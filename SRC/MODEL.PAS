unit model;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, Buttons, ExtCtrls , generate ,Math;

const
 PI = 3.1415926536;
 MAXNODE = 4000;    //  节点:4000;  单元:25000
 MAXELE = 25000;

type
 pornd=^knd;
 poele=^kele;

 kele=record     //  chain unit of element
  lf,rt:integer;  //  left,right node's xuhao of element
  lfp,rtp:pornd;  //  point to node
  sel:byte;     //  if selected
  next:poele;
 end;

 knd=record      // chain unit of node
  x,y,z:single;   // true ordinate of node
  scx,scy:integer;  // x,y on screen
  xh:integer;     //  No. of model_node
    // if read from txt or dxf xh is sequence of data
    // if get from Tspg xh is node number
    // in model mode xh never changed
  sel:byte;      //  if selected
  next:pornd;
 end;

Tmodel=class
  headnd:pornd;        //  head pointer of node chain
  headele:poele;       //  head pointer of element chain
  middx,middy,middz:single;
  wkn1,wkn2:pornd;
  wke1,wke2:poele;
  ndnum,ndcur,elnum,elcur:integer; // total node ,current node
                                   // total element ,current element
private
public
  constructor init;

  function addnd(new1:pornd):integer;
  function delend:integer;
  function insnd(new1:pornd;pos:integer):integer;
  function ifndexist(var new1:pornd):integer;
  function schndbyxh(no:integer;var ndfound:pornd):byte;
  function addel(new1:poele):integer;
  function deleel:integer;
  function deleelbynode(xx:integer):integer;
  procedure selnd(fig:byte);
  function insel(new1:poele;pos:integer):integer;
  function schel(new1:poele):integer;
  procedure clear_sel;
    //  next is modify model fun or proc
  function onenodesel(var xx,yy,zz:single):byte;
  procedure createnodeone(x1,y1,z1:single);
  procedure createnodes(dx,dy,dz:single);
  procedure movenodeone(x1,y1,z1:single;doa:byte);
  procedure movenodes(dx,dy,dz:single);
  procedure rotnode(deg:single;cpy,rotaxis:byte;p1,p2:single);
  procedure link2node;
  procedure copyele(dx,dy,dz:single);

    //  next proc & fun is with screen show ,file
  function nodeinrect(x1,y1,x2,y2:integer):byte;
  function eleinrect(x1,y1,x2,y2:integer):byte;
  function readtxt(filename:string):byte;
  function readdxf(filename:string):byte;
  procedure dxf2txt(filename:string);
  procedure txt2dxf;
  procedure calscxy;      //  calcuate the xy in screen
  procedure modelmov(x1,y1,x2,y2:integer);
  procedure modelrot(x1,y1,x2,y2:integer);
  procedure modelpan(x1,y1,x2,y2:integer);
  procedure drawmodel;   // draw the model specified by wgm
  procedure checkdup;    // check if node or element duplicated
  procedure savetodat;
end;

var
  wgm:Tmodel;
implementation
uses main;

constructor Tmodel.init;
begin
   new(headnd);
   headnd^.next:=nil;
   headnd^.xh:=0;     //  here initial xh
   new(headele);
   headele^.next:=nil;
   ndnum:=0;   ndcur:=0;
   elnum:=0;   elcur:=0;
end;

procedure Tmodel.calscxy;
var              //  计算屏幕坐标
 ax,ay:single;
 xc,yc,zc:single;
begin
 wkn1:=headnd;
  while(wkn1^.next<>nil)do
    begin
      wkn1:=wkn1^.next;
      xc:= wkn1^.x-middx;
      yc:= wkn1^.y-middy;
      zc:= wkn1^.z-middz;
      ax:=xc*msht[1,1]+yc*msht[2,1]+zc*msht[3,1];
      ay:=xc*msht[1,2]+yc*msht[2,2]+zc*msht[3,2];
      wkn1^.scx:=round(ax*scale+basex);
      wkn1^.scy:=mainform.ClientHeight - round(ay*scale+basey);
    end;
end;

procedure Tmodel.modelmov(x1,y1,x2,y2:integer);
begin
  basex:=basex+x2-x1;
  basey:=basey-y2+y1;
  mainform.cleansc;
  drawmodel;
end;

procedure Tmodel.modelrot(x1,y1,x2,y2:integer);
var                 //  rotate in space
  dx,dy:integer;
  theta:single;
begin
  dx:=x2-x1;
  dy:=y2-y1;
  if dx=0 then theta:=PI/2
  else
    theta:=arctan(abs(dy/dx));
  if theta>=PI/3 then      //  >= 60
    begin
      jx:=jx-0.125*dy*PI/180;
      mainform.cleansc;
      drawmodel;
    end
  else if theta<=PI/6 then     //  <= 30
    begin
      jz:=jz+0.125*dx*PI/180;
      mainform.cleansc;
      drawmodel;
    end;
end;

procedure Tmodel.modelpan(x1,y1,x2,y2:integer);
var        // 窗口放大
  dx,dy:single;
  a,a1,a2:single;
begin

  a:=1;
  a1:=mainform.ClientWidth/abs(x1-x2);
  a2:=mainform.ClientHeight/abs(y1-y2);
  if (a1>a2) and (a2<10) then
    a:=a2
  else if (a1<10) then
    a:=a1
  else
    showmessage('比例改变过大，请分多次完成!');

  basex:=(basex-x1)*a;
  basey:=mainform.ClientHeight-(mainform.ClientHeight-basey-y1)*a;
  scale:=a*scale;
  mainform.cleansc;
  drawmodel;
end;

procedure Tmodel.drawmodel;
begin
  mainform.makmsht;       //  生成投影转换矩阵
  mainform.draword;       //  draw the ordinate xyz
  calscxy;          //  calculate the node ordinate in screen
  with mainform.canvas.pen do
   begin
    width:=1;
    style:=pssolid;
    color:=clred;
   end;
  wke1:=headele;
  while(wke1^.next<>nil) do
    begin
     wke1:=wke1^.next;
     //  !!! changed by  lfp,rtp
        with mainform.Canvas do
         begin
         if wke1^.sel=1 then
          begin
            pen.style:=psdot;
            pen.color:=clred;
          end
         else
          begin
            pen.style:=pssolid;
            pen.color:=clred;
          end;
          moveto(wke1^.lfp^.scx,wke1^.lfp^.scy);
          lineto(wke1^.rtp^.scx,wke1^.rtp^.scy);
         end;

    end;
  mainform.Canvas.pen.style:=pssolid;
  wkn1:=headnd;
   while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then    //   selected
      with mainform.Canvas do
        begin
          pen.color:=clwhite;
          rectangle(wkn1^.scx-2,wkn1^.scy-2,wkn1^.scx+2,wkn1^.scy+2);
        end

     else         //  not selected
      with mainform.Canvas do
        begin
         pen.color:=clsilver;
         moveto(wkn1^.scx-3,wkn1^.scy);
         lineto(wkn1^.scx+4,wkn1^.scy);
         moveto(wkn1^.scx,wkn1^.scy-3);
         lineto(wkn1^.scx,wkn1^.scy+4);
        end;

    end;   //  end of while
end;

function Tmodel.addnd(new1:pornd):integer;    //  add node
var
 ct:integer;
 ww1:pornd;
 begin
  ww1:=headnd;    //  find last node in chain
   while(ww1^.next<>nil)do  ww1:=ww1^.next;
  ct:=ww1^.xh+1;     //  last xh +1 , if first headnd^.xh:=0;

  new1^.xh:=ct;
  ww1:=headnd;
   while(ww1^.next<>nil)do ww1:=ww1^.next;
  ww1^.next:=new1;
  ndnum:=ndnum+1;
  result:=ct;
 end;

  function Tmodel.delend:integer;   //  delete selected nodes
  var
    i,xx1:integer;
   begin
    wkn1:=headnd;
    while(wkn1^.next<>nil)do
     begin
      if wkn1^.next^.sel=1 then
        begin
         wkn2:=wkn1^.next;
         xx1:=wkn2^.xh;
         wkn1^.next:=wkn1^.next^.next;
         dispose(wkn2);
         deleelbynode(xx1);    // add !!!
         ndnum:=ndnum-1;
        end
      else
        wkn1:=wkn1^.next;
     end;   // end of while
    result:=ndnum;
   end;

  function Tmodel.insnd(new1:pornd;pos:integer):integer;  //  insert node
  var
    i:integer;
    wwn:pornd;
   begin      //  function not used
    wwn:=headnd;
    for i:=1 to pos do
      wwn:=wwn^.next;
    new1^.next:=wwn^.next;
    wwn^.next:=new1;
    ndnum:=ndnum+1;
    result:=ndnum;
   end;

  function Tmodel.schndbyxh(no:integer;var ndfound:pornd):byte;
  var
    fg:byte;
    wwn:pornd;
  begin
   wwn:=headnd;
   fg:=0;
    while(wwn^.next<>nil) do
      begin
        wwn:=wwn^.next;
        if wwn^.xh=no then
         begin
           fg:=1; ndfound:=wwn; break;
         end;
      end;
   if fg=1 then
    result:=1      //  have found
   else result:=0;   //  not found
  end;

  procedure Tmodel.clear_sel;
  var
    wa1:pornd;
    ws1:poele;
  begin
    wa1:=headnd;
    while(wa1^.next<>nil)do
     begin
      wa1:=wa1^.next;
      wa1^.sel:=0;
     end;
    ws1:=headele;
    while(ws1^.next<>nil)do
     begin
      ws1:=ws1^.next;
      ws1^.sel:=0;
     end;
  end;

  function Tmodel.ifndexist(var new1:pornd):integer;
  var
    fg:byte;
    i:integer;
    ww1,tmpnd:pornd;
  begin                         //  to check such node if exist
    ww1:=headnd;  i:=0;   fg:=0;
    while(ww1^.next<>nil)do
     begin
      ww1:=ww1^.next;
      i:=ww1^.xh;
      if (abs(ww1^.x-new1^.x)<1e-3) and
         (abs(ww1^.y-new1^.y)<1e-3) and
         (abs(ww1^.z-new1^.z)<1e-3) then
        begin
         fg:=1;
         tmpnd:=new1;
         dispose(tmpnd);
         new1:=ww1;
         break;
        end;
     end;
    if (fg=1) then result:=i          //  found
    else result:=-1;             //  not found!

  end;

  function Tmodel.schel(new1:poele):integer;
  var
    i:integer;
  begin
    i:=0;
    result:=i;
  end;

  function Tmodel.addel(new1:poele):integer;   //  add element
  var
    i:integer;
   begin
   wke1:=headele;
    while(wke1^.next<>nil)do wke1:=wke1^.next;
     wke1^.next:=new1;
     elnum:=elnum+1;
     result:=elnum;
   end;

  function Tmodel.deleel:integer;  //  delete selected element
  var
   i:integer;
   begin
    wke1:=headele;
    while (wke1^.next<>nil)do
      if wke1^.next^.sel=1 then
        begin
         wke2:=wke1^.next;
         wke1^.next:=wke1^.next^.next;
         dispose(wke2);
         elnum:=elnum-1;
        end
      else wke1:=wke1^.next;
    result:=elnum;
   end;

  function Tmodel.deleelbynode(xx:integer):integer;  //  delete element due to node
  var
   i:integer;
   begin
    wke1:=headele;
    while (wke1^.next<>nil)do
      if (wke1^.next^.lf=xx) or (wke1^.next^.rt=xx) then
        begin
         wke2:=wke1^.next;
         wke1^.next:=wke1^.next^.next;
         dispose(wke2);
         elnum:=elnum-1;
        end
      else wke1:=wke1^.next;
    result:=elnum;
   end;

  function Tmodel.insel(new1:poele;pos:integer):integer;   //  insert element
  var
    i:integer;
   begin
    wke1:=headele;
    for i:=1 to pos do
      wke1:=wke1^.next;
    new1^.next:=wke1^.next;
    wke1^.next:=new1;
    elnum:=elnum+1;
    result:=elnum;
   end;

function Tmodel.onenodesel(var xx,yy,zz:single):byte;  //  if only select one node
var
 cca:byte;
begin
 wkn1:=headnd;
 cca:=0;
  while(wkn1^.next<>nil) do
   begin
    wkn1:=wkn1^.next;
    if wkn1^.sel=1 then
     begin
      cca:=1;
      xx:=wkn1^.x;
      yy:=wkn1^.y;
      zz:=wkn1^.z;
      break;
     end;
    end;
  while(wkn1^.next<>nil) do
   begin
    wkn1:=wkn1^.next;
    if wkn1^.sel=1 then
     begin
      cca:=2;
      break;
     end;
   end;
  result:=cca;
end;

procedure Tmodel.createnodeone(x1,y1,z1:single);
var
  knd:pornd;
begin
  new(knd);
  knd^.x:=x1;  knd^.y:=y1; knd^.z:=z1;
  knd^.sel:=0;  knd^.next:=nil;
  addnd(knd);
end;

procedure Tmodel.createnodes(dx,dy,dz:single);
var
 knd:pornd;
begin
   wkn1:=headnd;
   while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then
      begin
       new(knd);
       knd^.x:=wkn1^.x+dx;
       knd^.y:=wkn1^.y+dy;
       knd^.z:=wkn1^.z+dz;
       knd^.sel:=0;
       knd^.next:=nil;
       addnd(knd);
       wkn1^.sel:=0;
      end;
    end;
end;

procedure Tmodel.movenodeone(x1,y1,z1:single;doa:byte);
begin
 wkn1:=headnd;
   while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then
      begin
       if doa=1 then //   absolute
        begin
          wkn1^.x:=x1;
          wkn1^.y:=y1;
          wkn1^.z:=z1;
          wkn1^.sel:=0;
        end
       else if doa=0 then   //relative
        begin
         wkn1^.x:=wkn1^.x+x1;
         wkn1^.y:=wkn1^.y+y1;
         wkn1^.z:=wkn1^.z+z1;
         wkn1^.sel:=0;
        end;
       break;
      end;     //  end of sel=1
    end;  //  end of  while
end;

procedure Tmodel.movenodes(dx,dy,dz:single);
begin
 wkn1:=headnd;
   while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then
      begin
       wkn1^.x:=wkn1^.x+dx;
       wkn1^.y:=wkn1^.y+dy;
       wkn1^.z:=wkn1^.z+dz;
       wkn1^.sel:=0;
      end;     //  end of sel=1
    end;  //  end of  while
end;

procedure Tmodel.rotnode(deg:single;cpy,rotaxis:byte;p1,p2:single);
var
  wnn,knd:pornd;
  d1,d2,s,jd:single;
  i:integer;
begin
  wnn:=headnd;
   while(wnn^.next<>nil) do
    begin
     wnn:=wnn^.next;
     if wnn^.sel=1 then     // 处理所有选中的节点
      begin
       if (rotaxis=1) then  //  rot by X
         begin
          d1:= wnn^.y-p1;   //  p1 as y
          d2:= wnn^.z-p2;   //  p2 as z
          s:=sqrt(d1*d1+d2*d2);
          jd:=arcsin(d2/s);
          wnn^.sel:=0;
          if (cpy=0) then
           begin
            jd:=jd+deg*PI/180;
            wnn^.y:=p1+s*cos(jd);
            wnn^.z:=p2+s*sin(jd);
           end
          else
           begin
            for i:=1 to cpy do
              begin
               jd:=jd+deg*PI/180;
                new(knd);
                 knd^.x:=wnn^.x;
                 knd^.y:=p1+s*cos(jd);
                 knd^.z:=p2+s*sin(jd);
                 knd^.sel:=0;
                 knd^.next:=nil;
                 addnd(knd);
              end;
           end;

         end
       else if (rotaxis=2) then // rot by y
         begin
          d1:= wnn^.z-p1;   //  p1 as z
          d2:= wnn^.x-p2;   //  p2 as x
          s:=sqrt(d1*d1+d2*d2);
          jd:=arcsin(d2/s);
          wnn^.sel:=0;
          if (cpy=0) then
           begin
            jd:=jd+deg*PI/180;
            wnn^.z:=p1+s*cos(jd);
            wnn^.x:=p2+s*sin(jd);
           end
          else
           begin
            for i:=1 to cpy do
              begin
               jd:=jd+deg*PI/180;
                new(knd);
                 knd^.y:=wnn^.y;
                 knd^.z:=p1+s*cos(jd);
                 knd^.x:=p2+s*sin(jd);
                 knd^.sel:=0;
                 knd^.next:=nil;
                 addnd(knd);
              end;
           end;


         end
       else if (rotaxis=3) then  //rot by z
         begin
           d1:= wnn^.x-p1;   //  p1 as x
          d2:= wnn^.y-p2;   //  p2 as y
          s:=sqrt(d1*d1+d2*d2);
          jd:=arcsin(d2/s);
          wnn^.sel:=0;
          if (cpy=0) then
           begin
            jd:=jd+deg*PI/180;
            wnn^.x:=p1+s*cos(jd);
            wnn^.y:=p2+s*sin(jd);
           end
          else
           begin
            for i:=1 to cpy do
              begin
               jd:=jd+deg*PI/180;
                new(knd);
                 knd^.z:=wnn^.z;
                 knd^.x:=p1+s*cos(jd);
                 knd^.y:=p2+s*sin(jd);
                 knd^.sel:=0;
                 knd^.next:=nil;
                 addnd(knd);
              end;
           end;

         end;    //  end of rotaxis
       end;    // end of if sel =1
     end;     //  end of while
  checkdup;
end;

function Tmodel.nodeinrect(x1,y1,x2,y2:integer):byte;
var
  tmp:integer;
  drct:byte;        //   正选选中,反选取消
begin
  drct:=0;
  if x2<x1 then     //  x1,y1 should less than x2,y2
    begin
      tmp:=x2; x2:=x1;  x1:=tmp;
      drct:=1;
    end;
  if y2<y1 then
    begin
      tmp:=y2; y2:=y1; y1:=tmp;
    end;
  tmp:=0;
  wkn1:=headnd;
  while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
    if (wkn1^.scx>=x1) and (wkn1^.scx<=x2) and
      (wkn1^.scy>=y1) and (wkn1^.scy<=y2) then
     begin
       if drct=1 then wkn1^.sel:=0     //  反选
       else  wkn1^.sel:=1;             //  正选
       tmp:=1;
     end

   end;  //end of while
  result:=tmp;
end;

function Tmodel.eleinrect(x1,y1,x2,y2:integer):byte;
var
  wee: poele;
  wnn: pornd;
  tmp: integer;
  drct: byte;   //   正选选中,反选取消
begin
  drct:=0;
  if x2<x1 then     //  x1,y1 should less than x2,y2
    begin
      tmp:=x2; x2:=x1;  x1:=tmp;
      drct:=1;    //  正
    end;
  if y2<y1 then
    begin
      tmp:=y2; y2:=y1; y1:=tmp;
    end;

  tmp:=0;
  wee:= headele;

  while(wee^.next<>nil) do
    begin
    wee:=wee^.next;
      if (wee^.lfp^.scx>=x1) and (wee^.lfp^.scx<=x2) then
       if (wee^.rtp^.scx>=x1) and (wee^.rtp^.scx<=x2) then
        if (wee^.lfp^.scy>=y1) and (wee^.lfp^.scy<=y2) then
         if (wee^.rtp^.scy>=y1) and (wee^.rtp^.scy<=y2) then
          begin
           if drct=0 then wee^.sel:=1
           else wee^.sel:=0;
           tmp:=1;
          end;
    end;
  result:=tmp;
end;

procedure Tmodel.link2node;
var
  cc:byte;
  kk:poele;
begin
  cc:=0;
  new(kk);
  kk^.next:=nil;
  kk^.sel:=0;
  wkn1:=headnd;
  while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then
      begin
       kk^.lf:=wkn1^.xh;
       kk^.lfp:=wkn1;  //  add !!!!
       cc:=1;
       break;
      end;
    end;
  while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     if wkn1^.sel=1 then
      begin
       kk^.rt:=wkn1^.xh;
       kk^.rtp:=wkn1;   //  add !!!!
       cc:=2;
       break;
      end;
    end;
  if cc=2 then addel(kk)   //  add new line in chain
  else dispose(kk);
 selnd(0); // select none node
end;

procedure Tmodel.copyele(dx,dy,dz:single);   //   copy some element
var
  newele,we:poele;
  newnd1,newnd2,wn:pornd;
  a1,a2:integer;
begin
  we:=headele;
  while(we^.next<>nil) do
    begin
     we:=we^.next;
     if (we^.sel=1) then
       begin
         new(newnd1); new(newnd2);
         newnd1^.x:=we^.lfp^.x+dx;   newnd2^.x:=we^.rtp^.x+dx;
         newnd1^.y:=we^.lfp^.y+dy;   newnd2^.y:=we^.rtp^.y+dy;
         newnd1^.z:=we^.lfp^.z+dz;   newnd2^.z:=we^.rtp^.z+dz;
         newnd1^.sel:=0; newnd2^.sel:=0;
         newnd1^.next:=nil; newnd2^.next:=nil;

         a1:=ifndexist(newnd1);    // if a1>=0 means have found
         if a1<0 then       // a new node
           a1:=addnd(newnd1);
         a2:=ifndexist(newnd2);
         if a2<0 then
           a2:=addnd(newnd2);
         new(newele);
         newele^.lf:=a1;    newele^.rt:=a2;
         newele^.lfp:=newnd1;   newele^.rtp:=newnd2;
         newele^.sel:=0;
         newele^.next:=nil;
         addel(newele);
       end;
    end;
  checkdup;
end;

procedure Tmodel.selnd(fig:byte);
begin  //   fig=1 select all; fig=0 select none
  wkn1:=headnd;
  while(wkn1^.next<>nil) do
    begin
     wkn1:=wkn1^.next;
     wkn1^.sel:=fig;
    end;
end;

function Tmodel.readtxt(filename:string):byte;
var
 f:textfile;
 str:string;
 newnode,wkn1:pornd;
 bar:poele;
 nod:array [1..MAXNODE] of pornd;
 np1,ne1,i,ia,lf,rt:integer;
 tmp,xtmp,ytmp,ztmp,maxx,maxy,maxz,minx,miny,minz:single;
begin
  assignfile(f,filename);
  reset(f);

   maxx:=-1e8; maxy:=-1e8; maxz:=-1e8;
   minx:=1e8;  miny:=1e8;  minz:=1e8;
   tmp:=0;

   readln(f,str);
   if strpos(pchar(str),'np')=nil then
     begin
      closefile(f);
      exit;
     end;
   readln(f,np1,ne1);

   while strpos(pchar(str),'x')=nil do
     readln(f,str);
   for i:=1 to np1 do        //  read node coordinate
    begin
     readln(f,xtmp,ytmp,ztmp);
     new(newnode);
     newnode^.x:=xtmp;      newnode^.y:=ytmp;      newnode^.z:=ztmp;
     newnode^.sel:=0;     newnode^.next:=nil;
     ia:=addnd(newnode);
     nod[i]:=newnode;
    end;

   while strpos(pchar(str),'left')=nil do
     readln(f,str);
   for i:=1 to ne1 do        //  read element node number
    begin
     readln(f,lf,rt);
     new(bar);
     bar^.lf:=lf;  bar^.rt:=rt;
     bar^.lfp:=nod[lf];  bar^.rtp:=nod[rt];      //  add !!!
     bar^.sel:=0;  bar^.next:=nil;
     addel(bar);
    end;
  closefile(f);

  wkn1:=headnd;
   while(wkn1^.next<>nil) do
     begin
      wkn1:=wkn1^.next;
      if maxx<wkn1^.x then maxx:=wkn1^.x;
      if maxy<wkn1^.y then maxy:=wkn1^.y;
      if maxz<wkn1^.z then maxz:=wkn1^.z;
      if minx>wkn1^.x then minx:=wkn1^.x;
      if miny>wkn1^.y then miny:=wkn1^.y;
      if minz>wkn1^.z then minz:=wkn1^.z;
     end;

    middx:=(maxx+minx)/2;
    middy:=(maxy+miny)/2;
    middz:=(maxz+minz)/2;

    tmp:=maxx-minx;
     if tmp<(maxy-miny) then tmp:=maxy-miny;
     if tmp<(maxz-minz) then tmp:=maxz-minz;
     scale0:=500/tmp;
     tmp:=(maxx-minx)/(maxy-miny);    //  modify
     if tmp>1 then tmp := 1 / tmp;
     if tmp > 0.8 then scale0:=scale0 / 1.2
     else if tmp <0.4 then scale0:=scale0 * 1.2;
     scale:=scale0;
    result:=1;
end;

function Tmodel.readdxf(filename:string):byte;
  var
    f:textfile;
    str:string;
    a,i,lf,rt,temp1,temp2:integer;
    frt,lst:pornd;
    bar:poele;
    axyz:array [1..6] of single;
    xtmp,ytmp,ztmp:single;
    tmp,maxx,maxy,maxz,minx,miny,minz:single;
  begin
    assignfile(f,filename);
    reset(f);

    maxx:=-1e8; maxy:=-1e8; maxz:=-1e8;
    minx:=1e8; miny:=1e8; minz:=1e8;
    temp1:=0;

    readln(f,str);
  while (str<>'EOF') do
    begin
    readln(f,str);
    if (str='LINE') then     // flag next is data
     begin
      readln(f,str);
      temp1:=0;
      temp2:=0;
      while (str<>' 10') do
        begin
         readln(f,str); //  next is xyz
         inc(temp2);
         if (temp2>100) then
          begin
           closefile(f);
           result:=0;
           exit;
          end;
        end;
      for i:=1 to 6 do
       begin
        readln(f,axyz[i]);
        readln(f,str);
       end;
       new(frt); new(lst);
       frt^.x:=axyz[1]; frt^.y:=axyz[2]; frt^.z:=axyz[3];
       frt^.sel:=0;  frt^.next:=nil;
       lst^.x:=axyz[4]; lst^.y:=axyz[5]; lst^.z:=axyz[6];
       lst^.sel:=0;  lst^.next:=nil;

       a:=ifndexist(frt);     //  back -1 or exist xh
        if a<0 then       // a new node
          lf:=addnd(frt)
        else
          lf:=a;       // node have been in chain

       a:=ifndexist(lst);
        if a<0 then
          rt:=addnd(lst)
        else
          rt:=a;

       new(bar);
       bar^.lf:=lf;  bar^.rt:=rt;
       bar^.lfp:=frt;  bar^.rtp:=lst;      //  add !!!
       bar^.sel:=0;  bar^.next:=nil;
       addel(bar);
      end         // end of if
    else
      begin
        inc(temp1);
        if (temp1>30000) then
         begin
           closefile(f);
           result:=0;
           exit;
         end;
      end;
   end;          //  end of while

   closefile(f);

   wkn1:=headnd;
    while(wkn1^.next<>nil) do
     begin
      wkn1:=wkn1^.next;
      if maxx<wkn1^.x then maxx:=wkn1^.x;
      if maxy<wkn1^.y then maxy:=wkn1^.y;
      if maxz<wkn1^.z then maxz:=wkn1^.z;
      if minx>wkn1^.x then minx:=wkn1^.x;
      if miny>wkn1^.y then miny:=wkn1^.y;
      if minz>wkn1^.z then minz:=wkn1^.z;
     end;
    middx:=(maxx+minx)/2;
    middy:=(maxy+miny)/2;
    middz:=(maxz+minz)/2;

     tmp:=maxx-minx;
     if tmp<(maxy-miny) then tmp:=maxy-miny;
     if tmp<(maxz-minz) then tmp:=maxz-minz;
     scale0:=500/tmp;
     tmp:=(maxx-minx)/(maxy-miny);    //  modify
     if tmp>1 then tmp := 1 / tmp;
     if tmp > 0.8 then scale0:=scale0 / 1.2
     else if tmp <0.4 then scale0:=scale0 * 1.2;
     scale:=scale0;
     result:=1;
  end;

  procedure Tmodel.dxf2txt(filename:string);
  var
    f:textfile;
  begin
    checkdup;
    assignfile(f,filename);
    rewrite(f);
    writeln(f,'    np    ne');
    writeln(f,ndnum:6,elnum:6);
    writeln(f,'');
    writeln(f,'       x         y         z');
    wkn1:=headnd;
    while(wkn1^.next<>nil) do
     begin
      wkn1:=wkn1^.next;
      writeln(f,wkn1^.x:10:2,wkn1^.y:10:2,wkn1^.z:10:2);
     end;
    writeln(f,'');
    writeln(f,'     left      right');
    wke1:=headele;
    while(wke1^.next<>nil) do
     begin
      wke1:=wke1^.next;
      writeln(f,'   ',wke1^.lf:7,wke1^.rt:7);
     end;
    closefile(f);
  end;

  procedure Tmodel.txt2dxf;
  begin

  end;

  procedure Tmodel.checkdup;
  var            //   check duplicate node
    i:integer;
    ww,ww1:pornd;
    we,we1:poele;
  begin
     //  delete surplus element link to node which not exist
    we:=headele;
    while (we^.next<>nil) do
     begin
      if (schndbyxh(we^.next^.lf,ww1)=0) or
         (schndbyxh(we^.next^.rt,ww1)=0) then
       begin
        we1:=we^.next;
        we^.next:=we^.next^.next;
        dispose(we1);
        elnum:=elnum-1;
       end
      else  we:=we^.next;
     end;

    wkn1:=headnd^.next;      //   delete surplus node in chain
     while(wkn1^.next<>nil) do
      begin
       wkn2:=wkn1;
       while (wkn2^.next<>nil) do     // 检查位置重合的点
         begin
          if (abs(wkn1^.x-wkn2^.next^.x)<1e-2) and
             (abs(wkn1^.y-wkn2^.next^.y)<1e-2) and
             (abs(wkn1^.z-wkn2^.next^.z)<1e-2) then
           begin
            //  i:=wkn2^.xh;
            wke1:=headele;   //  repoint element relative to the surplus node
            while(wke1^.next<>nil)  do
             begin
              if (wke1^.next^.lfp=wkn2^.next) then
               begin
                wke1^.next^.lfp:=wkn1;
                wke1^.next^.lf:=wkn1^.xh;
               end
              else if (wke1^.next^.rtp=wkn2^.next) then
               begin
                wke1^.next^.rtp:=wkn1;
                wke1^.next^.rt:=wkn1^.xh;
               end;
              wke1:=wke1^.next;
             end;

            ww:=wkn2^.next;      //  delete wkn2^.next
            wkn2^.next:=wkn2^.next^.next;
            dispose(ww);
            ndnum:=ndnum-1;
          end;

          wkn2:=wkn2^.next;
          if (wkn2=nil) then break;
         end;             //  inter while  wkn2
       wkn1:=wkn1^.next;
         if (wkn1=nil) then break;
      end;              //  outer while  wkn1

    wke1:=headele;      //  delete surplus element

    while(wke1^.next<>nil)  do
     begin
      wke2:=wke1;
      while (wke2^.next<>nil) do
       begin

        if ((wke1^.lfp=wke2^.next^.lfp) and (wke1^.rtp=wke2^.next^.rtp)) or
           ((wke1^.lfp=wke2^.next^.rtp) and (wke1^.rtp=wke2^.next^.lfp)) then
          begin
            we:=wke2^.next;
            wke2^.next:=wke2^.next^.next;    //  delete    wke2^.next
            dispose(we);
            elnum:=elnum-1;
          end;
          wke2:=wke2^.next;
          if (wke2=nil) then break;
        end;  //  inner while wke2
        wke1:=wke1^.next;
          if (wke1=nil) then break;
      end;      //  outer while wke1
   end;

procedure Tmodel.savetodat;
var
  fi:textfile;
  nm:string;
  ndc,elc:integer;
  a:array[1..7000] of integer;  //  max node 7000
begin
  if mainform.savedialog1.execute then
    begin
     nm:=mainform.savedialog1.filename+'.dat';
     assignfile(fi,nm);
     rewrite(fi);
     checkdup;
     ndc:=0;
     wkn1:=headnd;       //   count total node number
     while(wkn1^.next<>nil) do
      begin
       wkn1:=wkn1^.next;
       inc(ndc); 
       a[wkn1^.xh]:=ndc;
      end;
     elc:=0;
     wke1:=headele;     //   count total element number
     while(wke1^.next<>nil) do
      begin
       wke1:=wke1^.next;
       inc(elc);
      end;
     writeln(fi,'      np       ne');
     writeln(fi,ndc:8,elc:9);
     writeln(fi,'');
     writeln(fi,'         x         y         z');
     wkn1:=headnd;       //   count total node number
     while(wkn1^.next<>nil) do
      begin
       wkn1:=wkn1^.next;
       writeln(fi,wkn1^.x:10:3,wkn1^.y:10:3,wkn1^.z:10:3);
      end;
     writeln(fi,'');
     writeln(fi,'    left      right');
     wke1:=headele;     //   count total element number
     while(wke1^.next<>nil) do
      begin
       wke1:=wke1^.next;
       writeln(fi,a[wke1^.lf]:7,a[wke1^.rt]:10);
      end;
     closefile(fi);
    end;  //  end of if
end;

end.

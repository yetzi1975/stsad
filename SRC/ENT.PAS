unit ent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, Buttons, ExtCtrls, Math ;

const
 PI = 3.1415926536;
 MAXNODE = 4000;    //  节点:4000;  单元:25000
 MAXELE = 25000;

type
ar3 = array [1..3] of single;
intarray = array [1..MAXNODE] of integer;
af = ^fchain;
pf = ^fk;

three=record
  x,y,z:single;
end;

fchain = array [1..MAXNODE] of three;

six=record
  x,y,z,Rx,Ry,Rz:single;
end;

fk = record
  kind:byte;     //  荷载种类(1x:恒; 2x:活; 3x:风; 4x:吊; 5x:震 )
  next:pf;
  header:af;
end;

Rnode = record        // 存储时用
  x,y,z:single;       //   实际坐标(米)
  dx,dy,dz:single;    //   位移值 ,沉降(米)
  scx,scy:integer;    //   屏幕显示坐标
  ys:integer;         //   约束情况
  sel:byte;           //   选中标记
  ang_cj:integer;     //
end;

Rbar = record            // 存储时用
   nf,nl:integer;        // 前、后节点号
   wt,force,len:single;  // 杆重(kN),内力(kN),长度(m)
   mat,sec,grp,red:byte;  //  材料号,截面号,组号,截面不足
   sel,chg,stc:byte;      //  选中标记,可调整标记,失稳曲线种类
   lmd,sigma: single;     //  长细比 ,应力(N/mm2)
end;

Tnode=class
  linknodes: Tlist;    //   与之相连的节点号
  linkelements: Tlist;  //   与之相连的杆件号
  x,y,z:single;       //   实际坐标(米)
  dx,dy,dz:single;    //   位移值 ,沉降(米)
  scx,scy:integer;    //   屏幕显示坐标
  ys:integer;         //   约束情况
  sel:byte;           //   选中标记
  ang_cj:integer;     //   斜边界的倾角(>10000:有沉降的节点)
                      // 10036 [down,36 deg] ;-21 [no down,-21 deg]
 private
 public
    constructor init;
    procedure calscxy(mtd:byte); //  mtd=0: origin; mtd=1: deformed
    procedure drawnode(color:Tcolor);
    procedure drawbear(color:Tcolor);
    function isinrect(x1,y1,x2,y2:integer):byte;
    function isnearpoint(x1,y1:integer):byte;
    function getysxyz(xz:byte):byte;

 end;

Tbar=class
    nf,nl:integer;        // 前、后节点号
    wt,force,len:single;  // 杆重(kN),内力(kN),长度(m)
    mat,sec,grp,red:byte;  //  材料号,截面号,组号,截面不足
    sel,chg,stc:byte;    //  选中标记,可调整标记,失稳曲线种类
    lmd,sigma: single;    //  长细比 ,应力(N/mm2)
     // grp => 127:(grp no.: 12; 均布参数:7)
  private
  public
    constructor init;
    procedure setlen;
    procedure drawbar(color:Tcolor; xx:integer);
    function isinrect(x1,y1,x2,y2:integer):byte;
    function isnearpoint(x1,y1:integer):byte;

  end;

  Tmat=class
    rwt,Es,fy:single;   // 比重(T/m3),弹模(MPa),设计强度(MPa)
    fq,alpha:single;    // 屈服强度(MPa),线胀系数(mm/c)
    name:string;
    color:Tcolor;
  private
  public
    constructor init;
    procedure getcolor(ind:integer);
    procedure lineinp(str1:string);
  end;

  Tsec=class
    area:single;    //   截面积(cm2)
    rodr2,rodr3:single;   //  回转半径(绕强/弱轴)cm
    Ita2,Ita3:single;     //  惯性矩(绕强/弱轴)cm4
    kind:byte;           //  分类
    name:string;
    color:Tcolor;
  private
  public
    constructor init;
    procedure getcolor(ind:integer);
    procedure ia2r;
    procedure lineinp(str1:string);
 end;

  Tusedsecmat=class
    mater: array[0..10] of Tmat;
    section: array[0..50] of Tsec;
    mno,sno: integer;
      //  材料类别数,截面类别数
  private
  public
    constructor init;
    function readcfg(fnm:string):byte;
    procedure writecfg(fnm:string);
    function addseckind(sec1:Tsec):integer;
    procedure addmatkind(mat1:Tmat);
    function getsecbase(kd:byte):integer;
    function getseckind(kd:byte;str:string='AAA'):string;
  end;

  Tspg = class
    ffn:string;           //  名称 (有目录无后缀)
    ne,np,nys:integer;   //  杆件数,节点数,约束节点数
    nic,nks,ies,ifs,ndes,iv:integer;
    //  斜边界数,弹簧数,材料数,截面数,不变截面数,节点位移数
    totalw,nodewt: single;   //  总重量估计值,节点重量
    elekind,mmax,ncc:byte;   //  结构单元,调整次数,结构自重控制系数
    rlm:integer;        //  允许长细比
    famp,damp:single;   //  力显示比例系数,位移显示比例系数
    smax,smin:single;    //  最大应力系数比,最小应力系数比
    ndforce:pf;            //  节点荷载(链表)
    spr:array[2..9] of single;     // 弹簧系数 N/mm
    comld:array[1..15,0..5] of single;  //  comld[1~14,1~5] 记录组合系数
                                       //  comld[1~14,0] 记录简化或一般组合
    bar:array[1..MAXELE] of Tbar;     //  杆件
    node:array[1..MAXNODE] of Tnode;    //  节点
    dtemp:integer;                //  温度增量
    midx,midy,midz:single;          //   网架的中心点
    curgrp,curfc,curldc:byte;        // 当前组号,荷载号,工况号
    bearforce:af;            //  支座反力
    subsecmat: Tusedsecmat;       //  材料截面子集
  private
  public
    constructor init(np1,ne1:integer);
    function readinfile_s(fname:string):byte;
    function write_s(fname:string):byte;
    function writeall(fname:string):byte;
    function readall(fname:string):byte;

    procedure setnodelink;     //  计算与各节点相连的节点
    function maxnodedist:integer;       //   计算半带宽
    procedure nodelinkopt;     //  优化节点号
    
    function getsprno(a:single):byte;
    procedure setload(var vbm:array of shortint);
    function addforce(jiyue:byte):pf;
    procedure delforce(jiyue:byte);
    procedure drawforce(prm:byte);       //  prm: display peremeter
    function forceexist(jiyue:byte):byte;

    procedure draw3dspt;
    procedure drawspt(xz:byte);
    procedure sptrot(x1,y1,x2,y2:integer);
    procedure sptmov(x1,y1,x2,y2:integer);
    procedure sptpan(x1,y1,x2,y2:integer);

    function updateforce(aa:byte;tf:three):byte;
    procedure calcudata;
    function PL_makgeofile(cz:byte):byte;    //  interface1 for Prof. Luo's program
    function PL_makloadfile(num:byte):byte;  //  interface2 for Prof. Luo's program
    procedure PL_readresult(lc:integer);     //  interface3 for Prof. Luo's program
    procedure PL_showsigma(choose:byte);     //  interface4 for Prof. Luo's program

end;



var
  spf: Tspg;

  curbv:array[1..10] of byte;   //  当前步骤
  curproc,lastproc: byte;  //  当前状态
  curdis: byte;    //   当前显示 0:no 1:material 2:sec 9:deform
  loadcase: byte;   //   工况号
implementation

uses main,ndinfo,barinfo;

function CompareLinksNum(Item1, Item2: Pointer): Integer;
begin   //  根据节点所连接节点的数量判断大小
  Result := CompareValue(spf.node[integer(Item1^)].linknodes.Count,
            spf.node[integer(Item2^)].linknodes.Count);
end;

// next is Tnode
constructor Tnode.init;
begin
  x:=0; y:=0; z:=0;
  dx:=0; dy:=0; dz:=0;
  scx:=0; scy:=0;
  ys:=0; sel:=0;
  ang_cj:=0;
end;

procedure Tnode.drawnode(color:Tcolor);
begin
  with mainform.canvas do
    begin
      pen.color:=color;
     //  rectangle(scx-2,scy-2,scx+2,scy+2);
      arc(scx-2,scy-2,scx+2,scy+2,scx-1,scy,scx-1,scy);
      // moveto(scx-2,scy);
      // lineto(scx,scy+2); lineto(scx+2,scy);
      // lineto(scx,scy-2); lineto(scx-2,scy);
    end;
end;

procedure Tnode.drawbear(color:Tcolor);
begin
 if ys<111 then
 with mainform.canvas do
  begin
    pen.style:=pssolid;
    pen.color:=color;
    moveto(scx-2,scy-4);
    lineto(scx-4,scy-2);  lineto(scx-4,scy+2);
    lineto(scx-2,scy+4);  lineto(scx+2,scy+4);
    lineto(scx+4,scy+2);  lineto(scx+4,scy-2);
    lineto(scx+2,scy-4);  lineto(scx-2,scy-4);
  end
 else if ys=111 then   //  all direction restrict
 with mainform.canvas do
  begin
    pen.style:=pssolid;
    pen.color:=color;
    moveto(scx,scy-8);
    lineto(scx-8,scy+4);
    lineto(scx+8,scy+4);
    lineto(scx,scy-8);
  end
 else    //  spring bound
 with mainform.canvas do
  begin
    pen.style:=pssolid;
    pen.color:=color;
    moveto(scx-4,scy-7);
    lineto(scx+4,scy-4);
    lineto(scx-4,scy-1);
    lineto(scx+4,scy+2);
    lineto(scx-4,scy+5);
  end;

if abs(ang_cj)>=10000 then     //  沉降
 with mainform.canvas do
  begin
    pen.style:=pssolid;
    pen.color:=color;
    moveto(scx-4,scy+6);
    lineto(scx+4,scy+6);
  end;
if (abs(ang_cj)-10000)>0 then   //  斜边界
  with mainform.canvas do
  begin
    pen.style:=pssolid;
    pen.color:=color;
    moveto(scx-3,scy);
    lineto(scx,scy-3);
    lineto(scx+3,scy);
    lineto(scx,scy+3);
  end;

end;

procedure Tnode.calscxy(mtd:byte); //  mtd=0: origin; mtd=1: deform
var
  xc,yc,zc,ax,ay:single;
begin
   xc:= x-spf.midx;
   yc:= y-spf.midy;
   zc:= z-spf.midz;

  if mtd<>0 then   //  deform
   begin
    xc:= xc+dx*spf.damp;
    yc:= yc+dy*spf.damp;
    zc:= zc+dz*spf.damp;
   end;
    ax:=xc*msht[1,1]+yc*msht[2,1]+zc*msht[3,1];
    ay:=xc*msht[1,2]+yc*msht[2,2]+zc*msht[3,2];
    scx:=round(ax*scale+basex);    //  四舍五入
    scy:=mainform.clientheight-round(ay*scale+basey);
end;

function Tnode.getysxyz(xz:byte):byte;
var
  aa:byte;
begin
  if xz=1 then aa:=trunc(ys/100)  //  X 向(取整)
  else if xz=2 then aa:=trunc((ys mod 100)/10) //  Y 向
  else if xz=3 then aa:=ys mod 10;  //  Z 向
  result:=aa;
end;

function Tnode.isnearpoint(x1,y1:integer):byte;
begin  // 一次选中,两次取消
 if (abs(scx-x1)<7) and (abs(scy-y1)<7) then
   begin
    if sel=0 then sel:=1
    else if sel=1 then sel:=0;
    result:=1;
   end
 else result:=0;
end;

function Tnode.isinrect(x1,y1,x2,y2:integer):byte;
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
  if (scx>=x1) and (scx<=x2) and (scy>=y1) and (scy<=y2) then
    begin
     if drct=1 then sel:=0     //  反选
     else  sel:=1;             //  正选
     result:=1;
     exit;
    end
  else  result:=0;

end;

// next is Tbar

constructor Tbar.init;
begin
 nf:=0; nl:=0;
 wt:=0; force:=0; len:=0;
 mat:=0; sec:=0; grp:=0;     //  all bar is in grp(0)
 sel:=0; chg:=1;  //  default is changeable section
 red:=0; stc:=0;  //  失稳曲线
 lmd:=0; sigma:=0;  
end;

procedure Tbar.setlen;   //   计算杆件长度
var
 dx2,dy2,dz2:single;
begin
  dx2:=(spf.node[nf].x-spf.node[nl].x);
  dx2:= dx2*dx2;
  dy2:=(spf.node[nf].y-spf.node[nl].y);
  dy2:= dy2*dy2;
  dz2:=(spf.node[nf].z-spf.node[nl].z);
  dz2:= dz2*dz2;
  len:=sqrt(dx2+dy2+dz2);
end;

procedure Tbar.drawbar(color:Tcolor; xx:integer);   //  画杆件
begin      //  xx is group
 with mainform.canvas do
  begin
   pen.Color:= color;
   pen.style:=pssolid;
   if (sel = 1) then        //  selected bar is displayed as dot
      pen.style:=psdot;
   if (xx<>grp) then
      pen.color:=clblack;    //  not selected grp not draw
   moveto(spf.node[nf].scx,spf.node[nf].scy);
   lineto(spf.node[nl].scx,spf.node[nl].scy);
  end;

  //  MoveToEx(mainform.canvas.Handle,spf.node[nf].scx,spf.node[nf].scy,nil);
  //   LineTo(mainform.canvas.Handle,spf.node[nl].scx,spf.node[nl].scy);

end;

function Tbar.isinrect(x1,y1,x2,y2:integer):byte;   //  框选杆件
var
  tmp:integer;
  drct:byte;   //   正选选中,反选取消
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
  if (spf.node[nf].scx>=x1) and (spf.node[nf].scx<=x2) then
    if (spf.node[nl].scx>=x1) and (spf.node[nl].scx<=x2) then
      if (spf.node[nf].scy>=y1) and (spf.node[nf].scy<=y2) then
        if (spf.node[nl].scy>=y1) and (spf.node[nl].scy<=y2) then
         begin
          if drct=0 then sel:=1
          else sel:=0;
          result:=1; exit;
         end;
  result:=0;
end;

function Tbar.isnearpoint(x1,y1:integer):byte;  //  点选杆件
var
  a,b,c,s,d:single;
  xs,ys,xb,yb:integer;
  tmp:byte;
begin              //  一次选中,两次取消
 tmp:=0;
 if (spf.node[nl].scx<spf.node[nf].scx) then
   begin
    xs:= spf.node[nl].scx-10;    xb:= spf.node[nf].scx+10;
   end
 else
   begin
    xs:= spf.node[nf].scx-10;    xb:= spf.node[nl].scx+10;
   end;
 if (spf.node[nl].scy<spf.node[nf].scy) then
   begin
    ys:= spf.node[nl].scy-10;    yb:= spf.node[nf].scy+10;
   end
 else
   begin
    ys:= spf.node[nf].scy-10;    yb:= spf.node[nl].scy+10;
   end;
 if (x1>xb) or (x1<xs) or (y1>yb) or (y1<ys) then
   begin
     result:=tmp;
     exit;
   end;
 b:= spf.node[nl].scx-spf.node[nf].scx;
 a:= spf.node[nf].scy-spf.node[nl].scy;
 c:= -a*spf.node[nf].scx-b*spf.node[nf].scy;

 s:=sqrt(a*a+b*b);
 d:=(a*x1+b*y1+c)/s;
 if abs(d)<5 then
   begin
    tmp:=1;
    sel:=1-sel;
   end;
 result:=tmp;  
end;

   // next is Tmat
constructor Tmat.init;
begin
  rwt:=0;
  Es:=0;   fy:=0;
  fq:=0;   alpha:=0;
  name:='未设置';
  color:=clgray;
end;

procedure Tmat.getcolor(ind:integer);
var
  a1,us1,cs1:integer;
begin
  ind:=ind mod c_clr1;
  us1:=ind mod 7; cs1:=trunc(ind/7);
  a1:= us1*trunc(c_clr1/7)+cs1+1;
  a1:= a1 mod c_clr1;
  color:=clr1[a1+1];
end;

procedure Tmat.lineinp(str1:string);
var
  ms1:Tstrings;
begin
  ms1:=Tstringlist.Create;
  ExtractStrings([' '],[' '],pchar(str1), ms1);
  name:=trim(ms1[0]);
  Es:=strtofloat(ms1[1]);
  fq:=strtofloat(ms1[2]);
  fy:=strtofloat(ms1[3]);
  rwt:=strtofloat(ms1[4]);
  alpha:=strtofloat(ms1[5]);
  ms1.Free;
end;

   // next is Tsec
constructor Tsec.init;
begin
  area:=0;
  rodr2:=0;  rodr3:=0;
  Ita2:=0;   Ita3:=0;
  kind:=0;
  name:='未设置';
  color:=clgray;
end;

procedure Tsec.ia2r;
begin
  if rodr2=0 then
    rodr2:=sqrt(ita2/area);
  if rodr3=0 then
    rodr3:=sqrt(ita3/area);
end;

procedure Tsec.getcolor(ind:integer);
var
  a1,us1,cs1:integer;
begin
  ind:=ind mod c_clr1;
  us1:=ind mod 11; cs1:=trunc(ind/11);
  a1:= us1*trunc(c_clr1/11)+cs1+1;
  a1:= a1 mod c_clr1;
  color:=clr1[a1+1];
end;

procedure Tsec.lineinp(str1:string);
var
  ms1:Tstrings;
begin
  ms1:=Tstringlist.Create;
  ExtractStrings([' '],[' '],pchar(str1), ms1);
  name:=trim(ms1[0]);
  area:=strtofloat(ms1[1]);
  ita2:=strtofloat(ms1[2]);
  ita3:=strtofloat(ms1[3]);
  ia2r;
  ms1.Free;
end;
// next is Tspg

constructor Tspg.init(np1,ne1:integer);
var
  i,j:integer;
begin
  np:=np1;  ne:=ne1;
  famp:=10.0;  damp:=100.0;      // amplify factor initialized
  curgrp:=0; curfc:=0;  dtemp:=0;
  ndforce:=nil;
  for i:= 1 to np1 do        //  create  node objects
    node[i]:=Tnode.init;
  for i:= 1 to ne1 do        //   create bar objects
    bar[i]:=Tbar.init;
  for i:=1 to 9 do
    spr[i]:=0;
  for i:=1 to 15 do
   for j:= 0 to 5 do
     comld[i,j]:=-1;
  subsecmat:=Tusedsecmat.init;
end;

function Tspg.readinfile_s(fname:string):byte;
var             // read simple file format
  f,f1:textfile;
  lnstr:string;
  i:integer;
  maxx,maxy,maxz,minx,miny,minz,tmp:single;
begin          // read infile get node &bar information
  assignfile(f, fname);
  reset(f);
  while strpos(pchar(lnstr),'x')=nil do
    readln(f,lnstr);
  for i:=1 to np do        //  read node coordinate
    readln(f,node[i].x,node[i].y,node[i].z);
  while strpos(pchar(lnstr),'left')=nil do
    readln(f,lnstr);
  for i:=1 to ne do        //  read element node number
    readln(f,bar[i].nf,bar[i].nl);
  closefile(f);

  setnodelink;    // 设置节点链
  
  maxx:=-1e8; maxy:=-1e8; maxz:=-1e8;
  minx:=1e8; miny:=1e8; minz:=1e8;

  for i:=1 to np do
   begin
    if maxx<node[i].x then maxx:=node[i].x;
    if maxy<node[i].y then maxy:=node[i].y;
    if maxz<node[i].z then maxz:=node[i].z;
    if minx>node[i].x then minx:=node[i].x;
    if miny>node[i].y then miny:=node[i].y;
    if minz>node[i].z then minz:=node[i].z;
   end;
  midx:=(maxx+minx)/2;
  midy:=(maxy+miny)/2;
  midz:=(maxz+minz)/2;
  tmp:=maxx-minx;
  if tmp<(maxy-miny) then tmp:=maxy-miny;
  if tmp<(maxz-minz) then tmp:=maxz-minz;
  scale0:=500/tmp;
  tmp:=(maxx-minx)/(maxy-miny);    //  modify
  if tmp>1 then tmp := 1 / tmp;
  if tmp > 0.8 then scale0:=scale0 / 1.2
  else if tmp <0.4 then scale0:=scale0 * 1.2;
  scale:=scale0;

  result:=0;
end;

procedure Tspg.setnodelink;   // 将与节点相连的节点号存入 linknodes,linkelements 
var
  i:integer;
  tmp1,tmp2,tmp3:^integer;
begin
  for i:=1 to np do
    begin
      node[i].linknodes := Tlist.Create;  // 创建一个List
      node[i].linkelements := Tlist.Create;
    end;
  for i:=1 to ne do
    begin
      New(tmp1);       New(tmp2);        New(tmp3);
      tmp1^:= bar[i].nl;     //  左节点
      tmp2^:= bar[i].nf;     //  右节点
      node[bar[i].nf].linknodes.Add(tmp1);
      node[bar[i].nl].linknodes.Add(tmp2);
      tmp3^:= i;          //  杆件号
      node[bar[i].nf].linkelements.Add(tmp3);
      node[bar[i].nl].linkelements.Add(tmp3);
    end;
end;

function Tspg.maxnodedist:integer; // 计算半带宽
var
  i,j,tmp,max:integer;
begin
  max := 0;
  for i:=1 to np do
     for j:=1 to node[i].linknodes.Count do
        begin      // Tlist.Items[i] 从0开始
           tmp := integer(node[i].linknodes.Items[j-1]^); 
           if abs(tmp-i)>max then
              max := abs(tmp-i);
        end;
  result := max;
end;

procedure Tspg.nodelinkopt;  // 优化节点编号
var
  iptmp,ptmp,processflag:^intarray;    //  下标为原节点编号
  Queue,tmplist:Tlist;   //  队列 , 临时表
  i,k,min,curnode,tmp:integer;
  ptp:^integer;
  str1:string;
  f1:textfile;
begin
  min := 10000;
  getmem(ptmp,sizeof(integer)*np);         // 存储节点的新编号
  getmem(processflag,sizeof(integer)*np);   // 处理标记

  for i:=1 to np do
    processflag[i]:=0;   // 对处理标记赋初值0

  Queue := Tlist.Create;  // 创建队列

  New(ptp);
  for i:= 1 to np do      //  找linknode数量最少的节点
    begin
      if min > node[i].linknodes.Count then
        begin
          min := node[i].linknodes.Count;
          ptp^ := i;
        end;
    end;
  Queue.add(ptp);

  ptmp[integer(Queue.First^)]:=1;  //  第一个进队列的编号为1
  processflag[integer(Queue.First^)]:=1;
  k:=2;
  while Queue.Count<>0 do     // 队列中的数量不为0
   begin
    curnode := integer(Queue.First^);    //  队列中的第一个

    // 将与当前节点相连的节点
    // 按其所连接的节点数量排序, 加入队列
    node[curnode].linknodes.Sort(@CompareLinksNum);
    str1:='';
    for i:=1 to node[curnode].linknodes.Count do
      begin
        // New(tmp);
        ptp := node[curnode].linknodes.Items[i-1];   // Tlist.Items[i] 从0开始
        tmp := integer(ptp^);
        if processflag[tmp]=0  then      // 尚未处理
          begin
            Queue.Add(ptp);               //  加入队列
            processflag[tmp]:=1;
            ptmp[tmp]:=k;      //  对其编号
            inc(k);
          end;
      end;
   //  已经处理过了
    Queue.Remove(Queue.First);         //  从队列中删掉当前的
   end;
   Queue.Free;
   // 显示出来
   str1 := '';
   {for i:= 1 to np do
        begin
            str1 := str1 + inttostr(i)+':'+inttostr(ptmp[i])+' ';
            if (i mod 10)=0 then str1 := str1 + #13;
        end;
   }

   freemem(processflag);

   getmem(iptmp,sizeof(integer)*np);         // 存储老节点编号
   for i:= 1 to np do
      begin
        iptmp[ptmp[i]]:=i;
      end;
   //  写入文件
   assignfile(f1, ffn+'_opt.dat');
    rewrite(f1);
   writeln(f1,'  np      ne');
   writeln(f1,format(' %4d   %5d', [np,ne]));
   writeln(f1,' ');
   writeln(f1,'     x        y        z   ');
   for i:=1 to np do
     begin
        tmp:= iptmp[i];
        writeln(f1,format('%9.3f %9.3f %9.3f',[node[tmp].x,node[tmp].y,node[tmp].z]));
     end;
   writeln(f1,' ');
   writeln(f1,'  left     right');
   for i:=1 to ne do
       writeln(f1,format('%5d    %5d',[ptmp[bar[i].nf],ptmp[bar[i].nl]]));
   closefile(f1);

   freemem(iptmp);
   freemem(ptmp);
end;

function Tspg.getsprno(a:single):byte;
var
  tmp,i:byte;
  min:single;
begin
  tmp:=0;
  min:=1e8;
  for i:=2 to 9 do  //  find equal
    if abs(spr[i]-a)<0.01 then tmp:=i;
  if tmp=0 then
  for i:=2 to 9 do  // treat as new
    if spr[i]<0.01 then
     begin
      spr[i]:=a;
      tmp:=i;
     end;
  if tmp=0 then   //  find the most nearly
  for i:=2 to 9 do
   if min>abs(spr[i]-a) then
     begin
      min:=abs(spr[i]-a);
      tmp:=i;
     end;
  result:=tmp;
end;

procedure Tspg.drawforce(prm:byte);
var
  fsx,fsy,i:integer;  //  在屏幕上的力点
  ar1x,ar2x,ar1y,ar2y:integer;   //  arrow xy on screen
  alf,alf1,alf2,arrow,ax,ay:single;
  zfg:byte;     //  flag if force is perpendicular to screen
  pp:pf;
begin
  arrow:=10;
  pp:=ndforce;
  i:=0;
  if pp=nil then exit;
  while pp<>nil do
   begin
     if pp^.kind=prm then
      begin
       i:=1;
       break;
      end;
     pp:=pp^.next;
   end;
  if i=0 then exit; //  prm not found;

  for i:=1 to np do
   begin
   if (abs(pp^.header^[i].x)>0.01) or (abs(pp^.header^[i].y)>0.01)
      or (abs(pp^.header^[i].z)>0.01) then
   begin
    ax:=pp^.header^[i].x*msht[1,1]+pp^.header^[i].y*msht[2,1]
        +pp^.header^[i].z*msht[3,1];
    ay:=pp^.header^[i].x*msht[1,2]+pp^.header^[i].y*msht[2,2]
        +pp^.header^[i].z*msht[3,2];
    ax:=famp*ax;
    ay:=famp*ay;
    if ay>=0 then
     begin
      fsx:=node[i].scx+round(ax);
      fsy:=node[i].scy-round(ay);
      if fsx=node[i].scx then alf:=PI/2
      else alf:=arctan2(node[i].scy-fsy,fsx-node[i].scx);
      alf1:=alf-PI/12;
      alf2:=alf+PI/12;
        ar1x:=round(fsx-arrow*cos(alf1));  //  四舍五入
        ar1y:=round(fsy+arrow*sin(alf1));
        ar2x:=round(fsx-arrow*cos(alf2));
        ar2y:=round(fsy+arrow*sin(alf2));
      zfg:=1;   //  arrow on force
     end
    else
     begin
       fsx:=node[i].scx-round(ax);
       fsy:=node[i].scy+round(ay);
       if fsx=node[i].scx then alf:=PI/2
       else alf:=arctan2(node[i].scy-fsy,fsx-node[i].scx);
       alf1:=alf-PI/12;
       alf2:=alf+PI/12;
         ar1x:=round(node[i].scx+arrow*cos(alf1));
         ar1y:=round(node[i].scy-arrow*sin(alf1));
         ar2x:=round(node[i].scx+arrow*cos(alf2));
         ar2y:=round(node[i].scy-arrow*sin(alf2));
       zfg:=2;    //  arrow on node
     end;
    if (fsx=node[i].scx) and (fsy=node[i].scy) then zfg:=0;
    with mainform.canvas do
     begin
      pen.style:=pssolid;
      pen.width:=1;
      if trunc(prm / 10) = 1 then   //  恒载
        pen.color:=$ffff80
      else if trunc(prm / 10) = 2 then   //  活载
        pen.color:=$80ffff
      else pen.color:=$ff80ff;    //  其它
     end;
    if zfg=0 then
     begin
       with mainform.canvas do
        begin
          ellipse(fsx-5,fsy-5,fsx+5,fsy+5);
          moveto(fsx-3,fsy-3);
          lineto(fsx+3,fsy+3);
          moveto(fsx+3,fsy-3);
          lineto(fsx-3,fsy+3);
        end;
     end
    else if zfg=1 then
     begin
      with mainform.canvas do
       begin
        moveto(node[i].scx,node[i].scy);
        lineto(fsx,fsy);
        moveto(fsx,fsy);lineto(ar1x,ar1y);
        moveto(fsx,fsy);lineto(ar2x,ar2y);
       end;
     end
    else if zfg=2 then
     begin
      with mainform.canvas do
       begin
        moveto(node[i].scx,node[i].scy);
        lineto(fsx,fsy);
        moveto(node[i].scx,node[i].scy);
        lineto(ar1x,ar1y);
        moveto(node[i].scx,node[i].scy);
        lineto(ar2x,ar2y);
       end;
     end;
   end;    // end of if
   end;    // end of for i
end;

procedure Tspg.setload(var vbm:array of shortint);
var
  i,k:byte;
  pp:pf;
begin
  pp:=ndforce;
   for i:=low(vbm) to high(vbm) do vbm[i]:=-1;
  if pp=nil then exit; 
  while pp<>nil do
   begin
    i:=trunc(pp^.kind/10)-1;
    for k:=i to 9 do inc(vbm[k]);
    pp:=pp^.next;
   end;

end;

function Tspg.addforce(jiyue:byte):pf;
//  在ndforce链表中找到位置,并增加一个af;jiyue=>curfc
var
  i:integer;
  pc,pp,newfk:pf;
  newf:af;
begin
  new(newfk);
  newfk^.kind:=jiyue;
  newfk^.next:=nil;
  getmem(newf,sizeof(three)*np);
  for i:=1 to np do
   begin
    newf^[i].x:=0;
    newf^[i].y:=0;
    newf^[i].z:=0;
   end;

  newfk^.header:=newf;

  if ndforce=nil then   //  first one
    begin
     ndforce:=newfk;
     result:=newfk;
     exit;
    end;
  pc:=ndforce;
  i:=0;
  while pc<>nil do
   begin
    if jiyue>pc^.kind then
     begin
      pp:=pc; pc:=pc^.next;
     end
    else if (jiyue<pc^.kind) and (pc=ndforce) then    // insert first
     begin
       ndforce:=newfk;
       ndforce^.next:=pc;
       result:=newfk;
       exit;
     end
    else //   have found place
     begin
      i:=1;
      break;
     end;
   end;
   if i=0 then pp^.next:=newfk  //  add to tail
   else       //  insert to proper place
     begin
       newfk^.next:=pp^.next;
       pp^.next:=newfk;
     end;
  result:=newfk;
end;

function Tspg.forceexist(jiyue:byte):byte;
var
  pc:pf;
  i:integer;
begin
  pc:=ndforce;
  i:=0;
  while pc<>nil do
   begin
    if jiyue<>pc^.kind then
     begin
      pc:=pc^.next;
     end
    else   //   have found
     begin
      i:=1;
      break;
     end;
   end;
   result:=i;
end;

procedure Tspg.delforce(jiyue:byte);
  //  在ndforce链表中找到位置,并删除af ;jiyue=>curfc
var
  i:byte;
  pp,pc:pf;
  ff:af;
begin
  pc:=ndforce;
  i:=0;
  while pc<>nil do
   begin
    if jiyue<>pc^.kind then
     begin
      pp:=pc; pc:=pc^.next;
     end
    else   //   have found
     begin
      i:=1;
      break;
     end;
   end;
  if i=0 then messagedlg('无此荷载!',mterror,[mbok],0)
  else
   begin
      freemem(pc^.header);
      pp^.next:=pc^.next;
      freemem(pc);
   end;
end;

function Tspg.updateforce(aa:byte;tf:three):byte;
 //  modify selected node's three-directed force
 //  according specified force kind "aa"(curfc)
var
  i:integer;
  pp:pf;
begin
  pp:=ndforce;
  i:=0;
  while pp<>nil do
   begin
     if pp^.kind=aa then
      begin
       i:=1;
       break;
      end;
     pp:=pp^.next;
   end;
  if i=0 then
   begin
    result:=0;
    exit; //  not found;
   end;
 for i:=1 to np do
  if node[i].sel=1 then
   begin
    pp^.header^[i].x:=tf.x;
    pp^.header^[i].y:=tf.y;
    pp^.header^[i].z:=tf.z;
   end;
  result:=1;
end;

procedure Tspg.draw3dspt;
begin

end;

procedure Tspg.drawspt(xz:byte);    //  xz is choose
var
  i,clr,tmp1:integer;
  f: textfile;
  max,min,x,y:single;
  x1,y1:integer;
begin
  if mainform.N3D1.checked then
    begin
      mainform.N3D1.checked := false;
    end;
  mainform.makmsht;       //  生成投影转换矩阵
  mainform.draword;       //  draw the ordinate xyz

  mainform.canvas.pen.width:=1;
  mainform.canvas.pen.color:=clyellow;
  x1:=round(basex);
  y1:=round(basey);
  mainform.canvas.MoveTo(x1-5,mainform.clientheight-y1);
  mainform.canvas.lineto(x1+6,mainform.clientheight-y1);
  mainform.canvas.MoveTo(x1,mainform.clientheight-y1-5);
  mainform.canvas.lineto(x1,mainform.clientheight-y1+6);

  if xz<10 then
   for i:= 1 to np do    //  original
    node[i].calscxy(0)
  else
   for i:= 1 to np do    //  deformation
    node[i].calscxy(1);

  mainform.canvas.pen.width:=1;

  if xz = 0 then
    for i:=1 to ne do  //  draw bar  no property
       bar[i].drawbar(clred,curgrp)
  else if xz = 1 then
    for i:=1 to ne do  //  draw  bar  by material
      bar[i].drawbar(subsecmat.mater[bar[i].mat].color,curgrp)
  else if xz = 2 then
    for i:=1 to ne do  //   draw  bar  by section
      bar[i].drawbar(subsecmat.section[bar[i].sec].color,curgrp)

  else if xz = 10 then  //  draw bar deformation
    for i:=1 to ne do
      bar[i].drawbar(claqua,0)
  else if xz = 11 then  //    draw bar by red 截面不满足
    for i:=1 to ne do
      if bar[i].red=1 then bar[i].drawbar(clred,0)
      else  bar[i].drawbar(clsilver,0)
  else if xz = 12 then
    begin
      {max:=-1000;
      min:=1000;
      for i:=1 to ne do
        begin
          if max<bar[i].sigma then max:= bar[i].sigma;
          if min>bar[i].sigma then min:= bar[i].sigma;
        end;  }
      for i:=1 to ne do
        begin
          if abs(bar[i].sigma)<1 then
            clr:=$808080
          else if bar[i].sigma>0 then
            begin
             // tmp1:= trunc(255*(1-bar[i].sigma/max));
            clr:=$0000ff;
            end
          else if bar[i].sigma<0 then
            begin
             //   tmp1:= trunc(255*(1-bar[i].sigma/min));
             clr:=$00ff00;
            end;
          bar[i].drawbar(clr,0);
        end
      end
    else if xz = 13 then  //    draw bar by too small 截面
     for i:=1 to ne do
      if abs(bar[i].sigma)<20 then bar[i].drawbar(cllime,0)  //  <20MPa
      else  bar[i].drawbar(clsilver,0);

  drawforce(curfc);   //  draw force of node in screen

  mainform.canvas.pen.width:=1;
  for i:=1 to np do
    begin
     if node[i].sel=1 then
         node[i].drawnode(clwhite);  //  draw selected node
     if node[i].ys>0 then
         node[i].drawbear(clblue);    //   draw  bearing
    end;
  with mainform do
   begin
    if N48.Checked = true then
      begin
        canvas.font.size:=8; canvas.font.color:=clyellow;
        canvas.Brush.style:=bsclear;
        for i:=1 to spf.np do
           canvas.textout(spf.node[i].scx,spf.node[i].scy,inttostr(i));
      end;
    if N49.Checked = true then
       begin
          canvas.font.size:=8;  canvas.font.color:=claqua;
            // canvas.Brush.style:=bsclear;
          for i:=1 to spf.ne do
              begin
                 x:=1.1*spf.node[spf.bar[i].nf].scx+0.9*spf.node[spf.bar[i].nl].scx;
                 y:=1.1*spf.node[spf.bar[i].nf].scy+0.9*spf.node[spf.bar[i].nl].scy;
                 x:=x/2;  y:=y/2;
                 canvas.textout(round(x),round(y),inttostr(i));
              end;
       end;
   end;
end;

procedure Tspg.sptrot(x1,y1,x2,y2:integer);
var                 //  rotate in space
  dx,dy:integer;
  theta:single;
begin
  dx:=x2-x1;
  dy:=y2-y1;
  if dx=0 then
    theta:=PI/2
  else
    theta:=arctan(abs(dy/dx));
  if theta>=PI/3 then      //  >= 60
    jx:=jx+0.15*dy*PI/180
  else if theta<=PI/6 then     //  <= 30
    jz:=jz+0.15*dx*PI/180;
end;

procedure Tspg.sptpan(x1,y1,x2,y2:integer);
var
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
  drawspt(curdis);
end;

procedure Tspg.sptmov(x1,y1,x2,y2:integer);

begin
  basex:=basex+x2-x1;
  basey:=basey-y2+y1;
  mainform.cleansc;
  drawspt(curdis);
end;

//  next procedure is interface for Prof. Luo's program
procedure Tspg.calcudata;
var
 i:integer;
begin
nys:=0; nic:=0; nks:=0; ies:=0;
ifs:=0; ndes:=0; iv:=0;
  for i:=1 to np do
   begin
    if node[i].ys<>0 then inc(nys);
    if (node[i].ang_cj mod 10000)<>0 then inc(nic);
    if (node[i].ang_cj>=10000) or (node[i].ang_cj<=-10000) then inc(iv);
   end;
  for i:=1 to ne do
   if bar[i].chg=0 then inc(ndes);
  for i:=2 to 9 do
   begin
     if spr[i]>0.01 then inc(nks);
   end;
  ies:=spf.subsecmat.mno;
  ifs:=spf.subsecmat.sno;   //  后面又改变
end;

function Tspg.PL_makgeofile(cz:byte):byte;
var
  f:textfile;
  str:string;
  i,j,k,kd:integer;
  tf:af;
begin
  calcudata;
  kd:= spf.subsecmat.section[bar[1].sec].kind;
  ifs:=spf.subsecmat.getsecbase(kd+1)-spf.subsecmat.getsecbase(kd);  //  ifs changed
  assignfile(f, workpath+'fpg.dat');
  rewrite(f);
  // 边界节点数,斜边界节点数,边界弹簧数,材料总数
  // 截面积总数,失稳曲线总数,截面积不可变的杆件总数
  writeln(f,nys:-4,',',nic:4,',',nks:4,',',ies:4,',',ifs:4,',  3,',ndes:4,',');
  // 单位制选择,容许长细比,最大应力系数,最小应力系数
  writeln(f,'3 ,',rlm:5,',',smax:5:2,',',smin:5:2,',');
  // 操作参数,杆件截面调整次数,指定长度杆的控制截面,控制截面编号
  writeln(f,cz:-2,',',mmax:4,', 10.0, 0,');
  // 序号,弹模,屈服值,设计值(共材料总数个)
  for i:=1 to ies do
    writeln(f,format('%-3d,%10.3e,%6.1f,%6.1f,',
     [i,spf.subsecmat.mater[i].Es,spf.subsecmat.mater[i].fq,
      spf.subsecmat.mater[i].fy]));
  // 序号, 失稳类型(共失稳曲线总数个)
  for i:=1 to 3 do
    writeln(f,i:3,',',i:3,',');
  // 结构自重控制系数
  writeln(f,ncc:3,',');
  // 杆件总数,节点总数
  writeln(f,ne:6,',',np:5,',');
    // 序号,杆总信息(共杆件总数个) a.xxxxxxxxoo
  for i:=1 to ne do
   begin
     //  截面序号应扣除起始位置
    j:=subsecmat.getsecbase(subsecmat.section[bar[i].sec].kind);
    str:=concat(format('%5d.',[bar[i].sec-j+1]));
     if bar[i].nf<bar[i].nl then
       str:=concat(str,format('%4.4d',[bar[i].nf]),format('%4.4d',[bar[i].nl]))
     else
       str:=concat(str,format('%4.4d',[bar[i].nl]),format('%4.4d',[bar[i].nf]));
     str:=concat(str,format('%1d',[bar[i].mat]),format('%1d',[bar[i].stc]));
     writeln(f,i:4,str);
   end;
  writeln(f,'');
  // 边界节点信息(共边界节点数个) b.xyz
  k:=0;
  for i:=1 to np do
   begin
    if node[i].ys<>0 then
      begin
       str:=concat(format('%3.3d',[node[i].ys]));
       write(f,i:4,'.',str,',');
       inc(k);
       if (k mod 5)=0 then writeln(f,'');
      end;
   end;
  writeln(f,'');
  // 边界弹簧信息(共边界弹簧数个)
  k:=0;
  for i:=1 to nks do
   begin
    write(f,spr[i]:9:2,',');
    if (i mod 5)=0 then writeln(f,'');
   end;
  writeln(f,'');

  // 面积(本组)
  with subsecmat do
  begin
   for i:=getsecbase(kd) to getsecbase(kd+1)-1 do
    begin
      write(f,(100*section[i].area):8:1,',');  //  change cm2 => mm2
      if ((i-getsecbase(kd)+1) mod 5)=0 then writeln(f,'');
    end;
   writeln(f,''); writeln(f,'');

  // 回转半径(本组)
   for i:=getsecbase(kd) to getsecbase(kd+1)-1 do
    begin
      write(f,(10*section[i].rodr2):8:1,',');    //  change cm => mm
      if ((i-getsecbase(kd)+1) mod 5)=0 then writeln(f,'');
    end;
   writeln(f,'');  writeln(f,'');
  end;

  // 序号,X坐标,Y坐标,Z坐标(共节点总数个)
  for i:=1 to np do
   writeln(f,i:5,node[i].x:9:3,',',node[i].y:9:3,',',node[i].z:9:3,',');
  // 斜边界节点号(共斜边界节点数个)
  for i:=1 to np do
    if (node[i].ang_cj mod 10000)<>0 then
     writeln(f,i:5,(node[i].ang_cj mod 10000):6,',');
  // 斜边界倾角[与X轴正向夹角](共斜边界节点数个)

  // 工况组合数
  k:=0;
  for i:=1 to 15 do
    if comld[i,0]>0 then inc(k);
  writeln(f,k:4);
  // 工况文件名(共工况总数个)
  for i:=1 to k do
    writeln(f,'loadp'+inttostr(i)+'.dat');
  writeln(f,'0');
  closefile(f);
  result:=1;
end;

function Tspg.PL_makloadfile(num:byte):byte;
var
  ff:textfile;
  i,j,fn:integer;
  tf:af;
  pp:pf;
  fk:array [1..5] of integer;
  coef,com:array [1..5] of single;
  pk:array [1..5] of af;   // 存放参与该组合的力的头指针
begin
  if (iv>0) and (dtemp>0) then i:=4
  else if (iv>0) or (dtemp>0) then i:=3
  else i:=2;
  assignfile(ff, workpath+concat('loadp',inttostr(num),'.dat'));
  rewrite(ff);
  // 总荷载类型数
  writeln(ff,i:3,',');
  // 荷载类型序号排列
  write(ff,'1, 2, ');
  if dtemp>0 then write(ff,'3, ');
  if iv>0 then write(ff,'4, ');
  writeln(ff,'');
  // 恒载分项系数,单个节点重,{材料密度(共材料总数个)}
  write(ff,'1.2, ',(-1*nodewt):7:2,',');
  for i:= 1 to ies do
    write(ff,format('%10.3e,',[-1*subsecmat.mater[i].rwt*9.8e-9]));
  writeln(ff,'');
  // 受荷节点总数
  getmem(tf,sizeof(three)*np);
  for i:=1 to 5 do
   begin
     fk[i]:=trunc(comld[num,i]/10000);
     coef[i]:=comld[num,i]-fk[i]*10000;
     fk[i]:=i*10+fk[i];
     if coef[i]<=0 then
       begin
        fk[i]:=0;
        coef[i]:=0;
       end;
     pk[i]:=nil;
   end;
  com[1]:=1.0;       //  恒载 1.0 (组合系数)
  if comld[num,0]>9 then   //  不简化
   begin
    com[2]:=1.0; com[3]:=0.6; //  风载0.6
    com[4]:=1.0; com[5]:=1.0;
   end
  else if (comld[num,0]>0) and (comld[num,3]>0) then  //  简化
   begin
    com[2]:=0.85; com[3]:=0.85; // 0.85
    com[4]:=0.85; com[5]:=0.85;
   end
  else if comld[num,0]>0 then   //   简化
   begin
    com[2]:=1.0; com[3]:=0.0; // 0.85
    com[4]:=1.0; com[5]:=1.0;
   end;
  pp:=ndforce;
  while pp<>nil do
    begin
      for i:= 1 to 5 do
        if pp^.kind=fk[i] then pk[i]:=pp^.header;
      pp:=pp^.next;
    end;
  fn:=0;
  for i:=1 to np do
   begin
     tf^[i].x:=0;
     tf^[i].y:=0;
     tf^[i].z:=0;
     for j:=1 to 5 do
      if pk[j]<>nil then
       begin
        tf^[i].x:=tf^[i].x+pk[j]^[i].x*coef[j]*com[j];
        tf^[i].y:=tf^[i].y+pk[j]^[i].y*coef[j]*com[j];
        tf^[i].z:=tf^[i].z+pk[j]^[i].z*coef[j]*com[j];
       end;
    if (abs(tf^[i].x)>0.001) or (abs(tf^[i].y)>0.001)
         or (abs(tf^[i].z)>0.001) then
    inc(fn);
   end;
   writeln(ff,fn:5,',');
   // 节点号,X向节点荷载,Y向节点荷载,Z向节点荷载(共受荷节点总数个)
   for i:=1 to np do
    if (abs(tf^[i].x)>0.001) or (abs(tf^[i].y)>0.001)
         or (abs(tf^[i].z)>0.001) then
    writeln(ff,i:5,',',tf^[i].x:9:3,',',tf^[i].y:9:3,',',tf^[i].z:9:3,',');

  freemem(tf);
  //  相对温度,{材料线膨胀系数(共材料总数个)}

  if dtemp>0 then
   begin
     write(ff,dtemp:5,',');
     for i:= 1 to ies do
       write(ff,format('%6.1f,',[subsecmat.mater[i].alpha]));
     writeln(ff,'');
   end;
  // 位移支座节点个数
  // 节点号,X向位移,Y向位移,Z向位移(共位移支座节点总数个)
  if iv>0 then
   begin
     write(ff,iv:4,',');
     for i:=1 to np do
      if (node[i].ang_cj<-10000) or (node[i].ang_cj>10000) then
       writeln(ff,i:5,',',node[i].dx:6:1,',',node[i].dy:6:1,
         ',',node[i].dz:6:1,',');
   end;
  writeln(ff,'0');
  closefile(ff);
end;

procedure Tspg.PL_readresult(lc:integer);  //  读结果文件
var
  ff:textfile;
  lin:string[85];
  sas:string[3];
  cc,i,j,a,clc:integer;
  st:string[22];
  s1,s2,s3:string[9];
  s4:string[8];  s5,s6,s7:string[7];
begin

  assignfile(ff, workpath+'res.dat');
  reset(ff);
  cc:=0;
  while not eof(ff)  do   //  judge 'analyse' or 'design'
   begin
     readln(ff,lin);
     if pos('Only',lin)<>0 then
       begin
        cc:=1;  break;    //  analyse only
       end
     else if pos('Verifying calculation',lin)<>0 then
       begin
        cc:=2;  break;    //  design & analyse
       end;
   end;
  if cc<1 then
    begin
     messagedlg('结果文件格式错!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end;

  cc:=0;
  clc:=0;
  while (clc<>lc) and (not eof(ff)) do    //  get loadcase
    begin
     readln(ff,lin);
      if (pos('>',lin)<>0) and (pos('case',lin)<>0) then
       begin
         cc:=1;
         inc(clc);
       end;
    end;

  if cc<>1 then
    begin
     messagedlg('工况号部分有错!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end;
  if clc<>lc then
    begin
     messagedlg('无此工况号!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end
  else           //  read this (lc) loadcase
   begin
   cc:=0;
   while not eof(ff)  do    //  read net weight;
    begin
     readln(ff,lin);
     if pos('Weight',lin)<>0 then
      begin
       cc:=1; break;
      end;
    end;
   if cc<>1 then
    begin
     messagedlg('总重量部分有错!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end
   else
    begin
     readln(ff,lin);
     trim(lin);
     delete(lin,1,22);  trim(lin);
     cc:=pos('Ton',lin); delete(lin,cc,3);
     totalw:=strtofloat(lin);
    end;
   cc:=0;
   while not eof(ff) do   //  read displace
    begin
     readln(ff,lin);
     if pos('Disp',lin)<>0 then
      begin
       cc:=1; break;
      end;
    end;
   if cc<>1 then
    begin
     messagedlg('位移部分有错!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end
   else
    begin
     readln(ff,lin);     //  omit 'No x(mm)...'
     for i:= 1 to trunc(np/2) do
      readln(ff,a,node[2*(i-1)+1].dx,node[2*(i-1)+1].dy,node[2*(i-1)+1].dz,
         a,node[2*i].dx,node[2*i].dy,node[2*i].dz);
     if trunc(np/2)<>trunc((np+1)/2) then
      readln(ff,a,node[np].dx,node[np].dy,node[np].dz);
     for i:=1 to np do     //  change unit from 'mm' to 'm'
      begin
       node[i].dx:=node[i].dx/1000;
       node[i].dy:=node[i].dy/1000;
       node[i].dz:=node[i].dz/1000;
      end;
    end;
   end;    //  end of else
  cc:=0;
  while not eof(ff) do   //  read stress etc.
    begin
     readln(ff,lin);
     if pos('Phi',lin)<>0 then
      begin
       cc:=1; break;
      end;
    end;
   if cc<>1 then
    begin
     messagedlg('内力部分有错!',mtwarning,[mbok],0);
     closefile(ff);
     exit;
    end
   else
    begin
      for i:=1 to ne do
       begin
        readln(ff,sas,st,s1,s2,s3,s4,s5,s6,s7);
        if trim(sas)='**' then bar[i].red:=1  //  应力超限
        else bar[i].red:=0;     
        if pos('*',s1)<>0 then bar[i].force:=INF  //  内力
        else bar[i].force:=strtofloat(s1);
        if pos('*',s2)<>0 then bar[i].sigma:=INF  //   应力
        else bar[i].sigma:=strtofloat(s2);
        if bar[i].chg=1 then                    //  截面改变
          bar[i].sec:=strtoint(s5)+
           subsecmat.getsecbase(subsecmat.section[bar[i].sec].kind)-1;
        if pos('*',s7)<>0 then bar[i].lmd:=INF  //  长细比
        else bar[i].lmd:=strtofloat(s7);
       end;
    end;
  getmem(bearforce,sizeof(three)*nys);
  cc:=0;
  while not eof(ff) do   //  read stress etc.
    begin
     readln(ff,lin);
     if (pos('X(kN)',lin)<>0) and (pos('Y(kN)',lin)<>0) then
      begin
       cc:=1; break;
      end;
    end;
  if cc<>1 then
    begin
     messagedlg('支座应力部分有错!',mterror,[mbok],0);
     closefile(ff);
     freemem(bearforce);
     exit;
    end
  else
    begin
     for i:= 1 to trunc(nys/2) do
      readln(ff,a,bearforce^[2*i-1].x,bearforce^[2*i-1].y,bearforce^[2*i-1].z,
         a,bearforce^[2*i].x,bearforce^[2*i].y,bearforce^[2*i].z);
     if trunc(nys/2)<>trunc((nys+1)/2) then
      readln(ff,a,bearforce^[nys].x,bearforce^[nys].y,bearforce^[nys].z);
    end;
  closefile(ff);
end;

procedure Tspg.PL_showsigma(choose:byte);
var
  i:integer;
begin
  mainform.cleansc;
  mainform.makmsht;       //  生成投影转换矩阵
  mainform.draword;       //  draw the ordinate xyz
   for i:= 1 to np do    //  deform
     node[i].calscxy(1);
  mainform.canvas.pen.width:=1;
  mainform.canvas.pen.style:=pssolid;
  if choose=1 then      //  不满足要求的杆件
   begin
    for i:=1 to ne do
      if bar[i].red=1 then bar[i].drawbar(clred,0)
      else  bar[i].drawbar(clsilver,0);
   end
  else if choose=2 then   //  应力太小的杆件
   begin
    for i:=1 to ne do
      if abs(bar[i].sigma)<20 then bar[i].drawbar(clgreen,0)  //  <20MPa
      else  bar[i].drawbar(clsilver,0);
   end
  else if choose=3 then    //   拉\压\零杆
   begin
    for i:=1 to ne do
       if abs(bar[i].sigma)<1 then bar[i].drawbar(clwhite,0)
       else if bar[i].sigma>=1 then  bar[i].drawbar(clred,0)
       else if bar[i].sigma<=-1 then  bar[i].drawbar(clgreen,0);
   end;
  mainform.canvas.pen.width:=1;
  for i:=1 to np do
    begin
     if node[i].sel=1 then
         node[i].drawnode(clwhite);  //  draw selected node
     if node[i].ys>0 then
         node[i].drawbear(clblue);    //   draw  bearing
    end;
end;

function Tspg.write_s(fname:string):byte;
begin
//
end;

function Tspg.writeall(fname:string):byte;
var
  i,j,ct :integer;
  a1: array[1..11] of integer;
  a2: array[1..17] of single;
  a3: array[1..6] of byte;
  a4: array[1..90] of single;
  a5: Rnode;   a6: Rbar;
  a7: three;
  pp: pf;
  f: file;
  //  f1: textfile;
begin
  subsecmat.writecfg(ffn+'_jc.txt');
  a1[1]:=ne; a1[2]:=np; a1[3]:=nys; a1[4]:=nic;
  a1[5]:=nks; a1[6]:=ies; a1[7]:=ifs; a1[8]:=ndes;
  a1[9]:=iv; a1[10]:=rlm; a1[11]:=dtemp;

  a2[1]:=totalw;  a2[2]:=nodewt;
  a2[3]:=famp;  a2[4]:=damp; a2[5]:=smax; a2[6]:=smin;
  a2[7]:=midx; a2[8]:=midy; a2[9]:=midz;
  for i:=10 to 17 do
    a2[i]:=spr[i-8];

  a3[1]:=elekind;  a3[2]:=mmax;  a3[3]:=ncc;
  a3[4]:=curgrp; a3[5]:=curfc; a3[6]:=curldc;

  for i:=1 to 15 do
    for j:=0 to 5 do
      a4[(i-1)*6+j+1]:=comld[i,j];

  assignfile(f, fname);
  rewrite(f,1);
  seek(f,0);

   blockwrite(f,a1,sizeof(a1));
   blockwrite(f,a2,sizeof(a2));
   blockwrite(f,a3,sizeof(a3));
   blockwrite(f,a4,sizeof(a4));
   for i:= 1 to np do
    begin
      a5.x:=node[i].x; a5.y:=node[i].y; a5.z:=node[i].z;
      a5.dx:=node[i].dx; a5.dy:=node[i].dy; a5.dz:=node[i].dz;
      a5.scx:=node[i].scx; a5.scy:=node[i].scy;
      a5.ys:=node[i].ys; a5.sel:=node[i].sel;
      a5.ang_cj:=node[i].ang_cj;
      blockwrite(f,a5,sizeof(a5));
    end;

  for i:= 1 to ne do
    begin
      a6.nf:=bar[i].nf; a6.nl:=bar[i].nl;
      a6.wt:=bar[i].wt; a6.force:=bar[i].force; a6.len:=bar[i].len;
      a6.mat:=bar[i].mat; a6.sec:=bar[i].sec; a6.grp:=bar[i].grp;
      a6.red:=bar[i].red; a6.sel:=bar[i].sel; a6.chg:=bar[i].chg;
      a6.stc:=bar[i].stc; a6.lmd:=bar[i].lmd; a6.sigma:=bar[i].sigma;
      blockwrite(f,a6,sizeof(a6));
    end;

  pp:=ndforce;
  ct:=0;
  while pp<>nil do
   begin
    ct:=ct+1;
    pp:=pp^.next;
   end;
  blockwrite(f,ct,sizeof(ct));
  pp:=ndforce;
  for i:=1 to ct do
   begin
    blockwrite(f,pp^.kind,sizeof(pp^.kind));
    for j:=1 to np do
     begin
      a7.x := pp^.header^[j].x;
      a7.y := pp^.header^[j].y;
      a7.z := pp^.header^[j].z;
      blockwrite(f,a7,sizeof(a7));
     end;
    pp:=pp^.next;
   end;
  blockwrite(f,curbv,sizeof(curbv));  //  当前状态
  closefile(f);

  result:=1;
end;

function Tspg.readall(fname:string):byte;
var
  i,j,ct :integer;
  kind, jcflag : byte;
  a1: array[1..11] of integer;
  a2: array[1..17] of single;
  a3: array[1..6] of byte;
  a4: array[1..90] of single;
  a5: Rnode;   a6: Rbar;
  a7: three;
  pp: pf;
  f: file;
  f1:textfile;
  maxx,maxy,maxz,minx,miny,minz,tmp:single;
begin
  jcflag:=1;
  if subsecmat.readcfg(ffn+'_jc.txt')=0 then //  读自带截面材料文件
   begin
     jcflag:=0;
   end;

  assignfile(f, fname);
  reset(f,1);
  seek(f,0);
   blockread(f,a1,sizeof(a1));
   blockread(f,a2,sizeof(a2));
   blockread(f,a3,sizeof(a3));
   blockread(f,a4,sizeof(a4));
   nys:=a1[3]; nic:=a1[4];
   nks:=a1[5]; ies:=a1[6]; ifs:=a1[7]; ndes:=a1[8];
   iv:=a1[9]; rlm:=a1[10]; dtemp:=a1[11];

   totalw:=a2[1];  nodewt:=a2[2];
   famp:=a2[3];  damp:=a2[4]; smax:=a2[5]; smin:=a2[6];
   midx:=a2[7]; midy:=a2[8]; midz:=a2[9];

  for i:=10 to 17 do
    spr[i-8]:=a2[i];

  elekind:=a3[1]; mmax:=a3[2]; ncc:= a3[3];
  curgrp:=a3[4]; curfc:=a3[5]; curldc:=a3[6];

  for i:=1 to 15 do
    for j:=0 to 5 do
      comld[i,j]:=a4[(i-1)*6+j+1];

   for i:= 1 to np do
    begin
      blockread(f,a5,sizeof(a5));
      node[i].x:=a5.x; node[i].y:=a5.y; node[i].z:=a5.z;
      node[i].dx:=a5.dx; node[i].dy:=a5.dy; node[i].dz:=a5.dz;
      node[i].scx:=a5.scx; node[i].scy:=a5.scy;
      node[i].ys:=a5.ys; node[i].sel:=a5.sel;
      node[i].ang_cj:=a5.ang_cj;
    end;

   for i:= 1 to ne do
    begin
      blockread(f,a6,sizeof(a6));
      bar[i].nf:=a6.nf; bar[i].nl:=a6.nl;
      bar[i].wt:=a6.wt; bar[i].force:=a6.force; bar[i].len:=a6.len;
      if jcflag=1 then
        begin
          bar[i].mat:=a6.mat; bar[i].sec:=a6.sec;
        end;
      bar[i].grp:=a6.grp; bar[i].red:=a6.red;
      bar[i].sel:=a6.sel; bar[i].chg:=a6.chg;
      bar[i].stc:=a6.stc; bar[i].lmd:=a6.lmd; bar[i].sigma:=a6.sigma;
    end;

  blockread(f,ct,sizeof(ct));

  for i:=1 to ct do
   begin
    blockread(f,kind,sizeof(kind));
    pp:=spf.addforce(kind);
    for j:=1 to np do
     begin
      blockread(f,a7,sizeof(a7));
      pp^.header^[j].x:=a7.x ;
      pp^.header^[j].y:=a7.y ;
      pp^.header^[j].z:=a7.z ;
     end;
   end;
  blockread(f,curbv,sizeof(curbv));
  if jcflag=0 then curbv[PROP]:=0;
  curbv[SOLV]:=0;
  curbv[OPT]:=0;
  closefile(f);

  setnodelink;    // 设置节点链

  maxx:=-1e8; maxy:=-1e8; maxz:=-1e8;
  minx:=1e8; miny:=1e8; minz:=1e8;

  for i:=1 to np do
   begin
    if maxx<node[i].x then maxx:=node[i].x;
    if maxy<node[i].y then maxy:=node[i].y;
    if maxz<node[i].z then maxz:=node[i].z;
    if minx>node[i].x then minx:=node[i].x;
    if miny>node[i].y then miny:=node[i].y;
    if minz>node[i].z then minz:=node[i].z;
   end;
  midx:=(maxx+minx)/2;
  midy:=(maxy+miny)/2;
  midz:=(maxz+minz)/2;
  tmp:=maxx-minx;
  if tmp<(maxy-miny) then tmp:=maxy-miny;
  if tmp<(maxz-minz) then tmp:=maxz-minz;
  scale0:=500/tmp;
  tmp:=(maxx-minx)/(maxy-miny);    //  modify
  if tmp>1 then tmp := 1 / tmp;
  if tmp > 0.8 then scale0:=scale0 / 1.2
  else if tmp <0.4 then scale0:=scale0 * 1.2;
  scale:=scale0;
end;

constructor Tusedsecmat.init;
var
  i:integer;
begin
 for i:=0 to 10 do
   mater[i]:=Tmat.init;
 for i:=0 to 50 do
   section[i]:=Tsec.init;

 mno:=0;
 sno:=0;
      //  材料类别数,截面类别数
end;

function Tusedsecmat.getsecbase(kd:byte):integer;
var
  a1,i:byte;
begin
  a1:=1;
  for i:=1 to sno do
    if section[i].kind< (kd) then
     inc(a1)
    else break;
  result:=a1;
end;

function Tusedsecmat.getseckind(kd:byte;str:string='AAA'):string;
var
  aa:string;
  i:integer;
begin
  if str='AAA' then
   begin
    if kd=1  then aa:='圆钢管'
    else if kd=2 then aa:='双拼角钢'
    else if kd=3 then aa:='工字型截面'
    else if kd=4 then aa:='方钢管'
    else  aa:='用户定义';
   end
  else
    begin
      if str='YG' then i:=1
      else if str='SJ' then i:=2
      else if str='GZ' then i:=3
      else if str='FG' then i:=4
      else i:=5;
      aa:=inttostr(i);
    end;
  result:=aa;
end;

function Tusedsecmat.readcfg(fnm:string):byte;  //  读cfg数据文件
var
  ls:string;
  sname:string[18];  //  max 18 charaters in section name
  mname:string[15];  //  max 15 charaters in matirial name
  a1,a2,a3,a4,a5:string[10];
  // c:Tcolor;
  f:textfile;
  i:integer;
begin
 if not FileExists(fnm) then
  begin
    showmessage('No Corresponding SecMat File!');
    result:=0;
    exit;
  end;

  assignfile(f,fnm);
  reset(f);
  i:=1;
  sname:='aa';
  mname:='bb';
  while (strpos(pchar(ls),'SEC')=nil) do
    readln(f,ls);
  readln(f,sname,a1,a2,a3);    //  read a line in sec file
  while (trim(sname)<>'')  do
   begin
    section[i]:=Tsec.init;
    section[i].name:=trim(sname);
    if pos('YG',sname)<>0 then     //  圆管
     begin
       section[i].kind:=1;
     end
    else if pos('SJ',sname)<>0 then    // 双角钢
     begin
       section[i].kind:=2;
     end
    else if pos('GZ',sname)<>0 then    //  工字钢
     begin
       section[i].kind:=3;
     end
    else if pos('FG',sname)<>0 then    //  方管
     begin
       section[i].kind:=4;
     end
    else
      section[i].kind:=5;       //  其余

    section[i].area:=strtofloat(a1);     // area unit cm2
    section[i].ita2:=strtofloat(a2);     //  I2 unit cm4
    section[i].ita3:=strtofloat(a3);     //  I3 unit cm4
    section[i].getcolor(i);
    section[i].ia2r;
    i:=i+1;
    readln(f,sname,a1,a2,a3);
   end;
  sno:=i-1;

  i:=1;
  while (strpos(pchar(ls),'MAT')=nil) do
    readln(f,ls);
  readln(f,mname,a1,a2,a3,a4,a5);
  while (trim(mname)<>'')  do
   begin
    mater[i]:=Tmat.init;
    mater[i].name:=trim(mname);
    mater[i].Es:=strtofloat(a1);     //  unit  MPa
    mater[i].fq:=strtofloat(a2);     //  unit  MPa
    mater[i].fy:=strtofloat(a3);     //  unit  MPa
    mater[i].rwt:=strtofloat(a4);    //  unit  T/m3
    mater[i].alpha:= strtofloat(a5);
    mater[i].getcolor(i);
    i:=i+1;
    readln(f,mname,a1,a2,a3,a4,a5);
   end;
  mno:=i-1;
  closefile(f);
  result:=1;
end;

procedure Tusedsecmat.writecfg(fnm:string);
var
  i:integer;
  f:textfile;
begin
  assignfile(f,fnm);
  rewrite(f);
  writeln(f,'SEC            ( Area cm2   I2 cm4   I3 cm4)');
  for i:=1 to sno do
    writeln(f,format('%-18s%-10.2f%-10.2f%-10.2f',
      [section[i].name,section[i].area,section[i].ita2,section[i].ita3]));
  writeln(f,format('%39d',[0]));
  writeln(f,'');
  writeln(f,'MAT           (E MPa   fq MPa   fy MPa   rwt T/m3   alpha mm/C )');
  for i:=1 to mno do
    writeln(f,format('%-15s%-10.0f%-10.1f%-10.1f%-10.2f%-10.2e',
     [mater[i].name,mater[i].Es,mater[i].fq,mater[i].fy,
      mater[i].rwt,mater[i].alpha]));
  writeln(f,format('%56d',[0]));
  closefile(f);    
end;

procedure Tusedsecmat.addmatkind(mat1:Tmat);
var
  i:integer;
begin
  i:=mno+1;
  mater[i]:=Tmat.init;
  mater[i]:=mat1;
  mno:=mno+1;
end;

function Tusedsecmat.addseckind(sec1:Tsec):integer;
var
  i,j,bas1,bas2:integer;
begin
  i:=1;
  if sno>=50 then
   begin
     showmessage('Too many types of Sections!');
     exit;
   end;
  bas1:=getsecbase(sec1.kind);
  bas2:=getsecbase(sec1.kind+1);
  j:=bas2;
  for i:=bas1 to bas2-1 do
    if sec1.area>section[i].area then
      begin
        j:=i;
        break;
      end;
  for i:=sno downto j do
    begin
     section[i+1].name:=section[i].name;
     section[i+1].area:=section[i].area;
     section[i+1].Ita2:=section[i].Ita2;
     section[i+1].Ita3:=section[i].Ita3;
     section[i+1].kind:=section[i].kind;
     section[i+1].color:=section[i].color;
     section[i+1].ia2r;
    end;
  section[j].name:=sec1.name;   section[j].area:=sec1.area;
  section[j].Ita2:=sec1.Ita2;   section[j].Ita3:=sec1.Ita3;
  section[j].kind:=sec1.kind;
  section[j].color:=sec1.color;
  section[j].ia2r;
  sno:=sno+1;
  result:=j;
end;

end.

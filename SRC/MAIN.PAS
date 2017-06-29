unit MAIN;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, Buttons, ExtCtrls, shellapi, StdCtrls, strutils, show3d ;

type
  TMAINForm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    OpenDialog1: TOpenDialog;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N35: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N10: TMenuItem;
    N16: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    DXF1: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    DXFin1: TMenuItem;
    PopupMenu1: TPopupMenu;
    N61: TMenuItem;
    N62: TMenuItem;
    N63: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    SaveDialog1: TSaveDialog;
    N66: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    N71: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    N74: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    N81: TMenuItem;
    N82: TMenuItem;
    N83: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    FAQ1: TMenuItem;
    N86: TMenuItem;
    N87: TMenuItem;
    N88: TMenuItem;
    N89: TMenuItem;
    N90: TMenuItem;
    N91: TMenuItem;
    N92: TMenuItem;
    N93: TMenuItem;
    N98: TMenuItem;
    N99: TMenuItem;
    N100: TMenuItem;
    N101: TMenuItem;
    N102: TMenuItem;
    N103: TMenuItem;
    N104: TMenuItem;
    N105: TMenuItem;
    N109: TMenuItem;
    N110: TMenuItem;
    N95: TMenuItem;
    N96: TMenuItem;
    N75: TMenuItem;
    SpeedButton4: TSpeedButton;
    SpeedButton16: TSpeedButton;
    N76: TMenuItem;
    N77: TMenuItem;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    N78: TMenuItem;
    N97: TMenuItem;
    N9: TMenuItem;
    N34: TMenuItem;
    N40: TMenuItem;
    N52: TMenuItem;
    test1: TMenuItem;
    N53: TMenuItem;
    N15: TMenuItem;
    Timer1: TTimer;
    N3D1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N39Click(Sender: TObject);
    procedure N45Click(Sender: TObject);
    procedure N46Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure N48Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure DXF1Click(Sender: TObject);
    procedure N58Click(Sender: TObject);
    procedure N59Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure DXFin1Click(Sender: TObject);
    procedure N50Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N65Click(Sender: TObject);
    procedure N54Click(Sender: TObject);
    procedure N56Click(Sender: TObject);
    procedure N55Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure N36Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N67Click(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure N96Click(Sender: TObject);
    procedure N74Click(Sender: TObject);
    procedure N93Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure N75Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure N77Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure N78Click(Sender: TObject);
    procedure N106Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure N57Click(Sender: TObject);
    procedure N73Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N62Click(Sender: TObject);
    procedure N63Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N69Click(Sender: TObject);
    procedure N90Click(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N3D1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure makmsht;
    procedure draword;
    procedure scrrot(x1,y1,x2,y2:integer);
    procedure scrmov(x1,y1,x2,y2:integer);
    procedure scrpan(x1,y1,x2,y2:integer);
    procedure cleansc;
    procedure drawdashrect(Clr:integer);
 end;

const
  READY = 0; GEN = 1; SUPP = 2;
  PROP = 3;  LOA = 4; COB = 5; SOLV = 6; OPT = 7;

  NDQST = 11 ;  BARQST = 12;     //  区分查询窗体内容
  MNDFORCE = 21;   MELEFORCE = 22;  //  输入节点,单元力
  MNDIN = 31;  MBARIN = 32;     // 区分wgm点和线

  SELSURFACE = 1;             //  选择一个面(导荷)
  ROTDOWN = 101;  MOVDOWN = 102;  PANDOWN = 103;

  DNONE = 0;  DMAT = 1;  DSEC = 2;  DGRP = 3;  //  display
  DDEF = 10;  DRED = 11;  DLY = 12; DSML = 13;      //  display
  INF = 1E20;   //  infinitve value

  // coef_sc = 70;
var
  MAINForm: TMAINForm;

  bx,by,ex,ey: integer;     //  框选起始点,终止点
  jz,jy,jx:single;          //  视图转角,绕z,y,x
  basex,basey,scale:single;      //  基点，比例
  basex0,basey0,scale0:single;      //  初始基点，初始比例
  msht:array[1..3,1..3] of single;  //  视图转角矩阵

  dpflag, flag3d: byte;        //  whether mouse is down , part draw 3d
  clr1: array [1..100] of integer;   // 备选颜色
  c_clr1: integer;               // 备选颜色数量
  path,workpath: string;

implementation

uses ent, VIEW ,ndinfo ,barinfo ,generate,
     new ,barres, model, inq, abt, mdch, load,
     comb, force, zxx, xl, js, sc, input;
{$R *.DFM}

procedure Tmainform.makmsht;  //  投影转换矩阵
begin
 msht[1,1]:=cos(jz)*cos(jy);
 msht[1,2]:=sin(jz)*cos(jx)+cos(jz)*sin(jy)*sin(jx);
 msht[1,3]:=sin(jz)*sin(jx)-cos(jz)*sin(jy)*cos(jx);
 msht[2,1]:=-sin(jz)*cos(jy);
 msht[2,2]:=cos(jz)*cos(jx)-sin(jz)*sin(jy)*sin(jx);
 msht[2,3]:=cos(jz)*sin(jx)+sin(jz)*sin(jy)*cos(jx);
 msht[3,1]:=sin(jy);
 msht[3,2]:=-cos(jy)*sin(jx);
 msht[3,3]:=cos(jy)*cos(jx);
end;

procedure Tmainform.draword;  //  画坐标轴
var
  i:byte;
  aa:string;
  dl,scdx,scdy:integer;
begin
  dl:=40;
 for i:=1 to 3 do
  begin
   scdx:=round(dl*msht[i,1]);   // x direction
   scdy:=round(dl*msht[i,2]);   // y direction
   with canvas do
    begin
     pen.width:=2;
     pen.style:=pssolid;
     pen.color:=cllime;
     moveto(50,height-150);
     lineto(50+scdx,height-150-scdy);
     font.color:=cllime;
     font.size:=5;
     if i=1 then aa:='X'
     else if i=2 then aa:='Y'
     else if i=3 then aa:='Z';
     textout(52+scdx,height-150-scdy,aa);
    end;
  end;
end;

procedure Tmainform.scrrot(x1,y1,x2,y2:integer);
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

  if (not N3D1.Checked) then
     begin
       cleansc; spf.drawspt(curdis);
     end
  else
    myDraw(@spf,scale,jx,jy,jz,basex-basex0,basey-basey0,flag3d);
end;

procedure Tmainform.scrpan(x1,y1,x2,y2:integer);
var
  dx,dy:single;
  a,a1,a2:single;
begin

  a:=1;
  a1:=ClientWidth/abs(x1-x2);
  a2:=ClientHeight/abs(y1-y2);
  if (a1>a2) and (a2<10) then
    a:=a2
  else if (a1<10) then
    a:=a1
  else
    showmessage('比例改变过大，请分多次完成!');

  basex:=(basex-x1)*a;
  basey:=ClientHeight-(ClientHeight-basey-y1)*a;
  scale:=a*scale;

  if (not N3D1.Checked) then
     begin
       cleansc; spf.drawspt(curdis);
     end
  else
    myDraw(@spf,scale,jx,jy,jz,basex-basex0,basey-basey0,flag3d);
end;

procedure Tmainform.scrmov(x1,y1,x2,y2:integer);

begin
  basex:=basex+x2-x1;
  basey:=basey-y2+y1;
  if (not N3D1.Checked) then
     begin
       cleansc; spf.drawspt(curdis);
     end
  else
    myDraw(@spf,scale,jx,jy,jz,basex-basex0,basey-basey0,flag3d);
end;

procedure TMAINForm.FormCreate(Sender: TObject);
var
  i,j,k:byte;
begin
  //   以下清屏幕
  canvas.brush.color:=clblack;
  cleansc;
  flag3d:=0;
  //   以下设置配置及工作路径
  path:=extractfilepath(application.exename)+'cfg\';  // 配置文件路径 !!!!
  workpath:=extractfilepath(application.exename)+'work\';  // 工作路径 !!!!
  opendialog1.initialdir:=workpath;
  //  以下初始化“步骤”及“状态”信息
  for i :=1 to 10 do
    curbv[i]:=0;
  curproc:= READY;
  curdis:= DNONE;
  //  以下自动生成一系列的颜色
 c_clr1:=0;
  for i:=4 downto 0 do
   for j:=4 downto 0 do
    for k:=4 downto 0 do
     if (i<>j) or (j<>k) or (k<>i) then
      if (i*i+j*j+k*k>19) and (i*i+j*j+k*k<34) then
        begin
         inc(c_clr1);
         clr1[c_clr1]:=abs(i*64-1)*65536+abs(j*64-1)*256+abs(k*64-1)
        end;
  //  以下禁止一些按钮
  N6.enabled:=false; N11.enabled:= false;
  N17.enabled:=false; N35.enabled:= false;
  N22.enabled:=false; N25.enabled:=false;

  //  以下设置初始值
  curproc:=READY;
  curdis:=DNONE;
  onResize(self);
end;

procedure Tmainform.cleansc;
var
  rect1:Trect;
begin
 rect1:=rect(0,0,width,height);
 with canvas do
    begin
     brush.color:=clblack;
     fillrect(rect1);
    end;
end;

procedure Tmainform.drawdashrect(Clr: integer);
begin
  with canvas do
    begin
       if Clr = 1 then pen.color:=clwhite
       else if Clr = 2 then pen.color:=clgreen;
       moveto(bx,by);
       lineto(ex,by);    lineto(ex,ey);
       lineto(bx,ey);    lineto(bx,by);
     end;
end;

procedure TMAINForm.N18Click(Sender: TObject);
var
  i:integer;
  a:byte;
begin               //  modify node information
   if spf<>nil then
   begin
   statusbar1.Panels.Items[8].Text:=' 输入节点约束';
   {a:=0;
    for i:=1 to spf.np do
       a:=a or spf.node[i].sel;
    if a <> 0 then }
    Application.CreateForm(TNODEINFO, NODEINFO);
   end;

end;

procedure TMAINForm.N19Click(Sender: TObject);
var
  i:integer;
  a:byte;
begin        //  MODIFY bar information
  if spf<>nil then
   begin
    statusbar1.Panels.Items[8].Text:=' 输入杆件信息';
    {a:=0;
     for i:=1 to spf.ne  do
       a:=a or spf.bar[i].sel;
     if a <> 0 then }
     Application.CreateForm(Tbinfo, binfo);
   end;
end;

procedure TMAINForm.SpeedButton5Click(Sender: TObject);
begin      //  display by section
 if N11.enabled=true then N46.onclick(self);
end;

procedure TMAINForm.SpeedButton6Click(Sender: TObject);
begin    // display by material
  if N11.enabled=true then N45.onclick(self);
end;

procedure TMAINForm.SpeedButton2Click(Sender: TObject);
begin         //  speed to open exist file
  DXF1.OnClick(self);
end;

procedure TMAINForm.N34Click(Sender: TObject);
begin     
  if wgm<>nil then
    begin
      wgm.savetodat;
      showmessage('几何文件已保存！');
    end;
end;

procedure TMAINForm.N23Click(Sender: TObject);
var
 i,j,k,nm:byte;
begin   //  CHECK SECTION  not modify
  if curbv[GEN]=0 then
    begin
     messagedlg('缺少总信息!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[SUPP]=0 then
    begin
     messagedlg('必须输入支座!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[PROP]=0 then
    begin
     messagedlg('必须输入材性!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[LOA]=0 then
    begin
      messagedlg('必须输入荷载!',mtwarning,[mbok],0);
      exit;
    end;
  if curbv[COB]=0 then
    begin
     messagedlg('必须输入工况!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[SOLV]=1 then
    begin
     messagedlg('结构分析已完成!',mtwarning,[mbok],0);
     exit;
    end;
  spf.PL_makgeofile(0);
  nm:=1;
  for i:=1 to 14 do
   begin
    if spf.comld[i,0]<0 then   //  comld[1~14,1~5] 记录组合系数
     for j:=i to 14  do        //  comld[1~14,0] 记录简化或一般组合
       for k:=0 to 5 do
        spf.comld[i,k]:=spf.comld[i+1,k];
   end;
  for i:=1 to 15 do
    if spf.comld[i,0]>0 then spf.PL_makloadfile(i);
  Application.CreateForm(Tjsform, jsform);

end;

procedure TMAINForm.N27Click(Sender: TObject);
begin
  //   spf.checkstrength(0.1,0.85);
end;

procedure TMAINForm.N39Click(Sender: TObject);
begin   //  display bar inner force by color
  if curbv[SOLV]=1 then Application.createform(Tbres,bres)
  else messagedlg('结构尚未分析!',mtconfirmation,[mbok],0);
end;

procedure TMAINForm.N45Click(Sender: TObject);
begin       //  material
  curdis:= DMAT;
  statusbar1.Panels.Items[4].Text:=' 按材料';
  cleansc;
  spf.drawspt(curdis);
end;

procedure TMAINForm.N46Click(Sender: TObject);
begin        //  section
  curdis:= DSEC;
  statusbar1.Panels.Items[4].Text:=' 按截面';
  cleansc;
  spf.drawspt(curdis);
end;

procedure TMAINForm.N41Click(Sender: TObject);
begin         //  top view
   viewform.vwt.onclick(self);
end;

procedure TMAINForm.N42Click(Sender: TObject);
begin          //  front view
   viewform.vwf.onclick(self);
end;

procedure TMAINForm.N43Click(Sender: TObject);
begin       //  left view
  viewform.vwl.onclick(self);
end;

procedure TMAINForm.N44Click(Sender: TObject);
begin        //   zheng deng zhou  view
  viewform.ct.onclick(self);
end;

procedure TMAINForm.N48Click(Sender: TObject);
begin    //   显示节点号
  N48.Checked := not N48.Checked;
  repaint;
    // Canvas.pen.Color:= cllime;  Canvas.Brush.Color:= claqua;
    // canvas.Brush.style:= bsDiagCross;
    // canvas.Polygon([Point(50, 50),Point(50, 80),Point(80, 80)]);
end;

procedure TMAINForm.N49Click(Sender: TObject);
begin    //   显示杆件号
  N49.Checked := not N49.Checked;
  repaint;
end;

procedure TMAINForm.N16Click(Sender: TObject);
var
  i,s:byte;
begin     //  check text information
   s:=0;
   for i:=1 to 5 do
     s:=s + curbv[i];
   if s=5 then
    shellexecute(handle,'open',pchar(workpath+'fpg.dat'),nil,nil,SW_SHOWNORMAL)
   else
    messagedlg('结构输入未完成!',mtwarning,[mbok],0);
   
end;

procedure TMAINForm.N20Click(Sender: TObject);
var
  i:byte;
begin      //  SHOW TXT RESULT FILE
   if (curbv[SOLV]=1) or (curbv[OPT]=1) then
    shellexecute(handle,'open',pchar(spf.ffn+'_res.dat'),nil,nil,SW_SHOWNORMAL)
   else
    messagedlg('结构分析未完成!',mtwarning,[mbok],0);
   
end;

procedure TMAINForm.N24Click(Sender: TObject);
var
  i,j,k,nm:byte;
begin   //  DESIGN (modify section)
  if curbv[GEN]=0 then
    begin
     messagedlg('缺少总信息!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[SUPP]=0 then
    begin
     messagedlg('必须输入支座!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[PROP]=0 then
    begin
     messagedlg('必须输入材性!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[LOA]=0 then
    begin
      messagedlg('必须输入荷载!',mtwarning,[mbok],0);
      exit;
    end;
  if curbv[COB]=0 then
    begin
     messagedlg('必须输入工况!',mtwarning,[mbok],0);
     exit;
    end;
  if curbv[OPT]=1 then
    begin
     messagedlg('结构优化已完成!',mtwarning,[mbok],0);
     exit;
    end;
  spf.PL_makgeofile(1);
  nm:=1;
  for i:=1 to 14 do
   begin
    if spf.comld[i,0]<0 then
     for j:=i to 14  do
       for k:=0 to 5 do
        spf.comld[i,k]:=spf.comld[i+1,k];
   end;
  for i:=1 to 15 do
   begin
    if spf.comld[i,0]>0 then  spf.PL_makloadfile(i);
   end;
 Application.CreateForm(Tjsform, jsform);
end;

procedure TMAINForm.N21Click(Sender: TObject);
begin   //  close a project
  //  if N25.enabled=true then freemem(spf.zd);
  if spf<>nil then
   begin
     spf.free; spf:=nil;
   end;
  if wgm<>nil then
   begin
    wgm.free;  wgm:=nil;
   end;
   cleansc;
   speedbutton5.down:=false;
   speedbutton6.down:=false;
   curdis:=DNONE;
   statusbar1.Panels.Items[2].Text:=' ';
   viewform.abortproc;
   viewform.enabled:=false;
end;

procedure TMAINForm.SpeedButton8Click(Sender: TObject);
begin    //  node input information
  if N17.enabled=true then N18.onclick(self);
end;

procedure TMAINForm.SpeedButton9Click(Sender: TObject);
begin     //  bar input information
  if N17.enabled=true then N19.onclick(self);
end;

procedure TMAINForm.SpeedButton12Click(Sender: TObject);
begin    // CHECK SECTION
 if N22.enabled=true then N23.onclick(self);
end;

procedure TMAINForm.SpeedButton13Click(Sender: TObject);
begin    // DESIGN ELEMENT
  if N22.enabled=true then N24.onclick(self);
end;

procedure TMAINForm.SpeedButton14Click(Sender: TObject);
begin    //  display result txt
  if N25.enabled=true then N20.onclick(self);
end;

procedure TMAINForm.DXF1Click(Sender: TObject);
var
  dtfnm:string;
  ik:byte;
  lstr:string;
  a1:array[1..2] of integer;
  f1:textfile;
  f:file;
  i,np1,ne1:integer;
begin    //  read dat | dxf | bin file as structure
  if opendialog1.execute then
   begin
   if (spf<>nil) or (wgm<>nil) then
     begin
       messagedlg('请先关闭当前模型!',mtwarning,[mbok],0);
       exit;
     end;
   dtfnm:= lowercase(opendialog1.filename);
   workpath:=extractfilepath(dtfnm);
   ik:=1;
   while (dtfnm[ik]<>'.') do ik:=ik+1;

   if (dtfnm[ik+1] in ['d','D']) and (dtfnm[ik+2] in ['x','X']) and (dtfnm[ik+3] in ['f','F']) then
     begin
       dtfnm[ik+1]:='d';  dtfnm[ik+2]:='a';
       dtfnm[ik+3]:='t';
       wgm:=Tmodel.init;
      if (wgm.readdxf(opendialog1.filename)=1) then
       begin
         wgm.dxf2txt(dtfnm);
         wgm.Free; wgm:=nil;
       end
      else
       begin
        messagedlg('DXF文件读取异常!',mtwarning,[mbok],0);
        wgm.Free; wgm:=nil;
        exit;
       end;
     end
   else if (dtfnm[ik+1]='b') and (dtfnm[ik+2]='i') and (dtfnm[ik+3]='n') then
    begin
      assignfile(f, dtfnm);
      reset(f,1);
      seek(f,0);
      blockread(f,a1,sizeof(a1));
      closefile(f);
      spf:=Tspg.init(a1[2],a1[1]);
      spf.ffn:=leftstr(dtfnm,pos('.',dtfnm)-1);
      spf.readall(dtfnm);
      jx:=-54.7356*PI/180;
      jz:=-PI/4;
      jy:=0;

     spf.drawspt(curdis);
     statusbar1.Panels.Items[2].Text:=' 结构模型';
     N6.enabled:=false; N11.enabled:= TRUE;
     N17.enabled:=TRUE; N35.enabled:= TRUE;
     N22.enabled:=true;
     N25.enabled:=false;
     viewform.enabled:=true;
     exit;
    end;

    assignfile(f1,dtfnm);
     reset(f1);
    readln(f1,lstr);
    if strpos(pchar(lstr),'np')<>nil then
     readln(f1,np1,ne1)
    else
     begin
      messagedlg('文件格式有错!',mtwarning,[mbok],0);
      exit;
     end;
    closefile(f1);

    spf:=Tspg.init(np1,ne1);
    //  read simple format infile
    cleansc;
    spf.ffn:=leftstr(dtfnm,pos('.',dtfnm)-1);
    spf.readinfile_s(dtfnm);
    for i:= 1 to spf.ne do
     begin
      spf.bar[i].mat:=0;
      spf.bar[i].sec:=0;
      spf.bar[i].sel:=0;
      spf.bar[i].setlen;
     end;

    jx:=-54.7356*PI/180;
    jz:=-PI/4;
    jy:=0;

    spf.drawspt(curdis);
    statusbar1.Panels.Items[2].Text:=' 结构模型';
    N6.enabled:=false; N11.enabled:= TRUE;
    N17.enabled:=TRUE; N35.enabled:= TRUE;
    N22.enabled:=true;
    N25.enabled:=false;
    viewform.enabled:=true;

  end;    //  end of dialogbox check
 end;

procedure TMAINForm.N58Click(Sender: TObject);
var
  i,a:integer;
  tmp:^integer;
  str:string;
  x1,y1,z1:single;
begin      //  node inquire
  if spf<>nil then
   begin
    curproc:=NDQST;
    a:=0;
    statusbar1.Panels.Items[8].Text:=' 查询节点信息';
    for i:=1 to spf.np do
      if spf.node[i].sel=1 then
         begin
           a:=i;   break;
         end;

    if a <> 0 then
     begin
       //  相连结点信息 开始
       str:='';
       for i:=0 to spf.node[a].linkelements.Count-1 do
         begin
           tmp:= spf.node[a].linknodes.Items[i];
           str:=str + '点: '+inttostr(tmp^) + ', ';
           tmp:= spf.node[a].linkelements.Items[i];
           str:=str + '杆: '+inttostr(tmp^) + #13;
         end;
       showmessage(str);
       //   相连结点信息 结束
       Application.CreateForm(Tinqform, inqform);
     end;
   end;
end;

procedure TMAINForm.N59Click(Sender: TObject);
var
  i:integer;
  a:byte;
begin            //  inquire bar
 if spf<>nil then
  begin
  curproc:=BARQST;
  a:=0;
    statusbar1.Panels.Items[8].Text:=' 查询杆件信息';
  for i:=1 to spf.ne  do
    a:=a or spf.bar[i].sel;
  if a <> 0 then
    Application.CreateForm(Tinqform, inqform);
  end;
end;

procedure TMAINForm.N29Click(Sender: TObject);
begin
  Application.CreateForm(Tabtform, abtform);
end;

procedure TMAINForm.SpeedButton15Click(Sender: TObject);
begin
  N29.onclick(self);
end;

procedure TMAINForm.DXFin1Click(Sender: TObject);
var
  dtfnm:string;
  ik:byte;
  lstr:string;
  f:textfile; 
  i:integer;
begin   //  read dat & dxf file as geo
  if opendialog1.execute then
   begin
   if (spf<>nil) or (wgm<>nil) then
     begin
       messagedlg('请先关闭当前模型!',mtwarning,[mbok],0);
       exit;
     end;
   dtfnm:= opendialog1.filename;
   ik:=1;
   wgm:=Tmodel.init;

   while (dtfnm[ik]<>'.') do ik:=ik+1;
   if (dtfnm[ik+1]='d') and  (dtfnm[ik+2]='x') and (dtfnm[ik+3]='f') then
     begin
      dtfnm[ik+1]:='d';  dtfnm[ik+2]:='a';
      dtfnm[ik+3]:='t';
      if (wgm.readdxf(opendialog1.filename)=1) then
         wgm.dxf2txt(dtfnm)
      else
        begin
          messagedlg('DXF文件读取异常!',mtwarning,[mbok],0);
          wgm.Free;  wgm:=nil;
          exit;
        end;
      end
    else if (wgm.readtxt(opendialog1.filename)<>1) then
      begin
        messagedlg('DAT文件读取异常!',mtwarning,[mbok],0);
        wgm.Free;  wgm:=nil;
        exit;
      end;

   cleansc;

    jx:=-54.7356*PI/180;
    jz:=-PI/4;
    jy:=0;
    wgm.drawmodel;
    statusbar1.Panels.Items[2].Text:=' 几何模型';
    N6.enabled:=TRUE; N11.enabled:= TRUE;
    N17.enabled:=false;
    N35.enabled:= TRUE;
    N22.enabled:=false;
    N25.enabled:=false;
    viewform.enabled:=true;
  end;
end;  // end of if opendialog execute

procedure TMAINForm.N50Click(Sender: TObject);
begin        // create node
  Application.CreateForm(Tmdchform, mdchform);
  with mdchform.gb1 do
   begin
    top:=0; left:=8; show;
   end;
end;

procedure TMAINForm.N61Click(Sender: TObject);
begin   //   popup delete
  N57.OnClick(self);
end;

procedure TMAINForm.N51Click(Sender: TObject);
begin   // create line between node
   wgm.link2node;
   cleansc;
   wgm.drawmodel;  
end;

procedure TMAINForm.N65Click(Sender: TObject);
begin     //  no operation
  wgm.clear_sel;
  cleansc;
  wgm.drawmodel;
end;

procedure TMAINForm.N54Click(Sender: TObject);
var
  ia: byte;
  x0,y0,z0: single;
begin   //  model node move
  Application.CreateForm(Tmdchform, mdchform);
  ia:=wgm.onenodesel(x0,y0,z0);
  if ia=1 then          //  only one selected
   with mdchform.gb2 do
    begin
      top:=0; left:=8; show;
    end
  else if ia=2 then      //  many selected 
    with mdchform.gb4 do
    begin
      top:=0; left:=8; show;
    end

end;

procedure TMAINForm.N56Click(Sender: TObject);
begin    //  model node rotate
  Application.CreateForm(Tmdchform, mdchform);
  with mdchform.gb3 do
   begin
    top:=0; left:=8; show;
   end;
 
end;

procedure TMAINForm.N55Click(Sender: TObject);
begin         //  model node copy
 Application.CreateForm(Tmdchform, mdchform);
  if (viewform.d.down=true) then
    with mdchform.gb5 do
       begin
        top:=0; left:=8; show;
       end
   else if (viewform.h.down=true) then
     with mdchform.gb6 do
       begin
        top:=0; left:=8; show;
       end
end;

procedure TMAINForm.N4Click(Sender: TObject);
begin    //  save to dat file
  
end;

procedure TMAINForm.SpeedButton3Click(Sender: TObject);
begin     //  shortcut of save
  n40.onclick(self);
end;

procedure TMAINForm.N36Click(Sender: TObject);
begin  //input load
  statusbar1.Panels.Items[8].Text:=' 输入荷载情况';
  Application.CreateForm(Tloadform, loadform);
  mainform.enabled:=false;
end;

procedure TMAINForm.N37Click(Sender: TObject);
begin   //  condition combination
  statusbar1.Panels.Items[8].Text:=' 输入组合工况';
  Application.CreateForm(Tcombform, combform);
  mainform.enabled:=false;
end;

procedure TMAINForm.N67Click(Sender: TObject);
begin    //  shortcut of link2node
  n51.onclick(self);
end;

procedure TMAINForm.N81Click(Sender: TObject);
begin
  Application.CreateForm(Tzxxform, zxxform);
  mainform.enabled:=false;
end;

procedure TMAINForm.N96Click(Sender: TObject);   //  show no force
begin
  spf.curfc:=0;
  cleansc;
  spf.drawspt(curdis);
  statusbar1.panels.items[6].text:='';
end;

procedure TMAINForm.N74Click(Sender: TObject);
begin        //  show force
  Application.CreateForm(Txlform, xlform);
  mainform.enabled:=false;
end;

procedure TMAINForm.N93Click(Sender: TObject);
begin    //  显示节点位移
  //  若读取结果文件正常
  curdis:=DDEF;
  cleansc;
  spf.drawspt(curdis);   //  draw deformation

end;

procedure TMAINForm.SpeedButton7Click(Sender: TObject);
begin    //   shortcut show force
  if N11.enabled=true then n74.onclick(self);
end;

procedure TMAINForm.N75Click(Sender: TObject);
begin  //  操作面板显示与否
  n75.checked:=not n75.checked;
  if (n75.checked=false) and (viewform<>nil) then
    viewform.close
  else if n75.checked=true then
    begin
     Application.CreateForm(TVIEWFORM, VIEWFORM);
     viewform.enabled:=true;
    end;
end;

procedure TMAINForm.SpeedButton4Click(Sender: TObject);
begin
  if N17.enabled=true then N36.onclick(self);
end;

procedure TMAINForm.SpeedButton16Click(Sender: TObject);
begin
  if N17.enabled=true then N37.onclick(self);
end;

procedure TMAINForm.N77Click(Sender: TObject);
begin
    Application.CreateForm(Tscform, scform);
    enabled:=false;
end;

procedure TMAINForm.SpeedButton11Click(Sender: TObject);
begin
  if N17.enabled=true then N58.onclick(self);
end;

procedure TMAINForm.SpeedButton17Click(Sender: TObject);
begin
  if N17.enabled=true then N59.onclick(self);
end;

procedure TMAINForm.N78Click(Sender: TObject);
begin       //   工况选择
  Application.CreateForm(TinputForm, inputForm);
end;

procedure TMAINForm.N106Click(Sender: TObject);
begin       //  general result file

end;

procedure TMAINForm.SpeedButton10Click(Sender: TObject);
begin       //  general information
  if N17.enabled=true then N81.onclick(self);
end;

procedure TMAINForm.N57Click(Sender: TObject);
begin     //  delete node in geo medel
   if (viewform.d.down=true) then
     begin
      if (messagedlg('节点删除?',mtconfirmation,[mbok,mbcancel],0)=mrok) then
       begin
        wgm.delend;
          cleansc;
        wgm.drawmodel;
       end;
     end
   else if (viewform.h.down=true) then
    begin
     if (messagedlg('杆件删除?',mtconfirmation,[mbok,mbcancel],0)=mrok) then
       begin
        wgm.deleel;
          cleansc;
        wgm.drawmodel;
       end;
    end;
end;

procedure TMAINForm.N73Click(Sender: TObject);
begin       // NO property
  curdis:= DNONE;
  statusbar1.Panels.Items[4].Text:='';
  cleansc;
  spf.drawspt(curdis);
end;

procedure TMAINForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  a:byte;
  i:integer;
begin
  if  Button = mbleft then   // left mouse key
    begin
      bx:=x;
      by:=y;
     if ((curproc<100) or (curproc = PANDOWN))  then    //  画虚线
      begin
        ex:=x;
        ey:=y;
        with canvas do
          begin
           pen.style:=psdot;
           pen.mode:=pmxor;
          end;
        drawdashrect(1);
        dpflag:=1;
       end;
    end
  else if Button = mbright then   //  right mouse key 作取消用
    begin
     a:=0;
     if curproc = MNDFORCE then   //  显示节点三向力窗体
      begin
       for i:=1 to spf.np do
          a:=a or spf.node[i].sel;
       if a <> 0 then
          Application.CreateForm(Tforceform, forceform);
      end
     else if curproc = SELSURFACE then  //  选受荷面
      begin
        loadform.show;
      end;
      viewform.abortproc;

    end;
end;

procedure TMAINForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  a,b:byte;
  i:integer;
begin
   if (Button = mbright) and (wgm<>nil) then
       popupmenu1.Popup(X,Y+40); 
   if (curproc<100) and (dpflag=1) then   //  画虚线
   begin
    drawdashrect(0);
    canvas.pen.mode:=pmcopy;
    dpflag:=0;
    if (spf<>nil) and (viewform<>nil) then   // first select & then operate!
      begin
       a:=0;
       if viewform.d.down=true then   //  选点
        for i:=1 to spf.np do
          begin
           if viewform.a.down=true then //   框选
             a:=a or spf.node[i].isinrect(bx,by,ex,ey)
           else if viewform.e.down=true then  //  点选
             a:=a or spf.node[i].isnearpoint(bx,by)
           else if viewform.i.down=true then   //  组选
             a:=a or spf.node[i].isinrect(bx,by,ex,ey);
          end
       else if viewform.h.down= true then    //  选杆
         for i:=1 to spf.ne do
          begin
           if viewform.a.down=true then     //   框选
             a:=a or spf.bar[i].isinrect(bx,by,ex,ey)
           else if viewform.e.down=true then  //  点选
             a:=a or spf.bar[i].isnearpoint(bx,by)
           else if viewform.i.down=true then   //  组选
             a:=a or spf.bar[i].isinrect(bx,by,ex,ey);
          end;

     if a=1 then  //  至少选中了一个
       begin
        cleansc;
        spf.drawspt(curdis);

       end;
      end;

     if (wgm<>nil) and (viewform<>nil) then   //  model mode
       begin
         a:=0;
         if viewform.d.down=true then    // select point
          begin
           if viewform.a.down=true then    //  框选
             a:=a or wgm.nodeinrect(bx,by,ex,ey);
          end;
         if  viewform.h.down=true then    // select bar
          begin
           if viewform.a.down=true then   //  框选
             a:=a or wgm.eleinrect(bx,by,ex,ey);
          end;

         if a=1 then
            begin
             cleansc;
             wgm.drawmodel;
            end;
       end;

    if curproc in [SELSURFACE] then     //  捕捉杆件
      begin
       if spf<>nil then       //  structure mode
         begin
          a:=0;
          for i:=1 to spf.ne do
           begin
             if viewform.a.down=true then //  框选
                a:=a or spf.bar[i].isinrect(bx,by,ex,ey)
             else if viewform.e.down=true then  //  点选
                a:=a or spf.bar[i].isnearpoint(bx,by)
             else if viewform.i.down=true then   //  组选
                a:=a or spf.bar[i].isinrect(bx,by,ex,ey);
           end;
          if a=1 then
            begin
             cleansc;
             spf.drawspt(curdis);
            end;

         end;   //  end of if spf<>nil

     end;       //   end of if 捕捉杆件

    end  //   end of draw dashed line

  else if curproc = ROTDOWN then     //  旋转
    begin
      if spf<>nil then scrrot(bx,by,x,y)
      else if wgm<>nil then wgm.modelrot(bx,by,x,y);
    end
  else if curproc = MOVDOWN then     //  移动
    begin
      if spf<>nil then scrmov(bx,by,x,y)
      else if wgm<>nil then wgm.modelmov(bx,by,x,y);
    end
  else if curproc = PANDOWN then     //  窗口放大
    begin
      drawdashrect(0);
      canvas.pen.mode:=pmcopy;
      dpflag:=0;
      if spf<>nil then scrpan(bx,by,x,y)
      else if wgm<>nil then wgm.modelpan(bx,by,x,y);
    end;
end;

procedure TMAINForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if ((curproc<100) or (curproc = PANDOWN)) and (dpflag=1) then    //  画虚线
  begin
    drawdashrect(0);
    ex:=x;
    ey:=y;
    if ex<bx then
       drawdashrect(2)   //  倒选绿色框
    else
       drawdashrect(1);   //  正选白色框
  end;

end;

procedure TMAINForm.FormPaint(Sender: TObject);
begin
  if (spf<>nil) and (N3D1.Checked) then
    myDraw(@spf,scale, jx, jy, jz, basex-basex0,basey-basey0,flag3d)
  else if spf<>nil then
    spf.drawspt(curdis)
  else if wgm<>nil then
    wgm.drawmodel;
end;

procedure TMAINForm.N5Click(Sender: TObject);
begin
  if (spf<>nil) then spf.Free;
  if (wgm<>nil) then wgm.Free;
  application.Terminate;
end;

procedure TMAINForm.N33Click(Sender: TObject);
begin
   showmessage('本功能暂不可用');
end;

procedure TMAINForm.N32Click(Sender: TObject);
begin
  if (spf<>nil) or (wgm<>nil) then
   begin
     messagedlg('请先关闭当前模型!',mtwarning,[mbok],0);
     exit;
   end;
  Application.CreateForm(Tcreatewj, createwj);
end;

procedure TMAINForm.N62Click(Sender: TObject);
begin
  N55.OnClick(self);
end;

procedure TMAINForm.N63Click(Sender: TObject);
begin
  N54.onclick(self);
end;

procedure TMAINForm.N9Click(Sender: TObject);
begin
  N56.OnClick(self);
end;

procedure TMAINForm.N69Click(Sender: TObject);
var
  x1,y1,z1:single;
begin
  if wgm<>nil then
   begin
    if wgm.onenodesel(x1,y1,z1)=1 then
      begin
          Application.CreateForm(Tmdchform, mdchform);
          mdchform.label35.caption:='X = '+ format('%9.3f',[x1])+' 米';
          mdchform.label36.caption:='Y = '+ format('%9.3f',[y1])+' 米';
          mdchform.label37.caption:='Z = '+ format('%9.3f',[z1])+' 米';
        with mdchform.gb7 do
         begin
          top:=0; left:=8; show;
         end;
      end
    else
      showmessage('请选择一个节点!');
   end;
end;

procedure TMAINForm.N90Click(Sender: TObject);
begin
   viewform.mv.onclick(self);
end;

procedure TMAINForm.N91Click(Sender: TObject);
begin
  viewform.usr.onclick(self);
end;

procedure TMAINForm.N40Click(Sender: TObject);
begin
  if spf<>nil then
   begin
    if spf.writeall(spf.ffn+'.bin')=1 then
       showmessage('保存BIN文件成功！')
    else
       showmessage('保存BIN文件出错！')
   end;
end;

procedure TMAINForm.N52Click(Sender: TObject);
begin
  N69.OnClick(self);
end;

procedure TMAINForm.N53Click(Sender: TObject);
var
  a:integer;
begin
  a := spf.maxnodedist;
  showmessage('结构的半带宽为 '+inttostr(a));
end;

procedure TMAINForm.N15Click(Sender: TObject);
var
  np1,ne1,i:integer;
  fname: string;
begin  //  带宽优化
   np1 := spf.np;
   ne1 := spf.ne;
   fname := spf.ffn+'_opt.dat';
   spf.nodelinkopt;
   showmessage('带宽优化完毕，重新载入结构!');
   N21.OnClick(self);

   spf:=Tspg.init(np1,ne1);
   cleansc;
   // fname := workpath + 'opttmp.dat';
   spf.ffn:=leftstr(fname,pos('.',fname)-1);
    spf.readinfile_s(fname);
    for i:= 1 to spf.ne do
     begin
      spf.bar[i].mat:=0;   spf.bar[i].sec:=0;
      spf.bar[i].sel:=0;   spf.bar[i].setlen;
     end;

    jx:=-54.7356*PI/180;
    jz:=-PI/4;
    jy:=0;

    spf.drawspt(curdis);
    statusbar1.Panels.Items[2].Text:=' 结构模型';
    N6.enabled:= false; N11.enabled:= TRUE;
    N17.enabled:= TRUE; N35.enabled:= TRUE;
    N22.enabled:= true; N25.enabled:= false;
    viewform.enabled:=true;

end;

procedure TMAINForm.N3D1Click(Sender: TObject);
begin
  if (not N3D1.Checked) then
    begin
      N3D1.checked := true;
      CreateDC(self.Handle);
    end
  else  N3D1.checked := false;

  repaint;

end;

procedure TMAINForm.FormResize(Sender: TObject);
begin
  basex0:=round(clientwidth/2);
  basey0:=round(clientheight/2+panel1.Height/2-statusbar1.Height/2);
  basex:=basex0;   
  basey:=basey0;
  if N3D1.Checked then CreateDC(self.Handle);
  repaint;
end;

end.

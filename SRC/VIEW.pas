unit VIEW;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls;

type
  TVIEWFORM = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    usr: TSpeedButton;
    vwt: TSpeedButton;
    nn: TSpeedButton;
    rdr: TSpeedButton;
    big: TSpeedButton;
    nd: TSpeedButton;
    vwf: TSpeedButton;
    ct: TSpeedButton;
    vwl: TSpeedButton;
    mv: TSpeedButton;
    el: TSpeedButton;
    sml: TSpeedButton;
    A: TSpeedButton;
    B: TSpeedButton;
    wd: TSpeedButton;
    D: TSpeedButton;
    E: TSpeedButton;
    F: TSpeedButton;
    H: TSpeedButton;
    G: TSpeedButton;
    J: TSpeedButton;
    K: TSpeedButton;
    I: TSpeedButton;
    SP: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton5: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure abortproc;
    procedure vwtClick(Sender: TObject);
    procedure usrClick(Sender: TObject);
    procedure vwfClick(Sender: TObject);
    procedure vwlClick(Sender: TObject);
    procedure bigClick(Sender: TObject);
    procedure smlClick(Sender: TObject);
    procedure ctClick(Sender: TObject);
    procedure mvClick(Sender: TObject);
    procedure rdrClick(Sender: TObject);
    procedure ndClick(Sender: TObject);
    procedure elClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wdClick(Sender: TObject);
    procedure GClick(Sender: TObject);
    procedure KClick(Sender: TObject);
    procedure FClick(Sender: TObject);
    procedure JClick(Sender: TObject);
    procedure DClick(Sender: TObject);
    procedure HClick(Sender: TObject);

    procedure nnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton12MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VIEWFORM: TVIEWFORM;

implementation

uses MAIN , ent, model, show3d ;

{$R *.DFM}
procedure view_draw;
begin
  if (spf<>nil) and (mainform.N3D1.Checked) then
    myDraw(@spf,scale,jx,jy,jz,basex-basex0,basey-basey0,flag3d)
  else if spf<>nil then
    spf.drawspt(curdis)
  else if wgm<>nil then
    wgm.drawmodel;
end;

procedure TVIEWFORM.FormCreate(Sender: TObject);
begin
  height:=115;  width:=120;
  top:=mainform.height-height-35;
  left:=mainform.width-width-20;
  enabled:=false;
end;

procedure TVIEWFORM.vwtClick(Sender: TObject);
begin      //  top view
  mainform.cleansc;
  abortproc;
  jz:=0;  jx:=0;  jy:=0;
  view_draw;
end;

procedure TVIEWFORM.usrClick(Sender: TObject);
begin     // user view rot
    if curproc<100 then lastproc:=curproc;
    curproc:=ROTDOWN ;
    usr.down:=true;
    mainform.Cursor:=crHandPoint;
end;

procedure TVIEWFORM.vwfClick(Sender: TObject);
begin    //  front view
  mainform.cleansc;
  abortproc;
  jz:=0;  jx:=-PI/2;  jy:=0;
  view_draw;
end;

procedure TVIEWFORM.vwlClick(Sender: TObject);
begin  //  left view
  mainform.cleansc;
  abortproc;
  jz:=-PI/2;  jx:=-PI/2;  jy:=0;
  view_draw;
end;

procedure TVIEWFORM.bigClick(Sender: TObject);
begin      //  bigger
  mainform.cleansc;
  abortproc;
  scale:=scale*1.414;
  view_draw;
end;

procedure TVIEWFORM.smlClick(Sender: TObject);
begin   //  smaller
  mainform.cleansc;
  abortproc;
  scale:=scale*0.707;
  view_draw;
end;

procedure TVIEWFORM.ctClick(Sender: TObject);
begin    //  正等轴
  mainform.cleansc;
  abortproc;
  jz:=-PI/4;  jx:=-54.7356*PI/180;  jy:=0;
  view_draw;
end;

procedure TVIEWFORM.mvClick(Sender: TObject);
begin   //  user  move
   if curproc <100 then lastproc:=curproc;
   curproc:=MOVDOWN;
   mv.down:=true;
   mainform.Cursor:=crSizeAll;
end;

procedure TVIEWFORM.rdrClick(Sender: TObject);
begin    //  redraw
  mainform.cleansc;
  view_draw;
end;

procedure TVIEWFORM.ndClick(Sender: TObject);
begin     //  node number
  mainform.N48.onclick(self);
end;

procedure TVIEWFORM.elClick(Sender: TObject);
begin     //  bar number
  mainform.N49.onclick(self);
end;

procedure TVIEWFORM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.n75.checked:=false;
end;

procedure TVIEWFORM.wdClick(Sender: TObject);
begin    // 窗口放大
  if curproc<100 then lastproc:=curproc;
    curproc:=PANDOWN ;
    wd.down:=true;
   mainform.Cursor:=crDrag;

end;

procedure TVIEWFORM.abortproc;
begin
  if curproc>100 then   // rotate or move or pan finished
     begin
         mv.down:=false;
         usr.down:=false;
         wd.down:=false;
         curproc:=lastproc;
         mainform.cursor:=crCross;
     end;
end;

procedure TVIEWFORM.GClick(Sender: TObject);
begin    // +45
  mainform.cleansc;
  jy:=jy+PI/4;
  view_draw;
end;

procedure TVIEWFORM.KClick(Sender: TObject);
begin        // display all
  mainform.cleansc;
  abortproc;
  scale:=scale0;
  basex:= basex0;
  basey:= basey0;
  //  jz:=-PI/4;
  //  jx:=-54.7356*PI/180;
  //  jy:=0;
  view_draw;
end;

procedure TVIEWFORM.FClick(Sender: TObject);
var
  i:integer;
begin     //  all select
  mainform.cleansc;
  if spf<>nil then
   begin
    if d.down=true then
     for i:=1 to spf.np do
       spf.node[i].sel:=1
    else if h.down=true then
     for i:=1 to spf.ne do
       spf.bar[i].sel:=1;
    spf.drawspt(curdis);
   end
  else if wgm<>nil then
   begin
    //  reserved function
    wgm.drawmodel;
   end;
end;

procedure TVIEWFORM.JClick(Sender: TObject);
var
  i:integer;
begin     //  select none selected
   mainform.cleansc;
  if spf<>nil then
   begin
    if d.down=true then
     for i:=1 to spf.np do
      if spf.node[i].sel=0 then spf.node[i].sel:=1
      else spf.node[i].sel:=0
    else if h.down=true then
      for i:=1 to spf.ne do
       if spf.bar[i].sel=0 then spf.bar[i].sel:=1
       else spf.bar[i].sel:=0;

    spf.drawspt(curdis);
   end
  else if wgm<>nil then
   begin
    //  reserved function
    wgm.drawmodel;
   end;
end;

procedure TVIEWFORM.DClick(Sender: TObject);
var
  i:integer;
begin
if spf <> nil then
 begin
   for i:=1 to spf.np do
     spf.node[i].sel:=0;
   for i:=1 to spf.ne do
     spf.bar[i].sel:=0;
   mainform.cleansc;
   spf.drawspt(curdis);
 end
else if wgm<>nil then
 begin
   wgm.clear_sel;
   mainform.cleansc;
   wgm.drawmodel;
 end;

end;

procedure TVIEWFORM.HClick(Sender: TObject);
var
  i:integer;
begin
  if spf <> nil then
 begin
   for i:=1 to spf.np do
     spf.node[i].sel:=0;
   for i:=1 to spf.ne do
     spf.bar[i].sel:=0;
   mainform.cleansc;
   spf.drawspt(curdis);
 end
else if wgm<>nil then
 begin
   wgm.clear_sel;
   mainform.cleansc;
   wgm.drawmodel;
 end;
end;

procedure TVIEWFORM.nnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   abortproc;
   panel2.left:=-112;
   panel2.top:=8;

end;

procedure TVIEWFORM.SPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   panel2.top:=8;
   panel2.left:=0;

end;

procedure TVIEWFORM.SpeedButton12MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button=mbleft then
   begin
    panel2.top:=8;
    panel2.left:=0;
   end
  else if button= mbright then
   begin
     panel2.top:=8;
     panel2.left:=-112;
   end;
end;

procedure TVIEWFORM.BClick(Sender: TObject);
var
 i:integer;
begin         //   不选
  mainform.cleansc;
  if spf<>nil then
   begin
    if d.down=true then
     for i:=1 to spf.np do
       spf.node[i].sel:=0
    else if h.down=true then
     for i:=1 to spf.ne do
       spf.bar[i].sel:=0;
    spf.drawspt(curdis);
   end
  else if wgm<>nil then
   begin
    //  reserved function
    wgm.drawmodel;
   end;
end;

end.

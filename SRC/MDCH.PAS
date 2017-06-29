unit mdch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  Tmdchform = class(TForm)
    GB1: TGroupBox;
    GB2: TGroupBox;
    GB4: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    RB1: TRadioButton;
    RB2: TRadioButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GB5: TGroupBox;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    GB3: TGroupBox;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    x1: TRadioButton;
    y1: TRadioButton;
    z1: TRadioButton;
    CheckBox1: TCheckBox;
    Label22: TLabel;
    Label23: TLabel;
    Edit15: TEdit;
    Label24: TLabel;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit16: TEdit;
    Label25: TLabel;
    gb6: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    gb7: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    BitBtn13: TBitBtn;
    RBa: TRadioButton;
    Edit20: TEdit;
    procedure RB2Click(Sender: TObject);
    procedure RB1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure y1Click(Sender: TObject);
    procedure z1Click(Sender: TObject);
    procedure x1Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mdchform: Tmdchform;

implementation
uses model, MAIN;
{$R *.DFM}

procedure Tmdchform.RB2Click(Sender: TObject);
begin   //  absolute ordinate
  label7.caption:='X =';
  label8.caption:='Y =';
  label9.caption:='Z =';
end;

procedure Tmdchform.RB1Click(Sender: TObject);
begin
  label7.caption:='¦¤X =';
  label8.caption:='¦¤Y =';
  label9.caption:='¦¤Z =';
end;

procedure Tmdchform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gb1.hide; gb2.hide; gb3.hide;
  gb4.hide; gb5.hide; gb6.hide; gb7.hide;
  mainform.enabled:=true;
  wgm.selnd(0);
  mainform.cleansc;
  wgm.drawmodel;
end;

procedure Tmdchform.BitBtn3Click(Sender: TObject);
var
  dd:byte;
  xx,yy,zz:single;
begin    //  move single node
  if rb2.checked=true then dd:=1  //  absolute
  else if rb1.checked=true then dd:=0;  // relative
  xx:=strtofloat(edit4.text);
  yy:=strtofloat(edit5.text);
  zz:=strtofloat(edit6.text);
  wgm.movenodeone(xx,yy,zz,dd);
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

procedure Tmdchform.BitBtn4Click(Sender: TObject);
begin  //  move single node abort
  close;
end;

procedure Tmdchform.BitBtn1Click(Sender: TObject);
var
  x,y,z:single;
begin    //  create node
  x:=strtofloat(edit1.text);
  y:=strtofloat(edit2.text);
  z:=strtofloat(edit3.text);
  wgm.createnodeone(x,y,z);
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

procedure Tmdchform.BitBtn2Click(Sender: TObject);
begin  //  create node abort

  close;
end;

procedure Tmdchform.BitBtn7Click(Sender: TObject);
var
  ddx,ddy,ddz:single;
begin     //  copy node
  ddx:=strtofloat(edit10.text);
  ddy:=strtofloat(edit11.text);
  ddz:=strtofloat(edit12.text);
  wgm.createnodes(ddx,ddy,ddz);
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

procedure Tmdchform.BitBtn8Click(Sender: TObject);
begin   //  copy node abort
     close;
end;

procedure Tmdchform.FormCreate(Sender: TObject);
begin
  height:=220;
  width:=175;
  mainform.enabled:=false;
end;

procedure Tmdchform.BitBtn5Click(Sender: TObject);
var
  xx,yy,zz:single;
begin   //  move some nodes
  xx:=strtofloat(edit7.text);
  yy:=strtofloat(edit8.text);
  zz:=strtofloat(edit9.text);
  wgm.movenodes(xx,yy,zz);
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

procedure Tmdchform.BitBtn6Click(Sender: TObject);
begin   //move some nodes abort
     close;
end;

procedure Tmdchform.y1Click(Sender: TObject);
begin
  label22.caption:='Z:';
  label23.caption:='X:';
end;

procedure Tmdchform.z1Click(Sender: TObject);
begin
  label22.caption:='X:';
  label23.caption:='Y:';
end;

procedure Tmdchform.x1Click(Sender: TObject);
begin
  label22.caption:='Y:';
  label23.caption:='Z:';
end;

procedure Tmdchform.BitBtn12Click(Sender: TObject);
begin
  close;
end;

procedure Tmdchform.BitBtn10Click(Sender: TObject);
begin
  close;
end;

procedure Tmdchform.BitBtn9Click(Sender: TObject);
var
  e1,e2,deg:single;
  cpy,axis:byte;
begin        //  Ðý×ª½Úµã
  e1:=strtofloat(edit13.text);
  e2:=strtofloat(edit14.text);
  deg:= strtofloat(edit15.text);
  cpy:= strtoint(edit16.text);
   if (x1.checked=true) then axis:=1
   else if (y1.checked=true) then axis:=2
   else if (z1.checked=true) then axis:=3;

  if (checkbox1.checked=false) or (cpy<1) then
    cpy:=0;
  wgm.rotnode(deg,cpy,axis,e1,e2);
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

procedure Tmdchform.BitBtn13Click(Sender: TObject);
begin
   close;
end;

procedure Tmdchform.BitBtn11Click(Sender: TObject);
var
  dx,dz,dy,px,py,pz:single;
  cc,i:byte;
begin     //  copy bar
  dx:=strtofloat(edit17.text);
  dy:=strtofloat(edit18.text);
  dz:=strtofloat(edit19.text);
  cc:=strtoint(edit20.text);
   if (rba.checked=false) then  cc:=1;
  for i:=1 to cc do
    begin
      px:=i*dx;   py:=i*dy;   pz:=i*dz;
      wgm.copyele(px,py,pz);
    end;
  wgm.clear_sel;
  mainform.cleansc;
  wgm.drawmodel;
  close;
end;

end.

unit force;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tforceform = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  forceform: Tforceform;

implementation
uses ent, load, MAIN;
{$R *.DFM}

procedure Tforceform.Button1Click(Sender: TObject);   //   OK
var
  F:three;
begin
  F.x:=strtofloat(edit1.text);
  F.y:=strtofloat(edit2.text);
  F.z:=strtofloat(edit3.text);
  spf.updateforce(spf.curfc,F);
  height:=80;
  groupbox1.hide;
  button3.show;   button4.show;
end;

procedure Tforceform.FormCreate(Sender: TObject);
var
  sa:string;
begin
  height:=240;
  if trunc(spf.curfc /10) =1 then sa:='D'+inttostr(spf.curfc mod 10)
  else if trunc(spf.curfc /10) =2 then sa:='L'+inttostr(spf.curfc mod 10)
  else if trunc(spf.curfc /10) =3 then sa:='W'+inttostr(spf.curfc mod 10)
  else if trunc(spf.curfc /10) =4 then sa:='C'+inttostr(spf.curfc mod 10)
  else if trunc(spf.curfc /10) =5 then sa:='E'+inttostr(spf.curfc mod 10);
  forceform.caption:='ºÉÔØ: '+sa;
end;

procedure Tforceform.Button3Click(Sender: TObject);   //  ¼ÌÐø
var
  i:integer;
begin
  for i:=1 to spf.np do
    if spf.node[i].sel<>0 then spf.node[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
  close;
end;

procedure Tforceform.Button4Click(Sender: TObject);  //  Íê³É
var
  i:integer;
begin
  for i:=1 to spf.np do
    spf.node[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
  close;
  loadform.show;
end;

procedure Tforceform.Button2Click(Sender: TObject);  //  cancel
var
  i:integer;
begin
  for i:=1 to spf.np do
    spf.node[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
  close;

end;

end.

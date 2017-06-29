unit zxx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tzxxform = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    Label5: TLabel;
    Edit5: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  zxxform: Tzxxform;

implementation

uses MAIN,ent;

{$R *.DFM}

procedure Tzxxform.Button1Click(Sender: TObject);  //  ok
begin
  spf.rlm:=strtoint(edit1.text);
  spf.smax:=strtofloat(edit2.text);
  spf.smin:=strtofloat(edit3.text);
  spf.nodewt:=strtofloat(edit4.text);
  spf.mmax:=strtoint(edit5.text);
  if rb1.checked=true then spf.ncc:=3
  else if rb2.checked=true then spf.ncc:=1
  else if rb3.checked=true then spf.ncc:=2;
  close;
  curbv[GEN]:=1;  curbv[SOLV]:=0;
end;

procedure Tzxxform.Button2Click(Sender: TObject);  //  cancel
begin
  close;
end;

procedure Tzxxform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.enabled:=true;
end;

procedure Tzxxform.FormCreate(Sender: TObject);
begin
  if spf.rlm <> 0 then
   edit1.text:=inttostr(spf.rlm);
  if spf.smax <> 0 then
   edit2.text:=format('%6.2f',[spf.smax]);
  if spf.smin <> 0 then
   edit3.text:=format('%6.2f',[spf.smin]);
  if spf.nodewt <> 0 then
   edit4.text:=format('%6.2f',[spf.nodewt]);
  if spf.mmax <> 0 then
   edit5.text:=inttostr(spf.mmax);
  if spf.ncc=3 then rb1.checked:=true
  else if spf.ncc=1 then rb2.checked:=true
  else if spf.ncc=2 then rb3.checked:=true;

end;

end.

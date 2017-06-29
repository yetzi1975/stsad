unit barres;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tbres = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    r1: TRadioButton;
    r3: TRadioButton;
    r4: TRadioButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  bres: Tbres;

implementation
uses main,ent;
{$R *.DFM}

procedure Tbres.Button1Click(Sender: TObject);
begin     // OK
  close;
  if r1.checked=true then
     curdis:=DRED    //  不满足要求的杆件
  else if r3.checked=true then
     curdis:=DSML        //  应力太小的杆件
  else if r4.checked=true then
     curdis:=DLY;   //  拉\压\零杆
  mainform.cleansc;
  spf.drawspt(curdis);

  close;
end;

procedure Tbres.Button2Click(Sender: TObject);
begin     //  cancel
   close;
end;

end.

unit input;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ent,main;

type
  TinputForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  inputForm: TinputForm;

implementation

{$R *.DFM}

procedure TinputForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if edit1.text<>'' then loadcase:=strtoint(edit1.text);
  if loadcase>0 then spf.PL_readresult(loadcase);
  curdis:=0;
  mainform.cleansc;
  spf.drawspt(curdis);   
end;

procedure TinputForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9',#8,#13]) then key:=#0;
  if key = #13 then close;
end;

end.

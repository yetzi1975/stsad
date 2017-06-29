unit abt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  Tabtform = class(TForm)
    Label1: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  abtform: Tabtform;

implementation

uses MAIN;

{$R *.DFM}

procedure Tabtform.FormCreate(Sender: TObject);
begin
  mainform.enabled:=false;
  
end;

procedure Tabtform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.enabled:=true;
end;

end.

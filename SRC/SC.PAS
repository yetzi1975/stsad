unit sc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tscform = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    RadioButton1: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  scform: Tscform;

implementation

uses MAIN,ent,model;

{$R *.DFM}

procedure Tscform.FormCreate(Sender: TObject);
begin
  edit1.text:=format('%4.1f',[scale]);
  if spf<>nil then
   begin
     edit2.text:=format('%4.1f',[spf.famp]);
     edit3.text:=format('%5.0f',[spf.damp]);
     if curdis=0 then combobox1.text:='无属性'
     else if curdis=1 then combobox1.text:='按材料'
     else if curdis=2 then combobox1.text:='按截面'
     else if curdis=9 then combobox1.text:='变形';
   end
  else if wgm<>nil then
   begin
   end;

end;

procedure Tscform.Button2Click(Sender: TObject);
begin   //  cancel
  close;
end;

procedure Tscform.Button1Click(Sender: TObject);
begin     //  OK
  mainform.cleansc;
  scale:=strtofloat(edit1.text);
  if RadioButton1.Checked then flag3d:=1
  else flag3d:=0;
  if spf<>nil then
   begin
     spf.famp:=strtofloat(edit2.text);
     spf.damp:=strtofloat(edit3.text);
     if combobox1.text='无属性' then curdis:=0
     else if combobox1.text='按材料' then curdis:=1
     else if combobox1.text='按截面' then curdis:=2
     else if combobox1.text='变形' then curdis:=9;
     spf.drawspt(curdis);
   end
  else if wgm<>nil then
   begin
   end;
  close;
end;

procedure Tscform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.enabled:=true;
end;

end.

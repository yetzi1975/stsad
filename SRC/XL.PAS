unit xl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Txlform = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Rb1: TRadioButton;
    rb2: TRadioButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    rb3: TRadioButton;
    rb4: TRadioButton;
    rb5: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  xlform: Txlform;

implementation

uses MAIN,ent;

{$R *.DFM}

procedure Txlform.Button1Click(Sender: TObject);
var
 tmp:string;
begin
  try
   if rb1.checked=true then
    begin
      spf.curfc:=10+strtoint(edit1.text);
      tmp:='恒载['+edit1.Text+']';
    end
   else if rb2.checked=true then
    begin
     spf.curfc:=20+strtoint(edit2.text);
     tmp:='活载['+edit2.Text+']';
    end
   else if rb3.checked=true then
    begin
     spf.curfc:=30+strtoint(edit3.text);
     tmp:='风载['+edit3.Text+']';
    end
   else if rb4.checked=true then
    begin
      spf.curfc:=40+strtoint(edit4.text);
      tmp:='吊车['+edit4.Text+']';
    end
   else if rb5.checked=true then
    begin
      spf.curfc:=50+strtoint(edit5.text);
      tmp:='地震['+edit5.Text+']';
    end;
  except
    messagedlg('输入有误!',mtwarning,[mbok],0);
  end;
  if spf.forceexist(spf.curfc)=1 then
    mainform.statusbar1.panels.items[6].text:=tmp
  else
    messagedlg('无此荷载!',mtwarning,[mbok],0);
  mainform.cleansc;
  spf.drawspt(curdis);
  close;
end;

procedure Txlform.Button2Click(Sender: TObject);
begin
  close;
end;

procedure Txlform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.enabled:=true;
end;

end.

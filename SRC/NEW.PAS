unit new;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Tabnotbk;

type
  Tcreatewj = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Edit6: TEdit;
    Label5: TLabel;
    Edit7: TEdit;
    zf: TCheckBox;
    xf: TCheckBox;
    pm: TCheckBox;
    qm: TCheckBox;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure zfClick(Sender: TObject);
    procedure xfClick(Sender: TObject);
    procedure pmClick(Sender: TObject);
    procedure qmClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure readdata;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  createwj: Tcreatewj;
  data:array[1..10] of single;
  flag:byte;
implementation

uses generate, model, main, VIEW;
{$R *.DFM}

procedure Tcreatewj.zfClick(Sender: TObject);
begin
  xf.checked:=false;
end;

procedure Tcreatewj.xfClick(Sender: TObject);
begin
  zf.checked:=false;
  qm.checked:=false;
end;

procedure Tcreatewj.pmClick(Sender: TObject);
begin
  qm.checked:=false;
end;

procedure Tcreatewj.qmClick(Sender: TObject);
begin
  pm.checked:=false;
  xf.checked:=false;
end;

procedure Tcreatewj.readdata;
begin
  if TabbedNotebook1.pageindex=0 then  //  four corner
    begin
      flag:=0;
      data[1]:=strtofloat(edit1.text);  // x num
      data[2]:=strtofloat(edit2.text);  // x distance
      data[3]:=strtofloat(edit3.text);  // y num
      data[4]:=strtofloat(edit4.text);  // y distance
      data[5]:=strtofloat(edit5.text);  // h
      if xf.checked=true then flag:=1;   //  0 is zf
      if qm.checked=true then flag:=flag+10;  //  0 is pm

      if flag mod 10 =1 then data[6]:=strtofloat(edit7.text);
      if flag >=10 then data[7]:=strtofloat(edit6.text);
    end
  else if TabbedNotebook1.pageindex=1 then   // three corner truss
    begin
      data[1]:=strtofloat(edit8.text);  // b1
      data[2]:=strtofloat(edit9.text);  // b2
      data[3]:=strtofloat(edit10.text);  // b3
      data[4]:=strtofloat(edit11.text);  // distance
      data[5]:=strtofloat(edit12.text);  // num
    end
  else if TabbedNotebook1.pageindex=2 then   //  sphere
    begin
    end;
end;

procedure Tcreatewj.Button1Click(Sender: TObject);
begin
  if TabbedNotebook1.pageindex=0 then  //  four corner
    begin
    readdata;
    if flag = 0 then
      v4(trunc(data[1]),trunc(data[3]),data[2],data[4],data[5]);
    end
  else if TabbedNotebook1.pageindex=1 then   // three corner truss
    begin
      readdata;
      truss3(data[1],data[2],data[3],data[4],round(data[5])+1);
    end
  else if TabbedNotebook1.pageindex=2 then   //  sphere
    begin
    end;

  showmessage('模型已生成');
  wgm:=Tmodel.init;

  if (wgm.readtxt(path+'wjtmp.dat')<>1) then
    begin
     messagedlg('DAT文件读取异常!',mterror,[mbok],0);
     wgm.Free; wgm:=nil;
     exit;
    end;

    mainform.cleansc;

    jx:=-54.7356*PI/180;
    jz:=-PI/4;
    jy:=0;
    wgm.drawmodel;

    mainform.statusbar1.Panels.Items[2].Text:=' 几何模型';
    mainform.N6.enabled:=TRUE;
    mainform.N11.enabled:= TRUE;
    mainform.N17.enabled:=false;
    mainform.N35.enabled:= TRUE;
    mainform.N22.enabled:=false;
    mainform.N25.enabled:=false;
    viewform.enabled:=true;

  close;
end;

procedure Tcreatewj.Button2Click(Sender: TObject);
begin
  close;
end;

end.

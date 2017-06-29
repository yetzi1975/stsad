unit comb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  Tcombform = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    ListBox2: TListBox;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    RB1: TRadioButton;
    RB2: TRadioButton;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  function genstr:string;
  end;

var
  combform: Tcombform;
  
implementation
uses ent, MAIN;
{$R *.DFM}

function Tcombform.genstr:string;
var
  str:string;
begin
  if checkbox1.checked=true then
     str:=concat(trim(edit6.text),'*D',trim(edit1.text));
  if checkbox2.checked=true then
     str:=concat(str,'+',trim(edit7.text),'*L',trim(edit2.text));
  if checkbox3.checked=true then
     str:=concat(str,'+',trim(edit8.text),'*W',trim(edit3.text));
  if checkbox4.checked=true then
     str:=concat(str,'+',trim(edit9.text),'*C',trim(edit4.text));
  if checkbox5.checked=true then
     str:=concat(str,'+',trim(edit10.text),'*E',trim(edit5.text));
  result:=str;
end;

procedure Tcombform.BitBtn1Click(Sender: TObject);   //  add  com-case
var
  si,a,i:byte;
  str:string;
begin
   if (checkbox1.checked=true) and (spf.forceexist(10+strtoint(edit1.text))=0) then
     begin
       messagedlg('恒载编号错!',mtwarning,[mbok],0);
       exit;
     end;
   if (checkbox2.checked=true) and (spf.forceexist(20+strtoint(edit2.text))=0) then
     begin
       messagedlg('活载编号错!',mtwarning,[mbok],0);
       exit;
     end;
   if (checkbox3.checked=true) and (spf.forceexist(30+strtoint(edit3.text))=0) then
     begin
       messagedlg('风载编号错!',mtwarning,[mbok],0);
       exit;
     end;
   if (checkbox4.checked=true) and (spf.forceexist(40+strtoint(edit4.text))=0) then
     begin
       messagedlg('吊车编号错!',mtwarning,[mbok],0);
       exit;
     end;
   if (checkbox5.checked=true) and (spf.forceexist(50+strtoint(edit5.text))=0) then
     begin
       messagedlg('地震编号错!',mtwarning,[mbok],0);
       exit;
     end;
  for i:=1 to 15 do
   if spf.comld[i,0]<0 then
    begin
     si:=i; break;
    end;
   if rb1.checked=true then spf.comld[si,0]:=10  //  一般 0.6
   else spf.comld[si,0]:=1;      //   简化 0.85
   if checkbox1.checked=true then
     spf.comld[si,1]:=strtoint(edit1.text)*10000+strtofloat(edit6.text);
   if checkbox2.checked=true then
     spf.comld[si,2]:=strtoint(edit2.text)*10000+strtofloat(edit7.text);
   if checkbox3.checked=true then
     spf.comld[si,3]:=strtoint(edit3.text)*10000+strtofloat(edit8.text);
   if checkbox4.checked=true then
     spf.comld[si,4]:=strtoint(edit4.text)*10000+strtofloat(edit9.text);
   if checkbox5.checked=true then
     spf.comld[si,5]:=strtoint(edit5.text)*10000+strtofloat(edit10.text);
   //  laoH[listbox2.items.count]:=si;
   str:=genstr;
   listbox2.items.add(str);

end;

procedure Tcombform.BitBtn3Click(Sender: TObject);   //  delete
var
 i,j,k,a:byte;
begin
  a:=listbox2.itemindex;
  listbox2.items.delete(listbox2.itemindex);
  for i:=0 to 5 do    //   comld[i,0~5]  清零
   spf.comld[a,i]:=-1;
    //  comld[1~14,1~5] 记录组合系数
  for j:=a to 14  do        //  comld[1~14,0] 记录简化或一般组合
    for k:=0 to 5 do
       spf.comld[j,k]:=spf.comld[j+1,k];
end;

procedure Tcombform.FormCreate(Sender: TObject);
var
  str:string;
  a,i:byte;
  fa:single;
begin
  for i:=1 to 15 do
   begin
    if spf.comld[i,0]>0 then
     begin
     if spf.comld[i,1]>10000 then
      begin
       a:=trunc(spf.comld[i,1]/10000);
       fa:=spf.comld[i,1]-10000*a;
       str:=concat(format('%3.1f',[fa]),'*D',inttostr(a))
      end;
     if spf.comld[i,2]>10000 then
      begin
       a:=trunc(spf.comld[i,2]/10000);
       fa:=spf.comld[i,2]-10000*a;
       str:=concat(str,'+',format('%3.1f',[fa]),'*L',inttostr(a))
      end;
     if spf.comld[i,3]>10000 then
      begin
       a:=trunc(spf.comld[i,3]/10000);
       fa:=spf.comld[i,3]-10000*a;
       str:=concat(str,'+',format('%3.1f',[fa]),'*W',inttostr(a))
      end;
     if spf.comld[i,4]>10000 then
      begin
       a:=trunc(spf.comld[i,4]/10000);
       fa:=spf.comld[i,4]-10000*a;
       str:=concat(str,'+',format('%3.1f',[fa]),'*C',inttostr(a))
      end;
     if spf.comld[i,5]>10000 then
      begin
       a:=trunc(spf.comld[i,5]/10000);
       fa:=spf.comld[i,5]-10000*a;
       str:=concat(str,'+',format('%3.1f',[fa]),'*E',inttostr(a))
      end;
     listbox2.items.add(str);
     end;
   end;
end;

procedure Tcombform.ListBox2Click(Sender: TObject);
begin
  if spf.comld[listbox2.itemindex,0]>9 then  //  一般   0.6
    rb1.checked:=true
  else if spf.comld[listbox2.itemindex,0]>0 then  //  简化 0.85
    rb2.checked:=true;
end;

procedure Tcombform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mainform.enabled:=true;
end;

procedure Tcombform.Button1Click(Sender: TObject);
begin
  curbv[COB]:=1; curbv[SOLV]:=0;
  close;
end;

end.

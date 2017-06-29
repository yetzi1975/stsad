unit ndinfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TNODEINFO = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox3: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Edit7: TEdit;
    Edit9: TEdit;
    Edit8: TEdit;
    Panel1: TPanel;
    CheckBox7: TCheckBox;
    Label11: TLabel;
    Edit10: TEdit;
    Label12: TLabel;
    Label4: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure readnode;
    procedure updatenode;
  end;

var
  NODEINFO: TNODEINFO;

implementation
uses  ent, MAIN;
{$R *.DFM}

procedure TNODEINFO.readnode;
var
  a,b,i:integer;
  z:array[1..10] of byte;
begin
 a:=0;
 for i:=1 to 10 do z[i]:=0;
  for i:=1 to spf.np do
    if spf.node[i].sel=1 then
     begin
       if trunc(spf.node[i].ys /100)=1 then z[1]:=1;
       if trunc((spf.node[i].ys mod 100)/10)=1 then z[2]:=1;
       if (spf.node[i].ys mod 10)=1 then z[3]:=1;
       if trunc(spf.node[i].ys/100)>1 then z[1]:=2;
       if trunc((spf.node[i].ys mod 100)/10)>1 then z[2]:=2;
       if (spf.node[i].ys mod 10)>1 then z[3]:=2;

       if abs(spf.node[i].ang_cj)>10000 then
        begin
          if abs(spf.node[i].dx)>0.001 then z[4]:=1;
          if abs(spf.node[i].dy)>0.001 then z[5]:=1;
          if abs(spf.node[i].dz)>0.001 then z[6]:=1;
        end;
       if abs(spf.node[i].ang_cj mod 10000)>0 then z[7]:=1;
      inc(a);
      b:=i;
     end;
  if a=1 then      //  only one node selected
   begin
    label4.caption:='节点号:'+format('%6d',[b]);
    label1.caption:='X坐标:'+ format('%8.3f',[spf.node[b].x]);
    label2.caption:='Y坐标:'+ format('%8.3f',[spf.node[b].y]);
    label3.caption:='Z坐标:'+ format('%8.3f',[spf.node[b].z]);
    z[1]:=spf.node[b].getysxyz(1);
    z[2]:=spf.node[b].getysxyz(2);
    z[3]:=spf.node[b].getysxyz(3);
    if z[1]=1 then checkbox4.checked:=true
    else if z[1]>1  then   // is spring
      begin
       checkbox1.checked:=true;
       edit1.text:=floattostr(spf.spr[z[1]]);
      end;
    if z[2]=1 then checkbox5.checked:=true
    else if z[2]>1  then  // is spring
      begin
       checkbox2.checked:=true;
       edit2.text:=floattostr(spf.spr[z[2]]);
      end;
    if z[3]=1 then checkbox6.checked:=true
    else if z[3]>1  then   // is spring
      begin
       checkbox3.checked:=true;
       edit3.text:=floattostr(spf.spr[z[3]]);
      end;
    if spf.node[b].ang_cj>10000 then //   有沉降
      begin
       if abs(spf.node[b].dx)>0.001 then
         begin
          checkbox8.checked:=true;
          edit7.text:=inttostr(trunc(spf.node[b].dx*1000));
         end;
       if abs(spf.node[b].dy)>0.001 then
         begin
          checkbox9.checked:=true;
          edit8.text:=inttostr(trunc(spf.node[b].dy*1000));
         end;
       if abs(spf.node[b].dz)>0.001 then
         begin
          checkbox10.checked:=true;
          edit9.text:=inttostr(trunc(spf.node[b].dz*1000));
         end;
       end;
    if (abs(spf.node[b].ang_cj) mod 10000)>0 then       //  有斜边界
      begin
        checkbox7.onclick(self);
        edit10.text:=inttostr(spf.node[b].ang_cj mod 10000);
      end;
   end
  else              //  多个节点
   begin
    label4.caption:='节点号:'+'  多节点';
    label1.caption:='X坐标:'+ '   ----';
    label2.caption:='Y坐标:'+ '   ----';
    label3.caption:='Z坐标:'+ '   ----';

    if z[1]=1 then checkbox4.state:=cbgrayed;  //  约束
    if z[2]=1 then checkbox5.state:=cbgrayed;
    if z[3]=1 then checkbox6.state:=cbgrayed;
      if z[1]=2 then checkbox1.state:=cbgrayed;  //  弹簧
      if z[2]=2 then checkbox2.state:=cbgrayed;
      if z[3]=2 then checkbox3.state:=cbgrayed;
    if z[4]=1 then checkbox8.state:=cbgrayed;  //  沉降
    if z[5]=1 then checkbox9.state:=cbgrayed;
    if z[6]=1 then checkbox10.state:=cbgrayed;
      if z[7]=1 then checkbox7.state:=cbgrayed;  // 斜边界
   end;
end;

procedure TNODEINFO.updatenode;
var
  tys,tcj,i,tmp:integer;
begin
try
  for i:=1 to spf.np do
   if spf.node[i].sel=1 then
    begin
      tys:=0;
      if checkbox4.state= cbchecked then tys:=100;
      if checkbox5.state= cbchecked then tys:=tys+10;
      if checkbox6.state= cbchecked then tys:=tys+1;
      if checkbox1.state= cbchecked then    //  弹簧
        tys:=tys+spf.getsprno(strtofloat(edit1.text))*100; //  spring unit N/mm
      if checkbox2.state= cbchecked then
        tys:=tys+spf.getsprno(strtofloat(edit2.text))*10;
      if checkbox3.state= cbchecked then
        tys:=tys+spf.getsprno(strtofloat(edit3.text));
      if (checkbox4.state= cbgrayed) or (checkbox1.state= cbgrayed) then
        tys:=tys+spf.node[i].getysxyz(1)*100;
      if (checkbox5.state= cbgrayed) or (checkbox2.state= cbgrayed) then
        tys:=tys+spf.node[i].getysxyz(2)*10;
      if (checkbox6.state= cbgrayed) or (checkbox3.state= cbgrayed) then
        tys:=tys+spf.node[i].getysxyz(3);
      spf.node[i].ys:=tys;    //  update ys

      if checkbox8.state= cbchecked then  //  update cj
          spf.node[i].dx:=strtofloat(edit7.text)/1000.0  // unit (m)
      else if checkbox8.state= cbunchecked then
          spf.node[i].dx:=0;
      if checkbox9.state= cbchecked then
          spf.node[i].dy:=strtofloat(edit8.text)/1000.0
      else if checkbox9.state= cbunchecked then
          spf.node[i].dy:=0;
      if checkbox10.state= cbchecked then
          spf.node[i].dz:=strtofloat(edit9.text)/1000.0
      else if checkbox10.state= cbunchecked then
          spf.node[i].dz:=0;
      if (checkbox8.state= cbunchecked) and (checkbox9.state= cbunchecked)
         and (checkbox10.state= cbunchecked) then
        spf.node[i].ang_cj:= spf.node[i].ang_cj mod 10000;
      if (checkbox8.state= cbchecked) or (checkbox9.state= cbchecked)
         or (checkbox10.state= cbchecked) then
        begin
         if (spf.node[i].ang_cj<10000) and (spf.node[i].ang_cj>=0)then
           spf.node[i].ang_cj:= spf.node[i].ang_cj+ 10000;
         if (spf.node[i].ang_cj>-10000) and (spf.node[i].ang_cj<0)then
           spf.node[i].ang_cj:= spf.node[i].ang_cj- 10000;
        end;
      tmp:=spf.node[i].ang_cj;
      if checkbox7.state=cbchecked then  //  update oblique bound
       begin
        if strtoint(edit10.text)>0 then
          tmp:=abs(tmp)-abs(tmp mod 10000)+strtoint(edit10.text)
        else
          tmp:=-1*(abs(tmp)-abs(tmp mod 10000)+abs(strtoint(edit10.text)));
       end;
    end;
 except
 on EconvertError  do
   messagedlg('存在无效数据!',mterror,[mbok],0);
   
 end;

end;

procedure TNODEINFO.Button2Click(Sender: TObject);    //  cancel button
var
  i:integer;
begin
  for i:=1 to spf.np do
    spf.node[i].sel:=0;
  close;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure TNODEINFO.Button1Click(Sender: TObject);      //   OK  button
var
 i:integer;
begin
  if (checkbox1.checked=true) and (checkbox4.checked=true) then
   begin
     messagedlg('请明确支撑条件!',mterror,[mbok],0);
     exit;
   end
  else if (checkbox2.checked=true) and (checkbox5.checked=true) then
   begin
     messagedlg('请明确支撑条件!',mterror,[mbok],0);
     exit;
   end
  else if (checkbox3.checked=true) and (checkbox6.checked=true) then
   begin
    messagedlg('请明确支撑条件!',mterror,[mbok],0);
    exit;
   end;

  updatenode;
  close;
  curbv[SUPP]:= 1;  curbv[SOLV]:=0;    //  SUPP TO 1
   for i:=1 to spf.np do
    spf.node[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure TNODEINFO.FormCreate(Sender: TObject);
begin
  readnode;
end;

procedure TNODEINFO.CheckBox7Click(Sender: TObject);  // 斜边界
begin
  if checkbox7.state=cbchecked then
    begin
     label11.show;  label12.show; edit10.show;
    end
  else if checkbox7.state=cbunchecked then
    begin
     label11.hide;  label12.hide; edit10.hide;
    end;
end;

procedure TNODEINFO.CheckBox4Click(Sender: TObject); // X 向约束
begin
  if checkbox4.state=cbunchecked then edit1.enabled:=true
  else
    begin
      edit1.text:='';
      edit1.enabled:=false;
    end;
end;

procedure TNODEINFO.CheckBox5Click(Sender: TObject);  // Y 向约束
begin
  if checkbox5.state=cbunchecked then edit2.enabled:=true
  else
    begin
      edit2.text:='';
      edit2.enabled:=false;
    end;
end;

procedure TNODEINFO.CheckBox6Click(Sender: TObject); // Z 向约束
begin
  if checkbox6.state=cbunchecked then edit3.enabled:=true
  else
   begin
    edit3.text:='';
    edit3.enabled:=false;
   end;
end;

procedure TNODEINFO.CheckBox1Click(Sender: TObject); // X 向弹簧
begin
  if checkbox1.state=cbunchecked then
    begin
      edit1.text:='';
      edit1.enabled:=false;
    end
  else  edit1.enabled:=true;
    
end;

procedure TNODEINFO.CheckBox2Click(Sender: TObject); // Y 向弹簧
begin
  if checkbox2.state=cbunchecked then
    begin
      edit2.text:='';
      edit2.enabled:=false;
    end
  else  edit2.enabled:=true;

end;

procedure TNODEINFO.CheckBox3Click(Sender: TObject);  // Z 向弹簧
begin
  if checkbox3.state=cbunchecked then
    begin
     edit3.text:='';
     edit3.enabled:=false;
    end
  else  edit3.enabled:=true;
   
end;

end.

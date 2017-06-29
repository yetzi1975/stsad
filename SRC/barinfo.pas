unit barinfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, StrUtils, Tabnotbk;

type
  Tbinfo = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    TabbedNotebook1: TTabbedNotebook;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    Label10: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label16: TLabel;
    Button4: TButton;
    Label11: TLabel;
    ComboBox2: TComboBox;
    Button3: TButton;
    Panel2: TPanel;
    Label4: TLabel;
    Label2: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    Label13: TLabel;
    Edit8: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Edit9: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    Edit10: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    ComboBox3: TComboBox;
    RadioButton1: TRadioButton;
    GroupBox2: TGroupBox;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label23: TLabel;
    GroupBox3: TGroupBox;
    Label24: TLabel;
    Edit11: TEdit;
    Image1: TImage;
    Label25: TLabel;
    ComboBox4: TComboBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button5: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure uj2bar;
    procedure bar2uj;
    procedure loadsec(kd:byte);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure ComboBox2Click(Sender: TObject);
    procedure ComboBox3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  binfo: Tbinfo;

implementation
uses  ent, MAIN;
{$R *.DFM}
procedure Tbinfo.uj2bar;
var         //   write data to form
  i,num:integer;
  sh,mh:byte;
  tkd,tmt,tsc,tly,tst:integer;
begin
  num:=-1; tkd:=0;  tmt:=0;
  tsc:=0;  tly:=0;  tst:=0;
  for i:=1 to spf.ne do
    if spf.bar[i].sel=1 then
     begin
      if num=-1 then num:=i
      else num:=-999;
      if (spf.subsecmat.section[spf.bar[i].sec].kind<>tkd) and (tkd=0) then
        tkd:= spf.subsecmat.section[spf.bar[i].sec].kind
      else if spf.subsecmat.section[spf.bar[i].sec].kind<>tkd then
        tkd:= -1;
      if (spf.bar[i].mat<>tmt) and (tmt=0) then
        tmt:= spf.bar[i].mat
      else if spf.bar[i].mat<>tmt then
        tmt:= -1;
      if (spf.bar[i].sec<>tsc) and (tsc=0) then
        tsc:= spf.bar[i].sec
      else if spf.bar[i].sec<>tsc then
        tsc:= -1;
      if (spf.bar[i].grp<>tly) and (tly=0) then
        tly:= spf.bar[i].grp
      else if spf.bar[i].grp<>tly then
        tly:= -1;
      if (spf.bar[i].stc<>tst) and (tst=0) then
        tst:= spf.bar[i].stc
      else if spf.bar[i].stc<>tst then
        tst:= -1;
     end;
  if num>0 then       //   only one bar
   begin
    label4.caption:='杆件号：'+format('%6d',[num]);
    label12.caption:='前节点号:  '+format('%3d',[spf.bar[num].nf]);
    label3.caption:='后节点号:  '+format('%3d',[spf.bar[num].nl]);
    label1.caption:='杆长:'+format('%7.2f',[spf.bar[num].len])+' 米';
    edit11.text:=format('%4d',[spf.bar[num].grp]);

    sh:=spf.bar[num].sec;   //  截面页
    combobox1.text:=spf.subsecmat.getseckind(spf.subsecmat.section[sh].kind);
    loadsec(spf.subsecmat.section[sh].kind);
    combobox3.text:=spf.subsecmat.section[sh].name;
    edit1.text:=format('%10.2f',[spf.subsecmat.section[sh].area]);
    edit2.text:=format('%10.2f',[spf.subsecmat.section[sh].Ita2]);
    edit3.text:=format('%10.2f',[spf.subsecmat.section[sh].Ita3]);
    edit4.text:=format('%10.1f',[spf.subsecmat.section[sh].rodr2]);
    edit5.text:=format('%10.1f',[spf.subsecmat.section[sh].rodr3]);
    panel1.color:=spf.subsecmat.section[sh].color;
    if spf.bar[num].chg=0 then radiobutton1.checked:=true;

    mh:=spf.bar[num].mat;    //  材料页
    combobox2.text:=spf.subsecmat.mater[mh].name;
    edit6.text:= format('%9.1f',[spf.subsecmat.mater[mh].fy]);
    edit7.text:= format('%9.1f',[spf.subsecmat.mater[mh].fq]);
    edit10.text:= format('%9.2e',[spf.subsecmat.mater[mh].alpha]);
    edit8.text:= format('%9.1f',[spf.subsecmat.mater[mh].Es]);
    edit9.text:= format('%9.2f',[spf.subsecmat.mater[mh].rwt]);
    panel2.color:=spf.subsecmat.mater[mh].color;

    if spf.bar[num].stc=1 then radiobutton2.checked:=true  // 稳定页
    else if spf.bar[num].stc=2 then radiobutton3.checked:=true
    else if spf.bar[num].stc=3 then radiobutton4.checked:=true;

   end
  else       //   many bar
   begin
    label4.caption:='   多根杆件';
    label12.caption:='前节点号:  ----';
    label3.caption:='后节点号:  ----';
    label1.caption:='杆长:   [---]米';
    if tly<>-1 then edit11.text:= format('%4d',[tly]);
    if tkd=-1 then combobox1.text:=''
    else
     begin
      combobox1.text:=spf.subsecmat.getseckind(tkd);
      loadsec(tkd);
     end;
    if tsc=-1 then panel1.color:=clblack
    else
     begin
      edit1.text:=format('%10.2f',[spf.subsecmat.section[tsc].area]);
      edit2.text:=format('%10.2f',[spf.subsecmat.section[tsc].Ita2]);
      edit3.text:=format('%10.2f',[spf.subsecmat.section[tsc].Ita3]);
      edit4.text:=format('%10.1f',[spf.subsecmat.section[tsc].rodr2]);
      edit5.text:=format('%10.1f',[spf.subsecmat.section[tsc].rodr3]);
      panel1.color:=spf.subsecmat.section[tsc].color;
      combobox3.text:=spf.subsecmat.section[tsc].name;
     end;
    if tmt=-1 then panel2.color:=clblack
    else
      begin
       combobox2.text:=spf.subsecmat.mater[tmt].name;
       edit6.text:= format('%9.1f',[spf.subsecmat.mater[tmt].fy]);
       edit7.text:= format('%9.1f',[spf.subsecmat.mater[tmt].fq]);
       edit10.text:= format('%9.2e',[spf.subsecmat.mater[tmt].alpha]);
       edit8.text:= format('%9.1f',[spf.subsecmat.mater[tmt].Es]);
       edit9.text:= format('%9.2f',[spf.subsecmat.mater[tmt].rwt]);
      end;
    if tst<>-1 then
     begin
      if tst=1 then radiobutton2.checked:=true
      else if tst=2 then radiobutton3.checked:=true
      else if tst=3 then radiobutton4.checked:=true;
     end;
   end;
end;

procedure Tbinfo.bar2uj;
var
  i,a:integer;
begin     //  read data from form
  if combobox1.itemindex>-1 then a:=combobox1.itemindex+1
   // next to deal with no click
  else if comparestr(trim(combobox1.text),'圆钢管')=0 then a:=1
  else if comparestr(trim(combobox1.text),'双拼角钢')=0 then a:=2
  else if comparestr(trim(combobox1.text),'工字型截面')=0 then a:=3
  else if comparestr(trim(combobox1.text),'方钢管')=0 then a:=4
  else a:=5;

  for i:=1 to spf.ne do
   if spf.bar[i].sel=1 then
     begin
      if (a>=0)and (combobox3.itemindex>=0) then   //  截面,a为截面类型
       spf.bar[i].sec:=spf.subsecmat.getsecbase(a)        //  在截面库中的总位置
                       +combobox3.itemindex;
      if combobox2.itemindex>=0 then       //  材料
       spf.bar[i].mat:=combobox2.itemindex+1;
      if strtoint(edit11.text)<>0 then    //  layer
        spf.bar[i].grp:= strtoint(edit11.text);
      if radiobutton1.checked=true then   //  section changeable
        spf.bar[i].chg:=0
      else spf.bar[i].chg:=1;

      if radiobutton2.checked=true then spf.bar[i].stc:=1  // stable
      else if radiobutton3.checked=true then spf.bar[i].stc:=2
      else if radiobutton4.checked=true then spf.bar[i].stc:=3;

     end;

end;

procedure Tbinfo.Panel1DblClick(Sender: TObject);
begin
   if colordialog1.execute then
      panel1.color:=colordialog1.color;
end;

procedure Tbinfo.Panel2DblClick(Sender: TObject);
begin
  if colordialog1.execute then
      panel2.color:=colordialog1.color;
end;

procedure Tbinfo.Button2Click(Sender: TObject);
var             //  cancel
  i:integer;
begin
  close;
  for i:=1 to spf.ne do
    spf.bar[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;


procedure Tbinfo.Button1Click(Sender: TObject);
var             //  OK
  i:integer;
begin
  bar2uj;
  close;
  for i:=1 to spf.ne do
    spf.bar[i].sel:=0;
  curbv[PROP]:=1;   curbv[SOLV]:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tbinfo.loadsec(kd:byte);
var
 i:byte;      // kd  1:YG 2:SJ 3:GZ 4:FG
begin
  for i:= combobox3.items.count-1 downto 0 do   //  delete old items
   combobox3.items.delete(i);
  for i:=1 to spf.subsecmat.sno do        //  add kind=kd to items
   if spf.subsecmat.section[i].kind=kd then
      combobox3.items.add(spf.subsecmat.section[i].name);
end;

procedure Tbinfo.FormCreate(Sender: TObject);
var
  i:byte;
  f:textfile;
  mat1: Tmat;
  ls:string;
  a1,a2,a3:string[10];
  snm:string[18];
begin     //  load section & material
 if spf.subsecmat.sno>0 then
   begin
     listbox1.hide; listbox2.hide;
     button5.hide;
     button1.show; button2.show;
     tabbednotebook1.Show;
     for i:=1 to spf.subsecmat.section[spf.subsecmat.sno].kind do
      combobox1.items.add(spf.subsecmat.getseckind(i));   //  转换截面名称
     for i:=1 to spf.subsecmat.mno do
      combobox2.items.add(spf.subsecmat.mater[i].name);
     uj2bar;
   end
 else
   begin
     listbox1.Show;   listbox2.Show;
     button5.Show;
     tabbednotebook1.hide;
     button1.Hide; button2.Hide;
     assignfile(f,path+'jmcl.txt');
     reset(f);
     a3:='*';
     while (strpos(pchar(ls),'SEC')=nil) do readln(f,ls);
     while (trim(ls)<>'0') do
       begin
        readln(f,ls);// (snm,a1,a2,a3);
        if trim(ls)<>'0' then
          begin
            //  ls:=trim(snm)+' '+trim(a1)+' '+trim(a2)+' '+trim(a3);
            listbox1.Items.Add(ls);
          end;
       end;
     while (strpos(pchar(ls),'MAT')=nil) do readln(f,ls);
     while (trim(ls)<>'0') do
      begin
        readln(f,ls);
        if trim(ls)<>'0' then
          begin
            with spf.subsecmat do
              begin
                mater[mno+1].lineinp(ls);
                mater[mno+1].getcolor(mno+1);
                mno:=mno+1;
              end;  
          end;
      end;
     closefile(f);
   end;
end;

procedure Tbinfo.ComboBox1Click(Sender: TObject); //  section kind
begin
  loadsec(combobox1.itemindex+1);       //  加载
end;

procedure Tbinfo.ComboBox2Click(Sender: TObject);
var        //  material
  mh:byte;
begin
  mh:= combobox2.itemindex+1;
  panel2.color:=spf.subsecmat.mater[mh].color;
  edit6.text:= format('%9.1f',[spf.subsecmat.mater[mh].fy]);
  edit7.text:= format('%9.1f',[spf.subsecmat.mater[mh].fq]);
  edit10.text:= format('%9.2e',[spf.subsecmat.mater[mh].alpha]);
  edit8.text:= format('%9.1f',[spf.subsecmat.mater[mh].Es]);
  edit9.text:= format('%9.2f',[spf.subsecmat.mater[mh].rwt]);
end;

procedure Tbinfo.ComboBox3Click(Sender: TObject);
var        //  section => spf
  sh,a:integer;
begin
  if combobox1.itemindex>-1 then a:=combobox1.itemindex+1
    // next to deal with no click
  else if comparestr(trim(combobox1.text),'圆钢管')=0 then a:=1
  else if comparestr(trim(combobox1.text),'双拼角钢')=0 then a:=2
  else if comparestr(trim(combobox1.text),'工字型截面')=0 then a:=3
  else if comparestr(trim(combobox1.text),'方钢管')=0 then a:=4
  else a:=5;

  sh:=spf.subsecmat.getsecbase(a)+combobox3.itemindex;
  if sh<=spf.subsecmat.sno then
    begin
      panel1.color:=spf.subsecmat.section[sh].color;
      edit1.text:=format('%10.2f',[spf.subsecmat.section[sh].area]);
      edit2.text:=format('%10.2f',[spf.subsecmat.section[sh].Ita2]);
      edit3.text:=format('%10.2f',[spf.subsecmat.section[sh].Ita3]);
      edit4.text:=format('%10.1f',[spf.subsecmat.section[sh].rodr2]);
      edit5.text:=format('%10.1f',[spf.subsecmat.section[sh].rodr3]);
    end;
end;

procedure Tbinfo.Button4Click(Sender: TObject);
var
  sectmp:Tsec;
  i,j:integer;
begin      //  新建截面
  if button4.Caption='新建' then
    begin
      edit1.Enabled:=true;  edit2.Enabled:=true;
      edit3.Enabled:=true;
      combobox4.Enabled:=true;
      button4.Caption:='完成';
    end
  else if button4.Caption='完成' then
    begin
      sectmp:=Tsec.init;
      sectmp.name:=trim(combobox4.text);
      
      if leftstr(combobox4.Text,2)='YG' then
        sectmp.kind:=1
      else if leftstr(combobox4.Text,2)='SJ' then
        sectmp.kind:=2
      else if leftstr(combobox4.Text,2)='GZ' then
        sectmp.kind:=3
      else if leftstr(combobox4.Text,2)='FG' then
        sectmp.kind:=4
      else  sectmp.kind:=5;
      combobox4.Text:='请选择';
      combobox4.Enabled:=false;
      sectmp.area:=strtofloat(edit1.Text);
      sectmp.ita2:=strtofloat(edit2.Text);
      sectmp.ita3:=strtofloat(edit3.Text);
      sectmp.ia2r;
      j:=spf.subsecmat.addseckind(sectmp);
      for i:=1 to spf.ne do
        if spf.bar[i].sec>j then
          spf.bar[i].sec:= spf.bar[i].sec+1;
      sectmp.Free;
      edit1.Enabled:=false;  edit2.Enabled:=false;
      edit3.Enabled:=false;
      button4.Caption:='新建';
    end;
end;

procedure Tbinfo.Button5Click(Sender: TObject);
var
  i:integer;
  sec1:Tsec;
begin
  listbox2.Clear;
  listbox2.Items.Add(' 截面名称          面积        I2       I3');
  spf.subsecmat.sno:=0;
  for i:=1 to listbox1.Count-1 do
    if listbox1.Selected[i]=true then
      listbox2.Items.Add(listbox1.Items[i]);
  sec1:=Tsec.init;
  for i:=1 to listbox2.Count-1 do
    begin
      sec1.lineinp(listbox2.Items[i]);
      sec1.kind:=strtoint(spf.subsecmat.getseckind(0,leftstr(sec1.name,2)));
      sec1.getcolor(i);
      spf.subsecmat.addseckind(sec1);
    end;
end;

end.

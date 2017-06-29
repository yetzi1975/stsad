unit load;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Tabnotbk, Gauges, Math, ent;

type
  Tloadform = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    GroupBox1: TGroupBox;
    BitBtn4: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn9: TBitBtn;
    ListBox1: TListBox;
    Label6: TLabel;
    Edit5: TEdit;
    Button4: TButton;
    Label7: TLabel;
    Button2: TButton;
    Button9: TButton;
    TabbedNotebook2: TTabbedNotebook;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    Edit6: TEdit;
    Edit9: TEdit;
    Edit7: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Gauge1: TGauge;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    BitBtn5: TBitBtn;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    Edit10: TEdit;
    Button7: TButton;
    Button10: TButton;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label10: TLabel;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    GroupBox6: TGroupBox;
    xz: TRadioButton;
    xf: TRadioButton;
    yz: TRadioButton;
    yf: TRadioButton;
    zz: TRadioButton;
    zf: TRadioButton;
    GroupBox7: TGroupBox;
    Label14: TLabel;
    Edit8: TEdit;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    GroupBox8: TGroupBox;
    Label15: TLabel;
    ProgressBar3: TProgressBar;
    Button5: TButton;
    GroupBox9: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TabbedNotebook2Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure BitBtn10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function getloadnum:byte;
    procedure g2n;
    procedure p3_face;
    procedure p3_area;
    procedure p3_vector;
    function p3_modivec(az:byte):byte;
    procedure p3_makeforce(xx:byte);
    procedure p3_deforce;      //  分配到节点
    function vecangle(a1,a2:three):single;
    function oneline(a1,a2:integer;var aa:byte):byte;
    procedure p4_face;
    procedure p4_area;
    procedure p4_vector;
    function p4_modivec(az:byte):byte;
    procedure p4_makeforce(xx:byte);
    procedure p4_deforce;    //  分配到节点
    function daoheok(aa:byte):byte;
  end;

 R3pf=record
  p1,p2,p3:integer;
  area:single;
  vec,fc:three;      //  法向量,力
  sel,flag:byte;     // flag用以区分组
  // sel 用于判断面是否同向
 end;

 R4pf=record
  p1,p2,p3,P4:integer;
  area:single;
  vec,fc:three;      //  法向量,力
  sel,flag:byte;     //  标记用以区分组
 end;

 Rwind=record                 //  风载参数
   betaz,muz,omiga0:single;    //  omiga0:kN/m2
   mus:array[1..10] of single;  //  体型系数(flag)
 end;

var
  loadform: Tloadform;
  num:array[1..10] of shortint;  //  第i类荷载在listbox1中结束的项号
  ff:af;                //   自动导荷的力数组指针(每次导荷产生一组)
  face3p:array[1..3000] of R3pf;     //  max 3000
  face4p:array[1..1000] of R4pf;     //  max 1000
  a3num,a4num:integer;
  wl:Rwind;                      //  风荷载参数
  q: array [1..10] of single;    //  均布荷载值(flag)
  jb: byte;                      //  均布参数 (31,32,21,22...)
  fifo: array [0..99,1..3] of integer;
  nok: byte;                     //  自动累加的均布参数号
  nfifo:integer;
implementation

uses MAIN, VIEW;

{$R *.DFM}
function Tloadform.getloadnum:byte;
var
 tmp:string;
 sa:byte;
begin
  sa:=0;
  if listbox1.itemindex <>-1 then
   begin
    tmp:=listbox1.items[listbox1.itemindex];
    tmp:=trim(tmp);
    if pos('D',tmp)>0 then sa:=10+strtoint(tmp[pos('D',tmp)+1])
    else if pos('L',tmp)>0 then sa:=20+strtoint(tmp[pos('L',tmp)+1])
    else if pos('W',tmp)>0 then sa:=30+strtoint(tmp[pos('W',tmp)+1])
    else if pos('C',tmp)>0 then sa:=40+strtoint(tmp[pos('C',tmp)+1])
    else if pos('E',tmp)>0 then sa:=50+strtoint(tmp[pos('E',tmp)+1]);
   result:=sa;
   end
  else result:=0;
end;

procedure Tloadform.Button4Click(Sender: TObject);  //   结构荷载布置
var
  i:byte;
  tmp:string;
begin
 if listbox1.itemindex <> -1 then
   begin
    spf.curfc:=getloadnum;
    tmp:=listbox1.items[listbox1.itemindex];
    tmp:=trim(tmp);
    hide;
    mainform.enabled:=true;
    mainform.cleansc;
    spf.drawspt(curdis);
    delete(tmp,8,8);
    mainform.statusbar1.panels.items[6].text:=tmp;
    curproc:=MNDFORCE;
    viewform.a.down:=true;     //  框选
    viewform.d.down:=true;      //   选点
    mainform.statusbar1.Panels.Items[8].Text:=' 选择受荷节点';
   end
 else
   messagedlg('请选择荷载类型!',mterror,[mbok],0);
end;

procedure Tloadform.FormCreate(Sender: TObject);
var
  st:string;
  j:shortint;
  i,k:integer;
begin
  nok:=1;
  nfifo:=-1;
  for i:=0 to 99 do
    for k:=1 to 3 do
      fifo[i][k]:=0;

  height:=265;
  //  mainform.enabled:=false;
  spf.setload(num);
   for j:=0 to num[1] do
    begin
     st:='恒载['+inttostr(j+1)+']      D'+inttostr(j+1);
     listbox1.items.add(st);
    end;
   for j:=num[1]+1 to num[2] do
    begin
     st:='活载['+inttostr(j-num[1])+']      L'+inttostr(j-num[1]);
     listbox1.items.add(st);
    end;
   for j:=num[2]+1 to num[3] do
    begin
     st:='风载['+inttostr(j-num[2])+']      W'+inttostr(j-num[2]);
     listbox1.items.add(st);
    end;
   for j:=num[3]+1 to num[4] do
    begin
     st:='吊车['+inttostr(j-num[3])+']      C'+inttostr(j-num[3]);
     listbox1.items.add(st);
    end;
   for j:=num[4]+1 to num[5] do
    begin
     st:='地震['+inttostr(j-num[4])+']      E'+inttostr(j-num[4]);
     listbox1.items.add(st);
    end;
   edit5.text:=inttostr(spf.dtemp);
end;

procedure Tloadform.BitBtn1Click(Sender: TObject);   //  恒载
var
  its:string;
  i:byte;
begin

   its:='恒载['+inttostr(num[1]+2)+']      D'+inttostr(num[1]+2);
   //  if num[1]<0 then listbox1.items.add(its)
   listbox1.items.insert(num[1]+1,its);
   spf.curfc:=10+num[1]+2;
   for i:=1 to 10 do inc(num[i]);
   spf.addforce(spf.curfc);    //  add in chain
end;

procedure Tloadform.BitBtn2Click(Sender: TObject);   //  活载
var
  its:string;
  i:byte;
begin
   its:='活载['+inttostr(num[2]-num[1]+1)+']      L'+inttostr(num[2]-num[1]+1);
   listbox1.items.insert(num[2]+1,its);
   spf.curfc:=20+num[2]-num[1]+1;
   for i:=2 to 10 do inc(num[i]);
   spf.addforce(spf.curfc);    //  add in chain
end;

procedure Tloadform.Button1Click(Sender: TObject);   //  地震
var
  its:string;
  i:byte;
begin
   its:='地震['+inttostr(num[5]-num[4]+1)+']      E'+inttostr(num[5]-num[4]+1);
   listbox1.items.insert(num[5]+1,its);
   spf.curfc:=50+num[5]-num[4]+1;
   for i:=5 to 10 do inc(num[i]);
   spf.addforce(spf.curfc);    //  add in chain

end;

procedure Tloadform.BitBtn3Click(Sender: TObject);  //  风载
var
  its:string;
  i:byte;
begin
   its:='风载['+inttostr(num[3]-num[2]+1)+']      W'+inttostr(num[3]-num[2]+1);
   listbox1.items.insert(num[3]+1,its);
   spf.curfc:=30+num[3]-num[2]+1;
   for i:=3 to 10 do inc(num[i]);
   spf.addforce(spf.curfc);    //  add in chain
end;

procedure Tloadform.BitBtn4Click(Sender: TObject); //  吊车
var
  its:string;
  i:byte;
begin
  its:='吊车['+inttostr(num[4]-num[3]+1)+']      C'+inttostr(num[4]-num[3]+1);
  listbox1.items.insert(num[4]+1,its);
  spf.curfc:=40+num[4]-num[3]+1;
  for i:=4 to 10 do inc(num[i]);
  spf.addforce(spf.curfc);    //  add in chain
end;

procedure Tloadform.BitBtn9Click(Sender: TObject);  //  delete load case
var
  tmp:string;
  i,ss:byte;
begin
  if listbox1.itemindex<>-1 then
    begin
      ss:=getloadnum;
      for i:=trunc(ss/10) to 10 do dec(num[i]);
      listbox1.items.delete(listbox1.itemindex);
      spf.delforce(ss);
    end
  else
    messagedlg('请选择要删除荷载类型!',mtwarning,[mbok],0);
end;

procedure Tloadform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if bitbtn8.Visible=false then
  begin
   curproc:=READY;
   mainform.enabled:=true;
   if edit5.text<>'' then
     spf.dtemp:=strtoint(edit5.text);
  end
else
  Action:=caNone;
end;

procedure Tloadform.Button2Click(Sender: TObject);
begin
  curbv[LOA]:=1;  curbv[SOLV]:=0;
  close;
end;

procedure Tloadform.Button3Click(Sender: TObject);
var
  ff:textfile;
  i:integer;
begin     //  begin to make wind load
  wl.muz:=strtofloat(edit9.text);
  wl.betaz:=strtofloat(edit7.text);
  wl.omiga0:=strtofloat(edit6.text);
   g2n;
   progressbar1.position:=5;
   p3_face;
   progressbar1.position:=40;
   p4_face;
   progressbar1.position:=100;

   p3_vector;
     progressbar2.position:=5;
   p3_area;
      progressbar2.position:=15;
   if p3_modivec(1)=1 then
     progressbar2.position:=25
   else
     begin
       progressbar1.position:=0;
       progressbar2.position:=0;
       for i:=1 to spf.np do
            spf.node[i].sel:=0;
       for i:=1 to spf.ne do
         begin
           spf.bar[i].sel:=0;
           spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;    //  清空组标记
         end;
       exit;
     end;
   p3_makeforce(1);             // wind load
      progressbar2.position:=40;
   p3_deforce;
      progressbar2.position:=50;
   p4_vector;
    progressbar2.position:=55;
   p4_area;
     progressbar2.position:=65;
   if p4_modivec(1)=1 then
        progressbar2.position:=75
   else
     begin
       progressbar1.position:=0;
       progressbar2.position:=0;
       for i:=1 to spf.np do
            spf.node[i].sel:=0;
       for i:=1 to spf.ne do
         begin
           spf.bar[i].sel:=0;
           spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;    //  清空组标记
         end;
       exit;
     end;
   p4_makeforce(1);             // wind load
   progressbar2.position:=90;
   p4_deforce;
   progressbar2.position:=100;
  assignfile(ff,'wind.dat');      //  写到文件中
  rewrite(ff);
  for i:=1 to a3num do
    writeln(ff,i:5,face3p[i].p1:5,face3p[i].p2:5,face3p[i].p3:5,
      face3p[i].vec.x:5:1,face3p[i].vec.y:5:1,face3p[i].vec.z:5:1,' @',
      face3p[i].area:5:1,face3p[i].flag:2);
  for i:=1 to a4num do
    writeln(ff,i:5,face4p[i].p1:5,face4p[i].p2:5,face4p[i].p3:5,
      face4p[i].p4:5,face4p[i].vec.x:5:1,face4p[i].vec.y:5:1,
      face4p[i].vec.z:5:1,' @',face4p[i].area:5:1,face4p[i].flag:2);

  closefile(ff);
end;

procedure Tloadform.Button10Click(Sender: TObject);
begin    //  clean select face

end;

procedure Tloadform.g2n;
var     //   选中组杆件的节点也选中
  i:integer;
begin
  for i:=1 to spf.np do
   spf.node[i].sel:=0;
  for i:=1 to spf.ne do
   if (spf.bar[i].grp) mod 10 <>0 then
      begin
        spf.node[spf.bar[i].nf].sel:=1;
        spf.node[spf.bar[i].nl].sel:=1;
      end;
end;

function Tloadform.oneline(a1,a2:integer;var aa:byte):byte;
var     //   两点是否在被选杆件中,并返回杆件组号
  flag:byte;
  i,j:integer;
begin
  flag:=0;
  for i:=0 to 99 do
   begin
    if fifo[i,1]=0 then break;
    if (a1=fifo[i,1]) and (a2=fifo[i,2]) then
     begin
      flag:=1; aa:= fifo[i,3] mod 10; break;
     end
    else if (a1=fifo[i,2]) and (a2=fifo[i,1]) then
     begin
      flag:=1; aa:= fifo[i,3] mod 10; break;
     end;
   end;
  if flag=1 then
    begin
     result:=flag;
     exit;
    end;
  flag:=0;
  for i:=1 to spf.ne do
   if (spf.bar[i].grp mod 10)<>0 then
    begin
     if (a1=spf.bar[i].nf) and (a2=spf.bar[i].nl) then
      begin
      for j:=0 to 6 do
       if (i+j <= spf.ne) then
         begin
          nfifo:=(nfifo+1) mod 100  ;
          fifo[nfifo,1]:= spf.bar[i+j].nf;
          fifo[nfifo,2]:= spf.bar[i+j].nl;
          fifo[nfifo,3]:= spf.bar[i+j].grp;
         end;
        flag:=1; aa:= spf.bar[i].grp mod 10; break;  //  均布参数
      end
     else if (a2=spf.bar[i].nf) and (a1=spf.bar[i].nl) then
      begin
       for j:=0 to 6 do
        if (i+j <= spf.ne) then
         begin
          nfifo:=(nfifo+1) mod 100 ;
          fifo[nfifo,1]:= spf.bar[i+j].nf;
          fifo[nfifo,2]:= spf.bar[i+j].nl;
          fifo[nfifo,3]:= spf.bar[i+j].grp;
         end;
       flag:=1; aa:= spf.bar[i].grp mod 10; break;  //  均布参数
      end;
    end;
   result:=flag;
end;

procedure Tloadform.p3_face;
var      //  生成三点面
  i,j,k,num:integer;
  a:array [1..3] of byte;
begin
  num:=0;
  for i:=1 to 3 do
   a[i]:=0;
  for i:=1 to spf.np do
   begin
   if spf.node[i].sel=1 then
    for j:=i to spf.np do
     if (spf.node[j].sel=1) and (oneline(i,j,a[1])=1) then
      for k:=j to spf.np do
        if (spf.node[k].sel=1) and (oneline(i,k,a[2])=1) and
           (oneline(j,k,a[3])=1) then
          begin
           inc(num);
           face3p[num].p1:=i;
           face3p[num].p2:=j;
           face3p[num].p3:=k;
           face3p[num].flag:=a[1];     // decide face flag
           if (a[1]<>a[2]) and (a[2]=a[3]) then face3p[num].flag:=a[2];

          end;
   end;
  a3num:=num;
end;

procedure Tloadform.p3_area;
var
  i:integer;
begin       //   calculate the area of a 3-point face
  for i:=1 to a3num do
   begin       //  数量积开方的一半
    face3p[i].area:=sqrt(face3p[i].vec.x*face3p[i].vec.x
        +face3p[i].vec.y*face3p[i].vec.y
        +face3p[i].vec.z*face3p[i].vec.z)/2;
   end;
end;

procedure Tloadform.p3_vector;
var
  i:integer;
  x1,y1,x2,y2,z1,z2:single;
begin   //  生成面法向量(不单位化)
for i:=1 to a3num do
 begin
   x1:=spf.node[face3p[i].p3].x-spf.node[face3p[i].p1].x;
   y1:=spf.node[face3p[i].p3].y-spf.node[face3p[i].p1].y;
   z1:=spf.node[face3p[i].p3].z-spf.node[face3p[i].p1].z;
   x2:=spf.node[face3p[i].p2].x-spf.node[face3p[i].p1].x;
   y2:=spf.node[face3p[i].p2].y-spf.node[face3p[i].p1].y;
   z2:=spf.node[face3p[i].p2].z-spf.node[face3p[i].p1].z;
   face3p[i].vec.x:=y1*z2-z1*y2;
   face3p[i].vec.y:=z1*x2-x1*z2;
   face3p[i].vec.z:=x1*y2-x2*y1;
 end;
end;

function Tloadform.vecangle(a1,a2:three):single;
var       //   两向量的夹角
  cs:single;
begin
  cs:=a1.x*a2.x+a1.y*a2.y+a1.z*a2.z;
  cs:=cs/sqrt(a1.x*a1.x+a1.y*a1.y+a1.z*a1.z);
  cs:=cs/sqrt(a2.x*a2.x+a2.y*a2.y+a2.z*a2.z);
  cs:=arccos(cs)*180/3.1415926;
  result:=cs;
end;

function Tloadform.p3_modivec(az:byte):byte;
var
  zz:three;
  i,kk,j:integer;
  jj:single;
begin    //  使相邻面的法向量一致; az=1: 正向Z;  az=0: 负向Z
 if a3num<1 then
  begin
    result:=1;
    exit;
  end;
 if az=1 then
  begin
   zz.x:=0;
   zz.y:=0;
   zz.z:=1;
  end
 else
  begin
   zz.x:=0;
   zz.y:=0;
   zz.z:=-1;
  end;

 for i:=1 to a3num do
   face3p[i].sel:=0;

 jj:=vecangle(face3p[1].vec,zz);   //  angle between first face and Z
 if (jj>90) then
  begin
    face3p[1].vec.x:=-face3p[1].vec.x;
    face3p[1].vec.y:=-face3p[1].vec.y;
    face3p[1].vec.z:=-face3p[1].vec.z;
  end;
  face3p[1].sel:=1;

 for i:=2 to a3num do    // angle between first face & followed face should <90d
  begin
    kk:=0;
     for j:=i-1 downto 1 do
      begin
       if (face3p[i].p1=face3p[j].p2) or (face3p[i].p1=face3p[j].p2) or
          (face3p[i].p1=face3p[j].p3) then
        begin        //  2nd or 3rd meet
         jj:=vecangle(face3p[i].vec,face3p[j].vec);
         if (jj>45) and (jj<135) then   //  不连续
          begin
           messagedlg('三边受荷面不连续!',mtwarning,[mbok],0);
           result:=0;
           exit;
          end
         else if (jj>135) then        //   reverse the vector
          begin
            face3p[i].vec.x:=-face3p[i].vec.x;
            face3p[i].vec.y:=-face3p[i].vec.y;
            face3p[i].vec.z:=-face3p[i].vec.z;
          end;
         face3p[i].sel:=1;
         kk:=1;
         break;
        end;   //  end of if
      end;   //  end of for j
    if kk=0 then     //  any point not meet
     begin
     jj:=vecangle(face3p[i].vec,zz);   //  angle between first face and Z
     if (jj>90) then
      begin
       face3p[i].vec.x:=-face3p[i].vec.x;
       face3p[i].vec.y:=-face3p[i].vec.y;
       face3p[i].vec.z:=-face3p[i].vec.z;
      end;
     face3p[i].sel:=1;
     end;
   
  end;     //  end of for i
 result:=1;
end;

procedure Tloadform.p3_makeforce(xx:byte);  //  1- wind ; 2x- all ; 3x- project
var                             //  xx=21,31:  x+  ; xx=22,32:  x-
i:integer;                       //  xx=23,33:  y+  ; xx=24,34:  y-
ffv,la,csx,csy,csz:single;        //  xx=25,35:  z+  ; xx=26,36:  z-
ax,ay,az:single;
begin
  if (xx=1) then         //  wind load
   for i:=1 to a3num do
    begin
      ffv:=-1*wl.betaz*wl.mus[face3p[i].flag]*wl.muz*wl.omiga0*face3p[i].area;
          //  风压体型系数压为正
      la:=sqrt(face3p[i].vec.x*face3p[i].vec.x
           +face3p[i].vec.y*face3p[i].vec.y+face3p[i].vec.z*face3p[i].vec.z);
      csx:=face3p[i].vec.x/la;
      csy:=face3p[i].vec.y/la;
      csz:=face3p[i].vec.z/la;     //  单位化
      face3p[i].fc.x:=csx*ffv;
      face3p[i].fc.y:=csy*ffv;
      face3p[i].fc.z:=csz*ffv;
    end
  else if (xx / 10 >2) then     //   surface load
   begin
    if (xx mod 10 =1) then      //  x+
      begin
        ax:=1; ay:=0; az:=0;
      end
     else if (xx mod 10 =2) then    // x-
      begin
        ax:=-1; ay:=0; az:=0;
      end
     else if (xx mod 10 =3) then    //  y+
      begin
        ax:=0; ay:=1; az:=0;
      end
     else if (xx mod 10 =4) then     //  y-
      begin
        ax:=0; ay:=-1; az:=0;
      end
     else if (xx mod 10 =5) then    //  z+
      begin
        ax:=0; ay:=0; az:=1;
      end
     else if (xx mod 10 =6) then     //  z- :gravity direction
      begin
        ax:=0; ay:=0; az:=-1;
      end;

    if (xx/10 <3) then      //    all area
     for i:=1 to a3num do
       begin
        face3p[i].fc.x:=ax*q[face3p[i].flag]*face3p[i].area;
        face3p[i].fc.y:=ay*q[face3p[i].flag]*face3p[i].area;
        face3p[i].fc.z:=az*q[face3p[i].flag]*face3p[i].area;
       end
    else if (xx/10 <4)  then     //  project area
     for i:=1 to a3num do
       begin
        la:=sqrt(face3p[i].vec.x*face3p[i].vec.x+face3p[i].vec.y*face3p[i].vec.y
           +face3p[i].vec.z*face3p[i].vec.z);
        csx:=face3p[i].vec.x/la;
        csy:=face3p[i].vec.y/la;
        csz:=face3p[i].vec.z/la;     //  单位化
        face3p[i].fc.x:=ax*q[face3p[i].flag]*face3p[i].area*csx;
        face3p[i].fc.y:=ay*q[face3p[i].flag]*face3p[i].area*csy;
        face3p[i].fc.z:=az*q[face3p[i].flag]*face3p[i].area*csz;
       end;
   end;  //  end of else if
end;

procedure Tloadform.p3_deforce;
var
  i,pp1,pp2,pp3: integer;
begin
  for i:=1 to a3num do
   begin
     pp1:= face3p[i].p1;
     pp2:= face3p[i].p2;
     pp3:= face3p[i].p3;

     ff^[pp1].x:=ff^[pp1].x+face3p[i].fc.x/3;
     ff^[pp2].x:=ff^[pp2].x+face3p[i].fc.x/3;
     ff^[pp3].x:=ff^[pp3].x+face3p[i].fc.x/3;

     ff^[pp1].y:=ff^[pp1].y+face3p[i].fc.y/3;
     ff^[pp2].y:=ff^[pp2].y+face3p[i].fc.y/3;
     ff^[pp3].y:=ff^[pp3].y+face3p[i].fc.y/3;

     ff^[pp1].z:=ff^[pp1].z+face3p[i].fc.z/3;
     ff^[pp2].z:=ff^[pp2].z+face3p[i].fc.z/3;
     ff^[pp3].z:=ff^[pp3].z+face3p[i].fc.z/3;
   end;
end;

procedure Tloadform.p4_face;
var
  i,j,k,n,num:integer;
  a:array [1..4] of byte;
begin
  num:=0;
  for i:=1 to 4 do
    a[i]:=0;
 for i:=1 to spf.np do
  if spf.node[i].sel=1 then
   for j:=i+1 to spf.np do
     if (spf.node[j].sel=1) and (oneline(i,j,a[1])=1) then
      for k:=j+1 to spf.np do
        begin
         if (spf.node[k].sel=1) and
            (oneline(i,k,a[2])=1) and (oneline(j,k,a[3])=0) then
                //  assure not a triangle
          begin
           for n:=k+1 to spf.np do
             if (spf.node[n].sel=1) and (oneline(n,i,a[3])=0)
                and (oneline(n,k,a[4])=1) and (oneline(n,j,a[3])=1) then
               begin
                inc(num);
                face4p[num].p1:=i;
                face4p[num].p2:=j;
                face4p[num].p3:=k;
                face4p[num].p4:=n;
                face4p[num].flag:=a[1];     // decide face flag
                if (a[1]=a[2]) then  face4p[num].flag:=a[1]
                else
                  begin
                   if (a[2]=a[3]) or (a[2]=a[4]) then  face4p[num].flag:=a[2]
                   else
                     begin
                      if (a[3]=a[4]) then
                         face4p[num].flag:=a[3]
                      else face4p[num].flag:=a[4] //   ?? !!!
                     end;
                  end;

               end;
           end   //  end of if k.sel=1
         else if (spf.node[k].sel=1) and
                 (oneline(i,k,a[3])=0) and (oneline(j,k,a[2])=1) then
                //  assure not a triangle
           begin
           for n:=k+1 to spf.np do
             if (spf.node[n].sel=1) and (oneline(n,j,a[3])=0) and
               (oneline(n,i,a[3])=1) and (oneline(n,k,a[4])=1) then
               begin
                inc(num);
                face4p[num].p1:=i;
                face4p[num].p2:=j;
                face4p[num].p3:=k;
                face4p[num].p4:=n;
                if (a[1]=a[2]) then  face4p[num].flag:=a[1]
                else
                  begin
                   if (a[2]=a[3]) or (a[2]=a[4]) then  face4p[num].flag:=a[2]
                   else
                     begin
                      if (a[3]=a[4]) then
                         face4p[num].flag:=a[3]
                      else face4p[num].flag:=a[4] //   ?? !!!
                     end;
                  end;

               end;  // end of if
           end;    // end of else if
         end;    // end of for k
  a4num:=num;
end;

procedure Tloadform.p4_vector;
var
  i:integer;
  x1,x2,y1,y2,z1,z2:single;
begin       //  生成面法向量(不单位化)
  for i:=1 to a4num do
   begin
    x1:=spf.node[face4p[i].p3].x-spf.node[face4p[i].p1].x;
    y1:=spf.node[face4p[i].p3].y-spf.node[face4p[i].p1].y;
    z1:=spf.node[face4p[i].p3].z-spf.node[face4p[i].p1].z;
    x2:=spf.node[face4p[i].p2].x-spf.node[face4p[i].p1].x;
    y2:=spf.node[face4p[i].p2].y-spf.node[face4p[i].p1].y;
    z2:=spf.node[face4p[i].p2].z-spf.node[face4p[i].p1].z;
    face4p[i].vec.x:=y1*z2-z1*y2;
    face4p[i].vec.y:=z1*x2-x1*z2;
    face4p[i].vec.z:=x1*y2-x2*y1;

    x1:=spf.node[face4p[i].p4].x-spf.node[face4p[i].p1].x;
    y1:=spf.node[face4p[i].p4].y-spf.node[face4p[i].p1].y;
    z1:=spf.node[face4p[i].p4].z-spf.node[face4p[i].p1].z;
    x2:=spf.node[face4p[i].p2].x-spf.node[face4p[i].p1].x;
    y2:=spf.node[face4p[i].p2].y-spf.node[face4p[i].p1].y;
    z2:=spf.node[face4p[i].p2].z-spf.node[face4p[i].p1].z;
    face4p[i].vec.x:=(face4p[i].vec.x+y1*z2-z1*y2)/2;
    face4p[i].vec.y:=(face4p[i].vec.y+z1*x2-x1*z2)/2;
    face4p[i].vec.z:=(face4p[i].vec.z+x1*y2-x2*y1)/2;
   end;
end;

procedure Tloadform.p4_area;
var
  i:integer;
  x1,x2,y1,y2,z1,z2 :single;
  v1,v2:three;
begin       //   calculate the area of a 4-point face
  for i:=1 to a4num do
   begin
     x1:=spf.node[face4p[i].p3].x-spf.node[face4p[i].p1].x;
     y1:=spf.node[face4p[i].p3].y-spf.node[face4p[i].p1].y;
     z1:=spf.node[face4p[i].p3].z-spf.node[face4p[i].p1].z;
     x2:=spf.node[face4p[i].p2].x-spf.node[face4p[i].p1].x;
     y2:=spf.node[face4p[i].p2].y-spf.node[face4p[i].p1].y;
     z2:=spf.node[face4p[i].p2].z-spf.node[face4p[i].p1].z;
     v1.x:=y1*z2-z1*y2;
     v1.y:=z1*x2-x1*z2;
     v1.z:=x1*y2-x2*y1;

     x1:=spf.node[face4p[i].p3].x-spf.node[face4p[i].p4].x;
     y1:=spf.node[face4p[i].p3].y-spf.node[face4p[i].p4].y;
     z1:=spf.node[face4p[i].p3].z-spf.node[face4p[i].p4].z;
     x2:=spf.node[face4p[i].p2].x-spf.node[face4p[i].p4].x;
     y2:=spf.node[face4p[i].p2].y-spf.node[face4p[i].p4].y;
     z2:=spf.node[face4p[i].p2].z-spf.node[face4p[i].p4].z;
     v2.x:=y1*z2-z1*y2;
     v2.y:=z1*x2-x1*z2;
     v2.z:=x1*y2-x2*y1;
                         //  以上只能计算平行四边形(不是任意四边形)
     face4p[i].area:=sqrt(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z)/2;
     face4p[i].area:=face4p[i].area+sqrt(v2.x*v2.x+v2.y*v2.y+v2.z*v2.z)/2;
   end;
end;

function Tloadform.p4_modivec(az:byte):byte;
var
  zz:three;
  i,j,kk:integer;
  jj:single;
begin    //  使相邻面的法向量一致; az=1: 正向Z;  az=0: 负向Z
if a4num<1 then
  begin
    result:=1;
    exit;
  end;
 if az=1 then
  begin
   zz.x:=0;
   zz.y:=0;
   zz.z:=1;
  end
 else
  begin
   zz.x:=0;
   zz.y:=0;
   zz.z:=-1;
  end;

 for i:=1 to a4num do  //  选中标记全清零
   face4p[i].sel:=0;

 jj:=vecangle(face4p[1].vec,zz);  //  若垂直于Z轴则可能????
 if (jj>90) then
  begin
    face4p[1].vec.x:=-face4p[1].vec.x;
    face4p[1].vec.y:=-face4p[1].vec.y;
    face4p[1].vec.z:=-face4p[1].vec.z;
  end;
  face4p[1].sel:=1;

 for i:=2 to a4num do
  begin
    kk:=0;
     for j:=i-1 downto 1 do
      begin
       if (face4p[i].p1=face4p[j].p2) or (face4p[i].p1=face4p[j].p2) or
         (face4p[i].p1=face4p[j].p3) or (face4p[i].p1=face4p[j].p4) then
        begin
         jj:=vecangle(face4p[i].vec,face4p[j].vec);
         if (jj>45) and (jj<135) then
          begin
           messagedlg('四边受荷面不连续!',mtwarning,[mbok],0);
           result:=0;
           exit;
          end
         else if (jj>135) then
          begin
            face4p[i].vec.x:=-face4p[i].vec.x;
            face4p[i].vec.y:=-face4p[i].vec.y;
            face4p[i].vec.z:=-face4p[i].vec.z;
          end;
         face4p[i].sel:=1;
         kk:=1;
         break;
        end;   //  end of if
      end;   //  end of for j
  if kk=0 then
     begin
       jj:=vecangle(face4p[i].vec,zz);  //  若垂直于Z轴则可能????
       if (jj>90) then
         begin
           face4p[i].vec.x:=-face4p[i].vec.x;
           face4p[i].vec.y:=-face4p[i].vec.y;
           face4p[i].vec.z:=-face4p[i].vec.z;
         end;
       face4p[i].sel:=1;
     end;
  end;     //  end of for i
 result:=1;
end;

procedure Tloadform.p4_makeforce(xx:byte);  //  1- wind ; 2x- total ; 3x- project
var                         //  xx=21,31:  x+  ; xx=22,32:  x-
i:integer;                        //  xx=23,33:  y+  ; xx=24,34:  y-
ffa,la,csx,csy,csz:single;               //  xx=25,35:  z+  ; xx=26,36:  z-
ax,ay,az:single;
begin
  if (xx=1) then         //  wind load
   for i:=1 to a4num do
    begin
      ffa:=-1*wl.betaz*wl.mus[face4p[i].flag]*wl.muz*wl.omiga0*face4p[i].area;    //  风压体型系数压为正
      la:=sqrt(face4p[i].vec.x*face4p[i].vec.x
           +face4p[i].vec.y*face4p[i].vec.y+face4p[i].vec.z*face4p[i].vec.z);
      csx:=face4p[i].vec.x/la;
      csy:=face4p[i].vec.y/la;
      csz:=face4p[i].vec.z/la;    //  单位化
      face4p[i].fc.x:=csx*ffa;
      face4p[i].fc.y:=csy*ffa;
      face4p[i].fc.z:=csz*ffa;
    end
  else if (xx / 10 >2) then     //   surface load
   begin
    if (xx mod 10 =1) then      //  x+
      begin
        ax:=1; ay:=0; az:=0;
      end
     else if (xx mod 10 =2) then    // x-
      begin
        ax:=-1; ay:=0; az:=0;
      end
     else if (xx mod 10 =3) then    //  y+
      begin
        ax:=0; ay:=1; az:=0;
      end
     else if (xx mod 10 =4) then     //  y-
      begin
        ax:=0; ay:=-1; az:=0;
      end
       else if (xx mod 10 =5) then    //  z+
      begin
        ax:=0; ay:=0; az:=1;
      end
     else if (xx mod 10 =6) then     //  z- :gravity direction
      begin
        ax:=0; ay:=0; az:=-1;
      end;

    if (xx/10 <3) then      //   all area
     for i:=1 to a4num do
       begin
        face4p[i].fc.x:=ax*q[face4p[i].flag]*face4p[i].area;
        face4p[i].fc.y:=ay*q[face4p[i].flag]*face4p[i].area;
        face4p[i].fc.z:=az*q[face4p[i].flag]*face4p[i].area;
       end
    else if (xx/10 <4)  then     //  project area
     for i:=1 to a4num do
       begin
        la:=sqrt(face4p[i].vec.x*face4p[i].vec.x+face4p[i].vec.y*face4p[i].vec.y
           +face4p[i].vec.z*face4p[i].vec.z);
        csx:=face4p[i].vec.x/la;
        csy:=face4p[i].vec.y/la;
        csz:=face4p[i].vec.z/la;      //  单位化
        face4p[i].fc.x:=ax*q[face4p[i].flag]*face4p[i].area*csx;
        face4p[i].fc.y:=ay*q[face4p[i].flag]*face4p[i].area*csy;
        face4p[i].fc.z:=az*q[face4p[i].flag]*face4p[i].area*csz;
       end;
  end;  //  end of (xx mod 10 >=2)
end;

procedure Tloadform.p4_deforce;
var
  i,pp1,pp2,pp3,pp4:integer;
begin
 for i:=1 to a4num do
   begin
     pp1:= face4p[i].p1;
     pp2:= face4p[i].p2;
     pp3:= face4p[i].p3;
     pp4:= face4p[i].p4;

     ff^[pp1].x:=ff^[pp1].x+face4p[i].fc.x/4;
     ff^[pp2].x:=ff^[pp2].x+face4p[i].fc.x/4;
     ff^[pp3].x:=ff^[pp3].x+face4p[i].fc.x/4;
     ff^[pp4].x:=ff^[pp4].x+face4p[i].fc.x/4;

     ff^[pp1].y:=ff^[pp1].y+face4p[i].fc.y/4;
     ff^[pp2].y:=ff^[pp2].y+face4p[i].fc.y/4;
     ff^[pp3].y:=ff^[pp3].y+face4p[i].fc.y/4;
     ff^[pp4].y:=ff^[pp4].y+face4p[i].fc.y/4;

     ff^[pp1].z:=ff^[pp1].z+face4p[i].fc.z/4;
     ff^[pp2].z:=ff^[pp2].z+face4p[i].fc.z/4;
     ff^[pp3].z:=ff^[pp3].z+face4p[i].fc.z/4;
     ff^[pp4].z:=ff^[pp4].z+face4p[i].fc.z/4;
   end;
 end;

function Tloadform.daoheok(aa:byte):byte;
var
  i:integer;
  pp:pf;
begin
  pp:=spf.ndforce;
  i:=0;
  while pp<>nil do
   begin
     if pp^.kind=aa then
      begin
       i:=1;
       break;
      end;
     pp:=pp^.next;
   end;
  if i=0 then
   begin
    result:=0;
    exit; //  not found;
   end;
 for i:=1 to spf.np do
  begin
    pp^.header^[i].x:=ff^[i].x;
    pp^.header^[i].y:=ff^[i].y;
    pp^.header^[i].z:=ff^[i].z;
  end;
  result:=1;
end;

procedure Tloadform.Button9Click(Sender: TObject);
var
 i:integer;
begin    //  auto calculate load
   if listbox1.itemindex <> -1 then
   begin
    spf.curfc:=getloadnum;
    TabbedNotebook1.hide;
    TabbedNotebook2.show;
    TabbedNotebook2.top:=0;
    bitbtn6.show;
    bitbtn7.show;
    bitbtn8.show;
    mainform.cleansc;
    spf.drawspt(curdis);
    getmem(ff,sizeof(three)*spf.np);    //  申请数组
    for i:=1 to spf.np do
     begin
       ff^[i].x:=0.0;
       ff^[i].y:=0.0;
       ff^[i].z:=0.0;
     end;
   end
 else
   messagedlg('请选择荷载类型!',mtwarning,[mbok],0);

end;

procedure Tloadform.Button7Click(Sender: TObject);
begin     //  select load surface
  curproc:= SELSURFACE;
  loadform.hide;
  mainform.enabled:=true;
  viewform.panel2.top:=8;
  viewform.panel2.left:=-112;
  viewform.a.down:=true;
  viewform.h.down:=true;
end;

procedure Tloadform.BitBtn6Click(Sender: TObject);
var
  i:integer;
begin   //  确定: 将ff联入ndforce中,并退出
  for i:=1 to spf.np do
     spf.node[i].sel:=0;
  for i:=1 to spf.ne do
   begin
    spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10; //  清空组标记
    spf.bar[i].sel:=0;
   end;
  daoheok(spf.curfc);
  freemem(ff);
  bitbtn6.hide;
  bitbtn7.hide;
  bitbtn8.hide;
  TabbedNotebook1.show;
  TabbedNotebook2.hide;
  spf.curgrp:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tloadform.BitBtn7Click(Sender: TObject);
var
  i:integer;
begin   // 重做:  将ff全部清空
 for i:=1 to spf.np do
  begin
   ff^[i].x:=0;
   ff^[i].y:=0;
   ff^[i].z:=0;
   spf.node[i].sel:=0;
  end;
 for i:=1 to spf.ne do
  begin
    spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;   //  清空组标记
    spf.bar[i].sel:=0;
  end;
  showmessage('请重选受荷面！');
  spf.curgrp:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tloadform.FormShow(Sender: TObject);
var
  aa:byte;
  i:integer;
begin    //  显示窗体时
if curproc<>SELSURFACE then exit;
 aa:=0;
  for i:=1 to spf.ne do
   if spf.bar[i].sel=1 then
     begin
       spf.bar[i].sel:=0;
       spf.bar[i].grp:=trunc(spf.bar[i].grp / 10)*10;    // 去掉个位
       spf.bar[i].grp:= spf.bar[i].grp+nok;              //  设置“组号”
       if tabbednotebook2.activepage='面荷载' then
         q[nok]:= strtofloat(edit8.text)
       else if tabbednotebook2.activepage='风荷载' then
         wl.mus[nok]:=strtofloat(edit10.text);
       aa:=1;
     end;

   if aa<>0 then
     begin
       //  spf.curgrp:=nok;
       mainform.cleansc;
       spf.drawspt(curdis);
       nok:=nok+1;
     end;
end;
                             
procedure Tloadform.BitBtn8Click(Sender: TObject);
var
 i:integer;
begin   // just exit
 for i:=1 to spf.np do
    spf.node[i].sel:=0;
 for i:=1 to spf.ne do
  begin
   spf.bar[i].sel:=0;
   spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;    //  清空组标记
  end;
  freemem(ff);
  bitbtn6.hide;
  bitbtn7.hide;
  bitbtn8.hide;
  TabbedNotebook1.show;
  TabbedNotebook2.hide;
  spf.curgrp:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tloadform.Button5Click(Sender: TObject);
var
  i:integer;
begin      //  计算均布荷载
 if xz.checked=true then jb:=1
 else if xf.checked=true then jb:=2
 else if yz.checked=true then jb:=3
 else if yf.checked=true then jb:=4
 else if zz.checked=true then jb:=5
 else if zf.checked=true then jb:=6;
 if radiobutton4.checked= true then jb:=jb+20    //  total area
 else if radiobutton5.checked= true then jb:=jb+30;  //  project area
 g2n;
 progressbar3.position:= 5;
   p3_face;
 progressbar3.position:=35;
   p3_vector;
   p3_area;
   if p3_modivec(1)=1 then
     progressbar2.position:=45
   else
     begin
       progressbar1.position:=0;
       progressbar2.position:=0;
       for i:=1 to spf.np do
            spf.node[i].sel:=0;
       for i:=1 to spf.ne do
         begin
           spf.bar[i].sel:=0;
           spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;    //  清空组标记
         end;
       exit;
     end;
   p3_makeforce(jb);  //  load
   p3_deforce;
   progressbar3.position:=60;
   p4_face;
 progressbar3.position:=75;
   p4_vector;
   p4_area;
   if p4_modivec(1)=1 then
     progressbar2.position:=90
   else
     begin
       progressbar1.position:=0;
       progressbar2.position:=0;
       for i:=1 to spf.np do
            spf.node[i].sel:=0;
       for i:=1 to spf.ne do
         begin
           spf.bar[i].sel:=0;
           spf.bar[i].grp:=trunc(spf.bar[i].grp /10)*10;    //  清空组标记
         end;
       exit;
     end;
   p4_makeforce(jb);  //  load
   p4_deforce;
  progressbar3.position:=100;
end;

procedure Tloadform.TabbedNotebook2Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  i:integer;
begin
  if tabbednotebook2.activepage='面荷载' then
    begin
     nok:=1;
     progressbar1.position:=0;
     progressbar2.position:=0;
     progressbar3.position:=0;
     for i:=1 to spf.np do
      begin
       ff^[i].x:=0.0;
       ff^[i].y:=0.0;
       ff^[i].z:=0.0;
      end;
    end
  else if  tabbednotebook2.activepage='地震荷载' then
    begin
     nok:=1;
     progressbar1.position:=0;
     progressbar2.position:=0;
     progressbar3.position:=0;
     for i:=1 to spf.np do
      begin
       ff^[i].x:=0.0;
       ff^[i].y:=0.0;
       ff^[i].z:=0.0;
      end;
    end
  else if  tabbednotebook2.activepage='风荷载' then
    begin
     nok:=1;
     progressbar1.position:=0;
     progressbar2.position:=0;
     progressbar3.position:=0;
     for i:=1 to spf.np do
      begin
       ff^[i].x:=0.0;
       ff^[i].y:=0.0;
       ff^[i].z:=0.0;
      end;
    end;
end;

procedure Tloadform.BitBtn10Click(Sender: TObject);
begin  //  select load surface
  curproc:= SELSURFACE;
  loadform.hide;
  mainform.enabled:=true;
  viewform.panel2.top:=8;
  viewform.panel2.left:=-112;
  viewform.a.down:=true;
  viewform.h.down:=true;

end;

end.

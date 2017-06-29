unit inq;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, Grids, Buttons ;

type
  Tinqform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  inqform: Tinqform;
  num: integer;
implementation
uses  ent, MAIN;
{$R *.DFM}

procedure Tinqform.FormCreate(Sender: TObject);
var
  i,t1,t2:integer;
  a,b,t3:single;
  strx,stry,strz:string[30];
  pp:pf;
begin
   //   StringGrid1.enabled:=false;
  if curproc=NDQST then
    begin
     num:=0;
      for i:=1 to spf.np do
       if spf.node[i].sel=1 then
          begin
           if num=0 then num:=i
           else num:=-1;
          end;
     if num<0 then     // not single node
       begin
         height:=100;
         label1.top:=10;
         label1.caption:='┌─────┐'+#13+
         '│  错  误  │     请选择单个节点!'+#13+'└─────┘';
         label2.caption:='';
         label3.caption:='';
         speedbutton1.hide;
       end
     else   //   single node
     begin
     height:=240;
     label1.top:=5;
     label2.top:=30;
     i:=spf.node[num].ys;
     if i>=100 then strx:=' 米          [1]'
     else strx:=' 米          [0]';
     if (i mod 100)>=10 then stry:=' 米          [1]'
     else stry:=' 米          [0]';
     if (i mod 10)>=1 then strz:=' 米          [1]'
     else strz:=' 米          [0]';

     if spf.node[num].ys>111 then strx:=strx+'(弹性)';
     if (spf.node[num].ys mod 100)>11 then stry:=stry+'(弹性)';
     if (spf.node[num].ys mod 10)>1 then strz:=strz+'(弹性)';

     label1.caption:='节点号:  ['+inttostr(num)+']';
     label2.caption:='节点坐标:                 约束'+#13+
        ' X: '+format('%10.3f',[spf.node[num].x])+strx+#13
       +' Y: '+format('%10.3f',[spf.node[num].y])+stry+#13
       +' Z: '+format('%10.3f',[spf.node[num].z])+strz;
     label3.caption:='';
     with StringGrid1 do
      begin
       Cells[0,0]:='  荷载';
       cells[1,0]:='  X <kN>';
       cells[2,0]:='  Y <kN>';
       cells[3,0]:='  Z <kN>';
       pp:=spf.ndforce;
       i:=0;
       while pp<>nil do
        begin
         i:=i+1;
         if trunc(pp^.kind /10)=1 then
          cells[0,i]:='恒['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=2 then
          cells[0,i]:='活['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=3 then
          cells[0,i]:='风['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=4 then
          cells[0,i]:='吊['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=5 then
          cells[0,i]:='震['+inttostr(pp^.kind mod 10)+']';
          cells[1,i]:=format('%7.2f',[pp^.header^[num].x]);
          cells[2,i]:=format('%7.2f',[pp^.header^[num].y]);
          cells[3,i]:=format('%7.2f',[pp^.header^[num].z]);
          pp:=pp^.next;
        end;

       end;
     end
    end
  else if curproc=BARQST then
    begin
    stringgrid1.hide;
    speedbutton1.hide;
     num:=0;
      for i:=1 to spf.ne do
        if spf.bar[i].sel=1 then
          begin
           if num=0 then num:=i
           else num:=-1;
          end;
      if num<0 then     //   not single element
       begin
         height:=100;
         label1.top:=10;
         label1.caption:='┌─────┐'+#13+
         '│  错  误  │     请选择单根杆件!'+#13+'└─────┘';
         label2.caption:='';
         label3.caption:='';
         speedbutton1.hide;
       end
     else            //   single element
       begin
         height:=200;
         label1.top:=5;
         label2.top:=50;
         label3.Top:=110;
         if spf.bar[num].sec>0 then
           strx:=spf.subsecmat.section[spf.bar[num].sec].name
         else  strx:='       未定义';
         if spf.bar[num].mat>0 then
            stry:=spf.subsecmat.mater[spf.bar[num].mat].name
         else stry:='       未定义';
          t1:=spf.bar[num].nf;
          t2:=spf.bar[num].nl;
          t3:=(spf.node[t1].x-spf.node[t2].x)*
                (spf.node[t1].x-spf.node[t2].x);
          t3:=t3+(spf.node[t1].y-spf.node[t2].y)*
                 (spf.node[t1].y-spf.node[t2].y);
          t3:=t3+(spf.node[t1].z-spf.node[t2].z)*
                  (spf.node[t1].z-spf.node[t2].z);
          t3:=sqrt(t3);
         if (spf.bar[num].sec>0) and (spf.bar[num].mat>0) then
          begin
           a:=t3*spf.subsecmat.mater[spf.bar[num].mat].rwt*9800;   //  T=>N
           b:=a*spf.subsecmat.section[spf.bar[num].sec].area/10000;  // cm2=>m2
           strz:=format('%8.1f',[b]);
          end
         else  strz:='   -----';

         label1.caption:='杆件号:  ['+
           inttostr(num)+']'+#13+#13+'前节点: [' +inttostr(spf.bar[num].nf)
             +']    后节点: ['+inttostr(spf.bar[num].nl)+']';
         label2.caption:='杆件长度:       '+format('%8.3f',[t3])
           +' 米'+#13+'杆件重量:       '+strz+' 牛'
           +#13+'杆件截面:         '+strx
           +#13+'杆件材料:             '+stry;
         if (curbv[SOLV]=1) or (curbv[OPT]=1) then
          begin
            label3.caption:=#13+'杆件内力:       '
              +format('%8.3f',[spf.bar[num].force])+'  kN';
            label3.caption:= label3.caption+#13+'杆件应力:       '
              +format('%8.1f',[spf.bar[num].sigma])+'  MPa';
          end
         else
          label3.caption:=''+#13+'杆件内力尚未计算!';
       end;
    end;

end;

procedure Tinqform.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:integer;
begin
  if curproc= NDQST then
   for i:=1 to spf.np do
    spf.node[i].sel:=0
  else if curproc= BARQST then
   for i:=1 to spf.ne do
    spf.bar[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tinqform.SpeedButton1Click(Sender: TObject);
var
  lds,i,j:integer;
  pp:pf;
begin
   if speedbutton1.caption='位移' then
     begin
      if (curbv[SOLV]=1) or (curbv[OPT]=1) then
       begin
       speedbutton1.caption:='荷载';
       with StringGrid1 do
        begin
         Cells[0,0]:='位移';
         cells[1,0]:=' ΔX <mm>';
         cells[2,0]:=' ΔY <mm>';
         cells[3,0]:=' ΔZ <mm>';
        end;
        lds:=0;
        for i:=1 to 14 do
         begin
          if spf.comld[i,0]>=0 then   //  comld[1~14,1~5] 记录组合系数
            lds:=lds+1;
         end;
        for i:=1 to lds do
         begin
          spf.PL_readresult(i);
         with StringGrid1 do
          begin
           cells[0,i]:='组合['+inttostr(i)+']';
           cells[1,i]:=format('%7.1f',[spf.node[num].dx*1000]);
           cells[2,i]:=format('%7.1f',[spf.node[num].dy*1000]);
           cells[3,i]:=format('%7.1f',[spf.node[num].dz*1000]);
          end;
         end;
       end
      else  messagedlg('结构尚未分析!',mtconfirmation,[mbok],0);

     end
   else if speedbutton1.caption='荷载' then
     begin
      speedbutton1.caption:='位移';
      for i:=1 to 20 do
        for j:= 0 to 3 do
          with StringGrid1 do
            cells[j,i]:='';
      with StringGrid1 do
       begin
        Cells[0,0]:='荷载';
        cells[1,0]:='  X <kN>';
        cells[2,0]:='  Y <kN>';
        cells[3,0]:='  Z <kN>';
         //  cells[0,1]:='D1'; cells[0,2]:='D2';
       pp:=spf.ndforce;
       i:=0;
       while pp<>nil do
        begin
         i:=i+1;
         if trunc(pp^.kind /10)=1 then
          cells[0,i]:='恒['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=2 then
          cells[0,i]:='活['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=3 then
          cells[0,i]:='风['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=4 then
          cells[0,i]:='吊['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=5 then
          cells[0,i]:='震['+inttostr(pp^.kind mod 10)+']';
          cells[1,i]:=format('%7.2f',[pp^.header^[num].x]);
          cells[2,i]:=format('%7.2f',[pp^.header^[num].y]);
          cells[3,i]:=format('%7.2f',[pp^.header^[num].z]);
          pp:=pp^.next;
        end;
       end;

     end;
end;

end.

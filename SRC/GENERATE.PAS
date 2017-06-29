unit generate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, Buttons, ExtCtrls, math;

type
  Rndd=record
    x,y,z:single;
  end;
  ndar=array [1..4000] of Rndd;
  pndar= ^ndar;

function newndar(i:integer):pndar;
procedure v4(xn,yn:integer;lx,ly,h:single);    // 正四角椎
procedure truss3(x1,x2,x3,x4:single;nn:integer);   //  三角管桁架

implementation
uses main;

function newndar(i:integer):pndar;
var
  g:pndar;
begin
  getmem(g,sizeof(Rndd)*i);
  result:=g;
end;

procedure truss3(x1,x2,x3,x4:single;nn:integer);
var
  i:integer;
  a1,b1,theta:single;
  nda:pndar;
  f1:textfile;
begin
   theta:=arccos((x1*x1+x2*x2-x3*x3)/(2*x1*x2));
   a1:=x2*cos(theta);   b1:=x2*sin(theta);
   nda:=newndar(3*nn);
   for i:=0 to nn-1 do
     begin
       nda^[i*3+1].x:=0;
       nda^[i*3+1].y:=i*x4;
       nda^[i*3+1].z:=0;
       nda^[i*3+2].x:=x1;
       nda^[i*3+2].y:=i*x4;
       nda^[i*3+2].z:=0;
       nda^[i*3+3].x:=a1;
       nda^[i*3+3].y:=i*x4;
       nda^[i*3+3].z:=b1;
     end;
   assignfile(f1, path+'wjtmp.dat');
    rewrite(f1);
   writeln(f1,'  np      ne');
   writeln(f1,format(' %4d   %5d', [3*nn,9*(nn-1)+3]));
   writeln(f1,' ');
   writeln(f1,'     x        y        z   ');
   for i:=1 to 3*nn do
     writeln(f1,format('%9.3f%9.3f%9.3f',[nda^[i].x,nda^[i].y,nda^[i].z]));
   writeln(f1,' ');
   writeln(f1,'  left     right');
   for i:=0 to nn-2 do
     begin
       writeln(f1,format('%5d    %5d',[i*3+1,i*3+2]));
       writeln(f1,format('%5d    %5d',[i*3+2,i*3+3]));
       writeln(f1,format('%5d    %5d',[i*3+3,i*3+1]));
       writeln(f1,format('%5d    %5d',[i*3+1,(i+1)*3+1]));
       writeln(f1,format('%5d    %5d',[i*3+2,(i+1)*3+2]));
       writeln(f1,format('%5d    %5d',[i*3+3,(i+1)*3+3]));
       writeln(f1,format('%5d    %5d',[i*3+1,(i+1)*3+3]));
       writeln(f1,format('%5d    %5d',[i*3+2,(i+1)*3+1]));
       writeln(f1,format('%5d    %5d',[i*3+3,(i+1)*3+2]));
     end;
   writeln(f1,format('%5d    %5d',[(nn-1)*3+1,(nn-1)*3+2]));
   writeln(f1,format('%5d    %5d',[(nn-1)*3+2,(nn-1)*3+3]));
   writeln(f1,format('%5d    %5d',[(nn-1)*3+3,(nn-1)*3+1]));

   closefile(f1);
   freemem(nda);
end;

procedure v4(xn,yn:integer;lx,ly,h:single);
var
  i,j,m:integer;
  s,d:integer;
  nda:pndar;
  dnd:array[1..1800] of integer;
  f1:textfile;
begin
  if xn<=yn then
   begin
     s:=xn;   d:=yn;
   end
  else
   begin
     s:=yn;   d:=xn;
   end;
  m:=2*s+1;      //   module of short side
  nda:=newndar(m*(d+1)-s);
  for i:= 0 to d do          //   shang xian node
    for j:= 1 to s+1 do
      begin
       if xn<=yn then
        begin
         nda^[i*m+j].x:=lx*(j-1);
         nda^[i*m+j].y:=ly*i;
        end
       else
        begin
         nda^[i*m+j].x:=lx*i;
         nda^[i*m+j].y:=ly*(j-1);
        end;
        nda^[i*m+j].z:=0;
      end;

   for i:= 0 to d-1 do      //   xia xian node
     for j:=1 to s do
      begin
       if xn<=yn then
        begin
         nda^[i*m+s+1+j].x:=lx*(j-1)+lx/2;
         nda^[i*m+s+1+j].y:=ly*i+ly/2;
        end
       else
        begin
         nda^[i*m+s+1+j].x:=lx*i+lx/2;
         nda^[i*m+s+1+j].y:=ly*(j-1)+ly/2;
        end;
        nda^[i*m+s+1+j].z:=-h;
        dnd[i*s+j]:=i*m+s+1+j;
       end;

  assignfile(f1, path+'wjtmp.dat');
  rewrite(f1);
  writeln(f1,'  np      ne');
  writeln(f1,format(' %4d   %5d', [m*(d+1)-s,8*xn*yn]));
  writeln(f1,' ');
  writeln(f1,'     x        y        z   ');
  for i:=1 to (m*(d+1)-s) do
    writeln(f1,format('%9.3f%9.3f%9.3f',[nda^[i].x,nda^[i].y,nda^[i].z]));
  writeln(f1,' ');
  writeln(f1,'  left     right');
  for i:= 0 to d do
    for j:= 1 to s do
      writeln(f1,format('%5d    %5d',[i*m+j,i*m+j+1]));      //  up by s
  for i:= 0 to d-1 do
    for j:= 1 to s+1 do
      writeln(f1,format('%5d    %5d',[i*m+j,(i+1)*m+j]));  //  up by d
  for i:= 0 to d-1 do
    for j:= s+2 to m-1 do
      writeln(f1,format('%5d    %5d',[i*m+j,i*m+j+1]));     //   down by s
  for i:= 0 to d-2 do
    for j:= s+2 to m do
      writeln(f1,format('%5d    %5d',[i*m+j,(i+1)*m+j]));    //  down by d

  for i:= 1 to xn*yn do
   begin
    writeln(f1,format('%5d    %5d',[dnd[i],dnd[i]+s+1]));
    writeln(f1,format('%5d    %5d',[dnd[i],dnd[i]-s-1]));
    writeln(f1,format('%5d    %5d',[dnd[i],dnd[i]+s]));
    writeln(f1,format('%5d    %5d',[dnd[i],dnd[i]-s]));
   end;

  closefile(f1);
  freemem(nda);
end;

end.

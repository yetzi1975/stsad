unit js;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, shellapi, ExtCtrls,main,ent ;

type
  TjsForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Gauge1: TGauge;
    Timer1: TTimer;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    sStartInfo: STARTUPINFO;
    seProcess, seThread: SECURITY_ATTRIBUTES;
    PProcInfo: PROCESS_INFORMATION;
  end;

var
  jsForm: TjsForm;

implementation

{$R *.DFM}

procedure TjsForm.Button1Click(Sender: TObject);
var
  bSuccess: boolean;
begin
  setcurrentdir(workpath);
  deletefile('res.dat');
  while fileexists('res.dat') do sleep(100);

  ZeroMemory(@sStartInfo, sizeof(sStartInfo));
  SStartInfo.cb := sizeof(sStartInfo);
  // SStartInfo.wShowWindow:=SW_HIDE;
  SStartInfo.dwFlags:=STARTF_USESHOWWINDOW;

  seProcess.nLength := sizeof(seProcess);
  seProcess.lpSecurityDescriptor := PChar(nil);
  seProcess.bInheritHandle := true;
  seThread.nLength := sizeof(seThread);
  seThread.lpSecurityDescriptor := PChar(nil);
  seThread.bInheritHandle := true;
   //ExtractFilePath(workpath+'Spack')
  bSuccess := CreateProcess(PChar(nil), Pchar(path+'Spack'),
  @seProcess, @seThread, false, CREATE_DEFAULT_ERROR_MODE, Pchar(nil),
  PChar(workpath), sStartInfo, PProcInfo);
  if (not bSuccess) then
    begin
      showmessage('缺少核心计算程序！'+#13+'Path['+workpath+']');
      exit;
    end;
  // sleep(100);
  timer1.enabled:=true;
  enabled:=false;
  button1.hide;
  label2.show;
  gauge1.Show;

end;

procedure TjsForm.Timer1Timer(Sender: TObject);
var
   dwExitCode: DWORD;
   fprocessExit: boolean;
begin
  if gauge1.progress<95 then gauge1.progress:=gauge1.progress+1;

  dwExitCode := 0;
  fprocessExit := GetExitCodeProcess
    (PProcInfo.hProcess, dwExitCode);
  if (fprocessExit and (dwExitCode <> STILL_ACTIVE)) then
   begin
     CloseHandle(PProcInfo.hThread);
     CloseHandle(PProcInfo.hProcess);
     gauge1.progress:=98;
     timer1.enabled:=false;
     curbv[SOLV]:=1;
     while not fileexists('res.dat') do sleep(100);
     copyfile('res.dat',pchar(spf.ffn+'_res.dat'),true);
     gauge1.progress:=100;
     enabled:=true;
     label2.caption:='结构分析已完成!';
   end
  else if Timer1.Interval<=400 then
     Timer1.interval:=Timer1.Interval+1;

end;

procedure TjsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   mainform.n25.enabled:=true;
end;

end.

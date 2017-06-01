unit xsedae;
{$mode objfpc}{$H+}
{ $mode delphi}
interface
uses cthreads,daemonapp,classes,
        xseglob,
//FileUtil, LResources,
//IniFiles, process, crt,
SysUtils;


Type
TmyThread = Class(TThread)
Procedure Execute; override;
end;
Type
txseusdaemon = Class(TCustomDaemon)
Private
serviceThread : TmyThread;
Procedure ThreadStopped (Sender : TObject);
public
Function Start : Boolean; override;
Function Stop : Boolean; override;
Function Pause : Boolean; override;
Function Continue : Boolean; override;
Function Execute : Boolean; override;
Function ShutDown : Boolean; override;
Function Install : Boolean; override;
Function UnInstall: boolean; override;
end;
Type
TxseusDaemonMapper = Class(TCustomDaemonMapper)
Constructor Create(AOwner : TComponent); override;
end;
var logdfile:tfilestream;
procedure go_daemon;


implementation
uses xserver;
procedure go_daemon;
begin
logwrite('dorub');
application.run;
logwrite('didrub');
end;

{ $R *.res}
//var log:textfile;
//var logord:integer;
procedure newlog(fn:string);
begin
try
 logwrite(fn+crlf);
 exit;
logdfile.writeansistring( '//'+fn);
except writeln('logging failed');end;
try
//closefile(logfile);
except end;
end;


{procedure TmyThread.Execute;
Var
C : Integer;
begin
C:=0;
Repeat
Sleep(1000);
inc(c);
logwrite('go'+inttostr(c));
Until Terminated;
end;

}
procedure TmyThread.Execute;
Var
C : Integer;res:boolean;
begin
newlog('exe:TmyThread.Execute');
// what the heck?
//xseusform.formcreate(self);
newlog('exe:formcreated ');
//Application.Run;
//while not Terminated do
      xseusserver.run;
 logwrite('************runrunrunning when here');
// processRequests(True);// wait for termination

end;

constructor TxseusDaemonMapper.Create(AOwner: TComponent);
Var
D : TDaemonDef;
begin
writeln('d-mappercreate');
logwrite('d-mappercreate');
writeln('d-mappercreate2');
inherited Create(AOwner);
D:=DaemonDefs.Add as TDaemonDef;
//D.DisplayName:='txseusdaemon';
D.DisplayName:='x6';
D.Name:='x6';
D.DaemonClassName:='txseusdaemon';
D.WinBindings.ServiceType:=stWin32;
newlog('didmapper');
//application.Logger.Info('Listening in port ';
end;

{begin
C:=0;
Repeat
Sleep(1000);
inc(c);
//Application.Logger.Info(Format(?Tick : %d?,[C]));
Until Terminated;
end;
}

Procedure txseusdaemon.ThreadStopped (Sender : TObject);
begin end;

function txseusdaemon.Start: Boolean;
begin
logwrite('xseudeamon:START');

//serviceThread.
//newlog('start');
Result:=inherited Start;
logwrite(('start: inheri'));

serviceThread:=TmyThread.Create(True);
serviceThread.OnTerminate:=@ThreadStopped;
serviceThread.FreeOnTerminate:=False;
serviceThread.Resume;

newlog('start: resumed');
end;

function txseusdaemon.execute: Boolean;
begin
try
//logdfile.writeansistring('xseudeamon exec ');
newlog('execute');
Result:=inherited execute;
newlog('executed');
exit;
EXCEPT logdfile.writeansistring('xseudeamon execfail ');
END;
end;

function txseusdaemon.shutdown: Boolean;
begin

Result:=inherited Stop;
newlog('Daemon shut: ');
//FThread.shutdown;
end;
function txseusdaemon.Stop: Boolean;
begin

Result:=inherited Stop;
newlog('Daemon Stop: ');
serviceThread.Terminate;
end;
function txseusdaemon.Pause: Boolean;
begin
Result:=inherited Pause;
newlog('Daemon pause: ');
serviceThread.Suspend;
end;
function txseusdaemon.Continue: Boolean;
begin
Result:=inherited Continue;
newlog('Daemon continue: ');
serviceThread.Resume;
end;
function txseusdaemon.install: Boolean;
begin
newlog('installdaemon');
Result:=inherited install;
end;
function txseusdaemon.uninstall: Boolean;
begin
newlog('uninstalldaemon');
Result:=inherited uninstall;
end;
initialization
{ $I daemonunit1.lrs}
g_inidir:=extractfiledir(paramstr(0))+'/';
//writeln('daemon iniiiiiiiiiiiiiiiiiiiiit'+inidir+'xseusd.log');
{ logdfile:=tfilestream.create(inidir+'/xseusd.log',fmcreate or fmopenwrite);

//newlog('initialize. log at '+inidir+'xseusd.log');
RegisterDaemonClass(TxseusDaemon);
RegisterDaemonMapper(TxseusDaemonMapper);
logwrite('xseusDAEMON registered');
Application.Title:='xseus';
logdfile.writeansistring('DAEMONAPP_starting_now');
Application.Run;
logdfile.writeansistring('xseusDAEMON ran ');

// RegisterDaemonClass(Txseusdaemon);
// newlog('initialized');
}
end.
end.

{

begin
newlog('deastart');
//regdaemon;
newlog('deaend');
end. }

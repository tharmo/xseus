program x6;
{$MODE Delphi}

{$M+}
{$APPTYPE CONSOLE}
uses
{$IFDEF LINUX}
  cthreads,//  daemonapp,// xsedae,
//cmem,
custapp,
//syncobjs,
{$ENDIF}
{$IFNDEF FPC} // Messages,
{$ELSE}
//  LCLIntf,  LMessages,  LclType,  LResources,
{$ENDIF}

  sysutils,
  {winsvc,}
  //SvcMgr,
//  Forms, Interfaces,//dialogs,
  classes, //uusserv
 //xsegui,
xserver,  xseglob,xsecmd //, //xseoid, xsetrie, //XSEJUNK,
//xsesta, //xsmarkd,
//estmark,
;//xsemarkd, xsedae;//, esimerkkisynhttpsrv;
{$DEFINE TIBURON}

{   $R *.RES}
//type listener=class(tthread)

{$ifdef TMyApplication}
type


  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;
  constructor TMyApplication.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException:=True;
  end;

  destructor TMyApplication.Destroy;
  begin
    inherited Destroy;
  end;

  var
  Application: TMyApplication;
procedure tmyapplication.dorun;
begin
        sleep(200);
 //        writeln('******************run');
         //xseusserver.run;
//         writeln('*******didrun');
         //terminate;
//xseusserver:=txseusserver.create;
//logwrite(('*************APP RUNNING********'));
//listener:=tlistener.create(true);
//xseusserver.run;
end;
  {$endif}

var servicemode:boolean;
//listener:tlistener;


{$ifdef doservicemodeafwterall}
{begin
 //writeln(argv[1]);
// argv[1]:='-r';
 //writeln(argv[1]);
logwrite(('*************STARTING********'));
//if (FindCmdLineSwitch('S', ['-', '/'], True)) then
if (FindCmdLineSwitch('c', ['-', '/'], True)) then cmdline;
if (FindCmdLineSwitch('S', ['-', '/'], True)) then servicemode:=true;
if (FindCmdLineSwitch('s', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('INSTALL', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('i', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('r', ['-', '/'], True)) then   servicemode:=true;
  if (FindCmdLineSwitch('u', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('UNINSTALL', ['-', '/'], True)) then   servicemode:=true;
end;}

if servicemode then
 begin
    logwrite('init servicemode!');
    //--  deamons
    {$IFDEF DELPHI}
    if not svcmgr.Application.DelayInitialize or svcmgr.Application.Installing then
      svcmgr.Application.Initialize;

    lokiwrite('servicemode inited');
    svcmgr.Application.CreateForm(Txserv, xserv);
    //Application.CreateForm(Tproxyform, proxyform);
     //closefile(log);
    lokiwrite('serviform created');
      //closefile(log);
    svcmgr.Application.Run;
    {$ELSE}
    {$IFDEF LINUX}
{     lokiwrite('LINUXDAEMON');
    //  application.initialize;
    //writeln('diniiiiiiiiiiiiiiiiiiiiit'+inidir+'/xseusd.log');
    //logdfile:=tfilestream.create(inidir+'xseusd.log',fmcreate or fmopenwrite);

     //newlog('initialize. log at '+inidir+'xseusd.log');
    RegisterDaemonClass(TxseusDaemon);
    RegisterDaemonMapper(TxseusDaemonMapper);
    lokiwrite('xseusDAEMON registered');
    lokiwrite('DAEMONAPP_starting_now');
    xseusserver:=txseusserver.create;
    go_daemon;
    lokiwrite('didgodae ran ');
    //Application.Run;
    lokiwrite('xseusDAEMON ran ');
}     {$ENDIF}
    {$ENDIF}
    //sleep(2000);
    //closefile(logfile);
    //lokifile.free;
    //exit;
    //logwrite('PASS:'+xser.password);
    //logwrite('USER:'+xser.servicestartname);
 end
 ELSE
 {$endif}

//var i:integer;//demoni:TCustomDaemon;
//proxyform: Tproxyform;
//xproxy:txseusproxy;
{$IFDEF WINDOWS} //IN LINUX DEFINED IN XSEDAE   ss
logdfile:tfilestream;
{$ENDIF}
{  $R *.res}
//var lokifile:tfilestream;inidir:string;servicemode:boolean;
procedure lokiwrite(st:string);
begin
        lokifile.WriteBuffer(st[1], length(st));
end;
begin
initcriticals;

try
g_inidir:=extractfiledir(paramstr(0));
//WRITELN('NOW LOGGING TO:' +g_inidir+'/xseus.log');
lokifile:= tfilestream.create(g_inidir+'/xseus.log',fmcreate or fmopenwrite);
//logWRITE('NOW LOGGING TO:' +g_inidir+'/xseus.log');
servicemode:=false;
dateseparator := '-';
timeseparator := ':';
shortdateformat := 'yyyy-MM-dd';
sysutils.DefaultFormatSettings.ShortDateFormat:= 'YYYY-MM-DD';
sysutils.DefaultFormatSettings.timeseparator:= ':';
sysutils.DefaultFormatSettings.dateseparator:= '-';
except writeln('failed to load xseus');exit;end;
if (FindCmdLineSwitch('c', ['-', '/'], True)) then
begin
   try
   cmdline;
   exit;
   except writeln('invalid command-line call');exit;end;
end;
  servicemode:=true;

try
//writeln('daemon');
//longtimeformat := 'hh.nn.ss';
 //servicemode:=false;

 //servicemode:=true;
  begin
  //Application:=TMyApplication.Create(nil);
  xseusserver:=txseusserver.create;
logwrite(('*************XSERV _is_created********'));
xseusserver.run;
 while true do begin
  sleep(1000);
  //logwrite('...running');
 end;
//application.run;
//listener:=tlistener.create(true);
//xseusserver.run;

 // Application.Run;
  //Application.Free;

{    lokiwrite('init app');
    forms.Application.CreateForm(Txform1, xseusformi);
    lokiwrite(('*************Formi_is_created********'));
    xseusformi.show;
   try
     t_currentxseus:=nil;
     xseusserver:=txseusserver.create;
     lokiwrite(('*************XSERV _is_created********'));
     except
       lokiwrite(('*************XSERV _FAILED********'));
     end;
     lokiwrite(('*************RUNAPPLIC********'));
     //listener:=tlistener.create(true);
     xseusserver.run;
     forms.Application.Run;
    //lokifile.free;
    }
  end
  ;

 finally
   try
   logwrite('STOPPING');
   xseusserver.free;
   logwrite('freed server');
  except ;end;
   //listener.dofree;
   //application.Terminate;
   //lokiwrite(('app_stop'));
  // lokifile.free;
    //application.Terminate;
 //   Application.Terminate;
//          while not Application.Terminated do
//            Application.ProcessMessages;
       logwrite('terminated');

   //halt;
 end;
end.



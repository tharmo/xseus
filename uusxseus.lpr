program uusxseus;
{  $APPTYPE CONSOLE  }
{$MODE Delphi}

{$M+}
uses
{$IFDEF LINUX}
cthreads,  daemonapp, // xsedae,
{$ENDIF}
  sysutils,
  {winsvc,}
  //SvcMgr,
  Forms, Interfaces,
  classes,
xserver in 'xserver.pas' {xseusform: Txseusform};

{$DEFINE TIBURON}

{   $R *.RES}

//var servicemode:boolean;


//var i:integer;//demoni:TCustomDaemon;
//proxyform: Tproxyform;
//xproxy:txseusproxy;
{$IFDEF WINDOWS} //IN LINUX DEFINED IN XSEDAE
logdfile:tfilestream;
{$ENDIF}
{$R *.res}

procedure lokiwrite(st:string);
begin
        lokifile.WriteBuffer(st[1], length(st));
end;
{procedure startxseus;
begin
lokiwrite('create server');
xseusserver:=txseusserver.create;
lokiwrite('created server');
//inherited paint;
//show;
logwrite('server is created');
runserver;
end;}
begin

   //writeln('gggggggggggggggggoooooooooooooooooooo');
   //exit;
try
//logfile:= tfilestream.create(inidir+'/home/t/xseus/xseus1.log',fmopenwrite);
 // logwrite('gogo:'+inidir+'xseus1.log');
inidir:=extractfiledir(paramstr(0))+G_DS;
lokifile:= tfilestream.create(inidir+'xseus1.log',fmcreate or fmopenwrite);
lokifile.WriteAnsiString('go');
lokifile.Free;
halt;
lokifile2:=tfilestream.create(inidir+'xseus2.log',fmcreate or fmopenwrite);
lokiwrite( 'xSTARTing'+inidir+'xseus1.log');
//WRITELN(inidir+'xseus1.log');
//regdaemon;
//writeln('go');
//halt;
servicemode:=false;
//if (FindCmdLineSwitch('S', ['-', '/'], True)) then
if (FindCmdLineSwitch('c', ['-', '/'], True)) then cmdline;
if (FindCmdLineSwitch('S', ['-', '/'], True)) then servicemode:=true;
if (FindCmdLineSwitch('s', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('INSTALL', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('i', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('r', ['-', '/'], True)) then   servicemode:=true;
  if (FindCmdLineSwitch('u', ['-', '/'], True)) then servicemode:=true;
  if (FindCmdLineSwitch('UNINSTALL', ['-', '/'], True)) then   servicemode:=true;
 servicemode:=false;
 if servicemode then
  begin
     lokiwrite('init servicemode');
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
     {$IFDEF LINUXxxx}
     lokiwrite('LINUXDAEMON');
     //  application.initialize;
     //writeln('diniiiiiiiiiiiiiiiiiiiiit'+inidir+'/xseusd.log');
     logdfile:=tfilestream.create(inidir+'xseusd.log',fmcreate or fmopenwrite);

      //newlog('initialize. log at '+inidir+'xseusd.log');
     RegisterDaemonClass(TxseusDaemon);
     RegisterDaemonMapper(TxseusDaemonMapper);
     logdfile.writeansistring('xseusDAEMON registered');
     Application.Title:='xseus';
     logdfile.writeansistring('DAEMONAPP_starting_now');
     lokiwrite('DAEMONAPP_starting_now');
     go_daemon;//Application.Run;
     logdfile.writeansistring('xseusDAEMON ran ');
     {$ENDIF}
     {$ENDIF}
     lokiwrite(('final dealog created'));
     //sleep(2000);
     //closefile(logfile);
     //lokifile.free;
     //exit;
     //logwrite('PASS:'+xser.password);
     //logwrite('USER:'+xser.servicestartname);
  end
  ELSE
  begin
    writeln('init app');
    try
    //forms.
     Application.Initialize;
    except
      lokiwrite('XXXXXXXXXXXXXXXXXXXXXnogo');
    end;
    writeln('APP inited');
    Application.CreateForm(Txseusform, xseusform);
    lokiwrite(('*************Formi_is_created********'));
    lokiwrite('running!!!!!!!!!!!!');
    //startxseus;
   forms.Application.Run;
   //huihai;
    //lokifile.free;
  end
  ;

 finally
   //lokiwrite(('app_stop'));
   lokifile.free;
    //logwrite('finaali');
    halt;
 end;
end.



unit xserver;

{$mode delphi}

interface

     {$R *.lfm}
uses
  {$IFDEF LINUX}
  cthreads,
  {$ENDIF}
  Classes, blcksock, sockets, Synautil, SysUtils,
  //procedure createsynserver;
  //implementation
  //uses xserver;

  //uses      //xsynser,
  {Windows,}{$IFNDEF FPC}  Messages, {$ELSE} LCLIntf, LMessages,
  LclType, interfaces, LResources, {$ENDIF}
  Dialogs,
  //SysUtils, Classes,
  Graphics, Controls, Forms,
  //IdGlobal, IdSocketHandle,
  //IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  //IdHTTPServer, IdContext, IdCookie, IdException, IdHeaderList,
  //IdIOHandlerStack, IdIOHandler,
  syncobjs,
  xsecgi,
  xsexml,
  xsefun,
  xseexp,
  xsecomp,
  xsedif, ExtCtrls,
  //xseftp,
  xsetimers,
  //xsesmtp,// xsesta,
  xsexse, StdCtrls, ExtDlgs;
//IdSSLOpenSSL, IdSchedulerOfThread;

const
  {$IFDEF WINDOWS}
  g_ds = '\';
  {$ELSE}
  g_ds = '/';
  {$ENDIF}

type

  Tservpro = class(TThread)
  private
    fStatusText: string;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    id:integer;
    ResponseStream: TMemoryStream;
    //respa: tresponse; //tidhttpresponseinfo;
    xso: txseus;
    sock: TTCPBlockSocket;
    HeaderHasBeenWritten: boolean;
    contenttype: string;
    resutxt: string;
    xs:pointer;
    //myoutput:ttextrec;
    //function HtmlOpen(var F: TTextRec): integer;
    //function HtmlCLOSE(var F: TTextRec): integer;
    //procedure AssignHtml(var F: TextFile);
    procedure AttendConnection(ASocket: TTCPBlockSocket);
    procedure writeheader;
    procedure test;
    destructor Free;
    constructor Create(CreateSuspended: boolean);
  end;

  tthreadpool = class(TObject)
    Count: integer;
    freeths, inuseths: TList;
    function obtain: tservpro;
    procedure doRelease(spr: tservpro);
    constructor Create;
    destructor Free;
  end;

  { Txseusform }

  Txseusform = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    //CalculatorDialog1: TCalculatorDialog;
    procedure Button1Click(Sender: TObject);
    //procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure showlogClick(Sender: TObject);
    procedure memolog(s: string);
  private
    //procedure GetPassword(var Password: string);
    //procedure Status(ASender: TObject; const AStatus: TIdStatus;
    //  const AStatusText: string);
  public
    gname:string;
    //function verpeer(Certificate: TIdX509; AOk: boolean): boolean;
  end;

  txseusconfig = class(TObject)
  public
    config, apppaths, xcommands, xpermissions, ftp, smtp: ttag;
    logf: tfilestream;
    cache: TStringList;
    locs: tlocs;
    gdebug: boolean;
    smtpindir: string;
    timers: ttag;
    procedure get(inif: string);
    function subs(st: string): string;
    function subt(st: string): ttag;
    destructor Free;
  end;

  txseusserver = class(TObject)
    //server: tidhttpserver;
    gname:string;
    sessionlist: TList;
    sessiontimeout: integer;
    listenerSocket: TTCPBlockSocket;
    servs: tthreadpool;
    //procedure createsynserver;
    //procedure onCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
    //procedure OnInvalidSession(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
    // AResponseInfo: TIdHTTPResponseInfo; var VContinueProcessing: boolean;
    // const AInvalidSessionID: string);
    constructor Create;
    //procedure sessionstart(Sender: TIdHTTPSession);
  private
    //procedure sessionend(Sender: TIdHTTPSession);
    //procedure serverConnect(AContext: TIdContext);
    //procedure serverdisconnect(AContext: TIdContext);
  end;




{  tsslserver = class(TObject)
  private
    server: tidhttpserver;
    connections: integer;
    sessionlist: TList;
    procedure onConnect(AContext: TIdContext);
    procedure onCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    constructor Create;
    procedure sessionstart(Sender: TIdHTTPSession);

    procedure sessionend(Sender: TIdHTTPSession);
  end;
}
const
  crlf = ^M^J;
  isost = 32000;
  whitespace = crlf + ' ';
  inlins =
    ',tt,span,strong,code,br,BR,img,em,b,i,a,strike,font,q,del,ins,value,FONT,STRONG,CODE,A,';
  g_myurl = 'http://valtweb.pc.helsinki.fi/cgi-shl/cgitalk.exe';
  g_nameChars = ['a'..'z', 'A'..'Z', '_', '0'..'9'];


var
  globaltext:string;
  xseuscfg: txseusconfig;
  xseusserver: TxseusServer;
  //ftpserver: txseusftp;
  //sslserver: tsslserver;
  servicemode: boolean;
  xseusform: Txseusform;
  connections: integer;
  lokifile, lokifile2: tfilestream;
  inidir: string;
  loglocked: boolean;
  loglines: TStringList;
  //logfile:textfile;
  //lokifile,lokifile2:tfilestream;
  logord: integer;
  logicriti: boolean;//TCriticalSection;
  {$IFNDEF LAZARUS}//logstream: tfilestream;
    {$ENDIF}
threadvar
  g_debug: boolean;
  //t_context: tidcontext;
  thrxs: txseus;
  mythreadelems, mythreadrefcount: TList;
  elements_freed, elements_created: integer;

procedure logwrite(st: ansistring);
//procedure restartserver;

threadvar
  thisprocess: Tservpro;

//actx: tidcontext;

procedure SLEEPPAA;
procedure runserver;

implementation

function HtmlOutput(var F: TTextRec): integer;
var
  s: string;
  i, len: integer;
  b: byte;
begin
  //exit;
  //F.BufPos := 0;
  //logwrite('writing');
  //thisprocess.Sock.SendString('1234</html>');
  //F.BufPos := 0;
  //logwrite('wrote');
  //exit;
  begin
    try
      //SetString(s, PAnsiChar(f.bufptr), f.bufpos);
      //writeln('hithere');

      //F.BufPos := 0;
      //thisprocess.Sock.SendString(s);
      //exit;
    except
      logwrite('NOMOGOGO');
    end;

    //if f=nil then logwrite('NOOUTPUTPUTUTUTUTU');
    begin
      if not thisprocess.HeaderHasBeenWritten then
        //NOT A GOOD IDEA TO KEEP TRACK OF HEADER-WRITING IN XSEUS-OGJECT
      begin
        //BUT IT ALSO NEEDS TO KNOW.. BUT RESPA.HEADERHASBEEWRITTEN SHOULD SUFFICE
        //THE THREAD-GLOBAL RESPA-VARIABLE IS NOT ELEGANT
        try
          //respa.WriteHeader;
          thisprocess.HeaderHasBeenWritten := True;
          //respa.HeaderHasBeenWritten := True;
        except
          logwrite('failed httpinit');
          //raise;  //NO RAISING ERRORS YET... GOTTA BUILD SOME CENTRAL ERROR-HANDLING SCHEME
        end;
      end;
      try
        SetString(s, PAnsiChar(f.bufptr), f.bufpos);
        //content-type: chunked means writing these chunks and their legths in HEX
        len := length(s);
        //s := crlf + inttohex(len, 4) + crlf + S + crlf;
        s := inttohex(len, 4) + crlf + S + crlf;
        thisprocess.sock.SendString(s);
        logwrite('didwrite:'+s);
        //FileClose(F.Handle); { *Converted from CloseHandle*  }
        //        T_CONTEXT.Connection.IOHandler.Write(TidBytes(S), Length(s));
        //INDY-FOLKS DON'T LIKE THIS BUT THIS IS THE ONLY WAY I CAN DO IT
        //SHOULD BE DOING BY CONTENT.TEXT .. WRITECONTENT
      except
        logwrite('failed htmloutput');
        logwrite('s:' + s);
        //raise; //GOTTA RAISE THIS ONE, OTHERWISE WE CAN GET MILLIONS OF THESE
        // WHEN BROWSERS QUIT CONNECTIONS
      end;
      F.BufPos := 0;
      Result := 0;
    end;
  end;
end;


function HtmlClose(var F: TTextRec): integer;
begin
  FileClose(F.Handle); { *Converted from CloseHandle*  }
  Result := 0;
  LOGWRITE('OUTPUTCOLSE');
end;

function HtmlOpen(var F: TTextRec): integer;
begin
  with F do
  begin
    begin
      Mode := fmOutput;
      InOutFunc := @HtmlOutput;
      FlushFunc := @HtmlOutput;
      CloseFunc := @HtmlClose;
    end;
    Result := 0;
  end;
end;

procedure AssignHtml(var F: TextFile);
//COPIED FROM SOMEWHERE, TO BE ABLE TO DO OUTPUT BY WRITELNS
begin
  try
    with TTextRec(F) do
    begin
      FillChar(F, SizeOf(F), 0);
      Mode := fmClosed;
      BufSize := SizeOf(Buffer);
      BufPtr := @Buffer;
      OpenFunc := @HtmlOpen;
      htmlopen(ttextrec(f));
    end;
  except
    writeln('no writeln outoput');
  end;
end;


destructor tservpro.Free;
begin
  sock.Free;
  inherited Free;
end;

constructor tservpro.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := false;
  sock := TTCPBlockSocket.Create;
  HeaderHasBeenWritten := False;
  //inherited Create(CreateSuspended);
  inherited Create(true);
end;

procedure tservpro.ShowStatus;
// this method is executed by the mainthread and can therefore access all GUI elements.
begin
  //Form1.Caption := fStatusText;
end;

procedure tservpro.Execute;
var
  newStatus: string;
begin

  //fStatusText := 'tservthread Starting...';
  fStatusText := 'tservthread Running...';
  while (not Terminated) and (1 = 1) do
  begin
    //synchronize(@test);
    logwrite('starting thread'+inttostr(id));//+xseusserver.name);
    attendconnection(sock);
    try
    logwrite('releasing thread');//+inttostr(id)+'/'+inttostr(txseusserver(xs).servs.freeths.count));
    //self.Synchronize(self,test);
    xseusserver.servs.freeths.add(self);
    finally
      logwrite('globaltext '+globaltext);
      logwrite('gname '+xseusform.gname);
      logwrite('server '+xseusserver.gname);
      //logwrite('didrelease '+inttostr(id)+'/'+inttostr(txseusserver(xs).servs.freeths.count));
      suspend;
    end;
    //terminated:=true;

      {if NewStatus <> fStatusText then
        begin
          fStatusText := newStatus;
          Synchronize(@Showstatus);
        end;
      }
  end;

end;

procedure tthreadpool.doRelease(spr: tservpro);
var
  pos: integer;//p:tservpro;
begin
  //pos:=inuseths.indexof(spr);
  logwrite('releasing thread '+inttostr(spr.id)+' now at '+inttostr(inuseths.indexof(spr))+'/'+inttostr(freeths.count));
  inuseths.Remove(spr);
  freeths.add(spr);
  logwrite('released thread '+inttostr(spr.id)+' now at '+inttostr(freeths.indexof(spr))+'/'+inttostr(freeths.count));

end;

function tthreadpool.obtain: tservpro;
begin
  Result := freeths[0];
  inuseths.add(Result);
  freeths.Delete(0);
end;

constructor tthreadpool.Create;
var
  i: integer;
  servpro: tservpro;
begin
  Count := 3;
  freeths := TList.Create;
  inuseths := TList.Create;
  for i := 0 to Count - 1 do
  begin
    servpro := tservpro.Create(True);
    freeths.Add(servpro);
    servpro.id:=i;
    servpro.xs:=xseusserver;
    servpro.FreeOnTerminate:=false;

  end;
end;

destructor tthreadpool.Free;
begin
  while freeths.Count > 0 do
  begin
    tthread(freeths[0]).Free;
  end;
  freeths.Free;
  while inuseths.Count > 0 do
  begin
    tthread(inuseths[0]).Free;
  end;
  inuseths.Free;

end;

procedure SLEEPPAA;
begin
  //APPLICATION.ProcessMessages;
  //SLEEP(100);
end;

procedure logwrite(st: ansistring);
var
  t: integer;
begin
  try
{    while logicriti = True do
    begin
      sleep(10);
      t := t + 1;
      if t > 100 then
        exit;
    end;
    logicriti := True;
    t := length(st);
    lokifile.writeansistring(st + crlf+crlf);// + '....' + IntToStr(t) + '...' +      timetostr(now) + crlf);
    logicriti := False;
  except
    writeln('NOLOG:' + st);
    lokifile:= tfilestream.create('/home/t/xseus/xseus1.log',fmopenwrite);
    lokifile.writeansistring(st+'!!!!!!!!!!!!!!!');
    //lokifile := tfilestream.Create(inidir + 'xseus2.log', fmcreate or fmopenwrite);

  end;
  exit;
  //logicriti.Enter;
  //LCLIntf.entercriticalsection(logicriti);
}  t := 0;
    if st = '' then
      exit;
    st := st + crlf;
{    while logicriti = True do
    begin
      sleep(10);
      t := t + 1;
      if t > 1000 then
        exit;
    end;
    //try
    //logicriti.acquire;
    logicriti := True;
    //try
 }   try
      //if servicemode then
      lokifile.WriteBuffer(st[1], length(st));
      //lokifile.WriteAnsiString('!/:'+^M^J+'!='+st + '=!'+^M^J+'\!');
      //lokifile.writestring(st + crlf + '....' + IntToStr(t) + '...' + crlf);
    except
      //writeln('FAILOG:'+st + crlf + '....' + IntToStr(t) + '...' + crlf);
      //try closefile(logfile); except end;
    end;

    {try
      //assignfile(logfile,'/home/t/xseus/dae_'+inttostr(logord)+'_'+inttostr(t)+'.log');
      logord := logord + 1;
      //rewrite(logfile);
      lokifile.writeansistring('++' + st);
    except
      //try closefile(logfile);except end;
      //assign(logfile, '/home/t/xseus/xerror.log');
      //rewrite(logfile);
      lokifile.writeansistring(st);
    end;
    }
    //exit;
    //exit;
    //if loglines.count>500 then loglines.clear;
    //loglines.add(st);
    //xseusform.memo1.lines.add(st);
  finally
    // leavecriticalsection(logicriti);
    //    logicriti.Leave;
    logicriti := False;
  end;
end;



function txseusconfig.subs(st: string): string;
begin
  Result := config.subs(st);
end;

function txseusconfig.subt(st: string): ttag;
begin
  Result := config.subt(st);
end;


procedure txseusconfig.get(inif: string);
var
  x: //, d:
  string;//atag:=ttag;
begin
  try

    locs := tlocs.Create;
    //if not FileExistsUTF8(inif) { *Converted from FileExists*  } then
    if not FileExists(inif) { *Converted from FileExists*  } then
    begin
      //>>inif:=extractfiledir(paramstr(0))+g_ds+'xseus.ini';
      //d := extractfiledir(ParamStr(0));
      //d := extractfiledir(ParamStr(0));
      x := '<xseus>' + crlf + '<urlpaths> <map path="' + inidir +
        '/www/" url="/"></map>' + crlf + '</urlpaths><apppahts><xseus path="' +
        inidir + '/xseus/"/></appaths></xseus>';
      //SHOULD GO SOMETHING LIKE THIS
      //config:=ttag.create;
      //config.vari:=xseus;
      //atag:=config.addsubtag('urlpaths','');
      //atag.addsubtag(
      writeln('!SAVEINI TO:' + inif + '!read config! ' + x);
      config := tagparse(x, False, False);
      config.saveeletofile(inidir + '/xseus.xsi', True, '', False);
      config.Free;
      writeln('!SAVEINI TO:' + inif + '!read config! ' + config.xmlis);
      createdir(inidir + '/www');
      x := '<helloer class="xseus:hello.xsi"><mygreeting>hello world</mygreeting></helloer>';
      config := tagparse(x, False, False);
      config.saveeletofile(inidir + '/www/hello.htmi', True, '', False);
      config.Free;
      createdir(inidir + '/xseus');
      x := '<class name="hello"><open><h1>xse:/helloer/mygreeting</h1></open></class>';
      config := tagparse(x, False, False);
      config.saveeletofile(inidir + '/xseus/hello.xsi', True, '', False);
      config.Free;
    end;
    //inif:='C:\XSER\xseus.ini';  //SLASHES AND BACKSLASHES! GOTTA MAKE IT GENERAL
    //BESIDES: NOW ONLY XML-SYNTAX.. SHOULD CHECK XSEUS.XSI FIRST
    //logwrite('read config ' + inif);
    //config:=ttag.create;
    //config.fromfile(inif,nil);
    //config:=(config.subtags[0]);
    config := tagfromfile(inif, nil);
    //writeln('!' + config.vari + '!read config! ' + config.xmlis);

  except
    logwrite('failed to read inifile from ' + inif);
    exit;
  end;
  cache := TStringList.Create;
  xcommands := config.subt('commands');
  xpermissions := config.subt('permission');
  logwrite('iniii;' + config.xmlis);
  apppaths := config.subt('apppaths');
  logwrite('apptahts INDIR:' + apppaths.xmlis);
  smtpindir := config.subs('//smtp/@indir');
  logwrite('SMTP INDIR:' + smtpindir);
  logwrite('config read ' + config.vari + ' from ' + inif);
  try
    ftp := coNFIG.subt('ftp');
    smtp := coNFIG.subt('smtp');
    TIMERS := config.subt('timers');
  except
    logwrite('problems: xseus.ini, ftp/smtp-section');
  end;

end;

destructor txseusconfig.Free;
var
  oldtx: txseus;
  //not sure that there are't memory leaks .. small probllem, performed very seldom
  //anyway, this is not in use yet
begin
  oldtx := thrxs;
  thrxs := nil;
  cache.Free;
  config.Free;
  thrxs := oldtx;

end;


procedure txseusform.memolog(s: string);
begin
  // logmemo.Lines.add(s);
end;

procedure Txseusform.FormCreate(Sender: TObject);
var
  inif: string;
  i: integer;
begin
  globaltext:='globaaliteksti';
  gname:='forminnimi';
  //exit;
  try
    //  inherited create(NIL);
    LOGWRITE('CREATING FORM');
    logicriti := False;
    g_debug := False;
    //logicriti:=tcriticalsection.create;
    //logmemo.Lines.Add('xseusformi starting');
    logwrite('Starting xseusformi');
    //inherited create(nil);
    loglines := TStringList.Create;
    //xseusserver := TxseusServer.Create;
    logwrite('created xseusform!');
   { try
      try
        if xseuscfg.timers <> nil then
          for i := 0 to xseuscfg.timers.subtags.Count - 1 do
          begin
            //logwrite(ttag(timersini.subtags[i]).listraw);
            if ttag(xseuscfg.timers.subtags[i]).vari = 'timer' then
              ttimertask.Create(
                TStringList(ttag(xseuscfg.timers.subtags[i]).getattributes));
            //(self);
          end;
      except
        logwrite('problems: timers /xseus.ini, timers-section');
      end;
      try
        if xseuscfg.ftp <> nil then
        begin
          logwrite('ftpserver create:');
          //ftpserver := txseusftp.Create;
          logwrite('ftpserver created');
        end;
      except
        logwrite('problems: ftp-server');
      end;
      try
        if xseuscfg.smtp <> nil then
        begin
          //§§ smtpserver := txseussmtp.Create(xseuscfg.smtp);
          logwrite('smtpserver created');
        end;
      except
        logwrite('problems: smtp-server. ');
      end;
    except
      logwrite('failed to initialize');
      exit;
    end;
    }
  except
    logwrite('xs initialization failed ' + inif);
    exit;
  end;
  logwrite('XXXXXXXXXXXXXXxXSEUSFORM is  CREATED');
  //  xseusserver := TxseusServer.Create;

end;

procedure Txseusform.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  //showmessage('DEACIVATE');
  //xseusserver.server.active := False;
  //showmessage('DEACIVATEd');
  xseusserver.Free;

end;

procedure Txseusform.Button1Click(Sender: TObject);
begin
  //restartserver;
end;


procedure Txseusform.showlogClick(Sender: TObject);
begin
  //logmemo.Lines := loglines;  //WORKAROUND TO HANDLE MEMO TEXT ONLY IN MAIN THREAD
  //loglines.Clear;
end;

procedure tservpro.test;
begin
   logwrite('testing release');
   xseusserver.servs.doRelease(self);
   logwrite('didreleasetesting');
end;
procedure tservpro.writeheader;

  begin
  //if uri = '/' then
  logwrite('Write the output document to the stream');
  resutxt :=
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"' +
    ' "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' +
    CRLF + '<html><h1>hello world</h1>' + CRLF+inttostr(id)+'</html>';// inttostr(xseusserver.servs.freeths.count)+

  // Write the headers back to the client
  sock.SendString('HTTP/1.1 200' + CRLF);
  //sock.SendString('Transfer-Encoding: chunked'+CRLF);
  Sock.SendString('Content-type: Text/Html' + CRLF);
  Sock.SendString('Content-length: ' + IntToStr(Length(resutxt)) + CRLF);
  //Sock.SendString('Connection: close' + CRLF);
  //Sock.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
  Sock.SendString('Server: Timon Servidoris usando Synapse' + CRLF);
  Sock.SendString('' + CRLF);

  //  if ASocket.lasterror <> 0 then HandleError;
  //writeln(resutxt);
  // Write the document back to the browser
  //writeln(resutxt);
  Sock.SendString(resutxt);
  //writeln(resutxt);
  //writeln('');
  //Sock.SendString(crlf);
 //ck.
  //Sock.SendString(resutxt);
  //writeln('1234</html>');
  //Sock.SendString('1234</html>');
  //htmlclose(myoutput);
  //thisprocess.Sock.SendString('1234</html>');

end;//else
//ASocket.SendString('HTTP/1.0 404' + CRLF);


{@@
  Attends a connection. Reads the headers and gives an
  appropriate response
}



procedure tservpro.AttendConnection(ASocket: TTCPBlockSocket);

var
  timeout: integer;
  s: string;
  method, uri, protocol: string;
  resutext: string;
  ResultCode: integer;
begin
     thisprocess := self;
     assignhtml(output);
     timeout := 120000;
     logwrite('Received headers+document from browser:');

  //read request line
  s := ASocket.RecvString(timeout);
  //WriteLn(s);
  method := fetch(s, ' ');
  uri := fetch(s, ' ');
  protocol := fetch(s, ' ');

  //read request headers
  repeat
    s := ASocket.RecvString(Timeout);
    //WriteLn(s);
  until s = '';
  resutext := 'hello world';
  // Now write the document to the output stream
  writeheader;
  //FileClose(F.Handle)
end;

//procedure txseusserver.createsynserver;
constructor txseusserver.Create;
var
  ListenerSocket: TTCPBlockSocket;
  serverprocess: tservpro;
begin
  inherited create;
  gname:='myxseusserver';
  servs := tthreadpool.Create;
  //xseusform.memolog('At');
  logwrite('creating xseusserver');
  //exit;
 end;
procedure runserver;
var
  ListenerSocket: TTCPBlockSocket;
  serverprocess: tservpro;
  begin
    ListenerSocket := TTCPBlockSocket.Create;
    ListenerSocket.CreateSocket;
    ListenerSocket.setLinger(True, 10);
    ListenerSocket.bind('0.0.0.0', '6500');
    ListenerSocket.listen;
  repeat
    //logwrite('-');
    if ListenerSocket.canread(100) then
    begin
      logwrite('start connection');
      serverprocess := xseusserver.servs.obtain;
      serverprocess.Sock.Socket := ListenerSocket.accept;
      logwrite(crlf+'a connection'+inttostr(serverprocess.id)+inttostr(xseusserver.servs.freeths.count));
      //respa:=tresponse.create;
      //server.Sock := TTCPBlockSocket.Create;
      //xseusform.memolog('Attending Connection. Error code (0=Success): ' +
      //  IntToStr(ConnectionSocket.lasterror));
      //assignhtml(serverprocess.myoutput);
      //serverprocess.myoutput:=output;
      SERVERPROCESS.resume;
      logwrite('doid connection'+inttostr(serverprocess.id)+inttostr(xseusserver.servs.freeths.count));
      //serverprocess.AttendConnection(serverprocess.Sock);
      //servs.release(serverprocess);
    end
    else
    begin
      //SLEEPPAA;
    end;
  until False;

  ListenerSocket.Free;
  //ConnectionSocket.Free;
end;
{procedure Txseusform.FormActivate(Sender: TObject);
begin
  xseusserver:=txseusserver.create;
  //inherited paint;
  //show;
  logwrite('server is created');
  runserver;
end;
}
procedure Txseusform.FormDeactivate(Sender: TObject);
begin

end;
begin
logwrite('create server');
xseusserver:=txseusserver.create;
//xseusform.Show;
//sleep(1000);
logwrite('created server');
//inherited paint;
//show;
logwrite('server is created');
runserver;

//initialization
  // {$I xseusform.lrs}
   //showmessage('running');
  //xseusserver := TxseusServer.Create;

end.

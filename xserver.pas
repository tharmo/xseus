unit xserver;

{$mode delphi}
interface
    uses
      {$IFDEF LINUX}
       cthreads,
       cmem,
      heaptrc,
      {$ENDIF}
      Classes, SysUtils, strutils,FileUtil, //Forms, Controls, //Graphics, Dialogs,
       blcksock, sockets, Synautil,
    {$IFNDEF FPC}  Messages, {$ELSE}
      LCLIntf, LMessages,
      LclType,
//      interfaces,
      //LResources,
      {$ENDIF}
      //xsetrie,
      //syncobjs,
      xsemisc,
      xseglob,
      //xsecgi,
      xsexml,
      //xsefun,
      //xseexp,
      //xsecomp,
      //xsedif,
      //ExtCtrls,
      //xseftp,
      {$ifndef windows}
     // xsetimers,
      {$ENDIF}

      //xsesmtp,// xsesta,
      xsexse;//, StdCtrls, ExtDlgs;//,syncobjs;


{  Method waits until data string is received. This string is terminated by
     CR-LF characters. The resulting string is returned without this termination
     (CR-LF)! If @link(ConvertLineEnd) is used, then CR-LF sequence may not be
     exactly CR-LF. See @link(ConvertLineEnd) description. If no data is
     received within TIMEOUT (in milliseconds) period, @link(LastError) is set
     to WSAETIMEDOUT. You may also specify maximum length of reading data by
     @link(MaxLineLength) property.
    function RecvString(Timeout: Integer): AnsiString; virtual;
}
type tsession=class(tobject)
   id,ip:string;port:integer;sestag:ttag;

   lasttime,starttime:tdatetime;
    //constructor create(ti:tdatetime);
    destructor free;
   end;

type tsessions=class(tobject)
   //sescookies:tstringlist;
   //time sestags,lasttimes,starttimes:tlist;//<TDateTime>;
   //sestags:tlist;//<TDateTime>;
   //lasttimes,starttimes:array of tdatetime;//<TDateTime>;
   //lasttimes,starttimes:ttimelist;
  //asttimes,starttimes:ttimelist;

   SesSIONS:tLIST;
   sestimeout:integer;
   function createsession(sessid:string;servi:pointer):tsession;
   function getsession(sessid:string):tsession;
   procedure clearsession(sess:tsession);
   //procedure delsession(idi:string);
   //procedure purgesession(ordo:integer);
   procedure purgeoldsessions;
   function gettime(ind:integer):tdatetime;
   function addtime(ti:tdatetime):integer;
   procedure settime(ti:tdatetime);
   constructor create;
   destructor clear;
end;



type

  Tlistener = class(TThread)
    ListenerSocket: TTCPBlockSocket;
      procedure dofree;
  //protected
    procedure Execute; override;
    constructor create(sus:boolean);
    destructor destroy;override;
  end;
 //txseus =class(tobject); //defined in txseus

 Tserving = class(TThread)
  private
    fStatusText: string;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    id,contlen:integer;
    method, uri, fullurl,protocol,contenttype,host,statusline: string;
    session:tsession;
    myxseus:pointer;//txseus;
    cookie:string;
    clientip:string;
    clientport:integer;
    sock: TTCPBlockSocket;
    HeaderHasBeenWritten: boolean;
    chunked:boolean;
    resutxt: string;
    xml:boolean;
    //content_stream:tstream;
    params,uploads:tstringlist;
    postdata:string;
    requestheaders,responseheaders:tstringlist;   //myoutput:ttextrec;
    procedure createheader;
    procedure docookies;
    procedure setheader(vari,vali:string);
    //procedure getquery(query:string);
    function servefile(mime, url:string):string;
    function redirect(mime, url:string):string;
    procedure getparams(postdata:string);
    procedure getmultiparams(len:integer;soc:TTCPBlockSocket;str:string);
    procedure getrest(len:integer;soc:TTCPBlockSocket;str:string);
    procedure AttendConnection(ASocket: TTCPBlockSocket);
    function writecustomheaders(httphead,conttype:string;len:integer):string; //,cookies:tstringlist
    procedure writeheaders;
    procedure test;
    procedure doFree;
    constructor Create(CreateSuspended: boolean);
    //destructor destroy;override;
  end;

  tthreadpool = class(TObject)
    threadCount: integer;
    freeths, inuseths,all: TList;
    function obtain: tserving;
    procedure doRelease(spr: tserving);
    //constructor Create;
    procedure init;
    destructor Free;
  end;


type txseusserver = class(TObject)
    gname:string;
    ssl,serverchunked:boolean;
    sessions: Tsessions;
    sessiontimeout: integer;
    listener:tlistener;
    servs: tthreadpool;
    defaultheaders:tstringlist;
    procedure run;
    //procedure iniutils;
    constructor Create;
    destructor free;
    //procedure sessionstart(Sender: TIdHTTPSession);
  private
    //procedure sessionend(Sender: TIdHTTPSession);
    //procedure serverConnect(AContext: TIdContext);
    //procedure serverdisconnect(AContext: TIdContext);
  end;




var   //xseuscfg: txseusconfig;
  xseusserver: TxseusServer;
 // g_writehandler:ttextrec;
 // g_keepbuffer:boolean;
  //ftpserver: txseusftp;
  //sslserver: tsslserver;
  //xseusformi: Txseusformi;
  //connections: integer;

procedure bitofrest;


implementation
uses xseauth;
{  $R *.lfm}
function tsessions.gettime(ind:integer):tdatetime;
begin
end;
function tsessions.addtime(ti:tdatetime):integer;
begin
end;
procedure tsessions.settime(ti:tdatetime);
begin
end;
{constructor tsession.create(ti:tdatetime);
begin
end;}
destructor tsession.free;
begin
  sestag.killtree;
  inherited free;
end;

{PROCEDURE TESTDATE;
var tdl:tlist;dt:tdatetime;dtp:^tdatetime;
begin
     dtp:=new(^tdatetime);
end;}
procedure tlistener.dofree;
begin
 //listenersocket.free;
 //writeln('listener freed');
 // inherited free;
end;
constructor tlistener.create(sus:boolean);
begin
 freeonterminate:=false;
 logwrite('listener created');
 writeln('listener created');
 inherited create(sus);
end;
destructor tlistener.destroy;
begin
logwrite('listener destroy');
 //listenersocket.
 //listenersocket.SetLinger(false,0);
 listenersocket.CloseSocket;
 listenersocket.free;
 logwrite('listener destroyed');
 inherited destroy;
end;

function tsessions.createsession(sessid:string;servi:pointer):tsession;
var sest:ttag;ases:tsession;
begin
 //logwrite('newsess for:'+sessid);
 sest:=ttag.create;
 sest.vari:='session';
 sest.addsubtag('started',timetostr(now));
 sest.addsubtag('ip',tserving(servi).clientip);
 sest.addsubtag('port',inttostr(tserving(servi).clientport));
 sest.vari:='session';
 system.enterCriticalSection(g_sesscriti);
 try
  ases:=tsession.create;
  sessions.add(ases);
  ases.id:=sessid;
  ases.ip:=tserving(servi).clientip;
  ases.port:=tserving(servi).clientport;
  ases.starttime:=now;
  ases.lasttime:=now;
  ases.sestag:=sest;
 //sescookies.add(sessid);
  ases.sestag:=sest;
  //logwrite('created session:'+inttostr(sessions.count)+ases.sestag.xmlis);
 {$ifndef windows} // .. its actually 32/64 quetion, not win/linux
 // starttimes.add(pointer(now));
 // lasttimes.add(pointer(now));
 {$ENDIF}
 //sesSIONS.ADD(tSESSION.create(NOW));
 //SES.starttime:=now;
 //starttimes.addtime(now);
 finally system.leaveCriticalSection(g_sesscriti);end;
 //logwrite('newsess:'+sestag.xmlis);
 result:=ases;
end;
function tsessions.getsession(sessid:string):tsession;
var i,ioc:integer; sestag:ttag;ases:tsession;
begin
 result:=nil;
 //logwrite('getses1');
 system.enterCriticalSection(g_sesscriti);
 ases:=nil;
 try
 //logwrite('getses2');
 for i:=0 to sessions.count-1 do
  if tsession(sessions[i]).id=sessid then
  begin
      ases:=sessions[i];
      ases.lasttime:=now;
      //logwrite('gotsession:'+inttostr(i)+ases.sestag.xmlis);
      break;
  end;
  if ases=nil then begin
  logwrite('nosession');exit;end;
 //ioc:=sescookies.indexof(sessid);
 //if ioc<0 then exit;//begin logwrite('nosession:'+inttostr(ioc)+sessid);exit;end;
 //sestag:=ttag(sestags[ioc]);
 sestag:=ases.sestag;
 //logwrite('getses4');
 finally system.leaveCriticalSection(g_sesscriti);end;
 //sestag.addsubtag('hit',datetimetostr(now));
 //logwrite('oldsess:'+sestag.xmlis);
 //logwrite('getses5');
 result:=ases;
end;
procedure tsessions.clearsession(sess:tsession);
var ordo,i:integer;ases:tsession;
begin
 system.enterCriticalSection(g_sesscriti);
  for i:=0 to sessions.count-1 do
   if tsession(sessions[i])=sess then
   begin
   tsession(sessions[i]).free;
   sessions.delete(i);
     break;
   end;
 //sescookies.delete(ordo);
 //sestags.delete(ordo);
 //starttimes.delete(ordo);
 //lasttimes.delete(ordo);
 system.leaveCriticalSection(g_sesscriti);
end;
{procedure tsessions.purgesession(ordo:integer);
begin
//system.enterCriticalSection(g_sesscriti);
 //this should be called only from within a criticalsection
sescookies.delete(ordo);
sestags.delete(ordo);
starttimes.delete(ordo);
lasttimes.delete(ordo);
//system.leaveCriticalSection(g_sesscriti);

end;
}
procedure tsessions.purgeoldsessions;
var i,c:integer;killtime:tdatetime;
begin
 killtime:=now-(sestimeout/1440);
 logwrite('purgeolder:'+datetimetostr(killtime)+'  '+datetimetostr(now));
 system.enterCriticalSection(g_sesscriti);
 c:=sessions.count-1;//lasttimes.count-1;
 try
  for i:=c downto 0 do
   //if tdatetime(lasttimes[i])<killtime then
   if tsession(sessions[i]).lasttime<killtime then
   begin //logwrite('purge:'+sescookies[i]);purgesession(i);
     clearsession(sessions[i]);
   end;// else logwrite('keep:'+sescookies[i]+'/'+floattostr(86400*(now-tdatetime(lasttimes[i]))));
finally system.leaveCriticalSection(g_sesscriti);end;

end;
constructor tsessions.create;
begin
//sescookies:=tstringlist.create;
//sestags:=tlist.create;
//lasttimes:=tlist.create;
//starttimes:=tlist.create;
 sessions:=tlist.create;
 logwrite('Created sessionlist, timeout:'+inttostr(sestimeout));
end;
destructor tsessions.clear;
var i:integer;ases:tsession;
begin
 for i:=0 to sesSIONS.Count-1 do
 begin
   ASES:=sessions[i];
   ASES.sestag.killtree;
 end;
 SESSIONS.CLEAR;SESSIONS.FREE;
 //sescookies.Free;
 //starttimes.free;
 //lasttimes.free;
 //sestags.free;
end;
function HtmlALLOut(var F: TTextRec): integer;
var
  s,hdr: string;
  i, len: integer;
  b: byte;
  begin
      try
        logwrite('htmlALLout'+inttostr(integer(f.bufpos)));
        SetString(s, PAnsiChar(f.bufptr), f.bufpos);
        //content-type: chunked means writing these chunks and their legths in HEX
        len := length(s);
        logwrite('len:'+inttostr(len)+'!'+inttostr(f.bufpos));
        //Tserving(t_thisprocess).writecustomheaders('HTTP/1.0 200','text/html',f.bufpos);
        //hdr:=Tserving(t_thisprocess).writecustomheaders('HTTP/1.0 200','text/html; charset=utf-8',f.bufpos);
        hdr:=Tserving(t_thisprocess).writecustomheaders('HTTP/1.0 200','text/html; charset=ISO-8859-1',f.bufpos);
        //Tserving(t_thisprocess).sock.SendBufferTo(f.bufptr,f.bufpos);
        Tserving(t_thisprocess).sock.SendString(hdr+s);
        //logwrite('s:' + s);
      except
        logwrite('failed htmlallout');
        //logwrite('s:' + s);
        raise; //GOTTA RAISE THIS ONE, OTHERWISE WE CAN GET MILLIONS OF THESE
        // WHEN BROWSERS QUIT CONNECTIONS
      end;
      F.BufPos := 0;
      Result := 0;
  end;
function ALLOut(RES:TMEMORYSTREAM): integer;
var
  s,hdr: string;
  i, len: integer;
  b: byte;
  begin
      try
       if res<>nil then
       begin
       logwrite('allout::'+inttostr(integer(RES.SIZE)));
       end else logwrite('noallout');
        //logwrite('tryallout');
        hdr:=Tserving(t_thisprocess).writecustomheaders('HTTP/1.0 200','text/html; charset=iso-8851-1',RES.position);
        Tserving(t_thisprocess).sock.SendString(hdr);
        Tserving(t_thisprocess).sock.SendBuffer(RES.MEMORY,RES.position);
        //logwrite('s:' + s);
      except
        logwrite('failed allout');
        //logwrite('s:' + s);
        raise; //GOTTA RAISE THIS ONE, OTHERWISE WE CAN GET MILLIONS OF THESE
        // WHEN BROWSERS QUIT CONNECTIONS
      end;
   RES.FREE
  end;

function HtmlOutput(var F: TTextRec): integer;
var
  s: string;
  i, len: integer;
  b: byte;
  begin
     if f.bufpos=0 then exit;
     if not xseusserver.serverchunked then
        //if 1=0 then
        //if t_keepbuffer then
        begin
           try
           //SetString(s, PAnsiChar(f.bufptr), f.bufpos);
           //logwrite('write:'+inttostr(integer(f.bufpos)));
           t_outbuffer.writebuffer(f.buffer,f.bufpos);
           //logwrite('res from:'+inttostr(f.bufpos)+'/'+inttostr(t_outbuffer.position));
           F.BufPos := 0;
           Result := 0;
           except logwrite('failed to write to buffer****************');end;

         exit;
        end
       ;//else begin htmlallout(F);exit;end;
      //should be possible to also keep everything in buffer and
      //write at end along with content-length. But is not yet
      if not Tserving(t_thisprocess).HeaderHasBeenWritten then
      begin
        try
         Tserving(t_thisprocess).writeheaders;
          Tserving(t_thisprocess).HeaderHasBeenWritten := True;
          logwrite('wrote headers TO pORT:'+ inttostr(Tserving(t_thisprocess).sock.getremotesinport));

        except
           logwrite('failed httpinit');
          //raise;  //NO RAISING ERRORS YET... GOTTA BUILD SOME CENTRAL ERROR-HANDLING SCHEME
        end;
      end;
      try
        SetString(s, PAnsiChar(f.bufptr), f.bufpos);
        //content-type: chunked means writing these chunks and their legths in HEX
        len := length(s);
        s := inttohex(len, 4) + crlf + S + crlf;
        Tserving(t_thisprocess).sock.SendString(s);
        //logwrite('s:' + inttostr(f.bufpos));
      except
        logwrite('failed htmloutput');
        //logwrite('s:' + s);
        raise; //GOTTA RAISE THIS ONE, OTHERWISE WE CAN GET MILLIONS OF THESE
        // WHEN BROWSERS QUIT CONNECTIONS
      end;
      F.BufPos := 0;
      Result := 0;
  end;



function HtmlClose(var F: TTextRec): integer;
begin
  FileClose(F.Handle); { *Converted from CloseHandle*  }
  Result := 0;
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
  logwrite('assign outoput');
    t_writehandler:=TTextRec(F);
    with TTextRec(F) do
    begin
          Mode := fmoutput;
       logwrite('outputmodeok');
      FillChar(F, SizeOf(F), 0);
      logwrite('assigned outoput1');
      Mode := fmClosed;
      logwrite('assigned outoput2');
      BufSize := SizeOf(Buffer);
      logwrite('buffer:'+inttostr(sizeof(buffer)));
      BufPtr := @Buffer;
      OpenFunc := @HtmlOpen;
      htmlopen(ttextrec(f));
      logwrite('assigned outoput');
    end;
  except
    logwrite('no writeln outoput');
  end;
end;

function tserving.servefile(mime, url:string):string;
var filen,ss:string;contents:tfilestream;
  csize:integer;
  //sst:tstringstream;
procedure fail;
begin
  logwrite('failedfile:'+uri+'('+filen+')'+mime);
  sock.SendString('HTTP/1.1 404 Not Found' + CRLF);
  Sock.SendString('Content-length: '+inttostr(15+length(filen))+ CRLF);
  Sock.SendString('Content-type: text/plain' + CRLF);
  //Sock.SendString('Connection: close' + CRLF);
  Sock.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
  Sock.SendString('Server: Xseus / Synapse' + CRLF);
  sock.sendstring(crlf+'File not found:'+filen);
end;
var hdr:string;
begin
  try
    filen := _getpath(_mapurltofile(url, g_xseuscfg.subt('urlpaths')),'\');
    if not fileexists(filen) then
    fail else
    begin
     contents:=tfilestream.create(filen,fmopenRead);
     try
        ss:= streamtostring(contents,0,contents.size);
        contents.seek(0,sobeginning);

       if contents.Size>0 then
       begin
        hdr:=writecustomheaders('HTTP/1.1 200',mime,contents.Size);
          try
          Sock.SendString(hdr+ss);
          //content.free;
          except logwrite('failed writing');end;
       end else   fail;
     finally
         try
             contents.Free;
          except    logwrite('failed to free content');end;
      end;
    end;
  except fail;end;
end;
//destructor

function tserving.redirect(mime, url:string):string;
//if pos('login', uri)<1 then
 begin //redirect

   sock.SendString('HTTP/1.1 301 Moved Permanently' + CRLF);
  Sock.SendString('Location: '+url + CRLF);


 //statusline:='HTTP/1.1 301 Moved Permanently';
//setheader('location','http://www.google.com');//url+formst);
end;

procedure tserving.doFree;
begin
  LOGwrite('stop thread '+inttostr(id));
  try
  params.free;
  uploads.free;
  except logwrite('failedfree params');end;
  try
  sock.Free;
  except logwrite('failedfree sock');end;
  try
  //inherited Free;
  except logwrite('failedfree ibnherited');end;
end;

constructor tserving.Create(CreateSuspended: boolean);
begin
  inherited Create(CreateSuspended);//,500000);
  xml:=false;
  FreeOnTerminate := true;
  sock := TTCPBlockSocket.Create;
  HeaderHasBeenWritten := False;
  resutxt:='';
  xml:=false;
  //chunked:=false;
  uploads:=tstringlist.create;
  params:=tstringlist.create;
  elements_created:=0;
  elements_freed:=0;
  //inherited Create(true);
end;

procedure tserving.ShowStatus;
// this method is executed by the mainthread and can therefore access all GUI elements.
begin
  //Form1.Caption := fStatusText;
end;

procedure tserving.Execute;
var
  newStatus: string;smem:carDINAL;
begin
  //fStatusText := 'tservthread Starting...';
  fStatusText := 'tservthread Running...';
  while (not Terminated) and (1 = 1) do
  begin
    try
    smem:=getheapstatus.totalallocated;
    logwrite('Open connection '+'/'+sock.getremotesinip+':'+inttostr(sock.getremotesinport));
    HeaderHasBeenWritten := False;
    attendconnection(sock);
    //logwrite('Close socket'+inttostr(sock.getremotesinport));
   // SOCK.PURGE;
    //sock.free;
    finally
      try
      xseusserver.servs.dorelease(self);
      sock.CloseSocket;
      sock.purge;
      finally
      logwrite('connectionmemlost:'+floattostr(getheapstatus.totalallocated-smem));
      end;
      suspend;
      //sock.free;
    end;
  end;
end;

procedure tthreadpool.doRelease(spr: tserving);
var
  pos: integer;//p:tserving;
begin
   system.enterCriticalSection(g_threadpoolcriti);
   try
    freeths.add(spr);
    logwrite('released thread '+inttostr(spr.id)+' now at '+inttostr(freeths.indexof(spr))+'/'+inttostr(freeths.count));
   finally
   system.leavecriticalsection(g_threadpoolcriti);
   end;

end;

function tthreadpool.obtain: tserving;
var i:integer;
begin
   result:=nil;
 for i:=0 to 100 do
 begin
 logwrite(inttostr(i)+'/get thread, free:'+inttostr(freeths.count));
  if freeths.count<1 then begin sleep(200);continue;end;
     system.entercriticalsection(g_threadpoolcriti);
   //  try
      if freeths.count>0 then
      begin
        Result := freeths[0];
        freeths.Delete(0);
        system.leavecriticalsection(g_threadpoolcriti);
        break;
      end;
     //finally
     system.leavecriticalsection(g_threadpoolcriti);
     //end;
    sleep(200);
 end;
 //WaitForSingleObject();
 //logwrite('got thread, free:'+inttostr(freeths.count));
end;


//constructor tthreadpool.Create;
procedure tthreadpool.init;
var
  i: integer;
  serving: tserving;
begin
  threadCount:=3;
  freeths := TList.Create;
  all := TList.Create;
  inuseths := TList.Create;
  for i := 0 to threadCount - 1 do
  begin
    serving := tserving.Create(true);
    freeths.Add(serving);
    all.Add(serving);
    serving.id:=i;
    serving.FreeOnTerminate:=true;
    logwrite('created thread '+inttostr(i));
  end;
end;


destructor tthreadpool.Free;
var i:integer;
begin
 logwrite('threadpoold.free'+inttostr(all.count));
for i:=0 to all.count-1 do
 begin
   logwrite('free:'+inttostr(tserving(all[i]).id)+'_'+inttostr(threadcount));
   try
   tserving(all[i]).dofree;
   //tSERVING(all[i]).free;
   except logwrite('failfreeserving '+inttostr(i));end;
 end;
//listener.terminate;
for i:=0 to all.count-1 do
try
tserving(all[i]).terminate;
  SLEEP(10);
except writeln('failterminate '+inttostr(i));end;
//for i:=0 to all.count-1 do
//  tthread(all[0]).free;
  freeths.Free;
  inuseths.Free;
  all.free;
  logwrite('threadpoold.freed');
end;

procedure bitofrest;
var i:integer;
begin
  //for i:=0 to 1050 do
//  APPLICATION.ProcessMessages;

  //SLEEP(100);
end;





procedure tserving.test;
begin
  // logwrite('testing release');
  // xseusserver.servs.doRelease(self);
  // logwrite('didreleasetesting');
end;

procedure tserving.createheader;
begin
statusline:='HTTP/1.1 200';
requestheaders:=tstringlist.create;
responseheaders:=tstringlist.create;
responseheaders.AddStrings(g_xseuscfg.defheaders);
//logwrite('defhead:'+responseheaders.text);
end;

procedure tserving.writeheaders;
var i:integer;ht:string;
 begin
   sock.SendString(statusline + CRLF);
   //logwrite('httphead:'+statusline+responseheaders.text);
   for i:=0 to responseheaders.count-1 do
   begin
    ht:=responseheaders[i];
    if trim(ht)<>'' then sock.SendString(cut_ls(ht)+':'+cut_rs(ht) + CRLF);
    //sock.SendString(cut_ls(ht)+':'+cut_rs(ht));
    logwrite(('H::'+cut_ls(ht)+':'+cut_rs(ht) + CRLF));
   end;
    sock.SendString(CRLF);

 end;

function tserving.writecustomheaders(httphead,conttype:string;len:integer):string;
var rst:string;
procedure socksendstring(st:string);
begin
   rst:=rst+st;
end;
begin
  rst:='';
  sockSendString(httphead + CRLF);
  if len<0 then
  begin
    sockSendString('Transfer-Encoding: chunked'+CRLF);
    SockSendString('Pragma: no-cache' + CRLF);
    SockSendString('Cache-Control: no-cache' + CRLF);
  end   else SockSendString('Content-length: ' + IntToStr(len) + CRLF);
  SockSendString('Content-type: '+conttype + CRLF);
  //SockSendString('Connection: close' + CRLF);
  //SockSendString('Connection: keep-alive' + CRLF);
  if pos('application',LOWERCASE(CONTTYPE))>0 then
  SockSendString('Content-Disposition: attachment'+crlf);
  SockSendString('Date: ' + Rfc822DateTime(now) + CRLF);
  if cookie<>'' then
    SockSendString('Set-Cookie: xseus_session='+cookie+'; path=/'+crlf);
  SockSendString('Server: Xseus / Synapse' + CRLF);
  SockSendString(CRLF);
  logwrite('custheads: '+rst+inttostr(length(rst))+'!');
  //sock.sendstring(rst);
  result:=rst;
  //sock.SendBufferTo(pointer(rst[1]),length(rst));
end;



function qsearchssoc(border: shortstring; soc: TTCPBlockSocket;start,m,n:integer;
         skip: array  of integer
        // ;var respc:pansichar
        ):integer;
     var i, j,k: integer;ch,ch2:ansichar;st,resst:string;//respc:pansichar;
         found: boolean;
     begin      // writeln('seeking:',start,' ',m,' ',n,' ', text.Size);
       try try
       found := FALSE;  result := -1;  k := start+m;
       while not found and (k <= n) do
       begin
          i := k; j := m;
          resst:=soc.RecvTerminated(100,border);
          //text.Seek(i,sobeginning);  text.Read(ch,1);
          ch:=chr(soc.PeekByte(100));
          ch2:=ch;
          while (j >= 1) do
          if ch2 <> border[j] then j := -1 else
          begin
              j := j-1;  i := i-1;
              //text.seek(i,sobeginning);text.Read(ch2,1);   turha:=turha+'-'+ch2;
              //resst:=soc.RecvTerminated(100,border);
              ch:=chr(soc.PeekByte(100));
          end;
          if j = 0 then
          begin
            resst:=soc.RecvTerminated(100,border);
                  result:=i+1;
                  found := TRUE;
                  break;
          end;
          k := k + skip[ord(ch)];
       end;
        except writeln('<li>faildeqsearch');raise;end;
finally
                  //writeln('<li>FOUND:',st,length(st), ' ',k);
                  //writeln('FOUND in:',result);
end;
end;



procedure tserving.getrest(len:integer;soc:TTCPBlockSocket;str:string);
var fs:tfilestream;filename,ermsg:string;
begin
  try
    //str:=soc.RecvBufferStr();
    //str:=soc.RecvBufferstr(contlen,1000);
   logwrite('doinggetrest****************');
   filename:=requestheaders.values['xfilename'];
  //fs:=tfilestream.Create('/home/t/xseus/downloads/test.xxx',fmcreate or fmopenwrite);
   try
      //logwrite('**********fileupload:'+inttostr(contlen)+'bytes to '+g_inidir+'/downloads/'+filename+'/for:'+cookie+'/ses:'+session.xmlis);
       fs:=tfilestream.Create(g_inidir+'/downloads/'+filename,fmcreate or fmopenwrite);
       logwrite(inttostr(contlen)+'created file:'+g_inidir+'/downloads/'+filename+filename);
     //SOC.Recvstreamsize(fs,5000,100);
     try
     SOC.Recvstreamsize(fs,1000,contlen);
     //postdata:=(soc.RecvBufferStr(contlen,1000));
     logwrite('received file:'+g_inidir+'/downloads/'+filename+inttostr(fs.size));
     // fs.WriteAnsiString(postdata);
     //SOC.READbuffer(curbyele.vali[1], length(curbyele.vali));
     except on e:exception do  logwrite('########ERR:'+e.message);end;
     //SOC.Recvstreamraw(fs,5000);
     finally
     logwrite('****file now '+inttostr(fs.size));
     fs.Free;
     soc.SendString('HTTP/1.0 204 No Content' + CRLF);
     //soc.SendString('HTTP/1.1 200 OK' + CRLF);
     soc.SendString('Connection: Closed' + CRLF+crlf);


     end;
    //logwrite(str);

  except
   // HTTP/1.1 400 Bad Request
   // HTTP/1.1 404 Not Found
    ermsg:='File could not be uploaded';
    soc.SendString('HTTP/1.1 400 Bad Request' + CRLF);
    soc.SendString('Content-Length: '+inttostr(length(ermsg)) + CRLF);
    soc.SendString('Content-Type: text/plain;' + CRLF);
    soc.SendString('Connection: Closed' + CRLF+crlf);
    soc.SendString(ermsg);
    logwrite('****could not write upload');
  end;
end;

procedure tserving.getmultiparams(len:integer;soc:TTCPBlockSocket;str:string);
var st:string; //        tf:file;
vari,vali:shortstring;
//vars,ifiles,tt:ttag;
s,hstr,fstr,boundary: string;
upstream:tmemorystream;
i:integer;
begin
  fetch(str,';');
  //logwrite('***UPLOAD'+str);
  boundary:='--'+copy(fetch(str,';'),10,9999);
  //logwrite('***boundary'+boundary);
  str:=soc.RecvTerminated(1000,boundary);
  str:=soc.RecvTerminated(1000,boundary);
  while str<>'' do
  begin
    //logwrite('***next'+str);
    hstr:=fetch(str,crlf+crlf);
    hstr:=copy(hstr,pos('name="',hstr)+6,999);
    fstr:=copy(hstr,pos('filename="',hstr)+10,999);
    hstr:=copy(hstr,1,pos('"',hstr)-1);
    fstr:=copy(fstr,1,pos('"',fstr)-1);
    if fstr='' then
      params.add(hstr+'='+copy(str,1,length(str)-2))
    else
     begin
      //s:='';for i:=1 to length(str) do s:=s+'-'+inttostr(ord(str[i]));
       //logwrite('###'+s);
        //fetch(str,crlf+crlf);
        upstream:=tmemorystream.create;
        upstream.SetSize(length(str)-2);
        try
        upstream.writeBuffer(str[1],length(str)-2);
        //s:='';for i:=1 to length(str) do s:=s+'-'+inttostr(ord(str[i]));
       //logwrite('###'+s);
        except logwrite('could not read buffer'+inttostr(length(str)-2));end;
        try
        except logwrite('could not save upload /home/t/xseus/upload.pdf'+inttostr(upstream.size));end;
     try
     uploads.addobject(hstr+'='+fstr,upstream);
     params.add(hstr+'='+fstr);
     params.add('@type=file');
     params.add('@size='+inttostr(length(str)-2));
     //params.add('@content='+str+'!');
     //logwrite('saved upload '+fstr+inttostr(upstream.size)+'//'+uploads.text);
     except logwrite('failed to get upfile');end;
     end;
    str:=soc.RecvTerminated(100,boundary);
  end;
  //logwrite('***params:'+params.text);
end;

procedure tserving.getparams(postdata:string); //get parameters from url, and postdata (if specified in the call)
var i,poseq,posq:integer;xres,curtag:ttag;ss,vari,vali,urlpars:string;stl:tstringlist;
begin
 fullurl:=uri;
 begin
   posq:=pos('?',uri);
   if posq<1 then urlpars:='' else
   begin
   stl:=tstringlist.create;
   urlpars:=(copy(uri,posq+1,99999));
   uri:=(copy(uri,1,posq-1));

   _split(urlpars+'&'+postdata,'&',stl);  //would be faster by scanning the string (or original stream)  directly. later.
   for i:=0 to stl.count-1 do
   begin
     if stl[i]='' then continue;
     ss:=_UrlDecode(stl[i]);
     poseq:=pos('=',ss);
     vari:=copy(ss,1,poseq-1);
     //vali:=_clean(copy(ss,poseq+1,999999));//why clean?
     vali:=(copy(ss,poseq+1,999999));
     if poseq<1 then params.add('handler='+vali) else
     params.add(vari+'='+vali);
     //logwrite('*gotpar:'+vari+inttostr(length(vali)));

   end;
   stl.clear;stl.free;
   end;
   //logwrite(uri+'*****params:'+params.text+inttostr(params.count));
 end;
end;

procedure tserving.setheader(vari,vali:string);
begin
 // logwrite('setting responseheader !'+vari+'_to_'+vali+'!');
 responseheaders.values[vari]:=vali;
end;

function _getcookie(reqhea:tstringlist):string; //temporary.. will be expandend
var stl:tstringlist;i,j,posi:integer;hline,s:string;
begin
 result:='';
 //stl:=tstringlist.create;
 //try
     hline:=lowercase(reqhea.text);
     //s:=crlf+'XXX:';
     hline:=_gsub(^M,'/MMM:',hline);
     hline:=_gsub(^J,'/JJJ:',hline);
     logwrite('headers:'+hline+'!');
     fetch(hline,crlf+'cookie=');
     hline:=fetch(hline,';');
     //logwrite('COOKIE:'+hline+'!');

     //result:=hline;
end;
{ for i:=0 to reqhea.Count-1 do
  if pos('cookie',lowercase(reqhea[i]))=1 then
  begin
    hline:=reqhea[i];
    fetch(
    stl.clear;
   _split(cookieline,';',stl);
   logwrite('tryline:'+cookieline+':'+inttostr(stl.Count)+'!');
   for j:=0 to stl.count-1 do
   if pos('xseus_session=',trim(stl[j]))=1 then
   begin
   posi:=pos('xseus_session',stl[j]);
   result:=copy(stl[j],posi+length('xseus_session='),999);
   posi:=pos(',',result);
   if posi>1 then result:=copy(result,1,posi-1);
   logwrite('cookieline:'+cookieline+'/xcookie:'+result+'!');
   end else logwrite('nogo:'+stl[j]+'!');
   if result<>'' then exit;

  end;
 finally stl.Free;
 end;
end;}
procedure tserving.docookies;
begin
try
if cookie='' then
begin cookie:=_randomstring;
end else  session:=xseusserver.sessions.getsession(cookie);
if session=nil then
begin
 session:=xseusserver.sessions.createsession(cookie,self);
end;
setheader('Set-Cookie','xseus_session='+cookie+'; path=/');
 session.ip:=clientip;
 session.port:=clientport;
//logwrite('thissession:'+session.xmlis);
except logwrite('Problems with cookies and session(cookie:'+cookie+')');end;
//logwrite(timetostr(now)+' connection gotses for '+cookie+'/'+inttostr(id)+':'+session.xmlis);
end;

procedure tserving.AttendConnection(ASocket: TTCPBlockSocket);
function _isxseus(ext:string):boolean;
begin
 logwrite('atten'+ext);
 if (ext='htmi') or (ext='htme') or (ext='xse') or (ext='xsi') then result:=true else result:=false;
end;
var
  timeout: integer;
  s,st,str,cmd,ext,ctype,mime: string;
  hvari,hvali,resutext: string;
  smem:cardinal;
  keepxseusalive,restfull:boolean; //rest file put
  i,vc,ResultCode,hposi: integer; //contlen,

  //mystream:tstringstream;

begin
   keepxseusalive:=false;
  try
  try  //init
     xml:=false;
     contenttype:='';
     createheader;
     restfull:=false;
     //uploads:=tstringlist.create;
     //params:=tstringlist.create;

     t_thisprocess := self;
     t_debug:=false;
     timeout := 120000;
    //read request line
   except writeln('<li>serving failed to init'); raise;end;
   //inited

  try //read request headers
  s := ASocket.RecvString(timeout);
  contlen:=0;
  cmd:=s+'/thread:'+inttostr(id);
  logwrite('/mem+'+inttostr(id)+'/a:'+floattostr(getheapstatus.totalallocated));
 // logwrite('RECEIVED:'+s+'+/thread:'+inttostr(id)+'/mymem:'+floattostr(getheapstatus.totalallocated));
  method := fetch(s, ' ');
  uri := fetch(s, ' ');
  protocol := fetch(s, ' ');
  clientip:=sock.getremotesinip;
  clientport:=sock.getremotesinport;
  setheader('Server','Xseus / Synapse');
  repeat
    s := (ASocket.RecvString(Timeout));
    if s='' then break;
    hposi:=pos(':',s);
    //logwrite('*'+copy(s,1,hposi-1));
    hvari:=lowercase(trim(copy(s,1,hposi-1)));
    hvali:=trim(copy(s,pos(':',s)+1,9999));
    requestheaders.add(hvari+'='+hvali);

    if hvari='cookie' then
    begin
     fetch(hvali,'xseus_session=');
     cookie:=fetch(hvali,';');
    end else
    if hvari='content-length' then contlen:=strtointdef(hvali,0)  else
    if hvari='host' then host:=hvali  else
    if hvari='content-type' then contenttype:=hvali;
  until s = '';

  except logwrite('failed to read headers'); raise; end;
  // headers read
   logwrite('read headers:'+requestheaders.Text);
   try //read params
    postdata:='';
    if pos('application/octet-stream',CONTENTTYPE)>0 then
    begin
    getparams('');
    //responseheaders.values['content-type']:='text/xml';
    //postdata:=(Asocket.RecvBufferStr(contlen,1000));
    //logwrite('XMLPARAMS:'+params.text+'!!!!!!!!!');
    //logwrite('XMLCONT:'+postdata+'!!!!!!!!!');
     restfull:=true;
     getrest(contlen,asocket,str);
     //writecustomheaders('HTTP/1.1 200 OK','');

    end else
    if pos('text/xml',CONTENTTYPE)>0 then
    begin
      xml:=true;
      getparams('');
      //responseheaders.values['content-type']:='text/xml';
      postdata:=(Asocket.RecvBufferStr(contlen,1000));
      //logwrite('XMLPARAMS:'+params.text+'!!!!!!!!!');
      //logwrite('XMLCONT:'+postdata+'!!!!!!!!!');
   end else
   if (pos('multipart',contenttype)>0) then
   begin
       try
       responseheaders.values['content-type']:='text/html';
       str:=contenttype;
       getmultiparams(contlen,asocket,str) ;
       getparams('');
       except on e:Exception do
          writeln('failed to read multipart data:'+e.Message);
       end;
    end
    else
    begin
     s:=Asocket.RecvBufferStr(contlen,1000);
     getparams(s);
    end;
   except logwrite('failed to read params');raise;   end;

   //params read
  i:=pos('?',uri);
  if i>1 then ext:=copy(uri,1,i-1) else ext:=uri;
  ext:=extractfileext(ext);
  ext:=lowercase(copy(ext,2,length(ext)-1));
  //ext :=extractdelimited(1,ext,['?','&']);
  mime:=g_xseuscfg.getmime(ext);
  //xseusserver.sessions.purgeoldsessions;
  //cookie:=_getcookie(requestheaders);
  //if pos('.htmi', uri)>0 then
  docookies;
  //if restfull then
   //getrest(contlen,asocket,str)
   //exit
  //else
  if not restfull then
  if _isxseus(ext)  then
  begin
  keepxseusalive:=false;
   //logwrite('(cookie:'+cookie+')');
    try
    try //doxeus
      //logshow('url'+uri);
      smem:=getheapstatus.totalallocated;
      //exit;
      {txseus(myxseus):=txseus.create(nil);
      if txseus(myxseus).init(uri,host,protocol,session.sestag,self) then //params,uploads);
      txseus(myxseus).Clear;
      logwrite('<li>xseusmemlost:'+floattostr(getheapstatus.totalallocated-smem));
      exit;}
      if not xseusserver.serverchunked then
      begin
        //t_keepbuff:=true;
         t_outbuffer:=tmemorystream.Create;
        //settextbuf(output,t_outbuffer);
        LOGWRITE('OUTBUFFER:'+INTTOSTR(T_OUTbuffer.SIZE));
        assignhtml(output);
      end  else
      begin
      //t_keepbuff:=false;
      assignhtml(output);

      end;
      //t_writehandler:=output;
      //logwrite('///NEWHEADS:'+responseheaders.text);
      //writeln('nogotoday');
      //logwrite('created xseus');
      //sleep(5000);
      if g_livesession<>nil then
       txseus(myxseus).docontinue
      else
      begin
      txseus(myxseus):=txseus.create(nil);
      if txseus(myxseus).init(uri,host,protocol,session.sestag,self) then //params,uploads);
      begin
        //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
        if xml then
        begin
         txseus(myxseus).htmlinited:=true;
        end else txseus(myxseus).htmlinited:=false;

        logwrite('inited xseus'+timetostr(now)+' ('+inttostr(id)+') for:'+uri);
        //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
        try
        //txseus(myxseus).c_inithtml;
        //txseus(myxseus).
        if not auth_checkauth(myxseus) then
        begin //redirect
          //statusline:='HTTP/1.1 302 FOUND';
          //sethe§ader('location','http://localhost:8001/notes/notes.htmi/login.htmi');//url+formst);
          redirect('','?login');
        end else

        /////////**********************
        writeln('<li>execute substo sapply');
        txseus(myxseus).dosubelements;
        /////////**********************
          //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
        //logwrite(uri+'!'+ext+'did:'+uri+'/mymem:'+inttostr(GetFPCHeapStatus.CurrHeapUsed)+'//'+inttostr(Int64(getheapstatus.totalallocated)));
        except  logwrite('fail:'+s);writecustomheaders('HTTP/1.1 200','text/html; charset=utf-8',-1); writeln('failed xseus.run');  end;
      end else
      begin
        writeln('<li>uri'+uri+' /file:');
        writeln('<li>failed xseus init:');

      end;
      end;
      try   //clear xseus
      if keepxseusalive then
      begin
      g_livesession:=self;
      //g_livesession:=nil; //to make sure not used yet

      end else
      begin
        //writeln(getheapstatus.totalallocated);
        //writeln(GetFPCHeapStatus.MaxHeapUsed);
        //logwrite('clear');
      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TEMPORARiLY comm out:
      txseus(myxseus).Clear;
      //logwrite('cleared');
      logwrite('freed:'+uri+'/mymem:'+inttostr(GetFPCHeapStatus.CurrHeapUsed));
      txseus(myxseus).free;
      //writeln('<li>memlost in connection:///////////////////'+floattostr(getheapstatus.totalallocated-smem));
      end;
     except   writeln('failed xseus.clear'); raise; end;
             //xseus cleared
   except logwrite('failed xseus thread');//raise;
   end;
   finally
   try
   if xseusserver.serverchunked then
   begin
       if not headerhasbeenwritten then writeln('No output from '+uri);
       Sock.SendString('0000'+crlf+crlf);
   end
   else begin logwrite('finishing Non-chunked');
    //t_keepbuff:=false;//writeln;
    ALLOut(t_outbuffer);
   end;
   logwrite('finished xseus-serving'+'/mymem:'+floattostr(getheapstatus.totalallocated-smem)+'/'+inttostr(GetFPCHeapStatus.CurrHeapUsed));
     except
   writeln('notok xseus thread');end;
     //xseus done
   end
   end
  else
  begin  //servefile
    logwrite('FILE ext:'+ext+'!!'+uri+'!!+/thread:'+inttostr(id)+'/mem:'+floattostr(getheapstatus.totalallocated));
    if ext='get' then uri:=copy(uri,1,length(uri)-4);
    // allow to get .htmi/xsi -files instead of running them
    myxseus:=nil;
    redirect('','notes.htmi');
    //servefile(mime,uri);
    logwrite('served file:'+uri+mime);
  end;
    //servefile;
  finally
   LOGwrite('closing-----------------------------------');
   if keepxseusalive=false then myxseus:=nil;
  for i:=0 to uploads.count-1 do
   tmemorystream(uploads.objects[i]).Free;
  uploads.clear;
  params.clear;
  requestheaders.free;
  responseheaders.free;
  //t_outbuffer.Free;
  end;
   //xseus cleared
  // logwrite('/closed:'+uri+'!!+/thread:'+inttostr(id)+'/mem:'+floattostr(getheapstatus.totalallocated-smem));

   //sock.closesocket;
   //sock.purge;
end;
destructor txseusserver.free;
var
  inif:string;i:integer;
begin
 //servs.free;
 logwrite('terminating');
// listener.listenersocket.closesocket;
 //listener.terminate;
 //WaitForThreadTerminate(listener.Handle,1000);
// killThread(listener.Handle);

 servs.free;
 try
 listener.terminate;
 listener.destroy;
 except logwrite('could not destroy listener');end;
 //logwrite('terminated listener');
 //listener.dofree;
 //inherited free;
 //listener.free;
 //logwrite('STOPPED');
 //listener.Free;
 logwrite('freed listener');
 //servs.free;
end;

constructor txseusserver.Create;
var
  inif:string;i:integer;
begin
  inherited create;
  ssl:=false;//true;//false; //some code is there, but still experimental
  //moved to below_ servs := tthreadpool.Create;
  sessions:=tsessions.create;
  defaultheaders:=tstringlist.create;
  inif := extractfiledir(ParamStr(0)) + g_ds + 'xseus.xsi';
  g_xseuscfg := txseusconfig.Create;
   //logwrite('INIF:'+inif);//+xseuscfg.config.xmlis);
  g_xseuscfg.get(INIF);
  sessions.sestimeout:=strtointdef(g_xseuscfg.sessiontimeout,15);
  //xseusformi.memolog('At');
  if g_xseuscfg.config.subs('chunked')='false' then serverchunked:=false else serverchunked:=true;
  //chunked:=false;
  servs := tthreadpool.Create;
  servs.threadcount:=strtointdef(g_xseuscfg.config.subs('threadcount'),6);//sorry not elegant to do it here
  servs.init;
  if serverchunked then
 logwrite('did create a xseusserver with inifile:'+inif+' running '+inttostr(servs.threadcount)+' threads, chunked')
  else
  logwrite('did create a xseusserver with inifile:'+inif+' running '+inttostr(servs.threadcount)+' threads, NOT chunked');
 end;

procedure txseusserver.run;
  begin
 //  ttextrec(output).mode:=fmclosed;
  logwrite('RUN server');
  logwrite('startlistener');
  listener:=tlistener.Create(true);
  listener.FreeOnTerminate := false;
  listener.start;
   end;
procedure tlistener.execute;
var
  aserverprocess: tserving;stimes:integer;port:string;
begin
 try
 stimes:=0;
 port:=g_xseuscfg.config.subs('port');
 if port='' then port:='8001';
 ListenerSocket := TTCPBlockSocket.Create;
 //listenersocket.SO_REUSEADDR:=true;
 ListenerSocket.CreateSocket;
 ListenerSocket.bind('0.0.0.0', port);
 logwrite('** STARTing LISTEN PORT:'+PORT);
 g_livesession:=nil;
 //exit;
 //ListenerSocket.setLinger(True, 20);
 Listenersocket.setLinger(true,1000);
 ListenerSocket.listen;
 logwrite('**  LISTENING PORT:'+PORT);
 //exit;
  repeat
     sleep(10);
     stimes:=stimes+1;
    //continue;
  //  if ListenerSocket.canread(20) then
    if (not Terminated) and (listenersocket.CanRead(1000))  then
    begin
    //  if g_livesession<>nil then aserverprocess:=g_livesession else
      logwrite('***************listernconnection:'+inttostr(stimes));
      aserverprocess := xseusserver.servs.obtain;
      if aserverprocess=nil then
      logwrite('NOconnection'+inttostr(xseusserver.servs.freeths.count));
//      aserverprocess.sock.RemoteSin:=listenersocket.remotesin;
       aserverprocess.Sock.Socket := ListenerSocket.accept;
      //aserverprocess.sock.setLinger(true,50);
      // aserverprocess.sock.Socket:=CliSock;
      //  LOGWRITE('ACCEPTED SOCKET'+aserverprocess.Sock.Socket.
      if xseusserver.ssl=true then
      begin
       aserverprocess.sock.SSL.CertificateFile:='/home/t/xseus/cert.pem';
       aserverprocess.sock.ssl.PrivateKeyFile:='/home/t/xseus/key.pem';
       aserverprocess.sock.ssl.CertCAFile:='/home/t/xseus/cacert.pem';
       aserverprocess.sock.SSLAcceptConnection;
       logwrite('SLLconnection');
       if aserverprocess.sock.Lasterror <> 0 then
       begin
          logwrite('HTTP.Sock.LastError :'+inttostr(aserverprocess.Sock.LastError)+ ' ; ' +aserverprocess.Sock.LastErrorDesc);
          logwrite('HTTPs.Sock.SSL.LastError :'+inttostr(aserverprocess.Sock.SSL.LastError)+ ' ; ' +aserverprocess.Sock.SSL.LastErrorDesc);
          Exit;
       end;
      end;
      aSERVERPROCESS.resume;
      logwrite('started connection'+inttostr(aserverprocess.id)+'/'+inttostr(tlist(xseusserver.servs.freeths).count)+'@'+timetostr(now));
    end
    else
    begin
      if stimes>100 then
      begin
      //logwrite('/mainthreadmem:'+floattostr(getheapstatus.totalallocated));
        stimes:=0;
        //xseusserver.sessions.purgeoldsessions;
      end;
      //bitofrest;
    end;
  until terminated;
  //listenersocket.closesocket;
  logwrite('termined');
  finally
  //logwrite('stop server');
  //xseusserver.servs.free;
  //xseusserver.free;
  //listenersocket.free;
  end;
  //ConnectionSocket.Free;
end;

initialization
//logwrite('initialization');
{  $i uusserv.lrs}
 // end;
end.


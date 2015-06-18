unit xseproxy;

{$MODE Delphi}

interface

uses
    {$IFDEF FPC}
  LCLIntf, LCLType, LMessages,
 	  {$ELSE}variants,
 	  {$ENDIF}
 Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
   // IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  //IdHTTPServer,IdContext,IdCookie,  IdException ,IdHTTPProxyServer,
  //idssl,
  //IdServerIOHandlerSocket,
  //IdServerIOHandlerSSLOpenSSL,
 //   sharemem,
 //indyapp,
  syncobjs, StdCtrls;
procedure lwrite(st:string);
{type
  Tproxyform = class(TForm)
    proxymemo: TMemo;
    procedure FormCreate(Sender: TObject);

  private
  public
  end;}
  type
    txseusproxy=class(tobject)
    server:tidhttpproxyserver;
    constructor create;
    procedure work(AContext: TIdContext);
    procedure DOwork(AContext: TIdHTTPProxyServerContext;
  var VStream: TStream);
    //(AContext: TIdHTTPPROXYSERVERContext;st:string;STR:TSTREAM);
   end;

var
 // proxyform: Tproxyform;
  xproxy:txseusproxy;
procedure createproxy;

implementation

uses xsserver;
{  $R *.lfm}
procedure lwrite(st:string);
begin
  //comment out if you want heavy debugging
       logwrite(st);
end;

constructor txseusproxy.create;
begin
 //server.onexecute :=work;
 //   SERVER.OnHTTPDocument(
end;

//procedure Tproxyform.FormCreate(Sender: TObject);
procedure createproxy;
begin
 try
  logwrite('STARTING THE PROXY AT PORT 5000');
 xproxy:=txseusproxy.create;
 xproxy.server:=tidhttpproxyserver.create;
   xproxy.SERVER.OnHTTPDocument:=xproxy.DOWORK;
 except
  logwrite('not working today');
 end;
 try
 Xproxy.server.Bindings.DefaultPort := 5000;
 xproxy.server.defaultport:=5000;
 xProxy.Server.DefaultTransferMode:=tmfullDocument;
 xproxy.server.active:=true;
 lwrite('proxy inited')
 except
  LWRITE('PROXY not inited');
 end;

end;
procedure txseusproxy.work(AContext: TIdContext);
    begin
      //  proxyform.proxymemo.lines.add('acontext.Connection.GetNamePath');
    end;
procedure txseusproxy.DOwork(AContext: TIdHTTPProxyServerContext;
  var VStream: TStream);
  var fs:tfilestream;
    begin
     try
      // acontext.data.InstanceSize
        // proxyform.proxymemo.lines.add('didcall');
        //proxyform.proxymemo.lines.add('xxx:'+inttostr(vstream.size));
        //fs:=tfilestream.Create('/home/t/xseus/proxy.log',fmCreate);
        fs:=tfilestream.Create(inidir+'proxy.log',fmCreate);
        //vstream.Seek(0,soFromBeginning);
        fs.CopyFrom(vstream,vstream.Size);
        //fs.write;
        //fs.Free;
        FreeAndNil(fs);
     finally
          //     proxyform.proxymemo.lines.add('didcall');

     end;
    end;
end.
{
***
Changes to idhttpproxyserver.pas:

capturing headers to string reads extra crlf to end of each, so gotta do
for i:=0 to lcontext.headers.count-1 do
 lcontext.headers[i]:=trimright(lcontext.headers[i]);

Writing streams to client does not work (puts out garbage), so gotta:
          SetString(ss, tmemorystream(lstream).memory, LSTREAM.SIZE);
          ADest.IOHandler.Write(tidbytes(cr+lf+ss),length(ss));
instead of      ADest.IOHandler.WriteLn;    ADest.IOHandler.Write(LStream);


Changed adelim-par in
LContext.Connection.IOHandler.Capture(LContext.Headers, cr+lf  , False);
from '' to cr+lf (in two places).
The real problem is in capture -> performcapture -> readln which should
strip of the linefeeds


****
Change in idcustomtcpserver TIdCustomTCPServer.Startup;
commented out the line
//Bindings.Add.IPVersion := Id_IPv6;


** change id idiohandler.pas , TIdIOHandler.ReadLn(
gotta set
atimeout:=1000;
instead of using default idtimeoutdefault =-1

Here may be some problems:
LTermPos := FInputBuffer.IndexOf(LTerm, LStartPos);
//>>LTermPos := FInputBuffer.IndexOf(LF, LStartPos);
THe former is the original, and now I reverted back to it.
However, previously I had seen it necessary to make the change.
Perhaps calling capture with cr+lf fixed that
A
          }

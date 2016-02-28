unit xsemisc;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
 {$DEFINE DELPHI}
{$ENDIF}
{ $H+}
 {$UNDEF INDY}
 {$DEFINE TIBURON}
{$M+}
interface
uses //sharemem,
xseglob,xsexml,                     //IdGlobal,
httpsend,
  blcksock,ssl_openssl,// synassl,
synautil,
//ssl_libssh2.pas,
{$IFNDEF windows}
Process,
 //-- LCLIntfvariants,
 	 {$else}

 	  //windows,
variants,    //shellapi,
{$ENDIF}
  SysUtils,strutils,dateutils,
  Classes,  //IdHTTP,
  typinfo,fileutil
  //IdSSLOpenSSL   ,IdComponent,IdHeaderList,
  //IdSMTP ,IdMessage,IdAttachmentFile,IdTCPClient,IdAttachment,IdAuthentication
  //generics.Collections
;
//var dd:tdictionary;
//procedure restartserver;
function _hyphenfi(w:string):ttag;
function _posany(parts,whole:string):integer;
function _dosort(slist:tlist;st:string): boolean;
procedure _testmem(tname:string);
//function copyfile(fn1,fn2:string;x:boolean):boolean;
function _gsub(what,towhat:string;var inwhat:string):string;
procedure _sub(what,towhat:string;var inwhat:string);
function StreamToString(aStream: TStream;sta,siz:integer): string;
function _listjson(ftag:ttag):ttag;
function _json(src:string):ttag;
function _ical(src:string):ttag;
function _getnum(var n:integer;st:string):boolean;
function _testrights(session:ttag;dir,role,by:string):boolean;
//function indyget(gurl:string):string;
//function indypost(server,fil,form,headers:string):string;
procedure _h1(st:string);
//function _wrap(str,width,indent:string):string;
function _wrap(str,indent:string;width:integer):string;
function _haveright(todir,fromdir,rig:string;xs:tobject):boolean;
function _ataghaveright(rigtag:ttag;fromdir,todir,rig:string):boolean;
procedure _cleancdata(acom,xform:ttag);
//ocedure _text2html(var res:tstringlist;txt:tstringlist;acom,xform:ttag);

function _indir(target,srcdir:string;xs:tobject;write:boolean):string;
function _indirs(st:string;appaths:ttag):string;
function _moveDir(fromdir,todir:string): boolean;
function _movefile(inf,outf:string):boolean;
procedure _readfile(fs:string; var ts:string);

procedure _tidylines(txt,resus:tstringlist);
function _texttokens(text:string;acom:ttag):ttag;
function _text2xml(atag:ttag;text:string):ttag;
//function _field2xml(atag,xform:ttag):ttag;
//nction _t2h(atag,xform,sel:ttag;xs:tobject;state:tobject):string;
procedure _writefile(fs,ts:string);
function _randomstring:string;
function _URLEncode(const Data: String): String;
function _UrlDecode(const EncodedStr: String): String;
//procedure _split(st,sep:string;stl:tstringlist);
function cut_li(s:string):integer;
function cut_rs(s:string):string;
function cut_ls(s:string):string;
function cut_par(s:string):string;
function _mapurltofile(url:string;mappings:ttag):string;
function _mapfiletourl(fil:string;mappings:ttag):string;
function _split(st,sep:string;stl:tstringlist):integer;
function _poslast(part,whole:string):integer;
function pos_reverse(part,whole:string):integer;
function _matches(x,y:string):boolean;
function _clean(st:string):string;
function _UNclean(st:string):string;
function cut_rse(s:string):string;
function launch(cmd, cmdline:string):string;
function launchprogram(FileName,cmdline:String; wait:boolean):string;

function WinExecAndWait32(FileName:String;
    wait:boolean):DWORD;
function fullcut_rs(s:string):string;
function vartodatetimex(ts:string):tdatetime;
function _strtodatetime(str:string):tdatetime;
function _getpathinfo(vari:pchar):string;
function _geturl(page,link:string):string;
function _newfile(pattern,ext:string):string;
procedure _listtolist(oldlist,alist:tlist;i:integer;par:ttag);
procedure _addattributes(atts:tstringlist;newatts:tstringlist;xs:tobject);
function _cdatavex(text:string):string;
Procedure _closeStdErr;
function _httppost(url,form:string;headers:tstringlist;post:boolean;var res:string):utf8string;
function _httpupload(url,filename:string;headers:tstringlist;post:boolean;var res:string):utf8string;
function _httphead(url:string;headers:tstringlist):ttag;
//indy function _httpspost(url,form:string;headers:tstringlist;post:boolean;var res:string;connections:tstringlist):string;
//         _httpspost(HTTP:TIDHTTP;url,server,fil,form,headers:string;post:boolean):string;

function _httpget(urli:string;wait:integer;acomatts:tstringlist):string;
function _httpsget(urli:string;wait:integer;acomatts:tstringlist):string;
function _tcpget(host,cmd,port:string):string;
function _WeekOfYear(ADate : TDateTime) : word;
function _unfold(st:string):string;
function _relpath(path,basepath:string):string;
function _getpath(st:string;sep:char):string;
function _getfield(fs:string;x:ttag):string;
procedure listwrite(t:ttag);
procedure listhtml(t:ttag;nocr:boolean);
function _normalizeurl(url,base:string):string;
//indy function _sendmail(mto,from,sub,msg,serv,attchs:string):boolean;
procedure _save(acom,xdata:ttag;ifile:string;xml:ttag);
procedure _error(s:string);
//indy function _emsgtoxml(msgfil,attachdir:string):ttag;
function _Encode64(const S: AnsiString): AnsiString;
function _Decode64(const cinline: String): String;
procedure _pokehtml(acom, xml: ttag; dir: string; xs: pointer);
function _quicksearch(needle,hay: string): integer;
function _IsFloat(S: String): Boolean;
function _Isinteger(S: String): Boolean;
function _testif(op, x1, x2: string; xs: pointer):boolean;//; acom: ttag): boolean;

  function _filetostr(fname:string):string;
  function regtoele(exp,str:string):ttag;
  function _NormalizeWhiteSpace(const Strg: string; doTrim: boolean): string;

procedure _synmail(mfrom,mto,subj,smtphost:string;msg:tstrings);
function _fetch(tofind:string;var findin:string):string;

//var turhahttp:tidhttp;
type tasorter=class(tobject) //record
 public
  orde:integer;numcomp:boolean;
end;
ttagsorter=class(tobject)
 recs:tstringlist;
 //function compare(t1,t2:ttag):boolean;
 constructor create(st:string);
 destructor free;
end; //pasorter=^tasorter;

implementation
uses math,
//IdException ,IdSSLOpenSSLHeaders,
//xsegui,
xsexse,//xsesta,
smtpsend,
xseexp,
xsereg;//idmessage,idmessageparts;

const konsonantit ='bcdfghjklmnpqrstvxz'; vokaalit='aeiouyäö';
function _hyphenfi(w:string):ttag;
var i,len,vpos:integer;hy,vocs:string;ch,chn:char;lasttag:ttag;
begin
 result:=ttag.create;
 result.vari:=w;
 len:=length(w);
 hy:=w[len];
 for i:=len-1 downto 1 do
 begin
  ch:=w[i];chn:=w[i+1];
  if (pos(ch,konsonantit)>0)  and (pos(chn,konsonantit)<1) then //and (i>2) then
  begin
     lasttag:=result.addsubtag(ch,hy);hy:='';
 end ELSE
  HY:=ch+hy;
 end;
  if hy<>'' then
  if pos(hy[1],vokaalit)>0 then result.addsubtag('',hy)
  else lasttag.vari:=hy+lasttag.vari;
{  if (pos(chn,konsonantit)>0) then
  begin
   if (pos(w[1],konsonantit)>0) then
    lasttag:=result.addsubtag(w[1]+chn,hy)
   else
   begin
    lasttag:=result.addsubtag(w[1]+chn,hy);

    lasttag:=result.addsubtag('',hy);

   end;

  end else
  }
  // hy:=w[1]+hy;
{   vpos:=_posany(vokaalit,hy);
   lasttag:=result.addsubtag('end',hy+'!'+inttostr(vpos));
   if vpos>1 then  //started with consonant
   begin
     lasttag:=result.addsubtag(copy(hy,1,vpos-1),copy(hy,vpos,9999))
   end
   else
   begin
    vpos:=_posany(konsonantit,hy);
    vocs:=copy(hy,1,vpos-1);hy:=copy(hy,vpos,9999);
    lasttag:=result.addsubtag('XXX',hy+'!'+inttostr(vpos));
    lasttag:=result.addsubtag(copy(hy,1,vpos),copy(hy,vpos,9999));
    lasttag:=result.addsubtag('',vocs);


   end;
   //lasttag.setatt('k',copy(w[1]+hy,1,vpos-1));
   //lasttag.setatt('v',copy(w[1]+hy,vpos,999));
    //ELSE

end; }

end;

function _getnum(var n:integer;st:string):boolean;
begin
 try
    n:=strtoint(st);result:=true;
 except
    result:=false;
 end;
end;
function _posany(parts,whole:string):integer;
{D: position of a @part in @whole - note: incorrect results for utf
}
var i:integer;
begin
  i:=1;
  while i<=length(whole) do
    if  pos(whole[i],parts)>0 then break
    else i:=i+1;
  if i>length(whole) then result:=0 else result:=i;

end;

function _fetch(tofind:string;var findin:string):string;
var posi:integer;
begin
 posi:=pos(tofind,findin);
 if posi<1 then result:=findin
 else
 begin
  result:=copy(findin,1,posi-1);
  findin:=copy(findin,posi+length(tofind), length(findin));
 end;
end;
procedure _synmail(mfrom,mto,subj,smtphost:string;msg:tstrings);
//var mailer:
begin
try
logwrite('smtpsend.sendto(from:'+''+mfrom+'/to:'+mto+'/subj:'+subj+'/host:'+ smtphost+'/msg:'+msg.text);
smtpsend.sendto(mfrom,mto,subj, smtphost,msg);
except writeln('failed_to_send_mail');end;
 //SendTo(const MailFrom, MailTo, Subject, SMTPHost: string; const MailData: TStrings): Boolean;
end;

function StreamToString(aStream: TStream;sta,siz:integer): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
  try
   if siz<0 then siz:=astream.Size;
    SS := TStringStream.Create('');
    try
      aStream.Position := sta;
      SS.CopyFrom(aStream, siz);
      Result := SS.DataString;
    finally
      SS.Free;
    end;
           except on e:Exception do
          writeln(e.Message);
       end;
  end else
  begin
    Result := '';
  end;
end;

function _tcpget(host,cmd,port:string):string;
var FSock: TTCPBlockSocket;st:string;
procedure logerr(st:string);
 begin
    if FSock.LastError<>0 then logwrite('faled tcpget '+st+fsock.geterrordesc(FSock.LastError));
 end;
begin
  result:='';
  try
  fsock := TTCPBlockSocket.Create;
  logerr('create');
  FSock.Bind(canyhost, cAnyPort);
  logerr('bind');
  FSock.Connect('localhost', '6500');
  logerr('');

  FSock.SendString('hellou'+crlf);
  logerr('send');
  result:=fsock.RecvString(7000);
  logerr('recv');
  FSock.CloseSocket;
  finally
    FSock.CloseSocket;
    logerr('close');
    fsock.Free;
    logerr('free');
  end;

end;
function _getheader(heads:tstringlist;val:string):string;
var i:integer;
begin
result:='';
for i:=0 to heads.count-1 do
 if pos(val, lowercase(heads[i]))=1 then result:=TRIM(copy(heads[i],pos(':',heads[i])+1,9999));
end;

function _httpget(urli:string;wait:integer;acomatts:tstringlist):string;
 var HTTP:THTTPSend;Resultb:boolean;st:string;i:integer;
 begin
  HTTP := THTTPSend.Create;
  //writeln('<li>GET', urli);
  try
  //SynHttp.HTTPMethod('GET', 'https://www.google.com');  try
    //http.UserName:='';

   if acomatts<>nil then
   begin
    HTTP.UserName:=acomatts.values['user'];
    HTTP.Password:=acomatts.values['pass'];
   end;
    //http.cookies.add('Horde=od56ucdeoih46eirms0c5h36t7; path=/horde; domain=webmail.helsinki.fi; secure; HttpOnly');
    //writeln('HTTPGET:'+urli);//+'!'+http.username+'/'+http.password+'!');
    try
    Resultb := HTTP.HTTPMethod('GET', urli);
    except    writeln('<li>nohttp:'+urli);
      writeln('HTTP.Sock.LastError :',HTTP.Sock.LastError, ' ; ' ,HTTP.Sock.LastErrorDesc);
    end;

    if Resultb then
    begin
      try
       if (http.resultcode DIV 100)=3 then begin ST:=_getheader(http.headers,'location');//writeln('<h2>redirect to.'+ST,'.</h2><pre>--',http.headers.text,'--</pre>');

       HTTP := THTTPSend.Create;
       Resultb := HTTP.HTTPMethod('GET', ST);
      end;

      // writeln('<li>got:'+urli,http.document.Size);
      SetString(result, PChar(http.document.memory), http.document.Size);
      //writeln('GOTURL:',http.resultcode,'<xmp>',result+'!!!</xmp>',http.document.Size);// ReadStrFromStream(HTTP.Document,HTTP.Document.Size))
      except writeln('failed http!get');
        writeln('HTTP.Sock.LastError :',HTTP.Sock.LastError, ' ; ' ,HTTP.Sock.LastErrorDesc);
        //writeln('HTTP.Sock.SSL.LastError :',HTTP.Sock.SSL.LastError, ' ; ' ,HTTP.Sock.SSL.LastErrorDesc);

      end;
    end
    else
      begin
      writeln('<li>nogot:'+urli+'!');
      end;
  finally
    HTTP.Free;
  end;
end  ;
{type thttps=class(thttpsend)
 function verf(sender:tobject):boolean;
 function connect(sender:tobject):boolean;
  constructor create;
end;
  constructor thttps.create;
  begin
   inherited create;
   //sock.ssl.doconnect:=con:
  end;
  function thttps.verf(sender:tobject):boolean;
  begin
    writeln('XXXXXXXXXQQQQQQQQQQQQQQQQä');
  end;
  function thttps.connect(sender:tobject):boolean;
  begin
    writeln('<li>DODODODCOCOCOCOCOC');
    //inherited connect;
    writeln('<li>DIDICOCOCOCOCOC');
  end;
}

function _httpsget(urli:string;wait:integer;acomatts:tstringlist):string;
 var HTTP:THTTPSend;Resultb:boolean;st:string;i:integer;
 begin
  HTTP := THTTPSend.Create;
  //http.Sock.SSL.OnVerifyCert:=mytestmethod; this did not get called
  HTTP.Protocol:='1.1' ;
  //Http.Sock.CreateWithSSL(TSSLOpenSSL);
  Http.Sock.SSL.CertificateFile:='/home/t/xseus/cert.pem';
  Http.Sock.SSL.PrivatekeyFile:='/home/t/xseus/key.pem';
  HTTP.Sock.SSL.VerifyCert:=true;
  HTTP.Sock.SSL.CertCAFile:='/home/t/xseus/cacert.pem';
  //HTTP.Sock.SSL.OnVerifyCert:=VerifyCert;
  //HTTP.Sock.SSL.CertCAFile:='/home/t/xseus/cert.pem';
  Http.Sock.SSLDoConnect;
         //https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements         //if http.sock.lasterror=SSL_ERROR_ZERO_RETURN then

  //urli:=  'https://www.openssl.org/';
  writeln('<li>1)HTTPS:'+urli+'!'+HTTP.Sock.SSL.GetPeerName+'!'+HTTP.Sock.SSL.Certificate+'/'+HTTP.Sock.SSL.GetCertInfo+'!');

  try
    //http.UserName:='';
   if acomatts<>nil then
   begin
    //HTTP.UserName:=acomatts.values['user'];
    //HTTP.Password:=acomatts.values['pass'];
   end;
    //http.cookies.add('Horde=od56ucdeoih46eirms0c5h36t7; path=/horde; domain=webmail.helsinki.fi; secure; HttpOnly');
    //Resultb := HTTP.HTTPMethod('GET', urli);
    Resultb := HTTP.HTTPMethod('GET', urli);
    //writeln('<li>2)HTTPS:'+urli+'!'+HTTP.Sock.SSL.GetPeerName+'!'+http.username+'/'+http.password+'!');

    if Resultb then
    begin
      try
      SetString(result, PChar(http.document.memory), http.document.Size);
      //writeln(st);// ReadStrFromStream(HTTP.Document,HTTP.Document.Size))
      except writeln('failed http!get');end;
    end
    else
      begin
        writeln('<li>HTTP.Sock.LastError :',HTTP.Sock.LastError, ' ; ' ,HTTP.Sock.LastErrorDesc,'/desc:',http.sock.GetErrorDescEx);
        writeln('<li>HTTP.Sock.SSL.LastError :',HTTP.Sock.SSL.LastError, ' ; ' ,HTTP.Sock.SSL.LastErrorDesc);
              end;
  finally
    HTTP.Free;
  end;
end  ;

 function syn_httpget(urli:string;wait:integer;acomatts:tstringlist):string;
var server,fil,res:string;
begin
// if pos('http://',urli)=1 then
//  urli:=copy(urli,8,9999);
 if pos('/',urli)>0 then
 begin
   server:=copy(urli,1,pos('/',urli)-1);
   fil:=copy(urli,pos('/',urli),9999);
 end
 else
 begin
   server:=urli;
   fil:='';
 end;
 //writeln('<li>szsz:'+server,' f:'+fil,' u:'+urli);
 //result:=_httppost(urli+server+fil,'',acom.attributes,false);
 result:=_httppost(urli,'',acomatts,false,res);
 //writeln('<xmp>r:'+result+'</xmp>');

end;



function _httphead(url:string;headers:tstringlist):ttag;
begin end;

function _httppost(url,form:string;headers:tstringlist;post:boolean;var res:string):utf8string;
 var
  aHTTP: THTTPSend;
begin
  aHTTP := THTTPSend.Create;
  //ahttp.headers:=headers;
  try
    //StrToStream(aHTTP.Document,form);
  //ahttp.document.writeansistring(form);
     //writeln('<li>tryxmlrpc:'+url+'!<xmp>'+form+'</xmp><hr/>');
    aHTTP.MimeType := 'text/xml';
    ahttp.document.writebuffer(form[1],length(form));
    logwrite('*****************GETXML:'+result);
    if aHTTP.HTTPMethod('POST', url) then
    begin
      result:=Streamtostring(aHTTP.Document,0,ahttp.document.size);
      aHTTP.Document.Position := 0;
      logwrite('*****************gotxml:'+result);
    end else logwrite('Can not POST');
  finally
    aHTTP.Free;
  end;
end;
function _httpupload(url,filename:string;headers:tstringlist;post:boolean;var res:string):utf8string;
 var
  aHTTP: THTTPSend;cnt:tfilestream;st:string;len:integer;
begin
  aHTTP := THTTPSend.Create;
  //ahttp.headers:=headers;
  try
    //StrToStream(aHTTP.Document,form);
  //ahttp.document.writeansistring(form);
     //writeln('<li>tryxmlrpc:'+url+'!<xmp>'+form+'</xmp><hr/>');
   // cnt:=tfilestream.Create(filename,fmopenread);
    try
    ahttp.document.LoadFromFile(filename);
      //ahttp.document.WriteAnsiString('kukkuluuruu');
    //  WriteStrToStream(aHTTP.Document,      crlf+CRLF +'hellothere'+crlf+crlf);
    except writeln('<li>failed to load file:'+filename);end;
   { len:=ahttp.document.Size;
     SetLength(st, len);
    ahttp.document.ReadBuffer(st[1], len);
    writeln('<li>sending'+string(st));
    aHTTP.MimeType := 'application/octet-stream';
    exit;}
    aHTTP.MimeType := 'application/octet-stream';
    writeln('<li>sending:'+filename+'/to:'+url);
    logwrite('<li>httpupload:'+filename+'/to:'+url);
    ahttp.Headers.add('xfilename: '+extractfilename(filename));
    if aHTTP.HTTPMethod('POST', url) then
    begin
     logwrite('<li>httpuploadPOSTED:'+filename+'/to:'+url);
      result:=Streamtostring(aHTTP.Document,0,ahttp.document.size);
      aHTTP.Document.Position := 0;
      logwrite('<li>httpupload:'+filename+'/to:'+url);
    end else logwrite('Can not POST'+inttostr(aHTTP.ResultCode)+ahttp.resultstring  );
  finally
    aHTTP.Free;
  end;
end;


{$IFDEF WININET}
function _httpget(urli:string;wait:integer;acom:ttag):string;

var
  Buffer: array[0 ..1023] of char;
  url: array[0..1023] of char;
  nRead: Cardinal;
  strRead : string;
  nBegin, nEnd,counter: integer;
  Size,Index: dword;


  Internet: HInternet;
  HttpHandle: HInternet;
  HttpRequest: HInternet;
  hopenhandle,
  Hrequrl: HInternet;
  sheaders:pchar;stime:tdatetime;
begin
 stime:=now;
 result:='';
  strpcopy(url,urli);
 hOpenHandle := InternetOpen ('Findweb', INTERNET_OPEN_TYPE_PRECONFIG, nil,
nil, 0);if acom.att('ifmodifiedsince')<>'' then
begin
   getmem(sheaders,1000);
  sheaders:=pchar(acom.att('ifmodifiedsince'));HttpAddRequestHeaders(hopenhandle, sHeaders, 1000,
            HTTP_ADDREQ_FLAG_ADD Or HTTP_ADDREQ_FLAG_REPLACE);
end;
 counter:=0;
 try
    hReqUrl := InternetOpenURL(hOpenHandle, url, nil,0,0,0);
   try
    if wait<>0 then
      repeat
        counter:=counter+1;
        if wait>0 then
        if counter>wait then break;
        InternetReadFile(hReqUrl, @Buffer, sizeof(Buffer), nRead);
        if nread>0 then result:=result+copy(string(buffer),1,nread);
        until nRead = 0;
    finally
   InternetCloseHandle(hReqUrl);
    end;
  finally
    InternetCloseHandle(hReqUrl);
    end;

 end;
{$ENDIF}


procedure SkipWhiteSpace(const Strg: string; var CharPos: cardinal);
var
  Len: cardinal;
begin
  Len := Length(Strg);
  while (CharPos <= Len) and (Strg[CharPos] in WhiteSpaces) do
    Inc(CharPos);
end;



function _NormalizeWhiteSpace(const Strg: string; doTrim: boolean): string;
var
  StrIndx, ResIndx: cardinal;
  InChar: char;
begin
  SetLength(Result, Length(Strg));
  if Length(Strg) = 0 then
    Exit;
  StrIndx := 1;
  ResIndx := 0;
  if doTrim then
    SkipWhiteSpace(Strg, StrIndx);
  while StrIndx <= cardinal(Length(Strg)) do
  begin
    Inc(ResIndx);
    InChar := Strg[StrIndx];
    if InChar in WhiteSpaces then
    begin
      Result[ResIndx] := ' ';
      SkipWhiteSpace(Strg, StrIndx);
    end
    else
    begin
      Result[ResIndx] := InChar;
      Inc(StrIndx);
    end;
  end;
  if doTrim and (Result[ResIndx] = ' ') then
    Dec(ResIndx);
  SetLength(Result, ResIndx);
end;


function _testif(op, x1, x2: string; xs: pointer):boolean;//; acom: ttag): boolean;

  function _s(x: string): integer;
  begin
    Result := strtointdef(x, 0);
  end;

var
  ok: boolean;
  apu: string;
  i, apui: integer;
  neg: boolean;
begin
// writeln('if x1?',x1,'x2=',x2,'op=',op);
  try
    neg := False;
    if pos('-', op) = 1 then
    begin
      Delete(op, 1, 1);
      neg := True;
    end;
    ok := False;
    Result := False;
    try
     { if op = 'rights' then
      begin
        ok := _testrights(xs.xx_session, _ubstitute(acom.att('dir'), xs),
          _ubstitute(acom.att('role'), xs), _ubstitute(
          acom.att('domain'), xs));
        if neg then
          Result := not ok
        else
          Result := ok;

        //writeln(ok,'_______________________________________________',result);
        exit;
      end;
    except
      writeln('failed to test rights');//listwrite(acom);
    end;
    }
    finally
    end;
{    try
      x1 := _ubstitute(x1, xs);
      x2 := _ubstitute(x2, xs);
      //ok:=true;result:=true;exit;
    except
      writeln('<li>fail test:', op, x1, x2);
    end;
}
    if (op = 'eq') or (op = '') then
    begin
      try
        ok := x1 = x2;
        // writeln('xtest:',ok,x1,'=',x2,'!',neg);
      except
        writeln('eq failed');
      end;
    end;
    if (op = 'isnum') then
    begin
      try
        //writeln('Isnum?',x1);
        apui := StrToInt(x1);
        ok := True;
      except
        ok := False;
        //writeln(ok);
        ;
      end;
      //writeln(ok);
    end;
    if (op = 'match') or (op = 'matches') then
    begin
      try
        ok := _matches(x1, x2);
      except
        writeln('eq failed');
      end;
    end;
    if op = 'ne' then
    begin
      ok := (x1) <> (x2);
      //writeln('xtest:',ok,x1,'<>',x2,'!',neg);
    end;
    if op = 'agt' then
      ok := (x1) > (x2);
    if op = 'gt' then
      ok := _s(x1) > _s(x2);
    if op = 'alt' then
      ok := (x1) < (x2);
    if op = 'lt' then
      ok := _s(x1) < _s(x2);
    if op = 'lte' then
      ok := _s(x1) <= _s(x2);
    if op = 'alte' then
      ok := (x1) <= (x2);
    if op = 'gte' then
      ok := _s(x1) >= _s(x2);
    if op = 'agte' then
      ok := (x1) >= (x2);
    if op = 'contains' then
    begin
      ok := pos(x2, x1) > 0;
    end;
    if op = 'hasword' then
    begin
      apu := '';
      for i := 1 to length(x1) do
        if pos(x1[i], whitespace + ',:;.') = 1 then
          apu := ''
        else
        if apu <> x2 then
          apu := apu + x1[i]
        else
        if i = length(x1) then
          ok := True
        else
        if pos(x1[i + 1], whitespace + ',:;.') = 1 then
        begin
          ok := True;
          break;
        end
        else
          apu := apu + x1[i];
    end;
    if op = 'fileexists' then
    begin
      //--ok:=FileExistsUTF8(x1); { *Converted from FileExists*  }
      ok := FileExists(x1); { *Converted from FileExists*  }
      // writeln('fileext:',x1,ok);
    end;
    if op = 'direxists' then
    begin
      //--ok:=DirectoryExistsUTF8(x1); { *Converted from DirectoryExists*  }
      ok := DirectoryExists(x1); { *Converted from DirectoryExists*  }
    end;
    if op = 'renamefile' then
    begin
      //--ok:=RenameFileUTF8(_indir(x1, xs.odir); { *Converted from RenameFile*  }
      ok := renamefile(_indir(x1, txseus(xs).x_objectdir, xs, False), _indir(x2, txseus(xs).x_objectdir, xs, False));
      //--ok:=renamefile(_indir(x1,xs.odir,false,xs),_indir(x2,xs.odir,false,xs));
      //-- strange .. it could not have worked with params in that order,....
    end;
    if op = 'md' then
    begin
      //--ok:=CreateDirUTF8(x1); { *Converted from CreateDir*  }
      ok := CreateDir(x1); { *Converted from CreateDir*  }
      //writeln('<li>md:',_indir(x1,xs.odir,false,xs),ok);
    end;
    if op = 'movefile' then
    begin
      ok := _movefile((_indir(x1, txseus(xs).x_objectdir, txseus(xs), False)), (_indir(x2, txseus(xs).x_objectdir, txseus(xs), True)));
    end;
    if neg then
      Result := not ok
    else
      Result := ok;
    //writeln('<li>tested:'+op,result);
  except
    writeln('failed in _test');
    //listwrite(acom);
  end;
  //writeln('didtest', result);
end;

function regtoele(exp,str:string):ttag;
{D: regular expression match

-uses: Andrey V. Sorokin's regexp library
-used by xse:from (only command, not attribute)
 }
var
r:tregexpr;i,j,mati:integer;
 reslist:tstringlist;resu:string;
 restag,ares:ttag;
begin
 //writeln('regexp split;'+str);
 //writeln('REGEX:',  exp);
 //exit;
 restag:=ttag.create;
 r := TRegExpr.Create;
// mati:=strtointdef(p_match,1)-1;
  try
     r.Expression := exp;
     if r.Exec (str) then
     begin
     //writeln('subex:',r.subExprMatchCount);
      REPEAT

            //writeln('<li>ahit:',r.match[0],'</li>');
            if r.match[0]<>'' then
            ares:=restag.addsubtag('hit',r.Match[0]);
            for j:=1 to  r.SubExprMatchCount do
            begin
             IF R.match[j]<>'' then
               ares.addsubtag('subhit',r.match[j]);
            end;
      UNTIL not r.ExecNext;
      end;
        result:=restag;
        //writeln('....<xmp>',restag.xmlis,'</xmp>');
    finally r.Free;
   end;
end;


function _IsInteger(S: String): Boolean;
begin
  try
    Result := True;
    StrToInt(S);
  except on E: EConvertError do
    Result := False;
  end;
end;

function _IsFloat(S: String): Boolean;
begin
  try
    Result := True;
    StrToFloat(S);
  except on E: EConvertError do
    Result := False;
  end;
end;

function _filetostr(fname:string):string;
var stf:tfilestream;sts:tstringstream;i:integer;
begin
   if fileexists(fname) then
   begin
     try
     stf:=tfilestream.create(fname,fmopenread);
      //for i:=0 to sts.length do
     SetLength(result, stf.Size);
     stf.Read(PChar(result)^, stf.Size);
     //result:=
     // if pos('inon',fname)>0 then writeln('didfiletostr:!!!!!!!!!<xmp>',result,'</xmp>');
     stf.free;
     except writeln('<li>Failed to read file '+fname);end;
   end else result:='';
end;

function _quicksearch(needle,hay: string): integer;
     var i, j, k, m, n: integer;
         skip: array [0..256] of integer;
         found: boolean;
     begin
       found := FALSE; result := 0;

       m := length(needle);
       if m=0 then exit;
       n := length(hay);
       if n<1000 then begin
            result := pos(needle,hay); exit; end;
       if n<m then exit;
       for k:=0 to 256 do skip[k] := m;
       for k:=1 to m-1 do     skip[ord(needle[k])] := m-k;

       k := m;  n := length(hay);
       while not found and (k <= n) do begin
            i := k; j := m;
            while (j >= 1) do
                 if hay[i] <> needle[j] then j := -1
                 else begin
                      j := j-1;  i := i-1; end;
            if j = 0 then begin
                 result := i+1; found := TRUE;  end;
            k := k + skip[ord(hay[k])];
            //write(hay[k]);
            end;
       end;


{$IFDEF FPC}
function GetEnvironmentStrings:pchar;
begin
  writeln('GetEnvironmentStrings; not defined in linux');
end;

{$ENDIF}
procedure _testmem(tname:string);
var turhatag:ttag;
begin
   turhatag:=ttag.create;
   turhatag.vari:=tname;
   //create an uncleanable element to see in testmem-state how it
   //is located in relation to other, unintentionally uncleanable elements
end;
{function copyfile(fn1,fn2:string;x:boolean):boolean;
begin
  writeln('//!! COPYFILE NOT IMPLEMENTED IN LINUX');
end;
}
function _Decode64(const cinline: string): string;
//function DecodeBase64(const CinLine: string): string;
const
  RESULT_ERROR = -2;
var
  inLineIndex: Integer;
  c: Char;
  x: SmallInt;
  c4: Word;
  StoredC4: array[0..3] of SmallInt;
  InLineLength: Integer;
begin
  Result := '';
  inLineIndex := 1;
  c4 := 0;
  InLineLength := Length(CinLine);

  while inLineIndex <= InLineLength do
  begin
    while (inLineIndex <= InLineLength) and (c4 < 4) do
    begin
      c := CinLine[inLineIndex];
      case c of
        '+'     : x := 62;
        '/'     : x := 63;
        '0'..'9': x := Ord(c) - (Ord('0')-52);
        '='     : x := -1;
        'A'..'Z': x := Ord(c) - Ord('A');
        'a'..'z': x := Ord(c) - (Ord('a')-26);
      else
        x := RESULT_ERROR;
      end;
      if x <> RESULT_ERROR then
      begin
        StoredC4[c4] := x;
        Inc(c4);
      end;
      Inc(inLineIndex);
    end;

    if c4 = 4 then
    begin
      c4 := 0;
      Result := Result + Char((StoredC4[0] shl 2) or (StoredC4[1] shr 4));
      if StoredC4[2] = -1 then Exit;
      Result := Result + Char((StoredC4[1] shl 4) or (StoredC4[2] shr 2));
      if StoredC4[3] = -1 then Exit;
      Result := Result + Char((StoredC4[2] shl 6) or (StoredC4[3]));
    end;
  end;
end;

function _xxDecode64(const S: String): String;
const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

  var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
  //s:string;
begin
 try
  Result := '';


  writeln('base64:<xmp>'+s+'</xmp><hr/>');
  a := 0;
  b := 0;
  for i := 1 to Length(s) do
  begin
    x := Pos(s[i], codes64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      Exit;
  end;
  finally
  writeln('base64:'+s+'=<xmp>'+result+'</xmp>');
end;

end;


function _Encode64(const S: AnsiString): AnsiString;
const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(s) do
  begin
    x := Ord(s[i]);
    b := b * 256 + x;
    a := a + 8;
    while a >= 6 do
    begin
      a := a - 6;
      x := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + Codes64[x + 1];
    end;
  end;
  if a > 0 then
  begin
    x := b shl (6 - a);
    Result := Result + Codes64[x + 1];
  end;
end;
// procedure TFrmPreview.IDMESSAGE_EXTRACT_INFO(Mensagem: TIdMessage);
// var
// _a: Integer;
// DuplicatedBody: Boolean;
// aFileName: String;


procedure _error(s:string);
begin
  writeln(s);
end;


procedure _save(acom,xdata:ttag;ifile:string;xml:ttag);
var x:ttag;  fn,fnname,fnext,fnpath,apufn,head:string;bus,i:integer;p1,p2:array[0 ..1023] of char;
ocrit,IND:boolean;
begin
  try
  fn:=acom.att('outfile');
  if fn='' then  fn:=acom.att('file');
  if fn='' then  fn:=ifile;
  if fn='' then begin
   _error('Could not save - no filename given');
   exit;
  end;
  fnname:=extractfilename(fn);
  fnext:=extractfileext(fn);
  fnname:=copy(fnname,1,length(fnname)-length(fnext));
  fnpath:=extractfilepath(fn);
  try
     begin
       bus:=strtointdef(acom.att('backups'),3);
       if FileExists(fn+'_'+inttostr(bus)) { *Converted from FileExists*  } then
       begin
         if now-filedatetodatetime(FileAge(fn+'_'+inttostr(bus)) { *Converted from FileAge*  })>1 then
         begin
          apufn:=fn+'_'+inttostr(bus);
          strpcopy(p1,fn);
          apufn:=fn+'_old';
          strpcopy(p2,apufn);
          //copyfile('a','b');
          copyfile(p1,p2,false);end;
         if acom.att('extension')='same' then
            DeleteFile(fnpath+fnname+'_'+inttostr(bus)+fnext) { *Converted from DeleteFile*  }
         else
         DeleteFile(fn+'_'+inttostr(bus)); { *Converted from DeleteFile*  }
       end;
       for i:=bus-1 downto 1 do
       begin
         if acom.att('extension')='same' then
         begin
            RenameFile(fnpath+fnname+'_'+inttostr(i)+fnext, fnpath+fnname+'_'+inttostr(i+1)+fnext); { *Converted from RenameFile*  }
            writeln('<li>RENAME:'+fnpath+fnname+'_'+inttostr(i)+fnext,
            '<br/>',fnpath+fnname+'_'+inttostr(i+1)+fnext);

         end
         else
            RenameFile(fn+'_'+inttostr(i), fn+'_'+inttostr(i+1)); { *Converted from RenameFile*  }
            end;
         if acom.att('extension')='same' then
         begin
            RenameFile(fn, fnpath+fnname+'_1'+fnext); { *Converted from RenameFile*  }
           writeln('<li>ORIGINal:',fn,' to: ', fnpath+fnname+'_1'+fnext);
         end
         else
          RenameFile(fn, fn+'_1'); { *Converted from RenameFile*  }

     end;
  except writeln('failed backups');end;
     if acom.att('text')<>'' then
     begin
       _writefile(fn,acom.att('text'));
       end
     else
     if acom.att('element')='' then
     x:=xdata else
     x:=xml.subt(acom.att('element'));
     head:=acom.att('header');
     try
      //writeln('<li>trysavefile:'+fn);

      //ocrit:=myxs.critical;
      //myxs.critical:=true;
       ind:=false;
     try
      if acom.att('format')='xmlis' then ind:=true else
      if pos('xmlis', head)>0 then ind:=true else
      if extractfileext(fn)='.htmi' then ind:=true;
      if acom.att('format')='xml' then ind:=false;

      if ind then
      x.savetofileind(fn,true,head,acom.att('compact')='true')
      else
      begin
        if acom.att('xml')<>'' then
         x.saveeletofile(fn,true,head,'  ',acom.att('compact')='true',acom.att('entities')='true')
         else
        x.saveeletofile(fn,false,head,'  ',acom.att('compact')='true',acom.att('entities')='true');
      end;
      except writeln('<li>failedsavefile:'+fn);end;
     finally //myxs.critical:=ocrit;
     end;
      //writeln('<h1>x.savetofile(',fn,false,'',acom.att('element'),'</h1>');
      //listwrite(x);

  except
     writeln('<li>failedtosavefile:'+fn+'</li>');
  end;
end;



procedure listhtml(t:ttag;nocr:boolean);
var sl:tstringlist;i:integer; cr:string;
begin
 if t=nil then exit;
 if nocr then cr:='' else cr:=crlf;
 try
  if t=nil then exit;
  sl:=tstringlist.create;
  if nocr then t.list('',sl)
  else
   t.list('  ',sl);
  except writeln('Failed to list html');raise;end;
 for i:=0 to sl.count-1 do
  write(sl[i]+cr);


 sl.clear;sl.free;
end;
function _wrap(str,indent:string;width:integer):string;
var i,linelen:integer;ch:char;
begin
 //writeln('<xmp>----'+str+'</xmp>');
 //wid:=strtointdef(width,60);
 //ind:=copy('                                         ',1,strtointdef(indent,0));
 result:=indent;  //or ''?
 linelen:=0;
 for I := 1 to length(str) do
 begin
  ch:=str[i];
   if (ch=^J) then CONTINUE;//ch:=' ';
   if (ch=^M) then
   begin
     result:=result+^M^J;//+''+indent+^M^J+indent;
     linelen:=0;
   end
   else
   if (linelen>width) and (ch=' ')
   then
   begin
     result:=result+^M^J+indent;linelen:=0;
   end
   else result:=result+ch;
   linelen:=linelen+1;
 end;
end;


procedure listwrite(t:ttag);
begin
 if t=nil then exit;
 writeln('TAG:'+t.vari+'<xmp>'+t.listraw);
 //listhtml(t,false);
 //t.listraw;
 writeln('</xmp><hr>');
end;


function _getfield(fs:string;x:ttag):string;
var fname,xname,startpart,lastpart,att:string;xx:ttag;
 p,i:integer;
begin
 fname:=copy(fs,2,length(fs));
   if pos('/@',fname)>0 then
   begin
     att:=copy(fname,pos('/@',fname)+2,length(fname));
     fname:=copy(fname,1,pos('/@',fname)-1);
     xx:=x.subt(fname);
     //result:=xx.attributes.values[att];
     result:=xx.att(att);
   end
   else
     result:=x.subs(fname);
     end;



function _relpath(path,basepath:string):string;
var dri,pathonly:string;i:integer;
begin
dri:=extractfiledrive(path);
pathonly:=copy(path,length(dri)+1,999);
if pos('\',pathonly)<>1 then path:=basepath+path;
   //not very clever handling of drive letters--
result:=_getpath(path,'\');
end;

function _unfold(st:string):string;
var stl:tstringlist;
begin
 try
stl:=tstringlist.create;
 stl.settext(pchar(st));
 result:=stl.text;
 finally
   stl.free
 end;
end;

function _dayssince(date:string):tdatetime;
var odate,ndate:tdatetime;
begin
 odate:=vartodatetimex(date);
 result:=now-odate;
 if odate>result then beep;
end;

function _randomname:string;
var i:integer;
 const chrs='abcdefghijklmnopqrstuvxyz1234567890';
begin
  randomize;
  result:='';
  for i:=1 to 8 do
   result:=result+copy(chrs,random(35),1);
end;

function _getval(st,text:string):string;
var alku:integer;
begin
 alku:=pos(st,text)+length(st)+2;
 if alku=0 then exit;
 result:=copy(text,alku,length(text));
 result:=copy(result,1,pos('"',result)-1);
 end;

function _WeekOfYear(ADate : TDateTime) : word;
var
  day : word;
  month : word;
  year : word;
  FirstOfYear : TDateTime;
begin
  DecodeDate(ADate, year, month, day);
  FirstOfYear := EncodeDate(year, 1, 1);
  Result := (Trunc(ADate - firstofyear +(dayofweek(FirstOfYear))+5) div 7);
  end;

function _getmonth(ADate : TDateTime) : word;
var
  day : word;
  month : word;
  year : word;
  FirstOfYear : TDateTime;
begin
  DecodeDate(ADate, year, month, day);
  Result := month;
  end;


{
 function _testssl(urli:string;wait:integer;acomatts:tstringlist):string;
 var
   sock: TTCPBlockSocket;
 begin
   sock := TTCPBlockSocket.create;
   try
     sock.SSLDoConnect;
     //sslEnabled:=True;
     writeln('Used OpenSSL library:');
     writeln(SSLLibFile);
     writeln(SSLUtilFile);
     sock.Connect(urli,paramstr(2));
     if sock.lasterror <> 0 then
     begin
       writeln('Error connecting!');
       exit;
     end;
     writeln;
     writeln('SSL version: ', sock.SSLGetSSLVersion);
     writeln('Cipher: ', sock.SSLGetCiphername);
     writeln('Cipher bits: ', sock.SSLGetCipherBits);
     writeln('Cipher alg. bits: ', sock.SSLGetCipherAlgBits);
     writeln('Certificate verify result: ', sock.SslGetVerifyCert);
     writeln('Certificate peer name: ', sock.SSLGetPeerName);
     writeln(sock.SSLGetCertInfo);
     sock.closesocket;
   finally
     sock.free;
   end;
 }


procedure _xcopyfile(acom:ttag);
 var inf,outf: array[0 ..1023] of char;
    begin
    try
     StrPCopy(inf,acom.att('in'));
     StrPCopy(outf,acom.att('out'));
       writeln('<li>copyfile '+inf+' to '+outf);
       writeln(copyfile(inf,outf,false));
       except writeln('<li>failed to copy '+acom.att('in'));
     end;

    end;
{
function Download(URL, User, Pass, FileName: string): Boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  F: File;
begin
   Result := False;
   hSession := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0) ;

   // Establish the secure connection
   InternetConnect (
     hSession,
     //PChar(FullURL),
     PChar(URL),
     INTERNET_DEFAULT_HTTPS_PORT,
     PChar(User),
     PChar(Pass),
     INTERNET_SERVICE_HTTP,
     0,
     0
   );

  try
    hURL := InternetOpenURL(hSession, PChar(URL), nil, 0, 0, 0) ;
    try
      AssignFile(f, FileName);
      Rewrite(f,1);
      try
        repeat
          InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) ;
          BlockWrite(f, Buffer, BufferLen)
        until BufferLen = 0;
      finally
        CloseFile(f) ;
        Result := True;
      end;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end;
end;
}

Procedure _closeStdErr;
  Var    f: Textfile;
    h: THandle;
  Begin
{$IFDEF DELPHI}
    h:= GetStdhandle( STD_ERROR_HANDLE );
    If h = INVALID_HANDLE_VALUE Then
      RaiseLastWin32Error;
    Move( TTextRec( output ), TTextRec( f ), sizeof( TTextrec ));
    TTextrec(f).Handle := h;
    If TTextrec(f).handle = TTextRec( output ).handle Then
      TTextrec(f).mode := fmClosed
    Else
      Closefile(f);
{$ENDIF}
  End;

function _getpathinfo(vari:pchar):string;
  var  buf:array[0..2000] of char;
   pvar:array[0..2000] of char;
begin
  {$IFDEF DELPHI}
  if GetEnvironmentVariable(vari, buf, sizeOf(buf))=0 then exit;
  result:=strpas(buf)
{$ELSE}
  result:=GetEnvironmentVariable(vari);
{$ENDIF}

end;

{function RFC2822Date(const LocalDate: TDateTime; const IsDST: Boolean): string;
const
  // Days of week and months of year: must be in English for RFC882
  Days: array[1..7] of string = (
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  );
  Months: array[1..12] of string = (
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  );
var
  Day, Month, Year: Word;             // parts of LocalDate
  TZ : Windows.TIME_ZONE_INFORMATION; // time zone information
  Bias: Integer;                      // bias in seconds
  BiasTime: TDateTime;                // bias in hrs / mins to display
  GMTOffset: string;                  // bias as offset from GMT
begin
  // get year, month and day from date
  SysUtils.DecodeDate(LocalDate, Year, Month, Day);
  // compute GMT Offset bias
  Windows.GetTimeZoneInformation(TZ);
  Bias := TZ.Bias;
  if IsDST then
    Bias := Bias + TZ.DaylightBias
  else
    Bias := Bias + TZ.StandardBias;
  BiasTime := SysUtils.EncodeTime(Abs(Bias div 60), Abs(Bias mod 60), 0, 0);
  if Bias < 0 then
    GMTOffset := '-' + SysUtils.FormatDateTime('hhnn', BiasTime)
  else
    GMTOffset := '+' + SysUtils.FormatDateTime('hhnn', BiasTime);
  // build final string
  Result := Days[DayOfWeek(LocalDate)] + ', '
    + SysUtils.IntToStr(Day) + ' '
    + Months[Month] + ' '
    + SysUtils.IntToStr(Year) + ' '
    + SysUtils.FormatDateTime('hh:nn:ss', LocalDate) + ' '
    + GMTOffset;
end;
}

function vartodatetimex(ts:string):tdatetime;
begin
{$IFDEF FPC}
 result:=strtodatetime(ts);
  {$ELSE}
 result:=vartodatetime(ts);
  {$ENDIF}
end;

procedure _writefile(fs,ts:string);
var f:text;
begin
 try
 assignfile(f,fs);
 rewrite(f);
 write(f,ts);
 closefile(f);
 except writeln('<li>failed to write to '+fs);
 end;
 //writeln('<li>wrote to '+fs);
end;


function _randomstring:string;
var i:integer;
begin
// randomize;
 result:='';
 for i:=1 to 8 do
 begin
  result:=result+copy(
'0123456789abcdefghijklmnopqrstuvxyz',random(36),1);
end;
 //writeln('gotrnd:',result);
end;
function _xsplit(text,pat:string;res:tstringlist):integer;
var st:string;i,m,len,patlen:integer;d:boolean;
begin
  st:='';
  patlen:=length(pat);
  len:=length(text);if patlen=0 then exit;
i:=0;   m:=1;
  d:=false;
  while i<len do
  begin
    i:=i+1;
    try
  while (pat[m]=text[i+m-1])  do
       if m+1>patlen then begin d:=true;break;end
       else m:=m+1;
      except writeln('failed split');raise;end;
      if d then
      begin
        res.add(st);
        st:='';
        i:=i+patlen-1;
        m:=1;
        d:=false;
        continue;
      end
      else m:=1;
    st:=st+text[i];                         end;
  res.add(st);
  result:=res.count;
end;
function _split(st,sep:string;stl:tstringlist):integer;
  var posi:integer;done:boolean;
  begin
    done:=false;
     repeat
      posi:=pos(sep,st);
      if posi=0 then begin done:=true;posi:=length(st)+1;end;
      stl.add(copy(st,1,posi-1));
      st:=copy(st,posi+length(sep),length(st));
    until done;
    result:=stl.count;
end;

function _poslast(part,whole:string):integer;
var i,len,alen:integer;
begin
    len:=length(whole);
    alen:=length(part);
    result:=-99;
    for i:=len downto 1 do
    if (whole[i]=part[1])
      and (copy(whole,i, alen)=part)
      then
      begin
       result:=i;
       //result:=i-1;
       break;
      end;end;

function _gsub(what,towhat:string;var inwhat:string):string;
begin
 inwhat:=StringReplace(inwhat,what,towhat,[rfreplaceall]);
 result:=inwhat;
end;

procedure oldgsub(what,towhat:string;var inwhat:string);
var i,j:integer;res:string;
begin
 i:=1;res:='';
 while i<=length(inwhat) do
  if pos(what,copy(inwhat,i,999999))=1 then
   begin res:=res+towhat;i:=i+length(what);end
  else
   begin res:=res+inwhat[i];i:=i+1;end;
 inwhat:=res;
end;


procedure _sub(what,towhat:string;var inwhat:string);
var i,j,hpt:integer;res:string;
begin
  hpt:=pos(what,inwhat);
  if hpt=0 then exit
  else
  //inwhat:=copy(inwhat,1,hpt-1)+towhat+copy(inwhat,hpt+length(what),length(inwhat));
  inwhat:=StringReplace(inwhat,what,towhat,[]);
end;
function cut_li(s:string):integer;
var apus:string;i,apui:integer;
begin
    apui:= pos('=',s);
    if apui>1 then
    begin
     apus:=copy(s,1,apui-1);
     result:=strtointdef(apus,0);
    end
    else
    begin
     apus:='';
     for i:=1 to length(s) do
     begin
       if (strscan('0123456789', s[i])=nil) then
       begin
        if apus='' then continue else break;
       end
       else
         apus:=apus+s[i];
     end;
     result:=strtointdef(apus,0);
    end;

end;

function pos_reverse(part,whole:string):integer;
var posi:integer;rest:string;
begin
 result:=pos(ReverseString(part),ReverseString(whole));
{ posi:=0;
 rest:=whole;
 while pos(part,rest)>0 do
 begin
  posi:=posi+pos(part,rest);
  rest:=copy(whole,posi+length(part),length(whole));
  end;
 result:=posi;
 }
 end;
{
procedure _split(st,sep:string;stl:tstringlist);
  var posi:integer;done:boolean;
  begin
    done:=false;
     repeat
      posi:=pos(sep,st);
      if posi=0 then begin done:=true;posi:=length(st)+1;end;
      stl.add(copy(st,1,posi-1));
      st:=copy(st,posi+length(sep),length(st));
    until done;
end;
}
function cut_par(s:string):string;
var apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,apui+1,length(s)) else result:=s;
    result:=trim(result);
    if (pos('"',result)=1) and (length(result)>1) and (result[length(result)]='"') then
     result:=copy(result,2,length(result)-2);
     //writeln('cut_par:',apui,'!',result,'¤',s);
   end;
function cut_rs(s:string):string;
var apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,apui+1,length(s)) else result:='';
    //§result:=trim(result);
    if (pos('"',result)=1) and (length(result)>1) and (result[length(result)]='"') then
     result:=copy(result,2,length(result)-2);
   end;
function cut_rse(s:string):string;
var apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,apui+1,length(s)) else result:='';
    if (pos('"',result)=1) and (length(result)>1) and (result[length(result)]='"') then
     result:=copy(result,2,length(result)-2);
   end;

function fullcut_rs(s:string):string;
var apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,apui+1,length(s)) else result:='';
end;

function cut_ri(s:string):integer;
var apus:string;i,apui:integer;
  begin
    apui:= pos('=',s);
    if apui>1 then apus:=copy(s,apui+1,8) else apus:='';
    for i:=1 to length(apus) do
    if (strscan('0123456789', apus[i])=nil) then break;
    result:=strtointdef(copy(apus,1,i-1),0);
end;

function cut_ls(s:string):string;
var apus:string;apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,1,apui-1) else result:=s;
end;



procedure _getvars(st:string;var stl:tstringlist);
var //vals:tstringlist;
i:integer;
invalu,invari,intag:boolean;
vari,valu:string;c:char;begin
  invari:=true;
  invalu:=false;

  for i:=1 to length(st) do
  begin
   c:=st[i];
    if invari then
    begin
      if c='=' then
      invari:=false ELSE
      if c<>' ' then VARI:=VARI+ST[I];
      continue;
    end;
    if not invalu then
    if (st[i]='"') then
    begin
      invalu:=true;
      continue;
    end;
    if (st[i]='"') then
    begin
      stl.add(vari+'='+valu);
      vari:=''; valu:='';
      invari:=true;invalu:=false;
      continue;
    end
    else VALu:=VAlu+ST[I];
  end;
end;


procedure _getvarsnoquotes(st:string;var stl:tstringlist);
var //vals:tstringlist;
i:integer;
invalu,invari,intag:boolean;
vari,valu:string;c:char;begin
  invari:=true;
  invalu:=false;

  for i:=1 to length(st) do
  begin
   c:=st[i];
    if invari then
    begin
      if c='=' then
      begin
        invari:=false;
        invalu:=true;
        continue;
       end ELSE
      if c<>' ' then VARI:=VARI+ST[I]
      else
      begin
      stl.add(vari);
      vari:=''; valu:='';


      end;
      continue;
    end;
    if (st[i]=',') then
    begin
      stl.add(trim(vari)+'='+trim(valu));
      valu:='';
    end else
    if (st[i]=' ') or (i=length(st)) then
    begin
     if i=length(st) then valu:=valu+st[i];
      stl.add(trim(vari)+'='+trim(valu));
      vari:=''; valu:='';
      invari:=true;invalu:=false;
      continue;
    end
    else VALu:=VAlu+ST[I];
  end;
end;

function _clean(st:string):string;
var i,len:integer;
begin
result:='';
  len:=length(st);
  for i:=1 to len do
  begin
  if st[i]='&' then result:=result+'&amp;' else
  if st[i]='"' then  result:=result+'&quot;'  else
  if st[i]='<' then  result:=result+'&lt;' else
  if st[i]='>' then  result:=result+'&gt;' else
  // NOTE; THIS NEED THINKING
  if st[i]='''' then  result:=result+'&#39;' else
  result:=result+st[i];
  end;
end;
function _UNclean(st:string):string;
var i,len:integer;
begin
result:=ST;
_gsub('&amp;','&',result);
_gsub('&gt;','>',result);
_gsub('&lt;','<',result);
_gsub('&quot;','"',result);
_gsub('&#39;','''',result);
end;


function _slowclean(st:string):string;
begin
  st:=trim(st);
  _gsub('"','&quot;',st);
  _gsub('<','&lt;',st);
  _gsub('>','&gt;',st);
  result:=st;
end;

function _cleanfield(st:string):string;
begin
  st:=trim(st);
  _gsub('"','&quot;',st);
  _gsub('<','&lt;',st);
  _gsub('>','&gt;',st);
  result:=st;
end;

function _matches(x,y:string):boolean;
begin
  result:=false;
  if pos('|'+x+'|','|'+y+'|')>0 then
   result:=true else
  if pos('|'+y+'|','|'+x+'|')>0 then
   result:=true else
   if (pos('*',y)>1) and
    (copy(y,1,length(y)-1)=copy(x,1,length(y)-1)) then
    result:=true
   else
   if (pos('*',x)>1) and
    (copy(x,1,length(x)-1)=copy(y,1,length(x)-1)) then
    result:=true;
   if y='*' then //if x<>'' then  //NOT SURE ABOUT MATCHING EMPTIES
   result:=true;
   if x='*' then //if y<>'' then
   result:=true;
   //if y='' then writeln('<li>fffffffffffffffff:',result);
   end;
{
function _reculist(stl:tstringlist;ind:string):string;
var ast:tstringlist;i:integer;
begin
  result:='';
  if stl=nil then exit;
  for i:=0 to stl.count-1 do
  begin
    result:=result+ind+inttostr(i)+stl[i]+crlf;
    if stl.objects[i]=nil then
    begin
     result:=result+ind+'nottinkia*'+crlf;
     continue;
    end;
    if not (stl.objects[i] is tstringlist) then break;
    ast:=tstringlist(stl.objects[i]);
    if ast<>nil then if ast.count>0 then
    begin
     result:=result+ind+inttostr(ast.count)+_reculist(ast,'*   '+ind)+crlf;
    end;
  end;
end;
}
function CreateProcessAndWait(const AppPath, AppParams: String;
                              Visibility: word): DWord;
{$IFDEF DELPHI}
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  Proc: THandle;
begin
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.wShowWindow :=0;
  if not CreateProcess(PChar(AppPath), PChar(AppParams), Nil, Nil, False,
                   Normal_Priority_Class, Nil, Nil, SI, PI) then
  Proc := PI.hProcess;
  CloseHandle(PI.hThread);
  if WaitForSingleObject(Proc, Infinite) <> Wait_Failed then
    GetExitCodeProcess(Proc, Result);
  CloseHandle(Proc);
end;
{$ELSE}BEGIN END;
{$ENDIF}
function launchprogram(FileName,cmdline:String; wait:boolean):string;//DWORD;
{$IFDEF windows}
begin writeln('<li>Launching ext programs not yet supported under windows');end;
{$ELSE}
const
  READ_BYTES = 2048;

var
  OurCommand: String;
  OutputLines: TStringList;
  MemStream: TMemoryStream;
  OurProcess: TProcess;
  NumBytes: LongInt;
  BytesRead: LongInt;

begin
  // A temp Memorystream is used to buffer the output
  MemStream := TMemoryStream.Create;
  BytesRead := 0;
  //writeln('<li>launching exe',filename,' with ',cmdline);
  OurProcess := TProcess.Create(nil);
  // Recursive dir is a good example.
  //OurCommand:='invalid command, please fix the IFDEFS.';
//==  OurCommand:=filename+' '+cmdline;
  {$IFDEF Windows}
  //Can't use dir directly, it's built in
  //so we just use the shell:
   //OurCommand:=filename;
  {$ENDIF Windows}
  {$IFDEF Unix}
  //Needs to be tested on Linux/Unix:
  //do we need a full path or not?
  //DirCommand:=FindDefaultExecutablePath('ls') + ' --recursive --all -l /';
  //OurCommand := '/bin/ls --recursive --all -l /';
  {$ENDIF Unix}
  //writeln('!Going to run: ' + OurCommand);
  //OurProcess.CommandLine := OurCommand;//+' '+filename;;
  //ourprocess.Executable:=filename;
  //ourprocess.commandline:='ls  --all -l';
  //ourprocess.commandline:= 'sh -c "'+cmdline+'"';
  ourprocess.commandline:= filename+' '+cmdline;
  //==  _split(cmdline,'|',tstringlist(ourprocess.parameters));
  //ourprocess.parameters.add(cmdline);
  //ourprocess.parameters.add('-Tsvg');
  // We cannot use poWaitOnExit here since we don't
  // know the size of the output. On Linux the size of the
  // output pipe is 2 kB; if the output data is more, we
  // need to read the data. This isn't possible since we are
  // waiting. So we get a deadlock here if we use poWaitOnExit.
  //OurProcess.Options := [poUsePipes];
  //==OurProcess.Options := [poNoConsole, poUsePipes, poStderrToOutPut] ;
  OurProcess.Options := [poUsePipes];
  //WriteLn('-- External program run starting',ourprocess.commandline);
  //WriteLn('-- External program run starting',ourprocess.executable);
  OurProcess.Execute;
  while OurProcess.Running do
  begin
    // make sure we have room
    MemStream.SetSize(BytesRead + READ_BYTES);

    // try reading it
    NumBytes := OurProcess.Output.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
    if NumBytes > 0
    then begin
      Inc(BytesRead, NumBytes);
      //Writeln('.',NUMBYTES) //Output progress to screen.
    end
    else begin
      // no data, wait 100 ms
      BREAK;
      Sleep(100);
      //writeln('slept');
    end;
  end;
  // read last part
  repeat
    // make sure we have room
    MemStream.SetSize(BytesRead + READ_BYTES);
    // try reading it
    NumBytes := OurProcess.Output.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
    //writeln('read?',numbytes);
    if NumBytes > 0
    then begin
      //writeln('read:',numbytes);
      Inc(BytesRead, NumBytes);
      //Write('.');
    end;
  until NumBytes <= 0;
  //if BytesRead > 0 then WriteLn('read:'+inttostr(bytesread));
  MemStream.SetSize(BytesRead);
  //WriteLn('-- External program run complete');

  OutputLines := TStringList.Create;
  OutputLines.LoadFromStream(MemStream);
  //WriteLn('-- External program output line count = ', OutputLines.Count, ' --');
  //for NumBytes := 0 to OutputLines.Count - 1 do
  //begin
  //  WriteLn('output:'+OutputLines[NumBytes]);
  //end;
  //WriteLn('-- Program end');
  //OutputLines.Free;
  result:=outputlines.text;
  //writeln('===<xmp>'+result.text+'</xmp>');
  OurProcess.Free;
  MemStream.Free;
end;
{$ENDIF}
function launch(cmd, cmdline:string):string;
{$IFDEF windows}
begin writeln('<li>Launching ext programs not yet supported under windows');end;
{$ELSE}
{
    Copyright (c) 2004-2011 by Marc Weustink and contributors

    This example is created in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
// This is a
// WORKING
// demo program that shows
// how to launch an external program
// and read from its output.
var
  OurCommand: String;
  OutputLines: TStringList;
  MemStream: TMemoryStream;
  OurProcess: TProcess;
  NumBytes: LongInt;
  BytesRead: LongInt;

const
  READ_BYTES = 2048;


begin
  // A temp Memorystream is used to buffer the output
  MemStream := TMemoryStream.Create;
  BytesRead := 0;

  OurProcess := TProcess.Create(nil);
  // Recursive dir is a good example.
  OurCommand:='invalid command, please fix the IFDEFS.';
  {$IFDEF Windows}
  //Can't use dir directly, it's built in
  //so we just use the shell:
  OurCommand:='cmd.exe /c "dir /s c:\windows\"';
  {$ENDIF Windows}
  {$IFDEF Unix}
  //Needs to be tested on Linux/Unix:
  OurCommand := 'ls  /home/t/xseus/xs*.*';
  {$ENDIF Unix}
  writeln('-- Going to run: ' + OurCommand);
  OurProcess.CommandLine := OurCommand;

  // We cannot use poWaitOnExit here since we don't
  // know the size of the output. On Linux the size of the
  // output pipe is 2 kB; if the output data is more, we
  // need to read the data. This isn't possible since we are
  // waiting. So we get a deadlock here if we use poWaitOnExit.
  OurProcess.Options := [poUsePipes];
  WriteLn('-- External program run started');
  OurProcess.Execute;
  while OurProcess.Running do
  begin
    // make sure we have room
    MemStream.SetSize(BytesRead + READ_BYTES);
    write('r');
    // try reading it
    NumBytes := OurProcess.Output.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
    if NumBytes > 0
    then begin
      Inc(BytesRead, NumBytes);
      Write('.') //Output progress to screen.
    end
    else begin
      // no data, wait 100 ms
      Sleep(100);
    end;
  end;
  // read last part
  repeat
        WriteLn('-- readdatea'+ourcommand);
    // make sure we have room
    MemStream.SetSize(BytesRead + READ_BYTES);
    // try reading it
    NumBytes := OurProcess.Output.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
    writeln('gotbytes-'+inttostr(numbytes));
    if NumBytes > 0
    then begin
      Inc(BytesRead, NumBytes);
      Write('.');
    end;
  until NumBytes <= 0;
  if BytesRead > 0 then WriteLn;
  MemStream.SetSize(BytesRead);
  WriteLn('-- External program run complete');

  OutputLines := TStringList.Create;
  OutputLines.LoadFromStream(MemStream);
  WriteLn('-- External program output line count = ', OutputLines.Count, ' --');
  for NumBytes := 0 to OutputLines.Count - 1 do
  begin
    WriteLn(OutputLines[NumBytes]);
  end;
  WriteLn('-- Program end');
  OutputLines.Free;
  OurProcess.Free;
  MemStream.Free;
end;
{$ENDIF}


function WinExecAndWait32(FileName:String;
   wait:boolean):DWORD;
{$IFDEF DELPHI}
  var  zAppName:array[0..512] of char;
    StartupInfo:TStartupInfo;
    ProcessInfo:TProcessInformation;
  begin
 try
StrPCopy(zAppName,FileName);
    FillChar(StartupInfo,Sizeof(StartupInfo),#0);
    StartupInfo.cb := Sizeof(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := 1;StartupInfo.wShowWindow := SW_HIDE;
    if not (CreateProcess(
      nil,
      zAppName,                      nil,                           nil,                           false,                         CREATE_NEW_CONSOLE or          NORMAL_PRIORITY_CLASS,
      nil,                           nil,                           StartupInfo,                   ProcessInfo)
      )
      then
      begin
        writeln('<!--cmd fail: ' +filename,getlasterror,'-->');

        Result:=2;
        end
      else
     begin
      if wait then
      begin
      WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
        GetExitCodeProcess(ProcessInfo.hProcess, result);
        end
       else
        writeln('<!--cmd nowait try: ' +filename,getlasterror,'-->');
       GetExitCodeProcess(ProcessInfo.hProcess,Result);
       FileClose(ProcessInfo.hProcess ); { *Converted from CloseHandle*  }
       FileClose(ProcessInfo.hThread ); { *Converted from CloseHandle*  }
       end;
       except writeln('Failed:'+filename+'!');
  end;
 end;
{$ELSE}
BEGIN launchprogram(FileName,cmdline,wait); writeln('WINEXEXEC NOT IMPLEMENTED');END;


{$ENDIF}




function HexToInt(HexStr: String): Int64;
var RetVar : Int64;
i : byte;
begin
HexStr := UpperCase(HexStr);
if HexStr[length(HexStr)] = 'H' then
Delete(HexStr,length(HexStr),1);
RetVar := 0;

for i := 1 to length(HexStr) do begin
RetVar := RetVar shl 4;
if HexStr[i] in ['0'..'9'] then
RetVar := RetVar + (byte(HexStr[i]) - 48)
else
if HexStr[i] in ['A'..'F'] then
RetVar := RetVar + (byte(HexStr[i]) - 55)
else begin
Retvar := 0;
break;
end;
end;

Result := RetVar;
end;
function _URLEncode(const Data: String): String;
var
  i: Integer;
begin
 result:='';
  for i:=1 to Length(Data) do
    if Data[i] in ['a'..'z','A'..'Z','0','1'..'9', '-', '_', '.'] then Result :=
Result+Data[i]
      else if Data[i]=' ' then Result := Result+'+'
      else Result := Result+'%'+IntToHex(Byte(Data[i]), 2);
end;

function _UrlDecode(const EncodedStr: String): String;
var
I: Integer;
begin
Result := '';
if Length(EncodedStr) > 0 then
begin
I := 1;
while I <= Length(EncodedStr) do
begin
if EncodedStr[I] = '%' then
begin
Result := Result + Chr(HexToInt(EncodedStr[I+1]
+ EncodedStr[I+2]));
I := Succ(Succ(I));
end
else if EncodedStr[I] = '+' then
Result := Result + ' '
else
Result := Result + EncodedStr[I];

I := Succ(I);
end;
end;
end;

function notused_newfile(pattern,ext:string):string;
var i:integer;h:thandle;begin
  for i:=1 to 99999 do
  if not FileExists(pattern+inttostr(i)+'.'+ext) { *Converted from FileExists*  } then
  begin
     h:=FileCreate(pchar(pattern+inttostr(i)+'.'+ext)); { *Converted from CreateFile*  }
//--    if  h<>INVALID_HANDLE_VALUE then
//-- THIS PROBABLY HAS TO BE FIXED
   begin
    result:=extractfilename(pattern+inttostr(i));FileClose(h); { *Converted from CloseHandle*  }
    break;
   end;
  end;
  end;
function _newfile(pattern,ext:string):string;
var i:integer;h:thandle;fn:string;
begin
  for i:=1 to 99999 do
  begin
    if i=1 then
      fn:=(pattern+'.'+ext) else
      fn:=pattern+inttostr(i)+'.'+ext;
    if not fileexists(fn) then
    begin
      try
      h:=FileCreate(pchar(pattern+inttostr(i)+'.'+ext)); { *Converted from CreateFile*  }
      //h:=createfile(
      //pchar(fn), generic_write,0 ,0, CREATE_NEW, 0, 0) ;
      //if  h<>INVALID_HANDLE_VALUE then
      begin
       result:=extractfilename(fn);FileClose(h); { *Converted from CloseHandle*  } //closehandle(h);
       break;
      end;
      except continue;end;
    end;
  end;
end;


function _getpath(st:string;sep:char):string;
var sl:tstringlist;i:integer;skip:integer;
begin
  if pos('..',st)<1 then result:=st else
  begin
    try
    skip:=0;
    sl:=tstringlist.create;
    _split(st,sep,sl);
    i:=sl.count-2;
    result:=sl[sl.count-1];
    //i:=sl.count-1;
    //result:='';
    while i>=0 do
    begin
      if sl[i]='..' then skip:=skip+1 else
      if sl[i]<>'.' then
      begin
       if skip=0 then
       result:=sl[i]+sep+result
       else skip:=skip-1;
      end;
      i:=i-1;
    end;
    finally sl.Free;
    end;
  end;
end;

function _normalizeurl(url,base:string):string;
begin
  if not (pos('http://',url)=1) then
  begin
    if not (base[length(base)]='/') then//muutetaan base hakemistoksi
      base:=copy(base,1,_poslast('/',base));
    if (pos('javascript:',url)=1) or (pos('#',url)=1) or (pos('mailto:',url)=1) then exit; //javascriptin tai # tullessa poistutaan
    if (pos('/',url))=1 then //eka on / niin
     result:=copy(base,1,pos('/',base)-1)+url
    else //jos eka ei oo /
     result:=base+url; //nii muodostetaan urli
    if (pos('./',result)>0) or (pos('../',result)>0) then //jos löytyy ../
     result:=_getpath(result,'/');//käytetään _getpath functioo
    if not (result[length(result)] = '/') and (_poslast('/',result) > _poslast('.',result)) then
    //jos resultin vika ei oo / ja resultissa vika / on vikan . jälkeen
    result := result+'/'; //niin resulttiin lisätään /
  end else
    result:=url;//jos urlin alussa on http:
    // niin se annetaan sellaisenaan
   // result:=StringReplace(result,'http://','',[RFReplaceAll]);
end;


function _geturl(page,link:string):string;
var base,filen,server:string;lastslash:integer;
begin
   if pos('http://',link)>0 then
   result:=link else
   if pos('mailto:',link)>0 then
   result:=link else
   begin
       server:=copy(page,pos('://',page)+3,length(page));
       begin
         base:=copy(server,pos('/',server),length(server));
         server:=copy(server,1,pos('/',server)-1);
         lastslash:=_poslast('/',base);
         filen:=copy(base,lastslash,length(base));
         if pos('.',filen)>0 then
          base:=copy(base,1,lastslash-1);

         if pos('/',link)=1 then base:='';

        end;
         result:='http://'+server+base+link;
     end;
end;
function _mapurltofile(url:string;mappings:ttag):string;
var base,filen,server:string;i,lastslash:integer;
 amap:ttag;
begin
   if url<>'' then
   begin
      for i:=0 to mappings.subtags.count-1 do
      begin
         amap:=mappings.subtags[i];
         if pos(amap.att('url'),url)=1 then
         begin
           filen:=copy(url,length(amap.att('url'))+1,length(url));
           filen:=StringReplace(filen,'/',g_pathseparator,[rfreplaceall]);


           result:=amap.att('path')+filen;
            break;
         end;
      end;
   end;
end;


function old_mapurltofile(url:string;mappings:ttag):string;
var base,filen,server:string;i,lastslash:integer;
 amap:ttag;
begin
  //logwrite('URL'+URL);
   if url<>'' then
   begin
      for i:=0 to mappings.subtags.count-1 do
      begin
         amap:=mappings.subtags[i];
         //logwrite('/\'+AMAP.XMLIS);
         if pos(amap.att('url'),url)=1 then
         begin
           result:=amap.att('path')+copy(url,length(amap.att('url'))+1,length(url));
           //>>_gsub('/','\',result);
           //logwrite('/\'+result);
          break;
         end;
      end;
   end;
end;

function _mapfiletourl(fil:string;mappings:ttag):string;
var base,filen,server:string;i,lastslash:integer;
 amap:ttag;
begin
   if fil<>'' then
   begin
      for i:=0 to mappings.subtags.count-1 do
      begin
         amap:=mappings.subtags[i];
         if pos(amap.att('path'),fil)=1 then
         begin
           result:=amap.att('url')+copy(fil,length(amap.att('path'))+1,length(fil));
           _gsub('\','/',result);
           break;
         end;
      end;
   end;
end;
procedure _addattributes(atts:tstringlist;newatts:tstringlist;xs:tobject);
var k:integer;aps:string;
begin
    if atts.count>0 then
    begin
     for k:=0 to atts.count-1 do
     begin
      aps:=cut_rs(atts[k]);
      if aps=txseus(xs).ns+'nil' then
            newatts.values[cut_ls(atts[k])]:= '' else

      newatts.values[cut_ls(atts[k])]:= aps;
      end;
     atts.clear;
    end;
end;


procedure _listtolist(oldlist,alist:tlist;i:integer;par:ttag);
var j,m:integer;
begin
 try
 try
 if oldlist=nil then exit;
 if alist=nil then exit;
 if alist.Count=0  then exit;
     except writeln('failde find lists to add');raise;end;

      if i<oldlist.count-1 then
      for j:=alist.count-1 downto 0 do
      begin
       try
        oldlist.insert(i+1,alist[j]);
        ttag(alist[j]).parent:=par;
        except writeln('couldnot ins list');raise;end;
        end
      else
      for j:=0 to alist.count-1 do
      begin
        try
        oldlist.add(alist[j]);
        ttag(alist[j]).parent:=par;
       except writeln('couldnot add to list');raise;end;
      end;
     except writeln('failde add to list');raise;end;

end;

function _cdatavex(text:string):string;
var rest,res:string;done:boolean;posi,pose:integer;
begin
 done:=false;
 rest:=text;
 result:='';
  while not done do
 begin
   posi:=pos('<![CDATA[',rest);
   if posi<1 then
   begin
     result:=result+rest;
     break;
   end
   else
   begin
     result:=result+copy(rest,1,posi-1);
     rest:=copy(rest,posi+9,length(rest));
     pose:=pos(']]>',rest);
     if pose<1 then
     begin
       result:=result+rest;
       break;
     end
     else
     begin
      result:=result+copy(rest,1,pose-1);
       rest:=copy(rest,pose+3,length(rest));
     end;
   end;
 end;
   end;

procedure _addform(acom,xform:ttag);
var i:integer;st:string;
begin
  try
 st:=acom.att('value');
 if st='$randomfile' then st:=_randomstring;
 xform.addsubtag(acom.att('name'),st);

except writeln('failed to add a field to form');end;
end;

procedure _listenv;
var
  Variable: Boolean;
  Str: PChar;
  Res: tstringlist;st:string;
begin
 try
  Res:= tstringlist.create;
  Str:=GetEnvironmentStrings;
  Variable:=False;
  while True do begin
    if Str^=#0 then
    begin
    Variable:=True;
      Inc(Str);
      RES.ADD(ST);
      st:='';
      if Str^=#0 then
        Break
      else
        st:=st+(str^);
    end
    else
      if Variable then st:=st+(Str^);
    Inc(str);
  end;
  writeln(res.text);
  res.savetofile('c:\temp\env.txt');
  finally res.free;end;
end;

{
function _t2h(atag,xform,sel:ttag;xs:tobject;state:tobject):string;
var
 ot:ttag;txt2,txt,taglist:tstringlist;
 i:integer;st,ast:string;intag:boolean;

begin
try try
try
 txt:=tstringlist.create;
 txt2:=tstringlist.create;
 taglist:=tstringlist.create;
  result:='';//nil;
  if atag.att('upload')='' then
  begin
  try
    if atag.att('string')<>'' then
     st:=atag.att('string')
    else
    begin
      try
        ot:=txseus(xs).xgetitsomehow('in',atag.attributes,sel,xform,atag,atag.att('path')='full',tstate(state));
      except
        writeln('failed to get for t2h');
      end;
      try
      if ot=nil then
        exit;
       except
           writeln('failed to exit');
       end;
      st:=ot.getsubvals;

    end;
    st:=_nocdata(st)
  except writeln('notagt2h _t2h');
  end;
  end
  else
//   st:=txseus(xs).ccall.upfile;
  if st='' then
  exit;

 except writeln('_t2h failed');end;
 try
 if pos('<![CDATA[',st)>0 then
 begin
 st:=copy(st,10,length(st)-12);
 end;
 if st='' then if ot<>nil then  st:=ot.listst;
 txt.Text:=st;
 intag:=false;ast:='';
 _tidylines(txt,taglist);

 if
 (atag.subt('formoptions')<>nil) and
 (atag.subt('formoptions').att('not2h')='on') then
 begin
  txt2.addstrings(txt);
 end else
 try
 //txt2:=_text2html(taglist,atag,xform);
 //if 1=0  then
 _text2html(txt2,taglist,atag,xform);
 except writeln('failed to convert _t2h - text2html');end;

result:=txt2.text;except writeln('t2h failed');end;
finally
try
 // if txt<>nil then
  txt.free;
  taglist.free;
  txt2.free;
  except
    writeln('<li>/t2h Finally failed');
  end;

 end;
except
    writeln('<li>/t2h finally failed');

end;
end;
}

{function _field2xml(atag,xform:ttag):ttag;
var fi:string;
 nt,ot:ttag;
 st:string;

begin
try
   ot:=xform.subt(atag.att('in'));
   if ot=nil then exit;
   st:=ot.vali;
   fi:=atag.att('out');
  if st='' then  st:=ot.listst;
  if st='' then
   exit;
  except writeln('t2h failed');end;
 if pos('<![CDATA[',st)>0 then
 begin
 st:=copy(st,10,length(st)-12);
  end;
  try
    nt:=tagparse(st,false,true);
    //nt:=ttag.create;
    //nt.vari:=fi;
    //nt.parse(st,false,true);
 except writeln('failde to parse');
 end;
 xform.subtagsadd(nt);
end;
}

function _strtodatetime(str:string):tdatetime;
const shormo='JanFebMarAprMayJunJulAugSepOctNovdec';
  shorda='MonTueWedThuFriSatSun';
  delims=' /:.,-';  //()?
  tzs='GMT00UTC00PST08ALDT08PDT07MST07MDT06CST06CDT05EST05EDT04AST04HST10';

//type tord=set  of 'y','m';
var i,len,prevtok,toki:integer;tokens:tstringlist;toks:string;ypos,mpos,y,m,d,h,n,s,ms,tzi:integer;dat:tdatetime;
 separ:char;ordo:integer;//tokord:array[1..3] of shortint;
 //function getord(posi:integer):integer;
 //var i:integer;
 //begin
  // 24[1]2!4[2]3!2010[3]4!13[4]2!15[5]2![5]7
 // 231 end;
 function _o(posi:integer):integer;   //posi 1 - give the string of number in first "char" of ordo
 begin
 if posi<3 then
 cASE posi OF
   0: begin result:=strtointdef(tokens[ordo div 100],0); exit;writeln('<li>',posi,'/',ordo div 100,'/', result,'</li>');end;
   1: begin result:=strtointdef(tokens[(ordo mod 100) div 10],0);exit;writeln('<li>',posi,'/',(ordo mod 100) div 10,'/', result,'</li>');end; // 582 -->  5
   2: begin result:=strtointdef(tokens[(ordo mod 10)],0);exit;writeln('<li>',posi,'/',(ordo mod 10),'/', result,'</li>');end;
  end else
  if posi<tokens.count then
   result:=strtointdef(tokens[posi],0) else
   result:=0;
 // writeln('<li>',posi,'/',result,'</li>');
 end;

 //function setord(pos,val:integer);
begin
 str:=str+'/';
 //writeln('<li><b>date:',str+'</b></li>');
 prevtok:=1;
 result:=0;
 ypos:=-1;
 mpos:=-1;
 separ:=#0;
 len:=length(str);
 if len=0 then exit;
 tokens:=tstringlist.create;
 try
 for i:=1 to len do
 begin
   if (pos(str[i],delims)>0) then //or (i=len) then
   begin
    if separ=#0 then separ:=str[i];
    if (str[i]='-') and (tokens.count>4) then continue; // "-" can be part of timezone
    toks:=copy(str,prevtok, i-prevtok);
    if i-prevtok=3 then
    begin
     toki:=pos(toks,shormo);
     if toki>0 then begin toks:=inttostr((toki+2) div 3);mpos:=tokens.count;end
     else
     begin
      toki:=pos(toks,tzs);
      if toki>0 then toks:=copy(tzs,toki+3,2);
      tzi:=strtointdef(toks,0);toks:='';
      //writeln('TZONE:',toks, '/',tzi,'/from:'+copy(str,prevtok, i-prevtok));
     end;
    end else
    if i-prevtok=7 then  // (+1234)
    begin
      tzi:=strtointdef(copy(toks,2,5),0);toks:='';
      //writeln('TZONE:',toks, '/',tzi,'/from:'+copy(str,prevtok, i-prevtok));
    end
    else if i-prevtok=4 then ypos:=tokens.count;
    if toks<>'' then tokens.add(toks);
    // writeln('!', toks,'[',tokens.count,']',i-prevtok);
    prevtok:=i+1;
   end;
  end;    // y=1,m=2,d=3        //321       //231
   try    //iso:yyyy-mm-dd  //  fi: d.m.yyyy   us: m/d/yyyy inet: d m y
   if ypos=0 then ordo:=012  //year first, always ISO
   else if (mpos=0) or (separ='/') then ordo:=201  //m/d/y
   else ordo:=210;  //d-m-y
   if ypos=-1 then //no 4-digit values found, year must be third. and short
      tokens[2]:=inttostr(2000+strtointdef(tokens[2],0));
 {  if length(tokens[2])<4 then y:=2000+strtointdef(tokens[2],0) else y:=strtointdef(tokens[2],0);
   m:=strtointdef(tokens[1],-9999);
   d:=strtointdef(tokens[0],-9999);
   if tokens.count>3 then h:=strtointdef(tokens[3],0) else h:=0;
   if tokens.count>4 then n:=strtointdef(tokens[4],0) else n:=0;
   if tokens.count>5 then s:=strtointdef(tokens[5],-0) else s:=0;
   if tokens.count>6 then ms:=strtointdef(tokens[5],-9999) else ms:=0;
 dat:=encodedatetime(y,m,d,h,n,s,ms);
 }
 //writeln('<li>o',ordo,'/m',mpos,'/y',ypos,'/separ',separ,tokens.text,'/',tokens.count);
 //writeln('<li>encode:',_o(0),_o(1),_o(2),_o(3),_o(4),_o(5),_o(6),'<li>');
 dat:=encodedatetime(_o(0),_o(1),_o(2),_o(3),_o(4),_o(5),_o(6));
 result:=dat;
 //result:=formatdatetime('yyyy-mm-dd hh:nn:ss',dat);
  //writeln('<h1>',result,'</h1>');
   except writeln('<li>failedidate:',tokens.count,'/', tokens.text);end;
 finally
    tokens.clear;tokens.free;
 end;

end;

function _texttokens(text:string;acom:ttag):ttag;
var iii,len:integer;pseps,sseps,wseps:string;res:ttag;ch:char;

    function getaword(tosnt:ttag):string;
 var resst:string;
 begin
   result:='';
   //iii:=iii+1;
   //result:=tosnt.addsubtag('w','');
   while (iii<len) do
   begin
      if (pos(text[iii],wseps)>0) then begin iii:=iii+1;break;end;
      if (pos(text[iii],pseps+sseps)>0) then break;
      result:=result+text[iii];
      iii:=iii+1;
   end;
  // writeln('!W:'+result.vali+'!'+text[iii]);
  end;
  function getasnt(topar:ttag):ttag;
  var wtext:string;
  begin
    result:=topar.addsubtag('p','');

    //iii:=iii+1;
    while (iii<len) do
    begin
      //ch:=text[iii];
      //writeln('-',text[iii],ord(text[iii]),'-');
      //if (pos(ch,pseps+sseps)>0) then break;
     if (pos(text[iii],sseps)>0) then begin iii:=iii+1;break;end;
     if (pos(text[iii],pseps)>0) then break;
     wtext:=trim(getaword(result));
     if wtext<>'' then result.addsubtag('span',wtext);
     //if (pos(ch,pseps+sseps)>0) then break;
     //iii:=iii+1;
    end;
    //writeln(text[iii]+'/Asnt:!<xmp>'+result.xmlis+'!!!</xmp>');
    if result.subtags.count<1 then
    begin
     topar.subtags.remove(result);
     result.killtree
    end;
 end;
 function getapar(topar:ttag):ttag;
 begin
  result:=topar.addsubtag('div','');
   //iii:=iii+1;
   while (iii<len) do
   begin
     //if (pos(text[iii],pseps)>0) then break;
    //if (pos(text[iii],pseps+sseps+wseps)>0) then begin iii:=iii+1;break;end;
     if (pos(text[iii],pseps)>0) then begin iii:=iii+1;break;end;
     getasnt(result);
     //iii:=iii+1;
   end;
   if result.subtags.count<1 then
   begin
    topar.subtags.remove(result);
    result.killtree
   end;
   //writeln(text[iii]+'/Apar:!<xmp>'+result.xmlis+'!!!</xmp>');
end;

 begin
   //writeln('<hr/>','<xmp>'+text+'</xmp><hr/>');
   result:=ttag.create;result.vari:='t';
   pseps:=acom.att('psep');
   if pseps='' then pseps:=crlf;
   sseps:=acom.att('ssep');
   if sseps='' then sseps:='!?.,;';
   wseps:=acom.att('wsep');
   if wseps='' then wseps:=' ';
   len:=length(text);
   iii:=1;
   while iii<len do
   begin
     getapar(result);
     writeln('<li>APAR:',text[iii],'<xmp>'+result.xmlis+'!!!</xmp>');
     //iii:=iii+1;
     if iii>9999999999 then break;
   end;
 end;

function _text2xml(atag:ttag;text:string):ttag;
var st,sep,fnam,row,fnoname:string;nt,nnt:ttag;sl,ssl:tstringlist;
 i,j:integer;fnames:tstringlist;ats:boolean;trimmaa:boolean;

begin
 try
  sl:=tstringlist.create;
  fnames:=tstringlist.create;

  ssl:=tstringlist.create;
  nt:=ttag.create;
  nt.vari:=atag.att('out');
  fnoname:=atag.att('xfields');
  if nt.vari='' then nt.vari:='text2xml';
  sep:=atag.att('sep');
  ats:=false;
  if atag.att('attributes')<>'' then ats:=true;
  if atag.att('trim')<>'' then trimmaa:=true;
  st:=atag.att('fields');
  if st<>'' then  _split(st,',',fnames);
  row:=atag.att('rows');
  if row='' then row:='r';
  //text:=adjustlinebreaks(text);
    text:=_cdatavex(text);
    sl.text:=text;
    //writeln('<li>SEPE:'+atag.att('sep')+'/',sep);
    //writeln('<li>text:',pos(#13,text),'/',pos(#10,text),'/lines:',sl.count,'!');
   // writeln('<li>text2xml!start|<xmp>!',sep,'!:',sl.count,'|',fnames.text,fnames.count,'</xmp>');
  //_split(text,^J,sl);
   for i:=0 to sl.count-1 do
    begin
     //writeln('<li>sltext:'+sl[i]);
    //st:=trim(sl[i]);
    st:=(sl[i]);
     if sep='' then nt.addsubtag(row,st) else
     begin
       nnt:=ttag.create;
       nnt.vari:=row;
       nt.subtagsadd(nnt);
       _split(st,sep,ssl);
       //writeln('<li>',i,':',sep+'*'+st+'#',ssl.count);
       for j:=0 to ssl.count-1 do
       begin
         if ats then begin
                 if fnames.count>j then fnam:=fnames[j] else fnam:='f'+inttostr(j+1);
                nnt.setatt(fnam,ssl[j])
         end       else
         begin
          if fnames.count>j then fnam:=fnames[j] else
           if fnoname<>'' then fnam:=fnoname else fnam:='noname';
           if trimmaa then
             nnt.addsubtag(fnam,ssl[j])
           else
             nnt.addsubtag(fnam,trim(ssl[j]));
         end;
         //writeln('<li>trypart:<pre>'+ssl[j]+':'+nnt.xmlis+'</pre>');
       end;
       ssl.clear;
     end;
   end;
  result:=nt;
 // writeln('<li>text2xml!:stop:<pre>'+nt.xmlis+'</pre>')
     except writeln('text2xml failed');end;
 sl.free;fnames.free;ssl.free;
end;

procedure _tidylines(txt,resus:tstringlist);
var i,j,sfar:integer;st,ast,xtra:string;intag,inquote:boolean;
var resu:tstringlist; buff:pchar;
begin
 resu:=tstringlist.create;
 intag:=false;inquote:=false;
 for i:=0 to txt.count-1 do begin
   st:=txt[i];
   sfar:=0;
   for j:=1 to length(st) do
   begin
   if intag then
     begin
       if st[j]='>' then
       begin
        if trim(copy(st,j+1,length(st)))<>'' then ast:=ast+'>'+crlf
        else ast:=ast+'>';
        xtra:='';
        intag:=false;
        sfar:=0;
       end else
       begin
          if st[j]='"' then inquote:=not(inquote);
         if not inquote then
          ast:=ast+ansilowercase(st[j])
          else
          ast:=ast+st[j];
       end
     end
     else
     if (st[j]='<') and ((j=length(st)) or (pos(st[j+1],' .,<>"'+crlf)>0)) then
     begin
       ast:=ast+'&lt;';
       end else
     begin if (st[j]='<') then
       begin
         intag:=true;
         inquote:=false;
       end;
       if (st[j]='<') then
       begin
       ast:=ast+crlf+'<';
            end
       else ast:=ast+st[j];  end;
   end;
   if not intag then
   begin
    resu.add(ast);
    ast:='';sfar:=0;
   end;
 end;
 if intag then resu.add(ast);
 //resu.add('loppu'+crlf+crlf+'/loppu');
 //resus.setText
 buff:=resu.gettext;
 resus.SetText(buff);
 strdispose(buff);
 //resus.addstrings(resu);
 //writeln('<li>tidylines: ',resus.Count,' ',resu.count,' ',sizeof(buff));

 resu.Free;
 end;

procedure _readfile(fs:string; var ts:string);
var sl:tstringlist;
begin
 try
 sl:=tstringlist.create;
 if FileExists(fs) { *Converted from FileExists*  } then
 sl.loadfromfile(fs);
 ts:=sl.text;
 logwrite('_readfile:'+fs);
 except writeln('failed to read '+fs);
 end;
 sl.free;
end;



function _movefile(inf,outf:string):boolean;begin
 {$IFDEF DELPHI}
try
result:=movefile(pchar(inf),pchar(outf));
except _error('**failed move**'+pansichar(inf)+' to '+ pansichar(outf));end;

{$ENDIF}

end;

function _moveDir(fromdir,todir:string): boolean;
    {$IFDEF DELPHI}
var
  SH: SHFILEOPSTRUCT;
  begin
 FillChar(SH, SizeOf(SH), 0);
  with SH do
    begin
      Wnd := 0;
      wFunc := FO_move;
      pFrom := PChar(FromDir+#0);
      pTo := PChar(ToDir+#0);
      fFlags := FOF_ALLOWUNDO

                end;
  Result := SHFileOperation(SH) = 0;
end;
{$ELSE} begin writeln('not impl. in linux');end;
{$ENDIF}

function _indirs(st:string;appaths:ttag):string;
var ast:string;path:ttag;
begin
  try
     if appaths=nil then
     begin
       result:='config_dir_not_defined_'+st;exit;
     end;
       ast:=copy(st,1,pos(':',st)-1);
       st:=copy(st,pos(':',st)+1,length(st));
       //if (dirs.subt(ast)<>nil) and
       path:=appaths.subtbyatt('map','ns',ast);
       //logwrite('indirs:'+st+'!'+ast+'!');
       if path<>nil then
       //and (dirs.subt(ast).getattributes<>nil) then
       begin
         ast:=path.att('path');
         //logwrite('indirs2:'+st+'!'+ast);
       end
       else
       begin
         logwrite('nopath:'+copy(st,1,200)+'-');
         //logwrite('from:'+appaths.xmlis+'-');

       result:='';exit;
       end;
       st:=ast+st;
       st:=StringReplace(st,'..','',[rfreplaceall]);
       st:=StringReplace(st,'|','',[rfreplaceall]);
      st:=StringReplace(st,'>','',[rfreplaceall]);
      //logwrite('indirs3:'+st);
      result:=st;
 except writeln('failed to find commanddir');
 listwrite(appaths);
 //writeln('<li>|'+ast+'|');
 //      writeln('<li>dirs.sub(ast).attributes.text:'+dirs.subt(ast).attributes.text);

 end;
end;

function fileupexists(dir,fil:string):boolean;
var updir:string;i,e:integer;
begin
          //writeln('<li>d:'+dir);
          if (FileExists(dir+fil) { *Converted from FileExists*  }) then result:=true else
           result:=fileupexists(ExpandFileName(dir + g_ds+'..') { *Converted from ExpandFileName*  },fil);
 exit;
          writeln('UP:'+dir+'='+ExpandFileName(dir + g_ds+'..') { *Converted from ExpandFileName*  });
          result:=false;

          if (FileExists(dir+fil) { *Converted from FileExists*  }) then
           result:=true
          else
          begin
           e:=length(dir)-1;
           for i := e downto 1 do
             if dir[i]=g_ds then
             begin
             updir:=copy(dir,1,i);
             result:=fileupexists(updir,fil);
             exit;
             end;

          end;

end;
function   _matchhead(a,b:string;var arest,brest:string):string;
var i,lena,lenb:integer;
begin
  lena:=length(a);
  lenb:=length(b);
  i:=1;
  while  (lena>i) and (lenb>i) and (a[i]=b[i]) do
   i:=i+1;//write(a[i],i);
  result:=copy(a,1,i-1);
  arest:=copy(a,i,lena);
  brest:=copy(b,i,lenb);
end;

function _findfileupstream(diri,fil:string;t:integer):string;
 var nex:string;
 begin
    //writeln('<li>UPD:'+diri+'|file:',fil,'<ul>');
    if FileExists(diri+g_ds+fil) { *Converted from FileExists*  } then
    begin
     result:=diri+g_ds+fil;
     exit;
    end;
    nex:=ExpandFileName(diri + g_ds+'..'); { *Converted from ExpandFileName*  }
    if nex=diri then exit;

    //if random(1000)=999 then exit;
    if t>16 then exit;
    result:=_findfileupstream(nex,fil,t+1);
    //writeln('</ul></li>');

 end;
function _indir(target,srcdir:string;xs:tobject;write:boolean):string;
var permfile,targfile,targdir,srcnorm,targnorm:string;
begin
     result:='INVALIDFILENAME?\'+target;
     if AnsiContainsText(target,'>') then exit;
     if AnsiContainsText(target,'|') then exit;
     if AnsiContainsText(target,'<') then exit;
     //targnorm:=lowercase(ExpandFileName(target) { *Converted from ExpandFileName*  });
     //srcnorm:=lowercase(ExpandFileName(srcdir) { *Converted from ExpandFileName*  });
     //targfile:=lowercase(extractfilename(targnorm));
     //targnorm:=lowercase(ExpandFileName(target) { *Converted from ExpandFileName*  });
     targnorm:=(ExpandFileName(target) { *Converted from ExpandFileName*  });
     srcnorm:=(ExpandFileName(srcdir) { *Converted from ExpandFileName*  });
     targfile:=(extractfilename(targnorm));
     targdir:=extractfilepath(targnorm);
     if pos(srcnorm, targdir)=1 then
     begin
        //writeln('<li>'+targnorm, ' is subof ',srcnorm);
        result:=targnorm;
        exit;
     end;

     //writeln('<li>allow |'+targdir+'|'+targfile,'| for:',srcnorm);
     if write then
     permfile:=_findfileupstream(targdir,'.xseuswrite',0) else
     permfile:=_findfileupstream(targdir,'.xseusread',0);
     if permfile='' then
     begin
       writeln('no permissions to:',target,write);
       exit;
     end;
     //if pos(extractfilepath(permfile),srcnorm)=1 then
     //  writeln('<li>subfilepermissions from |'+permfile+'|for:'+srcnorm+'('+extractfilepath(permfile))
     //else  writeln('<li>anyfilepermissions from |'+permfile+'|for:'+srcnorm);

     result:=targdir+targfile;

end;

function _oldindir(target,srcdir:string;testallow:boolean;xs:tobject):string;
//NEEDS RETHINKING AND REWRITING
var targdir,tfile,trest,srest:string;haveright:boolean;//adir:tdirectoryinfo;
     begin
  try
      if pos('http://',target)=1 then
      begin
        result:=target;exit;
      end;
     result:='INVALIDFILENAME?\'+target;
     if AnsiContainsText(target,'>') then exit;
     if AnsiContainsText(target,'|') then exit;
     if AnsiContainsText(target,'<') then exit;
     testallow:=false;
     target:=ansilowercase(target);
     targdir:=extractfiledir(target);//+g_ds;
     //if (targdir='\') or
     if (targdir='\\') then targdir:=g_ds;
     tfile:=extractfilename(target);
     //     writeln('indir ?: '+target+'/srcdir:'+srcdir+'/targdir:'+targdir+'/filename:'+tfile);
     {       writeln('commonpath ?: <li>'+target,
            '<li> from '+srcdir+'<li> common:'
        ,_matchhead(target,srcdir,trest,srest),
        '<li> tailtarg:',trest,
        ' <li>srest:',srest);
       writeln('<li> tailtarg:',trest,' <li>srest:',srest);
     }
     if targdir='' then
      targdir:=srcdir else
     targdir:=_relpath(targdir,srcdir)+g_ds;
      //    writeln('reldir ?: '+targdir);
   //  targdir:=StringReplace(targdir,'|','',[rfreplaceall]);
   //  targdir:=StringReplace(targdir,'>','',[rfreplaceall]);

      srcdir:=ansilowercase(srcdir);
      if testallow or (pos(srcdir,targdir)=1) then
      begin
       result:=targdir+''+tfile;
       //writeln('indir ok: '+targdir+' from '+srcdir+'='+result);
       exit;
      end;
      //getdirectoryparent(targdir);

      if testallow=testallow then
        begin
          haveright:=_haveright(targdir,srcdir,'r',txseus(xs));
          if haveright then
          begin
            result:=targdir+''+tfile;exit;
          end;
          if (fileupexists(targdir,'.xseusallow')) then
          begin
            result:=targdir+''+tfile;
            exit;
          end
           else
          begin
            writeln('Forbidden: no permission for: '+targdir+'.xseusallow in '+srcdir);
            exit;
          end;
        end;
      finally
         //   writeln('indir: '+targdir+' from '+srcdir+'='+result);
      end
end;

{
//function _text2html(txt:tstringlist;acom,xform:ttag):tstringlist;
procedure _text2html(var res:tstringlist;txt:tstringlist;acom,xform:ttag);
var cv:tconverter;opts:ttag;
begin
  cv:=tconverter.create;
  cv.inst:=txt;

    cv._debug:=false;if acom.att('doh')<>'' then cv.op.doh:=true;
  if acom.att('dop')<>'' then cv.op.dop:=true;
  if acom.att('dou')<>'' then cv.op.dourls:=true;
  if acom.att('dot')<>'' then cv.op.dotabs:=true;
  if acom.att('doexl')<>'' then cv.op.doexl:=true;
  if acom.att('dom')<>'' then cv.op.domail:=true;
  if acom.att('dol')<>'' then cv.op.dolist:=true;
  if acom.att('h1')<>'' then cv.op.h1:=acom.att('h1');
  if acom.att('h2')<>'' then cv.op.h2:=acom.att('h2');
  if acom.att('h3')<>'' then cv.op.h3:=acom.att('h3');
  if acom.att('empties')<>'' then cv.op.empties:=true;
  if acom.att('dots')<>'' then
  begin
   _h1('dots');
   cv.op.dots:=true;
  end;
  cv.op.hlev:=strtointdef(acom.att('hlev'),0);
opts:=acom.subt('formoptions');
 if opts<>nil then
begin
 if opts.att('doh')<>'' then cv.op.doh:=true;
 if opts.att('dop')<>'' then cv.op.dop:=true;
 if opts.att('dol')<>'' then cv.op.dolist:=true;
 if opts.att('dot')<>'' then cv.op.dotabs:=true;
 if opts.att('dots')<>'' then cv.op.dots:=true;
 if opts.att('doexl')<>'' then cv.op.doexl:=true;
 if opts.att('empties')<>'' then cv.op.empties:=true;
 if opts.att('dou')<>'' then cv.op.dourls:=true;
 if opts.att('dom')<>'' then cv.op.domail:=true;
  if opts.att('h1')<>'' then cv.op.h1:=opts.att('h1');
  if opts.att('h2')<>'' then cv.op.h2:=opts.att('h2');
  if opts.att('h3')<>'' then cv.op.h3:=opts.att('h3');
  cv.op.hlev:=strtointdef(opts.att('hlev'),0);

end;



cv.op.heads:=false;
cv.op.accepthtml:=true;

cv.makehtml;

//result:=tstringlist.create;
//result.addstrings(cv.outst);
res.addstrings(cv.outst);

cv.op.free;

cv.outst.free;
//cv.inst.free;
//exit;
 cv.free;
end;
}
procedure _cleancdata(acom,xform:ttag);
var st:string;
ot,nt:ttag;
begin
 ot:=xform.subt(acom.att('in'));
 if ot=nil
 then exit;
 nt:=ttag.create;
 nt.vari:=acom.att('out');
 st:=ot.vali;
 if pos('<![CDATA[',st)>0 then
 begin
   st:=copy(st,10,length(st)-12);
   //  writeln('<li>X:'+ot.vari
  // +'<xmp>'+ot.vali+'----'+st+'</xmp>');

   //writeln('CDATAA:<hr><xmp>'+_clean(st)+'</xmp><hr>');
  nt.vali:=_clean(st);
 end else if ot.subt('cdata')<>nil then
 begin
    nt.vali:=_clean(ot.subt('cdata').vali);
 end;
 xform.subtagsadd(nt);
end;


function _ataghaveright(rigtag:ttag;fromdir,todir,rig:string):boolean;
var j:integer;aput2:ttag;
begin
    result:=false;
    for j:=0 to rigtag.subtags.count-1 do
    begin
      aput2:=rigtag.subtags[j];
      if aput2.vari='file' then
      if _matches(aput2.att('from'),fromdir) then
      if  todir=aput2.att('to') then
      begin
        result:=true;
        exit;
      end;
    end;
end;

function _haveright(todir,fromdir,rig:string;xs:tobject):boolean;
var  aput,aput2:ttag;i:integer;
begin
 result:=false;
  result:=_ataghaveright(txseus(xs).x_rights,fromdir,todir,rig);
  if result then exit;

    if (FileExists((todir)+g_ds+'rights.htme')) then
          begin
           aput:=tagfromfile((todir)+g_ds+'rights.htme',nil);
           //aput:=ttag.create;
           //aput.fromfile((todir)+g_ds+'rights.htme',nil);
           //aput:=aput.subtags[0];

           for i:=0 to aput.subtags.count-1 do
           begin
            aput2:=ttag(aput.subtags[i]).copytag;
            txseus(xs).x_rights.subtags.add(aput2);
            aput2.setatt('to',todir);
           end;
           result:=_ataghaveright(aput,fromdir,todir,rig);
           aput.killtree;aput2.clearmee;
    end;end;
procedure _h1(st:string);
begin
 writeln('<h1>'+st+'</h1>');
end;
{function indypost(server,fil,form,headers:string):string;
var http:tidhttp;i:integer;
  InStream:   TMemoryStream;
resu:tstringlist;list,headerslist:tstringlist;
vari,vali:string; stdprop:PPropInfo;
begin
  http := TIdHTTP.Create(nil);
 resu:=tstringlist.create;
 list:=tstringlist.create;
 list.add('<huihai/>');
 headerslist:=tstringlist.create;

 HTTP.Request.Clear;
  try
    InStream := TMemoryStream.Create;
      try
     HTTP.post('http://'+server+fil,list, InStream);
       except
          end;
      InStream.Position := 0;
    resu.LoadFromStream(InStream);
    InStream.Position := 0;
    result:=resu.text;
  finally
   InStream.Free;
    http.free;
  end;
end;

function indyget(gurl:string):string;
var idhttp1:tidhttp;
  InStream:   TMemoryStream;
resu:tstringlist;url:string;
begin
 url:=gurl;
  idhttp1 := TIdHTTP.Create(nil);
  resu:=tstringlist.create;
  IdHTTP1.Request.Clear;
  idhttp1.HandleRedirects:=true;
  try
    InStream := TMemoryStream.Create;
      try
        IdHTTP1.Get(url, InStream);
      except
        end;
      InStream.Position := 0;
    resu.LoadFromStream(InStream);
    InStream.Position := 0;
  finally
    InStream.Free;
    result:=resu.text;
    idhttp1.free;
    resu.Clear;resu.Free;
  end;
end;
}
function _testrights(session:ttag;dir,role,by:string):boolean;
var i:integer;aputag:ttag;
begin
  try
       result:=false;
       for i:=0 to session.subtags.count-1 do
       begin
         aputag:=session.subtags[i];
         //listwrite(aputag);
         if aputag.vari='aukt' then
         begin
           //x1:=_ubstitute(acom.att('dir'),selst,state,xs);
           //x2:=_ubstitute(acom.att('role'),selst,state,xs);
           //x3:=_ubstitute(acom.att('by'),selst,state,xs);
           //writeln('<li>authdir: '+x1 +'todir: '+aputag.att('dir'));
           if (pos((aputag.att('dir')),(dir))=1)
           then
           begin
            //if aputag<>nil then  writeln('<li>ok to ' +aputag.att('dir'),result,'</li>');
            result:=true;
           end;

         end;
       end;
 except
   _h1('eikäy rights');listwrite(session);
     writeln('<li>dir:',dir,'</li>');

 end;
 // writeln('<li>ok to ' +dir,result,'</li>');
 // listwrite(session);
 end;

{ function _isnumlist(cs:string;var levs,llen:integer):boolean;
var i:integer;innum:boolean;
begin
 result:=false;
 levs:=0;llen:=1;innum:=true;
  for i:=1 to length(cs) do
   if pos(cs[i],' '+#09)>0 then
   begin
    if innum then levs:=levs+1;
    break;
   end else
   if cs[i]='.' then
   begin
     levs:=levs+1;
     llen:=llen+1;
     innum:=false;
     result:=true;
   end else
   if (pos(cs[i],'1234567890')>0) then
   begin
    llen:=llen+1;
    innum:=true;
   end
   else
   begin
    result:=false;
    break;
   end;

end;
 }




type tjson=class(tobject)
   //-- added public
public

 src:string;resu:string;
  curpos,stpos,epos,len:integer;
 function getstring:string;
 function getlist(vari:string):ttag;
 function getobjects(basetag:ttag;liststring:string):boolean;
 constructor create(sr:string);
end;

function tjson.getobjects(basetag:ttag;liststring:string):boolean;
var ch:char;start,hasvali,hasvari,inlist:boolean;restag:ttag;ast,listvari:string;
begin
try
 restag:=ttag.create;
 basetag.subtags.Add(restag);
   restag.parent:=basetag;
 restag.vari:=liststring;
 inlist:=false;
  if liststring<>''  then
   inlist:=true;
 hasvari:=inlist;
 while  (curpos<len) do
 begin
   curpos:=curpos+1;
   ch:=(src[curpos]);
   try
   if ch='"' then
   begin
     ast:=getstring;
     if hasvari then
     begin
       restag.vali:=ast;
     end
     else
     begin
         restag.vari:=ast;
         hasvari:=true;
     end;
   end
   else
   if ch='}' then exit else
   if ch='{' then
   begin
    getobjects(restag,'')
   end else
   if ch=',' then
   begin
     restag:=ttag.create;
     basetag.subtags.add(restag);
     restag.parent:=basetag;
     if hasvari then restag.vari:=liststring;
     if not inlist then hasvari:=false;
   end else
   if ch='[' then
   begin
     basetag.subtags.delete(basetag.subtags.Count-1);
     getobjects(basetag,restag.vari);
   end else
   if ch=']' then
   begin
       exit
   end;// else igmored chars, whitespace etc
   except writeln('faileddojsonele'+ch);

   end;
 end;
finally
end;
end;


function tjson.getstring:string;
var ch,nch:char;
begin
 result:='';
 curpos:=curpos+1;
 repeat
       ch:=src[curpos];
       if ch='"' then exit;
       if ch='\' then
       begin
          nch:=src[curpos+1];
          curpos:=curpos+2;
          case nch of
           '"':result:='"';
           '\':result:=result+'\';
           '/':result:=result+'/';
           'f':result:=^J;
           'n':result:=result+crlf;
           'r':result:=^M;
           't':result:=^I;
           'b':result:=^H;
           else curpos:=curpos-1;
          end;
       end
       else
       begin
          result:=result+src[curpos];
          curpos:=curpos+1;
       end;
   until curpos>len;

end;
function tjson.getlist(vari:string):ttag;
begin
end;

constructor tjson.create(sr:string);
begin
 src:=sr;
 curpos:=1;
 len:=length(src);
end;

function _json(src:string):ttag;
var js:tjson;i,j:integer;basetag:ttag;
begin
  js:=tjson.create(src);
  //writeln('jiisoni:<xmp>'+src+'</xmp>');
  while (js.src[js.curpos]<>'{') and (js.curpos<js.len) do
   js.curpos:=js.curpos+1;
   result:=ttag.create;
   js.getobjects(result,'');
   result:=result.subtags[0];
end;

function _listjson(ftag:ttag):ttag;
var js:tjson;i,j:integer;basetag:ttag;
begin

end;

type tical=class(tobject)
 //-- added public
public
 //src:string;resu:string;
 icsrc:tstringlist;
 basetag:ttag;curline:integer;
 function getstring:string;
 function getlist(vari:string):ttag;
function getline(var curst:integer;par:ttag;ast:string):ttag;
 constructor create(sr:string);
  private
    function getlines(par:ttag): ttag;
end;

function tical.getline(var curst:integer;par:ttag;ast:string):ttag;
var ch:char;start,hasvali,hasvari,inlist:boolean;restag:ttag;aaast,listvari:string;
  len,curpos,stpos,epos:integer;
  function getvar:string;
  begin
    result:='';
     while  (curpos<len) do
     begin  //getvar
       ch:=ast[curpos];
       if pos(ch,';: ')>0 then break;
       result:=result+ch;
       curpos:=curpos+1;
     end;
  end;
  function getpar:string;
  var inquote:boolean;
  begin
    inquote:=false;
    result:='';
    curpos:=curpos+1;
     while  (curpos<len) do
     begin  //getvar
       ch:=ast[curpos];
       if ch='"' then inquote:=not inquote else
       if not inquote then
        if pos(ch,';:')>0 then break;
       result:=result+ch;
       curpos:=curpos+1;
     end;
  end;
begin
try
 //ast:=icsrc[curst];
 restag:=ttag.create;
 result:=restag;
 len:=length(ast);
 curpos:=1;
 restag.vari:=getvar;
 while (curpos<len) and (ch=';') do
 begin
  restag.setatt(cut_ls(getpar),cut_rs(getpar));
 end;
 restag.vali:=copy(ast,curpos+1,99999);
   except
    writeln('failedical:'+ast,curpos);
   end;

   end;

function tical.getlines(par:ttag):ttag;
var gottag,prevtag:ttag;
begin
  while curline< icsrc.Count  do
  begin
   //writeln('<li>',curline,icsrc.strings[curline]+'/X</li>');
   gottag:=getline(curline,par,icsrc[curline]);
   curline:=curline+1;
   if curline>1000 then break;

   if gottag.vari='BEGIN' then
   begin
     gottag.vari:=gottag.vali;
     gottag.vali:='';
     getlines(gottag);

   end else
   if gottag.vari='END' then
   begin
     exit;
   end;
   if gottag.vari='' then
   begin
     //gottag.parent:=prevtag;
     //prevtag.subtags.add(gottag);
     prevtag.vali:=prevtag.vali+gottag.vali;

   end
   else
   begin
     gottag.parent:=par;
     par.subtags.add(gottag);
     prevtag:=gottag;
   end;
end;
 result:=par;
 end;


function tical.getstring:string;
var ch,nch:char;curpos:integer;
begin
{ result:='';
 curpos:=1;//curpos+1;
 repeat
       ch:=src[curpos];
       if ch='"' then exit;
       if ch='\' then
       begin
          nch:=src[curpos+1];
          curpos:=curpos+2;
          case nch of
           '"':result:='"';
           '\':result:=result+'\';
           '/':result:=result+'/';
           'f':result:=^J;
           'n':result:=result+crlf;
           'r':result:=^M;
           't':result:=^I;
           'b':result:=^H;
           else curpos:=curpos-1;
          end;
       end
       else
       begin
          result:=result+src[curpos];
          curpos:=curpos+1;
       end;
   until curpos>len;
 }
end;
function tical.getlist(vari:string):ttag;
begin
end;

constructor tical.create(sr:string);
var i:integer;
begin
 //src:=sr;
 icsrc:=tstringlist.create;
 icsrc.text:=sr;
 basetag:=ttag.create;
 basetag.vari:='icalendar';
 curline:=0;
 //len:=icsrc.count;

end;

function _ical(src:string):ttag;
var ic:tical;i,j:integer;
begin
  ic:=tical.create(src);
  result:=ic.getlines(ic.basetag);

  //writeln('iicali:<xmp>'+ic.basetag.xmlis+'</xmp>');
  //result:=ic.basetag;//result.subtags[0];
  //writeln('didiical:');
end;

function _listical(ftag:ttag):ttag;
var ic:tical;i,j:integer;basetag:ttag;
begin

end;

function parseone(s:string;sta:integer;res:ttag):integer;
var i:integer;nres:ttag;
begin
  writeln('**parseone',copy(s,sta,99999));

 //res.addsubtag('blockquote','');

 i := sta;
 while i<length(s) do
 begin
   i:=i+1;
   result:=i;
   if s[i]=']' then
   begin
    res.addsubtag('subtag',res.vari+':'+inttostr(res.subtags.count)+copy(s,sta,i-sta));
    exit;
   end
   else
   if s[i]='[' then
   begin
     if res.subtags.Count=0 then
      res.vali:=copy(s,sta,i-sta)
     else
     res.addsubtag('div',copy(s,sta,i-sta));
     //nres:=ttag.create;
     //nres.vari:='turha';
     i:=parseone(s,i+1,res)+1;
     sta:=i;
     //res.subtags.add(nres);
   end;
 end;
 res.addsubtag('ediv',copy(s,sta,result-sta+1));


end;
procedure _replaceparts(pagetext: string; comtag: string; var possta, posen: integer);
var
  sp, ep: integer;
  apart: string;
begin
  try
    possta := 0;
    posen := 0;
    sp := pos('<!--' + comtag + '-->', pagetext);
    if sp < 1 then
    begin
      possta := -1;
      posen := -1;
      exit;
    end;
    sp := sp + 8 + length(comtag);
    apart := copy(pagetext, sp, length(pagetext) - 1);
    ep := pos('<!--/' + comtag + '-->', apart) - 1;
    possta := sp;
    posen := ep;
  except
    writeln('failed to replace in html-file');
  end;
end;



procedure _pokehtml(acom, xml: ttag; dir: string; xs: pointer);
var
  i, j, res: integer;
  coms, scom: ttag;
  apage: TStringList;
  pss, pse, pes, pee: integer;
  newp, itext: TStringList;
  n: tdatetime;
  ofil, fil, rep, fn: string;

begin
  try
    n := now;
    ofil := '';
    apage := TStringList.Create;
    newp := TStringList.Create;
    try
      pss := 0;
      scom := acom;
      ofil := fil;
      fil := _indir(scom.att('in'), dir, xs, True);
      if acom.att('text') <> '' then
        rep := acom.att('text')
      else
      if acom.att('includefile') <> '' then
        //--if FileExistsUTF8(acom.att('includefile')) { *Converted from FileExists*  } then
        if FileExists(acom.att('includefile')) { *Converted from FileExists*  } then
        begin
          itext := TStringList.Create;
          itext.loadfromfile(acom.att('includefile'));
          rep := itext.Text;
          itext.Clear;
          itext.Free;
        end;
      if fil = '' then
        exit;
      fn := copy(fil, 1, length(fil) - length(extractfileext(fil))) + '_navi.htm';
      //--if FileExistsUTF8(fn) { *Converted from FileExists*  }  then
      if FileExists(fn) { *Converted from FileExists*  } then
      begin
        fil := fn;
      end;
      //--if not FileExistsUTF8(fil) { *Converted from FileExists*  } then exit;
      if not FileExists(fil) { *Converted from FileExists*  } then
        exit;
      apage.loadfromfile(fil);
    except
      writeln('failed to read file to replace');
      listwrite(scom);
    end;
    try
      _replaceparts(apage.Text,
        scom.att('comtag'), pss, pse);
    except
      writeln('failed to to replace');
    end;
    try
      newp.add(copy(apage.Text, 1, pss));
      newp.add(rep);
      newp.add(copy(apage.Text, pss + pse, length(apage.Text)));
      newp.savetofile(fil);
      newp.Clear;
    except
      writeln('failed create new page replace');
    end;

  except
    writeln('failed to replace in html-files 2');
  end;
  newp.Free;
  apage.Free;
end;

//type TCompareFunc = function(Item1, Item2: ttag): Integer;


constructor ttagsorter.create(st:string);
var sels:tstringlist;     i:integer;arec:tasorter;
begin
 recs:=tstringlist.create;
 _split(st,';',recs);
 for i:=0 to recs.count-1 do
 begin
   arec:=tasorter.create;//new(pasorter);
   arec.orde:=1;
   arec.numcomp:=false;
   if pos('#',recs[i])=1 then
   begin
     recs[i]:=copy(recs[i],2,999);
     arec.numcomp:=true;
   end;
   if pos('-',recs[i])=1 then
   begin
      recs[i]:=copy(recs[i],2,999);
      arec.orde:=-1;
   end else
   if pos('+',recs[i])=1 then
   begin
     recs[i]:=copy(recs[i],2,999);
     arec.orde:=1;
   end;
   recs.objects[i]:=arec;
   //arec.orde:=1;
end;
// writeln('<li>sssssssoort', recs.text,recs.count);
end;

destructor ttagsorter.free;
var i:integer;
begin
  for i:=0 to recs.count-1 do tasorter(recs.objects[i]).free;
  recs.free;//ords.free;typ.free;
  //inherited free;

end;

threadvar t_listsorter:ttagsorter;

function mycompare(A1,A2:pointer): Integer;
var i,neg,si:integer;arec:tasorter;s1,s2,str:string;n1,n2:float;gt,lt:boolean;ocur:ttag;
begin
//propValueP1 :=
//GetPropValue(A1, 'PropertyName', False);
//result:=1;exit;
for i:=0 to t_listsorter.recs.count-1 do
begin
  try
   str:=t_listsorter.recs[i];
   if str='' then continue;
   arec:=tasorter(t_listsorter.recs.objects[i]);
   if pos('?',str)=1 then
   begin
   s1:=parsefromele(a1,str);
   s2:=parsefromele(a2,str);
   end else
   begin
   s1:=ttag(a1).subs(str);
   try
   s2:=ttag(a2).subs(str);
   except
     writeln('<li>failed to get tag to compare',ttag(a2).xmlis);raise;
   end;
   end;
  except writeln('<li>failed get <b>',t_listsorter.recs[i],'</b> to compare'+s1,'!!!',s2+'/');writeln('  /a1',ttag(a1).head);writeln('  /a2',ttag(a2).head);raise;end;
   //test:=s1>s2;
   if arec.numcomp then
   begin
        n1:=strtofloatdef(s1,0);
        n2:=strtofloatdef(s2,0);
        //test:=n1>n2;
   end;
  if ((arec.numcomp) and (n1>n2)) or (s1>s2) then
    begin
       result:=arec.orde;
       break;
    end else
    if ((arec.numcomp) and (n1<n2)) or (s1<s2) then
      begin
         result:=0-arec.orde;
         break;
      end else
      result:=0;
      //writeln('<li>',result,'  ', s1,'!',s2,'!!',t_listsorter.recs[i]);

end;
  //writeln('<li>compare:'+str,': ',ttag(a1).vari,'(',s1,')   /  ',ttag(a2).vari,'(',s2,')=',result);

end;
function _dosort(slist:tlist;st:string): boolean;
var //slist:tlist;
    i:integer;
begin

 //for i:=0 to slist.count-1 do writeln('<li>o:',i,'/'+ttag(slist[i]).head);

   try  t_listsorter:=ttagsorter.create(st);  except writeln('<li>failed to create sorter');end;
   try  slist.sort(@mycompare);    except writeln('<li>failed to sortby sorter');raise;
  //  for i:=
   end;
   t_listsorter.free;
  //slist.addlist(curfromele.subtags);    except writeln('<li>failed to add items to  sorter');end;

 // try
  // for i:=0 to slist.count-1 do writeln('<li>',i,'/'+ttag(slist[i]).head);
 //    except writeln('<li>failed to list unsorted');end;
  //writeln('<li>gosort:',slist.count,curfromele.head);
// try
 // for i:=0 to slist.count-1 do writeln('<li>s:',i,'/'+ttag(slist[i]).head);
  //  except writeln('<li>failed to list sorted');end;
end;




end.

{

function txseus.c_htmlnavi(state: tstate): boolean;
{D: one of several attempts to handle writing of content into html-files
  that have navigation etc in place. Probably not the best one
}
var
  i, j, res: integer;
  acom, coms, scom: ttag;
  apage: TStringList;
  pss, pse, pes, pee: integer;
  newp: TStringList;
  n: tdatetime;
  ofil, fil, rep, fn: string;

begin
  try
    acom := state.appta;
    n := now;
    ofil := '';
    coms := xml.subt(acom.att('commands'));
    apage := TStringList.Create;
    newp := TStringList.Create;
    for i := 0 to coms.subtags.Count - 1 do
    begin
      try
        pss := 0;
        scom := ttag(coms.subtags[i]);
        ofil := fil;
        fil := scom.att('in');
        rep := scom.vali;
        if fil = '' then
          continue;
        fn := copy(fil, 1, length(fil) - length(extractfileext(fil))) + '_navi.htm';
        //--if FileExistsUTF8(fn) { *Converted from FileExists*  }  then
        if FileExists(fn) { *Converted from FileExists*  } then
        begin
          fil := fn;
        end;
      except
        _com('failed in htmlnavi');
      end;
      if fil <> ofil then
      begin
        try
          if newp.Count > 0 then
          begin
            try
              newp.savetofile(ofil);
            except
              _h1('failed to save file to replace: ' + ofil);
            end;
          end;
          newp.Clear;
          apage.Clear;
        except
          _h1('failed to find file to replace: ' + fil);
        end;
        try
          //if not FileExistsUTF8(fil) { *Converted from FileExists*  } then continue;
          if not FileExists(fil) { *Converted from FileExists*  } then
            continue;
          apage.loadfromfile(fil);
        except
          _h1('failed to read file to replace: ' + fil);
        end;

      end
      else
      begin
        try
          apage.Clear;
          apage.addstrings(newp);
          newp.Clear;
        except
          _com('failed to read file to replace');
        end;

      end;
      try
        _replaceparts(apage.Text,
          scom.att('comtag'), pss, pse);
      except
        writeln('failed to to replace');
      end;
      try
        if pss > 0 then
        begin
          newp.add(copy(apage.Text, 1, pss));
          newp.add(rep);
          newp.add(copy(apage.Text, pss + pse, length(apage.Text)));
          if i = coms.subtags.Count - 1 then
          begin
            newp.savetofile(fil);
            newp.Clear;
          end;
        end;
      except
        writeln('failed create new page replace');
      end;

    end;
  except
    writeln('failed to replace in html-files 2');
  end;
  apage.Free;
  newp.Free;
end;

function txseus.c_gethtmlpart(state: tstate): boolean;
{D: one of several outdated attempts to handle writing of content into html-files
  that have navigation etc in place. Probably not the best one
}
var
  i, j, res, sp, ep: integer;
  coms, acom: ttag;
  apage: TStringList;
  pagetext: string;
  comtag: string;
var
  possta, posen: integer;
  apart: string;
begin
  try
    try
      acom := state.appta;
      apage := TStringList.Create;
      apage.loadfromfile(acom.att('file'));
    except
      writeln('failed to find html-file');
      listwrite(acom);
    end;
    pagetext := apage.Text;
    possta := 0;
    posen := 0;
    comtag := acom.att('comtag');
    if comtag = '' then
    begin
      exit;
    end
    else
    begin
      sp := pos('<!--' + comtag + '-->', pagetext);
      if sp < 1 then
      begin
        exit;
      end;
      sp := sp + 8 + length(comtag);
      apart := copy(pagetext, sp, length(pagetext));
      ep := pos('<!--/' + comtag + '-->', apart) - 1;
      apart := copy(apart, 1, ep);
    end;
  except
    writeln('failed to import in html-file');
    listwrite(acom);
  end;
  xml.addsubtag(state.appta.att('element'), apart);
  apage.Free;
end;





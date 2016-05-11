unit xseauth;

{$mode delphi}

interface

uses
  Classes, SysUtils,xsemisc,xsexml,xseglob;
function auth_report:boolean;
//debugging, see what we have

function auth_login: boolean;
// writes a default format line to session-element (tat is preserved - saved in global server space - between http-calls

function auth_checkauth(xsp:pointer):boolean;
function auth_getauthorization:boolean;
function auth_readauthorization:boolean;
function auth_authorize:boolean;
function auth_session:boolean;
function _ataghaveright(rigtag:ttag;fromdir,todir,rig:string):boolean;
function _testrights(session:ttag;dir,role,by:string):boolean;
// checks if current session has authorization _role_ in _dir_ .. old, not tested, perhaps unnecessary

{function _haveright(todir,fromdir,rig:string;xs:tobject):boolean;
function _authorizebyentryword(outdiri:string;acom: ttag):string;
//old, not tested, perhaps not needed - easy to write in xseus-script
function _authorizebyuser(outdiri, role, password, user: string; acom: ttag;  xml: ttag; sestag:ttag): boolean;
 }


// OPENID Client  .. not tested recently
type toid = class(tobject)
assoc_handle,claimed_id,identity,mode,ns, oauth,realm,return_to,trust_root,signed,nonce:string;
procedure populate;
function taggaa:ttag;
function get(url:string):string;
function redirect(url,nonc:string):string;
function tostr:string;
function check_auth(url:string;params:ttag):ttag;

end;
implementation
uses xsexse,xserver;

function auth_report:boolean;
 var xs:txseus;acom,aputag,at,oldto,ses,log,alog:ttag;i,slaspos:integer;done:boolean;
   fname,fromfile:string;
 begin
  xs:= txseus(t_currentxseus);
  ses:=xs.x_session;
  acom:=xs.CurBYEle;
  if ses=nil then
  begin writeln('<li>NO SESSION, NO RIGHTS TO ANYTHING. Try reloading</li>');exit
  end;
  log:=ses.subt('login');
  if log=nil then
  begin writeln('<li>NO Login, NO RIGHTS TO ANYTHING. </li>');
    //find all login.htmi's upstream
    fname:=acom.att('file');
    if fname='' then fname:='login.htmi';

    //fromdir:=copy(xs.x_url,1,slaspos);
    fromfile:=_mapurltofile(xs.x_url,g_xseuscfg.subt('urlpaths'));
    slaspos:=_poslast(g_ds,fromfile)-1;
    while slaspos>0 do
    begin
      fromfile:=copy(fromfile,1,slaspos);
      writeln('<li>fromdir:'+fromfile,slaspos);
      if fileexists(fromfile+g_ds+fname) then
      begin
       alog:=tagfromfile(fromfile+g_ds+fname,nil);
        writeln('from:<xmp>'+alog.xmlis+'</xmp>'+fromfile);


      end;
      slaspos:=_poslast(g_ds,fromfile)-1;

    end;
  end;



end;

function auth_session:boolean;
var xs:txseus;acom,aputag,at,oldto:ttag;i:integer;
begin
 xs:= txseus(t_currentxseus);
 acom := xs.CurBYEle;
  if xs.x_session <> nil then
  begin
    aputag := ttag.Create;
    oldto := xs.curtoele;
    xs.CurToEle := aputag;
    xs.dosubelements;
    try
      if aputag.subtags.Count = 0 then
        listwrite(xs.x_session)
      else
        for i := 0 to aputag.subtags.Count - 1 do
        begin
          at := ttag(aputag.subtags[i]).copytag;
          xs.x_session.subtags.add(at);
          at.parent := xs.x_session;
          at.setatt('domain', xs.x_object.att('app'));
          //ttag(aputag.subtags[k]).att('by']:=x_object.att('url');
        end;
      //writeln('Cookies;<xmp>', tserving(x_serving).cookies.Text, '<xmp>');
      aputag.killtree;
      xs.curtoele := oldto;
      //writeln('<!--SESSION:'+xs.x_session.xmlis+'-->');
    finally //writeln('ENDOFSESSTAG');
    end;
  end;
end;
function auth_readauthorization:boolean;
var fromdir,fname,fromfile:string;xs:txseus;acom,alog:ttag;
begin
 xs:= txseus(t_currentxseus);
 acom := xs.CurBYEle;
 fname:=acom.att('file');
 if fname='' then fname:='login.htmi';
 fromdir:=copy(xs.x_url,1,_poslast(g_ds,xs.x_url)-1);

 fromfile:=_mapurltofile(fromdir+g_ds+fname,g_xseuscfg.subt('urlpaths'));
 writeln('<li>from:'+fromfile);
 while pos(g_ds,fromdir)>0 do
 begin
   fromdir:=copy(fromdir,1,_poslast(g_ds,fromdir)-1);
   fromfile:=_mapurltofile(fromdir+g_ds+fname,g_xseuscfg.subt('urlpaths'));
   writeln('<li>from:'+fromdir+'                    <li>file:'+fromfile);
   if fileexists(fromfile) then
   begin
    alog:=tagfromfile(fromfile,nil);
     writeln('from:<xmp>'+alog.xmlis+'</xmp>'+fromfile);


   end;

 end;
end;

function auth_checkauth(xsp:pointer):boolean;
  procedure _aint(ast:string;var oint:integer);
  begin
   //writeln('<li>tryreq:',ast,'/',oint);
   if ast='' then exit;
   //case ast of  'guest': result:=1; end;
      if ast='guest' then oint:=1 else
        if ast='user' then oint:=2 else
          if ast='poweruser' then oint:=3 else
            if ast='admin' then oint:=4 else
              if ast='owner' then oint:=5;
  end;

var i,mreq:integer;ses,aau:TTAG;cur:string;xs:txseus;
begin
 xs:=xsp; mreq:=0;
 result:=true;
 _aint(xs.x_handlers.att('require'),mreq);
 _aint(xs.x_myhandler.att('require'),mreq);
 _aint(xs.x_data.att('require'),mreq);

 cur:=txseus(xsp).x_url;
 cur:=copy(cur,1,_poslast('/',cur)-1);
 ses:=txseus(xsp).x_session;
 if mreq=0 then exit;
 //result:=false;
 for i:=0 to ses.subtags.count-1 do
 begin
  aau:=ses.subtags[i];
  if (aau.vari<>'allow') then continue;
  if pos(aau.att('to'),cur)<>1 then continue;
  result:=true;
 end;
result:=true;
end;


function auth_authorize: boolean;
{D: writes authorization data to session-tag (persistent data for a user-session over separate
  xseus-tasks. }
var
  todir: string;
  j: integer;
  aputag, acom, dom,adom,ses: ttag;
  xs:txseus;
begin
  aputag:=nil;
  xs:= txseus(t_currentxseus);
  acom:=xs.curbyele;
  todir:=xs.x_url;
  writeln('<li>todir:'+todir+'!'+copy(todir,1,_poslast('/',todir)-1));
  //exit;
  todir:=copy(todir,1,_poslast('/',todir)-1);
  ses:=xs.x_session;
  writeln('<li>SES:',ses.xmlis+'!!!');
  aputag:=ses.subt('+allow[@by='+todir+']');
  writeln('<li>SES:',ses.xmlis+'!!!');
  aputag.setatt('name', acom.att('name'));
  aputag.setatt('subdir', extractfilepath(xs.x_url));// dom.att('name'));
  aputag.setatt('idi', acom.att('idi'));
  aputag.setatt('role', acom.att('role'));
  writeln('<xmp>'+aputag.xmlis+'</xmp>');
end;

function auth_login: boolean;
{D: writes authorization data to session-tag (persistent data for a user-session over separate
  xseus-tasks. }
var
  todir: string;
  j: integer;
  aputag, acom, dom,adom,ses: ttag;
  xs:txseus;
begin
  aputag:=nil;
  xs:= txseus(t_currentxseus);
  acom:=xs.curbyele;
  todir:=xs.x_url;
  //writeln('<li>todir:'+todir+'!'+copy(todir,1,_poslast('/',todir)-1));

  todir:=copy(todir,1,_poslast('/',todir)-1);
  ses:=xs.x_session;
  for  j := 0 to ses.subtags.Count - 1 do
    if ttag(ses.subtags[j]).att('by') = todir then
    begin
     //writeln('<li>foundone:'+ses.xmlis);
      aputag := ses.subtags[j];
      break;
    end;

  //writeln('<li>Checksession:'+ses.head,aputag=nil);
  if aputag = nil then
  begin
   //writeln('<li>NIL:',ses.xmlis+'!!!');
   aputag:=ses.subt('+login');
   aputag.setatt('by',todir);
  end;
  //writeln('<li>obj:',aputag.xmlis+'!!!');
  aputag.setatt('name', acom.att('name'));
  //x_session . attributes . values ['domain' ] := acom . att ('domain' ) ;

  //aputag.setatt('subdir', extractfilepath(xs.x_url));// dom.att('name'));
  aputag.setatt('subdir', extractfilepath(xs.x_url));// dom.att('name'));
  aputag.setatt('idi', acom.att('idi'));
  aputag.setatt('role', acom.att('role'));
  //writeln('sofar2'+aputag.xmlis);
end;

function auth_getauthorization:boolean;
{D:    part of a set of tools for authentication (see: if test="rights", c_login, c_logout, etc.
  given a username, (optionally entryword)  and directory, looks for authorization statements in xseus.htmi -files in the directory or its parents
  -doc: later
  -plan: rewrite if impossible to document
}
var
  apust: string;
  k: integer;
  res,acom: ttag;
  xs:txseus;
begin
 xs:= txseus(t_currentxseus);
  //res:=_authenticate(xs.x_session,xs.curbyele,xs.x_outdir,'xseus.htmi');
  //writeln('<hr/><xmp>'+res.xmlis+'<xmp>');
  if res<>nil then xs.curtoele.subtags.add(res);
  //if res<>nil then curtoele.subtags.add(res.copytag);
 // if res<>nil then curtoele.subtags.add(res);
  exit;
  acom := xs.CurBYEle;
  apust := '';
  if acom.att('forcepass') <> '' then
    apust := acom.att('forcepass')
  else
    apust := xs.X_FORM.subs('.//entryword');
  //for k := x_form.subtags.Count - 1
  //downto
  //0 do
  //if cut_ls([k]) = 'entryword' then
  //  apust := cut_rs(ccall.fields[k]);
  try

    //_authorizebyuser(xs.x_outdir, acom.att('role'), apust,
    //  xs.x_session.att('name'), acom, xs.xml, xs.x_session);

    ;
  except

    _h1('nocheckr');

  end;
end;




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

    if (FileExists((todir)+g_ds+'xseus.htmi')) then
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
procedure toid.populate;
begin
  mode:='checkid_setup';
  identity:='http://belyykit.wordpress.com/';
  claimed_id:='http://belyykit.wordpress.com/';
  //assoc_handle:='%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D';
  return_to:='http://localhost:6500/test.htmi?login&nonce='+nonce;
  trust_root:='http://localhost:6500/test.htmi';

end;
function toid.taggaa:ttag;
begin
  result:=ttag.create;
  result.addsubtag('mode',mode);
  result.addsubtag('identity',identity);
  result.addsubtag('claimed_id',claimed_id);
  result.addsubtag('assoc_handle',assoc_handle);
  result.addsubtag('return_to',return_to);
  result.addsubtag('trust_root',trust_root);

end;
function toid.tostr:string;//list;
var resst:string;
 function uc(va,val:string):string;
   begin
      resst:=resst+va+'='+_urlencode(val);
   end;
begin
  resst:='';
  if pos('?',identity)>1 then
  uc('&openid.ns','http://specs.openid.net/auth/2.0')
  else uc('?openid.ns','http://specs.openid.net/auth/2.0');
  uc('&openid.mode',mode);
  uc('&openid.identity',identity);
  uc('&openid.claimed_id',claimed_id);
  //uc('&openid.assoc_handle',assoc_handle);
  uc('&openid.return_to',return_to);
  //uc('&openid.realm',realm);
  uc('&openid.trust_root',trust_root);
  result:=resst;
end;
function toid.get(url:string):string;
var formstl:tstringlist;formst,resst:string;
begin
  mode:='checkid_setup';
  realm:='xseus/timo';
  identity:=url;
  claimed_id:=url;
  //assoc_handle:='%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D';
  return_to:='http://localhost:6500/test.htmi?login&nonce='+nonce;
  trust_root:='http://localhost:6500/test.htmi';
  //formstl:=tostr;
  formst:=tostr;
  writeln('OID<xmp>'+url+formst+'</xmp>');
 resst:=_httpget(url+formst,909,nil);
 writeln('OID:<xmp>'+resst+'</xmp>');
 end;
function toid.redirect(url,nonc:string):string;
var formstl:tstringlist;formst,resst:string;
begin
  nonce:=nonc;
  mode:='checkid_setup';
  identity:=url;//'Timo@google';
  claimed_id:=url;
  realm:=url;//'xseus/timo';
  //assoc_handle:='%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D';
  return_to:='http://localhost:6500/test.htmi?login&nonce='+nonce;
  trust_root:='http://localhost:6500/test.htmi';

  //formstl:=tostr;
  formst:=tostr;
  logwrite('OID:'+url+'!'+formst+'');
  tserving(t_thisprocess).statusline:='HTTP/1.1 307 redirect';
  tserving(t_thisprocess).setheader('location',url+formst);
//  (Request-Line)	GET /?openidserver=1&openid.mode=checkid_setup&openid.identity=http%3A%2F%2Fbelyykit.wordpress.com%2F&openid.claimed_id=http%3A%2F%2Fbelyykit.wordpress.com%2F                                                                      &openid.return_to=http%3A%2F%2Flocalhost%2Ftest.htmi%3Flogin    &openid.trust_root= HTTP/1.1
//  (Request-Line)	GET /?openidserver=1&openid.mode=checkid_setup&openid.identity=http%3A%2F%2Fbelyykit.wordpress.com%2F&openid.claimed_id=http%3A%2F%2Fbelyykit.wordpress.com%2F&openid.assoc_handle=%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D&openid.return_to=https%3A%2F%2Fwww.zotero.org%2Fuser%2Flogin%2F&openid.trust_root=https%3A%2F%2Fwww.zotero.org%2Fuser%2Flogin%2F HTTP/1.1
// resst:=_httpget(url+formst,909,nil);
 //writeln('OID:<xmp>'+resst+'</xmp>');
 end;
function toid.check_auth(url:string;params:ttag):ttag;
var sigs:tstringlist;i:integer;asig,resst,chkst,furl:string;
begin
  mode:='check_authentication';
  chkst:='&openid.mode='+mode;
  furl:=tserving(t_thisprocess).fullurl;
  sigs:=tstringlist.create;
  _split(furl,'&',sigs);
  // if params.subs('openid.mode').vali='id_res' then
   begin
   result:=ttag.create;
   result.vari:='openid';
   result.addsubtag('id',params.subs('openid.identity'));
   //result.addatt('from='+x_object('openid.identity));

   end;
  //for i:=0 to params.subtags.count-1 do
  //  result.addsubtag(ttag(params.subtags[i]).vari,ttag(params.subtags[i]).vali);
  for i:=0 to sigs.count-1 do
   begin
    //writeln('<li>FIELD:<xmp>!'+sigs[i]+'!</xmp>');
    if (pos('openid.',sigs[i])=1) and (pos('openid.mode',sigs[i])<>1) then
     chkst:=chkst+'&'+sigs[i];
   end;
  writeln('<h3>CHECKOPENID:'+url+chkst+'!</h3>');
  resst:=_httpget(url+chkst,909,nil);
  writeln('<h3>CHECKEDOPENID:</h3><xmp>'+resst+'!</xmp>');
  //agparse(resst,true,true);
 {           tagparse(cla: string; low, trimmaa: boolean): ttag
  //for i:=0 to params.count-1 do
  _split(signed,',',sigs);

  signed:=params.subs('openid.signed');
  assoc_handle:= params.subs('openid.assoc_handle');
  signed:=params.subs('openid.signed');
  _split(signed,',',sigs);
  chkst:='&openid.mode='+mode;
  chkst:=chkst+'&openid.assoc_handle='+assoc_handle;
  for i:=0 to sigs.count-1 do
  begin
  asig:=''+trim(sigs[i]);
  if (asig<>'mode') and (asig<>'handler') then
   chkst:=chkst+'&openid.'+asig+'='+_urlencode(params.subs('openid.'+asig));
  end;
  writeln('<h3>CHECKOPENID:'+url+chkst+'!</h3>');
  resst:=_httpget(url+chkst,909,nil);
  writeln('<h3>CHECKEDOPENID:</h3><xmp>'+resst+'!</xmp>');
  result:=resst;

  //- openid.* = everything else
  //+ Everything that is in our list of signed items (minus the mode). In this case, we'll need to echo back the
  //identity and return_to parameters that we've been bouncing around for a while now.
  }
end;

end.

{
Redirect to: http://belyykit.wordpress.com/
?openidserver=1
&openid.mode=checkid_setup
&openid.identity=http%3A%2F%2Fbelyykit.wordpress.com%2F
&openid.claimed_id=http%3A%2F%2Fbelyykit.wordpress.com%2F
&openid.assoc_handle=%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D
&openid.return_to=https%3A%2F%2Fwww.zotero.org%2Fuser%2Flogin%2F
&openid.trust_root=https%3A%2F%2Fwww.zotero.org%2Fuser%2Flogin%2F



Redirect to: https://www.zotero.org/user/login/
?openid.assoc_handle=%7BHMAC-SHA1%7D%7B5219c16f%7D%7B%2BQiMbA%3D%3D%7D
&openid.identity=http%3A%2F%2Fbelyykit.wordpress.com%2F
&openid.mode=id_res
&openid.return_to=https%3A%2F%2Fwww.zotero.org%2Fuser%2Flogin%2F
&openid.sig=WA2OBv6Xckddwft4fXTmhahjPAI%3D
&openid.signed=mode%2Cidentity%2Creturn_to


 https://open.login.yahooapis.com/openid/op/auth?
openid.assoc_handle=UgNQaVi5Q0LMloDAgBHsf4Is7KNxmC3doAcrJmIVuzAvj.1m8koFbZ4luX9MWmoYeFCzM.sjjMhuQFOX6aAQgIS.RCIGFCdhGRCW8g5ARVNjTNUEk8R08FL4Sr76inA-
&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select
&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select
&openid.mode=checkid_setup
&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0
&openid.realm=http%3A%2F%2Fexample.com%2F
&openid.return_to=http%3A%2F%2Fexample.com%2Fauth
&openid.ns.oauth=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Foauth%2F1.0
&openid.oauth.consumer=dj0yJmk9V0Q4eDY4YUV1SHRBJnM9Y29uc3V
}

end.
function oldauth_checkauth(xsp:pointer):boolean;

  procedure _aint(ast:string;var oint:integer);
  begin
   //writeln('<li>tryreq:',ast,'/',oint);
   result:=false;
   if ast='' then exit;
   //case ast of  'guest': result:=1; end;
      if ast='guest' then oint:=1 else
        if ast='user' then oint:=2 else
          if ast='poweruser' then oint:=3 else
            if ast='admin' then oint:=4 else
              if ast='owner' then oint:=5;
  end;
  function checkdomain(ses:ttag;dom:string): boolean;
    var asub,subsub:ttag;i,j,mhas,mreq:integer;
    begin
      writeln('<li>dochec:<xmp>',ses.xmlis,'</xmp>___',dom);
      mreq:=0;mhas:=0;
      result:=false;
      for i:=0 to ses.subtags.count-1 do
      begin
          asub:=ttag(ses.subtags[i]);
           writeln('<li>acheckin::',asub.xmlis,' for ',asub.att('domain'),':::',dom);
       if asub.vari='domain' then
       if asub.vali=dom then
          for j:=0 to asub.subtags.count-1 do
          begin
            subsub:=ttag(asub.subtags[j]);
            _aint(subsub.att('role'),mhas);
            if subsub.vari='trust' then
             result:=checkdomain(ses,subsub.att('domain'));  //check trusted domain for credentials
             if mhas>=mreq then begin result:=true;exit;end;
          end;
      end;
      //writeln('<li>checked:',ses.xmlis,' for domain:',dom,result);
      //writeln('<li>checked:',mhas,' /',mreq);
    end;

var xs:txseus;mreq:integer;ses:ttag;
begin
   xs:=txseus(xsp);
   mreq:=0;
   //get *highest* requirement for current handler& object
  _aint(xs.x_handlers.att('require'),mreq);
  _aint(xs.x_myhandler.att('require'),mreq);
  _aint(xs.x_data.att('require'),mreq);
  // writeln('<li>checking requirements for ',xs.x_myhandler.xmlis,'/got:',mreq);
  if mreq=0 then begin result:=true;exit;end;
  //some kind of authorization is required
  //see what credentials we have already for this domain
  result:=checkdomain(xs.x_session,xs.x_object.att('app'));
end;
function oldauth_login: boolean;
{D: writes authorization data to session-tag (persistent data for a user-session over separate
  xseus-tasks. }
var
  domname: string;
  j: integer;
  aputag, acom, dom,adom,ses: ttag;
  xs:txseus;
begin
  dom := nil;adom:=nil;
  xs:= txseus(t_currentxseus);
  ses:=xs.x_session;
  acom := xs.CurBYEle;
  //writeln('<li>login command:',acom.xmlis+'!!!'+ses.xmlis);
  aputag := xseuscfg.subt('apppaths');
  domname := xs.x_object.att('app');
  for  j := 0 to aputag.subtags.Count - 1 do
    if ttag(aputag.subtags[j]).att('ns') = domname then
    begin
      dom := aputag.subtags[j];
      break;
    end;
  if dom = nil then
  begin
    _h1('Unauthorized domain for login:' + xs.x_object.att('app') + ':');
  end
  else
  begin
    if ses = nil then
    begin
      writeln('<li>NO VALID SESSION');//<pre>',xx_session.xmlis,'</pre>');
      exit;
    end;
    //writeln('<li>VALID SESSION<xmp>'+ses.xmlis+'</xmp>');//<pre>',xx_session.xmlis,'</pre>');
    for j:=0 to ses.subtags.count-1 do
    begin
      //writeln('<li>sesdom:');
      if ttag(ses.subtags[j]).vari<>'domain' then continue;
      if ttag(ses.subtags[j]).vali<>domname then continue;
      adom:=ses.subtags[j];
      //writeln('<li>sesdom:',adom.xmlis);
      break;
    end;
    try
    //  aputag := Createpersistenttag;
    if adom=nil then
    begin
       //writeln('<li>createnewsessiondom');
       adom:=ttag.create;
       adom.parent:=ses;
       ses.subtags.add(adom);
       adom.vari:='domain';
       adom.vali:=domname;
    end;
      //writeln('<li>UseSessiondom');
      //aputag:=xs.x_session.subt('+'+domname);
      aputag:=adom.subt('+login');
      aputag.vali := domname;
      //aputag.parent := xs.x_session;
      //writeln('sofarlog'+aputag.xmlis+'!!!');
      //xs.x_session.subtags.add(aputag);
      aputag.setatt('name', acom.att('name'));
      //writeln('<li>obj:',aputag.xmlis+'!!!');
      //x_session . attributes . values ['domain' ] := acom . att ('domain' ) ;

      //aputag.setatt('subdir', extractfilepath(xs.x_url));// dom.att('name'));
      aputag.setatt('subdir', extractfilepath(xs.x_url));// dom.att('name'));
      aputag.setatt('idi', acom.att('idi'));
      aputag.setatt('role', acom.att('role'));
      //writeln('sofar2'+aputag.xmlis);
      //x_session . attributes . values ['saveas' ] := ses_dir + '\' + acom . att ('saveas' ) ;
      aputag.setatt('ip', ses.subs('ip'));
    except    writeln('Failed to set session attributes' + xs.x_session.xmlis);   end;
  end;
end;
function _authorizebyentryword(outdiri:string;acom: ttag):string;
begin
end;

function _authorizebyuser(outdiri, role, password, user: string; acom: ttag;  xml: ttag; sestag:ttag): boolean;
begin

end;

function _oldauthorizebyuser(outdiri, role, password, user: string; acom: ttag;  xml: ttag; sestag:ttag): boolean;
var
  i, j: integer;
  aputagi, oses: ttag;
  pwok, onjo: boolean;
  fn: string;

  st, stold: string;
  authtag,xpass, thepass:ttag;
  oelems: TList;
begin
  try
    try
      Result := False;
      //xpass := ttag.Create;
      st := outdiri;
      stold := '';
      pwok := False;
      fn := acom.att('file');
      if fn = '' then
        fn := 'xseus.htmi';
      while not pwok do
      begin
        try
          stold := st;
          st := extractfiledir(st);
          if stold = st then
            break;
          //--if FileExistsUTF8(st+g_ds+fn) { *Converted from FileExists*  } then
          if FileExists(st + g_ds + fn) { *Converted from FileExists*  } then
          begin
            //_com('found ' + st);
            //xpass.fromfile(st + g_ds + 'luvat.htme', nil);
            xpass := tagfromfile(st + g_ds + 'xseus.htmi', nil);
          end
          else
            continue;
          if (xpass = nil) or (xpass.subtags.Count = 0) then
            continue;
        except
          writeln('<li>Problems with ' + st);
          raise;
        end;
        thepass := xpass.subtags[0];
        for i := 0 to thepass.subtags.Count - 1 do
        begin
          try
            aputagi := ttag(thepass.subtags[i]);
            //writeln('pass:'+password);
            //listwrite(aputagi);
            //if aputagi<>nil then
            begin
              if ((password = aputagi.att('pass')) and (password <> '')) or
                ((user = aputagi.att('user')) and (user <> '')) then
              begin
                pwok := True;
                authtag := ttag.Create;
                authtag.vari := 'aukt';
                authtag.setatt('dir', st + '');
                //user:=aputagi.att('user');
                authtag.setatt('user', user + '');
                role := aputagi.att('role');
                authtag.setatt('role', role);
                         {if ((password=aputagi.att('pass')) and (password<>'')) then
                         begin
                          writeln('HITpass:'+password);
                          sestag.attributes.add('P_'+password +'_=_'+aputagi.att('pass')+'_');
                           sestag.addsubtag('allow','' );
                           sestag.attributes.add( 'role='+aputagi.att('role'));
                           sestag.attributes.add( 'user='+aputagi.att('name'));
                           sestag.attributes.add( 'hui=hai');
                           //ttag(thepass.subtags[thepass.subtags.count-1]).attributes.text:=
                           //  'role='+role+crlf+'user='+user+'';
                           listwrite(sestag);
                          writeln('//HITpass:'+password);
                         end;}
                onjo := False;
                if authtag = nil then
                  exit;
                //for j := 0 to xs.x_session.subtags.Count - 1 do
                for j := 0 to sestag.subtags.Count - 1 do
                  if (ttag(sestag.subtags[j]).att('dir') = st) and
                    (ttag(sestag.subtags[j]).att('role') = role) and
                    (ttag(sestag.subtags[j]).att('name') = user) then
                    onjo := True;
                if not onjo then
                begin
                  if authtag <> nil then
                  sestag.subtags.add(authtag);
                  //sestag.subtags.add(authtag.copytag);
                end;
                if sestag <> nil then
                  if sestag.att('name') = '' then
                    sestag.setatt('name', sestag.att('user'));
                // _h1('Passw ok for '+st+password+'='+aputagi.att('pass'));

              end;
            end;
          except
            writeln('<li>could not authenticate ' + st);
            //listwrite(xs.x_session);
          end;
        end;
      end;
      //               writeln('<li>pw:');
      //     listwrite(xs.x_session);
      Result := pwok;
      //writeln('pwokpwpwpwpwp',result);
      exit;

   {
   if pwok then
     if xs.x_session.att('name')<>'' then
      begin
        try
        oses:=ttag.create;
        if fileexists(xs.x_session.att('dir')+g_ds+xs.x_session.att('name')+'.usr') then
        oses.fromfile(xs.x_session.att('dir')+g_ds+xs.x_session.att('name')+'.usr',nil);
     except writeln('<li>Could not read rights '+xs.x_session.att('dir')+g_ds+xs.x_session.att('name')+'.usr');
       end;
        if oses.subtags.count>0 then oses:=oses.subtags[0];
        if xs.x_session<>nil then if xs.x_session.subtags.count>0 then oses.subtagscopy(xs.x_session.subtags);
        oses.att('ip']:=xs.x_session.att('ip');
        oses.att('time']:=xs.x_session.att('date')+' '+xs.x_session.att('time');
        oses.att('id']:=xs.x_session.att('id');
        oses.savetofile(xs.x_session.att('dir')+g_ds+xs.x_session.att('name')+'.usr',false,'',false);
         end;
         }
    except
      writeln('<li>could not checkrights ' + st);
    end;

  finally
    //xs.x_elemlist := oelems;
  end;

end;


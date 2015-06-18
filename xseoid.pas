unit xseoid;

{$mode delphi}

interface

uses
  xsexml,xsemisc,xseglob,Classes, SysUtils;
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
uses xserver;
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
  tserving(t_thisprocess).statusline:='HTTP/1.1 302 FOUND';
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

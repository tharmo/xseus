unit xseglob;
//global varsw, consts and helper objects
//to be included in most units
{$mode delphi}

interface

uses
{$IFDEF LINUX}
// cthreads,//cmem,
{$ENDIF}
 //fgl,
//{$IFNDEF FPC}  Messages, {$ELSE} LCLIntf, LMessages,    LclType, interfaces, LResources, {$ENDIF}

xsexml,      xsestrm,
    //syncobjs,
    Classes, SysUtils;//,syncobjs;
const
  {$IFDEF windows}
    g_pathseparator='\';
    {$else}
    g_pathseparator='/';
    {$ENDIF}

  crlf = ^M^J;
  isost = 32000;
  whitespace = crlf + ' ';
  inlins = ',tt,span,strong,code,br,BR,img,em,b,i,a,strike,font,q,del,ins,value,FONT,STRONG,CODE,A,';
  //g_myurl = 'http://valtweb.pc.helsinki.fi/cgi-shl/cgitalk.exe';
  //g_nameChars = ['a'..'z', 'A'..'Z', '_', '0'..'9'];
  gc_tabsize = 3;
  gc_voids=',area,base,br,col,command,embed,hr,img,input,keygen,link,meta,param,source,track,wbr,';
  const gc_namechars= ['A'..'Z','a'..'z','_', '0'..'9',#128..#255];

  //inlineelems =  ',A,ABBR,ACRONYM,B,BASEFONT,BDO,BIG,BR,CITE,CODE,DFN,EM,FONT,I,IMG,INPUT,KBD,LABEL,Q,S,SAMP,SELECT,SMALL,SPAN,STRIKE,STRONG,SUB,SUP,TEXTAREA,TT,U,VAR,';
  //BLOCKelems =  ',ADDRESS,BLOCKQUOTE,CENTER,DIR,DIV,DL,FIELDSET,FORM,H1,H2,H3,H4,H5,H6,HR,ISINDEX,MENU,NOFRAMES,NOSCRIPT,OL,P,PRE,TABLE,UL,DD,DT,FRAMESET,LI,TBODY,TD,TFOOT,TH,THEAD,TR,APPLET,BUTTON,DEL,IFRAME,INS,MAP,OBJECT,SCRIPT,';
//  tmpoutdir = 'c:\www\tmp\';
//  tmpindir = 'c:\website\cgi-temp\';
 gc_blockelems='<address><article><aside><audio><blockquote><canvas><dd><div><dl><fieldset><figcaption><figure><footer><form><h1><h2><h3><h4><h5><h6><header><hgroup><hr><noscript><ol><output><p><pre><section><table><tfoot><ul><video>';
 gc_inlineelems=' <b><big><i><small><tt><abbr><acronym><cite><code><dfn><em><kbd><strong><samp><var><a><bdo><br><img><map><object><q><script><span><sub><sup><button><label><select><textarea>';
 gc_autoclosers='<html><head><body><p><dt><dd><li><option><thead><th><tbody><tr><td><tfoot><colgroup><input><frame><basefont><isindex><link><param>';
 gc_html5voids='<area><base><br><col><command><embed><hr><img><input><keygen><link><meta><param><source><track><wbr>';
 //both: <meta><br><hr> <col><img> <base><area><input>
  //g_myurl = 'http://valtweb.pc.helsinki.fi/cgi-shl/cgitalk.exe';

  //const bucketcount=128;
  const bucketcount=1;

type
 thashstrings = class(tobject)
 public

  private
    buckets:array[1..bucketcount] of tstringlist;
    function gethash(st:string): byte;
  public
    procedure list;
    function find(vari:string):string;
    function findobject(vari:string):ttag;
    function findobjects(vari:string):tlist;
    procedure add(vari,vali:string);
    procedure DELETE(vari:string);
    procedure addobject(t:ttag;vari:string);
    procedure delobject(t:ttag;vari:string);
    procedure fromlist(newvals,oldvals:tstringlist);
  procedure inc(vari:string;plus:integer);
  procedure clearvars(pattern:string);
   constructor create;
   destructor free;
end;
type
   TSeverity = (locked_not, locked_tmp, locked_write, locked_read);    // Defines the enumeration
type tloc=class(tobject)
  filename:string;
  severity: tseverity;
  owner:pointer;
  constructor Create(fs:string;sev:tseverity;ownerp:pointer);
  end;

  tlocs = class(TObject)
    //weights:TFPGList;
    locks: TList;
    criti: TrtlCriticalSection;
    function findfile(fs: string): tloc;
    function freefile(fn: string; locklist: TStringList): boolean;
    //function deletelock(aloc:tloc):boolean;
    //function freefileinlist(fn: string; locklist: TStringList): boolean;
    //function newlockfile(acom: ttag; xs: tobject): boolean;
    //function newfreefile(fn: string): boolean;
    function listlocks:string;
    function lockfile(fs: string;mylocks:tstringlist): boolean;
    function trylockfile(fs: string;mylocks:tstringlist): boolean;
    constructor Create;
    destructor Free;

  private
  end;
  txseusconfig = class(TObject)
  public
    config,
    mimetag,apppaths, xcommands, xpermissions, ftp, smtp: ttag;
    logf: tfilestream;
    //locs: tlocs;
    //threadcount:integer;
    cache,defheaders:tstringlist;
    mimelist:tlist;
    sessiontimeout:string;
    //gdebug: boolean;
    smtpindir: string;
    timers: ttag;
    function getmime(ext:string):string;
    procedure get(inif: string);
    function subs(st: string): string;
    function subt(st: string): ttag;
    destructor Free;
  end;
//type tsession=class(tobject)



type
  ttimes = class;  //used in debuggin to keep track of time taken by procedures
               // xse:showtimes  - probably not functioning now

  tstarted = class(TObject)
    elems, pars: TList;laststart:boolean;
    constructor Create;
    destructor Free;
    function xCount: integer;
    procedure setpar(newp:ttag);

    procedure add(ele, par: pointer);
    procedure Delete;
    function list:string;
    function getpar: ttag;
    function getele: ttag;

  end;
  ttimes = class(TObject)
    path: TList;
    insts:integer;
    //curxseus:pointer;
    procedure addsub(handler: ttag; ob: string);
    procedure return;
    procedure listaa;
  public
    procedure Clear;
  end;

  tatime = class(TObject)
    public
      handler: ttag;
      xseussize, sheap,eheap: integer;
      sub: TList;
      text: string;
      stime, etime: tdatetime;
      //curxseus:pointer;
      constructor Create(handleri: ttag; txt: string;cur:pointer);
      function Clear:integer;
      function createsub(handleri: ttag; ob: string): tatime;
      procedure list(lasttime: tdatetime;lastmem:integer);
    public
      // destructor free;
    end;


var
  lokifile, lokifile2: tfilestream;
  g_inidir: string;
  //loglocked: boolean;
  loglines: TStringList;
  //logfile:textfile;
  //lokifile,lokifile2:tfilestream;
  //logord: integer;
  //logicriti: boolean;
  //logcrit:TCriticalSection;
  g_livesession:pointer=nil;
  g_threadpoolcriti,g_sesscriti,g_logscriti:trtlcriticalsection;
 // g_objectcache: TStringList;
  g_locks:tlocs;
  //xseuscfg: txseusconfig;
  g_xseuscfg:txseusconfig;
  {$IFNDEF LAZARUS}//logstream: tfilestream;
    {$ENDIF}
threadvar             //why not part of a txseus??
  elements_freed, elements_created:integer;
  t_debug: boolean;
  //t_lastopentag:tobject;
  //t_context: tidcontext;
  t_currentxseus: pointer; //txseus
  t_thisprocess: pointer;//Tserving;
  //t_idlist:thashstrings;
  //t_elemlist,t_elemrefcount:tlist;
  t_writehandler:ttextrec;
  t_outbuffer:tmemorystream;
  t_stream:tstreamer;
  //t_keepbuff:boolean; //wonder what this was for...
   //t_rematch:boolean; //currentkly only for case-statement, later apply?
 // t_mythreadelems, mythreadrefcount: TList;
  //myxs: pointer;//txseus;
  _debug: boolean;

const
  {$IFDEF WINDOWS}
  g_ds = '\';
  {$ELSE}
  g_ds = '/';
  {$ENDIF}

const //g_ds='/';
 g_memtest=false;
 // g_memtest=true;
procedure logshow(st: ansistring);
procedure logwrite(st: ansistring);
procedure initcriticals;

implementation
uses xsexse,xserver,
//xsegui,
xsemisc;
procedure initcriticals;
begin
  system.initcriticalsection(g_threadpoolcriti);
  system.initcriticalsection(g_logscriti);
  system.initcriticalsection(g_sesscriti);


end;


procedure logwrite(st: ansistring);
var
  t: integer;
begin
  //writeln('l:'+st);
 system.entercriticalsection(g_logscriti);
  try
  //exit;
  //LCLIntf.
  t := 0;
    if st = '' then
      exit;
    st := st + crlf;
  try
    lokifile.WriteBuffer(st[1], length(st));
    //writeln('d:'+st);
    //lokifile.position:=0;
    except
      writeln('FAILLOG:'+st + crlf + '....' + IntToStr(t) + '...' + crlf);
      //try closefile(logfile); except end;
    end;
  finally
      system.leavecriticalsection(g_logscriti);
  end;

end;
procedure logwrite2(st: ansistring);
begin   //logwrite2(st);
end;

procedure logshow(st: ansistring);
var
  t,i: integer;
begin
{//  logwrite2(st+'___');
//  exit;
 system.entercriticalsection(g_logscriti);
 //if xseusformi.memo1.lines.count>20 then
   while xseusformi.memo1.lines.count>50 do
   xseusformi.memo1.lines.delete(1);
   //xseusformi.memo1.lines.clear;
   //xseusformi.memo1.lines.insert(0,st);
   xseusformi.memo1.lines.add(st);
 // xseusformi.memo1.VertScrollbar.Position:= xseusformi.memo1.lines.count*16;
 system.leavecriticalsection(g_logscriti);
 }
end;

constructor tloc.Create(fs:string;sev:tseverity;ownerp:pointer);
begin
   filename:=fs;severity:=sev;owner:=ownerp;
   logwrite('created lock for '+fs);
end;

function tlocs.listlocks: string;
var i:integer;
begin
   result:='';
   for i:=0 to locks.Count-1 do
    result:=result+tloc(locks[i]).filename;
end;
function tlocs.findfile(fs:string): tloc;
var i:integer;myloc:tloc;
begin
   result:=nil;
   i:=-1;
   //while i< do
   //begin
   for i:=0 to locks.Count-1 do
   begin
     //i:=i+1;
     //logwrite('lock?'+inttostr(i)+fs);
     if tloc(locks[i]).filename=fs then
     begin
       result:=tloc(locks[i]);
       exit;
     end;

   end;
end;
function tlocs.lockfile(fs: string;mylocks:tstringlist): boolean;
var
  i: integer;
  fr: boolean;
  oldloc,newloc:tloc;
  sev:tseverity;owner:tserving;
begin
  Result := false;
  //logwrite('LOCKSCREATE:'+fs);
  //writeln('<li>trylock '+fs+'with:'+locks.Text+'</li>');
  sev:=locked_write;
  owner:=t_thisprocess;
  newloc:=tloc.Create(fs,sev,pointer(owner));
 //logwrite('LOCKSCREATED:'+fs);
  for I := 0 to 40 do
  begin
     oldloc:=findfile(fs);
     if  oldloc=nil then
     begin
      try
      logwrite(inttostr(tserving(owner).id)+'Locked file: '+fs);
      system.entercriticalsection(criti);
      Result := true;
      locks.add(newloc);
      mylocks.add(fs);
      finally system.leavecriticalsection(criti);end;
      exit;
    end;
    logwrite(fs+' is locked');//+ inttostr(i)+'/by:'+inttostr(tserving(oldloc.owner).id)+'/for:'+inttostr(tserving(owner).id));
    sleep(200);
  end;
  logwrite('could not obtain lock for '+fs);
end;
function tlocs.trylockfile(fs: string;mylocks:tstringlist): boolean;
var
  i: integer;
  fr: boolean;
  oldloc,newloc:tloc;
  sev:tseverity;owner:tserving;
begin
  Result := false;
  //logwrite('LOCKSCREATE:'+fs);
  //writeln('<li>trylock '+fs+'with:'+locks.Text+'</li>');
  sev:=locked_write;
  owner:=t_thisprocess;
  newloc:=tloc.Create(fs,sev,pointer(owner));
  system.entercriticalsection(criti);
  try
  oldloc:=findfile(fs);
  if  oldloc=nil then
  begin
      //logwrite('add tmp lock for '+fs);
      Result := true;
      locks.add(newloc);
      mylocks.add(fs);
      exit;
  end else
  logwrite(fs+' was locked at first');
  finally system.leavecriticalsection(criti);end;
end;

{function tlocs.deletelock(aloc:tloc):boolean;
begin
   locs.delete(
end;
}
function tlocs.freefile(fn: string; locklist: TStringList): boolean;
var aloc:tloc;
begin
  // logwrite('LOCKSDEL:'+fn);

  //entercriticalsection(locriti);
    if locks = nil then
      exit;
    //criti.enter;
    try
    system.entercriticalsection(criti);
    aloc:=findfile(fn);
    if  aloc<>nil then
    begin
     locks.remove(aloc);
     aloc.Free;
    end;
    if locklist.indexof(fn) >= 0 then
     locklist.Delete(locklist.IndexOf(fn));
    //writeln('<li>freed:'+fn+'</li>');
    //>> else
    //>> logwrite('cannot free file '+fn+' in: '+locks.Text +'/cannot'+inttostr(locks.count));
    //>>logwrite('freed File '+fn+' in: '+locks.Text +'/freed'+inttostr(locks.count));

  finally
    //criti.leave;
     system.leavecriticalsection(criti);

  end;
end;

constructor tlocs.Create;
begin
  locks := tlist.create;//TStringList.Create;
  system.InitCriticalSection(criti);
  //criti := TCriticalSection.Create;

end;

destructor tlocs.Free;
var
  i: integer;
  st: string;
begin
  //logwrite('freefiles');
  for i := 0 to locks.Count - 1 do
  begin
    tloc(locks[i]).free;
    //freefile(locks[i],nil);
  end;
  locks.Clear;
  locks.Free;
  //inherited free;
end;



function thashstrings.gethash(st:string): byte;
var i,res,len: integer;
begin
  st:=trim(st);
 res:=0;
 //len:=min(3,length(st));
  len:=length(st);
  try
  for i := 1 to  len do
   //try
    res := ord(st[i])+res;
   //except end;
  except writeln('failedingethash_'+st,len);
  end;
  result := 1+(res mod bucketcount);
  //writeln('<li>hash s:',st,'/h:',result,'/l:',len,'</li>');
end;

constructor thashstrings.create;
var i:integer;
begin
  for i:=1 to bucketcount do
     buckets[i]:=tstringlist.create;
end;
destructor thashstrings.free;
var i,j:integer;
begin
//  writeln('<ul>');
  for i:=1 to bucketcount do
     begin
  //   writeln('<li><b>',buckets[i].count,'</b>:',buckets[i].text,'</li>');
     for j:=0 to tstringlist(buckets[i]).Count-1 do
        if tstringlist(buckets[i]).objects[j]<>nil then
          tstringlist(buckets[i]).objects[j].free;
     buckets[i].clear;
     buckets[i].free;
     end;
 // writeln('</ul>');
  //inherited free;
end;
procedure thashstrings.list;
var i:integer;
begin
  for i:=1 to bucketcount do
     writeln('<li><b>',buckets[i].count,'</b>:',buckets[i].text,'</li>');
end;
procedure thashstrings.inc(vari:string;plus:integer);
var hs:byte;olde:integer;
begin
   try
   vari:=trim(vari);
   hs:=gethash(vari);
   except writeln('failedtogethash_'+vari);
   end;
   try
   olde:=strtointdef(tstringlist(buckets[hs]).values[vari],0);
   except writeln('failedtogethashstr_vali:',hs);
   end;
   try
   tstringlist(buckets[hs]).values[vari]:=inttostr(olde+plus);
   except writeln('failedtoinchashstr_vali:',hs);
   end;
end;
procedure thashstrings.fromlist(newvals,oldvals:tstringlist);
var hs:byte;i:integer;newst,oldval,vari:string;
begin
  for i:=0 to newvals.Count-1 do
  begin
   newst:=newvals[i];
   vari:=cut_ls(newst);
   try
     hs:=gethash(vari);
   except writeln('failedtogethashnum_'+vari);end;
   try
    oldval:=trim(tstringlist(buckets[hs]).values[vari]);
    oldvals.add(vari+'='+oldval);
    tstringlist(buckets[hs]).values[vari]:=trim(cut_rs(newst));
   except writeln('failedtogethash_',vari,hs); end;
  end;

end;

procedure thashstrings.add(vari,vali:string);
var hs:byte;
begin
  vari:=trim(vari);
    try
   hs:=gethash(vari);
   except writeln('failedtogethashnum_'+vari);
   end;
   try
   tstringlist(buckets[hs]).values[vari]:=vali;
   except writeln('failedtogethash_',vari,hs);
   end;

end;
procedure thashstrings.clearvars(pattern:string);
var i:integer;
begin
 //for i:=x_svars.count-1 downto 0 do
 // if _matches(pattern, ttag(x_svars[i]).vari) then
end;
procedure thashstrings.delete(vari:string);
var hs:byte;hit:integer;tt:ttag;elelist:tlist;
begin            //DON'T USE ---
    try
   vari:=trim(vari);
   hs:=gethash(vari);
   except writeln('failedtogethashnum_'+vari);
   end;
   try
   hit:=tstringlist(buckets[hs]).indexof(vari);
   if hit<0 then exit;
   tstringlist(buckets[hs]).delete(hit);
   except writeln('failedtodelhash_obj',vari,hs);
   end;

end;

procedure thashstrings.delobject(t:ttag;vari:string);
var hs:byte;hit:integer;tt:ttag;elelist:tlist;
begin
    try
   vari:=trim(vari);
   hs:=gethash(vari);
   except writeln('failedtogethashnum_'+vari);
   end;
   try
   hit:=tstringlist(buckets[hs]).indexof(vari);
   if hit<0 then exit;
   elelist:=tlist(tstringlist(buckets[hs]).objects[hit]);
    if pos('s1_1',vari)>0 then   writeln('<li>DELid_',vari,'?<b>',t.xmlis,'</b>!',hs,'//</li>',hit);
   except writeln('failedtofindelhash_obj',vari,hs);end;
  try
  //if hit>-1 then
     if elelist<>nil then
       elelist.remove(t);
      //tstringlist(buckets[hs]).objects[hit]:=nil;
   //tstringlist(buckets[hs]).delete(hit);
   //             Setid_        ?   atag id= !1//
   //try
  //if vari='aapeli' then writeln('<li>DELid_',vari,'?<pre>',t.xmlis,'</pre>!',hs,'//</li>',hit,'/left:',elelist.count,'/DELIS</li>');
   //except writeln('<li>nononowriteaapeli</li>');end;
   except writeln('failedtodelhash_obj',vari,hs);
   end;

end;
function thashstrings.findobject(vari:string):ttag;
    var hs:byte;hit:integer;elelist:tlist;
begin
  try
  vari:=trim(vari);
  result:=nil;
 hs:=gethash(vari);
 except writeln('failedtogethashnum:forobj_'+vari);
 end;
 try
  hit:=tstringlist(buckets[hs]).indexof(vari);
  if hit>-1 then
  begin
   //result:=ttag(tstringlist(buckets[hs]).objects[hit]);
    elelist:=tlist(tstringlist(buckets[hs]).objects[hit]);
    result:=ttag(elelist[0]);
   if pos('s1_1',vari)>0 then     writeln('foundidi:',vari,'/',elelist.count,'/hash:',hs,'/hit:',hit,'!'+result.vari,'!','!'+result.vali,'!');
    end;
      // ------------------Getid_0_0!64#-1Â¤Â¤Â¤#
  //if    result<>nil then writeln('<li>------------------Getid_',vari,'!hash:',hs,'#',hit,'¤¤¤',tstringlist(buckets[hs]).text,'#',result.xmlis,'!!!</li>')
  //else writeln('<li>noid',hit,vari,'#',hs,'#</li>'+'!'+tstringlist(buckets[hs])[0]+'!/noid');
 except writeln('failedtogetst_obj:forobj_'+vari,result=nil);
 end;
end;
procedure thashstrings.addobject(t:ttag;vari:string);
var hs:byte;hit:integer;ellist:tlist;
begin
  vari:=trim(vari);
    try
   hs:=gethash(vari);
   except writeln('failedtogethashnum_'+vari);
   end;
   try
   try
   hit:=tstringlist(buckets[hs]).indexof(vari);
   except writeln('failedtosethash_HIT',vari,'/hash:',hs,'/buckets:',bucketcount);end;
   if hit<0 then
   begin
    try
    ellist:=tlist.create;
    ellist.add(t);
    tstringlist(buckets[hs]).addobject(vari,ellist);
    except writeln('failedtosethash_NEWelelist',vari,hs);end;
   end
   else
   begin
   try
    ellist:=tlist(tstringlist(buckets[hs]).Objects[hit]);
    ellist.insert(0,t);
    except writeln('failedtosethash_OLDelelist',vari,hs);end;
    //tstringlist(buckets[hs]).objects[hit]:=ellist;
   end;
   //             Setid_        ?   atag id= !1//
   if pos('s1_1',vari)>0 then writeln('<li>DOSetid_',vari,'/hash:',hs,'//',hit,'?',t.xmlis,'?''/setid',ellist.count);//<xmp>'+ttag(tlist(tstringlist(buckets[hs]).objects[0]))[0].xmlis,'</xmp>/setid');
   except writeln('</pre>failedtosethash_ele',vari,hs);
   end;

end;


function thashstrings.findobjects(vari:string):tlist;
    var hs:byte;hit:integer;elelist:tlist;
begin
  try
  vari:=trim(vari);
  result:=nil;
 hs:=gethash(vari);
 except writeln('failedtogethashnum:forobj_'+vari);
 end;
 try
  hit:=tstringlist(buckets[hs]).indexof(vari);
  if hit>-1 then
   //result:=ttag(tstringlist(buckets[hs]).objects[hit]);
    result:=tlist(tstringlist(buckets[hs]).objects[hit]);
 except writeln('failedtogetst_obj:forobj_'+vari,result=nil);
 end;
end;

function thashstrings.find(vari:string):string;
    var hs:byte;
begin
  vari:=trim(vari);
  hs:=gethash(vari);

  result:=tstringlist(buckets[hs]).values[vari];
end;

function txseusconfig.getmime(ext:string): string;
var i:integer;t:ttag;
begin
 result:='';
 for i:=0 to mimetag.subtags.count-1 do
 begin
   t:=mimetag.subtags[i];
   if t.att('ext')=ext then
   begin
     result:=t.att('mime');exit;
   end;
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
var    i:integer;
  x: //, d:
  string;//mimetag:ttag;
  dh:tlist;
  dt,dht:ttag;
begin
  try

    g_locks := tlocs.Create;
    //g_locks.locks.add('jiphei');
    //if not FileExistsUTF8(inif) { *Converted from FileExists*  } then
    if not FileExists(inif) { *Converted from FileExists*  } then
    begin
      //>>inif:=extractfiledir(paramstr(0))+g_ds+'xseus.ini';
      //d := extractfiledir(ParamStr(0));
      //d := extractfiledir(ParamStr(0));
      logwrite('INIFILE NOT FOUND');
      x := '<xseus>' + crlf + '<urlpaths> <map path="' + g_inidir +
        '/www/" url="/"></map>' + crlf + '</urlpaths><apppahts><xseus path="' +
        g_inidir + '/xseus/"/></appaths></xseus>';
      //SHOULD GO SOMETHING LIKE THIS
      //config:=ttag.create;
      //config.vari:=xseus;
      //atag:=config.addsubtag('urlpaths','');
      //atag.addsubtag(
      //writeln('!SAVEINI TO:' + inif + '!read config! ' + x);
      config := tagparse(x, False, False);
      config.saveeletofile(g_inidir + '/xseus.xsi', True, '','  ', False,false);
      config.Free;
      //writeln('!SAVEINI TO:' + inif + '!read config! ' + config.xmlis);
      createdir(g_inidir + '/www');
      x := '<helloer class="xseus:hello.xsi"><mygreeting>hello world</mygreeting></helloer>';
      config := tagparse(x, False, False);
      config.saveeletofile(g_inidir + '/www/hello.htmi', True, '','  ',false, False);
      config.Free;
      createdir(g_inidir + '/xseus');
      x := '<class name="hello"><open><h1>xse:/helloer/mygreeting</h1></open></class>';
      config := tagparse(x, False, False);
      config.saveeletofile(g_inidir + '/xseus/hello.xsi', True, '', '  ',False,false);
      config.Free;
    end;
    //inif:='C:\XSER\xseus.ini';  //SLASHES AND BACKSLASHES! GOTTA MAKE IT GENERAL
    //BESIDES: NOW ONLY XML-SYNTAX.. SHOULD CHECK XSEUS.XSI FIRST
    //logwrite('read config ' + inif);
    //config:=ttag.create;
    //config.fromfile(inif,nil);
    //config:=(config.subtags[0]);
    logwrite('readingconfig');
    config := tagfromfile(inif, nil);
  except   logwrite('failed to getconfig' + inif);  end;
  try
    //logwrite('readconfig'+config.xmlis);
    //writeln('!' + config.vari + '!read config! ' + config.xmlis);

  except
    logwrite('failed to read inifile from ' + inif);
    exit;
  end;
  //mimelist:=tstringlist.create;
  //mimelist.add('css=text/css');
  //mimelist.add('html=text/html');
  try
  mimetag:=config.subt('mimetypes');
  sessiontimeout:=config.subs('sessiontimeout');
  except   logwrite('failed to config  mimetypes' + inif);  end;
  try
  if mimetag=nil then
  begin
     try
      mimetag:=ttag.create;
     except   logwrite('failed to create mimetag' + inif);  end;

      mimetag:=tagparse('<mimetypes><type mime="text/plain" ext="txt"/>'+
        '<type mime="text/html" ext="htm"/>'+
        '<type mime="text/html" ext="html"/>'+
        '<type mime="text/xml" ext="xml"/>'+
        '<type mime="text/css" ext="css"/>'+
        '<type mime="text/javascript" ext="js"/>',false,false);
  end;// else
  except   logwrite('failed to read mimetag' + inif);  end;
  try
  mimelist:=mimetag.subtags;
  defheaders:=tstringlist.create;
  dht:=config.subt('defaultheaders');
  except   logwrite('failed to create mimelist' + inif);  end;
  try
  if dht=nil then
  begin
    defheaders.add('transfer-encoding=chunked');
    defheaders.add(' content-type=text/html');
    defheaders.add(' pragma=no-cache');
    //defheaders.add('connection=keep-alive');
  end else
  begin
    dh:=dht.subtags;
    for i:=0 to dh.count-1 do
    begin
     dt:=ttag(dh[i]);
     defheaders.add(dt.vari+'='+dt.vali);
    end;
  end;
  //logwrite('mimetypes:'+mimetag.xmlis);
  //logwrite('defheads:'+defheaders.text);
  except   logwrite('failed to read mimetypes' + inif);  end;

  //for i:=0 to config.subt('mimelist').subtags.count-1 do
  //   mimelist.add(ttag(config.subt('mimelist').subtags[i]).att('ext')+'='
  //    +ttag(config.subt('mimelist').subtags[i]).att('mime'));}
  cache := TStringList.Create;
  xcommands := config.subt('commands');
  xpermissions := config.subt('permission');
  //logwrite('iniii;' + config.xmlis);
  apppaths := config.subt('apppaths');
  //urlpaths := config.subt('urlpaths');
  //logwrite('application paths INDIR:' + apppaths.xmlis);
  //logwrite('page paths:'+xseuscfg.subt('urlpaths').xmlis);
  smtpindir := config.subs('//smtp/@indir');
  //logwrite('SMTP INDIR:' + smtpindir);
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
//var
  //oldtx: txseus;
  //not sure that there are't memory leaks .. small probllem, performed very seldom
  //anyway, this is not in use yet
begin
  //oldtx := thrxs;
  //thrxs := nil;
  cache.Free;
  config.Free;
  //thrxs := oldtx;

end;



{D: tell xseus that htme will not be saved so it can unlock the htme-file.
function tlocs.freefileinlist(fn: string; locklist: TStringList): boolean;
  Better to use c_unlock directly.
  plans: remove / add similar functionality to handler-elements lock=false -attribute
   (or missing lock=true? which should be default)

begin
    if locklist = nil then
      exit;
    try
      system.entercriticalsection(criti);
      try
       if locklist.IndexOf(fn) >= 0 then
        locklist.Delete(locklist.IndexOf(fn));
      except exit; end;
      try
        g_locks.freefile(fn);
        mylocks.Delete(locks.IndexOf(fn));
      except logwrite('lockstext=nil:');end;
    finally system.leavecriticalsection(criti);
  end;
end;
}


constructor tstarted.Create;
begin
  //inherited create;
  elems := TList.Create;
  pars := TList.Create;
end;

destructor tstarted.Free;
begin
  elems.Free;
  pars.Free;
  //inherited free;
end;

procedure tstarted.add(ele, par: pointer);
begin
 //writeln('<li><b>STARTED::::',count, '/',(elems.capacity), '/',(pars.capacity),'</li></ul>');
  elems.add(ele);
  pars.add(par);
end;
function tstarted.list:string;
var i:integer;
begin
 result:='';
 for i:=pars.count-1 downto 0 do
 begin
  result:=result+inttostr(i);
  try
  result:=result+'/ele:'+ttag(elems[i]).head;except end;
  try result:=result+' /par'+ttag(pars[i]).head+ '!!';except end
 end;
end;

procedure tstarted.Delete;
begin
  pars.Delete(pars.Count - 1);
  elems.Delete(elems.Count - 1);

end;

function tstarted.getele: ttag;
begin
  Result := elems[elems.Count - 1];
end;

function tstarted.xCount: integer;
begin
  if pars.Count = elems.Count then
    Result := elems.Count
   else
    Result := -999999;
end;

function tstarted.getpar: ttag;
begin
  Result := pars[pars.Count - 1];
end;
procedure tstarted.setpar(newp:ttag);
begin
 if   pars.count>0 then
    pars[pars.Count - 1]:=newp;
end;
constructor tatime.Create(handleri: ttag; txt: string;cur:pointer);
begin
  stime := now;
  //curxseus:=cur;
  sub := TList.Create;
  handler := handleri;
  sheap := getheapstatus.totalallocated;
  //xseussize := txseus(curxseus).getmemx;
  text := txt;
end;

function tatime.Clear:integer;
var i:integer;
begin
 result:=1;
 if sub <> nil then
   for i := 0 to sub.Count - 1 do
   begin
     result:=result+tatime(sub[i]).clear;
     tatime(sub[i]).free;
   end;
  sub.Free;
  //inherited free;
end;

function tatime.createsub(handleri: ttag; ob: string): tatime;
var
  newt: tatime;
begin
  newt := tatime.Create(handleri, ob,nil);
  sub.add(newt);
  Result := newt;
end;

procedure ttimes.Clear;
var
  i,cl: integer;
begin
  cl:=0;
  //writeln('<li>createdtimes:',insts);
  if path <> nil then
  begin
   //tatime(path[0]).list(now);
    for i := 0 to path.Count - 1 do
    begin
      cl:=cl+tatime(path[i]).Clear;
      tatime(path[i]).Free;
    end;
    //writeln('<li>freedtimes:',cl);
    path.Free;
  end;
  //inherited free;
end;
procedure tatime.list(lasttime: tdatetime;lastmem:integer);
var
  i: integer;
  t: tdatetime;
begin
  try
    writeln('<li>', ttag(handler).vari,':', //text,
      ' -  <b>', round((etime - stime)* 24 * 3600 * 1000),'</b>',
      ' (', round((stime - lasttime) * 24 * 3600 * 1000),
      ') mem: <b>', sheap-eheap, '</b> xs:', sheap-lastmem, '<ul>');
    t := stime;
  except
    writeln('<li>failure in showtime.listaa.list.alku</li><ul>');
    //raise;
  end;
  if sub <> nil then
    for i := 0 to sub.Count - 1 do
    begin
      tatime(sub[i]).list(t,sheap);
       //writeln('<li>atimelisted</li>');
      //t := tatime(sub[i]).etime;
    end;
  //if (sub.Count > 0) and (round((t - etime) * 24 * 3600 * 1000) > 0) then
  //  writeln('</ul><li>/', ttag(handler).att('name'), ' - ', round((t - etime) * 24 * 3600 * 1000),'</li>')
  //else
    writeln('</ul></li>');
end;

procedure ttimes.listaa;
begin
  //writeln('listaa1');

  if path = nil then
    exit;
  //writeln('listaa2');
  if path.Count < 1 then
    exit;
  writeln('<ul>');
  try
    //writeln('<li>listaa3</li><ul>');
    tatime(path[0]).list(now,0);
    //writeln('listaa4');
  except
    writeln('failure in showtime.listaa');
  end;
  writeln('</ul></li></ul>');
end;

procedure ttimes.addsub(handler: ttag; ob: string);
var
  tim: tatime;
begin
  try
    if path = nil then
    begin
      path := TList.Create;
      tim := tatime.Create(handler, ob,nil);
      insts:=1;
      path.add(tim);
      //writeln('<h3>timepath created</h3>');
    end;
    tim := tatime(path[path.Count - 1]).createsub(handler, ob);
    insts:=insts+1;
    path.add(tim);
  except
    writeln('failedtowritetime');
  end;

end;

procedure ttimes.return;
begin
  if path.Count < 1 then begin writeln('nogottimesreturn');   exit;end;

  tatime(path[path.Count - 1]).etime := now;
  tatime(path[path.Count - 1]).eheap := getheapstatus.totalallocated;;
  if path.Count > 1 then
  begin
    path.Delete(path.Count - 1);
  end;
end;


end.


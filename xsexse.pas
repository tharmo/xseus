

unit xsexse;

interface

{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
 {$DEFINE DELPHI}
{$ENDIF}
{ $H+}
{$M+}
uses
  {$IFNDEF LCL}
  //Messages,
  {$ELSE}
{$IFNDEF FPC}
 // shellapi, //Windows,
{$ELSE}
  //LCLIntf, LCLType, LMessages,
{$ENDIF}
  //LclIntf, LMessages, LclType,
  {$ENDIF}
  // sharemem,
  contnrs,
  SysUtils, strutils,
  Classes, dateutils,// Controls, //syncobjs,
  fileutil,
  xsestrm,
  //what is this: uhashedstringlist,
  //xsesta,
  xseglob,
  //xsecgi,
  //xsemuu,
  xseconv,//xsesta,
  xsexml, Math,
  variants,
  xsedif, xsedb;
//IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
//IdHTTPServer, IdContext;
type
  Teabreak = (br_goon, br_cont, br_break, br_exit, br_halt);
// Defines the enumeration
type tcompfunc= function(Item1, Item2: Pointer): integer;
txseus=class;
trelation=class(tobject)
  public
    tolist:tstringlist;fromlist:tlist;
    xseus:txseus;
    //stlist:tstringlist;
    //toele:pointer;
    toselector, torootsel,fromselector: string;
    toselected,  fromselected:pointer;
    sofarto:integer;
    prev:trelation;
    sorted:boolean;
    //sortst:string;
    //sorter:pointer;
    compfunc: function(Item1, Item2: Pointer): integer;  //sortcomp
    constructor create(relsel:string;sels:tlist;xs:pointer;var hasrelation:boolean; fun:tcompfunc);
    destructor free;
    procedure findrel(fromsel:pointer);
    function findrellist:tlist;
    procedure debug;
end;
tgrouping=class(tobject)
  public
  list:tlist;
  position:integer;
  name,selector,nextst:string;
  nextpos:integer;
  nexttag:ttag;
  constructor create(pars:string;lis:tlist);
  //destructor free;
  function nextgrouplist:tlist;
  function nextgrouptag:ttag;
end;
txseus = class(TObject)
  public
    //§§ response:tresponse;
    x_relation:trelation;
    x_SERVING: pointer; //tserving;
    x_url, x_host, x_protocol, x_handlername, x_cookie: string;
    xml, x_data, x_myhandler, x_handlers, //x_cgi,
    //x_pass,
    x_form, x_object, curtemplates,
     X_funcs, // not really figured out whys and hows of  func declarations
    x_rights,
    x_bookmarks, x_config, x_uploads: ttag;
    x_elemlist, x_elemrefcount: TList; //, states
    //x_config:xseuscfg: txseusconfig;
    x_started,x_stopped: tstarted;
    x_session: ttag;
    x_classname:string;
    x_cmdline: boolean;
    x_rematch: boolean;  //for case-statement. Apply?
    x_hmackey, x_newcookie, x_objectfile, x_outdir, ses_file,
    ses_url, x_commandfile, x_commanddir: string;
    //state_continue, state_exit, state_halt, state_break: boolean;
    break_state: teabreak;
    //x_svars:TurboHashedStringList;
    x_svars:TSTRINGLIST;
    x_databases:tstringlist;
    //x_svars used to be hashstrings, but no point in that
    x_ids: ThashSTRINGs;
    xx_connections, x_objectlist, x_mylocks: TStringList;
    inihttp, inidecl, inihtml, inihead, inibodyst, inibodyend: string;
    //request: TIdHTTPRequestInfo;
    //response: TIdHTTPResponseInfo;
    //ccall: tcgicall;
    ns, x_objectdir, //xmlformat,
    stateexception: string;
    //loc:tlocs;
    x_times: ttimes;
    debug, x_critical, unlimited, httpinited, htmlinited, nobody,
    x_resettimer, x_called, x_locked: boolean;
    x_stream:tstreamer;
    CurFromEle, CurByEle, CurToEle: ttag;
    Curselectionset: TList;
    constructor Create(principal: txseus);
    function staselect(st: string; def: ttag): TTAG;
    function dosubelements: boolean;
    function doelementlist(proglist: TList): boolean;
    //function doelement(progt: Tttag): boolean;
    procedure doit;
    procedure docontinue;
    function init(url, host, protocol: string; session: ttag; ser: pointer): boolean;
    //form,uploads:tstringlist);
    function Clear: integer;
    function substitutex(st: string): string;
    function applyall: boolean;
    function getmemx: integer;
  private
    //filestream: tstream;
    // function doelems2(nfrom,nby, nto:ttag): boolean;
    procedure resuadd(t: ttag);
    procedure setvals(ol: txseus);
    //function substisubs: ttag;
    //procedure readfileform;
    procedure initxmlinput(var xmlrpc: boolean; var soapcall: string);
    //function setstatex: boolean;
    function Execute(ns:string): boolean;
    function externalcmd: boolean;
    //function copysubatts(old, new: ttag; ): boolean;
    function preparebytag(old: ttag; var orignew: ttag): ttag;
    //; var newroot: ttag): ttag;
    function copysubatts(old, new: ttag): boolean;
    function doone(atag: ttag): ttag;
    function getcurrenthandler(msg: string): ttag;
    //function sel<DLELETED>root(st: string; def: ttag; var rest: string;
    //  needtowrite: boolean; var got tafree: boolean): ttag;
    //function getbookmarkpathx(st: string): TList;
    //function docom( acom: ttag): boolean;
    function doonerror: boolean;
    function writeelement: boolean;
    function setbookmark(vari: string; tagi: ttag): boolean;

  public
    //function checkauth:boolean;
    procedure readhtme;
    function readxsi(cname,handler: string):boolean;
    procedure writelog(msg: string; form: boolean);

  published
    function c_to: boolean;
    function c_from: boolean;
    function c_by: boolean;
    //function c_todb:boolean;
   // function c_fromall: boolean;

    //the very basics
    function c_apply: boolean;
    //function c_sort: boolean;
    // all kinds of looping and handling of multiple elements
    // use of  template-elements should be under "very basics", but templates will change soon
    function c_if: boolean;
    function c_oldif: boolean;  //outdated
    function c_case: boolean;
    function c_rematch: boolean;
    function c_iff: boolean;  //???
    function c_add: boolean;  //mainly replaced by xse:to
    function c_del: boolean;  //delete an element
    //some variations of add
    function c_html: boolean;   //abbreviation of add to write to browser. not really needed (at least at the moment the default is to write to browser)
    function c_copyelement: boolean;  //will be replaced by copy
    function c_copy: boolean;  //just short for copyelement
    function c_copyapply: boolean;
    function c_element: boolean;  //adds an element whose name can be given in attribute xse:name (so you can calculate the name) needs so rethinking....
    function c_head: boolean;  //adds an element whose name can be given in attribute xse:name (so you can calculate the name) needs so rethinking....

    //program flow etc
    function c_bookmark: boolean;
    function c_bookmark_to: boolean;
    function c_foreach: boolean;
    function c_while: boolean;
    function c_sleep: boolean;
    //problematic: what exactly is the scope of these:
    function c_break: boolean;
    function c_continue: boolean;
    function c_exit: boolean;
    function c_halt: boolean;
    //calling external apps
    function c_exec:boolean;
    function c_shellexec:boolean;
    // fighting endless loops etc. Unfinished stuff.
    function c_restart: boolean;
    function c_critical: boolean;
    function c_noncritical: boolean;
    function c_unlimited: boolean;
    function c_resettimer: boolean;
    //not functional, to be developed:
    function c_error: boolean;
    function c_except: boolean;


    //element-grafting
    function c_attributename: boolean;
    function c_elementname: boolean;
    function c_value: boolean;
    function c_attribute: boolean;
    function c_attributes: boolean;
    function c_setid: boolean;
    //change an attribute in result ..
    function c_move: boolean;
    function c_replace: boolean;
    function c_start: boolean;
    function c_stop: boolean;
    function c_stopall: boolean;
    //start and stop allow for building hierarchies other than that of the command-tree
    function c_rawcopy: boolean;
    //quick and dirty insertions of elements


    // vars etc
    function c_set: boolean;
    function c_comp: boolean;
    function c_inc: boolean;
    function c_incattribute: boolean;
    function c_clearvars: boolean;

    //produce text text
    function c_text: boolean;
    function c_line: boolean;
    function c_comment: boolean;
    function c_doc: boolean;

    //tcp-related
    function c_httpheaders: boolean;
    function c_htmlhead: boolean;
    function c_inithtml: boolean;
    function c_setcontenttype: boolean;
    function c_httpget: boolean;
    function c_httppost: boolean;
    function c_httpupload: boolean;
    function c_httphead: boolean;
    function c_httpspost: boolean;
    function c_sendmail: boolean;  //not sure whether works
    function c_reademsg: boolean;
    function c_ftpstore: boolean;  //not functioning??
    function c_ftpput: boolean;
    function c_soaprpc: boolean;
    function c_xmlrpc: boolean;
    // files
    function c_write: boolean;
    function c_delete: boolean;
    function c_dir: boolean;
    function c_filereplace: boolean;
    function c_copyfile: boolean;
    function c_copyfilescmd: boolean;
    function c_md: boolean;
    function c_rmd: boolean;
    function c_movefile: boolean;
    function c_unlock: boolean;
    function c_listlocks: boolean;
    function c_upload: boolean;
    function c_renamefile: boolean;
    //files - xml/xseus
    function c_save: boolean;
    function c_savefile: boolean;
    function c_nosave: boolean;  //nosave declares intention not to save, thus frees locking
    function c_lock: boolean;



    //parsers etc
    function c_parse: boolean;  //takes xml-text, produces xml elements
    function c_markdown: boolean;
    function c_streamread: boolean;
    function c_sapply:boolean;
    function c_parsexse: boolean;
    function c_parsecdata: boolean;
    function c_ical: boolean;
    function c_rruletolist: boolean; // ical repeat-rules)
    function c_json: boolean;
    function c_text2xml: boolean;  //text to paragraps, sentences, words (<div>, <p>, <span>)
    //function c_field2html(state:tstate): boolean;
    //function c_field2xml: boolean;  //old????
    //regexp & strings
    function c_split: boolean;  //split by regexp to give xml
    function c_t2x: boolean; //split csv-style text to xml
    function c_chop: boolean;  //chars to xml
    function c_diff: boolean;
    function c_js: boolean;  //some simple tokenizing only


    //debuggin
    function c_debug: boolean;
    function c_debugging: boolean;
    function c_debugids: boolean;
    function c_list: boolean;
    function c_listhandler: boolean;
    function c_listhandlers: boolean;
    function c_markmem: boolean;
    function c_setdebug: boolean;
    function c_logwrite: boolean;
    function c_nodebug: boolean;
    function c_showtime: boolean;
    function c_debugtext: boolean;

    //sessions etc  (havent used the for a while so not sure if these work. I think they do, but what they do is forgotten at the moment)
    function c_getauthorization: boolean;
    function c_readauthorization: boolean;
    function c_authorize: boolean;
    function c_login: boolean;
    function c_logout: boolean;
    function c_savesession: boolean;
    function c_session: boolean;
    function c_listsession: boolean;

    //installing new xseus apps (writing locations to ini-files)
    function c_setxseusapppath: boolean;
    function c_setxseusurlpath: boolean;
    function c_resetini: boolean;

    //testing, experimental, forgotten
    function c_nop: boolean;  //no operation - do nothing
    function c_hyphenfi: boolean;    //addhoc, will be removed
    function c_openid: boolean;  //these did something with open id providers, gotta
    function c_checkopenid: boolean;

    //sqlite stuff
    //function c_sqlcreate: boolean;  //just a plan to use sql
    function c_sqlexec: boolean;  //just a plan to use sql
    function c_sqlopen: boolean;  //open with transaction   and query
    function c_sqlselect: boolean;  //just a plan to use sql
    function c_sqlnext: boolean;  //just a plan to use sql
    function c_sqllist: boolean;
    function c_sqlprepare: boolean;
    function c_sqldoprepared: boolean;
    function c_sqlclose: boolean;
    function c_sqlconnect: boolean;
    function c_test: boolean;
    function c_callobject: boolean;  //probably not working. To start new xseus-processess, call them via url

    //don't remember
    function c_flush: boolean;
    // temporary redirecs .., splitting (non-hierarchical) files?
    function c_nooutput: boolean;
    function c_resumeoutput: boolean;
    function c_closeoutput: boolean;
    function c_copyfiles: boolean;
    function c_listparts: boolean;
    function c_output: boolean;

    //still there, waiting to be weeded
    function c_writehidden: boolean;
    function c_template: boolean; //just skips templates.. stupid
    function c_includexml: boolean;
    //usefull, but replaced by xse:from-attr
    function c_cleancdata: boolean;
    //function c_include: boolean; //usefull, but replaced by xse:by-attr
    function c_call: boolean;  //replaced by xse:by
    //probably needed. very complicated
    function c_function: boolean;
    function c_pokehtml: boolean;
  end;



procedure registerxseus(xse: TObject; s, e: TList);
//procedure clearelems(elems: TList);
//procedure clearstates(states: TList);
function readparamstoform(params: TStringList): ttag;



implementation

uses  xsemisc, xsefunc, synacode, xseauth,
  xseexp,  //xseftp,
  //xseoid,//xsetrie,//xsmarkd,
  xsemarkd,       sqldb,
  xserver, xsereg;
{tolist,fromlist:tlist;
//toele:pointer;
toselector, torootsel,fromselector: string;
toselected,fromselected:pointer;
toselecti:integer;
next:trelation;}

function txseus.c_sapply: boolean;
var i,j,olookat,c:integer;done,streamroot:boolean;//str:tstreamer;
atag,res,ofrom,oto,oby:ttag;oldpath:tstringlist;
stre:tjsonstreamer;
begin
  done:=false;
  ofrom:=curfromele;
  stre:=tjsonstreamer.create(curbyele.att('file'),curtoele,curbyele);

  {while (not jstr.eof) and (jstr.limitti<200) do
  begin
    //curtoele.subtags.add (jstr.next);
    atag:=jstr.next;
    writeln('<hr/>');
    try
    if atag<>nil then writeln('<li>',atag.head);except end;
    jstr.limitti:=jstr.limitti+1;
  end;

  exit;+0}
  {
  if x_stream=nil then
  begin
    streamroot:=true;
   x_stream:=tstreamer.create(curbyele.att('file'),curtoele,curbyele);
   olookat:=0;
  end else}
  begin
    { temp disabled, to be replaced by level-stuff
    oldpath:=x_stream.changepath(curbyele.att('path'));
    writeln('<li>changepath',x_stream.lookingat);
    streamroot:=false;
    olookat:=x_stream.lookingat;
    x_stream.lookingat:=x_stream.lookingat+1;
    }
  end;
  try
 //  res:=x_stream.walkthru;
 // x_stream.readline;
  c:=0;
  repeat
  begin
   //c:=c+1;
   //if c>300 then break;
   //res:=stre.next(1,0,curtoele);
   try
   res:=stre.next;
  //break;
  except
  writeln('<li>notgotkot?',res=nil);//,tstreamlevel(x_stream.levels[1]).tagi.head,'???');
  raise;
  end;
    if res=nil then break;
    if stre.eof then break;
    try
   //writeln('<li>gotkot:',stre.curline,i,'!!',stre.changedlev,'/',stre.targetdepth-1,'!!!');//tstreamlevel(x_stream.levels[1]).tagi.head,'???');
    except end;
  //curtoele.subtags.add(res.copytag);
   ofrom:=curfromele;
   oby:=curbyele;
   oto:=curtoele;
    for i:=stre.changedlev to stre.targetdepth-2 do
      c_stop;
    for i:=stre.changedlev to stre.targetdepth-2 do
    begin
      try
      //writeln('+++');
      curfromele:=tstreamlevel(stre.levels[i]).tagi;
      //curfromele:=curbyele;
      curbyele:=oby.subtags[i];
      //dosubelements;
      //nto:=ttag.create;
      //curtoele.subtags.add(nto);
      //curtoele:=nto;
      //writeln('<pre>',c,i,curbyele.xmlis,'</pre><hr/>');
      //curtoele.subtags.add(curbyele.copytag);
      //writeln('<li>',i,curfromele.xmlis);
      c_start;
      curbyele:=oby;
      //doelementlist(ttag(curbyele.subtags[i]).subtags);
      except writeln('nogo');end;
    end;
    //curbyele:=tstreamlevel(x_stream.levels[x_stream.targetdepth-1]).tagi;
    curbyele:=oby.subtags[stre.targetdepth-1];
    curfromele:=res;
    //writeln('<li>TO:',curtoele.head,'</li>');
    //resuadd(curfromele.copytag);
    //writeln('<xmp>****',res.xmlis,'</xmp><hr/>');
    try
    dosubelements; except writeln('fail do');end;
    //writeln('<li>DIDto:',curtoele.head);
    //curtoele.subtags.add(res.copytag);
    //ofrom:=curfromele;
    //curfromele:=res;
    //doelementlist(curbyele.subtags);
    curfromele:=ofrom;
    curbyele:=oby;

  end;
  until (stre.eof) or (c>1000);
  writeln('<h2>DIDGETSTREAM</H2><xmp>', i,   curtoele.xmlis,'</xmp>');


  exit;
  finally
   writeln('</ul><li>diddiip');
    if streamroot then
    begin
    stre.free;
    writeln('<li>saplied');
    curfromele:=ofrom;
    end else
    {begin
      x_stream.lookingat:=olookat;
      x_stream.pathtofind.free;
      x_stream.pathtofind:=oldpath;
    end;  }
   end;
  writeln('alliswell');
end;


function txseus.c_streamread: boolean;
var s:tstreamer;smem:cardinal;t,tot:ttag;i,newi,pari:integer;
begin
 //exit;
{ smem:=getheapstatus.totalallocated;
 s:=tstreamer.create(curbyele.att('file'),curtoele,curbyele.att('path'));
 s.skip:=curbyele.att('skip');
 //curtoele.subtags.add(s.parsexsi());
 //writeln('<li>streamermade,memlost=',getheapstatus.totalallocated-smem);;
   try
    //t:=s.doparse;
    //t:=s.nexttag;
    i:=0;
    resuadd(s.parseone);
    writeln('<li>stred:<xmp>',curtoele.xmlis,'</xmp>');
    s.free;
    exit;
    while not s.eof do
    begin
      //i:=i+1;if i>7 then break;
      t:=s.nexttag(0);
      if t<>nil then
      begin
        //restags[restags.count-downcount-1]
        pari:=s.xhilev;//restags.count-s.btcount-1;
        tot:=curtoele;
        try
         //writeln('<h3>placehit:',tot.vari,s.hilev,'</h3>');
        for i:=pari downto 1 do
        begin
         tot:=tot.subtags[tot.subtags.count-1];
         //writeln(tot.vari,'-');
        end;
         except writeln('<li>!!!!!!</li>');end;
        tot.subtagsadd(ttag(s.restags[pari]).copytag);
        //writeln('<xmp>',curtoele.xmlis,'</xmp>');
        //for i:=
        //curtoele.subtags.add(ttag(s.restags[pari]).copytag);
try
//writeln('<h3>tocopy',ttag(s.restags[pari]).xmlis,'</h3>');
//      writeln('<h3>copiedto',tot.xmlis,'</h3>');
except writeln('nonononon',tot=nil);end;
        //try t.free;except writeln('xxxxxxxxxxxx');end;
      end;
    end;
    //writeln('<xmp>???????????',t.xmlis,'</xmp>!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
   // resuadd(t);
   //curtoele.subtags.add(t);
   except writeln('nogoodstreamreading');end;
    //writeln('<li>streamerfreed,memlost=',getheapstatus.totalallocated-smem);;
    s.free;

 //s.parsexsi();
 //writeln('<hr><hr><hr><hr><hr><hr>');
  }
end;

function txseus.c_js:boolean;
var jssource,js:tstringlist;
iei,j,k,inde:integer;lin,alin,sps,acom,sourcetext:string;
insq,indq,insc,inmc,inpare:boolean;ch,prevch:char;
root,curt:ttag;
  procedure _linadd(ch:char);
  begin
    if insc then acom:=acom+ch else
    alin:=alin+ch;
  end;
  function _nextk(nch:char):boolean;
  begin
    result:=false;
    if k<length(lin) then
      if lin[k+1]=nch then begin k:=k+1;result:=true; end
end;

begin
  sourcetext:=curbyele.att('source');
  root:=curtoele;
  curt:=root;
  jssource:=tstringlist.create;
  sps:='                                                                                                ';
  js:=tstringlist.create;
  //jssource.loadfromfile('/home/t/xseus/apps/uusi.js');
  jssource.text:=sourcetext;
  inde:=0;
  inmc:=false; //multiline /* */ comment
  insq:=false;indq:=false;insc:=false;
  //root.addsubtag('style','div {margin-left:2em;border-left:1px solid gray} p {font-size:0.6em;font-style:italic;margin:0 0 0 4em;} pre{font-size:0.6em;color:gray}');
  //root.addatt('type=text/css');
    //apust.clear;
    //_split(jssource[i],';',apust);
    j:=-1;
    while j<jssource.count-1 do
    begin
        j:=j+1;
        lin:=trim(jssource[j]);
        alin:='';
        insq:=false;
        indq:=false;
        insc:=false;
        ch:='_';
        k:=0;
        while k<length(lin) do
        begin
          k:=k+1;
          prevch:=ch;
          ch:=lin[k];
          //if insc then begin acom:=acom+ch;continue;end else
          if inmc then // /*  */ -comment
          begin
            if (ch='*') and (_nextk('/')) then
            begin
              js.add(copy(sps,1,inde*3)+'/*'+(acom)+'*/');
              curt.addsubtag('pre',acom);
              acom:='';
              inmc:=false;
            end else acom:=acom+ch;
            continue;
          end;
          if ch='''' then
          begin
           insq:=not(insq);alin:=alin+'''';
          end else
          if ch='"' then
          begin
           indq:=not(indq);alin:=alin+'"';
          end else
          if ch='(' then
          begin
           inpare:=true;alin:=alin+'(';
          end else
          if ch=')' then
          begin
           inpare:=false;alin:=alin+')';
          end else
          if (insq or indq ) then alin:=alin+ch else
          case ch of
          '/': if  _nextk('/') then insc:=true else
               if  _nextk('*') then inmc:=true else
                 alin:=alin+ch;
          '{':  begin
               js.add(copy(sps,1,inde*3)+trim(alin)+'{');
               if alin<>'' then
                curt:=curt.addsubtag('div',stringreplace(alin,'<','&lt;', [rfReplaceAll]))
                else curt:=curt.subtags[curt.subtags.count-1];
               alin:='';
               inde:=inde+1;
               end;
          '}': begin
                js.add(copy(sps,1,inde*3)+trim(alin)+'}//'+inttostr(inde));
                if alin<>'' then  curt.addsubtag('div',stringreplace(alin,'<','&lt;', [rfReplaceAll]));
                curt:=curt.parent;
                inde:=inde-1;
                alin:='';
               end;
          ';': begin
              if not inpare then
               begin
                js.add(copy(sps,1,inde*3)+trim(alin)+';');
                if alin<>'' then curt.addsubtag('div',stringreplace(alin,'<','&lt;', [rfReplaceAll]));
               alin:='';
               end else _linadd(ch);
               end;
          else _linadd(ch);
          end;
          if insc then begin acom:='/'+copy(lin,k,999999);k:=99999;;end;
       end;
      if trim(alin)<>'' then begin curt.addsubtag('div',stringreplace(alin,'<','&lt;',[rfReplaceAll]));js.add(copy(sps,1,inde*3)+trim(alin)+';');end;
      if acom<>'' then if  not inmc then  begin curt.addsubtag('p',acom);js.add(copy(sps,1,inde*3)+'//-'+trim(acom));end;
      alin:='';IF NOT INMC THEN acom:='' else acom:=acom+crlf+copy(sps,1,inde*3)+'_';
    end;

      //js.addstrings(apust);
      //apust.clear;
  //writeln('<xmp>'+js.text+'</xmp><hr>');
  //writeln('<pre>'+jssource.text+'</pre><hr>');
  js.clear;jssource.clear;

end;
 function txseus.setbookmark(vari: string; tagi: ttag): boolean;
var
  obi: integer;
  at: ttag;
begin
 try
  for obi := 0 to x_bookmarks.subtags.Count - 1 do
  begin
    at := ttag(x_bookmarks.subtags[obi]);
    if at.vari = vari then
    begin
      //writeln('<XMP>biik2:');//,x_bookmarks.LISTRAW+'</XMP>');
      //ttag(at.subtags[0]).killtree; //xrefcount:=ttag(at.subtags[0]).xrefcount-1;
      at.subtags.Clear;
      at.subtags.add(CurFromEle);
      //at.Clearmee;
      CurFromEle.xrefcount := CurFromEle.xrefcount + 1;
      //writeln('<li>oldbookmark:', x_bookmarks.xmlis + '</li>');
      exit;
    end;
  end;
  begin
    at := ttag.Create;
    x_bookmarks.subtags.add(at);//addsubtag(bm, '');
    at.vari := vari;
    at.subtags.add(tagi);
    tagi.xrefcount:=tagi.xrefcount+1;
    //CurFromEle.xrefcount := CurFromEle.xrefcount + 1;
    //for i := 0 to x_bookmarks.subtags.Count - 1 do
    //  writeln('<li>bm' + ttag(x_bookmarks.subtags[i]).vari);
  end;
  finally
  //writeln('<li>addedbookmark:<XMP>' + x_bookmarks.xmlis, '</XMP>');

  end;

end;
{function txseus.setbookmark(vari: string; tagi: ttag): boolean;
var
  obi: integer;
  at: ttag;
begin
  //x_bookmarks.subtags.add(tagi);
  //exit;
  writeln('<li>bookmarkadd:<b>',vari,'</b>', tagi.xmlis + '</li>',x_bookmarks.subtags.count);
 try
  for obi := 0 to x_bookmarks.subtags.Count - 1 do
  begin
    at := ttag(x_bookmarks.subtags[obi]);
    if at.vari = vari then
    begin
    //  writeln('<XMP>biik2:');//,x_bookmarks.LISTRAW+'</XMP>');
      //ttag(at.subtags[0]).killtree; //xrefcount:=ttag(at.subtags[0]).xrefcount-1;
      //at.subtags.Clear;
      x_bookmarks.subtags[obi]:=at;
      //at.subtags.add(tagi);
//      at.subtags[0]:=tagi;
      //at.Clearmee;
      //tagi.xrefcount := tagi.xrefcount + 1;
      //writeln('<li>oldbookmark',obi,':<b>',vari,'</b>', x_bookmarks.xmlis + '</li>');
      exit;
    end;
  end;
  begin
    //at := ttag.Create;
    x_bookmarks.subtags.add(tagi);//addsubtag(bm, '');
    //at.vari := vari;
    //at.subtags.add(tagi);
    //tagi.xrefcount:=tagi.xrefcount+1;
    //CurFromEle.xrefcount := CurFromEle.xrefcount + 1;
    //for i := 0 to x_bookmarks.subtags.Count - 1 do
    //  writeln('<li>newbm:',vari,':<pre>' + x_bookmarks.xmlis,'</pre>');
  end;
  finally
  //writeln('<li>addedbookmark:<XMP>' + x_bookmarks.xmlis, '</XMP>');

  end;

end;
}
function txseus.c_shellexec: boolean;
begin
  curtoele.vali:=launchprogram('sh -c','"'+curbyele.att('cmd')+'"',true);
end;

function txseus.c_exec: boolean;
var res:tstringlist;
begin
curtoele.vali:=launchprogram(curbyele.att('exe'),curbyele.att('cmd'),true);
//curtoele.addsubtag('',res.text);
//curtoele.vali:=res.text;
//writeln('debug:<xmp>',res.text,'</xmp><hr/>');
//res.free;
end;

function txseus.c_httpheaders: boolean;
var
  i: integer;
  hdrs: TStringList;
  vari, vali: string;
  stag:ttag;
begin
  //hdrs :=
  curtoele.vali:=tserving(x_serving).requestheaders.text;
  tserving(x_serving).responseheaders.clear;
  //hdrs.clear;
  tserving(x_serving).statusline:=curbyele.vali;
  //logwrite('Statusline:'+tserving(x_serving).statusline);
  for i := 0 to curbyele.subtags.Count - 1 do
  begin
   stag:=curbyele.subtags[i];
   tserving(x_serving).responseheaders.add(stag.vari+'='+stag.vali);
  end;
  {for i := 0 to curbyele.getattributes.Count - 1 do
  begin
    vari := CurBYEle.getattributes[i];
    vali := cut_rs(vari);
    vari := cut_ls(vari);
    tserving(x_serving).responseheaders.values[vari] := vali;
   // tserving(x_serving).responseheaders.add(vari+': '+vali);
  end;}
  //responseheaders.values['content-type']:='text/xml' else
  //responseheaders.values['content-type']:='text/xml' else
end;

function txseus.c_setcontenttype: boolean;
{D: sets response content-type (default text/html)
must be done before http/html is inited, ie. before anything is written out
ashould be expanded to handle any http-headers
}
begin
  tserving(x_serving).contenttype := CurBYEle.att('type');
  //myxs.response.
  //filestream:=tfilestream.create(
end;

function txseus.c_openid: boolean;
var
  oid: toid;
begin
  oid := toid.Create;
  //tserving(x_serving).statusline:='HTTP/1.1 302 FOUND';
  //tserving(x_serving).setheader('location','http://belyykit.wordpress.com/?openidserver=1');
  oid.redirect(curbyele.att('url'), x_cookie);
  //oid.redirect('http://belyykit.wordpress.com/?openidserver=1',x_cookie);
end;

function txseus.c_checkopenid: boolean;
var                                 oid: toid;
  resform: ttag;
begin
  oid := toid.Create;
  //tserving(x_serving).statusline:='HTTP/1.1 302 FOUND';
  //tserving(x_serving).setheader('location','http://belyykit.wordpress.com/?openidserver=1');
  x_session.addsubtag('a', 'b');
  resform := oid.check_auth(curbyele.att('url'), x_form);
  if (resform <> nil) then // and (resform.
  begin
    resuadd(resform);
  end;
end;




function txseus.c_sqlclose: boolean;
begin
 closeall_sql(x_databases);
 x_databases.clear;
end;
function txseus.c_sqlconnect: boolean;
// open database connection without  starting transaction
var d:tdb;
begin
  d:=tdb.create(curbyele.vali);
  x_databases.addobject(curbyele.vali,d);
end;

function txseus.c_sqlexec: boolean;
var newtag:ttag;i,
   //fi:integer;stime:tdatetime;
  c,t,q:pointer;db:tdb;
  //execute single query &close transaction, criticalpoints,timeouts?
begin
  db:=getdb_sql(curbyele.vali,x_databases);
  //for i:=1 to 100 do

 // c:=sql_getconnection(curbyele.att('db'));
//  t:=sql_starttransaction(c);
//  q:=sql_query(c,t,curbyele.att('q'));
//  writeln('<li>queried in ',MilliSecondsBetween(now,stime));
 //x_databases.add(tdb.create('/home/t/xseus/turha.db'));
 writeln('<li>do_execsql:',x_databases.Count,'</li>');
 //x_database.sql_list(curbyele.att('query'));
  db.sql_exec(curbyele.att('q'));
  writeln('<li>did_exec<li>');
 // createdb;

end;


function txseus.c_sqlopen: boolean;  //open with transaction   and query
var db:tdb;i:integer;
begin
  db:=getdb_sql(curbyele.vali,x_databases);
  writeln('USING DB:',db.name,'!');
 //di:=x_databases.indexof(curfromele.vali);
  db.sql_open(curbyele.att('q'));
end;

function txseus.c_sqlselect: boolean;
var subtags,oldto:ttag;i:integer;comlist:tlist;db:tdb;
  fn:string;
  //create a temporary table with open transaction to be applied
begin
  writeln('<li>createdb '+fn);
  fn:=curfromele.att('db');
  db:=tdb.create(fn);
  x_databases.addobject(fn,db);
  writeln('<li>query: ',curbyele.att('q'));
  //x_database.sql_query(curbyele.att('query'));
  db.sql_gettable(curbyele.att('q'));
  writeln('<li>didq <hr>');

end;
function txseus.c_sqlnext: boolean;
//needs a connection with open transaction and query
var subtags,oldto:ttag;i,fi:integer;comlist:tlist;ret:ttag;db:tdb;
begin
  writeln('<li>getnextt ',x_databases.Count,curbyele.xmlis);
   db:=getdb_sql(curbyele.vali,x_databases);
   writeln('<li>openeddb:',db.name);

   if (db.Q=nil) or (db.t=nil) then
   begin
     writeln('<li>No query active '+curtoele.xmlis);
   end;
   ret:=ttag(db.sql_next);
   if ret<>nil then curtoele.subtags.Add(ret);

end;
function txseus.c_sqlprepare: boolean;
//needs a connection with open transaction and query
var ret:ttag;db:tdb;
begin
  writeln('<li>preparequery ',x_databases.Count,curbyele.xmlis);
   db:=getdb_sql(curbyele.vali,x_databases);
   writeln('<li>db: ',db.name);
   db.sql_prepare(curbyele.att('q'));
   writeln('<li>preparedquery: ',db.name,' /query:',db.Q.SQL.text,' /params:',db.q.Params.count);

end;

function txseus.c_sqldoprepared: boolean;
//needs a connection with open transaction and query
var ret:ttag;db:tdb;
begin
  db:=getdb_sql(curbyele.vali,x_databases);
 // writeln('<li>prepared: ',db.name);//,':',db.q.params.count);

   if (db.Q=nil) or (db.t=nil) then
   begin
     writeln('<li>No query active '+curtoele.xmlis);
   end;
   db.sql_doprepared(curbyele.getattributes);

end;

function txseus.c_sqllist: boolean;  //debuggin mainly on mind
begin
    //curtoele:=oldto;
    //logwrite('DidclearS***from:'+curfromele.vari);
  end;

function txseus.c_test: boolean;
var
  st, needle: string;
  star, respos, ressea: tdatetime;
  i, j, posi, len: integer;
  sts: tstringstream;
  stf: tfilestream;
  stl:tstringlist;
begin
{ // copytosfile;exit;
  //sts:=tstringstream.create;
 // if curbyele.att('debug')<>'' then trie_debug:=true else trie_debug:=false;
  if curbyele.att('big')<>'' then
  begin
    //readrdfstream(strtointdef(curbyele.att('bytes'),10000));
    readrdfstream2(strtointdef(curbyele.att('triples'),10000));
  end
  else
  testtrie;
  exit;
  writeln('<ul>');
  for i:=0 to stl.count-1 do
   writeln('<li>',i, stl[i],'</li>');
  writeln('</ul>');
  //st := _filetostr('/home/t/xseus/www/kungpao.xsi');
  //stf.filename='/home/t/xseus/www/kungpao.xsi';
  //stf.
 }
{  st:='';
  needle:=curbyele.att('st');
  len:=strtointdef(curbyele.att('len'),100);
  writeln('<h1>start for ',curbyele.xmlis,'</h1>',len,needle);
  for i:=0 to 20000000 do
    st:=st+char(random(255));
  star:=now;
  writeln('startat:',datetostr(now));
  for i:=1 to 10 do
    posi:=pos(needle,st);
  writeln('<li>pos:',now-star,'</li>');
  star:=now;
  writeln('startat:',datetostr(now));
  for i:=1 to 5 do
    posi:=_quicksearch(needle,st);
  writeln('<li>qsea:',now-star,'</li><h1>shorttext</h1>');}
  {
  st:='';
  for i:=0 to len do
    st:=st+char(random(255));
  star:=now;
  writeln(len,'startat:',datetimetostr(now),' tofind:',needle);
  for i:=1 to 5000 do
    posi:=pos(needle,st);
  respos:=now-star;
  writeln('<li>pos:',now-star,'</li>');
  star:=now;
  writeln(len,'startat:',datetimetostr(now));
  for i:=1 to 5000 do
    posi:=_quicksearch(needle,st);
  ressea:=now-star;
  writeln('<li>qsear:',now-star,'</li>');
  writeln('<h1>sea-pos:',ressea-respos,'</li>');
  writeln('<h1>sea div pos:',round(ressea*1000000000) / round(respos*1000000000),'</li>');}
end;

procedure txseus.resuadd(t: ttag);
begin
  try
    curtoele.subtags.add(t);
    t.parent:=curtoele;
  except
    writeln('failed to add to result', curtoele.subtags = nil, t = nil);
    writeln('failed to add to result', curtoele.xmlis, '!');
    writeln('succeeded to fail');
  end;
end;


function txseus.writeelement: boolean;
var
  st: string;i:integer;
begin
  try
  if curtoele = nil then
  begin //writeln('noono7             ');
    writeln('<--failed - nothing to write to  browser-->');
    exit;
  end;
  //if not httpinited then
  try
    st:='';
    if pos('temporaryto',curtoele.vari)=1 then
     for i:=0 to curtoele.subtags.count-1 do st := st+ttag(CurToEle.subtags[i]).listxml('', False, False)
   else
    st := CurToEle.listxml('', False,false);
   //st:='writeelement disabled';
    //logwrite('testwrite:'+st+'!!!!'+curtoele.head);
    //if t_debug then
    except try writeln('fail curtoele list');//writeln('<li>failed nogotoutputst:'+curtoele.head+'!!!',x_started.count,x_stopped.count,'!!!</li>',curtoele.subtags.count);
      except writeln('ele to write fucked up',curtoele=nil);end;
    end;
    try
    if st <> '' then
    begin
      if not htmlinited then
      begin
        //logwrite('Writeeinit');
        c_inithtml;
        //logwrite('//Writeeinit');
        //writeln('initedit+<xmp>'+curbyele.xmlis+'</xmp>------');
        //httpinited := True;
      end else
      //logwrite('wasinited:'+curtoele.vari+'!!!'+st+'!!!');
      htmlinited := True;
      //writeln('writetxt:');
      //for i:=1 to 1000 do
      if st<>'' then writeln(st);
     // if st<>'' then writeln(st);
      //logwrite('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'+st);
    end;

  except
    writeln('failed elr writebrows');
  end;
try
  //logwrite('KILL:'+curtoele.xmlis);
    CurToEle.killtree;
  // logwrite('KILLED:');
   // writeln('KILLED:');

  except
    writeln('<li>failed write - cleanup');

  end;
  curtoele:=nil;
  //if t_debug then
  //writeln('</ul></li><li>wtoet!</li>');

except
  writeln('failed writetoclient');
end;
//finally   writeln('<li> wrotetoclient');end;

end;  //of browseroutput


procedure _testloops(ele:ttag);
var was:tlist;i:integer;

function levs(ele:ttag):boolean;
var curlev:integer;atag,PTAG:ttag;alev,levs:tlist;
begin

  levs:=tlist.create;
  alev:=tlist.create;
  alev.AddList(ele.subtags);
  levs.add(alev);
  writeln('<li>xlist:'+ele.xmlis);
  // ptag:=ele;
 curlev:=0;
 while curlev>=0 do
 begin
    atag:=ttag(alev[0]);
    alev.delete(0);
    writeln('<li>',curlev,atag.head+'</li>');
    if atag.subtags.count>0 then
    begin
      alev:=tlist.create;
      alev.AddList(atag.subtags);
      levs.add(alev);
      curlev:=curlev+1;
      continue;
    end;
    while alev.count=0 do
    begin
     alev.Free;
     levs.delete(levs.Count-1);
     curlev:=curlev-1;
     alev:=levs[curlev];
    end;
 end;
end;
function alevrec(t:ttag):boolean;
var ii:integer;
begin
 try
 try
 if t=nil then logwrite(inttostr(i)+'NILTAG');
 if t.subtags=nil then logwrite(inttostr(i)+'NILSUB') else
   if t.subtags.count>1 then logwrite(inttostr(i)+'subcount:'+inttostr(t.subtags.count));
 if i mod 1000=0 then logwrite(inttostr(i)+'//'+inttostr(t.subtags.count));
   except writeln('failedheadpart');end;
   //t.head;
   i:=i+1;
   //logwrite('tryingsub');
  for ii:=0 to   t.subtags.count-1 do
  begin
    try
    //logwrite('trysub');
    if (was.indexof(t.subtags[ii])>=0) or (t.subtags[ii]=nil) then
     begin
        logwrite('aloopppppppppppppppppppppppppppppppp'+inttostr(ii));
     end else
     if  (t.subtags[ii]=nil) then
      begin
         logwrite('nilnilnil'+inttostr(ii));
      end else
      begin
       // logwrite('trytrysub');
       was.add(t.subtags[ii]);
       if ttag(t.subtags[ii]).subtags.count<>1 then logwrite(inttostr(ii)) else alevrec(t.subtags[ii]);
      end;
      except logwrite('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'+inttostr(i));end;

  end;
   except logwrite('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');end;
end;

begin
 was:=tlist.create;
 was.add(ele);
 i:=0;
 logwrite('testingloops');
 logwrite(ele.head);
 try
 levs(ele);
 except
   logwrite('failedloops'+inttostr(i));end;
 logwrite('testedloops'+ele.head);

end;

function txseus.c_to: boolean;
var
  place, ele, outfile, outvar,rest, apus,byvali,head: string;
  tmpoldres, rootsel, resupar,gottafree,pseudoroot: ttag;
  browseroutput, wasdatatag: boolean;
  i, rootpos, resupoint: integer;
{
    /test/+  =firstchild
    /test/++ =lastchild
    /test    =replace
    /test/   =at
    /test/..

}
 { procedure getplaceinfix;
  begin
    place:='';
    if pos('at:', ele) = 1 then
    begin
      ele := copy(ele, 4, 999);
      place := 'at';
    end else
    if pos('replace:', ele) = 1 then
    begin
      ele := copy(ele, 9, 999);
      place := 'replace';
    end
    else
    if pos('after:', ele) = 1 then
    begin
      ele := copy(ele, 7, 999);
      place := 'after';
    end
    else
    if pos('before:', ele) = 1 then
    begin
      ele := copy(ele, 8, 999);
      place := 'before';
    end
    else
    if pos('firstchild:', ele) = 1 then
    begin
      ele := copy(ele, 12, 999);
      place := 'firstchild';
    end;
  end;
  }
  procedure getresupoint;
  var i:integer;
  begin
   try
   //resupoint is not anymere used outside this function. But this sets the resupar
    if (place = 'at') then
    begin
      //replace all subtags, keep old vari and atts
      //writeln('<li>AT:'+resupar.xmlis+ele);
      resupoint := 0;
      for i:=resupar.subtags.count-1 downto 0 do
      begin
       ttag(resupar.subtags[i]).killtree;
      end;
      resupar.subtags.clear;
      exit;
    end;// else
    pseudoroot:=ttag.create;
    pseudoroot.vari:='tmp_toelement';
    if (place = 'replace') then
    begin  //replace probably not working as intended (what is intended?)
      if resupar=x_data then begin //writeln('xxxxxxxxxxxxxxxxxxxx'+x_data.xmlis);
        wasdatatag:=true;end;
      //resupoint := resupar.subtags.indexof(tmpoldres);
      //writeln('<li>replace',resupar.xmlis);
      resupoint := resupar.parent.subtags.indexof(resupar);
      //writeln('<li>replace',resupoint, resupar.parent.xmlis);
      if resupoint>=0 then
      begin
      resupar.parent.subtags.Delete(resupoint);
      resupar.killtree;
      end  else resupoint:=resupar.parent.subtags.Count;
      resupar := resupar.parent;
      //writeln('<li>replaced',resupoint, resupar.parent.xmlis);
    end
    else
    if (place = 'after') then
    begin
      resupoint := resupar.parent.subtags.indexof(resupar) + 1;
      resupar := resupar.parent;
    end
    else
    if (place = 'before') then
    begin
      resupoint := resupar.parent.subtags.indexof(resupar);
      resupar := resupar.parent;
    end
    else
    if (place = 'firstchild') then
    begin
      resupoint := 0;
    end
    else
    begin  //lastchild
      try
      resupoint := resupar.subtags.Count;
      except writeln('failed pointless resupoint',resupar=nil);end;
    end;
   except writeln('<li>failedtresupoint:'+place+'!',resupar.head,'//',resupoint);end;

  end;
{function agetfile(st:string):string;
var i:integer; inf:boolean;
  begin
    result:='';inf:=false;
    for i:=1 to length(st) do
      if st[i]=')' then break else
      if st[i]='(' then inf:=true else
      if inf then result:=result+st[i];

  end;
}
var startedbefore:integer;
begin
  try
    startedbefore:=x_started.elems.count;
    // writeln('DOTO::',curbyele.head);
    pseudoroot:=nil;
    wasdatatag:=false;gottafree:=nil;
     //if byvali<>'' then    begin     end;
    //writeln('STARTING XSE:TO');
    //place := '';
    tmpoldres := curtoele;
    browseroutput := CurBYEle.att('browser') = 'true';
    ele:=trim(curbyele.vali);
    if ele='' then ele := curbyele.att('element');
    outfile := CurBYEle.att('file');
//    place := curbyele.att('place'); //ns+''???
    head:=curbyele.att('header');
    outvar:=curbyele.att('outvar');
   // if outfile<>'' then       writeln('<li>head?',curbyele.vari,'<b>',curbyele.head+'</xmp>/head:',head);
  {
    begin
    end else}

    if (outfile <> '') or (outvar <> '') or (browseroutput) then //or (place='replace') then
    begin
       pseudoroot := ttag.Create;
       pseudoroot.vari:='temporaryto'+inttostr(random(10000));
       curtoele:=pseudoroot;
       //end;
       //if place<>'' then
    end;
  except
    writeln('failed to read to-tag');
    raise;
  end;
  //    if (curbyele.subtags.Count > 0) then
  //      doelements;
  // writeln('<h2>DOTO:'+ele+'!</h2><xmp>',curbyele.xmlis,'</xmp>',place,'<hr/>');

  if ele <> '' then
  begin
    try
      //if place='test' then
      begin //NEW SYNTAX FOR whereTO
        //writeln('<li>try:'+':'+curbyele.head+'_');
        if ele[1]='-' then begin place:='before'; ele:=copy(ele,2,length(ele)-1) end
        else if ele[1]='+' then begin place:='after'; ele:=copy(ele,2,length(ele)-1) end
        else   if ele[length(ELE)]='/' then place:='' //lastchild
        else   if ele[length(ELE)]='!' then place:='replace' //lastchild
        //else if ele[1]='!' then begin place:='replace'; ele:=copy(ele,2,length(ele)-1) end
        else  if ele[length(ELE)]='+' then  begin place:='firstchild'; ele:=copy(ele,1,length(ele)-1) end
        else place:='at';
        //writeln('<li>place:'+place+':'+ele,ele[1]='/',xml.head);
        //getplaceinfix;
      end;

      //if place='' then getplaceinfix;

      rootpos := 1;
      rootsel := p_selroot(ele, self, tmpoldres, rootpos, True, gottafree);
      //instead of place-attribute, place may be given by prefix Needs rethinking and/or rewriting
      browseroutput := False;
      //rootsel := p_selroot(ele, self, curtoele, rootpos, True, gottafree);
      //rootsel := p_selroot(ele, self, tmpoldres, rootpos, True, gottafree);
      //writeln('<li>didselroot:',length(ele),'_',rootpos,rootsel.head+'/left:'+trim(copy(ele, rootpos, 9999)+']</li>'));
      if rootsel = nil then
      begin
        writeln('<li>failed: noroot for: '+ele+'!',xml.head);
        rootsel:=ttag.create;//rootsel.parent=
        //rootsel := xml;
      end;
      //note  to=file / http makes little sense (or is not implemented)
      //writeln('<li>resupar::',ele,rootpos,'<b>'+rootsel.head+'</b>'+copy(ele, rootpos, 9999));
      //why???? if (rootpos = 1) or (length(ele)<rootpos ) then
      if length(ele)<rootpos then
        resupar := rootsel
      else
      begin
        resupar := rootsel.subt('+' + trim(copy(ele, rootpos, 9999)));
//CCC      curtoele.parent:=resupar;
        //resupar := rootsel.subt('+' + trim(copy(ele, rootpos, 9999)));
        //writeln('<li>GOTREST:',resupar.xmlis);
      end;
      if place<>'' then  getresupoint;
      if pseudoroot=nil then
      begin
       //if resupar<>nil then
       curtoele:=resupar
      end
      else
      curtoele:=pseudoroot;
      //resupar := rootsel.subt('+' + trim(rest));
      //writeln('<li>doin_'+ele+'_place:'+place+'_res:'+copy(resupar.xmlis,1,50)+'___to:'+copy(curtoele.head,1,50)+'!!!by:'+curbyele.head);
      //if curtoele.parent<>nil then writeln('<li>to-parent:',curtoele.parent.head) else writeln('<li>tyo-nil');
    except
      writeln('<li>FAILED xse:to', ele, '|');
      exit;
      //raise;
    end;
    //writeln('<li>curto:'+curtoele.xmlis+'!by:'+curbyele.head);
    //writeln(ele,rootpos,'<li>root:'+rootsel.vari+'/rest:'+trim(copy(ele, rootpos, 9999))+'/resu:'+resupar.xmlis+'!!!');
    //!getresupoint;
    //!writeln('<li>ROOT:'+xml.xmlis+'!');
    //!curtoele.parent := resupar;
  end;
  if curtoele=nil then
  try
   //writeln('<li>DOINGNIL to::'+resupar.head+'//atroot:'+rootsel.HEAD,'/curto',resupar=curtoele,curbyele.head);
  except writeln('<li>dointonil:',resupar=nil,pseudoroot=nil);end;

  //***************************DOIT*******************************************************//
  if (curbyele.subtags.Count > 0) then
    dosubelements;
  //***************************DIDIT*******************************************************//

  //if t_debug then
  try
   //logwrite('didtox');
   // logwrite('to_stop'+inttostr(x_started.elems.count)+'/'+inttostr(startedbefore));
  if startedbefore=0 then c_stopall else
  while x_started.elems.count>startedbefore do c_stop;
  except logwrite('nosptop');end;
  //logwrite('to_stop'+inttostr(x_started.elems.count)+'/'+inttostr(curtoele.subtags.count)+curtoele.head);
  //if curtoele<>nil then _testloops(curtoele);

  //  c_stopall(startedbefore);
  //writeln('<h1>didto'+ele+' </h1>/got:<xmp>'+curtoele.LISTxml('  ',FALSE),'</xmp>!!!/file:'+outfile+'/ele:',ele,'!!!',browseroutput);
  //#if t_debug then
  //writeln('<em>resuto'+resupar.head+'</em>',x_started.count,x_stopped.count);
  //try
  //while x_stopped.count>0 do x_stopped.delete;
  //except writeln('<li>stopped failed?');end;
  if ele <> '' then
  begin
    //writeln('<li>GOTGOTGOTGO:'+curtoele.xmlis+'¤¤¤¤¤¤¤¤¤¤');
    try
      try
//       getresupoint;
       except writeln('<li>***failed getresupoint:'+place+curbyele.xmlis);end;
    //writeln('<li>GOTGOTGOTGO:'+curtoele.xmlis+'¤¤¤¤¤¤¤¤¤¤');
    //writeln('<li>GOT2:'+resupar.head+'',resupar=curtoele);
    //if curtoele.subtags.count=0 then
    if wasdatatag then x_data:=curtoele.subtags[0];
    //writeln('<li>xse:to:'+resupar.vari+inttostr(resupoint));
    //CCC if curtoele=nil then writeln('<h2>failed xse:to - result=nil</h2>');
    if pseudoroot<>nil then
    begin
      for i := curtoele.subtags.Count - 1 downto 0 do
      begin
        try
          if curtoele.subtags[i]=nil then continue;
          resupar.subtags.insert(resupoint, curtoele.subtags[i]);
          ttag(curtoele.subtags[i]).parent:=resupar;
        except
          writeln('failedinsertat ', resupoint, curtoele.subtags.Count);
        end;
      end;
      for i := 0 to curtoele.attributesCount - 1  do
        resupar.addatt(curtoele.getatt(i));
      resupar.vali:=curtoele.vali;
      curtoele.clearmee;
      curtoele.free;
      //if t_debug then
     end;
    //writeln('<li>didto:'+copy(resupar.xmlis,1,50)+'___'+copy(curtoele.xmlis,1,50)+'!!!');
     {only for file and http : if gottafree<>nil then
      begin
        apus:=_INDIR(agetfile(ele),X_OUTDIR,SELF,TRUE);
        //writeln('<li>xse:tofile:'+APUS,'!!!',gottafree.xmlis+inttostr(resupoint));
        if not GOTTAFREE.saveeletofile(apus, False, '', True) then
          writeln('failed to create file:' + apus)
        //_indir(loc, xs.x_outdir, xs, needtowrite);
      end;}
      {CCC curtoele.vari:='whatthefuckisthis';
      curtoele.clearmee;}
    except
      writeln('failedxseTOelement');
    end;
  end
  else
  if browseroutput then
  begin
      if not httpinited then
      begin
        c_inithtml;
        httpinited := True;
      end;

    //writeln('<li>did not tobrowser');
    //writeln('<li>did not tobrowser',curfromele.xmlis());
    writeelement;

  end
  else  //of browseroutput
  if outvar <> '' then
  begin
     x_svars.values[outvar]:=curtoele.listxml('    ',false,true);
     CurToEle.killtree;
  end  else  //of varoutput
  if outfile <> '' then
    begin
    try
      if (trim(curbyele.vali) <> '') and (curbyele.subtags.Count = 0) then
      begin
        //INDIR_AUTH
        apus := _indir(outfile, x_outdir, self, True);
        _writefile(apus, curbyele.vali);
        writeln('<li>writing raw text value - did you mean this?');
      end;
      if CurToEle = nil then
      begin
        writeln('nilresult_tofile');
        exit;
      end;
      //INDIR_AUTH
      apus := _indir(outfile, x_outdir, self, True);
      begin
        try
         //writeln('<li>savefile:',apus,'/head:<xmp>!',head,'!</xmp></li>');
         if curtoele.subtags.Count > 0 then
            if not ttag(CurToEle.subtags[0]).saveeletofile(apus, true, head,'  ', false, curbyele.att('entities')='true') then
              writeln('failed to create file:' + apus)
        except
          writeln('faileedtowrite out:' + apus);
        end;
      end;
      //writeln('<li>free element after writing to file');
      CurToEle.killtree;
    except
      writeln('failed outfileresult');
      raise;
    end;
  end
  //of outfile
  else
  begin
    writeln('<li>Nowhere to write to!</xmp>', curtoele.xmlis + '</xmp><hr/>');
    //writeln('<LI>didto:<B>',curtoele.VARI,'</B> now to:',tmpOLDRES.VARI,xml.subtags.count,'<xmp>',tmpoldres.xmlis,'</xmp></LI>');

  end;
  //if t_debug then writeln('<li>TODONE:',outfile,'::<b>', ele, '</b>//<pre>', (curbyele.xmlis), '\\</pre>', '\\<b>',outfile,'</b></li>');
  //if curtoele<>nil then writeln('<xmp>'+tmpoldres.xmlis+'</xmp>');
  {if (tmpoldres.vari='') and (tmpoldres.subtags.count=0) then
  begin tmpoldres.killtree;
    curtoele:=nil;
    writeln('forgetemptypseudo_to');
   end else}
  //logwrite('TO/TO:');//RESUPAR.head,resupar=curtoele,'</li>');
  CurToEle := tmpoldres;
  //writeln('<li>TO-END',curtoele=nil,'</li>!!!!');//<xmp style="color:red">', xml.xmlis, '!</xmp><hr/>');
  if curtoele<>nil then logwrite('didto:'+curtoele.xmlis+'!') else logwrite('tonil');
end;

function txseus.c_clearvars: boolean;
var toclear:string;i:integer;
begin
   toclear:=curbyele.att('pattern');
   if toclear='' then x_svars.clear else
   for i:=x_svars.count-1 downto 0 do
     if _matches(toclear, x_svars.names[i]) then
       x_svars.delete(i);
end;

function txseus.c_from: boolean;
var
  ele: string;
  elemstrs: TStringList;
  rootsel, fromtag, oldseltag, ctag: ttag;
  fromregex, fromlist,fromtext, fromelem, fromfile, fromurl, rest, restring,
  apust, rawtext, opath: string;
  gottafree: ttag;
  apui, rootpos: integer;
  isxsi: boolean;
begin
  //writeln('<h1>from</h1>');
  isxsi := False;
  fromfile := CurBYEle.att('file');
  fromurl := CurBYEle.att('url');
  fromelem := CurBYEle.att('elem');
  fromregex := CurBYEle.att('regex');
  fromlist := CurBYEle.att('list');
  if fromelem = '' then
    fromelem := CurBYEle.att('element');
  fromtext := CurBYEle.att('text');
  oldseltag := CurFromEle;
 TRY
  //fromstring:=CurBYEle.att('string');
  //fromsreg:=CurBYEle.att('regexp');
  //writeln('<li>c_from_'+fromurl+'<hr/>'+curbyele.xmlis+'</li>');
  if fromfile + fromurl <> '' then
  begin
    if pos(extractfileext(fromfile + fromurl), '.xsi.htmi') > 0 then
      isxsi := True;
    if fromfile <> '' then
    begin
      apui := pos(';', fromfile);
      if apui > 0 then
      begin
        fromeleM := copy(fromfile, apui + 1, 999);
        fromfile := copy(fromfile, 1, apui - 1);
      end
      else
        fromeleM := '';
      if pos('!', fromfile) = 1 then
      begin
        opath := getcurrentdir;
        setcurrentdir(x_commanddir);
        try
          fromfile := _indir(copy(FROMfile, 2, 99), x_commanddir, self, False);
        finally
          setcurrentdir(opath);
        end;
      end
      else
        fromfile := _indir(fromfile, x_outdir, self, False);
      //writeln('<li>fromfile:',fromfile);

      try
        rawtext := _filetostr(fromfile);
      //logwrite('fromfile'+inttostr(length(rawtext))+rawtext);//+':'+:rawtext);
      //if pos('inon',fromfile)>0 then writeln('didfiletostr:!!!!!!!!!<xmp>',rawtext,'</xmp>');
      //writeln('<li>didreadraw'+inttostr(length(rawtext))+'<xmp>'+_clean(rawtext)+'</xmp>');
      except writeln('<li>could not read fromtext');
      end;
    end
    else //url
    begin
      //writeln('<li>FRMURL:',FROMURL,'! ');
      apui := pos(';', fromurl);
      if apui > 0 then
      begin
        fromeleM := copy(fromurl, apui + 1, 999);
        fromurl := copy(fromurl, 1, apui - 1);
      end
      else
        fromeleM := '';
      if pos('https://', fromurl) = 1 then
        rawtext := _httpsget(fromurl, -1, CurBYEle.getattributes)
      else
        rawtext := _httpget(fromurl, -1, CurBYEle.getattributes);
       logwrite('FRMURL:'+FROMURL+'! '+fromelem  +'!!!'+rawtext);
    end;
    if curbyele.att('skipto') <> '' then
    begin
      //writeln('<li>skipto:'+curbyele.att('skipto'),length(rawtext),'foundat:',_quicksearch(curbyele.att('skipto'),rawtext),'</li>');
      rawtext := copy(rawtext, _quicksearch(curbyele.att('skipto'), rawtext),
        length(rawtext));
      //writeln('<li>skipped to:<xmp>'+curbyele.att('skipto'),'</xmp>',length(rawtext),'</li>');//<xmp>',rawtext,'</xmp>');
    end;
    //g_debug:=true;
    //writeln('<h2>parsefromurl</h2>');
    try
     if rawtext<>'' then
    fromtag := strtotag(rawtext, isxsi) else fromtag:=nil;
    except writeln('<li>failed to parse fromtext');    end;
    //if fromtag<>nil then writeln('<pre>'+fromtag.xmlis+'</pre>');
    //g_debug:=false;
     //writeln('<li>parsedFRM:',FROMurl,'::', fromelem,'<xmp>', rawtext,'</xmp><h2>',fromtag.vari,'</h2><xmp>',fromtag.xmlis, '</xmp>xxxxxxxxxxxxxx<b>',fromelem,'</b></li>');
  end  //file or url
  else
  if fromlist <> '' then
             fromtag:=_listtotag(fromlist,'')
  else
  if fromtext <> '' then
  begin
    //writeln('from:',fromtext,'/withrregexp:',fromregex);
    if fromregex <> '' then
    begin
      //writeln('REGSPLIT:<pre>'+fromregex+'!'+fromtext+'</pre>');
      fromtag := regtoele(fromregex, fromtext);
      fromtag.vari := 'result';
      //writeln('REGSPLAT:<pre>'+fromtag.xmlis+'</pre>');
    end
    else
     try
      if fromtext<>'' then fromtag := tagparse(fromtext, False, True) else fromtag:=nil;

     except writeln('<li>failed to parse '+fromfile);
     end;
     fromelem := '';
    //writeln('from<xmp>',fromtag.xmlis,'</xmp>');
  end
  else
  if fromelem <> '' then
  begin
    try
      rootpos := 1;
      fromtag := p_selroot(fromelem, SELF, curfromele, rootpos, True, gottafree);
      fromelem := copy(fromelem, rootpos, 999); //rest;
//      if fromtag = nil then
//        fromtag := curfromele;  //LOOOP!!!
        //writeln('<b>FROMTAG:'+fromtag.head+'</b>!'+fromelem+' !TO:'+curtoele.vari+'</li>');
        //fromtag := state.selroot(fromelem, fromtag, rest, False);
    except
      writeln('nogoot-rootsel' + fromelem + '_' + rest + '_');
    end;
  end;
  try
    if fromtag  = nil then
    begin
      curfromele:=nil;
      writeln('<li>!--xse:from empty element-->');exit;
    end
    else
    if fromelem <> '' then
    begin
     // writeln('<li>fromelem:',fromelem);

     // writeln('<li>getrest:',fromtag.head,'---',fromelem,'</li>');
      //if fromtag.parent=nil then writeln('<li>getrest:',fromtag.xmlis,'---',fromelem,'---</li>')
      //else writeln('<li>parentis;'+fromtag.parent.xmlis+'</li>');
      //CurFromEle := fromtag.subt('+' + trim(fromelem))

      CurFromEle := fromtag.subt(trim(fromelem));
      //if curfromele<>nil then writeln('<hr>nowfrom'+curfromele.head+'//under:',curfromele.parent.head,'<hr>');
    end
    else
      CurFromEle := fromtag;
  except
    writeln('nogoroot-from');
    raise;
    exit;
  end;
  //writeln('<li>FRMe:',FROMFILE,'::<b>', fromelem, '</b>//<pre>', (curbyele.xmlis), '\\</pre>', '\\<b>',fromelem,'</b></li>',curbyele.subtags.count);
  //logwrite('FRM2:'+inttostr(curbyele.subtags.count)+'::'+ CurfromEle.vari+'/FRM2');
  //if fromtext<>'' then writeln('<li>fromreg:<pre>',curfromele.xmlis+'</pre>'+curfromele.vari);

  if curbyele.subtags.Count > 0 then
    dosubelements
  else
  begin
    ctag := curfromele.copytag;
    //CurToEle.subtags.add(ctag);
    resuadd(ctag);
    ctag.parent := CurToEle;
  end;
  //logwrite('FRM3:'+fromelem+ '!'+ curfromele.vari+ '/FRM3');
  //writeln('<li>didFRoM</h2>'+curfromele.head);
  finALLY
  CurFromEle := oldseltag;
  //writeln('<li>backtoFRoM'+curfromele.head);
  if fromfile + fromurl + fromtext <> '' then
    fromtag.killtree;
  END;

end;

function txseus.c_by: boolean;

var
  ele: string;
  i, rootpos: integer;
  rootsel, bytag, oldBYtag, tmpele: ttag;
  BYelem, byfile, byurl, rest, restring, apust, bpath: string;
  gottafree: ttag;
begin
  //writeln('<li>byb1:',curbyele.vari, '<PRE>', CurbyEle.xmlis, '/by2</PRE>',curbyele.subtags.count);
  byfile := CurBYEle.att('file');
  byurl := CurBYEle.att('url');
  byelem := CurBYEle.att('element');
  oldbytag := CurbyEle;
  //fromstring:=CurBYEle.att('string');
  //fromsreg:=CurBYEle.att('regexp');
  if byfile + byurl <> '' then
  begin
    if byfile <> '' then
    begin
      //writeln('<h2>byfile:',byfile,'</h2>');
      if pos('!', byfile) = 1 then
      begin
        //byfile:=_indir(copy(byfile,2,99),x_commanddir,self,false);

        byfile := x_commanddir + copy(byfile, 2, 99);
        //just a bit of security .. FILE HAS to be directly above, or below commanddir
        byfile := expandfilename(byfile);
        byfile := StringReplace(byfile, '//', '/', [rfreplaceall]);
        bpath := extractfilepath(byfile);
        if (pos(x_commanddir, bpath) = 1) or (pos(bpath, x_commanddir) = 1) then
        //writeln('<h2>byfile:',byfile,'!',x_commanddir,'</h2>')
        else
        begin
          writeln('<h2>Not allowed byfile (has to be in or below cmd-path):',
            byfile, '</h2>');
          exit;
        end;

      end
      else
        byfile := _indir(byfile, x_outdir, self, False);
      //should have some restrictions besides the indir.. file operations not permitted?
      if not fileexists(byfile) then
        exit;
      bytag := tagfromfile(byfile, nil);
    end
    else //url
    begin
      byurl := _httpget(byurl, -1, CurBYEle.getattributes);
      bytag := tagparse(byurl, False, True);
    end;
  end
  else
  if byelem <> '' then
  begin
    try
      //fromtag := state.selroot(fromelem, fromtag, rest, False);
      //bytag := selroot(byelem, curbyele, rest, True, gottafree);
      //byelem := rest;
      rootpos:=1;
      //writeln('<li>BYELEM:' + byelem,'</li>');
      bytag := p_selroot(byelem, SELF, curfromele, rootpos, True, gottafree);
      //writeln('<li>BYROOT:' + bytag.head,'</li>');
      byelem := copy(byelem, rootpos, 999); //rest;

      //writeln('<li>BY:' + byelem + '!',bytag.head,'/from:','!</li>');
      //fromtag := state.selroot(fromelem, fromtag, rest, False);
      // writeln('<li>FRM111:', fromelem, '//', copy(fromtag.xmlis,1,100), '\\', CurBYEle.xmlis, '\\<b>',rest,'</b></li>');
    except
      writeln('nogoot-rootselby' + byelem + '_' + rest + '_');
    end;
  end;
  try
    //writeln('<li>BY:'+bytag.vari,bytag.subtags.count,byelem,'!</li>');
    //for i:=0 to bytag.subtags.count-1 do writeln('#'+ttag(bytag.subtags[i]).vari+'#');
    if bytag = nil then
      writeln('<!--bynoroot-->')
    else
    if byelem <> '' then
    //CurbyEle := bytag.subt('+' + trim(byelem))
    CurbyEle := bytag.subt(trim(byelem))
    else
      Curbyele := bytag;
  except
    writeln('nogoroot-by');raise;
  end;
  //writeln('!'+byelem,'!<pre>BY:' + curbyele.xmlis,'!</pre>');

  if oldbytag.subtags.Count > 0 then
  begin
    tmpele := curbyele;
    curbyele := oldbytag;
    ttag(curbyele.subtags[0]).subtags.add(tmpele);
    //for i:=0 to oldbytag.subtags.count-1 do
    //  curbyele.subtags.add(oldbytag.subtags[i].copytag);
    //writeln('<li>byb2:',byelem, '<PRE>', CurbyEle.xmlis, '/by2</PRE>',curbyele.subtags.count);
    //writeln('<li>OLDbyb2:',byelem, '<PRE>', oldbytag.xmlis, '/by2</PRE>');

  end;
  //writeln('<li>byb3:',byelem, '<PRE>', curbyele.xmlis ,'/byb2</PRE>');

  dosubelements;
  CurbyEle := oldbytag;
  if byfile + byurl <> '' then
    bytag.killtree;

end;

{function txseus.c_fromall: boolean;
begin
end;
 }


function getxse(handlersn: string; var elems: TList): ttag;
var   //this is quite stupid -- created with the idea of caching xse-files which is not implemented now
  handlers: ttag;
  oelems: TList;
begin
  try
    if True then
    begin
      if extractfileext(handlersn) = '.xsi' then
      begin
        handlers := tagfromfileind(handlersn);
      end
      else
      if extractfileext(handlersn) = '.xsd' then
      begin
        handlers := tagfromfileind(handlersn);
      end
      else
        handlers := tagfromfile(handlersn, nil);
      Result := handlers;//.subtags[0];
      //writeln('<xmp>'+result.listraw+'</xmp>');
      exit;
    end;
   { if g_objectcache.indexof(handlersn) < 0 then
    begin //not cached
      try
        oelems := elems;
        elems := nil;
        x_handlers := tagfromfile(handlersn, nil);
        elems := oelems;
      except //if acom.att('fail')<>'ok'     then begin
        writeln('<li>+Couldnot open class ' + handlersn); //+' for object '+objn
      end;
      g_objectcache.addobject(handlersn, handlers);
    end
    else
    begin
      //writeln('<li>cached object: '+handlersn);
      x_handlers := ttag(g_objectcache.objects[g_objectcache.indexof(handlersn)]);
    end;
    Result := x_handlers;
    }
  except
    writeln('failed to get xse-handlers from ' + handlersn);
    raise;
  end;
end;

procedure registerxseus(xse: TObject; s, e: TList);
begin
  t_currentxseus := txseus(xse);
end;

{procedure clearelems(elems: TList);
var
  i: integer;
begin
  if elems <> nil then
    for i := 0 to elems.Count - 1 do
    begin
      try
        if elems[i] <> nil then
        begin
          try
            ttag(elems[i]).getAttributes.Free;
            ttag(elems[i]).subtags.Free;
          except
            writeln('<li>failed ', i, ' -', ttag(elems[i]).vari)
          end;
          try
            ttag(elems[i]).Free;
          except
            writeln('failed to clear element');
          end;
        end
        else
          writeln('<li>nil ', i);
      except
        writeln('could not clear element ', i);
      end;
    end;
end;}

{procedure clearstates(states: TList);
var
  i: integer;
begin
  for i := 0 to states.Count - 1 do
    try
      if states[i] <> nil then
      begin
        tstate(states[i]).Free;
      end;
    except
    end;
end;
}

procedure _com(st: string);
begin
end;


type
  tsoap = class(TObject)
  public
    httpheaders: TStringList;
    envs, enve, server, path, host, action: string;
    msg: ttag;
    constructor Create(h, a, s, p: string; m: ttag);
    function getsoup: string;
    procedure list;

  end;

procedure tsoap.list;
begin
  writeln('soaprequest to ' + server, path, '<xmp>' + httpheaders.Text + crlf + envs);
  msg.listst;
  writeln(enve + '</xmp>');
end;

constructor tsoap.Create(h, a, s, p: string; m: ttag);
begin
  httpheaders := TStringList.Create;
  envs := '<?xml version="1.0"?>' + crlf +
    '<soap:Envelope xmlns:soap="http://www.w3.org/2001/12/soap-envelope"' +
    ' soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">' + '<soap:Body>';
  enve := '</soap:Body></soap:Envelope>';
  host := h;
  path := p;
  server := s;
  msg := (m);
  action := a;
end;

function tsoap.getsoup: string;
var
  msgst, res: string;
begin
  msgst := envs + msg.listst + enve;
  httpheaders.add('User-Agent: Xseus');
  httpheaders.add('Host: ' + host);
  httpheaders.add('SOAPAction:' + action);
  httpheaders.add('Content-Type: text/xml');
  httpheaders.add('Content-length:' + IntToStr(length(msgst)));
  Result := _httppost(server + path, msgst, httpheaders, True, res);
end;

function _sysfunc(st: string): string;
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: word;
begin
  Present := Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);

  st := StringReplace(st, '%%date%%', datetostr(now), [rfreplaceall]);
  st := StringReplace(st, '%%day%%', datetostr(now), [rfreplaceall]);
  st := StringReplace(st, '%%time%%', timetostr(now), [rfreplaceall]);
  st := StringReplace(st, '%%year%%', IntToStr(year), [rfreplaceall]);
  st := StringReplace(st, '%%month%%', IntToStr(month), [rfreplaceall]);
  st := StringReplace(st, '%%day%%', IntToStr(day), [rfreplaceall]);
  st := StringReplace(st, '%%hour%%', IntToStr(hour), [rfreplaceall]);
  st := StringReplace(st, '%%min%%', IntToStr(min), [rfreplaceall]);
  st := StringReplace(st, '%%sec%%', IntToStr(sec), [rfreplaceall]);
  st := StringReplace(st, '%%random%%', IntToStr(random(1000000)), [rfreplaceall]);
  Result := st;

end;

function _sysxml: ttag;
var
  Present: TDateTime;
  stag: ttag;
  Year, Month, Day, Hour, Min, Sec, MSec: word;
begin
  stag := ttag.Create;
  stag.vari := 'datetime';
  Present := Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  stag.setatt('date', datetostr(now));
  stag.setatt('time', timetostr(now));
  stag.setatt('sec', IntToStr(sec));
  stag.setatt('min', IntToStr(min));
  stag.setatt('hour', IntToStr(hour));
  stag.setatt('day', IntToStr(day));
  stag.setatt('month', IntToStr(month));
  stag.setatt('year', IntToStr(year));
  Result := stag;
  stag.vali := datetostr(now) + ' ' + timetostr(now);
end;

procedure  _move(frompath,topath:string;fromroot:ttag);
var tpath,oposs,turha:string;
  i,auxi,toposi,frompos:integer;fromele,frompar,toparent:ttag;
begin
  auxi:=_poslast('/',topath);
  tpath:=copy(topath,1,auxi-1);
  try
  toposi:=strtoint(copy(topath,auxi+1,9999));
  except
    writeln('<li>1 Non-numeric end of path in move;',topath,'</li>');
    raise;
  end;
  try
  fromele:=fromroot.subt(frompath);
  except
    writeln('<li>2 move from-element not found;',frompath,'!</li>');
    raise;
  end;
  try turha:=fromele.vari;
  except
     writeln('<li>3 invalid ele to move:',frompath,'/frompar:',fromroot.vari,'!</li>');
     raise;
  end;
  try
  frompar:=fromele.parent;
  except
     writeln('<li>3 failed to locate parent of ele to move from:',frompath,'/frompar:',fromele.xmlis,'!</li>');
     raise;
  end;
  try
  frompos:=frompar.subtags.indexof(fromele);
  except
     writeln('<li>failed to locate old pos of ele to move from:',frompath,'/frompar:',frompar.xmlis,'!</li>');
     raise;
  end;
  try
  fromele.parent.subtags.remove(fromele);
  except
     writeln('<li>failed to remove element to move from:',frompath,'/frompar:',frompar.vari,'/ele:',fromele.vari,'!</li>');
     raise;
  end;
  try
  toparent:=fromroot.subt(tpath);
  toparent.subtags.Insert(toposi-1,fromele);
  except
     try
     frompar.subtags.insert(frompos,fromele); //undo - not tested
     writeln('<li>CANCEL MOVE tp: ',tpath,':',fromele.vali,toparent.subtags.count,'/',toposi,'!!',toparent.xmlis);

     except
       writeln('<li>Fuckup in MOVE, trouble  ',tpath,':',fromele.vari,toparent.subtags.count,'/',toposi);
     end;
     raise
  end;
  fromele.parent:=toparent;

  //newpar:=_staselect(npath);
end;
procedure _moveold(com, ele, toele: ttag);  //only at the same level?
//probably to be removed, replaced by the to/from -attributes
//still, a way to snap of elements is needed
var
  froot, ftag: string;
  newtag, atag1: ttag;
  curindex, newindex, skipped, togo: integer;
begin
  try
    newindex := 0;
    newtag := nil;
    if com.att('place') = 'under' then
    begin
      try
        ele.parent.subtags.Remove(ele);
      except
        writeln('faile remove under');
        listwrite(ele);
        listwrite(ele.parent);
      end;
      try
        toele.subtags.add(ele);
      except
        writeln('faile insert under');
        listwrite(ele);
        listwrite(ele.parent);
      end;
      ele.parent := toele;
      exit;
    end
    else
    if com.att('place') = 'after' then
    begin
      ele.parent.subtags.Remove(ele);
      newindex := toele.parent.subtags.indexof(toele) + 1;
      toele.parent.subtags.Insert(newindex, ele);
      ele.parent := toele.parent;
      exit;
    end
    else
    if com.att('place') = 'before' then
    begin
      ele.parent.subtags.Remove(ele);
      newindex := toele.parent.subtags.indexof(toele);
      toele.parent.subtags.Insert(newindex, ele);
      ele.parent := toele.parent;
      exit;
    end
    else
      exit;
    skipped := 0;
    if com.att('up') <> '' then
    begin
      togo := strtointdef(com.att('up'), 1);
      newindex := curindex;
      while newindex > 0 do
      begin
        newindex := newindex - 1;
        atag1 := newtag.parent.subtags[newindex];
        if //VALUE (atag1.vari<>'value') or
        (trim(atag1.vali) <> '') then
          skipped := skipped + 1;
        if skipped >= togo then
          break;
      end;
    end;
    if com.att('down') <> '' then
    begin
      newindex := curindex;
      skipped := 0;
      togo := strtointdef(com.att('down'), 1);
      while newindex < newtag.parent.subtags.Count - 1 do
      begin
        newindex := newindex + 1;
        atag1 := newtag.parent.subtags[newindex];
        if //VALUE (atag1.vari<>'value') or
        (trim(atag1.vali) <> '') then
          skipped := skipped + 1;
        if skipped >= togo then
          break;
      end;
    end;
    newtag.parent.subtags.move(curindex, newindex);
  except
    writeln('element move failed');
    listwrite(com);
    listwrite(newtag);
    listwrite(newtag.parent);
  end;
end;

procedure _replace(com, addto: ttag; xs: txseus);
//probably to be removed, replaced by the to/from -attributes
//still, a way to snap of elements is needed
var
  addtopoint: ttag;
  astr, froot, ftag: string;
  newtag, atag1: ttag;
  i, j, APUIi: integer;
begin
  apuii := 0;
  try
    ftag := com.att('tag');
    froot := com.att('match');
    if com.att('place') <> 'delete' then
      if com.att('element') <> '' then
        newtag := addto.subt(com.att('element'))
      else if com.subtags.Count > 0 then
        newtag := ttag(com.subtags[0]);

    if com.att('debug') = 'true' then
    begin
      listwrite(com);
      listwrite(addto);
    end;
    try

      //if newtag=nil then exit;
      if com.att('move') = 'true' then
        try
          newtag.parent.subtags.Delete(newtag.parent.subtags.indexof(newtag));
        except
          listwrite(com);
          writeln('<li>Element move failed</li>');
          listwrite(newtag);
          writeln('new');
          listwrite(newtag.parent);
          writeln('paremt')
        end;

      if com.att('create') <> '' then
      begin
        addtopoint := addto.subt('+' + froot);
      end
      else
      begin
        try
          addtopoint := addto.subt(froot);
        except
          writeln('failed to find froot');
          listwrite(com);
        end;
      end;
      if xs.debug then
      begin
      end;
      if addtopoint = nil then
      begin
        //writeln('<!--nowheretoadd-->');
        exit;
      end;
    except
      writeln('<li>failed to find what to replace');
    end;
    if com.att('place') = 'delete' then
    begin
      try
        atag1 := addtopoint.parent;
        if atag1 <> nil then
          atag1.subtags.Delete(atag1.subtags.indexof(addtopoint));
        exit;
      except
        writeln('failed to delete');
        listwrite(com);
        listwrite(addtopoint);
        listwrite(addtopoint.parent);
      end;
    end
    else


    if (com.att('place') = '') or (com.att('place') = 'lastchild') then
    begin
      try
        if addtopoint = nil then
        begin
          writeln('<li>noWHERE to insert in replace');
          exit;
        end;
        if newtag = nil then
        begin
          writeln('<li>nothing to insert in replace');
          exit;
        end;
        if addtopoint.subtags = nil then
          addtopoint.subtags := TList.Create;
        addtopoint.subtagsadd(newtag);
        newtag.parent := addtopoint;
      except
        writeln('failed to find lastchild');
        listwrite(newtag);
        listwrite(addtopoint);
        raise;
      end;
    end
    else
    if com.att('place') = 'firstchild' then
    begin
      if newtag = nil then
      begin
        writeln('<li>nothing to insert in replace firstchild');
        exit;
      end;
      if addtopoint = nil then
      begin
        writeln('<li>nowhere to insert in replace firstchild');
        exit;
      end;
      addtopoint.subtags.insert(0, newtag);
      newtag.parent := ttag(addtopoint.subtags[0]);

    end
    else
    if com.att('place') = 'attributes' then
    begin
      for i := 0 to newtag.getattributes.Count - 1 do
        addtopoint.setatt(cut_ls(newtag.getattributes[i]),
          cut_rs(newtag.getattributes[i]));
      //addtopoint.attributes.values[cut_ls(newtag.attributes[i])] :=
      //  cut_rs(newtag.attributes[i]);
    end
    else
    if com.att('place') = 'replace' then
    begin
      try
        writeln('<li>replacez:'+addtopoint.xmlis);
        if addtopoint.parent = nil then
        begin
          writeln('<!--nil to replace-->');
          exit;
        end;
        if newtag = nil then
          writeln('<!--nil to replace newtag-->')
        else
        begin
          apuii := addtopoint.parent.subtags.indexof(addtopoint);

          newtag.parent := addtopoint.parent;
          if newtag <> nil then
            addtopoint.parent.subtags[apuii] := newtag;
          ttag(addtopoint.parent.subtags[apuii]).parent := addtopoint.parent;
        end;
        writeln('replacez:'+newtag.xmlis);
      except
        writeln('<li>failed to find parent of what to replace', apuii);
        writeln('<li>newtag');
        listwrite(newtag);
        raise;
      end;
    end
    else
    if com.att('place') = 'after' then
    begin
      writeln('<li>after');
      newtag.parent := addtopoint.parent;
      addtopoint.parent.subtags.insert(
        addtopoint.parent.subtags.indexof(addtopoint) + 1
        , newtag);
    end
    else
    if com.att('place') = 'swap' then
    begin
      try
        writeln('<li>swap (unfinished function)<hr/>');
        listwrite(COM);
        listwrite(newtag);
        newtag.parent.subtags.Delete(newtag.parent.subtags.indexof(newtag));
        addtopoint.parent.subtags.insert(
          addtopoint.parent.subtags.indexof(addtopoint)
          , newtag);
        listwrite(addtopoint);
        writeln('<li>//swap<hr/>');
      except
        writeln('<li>//swap FAIL<hr/>');
        raise;
      end;

    end
    else
    if com.att('place') = 'before' then
    begin
      newtag.parent := addtopoint.parent;
      addtopoint.parent.subtags.insert(
        addtopoint.parent.subtags.indexof(addtopoint)
        , newtag);
    end;

  except
    writeln('xxx<hr/>');
    writeln('<li>failed to find Where to Replace');
    listwrite(com);
    raise;
  end;
  try
    for i := 0 to com.subtags.Count - 1 do
      if ttag(com.subtags[i]).vari = xs.ns + 'attribute' then
        for j := 0 to ttag(com.subtags[i]).attributesCount - 1 do
        begin
          astr := ttag(com.subtags[i]).getattributes[j];
          newtag.setatt(cut_ls(astr), cut_rs(astr));
          //newtag.attributes.values[cut_ls(ttag(com.subtags[i]).attributes[j])] :=
          //  cut_rs(ttag(com.subtags[i]).attributes[j]);
        end;
  except
    writeln('failed in replacing');
    raise;
  end;

end;




function _sortcomptags(Item1, Item2: Pointer): integer;
begin
  if string(item1) > string(item2) then
    Result := 1
  else
  if string(item1) = string(item2) then
    Result := 0
  else
    Result := -1;
  //writeln('<li>comp:',string(item1),'/',string(item2),'=',result,'?',trim(string(item1))=trim(string(item2)));
end;

function _sortcomptagsrev(Item1, Item2: Pointer): integer;
begin
  if string(item1) > string(item2) then
    Result := -1
  else
  if string(item1) = string(item2) then
    Result := 0
  else
    Result := 1;
end;


function _sortcomptagsnum(Item1, Item2: Pointer): integer;
var
  i1, i2: extended;
  er: integer;
begin
  try
    val(trim(string(item1)), i1, er);
  except
    i1 := -1;
  end;
  try
    val(trim(string(item2)), i2, er);
  except
    i2 := -1;
  end;
  if i1 > i2 then
    Result := 1
  else
  if i1 = i2 then
    Result := 0
  else
    Result := -1;
end;

function _sortcomptagsrevnum(Item1, Item2: Pointer): integer;
var
  i1, i2: extended;
  er: integer;
begin
  try
    val(trim(string(item1)), i1, er);
  except
    i1 := 0;
  end;
  try
    val(trim(string(item2)), i2, er);
  except
    i2 := 0;
  end;

  if i1 > i2 then
    Result := -1
  else
  if i1 = i2 then
    Result := 0
  else
    Result := 1;
end;

function _sortcompdates(Item1, Item2: Pointer): integer;
var
  date1, date2: tdatetime;
begin

  DateSeparator := '.';
  date1 := vartodatetime(string(item1));
  date2 := vartodatetime(string(item2));
  if date1 > date2 then
    Result := 1
  else
  if date1 = date2 then
    Result := 0
  else
    Result := -1;
end;

//function _sorttaa(oldlist: TList; apptag: ttag): TstringList;
function _sorttaa(oldlist: TList; apptag: ttag;var sortstr,sortascending:boolean): TList;
var
  lis: TList;
  i, k: integer;
  at, atv, at1, //at2, at3, at4,
  sk, misskey: string;
  sklist: TStringList;
  done: boolean;
  //note this is not using the compare-functions, and always doing a alphabetic sort or fill0 -sort
  //i've broken it at some time, probably intentionally. maybe it's ok.
begin
  lis := TList.Create;
  sklist := TStringList.Create;
  Result := nil;
  try
    at1 := apptag.att('sortkey');
{    at2 := apptag.att('sortkey2');
    at3 := apptag.att('sortkey3');
    at4 := apptag.att('sortkey4');
}    misskey := apptag.att('sortmiss');
    sortstr:=true;
    if apptag.att('sorttype') = 'fill0' then   sortstr:=false;
    sortascending:=true;
    if apptag.att('sortorder') = '-' then   sortascending:=false;
    try
      for i := 0 to oldlist.Count - 1 do
      begin
        //    li.add(oldlist[i]);
        done := False;
        at := apptag.att('sortkey');
        k := 1;
        sk := '';
        while not done do
        begin
          if at = '.' then
            atv := ttag(oldlist[i]).vali
          else
          if pos('@.', at) = 1 then
            atv := ttag(oldlist[i]).vari
          else
          if pos('@', at) = 1 then
            atv := ttag(oldlist[i]).att(copy(at, 2, length(at)))
          else
            atv := ttag(oldlist[i]).subs(at);
          if not sortstr then
          begin
            atv := copy('0000000000000000', 1, 9 - length(atv)) + atv;
          end;
          sk := sk + #0 + atv;
          k := k + 1;
          at := apptag.att('sortkey' + IntToStr(k));
          //if apptag.attributes.indexofname('sortkey' + IntToStr(k)) < 0 then
          if apptag.att('sortkey' + IntToStr(k)) = '' then
            done := True;
        end;
        sklist.Addobject(sk, oldlist[i]);
      end;
    except
      writeln('could not form sortlist');
    end;
    if at1 <> '' then
    begin
    {if apptag.att('sorttype')='num' then
    begin
      if apptag.att('sortorder')<>'-' then
      lis.sort(@_sortcomptagsnum) else
      lis.sort(@_sortcomptagsrevnum);
    end else}
      begin
        sklist.sort;
        if sortascending then
         for i := 0 to skList.Count - 1 do
          lis.add(sklist.Objects[i])
         else
           for i := skList.Count - 1 downto 0 do
              lis.add(sklist.Objects[i]);
      end;
    end;
    ;
    Result := lis;
    //Result := sklist;
    //writeln('sorted ', oldlist.count,' = ',lis.count);
    sklist.Free;
  except
    writeln('<li>could not sort');
  end;
end;


procedure _checkfilelocation(acom: ttag; indirs: string; xse: txseus;
  writeperm: boolean);
var
  ins: TStringList;
  i: integer;
  testallow: boolean;
begin
  try
    ins := TStringList.Create;
    testallow := acom.att('path') = 'full';
    _split(indirs, ',', ins);
    for i := 0 to ins.Count - 1 do
    begin
      if acom.att(ins[i]) <> '' then
      begin
        acom.setatt(ins[i], _indir(acom.att(ins[i]), xse.x_outdir, xse, writeperm));
        //acom.attributes.values[ins[i]] :=
        //  _indir(acom.att(ins[i]), xse.outdiri, xse, writeperm);
      end;
    end;
  finally
    ins.Clear;
    ins.Free;
  end;
end;

procedure _md(acom: ttag; xs: txseus; apust: string);
begin
  try
    if acom.att('salli') <> 'ok' then
    begin
      //CreateDirUTF8(acom.att('dir')); { *Converted from CreateDir*  }
      CreateDir(acom.att('dir')); { *Converted from CreateDir*  }
      writeln('<li>create ' + acom.getattributes.Text);
    end
    else
      //--CreateDirUTF8(acom.att('dir')); { *Converted from CreateDir*  }
      CreateDir(acom.att('dir')); { *Converted from CreateDir*  }
  except
    writeln('<li>failed to create ' + apust + acom.att('dir'));
  end;
end;

function _test(op, x1, x2: string; xs: txseus; acom: ttag): boolean;

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
      if op = 'rights' then
      begin
        ok := _testrights(xs.x_session, parsexse(acom.att('dir'), xs),
          parsexse(acom.att('role'), xs), parsexse(acom.att('domain'), xs));
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
    try
      x1 := parsexse(x1, xs);
      x2 := parsexse(x2, xs);
      //ok:=true;result:=true;exit;
    except
      writeln('<li>fail test:', op, x1, x2);
    end;

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
      ok := renamefile(_indir(x1, xs.x_objectdir, xs, False),
        _indir(x2, xs.x_objectdir, xs, False));
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
      ok := _movefile((_indir(x1, xs.x_objectdir, xs, False)),
        (_indir(x2, xs.x_objectdir, xs, True)));
    end;
    if neg then
      Result := not ok
    else
      Result := ok;
    //writeln('<li>tested:'+op,result);
  except
    writeln('failed in _test');
    listwrite(acom);
  end;
  //writeln('didtest', result);
end;




function _condition(condtag, seltag, xform: ttag; xs: txseus): boolean;
var
  i: integer;
  ok: boolean;
  op: string;
begin
  try
    // writeln('<!--_condition may require rewriting-->');
    op := condtag.att('op');
    if op = 'and' then
    begin
      ok := True;
      for i := 0 to condtag.subtags.Count - 1 do
      begin
        if POS('xse', ttag(condtag.subtags[i]).vari) <> 1 then
          continue;
        if not _condition(condtag.subtags[i], seltag, xform, xs) then
        begin
          ok := False;
          Result := False;
          exit;
        end;
        ok := True;
      end;
      Result := True;
      exit;
    end;
    if op = 'or' then
    begin
      ok := False;
      for i := 0 to condtag.subtags.Count - 1 do
      begin
        if POS('xse', ttag(condtag.subtags[i]).vari) <> 1 then
          continue;
        if _condition(condtag.subtags[i], seltag, xform, xs) then
        begin
          ok := True;
          Result := True;
          exit;
        end;
      end;
      Result := False;
      exit;
    end;
    if condtag.vari = 'xse:if' then
      if condtag.attributesCount = 0 then
      begin
        ok := _condition(condtag.subtags[0], seltag, xform, xs);
        exit;
      end;
    ok := _test(condtag.att('test'), condtag.att('x1'), condtag.att('x2'), xs,
      condtag);
  finally
    if condtag.att('neg') = '' then
      Result := ok
    else
      Result := not ok;
    if condtag.att('debug') = 'true' then
    begin
      writeln('<li>_test(' + condtag.att('test'),
        condtag.att('x1'),
        parsexse(condtag.att('x1'), xs),
        condtag.att('x2'),
        parsexse(condtag.att('x2'), xs),
        op, Result, '</li>');
      listwrite(condtag);
    end;
  end;
end;



procedure _whiletag(acom: ttag; oldlist: TList; seltag, xform: ttag; vars: TStringList);
begin
  try
    _h1('while not implemented');
  except
    writeln('could not do while');
  end;

end;

procedure _casetag(acom: ttag; oldlist: TList; seltag, xform: ttag; vars: TStringList);
begin
  try
    _h1('case not implemented');
  except
    writeln('could not do case');
  end;

end;

function txseus.getmemx: integer;
var
  i, ers, j: integer;
  ele: ttag;
begin
  //exit;
  ers := 0;
  Result := sizeof(self);
  if x_elemlist <> nil then
    for i := 0 to x_elemlist.Count - 1 do
      if x_elemlist[i] <> nil then
      begin
        try
          //     writeln('<li>clear ',i,' -' ,ttag(elems[i]).vari);
          ele := x_elemlist[i];
          Result := Result + 4 + length(ele.vari) + length(ele.vali) +
            length(ele.commenttext) + sizeof(ele.getattributes) + sizeof(ele.subtags);
          for j := 0 to ele.attributesCount - 1 do
            Result := Result + length(ele.getattributes[j]) + 1;
        except
          ers := ers + 1;
          writeln('<li>failed getmemx ', i, ' -', ttag(x_elemlist[i]).vari);
        end;
      end;
  {if states <> nil then
    for i := 0 to states.Count - 1 do
      try
        if states[i] <> nil then
          Result := Result + sizeof(tstate(states[i]));
      except
        ers := ers + 1;
        writeln('<li>failed GM', i, ' -state');
      end;}
  //Result := Result + sizeof(x_svars);
  Result := Result + sizeof(x_bookmarks);
  //for j := 0 to x_svars.Count - 1 do
  //  Result := Result + sizeof(ele) + sizeof(x_svars[j]);
end;

function txseus.Clear: integer;
var
  i, ii, ers, orefcount: integer;
  ele: ttag;
begin
 // writeln('!');
 try
   try
     if x_started<>NIL THEN   x_started.Free;
     IF X_STOPPED<>NIL THEN x_stopped.Free;
   except WRITELN('<li>xxxxstartstop');end;
   //exit;
     try
     IF x_databases<>NIL THEN
     BEGIN
       for i:=0 to x_databases.count-1 do
        tdb(x_databases.objects[i]).free;
       x_databases.free;

     end;
    except WRITELN('dbase');end;try

    ers := 0;    //c:=0;
    //x_svars.clear;
    IF x_svars<>NIL THEN x_svars.Free;
    except WRITELN('svars');end;try
     if x_handlers <>nil then       X_HANDLERS.KILLTREE;
    except writeln('nokillhands');  end;  try
      if x_rights <>nil then X_RIGHTS.KILLTREE;
      //logwrite('<li>rigs');
    except  writeln('nokillrights'); end; try
    if g_memtest then
      writeln('clearbookmarsk:<pre>', x_bookmarks.xmlis + '</pre>',
        elements_CREATED, ' Killed:', elements_FREED);
       if x_bookmarks <>nil then
       begin
         //x_bookmarks.clearmee;
//         X_BOOKMARKS.killtree;

         //x_bookmarks.clearmee;
         //x_bookmarks.free;
       end;
      //logwrite('<li>bms');
    except   writeln('nokillbook');  end;
    if g_memtest then
      writeln('cleedarbookmar:', elements_CREATED, ' Killed:', elements_FREED);
    try
      if x_funcs <>nil then   X_funcs.KILLTREE;
    except writeln('nokillfun');  end;  try
      //logwrite('<li>goxml');
   if xml <>nil then      XML.KILLTREE;
      //XML.freemEE;
      //logwrite('<li>didgoxml');
    except   writeln('nokillXML');  end;   try
    IF X_MYLOCKS<>NIL THEN
    begin for i := 0 to x_myLocks.Count - 1 do
      g_locks.freefile(x_mylocks[i], x_mylocks);
    x_mylocks.Free;

    end;
    except writeln('locks');end;try
   IF X_ids<>NIL THEN
         x_ids.Free;
    except writeln('ids');end;try
    IF X_objectlist<>NIL THEN
    begin     x_objectlist.Clear;
    x_objectlist.Free;
    end;
    // c:=c+sizeof(states);
    except writeln('oblist');end;try
    IF X_times<>NIL THEN
       begin     x_times.Clear;
    x_times.Free;

       end;
    except writeln('times');end;try
    if x_called then
    begin
      //states.free;
      //elems.free;
      exit;
    end;
    except writeln('whatever');end;

  except
    ers := ers + 1;
    writeln('could not clear somethinv', i);
    //raise;
  end;
  {if g_memtest then
    if x_elemlist <> nil then
      writeln('<li>TOTAL ELEMENTS:', elements_CREATED, ' Killed:', elements_FREED,
        ' mem:', getheapstatus.totalallocated div 1000000, '!</li>');
  if g_memtest then
    for i := 0 to x_elemlist.Count - 1 do
    begin
      try
        orefcount := integer(x_elemrefcount[i]);
        //writeln('<li>free:', i, '/', orefcount);
        if orefcount < 0 then
          writeln('<li>multifreed:', i, ttag(x_elemlist[i]).vari)
        else
        if orefcount > 0 then
          if x_elemlist[i] <> nil then
          begin
            try
              try
                ele := x_elemlist[i];
                writeln('<li>Unfreed:', ele.vari, '/', i, '/', ele.memregnum);
              except
                writeln('<li>Unfreed but nonexistent element:', i);
              end;
              try
                //f ele.getattributes <> nil then
                ele.freeattributes;
                //ele.getattributes.Free;
              except
                ers := ers + 1;
                writeln('<li>failed eleattsfree', i, ' -', ttag(x_elemlist[i]).vari)
              end;
              //ele.attributes := nil;
              //ele.subtags.clear;
              try
                if ele.subtags <> nil then
                  ele.subtags.Free;
              except
                ers := ers + 1;
                writeln('<li>failed subfree', i, ' -', ttag(x_elemlist[i]).vari);
              end;
            except
              ers := ers + 1;
              writeln('<li>failed eleafree', i, ' -', ttag(x_elemlist[i]).vari)
            end;
            try
              ele.Free;
            except
              ers := ers + 1;
              writeln('<li>ffailed elefree ', i, ' -', ttag(x_elemlist[i]).vari);
              //raise;
            end;
          end
          else
            writeln('<li>nilele ', i);
      except
        ers := ers + 1;
        writeln('cold not clear', i);
        //raise;
      end;
    end;
  }
    //except writeln('<li>fuckupinclear');end;
  //  exit;
  try
  //   g_memtest:=true;
  {if g_memtest then
    writeln('<li>freed elemems:', getheapstatus.totalallocated div 1000000, '</li>');
  try
    if states <> nil then
      for i := 0 to states.Count - 1 do
      begin
        try
          if states[i] <> nil then
          begin
            sta := states[i];
            //c:=c+sizeof(sta);
            sta.Free;
          end;
        except
          ers := ers + 1;
          writeln('could not clear state');
        end;
        Result := ers;

      end;
    //writeln('<li>states cleared' s.count,'(mem:',getheapstatus.totalallocated div 1000,'</li>');
    states.Clear;
    states.Free;

    if g_memtest then
      writeln('<li>stateLIST cleared', '(mem:', getheapstatus.totalallocated div
        1000000, '</li>');
      }
    try
      IF X_elemlist<>NIL THEN
      begin
        x_elemlist.Clear;
        if g_memtest then
        writeln('<li>ELE cleared', SIZEOF(x_elemlist), '(mem:',
          getheapstatus.totalallocated div 1000000, '</li>');
         x_elemlist.Free;

      end;
     except writeln('elemes');end;try
     if g_memtest then
      writeln('<li>ele freed, next eref', SIZEOF(x_elemrefcount), '(mem:',
        getheapstatus.totalallocated div 1000000, ')</li>');
    IF X_elemrefcount<>NIL THEN
    begin
      x_elemrefcount.Clear;
      x_elemrefcount.Free;
    //if g_memtest then
    //  writeln('<li>EREF cleared', SIZEOF(x_elemrefcount), '(mem:',
    //    getheapstatus.totalallocated div 1000, '</li>');

     end;
    except writeln('refs');end;
    if g_memtest then
      writeln('<li>EREFcout freed', '(mem:', getheapstatus.totalallocated div
        1000000, '</li>');
    //loc.free;
    // lists.Free;
    //§    ccall.fields.Free;
    //§    ccall.vars.Free;
    //§    ccall.cookies.Free;

    if g_memtest then
      writeln('<li>!--mem after xseus.clear:', getheapstatus.totalallocated div 1000000, 'B--</li>');
  except
    ers := ers + 1;
    writeln('Failed to clear xseus ', i);
    raise;
  end;

end;



constructor txseus.Create(principal: txseus);
begin
 inherited create;
{  x_called := False;
  x_cmdline := False;
  x_relation:=nil;
  x_started := Tstarted.Create;
  x_stopped := Tstarted.Create;
  x_elemlist := TList.Create;
  x_elemrefcount := TList.Create;
  // states := TList.Create;
  mylocks := TStringList.Create;
  curselectionset := nil;
  ns := 'xse:';
  debug := False;
  if principal = nil then
  begin
    // elems:=tlist.create;
    //states:=tlist.create;
    t_currentxseus := self;
  end
  else
  begin
    x_elemlist := principal.x_elemlist;
    //states := myxs.states;
  end;
  //LOGWRITE('XXX1');
  x_times := ttimes.Create;
  //x_times.curxseus := self;
  OBJECTLIST := TStringList.Create;
  x_svars := TStringList.Create;
  //x_svars := ThashStrings.Create;
  x_ids := ThashStrings.Create;
  //registertagowner(self, x_elemlist, x_elemrefcount);
  //    x_svars:TurboHashedStringList;
  //X_SVARS.SORTED:=TRUE;
  //x_svars.duplicates:=dupaccept;
  //x_svars := TurbohashedStringList.Create;
  x_bookmarks := ttag.Create;//.create;
  x_bookmarks.vari := 'xseus_bookmarks';
  x_funcs := ttag.Create;
  //x_fORM := ttag.Create;
  //LOGWRITE('XXX2');
  x_funcs.vari := ns + 'functions';
  xml := ttag.Create;
  xml.parent := nil;
  //!! parse later x_form := ttag.Create;
  //!!  parse later x_data := ttag.Create;
  //x_cgi := ttag.Create;
  //x_cgi.vari := 'cgi';
  //LOGWRITE('XXX3');
  x_rights := ttag.Create;
  x_rights.vari := 'rights';
  //x_handlers:=ttag.create;
  //  handlerlist:=TSTRINGLIST.CREATE;
  //LOGWRITE('XXX4');

  inihttp := '';//'Content-type:text/html'+crlf+'Pragma: nocache'+crlf+crlf;
  //inidecl :=
  //  '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ENG" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
  //  + crlf;
  inidecl := '<!DOCTYPE html>'+crlf;// PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" ' +
  // 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' + crlf;
  //LOGWRITE('XXX5');
  inihtml := '<html>'+crlf;// xlmns="http://www.w3.org/1999/xhtml">';
  inihead := '<head>'+crlf+'<title>X-seus</title>'+crlf
    // +'<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />'
    + '</head>'+crlf;
  inibodyst := '<body>';
  inibodyend := crlf+'</body></html>';
  //LOGWRITE('XXX6');
  g_xseuscfg.logf := nil;
  //LOGWRITE('XXX7');
}
end;

function txseus.staselect(st: string; def: ttag): TTAG;
  // does very little and is called by few. Not really needed,
  //all callers could do the trick (selroot - subt rest) themselves
  //note: gottafree not passed on
var
  //rl: TList;
  aput: ttag;
  //rest: string;
  rootpos: integer;
  gottafree: ttag;
begin
  rootpos := 1;
  //writeln('<h1>STASELEXT</H1>');
  aput := p_selroot(st, SELF, curfromele, rootpos, True, gottafree);
  if aput = nil then
    aput := def;
  //aput := selroot(st, curtoele, rest, True, gottafree);
  //writeln('select:',aput.vari,'_',apust,'?',st);
  //if rest = '' then
  if rootpos = 1 then
    Result := aput
  else
    Result := aput.subt(copy(st, rootpos, 999));

end;

function txseus.c_split: boolean;
{D: regular expression match
 returns first match of expression given in "ext"-param in "in"-param
 or if match-parameter is specified, the match no. specified by that.
 Negative number specifies that counting starts from end
 If expression contains subexpressions (parentheses-limited parts)
 they are returned concatenated
-uses: Andrey V. Sorokin's regexp library
-example:  ?match(in='c:\hui\hai\hei\index.html';exp='(.*\\.*)\\.*\\.*')
 cuts everything after second last \
 }
var
  r: tregexpr;
  i, j, matii: integer;
  //reslist:tstringlist;
  //resu:string;
  res, sres: ttag;
  fund: boolean;
begin
  // reslist:=tstringlist.create;
  // writeln('<xmp>'+  pars.values['exp']+'</xmp>');

  r := TRegExpr.Create;
  matii := strtointdef(CurBYEle.att('match'), 1) - 1;
  res := CurToEle.addsubtag('match', '');
  res.setatt('target', CurBYEle.att('in'));
  res.setatt('exp', CurBYEle.att('exp'));
  try
    r.Expression := CurBYEle.att('exp');
    //writeln('REGSPLIT', matii, '!', r.expression, 'in:', CurBYEle.att('in'), '!');
    try
      fund := r.Exec(CurBYEle.att('in'));
    except
      writeln('fail REGEXEC', matii, '!', r.expression, 'in:', CurBYEle.att('in'));

    end;
    if fund then
      repeat
        if r.SubExprMatchCount = 0 then
        begin
          if R.match[0] <> '' then
            //CurToEle.addsubtag('hit',r.Match[0]);
            sres := res.addsubtag('hit', r.Match[0]);
          //sres.attributes.Add('p1='+r.Match[0]);
          //Reslist.add(r.Match[0]);
        end
        else
        begin
          sres := res.addsubtag('hit', r.Match[0]);
          for i := 1 to r.SubExprMatchCount do
          begin
            //IF R.match[i]<>'' then
            sres.setatt('p' + IntToStr(i), r.Match[i]);

            // CurToEle.addsubtag('part',r.Match[i]);
            //Resu:=resu+(r.Match[i]);//+ ',';;
          end;
          //if resu<>'' then reslist.add(resu);
        end;
      until not r.ExecNext;
    //if mati<0 then
    //  mati:=reslist.count+mati+1; //note xseus is 1-based,pascal/regexp 0-based
    // if reslist.Count>mati then
    //  result:=reslist[mati] else result:='';
  finally
    r.Free;  //reslist.Free;
  end;
end;


function txseus.c_parsexse: boolean;
  //parses a xse-macro. why?
begin
  parsexse(CurBYEle.subs('x'), self);
end;


function txseus.c_ftpstore: boolean;
{D: useless
 -Plan: if ftp-server is to be really implemented with xseus-defined actions,
  not only a hard-wired "add hoc" functionality for our xerox_machines this might be needed
}
begin
  //filestream:=tfilestream.create(
end;

function txseus.c_htmlhead: boolean;
{D: creates the head-element that is used in htmlinit
must be done before html is inited, ie. before anything is written out
}
var
  headelem, ores: ttag;
  //new
begin
  headelem := ttag.Create;
  //newstate := tstate.Create(state, self);
  ores := curtoele;
  //newCurFromEle:=newtag;
  CurToEle := headelem;
  //setstatex(newstate);
  // newtag.parent:=CurToEle;

  //state.restagadd(newtag);
  //writeln('<h1>elementx</h1><xmp>'+CurBYEle.listraw+'</xmp>XXX<xmp>'+newCurBYEle.listraw+'</xmp>');
  //newstate.starts := state.starts;

  dosubelements();
  inihead := headelem.subs('./@asstring()');
  //logwrite('HEAD!'+inihead+'!');
  //inihead:='<html><head><title>jojojojojojojoj</title></head>';
  //inihead:='<html><head><title>inited</title><script src="jquery.js"/></head>';
  headelem.killtree;
  //headelem.clearmee; //how about subtags of headelem?
  curtoele := ores;
  //curtoele.addsubtag('h1','dididit');
  //newstate.dofree;
  exit;
{ //exit;

  headelem := ttag.Create;
  ores:=CurToEle;
  newstate := tstate.Create(state, self);
  //newstate.setstate;
  setstatex(newstate);
  newCurToEle := headelem;
  newCurBYEle:=CurBYEle;
  try
  doelements(newstate);
  except
    writeln('<h1>faildodododoodod</h1><xmp>',headelem.xmlis,'</xmp>ZZZZZZZZZZZZZZz');
  end;
  inihead := '<html>'+headelem.subs('@asstring()');
  //newstate.dofree;
  //headelem.clearmee;
  //CurToEle:=ores;
}

end;

function txseus.c_inithtml: boolean;
{D: writels html decl, head, body etc
usually this is called automatically with default values before the
first html-output is written,
but it can be called before that to write non-default wrapper-elements and declaration
}
var
  acom, head: ttag;

  procedure doat(att: string; var inival: string);
  begin
    if acom.att('no' + att) <> '' then
      inival := ''
    else
    if acom.att(att) <> '' then
      inival := acom.att(att)
    //else
    //if acom.subt(att) <> nil then
    //  inival := acom.subs(att);

  end;

begin
  //logwrite('inithtml');
  if htmlinited then
  begin
    //logwrite('itwasinited');
    exit;
  end;
  head:=nil;
  htmlinited := True;
  acom := CurBYEle;
  if ACOM <> nil then
  begin
    //InternetOpen('Modzilla/2.0 (Updater/Eriksen)',
    //    LOCAL_INTERNET_ACCESS, '', '', 0);
    //writeln('Content-type: text/html'+crlf+crlf);
    // doat('http',inihttp);
    //writeln('<head><title>nynead</title></head><body>mybody:<xmp>');
    doat('decl', inidecl);
    doat('html', inihtml);
    //nobody := False;
    //if acom<>nil then
    if acom.att('nobody') = 'true' then
    begin
    //  nobody := True;
    //doat('head', inihead);
    //if not nobody then
     inibodyst:='';inibodyend:='';
    end
    else
    begin
      doat('bodyst', inibodyst);
      doat('bodyend', inibodyend);
    end;
    //inihead:='huihai';
  end;
  head := acom.subt('head');
  //logwrite('INIGHEAD1:' + inidecl  + '!'+ inihtml + '!' + inihead  + '!'+ inibodyst + '!');
  if head <> nil then
  begin
    head := doone(head);
    inihead := head.listst;
  end
  else
    doat('head', inihead);
  htmlinited := True;
  //if not httpinited then
  writeln(inidecl + inihtml + inihead + inibodyst);
  httpinited := True;
  //writeln('<xmp>XXXXX'+acom.xmlis+'</xmp>');
  //writeln('<xmp>'+inidecl + '!!!' +crlf+'html:'+inihtml+'HEAZ:'+ inihead+ '!!!' + inibodyst+'</xmp>');
  //else if (acom<>nil) and (acom.vari='inithtml') then
  //logwrite('INIGHEAD:' + inidecl  + '!'+ inihtml + '!' + inihead  + '!'+ inibodyst + '!');
  //flush(output);
  //if not httpinited then
  //_com('init'+ inidecl+inihead+inibodyst);
  //_h1('init');
  //if acom.att('zzz')='sss' then listwrite(acom);
  //logwrite('initedhtml');

end;

procedure txseus.writelog(msg: string; form: boolean);
var
  mus: integer;
  tp: string;
  mymu: thandle;
begin
{try
mymu:=createmutex(nil, true, 'xseuslogger');
flush(output);
 mus:=0;
          tp:=x_commands.subs('log');
          if tp='' then
           tp:=_getpathinfo('temp');
          if tp='' then
           tp:='c:\temp';
          tp:=tp+g_ds+'xseus.log';
          if not FileExists(tp) then
          begin
             _writefile(tp,'XSEUSLOG '+datetimetostr(now));
          end;

 if Mymu <> 0 then
  while mus<5 do
  begin
    mus:=mus+1;
    case WaitForSingleObject(Mymu, 100) of
      WAIT_OBJECT_0 :
      begin
        if logf=nil then
        begin
        try
           writeln('createlog');
          logf:=tfilestream.create(tp, fmOpenWrite or fmShareDenyNone  );
          except writeln('<li>failed to open logfile '+tp+' to write errors</li>');end;
        end;
if ccall.vars=nil
         then msg:=crlf+'NOINIT '+_getpathinfo('PATH_INFO')
         else
         msg:=crlf+msg+' '+datetimetostr(now)+' '
         +ccall.vars.values['PATH_TRANSLATED']+' '
         +ccall.vars.values['REMOTE_ADDR']+' '
         +ccall.vars.values['QUERY_STRING']+' '
         ;
         logf.seek(0,sofromend);
         logf.writebuffer(pointer(msg)^, length(msg));
         if form then
        x_form.savetofile(x_commands.subs('tmp')+ccall.vars.values['random_string8']+'.xxx',false,'',false);
        break;
      end;
      WAIT_ABANDONED :
      begin
        writeln('<!--WAIT_ABANDONED  -->');
        break;
      end;
      WAIT_TIMEOUT :
      begin
        writeln('<!--Wait..-->');
        end;
      else writeln('<!-- logging ELSE-->');
      end;
   end;
   releasemutex(mymu);
   FileClose(mymu);  *Converted from CloseHandle*
except writeln('<li>Failed to open logfile '+tp+' to write errors</li>');end;
flush(output);
}
end;

{procedure _stripvalues(sus: TList);
var
  i: integer;
  atag: ttag;
begin
  for i := sus.Count - 1 downto 0 do
  begin
    atag := ttag(sus[i]);
    if (//VALUE(atag.vari='value') or
      (atag.vari = '')) and (atag.subtags.Count = 0) and (trim(atag.vali) = '') then
    begin
      sus.Delete(i);
      writeln('<li>delempty', i);
    end;
  end;
end;
}

procedure trelation.debug;
begin
 writeln('<li>relation:/tosel:',toselector,'/fromsel:',fromselector,'/tcount:',tolist.count);
end;

function testsort(stl:tstringlist;i,j:integer):Integer;
begin
  if stl[i]>stl[j] then result:=1 else if stl[i]<stl[j] then result:=-1 else
  begin
    if i>j then result:=1 else result:=-1;
  end;
 //writeln('<li>test',i,'/',j,result,'  <b>',stl[i],'?',stl[j],'</b></li>');
end;
destructor trelation.free;
begin
 tolist.free;
 xseus.x_relation:=prev;
 //inherited free;
end;

constructor trelation.create(relsel:string;sels:tlist;xs:pointer;var hasrelation:boolean;fun:tcompfunc);
var slist:tlist;orel:trelation;
i:integer;
begin  //relation="$id>/others/>@idref"
  //x_relation:=trelation.create;
  try
  xseus:=xs;
  //writeln('<h3>Createrel:',relsel,'to:',toselector,':',sels.count,xseus.curfromele.vari,'</h3>');
  except writeln('</h3>noxseus');end;
  fromlist:=sels;
  fromselector:=_fetch(';',relsel);
  torootsel:=_fetch(';',relsel);
  toselector:=_fetch(';',relsel);
  sorted:=relsel='sorted';
  try
  slist:=xseus.staselect(torootsel,xseus.curfromele).subtags;
  tolist:=tstringlist.create;
  for i:=0 to slist.count-1 do
  begin
    //tolist.addobject(ttag(slist[i]).subs(toselector),slist[i]);
    tolist.addobject(parsefromele(slist[i],toselector),slist[i]);
    //writeln('<li>addeds:',parsefromele(slist[i],toselector),'*',ttag(slist[i]).vari,'_',toselector);


  end;
 // writeln('<h3>Creatingrel to:',toselector,tolist.count,' /in:',torootsel,' /from:',fromselector,slist.count,':</h3>');
    if not sorted then
    //_dosort(tolist,sortst);
    tolist.customsort(testsort);
  {for i:=0 to 9 do
    writeln('<li>FROM:'+ttag(fromlist[i]).xmlis,'?</li>');
  for i:=0 to tolist.count-1 do
    writeln('<li>TO:'+ttag(tolist.objects[i]).xmlis,'?</li>');
    //writeln('<xmp>',xseus.curfromele.xmlis,'?</xmp>');
    }
   //tolist.sort;
  //for i:=0 to 90 do    writeln('<li>TOLIST:',tolist[i],'##'+ttag(tolist.objects[i]).head,'</div>');
  //note: remembertofree not saved
  compfunc:=fun;
  sofarto:=0;
  hasrelation:=true;
  if (tolist=nil) or (tolist.count=0) then   writeln('<li>rel no sel')
  else
  begin
    toselected:=tolist.objects[0];
    fromselected:=fromlist[0];
    orel:=txseus(xs).x_relation;
    xseus.x_relation:=self;
    prev:=orel;

    //debug;
  end;
  finally
   // writeln(sofarto,'<pre>'+tolist.text,'</pre>');
  // slist.clear;
   //  slist.free;
  end;
end;

procedure trelation.findrel(fromsel:pointer);
var tselst,fselst:string;i,j,rel:integer;nextry:ttag;
begin
  fromselected:=ttag(fromsel);
  writeln('<li>findrel:',fromselector,'/',fselst,'/to:',toselector,'/pos:',sofarto,'/',tolist.count,'!!',ttag(fromselected).xmlis);
  fselst:=ttag(fromselected).subs(fromselector);
  //writeln('<li>firstreltion select:',sofarto,'?',fselst,'-',toselector,'/pos:',sofarto,'/',tolist.count,'??');
  //for j:=0 to tolist.count-1 do writeln('#',ttag(tolist.objects[j]).att('id'));
  //writeln('</small>)');
  i:=sofarto;
  toselected:=nil;
  //while true do //toselecti<tolist.count do
  while i<tolist.count do //toselecti<tolist.count do
  begin
    //tselst:=ttag(toselected).subs(toselector);
    try
    tselst:=tolist[i];
    rel:=compfunc(pointer(tselst),pointer(fselst));
    except
    writeln('<li>tryone:',fselst,'='+tselst,'/for:',toselector,'/in:'+ttag(tolist.objects[i]).xmlis,'/at',sofarto,'!',rel,i,'!');
    end;
    //for j:=0 to tolist.count-1 do writeln('!',ttag(tolist.objects[j]).att('id'));
    //writeln('</small>)');
    if rel=0 then
    begin
      toselected:=tolist.objects[i];
      writeln('<li>relfound:'+fselst+'!'+ttag(toselected).xmlis);
      break;
    end;
    //if tselst>fselst then begin break;end;
    if rel=1 then begin //writeln('<li>breakatt:',tselst,'&gt;',fselst,'!',sofarto);
      break;end else
    //if rel=-1 then begin writeln('<li>pastalready:',tselst,'&lt;',fselst);break;end;
    i:=i+1;
    sofarto:=i;
    if i=tolist.count then
    begin
      tselst:='';
      //toselected:=nil;
      //writeln('<li>End of relation:',fselst,'!='+tselst);
      break;
    end else   tselst:=tolist[i];

  end;
  //writeln('</li></ul>');
end;
{function trelation.findrellist:tlist;
var tselst,fselst:string;i,rel:integer;nextry:ttag;
begin
  result:=tlist.create;
  if fromselected=nil then exit;
  if toselected=nil then exit;
  fselst:=ttag(fromselected).subs(fromselector);
  while true do //toselecti<tolist.count do
  begin
    tselst:=stlist[toselecti];
    rel:=compfunc(pointer(tselst),pointer(fselst));
    writeln('<li>try:',fselst,'='+tselst,'/for:',toselector,'/in:'+ttag(toselected).xmlis,'/at',toselecti,'!',rel);
    if rel=0 then
    begin
      writeln('<li>reltion found:'+fselst+'!'+ttag(toselected).xmlis);
      result.add(toselected);
    end;
    //if tselst>fselst then begin break;end;
    if rel=1 then break else
    //if rel=-1 then begin writeln('<li>pastalready:',tselst,'&lt;',fselst);break;end;
    toselecti:=toselecti+1;
    if toselecti>=tolist.count then
    begin
      toselected:=nil;
      writeln('<li>End of relation:',fselst,'!='+tselst);
      break;
    end else  tselst:=tolist[toselecti];

  end;
end;
}

function trelation.findrellist:tlist;
var tselst,fselst:string;i,rel:integer;nextry:ttag;
begin
  result:=tlist.create;
  if fromselected=nil then exit;
  if sofarto>=tolist.count then exit;
  //fselst:=ttag(fromselected).subs(fromselector);
  fselst:=parsefromele(fromselected,fromselector);
  try
  //writeln('<li>rellist:',fselst,'='+tolist[sofarto],'/at',sofarto,'!tl:',tolist.count,'/fl:',fromlist.count,'!</li>');
  i:=sofarto;
  while true do //toselecti<tolist.count do
  begin
    tselst:=tolist[i];
    //writeln('<li>trylist:',fselst,'='+tselst,'/for:',i,'/in:'+tolist[i],'/at:',i,'!',fselst=tselst);
    rel:=compfunc(pointer(tselst),pointer(fselst));
    //rel:=fselst=
    //writeln('/got:',rel,'!</li>');
     if rel=0 then
    begin
      //writeln('---RL Add:'+fselst+'!'+ttag(tolist.objects[i]).xmlis);
      result.add(tolist.objects[i]);
    end;
    //if tselst>fselst then begin break;end;
    //if rel=1 then break else
    if rel=1 then begin //writeln('<li>past:',tselst,'&lt;',fselst);
      break;end;
    i:=i+1;
    //tselst:=tolist[toselecti];
    if i>=tolist.count then
    begin
      toselected:=nil;
      //writeln('<li>End of relation:',fselst,'!='+tselst);
      break;
    end;// else  tselst:=tolist[toselecti];

  end;
  finally
    //writeln('</li></ul>');
    //if result.count>o then toselected:=tolist.objects[i];
  end;
end;


{
type tgrouping=class(tobject)
  public
  list:tlist;
  position:integer;
  name,selector:string;
  constructor create(par:string;lis:tlist);
  function nextgrouplist:tlist;
}
  constructor tgrouping.create(pars:string;lis:tlist);
  begin
    nextpos:=0;
    name:='subtag'; //_fetch(';',pars);
    selector:=pars;//_fetch(';',pars);;
    list:=lis;
    // writeln('<li>grp: '+name+'-',selector,list.count);
    nexttag:=ttag(list[0]);
    nextst:=nexttag.subs(selector);
  end;

  function tgrouping.nextgrouplist:tlist;
  var st:string;
   begin
      while (nextpos<list.count) do
      begin
        st:=''
      end;
   end;
  function tgrouping.nextgrouptag:ttag;
  var st,oldst:string;atag:ttag;
   begin
     try
     result:=ttag.create;  //NEVER FREED!
     result.vari:=name;
     result.subtags.add(nexttag);
     result.addatt('grp='+nextst);
     oldst:=nextst;
     while (nextpos<list.count-1) do
     begin
           nextpos:=nextpos+1;
           nexttag:=list[nextpos];
           nextst:=nexttag.subs(selector);
           if nextst=oldst then
           begin result.subtags.add(nexttag);
           end
           else    break;
     end;
    finally
                //writeln('<li>Added:<pre>'+result.xmlis,'</pre>',nextpos);
    end;
   end;


function txseus.applyall: boolean;
var
  //streamer:tstreamer;
 // oldstreampath:tstringlist;
  sels: TList;
   apulist:tlist;
  streaming,ocrit,hasrelation,sortascending,sortstr,hadmat: boolean;
  times, i, j, m, apuii, olresi: integer;
  sel2, asel, atpl, septag, atfirsttag, atlasttag, thetpl, aputag,
  rootseltag, //templates1,//xform1,
  respoint, xoldres, oldtemplates, oldbookm, oldappta, oldfrom: ttag;
  templateatt, thisout, sepst, aps, countervar, oldprefix, selst, selector,mat: string;
  separ, atlast, atfirst: boolean; //, breaksf?
  oldvars, withvars, withelems: TStringList;
  selection1, apptag: ttag; //restag,     f
  //newstate,newstate2:tstate;
  //oldelemscount, selelemscount: integer;
  //oldstatescount, selstatescount: integer;
  templist: TList; //to hold created elements that need to be freed
  grouping:tgrouping;
  debugst: string;
   compfunc: function(Item1, Item2: Pointer): integer;  //sortcomp
  db,fromdb:tdb;
begin

  try
    templist := TList.Create;
    try
      debugst := '';
      hasrelation:=false;
      grouping:=nil;
      selection1 := CurFromEle;
      apptag := CurBYEle;
      //if apptag.att('debug')='true' then writeln('<li>applydebug:',curfromele.xmlis);
      fromdb:=nil;
      //t_stream:=nil;
      streaming:=false;
      //logwrite('applytemplates:'+curbyele.head);
      //writeln('<pre>'+curbyele.xmlis+'</pre><hr/>');
      //writeln('<h3>applyfrom</h3><pre>'+ttag(curfromele).xmlis+'</pre><hr/>');
      oldtemplates := curtemplates;
      //oldres:=CurToEle;
      oldfrom := curfromele;
      ocrit := x_critical;
      oldprefix := ns;
      thetpl := nil;
      oldvars := TStringList.Create;
      withvars := TStringList.Create;
      withelems := TStringList.Create;
      if selection1 = nil then
        exit;
      try
        if apptag.att('db')<>'' then //very experimental
        begin
           try
           db:=getdb_sql(apptag.att('db'),x_databases);
           except on e:exception do writeln('<li>errordb:',e.message);end;
           writeln('<li>using db',x_databases[0],x_databases.count);
           //fromdb:=_createtempdb(db,apptag.att('select'));
           try
           fromdb:=_createtempdb(db,x_databases,apptag.att('select'),apptag.att('table'));
           except on e:exception do writeln('<li>tmpdb_',e.message);end;
           sels := TList.Create;
        end else
        if apptag.att('stream')<>'' then //very experimental
        begin
        t_stream:=tstreamer.create(curbyele.att('stream'),curtoele,curbyele);
        streaming:=true;
        //stream.skip:=curbyele.att('skip');
         //writeln('<li>stream:',curbyele.xmlis)
        end else
        {if apptag.att('selectstream')<>'' then //very experimental
        begin
          writeln('<li>substream:',t_stream.pathtofind.text);
         oldstreampath:=t_stream.changepath(apptag.att('selectstream'));
          //t_stream:=tstreamer.create(curbyele.att('stream'),curtoele,curbyele.att('select'));
        //stream.skip:=curbyele.att('skip');
         writeln('<li>substream:',t_stream.pathtofind.text)
        end else}
        if (CurBYEle.att('list') <> '') then
        begin
           //writeln('<li>apply from list');
           sels:=_listtotag(CurBYEle.att('list'),'').subtags;
           // writeln('<xmp>',_listtotag(CurBYEle.att('list'),'').xmlis,'</xmp>from:',CurBYEle.att('list'));
        end else
        if (CurBYEle.att('select') = '') then
        begin
          sels := TList.Create;
          if curfromele<>nil then sels.Assign(CurFromEle.subtags);
          //logwrite('sewlect'+curfromele.xmlis+'/sel');
        end
        else
        begin
          try
          if CurBYEle.att('select')='&' then
          begin
               if x_relation=nil then writeln('<li>No relation definded for select=&')
               else try begin sels:=x_relation.findrellist;end;except writeln('noselerele');end;
          end else
          sels := CurFromEle.select(CurBYEle.att('select'), True, True);
          //for i:=0 to sels.count-1 do
          //logwrite('selectedx:' + ttag(sels[i]).vari);
          {if pos('attributes::',CurBYEle.att('select'))>0 then
          begin
            writeln('selectedatts:' ,sels.count, '/sle:');
            for i:=0 to sels.count-1 do
            writeln('selectedx:' + ttag(sels[i]).xmlis, '/sle:');
          end;}
          except writeln('<li>failed apply select1');end;
        end;
      except
        writeln('faileapplyselect:' + aps, '/sle:');
        raise;
      end;
      TRY
      olresi := CurToEle.subtags.Count;
      //-templates1 := x_templates;
      selector := apptag.att('selector');
      //writeln('!selector:',selector);
      templateatt := trim(apptag.att('template'));

      if apptag.subtags.Count > 0 then
      begin
        //writeln('<h4>gettemplatesfrom'+apptag.head+'</h4>');
        if (ttag(apptag.subtags[0]).vari = ns + 'templates') or
           (ttag(apptag.subtags[0]).vari = 'templates') then
        begin
          //templates1:=apptag.subtags[0];
          curtemplates := apptag.subtags[0];
          //writeln('foundtemplates in:',curtemplates.xmlis,'!');
        end
        else
        if ttag(apptag.subtags[0]).vari = ns + 'template' then
        begin
          //templates1:=apptag;
          curtemplates := apptag;
          //writeln('<h4>tpls:',apptag.head,'</h4>');
        end
        else
        begin  //simply child element to be applied
          thetpl := apptag;
          if curtemplates=nil then  curtemplates := apptag;
          //writeln('<ul><li>templates set to:'+curtemplates.head+'</li></ul>');
        end;
      end;
      if thetpl = nil then
      begin
        //writeln('<li>templates1?'+apptag.head,curtemplates=nil,seleat);

        if templateatt <> '' then  //use named template -- the same one for all
        begin
          if curtemplates=nil then
          begin writeln('<li>failed finding named template</li>');
            exit;
          end else //writeln('<li>templates for '+apptag.head+curtemplates.xmlis);
          for j := 0 to curtemplates.subtags.Count - 1 do
            //if trim(ttag(templates1.subtags[j]).attributes.values['name']) = seleat then
            if trim(ttag(curtemplates.subtags[j]).att('name')) = templateatt then
            begin
              thetpl := curtemplates.subtags[j];
              break;
            end;
           //writeln('<li>templates?'+apptag.head,thetpl=nil);
        end
        else
         if curtemplates=nil then
         begin writeln('<li>failed finding template</li>');

           //perhaps: if no template, then just copy??
            exit;
          end else //writeln('<li>templates for '+apptag.head+curtemplates.xmlis);
        if (curtemplates.vari=ns+'apply') and (ttag(curtemplates.subtags[0]).vari<>ns+'template') then
        begin  //
          try
          thetpl:=curtemplates;//.subtags[0];
          //writeln('<li>defatemp:',thetpl.head+'/:'+curtemplates.head+'!!!</li>');
          //exit;
          except
            writeln('<li>failed to apply old template for :',apptag.head+'!!!</li>');
          end;
        end;
      end; //thepl nil - no named template or a single non-template under apptag
      if (thetpl = nil) and (curtemplates = nil) then
      begin
        writeln('!-- no templates to apply-->');
        exit;
      end;
      separ := False;
      atlast := False;
      atfirst := False;
      countervar := apptag.att('counter');
      if pos('=', countervar) > 0 then
      begin
        x_svars.Values[cut_ls(countervar)] := cut_rs(countervar);
        //x_svars.add(cut_ls(countervar), cut_rs(countervar));
        countervar := cut_ls(countervar);
      end;

      if apptag.att('separator') <> '' then
      begin
        separ := True;
        septag := ttag.Create;
        septag.vari := '';//'value';
        septag.vali := apptag.att('separator');
        ;
      end;
      if apptag.att('atfirst') <> '' then
      begin
        atfirst := True;
        atfirsttag := ttag.Create;
        atfirsttag.vari := '';//'value';
        atfirsttag.vali := apptag.att('atfirst');
        ;
      end;
      if apptag.att('atlast') <> '' then
      begin
        atlast := True;
        atlasttag := ttag.Create;
        atlasttag.vari := '';//'value';
        atlasttag.vali := apptag.att('atlast');
        ;
      end;
      if apptag.att('withvar') <> '' then
      begin
        _split(apptag.att('withvar'), ',', withvars);
        //x_svars.fromlist(withvars, oldvars);
        for i := 0 to withvars.Count - 1 do
        begin
          //apuii := x_svars.IndexOfName(withvars.Names[I]);
          apuii := x_svars.IndexOfName(cut_ls(withvars[I]));
          if apuii<0 then
          begin
            x_svars.add(cut_ls(withvars[i])+'=');apuii:=x_svars.Count-1;{'<li>failed svars at  ',i);}
          end;
          //aps:=x_svars.values[cut_rs(withvars[i])];
          try oldvars.add(x_svars[apuii]);except writeln('<li>failed Oldvars at  ',apuii,'/',i,'/',x_svars.count);end;
          try x_svars[apuii]:=withvars[i];except writeln('<li>failed svars at  ',apuii);end;
        end;
      end;
      if apptag.att('withelems') <> '' then
      begin
        _split(apptag.att('withelems'), ',', withelems);
        for i := 0 to withelems.Count - 1 do
        begin
          aps := withelems[i];
          withelems[i] := (cut_ls(aps));
          withelems.objects[i] := x_bookmarks.subt(aps);
        end;
      end;
      sortstr:=true;
      try
      if apptag.att('sort') <> '' then
        //if apptag.att('sort') <> '-' then

       _DOSORT(Sels,APPTAG.ATT('sort'));
      except writeln('<li>failed applysort</li><pre>',sels.count,'</pre>!!!');
      for j:=0 to sels.count-1 do writeln('<li>x:',j,ttag(sels[j]).head);
      end;
      compfunc:=@_sortcomptags;  //this is only for relations (groupings???)
      if (fromdb<>nil) or (streaming) then times:=99999999 else
      if sels<>nil then
      begin times := strtointdef(apptag.att('times'), sels.Count);
      if times<0 then times:=sels.count+times;
      end;
      if apptag.att('mintimes') <> '' then
      begin
        times := max(strtointdef(apptag.att('mintimes'), -1), times);
      end;
      if apptag.att('maxtimes') <> '' then
        times := min(strtointdef(apptag.att('maxtimes'), times), times);
      if times < 0 then
        times := sels.Count + times;
      if apptag.att('resetvars') = 'true' then
      begin
        //HASHED?       oldvars.Text := x_svars.Text;
        oldbookm := x_bookmarks;
      end;
      if apptag.att('prefix') <> '' then
        ns := apptag.att('prefix');
      break_state := br_goon;
      if apptag.att('relation')<>'' then
       trelation.create(apptag.att('relation'),sels,self,hasrelation,compfunc);
      try
      if apptag.att('grouping')<>'' then
       grouping:=tgrouping.create(apptag.att('grouping'),sels) else grouping:=nil;
      except writeln('failcreategroup');end;
      //writeln('<li>dbapply_3');

      except writeln('failED APPLYSETUP',apptag.head);end;
      //writeln('<li>dbapply_4');
      //if sels=nil then sels:=tlist.create;
      //for i := 0 to times - 1 do
      i:=-1; while i<times-1 do
//************** APPLY LOOP ****************************************************
      begin
        TRY
        i:=i+1;
        atpl := nil;
        if fromdb<>nil then
        begin
         asel:=fromdb.sql_next;
         if asel=nil then break;
        end
        else
        if streaming then
        begin
         //asel:=t_stream.nexttag(0);
         if asel=nil then begin writeln('<li>gotnilfromsrteam:',t_stream.curline+'!!!');
           break;end;

         //writeln('<li>xchanged:',t_stream.restags.count,'/',t_stream.downcount,'/',t_stream.restags.count-t_stream.downcount);
         writeln('<li>RESto:',curtoele.xmlis, '::::from:',asel.xmlis,'');
         //for apuii:=t_stream.restags.count-t_stream.downcount to t_stream.restags.count-1 do
         //   writeln('<li>newlev:',              apuii);
            //writeln('<li>newlev:',ttag(t_stream.restags[apuii]).head,'!');
        end
        else
        if grouping<>nil then
        begin
          try
           asel:=grouping.nextgrouptag;
           i:=i+asel.subtags.count-1;
           //writeln('<li>gotgroup<pre>',asel. xmlis,'</pre>');
          except writeln('failgetgroup');end;
        end else
        if sels.Count = 0 then
          asel := CurFromEle
        else
        if i < sels.Count then
          asel := sels[i]
        else
        begin
          asel := sels[sels.Count - 1];
        end;
        //if apptag.att('debug')='true' then writeln('<li>apply:',curfromele.xmlis);
        if countervar <> '' then
          x_svars.Values[countervar] := IntToStr(strtointdef(x_svars.Values[countervar], 0) + 1);
        if thetpl <> nil then //fixed, named tpl
        begin
          atpl := thetpl;
        end
        else
        begin     //find the custom template for this tag
          try
            if selector = '' then
              selst := asel.vari
            else
            begin
              selst := parsefromele(asel,selector);
              //writeln('<li>selex:',selector,'///',selst);
            end;

          except
            writeln('notgot selector');
          end;
          hadmat:=false;
          {try
            writeln('<li>try<pre>:'+selst+curtemplates.vari+'!',i,curtemplates.xmlis,'!!!</pre>');
          except
            writeln('<li>fail!!!templates for:'+selst+'!');
            //writeln('<li>fail<pre>:'+selst+curtemplates.vari,'!!!</pre>');

          end;}
          for j := 0 to curtemplates.subtags.Count - 1 do
          begin
            try
              //writeln('<li>match?'+selst+'!',ttag(curtemplates.subtags[j]).att('match'),'!');
              mat:=ttag(curtemplates.subtags[j]).att('match');
              iF mat<>'' then hadmat:=true;
              if _matches(mat, selst) then
              begin
                atpl := curtemplates.subtags[j];
                //writeln('<li>OK',selst);
                break;
              end;//  else   writeln('<li>failtpl:'+mat,'!',selst,'</li>');

            except
              writeln('<li>failed apply find template in:', ttag(curtemplates.subtags[j]).head, '/');
            end;
          end;
        end;
        if atpl = nil then
        begin
          if (not hadmat) and (curtemplates.subtags.count>0) then atpl:=curtemplates else  //.subtags[0] else
          begin
            writeln('<---no template for ' + asel.vari + '/in:' +      curtemplates.head + '',hadmat,'-->');
            continue; //break;
          end; //writeln('<li>applytpl:',atpl.xmlis,'</li>');
        end;// else   atpl:=atpl;
        //        atpl := atpl.clonetag(true);  //??????????????????
        // template can be modified during run, so we mustn't modify the original
        //(probably would be better to not modify, in eg. c_if)
        //registertagowner(self,self.elems);
        // needs testing, but at some point cloning can maybe be removed
        try
          //breaks := False;
          OLDappta := CurBYEle;
          CurBYEle := atpl;
        except
          writeln('<li>nogosel1: ');
        end;
        try
          CurFromEle := asel;
          if asel = nil then
            break;
          if atfirst then
            if I = 0 then
              begin
                CurToEle.subtagsadd(atfirsttag)
              //resUadd(atfirsttag.copytag);//(
              end;
        except
          writeln('<li>nogosel2: ');
        end;
        try
          if hasrelation then x_relation.findrel(curfromele);
        except writeln('<li>failed reletion:</li>',curfromele.head);end;
        try
         if streaming then writeln('<li>applystr:'+atpl.head+'//from: '+asel.xmlis,'/to:',curtoele.head,'//',i,'/',times,'</li>');
          //doelements(nil);
          if atpl <> nil then
            if atpl.subtags <> nil then
              if atpl.subtags.Count > 0 then
//*********************************************************************************
               result:=doelementlist(atpl.subtags); //else
          //  curtoele.addsubtag('c','d');
//*********************************************************************************
          //writeln('<h3>no template</h3>');//<pre>'+curtoele.xmlis+'</pre>');
            except
              writeln('<li>nogosel3: ' + atpl.vari + atpl.vali);raise;
        end;
        try
          if streaming then    writeln('<li><b>GOTRES:',curtoele.xmlis,'!');

          {if x_stream<>nil then //experimebntal
          begin
            for j:=0 to curtoele.subtags.count-1 do
            begin
              aputag:=curtoele.subtags[i];
            // x_database.q.params.items[j]:=curtoele
              writeln('<li>-------<pre>',aputag.xmlis+'</pre>',db.q.fieldcount,'////////',
              db.q.fieldcount);
              try
              begin
                //db.Q.appendrecord([1]);
                //db.q.Params.ParamByName('url').AsString := aputag.att('a');
                //db.q.Params.ParamByName('date').AsString := aputag.att('b');
                //db.q.Params.ParamByName('name').AsString := aputag.att('c');
                //db.q.execSQL;
              end;
              //db.q.active:=true;
              //db.Q.appendrecord([aputag.att('a'),aputag.att('b'),aputag.att('c')]);
              //db.q.active:=false;
              except on e:exception do writeln('noprep:'+e.message);end;
            end;
            //curtoele.clearmee;
          end;}
          //WRITELN('<li>DIDDOAPPLYLOOP asel:', i, Asel.XMLIS, '<HR/>');
          //if apptag.att('debug') = 'true' then
          //  writeln('<li>debug:<xmp>', CurToEle.xmlis + '</xmp><hr/></li>');

          CurBYEle := oldappta;
          try
            //!!          atpl.clearmee;
          except
            writeln('failde to free tmlp_');
          end;
        except
          writeln('<li>nogosel: ' + asel.vari);
        end;
          {if state.s_break or state.s_exit or state.s_halt then
          begin
            state.s_break := False;
            break;
          end;
          }
        if separ then
          if I < times - 1 then
            resUadd(septag.copytag);//(
        if atlast then
          if I = times - 1 then
            resUadd(atlasttag.copytag);//(
        case break_state of
          br_cont:
          begin
            break_state := br_goon;
          end;
          br_break:
          begin
            break_state := br_goon;
            //writeln('<li>broke apply',curbyele.xmlis,'</li>');
            break;
          end;
          br_exit:
          begin
            break;
          end;
        end;
        //if t_stream<>nil then asel.killtree;
        EXCEPT writeln('<-- apply ONESTEP failed-->');raise;END;

      end;  //of the apply select times-loop
      //writeln('didaappl',apptag.att('select'),'y</ul></li>');
//************** END APPLY LOOP ***********************
      if pos('attributes::', CurBYEle.att('select')) > 0 then
        for i := 0 to sels.Count - 1 do
        begin //writeln('<li>killatt:',i,ttag(sels[i]).vari);
          ttag(sels[i]).clearmee;ttag(sels[i]).free;
        end;
      try
      sels.Clear;
      sels.Free;

      except
      end;
      if apptag.att('resetvars') = 'true' then
      begin  //NOT DOINF NOTHINF
        //x_svars.Clear;
        //HASHED?        x_svars.Text := oldvars.Text;
        x_bookmarks := oldbookm;
      end;
      {start! if apptag.att('nonstop') = 'true' then
        while x_started.elems.Count > 0 do
          c_stop;}
    except
      writeln('<-- apply failed-->');
    end;
  finally
    try

      //if t_stream<>nil then streamer.free;
      curfromEle := oldfrom;
      //writeln('EO-APPLY1:<b>',curtoele.xmlis,'</b>',xml.subtags.count);//(getheapstatus.totalallocated) div 1000,'!');
      x_critical := ocrit;
      try
        try
         if hasrelation then x_relation.free;
         if grouping<>nil then grouping.free;

        except writeln('relnotfreed');
        end;
        if pos('file://', CurBYEle.att('select')) = 1 then
        begin
          try
            rootseltag.killtree;
          except
            writeln('apply-free fromfile failed');
          end;
        end;
      except
        writeln('applystateappta failed');
      end;
      try
        templist.Free;
      except
        writeln('apply-tmpfree failed');
      end;
      try
        //CurToEle:=oldres.parent;
        curtemplates := oldtemplates;
        ns := oldprefix;
      except
        writeln('apply-free1 failed');
      end;
      try
       //if withvars.Count > 0 then
        //  writeln('<li>withvars not impl. / qworking'+withvars.text+'///');
        //writeln('<li>WVmem2:'+x_svars.find('sel')+'</li>!');
        //x_svars.fromlist(oldvars, withvars);
        for i := 0 to oldvars.Count - 1 do
        begin
          //writeln('<li>resetvar:',oldvars.Names[i],'/from:',x_svars.Values[oldvars.Names[i]],'/to:',oldvars.valuefromindex[i]);
          //writeln('<li>resetvar:',oldvars.text);

          x_svars.Values[cut_ls(oldvars[i])]:=oldvars.valuefromindex[i];
          //apust:=oldvars.names[i];
          //apuii := x_svars.IndexOfName(oldvars.Names[I]);
          //x_svars.values[cut_rs(withvars[i])];
          //oldvars.add(x_svars[apuii]);
        end;
        {for i := 0 to withvars.Count - 1 do
        begin
           x_svars.add(cut_ls(withvars[i]), oldvars.values[cut_ls(withvars[i])]
           );
          writeln('<li>wvmem:'+withvars[i]+'!'
          +x_svars.find(cut_ls(withvars[i])));
        end;
         // x_svars.add(cut_ls(withvars[i]), cut_rse(withvars[i]));
        }
        //writeln('<li>WVmem2:'+x_svars.find('sel')+'!'+oldvars .text+'!</li></ul></li>!');
      except
        writeln('apply-free2 failed');
      end;
      try
    {DISABLED temporarily - do we need this?
    if withelems.count>0 then
      for i:=0 to withelems.count-1 do
      begin
         apui:=x_bookmarks.indexof(withelems[i]);
         x_bookmarks.objects[apui]:=withvars.objects[i];
      end;
    }
        //writeln('EO-APPLY3:',(getheapstatus.totalallocated) div 1000,'!');
        oldvars.Clear;
        oldvars.Free;
        //oldelems.clear;oldelems.free;
        withvars.Clear;
        withvars.Free;
        withelems.Clear;
        withelems.Free;
      except
        writeln('apply-freeend failed');
      end;
      //writeln('<li>donestream:',tstream<>nil,streaming,oldstreampath=nil);
       if streaming then if t_stream<>nil then //if oldstreampath=nil then
       t_stream.free;// else t_stream.pathtofind:=oldstreampath;
    except
      writeln('apply-free failed');
    end;
  end;
  //writeln('END-APPLY1:<b>',curtoele.xmlis,'</b>',xml.subtags.count);//(getheapstatus.totalallocated) div 1000,'!');

end;





function txseus.c_inc: boolean;
{D: adds 1 to var)
}
var
  iby : integer;
  ivar,ibys: string;             //bl:tbucketlist;
begin
  ivar := CurBYEle.att('var');
  ibys := CurBYEle.att('by');
  if ibys='' then iby:=1 else iby:=strtointdef(ibys,1);
  if ivar <> '' then x_svars.values[ivar]:=inttostr(strtointdef(x_svars.values[ivar],0)+1);


{  //bl:=tbucketlist.create;bl.
  //writeln(CurBYEle.xmlis,'+1=', x_svars.text);
  ovarname := CurBYEle.att('var');
  spos:=x_svars.indexof(ovarname);
  if spos<0 then
     x_svars.add(ovarname+'=1')
  else begin
    x_svars.sorted:=false;
    oval := strtointdef(x_svars.strings[spos], 0);
   x_svars.strings[spos] := IntToStr(oval + 1);
  //oval := strtointdef(x_svars.values[ovarname], 0);
  //x_svars.values[ovarname] := IntToStr(oval + 1);
   x_svars.sorted:=true;
  end;
  //writeln(ovarname,'?',oval,'+1='+ x_svars.text);
  //oval:=strtointdef
}
end;

function txseus.c_incattribute: boolean;
{D: adds 1 to var)
}
var
  oval: integer;
  ovar, ovarname: string;
begin
  //writeln(CurBYEle.xmlis,'+1=', x_svars.text);
  ovarname := CurBYEle.att('name');
  oval := strtointdef(CurToEle.att(ovarname), 0);
  CurToEle.setatt(ovarname, IntToStr(oval + 1));
  //CurToEle.attributes.values[ovarname] := IntToStr(oval + 1);
  //writeln('<LI>ia:',curtoele.vari,':',CurToEle.head,';',ovarname,'?',oval,'+1='+ CurBYEle.head);
  //writeln('<LI>bm:',x_bookmarks.xmlis);
  //oval:=strtointdef

end;

function txseus.preparebytag(old: ttag; var orignew: ttag): ttag;
  // var newroot: ttag): ttag;

var
  i, k, apui, rootpos: integer;
  vari, vali, rest: string;
  sres, newtag, at: ttag;
  gottafree: ttag;
  //ifs:tstringlist;
  procedure dotofrom(thisat, thisval: string);
  var
    subtag: ttag;//clist:tlist;
  begin

    subtag := newtag;
    orignew := subtag;
    newtag := ttag.Create;
    newtag.vari := thisat;
    subtag.attributescopyfrom(old);
    subtag.delatt(thisat);
    subtag.vari := old.vari;
    subtag.vali := old.vali;
    //subtag.subtags.Free;
    //subtag.subtags:=old.subtags; //raw copy without cloning.. danger
    //ores:=old.copytag;
    //old.;
    newtag.parent := old.parent;
    newtag.subtagsadd(subtag);
    //create a xse:to or xse:by command element with newtag as subtag
    //writeln('<h2>ddodo '+thisat+'</h2><xmp>'+newtag.xmlis+'</xmp><hr/>');
    //ores.parent := Result;
    vari := 'element';
    if pos('!file(', thisval) = 1 then
    begin
      _fetch('!file(', thisval);
      vali := _fetch(')', thisval);
      //vali:=thisval;
      //vali := copy(thisval, 8, 999);
       vali := parsexse(vali, self);
      vari := 'file';
      //writeln('<li>getfile:',vari,'=',vali)
    end
    else
    if (pos('!http(', thisval) = 1)  then
    begin
      //vali:=copy(vali,8,999);
      vari := 'url';
      _fetch('!http(', thisval);
      vali := _fetch(')', thisval);
      //vali:=thisval;
      //vali := copy(thisval, 8, 999);
      //vali:=parsexse(thisval, self);
      vali := parsexse(vali, self);
      if pos('http://', lowercase(vali))<1 then vali:='http://'+vali;
     // writeln('<li>fromurl:'+vali);
    end
    else
    if  (pos('!https(', thisval) = 1) then
    begin
      //vali:=copy(vali,8,999);
      vari := 'url';
      _fetch('!https(', thisval);
      vali := _fetch(')', thisval);
      //vali:=thisval;
      //vali := copy(thisval, 8, 999);
      //vali:=parsexse(thisval, self);
      vali := parsexse(vali, self);
      if pos('https://', lowercase(vali))<1 then vali:='https://'+vali;
      //writeln('<li>fromsslurl='+vali);
    end
    else
    if thisval = 'browser' then
    begin
      vari := 'browser';
      vali := 'true';
    end
    else
      vali := parsexse(thisval, self);
    newtag.setatt(vari, vali);

    Result := newtag;
    //writeln('<h2>ddodo '+thisat+'</h2><xmp>'+newtag.xmlis+'</xmp><hr/>');
      {clist:=tlist.create;
      clist.add(newtag);
      curtoele:=ttag.create;
      try
      doelementlist(clist);
      result:=nil;
      writeln('<h2>did '+thisat+'</h2><xmp>'+curtoele.xmlis+'</xmp><hr/>');
      except writeln('<h1>nogotofromtag');end;
      }
  end;

begin
  try
  // if old=nil then writeln('<li>nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnä');
   //try
   //except writeln('<li>nothing to prepare');raise;end;
    Result := nil;
    orignew := nil;
    newtag := ttag.Create;
    try
      newtag.vari := old.vari;
      if old.vali <> '' then
        newtag.vali := parsexse(old.vali, self);
    except
      writeln('<li>failed substitute vali' + old.vali, '!');
    end;
    try
    for i := old.subtags.Count - 1 downto 0 do
    begin
      if t_debug then  writeln('<li><small>TONEW:' + ttag(old.subtags[i]).vari + '!</small>');
      newtag.subtags.insert(0, old.subtags[i]);  //note, insert links, not copy elems
    end;
  except
    writeln('<li>failed copy subtags' + old.vari, '!');
  end;

  try
    if old.att(ns + 'to') <> '' then
    begin
      dotofrom(ns + 'to', old.att(ns + 'to'));

      exit;
    end;
  except
    writeln('<li>failed to prepare XSE:TO',old.vari);
    //newtag.killtree;
  end;
    if old.att(ns + 'from') <> '' then
    begin
      vali:=parsexse( old.att(ns + 'from'), self);
      if vali<>'' then
      begin
      //writeln('<li>fromold:',vali,'/<pre>' + old.head + '!</pre>');
      dotofrom(ns + 'from', vali);//old.att(ns + 'from'));
      //writeln('<li>fromNEW<pre>' + newtag.xmlis + '!</pre>');
      exit;
      end;
    end;
    if old.att(ns + 'by') <> '' then
    begin
      try
      vali := old.att(ns + 'by');
      rootpos := 1;
      sres := p_selroot(vali, SELF, curbyele, rootpos, True, gottafree);
      rest := copy(vali, rootpos, 9999); //rest;
      //if pos('class',vali)>1 then writeln('<li>gotbm:',sres.xmlis,'!!!',rest,'!');
      // writeln('<li>goby:',sres.head,'!!!(',rest,')!!!');
      if sres = nil then
        sres := curbyele;
      if rest <> '' then
        sres := sres.subt('+' + trim(rest));
      for i := 0 to sres.subtags.Count - 1 do
        newtag.subtags.add(sres.subtags[i]);
      //newtag.subtags.add(sres);
     // newtag.attributescopy(old);
    //  newtag.delatt(ns + 'by');
      //Result := newtag;
      except writeln('<h1>failed: nobyby</h1>');end;
      //exit;
    end;
    //writeln('<li>'+vali+'unprepared=<xmp>'+newtag.xmlis+crlf+'!!!</xmp>');

    for k := 0 to old.attributesCount - 1 do
    begin
       try
        vali := old.getattributes[k];
        vari := cut_ls(vali);
        vali := cut_rs(vali);
       except
         writeln('<li>NONOSUBS:' + vari + '/' + vali + '!');
        end;
       try
        //if pos(ns,vari) =1 then
        if (vari <> ns + 'if') then
        begin
          if (vari = ns + 'bookmark') then
          begin
            //at := ttag.Create;
            //x_bookmarks.subtags.add(at);//addsubtag(bm, '');
            //at.vari := vali;
            //writeln('<li>TO:'+curTOELe.vari, ':',curtoele.xmlis ,'</li>');
            //at.subtags.add(CurFromEle);
            setbookmark(vali, curfromele);
          end
          else
          if pos(ns,vari)<>1 then
          begin
            newtag.setatt(vari, parsexse(vali, self));
            //if (vari='id') and (pos('s1_1',vali)>1) then writeln('<li>!!!!!SetId',vali,'!!!!', parsexse(vali, self));
          end;
        end;
      except
        writeln('<li>NOSUBS!!' + vari + '/' + vali + '!!');
      end;
    end;
    Result := newtag;
    //if old.att(ns+'by')<>'' then
  except
    writeln('<li>failed to prepare cmd',old.vari);
    newtag.killtree;
  end;
end;

function txseus.copysubatts(old, new: ttag): boolean;
  //only used by almost unused "doone". probably unnecessary but gotta check...
var
  k: integer;
  vari, vali: string;
begin
  try
    //if pos('!debug', old.vali) > 0 then
    begin
      // g_debug := True;
      if NEW = nil then
        writeln('<li>niltag from:' + old.vali);
    end;//else
    if old.vali <> '' then
      new.vali := parsexse(old.vali, self);
  except
    writeln('failed substitute vali' + old.vali, '!');
  end;
  for k := 0 to old.attributesCount - 1 do
  begin
    try
      vali := old.getattributes[k];
      vari := cut_ls(vali);
      vali := cut_rs(vali);
    except
      writeln('NONOSUBS:' + vari + '/' + vali + '!');
    end;
    try
      new.setatt(vari, parsexse(vali, self));
    except
      writeln('NOSUBS!!' + vari + '/' + vali + '!!');
    end;
  end;
  //  g_debug:=false;

end;

type
  TExec = function: boolean of object;

function txseus.doonerror: boolean;
{Doc: insert onerror-element into handler at current point
 -group: programflow
 -status: experimental
 -usage: hopefully common in future
}
var
  newcom: ttag;
  acomx, exchand: ttag;
  i, thiscomi, parsubtags: integer;
  acom: ttag;
begin
  try
    //aput:=x_handlers.SUBt('class/handler[@name='+CurBYEle.att('handler')+']').copytag;
    writeln('get exception' + stateexception + ' in <xmp>' +
      CurBYEle.listraw + '</xmp>');
    //listwrite(CurBYEle);
    thiscomi := CurBYEle.parent.subtags.indexof(CurBYEle);
    parsubtags := CurBYEle.parent.subtags.Count;
    for i := thiscomi + 1 to parsubtags - 1 do
    begin
      acom := CurBYEle.parent.subtags[i];
      // writeln('<li>skip:'+acom.vari+'</li>');
      if acom.vari = ns + 'except' then
      begin
        _listtolist(CurBYEle.parent.subtags,
          acom.subtags, CurBYEle.parent.subtags.indexof(CurBYEle),
          CurBYEle.parent);
        writeln('Got exception' + stateexception + ' in <xmp>' +
          acom.listraw + '</xmp>');
        //listwrite(acom);
        //listwrite(CurBYEle.parent);
        if acom.att('raise') <> '' then
          stateexception := '';
        exit;

      end;
      //state.upsstateexception:=sstateexception;
    end;
  except
    writeln('could bnot handker exception');
  end;

end;


//exchand:=CurBYEle.parent.SUBt('xse:except').copytag;
       {
        if exchand<>nil then
        try
      listwrite(CurBYEle.parent);
      except
       _h1('failed include');listwrite(CurBYEle);end;
       }

function txseus.doone(atag: ttag): ttag;  //not really used .. probably not working ...?
var
  newtag, oldto,oldby: ttag;
begin
      if atag.subtags.Count > 0 then exit;

  try
    //listwrite(progt);
    newtag := ttag.Create;
    newtag.vari := atag.vari;
    try
      copysubatts(atag, newtag);
      //writeln('<li>doelem loop respoint:',progt.vari,'/',state.respoint);
      //listwrite(newtag);
        {newtag.vali:=progt.vali;
        newtag.attributes.addstrings(progt.attributes);
        newtag.parent:=state.resta;
        newstate.restagadd(newtag);
        newstate.resta:=newtag;
        }
      //state.restagadd(newtag);
      oldto := CurToEle;
      oldby := CurbyEle;
      //oldpoint:=state.respoint;
      CurToEle := newtag;
      CurBYEle := atag;
      newtag.parent := oldto;
      //  listwrite(newtag);
     // if atag.subtags.Count > 0 then
        try
          dosubelements;
        except
          writeln('FAILEDDOELE');
          listwrite(newtag);
        end;
    finally
      CurToEle := OLDto;
      CurbyEle := OLDby;
      //state.respoint:=OLDpoint;
    end;
  except
    _h1('failed newx');
    listwrite(newtag);
    raise;
  end;
  Result := newtag;
end;


function txseus.dosubelements: boolean;
var
  comlist: TList;
  i: integer;
begin
  try
    if curbyele=nil then writeln('<li>nothingtodoodoo', '</li>');
    comlist := CurBYEle.copysubtags;
  except
    writeln('<li>nodoodoolist', '</li>');
  end;
  //writeln('<li>DOSUBS***from:'+curbyele.xmlis);
  //for i:=0 to comlist.count-1 do writeln('<li>c_',ttag(comlist[i]).vari,'</li>');
  //writeln('gogogox');
  try
    result:=doelementlist(comlist);
  finally
    //logwrite('DISUBS***');
    comlist.Clear;
    comlist.Free;
    //logwrite('DidclearS***from:'+curfromele.vari);
  end;
end;

function txseus.doelementlist(proglist: TList): boolean;
  //starting a new func to take care of both docoms2 and doelements.
  //probably allowing for xse-attributes in non-xse -elements.
  //wondering about what to do with apply: perhaps anything could be an apply
  //if it has proper attributes (xse:apply="*")
var
  i, progcounter, oldpoint, oldstarts,
  tags, stags, ktags, sktags, mem, smem,apui: integer;
  firststarted,orignew: ttag;
  newtag, thistagroot, backto,oldto, progt,startedele,startedpar, oldBY : ttag; //sstartedele,sstartedpar, turha
  alist: TList;
  oldns: string;
  ermes,memlog, taglog: string;

  //progtag: ttag;
  did, deb,elsepending,mydebug,trying: boolean;

begin
  mydebug := false;
  result:=true;
  ermes:='';
  mydebug := False;
  deb := False;
  oldto := CurToEle;
  oldby := curbyele;
  trying:=false;
  if x_started.elems.count>0 then
  begin
    firststarted:=x_started.pars[0];
    startedpar:=x_started.getpar;
    startedele:=x_started.getele;
  end else firststarted:=nil;
  //if mydebug then   if curtoele<>nil then   writeln('<li>cmdlist:<b>',curbyele.vari,'</b> ','/xstart:',x_started.count,'<ul style="border: 1px solid gray">');
 //  if firststarted<>nil then writeln('<li>fstart:'+firststarted.head);
  try
   if proglist = nil then  exit;
   progcounter := -1;
   while (progcounter < proglist.Count - 1) do
   //*********main loop**********
   begin
        try
        progcounter := progcounter + 1;
        progt := proglist[progcounter];
         //if progt.vari=ns+'to'
         //then
         //writeln('<li>cmd:'+progt.vari+'///:',progt.xmlis,'</li><hr>');
        if (curtoele = nil) then if not(progt.vari=ns+'to') then
          curtoele := ttag.Create;
          except        writeln('failed commandlist start');      end;


      begin //some special commands, should not be handled here (?)
      try
      if (progt.att(ns + 'try') <> '') then begin trying:=true;writeln('<li>trying!');end;
        if (progt.att(ns + 'if') <> '') then
        begin  //will take care of this in the main doelementlist-loop and remove from here
            elsepending:=false;
            apui:=1;
            {INFIX if _p_infix(parsexse(progt.att(ns + 'if'), self),apui, self,'') <> '1' then)}
            if parsefromele(curfromele,parsexse(progt.att(ns + 'if'), self)) <> '1' then

            begin
              elsepending:=true;
              progcounter := progcounter + 1;
              if progcounter>=proglist.count then break;
              progt := proglist[progcounter];
            end;
         end;
        if progt.vari=ns + 'else' then
        begin
           if elsepending then
           begin
             result:=doelementlist(progt.subtags);
             //dosubelements;
           end;
           elsepending:=false;
           continue;
        end;
        if (progt.att(ns + 'else') <> '') then
        begin
         if not elsepending then continue else elsepending:=false;
        end;
        //try
          if progt.att(ns + 'marktime') <> '' then
          x_times.addsub(progt,'');
      except  writeln('<li>failed cmdlist prepare'+progt.vari);    end;
      end;
      //end of special commands
      //prepare frombyto's
      begin
        try
        // try
        //if mydebug then
        //writeln('<li>cmd:'+progt.vari+'/tonil:',curtoele=nil,'/oldtonil:<b>',oldto=nil,'</b></li>');
        //except writeln('<li>cmdnolist:',progt.head,curtoele=nil,'</li>');end;
        newtag := preparebytag(progt, orignew);// orignew will point to new even if it changed by to/by;
        if newtag = nil then
        begin
          writeln('<li>FAILED TO PREPARE CMD, skipping:'+progt.xmlis);
          continue;
        end;
        oldns := ns;
        curbyele := newtag;  //clone with xseed atts etc, including subtags
        if progt.att(ns + 'ns') <> '' then
        begin
          newtag.delatt(ns + 'ns');
          ns := progt.att(ns + 'ns') + ':';
          //writeln('lis>new namespave: ',
        end;
        except writeln('failed to prepare progtag'+progt.vari );  end;
      end;
      backto:=curtoele;
      oldstarts:=x_started.elems.count;
      //end of one cmd preparations
        //************************************ COMMAND-ELEMENTS
      if (pos(oldns, newtag.vari) = 1) and (curfromele<>nil) then
      begin
          try
            did := Execute(oldns);
            if progt.vari=oldns + 'if' then  begin elsepending:=not did; end;
            //if progt.vari=oldns + 'start' then begin startedhere:=true;//oldto:=x_started.getele;end;
          except on e:exception do begin writeln('<li>failed DO EXEC' + progt.vari + e.message); writeln(curfromele.head,'!!!');
             if trying then ermes:=e.message; raise;  end;end;
      end
        //end of ns:command
      else //********************************** PLAIN ELEMENTS
      begin
          try
            thistagroot:=curtoele.addsubtag(newtag.vari,newtag.vali);
            thistagroot.attributescopyfrom(newtag);
            CurToEle := thistagroot;
             if newtag.subtags.Count > 0 then
              begin
                try
                  CurToEle := thistagroot;
                  //writeln('<li>dosub:'+curtoele.head+'<ul>');
                  dosubelements;
                  //writeln('</ul></li><li>didsub:<b>'+curtoele.head+'</b>',curtoele.parent.head);
                  //if x_started.count=0 then curtoele:=curtoele.parent else curtoele:=x_started.getele;
                except   writeln('FAILED DOELE noXSE:', progt.vari); logwrite('FAILED DOELE noXSE:'+ curtoele.head);    raise;    end;
               end else mydebug:=true;
             //try
             // thistagroot.addatt('debug="to:'+curtoele.vali+'/started:'+inttostr(x_started.count)+'/olstarts'+inttostr(oldstarts)+'/'
             // + '/from:'+curfromele.vali+ '/oldto:'+oldto.vari+oldto.vali+'  /backto:'+backto.vari+backto.vali+'"');
             // except writeln('failed:',progt.head ,curtoele=nil,curfromele=nil, backto=nil,'/back:',oldto=nil); end;

          except on e:exception do begin writeln('<li>failed plain element' + progt.vari + e.message); if trying then ermes:=e.message;   end;end;
      end;
         //end of no-ns
      //finally  //both ns: and plain:
      if ermes<>'' then
      begin
         writeln('<li>failure: skip until exec',progcounter,'/',proglist.count);
         try
         while (progcounter < proglist.Count) and (ttag(proglist[progcounter]).vari<>ns+'except') do
         begin
           writeln('<li>skipping:',progcounter);
           writeln('...'+ttag(proglist[progcounter]).vari+':'+ermes );
           progcounter:=progcounter+1;

         end;
         ermes:='';
         except writeln('failed skipping');end;
           //dosubelements;
           //break;
           writeln('clean up??');

      end;
      begin //PLACE RESULTS AND CLEANUP
        try
          //if progt.vari<>ns+'stop' then
          //begin
          //if mydebug then writeln('<li>did newnil=',newtag=nil, '/onil:', oldto=nil,'/curnil:',curtoele=nil);

          if newtag <> nil then
          begin
            if (oldto = nil) and (curtoele<>nil) then
            begin
              try
                if x_started.elems.count>0 then
                 c_stopall;  //maybe not all? 0 means all
                //writeln('<li>BROWSER/STARTED (should not happen)', x_started.getele.head,'/ @',curtoele.head);
                //if not t_debug then
                 writeelement;
                //if mydebug then
                 curtoele := nil;
              except writeln('<h3>failed write to client</h3>');   end;
            end else
           begin
           //curtoele.addatt('HADstarted="old:'+inttostr(oldstarts)+'/now:'+inttostr(x_started.count)+'"');
           if (x_started.elems.count=0) then //and (oldto<>nil) then
           begin
             if firststarted=nil then //nothing is, nothing was. Ignore the backto, use original oldto
               begin
                 //if mydebug then writeln('<li>xxx:',curtoele.head,'///',oldto.head);
                 curtoele:=oldto;
               end
             else //something had been startged, but no longer is
               begin curtoele:=firststarted;  end;
           end else
           //if (x_started.count=oldstarts) then
           if (x_started.getele=startedele) then //no changes, use what was before this
             begin //
                curtoele:=backto;
             end
           else  //somthng has changed below
            // if x_started.count>oldstarts then
             if x_started.laststart then
               begin  //last startstop was a start, place under that
                 curtoele:=x_started.getele;
              end; //last was a stop, so keep the point where it reverted
             //else  curtoele.addatt('start=goon'); //has done a stop
          //if (x_started.count>0) and (x_started.count<oldstarts) then curtoele:=x_started.getpar;
          oldstarts:=x_started.elems.count-oldstarts;
         end;
         oldstarts:=x_started.elems.count-oldstarts;
         ns := oldns;
            if progt.att(ns + 'marktime') <> '' then  x_times.return;
            //if mydebug then writeln('<li>clearprog:',newtag.head,'///',oldto.head);

            newtag.CLEARMEE; //note: subtags not cleared, they are raw copies (pointers to the original subtags)
            newtag.free;
          end else writeln('nonewprogtag');
          if orignew <> nil then
            begin    orignew.clearmee;orignew.free;end;//orignew - copy of original wtih to/by attr removed, placed under to/by element
        except writeln('<h3>failed to clear up after cmd: ', progt.vari, '</h3>');     end;
        curbyele:=oldby;
        // writeln('</ul></li><li>diddo:<b>',progt.vari,'</b> /has:',x_started.count,'):',oldto=nil,curtoele=nil);
      end;
      //end of finals of one command
      if break_state <> br_goon then
        break;
      //logwrite('DidCOM'+progt.vari);
    end;
    //end  of subelement-loop
  finally
    //!?writeln('<li>//cmdlist:'+oldby.head+'</li></ul>');
    curbyele := oldby;
    //writeln('<li>nextdo:' + curbyele.head);
  end;
end;


function txseus.c_bookmark: boolean;
{D:sets a "bookmark" - variables that are pointers to elements
and referenced by xse:!bm(name)

}
var
  obi, i: integer;
  bm: string;
  at: ttag;
begin
  try
    //exit;
    //writeln('<li>biikbarks:',x_bookmarks.xmlis+'</li>');
    bm := CurBYEle.att('name');
    if bm='' then   bm := trim(CurfromEle.vali);
    //writeln('<li>bookmark',bm);
    setbookmark(bm, curfromele);
    //writeln('<li>setbm2:',bm,x_bookmarks.xmlis,'',curfrom);
    exit;
    //obi:=x_bookmarks.IndexOf(bm);
    //if obi<0 then
    // x_bookmarks.addobject(bm,CurFromEle) else
    // x_bookmarks.Objects[obi]:=CurFromEle;

    // writeln('<li>setbm0:');
    // writeln('<li>setbm1:',x_bookmarks.count);
    // x_bookmarks.addobject(,CurFromEle);
    // x_bookmarks.addobject(CurBYEle.att('name'),CurFromEle);
    // writeln('<li>setbm2:',obi,bm,x_bookmarks.count,x_bookmarks.text);
    // listwrite(CurFromEle);
    //listwrite(ttag(x_bookmarks.objects[0]));
  except
    writeln('failedsetbooknmark');
  end;
end;
function txseus.c_bookmark_to: boolean;
{D:sets a "bookmark" - variables that are pointers to elements
and referenced by xse:!bm(name)

}
var
  obi, i: integer;
  bm: string;
  at: ttag;
begin
  try
    bm := CurBYEle.att('name');
    if bm='' then   bm := trim(CurbyEle.vali);
    writeln('<h2>dosetbookmark',bm,'</h2><pre>',x_bookmarks.xmlis,'!</pre>?',curtoele.xmlis,'?<hr/><hr/>');
    try
    setbookmark(bm, curtoele);

    except
    end;
    //writeln('<h2>',curtoele.head,'dosetbookmark',bm,'</h2><pre>',curtoele.xmlis,'</pre><hr/><pre>',x_bookmarks.xmlis,'</pre><hr/>');
    //x_bookmarks.subtags.add(curtoele);
    writeln('<h2>didsetbookmark',bm,'</h2><pre>',x_bookmarks.xmlis,'</pre><hr/>');
   // writeln('<h2>to:',bm,'!</h2><pre>',curtoele.parent.xmlis,'</pre><hr/>');
  except
    writeln('failedsetbooknmark');
  end;
end;

function txseus.c_break: boolean;
{D: breaks an apply-loop
  -doc: difficult to document.
}
begin
  break_state := br_break;
  //state_break := True;
end;

function txseus.c_continue: boolean;
{D: breaks the current template in an apply-loop
  -doc: difficult to document, skip
}
begin
  // writeln('contx');
  break_state := br_cont;
  //state_continue := True;
end;

function txseus.c_exit: boolean;
{D: breaks the apply-loop and current handler
  -doc: difficult to document, skip
}
begin
  break_state := br_exit;
  //state_exit := True;
end;

function txseus.c_halt: boolean;
{D: breaks the apply-loop current handler and the whole xseus-task
  -doc: difficult to document, skip
}
begin
  break_state := br_halt;
  //state_halt := True;
  //_h1('halting');
 // halt
end;

function txseus.c_restart: boolean;
{D: restarts server .. probably not a good idea
  -doc: probably
}
begin
  logwrite('RESTART');
  //§§  restartserver;
  //_h1('halting');
end;

function txseus.c_resetini: boolean;
{D: reads the config-file anew .. needs thinking ..
 allowing programmatic changes to config is probably a security risk.
 If they are not allowed, rereading is not needed /could restart the server manulally as well
}
var
  ot: txseus;
begin
  writeln('OLDINI<pre> ');
  writeln(g_xseuscfg.config.xmlis);
  //xseuscfg.free;
  //ot := thrxs;
  //thrxs := nil;
  //xseuscfg:=txseuscfg.create;
  g_xseuscfg.config.Free;
  g_xseuscfg.get(g_inidir + 'xseus.xsi');
  //thrxs := ot;
  writeln(g_xseuscfg.config.xmlis);
  writeln('NEWINI</pre> ');

  //_h1('halting');
end;

function txseus.c_setxseusapppath: boolean;
{D: adds paths to xseus-configuration.
 probably some security concerns here. Who has the right to add paths, and where
}
var
  i: integer;
  apt, subt: ttag;
  ind: string;
begin
  apt := g_xseuscfg.config.subt('apppaths');
  if apt.subt('map[@ns=''' + curbyele.att('ns') + ''']') <> nil then
    writeln('<h2>Not allowed to override old app-paths' + curbyele.att('ns'), '</h2>')
  else
  begin
    subt := apt.addsubtag('map', '');
    subt.addatt('path=' + curbyele.att('path'));
    subt.addatt('ns=' + curbyele.att('ns'));
    g_xseuscfg.config.saveeletofile(g_inidir + '/xseus.xsi', True, '','  ', False,false);
  end;
end;

function txseus.c_setxseusurlpath: boolean;
{D: adds paths to xseus-configuration.
 probably some security concerns here. Who has the right to add paths, and where
}
var
  i: integer;
  apt, subt: ttag;
  ind: string;
begin
  apt := g_xseuscfg.config.subt('urlpaths');
  if apt.subt('map[@url=''' + curbyele.att('url') + ''']') <> nil then
    writeln('<h2>Not allowed to override old url-mappings' +
      curbyele.att('url'), '</h2>')
  else
  begin
    subt := ttag.create;
    subt.vari:='map';
    apt.subtags.insert(0,subt);
    subt.addatt('path=' + curbyele.att('path'));
    subt.addatt('url=' + curbyele.att('url'));
    //apt.subtags.move(apt.subtags.Count - 1, 0);
    writeln('<pre>' + apt.xmlis +
      '</pre>!!!'+g_inidir+'/xseus.xsi');
   // apt.subtags.move(apt.subtags.Count - 1, 0);
    writeln('<pre>' + g_xseuscfg.config.xmlis +
      '</pre>!!!'+g_inidir+'/xseus.xsi');

     g_xseuscfg.config.saveeletofile(g_inidir + '/xseus.xsi', True, '','  ', False,false);
  end;
end;

function txseus.c_copyelement: boolean;
begin
 c_copy;

end;

function txseus.c_copy: boolean;
{D:
 -usage:common
}
var
  atag: ttag;
  i: integer;
  ctag: ttag;
  aps: string;
begin
  try
    if CurBYEle = nil then
      exit;


    if curfromele=nil then
     writeln('<li>xxxCOPY:nil');
    //else writeln('<li>nultocopy');
    //try writeln(curfromele.xmlis,'???'); except writeln('<li>failcopyfrom');end;
    //  if CurBYEle.att('select')<>'' then
    begin
      try
        {if CurBYEle.att('select') <> '' then
        begin
          atag := sta-select(CurBYEle.att('select'), CurFromEle);
          //atag:=state.selroot(CurBYEle.att('select'),CurFromEle,aps,false);
          //atag:=atag.subt(aps);
        end
        else}
        atag := CurFromEle;
      except
        writeln('failder find copyelement');
        raise;
      end;
      if atag = CurBYEle then
        exit;
      if atag = nil then
        exit;
      if CurBYEle.att('sub') = 'true' then
      begin
        if atag.subtags = nil then
          exit;

        for i := 0 to atag.subtags.Count - 1 do
        begin
          try
            resUadd(ttag(atag.subtags[i]).copytag);
          except
            writeln('<li>faild restagadd');
          end;
        end;

      end
      else
        try
          if CurToEle.subtags <> nil then
          begin
            ctag := atag.copytag;
            //CurToEle.subtags.add(ctag);
            resuadd(ctag);
            ctag.parent := CurToEle;
          end
          else
            writeln('<li>nostateresta');
          //TÄMÄ KAATAA RUMASTI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        except
          writeln('failder addres copyelement');
          raise;
        end;
    end;
  except
    writeln('<li>failder copyelement');
    raise;
  end;
end;

function txseus.c_apply: boolean;
{D:
 -usage:key command
 -doc: difficult, but the handling of special attributes (times, maxtimes, etc)
  may make sense if you  dig out the attributes from source and guess what they do
}

begin
  applyall;
end;

function txseus.c_copyapply: boolean;
{D: copies current selected element, and applys templates to its subtags
  -usage: quite common
}
var
  newtag, oldres: ttag;
begin
  try
    newtag := ttag.Create;
    if CurBYEle.att('rename') <> '' then
      newtag.vari := CurBYEle.att('rename')
    else
      newtag.vari := CurFromEle.vari;
    //newtag.attributesClear;
    if CurBYEle.att('substitute') = 'no' then
      newtag.vali := CurFromEle.vali
    else
      newtag.vali := CurFromEle.vali;
    if CurBYEle.att(ns + 'attributes') <> 'mine' then
      newtag.attributescopyfrom(CurFromEle);
    // newtag.attributes.addstrings(CurFromEle.attributes);

    try
      //logwrite('copyappl:'+curfromele.vari+' '+inttostr(curfromele.subtags.count));
      oldres := CurToEle;
      resuadd(newtag); //-
      CurToEle := newtag;    //ä
      if curfromele.subtags.count>0 then
      Result := applyall;
    except
      writeln('faikledapplyall');
    end;
    CurToEle := oldres;
  except
    writeln('failed copyapply');
  end;
end;



function txseus.c_element: boolean;
{D:
 -usage: quite common
}
var
  newtag, oldto: ttag;//, acom, seltag: ttag;

  i: integer;
  ast: string;
begin
  newtag := ttag.Create;
  //if curbyele.att(ns + 'name') = '' then
    if curbyele.att('name') = '' then
    newtag.vari := CurFromEle.vari
  else
  //newtag.vari := curbyele.att(ns + 'name');
    newtag.vari := curbyele.att('name');
  newtag.vali := curbyele.vali;
  if curbyele.att('attributes') = 'copy' then
    //if acom.att(ns+'attributes')<>'nocopy' then
  begin
    newtag.attributescopyfrom(CurFromEle);
  end;
  if curbyele.att('attributes') <> 'nomine' then
  begin
    //  newtag.attributescopy(curbyle);
    for i := 0 to curbyele.attributesCount - 1 do
    begin
      ast := curbyele.getattributes[i];
      if pos(ns, ast) <> 1 then
        if (cut_ls(ast)<>'name') and (cut_ls(ast)<>'attributes') then
        newtag.setatt(cut_ls(ast), cut_rs(ast));
    end;
  end;
    curtoele.subtagsadd(newtag);
    oldto := curtoele;
    CurToEle := newtag;
  if curbyele.subtags.Count > 0 then
    dosubelements;
    CurToEle := oldto;
  end;

function txseus.c_head: boolean;
{D:
 -usage: quite common
}
var
  newtag, oldto: ttag;//, acom, seltag: ttag;

  i: integer;
  ast: string;
begin
  //writeln('<li>DOHEAD: '+curbyele.xmlis);
  newtag := ttag.Create;
  //if curbyele.att(ns + 'name') = '' then
    if curbyele.att('name') = '' then
    newtag.vari := CurFromEle.vari
  else
    newtag.vari := curbyele.att('name');
    //newtag.vari := curbyele.att(ns + 'name');
    newtag.vali := curfromele.vali;
  ;
  //if curbyele.att(ns + 'attributes') = 'copy' then
    //if acom.att(ns+'attributes')<>'nocopy' then
    newtag.attributescopyfrom(CurFromEle);
    curtoele.subtagsadd(newtag);
    oldto := curtoele;
    CurToEle := newtag;
  if curbyele.subtags.Count > 0 then
    dosubelements;
   //writeln('<li>DIDHEAD: '+curtoele.xmlis);
    CurToEle := oldto;
  end;


function txseus.getcurrenthandler(msg: string): ttag;
var
  incfile: string;
  inctag: ttag;
  i: integer;
begin
  try
    Result := nil;
    inctag := x_handlers.SUBt(msg);
    for i := 0 to x_handlers.subtags.Count - 1 do
      if ttag(x_handlers.subtags[i]).att('name') = msg then
      begin
        inctag := x_handlers.SUBtags[i];
        break;
      end;
    Result := inctag.copytag;
  except
    LOGwrite('no handler: |' + msg+x_handlers.xmlis);
    writeln('<li>No such handler "',msg,'"');
    //listwrite(x_handlers);
  end;
  exit;
  if Result <> nil then
    if Result.att('file') <> '' then  //data pointer to external helper-file
    begin
      incfile := _indirs(Result.att('file'), g_xseuscfg.apppaths);
      inctag := tagfromfile(incfile, nil);
      Result := inctag.SUBt('handler[@name eq ''' + msg + ''']').copytag;
    end;
end;



function _cleandir(xindir, xnodir, xindirs, xaddtoval, st, outdir: string;
  dirs: ttag; testallow: boolean; xs: txseus): string;
begin
  //very strange.. for clening attributes of external commands
  //does not allow to require write permissions
  // to be rewritten. Not going to translate for linux
  if xindir = 'true' then
    st := _indir(st, outdir, xs, False);
  if xnodir = 'true' then
  begin
    st := StringReplace(st, '..', '', [rfreplaceall]);
    st := StringReplace(st, '\', '', [rfreplaceall]);
    st := StringReplace(st, '|', '', [rfreplaceall]);
    st := StringReplace(st, '>', '', [rfreplaceall]);
  end;
  if xindirs = 'true' then
  begin
    try
      st := _indirs(st, dirs);
    except
      writeln('cleandir faild');
    end;
  end;
  if xaddtoval <> '' then
    st := xaddtoval + st;
  Result := st;
end;


function txseus.externalcmd: boolean;
{D: this is where xseus started: converting xml-commands defined in ini-files and
   called in xse-files to external windows commands.
  -usage: not very common, but still very powerfull
  -plan: converting this to work under linux is a challange
}
var
  j: integer;
  newcom, aput, thecom, acom, newtag: ttag;
  q, apust, apust2, newvari, newvali, thisatt: string;
var
  retcode: integer;

begin
  try
    try
      debug := True;
      acom := CurBYEle;
      Result := False;
      thecom := nil;
      newcom := ttag.Create;
      //writeln('<li>Try command:<pre>' + acom.xmlis + '</pre>_' +
      //  xseuscfg.xcommands.xmlis + '###' + IntToStr(xseuscfg.xcommands.subtags.Count));
      for j := 0 to g_xseuscfg.xcommands.subtags.Count - 1 do
      begin
        if ttag(g_xseuscfg.xcommands.subtags[j]).att('name') = acom.vari then
        begin
          thecom := g_xseuscfg.xcommands.subtags[j];
          writeln('found cmd: <pre>' + thecom.xmlis + '</pre>');
          if thecom = nil then
            if debug then
              writeln('found nothing');
          break;
        end;
      end;
      if thecom = nil then
      begin
        Result := False;
        exit;
      end;
      if debug then
        writeln('try cmd: <pre>' + thecom.xmlis + '</pre>');
      //if thecom.attributes.indexofname('call') >= 0 then
      if thecom.att('call') <> '' then
        newcom.vari := thecom.att('call')
      else
        newcom.vari := thecom.att('name');
      if debug then
        writeln('<h1>Call' + thecom.att('call') + 'xx' + newcom.vari + '</h1>');

      if thecom.att('nowait') = 'true' then
        newcom.setatt('nowait', 'true');
      for j := 0 to thecom.subtags.Count - 1 do
      begin
        aput := thecom.subtags[j];
        apust := aput.att('name');
        q := '';
        if aput.att('quote') <> '' then
          q := '"';
        if aput.vari = 'oboption' then
        begin
          if aput.att('call') <> '' then
            newvari := aput.att('call')
          else
            newvari := apust;
          newvali := aput.att('sep') + q + aput.att('value') + q;
          newcom.setatt(newvari, newvali);
        end
        else
        if acom.att(apust) <> '' then
        begin
          try
            if aput.att('quote') <> '' then
              q := '"'
            else
              q := '';
            if aput.att('call') <> '' then
              newvari := aput.att('call')
            else
              newvari := apust;
            newvali := aput.att('sep') + q + _cleandir(
              aput.att('indir'), aput.att('nodir'), aput.att('indirs'),
              aput.att('addtoval'), acom.att(apust), x_outdir,
              g_xseuscfg.subt('apppaths'), False, self) + q;
            if aput.att('redir') = 'true' then
              newvali := ' > ' + newvali;
            newcom.setatt(newvari, newvali);
          except
            Result := False;
            writeln('external cmd approve failed');
            exit;
          end;
        end;
      end;
      if debug then
      begin
        _h1('approve acom' + acom.xmlis);
        listwrite(acom);
        _h1('newcom<pre>' + newcom.xmlis + '</pre>');
        listwrite(newcom);
      end;
      Result := True;
    except
      writeln('not approved');
      exit;
    end;


    try
      apust := newcom.vari;
      for j := 0 to newcom.attributesCount - 1 do
      begin
        thisatt := newcom.getattributes[j];
        if pos('nowait', thisatt) <> 1 then
          if pos(ns + 'element', thisatt) <> 1 then
            if pos('tmppipe', thisatt) <> 1 then
              //if newcom.attributes.names[j] <> ns + 'element' then
              //  if newcom.attributes.names[j] <> ns + 'tmppipe' then
              apust := apust + cut_ls(thisatt) + fullcut_rs(thisatt);
      end;
      if newcom.att('nowait') = 'true' then
      begin
        retcode := WinExecAndWait32(apust, False);
      end
      else
      if newcom.att(ns + 'tmppipe') = 'true' then
      begin
        apust := apust + (' > "' + x_outdir + x_object.subs('random_id') + '.tmp');
        //ccall.vars.values['random_string8'] + '.tmp"');
      end;
      writeln('<!--TMP:' + apust + '-->');
      retcode := WinExecAndWait32(apust, True);
      if newcom.att(ns + 'tmppipe') = 'true' then
      begin
        _readfile(x_outdir + x_object.subs('random_id') + '.tmp', apust2);
        //ccall.vars.values['random_string8'] + '.tmp', apust2);
        newtag := ttag.Create;
        newtag.vari := newcom.att(ns + 'element');
        newtag.vali := apust2;
        resuadd(newtag);
        //((state.resta.addsubtag(newcom.att(ns+'element'),apust2);
      end;
      if debug then
        writeln('ExecuteD ' + apust);
      //x_svars.add('errorlevel', IntToStr(retcode));
      x_svars.values['errorlevel']:= IntToStr(retcode);
    except
      writeln('Command' + apust + ' not executeD');
    end;
  finally
    newcom.killtree;
  end;
end;




function _match(cal: string; ats: TStringList): string;
var
  parts: TStringList;
  i: integer;
begin
  Result := '';
  try
    parts := TStringList.Create;
    _split(cal, '@', parts);
    for i := 0 to parts.Count - 1 do
    begin
      if i mod 2 = 1 then
        parts[i] := ats.values[parts[i]];
    end;
    for i := 0 to parts.Count - 1 do
      Result := Result + parts[i];
  finally
    parts.Clear;
    parts.Free;
  end;
end;


procedure _expandfunction(xconfig, acom, xcom: ttag; cur: integer);
{D: xseus-defined functions. Executed when reading xse-file, makes the functions
   available to handlers
  -usage: never really used so far (not properly tested), but could be powerfull
}
var
  i, j, k: integer;
  newcom, FTAG: ttag;
  atst, fun: string;
begin
  try
    fun := acom.att('func');
    for i := 0 to xconfig.subtags.Count - 1 do
    begin
      ftag := ttag(xconfig.subtags[i]);
      if (ftag.vari = 'function') and (ftag.att('name') = fun) then
      begin
        for j := ftag.subtags.Count - 1 downto 0 do
        begin
          try
            newcom := ttag.Create;
            newcom.vari := ttag(ftag.subtags[j]).att('name');
            for k := 0 to ttag(ftag.subtags[j]).attributesCount - 1 do
            begin
              atst := ttag(ftag.subtags[j]).getattributes[k];
              newcom.setatt(cut_ls(atst), _match(
                cut_rs(atst), acom.getattributes));
            end;
            xcom.subtags.insert(cur, newcom);
          except
            writeln('FAILed to expand function');
          end;
        end;
      end;
    end;
  except
    writeln('FAILed to expand a function');
  end;
end;

procedure _expandfunctions(xcom, xconfig: ttag);
var
  stag: ttag;
  cur: integer;
  fun: string;
begin
  try
    if xcom = nil then
      _h1('Nothing to expand');
    cur := xcom.subtags.Count;
    while cur > 0 do
    begin
      try
        Dec(cur);
        stag := xcom.subtags[cur];
        if stag.att('func') = '' then
          continue;
        _expandfunction(xconfig, stag, xcom, cur);
      except
        writeln('failed one');
        raise;
      end;
    end;
  except
    writeln('FAILed to expand functions');
  end;

end;


{procedure _cookieauth(var sestag:ttag;var sesdir,sesurl:string;xseus:txseus;cookies:tstringlist;var sesfile:string);
var
sess:string;ocrit:boolean;
begin
  if sestag=nil then exit;
   sess:=cookies.values['xseus_session'];
   if xseus.x_newcookie<>'' then
     sess:=xseus.x_newcookie;
   if sess='' then sess:=_randomstring;
      sesfile:=sesdir+g_ds+sess+'.htme';

   //sesurl:=copy(sesfile,
   //  length(xseus.x_cgi.subs('document_root'))+1,
   //  length(sesfile));
   //   StringReplace(sesurl,'\','/',[rfreplaceall]);

   if fileexists(sesfile) then
   begin
   try
     //tagfromfile(
     ase:=sestag.fromfile(sesfile,nil);
     if (ase<>nil) and (ase.subtags.count>0) then
     begin
       ase:=ase.subtags[0];
       ase.att('time']:=timetostr(now);
       ocrit:=xseus.critical;
       xseus.critical:=true;
      try
       ase.savetofile(sesfile,true,'',false);
    except writeln('problems saving session '+sesfile);end;
       xseus.critical:=ocrit;
       exit;
     end;
    except writeln('problems with session '+sesfile);end;
   end;
   begin
     if ase=nil then ase:=ttag.create;
     ase.vari:='session';
     ase.attributes.add('class=system:login');
     ase.attributes.add('dir='+sesdir);
     if xseus.x_newcookie<>'' then
     ase.attributes.add('id='+xseus.x_newcookie)
     else
       ase.attributes.add('id='+cookies.values['xseus_session']);

     ase.attributes.add('time='+timetostr(now));
     ase.attributes.add('ip='+xseus.x_cgi.subs('REMOTE_ADDR'));
     ase.attributes.add('new=true');
     end;

  _com('session:'+sesfile);
   exit;
 end;
 }

function txseus.substitutex(st: string): string;
begin
  Result := parsexse(st, self);
end;



{function txseus.substisubs: ttag;
  //old version of evalsubtags
var
  k: integer;
  ok: boolean;
  acom: ttag;
begin
  try
    acom := CurBYEle;
    if acom = nil then
      exit;
    Result := acom.copytag;
    if acom.subtags = nil then
      exit;
    dosubelements;
    for k := 0 to Result.subtags.Count - 1 do
      ttag(Result.subtags[k]).parent := Result;

  except
    writeln('failed to substisubs');
  end;

end;
}
//procedure _sendmail(acom,xml:ttag);
//begin
// _writefile('c:\bats\tmp.msg',acom.att('msg'));
//     WinExecAndWait32('cmd /c c:\bats\'+acom.att('bat')+' c:\bats\tmp.msg' ,false);
//_h1('mail sent');
//end;




function _getobjectdata(ifile, iurl, host, handler: string; ol, acom: ttag): ttag;
var
  xtmp: ttag;
  st: string;
  i: integer;
begin
  try
    xtmp := ttag.Create;
    xtmp.vari := 'object';
    st := extractfilename(ifile);
    xtmp.setatt('name', copy(st, 1, length(st) - length(extractfileext(st))));
    //xtmp.setatt('fullname', ifile);
    xtmp.setatt('path', extractfilepath(ifile));
    xtmp.setatt('file', st);
    //xtmp.setatt('dir', extractfilepath(ifile));
    // xtmp.setatt('ext', extractfileext(st));
    //xtmp.setatt('filenoext', xtmp.att('dir') + xtmp.att('name'));
    xtmp.setatt('random_id', _randomstring);
  except
    writeln('************************nogo');
  end;
  if iurl = '' then
    if acom <> nil then
    begin
      iurl := acom.att('url');
    end;
  if iurl = '' then
    if ol <> nil then
    begin
      iurl := ol.att('urldir') + xtmp.att('name') + xtmp.att('ext');
    end;
  xtmp.setatt('url', iurl);
  xtmp.setatt('urlpath', extractfilepath(iurl));
  xtmp.setatt('host', host);
  xtmp.setatt('handler', handler);
 // i := length(iurl);
  //while (i > 1) and (iurl[i] <> '/') do
  //  i := i - 1;
  //xtmp.setatt('urldir', copy(iurl, 1, i));

  if ol <> nil then
    xtmp.subtagsadd(ol);
  Result := xtmp;
end;




procedure txseus.setvals(ol: txseus);
var
  handlern, handlersn, objn, xodir, oodir, url: string;
  atts: TStringList;
  i, k, skipped: integer;
  newob, ok: boolean;
  ct, acom: ttag;

begin
  try
    //     logwrite('change from dir '+def_dir);
    _debug := True;
    x_called := True;
    acom := CurBYEle;
    newob := False;
    atts := TStringList.Create;
    try
      //x_cgi := ol.x_cgi;
      ns := ol.ns;
      x_session := ol.x_session;

      //hashed?      x_svars.addstrings(ol.x_svars);
      //x_bookmarks.addstrings(ol.x_bookmarks);
      ol.x_bookmarks := x_bookmarks.copytag;
      handlern := acom.att('handler');
      if handlern = '' then
        handlern := 'open';
      x_data := ttag.Create;
      // x_handlers:=ttag.create;
      url := acom.att('url');
      if acom.att('object') <> '' then
        objn := (acom.att('object'))
      else
      begin
        //objn := _getpath(_mapurltofile(url, xseuscfg.subt('urlpaths')), '\');
        objn := _mapurltofile(url, g_xseuscfg.subt('urlpaths'));
        //writeln(objn,':=_getpath(',_mapurltofile(url,x_commands.subt('mappings')),url,'<hr/>');
      end;
      try
        if url = '' then
          url := _mapfiletourl(objn, g_xseuscfg.subt('mappings'));
      except
        writeln('<li>mapfile error url:' + url + ' file: ' + objn);
        listwrite(g_xseuscfg.subt('urlpaths'));
      end;
    except
      writeln('<!--could not sel vals for callobject:' + objn + '-->');
    end;
    writeln('<li> set vals for callobject:' + objn + '</li>');
    try
      if _debug then
        _h1('objn2:' + objn);
      if pos('xse:', objn) > 0 then
        objn := ol.substitutex(objn);
      writeln('<li>ns:' + ns + 'OBOBOBOBO:' + objn + 'IN:', x_objectlist.Text, '!</li>');
      if objn <> '' then
      begin
        if (x_objectlist.indexof(objn) < 0) or (acom.att('reload') = 'true') then
        begin
          //--if FileExistsUTF8(objn) { *Converted from FileExists*  } then
          if FileExists(objn) { *Converted from FileExists*  } then
          begin
            logwrite('changed to dir ' + objn);
            //x_data.fromfile(objn, nil);
            x_data := tagfromfile(objn, nil);
            x_outdir := extractfiledir(objn);
            //writeln('<h1>obobobfromfile',objn,'</h1>'+x_data.xmlis+'<hr/><hr/>');

            //ol.def_dir;
            //--SetCurrentDirUTF8(def_dir); { *Converted from SetCurrentDir*  }
            SetCurrentDir(x_outdir); { *Converted from SetCurrentDir*  }
          end
          else
          if acom.att('create') <> '' then
          begin
            objn := _indir(objn, ol.xml.subs('object/@dir'), self, True);
            newob := True;
          end
          else if acom.att('uptree') = 'true' then
          begin
            try
              x_objectdir := extractfiledir(objn);
              skipped := length(objn) - length(x_objectdir);
              objn := extractfilename(objn);
              i := 0;
              while (objn <> '') and (i < 10) do
              begin
                oodir := x_objectdir;
                x_objectdir := extractfiledir(x_objectdir);
                skipped := skipped + length(oodir) - length(x_objectdir);
                i := i + 1;
                _com(x_objectdir + objn);
                //--if FileExistsUTF8(odir+g_ds+objn) { *Converted from FileExists*  } then
                if FileExists(x_objectdir + g_ds + objn)
                { *Converted from FileExists*  } then
                begin
                  url := copy(url, 1, length(url) - skipped) + '/' + objn;
                  objn := x_objectdir + g_ds + objn;
                  //x_data.fromfile(objn, nil);
                  x_data := tagfromfile(objn, nil);
                  break;
                end;
              end;
            except
              writeln('<!--UPTREE fail' + x_objectdir + g_ds + objn + '-->');
            end;
          end;
          //if x_data.subtags.Count > 0 then
          //  x_data := x_data.subtags[0];
        end
        else
        begin
          if _debug then
            writeln('<h1>obobob cached', objn, '</h1>');

          x_data := ttag(x_objectlist.objects[x_objectlist.indexof(objn)]);
        end;
      end
      else
      begin //no object?
        if _debug then
          writeln('CCCCCCCCCCCCCCCC create obj:' + objn);
      end;
    except
      if acom.att('fail') <> 'ok' then
        writeln('<li>could not get object for callobject:/' + objn + '/');
      exit;
    end;
    try
      if acom.att('class') <> '' then
        handlersn := _indirs(acom.att('class'), g_xseuscfg.apppaths)
      else
        handlersn := _indirs(x_data.att('class'), g_xseuscfg.apppaths);
      x_commandfile := handlersn;
      x_handlers := getxse(handlersn, x_elemlist);
      //writeln('aaaaaaaaxxxxxxx' + handlersn + '!');
      //  listwrite(x_handlers);

    except
      if acom.att('fail') <> 'ok' then
      begin
        writeln('<li>Could not get handlers for callobject:' + handlersn + '##');
        listwrite(x_handlers);
        listwrite(acom);
      end
      else
        exit
    end;
    if _debug then
      writeln('<hr/>', x_handlers.xmlis, '<hr/>');
    //x_handler:=x_handlers.SUBt('class/handler[@name='+handlern+']');
    //writeln('ssssssss');
    x_handlername := handlern;
    x_myhandler := getcurrenthandler(handlern);

    if x_myhandler = nil then
    begin
      if acom.att('fail') <> 'ok' then
      begin
        writeln('<li>Nul handler:' + handlern + ': in handlers=' + handlersn + '?');
        writeln(' o:', objn, '</li>');
        //listwrite(acom);
        //miksi? x_handler:=x_handlers.subtags[0];
        exit;
      end
      else
        exit;
    end;

    try
      if acom.subtags.Count > 0 then
      begin
        x_form := ttag.Create;
        X_FORM.VARI := 'form';
        CurToEle := x_form;
        OL.dosubelements;
        for k := 0 to x_form.subtags.Count - 1 do
          ttag(x_form.subtags[k]).parent := x_form;
        //LISTWRITE(CurToEle);

      end
      else
      if acom.att('form') <> '' then
      begin
        x_form := ttag.Create;
        X_FORM.VARI := 'form';
        x_form.subtagsadd(ol.xml.subt(acom.att('form')).copytag);
        CurToEle := x_form;

      end
      else
        x_form := ol.x_form.copytag;
      //for k := 0 to acom.attributes.Count - 1 do
      //x_form.attributes.addstrings(acom.attributes);
      x_form.attributescopyfrom(acom);
      //xml.subtags.add(x_form);
    except
      writeln('<li>could not get form for object');
    end;
    atts.Clear;
    x_objectfile := objn;
    if x_objectfile = '' then
      x_objectfile := ol.x_objectfile;
    x_outdir := extractfilepath(x_objectfile);
    x_objectdir := x_outdir;
    xml.subtagsadd(x_data);
    //parse later?
    xml.subtagsadd(x_form);
    //xml.subtagsadd(x_cgi);
    xml.subtags.add(x_myhandler);
    //xml.subtags.add(xx_session);
    //xx_session.parent := xml;
    if x_objectfile <> '' then
      x_object := _getobjectdata(x_objectfile, url, x_host,
        x_handlername, ol.xml.subt('object'), acom)
    else
      x_object := (ol.xml.subt('object'));
    xml.subtagsadd(x_object);

    if newob then
    begin
      x_form.setatt('create', objn);
      //ct:= x_handlers.subt('/class/handler[@name='+'create'+']');
      ct := getcurrenthandler('create');
      dosubelements;
      // docoms2(ct);
      //docoms2(ct,nil);
    end;

  finally
    atts.Free;
  end;

  //writeln('<li>callobject3 '+objn+' class='+handlersn+' handler='+handlern);
end;



function txseus.Execute(ns:string): boolean;
var
  retcode: dword;
  routine: tmethod;
  exec: texec;
  acom: ttag;
  cmd: string;
begin
  try
  // writeln('*');
  // writeln('<li>exexc:',curfromele.vari,'/',curbyele.vari);
    Result := False;
    cmd := trim(CurBYEle.vari);
    if pos(ns, cmd) = 1 then
      cmd := copy(cmd, length(ns)+1, 999999);
    routine.Data := pointer(self);
    routine.code := self.methodaddress('c_' + cmd);
    if not assigned(routine.code) then
    begin
      Result := False;
       writeln('<li>Failed to execute:!',cmd,'!');

      // state.did:=false;
    end
    else
    begin
      Result := True;
      exec := texec(routine);
      Result := exec;
      //state.did:=true;
      //Result := True;
    end;
  except
    writeln('<li>faill' + acom.vari,'!!!');
    listwrite(acom);
  end;
    //fwriteln('/didexexc:',curbyele.vari);

end;




//var apt:ttag;msg:string;

{procedure _getdata(var xd: ttag; ifile: string);
begin
  xd.fromfile(ifile, nil);
  xd := xd.subtags[0];
end;
}
procedure txseus.initxmlinput(var xmlrpc: boolean; var soapcall: string);
var
  apust: string;
begin
  writeln('<h2>xmlinput currently not implemented</h2>');
  // ccall.vars.savetofile('c:\temp\xformi.tmp');
{  apust := ccall.vars.values['form_xml'];
  while (length(apust) > 1) and (apust[1] <> '<') and (apust[2] <> '?') do
    Delete(apust, 1, 1);
  x_form := tagparse(apust, False, True);
  //x_form.parse(apust, False, True);
  // x_form.savetofile('c:\temp\call.tmp',true,'',false);
  // ccall.vars.savetofile('c:\temp\acall.tmp');
  x_form.vari := 'form';
  if ccall.vars.values['HTTP_SOAPAction'] <> '' then
  begin
    //x_form.savetofile('c:\temp\soap.tmp', True, '', False);
    soapcall := ttag(x_form.subtags[0]).vari;
    x_form := ttag(x_form.subtags[0]).subtags[0];
    x_form.addsubtag('handle', ccall.vars.values['HTTP_SOAPAction']);
    x_form.vari := 'form';
    writeln('Content-type: text/xml' + crlf + crlf);
    writeln(
      '<?xml version="1.0"?>' + crlf + '<SOAP-ENV:Envelope ' +
      'SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/1999/XMLSchema" ' + ' xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance">' + crlf + '<SOAP-ENV:Body>' + crlf + '<' + ttag(x_form.subtags[0]).vari + 'Response xmlns:m="http://www.soapware.org/">' + crlf);
    httpinited := True;

  end
  else
  begin
    try
      httpinited := True;
      //writeln('Content-type: text/xml'+crlf+crlf);
      x_handlername := ttag(x_form.subtags[0]).vari;
      x_form.addsubtag('handle', x_handlername);
      xmlrpc := True;
      soapcall := x_handlername;
      x_form.saveeletofile('xmlrpc.tmp', True, '', False);
      //       assign(output,'nul');
    except
      x_cgi.saveeletofile('xmlform.err', False, '', False);
    end;
  end;

end;
  }
end;

procedure txseus.readhtme;
var
  //dosaved: boolean;
  ext: string;
  i: integer;
begin
  try
    ext := extractfileext(x_objectfile);
    x_outdir := extractfilepath(x_objectfile);
    SetCurrentDir(x_outdir); { *Converted from SetCurrentDir*  }
    //dosaved := True;
    {if ext = '.htme' then
      xmlformat := 'xml'
    else
      xmlformat := 'ind';
    //SetCurrentDirUTF8(def_dir); { *Converted from SetCurrentDir*
    if xmlformat = 'ind' then
    //x_data.fromfileind(ifile)
    //x_data:=tagfromfileind(ifile)
    else
      // x_data.fromfile(ifile, nil);
      //x_data := x_data.subtags[0];
      logwrite('GETDATA ');
    }
    x_data := tagfromfile(x_objectfile, nil);
    //  listwrite(x_data);
    //logwrite('GOTDATA ' + X_DATA.XMLIS);
    //logwrite('CLASS ' + X_DATA.att('class'));

    x_objectdir := x_outdir;
  except
    writeln('<h1>failed to initialize:' + x_objectfile + '</h1>');
  end;
end;

function txseus.readxsi(cname,handler: string):boolean;
var   //handlersn: string;
  i: integer;

begin
  try
    result:=false;
   // logwrite('READXSI FOR:' + cname+'/read');

    //handlersn := _indirs(x_data.att('class'), xseuscfg.dirs);
    x_commanddir := extractfilepath(cname);
    x_handlers := getxse(cname, x_elemlist);
    //logwrite('READXSI:' + x_handlers.xmlis);
    if ttag(x_handlers.subtags[0]).att('xseus-version') = '1' then
    begin
      inihead := '';
      inibodyst := '';
      inibodyend := '';
    end;
  except
    logwrite('-failed to initialize xsi-file:'+cname);
    raise;
    //writeln('<h2>looked in:"', han, '"</h2>');
    //writeln('<h1>failed to find commands for htmi:',
    //  x_objectfile, ' class "', x_data.att('class'), '", pointing to:',
    //  han, '!</h1>');
    //listwrite(x_data.subt());
    //writeln('<li>handlers:', han);
    //writeln('<li>class:', x_data.att('class'), ' from dirs:<pre>',
    // xseuscfg.dirs.xmlis, '</pre>');
    //writeln('<li>xdirs:');
    //listwrite(x_dirs);
    //writeln('<li>xcoms:');
    //listwrite(x_commands);
  end;
  try

    if _debug then
    begin
      //_h1('class:' + handlersn);
      listwrite(x_handlers);
    end;
    //logwrite('hands:'+x_form.xmlis);
    if handler<>'' then x_handlername:=handler else
    x_handlername := x_form.subs('handler');
    //logwrite('hands:'+x_handlername+'!'+x_form.xmlis);
    if x_handlername = '' then
      x_handlername := x_form.subs('handle');

    if x_handlername = '' then
      x_handlername := 'open';
    try
      //  logwrite(x_handlers.listraw);

      //x_handler := gethandler(msg);
      //logwrite('try to get handler ' + x_handlername);
      x_myhandler := getcurrenthandler(x_handlername);
    except
      // logwrite('failed to get handler '+msg);raise;
      writeln('failed to get handler ' + x_handlername);
      raise;
    end;
    //logwrite('did get handler '+x_myhandler.xmlis);

    //x_handler:=X_handlers.SUBt('class/handler[@name='+msg+']');
    if (x_myhandler = nil) then // or (x_myhandler.subtags.Count = 0) then
    begin
      result:=false;
      writeln('<li>failed to find handler ' + x_handlername + ' in ' +
        cname + '</li><ul>');//<pre>' + x_handlers.xmlis+'</pre>');
      logwrite('<li>failed to find handler ' + x_handlername + ' in ' + cname + '</li>');
      //if x_handlers.subtags[0] <> nil then
        //for i:=0 to ttag(x_handlers.subtags[0]).subtags.count-1 do
        //logwrite('--'+ttag(ttag(x_handlers.subtags[0]).subtags[i]).att('name'));
        for i := 0 to x_handlers.subtags.Count - 1 do
          writeln('<li>',ttag(x_handlers.subtags[i]).head);
        writeln('</ul>')
      //listwrite(x_handlers);
    end else result:=true;
  except
    writeln('<h1>failed readclass for:' + x_object.subs('url') + '</h1>');
  end;

  //logwrite('donereadhtme');
end;

procedure _getcomdirs(var outdir, commanddir: string; xform, xconfig: ttag);
begin
  OUTDIR := XFORM.subs('outdir');
  try
    commanddir := _indirs(xform.subs('commanddir'),
      ttag(xconfig.subtags[0]).subt('apppaths'));
  except
    writeln('<h1>FAILEd to subst</h1>' + commanddir);
  end;
  _com('commanddir: ' + commanddir + 'outdir: ' + OUTDIR);
  _com('COMMANDS FROM ' + commanddir + ' file:' + xform.subs('commands'));
  if commanddir = '' then
    commanddir := outdir;
  _com(' COMMANDS FROM ' + commanddir + xform.subs('commands'));
end;

{edure txseus.readfileform;
var
  commanddir, st: string;
begin
  writeln('cq:' + ccall.query + 'Loading form from file ' + ifile);
  //--if FileExistsUTF8(ccall.query) // *Converted from FileExists*   then
  //if FileExists(ccall.query) // *Converted from FileExists*   then
  begin
    writeln('<h1>read form</h1>');
    outdiri := extractfilepath(ccall.query);
    odir := outdiri;
    try
      //x_form.fromfile(ccall.query, nil);
      //x_form := x_form.subtags[0];
      x_form := tagfromfile(ccall.query, nil);
      //_getdata(x_data, x_form.subs('file'));
      x_myhandler := X_form.SUBt('call');

      x_myhandler.vari := 'commands';
      X_form := X_form.SUBt('form');
    except
      writeln('Could not read file');
      exit;
    end;
  end
  else
  begin
    writeln('<h1>read form</h1>');
    try
      _getcomdirs(outdiri, commanddir, x_form, xseuscfg.config);
      if x_form.subs('file') <> '' then
        // x_data.fromfile(x_form.subs('file'), nil);
        //x_data := x_data.subtags[0];
        x_data := tagfromfile(x_form.subs('file'), nil);
      try
        st := _indirs(x_data.att('class'), xseuscfg.dirs);
        //x_handlers.fromfile(st, nil);
        x_handlers := tagfromfile(st, nil);
      except
        writeln('<h1>zzzz failed to find commands:' + commanddir +
          x_data.att('class') + '</h1>');
        listwrite(x_data);
      end;
      //x_handler:=x_handlers.SUBt('class/handler[@name='+X_form.SUBs('handler')+']');
      x_myhandler := getcurrenthandler(X_form.SUBs('handler'));

    except
      writeln(st + '_<h1>FAILED to find commands</h1>' + commanddir +
        ' class/handler[@name eq ''' + X_form.SUBs('handle') + ''']');
      listwrite(x_form);
    end;
  end;
end;
}
function readparamstoform(params: TStringList): ttag;
var
  i, poseq: integer;
  vari, vali, ss: string;
  curtag, tt: ttag;
begin
  Result := ttag.Create;
  Result.vari := 'form';
  curtag := Result;
  //writeln('<h1>FORM</h1>');

  for i := 0 to params.Count - 1 do
  begin
    if params[i] = '' then
      continue;
    //logwrite('par:'+params[i]+'!');
    poseq := pos('=', params[i]);
    if poseq < 1 then
    begin
      tt := curtag.addsubtag('handler', params[i]);
      continue;

    end;
    vari := copy(params[i], 1, poseq - 1);
    //vali := _clean(copy(params[i], poseq + 1, 999999));
    vali := copy(params[i], poseq + 1, 999999);
    if vari = 'starttag' then
    begin
      curtag := curtag.addsubtag(vali, '');
    end
    else if vari = 'endtag' then
    begin
      if curtag.parent <> nil then
        curtag := curtag.parent;
    end
    else
    if pos('@', vari) = 1 then
    begin
      if curtag.subtags.Count = 0 then
        curtag.addatt(copy(vari, 2, length(vari)) + '=' + vali)
      else
        ttag(curtag.subtags[curtag.subtags.Count - 1]).addatt(
          copy(vari, 2, length(vari)) + '=' + vali);

    end
    else
    begin
      tt := curtag.addsubtag(vari, vali);
    end;
    //xres.addsubtag('atag',ss);

  end;
  //writeln('<h1>/FORM</h1>');
  //logwrite('FRM:'+result.xmlis+'!');
end;

procedure txseus.DOcontinue;
begin
  writeln('<h3>Continue error</h3>');
  curbyele:=ttag.create;
  curbyele.ADDsUbtag('xse:debug','');
  curbyele.ADDsUbtag('H1','now is {?now}');
  doSUBelements;
  //(CURBYLE);

end;

function txseus.init(url, host, protocol: string; session: ttag; ser: pointer): boolean;
  //form,uploads:tstringlist);
var principal:txseus;
  serv: tserving;
  posi,i: integer;
  apust:string;
begin
  //result:=true;  exit;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  try  //moved from create
    x_started := Tstarted.Create;
    x_stopped := Tstarted.Create;
    principal:=nil;
    x_called := False;
    x_cmdline := False;
    x_relation:=nil;
    x_elemlist := TList.Create;
    x_elemrefcount := TList.Create;
    //x_elemlist.free;
    //x_elemrefcount.free;
    x_databases:=tstringlist.create;
   // writeln('<li>eles:',x_elemlist=nil);
    // states := TList.Create;
    x_mylocks := TStringList.Create;
    curselectionset := nil;
    ns := 'xse:';
    debug := False;
    if principal = nil then
    begin
      // elems:=tlist.create;
      //states:=tlist.create;
      t_currentxseus := self;
    end
    else
    begin
      x_elemlist := principal.x_elemlist;
      //states := myxs.states;
    end;
    //LOGWRITE('XXX1');
    x_svars := TStringList.Create;
    x_times := ttimes.Create;
    //x_times.curxseus := self;
    x_OBJECTLIST := TStringList.Create;
    //x_svars := ThashStrings.Create;
    x_ids := ThashStrings.Create;
    //registertagowner(self, x_elemlist, x_elemrefcount);
    //    x_svars:TurboHashedStringList;
    //X_SVARS.SORTED:=TRUE;
    //x_svars.duplicates:=dupaccept;
    //x_svars := TurbohashedStringList.Create;
    x_bookmarks := ttag.Create;//.create;
    x_bookmarks.vari := 'xseus_bookmarks';
    //result:=true;EXIT;
    x_funcs := ttag.Create;
    //x_fORM := ttag.Create;
    //LOGWRITE('XXX2');
    x_funcs.vari := ns + 'functions';
    xml := ttag.Create;
    xml.parent := nil;
    //!! parse later x_form := ttag.Create;
    //!!  parse later x_data := ttag.Create;
    //x_cgi := ttag.Create;
    //x_cgi.vari := 'cgi';
    //LOGWRITE('XXX3');
    x_rights := ttag.Create;
    x_rights.vari := 'rights';
    //x_handlers:=ttag.create;
    //  handlerlist:=TSTRINGLIST.CREATE;
    //LOGWRITE('XXX4');

    inihttp := '';//'Content-type:text/html'+crlf+'Pragma: nocache'+crlf+crlf;
    //inidecl :=
    //  '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ENG" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
    //  + crlf;
    inidecl := '<!DOCTYPE html>'+crlf;// PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" ' +
    // 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' + crlf;
    //LOGWRITE('XXX5');
    inihtml := '<html>'+crlf;// xlmns="http://www.w3.org/1999/xhtml">';
    inihead := '<head>'+crlf+'<title>X-seus</title>'+crlf
      // +'<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />'
      + '</head>'+crlf;
    inibodyst := '<body>';
    inibodyend := crlf+'</body></html>';
    //LOGWRITE('XXX6');
    g_xseuscfg.logf := nil;
    //LOGWRITE('XXX7');

    //logwrite('initing:'+url+'!'+host);
    Result := False;
    serv := tserving(ser);
    x_cookie := serv.cookie;
    x_session := session;
    x_serving := serv;
    x_stream:=nil;
    randomize;
    x_form := readparamstoform(serv.params);




    if serv.xml then
    begin  //put parsed xml-data is params:
      x_form.subtags.add(tagparse(serv.postdata, False, True));
      //logwrite('form:<xmp>'+serv.params[0]+'</xmp>');
      //logwrite('xmlform:<xmp>'+x_form.xmlis+'</xmp>');
    end
    ;//else
    //logwrite('form:<xmp>'+x_form.xmlis+'</xmp>');
    //x_uploads:=tstringlist.create;
    //posi:=pos('?',url);
    //if posi<1 then x_url:=url else x_url:=copy(url,1,posi-1);
    x_url := extractdelimited(1, url, ['?', '&']);
    //logwrite('URL:'+x_url+'!!!'+xseuscfg.config.subt('urlpaths').xmlis);
    logwrite('URL:'+x_url+'!!!'+_mapfiletourl(url,g_xseuscfg.config.subt('urlpaths')));
    x_host := host;
    x_protocol := protocol;

    x_objectfile := _mapurltofile(x_url, g_xseuscfg.subt('urlpaths'));
    x_hmackey := g_xseuscfg.subs('hmackey');
    {$ifdef windows}
    x_url:=_gsub('/',g_pathseparator,x_url);
    x_objectfile:=_gsub('/',g_pathseparator,x_objectfile);
    {$endif}
    if not fileexists(x_objectfile) then
    begin
      writeln('<li>Fail: file', x_objectfile,' not found for url',x_url);
      writeln('<pre>', g_xseuscfg.subt('urlpaths').xmlis,'</pre>');

       exit;
    end;
    //params.addsubtag('url',uri);
    //params.addsubtag('file',_mapurltofile(uri,xseuscfg.subt('urlpaths')));
    //logwrite('calling file:'+x_objectfile);
    //read input files
    x_outdir := extractfilepath(x_objectfile);
    SetCurrentDir(x_outdir); { *Converted from SetCurrentDir*  }
    x_locked := g_locks.trylockfile(x_objectfile, x_mylocks);
   //x_locked:=false;
    htmlinited:=false;
    if (pos('.htme', x_objectfile) > 0) or
     (pos('.htmi', x_objectfile) > 0) then
    begin
      //readhtme;
      //outdiri := extractfilepath(x_objectfile);
      try
      x_data := tagfromfile(x_objectfile, nil);

      except
        logwrite('failed read/parse data:' + x_objectfile +'!!!');
      end;
      x_commandfile := _indirs(x_data.att('class'), g_xseuscfg.apppaths);
      //logwrite('calling class:'+x_commandfile);
      try
       //logwrite('read:'+x_data.att('class')+'ZZ'+X_DATA.XMLIS+'/X_DATA');
        if not(readxsi(x_commandfile,'')) then result:=false else result:=true;
        //logwrite('faireadxsi:'+x_myhandler.xmlis);
      except
        logwrite('no handlers in:' + x_objectfile + ' not found in ' +
         x_commandfile + '</li>');
     //   writeln('no handlers in:' + x_objectfile + ' not found in ' +
     //    x_data,.listxml + '</li>');
      end;
    end
    else
    if (pos('.xsi', x_objectfile) > 0) or
      (pos('.xse', x_objectfile) > 0) then
    begin
      x_commandfile:=x_objectfile;
      if not readxsi(x_objectfile,'') then result:=false else result:=true;
      //x_commands:=x_data;
      x_data := x_handlers.subt('data');
      x_handlers:=x_data.copytag;
      //LOGWRITE('DIDREADHTMR');
      //writeln('<li>handler:',x_myhandler.xmlis);
    end;
    if x_myhandler.att('lock') = '' then
    begin
      logwrite('freelock:' + x_objectfile);
      g_locks.freefile(x_objectfile, x_mylocks);
      x_locked := False;
    end
    else
    begin
      if x_locked then
        logwrite('keep lock')
      else
        logwrite('retry locking');
      if not x_locked then
        x_locked := g_locks.lockfile(x_objectfile, x_mylocks);
      if not x_locked then  //could not obtain a lock for this instance
      begin
        writeln('<h1>' + x_objectfile + ' is locked</h1>');
        exit;
      end;
    end;
    //apust:=x_data.att('class');
    //for i:=1 to length(apust) do if apust[i]=':' then break else x_classname:=x_classname+apust[i];
    //WRITELN('<h1>class: '+classname+'</h1>');
    xml.vari := 'xseus';
    xml.subtagsadd(x_data);
    xml.subtagsadd(x_form);
    //xml.subtagsadd(session);
    //xml.subtagsadd(x_cgi);
    //logwrite('xmlhan');
    //xml.subtags.add(x_myhandler);
    //logwrite('getob');
    x_object := _getobjectdata(x_objectfile, x_url, x_host, x_handlername, nil, nil);
    xml.subtagsadd(x_object);
    apust:=x_data.att('class');
    for i:=1 to length(apust) do if apust[i]=':' then break else x_classname:=x_classname+apust[i];
    x_object.setatt('app', x_classname);

    //logwrite('gotob'+x_object.xmlis);
    //!!!????    CurBYEle := x_myhandler.copytag;
        CurBYEle := x_myhandler;
    xml.subtagsadd(curbyele);
    //logwrite('3');
    //xml.subtags.add(x_handler);
    //x_templates := x_myhandler;
    curtemplates := nil;//curbyele;
    curtoele := nil;
    curfromele := xml;
    Result := True;
    //writeln('iniiniitED');
    //result:=auth_checkauth(self);

  except
    logwrite('failed to init xseus');
    //Result := True;
  end;
end;


procedure txseus.doit;
begin

end;

function txseus.c_sleep: boolean;
{D:
}
begin
  sleep(strtointdef(CurBYEle.att('time'), 0));
end;


function txseus.c_critical: boolean;
{D: currently not used. Marks sections of code invulnerable to thred-killers (that try to detect
 runaway processess / infinite loops
  -plan: will be re-implemented
}
begin
  writeln('!<!--critical-->');
  x_critical := True;
end;


function txseus.c_unlimited: boolean;
{D: see critical. Stronger invulnerabilty, close to immortality
}
begin
  writeln('<h1>Unlimited</h1>');
  unlimited := True;
end;


function txseus.c_noncritical: boolean;
{D:   ncx  sxx
}
begin
  x_critical := False;
end;

function txseus.c_logwrite: boolean;
{D: writes text to UI (or log file if running as service) for debugging
}
begin
  logwrite(CurBYEle.vali);
end;


function txseus.c_resettimer: boolean;
{D: not functional. Resets the countdown of killer-processess
}
begin
  x_resettimer := True;
end;




function txseus.c_showtime: boolean;
{D: debugging, lists execution times of multi-handler commands
}
begin
  //writeln('<h1>showtime</h1>');
  x_times.listaa;
end;


function txseus.c_flush: boolean;
{D: probably not needed. Makes sure everything is written out in case the thread is
 killed by loopdetectors
}
begin
  flush(output);
end;


function txseus.c_closeoutput: boolean;
{D: makes thread invulnerable against clients disconnecting. Probably not working properly
  -plan: could be usefull for creating "background processess"
}
begin
  Assign(output, '');
  writeln('Content-type: text/xml' + crlf + crlf);
  //writeln(CurBYEle.att('byby') + 'done');
  flush(output);
  Close(output);
  _closestderr;
  Assign(output, 'nul');
end;

function txseus.c_login: boolean;
begin
  auth_login;
end;

function txseus.c_logout: boolean;
{D: not functional at the moment
}
begin
  x_session.killtree;
  x_session := ttag.Create;
  //--DeleteFileUTF8(ses_file ); { *Converted from DeleteFile*  }
  DeleteFile(ses_file); { *Converted from DeleteFile*  }
  //xml.subtags.Delete(xml.subtags.indexof(xml.subt('session')));

end;



function txseus.c_authorize: boolean;
begin
  result:=auth_authorize;
  //writeln('xxxxxxxxxxxxxxxxxxxxxx');
end;

function txseus.c_getauthorization: boolean;
begin   //check if authorized
  result:=auth_getauthorization;
end;

function txseus.c_readauthorization: boolean;
begin  //check files for authorization
  result:=auth_report;//readauthorization;
  //result:=auth_readauthorization;
end;

function txseus.c_function: boolean;
{D: adds used-defined functions at run-time
 -usage: very rare. not tested.
 -plan: could be powerfull
 -doc: not now
}
begin
  x_funcs.subtags.add(CurBYEle);
end;



function txseus.c_setdebug: boolean;
begin
  //g_debug := True;
  t_debug := True;
end;

function txseus.c_nodebug: boolean;
begin
  t_debug := False;
end;

function txseus.c_write: boolean;
{D: writes text to files (if _indir)
}
var
  fs: tfilestream;
  fn: string;
begin
  //writeln('writing to :'+fn);
  fn := _indir(curbyele.att('file'), x_outdir, self, True);
  fs := tfilestream.Create(fn, fmcreate or fmopenwrite);
  //writeln('writing to :' + fn + '!' + curbyele.vali);
  fs.Writebuffer(curbyele.vali[1], length(curbyele.vali));
  fs.Free;

end;

function txseus.c_delete: boolean;
{D: deletes files (if _indir)
}
var
  apust: string;

begin
  apust := CurBYEle.att('file');
  apust := _indir(apust, x_outdir, self, True);
  if apust <> '' then
    //--DeleteFileUTF8(apust ); { *Converted from DeleteFile*  }
    DeleteFile(apust); { *Converted from DeleteFile*  }
end;


function txseus.c_comment: boolean;
{D: Creates comment-tags ..
 plan: do doelements (evaluate subcoms) before writing the comment
}
var
  newtag: ttag;
begin
  newtag := ttag.Create;
  newtag.vari := '';//'value';
  //CurBYEle:=evalsubtags;
  //substissubs;

  //newtag.vali:='<!--'+CurBYEle.vali+'(comments not implemented properly-->';
  //newtag.vali:='<!--'+evalsubtags.subs('@alltext()')+'-->';
  newtag.vali := '<!--' + CurBYEle.subs('@asstring()') + '-->';
  resuadd(newtag);
end;
function txseus.c_doc: boolean;
{D: documentation comments. gotta figure out what to do with them. For now, just display
}
begin
  writeln('<blockquote style="font-size:0.8em;color:gray">',curbyele.vali,'</blockquote>');
end;
function txseus.c_text: boolean;
{D: creates text-nodes (elements without a name).
}
var
  newtag: ttag;
begin
  //writeln('<li>newtext:<xmp>'+curtoele.xmlis+'</xmp>');
  if (curtoele.subtags.count<1)  then curtoele.vali:=curtoele.vali+curbyele.vali
  else if (ttag(curtoele.subtags[curtoele.subtags.count-1]).vari='') then
  begin
   newtag:=curtoele.subtags[curtoele.subtags.count-1];
   newtag.vali:=newtag.vali+curbyele.vali;
  end else
  begin
    newtag := ttag.Create;
    newtag.vari := '';
    newtag.vali := CurBYEle.vali;
    //newtag.vali :='_'+ttag(curtoele.subtags[curtoele.subtags.count-1]).vari+inttostr(curtoele.subtags.count)+'_'+ CurBYEle.vali;
    resuadd(newtag);
  end
  //writeln('<li>text:<xmp>'+curtoele.xmlis+'</xmp>');
end;

function txseus.c_line: boolean;
{D: creates text-nodes (elements without a name), with crlf at end
}
var
  newtag: ttag;
begin
  if curtoele.subtags.count>0 then
  begin
    newtag := ttag.Create;
    newtag.vari := '';
    newtag.vali := lf+CurBYEle.vali;
    resuadd(newtag);
  end
  else curtoele.vali:=curtoele.vali+lf+curbyele.vali;
end;

function txseus.c_rawcopy: boolean;
{D: fast and probably dangerous way to add content to result-element
  (vulnerable to memory cleanup operations)
}
begin
  resuadd(CurFromEle);
  CurFromEle.xrefcount := CurFromEle.xrefcount + 1;
end;

function txseus.c_diff: boolean;
{D: produces html-format diff-reports
 -status: not tested much
 -usage: mainly for debugging (output not very pretty, but functional for programmers)
}
var
  newtag: ttag;
  apustl: TStringList;
begin
  newtag := ttag.Create;
  try
    newtag.vari := '';//'value';
    //writeln('<h1>dodif</h1>' + CurBYEle.att('t1'), CurBYEle.att('t2'), '<hr/>');
    apustl := dodif(CurBYEle.att('t1'), CurBYEle.att('t2'));
    resuadd(newtag);
    newtag.vali := apustl.Text;
  finally
    apustl.Free;
  end;
end;

function txseus.c_dir: boolean;
{D: xml-format dir-listtings
  -status: attribute naming could maybe be reconsidered
   Uses Linux wildcards if not specified (* not *.*)

}
var
  sub: boolean;
  subc: ttag;
  pattern: string;

  procedure __adirfiles(totag:ttag;dir,pattern: string);
  var
    s1, s2, aps, subdir: string;
    t: tdatetime;
    resu: ttag;
    i: integer;
    sr,subdirs,subsearch: TSearchRec;
    sublist:tlist;

  begin
    sublist:=tlist.create;;
    //WRITELN('<LI>files!:'+dir+'!');//+sr.type'!');
    if FindFirst(dir+pattern, faAnyFile,   sr) = 0 then
    repeat
    Resu := ttag.Create;
    Resu.vari := CurBYEle.att('filetag');
    if Resu.vari = '' then
      Resu.vari := 'file';
    s1 := sr.Name;
    s2 := extractfileext(s1);
    s1 := copy(s1, 1, length(s1) - length(s2));
    Resu.setatt('name', s1);
    Resu.setatt('ext', s2);
    Resu.setatt('size', IntToStr(sr.size));
    t := filedatetodatetime(sr.time);
    s1 := datetostr(t);
    s2 := timetostr(t);
    Resu.setatt('time', s2);
    Resu.setatt('date', s1);
    If (sr.Attr and faDirectory) = faDirectory then
    //sublist.add(resu)
    ELSE  totag.subtags.add(resu);
    until (FindNext(sr) <> 0);
    //WRITELN('<li>GOTFILES:<xmp>'+totag.xmlis+'</xmp>!!!'+dir);
    findclose(sr);
    {FOR I:=0 TO SUBlist.count-1 do
    begin
       resu:=sublist[i];
       resu.vari:='dir';
       WRITELN('<li>get:<xmp>'+resu.xmlis+'</xmp>!!!'+dir);
       totag.subtags.add(resu);
      //__adir(resu,dir+resu.att('name')+'/');
    end;}
    //WRITELN('<li>GOTALL:<xmp>'+totag.xmlis+'</xmp>!!!'+dir);


  end;
  procedure __subdirs(totag:ttag;dir,pattern: string);
  var
    s1, s2, aps, subdir: string; ssr: tsearchrec;
    resu: ttag;
    t: tdatetime;
    subres: ttag;
    i: integer;
    dirlist:tlist;
   // subdirs: TSearchRec;
  begin
    dirlist:=tlist.create;
    //WRITELN('<LI>SUBDIRS!:'+dir+'!');//+sr.type'!');
     if FindFirst(dir+'*',   faDirectory,   ssr) = 0 then
     repeat
       //WRITELN('<LI>SUBDIR!:'+SR.Name+'!');//+sr.type'!');
       //break;
     If (ssr.Attr and faDirectory) = faDirectory then
       if (ssr.Name <> '.') and (ssr.Name <> '..') and (ssr.Name <> '') then
     begin
     //WRITELN('<LI>is DIR!:'+sSR.Name+'!','/in:',dir);//+sr.type'!');
     Resu := ttag.Create;
     Resu.vari := CurBYEle.att('dirtag');
     if Resu.vari = '' then resu.vari:='dir';
     s1 := ssr.Name;
     s2 := extractfileext(s1);
     s1 := copy(s1, 1, length(s1) - length(s2));
     Resu.setatt('name', s1);
     Resu.setatt('ext', s2);
     Resu.setatt('size', IntToStr(ssr.size));
     t := filedatetodatetime(ssr.time);
     s1 := datetostr(t);
     s2 := timetostr(t);
     Resu.setatt('time', s2);
     Resu.setatt('date', s1);
     Resu.setatt('path', dir);
     //writeln('<li>trydeeper:',resu.att('name'),'!from:',dir+''+ssr.name,pattern);
     //__subdirs(resu,dir+''+ssr.name,pattern);
    //  __adir(resu,dir,pattern);
     dirlist.add(resu)
     //totag.subtags.add(resu);
     end;
    until (FindNext(ssr) <> 0);
     //WRITELN('<li>GOTALL:<xmp>'+totag.xmlis+'</xmp>!!!'+dir);
     findclose(ssr);
     __adirfiles(totag,dir+'*',pattern);
      for i:=0 to dirlist.count-1 do
        begin

          subdir:=ttag(dirlist[i]).att('path')+''+ttag(dirlist[i]).att('name')+'/';
          //writeln('<li>dotrydeeper:',subdir,'!from:',dir+'!pat:',pattern);
         __subdirs(ttag(dirlist[i]),subdir,pattern);
         totag.subtags.add(dirlist[i]);

        end;
    end;
 { if 1=0 THEN
  if FindFirst(dir, faDirectory,  subdirs)  = 0 then
  //if (Sr.Attr and fadirectory > 0) then
  begin
    if (1=0) and (sub) then
    begin
      subdir := dir + sr.Name + g_ds;
      WRITELN('<LI>SUBDIR1:'+SR.Name+'!'+SUBDIR+'!');
      if FindFirst(subdir, faAnyFile and faDirectory,   subSearch) = 0 then
      begin
        repeat
          if (subsearch.Name <> '.') and (subsearch.Name <> '..') then
          begin
            WRITELN('<LI>SUBDIR2:'+SR.Name+SUBDIR);
            __adir(subres, subdir, subsearch);
            Resu.subtags.add(subres);
          end;
        until (FindNext(subSearch) <> 0);
      end;
      FindClose(subSearch);

    end;
  end;
  //writeln('<li>',result.xmlis+'</li>');}
//end;

var
  subsearch,SearchRec: TSearchRec;
  restag, ares: ttag;

begin
   pattern := CurBYEle.att('pattern');
  if pattern = '' then
    pattern := '*';
  if CurBYEle.att('sub') = 'true' then
    sub := True
  else
    sub := False;
  //__adir(curtoele,curbyele.att('dir'), pattern);
  //if sub then
   __subdirs(curtoele,curbyele.att('dir'),pattern);
 end;
  //!!restag := ttag.Create;
  //!!restag.vari := CurBYEle.att('out');
  //!!if restag.vari = '' then
  //!!  restag.vari := 'dir';
  //!!resuadd(restag);
 // WRITELN('<li dir from:'+curbyele.att('dir') + pattern,'/to:',restag.vari);
  //if FindFirst(curbyele.att('dir') + pattern, faAnyFile and faDirectory,  SearchRec)  = 0 then
{    if FindFirst(curbyele.att('dir') + pattern, faAnyFile,  SearchRec)  = 0 then
    repeat
      if (searchrec.Name <> '.') and (searchrec.Name <> '..') then
      begin
        //restag.addsubtag('diri',searchrec.name);
        //writeln('<li>x',searchrec.name,'</li>');
        __adir(ares, curbyele.att('dir')+'\', searchrec);
        resuadd(ares);
      end;
    until (FindNext(SearchRec)  <> 0);
        //subdir := dir + sr.Name + g_ds;
        //WRITELN('<LI>SUBDIR1:'+SR.Name+'!'+SUBDIR+'!');

    //if 1=0 THEN
      if FindFirst(curbyele.att('dir')+'/*', faDirectory,   subSearch) = 0 then
      repeat
        //WRITELN('<LI>SUBDIRxxx:'+Subsearch.Name+'!');
        if (subsearch.Name <> '.') and (subsearch.Name <> '..') then
        BEGIN
        __SUBdirs(ares, curbyele.att('dir'), subsearch);
        //restag.subtags.add(ares);
        resuadd(ares);

        end;
    until (FindNext(subSearch)  <> 0);
  FindClose(SearchRec);

end;
}


function txseus.c_ftpput: boolean;
begin
end;{
var
  ftp: txseusftpclient;
begin
  ftp := txseusftpclient.Create;
end;
}

function txseus.c_sendmail: boolean;
{D: sends mail
 -usage: -common
 -plans: attachments?
}
var
  msg: string;
  msgl: TStringList;
  //atch: TList;

begin
  msg := CurBYEle.att('msg');
  msgl := TStringList.Create;
  try
    if msg = '' then
      msg := CurBYEle.subs('msg/@asstring()');
    msgl.add(msg);
    logwrite(CurBYEle.att('to') + CurBYEle.att('from') + CurBYEle.att(
      'subject') + msg + CurBYEle.att('smtpserver') + CurBYEle.att('attach'));
    _synmail(CurBYEle.att('from'), CurBYEle.att('to'), CurBYEle.att('subject'),
      CurBYEle.att('smtpserver'), msgl);
    //procedure _synmail(mfrom,mto,subj,smtphost:string;msg:tstrings);

    //SendTo(const MailFrom, MailTo, Subject, SMTPHost: string; const MailData: TStrings): Boolean;
    //writeln('smtp functions temporarily disabled in xseus');
    //indy _sendmail(CurBYEle.att('to'), CurBYEle.att('from'), CurBYEle.att(
    //   'subject'), msg, CurBYEle.att('smtpserver'), CurBYEle.att('attach'));
  finally
    msgl.Free;
  end;
end;


function txseus.c_callobject: boolean;
{D: runs another xseus-call in the current thread
 -usage: common
 -doc: quite difficult, skip
}
var
  handlers, xdata, xform, nxform, res, aput: ttag;
  ol: txseus;
  //vars: TSTRINGLIST;//TurbohashedStringList;
  vars: tstringlist;//ThashStringS;
  handler, obfile, oodir: string;
  atts: TStringList;
  newob, oldob: txseus;
  acom, oldres, bmarks: ttag;
begin
  vars := x_svars;
  //elems:=x_bookmarks;
  bmarks := x_bookmarks;

  ol := self;
  acom := CurBYEle;
  oodir := x_objectdir;
  Result := True;
  newob := txseus.Create(ol);
  newob.x_called := True;
  //newob.clear;newob.Free;exit;
  try
    oldres := x_form;
    newob.setvals(ol);
  except
    writeln('<li>could not set object</li>');
    //listwrite(acom);
    exit;
    //raise;
  end;
  try
    if newob.x_myhandler = nil then
      if acom.att('fail') = 'ok' then
        exit
      else
      begin
        writeln('<!--No Handler &lt;' + acom.vari + //' ' + acom.attributes.Text +
          '&gt;</-->');
        exit;
      end;
    try
      try
        newob.httpinited := True;
        //myxs := newob;
        try
          writeln('<h1>callobjek', '</h1>', newob.xml.xmlis);
        except
          writeln('faiiled to list newob');
        end;
        //listwrite(myxs.xml);
        //result:=newob.docoms2(newob.x_handler,state);
        //  writeln('----------------------------');
        //listwrite(newob.xml);
        //writeln('///----------------------------');
        try
          //thrxs := newob;
          //Result := newob.docoms2(newob.x_myhandler, nil);
          //!!DOE DOES NOT WORK WITH DOELEMENTS:
          CurBYEle := newob.x_myhandler;
          Result := newob.dosubelements;
        finally
          //!thrxs := self;
        end;
        //writeln('<h1>///callobjek','</h1>');
        //    registertagowner(self,SELF.elems);
        //!myxs := self;
        //x_bookmarks:=x_bmarks;

      except
        writeln('<li>object FAIL: ');
        flush(output);
      end;
    finally   //flush(output);
      //--SetCurrentDirUTF8(def_dir); { *Converted from SetCurrentDir*  }
      SetCurrentDir(x_outdir); { *Converted from SetCurrentDir*  }

    end;

    x_objectdir := oodir;
  except
    writeln('failed in callhandler');
    flush(output);
  end;
  try
    if acom <> nil then
      if acom.att('result') <> '' then
      begin
        res := newob.xml.subt(acom.att('result'));
        //listwrite(ttag(newob.xml));
        if res <> nil then
        begin
          if acom.att('replace') = 'true' then
          begin
            aput := ol.xml.subt('+' + acom.att('result'));
            aput.subtags.Clear;
            aput.subtagscopy(res.subtags);
          end
          else
            ol.xml.subtagsadd(res);
          if acom.att('rename') <> '' then
            res.vari := acom.att('rename');
        end;
      end;
    CurToEle := oldres;
    newob.Clear;
    newob.Free;
  except
    writeln('<li>could not call object');
    flush(output);
  end;
end;

function txseus.c_cleancdata: boolean;
{D: purges cdata-limiters
  -usage: use of cdata is deappriciated
}
begin
  _cleancdata(CurBYEle, xml);
end;


function txseus.c_pokehtml: boolean;
{D: one of several attempts to handle writing of content into html-files
  that have navigation etc in place. Probably not the best one
}
begin
  _pokehtml(CurBYEle, xml, x_outdir, self);
end;

function txseus.c_filereplace: boolean;
{D:  replace text inside external files
   -usage: sometimes.. when lots of big files that one wishes not to have to parse
    properly
   -plans: unix ed functionality? probaly to be replaced by somthing awkish
    may simple , fast version like this also sometimes usefull
}
var
  fn, old, new: string;
  txt: TStringList;
  acom: ttag;
begin
  try
    acom := CurBYEle;
    if acom = nil then
      exit;
    fn := acom.att('file');
    old := acom.att('old');
    new := acom.att('new');
    writeln('<li>' + fn);
    try
      txt := TStringList.Create;
      txt.loadfromfile(fn);
    except
      writeln('failed to load file');
    end;
    txt.Text := StringReplace(txt.Text, old, new, [rfreplaceall]);

    txt.savetofile(fn);
  except
    writeln('failed to replace in files');
  end;
  txt.Clear;
  txt.Free;
end;


function txseus.c_lock: boolean;
var
  fn: string;
{D: locks a file
}
begin
  //g_locs.lockfile (CurBYEle,self ) ;
  fn := CurBYEle.att('file');
  if fn = '' then
    fn := x_objectfile;
  //writeln('<li>locked:'+g_locks.locks.text+'</li><li>trylock;'+fn+'</li>');
  g_locks.lockfile(fn, x_mylocks);

end;

function txseus.c_listlocks: boolean;
var
  fn: string;
{D: locks a file
}
begin
  writeln('<li>listlocked:' + g_locks.listlocks + '</li>');

end;


function txseus.c_unlock: boolean;
{D:   ok
}
var
  fn: string;
begin
  fn := CurBYEle.att('file');
  if fn = '' then
    fn := x_objectfile;
  //writeln('<li>beforefree:'+g_locks.locks.text+'</li>');
  g_locks.freefile(fn, x_mylocks);
  //writeln('<li>afterfree:'+g_locks.locks.text+'</li>');

end;



function txseus.c_markmem: boolean;
begin
  _testmem(CurBYEle.att('var'));
end;

function txseus.c_set: boolean;

{D:   sets variable values
  -usage: very common
  -see also: c_comp
}
  var
    x1, x2, st: string;
    i, k, ind: integer;
    acom, seltag: ttag;
    vars: TStringList;
    //vars: ThashStrings;
  begin
    try
        acom := CurBYEle;
        seltag := CurFromEle;
        vars := x_svars;
        begin
          if acom.att('var') <> '' then
          begin
            vars.values[acom.att('var')]:=acom.vali;
            //writeln('<li>setvar:', acom.att('var'),acom.vali);
          end
          else
          if acom.att('func') <> '' then
          begin  //not sure what this is for
            try
                vars.values[acom.att('var')]:= _docompute(acom, self, '');
            except
              writeln('<li>coud not set function:' + acom.getattributes.Text);
            end;
          end
          else
            for k := 0 to acom.attributesCount - 1 do
            begin
              x1 := cut_ls(acom.getattributes[k]);
              x2 := cut_rs(acom.getattributes[k]);
              if x1 = '' then
                continue;
              if (x2 = '') and (acom.att(ns + 'ifempty') <> '') then
                //vars.add(x1, acom.att(xs.ns + 'ifempty'))
                vars.values[x1] := acom.att(ns + 'ifempty')
              else
              begin
                try
                  vars.values[x1]:=x2;
                  //vars.add(x1, x2);
                except
                  writeln('<li>coudnotgetvarindex:');
                end;
              end;
            end;
        end;
      except
        writeln('<li>coudnotsetvar:');
        raise;
      end;
end;

function txseus.c_comp: boolean;
{D: runs functions, place results to curren result-tag (see c_set which places results to vars)
}
var
  newtag: ttag;
begin
  newtag := ttag.Create;
  newtag.vali := _docompute(CurBYEle, self, '');
  newtag.vari := '';//'value';

  resuadd(newtag);
end;

function txseus.c_while: boolean;
var
  i, placeinhand, nextcom: integer;
  acom, selfcopy: ttag;
begin
  //i:=o;
  try
    writeln('<h1>sorry, while not implemented</h1>');
    selfcopy := CurBYEle.copytag;
    placeinhand := CurBYEle.parent.subtags.indexof(CurBYEle);
    writeln('try while', placeinhand, ' ', selfcopy.att('loop') +
      '<xmp>' + CurBYEle.parent.listraw + '</xmp>');
  except
    writeln('nogo');
  end;
  if placeinhand > 100 then
    exit;

  //state.apparentins(placeinhand + 1, selfcopy);
  try
    selfcopy.setatt('loop', IntToStr(strtointdef(selfcopy.att('loop'), 0) + 1));
  except

  end;
  if not c_if then
  begin
    writeln('fail while', placeinhand);
    selfcopy.vari := 'xse:noop';

    //selfcopy:=nil;
    //i:=i+1;if i>50 then break;
    //placeinhand:=acom.parent.subtags.indexof(acom)+1;
    //placeinhand:=acom.parent.subtags.indexof(acom)+1;
  end;

end;


function txseus.c_if: boolean;
{D: conditionally execute subcmds, return elseflag
  -usage: experimental, MAINLY REPLACED BY XSE:IF -ATTRIBUTE
}
var
  test, past: boolean;
  resucoms: TList;
  i, apui: integer;
  testst:string;
begin
    apui := 1;
    if curbyele.att('test')='' then
      {INFIX test := _p_infix(curbyele.vali, apui, self, '') = '1'}
    //test:=parsefromele(curfromele,curbyele.vali) = '1'
    test:=_p_condition(curbyele.vali,curfromele) = '1'
      else  {INFIX test := _p_infix(curbyele.att('test'), apui, self, '') = '1';}
      //test:=parsefromele(curfromele, curbyele.att('test'))='1';
     testst:=_p_condition(curbyele.att('test'),curfromele );
     test:=testst='1';
     //writeln('<li>didif:',curbyele.head,test,curbyele.att('test'),'=',testst,'/</li>');
    if test then
    begin
      result:=true;
      try
        if curbyele.subtags.Count > 0 then
          result:=doelementlist(curbyele.subtags);
        //setting the result????
      except
        writeln('failed in executing conditional part: if', test)
      end;
      //for i := elsepos-1 downto 0 do
    end else result:=false;

end;
function txseus.c_oldif: boolean;
{D: complex, powerfull if statement
  -usage: experimental, MAINLY REPLACED BY XSE:IF -ATTRIBUTE
}
var
  test, past: boolean;
  resucoms: TList;
  i, apui, elsepos: integer;
  elsetag: ttag;
  turha: string;
begin
  try
    resucoms := TList.Create;
    apui := 1;
    //turha:=inttostr(curbyele.subs(ns+'else/@position()'));
    elsetag:=curbyele.subt(ns + 'else');
    if elsetag<> nil then
    elsepos := curbyele.subtags.indexof(elsetag)
    else elsepos:=curbyele.subtags.Count-1;
    //for i:=0 to curbyele.subtags.count-1 do write(ttag(curbyele.subtags[i]).vari,'!');
    apui:=1;
    if curbyele.att('test')='' then
    {INFIX test := _p_infix(curbyele.vali, apui, self, '') = '1' else
    test := _p_infix(curbyele.att('test'), apui, self, '') = '1';}
    test:=parsefromele(curfromele, curbyele.vali)='1' else
    test:=parsefromele(curfromele, curbyele.att('test'))='1' ;
    //writeln('<li>if:',test,'!' ,curbyele.vali,'/epos:',elsepos,'\',curbyele.subtags.count,curbyele.xmlis); //,ttag(curbyele.subtags[elsepos]).vari
    if test then
    begin
      //for i := elsepos-1 downto 0 do
      for i := 0 to elsepos - 1 do
      begin
        //if ttag(curbyele.subtags[i]).vari=ns+'else' then past:=true;
        //state.apparentins(placeinhand, ttag(thentag.subtags[j]).copytag);
        resucoms.add(curbyele.subtags[i]);
        //writeln('<li>dothen:'+ttag(curbyele.subtags[i]).vari);

      end;
    end
    else
      //for i := curbyele.subtags.Count - 1 downto elsepos+1 do
      for i := elsepos+1  to curbyele.subtags.Count - 1 do
      begin
        //if ttag(curbyele.subtags[i]).vari=ns+'else' then continue;
        //state.apparentins(placeinhand, ttag(thentag.subtags[j]).copytag);
        resucoms.add(curbyele.subtags[i]);
        //writeln('<li>doelse:'+ttag(curbyele.subtags[i]).vari);

      end;
    try
      if resucoms.Count > 0 then
        doelementlist(resucoms);

    except
      writeln('failed in executing conditional part: if', test)
    end;
  finally
    resucoms.Clear;
    resucoms.Free;

  end;

end;
function txseus.c_rematch: boolean;
begin
 x_rematch:=true;
end;
function txseus.c_case: boolean;
var selector,acon:string;i:integer;oldmatch:boolean;
begin
  oldmatch:=x_rematch;
try
  selector:=trim(curbyele.vali);
  if selector='' then selector:='1';  //'1'=boolean true
  //writeln('<li>case:'+selector+'/of:',curbyele.subtags.count);
  for i:=0 to curbyele.subtags.count-1 do
  begin
    //acon:=parsefromele(curfromele,ttag(curbyele.subtags[i]).vali);
    acon:=parsexse(ttag(curbyele.subtags[i]).vali,self);
    //writeln('<li>',_matches(selector,acon),'/Acase:'+selector+'/vs:',acon,'(=',ttag(curbyele.subtags[i]).vali,')=','/from:',curfromele.head);
    if _matches(selector,acon) then
    begin
      x_rematch:=false;
      result:=doelementlist(ttag(curbyele.subtags[i]).subtags);
      if not x_rematch then exit;
    end;

  end;
  if ttag(curbyele.subtags[curbyele.subtags.count-1]).vari='else' then
  result:=doelementlist(ttag(curbyele.subtags[curbyele.subtags.count-1]).subtags);
  finally
    //writeln('li>always do:',curbyele.subtags.text);
    //if curbyele.subttags.values('always')<>
    x_rematch:=oldmatch;end;


 {se:case: keissi
    case: 1 ..do
    case:2 ..
     xse:rematch
    case:3}
end;

function txseus.c_iff: boolean;
{D: complex, powerfull if statement  //iff? Old version?
  -usage: very common
}
var
  alist: TList;
  did: boolean;
  acom: ttag;
  i, j, k, osubs, testels: integer;
  etag: ttag;
  condtag, thentag, elsetag, aputag, OLDBY: ttag;
  x1, x2, x3, test: string;
  elses, setled: boolean;
  ok, neg: boolean;
  resucoms: TList;
  seltag, xform: ttag; //vars:tstringlist;
  placeinhand: integer;

begin
  try
    resucoms := TList.Create;
    try
      try
        try
          try
            acom := CurBYEle;
            if acom = nil then
              writeln('<h1>nilacom</h1>');
            if acom.parent = nil then
              listwrite(acom);
            placeinhand := acom.parent.subtags.indexof(acom) + 1;
          except
            writeln('fail if pre why?');
            listwrite(acom.parent);
            if acom.parent = nil then
              writeln('<h1>nilacomparent</h1>');
            raise;
          end;
          seltag := CurFromEle;
          xform := xml;
          //vars:=x_vars;
          ok := False;
          elses := False;
          neg := False;
          elsetag := acom.subt(ns + 'else');
          thentag := acom.subt(ns + 'then');
          condtag := acom.subt(ns + 'test');
          testels := 0;
        except
          writeln('fail if pre');
          raise;
        end;

        if (condtag <> nil) then
        begin
          ok := _condition(condtag, seltag, xform, self);
          //writeln('<li>cond:',ok);listwrite(thentag);listwrite(elsetag);
        end
        else
        begin
          try
            test := acom.att('test');
            if test = '' then
              test := 'eq';
            ok := _test(test, acom.att('x1'), acom.att('x2'), self, acom);
            if neg then
              ok := not ok;
            setled := False;
            testels := -1;
          except
            writeln('fail test');
          end;
          if acom.subtags.Count < 1 then
            testels := 0
          else
            try
              while testels < acom.subtags.Count - 1 do
              begin
                testels := testels + 1;
                aputag := acom.subtags[testels];
                if ((aputag.vari = '') and (trim(aputag.vali) = '') and
                  (aputag.subtags.Count = 0)) then
                  continue
                else
                if (aputag.vari = ns + 'andif') then
                begin
                  if setled then
                    continue
                  else
                  if not ok then
                    setled := True
                  else
                  begin
                    try
                      //newstate := tstate.Create(state, self);
                      OLDBY := CURBYELE;
                      CurBYEle := aputag;
                      ok := c_iff;
                      CURBYELE := OLDBY;
                      //newstate.dofree;
                    except
                      writeln('AND fai');
                    end;
                  end;
                end
                else
                if (aputag.vari = ns + 'orif') then
                begin
                  if setled then
                    continue
                  else
                  if ok then
                    setled := True
                  else
                    try
                      //newstate := tstate.Create(state, self);
                      OLDBY := CURBYELE;
                      CurBYEle := aputag;
                      ok := c_iff;
                      CURBYELE := OLDBY;
                    except
                      writeln('AND fai');
                    end;
                end
                else
                  break;
              end;
            except
              writeln('failed to find iftag subtags');
            end;

        end;  //tests results have been settled
        //writeln('<li>tested:',ok);
      except
        writeln('could not do iftag');
      end;
      try
        //ok:=false;
        if ok then
        begin
          if acom.att('var') <> '' then
            //x_svars.ADD(acom.att('var'), acom.att('value'));
            x_svars.values[acom.att('var')] := acom.att('value');
          try
            if thentag <> nil then
            begin
              for j := thentag.subtags.Count - 1 downto 0 do
              begin
                //state.apparentins(placeinhand, ttag(thentag.subtags[j]).copytag);
                resucoms.add(thentag.subtags[j]);
              end;
            end
            else
            begin
              try
                for j := testels to acom.subtags.Count - 1 do
                begin
                  //writeln(acom.att('x1'),'sub:<pre>', ttag(acom.subtags[j]).xmlis,'</pre>',acom.att('x2'));
                  if ttag(acom.subtags[j]).vari = ns + 'elseif' then
                  begin
                    //write('ADDCOM:<pre>',ttag(CurBYEle.parent).xmlis,'</pre>');

                    break;
                  end
                  else
                  if ttag(acom.subtags[j]).vari = ns + 'orif' then
                    continue
                  else
                  if ttag(acom.subtags[j]).vari = ns + 'andif' then
                    continue
                  else
                  if (ttag(acom.subtags[j]).vari = '') and //'value') and
                    (ttag(acom.subtags[j]).subtags.Count < 1) and
                    (trim(ttag(acom.subtags[j]).vali) < '') then
                  begin
                    //if acom.att('debug')='true' then
                    //begin
                    //  writeln('<li>valuex</li>',ttag(acom.subtags[j]).vali);
                    //  listwrite(ttag(acom.subtags[j]));
                    //end;
                    continue;
                  end
                  else
                  begin
                    try
                      //write('ADDCOM:<pre>',ttag(acom.subtags[j]).xmlis,'</pre>');
                      //write('ADDCOM:<pre>',ttag(acom.subtags[j]).copytag.xmlis,'</pre>');
                      resucoms.add(acom.subtags[j]);
                      //state.apparentins(placeinhand, ttag(acom.subtags[j]).copytag);
                      //placeinhand := placeinhand + 1;
                    except
                      writeln('<li>fail in if: ', i, test, neg, x1, x2, ok, placeinhand);
                    end;
                  end;
                end;
              except
                writeln('<li>failif: ' + test, neg, x1, x2, ok, placeinhand);
              end;
            end;
          except
            writeln('vailed ok if', testels);
          end;
        end  //ok
        else //not ok:
        begin
          if acom.att('elsevalue') <> '' then
            //x_svars.ADD(acom.att('var'), acom.att('elsevalue'));
            x_svars.values[acom.att('var')] := acom.att('elsevalue');
          if elsetag <> nil then
          begin
            try
              try
                for j := 0 to elsetag.subtags.Count - 1 do
                  resucoms.add(acom.subtags[j]);
                //for j := elsetag.subtags.Count - 1 downto 0 do
                //state.apparentins(placeinhand, ttag(elsetag.subtags[j]).copytag);
              except
                writeln('failed else if1');
              end;
            except
              writeln('could not add elseelement1');
            end;
          end
          else
          begin
            try
              for j := 0 to acom.subtags.Count - 1 do
              begin
                if ttag(acom.subtags[j]).vari = ns + 'elseif' then
                begin
                  for k := j to acom.subtags.Count - 1 do

                    resucoms.add(acom.subtags[k]);
                  break;
                end;
              end;
              {for j := 0 to acom.subtags.Count - 1 do
              begin
                //writeln('<li>els:'+ttag(acom.subtags[j]).vari);
                if ttag(acom.subtags[j]).vari = ns + 'elseif' then
                begin                  ölklk
                  for k := acom.subtags.Count - 1 downto j + 1 do
                    if (ttag(acom.subtags[k]).vari = 'value') and
                      (ttag(acom.subtags[k]).subtags.Count < 1) and
                      (trim(ttag(acom.subtags[k]).vali) = '') then
                      continue
                    else
                      state.apparentins(placeinhand, ttag(acom.subtags[k]).copytag);
                  break;
                  elses := True;
                end;
              end;}
            except
              writeln('could not add elseelement');
            end;
          end;
          //writeln('<li>IFIF:',ttag(CurBYEle.parent).xmlis);
        end;
      except
        writeln('could not decide whatif');
      end;
    except
      writeln('could not eval if');
      listwrite(acom);
    end;
    try
      doelementlist(resucoms);
    except
      writeln('<li>IFIF:', acom.xmlis);
    end;
  finally

    resucoms.Clear;
    resucoms.Free;
    Result := ok;
    if acom.att('debug') = 'true' then
      writeln(ok, '<pre>', ttag(acom).xmlis, '</pre> x1=', acom.att('x1'),
        '!x2=', acom.att('x2'), '!');

  end;
end;


function txseus.c_output: boolean;
{D: something very ancient. Writes either some text to some file, or lists all
  http-postform fields to file. use xse: outfile -attribute instead
  -status: outdated
  -group: fileio, debug ?
..NEW FUNCTIONALITY BEING TESTED:
.. WRITES THE VALUE
}
var
  apust: string;
  j: integer;
  outf: string;
  acom: ttag;
  xse: txseus;
begin
  try
    acom := CurBYEle;
    xse := self;
    outf := _indir(acom.att('file'), xse.x_outdir, self, True);
    if acom.att('text') = 'all' then
    begin
      apust := '';
      for j := 0 to tserving(x_serving).requestheaders.Count - 1 do
        apust := apust + cut_rs(tserving(x_serving).requestheaders[j]) + acom.att('sep');
      _writefile(outf, apust);
    end
    else
      _writefile(outf, acom.att('text'));
    if _debug then
      writeln('<li>OUTPUT' + acom.att('file') + ' X ' + acom.att('text'));
  except
    writeln('Problems: output');
  end;

end;

function txseus.c_foreach: boolean;
{D: creates an element and runs it as a command
 -usage_ not uncommon
 about same as <add element=commands><apply select=whatever><a cmd/></app></add><do commands="commands"/>

}
var
  ALIST: TList;
  ok: boolean;

  newtag, turha: ttag;
  i, ipoint: integer;
begin
{  newstate := tstate.Create(state, self);
  newtag := ttag.Create;
  newCurToEle := newtag;
  //newstate.resta:=CurBYEle.parent;
  //newstate.resta:=CurBYEle.parent;
  //newstate.respoint:=
  ipoint := CurBYEle.parent.subtags.indexof(CurBYEle) + 1;
  //writeln('<li>respoint',newstate.respoint);
  //listwrite(CurBYEle);
  //listwrite(CurBYEle.parent);
  //setstate(newstate);
  applyall(newstate);
  newstate.dofree;
  //ipoint:=0;
  // turha:=ttag.create;
  // turha.vari:='exit';
  //turha.subtags.add(newtag);
  for i := newtag.subtags.Count - 1 downto 0 do
  begin
    //turha:=newtag.subtags[i];
    //listwrite(turha);
    // CurBYEle.parent.subtags.add(newtag.subtags[i]);
    //turha.subtags.insert(ipoint,newtag.subtags[i]);
    CurBYEle.parent.subtags.insert(ipoint, newtag.subtags[i]);
    ttag(newtag.subtags[i]).parent := ttag(CurBYEle.parent);
  end;
  //  CurBYEle.parent.subtags.insert(ipoint+1,turha);
  //CurBYEle.parent.subtags.insert(ipoint,newtag.subtags[i]);
  Result := ok;
  //listwrite(newtag);
  //listwrite(CurBYEle.parent);
  }
end;



function txseus.c_json: boolean;
var
  src: string;
begin
  src := CurBYEle.att('src');
  //resuadd(_json(src));
  _json(src,curtoele);

end;

function txseus.c_ical: boolean;
var
  src: string;
begin
  src := CurBYEle.att('src');
  resuadd(_ical(src));
  //writeln('didiical:'+src+'zzzzzzzzzzz');

end;

function txseus.c_markdown: boolean;
var
  src: string;
  resu, pars: ttag;i,j:integer;



begin
  resu:=(_markdown(curbyele.vali,curbyele.att('inline')<>'false'));
  resuadd(resu);
 //  writeln('<h1>did c_markdown:</h1><pre>'+copy(_clean(resu.xmlis),1,100)+'</pre><hr/>');
   exit;

  //src := CurBYEle.att('src');
  //  src:=CurFromEle.vali;//.subs(src);
   //writeln('-----<h2>try ele: '+src+'</h2>+++++'+curbyele.xmlis+'!!!');
  //resu:=ttag.create;
  // prev:=ttag.create;
  //prev:=resu;
  //resu.subtags.add(prev);
  //resu.vari:=CurFromEle.vari;
  //resu.attributes.addstrings(CurFromEle.attributes);
  //prev.parent:=resu;
  //resu := _markdownone(src);
  pars:=(_markdownblocks(curbyele.vali));
  //writeln('<li>parsedmarkdown<xmp>',pars.xmlis,'</xmp>',pars.subtags.count,pars.vali,'XML:<xmp>',pars.listst,'</xmp>!!!');
  //resu:=ttag.create;
  //pars.saveeletofile(g_inidir+'/problemos.xml',false,'',true);
  //writeln('<li>writeto'+g_inidir+'/problemos.xml',false,'',true);
  resu:=tagparse('<div>'+pars.listst+'</div>',true,true); // gdfg
  //writeln('<li>parsed_xml<pre>',resu.xmlis,'</pre>',resu.subtags.count,resu.vali,'!!!<xmp>',resu.listxml(true,false),'</xmp>!!!');
  //recursemark(pars);
  {for i:=0 to pars.subtags.count-1 do
  begin
  writeln('<hr/><b>par:</b><pre>',ttag(pars.subtags[i]).xmlis,'</pre>');
  //resu.addsubtag(ttag(pars.subtags[i]).vari,_markdownone(ttag(pars.subtags[i]).vali));
  resu.subtags.add(_markdownone(ttag(pars.subtags[i]).vali));
  end;}
  //writeln('Markedup:<pre>',pars.xmlis,'</pre><hr/>',pars.subtags.count,pars.vali,'!!!');
 // if curbyele.vali<>'' then resu := _markdownone(curbyele.vali) else
 // resu := _markdownone(curfromele.vali);
  resuadd(resu);
end;

function txseus.c_parse: boolean;
{D: takes a string, produces an xml-element
  handles xml, yaml-type stuff, and markdown (depending on command attributes)
  -usage: not uncommon
  -plans: more formats? Better syntax for specifying format
}
var
  newtag, oldt, mtag, aputag: ttag;
  aps: string;
  j, k: integer;
  apustl: TStringList;
begin
  try
   // writeln('<h1>DOPERSE</h1>');
    oldt := CurBYEle;
    //newtag := ttag.Create;
    //newtag.vari := oldt.att('tag');
    if oldt.att('eletext') <> '' then
    begin

      //aps:=CurFromEle.subs(oldt.att('eletext'));
      aputag := CurFromEle.subt('text');
      //aps:=CurFromEle.subs('text/@alltext()');
      aps := aputag.vali;
      //for j := 0 to CurFromEle.subtags.Count - 1 do
      //  writeln(ttag(CurFromEle.subtags[j]).vari+'<xmp>'+ttag(CurFromEle.subtags[j]).vali+'</xmp>');
      //  writeln('XXX<xmp>'+aputag.listraw+'</xmp>/XXX');
      //  writeln('APPA<xmp>'+aps+'</xmp>/XXX');
    end
    else
    if oldt.att('enttext') <> '' then
    begin
      //writeln('enttextat<xmp>'+oldt.att('enttext')+'</xmp><hr/>' );
      //writeln('et<xmp>'+_unclean(oldt.att('enttext'))+'</xmp>' );
      //aps := '<div>' + _unclean((oldt.att('enttext')) + '</div>');
      aps :=  _unclean(oldt.att('enttext'));
      //newtag.dontclosetags:=true;
      //writeln('txt<xmp>'+oldt.att('enttext')+'</xmp><hr/>' );
      //writeln('<h1>toPARSE</h1><xmp>'+aps+'</xmp><hr/><h1>/toPARSE</h1>' );
    end
    else
      aps := oldt.att('text');
    if oldt.att('entities') <> '' then
    begin
      aps := _unclean(aps);
      //writeln('<h1>toPARSE</h1><xmp>'+aps+'</xmp><hr/><h1>/toPARSE</h1>' );
    end;
    //newtag.parse(aps,true,false);
    if oldt.att('markdown') <> '' then
    begin
      newtag := _markdown(aps,true);//newtag, 0);
    end
    else
     {if oldt.att('yaml')<>'' then
     begin
        //writeln('parsing yaml:::');
        apustl:=tstringlist.create;
        try
        apustl.text:=aps;
        try
        newtag.parseyaml(apustl);
        //listwrite(newtag);
        finally
          //apustl.Free;
        end;
        except
          writeln('FAILED PARSEYAML');
        end;
     end else}
    if oldt.att('format') = 'xmlis' then
    begin
      //writeln('<h1>parsing xmlish::</h1>');
      apustl := TStringList.Create;
      try
        apustl.Text := aps;
        try
          newtag := tagparsexmlis(apustl);
          //writeln('xmp>'+newtag.listraw+'</xmp>');//(newtag);
        finally
          //apustl.Free;
        end;
      except
        writeln('FAILED PARSExmlis');
      end;
    end
    else
    newtag := tagparse(aps, False, False);
   // writeln('DOPERSE//THIS:<xmp>'+aps+'</xmp>!!!');
    //newtag.parse(aps,true,true);
    //     t_debug:=true;
    //t_debug:=false;
    //state.trimtemplate := False;
    //writeln('DIDPARSEGOT<xmp>'+newtag.listxml(' ',false)+'</xmp>!!!');
    //listwrite(newtag);
    //writeln('<h1>markdown</h1>');
    //mtag:=_markdown(newtag);
    //listwrite(mtag);
    //writeln('<h1>markdown</h1>');
    resuadd(newtag);
   // writeln('<li>DIDPARSE<pre>'+_clean(curtoele.xmlis)+'</pre><hr/>');
    //note: newtag itself will used be returned, just subtags
    // so this did xml-fragments, but was memorymanagemantwise not wise
    //try
    //  for k := 0 to newtag.subtags.Count - 1 do
    //    resuadd(newtag.subtags[k]);
    //  newtag.clearmee;
    //except
    //  writeln('FAILED addPARSEd');
    //end;
    //listwrite(state.resta);
    //listwrite(state.resta);
    //writeln('XXXXXXXXX<xmp>'+state.resta.listraw+'</xmp>yyyyyy');
  except
    writeln('FAILED PARSE');
  end;
end;

function txseus.c_parsecdata: boolean;
{D:Parses a string, ignoring cdata-markers it includes
  -usage: cdata is deprecated, but may be needed when handling external files containing cdata
}
var
  newtag, oldt, aput: ttag;
  aps: string;
  k: integer;
begin
  try
    // newtag := ttag.Create;
    // newtag.vari := oldt.att('element');
    aput := CurFromEle;
    if CurBYEle.att('select') <> '' then
      if pos('/', CurBYEle.att('select')) = 1 then
        aput := xml.subt(CurBYEle.att('select'))
      else
        aput := CurFromEle.subt(CurBYEle.att('select'));
    aps := _nocdata(aput.getsubvals);
  except
    writeln('couldnot readcdata');
    listwrite(CurBYEle);
    listwrite(xml);
  end;
  if aps <> '' then
  begin
    newtag := tagparse(aps, True, False);
    //newtag.parse(aps, True, False);
    for k := 0 to newtag.subtags.Count - 1 do
    resuadd(newtag.subtags[k]);
    newtag.clearmee;
    newtag.free;
  end;
end;
function txseus.c_nop: boolean;
begin
end;
function txseus.c_hyphenfi: boolean;
begin
  curtoele.subtags.add(_hyphenfi(curbyele.vali));
  //writeln('<pre>',curtoele.xmlis,'</pre>');

end;

function txseus.c_text2xml: boolean;
{D: splits element content into xml.
  -plans: to be removed, c_t2x is sufficient
}
var
  newtag, acom: ttag;k:integer;
begin
   if curbyele.subtags.count>0 then
   begin
      doelementlist(curbyele.subtags);
      resuadd(_texttokens(curtoele.subs('@alltext()'),curbyele));
   end
   else newtag:=(_texttokens(curbyele.vali,curbyele));
   for k := 0 to newtag.subtags.Count - 1 do
   begin
     resuadd(newtag.subtags[k]);
   end;
   newtag.clearmee;
   newtag.free;
  //acom := CurBYEle;

  //aputag := xml.subt(acom.att('in'));
  //resuadd(_text2xml(substisubs, aputag.vali));
end;
function txseus.c_chop: boolean;
var st:widestring;i:integer;
begin
 st:=curbyele.vali;
 for i:=1 to length(st) do
  curtoele.addsubtag(st[i],'');
end;
function txseus.c_t2x: boolean;
{D: splits a string into xml based on row and column separators
  -usage: quite usefull
  -plans: to be (partly?) replaced by regexp-based commands
    and maybe an awk-type "file-splitter"
}
var
  aputag, acom: ttag;
  k: integer;
begin
  //writeln('<li>t2x!start<xmp>!'+curbyele.att('sep')+'!</xmp>',length(curbyele.att('sep')));
  //aputag := _text2xml(CurBYEle, CurBYEle.att('text'));
  aputag:=_text2xml(curbyele, curbyele.vali);
  for k := 0 to aputag.subtags.Count - 1 do
    resuadd(aputag.subtags[k]);
  //writeln('<hr><h1>did</h1><pre>',aputag.xmlis,'<hr>');
end;


{function txseus.c_field2xml: boolean;
D: probably unnecessary, about the same as t2x

begin
  _field2xml(substisubs, xml);
end;
}

//function txseus.c_field2html (state:tstate): boolean;
{D: parses old type text-markup
 -usage: depreciated, use parse/markdown instead
}
{
var txtx:tstringlist;nt,atag,xform:ttag;fi:string;
// res:=tstringslist;
begin
 try
  try
   atag:=substisubs ( state );
   xform:=xml;
   txtx:=tstringlist.create;
   txtx.text:=_t2h(atag,xform,nil,self,state);
   except writeln('failed t2h');   end;
   fi:=atag.att('out');
  except writeln('failed 1field2html1');
  end;
  try
     txtx.insert(0,'<div>');
     txtx.add('</div>');
     except
      try
       txtx:=tstringlist.create;
       txtx.insert(0,'<div>');
       txtx.add('</div>');
     except writeln('failed insert anew');
     end;
   end;
  try
 nt:=ttag.create;
 nt.vari:=fi;
  except writeln('failde to create');raise
 end;

  try
 nt.parse(txtx.text,false,false);
 except writeln('failde to parse');
 end;
try
 xform.subtagsadd(nt);
 except writeln('failde to add html to form');
 end;
 txtx.free;
end;
}


function txseus.c_writehidden: boolean;
{D: Creates a form with input-elements for all elements that the calling form contained
  very ad hoc for some old need
   -plans: to be removed. Easy to write the code in xseus when needed
}
var
  j: integer;
  acom: ttag;
begin
  acom := CurBYEle;

  writeln('<form action=' + acom.subs('action') + ' method="post">');
  for
    j := 0
    to
    tserving(x_serving).requestheaders.Count - 1 do
    writeln('<input type=hidden value="' +
      _clean(cut_rs(tserving(x_serving).requestheaders[j])) +
      '" name="' + cut_ls(tserving(x_serving).requestheaders[j]) + '">');
  writeln('<input type=checkbox checked=checked name=previewed>');
  writeln('<input type=submit value=' + acom.subs('submit') + '>');
  writeln('</form>');
end;


function txseus.c_html: boolean;
{D: synonyM to "add out=browser"
}
var
  acom: ttag;
begin
  acom := CurBYEle;
  //acom.attributes.add(ns+'to=browser');
  //state.browseroutput := True;
  //acom.attributes.add(ns+'to=browser');
  //acom.attributes.add('element=div');  //this must be unnecessary?
  // acom.valitovalue;
  //element's starting text content converted to a text-element (nameless element)
  acom.vari := 'add';
  c_add;
  // writeln('<li>didhtml</li><xmp>'+CurBYEle.xmlis+'</xmp><hr/>//');

end;

{function txseus.nosetstatex: boolean;
var
  k: integer;
  aps, apval: string;
begin
  state.setstate(self);
  exit;
end;
}
function txseus.c_del: boolean;
var  t:ttag;
begin
    if curfromele=nil then exit;
    t:=curfromele.parent;
    t.subtags.remove(curfromele);
    curfromele.killtree;
    curfromele:=t;

end;

function txseus.c_add: boolean;
{D:
 -usage: with apply, the most common command. But replaced by c_to maybe
}
var
  newtag, aputag, acom: ttag;
  i, xop: integer;//turha:tstringlist;
begin
  try
    CurToEle.vali := CurBYEle.vali;
    dosubelements;
  except
    writeln('<li>Could not add element');
    raise;
  end;

end;




function txseus.c_attribute: boolean;
{D: adds an attribute to current result element
  problem: curtoele is the one where we are adding, not what we are adding
}    var ele:ttag;
begin

  {if curbyele.att('element')<>'' then
  begin
     ele:=staselect(curbyele.att('element'),curfromele);
  end  else ele:=curtoele;
  if curbyele.att('ord')<>'' then
  begin
    ele.setatt(CurBYEle.att('name'),curbyele.att('value'));
  end else }
  curtoele.setatt(CurBYEle.att('name'), CurBYEle.att('value'));
  //wrITELN('<LI>SETATT:',curtoele.vari,'<pre>'+CURTOELE.XMLIS+'</pre><hr>!'+CURTOELE.vari+'*'+curtoele.parent.vari);
end;
function txseus.c_attributes: boolean;
{D: adds  attribute of curby to curto
}    var ele:ttag;i,ai:integer;
begin
  curtoele.attributescopyfrom(curbyele);
end;

function txseus.c_attributename: boolean;
{D: adds an attribute to current result element
}    var ele:ttag;
begin
  if curbyele.att('element')<>'' then
  begin
     ele:=staselect(curbyele.att('element'),curfromele);
  end  else ele:=curfromele;
  //try
  //  wrITELN('<LI>SETATTname:',ele.vari,'<pre>'+ELE.XMLIS+'<hr>!'+curbyele.xmlis+'</pre>');
  //except
  //  wrITELN('<LI>failSETATTele:',CURBYELE.ATT('element')+'<hr>!'+curbyele.xmlis+'</pre>');
  //end;
  try
  Ele.setattname(CurBYEle.att('old'), CurBYEle.att('new'));
  except
    wrITELN(      '<LI>NOATTname:',ele.vari,'<pre>'+ELE.XMLIS+'<hr>!'+curbyele.xmlis+'</pre>');
  end;
end;
function txseus.c_elementname: boolean;
{D: adds an attribute to current result element
}    var ele:ttag;
begin
  {if curbyele.att('element')<>'' then
  begin
     ele:=staselect(curbyele.att('element'),curfromele);
  end  else ele:=curfromele;}
  curfromEle.vari:= trim(CurBYEle.vali); //att('new');
  //wrITELN('<LI>SETelename:',ele.vari,'<pre>'+ELE.XMLIS+'<hr>!'+curbyele.xmlis+'</pre><li>');
end;
function txseus.c_value: boolean;
{D: adds an attribute to current result element
}    var ele:ttag;
begin
  if curbyele.att('element')<>'' then
  begin
    //wrITELN('<LI>changeele:',curfromele.XMLIS,'</li>');
     ele:=staselect(curbyele.att('element'),curfromele);
  end  else ele:=curtoele;
  Ele.vali:=CurBYEle.vali;//att('new');
  //wrITELN('<LI>changetext:',ele.vari,'<xmp>!'+ele.parent.xmlis+'!</xmp><hr>');
end;

function txseus.c_setid: boolean;
{D: adds an id-attribute to current result element and to id-hash
}
begin
  //writeln('<li>GONNNASET to:',curtoele.xmlis,'/by:',curbyele.xmlis,'</li>');
  CurToEle.setatt('id', CurBYEle.att('id'));
  x_ids.addobject(curtoele, CurBYEle.att('id'));
end;

function txseus.c_replace: boolean;
{D: replaces
}
var
  acom: ttag;
begin
  try
    acom := CurBYEle;

    _replace(acom, xml, self);

    ;
  except

    writeln('<li>failed to replace');
    listwrite(acom);

  end;
end;


function txseus.c_move: boolean;
{D: Moves an element to another place in the xml-tree
  -status: seems to be unfinished, probably works for some application
    but needs to be made more general
}
var
  from, toele: ttag;
  froms, toeles, aps: string;
begin
  try
    froms := CurBYEle.att('from');
       {if eles<>'' then
        begin
           ELE:=state.selroot(eles,CurFromEle,aps,false);
           ele:=ele.subt(aps);
       end
       else ele:=CurFromEle;
       toeles:=CurBYEle.att('to');
       if toeles<>'' then
        begin
           toELE:=state.selroot(toeles,CurFromEle,aps,false);
           toele:=toele.subt(aps);
       end
       else toele:=CurFromEle;}

    //from := staselect(eles, CurFromEle);
    toeles := CurBYEle.att('to');
    if toeles <> '' then if froms <> '' then
      //toele := staselect(toeles, CurFromEle);
 //   _moveold(CurBYEle, ele, toele);
   _move(froms,toeles,curfromele);
    ;
  except

    writeln('<li>failed to moveup');
    //listwrite(CurBYEle);

  end;
end;


function txseus.c_save: boolean;
{D: saves xml to file, used for saving current htme (don't use @element-attribute to avoid writing over your htme)
 -usage: very common
 -Seealso: savefile
 -status:
 -lastfix: save/savefile needs to be split into two (or more) separate commands,
  one for saving the current data-node to htme-file, and other to save other elements
   (spelling-errors may destroy the htme-file, and file-locking should be handled differenty)
   unlocking produces currenty unnecesasry error-messages

}
begin
try
  //writeln('<li>saving:','!</li>');
  //logwrite('Saving:'+x_objectfile);
  //writeln('<li>saving:',x_objectfile,'!</li>');
  _save(CurBYEle, x_data, x_objectfile, xml);
  //writeln('<li>saved:',x_objectfile,'!',x_data.xmlis+'!</li>');
except
  writeln('<li>couldnotsave:',x_objectfile,'!</li>');

end;
end;

function txseus.c_reademsg: boolean;
begin
  writeln('<h1>readwemsg</h1>');
  //indy  resuadd(_emsgtoxml(CurBYEle.att('file'), CurBYEle.att('dir')));
  //logwrite('***'+state.resta.listraw);

end;

function txseus.c_savefile: boolean;
{D: saves xml to file, used to write external files
  -atts:
  --backups: number of versions to keep
  --
 -usage: very common


}
begin
  _save(CurBYEle, x_data, '', xml);
  // g_locs.freefile(ifile);
end;

function txseus.c_nosave: boolean;
{D: tell xseus that htme will not be saved so it can unlock the htme-file.
  Better to use c_unlock directly.
  plans: remove / add similar functionality to handler-elements lock=false -attribute
   (or missing lock=true? which should be default)
}

begin
  logwrite('locks1:' + x_mylocks.Text);
  try
    g_locks.freefile(x_objectfile, x_mylocks);
  except
    logwrite('failfreefile');

  end;
  try
    //   locks.Delete(locks.IndexOf(ifile));
  finally
    logwrite('locks2:' + x_mylocks.Text);

  end;
end;



function txseus.c_savesession: boolean;
{D: Outdated function from cgi days when session were saved in separate files.
  -plans: something like this is still needed so session-info can be saved
   over xseus-restarts
}
var
  aputag, oldto: ttag;
  ok: boolean;
begin
  aputag := ttag.Create;
  oldto := curtoele;
  CurToEle := aputag;
  dosubelements;
  ttag(aputag.subtags[0]).saveeletofile(g_xseuscfg.subs('users') +
    CurBYEle.att('name') + '.usr', true, '','  ', False,false);
  Result := ok;
  aputag.killtree;
  curtoele := oldto;
end;


function txseus.c_listsession: boolean;
{D: lists the session tag,
    -usage: debugging.
    - security: should apps be able to list what others have added to the session? (it's for the same user. shoulnot be problem)
}
begin
  //writeln('<pre>', x_session.xmlis, '</pre>');
  curtoele.subtags.add(x_session.copytag);
end;

function txseus.c_session: boolean;
{D: Adds an element to session tag, marking which htme-file is responsible the addition
    -usage: could be very usefull, but currently probably not fuctioning properly
}

begin
   result:=auth_session;
end;

function txseus.c_list: boolean;
var xlist:tstringlist;apustag : ttag;
begin
  xlist:=tstringlist.create;
  try
  curfromele.listxmlish('', xlist,false);
  apustag := ttag.Create;
  apustag.vari := curbyele.att('tag');
  apustag.vali := xlist.Text;
  //+ xform.xmlis;
  //writeln('</div>');
   resuadd(apustag);
   finally xlist.free;end;
end;
//procedure _listform(acom,xform:ttag);
function txseus.c_debugids: boolean;
begin
  x_ids.list;
end;
function txseus.c_debugging: boolean;
begin
  t_debug:=not(t_debug);
end;

function txseus.c_debug: boolean;
{D: List xml content.
   -usage: Common.  For debugging only.
}
var xsistr:string;apustag:ttag;
begin
   apustag := ttag.Create;
   apustag.vari := 'xmp';
   apustag.vali := curfromele.xmlis;//+'<hr/>'+x_bookmarks.xmlis;
            //+ xform.xmlis;
            //writeln('</div>');
            resuadd(apustag);


  end;

{var
  i: integer;
  xmllist,
  apustl: TStringList;
  acom, xform, apustag: ttag;
  aps: string;
begin
  try
   i:=0;
    acom := CurBYEle;
    xform := xml;
    xmllist := TStringList.Create;
    try
      //if acom.att('indent')='true' then
      if acom.att('xml') = '' then
      begin
        //writeln('<div style="margin:5em;background:yellow">');
        //if acom.att('element') = '' then
          xform := CurFromEle;
          if xform=nil then exit;
        //else
        //  xform := staselect(acom.att('element'), CurFromEle);
        //begin
        //   xform:=state.selroot(acom.att('element'),CurFromEle,aps,false);
        //   xform:=xform.subt(aps);
        //end;

        apustl := TStringList.Create;
        try
          //xform.listYAML('',apustl);
          xform.listxmlish('    ', apustl,false);
          if (acom.att('out') = '') then
          begin
            apustag := ttag.Create;

            apustag.vari := 'xmp';
            apustag.vali := apustl.Text;
            //+ xform.xmlis;
            //writeln('</div>');
            resuadd(apustag);
          end
          else
            apustl.savetofile(acom.att('out'));
          //writeln('<hr/>didxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
          exit;
          //writeln('/<pre><h1>parsed</h1>',apustl.count);
          //apustl.text:=adjustlinebreaks(apustl.text);
          //writeln('/<pre><h1>parsed</h1>',apustl.count);
          //aputag:=ttag.create;
          //aputag.parseyaml(apustl);
          // writeln('<h1>lr</h1><ul>', aputag.ashtml,'</ul>');
        finally
          apustl.Free;
        end;
        //_listform(acom,aputag);
      end
      else

      if acom.att('indent') = 'all' then
      begin
        apustl := TStringList.Create;
        try
          x_handlers.listxmlish('', apustl,false);
          writeln('xmlsih<xmp>');
          writeln(apustl.Text);
          writeln('</xmp>');
        finally
          apustl.Free;
        end;
        exit;
      end
      else
      if acom.att('root') <> '' then
        xmllist.add('<' + acom.att('root') + '>');
      if acom.att('parent') = '' then
      begin
        if acom.att('element') = '' then
        begin
          xform.list('', xmllist);
          writeln('<h1>List</h1><xmp>' + xform.listxml('  ', False,true) + '</xmp>');
        end
        else
        begin
          //xform:=xform.subt(acom.att('element'));
          xform := CURFROMELE;// staselect(acom.att('element'), CurFromEle);
          if xform <> nil then
          begin
            if acom.att('format') = 'xmlis' then
              writeln('<xmp>LisTform' + xform.xmlis + '</xmp>')
            else
              writeln('<xmp>LisTform' + xform.listxml('  ', False,true) + '</xmp>');
            xform.list('', xmllist);
          end;
        end;
        exit;
      end
      else
      begin
      end; //code below makes no sense? parent?
      if acom.att('root') <> '' then
        xmllist.add('</' + acom.att('root') + '>');
      if (acom.att('out') = '') then
      begin
        writeln('<h1>LIST</h1><xmp>');
        for i := 1 to xmllist.Count - 1 do
          writeln(xmllist[i]);
        writeln('</xmp>end');
      end
      else
        xmllist.savetofile(acom.att('out'));

    except
      writeln('Problems: listform');
    end;
  finally
    xmllist.Clear;
    xmllist.Free;
    //writeln('didlist');
  end;
end;

end;
}

{function txseus.c_list (state:tstate): boolean;
begin
    _listform ( CurBYEle , xml ) ;
end;
}

//procedure _listparts(acom,xform:ttag);
function txseus.c_listparts: boolean;
{D: one (currently probably best) of several attemps to
  create an effective way to glue together html-content and page/navigation  templates.
  Saves a file in several parts so the parts can later be copied using xse:copyfiles
  -status: needs better syntax and more options for naming the partial files
}
var
  xmllist: TStringList;
  outfile: string;
  acom, xform: ttag;
begin
  try
    acom := CurBYEle;
    xmllist := TStringList.Create;
    try
      if acom.att('root') <> '' then
        xmllist.add('<' + acom.att('root') + '>');
      outfile := acom.att('outfile');
      //if outfile = '' then
      //  outfile := state.outfile;
      if outfile = '' then
        exit;

      if acom.att('parent') = '' then
      begin
        if acom.subtags.Count > 0 then
        begin
          xform := doone(acom.subtags[0]);
          //listwrite(xform);
          xform.listparts('  ', outfile, xmllist, acom.att('splitat'));
          //writeln('<li>listedparts</li>');
        end
        else
        if acom.att('element') = '' then
          CurFromEle.listparts('  ', outfile, xmllist, acom.att('splitat'))
        else
        begin
          xform := xml.subt(acom.att('element'));
          xform.listparts('  ', outfile, xmllist, acom.att('splitat'));
        end;
      end
      else
      begin
      end;
      if acom.att('root') <> '' then
        xmllist.add('</' + acom.att('root') + '>');
      xmllist.savetofile(outfile);
    except
      writeln('Problems: listparts');
    end;
  finally
    xmllist.Clear;
    xmllist.Free;
  end;
end;




//function txseus.c_listparts (state:tstate): boolean;
//begin
//    _listparts ( CurBYEle , xml ) ;
//end;


function txseus.c_listhandler: boolean;
{D: lists current handler
 -usage: Debugging
}
begin
  //listwrite(CurBYEle.parent);
  writeln('<pre>',curbyele.parent.xmlis,'</pre>');

end;


function txseus.c_listhandlers: boolean;
{D: lists current xse-file
 -usage: Debugging
}
begin
  writeln('<xmp>',x_handlers.xmlis,'</xmp>');
  //listwrite(x_handlers);
end;

function txseus.c_httpget: boolean;
{D: gets external file via http using synapse -i-n-d-y- http-client
 -plans: currenty places the resulting string (unparsed) into an element.
  something more elegant is needed. Probably better make an function out of this.
 -seealso: To get parsed content, use xse:from file="http:xxx"
}
var
  apust, ele, url: string;
  newt: ttag;
begin
  writeln('<li>try http:' + curbyele.att('url') + '!</li>' + curbyele.xmlis);
  url := CurBYEle.att('in');
  if url = '' then
    url := CurBYEle.att('url');
  //writeln('get url_'+url);
  if pos('https://', url) = 1 then
    apust := _httpsget(url, -1, TStringList(CurBYEle.getattributes))
  else
  begin
    if pos('http://', url) <> 1 then
      url := 'http://' + x_host + url;
    apust := _httpget(url, -1, TStringList(CurBYEle.getattributes));
  end;
  //writeln('got_'+apust);
  ele := CurBYEle.att('element');
  if ele = '' then
    ele := 'httpgot';
  newt := ttag.Create;
  newt.vari := ele;
  newt.vali := apust;
  resuadd(newt);
  //writeln('<pre>'+CurToEle.xmlis+'</pre>');
  // state.resta. addsubtag(ele, apust )
end;

function txseus.c_httppost: boolean;
{D:
 -status: unfinished
 -plans: add some clever mechanism to convert the form-element to http-formfield-format
}
var
  res: string;
begin
  writeln('<li>try HTTPS:' + curbyele.att('url') + '!</li>' + curbyele.xmlis);
  _httppost(curbyele.att('url'), '<hello>there</hello>', nil, False, res);
  writeln('RES:<xmp>' + res + '</xmp><hr/>');
  //HttpPostBinary(const URL: string; const Data: TStream): Boolean;
end;

function txseus.c_httpupload: boolean;
{D: sends raw binary data to given address
 -status: unfinished
 -plans: add some clever mechanism to convert the form-element to http-formfield-format
}

var
  res: string;
begin
  logwrite('<li>try RAWUPLOAD:' + curbyele.att('url') + '!</li>' + curbyele.xmlis);
  try
  _httpupload(curbyele.att('url'), curbyele.att('file'), nil, False, res);
  except writeln('<h3>failed httpupload:',curbyele.att('file'),'/to:',curbyele.att('url'),'</h3>');end;
  //logwrite('RES:<xmp>' + res + '</xmp><hr/>');
  //HttpPostBinary(const URL: string; const Data: TStream): Boolean;

end;

{var
  ok: boolean;
  aputag, newt, oldto: ttag;
  apust, apust2, res: string;
begin
  //writeln('<h1>httpg</h1><xmp>'+CurBYEle.listraw+'</xmp>___');
  aputag := ttag.Create;
  aputag.vari := 'xxx';
  oldto := curtoele;
  CurToEle := aputag;
  doelements;
  apust2 := aputag.listst;
  //apust := _httppost ( CurBYEle . att ('url' ) ,CurBYEle . att ('server' ) , CurBYEle . att ('path' ) , apust2 , CurBYEle . att ('headers' ),true ) ;
  apust := _httppost(curbyele.att('url') + curbyele.att('server') +
    curbyele.att('path'), apust2, TStringList(curbyele.getattributes), True, res);
  //writeln('<li>httppost'+CurBYEle . att ('url' ));
  newt := ttag.Create;
  newt.vali := apust;
  aputag.killtree;
  curtoele := oldto;
  resuadd(NEWT);
end;
}

function txseus.c_httpspost: boolean;
{D: still experimental. httppost seems to do https already (or tries to, anyway)
 -plans: hard work with certificates probably needed before this will work
}
var
  apust, res: string;
  newtag: ttag;
begin
{
  newtag := ttag.Create;
  newtag.vali := _httpspost(CurBYEle.att('url') + CurBYEle.att(
    'server') + CurBYEle.att('path'), '', TStringList(CurBYEle.getattributes),
    True, res, xx_connections);
  //newtag.vali := _httpspost(CurBYEle.att('url') + CurBYEle.att(
  //  'server') + CurBYEle.att('path'), '', CurBYEle.attributes, True,
  //  res, nil);  //something vital missing for https .. x_connections (watever is should be)
  newtag.vari := '';//'value';
  resuadd(newtag);
  //newtag:=ttag.create;
  //newtag.vali:=_httpspost(CurBYEle.att('url')+CurBYEle.att('server')+CurBYEle.att('path'),'',CurBYEle.attributes,true,res,x_connections);
  //newtag.vari:='value';
  //resuadd(newtag);

  //_httpspost(turhahttp,CurBYEle.att('url'),'','','','',true);
  }
end;

function txseus.c_httphead: boolean;
{D: retrieves  headers only of a http-call  and builds a result element
 -usage: rss-readers etc that need to check dates etc before starting download
}
begin
  //state.resta.subtags.add(
  resuadd(_httphead(CurBYEle.att('url'), nil));
  //listwrite(state.resta.subtags[state.resta.subtags.count-1]);
end;

function _getsoap(acom: ttag): ttag;
{D:
}
var
  asoap: tsoap;
  ast: string;
begin
  asoap := tsoap.Create(acom.att('host'), acom.att('action'),
    acom.att('server'), acom.att('path'), acom);
  ast := asoap.getsoup;
  Result := tagparse(ast, True, False);
  //Result := ttag.Create;
  //Result.parse(ast, True, False);
  //Result := ttag(Result.subtags[0]);
  Result := ttag(Result.subtags[0]);
  Result := ttag(Result.subtags[0]);
end;

function txseus.c_soaprpc: boolean;
{D:
}
var
  ok: boolean;
  aputag: ttag;
begin
  aputag := _getsoap(curbyele);

  begin
    xml.subtags.add(aputag);
    if CurBYEle.att('element') <> '' then
      aputag.vari := CurBYEle.att('element')
    else
      aputag := aputag.subtags[0];

  end;
end;


function txseus.c_stop: boolean;
{D: xse-start / xse-stop mechanism allows to insert elements even when
 it is not yet known when they will be closed. Quite powerfull, and quite complicated
}
var
  starttag,tmpfrom: ttag;
  i,apui: integer;
  par: ttag;
  testst,test:string;
begin
 //  if t_debug then writeln('<li><ul>');
  //test:=inttostr(random(100));
  //logwrite('astopping');
  if x_started.elems.Count > 0 then
  begin
    //starttag := ttag(started[started.Count - 1]);
    try
    //if t_debug then
     starttag := ttag(x_started.getele);
     //writeln('<li>!:<b>',curfromele.head,'</b>[', x_started.Count,']/laststarted:', starttag.head,'   ///ocurto:',curtoele.head,'</li>');
      if curbyele.att('if')<>'' then
      while starttag<>nil  do
      begin
        apui:=1;
        testst:=curbyele.att('if');
        {INFIX tmpfrom:=curfromele;
        curfromele:=starttag;
        test := _p_infix(testst, apui, self, '');}
        test:=parsefromele(starttag, testst);
        //curfromele:=tmpfrom;
        //if test='1' then
        //writeln('<li>STOP[', x_started.Count,']<b>',curfromele.att('ind'),'=',tmpfrom.att('ind'),'/</b>/test:<em>:', testst,'</em>//',starttag.head+'///'+curfromele.head)
        //else
        //writeln('<li>nostsop<b>',curfromele.att('ind'),'=',tmpfrom.att('ind'),'/</b>/test:<em>:', testst,'</em>//',starttag.head+'///'+curfromele.head);
       //if strtointdef(starttag.att('if'),0)>strtointdef(curtoele.att('test'),0) then  exit;
        if test<>'1' then exit;
        CurToEle := x_started.getpar;

        //writeln('<li>STOPif[', x_started.Count,']',curtoele.head);
        x_started.Delete;
        x_started.laststart:=false;
        if x_started.elems.count>0 then starttag := ttag(x_started.getele) else exit;
     end;

    except writeln('failed to report stop');  end;
    //writeln('<li>stopthis:',started.count,' curresta:', CurToEle.xmlis,'<li>started:@',starttag.xmlis,'</li>!!!');
    //note @element - attribute not working as expected - it tries to match to parent of started
    //if (CurBYEle.att('element') = '') or (CurBYEle.att('element') =   starttag.vari) then
    //begin
      //par := CurToEle.parent;
      //writeln('<li>c_stop:' + starttag.xmlis, '!<hr/>', curtoele.xmlis, '!</li>');
  //TEMP COMM OUT ???????????????????????????????????????
   //writeln('<!--stop:',starttag.head,'/for:',curtoele.head, '-->');
    starttag := ttag(x_started.getpar);
    //curtoele.addsubtag('stopping',starttag.vari+'/'+test);
    CurToEle := starttag;//.parent;
    //curtoele.addsubtag('stopped',starttag.vari+'/'+test);
    x_started.Delete;
    x_started.laststart:=false;
    //writeln('<li>STOP[', x_started.Count,']<b>',curtoele.head);
  end;// else writeln('<!--nothing to stop-->');
  //if curtoele=nil then writeln('<li>back to browser');
  //if t_debug then
  //writeln('<li><b>diddoSTOP</b>, nowto::!!<small>',curtoele.xmlis,'</small>!!', x_started.Count,x_stopped.count,'!!</li>');
end;

function txseus.c_stopall: boolean;
{D: xse-start / xse-stop mechanism allows to insert elements even when
 it is not yet known when they will be closed. Quite powerfull, and quite complicated
}
var
  starttag: ttag;
  i,sts: integer;
begin
 logwrite('xstopping');
 if x_STARTED.pars.Count > 0 then
    CurToEle := x_startED.PARS[0];
 //sts:=x_started.count-1;
 logwrite('stopping');
 sleep(100);
 x_started.pars.clear;
 x_started.elems.clear;
 // if (upto>0) and  (x_started.elems.count>0) then
 //  writeln('<li>stoppall:',x_started.elems.count,'!!!',ttag(x_started.elems[0]).xmlis+'???');
  //writeln('<li>stopall:',x_started.pars.count,curtoele=nil);
  //if curtoele<>nil then writeln('<li>cur:',curtoele.xmlis);
 {for i:=sts downto 0 do
 begin
   x_started.pars.delete(i);
   x_started.elems.delete(i);


 end;
 }
 { while x_started.ELEMS.Count > 0 do
  begin
    //starttag := ttag(started[started.Count - 1]);
    //CurToEle := starttag.parent;
    //state.starts := state.starts - 1;
    //started.Delete(started.Count - 1);
   // writeln('<li>deleting started');
    x_started.Delete;
  end;}
  x_started.laststart:=false;
  //if (upto>0) and (x_started.elems.count>0) then
  //writeln('<li>stoppedall:',x_started.elems.count,'!!!',ttag(x_started.elems[0]).xmlis+'???');
end;

function txseus.c_start: boolean;
{D: xse-start / xse-stop mechanism allows to insert elements even when
 it is not yet known when they will be closed. Quite powerfull, and quite complicated
}
  function _deepest(ele: ttag): ttag;
  begin
    if (ele.subtags.Count = 0) or (ele.att(ns+'start')='here') then
      Result := ele
    else
      Result := _deepest(ele.subtags[ele.subtags.Count - 1]);
  end;

var
  newt, oldt, aput: ttag;i:integer;

begin
  try
   // aput := ttag.Create;
   // aput.parent:=curtoele.parent;
    oldt := curtoele;
   // curtoele := aput;
    //if t_debug then
    //writeln('<li><b>startunder::',x_started.elems.count, oldt.head,'</b> </li>');
    dosubelements;
    //writeln('<li><b>didsub::',x_started.elems.count, curtoele.xmlis,'</b> </li>');
    //if aput.subtags.Count=0 then begin writeln('<!--nothing to start-->');exit;end;
   // newt := (aput.subtags[0]);
    newt := (curtoele.subtags[curtoele.subtags.count-1]);
  except
    writeln('failed xse:start /what to start?');
  end;
  try
    newt.parent := oldt;
    //starts := state.starts + newstate.starts;
    //newt := _deepest(newt);
    //oldt.subtags.add(newt);
    CurToEle := _deepest(newt);
    //CurToEle := (newt);

    //if x_started.count<4000 then
    //for i:=0 to 50000 do
    x_started.add(curtoele, oldt);
    x_started.laststart:=true;
//    aput.clearmee;  //if aputag.subtags.count>1 they are not cleared!
   // if x_stopped.count>0 then x_stopped.delete;
    //if t_debug then
    //writeln('<li><b>STARTED::::',x_started.count, curtoele.head,'    /pare:', oldt.head,'</b>'+x_started.getpar.xmlis+'</li></ul>');
  except
    writeln('failed xse:start');
  end;
end;
{function txseus.c_starthere: boolean;
begin
  x_started.add(curtoele, oldt);

end;
}
function txseus.c_nooutput: boolean;
{D: stops writing output to client
  -status: currently not workin
  -plans: quite easy to re-implement
  -usage: maybe usefull for some "background tasks" eg. timer-driven tasks
}
begin
  Assign(output, 'nul');
end;


function txseus.c_resumeoutput: boolean;
{D: complement to nooutput
}
begin
  Assign(output, '');
end;

function _xmlrpc(acom: ttag; host: string): ttag;
var
  headers: TStringList;
  msg: string;
  server, path, apust, url, res: string;
begin
  headers := TStringList.Create;
  server := acom.att('server');
  path := acom.att('path');
  url := acom.att('url');
  msg := acom.listst;

  msg := '<?xml version="1.0"?>' + crlf + '<methodCall>' + '<methodName>' +
    acom.att('method') + '</methodName>' + msg + '</methodCall>';
  //headers:='User-Agent: Xseus'+crlf+
  //'Host: '+ server +crlf+
  //'Content-Type: text/xml'+crlf+
  //'Content-length:'+inttostr(length(msg))+crlf+crlf;
  headers.Add('User-Agent: Xseus');
  headers.Add('Host: ' + server);
  headers.Add('Content-Type: text/xml');
  headers.Add('Content-length:' + IntToStr(length(msg)));
  apust := _httppost(url + server + path, msg, headers, True, res);
  //Result := ttag.Create;
  //Result.parse(apust, False, False);
  Result := tagparse(apust, False, False);
  listwrite(Result);
  headers.Free;
end;
//function getvalstring(in:ttag;out:ttag);


function txseus.c_xmlrpc: boolean;
{D: retrieves content via xmlrpc-protocol
  -status: Unknown. Not used in ages, no idea whether works still.
  -usage: could be extremely usefull
}
var
  ok: boolean;
  oldto, newtag, restag: ttag;
  headers: TStringList;
  msg: string;
  server, path, url, apust, res: string;
  i: integer;
begin
  try
    headers := TStringList.Create;
    oldto := CurToEle;
    curtoele := ttag.Create;
    CurToEle.vari := 'xmlrpc';
    ok := dosubelements;
    newtag := CurToEle;
    curtoele := oldto;
    //newtag.attributes.addstrings(curbyele.attributes);
    newtag.attributescopyfrom(curbyele);
    server := curbyele.att('server');
    path := curbyele.att('path');
    url := curbyele.att('url');
    if curbyele.att('values') = 'normal' then
      msg := ttag(newtag.subtags[0]).listraw
    else
      msg := newtag.listst;
    //writeln('raw:<xmp>',msg,'</xmp>');
    msg := '<?xml version="1.0"?>' + crlf + '<methodCall>' +
      '<methodName>' + newtag.att('method') + '</methodName>' + msg + '</methodCall>';
    //headers:='User-Agent:Xseus'+crlf+
    //'Host:'+ server +crlf+
    //'Content-Type:text/xml'+crlf+
    //'Content-length:'+inttostr(length(msg))+crlf;
    headers.add('User-Agent:Xseus');
    headers.add('Host:' + server);
    headers.add('Content-Type:text/xml');
    headers.add('Content-length:' + IntToStr(length(msg)));
    flush(output);
    //headers:='text/xml';
    apust := _httppost(url + server + path, msg, headers, True, res);
    CurToEle := tagparse(apust, False, False);
    //all rest commented out with rewrite, not tested.. xmlrpc is quite forgotten
    //probably need work when put to use
    //restag := ttag.Create;
    //restag.parse(apust, False, False);
    //restag.vari := 'xml-rpc';
    //if CurBYEle.att('element') <> '' then
    //  restag.vari := CurBYEle.att('element')
    //else
    //  restag := restag.subtags[0];
    //listwrite(restag);
    //for i := 0 to restag.subtags.Count - 1 do
    //  resuadd(restag.subtags[i]);
  except
    writeln('failed xmlrpc-call');
  end;
  headers.Free;
end;




function TXSEUS.c_rmd: boolean;
{D: removes directory
  -status: seems somewhat experimental. security considerations prevail
}
begin
end;
//-------------------
{
var dir: string;ok:boolean;



  fos: TSHFileOpStruct;
  perms:ttag;i:integer;
begin
 dir:=CurBYEle . att ('dir' );
 ok:=true;
 if pos('.',dir)>0 then ok:=false;
 if pos('..',dir)>0 then ok:=false;
 if pos('\\',dir)>0 then ok:=false;
 if pos('/',dir)>0 then ok:=false;
 if pos('%',dir)>0 then ok:=false;
 dir:= _indir ( CurBYEle . att ('dir' ) , outdiri , self,true ) ;  ZeroMemory(@fos, SizeOf(fos));
 perms:=x_commands.subt('removesubdirs');
 if (ok) and (perms=nil) then ok:=false else
 begin
   writeln(dir+'<xmp>'+perms.listraw+'</xmp>');
   for i:=  0 to perms.subtags.Count - 1 do
     if pos(ttag(perms.subtags[i]).att('subof'),dir)=1 then
      ok:=true;
    perms:=perms.subt('subof[@dir='+dir+']');
     if perms=nil then ok:=false else
        writeln(dir+perms.listraw);

 end;
 if pos(outdiri,dir)<>1 then ok:=false;
 if not ok then
  //writeln('<li>remdir:'+dir);
  begin
  writeln('<li>not ok to remove dir:'+dir);
  exit end else
  writeln('<!--ok to remove dir:'+dir+'-->');
  //                  exit;
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;
}

{

 listpossibleyears
 listpossiblenonths
    restrict years
 listpossibleweeks
   restrict years - restrict months
 listpossibledays



}
{
function __weaklyloop(star,en:tdate;count:integer;wrules:tlist):boolean; //weekly loop
var thewday,c,i:integer;
begin
 idate:=star;
 if count=0 then count:=1000;
 c:=0;
 while (idate<en) and (c<count) do
 begin
   thewday:=dayoftheweek(idate);
   writeln('date:'+datetostr(idate),'/',thewday);
   for i:=0 to wrules.count-1 do
   begin
   if thewday=integer(wrules[i]) then
   begin
    CurToEle.addsubtag('d',datetostr(idate));
    C:=c+1;
    break;
   end;
   end;
   idate:=idate+7;
 end;
end;

function __findinweek(star,en:tdate;count:integer;wrules:tlist):boolean; //weekly loop
var thewday,c,i:integer;
begin
 idate:=star;
 if count=0 then count:=1000;
 c:=0;
 while (idate<en) and (c<count) do
 begin
   thewday:=dayoftheweek(idate);
   writeln('date:'+datetostr(idate),'/',thewday);
   for i:=0 to wrules.count-1 do
   begin
   if thewday=integer(wrules[i]) then
   begin
    CurToEle.addsubtag('d',datetostr(idate));
    C:=c+1;
    break;
   end;
   end;
   idate:=idate+7;
 end;
end;
 }
{

Ekaks tutkitaan onko freq ylemmällä tasolla rajoituksia
ne huomioon ottaen tehdään lista

FROQ=YEARLY;BYMONTH=1,2;BYDAY=1,2
 tammi helmi ma ja ti
FROQ=MONTHLY;BYMONTH=1,2;BYDAY=1,1
 muuten sama, mutta jos INTERVAL kerrottu niin vuosia rajataan
 ja jos BYDAY=1MA
 eli
FROQ=YEARLY;BYMONTH=1,2;BYDAY=5MA;INTERVAL=2
  etsitään vuosittain eka maanantain, poistetaan ne jotka eivät matsää kuukausiin)
  eikun
   otetaan vuocen kaikki päivät

FREQ=YEARLY;INTERVAL=2; - listataan vuodet 2010, 2012, 2014...
  BYMONTH=1,2; oteaan kustakin vuodesta kuukaudet
  BYDAY=MA kustakin kuukaudesta maanantait

  FROQ=MONTHLY; -listataan kuukaudet
    BYMONTH=1,2; - valitaan listasta sopivat
    BYDAY=MA; kustakin kksta maanantain
    BYEAR=2010,2012


if freqs='MONTHLY' then
 - tee lista ottaen huomioon interval
  -katso onko vuosia rajattu, poista rajatut
  -katso onko viikkoja lisätty (BYWEEKNO)

}
function txseus.c_rruletolist: boolean;
var
  dtstart, dtend, idate, adate: tdatetime;
  Count: integer;
  freq, interval: integer;
  freqs, duntil: string;
  sfreq, sbyweeknum, sbymonth, sbyday, sbyyear, sbymonthday: string;

  byday, //simple weekdayrule, list of WD's: [MO TU WE TH FR SA SU ]
  bydayordr, //dayorder Num -5..-1 1..5 followed by WD - relative to MONTH of YEAR as given if FREQ
  bymonth, //monthrule: list of positive numbers 1..12
  byweeknum, // [1..52]
  bymonthday, byyearday, byby: boolean;
  ylist, mlist, wlist, dlist: TList;
  slist: TStringList;
  hstart, hend: string;
  //mday:integer;
  mm, dd, yy: word;

  function _icaldate(p_date: string): string;
  begin
    //shortdateformat:=
    Result := copy(p_date, 1, 4) + '-' + copy(p_date, 5, 2) + '-' + copy(p_date, 7, 2);
    //+' '+copy(p_date,10,2)+':'+copy(p_date,12,2)+':'+copy(p_date,14,2)+':00';
  end;

  function _icaltime(p_date: string): string;
  begin
    Result := copy(p_date, 17, 2);
  end;

  function __monthly: TList;
  var
    i: integer;
    atag: ttag;
    mmm: integer;
  begin
    if sbymonthday = ',,' then
      if sbyday = ',,' then
        sbymonthday := ',' + IntToStr(dayofthemonth(dtstart)) + ',';
    slist := TStringList.Create;
    _split(sbymonthday, ',', slist);

    //writeln('trydates:'+slist.Text,'%'+sbymonthday+'¤'+sbyday);
    decodedate(idate, yy, mm, dd);
    idate := encodedate(yy, mm, 1);
    while (idate < dtend) and (Count < 100) do //tehdään kuukausilista
    begin
      mmm := DayOfTheMonth(idate);
      for i := 0 to sList.Count - 1 do
      begin
        if slist[i] = '' then
          continue;
        //writeln('trydate:'+slist[i],'/',slist.count,datetostr(idate));

        try
          adate := idate + strtointdef(slist[i], 0) - 1;
          if adate < dtstart then
            continue;
          if adate > dtend then
            continue;
          if DayOfTheMonth(adate) <> mmm then
            continue;
          //writeln('<li>Pickdate:',datetostr(adate),'/',slist[i]);
          atag := CurToEle.addsubtag('vevent', '');
          atag.addsubtag('dtstart', datetostr(adate));
          //atag.addsubtag('dtend',datetostr(adate));
        except
          writeln('<li>invaliddate:', '/', slist[i]);
        end;

        // if pos(inttostr(dayoftheweek(idate)),byday)>0 then
        //CurToEle.addsubtag('d',datetostr(idate));
        //PITÄIS TESTATA ONKO VUOSILISTASSA
        //mlist.add(idate);

      end;
      idate := incmonth(idate);
      //COUNT:=count+1;
    end;
    slist.Free;
  end;

  function __weekly: TList;
  var
    i: integer;
    wd: integer;
    adate, wstart: tdate;
    atag: ttag;
  begin
    if sbyday = ',,' then
      sbyday := ',' + IntToStr(dayoftheweek(dtstart)) + ',';
    slist := TStringList.Create;
    _split(sbyday, ',', slist);
    wd := dayoftheweek(idate);
    //writeln('tryweeklydates:'+slist.Text,'%'+sbyday+'_'+datetostr(idate)+' ',wd,'_',dtend,datetostr(dtend));
    try

      //decodedate(idate,yy,mm,dd);
      //idate:=encodedate(yy,mm,dd-wd+1);
      idate := idate - wd + 1;
    except
      //writeln('failedencode first of week:',WD,'/',datetostr(idate),' ',yy,mm,dd-wd+1);
    end;
    //writeln('tryweekstart:',WD,datetostr(idate),' ',dayoftheweek(idate));
    //adate:=idate;
    while (idate <= dtend) and (Count < 100) do //tehdään kuukausilista
    begin
      decodedate(idate, yy, mm, dd);
      //writeln('tryweek:'+datetostr(idate),' ',count,' ',datetostr(dtend));
      for i := 0 to sList.Count - 1 do
      begin
        if slist[i] = '' then
          continue;
        //writeln('trydate:'+slist[i]);
        try
          //adate:=encodedate(yy,mm,strtointdef(slist[i],0));
          //adate:=idate+strtointdef(slist[i],1)-1;
          adate := idate + strtointdef(slist[i], 1) - 1;
          Count := Count + 1;
          atag := CurToEle.addsubtag('vevent', '');
          atag.addsubtag('dtstart', datetostr(adate));
          atag.addsubtag('dtend', datetostr(adate));
          atag.addsubtag('hstart', hstart);
          atag.addsubtag('hend', HEND);
          //atag.addsubtag('dtend',datetostr(idate));
          //atag.addsubtag('meta',datetostr(adate)+'**'+slist[i]);
         {
         //subtagsadd('vevent','');
        <dtstart>19970714T170000Z</dtstart>
        <dtendt>19970715T035959Z</dtend>
        <summary xml:lang="en_US">Bastille Day Party</summary>
        </vevent>
          }
        except
          // writeln('<li>invaliddate:',yy,mm,dd,'/',slist[i]);
        end;
        //writeln('<li>Pickdate:',datetostr(adate),'/',slist[i]);
        // if pos(inttostr(dayoftheweek(idate)),byday)>0 then
        //CurToEle.addsubtag('d',datetostr(idate));
        //PITÄIS TESTATA ONKO VUOSILISTASSA
        //mlist.add(idate);

      end;
      idate := idate + 7;
      //COUNT:=count+1;

    end;
    slist.Free;
  end;

var
  apps: TStringList;
begin
  try

    try
      dtstart := strtodate(CurBYEle.att('DTSTART'));
    except
      //writeln('failed to get dtstart',CurBYEle.att('dtstart'));
      //listwrite(CurBYEle);
    end;
    if CurBYEle.att('text') <> '' then
    begin
      try
        apps := TStringList.Create;
        _split(CurBYEle.att('text'), ';', apps);
        sbyday := ',' + apps.Values['BYDAY'] + ',';
        sbymonth := ',' + apps.Values['BYMONTH'] + ',';
        sbymonthday := ',' + apps.Values['BYMONTHDAY'] + ',';
        sbyweeknum := ',' + apps.Values['BYWEEKNUM'] + ',';
        sfreq := apps.Values['FREQ'];
        interval := strtointdef(apps.Values['FREQ'], 1);
        duntil := apps.Values['UNTIL'];
        dtend := strtodatedef(_icaldate(apps.values['UNTIL']), dtstart);
        //   writeln(apps.values['UNTIL'],'@',dtend,'|',_icaldate(apps.values['UNTIL']));
        //hstart:=

      finally
        apps.Free;
      end;
    end
    else
    begin
      try
        dtend := strtodatedef(CurBYEle.att('DTEND'), dtstart);
        sbyday := ',' + CurBYEle.att('BYDAY') + ',';
        sbymonth := ',' + CurBYEle.att('BYMONTH') + ',';
        sbymonthday := ',' + CurBYEle.att('BYMONTHDAY') + ',';
        sbyweeknum := ',' + CurBYEle.att('BYWEEKNUM') + ',';
        sfreq := CurBYEle.att('FREQ');
        interval := strtointdef(CurBYEle.att('FREQ'), 1);
        //    mday:=strtointdef(CurBYEle.att('FREQ'),1);
        //listwrite(CurBYEle);
      except
        //writeln('failed to get dtend',CurBYEle.att('dtend'));
      end;
    end;
    idate := dtstart;
    //writeln('dates_'+datetostr(dtstart),'freq:',sfreq,datetostr(dtend),'byday:',byday);
    if sfreq = 'MONTHLY' then
      __monthly
    else if sfreq = 'WEEKLY' then
      __weekly


 {//dayly loop
 while (idate<dtend) and (count<100) do
 begin
   writeln('date:'+datetostr(idate),'/',dayoftheweek(idate));
   if pos(inttostr(dayoftheweek(idate)),byday)>0 then
    CurToEle.addsubtag('d',datetostr(idate));
   idate:=idate+1;
   COUNT:=count+1;
 end;}
  except
    writeln('failed to parse recuring list');
  end;

end;

function txseus.c_md: boolean;
{D: creates a directory
  -group: fileio
}

var
  apust: string;
begin
  apust := _indir(CurBYEle.att('dir'), x_outdir, self, True);
  writeln('<!--createdir:', apust + '-->');
  if    //--CreateDirUTF8(apust ) { *Converted from CreateDir*  } then
  CreateDir(apust) { *Converted from CreateDir*  } then
    writeln('<!--MaDeDir:' + apust + '@' + getcurrentdir + '-->')
  else
  begin
    //--iffctoryExistsUTF8(apust) { *Converted from DirectoryExists*  } then
    if DirectoryExists(apust) { *Converted from DirectoryExists*  } then
      writeln('<li>directory ezists:' + apust + '</li>')
    else
      writeln('<li>failed to create directory:' + apust);
  end;
end;


function txseus.c_copyfile: boolean;
{D: does not copyfiles
  -group: fileio
  -status: the copying itself seems to have dropped oout, contains only debugging
}
var
  apust: string;
var
  inf, outf: array[0 ..255] of char;

begin
  try

    _checkfilelocation(CurBYEle, 'from,to', self, True);
  except
    writeln('<li>failed checkfileloc ' + CurBYEle.att('in'));
    exit;
  end;
  copyfile(CurBYEle.att('from'), CurBYEle.att('to'));
{  StrPCopy(inf, CurBYEle.att('from'));
  StrPCopy(outf, CurBYEle.att('to'));
  //writeln('copying:', inf, '_to:', outf);
  if not copyfile(inf, outf, False) then
    //--     if CurBYEle.att('debug')='true' then writeln('copyok:') else
    writeln('COPYFILE FAILED:', inf, '', outf)
}
{    try
        _checkfilelocation ( CurBYEle ,'from,to' , self,true ) ;

       writeln('<li>copyfile '+inf+' to '+outf);
       writeln(copyfile(inf,outf,false));
       except writeln('<li>failed to copy '+CurBYEle.att('in'));
     end;
};

end;


function txseus.c_movefile: boolean;
{D: move files
  -group: fileio
  -status: produces unnecessary debug-info. Does currently nothing in free pascal
}
begin
  try
    try

      _checkfilelocation(CurBYEle, 'in,out', self, True);
    except
      writeln('<li>failed checkfileloc ' + CurBYEle.att('in'));
    end;
    if _movefile((CurBYEle.att('in')), (CurBYEle.att('out'))) then
      _h1('did move')
    else
      logwrite('faiked move');

    ;
  except

    writeln('<li>failed to copy ' + CurBYEle.att('in'));

  end;
end;

function txseus.c_copyfiles: boolean;
{D: copies/appends several infiles to outfile.
 -usage: in conjunction with xse:listparts usefull to glueing together templates, navigation and content
 -group: fileio
}
var
  ins, outs: TStringList;
  afile: ttag;
  i: integer;
  fn: string;
begin

  ins := TStringList.Create;
  outs := TStringList.Create;
  for i := 0 to CurBYEle.subtags.Count - 1 do
  begin
    afile := ttag(CurBYEle.subtags[i]);
    fn := parsexse(afile.att('name'), self);
    try
      if afile.vari = 'infile' then
      begin
        //--if FileExistsUTF8(fn) { *Converted from FileExists*  } then
        if FileExists(fn) { *Converted from FileExists*  } then
        begin
          ins.Clear;
          ins.loadfromfile(fn);
          outs.add(ins.Text);
        end;
      end;
      if afile.vari = 'outfile' then
      begin
        outs.savetofile(fn);
        //writeln('<li>wroteoutto;',fn,'<xmp>',outs.Text,'</xmp>');
      end;

    except
      writeln('failedafile ');
      writeln(afile.vari + ' : ' + afile.att('name'), ' ', fn);
    end;
  end;
  outs.Clear;
  outs.Free;
  ins.Clear;
  ins.Free;
end;

function txseus.c_copyfilescmd: boolean;
{D: creates and runs (in separate threads?) batch-files that copy files
 -usage: maybe usefull somtimes if a lot of copying is needed and it can be done "in the background"
 -group: fileio

}
var
  ins, outs, cmd, resust: TStringList;
  acom, afile, comlist: ttag;
  i, coms, res: integer;
  acomst: string;
  didone: boolean;
begin
  writeln('<li>out:' + x_objectdir);
  comlist := CURFROMELE;//staselect(CurBYEle.att('element'), CurFromEle);

  ins := TStringList.Create;
  outs := TStringList.Create;
  resust := TStringList.Create;
  acomst := '';
  for coms := 0 to comlist.subtags.Count - 1 do
    if ttag(comlist.subtags[coms]).vari = 'copyfiles' then
    begin
      acom := comlist.subtags[coms];
      didone := False;
      for i := 0 to acom.subtags.Count - 1 do
        if ttag(acom.subtags[i]).vari <> '' then //'value' then
        begin
          try
            afile := ttag(acom.subtags[i]);
            if afile.vari = 'infile' then
            begin
              if (pos('\', afile.att('name')) <> 1) and
                (pos('..', afile.att('name')) = 0) then
              begin
                if didone then
                  acomst := acomst + ' + ' + x_objectdir + afile.att('name')
                else
                  acomst := 'copy ' + x_objectdir + afile.att('name') + ' ';
                didone := True;
              end;
            end;
            if afile.vari = 'outfile' then
              if (pos('\', afile.att('name')) <> 1) and
                (pos('..', afile.att('name')) = 0) then
                acomst := acomst + '  ' + x_objectdir + afile.att('name');
          except
            writeln('failedafile ');
            writeln(afile.vari + ' : ' + afile.att('name'));
          end;
        end;
      resust.add(acomst);
    end;
  resust.add('del ' + x_objectdir + 'xseus_tmp.bat');

  try
    resust.savetofile(x_objectdir + 'xseus_tmp.bat');
    WinExecAndWait32('cmd /c ' + x_objectdir + 'xseus_tmp.bat >' +
      x_objectdir + 'xseus_tmp.res', False);
  except
    writeln('<li>copycmd failed: ', res, 'copycmd', x_objectdir + 'xseus_tmp.bat');
  end;
  outs.Clear;
  outs.Free;
  ins.Clear;
  ins.Free;
  resust.Clear;
  resust.Free;
end;



function txseus.c_renamefile: boolean;
{D: renames files. (freepascal?)
  -group: fileio
}
begin
  try

    _checkfilelocation(CurBYEle, 'in,out', self, True);
    //--RenameFileUTF8(CurBYEle . att ('in' ) , CurBYEle . att ('out' ) ); { *Converted from RenameFile*  }
    RenameFile(CurBYEle.att('in'), CurBYEle.att('out'));
    { *Converted from RenameFile*  }

    ;
  except

    writeln('<li>failed to copy ' + CurBYEle.att('in'));

  end;
end;



function txseus.c_call: boolean;
{D: Calls other handers
  -group: programflow
 -usage: very common
 -status: it is possible to specify a different "form" element (from the one parsed from
  http post fields), but that functionality seems experimental only
}
var
  aputag, oldform, tmpform: ttag;
  k: integer;
  apui: integer;
  apust: string;
  acom: ttag;
begin
  acom := CurBYEle;
  Result := True;
  //if acom.att('file')<>'' then
  //begin
  // acom.fromfile(CurBYEle.att('file'),nil);
  // writeln('<h1>test</h1>');
  // listwrite(acom);
  // exit;
  //end;
  //aputag:= x_handlers.subt('/class/handler[@name='+acom.att('handler')+']');
  aputag := getcurrenthandler(acom.att('handler'));

  if aputag = nil then
  begin
    _h1('handler NOT FOUND' + 'handler[@name eq ''' + acom.att('handler') + ''']');
  end
  else
  begin
    oldform := nil;
    apust := acom.att('form');
    if (apust <> '') or (acom.subtags.Count > 0) then
    begin
      try
        for k := 0 to xml.subtags.Count - 1 do
        begin
          if ttag(xml.subtags[k]).vari = 'form' then
          begin
            apui := k;
            break;
          end;
        end;
        oldform := xml.subt('form').copytag;
        listwrite(oldform);
        //listwrite(acom.subtags[0]);
        if acom.subtags.Count > 0 then
        begin
          tmpform := acom.copytag;
          tmpform.vari := 'form';
          xml.subtags[apui] := tmpform;
        end
        else
        if xml.subt(acom.att('form')) <> nil then
          try
            tmpform := xml.subt(acom.att('form'));
            tmpform.vari := 'form';
            xml.subtags[apui] := tmpform;
          except
            _h1('faile call form');
          end;
      except
        _h1('faile call');
      end;
    end;
    try
      //       tim.addsub(aputag,'');
      //writeln('trytoexec)');
      if not doelementlist(aputag.subtags) then
      begin
        Result := False;
        if oldform <> nil then
          xml.subtags[apui] := oldform;
        exit;
      end;
    finally
      //          tim.return;
      aputag.killtree;
    end;
    if oldform <> nil then
    begin
      xml.subtags[apui] := oldform;
    end;
  end;
end;


function txseus.c_debugtext: boolean;
{D: write some text out to the browser, bypassing state.resu output-mechanism
  -group: debug
}
begin
  writeln(CurBYEle.vali+curbyele.subs('text'));
end;


function txseus.c_includexml: boolean;
{D: reads an parses xml-files, places result in tree
 -usage: very common
 -plans: support for different formats
 -rewrite dec 2011: simplified much, use apply file// for finesses
}
var
  newtag, aput, acomx: ttag;
  i: integer;
begin
  _checkfilelocation(CurBYEle, 'file', self, False);
  acomx := CurBYEle;
  if FileExists(acomx.att('file')) { *Converted from FileExists*  } then
    newtag := tagfromfile(acomx.att('file'), TStringList(acomx.getattributes))
  //newcom.fromfile(acomx.att('file'), acomx.attributes);
  else
    exit;
  //CurToEle := newtag;
  CurToEle.subtags.add(newtag);
  newtag.parent := curtoele;

end;




function txseus.c_upload: boolean;
{D: writes contents of postform multipart (input type=file) into specified file
}
var
  filename, formname: string;
  tf: file;
  upstart: pointer;
  uplen: integer;
  fs: tmemorystream;
  upord: integer;
  uptag: ttag;
  ups: TStringList;
begin
  ups := tserving(x_serving).uploads;
  if ups.Count < 1 then
    exit;
  upord := 0;
  ups := tserving(x_serving).uploads;
  if ups.Count < 1 then
    exit;
  formname := curbyele.att('formname');
  filename := curbyele.att('filename');
  if formname <> '' then
    upord := ups.indexofname(CurBYEle.att('formname'))
  else
    upord := 0;
  if filename = '' then
    filename := cut_rs(ups[upord]);
  filename := _indir(filename, x_outdir, self, False);

  try
    begin
      //writeln('<li>tryto upload:'+apust+'  '+inttostr(tserving(x_serving).uploads.count)+'</li>');
      fs := tmemorystream(ups.objects[upord]);
      fs.position:=0;
     // writeln('<li>save upload:'+inttostr(fs.Size)+'</li>');
      fs.SaveToFile(filename);
    end

  except
    writeln('<li>failed to upload ' + filename + '</li>');
  end;
end;



function txseus.c_template: boolean;
{D: does nothing .. or just skips templates
  -maybe

}
begin

end;


function txseus.c_except: boolean;
{D:  does nothing normally, only if error is raised in state
}
begin
{  if sstateexception = '' then
    exit
  else
  begin
    //newCurFromEle:=newtag;
    //newstate.resta:=newtag;
    setstatex(newstate);
    //resuadd(newtag);
    dosubelements(newstate);
    writeln('<h1>elementx</h1><xmp>' + CurBYEle.listraw + '</xmp><xmp>' +
      newCurToEle.listraw + '</xmp>');
    newstate.dofree;

  end;
}
end;

function txseus.c_error: boolean;
{D:  raises an error for testing c_except
}
begin
  stateexception := CurBYEle.att('msg');

end;

end.
procedure listmem(posi: integer;
st: string);
var
i: integer;
begin
//   exit;  writeln(' <h3>elems:', t_elemlist.Count, st, '</h3><ul>');for i :=
t_elemlist.Count - posi to t_elemlist.Count - 1 do
try
writeln('<li>');
writeln(ttag(t_elemlist[i]).vari + ':', integer(t_elemrefcount[i]),
ttag(t_elemlist[i]).attributeslist + '!</li>');
except
writeln('couldnotlist</li>');
end;
writeln('</ul>');
end;
procedure getmema;
var
nowmem: integer;
begin
exit;
nowmem := GetFPCHeapStatus.CurrHeapUsed;
memlog := '<b>' + progt.vari + '</b> ';
taglog := '<b>tags:</b>';
mem := nowmem;
smem := nowmem;
stags := elements_CREATED;
sktags := elements_FREED;
tags := stags;
ktags := sktags;
listmem(1, 'start');
// oldend;procedure getmemb(st: string);
var
nowmem, nt, nk: integer;
begin
exit;
nowmem := GetFPCHeapStatus.CurrHeapUsed;
nt := elements_created;
nk := elements_freed;
memlog := memlog + '/' + st + ':' + IntToStr(nowmem - mem) + '/';
taglog := taglog + st + ':' + IntToStr(nt - tags) + '/';
taglog := taglog + ' (' + IntToStr(nk - ktags) + ') /';
listmem(nt - tags, st);
tags := nt;
ktags := nk;
mem := nowmem;
end;
procedure getmemc;
var
i, nowmem, nt, nk: integer;
begin
exit;
nowmem := GetFPCHeapStatus.CurrHeapUsed;
nt := elements_created;
nk := elements_freed;
taglog := taglog + '/:' + IntToStr(nt - tags);
taglog := taglog + ' (' + IntToStr(nk - ktags) + ')';
writeln('<li>mem: ' + memlog, '/' + IntToStr(nowmem - mem) + '=' + IntToStr(
nowmem - smem) + '</li>');
writeln('<li>tags: ' + taglog, '/==' + IntToStr(nt - stags) + ' (' + IntToStr(
nk - sktags) + ')</li>');
listmem(9, 'end:');
mem := nowmem;
// listmem('end');end;

{if (x_stopped.count>0) and (progt.vari<>ns+'stop') then
begin
  writeln('<li>Stoppedbelow ');
  try
    //if mydebug then
    if curtoele<>nil then writeln('<li>curto /in:'+curtoele.head);
    if x_stopped.getpar<>nil then writeln('//bac:'+x_stopped.getpar.head);
    if oldto<>nil then writeln('//OTO:'+oldto.head);
    if x_stopped.getpar.parent<>nil then writeln('/PARPAR:'+x_stopped.getpar.parent.head,x_stopped.getpar.parent=curtoele,'</li>') else writeln('noparpar');

  except
     writeln('<li>failed to check stp');
  end;
  //curtoele:=x_stopped.getpar;
  //oldto:=curtoele;
  //if oldto=curtoele.parent then begin curtoele:=oldto.parent;writeln('<li><b>delstop:'+oldto.head+'</b>/at:'+progt.head+'</li>');x_stopped.delete;end;
   //if oldto=curtoele.parent then
   // if (not startedhere) and
  if curtoele=nil then begin x_stopped.delete;writeln('<li>baccktobrowser</li>') end else
  if  (curtoele=x_stopped.getele) then
  begin
    if mydebug then writeln('<li><b>delstop:</b>',oldto=nil,curtoele=nil);
    if oldto=nil then
      writeln('<li>no-oldto') else
    if x_stopped.getpar=nil then writeln('<li>no-stop/par') else
    //if mydebug then
    writeln(oldto.head+'</b>/at:'+curtoele.head+'/par:'+oldto.parent.head,'///',x_stopped.getpar.head,'</li>');
    oldto:=x_stopped.getpar;
    if oldto<>nil then oldto:=oldto.parent;
    curtoele:=oldto;
    x_stopped.delete;


    //curtoele.subtags.remove(curtoele);
    //oldto.subtags.add(ttag(curtoele.subtags[curtoele.subtags.count-1]));
    //curtoele.subtags.delete(curtoele.subtags.count-1);
  end
   else
   begin
     try
     if mydebug then writeln('<li>keepstopping:<b>'+oldto.head+'</b>/at:'+curtoele.head+'/par:'+'</li>');
     except writeln('<li>failed report keepstop',x_stopped.getpar<>nil);
     end;
     curtoele:=x_stopped.getpar;

    //oldto:=x_stopped.getpar;
    end;
   if mydebug then writeln('<li>nowto:'+curtoele.head+'/oldto:',oldto<>nil,'</li>');
end
else}


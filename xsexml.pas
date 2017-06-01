unit xsexml;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

//EF BB BF
{ $H+}
interface

uses Classes, SysUtils;//,       generics.collections;


//function cut_rs(s: string): string;
//function cut_ls(s: string): string;
function _utf8toasc(st: string): string;
function _nocdata(st: string): string;

const
  crlf = #13#10;crr=#13;lf: STRING=#10;

const
  whitespace = #13#10#9 + ' ';

const
  inlins = ',,span,strong,code,br,BR,img,em,b,i,a,strike,font,FONT,STRONG,CODE' +
    'q,del,ins,tt,value,';

//const
//  emptyels = ',area,base,basefont,br,BR,IMG,col,frame,hr,img,input,isindex,link,meta,param,';

const
  WhiteSpaces = [' ', #9, #10, #12, #13];
//var simplex:boolean;

type
ttag = class;

tattributes=class(tstringlist)
   myele:ttag;
   procedure add(st:string);
   constructor create(aown:ttag);
   end;

ttag = class(TObject)
    private
     attributes: tattributes;
  public
  //   function hasattribute(vari: string): boolean;
    vari, vali: ansistring;
    memregnum, hasindent: integer;  //hasindent is only used in xmlis-parse, shall be removed from here
    subtags: TList;
    parent  //,xselected
    : ttag;
    //attributes:TStringList;
    //intext,
    //sortkey,
    commenttext: ansistring;       //not used
    //iscomment,
    xdontclosetags,       //not used
    //xlowertags,
    //xcopied, //not necessary
    xquoted: boolean;
    xrefcount: shortint;
    property getattributes:tattributes read attributes;
    function attributescount:integer;
    function hasancestor(anc:ttag):boolean;
     procedure freeattributes;
    procedure attributesclear;
    function attributeslist:string;
    function head:string;
    procedure attributescopyfrom(frt:ttag);
    //procedure attributesindex(frt:ttag);
    procedure setatt(varix,valix:string);
    procedure setattname(old,new:string);
    //procedure savedents(fil: string);
    function addsubtag(varix, valix: string):ttag; //TAG
    procedure addatt(st:string);
    procedure addval(st:string);
    function getatt(n:integer):string;
    procedure delatt(st:string);
    procedure subtagsadd(newt: ttag);//TAG
    procedure subtagscopy(sou: TList);
    function copysubtags:TList;
    function subt(t: string): ttag;  //TAG
    function subtbyatt(tagname,attname,attval: string): ttag;
    function subs(t: string): string;
    function select(pathst: string; all, empties: boolean): TList;
    function att(t: string): string;
    function getsubvals: string;
    function lastsubtag:ttag; //TAG
    procedure valitovalue;
    //procedure clear;
    function copytag: ttag;  //TAG
    function copytagnew: ttag;  //TAG
    function clonetag(par:ttag;subs:boolean): ttag;//TAG
    function copyutftag: ttag;   //TAG
    constructor Create;
    procedure clearmeE;
    destructor freemee;
    destructor killtree;
    procedure xfree(x: string);
    procedure list(pre: string; res: TStringList);
    procedure listparts(pre: string; var outfile: string; res: TStringList;
      splitat: string);
    function listst: string;
    function listraw: string;
    function listjson(inde: string): string;
    function saveeletofile(t: string; xhead: boolean; head,ind: string; compact,ents: boolean): boolean;
    //procedure fromfile(fil: string; hdr: TStringList);
    //procedure fromfileind(fil: string);
    //procedure fromfiledots(fil: string);
    //procedure cgi2xml(tagi: string; sl: TStringList; clean: boolean);
    procedure listdebug;
    function listxml(inde:string; ents,isroot: boolean): string;
    function ashtml: string;
    function listxmlish(inde: string; var RES: TStringList;inlinexml:boolean): boolean;
    // function listxmlish2(inde: string; var RES: tstringlist): BOOLEAN;
    //function xmlishtohtml(inde: string; var RES: tstringlist): BOOLEAN;
    //function xmlishtohtmlx(inde,cl:string;indi:integer;VAR RES:tstringlist):BOOLEAN;
    function xmlis: string;
    function savetofileind(t: string; xhead: boolean; head: string;
      compact: boolean): boolean;
    //function listasis: string;

  private
    procedure listhtml(nocr: boolean);
    procedure listwrite;
    //constructor createst(par: ttag; vars: string);
    procedure addsubprop(propvaris: TStringList; param, term: string);
    procedure listwparent(pre: string; res: TStringList);
    //function checkids(var ids: TStringList): string;
    //    function inferers: string;
    //function withattr(at, va: string): ttag;
    procedure minitidy(tagst, CONT: string);
    //function doselect(pathp: pointer; root: ttag): TList;
    function getnext: ttag;
    function getprev: ttag;
    function getaxis(pathp: pointer): TList;
    function getsubvalsasis: string;
    function moveto(newpar:ttag):ttag;
    //function getdent(dents: string): string;
    //    function listiTREE: string;
  end;

type
  txcond = class(TObject)
    cond: string;
    //nn,
    hits,tries: integer;
    function parsest(path: string; var posi: integer): boolean;
    // function parseold(path:string; var posi:integer):boolean;
    procedure list;
  private
    procedure Clear;
  end;
{type
  txcondold = class(TObject)
    x, y, paxis: string;
    //nn,
    hits,tries: integer;
    Next: txcond;
    nextand, lt, gt, eq, //xnewsyntax,
    match,negat: boolean;
    function parsest(path: string; var posi: integer): boolean;
    // function parseold(path:string; var posi:integer):boolean;
    procedure list;
  private
    procedure Clear;
  end;
}
type
  txpath = class(TObject)
    ele, axis,idi: string;
    con: txcond;
    Next: txpath;
    dochils, reverse: boolean;
    function parse(path: string): ttag;
    function list:string;
    procedure Clear;
  end;

type
  ttaglist = class(TObject)
    refcoun: integer;
    ele: ttag;
  end;

function strtotag(st:string;isxsi:boolean):ttag;
function tagparse(cla: string; low, trimmaa: boolean): ttag;
//function tagdoparse(cla: string; low, trimmaa,onetagonly: boolean;var posit:integer): ttag;
function tagdoparse(cla: string; low, trimmaa,onetagonly,inmarkdown: boolean;var posit:integer): ttag;
function tagparsexmlis(sl: TStringList): ttag;
function tagfromfile(fil: string; hdr: TStringList): ttag;
function tagfromfileind(fil: string): ttag;
function tagfromfiledots(fil: string): ttag;
//procedure registertagowner(xse: TObject; e,r: TList);
function createtag(par: ttag; vars: string):ttag;
//function createpersistenttag:ttag;
function _p_condition(condst:string; ele:ttag):string;

implementation

uses xseglob,xsexse, xseexp //xsesta,
  //,xsefunc,
  ,xsemisc;
procedure ttag.attributescopyfrom(frt:ttag);
var i:integer;
begin
 // attributes.addstrings(frt.attributes);
  for i:=0 to frt.attributes.count-1 do
    attributes.add(frt.attributes[i]);
end;
function strtotag(st:string;isxsi:boolean):ttag;
var stbeg:string;hasheader:boolean;sl:tstringlist;
  headend:integer;
begin
   hasheader:=false;
   stbeg:=copy(st,1,256);
   //writeln('<li>STRTOTAG:', '//<xmp>', stbeg,'</xmp></li>');
   if (pos('?xmlis', stbeg) = 1) then
   begin
     isxsi:=true;
     hasheader:=true;
   end else
    if (pos('<?xml ', stbeg) > 0) or (pos('<!DOCTYPE', stbeg) > 0)  then
    begin
         isxsi:=false;
         hasheader:=true;
    end;
    if isxsi then
    begin
       // writeln('<h1>isxsi</h1>');
       sl:=tstringlist.create;
       sl.text:=st;
       if hasheader then sl.delete(1);
       result:=tagparsexmlis(sl);
       sl.free;
    end else
    begin
      //writeln('<h1>isxml</h1>',hasheader,'<xmp>',copy(st,1,1000),'</xmp>');
       if hasheader then
       begin
          headend:=pos(crlf,stbeg);
          if headend>0 then st:=copy(st,headend,length(st));
       end;
       //writeln('<h1>isxml</h1>',hasheader,'<xmp>',st,'</xmp>');
       result:=tagparse(st,false,true);
    end;
end;

constructor tattributes.create(aown:ttag);
begin
  myele:=aown;
  inherited create;
end;

function ttag.hasancestor(anc:ttag):boolean;
var apar:ttag;

begin
  try
 apar:=self;
 result:=false;
 while apar.parent<>nil do
 begin
    try
    //writeln('-',apar.parent.vari);

    except
      writeln('<li>nogohasanc-parentsucks:',result);
    end;
   if apar.parent=anc then
   begin
     result:=true;exit;
   end;
   apar:=apar.parent;
 end;

  except
    writeln('<li>nogohasanc:',result);
  end;
end;
procedure ttag.setattname(old,new:string);
var o:integer;
begin
  try
  { if _getnum(o,vari) then
   begin
     //writeln('<li>set@',o,'/',attributes.count);
     attributes[o-1]:=vali
   end else
    }
    o:=attributes.indexofname(old);
    if o=-1 then writeln('<h2>cannon change attribute</h2>'+vari)//txseus(t_currentxseus).x_ids.addobject(self,vali);
    else
    begin
    //writeln('<li>att of :',vari,attributes[o]'/old:', old,'/new',new,'!',o,'!'+attributes.text,'</li>');
    attributes[o]:=new+'='+attributes.ValueFromIndex[o];
    //writeln(xmlis);
    //writeln('<li>att of :',vari,'/old:', old,'/new',new,'!',o,'!'+attributes.text,'</li>');

    end;
   if vari='id' then //if t_currentxseus<>nil then
   begin writeln('<h2>cannon change id</h2>');//txseus(t_currentxseus).x_ids.addobject(self,vali);
   end;

  except
    writeln('<li>Failed to name attribute:'+vari+'?'+vali);
  end;

end;

procedure ttag.setatt(varix,valix:string);
var i,o:integer;
begin
  try
   varix:=trim(varix);
   {if varix='value' then
   begin
   writeln('<h3>',head,'</h3>');
   for i:=0 to attributes.count-1 do
     writeln('<li>att:',i,'/', _getnum(o,varix),'!', cut_ls(attributes[i]),'</li>');
   end;}
    //writeln('<li>atts:', attributes.text,'!</li>');
   //if _getnum(o,varix) then

   if pos('#',varix)=1 then
   begin
    try
     //writeln('<li>set@',varix,':',o,'/',attributes.count);
    //valix := StringReplace(valix, '&#xA;', ^M^J, [rfreplaceall]);
     valix := StringReplace(valix, '&#xA;', crlf, [rfreplaceall]);
     attributes[o-1]:=valix
     except
       writeln('<li>Failed to replace attribute:'+vari+'?'+vali+'!!!'+varix+'!!!'+valix);
     end;
   end else
    attributes.values[varix]:=valix;

   if varix='id' then if t_currentxseus<>nil then
   begin txseus(t_currentxseus).x_ids.addobject(self,valix);
   end;

  except
    writeln('<li>Failed add attribute:'+vari+'?'+vali);
  end;

end;
procedure ttag.freeattributes;
begin                        //remember to handle id's
  attributes.free;
  attributes:=nil;
end;
function ttag.attributeslist:string;
begin                        //remember to handle id's
  result:=attributes.text;
end;
function ttag.head:string;
begin                        //remember to handle id's
  result:='<b>'+vari+'</b> '+attributes.text+': '+vali+ '>'+inttostr(subtags.count)+'!';
end;
procedure ttag.attributesclear;
begin//remember to handle id's
  if att('id')<>'' then
  begin
  //WRITELN('<li>DELATTS:',att('id'),'<b>',self.xmlis,'</b></li>');
     try
      if t_currentxseus<>nil then
      txseus(t_currentxseus).x_ids.delobject(self,att('id'));
      //writeln('--  clearing id -hash ..');
      attributes.clear;
   except writeln('-- problem clearing id -hash .. KNOWN but perhaps forgotten BUG --');end;
  end;

  //attributes.clear;
end;
function ttag.attributescount:integer;
begin
  result:=attributes.count;
end;
//function ttag.hasattribute(vari:string):boolean;
//begin
//  result:=attributes.indexofname(vari) < 0
//end;

procedure tattributes.add(st: string);
var vari, vali:string;
begin
  //tstringlist.add
  //inherited add(st);
  vari:=trim(cut_ls(st));
  vali:=cut_rs(st);
  if vari='' then exit;
  //if vali='' then vali:='true';
  values[vari]:=vali;
  //add(st);
   if vari='id' then txseus(t_currentxseus).x_ids.addobject(myele,cut_rs(st));
  //writeln('addatt:'+st);



end;
function ttag.getatt(n:integer):string;
begin
  result:=attributes[n];
end;

procedure ttag.addatt(st: string);
var vari, vali:string;
begin
  st := StringReplace(st, '&quot;', '"', [rfreplaceall]);
  //st := StringReplace(st, '&#xA;', ^M, [rfreplaceall]);
  st := StringReplace(st, '&#xA;', crlf, [rfreplaceall]);
  attributes.add(st);
  //add(st);
  //vari:=cut_ls(st);
  //if vari='id' then txseus(t_currentxseus).x_ids.addobject(self,cut_rs(st));
  //if vari='id' then t_idlist.addobject(self,cut_rs(st));
end;
procedure ttag.delatt(st: string);
var vari, vali:string;p:integer;ids:thashstrings;
begin
   p:=attributes.indexofname(st);
  //writeln('<li>delatt:'+st+'/',p);
  if p>=0 then attributes.delete(attributes.indexofname(st));
  //add(st);
   if st='id' then
   begin
    ids:=txseus(t_currentxseus).x_ids;
    if ids<>nil then
       ids.delobject(self,att('id'));
   //if t_idlist<>nil then
   //t_idlist.delobject(self,att('id'));
   //writeln('<pre>',xmlis,'</pre>');
   end;



end;

procedure ttag.addval(st: string);
var vari, vali:string;
begin
  if subtags.count=0 then begin self.vali:=self.vali+st; // writeln('<li>addedval:',st,'/to:'+self.xmlis+'!');
 end else
 begin
  self.addsubtag('',st);  //writeln('<li>addedsub:',st,'/to:'+self.xmlis+'!');
 end;

end;


procedure txcond.list;
begin
  writeln('<li>cond:',cond,'</li>');
  //'x:', x, ' y:', y, '  gt:', gt, ' lt:', lt, '...', nextand,
  //  ' nil:', Next = nil);
  //if Next <> nil then
  //  Next.list;
end;

function txcond.parsest(path: string; var posi: integer): boolean;
  function tillendbrac(path: string; var posi: integer): boolean;
  var  bracks, quotes,apos,len:integer;
  begin
    result:=true;quotes:=0;
    len:=length(path);
    while posi<len do
    begin
     posi:=posi+1;
     //writeln('-'+path[posi],path[posi]=']', '-');
     if quotes>0 then begin if path[posi]='''' then quotes:=quotes-1;end  else
     begin
      if path[posi]='''' then quotes:=quotes+1 else
      if path[posi]=']' then
      begin
       if (posi<len) and (pos(path[posi],'[&!|')>0) then result:=tillendbrac(path,posi) else
       result:=true;posi:=posi+1;break;

      end else
      if path[posi]='[' then if not tillendbrac(path,posi) then
        writeln(' end bracket not found');//[x][y] ... not doing anything...???
     end;
  end;

  end;

var stpos:integer;
begin //txcond.parse
  try
    //writeln('parsepath');
    stpos:=posi+1;
    if not tillendbrac(path,posi) then writeln('Failed to parse xse-path condition - missing end bracket?');
  finally
   cond:=copy(path,stpos,posi-stpos-1);
   //writeln('<li>_didcondx<b>(',cond,')</b></li>');
   // writeln('<li>rest<b>(',copy(path,posi,999),')</b></li>');
  //writeln('didparsepath');
  end;
end;




{procedure registertagowner(xse: TObject; e,r: TList);
begin
  txseus(t_currentxseus) := txseus(xse);
  //t_idlist:=txseus(xse).x_ids;
  t_elemlist:=txseus(xse).x_elemlist;
  t_elemrefcount:=txseus(xse).x_elemrefcount;
  //mythreadelems := e;
  //mythreadrefcount := r;
end;
removed: no need for threadvars, it is in xseus (???)
}




function _asctoutf8(st: string): string;
var
  len, i: integer;
  hex: boolean;

  function _getent(st: string): string;
  var
    resst: string;
  begin
    i := i + 1;
    resst := '';
    if st[i] = 'x' then
    begin
      hex := True;
      i := i + 1;
    end
    else
      hex := False;
    while (i < len) do
    begin
      //if hex then if stlength(resst)>4 then
      begin
        Result := resst;
        exit;
      end;
      resst := resst + st[i];
      i := i + 1;
      if st[i] = ';' then
        break;
    end;
    i := i + 1;
    if hex then

    else
      Result := Result + chr(strtointdef(resst, -1));
  end;

var
  res, bs, hi, fre: integer;
  ib: byte;
begin
  hex := False;
  Result := '';
  i := 0;
  len := length(st);
  while i < len do
  begin
    i := i + 1;
    if (st[i] = '&') and (i < len) and (st[i + 1] = '#') then
      Result := Result + _getent(st)
    else
      Result := Result + st[i];
  end;

end;

function _utf8toasc(st: string): string;
var
  i, res, bs, hi, fre: integer;
  ib: byte;
begin
  Result := '';
  i := 0;
  while i < length(st) do
  begin
    i := i + 1;
    ib := Ord(st[i]);
    if ib < 128 then
      Result := Result + st[i]
    else
    begin                       //195,164
      bs := 1;
      hi := 64;
      res := Ord(st[i + 1]) - 128;
      fre := 192; //    res=36, ib=195,fre=192,hi=64
      if ib >= 224 then
      begin
        bs := 2;
        hi := hi * 64;
        fre := 224;
        res := 64 * res + Ord(st[i + 2]) - 128;
      end;
      if ib >= 240 then
      begin
        hi := hi * 64;
        bs := 3;
        res := 64 * res + Ord(st[i + 3]) - 128;
        fre := 240;
      end;
      if ib >= 248 then
      begin
        hi := hi * 64;
        bs := 4;
        fre := 248;
        res := 64 * res + Ord(st[i + 4]) - 128;
      end;
      if ib >= 252 then
      begin
        hi := hi * 64;
        bs := 5;
        fre := 252;
        res := 64 * res + Ord(st[i + 5]) - 128;
      end;
      if ib > 254 then
        Result := ('')
      else
        Result := Result + '&#' + IntToStr((ib - fre) * hi + res) + ';';
      //    res=36, ib=195,fre=192,hi=64, result=3*64+35=
      i := i + bs;
    end;
  end;
end;


function _clean(st: string): string;
var
  i, len: integer;
begin
  len := length(st);
  Result := '';
  for i := 1 to len do
  begin
    if st[i] = '&' then
      Result := Result + '&amp;'
    else
    if st[i] = '"' then
      Result := Result + '&quot;'
    else
    if st[i] = '<' then
      Result := Result + '&lt;'
    else
    if st[i] = '>' then
      Result := Result + '&gt;'
    else
    if st[i] = '''' then
      Result := Result + '&#39;'
    else
      Result := Result + st[i];
  end;
end;

function _cleanattr(st: string): string;
begin
  st := StringReplace(st, '"', '', [rfreplaceall]);
  st := StringReplace(st, '<', '', [rfreplaceall]);
  st := StringReplace(st, '>', '', [rfreplaceall]);
  st := StringReplace(st, #13, '', [rfreplaceall]);
  st := StringReplace(st, #10, '', [rfreplaceall]);
  Result := st;
end;

procedure quickgsub(what, towhat: string; var inwhat: string);
var
  i, j, len, whatlen, lendif: integer;
  res: string;
  what1: char;
  match: boolean;
begin
  i := 0;
  res := '';
  what1 := what[1];
  whatlen := length(what);
  lendif := length(towhat) - whatlen;
  len := length(inwhat) - whatlen;
  while i <= len do
  begin
    i := i + 1;
    if inwhat[i] <> what1 then
    begin
      res := res + inwhat[i];
      continue;
    end;
    match := True;
    for j := 2 to whatlen do
    begin
      if j > whatlen then
        break;
      if what[j] <> inwhat[i + j - 1] then
      begin
        match := False;
        break;
      end;
    end;
    if match then
    begin
      res := res + towhat;
      i := i + lendif;
    end
    else
      res := res + inwhat[i];
  end;
  inwhat := res;
end;

procedure sub(what, towhat: string; var inwhat: string);
var
  fo: integer;
begin
  fo := pos(what, inwhat);
  if fo > 0 then
    inwhat := copy(inwhat, 1, fo - 1) + towhat + copy(inwhat, fo +
      length(what), length(inwhat));
end;

function cut_ls(s:string):string;
var apus:string;apui:integer;
begin
    apui:= pos('=',s);
    if apui>0 then result:=copy(s,1,apui-1) else result:=s;
end;

function oldcut_ls(s: string): string;
var
  apui: integer;
begin
  apui := pos('=', s);
  if apui > 1 then
    Result := copy(s, 1, apui - 1)
  else
    Result := '';
end;

function cut_rs(s:string):string;
var apui,i:integer;apust:string;
begin
  //apui:= length(s)-pos('=',s);
  apui:=0;
  apui:=pos('=',s);
  result:='';
    apust:='';
    if apui>0 then //apust:=rightstr(s,apui);
     for i:=apui+1 to length(s) do
     try
     apust:=apust+s[i];
    //apust:=copy(s,apui+1,length(s)-apui);// else result:='';
    //§result:=trim(result);
   // if (pos('"',result)=1) and (length(result)>1) and (result[length(result)]='"') then
   //  result:=copy(result,2,length(result)-2);
   result:=apust;
    except  writeln('<li>cut_rs failed for:',s,'/pos:',apui,'/len:',length(s), ' /at:',i, '   ',s[i],'/'+floattostr(getheapstatus.TotalFree));raise;end;
   // try
    //  apust:='zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz';
     // except writeln('<li>faild to ad string2');end;
   end;


function oldcut_rs(s: string): string;
var
  apui: integer;
begin
  apui := pos('=', s);
  if apui > 0 then
    Result := copy(s, apui + 1, length(s))
  else
    Result := '';
end;


{function ttag.checkids(var ids: TStringList): string;
var
  i: integer;
  id: string;
begin
  if ids = nil then
    ids := TStringList.Create;
  id := attributes.values['id'];
  if id <> '' then
  begin
    if ids.values[id] <> '' then
    begin
      Result := Result + '/' + id;
      exit;
    end;
    ids.add(id);
  end;
  for i := 0 to subtags.Count - 1 do
    ttag(subtags[i]).checkids(ids);
end;
}
function ttag.moveto(newpar:ttag):ttag;
begin
  parent.subtags.remove(self);
  newpar.subtags.add(self);
  parent:=newpar;
end;

procedure _movesubtags(tot, fromt: ttag);
var
  i, j: integer;
begin
  if fromt.vali <> '' then
  begin
    tot.addsubtag('', fromt.vali); //VALUE
    fromt.vali := '';
  end;

  //writeln('move:'+tot.vari, fromt.vari);
  //tot.listwrite;
  //fromt.listwrite;
  //exit;
  for i := 0 to fromt.subtags.Count - 1 do
  begin
    ttag(fromt.subtags[i]).parent := tot;
    tot.subtags.add(fromt.subtags[i]);
  end;
  fromt.subtags.Clear;
end;

function tagparse(cla: string; low, trimmaa: boolean): ttag;
var posit:integer;
begin
  posit:=0;
  result:=tagdoparse(cla,low,trimmaa,false,false,posit);
end;
function tagdoparse(cla: string; low, trimmaa,onetagonly,inmarkdown: boolean;var posit:integer): ttag;
var
  curpos, skipstart, paslen: integer;
  intagword, inquote, inendtag, incont, inparvar, inparval, incdata, incomment: boolean;
  sts, term, attname, comtext: string;
  basetag, tag, newtag, oldtag: ttag;
//prop  propvaris: TStringList;
//prop  propvars: TList;
  quote: char;

  procedure _status(x: string);
  var
    s: string;
  begin
    s := '';
    if inquote then
      s := s + 'inquote/';
    if intagword then
      s := s + 'intagword/';
    if inendtag then
      s := s + 'inendtag/';
    if inparvar then
      s := s + 'inparvar/';
    if inparval then
      s := s + 'inparval/';
    if incont then
      s := s + 'incont/';
  end;

  procedure addattr;
  begin
    term := _cleanattr(term);
    if attname = '' then
      attname := term;
    if term <> '' then
    begin

                    tag.setatt(attname,term);
   end;
      //tag.attributes.add(term + '=' + param);
    term := '';
    //tag.attributes.hashadd(term + '=' + param);

  end;

{  procedure _newprop(t: ttag; var term: string);
  var
    avar: string;
  begin
    try
      //tämä lienee ihan turha.. piti tulla jotain prolog-unifikaatioita
      if (1 = 1) and (t = basetag) then
      begin
        propvars.add(propvaris);
        avar := '';
        if pos('=', term) > 0 then
        begin
          propvaris.add('.=' + cut_rs(term) + '_x');
          term := cut_ls(term);
        end;
      end
      else
      if pos('=', term) > 0 then
      begin
        t.addsubprop(propvaris, cut_ls(term), cut_rs(term));
        term := cut_ls(term);
      end;
    except
      writeln('failer to save element');
    end;
  end;
}

  function _uptree(tag: ttag;var tagtoclose:ttag; term: string;basetag:ttag): tlist;
  begin
    tagtoclose:=nil;
    Result := tlist.create;
    while tag.parent <> nil do
    begin
      if term = tag.vari then
      begin
        //Result := True;
        if tag<>basetag then tagtoclose:=tag;
        exit;
      end;
      result.add(tag);
      //if tag.parent=nil then
      tag := tag.parent;

    end;
  end;

var
  skip,j,k: integer;opentree:tlist;tagtoclose,atag:ttag;
begin
  //writeln('<pre>PARSEC:',_clean(cla)+'</pre>');
  if cla='' then begin result:=nil;exit;end;
  try
    try


        //prop      propvars := TList.Create;
        //prop      propvaris := TStringList.Create;
      sts := cla;
      inquote := False;
      skip := 0;
      skipstart := 0;
      intagword := True;
      inparvar := False;
      inparval := False;
      incont := False;
      inendtag := False;
      incdata := False;
      incomment := False;
      trimmaa:=false;
      //if not trimmaa then writeln('<li>NOTRIM');
      //asetag := self;
      basetag := ttag.Create; //empty basetag to be cleared - not elegant
      basetag.parent:=nil;
      basetag.vari:='baseparsed';
      tag := basetag;
      //t_lastopentag:=nil;
      quote := '"';
      if posit=0 then
      begin
        if pos('<?xml ', sts) = 1 then
          Delete(sts, 1, 1);

        paslen := length(sts);
        for curpos := 1 to paslen - 2 do
          if sts[curpos] = '<' then
            if pos(sts[curpos + 1], '?! /') < 1 then
            begin
              skipstart := curpos + 1;
              break;
            end;
      end else skipstart:=1;
        if t_debug then
          writeln('<xmp>SKIPBEG:' + copy(cla,1, skipstart) + '//skipbeg</xmp>', skipstart);
        if t_debug then
          writeln('<xmp>starzat:' + copy(cla, skipstart,20) + '//starzat:</xmp>', skipstart);

      for curpos:=skipstart to paslen do
      begin
        try
        if skip > 0 then
        begin
          skip := skip - 1;
          continue;
        end;
        if onetagonly then
        begin
            writeln('<b>'+sts[curpos]+'</b><small>');
          if incont then writeln('/c');
          if intagword then writeln('/t');
          if inparvar then writeln('/@');
          if inparval then writeln('/+');
          if incont then writeln('/.');
          if inendtag then writeln('/-');
          writeln('</small>');

        end;
        // write('*',curpos,_clean(sts[curpos])+'-');
        //if curpos=paslen then begin writeln('<li>endparse:'+tag.head+'!!!'); break;end;
        if incdata then
        begin
          if (sts[curpos] = '>') and (curpos > 2) and (sts[curpos - 1] = ']') and
            (sts[curpos - 2] = ']') then
          begin
            try
              incdata := False;
              term := copy(term, 1, length(term) - 2);
              if tag <> nil then
                //prop tag.addsubprop(propvaris, 'cdata', term);
                tag.addsubtag('cdata', term);

              incont := True;
              term := '';
              attname := '';
              continue;
            except
              writeln('<h1>cdata failure</h1>');
            end;
          end
          else
            term := term + sts[curpos];
          continue;
        end;
        if intagword then
          if ((term) = '![CDATA[') then
          begin
            incdata := True;
            intagword := False;
            incont := True;
            inparvar := False;
            term := sts[curpos];
            continue;
          end;

        if incomment then
        begin
          if (sts[curpos] = '>') and (curpos > 2) and (sts[curpos - 1] = '-') and
            (sts[curpos - 2] = '-') then
          begin
            incomment := False;
            tag.commenttext := comtext;
          end;
          comtext := comtext + sts[curpos];
          continue;
        end;
        if not incont then  //quotes and double quotes
        if not intagword then
            //if not inendtag then tag.intext:=tag.intext+sts[i];
        if (pos(sts[curpos], '''''"') > 0) and (not incont) then
        begin
              if (not inquote) then
              begin
                inquote := True;
                quote := sts[curpos];
                continue;
              end
              else
              begin
                if quote = sts[curpos] then
                  inquote := False
                else
                //if sts[i]='''' then term:=term+'&apos;'
                if sts[curpos] = '''' then
                  term := term + ''''
                else
                  term := term + '&quot;';
                continue;
              end;
        end;

        if inquote then
        begin
          term := term + sts[curpos];
          continue;
        end;
        //else
        //BEGIN
        if intagword then
        begin
            try
              if term = '!--' then
              begin
                continue;
              end;
              if (term = '') and (sts[curpos] = '/') then  // </
              begin // empty word  oldcontent</somethingendinghere
                inendtag := True;
                intagword := False;
                continue;
              end;
              if (pos(sts[curpos], whitespace) > 0) or (sts[curpos] = '>') or
                ((sts[curpos] = '/') and (paslen > curpos) and (sts[curpos + 1] = '>')) then // <  xx
              begin  //ends the body of tag name
                if low then      term := ansilowercase(term);
                //prop    _newprop(tag, term);

                if tag <> nil then
                  newtag := tag.addsubtag(term, '') else writeln('<h1>ending a nil tag -please report problem</h1>');
                //writeln('<h4>Start:',curpos,_clean(term),'/under:',tag.vari,'!</h4>');
                //if (term='head') or (term='body') then writeln('<li>starting tag:',term);
                tag := newtag;
                intagword := False;
                if pos(sts[curpos], whitespace) > 0 then  //attributes forthcomin?
                  inparvar := True
                else if sts[curpos] = '>' then
                begin
                  incont := True;
                  //if curpos < paslen - 1 then
                    //if sts[curpos + 1] + sts[curpos + 2] = crlf then
                    //  skip := 2;
                end
                else
                begin  // tag ends with />, will handle the ending ">" next
                  inendtag := True;
                  continue;
                end;
                term := '';
                attname := '';
              end
              else
                term := term + sts[curpos];
              continue;
            except
              writeln('failed parsing intag<xmp>'+cla+'</xmp>');
            end;
          end
        else
        if inendtag then
        begin
            try
              //if curpos=paslen then begin writeln('<li>atendparse:'+tag.head+'!!!');  end;
              if onetagonly then
              begin
                 //writeln('<h2>did firsttag endtag:',term,'</h2><xmp>!',tag.xmlis,'</xmp>',curpos,'<xmp>!',copy(sts,1,curpos),'</xmp>','<xmp>!',copy(sts,curpos+1,999),'</xmp>');
                 posit:=curpos;
                 break;
              end;
              if sts[curpos] <> '>' then
              begin
                 term := term + sts[curpos];
                 //writeln('<li>noclose:',term,'<b>_',sts[curpos],'_</b>/in'+tag.vari);
              end else
              begin
                term:=trim(term);
                //writeln('!<pre>'+basetag.xmlis+'</pre>!!!!!<pre>'+tag.xmlis+'</pre>!!!!');
                oldtag := tag;
                //if (term='head') or (term='body') then
                // begin writeln('<li>ending tag:',term);
                // writeln('<li>!closetag:'+tag.vari+'::'+term+' under:'+tag.parent.vari);
                // end;
                if (ansilowercase(tag.vari) = ansilowercase(trim(term))) then
                begin
                    if tag=basetag then break;
                    tag := tag.parent;
                end else
                begin
                  opentree:=_uptree(tag,tagtoclose,term,basetag); ////tagtoclose=the closest starttag with nae of this endtag
                  //writeln('<li>nnnmatchingend:');
                  try
                   if inmarkdown then //and (term='p') then
                   begin
                      //test for handling markdown errors
                     try
                     //if tagtoclose=nil then begin writeln('niltag:'+tag.xmlis+'<hr/>/BaSE:',basetag.xmlis,'!!');break;end;
//                     writeln('<li>Invalid_end!'+term+'/tag:<b>'+tag.head,'</b> /UNDER:',tag.parent.head+'//UNDER</li>'+'/sofar:<pre>',_clean(basetag.xmlis),'</pre><hr/>');
                     //if tag.parent.att('markdown')='true' then
//                     writeln('<li>Not closing?:'+tag.parent.att('markdown')+'!!</li>');
                     except writeln('zzzzzzzzzzzzzzzzzz');end;
                       //if tag.parent.parent<>basetag then
                     //if tag.parent.att('markdown')='true' then //ending
                     //   tag.moveto(tag.parent.parent) else tag:=
                     if not((tagtoclose=nil) or (tagtoclose.parent=nil)) then
                     begin
                     if tagtoclose.att('markdown')='true' then //end anything started by markdowned blocks and move current one from under it
                      tag.moveto(tagtoclose.parent)
                     else   tag:=tagtoclose.parent;
                     end; //else just ignore the closin tag
                     //writeln('<li>fixedmd:'+term+'/tag:<b>'+tag.vari,'</b>/under:',tag.parent.head);//+'/sofar:<pre>',_clean(basetag.xmlis),'</pre>');
                     inendtag := False;
                     incont := True;
                     term:='';
                     continue;
                   end else
                   begin
                     try
                      //opentree:=_intree(tag,tagtoclose,term,basetag); ////tagtoclose=the one this tag should close
                       //try
                       //writeln('<li>Invalid end:'+term+'/tag:<b>'+tag.vari,'</b>/under:',tag.parent.head+'/auto:',pos('<'+ansilowercase(tag.vari)+'>',gc_autoclosers)>0,'/void:',pos('<'+ansilowercase(tag.vari)+'>',gc_html5voids)>0);
                       //except writeln('<li>trying to close base</li>',tagtoclose=nil);end;
                       if tagtoclose<>nil then
                       begin
                         for j:=opentree.count-1 downto 0 do
                         begin
                           atag:=ttag(opentree[j]);
                           //if (term='head') or (term='body') then
                           //   writeln('<li>autoclosing:'+atag.head+'/reason:/'+term+'/under:'+atag.parent.head+' /for:'+tagtoclose.head);
                           if pos('<'+ansilowercase(atag.vari)+'>',gc_html5voids)>0 then
                           begin
                             if trim(atag.vali)<>'' then tagtoclose.addsubtag('',atag.vali);
                             //writeln('<li>void-',j,',',atag.head);
                             //tagtoclose.addval(atag.vali);
                             atag.vali:='';
                             while atag.subtags.count>0 do ttag(atag.subtags[0]).moveto(tagtoclose);
                             //for k:=0 to atag.subtags.count-1 do ttag(atag.subtags[k]).moveto(tagtoclose);
                             //writeln('x3');
                           end
                           //else
                            //writeln('<li>UNSTARTED' +term+'/closeup:<b>',tagtoclose.vari+'</b>  ',tagtoclose.head,'<b>',atag.vari,' </b>',atag.head,'!!');
                         end;
                         tag:=tagtoclose.parent;
                         //opentree.free;opentree:=nil;
                       end;
                        except writeln('<li>failed parse bracket endtag for : /'+term);end;
                   end;
                   finally opentree.free;opentree:=nil;end;
                  end;
                  term := '';
                  attname := '';
                  inendtag := False;
                  incont := True;
                  //writeln(' to element '+tag.vari);
                  continue;
                end;
            except writeln('failed in endtag'); end;
        end
        else
            try
              if inparvar then
              begin
               //   if oneonly then writeln('#'+sts[i],'#');
                if sts[curpos] = '=' then
                begin
                  inparvar := False;
                  inparval := True;
                  attname := term;
                  term := '';
                end
                else
                if sts[curpos] = '>' then
                begin
                  inparvar := False;
                  incont := True;
                  addattr;
                  if onetagonly then
                  begin
                     //writeln('<h2>did firsttagtag parvar:',term,'</h2><xmp>!',tag.xmlis,'</xmp>',curpos,'<xmp>!',copy(sts,1,curpos),'</xmp>','<xmp>!',copy(sts,curpos+1,999),'</xmp>');
                  end;

                  incont := True;
                  term := '';
                  attname := '';
                end
                else
                if (sts[curpos]='/') and (paslen>curpos) and (sts[curpos+1]='>') then
                begin
                  inendtag := True;
                  addattr;
                  term := tag.vari;
                  attname := '';
                  inparvar := False;
                  inparval := False;
                  continue;
                end

                else
                if pos(sts[curpos], whitespace) < 1 then
                begin
                  term := term + sts[curpos];
                end
                else
                begin
                  if trim(term)<>'' then begin //writeln('<li>X:',term);
                   continue;end;
                  addattr;
                  term := '';
                  attname := '';
                  inparval := False;
                  inparvar := True;
                  continue;
                end;
                continue;
              end;
            except
              writeln('failed inparvar');
              tag.listwrite;
              raise;
            end;
          try;
        if inparval then
        begin
              if (sts[curpos] = '>') or ((sts[curpos] = '/') and (paslen > curpos) and
                (sts[curpos + 1] = '>')) then
              begin
                //if param = 'contentEditable' then
                //begin
                //end;
                inparval := False;
                term := _cleanattr(term);
                //tag.attributes.add(param + '=' + term);
                addattr;//tag.setatt(attname,term);
                term := '';
                attname := '';
                if sts[curpos] = '>' then
                begin
                  incont := True;
                  continue;
                end
                else
                begin
                  inendtag := True;
                  term := tag.vari;
                  continue;
                end;
                continue;
              end
              else
              if pos(sts[curpos], whitespace) > 0 then
              begin
                //tag.attributes.add(param + '=' + _cleanattr(term));
                IF trim(term)='' then begin continue;end;
                addattr;//tag.setatt(attname,_cleanattr(term));
                term := '';
                attname := '';
                inparval := False;
                inparvar := True;
                continue;
              end
              else
                term := term + sts[curpos];
              continue;
            end;
          except
            writeln('failed inparval');
            raise;
        end;
        try
        if incont then
            begin
              if onetagonly then
              begin
                 //writeln('<h2>did firsttag cont:',term,'</h2><xmp>!',tag.xmlis,'</xmp>',curpos,'<xmp>!',copy(sts,1,curpos),'</xmp>','<xmp>!',copy(sts,curpos+1,999),'</xmp>');
                 posit:=curpos;
                 break;
              end;

              if (sts[curpos] = '<') then
              begin
                if (paslen > curpos + 1) then  //pretty?
                  if sts[curpos + 1] = '!' then
                    if sts[curpos + 2] = '-' then
                      if sts[curpos + 3] = '-' then
                      begin
                        comtext := '';
                        incomment := True;
                        skip := 2;
                        continue;
                      end;
                if (paslen>curpos) then
                  //if pos(sts[i + 1], whitespace) > 0 then
                  if (sts[curpos+1]<>'/') and (not (sts[curpos+1] in gc_namechars)) then
                  begin  //was not start of a new tag after all
                    term := term + '&lt;';
                    continue;
                  end
                  else
                    incont := False;

                if ((not trimmaa and (term <> '')) or (trimmaa and (trim(term) <> ''))) then
                begin
                  if tag <> nil then
                    if tag.subtags.Count > 0 then
                    begin
                      if trimmaa then
                      begin
                        if term<>'' then
                         //prop tag.addsubprop(propvaris, '', trim(term));
                         tag.addsubtag('',trim(term))
                      end
                      else
                       //prop  tag.addsubprop(propvaris, '', term);
                       tag.addsubtag('',term)
                    end
                    else //no subtags
                    begin
                      tag.vali := (term);
                    end;
                end;
                incont := False;
                intagword := True;
                term := '';
                attname := '';
                continue;
              end   // of a "<"
              else
              begin
                if sts[curpos] = '>' then
                  term := term + '&gt;'
                else
                  term := term + sts[curpos];
              end;
              continue;
            end;
          except
            writeln('failed in element content');
          end;
        //END;
      finally end;//if curpos=paslen then begin writeln('<li>endparse:'+tag.head+'!!!'+sts[curpos]); end; end;
      end;

    except
      writeln('Clause noparse', incont, inquote, inparval, inparvar);
      raise;
    end;
  finally
    //propvars.Free;
    //propvaris.Free;

    //if t_debug then
    begin
     try
      //writeln('<li>',basetag.vari,'//PARZ3<xmp>',basetag.xmlis,'</xmp><hr/><hr/>didparse', skipstart);
     except writeln('<li>failed list parsed atg');end;
     try
     //if (tag<>basetag) then
    // t_lastopentag:=tag;
    //Writeln('<h3>!!-!OPeN',ttag(t_lastopentag).vari,'TAG'+ttag(t_lastopentag).xmlis+'!-!!</h3>');

 except writeln('<li>failed find opentatg');end;

      //basetag.listwrite;
      //writeln('/PARZ4', basetag.subtags.Count, '<xmp>');
      //basetag.listraw;
      //writeln('/PARZ4', ttag(basetag.subtags[0]).subtags.Count, '</xmp>');
    end;
    //writeln('<li>FINISHPARSE:',term,'/base:<pre style="background:red">',_clean(basetag.xmlis),'</pre><hr/>TAG;<pre>',tag.xmlis,'</pre>',basetag=tag);
    if basetag.subtags.count>0 then
    begin
       Result := basetag.subtags[0];
      basetag.clearmee;
      basetag.free;
    end else
         Result := basetag;
    //writeln('<li>gotresults');
    //if t_lastopentag<>nil then Writeln('<h3>!!-!2OPeNTAG'+ttag(t_lastopentag).xmlis+'!-!!</h3>');

  end;
  //writeln('PARSED:<pre>'+result.xmlis+'</pre>');
  //writeln('<h1>didparsec</h1> ');
end;


{constructor ttag.createst(par: ttag; vars: string);
begin
  inherited create;
  //subtags := TList.Create;
  //attributes := TStringList.Create;
  parent := par;
  if par <> nil then
    xdontclosetags := parent.xdontclosetags;
  if pos(' ', vars) = 0 then
    vari := vars
  else
    //vari:=(vars);
    vari := trim(vars);
  //if txseus(currentxseus) <> nil then
  //  if txseus(currentxseus).elems <> nil then
  //    mythreadelems.add(self)
  //  else
  //    writeln('<span title="no elestrore">XXX</span>');
  //if txseus(currentxseus).xstarted then
  //  xrefcount := 1;  //for debugging new mem management
end;}
{function createpersistenttag:ttag;
var elemlist:tlist;
begin
 elemlist:=t_elemlist;
 result:=ttag.create;
 t_elemlist:=elemlist;
end;
}

function createtag(par: ttag; vars: string):ttag;
  begin
  result:=ttag.create;
  //subtags := TList.Create;
  //attributes := TStringList.Create;
  result.parent := par;
  if par <> nil then
    result.xdontclosetags := par.xdontclosetags;
  if pos(' ', vars) = 0 then
    result.vari := vars
  else
    //vari:=(vars);
    result.vari := trim(vars);
  //if txseus(currentxseus) <> nil then
  //  if txseus(currentxseus).elems <> nil then
  //    mythreadelems.add(self)
  //  else
  //    writeln('<span title="no elestrore">XXX</span>');
  //if txseus(currentxseus).xstarted then
  //  xrefcount := 1;  //for debugging new mem management
end;

//procedure ttag.fromfile(fil: string; hdr: TStringList);
function tagfromfile(fil: string; hdr: TStringList): ttag;
var
  sl: TStringList;
  EXT: string;   trimmaa:boolean;
begin
  result:=nil;
  try
    sl := TStringList.Create;
    try
      sl.loadfromfile(fil);
    except
      writeln('<--failed to find object file:' ,fil,'-->');
     // result:=ttag.create;  //do we want this?
      exit;
    end;
    try
      if sl.Count > 0 then
      begin
        if pos('encoding="utf-8"', lowercase(sl[0])) > 0 then
        begin
          //sl.text:=_utf8toasc(sl.text);
          sl.Text := utf8toaNSI(sl.Text);
          //writeln('<li>UTF</li>');
        end;
        ext := extractfileext(fil);
        //if (ext='.xsi') THEN  //writeln('FIFIFIFIF'+fil,SL.Text,'!',sl[0]);
        //writeln('|'+ext+'-------------'+fil);
        //if pos('edit',fil)>0 then   //writeln('FIFIFIFIF'+fil,SL.Text,'!',sl[0]);
        //writeln('|'+extractfileext(fil)+'---------extractiuon htmi',LENGTH(extractfileext(fil)));
        // if (pos('?xmlis',sl[0])=1) then
        //  writeln('parsing xmlis'+sl.text);
       if hdr<>nil then trimmaa:=hdr.values['trim']='true';
        if (ext = '.xsi') or (ext = '.htmi') or (pos('?xmlis', sl[0]) > 0) then
        begin
          if (pos('?xmlis', sl[0]) = 1) then
            sl.Delete(0);

          //if pos('sauna',fil)>0  then writeln('XMLIS;;;'+sl.text);
          TRY
          //LOGWRITE('XXXXXXXXXXXXXXXX');
          Result := tagparsexmlis(sl);
          //LOGWRITE('////XXXXXXXXXXXXXXXX');
          EXCEPT WRITELN('FAILED To PARse xsi-FILE');END;
        end
        else
        begin
          if pos('<?xml ', sl[0]) = 1 then
            if hdr <> nil then
              if not (hdr.values['headers'] = 'true') then
                sl.Delete(0);
          Result := tagparse(sl.Text, true, true);
        end;
        //parse(sl.text,false,true);
      end;
      //writeln('got file:'+sl.text+'**********'+result.xmlis+'***');
    except
      writeln('failed to parsefromfile', fil);
    end;
  finally
    //writeln('parsedfromfile'+fil);
    sl.Clear;
    sl.Free;
  end;
end;

{procedure ttag.fromfile(fil:string;hdr:tstringlist);
var sl:tstringlist;
begin

try
 sl:=tstringlist.create;
 try
 sl.loadfromfile(fil);
 except
  //writeln('extractiuon htmi'+sl.text);
 end;
try
 if sl.count>0 then
 begin
  if pos('encoding="utf-8"',lowercase(sl[0]))>0 then
  sl.text:=_utf8toasc(sl.text);
  if pos('<?xml ',sl[0])=1 then
   if hdr<>nil then if not(hdr.values['headers']='true') then
   begin
    sl.delete(0);
   end;
  parse(sl.text,false,false);
  //parse(sl.text,false,true);
 end;
except
  writeln('failed to parsefromfile');
end;
finally
  //writeln('parsedfromfile'+fil);
  sl.clear;
  sl.free;
end;
end;
}
//procedure ttag.fromfileind(fil: string);
function tagfromfileind(fil: string): ttag;
var
  sl: TStringList;
  ext: string;
begin
  ext := extractfileext(fil);

  sl := TStringList.Create;
  try
    sl.loadfromfile(fil);
    try
      if sl.Count > 0 then
      begin
        //parseyaml(sl);
        // writeln('<LI>loadffomfileIND1'+sl[0]);

        if (pos('?xmlis ', sl[0]) = 1) then
          sl.Delete(0);
        //write('<LI>loadEDffomfileind'+sl.text);
        Result := tagparsexmlis(sl);
        //writeln(listraw);
      end;
    except
      writeln('failed to parseyamlfile');
    end;
  finally
    sl.Clear;
    sl.Free;
  end;
end;

//procedure ttag.fromfiledots(fil: string);
function tagfromfiledots(fil: string): ttag;
var
  sl: TStringList;
  ext: string;
begin
  ext := extractfileext(fil);

  sl := TStringList.Create;
  try
    sl.loadfromfile(fil);
    try
      if sl.Count > 0 then
      begin
        Result := tagparsexmlis(sl);
      end;
    except
      writeln('failed to parsedotsfile');
    end;
  finally
    //writeln('parsedfromfile'+fil);
    sl.Clear;
    sl.Free;
  end;
end;

constructor ttag.Create;
var elist:tlist;
begin
  //inherited Create;
  xrefcount := 1;
  xquoted := False;
  elements_created:=elements_created+1;
  subtags := TList.Create;
  attributes := Tattributes.Create(self);
  //attributes := Tstringlist.Create;
  parent := nil;
  //if g_memtest then
  if t_currentxseus=nil then exit;
  elist:=txseus(t_currentxseus).x_elemlist;
  if elist <> nil then
  begin
      memregnum:=elist.count;
      elist.add(self);
      txseus(t_currentxseus).x_elemrefcount.add(pointer(1));
     // writeln(t_elemlist.count,'XXXXXXX');
    end
   //  if txseus(currentxseus).x_elemlist <> nil then
   { if t_elemlist<>nil then
     begin
       memregnum:=t_elemlist.count;
       t_elemlist.add(self);
       t_elemrefcount.add(pointer(1));
      // writeln(t_elemlist.count,'XXXXXXX');
     end
    else }
   //writeln('<span title="created persistent elem / session started">.</span>');
end;


procedure ttag.xfree(x: string);
begin
  writeln('free', memregnum, x);
end;

destructor ttag.freemee;
begin
  killtree;
  //inherited Free;
end;

destructor ttag.killtree;
var
  i,curi: integer;done:boolean;curt,nextt:ttag;todos:tlist;    tmp,turha:string;//mydebug:boolean;
begin
  todos:=tlist.create;

  if self=nil then exit;
  todos.add(self);
  curt:=self;
  //writeln('<h4>kill:'+vari+'</h4><ul>');
  try
  i:=0;
  while todos.count>0 do
  begin
   if curt=nil then
    WRITELN('<LI>try nil at ',todos.count);
   //i:=i+1;
   //if i>1000000 then break;
  try
    IF curt.XREFCOUNT>1 THEN  begin
        curt.xrefcount:=xrefcount-1;
      continue;
    end;
    if curt.subtags.count<1 then
     begin
      //writeln('<li>kill:'+curt.vari+'</li></ul></li>');
      todos.Delete(todos.count-1);
       if todos.count=0 then BEGIN
         //WRITELN('<LI>NOTHINTODO</UL>');
         break;END;
      try
      nextt:=todos[todos.count-1];
      except writeln('<li>failedkill:'+'!',todos.count); end;
      //writeln('<li>nextup:'+nextt.vari+'</li>');
      curt.clearmee;curt.free;
      if todos.count=0 then BEGIN //WRITELN('<LI>NOTHINTODOnext</UL>');
        exit;END;
     end else
     begin
      try
       nextt:=curt.subtags[0];
       try curt.subtags.delete(0);

       except    end;
       //writeln('<li>dfrom:'+curt.vari+'<ul>');
       //writeln('<li>ndown:'+nextt.vari,'#',TODOS.COUNT,'</li>');
       todos.add(nextt);
      except writeln('<li>failedaddkills:'+curt.vari+'</li></ul></li>'); end;
     end;
     curt:=nextt;
  except
    logwrite('FAILEDKILLELEMENTTREE');
    //WRITELN('EMENT:'+turha);
    //raise;
  end;
  end;

  finally
  todos.free;
  clearmee;
 // inherited free; //????????

  //inherited free;
   // writeln('</ul><h4>killed</h4>');
  end;
end;
{procedure ttag.killtree;
var
  i: integer;    tmp,turha:string;//mydebug:boolean;
begin
  try
  if self=nil then exit;
  tmp:=vari;
    IF XREFCOUNT>1 THEN
    begin
      xrefcount:=xrefcount-1;
      exit;
    end;
    try
    //logwrite('KIDSOF:'+vari);
    for i := subtags.Count - 1 downto 0 do
    begin
         ttag(subtags[i]).killtree
    end;
    except
      logwrite(inttostr(subtags.Count)+'-killtree nogo'+inttostr(i));
    end;
    //logwrite('DIDKIDS');
    try
    clearmee;
    except
      logWRITE('failed clerarmee');
    end;
  except
    logwrite('FAILEDKILLELEMENTTREE');
    //WRITELN('EMENT:'+turha);
    //raise;
  end;
end;
 }
procedure ttag.clearmeE;
var
  i,orefcount: integer;
begin //note does not clear subtags in testmem-state
  try     //write('.');
   // logwrite('kill:'+vari+inttostr(subtags.count));
    try
    if g_memtest then
    begin
      orefcount:=integer(txseus(t_currentxseus).x_elemrefcount[memregnum]);
      //writeln('<li>clear:',vari,orefcount,'(',xrefcount,' ',memregnum);
       //this for temporary test-system to find memory-leaks or extra attemps to free
       try
        txseus(t_currentxseus).x_elemrefcount[memregnum]:=pointer(orefcount-1);
       except
         writeln('refcounterrorB:',vari,memregnum,'/', txseus(t_currentxseus).x_elemrefcount.Count)
       end;
       if orefcount<>xrefcount then writeln('refcountcounters differ',vari);
    end;
    except
      writeln('refcounterrorA:',vari,memregnum,'/', txseus(t_currentxseus).x_elemrefcount.Count)
    end;
    xrefcount := xrefcount - 1;
   // if vari='root' then writeln('<h2>','KILLROOT','</h2>');
   // if vari='form' then writeln('<h2>','KILLform','</h2>');
    elements_freed := elements_freed+ 1;
    //if xrefcount<0 then writeln(' !_'+vari+'_!',xrefcount);
    if g_memtest then
      exit;      // currently only marks as "would have been killed
    if xrefcount>0 then
    begin
       writeln(' keep:'+vari);
       exit;
    end;

   { try
      if subtags <> nil then
        subtags.Clear;
    except
      writeln('<li>subtags of ', vari, ' clear-error</li>');
    end;}
    try
      if subtags <> nil then
      subtags.clear;
    except
      writeln('<li>subtags of ', vari, ' clear-error</li>');
    end;
    try
    //this gives errors in killtree. why)
     if parent <> nil then
      parent.subtags.remove(self);
    except
      //writeln('<li>failed remove', vari, ' from parent subtags</li>');
    end;
    try
      //if attributes <> nil then

      attributesClear;
      attributes.Free;
    except
      writeln('<li>attributes memory-error</li>');
    end;
    subtags.Free;

  except
    writeln('<li>memory-error</li>');
  end;
  //inherited free;
end;



function tagparsexmlis(sl: TStringList): ttag;
var
  i, ichars, thisind, prevind: integer;
  line: string;
  partag, thistag, prevtag, roottag: ttag;

  function _getfirstword(lin: string; var curpos: integer): boolean;
  var
    i, len: integer;
  begin
    Result := True;
    len := length(lin);
    for i := curpos to len do
    begin
      if pos(lin[i], ' ;,"+#(''''') > 0 then
      begin
        //result:=false;
         //if lin[i] = '+' then
         //logwrite('<li>gotplus:');
        curpos := i;
        exit;
      end
      else

      if lin[i] = ':' then
        if i = len then
        begin
          curpos := i;
          exit;
        end
        else
        if pos(lin[i + 1], whitespace) > 0 then
        begin
          curpos := i;
          exit;
        end;// else

    end;
    //curpos:=i;
    curpos:=len + 1;
  end;



  function _parseats(tagi: ttag; lin: string; var curpos: integer): boolean;
  var
    ii, len,thisfar: integer;
    inq, skipwhite: boolean;
    c: char;
    par: string;
  begin
    try
      Result := False;
      skipwhite := True;
      thisfar:=curpos+1;
      if trim(line) = '' then
        exit;
      //if line[i]<>')' then

      inq := False;
      len := length(lin);
      for ii := curpos + 1 to len do
      begin
        c := lin[ii];
        //if c='¤' then break;
        //if c=' '  then
        //    continue;
        if skipwhite then
        if pos(whitespace, c) > 0 then
          continue;
        skipwhite := False;
        //IF INQ THEN write(',',c) ELSE WRITE('_',C);
        if inq then  //within quotes
        begin
          if c = '"' then
          begin
            //tagi.attributes.add(par);par:='';
            //writeln('***'+par+'///');
            inq := False;
          end
          else
            par := par + c;
        end
        else  //not in quoted
        begin
          //if c=')' then  ### SYNTAX CHANGE
          if (c = ':') and ((ii = len) or (pos(lin[ii + 1], whitespace) > 0)) then
          begin
            //writeln('<li>atsend:',tagi.vari,length(par),par,'|');
            //if trim(par) <> '' then tagi.addatt(trim(par));
            tagi.addatt(par);
            //if pos('sep',par)>0 then writeln('<li>parseP|',cut_rs(par)+'|</li>');//<xmp>'+tagi.listraw+'</xmp>');
            //tagi.attributes.add(par);
            par := '';
            curpos := ii + 1;
            exit;      //no more atts
          end
          else
          if c = ' ' then
          begin
            if trim(par)<>'' then tagi.addatt(par);
            //if trim(par)<>'' then tagi.addatt(trim(par));
            //if pos('sep',par)>0 then writeln('<li>parseP|',cut_rs(par)+'|</li>');//<xmp>'+tagi.listraw+'</xmp>');
            par := '';
            skipwhite := True;
            //writeln('<li>aat:',tagi.attributes.text,'</li>');
          end
          else
          if c = '"' then
            inq := True
          else
            par := par + c;
        end; //for-loop
      end;
      if trim(par) <> '' then
            tagi.addatt(trim(par));
            par := '';
            curpos := ii + 1;
    except
      writeln('failed parseatts in parseindents');
    end;

  end;
  function _gettextval(src: string; var curpos: integer;
  var inquotedpar: boolean): string;  //not used now, needed if we parse inline comments
  var apos:integer;
  begin
    apos:=pos('''''''',src);
    if apos<1 then result:=copy(src,curpos+1,length(src)) else
    begin
    result:=copy(src,apos+3,length(src));
    apos:=pos('''''''',result);
    if apos>0 then result:=copy(result,1,apos-2) else
    inquotedpar := True;

    //writeln('<li>TVAL['+result+']'+''''''+'/from:{'+src+'}');
    end;
    curpos:=length(src);
    //if pos('<li>GO',src)>0 then writeln('<li>try:['+result+']'+''''''+'!');
  end;
  function _gettextvalold(src: string; var curpos: integer;
  var inquotedpar: boolean): string;  //not used now, needed if we parse inline comments
  var
    ch, nch: char;//CURPOS,
    len: integer;
  begin
    Result := '';
    //curpos:=1;
    len := Length(src);
    if curpos>len then exit;//begin    writeln('<li>finis:'+tag.head)+'|</li>');   exit;end;
    repeat
      ch := src[curpos];
      if ch = '''' then
        if (curpos + 1 < len) and (line[curpos + 1] = '''') and
          (line[curpos + 2] = '''') then
        begin             // '''   len=3, curpos=1
          inquotedpar := True;
          exit;
        end;
      begin
        Result := Result + src[curpos];
        curpos := curpos + 1;
      end;
    until curpos > len;
    //Result := trimright(Result);
  end;


var
  curpos: integer;tagword,startwhite:string;
  inquotedpar,incommentedpar: boolean;
begin
  partag := nil;
  roottag := nil;
  inquotedpar := False;
  incommentedpar := False;
  try
    for i := 0 to sl.Count - 1 do
    begin
      try
        if inquotedpar then
        begin
          if pos('''''''', sl[i]) > 0 then
          begin  //will have to deal with escaped """'s
            inquotedpar := False;
            partag.xquoted := True;
            partag.vali:=partag.vali+copy(sl[i],0, pos('''''''', sl[i])-1);
            continue;
          end;
          partag.vali := partag.vali + sl[i] + lf;
          continue;
        end;
        if trim(sl[i]) = '' then
          continue;
        line := sl[i];
        ichars := 1;
        prevind := thisind;
        thisind := 0;
        while (ichars < length(line)) do
        begin
          if (line[ichars] = ' ') then
          begin
            thisind := thisind + 1;
            ichars := ichars + 1;
          end
          else if (line[ichars] = #09) then  //handle tabs
            //very crude - basically tabs are not supported
          begin
            thisind := thisind + (gc_tabsize - (thisind mod gc_tabsize));
            ichars := ichars + 1;
          end
          else
            break; // whitespace skipped over
        end;
        curpos := ichars;
        if (incommentedpar) then
            if thisind>prevind then
            begin //writeln('endcomment');
             thisind:=prevind;continue;
            end else incommentedpar:=false;
        if line[curpos] = '#' then
        begin
          if copy(line,curpos,3)='###' then incommentedpar:=true;
          continue
        end;
        if (curpos=1) and (partag<>nil) then begin thisind:=partag.hasindent;partag:=partag.parent; end else
        if (partag <> nil) and (partag <> roottag) then
          while (thisind <= partag.hasindent) do
          begin
            try
              //writeln('-',partag.vari+'/');
              partag := partag.parent;
            except
              writeln('failindent', thisind)
            end;
          end;
        if line[curpos] = '@' then
        begin  //this has to be handled. now just reads one att=val  strig
          _parseats(partag, LINE, curpos);
          //partag.attributes.add(copy(line,curpos+1,9999));
          continue;
        end;
        //INDENTATION HANDLED. NOW CONTENT OF LINE
        if (line[curpos]=':') or (line[curpos]='.') or ((curpos=1) and (partag<>nil)) then
        begin
          //logwrite('#'+line+inttostr(curpos)+line[curpos]);
          startwhite:=' ';
          //if (line[curpos]=':') then startwhite:=crlf+crlf else
          if (line[curpos]='.') then startwhite:=lf;
          if curpos>1 then  curpos := curpos+1;//2;

          //if line[curpos]<>' ' then startwhite:=crlf else begin startwhite:=' ';curpos:=curpos+1;end;
          //if (partag <> nil) and
          if   (partag.subtags.Count = 0)    then
          begin
            //logwrite('w:'+startwhite+'/t:'+partag.vali+'?' + startwhite+'?'+copy(line,curpos,9999)+'!');
            partag.vali := partag.vali+ startwhite+_gettextval(line, curpos, inquotedpar);
            //partag.vali := partag.vali+ startwhite+copy(line,curpos,9999);
            //logwrite(partag.vali+ '---'+partag.xmlis+crlf);
          end
          //else      if (partag.lastsubtag.vari)='' then
          //  partag.lastsub.vali := partag.vali + startwhite+_gettextval(line, curpos, inquotedpar);


          else
          begin
            thistag := ttag.Create;
            thistag.hasindent := thisind;
            thistag.parent := partag;
            partag.subtags.add(thistag);
            thistag.vari := '';//VALUE
            thistag.vali := _gettextval(line, curpos, inquotedpar);
            //thistag.vali := copy(line, curpos+1, length(line));
            if startwhite=crlf then thistag.vali:=lf+thistag.vali;
            //writeln('<li>gottextline:',curpos,'|',thistag.vali,'',line[curpos],'</li>');
            //thistag.listraw;
          end;
          partag:=thistag;
          continue;
        end;
        //normal line wth element, possibly atts and text
        begin
           _getfirstword(line, curpos);
           tagword:=copy(line, ichars, curpos - ichars);
          thistag := ttag.Create;
          thistag.hasindent := thisind;
          if partag = nil then
          begin
            partag := thistag;
            roottag := thistag;
          end else
          begin
            thistag.parent := partag;
            partag.subtags.add(thistag);
           end;
          //line:=copy(line,thisind,length(line));
          thistag.vari := tagword; //copy(line, ichars, curpos - ichars);
          //logwrite('elem:'+thistag.vari+inttostr(curpos)+' // '+inttostr(ichars)+' //'+line+'//'+inttostr(length(line)));
          partag := thistag;
          if (length(line) > curpos) then
            //##SYNTAX CHANGE if line[curpos]='(' then  //atts ( start directly
            if line[curpos] <> ':' then
            begin
              _parseats(thistag, LINE, curpos);
              //for apui:=1 to thistag.attributes.count-1 do writeln:
              //line:=copy(line,donepos,length(line));
            end
            else
              curpos := curpos + 1;
          //writeln('<li>noats:'+line+'</li>');
          //if donepos<length(line) then
          //writeln('<li>rest?'+line+'|',curpos,copy(line,curpos,999)+'|'+'</li>');
          if length(line) > curpos then //line goes on .. with value for tag
            //if line[curpos]=':' then
          begin
            //if thistag.vari='id' then
            // writeln('GETLINE'+line,curpos,'/',line[curpos],'\',copy(line,curpos,999));
            //while (pos(line[curpos],' '+#9)<1) do
//            while (pos(line[curpos], ' ' + #9) > 0) do
//              curpos := curpos + 1;  //skip whitespace
            try
              thistag.vali := _gettextval(line, curpos, inquotedpar);
              //thistag.vali := copy(line, curpos+1, length(line));
            except
              writeln('--------failtextline' + line);
            end;
          end;// else  partag:=thistag;
        end;
      except
        writeln('failed parsing line ', i);
      end;
    end;

  finally
    RESULT:=ROOTTAG;

    //sl.free;
    TRY
     //LOGWrite('xDIDPARSEONE');
    EXCEPT WRITELN('NMOGO');END;
  end;
end;


function _xwrap(str,indent:string;width:integer):string;
var i,linelen:integer;ch:char;
begin
 //if pos('taaseka',str)>0 then writeln('xwrap:<pre>!-'+str+'-!</pre>');
 //wid:=strtointdef(width,60);
 //ind:=copy('                                         ',1,strtointdef(indent,0));
 result:='';//indent+': ';  //or ''?
 linelen:=0;
 for I := 1 to length(str) do
 begin
  ch:=str[i];
 // if pos('taaseka',str)>0 then writeln('-'+ch+'-');
   if (ch=^J) then CONTINUE;// else;//ch:=' ';
   if (ch=^M) then
   begin
     //if result='' then
     result:=result+lf+indent+'. '
     ;//else
     //result:=result+crlf+indent+'  ';
    //result:=result+^M^J+indent+'. ';
     // result:=
      linelen:=0;
   end  else
   if (linelen>width) and (ch=' ') then
   begin
     result:=result+^M^J+indent+':  ';linelen:=0;
   end  else result:=result+ch; //begin if result='' then result:=': '+ch else result:=result+ch;end;
   linelen:=linelen+1;
 end;
 //if pos('taaseka',str)>0 then writeln('<li>taas:',length(indent),'<xmp>!!!!!!!!!!!!!!'+result+'!!!!!!!!!!!!</xmp>');
end;

function _onelinexml(tagi:ttag;inde:string):string;
  function etrim(v:string):string;
    begin
      result:=v;
        //if ents then begin result:=trim(_clean(v));writeln('<li>cleaning:' +result);end else result:=v;//trim(v);
    end;
var i:integer;st:string;

begin
    if tagi.vari = 'cdata' then
    begin
      result:= '<![CDATA[' + StringReplace(tagi.vali,  ']]>', ']]]]><![CDATA[>', [rfreplaceall]) + ']]>';
      exit;
    end;
    if (tagi.vari = '') then
     begin
      result := etrim(tagi.vali);
      exit;
      //subc := subc + '!'+(ttag(subtags[i]).vali)+'/'+inttostr(i);
      //writeln('<li>',vari,'vali:'+'/'+ ttag(subtags[i]).vali+ '\');
     end;
    try
     result:=tagi.vari;
    if tagi.attributes<>nil then
    for i := 0 to tagi.attributes.Count - 1 do
    begin
      st := tagi.attributes.strings[i];
      //ost:=st;
      if length(st)>0 then
      begin
      st := StringReplace(st, '"', '&quot;', [rfreplaceall]);
      st := StringReplace(st, crlf, '&#xA;', [rfreplaceall]);
      st := StringReplace(st, ^M, '&#xA;', [rfreplaceall]);
      st := StringReplace(st, ^J, '&#xA;', [rfreplaceall]);
      //ost:=st;
       result := result+' '+cut_ls(st) + '="' + cut_rs(st) + '"';
      end;
    end;
   except writeln('<li>failed xmlis corrupt attribute!!'+st+'??',length(st));end;
   if (tagi.subtags.count=0) then
   begin
     if (tagi.vali='') then
       result:=inde+'<'+result+'/>' else
  result:=inde+'<'+result+'>'+tagi.vali+'</'+tagi.vari+'>';

   end else   result:=inde+'<'+result+'>'+tagi.vali;


end;

function x_list(ele:ttag):string;
var   counter:word;stop:boolean;
procedure res(st:string);
begin
 result:=result+st+^j;
 //writeln('<xmp>',st,'</xmp>');
end;
procedure tick;
begin
  counter:=counter+1;
  if counter>10000 then halt;
  //write('tic');
end;
vAR curs:ARRAY[0..64000] OF WORD; //,togos
  i,togo:WORD;curtag:ttag;ind:string;
  curlev:integer;
  stakki:tlist;
begin
 if ele=nil then exit;
 try
  try
   //logwrite('ELE:'+ele.xmlis);
  //writeln('start1:::',ele.vari,'!');
  except writeln('!!!startfail');raise;end;
  stakki:=tlist.create;
  curlev:=0;
  curs[curlev]:=0;
  //togos[curlev]:=1;
  curtag:=ele;
  counter:=0;
  stop:=false;
  //writeln('start2???');
  while curlev>=0 do
  begin
    counter:=counter+1;
    try
    //write(curlev,'.',stop);
    if stop then break;
    //if curlev<1 then break;
    try
    res(_onelinexml(curtag,ind));
    except writeln('<li>failoneline',curlev,'/',counter);write(curtag.vari,'xx');end;
    curs[curlev-1]:=curs[curlev-1]+1;
    //if curlev>0 then togos[curlev-1]:=togos[curlev-1]-1;// else write('<li>gogo');
    //if togos[curlev-1]>10000 then writeln('timetostop?',curlev);
    except writeln('!!!!!fail element list:',curlev);end;
    try
    if curtag.subtags.count>0 then
    begin  //go deeper
     try
      curlev:=curlev+1;
      curs[curlev-1]:=0;
      //togos[curlev-1]:=curtag.subtags.count;
      stakki.add(curtag);
      curtag:=curtag.subtags[0];
      ind:=ind+'  ';
      //writeln('<li>down:',curtag.head,'/');
      continue;
     except writeln('!!!deeper');raise;end;
    end;
    except writeln('!!!subtags');raise;end;
    try
    if curlev<=0 then break;
    //if togos[curlev-1]>0 then
    //write('<li>next from:',curtag.head,'_',curs[curlev-1],'/', ttag(stakki[curlev-1]).subtags.count);
    if curs[curlev-1]<ttag(stakki[curlev-1]).subtags.count then
    begin  //unhandled stuff at this level
      try
        curtag:=ttag(stakki[curlev-1]).subtags[curs[curlev-1]];
        //writeln(' to:',curtag.head,'/');
        //curs[curlev-1]:=curs[curlev-1]+1;
        //curtag:=ttag(stakki[curlev-1]).subtags[togos[curlev-1]];
      except writeln('<li>!!!next',curlev);raise;end;

    end else
    begin  //bactrack
     //while (curlev>0) and (togos[curlev-1]=0) do
      while (curlev>0) and (curs[curlev-1]>=ttag(stakki[curlev-1]).subtags.count) do
      begin //the previous one has no subtags left
        try
        //if curlev<1 then write('---------------shouldstop?');
        curlev:=curlev-1;
        //if curlev>0 then write(curlev,'!!',ttAG(stakki[curlev]).vari);
        ind:=copy(ind,3,9999);
        res(ind+'</'+ttAG(stakki[curlev]).vari+'>');
        stakki.delete(curlev);
        //if curlev<2 then try write('<li>closetoroot:',curlev,':',togos[1],'.',togos[0],'!',ttAG(stakki[0]).vari);except write('X');end;
        if curlev<1 then //begin writeln('EOS  ');
          break;//end;
        except writeln('<li>!!!faioneback',curlev);raise;end;
      end;
      if curlev<1 then begin //writeln('EOSX',curlev,' ');
        stop:=true;curlev:=curlev-1;break;end;
      try       //the level to jump back to has been found
        curtag:=ttag(stakki[curlev-1]).subtags[curs[curlev-1]];
        //writeln('<li>backtrack to: ',curtag.head);
        //curtag:=ttag(stakki[curlev-1]).subtags[togos[curlev-1]];
      //if curlev<1 then write('<li>xxxclosetoroot:',curlev,':',togos[1],'.',togos[0],'!',ttAG(stakki[0]).vari);
      except writeln('<li>!!!failstasck',curlev,'/',curs[curlev-1]);raise;end;
     end;
     except writeln('<li>!!!furtherx',curlev);raise;end;
    if curlev<0 then begin //writeln('EOSZ');
      continue;end;
  end;
 finally
    //writeln('<li>DONE');
    stakki.free;
 end;

end;

function _listxml(ele:ttag):string;     //old, not used. remove if  x_list has no problems
var i,j,curlev:integer;atag:ttag;alev,levs,prevlev:tlist;ind:string;waslast:boolean;
  curs:array[0..64000] of word;
begin
  levs:=tlist.create;
  alev:=tlist.create;
  try
  alev.Add(ele);
  levs.add(alev);
 curlev:=0;
 i:=0;
 atag:=ele;
 waslast:=false;//alev.count=0;
 result:='<!--start-->';
 while curlev>=0 do
 begin
   //writeln('<li>sofar<xmp>:'+result,'</xmp><hr/>');
   try
   result:=result+(^j+(ind)+'['+atag.vari+' id='+atag.att('id')+'|'+inttostr(alev.count)+'/'+inttostr(levs.count)+']');
   writeln(^j+(ind)+'['+atag.vari+' id='+atag.att('id')+'|'+inttostr(alev.count)+'/'+inttostr(levs.count)+']<br/>');
   except    write('DEB[-]');   end;
     //if (alev.count<1) then
    ///// NOTHING MORE ON THIS LEVEL: end the tag (unless "<simple/>") and backtrack one level
    {if waslast then
    begin

       //WRITELN('<LI>backing:',curlev,' with ',alev.count,' levs [',levs.count,']');//+atag.vari); for i:=0 to levs.count-1 do writeln('<li>',tlist(levs[i]).count,'</li>');
       if (atag.subtags.count>0) then //or (atag.vali<>'') then
       result:=result+'</'+atag.vari+'>';// else result:=result+'//'+atag.head;
       if curlev=0 then if alev.count=0 then exit;
       alev.Free;
       levs.delete(levs.Count-1);
       curlev:=curlev-1;
       alev:=levs[curlev];
       try  ///this tag removed from parent as this has been handled
       atag:=alev[0];
       alev.delete(0);
       result:=result+(^j+ind+'(('+atag.vari+'/'+atag.att('id')+'#'+inttostr(alev.count)+'))');
       except  WRITELN('<LI>troubleat:',curlev,' with ',alev.count,', levs [',levs.count,']');   end;
       //comeback:=true;
       continue;
    end;}
    try

    if alev.count=0 then break;
    atag:=ttag(alev[0]);
    alev.Delete(0);
    //waslast:=alev.count=0;
    ind:=copy('                                                            ',1,curlev*2);
    result:=result+^j+ind+'>>'+atag.vari+'/'+atag.att('id');// else result:=result+'//'+atag.head;
    //WRITELN('<LI>doing:',curlev,' with ',alev.count,' to go [',atag.head+']');
    result:=result+lf+_onelinexml(atag,ind);
    //if curlev>0 then if tlist(levs[curlev+1]).count>0 then write('*');

    //if  curlev>0 then if levs.count>0 then    begin prevlev:=levs[curlev-1];result:=result+'****'+inttostr(prevlev.count);if prevlev.count>0 then prevlev.delete(0);end;
    // writeln('<li>got:<xmp>'+_onelinexml(atag,copy('                                                    ',1,curlev))+'</xmp>');
    except writeln('oinelaine!!!'); end;
    if atag.subtags.count>0 then
    //////////HAS SUBTAGS - add them and continue
    begin
      try
      waslast:=false;
      alev:=tlist.create;
      alev.AddList(atag.subtags);
      levs.add(alev);
      curlev:=curlev+1;

      //WRITELN('<LI>adding:',curlev,' with ',alev.count,' unhandled [',atag.head+']');
      continue;
    except writeln('subtas!!!'); end;
    end else
    ///////// NO SUBTAGS: continue with next tag
    begin
      //if atag.vali<>'' then
      //alev.Delete(0);
      //levs[curlev-1].delete(0);
    try
    while alev.count=0 do
    //if alev.count=0 then
      begin
        write('@',levs.count,curlev);
        //alev.Free;
        levs.delete(levs.Count-1);
        curlev:=curlev-1;
         if curlev<1 then break;
        alev:=levs[curlev];
        result:=result+' --';
      end;
      if alev.count>0 then atag:=alev[0];
      writeln('<li>',curlev,'*',LEVS.COUNT, '/',alev.count,'</li>');

    except writeln('failedloopingback');end;
    end;
 end;
 finally  //these have been freed already?
  //for curlev:=levs.count-1 downto 0 do tlist(levs[curlev]).free;
  levs.free;
  //writeln('<li>finished<xmp>:'+result,'</xmp>');

 end;
end;
{if comeback then result:=result+'************';
if comeback then if alev.count<1 then
begin
   alev.delete(0);
   result:=result+(^j+ind+'<<<<<'+atag.vari+'/'+atag.att('id')+'#'+inttostr(alev.count)+'))');
   //curlev:=curlev-1;
   if curlev=0 then break;
   //alev:=levs[curlev];
   comeback:=false;
   continue;

 end;}
//WRITELN('<LI>doing:',ATAG.VARI,ATAG.SUBTAGS.COUNT,'@',curlev,' with ',alev.count,' levs [',levs.count,']');//+atag.vari); for i:=0 to levs.count-1 do writeln('<li>',tlist(levs[i]).count,'</li>');

function __oneline(tagi:ttag;inde: string): string;
var
  i, vals: integer;
  aline,atts, st, values, tvali,ost: string;
 begin
 st:='';
 atts:='';
 aline:='';
 // if (trim(vari)='') and (trim(vali)='') then exit;
  aline:=inde+tagi.vari;
  try
  if tagi.attributes<>nil then
  for i := 0 to tagi.attributes.Count - 1 do
  begin
    st := tagi.attributes.strings[i];
    ost:=st;
    if length(st)>0 then
    begin
    st := StringReplace(st, '"', '&quot;', [rfreplaceall]);
    st := StringReplace(st, crlf, '&#xA;', [rfreplaceall]);
    st := StringReplace(st, ^M, '&#xA;', [rfreplaceall]);
    st := StringReplace(st, ^J, '&#xA;', [rfreplaceall]);
    //ost:=st;
    try
    st := cut_ls(st) + '="' + cut_rs(st) + '"';
     except st:=ost;writeln('<li>failed xmlis corrupt attribute!!'+ost+'??',length(ost));end;
    end;
    try
      aline:=aline+' '+st;
    except writeln('<li>failed add attribute!!',st,'!!!',ost,'///');end;
  end;
  except writeln('failed xmlis corrupt attributes');  end;
  if tagi.vali<>'' then //else
  begin
    //if (xquoted) or (att('xse:format')='quoted') then res.add(aline + ': ''''''' + vali  + '''''''') else
    //if inlinexml then res.add(aline+': '+vali) else
    //if vari<>'' then
    aline:=(aline+': '+_xwrap(tagi.vali,inde+'  ',80)) //+' ('+vali+')');
    ;//else res.add(aline+': '+_xwrap(vali,ind+'',80)) //+' ('+vali+')');
  end;
  result:=aline;

 end;

function _listxmlis(ele:ttag):string;
var i,curlev:integer;atag:ttag;alev,levs:tlist;
begin
  //writeln('<h1>xmlis</h1>');

  result:='';
  levs:=tlist.create;
  alev:=tlist.create;
  try
  alev.Add(ele);
  levs.add(alev);
 curlev:=0;
 while curlev>=0 do
 begin
    if alev.count<1 then break;
    atag:=ttag(alev[0]);
    //WRITELN('<LI>doing:',curlev,' with ',alev.count,' unhandled [',atag.head+']');
    alev.delete(0);
    result:=result+lf+__oneline(atag,copy('                                                    ',1,curlev));
    if atag.subtags.count>0 then
    begin
      alev:=tlist.create;
      alev.AddList(atag.subtags);
      levs.add(alev);
      curlev:=curlev+1;
      //WRITELN('<LI>adding:',curlev,' with ',alev.count,' unhandled [',atag.head+']');
      continue;
    end;
    //writeln('<li>more? at:',curlev,' with ',alev.count);
    while (curlev>0) and (alev.count=0) do  //skip all levels that have no more branches to travel
    begin
     alev.Free;
     levs.delete(levs.Count-1);
     curlev:=curlev-1;
     alev:=levs[curlev];
    end;
 end;
 finally
  for curlev:=levs.count-1 downto 0 do tlist(levs[curlev]).free;
  levs.free;
 end;
end;


function ttag.xmlis: string;
var
  sl: TStringList;
begin

  //sl := TStringList.Create;
  try
  try
    //logwrite('xmlxmlmxlmxlmxlmlxm');
    result:=_listxmlis(self);
   // listxmlish('', SL,false);
   // Result := sl.Text;

  except

  logwrite('<li>FAILED ttag.XMLIS'+vari+'</li>');
  writeln('<li>FAILED ttag.XMLIS',vari,'</li>');
  end;
  finally
    //sl.Free;
  end;
end;
function ttag.listxml(inde:string; ents,isroot: boolean): string;
{D: one of despare efforts to handle whitespace correctly
}
begin
  // result:=listst;
  //result:=_listxml(self);
  result:=x_list(self);
  //logwrite('listed:'+result+'//////////////listed');
end;

{
function ttag.listxmlish2(inde:string;VAR RES:tstringlist):BOOLEAN;
function _indline(st,ind:string):string;
begin
 result:=''+stringreplace(trim(adjustlinebreaks(st)),crlf,crlf+ind+':',[rfreplaceall]);
 result:=''+stringreplace(result,'#','\#',[rfreplaceall]);
end;

var i,vals:integer;sl:tstringlist;line,st,values:string;isnew:boolean;asub:ttag;
begin
  if self=nil then exit;
   isnew:=false;

  if res=nil then
  begin
   isnew:=true;
   res:=tstringlist.create;
  end;
  //note - memory leak
  if vari='value' then
  begin
    //line:='';
    if trim(vali)<>'' then
    if xquoted then
    begin
    res.add(inde+': """'+crlf+vali+crlf+inde+'"""');
    end
    else
    res.add(inde+': '+_indline(vali,inde));
  end
  else
    if attributes.count>0 then
    begin
     line:=inde+vari+'(';
      for i:=0 to attributes.count-1 do
      BEGIN
        st:=attributes.strings[i];
        if (pos(';',st)>0) or (pos(')',st)>0)  then
         line:=line+cut_ls(st)+'="'+cut_rs(st)+'";'
        else line:=line+st+';'
      end;
      if trim(vali)<>'' then
      if xquoted then
      res.add(line+')"""'+crlf+vali+crlf+inde+'"""') else
      res.add(line+'): ' //+crlf+inde+':'
      +_indline(vali,'  '+inde))
      else
      res.add(line+')');
    end
    else //no attributes
    begin
    if xquoted then
    begin
    res.add(inde+vari+'"""'+crlf+vali+crlf+inde+'"""');
            //  writeln('listquoted'+vali);

    end else
      res.add(inde+vari+': '+_indline(vali,'  '+inde));
    end;
    values:='';
    if subtags<>nil then for i:=0 to subtags.count-1 do
    begin
      asub:=ttag(subtags[i]);
      asub.listxmlish(inde+'   ',res);
    end;
end;
}


function ttag.listxmlish(inde: string; var RES: TStringList;inlinexml:boolean): boolean;

{function _indoneline(st, ind: string): string;
begin
  Result := stringreplace((adjustlinebreaks(st)), crlf, ind + '', [rfreplaceall]);
end;}
function _addtores(atts,ind: string): string;
var aline,mywrap:ansistring;
begin
   try

 //if vari='' then line:=line+'X';
 //line:= line+' sub='+inttostr(subtags.count);
 //if vari='' then mywrap:=ind else mywrap:=ind+'  ';
 //if (trim(vari)='') and (trim(atts)='') and (trim(vali)='') then exit;
 //if vari='' then line:=ind+'__' else
 //if atts=nil then writeln('<li>attributes not initialized');
 try
 if (trim(vari)='') and (trim(vali)='') then exit;
 aline:=ind+vari;
 except writeln('<li>failed to add ind/line');end;
 try
 try
     //if trim(atts)<>'' then
     //  aline:=aline+' '+trim(atts);
   //atts:='juu="jaa"';
  // aline:=concat(aline,' '+atts);
   aline:=concat(aline,atts);
   //aline:=aline+' juu="jaa"';
 except writeln('<li>failed to list atts');writeln(aline);aline:=ind+vari;writeln('??????????'); end;
 except writeln('<li>failed to fail to list atts'); end;
// except on e:exception do begin writeln('<li>!!!failed to add ats:'+e.message);logwrite(aline+'################'+atts);
//  writeln('<li>'+'<b>'+aline+'</b></li>');end;end; //line+'!'+vari+''+vali);end;
 try
  if (vali='') then
  begin
    if (vari<>'') then
     res.add(aline);

  end
 except writeln('<li>failed to add shortline:');// +line+'!'+vari+''+vali);
 end;
 try
 if vali<>'' then //else
 begin
   //if length(vali)+length(line)<3 then res.add(line+': '+vali) else
  try
   if (xquoted) or (att('xse:format')='quoted') then res.add(aline + ': ''''''' + vali  + '''''''') else
   //if length(vali+line)<70 then  res.add(line+': '+vali)
   //else
   if inlinexml then res.add(aline+': '+vali) else
   if vari<>'' then res.add(aline+': '+_xwrap(vali,ind+'  ',80)) //+' ('+vali+')');
   else res.add(aline+': '+_xwrap(vali,ind+'',80)) //+' ('+vali+')');

   except writeln('<li>failed to add line:');// +line+'!'+vari+''+vali);
   end;
   //if pos('taaseka',vali)>0 then
   //if pos(vali,crlf)=1 then res.add(line+': ['+_xwrap(vali,ind+'',65)+']')
   //else res.add(line+': {'+_xwrap(vali,ind+'  ',65)+'}')
   //if vari='' then res.add(line+': ['+_xwrap(vali,ind+'',65)+']')
   //else res.add(line+': {'+_xwrap(vali,ind+'  ',65)+'}')
   //else
   //res.add(line+': '+_xwrap(vali,ind+'  ',65))
 end;
    except writeln('<li>failed to add linewith vali:');end;

 //logwrite('listed:'+var7i+'/line;'+line);
 //writeln('<li>addto:'+vari+'<xmp>%'+listxml(' ',false)+'%</xmp>topar:<pre>'+_clean(parent.listxml(' ',false))+'!!</pre>###',parent.vari,length(inde),'</li>');
   except writeln('failed addon elin e');end;

end;

var
  i, vals: integer;
  //sls: TStringList;
  atts, st, values, tvali,ost: string;
  isnew: boolean;
  asubi: ttag;
 // function _owrap(st,x:integer;inde:string);
 begin
   inlinexml:=false;
 st:='';
 atts:='';
  if res = nil then
  begin
    isnew := True;
    res := TStringList.Create;
  end;
  try
  if attributes<>nil then
  for i := 0 to attributes.Count - 1 do
  begin
    st := attributes.strings[i];
    ost:=st;
    if length(st)>0 then
    begin
    //st := StringReplace(st, ^M, '\r', [rfreplaceall]);
    //st := StringReplace(st, ^J, '\n', [rfreplaceall]);
    st := StringReplace(st, '"', '&quot;', [rfreplaceall]);
    st := StringReplace(st, crlf, '&#xA;', [rfreplaceall]);
    st := StringReplace(st, ^M, '&#xA;', [rfreplaceall]);
    st := StringReplace(st, ^J, '&#xA;', [rfreplaceall]);
    ost:=st;
    //if cut_ls(st)='value' then writeln('!!class:<xmp>'+st+'</xmp><hr/>');
    try
    st := cut_ls(st) + '="' + cut_rs(st) + '"';
     except st:=ost;writeln('<li>failed xmlis corrupt attribute!!'+ost+'??',length(ost));end;
    end;
    try
      atts:=concat(atts,' ',st);
      //atts:=concat(atts,st);
    except writeln('<li>failed add attribute!!',st,'!!!',ost,'///');end;
    //atts:=st;
  end;


  except writeln('failed xmlis corrupt attributes');
     writeln(vari+''+vali+'!'+attributes.text+'!!',attributes.count);
    for i:=0 to attributes.count-1 do
     try
    writeln('<li>::',i,attributes.strings[i]);

     except writeln('unininted element');end;
  end;
  try
  _addtores(atts,inde);
   //writeln('<li>to:'+vari+'/',vali,length(inde),'</li>');

  except writeln('<li>failed addtores one line'+head+'</li>');end;
  try
  if subtags <> nil then
    for i := 0 to subtags.Count - 1 do
    begin
      asubi := ttag(subtags[i]);
      if inlinexml and (asubi.vari='') then //or (pos(','+uppercase(asub.vari)+',',inlineelems)>0) then
      begin
         res[res.count-1]:=res[res.count-1]+(stringreplace(asubi.listxml(inde+'',true,false),crlf,' ',[rfReplaceAll]));
      end else
      asubi.listxmlish(inde + '  ', res,inlinexml);
    end;
   except
     writeln('<li>FAILED list XMLIS','</li>');
     //raise;
  end;

 end;

procedure TTAG.minitidy(tagst, CONT: string);
var
  xm: ttag;
  xs: string;
begin
  try
    try
      //xm := ttag.Create;
      xm := tagparse('<' + tagst + '>' + cont + '</' + tagst + '>', False, False);
      ;
    except
      writeln('parse/add failed<xmp>' + xs + '</xmp>');
    end;
    SUBTAGS.ADD(xm.subtags[0]);
  except
    writeln('xminitidy failed');
  end;
end;


procedure ttag.listwparent(pre: string; res: TStringList);
{D: early rebugging-command
}
var
  i: integer;
  rest: string;
  noname: boolean;
const
  indents = '  ';

begin
  try
    rest := '';
    if (vari = '') //VALUE or  (vari='value')
    then
      noname := True
    else
      noname := False;
    if noname then
      rest := vali
    else
      rest := '<' + vari + '';
    if not noname then
      for i := 0 to attributes.Count - 1 do
      begin
        rest := rest + ' ' + cut_ls(attributes[i]) + '="' + cut_rs(attributes[i]) + '"';
      end;
    if parent <> nil then
      rest := rest + ' ' + 'parent="' + parent.vari + '"';
    if subtags = nil then
    begin
      res.add(pre + rest + ' LOPPU />');
      exit;
    end;
    if (subtags.Count = 0) and (not noname) then
    begin
      if vali = '' then
        res.add(pre + rest + '></' + vari + '>')
      else
        res.add(pre + rest + '>' + (vali) + '</' + vari + '>');
    end
    else
    begin
      if not noname then
        rest := rest + '>' + vali;
      res.add(pre + rest);
      rest := '';
      for i := 0 to subtags.Count - 1 do
      begin
        begin
          rest := '';
          try
            ttag(subtags[i]).listwparent(pre + indents, res);
          except
            writeln('listing subtag failed');
          end;
        end;
      end;
      if not noname then
        res.add(pre + '</' + vari + '>' + pre);
    end;
  except
    writeln('<!--subtag ' + 'vari' + 'not found-->');
  end;

end;

procedure ttag.listdebug;
var
  i: integer;
begin
  writeln('<li>' + vari + ':<xmp style="display:inline">' + vali + '</xmp><ul>');
  try
  for i := 0 to subtags.Count - 1 do
    ttag(subtags[i]).listdebug;

  finally
  writeln('</ul></li>');
  end;

end;

procedure ttag.list(pre: string; res: TStringList);
var
  i, j, substart: integer;
  rest, newpre, apu: string;
  noname: boolean;
  res2: TStringList;
begin
  try
    try
      rest := '';
      newpre := pre;
      if vari = 'cdata' then
      begin
        res.add('<![CDATA[' + vali + ']]>');
        exit;
      end;
      if (vari = '')  //VALUE or (vari='value')
      then
        noname := True
      else
        noname := False;
      if noname then
        rest := vali
      else
      if pos(',' + vari + ',',
        ',span,strong,code,br,BR,img,em,b,i,a,strike,font,li,tr,td,dd,dt,th,dl,q,del,ins,')
        > 0 then
        rest := pre + '<' + vari + ''
      else
        rest := '<' + vari + '';
      if not noname then
        for i := 0 to attributes.Count - 1 do
        begin
          if cut_ls(attributes[i]) = 'xse:compact' then
            newpre := ''
          else
            rest := rest + ' ' + cut_ls(attributes[i]) + '="' +
              cut_rs(attributes[i]) + '"';
        end;
    except
      writeln('<!--Ssubtag ' + vari + ' not found-->');
    end;
    if subtags = nil then
    begin
      res.add(pre + rest + ' LOPPU />');
      exit;
    end;
    if (subtags.Count = 0) and (not noname) then
    begin
      if vali = '' then
        //if (vari = 'img') or (vari = 'br') or (vari = 'input') then
        if pos(','+vari+',', gc_voids)>0 then
          res.add(pre + rest + ' />')
        else
          res.add(rest + '>' + '</' + vari + '>')
      else
        res.add(rest + '>' + (vali) + '</' + vari + '>');
    end
    else
    begin
      if not noname then
        rest := rest + '>' + (vali);
      substart := 0;
      //VALUE if (subtags.count>0) and (ttag(subtags[0]).vari='value')
      if (subtags.Count > 0) and (ttag(subtags[0]).vari = '') and
        (ttag(subtags[0]).subtags.Count = 0) then
      begin
        rest := rest + (ttag(subtags[0]).vali);
        substart := 1;
      end;
      res.add(rest);
      rest := '';
      if newpre <> '' then
        newpre := pre + '  ';
      for i := substart to subtags.Count - 1 do
      begin
        if subtags[i] = nil then
          continue;
        begin
          rest := '';
          try
            if newpre = '' then
            begin
              res2 := TStringList.Create;
              ttag(subtags[i]).list(newpre, res2);
              apu := '';
              for j := 0 to res2.Count - 1 do
                apu := apu + (res2[j]);
              res.add(apu);
              res2.Clear;
              res2.Free;
            end
            else
              ttag(subtags[i]).list(newpre, res);
          except
            writeln('subtalist failed' + vari + '/' + vali);
            raise;
          end;
        end;
      end;
      if not noname then
        res.add(pre + '</' + vari + '>');
    end;
  except
    writeln('<!--subtag ' + vari + ' not found-->');
  end;

end;


function ttag.ashtml: string;
var
  i: integer;
begin
  Result := '';
  // if (vari='value') and (trim(vali)='') then exit;

  //result:='listraw'+vari;
  Result := '<li>' + vari + ':';
  for i := 0 to attributes.Count - 1 do
    Result := Result + ' @' + attributes[i];
  Result := Result + crlf + vali + '<ul>';
  if subtags <> nil then
    for i := 0 to subtags.Count - 1 do
      Result := Result + ttag(subtags[i]).ashtml;
  Result := Result + '</ul></li>' + crlf;
end;


function ttag.listraw: string;
{D: listing for debugging
}
var
  i: integer;
begin
  Result := '';
  // if (vari='value') and (trim(vali)='') then exit;

  //result:='listraw'+vari;
  Result := '<' + vari + ' _' + attributes.Text + '>' + vali;
  if subtags <> nil then
    for i := 0 to subtags.Count - 1 do
      Result := Result + ttag(subtags[i]).listraw;
  Result := Result + '</' + vari + '>';//+crlf;
end;

{function ttag.listasis: string;
var
  i: integer;
  rest: string;
  noname: boolean;
begin
  try
    Result := '';
    rest := '';
    if vari = 'cdata' then
    begin
      Result := Result + ('<![CDATA[' + vali + ']]>');
      exit;
    end;
    if (vari = '') or (vari = 'nonono_value') then
      noname := True
    else
      noname := False;
    if vari = 'xse:value' then
      vari := '';//VALUE 'value';
    if noname then
      rest := vali
    else
      rest := '<' + vari + '';
    if not noname then
      for i := 0 to attributes.Count - 1 do
      begin
        rest := rest + ' ' + cut_ls(attributes[i]) + '="' + cut_rs(attributes[i]) + '"';
      end;
    if subtags = nil then
    begin
      exit;
    end;
    if (subtags.Count = 0) and (not noname) and (pos(vari,c_voids)>0) then
    begin
      //if vali = '' then
        Result := Result + (rest + ' />')
      //else
      //  Result := Result + (rest + '>' + (vali) + '</' + vari + '>');

    end
    else
    begin
      if not noname then
        rest := rest + '>' + vali;
      Result := Result + (rest);
      rest := '';
      for i := 0 to subtags.Count - 1 do
      begin
        begin
          rest := '';
          try
            Result := Result + ttag(subtags[i]).listasis;
          except
            writeln('subelement list failed');
          end;
        end;
      end;

      if not noname then
        Result := Result + ('</' + vari + '>');
    end;
  except
    writeln('<!--subtag ' + 'vari' + 'not found-->');
  end;

end;
}
function ttag.listjson(inde: string): string;
var
  i: integer;
  rest: string;
  noname: boolean;
begin
  try
    Result := '';
    rest := '';
    if vari = 'xse:value' then
      vari := '';
    if (vari = '') or (vari = 'nonono_value') then
      noname := True
    else
      noname := False;
    if noname then
    begin
      if subtags.Count > 0 then
      begin
        for i := 0 to subtags.Count - 1 do
          Result := Result + 'X' + ttag(subtags[i]).listjson(inde + '  ');
      end;
      exit;
    end;
    if (subtags.Count = 0) and (attributes.Count = 0) then
    begin
      Result := inde + '"' + vari + '" : ' + vali + '";';
      exit;
    end;
    Result := Result + '"' + vari + '" : {';
    for i := 0 to attributes.Count - 1 do
    begin
      Result := Result + crlf + inde + '  "' + cut_ls(attributes[i]) +
        '" : "' + cut_rs(attributes[i]) + '",';
    end;
    if subtags = nil then  //should never be
    begin
      exit;
    end;
    for i := 0 to subtags.Count - 1 do
    begin
      Result := Result + '' + crlf + ttag(subtags[i]).listjson(inde + '  ');
    end;
    Result := Result + crlf + inde + '}';
  except
    writeln('!--subtag ' + 'vari' + 'not found-->');
  end;

end;

procedure ttag.listwrite;
begin
  if self = nil then
    exit;
  writeln('TAG:' + vari + '<xmp>');
  listhtml(False);
  writeln('</xmp><hr>');
end;

procedure ttag.listhtml(nocr: boolean);
var
  sl: TStringList;
  i: integer;
  cr: string;
begin
  try
    if nocr then
      cr := ''
    else
      cr := crlf;
    try
      if self = nil then
        exit;
      sl := TStringList.Create;
      if nocr then
        list('', sl)
      else
        list('  ', sl);
    except
      writeln('Html listing failed');
      raise;
    end;
    for i := 0 to sl.Count - 1 do
      Write(sl[i] + cr);
  finally
    sl.Free;
  end;
end;



function ttag.listst: string;
var
  i: integer;stl:tstringlist;
begin
  stl:=tstringlist.create;
  try
  stl.add(listxml('  ', False,false));
  Result := stl.text;
  finally stl.free;end;
  {if self = nil then
  exit;
  result:=listxml('',false);
  exit;
  Result := Result + vali;
  for i := 0 to subtags.Count - 1 do
    Result := Result + ttag(subtags[i]).listasis;}
end;
function ttag.lastsubtag: ttag;
begin
  result:=subtags[subtags.count-1];
end;

function ttag.getsubvals: string;
var
  i: integer;
begin
  begin
    Result := _normalizewhitespace(vali, False)+' ';
    //result:=vali;
    for i := 0 to subtags.Count - 1 do
      Result := Result  + ttag(subtags[i]).getsubvals;
  end;
end;

function ttag.getsubvalsasis: string;
var
  i: integer;
begin
  begin
    //result:=normalizewhitespace(vali,false);
    Result := vali;
    for i := 0 to subtags.Count - 1 do
      Result := Result + ' ' + ttag(subtags[i]).getsubvalsasis;
  end;
end;


{function ttag.withattr(at, va: string): ttag;
var
  i: integer;
begin
  if attributes.values[at] = va then
  begin
    Result := self;
    exit;
  end
  else
    Result := nil;
  for i := 0 to subtags.Count - 1 do
  begin
    Result := ttag(subtags[i]).withattr(at, va);
    if Result <> nil then
      break;
  end;
end;
 }
procedure txpath.Clear;
begin
  if Next <> nil then
  begin
    Next.Clear;
    Next.Free;
  end;
  if con <> nil then
  begin
    con.Clear;
    con.Free;
  end;

end;

procedure txcond.Clear;
begin
 { if Next <> nil then
  begin
    Next.Clear;
    Next.Free;
  end;}
end;

function txpath.list:string;
begin
   result:='';
  if con = nil then
    result:=('<li>path:' + ele + '/sub:<ul>')
  else
  begin
    result:=result+('<li>' + ele + '  [' + con.cond+ ']/sub_<ul>');
  end;
  if Next <> nil then
    Next.list;
     result:=result+('</ul>');

end;

function txpath.parse(path: string): ttag;
var
  i: integer;
  rest: string;
  inele: boolean;
begin
  try
    con := nil;
    reverse:=false;
    ele:='';
    idi:='';
    i := 0;
    inele := True;
    if length(path) = 0 then
      exit;
    if pos('//', path) = 1 then
    begin
      dochils := True;
      i := 2;
    end
    else
    if pos('/', path) = 1 then //WHY?
      i := 1;
    while i < length(PATH) do
    begin
      i := i + 1;
      if inele then
      begin
        if path[i] = '/' then
        begin
          break;
        end
        else
        if path[i] = '[' then
        begin
          con := txcond.Create;
          //i:=i+1;
          //if pos('ext',path)>0 then writeln('<li>tryparseCondi:'+path+'!',con.cond);
          con.parsest(path, i);
          //if pos('ext',path)>0 then writeln('<li>Condi:'+path+'!',con.cond);
          {if pos('-',con.y)=1 then
          begin
             reverse:=true;
             delete(con.y,1,1);
           end;}
          inele := False;
          //writeln('<li>parsecond:', copy(path,1,i),'***' ,copy(path,i,900));
          break;
        end
        else
          ele := ele + path[i];
      end;
    end;

    if pos('reverse::', ele) = 1 then
    begin
      Delete(ele, 1, 9);
      axis := 'reverse';
      //writeln('reverses'+ele);
    end;
    if pos('descendant::', ele) = 1 then
    begin
      Delete(ele, 1, 12);
      axis := 'descendant';
    end else
    if pos('descendantrev::', ele) = 1 then
    begin
      Delete(ele, 1, 15);
      axis := 'descendantrev';
    end else
    if pos('preceding-sibling::', ele) = 1 then
    begin
      Delete(ele, 1, 19);
      axis := 'preceding-sibling';
    end else
    if pos('prev::', ele) = 1 then
    begin
      Delete(ele, 1, 6);
      axis := 'preceding-sibling';
    end else
    if pos('preceding::', ele) = 1 then
    begin
      Delete(ele, 1, 11);
      axis := 'preceding';
      //writeln('axis:'+axis);
    end else
    if pos('sibling::', ele) = 1 then
    begin
      Delete(ele, 1, 10);
      axis := 'sibling';
      //writeln('axis:'+axis);
    end else
    if pos('ancestor-and-self::', ele) = 1 then
    begin
      Delete(ele, 1, 19);
      axis := 'ancestor-and-self';
    end
    else
    if pos('ancestor::', ele) = 1 then
    begin
      Delete(ele, 1, 10);
      axis := 'ancestor';
    end;
    if pos('..', ele) = 1 then  //dirty
    begin
      //writeln('<li>aaxis:::_'+ele+'_');
      ele:='*';//'*'+copy(ele, 2, length(ele));
      axis := 'parent';
    end;
    if pos('self-and-followers::', ele) = 1 then
    begin
      Delete(ele, 1, 20);
      axis := 'self-and-followers';//-and-self';
    end
    else
    if pos('following-sibling::', ele) = 1 then
    begin
      Delete(ele, 1, 19);
      axis := 'following-sibling';
    end;
    if pos('following::', ele) = 1 then
    begin
      Delete(ele, 1, 11);
      axis := 'following';
      //writeln('gotaxis'+axis+';;'+ele+'!');
    end;
    if pos('next::', ele) = 1 then
    begin
      Delete(ele, 1, 6);
      axis := 'following-sibling';
    end else
    if pos('attributes::', ele) = 1 then
    begin
      Delete(ele, 1, 12);
      axis := 'attributes';
    end;
    if pos('#', ele) = 1 then
    begin
      Delete(ele, 1, 1);
      idi := ele;
    end;


    rest := copy(path, i + 1, length(path));

    if rest <> '' then
    begin
      Next := txpath.Create;
      Next.parse('/' + rest);
    end;
  except
    writeln('Content-type: text/html' + crlf + crlf + 'path parese failded');
  end;
  //writeln('listpathx<hr/>');
  if t_debug then list;
end;


function _matches(x, y: string): boolean;
var
  neg: boolean;
begin
  try
    neg := False;
    if pos('-', x) = 1 then
    begin
      neg := True;
      x := copy(x, 2, length(x));
    end;
    Result := False;
    if pos('|' + x + '|', '|' + y + '|') > 0 then
      Result := True
    else
    if pos('|' + Y + '|', '|' + X + '|') > 0 then
      Result := True
    else
    if (pos('*', y) > 1) and (copy(y, 1, length(y) - 1) = copy(x, 1, length(y) - 1)) then
      Result := True
    else
    if (pos('*', x) > 1) and (copy(x, 1, length(x) - 1) = copy(y, 1, length(x) - 1)) then
      Result := True
    else
    if (y = '*') and (x <> '') then
      Result := True
    else
    if (x = '*') and (y <> '') then
      Result := True
    else
    if (x = '') and (y = '') then
      Result := True;
    if neg then
    begin
      Result := not Result;
    end;
  except
    writeln('failed matching');
  end;
  //if (pos('*',x+y)>0 then writeln(
end;
function _p_condition(condst:string; ele:ttag):string;
var i,len:integer;ch:char;st1,st2,con:string;
//function onetest:boolean;
function onetest:boolean;
 var int1,int2:integer;compa,neg:boolean;
  begin
    st1:=parsexpart(condst,i,t_currentxseus,false,false);
    if (i>len) or (pos(condst[i],'<>=')<0) then
    begin
      result:=st1='1';
     exit;
    end;
      //then begin writeln('<li>cond[',i,']=',condst[i],'/in:',condst);result:=st1='1';exit;end; //was a truth function
    con:=condst[i];i:=i+1;  //take later care of >=, =>, <>, !=,
    if (i<len) and (pos(condst[i],'<>=')>0) then begin con:=con+condst[i];end;
    if i>len then st2:='' else
    st2:=parsexpart(condst,i,t_currentxseus,false,false);
    try
    int1:=strtoint(st1);
    int2:=strtoint(st2);
    if con='=' then result:=int1=int2 else
    if con='>' then result:=int1>int2 else
    if con='<' then result:=int1<int2 else
    if con='<>' then result:=int1<>int2 else
    if con='>=' then result:=int1>=int2 else
    if con='<=' then result:=int1<=int2;
    except
    if con='=' then result:=st1=st2 else
    if con='>' then result:=st1>st2;
    if con='<' then result:=st1<st2 else
    if con='<>' then result:=ST1<>st2 else
    if con='<=' then result:=st1<=st2;
    end;

 // a=1&b<>2  a=a/b/c/@d<>3
end;
var res:boolean;
begin
    i:=1;
    len:=length(condst);
    //writeln('<li>part:',txseus(t_currentxseus).curfromele.xmlis);
    res:=onetest;
    //writeln('<li>TESTed:',condst,':',res,'!!',copy(condst,i,99));
    while (i<len) do
    begin
       ch:=condst[i];
       i:=i+1;
       if i>1000 then begin writeln('<li>failed, too much testing </li>');result:='0';EXIT;end;
       //if i<len then  writeln('<li>MOretest',ch, result,'</xmp>');
       if ch='&' then begin if res then res:=onetest else break; end
       else if ch='|' then
         if res then break else res:=onetest;


    end;
    if res then result:='1' else result:='0';
    //writeln('<li>tested:',st1,'/cmp:',con,'/2:',st2,'/res:',result,'/i:',i,'/in'+condst);

end;


function _cond(pathcon: txcond; tag, root: ttag; posi:integer;axisz: TList): boolean;
var
  at,xsub,res: string;
  i, j,apui,possi: integer;
  apus: TList;
  otag: ttag;
  oldselectionset:tlist;
begin
  try
      if pathcon = nil then
      begin
        Result := True;
        exit;
      end;
      try
        Result := true;
     //if t_debug then
     //writeln('<li>TRYCOND1');
     //writeln('<li>TRYCOND prev:',pathcon.tries,' hits:',pathcon.hits,'x:',pathcon.cond,'|',tag.vari,'</li>');
      //if prevhits <= pathcon.hits then
      //  pathcon.hits := prevhits - 1;
      pathcon.tries:=pathcon.tries+1;
      Result := true;
      if t_currentxseus<>nil then otag := txseus(t_currentxseus).CURFROMELE;
      xsub:=pathcon.cond;
      except writeln('failed to get condition_');pathcon.list;
      end;

      if  xsub <> '' then
      begin
         possi:=strtointdef(xsub,-99999);
         if possi<>-99999 then //pos(xsub[1], '0123456789') > 0 then
        begin
         // writeln('<li>Testing numeric cond:',xsub,':',possi,'!',posi,'/',axisz.count);
          if possi<0 then
            possi:=axisz.count+possi+1;
          //for i:=0 to axisz.count-1 do
          //   if i=possi then writeln('<li><b>pos_',i,ttag(axisz[i]).head,'</b>')
          //   else writeln('<li>nopos:',i,'/',axisz.count,' ',possi,' ',ttag(axisz[i]).head);
          if possi=posi then res:='1' else res:='0';  //posi+1?
        end
        else
        begin
         try
          //if pos('ext',xsub[1])>0 then
          //writeln('<li>Condi:'+xsub+'!');
          apui := 1;
          if t_currentxseus<>nil then
          begin
          txseus(t_currentxseus).Curselectionset:=axisz;
          txseus(t_currentxseus).CURFROMELE := tag;
          //if pos('a',tag.vari)=1 then         for j:=0 to axisz.Count-1 do writeln('<li>test: ',ttag(axisz[j]).head);
          end;
          try
            if txseus(t_currentxseus).curfromele=nil then
             writeln('<li>fail:nil to choose from');
            // res := _p_infix(xsub , apui, nil,'')
            //else
            if xsub[1]='#' then
            {INFIX res := _p_infix(copy(xsub,2,9999) , apui, t_currentxseus,'') else
            res := _p_infix(xsub , apui, t_currentxseus,'');}
            begin //no sense in this
                        res := _p_condition(copy(xsub,2,9999),tag );
                        writeln('<li>cond:',xsub,'=',res);
            end

                        else
            res := _p_condition(xsub , tag);
            //if xsub='$i' then writeln('<li>triedtoget:'+tag.xmlis+'!'+res+'!');
            //res := _p_infix(xsub , apui, txseus(t_currentxseus),'')
           //res:='1';
          except writeln('failed !infix:',apui,'/',xsub);end;
         finally
          if t_currentxseus<>nil then
           begin
             txseus(t_currentxseus).CURFROMELE := otag;
             txseus(t_currentxseus).Curselectionset:=oldselectionset;

           end;
          end;
        end;

      end;
  except
    writeln('failed to test)');
  end;
  //if t_debug then
  result:=res='1';
  if xsub[1]='#' then
   begin
     result:=res=inttostr(posi); //?
    // writeln('<h5>numeric condition:',POSI,'='+xsub,'!',RES,result,'</h5>')

            end;
  if t_debug then
  writeln('<li>condition:' + xsub, '/res:',res,'/pos:',posi+1,'=',result,'</li>');
  //if pathcon.negat then      Result := not (Result);
  if Result then
        pathcon.hits := pathcon.hits + 1;
  //if xsub='$i' then writeln('<li>TEST:',xsub,'!',res,result, '/</li>');
  //pathcon.list;

end;

function _newcond(pathcon: txcond; tag, root: ttag; posi:integer;maybelist: TList): boolean;
var
  at,xsub,res: string;
  i, apui,possi: integer;
  apus: TList;
  otag: ttag;
  oldselectionset:tlist;
begin
  try
      if pathcon = nil then
      begin
        Result := True;
        exit;
      end;
      try
        Result := true;
     //if t_debug then
     //writeln('<li>TRYCOND1');
     //writeln('<li>TRYCOND prev:',pathcon.tries,' hits:',pathcon.hits,'x:',pathcon.cond,'|',tag.vari,'</li>');
      //if prevhits <= pathcon.hits then
      //  pathcon.hits := prevhits - 1;
//      pathcon.tries:=pathcon.tries+1;
      Result := true;
      if t_currentxseus<>nil then otag := txseus(t_currentxseus).CURFROMELE;
      xsub:=pathcon.cond;
      except writeln('failed to get condition_');pathcon.list;
      end;

      if  xsub <> '' then
      begin
         {possi:=strtointdef(xsub,-99999);
         if possi<>-99999 then //pos(xsub[1], '0123456789') > 0 then
        begin
          writeln('<li>testing numeric cond:',xsub,':',possi,'!',posi,'/',maybelist.count);
          if possi<0 then
            possi:=maybelist.count-possi;
          if possi>=maybelist.count then exit;
          result.add(maybelist[possi];
         // for i:=0 to axisz.count-1 do
         //    if i=possi then writeln('<li><b>pos_',i,ttag(axisz[i]).head,'</b>')
         //    else writeln('<li>nopos:',i,ttag(axisz[i]).head);
         // if possi=posi then res:='1' else res:='0';  //posi+1?
        end
        else}
        begin
         for i:=0 to maybelist.count-1 do
         try
          //if pos('ext',xsub[1])>0 then
          //writeln('<li>Condi:'+xsub+'!');
          apui := 1;
          if t_currentxseus<>nil then
          begin
          txseus(t_currentxseus).Curselectionset:=maybelist;
          txseus(t_currentxseus).CURFROMELE := tag;
          end;
          try
            if txseus(t_currentxseus).curfromele=nil then
             writeln('fail:nil to choose from');
            // res := _p_infix(xsub , apui, nil,'')
            //else
            if xsub[1]='#' then
            {INFIX res := _p_infix(copy(xsub,2,9999) , apui, t_currentxseus,'') else
            res := _p_infix(xsub , apui, t_currentxseus,'');}
            begin
                        res := _p_condition(copy(xsub,2,9999),tag );
                        writeln('<li>cond:',xsub,'=',res);
            end

                        else
            res := _p_condition(xsub , tag);
            //if xsub='$i' then writeln('<li>triedtoget:'+tag.xmlis+'!'+res+'!');
            //res := _p_infix(xsub , apui, txseus(t_currentxseus),'')
           //res:='1';
          except writeln('failed !infix:',apui,'/',xsub);end;
         finally
          if t_currentxseus<>nil then
           begin
             txseus(t_currentxseus).CURFROMELE := otag;
             txseus(t_currentxseus).Curselectionset:=oldselectionset;

           end;
          end;
        end;

      end;
  except
    writeln('failed to test)');
  end;
  //if t_debug then
  result:=res='1';
  if xsub[1]='#' then
   begin
     result:=res=inttostr(posi); //?
    // writeln('<h5>numeric condition:',POSI,'='+xsub,'!',RES,result,'</h5>')

            end;
  if t_debug then
  writeln('<li>condition:' + xsub, '/res:',res,'/pos:',posi+1,'=',result,'</li>');
  //if pathcon.negat then      Result := not (Result);
  if Result then
        pathcon.hits := pathcon.hits + 1;
  //if xsub='$i' then writeln('<li>TEST:',xsub,'!',res,result, '/</li>');
  //pathcon.list;

end;



//check conditions, add subtags by "//", skip empties

procedure _doselect(hitlist, subtags: TList; var hitmees:integer;
  pathp: pointer; root: ttag; onlyone: boolean; empties: boolean);
var
  path: txpath;//debug:boolean;
  i, j, xhitmees, ivalx, ivaly,numcond: integer;
  reslist,maybehits: TList; acond:txcond;
begin
  try
  //  logwrite('doselectvvv from '+root.vari+inttostr(subtags.count));

  try
    maybehits:=tlist.create;
    path := txpath(pathp);
    numcond:=-99999;
    //if path.ele='a*' then writeln('<li>NUM;',numcond);
    if path.con<>nil then numcond:=strtointdef(path.con.cond,-99999);
    if subtags <> nil then
    if _isinteger(path.ele) then
    begin //vow.. paths like /ele/ele/1/xxx  what have i'ce been thinking?
      i:=strtoint(path.ele);
      if i<=subtags.count then
       if ((path.con = nil) or    (_cond(path.con, ttag(subtags[i]), root,hitmees, subtags))) then
        hitlist.add(subtags[i-1]);
    end else
    //logwrite('trycond:'+path.ele+'.vs.'+ttag(subtags[i]).vari);
    for i := 0 to subtags.Count - 1 do
        if (path.ele = '.') or (path.ele = '..') or (path.ele='*') or  (_matches(path.ele, ttag(subtags[i]).vari)) then
        begin
        maybehits.add(subtags[i]);
        //if numcond=2 then  writeln('<li>maybe:',i,'/',maybehits.count,ttag(subtags[i]).head,'/num:',numcond);
        end;
       //if numcond<0 then numcond:=maybehits.count+numcond;
       //if (numcond<0) or (numcond>=maybehits.count) then
    if numcond<>-99999 then
    begin  //not pretty- the [index] -conditions handled separately. Problems with xxx[xse:$test;] -type conds
      try   //negatives do not work
       if numcond<0 then numcond:=maybehits.count-numcond-1;
        if (numcond<0) or (numcond>maybehits.count) then
          writeln('<!--li >',path.con.cond,'wrong count',numcond,'/',maybehits.count,'//',subtags.count,ttag(subtags[0]).parent.head+'-->')
        else
        //writeln('<li>o:',numcond,'/',maybehits.count,'=');//+ttag(maybehits[numcond]).head);
        begin //writeln('<li>hitnum',i,'::',numcond,ttag(maybehits[numcond-1]).head);
         hitlist.add(maybehits[numcond-1]);end;
       except //writeln('fail numcond:',numcond,'/',maybehits.count);;
          //
       end;
    end else
    begin
      for i := 0 to subtags.Count - 1 do
      begin
        try
          if (not empties) and ((ttag(subtags[i]).vari = 'nonono_value') or
            (ttag(subtags[i]).vari = '')) and (trim(ttag(subtags[i]).vali) = '') and
            (ttag(subtags[i]).subtags.Count = 0) then
            continue;
        except
          writeln('failed to skip empty value');
        end;
        try        //skip empty, whitespace-caused tags
          //if (path.con<>nil) and (path.con.y='3') then
          if (path.ele = '.') or (path.ele = '..') or (path.ele='*') or
            (_matches(path.ele, ttag(subtags[i]).vari)) then
          begin
            hitmees := hitmees + 1;
            //if (numcond<>-99999) and hitlist.count=
            if ((path.con = nil)  or
            //(_cond(path.con, ttag(subtags[i]), root,hitmees, subtags))) then
            (_cond(path.con, ttag(subtags[i]), root,hitmees, maybehits))) then
            //(_cond(path.con, ttag(subtags[i]), root,i, subtags))) then
            begin
              hitlist.add(subtags[i]);
            end;
          end;
        except
          writeln('doselect matching failed');
          raise;
        end;
        try
          if path.dochils and ((hitlist.Count < 1) or (not onlyone)) then
            //   "//" in path
          begin
            try
              //writeln('<li>trysub:'+ttag(subtags[i]).vari);
              _doselect(hitlist, ttag(subtags[i]).subtags, HITMEES,
                path, root, onlyone, empties);
            except
              writeln('failed recursive doselect');
            end;
          end;
        except
          writeln('not happy with childen');
        end;
        if onlyone and (hitlist.Count > 0) then
          exit;
      end;//loop
      //if (path.ele='..') then writeln('<li>sel.:',hitlist.Count,' from ',subtags.Count, 'tried:',hitmees);
       //if path.con<>nil then writeln('<hr/>');

    end;
  except
    logwrite('doselect subtags failed');
    raise;
  end;

  finally
    maybehits.free;
    //if (path.ele='hui') then writeln('<li>///////.:',hitlist.Count,' from ',i, 'tried:',hitmees);
  end;
end;

procedure test_doselect(hitlist, subtags: TList; var hitmees:integer;
  pathp: pointer; root: ttag; onlyone: boolean; empties: boolean);
var
  path: txpath;//debug:boolean;
  i, j, xhitmees, ivalx, ivaly,numcond: integer;
  reslist,maybehits: TList; acond:txcond;
begin
  try
  //  logwrite('doselectvvv from '+root.vari+inttostr(subtags.count));

  try
    path := txpath(pathp);
    numcond:=-9999;
    if path.con<>nil then numcond:=strtointdef(path.con.cond,-9999);
    if subtags <> nil then
    if _isinteger(path.ele) then
    begin //vow.. paths like /ele/ele/1/xxx  what have i'ce been thinking?
      i:=strtoint(path.ele);
      if i<=subtags.count then
       if ((path.con = nil) or    (_cond(path.con, ttag(subtags[i]), root,hitmees, subtags))) then
        hitlist.add(subtags[i-1]);
       exit;
    end else
    begin
    maybehits:=tlist.create;
    for i := 0 to subtags.Count - 1 do
    begin
      try
        if (not empties) and ((ttag(subtags[i]).vari = 'nonono_value') or
          (ttag(subtags[i]).vari = '')) and (trim(ttag(subtags[i]).vali) = '') and
          (ttag(subtags[i]).subtags.Count = 0) then
          continue;
        except
        writeln('failed to skip empty value');
        end;
      if (path.ele = '.') or (path.ele = '..') or (path.ele='*') or  (_matches(path.ele, ttag(subtags[i]).vari)) then
      begin
       maybehits.add(subtags[i]);
        //if numcond=2 then  writeln('<li>maybe:',i,'/',maybehits.count,ttag(subtags[i]).head,'/num:',numcond);
       end;
    end;
    for i:=0 to maybehits.count-1 do
    begin
       try        //skip empty, whitespace-caused tags
            hitmees := hitmees + 1; //what is this
            //if path.ele='type' then writeln('<li>test:',path.con.cond,'?', ttag(subtags[i]).xmlis+'!</li>');
            //if path.ele='type' then writeln('<li>test:','?', ttag(subtags[i]).xmlis+'!</li>');
            if ((path.con = nil) or
            (_newcond(path.con, ttag(subtags[i]), root,hitmees, maybehits))) then
            //(_cond(path.con, ttag(subtags[i]), root,i, subtags))) then
            begin
              hitlist.add(maybehits[i]);
            end;
        except  writeln('doselect matching failed'); raise;end;
     end;
    try
     if path.dochils and ((hitlist.Count < 1) or (not onlyone)) then     //   "//" in path
     for i:=0 to subtags.count-1 do
          begin
            try
              //writeln('<li>trysub:'+ttag(subtags[i]).vari);
              _doselect(hitlist, ttag(subtags[i]).subtags, HITMEES,
                path, root, onlyone, empties);
            except
              writeln('failed recursive doselect');
            end;
          end;
        except writeln('not happy with childen'); end;
        if onlyone and (hitlist.Count > 0) then
          exit;
      end;//loop
      //if (path.ele='..') then writeln('<li>sel.:',hitlist.Count,' from ',subtags.Count, 'tried:',hitmees);
       //if path.con<>nil then writeln('<hr/>');

  except
    logwrite('doselect subtags failed');
    raise;
  end;

  finally
    //if (path.ele='hui') then writeln('<li>///////.:',hitlist.Count,' from ',i, 'tried:',hitmees);
  end;
end;


function ttag.getaxis(pathp: pointer): TList;
var
  APU,apu2: ttag;
  i, apui: integer;
  path: txpath;

  procedure _getallsubs(slist: TList; res: TList);
  var
    ii: integer;
  begin
    for ii := 0 to sList.Count - 1 do
    begin
      res.add(slist[ii]);
      _getallsubs(ttag(slist[ii]).subtags, res);
    end;
  end;

  procedure _getallsubsrev(slist: TList; res: TList);
  var
    ii: integer;
  begin
    for ii := sList.Count - 1 downto 0 do
    begin
      _getallsubsrev(ttag(slist[ii]).subtags, res);
      res.add(slist[ii]);
      writeln('--',ttag(slist[ii]).vari,'-');
    end;
  end;

begin
  path := txpath(pathp);

  Result := TList.Create;
  if path.axis = '' then
  begin
    //if path.reverse then
    //for i := subtags.Count - 1 downto 0 do
    //  Result.add(subtags[i])
    //else
    for i := 0 to subtags.Count - 1 do
      Result.add(subtags[i]);
    exit;
  end else
  //if path
  if (path.axis = 'following-sibling') then //or (path.axis = 'self-and-followers') then
  begin
    try
      apu := parent;
      if apu = nil then
      writeln('<li>Noo parent'+path.axis+' for ', vari, vali)
      ;//else
      apui := apu.subtags.indexof(self) + 1;
      if path.axis = 'self-and-followers' then
        apui := apui - 1;
      //writeln('<li>gotparent'+path.axis+' for ', vari, vali,'/parhas:',apu.subtags.count,'/this:',apui);

      for i := apui to apu.subtags.Count - 1 do
      begin
        Result.add(apu.subtags[i]);
        //writeln('--',i,':',ttag(apu.subtags[i]).xmlis());
      end;
      //writeln('getfols:',apu.subtags.Count,'//');
    except
      writeln('nogo path.followingsibling');
    end;
  end else
  if (path.axis = 'following') or (path.axis = 'self-and-followers') then
  begin
    try
      if (path.axis = 'self-and-followers') then result.add(self);
      apu:=self;
      while (apu<>nil) do
      begin
        //writeln('<li>getnext:',apu.vari+'<ul>');
        if apu<>self then
        begin
        result.add(apu);
         _getallsubs(apu.subtags, Result);
         end;
        apu2:=apu.getnext;
        while (apu2<>nil) do
        begin
         //writeln('<li>next:',apu2.vari,'</li>');
         result.add(apu2);
          _getallsubs(apu2.subtags, Result);
          apu2:=apu2.getnext;
        end;
        //writeln('</ul><li>got:',apu.vari+'</li>');
        if (apu.parent=txseus(t_currentxseus).curfromele)  then break;
        apu := apu.parent.getnext;
      end;
      except
      writeln('nogo path.followingsibling');
    end;
  end else
  if (path.axis = 'preceding') or (path.axis = 'self-and-predecessors') then
  begin
    try
      if (path.axis = 'self-and-predecessors') then result.add(self);
      apu:=self;
      while (apu<>nil) do //and (apu.parent<>txseus(t_currentxseus).curfromele)  do
      begin
        //writeln('<li>getprev:',apu.vari+'//',txseus(t_currentxseus).curfromele.head,'<ul>');
        //txseus(t_currentxseus).curfromele
        apu2:=apu.parent;
        while apu2<>nil do begin writeln('!',apu2.vari,'//');apu2:=apu2.parent;end;
        if apu<>self then
        begin
          _getallsubsrev(apu.subtags, Result);
          result.add(apu);
        end;
        apu2:=apu.getprev;
        while (apu2<>nil) do
        begin
        // writeln('<li>prev:',apu2.vari,'</li>');
         _getallsubsrev(apu2.subtags, Result);
         result.add(apu2);
          apu2:=apu2.getprev;
        end;
        //writeln('</ul><li>got:',apu.vari+'</li>');
        if (apu.parent=txseus(t_currentxseus).curfromele)  then break;
        apu := apu.parent.getprev;
      end;
      except
      writeln('nogo path.preceding');
    end;
  end else
  if path.axis='parent' then
  begin  //quick and dirty way to fix ".."  .. problems later?
    result.add(self.parent);
  end else
  if (path.axis = 'ancestor') or (path.axis = 'ancestor-and-self') then
  begin
    apu := parent;
    if (path.axis = 'ancestor-and-self') then
      Result.add(self);
    while apu <> nil do
    begin
      Result.add(apu);
      apu := apu.parent;
    end;
  end else
  if path.axis = 'preceding-sibling' then
  begin
    try
      apu := parent;
      apui := apu.subtags.indexof(self) - 1;
      //writeln('<li>ax:'+path.list+'!',apu.subtags.count,apu.vari,apui,self.vali);
      for i := apui downto 0 do
      begin
        Result.add(apu.subtags[i]);
        //writeln('<li>addsib:_'+ttag(apu.subtags[i]).vali);
      end;
    except
      writeln('nogo:path.preceding-sibling');
    end;
  end
  else if path.axis = 'sibling' then
  begin
    try
      apu := parent;
      if apu<>nil then
      begin
      apui := apu.subtags.indexof(self);
      //writeln('<li>SIBS:'+path.list+'!',self.head+'<ul>');
      for i := apu.subtags.count-1 downto 0 do
      begin
        if i<>apui then Result.add(apu.subtags[i]);
        //writeln('<li>addsib:_'+ttag(apu.subtags[i]).head,i<>apui,'</li>');
      end;
      //writeln('</ul>');

      end;
    except
      writeln('nogo path:sibling');
    end;
  end else
  if path.axis = 'descendant' then
  begin
    _getallsubs(subtags, Result);
  end else
   if path.axis = 'descendantrev' then
  begin
    _getallsubsrev(subtags, Result);
  end else
  if (path.axis = 'reverse') then // or (path.reverse=true) then
  begin
    try
      //writeln('rev:'+vari+'_',vali,'<ul>');
      for i := subtags.Count - 1 downto 0 do
      begin
         //ttag(subtags[i]).vali:=ttag(subtags[i]).vali+'_'+inttostr(i);
        //writeln('<li>rev:',ttag(subtags[i]).vari+':'+ttag(subtags[i]).vali+'</li>');
        Result.add(subtags[i]);
      end;
      //writeln('</ul>');
    except
      writeln('nogo path:reverse');
    end;
  end else
  if path.axis = 'attributes' then
  begin
    //writeln('<li>getatts:'+xmlis+'!!!');
    try
      for i := 0 to attributes.Count - 1 do
      begin
        //writeln('<li>attax:',i,'/',attributes[i]);
        apu := ttag.Create;
        apu.vari := cut_ls(attributes[i]);
        //if apu.vari='' then apu.vari:='nil';

        apu.vali := cut_rs(attributes[i]);
        apu.parent := self;
        Result.add(apu);
        //writeln('</li>createatt:',i,'<b>',apu.vari,'</b>',apu.vali);
      end;
    except
      writeln('nogo axis.attrib');
    end;
  end;
end;

function ttag.getnext: ttag;
var
  apu: ttag;
  apui: integer;
begin
  try
   result:=nil;
    if parent=nil then exit;
    apu := parent;
    apui := apu.subtags.indexof(self) + 1;
    if apui < apu.subtags.Count then
    begin
      Result := ttag(apu.subtags[apui]);
    end;
  except
    writeln('nogo path.getnext');
  end;
end;
function ttag.getprev: ttag;
var
  apu: ttag;
  apui: integer;
begin
  try
    result:=nil;
     if parent=nil then exit;
    apu := parent;
    apui := apu.subtags.indexof(self)-1;
    if apui >=0 then
    begin
      Result := ttag(apu.subtags[apui]);
    end;
  except
    writeln('nogo path.getnext');
  end;
end;


function ttag.select(pathst: string; all, empties: boolean): TList;
var
  pathroot, path: txpath;
  tag, ntag, apu: ttag;
  i,j, apui, hitmees: integer;
  hitlist,ids: TList;
  todolist, pathlist: TList;
  docreate: boolean;
  axis,apulist: TList;
  oneonly: boolean;//,debug
  turha: string;

begin
  // simple:=false;
  //    if pathst='turha' then debug:=true;
  try
    try
     try
      turha := pathst;
      docreate := False;
      Result := TList.Create;
      hitlist := TList.Create;
      pathlist := TList.Create;
      todolist := TList.Create;
      pathroot := txpath.Create;
      // if t_debug then
      if (pathst = '') or (pathst = '.') or (pathst='+') or (pathst='+.') then
      begin
         Result.add(self);
         exit;
       end;
       if pathst[1] = '+' then
      begin
        Delete(pathst, 1, 1);
        docreate := True;
        //if vari='' then
        //if pathst = '' then
        //  exit;
      end;
     except writeln('<li>empty tagselector</li>');end;
     tag := self;
      try
       if pos('.../', pathst) = 1 then
       begin
           //writeln('<h1>uptoroot</h1>');
             while tag.parent<>nil do
             begin
              tag:=tag.parent;
             end;
              pathst := copy(pathst, 5, length(pathst));
             // writeln('<li>upto:'+tag.head+'//'+pathst+'//</li>');
          end else
        if pos('.//', pathst) = 1 then
          pathst := copy(pathst, 2, length(pathst));
        if pos('../', pathst) = 1 then
        begin
          pathst := copy(pathst, 4, length(pathst));
          tag := tag.parent;
          //writeln('<li>..pathts:'+pathst+':'+tag.vari+tag.parent.vari+'</li>');
          if pathst = '' then
          begin
            Result.add(tag);
            exit;
          end;
        end;
        if pos('./', pathst) = 1 then
        begin
          pathst := copy(pathst, 3, length(pathst));
          //writeln('<li>..pathts:'+tag.vari+tag.parent.vari+'</li>');
        end;
        if pos('/!!!', pathst) = 1 then
        begin       //what the fuck?
          pathst := copy(pathst, 2, length(pathst));
          //if pos('testselect',pathst)>0  then writeln('<xmp>xxselect1:!'+pathst+'!'+tag.xmlis+'!</xmp>');
          if pos('/', pathst)>0 then
          pathst := copy(pathst, pos('/', pathst), length(pathst))
          else begin result.add(tag);exit;end;
          //try writeln('<li>..pathts:'+tag.vari+tag.parent.vari+'</li>'); except writeln('noåparemt');end;
        end;
        //if pos('testselect',pathst)>0  then writeln('<XMP>xxselect:!'+pathst+'!'+tag.xmlis+'!</XMP>');
        if pathst = '' then
        begin
          Result.add(tag);
          exit;
        end;
        pathroot.parse(pathst);
        path := pathroot;
  {//if simple then
  if not docreate then
  if maxi=1 then
   if path.next=nil  then
    if path.con=nil  then
    begin
     //simple:=true;
     for i:=0 to subtags.count-1 do
     if ttag(subtags[i]).vari=path.ele then
     begin
      //writeln('<li>simple:'+ttag(tag.subtags[i]).vari+'  = '+ttag(tag.subtags[i]).vali+'   '+turha);
      //path.list;
      result.add(ttag(subtags[i]));
      break;
     end;
     exit;
    end;
  }
  {if maxi>0 then
  begin
   if pathroot.con=nil then pathroot.con:=txcond.create;
   pathroot.con.n:=maxi;
  end else maxi:=99999;}
        //writeln('<li>plsit:</li>');
        //pathroot.list;
      except
        writeln('failed to parse xpath: ' + pathst + IntToStr(length(pathst)));
      end;
      todolist.Add(tag);
      pathlist.Add(pathroot);
      path := pathroot;

      while pathlist.Count > 0 do
      begin
        {if t_debug then
        begin
         writeln('<div style="margin:1em;border:1px solid red"><ul>');
         writeln('<li>paths:<ul>');
         for i:=0 to pathlist.count-1 do
         begin
           txpath(pathlist[i]).list;
         end;
         writeln('</ul></li><li>todo<ul>');
         for i:=0 to todolist.count-1 do
         begin
           writeln('<li>',ttag(todolist[i]).vari,'</li>');
         end;
         writeln('</ul></li><li>hits<ul>');
         for i:=0 to hitlist.count-1 do
         begin
           writeln('<li>',i,ttag(hitlist[i]).vari,'</li>');
         end;
         writeln('</ul></li></ul></div>');

        end; }
        if todolist.Count > 0 then
        begin
          tag := ttag(todolist[0]);
          path := txpath(pathlist[0]);
          todolist.Delete(0);
          pathlist.Delete(0);
        end else exit;
        if t_debug then
        begin
        // exit;
        end;
        if path = nil then
          break;
        //writeln('<li>pathi:',path.ele+'</li>');

        if tag = nil then
          break;
        //writeln('<li>pathi:',path.ele,'/tag:',tag.vari,'/val:',tag.vali+'</li>');
        if path.ele = '@next()' then
        begin
          apu := tag.getnext;
          if apu <> nil then
            Result.add(apu);
          continue;
        end;
        try
          begin
          //if t_debug then writeln('TESTING:<HR/>!',PATH.ELE,'!');
            //if path.subtags.count=0 then break;
          if PATH.ELE = '.' then
          begin
              axis := TList.Create;
              //axis.add(tag);
              //axis.Assign(hitlist);
              //writeln('/hitz:',hitlist.count);
              for j:=0 to hitlist.count-1 do
              begin
                 axis.add(hitlist[j]);
              end;                //makes no sense,not used I hope
              for j:=0 to todolist.count-1 do
              writeln('select(.): ',ttag(todolist[j]).vari+'/');
          end
          else
            if PATH.ELE = '..' then
            begin
              axis := TList.Create;
              for j:=0 to hitlist.count-1 do axis.add(ttag(hitlist[j]).parent);
              //axis.Assign(hitlist);
              //axis.add(tag.parent);
              //writeln('hit parent :',tag.parent.vari,tag.parent.attributes.text);
            end
            else
            if path.idi='' then
                  axis := tag.getaxis(path) else axis:=nil;

            //IF PATH.ELE='hui' THEN begin
            // writeln('.axis:',tag.vari,tag.subtags.Count,'/',axis.Count,'/',hitlist.Count);
            // for i:=0 to axis.count-1 do writeln(ttag(axis[i]).vali+'\');
            //end;
            //if debug then begin axis.free;exit;end;
            {if path.reverse then
            begin
              apulist:=tlist.create;
              for i:=axis.count-1 downto 0 do
               apulist.add(axis[i]);
              axis.free;
              axis:=apulist;
              //for i:=0 to axis.count-1 do
              // writeln('<li>rEv;',i,ttag(axis[i]).vali,'_',path.axis+'</li>');

            end;}
          hitlist.Clear;
          try
              if (not all) and (path.Next = nil) then
                oneonly := True
              else
                oneonly := False;
              hitmees := 0;
              if t_debug then     writeln('<li>TRYHITS:',hitlist.count,tag.vari,'!',pathst);
              if t_debug then path.list;

              if path.idi<>'' then
              begin
                ids:=txseus(t_currentxseus).x_ids.findobjects(path.idi);
                if ids=nil then begin result:=nil;exit;end;//writeln('<h1>no id='+path.idi+'</h1><xmp>'+tag.xmlis+'</xmp>!');
                //writeln('id-in-path:'+path.idi,ids.count,'////');
                //path.list;
                j:=0;
                while j<ids.count do
                begin
                 //writeln('<li>testids:',tag.vari, ' is ancesrot of '+ttag(ids[j]).vari,ids.count);
                 if ttag(ids[j]).hasancestor(tag) then
                 begin
                   //writeln('<li>ids:',tag.vari, ' is ancesrot of '+ttag(ids[j]).xmlis);
                   hitlist.add(ids[j]);
                   break;
                 end;
                 j:=j+1;
                end;

                //apu:=txseus(currentxseus).x_ids.findobject(path.idi);
                //path.list;
                //hitlist.add(ids[0]);
                //writeln('id-is::'+path.idi+'<xmp>:',ttag(ids[0]).xmlis,':</xmp>!',tag.vari,'#',ttag(ids[0]).parent.vari,'!!');
                //end;
              end else
              //logwrite('DOSE '+path.list+'!');
              if (axis<>nil) and  (axis.count>0) then
              _doselect(hitlist, axis, hitmees, pointer(path), self, oneonly, empties);
              //if t_debug then
              //writeln('<li>GOTHITS:',hitlist.count,tag.vari, '_idi:',path.idi, '_ele:',path.ele);

              //pathroot.list;
              //if hitlist.count>0 then
              //begin
              //ttag(hitlist[0]).listwrite;
              // path.list;
              //end;

            except
              writeln('failed to _doselect:<pre>'+path.list+'</pre>!'+pathst+'!');
            end;
            if axis<>nil then axis.Free;
            //if debug then exit;
            //if hitlist.count=0 then exit;

          end;
          //if debug then
          //begin
          //   exit;
          //end;
        except
          writeln('<li>failed to xhit:'+turha+'!',length(turha),turha[1]=#0);
          raise;
        end;
        if (hitlist.Count = 0) then
          if docreate then
          begin
            ntag := ttag.Create;
            if pos('*',path.ele)<1  then  ntag.vari := path.ele;
            ntag.parent := tag;
            tag.subtags.add(ntag);
            hitlist.add(ntag);
          end
          else
          if (pathlist = nil) or (pathlist.Count < 1) then
            exit;
        try
          if hitlist <> nil then
            IF (path.Next<>nil) and (path.NEXT.ele='.') THEN
            begin
              pathlist.add(path.next);
              todolist.add(tag);
              //for i := 0 to hitlist.Count - 1 do
            end
            else
            for i := 0 to hitlist.Count - 1 do
            begin
              if path.Next = nil then
              begin
                //if not simple then
                // if path.ele='.' then writeln('<li>nonexthits?:',path.ele,result.count,' pathconnil:',path.con=nil,' todo',todolist.count);

                if t_debug then writeln('<li>no-next-hits:',ttag(hitlist[i]).vali,'/ele:',path.ele,'/hits:',hitlist.count,'/paths:',pathlist.count,'</li>');
                Result.add(hitlist[i]);
                //if (path.con<>nil) and (path.con.n<=result.count) then
                if (path.con <> nil) and (Result.Count > 0) and (not all) then
                begin
                  if t_debug then  writeln('<li>enuff:'+ttag(hitlist[i]).vari);
                  exit;
                  //break;
                end;
              end
              else
              begin
                pathlist.add((path.Next));
                //if t_debug then
                //if path.idi<>'' then writeln('<li>nexthits?:',path.ele,i,' paths:',pathlist.count);
                //path.next.list;
                todolist.add(hitlist[i]);
              end  //  a/b/c
            end;
        except
          writeln('failed to find path');
        end;
      end;
    except
      writeln('<li>Failed pathselect!'+pathst+'!');raise;
    end;
  finally
    hitlist.Clear;
    hitlist.Free;
    pathlist.Free;
    todolist.Free;
    pathroot.Clear;
    pathroot.Free;

    //axis.free;
  end;
end;


function _nocdata(st: string): string;
var
  ai: integer;
begin
  Result := '';
  ai := pos('<![CDATA[', st);
  if ai < 1 then
    Result := st
  else
  begin
    while ai > 0 do
    begin
      if ai > 0 then
      begin
        Result := Result + copy(st, 1, ai - 1);
        st := copy(st, ai + 9, length(st));
        ai := pos(']]>', st);
        if ai > 0 then
        begin
          Result := Result + copy(st, 1, ai - 1);
          st := copy(st, ai + 3, length(st));
          ai := pos('<![CDATA[', st);
          if ai = 0 then
          begin
            ai := pos(']]>', st);
            if ai > 0 then
              Result := Result + ']]>' + copy(st, 1, length(st) - 3);
          end;
        end;
      end;
    end;
  end;
end;

function ttag.subs(t: string): string;
var
  tag: ttag;
  i, j, apui,tlen: integer;
  at: string;
  getcount, simple: boolean;
  reslist: TList;
  apusl: TStringList;

begin
  //   writeln('<div style="border:1px solid blue;margin-left:1em" >');
  try
    //if pos('count',t)>0 then logwrite('trycount:'+t);

    reslist := nil;
    at := '';
    simple := True;
    getcount := False;
    tlen := length(t);
    if t = '' then
      tag := self
    else
    {if t[1] = '#' then
    begin
      getcount := True;
      Delete(t, 1, 1);
      simple := False;
    end
    else}
    if t[1] = '@' then
    begin
      //at := copy(t, 2, length(t));
      at := t;
      //if t='@time' then writeln('<h1>time</h1>');

      //simple:=true;
      t := '';
    end
    else
      for i := tlen downto 1 do
      begin
        if (t[i] = '@') then //and (at='') then
        begin
          //at := copy(t, i + 1, length(t));
          at := copy(t, i , length(t));
          t := copy(t, 1, i - 1);
          //logwrite('<li>att:'+at+'/ '+t);
          break;
          //continue;
        end;
        if t[i] = ']' then
          break;
        //if pos(t[i],']/.()#')>0 then
        //begin
        //  simple:=false;
        //  if t[i]=']' then break;
        //end;
      end;
    //if at<>'' then
    //    writeln('<li>dogetatt_',at);
{  if simple then
  begin
       // xs.httpinited:=true;
          //reslist:=tlist.create;
          if at<>'' then
           result:=attributes.values[at]
           else
           for i := 0 to subtags.Count - 1 do
           if ttag(subtags[i]).vari=t then
           begin
             result:=ttag(subtags[i]).vali;
           end;
           //writeln('<li>simple:',t,' @',at,'=',result, ' ats:',attributes.text);
           //listwrite;
           exit;
   end;
   }
    if (t = '') or (t = '.') or (t = './') then
      tag := self
    else
    begin
      if getcount then
      begin
        reslist := self.select(t, True, True);
        Result := IntToStr(reslist.Count);
        exit;
      end
      else
      if at = '@count()' then
      begin
        result:='0';
        reslist := self.select(t, True, True);
        result:=inttostr(reslist.count);//=0 then
        //writeLN('gotcaount'+result);
        exit;
      end
      else
      begin
        //simple:=true;
        //if not simple then
        reslist := self.select(t, False, True);
        //simple:=false;
      end;

      if reslist.Count > 0 then
        tag := ttag(reslist[0])
      else
        tag := nil;
      // if simple then
      // begin
      //  if reslist.count>1 then
      //  writeln('<li>simple selection:',reslist.count,tag.vari+'  '+ttag(reslist[1]).vari);

      // end;

    end;
    if tag <> nil then
    begin
      if at <> '' then
      begin
        at:=copy(at,2,length(at));
        if at='' then result:=trim(tag.vari) else
        if at[length(at)] = ')' then
        begin
          if (at = 'element()') or (at = '.()')then
            Result := trim(tag.vari)
          else
          if at = 'name()' then
            Result := tag.vari
          else
          if at = 'attcount()' then
          begin
          if tag<>nil then
            //result:=inttostr(ttag(reslist[0]).attributes.count)
            result:=inttostr(tag.attributes.count)
            else result:='-1';
          end
          else
          if at = 'count()' then
          begin
            if reslist = nil then
              Result := '0'
            else
              Result := IntToStr(reslist.Count);
              logwrite('@counting:'+result);
          end
          else
          if at = 'normtext()' then
            Result := _normalizewhitespace(tag.vali, True)
          else
          if at = 'trimtext()' then
            Result := trim(tag.vali)
          else
          if at = 'text()' then
          begin
            if vari = 'cdata' then
            begin
              Result := _nocdata(tag.vali);
            end
            else
            begin
              Result := (tag.vali);
            end;
          end
          else
          if at = 'ttexts()' then
          begin
            Result := (tag.vali);
            for i := 0 to tag.subtags.Count - 1 do
              if (ttag(tag.subtags[i]).vari = 'nonono_value') or
                (ttag(tag.subtags[i]).vari = '') then
                Result := Result + crlf + ttag(tag.subtags[i]).vali;
          end
          else
          if at = 'ttext()' then
          begin
            Result := (tag.vali);
            if tag.subtags.Count > 0 then
              if (ttag(tag.subtags[0]).vari = 'nonono_value') or
                (ttag(tag.subtags[0]).vari = '') then
                Result := Result + crlf + ttag(tag.subtags[0]).vali;
          end
          else
          if at = 'clean()' then
            Result := _cleanattr(trim(tag.vali))
          else
          if at = 'lowercase()' then
            Result := ansilowercase(tag.vali)
          else
          if at = 'uppercase()' then
            Result := AnsiUpperCase(tag.vali)
          else
          if at = 'list()' then
            Result := trim(tag.listst)
          else
          if at = 'listent()' then
            Result := _clean(tag.listst)
          else
          if at = 'listxml()' then
          begin
            Result := tag.listxml('', False,true);
          end
          else
          if at = 'listxmlsub()' then
          begin
            //result:=tag.vali;
            for j := 0 to tag.subtags.Count - 1 do
              Result := Result + ttag(tag.subtags[j]).listxml('', False,false);
          end
          else
          if at = 'listindent()' then
          begin
            apusl := TStringList.Create;
            tag.list(' ', apusl);
            Result := apusl.Text;
            apusl.Clear;
            apusl.Free;
          end
          else
          if at = 'listindentsub()' then
          begin
            apusl := TStringList.Create;
            for j := 0 to tag.subtags.Count - 1 do
              ttag(tag.subtags[j]).list(' ', apusl);
            Result := apusl.Text;
            apusl.Clear;
            apusl.Free;
          end
          else
          if at = 'sublist()' then
            Result := trim(tag.listst)
          else
          if at = 'alltext()' then
          begin
            Result := trim(tag.getsubvals);
          end
          else
          if at = 'alltexts()' then
          begin
            Result := tag.getsubvalsasis;
          end
          else
{       if at='listitree()' then
       begin
         result:=tag.listitree;
       end else}
          if at = 'listjson()' then
          begin
            Result := tag.listjson('  ');
          end
          else
          if at = 'xmlis()' then
          begin
            Result := tag.XMLIS;
          end else
          if at = 'head()' then
          begin
            Result := tag.head;
          end
          else

          if at = 'rawxml()' then
          begin
            Result := tag.listraw;
          end
          else
          if (at='xml()') or (at = 'asstring()') then
          begin
            //Result := tag.xmlis;
            Result := tag.listst;
          end
          else
          if at = 'asxstring()' then
          begin
            Result := tag.listxml('  ', True,true);
          end
          else
          if at = 'nocdata()' then
          begin
            Result := _nocdata(tag.listst);
          end
          else
          if at = 'position()' then
          begin
            if tag.parent <> nil then
            begin
              Result := IntToStr(tag.parent.subtags.indexof(tag) + 1);
              //writeln('<li>position: ',result,'/',tag.parent.subtags.count);

            end
            else
              Result := '-1';
          end
          else
          if at = 'parent()' then
            Result := tag.parent.vari
          else
          if at = 'attributes()' then
            Result := tag.attributes.Text
          else
          if at = 'ntobr()' then
          begin
            Result := tag.vali;
            Result := StringReplace(Result, '\n', '<br />', [rfreplaceall]);
          end;
        end
         else
         if (at='.') then
           Result := trim(tag.vari) else
         begin
          try
           //writeln('<li>getatt_',tag.vari,'/att:',at,'=',strtointdef(at,-999),'/atts:',tag.attributescount,'</li>');
          apui:=strtoint(at)-1;  //fail in nonnum
          if apui>-1 then result:=tag.getatt(apui);
          //writeln('<li>getatt_',tag.vari,'-',at,'=',result,'</li>');
          except
          try
            Result := tag.att(at);
          except writeln('<li>faildedtogetatt');  exit;      end;
          end;
         end;
      end
      else  //no attributes, get the text value
      begin
        try
          //result:=trim(tag.vali);
          Result := (tag.vali);
        except
          writeln('failedtogetatt:'+at+'!');
          raise;
        end;
        if Result = '' then
          if tag.subtags.Count > 0 then
            if (ttag(tag.subtags[0]).vari = '') then
              Result := ':'+ttag(tag.subtags[0]).vali
            else
            if (ttag(tag.subtags[0]).vari = 'cdata') then
              Result := '<![CDATA[' + ttag(tag.subtags[0]).vali + ']]>'
            //else
            //  Result := tag.vali + tag.getsubvals;
      end;
    end

    else
      Result := '';
  finally
    //writeln('</div>');
    //if reslist<>nil then reslist.clear;
    reslist.Free;
  end;

end;

function ttag.subt(t: string): ttag;
var
  reslist: TList;par:ttag;
begin
  //simple:=false;
  Result := nil;
  {if pos('..', t) = 1 then
  begin
    if parent <> nil then
      reslist := parent.select(copy(t, 3, length(t)), True, True);
  end
  else}
    reslist := self.select(t, True, True);
  {if t = 'turha' then
  begin
    writeln('<li>finding testtag', reslist.Count);
    //listwrite;
    Result := nil;
    reslist.Clear;
    reslist.Free;
    exit;
  end;}
  if reslist.Count > 0 then
    Result := ttag(reslist[0])
  else
    Result := nil;
  reslist.Clear;
  reslist.Free;
end;
function ttag.subtbyatt(tagname,attname,attval: string): ttag;
var
  reslist: TList;i:integer;
begin
  //simple:=false;
  //logwrite('findbyatt:'+self.xmlis+'_'+tagname+'@'+attname+'='+attval+'!'+self.vari);
  Result := nil;
  {if pos('..', tagname) = 1 then
  begin
    if parent <> nil then
      reslist := parent.select(copy(tagname, 3, length(tagname)), True, True);
  end
  else}
    reslist := self.select(tagname, True, True);
  //logwrite('find att:'+attname+'value matching:'+attval+inttostr(reslist.count));
  for i:=0 to  reslist.Count-1 do
    if ttag(reslist[i]).att(attname)=attval then
    begin
     Result := ttag(reslist[i]);
     //logwrite('foundbyatt:'+result.xmlis);
     break;
    end;// else    logwrite('nofoundbyatt:'+ttag(reslist[i]).xmlis+'!');

  reslist.Clear;
  reslist.Free;
end;

function ttag.addsubtag(varix, valix: string): ttag;
var
  uustag: ttag;
begin
  varix := trim(varix);
  if subtags = nil then
    exit;
  {if varix = '' then
    if valix = '' then
      VARIX := 'aERROR';
  }//uustag := ttag.createst(self, varix);
  uustag := createtag(self, varix);
  //uustag := ttag.create;
  //uustag.parent=self;
  //uustag.vari:=trim(varix);
  uustag.vali := valix;
  subtags.add(uustag);
  Result := uustag;
  //if varix='mymark' then writeln(txseus(t_currentxseus).x_bookmarks.xmlis);
 // x_bookmarks.xmlis);
end;

procedure ttag.addsubprop(propvaris: TStringList; param, term: string);
var  //no idea .. somethng to do with unification. Adds a subtag , but also adds something
   // to mysterious propvaris stringlist. Only called in tagparse
  avar: string;
begin
  avar := '';
  if pos('=', param) > 0 then
  begin
    avar := cut_rs(param);
    param := cut_ls(param);
    if param = 'token' then     param := '';
    propvaris.add(param + '=' + avar);
  end;
  param := _cleanattr(param);
    {if param = '' then  begin   param := '';//VALUE  end;}
  if param <> 'token' then
    addsubtag(param, term)
  else
    vali := term;
end;

{function ttag.getdent(dents: string): string;
var
  i, dep: integer;
  dent, st: string;
  f: Text;
begin
  Result := dents + vari;
  for i := 0 to attributes.Count - 1 do
    Result := Result + (' @' + attributes[i]);
  st := vali;
  st := StringReplace(st, ^M + ^J, ^M + ^J + dents + '*', [rfreplaceall]);
  Result := Result + st;
  for i := 0 to subtags.Count - 1 do
    Result := Result + (crlf + dents + ttag(subtags[i]).getdent(dents + '  '));

end;
//experimenting with YAML-style syntax
procedure ttag.savedents(fil: string);
var
  i, dep: integer;
  dent, dents: string;
  f: Text;
  res: TStringList;
begin
  fil := 'c:\temp\turha.dnt';
  //assign(f,fil);
  //rewrite(f);
  res := TStringList.Create;

  res.add(getdent(''));
  res.savetofile(fil);
end;
}
function ttag.savetofileind(t: string; xhead: boolean; head: string;
  compact: boolean): boolean;
var
  stl: TStringList;
  f: Text;
  i: integer;
begin
  stl := TStringList.Create;
  try
    try

      //if compact=true then
      begin
        if head <> '' then
          stl.add(head);
        listxmlish('', stl,compact);
        try
          assignfile(f, t);
        except
          writeln('noassign:', t, '|');
          raise
        end;
        try
          rewrite(f);
        except
          writeln('<li>failed savefile:', t, '</li>');
          raise;
        end;
        for i := 0 to stl.Count - 1 do
          writeln(f, stl[i]);
        closefile(f);
      end;
      Result := True;
      //writeln('didsavefile');
    except
      Result := False;
    end;
  finally
    stl.Clear;
    stl.Free;
  end;

end;
//    function saveeletofile(t: string; xhead: boolean; head,ind: string; compact,ents: boolean): boolean;

function ttag.saveeletofile(t: string; xhead: boolean; head,ind: string;  compact,ents: boolean): boolean;
var
  stl: TStringList;
  f: Text;
  i: integer;
  st,EXT: string;
begin
  //if head<>'' then head:=head+^J;
  ext := extractfileext(t);
  if (pos('xmlis', head) > 0) or (ext = '.htmi') or (ext = '.xsi') then
  begin
    Result := savetofileind(t, xhead, head, compact);
    exit;
  end;
  try
    try
      //if head <> '' then       stl.add(head)    else
       if (head='') then if (xhead) then head:='<?xml version="1.0" encoding="UTF-8"?>';
      // if xhead then stl.add(' <!DOCTYPE '+self.vari+'>');
      //       writeln(stl.text);
      //      writeln('</xmp>');
      if not ForceDirectories(extractfilepath(t))
      { *Converted from ForceDirectories*  } then
        writeln('<li>could not forcedir');
      if compact = True then
      begin
       stl := TStringList.Create;
       try
       stl.TextLineBreakStyle:=tlbsLF;
        if head<>'' then stl.add(head);
        list('', stl);
        assignfile(f, t);
        rewrite(f);
        for i := 0 to stl.Count - 1 do
          Write(f, stl[i]);
        closefile(f);
        finally    stl.Clear;    stl.Free;  end;

      end
      else
      begin
        try
         st:=listxml('  ',ents,true) ;
         //writeln('<li><small>xwrite file ',t,'</small><xmp>',xmlis,'/head:',head,'!</xmp>',compact,ents,'!</li>xml:<xmp>',st,'</xmp>');
         //writeln('<li><small>Xxwrite file ',t,'/head:',_clean(head),'!',compact,ents,'!</small></li>');
         if head<>'' then head:=head+^J;
          _writefile(t,head+st);
          //stl.add(listxml('  ', true));
          //stl.savetofile(t);
        except
          writeln('<li>Failed to save:' + t);
          raise;
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  except
    writeln('<li>Failed to write '+t);
  end;
end;

{
function ttag.inferers: string;
var i:integer;tt:ttag;st:string;

function _invalidelemname(st:string):boolean;
var i:integer;
  begin
     result:=false;
     for i:=1 to length(st) do
     if st[i]<>'_' then
     if st[i] in ['<','>','"',' ',
     '''',
     ';',
     ',',
     '.'] then
     begin
      result:=true;
      end;
     end;
begin
i:=-1;
 while i<subtags.count-1 do
 begin
  inc(i);
   tt:=ttag(subtags[i]);
   tt.inferers;
  if _invalidelemname(tt.vari) then
  begin
    st:='&lt;'+tt.vari+tt.intext;
    st:=StringReplace(st,'<','&lt;',[rfreplaceall]);
    st:=StringReplace(st,'>','&gt;',[rfreplaceall]);
    tt.vari:='value';
    tt.vali:=st;
    tt.attributes.Clear;
    end;
 end;
end;
}
function ttag.att(t: string): string;
begin
  Result := attributes.values[t];
end;


function ttag.clonetag(par:ttag;subs:boolean): ttag;
//clones a tag, without copying subtags (only pointers to them)
var
  i: integer;
  res, atag: ttag;

begin
  //result:=self;exit;
  //writeln('<ul><li>ccs;',vari,subtags.count);

  res := ttag.Create;
  res.vari := vari;
  res.vali := vali;
  //res.attributes.add('copy='+inttostr(subtags.count));
  for i := 0 to attributes.Count - 1 do
    res.attributes.add(attributes[i]);
  if subs then
  for i := 0 to subtags.Count - 1 do
  begin
    //WRITELN('TTT',ttag(subtags[i]).VARI);
    res.subtags.add(subtags[i]);
  end;
  //res.xcopied:=true;
  res.xquoted := xquoted;
  Result := res;
  res.parent:=par;
  if par<>nil then par.subtags.add(res);
  //writeln('</li><li>-cc;',result.vari,result.subtags.count,'</li></ul>');
end;
function ttag.copytag: ttag;
var
  i,subtogo: integer;
  //res,
  totag,fromtag: ttag;
  FROMS,TOS:tlist;
begin
  //result:=ttag.create;
  i:=0;
  tos:=tlist.create;
  froms:=tlist.create;
  try
  fromtag:=self;
  FROMS.ADD(self);
  totag:=fromtag.clonetag(nil,false);
  tos.add(totag);
  result:=totag;
  //res.attributes.add('copy='+inttostr(subtags.count));
  //WRITELN('<li>startCOPYY',fromtag.VARI,froms.count);
  while froms.count>0 do
  begin
    //i:=i+1;
    //if i>100 then exit;
    subtogo:=fromtag.subtags.count-totag.subtags.count;
    if subtogo=0 then  //bactrack
    begin
      froms.Delete(froms.count-1);
      tos.Delete(tos.count-1);
      if froms.count=0 then exit;
      fromtag:=froms[froms.count-1];
      totag:=tos[tos.count-1];
      //WRITELN('<li>DIDCOPYY',fromtag.head,'/subtogo:',subtogo,'/done:',totag.subtags.count,'/levs:',tos.count,'=',froms.count);
      //if cut_ls(attributes[i])='id' then
      //  writeln('<h4>copyatt:,',res.xmlis,'</h4>');
    end else  //go deeper
    begin
     fromtag:=fromtag.subtags[totag.subtags.count];
     froms.add(fromtag);
     totag:=fromtag.clonetag(totag,false);
     tos.add(totag);
     //WRITELN('<li>WILLCOPYY',fromtag.head,'/subtogo:',subtogo,'/done:',totag.subtags.count,'/levs:',tos.count,'=',froms.count);
    end;
  end;
    //res.xcopied:=true;
    //writeln('</li><li>-cc;',result.vari,result.subtags.count,'</li></ul>');
   //    Result := ;
   finally
    froms.clear;tos.clear;
   froms.free;tos.free;  end;
end;
function ttag.copytagnew: ttag;
var
  i: integer;
  res, atag: ttag;
begin
  //result:=self;exit;
  //writeln('<ul><li>ccs;',vari,subtags.count);

  res := ttag.Create;
  res.vari := vari;
  res.vali := vali;
  //res.attributes.add('copy='+inttostr(subtags.count));
  for i := 0 to subtags.Count - 1 do
  begin
    //WRITELN('TTT',ttag(subtags[i]).VARI);
    atag := ttag(subtags[i]).copytag;
    atag.parent := res;
    res.subtags.add(atag);
  end;
  for i := 0 to attributes.Count - 1 do
  begin
    res.addatt(attributes[i]);
    //if cut_ls(attributes[i])='id' then
    //  writeln('<h4>copyatt:,',res.xmlis,'</h4>');
  end;
  //res.xcopied:=true;
  res.xquoted := xquoted;
  Result := res;
  //writeln('</li><li>-cc;',result.vari,result.subtags.count,'</li></ul>');
end;

function ttag.copyutftag: ttag;
var
  i: integer;
  atag: ttag;
begin
  Result.xquoted := xquoted;
  Result.vali := _utf8toasc(vali);
  for i := 0 to attributes.Count - 1 do
    Result.attributes.add(_utf8toasc(attributes[i]));
  for i := 0 to subtags.Count - 1 do
  begin
    atag := ttag(subtags[i]).copyutftag;
    atag.parent := Result;
    Result.subtags.add(atag);
  end;
  // result.xselected:=xselected;
end;

procedure ttag.subtagsadd(newt: ttag);
begin
  subtags.add(newt);
  newt.parent := self;
end;

procedure ttag.subtagscopy(sou: TList);
var
  i: integer;
begin
  for i := 0 to sou.Count - 1 do
    subtags.add(sou[i]);
end;
function ttag.copysubtags:TList;
 //adds the subtags without making separate copies of elements
var
  i: integer;
begin
  result:=tlist.create;
  for i := 0 to subtags.Count - 1 do
    result.add(subtags[i]);
end;

procedure ttag.valitovalue;
var
  vtag: ttag;
begin
  if vali <> '' then
  begin
    vtag := ttag.Create;
    subtags.Insert(0, vtag);
    vtag.vari := '';//VALUE
    vtag.vali := vali;
    vali := '';
  end;

end;

procedure ttag.listparts(pre: string; var outfile: string; res: TStringList;
  splitat: string);
var
  i, j: integer;
  atr: boolean;
  rest, newpre, apu: string;
  noname: boolean;
  res2: TStringList;
begin
  try
    try
      if splitat = '' then
        splitat := 'newoutfile';

      rest := '';
      atr := True;
      newpre := pre;
      if vari = splitat then
      begin
        res.savetofile(outfile);
        res.Clear;
        outfile := outfile + '_x';
        if att('file') <> '' then
          outfile := att('file');
        //writeln('z<li>outto:_'+outfile);
        exit;
      end;
      if vari = 'cdata' then
      begin
        res.add('<![CDATA[' + vali + ']]>');
        exit;
      end;
      if (vari = '') then
        noname := True //VALUE
      else
        noname := False;
      if noname then
      begin
        rest := vali;
      end
      else
        rest := pre + '<' + vari + '';
      if not noname then
        for i := 0 to attributes.Count - 1 do
        begin
          if cut_ls(attributes[i]) = 'xse:compact' then
            newpre := ''
          else
            rest := rest + ' ' + cut_ls(attributes[i]) + '="' +
              cut_rs(attributes[i]) + '"';
        end;
    except
      writeln('<!--Ssubtag ' + vari + ' not found-->');
    end;
    if subtags = nil then
    begin
      res.add(pre + rest + ' LOPPU />');
      exit;
    end;
    if (subtags.Count = 0) and (not noname) then
    begin
      if vali = '' then
        //if (vari = 'img') or (vari = 'br') or (vari = 'input') then
        if pos(','+vari+',', gc_voids)>0 then
          res.add(pre + rest + ' />')
        else
          res.add(rest + '></' + vari + '>')
      else
        res.add(rest + '>' + (vali) + '</' + vari + '>');
    end
    else
    begin
      if not noname then
        rest := rest + '>' + (vali);
      res.add(rest);
      rest := '';
      if newpre <> '' then
        newpre := pre + '  ';
      for i := 0 to subtags.Count - 1 do
      begin
        if subtags[i] = nil then
          continue;
        begin
          rest := '';
          try
            if newpre = '' then
            begin
              res2 := TStringList.Create;
              ttag(subtags[i]).listparts(newpre, outfile, res2, splitat);
              apu := '';
              for j := 0 to res2.Count - 1 do
                apu := apu + (res2[j]);
              res.add(apu);
              res2.Clear;
              res2.Free;
            end
            else
              ttag(subtags[i]).listparts(newpre, outfile, res, splitat);
          except
            writeln('Failed to list ' + vari + '/' + vali);
            raise;
          end;
        end;
      end;
      if not noname then
        res.add(pre + '</' + vari + '>');
    end;
  except
    writeln('<!--subtag ' + vari + ' not found-->');
  end;

end;



end.
end;



procedure txcond.list;
begin
  writeln('x:', x, ' y:', y, '  gt:', gt, ' lt:', lt, '...', nextand,
    ' nil:', Next = nil);
  if Next <> nil then
    Next.list;
end;

function txcond.parsepaska(path: string; var posi: integer): boolean;
var
  debug,numonly: boolean;

  procedure _skipwhite(var posi: integer; path: string);
  begin
    while (posi < length(path)) and (path[posi] = ' ') do
      posi := posi + 1;
  end;

  function getpunct(sta, sto: char): string;
  var
    len, pars: integer;
    inquote: boolean;
  begin
    Result := '';
    pars := 0;
    inquote := False;
    len := length(path);
    while (posi < len) do
    begin
      posi := posi + 1;
      if path[posi] = '''' then
        inquote := not inquote;
      Result := Result + path[posi];
      if not inquote then
        if (path[posi] = sto) then
          if pars = 0 then
          begin
            posi := posi + 1;
            break;
          end
          else
            pars := pars - 1;
      if not inquote then
        if (path[posi] = sta) then
        begin
          pars := pars + 1;
        end;
    end;
    //writeln('<li>parenth:'+sta+sto+result);
  end;

  function getallpuncts: string;
  //if we are at '[( then preceed to the end-character '])
  begin
    Result := '';
    if path[posi] = '''' then
    begin
      posi := posi + 1;
      while (posi < length(path)) and (path[posi] <> '''') do
      begin
        Result := Result + path[posi];
        posi := posi + 1;
      end;
      Result := '''' + Result + '''';
      posi := posi + 1;
      //WRITELN('JUST THE QUOTED:'+RESULT);
    end
    else
    //if path[posi]='''' do
    // result:=''''+getpares('''') else
    if path[posi] = '[' then
      Result := '[' + getpunct('[', ']')
    else
    if path[posi] = '(' then
      Result := '(' + getpunct('(', ')');
  end;
  //proedure _getrest;
  function _condpart(enders: string): string;
  var
    bracs: integer;
    inquote: boolean;
  begin
    inquote := False;
    Result := '';
    while posi < length(path) do
    begin
      Result := Result + getallpuncts; //WHYHWHYWHY???
      /// writeln('<li><b>'+'paRES:</b>',bracs,result,'</li>');
      if not inquote then
        if (pos(path[posi], enders) > 0) then
          break;
      if path[posi] = '''' then
        inquote := not inquote;
      Result := Result + path[posi];
      posi := posi + 1;
    end;
    //if debug then
    // writeln('<li><b>'+'patx:'+PATH+'</b>',POSI,result,'*',ENDERS,INQUOTE,'</li>');
  end;

  procedure _getcompar;
  var
    ch:char;
  begin
    Result := True;
    ch:=path[posi];posi:=posi+1;
    //writeln('xcompare:',ch,'/'+copy(path,posi,9),'/');
    if ch = '<' then
    begin
       if path[posi]='=' then
       begin posi:=posi+1;eq:=true;
       end;
       lt := True;
    end else
    if ch = '>' then
    begin
       if path[posi]='=' then
       begin posi:=posi+1;eq:=true;
       end;
       gt := True;
    end else
    if ch = '=' then
      eq := True;
    if (ch = '!') and (path[posi]='=') then
    begin posi:=posi+1;eq:=true;negat:=true;
       //writeln('notequals');
    end else
    if ch = '@' then
    begin
      eq := True;
      match := True;
    end;

  end;
var bool:string;
begin //txcond.parse
  try
    Next := nil;
    negat:=false;
    Result := False;
    debug := False;
    posi := posi + 1;
    //if debug then
    //writeln('<li>docondx:',copy(path,posi,9999)+'!'+path[posi]+'!</li>');
    lt := False;
    gt := False;
    eq := False;
    hits:=0;tries:=0;bool:='';
    //xnewsyntax := False;
    {no more negation
    if (posi <= length(path)) and (path[posi] = '-')  //start with minus sign
      and ((pos('=', path) > 1) or (pos(' ', path) > 1))   //minus not arithm.
    then
    begin
      posi := posi + 1;
      neg := True;
             WRITELN('<LI>neg:',x,'-',y);

      //op:='-';
    end;
    }
    _skipwhite(posi, path);
    begin
      x := _condpart(']=><&|!');
      //if x='last()' then x:=
      _skipwhite(posi, path);

      //writeln('<li>dogetcomp:',copy(path,posi,9999),'/',x,'!');
      //if (path[posi] = ']')  then
      //begin
      //  y := '';
        //posi:=posi+1;
        //exit;   no. check out &| and numbers first
      //end
      //else
      if pos(path[posi],'=><!@')>0 then
      begin
        _getcompar;
        _skipwhite(posi, path);
        y := _condpart(']&|');
        //writeln('GETYshort:',copy(path,posi,9999),'!',y,'#');
        // WRITELN('<LI>oldsyns:',x,'-',y,'!',eq,gt,lt);
      end
      else y:='';
      //begin
      //  if pos('and ',copy(path(posi
      //  exit;
      //end;
{z      if (path[posi]='[')  then
     begin
       sub:=txcond.create;
       sub.parse(path,posi);
       n:=sub.n;
     end;
 }
    end;
    //_skipwhite(posi, path);
    if path[posi] = ']' then
     posi:=posi+1;
{    begin
      if (strtointdef(x, -999999) <> -999999) and (trim(y) = '') then
      begin
        //writeln('<li>numx?:',X,'=',y);
        //xnewsyntax := True;
        eq := True;
        y := x;
        x := '#';
        //writeln(' // ',X,'=',y);
      end;
      posi := posi + 1;

      //exit;
    end;
}
    if trim(y)='' then
    begin
      eq := True;
      y := x;
      x := '#';
    end;
    _skipwhite(posi, path);
    if posi < length(path) then
    begin
      //writeln('<li>rest:',bool,'!',copy(path,posi,9999),'</li>');
      {if path[posi]='[' then bool:='and'
       else  then
       begin
         bool:='and';posi:=posi+2;
         writeln('<li>boo:',bool,'!',copy(path,posi,9999),'</li>');


       end;
      //posi:=posi-1;

      WRITELN('<li>result',result,' more:',copy(path,posi,999),'</li>');}
     // _skipwhite(posi, path);
     // if (path[posi] = '&') or (path[posi]='[') then
     if (path[posi]='&') or (pos('and',path)=posi) then
     //if (bool='and') then
      begin
        if path[posi]<>'[' then  posi:=posi+1;
        //if path[posi]<>'[' then  posi:=posi+2;
        //_skipwhite(posi, path);
        //posi:=posi-1;
        //_skipwhite(posi,path);
        //WRITELN('EXTRAAKONDITIONIS',copy(path,posi,999));
        Next := txcond.Create;
        Next.parse(path, posi);
        //nn := Next.nn;
        //writeln('<hr/>');
        nextand := True;
        //list;
        //break;
      end
      else
      //if (pos('or',path)=posi) then
      if path[posi] = '|' then
      begin
        posi:=posi+1;
        Next := txcond.Create;
        Next.parse(path, posi);
        //nn := Next.nn;
        //writeln('parsenext');next.list;
        nextand := False;
        //break;
      end;
      //if next<>nil then  writeln('<li>nexx:',next.X,'=',next.y);
      //  writeln('<li>this:',X,'=',y,'X',copy(path,posi,9999));
      exit;
    end;

     {z
     else
     if path[posi]=']' then
     begin
      if posi<length(path) then
       begin
          if pos(path[posi+1],'0123456789')>0 then
          begin
           posi:=posi+1;
           n:=strtoitdef(path[posi],9999999);
           end;
        end;
       posi:=posi+1;
       break;
     end
     else
      x:=x+path[posi];
   end;
 }
  finally
    if t_debug then   writeln('<li>_didcondx',copy(path,posi,9999), ' -x=', x, '-y=', y, '-s/eq/gt/lt:',        eq, gt, lt,'</li>');
  end;
end;



end;


function ttag.listxml(inde:string; ents,isroot: boolean): string;
{D: one of despare efforts to handle whitespace correctly
}
function etrim(v:string):string;
begin
    if ents then begin result:=trim(_clean(v));writeln('<li>cleaning:' +result);end else result:=v;//trim(v);
end;
var
  st, subc,tmpinde: string;
  i: integer;

begin
  try
  ents:=false; //?????
  if isroot then tmpinde:='' else tmpinde:=inde;
  //if isroot then Result := '' else result:=^J;
  if vari = 'xxxcdata' then
  begin
    st := StringReplace(vali, ']]>', ']]]]><![CDATA[>', [rfreplaceall]);
    Result := Result + '<![CDATA[' + st + ']]>';
    exit;
  end;
  if (vari = 'nonono_value') or (vari = '') then
    Result := ''
  else
  begin
    if (tmpinde='') or (pos('<'+uppercase(vari)+'>', gc_inlineelems)>0) then
    Result := '<' + vari //+' inde="'+inde+'"'
      //  <b> joo</b>  <em>joo  </em> missä välit
      // ent' <pre>
    else
    Result := ^j + tmpinde+'<' + vari ;//inde="'+inde+'"';
    try
    //if attributes<>nil then
    for i := 0 to attributes.Count - 1 do
      Result := Result + ' ' + cut_ls(attributes[i]) + '="' +
        cut_rs(attributes[i]) + '"';
    except writeln('<li>failes list atts #'+'!'+vari);end;
  end;
  subc := '';
  except writeln('<li>failes tag #'+'!');raise;end;
  try
  if subtags<>nil then
  if subtags.count>0 then
  for i := 0 to subtags.Count - 1 do
  begin
   //try    if ttag(subtags[i]).vari<>'' then writeln('');  except writeln('failing subtag');raise;end;
    if ttag(subtags[i]).vari = 'cdata' then
      subc := subc + '<![CDATA[' + StringReplace(ttag(subtags[i]).vali,
        ']]>', ']]]]><![CDATA[>', [rfreplaceall]) + ']]>'
    else
    if (ttag(subtags[i]).vari = '') then
     begin
      subc := subc +etrim(ttag(subtags[i]).vali);
      //subc := subc + '!'+(ttag(subtags[i]).vali)+'/'+inttostr(i);
      //writeln('<li>',vari,'vali:'+'/'+ ttag(subtags[i]).vali+ '\');
     end
    else   //never happens:   //VALUE if (ttag(subtags[i]).vari='value') and (ttag(subtags[i]).subtags.count=0)  then
    if (ttag(subtags[i]).vari = '') and (ttag(subtags[i]).subtags.Count = 0) then
      subc := subc + etrim((ttag(subtags[i]).vali))
    else
    try
    begin
      //if (inde<>'')  then
      //begin
      // subc := subc + (ttag(subtags[i]).listxml('', ents));
      //end else
    //if inde='' then
    //subc := subc + (ttag(subtags[i]).listxml('', ents,false)) else
    subc := subc + (ttag(subtags[i]).listxml('  '+tmpinde, ents,false));

    end;except writeln('<li>failes subbtag #'+inttostr(i));end;
  end;
  except writeln('<li>could not write subbtags to res:');writeln(ttag(subtags[i]).vari+inttostr(subtags.count)+'!'+inde+'!'+booltostr(ents));end;
  try
  if (vari = '') then
  begin
    //if inde<>'' then
      Result := Result + etrim(vali)+subc; //_normalizewhitespace(vali, False) + (subc)
   // else
   //   Result := Result +vali + subc;
  end
  else
  begin
   if (subc + trim(vali) = '') and (pos(',' + vari + ',', gc_voids) > 0)  then
    Result := Result + '></'+vari+ '>'
   //Result := Result + crlf+'/>'
   else
   begin
     if trim(subc)='' then tmpinde:='' else tmpinde:=^J+tmpinde;
     Result := Result + '>' + etrim(vali) + (subc) +tmpinde+ '</' + vari + '>'
   end;
  end;
  except writeln('<li>could not write tags to res');end;
  //logwrite('**!!'+result+'!!**');
  {if ents then
   Result := Result + '>' + _clean(vali) + (subc) + '</' + vari +crlf+ '>'
 else
   Result := Result + '>' + vali + (subc) + '</' + vari +crlf+ '>';}
  // if isroot then writeln('LISTED:<xmp>',result,'</xmp>');
end;


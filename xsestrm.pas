unit xsestrm;

{$mode delphi}

{TODO
 - json, xml

 - streamseek previous pos
 or
 - save lines

 - nested sapply's (stream thru subtags)
  .. substreams  .. prepared
}

interface
uses

  Classes, SysUtils,xsexml,math;

type tstreamlevel=class;

tstreamer = class(tobject)
sfile:tfilestream;
fname:string;
eof:boolean;
curline,prevline:string;
inquotedpar,incommentedpar: boolean;
curlineind,prevind,
curlevel,prevlevel,targetdepth,limitti,changedlev:integer;//,skipbelow
level: tstreamlevel;
levels:tlist;
constructor Create(filee:string;resu,acom:ttag);
destructor free;
function gettag(vari:string;curlinepos:integer):ttag;
procedure skiplevel(dto:integer);
function getlevel(par:ttag;dto:integer):boolean;
function ReadLine:boolean;
function ReadLinejson:boolean;
function createlevels(acom:ttag):tlist;
function parseline(line:string):ttag;
function getfirstword(lin: string; var curpos: integer): string;
function next(lev,ind:integer;res:ttag): ttag;
end;

txmlstreamer = class(tstreamer)
 nextup,nextdown:integer;
 nextch, prevchar:char;
 intag,inval,incom:boolean;
 nextline,prevline:string;
 roottag,curtag:ttag;
 function Readstarttag(var aline:string):boolean;
 constructor Create(filee:string;resu,acom:ttag);virtual;
 destructor free;
 function getlevel(par:ttag;dto:integer):boolean;
 function next(root:ttag): ttag;
 //function gettag(lev:tstreamlevel):ttag;
 end;

 tjsonstreamer = class(tstreamer)
  nextup,nextdown:integer;
  nextch:ansichar;
  parts:tstringlist;
  function ReadLine(var ari,ali:string):boolean;virtual;
  constructor Create(filee:string;resu,acom:ttag);virtual;
  destructor free;
// function next(lev,ind:integer;res:ttag): ttag;virtual;
{sfile:tfilestream;
fname:string;
eof:boolean;
curline,prevline:string;
inquotedpar,incommentedpar: boolean;
curlineind,prevind,
curlevel,targetdepth,limitti,changedlev:integer;//,skipbelow
level: tstreamlevel;
levels:tlist;
constructor Create(filee:string;resu,acom:ttag);
procedure skiplevel(dto:integer);
function ReadLine:boolean;
function ReadLinejson:boolean;
function createlevels(acom:ttag):tlist;
function parseline(line:string):ttag;
function getfirstword(lin: string; var curpos: integer): string;
}
function getlevel(par:ttag;dto:integer):boolean;
function next: ttag;
//function gettag(lev:tstreamlevel):ttag;
end;

tstreamlevel=class(tobject)
 s:tstreamer;
 prev:tstreamlevel;
 lev,ind:integer;
 lookingfor:string;
 tagi:ttag;
 pos:int64;
 constructor create(leve:integer);
 destructor free;
 function dbug:string;
  end;

implementation
uses xsemisc,xseglob;

{function tjsonstreamer.gettag(lev:tstreamlevel):ttag;
var p:integer;atag:ttag;vall,varl:string;
begin
parts.clear;
atag:=nil;
p:=_split(curline,'"',PARTS);
if p=3 then begin vall:='';varl:=parts[1];end
else if p=5 then begin vall:=parts[3];varl:=parts[1];end
else if nextdown>0 then
begin vall:='';varl:='item';end else begin vall:='';  varl:='';end;
//ind:=copy('                             ',1,curlineind*2);
if varl<>'' then
begin
//writeln('<li>','<b>',varl,'</b>:',vall, '<small>(',curline,curlineind,')</small>',p);
atag:=ttag.create;
atag.vari:=varl;atag.vali:=vall;
//curlevel:=curlevel+1;
//level:=levels[curlevel];
if lev<>nil then
begin
if level.tagi<>nil then begin //writeln('<li>kill:',level.tagi.xmlis);
  level.tagi.killtree;end;
  level.tagi:=atag;
//if level.tagi<>nil then begin writeln('<li>new:',level.tagi.xmlis);end;
end;
//level.ind:=curlineind;
//writeln('<li>got:',curlevel,atag.vari,'/',nextdown,'!');

end;
result:=atag;
end;
}
constructor tjsonstreamer.Create(filee:string;resu,acom:ttag);
begin
//parts:=tstringlist.create;
nextup:=0;nextdown:=0;
nextch:=#0;prevline:='';limitti:=0;
inherited;
writeln('<li>jsonstream created;<ul>');
//readline;
end;
destructor tjsonstreamer.free;
begin
 inherited free;
end;

function tjsonstreamer.getlevel(par:ttag;dto:integer):boolean;
var i,odown:integer;vari,vali:string;atag:ttag;
begin
  //exit;
   odown:=nextdown;
   result:=false;
   //writeln('<li>dodo:',curline,dto,'/',curlineind,'<ul>');
   repeat
    if curlineind+nextdown<dto then break;
    nextdown:=0;
    readline(vari,vali);
    if eof then break;
    //par.vali:=curline;
    //if eof then exit;
    //if curlineind<=dto then  break;
    //cp:=1;
    //writeln('<li>gotsub:',vari,'??',nextdown,'(',curlineind,'/',dto,')');
    //if trim(curline)='' then break;
    //atag:=gettag(nil);
    atag:=ttag.create;atag.vari:=vari;atag.vali:=vali;
    curlineind:=curlineind+nextdown;
    //if atag.vari='lemmacomp' then break;
    if atag<>nil then
    begin
     par.subtags.add(atag);
     atag.parent:=par;
    end;
    //atag.parent:=par;
    if nextdown>0 then
    begin
      //writeln('<li>dolev:',curlineind);
      getlevel(atag,curlineind);
      //writeln('<li>didlev:',curlineind,'/',dto);
    end;
    //nextdown:=0;
    if curlineind<dto then
    begin
      //writeln('<li>end:',curline,curlineind,'/',dto);
      //break;

    end;
   until curlineind<dto ;// (lookingat<2);
   //end;
   prevline:=curline;
   //prevind:=curlineind;
   nextdown:=odown;
   //writeln('</ul><li>diddo:',curline,curlineind,'!',dto);
end;

function tjsonstreamer.next: ttag;
var i,p:integer;varl,vall:string;atag:ttag;
begin
//writeln('<li>gotmore:',curline,'??',curlineind,'/',curlevel);
changedlev:=levels.count;
while not eof do
 begin
  try
  readline(varl,vall);

  //writeln('<li>',varl,'==========',vall);
  if sfile.position>=sfile.size then eof:=true;
  limitti:=limitti+1;
  //if limitti>5000 then begin eof:=true;break;end;
  if eof then break;
   //writeln('<li>try:',curlevel,varl,'=',level.lookingfor,'/<b>',curlineind,'</b>!',nextdown);
   prevline:='';
  // result:=gettag;exit;
  // continue;
   if curlevel<curlineind then begin //we are deeper than what we are looking for
     continue;end else
   if curlevel>curlineind then
   begin
     //writeln('<li>up:');

     curlevel:=curlevel-1;
     level:=levels[curlevel];
     if changedlev>curlevel then changedlev:=curlevel;
   end;
    //handle the tag
  // atag:=gettag(level);
// if varl<>'' then
 if nextdown>0 then if varl='' then varl:='item';
  //if atag<>nil then
 begin
  //writeln('<li>m?',varl,'=',level.lookingfor,'=',_matches(level.lookingfor,varl));
  //writeln('<li>t:',atag.HEAD,'!');
   if _matches(level.lookingfor,varl) then
   begin
     atag:=ttag.create;atag.vari:=varl;atag.vali:=vall;
     if level.tagi<>nil then level.tagi.killtree;
     level.tagi:=atag;
     //writeln('<li>m!',curlevel,'=?',targetdepth-1);
     if curlevel=targetdepth-1 then
     begin
          result:=atag;
          //writeln('<li>sub:',curlevel,curline);
          getlevel(result,curlevel+1);
          //curlineind:=curlineind-1;//+nextdown;
          //writeln('</ul><li>didsub',curlineind);
          exit;
     end else
     begin
         //writeln('<li><b>deeper:</b>',curline,'/lv:',level.dbug);
         curlevel:=curlevel+1;
         level:=levels[curlevel];
      end;
   end;
 end;
  finally
     curlineind:=curlineind+nextdown;
    //if curlevel<levels.count then level:=levels[curlevel];
    nextdown:=0;
    end;

 end;
end;

function tjsonstreamer.ReadLine(var ari,ali:string):boolean;
var //invar,inval:boolean;
   qpas:integer;
  //RawLine: UTF8String;
  ch,prevch: AnsiChar;
begin
 result:=true;

 //writeln('.');
 {
if prevline<>'' then
begin
   curline:=prevline;
   prevline:='';
   curlineind:=prevind;
   result:=true;
   exit;
end;}
limitti:=limitti+1;
//if limitti>200 then begin eof:=true;result:=false;exit;end;
ch := #0;
//curlineind:=0;
curline:='';ari:='';ali:=''; qpas:=0;//invar:=false;inval:=false;
//writeln('<li>',curlineind);
while Sfile.Read(ch,1)=1  do
 begin
  // writeln('|',ch,qpas,'|');
   if (ch='"') and (prevch<>'\') then
     begin qpas:=qpas+1;//if invar then invar:=false else if inval then inval:=false else invar:=true;
      continue;
     end;
    prevch:=ch;
    if qpas=1 then ari:=ari+ch else
    if qpas=3 then ali:=ali+ch else
    case ch of
    '{': begin
      nextdown:=nextdown+1;
      break;
    end;
    '[': begin
      nextdown:=nextdown+1;
      break;
    end;
    ']': begin
      nextdown:=nextdown-1;
      break;
    end;
    '}': begin
      nextdown:=nextdown-1;
      break;
    end;
    ',': begin
      break;
    end
  else curline:=curline+ch;

 end;
   if Sfile.position>=sfile.Size then
    begin
    eof:=true;result:=false;
    exit;
    end;
end;
 prevind:=curlineind;
end;

constructor tstreamlevel.create(leve:integer);
begin
end;
destructor tstreamlevel.free;
begin
  if tagi<>nil then tagi.killtree;
end;
function tstreamlevel.dbug:string;
begin
  result:='<b>'+lookingfor+'</b>/llev:'+inttostr(lev)+'/llind:'+inttostr(ind);
  //if tagi<>nil then writeln('<em >!!!!',tagi.xmlis,'!!!!!</em>');

end;
function tstreamer.createlevels(acom:ttag):tlist;
var steps:tstringlist;
   i:integer;
   alev:tstreamlevel;
begin
  result:=tlist.create;
  steps:=tstringlist.Create;
  targetdepth:=_split(acom.att('path'),'/',steps);
  for i:=0 to targetdepth-1 do
  begin
     try
    alev:=tstreamlevel.create(i);
    alev.lookingfor:=steps[i];
    alev.ind:=-1;
    alev.lev:=i;
    alev.tagi:=nil;
    result.add(alev);except writeln('could no crete level ',i);end;
  end;
end;


function tstreamer.next(lev,ind:integer;res:ttag): ttag;
var i,lim,hitind,curlinepos:integer;vari,toget:string;dbug:boolean;
  otag,subt:ttag;
begin
 dbug:=false;
 lim:=1;
 changedlev:=curlevel;
 result:=nil;
 repeat
   readline;
   if sfile.position>=sfile.size then exit;
   //writeln('<span style="fontsize:0.7;color:red">',curline,'</span>');
   if level.ind=-1 then level.ind:=curlineind;
   lim:=lim+1;
   if lim>100 then begin eof:=true;break;end;
   //writeln('<li>try:',curlineind,curline,'/lev:',level.dbug);
   if curlineind=level.ind then
   begin
     curlinepos:=1;
     vari:=getfirstword(curline, curlinepos);
     //writeln('<li>level::<b>',vari,'=!',level.lookingfor,'!</b>',curlevel,'/',targetdepth,'/i:',curlineind,curline,'/lev:',level.dbug);
     if level.ind=-1 then level.ind:=curlineind;
     if _matches(level.lookingfor,vari) then
     begin
        subt:=gettag(vari,curlinepos);
       if level.tagi<>nil then level.tagi.killtree;
        level.tagi:=subt;
        if curlevel=targetdepth-1 then
        begin
            result:=subt;
            getlevel(result,level.ind);
            exit;
        end else
        begin
           //writeln('<li><b>deeper:</b>',curline,'/lv:',level.dbug);
           curlevel:=curlevel+1;
           level:=levels[curlevel];
        end;
     end else
   end else
   if curlineind>level.ind then
   begin
    skiplevel(level.ind);
   end else
   begin
     //writeln('<li>upper::<b>',curlineind,curline,'=!',level.lookingfor,'!</b>',curlevel,'/',targetdepth,'/lev:',level.dbug);
     if level.tagi<>nil then begin //writeln('<li>kill:',level.tagi.head,'!');
     level.tagi.killtree;
     level.tagi:=nil;
     end;
     curlevel:=curlevel-1;
     changedlev:=min(changedlev,curlevel);
     prevline:=curline;
     level:=levels[curlevel];
   end;
 until eof;
  if dbug then writeln('<li>goingdown:',curline,'-',lev,'-',ind);
  //for i:=0 to resindents.count-1 do writeln('{',integer(resindents[i]),'}');
end;


constructor tstreamer.Create(filee:string;resu,acom:ttag);
var i:integer; // paths:string;
begin
   fname:=filee;
   eof:=false;
  try
  sfile:=tfilestream.create(fname,fmopenread);
  except writeln('<li>could not open ['+fname+']');raise;end;
  try
  eof:=false;
  //levels:=createlevels(acom);
  //level:=levels[1];
  curlevel:=1;
  except writeln('<li>could not create streamer ['+acom.xmlis+']');raise;end;
end;


destructor tstreamer.free;
var i:integer;
begin
{  for i:=levels.count-1 downto 0 do tstreamlevel(levels[i]).free;
  levels.free;
  sfile.free;                   temp out of use

  writeln('<li>fdreed stream');}
end;

procedure skipcomments(var line:string;sfile:tfilestream);
begin
     // to be handled later
end;

function tstreamer.ReadLine:boolean;
var
  RawLine: UTF8String;
  ch: AnsiChar;
begin
if prevline<>'' then
begin
   curline:=prevline;
   prevline:='';
   curlineind:=prevind;
   result:=true;
   exit;
end;
limitti:=limitti+1;
//if limitti=20 then begin eof:=true;exit;end;
result := false;
ch := #0;
curlineind:=0;
curline:='';
while Sfile.Read(ch,1)=1  do
 begin
  if ch<>' ' then break else curlineind:=curlineind+1;

 end;
while ch<>#10 do
  begin
   if ch<>#13 then if ch<>#0 then
   curline := curline+ch;
   if Sfile.Read( ch, 1) <> 1 then
    begin
    eof:=true;
    break;
    end;
end;
 prevind:=curlineind;
end;

function tstreamer.ReadLinejson:boolean;
var
  RawLine: UTF8String;
  ch: AnsiChar;
begin
if prevline<>'' then
begin
   curline:=prevline;
   prevline:='';
   curlineind:=prevind;
   result:=true;
   exit;
end;
limitti:=limitti+1;
//if limitti=20 then begin eof:=true;exit;end;
result := false;
ch := #0;
curlineind:=0;
curline:='';
while Sfile.Read(ch,1)=1  do
 begin
  if ch<>' ' then break else curlineind:=curlineind+1;

 end;
while ch<>#10 do
  begin
   if ch<>#13 then if ch<>#0 then
   curline := curline+ch;
   if Sfile.Read( ch, 1) <> 1 then
    begin
    eof:=true;
    break;
    end;
end;
 prevind:=curlineind;
end;


function _parseatts(tagi: ttag; line: string; var curpos: integer): boolean;
var
  ii, len,thisfar: integer;
  inq, skipwhite: boolean;
  c: char;
  par: string;
begin
  try
    Result := False;
    len := length(line);
    if len<=curpos then exit;
    skipwhite := True;
    thisfar:=curpos+1;
    inq := False;
    ii := curpos;
    repeat
    begin
      ii:=ii+1;
      c := line[ii];
      if skipwhite then
      if pos(whitespace, c) > 0 then
        continue;
      skipwhite := False;
      if inq then  //within quotes
      begin
        if c = '"' then
        begin
          //write('#',ii,'/',len);
          inq := False;
        end
        else
          par := par + c;
      end
      else  //not in quoted
      begin
        if  (ii=len) or ((c = ':') and ((ii = len) or (pos(line[ii + 1], whitespace) > 0))) then
        begin
          //write('***');
          tagi.addatt(par);
          par := '';
          curpos := ii + 1;
          exit;      //no more atts
        end
        else
        if c = ' ' then
        begin
          if trim(par)<>'' then tagi.addatt(par);
          par := '';
          skipwhite := True;
        end
        else
        if c = '"' then
        begin
          inq := True

        end
        else
          par := par + c;
      end; //for-loop
    end;
    until ii>=len;
  except
    writeln('failed parseatts in parseindents');
  end;

end;
function tstreamer.getfirstword(lin: string; var curpos: integer): string;
var
  i, len: integer;
begin
  Result := ''; //lin[curpos-1];//
  len := length(lin);
  for i := curpos to len do
  begin
    if pos(lin[i],' ;,"+#(''''') > 0 then
    begin
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
        curpos := i+1;
        exit;
      end;// else
      result:=result+lin[i];
  end;
  //curpos:=i;

  curpos:=len + 1;
end;
function _gettextval(src: string; var curpos: integer;
var inquotedpar: boolean): string;
var apos:integer;
begin
  apos:=pos('''''''',src);
  if apos<1 then result:=copy(src,curpos+1,length(src)) else
  begin
    result:=copy(src,apos+3,length(src));
    apos:=pos('''''''',result);
    if apos>0 then result:=copy(result,1,apos-2) else
    inquotedpar := True;
  end;
  curpos:=length(src);
end;

function tstreamer.parseline(line:string):ttag;
var cpos:integer;b:boolean;
begin

  result:=ttag.create;
  //strpos:=tstreampos.create;
  //strpos.pos:=sfile.position;
  cpos:=1;
  result.vari:=getfirstword(line,cpos);
  if line[cpos] <> ':' then   _parseatts(result,line,cpos);
  result.vali := _gettextval(line, cpos, b);
end;

procedure tstreamer.skiplevel(dto:integer);
var i,cp:integer;vari:string;atag:ttag;
begin
   repeat
    readline;
     if eof then exit;
    //if curlineind<=dto then break;
   until curlineind<=dto ;// (lookingat<2);
   //end;
   prevline:=curline;
   prevind:=curlineind;
end;
function tstreamer.getlevel(par:ttag;dto:integer):boolean;
var i,cp:integer;vari:string;atag:ttag;
begin
   result:=false;
   repeat
    readline;
    if eof then exit;
    if curlineind<=dto then  break;
    cp:=1;
    atag:=parseline(curline);
    par.subtags.add(atag);
    atag.parent:=par;
    getlevel(atag,curlineind);
   until curlineind<=dto ;// (lookingat<2);
   //end;
   prevline:=curline;
   prevind:=curlineind;
end;

function tstreamer.gettag(vari:string;curlinepos:integer):ttag;
//var strpos:tstreampos;
begin
result:=ttag.create;
result.vari:=vari;
if CURline[curlinepos] <> ':' then   _parseatts(result,curline,curlinepos);
result.vali := _gettextval(CURline, curlinepos, inquotedpar);
end;
 constructor txmlstreamer.Create(filee:string;resu,acom:ttag);
begin
//parts:=tstringlist.create;
nextup:=0;nextdown:=0;
nextch:=#0;prevline:='';limitti:=0;
roottag:=resu;
inherited;
writeln('<li>xmlstream created;<ul>');
intag:=false;//incomment:=false;invali:=false;
//readline;
end;
destructor txmlstreamer.free;
begin
writeln('XXXXXXXXXXXXXXXXXXaXXXXXXXXXXXXXXXXXXXXXX');
 //inherited free;
sfile.free;
writeln('XXXXXXXXXXXXXXXXXXbXXXXXXXXXXXXXXXXXXXXXX');
end;

function txmlstreamer.getlevel(par:ttag;dto:integer):boolean;
var i,odown:integer;line:string;atag:ttag;
begin
  //exit;
   odown:=nextdown;
   result:=false;
   //writeln('<li>dodo:',curline,dto,'/',curlineind,'<ul>');
   repeat
    if curlineind+nextdown<dto then break;
    nextdown:=0;
    readstarttag(line);
    if eof then break;
    if nextdown>0 then
    begin
      //writeln('<li>dolev:',curlineind);
      getlevel(atag,curlineind);
      //writeln('<li>didlev:',curlineind,'/',dto);
    end;
    //nextdown:=0;
    if curlineind<dto then
    begin
      //writeln('<li>end:',curline,curlineind,'/',dto);
      //break;

    end;
   until curlineind<dto ;// (lookingat<2);
   prevline:=curline;
   nextdown:=odown;
   //writeln('</ul><li>diddo:',curline,curlineind,'!',dto);
end;

function txmlstreamer.next(root:ttag): ttag;  //note root<>roottag ... fix this later
var i,p:integer;tagbody,atst:string;atag:ttag;vari,vali:string;posi:integer;
begin
curtag:=root;

//writeln('<li>gotmore:',curline,'??',curlineind,'/',curlevel);
//changedlev:=levels.count;
while not eof do
 begin
  try
  readstarttag(tagbody);
   if intag then //got the prev tags content
    begin
    //write('val:',nextline):
      curtag.vali:=nextline;
    end else if nextline='' then continue else
    begin        p:=prevlevel;
      if curlevel>prevlevel then
      begin //writeln('<ul><li>D:');
        posi:=pos(' ',nextline);
        if posi>0 then
        tagbody:=copy(nextline,1,posi-1) else tagbody:=nextline;
        atag:=curtag.addsubtag(tagbody,'');
        atag.parent:=curtag;
        if posi>0 then _parseatts(atag,nextline+' ',posi);
        //writeln('--<xmp>',root.xmlis,'</xmp>++',curtag.vari,atag.vari);
        curtag:=atag;
       end else
       begin
        //writeln('<hr/>');
       //curtag:=atag;
      while curlevel<p do begin //writeln('</li></ul>');
       p:=p-1;if curtag.parent<>roottag then curtag:=curtag.parent else break;end;
      //writeln('<li>',curtag.vari);
       //write('<b>',curlevel,'/',prevlevel,':',nextline,'</b>');
       //writeln('--<xmp>',root.xmlis,'</xmp>--',curtag.vari);
      end;
     prevlevel:=curlevel;
     //writeln(curtag.vari+'@');
    end;

   result:=curtag;
  exit;

  except writeln('failednext');
  end;
 end;
end;
  //writeln('<li>',varl,'==========',vall);
{  if sfile.position>=sfile.size then eof:=true;
  limitti:=limitti+1;
  //if limitti>5000 then begin eof:=true;break;end;
  if eof then break;
   //writeln('<li>try:',curlevel,varl,'=',level.lookingfor,'/<b>',curlineind,'</b>!',nextdown);
   prevline:='';
  // result:=gettag;exit;
  // continue;
   if curlevel<curlineind then begin //we are deeper than what we are looking for
     continue;end else
   if curlevel>curlineind then
   begin
     //writeln('<li>up:');

     curlevel:=curlevel-1;
     level:=levels[curlevel];
     if changedlev>curlevel then changedlev:=curlevel;
   end;
    //handle the tag
  // atag:=gettag(level);
// if varl<>'' then
 //if nextdown>0 then if nextline='' then varl:='item';
  //if atag<>nil then
 begin
  //writeln('<li>m?',varl,'=',level.lookingfor,'=',_matches(level.lookingfor,varl));
  //writeln('<li>t:',atag.HEAD,'!');
   if _matches(level.lookingfor,varl) then
   begin
     atag:=ttag.create;atag.vari:=varl;atag.vali:=vall;
     if level.tagi<>nil then level.tagi.killtree;
     level.tagi:=atag;
     //writeln('<li>m!',curlevel,'=?',targetdepth-1);
     if curlevel=targetdepth-1 then
     begin
          result:=atag;
          //writeln('<li>sub:',curlevel,curline);
          getlevel(result,curlevel+1);
          //curlineind:=curlineind-1;//+nextdown;
          //writeln('</ul><li>didsub',curlineind);
          exit;
     end else
     begin
         //writeln('<li><b>deeper:</b>',curline,'/lv:',level.dbug);
         curlevel:=curlevel+1;
         level:=levels[curlevel];
      end;
   end;
 end;

 end;
end;
}
function txmlstreamer.Readstarttag(var aline:string):boolean;
var //invar,inval:boolean;
   qpas:integer;
  //RawLine: UTF8String;
  ch: AnsiChar;cou:integer;
begin
 try
 result:=true;
 limitti:=limitti+1;
 //if limitti>200 then begin eof:=true;result:=false;exit;end;
ch := ' ';
cou:=0;
//curlineind:=0;   ;ali:=''; qpas:=0;//invar:=false;inval:=false;
//writeln('<li>readstr',curlineind);
prevline:=nextline;
nextline:='';//ari:=''
while Sfile.Read(ch,1)=1  do
 begin
//m:=lim+1;if lim>1000 then break;
  cou:=cou+1;
  if intag and (cou=1) then
  begin
    if ch='?' then
    begin
     //writeln('xmldeclaration');
     while sfile.read(ch,1)=1 do
     begin
       intag:=false;
       if (ch=lf) or (ch=crr) then exit;
      end;
    end
    else
    if ch='!' then
    begin //writeln('xdoctypedeclaration or comment');
      sfile.read(ch,1);
    if ch='-' then
    begin
     //writeln('comment');
     while sfile.read(ch,1)=1 do
     begin
       if ch='>' then if prevchar='-' then begin intag:=false;exit;end;
       prevchar:=ch;
     end;
    end else
    while sfile.read(ch,1)=1 do
    begin intag:=false;
      if (ch=lf) or (ch=crr) then exit;
     end;


   end;
  end;
  // writeln('|',ch,qpas,'|');
  if ch='>' then
  begin
    if prevchar='/' then curlevel:=curlevel-1;// else curlevel:=curlevel+1;
    //write('T:',nextline,'/',curlevel,prevchar,prevlevel);
    intag:=false;inval:=true;
    prevchar:=ch;
    break;
  end;
  if ch='/' then begin
     if prevchar='<' then begin curlevel:=curlevel-2;end; end else
  if ch='<' then begin //write('!',ord(ch),'!');
    intag:=true; curlevel:=curlevel+1;prevchar:=ch;break;end
  else begin //write('+');
   nextline:=nextline+ch;end;
  //write(ch,'.',ch);
  prevchar:=ch;
 end;
 //prevind:=curlineind;

 except writeln('nogoread');end;
end;





end.


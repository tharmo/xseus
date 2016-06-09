unit xseconv;

{$mode delphi}

interface

uses
  Classes, SysUtils,xsexml,xseglob;
function _listjson(ftag:ttag):ttag;
function _json(src:string;res:ttag):boolean;
function _json2(src:string):ttag;
function _ical(src:string):ttag;
implementation
uses xsemisc,lazutf8;
type tjson=class(tobject)
   //-- added public
public

 src:string;resu:string;
  curpos,stpos,epos,len:integer;
 function getstring:string;
 function steppaa:char;
 function skippaa:char;
 //function getlist(vari:string):ttag;
 function oldgetobjects(basetag:ttag;liststring:string):boolean;
 function getobjectlist(basetag:ttag;defname:string):tlist;
 function getvalue(basetag:ttag;defname:string):ttag;
 function getname:string;
 function getarray(basetag:ttag;defname:string):ttag;
 constructor create(sr:string);
end;
//  function tjson.getlist(vari:string):ttag;
//  begin
//  end;

function tjson.steppaa:char;
begin
 //writeln('<li>/skip:',curpos,'_',copy(src,curpos,10));
 while (curpos<len-1) and (pos(src[curpos],whitespace+',:')>0) do begin writeln('\',src[curpos]);curpos:=curpos+1;end;
 //note: null-values get eaten away
 curpos:=curpos+1;
 result:=src[curpos];
 //writeln('/to:',copy(src,curpos,10));
end;
function tjson.skippaa:char;
begin      //increase curpos until src[curpos]=meaningful char
 while (curpos<len-1) and (pos(src[curpos],whitespace+',:')>0) do curpos:=curpos+1;
 result:=src[curpos];
end;

function tjson.getname:string;
begin
{  steppaa;
  while (curpos<len-1) and (src[curpos]<>'"') do
  begin  //unnecessary
    curpos:=curpos+1;
  end;
  result:=getstring;
end;
}

end;

function tjson.getvalue(basetag:ttag;defname:string):ttag;
var ch:char;aval:string; newtag:ttag;

begin
 try
  //while  (curpos<len) do
  //begin
   aval:='';

    ch:=skippaa;
    //if t_debug then
    //writeln('<li>GETAVAL:'+ch+copy(src,curpos,20)+'<ul>');
    //curpos:=curpos+1;
    if ch='"' then
    begin
     aval:=getstring;
     result:=basetag.addsubtag(defname, aval);
 //    if t_debug then
 //         writeln('<li>stringvalue:'+aval+'/left:'+copy(src,curpos,20)+'<small>'+basetag.xmlis+'</small>');
    end;
    if ch='{' then
    begin
     //if t_debug then
     // writeln('<li>GETsub:'+copy(src,curpos,20)+'</li>');
      steppaa;
      newtag:=basetag.addsubtag(defname,'');
      getobjectlist(newtag,defname);
    end  else
    if ch='[' then
    begin
      steppaa;
      getarray(basetag,defname)
    end
      else
    if ch='}' then
      exit
    else
    begin
     while  (curpos<len-1) and (pos(src[curpos],whitespace+',:')<1) do
     begin
       aval:=aval+src[curpos];
       curpos:=curpos+1;
     end;
     result:=basetag.addsubtag(defname,aval);

     end;
  //end;

 finally
    //writeln('</ul><li>gotval:</li>');
    //writeln('<li>gotvalx:'+basetag.xmlis+'</li>');
 end;
end;

function tjson.getobjectlist(basetag:ttag;defname:string):tlist;
  var ch:char;anam,aval:string;ntag:ttag;
  begin
   skippaa;
   //writeln('<li>objectlist:',curpos,'/',len,'!'+copy(src,curpos,20)+'!<ul>');
    while  (curpos<len-1) do
    begin
     //try   writeln('<li>:xml:',basetag.xmlis);except writeln('<li>brokenxml');end;
      ch:=skippaa;
      if ch='}' then BEGIN curpos:=curpos+1;skippaa;break;end;
      anam:=getstring;
      skippaa;
      //writeln('<li>name:'+anam+'/next:'+copy(src,curpos,20),'</li>');
      ch:=src[curpos];
      //steppaa;
      //skippaa; // jump overcolon
      //if ch=',' then steppaa;
      //writeln('<li>valfor:'+anam+'/next:'+copy(src,curpos,30),'/ch:(',ch,')');
      if ch='"' then
      begin
        aval:=getstring;
       // curpos:=curpos+1;
        basetag.addsubtag(anam,aval);
        skippaa;
        //writeln('--gotstring'+aval+'/next:'+copy(src,curpos,20),'/ch:(',ch,')'+basetag.xmlis);
      end else
      begin
       //writeln('<li>getvalue:'+anam+'--',copy(src,curpos,40),'<ul>');
       getvalue(basetag,anam);
       //writeln('--gotval'+anam+'--</li></ul>');
       //basetag.subtags.add(getvalue(basetag,anam));
      end;
      //writeln('<li>jsonval:',ch,curpos,'/',len,'!'+copy(src,1,curpos)+'?</li>');
      //ch:=steppaa;
      //if ch=',' then curpos:=curpos+1;
    end;
    //writeln('</ul></li><li>/obj:'+anam,curpos,'/',len,'</li>');
    //writeln('<li>tag:',basetag.xmlis,'/tag</li>');
  end;
function tjson.getarray(basetag:ttag;defname:string):ttag;
    var ch:char;anam,aval:string;ntag:ttag;
    begin
     skippaa;
     ntag:=basetag.addsubtag(defname,'');
     DEFNAME:='item';
     //writeln('<li>ARRAY:',curpos,'/',len,'!'+copy(src,curpos,20)+'!<ul>');
      while  (curpos<len-1) do
      begin
       //try   writeln('<li>:xml:',basetag.xmlis);except writeln('<li>brokenxml');end;
        ch:=skippaa;
        if ch=']' then BEGIN curpos:=curpos+1;skippaa;break;end;
        //writeln('<li>valfor:'+anam+'/next:'+copy(src,curpos,30),'/ch:(',ch,')');
        if ch='"' then
        begin
          aval:=getstring;
         // curpos:=curpos+1;
          ntag.addsubtag(defname,aval);
          skippaa;
          //writeln('--gotstring'+aval+'/next:'+copy(src,curpos,20),'/ch:(',ch,')'+basetag.xmlis);
        end else
        begin
        // writeln('<li>XXX:'+defname+'--',copy(src,curpos,40),'<ul>');
         //skippaa;
         t_debug:=true;
         getvalue(ntag,defname);
         //steppaa;
         t_debug:=false;
         //writeln('--nogotval'+anam+'--</li></ul>');
         //basetag.subtags.add(getvalue(basetag,anam));
        end;
        //writeln('<li>jsonval:',ch,curpos,'/',len,'!'+copy(src,1,curpos)+'?</li>');
        //ch:=steppaa;
        //if ch=',' then curpos:=curpos+1;
      end;
      //writeln('</ul></li><li>/obj:'+anam,curpos,'/',len,'</li>');
      //writeln('<li>tag:',basetag.xmlis,'/tag</li>');
    end;


function tjson.getstring:string;
var ch,nch:char;u:cardinal;
begin
 result:='';
 skippaa;
 curpos:=curpos+1;
 repeat
       ch:=src[curpos];
       if ch='"' then begin curpos:=curpos+1;exit;end;
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
           'u': begin
                try
                result:=result+UnicodeToUTF8(strtoint('x'+copy(src,curpos,4)));
                except result:='zz';end;
                curpos:=curpos+4;
           end
           else curpos:=curpos-1;
          end;
       end
       else
       begin
          result:=result+ch;
          curpos:=curpos+1;
       end;
   until curpos>len;

end;

constructor tjson.create(sr:string);
begin
 src:=sr;
 curpos:=1;
 len:=length(src);
end;

function _json(src:string;res:ttag):boolean;
var js:tjson;i,j:integer;basetag:ttag;
begin
  js:=tjson.create(src);
  //writeln('jiisoni:<xmp>'+src+'</xmp>');
  js.skippaa;
  while (js.src[js.curpos]='{') and (js.curpos<js.len) do
   js.curpos:=js.curpos+1;
  //writeln('<li>start at ',js.curpos,copy(js.src,js.curpos,10));
   //basetag:=ttag.create;
   //result:=ttag.create;
   //basetag.vari:='json';
   //result.vari:='json';
   //result.subtags:=
   js.getobjectlist(res,'');
   //writeln('jiisonigot:<xmp>'+result.xmlis+'</xmp><hr/><hr/><hr/>');
  // result:=result.subtags[0];
end;
function _json2(src:string):ttag;
var js:tjson;i,j:integer;basetag:ttag;
begin
  js:=tjson.create(src);
  //writeln('jiisoni:<xmp>'+src+'</xmp>');
  js.skippaa;
  while (js.src[js.curpos]='{') and (js.curpos<js.len) do
   js.curpos:=js.curpos+1;
  //writeln('<li>start at ',js.curpos,copy(js.src,js.curpos,10));
   //basetag:=ttag.create;
   result:=ttag.create;
   //basetag.vari:='json';
   result.vari:='json';
   //result.subtags:=
   js.getobjectlist(result,'');
   //writeln('jiisonigot:<xmp>'+result.xmlis+'</xmp><hr/><hr/><hr/>');
  // result:=result.subtags[0];
end;




function tjson.oldgetobjects(basetag:ttag;liststring:string):boolean;
var ch:char;start,hasvali,hasvari,inlist:boolean;restag:ttag;ast,listvari:string;
begin
try
 try
 //writeln('<li>jsontag:',basetag.head+'/par:',basetag.parent.head+'--------'+src[curpos]+'----',list);
 except
 writeln('<li>jsonstr:',basetag.head);

 end;
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
    oldgetobjects(restag,'');

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
     //getobjects(basetag,restag.vari);
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

end.


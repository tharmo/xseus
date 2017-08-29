unit xsestream; //to replace xsestrm

{$mode delphi}
interface

uses
  Classes, SysUtils,xsemisc,xsexml;
type txstream=class(tobject)
  spath:tstringlist;
  sfile:tfilestream;
  eof:boolean;
  cur_from,cur_to:word;
 //nextup,nextdown:integer;
 nextch, prevchar:char;
 intag,inval,incom:boolean;
 //nextline,prevline:string;
 //roottag,
   curtag,prevtag:ttag;
 function skipdecl:boolean;  //XML skip declarations etc
 function readtextval:boolean;
 function readtaghead(var tag_ended:boolean):boolean;
 function next: ttag;  //note root<>roottag ... fix this later
 function Readattributes:boolean;
 function getlevel(par:ttag;dto:integer):boolean;
 function skiplevel:boolean;
  constructor create(sfilename,pathst:string);
  destructor free;
end;

implementation
constructor txstream.create(sfilename,pathst:string);
begin
  spath:=tstringlist.create;
  _split(pathst,'/',spath);
   eof:=false;
  try
  sfile:=tfilestream.create(sfilename,fmopenread);
  except writeln('<li>could not open ['+sfilename+']');raise;end;
  try
  eof:=false;
  //levels:=createlevels(acom);
  //level:=levels[1];
  cur_to:=1;cur_from:=0;
  skipdecl;
  writeln('<li>created:',sfilename,'//',spath.text,spath.count,prevchar,'!');
  except writeln('<li>could not create streamer ',sfilename,'['+pathst  +']');raise;end;

end;
destructor txstream.free;
begin
 try
 writeln('<li>FREE');
 sfile.free;
 except writeln('failed free sfile')end;
 //spath.clear;
 try
 spath.free;
 except writeln('failed free spath')end;
end;

function txstream.getlevel(par:ttag;dto:integer):boolean;
var i,odown:integer;line:string;atag:ttag;
begin
end;


function txstream.next: ttag;
var i,p:integer;tagbody,atst:string;atag:ttag;vari,vali:string;posi:integer;
  ended:boolean;
begin
 prevtag:=curtag;
 curtag:=ttag.create;
 cur_to:=1;
 i:=0;
 writeln('<li>NEXT:',prevchar, '[',cur_to,cur_from,']@',spath.count,cur_from<>spath.count-1);

 //while cur_from<>spath.count-1 do
 while not eof do //cur_from<>spath.count-1 do
 begin
   //if eof then break;
   //writeln('!',prevchar,'[',cur_to,cur_from,']@',spath.count,cur_from<>spath.count-1);
   i:=i+1;if i>10 then begin writeln('<li>EoF');eof:=true;break;end;
   //if (cur_to=cur_from) and
   //writeln('<li>tonext:',cur_to,'_',cur_from,'|',curtag.vari,'=',spath[cur_to],curtag.vari=spath[cur_to],'/prev:',prevchar);
   if (curtag.vari=spath[cur_to]) then
   if cur_from=spath.count-1 then begin writeln('<li>didhit');result:=curtag;exit;end else cur_to:=cur_to+1;
   if cur_from>=cur_to then skiplevel ;
   curtag.vari:='';cur_from:=cur_from+1;
   writeln('trye:',cur_to,'_',cur_from,'|',curtag.vari,'=',spath[cur_to],curtag.vari=spath[cur_to],'/prev:',prevchar);
   //write('TRY');
   readtaghead(ended);
   writeln('<li>***********got:',cur_to,'_',cur_from,'|',curtag.vari,'=',spath[cur_to],curtag.vari=spath[cur_to],'</li><hr/>');
   //exit;
 end;
 result:=curtag;
 write('HIT:',curtag.xmlis,'|');
 cur_to:=1;
end;

function x(c:char):string;
begin
   if c='<' then result:='&lt;'
   else if  c='>' then result:='&gt;'
   else result:=c;
end;

function txstream.skiplevel:boolean;
var i,p:integer;tagbody,atst:string;atag:ttag;vari,vali:string;posi:integer;
  ended:boolean;
begin
 prevtag:=curtag;
 curtag:=ttag.create;
 i:=0;

 //writeln('<li>SKIPTO:',prevchar, '[',cur_to,cur_from,']@',spath.count,cur_from<>spath.count-1);

 while (cur_from>cur_to) and (not eof) do
  begin
  writeln('<li>SKIPONE:',x(prevchar), '[',cur_to,cur_from,']::');//,spath.count,cur_from<>spath.count-1);
  readtaghead(ended);
  writeln('/SKIPpedONE:',x(prevchar), '[',cur_to,cur_from,']');//,spath.count,cur_from<>spath.count-1);

  end;
 writeln('//SKIPPED:',x(prevchar), '[',cur_to,cur_from,']@',spath.count,cur_from<>spath.count-1);
end;

function txstream.readtaghead(var tag_ended:boolean):boolean;
var ci:integer;
begin
   tag_ended:=false;
   //if sfile.eof
   for ci:=1 to 999 do
   begin
    if sfile.read(prevchar,1)<1 then begin eof:=true;writeln('<li>EOF');exit;end
    else
    begin
      write('*',x(prevchar));
      if prevchar='<' then begin write('!',x(prevchar));exit;end;
      if (ci=1) and (prevchar='/') then
      while true do
      begin //if it is endtag </tag>, skip till ending ">"  ..
        write('_');
        if sfile.read(prevchar,1)<1 then  begin eof:=true;writeln('<li>EOF');exit;end;
      end;
      if prevchar='>' then begin write('|',x(prevchar));cur_from:=cur_from-1;exit;end;
      if pos(prevchar,whitespace+'/>')>1 then break else begin curtag.vari:=curtag.vari+prevchar;end;

    end;
   end;
  //if prevchar=' ' then readattributes;
  if prevchar='/' then tag_ended:=true else
    begin
    //if not readtextval then break;
    readtextval;
    cur_from:=cur_from+1;
    end;

  //eof:=true;
end;
function txstream.readtextval:boolean;
var ci,odown:integer;
begin
 //tag_ended:=false;
 for ci:=1 to 999 do
  if sfile.read(prevchar,1)<1 then begin eof:=true;writeln('<li>EOF');exit;end
  else
  begin
    write('#',prevchar);
    if  (prevchar='<') then  begin  cur_from:=cur_from-1; exit; end
    else if prevchar='<' then
    begin
    break
    end
    else begin
      curtag.vali:=curtag.vali+prevchar;
    end;

  end;
end;

function txstream.Readattributes:boolean;
var //invar,inval:boolean;
   //qpas:integer;
  //RawLine: UTF8String;
  ch: AnsiChar;cou:integer;
begin
end;

{ try
 result:=true;
 ch := ' ';
 cou:=0;
 prevline:=nextline;
 nextline:='';//ari:=''
 while Sfile.Read(ch,1)=1  do
 begin
  cou:=cou+1;
  if ch='>' then
  begin
    if prevchar='/' then curlevel:=curlevel-1;// else curlevel:=curlevel+1;
    intag:=false;inval:=true;
    prevchar:=ch;
    break;
  end;
  if ch='/' then
  begin
     if prevchar='<' then begin curlevel:=curlevel-2;end;
  end else
  if ch='<' then begin //write('!',ord(ch),'!');
    intag:=true; curlevel:=curlevel+1;prevchar:=ch;break;end
  else begin //write('+');
   nextline:=nextline+ch;end;
  prevchar:=ch;
 except writeln('nogoread');end;
end;
}
function txstream.skipdecl:boolean;  //XML skip declarations etc
//var //ch:char;
begin
 while sfile.read(prevchar,1)=1 do
 begin
   writeln('<xmp>C:',prevchar,'!</xmp>');
   if prevchar='<' then
   begin
       if sfile.read(prevchar,1)<>1 then exit;
       writeln('<xmp>T:',prevchar,'!</xmp>');
       if (prevchar='?') or (prevchar='!') then
        begin
         //writeln('xmldeclaration');
          while sfile.read(prevchar,1)=1 do
          begin
             if (prevchar=lf) or (prevchar=crr) then break;  //??
          end;
        end
        else
        begin
          //writeln('""""""');
          sfile.seek(-1,sofromcurrent);
          //if sfile.read(prevchar,1)<>0 then exit else writeln('***<xmp>',prevchar,'</xmp>');
          break;
        end;
        {if prevchar='!' then
        begin //writeln('xdoctypedeclaration or comment');
          sfile.read(prevchar,1);
        if ch='-' then
        begin
         //writeln('comment');
         while sfile.read(prevchar,1)=1 do
         begin
           if ch='>' then if prevchar='-' then begin intag:=false;exit;end;
           prevchar:=ch;
         end;
        end else
        while sfile.read(prevchar,1)=1 do
        begin intag:=false;
          if (prevchar=lf) or (prevchar=crr) then exit;
         end;

        end;}
    end;
 end;
end;

end.


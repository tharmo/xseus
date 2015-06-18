unit xsetrie;

{$mode delphi}

interface

uses  FGL,
inifiles,
  Classes, SysUtils;
const dumpsize=160000;
var trie_debug:boolean;
//type   TIntegerList = specialize TFPGList<Integer>;
type   TIntegerList = TFPGList<Integer>;
  //type stepdump=class(tobject);
  {type
  generic TList<T> = class
    Items: array of T;
    procedure Add(Value: T);
  end;

  Type    generic TMyBaseObjectList<T> = class( specialize TFPGObjectList<T>)
      function FindName(AName: string): Integer;
    end;
}
type tatrie=class(tobject)
  prefix:string;
  subcount,
  factcount:integer;
  totmem:integer;
  morep:pointer;
  subs,facts:tlist;
  next:tatrie;
  ob:integer;
  function gettriemem:integer;
  function findsub:tlist;
  //function add(st:string;var added:integer):tlist;
  function add(st:string;var mems:integer;var wasnew:boolean):integer;
  function addsub(addwhere:integer;st:string;var moremem:integer):integer;
  //function split(matchchars:integer;parent:tatrie;addwhere:integer;st:string):tatrie;
  function list(pre:string;lev:integer):integer;
  constructor create;
  destructor free;
  end;
  function readrdfstream(len:integer):tstringlist;
  function readrdfstream2(len:integer):tstringlist;
procedure testtrie;
procedure copytosfile;

 var trieroot:tatrie;
implementation
constructor tatrie.create;
begin
 subs:=tlist.create;
 factcount:=0;
 totmem:=0;
end;
destructor tatrie.free;
var i:integer;
begin
 for i:=0 to subs.count-1 do
  tatrie(subs[i]).free;
 subs.free;
 factcount:=0;
 totmem:=8;
end;
function tatrie.gettriemem:integer;
var i:integer;
begin
  result:=sizeof(self)+length(prefix);
  for i:=0 to subs.count-1 do
   result:=result+tatrie(subs).totmem;
  for i:=0 to facts.count-1 do
  result:=result+4;
end;

function tatrie.findsub:tlist;
begin

end;
//type compz=(do_here, do_under, do_before, do_after,do_split);

{function tatrie.split(matchchars:integer;parent:tatrie;addwhere:integer;st:string):tatrie;
var newmain,newsub:tatrie;
begin
  if trie_debug then writeln('<li>try split',prefix,matchchars,st,'</li>');
  newmain:=tatrie.create;
  //newmain.subs.add(parent.subs[addwhere]);
  //tatrie(parent.subs[addwhere]).prefix:=copy(st,matchchars,9999);
  newmain.prefix:=copy(st,1,matchchars);
  parent.subs[addwhere]:=newmain;


  newsub:=tatrie.create;
  if st>prefix then
  begin
   newmain.subs.add(newsub);
   newmain.subs.add(self);
  end else
  begin
    newmain.subs.add(self);
   newmain.subs.add(newsub);
  end;
  newmain.subcount:=subcount+2;
  newsub.prefix:=copy(st,matchchars+1,9999);
  newsub.factcount:=newsub.factcount+1;
  prefix:=copy(prefix,matchchars+1,9999);
  if trie_debug then writeln('<li>splat:main:'+newmain.prefix+'/oldsub:'+prefix,'/newsub:',newsub.prefix,'</li>');

end;
}
function comparest(s,p:string;var alls,allp:boolean):integer;
var i:integer;  //ash, as
begin
  result:=0;
   allp:=false;alls:=false;
   for i:=1 to length(p) do
   begin
   if  S[I]<>P[I] then
   begin
     result:=i-1;break;   //
   end;
   if i=length(s) then  alls:=true;
   if i=length(p) then  allp:=true;
   result:=i;
   if allp or alls then exit;
   //writeln('-',i,s[i]+'='+p[i]);
  end;
end;

//function tatrie.add(st:string;var added:integer):tlist;
function tatrie.add(st:string;var mems:integer;var wasnew:boolean):integer;
var i,j:integer;subt,newt:tatrie;addwhere,matchchars,moremem:integer;allp,alls:boolean;
begin
  mems:=0;moremem:=0;
  wasnew:=true;
  result:=0;
  addwhere:=0;
  try
  if trie_debug then writeln('<div>ADDing:'+ST+'/totrie:'+prefix,subs.count,'<ul>');
  for i:=0 to subs.count-1 do
  begin
    subt:=subs[i];
    if st=subt.prefix then
    begin // existed - just add fact .. later
      //writeln('.');
      subt.factcount:=subt.factcount+1;mems:=mems+4;subt.totmem:=subt.totmem+4;totmem:=totmem+4;wasnew:=false;exit;
    end;// else
    addwhere:=i;
    if subt.prefix[1]<st[1] then begin if trie_debug then writeln(i,'goon:'+subt.prefix);continue end else
    //if subt.prefix[1]>st[1] then begin if trie_debug then writeln(i,'break:'+subt.prefix);break end else
    if subt.prefix[1]>st[1] then
    begin
         if trie_debug then writeln(i,'break:'+subt.prefix);
         result:=addsub(i,st,moremem);
         totmem:=totmem+moremem+8;mems:=moremem+8;exit;
    end else
    begin  //partially matching
      if trie_debug then writeln('<li>try:',st,'/',subt.prefix);
      matchchars:=comparest(st,subt.prefix,alls,allp);
      if trie_debug then writeln('/match:',matchchars,'/',allp,alls,prefix,'</li>');
      if allp and not alls then  //keep this one, continue under this
      begin //
          if trie_debug then writeln('<li>addtosub',prefix,'</li>');

        result:=subt.add(copy(st, matchchars+1, 99999),moremem,wasnew);
        subcount:=subcount+result;
          if trie_debug then writeln('<li>addtosub',prefix,'</li>');
        totmem:=totmem+moremem;
        mems:=moremem;
          if trie_debug then writeln('<li>addedtosub',prefix,totmem,'</li>');
        //moremem:=mems+subcount*8;
        exit;
      end;// else if allp and alls has been hanled already in "if st=subt.prefix"
      //so we need a new, shorter tag and swithch it with the current one
      newt:=tatrie.create;
      subs[i]:=newt;  //replaces in current level
      newt.subs.add(subt); //and put old one under it
      newt.prefix:=copy(st,1,matchchars);
      newt.totmem:=subt.totmem+8 ;  //just one pointer added
      subt.totmem:=subt.totmem-(matchchars);
      subt.prefix:=copy(subt.prefix,matchchars+1,99999);
      subcount:=subcount+1;
      //newt.totmem:=newt.totmem+subt.totmem;
      //writeln('totmemof:',prefix,' is ',totmem);
      result:=result+1;
      //totmem:=totmem+8;
      //symems:=mems+8;
      if alls then
      begin
        newt.factcount:=newt.factcount+1;
        newt.totmem:=newt.totmem+4;
        mems:=mems+8+4; //added 1 fact, 1 link, no strings.
        totmem:=totmem+mems;
      end
      else
      begin //add the new node under the branch
          //subt.split(matchchars,self,addwhere,st);
        if trie_debug then writeln('<li>addtonewsubtree',newt.totmem,newt.prefix,'+',moremem);
        if trie_debug then trieroot.list('*',0);
          result:=result+newt.add(copy(st,matchchars+1,99999),moremem,wasnew);
         // moremem:=moremem-4; //the fact prev counted in is counted out
           if trie_debug then writeln('<li>addedtonewsubtree',newt.totmem,newt.prefix,'+',moremem);
          //subcount:=subcount+1;
          //newt.totmem:=newt.totmem+moremem;
          totmem:=totmem+moremem+8;
          mems:=moremem+8;
        //newt.prefix:=st;
        //subs.insert(addwhere,newt);
      end;
      exit;
    end;
  end;
  addsub(subs.count,st,moremem);
  totmem:=totmem+moremem+8; mems:=moremem+8;
  finally
  if trie_debug then writeln('</ul><div>ADDED:'+ST+'/totrie:'+prefix,subs.count,'/mem:',totmem);
  end;
  end;
  //looped over every one, what to do?

function tatrie.addsub(addwhere:integer;st:string;var moremem:integer):integer;
var newt:tatrie;
begin
 try
  if trie_debug then writeln('<li>adding to end:',addwhere,'/mem:',totmem,'</li>');
  newt:=tatrie.create;
  newt.prefix:=st;
  try
  subs.insert(addwhere,newt);
  except writeln('asdfasfassfasdfasdf');end;
  newt.factcount:=1;
  //subt.subcount:=subt.subcount+1;
  subcount:=subcount+1;
  result:=1;
  newt.totmem:=4+length(st);//newt.gettriemem;
  //totmem:=totmem+newt.totmem+8;
  moremem:=newt.totmem;
  finally
  if trie_debug then writeln('NEWSUB:'+ST+'/totrie:'+prefix,subs.count,'/mem:',moremem);
  end;

end;
var totstr,totsublists,totfacts,totobs,totnodes:integer;
function tatrie.list(pre:string;lev:integer):integer;
var i,mem:integer;
begin
 totsublists:=totsublists+subs.count;
 totfacts:=totfacts+factcount;
 totstr:=totstr+length(prefix);
 totnodes:=totnodes+1;
 if factcount>0 then totobs:=totobs+1;
  //writeln('<ul><li>'+prefix, '(',subs.count,') {',factcount,'}<small>'+pre+prefix);
 // writeln('<li>'+prefix, '<em>(',subs.count,'</em>) <em>{',subcount,' }</em> <i>[',factcount,']</i> <b>_',totmem,'_</b><small> '+pre+prefix,'</small>');
  result:=length(prefix)+(4*factcount);
  if subs.count>0 then
  begin
   writeln('<ul>');

    for i:=0 to subs.count-1 do
     begin
        result:=result+8+tatrie(subs[i]).list(pre+prefix,lev+1);
     end;
     //writeln('<div class="mem">',result,' </b> ',result-totmem,'</div>');
     writeln('</ul>');
  end;
  writeln('</li>');


end;


var  trips:tfilestream;
  lengs: array [1..10000] of byte;


procedure testtrie;
var ch:char;line:string;mem:integer;wasnew:boolean;
begin
  trieroot:=tatrie.create;
  trips:=tfilestream.create('/home/t/xseus/www/test.lst',fmopenread);
  while trips.position< trips.size do
  begin
    ch:=char(trips.ReadByte);
    if ch='#' then break;
    if (ch=^M)  or (ch=^J)then
    begin
      trieroot.add(line,mem,wasnew);trieroot.list('',1);
      line:=''; continue;
    end
    else
     line:=line+ch;
   end;
{  trieroot.add('vakkarialku');
  trieroot.add('vakkarialkuasdfgh');
  trieroot.add('vakkarialku');
  trieroot.add('vakkarialkuash');
  trieroot.add('vakkarialku');
  //trieroot.list;
  trieroot.add('vakkarialkuasx');
  //trieroot.list;
  trieroot.add('vakkarialkuash');
  //trieroot.list;
  trieroot.add('vakkarialkuasdfgh');
  //trieroot.list;
  trieroot.add('v');
}  trieroot.list('X:',1);
trips.Free;
trieroot.free;
end;

function readrdfstream(len:integer):tstringlist;
var ch:char;line:string;lines,obs,dups,strdups,bytes:integer;starttime:ttime;wasnew:boolean;
  sub,pred,obj:integer;strs:tstringlist;

begin
  trieroot:=tatrie.create;dups:=0;obs:=0;
  totstr:=0;totsublists:=0;totfacts:=0;
  totobs:=0;totnodes:=0;
  trips:=tfilestream.create('/home/t/xseus/www/instance_types_en.nt',fmopenread);
  strs:=tstringlist.create;
  strs.Sorted:=true;
  strs.duplicates:=dupIgnore;//duperror;
  strs.capacity:=60000;

  writeln('<h1>TRIE</h1>',trips.position, '/',trips.size,'</p>');
  //writeln('<h1>sizes</h1><p>',sizeof(mytrie.subcount), '/',sizeof(mytrie.morep),'</p>');
  //while trips.position<150000000 do //trips.size do
  starttime:=now;
  while trips.position< trips.size-1 do
  begin
      ch:=char(trips.ReadByte);
      if (ch=^M) or (ch='<') or (ch=^J)then begin line:=''; continue;end;
      if (ch='>') then
      begin
       trieroot.add(line,bytes,wasnew);
       if wasnew=true then obs:=obs+1 else dups:=dups+1;
       lines:=lines+1;
       if wasnew then
         strs.add(line);
      //writeln('<xmp>'+line+'</xmp>');
      line:='';
      continue;
      end;
      line:=line+ch;
      {if trips.position mod 2000000=0 then
      begin
        writeln('<li>',round((now-starttime)*86400),'  /',lines,'  /',obs);
        writeln('<li>strings:',obs,'/duplicates:',dups,'</li>');
        try
        writeln(' l/s:',round(lines/((now-starttime)*86400)),' o/s:',round(obs/((now-starttime)*86400)),'  /',round(GetFPCHeapStatus.CurrHeapUsed/1000),'</li>');
        except writeln('-');end;
        starttime:=now;lines:=0;//obs:=0;
      end;}
      if trips.position>len then break;
  end;
//  trieroot.list('',1);
  writeln('<li>DIDIN:',round((now-starttime)*8640000),'  /',lines,'  /',obs);
  //writeln('<h1>did:',totsublists,'/lines:',totfacts,'/strings',totstr,'/obs',totobs,'/nodes:',totnodes,'</h1>');
  writeln('<h1>did /lines:',lines,'/slines:',strs.count,'/obs',obs,'/dups:',dups,'</h1>');
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  trieroot.free;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  strs.clear;strs.free;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  trips.Free;
 end;

procedure copytosfile;
 var ch:char;line:ansistring;hit,lines,obs,dups,bytes:integer;starttime:ttime;wasnew:boolean;
   triple:array[1..3] of integer;trippos:integer;strssort, strsorig:tstringlist;
   newf:tfilestream;
   begin
    starttime:=now;
    lines:=0;
    //    writeln('dofiles');
    trips:=tfilestream.create('/home/t/xseus/www/instance_types_en.nt',fmopenread);
    //writeln('dofiles');
    newf:=tfilestream.create('/home/t/xseus/www/triples.txt',fmcreate);// fmopenwrite  or fmShareDenyNone);
    //writeln('didfiles');exit;
    while trips.position< trips.size-1 do
    begin
        ch:=char(trips.ReadByte);
        if (ch=^M) or (ch=^J)then
        begin
          line:='';
          continue;
        end else
        if (ch='<') then //new fact starting
        begin
         line:=''; continue;
        end else
        if (ch='>') then
        begin
          // try strs.add(line);obs:=obs+1 except  dups:=dups+1;end;
         //if strs.Find(line,hit) then
          newf.writeansistring(line);
          lines:=lines+1;
          line:='';
        end
        else line:=line+ch;
        if trips.position mod 1000000=0 then
        begin
          writeln('<li>',round((now-starttime)*86400),'  /',lines,'  /',newf.size);
          //break;
        end;
    end;
    newf.free;
    trips.free;
    exit;
    newf:=tfilestream.create('/home/t/xseus/www/triples.txt',fmopenread  or fmShareDenyNone);
     while newf.position< newf.size-1 do
      writeln('<li>'+newf.readansistring,'</li>');


 end;
function readrdfstream2(len:integer):tstringlist;
var ch:char;line:string;
   hit,lines,ob,secs,dups,bytes,linestoread:integer;
   starttime,lasttime:tdatetime;
   wasnew:boolean;
   trip:array[1..3] of string;
   strsort, strorig:tstringlist;
   a,itrip:array[1..3] of integer;
   obs:tintegerlist;
  //f1,f2,f3,obid1,obid2,obid3:integer;swap12,swap13,swap23:boolean;
function storeob(ob:ansistring):integer;
var obid,newid:integer;
begin
 obid:=strsort.indexof(ob);
  if obid<0 then
  begin
    result:=strorig.addobject(ob,tintegerlist.create);
    //result:=strorig.add(ob);
    obid:=strsort.addobject(ob,pointer(result));
  end else
  begin
      result:=integer(strsort.objects[obid]);
  end;

end;
var lastline,i,j,k,aob:integer;
begin
  writeln('Heap:',GetFPCHeapStatus.CurrHeapUsed);
  dups:=0;//obs:=0;
  lines:=0;
  totstr:=0;totsublists:=0;totfacts:=0;
  totobs:=0;totnodes:=0;
  //trips:=tfilestream.create('/home/t/xseus/www/instance_types_en.nt',fmopenread);
  trips:=tfilestream.create('/home/t/xseus/www/triples.txt',fmopenread);
  //trips:=tfilestream.create('/home/t/xseus/www/test.txt',fmopenread);
  strSORT:=tstringlist.create;
  strSORT.Sorted:=true;
  //strs.duplicates:=duperror;
  strsort.duplicates:=dupIgnore;
  strsort.casesensitive:=true;
  strsort.ownsobjects:=false;
  strsort.capacity:=1000000;

  strorig:=tstringlist.create;
  strorig.Sorted:=false;
  strorig.ownsobjects:=true;
  //strs.duplicates:=duperror;
  strorig.duplicates:=dupIgnore;
  strorig.casesensitive:=true;
  strorig.capacity:=1000000;
  writeln('<h1>DododOUBLESTRINGLIST',len,'</h1>',trips.position, '/',trips.size,'</p>');
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  starttime:=now;
  //linestoread:=(16*16*16*16*8);
  for i:=1 to len do //2000 do //linestoread do
  begin
      trip[1]:=trips.readansistring;
      trip[2]:=trips.readansistring;
      trip[3]:=trips.readansistring;
     // writeln('<li>',trip[1],'/                  /',trip[2],'/                 /',trip[3],'</li>');
      lines:=lines+1;
      //for j:=1 to 3 do trip[j]:=chr(65+random(20));
      {//strings have to be added biggest (last in alphabet) first
      if trip[1]>trip[2] then begin a[1]:=1;a[2]:=2; end else begin a[1]:=2;a[2]:=1;end;//the first two are in order;
      if trip[3]<trip[a[2]] then a[3]:=3   //the order remained
      else if trip[3]>trip[a[1]] then //3 will go first
      begin
         a[3]:=a[2];a[2]:=a[1];a[1]:=3;
      end else
      begin
        a[3]:=a[2];a[2]:=3;
      end;
     //writeln('<li>',trip[a[1]],'/',trip[a[2]],'/',trip[a[3]],'-',a[1],a[2],a[3],'</li>');
     //if i>20 then break;
     for j:=1 to 3 do
         itrip[a[j]]:=storeob(trip[a[j]]);
     }
     for j:=1 to 3 do
         itrip[j]:=storeob(trip[j]);
     for j:=1 to 3 do
       for k:=1 to 3 do
        begin
         tintegerlist(strorig.objects[itrip[j]]).add(itrip[k]);
        end;

      //triple[trippos]:=hit;

      if trips.position >= trips.size then begin writeln('<h1>allread</h1>');break;end;//mod 2000000=0 then
      if lines mod 100000=0 then
      begin
       secs:=round(86400*(now-lasttime));
       writeln('<li>Triples:',lines,'/', lines-lastline,'/obs:',strsort.count,'/bytes:',trips.position,'/s:',secs,'/tri/s:',round((lines-lastline)/secs),'</li>');
       lasttime:=now;lastline:=lines;
      end;
      {begin
        writeln('<li>',round((now-starttime)*86400),'  /',lines,'  /',obs);
        writeln('<li>strings:',obs,'/duplicates:',dups,'</li>');
        try
        writeln(' l/s:',round(lines/((now-starttime)*86400)),' o/s:',round(obs/((now-starttime)*86400)),'  /',round(GetFPCHeapStatus.CurrHeapUsed/1000),'</li>');
        except writeln('-');end;
        starttime:=now;lines:=0;//obs:=0;
      end;}
      //if trips.position>len then break;
  end;

  writeln('<h3>DIDIN:',round((now-starttime)*8640000),'  /',lines,'  /obs',strorig.Count,'  /obs',strsort.count,'</h3>');
 //writeln('<li>strings:',obs,'/duplicates:',dups,'/count:',strsort.count,'/size:',length(strssort.text),'</li>');
  //result:=strsort;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  writeln('<ul>');

{  for i:=1 to 20 do
  begin
     line:=strsort[i];
     writeln('<li>',i, line,'</li>');
     ob:=integer(strsort.objects[i]);
     obs:=tintegerlist(strorig.objects[ob]);
     writeln('<li>', ob,strorig[ob],obs.count,'<ul>');
     for j:=0 to obs.count-1 do
     begin
         aob:=integer(obs[j]);
         writeln('<li>',aob, strorig[aob],'</li>');
     end;
     //writeln('</ul></li>');

   end;
 }
  writeln('<h3>DIDIN:',round((now-starttime)*8640000),'  /',lines,'  /obs',strorig.Count,'  /obs',strsort.count,'</h3>');

  //strsort.clear;
  //strorig.clear;
  strsort.free;
  strorig.free;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  //writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  //writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);

  trips.Free;
 end;
function readrdfstreamhash(len:integer):tstringlist;
var ch:char;line:string;hit,lines,obs,dups,bytes:integer;starttime:ttime;wasnew:boolean;
  triple:array[1..3] of integer;trippos:integer;strs:thashedstringlist;
begin
  dups:=0;obs:=0;
  totstr:=0;totsublists:=0;totfacts:=0;
  totobs:=0;totnodes:=0;
  trips:=tfilestream.create('/home/t/xseus/www/instance_types_en.nt',fmopenread);
  strs:=thashedstringlist.create;
  strs.Sorted:=false;
  //strs.duplicates:=duperror;
  strs.duplicates:=dupIgnore;
  strs.casesensitive:=true;
  strs.capacity:=64000;
  writeln('<h1>HASHEDSTRINGLIST</h1>',trips.position, '/',trips.size,'</p>');
  starttime:=now;
  while trips.position< trips.size-1 do
  begin
      ch:=char(trips.ReadByte);
      if (ch=^M) or (ch=^J)then
      begin
        trippos:=0;
        line:='';
        continue;
      end else
      if (ch='<') then //new fact starting
      begin
       trippos:=trippos+1;
       line:=''; continue;
      end;
      if (ch='>') then
      begin
        // try strs.add(line);obs:=obs+1 except  dups:=dups+1;end;
       //if strs.Find(line,hit) then
       hit:=strs.indexof(line);
       if hit>-1 then
       begin
        dups:=dups+1;
        end else
        begin hit:=strs.add(line);obs:=obs+1;
        end;
        triple[trippos]:=hit;
        lines:=lines+1;
        line:='';
        if trippos=3 then

        continue;
      end;
      line:=line+ch;
      {if trips.position mod 2000000=0 then
      begin
        writeln('<li>',round((now-starttime)*86400),'  /',lines,'  /',obs);
        writeln('<li>strings:',obs,'/duplicates:',dups,'</li>');
        try
        writeln(' l/s:',round(lines/((now-starttime)*86400)),' o/s:',round(obs/((now-starttime)*86400)),'  /',round(GetFPCHeapStatus.CurrHeapUsed/1000),'</li>');
        except writeln('-');end;
        starttime:=now;lines:=0;//obs:=0;
      end;}
      if trips.position>len then break;
  end;
  writeln('<h3>DIDIN:',round((now-starttime)*8640000),'  /',lines,'  /',obs,'</h3>');
  writeln('<li>strings:',obs,'/duplicates:',dups,'/count:',strs.count,'/size:',length(strs.text),'</li>');
  result:=strs;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  strs.clear;
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  strs.free;
  //writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  writeln('heap:',GetFPCHeapStatus.CurrHeapUsed);
  trips.Free;
 end;
end.


<html><head><title>esimerkkitrie</title>
<style type="text/css">
ul li ul li{display:none}
ul li:hover ul {display:block}
ul:hover li:hover ul li ul li{display:none}

</style>
</head>
<ul>

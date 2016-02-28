unit xsedif;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses xsexml,classes, math, sysutils;

var ents:boolean;

 function dodif(f1,f2:string):tstringlist;
 function dochardif(f1,f2:string):tstringlist;

type tdifentry=class(tobject)
 del:boolean;
 sta,len,st2,chars:integer;
 function write:string;
end;

function xdiff(words1,words2:tstringlist;seqlist:tlist):string;
procedure _cuttolist(st:string;stl:tstringlist;ch:char);
function xmldiff(axml,bxml:ttag):ttag;
var dlist:tlist;

implementation

type ttagindex = class(tobject)
 tags:tstringlist;
 function find(tagst:string):ttag;
 procedure add(tagi:ttag);
 constructor create(tagi:ttag);
 end;
function ttagindex.find(tagst:string):ttag;
begin
end;
procedure ttagindex.add(tagi:ttag);
var i:integer;
begin
  tags.addobject(tagi.vari,tagi);
  for i:=0 to tagi.subtags.count-1 do
    add(tagi);
end;
constructor ttagindex.create(tagi:ttag);
var i:integer;
begin
  tags:=tstringlist.create; //make this hashed later on
  tags.addobject(tagi.vari,tagi);
end;

function xmldiff(axml,bxml:ttag):ttag;
var tia,tib:ttagindex;
begin
 result:=ttag.create;
 tia:=ttagindex.create(axml);
 tib:=ttagindex.create(bxml);
end;



function tdifentry.write;
begin
 if del then result:='D:' else result:='I:';
 result:=result+inttostr(sta)+' 2:'+inttostr(st2)+' LEN:'+inttostr(len)+' chars:'+inttostr(chars);
end;


procedure _cuttolist(st:string;stl:tstringlist;ch:char);
var st2:string;i,j:integer;

 begin
   i:=0;
   while i<length(st) do
   begin
       i:=i+1;
       if pos(st[i],' .,!?=')>0 then
       begin
          stl.add((st2)+st[i]);
           st2:='';
       end else
        if (st[i]=^M )  then continue;
        if (st[i]=^J) then
       begin
           //stl.add((st2)+^M^J);
           stl.add((st2)+^J);
           //i:=i+1;
         st2:='';
       end
       else
       begin
        st2:=st2+st[i];
     end;
   end;
   if length(st2)>0 then stl.add(st2);
 end;
procedure _cuttochars(st:string;stl:tstringlist;ch:char);
var st2:string;i,j:integer;

 begin
   i:=0;
   while i<length(st) do
   begin
       i:=i+1;
       stl.add(st[i]);
   end;
 end;

function _br(st:string):string;
begin
  result:=StringReplace(st,'>','&gt;',[rfreplaceall]);
  result:=StringReplace(result,'<','&lt;',[rfreplaceall]);
end;

function _ents(st:string):string;
begin
  result:=StringReplace(st,'&gt;','>',[rfreplaceall]);
  result:=StringReplace(result,'&lt;','<',[rfreplaceall]);
  end;

function _gettext(d:tdifentry;sta:integer;words:tstringlist;cla:string):string;
var j:integer;
begin
    result:='';
     j:=sta;
     while (j<sta+d.len) and (j<words.count) do
     begin
       if ents then
      begin
       result:=result+_ents(words[j])
      end
      else result:=result+_br(words[j]);
      j:=j+1;
     end;
end;
FUNCTION showhtml(words1,words2:tstringlist):string;
var i,j,k:integer;d:tdifentry;
begin
  IF PARAMSTR(5)='-e' then ENTS:=TRUE;
  k:=0;i:=0;
k:=0;
  while k<dlist.count do
  begin
  try
    d:=tdifentry(dlist[k]);k:=k+1;
    if i<d.sta then
    begin
      while i<d.sta do
      begin
        if ents then result:=result+_ents(words1[i])
        else result:=result+_br(words1[i]);
        i:=i+1;
      end;
    end;
    if d.del then
    begin
    result:=result+('<del>');
      result:=result+_gettext(d,d.st2,words2,'del')+'</del>';
    end
    else
    if d.len>0 then
    begin
     result:=result+('<ins>');
      result:=result+_gettext(d,d.sta,words1,'ins'); i:=i+d.len;
     result:=result+('</ins>');
    end;
    if k>=dlist.count then
     for j:=i to words1.count-1 do    result:=result+_br(words1[j]);
   except writeln('FAIL');end;
 end;
end;

procedure getsecs(words1,words2:tstringlist;seqlist:tlist);
var i,j,k,longest,longpos,charsx,OLDJ:integer;
procedure _newseq(len,alku1,alku2,chrs:integer);
var nseq:tdifentry;
begin
  nseq:=tdifentry.create;
  seqlist.add(nseq);
  nseq.len:=len;
  nseq.sta:=alku1;
  nseq.st2:=alku2;
  nseq.chars:=chrs;
end;

begin
  i:=0;j:=0;
  while i<words1.count do            //for each word in w1
  begin
      longest:=-1;
      longpos:=-1;
      oldj:=j;
    j:=0;
    repeat                           //find the longest matching sequence  in w2
    if words1[i]=words2[j] then        //why only the longest?
    begin
        k:=0;charsx:=0;
        while words1[i+k]=words2[j+k] do
        begin
          charsx:=charsx+length(words1[i+k])+length(words2[j+k]);
          k:=k+1;
          if i+k>=words1.count then break;
          if j+k>=words2.count then break;
        end;
        if k>longest then
        begin
         longest:=k;
         longpos:=j;
        end;
    end;j:=j+1;
    until (j>=words2.count);
    if longest<1 then
    begin
     i:=i+1;
    end else
    begin
         _newseq(longest,i,longpos,charsx);
         i:=i+longest;
         longest:=-1;
    end;
  end;
  _newseq(1,words1.count,words2.count,0);
end;


function xdiff(words1,words2:tstringlist;seqlist:tlist):string;
 var diflist:tstringlist;d:tdifentry;
 i,j,k,l,olddif,
  chars,w1pos,w2pos,pena,lastjump
 :integer;
 nseq,pseq:tdifentry;
begin
try
 dlist:=tlist.create;
  result:='';
  diflist:=tstringlist.create;
  i:=0;lastjump:=0;
  w1pos:=0;w2pos:=0;
  FOR i:=0 TO seqlist.COUNT-1 DO
  begin
    nseq:=seqlist[i];
    if (nseq.st2+lastjump<w2pos)
    or (nseq.st2+nseq.len<=w2pos)
    then begin    //the present result has went past the
        continue;
    end;
    pena:=0;
    try
    for k:=i+1 to min(i+40, seqlist.count-1) do
    begin
     if tdifentry(seqlist[k]).st2<=nseq.st2 then
       //some following sequence starting before  the one inspected (in w2)
      if tdifentry(seqlist[k]).st2+tdifentry(seqlist[k]).len>=w2pos then
       //and  ending after ?
       pena:=pena+tdifentry(seqlist[k]).len;
    end;
    except writeln('******************************************');end;
    if (pena> nseq.len) then continue;

    if (nseq.st2>w2pos) then
    begin  //something was deemed to be deleted in w2
          d:=tdifentry.create;d.st2:=w2pos;d.sta:=w1pos;d.del:=true;d.len:=nseq.st2-w2pos;
          dlist.add(d);
          lastjump:=nseq.len;
    end;
    d:=tdifentry.create;d.sta:=w1pos;d.st2:=nseq.st2;d.del:=false;d.len:=nseq.sta-w1pos;
    dlist.add(d);
    w1pos:=nseq.sta+nseq.len;
    w2pos:=nseq.st2+nseq.len;
  end;
 result:=(showhtml(words1,words2));
 EXCEPT END;
END;

function dodif(f1,f2:string):tstringlist;
var words1,words2:tstringlist;
 i,ii:integer;
 apust,apust2,apust3:string;d:tdifentry;di:integer;seqlist:tlist;
 begin
   words1:=tstringlist.create;
   words2:=tstringlist.create;
  _cuttolist(f1,words1,' ');
  _cuttolist(f2,words2,' ');
  result:=tstringlist.create;
  seqlist:=tlist.create;
  getsecs(words1,words2,seqlist);
  result.text:=xdiff(words1,words2,seqlist);
end;
function dochardif(f1,f2:string):tstringlist;
var words1,words2:tstringlist;
 i,ii:integer;
 apust,apust2,apust3:string;d:tdifentry;di:integer;seqlist:tlist;
 begin
   words1:=tstringlist.create;
   words2:=tstringlist.create;
  _cuttochars(f1,words1,' ');
  _cuttochars(f2,words2,' ');
   result:=tstringlist.create;
  seqlist:=tlist.create;
  getsecs(words1,words2,seqlist);
  result.text:=xdiff(words1,words2,seqlist);
end;

end.




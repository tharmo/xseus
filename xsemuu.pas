unit xsemuu;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  //LCLIntf, LCLType, LMessages,
{$ENDIF}
//  Messages,
SysUtils, Classes;
const
   crlf=^M^J;
    isost=32000;

type toptions=class(tobject)
 heads,dohtml,domail,dourls,doat,doh,dop,docol,dotabs,dolist,
 dots,doexl,empties:boolean;
 h1,h2,h3:string;
 dotalk, talkp,talkh,talkq,talktabs,talkex:boolean;
 accepthtml:boolean;hlev:integer;
 infilename,outfilename,headerfilename,soundfile:string;
    procedure getparams;

end;

type tconverter=class(tobject)
 inst,outst:tstringlist;
 op:toptions;       _debug:boolean;
 paraelems,inlineelems:string;
 constructor create;
 destructor xfree;
    procedure makehtml;
    procedure makethl;
    procedure makethm;
    procedure readinput;
    procedure writeoutput;
    private
    function anchor(st: string): string;
    function closeopens(atag: string;openin,openpar:tstringlist;stop:boolean;keepopen:boolean): string;
    function tagsclose(wtag, atag: string;openin,openpar:tstringlist;keepopen:boolean): string;
end;


implementation


function _randomstring:string;
var i:integer;
begin
 result:='';
 for i:=0 to 8 do
 begin
  result:=result+copy(
'0123456789abcdefghijklmnopqrstuvxyz',random(36),1);
end;

end;
procedure _split(st,sep:string;stl:tstringlist);
  var posi:integer;done:boolean;
  begin
    done:=false;
     repeat
      posi:=pos(sep,st);
      if posi=0 then begin done:=true;posi:=length(st)+1;end;
      stl.add(copy(st,1,posi-1));
      st:=copy(st,posi+length(sep),length(st));
    until done;
end;

procedure gsub(what,towhat:string;var inwhat:string);
var i,j:integer;res:string;
begin
 i:=1;res:='';
 while i<=length(inwhat) do
  if pos(what,copy(inwhat,i,999999))=1 then
   begin res:=res+towhat;i:=i+length(what);end
  else
   begin res:=res+inwhat[i];i:=i+1;end;
 inwhat:=res;
end;
procedure sub(what,towhat:string;var inwhat:string);
var i,j,hpt:integer;res:string;
begin
  hpt:=pos(what,inwhat);
  if hpt=0 then exit
  else
  inwhat:=copy(inwhat,1,hpt-1)+towhat+copy(inwhat,hpt+length(what),length(inwhat));
end;
var xtag:integer;




function cut_li(s:string):integer;
var apus:string;i,apui:integer;
begin
    apui:= pos('=',s);
    if apui>1 then
    begin
     apus:=copy(s,1,apui-1);
     result:=strtointdef(apus,0);
    end
    else
    begin
     apus:='';
     for i:=1 to length(s) do
     begin
       if (strscan('0123456789', s[i])=nil) then
       begin
        if apus='' then continue else break;
       end
       else
         apus:=apus+s[i];
     end;
     result:=strtointdef(apus,0);
    end;

end;

function cut_rs(s:string):string;
var apui:integer;
begin
    apui:= pos('=',s);
    if apui>1 then result:=copy(s,apui+1,length(s)) else result:='';
    result:=trim(result);
    gsub('"','',result);
end;

function cut_ri(s:string):integer;
var apus:string;i,apui:integer;
  begin
    apui:= pos('=',s);
    if apui>1 then apus:=copy(s,apui+1,8) else apus:='';
    for i:=1 to length(apus) do
    if (strscan('0123456789', apus[i])=nil) then break;
    result:=strtointdef(copy(apus,1,i-1),0);
end;

function cut_ls(s:string):string;
var apus:string;apui:integer;
begin
    apui:= pos('=',s);
    if apui>1 then result:=copy(s,1,apui-1) else result:=s;
end;


function tconverter.anchor(st:string):string;
var alku,loppu,i,j,tagend,oldtag:integer;
 urli,loput:string;
 sulku:char;
begin
  if pos('href=',lowercase(st))>0 then
  begin
   result:=st;
   exit;
  end;
  oldtag:=xtag;
  try
  result:='';
  loput:=st;
  alku:=1;
  while alku>0 do
  begin
    if xtag>0 then xtag:=1
    else xtag:=pos('<a ',lowercase(loput)+' ');
    if xtag>0 then
    begin
      tagend:=pos('</a',lowercase(loput));
      if _debug then
      writeln('anch:<xmp>'+st+'</xmp>');

      if tagend=0 then tagend:=isost else xtag:=0;
      result:=result+copy(loput,1,tagend+3);
      loput:=copy(loput, tagend+4,isost);
    end;
    alku:=pos('http:',lowercase(loput));
    if alku<1 then
    begin
      result:=result+loput;exit;
    end;

    loppu:=length(loput)+1;
    for i:=alku to length(loput) do
    if pos(loput[i],' )],')>0 then
    begin
      loppu:=i;
      break;
    end;
    urli:=copy(loput,alku,loppu-alku);
   result:=result+copy(loput,1,alku-1)
     +'<a href="'+urli+'">'+trim(urli)+'</a>';loput:=copy(loput,loppu,isost)
   end;
   xtag:=oldtag;
  finally if op.domail then xtag:=oldtag;end;
end;

function mailto(st:string):string;
var alku,loppu,i,j,tagend:integer;
 urli,loput:string;
 sulku:char;
 ismail:boolean;
begin
     loppu:=length(st);alku:=0;
    for i:=pos('@',st) downto 1 do
     if pos(st[i],' ()<>{}/\:,;')>0 then
     begin
       alku:=i;
       break;
     end;
    ismail:=false;
    for i:=pos('@',st) to length(st) do
     if pos(st[i],' ()<>{}/\:,;')>0 then
     begin
       loppu:=i-1;
       break;
     end else
           if st[i]='.' then ismail:=true;
    if ismail then
    result:=copy(st,1,alku)
    +'<a href="mailto:'
    +copy(st,alku+1,loppu-alku)
    +'">'
    +copy(st,alku+1,loppu-alku)
    +'</a>'
    +copy(st,loppu+1,length(st))
    else result:=st;
    end;


constructor tconverter.create;
begin
 //inst:=tstringlist.create;
 outst:=tstringlist.create;
 paraelems:=',div,close,p,P,h1,h2,h3,h4,h5,h6,h7,blockquote,table,ul,ol,dl,pre,';
 inlineelems:='span,strong,code,br,BR,img,em,b,i,a,strike,font,li,tr,td,dd,dt,th,dl,q,del,tt,ins';
 op:=toptions.create;
end;

destructor tconverter.xfree;
 procedure rid(sl:tstringlist);
 begin
   if sl<>nil then
  begin
    sl.clear;
    sl.free;
   end;
  end;
begin
 inst.Free;
 outst.Free;

// rid(inst);
// rid(outst);
 op.free;
end;

function tconverter.closeopens(atag:string;openin,openpar:tstringlist;stop:boolean;keepopen:boolean):string;
var i:integer;begin
  atag:=ansilowercase(atag);
  result:='';
for i:=0 to openin.count-1 do
   begin
     result:=result+'</'+openin[i]+'>';end;
    openin.clear;
    while openpar.count>0 do
    begin
      if (atag='div') or (openpar[openpar.count-1]='div') then
      if (atag<>'div') or (openpar[openpar.count-1]<>'div') then
      begin
        break;
      end;
      result:=result+'</'+openpar[openpar.count-1]+'>'+crlf;
      openpar.delete(openpar.count-1);
    end;

end;


function tconverter.tagsclose(wtag,atag:string;openin,openpar:tstringlist;keepopen:boolean):string;

var i,j,ind:integer;stop:boolean;
apar,ainl:boolean;st:string;
begin
 result:='';
 if wtag='' then exit;
 stop:=false;

 if pos('/',atag)=1 then
 begin
     delete(atag,1,1);
     stop:=true;
     end;
 ainl:=pos(','+atag+',', inlineelems)>0;
 apar:=pos(','+atag+',', paraelems)>0;

 if ainl then
     begin
        ind:= openin.IndexOf(atag);
        if ind>=0 then
        for j:=ind downto 0 do
        begin
          st:=openin[j];
          result:=result+'</'+st+'>';
          openin.delete(j);
          if st=atag then break;
        end;
        if not stop then
         if keepopen then
         openin.add(atag);
         end;
  if apar then
  begin
    result:=closeopens(atag,openin,openpar,stop,keepopen);
    if keepopen then if not stop then
    begin
      openpar.add(atag);
    end;
  end;

 if atag<>'close' then
 if not (stop) then
 if apar then result:=result+crlf+'<'+wtag+'>'
 else
  result:=result+'<'+wtag+'>';

 ;end;


function _numlevels(st:string):integer;
var i,len,levs:integer;hit:boolean;
begin
  levs:=0;
  len:=length(st);
  for i:=1 to len do
  begin
   if st[i]='.' then
   begin
    levs:=levs+1;
    hit:=true;
     continue;
   end;
   if pos(st[i],'0123456789')>0 then
   continue;
   if (hit) then if st[i-1]<>'.' then levs:=levs+1;
   break;
  end;
  result:=levs;
  end;

procedure tconverter.makehtml;
var intable,inlist,inl,inp,emptyl,wrap:boolean;
cline,clinetrim,lastline,st,title,beg,mid,en,h1,h2,h3,apust:string;
 i,j,empties,nocr:integer;open,ekaots,still:boolean;
 openin,openpar:tstringlist;ch:char;inpre:boolean;
procedure _outall;
 procedure _o(tag:string);
 begin
  exit;
      outst.add('</'+tag+' ended="true">');
      end;
begin
empties:=1;
inp:=false;
 inl:=false;
 inlist:=false;
 intable:=false;
 emptyl:=false;

end;


procedure _inlinelink(var cline:string);
var apust:string;i,j,k,l:integer;ubeg,uend,abeg,aend:integer;
  done:boolean;quot:boolean;
  begin
  try
   ubeg:=0;uend:=0;aend:=0;
   quot:=false;
   abeg:=0;
    done:=false;
    while not done do
    begin
      try
       l:=length(cline);
       for i:=l downto 1 do
       if cline[i]='}' then
       begin
         uend:=i;
         quot:=false;
         break;
       end;
       if uend<2 then exit;
       ubeg:=0;
       for i:=uend downto 1 do
       if cline[i]='{' then
       begin
         ubeg:=i+1;
         if (i>1) and (cline[i-1]='''') then quot:=true;
         break;
       end;
       if ubeg<=2 then exit;
        aend:=ubeg-2;
       if cline[aend]=' ' then exit;
      except
      writeln(ubeg,'anchor fail',aend);
      end;
       for i:=aend-1 downto 1 do
       if ((not quot) and (cline[i]=' ')) or
       (quot) and (cline[i]='''')
        then
       begin
           abeg:=i;
           break;
       end;
        if (not quot) then
       cline:=copy(cline,1,abeg)+'<a href="'+copy(cline,ubeg,uend-ubeg)+'">'
       +copy(cline,abeg+1,aend-abeg)+'</a>'+copy(cline,uend+1,length(cline))
      else
       cline:=copy(cline,1,abeg-1)+'<a href="'+copy(cline,ubeg,uend-ubeg)+'">'
       +copy(cline,abeg+1,aend-abeg-1)+'</a>'+copy(cline,uend+1,length(cline));
    end;
    finally
     end;
  end;

procedure _inline(ch1,ch2,tagi:string;var cline:string);
var apust:string;
begin
   while
   (pos(ch1,cline)>0) do
   begin
     apust:= copy(cline,pos(ch1,cline)+length(ch1),length(cline));
     if pos(ch2,apust)>0  then
     begin
       cline:=copy(cline,1,pos(ch1,cline)-1)
       +'<'+tagi+'>'
       +copy(apust,1,pos(ch2,apust)-1)
       +'</'+tagi+'>'
       +copy(apust,pos(ch2,apust)+length(ch2),length(apust));
     end else break;
    end;
end;

procedure _inlinenew(ch1,ch2,tagi:string;var cline:string);
var apust:string;i,len:integer;
begin
   len:=length(cline);
   if
   (pos(ch1,cline)>0) then
   begin
     for i:=len downto 1 do
     apust:= copy(cline,pos(ch1,cline)+length(ch1),length(cline));
     if pos(ch2,apust)>0  then
     begin
       cline:=copy(cline,1,pos(ch1,cline)-1)
       +'<'+tagi+'>'
       +copy(apust,1,pos(ch2,apust)-1)
       +'</'+tagi+'>'
       +copy(apust,pos(ch2,apust)+length(ch2),length(apust));
     end;end;
end;


begin
 h1:=op.h1;
 h2:=op.h2;
 h3:=op.h3;
 openin:=tstringlist.create;
 openpar:=tstringlist.create;
 intable:=false;inlist:=false;emptyl:=false;ekaots:=false;
 inpre:=false;
 i:=-1;
emptyl:=true;
 nocr:=0;
 if inst.count>0 then
 while i<inst.count-1 do
 begin
   still:=true;
   if i>0 then lastline:=inst[i];i:=i+1;
   cline:=inst[i];
   clinetrim:=trim(cline);
   if inpre then
   begin
      if pos('</pre', lowercase(cline))=1 then
      inpre:=false;
      if pos('<', cline)=1 then
       begin
       try
        outst[outst.count-1]:=outst[outst.count-1]+cline+inst[i+1];
        i:=i+1;
        except outst.add(cline);end;
       end
      else outst.add(cline);
      continue;
     end;
     if pos('<pre', lowercase(cline))=1 then
     begin
      inpre:=true;
      outst.add(cline);
      continue;
     end;
   if title='' then title:=trim(cline);
   if trim(cline)='' then
   begin
    emptyl:=true;
    empties:=empties+1;
    continue;
   end;
   if op.accepthtml  and (pos('<',cline)>0) then
   begin
   try
     begin
       st:=copy(cline, pos('<',cline)+1,length(cline));
       beg:=copy(cline,1,pos('<',cline)-1);
       en:=copy(st,pos('>',st)+1,length(cline));
       st:=copy(st,1,pos('>',st)-1);
       mid:=st;
       if pos(' ',st)>0 then
        st:=copy(st,1,pos( ' ',st)-1);
       if (mid<>'') and (mid[length(mid)]='/') then
       apust:=tagsclose(mid,st,openin,openpar,false)
       else
        apust:=tagsclose(mid,st,openin,openpar,true);
        cline:=beg+apust+en;
        emptyl:=false;
       if pos('ul',lowercase(st))=1 then inlist:=true;
       still:=false;
       nocr:=2;
    end;
    except writeln('failed to handle html-tag');end;
   end;
  if pos('?', cline)=1 then
 begin
   outst.add('<q>'+trim(copy(cline,2,length(cline)))+'</q>');
   continue;
 end;
   if pos('(--',cline)>0 then
   begin
      cline:='';
      outst.add(tagsclose('div class="group"','div',openin,openpar,false));continue;
   end;
   if pos('--)',cline)=1 then
   begin
      cline:='';
       outst.add(tagsclose('/div','div',openin,openpar,false));continue;
   end;


   if pos('* ',cline)<>1 then _inline('*','*','strong',cline);
   _inline('¤','¤','em',cline);
   if pos('<!--sound',cline)=1 then
   begin
     op.soundfile:=cut_rs(cline);
     op.soundfile:=trim(copy(op.soundfile,1,pos('--',op.soundfile)-1));
     still:=false;
     outst.add(cline);
     cline:='';
     end;

   if op.doexl then
   if pos('!!!',cline)>0 then
      gsub('!!!','<span/>',cline);
   if op.soundfile<>'' then
   if pos('**',cline)=1 then
   begin
      st:=trim(copy(cline,pos('**',cline)+2,length(cline)));
      _outall;
      cline:='<p><a href="'+op.soundfile+'?start='+st+'">Kuuntele</a><p>';
       outst.add(cline);
       cline:='';st:='';
      still:=false;
      end;

   if still and op.dourls then
   if pos('{',cline)>0 then
   begin
    _inlinelink(cline);
    clinetrim:=trim(cline);
    end
   else
   if pos('http:',cLINE)>0 then
   begin
       cline:=anchor(cline);
       end;
   if still and op.domail then
   if pos('@',cline)>0 then
   begin
       cline:=mailto(cline);
       end;




   if still and op.dolist then
   if (clinetrim<>'') and ((pos('* ',clinetrim)=1)
    or
    (pos('# ',clinetrim)=1)
    or
    (pos('-' ,clinetrim)=1)
    )
   then
   begin
      still:=false;
     emptyl:=false;
     cline:=trim(cline);
     ch:=cline[1];
     cline:=copy(cline,2,length(cline));
     if not inlist then
     begin
       _outall;
       if ch='#' then
       outst.add(tagsclose('ol','ol',openin,openpar,true))
       else
       outst.add(tagsclose('ul','ul',openin,openpar,true));inlist:=true;
      end;
      cline:=(tagsclose('li','li',openin,openpar,true)+cline);
       inl:=true;
      clinetrim:=trim(cline);
      end;

   if still and op.dotabs then
   if pos('|',trim(cline))=1 then
   begin
     still:=false;
     emptyl:=false;
     if not intable then
     begin
       _outall;
       outst.add(tagsclose('table','table',openin,openpar,true));intable:=true;
     end;
     st:='';open:=false;
     for j:=1 to length(cline) do
     if cline[j]='|' then
     begin
       if open then st:=st+'</td>';
       if j<length(cline) then
       begin st:=st+'<td>';
          open:=true;
       end else open:=false;
     end else st:=st+cline[j];
     if open then st:=st+'</td>';
     cline:='<tr>'+st+'</tr>';
     inp:=false;
     end;

   if
   (op.dots and (_numlevels(cline)=1))
   or
   (op.doh and
   ( (i=0) and (trim(cline)<>'') and (length(trim(cline))<40)
   and (h1<>'')
   )
  )
    then
   begin
       emptyl:=false;
       if pos('<',lowercase(cline))<1 then
       begin
         ekaots:=true;
         _outall;
         title:=cline;
         cline:=tagsclose(h1,h1,openin,openpar,false)+cline+'</'+h1+'>';
         openpar.clear;
         emptyl:=true;still:=false;
       end;
   end;
   if
    (still and op.dots and (_numlevels(cline)=2))
    or
    (still and op.empties and (empties>2))
    or
    (still and op.doh
       and
      (
        (
          (i>0) and  (trim(inst[i-1])='')
        )
        or (i=0)
       )
       and (lastline='')
       and (i<inst.count-1)
       and (trim(inst[i+1])='')
       and (length(trim(cline))<60)
       and (length(trim(cline))>1)
       and (h2<>'')
    )
    then
   begin
     _outall;
empties:=0;
     cline:=tagsclose(h2,h2,openin,openpar,false)+cline+'</'+h2+'>'+lastline;
     emptyl:=true;still:=false;
   end;

   if
    (op.dots and (_numlevels(cline)>2))
    or
   (still and op.empties and (empties>1))
   or
   (
   still and (lastline='')
   and ((h3<>'') and (op.doh)
     and
      ((pos('*',trim(cline))=1) or
       ((length(trim(cline))<50)) and (i<inst.count-1) and (pos('<',inst[i+1])<>1 ))
     ))
     then

    begin
     _outall;
     empties:=0;
     cline:=trim(cline);
     cline:=tagsclose(h3,h3,openin,openpar,false)+cline+'</'+h3+'>';
     emptyl:=true;
     still:=false;
end;
   if still and op.dop then
   if trim(cline)<>'' then
   begin
     if pos('<p>',lowercase(cline))>0 then
     emptyl:=false;
     if emptyl then
     begin
        _outall;
        if (pos('"',cline)=1) or (pos('&quot;',cline)=1) then
         outst.add(tagsclose('blockquote','blockquote',openin,openpar,true))
         else
        if (pos('>',cline)=1) or (pos('&gt;',cline)=1) then
         outst.add(tagsclose('pre','pre',openin,openpar,true))
         else
         outst.add(tagsclose('p','p',openin,openpar,true));
        still:=false;
        inp:=true;
         end;
      emptyl:=false;
   end
   else if op.dop then
   if not emptyl then
   begin
         emptyl:=true;end;
   if (nocr>0) and (outst.count>0) then
 begin
  try

  outst[outst.count-1]:=outst[outst.count-1]+cline;
  nocr:=nocr-1;
  except writeln('failed to ousts');end;
 end
  else
 outst.add(cline);
   empties:=0;
  nocr:=0;
 end;
 outst.add(tagsclose('close','close',openin,openpar,true));

 if title='' then title:='Untitled';

if op.heads then outst.insert(0,'<html>'+crlf+'<head><title>'+title+'</title></head><body>');
 _outall;
if op.heads then  outst.add('</body>'+crlf+'</html>');
//  openin.clear;openpar.clear;
openin.free;openpar.free;
end;



procedure tconverter.makethl;
var upfilename,rivi,xst:string;//tmp:tstringlist;
eka:boolean;
 i,last,p:integer;

function _hit(point,ctr:integer):string;
var lis,ne:string;
begin
       ne:='<!--ct id="c'+inttostr(i)+'"-->'+crlf;
       if op.talktabs then ne:='<td valign=top>'+ne+'</td></tr><tr><td>';
       rivi:=copy(rivi,1,point)+crlf+ne+copy(rivi,point+1,length(rivi));
       last:=i;
       eka:=false;
       end;

begin
        eka:=true;
      eka:=true;
       last:=0;
       if eka and op.talktabs then outst.add(crlf+'<table border=1><tr><td width="70%">'+crlf);

    for i:=0 to inst.count-1 do
    begin
      rivi:=inst[i];
      begin

        if  op.talkp and (pos('<p>',ansilowercase(rivi))>0) then
        begin
         xst:=_hit(pos('<p>',ansilowercase(rivi))-1,i);
         end;
        if op.talkex and (pos('!!!',rivi)>0) then
        begin
           p:=pos('!!!',rivi);
           gsub('!!!','',rivi);
           _hit(p-1,i);
        end;
        if op.talkh and (pos('<h',ansilowercase(rivi))>0) then
        begin
         xst:=_hit(pos('<h',ansilowercase(rivi))-1,i);
         end;
      end;
      outst.ADD(RIVI);
      end;
end;

procedure tconverter.makethm;
var
i:integer;
 rs,g_myurl,f_talk,st,comst:string;
begin
if (inst=nil) or (inst.count=0) then exit;
g_myurl:='myurl';
f_talk:='mytalk';
  outst.add('<h1>Testikeskustelu</h1>');
            for i:=0 to inst.count-1  do
            if pos('<!--ct ',inst[i])>0 then
            begin
              outst.ADD(COPY(inst[i],1,pos('<!--ct ',inst[i])-1));
              st:=COPY(inst[i],pos('<!--ct ',inst[i]),length(inst[i]));
              comst:=COPY(st,1,pos('>',st));
              st:=COPY(st,pos('>',st)+1,length(st));
              outst.add('<table border=1 cellspacing=10 cellpadding=0 width="80%">');
               outst.add('<tr><td bgcolor="yellow" width="80%">');
               rs:=cut_rs(copy(comst,7,length(comst)-10));
               outst.add('<a href="'+g_myurl+'?'+f_talk+'='+rs+'"><font size="-3">kommentoi</font></a>');
               outst.add('</table>');
               outst.add(st);
            end else outst.add(inst[i]+'');
            if inst.count>=0 then outst.add('</table>');
             outst.add('<hr>All comments in cronological order<ul>');
            end;

procedure toptions.getparams;
procedure _op(var b:boolean);
begin
   b:=true;
   dohtml:=true;
end;
var i:integer;ops:string;
begin

hlev:=0;
   for i:=0 to paramcount do
   begin
    if paramstr(i)='-p' then _op(dop);
    if paramstr(i)='-h' then _op(doh);
    if paramstr(i)='-t' then _op(dotabs);
    if paramstr(i)='-e' then _op(doexl);
    if paramstr(i)='-l' then _op(dolist);
    if paramstr(i)='-u' then _op(dourls);
    if paramstr(i)='-m' then _op(domail);
    if cut_ls(paramstr(i))='-hlev' then
     hlev:=strtointdef(cut_rs(paramstr(i)),0);
    if cut_ls(paramstr(i))='-talk' then
    begin
     ops:=cut_rs(paramstr(i));
     if ops<>'' then dotalk:=true;
      if pos('!',ops)>0  then talkex:=true;
     if pos('h',ops)>0 then talkh:=true;
     if pos('p',ops)>0 then talkp:=true;
     if pos('t',ops)>0 then talktabs:=true;

    end;
    if cut_ls(paramstr(i))='-sound' then
       soundfile:=cut_rs(paramstr(i));
    if cut_ls(paramstr(i))='-in' then
       infilename:=cut_rs(paramstr(i));
    if cut_ls(paramstr(i))='-out' then
       outfilename:=cut_rs(paramstr(i));
    if cut_ls(paramstr(i))='-head' then
       headerfilename:=cut_rs(paramstr(i));
  end;
 end;


procedure tconverter.readinput;
var st:string;
begin
 if inst=nil then inst:=tstringlist.create;
 if op.infilename='' then
 begin
  reset(input);
   while not eof(input) do
   begin
     readln(st);
     adjustlinebreaks(st);
     inst.add(st);
   end;

 end
 else inst.loadfromfile(op.infilename);
end;

procedure tconverter.writeoutput;
var i:integer;hef:textfile;st:string;
begin
 if (outst=nil) or (outst.count=0) then exit;
 //--if FileExistsUTF8(op.headerfilename) { *Converted from FileExists*  } then
 begin
   assign(hef,op.headerfilename);
   reset(hef);i:=0;
   while not eof(hef) do
   begin
      readln(hef,st);
      outst.insert(i,st);
      inc(i);
   end;
 end;
 if op.outfilename='' then
 begin
   for i:=0 to outst.count-1 do
   begin
     writeln(outst[i]);
   end;
 end
 else outst.savetofile(op.outfilename);

end;

end.




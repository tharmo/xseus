unit testmark;

{$mode delphi}

interface

uses
  Classes, SysUtils,xsexml;
function parsemdinlines(st:string;roottag:ttag):ttag;
function _markdown(val:string;inlines:boolean):ttag;
function _markdownblocks(val:string):ttag;
function markdowninlines(thetag:ttag):ttag;
function cleanxmp(var thetag:ttag):ttag;
function _tidylists(tagi:ttag):ttag;

implementation
uses xsemisc,xseglob;
function rawlist(tag:ttag):string;
var i:integer;
begin
 result:=result+'<li>'+'<B>'+tag.vari+'</B> <EM>'+tag.attributeslist+'</EM>:<SMALL>'+tag.vali+'!</SMALL><ul>';
 for i:=0 to tag.subtags.count-1 do result:=result+rawlist(ttag(tag.subtags[i]));
 result:=result+'</ul></li>';
end;




function parserec(src:string):ttag;
var blocks,ablock,oblock,rtag,inshere,aputag:ttag;i,j,inspoint:integer;

begin
   result:=ttag.create;
   writeln('<li>GO:<pre>'+_clean(src)+'</xmp><hr/><ul>');
   blocks:=_markdownblocks(src);
   writeln('</ul><li>Going:<pre style="border:1px solid red:margin:3em">'+_clean(blocks.xmlis)+'</pre><hr/><ul>');
   for i:=0 to blocks.subtags.count-1 do
   begin
     ablock:=blocks.subtags[i];
     //if ablock.vari='xmp' then result.subtags.add(ablock) else
     if ablock.vari='tag' then
     begin
        try
        rtag:=tagparse(ablock.att('startline')+'<inshere/>'+ablock.att('endline'),false,false);
        writeln('</ul><li>next:<pre>'+_clean(rtag.listxml('',false))+'</pre><hr/>');
        result.subtags.add(rtag);
        inshere:=rtag.subt('.//inshere');
        //writeln('</ul><li>righthere:<pre>'+_clean(inshere.listxml('',false))+'</pre><hr/>');
        //inspoint:=inshere.parent.SUBTAGS.indexof(inshere);
        aputag:=inshere;  //just tmp switching
        writeln('</ul><li>inshere:<pre>'+_clean(inshere.xmlis)+'</pre><hr/>');
        inshere:=aputag.parent;
        inshere.subtags.remove(aputag);
        //aputag.
        aputag.clearmee;
        //writeln('</ul><li>insertedhere:<pre>'+_clean(inshere.xmlis)+'</pre><hr/>');
//        inshere.clearmee;
        //rtag:=ablock;
        //oblock:=ablock;
        ablock:=parserec(ablock.vali);
        for j:=0 to ablock.subtags.count-1 do
          rtag.subtags.add(ablock.subtags[j]);
//        ablock.clearmee;
        except    writeln('<li>FAILTAG:'+_clean(ablock.xmlis)+'</pre><hr/><ul>');
end;
     end else
     result.subtags.add(ablock);
   end;
   writeln('</ul><li>WENT:<pre>'+_clean(result.xmlis)+'</pre><hr/>');

end;
function _markdown(val:string;inlines:boolean):ttag;
var pars,apar:ttag;debug:boolean;i:integer;
begin
 result:=parserec(val);
 result:=markdowninlines(result);
end;

function _tidylists(tagi:ttag):ttag;
var //s,origs,n,
  thist,listto,lastlist:ttag;i,j,previndent,indent:integer;hadlist:boolean;//sl:tlist;
  lists,indents:tlist;
 sublist:tlist;
begin
 try
 result:=ttag.create;
 listto:=result;
 indents:=tlist.create;
 lists:=tlist.create;
 for i:=0 to tagi.subtags.count-1 do
 begin
   try
     thist:=ttag(tagi.subtags[i]);
   except  writeln('failed tidylist substart');  end;
   //writeln('<li>tidylisting '+thist.xmlis+'!');
   if   (thist.vari<>'li') then
   begin
    result.subtags.add(thist);
    indents.clear;lists.clear;
    listto:=result;
   end  else
   begin
     try
     //writeln(tagi.vari,i,'dolist:'+s.vari+s.vali,s.subtags.count);
     indent:=strtointdef(thist.att('indent'),0);
     while (indents.count>0) and (indent<INTEGER(indents[0])) do
     begin
       indents.delete(0);
       lists.delete(0);
       if lists.count=0 then  listto:=result  else listto:=lists[0];
     end;
     if (lists.count=0) or (indent>integer(indents[0])) then
      begin
       try
         if indents.count=0 then  listto:=result.addsubtag(thist.att('listtype'),'')
         else try listto:=listto.lastsubtag.addsubtag(thist.att('listtype'),''); except writeln('nolastsubtag'+thist.head+'<xmp>',result.xmlis,'</xmp>');end;
         lists.insert(0,listto);
         indents.insert(0,pointer(indent));
         except writeln('<li>failed insert list:',lists.count,thist.head);end;
      end;// else
      //listto.subtags.add(thist.copytag);
      listto.addsubtag('li',thist.vali);
     except   writeln('failed somewhere in tidylist');  end;
   end;
  end;
 except   writeln('failed somewhre in tidylist');    end;
end;


function _markdownblocks(val:string):ttag;
var stl:tstringlist;cnt,cntcl,apus,tagname:string;
    I,j,h,levs,llen: Integer;prev,atag,resutag,resus,root:ttag;
    empties,indent,xmp,intag:integer;
    debug: boolean;


begin
 //writeln('<h1>getblocks</h1><pre>'+_clean(val)+'</pre><hr/>');
  debug:=false;//true;
  resus:=ttag.create;
  resus.vari:='XXX';
  cntcl:='';
  stl:=tstringlist.create;
  //stl.delimiter:=#10;
  xmp:=0;
  intag:=0;
  try
  empties:=0;
  stl.text:=val;
  prev:=resus;
  root:=resus;
  I:=-1;
  //for I := 0 to stl.Count - 1 do
  WHILE i<stl.count-1 do
  begin
    i:=i+1;
   try
    // writeln('<li>try:',i,stl[i],'/',stl.count);
    try
     //writeln('<li>I:',i,'!',_clean(stl[i]),'!',intag,pos('<',stl[i])=1);
     cnt:=stl[i];
     if (trim(stl[i])='') and (xmp<1) and (intag<1) then begin empties:=empties+1;continue;end;
     if cnt[1]='<' then
     begin
       tagname:='';
       for j:=2 to length(cnt) do
      // if pos(cnt[i],gc_namechars)<1 then break else
       if not (cnt[j] in gc_namechars) then break else
        tagname:=tagname+cnt[j];
       if tagname='' then continue;
       if tagname='xmp' then
       begin
         prev:=resus.addsubtag('xmp','');

         for j:=i+1 to stl.count-1 do
         begin
           if pos('</'+tagname,stl[j])=1 then
           begin
             i:=j;
             prev:=resus;
             break;
           end
           else prev.vali:=prev.vali+crlf+stl[j];
          end;
       end else
       begin
           prev:=resus.addsubtag('tag','');
           writeln('<h3>tagi:'+tagname+'</h3>');
           for j:=i+1 to stl.count-1 do
           begin
             if pos('</'+tagname,stl[j])=1 then
             begin
              i:=j;
              prev.addatt('startline='+cnt);
              prev.addatt('endline='+stl[i]);

              //cnt:=stl[i];
              prev:=resus;
              break;
             end;
             prev.vali:=prev.vali+crlf+stl[j];
           end;
           continue;
         end;
     end;

    cnt:=trimleft(cnt);
     indent:=length(stl[i])-length(cnt);

     if (cnt[1] ='-') or (pos('* ',cnt)=1)  then
      begin
        if (cnt[1] ='-')  then prev:=resus.addsubtag('li',trim(copy(cnt,2,99999)));
        prev.setatt('listtype','ul');
        prev.setatt('indent',inttostr(indent));
        continue;
      end;
     if (indent>3) or (cnt[1]=#9) or (pos('    ',cnt)=1) then
      begin
          // writeln('encouter prev');
          if prev.vari='pre' then
           //prev.addsubtag('div',cnt)
           prev.vali:=prev.vali+crlf+stl[i]
          else
            prev:=resus.addsubtag('pre',stl[i]);
         //prev.setatt('style','xmargin: 0 2em 0 1em;color:red;');
         empties:=0;
         continue;
      end;
     if (pos(trim(cnt),'============================================')=1)  and   (length(cnt)>2)  then
      begin
          //if (empties>0) or (resus.subtags.count=0)  then
           if (empties>0) or (pos(#13,prev.vali)>0) or (resus.subtags.count=0)  then
               resus.addsubtag('hr','') else
             prev.vari:='h1';
             continue;
      end;
     if (pos(trim(cnt),'--------------------------------------------')=1) and    (length(cnt)>2) then
      begin
            if empties>0 then resus.addsubtag('hr','') else
            if resus.subtags.count>0 then
             prev.vari:='h2';continue;
      end;
       { else
       if  (pos(cnt[1],'1234567890')>0) and (_isnumlist(cnt,levs,llen))
       then
       begin
         prev:=_addmarked(resutag,prev,copy(cnt,llen,length(cnt)),'li',1,0);
         prev.attributes.add('listtype=ol');
         //continue;
       end}
     if  (cnt[1]='#') and (length(cnt)>1) and (cnt[2]='.') then
      begin
         prev:=resus.addsubtag('li',copy(cnt,3,length(cnt)));
         prev.setatt('listtype','ol');
         prev.setatt('indent',inttostr(indent));
         continue;
      end;
      if pos('#',cnt)=1 then
      begin
         h:=0;
         while (length(cnt)>0) and (cnt[1]='#') do
         begin
          delete(cnt,1,1);h:=h+1;
          try
          if length(cnt)>1 then
           if cnt[length(cnt)]='#' then
            delete(cnt,length(cnt),1)
           except writeln('<li>failed mardown heading');end;
         end;
         if length(cnt)>0 then
         begin
         prev:=resus.addsubtag('h'+inttostr(h),cnt);
         empties:=2;
         end;
         continue;
      end;
     if (cnt[1] ='>') or (pos('&gt;',cnt)=1) then
      begin
        if prev.vari='blockquote' then
        //prev.addsubtag('p',cnt) //added new line to blockquote asis.. whats the point?
        prev.addval(crlf+cnt)
        else
        prev:=resus.addsubtag('blockquote',cnt);
        empties:=0;
        continue;
      end;
     if cnt[1] ='"' then
      begin
         prev:=resus.addsubtag('blockquote',cnt);
         empties:=0;continue;
      end; // else  //no special markers
         {if (stl[i][1]='<') then
         begin
          prev:=resus;
          resus.addval(cnt);empties:=0;intag:=true;
         end else}

      if ((empties>0) or (i=0)) //whether to dump into prev or into root
         or (pos('.'+prev.vari+'.','.h.pre.')>0) //these cannot continue on new line without special markdown
         //or (pos(prev.vari,'.p.pre.li.blockquote')<1) //why?
         //and (cnt[1]<>'<')
         then
         begin
           try
           prev:=resus.addsubtag('p',cnt);
           empties:=0;
           except  writeln('<li>failed addmarks empties &gt; '+cnt+'/</li>');    end;
         end
      else
         begin
           try  //continue previous element
           //if (prev.vari='p') or (prev.vari='li') then
           //if (prev.vari='p') or (prev.vari='li')  or (prev.vari='blockquote') then
           begin
            //prev:=
            //_addmarked(prev,crlf+' '+cnt,'',empties,0);
            prev.vali:=prev.vali+crlf+cnt;empties:=0;
           end;
           except  writeln('<li>addmarks empties =&lt; error '+cnt+'/</li>');    end;
         end;
     except writeln('<li>Markdown atag error!',stl[i],'!',i);end;
       finally
        {writeln('<li>didmark '+cnt+'/</li>');
        try
        listwrite(resus);
        except
        writeln('<li>noresus'+cnt+'/</li>');

        end;}
       end;
  end ; //for-loop
  if resus.subtags.Count=0 then
  begin
    prev:=resus.addsubtag('p',val);
    prev:=resus;
  end;
  //while prev<>resus do resus:=
  result:=resus;
  stl.Clear;
  finally
   stl.Free;
  // writeln('<h1>gotblocks</h1><pre>'+_clean(result.xmlis)+'</pre>');
  end;
  //result.vari:='div';
end;

//type marks=(value,a,strong,emp,link,url,note,code,esc);

function _copyupto(st:string;beg,en:integer):string; //utility to be move to xsemisc
begin
 //len:=en-beg  //including end
  result:=copy(st,beg,en-beg-1);
end;


//const critchars='_*][h()_`';
const critchars='_*[`';




function cleanxmp(var thetag:ttag):ttag;
var i:integer;atag:ttag;
begin
 result:=thetag;
 //result:=ttag.create; //memleak
  for i:=0 to thetag.subtags.count-1 do // recurse
  begin
    atag:=thetag.subtags[i];//ttag.create('div',''); //memleak
    if atag.vari='xmp' then atag.vali:=_clean(atag.vali);
  end;
end;
function _checkstarts(st:string;ch:char;var curpos:integer;curtag:ttag):ttag;
var i,t,stlen:integer;hit:boolean;apust,linktxt,linkurl:string;
begin
  result:=nil;
// writeln('<li>trystart:'+ch+'/',curtag.vari);
 case ch of
   '_': // worry about escapes later ..if (pos(st[curpos+1],' _')<1) then
      begin
       result:=createtag(curtag,'em');
      end;
   '*': //if (curpos=stlen) or (pos(st[curpos+1],' *')<1) then
     begin
       result:=createtag(curtag,'strong');
     end;
   '`':
     begin
            result:=createtag(curtag,'code');
     end;
   'h':
     begin
       hit:=false;
       apust:=(copy(st,curpos,8));//https://
       if (apust='https://')  or (copy(apust,1,7)='http://') then
       //why? if (curpos>1) and (pos(st[curpos],'''''"\')>0) then
       begin
         hit:=true;
         if (apust='https://') then I:=curpos+9
         else I:=curpos+8;
         while (i<=length(st)) and (pos(st[i],whitespace)<1) do
         begin
           i:=i+1;
         end;
         result:=createtag(curtag,'a');
         result.vali:=copy(st,curpos,i-curpos);
         result.addatt('href='+copy(st,curpos,i-curpos));
         //curtag.subtags.add(result);
         //result:=nil;
         curpos:=i-1;
       end;// else result.killtree;
     end;
   '[':
     begin
       hit:=false;
       stlen:=length(st);
       i:=curpos+1;
       linktxt:='';linkurl:='';
       while (i<=stlen) do //and (pos(st[i],whitespace)<1) do
       begin
           if (pos(st[i],crlf)>0) then break;
           if st[i]=']' then begin hit:=true;break;END;
           linktxt:=linktxt+st[i];
           i:=i+1;
       end;
       if (i>=stlen) or (st[i+1]<>'(') then hit:=false;
       if (hit) then
       begin
         i:=i+1;hit:=false;
         while (i<=length(st)) do //and (pos(st[i],whitespace)<1) do
         begin
              i:=i+1;
              if (pos(st[i],crlf)>0) then break;
              if st[i]=')' then begin hit:=true;break;END;
              linkurl:=linkurl+st[i];
         end;
       end;
       if hit then
       begin
         result:=createtag(curtag,'a');
         result.vali:=linktxt;
         result.addatt('href='+linkurl);
         //curtag.subtags.add(result);
         //result:=nil;
         curpos:=i;
       end else begin result:=nil;end;
     end;
    end;
    if result<>nil then
    begin
      result.addatt('mark='+ch);
      //writeln('<li>startedtag:'+result.head+'/at:'+copy(st,1,curpos)+'/left:'+copy(st,curpos+1,999)+'!');
    end;
   // writeln('<li>triedstart',ch,result<>nil,curtag.vari);
end;

function _checkends(ch:char;st:string;curpos:integer;var term:string;curtag:ttag):boolean;
var newele:ttag;j,ui:integer;apst:string;oldch:char;
begin
     result:=false;
     apst:=curtag.att('mark');
     //try
     //writeln('<li>chkend:(',ch,'=',apst,')'+curtag.xmlis+'   /at:'+copy(st,1,curpos)+'!');
     //except writeln('Fail chken',curtag=nil);end;

     if apst='' then begin //writeln('<li>unmarked'+curtag.xmlis);
      exit;end;
     oldch:=apst[1];
     //if (ch=']') and (oldch='[') then ch:='[' else //trickery!
     if oldch=ch then // begin writeln('<li>wrongend:',ch,'/for:',curtag.xmlis);exit;end;
     result:=true;

end;


function parsemdinlines(st:string;roottag:ttag):ttag;
var i,len:integer;curtag,atag:ttag;res,term:string;ch:char;escap:boolean;
begin
 res:='';
 result:=ttag.create;
 result:=roottag;
 len:=length(st);
 curtag:=result;
 escap:=false;
// writeln('<hr><li>DODINS:',st);

 i:=0;
 while (i<len) do
 begin
    if curtag=nil then writeln('niltag at',i);
    i:=i+1;
    ch:=st[i];
   // writeln('-',i,':',ch);
    if pos(ch,critchars)>0 then
    begin
      //writeln('<li>test:',ch,'/in:',term);
      if escap then begin term:=term+ch;escap:=false;continue;end;
      if _checkends(ch,st,i,term,curtag) then
      begin
        try
         if term<>'' then curtag.addval(term);
         //writeln('<li>ended:'+curtag.head+'!with(',term, ')');
         term:='';
         curtag:=curtag.parent;
        except writeln('<li>noparent',i,ch); end;
      end else
      begin
        atag:=_checkstarts(st,ch,i,curtag);
        if atag<>nil then
        begin
          curtag.addval(term);
          curtag.subtags.add(atag);
          atag.parent:=curtag;
          if pos(ch,'h[')<1 then
            curtag:=atag;
         term:='';
        end
        else   //it was not markdown thou it looked like it
        begin
            term:=term+ch;
           // writeln('<li>',i,'nonewtag for <b>',ch,'</b>//',term,'//<small>',curtag.head,'</small></li>');
        end;
      end;
    end  else
    begin // normal char
      if escap then begin term:=term+'\'+ch;escap:=false;continue; end;
      if ch='\' then escap:=true
      else  begin  term:=term+ch;escap:=false; end;
      //term:=term+ch;
    end;
 end;     //of while
 if term<>'' then curtag.addval(term);
 //writeln('<h3>res:</h3><xmp>',result.xmlis,'</xmp>',curtag.xmlis,'<hr/>');
 while curtag<>result do
 begin
  //writeln('<li>move:'+curtag.head,'/to:',curtag.parent.head+'//');
  //writeln('<xmp>clear:'+curtag.parent.xmlis,'_</xmp>');
  curtag.parent.subtags.remove(curtag);
  curtag.parent.addval(curtag.att('mark')+curtag.vali);
  curtag.clearmee;
  curtag:=curtag.parent;
 //   writeln('<li>moved:'+curtag.head,'_</li>');
 end;

 //writeln('GOT:<xmp>'+result.xmlis,'_</xmp>');
end;
function parsetagtag(thetag:ttag):ttag;
var atag,atag2:ttag;i:integer; cnt:string;
begin

 atag:=tagparse(thetag.vali,false,true);
 cnt:=atag.vali;
 for i:=0 to atag.subtags.count-1 do cnt:=cnt+crlf+ttag(atag.subtags[i]).listxml('',false);
 writeln('<li>dopars:<pre>!',_clean(cnt),'!</pre><ul>');
 //atag:=atag.subtags[0];
 atag2:=_markdownblocks(cnt);
 atag2.vari:=atag.vari;
 atag2.attributescopyfrom(atag);
  //_markdown(ttag(atag.subtags[0]).vali,true);
  //writeln('<li>didblocks:<xmp>!',atag2.xmlis,'!</xmp>',atag2.vari+'/vali:<xmp>'+atag2.vali+'</xmp><ul>');
  result:=atag2;
  atag.killtree;
  writeln('<li>didpars:<pre>!',_clean(result.xmlis),'!</pre><ul>');
  //result:=ttag.create;
  //result.vari:=atag.vari;
  //result.attributescopyfrom(thetag);
  //result
  //result.subtags.add(markdowninlines(atag));
  //result:=(markdowninlines(atag));
 // result.subtags.add(_markdown(atag.listxml('',false),false));
  //writeln('</ul><li>didmarkx</h2><xmp>!',result.listxml('  ',false),'!</xmp>');
  {writeln('<h2>didblocks</h2><xmp>!',thetag.vali,'!</xmp>');
  thetag:=tagparse(thetag.vali,false,true);
  writeln('<h2>didinlines</h2><xmp>!',thetag.vali,'!</xmp>');
  thetag:=markdowninlines(thetag);
   writeln('<h2>didtagval</h2><xmp>',thetag.listxml('  ',false),'</xmp>');
   //result:=atag.subtags[0];
   //exit;
  }
end;

function markdowninlines(thetag:ttag):ttag;
var i:integer;atag:ttag;
begin
 try
 //writeln('<h2>dotagparse</h2><xmp>!',thetag.xmlis,'!</xmp><ul>');
 if thetag.vari='tag' then
 begin
    //thetag:=
    thetag:=parsetagtag(thetag);
    //result:=ttag.create;
    //result.vari:='huuhaa';
    //exit;
 end;
 result:=ttag.create;
 result.vari:=thetag.vari;
 result.attributescopyfrom(thetag);
 try                             //this will add to end???
    if trim(thetag.vali)<>'' then
     // _addmarked(thetag);//, atag.vari,'div');
      parsemdinlines(thetag.vali,result);
 except writeln('failed to mark tag at:',i,thetag.xmlis);end;
  //writeln('<li>didinlines:'+result.head,'!',result.xmlis,'!');
 //writeln('<hr/>RENINS:<xmp>'+result.xmlis+'</xmp><hr/>');
 //result:=ttag.create; //memleak
  for i:=0 to thetag.subtags.count-1 do // recurse
  begin
    atag:=thetag.subtags[i];//ttag.create('div',''); //memleak
    if atag.vari<>'xmp' then result.subtags.add(markdowninlines(atag))
    else begin
      //writeln('<li>XMP:<xmp>',atag.vali,'</xmp>');
      atag.vali:=_clean(atag.vali);
      atag.vari:='pre';
      result.subtags.add(atag);
      //writeln('<li>NOW:<xmp>',atag.vali,'</xmp>');
    //writeln('<li>/UM;'+atag.xmlis);
     end;
    //nt.subtags.add(
    //atag:=
    //result.subtags.add(atag);
   // nt:=ttag
  // writeln('<li>/MA;'+atag.xmlis);
  end;
  finally //writeln('</ul><li>did:',thetag.vari+'</li>');
  end;
end;
{function xmarkdowninlines(var thetag:ttag):ttag;
var i:integer;atag:ttag;
begin
 result:=thetag;
 //result:=ttag.create; //memleak
  for i:=0 to thetag.subtags.count-1 do // recurse
  begin
    atag:=thetag.subtags[i];//ttag.create('div',''); //memleak
    if atag.vari<>'xmp' then markdowninlines(atag)
    else begin
      //writeln('<li>XMP:<xmp>',atag.vali,'</xmp>');
      atag.vali:=_clean(atag.vali);

      atag.vari:='pre';
      //writeln('<li>NOW:<xmp>',atag.vali,'</xmp>');
    //writeln('<li>/UM;'+atag.xmlis);
     end;
    //nt.subtags.add(
    //atag:=
    //result.subtags.add(atag);
   // nt:=ttag
  // writeln('<li>/MA;'+atag.xmlis);
  end;
  try                             //this will add to end???
     if trim(thetag.vali)<>'' then
       _addmarked(thetag);//, atag.vari,'div');
  except writeln('failed to mark tag at:',i,thetag.xmlis);end;
  //writeln('<li>ALL;'+thetag.head,'!',thetag.xmlis);
  //writeln('<hr/>RENINS:<xmp>'+result.xmlis+'</xmp><hr/>');

end;
}

end.




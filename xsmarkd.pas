unit xsmarkd;

{$mode delphi}

interface

uses
  Classes, SysUtils,xsexml;
function _markdownstring(resus:ttag;val:string):ttag;
function _markdownone(st:string):ttag;
//function _markdownblocks(st:string):ttag;
//function _markdownonlines(st:string):ttag;
function _markdown(ele:ttag;mdlev:integer):ttag;

implementation
uses xsemisc,xseglob;
type marks=(value,a,strong,emp,link,url,note,code);

Type tmarkpoint=class (tobject)
   //-- added public
public
  soff,eoff:integer;
  mark:marks;
  param:string;
  function asstring(st:string):string;
end;
function tmarkpoint.asstring(st:string):string;
begin
  if eoff<>0 then
  case mark of
    value: result:=copy(st,soff,eoff-soff)+crlf;
    a: result:='|A|'+copy(st,soff,eoff-soff)+'|/A|'+crlf;
    strong: result:='|B|'+copy(st,soff,eoff-soff)+'|/B|'+crlf;
    emp: result:='|E|'+copy(st,soff,eoff-soff)+'|/E|'+crlf;
    link:result:='|AHREF|'+copy(st,soff,eoff-soff)+'|/AH|'+crlf;
    code:result:='|CODE|'+copy(st,soff,eoff-soff)+'|/CODE|'+crlf;
  end;
end;

Type tmarkpoints=class (tobject)
  //-- added public
public
  st:string;
  markslist:tlist;
  resele:ttag;
  curpos,stlen:integer;
  constructor create(str:string);
  //destructor free;
  procedure clear;
  function checkstarts(ch:char):boolean;
  function checkends:boolean;//virtual;
  function dohtml(var imark:integer):ttag;
  function parse:ttag;
  function createmark(m:marks;s,e:integer):tmarkpoint;
  procedure list;
end;

function tmarkpoints.createmark(m:marks;s,e:integer):tmarkpoint;
var newpoint:tmarkpoint;
begin
 newpoint:=tmarkpoint.Create;
 markslist.add(newpoint);
 newpoint.mark:=m;
 newpoint.soff:=s;
 newpoint.eoff:=e;
 result:=newpoint;
end;
procedure tmarkpoints.list;
var i:integer;amark:tmarkpoint;
begin
 for i := 0 to marksList.Count - 1 do
 begin
    amark:=markslist[i];
   writeln('<li>',amark.soff,'_',amark.eoff,'/',integer(amark.mark),
   copy(st,amark.soff,amark.eoff-amark.soff));

 end;
end;

function tmarkpoints.checkstarts(ch:char):boolean;
var i,t:integer;hit:boolean;apust:string;
amark:tmarkpoint;
begin
result:=false;
//writeln('+'+ch+'+');
case ch of
   'h':
     begin
       hit:=false;
       apust:=(copy(st,curpos,8));//https://
       if (apust='https://')  or (copy(apust,1,7)='http://') then
       begin
         hit:=true;
         if (apust='https://') then I:=curpos+9
         else I:=curpos+8;
         while (i<=stlen) and (pos(st[i],whitespace)<1) do
         begin
           i:=i+1;
         end;
         result:=true;
         amark:=createmark(link,curpos,i);
         curpos:=i;
       end;
     end;
        //'_': if (curpos=1) or (st[curpos-1]<>'_') then
   '_': if (curpos=stlen) or (pos(st[curpos+1],' _')<1) then
      begin
        createmark(emp,curpos,0);
        result:=true;
      end;
      //'*': if (curpos=1) or (st[curpos-1]<>'*') then
   '*': if (curpos=stlen) or (pos(st[curpos+1],' *')<1) then
     begin createmark(strong,curpos,0);
      result:=true;
     end;
   '`':
     begin
       createmark(code,curpos,0);
       result:=true;
     end;
   '[':
      begin
        createmark(a,curpos,0);
        result:=true;
      end;
   '(':
     begin
       I:=curpos+1;
       if (curpos>1) and (st[curpos-1]=']') then
       while (i<stlen) and (st[i]<>')') do
       begin
           i:=i+1;
       end;
      result:=true;
      amark:=createmark(url,curpos,i+1);
      curpos:=i;
     end;
   end;
end;

function tmarkpoints.checkends:boolean;
var newele:ttag;j,ui:integer;amark:tmarkpoint;
begin
    result:=false;
   for j := markslist.Count - 1 downto 0 do
   begin
      amark:=markslist[j];
     if amark.eoff=0 then
     case amark.mark of
      a:begin
      if (st[curpos]=']') then
       if (curpos<stlen) and (st[curpos+1]='(') then
       begin
        ui:=curpos+2;
        result:=true;
        //while (st[ui]<>'}') do
        {begin
            amark.param:=amark.param+st[ui];
            ui:=ui+1;
            if (ui>=curpos+100) or (ui>stlen) then
            begin
              result:=false;
               break;
            end;
        end;
        if result  then}
        begin
        amark.eoff:=curpos+1;
        //result:=true;
        //curpos:=ui;
        end;
       end
       else //plain brackets, no (
       if (curpos<stlen) and (st[curpos+1]='!') then
        begin
        ui:=curpos+2;
        result:=true;
        amark.mark:=note;
        amark.eoff:=curpos+1;
        break;
        //iteln('note:');
        end;
      end;
      url:begin
       if (st[curpos]=')') then
       begin
        amark.eoff:=curpos+1;
        result:=true;
       end;
      end;
      strong: begin
        if (st[curpos]='*') then
         if (curpos<2) or (st[curpos-1]<>'*') then
        begin
         amark.eoff:=curpos+1;
         result:=true;
        end;
      end;
      emp: begin
        if (st[curpos]='_') then
         if (curpos<2) or (st[curpos-1]<>'_') then
         begin
            amark.eoff:=curpos+1;
            result:=true;
        end;
      end;
      code: begin
          if (st[curpos]='`') then
           if (curpos<2) or (st[curpos-1]<>'`') then
            begin
           amark.eoff:=curpos+1;
           result:=true;
          end;
      end;
    end; //case
  end; //if eoff>0
end;

procedure _addsubvalue(res:ttag;val:string);
var ltag:ttag;
begin
   //if ((res.vari='value')or (res.vari='')) and
   if val=''  then exit;

   if (res.subtags.count=0) then
   begin
     if res.vali='' then res.vali:=val else
     res.vali:=res.vali+' '+val;
   end
   //else
   //if res.subtags.count>0 then
   //begin
   //  ltag:=ttag(res.subtags[result.subtags.count-1]);
   //  if ltag.vari then

   else res.addsubtag('',val);


end;
function tmarkpoints.dohtml(var imark:integer):ttag;
var newele:ttag;j,mlen:integer;mymark,amark:tmarkpoint;
 didone:boolean;
begin
try
 didone:=false; //to only trim off tagchar once
    mymark:=markslist[imark];
// writeln('DOMARKS',markslist.Count);
// list;
    result:=ttag.create;
    mlen:=0;
    curpos:=mymark.soff;
   case mymark.mark of
  // url: begin result.vari:='hui';result.vali:='hai';end;
   a:begin
    begin
      try
      mlen:=0;
      result.vari:='a';
      result.vali:=copy(st,mymark.soff+1,mymark.eoff-mymark.soff-2);
     if markslist.count>imark then
     begin
      imark:=imark+1;
      amark:=markslist[imark];
      curpos:=amark.eoff;
     end
     else amark:=markslist[imark];
     if (mymark.soff>1) and (st[mymark.soff-1]='!') then
     begin
       result.setatt('src',copy(st,amark.soff+1,amark.eoff-amark.soff-2));
       result.setatt('alt',result.vali);
       //result.attributes.add('title=huutomerkki edellä ihna kiusaksi'+result.vali);
       result.vari:='img';result.vali:='';
     end else
     result.setatt('href',copy(st,amark.soff+1,amark.eoff-amark.soff-2));
     mymark:=amark;
     //result.attributes.add('class='+copy(st,mymark.soff-1,1));
         except
      writeln('<xmp>failed adding link:',integer(amark.mark),'/',imark,'/',curpos,':','</xmp>');
    end;

    end;
   end;
   {value: begin
      begin
       mlen:=0;
      result.vari:='u';
      end;
   end;}
   note: begin
      begin
       mlen:=1;
      result.vari:='a';
      result.setatt('title',copy(st,mymark.soff,mymark.eoff-mymark.soff));
      end;
   end;
   strong: begin
      begin
       mlen:=1;
      result.vari:='strong';
      end;
   end;
   code: begin
      begin
       mlen:=1;
      result.vari:='code';
      end;
   end;
   emp: begin
      begin
      mlen:=1;
     result.vari:='em';
      end;
    end;
   link: begin
      begin
       result.vari:='a';
       result.setatt('href',copy(st,mymark.soff,mymark.eoff-mymark.soff));
       //result.attributes.add('class=LINK'+copy(st,mymark.soff-1,1));
       mlen:=0;
      end;
    end;
   end; //case
    curpos:=curpos+mlen;
   while imark< markslist.Count-1 do
   begin
    try
    imark := imark+1;
    amark:=markslist[imark];
    if amark.eoff=0 then continue;
    if amark.soff=0 then continue;
    if amark.soff>mymark.eoff then
    begin
     imark:=imark-1;
     break;
    end;
    didone:=true;
    try
    if amark.soff>curpos then
    _addsubvalue(result,copy(st,curpos,amark.soff-curpos));
    result.subtags.add(dohtml(imark));
    except
      writeln('<xmp>markdownadd failded:',integer(amark.mark),'/',imark,'/',curpos,':','</xmp>');
    end;
    except
      writeln('<xmp>didnothtmltag:',integer(amark.mark),'/',imark,'/',curpos,':','</xmp>');
    end;
   end;
   if curpos<mymark.eoff then
   begin
    _addsubvalue(result,copy(st,curpos,mymark.eoff-curpos-mlen));
  // result.attributes.add('y_'+result.vari+'='+inttostr(result.subtags.count-1));
   end
   else
   begin
   //result.addsubtag('value',copy(st,curpos,mymark.eoff-curpos-mlen));
   //writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
   //ttag(result.subtags[result.subtags.Count-1]).attributes.add('x_'+result.vari+'='+inttostr(result.subtags.count-1));
   end;


   curpos:=mymark.eoff;
except
  writeln('<xmp>didnothtml:',integer(mymark.mark),'/',imark,'/',curpos,':','</xmp>');
raise;
end;
 //writeln('/DIDMARKS',markslist.Count);

end;

constructor tmarkpoints.create(str:string);
begin
inherited create;
resele:=ttag.create;
markslist:=tlist.create;
st:=str;
end;

//destructor tmarkpoints.free;
procedure tmarkpoints.clear;
var i:integer;
begin
//markslist:=tlist.create;
for i := 0 to marksList.Count - 1 do
   tmarkpoint(markslist[i]).free;
markslist.clear;
markslist.free;
//inherited free;

end;


const critchars='_*][h()_`';

function tmarkpoints.parse:ttag;
var i,j:integer;
atag:ttag;
inslist:tlist;
 amark:tmarkpoint;
begin
try
try
 inslist:=tlist.Create;
 curpos:=0;stlen:=length(st);
 inslist.add(createmark(value,1,stlen+1));
 //inslist.add(createmark(strong,1,stlen+1));
  while curpos<=stlen do
  begin
    curpos:=curpos+1;
    if pos(st[curpos],critchars)>0 then
    begin
       if checkends then
          continue;
       if checkstarts(st[curpos]) then
       begin
         continue;
       end;
    end;
  end;
  i:=0;
  //list;
  //writeln('----------dohtml'+st);
  result:=dohtml(i);
except
  writeln('----------FAIL'+st);

end;
finally
 // writeln('----------'+st);
 //  listwrite(result);
 // writeln('///////');
  inslist.Free;
end;
end;
{function _inlinetag(st:string):boolean;
begin
 if pos(','+st+',', ',span,b,em,strong,u,tt,code,')>0 then
 result:=true else result:=false;
end;
function _blocktag(st:string):boolean;
begin
 if pos(','+st+',', ',span,b,em,strong,u,tt,code,')>0 then
 result:=true else result:=false;
end;}


type tmarkdownlist=class(tobject)
   list,ilist:tlist;
   topparent:ttag;
   function pop(lev:integer):ttag;
   function lastindent:integer;
   function lastlist:ttag;
   procedure push(tagi:ttag;lev:integer);
   procedure clear;
   constructor create;
   procedure listaa(st:string);
end;
   function tmarkdownlist.lastlist:ttag;
   begin
     result:=list[list.count-1];
   end;
   function tmarkdownlist.lastindent:integer;
   begin
    if ilist.count=0  then
     result:=-1 else
     result:=integer(ilist[ilist.count-1]);
   end;
   function tmarkdownlist.pop(lev:integer):ttag;
   var i,j:integer;
   begin
    //   writeln('pop ',lev,' from ', integer(ilist.count));
     for i:= list.count-1 downto 0 do
       if integer(ilist[i])>lev then
       begin
         //  writeln('skip item ',i,' as ', integer(ilist[i]),'&lt;',lev);
           continue  //isot arvot ovat listan lopussa
       end
       else
       begin
           result:=list[i];
           //writeln('match at ',i,'=', integer(ilist[i]));
           for j := List.Count - 1 downto i+1 do
           begin
             //writeln('del ',j,'=', integer(ilist[j]));
              ilist.Delete(j);
              list.Delete(j);
           end;
           exit;
       end;
   end;
   procedure tmarkdownlist.push(tagi:ttag;lev:integer);
   var lastlast:ttag;
   begin
      list.add(tagi);
      ilist.add(pointer(lev));
      if list.Count>1 then
      begin
        lastlast:=ttag(list[list.Count-2]);
        lastlast:=lastlast.subtags[lastlast.subtags.count-1];
        lastlast.subtagsadd(tagi);
      end;

   end;
   procedure tmarkdownlist.listaa(st:string);
   var i:integer;
   begin
     writeln('list:'+st);
     for I := 0 to List.Count - 1 do
     begin
           writeln('###',i,'=', integer(ilist[i]));
           try
             //if list[i]<>nil then
             //if ttag(list[i]).subtags<>nil then
             // if ttag(list[i]).subtags.Count>0 then
               writeln(ttag(ttag(list[i]).subtags[0]).xmlis);
             //  listwrite(ttag(list[i]));

           except

           end;
     end;
   end;
   procedure tmarkdownlist.clear;
   begin
    list.clear;
    ilist.clear;
   end;
   constructor tmarkdownlist.create;
   begin
    list:=tlist.create;
    ilist:=tlist.create;
   end;

function _sublist(oli:ttag):ttag;
var n:ttag;sl:tlist;
begin
       n:=ttag.create;
       n.vari:=oli.att('listtype');
       oli.attributesclear;
       oli.parent:=n;
       n.subtags.add(oli);
       result:=n;
end;
{ if ((tagi.vari='value') or (tagi.vari='') ) and (tagi.vali='')
  then
  begin
   writeln('valuevaluevaluevaluevaluevalue');
    for i := 0 to tagi.subtags.Count - 1 do
      try
      _addunder(_tidylists(tagi.subtags[i],lili));
      except
           writeln('failedvalue',i,ttag(tagi.subtags[i]).vari+':'+ttag(tagi.subtags[i]).vali);
      end;
   writeln('/////////////valuevaluevaluevaluevaluevalue');
     exit;
  //result.vari:=_randomstring
  end;
}
function _tidylists(tagi:ttag; lili:tmarkdownlist):ttag;
var s,origs,n,lastul,res,aput:ttag;i,j,previndent,indent:integer;hadlist:boolean;//sl:tlist;
 sublist:tlist;

procedure _addtag(tot,t:ttag);
var i:integer;
begin
     if (  //(t.vari='value') or
     (t.vari='') ) and (t.vali='kjhkj') then
     begin
       for i:=0 to   t.subtags.Count - 1 do
          tot.subtags.Add(t.subtags[i]);
     end
     else
      tot.subtags.add(t);
end;


begin
// listwrite(tagi);

try
 //writeln('STARTING TIDYLISTS'+tagi.vari+inttostr(tagi.subtags.count),tagi.vali );
 if tagi.subtags.Count<1 then
 begin
   result:=tagi.copytag;
   exit;
 end;
 result:=ttag.create;

 //if lili.lastlev>0 then
 // lili.listaa('OLDINDENTLISTOLDINDENTLISTOLDINDENTLIST'+tagi.vari+inttostr(tagi.subtags.count));

 result.vari:=tagi.vari;

 result.vali:=tagi.vali;
 result.attributescopy(tagi);
 lastul:=nil;
 //lili:=nil;
 hadlist:=false;
except
  writeln('failedstarttidylist');
end;
 try
 for i:=0 to tagi.subtags.count-1 do
 begin
   try
   s:=ttag(tagi.subtags[i]).copytag;
   origs:=ttag(tagi.subtags[i]);
     except
      writeln('failed tidylist substart');
    end;
  //  writeln('tidylisting '+'&svar'+s.vari+'&sval'+s.vali+'&',s.subtags.count,'%%%tag'+tagi.vari+'&');
   if   (s.vari='li') then
   begin
     try
     //writeln(tagi.vari,i,'dolist:'+s.vari+s.vali,s.subtags.count);
      indent:=strtointdef(s.att('indent'),0);
      s.subtags.clear;//:=tlist.create;

      if lili.lastindent<0 then
      begin
       //lili:=tmarkdownlist.create;
       n:=_sublist(s);
       lili.push(n,indent);
       result.subtags.add(lili.list[0]);
       hadlist:=true;
       lili.topparent:=result;
       n.parent:=result;
       //writeln('inited liststack',result.subtags.count,result.vari);
      end else
      if (indent>lili.lastindent) then
      begin
        lili.push(_sublist(s),indent);
        //lili.listaa('pushed'+s.vari);
      end
      else
      if indent=lili.lastindent then
      begin
        s.attributesClear;
        lili.lastlist.subtags.add(s);
      end else
      begin
        //listwrite(lili.lastlist);
        lili.pop(indent);
        s.attributesClear;
        lili.lastlist.subtags.add(s);
        //lili.listaa('poppinglist'+s.vari+s.vali+inttostr(indent));
        //listwrite(lili.lastlist);
      end;
      //if (tagi.vari<>'ul') and (tagi.vari<>'ol') then
       for j := 0 to origs.subtags.Count - 1 do
       begin
          //s.subtagsAdd(_tidylists(origs.subtags[j],lili));
          //writeln('!!!!!!!!!!!!!!!!!!!!!!!');
          _addtag(s,_tidylists(origs.subtags[j],lili));
          //aput:=(s.subtags[s.subtags.count]);
          //aput.vali:=aput.vali+'xxx';//attributes.add('list=under');

       end;
           // _addtag(s,_tidylists(origs.subtags[j],lili));

     //writeln('tidied list'+ ttag(lili.list[0]).xmlis);
    // lili.listaa('tidied list'+s.vali);
      //if origs.subtags.count>0 then
          //if hadlist then
          //else _addunder(_tidylists(origs,lili,true));
          //hadlist:=false;

        //  lili.lastlist.subtags.add(_tidylists(origs,lili));
     // s.subtags:=tlist.create;
          except
      writeln('failed tidylist li-handler'+s.vali);
    end;

   end else
   begin  //NOT LI
     //writeln(tagi.vari,i,'doother:'+s.vari+s.vali);
    try
     if lili<>nil then
     begin
       //lili.clear;
       //lili.free
     end;
     //lastul:=nil;
     //writeln('nonlist: '+'&svar'+s.vari+'&sval'+s.vali+'&',s.subtags.count,'%%%tag'+tagi.vari+'&');
       //s.attributes.add('listed=true');
       //   s.vari:=s.vari+'_';
     if (pos(','+uppercase(s.vari)+',',blockelems)>0)
     or (s.vari='') then
     begin
      lili.clear;
      //writeln('listended'+s.vari);
     end;
     if origs.subtags.count>0 then
     begin
     try
      res:=_tidylists(s,lili);
     except
      writeln('failedENDtidylist1'+s.vari+':'+s.vali);
    end;
    try
     if res<>nil then
       _addtag(result,res);
      //_addunder(res);
      //s.attributes.add('listby=copy');
     except
      writeln('failedENDtidylist2'+s.vari+':'+s.vali);
    end;

     end
 //      result.subtags
      {if (s.vari='value') or (s.vari='') then
      begin
      for j := 0 to s.subtags.Count - 1 do
        begin
          ttag(s.subtags[j]).attributes.add('invalue=true');
          result.subtags.add(_tidylists(ttag(s.subtags[j]),lili))
        end;
      end
      else}
     ELSE
     begin
     // _addunder(S.copytag);
      result.subtags.Add(s.copytag);
      //s.attributes.add('listby=rawxopy');

     end;
     //  i:=i+1;
     except
      writeln('failedENDtidylist');
    end;

   end;
 end;
  // if lili<>nil then
  // begin
  //     lili.clear;
  //     lili.free
  // end;
// tagi.attributes.values['indent']:='';
// tagi.attributes.values['listtype']:='';
 //writeln('ENDING TIDYLISTS',result.subtags.count,lili.lastindent,result.xmlis );
// lili.listaa
//writeln('endof '+tagi.vari+tagi.vali+'!'+inttostr(tagi.subtags.count));
     except
      writeln('failed somewhre in tidylist');
    end;

end;

function markdownsubtags(ele,baseres,respoint:ttag;mdlev:integer):ttag;
var i:integer;curtag,markedpoint,subrespoint,subbase,marktag,NEWTAG:ttag;
 lastwasblock:boolean;
function _addvalvalues(valtag,base,basebase:ttag):ttag;
var ctag,addpoint:ttag;
    i,j,sta: Integer;
begin
         try
          for i := 0 to valtag.subtags.Count - 1 do
          begin
            ctag:=valtag.subtags[i];
            if (i=0) and (ctag.vari='p') then // and not (lastwasblock) then
            begin
              //if (base<>basebase) then
              ctag.vari:='';
               //else respoint:=ctag;
              base.subtagsadd(ctag);
              respoint:=ctag;
            end else
            begin
              basebase.subtagsadd(ctag);
              //subrespoint:=ctag;
              respoint:=ctag;
            end;
          end;
          //if prevt<>result then prevt.parent:=result;
          except       writeln('<li>Markdown vali error:'+base.vari+':'+'</b> '+inttostr(i)+'</li>');
          end;
end;

function _addblockvalues(valtag,base:ttag):ttag;
var ctag,addpoint:ttag;
    i,j,sta: Integer;
begin
         try
          for i := 0 to valtag.subtags.Count - 1 do
          begin
            ctag:=valtag.subtags[i];
            subrespoint:=base;
            if (i=0) and  (base.subtags.Count=0) and (ctag.vari='p') then
            begin
             //respoint:=ctag;
               base.vali:=base.vali+ctag.vali;//+'!!!';
               for j := 0 to ctag.subtags.Count - 1 do
                 base.subtagsAdd(ctag.subtags[j]);
               continue;
            end ;//else //addpoint.vali:='value';            end;
            base.subtagsadd(ttag(ctag));
            subrespoint:=ctag;
            //respoint:=ctag;
            end;

          //if prevt<>result then prevt.parent:=result;
          except       writeln('<li>Markdown vali error:'+base.vari+':'+'</b> '+inttostr(i)+'</li>');
          end;
end;


begin
     lastwasblock:=true;
     //writeln('<li>dosub:'+ele.vari+ '('+ele.vali+')'+'<ul>');
     for i := 0 to ele.subtags.Count - 1 do
     begin
        curtag:=ele.subtags[i];
        //writeln('<li>next:'+curtag.vari+' TO '+RESPOINT.vaRi);
        //writeln('dosub',mdlev,curtag.vali,
        //crlf+' to: ', respoint.xmlis, ' within ',baseres.xmlis );
        subbase:=baseres;
        subrespoint:=respoint;
       //   if pos(','+uppercase(newsub.vari)+',',blockelems)>0 then
        //      prevt:=result;
       //prevprev:=prevt;
       //newsub:=_markdown(curtag,result,mdlev+1);
       //newsub.vali:=baseres.vari+'/'+prevt.vari+'/'+result.vari+'/'+newsub.vali+'#'+inttostr(mdlev);
       if pos(','+uppercase(curtag.vari)+',',inlineelems)>0 then
       begin
          //writeln('doinline:',i,curtag.vali+' cur: '+curtag.xmlis,' rp:',respoint.xmlis);
         respoint.subtagsadd(curtag);
          //writeln('didinline:',i,curtag.vali+' cur: '+curtag.xmlis,' rp:',respoint.xmlis);
         //lastwasblock:=false; //whatever follows this one, first line is value, not p
         //respoint:=respoint;
         //curtag.attributes.Add('inlineresp='+respoint.vari+'/'+baseres.vari);
         continue;
       end;
       marktag:=ttag.create;
       //writeln('___gotmarks:' +marktag.xmlis+'__________________');
       if curtag.vari='' then
       begin
           markedpoint:=_markdownstring(marktag,curtag.vali);
             //writeln('dovalue:',i,lastwasblock,curtag.vali+' to: '+respoint.xmlis,' marks:',marktag.xmlis);
           _addvalvalues(marktag,respoint,baseres);
            // writeln('didvalue <XMP>'+MARKTAG.LISTRAW+'</XMP>TO: '+RESPOINT.VARI);
             //,i,curtag.vali+' resp: '+             respoint.xmlis,' base:',baseres.xmlis);
             //writeln('nextto:',i,' resp: '+respoint.xmlis,' base:',baseres.xmlis);
             continue;
       end else
       //if pos(','+uppercase(curtag.vari)+',',blockelems)>0 then
       begin //block element
          markedpoint:=_markdownstring(marktag,curtag.vali);
          //writeln('doblock:',i,lastwasblock,curtag.vali+' mark: '+marktag.listraw,' cur:',curtag.xmlis);
          NEWTAG:=TTAG.create;
          NEWtag.vari:=curtag.vari;
          NEWtag.attributescopy(curtag);
          _addblockvalues(marktag,newtag);
          //NEWtag.attributes.Add('respa='+respoint.vari+'/'+baseres.vari+inttostr(newtag.subtags.count));
          baseres.subtagsadd(NEWTAG);
          respoint:=baseres;
          subbase:=newtag;
          //writeln('didblock:'+respoint.xmlis+' base: '+baseres.xmlis,' new:',newtag.xmlis);
       end;
     //  writeln('___addedmarks:' +baseres.xmlis+'__________________');
       if curtag.subtags.Count>0 then
       BEGIN
         //writeln('SUBTAGS TO: '+crlf+subrespoint.xmlis+'WITHIN:'+crlf+subbase.xmlis);
         markdownsubtags(curtag,subbase,subrespoint,mdlev+1);
       END;
     end;
     //writeln('</ul></li><li>Didsub:'+ele.vari+ '('+ele.vali+')</li>');
end;

function _markdown(ele:ttag;mdlev:integer):ttag;
var i,j:integer;ctag,prevt,prevprev,newsub:ttag;etype:string; lili:tmarkdownlist;
begin
 try
     result:=ttag.create;
     lili:=tmarkdownlist.create;
     result.vari:=ele.vari;
     //result.attributes.addstrings(ele.attributes);
     result.attributescopy(ele);
     prevt:=result; //prevt is the 'endpoint', where following
     markdownsubtags(ele,result,result,0);

     begin
     //WRITELN('DIDTAG..................',lili.lastindent,result.listraw+result.xmlis);
     result:=_tidylists(result,lili);
    // WRITELN('ordered..................',lili.lastindent,result.listraw+result.xmlis);
     //result:=_reorder(result);
     //WRITELN('liTAG..................',lili.lastindent,result.listraw+result.xmlis);
     end;
     finally
        //writeln('DIDMARKUP********'+ele.vari);
        lili.clear;lili.Free;
     end;
 end;
function _markdownone(st:string):ttag;
var i,j:integer;ctag,prevt,prevprev,newsub:ttag;etype:string; lili:tmarkdownlist;
begin
 try
     result:=ttag.create;
     lili:=tmarkdownlist.create;
     result.vari:='div';//ele.vari;
     //writeln('<h1>MARKD</h1><pre>',st,'</pre><hr/><hr/><hr/>');
     //result.attributes.addstrings(ele.attributes);
     prevt:=result; //prevt is the 'endpoint', where following
     _markdownstring(result,st);

     begin
     //WRITELN('DIDTAG..................',lili.lastindent,result.listraw+result.xmlis);
     result:=_tidylists(result,lili);
    // WRITELN('ordered..................',lili.lastindent,result.listraw+result.xmlis);
     //result:=_reorder(result);
     //WRITELN('liTAG..................',lili.lastindent,result.listraw+result.xmlis);
     end;
     finally
        //writeln('DIDMARKUP********'+ele.vari);
        lili.clear;lili.Free;
     end;
 end;



function _markdownstring(resus:ttag;val:string):ttag;
var stl:tstringlist;cnt,cntcl:string;
    I,j,h,levs,llen: Integer;prev,ctag,resutag:ttag;
    empties,indent:integer;
function _addmarked(addto:ttag;cnt,tagst:string;emp,vex:integer):ttag;
//makes a new tag and adds it to prevtag (or its ancestor, based on indentation)
var    marktag,partag:ttag;tagind:integer;
 mymarks:tmarkpoints;
begin
        try
        //writeln('addmarked',copy(cnt,vex+1,length(cnt)),indent);
       // listwrite(prevtag);
        mymarks:=tmarkpoints.create(copy(cnt,vex+1,length(cnt)));
          try
          marktag:=mymarks.parse;
          //mymarks.list;
          mymarks.clear;
          finally
           mymarks.free;
          end;
        marktag.vari:=tagst;
        addto.subtags.Add(marktag);
        marktag.parent:=addto;
        except
          writeln('<li>addmarks3 error '+cnt+'/</li>');
        end;
        result:=marktag;
        //exit;
        end;

begin
  cntcl:='';
  stl:=tstringlist.create;
  try
  empties:=1;
 // writeln('<li>crlf at pos:',pos(crlf,val));
 // writeln('<li>cr at pos:',pos(^m,val));
 // writeln('<li>lf at pos:',pos(^j,val));
  //_split(val,crlf,stl);
  //_split(adjustlinebreaks(val),^M,stl);
  _split(val,^j,stl);
   prev:=resus;
  for I := 0 to stl.Count - 1 do
  begin
   try
    try
    {firstnot:=false;
     if skipline1mark then
     begin
       writeln('skipfirst:'+stl[i],'|in|',stl.text,'|',i);
       if stl[i]='' then continue;
       //indent:=99999; //meaning: ???
       prev:=_addmarked(prev,''+stl[i],'value',0,0);
       skipline1mark:=false;
       continue;
     end;}

     //cnt:=stl[i];
     cnt:=trimleft(stl[i]);
     //writeln(turha+'**'+cnt);
     indent:=0;
     while (indent+1<length(stl[i])) and (stl[i][indent+1]=' ') do
       indent:=indent+1;  //chack indentation in case of nested lists
     //writeln('<li>r:',indent,cnt);
     if cnt<>'' then
     begin
        //if cnt[1]='<' then
        //else
        if (indent>3) or (cnt[1]=#9) or (pos('    ',cnt)=1) then //NOT VERY GOOD
        begin
        // writeln('encouter prev');
         if prev.vari='pre' then
         //prev.addsubtag('div',cnt)
           prev.vali:=prev.vali+crlf+stl[i]
         else
         prev:=_addmarked(resus,stl[i],'pre',empties,0);
         //prev.setatt('style','xmargin: 0 2em 0 1em;color:red;');
         empties:=0;
        end
        else
       if (pos(trim(cnt),'============================================')=1)  and
       (length(cnt)>2)  then
       begin
             //if empties>0 then resus.addsubtag('hr','') else
             //if resus.subtags.count>0 then
             if (empties>0) or (resus.subtags.count=0)  then
                resus.addsubtag('hr','') else
             prev.vari:='h1';
       end
       else
       if (pos(trim(cnt),'--------------------------------------------')=1) and
       (length(cnt)>2) then
       begin
            if empties>0 then resus.addsubtag('hr','') else
            if resus.subtags.count>0 then
             prev.vari:='h2';
       end
       else
       if (cnt[1] ='-') or (pos('* ',cnt)=1)
       then
       begin
         prev:=_addmarked(resus,cnt,'li',1,1);
         prev.setatt('listtype','ul');
         prev.setatt('indent',inttostr(indent));
       end
       { else
       if  (pos(cnt[1],'1234567890')>0) and (_isnumlist(cnt,levs,llen))
       then
       begin
         prev:=_addmarked(resutag,prev,copy(cnt,llen,length(cnt)),'li',1,0);
         prev.attributes.add('listtype=ol');
         //continue;
       end}
       else
       if  (cnt[1]='#') and (length(cnt)>1) and (cnt[2]='.')
       then
       begin
         prev:=_addmarked(resus,copy(cnt,3,length(cnt)),'li',1,0);
         prev.setatt('listtype','ol');
         prev.setatt('indent',inttostr(indent));
         //continue;
       end
       else
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
           except writeln('!!!#!!!!');end;
         end;
         if length(cnt)>0 then
         prev:=_addmarked(resus,cnt,'h'+inttostr(h),empties,0);
         empties:=0;
         //prev.attributes.values['indent']:='999';
       end
       else
       if (cnt[1] ='>') or (pos('&gt;',cnt)=1) then //NOT VERY GOOD
       begin
        if prev.vari='blockquote' then
        prev.addsubtag('div',cnt) //added new line to blockquote asis.. whats the point?
        else
        prev:=_addmarked(resus,cnt,'blockquote',empties,0);
        prev.setatt('style','xmargin: 0 2em 0 1em;color:red;');
        empties:=0;
       end
       else
       if cnt[1] ='"' then
       begin
         prev:=_addmarked(resus,cnt,'blockquote',empties,0);
         empties:=0;
       end else
       begin
       if (empties>0) or (i=0) then
       begin
          try
          prev:=_addmarked(resus,stl[i],'p',empties,0);
          except
          writeln('<li>addmarks empties &gt; error '+cnt+'/</li>');
          end;
       end
       else
       begin
           try
           //if (prev.vari='p') or (prev.vari='li') then
           if (prev.vari='p') or (prev.vari='li')  or (prev.vari='blockquote') then
           begin
            //prev:=
            _addmarked(prev,crlf+' '+cnt,'',empties,0);
            //_addmarked(crlf+' '+cnt,'value',empties,0);
            //prev.attributes.values['indent']:='999';
            //_addmarked(result,prev,crlf+prev.att('indent')+'¤'+inttostr(indent)+cnt,'value',empties,0);
           end
           else
           begin prev:=_addmarked(resus,' '+cnt,'',empties,0);
           prev.setatt('indent','999');
           end;
           except
             writeln('<li>addmarks empties =&lt; error '+cnt+'/</li>');
           end;
       end;
     end;
     empties:=0;
     end else
     begin
     empties:=empties+1;
     end;
     except writeln('<li>Markdown atag error ',stl[i],'!',i);end;
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
   // prev:=_addmarked(resus,crlf+'qqq'+val,'p',0,0);
    //prev:=resus;//.subtags[0];
    //writeln('HYVITYS///////////////////////////////////////////////');

  end;

  result:=prev;  //returns the last added tag
 // writeln(turha+'*********RESULT'+result.vari);
  //listwrite(result);
  //writeln(turha+'*********RESUs'+resuS.vari);
  //listwrite(resuS);
  {
  listwrite(prev.parent);
  writeln('/GOTMARKS');}
 // _tidylists(resus);
  stl.Clear;
  finally
   stl.Free;
  end;
  //result.vari:='div';
end;




end.


function _markdownstOLD(var resus,prev:ttag;val:string;firstnot:boolean;turha:string):ttag;
var stl:tstringlist;cnt,cntcl:string;
    I,j,h,levs,llen: Integer;ctag,resutag:ttag;
    empties,indent,previndent:integer;
function _addmarked(prevtag:ttag;cnt,tagst:string;emp,vex:integer):ttag;
//makes a new tag and adds it to prevtag (or its ancestor, based on indentation)
var    marktag,partag:ttag;tagind:integer;
 mymarks:tmarkpoints;
begin
        try try try
        //writeln('addmarked',copy(cnt,vex+1,length(cnt)),indent);
       // listwrite(prevtag);
        mymarks:=tmarkpoints.create(copy(cnt,vex+1,length(cnt)));
        try
        marktag:=mymarks.parse;
        except
          writeln('<li>addmarks parse error '+cnt+'/</li>');
        end;
        try
         mymarks.clear;
        except
          writeln('<li>addmarks clear error '+cnt+'/</li>');
        end;
        try
        mymarks.free;
        except
          writeln('<li>addmarks free error '+cnt+'/</li>');
        end;
        try
        marktag.vari:=tagst;
        //if pos(' ',cnt)=1 then emp:=2 else emp:=-1;
        partag:=prevtag;
        except
          writeln('<li>addmarks01 error '+cnt+'/</li>');
        end;
        except
          writeln('<li>addmarks1 error '+cnt+'/</li>');
        end;
        partag.subtags.Add(marktag);
        except
          writeln('<li>addmarks2 error '+cnt+'/</li>');
        end;
        marktag.parent:=partag;
        marktag.attributes.values['indent']:=inttostr(indent);
        except
          writeln('<li>addmarks3 error '+cnt+'/</li>');
        end;
        //marktag.attributes.values['class']:=inttostr(indent)+'#'+inttostr(tagind);
        result:=marktag;
        exit;
        end;

begin
  cntcl:='';
  stl:=tstringlist.create;
  try
  empties:=0;
  _split(val,crlf,stl);
   writeln(_wrap('aline:'+val,'99',turha));
  for I := 0 to stl.Count - 1 do
  begin
   try
    try
    {firstnot:=false;
     if firstnot then
     begin
       if stl[i]='' then continue;
       indent:=99999; //meaning: ???
       prev:=_addmarked(prev,''+stl[i],'value',0,0);
       firstnot:=false;
       continue;
     end;
     }
     //cnt:=stl[i];
     cnt:=trimleft(stl[i]);
     writeln(turha+'**'+cnt);
     previndent:=indent;
     indent:=0;
     while (indent+1<length(stl[i])) and (stl[i][indent+1]=' ') do
       indent:=indent+1;  //chack indentation in case of nested lists
     if cnt<>'' then
     begin
       if (pos(trim(cnt),'============================================')=1)  and
       (length(cnt)>2)  then
       begin
             if empties>0 then resus.addsubtag('hr','') else
             if resus.subtags.count>0 then
             prev.vari:='h1';
             empties:=0;
             prev.attributes.values['indent']:='999';//tämän alle ei panna mitään
       end
       else
       if (pos(trim(cnt),'--------------------------------------------')=1) and
       (length(cnt)>2) then
       begin
            if empties>0 then resus.addsubtag('hr','') else
            if resus.subtags.count>0 then
             prev.vari:='h2';
            empties:=0;
            prev.attributes.values['indent']:='999';
       end
       else
       if (cnt[1] ='-') or (pos('* ',cnt)=1)
       then
       begin
         //prev:=
         _addmarked(prev,cnt,'li',1,1);  //meaning that whatever comes
          //next, it will be placed under this li if indented more that this
         prev.attributes.add('listtype=ul');
       end
       { else
       if  (pos(cnt[1],'1234567890')>0) and (_isnumlist(cnt,levs,llen))
       then
       begin
         prev:=_addmarked(resutag,prev,copy(cnt,llen,length(cnt)),'li',1,0);
         prev.attributes.add('listtype=ol');
         //continue;
       end}
       else
       if  (cnt[1]='#') and (length(cnt)>1) and (cnt[2]='.')
       then
       begin
         prev:=_addmarked(prev,copy(cnt,3,length(cnt)),'li',1,0);
         prev.attributes.add('listtype=ol');
         //continue;
       end
       else
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
           except writeln('!!!#!!!!');end;
         end;
         if length(cnt)>0 then
         prev:=_addmarked(prev,cnt,'h'+inttostr(h),empties,0);
         empties:=0;
         prev.attributes.values['indent']:='999';
       end
       else
       if (cnt[1] ='>') or (pos('&gt;',cnt)=1) then //NOT VERY GOOD
       begin
        if prev.vari='blockquote' then
        prev.addsubtag('div',cnt) //added new line to blockquote asis.. whats the point?
        else
        prev:=_addmarked(prev,cnt,'blockquote',empties,0);
        prev.attributes.values['style']:='xmargin: 0 2em 0 1em;color:red;';
        empties:=0;
       end
       else
       if cnt[1] ='"' then
       begin
         prev:=_addmarked(prev,cnt,'blockquote',empties,0);
         empties:=0;
       end else
       begin
       //if (prev=nil) or (result=nil) then writeln('<li>PREVNIL:'+'stl[i]'+'/</li>') else
       //   writeln('<li>prevok: '+stl[i]+'/</li>');
       if empties>0 then
       begin
          try
          prev:=_addmarked(prev,''+cnt,'p',empties,0);
          except
          writeln('<li>addmarks empties &gt; error '+cnt+'/</li>');
          end;
       end
       else
       begin
           indent:=999;
           try
           if (prev.vari='p') or (prev.vari='xli') then
           begin
            _addmarked(prev,crlf+' '+cnt,'',empties,0);
            prev.attributes.values['indent']:='999';
            //_addmarked(result,prev,crlf+prev.att('indent')+'¤'+inttostr(indent)+cnt,'value',empties,0);
           end
           else
           begin prev:=_addmarked(prev,' '+cnt,'',empties,0);
           prev.attributes.values['indent']:='999';
           end;
           except
             writeln('<li>addmarks empties =&lt; error '+cnt+'/</li>');
           end;
       end;
     end;
     empties:=0;
     end else empties:=empties+1;
     except writeln('<li>Markdown atag error ',stl[i],'!',i);end;
       finally
        {writeln('<li>didmark '+cnt+'/</li>');
        try
        listwrite(resus);
        except
        writeln('<li>noresus'+cnt+'/</li>');

        end;}
       end;
  end ;
  result:=prev;  //returns the last added tag
  writeln(turha+'GOTMARKS'+result.vari);
  //listwrite(result);
  {
  listwrite(prev.parent);
  writeln('/GOTMARKS');}
 // _tidylists(resus);
  stl.Clear;
  finally
   stl.Free;
  end;
  //result.vari:='div';
end;

function _addvalues(valtag,prevbase,prevend:ttag;isblock:boolean):ttag;
var ctag,addpoint:ttag;
    i,j,sta: Integer;
begin
      addpoint:=prevend;
         try
          for i := 0 to valtag.subtags.Count - 1 do
          begin
            ctag:=valtag.subtags[i];
            //if (i=0) and (ctag.vari='p') then // and not (lastwasblock) then
            //begin
            // ctag.vari:='value'
            //end;
            if (i=0) and (ctag.vari='p') and
              (isblock or isblock) then
             //and
            begin
             if (addpoint.subtags.Count=0) then
             begin
               addpoint.vali:=addpoint.vali+ctag.vali;
               ctag.vari:='';
               writeln('getsubvals');
               for j := 0 to ctag.subtags.Count - 1 do
                 addpoint.subtagsAdd(ctag.subtags[j]);
               continue;
             end else addpoint.vali:='';
            end;

            //ctag.attributes.add('prev=
            if (isval) and (pos(','+uppercase(ctag.vari)+',',blockelems)>0) then
            begin
             writeln('BLOCKINVAL:'+ctag.xmlis+' newbase:'+prevbase.xmlis+' oldadd:'+addpoint.xmlis);
             addpoint:=prevbase;
             //addpoint:=ctag;
             respoint:=baseres;
             respoint:=ctag;//baseres;
            end;
            addpoint.subtagsadd(ttag(ctag));

          //if prevt<>result then prevt.parent:=result;
          end;
          except       writeln('<li>Markdown vali error:'+prevbase.vari+':'+prevend.vali+'</b> '+inttostr(i)+'</li>');
          end;
end;



unit xseexp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{After adding support for infix-operators, this got to be very confusing.
Needs some refactoring - probably starting with the infix-part.

}
interface
uses
  {$IFNDEF LCL} //Windows,
  //Messages,
  {$ELSE} //LclIntf, LMessages, LclType,
  {$ENDIF}
  xseglob, xsexml,xsexse,
  //xsesta,
  SysUtils,variants,  xmd5,
  xsereg, xsefunc,
  Classes;

type texpr=class(tobject)
 vali:string;//explistx,   x
 protected
 inquote:boolean;
 typ:char;namedpar:boolean;
 subexp:tlist;par:texpr;
 bracks:integer;
 procedure list;
 procedure clear;
 constructor create(pare:texpr;t:char;reglist:tlist);
end;
//const   const_opers ='&|<>=<=+-\^';  //remember / is also xpath
const   const_opers ='&|<>=<=+';  //remember / is also xpath
   //shit! * is also wildcard. use div(a,b) times(a,b) instead.

function _docompute(mathtag:ttag;xs:txseus;atstr:string):string;
function parsexse(st:ansistring;xs:txseus):ansistring;
//function parsexpart(st:ansistring;var sta:integer;xs:txseus;ininfix,needtowrite:boolean;var got tafree:boolean):ansistring;
//function doparsexpart(st:ansistring;var sta:integer;xs:txseus):ansistring;

//function _p_infix(st:ansistring;var sto:integer;xs:txseus;inival:string):ansistring;
function p_selroot(st:string;xs:txseus;curtag:ttag; var sta:integer;  needtowrite: boolean; var gottafree:ttag): ttag;
function parsexpart(st:ansistring;var sta:integer;xs:txseus;ininfix,needtowrite:boolean):ansistring;
function parsefromele(ele:ttag;st:string):string;
//function _p_condition(condst:string; ele:ttag):string;

implementation
uses xsemisc,Synautil;
//function parsexpart(st:ansistring;var sta:integer;xs:txseus;ininfix,needtowrite:boolean;var gottafree:ttag):ansistring;forward;

function parsefromele(ele:ttag;st:string):string;
var ii:integer;cb:ttag;
begin
 ii:=1;
  cb:=txseus(t_currentxseus).curfromele;
  txseus(t_currentxseus).curfromele:=ele;
  try
   result:=parsexpart(st,ii,t_currentxseus,false,false);//,true);

  finally
    txseus(t_currentxseus).curfromele:=cb;
    //writeln('<li>prspar:<b>',st,'</b>',result,'/from:',ele.head);
  end;
 end;
function doparsexpart(st:ansistring;var sta:integer;xs:txseus;ininfix:boolean):ansistring;
var needtowrite:ttag;
begin
  result:=parsexpart(st,sta,xs,ininfix,false);//,true);
end;
{
function _p_condition(condst:string; ele:ttag):string;
var i,len:integer;ch:char;st1,st2,con:string;
//function onetest:boolean;
function onetest:boolean;
 var int1,int2:integer;compa:boolean;
  begin
    st1:=parsexpart(condst,i,t_currentxseus,false,false);
    if (i>len) or (pos(condst[i],'<>=')<0) then begin writeln('<li>cond[',i,']=',condst[i],'/in:',condst);result:=st1='1';exit;end; //was a truth function
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
    //writeln('<xmp>TEST:',condst,':',len,'</xmp>');
    res:=onetest;
    while (i<len) do
    begin
       ch:=condst[i];
       i:=i+1;
       if i>1000 then begin writeln('<li>failed, too much testing </li>');result:='0';EXIT;end;

       if ch='&' then begin if res then res:=onetest else break; end
       else if ch='|' then if res then break else res:=onetest;
       writeln('<xmp>',ch, result,'</xmp>');

    end;
    if res then result:='1' else result:='0';
    //Fnum;writeln('<li>tested:',st1,'/cmp:',con,'/2:',st2,'/res:',result,'/i:',i,'/in'+condst);

end;
 }
function _getstring(st:string;sta:integer;var sto:integer):string;
begin
  result:='';
  sto := sta+1;
  while sto<=length(st) do
  begin
      if st[sto]='''' then
      begin          // writeln('<li>STEND:'+result+'!',sto,'!'+copy(st,sto,999),'!');
      sto:=sto+1;
      exit

      end
      else
      result:=result+st[sto];
      sto:=sto+1;

  end;
end;
function _getnum(st:string;sta:integer;var sto:integer):string;
begin
   result:=st[sta];
  sto := sta+1;
  while sto<=length(st) do
  begin
      if pos(st[sto],'0123456789E.')<1 then exit else
      result:=result+st[sto];
      sto:=sto+1;
  end;
end;
function _fetchst(findfrom,tofind:string;sta:integer;var sto:integer;maxlen:integer):string;
var i,posi:integer;startst:string;
begin
  startst:=copy(findfrom,sta,sta+maxlen);
  posi:=pos(tofind,startst);
  if posi>0 then
  begin
    sto:=sta+posi+length(tofind)-1;
    result:=copy(startst,1,posi-1);
    //writeln('<li>fetch:'+tofind+'/found:<b>',result,'</b>_',copy(findfrom,sto,length(findfrom)));
  end;
end;
function _uptoany(findfrom,tofind:string;sta:integer;var sto:integer;maxlen:integer):string;
var i,posi:integer;startst:string;
begin   //UGLY!
   result:='';
   //for i:=sta to sta+length(findfrom) do //maxlen do
   for i:=sta to length(findfrom) do //maxlen do
    if pos(findfrom[i],tofind)>0 then
    begin
     posi:=i;
     break;
    end else posi:=i;
  if posi=sta+maxlen then sto:=posi else
  begin
    sto:=posi+1;
    result:=copy(findfrom,sta,posi-sta); //'' if not found
  end;
  //writeln('<li>fetch:'+tofind+'/found:<b>',result,'/</b>_',sta,'-',sto);
end;

function _getrela(rela:trelation;st:string;var sta:integer):ttag;
//var rel:trelation;
begin
// ( xs.x_relation,sta)
  sta:=sta+1;
  //writeln('<li>rel:',st,sta);
  while st[sta]='&' do
  begin
    //ttag(xs.x_relation.toselected);
    rela:=rela.prev;
    sta:=sta+1;
  end;
  try writeln('<li>Relat:',ttag(rela.toselected).xmlis,'!</li>');
  except writeln('<li>nillrela');//writeln(rela.toselector+'!'+rela.fromselector);
  end;
  result:=rela.toselected
end;

function p_selroot(st:string;xs:txseus;curtag:ttag; var sta:integer;  needtowrite: boolean; var gottafree:ttag): ttag;

                   //st,       xs,       xs.CurFromEle,sta,            gottafree) else  //rememner to add remembertofree
var
  res,newtag, atag: ttag;
  txt, loc,spec,apust: string;
  rl: TList;
  i, apui: integer;
  //rest: string;
  //needtowrite: boolean; gottafree: boolean;
begin
 //writeln('<li>getroot:'+copy(st,sta,100),'!</li>',st,sta);
 //t_debug:=true;
  try
 // t_debug:=true;
  if st[sta]='!' then
  begin
    sta:=sta+1;
    //for i:=sta to
    spec:=_uptoany(st,'(/',sta,sta,10);
   //WHY THIS: if st[sta-1]='/' then sta:=sta-1;
    //t_debug:=true;  =!from/
    //function _fetchst(findfrom,tofind:string;{var} sto:integer;sta,maxlen:integer):string;
    //if t_debug then
    //writeln('<li>specifier:'+spec+'!/from:'+loc+'!/rest:'+copy(st,sta,100),'!</li>');
    Res := nil;
    gottafree := nil;
    //rest := '';
    if spec = '' then
    begin
      Res := nil;
      //rest := '';
    end else

    if spec='file' then
    begin
        loc:=_uptoany(st,')',sta,sta,100);
        //writeln('remembertofree:',st,appta.vari);
        apust := _indir(loc, xs.x_outdir, xs, needtowrite);
        //if t_debug then
        //writeln('<li>getfile:'+apust+'/rest:'+copy(st,sta,9999));
        Res := tagfromfile(apust, nil);
        gottafree := res;
        //gottafree.addATT('xse_filename='+APUST);
        //if t_debug then
        //writeln('<li>gotfile:'+res.xmlis);
        exit;
     end
     else
     if spec='http' then
     begin            //writeln('gggggggggggggggg');
        loc:=_uptoany(st,')',sta,sta,100);
         if t_debug then
        writeln('<li>geturl:'+apust+'!'+copy(st,sta,9999));
        apust := _httpget('http://'+loc, -1, nil);
        Res := tagparse(apust,false,true);
        gottafree := res;
        if t_debug then writeln('<li>gotfile:'+res.xmlis);
        exit;
      end else
      if spec='list' then
      begin
         loc:=_uptoany(st,')',sta,sta,100);
         res:=_listtotag(loc,'');
         gottafree:=res;
         //rest:='';
      end else
      if (spec = 'bookmark') or (spec = 'bm')  then ////***BOOKMARKS
      begin
       try
       //NOT WORKING! or i dont remember how...
       //writeln('<li>getbookmark:',sta,'//',st,'!!');
       loc:=_uptoany(st,')',sta,sta,100);
       //writeln('<li>/:',loc,'_',sta);
       if sta<length(st) then if  st[sta]='/' then sta:=sta+1; //UGLY
        //writeln('<li>bookmarx/:!!!',loc,'!!!',length(st),'!<b>',copy(st,sta,999)+'!</b>');
        res := xs.x_bookmarks.subt(loc);
        if (res<>nil) and (res.subtags.count>0) then res:=res.subtags[0] else res:=nil;
        //if res<>nil then writeln('<li>@@@'+loc+'!<pre>'+res.xmlis+'</pre>',copy(st,sta,99)+'!</li>')
        //if res<>nil then writeln('@@@'+loc+'!'+res.vari+'!rest:',copy(st,sta,99)+'!</li>')
        //else
        //writeln('NOBOOKM:<pre>!',xs.x_bookmarks.xmlis,'!</pre>');
       except   writeln(' --nononbiik--');res:=nil; end;
     end
      else
      if spec = 'to' then //***RESTAG
      begin
        Res := xs.curtoele;
        try
       // writeln('<li>FromTo:'+res.HEAD+'/with:'+copy(st,sta,100)+'!');
       // writeln('<li>FromTo2:'+'/UNDER'+RES.PARENT.HEAD);
        except     writeln('<li>didtryto'); end;
      end else
      if spec = 'toroot' then //***RESTAG
      begin
        Res := xs.curtoele;
        try
        try
        //writeln('<li>*****up1.'+res.vari);
        except    writeln('<li>curtoeleFAIL</li>'); end;
        if res.parent<>nil then
        while res.parent.parent<>nil do
        //while res.parent<>nil do
        begin
          //writeln('<li>up.'+res.parent.vari);
          res:=res.parent;
        end;
        //if t_debug then
        //writeln('<li>gottopar:'+res.vari+'!');
        except    writeln('<li>noparents:'+res.vari); end;
      end else
    if spec = 'from' then
    begin
      Res := xs.curfromele;
     end else
     if spec = 'fromroot' then
     begin
       Res := xs.curfromele;
      try
      while res.parent<>nil do
        res:=res.parent;
      if t_debug then writeln('<li>gottopar:'+res.subs('../../@element()'));
      except    writeln('<li>noparents:'+res.vari); end;
     end
     else
     if spec = 'class' then ////***handerslers
     begin
          Res := xs.x_handlers;
          //writeln('<li>ROOTELE:'+copy(res.xmlis,1,100)+'/rest:',copy(st,sta,99));
     end else
    if spec = 'handler' then ////***handerslers
    begin
       Res := xs.x_myhandler;
      //writeln('<li>ROOTELE:'+copy(res.xmlis,1,100)+'/rest:',copy(st,sta,99));
     end
     else
     if spec = 'by' then ////***handerslers
          Res := xs.curbyele
     else
        Res := nil;
     if st[sta]='/' then begin writeln('GET:'+copy(st,sta,999));sta:=sta+1;end;  //breaks something? We don't want the leading "/" ... ever?
   end
   else
   if st[sta]='/' then
   begin
    res:=xs.xml;sta:=sta+1;
   end else
   if st[sta]='&' then
   begin
     res:=_getrela(xs.x_relation,st,sta);// ttag(xs.x_relation.toselected);sta:=sta+1;
     //while st[sta]='&' do res:=
     //writeln('gotrel:'+res.xmlis);

   end
   else begin res:=curtag;//writeln('<li>gotroot:'+res.xmlis);
   end;
  finally
   result:=res;
   //t_debug:=false;
  end;
end;

function _p_path(st:ansistring;var sta:integer;intag:ttag):ansistring;
var j,posi,sofar,len:integer;xst,aps:string;P:pansichar;ch,etype:ansichar;
list:tlist;inquote:boolean;bracks, parens:integer;turha:boolean;
{
why parenthesis are handled? Where can they appear in path?
pol/ku[a=funktio(jotain...)] .. ONLY IN BRACKETS
plo/ku() .. eieie
ent
pol/ku[a=funktio(f2(F3()),)]

}

begin
 try
  len:=length(st);
  turha:=false;
  bracks:=0;
  parens:=0;
  inquote:=false;

  //if t_debug then

  if st[sta]=':' then
  begin
    //writeln('<h4>parsepath ',sta,'-from'+copy(st,sta,len)+'/in:'+intag.xmlis+'/</h4>');
    //t_debug:=true;
    sta:=sta+1;
    turha:=true;
    //turha:=999;
  end;
  while sta<=len do
  begin
    ch:=st[sta];
    if ch='\' then ch:='/';
    if t_debug then  writeln('<li>ch',ch,'/bracks:',bracks,inquote,parens,'/sta:',sta,'/of:',len,'</li>');
    if inquote then
    begin
      if ch='''' then inquote:=false;
      //xst:=xst+ch;
      //continue;
    end
    else
      if bracks>0 then
      begin
       if ch='''' then inquote:=not inquote  //quotes work  only in brackets
       else if ch=']' then begin bracks:=bracks-1;if bracks<0 then begin bracks:=0;writeln('<li>too many closing bracks'); sta:=sta+1;exit;end;end;
      end else  //not in bracks
      if ch='(' then
      begin parens:=parens+1;
         //WRITELN('<LI>PARENTHESIS:',COPY(ST,STA,999),'</LI>');
      end else
      if parens>0 then
      begin
          if ch=')' then
          begin parens:=parens-1;
          end
      end
      else
      if (pos(ch,'; ,)'+const_opers)>0) then         //or (ch=')'
      //if (pos(ch,'; ,+)')>0) then         //or (ch=')'
      begin
           if t_debug then writeln('<li>trysubee:',xst,'!<ul>');
           if xst='' then result:='' else
           if intag<>nil then result:=intag.subs(xst);
           //if t_debug then
           //writeln('<li>XST:'+xst+'=',result+'</li>');
           //sta:=sta+1;
           //if (pos(ch,'+ ')<1)  then
           exit;
      end;

    if ch='[' then if not inquote then bracks:=bracks+1;
    xst:=xst+ch;
    sta:=sta+1;
  end;
  if intag<>nil then result:=intag.subs(xst);

  finally
   // if pos('preceding',st)>0 then  WRITELN('<li>from: ',st,'  !!xstring:',xst,'/result:'+RESULT,'/rest:',copy(st,sta,999),'!</li>');
    {if turha=sta then
    begin
    sta:=sta+1; //to prevent from trying all over
    end;}
    //§§t_debug:=false;
    //if bracks<0 then writeln('NONGOBRAC');result:='NONOGOGO';
  end;
end;
///function turha_p_func(st:ansistring;sta:integer;var sto://integer;xs:txseus):ansistring;forward;

function turha_p_funparam(st:ansistring;var sto:integer;ordo:integer;xs:txseus):ansistring;
var op:string;
{  function _tryopname:integer;  //if funparam is of form par=value
  var i:integer;ch:ansichar;
  begin
    op:='';
    result:=0;
    ch:=st[sto];
    if Ch in ['A'..'Z', 'a'..'z'] then
    for i := 1 to 16 do
    begin
      ch:=st[sto+i-1];
      if ch='=' then
      begin
        result:=i;exit;
      end;
      if not (Ch in ['A'..'Z', 'a'..'z','0'..'9']) then break;
    end;
  end;
 }
var i,sta,opstop:integer;ch:ansichar;val,turha:string;//inope:boolean;
begin
try
 { inope:=false;
 opstop:=_tryopname;
 if opstop>0 then
 begin
   op:=copy(st,sto,opstop);//-1)+'=';
   //writeln('gotopo:'+op,'||'+st,opstop,' sto:',sto,'X',st[sto+opstop]);
   sto:=sto+opstop;
 end else op:='=';//'x'+inttostr(ordo)+'';
  if t_debug then writeln('<li>GETFUNPARAMTR:',op,sto,'!<b>',copy(st,sto,99),'</b>!</li>');
 }
//   while pos(ST[STO],whitespace+'+'+'=')>0 do  //WHY THE PLUS?
//     sto:=sto+1;
 ch:=st[sto];
  //writeln('FUNPARAMTR:',ch,'/',sto,':O:',opstop);
 if pos(ch,';,')>0 then exit;
 if ch=')' then begin writeln('<li>emptyfun');sto:=sto+1;exit;end;
 //these are tricky

 if ch='''' then
   begin
   val:=_getstring(st,sto,sto);
   //writeln('GOTST:'+val+'!!'+copy(st,sto,999),'/o:',op);
   end
   else
    if pos(ch,'(1234567890')>0 then val:=_getnum(st,sto,sto)
    else
    begin
      if t_debug then writeln('<li>Xparam:'+copy(st,sto,999),'</li>');
      val:=val+doparsexpart(st,sto,xs,false);//,false);//,false);
      if t_debug then writeln('<li>gotXparam:('+val,'), left:',copy(st,sto,999),'</li>');
    end;
 if st[sto]<>')' then sto:=sto+1;
 result:=op+val;
 finally
   if t_debug then writeln('<li>GoTFUNPARAMTR:'+op,val,' ??<b> '+result,'</b>-Left:<em>',copy(st,sto,99),'</em>');
 end;

end;
{begin
//if t_debug then writeln('<li>numparam:'+copy(st,sto,999),'</li>');
val:=_p_infix(st,sto,xs);
//if t_debug then   writeln('<li>gonumparam:('+val,'), left:',copy(st,sto,999),'</li>');
end else
}{ if pos(ch,'1234567890-')>0 then
begin
  val:=_getnum(st,sto,sto)
end}




function _p_func(st:ansistring;sta:integer;var sto:integer;xs:txseus):ansistring;
var j,jj,apui,posi,sofar,stlen:integer;
para,apstr,fname:string;P:pansichar;ch,etype:ansichar;
list:tlist;pars,subexp:tstringlist;//acom:ttag;
ok,hasparams,debug:boolean;fun:tfunc;

 function _getfunname:string;
 var en,i:integer;
 begin
  hasparams:=false;
  en:=32+sta;
  if en>length(st) then en:=length(st);
   for i:= sta to en do
   begin
     //writeln(i,'+',st[i]+'-');
     try
      if pos(st[i],whitespace+'();,'+const_opers)>0 then   {legacy - now checking just for "(" should suffice}
     // if st[i]='(' then
     begin
      result:=copy(st,sto,i-sto);
      if st[i]='(' then
      begin
         //writeln('<li>gettinfun:',st,'/',i,st[i],st[i+1],hasparams,'<b>',result,'!</b>');
        if (stlen>i) and (st[i+1]=')') then
        begin
        sta:=i+2;exit;
        end
        else
        begin
        hasparams:=true;
        sta:=i+1;exit;
        end;
      end
      else sta:=i;
//!!      if pos(st[i],whitespace+'(;,')>0 then
//!!      sta:=i+1 else sta:=i;//what else is there? operators +-<>&
      exit;
     end;
     sta:=i;
     except writeln('fail p_func getname');
     end;
   end;
   write('<li>onoononon',st, i,',',sta,',',sto,'=',copy(st,sto,sta));
   result:=copy(st,sto,sta-sto+1);
   //sto:=sta+1;

   // result:=''; what the fuck was this?
 end;
begin
 //t_debug:=true;
 // writeln('<li>parsefun ',fname,'/from:',copy(st,sta,length(st)),'      at!',sto,st[sto-1],hasparams,'<ul>');
 stlen:=length(st);
  fname:=_getfunname;
  //writeln('<li>parsedname: ',fname,'/from:',copy(st,sta,length(st)),'      at!',sto,st[sto-1],hasparams,'<ul>');
  if fname='' then exit;  //just ?: ?_, ?; ?xse:$myfun? throw some error!
  subexp:=tstringlist.create;
  pars:=tstringlist.create;
  sto:=sta;
  para:='';
  //if t_debug then
  //parsefun eq/from:?gt;!5=
  //if st[sto-1]<>')' then sto:=sto-1 else
  //if st[sto-1]=';' then sto:=sto-1 else
  //if st[sto-1]=')' then sto:=sto-1 else  //not pretty perhaps ?time(?now)  omitted ?now()
  //if st[sto-1]='(' then
  if hasparams then
  while sto<=stlen do
  begin
    //if t_debug then
  //writeln('<li>c:: ',sto,'-',stlen,'get:',copy(st,sto,stlen),' sofar:',subexp.text+'!</li>');
    try
      while (sto<stlen) and (pos(st[sto], whitespace)>0) do sto:=sto+1;
      if st[sto]=')' then break;
      //writeln('<li>trypar /at:',st[sto],sto,'/rest:',copy(st,sto,len),'!</li>');
      if st[sto]=',' then subexp.Add('') else
      subexp.Add(doparsexpart(st,sto,xs,false));////,false));//,false);
      //t_debug:=true;
     //if t_debug then
     //writeln('<li>GOTpar:'+subexp[subexp.count-1],'/at:',ch,sto,'/rest:',copy(st,sto,stlen),'|stext:'+subexp.text,'_',subexp.count,'!</li>');
    except  writeln('Ffailed to parse function parameters for ',fname,' at pos ',sto);
    end;
    //if t_debug then writeln('<li>GOonfparts:','/at:',ch,sto,'/rest:',copy(st,sto,stlen),'!</li>');
    while (sto<stlen) and (pos(st[sto], whitespace)>0) do sto:=sto+1;
    if sto>stlen then begin writeln('<li>unexpected end of params for ', fname);bREAK;end;
    ch:=st[sto];
    //if ch=',' then   sto:=sto+1  //and continue to get params
    //else
    begin
      sto:=sto+1;
      if ch=',' then continue else
      if (ch=')') then
       break  //normal brea,
      else // if pos(ch=';') then
      begin
        writeln('<li>invalid "',ch,'" within parameter list of '+fname+' in:',st,'!!!');break;
      end
    end;


  end;
  para:='';
  for j:=0 to subexp.count-1 do
     pars.add(subexp[j]);
   //if t_debug then
   fun:=tfunc.create(fname,pars,xs);
   try
      result:=fun.execute;
   except writeln('failed p_func exec',fname,'!');end;
      fun.Free;
     //writeln('</ul><li>failed function:?',fname,'!<b>',result,'</b>!',pars.text,pars.count,' (...',copy(st,sto,9999),')');
  try
    if pos('contains',st)>0 then
  //writeln('<li>gtfun:<b>',fname,'!</b>',subexp.count, '/left:',copy(st,sto,999),'/pars:<b>',subexp.text+'!</b>',result,'</li>');
   subexp.Free;
   except  writeln('failed free p_func sub');  end;
   try
   pars.free;

   except  writeln('failed free p_func pars');  end;
   //if pars=nil then
   // writeln('nopars');
   //t_debug:=false;

  end;


function _p_bookmark(st:ansistring;var sta:integer;xs:txseus):ansistring;
var aps:ansistring;apui:integer;aput:ttag;
 begin
    result:='';
    if xs=nil then exit;
    aps:='';
    while (sta<length(st)-1) do
    begin
      sta:=sta+1;
      if st[sta]='/' then break else aps:=aps+st[sta];
    end;
    //writeln('<li>bm_',aps,'$'+copy(st,sta,10)+'<pre>',xs.x_bookmarks.xmlis,'</pre>');

    //apui:= xs.x_bookmarks.subtags.IndexOf(aps)
    //aput:=ttag(xs.x_bookmarks.subtags.objects[apui]);
    try
    aput:=xs.x_bookmarks.subt(aps).subtags[0];
         except writeln('nobooksinexp:'+xs.x_bookmarks.subt(aps).xmlis);
        end;

    //writeln('<li>bm2_'+aput.xmlis,'</pre>');
    //listwrite(aput);
    sta:=sta+1;
    result:=_p_path(st,sta,aput);
 end;
function _p_ids(st:ansistring;var sta:integer;xs:txseus):ansistring;
var aps:ansistring;apui:integer;aput:ttag;
 begin
  result:='';
  if xs=nil then exit;
  aps:='';
    while (sta<length(st)) do
    begin
      sta:=sta+1;
      if st[sta]=';' then break
      else if st[sta]='/' then begin sta:=sta+0;break;end
      else aps:=aps+st[sta];
    end;
    //writeln('<li>id_',aps,'$'+copy(st,sta,10)+'<pre>','</pre>');

    //apui:= xs.x_bookmarks.subtags.IndexOf(aps)
    //aput:=ttag(xs.x_bookmarks.subtags.objects[apui]);
    try

    aput:=xs.x_ids.findobject(aps);
         except writeln('noIDinexp');
        end;

    //writeln('<li>GOTID_',aps,'<pre>',aput.xmlis,'#</pre>',st,':',sta,'left:',copy(st,sta,999),'!');
    //listwrite(aput);
    sta:=sta+1;
    result:=_p_path(st,sta,aput);
   // writeln('<li>GOTID:',st,'/=',result,'!',aput.head);
 end;

function _p_var(st:ansistring;var sta:integer;xs:txseus):ansistring;
var aps:ansistring;apui:integer;aput:ttag;
 begin
  result:='';
  if xs=nil then exit;
   aps:='';
    while true do //(sta<length(st)+1) do
    begin
      sta:=sta+1;
      if sta>length(st) then break;
      {if st[sta]=';' then
      begin
       //sta:=sta+1;
       //writeln('<li>VAREND:'+aps+'!');
       break;

      end;}
      if pos(st[sta],'-<>=+*/ ;.,)([]''')>0 then break else aps:=aps+st[sta];
    end;
    //writeln('<li>',st,'/VAR_'+aps+'/rest:'+copy(st,sta,99),'!');//+xs.x_svars.ToString);
    //xs.x_svars.list;
    //result:=xs.x_svars.values[aps];
    result:=xs.x_svars.values[aps];   //find(aps);
    //sta:=sta-1;
    //if result='' then result:='0';
    //writeln('<li>VAR:',aps,'=',result+'!');
 end;

function parsexpart(st:ansistring;var sta:integer;xs:txseus;ininfix,needtowrite:boolean):ansistring;
var i,j,posi,sofar,len,apui:integer;xst,aps:string;P:pansichar;ch,etype:ansichar;
list:tlist;aput,gottafree:ttag;rest:string;
//this requires a non-nil  xseus-object. Rewrite!
begin
 try
 result:='';
 if xs=nil then begin writeln('nilxseus'); exit;end;
 // t_debug:=true;
 xst:='';
 len:=length(st);
 ch:=st[sta];
 aput:=nil;
 if ch='#' then begin //writeln('<li>findid:',copy(st,sta,99999),'</li>'); //  result:=xs.x_ids.findtag())
    result:=_p_ids(st,sta,xs);end
 else if ch='''' then result:=_getstring(st,sta,sta) //sta:=sta+1;
 else  if pos(ch,'-1234567890')>0 then result:=_getnum(st,sta,sta)  else
 {INFIX if ch='(' then result:=_p_infix(st,sta,xs,'')  else}
 if ch='?' then
 begin
  sta:=sta+1;
   result:=_p_func(st,sta,sta,xs);
 end else
 if ch='$' then result:=_p_var(st,sta,xs) else
 //none of the above chars
 begin
   apui:=sta;
   gottafree:=nil;
   if (ch='!') or (ch='&') then
   begin
     aput:=p_selroot(st,   xs,   ttag(xs.curfromele),sta,false, gottafree);
   end
   else  //rememner to add remembertofree
   if ch='/' then aput:=xs.xml else aput:=xs.curfromele;
   begin
        //if pos('!to',st)>0 then sta:=sta+1;//writeln('<li>TO:',aput.head,'!!',copy(st,sta,999),'!!');
      result:=_p_path(st,sta,aput);
   end;
   if gottafree<>nil then gottafree.killtree;
   //if apui=sta then writeln('<h1>stuck</h1>');//exit; //just checking we are not stuck
 end;
 while (sta<length(st)) and (st[sta]=' ') do sta:=sta+1;

except writeln('<li>failed to parse xpart</li>');
end;
//if pos('contains',st)>0 then writeln('<li>containsx:',result);

end;


//    xse:$xse:$curvar;; {${$curvar}}
//    xse:$var_xse:$varind;; {$var_{$varind}}
function parsexse(st:ansistring;xs:txseus):ansistring;
var len,ii:integer;
function doapart:string;
var ch:char;myst:string;sto,apui:integer;
begin
 try
 result:='';
 apui:=1;
 //writeln('<li>parse at:',ii,'/',len,'/from:',copy(st,ii,999),'<ul>');
 while ii<len do
 begin
    //writeln('<li>try:'+copy(st,ii,999)+'!');
    ch:=st[ii];
    //writeln(':',ii,'-',ch);
    if ch='{' then
    begin
      if (ii>=len) or (pos(st[ii+1],whitespace)>0) then
      begin
       ii:=ii+1;
       result:=result+'{';
       continue;
      end;
     //ii:=ii+1;
          result:=result+doapart;
          //writeln('<li>gotpart:',result+'/left:'+copy(st,ii,999)+'!');
    end  else
    if ch='}' then begin
     //writeln('<li>get:',ii,result+'!');
     result:=parsexpart(result,apui,xs,false,false);//,true);
     //ii:=ii-1;
     //writeln('<li>got:',ii,'+',apui,result+'/left:'+copy(st,ii,999)+'!');
     exit;
    end else
    result:=result+ch;
    ii:=ii+1;
 end;
 //writeln('</ul><li>eval:'+result,'!</li>');
 apui:=1;
 if result<>'' then result:=parsexpart(result,apui,xs,false,false);//,true);

 finally  //writeln('</ul><li>parsed:'+result,'!</li>');
 end;

end;
//parses a string that can contain several {}-macros
begin
 try
 ii:=0;
 len:=length(st);
 while ii<len do
 begin
    ii:=ii+1;
   if st[ii]='{' then
   begin
    //if (ii<len) and (st[ii+1]='}') then
     if (ii>=len) or (pos(st[ii+1],whitespace)>0) then
     begin
       //writeln('nonmacrobracket');
       ii:=ii+1;
       result:=result+'{';
       continue;
     end;
     ii:=ii+1;
     result:=result+doapart;
   end
   else result:=result+st[ii];
 end;
 except
   writeln('<--fail parse xse'+st+'-->');
  end;
end;


function parsexsewithns(st:ansistring;xs:txseus):ansistring; //old version
//parses a string that can contain several xse:-elements
var i,j,posi,sofar,apui,startat:integer;aps,apus:string;P:pansichar;ch,etype:ansichar;
list:tlist;//,dones,chst,chen:tlist;//dones:txsechecpoint;
begin
 result:='';
 if xs=nil then exit;
 try
list:=tlist.create;
if st='' then begin result:='';exit;end;
//if pos('cxz',st)>0 then t_debug:=true;
try
  p:=pansichar(st);
  posi:=pos(xs.ns,p);  //quickfind!
  sofar:=0;
  while posi>0 do
  begin
    p:=p+posi+4-1;
    sofar:=sofar+posi+4-1;
    list.Add(pointer(posi-1));
    posi:=pos(xs.ns,p);  //quickfind!
  end;
  list.Add(pointer(length(st)-sofar));
  p:=pansichar(st);
  sofar:=length(st);
  aps:='';
  for I := List.Count - 1 downto 1 do
  begin
    apui:=integer(list[i]);
    aps:=copy(st,sofar-integer(list[i])+1,integer(list[i]))+aps;
    startat:=1;
    try
    apus:=doparsexpart(aps,startat,xs,false);//,false);//,false);
    except apus:='';end;
    aps:=apus+copy(aps,startat+1,99999);
    sofar:=sofar-apui-4;
  end;
  result:=copy(st,1,integer(list[0]))+aps;//+copy(; 0
  except
   writeln('<--fail parse xse'+st+'-->');
  end;
finally
  list.free;
end;
end;





procedure _h1(st:string);
begin
 writeln('<h1>'+st+'</h1>');
end;



 function _evalfunc(op:string;pars:tstringlist;xs:txseus):string;
var fun:tfunc;
begin
//_h1('evalfunc'+op+':'+pars.text);
 fun:=tfunc.create(op,pars,xs);
 result:=fun.execute;
 fun.Free;
end;

procedure texpr.clear;
var i:integer;
begin
  for i:=0 to subexp.count-1 do
   texpr(subexp[i]).clear;
   texpr(subexp[i]).free;
end;

 constructor texpr.create(pare:texpr;t:char;reglist:tlist);
begin
 inherited create;
 bracks:=0;
 inquote:=false;
  namedpar:=false;

 subexp:=tlist.create;
 par:=pare;
 typ:=t;
 if par<>nil then
 begin
 par.subexp.add(self);
 //explist:=par.explist;
 end;
 reglist.add(self);
end;




procedure texpr.list;
var i:integer;
begin
  writeln('<ul><li>'+vali+'/'+typ);
  for i:=0 to subexp.count-1 do
   texpr(subexp[i]).list;
  writeln('</li></ul>');
end;

function _getbookmark(path:string;bookmarks:tstringlist):string;
var st:string;
apui:integer;
       begin
         try
          //writeln('<li>bm1:',path,bookmarks.count,ttag(bookmarks.objects[0]).attributes.text);
          //st:=copy(path,3,999);
          st:=copy(path,2,pos('/',path)-2);
          apui:=bookmarks.indexof(st);
          //writeln('<li>///',st,'/',apui,bookmarks.Text,bookmarks.count,copy(path,3,999));
          //writeln('<li>bm:'+copy(path,pos('/',path)+1,length(path)),'+++',
          //copy(path,pos('/',path)+1,length(path))+//ttag(bookmarks.objects[apui]).attributes.text+
          //'|</li>');
          //listwrite(ttag(bookmarks.objects[apui]));
           result:=ttag(bookmarks.objects[apui]).subs(copy(path,pos('/',path)+1,length(path)));
          //writeln('<li>resultx',st,'/',result);
           //result:=ttag(bookmarks.objects[apui]).att(copy(path,pos('/',path)+1,length(path)));
         except writeln('<li>failedbookmark:::',path);end;
       end;



function _extfunctions(mathtag:ttag;xs:txseus):string; //DOE

var op:string;restag,stag:ttag;i:integer;
begin
 op:=mathtag.att('func');
 if pos('?',op)=1 then
 begin  //user-defined funcs
    try
    delete(op,1,1);
    for i:=0 to xs.X_funcs.subtags.count-1 do
    begin
     if ttag(xs.X_funcs.subtags[i]).att('name')=op then
     stag:=ttag(xs.x_funcs.subtags[i]);
    end;
    if stag=nil then exit;
      try
          restag:=ttag.create;
          (xs.dosubelements);
      except writeln('<li>failed to call function');end;
    if restag.subtags.count>0 then result:=ttag(restag.subtags[0]).listst
    else result:='';except writeln('<li>failed to call function.');end;
 end;
end;

function _docompute(mathtag:ttag;xs:txseus;atstr:string):string;
var afun:tfunc;   pars:tstringlist;didtag:boolean;op,ctagi:string;i:integer;
stag:ttag;apus:string;
begin     //called only by c_set / C_COMP. Somewhat extended (mathmlish) syntax for them
  pars:=tstringlist.create;
  try
  //if mathtag=nil then mathtag:=_oldfuncsyntax(atstr,didtag,pars);
  op:=mathtag.att('func');
  if pos('?',op)=1 then
  begin  //external functions probably not working, never fulloy thought out
    result:=_extfunctions(mathtag,xs);
    exit;
  end;
  if mathtag.vali<>'' then pars.add('value='+parsexse(mathtag.vali,xs));
  if not didtag then
  try
  for i:=0 to mathtag.getattributes.count-1 do
  begin
    apus:=cut_ls(mathtag.getattributes[i]);
    if apus ='func' then continue
    else if apus='var' then continue;
    IF (length(apus)=2)and (apus[1]='x') then
    pars.add(cut_rs(mathtag.getattributes[i])) else
    pars.add(mathtag.getattributes[i]);
  end;
  except writeln('failded in mathttag.attributes');
  end;
  try
  if not didtag then for i:=0 to mathtag.subtags.count-1 do
  begin
    stag:=ttag(mathtag.subtags[i]);
     if stag.vari=xs.ns+'comp' then  //this was early, mathml-inspired syntax
     begin
       ctagi:=stag.att('tag');
       if ctagi='' then ctagi:=op;
       pars.add(ctagi+'='+_docompute(STAG,xs,''));
     end
     else
      IF (length(stag.vari)=2)and (stag.vari[1]='x') then //why this? senseless!
       pars.add(parsexse(stag.vali,xs)) else
       pars.add(stag.vari+'='+parsexse(stag.vali,xs));
       end;
  except writeln('failded in mathttag.subtags');
  end;
  //tfunc.create(pars,xs.x_svars,xs.x_bookmarks,atstr,xs);
 // tfunc.create(op,pars,xs);
 result:=_evalfunc(op,pars,xs);
  finally
    pars.Free;

  end;
end;



end.


unit xsefunc;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
 {$M+}
//  {$IFNDEF LCL} //Windows,
// Messages, {$ELSE}
//{$IFNDEF FPC}
//  shellapi,
//{$ELSE}
//{$ENDIF}
//  LclIntf, LMessages, LclType, {$ENDIF}
 xseglob,xsexml,xsexse,
 //xsefun,//xsesta,
 //controls,
 typinfo,strutils,
 SysUtils,variants,  xmd5,
 xsereg,dateutils,
 Classes;

const
DayStr:array[1..7] of string[3]=('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
MonthStr:array[1..12] of string[3]=('jan','feb','mar','apr','may','jun',
'jul','aug','sep','oct','nov','dec');
function _listtotag(st,sep:string): ttag;  //

type  TfExec = function:string of object;

type tfunc=class(tobject)
public
 //pars:tcompparam;//apui,ires:integer;
 pars:tstringlist;
 //mathtag:ttag;
// svars,evars:tstringlist;
// state:tstate;
  xs:txseus;
 fname:string;
//atstr:string;
 //constructor create(p,s,e:tstringlist;st:tstate;ats:string;x:txseus);
 //procedure clear;
// constructor create(fn:string;p:tstringlist;st:tstate;x:txseus);
 constructor create(fn:string;p:tstringlist;x:txseus);
  private
 //  varlist:array[1..3] of string;
 published
  //condition comparisons
 function f_if: string; //xse:?if(cond, value_iftrue, valueiffalse)
 function f_not: string;
 function f_and: string;
 function f_or: string;
  function f_eq: string;
  function f_ne: string;
  function f_gt: string;
  function f_lt: string;
  function f_gte: string;
  function f_lte: string;
  function f_fileexists: string;
  function f_isinline: string;
  function f_isblock: string;
  function f_isnamechar: string; //just tm debuggin

  //characters etc constants
    function f_amp: string;
    function f_apos: string;
    function f_crlf: string;
    function f_formurl: string;
    function f_lf: string;
    function f_ntobr: string;
    function f_quote: string;
    function f_rnd: string;
    function f_space: string;
    function f_tab: string;
    function f_xse: string;
    function f_xhtmlheader:string;

    //file info
    function f_filesize:string;
    function f_filedate:string;
    function f_xfilename: string;
    function f_xfileext:string;
    function f_xfilenoext: string;
    function f_xfilepath: string;

    //ARITHMETICS
  function f_isnum:string;
 function f_plus:string;
  function f_inc:string;
 function f_num:string;
 function f_minus:string;
 function f_div:string;
 function f_mod:string;
 function f_random:string;
 function f_max:string;
 function f_min:string;

 //floats
  function f_fplus:string;
 function f_fminus:string;
 function f_fdiv:string;
 function f_ftimes:string;

 //date and time
 function f_incsecs:string;
 function f_incmins: string;
 function f_inchours: string;
 function f_incdays:string;
 function f_dateadd:string;
 function f_incweeks:string;
 function f_incmonths:string;
 function f_incyears:string;
 function f_hourssince:string;
 function f_dayssince:string;
 function f_datedif:string;
 function f_timedif:string;
 function f_dayofweek:string;
 function f_dayoftheweek:string;
 function f_formattime:string;
 function f_formatdatetime:string;
 function f_getdatetime: string;
 function f_icaldate:string;
 function f_icaltime:string;
 function f_datetime:string;
 function f_date:string;
 function f_time:string;
 function f_now:string;
 function f_today:string;
 function f_weekofyear:string;
 function f_month:string;
 function f_startofweek: string;
 function f_times:string;
 function f_sqrt:string;

 //string
    function f_copy:string;  //unnecessary
    //function f_substring:string;
    function f_substr:string;  //(string, startingat, optionally_length)
    function f_slice:string;  //(string, startingat, optionally_endingat)
    function f_length:string;
    function f_utf8length:string;
    function f_pos:string;   //position, returns number
    function f_posany:string;   //position, returns number
    //string input
    function f_read:string; //reads a file into string (no parsing)
    function f_tcpget: string; //raw tcp
    function f_httpget: string; //raw tcp
    function f_exec: string;
    function f_shellexec: string;
  function f_after: string; //after(target, delim, occurence_number)
  function f_between: string; //after(target, delim, occurence_number)
  function f_before: string;
  function f_afterlast: string;
  function f_beforelast: string;
  function f_cutatlast: string;
  function f_cutat: string;
  function f_startafterlast: string;
  function f_startbeforelast: string;
  function f_startafter: string;
  function f_normalize: string;  //trims and strips multiple whitespace
  function f_concat: string;
  function f_reverse: string;
  function f_contains: string;
  function f_startswith: string;  //returns 1 or 0
  function f_endswith: string;    //returns 1 or 0
  function f_translate: string;   //see js or xpath translate -function
  function f_case: string;  //case(selector, case, string, case, string,....)
  function f_evalcase: string;  //case(selector, case, string, case, string,....)
  function f_translatewords: string;  // a bit like case, but order as in translate..
          //translate(string, 'one','two', 'three' 'yksi', kaksi', kolme')
  function f_match:string;   //regexp matching
  function f_replace:string; //regexp replace
  function f_substitute:string;  //reexp replace with templates...
    function f_gsub:string;  // global replace ?gsub(targetstring,what_to_replace,changeintowhat)
    function f_text:string;   //???
   function f_diff:string;
  //string creation
    function f_randomst: string;  //random string of 8 chars
    function f_makename:string;  //tries to build a legal, understandable short file name from a
                       // string of several words
    function f_varname:string; //like above, but will not overwrite existing varname
    function f_newfile:string;  //like above, but will not return existing file
    function f_mem: string;  //debugging
    function f_vars: string;  //debugging
    function f_started: string;  //debugging

   //lists  (commasepared strings)
   function f_item: string;
   function f_itemadd: string;
   function f_itemcount: string;
   function f_itemval: string;
   function f_setitem: string;
   function f_incitem: string;
   function f_decitem: string;

 //text conversions, special chars etc
 function f_utf8toasc:string;
 function f_trim:string;
 function f_trimright:string;
 function f_trimleft:string;
 function f_wrap:string;
 function f_entities:string;
 function f_noentities:string;
 function f_nouml:string;  //äöå
 function f_cleanspaces:string;
 function f_oneline:string;
 function f_unfold:string;
 function f_trimwhitespace:string;
 function f_whitespacespace:string;
 function f_lowercase:string;
 function f_uppercase:string;
 function f_base64encode:string;
 function f_base64decode:string;
 function f_urlencode:string;
 function f_urldecode:string;
 function f_normalizeurl:string;
 function f_nocdata:string;
 function f_cdata:string;
 function f_parsemdinlines:string;

 function f_md5:string;
 function f_absoluteurl:string;
 function f_mapurltofile:string;
 function f_mapfiletourl:string;
 function f_users: string;

 //Stuff I don't remember
   function f_rights:string;
   function f_position: string;
   function f_last: string;
  //trig
   function f_rotate:string;
   function f_rotatex:string;
   function f_rotatey:string;

 //function f_json:string;
 //function f_xml:string;
 //function f_xmlis:string;

 function execute:string;
 end;
type
 tfunc2=class(tpersistent);
 test1=class(tfunc2)
  public
    p1,p2:string;
 end;
 test2=class(tfunc2)
  public
    p1,p2,p3,p4:string;
  end;
 implementation
 uses xsemisc,xseexp,xsedif,lazutf8;

function getdatetime(p_date:string):tdatetime;
 var formset:tformatsettings;adat:tdatetime;ast:string;
 function getmnumS(st:string):STRING;
 var i:integer;
 begin
  for i:=1 to 12 do
    p_date:=StringReplace(p_date,MONTHSTR[I],INTTOSTR(I),[rfIgnoreCase]);
   RESULT:=P_DATE;
   //if monthstr[i]=st then begin result:=i;exit;end;
 end;

 begin
//formset.ShortMonthNames:= ('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec');
// formset.ShortMonthNames:= sysutils.DefaultFormatSettings.Shortmonthnames;
 //ast:=formatdatetime('DD-MMM-YYYY',now);
 //FormSet.Dateseparator:='_';
 //formset.ShortDateFormat:='DD-MMM-YYYY';
 //FormSet.timeseparator:=':';
 //writeln('<li>shoulddo:', ast);
 //adat:=strtodatetime(ast,formset);

 result:=_strtodatetime(p_date);
 exit;
{ try
 sysutils.DefaultFormatSettings.ShortDateFormat:= 'MMM/DD/YYYY';
 sysutils.DefaultFormatSettings.timeseparator:= ':';
 sysutils.DefaultFormatSettings.dateseparator:= '/';
 ast:=formatdatetime('MMM/DD/YYYY',now);
 adat:=strtodatetime(ast);
 writeln('<li>coulddo:', ast,sysutils.DefaultFormatSettings.shortmonthnames[10]);
 except writeln('<li>couldNOTdo:',ast,sysutils.DefaultFormatSettings.shortmonthnames[10]); end;
 try
 sysutils.DefaultFormatSettings.ShortDateFormat:= 'MM/DD/YYYY';
 adat:=strtodatetime('10/20/2013');
 writeln('<li>coulddo:', ast);
 except writeln('<li>couldNOTdo:', ast); end;
 try
 ast:=formatdatetime('DD MMM YYYY',now);
 FormSet.Dateseparator:=' ';
 formset.ShortDateFormat:='DD MMM YYYY';
 FormSet.timeseparator:=':';
 writeln('<li>shoulddo:', ast);
 adat:=strtodatetime(ast,formset);
 writeln('<li>coulddo:', ast);
 except writeln('<li>couldNOTdo:', ast); end;
 try
    result:=strtodatetime(p_date);
  except  //writeln('stringtodate error:'+p_date+'!local');
   formset.ShortDateFormat:='YYYY-MM-DD';
   FormSet.Dateseparator:='-';
   FormSet.timeseparator:='.';
    try
     result:=strtodatetime(p_date,formset);
    except
     //writeln('stringtodate error:'+p_date+'!ISO');
     formset.ShortDateFormat:='DD.MM.YYYY';
     FormSet.Dateseparator:='.';
     FormSet.timeseparator:=':';
      try
       result:=strtodatetime(p_date,formset);
      except
       //writeln('stringtodate error:'+p_date+'!FI');
       formset.ShortDateFormat:='MM/DD/YYYY';
       FormSet.Dateseparator:='/';
       FormSet.timeseparator:=':';
       try
         result:=strtodatetime(p_date,formset);
       except
        //Mon, 24 May 2010 17:54:00 GMT
        p_date:=StringReplace(p_date,' ','-',[rfreplaceall]);
        p_date:=GETMNUMS(p_date);
        formset.ShortDateFormat:='dd-m-yyyy';
        FormSet.Dateseparator:='-';
        FormSet.timeseparator:=':';
        writeln('<li>try rfc 2822:'+p_date+'!!!');//+formatdatetime('dd-m-yyyy',now));
        ast:=formatdatetime('dd-mm-yyyy hh:nn:ss',now);
        writeln('<li>shoulddo:', ast);
        adat:=strtodatetime(ast,formset);
        writeln('<li>coulddo:', ast);
        try
          result:=strtodatetime(p_date,formset);
        except
         //Mon, 24 May 2010 17:54:00 GMT
         p_date:=StringReplace(p_date,' ','-',[rfreplaceall]);
         p_date:=GETMNUMS(p_date);
         writeln('<li>try rfc 2822:'+p_date+'!!!');//+ formatdatetime('ddd",/dd/mmm/yy',now));
         formset.ShortDateFormat:='ddd,-dd-m-yy';
         FormSet.Dateseparator:='-';
         FormSet.timeseparator:=':';
         //ast:=formatdatetime('ddd,-dd-m-yyyy',now);
         //writeln('<li>shoulddo:', ast);
         //adat:=strtodatetime(p_date,formset);
         //writeln('<li>coulddo:', ast);
         try
           result:=strtodatetime(p_date,formset);
         except result:=0;writeln('<li>failed to parse date from: ',p_date);end;
         end;
       end;
      end;
    end;
  end;

 end;
  }
 end;

procedure regclasses;
begin
   registerclass(test1);
   registerclass(test2);

end;

function _apar(var x:string;posi:integer;pars:tstringlist):boolean;
begin
 result:=true;
 if pars.count>posi then
 begin
  x:=pars[posi];
 end else result:=false;
end;

Function namepars(var x1:string;vlist:array of string;pars:tstringlist):string;overload;
begin
 if pars.count=0 then exit;
 x1:=pars[0];
 exit;
   if pars.names[0]='' then
   begin
    _apar(x1,0,pars);
    //writeln('gotttttttttttt_'+pars[0]+'XX');
   end else
   begin
     x1:=pars.values[vlist[0]];
   end;

end;
Function namepars(var x1,x2:string;vlist:array of string;pars:tstringlist):string;overload;
begin
   if pars.count=0 then exit;
   x1:=pars[0];
   if pars.count=1 then exit;
   x2:=pars[1];
   exit;
 if pars.count=0 then exit;
   if pars.names[0]='' then
   begin
    if _apar(x1,0,pars) then
    _apar(x2,1,pars);
   end else
   begin
     x1:=pars.values[vlist[0]];
     if pars.count>1 then x2:=pars.values[vlist[1]];
   end;

end;
Function namepars(var x1,x2,x3:string;vlist:array of string;pars:tstringlist):string;overload;
var i:integer;
begin
   if pars.count=0 then exit;
   x1:=pars[0];
   if pars.count=1 then exit;
   x2:=pars[1];
   if pars.count=2 then exit;
   x3:=pars[2];
   //writeln('<li>got1: ',pars.count,'/1'+x1+'/2'+x2+'/3:'+x3+'/');
   exit;
 if pars.count=0 then exit;
   if pars.names[0]='' then
   begin
    if _apar(x1,0,pars) then
    if _apar(x2,1,pars) then
    _apar(x3,2,pars);
    //writeln(x1+'?'+pars[0]+'-');
    //writeln(x2+'?'+pars[1]+'-');
    //writeln(x3+'?'+pars[2]+'-');
   end else
   begin
     x1:=pars.values[vlist[0]];
     x2:=pars.values[vlist[1]];
     x3:=pars.values[vlist[2]];
     //except writeln('namedpars:'+pars.text,'/'vlist.count);end;
   end;

end;

function tfunc.execute:string;
var retcode:dword;
 routine:tmethod;
 exec:tfexec;acom:ttag;
begin
try
     //writeln('<h1>tryfunc '+fname+' : '+pars.text+'</h1>');
     result:='';
      routine.data:=pointer(self);
      routine.code:=self.methodaddress('f_'+fname);
      if not assigned(routine.code) then
      begin
       writeln('<!--nosuchfunc  f_'+fname +':'+pars.text+'-->');

         result:='';
         // state.did:=false;
      end else
      begin
        //result:=true;
        exec:=tfexec(routine);
        result:=exec();
       //writeln('<h1>didfunc  f_'+fname +':'+result+'</h1>');
        //state.did:=true;
        //result:=true;
        end;
      except writeln('<h3>xseus:failfunc'+fname+'</h3>');raise;end;
end;
//procedure tfunc.
 //constructor tfunc.create(fn:string;p:tstringlist;st:tstate;x:txseus);
 constructor tfunc.create(fn:string;p:tstringlist;x:txseus);
 begin
  fname:=fn;
  pars:=p;
  
 //mathtag:ttag;
 //svars:=s;evars:=e;
 //state:=st;
 xs:=x;
 //atstr:=ats;
 //pars:=tstringlist.create;
 end;
 function tfunc.f_item: string;  //with trailing separator (ie. item 0 is ignored)
  var items,no:integer; st,sep:string;
   stl:tstringlist;
  begin
    st:=pars[0];
    no:=strtointdef(pars[1],1);
     if pars.count>2 then sep:=pars[2] else if st<>'' then sep:=st[length(st)] else sep:=',';
    try
    stl:=tstringlist.create;
    items:=_split(st,sep,stl);
    if items<no then result:=''
     else result:=stl[no-1];
    //for i:=i to length(st) do
    finally
      //writeln('<li>sep:'+sep+'_'+ stl.count);
      stl.free;
    end;

  end;
function tfunc.f_parsemdinlines:string;
begin
  //result:=md2xml(pars[0]);
 end;

 function tfunc.f_itemval: string;  //with trailing separator (ie. item 0 is ignored)
  var items:integer; st,sep,vari:string;
   stl:tstringlist;
  begin
    st:=pars[0];
    vari:=pars[1];
    if pars.count>2 then sep:=pars[2] else if st<>'' then sep:=st[length(st)] else sep:=',';
    try
    stl:=tstringlist.create;
    items:=_split(st,sep,stl);
    result:=stl.values[vari];
    //for i:=i to length(st) do
    finally
      //writeln('<li>sep:'+sep+'_'+ stl.count);
      stl.free;
    end;

  end;

 function tfunc.f_setitem: string;  //
 var I,items,no:integer; st,sep:string;
  stl:tstringlist;
 begin
   st:=pars[0];
   no:=strtointdef(pars[1],1);
   if pars.count>3 then sep:=pars[3] else if st<>'' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   try
   items:=_split(st,sep,stl);
   if no<0 then no:=items+no;
   result:='';
     for i:=0 to ITEMS-2 do
       begin
        if i=no-1 then result:=result+pars[2]+sep else result:=result+stl[i]+sep;
       end;
   if no>items then
   begin
     for i:=ITEMS+1 to no do
       result:=result+sep;
     result:=result+pars[2]+sep;
   end;
   finally
     //writeln('<li>sep:'+sep+'_'+ stl.count);
     stl.free;
   end;
 end;
 function tfunc.f_itemadd: string;  //
 var I,items,no,toadd:integer; st,sep:string;
  stl:tstringlist;
 begin
   st:=pars[0];
   no:=strtointdef(pars[1],1);
   toadd:=strtointdef(pars[2],1);
   if pars.count>3 then sep:=pars[3] else if st<>'' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   try
   items:=_split(st,sep,stl);
   if no<0 then no:=items+no;
   result:='';
     for i:=0 to ITEMS-2 do
       begin
        if i=no-1 then result:=result+inttostr(strtointdef(stl[i],1)+toadd)+sep else result:=result+stl[i]+sep;
       end;
   if no>items then
   begin
     for i:=ITEMS+1 to no do
       result:=result+sep;
     result:=result+pars[2]+sep;
   end;
   finally
     //writeln('<li>sep:'+sep+'_'+ stl.count);
     stl.free;
   end;
 end;

 function tfunc.f_incitem: string;  //
 var I,items,no:integer; st,sep:string;
  stl:tstringlist;
 begin
   st:=pars[0];
   no:=strtointdef(pars[1],1);
   if pars.count>3 then sep:=pars[3] else if st<>'' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   try
   items:=_split(st,sep,stl);
   if no<0 then no:=items+no;
   result:='';
     for i:=0 to ITEMS-2 do
       begin
        if i=no-1 then result:=result+inttostr(strtointdef(stl[i],1)+1)+sep else result:=result+stl[i]+sep;
       end;
   if no>items then
   begin
     for i:=ITEMS+1 to no do
       result:=result+sep;
     result:=result+pars[2]+sep;
   end;
   finally
     //writeln('<li>sep:'+sep+'_'+ stl.count);
     stl.free;
   end;
 end;
 function tfunc.f_itemcount: string;  //
 var I,items,no:integer; st,sep:string;
  stl:tstringlist;
 begin
   st:=pars[0];
   if pars.count>2 then sep:=pars[2] else if st<>'' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   try
   result:=inttostr(_split(st,sep,stl));
   finally
     //writeln('<li>sep:'+sep+'_'+ stl.count);
     stl.free;
   end;
 end;
 function tfunc.f_decitem: string;  //
 var I,items,no:integer; st,sep:string;
  stl:tstringlist;
 begin
   st:=pars[0];
   no:=strtointdef(pars[1],1);
   if pars.count>3 then sep:=pars[3] else if st<>'' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   try
   items:=_split(st,sep,stl);
   if no<0 then no:=items+no;
   result:='';
     for i:=0 to ITEMS-2 do
       begin
        if i=no-1 then result:=result+inttostr(strtointdef(stl[i],1)-1)+sep else result:=result+stl[i]+sep;
       end;
   if no>items then
   begin
     for i:=ITEMS+1 to no do
       result:=result+sep;
     result:=result+pars[2]+sep;
   end;
   finally
     //writeln('<li>sep:'+sep+'_'+ stl.count);
     stl.free;
   end;
 end;
 function _listtotag(st,sep:string): ttag;  //
 var I,items:integer;
  stl:tstringlist;stag:ttag;
 begin
   if sep='' then sep:=st[length(st)] else sep:=',';
   stl:=tstringlist.create;
   result:=ttag.create;
   try
   items:=_split(st,sep,stl);
   for i:=0 to ITEMS-2 do
   begin
         stag:=result.addsubtag(cut_ls(stl[i]),cut_rs(stl[i]));
   end;
   //writeln('<li>created:<pre>'+ result.xmlis+'</pre>');
   finally
     stl.free;
   end;
 end;

 {    function tfunc.f_item: string;  //without leading separator
     var items,no:integer; st,sep:string;
      stl:tstringlist;
     begin
       st:=pars[0];
       no:=strtointdef(pars[1],1);
        if pars.count>2 then sep:=pars[2] else sep:=',';
       try
       stl:=tstringlist.create;
       items:=_split(st,',',stl);
       if items<no then result:=''
        else result:=stl[no-1];
       //for i:=i to length(st) do
       finally
         stl.free;
       end;

     end;

    function tfunc.f_setitem: string;  //debugging
    var I,items,no:integer; st,sep:string;
     stl:tstringlist;
    begin
      st:=pars[0];
      no:=strtointdef(pars[1],1);
      if pars.count>3 then sep:=pars[3] else sep:=',';
      stl:=tstringlist.create;
      try
      items:=_split(st,sep,stl);
      if no<0 then no:=items-no-1;
      result:='';
        for i:=0 to ITEMS-1 do
          begin
           if i=no-1 then result:=result+pars[2] else result:=result+stl[i];
           if i<items-1 then result:=result+sep;
          end;
      if no>items then
      begin
        if items>0 then result:=result+sep;
        for i:=ITEMS+2 to no do
          result:=result+sep;

        result:=result+pars[2];
      end;
      finally
        stl.free;
      end;
    end;
}
function tfunc.f_after: string;
var str,substr:string;ordo,i:integer;
 slist:tstringlist;
begin
 try
 slist:=tstringlist.create;
 result:='';
 str:=pars[0];
 if pars.count>1 then substr:=pars[1] else exit;
 if pars.count<3 then ordo:=1 else
 ordo:=strtointdef(pars[2],1);
 _split(str,substr,slist);
 if slist.count>ordo then result:=slist[ordo];
 //if slist.count>1 then for i:=slist.count-ordo+1 to slist.count-1 do result:=result+substr+slist[i];
                                 //  3    - 1 +1=4          1
    if slist.count>1 then for i:=ordo+1 to slist.count-1 do result:=result+substr+slist[i];

                                 //writeln('<li>: after:',result);

          // writeln('<li>: after1:',ordo,'/short:',substr,'/long'+str,'/parts:',slist.count,'::'+slist.text,'/<b>',RESULT,'</b>');
 finally
   slist.free;
 end;

 end;
function tfunc.f_between: string;
var str,substr:string;ordo,i:integer;
 slist:tstringlist;
begin
 try
 slist:=tstringlist.create;
 result:='';
 str:=pars[0];
 if pars.count>1 then substr:=pars[1] else exit;
 if pars.count<3 then ordo:=1 else
 ordo:=strtointdef(pars[2],1);
 _split(str,substr,slist);
 if slist.count>ordo then result:=slist[ordo];

 finally
   slist.free;
 end;

 end;

 function tfunc.f_afterlast: string;
 var str,substr:string;ordo,i:integer;
  slist:tstringlist;
 begin
  try
    slist:=tstringlist.create;
  result:='';
  str:=pars[0];
  if pars.count>1 then substr:=pars[1] else exit;
  if pars.count<3 then ordo:=1 else
  ordo:=strtointdef(pars[2],1);
  _split(str,substr,slist);
  if slist.count>ordo then result:=slist[slist.count-ordo];
  if slist.count>1 then for i:=slist.count-ordo+1 to slist.count-1 do result:=result+substr+slist[i];

  finally
    slist.free;
  end;

  end;

 function tfunc.f_startafter: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=pos(pars[1],pars[0]);
    if ordo<1 then
      result:=pars[0] else result:=copy(pars[0],ordo+1,length(pars[0]));
 end;
 function tfunc.f_startafterlast: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=_poslast(pars[1],pars[0]);
    if ordo<1 then
      result:=pars[0]
    else result:=copy(pars[0],ordo+1,length(pars[0]));
 end;
 function tfunc.f_startbeforelast: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=_poslast(pars[1],pars[0]);
    if ordo<1 then
      result:=pars[0]
    else result:=copy(pars[0],1,ordo-1);
 end;
 function tfunc.f_cutat: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=pos(pars[1],pars[0]);
    if ordo<1 then
      result:=pars[0] else result:=copy(pars[0],1,ordo-1);
 end;
 function tfunc.f_cutatlast: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=_poslast(pars[1],pars[0]);
    if ordo<1 then  result:=''
    else result:=copy(pars[0],1,ordo-1);
 end;
 function tfunc.f_beforelast: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=_poslast(pars[1],pars[0]);
    if ordo<1 then
      result:=''
    else result:=copy(pars[0],1,ordo-1);
    //writeln('<li>beflast',pars
 end;
 function tfunc.f_before: string;
 var str,substr:string;ordo,i:integer;elsest:boolean;
 begin
    result:='';
    if pars.count<2 then exit;
    ordo:=pos(pars[1],pars[0]);
    if ordo<1 then
    begin
         if pars.Count>2 then result:=pars[0] else result:='';
      //   if elsest then result:=pars[0] else
      //result:=''
    end
    else result:=copy(pars[0],1,ordo-1);
    //writeln('<li>before:'+pars[0],'/',pars[1],'('+pars[2]+')'+result);
 end;
{ function tfunc.f_before: string;
 var str,substr:string;ordo,i:integer;
  slist:tstringlist; //par1=instrig //par2=text to find //par3=how 'manieth' (if 0 then
 begin
  try
    slist:=tstringlist.create;
    result:='';
    str:=pars[0];
    if pars.count>1 then substr:=pars[1] else exit;
    if pars.count<3 then ordo:=1 else
     ordo:=strtointdef(pars[2],1);
    _split(str,substr,slist);
    if slist.count<2 then
     begin if ordo=0 then result:=str else result:=''
     end
    else
    begin
     result:=slist[0];
     if slist.count>ordo then
      for i:=1 to ordo-1 do result:=result+substr+slist[i];
     end;
  finally
    slist.free;
  end;

  end;


 function tfunc.f_beforelast: string;
 var str,substr:string;ordo,i:integer;
  slist:tstringlist;
 begin
  try
    slist:=tstringlist.create;
  result:='';
  str:=pars[0];
  if pars.count>1 then substr:=pars[1] else exit;
  if pars.count<3 then ordo:=1 else
  ordo:=strtointdef(pars[2],1);
  _split(str,substr,slist);
  ordo:=slist.count-ordo;
  if slist.count>1 then result:=slist[0];
  if slist.count>ordo then
   for i:=1 to ordo-1 do result:=result+substr+slist[i];

  finally
    slist.free;
  end;

  end;
 }
 function tfunc.f_normalize: string;
  begin
      Result := _normalizewhitespace(pars[0], False);
   end;
 function tfunc.f_concat: string;
 var i:integer;
 begin
 for i:=0 to pars.count-1 do
       Result := Result + pars[i];
  end;
 function tfunc.f_reverse: string;
  var x1,x2:widestring;i:integer;
  begin
   x1:=pars[0];result:='';
   for i:=1 to length(x1) do result:=x1[i]+result;
  end;
   function tfunc.f_contains: string;
 var x1,x2:string;
 begin
  x1:=pars[0];
  if pars.count>1 then x2:=pars[1] else x2:='';
  if pos(x2,x1)>0 then result:='1' else result:='0';
  //writeln('<li>contains?:',pars[0],'??',pars[1],result,'</li>');
 end;

 function tfunc.f_startswith: string;
 var x1,x2:string;
 begin
  x1:=pars[0];
  if pars.count>1 then x2:=pars[1] else x2:='';
  if pos(x2,x1)=1 then result:='1' else result:='0';
 end;
 function tfunc.f_endswith: string;
 var x1,x2:string; lendif:integer;
 begin
  x1:=pars[0];
  if pars.count>1 then x2:=pars[1] else x2:='';
  lendif:=length(x1)-length(x2);
  if lendif>=0 then if copy(x1,lendif+1,length(x2))=x2 then  result:='1'
   else result:='0';
 end;
 function tfunc.f_case: string;
 var mat:string;i:integer;
 begin
  result:='';
  mat:=pars[0];
  i:=2;
  //writeln('<li>',i,'/test:','?',mat,'/by{',txseus(xs).curbyele.head,'}  /from',txseus(xs).curfromele.head,'<ul>');
  while i<pars.count do
  begin
    //writeln('<li>',i,'/test',pars[i-1],'?',mat,'(',pars[i],')');
    if pars[i-1]=mat then
    begin
      //writeln('/found');
      result:=pars[i];
      break;
   end
   else i:=i+2;
  end;
  //writeln('<li>',result,'</li></ul>');
 end;
 function tfunc.f_evalcase: string;
 var mat,atest:string;i:integer;
 begin
  result:='';
  mat:=pars[0];
  i:=2;
  //writeln('<li>','/EVALCASE:','?',mat,'/PARS',pars.count,'!!!<ul>');
  while i<pars.count do
  begin
   atest:=mat;
   _sub('!',''''+pars[i]+'''',atest);
    //writeln('<li>',i,'/unparsed',atest,'?');
    atest:=parsefromele(txseus(xs).CurFromEle,atest);
    //writeln('<li>',i,'/parsed:',atest,'=='+pars[i],'?');
    if '1'=atest then
    begin
      //writeln('/found',pars[i],'=',pars[i-1]);
      result:=pars[i-1];
      break;
   end
   else i:=i+2;
  end;
  //writeln('<li>got:',result,'/from:',txseus(xs).CurFromEle.head,'</li></ul>');
 end;

 function tfunc.f_translate: string;
 const parlist:array[0..2] of string =('p_target','p_keys','p_reps');

{D: Does not work
}
 var st1,st2:tstringlist;hit,i,lentar,lenrep:integer;
  p_target,p_keys,p_reps:string;
 begin
 try
  result:='';
  namepars(p_target,p_keys,p_reps,parlist,pars);
  lentar:=length(p_target);
  lenrep:=length(p_reps);
  writeln('<li>translate:'+p_target+' with '+p_keys+' to '+ p_reps+'/'+pars.text);
  for i := 1 to Lentar  do
  begin
    hit:=pos(p_target[i],p_keys);
    writeln(p_target[i],hit,'-');
    if hit>0 then
    begin
     if hit<=lenrep then result:=result+p_reps[hit]
     //else result:=result+inttostr(hit) //continue
    end
    else result:=result+p_target[i];
  end;
 except
     writeln('failed translate '+pars.Text);
 end;
   //  writeln('Translated '+p_target+inttostr(lentar)
   //  +' keys:'+p_keys+'reps:'
   //  +p_reps+inttostr(lenrep)+'  :'+pars.text,pars.count);
end;
 function tfunc.f_translatewords: string;
 const parlist:array[0..2] of string =('p_target','p_keys','p_reps');

{D: as translate, but with space separated words instead of chars
 - probably useless
}
 var st1,st2:tstringlist;hit,i,lentar,lenrep:integer;
  p_target,p_keys,p_reps:string;
  tarlist,keylist,repslist:tstringlist;
 begin
 try
 try
  namepars(p_target,p_keys,p_reps,parlist,pars);
  tarlist:=tstringlist.create;
  keylist:=tstringlist.create;
  repslist:=tstringlist.create;
 _split(p_target,' ',tarlist);
 _split(p_keys,' ',keylist);
 _split(p_reps,' ',repslist);
  lentar:=tarlist.count;
  lenrep:=repslist.count;
  for i := 0 to Lentar-1  do
  begin
    hit:=keylist.IndexOf(tarlist[i]);
    if hit>0 then
     if hit<lenrep then result:=result+' '+repslist[hit]
     else continue
    else result:=result+' '+tarlist[i];
  end;
 finally
   keylist.Free;repslist.Free;tarlist.Free;
 end;
 except
     writeln('failed translate '+pars.Text);
 end;
end;



 // type params=(x,y,z);
 function tfunc.f_substr:string;
 const parlist:array[0..2] of string =('string','start','len');
 {D:simple normal substring
 }
 var p_string,p_sta,p_len:string; //+no others
  len,sta:integer;
 //sta,sto,len,cut,olen:integer;st:string;apui,ires:integer;
// params:(xstr,xlen,xpos);
 begin
  namepars(p_string,p_sta,p_len, parlist,pars);
  len:=strtointdef(p_len,length(p_string));
  sta:=strtointdef(p_sta,1);
  if len<0 then len:=length(p_string)+len;
  //writeln('<li>substr:',p_string,'/sta', sta,'/len;',len, '/res:',copy(p_string,sta,len-sta)+'!plen:'+p_len);
 if sta<0 then sta:=length(p_string)+sta;

  result:=copy(p_string,sta,len); //+'/'+p_string+'_'+inttostr(len)+'_'+p_sta;
  //writeln('<li>',p_string,'/sta:',sta,'/len:',len, '!',result+'!'+pars.text);
 end;

 function tfunc.f_slice:string;
 const parlist:array[0..2] of string =('string','start','len');
 {D:simple normal substring
 }
 var p_string,p_sta,p_end:string; //+no others
  en,sta:integer;
 //sta,sto,len,cut,olen:integer;st:string;apui,ires:integer;
// params:(xstr,xlen,xpos);
 begin
  namepars(p_string,p_sta,p_end, parlist,pars);
  en:=strtointdef(p_end,length(p_string));
  if en<0 then en:=length(p_string)+en;
  writeln('<li>',p_string, sta,' ',en, '!',copy(p_string,sta,en-sta)+'!'+p_end);
  sta:=strtointdef(p_sta,1);
  if sta<0 then sta:=length(p_string)+sta;
  result:=copy(p_string,sta,en-sta);//+'/'+p_string+'_'+inttostr(len)+'_'+p_sta;
 end;


 function tfunc.f_rights:string;
 var dir,role,domain:string;
 begin
  dir:=pars[0];
  if pars.count>1 then role:=pars[1] else role:='';
  if pars.count>2 then domain:=pars[2] else domain:='';
  if _testrights(xs.x_session, dir, role, domain) then result:='1' else  result:='0';
  //function _testrights(session:ttag;dir,role,by:string):boolean;
 end;

 function tfunc.f_users:string;
  const parlist:array[0..2] of string =('','','');
 {D: part of a long-forgotten system for specifuing user names and righs etc
 in different "domains"
 }
 begin
   result:=xs.x_config.subs('userdomains/dir[@name='+cut_rs(pars.strings[0])+']/@dir')
 end;

 function tfunc.f_fileexists:string;
 begin
  if fileexists(pars[0]) then result:='1' else result:='0';
 end;

 function tfunc.f_not:string;
 begin
  if strtointdef(pars[0],0)>0 then result:='0' else result:='1';
  //writeln('<li>not:', pars[0],'=',result);
 end;
 function tfunc.f_or:string;
 var i:integer;
 begin
 result:='0';
  for i:=0 to pars.count-1 do
    if pars[i]='1' then
    begin
      result:='1';
      exit;
    end;
 end;
 function tfunc.f_and:string;
 var i:integer;
 begin
 result:='1';
 for i:=0 to pars.count-1 do
   if pars[i]='0' then
   begin
     result:='0';
     exit;
   end;
 end;

 function tfunc.f_if:string;
  var i:integer;
  var x1,x2,test,ifval,elseval:string;
   begin
    i:=1;
     //t_debug:=true;
     {INFIX   test:=_p_infix(pars[0],i,xs,'');}
     test:=parsefromele(xs.curfromele,pars[0]);
     //t_debug:=false;
     ifval:=pars[1];
     elseval:=pars[2];
     if test='1' // if(test,x1,x2,xs)
       then result:=ifval else result:=elseval;
     //writeln('<li>if:'+pars[0]+'/x1='+pars[1]+'/x2='+pars[2]+'?',result);

 end;
 function tfunc.f_eq:string;
  var x1,x2,test:string;
   begin
  // writeln('<li>EQUALS: ','!',pars.text,'/',pars.count,'</li>');
   if pars.count<2 then result:='=' else
   begin
     x1:=pars[0];
     x2:=pars[1];
     if x1=x2 then result:='1' else result:='0';
     //writeln('<li>EQ?<code>/x1:',x1, '/x2:',x2, '/res:',result+'</code></li>');
   end;
  end;
 function tfunc.f_ne:string;
  var x1,x2,test:string;
   begin
   //writeln('<li>EQUALS: ','<pre>',pars.text,'</pre>',pars.count,'</li>');
   if pars.count<2 then result:='=' else
   begin
     x1:=pars[0];
     x2:=pars[1];
     if x1=x2 then result:='0' else result:='1';
     //writeln('x1:',x1, 'x2:',x2, 'res:',result,'<pre>',pars.text,'</pre>');
   end;
  end;

 function tfunc.f_gt:string;
  var x1,x2:string;i1,i2:integer;
   begin
     //writeln('<li>gt:',pars.count);

     if pars.count<1 then result:='>' else
     begin
      if pars.count=1 then pars.add('=0');
     x1:=pars[0];
     x2:=pars[1];
     try
         i1:=strtoint(x1);
         i2:=strtoint(x2);
        if i1>i2 then result:='1' else result:='0';
     except
      if x1>x2 then result:='1' else result:='0';
     end;


     end;
 end;
 function tfunc.f_lt:string;
  var x1,x2,test:string;i1,i2:integer;
   begin
     if pars.count<1 then result:='<' else
     begin
       if pars.count=1 then pars.add('=0');
     x1:=pars[0];
     x2:=pars[1];
     try
         i1:=strtoint(x1);
         i2:=strtoint(x2);
        if i1<i2 then result:='1' else result:='0';
     except
      if x1<x2 then result:='1' else result:='0';
      //writeln('<li>ST:',x1,'<',x2);
     end;
    //writeln('<li>',i1,'<',i2,'=',result);
    end;
 end;
 function tfunc.f_gte:string;
  var x1,x2,test:string;i1,i2:integer;
   begin
     if pars.count<1 then exit else
     begin
     if pars.count=1 then pars.add('=0');
     x1:=pars[0];
     x2:=pars[1];
     try
         i1:=strtoint(x1);
         i2:=strtoint(x2);
        if i1>=i2 then result:='1' else result:='0';
     except
      if x1>=x2 then result:='1' else result:='0';
     end;


     end;
 end;
 function tfunc.f_lte:string;
  var x1,x2,test:string;i1,i2:integer;
   begin
     if pars.count<1 then exit  else
     begin
     if pars.count=1 then pars.add('=0');
     x1:=pars[0];
     x2:=pars[1];
     try
         i1:=strtoint(x1);
         i2:=strtoint(x2);
        if i1<=i2 then result:='1' else result:='0';
     except
      if x1<=x2 then result:='1' else result:='0';
     end;


     end;
 end;

 function tfunc.f_isinline:string;
  var i:integer;
 begin
     if pos('<'+pars[0]+'>',gc_inlineelems)>0 then result:='1' else result:='0';
     //writeln('<li>isinline:',pars[0],'/',result);
 end;
 function tfunc.f_isblock:string;
  var i:integer;
 begin
     if pos('<'+pars[0]+'>',gc_blockelems)>0 then result:='1' else result:='0';
     //writeln('<li>isblock:',pars[0],'/',result);
 end;
 function tfunc.f_isnamechar:string;
  var i:integer;
 begin
    // if pos('<'+pars[0]+'>',c_namchar)>0 then result:='1' else result:='0';
     for i:=1 to length(pars[0]) do writeln('<li>isblock:',pars[0][i],pars[0][i] in gc_namechars,'/');
 end;
 function tfunc.f_position:string;
  var i:integer;
 begin
  if xs.curselectionset<> nil then
  begin
 result:=IntToStr(xs.curselectionset.indexof(xs.CurFromEle)+1);
  //if t_debug then
  //writeln('<li>POS:',xs.curfromele.vari+xs.curfromele.vaLi,'=',result,'!',xs.curselectionset.count,'</li>');
 //for i:=0 to xs.curselectionset.count-1 do writeln('!',ttag(xs.curselectionset[i]).vari);
 end
 else
 result:=IntToStr(xs.curfromele.parent.subtags.indexof(xs.CurFromEle)+1);
 end;
 function tfunc.f_last:string;
  var i:integer;
 begin
  if xs.curselectionset<> nil then
  begin
 result:=IntToStr(xs.curselectionset.count);
 end
 else
 result:=IntToStr(xs.curfromele.parent.subtags.count);
 end;
 function tfunc.f_mem:string;
 begin
 result:=IntToStr(getheapstatus.totalallocated div
                   1000)+'els:'+inttostr(elements_created-elements_freed)+' ela:'+inttostr(elements_created);//+' s:'+inttostr(xs.states.count);
 end;
 function tfunc.f_vars:string;
 begin
   result:=txseus(xs).x_svars.text;
 end;
 function tfunc.f_started:string;
 var i:integer;sts:tstarted;
 begin
   sts:=txseus(xs).x_started;
   result:=inttostr(sts.count)+':';
   for i:=0 to sts.count-1 do
    result:=result+'['+ttag(sts.elems[i]).vari+'/'+ttag(sts.pars[i]).vari+']';
 end;

 function tfunc.f_copy:string;
 begin
  result:=pars[0];

 end;

function tfunc.f_substitute:string;
 {D: Find "exp" in "in" and place the occurances to $0,$1 etc. in template given in param 3

  -example: ?substitute(in='0/11/2004';exp='([0123456789].]\/([0123456789].]\/([0123456789].]';tpl='$3-$1-$2'
  formats mm/dd/yyyy string to ISO-format
 }

const parlist:array[0..2] of string =('exp','in','tpl');
var p_exp,p_ins,p_tpl,p_rep:string;
 r:tregexpr;i:integer;
  begin
   namepars(p_exp,p_ins,p_tpl,parlist,pars);
  // writeln('exp:',p_exp,' in:',p_ins,' tpl:',p_tpl,' all:',pars.text);
  r := TRegExpr.Create;
   try
     //r.Expression := pars.values['exp'];
     r.Expression := p_exp;
    // if r.Exec(pars.values['in']) then
    if r.Exec(p_ins) then
       Result := r.substitute(p_tpl)
       //Result := r.substitute(pars.values['tpl'])
       else result:=p_rep;

    //for i:=0 to length(r.match) do
    //writeln('*',r.match[0])
    finally r.Free;
   end;
  end;

function tfunc.f_replace:string;
const parlist:array[1..4] of string =('exp','in','rep','subs');
 {D: find and replace by regexp. Find "exp" in "in" and replace with "rep"
   if subs="true", something different is done?
 }
var p_exp,p_in,p_rep,p_subs:string;
 r:tregexpr;
 begin
   namepars(p_exp,p_in,p_rep,parlist,pars);
  r := TRegExpr.Create;
   try
     r.Expression := p_exp;
     if r.Exec(p_in) then
       Result := r.replace(p_in,p_rep,p_subs='true')
       //Result := r.substitute(pars.values['rep'])
       else result:=p_rep;
    finally r.Free;
   end;
  end;
function tfunc.f_diff:string;
begin
result:=dodif(pars[0],pars[1]).text;

end;

function tfunc.f_match:string;
const parlist:array[0..2] of string =('exp','in','match');
{D: regular expression match
 returns first match of expression given in "exp"-param in "in"-param
 or if match-parameter is specified, the match no. specified by that.
 Negative number specifies that counting starts from end
 If expression contains subexpressions (parentheses-limited parts)
 they are returned concatenated
-uses: Andrey V. Sorokin's regexp library
-example:  xse:?match(in='c:\hui\hai\hei\index.html';exp='(.*\\.*)\\.*\\.*')
 cuts everything after second last \
 }
var p_exp,p_in,p_match:string;
r:tregexpr;i,j,mati:integer;
 reslist:tstringlist;resu:string;
begin
 //writeln('xxxxx');
 //exit;
  namepars(p_exp,p_in,p_match,parlist,pars);
  // writeln('<xmp>reg:('+  p_exp+') in ('+p_in+')</xmp>');
 reslist:=tstringlist.create;
 r := TRegExpr.Create;
 mati:=strtointdef(p_match,1)-1;
  try
     r.Expression := p_exp;
     if r.Exec (p_in) then
      REPEAT
       if r.SubExprMatchCount=0 then
       begin
         IF R.match[0]<>'' then
             Reslist.add(r.Match[0])
       end
       else
       begin
          resu:='';
          for i:=1 to r.SubExprMatchCount do
          begin
           IF R.match[i]<>'' then
              Resu:=resu+(r.Match[i]);//+ ',';;
          end;
          if resu<>'' then reslist.add(resu+'');
       end;
      UNTIL not r.ExecNext;
      //for i := 0 to resList.Count - 1 do
      //  writeln('R*',i,'"',reslist[i],'"',r.expression,p_in);
      if mati<0 then
        mati:=reslist.count+mati+1; //note xseus is 1-based,pascal/regexp 0-based
       if reslist.Count>mati then
        result:=reslist[mati] else result:='';
        //writeln('....'+result,reslist.Count);
    finally r.Free;
   end;
end;


 function tfunc.f_text:string;
 const parlist:array[0..0] of string =('text');
  {D: return text of first param. Quite unnecessary - all param vals are text anyway
  }
  begin
      result:=(pars[0]);
      //result:=cut_par(pars[0]);
  end;

 function tfunc.f_filesize:string;
const parlist:array[0..0] of string =('file');
 {D:returns size of given file in bytes. Requires full filename. Does not check
  for any rights!
 }
 var sr:tsearchrec;apui,ires:integer;
  begin
     //apui:=FindFirstUTF8(cut_par(pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     //apui:=FindFirst(cut_par(pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     apui:=FindFirst((pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     if apui=0 then
      result:=inttostr(sr.size) else result:='-1';
  end;

 function tfunc.f_filedate:string;
 const parlist:array[0..0] of string =('file');
 {D:returns date of given file in servers datetimeformat (need rewriting to allow for other formats).
  Requires full filename. Does not check
  for any rights!
 }
 var sr:tsearchrec;apui,ires:integer;
  begin
     //!!apui:=FindFirstUTF8(cut_par(pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     //apui:=FindFirst(cut_par(pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     apui:=FindFirst((pars[0]), faanyfile, sr); { *Converted from FindFirst*  }
     if apui=0 then
      result:=datetimetostr(filedatetodatetime(sr.time)) else result:='-1';
  end;

 function tfunc.f_inc:string;
 const parlist:array[0..1] of string =('base','by');
 {D: short for plus(x,1) - unnecessary
 }
 var p_base,p_by:string;
 sr:tsearchrec;apui,ires:integer;
  begin
  namepars(p_base,p_by,parlist,pars);
   // ires:=strtointdef(svars.values[mathtag.att('var')],0)
   // +strtointdef(cut_rs(pars.values['by')),1);
    //ires:=strtointdef(svars.values[pars.values['var']],0)
    //+strtointdef(pars.values['by'],1);
    //result:=inttostr(strtointdef(cut_rs(pars.strings[0]),0));
    ires:=strtointdef(p_base,0)+
    strtointdef(p_by,1);
    result:=inttostr(ires);
   end;

 function tfunc.f_plus:string;
 const parlist:array[0..0] of string =('unlimited unnamed pars');
 {D: adds all parameters (if intgegers)
 }
 var i:integer;apu:string;apui,ires:integer;
  begin
    ires:=0;
    //listwrite(mathtag);
    for i:=0 to pars.count-1 do
    BEGIN
     try
     //ires:=ires+strtointdef(cut_rs(pars.strings[i]),0);

     ires:=ires+strtointdef(pars[i],0);
     //writeln(strtointdef(pars[i],0),'/',pars[i],'=',ires,'+');
     except   _h1('PLUS failed'+pars.text);raise; end;
    END;
     try
    apu:=inttostr(ires);
     except on ERR: Exception do
     BEGIN
      _h1('PLUS failedinres'+Err.Message);
      writeln(inttostr(ires), ERR.HelpContext);
      raise; end;
      END;
     result:=apu;
    //writeln('[plus:'+pars.Text+'=',result+']');
     end;

 function tfunc.f_fplus:string;
  const parlist:array[0..0] of string =('unlimited unnamed pars');
 {D: floating point substraction. Substacts all other params from first one
 }
 var i:integer;fres:double;
  begin
  //if pars.count>0 then fres:=strtofloat(cut_par(pars[0]));
  if pars.count>0 then fres:=strtofloat((pars[0]));
  for i:=1 to pars.count-1 do
   fres:=fres-strtofloat(cut_par(pars[i]));
   result:=floattostr(fres);
  end;
 function tfunc.f_fminus:string;
  const parlist:array[0..0] of string =('unlimited unnamed pars');
 {D: floating point substraction. Substacts all other params from first one
 }
 var i:integer;fres:double;
  begin
  if pars.count>0 then fres:=strtofloat((pars[0]));
  for i:=1 to pars.count-1 do
   fres:=fres-strtofloat((pars[i]));
   result:=floattostr(fres);
  end;


 function tfunc.f_minus:string;
  const parlist:array[0..0] of string =('unlimited unnamed pars');
 {D: INTEGER substraction. Substacts all other params from first one
 }
 var i:integer;apui,ires:integer;
 begin
  if pars.count>0 then ires:=strtointdef((pars[0]),0);
  for i:=1 to pars.count-1 do
   ires:=ires-strtointdef((pars[i]),0);
   result:=inttostr(ires);
   //writeln(pars.count,'////minus:'+ pars.text+'??',result);

  end;

 function tfunc.f_times:string;
 const parlist:array[0..0] of string =('UU');
 {D: float multiplication, multipleis all given params regardless of param name
 }
 var i:integer;fres:double;
 begin
   fres:=1;
   for i:=0 to pars.count-1 do
   begin
   try
    fres:=fres*strtofloat(pars[i]);
    except result:='*';break; end;
    end;
    if result<>'*' then result:=inttostr(round(fres)) else result:='';
 end;

 function tfunc.f_sqrt:string;
 const parlist:array[0..0] of string =('UU');
 {D: float multiplication, multipleis all given params regardless of param name
 }
 var i:integer;fres:double;
 begin
   try
    result:=inttostr(round(sqrt(strtointdef(pars[0],1))));
    fres:=cos(1);
   except result:='*'; end;
 end;
 function tfunc.f_rotate:string;
 const parlist:array[0..0] of string =('UU');
 {D: float multiplication, multipleis all given params regardless of param name
 }
 var i:integer;fang,fres:double; ang,cx,cy,r:integer;
 begin
   try
   ang:=strtoint(pars[0]);
   fang:=(ang/180)*pi;
    except ang:=0;end;
    try
    r:=strtoint(pars[1]);
    except r:=100;end;
    try
    cx:=strtoint(pars[2]);
     except cx:=0;end;
     try
    cy:=strtoint(pars[3]);
  except cy:=0;end;
   // writeln('<li>radians:',floattostr(cy+r*sin(fang)));
   // writeln('<li>x:',floattostr(cx+r*cos(fang)));
   // writeln('<li>y:',floattostr(cy+r*sin(fang)));
    writeln('<div style="color:red;background:black;position: absolute;left:',floattostr(cx+r*cos(fang)),'px;top:',floattostr(cy+r*sin(fang)),'px">',inttostr(ang),'</div>');
//    (a+rcos(θ+ϕ),b+rsin(θ+ϕ))
 end;
 function tfunc.f_rotatex:string;
 const parlist:array[0..0] of string =('UU');
 {D: float multiplication, multipleis all given params regardless of param name
 }
 var i:integer;fang,fres:double; ang,cx,r:integer;
 begin
   try
   ang:=strtoint(pars[0]);
   fang:=(ang/180)*pi;
    except ang:=0;end;
    try
    r:=strtoint(pars[1]);
    except r:=100;end;
    try
    cx:=strtoint(pars[2]);
     except cx:=0;end;
     //try
     // cy:=strtoint(pars[3]);
     //except cy:=0;end;
   //writeln('<li>radians:',floattostr(fang));
   //writeln('<li>r:',floattostr(r));
   //writeln('<li>x:',floattostr(cx));
   // writeln('<li>y:',floattostr(cy+r*sin(fang)));
   // writeln('<div style="color:red;background:black;position: absolute;left:',floattostr(cx+r*cos(fang)),'px;top:',floattostr(cy+r*sin(fang)),'px">',floattostr(fang),'</div>');
//    (a+rcos(θ+ϕ),b+rsin(θ+ϕ))
  result:=inttostr(round(cx+r*cos(fang)));
  //writeln('<li>RES:',result);

 end;
 function tfunc.f_rotatey:string;
 const parlist:array[0..0] of string =('UU');
 {D: float multiplication, multipleis all given params regardless of param name
 }
 var i:integer;fang,fres:double; ang,cy,r:integer;
 begin
   try
   ang:=strtoint(pars[0]);
   fang:=(ang/180)*pi;
    except ang:=0;end;
    try
    r:=strtoint(pars[1]);
    except r:=100;end;
   // try
   // cx:=strtoint(pars[2]);
   //  except cx:=0;end;
     try
    cy:=strtoint(pars[2]);
  except cy:=0;end;
   // writeln('<li>radians:',floattostr(cy+r*sin(fang)));
   // writeln('<li>x:',floattostr(cx+r*cos(fang)));
   // writeln('<li>y:',floattostr(cy+r*sin(fang)));
    //writeln('<div style="color:red;background:black;position: absolute;left:',floattostr(cx+r*cos(fang)),'px;top:',floattostr(cy+r*sin(fang)),'px">',floattostr(fang),'</div>');
    result:=inttostr(round(cy+r*sin(fang)))
    //    (a+rcos(θ+ϕ),b+rsin(θ+ϕ))
 end;




 function tfunc.f_unfold:string;
 const parlist:array[0..0] of string =('');
{D: ??? cleans linebreaks.. (rearreanges stringlists that have strings containing cr/lf)
internally needed, but is it needed as a xseus-function?
}
 begin
  RESULT:=_unfold((pars[0]));
 end;

function tfunc.f_isnum:string;
begin
  try
  strtoint(pars[0]);
  result:='1';
  except
   result:='-1';
  end;
end;
 function tfunc.f_num:string;
 const parlist:array[0..0] of string =('num');
{D: cleans up floating point numbers.
 maybe needed in special cases where input contains floats in exotic formats
}
 var p_num:string;fres:double;
 begin
   namepars(p_num,parlist,pars);
  try
  fres:=strtofloat(p_num);
  except
    p_num:=trim((pars[0]));

    p_num:=StringReplace(p_num,',','.',[rfreplaceall]);
    fres:=strtofloatdef(p_num,0);
  end;
  result:=floattostrf(fres,ffgeneral,5,0);
 end;

 function tfunc.f_random:string;
 const parlist:array[0..0] of string =('range');
{D: RANDOM INTEGER between 0 and 1000 - or other nubber given as first param
}
 var p_range:string;
 apui,ires:integer;
begin
namepars(p_range,parlist,pars);
if pars.count>0 then ires:=strtointdef(p_range,1000)
 else ires:=1000;
result:=inttostr(random(ires));
end;

 function tfunc.f_max:string;
 const parlist:array[0..0] of string =('unlimited unnamed');
{D: returns the largest of given integers.
 No float-version yet
}
 var i,ires:integer;
 begin
 if pars.count>0 then ires:=strtointdef((pars[0]),0);
 for i:=1 to pars.count-1 do
  if ires<strtointdef(pars[i],0) then ires:=strtointdef((pars[i]),0);
  result:=inttostr(ires);
  end;

 function tfunc.f_min:string;
 const parlist:array[0..0] of string =('unlimited unnamed');
{D: returns the smallest of given integers
 No float-version yet
}
 var i,ires:integer;
 begin
 if pars.count>0 then ires:=strtointdef((pars[0]),0);
 for i:=1 to pars.count-1 do
  if ires>strtointdef(pars[i],0) then ires:=strtointdef(pars[i],0);
  result:=inttostr(ires);
  end;

 function tfunc.f_fdiv:string;
 const parlist:array[0..0] of string =('UU');
{D: float division. Devides first par by next (and for some reason, also extra pars if given
}
 var i:integer;fres:double;
 begin
 if pars.count>0 then
 begin
 try
  fres:=strtofloat((pars[0]));
 except
     fres:=0;
 end;
 end;
 for i:=1 to pars.count-1 do
  try
  fres:=fres/strtofloat((pars[i]));
  //writeln('fdiv:',(pars[0]),'/',(pars[i]),'=',floattostr(fres));
  except

  end;
  result:=floattostr(fres);
  end;

 function tfunc.f_ftimes:string;
 const parlist:array[0..0] of string =('UU');
{D: float multiplication. multiplies all given params
}
 var i:integer;fres:double;
 begin
 if pars.count>0 then fres:=strtofloat((pars[0]));
 for i:=1 to pars.count-1 do
  fres:=fres*strtofloat((pars[i]));
  result:=floattostr(fres);
  end;

 function tfunc.f_div:string;
 const parlist:array[0..0] of string =('UU');
{D: integer division. Devides first par by next and returns integer of result
}
 begin
  try
   result:=inttostr(
     strtointdef((pars[0]),0)
      div
     strtointdef((pars[1]),0)
   );

  except writeln('<!--failed in division-->');//raise;
   ;end;
 end;

 function tfunc.f_mod:string;
 const parlist:array[0..1] of string =('div','by');
{D: integer modulus. Devides first par by next and returns modulus (jakojäännös) of result
}
var p_div,p_by:string;
 begin
 try
 //writeln('<li>calc modulus['+pars.text+']</li>');
namepars(p_div,p_by,parlist,pars);
//writeln('divx{'+p_div+'} /by',p_by);
 //writeln('calc modulus'+pars.text);
 result:=inttostr(
    strtointdef(p_div,0)
  mod
   strtointdef(p_by,1));
 //writeln('<li>modulus('+pars.text+')=',result);
 except writeln('could not calc modulus');

 end;
 end;
 function tfunc.f_incsecs:string;
  const parlist:array[0..1] of string =('date','add');
 {D: date addition, param "add" in seconsd, "date" in system format
 to be integrated into some more general function
 }
  var p_date,p_add:string;
  begin
  //writeln('INCS:',pars.Count,pars.Text);
  if pars.count=0 then  result:=datetimetostr(now) else
  begin
    if pars.count=1 then  result:=datetimetostr((now+strtointdef(pars[0],0)/(24*60*60)))  else
       result:=datetimetostr(getdatetime(pars[1])+strtointdef(pars[0],0)/(24*60*60));
   end;
  end;

 function tfunc.f_incmins:string;
 const parlist:array[0..1] of string =('date','add');
 {D: date addition, param "add" in minutes, "date" in system format
 to be integrated into some more general function
 }
 var p_date,p_add:string;
 begin
 //namepars(p_date,p_add,parlist,pars);
 if pars.count=0 then  result:=datetimetostr(now) else
 begin
   if pars.count=1 then  result:=datetimetostr(now+strtointdef(pars[0],0)/(24*60))  else
      result:=datetimetostr(getdatetime(pars[1])+strtointdef(pars[0],0)/(24*60));
  end;
 end;

 function tfunc.f_inchours:string;
 const parlist:array[0..1] of string =('date','add');
 {D: date addition, param "add" in minutes, "date" in system format
 to be integrated into some more general function
 }
 var p_date,p_add:string;
 begin
 if pars.count=0 then  result:=datetimetostr(now) else
 begin
   if pars.count=1 then  result:=datetimetostr((now+strtointdef(pars[0],0)/(24)))  else
      result:=datetimetostr(getdatetime(pars[1])+strtointdef(pars[0],0)/(24));
  end;
END;

{ namepars(p_date,p_add,parlist,pars);
 try
 result:=datetimetostr((vartodatetimex(p_date)
 +strtointdef(p_add,0)/(60)));
 except result:=datetimetostr(now);end;
 end;                                  }


 function tfunc.f_incdays:string;
 const parlist:array[0..1] of string =('date','add');
{D: date addition, param "add" in days, "date" in system format
to be integrated into some more general function
}
var p_add,p_date:string;
 begin
 if pars.count=0 then  result:=datetimetostr(now) else
 begin
   if pars.count=1 then  result:=datetimetostr((now+strtointdef(pars[0],0)))  else
      result:=datetimetostr(getdatetime(pars[1])+strtointdef(pars[0],0));
  end;
 end;
 function tfunc.f_incweeks:string;
 const parlist:array[0..1] of string =('date','add');
{D: date addition, param "add" in days, "date" in system format
to be integrated into some more general function
}
var p_add,p_date:string;
 begin
 if pars.count=0 then  result:=datetimetostr(now) else
 begin
   if pars.count=1 then  result:=datetimetostr((now+strtointdef(pars[0],0)*7))  else
      result:=datetimetostr(getdatetime(pars[1])+strtointdef(pars[0],0)*7);
  end;
 end;

 function tfunc.f_incmonths:string;
  const parlist:array[0..1] of string =('date','add');
 {D: date addition, param "add" in months, "date" in system format
 to be integrated into some more general function.
 }
  var p_date,p_add:string;dat:tdatetime;
  begin
  if pars.count=0 then  result:=datetimetostr(now) else
    if pars.count=1 then  result:=datetimetostr(incmonth(now,strtointdef(pars[0],0)))  else
      result:=datetimetostr(incmonth(getdatetime(pars[1]) ,strtointdef(pars[0],0)));
   end;

 function tfunc.f_incyears:string;
  const parlist:array[0..1] of string =('date','add');
 {D: date addition, param "add" in months, "date" in system format
 to be integrated into some more general function.
 }
  var p_date,p_add:string;
  begin
  if pars.count=0 then  result:=datetimetostr(now) else
    if pars.count=1 then  result:=datetimetostr(incmonth(now,strtointdef(pars[0],0)*12))  else
      result:=datetimetostr(incmonth(getdatetime(pars[1]) ,strtointdef(pars[0],0)*12));
  end;
function tfunc.f_dateadd:string;
 {D: date addition, param "add" in days, "date" in system format
 to be integrated into some more general function
 }
 var p_add,dat:tdatetime;toadd:integer;unt:integer;

  begin
  toadd:=0;
  if pars.count<2 then exit;
  dat:=getdatetime(pars[0]);
  toadd:=strtointdef(pars[1],0);
  if pars.count=2 then unt:=1 else
  begin
    if pars[2]='hours' then unt:=24   else
    if pars[2]='minutes' then unt:=24*60 else
    if pars[2]='seconds' then unt:=24*60*60 else
    if pars[2]='milliseconds' then unt:=24*60*60*1000 else
    if pars[2]='days' then unt:=1 else
    if pars[2]<>'weeks' then
     begin
      if pars[2]='months' then result:=datetimetostr(incmonth(dat ,toadd));
      if pars[2]='years' then result:=datetimetostr(incmonth(dat,toadd*12));
      exit;
    end;
  end;
       if pars[2]='weeks' then result:=datetimetostr(dat+toadd*7) else
       result:=datetimetostr(dat+toadd/unt);
end;



function tfunc.f_hourssince:string;
 const parlist:array[0..1] of string =('date','now');
{D: date substraction from now, param "add" in months, "date" in system format
to be integrated into some more general function.
}
 var p_date,p_now:string;dat:tdatetime;
 apui:integer;nowdate:tdatetime;
 begin
   namepars(p_date,p_now,parlist,pars);
   try
   if p_now='' then nowdate:=now else nowdate:=strtodatetime(p_now);

   apui:=round(24*60*(nowdate-strtodatetime(p_date)));
   result:=inttostr(apui div 60)+':'+inttostr(apui mod 60);
   except result:='1000';end;
 end;

 function tfunc.f_dayssince:string;
 const parlist:array[0..1] of string =('date','now');
{D: date substraction from now, param "add" in months, "date" in system format
to be integrated into some more general function.
}
 var p_date,p_now:string;
 nowdate:tdatetime;
 begin
   try
   namepars(p_date,p_now,parlist,pars);
   if p_now='' then nowdate:=now else nowdate:=strtodatetime(p_now);
   result:=inttostr(round(now-vartodatetime(p_date)));
   //writeln('<h2>ds_'+pars.values['date'),' = ', result,'</h2>');
   //pars.list;
   except result:='1000';end;
 end;
 function tfunc.f_datedif:string;
 const parlist:array[0..2] of string =('date1','date2','unit');
{D: date substraction date2 from date1, param "add" in months, "date" in system format
to be integrated into some more general function. .. only unit=days implemented
}
var p_date1,p_date2,p_unit:string;
 date1,date2:tdatetime;
 datedif:double;        apui:integer;
 //y,m,d_integer;
 begin
   try
   writeln('<h2>dd1:'+pars.text,'</h2>');
   namepars(p_date1,p_date2,p_unit,parlist,pars);
      date1:=strtodatetime(p_date1);
      date2:=strtodatetime(p_date2);

   //writeln('<h4>dd2:',p_date1,' d2:',p_date2,' u:',p_unit,'</h4>');
   datedif:=date1-date2;
   {if p_unit='years' then
    result:=inttostr(round(monthoftheyear(date1)-monthoftheyear(date2)))
    else
   if p_unit='months' then
    result:=inttostr(round(monthoftheyear(date1)-monthoftheyear(date2)))
    else
   if p_unit='weeks' then
    result:=inttostr(round(weekoftheyear(date1)-weekoftheyear(date2)))
    else}
   if p_unit='hours' then
    result:=inttostr(round(24*datedif))
    else
   if p_unit='minutes' then
    result:=inttostr(round(24*60*datedif))
    else
   if p_unit='seconds' then
    result:=inttostr(round(24*60*60*datedif))
    else
   if p_unit='milliseconds' then
    result:=inttostr(round(24*60*60*1000*datedif))
    else
  if (p_unit='days') or (p_unit='') then
   begin
   result:=inttostr(round(datedif));
   end
   ;{ else
   if p_unit='hours' then
   begin
   apui:=round(24*60*(datedif));
   //result:=inttostr(apui div 60)+':'+inttostr(apui mod 60);
   result:=inttostr(apui div 60)+':'+inttostr(apui mod 60);
   }
   except result:='0';raise; end;
 end;

 function tfunc.f_timedif:string;
 const parlist:array[0..2] of string =('time1','time2','unit');
{D: date substraction date2 from date1, param "add" in months, "date" in system format
to be integrated into some more general function.
}
var p_time1,p_time2,p_unit:string;
 date1,date2:tdatetime;dif:integer;
 begin
   namepars(p_time1,p_time2,p_unit,parlist,pars);
   try
     // writeln('<li>Timedif:',pars.values['time1'],'/',pars.values['time2']);
     //exit;
      date1:=strtodatetime(p_time1);
      date2:=strtodatetime(p_time2);
      dif:=round(24*60*60*(date1-date2));
  // result:=inttostr(dif div 60)+':'+inttostr(dif mod 60);

   //writeln('<h2>ds:'+pars.values['date1'],pars.values['date2'],'</h2>');
   if p_unit='seconds' then
   result:=inttostr(dif) else
    if p_unit='minutes' then
   result:=inttostr(dif div 60) else
   if p_unit='hours' then
   result:=inttostr(dif div 3600) else
   result:=inttostr(dif);
   //writeln('<h2>'+pars.values['date1'],pars.values['date2'],' = ', result,'</h2>');
   //pars.list;
    //  write('Timedif: d1=',date1,'/d2=',date2,' /dif=',dif,' /result=',result);writeln('*');
   except result:='1000';end;
 end;

 function tfunc.f_startofweek:string;
 const parlist:array[0..0] of string =('unnamed');
{D: return the monday of the week of given date
to be integrated into some more general function
}
var adate:tdate;wday:integer;dd:string;
 begin
   try
   dd:=(pars[0]);
   //writeln('indays ', pars.values['date'],' - ',pars.values['add'],0);
  if dd='' then adate:=today else
  adate:=vartodatetimex(dd);
  wday:=dayoftheweek(adate);
 //  writeln('strt: ',wday, '--',pars[0]+' - ',datetostr(adate));
  adate:=adate-wday+1;
  result:=datetostr((adate));
 //   +strtointdef(pars.values['add'],0)));
   except result:=datetostr(now);end;
   //writeln('strt ',wday, '--',pars.Values['date']+' - ',datetostr(adate));
 end;

 function tfunc.f_dayofweek:string;
 const parlist:array[0..0] of string =('unnamed');
 {D: numeric dayofweek
  1=sun, 7=mon  .. needs formatting options
 }
 var wday:integer;apu:string;
 begin
// writeln('dow:'+pars.values['date']+'///'+pars.text);
  apu:=(pars[0]);
  //if apu=''  then apu:=cut_rs(pars.Strings[0]);

  result:=inttostr(DayOfWeek(vartodatetime(apu)));
 //  result:=FormatDateTime('ddd',vartodatetime(pars.values['date']));
 end;

 function tfunc.f_dayoftheweek:string;
 const parlist:array[0..0] of string =('unnamed');
 {D: numeric dayofweek
  1=mon, 7=sun  .. needs formatting options
 }
 var wday:integer;dd:string;
 begin
  //writeln('dayofW:',result);
   dd:=(pars[0]);
  result:=inttostr(DayOftheWeek(vartodatetime(dd)));
  //writeln('dayofW:',result);
 //  result:=FormatDateTime('ddd',vartodatetime(pars.values['date']));
 end;

 function tfunc.f_formattime:string;
 const parlist:array[0..1] of string =('time','format');
{D: formats a @time according to a format
 ex: formattime(format='hh:nn:ss' time=?now())
 }
 var p_time,p_format:string;
 begin
   namepars(p_time,p_format,parlist,pars);
   result:=FormatDateTime(p_format,strtotime(p_time));
 end;

function tfunc.f_getdatetime:string;
 const parlist:array[0..0] of string =('unnamed');
{D:
 general date that tries to guess used format
 under construction
}
var dats:string;i,lastpos:integer;items,separs,formats:tstringlist;inint:boolean;
y,m,d,h,min,sec,ms:word;yitem,mitem:integer;mdy:boolean;pm,hit:boolean;
i0,i1,i2,mint:integer;daatee:tdatetime;lsepar:string;
  function _getmonth(st:string):integer;
  var i:integer;
  begin
  try
  //st:=lowercase(st);
  result:=-1;
  for I := 1 to 12 do
  begin
    //   writeln(i,st,'try month:',monthstr[i]);
    if pos(monthstr[i],st)>0 then
    begin
      result:=i;
      break;
    end;
  end;
  finally
   //writeln('got month:',st,result);
   end;
  end;
 function _trydate(myear,mmonth,mday:integer):boolean;
 begin
   result:=true;
   try
   daatee:=encodedate(myear,mmonth,mday);
   except writeln('<li>fail:',myear,'-',mmonth,'-',mday,'</li>');
   result:=false;exit;
   end;
  //writeln('<li>OKDATE:',myear,'-',mmonth,'-',mday,'</li>');
end;
begin
inint:=false;
hit:=false;
pm:=false; yitem:=-1;mitem:=-1;
 items:=tstringlist.create;
 separs:=tstringlist.create;
// formats:=tstringlist.create;
  dats:='x'+(pars[0])+'x';
  //writeln('tryedate:',dats);
  lastpos:=1;inint:=false;
  try
  for i := 1 to length(dats) do
      if pos(dats[i],'0123456789')>0 then
      begin
        if not(inint) then
        begin
          lsepar:=lowercase(copy(dats,lastpos,i-lastpos));
          mint:=-1;
          if (length(lsepar)>2) then mint:=_getmonth(lsepar);
          if (mint>0) then
          begin
            try
                separs.add(lsepar[1]);
                separs.add(lsepar[1]);
                items.add(inttostr(mint));
                mitem:=items.Count-1;
             except writeln('fail monthstr');  end;
           end else
           separs.add(lsepar);
           lastpos:=i;inint:=true;
           if items.Count>3 then if length(lsepar)>2 then
            if (pos(lsepar,'p.m')>0) or (pos(lsepar,'pm')>0) then
              pm:=true;
        end;
      end else
      if (inint) then
        begin
         items.add(copy(dats,lastpos,i-lastpos));
         if (strtointdef(items[items.count-1],0)>60) or ((items.count<4) and
         (strtointdef(items[items.count-1],0)>31)) then
         begin
         yitem:=items.count-1;
         //writeln('<li>y:'+items.Text,yitem, '?',items[yitem]);
         end;
         lastpos:=i;inint:=false;
        end;
       separs.add(copy(dats,lastpos,length(dats)-lastpos));
       //writeln('<li>splitted: '+items.Text+' seps: '+separs.Text+'</li>');
 except
     writeln('<li> cant split string</li>');
end;
try
 i0:=strtointdef(items[0],-1);
 i1:=strtointdef(items[1],-1);
 i2:=strtointdef(items[2],-1);
except
     writeln('<li> not enuff items</li>');
end;
 writeln('<LI>gettingdate:',dats,'try items',items.text,' 0:',i0,' 1:', i1,' 2:',i2,' y:',yitem);
if yitem>=0 then
begin
 //writeln('YEAR GIVEN',yitem);
 if yitem=0 then
  //   ymd:=true
  _trydate(i0,i1,i2)
 else if yitem=2 then
   if mitem=0 then
    _trydate(i2,i0,i1) else
     // mdy:=true else
   if mitem=1 then
    _trydate(i2,i1,i0) else
   if separs[1]='/' then
   begin
    if not _trydate(i2,i0,i1) then _trydate(i2,i1,i0)
   end else
   begin
    if not _trydate(i2,i1,i0) then _trydate(i2,i0,i1)
   end else writeln('nothing tried',yitem);
end else  //no clear year specified  30-02-03
 if mitem>=0 then //but month is (jan,feb...)
 begin
  if mitem=0 then _trydate(i2+2000,i0,i1) else
  if mitem=1 then
  begin
    if separs[1]='-' then
    begin
     if not _trydate(i0+2000,i1,i2) then _trydate(i2+2000,i1,i0)
    end else
    if not _trydate(i2+2000,i1,i0) then _trydate(i0+2000,i1,i2)
  end else
 end
 else //neither year or month clear;
  begin
    if separs[1]='-' then //expect ISO
    begin
     if not _trydate(i0+2000,i1,i2) //ymd
      then   if not _trydate(i2+2000,i1,i2)  //dmy
     then _trydate(i2+2000,i0,i1) //mdy

    end else
    if separs[1]='.' then //expact d.m.y
    begin
      if not _trydate(i2+2000,i1,i0)  //dmy
      then if not _trydate(i2+2000,i0,i1) //mdy
      then _trydate(i0+2000,i1,i2) //ymd
    end else //US?
    begin
      if not _trydate(i2+2000,i0,i1)  //mdy -US
     then if not _trydate(i2+2000,i1,i0) //dmy -UK
     then _trydate(i0+2000,i1,i2) //ymd
    end
  end;
try
  h:=0;min:=0;sec:=0;ms:=0;
if items.count>3 then h:=strtointdef(items[3],0);
if items.count>4 then min:=strtointdef(items[4],0);
if items.count>5 then sec:=strtointdef(items[5],0);
if items.count>6 then ms:=strtointdef(items[6],0);
if pm then h:=h+12;
except writeln('<li>not enyuff items: '+dats);end;
try
writeln('<h2>gotDate:'+DATETIMETOSTR(DaaTee),'</h2>');
decodedate(daatee,y,m,d);
daatee:=encodedatetime(y,m,d,h,min,sec,ms);
except writeln('<li>Invalid date: '+dats);end;
try
if items.Count>3 then
result:=formatdatetime('yyyy-mm-dd hh:nn:ss',daatee) else
result:=formatdatetime('yyyy-mm-dd',daatee);

writeln('<h2>GotDate:'+result+'</h2><h2>'+dats+'</h2>');
  except writeln('<h1>failformatdate'+dats, y,'*',m,'*',d,'</h1>');end
 end;

function tfunc.f_formatdatetime:string;
 const parlist:array[0..1] of string =('date','format');
{D: another (see getdatetime), older attempt a general date-formatter
}
var p_date,p_format:string;
apu,apu2:string;dat:tdatetime;
 begin
 namepars(p_date,p_format,parlist,pars);
 dat:=getdatetime(p_date);

      if p_format='' then p_format:='yyyy-MM-dd';//shortdateformat;
      result:=FormatDateTime(p_format,dat);
      //result:=FormatDateTime(p_format,vartodatetime(p_date));
     // writeln('format :'+pars.values['date']+' / '+result+'=='+pars.values['format']+'\');
      try
        //result:=FormatDateTime(p_format,vartodatetime(p_date));
        //result:=DateTimetostr(vARtodatetime(p_date));
      except  writeln('faileddate:',p_date);   end;
   // writeln('<li>formatdate :'+result+'--'+p_format+'!!!'+pars[1]);
    //finally
    //shortdateformat:=apu;
    //dateseparator:=apu2[1];
    //end;
 end;

 function tfunc.f_icaldate:string;
 const parlist:array[0..2] of string =('','','');
 var p_date:string;
{D: STILL another (see getdatetime) old attempt at general date-formatter
 using simply delphis own general formatter, vartodatetime . Vartodatetimex
 jsut wraps it to fpc where just dateeimetstr is used}
 begin
  p_date:=pars.values['date'];
   result:=copy(p_date,1,4)+'-'+copy(p_date,5,2)+'-'+copy(p_date,7,2);
  // +' '+copy(p_date,10,2)+':'+copy(p_date,12,2)+':'+copy(p_date,14,2)+':00';
 end;
 function tfunc.f_icaltime:string;
 const parlist:array[0..2] of string =('','','');
 var p_date:string;
{D: STILL another (see getdatetime) old attempt at general date-formatter
 using simply delphis own general formatter, vartodatetime . Vartodatetimex
 jsut wraps it to fpc where just dateeimetstr is used}
 begin
  p_date:=pars.values['date'];
   result:=//copy(p_date,1,4)+'-'+copy(p_date,5,2)+'-'+copy(p_date,7,2);
    copy(p_date,10,2)+':'+copy(p_date,12,2)+':'+copy(p_date,14,2);
 end;

 function tfunc.f_datetime:string;
  const parlist:array[0..2] of string =('','','');
  {D: try to make senseof datetime string, trying several formats}
  begin
  if pars.count=0 then result:=datetostr(now) else
   result:=formatdatetime('yyyy-mm-dd hh:nn:ss',getdatetime(pars[0]));
  //writeln(RFC2822Date(now));
  end;

 function tfunc.f_date:string;
  const parlist:array[0..2] of string =('','','');
 {D: get just date part of datetime, trying several formats}
  begin
  if pars.count=0 then result:=datetostr(now) else
   result:=datetostr(getdatetime(pars[0]));
  //writeln(RFC2822Date(now));
  end;
 function tfunc.f_time:string;
  const parlist:array[0..2] of string =('','','');
  {D: get just time part of datetime, trying several formats}
  begin
    if pars.count=0 then result:=formatdatetime('hh:nn:ss',now)
            //timetostr(now)
            else
    result:=timetostr(getdatetime(pars[0]));
    //result:=formatdatetime('hh:nn:ss',getdatetime(pars[0]));
   //writeln('<li>TIME:',pars[0],'!',result+'!','</li>');
  end;


function tfunc.f_now:string;
 const parlist:array[0..0] of string =('format');
 {D:present datetime in servers system format (needs formatting params
 }
 var p_format:string;
 begin
  namepars(p_format,parlist,pars);
//longtimeformat:='hh:nn:ss';
//shorttimeformat:='hh:nn';
//   result:=datetimetostr(now)+shorttimeformat+'  '+longtimeformat
//   +'  '+shortdateformat +'  '+longdateformat;
  if p_format='' then  result:=formatdatetime('yyyy-mm-dd hh:nn:ss',now)
  else result:=formatdatetime(p_format,now);
  //writeln('****NOWNOW',pars.Text,'!',pars.Values['format'],'!',result);
 end;

 function tfunc.f_today:string;
 const parlist:array[0..0] of string =('format');
 {D: todays date in yyy-mm-dd (can have formatting param
 }
 var p_format:string;
 begin
  namepars(p_format,parlist,pars);
//longtimeformat:='hh:nn:ss';
//shorttimeformat:='hh:nn';
//   result:=datetimetostr(now)+shorttimeformat+'  '+longtimeformat
//   +'  '+shortdateformat +'  '+longdateformat;
//      result:=formatdatetime('yyyy-mm-dd hh;nn:ss',now);
  if p_format='' then  result:=formatdatetime('yyyy-mm-dd',now)
  else result:=formatdatetime(p_format,now);
  //result:=datetostr(today);
  //writeln('today is '+result);
 end;

 function tfunc.f_weekofyear:string;
 const parlist:array[0..0] of string =('Unnamed date');
 {D:week number of @date according to delphis weekofyear-function,
 internals unkown (what is week 1? - first week containing a thursday?)
 }
 begin
   try
   result:=inttostr(_weekofyear(vartodatetimex((pars[0]))));
   except result:='1000';end;
 end;

 function tfunc.f_month:string;
 const parlist:array[0..0] of string =('unnamed');
 {D: month number of @date
 }
 //vat mm:string;
 begin
   try
   result:=inttostr(monthof(vartodatetime((pars[0]))));
   //result:=FormatDateTime('mmm',vartodatetime(pars.values['date']));

   except result:='1000';end;
 end;


function tfunc.f_gsub:string;
 const parlist:array[0..2] of string =('where','what','with');
{D: replace occurances of @what within @inwhat with @with
}
var p_what,p_with,p_where:string;
begin
  namepars(p_where,p_what,p_with,parlist,pars);
 // writeln('<li>try gsub!'+p_what+'!!!'+p_with+'!!!'+'<small>',p_where,'</small>');
  try
  if pars=nil then
    writeln('<li>gsub nil</li>');
  except
    writeln('<li>gsub broken</li>');

  end;
  //if pars.text='' then
  //writeln('<li>gsub empty</li>');
  if pars.values['debug']<>'' then
  writeln('<xmp>gsub pars:',pars.text,'</xmp>');
 //  result:=pars.values['inwhat'];
//   result:=StringReplace(result,pars.values['what'],pars.values['towhat'],[rfreplaceall]);
 try
  result:=AnsiReplaceStr(p_where,p_what,p_with);
 except
  writeln('<li>gsub result:',pars.text,'</li>');
 end;
  //writeln('<li>gsub result:',result,'</li>');
end;

function tfunc.f_makename:string;
 const parlist:array[0..0] of string =('U');
{D: tries to build a legal, understandable short file name from a
 string of several words
}
var astl:tstringlist;i:integer;ch:ansichar;poch:integer;
const aaks='äöåÄÖÅ';aaks2='aooAOO';


 begin
   astl:=tstringlist.create;
   _split(trim((pars[0])),' ',astl);
   if astl.count>1 then result:=copy(astl[0],1,4)+copy(astl[1],1,3)
   else result:=copy(astl[0],1,8);
   if astl.count>2 then result:=result+copy(astl[2],1,1);
   result:=ansilowercase(result);
   result:=StringReplace(result,'ä','a',[rfreplaceall]);
   result:=StringReplace(result,'ö','o',[rfreplaceall]);
   result:=StringReplace(result,'å','o',[rfreplaceall]);
   for i:=1 to length(result) do
   begin
    ch:=result[i];
    poch:=pos(ch,aaks);
    if poch>0 then ch:=aaks2[poch];

    if not (ch in ['A'..'Z', 'a'..'z','0'..'9'])
    then result[i]:='_'
   end;
    astl.clear;astl.free;
   end;

function tfunc.f_varname:string;
 const parlist:array[0..1] of string =('string','oldvars');
{D: tries to build a legal, understandable short file name from a
 string of several words
}
var p_string,p_oldvars:string;
astl:tstringlist;i:integer;//oldvars:string;
 begin
  namepars(p_string,p_oldvars,parlist,pars);
   astl:=tstringlist.create;
    //oldvars:=pars.values['old'];
   _split(p_string,' ',astl);
   if astl.count>2 then result:=copy(astl[0],1,3)+copy(astl[1],1,3)+copy(astl[2],1,2)
   else   if astl.count>1 then result:=copy(astl[0],1,5)+copy(astl[1],1,3)
   else result:=copy(astl[0],1,8);
   //if astl.count>2 then result:=result+copy(astl[2],1,1);
   result:=ansilowercase(result);
   result:=StringReplace(result,'ä','a',[rfreplaceall]);
   result:=StringReplace(result,'ö','o',[rfreplaceall]);
   result:=StringReplace(result,'å','o',[rfreplaceall]);
   for i:=1 to length(result) do
    if not (result[i] in ['A'..'Z', 'a'..'z','0'..'9'])
    then result[i]:='_';
   if pos(','+result+',',p_oldvars)>0 then
   begin
    //writeln('<li>DUP:'+result+':::'+oldvars);
    result:='k'+_randomstring;  //LAZY!
   end;
    astl.clear;astl.free;
   end;

 function tfunc.f_utf8toasc:string;
 const parlist:array[0..0] of string =('Unnamed');
{D: utf to iso western euro
}
 begin
   result:=_utf8toasc((pars[0]))
   end;


function tfunc.f_trim:string;
 const parlist:array[0..0] of string =('U');
 {D: Trims leading and trailing whitespace
 }
 begin
   result:=trim((pars[0]));
   end;

 function tfunc.f_trimleft:string;
 const parlist:array[0..0] of string =('U');
 {D: Trims leading  whitespace
 }
 begin
   result:=trimleft((pars[0]));
   end;
 function tfunc.f_trimright:string;
 const parlist:array[0..0] of string =('U');
 {D: Trims trailing whitespace
 }
 begin
   result:=trimright((pars[0]));
   end;

 function tfunc.f_wrap:string;
 const parlist:array[0..2] of string =('str','indent','width');
{D: semi-intelligent wor wrapper with given @indent and @widht
}
 var p_str,p_indent,p_width:string;
 begin
   namepars(p_str,p_width,p_indent,parlist,pars);
   result:=_wrap(p_str,p_indent,strtointdef(p_width,60));
   end;

 function tfunc.f_entities:string;
 const parlist:array[0..0] of string =('U');
 {D: replaces all <>"&' with entities &lt; etc
 }
 begin
   //writeln('<xmp>enti:'+pars[0]+'</xmp>');
   result:=_clean((pars[0]));
 end;

 function tfunc.f_noentities:string;
 const parlist:array[0..0] of string =('');
 {D: replaces  entities &lt; &gt; &quot; &amp; &#39; with <>"&' withetc
 }
 begin
   result:=_unclean((pars[0]));
 end;

 function tfunc.f_nouml:string;
 const parlist:array[0..0] of string =('');
 {D: makes scandinavic texts using umlaut-entities readable
   a more general function needed for other labnguages rendered
   unreadable by many editors
 }
 var apu:string;
 begin
    apu:=(pars[0]);
    apu:=StringReplace(apu,'&auml;','ä',[rfreplaceall]);
    apu:=StringReplace(apu,'&Auml;','Ä',[rfreplaceall]);
    apu:=StringReplace(apu,'&öuml;','ö',[rfreplaceall]);
    apu:=StringReplace(apu,'&Ouml;','Ö',[rfreplaceall]);
    apu:=StringReplace(apu,'&aring;','å',[rfreplaceall]);
    apu:=StringReplace(apu,'&Aring;','Å',[rfreplaceall]);
    result:=apu;
 end;

 function tfunc.f_cleanspaces:string;
 const parlist:array[0..0] of string =('');
 {D: strips double spaces and nonbraking spaces #160
 }
 begin
   result:=trim((pars[0]));
    result:=StringReplace(result,#160,' ',[rfreplaceall]);
   result:=StringReplace(result,'  ','_',[rfreplaceall]);
   end;

 function tfunc.f_oneline:string;
 const parlist:array[0..0] of string =('');
 {D: converts crlf, lf, cr to spaces and trims the result
 }
 begin
   result:=adjustlinebreaks(pars.strings[0]);
   result:= StringReplace(result,crlf,' ',[rfreplaceall]);
   result:=StringReplace(result,^M,' ',[rfreplaceall]);
   result:=StringReplace(result,^J,' ',[rfreplaceall]);
   result:=trim((result));
   //writeln('<!--oneline:'+result+'-->');
  end;

 function tfunc.f_trimwhitespace:string;
 const parlist:array[0..0] of string =('');
 {D: converts all adjacent whitespaces to single space
 }
 var ws,lineb:boolean;apu,apu2:string; i:integer;
 begin
  apu:='';
   ws:=true;
   apu2:=pars.strings[0];
   for i:=1 to length(apu2) do
    if pos(apu2[i],whitespace)>0 then
    begin
      if pos(apu2[i],crlf)>0 then lineb:=true;
      if ws or (i=length(apu2)) then continue else
      begin  ws:=true;apu:=apu+' ';
      end
    end
    else
    begin ws:=false;if lineb then apu:=apu+crlf; lineb:=false; apu:=apu+apu2[i];
      end;
   result:=apu;
   //result:='got:'+adjustlinebreaks(apu);
 end;
function tfunc.f_whitespacespace:string;
const parlist:array[0..0] of string =('');
{D: converts all adjacent whitespaces to single space
}
var ws:boolean;apu,apu2:string; i:integer;
begin
apu:='';
ws:=true;
apu2:=pars.strings[0];
for i:=1 to length(apu2) do
if pos(apu2[i],whitespace)>0 then
if ws or (i=length(apu2)) then continue else
begin ws:=true;apu:=apu+' ';
end
else
begin ws:=false;apu:=apu+apu2[i];
end;
result:=apu;
end;


 function tfunc.f_nocdata:string;
 const parlist:array[0..0] of string =('');
{D: strips away cdata delimiters
}
 begin
   result:=_nocdata(pars.strings[0]);
   end;
 function tfunc.f_cdata:string;
 var ast:string;
 begin
      ast:=pars.strings[0];
       ast:=StringReplace(ast,']]>',']]]]><![CDATA[>',[rfreplaceall]);

       result:='<![CDATA['+ast+']]>';
end;

 function tfunc.f_utf8length:string;
  //const parlist:array[0..0] of string =('');
 var
   i: Integer;
  {D: length of string - note: incorrect results for utf
  }
  begin
    result:=inttostr(utf8length((pars[0])));

  end;

function tfunc.f_length:string;
 const parlist:array[0..0] of string =('');
var
  i: Integer;
 {D: length of string - note: incorrect results for utf
 }
 begin
   result:=inttostr(length((pars[0])));

 end;

function tfunc.f_pos:string;
const parlist:array[0..1] of string =('part','whole');
{D: position of a @part in @whole - note: incorrect results for utf
}
var p_part,p_whole:string;
begin
  namepars(p_part,p_whole,parlist,pars);
  result:=inttostr(pos(p_part,p_whole));
 // writeln('<li>',result,p_part,'_in_',p_whole);
 // writeln('<li>',pars.text,pars.count);
end;

function tfunc.f_posany:string;
const parlist:array[0..1] of string =('part','whole');
{D: position of a @part in @whole - note: incorrect results for utf
}
var p_parts,p_whole:string;i:integer;
begin
  namepars(p_parts,p_whole,parlist,pars);
  i:=1;
  while i<=length(p_whole) do
    if  pos(p_whole[i],p_parts)>0 then break
    else i:=i+1;
  result:=inttostr(i);
end;

 function tfunc.f_lowercase:string;
 const parlist:array[0..0] of string =('');
{D: lowercase - note: incorrect results for utf
 }
  begin
   try
   result:=ansilowercase((pars[0]));
   except result:='';end;
   end;

 function tfunc.f_uppercase:string;
 const parlist:array[0..0] of string =('');
{D: uppercase - note: incorrect results for utf
 }
 begin
   if (pars<>nil) and (pars.count>0) then result:=ansiuppercase((pars[0]))
   end;

 function tfunc.f_md5:string;
 const parlist:array[0..0] of string =('');
 {D: // Create hex representation of given digest
 }
 begin
   result:=md5print(MD5String((pars[0])))
end;

 function tfunc.f_absoluteurl:string;
 const parlist:array[0..1] of string =('page','link');
 {D: // Forms absolute url from given (@page) absolute url
 and a relative @link from that page
 }
 var p_page,p_link:string;
 begin
  namepars(p_page,p_link,parlist,pars);
   result:=_geturl(p_page,p_link);
  end;


 function tfunc.f_newfile:string;
 const parlist:array[0..1] of string =('pattern','ext');
  {D: // finds a free filename @pattern1.@ext @pattern2.@ext
  and "reserves" the name by creating an empty file
 }
var p_pattern,p_ext:string;
 begin
   namepars(p_pattern,p_ext,parlist,pars);
   result:=_newfile(p_pattern,p_ext);
 end;
 function tfunc.f_shellexec:string;
 begin
   //WRITELN(pars[0]+'!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
   result:=launchprogram('sh -c','"'+pars[0]+'"',true);
   //writeln(result+'????????????????????????');

 end;
 function tfunc.f_exec: string;
 var exe,cmd:string;
 begin
   if pars.count>1 then cmd:=pars[1] else cmd:='';
   result:=launchprogram(pars[0],cmd,true);
 end;

 function tfunc.f_read:string;
 const parlist:array[0..0] of string =('file');
 {D: reads a file's (or http:-url) and returns its contents as string
  (if file is xml, note that read returns it unparsed)
   if file is not in current directory-branch, checks for existence of a .xseusallow -file
   in its dir or somewher uptree from it
   this .xseusallow-mechanism needs developing (to something similar to .htaccess )
 }
 var p_file:string;
  apu,apu2,st:string;testallow:boolean;
 begin
   namepars(p_file,parlist,pars);
   //logwrite('reading');
   //apu:= pars.values['file'];
   //if apu='' then apu:=cut_rs(pars.strings[0]);
   //writeln('<li>read: file='+p_file+' pars='+pars.text+g_ds+'\\');
    if (pos('http:',p_file)=1) or (pos('https:',p_file)=1) then
    begin
      apu2:='-1';
      apu:=p_file;
      if pos(' :::', st)>0 then //what is this??? timeout?
       begin
          apu2:=copy(p_file,pos(p_file,' :::')+4,length(p_file));
          apu:=copy(p_file,1,pos(p_file,' :')-1);
       end;
       result:=_httpget(apu,strtointdef(apu2,-1),pars);
       //writeln('get:'+ apu+'/got:'+'<xmp>'+result+'</xmp>');
       exit;
      end;
    testallow:=pars.values['path']='full';
   try
   //--if (FileExistsUTF8(extractfiledir(p_file)+g_ds+'.xseusallow') { *Converted from FileExists*  }) then
   if (FileExists(extractfiledir(p_file)+g_ds+'.xseusallow') { *Converted from FileExists*  }) then
   _readfile(p_file,result)
     else
     begin
      // writeln('<h1>read</h1><h2>_'+p_file+'_</h2>_'+_indir(p_file,xs.odir,xs,false),'_');
      _readfile(_indir(p_file,xs.x_objectdir,xs,false),result);

     end;
   except
   writeln('failed readfile '+_indir(p_file,xs.x_objectdir,xs,false)+'<xmp>'+result+'</xmp>');
   end;
   //writeln(p_file,'xxxxxxxxxxreadfile '+_indir(p_file,xs.odir,testallow,xs)+'<xmp>'+result+'</xmp>');
   end;

 function tfunc.f_mapurltofile:string;
 const parlist:array[0..0] of string =('url');
  {D: // get filename from url according to mappings given in xseus.ini
 }
 var p_url:string;
 begin
   result:=_mapurltofile(p_url,xs.x_config.subt('urlpths'));
   end;

 function tfunc.f_mapfiletourl:string;
 const parlist:array[0..0] of string =('');
  {D: // get url from filename according to mappings given in xseus.ini
 }
 begin
   result:=_mapfiletourl((pars[0]),xs.x_config.subt('urlpaths'));
 end;


 function tfunc.f_base64encode:string;
 const parlist:array[0..0] of string =('');
   {D: base64 encodes a given @string
 }
 begin
   result:=_encode64((pars[0]));
 end;

 function tfunc.f_base64decode:string;
 const parlist:array[0..0] of string =('');
   {D: b64decodes a given @string
 }
 begin
   result:=_decode64((pars[0]));
 end;

 function tfunc.f_urlencode:string;
 const parlist:array[0..0] of string =('');
   {D: urlencodes a given @string
 }
 begin
   result:=_urlencode((pars[0]));
 end;

 function tfunc.f_urldecode:string;
 const parlist:array[0..0] of string =('');
   {D: urlencodes a given @string
 }
 begin
   result:=_urldecode(((pars[0])));
 end;

 function tfunc.f_normalizeurl:string;
 const parlist:array[0..1] of string =('url','base');
   {D:gets rid of /../ and /./ in urls and
   form absolute urls for relative @url and absolute @base
   overlaps with f_geturl, needs rewriting
 }
var p_url,p_base:string;
begin
 try
   namepars(p_url,p_base, parlist,pars);
   result:=_normalizeurl(p_url,p_base);

 except
  writeln('<li>nonorm');
 end;
 end;



 function tfunc.f_tcpget:string;
  const parlist:array[0..2] of string =('host','port','cmd');
 {D: raw tcp-read (ad hoc need to read a sauna thermometer
 }
 var p_host,p_port,p_cmd:string;
 begin
    //namepars(p_host,p_port,p_cmd, parlist,pars);
    //indy result:=_tcpget(p_host,p_cmd,strtointdef(p_port,2000));
    result:=_tcpget(p_host,p_port,p_cmd);
    //'not implemented yet');
 end;
 function tfunc.f_httpget:string;
  const parlist:array[0..2] of string =('host','port','cmd');
 {D: raw tcp-read (ad hoc need to read a sauna thermometer
 }
 var p_host,p_port,p_cmd:string;
 begin
   result:=_httpget(pars[0],1000,nil);
  //  namepars(p_host,p_port,p_cmd, parlist,pars);
    //indy result:=_tcpget(p_host,p_cmd,strtointdef(p_port,2000));
   // result:=_httpget('not implemented yet');
 end;

function tfunc.f_crlf:string;
{D: carriage return-linefeed-pair
}
begin
   result:=^M+^J
end;

function tfunc.f_lf:string;
{D: linefeed char
}
begin
   result:=^J
end;

function tfunc.f_quote:string;
{D: doublequote-char
}
begin
   result:='"'
end;

function tfunc.f_apos:string;
{D: '  (apostrophe, single quote)
}
begin
   result:=''''
end;

function tfunc.f_amp:string;
{D: ampersand &
}
begin
   result:='&'
end;

function tfunc.f_tab:string;
{D: tabularor char
}
begin
   result:=#09
end;

{function tfunc.f_equals:string;
D: equal-sign

begin
   result:='='
end;

function tfunc.f_lt:string;
D: lt-sign. <, left bracket

begin
   result:='<'
end;

function tfunc.f_gt:string;
D: gt-sign. >, right bracket

begin
   result:='>'
end;
}
function tfunc.f_space:string;
{D: space
}
begin
   result:=' '
end;

function tfunc.f_xhtmlheader:string;
// empty const parlist:array[0..2] of string =('','','');
{D: shortcut for writing a XHTML 1.0 Transitional//EN header
}
begin
result:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
end;



function tfunc.f_xse:string;
{D: returns current namespace-prefix (normally "xse:")
 needed when building command-elements
}
begin
   result:=txseus(xs).ns;
   //writeln('<h1>ret:'+result+'</h1>');


end;

function tfunc.f_randomst:string;
{returns a string of lenght 8 consisting of random chars 1..0 a..z
}
begin
   result:=_randomstring
end;

function tfunc.f_rnd:string;
 const parlist:array[0..2] of string =('','','');
begin
   result:=inttostr(random(strtointdef((pars[0]),1000)));
   //writeln('random:'+pars.Text+ '!'+result+'!'+(pars[0])+'('+pars[0]+')');
end;




function tfunc.f_formurl:string;
{D: returns, in GET-format, the form (POSTed of GETted) of the
current http-call}

var j:integer;
begin
{//not working, no cgi-object      for j:=0 to txseus(xs).ccall.fields.count-1 do
      begin
        result:=result
         +_urlencode(cut_ls(txseus(xs).ccall.fields[j]))+'='
         +_urlencode(cut_rs(txseus(xs).ccall.fields[j]));
         if j<txseus(xs).ccall.fields.count-1 then
          result:=result+'&';
      end
}
end;

{function tfunc.f_urlencode:string;
begin
        result:=_urlencode(cut_rs(pars.strings[0])));

end;}

function tfunc.f_ntobr:string;
 const parlist:array[0..0] of string =('');
begin
      result:=StringReplace((pars[0]),'\n','<br />',[rfreplaceall]);
end;

{function tfunc.f_uppercase:string;
begin
        result:=ansiuppercase(copy(path,11,length(path)));

end;
}


function tfunc.f_xfilename:string;
 const parlist:array[0..0] of string =('');
{D:extracts filename-part of a path
}
begin
       result:=extractfilename((pars[0]));
end;

function tfunc.f_xfileext:string;
 const parlist:array[0..0] of string =('');
{D:extracts extension-part of a path
}
begin
       result:=extractfileext((pars[0]));
end;

function tfunc.f_xfilepath:string;
 const parlist:array[0..0] of string =('');
{D:extracts extension-part of a path
}
begin
       result:=extractfilepath((pars[0]));
end;

function tfunc.f_xfilenoext:string;
 const parlist:array[0..0] of string =('');
{D:extracts path and filename without extension  of a path
 .. not very good .. maybe fixed now
}
var f,dot:string;
begin
  f:=(pars[0]);
  dot:=extractfileext(f);
  result:=copy(f,1,length(f)-length(dot));
  //      if pos('.',pars[0])>0 then
  //      result:=copy(pars[0],1,pos('.',(pars[0])));
end;




end.



not any more


function tfunc.f_substring:string;
const parlist:array[0..2] of string =('string','start','len');
{D:complex function. Source string in @string
other params
 @cut cuts @cut chars from end of result (or @firstcut from end of source)
 @start cuts @start-1 chars from beginning of result (or @firstskip from beginning of source)
 @len truncates result to given @len
 @last truncates result to given len counting from end
 @before @beforelast @after @afterlast cut result on position of substring-occurances  modified by
 missign=empty

 all this can be done using regexp-functions too if you happen to be versed...
}
var p_string,p_sta,p_len:string; //++ others
sta,sto,len,cut,olen:integer;st:string;apui,ires:integer;
params:(xstr,xlen,xpos);
begin
 //namepars(p_string,p_sta,p_len, parlist,pars);
 sto:=0;
 st:=pars.values['string'];
 //pars.add('heiparallaa=huhhahhei');
// writeln('<li>substring',st,'****', pars.text, '!!!</li>');
//st:=p_string;
 if pars.values['firstcut']<>'' then
 st:=copy(st,1,length(st)-strtointdef(pars.values['firstcut'],0));
 if pars.values['firstskip']<>'' then
 st:=copy(st,strtointdef(pars.values['firstskip'],0)+1,length(st));
 len:=length(st);
 sta:=strtointdef(pars.values['start'],1);
 if sta>0 then len:=len-sta+1;
 len:=strtointdef(pars.values['len'],len);
 cut:=strtointdef(pars.values['cut'],0);
 if pars.values['last']<>'' then
 begin
  sta:=len-strtointdef(pars.values['last'],0);
  if sta<0 then sta:=0;
  end;
 if pars.values['before']<>'' then
 begin
  apui:=pos(pars.values['before'],st);
   if apui>0 then sto:=len-apui+1;
  if (pars.values['missing']='empty') and
    (pos(pars.values['after'],st)<1) then
   len:=0;
  end;
 if pars.values['beforelast']<>'' then
  begin
   olen:=len;
   len:=_poslast(pars.values['beforelast'],st)-sta;
   if (pars.values['missing']='empty') and (len<1) then
   len:=0 else
   if len<1 then
   len:=olen;
   end;
 if pars.values['afterlast']<>'' then
 begin
   //sta:=_poslast(pars.values['afterlast'),st);
   sta:=_poslast(pars.values['afterlast'],st);
   //writeln('afterlast:',sta,pars.values['afterlast']);
   if sta>=0 then
   begin
    //sta:=sta+length(pars.values['afterlast'))+1;
    sta:=sta+length(pars.values['afterlast']);
    len:=len-sta+1;
   end
   else
   if (pars.values['missing']='empty') then
    len:=0 else
    sta:=1;
   end;
  if pars.values['after']<>'' then
 begin
  sta:=pos(pars.values['after'],st);
   //if (pars.values['missing']='empty') and
   // (pos(pars.values['before'],st)<1) then
   if sta>0 then
    sta:=sta+length(pars.values['after']) else
     if (pars.values['missing']='empty') then
     len:=0 else len:=9999;
  // writeln('<pre>'+pars.text+'X'+copy(st,sta,len)+'</pre>');
end;
 if cut>0 then len:=len-cut;
 if sto>0 then
 begin
 len:=len-sta+1-sto;
 end;
 result:=copy(st,sta,len);
end;




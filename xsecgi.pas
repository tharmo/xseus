unit xsecgi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$DEFINE DELPHI}
interface
uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages,
  SysUtils,
  //IdHTTPServer,IdContext,
//IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  Classes,
   xseglob;
type Tcgicall = object
  private
  public
        content:string;
        urli:string;
        query,mydir,myprogname,pathtrans:string;
        fields:tstringlist;
upfilename ://,upfile:
string;
        content_length:integer;
        vars:tstringlist;
        cookies:tstringlist;
      content_stream:tstream;
        procedure initcmd;
        //procedure init(c_maxsize:integer;req:TIdHTTPRequestInfo);
        procedure init(c_maxsize:integer);
        procedure getquery;
        procedure clear;
        function value(st:string):string;
        function conv(ins: string): string;
        function addvars(vari:string):string;
        procedure multipart(len:integer;ps:tstream);
        //procedure multipart(str:tmemorystream;len:integer);
    end;

implementation
uses xsexse,xsefun;
const crlf=#13#10;whitespace=#13#10+' ';
function getenv(evar:string):string;
  var  buf:array[0..2000] of char;
   pvar:array[0..2000] of char;
begin
  {$IFDEF DELPHI}
   strpcopy(pvar,evar);
//--    if GetEnvironmentVariable(pvar, buf, sizeOf(buf))=0 then
//--    result:='' else
//--    result:=(strpas(buf));
  {$ELSE}
    result:=lowercase(GetEnvironmentVariable(evar));
  {$ENDIF}

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
    result:=StringReplace(result,'"','',[rfreplaceall])
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



function tcgicall.conv(ins:string):string;
var i,chi:integer;ch:char;
begin
 i:=1;ch:=' ';RESULT:='';
 while i<=length(ins) do
 begin
   if (ins[i]='%') and (length(ins)>i+1) then
   begin
     chi:=16*pos(ins[i+1],'123456789ABCDEF')
     +pos(ins[i+2],'123456789ABCDEF');
     ch:=chr(chi);
     i:=i+2;
   end else
   if ins[i]='+' then ch:=' '
   else ch:=ins[i];
   result:=result+ch;
   INC(I)
    end;
   end;

function tcgicall.addvars(vari:string):string;
begin
  result:=GetEnv(vari);
  if result='' then exit;
  vars.values[vari]:=result;
  end;

const maxchar=256;

function StreamToString(aStream: TStream;sta,siz:integer): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
  try
   if siz<0 then siz:=astream.Size;
    SS := TStringStream.Create('');
    try
      aStream.Position := sta;
      SS.CopyFrom(aStream, siz);
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  except writeln('failed streamtostring',sta,', ',siz);end;

  end else
  begin
    Result := '';
  end;
end;

function search( pat: string; text: pchar): integer;
     var i, j, k, m, n: integer;
         skip: array [0..MAXCHAR] of integer;
         found: boolean;
     begin
       found := FALSE; search := 0;

       m := length(pat);
       if m=0 then begin
            search := 1;  found := TRUE; end;
       for k:=0 to MAXCHAR do skip[k] := m;
       for k:=1 to m-1 do     skip[ord(pat[k])] := m-k;

       k := m;  n := length(text);            while not found and (k <= n) do begin
            i := k; j := m;
            while (j >= 1) do
                 if text[i] <> pat[j] then j := -1
                 else begin
                      j := j-1;  i := i-1; end;
            if j = 0 then begin
                 result := i+1; found := TRUE;  end;
            k := k + skip[ord(text[k])];
            end;
       end;

function qsearch( pat: shortstring; text: pansichar;m,n:integer;
         skip: array  of integer): integer;
     var i, j,k: integer;found: boolean;
     begin
       try
       found := FALSE; result := 0;
       k := m;  while not found and (k <= n) do begin
        i := k; j := m;
            while (j >= 1) do
                 if text[i] <> pat[j] then j := -1
                 else begin
                      j := j-1;  i := i-1; end;
            if j = 0 then begin
                 result := i+1; found := TRUE; break; end;
            k := k + skip[ord(text[k])];
            end;
        except writeln('<li>faildeqsearch');raise;end;
     end;

function qsearchstream( pat: shortstring; text: tstream;start,m,n:integer;
         skip: array  of integer
        // ;var respc:pansichar
        ):integer;
     var i, j,k: integer;ch,ch2:ansichar;st,turha:string;//respc:pansichar;
         found: boolean;
     begin      // writeln('seeking:',start,' ',m,' ',n,' ', text.Size);
       turha:='';try try
       found := FALSE;  result := -1;  k := start+m;
       while not found and (k <= n) do
       begin
          i := k; j := m;
          text.Seek(i,sobeginning);  text.Read(ch,1);  turha:=turha+'+'+inttostr(i)+'='+ch;
          ch2:=ch;
          while (j >= 1) do
          if ch2 <> pat[j] then j := -1 else
          begin
              j := j-1;  i := i-1;
              text.seek(i,sobeginning);text.Read(ch2,1);   turha:=turha+'-'+ch2;
          end;
          if j = 0 then
          begin
                  text.seek(start+m+2,sobeginning);
                  result:=i+1;
         //         getmem(respc,i-start-m-3);
         //         text.Read(respc^,i-start-m-4);
         //         if i-start-m-4>1 then
         //           respc[i-start-m-4]:=#0;
                  found := TRUE;
//                  writeln('Find:////////////////////// i=',i,'  i-s:',i-start,^M^J,respc,'/',^M^J,result,'\\\\\\\\\\\\\\\\\\\\\'+^M^J+turha);
                  break;
          end;
          k := k + skip[ord(ch)];
       end;
        except writeln('<li>faildeqsearch');raise;end;
finally
                  //writeln('FOUND:',st,length(st), ' ',k);
                  //writeln('FOUND in:',result);
end;


     end;





//procedure tcgicall.multipart(str:tmemorystream;len:integer);
function _getheadlines(str:pansichar;resstl:tstringlist;var resst:string;var resi:integer):integer;
var i:integer;ch:ansichar;lf:boolean;
begin
  resst:='';result:=0;
  for i := 0 to length(str) - 1 do
  begin
    if str[i]=^M then
    continue;
    if str[i]=^J then
    begin
     if resst=''  then
     begin
       result:=resstl.count;
      //  writeln('??===',result,resstl.text);
        if resstl.Count=1 then
        begin
          resst:=copy(str,i+2,length(str)-i);
          //writeln('RESSSS:',resst,'len:',length(resst))
        end    else
        resi:=i;
       exit;
     end;
     resstl.add(resst);
     resst:='';
    end else
    begin
       resst:=resst+ansichar(str[i])+'';
       lf:=false;
    end;
  end;
 // writeln('****'+resst);
end;

function _getstreamhead(str:tstream;sta,sto:integer;resstl:tstringlist;var resst:string;var resi:integer):integer;
var i:integer;ch:ansichar;lf:boolean;TURHA:STRING;
begin
try
  resst:='';result:=0;i:=sta;TURHA:='';
 //      writeln('gethead:',sta,' sto:',sto,streamtostring(str,sta,sto-sta),'///');
  while i< sto - 1 do
  begin
   str.Seek(i,sobeginning);
   i:=i+1;
   str.Read(ch,1);
//   turha:=turha+ch+inttostr(ord(ch))+'.';
    if ch=^M then
    continue;
    if ch=^J then
    begin
      if resst=''  then
      begin
        result:=resstl.count;
        //  writeln('??===',result,resstl.text);
        if resstl.Count=1 then
        begin
                //str.Seek(i+2,sobeginning);
                 //str.read(resst,sto-i);
                 resst:=streamtostring(str,i,sto-i);
            //writeln('RES:',resst,'len:',length(resst),' ',i+2,' ',sto-i);

              //          resst:=copy(str,i+2,length(str)-i);
        end else resi:=i;
        exit;
      end;
      resstl.add(resst);
      resst:='';
    end else
    begin
       resst:=resst+ch;
       lf:=false;
    end;
  end;
  finally
  //writeln('finally:'+resst+'**'+turha+'___');
end;
end;

//procedure tcgicall.multipart(block:pansichar;len:integer;ps:tstream);
procedure tcgicall.multipart(len:integer;ps:tstream);
var st:string;                     tf:file;
vari,vali,
bou:shortstring;
i,j,m,k,sta,sto,garb,posbor,xx,posi:integer;
fline:boolean;
stl:tstringlist;ch:ansichar;ufilecount:integer;
         skip: array [0..MAXCHAR] of integer;
  stime:tdatetime;   fs:tmemorystream;
  hs:  THandleStream;
  turha:shortstring;fstream:tstringstream;
  //found:pansichar;
  upstart:pointer;
  multihead:boolean;
begin
 ufilecount:=0;
try
try
  try
  //myxs.respONSE.WriteHeader;myxs.httpinited:=true;
 // writeln('content-type:text/html'+crlf+crlf+'<h1>UPLOAD</h1>',^M^J);//,len,block,'\\\\');
  fline:=false;
  stl:=tstringlist.create;
  //getmem(block,len);
  //xx:= Str.read(Block^, len);
  // SetString(BufferStr, Buffer, ReadedBytes);
 { for i:=1 to  len-1 do
  begin
    if (pos(block[i],crlf)>0) then
    begin
      break;
    end else
    bou:=bou+block[i];
  end;
  }
  for i:=1 to  len-1 do
  begin
     ps.Seek(i,sofrombeginning);
     ps.read(ch,1);
    if (pos(ch,crlf)>0) then
    begin
      break;
    end else
    bou:=bou+ch;
  end;
  m := length(bou);
  try
  for k:=0 to MAXCHAR do skip[k] := m;
  except writeln('failedmultipartstart1',m);raise;end;
  // for k:=1 to m-1 do  writeln(ord(ansichar(bou[k])));
   for k:=1 to m-1 do  skip[ord((bou[k]))] := m-k;
   //for k:=1 to m-1 do  st:=st+inttostr(ord(bou[k]))+':='+inttostr(m-k);
  except writeln('failedmultipartstart2',m,' ',length(bou),' ',maxchar);raise;end;
  try
  //writeln('h1');
  sta:=1;
 // posbor:=qsearch(bou,block+sta,m,len-sta,skip);
  posbor:=qsearchstream(bou,ps,m+2,m,len,skip);
  //writeln('h2',posbor,'  ',sta,'');
  except writeln('seachfail');raise;end;
  while posbor>0 do
    begin
       stl.Clear;
//       if _getheadlines(found,stl,st,garb)=2 then
       if _getstreamhead(ps,sta+m+2,posbor-3,stl,st,garb)=2 then
      begin
         begin
         try
          //writeln('upfile****',stl.Text,'****',garb,'/****',posbor,'///');
           upfilename:=copy(stl[0],pos('filename=',stl[0])+9,length(stl[0]));
           upfilename:=StringReplace(upfilename,'"','',[rfreplaceall]);
           upfilename:=extractfilename(upfilename);
           //upstart:=found+garb+1;
           vars.add('upfilestart='+INTTOSTR(garb));
           vars.add('upfilelen='+INTTOSTR(posbor-garb-3));
           vars.add('upfilename='+upfilename);
           vars.add('upfilename_'+inttostr(ufilecount)+'='+upfilename);
           ufilecount:=ufilecount+1;

         except writeln('failedmultifile');end;
         end end else
          if stl.Count>0 then
         begin
         // writeln('varvalue!!!',stl.Text,'!!!',garb,'/!!!',st,'///');
             vali:=st;
           vari:=copy(stl[0],pos('=',stl[0])+1,length(stl[0]));
           try
           vari:=StringReplace(vari,'"','',[rfreplaceall]);
            fields.add(vari+'='+vali);
    //         writeln('VAR ',vari,'=',vali,'===');
           except writeln('failedstringreplace');end;
         end;
         // writeln(stl.count,'!!!!',stl.Text,'!!!!',st,'/!!!!');
       try
        sta:=posbor;
       //  posbor:=qsearch(bou,block+sta,m,len-sta,skip);
       posbor:=qsearchstream(bou,ps,posbor+m+2,m,len,skip);
        except writeln('failedmultipartend');end;

      end;
//writeln('CCC-',vars.text);
except writeln('failedmultipartx');end;
 FINALLY STL.FREE;END;
end;

procedure tcgicall.initcmd;
begin
fields:=tstringlist.create;
vars:=tstringlist.create;
cookies:=tstringlist.create;
end;

//procedure tcgicall.init(c_maxsize:integer;req:TIdHTTPRequestInfo);
  procedure tcgicall.init(c_maxsize:integer);
var i,j,fl,vl,lastmatch,boulen,re,garb:integer;
 vari,vali,st,st2,bou,lastst,binst,p_t,p_i,conttype:string;
 buf:array[0..2000] of char;
 inval:boolean;still:pchar; //postblock:pansichar;
 blocks,sofar:integer;
 stl:tstringlist;
 ff:file;varlist:tlist;ch:char;
 by:byte;
 postedfile:tmemorystream;
 done,loadok:boolean;apustl:tstringlist;
 STIME:TDATETIME;

 function _match(c:char):boolean;
 var i:integer;rep:boolean;   //x:tidstream;
 begin
    result:=false;
    rep:=false;
  if c=copy(bou,lastmatch,1) then lastmatch:=lastmatch+1
    else
    begin
     lastmatch:=1;
      end;
    if lastmatch>length(bou) then
    result:=true;
 end;
 begin
  STIME:=NOW;
   inval:=false;
   fields:=tstringlist.create;
   vars:=tstringlist.create;
   cookies:=tstringlist.create;
{§§   vars.add('CONTENT_LENGTH='+inttostr(req.ContentLength));
   vars.add('CONTENT_TYPE='+req.ContentType);

   vars.add('QUERY_STRING='+req.queryparams);
   vars.add('REMOTE_ADDR='+req.RemoteIP);
   addvars('SCRIPT_NAME');
   vars.add('HTTP_REFERER='+req.referer);
   addvars('HTTP_HOST');
   vars.add('PATH_TRANSLATED='+req.Document);
   p_i:=addvars('PATH_INFO');
   if p_i='' then
   begin
    p_i:=vars.values['SCRIPT_NAME'];
    vars.add('PATH_INFO='+p_i);
   end;
   addvars('HTTP_xseusinit');
   addvars('SERVER_URL');
   addvars('REQUEST_METHOD');
   addvars('HTTP_REFERER');
   if REQ.COOKIES<>NIL  then
     for I := 0 to req.cookies.Count - 1 do
     begin
      vars.add('COOKIE='+req.cookies.cookies[i].value);
      //vars.add('COOKIE='+req.cookies.Items[i].value);
      // cookies.add(req.cookies.Items[i].CookieName+'='+req.cookies.Items[i].CookieText);
      cookies.add(req.cookies.cookies[i].CookieName+'='+req.cookies.cookies[i].CookieText);
     end;
    §§}
   addvars('HTTP_COOKIE');
   st:=vars.values['PATH_INFO'];
   vars.add('document_root='+copy(p_t,1,length(p_t)-length(p_i)));
   if st='' then st:=vars.values['SCRIPT_NAME'];
   //§§ st:=req.document;
   vars.add('me='+st);
   //st:=StringReplace(st,'/','\',[rfreplaceall]);
   //st:=StringReplace(st,'\','/',[rfreplaceall]);
   st2:=extractfilename(st);
   vars.add('filename='+st2);
   st2:=copy(st2,1,length(st2)-length(extractfileext(st2)));
   vars.add('name='+st2);
   st:=extractfiledir(st);
   vars.add('filedir='+extractfiledir(vars.values['PATH_TRANSLATED']));
   st:=StringReplace(st,'\','/',[rfreplaceall]);
   vars.add('urldir='+st+'/');
  //conttype:=getenv('CONTENT_TYPE');
   conttype:=vars.values['CONTENT_TYPE'];
   content_length:=strtointdef(vars.values['CONTENT_LENGTH'],0);
   //§§content_stream:=req.poststream;
   IF (pos('multipart',CONTTYPE)=1) then
   begin
     loadok:=true;
     if (content_length>=c_maxsize) then loadok:=false;
     if not loadok then
     begin
        apustl:=tstringlist.create;
        if FileExists(vars.values['filedir']+g_ds+'.xseusaccess') { *Converted from FileExists*  } then
        begin
           apustl.loadfromfile(vars.values['filedir']+g_ds+'.xseusaccess');
           if strtointdef(apustl[0],-9)>content_length then
           loadok:=true;
        end;
    end;
    if not loadok then
        begin
         vars.values['error']:='Maxsize exceeded';
         writeln('content-type:text/html'+crlf+crlf+'<h1>Maxsize exceeded for file upload...</h1>'
          + apustl.Text+'<li>'+vars.Values['filedir']);
         exit;
        end;
    IF (loadok) and (pos('multipart',conttype)>0)
    then
    begin
      // multipart(pansichar(req.formparams),content_length);
      //PostedFile:=TMemoryStream.Create;
      //PostedFile.LoadFromStream(Req.PostStream);
      //PostedFile.SaveToFile('C:\File.stream');
      //!!getmem(postblock,content_length);
      try
      //!req.poststream.Read(postblock^,content_length);
      //multipart(postblock,content_length);
      //multipart(postblock,content_length,req.PostStream);
      //§§       multipart(content_length,req.PostStream);
      finally //freemem(postblock,content_length);
      end;
 //§§     vars.values['content']:=req.formparams;
      //writeln('<li>parsed<xmp>'+req.unparsedparams+'</xmp>');
      {  stime:=now;
       stl:=tstringlist.create;
       assignfile(ff,'');
       reset(ff,1);getmem(block,2*content_length+1);
       stime:=now;
       blocks:=(content_length+1) div 256;
       sofar:=0;           re:=0;
       i:=0;
       while sofar<content_length do
       begin
         blockread(ff,(block+sofar)^,CONTENT_LENGTH,re);
        sofar:=sofar+re;
            sleep(10);
         if i>100000 then breaK;
         if i>10000 then breaK;
       end;
       closefile(ff);
       try
       IF 1=0 THEN
       for i:=0 to blocks do begin
         blockread(ff,(block+sofar)^,1,re);sofar:=sofar+(re*256);
         if i mod 1000=0 then
         if re=0 then break;
        end;
       except writeln('failed in reading cgi input');end;
       stime:=now;
       writeln('multipart read');
       closefile(ff);
       multipart(block,content_length);
       stime:=now;
        }
       //vars.values['content']:=block;
       //stime:=now;
       end
      end
  else if (pos('text/xml',lowercase(conttype))=1) then
  begin
   // st:=req.queryparams;//'';
  //  if 1=0 then
    {   while not eof do
        begin
         read(ch);
         st:=st+ch;
        end;}
          for i:=1 to  content_length-1 do
       begin
        //§§             req.poststream.read(ch,1);
             st:=st+ch;
            //ps.Seek(i,sofrombeginning);
            //  ps.read(ch,1);
     end;
   //    req.poststream.seek(0,sofrombeginning);
         vars.values['form_xml']:=st+'_';
         vars.values['form_len']:=inttostr(content_length);
         addvars('HTTP_SOAPAction');
       //vars.savetofile('c:\temp\xform.tmp');
  end else
  begin
     begin
      //§§         st:=req.FormParams;
        if st<>'' then
         begin
           _split(st,'&',fields);
           for i:=0 to fields.count-1 do
           begin
            fields[i]:=conv(fields[i]);
            end;
         end;
     end;
          vars.values['content']:=st;
        end;
  urli:=GetEnv('SCRIPT_NAME');
  urli:='http://'+urli;
  buf:='';
  pathtrans:=GetEnv('PATH_TRANSLATED');
  MYDIR:=EXTRACTFILEDIR(PARAMSTR(0));
  myprogname:=extractfilename(paramstr(0));
  buf:='';
  //§§  query:=req.queryparams;
  end;

procedure tcgicall.getquery;
var i:integer; fl:tstringlist;
begin
  fl:=tstringlist.create;
         _split(query,'&',fl);
         for i:=0 to fl.count-1 do
         begin
          fields.add(conv(fl[i]));
          end;
   fl.free;
end;

procedure tcgicall.clear;
begin
        fields.clear;
        fields.free;
        end;

function tcgicall.value(st:string):string;
var xx:tstringlist;
begin
 if fields<>nil then
 result:=fields.values[st];
end;



end.


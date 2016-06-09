unit xsestrm;

{$mode delphi}

interface

uses
  Classes, SysUtils,xsexml;
//function xmistreamer(fname: String): ttag;
type tstreamer = class(tobject)
//constructor Create(CreateSuspended: boolean;);
sfile:tfilestream;
fname,skip:string;
eof:boolean;
//smem:carDINAL;
resutag:ttag;
curline,prevline,lastcline:string;
//partag, thistag, prevtag, roottag: ttag;
inskip,inquotedpar,incommentedpar,done: boolean;
curind,prevind:integer;
constructor Create(filee:string;resu:ttag);
destructor free;
function ReadLine:boolean;
//function parsexsi: ttag;
function parseline: ttag;
function newparsexsi: ttag;
//protected
 procedure doparse; //override;
end;


implementation
uses xsemisc,xseglob;

procedure doone;
begin
 writeln('<li>gotone');
end;


procedure tstreamer.doparse;
var              MAXTIMES:INTEGER;
  newStatus: string;t:ttag;
begin
   maxtimes:=0;
   //resutag.subtags.add(newparsexsi);
   newparsexsi;
end;

constructor tstreamer.Create(filee:string;resu:ttag);
begin
  //smem:=getheapstatus.totalallocated;
  resutag:=resu;//ttag.create;//resu;
  resutag.vari:='streamed';
  //inherited Create(false);//,500000);
  //FreeOnTerminate := true;
   fname:=filee;
   eof:=false;
  try
  sfile:=tfilestream.create(fname,fmopenread);
  except writeln('<li>could not open ['+fname+']');raise;end;
  //resume;
  //inherited Create(true);
end;

destructor tstreamer.free;
begin
  //resutag.killtree;
  sfile.free;
end;

procedure skipcomments(var line:string;sfile:tfilestream);
begin
     // to be handled later
end;

function tstreamer.ReadLine:boolean;
var
  RawLine: UTF8String;
  ch: AnsiChar;
begin
result := false;
ch := #0;
curind:=0;
curline:='';
while Sfile.Read(ch,1)=1  do
  if ch<>' ' then break else curind:=curind+1;
while ch<>#10 do
  begin
   if ch<>#13 then if ch<>#0 then
   curline := curline+ch;
   if Sfile.Read( ch, 1) <> 1 then
    begin
    eof:=true;
    break;
    end;
end;
end;
function tstreamer.parseline:ttag;
begin

end;


function _parseatts(tagi: ttag; line: string; var curpos: integer): boolean;
var
  ii, len,thisfar: integer;
  inq, skipwhite: boolean;
  c: char;
  par: string;
begin
  try
    Result := False;
    len := length(line);
    if len<=curpos then exit;
    //for ii := curpos + 1 to len do
    skipwhite := True;
    thisfar:=curpos+1;
    inq := False;
    ii := curpos;
    repeat
    begin
      ii:=ii+1;
      c := line[ii];
      if skipwhite then
      if pos(whitespace, c) > 0 then
        continue;
      skipwhite := False;
      if inq then  //within quotes
      begin
        if c = '"' then
        begin
          inq := False;
        end
        else
          par := par + c;
      end
      else  //not in quoted
      begin
        if (c = ':') and ((ii = len) or (pos(line[ii + 1], whitespace) > 0)) then
        begin
          tagi.addatt(par);
          par := '';
          curpos := ii + 1;
          exit;      //no more atts
        end
        else
        if c = ' ' then
        begin
          if trim(par)<>'' then tagi.addatt(par);
          par := '';
          skipwhite := True;
        end
        else
        if c = '"' then
          inq := True
        else
          par := par + c;
      end; //for-loop
    end;
    until ii>=len;
  except
    writeln('failed parseatts in parseindents');
  end;

end;
function _getfirstword(lin: string; var curpos: integer): string;
var
  i, len: integer;
begin
  Result := ''; //lin[curpos-1];//
  len := length(lin);
  for i := curpos to len do
  begin
    if pos(lin[i], ' ;,"+#(''''') > 0 then
    begin
      curpos := i;
      exit;
    end
    else

    if lin[i] = ':' then
      if i = len then
      begin
        curpos := i;
        exit;
      end
      else
      if pos(lin[i + 1], whitespace) > 0 then
      begin
        curpos := i;
        exit;
      end;// else
      result:=result+lin[i];
  end;
  //curpos:=i;

  curpos:=len + 1;
end;
function _gettextval(src: string; var curpos: integer;
var inquotedpar: boolean): string;
var apos:integer;
begin
  apos:=pos('''''''',src);
  if apos<1 then result:=copy(src,curpos+1,length(src)) else
  begin
  result:=copy(src,apos+3,length(src));
  apos:=pos('''''''',result);
  if apos>0 then result:=copy(result,1,apos-2) else
  inquotedpar := True;

  //writeln('<li>TVAL['+result+']'+''''''+'/from:{'+src+'}');
  end;
  curpos:=length(src);
  //if pos('<li>GO',src)>0 then writeln('<li>try:['+result+']'+''''''+'!');
end;


function tstreamer.newparsexsi:ttag;
var newtag,curtot:ttag;
  levs,indents:tlist;  curpos,i,skipping:integer;
  counter:integer;vari:string;

begin
 curtot:=resutag;
 counter:=0;
 levs:=tlist.create;
 indents:=tlist.create;
try
 levs.add(resutag);
 indents.add(pointer(0));
 skipping:=999999;

 while not eof do // one line at a time
 begin
  CURIND:=0;
  readline;
  i:=levs.count-1;
  curpos:=1;
   //if eof then
   if eof then if curline='' then exit;
   if curline='' then continue;
   //writeln('<li>skip?:',curind,'/',skipping,' ____ ',curline);
   if skipping<curind then continue else skipping:=9999;
   vari:=_getfirstword(curline, curpos);
   if _matches(skip,vari) then begin skipping:=curind;continue;end;
   //if skipping then
   begin
      while (i>0) and (integer(indents[i])>=curind) do
      begin
       //writeln('<li>backing: from:'+curtot.head,'  ____to:',ttag(levs[i]).head);
       curtot:=levs[i-1];
       levs.delete(i);
       indents.delete(i);
       //break;
       i:=i-1;
      end;
     // skipping:=curind>3;
      //skipcomments(curline,sfile);
        newtag:=ttag.create;
        levs.add(newtag);
        indents.add(pointer(curind));
        newtag.vari:=vari;
        if CURline[curpos] <> ':' then   _parseatts(newtag,curline,curpos);
        newtag.vali := _gettextval(CURline, curpos, inquotedpar);
        curtot.subtags.add(newtag);
        counter:=counter+1;
        //if counter mod 1000=1 then
        //if curtot=resutag then
        // writeln('<li>addeD',counter,newtag.heAD,':::',LEVS.COUNT,'___TO:',ttag(curtot).vari);
        CURTOT:=newtag;
  end;
end;
finally
 levs.free;
 indents.free;
end;


end;

end.



exit;
try
while (not eof) do
begin
 IF maxtimes>1000000 THEN begin writeln('<li>exceepded_max');exit;end;
 maxtimes:=maxtimes+1;
 try
 writeln('<li>Open connection '+'/'+fname);
 smem:=getheapstatus.totalallocated;
 //roottag:=nil;
 inquotedpar := False;
 incommentedpar := False;
 prevind:=0;
 inskip:=false;
 lastcline:='';
 t:=parsexsi;
 if t=nil then writeln('<li>gotmil') else
 writeln('<li>got <xmp>'+'/'+t.xmlis+'</xmp>');
 resutag.SUBTAGS.ADD(parsexsi);//doone;
 //break;
 //suspend;
 finally
 end;

end;
finally
 writeln('<li>RESULTx:',resutag.xmlis);
 writeln('close connection '+'/'+fname);
 sfile.free;
 writeln('connectionmemlost:'+floattostr(getheapstatus.totalallocated-smem));
 // terminate;
  end;


function tstreamer.parsexsi: ttag;
var
 line: string;
  //i, ichars, thisind, prevind: integer;
  //partag, thistag, prevtag, roottag: ttag;

  function _getfirstword(lin: string; var curpos: integer): boolean;
  var
    i, len: integer;
  begin
    Result := True;
    len := length(lin);
    for i := curpos to len do
    begin
      if pos(lin[i], ' ;,"+#(''''') > 0 then
      begin
        curpos := i;
        exit;
      end
      else

      if lin[i] = ':' then
        if i = len then
        begin
          curpos := i;
          exit;
        end
        else
        if pos(lin[i + 1], whitespace) > 0 then
        begin
          curpos := i;
          exit;
        end;// else

    end;
    //curpos:=i;
    curpos:=len + 1;
  end;



  function _parseats(tagi: ttag; lin: string; var curpos: integer): boolean;
  var
    ii, len,thisfar: integer;
    inq, skipwhite: boolean;
    c: char;
    par: string;
  begin
    try
      Result := False;
      skipwhite := True;
      thisfar:=curpos+1;
      if trim(line) = '' then
        exit;
      //if line[i]<>')' then

      inq := False;
      len := length(lin);
      for ii := curpos + 1 to len do
      begin
        c := lin[ii];
        //if c='¤' then break;
        //if c=' '  then
        //    continue;
        if skipwhite then
        if pos(whitespace, c) > 0 then
          continue;
        skipwhite := False;
        //IF INQ THEN write(',',c) ELSE WRITE('_',C);
        if inq then  //within quotes
        begin
          if c = '"' then
          begin
            //tagi.attributes.add(par);par:='';
            //writeln('***'+par+'///');
            inq := False;
          end
          else
            par := par + c;
        end
        else  //not in quoted
        begin
          //if c=')' then  ### SYNTAX CHANGE
          if (c = ':') and ((ii = len) or (pos(lin[ii + 1], whitespace) > 0)) then
          begin
            //writeln('<li>atsend:',tagi.vari,length(par),par,'|');
            //if trim(par) <> '' then tagi.addatt(trim(par));
            tagi.addatt(par);
            //if pos('sep',par)>0 then writeln('<li>parseP|',cut_rs(par)+'|</li>');//<xmp>'+tagi.listraw+'</xmp>');
            //tagi.attributes.add(par);
            par := '';
            curpos := ii + 1;
            exit;      //no more atts
          end
          else
          if c = ' ' then
          begin
            if trim(par)<>'' then tagi.addatt(par);
            //if trim(par)<>'' then tagi.addatt(trim(par));
            //if pos('sep',par)>0 then writeln('<li>parseP|',cut_rs(par)+'|</li>');//<xmp>'+tagi.listraw+'</xmp>');
            par := '';
            skipwhite := True;
            //writeln('<li>aat:',tagi.attributes.text,'</li>');
          end
          else
          if c = '"' then
            inq := True
          else
            par := par + c;
        end; //for-loop
      end;
      if trim(par) <> '' then
            tagi.addatt(trim(par));
            par := '';
            curpos := ii + 1;
    except
      writeln('failed parseatts in parseindents');
    end;

  end;
  function _gettextval(src: string; var curpos: integer;
  var inquotedpar: boolean): string;  //not used now, needed if we parse inline comments
  var apos:integer;
  begin
    apos:=pos('''''''',src);
    if apos<1 then result:=copy(src,curpos+1,length(src)) else
    begin
    result:=copy(src,apos+3,length(src));
    apos:=pos('''''''',result);
    if apos>0 then result:=copy(result,1,apos-2) else
    inquotedpar := True;

    //writeln('<li>TVAL['+result+']'+''''''+'/from:{'+src+'}');
    end;
    curpos:=length(src);
    //if pos('<li>GO',src)>0 then writeln('<li>try:['+result+']'+''''''+'!');
  end;



  function ReadLine(Stream: TStream):string;
  var
    RawLine: UTF8String;
    ch: AnsiChar;
  begin
  result := '';
  ch := #0;
  while (Stream.Read( ch, 1) = 1)  do
  begin
      //if (ch =#13) then break;
      if (ch =#10) then break;
      if ch<>#10 then
      result := result+ch;
  end;
    if (ch<>#10)  then eof:=true;
 end;

var
  curpos: integer;tagword,startwhite:string;
  var
   iii,ichars, thisind: integer;

  //line: string;

   //partag, thistag, prevtag, roottag: ttag;


//parsexsi
begin
 // partag := nil;
 // roottag := nil;
  try
    //for i := 0 to sl.Count - 1 do
    iii:=0;
    while not eof do
    begin
      try
        if lastcline<>''then
        begin
         line:=lastcline;
         writeln('<li>tryagin:',lastcline);
         //lastcline:='';
        end else
        line:=readline(sfile);
        iii:=iii+1;
        writeln('<li>tryline:',iii,line ,'(',lastcline,')</li>');
        if iii>1000000 then begin writeln('temporaryrestriction');break;end;
        if inquotedpar then
        begin
          //line:=readline(sfile);
          if pos('''''''', line) > 0 then
          begin  //will have to deal with escaped """'s
            inquotedpar := False;
            partag.xquoted := True;
            partag.vali:=partag.vali+copy(line,0, pos('''''''', line)-1);
            continue;
          end;
          partag.vali := partag.vali + line + lf;
          continue;
        end;
        if trim(line) = '' then
          continue;
        //line := sl[i];
        ichars := 1;
        prevind := thisind;
        thisind := 0;
        while (ichars < length(line)) do
        begin
          if (line[ichars] = ' ') then
          begin
            thisind := thisind + 1;
            ichars := ichars + 1;
          end
          else if (line[ichars] = #09) then  //handle tabs: very crude - basically tabs are not supported
          begin
            thisind := thisind + (gc_tabsize - (thisind mod gc_tabsize));
            ichars := ichars + 1;
          end
          else
            break; // whitespace skipped over
        end;
        curpos := ichars;
        if (incommentedpar) then
            if thisind>prevind then
            begin //writeln('endcomment');
             thisind:=prevind;continue;
            end else incommentedpar:=false;
        if line[curpos] = '#' then
        begin
          if copy(line,curpos,3)='###' then incommentedpar:=true;
          continue
        end;
        if (curpos=1) and (partag<>nil) then //no indent .. should not happen?
        begin thisind:=partag.hasindent;partag:=partag.parent;
        end else
        if (partag <> nil) and (partag <> roottag) then
        while (thisind <= partag.hasindent) do
        begin
            try
              writeln('<li>back:',partag.head+'/',partag.hasindent);
              if partag.hasindent<4 then //pauselevel then
              begin
                writeln('<li>EXIT<b>',lastcline+'</b>');
                if lastcline='' then begin  lastcline:=line; exit;end
                else  lastcline:='';      //why?
              end;
              partag := partag.parent;
            except
              writeln('failindent', thisind)
            end;
        end;
        if line[curpos] = '@' then
        begin  //this has to be handled. now just reads one att=val  strig
          _parseats(partag, LINE, curpos);
          //partag.attributes.add(copy(line,curpos+1,9999));
          continue;
        end;
        //INDENTATION HANDLED. NOW CONTENT OF LINE
        if (line[curpos]=':') or (line[curpos]='.') //TEXTNODE
          or ((curpos=1) and (partag<>nil)) then //A BIT STRANGE:  unindented lines are treated as text values to parent
        begin
          //logwrite('#'+line+inttostr(curpos)+line[curpos]);
          startwhite:=' ';
          if (line[curpos]='.') then startwhite:=lf;
          if curpos>1 then  curpos := curpos+1;//2;

          if   (partag.subtags.Count = 0)    then
          begin
            //logwrite('w:'+startwhite+'/t:'+partag.vali+'?' + startwhite+'?'+copy(line,curpos,9999)+'!');
            partag.vali := partag.vali+ startwhite+_gettextval(line, curpos, inquotedpar);
          end
          else
          begin
            thistag := ttag.Create;
            thistag.hasindent := thisind;
            thistag.parent := partag;
            partag.subtags.add(thistag);
            thistag.vari := '';//VALUE
            thistag.vali := _gettextval(line, curpos, inquotedpar);
            if startwhite=crlf then thistag.vali:=crlf+thistag.vali;
            //writeln('<li>gottextline:',curpos,'|',thistag.vali,'',line[curpos],'</li>');
          end;
          partag:=thistag;
          continue;
        end;
        //normal line wth element, possibly atts and text
        begin
           _getfirstword(line, curpos);
           tagword:=copy(line, ichars, curpos - ichars);
          thistag := ttag.Create;
          thistag.hasindent := thisind;
          if partag = nil then
          begin
            partag := thistag;
            roottag := thistag;
          end else
          begin
            thistag.parent := partag;
            partag.subtags.add(thistag);
           end;
          thistag.vari := tagword; //copy(line, ichars, curpos - ichars);
          //logwrite('elem:'+thistag.vari+inttostr(curpos)+' // '+inttostr(ichars)+' //'+line+'//'+inttostr(length(line)));
          partag := thistag;
          if (length(line) > curpos) then
            //##SYNTAX CHANGE if line[curpos]='(' then  //atts ( start directly
            if line[curpos] <> ':' then
            begin
              _parseats(thistag, LINE, curpos);
            end
            else
              curpos := curpos + 1;
          //writeln('<li>noats:'+line+'</li>');
          if length(line) > curpos then //line goes on .. with value for tag
            //if line[curpos]=':' then
          begin
            try
              thistag.vali := _gettextval(line, curpos, inquotedpar);
            except
              writeln('--------failtextline' + line);
            end;
          end;// else  partag:=thistag;
        end;
      except
        writeln('failed parsing line ',iii,line);
      end;
    end;

  finally
    RESULT:=ROOTTAG;

//    sfile.free;
  end;
end;


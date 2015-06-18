unit XSEJUNK;
//DELETED STTUFF THAT I MAY NEED LATER
{$mode delphi}

interface

uses
  Classes, SysUtils;

implementation
{function txseus.selroot(st: string; def: ttag; var rest: string;
  needtowrite: boolean; var gottafree: boolean): ttag;
var
  newtag, atag: ttag;
  txt, apust: string;
  rl: TList;
  i, apui: integer;
begin
  try
    Result := nil;
    gottafree := False;
    rest := '';
    if st = '' then
    begin
      Result := def;
      rest := '';
    end
    else
    begin
      if pos('file://', st) = 1 then
      begin
        //writeln('remembertofree:',st,appta.vari);
        gottafree := True;
        st := copy(st, 8, 256);
        apui := pos(';', st);
        if apui > 0 then
        begin
          rest := copy(st, apui + 1, 999);
          st := copy(st, 1, apui - 1);
        end
        else
          rest := '';
        apust := _indir(st, outdiri, self, needtowrite);
        Result := tagfromfile(apust, nil);
        //atag := ttag.Create;
        //atag.fromfile(apust, nil);
        ////if rest='' then
        //Result := atag.subtags[0];
        //atag.clearmee;
        exit;
      end
      else
      if pos('http://', st) = 1 then
      begin
        gottafree := True;
        txt := _httpget(st, -1, curbyele.getattributes);
        Result := tagparse(txt, False, True);
        //Result := ttag.Create;
        //if txt <> '' then
        //  Result.parse(txt, False, True);
        //Result := Result.subtags[0];
      end
      else

      if st[1] = '#' then //***any id-attribute anywhere
      begin
        apui := pos('/', st);
        if apui = 0 then
          apui := length(st) + 1;
        ///writeln('___',copy(st, 2, apui - 2),'---');
        ATAG := x_ids.findobject(copy(st, 2, apui - 2));
        Result := ATAG;//.subtags[0];
        if atag = nil then
        begin
          rest := '';
          exit;
        end;
        rest := copy(st, apui + 1, 999);
        //writeln('ID:'+result.vari+':'+copy(st, 2, apui - 2)+'!'+copy(st, apui+1, 999));
      end
      else
      if st[1] = '/' then //***ROOT
      begin
        Result := xml;
        rest := (copy(st, 2, 999999));
      end
      else
      if st[1] = '=' then //***RESTAG
      begin
        Result := curtoele;
        rest := (copy(st, 2, 999999));
      end
      else
      if st[1] = '!' then ////***handerslers
      begin
        //writeln('<h1>selappt:</h1>');
        writeln('selappt:'+copy(st, 2, length(st)));
        if (length(st) < 2) or (st[2] <> '!') then
        begin
          Result := x_handlers.subt(copy(st, 2, length(st)));
          writeln('<h2>root!'+st+'</h2><pre>'+RESULT.xmlis+'</pre>');
          writeln('<h2>root!'+st+'</h2><pre>'+x_handlers.xmlis+'</pre>');
        end
        else
          Result := curbyele.subt(copy(st, 3, length(st)));
        ;
        rest := '';
        //rl:=tlist.Create;
        //writeln('xxxxsdxxx');
        //apui := pos('/', st);
        //if apui=0 then apui:=length(st);
        //if (length(st)<2) or (st[2] <> '§') then
        //Result := txseus(xseusp).x_handlers.subt(copy(st, 2, apui - 2))
        //else
        //Result := appta.subt(copy(st, 2, apui - 2));
        //rest := copy(st, 2, 999);
        //writeln('xxxxsdxxx'+result.xmlis);
      end
      else
      if st[1] = '%' then ////***BOOKMARKS
      begin
        //rl:=tlist.Create;
        apui := pos('/', st);
        if apui = 0 then
          apui := length(st) + 1;
        ///writeln('___',copy(st, 2, apui - 2),'---');
        ATAG := x_bookmarks.subt(copy(st, 2, apui - 2));
        Result := ATAG;//.subtags[0];
        try
          //writeln('books.',ATAG.SUBTAGS.COUNT,copy(st, 2, apui - 2),'!<pre>'+ATAG.xmlis,'#',ATAG.VARI,'</pre>');
          Result := ATAG.subtags[0];
          //writeln('!!!',ttag(atag.subtags[0]).xmlis,'???');
        except
          writeln('nononbiik');
        end;
        rest := copy(st, apui, 999);
      end
      else  //***CURRENT
      begin
        rest := st;
        //result:=selta;
        Result := def;
      end;
    end;
  finally

  end;
end;
}

end.


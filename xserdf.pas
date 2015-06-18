unit xserdf;

{  $MODE Delphi}

interface
type thash=class(tobject)
  obname:string;
  hasnext:boolean;
  //next:pointer;
  function getnext:thash;
end;

type thashes=class(tobject)
  next:thashes;
end;



implementation
  function thash.getnext:thash;
  begin end;

function _ElfHash(const Value: string): Integer;
var
  i, x: Integer;
begin
  Result := 0;
  for i := 1 to Length(Value) do
  begin
    Result := (Result shl 4) + Ord(Value[i]);
    x := Result and $F0000000;
    if (x <> 0) then
      Result := Result xor (x shr 24);
    Result := Result and (not x);
  end;
end;


end.
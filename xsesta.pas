unit xsesta;        //not in use (yet / any more).. probably a good idea esp for start/stop, templates,...

{$mode delphi}

interface

uses
  xsexml,
  Classes, SysUtils;
//type txseus=class;
type tstate=class(tobject)
   toe,frome,bye,tpls,tpl:ttag;
   prev:tstate;
   function gettemplates:ttag;
   constructor create(prevs:tstate);
   constructor createfirst(xp:pointer);
   destructor free;
end;
implementation
uses xsexse;
function tstate.gettemplates:ttag;
begin
 result:=nil;
 //while
end;

constructor tstate.create(prevs:tstate);
begin
  prev:=prevs;
  toe:=prev.toe;
  frome:=prev.frome;
  bye:=prev.bye;
  tpls:=prev.tpls;
  tpl:=prev.tpl;
end;
constructor tstate.createfirst(xp:pointer);
var x:txseus;
begin
  toe:=x.curtoele;
  frome:=x.curfromele;
  bye:=x.curbyele;
  tpls:=nil;
  tpl:=nil;
end;
destructor tstate.free;
begin

end;

end.


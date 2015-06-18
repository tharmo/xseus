unit xsecmd;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  xsexse,xserver,xsefun,xsexml;
var //axseuscfg: txseusconfig;
  axseus:txseus;
procedure cmdline;
implementation
procedure cmdline;
var i:integer; inif,ifile,xfile:string;sws:tstringlist;
begin
  inif := extractfiledir(ParamStr(0)) + g_ds + 'xseus.xsi';
  xseuscfg := txseusconfig.Create;
  xseuscfg.get(INIF);
  //writeln(xseuscfg.config.xmlis);
  sws:=tstringlist.create;
  for i := 0 to ParamCount do
      sws.add(paramStr(i));
  xfile:=sws.values['xsi'];
  ifile:=sws.values['htmi'];
  //writeln('ifile:'+ifile,':::',sws.text+':::',sws.count);
  //for i := 0 to sws.count-1 do
  //    writeln('//',sws[i]);
  axseus:=txseus.create(true);
  axseus.x_cmdline:=true;
  if ifile='' then axseus.ifile:=xfile else axseus.ifile:=ifile;
  axseus.doit;
  //writeln('DIDIDI');axseus.clear;
  // writeln('DIDIDI');axseus.free;
end;

end.


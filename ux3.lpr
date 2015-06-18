program ux3;

{$mode objfpc}{$H+}

uses
  cthreads,  dialogs,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms;//,xserver;

{$R *.res}

begin
  showmessage('go');
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Run;
end.


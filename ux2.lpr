program ux2;
{$MODE Delphi}

{$M+}
uses
  cthreads,  //daemonapp, // xsedae,
  sysutils,
  Forms, Interfaces,
  classes,
  xserver in 'xserver.pas' {xseusform: Txseusform};

begin
 RequireDerivedFormResource := True;

try

{inidir:=extractfiledir(paramstr(0))+G_DS;
lokifile:= tfilestream.create(inidir+'xseus1.log',fmcreate or fmopenwrite);
lokifile.WriteAnsiString('go');
lokifile2:=tfilestream.create(inidir+'xseus2.log',fmcreate or fmopenwrite);
}
  begin
    //writeln('init app');
    try
    forms.Application.Initialize;
    except
      writeln('nogo');
      //lokiwrite('XXXXXXXXXXXXXXXXXXXXXnogo');
    end;
    //writeln('APP inited');
    Application.CreateForm(Txseusform, xseusform);
    //lokiwrite(('*************Formi_is_created********'));
    //lokiwrite('running!!!!!!!!!!!!');
    //startxseus;

   forms.Application.Run;
   //huihai;
    //lokifile.free;
  end
  ;

 finally
   //lokiwrite(('app_stop'));
   lokifile.free;
    //logwrite('finaali');
    halt;
 end;
end.



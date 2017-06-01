unit xsecmd;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  xsexse,xserver,xsefunc,xsexml,xseglob,xsemisc;
var //axseuscfg: txseusconfig;
  axseus:txseus;
function cmdline:boolean;
implementation
function cmdline:boolean;
var i:integer; inif,ifile,xfile,uri,handler:string;sws:tstringlist;
begin
  //writeln('cmdlinestarting');
  inif := extractfiledir(ParamStr(0)) + g_ds + 'xseus.xsi';
  //for i:=0 to paramcount do writeln('***'+paramstr(i));
  g_xseuscfg := txseusconfig.Create;
  inif:='/home/t/xseus/xseus.xsi';
  g_xseuscfg.get(INIF);
  //ifile:=if (FindCmdLineSwitch('c', ['-', '/'], True)) then

  //writeln(xseuscfg.config.xmlis);
  sws:=tstringlist.create;
  for i := 0 to ParamCount do
      sws.add(paramStr(i));
  xfile:=sws.values['x'];
  ifile:=sws.values['i'];
  handler:=sws.values['h'];
  //writeln('ifile:'+ifile,':::',sws.text+':::',sws.count);
  //for i := 0 to sws.count-1 do
  //    writeln('//',sws[i]);
  if ifile='' then ifile:=xfile;
  axseus:=txseus.create(nil);
  with axseus do
  begin
    x_cmdline:=true;
    x_objectfile := ifile;//'/home/t/xseus/www/cmd.htmi';
    x_data := tagfromfile(axseus.x_objectfile, nil);
    //Fwriteln(handler+' GoTxmlhan'+axseus.x_data.xmlis);
    x_form:=ttag.create;
    x_form:=readparamstoform(sws);
    xml.vari := 'xseus';
    xml.subtagsadd(x_data);
    xml.subtagsadd(x_form);
    //xml.subtagsadd(x_cgi);
    if xfile='' then   x_commandfile := _indirs(x_data.att('class'), g_xseuscfg.apppaths) else x_commandfile:=xfile;
      //writeln('calling class:'+x_commandfile);
      try
       //logwrite('read:'+x_data.att('class')+'ZZ'+X_DATA.XMLIS+'/X_DATA');
        if not(readxsi(x_commandfile,handler)) then result:=false else result:=true;
        //logwrite('faireadxsi:'+x_myhandler.xmlis);
      except
        //writeln('no handlers in:' + x_objectfile + ' not found in ' +
        // x_commandfile + '</li>');
     //   writeln('no handlers in:' + x_objectfile + ' not found in ' +
     //    x_data,.listxml + '</li>');
      end;

    //xml.subtags.add(x_myhandler);
    //logwrite('getob');
    //x_object := _getobjectdata(x_objectfile, x_url, x_host, x_handlername, nil, nil);
    //xml.subtagsadd(x_object);
    CurBYEle := x_myhandler;
    xml.subtagsadd(curbyele);
    //logwrite('3');
    //xml.subtags.add(x_handler);
    //x_templates := x_myhandler;
    curtemplates := nil;//curbyele;
    curtoele := nil;
    curfromele := xml;

    end;


  uri:='/xseus';
    //    if txseus(axseus).init(uri,host,protocol,session.sestag,self) then //params,uploads);
  begin
        //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
         axseus.htmlinited:=true;

        //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
        try
         //WRITELN('HELÖLO');
        axseus.dosubelements;
          //if Tserving(t_thisprocess).HeaderHasBeenWritten then logwrite('heaadhas') else logwrite('head has NOT');
        //writeln(uri+'!DIDIDID');//+ext+'did:'+uri+'/mymem:'+inttostr(GetFPCHeapStatus.CurrHeapUsed));
        except  logwrite('fail: xseus.run');  end;

  end;

end;
end.


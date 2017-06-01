unit xsetimers;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
//  windows,
{$ELSE}
  LCLIntf, LCLType, //LMessages,
{$ENDIF}
  classes,xsefunc,customtimer,//ExtCtrls,
sysutils,//dialogs,forms    //,StdCtrls;
xsexml,  xseglob;

type tschedthread=class(tthread)
  timertask:tobject;
  procedure execute;override;
end;
//  type ttimer=class(tobject); ss
type ttimertask=class(tobject)
  timer:tcustomtimer;
  thread:tschedthread;
  interval:integer;
  url,cookie,name:string;
 procedure dotimer(Sender: TObject);
  constructor create(ini:tstringlist);
  end;
implementation
//uses //xserver;//,IdCustomHTTPServer;
 //var t:tschedtask;
   var x_timers:ttag;
procedure tschedthread.execute;
  var sl,heads:tstringlist;res:ansistring;i:integer;t:ttimertask;
  begin
{
  try
  try
  //   showmessage('HJUIHAI');
   t:=ttimertask(timertask);
    sl:=tstringlist.create;
    heads:=tstringlist.create;
    if t.cookie<>'' then heads.add('Cookie='+t.cookie);
    logwrite('gettimer:'+heads.text);
    //sl.add
   // _tcpget('217.119.43.186','ERDG00A',2000)
  //  (_httpPOST('http://localhost/test.htme?open','',nil,TRUE));
    (_httpPOST(t.url,'',heads,TRUE,res));
    sl.text:=res;
    //postres:3Set-Cookie: IDHTTPSESSIONID=oNRq9TZueSMNINC; path=/
 //          IdHTTP1.Response.RawHeaders.Extract('Set-cookie', TempStrList);
    //  logwrite('dotimer'+sl.text);

    for i:=0 to sl.Count - 1 do
    if pos('Set-Cookie',sl[i])>0 then
    begin
     t.cookie:=copy(sl.strings[i],pos(':',sl[i])+2,999);
      //logwrite('SET:'+cookie+'|'+sl[i])
    end
  //  else
   //   logwrite('postres:'+inttostr(i)+sl[i]);
  //  (_httpPOST('http://www.valt.helsinki.fi/blogs/harmo/sauna.htm','',nil,TRUE));
    //sl.savetofile('j:\www\blogs\harmo\sauna2.htm');
  except
    sl:=tstringlist.create;
    sl.add('huihai');
    sl.savetofile('c:\xser\turha1.tmp');
    sl.Free;
    //raise;
  end;
     //showmessage('HUIHAI');
  finally
   sl.Free;
   heads.Free;
  end;
  }
  end;
     //showmessage(_httpPOST('http://localhost/test.htme?sauna','',nil,TRUE));


 constructor ttimertask.create(ini:tstringlist);
 //var //sessio: tidhttpsession;
 begin
 try
  timer:=tcustomtimer.Create(nil);
  timer.Enabled:=true;
 // timer.Enabled:=false;
  timer.ontimer:=dotimer;
  timer.Interval:=strtointdef(ini.Values['interval'],600000);//default 1h
  timer.name:=ini.Values['name'];
  name:=ini.Values['name'];
  cookie:=''+ini.Values['cookie'];
//§§  sessio:=tidhttpsession.CreateInitialized(xseusserver.server.sessionlist,cookie,'127.0.0.1');
//§§  xseusserver.server.sessionlist.add(sessio);

  cookie:='IDHTTPSESSIONID='+cookie+'; path=/';
  url:=ini.Values['url']; //'http://localhost/test.htme?sauna';
  logwrite('Timer '+name+' created'+ini.text);
  dotimer(self);

 except
     logwrite('Timer '+name+' NOT created'+url);

 end;
 end;
procedure ttimertask.dotimer(Sender: TObject);
  var sl:tstringlist;
  begin
  inherited create;
   try
     thread:=tschedthread.create(TRUE);
     thread.timertask:=self;
     thread.FreeOnTerminate := true;
     thread.resume;
   except
    sl:=tstringlist.create;
    sl.add('huihai');
    sl.savetofile('c:\xser\timererrors.log');
    sl.free;
        //showmessage('nogo');
   end;
    //interval:=2000;
    //thread.Free;
    //thread.execute;
    //sleep(interval);
  end;

end.

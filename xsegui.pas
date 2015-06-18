unit xsegui;

{$mode delphi}

interface

uses
  {$IFDEF LINUX}
   //cthreads,
  {$ENDIF}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  // blcksock, sockets, Synautil,
{$IFNDEF FPC}  Messages, {$ELSE} LCLIntf, LMessages,
  LclType, interfaces, LResources, {$ENDIF}
  syncobjs,
  //xseglob,
  //xsecgi,
  //xsexml,
  //xsefunc,
  //xseexp,
  xsefunc,
  //xsedif, ExtCtrls,
  //xseftp,
  //xsetimers,
  //xsesmtp,// xsesta,
  //xsexse,
  StdCtrls, ExtDlgs;






type

  { Txseusformi }

  Txform1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    //CalculatorDialog1: TCalculatorDialog;
    procedure Button1Click(Sender: TObject);
    //procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure showlogClick(Sender: TObject);
    procedure memolog(s: string);
  private
    //procedure GetPassword(var Password: string);
    //procedure Status(ASender: TObject; const AStatus: TIdStatus;
    //  const AStatusText: string);
  public
    //function verpeer(Certificate: TIdX509; AOk: boolean): boolean;
  end;

var xseusformi:Txform1;


implementation
{  R *.lfm}


procedure Txform1.memolog(s: string);
begin
  // logmemo.Lines.add(s);
end;

procedure Txform1.FormCreate(Sender: TObject);
var
  inif: string;
  i: integer;
begin
  //exit;
  try
    //  inherited create(NIL);
    //LOGWRITE('CREATING FORM');
    //logicriti := False;
    //g_debug := False;
    //logicriti:=tcriticalsection.create;
    //logmemo.Lines.Add('xseusformi starting');
    //logwrite('Starting xseusformi');
    //inherited create(nil);
    //loglines := TStringList.Create;
    //xseusserver := TxseusServer.Create;
    //logwrite('created xseusform!');
   { try
      try
        if xseuscfg.timers <> nil then
          for i := 0 to xseuscfg.timers.subtags.Count - 1 do
          begin
            //logwrite(ttag(timersini.subtags[i]).listraw);
            if ttag(xseuscfg.timers.subtags[i]).vari = 'timer' then
              ttimertask.Create(
                TStringList(ttag(xseuscfg.timers.subtags[i]).getattributes));
            //(self);
          end;
      except
        logwrite('problems: timers /xseus.ini, timers-section');
      end;
      try
        if xseuscfg.ftp <> nil then
        begin
          logwrite('ftpserver create:');
          //ftpserver := txseusftp.Create;
          logwrite('ftpserver created');
        end;
      except
        logwrite('problems: ftp-server');
      end;
      try
        if xseuscfg.smtp <> nil then
        begin
          //Â§Â§ smtpserver := txseussmtp.Create(xseuscfg.smtp);
          logwrite('smtpserver created');
        end;
      except
        logwrite('problems: smtp-server. ');
      end;
    except
      logwrite('failed to initialize');
      exit;
    end;
    }
  except
    //logwrite('xs initialization failed ' + inif);
    //exit;
  end;
  //logwrite('XXXXXXXXXXXXXXxXSEUSFORM is  CREATED');
  //  xseusserver := TxseusServer.Create;

end;

procedure Txform1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  //showmessage('DEACIVATE');
  //xseusserver.server.active := False;
  //showmessage('DEACIVATEd');
end;

procedure Txform1.Button1Click(Sender: TObject);
begin
  //restartserver;
end;


procedure Txform1.showlogClick(Sender: TObject);
begin
  //logmemo.Lines := loglines;  //WORKAROUND TO HANDLE MEMO TEXT ONLY IN MAIN THREAD
  //loglines.Clear;
end;

{procedure Txform1.FormActivate(Sender: TObject);
begin
  xseusserver:=txseusserver.create;
  //inherited paint;
  //show;
  logwrite('server is created');
  runserver;
end;
}
procedure Txform1.FormDeactivate(Sender: TObject);
begin
//logwrite('deactivation');

end;
  //logwrite('ready to run');
  //runserver;

initialization
//logwrite('initialization');
{$i xsegui.lrs}
//runserver;
end.


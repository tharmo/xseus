unit clip;

{ $mode objfpc}
{$mode delphi} {$H+}
interface

uses
  //myclips,
  //lcl,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls,//clipbrd,
   interfaces,lresources,LCLIntf, LCLType, LMessages,
{$ifdef windows}
  windows,
  Messages;
{$endif}
type
   tmyboard = class(tclipboard)
     public
     procedure luuk;
    end;
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
   // procedure WMChangeCBChain(var Msg: TlMessage); message LM_CHANGECBCHAIN;
    //  private   WM_MY_MESSAGE: UINT;

    //FNextClipboardOwner: HWnd;   {handle to the next viewer}
    {Here are the clipboard event handlers}
    //function WMChangeCBChain(wParam: WParam; lParam: LParam):LRESULT;
    //function WMDrawClipboard(wParam: WParam; lParam: LParam):LRESULT;
  public
    { public declarations }
  end;
  //procedure WMMove(var Message: TLMMove) ;message LM_MOVE;
//procedure WMDrawClipboard(var Msg:TlMessage); message LM_DRAWCLIPBOARD;
 //procedure WMChangeCBChain(var Msg: TMessage) ; message LM_CHANGECBCHAIN;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure tmyboard.luuk;
begin
   form1.memo1.text:=clipboard.astext;
   end;

procedure TForm1.Button1Click(Sender: TObject);
var mycl:tmyboard;
begin
  Clipboard.AsText:=('Send these words');
end;

procedure TForm1.Button2Click(Sender: TObject);
var mycl:tmyboard;
begin
  mycl:=clipboard as tmyboard;
  mycl.luuk;
   Memo1.text:=strtointdef(mycl.fdata.stream.size,-1);
end;

procedure wclips;
var mycl:tmyboard;i:integer;
begin
    //while true do
 for i:=1 to 1000 do
  begin
      application.processmessages;
      sleep(200);
      mycl:=clipboard as tmyboard;
   end;
end;

end.


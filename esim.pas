{--------------------------------------------------------------}
{                                                              }
{  SynHttpSrv.pas - HTTP server over Synapse                   }
{                                                              }
{  Author:     Semi                                            }
{  Started:    070528                                          }
{                                                              }
{--------------------------------------------------------------}
unit esim;
interface
uses {$ifdef WIN32} Windows, {$endif}
     SysUtils, Classes, synsock, blcksock, SynSrv;
//-------------------------------------------------------------

{$undef DEBUG}
{$define DEBUG}

//!!!TODO: SSL/https

//{$define CIL} //only for dotnet testing...

{$ifdef CIL} {$undef WIN32} {$endif}

type
  // Result: True=found/stop, False=continue
  THeaderEnum=function(const Value: string; LParam: Longint): Boolean of object;

  THeaderList=class(TStringList)
  protected
    { Internal methods: } function GetValueByName(const Name: string): string; procedure SetValueByName(const Name,Value: string); function GetNameByIndex(Index: integer): string; function GetValueByIndex(Index: integer): string; function CheckHttpFindValue(const Value: string; LParam: Longint): Boolean; function GetSubValue(const Name,SubName: string): string; procedure SetSubValue(const Name,SubName,Value: string);
  public
    { Internal methods: } function Add(const S: string): integer; override; procedure Insert(Index: integer; const S: string); override; procedure Put(Index: integer; const S: string); override;
  public
    property Values[const Name: string]: string read GetValueByName write SetValueByName; default;
    //
    property Strings;
    property Names[Index: integer]: string read GetNameByIndex;
    property ValuesByIndex[Index: integer]: string read GetValueByIndex;
    property SubValues[const Name,SubName: string]: string read GetSubValue write SetSubValue; // for 'ContentType: text/html; charset="Windows-1250"', SubValues['Content-Type','charset']
    //
    function IndexOfName(const Name: string): integer;
    procedure AddValue(const Name,Value: string); // add (possibly duplicate) value...
    function RemoveValue(const Name: string): Boolean; // used also by writing Values[Name]:='';
    //
    // Enumerates duplicated or comma-separated headers:
    procedure EnumHeaders(const Name: string; const Enum: THeaderEnum; LParam: Longint=0);
    function  HasValue(const Name,Value: string): Boolean; // Connection: upgrade, close
  end;

  THttpCookie=class(TCollectionItem)
  protected
    FName:         string;
    FValue:        string;
    FDomain:       string;
    FPath:         string;
    FExpires:      string;
    FVersion:      string;
    FMaxAge:       string;
    FComment:      string;
    FSecure:       Boolean;
  public
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
    //
    property Domain: string read FDomain write FDomain;
    property Path: string read FPath write FPath;
    property Version: string read FVersion write FVersion;
    property MaxAge: string read FMaxAge write FMaxAge;
    property Comment: string read FComment write FComment;
    property Secure: Boolean read FSecure write FSecure;
    property Expires: string read FExpires write FExpires; // obsolette...
    //
    procedure DeleteCookie; // set MaxAge:='0'; so that client will delete the cookie...
    //
    procedure Assign(Source: TPersistent); override;
    //
    function GetServerCookie: string; // Set-Cookie: format... (for sending server->client)
    function GetClientCookie: string; // Cookie:     format... (for sending client->server)
    function ParseValue(Line: string; Version: integer): Boolean; // parse either Cookie: or SetCookie: header part, 1 cookie at a time...
    function MatchPath(const aPath: string): Boolean; // is it cookie for this path?
  end;

  THttpCookies=class(TCollection)
  protected
    function GetCookieItem(Index: integer): THttpCookie;
    function AddCookieValue(const Value: string; LParam: Longint): Boolean;
  public
    constructor Create;
    //
    property Cookies[Index: integer]: THttpCookie read GetCookieItem; default;
    function IndexOf(const Name: string): integer;
    function Find(const Name: string): THttpCookie;
    //
    // Load cookies from client, used in server... (Cookie: headers)
    procedure LoadClientCookies(Headers: THeaderList);
    // Save cookies to client, used in server...
    procedure SaveServerCookies(Headers: THeaderList; const DefaultDomain,DefaultPath: string);
    //
    // Load cookies from server, used in client... (Set-Cookie: headers)
    procedure LoadServerCookies(Headers: THeaderList);
    // Save cookies to server, used in client...
    procedure SaveClientCookies(Headers: THeaderList; const Path: string);
    //
    // Other client-side functions:
    procedure MergeCookies(Source: THttpCookies);
  end;

  // HTTP request and response object
  THttpRequest=class(TPersistent)
  protected
    FHeaders:      THeaderList;
    FCookies:      THttpCookies;
    FParams:       TStringList;
    FUrl:          string;
    FMethod:       string;
    FProtocol:     string;
    FContent:      string;
    FContentStream:TStream;
    FStatusCode:   integer;
    FStatusMsg:    string;
    FConnection:   TObject;
    FFlags:        integer;
    procedure SetHeaders(Value: THeaderList);
    procedure SetCookies(Value: THttpCookies);
    procedure SetStatusCode(Value: integer);
    function  GetFlagBool(Index: integer): Boolean;
    procedure SetFlagBool(Index: integer; Value: Boolean);
    function  GetStrProp(Index: integer): string;
    procedure SetStrProp(Index: integer; const Value: string);
    function  GetDateProp(Index: integer): TDateTime;
    procedure SetDateProp(Index: integer; const Value: TDateTime);
    //
    procedure ApplyHeaders(bnIsServer: Boolean); virtual; // parse Cookies and possibly other things from Headers... used by TSynHttpServer.ReadRequest
    function  AddMultiPartFormItem(Headers: THeaderList; const FieldName,Content: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    //
    property Headers: THeaderList read FHeaders write SetHeaders;  // Set assigns copy...
    //
    property Cookies: THttpCookies read FCookies write SetCookies; // Set assigns copy...
    //
    property Url: string read FUrl write FUrl;                 // '/index.html'
    property Method: string read FMethod write FMethod;        // 'GET'
    property Protocol: string read FProtocol write FProtocol;  // 'HTTP/1.1'
    // also MUST include Headers['Host'] value...
    //
    property StatusCode: integer read FStatusCode write SetStatusCode; // 200
    property StatusMsg: string read FStatusMsg write FStatusMsg;       // 'OK'
    //
    property Content: string read FContent write FContent;
    property ContentStream: TStream read FContentStream write FContentStream; // stream is owned by the Request...
    property SendChunked: Boolean index 1 read GetFlagBool write SetFlagBool; // set to True to prevent asking Stream.Size and send in chunked mode (without Content-length)
    //
    property Connection: TObject read FConnection write FConnection; // TSynTcpSrvConnection usually...
    //
    // Params contain 'Name=Value' for parameters in ?params in url and for POST params inside content:
    // When posting files, Params does NOT contain file data, only FileName, use GetPostFormParam to retrieve file data...
    property Params: TStringList read FParams; // use  Request.Params.Values[ParamName]
    function GetPostFormParam(const ParamName: string; var ParamData: string): Boolean; // get 1 param from multipart/form-data or application/x-www-form-urlencoded...
    //
    // Common operations for application for making reply:
    procedure ServeFile(const LocalFileName: string); // open file in ContentStream, set Last-Modified, Content-Length, Content-Type
    procedure Redirect(const aUrl: string); // set 302 redirection and Location: header
    //
    // Common Header properties:
    property ContentType: string index 0 read GetStrProp write SetStrProp;  // 'text/html; charset="Windows-1250"'
    property BaseContentType: string index 1 read GetStrProp;               // 'text/html'
    property ContentDisposition: string index 2 read GetStrProp write SetStrProp; // 'attachment; filename=targetfile.html'
    property TargetFileName: string index 3 read GetStrProp write SetStrProp; // name, by which this should be saved by client (in Content-Disposition)
    property Location: string index 4 read GetStrProp write SetStrProp;       // Location: header
    property Etag: string index 5 read GetStrProp write SetStrProp;           // Etag is used for caches, so that they may know, that their copy is exactly identical with current data (having same Etag for same URL means it is exactly identical...)
    property Host: string index 6 read GetStrProp write SetStrProp;           // must be in Request
    property Referer: string index 7 read GetStrProp write SetStrProp;
    property UserAgent: string index 8 read GetStrProp write SetStrProp;
    property Vary: string index 9 read GetStrProp write SetStrProp;           // list of headers, for which the response varies... used by caches...
    property WwwAuthenticate: string index 10 read GetStrProp write SetStrProp; // authentication challenge, used with 401 status-code... see RFC2617...
    property Authorization: string index 11 read GetStrProp write SetStrProp; // Authorization: value, sent by client
    property Boundary: string index 12 read GetStrProp write SetStrProp; // Content-Type: multipart/any; boundary=0123456789
    //
    property Date: TDateTime index 0 read GetDateProp write SetDateProp;      // local date of serving the request (is converted to UTC)    (filled by Server)
    property LastModified: TDateTime index 1 read GetDateProp write SetDateProp; // local date of file modification (is converted to UTC)   (filled by ServeFile method)
    property LastModifiedUTC: TDateTime index 2 read GetDateProp write SetDateProp; // UTC date of file modification   (filled by ServeFile method)
    property Expires: TDateTime index 3 read GetDateProp write SetDateProp;   // UTC date of expiration (for caches, allows caching of otherwise-non-cacheable responses)
    //
    // Functions used by server/client:
    procedure ParseFirstRequestLine(Line: string);  // parse:  'GET /index.html HTTP/1.1'  // used by server
    procedure ParseFirstResponseLine(Line: string); // parse:  'HTTP/1.1 200 OK'           // used by client
    function  GetFirstResponseLine: string;         // format: 'HTTP/1.1 200 OK'           // used by server
    function  GetFirstRequestLine: string;          // format: 'GET /index.html HTTP/1.1'  // used by client
    procedure ParsePostFormData; // parse Content string into Params, used usually by Server (for POST requests with propper Content-Type)
    //
    function  MatchTag(Etags: string): Boolean; // Etags may have multiple tags, comma-separated... returns True, if some of them is identical with Etag...
  end;

  TSynOnHttpGet=procedure(Sender: TObject; var Request,Response: THttpRequest) of object;
  TSynOnHttpExpect=procedure(Sender: TObject; Request: THttpRequest; var bnContinue: Boolean) of object;

  // Virtual HTTP server.
  // This level does some RFC2616 stuff for you,
  // but it does NOT resolve URL->filename, which must be done in OnHttpGet method.
  TSynHttpServer=class(TSynTcpServer)
  protected
    FOnHttpGet:    TSynOnHttpGet;
    FOnExpect:     TSynOnHttpExpect;
    FCertFile:     string;
    FKeyFile:      string;
    FKeyPass:      string;
    FCaCertFile:   string;
    procedure HandleClientCommand(Connection: TSynTcpSrvConnection; Command: string);
      procedure ReadRequest(Connection: TSynTcpSrvConnection; var Request,Reply: THttpRequest; Command: string); virtual;
      procedure DoHttpGet(var Request,Reply: THttpRequest); virtual;
      procedure SendReply(Connection: TSynTcpSrvConnection; var Request,Reply: THttpRequest); virtual;
    procedure SetActive(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    //
    procedure InitHttps(const CertFile,KeyFile,KeyPassword,CaCertFile: string);
    //
  published
    property Port;//default '80';
    //
    property OnHttpGet: TSynOnHttpGet read FOnHttpGet write FOnHttpGet;
    property OnExpect: TSynOnHttpExpect read FOnExpect write FOnExpect;
  end;

  // TSynSslConnection used internally by HTTPS server
  TSynSslConnection=class(TSynTcpSrvConnection)
  protected
    function  OpenConnection(CliSock: TSocket; const CliAddr: TVarSin): Boolean; override;
  public
  end;

var
  // Value for Server: header...
  ServerValue: string='SynHttpSrv/1.0';

function ReadHeadersFromSocket(Socket: TTCPBlockSocket; Headers: THeaderList; LineTimeout: integer=0): Boolean;

const
  cProtoHttp10='HTTP/1.0';
  cProtoHttp11='HTTP/1.1';

function GetHttpStatusMsg(StatusCode: integer; var StatusMsg: string): Boolean;

//-----------------------------------------------------------------------------
// string utility functions:

// Trim(Copy(S,Pos,Count));
function TrimCopy(const S: string; Pos,Count: integer): string;
// trim inplace:
procedure DoTrim(var S: string);
// remove first token, no quoting:
function FetchToken(var Line: string; const Sep: string; bnTrim: Boolean): string;
// "Quote value, using \" and \\ inside..."
function QuoteValue(const Value: string): string;
// remove first comma-separated value, possibly quoted
function FetchQSepValue(var Line: string; const Sep: string): string;
// for parsing: remove first  Name="Value", separators either ";" or ","
function FetchDequoted(var Line: string; var Name,Value: string): Boolean;
// get value from Name="Value" in multi-prop header value:  (from 'text/html; charset="Windows-1250"' can extract charset...)
function GetHeaderSubValue(Header: string; const Name: string): string;
procedure ReplaceHeaderSubValue(var Header: string; const Name,Value: string);
function CombineStrings(Strings: TStrings; const Separator: string): string;
// SameHead == SameText(Copy(Str,1,Length(SHead)),SHead)
function SameHead(const Str,SHead: string): Boolean;
// multipart parsing...
type
  // Result: True=found/stop, False=continue
  TMultipartEnumCallback=function(Headers: THeaderList; const FieldName,Content: string): Boolean of object;
procedure EnumMultiPart(ContentData,Boundary: string; const Enum: TMultipartEnumCallback);

// Date - in HTTP (RFC2616), all dates MUST be in GMT (utc) format...
function FormatHttpDate(LocalDate: TDateTime; bnIsLocal: Boolean): string;
function ParseHttpDate(Str: string; var DateTime: TDateTime): Boolean;
function LocalToUtcDateTime(LocalDate: TDateTime): TDateTime;
function UtcToLocalDateTime(UtcDate: TDateTime): TDateTime;
function TimeZoneBiasTime: TDateTime;
function GetFileDateUtc(const FileName: string): TDateTime;

// Content-Type detection used by THttpRequest.ServeFile
function DetectContentType(const FileName: string; Stream: TStream): string;
function GetContentTypeByExt(const Ext: string): string;
// RegisterContentType can be used to register content-types by extension from user configuration:
procedure RegisterContentType(const Ext,ContentType: string);
{$ifdef WIN32}
// Automatically register content-types for all file extensions from registry...
procedure RegisterContentTypesFromRegistry;
{$endif WIN32}

// convert 'Documents%20and%20Settings'  to 'Documents and Settings', also handles utf8 encoded in %C4%8D...
procedure ConvertUrlChars(var Url: string);
procedure TryDecodeUtf8(var Url: string); // used by ConvertUrlChars...

var
  // location of /error.html file, used by THttpRequest.ServerFile:
  Error404Url: string;
  // contents of 404 error doc, used by THttpRequest.ServerFile, only if Error404Url is empty:
  Error404DocText: string;


procedure Register;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//-------------------------------------------------------------
implementation
uses {$ifdef DEBUG} UDebug, {$endif DEBUG}
     SynaUtil;
//-------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('Samples',[TSynHttpServer]);
end;

// read header lines until empty line is received...
function ReadHeadersFromSocket(Socket: TTCPBlockSocket; Headers: THeaderList; LineTimeout: integer): Boolean;
var Line: string;
begin
  if (LineTimeout=0) then
    LineTimeout:=SynSrv.cDefLineTimeout; // default 2 minutes...
  //
  while True do begin
    Line:=Socket.RecvString(LineTimeout);
    if (Line='') then begin
      if (Socket.LastError<>0) then begin
        // error (either timeout or client disconnected)
        Result:=False;
        exit;
      end;
      // Headers complete (terminated by empty line)
      {$ifdef DEBUG}
      Debug('Request headers:'#13#10'%s',[Headers.Text]);
      {$endif DEBUG}
      Result:=True;
      exit;
    end;
    Headers.Add(Line);
  end;
end;

function TrimCopy(const S: string; Pos,Count: integer): string;
var len,maxlen: integer;
begin
  //Result:=Trim(Copy(S,Pos,Count));
  // Optimized - trim before allocating result:
  len:=Length(S);
  while (Pos<=len) and (S[Pos]<=' ') do
    inc(Pos);
  if (Pos<=len) then begin
    maxlen:=len-Pos+1;
    if (Count>maxlen) then
      Count:=maxlen;
    while (Count>0) and (S[Pos+Count-1]<=' ') do
      dec(Count);
  end;
  Result:=Copy(S,Pos,Count);
end;

procedure DoTrim(var S: string);
var len: integer;
begin
  len:=Length(S);
  if (len>0)
  and ((S[1]<=' ') or (S[len]<=' '))
  then
    S:=Trim(S);
end;

function FetchToken(var Line: string; const Sep: string; bnTrim: Boolean): string;
var p: integer;
begin
  p:=Pos(Sep,Line);
  if (p>0) then begin
    // give part until separator:
    if bnTrim then begin
      Result:=TrimCopy(Line,1,p-1);
      Delete(Line,1,p+Length(Sep)-1);
      DoTrim(Line);
    end else begin
      Result:=Copy(Line,1,p-1);
      Delete(Line,1,p+Length(Sep)-1);
    end;
  end else begin
    // give all rest:
    Result:=Line;
    Line:='';
    if bnTrim then
      DoTrim(Result);
  end;
end;

procedure AdjustHeaderLine(var Line: string);
var p,len: integer;
    Name: string;
begin
  // Right-trim:
  len:=Length(Line);
  if (len=0) then
    exit;
  if (Line[1]<=' ') then begin
    Line:=Trim(Line);
  end else
  if (Line[len]<=' ') then begin
    Line:=TrimRight(Line);
  end;
  // Normalize arround ":"...
  p:=Pos(':',Line);
  if (p>1) then begin
    if (Line[p-1]<=' ')
    or not (Line[p+1]<=' ')
    or (Line[p+2]<=' ')
    then begin
      // Needs normalize...
      Name:=FetchToken(Line,':',True);
      //
      Line:=Name+': '+Line;
    end;
  end;
end;

// for parsing: remove first  Name="Value", separators either ";" or ","
// Value may be quoted, but does not need to be quoted
// Name may be missing (if no "=" is found, whole is Value)
function FetchDequoted(var Line: string; var Name,Value: string): Boolean;
var len,startname,lenname,startvalue,lenvalue,Skip,rest,p: integer;
    bnName,bnSlash: Boolean;
begin
  len:=Length(Line);
  // LTrim name:
  startname:=1;
  while (startname<=len) and (Line[startname]<=' ') do
    inc(startname);
  startvalue:=startname;
  //
  if (startname>len) then begin
    // Line was empty (or blank)...
    Line:='';
    Name:='';
    Value:='';
    Result:=False;
    exit;
  end;
  //
  // Seek end of name:
  bnName:=False;
  lenname:=0;
  lenvalue:=0;
  while (startname+lenname<=len) do begin
    case Line[startname+lenname] of
      ';',',','"': break;
      '=': begin
        // End of name:
        startvalue:=startname+lenname+1;
        bnName:=True;
        break;
      end;
    end;
    inc(lenname);
  end;
  if not bnName then begin
    // no name...
    //startvalue:=startname; // already...
    lenvalue:=lenname;
    lenname:=0;
  end;
  Name:=TrimCopy(Line,startname,lenname);
  //
  Skip:=0;
  bnSlash:=False;
  if (lenvalue=0) then begin
    // ltrim:
    while (startvalue<=len) and (Line[startvalue]<=' ') do
      inc(startvalue);
    lenvalue:=0;
    if (Line[startvalue]='"') then begin
      // quoted:
      inc(startvalue);
      lenvalue:=0;
      while (startvalue+lenvalue<=len) do begin
        case Line[startvalue+lenvalue] of
          '\': begin
            bnSlash:=True;
            inc(lenvalue);
          end;
          '"': begin
            // end-quote...
            Skip:=1;
            break;
          end;
        end;
        inc(lenvalue);
      end;
    end else begin
      // separated:
      while (startvalue+lenvalue<=len) do begin
        case Line[startvalue+lenvalue] of
          ';',',': begin
            break;
          end;
        end;
        inc(lenvalue);
      end;
    end;
  end;
  Value:=TrimCopy(Line,startvalue,lenvalue);
  //
  rest:=startvalue+lenvalue+Skip;
  while (rest<=len) and (Line[rest]<=' ') do
    inc(rest);
  if (rest<=len) and (Line[rest] in [';',',']) then
    inc(rest);
  Line:=TrimCopy(Line,rest,Length(Line)-rest+1);
  //
  if bnSlash then begin
    // Remove middle quoting markup:
    len:=Length(Value);
    p:=1;
    while (p<=len) do begin
      if (Value[p]='\') then begin
        Delete(Value,p,1);
        dec(len);
      end;
      inc(p);
    end;
  end;
  //
  Result:=True;
end;

function GetHeaderSubValue(Header: string; const Name: string): string;
var S: string;
begin
  Result:='';
  while (Header<>'') do begin
    FetchDequoted(Header,S,Result);
    if SameText(S,Name) then
      break;//exit;
    Result:='';
  end;
end;

procedure ReplaceHeaderSubValue(var Header: string; const Name,Value: string);
var Parts: TStringList;
    S,S2: string;
    ls2: integer;
begin
  // find existing Name="Value", value may be quoted and may be not quoted, Name= may occur inside other quoted value so may not use simple Pos()...
  Parts:=TStringList.Create;
  try
    S2:=Name+'=';
    ls2:=Length(S2);
    //
    while (Header<>'') do begin
      S:=Trim(FetchQSepValue(Header,';'));
      //
      if (S<>'')
      and (ls2>=Length(S))
      and (S[ls2]='=')
      and SameHead(S,S2) //and SameText(Copy(S,1,ls2),S2)
      then begin
        // Replace this:
        S:=S2+QuoteValue(Value);
        ls2:=0;
      end;
      //
      Parts.Add(S);
    end;
    //
    if (ls2>0) then begin
      // was not found...
      Parts.Add(S2+QuoteValue(Value));
    end;
    //
    // Combine into string:
    Header:=CombineStrings(Parts,'; ');
    //
  finally
    Parts.Free;
  end;
end;

{$ifndef CIL}
//
// Fast way for languages, that have PChar type...
function CombineStrings(Strings: TStrings; const Separator: string): string;
var i,Total,Len,lsep: integer;
    S: string;
    Put: PChar;
begin
  lsep:=Length(Separator);
  Total:=0;
  for i:=0 to Strings.Count-1 do begin
    S:=Strings[i];
    Len:=Length(S);
    inc(Total,Len);
    if (i>0) then
      inc(Total,lsep);
  end;
  SetString(Result,PChar(nil),Total); // SetString is faster than SetLength...
  if (Total>0) then begin
    Put:=Pointer(Result);
    for i:=0 to Strings.Count-1 do begin
      //
      if (i>0) and (Total>=lsep) then begin
        Move(Pointer(Separator)^,Put^,lsep);
        dec(Total,lsep);
        inc(Put,lsep);
      end;
      //
      S:=Strings[i];
      Len:=Length(S);
      if (Len>Total) then
        Len:=Total; // we will be safe even in case that source strings change in other thread...
      dec(Total,Len);
      inc(Put,Len);
      Move(Pointer(S)^,(Put-Len)^,Len);
    end;
  end;
end;
//
function SameHead(const Str,SHead: string): Boolean;
begin
  // Fast way for languages that have PChar type...
  Result:=StrLIComp(PChar(Str),PChar(SHead),Length(SHead))=0; // this way we need not allocate anything for the comparision...
  //Result:=SameText(Copy(Str,1,Length(SHead)),SHead);
end;
//
{$else ->CIL}
//
// Slow way for language without PChars...
function CombineStrings(Strings: TStrings; const Separator: string): string;
var S: string;
    i: integer;
begin
  Result:='';
  for i:=0 to Strings.Count-1 do begin
    S:=Strings[i];
    if (i>0) then
      Result:=Result+Separator+S
    else
      Result:=Result+S;
  end;
end;
//
function SameHead(const Str,SHead: string): Boolean;
begin
  Result:=SameText(Copy(Str,1,Length(SHead)),SHead);
end;
{$endif}

const
  // SysUtils.ShortDayNames may be translated with resources... here use constants:
  UsShortDayNames: array[1..7] of string=('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
  UsShortMonthNames: array[1..12] of string=('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

function FormatHttpDate(LocalDate: TDateTime; bnIsLocal: Boolean): string;
var UtcDate: TDateTime;
    d,m,y,h,n,s,z: Word;
begin
  if (LocalDate<=1) then begin
    Result:='';
    exit;
  end;
  // This format is recomended by RFC2616. it MUST be in GMT time-zone...
  // Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
  if bnIsLocal then
    UtcDate:=LocalToUtcDateTime(LocalDate)
  else
    UtcDate:=LocalDate;
  DecodeDate(UtcDate,y,m,d);
  DecodeTime(UtcDate,h,n,s,z);
  Result:=Format('%s, %.2d %s %.4d %.2d:%.2d:%.2d GMT',
    [UsShortDayNames[DayOfWeek(UtcDate)],
     d,UsShortMonthNames[m],y,
     h,n,s]);
end;

function LocalToUtcDateTime(LocalDate: TDateTime): TDateTime;
begin
  // UTC = local_time + bias
  if (LocalDate<>0) then
    Result:=LocalDate+TimeZoneBiasTime()
  else
    Result:=0;
end;

function UtcToLocalDateTime(UtcDate: TDateTime): TDateTime;
begin
  // local_time = UTC - bias
  if (UtcDate<>0) then
    Result:=UtcDate-TimeZoneBiasTime()
  else
    Result:=0;
end;

const
  cMinuteToDateTime=1/(24*60);

{$undef WIN32FILETIME}
{$undef WIN32TZ}
{$ifdef WIN32} {$ifndef CIL}

{$define WIN32TZ}
function TimeZoneBiasTime: TDateTime;
var tzi: TTimeZoneInformation;
    Bias: integer;
begin
  case GetTimeZoneInformation(tzi) of
    TIME_ZONE_ID_UNKNOWN: Bias:=tzi.Bias;
    TIME_ZONE_ID_STANDARD: Bias:=tzi.Bias+tzi.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Bias:=tzi.Bias+tzi.DaylightBias;
    else Bias:=0;
  end;
  if (Bias<>0) then
    Result:=Bias*cMinuteToDateTime
  else
    Result:=0;
end;

{$define WIN32FILETIME}
function FileTimeToUtcDateTime(const FileTime: TFileTime): TDateTime;
var Sys: TSystemTime;
begin
  if FileTimeToSystemTime(FileTime,Sys) then begin
    Result:=EncodeDate(Sys.wYear,Sys.wMonth,Sys.wDay)+EncodeTime(Sys.wHour,Sys.wMinute,Sys.wSecond,Sys.wMilliseconds);
  end else
    Result:=0;
end;
{$endif}{$endif}
//
{$ifndef WIN32TZ} // fallback for dotnet & linux:
const
  cMinuteToDateTime=1/(24*60);

function TimeZoneBiasTime: TDateTime;
begin
  Result:=SynaUtil.TimeZoneBias*cMinuteToDateTime;
end;
{$endif}

function GetFileDateUtc(const FileName: string): TDateTime;
var SR: TSearchRec;
begin
  // This could work on linux also?
  if (FindFirst(FileName,faAnyFile,SR)=0) then begin
    FindClose(SR);
    //
    {$ifdef WIN32FILETIME} // WIN32
    // Here we have directly UTC date-time:
    Result:=FileTimeToUtcDateTime(SR.FindData.ftLastWriteTime);
    {$else ->fallback}
    Result:=LocalToUtcDateTime(FileDateToDateTime(SR.Time));
    {$endif}
  end else
    Result:=0;
end;

function ParseShortMonthName(const Token: string): integer;
var i: integer;
begin
  for i:=1 to 12 do
    if SameText(Token,UsShortMonthNames[i]) then begin
      Result:=i;
      exit;
    end;
  Result:=0;
end;

function ParseHttpDate(Str: string; var DateTime: TDateTime): Boolean;
var Token: string;
    Int,y,m,d,h,n,s,tzh,tzm,tokencount: integer;
    TzOffset: Double;
begin
  DateTime:=0;
  // This format is recomended by RFC2616. it MUST be in GMT time-zone...
  // Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
  // These formats are also possible:
  // Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
  // Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
  // Anyhow due to robustness we will parse +0000 and -0000 timezones also...
  y:=0;
  m:=0;
  d:=0;
  h:=0;
  n:=0;
  s:=0;
  tokencount:=0;
  TzOffset:=0;
  while (Str<>'') do begin
    Token:=FetchToken(Str,' ',True);
    if (Token='') then
      continue;
    //
    inc(tokencount);
    if (tokencount>31) then
      break;
    //
    Int:=-1;
    if (Token[1] in ['0'..'9']) then
      Int:=StrToIntDef(Token,-1);
    //
    case Length(Token) of
      1,2: begin
        // Day...
        if (d=0) and (Int>0) then
          d:=Int;
      end;
      3: begin
        // Sun, GMT, Nov
        if (m=0) and (Int<0) then begin
          m:=ParseShortMonthName(Token);
        end;
      end;
      4: begin
        // 1999
        if (y=0) and (Int>=1900) and (Int<=2200) then
          y:=Int;
      end;
      5: begin
        if (Token[1] in ['-','+']) and (Token[2] in ['0'..'2']) then begin
          // +0200, -0200
          tzh:=StrToIntDef(Copy(Token,2,2),-1);
          tzm:=StrToIntDef(Copy(Token,4,2),-1);
          if (tzh>=0) and (tzm>=0) then begin
            TzOffset:=(tzh*(1/24))+(tzm*(1/(24*60)));
            if (Token[1]='+') then
              TzOffset:=-TzOffset;
          end;
        end;
      end;
      else begin
        if (Pos(':',Token)>0) then begin
          // Time...
          h:=StrToIntDef(FetchToken(Token,':',True),0);
          n:=StrToIntDef(FetchToken(Token,':',True),0);
          s:=StrToIntDef(FetchToken(Token,':',True),0);
        end else
        if (d=0) and (Pos('-',Token)>0) then begin
          // 06-Nov-94
          d:=StrToIntDef(FetchToken(Token,'-',True),0);
          m:=ParseShortMonthName(FetchToken(Token,'-',True));
          if (m<>0) then begin
            y:=StrToIntDef(Token,-1);
            if (y>=0) then begin
              if (y>50) then
                inc(y,1900)
              else
                inc(y,2000);
            end;
          end;
        end;
      end;
    end;
  end;
  //
  if (m>0) and (m<=12)
  and (y>=1900)
  and (d>0) and (d<=MonthDays[IsLeapYear(y),m])
  then begin
    // Valid date...
    DateTime:=EncodeDate(y,m,d);
    // Check time:
    if (h>=0) and (h<=23)
    and (n>=0) and (n<=59)
    and (s>=0) and (s<=59)
    then begin
      DateTime:=DateTime+EncodeTime(h,n,s,0)+TzOffset;
    end;
    Result:=True;
  end else
    Result:=False;
end;


{$ifdef WIN32} {$ifndef CIL} {$define LOCALUTF} {$endif}{$endif}

{$ifdef LOCALUTF}
//For compatibility with Delphi5, use our and kernel functions...

//U+00000000 - U+0000007F 	0xxxxxxx
//U+00000080 - U+000007FF 	110xxxxx 10xxxxxx
//U+00000800 - U+0000FFFF 	1110xxxx 10xxxxxx 10xxxxxx
//U+00010000 - U+001FFFFF 	11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
//U+00200000 - U+03FFFFFF 	111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
//U+04000000 - U+7FFFFFFF 	1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx

function GetUtfCharLen(pc: PChar): integer;
var b: Byte;
begin
  b:=ord(pc[0]);
  case b and $C0 of
    0,$40: begin
      Result:=1;
    end;
    $C0: begin
      // Start multi-byte:
      case b and $30 of
        $00,$10: begin
          // 2 bytes:
          if (ord(pc[1]) and $C0=$80) then
            Result:=2
          else
            Result:=0;
        end;
        $20: begin
          // 3 bytes:
          if (ord(pc[1]) and $C0=$80)
          and (ord(pc[2]) and $C0=$80)
          then
            Result:=3
          else
            Result:=0;
        end;
        else begin//$30: begin
          // Longer than UCS-2 (unicode >$FFFF) not supported...
          Result:=0;
        end;
      end;
    end;
    else //$40,$80
      Result:=0; // illegal
  end;
end;

function IsUtf8(pc: PChar): Boolean;
var bn80: Boolean;
    Len: integer;
begin
  bn80:=False;
  while (pc^<>#0) do begin
    if (Byte(pc^) and $80<>0) then begin
      bn80:=True;
      Len:=GetUtfCharLen(pc);
      if (Len>0) then
        inc(pc,Len)
      else begin
        // illegal bytes...
        Result:=False;
        exit;
      end;
    end else
      inc(pc);
  end;
  Result:=bn80;
end;

function FromUtf8ToWin(const S: string): string;
var WideBuf: PWideChar;
    Len,WideLen: integer;
begin
  Len:=Length(S);
  WideBuf:=AllocMem(Len*2+16);
  try
    WideLen:=MultiByteToWideChar(CP_UTF8,0,Pointer(S),Len,WideBuf,Len);
    if (WideLen=0) then begin
      Result:='';
      exit;
    end;
    SetString(Result,PChar(nil),WideLen);
    Len:=WideCharToMultiByte(0,0,WideBuf,WideLen,Pointer(Result),WideLen,'@',nil);
    if (Len<WideLen) then
      SetLength(Result,WideLen);
  finally
    FreeMem(WideBuf);
  end;
end;

procedure TryDecodeUtf8(var Url: string);
begin
  if IsUtf8(PChar(Url)) then begin
    Url:=FromUtf8ToWin(Url);
  end;
end;

{$else ->Delphi7+}

// For Delphi7+ can use function in pascal System unit...
procedure TryDecodeUtf8(var Url: string);
var S: string;
begin
  S:=Utf8Decode(Url); // returns empty, if not valid Utf8...
  if (S<>'') then
    Url:=S;
end;
{$endif}

function ValHex(const S: string; var Value: integer): Boolean;
var code: integer;
begin
  Val('$'+S,Value,Code);
  Result:=Code=0;
end;

procedure ConvertUrlChars(var Url: string);
var p,len,code: integer;
    bnUtf: Boolean;
begin
  // convert 'Documents%20and%20Settings'  to 'Documents and Settings'
  p:=Pos('%',Url);
  if (p=0) then
    exit;
  //
  bnUtf:=False;
  len:=Length(Url);
  while (p<=len) do begin
    if (Url[p]='%') then begin
      if ValHex(Copy(Url,p+1,2),code) then begin
        Delete(Url,p+1,2);
        dec(len,2);
        Url[p]:=chr(code);
        if (code>$80) then
          bnUtf:=True;
      end;
    end;
    inc(p);
  end;
  //
  if bnUtf then
    TryDecodeUtf8(Url);
end;

{ THeaderList }

function THeaderList.Add(const S: string): integer;
var Index: integer;
    Line: string;
begin
  // No empty lines:
  Line:=S;
  if (Line='') then begin
    Result:=-1;
    exit;
  end;
  // Check multi-line headers:
  if (Line[1]<=' ') then begin
    Index:=Count-1;
    if (Index>=0) then begin
      // Append to last line:
      Strings[Index]:=Strings[Index]+#13#10+Line; // line includes leading blank...
      Result:=Index;
      exit;
    end;
  end;
  // Common adjustment (trim and normalize arround ":")
  AdjustHeaderLine(Line);
  //
  Result:=inherited Add(Line);
end;

procedure THeaderList.Insert(Index: integer; const S: string);
var S2: string;
begin
  S2:=S;
  if (S2<>'') then begin
    // Common adjustment (trim and normalize arround ":")
    AdjustHeaderLine(S2);
    //
    inherited Insert(Index,S2);
  end;
end;

procedure THeaderList.Put(Index: integer; const S: string);
var S2: string;
begin
  S2:=S;
  if (S2<>'') then begin
    // Common adjustment (trim and normalize arround ":")
    AdjustHeaderLine(S2);
    //
    inherited Put(Index,S2);
  end;
end;

procedure THeaderList.AddValue(const Name,Value: string);
var S: string;
begin
  if (Name<>'') and (Value<>'') then begin
    S:=Name+': '+Value;
    AdjustHeaderLine(S);
    inherited Add(S);
  end;
end;

function THeaderList.IndexOfName(const Name: string): integer;
var i,len: integer;
    S: string;
begin
  Result:=-1;
  len:=Length(Name);
  if (len>0) then begin
    for i:=0 to Count-1 do begin
      S:=Strings[i];
      if (Length(S)>len)
      and (S[len+1]=':')
      and SameHead(S,Name) //and SameText(Copy(S,1,len),Name)
      then begin
        Result:=i;
        break;//exit;
      end;
    end;
  end;
end;

function IsName(const Line,Name: string): Boolean;
var len: integer;
begin
  len:=Length(Name);
  if (len>0)
  and (Length(Line)>len)
  and (Line[len+1]=':')
  and SameHead(Line,Name) //and SameText(Copy(Line,1,len),Name)
  then
    Result:=True
  else
    Result:=False;
end;

procedure LStrDel(var S: string; Index,Count: integer);
begin
  Delete(S,Index,Count);
end;

// returns pos after quote...
function StrSkipQuoted(const S: string; pquote: integer): integer;
var Q: Char;
    p,len: integer;
begin
  p:=pquote;
  Q:=S[p];
  inc(p);
  len:=Length(S);
  while (p<=len) do begin
    if (S[p]=Q) then begin
      // Found...
      inc(p);
      Result:=p;
      exit;
    end else
    if (S[p]='\') then
      inc(p,2)
    else
      inc(p);
  end;
  Result:=0;
end;

// seek next occurence after this pos:
function StrSeek(const S: string; C: Char; StartPos: integer): integer;
var p,len: integer;
begin
  len:=Length(S);
  p:=StartPos;
  if (p<=0) then
    p:=1;
  while (p<=len) do begin
    if (S[p]=C) then begin
      Result:=p;
      exit;
    end;
    inc(p);
  end;
  Result:=len+1;
end;

// remove first comma-separated value
function FetchQSepValue(var Line: string; const Sep: string): string;
var pcomma,pquote,p,len: integer;
begin
  // values are separated by "," but there may be another such in quotes...
  pcomma:=Pos(Sep,Line);
  if (pcomma=0) then begin
    // whole line is last part:
    Result:=Trim(Line);
    Line:='';
    exit;
  end;
  // skip quoted content:
  pquote:=Pos('"',Line);
  while (pquote>0) and (pquote<pcomma) do begin
    // May be quoted, may have multiple quoted parts...
    p:=StrSkipQuoted(Line,pquote);
    pquote:=StrSeek(Line,'"',p);
    pcomma:=StrSeek(Line,Sep[1],p);
    if (pcomma=0) then begin
      // whole line is last part:
      Result:=Trim(Line);
      Line:='';
      exit;
    end;
  end;
  // Extract part:
  Result:=TrimCopy(Line,1,pcomma-1);
  // Remove part, comma and spaces:
  len:=Length(Line);
  p:=pcomma;
  while (p<len) and ((Line[p+1]<=' ') or (Line[p+1]=Sep[1])) do
    inc(p);
  Delete(Line,1,p);
end;

// according to RFC2616, comma-separated headers may be also duplicated...
procedure THeaderList.EnumHeaders(const Name: string; const Enum: THeaderEnum; LParam: Longint=0);
var i,Index,Cnt: integer;
    Line,Value: string;
begin
  Index:=IndexOfName(Name);
  if (Index>=0) then begin
    i:=Index;
    Line:=Strings[i];
    while True do begin
      // Process this line:
      LStrDel(Line,1,Length(Name)+2); // remove 'Name: '
      Line:=Trim(Line);
      //
      while (Line<>'') do begin
        Value:=FetchQSepValue(Line,',');
        if (Value<>'') then begin
          if Enum(Value,LParam) then
            exit;
        end;
      end;
      // find next...
      inc(i);
      Cnt:=Count;
      while (i<Cnt) do begin
        Line:=Strings[i];
        if IsName(Line,Name) then
          break;
        inc(i);
      end;
      if (i>=Cnt) then
        break;
    end;
  end;
end;

{$ifndef CIL}
// Simple pascal:
type
  PHeaderFinder=^THeaderFinder;
  THeaderFinder=record
    FindValue:     PString;
    Found:         Boolean;
  end;
{$else ->dotnet is more complicated}
type
  THeaderFinder=class(TObject)
  public
    FindValue: string;
    Found: Boolean;
    function CheckHttpFindValue(const Value: string; LParam: Longint): Boolean;
  end;
  PHeaderFinder=THeaderFinder;

function THeaderFinder.CheckHttpFindValue(const Value: string; LParam: Longint): Boolean;
var S: string;
begin
  S:=Value;
  if SameText(FetchToken(S,'=',True),FindValue) then begin
    Found:=True;
    Result:=True; // stop.
  end else
    Result:=False; // continue...
end;
{$endif}

function THeaderList.CheckHttpFindValue(const Value: string; LParam: Longint): Boolean;
{$ifndef CIL}
var S: string;
    Finder: PHeaderFinder;
{$endif}
begin
  {$ifndef CIL}
  Finder:=PHeaderFinder(LParam);
  S:=Value;
  if SameText(FetchToken(S,'=',True),Finder.FindValue^) then begin
    Finder.Found:=True;
    Result:=True; // stop.
  end else
  {$endif}
    Result:=False; // continue...
end;

function THeaderList.HasValue(const Name,Value: string): Boolean;
var Finder: THeaderFinder;
begin
  {$ifndef CIL}
  // Simple:
  Finder.FindValue:=@Value;
  Finder.Found:=False;
  //
  EnumHeaders(Name,Self.CheckHttpFindValue,Longint(@Finder));
  Result:=Finder.Found;
  //
  {$else ->dotnet, little more complicated}
  //
  Finder:=THeaderFinder.Create;
  Finder.FindValue:=Value;
  Finder.Found:=False;
  EnumHeaders(Name,Finder.CheckHttpFindValue,0);
  Result:=Finder.Found;
  Finder.Free;
  {$endif}
end;

function THeaderList.GetValueByName(const Name: string): string;
var Index,p: integer;
begin
  Index:=IndexOfName(Name);
  if (Index>=0) then begin
    //Result:=GetValueByIndex(Index);
    Result:=Strings[Index];
    //System.Delete(Result,Length(Name)+2); // remove 'Name: '
    p:=Length(Name)+2;
    Result:=Copy(Result,p+1,Length(Result)-p);
  end else
    Result:='';
end;

procedure THeaderList.SetValueByName(const Name,Value: string);
var Index: integer;
    S: string;
begin
  if (Name<>'') then begin
    if (Value<>'') then begin
      Index:=IndexOfName(Name);
      S:=Trim(Name)+': '+Trim(Value);
      if (Index>=0) then
        inherited Put(Index,S) //Strings[Index]:=S
      else
        inherited Add(S);
    end else
      RemoveValue(Name);
  end;
end;

function THeaderList.RemoveValue(const Name: string): Boolean;
var Index,Count: integer;
begin
  Result:=False;
  Index:=IndexOfName(Name);
  if (Index>=0) then begin
    Delete(Index);
    Result:=True;
    //
    // Remove all occurences:
    Count:=Self.Count;
    while (Index<Count) do begin
      if IsName(Strings[Index],Name) then begin
        Delete(Index);
        dec(Count);
      end else
        inc(Index);
    end;
  end;
end;

function THeaderList.GetNameByIndex(Index: integer): string;
var p: integer;
begin
  Result:=Strings[Index];
  p:=Pos(':',Result);
  if (p>0) then begin
    Result:=Copy(Result,1,p-1);
  end else
    Result:='';
end;

function THeaderList.GetValueByIndex(Index: integer): string;
var p: integer;
begin
  Result:=Strings[Index];
  p:=Pos(':',Result);
  if (p>0) then begin
    inc(p); // remove space after colon also...
    Result:=TrimCopy(Result,p+1,Length(Result)-p);
  end;
end;

function THeaderList.GetSubValue(const Name,SubName: string): string;
begin
  Result:=Values[Name];
  if (Result<>'') then
    Result:=GetHeaderSubValue(Result,SubName);
end;

procedure THeaderList.SetSubValue(const Name,SubName,Value: string);
var S: string;
    Index: integer;
begin
  Index:=IndexOfName(Name);
  if (Index>=0) then begin
    S:=ValuesByIndex[Index];//Values[Name];
  end else
    S:='';
  //
  if (S<>'') then begin
    // Replace in existing header:
    ReplaceHeaderSubValue(S,SubName,Value);
  end else begin
    S:=Format('%s=%s',[SubName,QuoteValue(Value)]);
  end;
  //
  S:=Trim(Name)+': '+Trim(S);
  //
  if (Index>=0) then
    inherited Put(Index,S)
  else
    inherited Add(S);
end;

{ THttpRequest }

constructor THttpRequest.Create;
begin
  inherited Create;
  FHeaders:=THeaderList.Create;
  FParams:=TStringList.Create;
  FCookies:=THttpCookies.Create;
end;

destructor THttpRequest.Destroy;
begin
  FreeAndNil(FContentStream);
  FreeAndNil(FHeaders);
  FreeAndNil(FParams);
  FreeAndNil(FCookies);
  inherited;
end;

procedure THttpRequest.Assign(Source: TPersistent);
var Req: THttpRequest;
    Lines: TStrings;
    Temp2: TStringList;
    i,Count: integer;
    S: string;
begin
  if (Source is THttpRequest) then begin
    Req:=THttpRequest(Source);
    FHeaders.Assign(Req.FHeaders);
    FCookies.Assign(Req.FCookies);
    FUrl:=Req.FUrl;
    FMethod:=Req.FMethod;
    FProtocol:=Req.FProtocol;
    FContent:=Req.FContent;
    FContentStream:=Req.FContentStream;
    Req.FContentStream:=nil; // only 1 request may own the content stream...
    FStatusCode:=Req.FStatusCode;
    FStatusMsg:=Req.FStatusMsg;
    FConnection:=Req.FConnection;
    FFlags:=Req.FFlags;
  end else
  if (Source is TStrings) then begin
    Lines:=TStrings(Source);
    Temp2:=nil;
    try
      // Load headers:
      Headers.Clear;
      i:=0;
      Count:=Lines.Count;
      while (i<Count) do begin
        S:=Lines[i];
        if (S='') then begin
          // End of headers...
          inc(i);
          break;
        end;
        Headers.Add(S);
        inc(i);
      end;
      //
      if (i<Count) then begin
        // Load content:
        // It is usually much faster to copy strings to new list than to delete items from start...
        Temp2:=TStringList.Create;
        Temp2.Capacity:=Count-i;
        while (i<Count) do begin
          Temp2.Add(Lines[i]);
          inc(i);
        end;
        FreeAndNil(Temp2);
        FContent:=Temp2.Text;
      end;
    finally
      Temp2.Free;
    end;
  end else
    inherited;
end;

procedure THttpRequest.SetHeaders(Value: THeaderList);
begin
  if (Value<>nil) then
    FHeaders.Assign(Value)
  else
    FHeaders.Clear;
end;

procedure THttpRequest.SetCookies(Value: THttpCookies);
begin
  if (Value<>nil) then
    FCookies.Assign(Value)
  else
    FCookies.Clear;
end;

type
  THttpStatusMsg=record
    Code:          integer;
    Msg:           string;
  end;

const
  // status codes defined in RFC2616:
  HttpStatusMsgs: array[0..39] of THttpStatusMsg=(
    // Common codes:
    (Code: 200; Msg: 'OK'),
    (Code: 403; Msg: 'Forbidden'),
    (Code: 404; Msg: 'Not Found'),
    (Code: 401; Msg: 'Unauthorized'),
    (Code: 500; Msg: 'Internal Server Error'),
    (Code: 302; Msg: 'Found'), // use this for redirection
    (Code: 304; Msg: 'Not Modified'),
    (Code: 206; Msg: 'Partial Content'),
    //
    (Code: 100; Msg: 'Continue'),
    (Code: 101; Msg: 'Switching Protocols'),
    (Code: 201; Msg: 'Created'),
    (Code: 202; Msg: 'Accepted'),
    (Code: 203; Msg: 'Non-Authoritative Information'),
    (Code: 204; Msg: 'No Content'),
    (Code: 205; Msg: 'Reset Content'),
    (Code: 300; Msg: 'Multiple Choices'),  //also possible for redirection...
    (Code: 301; Msg: 'Moved Permanently'), //also possible for redirection...
    (Code: 303; Msg: 'See Other'),         //also possible for redirection...
    (Code: 305; Msg: 'Use Proxy'),         //also possible for redirection...
    (Code: 307; Msg: 'Temporary Redirect'),//also possible for redirection...
    (Code: 400; Msg: 'Bad Request'),
    (Code: 402; Msg: 'Payment Required'),
    (Code: 405; Msg: 'Method Not Allowed'),
    (Code: 406; Msg: 'Not Acceptable'),
    (Code: 407; Msg: 'Proxy Authentication Required'),
    (Code: 408; Msg: 'Request Timeout'),
    (Code: 409; Msg: 'Conflict'),
    (Code: 410; Msg: 'Gone'),
    (Code: 411; Msg: 'Length Required'),
    (Code: 412; Msg: 'Precondition Failed'),
    (Code: 413; Msg: 'Request Entity Too Large'),
    (Code: 414; Msg: 'Request-URI Too Long'),
    (Code: 415; Msg: 'Unsupported Media Type'),
    (Code: 416; Msg: 'Requested Range Not Satisfiable'),
    (Code: 417; Msg: 'Expectation Failed'),
    (Code: 501; Msg: 'Not Implemented'),
    (Code: 502; Msg: 'Bad Gateway'),
    (Code: 503; Msg: 'Service Unavailable'),
    (Code: 504; Msg: 'Gateway Timeout'),
    (Code: 505; Msg: 'HTTP Version Not Supported')
  );

procedure THttpRequest.SetStatusCode(Value: integer);
begin
  FStatusCode:=Value;
  GetHttpStatusMsg(FStatusCode,FStatusMsg);
end;

function GetHttpStatusMsg(StatusCode: integer; var StatusMsg: string): Boolean;
var i: integer;
begin
  for i:=Low(HttpStatusMsgs) to High(HttpStatusMsgs) do
    if (HttpStatusMsgs[i].Code=StatusCode) then begin
      StatusMsg:=HttpStatusMsgs[i].Msg;
      Result:=True;
      exit;
    end;
  Result:=False;
end;

function THttpRequest.GetFlagBool(Index: integer): Boolean;
var Mask: integer;
begin
  Mask:=1 shl Index;
  Result:=(FFlags and Mask<>0);
end;

procedure THttpRequest.SetFlagBool(Index: integer; Value: Boolean);
var Mask: integer;
begin
  Mask:=1 shl Index;
  if Value then
    FFlags:=FFlags or Mask
  else
    FFlags:=FFlags and not Mask;
end;

procedure THttpRequest.ApplyHeaders(bnIsServer: Boolean);
var S: string;
    p: integer;
begin
  if bnIsServer then
    Cookies.LoadClientCookies(Headers)
  else
    Cookies.LoadServerCookies(Headers);
  //
  // Parse parameters in URL:
  FParams.Clear;
  p:=Pos('?',Url);
  if (p>0) then begin
    S:=Copy(Url,p+1,Length(Url)-p);
    while (S<>'') do begin
      FParams.Add(Trim(FetchQSepValue(S,'&')));
    end;
  end;
end;

{Sample from RFC1867:

Content-type: multipart/form-data, boundary=AaB03x

--AaB03x
content-disposition: form-data; name="field1"

Joe Blow
--AaB03x
content-disposition: form-data; name="pics"; filename="file1.txt"
Content-Type: text/plain

 ... contents of file1.txt ...
--AaB03x--
{}

procedure THttpRequest.ParsePostFormData;
begin
  EnumMultiPart(Content,Boundary,AddMultiPartFormItem);
end;

function THttpRequest.AddMultiPartFormItem(Headers: THeaderList; const FieldName,Content: string): Boolean;
var S: string;
begin
  S:=Headers.SubValues['Content-Disposition','filename'];
  if (S<>'') then begin
    // will add FieldName=filename
  end else begin
    // will add FieldName=Content
    S:=Content;
  end;
  //
  if (FieldName<>'') then
    FParams.Add(FieldName+'='+S)
  else
    FParams.Add(S);
  //
  Result:=False; // all...
end;

type
  TGetPostParamInfo=class(TObject)
  public
    ParamName:     string;
    ParamData:     string;
    bnFound:       Boolean;
    function FindParamEnum(Headers: THeaderList; const FieldName,Content: string): Boolean;
  end;

function TGetPostParamInfo.FindParamEnum(Headers: THeaderList; const FieldName,Content: string): Boolean;
begin
  if SameText(FieldName,ParamName) then begin
    ParamData:=Content;
    bnFound:=True;
    Result:=True; // stop.
  end else
    Result:=False; // continue...
end;

function THttpRequest.GetPostFormParam(const ParamName: string; var ParamData: string): Boolean;
var Info: TGetPostParamInfo;
begin
  Info:=TGetPostParamInfo.Create;
  try
    Info.ParamName:=ParamName;
    Info.ParamData:=ParamData;
    EnumMultiPart(FContent,Boundary,Info.FindParamEnum);
    ParamData:=Info.ParamData;
    Result:=Info.bnFound;
  finally
    Info.Free;
  end;
end;

{$ifndef CIL}
// Fast PChar-based version:
procedure EnumMultiPart(ContentData,Boundary: string; const Enum: TMultipartEnumCallback);
var pc,pe,ple: PChar;
    Line: string;
    bnBound,bnHeaders: Boolean;
    Headers: THeaderList;
    lbound: integer;
begin
  if (ContentData='') then
    exit;
  if (Boundary='') then begin
    // auto-detect boundary:
    pc:=PChar(ContentData);
    while (pc^ in [#1..' ']) do
      inc(pc);
    if (pc[0]='-') and (pc[1]='-') then begin
      inc(pc,2);
      ple:=pc;
      while not (ple^ in [#0,#13,#10]) do
        inc(ple);
      SetString(Boundary,pc,ple-pc);
    end;
    //
    if (Boundary='') then
      exit;
  end;
  Headers:=THeaderList.Create;
  try
    pc:=PChar(ContentData);
    pe:=pc+Length(ContentData);
    bnHeaders:=False;
    Insert('--',Boundary,1);
    lbound:=Length(Boundary); // length including leading --
    //
    while (pc<pe) do begin
      // Extract line:
      ple:=pc;
      while (ple<pe) and not (ple^ in [#13,#10]) do
        inc(ple);
      SetString(Line,pc,ple-pc);
      pc:=ple;
      if (pc<pe) and (pc^=#13) then
        inc(pc);
      if (pc<pe) and (pc^=#10) then
        inc(pc);
      //
      // Check boundary:
      bnBound:=False;
      if (Line=Boundary) then begin
        bnBound:=True;
      end else
      if (Line=Boundary+'--') then begin
        break; // terminating boundary...
      end;
      //
      if bnBound then begin
        Headers.Clear;
        bnHeaders:=True;
        continue;
      end;
      //
      if bnHeaders then begin
        if (Line<>'') then begin
          Headers.Add(Line);
          continue;
        end;
        // Empty-line is end-of-headers...
        bnHeaders:=False;
        //
        // Extract part content:
        ple:=pc;
        while (ple<pe) do begin
          // check for #13#10'--Boundary'
          if (ple[0]=#13) and (ple[1]=#10)
          and (ple[2]='-') and (ple[3]='-')
          and (pe-ple>=lbound)
          and (ple[2+lbound] in [#13,'-'])
          and (ple[3+lbound] in [#10,'-'])
          then begin
            SetString(Line,ple+2,lbound);
            if (Line=Boundary) then begin
              // End of value here (before new-line)
              // Field contents:
              SetString(Line,pc,ple-pc);
              pc:=ple+2; // skip #13#10, will parse this --Boundary again in main "while"...
              //
              if Enum(Headers,Headers.SubValues['Content-Disposition','name'],Line) then
                exit;
              Line:='';
              //
              break;
            end;
          end;
          inc(ple);
        end;
      end;
    end;
  finally
    Headers.Free;
  end;
end;
{$else ->dotnet}
// dotnet version, is slower but does not use PChar...
procedure EnumMultiPart(ContentData,Boundary: string; const Enum: TMultipartEnumCallback);
  function FetchLine(var Rest: string): string;
  begin
    Result:=FetchToken(Rest,#13#10,False);
  end;
var Line: string;
    Headers: THeaderList;
    p,lbound: integer;
    bnTerm,bnPart: Boolean;
begin
  // cannot use TStringList, since it would damage binary parts (uploaded files)?!
  // could consume leading part of ContentData, but it can be very slow on large uploads... well, dotnet is slow anyway...
  //
  if (Boundary='') then begin
    // autodetect boundary:
    while (ContentData<>'') do begin
      Line:=FetchLine(ContentData);
      if (Line<>'')
      and (Line[1]='-')
      and (Line[2]='-')
      then begin
        //Delete(Line,1,2); Boundary:='--'+Line;
        Boundary:=Line; // contains leading '--'
        break;
      end;
    end;
  end else begin
    // Seek leading boundary:
    Insert('--',Boundary,1);
    while (ContentData<>'') do begin
      Line:=FetchLine(ContentData);
      if (Line='') then
        continue;
      if (Line=Boundary) then
        break;
      if (Line=Boundary+'--') then
        exit;
    end;
  end;
  lbound:=Length(Boundary);
  //
  Headers:=THeaderList.Create;
  try
    while (ContentData<>'') do begin
      // Parse part headers:
      Headers.Clear;
      while (ContentData<>'') do begin
        Line:=FetchLine(ContentData);
        if (Line='') then
          break;
        Headers.Add(Line);
      end;
      // Parse part body:
      bnTerm:=False;
      bnPart:=False;
      p:=1;
      while (p<Length(ContentData)) do begin
        if (ContentData[p]=#13)
        and (ContentData[p+1]=#10)
        and (ContentData[p+2]='-')
        and (ContentData[p+3]='-')
        and (ContentData[p+2+lbound] in [#13,'-'])
        and (ContentData[p+3+lbound] in [#10,'-'])
        then begin
          Line:=Copy(ContentData,p+2,lbound);
          if (Line=Boundary) then begin
            // End of part body here:
            Line:=Copy(ContentData,1,p-1);
            inc(p,2); // skip #13#10
            inc(p,lbound); // skip '--Boundary'
            bnTerm:=(ContentData[p]='-');
            inc(p,2); // skip either #13#10 or '--'
            Delete(ContentData,1,p);
            //
            if Enum(Headers,Headers.SubValues['Content-Disposition','name'],Line) then
              exit;
            Line:='';
            //
            bnPart:=True;
            break;
          end;
        end;
        inc(p);
      end;
      //
      if bnTerm then // final boundary reached...
        break;
      if not bnPart then // input was incomplete, no boundary after data was found...
        break;
    end;
  finally
    Headers.Free;
  end;
end;
{$endif}

const
  StrPropNames: array[0..12] of string=(
    'Content-Type',             // 0
    'Content-Type',             // 1
    'Content-Disposition',      // 2
    'Content-Disposition',      // 3
    'Location',                 // 4
    'Etag',                     // 5
    'Host',                     // 6
    'Referer',                  // 7
    'User-Agent',               // 8
    'Vary',                     // 9
    'WWW-Authenticate',         //10   //!!!TODO
    'Authorization',            //11
    'Content-Type'              //12
  );

function THttpRequest.GetStrProp(Index: integer): string;
var p: integer;
begin
  Result:='';
  if (Index>=0) and (Index<=High(StrPropNames)) then begin
    Result:=Headers[StrPropNames[Index]];
    //
    case Index of
      1: begin
        // BaseContentType... remove sub-type...
        p:=Pos(';',Result);
        if (p>0) then
          Result:=TrimCopy(Result,1,p-1);
      end;
      3: begin
        // TargetFileName, extract it:
        // Content-Disposition: attachment; filename="Filename"    also works without the "attachment"...
        Result:=GetHeaderSubValue(Result,'filename')
      end;
      12: begin
        // Boundary:
        Result:=GetHeaderSubValue(Result,'boundary');
      end;
    end;
  end;
end;

procedure THttpRequest.SetStrProp(Index: integer; const Value: string);
begin
  if (Index>=0) and (Index<=High(StrPropNames)) then begin
    case Index of
      3: begin
        // TargetFileName:
        // Content-Disposition: attachment; filename="Filename"    also works without the "attachment"...
        Headers.SubValues[StrPropNames[Index],'filename']:=Value;
        exit;
      end;
      12: begin
        // Boundary:
        if (Headers.Values[StrPropNames[Index]]='') then
          Headers.Values[StrPropNames[Index]]:='multipart/mixed';
        //
        Headers.SubValues[StrPropNames[Index],'boundary']:=Value;
        exit;
      end;
    end;
    //
    Headers[StrPropNames[Index]]:=Value;
  end;
end;

const
  DatePropNames: array[0..3] of string=(
    'Date',
    'Last-Modified',
    'Last-Modified',
    'Expires'
  );
  DatePropIsLocal: array[0..3] of Boolean=(
    True,
    True,
    False,
    False
  );

function THttpRequest.GetDateProp(Index: integer): TDateTime;
begin
  if (Index>=0) and (Index<=High(DatePropNames))
  and ParseHttpDate(Headers[DatePropNames[Index]],Result)
  then begin
    if DatePropIsLocal[Index] then
      Result:=UtcToLocalDateTime(Result);
    exit;
  end;
  //
  Result:=0;
end;

procedure THttpRequest.SetDateProp(Index: integer; const Value: TDateTime);
var bnIsLocal: Boolean;
begin
  if (Index>=0) and (Index<=High(DatePropNames)) then begin
    bnIsLocal:=DatePropIsLocal[Index];
    Headers[DatePropNames[Index]]:=FormatHttpDate(Value,bnIsLocal);
  end;
end;

procedure THttpRequest.ServeFile(const LocalFileName: string);
begin
  FreeAndNil(FContentStream);
  //
  if FileExists(LocalFileName) then begin
    //LastModified:=GetFileDateUtc(LocalFileName); // LastModified property is in LOCAL time, converting to UTC!
    Headers[DatePropNames[1]{'Last-Modified'}]:=FormatHttpDate(GetFileDateUtc(LocalFileName),False);
    //
    //FreeAndNil(FContentStream);
    ContentStream:=TFileStream.Create(LocalFileName,fmOpenRead or fmShareDenyWrite);
    //
    ContentType:=DetectContentType(LocalFileName,ContentStream);
    //
    StatusCode:=200; // OK
    //
  end else begin
    // File not found:
    StatusCode:=404; // Not Found
    // Give some message:
    if (Error404Url<>'') then begin
      Redirect(Error404Url);
    end else
    if (Error404DocText<>'') then begin
      Content:=Error404DocText;
      ContentType:='text/html';
    end else begin
      // Fallback:
      Content:='404 - not found.';
      ContentType:='text/plain';
    end;
  end;
end;

function DetectContentType(const FileName: string; Stream: TStream): string;
var Ext: string;
begin
  // By file extension:
  Ext:=ExtractFileExt(FileName);
  Result:=GetContentTypeByExt(Ext);
  if (Result<>'') then
    exit;
  //
  // Auto-detect by contents?
  // Not here...
  Result:='';
end;

var
  ContentTypes: TStringList;

procedure RegisterContentType(const Ext,ContentType: string);
var S,Prev: string;
    List: TStringList;
    Index: integer;
begin
  S:=Ext+'='+ContentType;
  if (S[1]='=') then
    exit;
  if (S[1]<>'.') then
    Insert('.',S,1);
  //
  List:=ContentTypes;
  if (List=nil) then begin
    List:=TStringList.Create;
    ContentTypes:=List;
  end;
  //
  List.Find(S,Index);
  if (Index<List.Count) then begin
    Prev:=List[Index];
    if SameText(FetchToken(Prev,'=',True),Ext) then begin
      List[Index]:=S;
      S:='';//exit;
    end;
  end;
  if (S<>'') then
    List.Insert(Index,S);
end;

procedure RegisterInternalContentTypes;
begin
  // register some basic content types...
  // other get registered from configuration or from registry:
  RegisterContentType('.htm','text/html');
  RegisterContentType(
    text/plain (.txt)
    text/html (.htm, .html)
    text/xml (.xml)
    text/css (.css)
    text/javascript (.js)
    text/rtf (.rtf)

    image/jpeg (.jpg, .jpeg)
    image/gif (.gif)
    image/png (.png)
    image/tiff (.tif, .tiff)

    audio/basic (.au, .snd)
    audio/aiff (.aif, .aiff)
    audio/wave (.wav)
    audio/midi (.mid, .midi)

    video/mpeg (.mpg, .mpeg)
    video/quicktime (.mov)
    video/msvideo (.avi)

    application/octet-stream (.exe)
    application/postscript (.ps)
    application/pdf (.pdf)
    application/zip (.zip)
    application/x-zip-compressed (.zip)
    application/msword (.doc) );
  RegisterContentType('.xml','text/xml');
  RegisterContentType('.txt','text/plain');
  RegisterContentType('.jpg','image/jpeg');
  RegisterContentType('.gif','image/gif');
  RegisterContentType('.png','image/png');
end;

function GetContentTypeByExt(const Ext: string): string;
var Index: integer;
    List: TStringList;
begin
  Result:='';
  List:=ContentTypes;
  if (List=nil) then begin
    RegisterInternalContentTypes;
    List:=ContentTypes;
  end;
  if (List<>nil) then begin
    List.Find(Ext+'=',Index);
    if (Index<List.Count) then begin
      Result:=List[Index];
      if not SameText(FetchToken(Result,'=',True),Ext) then
        Result:='';
    end;
  end;
end;

{$ifdef WIN32}
// Win32 specific...
//[HKEY_CLASSES_ROOT\.xsl]
//@="xslfile"
//"Content Type"="text/xml"

procedure RegisterContentTypesFromRegistry;
var Key,SubKey: HKEY;
    KeyIndex: integer;
    CbName,CbData: DWORD;
    KeyName,Value: string;
begin
  KeyIndex:=0;
  Key:=HKEY_CLASSES_ROOT;
  CbName:=128;//x080922: 16;
  SetLength(KeyName,CbName);
  while (RegEnumKeyEx(Key,KeyIndex,@KeyName[1],CbName,nil,nil,nil,nil)=0) do begin
    SetLength(KeyName,CbName);
    if (KeyName<>'')
    and (KeyName[1]='.')
    and (RegOpenKeyEx(Key,PChar(KeyName),0,KEY_READ,SubKey)=0)
    then begin
      CbData:=64;
      SetLength(Value,CbData+8);
      if (RegQueryValueEx(SubKey,'Content Type',nil,nil,@Value[1],@CbData)=0)
      and (Value<>'')
      then begin
        SetLength(Value,CbData);
        RegisterContentType(KeyName,Value);
      end;
      RegCloseKey(SubKey);
    end;
    //
    inc(KeyIndex);
    CbName:=128;//x080922: 16;
    SetLength(KeyName,CbName);
  end;
end;
{$endif WIN32}

procedure THttpRequest.Redirect(const aUrl: string);
begin
  StatusCode:=302; // there are other 30x codes, but some HTTP/1.0 browsers do not understand them and understand only 302...
  Self.Location:=aUrl;
end;

// parse:  'GET /index.html HTTP/1.1'  // used by server
procedure THttpRequest.ParseFirstRequestLine(Line: string);
var p: integer;
begin
  Self.Method:=FetchToken(Line,' ',True); // this trims Command...
  p:=Length(Line)-7;
  if (p>0)
  and SameText( Copy(Line,p,4) ,'HTTP')
  then begin
    Self.Protocol:=Copy(Line,p,8);
    Self.Url:=TrimCopy(Line,1,p-1);
  end else begin
    Self.Url:=FetchToken(Line,' ',True);
    Self.Protocol:=Line;
  end;
end;

// parse:  'HTTP/1.1 200 OK'           // used by client
procedure THttpRequest.ParseFirstResponseLine(Line: string);
begin
  FProtocol:=FetchToken(Line,' ',True);
  FStatusCode:=StrToIntDef(FetchToken(Line,' ',True),0);
  FStatusMsg:=Line;
end;

// format: 'HTTP/1.1 200 OK'           // used by server
function THttpRequest.GetFirstResponseLine: string;
begin
  if (FProtocol='') then
    FProtocol:='HTTP/1.0';
  if (FStatusCode=0) then
    StatusCode:=500; // Internal server error - did not set StatusCode...?
  //
  Result:=Format('%s %d %s',[FProtocol,StatusCode,StatusMsg]);
end;

// format: 'GET /index.html HTTP/1.1'  // used by client
function THttpRequest.GetFirstRequestLine: string;
begin
  if (FMethod='') then
    FMethod:='GET';
  if (FUrl='') then
    FUrl:='/';
  if (FProtocol='') then
    FProtocol:='HTTP/1.0';
  //
  Result:=Format('%s %s %s',[FMethod,FUrl,FProtocol]);
end;

function THttpRequest.MatchTag(Etags: string): Boolean;
var E: string;
begin
  Result:=False;
  // If-Match header may specify more tags, comma-separated...
  while (Etags<>'') do begin
    E:=FetchQSepValue(Etags,',');
    if (E='') then
      continue;
    if (E='*') then begin
      Result:=(Self.Etag<>'');
      break;//exit;
    end;
    if (E=Self.Etag) then begin
      Result:=True;
      break;//exit;
    end;
  end;
end;

{ THttpCookies }

constructor THttpCookies.Create;
begin
  inherited Create(THttpCookie);
end;

function THttpCookies.GetCookieItem(Index: integer): THttpCookie;
begin
  Result:=THttpCookie(inherited Items[Index]);
end;

function THttpCookies.IndexOf(const Name: string): integer;
var i: integer;
begin
  for i:=0 to Count-1 do begin
    if SameText(Cookies[i].Name,Name) then begin
      Result:=i;
      exit;
    end;
  end;
  Result:=-1;
end;

function THttpCookies.Find(const Name: string): THttpCookie;
var Index: integer;
begin
  Index:=IndexOf(Name);
  if (Index>=0) then begin
    Result:=Cookies[Index];
  end else
    Result:=nil;
end;

procedure THttpCookies.LoadClientCookies(Headers: THeaderList);
begin
  Clear;
  Headers.EnumHeaders('Cookie',AddCookieValue,1);
  //x: Headers.EnumHeaders('Cookie2',AddCookieValue,2);
end;

procedure THttpCookies.SaveServerCookies(Headers: THeaderList; const DefaultDomain,DefaultPath: string);
var i: integer;
    Cookie: THttpCookie;
begin
  Headers.RemoveValue('Set-Cookie');
  for i:=0 to Count-1 do begin
    Cookie:=Cookies[i];
    if (Cookie.Domain='') then
      Cookie.Domain:=DefaultDomain;
    if (Cookie.Path='') then
      Cookie.Path:=DefaultPath;
    Headers.AddValue('Set-Cookie',Cookie.GetServerCookie);
  end;
end;

procedure THttpCookies.LoadServerCookies(Headers: THeaderList);
begin
  Clear;
  Headers.EnumHeaders('Set-Cookie',AddCookieValue,1);
  Headers.EnumHeaders('Set-Cookie2',AddCookieValue,2);
end;

procedure THttpCookies.SaveClientCookies(Headers: THeaderList; const Path: string);
var i: integer;
    Cookie: THttpCookie;
begin
  Headers.RemoveValue('Cookie');
  for i:=0 to Count-1 do begin
    Cookie:=Cookies[i];
    if (Path='')
    or Cookie.MatchPath(Path)
    then
      Headers.AddValue('Cookie',Cookie.GetClientCookie);
  end;
end;

function THttpCookies.AddCookieValue(const Value: string; LParam: Longint): Boolean;
var Cookie: THttpCookie;
begin
  Cookie:=THttpCookie.Create(nil);
  if Cookie.ParseValue(Value,LParam) then
    Cookie.Collection:=Self
  else
    Cookie.Free;
  //
  Result:=False; // all...
end;

procedure THttpCookies.MergeCookies(Source: THttpCookies);
var i: integer;
    Src,Dst: THttpCookie;
begin
  for i:=0 to Source.Count-1 do begin
    Src:=Source[i];
    Dst:=Self.Find(Src.Name);
    if (Dst=nil) then
      Dst:=THttpCookie.Create(nil);
    Dst.Assign(Src);
    Dst.Collection:=Self;
  end;
end;

{ THttpCookie }

procedure THttpCookie.Assign(Source: TPersistent);
begin
  if (Source is THttpCookie) then begin
    FName:=THttpCookie(Source).FName;
    FValue:=THttpCookie(Source).FValue;
    FDomain:=THttpCookie(Source).FDomain;
    FPath:=THttpCookie(Source).FPath;
    FExpires:=THttpCookie(Source).FExpires;
    FSecure:=THttpCookie(Source).FSecure;
    FMaxAge:=THttpCookie(Source).FMaxAge;
  end else
    inherited;
end;

procedure THttpCookie.DeleteCookie;
begin
  // RFC2109:
  //Optional.  The Max-Age attribute defines the lifetime of the
  //cookie, in seconds.  The delta-seconds value is a decimal non-
  //negative integer.  After delta-seconds seconds elapse, the client
  //should discard the cookie.  A value of zero means the cookie
  //should be discarded immediately.
  FMaxAge:='0';
end;

function QuoteValue(const Value: string): string;
var p,len: integer;
begin
  Result:=Value;
  //
  len:=Length(Result);
  p:=1;
  while (p<=len) do begin
    case Result[p] of
      '"','\': begin
        Insert('\',Result,p);
        inc(p);
        inc(len);
      end;
    end;
    inc(p);
  end;
  //
  Result:='"'+Result+'"';
end;

function NeedsCookieValueQuoting(const S: string): Boolean;
var p: integer;
begin
  if (S='') then begin
    Result:=True;
    exit;
  end;
  //
  p:=Length(S);
  while (p>0) do begin
    case S[p] of
      '"','=',';',',',#1..' ': begin
        Result:=True;
        exit;
      end;
    end;
    dec(p);
  end;
  Result:=False;
end;

function AddCookieProp(const Cookie,Name,Value: string; bnQuoted: Boolean): string;
var Sep,QVal: string;
begin
  Result:=Cookie;
  if (Value<>'') then begin
    Sep:='';
    if (Result<>'') then
      Sep:='; ';
    //
    QVal:=Value;
    // values may be quoted, but do not need to be quoted...
    if bnQuoted and NeedsCookieValueQuoting(Value) then
      QVal:=QuoteValue(Value);
    //
    Result:=Result+Sep+Name+'='+QVal;
  end;
end;

function THttpCookie.GetServerCookie: string; // Set-Cookie: format... (for sending server->client)
begin
  Result:=
      AddCookieProp(
      AddCookieProp(
      AddCookieProp(
      //AddCookieProp(
      AddCookieProp(
      AddCookieProp(
      AddCookieProp('',
      FName,FValue,True),
      'Version',FVersion,True),
      'Path',FPath,True),
      //'Expires',FExpires,True), // this is not in RFC2109...? was used with netscape cookies...
      'Domain',FDomain,True),
      'Max-Age',FMaxAge,True),
      'Comment',FComment,True);
  //
  //Expires= is in this format:  Wdy, DD-Mon-YY HH:MM:SS GMT
  //in Netscape format, also must not use quotes or spaces elsewhere than in Expires...
  //
  if FSecure then
    AppendStr(Result,'; secure');
end;

function THttpCookie.GetClientCookie: string; // Cookie:     format... (for sending client->server)
begin
  if (Version<>'') then begin
    // RFC2109 format... should have Version='1'
    // Cookie: $Version="1"; Name="Value"; $Path="Path", $Domain="Domain"
    Result:=
      AddCookieProp(
      AddCookieProp(
      AddCookieProp(
      AddCookieProp('',
      '$Version',Version,True),
      FName,FValue,True),
      '$Path',FPath,True),
      '$Domain',FDomain,True);
  end else begin
    // Simple Netscape format, just Name=Value, no quoting
    Result:=AddCookieProp('',FName,FValue,False); //Result:=FName+'='+FValue;
  end;
end;

function THttpCookie.ParseValue(Line: string; Version: integer): Boolean;
var Value,Name: string;
    bnFirst,bnSpecial: Boolean;
begin
  bnFirst:=True;
  while (Line<>'') do begin
    Value:=FetchQSepValue(Line,';');
    if (Value<>'') then begin
      Name:=FetchToken(Value,'=',True);
      //
      if (Name<>'') and (Name[1]='$') then begin
        bnSpecial:=True;
        Delete(Name,1,1);
      end else
        bnSpecial:=False;
      //
      if bnFirst and not bnSpecial then begin
        FName:=Name;
        FValue:=Value;
        bnFirst:=False;
      end else begin
        // other values:
        if SameText(Name,'path') then // do not localize...
          FPath:=Value
        else
        if SameText(Name,'expires') then
          FExpires:=Value
        else
        if SameText(Name,'domain') then
          FDomain:=Value
        else
        if SameText(Name,'secure') then
          FSecure:=True
        else
        if SameText(Name,'version') then
          FVersion:=Value;
      end;
    end;
  end;
  Result:=not bnFirst;
end;

function THttpCookie.MatchPath(const aPath: string): Boolean;
var Len: integer;
begin
  Len:=Length(Self.Path);
  //
  if (Length(aPath)>=Len)
  and SameHead(aPath,Self.Path) //and SameText(Copy(aPath,1,Len),Self.Path)
  then
    Result:=True
  else
    Result:=False;
end;

{ TSynHttpServer }

constructor TSynHttpServer.Create(AOwner: TComponent);
begin
  inherited;
  Port:='80';
  //
  //FConnClass:=TSynTcpSrvConnection; // we are using generic connection class...
  //
  if not (csDesigning in ComponentState) then
    OnCommand:=HandleClientCommand;
end;

procedure TSynHttpServer.SetActive(Value: Boolean);
begin
  {$ifdef DEBUG}
  if (Value=Self.Active) then
    exit;
  if Value then
    Debug('%s http server on port %s',['Starting',Port])
  else
    Debug('%s http server on port %s',['Stoping',Port]);
  {$endif DEBUG}
  //
  inherited;
  //
  {$ifdef DEBUG}
  Debug('Done.');
  {$endif DEBUG}
end;

function GetStreamSize(Stream: TStream): Int64;
var Pos: Int64;
begin
  Pos:=Stream.Position;
  Result:=Stream.Size;
  //
  {$ifdef WIN32}
  // Workarround for Delphi 5, where stream does not return Int64...
  if (Stream is TFileStream) then begin
    LARGE_INTEGER(Pos).HighPart:=0;
    LARGE_INTEGER(Pos).LowPart:=SetFilePointer(TFileStream(Stream).Handle,0,@LARGE_INTEGER(Pos).HighPart,FILE_CURRENT);
    LARGE_INTEGER(Result).HighPart:=0;
    LARGE_INTEGER(Result).LowPart:=SetFilePointer(TFileStream(Stream).Handle,0,@LARGE_INTEGER(Result).HighPart,FILE_END);
    //
    SetFilePointer(TFileStream(Stream).Handle,LARGE_INTEGER(Pos).LowPart,@LARGE_INTEGER(Pos).HighPart,FILE_BEGIN);
  end;
  {$endif}
  //
  Result:=Result-Pos;
end;

procedure StreamSeek(Stream: TStream; Offset: Int64);
var This: Longint;
begin
  // Workarround for Delphi 5, where TStream cannot seek by Int64...
  while (Offset>0) do begin
    if (Offset<$20000000) then
      This:=Offset
    else
      This:=$20000000;
    dec(Offset,This);
    Stream.Seek(This,soFromCurrent);
  end;
end;

function ParseRangeRequest(S: string; var RangeStart,RangeLength: Int64; const ContentSize: Int64; bnSizeKnown: Boolean): Boolean;
var p: integer;
    S1,S2: string;
    RangeEnd: Int64;
begin
  Result:=False;
  // bytes=0-1000
  // bytes=1000-
  // bytes=-1000
  // bytes=0-1000,2000-3000   this form is not parsed here and is ignored... this way we can avoid sending multipart/byte-ranges response...
  //
  if SameHead(S,'bytes') //if SameText(Copy(S,1,5),'bytes')
  then begin
    Delete(S,1,5);
    DoTrim(S); // can have space: bytes = ...
    if (S<>'') and (S[1]='=') then begin
      Delete(S,1,1);
      DoTrim(S);
    end;
    //
    p:=Pos('-',S);
    if (p=0) then
      exit;
    //
    S1:=TrimCopy(S,1,p-1);
    S2:=TrimCopy(S,p+1,63);
    //
    RangeStart:=StrToInt64Def(S1,-1);
    RangeEnd:=StrToInt64Def(S2,-1);
    //
    if (S1='') then begin
      if (S2='')
      or not bnSizeKnown
      or (RangeEnd<0)
      then
        exit;
      // bytes=-tailsize
      RangeStart:=ContentSize-RangeEnd;
      RangeLength:=RangeEnd;
      Result:=True;
    end else
    if (S2='') then begin
      // bytes=startpos-
      if (RangeStart<0) or not bnSizeKnown then
        exit;
      RangeLength:=ContentSize-RangeStart;
      Result:=True;
    end else
    if (RangeStart>=0)
    and (RangeEnd>=0)
    then begin
      // bytes=startpos-endpos
      RangeLength:=RangeEnd-RangeStart+1;
      Result:=True;
    end;
  end;
end;

// this function is the body of http request handling:
procedure TSynHttpServer.HandleClientCommand(Connection: TSynTcpSrvConnection; Command: string);
var Request,Reply: THttpRequest;
begin
  // Command is first line of request:   GET /index.html HTTP/1.1
  Request:=THttpRequest.Create;
  Reply:=THttpRequest.Create;
  try
    ReadRequest(Connection,Request,Reply,Command);
    //-------------------------------------------------------------------------
    // Pass to application:
    DoHttpGet(Request,Reply);
    if (Reply=nil) then begin
      // There is a chance for application to send reply, free it and give us NIL instead, to prevent further processing...
      exit;
    end;
    //-------------------------------------------------------------------------
    SendReply(Connection,Request,Reply);
    //
  finally
    Reply.Free;
    Request.Free;
  end;
end;

procedure TSynHttpServer.ReadRequest(Connection: TSynTcpSrvConnection; var Request,Reply: THttpRequest; Command: string);
var Value: integer;
    bnContinue,bnHttp11: Boolean;
    S: string;
begin
  //
  // Connect objects:
  Request.FConnection:=Connection;
  Reply.FConnection:=Connection;
  //
  // Parse first line:
  {$ifdef DEBUG} Debug('Command:'#13#10'%s',[Command]); {$endif}
  Request.ParseFirstRequestLine(Command);
  //
  // Read rest of headers:
  if not ReadHeadersFromSocket(Connection.Socket,Request.Headers,LineTimeout) then begin
    Connection.Terminate;
    exit;
  end;
  Request.ApplyHeaders(True);
  //
  if (Request.Protocol>='HTTP/1.1')
  and SameHead(Request.Protocol,'HTTP') //and SameText(Copy(Request.Protocol,1,4),'HTTP')
  then begin
    bnHttp11:=True;
    Reply.Protocol:='HTTP/1.1'; // we are compliant...
    //
    S:=Request.Headers['Expect'];
    if (S<>'') then begin
      // RFC2616:
      //A server that does not understand or is unable to comply with any of
      //the expectation values in the Expect field of a request MUST respond
      //with appropriate error status. The server MUST respond with a 417
      //(Expectation Failed) status if any of the expectations cannot be met
      //or, if there are other problems with the request, some other 4xx
      //status.
      bnContinue:=SameText(S,'100-continue'); // we understand only this Expect value...
      if Assigned(FOnExpect) then
        FOnExpect(Self,Request,bnContinue);
      //
      if bnContinue then begin
        Reply.StatusCode:=100; // 100 continue
        Connection.Socket.SendString(Reply.GetFirstResponseLine+#13#10#13#10);
      end else begin
        // RFC2616:
        //If it responds with a final status
        //code, it MAY close the transport connection
        Reply.StatusCode:=417; // Expectation failed
        Connection.Socket.SendString(Reply.GetFirstResponseLine+#13#10#13#10);
        Connection.Terminate;
        exit;
      end;
    end;
  end else
  if (Request.Protocol='HTTP/1.0') then begin
    Reply.Protocol:='HTTP/1.0';
    bnHttp11:=False;
  end else begin
    // Do not serve just any non-sense, written to our port...
    // Chance for getting HTTP/0.9 request is very small,
    // but chance for getting for ex. SMTP communication into the server port is much better...
    Connection.Terminate;
    exit;
  end;
  //
  // Read body:
  Value:=StrToIntDef(Request.Headers['Content-Length'],0);
  if (Value>0) then begin
    // Read content:
    Request.ContentStream:=TMemoryStream.Create;
    Connection.Socket.RecvStreamSize(Request.ContentStream,LineTimeout,Value);
    if (Connection.Socket.LastError<>0) then begin
      Connection.Terminate;
      exit;
    end;
    //
    // put request to string, share same memory with ContentStream...
    {$ifndef CIL}
    SetString(Request.FContent,PChar(TMemoryStream(Request.ContentStream).Memory),Request.ContentStream.Size);
    FreeAndNil(Request.FContentStream);
    Request.FContentStream:=TStringStream.Create(Request.Content);
    {$else ->CIL}
    //??? how to load string from stream in dotnet?
    //!!!TODO
    {$endif !CIL}
  end;
  //
  // Set some defaults:
  Reply.StatusCode:=404; // default to Not-found...
  if bnHttp11 then begin
    // HTTP/1.1 clients should default to keep-alive (rfc2616):
    if not Request.Headers.HasValue('Connection','close') then
      Reply.Headers['Connection']:='keep-alive'
    else
      Reply.Headers['Connection']:='close';
  end else begin
    // HTTP/1.0 clients should default to close (rfc2616):
    if Request.Headers.HasValue('Connection','keep-alive') then
      Reply.Headers['Connection']:='keep-alive'
    else
      Reply.Headers['Connection']:='close';
  end;
  //
  // Cookies:
  //??? Reply.Cookies.Assign(Request.Cookies);
  //
  // POST parameters:
  if SameText(Request.Method,'POST') then begin
    S:=Request.ContentType;
    if SameText(S,'application/x-www-form-urlencoded')
    or SameText(S,'multipart/form-data')
    then begin
      Request.ParsePostFormData;
    end;
  end;
  //
  Reply.Headers['Server']:=ServerValue;
end;

procedure TSynHttpServer.DoHttpGet(var Request,Reply: THttpRequest);
begin
  if Assigned(FOnHttpGet) then begin
    FOnHttpGet(Self,Request,Reply);
  end;
end;

function IsWithin(Value,Min,Max: integer): Boolean;
begin
  Result:=(Value>=Min) and (Value<=Max);
end;

function ExtractUrlPath(const Url: string): string;
var p: integer;
    bnFound: Boolean;
begin
  Result:=Url;
  p:=Pos('://',Result);
  if (p>0) then begin
    Delete(Result,1,p+2); // remove http://
    p:=Pos('/',Result);
    if (p>0) then
      Delete(Result,1,p); // remove hostname
  end;
  //
  p:=Pos('?',Result);
  if (p=0) then
    p:=Length(Result)+1;
  bnFound:=False;
  while (p>1) do begin
    dec(p);
    if (Result[p]='/') then begin
      SetLength(Result,p-1);
      bnFound:=True;
      break;
    end;
  end;
  //
  if not bnFound
  or (Result='')
  then
    Result:='/';
end;

procedure TSynHttpServer.SendReply(Connection: TSynTcpSrvConnection; var Request,Reply: THttpRequest);
var bnBody,bnSize: Boolean;
    S: string;
    Size,RangeStart,RangeLength: Int64;
    Date,Date2: TDateTime;
begin
  // Adjust Reply:
  //
  // Cookies:
  Reply.Cookies.SaveServerCookies(Reply.Headers,Request.Host,ExtractUrlPath(Request.Url));
  //
  // Fill other values:
  if (Reply.Headers['Date']='') then
    Reply.Headers['Date']:=FormatHttpDate(Now,True);
  //
  // Content-Length and Transfer-Encoding:
  if Reply.SendChunked then begin
    Reply.Headers['Content-Length']:='';
    Reply.Headers['Transfer-Encoding']:='chunked';
    Size:=-1;
    bnSize:=False;
  end else begin
    S:=Reply.Headers['Content-Length'];
    if (S='') then begin
      // Fill Content-Length:
      if (Reply.ContentStream<>nil) then begin
        //Size:=Reply.ContentStream.Size;
        Size:=GetStreamSize(Reply.ContentStream);
        bnSize:=True;
      end else
      if (Reply.Content<>'') then begin
        Size:=Length(Reply.Content);
        bnSize:=True;
      end else begin
        Size:=0;
        bnSize:=False;
      end;
      //
      Reply.Headers['Content-Length']:=IntToStr(Size);
      //
    end else begin
      // Content-Length was filled by application:
      Size:=StrToInt64Def(S,-1);
      bnSize:=(Size>=0);
    end;
  end;
  //
  //? if (Reply.StatusCode=404) then Reply.Headers['Connection']:='close';
  //
  if IsWithin(Reply.StatusCode,200,299) then begin
    //
    // Check If-Modified-Since:
    S:=Request.Headers['If-Modified-Since'];
    if (S<>'')
    and ParseHttpDate(S,Date)
    then begin
      {$ifdef DEBUG}
      Debug('If-Modified-Since: %s',[S]);
      Debug('Last-Modified: %s',[Reply.Headers['Last-Modified']]);
      {$endif DEBUG}
      //
      Date2:=Reply.LastModifiedUtc;
      if (Date2<>0)
      and (Date2>Date)
      then begin
        // is modified...
        {$ifdef DEBUG}
        Debug('Is modified: Date=%g, Date2=%g',[Date,Date2]);
        {$endif DEBUG}
      end else begin
        // Is not modified...
        Reply.StatusCode:=304; // Not Modified
        //!!!TODO/bug
        // mozilla hangs in transfer, when it gets the 304 responses??
        if (Copy(Request.Headers['User-Agent'],1,7)='Mozilla') then
          Reply.Headers['Connection']:='close';
      end;
    end else begin
      {$ifdef DEBUG}
      if (S<>'') then
        Debug('Failed parse date "%s"',[S]);
      {$endif DEBUG}
      //
      S:=Request.Headers['If-Unmodified-Since'];
      if (S<>'')
      and ParseHttpDate(S,Date)
      then begin
        Date2:=Reply.LastModifiedUtc;
        if (Date2<>0)
        and (Date2>Date)
        then begin
          // is modified
          Reply.StatusCode:=412; // Precondition Failed
        end;
      end;
    end;
  end;
  //
  if IsWithin(Reply.StatusCode,200,299) then begin
    //
    // Check If-Range - if the condition fails, we will ignore Range: header...
    S:=Request.Headers['If-Range'];
    if (S<>'') then begin
      // If-Range = "If-Range" ":" ( entity-tag | HTTP-date )
      if (S[1] in ['w','W']) and (S[2]='/') // W/"tag"
      or (S[1]='"')                // "tag"
      then begin
        if not Request.Headers.HasValue('Etag',S) then
          Request.Headers['Range']:=''; // does not have this Etag...
      end else begin
        // Http-date:  like If-Unmodified-Since...
        if ParseHttpDate(S,Date) then begin
          Date2:=Reply.LastModifiedUtc;
          if (Date2=0)
          or (Date2<=Date)
          then begin
            // is not modified since...
          end else begin
            // was modified since...
            Request.Headers['Range']:=''; // will send whole...
          end;
        end else
          Request.Headers['Range']:=''; // we do not understand If-Range header, so we will send whole body...
      end;
    end;
    //
    // Check Range: header
    RangeStart:=0;
    RangeLength:=0;
    S:=Request.Headers['Range'];
    if (S<>'')
    and ParseRangeRequest(S,RangeStart,RangeLength,Size,bnSize)
    then begin
      //
      if (bnSize and (RangeStart>=Size))
      or (RangeLength<=0)
      then begin
        Reply.StatusCode:=416; // Requested Range Not Satisfiable
        Reply.Headers['Content-Length']:='';
        if bnSize then
          Reply.Headers['Content-Range']:=Format('*/%d',[Size]); // we SHOULD send this with 416 code...
        Size:=0; // do not send body... //we will not send body, filtered also below...
      end else begin
        // Valid range:
        if bnSize then
          S:=IntToStr(Size)
        else
          S:='*';
        Reply.StatusCode:=206; // Partial Content
        Reply.Headers['Content-Range']:=
            Format('bytes %d-%d/%s',
               [RangeStart,RangeStart+RangeLength-1,S]);
        if bnSize then
          Reply.Headers['Content-Length']:=IntToStr(RangeLength);
        //
        if (RangeStart<>0) then begin
          if (Reply.ContentStream<>nil) then
            StreamSeek(Reply.ContentStream,RangeStart)
          else
          if (Reply.Content<>'') then
            Delete(Reply.FContent,1,RangeStart);
        end;
        //
        if (RangeLength<>0) then begin
          Size:=RangeLength;
          if (Reply.ContentStream=nil)
          and (Reply.Content<>'')
          and (Size<Length(Reply.Content))
          then
            SetLength(Reply.FContent,Size);
        end;
      end;
    end;
  end;
  //
  if IsWithin(Reply.StatusCode,200,299) then begin
    // Check Etag headers (If-Match, If-None-Match)
    S:=Request.Headers['If-Match'];
    if (S<>'') then begin
      // reply may have more tags, comma-separated, some week...
      // also If-Match may specify more tags...
      if not Reply.MatchTag(S) then begin
        Reply.StatusCode:=412; // Precondition Failed
      end;
    end;
    S:=Request.Headers['If-None-Match'];
    if (S<>'') then begin
      if Reply.MatchTag(S) then begin
        Reply.StatusCode:=412; // Precondition Failed
      end;
    end;
  end;
  //
  //-------------------------------------------------------------------------
  // Write reply to client:
  S:=Reply.GetFirstResponseLine+#13#10+Reply.Headers.Text+#13#10; // include 1 empty line after headers...
  {$ifdef DEBUG}Debug('Response headers:'#13#10'%s',[S]);{$endif}
  Connection.Socket.SendString(S);
  if (Connection.Socket.LastError<>0) then begin
    Connection.Terminate;
    exit;
  end;
  //
  bnBody:=True;
  if SameText(Request.Method,'HEAD') then
    bnBody:=False // MUST NOT send entity body with HEAD, but should send Content-Length...
  else
    case Request.StatusCode of
      412, // this is not in RFC, but we will not send entity body with 412 precondition failed anyway...
      416, // this is not in RFC, but we will not send entity body with 416 code (Requested Range Not Satisfiable) anyway...
      100..199,204,304: bnBody:=False; // we MUST NOT send entity body with these status-codes...
    end;
  //
  if bnBody then begin
    // Send body:
    if (Reply.ContentStream<>nil) then begin
      //x: we cannot use this, since it uses Stream.Size: Connection.Socket.SendStreamRaw(Reply.ContentStream);
      SendSocketStream(Connection.Socket,Reply.ContentStream,Size,Reply.SendChunked);
    end else
    if (Reply.Content<>'') then begin
      if not Reply.SendChunked then begin
        Connection.Socket.SendString(Reply.Content);
      end else begin
        // Send 1 chunk:
        Connection.Socket.SendString(Format('%x'#13#10,[Length(Reply.Content)]));
        if (Connection.Socket.LastError=0) then
          Connection.Socket.SendString(Reply.Content);
        if (Connection.Socket.LastError=0) then
          Connection.Socket.SendString('0'#13#10#13#10);
      end;
    end;
    //
    if (Connection.Socket.LastError<>0) then begin
      Connection.Terminate;
      exit;
    end;
  end;
  //
  if Reply.Headers.HasValue('Connection','close') then
    Connection.Terminate;
end;

procedure TSynHttpServer.InitHttps(const CertFile,KeyFile,KeyPassword,CaCertFile: string);
begin
  {Toto asi neni potreba na server-socketu, az na connection?
  FSrvSocket.SSLCertificateFile:=CertFile;
  //
  if (KeyFile<>'') then
    FSrvSocket.SSLPrivateKeyFile:=KeyFile;
  //
  if (KeyPassword<>'') then
    FSrvSocket.SSLPassword:=KeyPassword;
  {}
  FCertFile:=CertFile;
  FKeyFile:=KeyFile;
  FKeyPass:=KeyPassword;
  FCaCertFile:=CaCertFile;
  //
  if (Self.Port='80') then
    Self.Port:='443';
  //
  FConnClass:=TSynSslConnection;
end;

{ TSynSslConnection }

function TSynSslConnection.OpenConnection(CliSock: TSocket; const CliAddr: TVarSin): Boolean;
begin
  Result:=inherited OpenConnection(CliSock,CliAddr);
  //
  if Result then begin
    //
    if (FServer<>nil)
    and (FServer is TSynHttpServer)
    and (TSynHttpServer(FServer).FCertFile<>'')
    then begin
      // old Synapse library:
      {FSocket.SSLCertificateFile:=TSynHttpServer(FServer).FCertFile;
      FSocket.SSLPrivateKeyFile:=TSynHttpServer(FServer).FKeyFile;
      FSocket.SSLPassword:=TSynHttpServer(FServer).FKeyPass;
      FSocket.SSLCertCAFile:=TSynHttpServer(FServer).FCaCertFile;
      {}
      // newer Synapse library (from release 36?):
      FSocket.SSL.CertificateFile:=TSynHttpServer(FServer).FCertFile;
      FSocket.SSL.PrivateKeyFile:=TSynHttpServer(FServer).FKeyFile;
      FSocket.SSL.KeyPassword:=TSynHttpServer(FServer).FKeyPass;
      FSocket.SSL.CertCAFile:=TSynHttpServer(FServer).FCaCertFile;
      {}
    end;
    //
    FSocket.SSLAcceptConnection;
    if (FSocket.LastError<>0) then begin
      Result:=False;
      exit;
    end;
  end;
end;

initialization
finalization
  FreeAndNil(ContentTypes);
end.

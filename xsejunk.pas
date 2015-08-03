unit XSEJUNK;
//DELETED STTUFF THAT I MAY NEED LATER
{$mode delphi}

interface

uses
  Classes, SysUtils;

implementation

   function txseus.c_todb:boolean;
var qq:tsqlquery;//vals:array [1..3] of const;
dbexists:boolean;dbn:string;i,dbi:integer;db:tdb;
  //pas:tparams;
begin
  db:=getdb_sql(curbyele.vali,x_databases);
  writeln('should have a db now');
  if curbyele.att('temp')<>'true' then //open a transaction
  with db do
  begin
   writeln('<li>start prepare');
   q:=tsqlquery.create(nil);
    writeln('<li>query cre');
    q.database:=c;
    writeln('<li>q con');
    T:=TSQLTransaction.create(c);
    writeln('<li>t cre');
    T.Database:=C;
    c.transaction:=t;
    q.transaction:=t;
    writeln('<li>t con');
   //   q.ParseSQL:=true;
    // q.UpdateMode:=upWhereAll;
   // Q.SQL.Text := 'insert into pages(url,date,name) values (:url,:date,:name)';
    Q.SQL.Text := 'insert into pages(url,date,name) values (:?,:?,:?)';
    //t.active:=true;
    try
    Q.Prepare;
    except on e:exception do writeln('NOGO:'+e.message);end;
    writeln('<li>q prep:',q.fieldcount);
    try
      c.ExecuteDirect('end transaction');
      c.ExecuteDirect('begin transaction');
      //q.active:=false;
      //q.active:=true;
      Q.appendrecord(['a','b','c']);
      //Q.append;
      //q.SetFields(['a','b','c']);
//q.Params.ParamByName('url').AsString := ('a');
//q.Params.ParamByName('date').AsString := ('b');
//q.Params.ParamByName('name').AsString := ('c');
//q.Params.ParamByName('nogo').AsString := ('c');
                //db.q.execSQL;
     except on e:exception do writeln('failappend:'+e.message);end;
     writeln('<li>q abc:');
    // sql_list(dbn);

  end else
  begin  //create temp table and open transaction there .. perhaps not, this is for writing, better keep db locked?


  end;
x_streaming:=true;
writeln('<li>start streaming to database');
end;

{ SQL
sql_connect create database connection object and add it to x_databases
//createtable to database can be done via exec_one
exec_one make a single query
prepapre prepare a query, start transaction and be ready for multiple next's
prepare temp=true  //create a temporary table for "prepare"
next

}





{   Q:=TSQLQuery.Create(C);
 //writeln('// Qcreat.');
  Q.Database:=C;
  Q.Transaction:=T;
  q.ParseSQL:=false;
  writeln('<li>turning of parsesql required otherwise syntax error. ');
  try
  q.sql.text:='SELECT * from res.uus';
  q.open;
  except on e:exception do writeln('<li>ERROR3',e.message+'!'+q.SQL.text+'!');end;
  writeln('<li>','queried  result.set');
  pos:=0;
  While not Q.EOF do
  begin
    pos:=pos+1;
    if pos>100 then break;
    writeln('<li>',inttostr(q.fields.count),'</li>');
    for i:=0 to q.fields.count-1 do
       writeln('--',pos,' ',q.fields[i].FieldName,q.fields[i].asstring);
     sleep(50);
     //just to keep connection busy for testing a simultan3eus connection from otheer thread
     Q.Next;
  end;

  //t.commit;
  //c.ExecuteDirect('end transaction');
  //c.Close;
  //had to comment all these out. Dont know why.
end;
}

//function tdb.sql_query(cp,tp:pointer;qs:string):pointer;
function tdb.sql_query(qs:string):pointer;
//make single query
var  //C:TSQLite3Connection;
 T:TSQLTransaction;
 Q:TSQLQuery;
var i:integer;busy:boolean;msg:string;
begin
  try
  if c=nil then
    begin
      //C:=TSQLite3Connection.create(nil);
      writeln('<li>','No connection');
      //C.DatabaseName:=sq';

    end;
  writeln('//************ startq');
  T:=TSQLTransaction.create(c);
  writeln('// trans.');
  C.Connected:=true;
  writeln('// con');
  Q:=TSQLQuery.Create(C);
  writeln('// Qcreat.');
  Q.SQL.Text := qs;
  writeln('<li>','qdb');
  Q.Database:=C;
  T.Database:=C;
  Q.Transaction:=T;
  writeln('<li>','qt');
  //qs := 'create  table turha2 (ID integer, NAME varchar(40));';
  //Q.open;
  //t.active:=true;

  writeln('<li>','MYquery:',qs);
  try
  q.execsql; except on e:exception do writeln('failexec-',e.message);end;
  writeln('<li>','executed:',qs);
  busy:=true;
  i:=1;
  while i<1000 do
  begin
    try
      i:=i+1;
      t.commit;
      //application.processmessages;
      busy:=false;
      break;
    except on e:exception do begin sleep(50); msg:=e.Message; end;end;
  end;
  if busy then writeln('<h1>failed to commit</h1>',msg) else
    writeln('<li>committed after ',i, 'tries');
  t.active:=false;
  writeln('<li>','deact');
 finally
  C.Connected:=false;
  writeln('<li>','discon');
  C.Free;
 end;
 writeln('<li>','endquery');

 end;


procedure tdb.sql_list(qs:string);//();
var
  ps:tlist;
  i,j,pos:integer;
  //c2:TSQLite3Connection;
  T:TSQLTransaction;
  Q:TSQLQuery;
begin
//C2:=TSQLite3Connection.create(nil);
//writeln('<li>','create con');
//C2.DatabaseName:='/home/t/xseus/turha2.db';
  if c=nil then
  begin
    C:=TSQLite3Connection.create(nil);
    writeln('<li>','create con');
    C.DatabaseName:='/home/t/xseus/turha.dbx';

  end;


//C:= CreateConnection;
//T := CreateTransaction(C);
T:=TSQLTransaction.Create(C);
writeln('--T created --');
C.Transaction := T;
writeln('--T to C --');
C.Open;
writeln('--C opened --');
T.StartTransaction;
writeln('--T started --');

Q:=TSQLQuery.Create(C);
writeln('// Q cre');
Q.Database:=C;
writeln('// Q2C');
Q.Transaction:=T;
writeln('// Q2T');
Q.SQL.Text:=qs;//'SELECT * FROM TBLNAMES';
writeln('<li> OPEN QUERY FOR LIST',qs);
//t.active:=true;

try
Q.execsql;
except on e:exception do writeln('eeeeeeeeeeeeeeeeeee',e.message);end;
writeln('--C opened --');
//writeln('--T committed??? --');
While not Q.EOF do
begin
  pos:=pos+1;
  //if pos>10 then break;
  writeln('<li>',inttostr(q.fields.count));
  for i:=0 to q.fields.count-1 do
     writeln(q.fields[i].FieldName,q.fields[i].asstring);
   t.commitretaining;
   sleep(500);
   Q.Next;
end;
q.close;
T.Commit;
c.close;
t.free;
writeln('<li> listend');
end;
{

writeln('// And now use the standard TDataset methods.');
T:=TSQLTransaction.Create(C);
T.Database:=C;
writeln('// Now we can open the database.');
C.Connected:=True;
//Q := CreateQuery(C, T);

writeln(' // Create a query to return data');
Q:=TSQLQuery.Create(C);
writeln('// Point to database and transaction.');
Q.Database:=C;
Q.Transaction:=T;
writeln(' // Set the SQL select statement:',qs);
Q.SQL.Text:=qs;//'SELECT * FROM TBLNAMES';
writeln('<li> OPEN QUERY',qs);
t.active:=true;
Q.Open;
writeln('<li> opende');
 pos:=0;
 While not Q.EOF do
 begin
   pos:=pos+1;
   //if pos>10 then break;
   writeln('<li>',inttostr(q.fields.count));
   for i:=0 to q.fields.count-1 do
      writeln(q.fields[i].FieldName,q.fields[i].asstring);
    sleep(200);
    Q.Next;
 end;
 writeln('<li> listend');
 Q.Close;
 writeln('// closed');
 T.Commit;
 t.active:=false;
 writeln('// committed');
// q.params.GetParamList(ps)

end;
}

{function tdb.sql_getconnection(dbname:string):pointer;
var  C:TSQLite3Connection;
begin
 C:=TSQLite3Connection.create(nil);
 //writeln('<li>','create con');
 C.DatabaseName:=dbname;
 result:=pointer(c);
end;
function tdb.sql_starttransaction(cp:pointer):pointer;
var C:TSQLite3Connection;
T:TSQLTransaction;
begin
 T:=TSQLTransaction.Create(TSQLite3Connection(C));
 T.Database:=TSQLite3Connection(C);
 result:=pointer(t);
end;
}

end.
















function sql_query(ds,qs:string):boolean;
var
 C:TSQLite3Connection;
 T:TSQLTransaction;
 Q:TSQLQuery;
 //D:TDatasource;
     i:integer;
begin
 try
writeln('<li>','start databasetest');
 //SQLConnection1.close;
 //writeln('<li>','closed old');
 C:=TSQLite3Connection.create(nil);
 //writeln('<li>','create con');
 C.DatabaseName:=ds;
 //writeln('<li>conto:',ds);
 //for i:=0 to 100 do
 begin
 T:=TSQLTransaction.Create(C);
 T.Database:=C;
 C.Connected:=true;
 //writeln('<li>','connected to',ds);
 Q:=TSQLQuery.Create(C);
 Q.Database:=C;
 Q.Transaction:=T;
 QS := 'createPASKA table turha (ID integer, NAME varchar(40));';
 Q.SQL.Text := qs;
 writeln('<li>','myquery:',qs);
 try
  C.EXECUTEDIRECT(QS);
 // Q.ExecSQL;
 except on e:exception do writeln('<li>ER:',e.message);end;
 //writeln('<li>','queried:',qs);
 t.commit;

 end;
 //listdb(c);
 finally
  C.Free;
 end;

 end;

procedure addrec(c:TSQLite3Connection); //aTran:TSQLTransaction);
var
  Q : TSQLQuery;
  T:TSQLTransaction;
  tnames:tstringlist;
  begin
     T:=TSQLTransaction.Create(C);
    writeln('// Point to the database instance');
    T.Database:=C;

    writeln('// Now we can open the database.');
    C.Connected:=True;
   writeln(' // Create a query to return data');
    Q:=TSQLQuery.Create(C);
    writeln('// Point to database and transaction.');
    Q.Database:=C;
    Q.Transaction:=T;
    writeln('// Set the SQL select statement');

 // Query := CreateQuery(ACon, ATran);
  // Set the SQL select statement
  //c.tableexists;
  tnames:=tstringlist.create;
  c.gettablenames(tnames);
  writeln(tnames.text);

  Q.SQL.Text := 'create table TBLNAMES (ID integer, NAME varchar(40));';
  writeln('ready..');
  try
  Q.ExecSQL;

  except on e:exception do writeln('failedtocreatetable:',e.message);

  end;
  writeln('execed1');
  Q.SQL.Text := 'insert into TBLNAMES (ID,NAME) values (1,''Name1'');';
  Q.ExecSQL;
  writeln('exe2');

  Q.SQL.Text := 'insert into TBLNAMES (ID,NAME) values (2,''Name2'');';
  Q.ExecSQL;
  writeln('exe3');
   T.Commit;
   writeln('trans committed');

  Q.Close;
  Q.Free;

end;

end.






{procedure createdb;
var
SQLConnection1:TSQLite3Connection;
SQLTransaction1:TSQLTransaction;
SQLQuery1:TSQLQuery;
SQLDatasource1:TDatasource;

begin
 try
 writeln('<li>','start');
 //SQLConnection1.close;
 //writeln('<li>','closed old');
 SQLConnection1:=TSQLite3Connection.create(nil);
 writeln('<li>','create con');
 SQLConnection1.DatabaseName:='/home/t/xseus/turha.db';
 writeln('<li>','a.db:');
 SQLConnection1.Connected:=true;
 writeln('<li>','connected');
 addrec(sqlconnection1);
 writeln('<li>','recadded');
 sql_list(sqlconnection1);
 finally
  SQLConnection1.Free;
 end;

 end;}
end.

//SQLTransaction1:=TSQLTransaction.create(nil);
//SQLTransaction1.Database:=SQLConnection1;
SQLConnection1.Transaction:=SQLTransaction1;
SQLTransaction1.Active:=true;

//SQLQuery1:=TSQLQuery.create(nil);
//SQLQuery1.Database:=SQLConnection1;
//SQLQuery1.Transaction:=SQLTransaction1;
//SQLQuery1.SQL.Text:='SELECT * FROM Student;';
sqlconnection1.ExecuteDirect('CREATE TABLE IF NOT EXISTS countries(' +
                   ' country_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' +
                   ' country_name VARCHAR(30) ' +
                   ')');

sqlconnection1.Transaction.Commit;
writeln('dddddddddddddddddddddddddddddddd');
//SQLDatasource1:=TDatasource.create(nil);
//SQLDatasource1.DataSet:=SQLQuery1;
end;
end.

procedure createdb;
var
  AConnection : TSQLConnection;
  ATransaction : TSQLTransaction;
  a:tibconnection;

begin
   try
  SQLiteLibraryName:='libsqlite3.so';
   aconnection.DatabaseName := '/home/t/xseus/turha.sqlite';
    except on  e:Exception do writeln('-noDB'+Exception(E).Message);
    end;
  AConnection := TSQLConnection.create;
  ATransaction := CreateTransaction(AConnection);
  AConnection.Transaction := ATransaction;
  AConnection.Open;
  ATransaction.StartTransaction;
  AConnection.ExecuteDirect('create table TBLNAMES (ID integer, NAME varchar(40));');

  // Some database-server types need a commit before you can use a newly created table. (Firebird)
  // With .Commit you also close the transaction
  ATransaction.Commit;

  ATransaction.StartTransaction;
  AConnection.ExecuteDirect('insert into TBLNAMES (ID,NAME) values (1,'Name1');');
  AConnection.ExecuteDirect('insert into TBLNAMES (ID,NAME) values (2,'Name2');');
  ATransaction.Commit;
  AConnection.Close;
  AConnection.Free;
  ATransaction.Free;
end.

function CreateConnection: TIBConnection;
begin
result := TIBConnection.Create(nil);
result.Hostname := 'localhost';
result.DatabaseName := '/opt/firebird/examples/employee.fdb';
result.UserName := 'sysdba';
result.Password := 'masterkey';
end;

procedure createdb;

var
SQLConnection1:TSQLite3Connection;
SQLTransaction1:TSQLTransaction;
SQLQuery1:TSQLQuery;
SQLDatasource1:TDatasource;

begin
//add sqlite3conn to uses at the top
SQLConnection1:=TSQLite3Connection.create(self);
SQLConnection1.DatabaseName:='A.db';
SQLConnection1.Connected:=true;

//add sqldb to uses
SQLTransaction1:=TSQLTransaction.create(self);
SQLTransaction1.Database:=SQLConnection1;
SQLConnection1.Transaction:=SQLTransaction1;
SQLTransaction1.Active:=true;

SQLQuery1:=TSQLQuery.create(self);
SQLQuery1.Database:=SQLConnection1;
SQLQuery1.Transaction:=SQLTransaction1;
SQLQuery1.SQL.Text:='SELECT * FROM Student;';

SQLDatasource1:=TDatasource.create(self);
SQLDatasource1.DataSet:=SQLQuery1;

Complie and run and there should be no errors
  //writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
 // SQLiteLibraryName:='/home/t/xseus/libsqlite.so';
  SQLiteLibraryName:='libsqlite3.so';
  if Aconnection.Connected then
    writeln('Successful connect!')
  else
    writeln('This is not possible, because if the connection failed, ' +
            'an exception should be raised, so this code would not ' +
            'be executed');
  AConnection.Close;
  AConnection.Free;  try
   SQL3c:=TSQLite3Connection.create(nil);
  except writeln('nocreate');
  end;
  try
SQLiteLibraryName:='libsqlite3.so';
  SQL3C.DatabaseName := '/home/t/xseus/turha.sqlite';
  except on  e:Exception do writeln('-noDB'+Exception(E).Message);
  end;
  ///try
  //SQLite3Connection1.createdb;
  //except on  e:EDatabaseError do writeln('-nocdb'+Exception(E).Message);
  //end;
  try
  //SQL3C.Connected := True;
  sql3c.open;
  sql3c.ExecuteDirect('create table TBLNAMES (ID integer, NAME varchar(40));');


  except on  e:Exception do writeln('-nocon'+Exception(E).Message);
  end;
  try
  SQLQuery1.Active := True;
  except writeln('-noact');
  end;

end;

end.



function tdb.sql_query(qs:string):pointer;
//var  C:TSQLite3Connection;
 //T:TSQLTransaction;
 //Q:TSQLQuery;
var i:integer;busy:boolean;
begin
  try
  if c=nil then
    begin
      C:=TSQLite3Connection.create(nil);
      writeln('<li>','create con');
      C.DatabaseName:='/home/t/xseus/xxxxxxturha.db';

    end;
  writeln('//************ startq');
  T:=TSQLTransaction.create(c);
  writeln('// trans.');
  C.Connected:=true;
  writeln('// con');
  Q:=TSQLQuery.Create(C);
  writeln('// Qcreat.');
  Q.SQL.Text := qs;
  writeln('<li>','qdb');
  Q.Database:=C;
  T.Database:=C;
  Q.Transaction:=T;
  writeln('<li>','qt');
  //qs := 'create  table turha2 (ID integer, NAME varchar(40));';
  //Q.open;
  q.sql.text:=qs;
  writeln('<li>','MYYquery:',qs);
  t.active:=true;
{  try
    q.open;
  // C.EXECUTEDIRECT(QS);
 //  Q.ExecSQL;
  except on e:exception do writeln('<li>ERROR',e.message);end;
   //writeln('<li>','queried:',qs);
  //t.commit;
  q.Close;
  T.COMMIT;
  C.Connected:=false;
  EXIT;
   result:=q;
 //listdb(c);

 sleep(10);

 writeln('<li>','did:::',q.fields.count,qs,q.RecordCount);
 for i:=0 to q.fields.count-1 do
    writeln(q.fields[i].FieldName,q.fields[i].asstring);

  q.close;
   writeln('<li>','closed',qs);
   busy:=true;
   i:=0;
   }
  while i<1000 do
  begin
    try
      i:=i+1;
      t.commit;
      //application.processmessages;
      busy:=false;
      break;
    except on e:exception do  sleep(50); end;
  end;
  if busy then writeln('<h1>failed to commit</a>') else
    writeln('<li>committed after ',i, 'tries');
  t.active:=false;
  writeln('<li>','deact');
 finally
  C.Connected:=false;
  writeln('<li>','discon');
  //C.Free;
 end;
 writeln('<li>','endquery');

 end;

{procedure tdb.sql_query(qs:string);//(c:TSQLite3Connection);
var
  ps:tlist;
  i,j,pos:integer;
begin
if c=nil then
  begin
    C:=TSQLite3Connection.create(nil);
    writeln('<li>','create con');
    C.DatabaseName:='/home/t/xseus/turha.db';

  end;

writeln('// And now use the standard TDataset methods.');
T:=TSQLTransaction.Create(C);
T.Database:=C;
writeln('// Now we can open the database.');
C.Connected:=True;
writeln(' // Create a query to return data');
Q:=TSQLQuery.Create(C);
writeln('// Point to database and transaction.');
Q.Database:=C;
Q.Transaction:=T;
writeln(' // Set the SQL select statement:',qs);
Q.SQL.Text:=qs;//'SELECT * FROM TBLNAMES';
writeln('// And now use the standard TDataset methods.');
Q.Open;
writeln('// opende');
 pos:=0;
 While not Q.EOF do
 begin
   pos:=pos+1;
   //if pos>10 then break;
   writeln('<li>',inttostr(q.fields.count));
   for i:=0 to q.fields.count-1 do
      writeln(q.fields[i].FieldName,q.fields[i].asstring);
    sleep(200);
    Q.Next;
 end;
 writeln('// istyend');
 Q.Close;
 writeln('// closed');
 T.Commit;
 writeln('// committed');
// q.params.GetParamList(ps)

end;

}


function tdb.sql_gettable(qs:string):pointer;
var  C2:TSQLite3Connection;
 T2:TSQLTransaction;
 //Q2:TSQLQuery;
var i,pos:integer;busy:boolean;
begin
  if c=nil then
    begin
      C:=TSQLite3Connection.create(nil);
      writeln('<li>','create con');
      C.DatabaseName:='/home/t/xseus/turha.db';
    end;
  writeln('//************ startq');
 // c2:=create('/home/t/xseus/huihai.db')
  T:=TSQLTransaction.create(c);
  T.Database:=C;
  writeln('// trans.');
  C.Connected:=true;

  //qs:='CREATE TABLE fileDB.qdn AS SELECT * from qdn';
  qs := 'attach database '':memory:'' as huihai';
//  t.active:=true;
  try
  c.ExecuteDirect('end transaction');
  C.EXECUTEDIRECT(QS);
  c.ExecuteDirect('begin transaction');
  writeln('<li>','didqs');
 //  Q.ExecSQL;
   except on e:exception do writeln('<li>ERROR1',e.message+'!'+qs+'!');end;
  try
  qs:='CREATE TABLE huihai.uus AS SELECT * from TBLNAMES';
  //qs:='CREATE TABLE uus AS SELECT * from TBLNAMES';
  c.ExecuteDirect(qs) ;
  except on e:exception do writeln('<li>ERROR2',e.message+'!'+qs+'!');end;
  qs := 'insert into huihai.uus (ID,NAME) values (100,''IHKAUUS'')';
  writeln('<li>','didisn');
 // Q.ExecSQL;
  c.executedirect(qs);
  //q.open;
  QS:= 'insert into huihai.uus (ID,NAME) values (200,''taasIHKAUUS'')';
  //writeln('<li>','doex2');
  //q.open;
  c.executedirect(qs);
  //Q.ExecSQL;
  writeln('<li>exe2');
  c.ExecuteDirect('end transaction');
  writeln('// con');
  Q:=TSQLQuery.Create(C);
  writeln('// Qcreat.');
  Q.SQL.Text := qs;
  writeln('<li>','qdb');
  Q.Database:=C;
  Q.Transaction:=T;
  writeln('<li>','qt');
  q.ParseSQL:=false;
  try
  //q.sql.text:='SELECT * from huihai.uus';
  q.sql.text:='SELECT * from links';
  q.open;
  except on e:exception do writeln('<li>ERROR3',e.message+'!'+q.SQL.text+'!');end;
  writeln('<li>','queried  huihai.uus');
  pos:=0;
  While not Q.EOF do
  begin
    pos:=pos+1;
    if pos>100 then break;
    writeln('<li>',inttostr(q.fields.count),'</li>');
    for i:=0 to q.fields.count-1 do
       writeln('--',pos,' ',q.fields[i].FieldName,q.fields[i].asstring);
     //t.commitretaining;
     sleep(100);
     Q.Next;
  end;

  //t.commit;

 //c.ExecuteDirect('end transaction');
  //Q.open;
end;

}
{function txseus.selroot(st: string; def: ttag; var rest: string;
  needtowrite: boolean; var gottafree: boolean): ttag;
var
  newtag, atag: ttag;
  txt, apust: string;
  rl: TList;
  i, apui: integer;
begin
  try
    Result := nil;
    gottafree := False;
    rest := '';
    if st = '' then
    begin
      Result := def;
      rest := '';
    end
    else
    begin
      if pos('file://', st) = 1 then
      begin
        //writeln('remembertofree:',st,appta.vari);
        gottafree := True;
        st := copy(st, 8, 256);
        apui := pos(';', st);
        if apui > 0 then
        begin
          rest := copy(st, apui + 1, 999);
          st := copy(st, 1, apui - 1);
        end
        else
          rest := '';
        apust := _indir(st, outdiri, self, needtowrite);
        Result := tagfromfile(apust, nil);
        //atag := ttag.Create;
        //atag.fromfile(apust, nil);
        ////if rest='' then
        //Result := atag.subtags[0];
        //atag.clearmee;
        exit;
      end
      else
      if pos('http://', st) = 1 then
      begin
        gottafree := True;
        txt := _httpget(st, -1, curbyele.getattributes);
        Result := tagparse(txt, False, True);
        //Result := ttag.Create;
        //if txt <> '' then
        //  Result.parse(txt, False, True);
        //Result := Result.subtags[0];
      end
      else

      if st[1] = '#' then //***any id-attribute anywhere
      begin
        apui := pos('/', st);
        if apui = 0 then
          apui := length(st) + 1;
        ///writeln('___',copy(st, 2, apui - 2),'---');
        ATAG := x_ids.findobject(copy(st, 2, apui - 2));
        Result := ATAG;//.subtags[0];
        if atag = nil then
        begin
          rest := '';
          exit;
        end;
        rest := copy(st, apui + 1, 999);
        //writeln('ID:'+result.vari+':'+copy(st, 2, apui - 2)+'!'+copy(st, apui+1, 999));
      end
      else
      if st[1] = '/' then //***ROOT
      begin
        Result := xml;
        rest := (copy(st, 2, 999999));
      end
      else
      if st[1] = '=' then //***RESTAG
      begin
        Result := curtoele;
        rest := (copy(st, 2, 999999));
      end
      else
      if st[1] = '!' then ////***handerslers
      begin
        //writeln('<h1>selappt:</h1>');
        writeln('selappt:'+copy(st, 2, length(st)));
        if (length(st) < 2) or (st[2] <> '!') then
        begin
          Result := x_handlers.subt(copy(st, 2, length(st)));
          writeln('<h2>root!'+st+'</h2><pre>'+RESULT.xmlis+'</pre>');
          writeln('<h2>root!'+st+'</h2><pre>'+x_handlers.xmlis+'</pre>');
        end
        else
          Result := curbyele.subt(copy(st, 3, length(st)));
        ;
        rest := '';
        //rl:=tlist.Create;
        //writeln('xxxxsdxxx');
        //apui := pos('/', st);
        //if apui=0 then apui:=length(st);
        //if (length(st)<2) or (st[2] <> '§') then
        //Result := txseus(xseusp).x_handlers.subt(copy(st, 2, apui - 2))
        //else
        //Result := appta.subt(copy(st, 2, apui - 2));
        //rest := copy(st, 2, 999);
        //writeln('xxxxsdxxx'+result.xmlis);
      end
      else
      if st[1] = '%' then ////***BOOKMARKS
      begin
        //rl:=tlist.Create;
        apui := pos('/', st);
        if apui = 0 then
          apui := length(st) + 1;
        ///writeln('___',copy(st, 2, apui - 2),'---');
        ATAG := x_bookmarks.subt(copy(st, 2, apui - 2));
        Result := ATAG;//.subtags[0];
        try
          //writeln('books.',ATAG.SUBTAGS.COUNT,copy(st, 2, apui - 2),'!<pre>'+ATAG.xmlis,'#',ATAG.VARI,'</pre>');
          Result := ATAG.subtags[0];
          //writeln('!!!',ttag(atag.subtags[0]).xmlis,'???');
        except
          writeln('nononbiik');
        end;
        rest := copy(st, apui, 999);
      end
      else  //***CURRENT
      begin
        rest := st;
        //result:=selta;
        Result := def;
      end;
    end;
  finally

  end;
end;
}

end.


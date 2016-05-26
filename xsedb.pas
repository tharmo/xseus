unit xsedb;

{$mode delphi}

interface

uses sqldb, db,
      sqlite3conn,
  Classes, SysUtils; 




type tdb=class(tobject)
c:TSQLite3Connection;
Q : TSQLQuery;
T:TSQLTransaction;
name:string;
//function sql_query(qs:string):pointer;
//function sql_getconnection(dbname:string):pointer;
//function sql_starttransaction(cp:pointer):pointer;
procedure sql_exec(qs:string);
function sql_gettable(qs:string):pointer;
//function sql_createtemp(qs:string):tdb;
function sql_copytable(db:tdb;qs,table:string):tdb;
//procedure sql_list(qs:string);
constructor create(dbname:string);
function sql_next:pointer;
procedure sql_open(qq:string);
procedure sql_prepare(qs:string);
procedure sql_doprepared(ats:pointer);
end;
procedure closeall_sql(dblist:tstringlist);
function getdb_sql(dbn:string;dblist:tstringlist):tdb;
function _createtempdb(db:tdb;dlist:tstringlist;sels,table:string):tdb;

implementation
uses xsexml;
{ SQL
  sql_connect create database
  //createtable to database can be done via exec_one
  exec_one make a single query
  prepapre prepare a query, start transaction and be ready for multiple next's
  prepare temp=true  //create a temporary table for "prepare"
  next

}
function _createtempdb(db:tdb;dlist:tstringlist;sels,table:string):tdb;
var newdb:tdb;
begin
  //result:=getdb_sql(':memory',dlist);
  result:=tdb.create(':memory:');
  //result:=tdb(db.sql_gettable(selst));
  dlist.addobject('temp_table',result);
  tdb(result.sql_copytable(db,sels,table));

end;

constructor tdb.create(dbname:string);
begin
 C:=TSQLite3Connection.create(nil);
 {if pos(':',dbname)=1 then
 begin
 //C.DatabaseName:=dbname;
 name:=dbname;

 end else}
 begin
 C.DatabaseName:=dbname;
 name:=dbname;

 end;

end;

procedure tdb.sql_doprepared(ats:pointer);
var i:integer;pees:tlist;apar:tparam;atts:tattributes;
begin
 atts:=tattributes(ats);
 pees:=tlist.create;

 // q.params.GetParamList(pees);
 try
  for i:=0 to q.params.count-1 do
  begin
      apar:=q.params[i];
      writeln('<li>',i,'@',apar.Name,'=',atts.values[apar.name]+'</li>');
    apar.Value:=atts.values[apar.name];
    //apar.Assign(atts.values[apar.name]);
    //Q.Params.ParamByName('ID').AsInteger := 1;
    //Q.Params.ParamByName('NAME').AsString := 'Name1';
  end;
  Q.ExecSQL;
  except on e:exception do begin writeln('<li>ERROR prepared ',e.message,'</li>');raise;end;end;

end;
procedure tdb.sql_prepare(qs:string);
begin
 writeln('<li>oppen',name,':',qs,'!</li>');
 try
 try
 T:=TSQLTransaction.create(c);
 writeln('<li> trans.');
 C.Connected:=true;
 writeln('<li> con');
 Q:=TSQLQuery.Create(C);
 writeln('<li> Q:',qs);
 Q.SQL.Text := qs;
 Q.Database:=C;
 T.Database:=C;
 Q.Transaction:=T;
 writeln('<li>','qdb');
 except on e:exception do writeln('<li>ERRORA opening query ',e.message,'!</li>');end;
 q.prepare;
 writeln('<li>prepared');
 except on e:exception do writeln('<li>ERROR preparing query ',e.message,'!</li>');end;

end;

procedure tdb.sql_open(qq:string);
//var
begin
 try
 T:=TSQLTransaction.create(c);
 writeln('<li> trans.');
 C.Connected:=true;
 writeln('<li> con');
 Q:=TSQLQuery.Create(C);
 writeln('<li> Q:',qq);
 Q.SQL.Text := qq;
 Q.Database:=C;
 writeln('<li>','qdb');
 T.Database:=C;
 Q.Transaction:=T;
 writeln('<li>','qt ');
 q.open;
 writeln('<li>','opened');
 except on e:exception do begin writeln('<li>ERROR opening database ',e.message,'</li>');end;end;
end;

function getdb_sql(dbn:string;dblist:tstringlist):tdb;
//
var
 i,dbi:integer;db:tdb;

begin
 //writeln('<li>dbs:',dblist.count,'?'+dbn+'</li>');
  //dbexists:=dblist.count>0;
 //for i:=0 to dblist.count-1 do
 // writeln('<li>db:',dblist[i]+'?'+dbn+'</li>');
  if dbn='' then
  begin
    if dblist.count>0 then result:=tdb(dblist.objects[0]) else result:=nil;
   // if dblist.count>0 then writeln('noi name, get firsts in list') else writeln('no name, nothing open;:result:=nil;');
   exit;

  end else
  begin
    //writeln('find connection '+dbn+'!');
    dbi:=dblist.indexof(dbn);
    if dbi>-1 then
    begin
     result:=tdb(dblist.objects[dbi]);
     //writeln('use connection ',dbi,':'+result.name);
    end
     else
    begin
     writeln('<li>create connection '+dbn);
     result:=tdb.create(dbn);
     dblist.addobject(dbn,result);
     //writeln('created connection '+dbn);
    end;
  end;

end;

procedure closeall_sql(dblist:tstringlist);
var i:integer;d:tdb;
begin
 for i:=0 to dblist.count-1 do
 begin
  try
  d:=tdb(dblist.Objects[i]);
  if d.t<>nil then
  begin
    d.t.Commit;
    d.t.free;
  end;
  if d.c<>nil then
  begin
  d.c.Close(true);
  d.c.free;

  end;
  except on e:exception do begin writeln('<li>ERROR commit in close; ',e.message,'</li>');raise;end;end;

 end;
end;

procedure tdb.sql_exec(qs:string);
//hit and run on a "local" transaction (???)
var  //C2:TSQLite3Connection;
 //Q : TSQLQuery;
 //Tt:TSQLTransaction;
 i,pos:integer;busy:boolean;
begin
 try
  if t<>nil then
  begin
    writeln('<li> DATABAse busy with transaction');
    exit;
  end;
  C.Connected:=true;
  writeln('---con');
  T:=TSQLTransaction.create(c);
  writeln('// transaction',qs,'!');
  t.Database:=C;
  t.active:=true;
  C.EXECUTEDIRECT(QS);
  except on e:exception do begin writeln('<li>ERROR sqlexec ',e.message,'</li>');raise;end;end;
  try
  t.Commit;
  t.free;
  t:=nil;
  except on e:exception do writeln('<li>ERROR commit in exec ',e.message,'</li>');end;
  writeln('<li>didsqlexe</li>');
end;

//Q.SQL.Text := 'create table TBLNAMES (ID integer, NAME varchar(40));';

function tdb.sql_gettable(qs:string):pointer;
// create a temporary memory-database from results of query, and leave the query open
{issues:
 - presently only one at a time
 -  possibly open query not freed
 - should create a new connection and a new tdb
}
//var  C2:TSQLite3Connection;
 //T:TSQLTransaction;
 //Q : TSQLQuery;
var i,pos:integer;busy:boolean;
begin
  C.Connected:=true;
  T:=TSQLTransaction.create(c);
  T.Database:=C;
  try
  c.ExecuteDirect('end transaction');
  try
  C.EXECUTEDIRECT('attach database ''memory'' as res');
  except on e:exception do writeln('<li>ERROR1',e.message+'!'+qs+'!');end;
  c.ExecuteDirect('begin transaction');
  //writeln('<li>','a trick learned from forums. This was necessary. could not achieve it using tsqltransaction');
   except on e:exception do writeln('<li>ERROR attaching tmp database table ',e.message,'</li>');end;
  try
    c.ExecuteDirect('CREATE TABLE res.uus AS '+qs);//SELECT * from TBLNAMES') ;
  except on e:exception do writeln('<li>ERROR creating memory table: ',e.message,'</li>');end;
  c.ExecuteDirect('end transaction');
  Q:=TSQLQuery.Create(C);
 //writeln('// Qcreat.');
  Q.Database:=C;
  Q.Transaction:=T;
  q.ParseSQL:=false;
  //writeln('<li>turning of parsesql required otherwise syntax error. '); //http://forum.lazarus.freepascal.org/index.php/topic,24751.msg149381.html#msg149381
  try
  q.sql.text:='SELECT * from res.uus';
  q.open;
  except on e:exception do writeln('<li>ERROR3',e.message+'!'+q.SQL.text+'!');end;
  //writeln('// temp database with open transaction created');//,ttag(sql_next).xmlis,ttag(sql_next).xmlis);
  result:=pointer(q);
end;


function tdb.sql_copytable(db:tdb;qs,table:string):tdb;
// create a temporary memory-database from results of query, and leave the query open
{trying to fix these issues of gettable:
 - presently only one at a time
 -  possibly open query not freed
 - should create a new connection and a new tdb
}
//var  C2:TSQLite3Connection;
 //T:TSQLTransaction;
 //Q : TSQLQuery;
var i,pos:integer;busy:boolean;//newdb:tdb;
begin
 C.Connected:=true;
 T:=TSQLTransaction.create(c);
 T.Database:=C;
// try
// C.EXECUTEDIRECT('drop table uus');
// except on e:exception do writeln('<li>ERROR dropping table: ',e.message,'</li>');end;
  try
  //C.EXECUTEDIRECT('drop table uus');
  writeln('<h1>db:'+name+'</h1>');
  writeln('<li>attach database '''+db.name+''' as old');
  c.ExecuteDirect('end transaction');
  //C.EXECUTEDIRECT('attach database '':memory:'' as res');
  C.EXECUTEDIRECT('attach database '''+db.name+''' as old');
  c.ExecuteDirect('begin transaction');
  writeln('<li>attached database '''+db.name+''' as old');
  //writeln('<li>','a trick learned from forums. These exedirects  were necessary. could not achieve it using tsqltransaction');
   except on e:exception do writeln('<li>ERROR attaching old database table: ',e.message,'</li>');end;
  try
  //qs:='CREATE TABLE res.uus AS SELECT * from TBLNAMES';
  //qs:='CREATE TABLE resset AS SELECT * from TBLNAMES';
  writeln('<li>CREATE TABLE uus AS SELECT * from old.'+table) ;
  c.ExecuteDirect('CREATE TABLE uus AS SELECT * from old.'+table) ;
  except on e:exception do writeln('<li>ERRORi creating tmp table: ',e.message,'</li>');end;
  //C.EXECUTEDIRECT('detach database ''my.db''');
  //writeln('// Qcreat.');
  c.ExecuteDirect('end transaction');
  C.EXECUTEDIRECT('detach database ''old''');

  Q:=TSQLQuery.Create(C);
  //writeln('// Qcreat.');
  Q.Database:=C;
  Q.Transaction:=T;
  q.ParseSQL:=false;
  //writeln('query temp table '); //http://forum.lazarus.freepascal.org/index.php/topic,24751.msg149381.html#msg149381
  //writeln('<li>turning of parsesql required otherwise syntax error. '); //http://forum.lazarus.freepascal.org/index.php/topic,24751.msg149381.html#msg149381
  try
  q.sql.text:='SELECT * from uus';
  q.open;
  except on e:exception do writeln('<li>ERROR3',e.message+'!'+q.SQL.text+'!');end;
  //writeln('// temp database with open transaction created');//,ttag(sql_next).xmlis,ttag(sql_next).xmlis);
  result:=self;
end;



function tdb.sql_next:pointer;
var // Q : TSQLQuery;
 i:integer;
 resu:ttag;
begin
  //Q := TSQLQuery(qp);
  //writeln('<li>gettin next', q.eof);
  result:=nil;
  if q.eof then exit;
  resu:=ttag.create;
  resu.vari:='result';
  try
  //writeln('<li>FIELDS COUNT:',q.fields.count);
  for i:=0 to q.fields.count-1 do
     begin
       //writeln('<li>',q.fields[i].FieldName+'='+q.fields[i].asstring);
       resu.addatt(q.fields[i].FieldName+'='+q.fields[i].asstring);
     end;
   //just to keep connection busy for testing a simultan3eus connection from otheer thread
   Q.Next;
   //writel
   //n('<li>next:',resu.xmlis);
  except on e:exception do writeln('<li>ERRORNXT',e.message+'!'+q.SQL.text+'!');end;
  result:=resu;
end;
end.


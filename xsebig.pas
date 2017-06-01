unit xsebig;

{$mode delphi}

interface
uses
  Classes, SysUtils,math;
const matsize=65536;
//const matsize=$FFFFFFFFFFFFFFFF;
type ttrienode=class(tobject)
end;
type ttrie=class(tobject)
  root:ttrienode;
end;
procedure bigmatrix(st:string);
implementation
 {   Sparse p-Adic Data Coding for Computationally
Efficient and Effective Big Data Analytics

Learning syntactic patterns for automatic
hypernym discovery
  }
procedure bigmatrix(st:string);

function _hash(st:string):word;
var i,len:integer;
begin
  writeln(st);
  result:=0;
  len:=length(st);
  for i := 1 to len do
    result := ord(st[i])+result*31;
  //result:=result mod 1024;
end;

var matrx:pointer;ipoint:^byte;hea,tim:double;
done:boolean;i,j,k,slen,wcount,aw,aw2,aw3,n2:integer;bstr,w:string;ch:char;index:word;vali:word;
ws:tstringlist;
bigstr:tfilestream;
hits,misses:array[0..258] of integer;
begin
 bigstr:=tfilestream.create(st,fmopenread);

 ws:=tstringlist.create;
 hea:=getheapstatus.totalallocated;tim:=now;
 //matrx:=getmem(matsize);
 getmem(matrx,matsize);
 slen:=length(st);
 fillchar(matrx^,matsize,0);
 writeln('<li>heap:',getheapstatus.totalallocated-hea,'/tim:',now-tim);
 tim:=now;wcount:=0;   aw:=0;
 n2:=1;
 {for i:=1 to 8 do
 begin
  writeln('<h3>',2**i,'</h3>');
  for j:=1 to 20 do
  begin
   //writeln('<li>');
   aw:=0;aw2:=0;aw3:=0;
   //randomize;
   for k:=1 to 2**2**i do
   begin
      if random(k*2)=0 then
       aw:=aw+1;
   end;
   writeln(2**((aw)),' ');
 end;
 end;
 exit;
 for i:=0 to 256 do
 begin
  if i=n2 then
   begin  writeln('<h2>',i, '</h2>');
    n2:=2*n2;
  end;
  for k:=1 to 10 do
  begin
   aw:=0;
   for j:=0 to n2 do
     if random(j)=0 then
     aw:=aw+1;
   writeln('<li>',aw);
   //if ispoweroftwo(i) then writeln(<li>
 end;
 end;
 exit;
 for j:=0 to 256 do begin hits[j]:=0;misses[j]:=0;end;
  }
  begin w:='';
   //for j:=1 to 20 do

   //for i:=1 to slen do

 //while i<slen do
   while bigstr.read(ch,1)=1 do
 begin
    if bigstr.position>=bigstr.size then break;
    //if bigstr.position>=0000000 then break;
    //i:=i+1;
     //ch:=st[i];
    //if i>10000 then break;

    if pos(ch,^m+^J+' ,.?!%&-;_''")(*}]{[1234567890')>0 then
    begin
      if length(w)>3 then
      begin
         vali:=hash(lowercase(w));
         ipoint:=matrx+vali;
         if ipoint^=0 then  wcount:=wcount+1;
         aw:=aw+1;
        //if (ipoint^=128)// and (w='then')
        //then writeln('? ');
        //if ipoint^<256 then  //more than 1+2+4+8...128 +256
        if random(ipoint^)=0 then
         begin
         ipoint^:=ipoint^+1;
            hits[ipoint^]:=hits[ipoint^]+1;

         //if ipoint^=255 then writeln('<li>',w,ipoint^,' ');
         if ipoint^ mod 128 =0  then
          ws.add(w+inttostr(ipoint^));
         end; //else
         misses[ipoint^]:=misses[ipoint^]+1;

      end;
      w:='';
    end else
    w:=w+ch;

    //if i>matsize then break;
    //index:=random(matsize);
 end;
 end;
 //end;
 writeln('<h2>heap:',(getheapstatus.totalallocated-hea)/1000,'/tim:',FormatDateTime('s . z',now-tim),'_',wcount,'</h2>');
 ws.sort;writeln(ws.text);
 writeln('<h2>Words: ',aw,' sep:',wcount,'</h2>');
 for j:=1 to 256 do begin try writeln('<li>',j,': ' ,hits[j],'/',misses[j],'=<b>',misses[j] div hits[j]+1,'</b></li>');except end;end;

end;

end.


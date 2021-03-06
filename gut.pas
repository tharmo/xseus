program gut;

{$mode objfpc}{$H+}
           {  $mode delphi}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  //cthreads,
 // sharemem,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, gutu,strutils,math
  { you can add units after this };
function hyphenate:tstringlist;forward;

type

  { tgut }

  tgut = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    instr:tfilestream;
    endpar:boolean;
    function readline:string;
    procedure cleanfile(fn:string);
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;
type tletterarray=array[1..32] of ansichar;
  const letters:array[1..32] of ansichar=('a','i','t','n','e','s','l','o','k','u',#228,'m','v','r','j','h','y','p','d',#246,'g','b','f','c','w',#229,'x','z','q','_','_','_');
  chrciphs:array[0..255] of ansichar=(#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#32,#0,#0,#35,#0,#0,#0,#0,#0,#0,#0,#0,#44,#45,#46,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#65,#66,#67,#68,#69,#70,#71,#72,#73,#74,#75,#76,#77,#78,#79,#80,#0,#82,#83,#84,#85,#86,#87,#0,#89,#0,#0,#0,#0,#0,#0,#0,#97,#98,#99,#100,#101,#102,#103,#104,#105,#106,#107,#108,#109,#110,#111,#112,#0,#114,#115,#116,#117,#118,#119,#0,#121,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#196,#197,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#214,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#228,#229,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#246,#0,#0,#0,#0,#0,#0,#0,#0,#0);
                //chrcodes:array[0..255] of byte=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27,0,0,31,0,0,0,0,0,0,0,0,29,30,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,22,24,19,5,23,21,16,2,15,9,7,12,4,8,18,0,14,6,3,10,13,25,0,17,0,0,0,0,0,0,0,1,22,24,19,5,23,21,16,2,15,9,7,12,4,8,18,0,14,6,3,10,13,25,0,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,11,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0);
  chrcodes:array[0..255] of byte=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0, 0,0,0,0,0,0,0,0,0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,22,24,19,5,23,21,16,2,15,9,7,12,4,8,18,29,14,6,3,10,13,25,27,17,28,0,0,0,0,0,0,1,22,24,19,5,23,21,16,2,15,9,7,12,4,8,18,29,14,6,3,10,13,25,0,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,11,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0);
  acodes:array[0..255] of byte=(0,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,000,000,000,000,000,000,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,24, 25,26,0,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000, 27, 28,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000, 29,000,000,000,000,000,000,000,000,000,000,000,000,000, 27, 28,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000, 29,000,000,000,000,000,000,000,000,000);
  aletters:array[1..32] of ansichar= ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','�','�','�','�','�','�');
type tshortnode=class(tobject)
   prefix:word; //pseudopointer to list of prefixes - to allow leaving of non-branching, n0n-word nodes
   haschild:word;//binary, each bit telling if it's corresponding letter forms a continuation
   childnodes:word; //pseudopointer to list of continuation nodes (each 32
   nextnode:word;   //pseudopoiner
end;
//var  wordbuckets:array[1..32,1..16,1..4] of word;     //sizeof alphabet, lengths

var debugst:string;

 //type w16=array[0..15] of byte;
 type w32=array[0..31] of byte;
 b32=bitpacked array[0..31] of boolean;

function readw(fst:tfilestream;var curword:w32;var cwlen:byte):boolean;
var ch:byte;
begin
 // fillchar(curword,32,0);
  cwlen:=0;
  result:=true;
  try
  while fst.read(ch,1)=1 do
  begin
    if fst.size<fst.position+2 then begin result:=false;break;end;
    if (ch=10) then begin exit;end;
    if ch=13 then continue;  //skip CR
    if cwlen>31 then continue;
    curword[cwlen]:=chrcodes[ch];
    cwlen:=cwlen+1;
  end; finally  // writeln('____________',result,cwlen);
  end;
end;
    function readl(fs:tfilestream;var resu:ansistring):boolean;
    var ch:byte;
    begin
      result:=true;
      try
      resu:='';
      while fs.read(ch,1)=1 do
      begin
        if fs.size<fs.position+2 then begin result:=false;break;end;
        if (ch=10) then  exit;
        if ch=13 then continue;  //skip CR
        if ch=ord('w') then resu:=resu+('v') else
        if ch=ord('W') then resu:=resu+('V') else
        resu:=resu+ansichar(ch);
      end; except   writeln('____________',result);end;
    end;

type tastack=record
 wlen:byte;
 s:pointer;
 stacktop,lasthit:longword;
 placebefore:boolean;
end;

type wl8=array[0..7] of byte; //just working with 8-letter wordsd

procedure lentab;
var fstr:tfilestream;
  curword:w32;
  cwlen:byte;
  //stacktop,lasthit:longword;
  custa:^tastack;
  ss:packed array[1..32] of tastack;

  function readl:boolean;
        var ch:byte;i:byte;
        begin
        fillchar(curword,32,0);
        result:=true;
        try
        cwlen:=0;
        while fstr.read(ch,1)=1 do
        begin
          //write(ansichar(ch));
          if fstr.size<fstr.position+1 then begin result:=false;break;end;
          if (ch=10) then  exit;
          if ch=13 then continue;  //skip CR
          curword[cwlen]:=(ch);
          cwlen:=cwlen+1;
        end; except   writeln('____________',result);end;
       // readln;
       end;

   function findstring:boolean;
    var midw,curw:^wl8;ilet:byte;hit:boolean;sma,smi:longword;

    begin
       result:=false;
       //write('\',custa^.stacktop,'\');
       if custa^.stacktop=0 then begin custa^.lasthit:=0;custa^.placebefore:=true;exit;end;
       custa^.lasthit:=custa^.stacktop div 2;
       sma:=custa^.stacktop;smi:=0;
       if custa^.stacktop>0 then
       repeat
         if sma<=smi then break;
         custa^.lasthit:=sma-((sma-smi) div 2);
         if custa^.lasthit<1 then break;
         custa^.lasthit:=custa^.lasthit-1;
         curw:=custa^.s+(custa^.wlen*custa^.lasthit);//nextstep:=lasthit div 2;
         hit:=true;
         for ilet:=0 to custa^.wlen-1 do //begin  //write(curw^[ilet],'=',curstr[ilet],'?');
           if curw^[ilet]<>curword[ilet] then
            begin hit:=false;custa^.placebefore:=curw^[ilet]>curword[ilet];//write('<>',lasthit);
              break
           end;        //writeln('    tryhit:',lasthit,ansichar(curw^[0]),ansichar(curw^[1]),placebefore,'!');
         if hit then begin //writeln('HITHITHIT');
           result:=true;exit;end;
         if custa^.placebefore then
         begin
           sma:=custa^.lasthit;
         end else
          smi:=custa^.lasthit+1;
       until false;//lasthit>=stacktop;
    end;

  function addstring:boolean;
   var f,t,s:pointer;i,len:longword;curw:^wl8;
  begin
      if not custa^.placebefore then custa^.lasthit:=custa^.lasthit+1;
      f:=(custa^.s+custa^.wlen*(custa^.lasthit));
      t:=f+custa^.wlen;
      if custa^.lasthit>=custa^.stacktop then len:=0 else len:=custa^.stacktop-custa^.lasthit;
      custa^.stacktop:=custa^.stacktop+1;
      if len>0 then move(f^,t^,len*custa^.wlen);
      s:=@curword;//str+1;
      move(s^,f^,custa^.wlen);
      curw:=custa^.s+custa^.wlen*custa^.lasthit;
      //if custa^.stacktop mod 1000 = 0 then
     //   for i:=0 to custa^.wlen do  write(ansichar(curword[i]));writeln;
     //   writeln('add:',custa^.lasthit, custa^.placebefore,custa^.stacktop,'@',custa^.wlen);
  end;



procedure createstacks;
var i:byte;
begin
  for i:=1 to 32 do
  begin
    getmem(ss[i].s,2**22);
    fillchar(ss[i].s^,2**22,#0);
    ss[i].STACKTOP:=0;
    ss[i].wlen:=i;
  end;

end;

var i,j,w:integer;counts:array[1..32] of longword;
  begin
  //  testbin;exit;
   //getmem(stack8,2**24);
  createstacks;
  //exit;
  for i:=1 to 32 do counts[i]:=0;
    //for i:=0 to files.count-1 do begin fstr:=tfilestream.create(files[i],fmopenread);
    //fstr:=tfilestream.create('/find2048.lst',fmopenread);
    fstr:=tfilestream.create('sanat.iso',fmopenread);
    w:=0;
    repeat
       if fstr.size-fstr.position<1 then break;
       readl;

       //counts[cwlen]:=counts[cwlen]+1;
       if (cwlen<3) or (cwlen>16) then continue;
       w:=w+1;
       //for i:=cwlen to 12 do curword[i]:=32;
       //if length(curstr)<>8 then continue;
       //writeln;
       custa:=@ss[cwlen];
       custa^.placebefore:=true;
       //writeln(cwlen,'-->',custa^.wlen,'!',cwlen);
       if findstring then
       begin end else
       addstring;
       //if fstr.position>1000 then break;
      //readciphered(aword,fstr);
      //if stacktop>100000 then break;
   until false;
     writeln('dopne');
      for j:=1 to 16 do
      begin
        custa:=@ss[j];
        writeln(j,'=',custa^.stacktop);
      end;
      //readln;
      //  for i:=1 to 32 do writeln(i,':',counts[i]);
      for j:=1 to 16 do
      begin
        custa:=@ss[j];
        writeln('words of ',custa^.wlen,': ',custa^.stacktop);
       for  i:=0 to custa^.stacktop*custa^.wlen do begin if i mod custa^.wlen =0 then writeln; write(ansichar((custa^.s+i)^));
        //if i mod 4000=0 then readln;
      end;


      end;
  end;


type simplestack=packed array[1..10000] of array[1..8] of byte;
type tmatrow=packed array[1..6461] of longword;
type tadmat=packed array[1..6461] of tmatrow;
type tsmat=packed array[1..6461] of packed array[1..6461] of byte;

//type tscarrow=
type tscarcemat=packed array[1..6461] of packed array[1..32] of word;
type pscarcemat=^tscarcemat;
type tmemtab=class(tobject)
  fstr:tfilestream;
  curword:array[0..15] of byte;
  cwlen:byte;
  mysize,stacktop,lasthit,maxsize:longword;
  wstackp:pointer;//^simplestack;
  placebefore:boolean;
  padmat,madmat:^tadmat;
  sadmat:^tsmat;
  scarsizes,scartargs,multisiz,multitarg:^tscarcemat;
  sums:array[1..6461] of longint;
  // scarmat:^tscarcemat;
    f:file;
 diags:array[1..6461] of longint;//should be local vars
 cosizes,cowhats:array[1..32] of longword; //should be local vars
 hits,difs,sims:array[1..6461] of longword;
 sanat,reasons:array[1..6461] of string;
  function addstring:boolean;
  function readl:boolean;
  function findstring(wrd:string):smallint;
  public
  constructor create(wl,siz:integer);
  procedure deps;//relations of word-pairs from turku.conllu-files
  function prw(ordo:integer):string;
  procedure multimat;
  procedure makematrix;
  procedure makescar;
  procedure scarmulti;
  //procedure prmatrix;//at end
  procedure iter;
  procedure dosims;
  procedure sumup(r:integer);
  function getsim(tof,inf:longint;var ordo:longint):longint;
  end;
function tmemtab.getsim(tof,inf:longint;var ordo:longint):longint;
 var i:integer;
 begin
   result:=0;
   for i:=1 to 32 do
    if scartargs^[inf,i]=tof then
    begin
       result:=scarsizes^[inf,i];
       ordo:=i;
       break;
    end;
 end;

 function tmemtab.prw(ordo:integer):string;
 var ii:integer;
 begin
   result:=sanat[ordo-1];
   //esult:='';inttostr(ordo)+
   //  for ii:=0 to 15 do if byte((wstackp+(ordo-1)*16+ii)^)<>0 then result:=result+(ansichar((wstackp+(ordo-1)*16+ii)^)) else break;
     //writeln;
 end;
procedure tmemtab.sumup(r:integer);
var ii,jj:integer;meansim:double;totsims,totdifs,simi,ordo,ss:longint;
begin
try
  for jj:=1 to 32 do cosizes[jj]:=0;
  for jj:=1 to 32 do cowhats[jj]:=0;
  totsims:=0;totdifs:=0;
  //for ii:=1 to mysize do if sims[ii]>0 then writeln(ii,':::',sims[ii]);
  for ii:=1 to mysize do totsims:=totsims+sims[ii];
  for ii:=1 to mysize do totdifs:=totdifs+difs[ii];
  //if totsims/(totsims+totdifs)>0.5 then
  //if totsims-totdifs<1 then exit;
  //writeln('****',sums[r],prw(r),'/',sums[c],prw(c),'                     ',totsims,'|',totdifs,'  ',1000*(totsims-totdifs)/(totsims+totdifs):4:0);
  //else
  //exit;
  try
  for ii:=1 to mysize do  //sort and pick 32 biggest
  begin
   //if (prw(i)='on') //and (prw(ii)='lienee ') then
   //then writeln(^j,'ON**************',prw(ii),hits[ii],'>',hitsize);
    //write(sims[ii]);
    if (sims[ii]>0) then
    begin
     // meansim:=(1000*sims[ii]) div totsims;//(diags[ii]*diags[i]);
      //simi:=round(1000*(sims[ii]-difs[ii])/(sims[ii]+difs[ii]));
      simi:=sims[ii];
      //hitsize:=hits[ii] div 1000;
      //if ii=i then
      //write(simi,'-');
       if simi>0 then
       //if hits[ii]>0 then
       for jj:=1 to 32  do
       begin
          if simi>cosizes[jj]then
          begin
            //writeln('(',prw(i),':',round(cosizes[jj]),')');//,round(diags[cowhats[jj]]),') ');
            move(cosizes[jj],cosizes[jj+1],(32-jj)*4);
            move(cowhats[jj],cowhats[jj+1],(32-jj)*4);
            cowhats[jj]:=ii;
            //write(' (',jj,'/',sims[jj],',',simi,') ');
            //if jj<>ii then
            cosizes[jj]:=simi;//[ii];//min(lonsiz,1000);
            //if jj<32 then if cosizes[jj]<cosizes[jj+1] then begin writeln('WWWWWWWWWWWWWWWWWWWWWW',jj);readln;end;
            //if jj>1 then if cosizes[jj]>cosizes[jj-1] then begin writeln('UUUUUUUUUUUUUU',jj);readln;end;
            break; //the saving / sorting loop
          end;
       end;
    end;
    end;except writeln('aaaaaaaaaaaaaaaaaaa'); end;
    //sum up results for one correlate of i
    totsims:=0;
    ii:=0;ss:=0;
    //for jj:=2 to 32 do totsims:=totsims+cosizes[jj];
    //writeln;    write(prw(r));
    for jj:=2 to 31 do
    begin
       if cowhats[jj]=0 then  continue;
       if cosizes[jj]<1 then  continue;
       if cowhats[jj]=r then continue;
       //write(cosizes[jj],'.');
       //ss:=ss+cosizes[jj];
       //ii:=ii+1;
       multisiz^[r,jj]:=cosizes[jj];//(1000*cosizes[jj]) div lonsiz  ;
       multitarg^[r,jj]:=cowhats[jj];
       //getsim(cowhats[jj],r,ordo);
       //if       (ordo-jj)>999995 then
       begin
         //write('  ',prw(cowhats[jj]),'<',ordo-jj,'  ');
         //write('  ',r,' ',jj,prw(cowhats[jj]),'/',cosizes[jj],'  ');
       //write('/',reasons[cowhats[jj]]);
       end;
    end;
    //writeln(^j,prw(r),' ',ii,' /S:',ss);
totsims:=0;
for jj:=1 to 32 do totsims:=totsims+multisiz^[r,jj];
multisiz^[r,1]:=round(totsims);
multitarg^[r,1]:=r;
//for jj:=1 to 32 do write(prw(jj),multisiz^[r,jj],' ');writeln;
for jj:=1 to 31 do if cosizes[jj]<cosizes[jj+1] then writeln(jj,'WRONG:',cosizes[jj],'<',cosizes[jj+1]);

except writeln('ERRxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');end;

end;
procedure tmemtab.dosims;
begin
assign(f,'matmul.bin');
 Reset(F,4*6461**2);
   Blockread (F,madmat^,1);
    close (f);
end;
procedure tmemtab.iter;
var i,j,k,jj,kk,rowvar,colvar,coln, co_r,co_c,rc,rr,common:longint;
  difrc,simrc:double;
  hitit:integer;
  rs:string;
  didcol:array[1..32] of boolean;
begin
for i:=1 to 6461 do begin sims[i]:=0;difs[i]:=0;sums[i]:=0;for j:=2 to 32 do sums[i]:=sums[i]+scarsizes^[i,j]; end;
 //for j:=0 to 10 do writeln(j,sanat[j]);
 for rowvar:=1 to 6460 do
   begin
     try
    //write(^j,prw(i):8,'   ');
    if sums[rowvar]=0 then continue;
    for i:=1 to 6461 do begin sims[i]:=0;difs[i]:=0;//reasons[i]:='';
    end;

     //writeln;
     //writeln;
     except writeln('ERRzxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');end;
   for coln:=1 to 32 do
   begin
     for i:=1 to 32 do
      didcol[i]:=false;
     colvar:=scartargs^[rowvar,coln];
    if sums[colvar]=0 then continue;
     if colvar=0 then continue;
     difrc:=0;
     simrc:=0;
     //writeln(rowvar,prw(rowvar),'>',scarsizes^[rowvar,coln],' ',colvar,prw(colvar));
     //continue;
     hitit:=0;rs:='';
     //if colvar=rowvar then continue;
     for rr:=1 to 32 do
     begin
      co_r:=scartargs^[rowvar,rr];
       //if co_r=0 then continue;
       //if co_r=rowvar then continue;
       //if co_r=colvar then continue;
      for rc:=1 to 32 do
      begin
        co_c:=scartargs^[colvar,rc];
        //if co_c=rowvar then continue;
        //if co_c=colvar then continue;
        //if co_c=0 then begin continue;end; //gotta count dirs for missing pairs!!
         if co_c=co_r then
         begin
            try
            didcol[rc]:=true;
            //write('*',rc);
            rs:=rs+prw(co_c)+'.';
            hitit:=hitit+1;
            //reasons[co_r]:=reasons[co_r]+prw(colvar);
            //difs[co_r]:=difs[co_r]+abs(round(1000*(scarsizes^[rowvar,rr]/sums[rowvar]-scarsizes^[colvar,rc]/sums[colvar])**1));// sums[k]**2;
            //sims[co_r]:=sims[co_r]+round(1000*(scarsizes^[rowvar,rr]/sums[rowvar]+scarsizes^[colvar,rc]/sums[colvar])**1);// sums[k]**2;
            sims[co_r]:=sims[co_r]+round(1000*min(scarsizes^[rowvar,rr]/sums[rowvar],scarsizes^[colvar,rc]/sums[colvar]));// sums[k]**2;
            break;
            except end;
          end;
         end;
     end;
     //write(^j,prw(rowvar),'+',prw(colvar),'=',sims[co_c],'-',difs[co_c],': ',coln,' :');
      for i:=1888 to 32 do
      if not didcol[i] then
      begin
        co_c:=scartargs^[colvar,i];
        difs[co_c]:=difs[co_c]+abs(round(1000*(scarsizes^[colvar,i]/sums[colvar]/4)));// sums[k]**2;
        //write('(-',prw(co_c),scarsizes^[colvar,i],') ');
      end else write('+',prw(scartargs^[colvar,i]));
      //writeln;

     //if hitit>3 then writeln(prw(rowvar),'/',prw(colvar),': ',rs,'#',hitit);
     //writeln(^j);
   end;

   //writeln('******************DID;',prw(rowvar));
   sumup(rowvar);//,colvar,coln);
 end;
 //mmat:=mmm;
end;

procedure tmemtab.multimat;
var i,j,br,bc,bb,ir,ic,ib,divi:integer;
  ro,co,bo,rob,cob,bob:^tmatrow;
  blocks,bsize,xtras,rolen,colen,bolen:integer;
  maxi,vali:longword;//diags:array[1..6461] of longword;s:string;
begin
  maxi:=0;
  rob:=@padmat;
  //mysize:=3;
  //mysize:=5;
  bsize:=32;//2**16;
  xtras:=mysize mod bsize;
  blocks:=mysize div bsize;
  //blocks:=2;xtras:=2;//bsize;
  //blocks:=1;
  //if xtras>0 then
  blocks:=blocks+1;
  writeln('multistart:',blocks,'/mod:',xtras);
  for i:=1 to mysize do diags[i]:=sadmat^[i,i];
  //for i:=1 to mysize do              7
  //  for j:=1 to mysize do if i<>j then diags[i]:=diags[i]+padmat^[i,j];

  for br:=0 to blocks-1 do
  begin
   writeln;
   writeln;
   writeln('/br:',br);
    //rob:=rob+1;cob:=@madmat;
    if br<blocks-1 then rolen:=bsize else rolen:=xtras;
    for bc:=0 to blocks-1 do
    begin
      write('  /bc:',bc);
      //cob:=cob+1;bob:=@madmat;
      if bc<blocks-1 then colen:=bsize else colen:=xtras;
      begin
        for bb:=0 to blocks-1 do
        begin
           //writeln('    /ref:',bb);
           if bb<blocks-1 then bolen:=bsize else bolen:=xtras;
           //continue;
           //bob:=bob+1;
           for ir:=br*bsize+1 to br*bsize+rolen do
           begin
             if diags[ir]<1 then begin write('');continue;end;
             for ic:=bc*bsize+1 to bc*bsize+colen do
             begin
               if ir=ic then begin madmat^[ir,ir]:=diags[ir];continue;end;
              //s:='                ';
                //continue;
                if diags[ic]<1 then begin continue;end;
              //writeln('  /IC ', ic);
               for ib:=bb*bsize+1 to bb*bsize+bolen do
               begin
                 //s:=s+inttostr(ir)+'.'+inttostr(ic)+'.'+inttostr(ib)+'   ';
                 if diags[ib]<1 then begin continue;end;
                 if ib=ic then continue;
                 if ib=ir then continue;
                //divi:=(padmat^[ib,ib]*padmat^[ic,ic]+1) div 100;
                try
                //inc(madmat^[ir,ic]);
                //inc(madmat^[ir,ib]);
                //inc(madmat^[ic,ib]);
               // write(madmat^[ir,ic],'              ', ir,'  ',ic,' ',ib,'            ', padmat^[ir,ic],' ', padmat^[ir,ib],' ', padmat^[ic,ib],'/',(diags[ic]*diags[ib]));
                //if divi>0 then

                //madmat^[ir,ic]:=madmat^[ir,ic]+(10*(padmat^[ir,ib]*padmat^[ic,ib]));// div (diags[ic]*diags[ir]);//*diags[ir]);
                //madmat^[ir,ic]:=madmat^[ir,ic]+(10*(padmat^[ir,ib]*padmat^[ic,ib])) div (diags[ib]);
                  madmat^[ir,ic]:=madmat^[ir,ic]+(100000*padmat^[ir,ib]*padmat^[ic,ib] div (diags[ib]*diags[ib]));
                 // writeln('=',madmat^[ir,ic]);
                //vali:=madmat^[ir,ic]+((padmat^[ir,ib]*padmat^[ic,ib])) div divi;//*padmat^[ir,ir]*padmat^[ic,ic]+1)
                 //madmat^[ir,ic]:=vali;
                 //if vali>maxi then begin write(' max:',maxi);maxi:=vali;end;
                except writeln('failed mat ',ir,':',ic);          end;
                //madmat^[ir,ic]:=madmat^[ir,ic]+10*(padmat^[ir,ib]*padmat^[ic,ib]) div (padmat^[ib,ib]+1)
                  //round((log2(padmat^[ib,ir]+1)*log2(padmat^[ib,ic]+1)));///(padmat^[ib,ib]*padmat^[ic,ic]+1));
               end;
               //writeln(br,'/',bc,'/',bb,'   /',ir,'/',ic,'/',s);
               //madmat^[ir,ic]:=100*madmat^[ir,ic] div (madmat^[ir,ic]:=madmat^[ic,ic]+1)
                //if ic<11 then writeln(' [',ir,',',ic,']=',madmat^[ir,ic],':',padmat^[ir,ic]);
                //if ic<4 then write(madmat^[ir,ic],' ');
             end;
           end;

        end;
      end;
    end;

  end;
end;


procedure tmemtab.makematrix;//relations of word-pairs from turku.conllu-files
var line:string;wlist,reflist,olist:tstringlist;i,j,jj,col,len,iref,lines,diag1,diag2:integer;
  w,ordi,ref,res:string;
  sid:integer;wnum,wnum2:smallint;wnumlist:array[1..1000] of smallint;slen,smax:smallint;
  //diags:array[1..6461] of longword;
  lp:^word;
  mieli,endsent:boolean;
begin
wlist:=tstringlist.create;
olist:=tstringlist.create;
reflist:=tstringlist.create;
sid:=1;
slen:=0;         lines:=0;
mieli:=false;
smax:=0;
repeat
  readln(line);
  lines:=lines+1;
  if lines mod 1000000=1 then write(lines div 1000000,' ');
  col:=1;
  w:='';ref:='';ordi:='';
  len:=length(line);
  endsent:=len<20;
  if not endsent then
  begin  //write('\');
      for i:=1 to len do
      begin
          if line[i]=#9 then
          begin
          col:=col+1;
          end
          else begin
              if col=1 then ordi:=ordi+line[i] else
              if col=2 then begin //write(line[i]);
                 if pos(line[i],'?!.;,')>0 then begin endsent:=false;end;end else
              if col=3 then w:=w+line[i] else
              if col=7 then ref:=ref+line[i];
          end;

      end;
      //write('/');

      // pos(w,'_ja_tai_ei_jos_tuo,.:;?!"''')<1 then
       // length(w)>2 then
      //if length(w)>2 then
      begin
        try
        wnum:=findstring(w);
         except writeln('xxxxxxxxxxxxxxxxxxx');end;
         //write('(',w,wnum,') ');
        if wnum>0 then
         begin
           slen:=slen+1;
           wnumlist[slen]:=wnum;
           wlist.add(w);
//        reflist.add(ref);
//      olist.add(ordi);
      //writeln(ordi,'/',w,'/',ref);
         end;
      end;
   end //else  //got one sent
  ; if endsent then
  begin
    //if slen>1000 then writeln(slen,' ', wlist.count);
    if slen>2 then
     for i:=1 to slen do
     begin
      wnum:=wnumlist[i];
      if mieli then write('_',prw(wnum));//write('/',' ');
      if slen>smax then begin smax:=slen;mieli:=true;end;
      for j:=1 to slen do
      begin
        wnum2:=wnumlist[j];
         //if (padmat^[wnum,wnum2])>254 then
         //write('****i:',i, '/j:',j,'/w1:',wnum,'/w2:',wnum2,'/len:',slen);
         //writeln(' ',wlist[i-1],wnum,' ',wlist[j-1],wnum2);

         padmat^[wnum,wnum2]:=padmat^[wnum,wnum2]+1;
             //if wlist.count>1 then
             {for i:=0 to wlist.count-1 do
              writeln(sid, ' ', wlist[i]);
             sid:=sid+1;
            //writeln;
            }
            {if slen>2 then
            for i:=2 to slen do
            for j:=1 to i do
              writeln(wlist[i],' ',wlist[j]);
             }
         //writeln;
      end;
      //writeln;
     {for i:=0 to wlist.count-1 do
         if length(wlist[i])>2 then
          if pos(wlist[i],'_ja_tai_ei_jos_tuo,.:;?!"''')<1 then
         //writeln(wlist[i]+'?');
         if findstring(wlist[i]) then
         //writeln('++++/',wlist[i]);
         begin
            iref:=strtointdef(reflist[i],0);
            if iref>0 then if length(wlist[iref-1])>2 then
               //if pos(wlist[iref-1],'_ja_tai_ei_jos_tuo,.:;?!"''')<1 then
               if findstring(wlist[iref-1]) then
                  writeln('    /',wlist[i],'/',wlist[iref-1]);
         end;// else    writeln('<<<<<<<');
      }
     end;//writeln;
    if mieli then writeln;
    if mieli then writeln;
    mieli:=false;
    slen:=0;wlist.clear;olist.clear;reflist.clear;
   end;
until eof;
writeln('longest:',smax);
end;
procedure tmemtab.makescar;
var i,j,ii,jj,maxi,rowtot:longword;wn,ws:longword;//freqs:array[0..255] of byte;

begin
writeln('zzzzzzzzzzzzz');
{
for i:=1 to mysize do
 begin
      for j:=1 to mysize do
       begin
        sadmat^[i,j]:=round(16*ln(padmat^[i,j]+1));
        if maxi<=padmat^[i,j] then writeln(prw(i),'/',prw(j),sadmat^[i,j],'<-',padmat^[i,j],'.',round(ln(padmat^[i,j]+1)*16));
        maxi:=max(maxi,padmat^[i,j]);
        //if i:=j then write(
       end;
      //writeln('max:',maxi);
  end;

assign(f,'s mat.bin');
Rewrite (F,6461**2);
 BlockWrite (F,sadmat^,1);
close (f);
writeln('didmat')
}
assign(f,'mat.bin');
getmem(padmat,sizeof(padmat^));

writeln('mat:',sizeof(padmat^));
Reset (F,sizeof(padmat^));
writeln('mat:',sizeof(padmat^));
 Blockread(F,padmat^,1);
 writeln('mat:',sizeof(padmat^));

close (f);


//exit;
{for j:=1 to mysize do
begin
  diag:=sadmat^[j,j];
  freqs[diag]:=freqs[diag]+1;
  write(diag,' ');
end;

for j:=0 to 255 do
begin
 write(j);
 for jj:=1 to freqs[j] do if jj mod 5=0 then write('*');
 writeln;
end;
exit;
}
getmem(scarsizes,32*6461*2);
fillchar(scarsizes^,32*6461*2,#0);
getmem(scartargs,32*6461*2);
fillchar(scartargs^,32*6461*2,#0);
for i:=100000000 to mysize do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   write('****',padmat^[i,i],'  X',prw(i),'X');
  // for jj:=1 to mysize do  if (padmat^[i,jj]*10000) div (padmat^[i,jj]+1) >10 then write(prw(jj),(padmat^[i,jj]*1000) div (1+padmat^[i,jj]),';');
   for jj:=1 to mysize do  if padmat^[i,jj]>1 then if (padmat^[i,jj]*100000) div (1+padmat^[jj,jj])>1000 then write(padmat^[i,jj],prw(jj),(padmat^[i,jj]*100000) div (1+padmat^[jj,jj]),'; ');
   writeln;
   writeln;
end;
//type tscarcemat=packed array[1..6461] of array[1..32] of word;

  for i:=1 to mysize do
  begin
   fillchar(cosizes,32*4,#0);
   fillchar(cowhats,32*4,#0);
   rowtot:=0;
   for j:=1 to mysize do
   begin
     //diag:=padmat^[j,j];
     //if diag>0 then ws:=(1000* padmat^[i,j]) div diag;
     //if diag<5 then continue;
    if i=j then continue;
    //ws:=round(5*sqrt(padmat^[i,j]));
    //ws:=round(100*log2(1+
    ws:=(10000*padmat^[i,j]) div (padmat^[j,j]+500);
    if ws>1 then  if padmat^[i,j]>1 then
     //write(diag,',',ws,'/');
     for jj:=1 to 32 do
      if cosizes[jj]<ws then
      //if cowhats[jj]>0 then
         //if largest8[jj]
          begin
           move(cosizes[jj],cosizes[jj+1],(32-jj)*4);
           move(cowhats[jj],cowhats[jj+1],(32-jj)*4);
           cowhats[jj]:=j;
           cosizes[jj]:=ws;
           break; //the larg8 loop
          end;
      end;
   for jj:=1 to 31 do
   begin
    scarsizes^[i,jj]:=cosizes[jj];//round(100*log2(cosizes[jj]+1));
    scartargs^[i,jj]:=cowhats[jj];
    //if i<>j then rowtot:=cosizes[jj]+rowtot;
    if i<>j then rowtot:=scarsizes^[i,jj]+rowtot;
    //write(i,'=',scartargs^[i,jj],' ');
   end;
   scarsizes^[i,1]:=rowtot;//round(100*log2(rowtot+1));
   scartargs^[i,1]:=i;
   if rowtot>40000 then writeln('[]',prw(i),rowtot,':',scarsizes^[i,i]);
   //writeln;
   //writeln;
  end;
  assign(f,'scsizes.bin');
  Rewrite (F,6461*2*32);
    BlockWrite (F,scarsizes^,1);
  close (f);
  assign(f,'sctargs.bin');
  Rewrite (F,6461*2*32);
    BlockWrite (F,scartargs^,1);
  close (f);
  for i:=1 to mysize do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
  begin
     write(scarsizes^[i,1],':::  ',prw(i-1));
     for jj:=1 to 32 do if scartargs^[i,jj]>0 then  write(prw(scartargs^[i,jj]-1),scarsizes^[i,jj],',');
     writeln;
     writeln;
  end;

end;

function cor(mrow,id:word):longword;
begin

end;
type tmat =array[1..12] of array[1..12] of longword;


procedure tmemtab.scarmulti;
var i,j,ii,jj,k,kk,apu,maxi:integer;wn,ws,diag:longint;freqs:array[0..255] of byte;
  //scarsizes,scartargs,multisiz,multitarg,
  swp:^tscarcemat;
  itarg,jtarg,jjtarg,iitarg,ktarg,  iters:word;
  lonsiz,isiz,jsiz,iisiz,jjsiz,jsum,ksiz,total:longword;
  expd:longint;
  hitsize:longword;
 // diags:array[1..6461] of longword;
begin
mysize:=12;
getmem(multitarg,32*6461*2);
fillchar(multitarg^,32*6461*2,#0);
getmem(multisiz,32*6461*2);
fillchar(multisiz^,32*6461*2,#0);
{  getmem(scarsizes,32*6461*2);
  getmem(scartargs,32*6461*2);
  assign(f,'scsizes.bin');
  Reset (F,6461*2*32);
    Blockread (F,scarsizes^,1);
  close (f);
  assign(f,'sctargs.bin');
  Reset (F,6461*2*32);
    Blockread (F,scartargs^,1);
  close (f);]]}
  //writeln('multiply scarec');
{  for i:=1 to 1 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
  begin
     write(prw(i),': ');   maxi:=0;//scarsizes^[i,1];
     for jj:=1 to 10 do //if scartargs^[i,jj]<1 then continue else
     if scarsizes^[i,jj]>maxi  then
     begin
       write(scarsizes^[i,jj],',',prw(scartargs^[i,jj]),' ');
       maxi:=scarsizes^[i,jj];
     end;
     writeln;WRITELN;
  end;
  prmatrix;
exit;
}
{for i:=1 to mysize do  //diags[i]:=scarsizes^[i,1];
begin
  diags[i]:=0;
  for j:=2 to 32 do
  diags[i]:=diags[i]+scarsizes^[i,j];
end;
for i:=1 to mysize do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
 write(i,':',prw(i),'=', scarsizes^[i,1],'/',diags[i],':         ');
 for ii:=2 to 32 do
  if scarsizes^[i,ii]<1 then break else
   write(prw(scartargs^[i,ii]),'=', scarsizes^[i,ii],' ');
 writeln;writeln;
 end;
exit;}



for iters:=1 to 4 do
begin
 //if iters>3 then break;
 //readln;
 fillchar(multisiz^,32*6461*2,#0);
 fillchar(multitarg^,32*6461*2,#0);
// readln;
 // write(scarsizes^[i,jj],',',prw(scartargs^[i,jj]),' ')
 for i:=1 to mysize do  //diags[i]:=scarsizes^[i,1];
 begin
 //!!  diags[i]:=scarsizes^[i,1];
   //write(prw(i),':',scarsizes^[i,1],' ');
   for j:=2 to 32 do
     diags[i]:=diags[i]+scarsizes^[i,j];

    //if diags[i]>20000 then writeln(prw(i),'/',diags[i],' ');
 end;
 //prmatrix;


 for i:=1000000000 to mysize do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
             begin
                //write(prw(i),diags[i],': ');
                for jj:=1 to 10 do if scartargs^[i,jj]<1 then continue else write(prw(scartargs^[i,jj]),scarsizes^[i,jj],'/',diags[jj],'=',((1000000*scarsizes^[i,jj]) div diags[jj]),' ');
                //writeln;WRITELN;
             end;
 //writeln('start:',scartargs^[1,1],'=',scarsizes^[1,1]);

//readln;
 //exit;
 maxsize:=0;
 try
 for i:=1 to mysize do
 begin
    if diags[i]<1 then continue;
    for jj:=1 to mysize do hits[jj]:=0; //redunda
    //write(^j,'I:',prw(i),'::',scarsizes^[i,1],'**');for j:=2 to 5 do write(prw(scartargs^[i,j]),'.');writeln;
    // if (i mod 3000=0) then readln;
    //fillchar(cosizes,4*32,#0);
    //fillchar(cowhats,4*32,#0);
    //if iters=2 then
    if diags[i]<1 then continue;
    //writeln(^j, '*************',i,prw(i));
    try
    for j:=2 to 32 do //cols
    begin
       jtarg:=scartargs^[i,j];
       //if (jtarg=i) or
        if (jtarg=0) or (diags[jtarg]=0) then continue;
       jsiz:=scarsizes^[i,j];
       if jtarg=i then continue;
       //write(^j,prw(i),'  J:', prw(jtarg),'/',scarsizes^[i,1],'**');for ii:=2 to 10 do write(prw(scartargs^[jtarg,ii]));writeln;
       try //all other cors of i (to find "third parties" that correlate with both i and j)
       for jj:=1 to 32 do
       begin  //for each cor of current j
          jjtarg:=scartargs^[jtarg,jj];
          {if iters=1 then if prw(i)='auto' then
          if (prw(jtarg)='punainen') then
          begin
          writeln('!!!!!!!',prw(i),'*',prw(jtarg),jsiz,'/',diags[jtarg],'_',jjtarg,prw(jjtarg),jjsiz,'/',diags[jjtarg],'! ',lonsiz,'!',(hits[jjtarg]));
          writeln('NO!!!!',jjtarg=i ,jtarg=0,jjtarg=jtarg,(diags[jjtarg]<1),jjsiz=0);//
          end;}
          //if iters=2 then if prw(i)='auto' then
          {if (prw(jjtarg)='mies') or (prw(jjtarg)='sininen') then
          begin writeln('   (',prw(jjtarg),'/d:',diags[jjtarg],'ij:',i,'.',j,'.',jjtarg,(jjtarg=0) or (diags[jjtarg]<1) or (jjtarg=i) or (jjtarg=j));
             //for kk:=i to 32 do write(prw(scartargs^[jtarg,kk]));
          end;}
          if   jjtarg=0    then break;
          if jjtarg=i then continue;
          //if  jjtarg=jtarg   then continue;
          if  (diags[jjtarg]<1)     then continue;
          jjsiz:=scarsizes^[jtarg,jj];
          if (jjsiz=0) then continue;
          try
          begin //the J cors with II
          { iisiz:=0;
          for ii:=2 to 32 do //scan all other corrs of i
          begin
             if prw(jtarg)='sininen' then write('*',prw(jjtarg));
             if scartargs^[i,ii]<>jjtarg then continue;
             //iitarg:=scartargs^[jtarg,jj]; //same as iitarg, but lets give it another name t keep track where we are
             iisiz:=scarsizes^[i,ii];
             break;
          end;}
          //   if (iisiz=0) then continue;
             //the J cors with II
             {for k:=2 to 32 do if scartargs^[iitarg,k]>1 then
           begin
               ktarg:=scartargs^[iitarg,k];
               if ktarg=i then continue;
               if ktarg=j then continue;
               for kk:=1 to 32 do if scartargs^[jtarg,kk]>1 then
               begin
                 if ktarg=scartargs^[jtarg,kk] then
                 begin}
                 //lonsiz:=1+(diags[iitarg]*diags[ktarg]) div 100;//using a free var for intermediate result
                 //lonsiz:=jjsiz*iisiz div lonsiz;
                 //lonsiz:=((diags[jjtarg]-iisiz)*(diags[jtarg]-jsiz)) div 1000;//using a free var for intermediate result
                 //lonsiz:=jjsiz*iisiz  div lonsiz;
           //dgs[k]**2 div 10000;
          expd:=round((diags[i] * (diags[jtarg]/total*diags[jjtarg]/total))*10);
          //hits[jjtarg]:=hits[jtarg]+(scarsizes[j,k]*scarsizes[i,k]) div rela;
          hits[jjtarg]:=hits[jtarg]+abs(expd-jjsiz);
          //rela:=rela+abs(expd-mmat[4,k]);

           lonsiz:=jjsiz*jsiz;
                       //write(lonsiz,'/',hits[ktarg]);
                 hits[jjtarg]:=hits[jjtarg]+(lonsiz);
                 //writeln('             :',prw(i),prw(jtarg),prw(iitarg),':',prw(ktarg),'+',hits[iitarg]);
                  {if prw(i)='sininen' then  //if prw(i)='sininen' then
                  if (pos('tytti',prw(i)+prw(jjtarg))>0)
                   or  (pos('sininen',prw(i)+prw(jjtarg))>0) then}
                   //if prw(i)='sininen' then if (prw(jtarg)='tytti') then
                  //if pos('pallo',prw(i)+prw(jtarg)+prw(ktarg)+prw(iitarg))>0 then
                   try
                   if prw(i)='xxxxxxxxauto' then //
                   if prw(jtarg)='sininen' then
                    writeln(^j,'',copy(prw(i),1,2),'/',copy(prw(jtarg),1,2),'/',copy(prw(jjTARG),1,2),'    ',(lonsiz),'->',(hits[jjtarg]),'   ', iisiz,'*',jjsiz);
                   except  writeln('********no word:',jjtarg);end;
                if iters=1 then if prw(i)='auto' then
                //if (prw(jjtarg)='mies') or (prw(jjtarg)='sininen') then
                //writeln('#',prw(i),'*',prw(jtarg),jsiz,'/',diags[jtarg],'_',jjtarg,prw(jjtarg),jjsiz,'/',diags[jjtarg],'! ',lonsiz,'!',(hits[jjtarg]));

             if jjtarg+9999999=i then
                       begin
                         try
                         writeln('                        ',prw(i),'*',prw(jtarg),'/',prw(jjtarg),'*');
                         writeLN('                        ','diags:',(diags[jjtarg]*diags[jtarg]) div 1000,'=','/',diags[jjtarg],'*',diags[jtarg]);// div diags[jtarg]);
                         writeLN('                        ','I:',prw(i),'/',prw(jtarg),'=',jjsiz,'/', DIAGS[jjTARG]);// div diags[jtarg]);
                         writeLN('                        ','J:',prw(jtarg),'=',jsiz,'/', DIAGS[jTARG]);// div diags[jtarg]);
                         writeLN('                        ','res:*',prw(jjTARG),'+',(lonsiz),'!',(hits[jjtarg]),^j);
                         except  writeln('********no word:',jjtarg);end;
                       end;
                       //writeln('                   ?',prw(iitarg),hits[iitarg]);
                  //     break;
               {  end;
               end;
             end; }
          end; except writeln('failed in finding/handling one third party','(',jtarg,':',iitarg,'/',diags[jtarg],'/',diags[iitarg],') ');readln;end;
          if hits[iitarg]>100000 then write('>>>',hits[iitarg],'(',jtarg,':',iitarg,') ');
       end;    except writeln('***** failed in finding commons');end;
       //writeln('X:',prw(i),prw(jtarg));
    end;
    except writeln('***failed in j (correlates of i');end;
    //cowhats[1]:=i;
    //if (i=1) or (i=2) then   writeln(i,'               XXX:',multitarg^[1,1],'=',multisiz^[1,1],':',cowhats[1]);
    //writeln;writeln;
    //writeln;

    for jj:=1 to 32 do cosizes[jj]:=0;
    for jj:=1 to 32 do cowhats[jj]:=0;
    lonsiz:=0;
    for ii:=1 to mysize do lonsiz:=lonsiz+hits[ii];
    //write(prw(i),lonsiz,'|',diags[i],'  ');
    for ii:=1 to mysize do  //sort and pick 32 biggest
    begin
       //if (prw(i)='on') //and (prw(ii)='lienee ') then
       //then writeln(^j,'ON**************',prw(ii),hits[ii],'>',hitsize);

    if (hits[ii]>0) then
    begin
      hitsize:=(10000*hits[ii]) div lonsiz;//(diags[ii]*diags[i]);
      hitsize:=hits[ii] div 1000;
      //if ii=i then
       //writeln('!',i,'/',hits[ii],',',hitsize);
       if hits[ii]>0 then
       for jj:=1 to 32  do
       begin
          if hitsize>cosizes[jj]then
          begin
            //writeln('(',prw(i),':',round(cosizes[jj]),')');//,round(diags[cowhats[jj]]),') ');
            move(cosizes[jj],cosizes[jj+1],(32-jj)*4);
            move(cowhats[jj],cowhats[jj+1],(32-jj)*4);
            cowhats[jj]:=ii;
            //if jj<>ii then
            cosizes[jj]:=hitsize;//[ii];//min(lonsiz,1000);
            //if jj<32 then if cosizes[jj]<cosizes[jj+1] then begin writeln('WWWWWWWWWWWWWWWWWWWWWW',jj);readln;end;
            //if jj>1 then if cosizes[jj]>cosizes[jj-1] then begin writeln('UUUUUUUUUUUUUU',jj);readln;end;
            break; //the saving / sorting loop
          end;
       end;
    end;
    end;
    //sum up results for one correlate of i
    lonsiz:=0;
    for jj:=2 to 32 do lonsiz:=lonsiz+cosizes[jj];
    //writeln;write(prw(i));
    for jj:=1 to 31 do
    begin
       if cowhats[jj]<1 then  break;
       multisiz^[i,jj+1]:=cosizes[jj];//(1000*cosizes[jj]) div lonsiz  ;
       multitarg^[i,jj+1]:=cowhats[jj];
    end;
    //writeln('%%%',prw(i),prw(cowhats[jj]),'=',cosizes[jj]);
    //writeln;
    lonsiz:=0;
    for jj:=1 to 32 do lonsiz:=lonsiz+multisiz^[i,jj];
    multisiz^[i,1]:=round(lonsiz);
    multitarg^[i,1]:=i;

    for jj:=1 to 31 do if cosizes[jj]<cosizes[jj+1] then writeln(jj,'WRONG:',cosizes[jj],'<',cosizes[jj+1]);


 end;
 except writeln('***failed in i');end;
  //if iters>1 then
  //writeln('O:',multitarg^[1,1],'=',multisiz^[1,1]);
  {for i:=1 to 100 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
  begin
     //if multisiz^[i,1]<1 then continue;
     write(prw(i),': ');
     for jj:=1 to 15 do if multitarg^[i,jj]<1 then continue else write(prw(multitarg^[i,jj]),multisiz^[i,jj],';');
     writeln;WRITELN;
  end;}
  writeln('iter:',iters);//readln;

  swp:=scarsizes;scarsizes:=multisiz;multisiz:=swp;
  swp:=scartargs;scartargs:=multitarg;multitarg:=swp;
  fillchar(multisiz^,32*6461*2,#0);
  fillchar(multitarg^,32*6461*2,#0);
 end;
  writeln('multiply scarec');
  assign(f,'msizes.bin');
  Rewrite (F,6461*2*32);
    BlockWrite (F,multisiz^,1);
  close (f);
  assign(f,'mtargs.bin');
  Rewrite (F,6461*2*32);
    BlockWrite (F,multitarg^,1);
  close (f);
  writeln('multiply scarec');
end;

procedure tmemtab.deps;//all kinds of stuff, most commented out. make separ funcs later, relations of word-pairs from turku.conllu-files
var line:string;wlist,reflist,olist,sent:tstringlist;i,j,jj,col,len,iref,lines,diag1,diag2:integer;
  sents:array[1..12] of tstringlist;
  w,w2,ordi,ref,res:string;
  sid:integer;wnum,wnum2,sumi,maxi,wad:longword;wnumlist:array[1..1000] of smallint;slen:smallint;
  sumz:array[1..6461] of longword;
  largest8,laddr: array[1..10] of longword;
  lp:^word;
  endsent:boolean;
  resm:array[0..19] of array[0..19] of byte;
  resad,ressiz:array[1..20] of byte;
  apui:integer;
  wi,wj:byte;
begin
getmem(scarsizes,32*6461*2);
fillchar(scarsizes^,32*6461*2,#0);
getmem(scartargs,32*6461*2);
fillchar(scartargs^,32*6461*2,#0);
mysize:=6461;//wlist.count;
mysize:=12;
//writeln('scarmu');
//scarmulti;exit;

wlist:=tstringlist.create;
for i:=1 to 20 do for j:=1 to 20 do resm[i,j]:=0;

for i:=1 to 20 do
begin
 readln(line);
 //write(line);
 if line='' THEN BREAK;
 sents[i]:=tstringlist.create;
 for j:=1 to length(line) do
 begin
  if line[j]=' ' then
  begin
    if wlist.indexof(w)<0 then wlist.Add(w);
    sents[i].add(w);
    w:='';
  end
  else   w:=w+line[j];
 end;
end;
for i:=1 to wlist.count do
 begin
  sanat[i]:=wlist[i-1];
  //writeln('*****',I,sanat[i],'_');
 end;
 writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
for i:=1 to 12 do
begin
  // write('#',sents[i].count);
   //for jj:=0 to sents[i].count-1 do write(sents[i][jj],' ');
   //writeln('**');
   for j:=0 to sents[i].count-1 do
   begin
     wi:=wlist.indexof(sents[i][j])+1;
     if wi<0 then continue;
     //write('   x');
     for jj:=0 to sents[i].count-1 do
     begin
     try
      wj:=wlist.indexof(sents[i][jj])+1;
      if wj<0 then continue;
      resm[wi,wj]:=resm[wi,wj]+1;
      //write(wi,sanat[wi],'/',wj,sanat[wj],'=',resm[wi,wj],'  ');
     except writeln('*****************');  end;
     end;
     //writeln;
   end;
end;
 writeln('--------------------------',wlist.count);
 for i:=19999 to 12 do
 begin
   //if i>=sanat.count then break else
   begin
     write(^j,i,sanat[i],':  ');
     for j:=1 to 12 do
     write(sanat[j],resm[i,j],',  ');
   end;
 end;

 for i:=1 to 12 do
begin
  //if i>=sanat.count then break else
  begin
   //writeln;
    //write(^j,i,sanat[i],';;');
    for j:=1 to 12 do
    begin
      //if j>=wlist.count then break else
      begin
        //write(' **',wlist[j],resm[i,j]);
        for jj:=1 to 12 do
          //if jj>=wlist.count then break else
          if resm[i,j]*100>scarsizes^[i,jj] then
          begin
              //write('#',sanat[j],resm[i,j]);//,'>',scarsizes^[i+1,jj+1],'/',jj,' ');
              move(scarsizes^[i,jj],scarsizes^[i,jj+1],2*(20-jj));
              move(scartargs^[i,jj],scartargs^[i,jj+1],2*(20-jj));
              scarsizes^[i,jj]:=resm[i,j]*100;
              scartargs^[i,jj]:=j;
              break;
          end;
      end;
      //writeln('***');

    end;
    for jj:=19999 to 12 do
    begin
     if scartargs^[i,jj]=0 then continue;
     //write(sanat[scartargs^[i,jj]],'/',scarsizes^[i,jj],':',jj,'  ');
     //write(wlist[scartargs^[i,jj]],scarsizes^[i,jj],' ');

    end;
    writeln;
  end;
end;
//writeln('--------------------------');

for i:=9990 to 9 do
 begin
    write(^j,'!!!!!!!***',wlist[i-1],':');
    for jj:=1 to 10 do
    begin
     write(wlist[scartargs^[i-1,jj-1]],'=',scarsizes^[i-1,jj-1],' ');
     //continue;
      if scartargs^[i,jj]=0 then continue;
      //write(wlist[scartargs^[i,jj]-1],'=',scarsizes^[i,jj],' ');
     //write(scartargs^[i+1,jj],'/',scarsizes^[i+1,jj],'/to:',jj,'  ');
     //write(wlist[scartargs^[i,jj]],scarsizes^[i,jj],' ');
    end;
    writeln;

 end;
getmem(multisiz,32*6461*2);
fillchar(multisiz^,32*6461*2,#0);
//getmem(multitarg,32*6461*2);
//fillchar(multitargs,32*6461*2,#0);


for i:=1999 to 12 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //write('#',prw(i),'*  ');//scarsizes^[i,ii],':         ');
   write(copy(prw(i),1,2), copy(inttostr(scarsizes^[i,1])+'   ',1,5),':???');
   for j:=1 to 12 do
   begin
    write(copy(prw(scartargs^[i,j]),1,2),'=',scarsizes^[i,j],' ');
   // multitarg^[i,j]:=scartargs^[i,j];
   end;
   writeln;
 end;
writeln;
scarmulti;exit;
try
for i:=1 to 12 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
  // write(copy(prw(i),1,2), copy(inttostr(multisiz^[i,1])+'   ',1,5),':???');
   //write(copy(prw(i),1,2), copy(inttostr(scarsizes^[i,1])+'   ',1,5),':');
   for j:=1 to 12 do
   begin
    apui:=scartargs^[i,j];
    multisiz^[i,j]:=((200000*scarsizes^[i,j]) div (scarsizes^[i,1]*scarsizes^[apui,1]));
    write(copy(prw(scartargs^[i,j]),1,2),'=',multisiz^[i,j],' ');
    //write(copy(prw(scartargs^[i,j]),1,2),'=',multisiz^[i,j],'/','_',scarsizes^[i,j],'/',(scarsizes^[i,j]),'*',scarsizes^[apui,1],'$',(10000*scarsizes^[i,j]) div (scarsizes^[i,1]*scarsizes^[apui,1]),'   ');
    //multitarg^[i,j]:=scartargs^[i,j];
   end;
   //writeln;
 end;
scarsizes:=multisiz;
//scartargs:=multitarg;
except writeln('staandardize failed'); end;
mysize:=wlist.count;
writeln('mutiply');
scarmulti;exit;
exit;

// getmem(sadmat,1*6461**2);
//fillchar(sadmat^,6461**2,#0);
//getmem(madmat,4*6461**2);
//fillchar(madmat^,4*6461**2,#0);
{padmat^[1,2]:=1;
padmat^[1,3]:=1;
padmat^[1,4]:=1;

padmat^[2,1]:=1;
padmat^[2,3]:=0;
padmat^[2,4]:=10;

padmat^[3,1]:=1;
padmat^[3,2]:=0;
padmat^[3,4]:=10;

padmat^[4,1]:=1;
padmat^[4,2]:=10;
padmat^[4,3]:=10;

padmat^[1,1]:=10;
padmat^[2,2]:=10;
padmat^[3,3]:=10;
padmat^[4,4]:=10;}
//mysize:=4;
{makematrix;
assign(f,'mat.bin');
  Rewrite (F,4*6461**2);
    BlockWrite (F,padmat^,1);
  close (f);
 exit;
 }
{for i:=1 to mysize do
  for j:=1 to mysize do
   if padmat^[i,j]>255*255 then write(prw(i),'/',prw(j)) else
    sadmat^[i,j]:=round(sqrt(padmat^[i,j]));
    //if padmat^[i,j]>255*255 then write(prw(i),'/',prw(j)) else
    // sadmat^[i,j]:=round(sqrt(padmat^[i,j]));
//mysize:=300;}
maxi:=0;
for i:=1 to mysize do
   begin
      for j:=1 to mysize do
       begin
        sadmat^[i,j]:=round(16*ln(padmat^[i,j]+1));
        if maxi<=padmat^[i,j] then writeln(prw(i),'/',prw(j),sadmat^[i,j],'<-',padmat^[i,j],'.',round(ln(padmat^[i,j]+1)*16));
        maxi:=max(maxi,padmat^[i,j]);
       end;
      //writeln('max:',maxi);
   end;
  assign(f,'smat.bin');
  Rewrite (F,6461**2);
    BlockWrite (F,sadmat^,1);
  close (f);
writeln(round(16*ln(2491406)));
writeln;

exit;
multimat;
  assign(f,'mulmat.bin');
  Rewrite (F,4*6461**2);
    BlockWrite (F,madmat^,1);
  close (f);

 maxi:=0;
 for i:=1 to mysize do
    begin
       for j:=1 to mysize do
       write(madmat^[i,j],' ');//div padmat^[i,i]
       //write(madmat^[i,j] div (padmat^[i,i]*padmat^[j,j]),' ');//div padmat^[i,i]
       writeln;
    end;
 writeln;
 writeln;
 for i:=1 to mysize do
    begin
       for j:=1 to mysize do
       write((madmat^[i,j]**2) div (madmat^[j,j]*madmat^[i,i]), ' ');
       //write(madmat^[i,j] div (padmat^[i,i]*padmat^[j,j]),' ');//div padmat^[i,i]
       writeln;
    end;
{        write(madmat^[i,j],' ');
        writeln;
        //writeln(i,'. ',prw(i),'  ',madmat^[i,i],' ');
       for j:=1 to mysize do
       begin
        write(madmat^[i,j],' ');
         for jj:=1 to mysize do
          begin
           //madmat^[i,j]:=madmat^[i,j]+round(sqrt(padmat^[i,jj]*padmat^[j,jj]));
           //madmat^[i,j]:=madmat^[i,jj]*padmat^[j,jj];
           //write(madmat[i,j
           //if madmat^[i,j]+1>=2**32 THEN BEGIN WRITELN('XXXXXXXXXXXXXXXXXXX');END;
          end;
          //if madmat^[i,j]<>0 then write(' ',madmat^[i,j]) else write('   ');

       end;
       //writeln;
      end;
      end;}
 exit;
    assign(f,'matmul.bin');
     Reset(F,4*6461**2);
       Blockread (F,madmat^,1);
        close (f);
{  for i:=1 to mysize do
      begin
       writeln(i);
       for j:=1 to mysize do
         if madmat^[i,j]>0 then write('  ',madmat^[i,j]);
       writeln;
       writeln;
      end;
  exit;
 }//   if 0=1 THEN
 {   for i:=1 to mysize do
    begin
     diags[i]:=madmat^[i,i];
     sumz[i]:=0;
     if diags[i]> 0 then
     for j:=1 to mysize do if i<>j then sums[i]:=sums[i]+madmat^[i,j];
     //if sums[i] div diags[i]<2 then
     write(diags[i],' ', sums[i],' ');
     writeln('    ',prw(i),i);
    end;
    for i:=1 to mysize do
      begin
       //for jj:=0 to 15 do if byte((wstackp+(i-1)*16+jj)^)<>0 then write(ansichar((wstackp+(i-1)*16+jj)^)) else write('_');

       writeln(prw(i),padmat^[i,i],':');
       for j:=1 to mysize do
         //for j:=i to i do
           if padmat^[i,j]>0 then
           begin
             write(10000*(padmat^[i,j]) div (padmat^[j,j]*padmat^[i,i]+1),' ');

           end;
          writeln('*********************');
      end;
          //for j:=1 to mysize do prw(j);
          //writeln(padmat^[3,3],' ');
   // exit;
          writeln('start listing');
 // madmat:=padmat;
 0+\}
 for i:=1 to mysize do  //get 10 largest coocs for each word ... brutishly
    begin
     for jj:=1 to 10 do largest8[jj]:=0;
     for jj:=1 to 10 do laddr[jj]:=0;
     //for jj:=0 to 15 do if byte((wstackp+(i-1)*16+jj)^)<>0 then write(ansichar((wstackp+(i-1)*16+jj)^)) else write('_');
     //writeln;
     //write(prw(i),madmat^[i,i],':');;
     maxi:=0;sumi:=0;
     for j:=1 to mysize do
     begin //if j mod 10=0 then write('#');
      //if padmat^[i,j]<3 then continue;

      //if madmat^[i,j]<1 then wnum:=0 else
        //wnum:=10000*padmat^[i,j]**2 div ((padmat^[i,i]+1) * (padmat^[j,j]+1));
        //wnum:=10000*padmat^[i,j] div ((padmat^[j,j]));
      //wnum:=padmat^[i,j];
      //wnum:=madmat^[j,j];
      try
      //if i<>j then begin     maxi:=max(maxi,madmat^[i,j] div 1000);sumi:=(madmat^[i,j] div 1000)+sumi; end;
      //if (madmat^[j,j]>1) and (madmat^[i,i]>1) then
      wnum:=madmat^[i,j];
      //wnum:=10000*(madmat^[i,j] div (padmat^[j,j]+1))
      //wnum:=10000*(madmat^[i,j]**2) div (1+(madmat^[j,j]))//*madmat^[i,i])) //+padmat^[i,j]**2 div padmat^[j,j]
      //else wnum:=0;
      //write(madmat^[i,j],'/',wnum,' ');
      except writeln('****************xxx*****************');end;
      //if wnum>0 then writeln('    ',wnum , '   ',prw(j),' _ ', madmat^[i,j],' ',madmat^[j,j],' ');
        //wnum:=1000* padmat^[i,j] div (padmat^[j,j]+1);
        //if j<10 then write('(',wnum,' ',madmat^[i,j],' ',madmat^[i,i],' ',madmat^[j,j],')' );
        for jj:=1 to 10 do
          //
          //if wnum>20 then
          if largest8[jj]<wnum then
           //if largest8[jj]
          begin
           //write(prw(j),'_');
           move(largest8[jj],largest8[jj+1],(10-jj)*4);
           move(laddr[jj],laddr[jj+1],(10-jj)*4);
           largest8[jj]:=wnum;
           laddr[jj]:=j;
           break; //the larg8 loop
          end;
     end;
     //for jj:=0 to 15 do if byte((wstackp+(i)*16+jj)^)<>0 then write(ansichar((wstackp+(i)*16+jj)^)) else write('_');
     //res:=prw(i)+': ';//
     writeln;
     write(prw(i),'(',maxi,' ',sumi, '): ');//,padmat^[i,i],': ');

     for j:=1 to 10 do
     begin
        //if largest8[j]<1 then break;
        wnum:=laddr[j];
        //write(wnum);
        if wnum<1 then continue;//break;
         //if (wnum=3219) or (wnum=3218) or (wnum=3217)then writeln('**************',wnum);
         //for jj:=0 to 8 do if byte((wstackp+(wnum)*16+jj)^)<>0 then write(ansichar((wstackp+(wnum)*16+jj)^)) else break;
         //IF largest8[j]>50 THEN
       //  res:=res+prw(wnum)+' ';
         write(prw(wnum),' ',largest8[j],' ');//,madmat^[i,wnum],'<-',madmat^[wnum,wnum],'<-',madmat^[i,i], '=',largest8[j],' ');
       //write('{',padmat^[i,i],'/',padmat^[wnum,wnum], '=',padmat^[i,wnum],'}  ');
     end;
     writeln;
     writeln;
     //if length(res)>8 then writeln(res);
    end;

end;


  function tmemtab.addstring:boolean;  //strings come in sorted order, just place then on top of stack
   var t,s,ff:pointer;i,len:longword;curw:^wl8;ch:ansichar;
  begin
      ff:=wstackp+(16*stacktop);
      stacktop:=stacktop+1;
      s:=@curword;//str+1;
      move(s^,ff^,cwlen);
      //for i:=0 to 15 do begin ch:=(ansichar((f+i)^));  if ch=#0 then write('_') else write(ch);end;
      //writeln;
  end;
type w16=array[0..15] of char;

 function tmemtab.findstring(wrd:string):smallint;
 var midw,curw:^w16;i,ilet:byte;hit,hitting:boolean;sma,smi:longword;len:byte;ch:char;
 begin
  try
    result:=-1;
    //write('\',self.stacktop,'\');
    if self.stacktop=0 then begin self.lasthit:=0;self.placebefore:=true;exit;end;
    self.lasthit:=self.stacktop div 2;
    sma:=self.stacktop;smi:=0;
    //writeln;
          //            if wrd='sininen' then  writeln('_____',copy('('+wrd+')_________________________',1,16));
    hitting:=false;
    if self.stacktop>0 then
    repeat
      //writeln;
      if sma<=smi then break;
      self.lasthit:=sma-((sma-smi) div 2);
      //write('  try:',lasthit);
      if self.lasthit<1 then break;
      self.lasthit:=self.lasthit-1;
      curw:=self.wstackp+(16*self.lasthit);//nextstep:=lasthit div 2;
      hit:=true;
      len:=length(wrd);
      //write(curw^[ilet],wrd[ilet],'-');
      //write('(',len,')');
      //if wrd='sininen' then  begin  write(lasthit,'#');  for i:=0 to 15 do begin if curw^[i]=#0 then write('-') else write(curw^[i],'');end;end;

      for ilet:=1 to len do //begin  //write(curw^[ilet],'=',curstr[ilet],'?');
      begin
         ch:=curw^[ilet-1];//if ch=#0 then begin hit:=false;exit;end;
         //if ch:=# then break;
         //write('/',ilet,ch,'_',wrd[ilet],'\');
       //if wrd='sininen' then         writeln('    tryhit:',lasthit,(wrd[ilet]),ansichar(curw^[ilet-1]),placebefore,'!',ilet,'/',len,(curw^[ilet-1]<>wrd[ilet]));
        if  (curw^[ilet-1]<>wrd[ilet]) then
         begin hit:=false;self.placebefore:=curw^[ilet-1]>wrd[ilet];
           break
        end;
      end;
      //if wrd='sininen' then      writeln('    goon?:');//,len,hit,'!',curw^[len]<>#0,ilet);
      if (hit) and (len<16) and (curw^[len]<>#0) then begin hitting:=true;placebefore:=true;hit:=false;end;
      if hit then
       begin //writeln('HITHITHIT');
        result:=lasthit+1;exit;
       end;
      if self.placebefore then
      begin
        sma:=self.lasthit;
      end else
       smi:=self.lasthit+1;
    until false;//lasthit>=stacktop;

  except writeln('*************************');
  end;
 end;

  function tmemtab.readl:boolean;
        var ch:byte;i:byte; w:string;
        begin
        fillchar(curword,16,0);
        result:=true;
        try
        cwlen:=0;
        while fstr.read(ch,1)=1 do
        begin
          if fstr.size<fstr.position+1 then begin result:=false;break;end;
          //write('!',ansichar(ch));
          if (ch=10) then  exit;
          if ch=13 then continue;  //skip CR
          if cwlen>=16 then continue;
          curword[cwlen]:=(ch);
          cwlen:=cwlen+1;
          //w:=w+ansichar(ch);
        end; except   writeln('nogo____________',result);end;
       // readln;
       end;

  constructor tmemtab.create(wl,siz:integer);
  var i,j,k,w:integer;pc:^ansichar;  smeme:cardinal;ch:byte;lcoun:integer;
    swpt,swps:^tscarcemat;

  begin
    lcoun:=0;
    mysize:=siz;
    smeme:=getheapstatus.totalfree;
    cwlen:=wl;  //maybe later separate stack for sep lengths
    getmem(wstackp ,cwlen*(siz));
    fillchar(wstackp^,(cwlen)*siz,#0);
    STACKTOP:=0;
    fstr:=tfilestream.create('sanat.iso',fmopenread);
    try
    while fstr.read(ch,1)=1 do
    begin
      if fstr.size<fstr.position+1 then begin break;end;
      //write('!',ansichar(ch));
      if (ch=10) then  begin lcoun:=lcoun+1;cwlen:=0;continue;end;
      if ch=13 then continue;  //skip CR
      if cwlen>=16 then continue;
      sanat[lcoun]:=sanat[lcoun]+ansichar(ch);
      cwlen:=cwlen+1;
    end; except   writeln('noreadgo____________');end;

    writeln('readx');
    getmem(scarsizes,32*6461*2);
getmem(scartargs,32*6461*2);
getmem(multisiz,32*6461*2);
getmem(multitarg,32*6461*2);
  assign(f,'scsizes.bin');
  Reset (F,6461*2*32);
    Blockread (F,scarsizes^,1);
  close (f);
  assign(f,'sctargs.bin');
  Reset (F,6461*2*32);
    Blockread (F,scartargs^,1);
  close (f);

    //for i:=1 to mysize do write(i,sanat[i],'|');
   fstr.free;
   for i:=2222 to 10 do
   begin
     try
      write(^j,^j,prw(i),':  ');
      for j:=1 to 32 do
       write(prw(scartargs^[i,j]),' ');
     except end;

   end;
   //makescar;
   for i:=1 to 5  do
   begin
     fillchar(multitarg^,32*6461*2,#0);
     fillchar(multisiz^,32*6461*2,#0);
   iter;
   //writeln('did*');
   if i=5 then
   for j:=1 to mysize do
   begin
     try
      write(^j,^j,prw(j),':  ');
      for k:=1 to 32 do
      if multisiz^[j,k]>20 then
       write(prw(multitarg^[j,k]),' ');
     except end;

   end;
   swpt:=scartargs;
   swps:=scarsizes;
   scartargs:=multitarg;
   scarsizes:=multisiz;
   multitarg:=swpt;
   multisiz:=swps;
   writeln('did*');
   end;
   //deps;
   //dosims;
 exit;
    w:=0;
    repeat
       if fstr.size-fstr.position<1 then break;
       readl;
       if (cwlen<3) or (cwlen>16) then continue;
       w:=w+1;
      // writeln(w,'=',prw(w));
       try
       addstring;
       except write(w,'---------------------------- ');end;
   until false;
    fstr.free;
   //for i:=0 to stacktop do writeln(i,' ',prw(i));
   deps;
   exit;
     writeln('sdone',stacktop);
     for i:=0 to stacktop do begin
      for  j:=0 to 15 do  //pc:=(wstackp+1)^;
      write('',ansichar((pointer(wstackp)+(i*16)+j)^));
      writeln('-');
      end;exit;
     fstr:=tfilestream.create('sanat.iso',fmopenread);
     i:=0;
     for i:=0 to stacktop do begin
      for  j:=0 to 15 do  //pc:=(wstackp+1)^;
      write('',ansichar((pointer(wstackp)+(i*16)+j)^));
      writeln('-');
      end;


      end;




procedure cleanpoems;
var infst,outfst:tfilestream;ssr: tsearchrec;ch:ansichar;
  thisline,firstline,runoline:ansistring;promising,runo:boolean;
  inlines:longword;
  lines,longuni,emptylines,oldies,indents,shorts:integer;
  j:integer;
  apar:tstringlist;
  function readpar(fs:tfilestream):boolean;
  var ch:byte;lf1:boolean;line:ansistring;
  begin
    result:=true;
    lf1:=false;
    apar.clear;
    INDents:=0;
    try
    line:='';lines:=0;shorts:=0;indents:=0;longuni:=0;
    while fs.read(ch,1)=1 do
    begin
      //write('*',ch);
     //debugst:=debugst+letters[chrcodes[ch]]+inttostr(chrcodes[ch]);
      if fs.size<fs.position+2 then begin result:=false;break;end;
      if (ch=10) then
      begin
           if line<>'' then
           begin
             //WRITE(APAR.TEXT+'!');
              if length(trim(line))>60 then
                if line[1]<>' ' then
                longuni:=longuni+1;
              if pos(' ',line)=1 then indents:=indents+1;
             lines:=lines+1;if length(line)< 60 then shorts:=shorts+1;
             apar.add(line);line:='';
           end;
           if lf1 then exit else lf1:=true;
           CONTINUE;
      end;
      if ch=13 then continue;  //skip CR
      //if chrcodes[ch]>30 then writeln('!!!!!!!!!!!!!!!!!!!!!!!!') ;
      line:=line+ansichar(ch);
      lf1:=false;
    end;
      except   writeln('____________',result);end;
  end;
var alen:integer;lcont:boolean;
begin
    apar:=tstringlist.create;
  infst:=tfilestream.create('/home/t/fingut/txt/runot.raw',fmopenread);
  while readpar(infst) do
  begin
    if apar.count<3 then continue;
    //if (lines>shorts) and     //at least one long line
   //(lines-indents>1) then //more than 1 non-indented lines
    if longuni>1 then
    else
    begin
    if lines>1 then
      begin
        lcont:=false;
        for j:=0 to lines-1 do
        begin
          try
          runoline:=trim(apar[j]);
          if runoline='' then continue;
          stringreplace(runoline,'"','', [rfReplaceAll]);
          if lcont  then runoline:=ansilowercase(runoline[1])+copy(runoline,2,9999);
          lcont:=false;
          if pos(runoline[length(runoline)],'.!?;')>0 then
           write(runoline+' ')
          else begin write(runoline+' ');lcont:=true;end;
          except on e:exception do begin writeln('***************************************',j,e.message,lines);
            readln;end;
          end;
        end;
        writeln;
     end

    ;//    else
    //writeln(apar.t ext,^j);
    writeln;

    end;

  end;

end;

procedure gutpoems;
var infst,outfst:tfilestream;ssr: tsearchrec;ch:ansichar;
  thisline,firstline,runoline:ansistring;promising,runo:boolean;
  inlines:longword;
  lines,emptylines,oldies,indents,shorts:integer;
  j:integer;
  abook:tstringlist;
  function readhead:string;
  begin
  runo:=false;
  while readl(infst,thisline) do
  begin
    if  (pos('n�ytelm',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
    if  (pos('n�yt�k',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
    //if  (pos('runo',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
   // if  (pos('satu',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
    //if  (pos('tarinoi',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
    //if  (pos('LAULU',ansilowercase(thisline))>0) then begin runo:=true;end;//writeln('MUKAAN:',thisline);end;
    //if (pos('w',ansilowercase(thisline))>0) and (pos('title',ansilowercase(thisline))>0) then writeln('***',thisline);
    //if (pos('x',ansilowercase(thisline))>0) and (pos('title',ansilowercase(thisline))>0) then writeln('***',thisline);
    //if  (pos('***',thisline)=1) then writeln(thisline,'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
  if  (pos('***',thisline)=1) then if pos('start',ansilowercase(thisline))>0 then BEGIN break;END;
  inlines:=inlines+1;
  if inlines>150 then break;
  end;

end;
procedure stats;
begin
 try
 //if (shorts div en
 if lines div shorts >2  then exit;
 if runo then exit;
// writeln('lines:',lines,'  /empty:',lines div emptylines,'  /shorts:',lines div shorts,'  /oldies:', oldies,'  /inds:',lines div indents);
 //writeln('  /shorts:',lines div shorts)
 writeln(^J,'*******************************',^j,ssr.name,'  ',firstline,abook.text,^j);
 //writeln(ssr.name,'  ',firstline);
 //readln;
 except writeln('no stats');end;
end;

begin
 abook:=tstringlist.create;
//outfst:=tfilestream.create('runot.all',fmcreate);
 if FindFirst('/home/t/fingut/txt/*.txt',   faAnyfile,   ssr) = 0 then
 repeat
    //writeln(ssr.Name,'xxxxxxxxxxx');
    try
    if ssr.name='7v.txt' then continue; //7 veljest� oli v�h�n eri muotoinen k�sin editoinnin j�ljilt�
    promising:=false;runo:=false;
    infst:=tfilestream.create('/home/t/fingut/txt/'+ssr.Name,fmopenread);
    try
    if not readl(infst,firstline) then continue;
    promising:=pos('runo',ansilowercase(firstline))>0;
    inlines:=0;
    readhead;
    inlines:=1;
//     if not runo then continue;
     //writeln(ssr.Name,' :', firstline);
    //WRITELN;WRITELN;
    //continue;
    lines:=1;emptylines:=1;oldies:=1;shorts:=1;indents:=1;
    abook.clear;
    while readl(infst,thisline) do
    begin
      if lines<50 then if pos('n�ytelm�',ansilowercase(thisline))>0 then runo:=true;
      //if length(thisline)=0 then write('000000') else
      //if length(trim(thisline))=0 then write('1111111111');
       inlines:=inlines+1;
        //if pos('w',ansilowercase(thisline))>1 then writeln('***',thisline);
      if (pos('***',thisline)=1) or (pos('End of ',thisline)=1) then begin //writeln('xxxxxxxxxx');
        stats;break;end;
      if length(trim(thisline))<5 then emptylines:=emptylines+1
        else begin  if thisline[1]=' ' then indents:=indents+1;
       if length(trim(thisline))<50 then shorts:=shorts+1;end;
        lines:=lines+1;
      //if (inlines>500) and (inlines<550) then
      abook.Add(thisline);
      //for j:=1 to length(thisline) do if pos(thisline[j],'xzcw')>0 then oldies:=oldies+1;
       //writeln(thisline,^J);
       //if inlines>5 then break;
    end;
    finally infst.free;end;

    except on e:exception do
      writeln('failed file ',ssr.name,e.message);
    end;
 until (FindNext(ssr) <> 0);
 findclose(ssr);

end;

type ap24=array[0..2] of byte;pap24=^ap24;


type node32=packed record
 w: array[1..32] of ap24;  //96 bytes
 isword: b32;
 isshort: b32;
 id: longword;  //4

 end;     //96+4+4+2=108;
type node1=packed record
 child:  ap24;  //3 byte pointer to child
 letter:byte;  //1 .. 5 bits will do, so this can be packed with the following bits
 isword: boolean;
 isshort: boolean;
 //id:longword;
 end;     //5 bytes?;
 type node1p=^node1;
type  node32p=^node32;
type  longstack=array[0..65534*32] of node32;

 function IntToBinStr(AInt : LongWord) : string;
 begin
   Result := '';
   repeat
     Result := Chr(Ord('0')+(AInt and 1))+Result;
     AInt := AInt div 2;
   until (AInt = 0);
 end;
VAR    words,nodescount,tails:array[0..32] of integer;  //to get some stats, not required for functioning
type ta6=array[1..6] of  byte;tpa6=^ta6;

function partition(A:tpa6; lo, hi:longword): longword;
var tmp:ta6;tmpp:tpa6;i,j:longword;pivot:byte;
procedure swap(x,y:longword);
begin
 move(a^[x],tmp,6);
 move(a^[y],a^[x],6);
 move(tmp,a^[y],6);
end;

begin
     pivot := A^[hi];
     i := lo;        // place for swapping
     for j := lo to hi-1 do
         if A^[j] < pivot then
             swap(i,j);
             i := i + 1;
     swap(i,hi);
     result:=i;
end;

procedure quicksort(A:tpa6; lo, hi:longword);
var p:longword;
begin
    if lo < hi then
    begin
        p := partition(A, lo, hi);
        quicksort(A, lo, p-1);
        quicksort(A, p + 1, hi);
    end;
end;

procedure listnode(nodenum:longword;stack:pointer;ind:string);
 var i,j:integer;//db:string;
   n:^node32;
  nex:longint;//tr:^tstack;ns:integer;nn:trienode;np:^trienode;
  wrd,nds:integer;
begin
  //tls:=0;
  nds:=0;
  n:=stack+sizeof(node32)*nodenum;
for i:=0 to 31 do
begin
   if (n^.w[i][0]>0) or (n^.w[i][1]>0) or (n^.w[i][2]>0)then     //not all zeroes
   begin
     nds:=nds+1;
     nex:=n^.w[i][0]+(256*n^.w[i][1])+256*256*(n^.w[i][2]);
     //if nds>0 then
       listnode(nex,stack,ind+letters[i]);
     ;//else
     //db:=db+(letters[i+1]);
   end; //else writeln('-',letters[i+1],n[i][0]+(256*n[i][1])+256*256*(n[i][2]));
   if n^.isword[I]=true THEN  //if nds=1 then
   writeln(ind,letters[i]);// else
end;
//writeln;
if nds>0 then nodescount[nds-1]:=nodescount[nds-1]+1;
// writeln(nds,'!');
end;
procedure dotrie;
var
fst:tfilestream;
  stack32:^node32;
  stack1:^node1;
  this32,prev32:^node32;
  this1,prev1:^node1;
  wrd:w32; wrdlen:byte;//array of cipohered chars read from stream, and its length;
  curletter:byte; //ord pos in current word
  top1,top32:integer;
  nextshort,prevshort:boolean;
  nexp24:ap24;
  step:longword;
  w_of6:tpa6;
  w6_top:longword;
  thisa6:ta6;
  nodes1, words1,nodes32,words32:longword;//array 1..32 of longword;
  singles,multis:array[1..32] of longword;
 function a24toint(p:ap24):longword;
 begin result:=p[0]+256*p[1]+256*256*p[2]end;
 function list32(cnode:node32;inde,stem:shortstring;pp,len:longword):string;forward;
PROCEDURE GET32;FORWARD;

 procedure debug;
 VAR I,J:BYTE;
 begin
  writeln('***************************************************');

   for j:=0 to top32 do
   begin
   for i:=1 to 5 do write('_',(stack32+j)^.w[i][0],(stack32+j)^.isshort[i],(stack32+j)^.isword[i],'_');//letters[i],'-');
   writeln;end;
   for i:=1 to top1 do write(' !',i, letters[(stack1+i)^.letter],  (stack1+i)^.isshort,  (stack1+i)^.isword,  (stack1+i)^.child[0],'! ');
   writeln;
   writeln('***************************************************');

 end;
 procedure save6(w:shortstring);
 var ppp:pointer;w6p:pointer;
 begin
     ppp:=@w;
     w6p:=w_of6+w6_top;
     move((ppp+1)^,(w6p)^,6);
     //for j:=0 to 5 do write('_',ansichar(byte((w6p+j)^)));
     //writeln('**',apu);
     w6_top:=w6_top+1;
 end;

 function list1(cnode:node1;inde,stem:shortstring;pp,len,ones:longword):string;
 var p:longword;j,ws:byte;apu:shortstring;marker:char;
 begin
 p:=a24toint(cnode.child);
 ws:=0;
 //writeln(cnode.letter);
 //writeln('-',cnode.letter,cnode.isword,cnode.isshort,p);
 //inde:=inde+letters[cnode.letter];
 {if len=5 then
 begin
    //writeln(inde,stem,letters[cnode.letter],'.');
     save6(stem+letters[cnode.letter]);
 end;}
   if cnode.isword  then  begin ws:=ws+1;writeln(stem,letters[cnode.letter]);
     words1:=words1+1;marker:='!' end else marker:=' ';
   nodes1:=nodes1+1;
   singles[ones]:=singles[ones]+1;
   //writeln(inde,letters[cnode.letter],marker);//,'_',pp);
 if p>0 then
 begin
   //writeln(inde,letters[cnode.letter]);
   if cnode.isshort then list1((stack1+a24toint(cnode.child))^,inde+'.',stem+letters[cnode.letter],p,len+1,ones+1) else
   list32((stack32+a24toint(cnode.child))^,inde+'.',stem+letters[cnode.letter],p,len+1);
   //writeln(inde,'//!');

 end else// writeln(inde,'--------------------------');
 end;

 function list32(cnode:node32;inde,stem:shortstring;pp,len:longword):string;
 var i,j,ws:byte;p:longword;marker:char;
 begin
  ws:=0;
   //write(inde, pp,'_');
   for i:=0 to 31 do
   begin
    p:=a24toint(cnode.w[i]);
    if p=0 then continue;

    {  if len=5 then
     begin
    //writeln(inde,stem,letters[cnode.letter],'.');
     save6(stem+letters[i]);
      end;
     }
     //tmp remove ...WRITING IS THE RESULT if len=6 then writeln(inde+stem+letters[i],'|');
    if cnode.isword[i]  then  begin ws:=ws+1; writeln(stem,letters[i]);
      words32:=words32+1;marker:='!' end else begin ws:=ws+1;marker:=' ';end;
    nodes32:=nodes32+1;
//    writeln(inde+letters[i],marker);//,i,'/',cnode.w[i][0],cnode.isshort[i]);
    if cnode.isshort[i] then list1((stack1+p)^,inde+'|',stem+letters[i],p,len+1,1) else
     list32((stack32+p)^,inde+'|',stem+(letters[i]),p,len+1);
    //iteln(inde,letters[i]);
   end;
   multis[ws]:=multis[ws]+1;
   if ws>10 then writeln(stem,ws);
 end;
 procedure expand;
 var ch,i,j:byte;isword,isshort:boolean;
 begin    //'allocate' node1
 //writeln(prevshort,'_____________________new:',letters[wrd[curletter]], '/old:',letters[this1^.letter],'/',curletter,wrdlen,'@',this1^.child[0]);
 //debug;
 top32:=top32+1;
 this32:=(stack32+top32); //creted new node32
 ch:=this1^.letter;  //the
 //writeln('^*******',letters[wrd[curletter]], letters[ch],curletter,wrdlen,'@',this1^.child[0]);
 this32^.w[ch]:=this1^.child;
 this32^.isword[ch]:=this1^.isword;
 this32^.isshort[ch]:=this1^.isshort;
 //debug;
 if prevshort then
 begin
   //writeln('\\\\\\SHORT',prev1^.letter,top32,':',prev1-stack1);
   move(top32 ,prev1^.child,3);
   prev1^.isshort:=false;
 end
 else
 begin
  //writeln('///////LONG',prev32^.w[wrd[curletter-1]][0]);
  move(top32 ,prev32^.w[wrd[curletter-1]],3);
  prev32^.isshort[wrd[curletter-1]]:=false;

 end;
//debug;
 prevshort:=false;
// writeln('EXPANDED_________________________________________________');
 end;




 procedure get32;
 var i:byte;
 begin
   step:=0;
   nexp24:=this32^.w[wrd[curletter]];
   // writeln;
   //writeln('+NODE32:      ',letters[wrd[curletter]],'=',nexp24[0],prevshort,this32-stack32);

   if (nexp24[0]=0) and (nexp24[1]=0) and (nexp24[2]=0) then
   begin    //'allocate' node1
    //write('+++++++++++');
    top1:=top1+1;
    move(top1,this32^.w[wrd[curletter]],3);
    this32^.isshort[wrd[curletter]]:=true;
    nextshort:=true;
    this1:=(stack1+top1);
    this1^.letter:=wrd[curletter+1];
    this1^.isshort:=true;
    nextshort:=true;
   end
   else
   begin
     //write('.............:',wrd[curletter]);
     step:=nexp24[0]+256*nexp24[1]+256*256*nexp24[2];
     nextshort:=this32^.isshort[wrd[curletter]];
     if nextshort then this1:=(stack1+step) else this32:=(stack32+step);
     //if nextshort then WRITE('S:',THISiSsHORT,this1-stack1) else WRITE(THISisSHORT,this32-stack32);

   end;
   //previsshort:=false;
   //thisisshort:=false;
   prev32:=this32;
   //writeln(nextshort,'------->',step,'/',top1,'] ',prev32-stack32);
 end;

procedure get1;
  var ch:byte;//apu:longword;
  begin
   //writeln;
   //writeln('SHORT((',this1-stack1,'/',this1^.child[0],prevshort);
   nexp24:=this1^.child;
   step:=nexp24[0]+256*nexp24[1]+256*256*nexp24[2];
   //write(letters[this1^.letter],'=',letters[wrd[curletter]],' ',this1^.letter=wrd[curletter],'/sh: ',this1^.isshort,step,'   ');

   //if this1^.letter<>wrd[curletter] then  //we gotta replace the preceding node1 with a node32
   // expand   else
   begin//we are on the right path
     //write('==>',step,this1^.isshort,this1-stack1);
     if step=0 then
     begin    //prth ends,'allocate' node1
       //write('+one:');
       top1:=top1+1;
       move(top1,this1^.child,3);
       this1^.isshort:=true;
       nextshort:=true;
       prev1:=this1;
       this1:=(stack1+top1);
       this1^.isshort:=true;
       this1^.letter:=wrd[curletter+1];
       //write(' nn:',top1,this1^.isshort);
       //for i:1 to
     end else
     begin
         //write('stepfrom', this1-stack1,'(',this1^.letter,this1^.isshort,')/by:',step);
         //if letters[this1^.letter]='t' then writeln('___________________--***************************',letters[prev1^.letter]);
         //thisisshort:=this^.isshort[wrd[curletter]];
         //step:=step+1;
         nextshort:=false;
         prev1:=this1;
         if this1^.isshort then begin nextshort:=true;this1:=stack1+step; end else this32:=(stack32+step);
          //this1:=(stack1+step);
         //write('gotto:',this1-stack1,'(',this1^.letter,nextshort,this32-stack32,')');
      end;
   end;
   //writeln('/long:',top32,'/short:',top1,'))))',this1-stack1);
   prevshort:=this1^.isshort;
  end;




type pbyt=^byte;
   var i:byte;  byt:pbyt;
var j:longword;wrd6s,wrd6b:tstringlist;st:string;wc:longword;

procedure writeword;
var i:integer;
begin
    for i:=0 to wrdlen-1 do write(letters[wrd[i]]);
    writeln(this32-stack32,'/',this1-stack1);
end;

begin
nodes1:=0; words1:=0;nodes32:=0;words32:=0;
wrd6s:=tstringlist.create;
wrd6b:=tstringlist.create;
for i:=1 to 32 do write(i,'=',letters[i],'.');
for i:=1 to 32 do singles[i]:=0;
for i:=1 to 32 do multis[i]:=0;
{for i:=1 to 32 do write(letters[chrcodes[ord(letters[i])]],'.');
 writeln;
//fst:=tfilestream.create('/home/t/turku/pienb.txt',fmopenread);
for i:=1 to 32 do write(ord(letters[i]),ansichar(letters[i]),'-');
 writeln;
 exit;}
 //fst:=tfilestream.create('/home/t/turku/isosanat.lst',fmopenread);
 fst:=tfilestream.create('kaikki.wlst',fmopenread);
getmem(stack32,sizeof(node32)*2**20);
fillchar(stack32^,sizeof(node32)*2**20,0);
getmem(stack1,sizeof(node1)*2**24);
fillchar(stack1^,sizeof(node1)*2**24,0);
getmem(w_of6,6*2**24);  //words of length 6
fillchar(stack1^,6*2**16,0);
top1:=0;top32:=0;
//stack32^.w[4][0]:=7;
//byt:=pbyt(stack32);
//byt^:=123;
//writeln('b',@byt-stack32);
wc:=0;
while readw(fst,wrd,wrdlen) do  //insert into trie
begin
 wc:=wc+1;
 //if (wrd[0]=1) and (wrd[1]=1) and (wrd[2]=1) then
 //if wc<20 then
 //begin writeln(' IN LINE:', wc);for i:=0 to wrdlen-1 do write(letters[wrd[i]]);end;
     //writeword;
     if wrdlen=0 then continue;
     if wrd[0]=0 then continue;
     {if wrdlen=6 then
     begin st:='';write('');for i:=0 to 5 do st:=st+(letters[wrd[i]]);wrd6s.add(st);write('');
      if (wrd[0]=3) and (wrd[1]=23) then begin for i:=0 to 5 do write(letters[wrd[i]]);writeln(' IN LINE:', wc);end;
     end;}
     //if wc=10000 then
     this32:=stack32;
     //writeln('***',int64(@this32-stack32),'/:',int64(@this32),'/',int64(stack32));
     //for i:=0 to 4 do write(this32^.w[i][0],this32^.isshort[i],'_');//letters[i],'-');
     nextshort:=false; //rootnode is node32
     curletter:=0;
     prevshort:=false;
     while curletter<wrdlen-1 do
     begin
          //writeln;
          //writeln('NEWLERRER',prevshort,nextshort,'  ',curletter, letters[wrd[curletter]]);
          //previsshort:=nextshort;
          //write(curletter,'/',wrdlen,letters[wrd[curletter]]);
          //if nextshort then writeln('get1')  else writeln('get32');
          if nextshort then
          begin
             if this1^.letter<>wrd[curletter] then begin expand;get32;prevshort:=false; end
             else begin get1;prevshort:=true;end;
          end
          else begin get32;prevshort:=false;end;
       curletter:=curletter+1;
       //writeln;writeln;
       {begin
         //wrd[curletter]];
       end;// else
       if not(thishort) then
       begin
         nextshort:=this32.sshort
      }
    end;
    curletter:=wrdlen-1;
    //writeln('END>>>>>>>>>>>;',nextshort,this1^.isword, letters[this1^.letter],letters[wrd[wrdlen-1]]);
    if (nextshort) and (this1^.letter=wrd[wrdlen-1]) then begin  this1^.isword:=true end
    else begin if nextshort then begin expand;end; this32^.isword[wrd[wrdlen-1]]:=true;end;
    //debug;
    //writeln(':::',top32,'/',top1,'/',int64(this32-stack32),^j);
     //*sizeof(this32)-stack32),^j);
   //  writeln(top1,'didword****************************************************************************');

 end;
 //readln;
 //exit;
 w6_top:=0;
 list32(STACK32^,'','',0,0);
 //writeln('**********************',w6_top,'*');
// exit;
{ for j:=1 to (w6_top) do
 begin
  try
    st:='';
    thisa6:=(w_of6+j)^;
    for i:=1 to 6 do write(ansichar(thisa6[i]));
    for i:=1 to 6 do st:=st+(ansichar(thisa6[i]));wrd6b.add(st);
    if wrd6s.indexof(st)<0 then writeln('**',st);
  //for j:=1 to 6 do write(thisa6[j],'.');
  writeln;

  except writeln('****');
  end;
 end;
 for j:=0 to wrd6b.Count-1 do
     if wrd6s.indexof(wrd6b[j])<3 then writeln('###',wrd6b[j]);
 }
 writeln('done',wrd6s.count,'/',wrd6b.count);
 writeln('w1:',words1,'/n1:',nodes1);
 writeln('w32:',words32,'/n32:',nodes32);
 j:=0;
 for i:=31 downto 1 do begin writeln(i,' ',singles[i],'   ',singles[i]+j);j:=j+singles[i];end;
 for i:=31 downto 1 do begin writeln(i,' ',multis[i],'   ',multis[i]+j);j:=j+multis[i];end;

end;





//type tbitstrie;
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
PROCEDURE DOIT;
//var strie:tstrie;w:w32;len:byte;fst:tfilestream;i,j,luku,uus:integer;x1:byte;upoint:^byte;//threebytes;
var i,j:integer;
  begin
  tmemtab.create(16,6461);
  exit;
  //lentab2;exit;

  //for i:=1 to 32 do write('''',

    // fst:=tfilestream.create('/home/t/turku/freq.txt',fmopenread);
    // lines(fst);
  //cleanpoems;exit;
  //  gutpoems;exit;
//    dotrie;exit;
//    hyphenate;
end;
function readlen(var w:w32;fs:tfilestream):byte;
 var len:byte;ch:byte;cch:byte;
 begin
   len:=0;
  //debugst:='';
   //for i:=0 to 7 do w[i]:=0;
   result:=0;
 while fs.read(ch,1)=1 do
 begin
   if (ch=10) then begin exit;end;
   if fs.size<fs.position+1 then break;
   if ch=13 then continue;  //skip CR
   //debugst:=debugst+chr(ch);
   if result>14 then continue;
   {if (chrcodes[ch]>31) or (chrcodes[ch]=0) then
    w[result]:=31
   else}
   w[result]:=chrcodes[ch];
   result:=result+1;
   //writeln(i,w[i],'_',ch,letters[w[i]],'  ');
   //if ch<>0 then
   //if (pos(ch,^J+' ,.?!%&-;_''")(*]{[1234567890')>0)  then  begin fs.read(ch,1);if ch=^j then continue;end;
  // cch:=chrcodes[ord(ch)];
   //if cch<>#0 then begin w[i]:=cch;i:=i+1;end;
   //result:=result+ch;
   //len:=len+1;
 end;
 end;
{ item:
  2 bytes for: 0)no children 1)


}

type
 ptiers=^ttiers;

 ttier=class(tobject)
    tiers:ptiers;
    myslot:pointer;
    arrays:array[1..4] of integer;   //really short pointers

    constructor create(size:cardinal);
end;

 ttiers=class(tobject)      //memory manager
    muistot:pointer;
    slots:tlist;
    function createslot:pointer;
    constructor create(size:cardinal);
end;

 constructor ttier.create(size:cardinal);
 begin
   //myslot:=
 end;
 constructor ttiers.create(size:cardinal);
 begin
   getmem(muistot,size);

 end;
function ttiers.createslot:pointer;
begin

end;



type ttrielevelbig=class(tobject)
  //a,b:char;
  is_a_word:boolean; //or pointer to the completed word?
  //nextoffsets: array[0..32] of word;
  haswords,
  haslevels
  : cardinal; //bitwise for each following letter - has or has not

  wordscount, //how many unprosessed longer words -max 16 (?), then process and produce levels
  levscount
  : byte;
  //nextoffsets: array[0..32] of byte;  //64 BITS - pointers  to the children (be they words of levels)
  //maybe a pointer to a list containing the sublevels
  pointerlist:pointer;
  constructor create;

end;
constructor ttrielevelbig.create;
begin
  inherited create;
  writeln('MY SIZE IS:', ttrielevelbig.instancesize);
end;
{$s+}
function readciphered(fst:tfilestream):w32;
var aw:w32;i,len:byte;p:pointer;
  begin
   //:=0;
   getmem(p,65535*4);
   while fst.Size>fst.position+1  do
   begin
     //c:=c+1;if c>100000 then break;
     len:=readlen(aw,fst);
     if len>14 then
     begin
       //write(len,'    ');
       for i:=0 to len-1 do if (aw[i]<1) or (aw[i]>31) then write('_') else write(letters[aw[i]]);
       //writeln('  !',length(debugst),debugst,' ',aw[len-1]);
       writeln;

     end;
   end;
 end;


//procedure lentab;forward;
PROCEDURE xDOIT;
var i,j:byte;hmem,smem:cardinal;//biggie:
  chb:byte;
  ch:ansichar;
  fst:tfilestream;
 //letcodes:array[1..32] of byte;
  //array[1..147483647] of byte;


BEGIN
   fst:=tfilestream.create('/home/t/turku/iso.wrd',fmopenread);

  readciphered(fst);
  fst.free;
  {for i:=0 to 255 do
   begin
   begin
     ch:=(letters[chrcodes[i]]);
   end;

  end; }
exit;
  smem:=getheapstatus.totalfree;
  //hmem:=getstackstatus.totalallocated;
  writeln('mem:',smem);
  exit;
  //tlentiles.create;
  writeln('memlost:'+floattostr(getheapstatus.totalallocated-smem));
  //wordlists:=tlist.create;
  //for i:=0 to 16 do wordlists.add(twordlist.create(i));
END;


function _hash(st:string):longword;//longword;
var i,len:integer;
begin
  result:=0;
  len:=length(st);
  for i := 1 to len do begin
    if st[i]=' ' then break;
    result := ord(st[i])+result*31;
  end;
end;


const konsonantit:ansistring='bcdfghjklmnpqrstvxz'; vokaalit:ansistring='aeiouy��';
 diftongit='ai,au,ei,eu,ey,ie,iu,oi,ou,�i,�i,�y,�y,ui,yi,iy,uo,y�';   //+7*.. =25


function _hyphenfi(w:string):ansistring;
 function diftong(a,b:ansichar):boolean;
 begin
      case a of
       'a':  result:=pos(b,'aiu')>0;
       'e':  result:=pos(b,'eiuy')>0;
       'i':  result:=pos(b,'ieuy')>0;
       'o':  result:=pos(b,'oiu')>0;
       'u':  result:=pos(b,'uoi')>0;
       'y':  result:=pos(b,'yi�')>0;
       #228:  result:=pos(b,'�iy')>0;
       #246:  result:=pos(b,'�iy')>0;
       //'':  result:=pos(b,'')<=0;
       else result:=false;

      end;

 end;

 var i,j,len,tavuraja,vows:integer;hy:ansistring;ch,chprev:ansichar;lasthyp:ansistring;vow,vowalert,prvow:boolean;
   tavuja,prev:byte;
tavurajat:array[1..16] of byte;
 begin
  for i:=1 to 16 do tavurajat[i]:=0;
  vows:=0;
  vow:=false;
  len:=length(w);
  result:='?';//w[len];
  hy:=w[len];
  chprev:='_';
  prvow:=false;
  tavuraja:=1;
  result:='';
  //writeln(w,LEN);result:=w;exit;
  tavuja:=0;
  vowalert:=false;
  for i:=2 to len do
  begin
     prvow:=vow;
     chprev:=ch;
     ch:=w[i];//chn:=w[i+1]; pankkrotti mins-tra
     vow:=(pos(ch,vokaalit)>0);
     //if (vow and prvow) then writeln(chprev,ch,diftong(chprev,ch));
     if (not prvow) and (vow) then //vokaali konsonantin j�lkeen - konsonantin eteen tavuraja
     begin
       if tavuraja>1 then result:=result+'-';
       for j:=tavuraja to i-2 do result:=result+w[j];
       //for j:=tavuraja to i-2 do write(w[j]);
       //writeln;
       vowalert:=false;
       tavuja:=tavuja+1;tavurajat[tavuja]:=i-1;
       tavuraja:=i-1;continue;
     end
     else
     if (prvow) and (vow) then //vokaali vokaalin j�lkeen
     if vowalert  then begin tavuja:=tavuja+1;tavurajat[tavuja]:=i;vowalert:=false;end
     else
      if not(diftong(chprev,ch)) then
      begin
         tavuja:=tavuja+1;tavurajat[tavuja]:=i;
         result:=result+'+';
        for j:=tavuraja to i-1 do result:=result+w[j];
        //for j:=tavuraja to i-1 do write(w[j]);
        //writeln;
        tavuraja:=i;
      end else       vowalert:=true;
     end;


  //writeln('**************');
  result:=result+'!!!';
  for j:=tavuraja to len do result:=result+w[j];
  //for j:=tavuraja to len do write( w[j]);
  //write('@@',tavuja,':');
  tavurajat[tavuja+1]:=len+1;
  prev:=1;
  for i:=1 to tavuja+1 do begin for j:=prev to tavurajat[i]-1 do write(w[j]);write(^j);prev:=tavurajat[i];end;
 end;
function hyphenate:tstringlist;//(files:tstringlist;wlistfile:string):pointer;
var fstr:tfilestream;words:tstringlist;i,j,wc,hits,nhits:integer;hasi:longword;//longword;
 pairs:^word;
 aword:ansistring;//isin:boolean;
  t:tdatetime; hashlist:tstringlist;
  shash:word; //not used,, was there for debugging. short for shorthash
  istr:ansistring;
  begin
   //writeln(vokaalit);exit;
    //for i:=0 to files.count-1 do begin fstr:=tfilestream.create(files[i],fmopenread);
    //fstr:=tfilestream.create('/find2048.lst',fmopenread);
  //fstr:=tfilestream.create('/home/t/turku/iso.wrd',fmopenread);
  //fstr:=tfilestream.create('iso.wrd',fmopenread);
  //fstr:=tfilestream.create('iso.wrd',fmopenread);
    repeat
       //if fstr.size-fstr.position<1 then break;
       //if fstr.position>1000 then break;
      //aword:=readword(fstr);
      readln(aword);
      //writeln(aword, ':');
      //writeln(
      _hyphenfi(ansilowercase(aword));
    //  writeln('=',_hyphenfi(aword))
      //writeln;
     // _hyphenfi(aword);
    until false;
  end;


function _hyphenfi2(w:string):string;
var i,j,len,vpos,vows:integer;hy:string;ch,chprev:char;lasthyp:string;vow,pvow,vowalert:boolean;
begin
 vows:=0;
 len:=length(w);
 result:='';//w[len];
 hy:=w[len];
 chprev:='_';
 pvow:=false;
 for i:=len downto 1 do
 begin
    ch:=w[i];//chn:=w[i+1]; pankkrotti mins-tra
    vow:=(pos(ch,vokaalit)>0);
     write('*',ch,vow);
    if vow then vows:=vows+1
    else
    if vows>0 then
    begin
           for j:=vows downto 1 do
           result:=w[i+j]+result;
           result:='-'+ch+result;
           vows:=0;
           //hy:='';
    end ELSE begin vows:=vows+1; end;
      {  case chn of
        'a':  if pos(ch,'aiu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        'e':  if pos(ch,'eiyu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        'i':  if pos(ch,'eiyu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        else hy:=ch+hy;

       end;
       }
      {  vaieta karaoke

        case ch of
        'a':  if pos(chn,'aiu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        'e':  if pos(chn,'eiyu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        'i':  if pos(chn,'eiyu')<=0 then hy:=ch+'+'+hy else hy:=ch+hy;
        else hy:=ch+hy;
       end;
       }
 // end else  //no vowels
 //  result:=ch+result;
   // HY:=ch+hy;
 end;

 //if hy<>'' then
//  if pos(hy[1],vokaalit)>0 then result:=hy+'-'+result
//  else result:=hy+result;

end;

function readword(fs:tfilestream):string;
 var ch:char;len:integer;
begin
  len:=0;result:='';
  while fs.read(ch,1)=1 do
  begin
    if (ch=^J) then begin exit;end;
    if fs.size<fs.position then break;
    if ch=^m then continue;  //skip CR
    if (pos(ch,^J+' ,.?!%&-;_''")(*}]{[1234567890')>0)  then  begin fs.read(ch,1);if ch=^j then continue;end;
    result:=result+ch;
    len:=len+1;
  end;
end;


//function readline(fs:tfilestream):string;

function _isin(whash:longword;hlist:pointer;var shash:word):boolean;
var midtest,curtest,nextstep:integer;curpoint:^longword;curval:longword;
begin
  result:=true;midtest:=1024;nextstep:=512;
   repeat
      curpoint:=hlist+(midtest*4);
      curval:=curpoint^;
      //if curval=whash then write('!!!!',midtest) else begin if curval> whash then write(' >',midtest) else write(' -',midtest);end;
      if curval=whash then begin shash:=midtest;break end else begin if curval>whash then midtest:=midtest-nextstep else midtest:=midtest+nextstep;end;
      if nextstep<1 then begin result:=false;break;end;
      nextstep:=nextstep div 2;
   until false;
end;

function Compa(P1, P2: Pointer): Integer;
begin
   result:=0;
       //if p1>p2 then result:=1 else if p1=p2 then result:=-1 else result:=0;
end;
function compai(List: TStringList; Index1, Index2: Integer): Integer;
var
a, b: Integer;
begin
a := StrToInt(List.Strings[Index1]);
b := StrToInt(List.Strings[Index2]);
if a > b then
Result := 1;
if a = b then
Result := 0;
if a < b then
Result := -1;
end;

function coocs(whashes:pointer):pointer;//(files:tstringlist;wlistfile:string):pointer;
var fstr:tfilestream;i,j:integer;hasi:longword;//longword;
 hasp:^longword;pairs:^longword;
  ipoint,ip2:^longword;//longword;
   aword:string;//isin:boolean;
  t:tdatetime;   shash,hasha,hashb:word;
  words_inpar:integer;
  parag:array[1..256] of word; // 2 bytes for co-occurrence-counts, max 256 words per sentence
begin
  //hits:=0;nhits:=0;
  getmem(PAIRS,2048*2048*4);
  fillchar(pairs^,2048*2048*2,0);
  //writeln('created matrix');
  //for i:=0 to files.count-1 do
  begin
    words_inpar:=0;
    //fstr:=tfilestream.create(files[i],fmopenread);
    fstr:=tfilestream.create('turha.txt',fmopenread);
    repeat
       if fstr.size-fstr.position<1 then break;
       //if fstr.position>300000 then break;
       //if fstr.position>1000 then break;
      aword:=readword(fstr);
      //write(aword,'/',words_inpar,' ');
      if aword='' then
      begin
      //writeln;
      for i:=1 to words_inpar do
      begin
        for j:=1 to words_inpar do
          begin
            ipoint:=pairs+(parag[i]*2048)+parag[j];
            //if ipoint^<10000 then
            ipoint^:=ipoint^+1;
            //write(parag[i],'/',parag[j],' ');
          end;
          //writeln;
       end;
       //writeln('w=',words_inpar);writeln;
       //writeln;
       words_inpar:=0;continue;
      end;/// else if length(aword)=1 then continue else
      if words_inpar>255 then begin writeln('longsennver�');continue;end;
      hasi:=_hash(aword);
      if _isin(hasi,whashes,shash) then
      begin
        //write('**',shash,' ');
        words_inpar:=words_inpar+1;
        parag[words_inpar]:=shash;
      end;
    until false;
    //exit;
      for i:=0 to 2047 do
      begin
        for j:=0 to 2047 do
        begin
           ipoint:=pairs+(i*2048)+j;
           try
           write(ipoint^,' ');

           except write(', ');       end;
        end;
        {for j:=i downto 0 do
        begin
             ipoint:=pairs+(i*2048)+j;
             try
             write(ipoint^,';');
             except write(',-');
             end;
         end;}
        writeln;
       end;

    end;/// else if length(aword)=1 then continue else

  end;
type tst=class(tobject)
  st:string;
  constructor create(s:string);
  end;
  constructor tst.create(s:string);
  begin st:=s;end;

function createcommonshash:pointer;//(files:tstringlist;wlistfile:string):pointer;
var words:tstringlist;i,j,wc:integer;
  ip2:^longword;
  whashes:pointer;
  istr:string;//isin:boolean;
  t:tdatetime; hashlist:tstringlist;
  shash:word;    st:tst;
begin
  getmem(whashes,wc*4);
  words:=tstringlist.create;
  words.loadfromfile('find2048.lst');
  wc:= words.count;
  hashlist:=tstringlist.create;
  for i:=0 to words.count-1 do //utterly inelegant, but easies i acme up with to numerically sort a few strings
  begin
     // later maybe usefull: words.objects[i]:=tobject(pointer(hasi));
     istr:=inttostr(_hash(words[i]));
     hashlist.addobject(copy('0000000000',1,12-length(istr))+istr,tst.create(words[i]));
  end;
  hashlist.sort;
  getmem(whashes,2048*4);  //hardcoded 2048, q & dirty
  fillchar(whashes^,2048*4,0);
  ip2:=whashes;
  for i:=0 to wc-1  do //prepare the 'matrix' of hashes of words to find
  begin
    ip2^:=strtointdef(hashlist[i],0);
    ip2:=ip2+1;
    write('''',tst(hashlist.objects[i]).st,''',');
  end;
  result:=whashes;
end;
function listcommons(whashes:pointer):tstringlist;//(files:tstringlist;wlistfile:string):pointer;
var fstr:tfilestream;words:tstringlist;i,j,wc,hits,nhits:integer;hasi:longword;//longword;
 pairs:^word;
 aword:string;//isin:boolean;
  t:tdatetime; hashlist:tstringlist;
  shash:word; //not used,, was there for debugging. short for shorthash
  istr:string;
  begin
    //for i:=0 to files.count-1 do begin fstr:=tfilestream.create(files[i],fmopenread);
    fstr:=tfilestream.create('turha.txt',fmopenread);
    repeat
       if fstr.size-fstr.position<1 then break;
       //if fstr.position>1000 then break;
      aword:=readword(fstr);
      if aword='' then begin writeln(^J);continue;end;/// else if length(aword)=1 then continue else
      hasi:=_hash(aword);
      if _isin(hasi,whashes,shash) then write(aword,' ');// else write('-',aword);
    until false;
  end;

procedure tgut.DoRun;
var
  ErrorMsg: String;files:tstringlist;i,j:integer;w:string;ch:ansichar;st:string;
  lip:^longint;  sip:^smallint;ship:^shortint;smem:carDINAL;P:POINTER;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    writeln('no help');
    Terminate;
    Exit;
  end;
   //ch:=#228;
   //writeln(ch,ansistrupper(ch));
  //for i:=1 to 32 do write(letters[i],'_');

  //createcommonshash;
  //listcommons(createcommonshash);
  //coocs(createcommonshash);
  //cleanfile('11940-8.txt');
  DOIT;
  terminate;
  exit;
  files:=tstringlist.create;
  //files.loadfromfile('dir.lst');
  files.loadfromfile('wrd_aa');

  for i:=0 to //10 do //
  files.count-1 do
   //writeln(files[i]);
   begin
    writeln(_hash(copy(files[i],pos(' ',files[i])+1)),' ',files[i]);
    //writeln(copy(files[i],pos(' ',files[i])+1),files[i]);

   end;
   //cleanfile(files[i]);
  { add your program here }

  // stop program loop
  Terminate;
end;


function tgut.readline:string;
var  ch:char;
begin
     //endpar
    instr.read(ch,1);

end;
{ getting charcodes
st:='';
 for i:=0 to 255 do
 begin
   j:=0;
   ch:=chr(i);
   while j<=32 do begin j:=j+1;//writeln('i=',i,'/let32:',letters[i],'/ch:',ch);
     if letters[j]=ansilowercase(ch) then break;end;
   if j=33 then //writeln(i, ch,j) else
   st:=st+'#0,'
   //if j<33 then
   else   st:=st+'#'+inttostr(i)+',';
 end;
 writeln(st);
}

procedure w(wr:string;incont:boolean);
begin
    if incont then write(wr);
end;

procedure tgut.cleanfile(fn:string);
var  ch,punc:char; wor:string;mc,jc:integer; incont:boolean;
begin
    mc:=0;jc:=0;
    instr:=tfilestream.create(fn,fmopenread);
   try
  incont:=false;
  while instr.size>instr.position do
  begin
   if jc>1 then begin jc:=0;write(^j,^j);end;
   instr.read(ch,1);
   //if punc<>#0 then if ch in[^M ,^J,' '] then
   //writeln(punc);
   //punc:=#0;
   if ch in [#65..#90,#97..#122,#196,#197,#214,#228,#229,#246] then
   begin
   wor:=wor+ch; jc:=0;end else
   begin
      if wor='GUTENBERG' then begin //writeln(incont);readln;
      if incont then break;incont:=not incont;end;
     //if ch in ['','','','', then write('_') else
     //if ch='.' then writeln('.') else
     if length(wor)>1 then
     begin w(wor,incont);
     if ch in ['.','?','!',',',';'] then w(ch,incont);// else punc:=' ';
      w(' ',incont);
     end;
     wor:='';
     if ch=^M then mc:=mc+1;
     if ch=^J then jc:=jc+1;
     //if ch=^J then writeln('****',jc);

   end;
 end;

   finally
  instr.free;
   end;
end;


constructor tgut.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor tgut.Destroy;
begin
  inherited Destroy;
end;

procedure tgut.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;


TYPE tWORDLIST=class(tobject)
  len,count:integer;
  words:^ansichar;
  function add(p:tletterarray):word;
  constructor create(l:integer);
  procedure list;
end;

procedure twordlist.list;
begin
  // while i<count write...chrcode[i] if mod ... writeln
end;

constructor twordlist.create(l:integer);
begin
    getmem(words,sizeof(byte) div l);
end;

function twordlist.add(p:tletterarray):word;
var i:integer;wp:^ansichar;
begin
   wp:=words+count*len;
   for i:=0 to len-1 do (wp+i)^:=p[i]; //wasting 3 bits for every char
   count:=count+1;
end;

var
  Application: tgut;
begin
  Application:=tgut.Create(nil);
  Application.Run;
  Application.Free;
end.


type trienode=record
 w: array[0..31] of array[0..2] of byte;
 iis: array[0..31] of byte;
 end;
type  tstack=array[0..(65535*64)-1] of trienode;

{writeln('255: ',IntToBinStr(255));
writeln(256*256-1 and 2**8,':',IntToBinStr(256*256-1 and 2**8));
writeln(256*256*256-1 and 2**8,': '+IntToBinStr(256*256*256-1 and 2**8-1));
writeln(256*256*256*256-1 and 2**8,':',IntToBinStr(256*256*256*256-1 and 2**8-1));
WRITELN('-------------------');
writeln(%11111111111111111111111111111111);

//writeln(%11111111111111111111111111111111,' ', inttobinstr(%11111111111111111111111111111111),'/',length('11111111111111111111111111111111'));

//li:=2**32-1;
li:=(2**24)+123456;
writeln(li AND %11111111111111111111111111111110);
writeln(li AND %11111111111111111111111111111100);
writeln(li AND %11111111111111111111111111110000);
writeln(li AND %11111111111111111111111100000000);
writeln(li AND %11111111111111110000000000000000);
writeln;
writeln(li AND %01111111111111111111111111111111);
writeln(li AND %00111111111111111111111111111111);
writeln(li AND %00001111111111111111111111111111);
writeln(li AND %00000000111111111111111111111111);
writeln(li AND %00000000000000001111111111111111);
writeln;

WRITELN(2**31);
WRITELN(2**30);
WRITELN(2**24);
WRITELN(2**16);
end;exit;}
procedure dotrieold;
 var stack:pointer;//longstack;
   nodes:longstack;
   wrd:w32;wrdlen,i,j:byte; fst:tfilestream;
   //cur:p32;
   curnode,curlink:longword;
   curnodep,firstnodep:^node32;
   p:^word;anode,fnode:node32;
   stacktop:longword;
   wbytes:p32;
   linkp:pointer;
   nbytes:pp32;
   //wpoint,npoint:longword;
   c:integer;
   newlink:^byte;
   mask,li:longword;
   ipoint:^longword;
   stakkip:^longstack;
   letter:byte;
begin
  Begin
   mask:=%00000000111111111111111111111111;
    //writeln(sizeof(longstack),'/',sizeof(node32),'=',sizeof(longstack) div sizeof(node32));
     //fst:=tfilestream.create('/home/t/turku/isosanat.lst',fmopenread);
    fst:=tfilestream.create('/home/t/turku/pienb.txt',fmopenread);
    //fst.read(letter,1);

    //writeln(sizeof(longstack));exit;
    getmem(stack,sizeof(longstack));
    fillchar(stack^,sizeof(longstack),0);
    //getmem(stakkip,sizeof(longstack));
    //fillchar(stakkip,sizeof(longstack),0);
    //fillchar(stakkip,sizeof(longstack),0);
{    //stakkip:=stack;
    for i:=0 to 10 do
    begin
      stakkip^[i].w[0][0]:=random(20);
      writeln(stakkip^[i].w[0][0]);
    end;
    curnodep:=nodep(stakkip);
    anode:=curnodep^;
        for i:=0 to 10 do
    begin
      anode:=(curnodep+i)^;
      writeln(anode.w[0][0],'    ',int64(addr(anode)));

    end;
    exit;
    nodes:=longstack(stack^);

    //writeln(int64(stakkip^));
    writeln(int64(stack));  //value of pointer
    writeln(int64(@nodes));  //pointer value should be the address of the
    writeln(int64(addr(nodes)));
    //writeln(int64(stack));
    writeln(int64(@nodes-stack));
    writeln(int64(@nodes)-int64(stakkip));
    writeln(int64(@nodes) / int64(stakkip));
    exit;
    //curnodep:=stack;
    }
    stacktop:=0;c:=1;curnode:=0;
    firstnodep:=nodep(stack);
    //firstnodep:=stack;
    //fnode:=stakkip^[0];
    writeln('start');
    //writeln('start:',int64(@nodes),'/',int64(stack),':',@nodes-stack);
    //fnode.w[0][0]:=9;
    while readw(fst,wrd,wrdlen) do  //insert into trie
    begin
     curnode:=0;
     if (wrdlen<3) or (wrdlen>31) then continue;
     for i:=0 to wrdlen-2 do
     begin
       //anode:=nodes[curnode];
       anode:=firstnodep^;
       writeln('----',curnode);
       if @anode=firstnodep   then write('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
       writeln(curnode,sizeof(longstack),'.',anode.w[0][0],'!');
       //curnodep:=stack;//+stacktop;
       //curnodep^:=stakkip^[curnode];
       //writeln(int64(firstnodep+stacktop),':::',int64(curnodep),':::',int64(curnodep+1),'!',stacktop);
       //writeln('***',stacktop,'/',fnode.w[0][0],'**');
       //tpoint:=curnode+3*(curword[i]-1);
       //tval:=tpoint^;
        letter:=wrd[i]-1;
        wbytes:=anode.w[letter];
        //wbytes[0]:=1;
        //wpoint:=longword(@(curnode^.w[wrd[i]])) mod 2**32;
        //wpoint:=wbytes mod (2**32) //((and %1111 1111 1111 1111 1111 1111 0000 0000;
        //li:=longword(curnode);
        //wpoint:=longword(curnode-stack) and mask;
        //curlink:=longword(curnode-stack) and mask;
        //writeln('FI*',firstnodep^.w[0][0]);
        curlink:=wbytes[0]+256*wbytes[1]+256*256*wbytes[2];
        writeln('n:',curnode,'[',wrd[i],'->',curlink,']',int64(@anode),':',stacktop);
        for j:=0 to 31 do write(firstnodep^.w[j][0]);
        writeln;
       if (curlink<>0) then  //next node exists, move to it
       begin
         curnode:=curlink;
         //curnodep:=firstnodep+curlink;
         write('+',letters[wrd[i]]);
       end else  //new node, reserve the space and save the pointer to it
       begin
         stacktop:=stacktop+1;
         //newlink:=@stacktop;//+1;  //skip first byte as only 2^24 are needed
         linkp:=@wbytes;
         //for i:=0 to 3 do linkp^:=linkbytes[0]=@wbytes;
         //writeln('stack:',integer(@stacktop));
         //ipoint:=@stacktop;
         //Move(newlink^,wbytes,3);
         //wbytes[0]:=1;
         anode.w[wrd[i]][0]:=1;//newlink^;
         //fnode.w[curnode][wrd[i]]:=1;//newlink^;
         //writeln('==',curnode,'$',wrd[i],'=',fnode.w[curnode][wrd[i]]);
         curnode:=stacktop;
         //writeln('node:',stacktop,':',wbytes[0],'/',wbytes[1],'/',wbytes[2],'=');
         //writeln('node:',stacktop,':',newlink^,'/',(newlink+1)^,'/',(newlink+2)^,'/',(newlink+3)^,'=');
         //Move(ipoint^,wpoint,1);
        //  wbytes,3);
         //npoint:=integer(@newbytes) and %11111111111111111111111100000000;
         //wpoint:=nbytes^[0]+256*nbytes^[1]+256*256*nbytes^[2];
         //curnode^.w[i]:=nbytes^;
         //curnodep:=stack+stacktop*sizeof(anode);
         //newbytes[0]+256*newbytes[i])^+256*256*(tmp+2)^));
       end;
     end;
      if stacktop>=65534 then begin writeln('stack full'); readln;break;end;
     c:=c+1;
    end;
    writeln(c);
 end;
end;
//tr:=stack;
//np:=stack;
//nn:=np^;
//writeln(sizeof(nn),'table');//,tr^[0][0][0],'/',tr^[0][1][0]);
 {for i:=0 to 5 do
 begin
   pcurnode:=stack+(i*sizeof(node32));
   writeln('___________________________________________________',i,' ');
   for j:=0 to 31 do
   begin
    pmyletter:=pcurnode+j*3;
    if pmyletter^=0 then write('  ') else write(letters[j],pmyletter^);
   end;
   writeln;
 end;
 writeln;writeln;
 for i:=0 to 5 do
 begin
  writeln('___________________________________________________',i, ' ');
  pcurnode:=stack+(i*sizeof(node32));
   for j:=0 to 31 do
   begin
    if node32(pcurnode^).isword[j]=true then
    write(' ',letters[j]) else write('   ');
   end;
   writeln;
 end;
writeln;
for i:=1 to 32 do write(letters[i]);writeln;
writeln; }
procedure cipher(st:string;var w:w32;var len:byte);
   var i:byte;ch:byte;
   begin
     //move(5,i,1);
     len:=min(length(st),32);
    //debugst:='';
      fillchar(w,32,0);
     for i:=1 to len do
     begin
        ch:=byte(st[i]);
        w[i-1]:=chrcodes[ch];
   end;
   end;

type tlentiles=class(tobject)
    //emptyspace:array[1..65536,1..65536] of longint;
    //subbuckets:array[1..3] of tlentiles;

  //  levels array[i:
    constructor create;
end;
 constructor tlentiles.create;
 begin
   writeln(tlentiles.instancesize);
 end;
type tstrie=class(tobject)
  stack:pointer;
  stacktop:longword;
  fst:tfilestream;
  curword:w32;
  cwlen:byte;
  function read:boolean;

  function findadd:word;//(st:w32;len:byte):word;
  procedure list;
   //slots:tlist;
   //function createslot:pointer;
   constructor create(size:cardinal);
 end;
 function tstrie.read:boolean;
 begin

   readw(fst,curword,cwlen);
 end;
procedure tstrie.list;
 var nex:longint;tr:^tstack;ns:integer;nn:trienode;np:^trienode;
   nsingles:integer;
   words,nodes,tails:array[0..32] of integer;
 procedure listnode(n:trienode;ind:string);
  var i,j:integer;//db:string;
    wrd,nds,tls:integer;
 begin
   //if iis[
   //writeln(ind);//exit;
 //db:='';
// for i:=0 to 31 do writeln('?',letters[i+1],n[i][0]+(256*n[i][1])+256*256*(n[i][2]));
   tls:=0;nds:=0;
   //writeln;
   //write('!',ind);
 for i:=0 to 31 do  if (n.w[i][0]>0) or (n.w[i][1]>0) or (n.w[i][2]>0)then nds:=nds+1;
 for i:=0 to 31 do
 begin
    if (n.w[i][0]>0) or (n.w[i][1]>0) or (n.w[i][2]>0)then     //not all zeroes
    begin
      nex:=n.w[i][0]+(256*n.w[i][1])+256*256*(n.w[i][2]);
      if nds>1 then
        listnode(tr^[nex],ind+letters[i+1])
      else if nds=1 then begin nsingles:=nsingles+1;listnode(tr^[nex],ind+ansiuppercase(letters[i+1]));end;
      //db:=db+(letters[i+1]);
    end; //else writeln('-',letters[i+1],n[i][0]+(256*n[i][1])+256*256*(n[i][2]));
    if n.iis[I]=1 THEN  //if nds=1 then
    writeln(ind,letters[i+1]) else
    //writeln(ind,'_',ansiuppercase(letters[i+1]));
 end;
 //writeln;
 if nds>0 then nodes[nds-1]:=nodes[nds-1]+1;
end;
      var i:integer;
begin
  nsingles:=0;
  for i:=1 to 32 do words[i]:=0;
  for i:=1 to 32 do nodes[i]:=0;
  tr:=stack;
  np:=stack;
  nn:=np^;
  writeln(sizeof(nn),'table');//,tr^[0][0][0],'/',tr^[0][1][0]);
  listnode(nn,'');
  for i:=0 to 32 do writeln(i+1,'=',nodes[i]);
   writeln('singles:',nsingles);
end;

constructor tstrie.create(size:cardinal);
begin
    fst:=tfilestream.create('/home/t/turku/isosanat.lst',fmopenread);
    //fst:=tfilestream.create('/home/t/turku/pienb.txt',fmopenread);
    getmem(stack,size*32*4);
    fillchar(stack^,size*32*4,0);
    stacktop:=0;
    //writeln('stackat:',tstrie. instancesize);
  end;
function lines(fs:tfilestream):string;
var ch:byte;ok:boolean;st:string;
begin
  while fs.read(ch,1)=1 do
  begin
  if (ch=10) then begin if ok and (length(st)>1) then writeln(st);ok:=true;st:='';continue;end;
  if ch=13 then continue;  //skip CR
  if chrcodes[ch]=0 then ok:=false else st:=st+chr(ch);

  end;
end;

{for i:=1 to 32 do
begin
  write(letters[i],',');
end;
writeln;writeln;
writeln('codes');writeln;
for i:=0 to 255 do
begin
  write(chrcodes[i]:4);
end;
writeln;writeln;
writeln;writeln('letters');;
for i:=0 to 255 do
begin
  if chrcodes[i]=0 then write('____') else
  write(letters[chrcodes[i]],'   ');
end;
writeln;writeln;
writeln;writeln('letters');;
for i:=0 to 255 do
begin
  if chrcodes[i]>0 then //write('____ 0') else
  writeln(i,' ',letters[chrcodes[i]],' ',chrcodes[i]);
end;
exit;
}
function tstrie.findadd:word;
var found:boolean;curnode:pointer;tpoint,tmp:^byte;tval:longword;i,j:word;//upoint:^threebytes;u:threebytes;t1,t2,t3:byte;
begin
    //writeln('tryfind');
    //for i:=0 to 31 do begin tpoint:=stack+i*2;write(tpoint^,'/');end;
    curnode:=stack;
    i:=0;
    //for i:=0 to cwlen-1 do
    //for i:=cwlen-1 downto 0 do
    while i<cwlen-1 do //last letter handled separately
    begin
     tpoint:=curnode+3*(curword[i]-1);
     //tval:=byte((tpoint+1)^)+;
     tval:=tpoint^;
     //tval:=tval div 256;
     //if tval=0 then //no prev continuation, create new node
     if ((tpoint+2)^=0) and ((tpoint+1)^=0)and ((tpoint)^=0) then //create new branch
     begin
       stacktop:=stacktop+1;
       //write('+',letters[curword[i]]);
       //curnode:=pointer(stack+(stacktop*64));
       curnode:=pointer(stack+(stacktop*128));
       tmp:=@stacktop;
       //f j:=2 downto 0 do
       //:=((tmp+2)^*256*256)+(upoint+1)^*256+(upoint)^;
        //     uus:=((upoint+2)^*256*256)+(upoint+1)^*256+(upoint)^;

        tpoint^:=tmp^;
       (tpoint+1)^:=(tmp+1)^;
       (tpoint+2)^:=(tmp+2)^;
 //       writeln('/',(tpoint)^,'/',(tpoint+1)^,'/',(tpoint+2)^,'//',stacktop,letters[curword[i]]);
       //stacktop;
     end else  //jump to existing branch



     begin //curnode:=pointer(stack+tval*96);
      tmp:=tpoint;
      curnode:=pointer(stack+128*(tmp^ +256*(tmp+1)^+256*256*(tmp+2)^));
      //uus:=((upoint+2)^*256*256)+(upoint+1)^*256+(upoint)^;
   //   writeln('+',letters[curword[i]],(curnode-stack) div 128);
      //write('_',letters[curword[i]]);
     end;
     i:=i+1;
     //write('(',tval,')');
    end;
    //last letter:
    tmp:=curnode+96+curword[i]-1;
    tmp^:=1;
    //writeln('*',letters[curword[i]],'!',cwlen,'!');
end;

VAR wordlists:tlist;
 // separ lists for words of each length 1..16 and for each starting char

  procedure dotrie3;
 var stack,ocstack:pointer;//longstack;
   wrd:w32;wrdlen,i,j:byte;
   fst:tfilestream;
   istacktop,ocstacktop,
   icurnode,icurlink,iocnode,ioclink:longword;
   pcurnode:pointer;
   ocnode:node1p;
   pmyletter:^byte;
   //anode,fnode:node32;
   wbytes:node32p;
   mask,li:longword;
   letter:byte;
   wcount,ii:integer;
   onlychild:boolean;
   thechild:node1p;
   //nsingles:integer;
   words,nodes,tails:array[0..32] of integer;
   function makeshorts(alltheway:boolean):integer;
   begin  //new, make a short one and add all the rest of the letters under it
     j:=i;
     while i<wrdlen-1 do
     begin
       ocstacktop:=ocstacktop+1;
       //if not alltheway then if
       if i=j then
       begin
         write('x');
         move(ocstacktop,pmyletter^,3);
         node32(pcurnode^).isshort[wrd[i]]:=true;
       end
       else begin
        ocnode^.isshort:=true;
        ocnode^.letter:=wrd[i+1];
        ocstacktop:=ocstacktop+1;
        move(ocstacktop,ocnode^.child,3);
        write('+',letters[wrd[i]],'_',ocnode^.letter,'/',node32(pcurnode^).w[1][0]);
       end;
       ocnode:=ocnode+1;
       i:=i+1;
     end;
     ocnode^.isword:=true;
     //break;
   end;

begin
   mask:=%00000000111111111111111111111111;
   fst:=tfilestream.create('/home/t/turku/pienb.txt',fmopenread);
   //fst:=tfilestream.create('/home/t/turku/isosanat.lst',fmopenread);
   getmem(stack,sizeof(node32)*2**16);
   fillchar(stack^,sizeof(node32)*2**16,0);
   getmem(ocstack,sizeof(ocnode)*2**16);
   fillchar(ocstack^,sizeof(ocnode)*2**16,0);
    istacktop:=0;icurnode:=0;onlychild:=true;
    ocstacktop:=0;
    //pfirstnode:=(stack);
    wcount:=0;
    while readw(fst,wrd,wrdlen) do  //insert into trie
    begin
     if wrdlen=0 then continue;
     wcount:=wcount+1;
     icurnode:=0;
     i:=0;
     while i<wrdlen-1 do
     begin
      pcurnode:=stack+icurnode*sizeof(node32);
      pmyletter:=pcurnode+wrd[i]*3;
      //write((pmyletter)^);
      ocnode:=ocstack+(pmyletter^+256*((pmyletter+1)^+256*((pmyletter+2)^)));
      if (pmyletter^=0) and ((pmyletter+1)^=0) and ((pmyletter+2)^=0) then
       makeshorts(true)
      else
      begin  //old node
       if node32(pcurnode^).isshort[wrd[i]] then
       begin
          write('=',letters[wrd[i]],letters[ocnode^.letter],'-');
          if ocnode^.letter=wrd[i+1] then
          begin  //the node will remain a one-child node
           //handle all consequtive onechild-nodes. for now, just write it out
           write('oc:',letters[wrd[i]],letters[wrd[i+1]],'...');
          end else
          begin
            //create node32 and change the pointer to it & change islong
           iocnode:=iocnode+1;
           move(iocnode,pmyletter^,3);
           node32(pcurnode^).isshort[wrd[i]]:=false;
           //write('B:',letters[wrd[i]],letters[wrd[i+1]],'...');
           makeshorts(false);
           break;  //we'll handle that later
          end;
       end else  //it was a full node;
       begin
       icurnode:=pmyletter^+256*((pmyletter+1)^+256*((pmyletter+2)^));
       write('>',letters[wrd[i]],node32(pcurnode^).ISshort[0]);
       end;
      end;
       i:=i+1;

     end;
     if i=wrdlen-1 then
     begin
     pcurnode:=stack+icurnode*sizeof(node32);
     node32(pcurnode^).isword[wrd[i]]:=true;
     write('.',letters[wrd[i]]);
     end;
     writeln;
    end;

    for i:=1 to 32 do words[i]:=0;
    for i:=1 to 32 do nodescount[i]:=0;

   //listnode(0,stack,'');
  // for i:=0 to 32 do writeln(i+1,'=',nodescount[i]);
end;


procedure testbin;
var i,j,top,step,cur:integer;dids:array[1..64] of byte;

  function steppaa(max,min:integer;ind:string):integer;
  VAR CURi:INTEGER;
  begin
  //writeln;
  curi:=((max+min)) div 2;
  // curi:=max-((max-min)) div 2;
      if max<=min then exit;
  //write(^j,ind,'/',max,'/',min,'(',curi,')');
      if curi>top then writeln('TTTTTTTTTTTTTTTTTTTTTTTTTT');
      if curi<1 then writeln('MMMMMMMMMMMMMMMM');
     dids[curi]:=dids[curi]+1;
      //if curi>max then exit;
      //if curi<min then exit;
      //write('*',ind,curi,'/',stepi,'/',stepi div 2,': ');
      //if stepi<=0 then exit;
      //stepi:=(stepi+1) div 2;

     //if curi+(curi div 2)<=top then steppaa(curi+(curi div 2),(stepi) div 2,ind+'+');
     //if curi-(curi div 2)>0 then  steppaa(curi-(curi div 2),(stepi) div 2,ind+'_');
     steppaa(max,curi,ind+'+');
     steppaa(curi-1,min ,ind+'-');
  end;

var max,min:integer;
begin
 for max:=1 to 10 do
   for min:=1 to max do
writeln('',max ,'/',min,'(',(max+min) div 2,'<>',max-((max-min) div 2),(max+min) div 2<>max-((max-min) div 2),')');
exit;
for top:=2 to 64 do
  begin
   for i:=1 to 64 do dids[i]:=0;
    cur:=top div 2;step:=cur;
    writeln('*****',top);
    //steppaa(4, 2, '*');
    steppaa(top,0, '');
    writeln;
    for i:=1 to top do write(i,'=',dids[i],' ');writeln;
    writeln;
    writeln('__________________________________________________');
  end;

end;
j:=0;
 for i:=1 to 255 do if chrcodes[i]=0 then
 begin
   if i=91 then j:=0;
   write('000,')
 end
 else begin j:=j+1;write(j:3,',');end;
 writeln;
 for i:=1 to 255 do if acodes[i]<>0 then write('''',ansichar(i),'''',',');



//!         if ktarg=i then continue;                                         // klo 14 ke asiakkaankatu
//!         if ktarg=jtarg then continue;
//if (ktarg<1) or (ktarg>mysize)  then continue; //technical, problems with rounding. should not happen
//if prw(ktarg)='pallo' then if prw(i)='auto' then for ii:=1 to 32 do write(prw(scartargs^[ktarg,ii]),scartargs^[ktarg,ii],'?');
//if prw(ktarg)='punainen' then if prw(i)='pallo' then for ii:=1 to 32 do write(prw(scartargs^[j,ii]),'p');
{if prw(ktarg)='xxxpallo' then if prw(i)='auto' then
begin
for ii:=1 to 32 do
begin
   if scartargs^[i,ii]>0 then
   /write(^j,'@',prw(scartargs^[i,ii]),ksiz,'/',diags[kTARG],'\',diags[jtarg],' sini[',prw(ktarg),round(lonsiz), ':',prw(scartargs^[i,ii]),scarsizes^[i,ii],'/',prw(jtarg),scarsizes^[jtarg,k],'=',hits[ktarg],':',lonsiz,'] ');
  //if prw(ktarg)='punainen' then if prw(i)='pallo' then
  // write(^j,prw(scartargs^[i,ii]),ksiz,'/',diags[kTARG],'\',diags[jtarg],' puna[',prw(ktarg),round(lonsiz), ':',prw(scartargs^[i,ii]),scarsizes^[i,ii],'/',prw(jtarg),scarsizes^[jtarg,k],'=',hits[ktarg],':',lonsiz,'] ');
end;
writeln;
end;   }
//if prw(i)='auto' then if prw(ktarg)='sininen' then begin  write(^j,'             K: ', prw(ktarg),'/',scarsizes^[i,1],'**');for ii:=2 to 5 do write(prw(scartargs^[ktarg,ii]));writeln('$$$');end;
//write(prw(ktarg),'/',prw(jtarg),':');
//for ii:=1 to 32 do begin  if scartargs^[i,ii]=ktarg then write('!');write(copy(prw(scartargs^[i,ii]),1,2),',');end;//,scarsizes^[);
//for kk:=1 to 32 do
   //if scarsizes^[i,kk]>0 then
//    write(copy(prw(scartargs^[ktarg,kk]),1,2),',');
//if 1= 0 then
//if iters=1 then writeln('***************************',prw(ktarg));
{for kk:=1 to 32 do  //all
begin
  kktarg:=scartargs^[ktarg,kk];
  if (kktarg=0) //or (kktarg=i) //or (kktarg=jtarg) or (kktarg=ktarg)
  then
  continue else
    for ii:=1 to 32 do
    begin
     if scartargs^[i,ii]=kktarg then
     begin
      try
       if ktarg=kktarg then continue;
       kksiz:=0;}
  {try
   begin
      kksiz:=0;
      for apu:=1 to 32 do if scartargs^[i,apu]=ktarg then
       kksiz:=scarsizes^[i,apu];
     if kksiz=0 then continue;
       //  write('\\',prw(scartarg[]);
       //l onsiz:=(1000*mysize*mysize*scarsizes^[i,ii]*ksiz) div (diags[jtARG]*diags[ktarg]);
       lonsiz:=1+(diags[ktarg]*diags[jtarg]) div 100;//hack, just using a free var
       //lonsiz:=1000;
        //lonsiz:=(10000*scarsizes^[i,ii]*ksiz) div (diags[jtARG]*diags[ktarg]);

       //lonsiz:=(scarsizes^[i,ii]*scarsizes^[ktarg,kk]) div 100;// div (diags[scartargs^[i,ii]]*diags[scartargs^[ktarg,kk]]);
       //lonsiz:=(scarsizes^[i,ii]*kksiz) div lonsiz;// div diags[jtarg]);
       lonsiz:=jsiz*kksiz div lonsiz;
       //write(lonsiz,'/',hits[ktarg]);
       hits[ktarg]:=hits[ktarg]+(lonsiz);
       //if prw(jtarg)='on' then  if prw(i)='sininen' then
       begin
         writeln(^j,prw(i),'*',prw(jtarg),'/',prw(ktarg));
         writeLN('diags:',(diags[jtarg]*diags[ktarg]) div 1000,'=','/',diags[jtarg],'*',diags[ktarg]);// div diags[jtarg]);
         writeLN('IK:',prw(i), DIAGS[KTARG],'=',kksiz,'/');// div diags[jtarg]);
         writeLN('jk:',PRW(jTARG), DIAGS[jTARG],'=',jsiz,'/');// div diags[jtarg]);
         writeLN('res:*',PRW(kTARG),'* ', DIAGS[kTARG],'!',(lonsiz),'!',(hits[ktarg]));
       end;


       {if (iters<=2) and (i=999991) and ((prw(ktarg)='sininen') or (prw(ktarg)='on'))then
       begin
        for apu:=19999 to 32 do if scartargs^[ktarg,apu]=kktarg then
         write('[',prw(scartargs^[ktarg,1]),prw(scartargs^[ktarg,apu]),' ',scarsizes^[ktarg,apu],']');
       write('+',prw(i),'-',prw(jtarg),'     ',prw(ktarg));//,diags[ktarg],prw(jtarg),diags[jtarg]);
       write  ('<-',prw(ktarg),prw(kktarg),'=',scarsizes^[i,ii],'/',diags[kktarg]);
       writeln('  ',prw(ktarg),prw(jtarg),'=',kksiz,'/',diags[jtarg], '      +',lonsiz,'==',hits[ktarg]);
       end;}
       //,diags[scartargs^[i,ii]]);
       //continue;
       //if prw(jtarg)='pallo' then
       //if prw(i)='auto' then
        //if prw(i)='axuto' then if prw(ktarg)='pallo' then
        //  writeln(^j,'!!!!!!!!!',round(lonsiz),prw(ktarg));
        //prw(jtarg),prw(i),ksiz,'/',diags[kTARG],'\',diags[jtarg],' [',prw(ktarg),round(lonsiz), ':',prw(scartargs^[i,ii]),scarsizes^[i,ii],'/',prw(jtarg),scarsizes^[jtarg,k],'=',hits[ktarg],':',lonsiz,'] ');
      //lonsiz:=                 (1*mysize*scarsizes^[i,ii]*ksiz);// div (diags[jtarg]*diags[ktarg]);
      //break;
   end;
   except writeln('xxxxxxxxxxxxxxxxxx');end;
   }



//writeln('N:',scartargs^[1,1],'=',scarsizes^[1,1]);
//if iters=5 then
{for i:=2465 to 2465 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //if multisiz^[i,1]<1 then continue;
   writeln;//(i,prw(2465),'::::::: ');
   for ii:=2 to 8 do
    if scarsizes^[i,ii]<100 then continue else
    begin
     write(prw(i),'::',prw(scartargs^[i,ii]),scarsizes^[i,ii],':         ');
     for jj:=2 to 8  do
     if scarsizes^[scartargs^[i,ii],jj]<100 then continue else
     write(prw(scartargs^[scartargs^[i,ii],jj]),'',scarsizes^[scartargs^[i,ii],jj],' ');
    writeln;
    end;
   WRITELN;writeln;
end;}
 // end;

{
for kk:=1 to 32 do
begin
kktarg:=scartargs^[ktarg,kk];
if (kktarg=0) //or (kktarg=i) //or (kktarg=jtarg) or (kktarg=ktarg)
then
continue else
  for ii:=1 to 32 do
  begin
   if scartargs^[i,ii]=kktarg then
   begin
    try
     if ktarg=kktarg then continue;
     kksiz:=0;
     for apu:=1 to 32 do if scartargs^[ktarg,apu]=kktarg then
       kksiz:=scarsizes^[ktarg,apu];
     //  write('\\',prw(scartarg[]);
     //l onsiz:=(1000*mysize*mysize*scarsizes^[i,ii]*ksiz) div (diags[jtARG]*diags[ktarg]);
     lonsiz:=1+(diags[kktarg]*diags[jtarg]) div 100;//hack, just using a free var
     //lonsiz:=1000;
      //lonsiz:=(10000*scarsizes^[i,ii]*ksiz) div (diags[jtARG]*diags[ktarg]);

     //lonsiz:=(scarsizes^[i,ii]*scarsizes^[ktarg,kk]) div 100;// div (diags[scartargs^[i,ii]]*diags[scartargs^[ktarg,kk]]);
     //lonsiz:=(scarsizes^[i,ii]*kksiz) div lonsiz;// div diags[jtarg]);
     lonsiz:=jsiz*kksiz div lonsiz;
     write(lonsiz,'/',hits[ktarg]);
     hits[ktarg]:=hits[ktarg]+(lonsiz);
     write(lonsiz,'/',hits[ktarg]);
     //if lonsiz>10000999 then
     begin
       writeln(^j,prw(i),'*',prw(jtarg),'/',prw(ktarg));
 ',diags[kktarg]);// div diags[jtarg]);
       writeLN('i:',PRW(KKTARG),prw(i), DIAGS[KKTARG],'!',kksiz,'/');// div diags[jtarg]);
       writeLN('j:',PRW(jTARG), DIAGS[jTARG],'!',jsiz,'/');// div diags[jtarg]);
       writeLN('v:',PRW(kkTARG), DIAGS[kTARG],'!',(lonsiz),'!',(hits[ktarg]));
     end;                                                                                                           writeLN('diags:',(diags[kktarg]*diags[jtarg]) div 1000,'=','/',diags[jtarg],'*
}

{for i:=199999 to 6461 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //if multisiz^[i,1]<1 then continue;
   write(prw(i),': ',diags[i]);
   for j:=1 to 32 do if scartargs^[i,j]<1 then continue else write(prw(scartargs^[i,j]),scarsizes^[i,j],'\',(scartargs^[i,j]<1),';');
   writeln;WRITELN;
end;}
writeln('************************************');
//readln;
{ for i:=1 to mysize do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //if multisiz^[i,1]<1 then continue;
   write(prw(i),': ');
   for jj:=1 to 32 do if scartargs^[i,jj]<1 then continue else write(prw(scartargs^[i,jj]),scarsizes^[i,jj],';');
   writeln;WRITELN;
end;readln;}
procedure tmemtab.prmatrix;
var isij:boolean;hitc,n,nn,i,j,k,kk,ii,iter,itarg,jtarg,ktarg,expd,divi,total:longword;//longword;//hits:integer;hitlist:array[1..32] of word;
mmat,mmm,emat:array[1..12] of array[1..12] of longword;line:tstringlist;dgs,exp,std:array[1..12] of longword;
rela,mean:longint;
procedure printit(mat:tmat);
var i,j:integer;
begin
writeln;
write('          '); for j:=1 to 12 do  write(copy(prw(j),1,3),'     ');writeln;
for i:=1 to 12 do
begin
    write(copy(prw(i)+'  ',1,3), copy(inttostr(dgs[i])+'       ',1,6),'|');
    for j:=1 to 12 do
    begin
     write(copy(inttostr(mat[i,j] div 1)+'      ',1,6),'| ');
    end;
   writeln;
 end;
 writeln;
end;
begin
write('        '); for nn:=1 to 12 do  write(copy(prw(nn)+'  ',1,3),'   ');
fillchar(mmat,sizeof(mmat),#0);
fillchar(emat,sizeof(mmat),#0);
//line:=tstringlist.create;
writeln('XZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
for itarg:=1 to 12 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //writeln(^j,'##############',prw(itarg),'*  ');//scarsizes^[i,ii],':         ');
   write(copy(prw(itarg)+'  ',1,3), copy(inttostr(scarsizes^[itarg,1])+'     ',1,5),':');
   for n:=1 to 12 do // for each word at a time, find it's correlates with current word
    for j:=1 to 12 do  //scan the list of cors of cur word
    begin
     jtarg:=scartargs^[itarg,j];
     isij:=false;
     begin //
       //if scarTARGS^[itarg,j]=0 then break;
       if jtarg=n Then  //found it
       begin
           mmat[itarg,jtarg]:=scarsizes^[itarg,j];
           //write(copy(inttostr(scarsizes^[itarg,j])+'       ',1,5),'|');
           write(copy(inttostr(mmat[itarg,jtarg])+'       ',1,5),'|');
          break;
        end
        ELSE if j=12 then if not isij then write('     |');//,itarg,'.',n); //i did not cor with the n;'th
      end;
     writeln;
    end;
   writeln('**');
end;
writeln('_______________________________**');
for i:=1 to 12 do
begin
   dgs[i]:=0;
    for j:=1 to 12 do
    //mmm[i,j]:=round(mmat[i,j]*log2 (total*(mmat[i,j]+1)/dgs[i]*dgs[j]));
     if i<>j then
     dgs[i]:=dgs[i]+mmat[i,j];
    //write(i,':::::',dgs[i],'  ');
end;
printit(mmat);
for i:=1 to 12 do
    for j:=1 to 12 do
    //mmm[i,j]:=round(mmat[i,j]*log2 (total*(mmat[i,j]+1)/dgs[i]*dgs[j]));
     if i=j then mmat[i,j]:=dgs[i] else
     //mmat[i,j]:=1000*mmat[i,j] div
     mmat[i,j]:=round(1000*mmat[i,j]/sqrt(dgs[i]*dgs[j]));
    //mmm[i,j]:=round(1000*mmat[i,j] div (1*dgs[i]*dgs[j] div total));
for i:=1 to 12 do
  begin
        for j:=1 to 12 do
        write(mmat[i,j]/1000:2:2,',');
        writeln;
   end; //- for export to R
printit(mmat);
{for itarg:=1 to 12 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   //writeln(^j,'##############',prw(itarg),'*  ');//scarsizes^[i,ii],':         ');
   //write(copy(prw(itarg)+'  ',1,3), copy(inttostr(scarsizes^[itarg,1])+'     ',1,5),':');
   for j:=1 to 12 do  //scan the list of cors of cur word
   begin
     jtarg:=scartargs^[itarg,j];
     // writeln;
      if jtarg=0 then continue;
      //!writeln(^j,' ',copy(prw(jtarg)+'   ',1,5),'***');
      //for k:=1 to 12 do  write(prw(scartargs^[jtarg,k]));
      for k:=1 to 12 do  //all cors of itarg
       if scartargs^[jtarg,k]=0 then continue else
       begin //for ii:=0 to 5 do write(prw(scartargs^[jtarg,ii]));
         ktarg:=scartargs^[jtarg,k];
         //!write(^j,'      !',prw(ktarg),':');
         //for kk:=1 to 12 do write(prw(scartargs^[ktarg,kk]));
         for kk:=1 to 12 do
          if scartargs^[ktarg,kk]=0 then continue else
           for ii:=1 to 12 do
            if scartargs^[itarg,ii]=0 then continue else
            if scartargs^[ktarg,kk]=scartargs^[itarg,ii] then
            begin
              mmat[itarg,ktarg]:=mmat[itarg,ktarg]+(scarsizes^[itarg,ii]*scarsizes^[ktarg,kk] div 1000);
              //mmat[itarg,ktarg]:=mmat[itarg,ktarg]+(scarsizes^[itarg,ii]*scarsizes^[ktarg,kk] div 1000);
              //writeln(itarg,'/',ktarg,'+',prw(scartargs^[ktarg,kk]),mmat[itarg,ktarg]);
              //write(prw(scartargs^[jtarg,kk]),mmat[itarg,jtarg],'+');//,prw(scartargs^[itarg,k]),scarsizes^[itarg,kk],'*',scarsizes^[j,k],'+');
            //break;
             end;
        //for kk:=1 to 12 do
        // if scarTARGS^[i,j]=II Then
     end;
   end;
   //writeln('X');
 end;
}
writeln;
//exit;

//for i:=1 to 12 do
//    for j:=1 to 12 do
    //mmm[i,j]:=round(mmat[i,j]*log2 (total*(mmat[i,j]+1)/dgs[i]*dgs[j]));
//    mmm[i,j]:=round(1000*mmat[i,j] div (1*dgs[i]*dgs[j] div total));

for iter:=1 to 20 do
begin
 writeln('??',iter);
 for i:=1 to 12 do
 dgs[i]:=mmat[i,i];
 fillchar(mmm,sizeof(mmm),#0);
 total:=0;
 for i:=1 to 12 do total:=total+dgs[i];
 for i:=1 to 12 do
   begin
      //write(copy(prw(i)+'  ',1,3), copy(inttostr(dgs[i])+'       ',1,6),'|');
      for j:=1 to 12 do
      begin

        //write('#',prw(i),'*  ');//scarsizes^[i,ii],':         ');
       //write(copy(inttostr(mmat[i,j])+'      ',1,6),'| ');
       //write(copy(inttostr(1000000*mmat[i,j] div (diags[i]*diags[j]))+'      ',1,6),'| ');
       //write(copy(inttostr(12*mmat[i,j]-diags[i])+'      ',1,6),'| ');
       //if i=j then continue;
        //if 12*mmat[i,j]>diags[j] then
        expd:=round(dgs[j]*dgs[i] div total);
        mmm[i,j]:=(mmat[i,j]-expd)+1000;
        for k:=199 to 12 do
        // if i<>k  then
        // if j<>k  then
        begin
         //rela:=//emat[(mmat[i,j]+(mmat[i,j]*1000);???
         //  dgs[k]**2 div 10000;
          //expd:=round((dgs[i] * (dgs[j]/total*dgs[k]/total))*10);
          //expd:=round(1000*mmat[i,k]*dgs[j]/(dgs[i]*diags[k]));// div diags[k];
          //expd:=round(mmat[i,k]*dgs[j]/(dgs[i]));// div diags[k];
          //expd:=round(mmat[i,k]/dgs[i]);
          //expd:=round(mmat[i,k]*dgs[j]/dgs[i]);
          //rela:=rela+abs(expd-mmat[4,k]);
          //mmm[i,j]:=mmm[i,j]+(abs(expd-mmat[j,k]));
          //mmm[i,j]:=mmm[i,j]+(abs(mmat[i,k]-mmat[j,k]));
          //mmm[i,j]:=mmm[i,j]+(abs(mmat[i,k]-mmat[j,k]));
          //expd:=round(abs((mmat[i,k])*dgs[i]/(dgs[i]+dgs[j])));
          //mmm[i,j]:=mmm[i,j]+abs(1000*(mmat[j,k]*expd)) div (dgs[j]+dgs[i]);
          //mmm[i,j]:=mmm[i,j]+mmat[j,k]*expd;
          //mmm[i,j]:=mmm[i,j]+mmat[j,k]*expd;
         //mmm[i,j]:=mmm[i,j]+(1*mmat[i,k]*mmat[j,k]) div 1000;//total;
         //x x x   100     25  50  25         50   50    0
         //x x x   200     50  100 50         50   100  50
         //x x x   100     25  50  25          0   50   50
         expd:=round(dgs[j]*dgs[i] div total);
         //mmm[i,j]:=mmm[i,j]+(1*mmat[i,k]*mmat[j,k])-expd;// div 1000;//total;
         mmm[i,j]:=mmm[i,j]+(1*mmat[i,k]*mmat[j,k]) div 1000;//total;

         // if prw(j)='pallo' then writeln(prw(i),prw(j),prw(k),':',mmat[j,k],'-',expd,'=',mmm[i,j],'/',abs(expd-mmat[j,k]));
          //mmm[i,j]:=mmm[i,j]+(mmat[j,k]*mmat[i,k]) div rela;
         //dgs[j]*dgs[j]*dgs[j] div 100000;
           //(dgs[i]*dgs[j]) div 100;
         //rela:=10000;
         //expd:=(mmat[i,j]*mmat[i,k]) div 10000;
         //if (i=k) or (j=k) then rela:=rela*4;
         //mmm[i,j]:=mmm[i,j]+(1000*(mmat[j,k]-diags[j])*(1000*mmat[i,k]-diags[i])) div (diags[j]*diags[i]);
        //mmm[i,j]:=mmm[i,j]+(  ((1000*mmat[j,k]) div diags[j])*((1000*mmat[i,k]) div diags[i])    );
        //mmm[i,j]:=mmm[i,j]+(mmat[j,k]*mmat[i,k]) div rela;
        //if (mmat[j,k]*mmat[i,k]>emat[j,k]) then
        //mmm[i,j]:=mmm[i,j]+((mmat[j,k]*mmat[i,k])) div rela;
        //if (mmat[j,k]*mmat[i,k])<10 then if i=2 then
        // writeln(prw(j),prw(k),expd,'/');
        end;
      end;
     //writeln;
   end;
 printit(mmm);
  writeln('nnnnnnnnnnnnnnnnnnn',round(1000* mmm[2,2] / sqrt(1+mmm[2,2]*mmm[2,2])));
  for i:=1 to 12 do
  begin
     mean:=0;
     std[i]:=0;
     for j:=1 to 12 do
      mean:=mean+mmm[i,j];
     mean:=mean div 12;
      for j:=1 to 12 do
       std[i]:=std[i]+round(mmm[i,j]-mean)**2;
      std[i]:=round(sqrt(std[i]/12));
  end;
  for i:=1 to 12 do
      for j:=1 to 12 do
      mmat[i,j]:=round( mmm[i,j] / 12);
      //mmat[i,j]:=round(1000* mmm[i,j] / std[i]*std[j]);
      //mmat[i,j]:=round(1000* mmm[i,j] / sqrt(0+mmm[i,i]*mmm[j,j]));
      //mmm[i,j]:=max(0,dgs[i]-mmm[i,j]);
  printit(mmat);
   {  writeln('auto on:');
 rela:=0;
 for k:=1 to 12 do
  if (k<>2) then if k<>1 then
  begin
     expd:=round(abs((mmat[1,k])*dgs[1]/(dgs[2]+dgs[1])));
      writeln(prw(k),mmat[2,k],'-',mmat[1,k],':',(expd));
      rela:=rela+(mmat[2,k]-expd);
  end;
 writeln(^j,dgs[2],'-',rela,'=',dgs[2]-rela);
  writeln;
  writeln('auto pallo:');
  rela:=0;
 for k:=1 to 12 do
   if (k<>8) then if k<>1 then
   begin
         expd:=round(abs((mmat[1,k])*dgs[1]/(dgs[1]+dgs[8])));
          writeln(prw(k),mmat[8,k],'-',mmat[1,k],':',(expd));
          rela:=rela+abs(mmat[8,k]-expd);
   end;
 writeln(^j,dgs[8],'-',rela,'=',dgs[8]-rela);
   writeln;

  ;
}

  writeln;
  //mmat:=mmm;
end;
writeln('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
end;

procedure tmemtab.prmatrix;
var isij:boolean;hitc,n,nn,i,j,k,kk,ii,its,itarg,jtarg,ktarg,divi,total:longword;//longword;//hits:integer;hitlist:array[1..32] of word;
mmat,mmm,emat:array[1..12] of array[1..12] of longword;line:tstringlist;sums,sums2:array[1..12] of longword;
exp,std:array[1..12] of real;
rela,mean:longint;
overlaps,xsum:longword;
acor,expdi,expdj,num,psum,den,difrc,sims:double;

procedure printit(mat:tmat);
var i,j:integer;
begin
writeln;
write('             '); for j:=1 to 12 do  write(copy(prw(j),1,3):3,'     ');writeln;
for i:=1 to 12 do
begin
    write(copy(prw(i)+'  ',1,8):8, copy(inttostr(sums[i])+'       ',1,6),'|');
    for j:=1 to 12 do
    begin
     write(copy(inttostr(mat[i,j])+'      ',1,6),'| ');
    end;
   writeln;
 end;
 writeln;
end;


begin
writeln('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
fillchar(mmat,sizeof(mmat),#0);
for itarg:=1 to 12 do //write(scartargs^[i,2],'=',scarsizes^[i,2],'/');
begin
   write(copy(prw(itarg)+'  ',1,3), copy(inttostr(scarsizes^[itarg,1])+'     ',1,5),':');
   for n:=1 to 12 do // for each word at a time, find it's correlates with current word
    for j:=1 to 12 do  //scan the list of cors of cur word
    begin
     jtarg:=scartargs^[itarg,j];
     isij:=false;
     begin //
       if jtarg=n Then  //found it
       begin
           mmat[itarg,jtarg]:=scarsizes^[itarg,j];
           //write(copy(inttostr(mmat[itarg,jtarg])+'       ',1,5),'|');
          break;
        end
        ;//ELSE if j=12 then if not isij then write('     |');//,itarg,'.',n); //i did not cor with the n;'th
      end;
    end;
   writeln('**');
end;  //transform the scarce matrix to square .. just to experiment, we need to do it later with the scarce one directly
total:=0;


for its:=1 to 100 do
begin
 writeln(^j,'---------------------------------------------------------------------',its);

 fillchar(mmm,sizeof(mmm),#0);
 printit(mmat);
 writeln('"sims/cors"',total);
 write('             '); for j:=1 to 12 do  write(copy(prw(j),1,4):4,'      ');writeln;
 //for i:=1 to 12 do sums[i]:=mmm[i,i];
 for i:=1 to 12 do
 begin
    sums[i]:=0;
     for j:=1 to 12 do
       if i<>j then
       begin
         sums[i]:=sums[i]+mmat[i,j];
         sums2[i]:=sums[i]+mmat[i,j]**2;
       end;
     total:=sums[i]+total;
     //mmm[i,i]:=sums[i];
     //write(i,':::::',dgs[i],'  ');
 end;

 for i:=1 to 12 do
   begin
    //write(^j,prw(i):8,'   ');
      for j:=1 to 12 do //if i<>j then
      begin
       difs:=0;
       overlaps:=0;
       acor:=0;
       sims:=0;
       xsum:=0;
        for k:=1 to 12 do
        //if (k<>j) and (k<>i) then
        begin
          try
          begin
            difs:=difs+abs((mmat[i,k]/sums[1]-mmat[j,k]/sums[1])**1);// sums[k]**2;
            sims:=sims+abs((mmat[i,k]/sums[1]+mmat[j,k]/sums[1])**1);// sums[k]**2;

          // sims:=1*sims+ max(expdi,expdj)*log2(max(expdi,expdj)/min(expdi,expdj));
          //writeln(prw(k),prw(i),expdi:4:4,'/',prw(j),expdj:4:4,'     =',sims:4:4)
          end;
          //expd:=expd+
          except writeln('#####################');end;
        end;
       // write(100*sims:4:0,' ',100*difs:4:0,'|');
        //mmm[i,j]:=round((sums[i]+sums[j]-(DIFS/1000)+sims/100));
        //mmm[i,j]:=round(max(0,(sims/1000-(DIFS/10000))));
          mmm[i,j]:=1  *round(max(0,0.1*(sims-difs)));
         mmm[i,j]:=round(sims/(total/(sums[i]+sums[j])));
         mmm[i,j]:=1  *round(max(0,100*((sums[i]*sums[j]/total)-10*sims)));
        // mmm[i,j]:=max(0,                   (sims-difs));
        mmm[i,j]:=round(1000*((difs)/(sims+(difs))));
        mmm[i,j]:=round(1000*((sims-difs)/(sims+(difs)**2)));
        //mmm[i,j]:=round(((sums[i]+sums[j])-1000*difs)/(sums[i]+sums[j]));
      end;
   end;
 //printit(mmm);
 //printit(mmm);
  //printit(mmm);


 mmat:=mmm;
end;
writeln('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
end;

{
 relative difference
 yet not multiplicative.

}



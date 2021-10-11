Unit UCoding;

interface

type
    TTypeCoding=(
                 WIN_2_ALT,WIN_2_ISO,WIN_2_KOI,WIN_2_MAC,
                 ALT_2_ISO,ALT_2_KOI,ALT_2_MAC,ALT_2_WIN,
                 ISO_2_ALT,ISO_2_KOI,ISO_2_MAC,ISO_2_WIN,
                 KOI_2_ALT,KOI_2_ISO,KOI_2_MAC,KOI_2_WIN,
                 MAC_2_ALT,MAC_2_ISO,MAC_2_KOI,MAC_2_WIN);

    function ConvertString(InputString: string; ttc: TTypeCoding): string;


implementation

{        Function ALT2ISO(Ch1: byte): byte;
        Function ALT2KOI(Ch1: byte): byte;
        Function ALT2MAC(Ch1: byte): byte;
        Function ALT2WIN(Ch1: byte): byte;
        Function ISO2ALT(Ch1: byte): byte;
        Function ISO2KOI(Ch1: byte): byte;
        Function ISO2MAC(Ch1: byte): byte;
        Function ISO2WIN(Ch1: byte): byte;
        Function KOI2ALT(Ch1: byte): byte;
        Function KOI2ISO(Ch1: byte): byte;
        Function KOI2MAC(Ch1: byte): byte;
        Function KOI2WIN(Ch1: byte): byte;
        Function MAC2ALT(Ch1: byte): byte;
        Function MAC2ISO(Ch1: byte): byte;
        Function MAC2KOI(Ch1: byte): byte;
        Function MAC2WIN(Ch1: byte): byte;
        Function WIN2ALT(Ch1: byte): byte;
        Function WIN2ISO(Ch1: byte): byte;
        Function WIN2KOI(Ch1: byte): byte;
        Function WIN2MAC(Ch1: byte): byte;}

//Const
   //Alt decode contants
  { ALT_2_ISO=1;
   ALT_2_KOI=2;
   ALT_2_MAC=3;
   ALT_2_WIN=4;
   //Iso decode contants
   ISO_2_ALT=5;
   ISO_2_KOI=6;
   ISO_2_MAC=7;
   ISO_2_WIN=8;
   //Koi decode contants
   KOI_2_ALT=9;
   KOI_2_ISO=10;
   KOI_2_MAC=11;
   KOI_2_WIN=12;
   //Mac decode contants
   MAC_2_ALT=13;
   MAC_2_ISO=14;
   MAC_2_KOI=15;
   MAC_2_WIN=16;
   //Win decode contants
   WIN_2_ALT=17;
   WIN_2_ISO=18;
   WIN_2_KOI=19;
   WIN_2_MAC=20;}

const
   ALTTable: array [1..64] of byte =(
                                     128, 129, 130, 131, 132, 133, 134, 135,
                                     136, 137, 138, 139, 140, 141, 142, 143,
                                     144, 145, 146, 147, 148, 149, 150, 151,
                                     152, 153, 154, 155, 156, 157, 158, 159,
                                     160, 161, 162, 163, 164, 165, 166, 167,
                                     168, 169, 170, 171, 172, 173, 174, 175,
                                     224, 225, 226, 227, 228, 229, 230, 231,
                                     232, 233, 234, 235, 236, 237, 238, 239
                                     );
   ISOTable: array [1..64] of byte =(
                                     176, 177, 178, 179, 180, 181, 182, 183,
                                     184, 185, 186, 187, 188, 189, 190, 191,
                                     192, 193, 194, 195, 196, 197, 198, 199,
                                     200, 201, 202, 203, 204, 205, 206, 207,
                                     208, 209, 210, 211, 212, 213, 214, 215,
                                     216, 217, 218, 219, 220, 221, 222, 223,
                                     224, 225, 226, 227, 228, 229, 230, 231,
                                     232, 233, 234, 235, 236, 237, 238, 239
                                    );
   KOITable: array [1..64] of byte =(
                                     225, 226, 247, 231, 228, 229, 246, 250,
                                     233, 234, 235, 236, 237, 238, 239, 240,
                                     242, 243, 244, 245, 230, 232, 227, 254,
                                     251, 253, 255, 249, 248, 252, 224, 241,
                                     193, 194, 215, 199, 196, 197, 214, 218,
                                     201, 202, 203, 204, 205, 206, 207, 208,
                                     210, 211, 212, 213, 198, 200, 195, 222,
                                     219, 221, 223, 217, 216, 220, 192, 209
                                    );
   MACTable: array [1..64] of byte =(
                                     128, 129, 130, 131, 132, 133, 134, 135,
                                     136, 137, 138, 139, 140, 141, 142, 143,
                                     144, 145, 146, 147, 148, 149, 150, 151,
                                     152, 153, 154, 155, 156, 157, 158, 159,
                                     224, 225, 226, 227, 228, 229, 230, 231,
                                     232, 233, 234, 235, 236, 237, 238, 239,
                                     240, 241, 242, 243, 244, 245, 246, 247,
                                     248, 249, 250, 251, 252, 253, 254, 223
                                     );
   WINTable: array [1..64] of byte =(
                                     192, 193, 194, 195, 196, 197, 198, 199,
                                     200, 201, 202, 203, 204, 205, 206, 207,
                                     208, 209, 210, 211, 212, 213, 214, 215,
                                     216, 217, 218, 219, 220, 221, 222, 223,
                                     224, 225, 226, 227, 228, 229, 230, 231,
                                     232, 233, 234, 235, 236, 237, 238, 239,
                                     240, 241, 242, 243, 244, 245, 246, 247,
                                     248, 249, 250, 251, 252, 253, 254, 255
                                     );

Function ALT2ISO(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ALTTable[i]=ch1 then begin
   ALT2ISO:=ISOtable[i];
   exit;
  end;
 end;
 ALT2ISO:=ch1;
end;

Function ALT2KOI(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ALTTable[i]=ch1 then begin
   ALT2KOI:=KOItable[i];
   exit;
  end;
 end;
 ALT2KOI:=ch1;
end;

Function ALT2MAC(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ALTTable[i]=ch1 then begin
   ALT2MAC:=MACtable[i];
   exit;
  end;
 end;
 ALT2MAC:=ch1;
end;

Function ALT2WIN(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ALTTable[i]=ch1 then begin
   ALT2WIN:=WINtable[i];
   exit;
  end;
 end;
 ALT2WIN:=ch1;
end;

Function ISO2ALT(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ISOTable[i]=ch1 then begin
   ISO2ALT:=ALTtable[i];
   exit;
  end;
 end;
 ISO2ALT:=ch1;
end;

Function ISO2KOI(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ISOTable[i]=ch1 then begin
   ISO2KOI:=KOItable[i];
   exit;
  end;
 end;
 ISO2KOI:=ch1;
end;

Function ISO2MAC(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ISOTable[i]=ch1 then begin
   ISO2MAC:=MACtable[i];
   exit;
  end;
 end;
 ISO2MAC:=ch1;
end;

Function ISO2WIN(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If ISOTable[i]=ch1 then begin
   ISO2WIN:=WINtable[i];
   exit;
  end;
 end;
 ISO2WIN:=ch1;
end;

Function KOI2ALT(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If KOITable[i]=ch1 then begin
   KOI2ALT:=ALTtable[i];
   exit;
  end;
 end;
 KOI2ALT:=ch1;
end;

Function KOI2ISO(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If KOITable[i]=ch1 then begin
   KOI2ISO:=ISOtable[i];
   exit;
  end;
 end;
 KOI2ISO:=ch1;
end;

Function KOI2MAC(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If KOITable[i]=ch1 then begin
   KOI2MAC:=MACtable[i];
   exit;
  end;
 end;
 KOI2MAC:=ch1;
end;

Function KOI2WIN(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If KOITable[i]=ch1 then begin
   KOI2WIN:=WINtable[i];
   exit;
  end;
 end;
 KOI2WIN:=ch1;
end;

Function MAC2ALT(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If MACTable[i]=ch1 then begin
   MAC2ALT:=ALTtable[i];
   exit;
  end;
 end;
 MAC2ALT:=ch1;
end;

Function MAC2ISO(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If MACTable[i]=ch1 then begin
   MAC2ISO:=ISOtable[i];
   exit;
  end;
 end;
 MAC2ISO:=ch1;
end;

Function MAC2KOI(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If MACTable[i]=ch1 then begin
   MAC2KOI:=KOItable[i];
   exit;
  end;
 end;
 MAC2KOI:=ch1;
end;

Function MAC2WIN(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If MACTable[i]=ch1 then begin
   MAC2WIN:=WINtable[i];
   exit;
  end;
 end;
 MAC2WIN:=ch1;
end;

Function WIN2ALT(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If WINTable[i]=ch1 then begin
   WIN2ALT:=ALTtable[i];
   exit;
  end;
 end;
 WIN2ALT:=ch1;
end;

Function WIN2ISO(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If WINTable[i]=ch1 then begin
   WIN2ISO:=ISOtable[i];
   exit;
  end;
 end;
 WIN2ISO:=ch1;
end;

Function WIN2KOI(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If WINTable[i]=ch1 then begin
   WIN2KOI:=KOItable[i];
   exit;
  end;
 end;
 WIN2KOI:=ch1;
end;

Function WIN2MAC(Ch1: byte): byte;
Var
 i: byte;
begin
 For i:=1 to 64 do begin
  If WINTable[i]=ch1 then begin
   WIN2MAC:=MACtable[i];
   exit;
  end;
 end;
 WIN2MAC:=ch1;
end;

function ConvertString(InputString: string; ttc: TTypeCoding): string;
Var
  i: word;
  b: byte;
begin
   for i:=1 to length(InputString) do begin
    b:=ord(InputString[i]);
    Case ttc of

     ALT_2_ISO: b:=Alt2Iso(b);
     ALT_2_KOI: b:=Alt2Koi(b);
     ALT_2_MAC: b:=Alt2Mac(b);
     ALT_2_WIN: b:=Alt2Win(b);

     ISO_2_ALT: b:=Iso2Alt(b);
     ISO_2_KOI: b:=Iso2Koi(b);
     ISO_2_MAC: b:=Iso2Mac(b);
     ISO_2_WIN: b:=Iso2Win(b);

     KOI_2_ALT: b:=Koi2Alt(b);
     KOI_2_ISO: b:=Koi2Iso(b);
     KOI_2_MAC: b:=Koi2Mac(b);
     KOI_2_WIN: b:=Koi2Win(b);

     MAC_2_ALT: b:=Mac2Alt(b);
     MAC_2_ISO: b:=Mac2Iso(b);
     MAC_2_KOI: b:=Mac2Koi(b);
     MAC_2_WIN: b:=Mac2Win(b);

     WIN_2_ALT: b:=Win2Alt(b);
     WIN_2_ISO: b:=Win2Iso(b);
     WIN_2_KOI: b:=Win2Koi(b);
     WIN_2_MAC: b:=Win2Mac(b);

    end;
    InputString[i]:=chr(b);
   end;

   Result:=InputString;
end;

end.


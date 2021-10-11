unit UIns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus;

type
  TfmIns = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    rbInt: TRadioButton;
    rbFloat: TRadioButton;
    edValue: TEdit;
    cbFloatType: TComboBox;
    cbIntType: TComboBox;
    Label1: TLabel;
    procedure edValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbIntClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure edValueKeyPressInt(Sender: TObject; var Key: Char);
    procedure edValueKeyPressExt(Sender: TObject; var Key: Char);
    procedure WriteFloatValue(wr: TWriter);
    procedure WriteIntegerValue(wr: TWriter);

  public
    { Public declarations }
    function GethexValue: String;
  end;

var
  fmIns: TfmIns;

implementation

{$R *.DFM}

procedure tfmIns.WriteFloatValue(wr: TWriter);
var
  Sin: Single;
  Rel48: Real48;
  Dbl: Double;
  Cur: Currency;
  Ext: Extended;
  Com: Comp;
begin
   case cbFloatType.ItemIndex of
      0:begin
        Rel48:=strtofloat(edValue.text);
        wr.Write(Rel48,sizeof(Real48));
      end;
      1:begin
        sin:=strtofloat(edValue.text);
        wr.Write(sin,sizeof(Single));
      end;
      2:begin
        Dbl:=strtofloat(edValue.text);
        wr.Write(Dbl,sizeof(Double));
      end;
      3:begin
        Ext:=strtofloat(edValue.text);
        wr.Write(Ext,sizeof(Extended));
      end;
      4:begin
        Com:=strtofloat(edValue.text);
        wr.Write(Com,sizeof(Comp));
      end;
      5:begin
        Cur:=StrToCurr(edValue.text);
        wr.Write(Cur,sizeof(Currency));
      end;
    end;
end;

procedure tfmIns.WriteIntegerValue(wr: TWriter);
var
  ShInt: ShortInt;
  SmInt: SmallInt;
  LInt: LongInt;
  I64: Int64;
  Bt: Byte;
  Wd: Word;
  Lw: LongWord;
begin
   case cbIntType.ItemIndex of
      0:begin
        ShInt:=StrToInt64(edValue.Text);
        wr.Write(ShInt,sizeof(ShortInt));
      end;
      1:begin
        SmInt:=StrToInt64(edValue.Text);
        wr.Write(SmInt,sizeof(SmallInt));
      end;
      2:begin
        LInt:=StrToInt64(edValue.Text);
        wr.Write(LInt,sizeof(LongInt));
      end;
      3:begin
        i64:=StrToInt64(edValue.Text);
        wr.Write(i64,sizeof(Int64));
      end;
      4:begin
        Bt:=StrToInt64(edValue.Text);
        wr.Write(Bt,sizeof(Byte));
      end;
      5:begin
        Wd:=StrToInt64(edValue.Text);
        wr.Write(Wd,sizeof(Word));
      end;
      6:begin
        Lw:=StrToInt64(edValue.Text);
        wr.Write(Lw,sizeof(LongWord));
      end;
    end;
end;

function tfmIns.GethexValue: String;
var
  ms: TmemoryStream;
  wr: TWriter;
  i: Integer;
  tmps: string;
  b: byte;
begin
  tmps:='';
  ms:=TmemoryStream.Create;
  wr:=TWriter.Create(ms,4096);
  try
   try
    if rbInt.Checked then begin
     WriteIntegerValue(wr);
    end else begin
     WriteFloatValue(wr);
    end;
   finally
    wr.Free;
   end;
   ms.Position:=0;
   for i:=0 to ms.Size-1 do begin
    ms.Read(b,1);
    tmps:=tmps+inttohex(b,2);
   end;
  finally
   ms.Free;
  end; 
  Result:=tmps;
end;

procedure TfmIns.edValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift)and(key=VK_INSERT)then
   Key:=0;
  
end;

procedure TfmIns.edValueKeyPressInt(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and (Key<>'-')and(Integer(Key)<>VK_Back) then begin
    Key:=char(0);
  end else begin
   if Key='-' then begin
    if Length(TEdit(Sender).Text)<>0 then begin
       Key:=char(0);
    end;
   end;
  end;
end;

procedure TfmIns.edValueKeyPressExt(Sender: TObject; var Key: Char);
var
  APos: Integer;
begin
  if (not (Key in ['0'..'9']))and (Key<>DecimalSeparator)
         and(Integer(Key)<>VK_Back)and (Key<>'-') then begin
    Key:=char(0);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(0);
   end;
   if Key='-' then begin
    if Length(TEdit(Sender).Text)<>0 then begin
       Key:=char(0);
    end;
   end;
  end;
end;

procedure TfmIns.rbIntClick(Sender: TObject);
begin
  if rbInt.Checked then begin
   edValue.OnKeyPress:=edValueKeyPressInt;
   edValue.MaxLength:=Length(inttostr(Low(Int64)));
   edValue.Clear;
   cbFloatType.Enabled:=false;
   cbIntType.Enabled:=true;
  end else begin
   edValue.OnKeyPress:=edValueKeyPressExt;
   edValue.MaxLength:=120;
   edValue.Clear;
   cbFloatType.Enabled:=true;
   cbIntType.Enabled:=false;
  end;
end;

procedure TfmIns.FormCreate(Sender: TObject);
begin
  edValue.OnKeyPress:=edValueKeyPressInt;
  edValue.MaxLength:=Length(inttostr(Low(Int64)));
  cbFloatType.ItemIndex:=0;
  cbIntType.ItemIndex:=0;
end;

procedure TfmIns.BitBtn1Click(Sender: TObject);
begin
  if rbInt.Checked then begin
    try
     StrToInt64(edValue.Text);
    except on E: Exception do begin
{      MessageBox(Application.handle,Pchar('Value '+edValue.Text+#13+
                              'must be from '+inttostr(Low(int64))+#13+
                              'to '+inttostr(High(Int64))),
                nil,MB_ICONERROR);}
      MessageBox(Application.handle,Pchar(E.Message),
                nil,MB_ICONERROR);
                
      exit;
     end;
    end;
  end else begin
    try
     StrToFloat(edValue.Text);
    except on E: Exception do begin
      MessageBox(Application.handle,Pchar(E.Message),
                nil,MB_ICONERROR);
      exit;
     end;
    end;
  end;
  Modalresult:=mrOk;
end;


end.

unit UAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, yupack, shellapi;

type
  TfmAbout = class(TForm)
    Panel1: TPanel;
    pnParent: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    lbVer: TLabel;
    pn: TPanel;
    Label7: TLabel;
    lbTom: TLabel;
    lbTotalPhys: TLabel;
    lbMemLoad: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbTomClick(Sender: TObject);
  private
    lbShevY: TYuSoftLabel;
    lbIsaevY: TYuSoftLabel;
    lbTomY: TYuSoftLabel;

  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.DFM}

procedure TfmAbout.FormCreate(Sender: TObject);
var
  T: TmemoryStatus;
  dwHandle: DWord;
  dwLen: DWord;
  lpData: Pointer;
  v1,v2,v3,v4: Word;
  tmps: string;
  VerValue: PVSFixedFileInfo;
  dMem: LongWord;
  Percent: Extended;
begin
  lbTomY:=TYuSoftLabel.Create(nil);
  lbTomY.Parent:=pn;
  lbTomY.BoundsRect:=lbTom.BoundsRect;
  lbTomY.Alignment:=taLeftJustify;
//  lbTomY.Align:=alClient;
  lbTomY.Layout:=tlCenter;
  lbTomY.AutoSize:=false;
  lbTomY.Caption:=lbTom.Caption;
  lbTomY.Font.Assign(lbTom.Font);
  lbTomY.OnClickState.Active:=true;
  lbTomY.OnClickState.BorderColor:=clAqua;
  lbTomY.OnClickState.BorderWidth:=1;
  lbTomY.OnClick:=lbTom.OnClick;
  lbTomY.ShowHint:=true;
  lbTomY.Hint:=lbTom.Hint;

  GlobalMemoryStatus(T);
  lbTotalPhys.Caption:='Available memory: '+inttostr(round(T.dwTotalPhys/(1024)))+' KB';
  dMem:=T.dwTotalPhys-T.dwAvailPhys;
  Percent:=(dMem/T.dwTotalPhys)*100;
  lbMemLoad.Caption:='Memory load: '+FormatFloat('0',Percent)+' %';

  dwLen:=GetFileVersionInfoSize(Pchar(Application.ExeName),dwHandle);
  if dwlen<>0 then begin
   GetMem(lpData, dwLen);
   try
    if GetFileVersionInfo(Pchar(Application.ExeName),dwHandle,dwLen,lpData) then begin
      VerQueryValue(lpData, '\', Pointer(VerValue), dwLen);
      V1 := VerValue.dwFileVersionMS shr 16;
      V2 := VerValue.dwFileVersionMS and $FFFF;
      V3 := VerValue.dwFileVersionLS shr 16;
      V4 := VerValue.dwFileVersionLS and $FFFF;
      tmps:=inttostr(V1)+'.'+inttostr(V2)+'.'+inttostr(V3)+'.'+inttostr(V4);
      lbVer.Caption:=lbVer.Caption+' '+tmps;
    end;
   finally
     FreeMem(lpData, dwLen); 
   end;
   end;
end;

procedure TfmAbout.FormDestroy(Sender: TObject);
begin
  lbShevY.Free;
  lbIsaevY.Free;
  lbTomY.Free;
end;


procedure TfmAbout.lbTomClick(Sender: TObject);
var
  tmps: string;
begin
  tmps:=TYuSoftLabel(Sender).Hint;
{  shellExecute(self.Handle,
               PChar('open'),
               Pchar(tmps),
               nil,
               nil,
               SW_SHOWNORMAL);}
end;

end.

unit UChange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus, USearch, UIns;

type
  TfmChange = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    edAddr: TEdit;
    Label2: TLabel;
    edOldValue: TEdit;
    Label3: TLabel;
    edNewValue: TEdit;
    cbType: TComboBox;
    Label4: TLabel;
    btOldIns: TBitBtn;
    btNewIns: TBitBtn;
    Label5: TLabel;
    edHint: TEdit;
    procedure edAddrKeyPress(Sender: TObject; var Key: Char);
    procedure btOkClick(Sender: TObject);
    procedure edOldValueChange(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure edAddrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btOldInsClick(Sender: TObject);
    procedure btNewInsClick(Sender: TObject);
  private
  public
    OldItemIndex: Integer;
  end;

var
  fmChange: TfmChange;

implementation

{$R *.DFM}

procedure TfmChange.edAddrKeyPress(Sender: TObject; var Key: Char);
var
  ch:char;
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Char(Key) in ['A'..'F']))and (not(Char(Key) in ['a'..'f']))then begin
    Key:=Char(nil);
  end else begin
    if char(Key) in ['a'..'f'] then begin
      ch:=Char(Key);
      Dec(ch, 32);
      Char(Key):=ch;
    end;
  end;
end;

procedure TfmChange.btOkClick(Sender: TObject);
begin
  if trim(edAddr.Text)='' then begin
   ShowMessage('Input Address !');
   edAddr.SetFocus;
   exit;
  end;
  if trim(edOldValue.Text)='' then begin
   ShowMessage('Input Oldvalue !');
   edOldValue.SetFocus;
   exit;
  end;
  if Length(edNewvalue.text)<>edNewvalue.MaxLength then begin
   ShowMessage('Length of NewValue must be '+inttostr(edNewvalue.MaxLength)+' !');
   edNewvalue.SetFocus;
   exit;
  end;
  Modalresult:=mrOk;
end;

procedure TfmChange.edOldValueChange(Sender: TObject);
begin
    edNewValue.MaxLength:=length(edOldValue.Text);
end;

procedure TfmChange.cbTypeChange(Sender: TObject);
begin
  if cbType.ItemIndex=OldItemIndex then exit;
  OldItemIndex:=cbType.ItemIndex;
  if cbType.ItemIndex=0 then begin
    edOldValue.OnKeyPress:=nil;
    edNewValue.OnKeyPress:=nil;
    edOldValue.Text:=GetStringFromHex(edOldValue.Text);
    edNewValue.Text:=GetStringFromHex(edNewValue.Text);
    btOldIns.Enabled:=false;
    btNewIns.Enabled:=false;
  end else begin
    edOldValue.OnKeyPress:=edAddrKeyPress;
    edNewValue.OnKeyPress:=edAddrKeyPress;
    edOldValue.Text:=GetHexFromString(edOldValue.Text);
    edNewValue.Text:=GetHexFromString(edNewValue.Text);
    btOldIns.Enabled:=true;
    btNewIns.Enabled:=true;
  end;
end;

procedure TfmChange.edAddrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift)and(key=VK_INSERT)then
   Key:=0;
 
end;

procedure TfmChange.btOldInsClick(Sender: TObject);
begin
  if fmIns.ShowModal=mrOk then begin
    edOldValue.Text:=fmIns.gethexvalue;
  end;
end;

procedure TfmChange.btNewInsClick(Sender: TObject);
begin
  if fmIns.ShowModal=mrOk then begin
    edNewValue.Text:=fmIns.gethexvalue;
  end;
end;

end.

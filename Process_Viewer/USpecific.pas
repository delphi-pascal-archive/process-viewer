unit USpecific;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmSpecific = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    rbNewValue: TRadioButton;
    rbOldValue: TRadioButton;
    rbType: TRadioButton;
    rbAddress: TRadioButton;
    edValue: TEdit;
    Label1: TLabel;
    rbHint: TRadioButton;
    GroupBox2: TGroupBox;
    rbRemove: TRadioButton;
    rbSelect: TRadioButton;
    rbCheck: TRadioButton;
    rbChange: TRadioButton;
    edChange: TEdit;
    procedure btOkClick(Sender: TObject);
    procedure rbChangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSpecific: TfmSpecific;

implementation

{$R *.DFM}

procedure TfmSpecific.btOkClick(Sender: TObject);
begin
  if not rbChange.Checked then
   if trim(edValue.Text)='' then begin
    ShowMessage('Input Value !');
    edValue.SetFocus;
    exit;
   end;
  ModalResult:=mrOk;
end;

procedure TfmSpecific.rbChangeClick(Sender: TObject);
begin
  edChange.Enabled:=rbChange.Checked;
  if edChange.Enabled then edChange.Color:=clWindow
  else edChange.Color:=clBtnFace;
end;

end.

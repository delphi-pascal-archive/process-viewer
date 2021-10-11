unit USendMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmSendMes = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btSend: TBitBtn;
    BitBtn2: TBitBtn;
    lbHWND: TLabel;
    edHWND: TEdit;
    lbMessage: TLabel;
    edMessage: TEdit;
    lbwParam: TLabel;
    edwParam: TEdit;
    lblParam: TLabel;
    edlParam: TEdit;
    btMess: TBitBtn;
    rbHex: TRadioButton;
    rbDec: TRadioButton;
    procedure btSendClick(Sender: TObject);
    procedure btMessClick(Sender: TObject);
    procedure rbHexClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure edHexKeyPress(Sender: TObject; var Key: Char);
    procedure edIntKeyPress(Sender: TObject; var Key: Char);
  public

    { Public declarations }
  end;

var
  fmSendMes: TfmSendMes;

implementation

uses UMessages;

{$R *.DFM}

procedure TfmSendMes.btSendClick(Sender: TObject);
begin
  if Trim(edHWND.Text)='' then begin
    MessageBox(Application.Handle,pchar('Field <'+lbHWND.Caption+'> is empty.'),'Ошибка',MB_ICONERROR);
    edHWND.SetFocus;
    exit;
  end;
  if Trim(edMessage.Text)='' then begin
    MessageBox(Application.Handle,pchar('Field <'+lbMessage.Caption+'> is empty.'),'Ошибка',MB_ICONERROR);
    btMess.SetFocus;
    exit;
  end;
  if Trim(edwParam.Text)='' then begin
    MessageBox(Application.Handle,pchar('Field <'+lbwParam.Caption+'> is empty.'),'Ошибка',MB_ICONERROR);
    edwParam.SetFocus;
    exit;
  end;
  if Trim(edlParam.Text)='' then begin
    MessageBox(Application.Handle,pchar('Field <'+lblParam.Caption+'> is empty.'),'Ошибка',MB_ICONERROR);
    edlParam.SetFocus;
    exit;
  end;
  
  Modalresult:=mrOk;
end;

procedure TfmSendMes.btMessClick(Sender: TObject);
begin
  fmMess.FillMessages;
  fmMess.FormStyle:=FormStyle;
  if Trim(edMessage.Text)<>'' then begin
   if rbHex.Checked then begin
    fmMess.LocateToId(strtoint('$'+edMessage.Text));
   end else begin
    fmMess.LocateToId(strtoint('$'+inttohex(strtoint(edMessage.Text),8)));
   end;
  end; 
  if fmMess.ShowModal=mrOk then begin
   if rbHex.Checked then begin
    edMessage.Text:=fmMess.getid;
   end else begin
    edMessage.Text:=inttostr(strtoint('$'+fmMess.getid));
   end;
  end;
end;

procedure TfmSendMes.rbHexClick(Sender: TObject);
begin
  if Sender=rbHex then begin
   edHWND.OnKeyPress:=edHexKeyPress;
   edHWND.MaxLength:=8;
   if Trim(edHWND.Text)<>'' then edHWND.Text:=inttohex(strtoint(edHWND.Text),8);
   edMessage.OnKeyPress:=edHexKeyPress;
   edMessage.MaxLength:=8;
   if Trim(edMessage.Text)<>'' then edMessage.Text:=inttohex(strtoint(edMessage.Text),8);
   edwParam.OnKeyPress:=edHexKeyPress;
   edwParam.MaxLength:=8;
   if Trim(edwParam.Text)<>'' then edwParam.Text:=inttohex(strtoint(edwParam.Text),8);
   edlParam.OnKeyPress:=edHexKeyPress;
   edlParam.MaxLength:=8;
   if Trim(edlParam.Text)<>'' then edlParam.Text:=inttohex(strtoint(edlParam.Text),8);
  end else begin
   edHWND.OnKeyPress:=edIntKeyPress;
   edHWND.MaxLength:=16;
   if Trim(edHWND.Text)<>'' then edHWND.Text:=Inttostr(strtoint('$'+edHWND.Text));
   edMessage.OnKeyPress:=edIntKeyPress;
   edMessage.MaxLength:=16;
   if Trim(edMessage.Text)<>'' then edMessage.Text:=Inttostr(strtoint('$'+edMessage.Text));
   edwParam.OnKeyPress:=edIntKeyPress;
   edwParam.MaxLength:=16;
   if Trim(edwParam.Text)<>'' then edwParam.Text:=Inttostr(strtoint('$'+edwParam.Text));
   edlParam.OnKeyPress:=edIntKeyPress;
   edlParam.MaxLength:=16;
   if Trim(edlParam.Text)<>'' then edlParam.Text:=Inttostr(strtoint('$'+edlParam.Text));
  end;
end;

procedure TfmSendMes.edIntKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmSendMes.edHexKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmSendMes.FormCreate(Sender: TObject);
begin
  edHWND.OnKeyPress:=edHexKeyPress;
  edMessage.OnKeyPress:=edHexKeyPress;
  edwParam.OnKeyPress:=edHexKeyPress;
  edlParam.OnKeyPress:=edHexKeyPress;
end;

end.

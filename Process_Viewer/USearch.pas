unit USearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus, UIns;

type

{  TProtectPage=(ppPAGE_READONLY,
                ppPAGE_READWRITE,
                ppPAGE_WRITECOPY,
                ppPAGE_EXECUTE,
                ppPAGE_EXECUTE_READ,
                ppPAGE_EXECUTE_READWRITE,
                ppPAGE_EXECUTE_WRITECOPY,
                ppPAGE_GUARD,
                ppPAGE_NOACCESS,
                ppPAGE_NOCACHE);}


  TfmSearch = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    edStartAddr: TEdit;
    rbString: TRadioButton;
    edString: TEdit;
    rbHex: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    cbCase: TCheckBox;
    cbStop: TCheckBox;
    btMore: TBitBtn;
    GroupBox1: TGroupBox;
    chbPAGE_READONLY: TCheckBox;
    chbPAGE_READWRITE: TCheckBox;
    chbPAGE_WRITECOPY: TCheckBox;
    chbPAGE_EXECUTE: TCheckBox;
    chbPAGE_EXECUTE_READ: TCheckBox;
    chbPAGE_EXECUTE_READWRITE: TCheckBox;
    chbPAGE_EXECUTE_WRITECOPY: TCheckBox;
    chbPAGE_GUARD: TCheckBox;
    chbPAGE_NOACCESS: TCheckBox;
    chbPAGE_NOCACHE: TCheckBox;
    btIns: TBitBtn;
    cbOnlyModules: TCheckBox;
    cbShowTime: TCheckBox;
    chbCheck: TCheckBox;
    cbFast: TCheckBox;
    cbFinish: TComboBox;
    cbWithOutM: TCheckBox;
    cbNoInfo: TCheckBox;
    cbSuper: TCheckBox;
    Label4: TLabel;
    cbDeltaPrioritet: TComboBox;
    Label5: TLabel;
    cbBasePrioritet: TComboBox;
    cbInfo: TCheckBox;
    cbPreSearch: TCheckBox;
    procedure edStartAddrKeyPress(Sender: TObject; var Key: Char);
    procedure rbHexClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btMoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbCheckClick(Sender: TObject);
    procedure edStartAddrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btInsClick(Sender: TObject);
    procedure cbOnlyModulesClick(Sender: TObject);
    procedure cbFastClick(Sender: TObject);
    procedure cbWithOutMClick(Sender: TObject);
    procedure cbSuperClick(Sender: TObject);
    procedure cbFinishChange(Sender: TObject);
  private
    procedure EnabledCheck(Enab: Boolean);
    procedure StringKeyPress(Sender: TObject; var Key: Char);
  public
    { Public declarations }
  end;

  function GetHexFromString(str: string): String;
  function GetStringFromHex(str: string): String;

var
  fmSearch: TfmSearch;

implementation

{$R *.DFM}

procedure TfmSearch.edStartAddrKeyPress(Sender: TObject; var Key: Char);
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

function GetHexFromString(str: string): String;
var
  i: Integer;
  hexstr: string;
  ch: char;
  tmps: string;
begin
 hexstr:='';
 for i:=0 to Length(str)-1 do begin
  ch:=str[i+1];
  tmps:=inttohex(Integer(ch),1);
  if Odd(Length(tmps)) then tmps:='0'+tmps;
  hexstr:=hexstr+tmps;
 end;
 if Odd(Length(hexstr))then result:='0'+hexstr
 else Result:=hexstr;
end;

function GetStringFromHex(str: string): String;
var
  i: Integer;
  newstr: string;
  ch: char;
begin
 newstr:='';
 if Odd(Length(str)) then begin
   for i:=0 to Length(str)-1 do begin
     if i=0 then begin
      ch:=Char(strtoint('$0'+str[i+1]));
      newstr:=newstr+ch;
     end;
     if Odd(i) then begin
      ch:=Char(strtoint('$'+str[i+1]+str[i+2]));
      newstr:=newstr+ch;
     end; 
   end;
 end else begin
   for i:=0 to Length(str)-1 do begin
     if not Odd(i) then begin
      ch:=Char(strtoint('$'+str[i+1]+str[i+2]));
      newstr:=newstr+ch;
     end;
   end;
 end;
 Result:=newstr;
end;

procedure TfmSearch.rbHexClick(Sender: TObject);
begin
  if rbString.Checked then begin
   edString.OnKeyPress:=StringKeyPress;
   edString.Text:=GetStringFromHex(edString.Text);
   cbcase.Enabled:=true;
   btIns.Enabled:=false;
  end else begin
   edString.OnKeyPress:=edStartAddrKeyPress;
   edString.Text:=GetHexFromString(edString.Text);
   cbcase.Enabled:=false;
   btIns.Enabled:=true;
  end;
end;

procedure TfmSearch.BitBtn1Click(Sender: TObject);
begin
  if trim(edStartAddr.Text)='' then begin
   ShowMessage('Input Start Address !');
   edStartAddr.SetFocus;
   exit;
  end;

  if trim(cbFinish.Text)='' then begin
   ShowMessage('Input Finish Address !');
   cbFinish.SetFocus;
   exit;
  end;

   if Trim(edString.text)='' then begin
    ShowMessage('Input Search Value !');
    edString.SetFocus;
    exit;
   end;
  Modalresult:=mrOk;
end;

procedure TfmSearch.btMoreClick(Sender: TObject);
begin
   if btMore.caption='More ->' then begin
     btMore.Caption:='<- Less';
     Self.Width:=406;
     Self.left:=(Screen.Width div 2)-(Self.Width div 2)
   end else begin
     btMore.caption:='More ->';
     Self.Width:=208;
     Self.left:=(Screen.Width div 2)-(Self.Width div 2)
   end;
 {  Refresh;
   update;
   Repaint;
   Invalidate;
   GroupBox1.Invalidate;  }
end;

procedure TfmSearch.FormCreate(Sender: TObject);
begin
     Self.Width:=208;
     Self.left:=(Screen.Width div 2)-(Self.Width div 2);
     edString.OnKeyPress:=StringKeyPress;
     cbFinish.ItemIndex:=1;
//     cbBasePrioritet.ItemIndex:=cbBasePrioritet.Items.Count-1;
  //   cbDeltaprioritet.ItemIndex:=cbDeltaprioritet.Items.Count-1;
     cbBasePrioritet.ItemIndex:=1;
     cbDeltaprioritet.ItemIndex:=1;

end;


procedure TfmSearch.chbCheckClick(Sender: TObject);
  procedure CheckAll(Check: Boolean);
  begin
    chbPAGE_READONLY.Checked:=Check;
    chbPAGE_READWRITE.Checked:=Check;
    chbPAGE_WRITECOPY.Checked:=Check;
    chbPAGE_EXECUTE.Checked:=Check;
    chbPAGE_EXECUTE_READ.Checked:=Check;
    chbPAGE_EXECUTE_READWRITE.Checked:=Check;
    chbPAGE_EXECUTE_WRITECOPY.Checked:=Check;
    chbPAGE_GUARD.Checked:=Check;
    chbPAGE_NOACCESS.Checked:=Check;
    chbPAGE_NOCACHE.Checked:=Check;
  end;
begin
  CheckAll(chbCheck.Checked);
end;

procedure TfmSearch.edStartAddrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift)and(key=VK_INSERT)then
   Key:=0;
end;

procedure TfmSearch.btInsClick(Sender: TObject);
begin
  fmIns.FormStyle:=FormStyle;
  if fmIns.ShowModal=mrOk then begin
    edString.Text:=fmIns.gethexvalue;
  end;
end;

procedure TfmSearch.cbOnlyModulesClick(Sender: TObject);
begin
   if cbOnlyModules.Checked then begin
     cbWithOutM.Enabled:=false;
   end else begin
     cbWithOutM.Enabled:=true;
   end;
end;

procedure TfmSearch.cbFastClick(Sender: TObject);
begin
//  EnabledCheck(not cbfast.Checked);
  cbSuper.Enabled:=not cbfast.Checked;
end;

procedure TfmSearch.EnabledCheck(Enab: Boolean);
begin
//    chbPAGE_READONLY.Enabled:=Enab;
//    chbPAGE_READWRITE.Enabled:=Enab;
    chbPAGE_WRITECOPY.Enabled:=Enab;
    chbPAGE_EXECUTE.Enabled:=Enab;
    chbPAGE_EXECUTE_READ.Enabled:=Enab;
    chbPAGE_EXECUTE_READWRITE.Enabled:=Enab;
    chbPAGE_EXECUTE_WRITECOPY.Enabled:=Enab;
    chbPAGE_GUARD.Enabled:=Enab;
    chbPAGE_NOACCESS.Enabled:=Enab;
    chbPAGE_NOCACHE.Enabled:=Enab;

  //  chbPAGE_READONLY.Checked:=Enab;
  //  chbPAGE_READWRITE.Checked:=Enab;
    chbPAGE_WRITECOPY.Checked:=Enab;
    chbPAGE_EXECUTE.Checked:=Enab;
    chbPAGE_EXECUTE_READ.Checked:=Enab;
    chbPAGE_EXECUTE_READWRITE.Checked:=Enab;
    chbPAGE_EXECUTE_WRITECOPY.Checked:=Enab;
    chbPAGE_GUARD.Checked:=Enab;
    chbPAGE_NOACCESS.Checked:=Enab;
    chbPAGE_NOCACHE.Checked:=Enab;
    chbCheck.Enabled:=Enab;

end;

procedure TfmSearch.cbWithOutMClick(Sender: TObject);
begin
  if cbWithOutM.Checked then begin
   cbOnlyModules.Enabled:=false;
  end else begin
   cbOnlyModules.Enabled:=true;
  end; 
end;

procedure TfmSearch.cbSuperClick(Sender: TObject);
begin
  if cbSuper.Checked then begin
    cbPreSearch.Enabled:=true;
    cbfast.Checked:=false;
    cbfast.Enabled:=false;
    cbNoInfo.Checked:=false;
    cbNoInfo.Enabled:=false;
    cbStop.Checked:=false;
    cbStop.Enabled:=false;
//    EnabledCheck(not cbSuper.Checked);
  end else begin
    cbPreSearch.Enabled:=false;
    cbfast.Enabled:=true;
    cbNoInfo.Enabled:=true;
    cbStop.Enabled:=true;
//    EnabledCheck(not cbSuper.Checked);
  end;
end;

procedure TfmSearch.StringKeyPress(Sender: TObject; var Key: Char);
begin
  { if (Key >= 'a') and (Key <= 'z') then Dec(Key, 32);
   if (Key >= 'à') and (Key <= 'ÿ') then Dec(Key, 32);}
end;


procedure TfmSearch.cbFinishChange(Sender: TObject);
begin
 if not cbInfo.Checked then exit;
  case cbFinish.ItemIndex of
    0:MessageBox(Application.Handle,Pchar('This address space of process Windows Aplications.'+#13+
                 'Size from zero: 1 GByte.'),
                 pchar('Information'),MB_OK+MB_ICONINFORMATION);
    1:MessageBox(Application.Handle,Pchar('This address space of process Windows Aplications.'+#13+
                 'Size from zero: 2 GByte.'),
                 pchar('Information'),MB_OK+MB_ICONINFORMATION);
    2:MessageBox(Application.Handle,Pchar('This address space of process Dos Aplications.'+#13+
                 'Size from zero: 3 GByte.'),
                 pchar('Warning'),MB_OK+MB_ICONWARNING);
    3:MessageBox(Application.Handle,Pchar('This address space of process System Dll.'+#13+
                 'Size from zero: 4 GByte.'),
                 pchar('Warning'),MB_OK+MB_ICONWARNING);
  end;
end;

end.

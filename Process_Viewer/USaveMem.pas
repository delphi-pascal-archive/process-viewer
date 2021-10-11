unit USaveMem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, PCGrids;

type
  TfmSaveMem = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    pnModule: TPanel;
    pnAddr: TPanel;
    pnTop: TPanel;
    Label1: TLabel;
    cbOper: TComboBox;
    Label2: TLabel;
    cbModule: TComboBox;
    Label3: TLabel;
    edStart: TEdit;
    edFinish: TEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbOperChange(Sender: TObject);
    procedure edStartKeyPress(Sender: TObject; var Key: Char);
    procedure cbModuleChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    FileName: string;
    CurPageStart,CurPageFinish: LongWord;
    ModuleStart,ModuleFinish: Longword;
    procedure FillModule(cb: TComboBox);
    procedure SetPosition;
  end;

var
  fmSaveMem: TfmSaveMem;

implementation

{$R *.DFM}

uses UDump;

procedure TfmSaveMem.FillModule(cb: TComboBox);
var
  i: Integer;
  p: PinfoModules;
begin
  cbModule.Clear;
  for i:=0 to cb.Items.Count-1 do begin
    P:=PinfoModules(cb.Items.Objects[i]);
    cbModule.Items.AddObject(P.Name,TObject(P));
  end;
  if cbModule.Items.Count=0 then exit;
  cbModule.ItemIndex:=0;
  ModuleStart:=PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Address;
  ModuleFinish:=PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Address+
                PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Size;
  edStart.Text:=inttohex(ModuleStart,8);
  edFinish.Text:=inttohex(ModuleFinish,8);
end;

procedure TfmSaveMem.FormCreate(Sender: TObject);
begin
  Height:=180;
  Width:=225;
  cbOper.ItemIndex:=1;
  SetPosition;
end;

procedure TfmSaveMem.cbOperChange(Sender: TObject);
begin
  pnAddr.Align:=alNone;
  pnModule.Align:=alNone;
  pnAddr.Align:=alTop;
  pnModule.Align:=alTop;
  case cbOper.ItemIndex of
    0:begin
     Height:=150;
     pnModule.Visible:=false;
     pnAddr.Visible:=true;
     edStart.ReadOnly:=true;
     edStart.Color:=clBtnface;
     edFinish.ReadOnly:=true;
     edFinish.Color:=clBtnface;
     edStart.Text:=inttohex(CurPageStart,8);
     edFinish.Text:=inttohex(CurPageFinish,8);
    end;
    1: begin
     Height:=180;
     pnAddr.Visible:=true;
     pnModule.Visible:=true;
     edStart.ReadOnly:=false;
     edStart.Color:=clWindow;
     edFinish.ReadOnly:=false;
     edFinish.Color:=clWindow;
     edStart.Text:=inttohex(ModuleStart,8);
     edFinish.Text:=inttohex(ModuleFinish,8);
    end;
    2: begin
     Height:=150;
     pnModule.Visible:=false;
     pnAddr.Visible:=true;
     edStart.ReadOnly:=false;
     edStart.Color:=clWindow;
     edFinish.ReadOnly:=false;
     edFinish.Color:=clWindow;
    end;
  end;
  SetPosition;
end;

procedure TfmSaveMem.SetPosition;
begin
  Left:=Screen.Width div 2 -Width div 2;
  Top:= Screen.Height div 2 - Height div 2;
end;

procedure TfmSaveMem.edStartKeyPress(Sender: TObject; var Key: Char);
var
  ch:char;
begin
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
    Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
  end;
end;

procedure TfmSaveMem.cbModuleChange(Sender: TObject);
begin
  if cbModule.Items.Count=0 then exit;
  ModuleStart:=PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Address;
  ModuleFinish:=PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Address+
                PinfoModules(cbModule.Items.Objects[cbModule.ItemIndex]).Size;
  edStart.Text:=inttohex(ModuleStart,8);
  edFinish.Text:=inttohex(ModuleFinish,8);
end;

procedure TfmSaveMem.BitBtn1Click(Sender: TObject);
var
 sd: TSaveDialog;
 tmps: string;
begin
  case cbOper.ItemIndex of
    0: tmps:='Mem_.dat';
    1: begin
      tmps:='Mem_'+cbModule.Text;
      try
        strtoint('$'+edStart.Text);
        strtoint('$'+edFinish.Text);
      except
        begin
          MessageBox(Application.Handle,Pchar('Invalid Start or Finish Address.'),nil,MB_OK+MB_ICONERROR);
          exit;
        end;
      end;
    end;
    2:tmps:='Mem_.dat';

  end;
  sd:=TSaveDialog.Create(nil);
  sd.Options:=sd.Options+[ofOverwritePrompt];
  sd.Filter:='(All files *.*)|*.*';
  sd.InitialDir:=ExtractFileDir(Application.Exename);
  sd.FileName:=tmps;
  if Sd.Execute then begin
    FileName:=Sd.FileName;
  end else begin
    sd.Free;
    exit;
  end;
  sd.Free;
  modalResult:=mrOk;
end;

end.

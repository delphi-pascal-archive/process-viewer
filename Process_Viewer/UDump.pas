unit UDump;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, PCGrids, ExtCtrls, TlHelp32, ComCtrls, Menus, UChange,
  Spin, CommCtrl, USpecific, USaveMem, Grids, psapi;

type

  PinfoModules=^TInfoModules;
  TInfoModules=packed record
    Address: Longword;
    Size: LongWord;
    Name: string;
  end;

  PInfoSearch=^TInfoSearch;
  TInfoSearch=packed record
    Address: LongWord;
    Value: String;
    TypeValue: Integer;
    LengthValue: Integer;
  end;

  PInfoHeaps=^TInfoHeaps;
  TInfoHeaps=packed record
    dwSize: DWORD;
    th32ProcessID: DWORD;  // owning process
    th32HeapID: DWORD;     // heap (in owning process's context!)
    dwFlags: DWORD;
    PHEList: TList;
  end;

  TfmDumpMem = class(TForm)
    Panel3: TPanel;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    btClose: TBitBtn;
    Panel5: TPanel;
    sg: TStringGrid;
    Panel6: TPanel;
    btPrev: TBitBtn;
    btNext: TBitBtn;
    btInfo: TBitBtn;
    btrefresh: TBitBtn;
    btSearch: TBitBtn;
    Panel7: TPanel;
    GroupBox3: TGroupBox;
    lbAllocationBase: TLabel;
    lbState: TLabel;
    lbBaseAddress: TLabel;
    lbRegionSize: TLabel;
    lbType_9: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    lbModule: TLabel;
    btGo: TBitBtn;
    Label33: TLabel;
    Panel8: TPanel;
    LV: TListView;
    pm: TPopupMenu;
    miGotoAddr: TMenuItem;
    N1: TMenuItem;
    miRemove: TMenuItem;
    miRemoveAll: TMenuItem;
    miChange: TMenuItem;
    Panel9: TPanel;
    btApply: TBitBtn;
    miAdd: TMenuItem;
    N2: TMenuItem;
    pmRO: TPopupMenu;
    pmSETime: TPopupMenu;
    cbOnTimer: TCheckBox;
    cbRef: TCheckBox;
    edTime: TEdit;
    udTime: TUpDown;
    tm: TTimer;
    cbStart: TComboBox;
    btSave: TBitBtn;
    btLoad: TBitBtn;
    sd: TSaveDialog;
    od: TOpenDialog;
    miAddToLV: TMenuItem;
    cbMulti: TCheckBox;
    miSpec: TMenuItem;
    lbCount: TLabel;
    btStopFill: TBitBtn;
    btSaveMem: TBitBtn;
    btClearMem: TBitBtn;
    N3: TMenuItem;
    miFont: TMenuItem;
    fd: TFontDialog;
    cbProtect: TComboBox;
    lbAllocProtect: TLabel;
    miView: TMenuItem;
    N4: TMenuItem;
    miViewHex: TMenuItem;
    miViewString: TMenuItem;
    pnMemo: TPanel;
    re: TMemo;
    pnMemoTop: TPanel;
    lbCoding: TLabel;
    cmbCoding: TComboBox;
    bibCodingBack: TBitBtn;
    bibCodingDefault: TBitBtn;
    chbCodingClear: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure sgKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btPrevClick(Sender: TObject);
    procedure btGoClick(Sender: TObject);
    procedure edStartKeyPress(Sender: TObject; var Key: Char);
    procedure btInfoClick(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btrefreshClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure pmPopup(Sender: TObject);
    procedure miGotoAddrClick(Sender: TObject);
    procedure miRemoveClick(Sender: TObject);
    procedure miRemoveAllClick(Sender: TObject);
    procedure LVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVDblClick(Sender: TObject);
    procedure LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure miChangeClick(Sender: TObject);
    procedure miAddClick(Sender: TObject);
    procedure sgExit(Sender: TObject);
    procedure sgSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btApplyClick(Sender: TObject);
    procedure seTimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seTimeKeyPress(Sender: TObject; var Key: Char);
    procedure edStartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbOnTimerClick(Sender: TObject);
    procedure udTimeChanging(Sender: TObject; var AllowChange: Boolean);
    procedure tmTimer(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure miAddToLVClick(Sender: TObject);
    procedure pmROPopup(Sender: TObject);
    procedure sgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbMultiClick(Sender: TObject);
    procedure miSpecClick(Sender: TObject);
    procedure btStopFillClick(Sender: TObject);
    procedure btSaveMemClick(Sender: TObject);
    procedure LVCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure sgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btClearMemClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure cbProtectChange(Sender: TObject);
    procedure miViewStringClick(Sender: TObject);
    procedure cmbCodingChange(Sender: TObject);
    procedure bibCodingBackClick(Sender: TObject);
    procedure bibCodingDefaultClick(Sender: TObject);
  private
    defaultStr: string;
    LastAllocProtectIndex: Integer;
    BreakFill: Boolean;
    MaxSize: LongWord;
    Col17Change: Boolean;
    OldText: String;
    OldRow,OldCol: Integer;
    glSortSubItem:integer;
    glSortForward:boolean;
    ListHeaps: TList;
    ListSearch: TList;
    CurrMemAddr: LongWord;
    PageSize: LongWord;
    ListStepCoding: TList;

    procedure ClearListSearch;
    procedure AddToListSearch(Addr: LongWord; Value: String; TypeValue: Integer; LengthValue: Integer);
    function getAllocationProtect(AllocationProtect: Integer): String;
    function getState(State: Integer): string;
    function getType_9(Type_9: integer): string;
    procedure lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
                           Data: Integer; var Compare: Integer);
    procedure lvCompareInt(Sender: TObject; Item1, Item2: TListItem;
     Data: Integer; var Compare: Integer);{compare by int}
    procedure SetTextFromHex(Hideedit: Boolean);
    procedure SetTextFromChar(Text: String; col,row: Integer);
    procedure SetTextFromText(Text,Value: String; col,row: Integer);
    procedure ApplyPage(CurAddr: LongWord; Question: Boolean);
    procedure ApplyListView;
    procedure ClearComboBox;
    procedure SetColumnWidth;
    function ColRowInRect(rc:TGridrect; Col,Row: Integer): Boolean;
    procedure ClearSelectionInGrid;
    procedure OperatinsFromLV(Index,IndexR: Integer;Value,ValueChange: string);
    procedure setValuesToProgress(Addr: LongWord);
    procedure InsertToListViewFromListSearch;
    function GetModuleName(ca: LongWord): PInfoMOdules;
    function UpperCaseEX(const S: string): string;
    procedure ViewCountMem;
    function GetStepCoding: string;
  public
    ExeName: String;
    FirstMemAddr: LongWord;
    ProcessEntry: PProcessEntry32;
    Proc_ID: DWOrd;
    procedure ViewSystemInfo;
    procedure ViewMemBasic(lpAddress: LongWord);
    procedure ViewInGrid(Address: Integer);
    procedure FillGridHead;
    procedure FillGridAndRichEdit(proc_id:DWord; lpAddress: Integer; SizeAdrr: integer; ROnly: Boolean);
    procedure FillHeaps(P: PProcessEntry32);
    procedure GridFillFromMem(ProcMem: Pointer; MemSize: Integer; lpAddress: Integer);
    procedure GridFillFromMemZero(MemSize: Integer; lpAddress: Integer);
    procedure ClearListHeaps;
    procedure ClearGrid;
    procedure SearchValue(FromAddress, ToAddress: LongWord;
                      Value: string; IsString,IsCharcase,IsStopFirst,DemoInfo,ShowTime: Boolean;
                      IndexM: Integer);
    procedure SearchValueOptimize(FromAddress, ToAddress: LongWord;
                      Value: string; IsString,IsCharcase,IsStopFirst,DemoInfo,ShowTime: Boolean;
                      IndexM: Integer);
    procedure SearchValueSuperFast(FromAddress, ToAddress: LongWord;
                      Value: string; IsString,IsCharcase,IsStopFirst,DemoInfo,ShowTime: Boolean;
                      IndexM: Integer);

    procedure SearchValueSuperFastForGame(Value: string; IsString,IsCharcase: Boolean);

    function GetCountFoundedSFast(CurAddr, ToAdV:LongWord;ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    IsCharcase: Boolean;
                    CountFonded: LongInt;
                    FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

    function GetCountFoundedHFast(CurAddr, ToAdV:LongWord;ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

    function GetCountFoundedSSuperFast(CurAddr, ToAdV:LongWord;ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    IsCharcase: Boolean;
                    CountFonded: LongInt;
                    FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

    function GetCountFoundedHSuperFast(CurAddr, ToAdV:LongWord;ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

    procedure AddToLV(Addr: LongWord; isString: Boolean; OldValue,NewValue: string);
    procedure LocateValue(BaseAddr,CurAddr: LongWord; IsString,Value: string);
    procedure RefreshListView;
    procedure FillComboBox98(PENew: PProcessEntry32);
    procedure FillComboBoxNT;

    procedure SaveMem(FileName: String;FromAd,ToAd: Longword);
    procedure SaveMemory(stream: TStream; Prcmem: Pointer; SizeMem: LongWord);

    function GetAllocProtect(Text: String): Longword;
  end;

var
  fmDumpMem: TfmDumpMem;
  BreakSearch: Boolean;
const
  SearchCaption='Searching...';
  SaveCaption='Saving...';
  
implementation

uses UPInfoSInfo, USearch, UProgress, RyMenus, UCoding;

{$R *.DFM}


procedure TfmDumpMem.FormCreate(Sender: TObject);
begin
  RyMenu.Add(pmRO,nil);
  RyMenu.Add(pm,nil);
  RyMenu.Add(pmSETime,nil);
  
  ListSearch:=TList.Create;
  ListHeaps:=TList.Create;
  FillGridHead;
  pnMemo.Align:=alClient;
  pnMemo.SendToBack;
  cmbCoding.ItemIndex:=-1;
  bibCodingBack.Enabled:=false;

  ListStepCoding:=TList.Create;
end;

procedure TfmDumpMem.FillGridHead;
var
  i: Integer;
begin
  ClearGrid;
  sg.ColWidths[0]:=58;
  for i:=0 to 15 do begin
    sg.Cells[i+1,0]:=inttohex(i,2);
    sg.ColWidths[i+1]:=18;
  end;
  sg.ColWidths[17]:=120;
  sg.Cells[17,0]:='Text';
end;

procedure TfmDumpMem.SetTextFromChar(text: string; col,row: Integer);
var
  tmps: string;
begin
  tmps:=sg.Cells[17,row];
  if Length(text)=1 then
   tmps[col]:=char(strtoint('$0'+Text))
  else tmps[col]:=char(strtoint('$'+Text));
  sg.Cells[17,row]:=tmps;
end;

procedure TfmDumpMem.SetTextFromText(Text,Value: String; col,row: Integer);
var
  tmps: string;
  i: Integer;
  ch: char;
  str: string;
begin
  tmps:=Value;
  for i:=length(tmps) to 16 do begin
    tmps:=tmps+' ';
  end;
  for i:=1 to 16 do begin
    ch:=tmps[i];
    str:=inttohex(Integer(ch),2);
    if Length(str)=1 then
     sg.Cells[i,Row]:='0'+str
    else sg.Cells[i,Row]:=str;
  end;
end;

procedure TfmDumpMem.sgKeyPress(Sender: TObject; var Key: Char);
var
  ch:char;
begin
 if OldCol<>17 then begin
  sg.InplaceEditor.MaxLength:=2;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
//    if not sg.InplaceEditor.ReadOnly then btApply.Enabled:=true;
    Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sg.InplaceEditor.ReadOnly)and (not cbMulti.Checked) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
  if (not sg.InplaceEditor.ReadOnly)and (not cbMulti.Checked) then begin
    btApply.Enabled:=true;
   end;
   sg.InplaceEditor.MaxLength:=16;
   if Integer(Key)<>VK_return then
    Col17Change:=true;
 end;
end;

procedure TfmDumpMem.ClearListHeaps;

  procedure ClearList(List: TList);
  var
    i: Integer;
    PHE: PHeapEntry32;
  begin
    for i:=0 to List.Count-1 do begin
      PHE:=List.Items[i];
      dispose(PHE);
    end;
    List.clear;
  end;

var
  PIH: PInfoHeaps;
  i: integer;
begin
  for i:=0 to ListHeaps.Count-1 do begin
    PIH:=ListHeaps.Items[i];
    ClearList(PIH.PHEList);
    PIH.PHEList.Free;
    Dispose(PIH);
  end;
  ListHeaps.Clear;
end;

procedure TfmDumpMem.FillHeaps(P: PProcessEntry32);
var
  FCurSnap: THandle;
  HL: THeapList32;
  HE: THeapEntry32;
  PHE: PHeapEntry32;
  PIH: PInfoHeaps;
  List: TList;
begin
  FCurSnap := CreateToolhelp32Snapshot(TH32CS_SNAPHEAPLIST, P.th32ProcessID);
  if FCurSnap = INVALID_HANDLE_VALUE then
    raise Exception.Create('CreateToolHelp32Snapshot failed');
  ClearListHeaps;
  HL.dwSize := SizeOf(HL);
  HE.dwSize := SizeOf(HE);
  if Heap32ListFirst(FCurSnap, HL) then
    repeat
    New(PIH);
    PIH.dwSize:=HL.dwSize;
    PIH.th32ProcessID:=HL.th32ProcessID;
    PIH.th32HeapID:=HL.th32HeapID;
    PIH.dwFlags:=HL.dwFlags;
    List:=TList.Create;
    PIH.PHEList:=List;
    ListHeaps.Add(PIH);
      if Heap32First(HE, HL.th32ProcessID, HL.th32HeapID) then
        repeat
          New(PHE);      // need to make copy of THeapList32 record so we
          PHE^ := HE;    // have enough info to view heap later
          PIH.PHEList.Add(PHE);
{          DetailLists[ltHeap].AddObject(Format(SHeapStr, [HL.th32HeapID,
            Pointer(HE.dwAddress), HE.dwBlockSize,
            GetHeapFlagString(HE.dwFlags)]), TObject(PHE));}
        until not Heap32Next(HE);
    until not Heap32ListNext(FCurSnap, HL);
  CloseHandle(FCurSnap);
end;

procedure TfmDumpMem.FillGridAndRichEdit(proc_id:DWord; lpAddress: Integer; SizeAdrr: integer; ROnly: Boolean);
var
  ProcId: LongInt;
  PH: THandle;
  MemSize: LongInt;
  ProcMem: Pointer;
  NumRead: DWord;
begin
  ProcId:=proc_id;
//  PH:=OpenProcess(PROCESS_VM_READ,false,ProcId);
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  MemSize:=SizeAdrr;
  GetMem(ProcMem,MemSize);
  Screen.Cursor := crHourGlass;
  sg.InplaceEditor.ReadOnly:=ROnly;
  if ROnly then begin
    sg.InplaceEditor.PopupMenu:=pmRO;
  end else begin
    sg.InplaceEditor.PopupMenu:=pmRO;
  end;
  if readProcessMemory(PH,Pointer(lpAddress),ProcMem,MemSize,NumRead)then begin
   GridFillFromMem(ProcMem,MemSize,lpAddress);
  end else begin
   GridFillFromMemZero(MemSize,lpAddress);
  end;
  Screen.Cursor := crDefault;
  FreeMem(ProcMem,MemSize);
  CloseHandle(PH);
end;

procedure TfmDumpMem.GridFillFromMemZero(MemSize: Integer; lpAddress: Integer);
var
  i: Integer;
  badr: Integer;
  b: byte;
  j: integer;
  ch: char;
  celid,rowid: integer;
  tmps: string;
begin
  badr:=Integer(lpAddress);
  sg.RowCount:=(MemSize div 16)+1;
  re.Lines.Clear;
  j:=0;
  for i:=badr to badr+MemSize do begin
    ch:=#0;
    b:=Byte(ch);
    tmps:=tmps+ch;
    celid:=1+(j mod 16);
    rowid:=(j div 16)+1;
    sg.Cells[celid,rowid]:=inttohex(b,2);
    if (j mod 16)=0 then begin
      sg.Cells[0,(j div 16)+1]:=inttohex(i,8);
    end;
    inc(j);
    if (j mod 16)=0 then begin
      sg.Cells[17,(j div 16)]:=tmps;
      tmps:='';
    end;
  end;
end;

  function ParseBadChar(s: string): string;
  var
    i: Integer;
    ch: byte;
    tmps: string;
    isOk: Boolean;
  begin
    for i:=1 to Length(s) do begin
      ch:=Byte(s[i]);
      isOk:=false;
      if ch in [Byte('A')..Byte('z')] then isOk:=true
//      else if ch in [Byte('a')..Byte('z')] then isOk:=true
      else if ch in [Byte('À')..Byte('ÿ')] then isOk:=true
//      else if ch in [Byte('à')..Byte('ÿ')] then isOk:=true;
      else if ch in [Byte('0')..Byte('9')] then isOk:=true;

      if IsOk then begin
        tmps:=tmps+Char(ch);
      end else begin
        tmps:=tmps+'.';
      end;

    end;
    Result:=tmps;
  end;

procedure TfmDumpMem.GridFillFromMem(ProcMem: Pointer; MemSize: Integer; lpAddress: Integer);

  function GetStrFromLine(IndLine: Integer): string;
  var
   ret: string;
   i: Integer;
   b: byte;
   ch: char;
   tmps: string;
  begin
    for i:=1 to 16 do begin
      tmps:=sg.Cells[IndLine,i];
      b:=Strtoint('$'+tmps);
      ch:=Char(b);
      ret:=ret+ch;
    end;
    Result:=ret;
  end;


var
  i: Integer;
  badr: Integer;
  b: byte;
  j: integer;
  ch: char;
  celid,rowid: integer;
  tmps: string;
  s: string;
begin
 re.Lines.BeginUpdate;
 try
  badr:=Integer(lpAddress);
  sg.RowCount:=(MemSize div 16)+1;
  re.Lines.Clear;
  j:=0;
  for i:=badr to badr+MemSize do begin
    Move(Pointer(LongInt(ProcMem)+j)^,ch,1);
    b:=Byte(ch);
    tmps:=tmps+ch;
    celid:=1+(j mod 16);
    rowid:=(j div 16)+1;

    sg.Cells[celid,rowid]:=inttohex(b,2);
    if (j mod 16)=0 then begin
      sg.Cells[0,(j div 16)+1]:=inttohex(i,8);
    end;
    inc(j);
    if (j mod 16)=0 then begin
      sg.Cells[17,(j div 16)]:=tmps;
      s:=s+tmps;
      tmps:='';
    end;
  end;
  defaultStr:=s;
  re.Lines.Text:=ParseBadChar(GetStepCoding);
 finally
  re.Lines.EndUpdate;
 end; 
end;

procedure TfmDumpMem.FormDestroy(Sender: TObject);
begin
  ClearListSearch;
  ListSearch.Free;
  ClearComboBox;
  ClearListHeaps;
  ListHeaps.Free;
  ListStepCoding.Free;
end;

procedure TfmDumpMem.ViewSystemInfo;
var
   p: TSystemInfo;
begin
  GetSystemInfo(p);
  PageSize:=P.dwPageSize;
end;


  function TfmDumpMem.getAllocationProtect(AllocationProtect: Integer): String;
  begin
    Result:='None';
    case AllocationProtect of
       PAGE_READONLY: Result:='READONLY';
       PAGE_READWRITE:Result:='READWRITE';
       PAGE_WRITECOPY:Result:='WRITECOPY';
       PAGE_EXECUTE:Result:='EXECUTE';
       PAGE_EXECUTE_READ:Result:='EXECUTE_READ';
       PAGE_EXECUTE_READWRITE:Result:='EXECUTE_READWRITE';
       PAGE_EXECUTE_WRITECOPY:Result:='EXECUTE_WRITECOPY';
       PAGE_GUARD:Result:='GUARD';
       PAGE_NOACCESS:Result:='NOACCESS';
       PAGE_NOCACHE:Result:='NOCACHE';
    end;
  end;

  function TfmDumpMem.getState(State: Integer): string;
  begin
    Result:='None';
    case State of
      MEM_COMMIT: Result:='MEM_COMMIT';
      MEM_FREE: Result:='MEM_FREE';
      MEM_RESERVE: Result:='MEM_RESERVE';
    end;
  end;

  function TfmDumpMem.getType_9(Type_9: integer): string;
  begin
    Result:='None';
    case Type_9 of
      MEM_IMAGE: result:='MEM_IMAGE';
      MEM_MAPPED: result:='MEM_MAPPED';
      MEM_PRIVATE: result:='MEM_PRIVATE';
    end;
  end;

procedure TfmDumpMem.ViewMemBasic(lpAddress: LongWord);
var
  PH: THandle;
  P: TmemoryBasicInformation;
  PM: PInfoMOdules;
  procid: DWord;
  ind: Integer;
begin
  CurrMemAddr:=lpAddress;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,Procid);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  VirtualQueryEx(
    PH,	// handle of process
    Pointer(lpAddress),	// address of region
    P,	// address of information buffer
    sizeof(P) 	// size of buffer
   );
   lbBaseAddress.Caption:=InttoHex(Integer(P.BaseAddress),8);
   lbAllocationBase.caption:=InttoHex(Integer(P.AllocationBase),8);
   lbAllocProtect.Caption:=getAllocationProtect(P.AllocationProtect);
   ind:=cbProtect.Items.IndexOf(getAllocationProtect(P.Protect));
   cbProtect.ItemIndex:=ind;
   LastAllocProtectIndex:=cbProtect.ItemIndex;
   lbRegionSize.Caption:=inttostr(P.RegionSize);
   lbState.Caption:=getState(P.State);
//   lbProtect.Caption:=getAllocationProtect(P.Protect);
   lbType_9.Caption:=getType_9(P.Type_9);
   PM:=GetModuleName(Integer(P.BaseAddress));
   if PM<>nil then
    lbModule.Caption:=PM.Name
   else lbModule.Caption:='NONE';
   CloseHandle(PH);
   case P.Protect of
     PAGE_READWRITE: FillGridAndRichEdit(procid,CurrMemAddr,PageSize,false);
    else begin
      FillGridAndRichEdit(procid,CurrMemAddr,PageSize,true);
    end;
   end;
end;


procedure TfmDumpMem.ViewInGrid(Address: Integer);
begin

end;

procedure TfmDumpMem.btNextClick(Sender: TObject);
begin
   if btApply.Enabled then ApplyPage(CurrMemAddr,true);
   ViewMemBasic(CurrMemAddr+PageSize);
end;

procedure TfmDumpMem.btPrevClick(Sender: TObject);
begin
  if btApply.Enabled then ApplyPage(CurrMemAddr,true);
  ViewMemBasic(CurrMemAddr-PageSize);
end;

procedure TfmDumpMem.btGoClick(Sender: TObject);
var
 news: string;
begin
  if cbStart.text='' then begin
   showmessage('Input Start Address !');
   exit;
  end;
  if btApply.Enabled then ApplyPage(CurrMemAddr,true);
  fmSearch.edStartAddr.Text:=cbStart.text;
//  FirstMemAddr:=strtoint('$'+cbStart.Text);
  news:=Copy(cbStart.Text,1,Length(cbStart.Text)-3);
  FirstMemAddr:=strtoint('$'+news+'000');
  ViewMemBasic(FirstMemAddr);
  if sg.RowCount<>2 then
   LocateValue(FirstMemAddr,strtoint('$'+cbStart.Text),
             '',
             '');

end;

procedure TfmDumpMem.edStartKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmDumpMem.btInfoClick(Sender: TObject);
var
  fm: TfmPISI;
begin
  fm:=TfmPISI.Create(nil);
  fm.Caption:=fm.Caption+' - '+ExeName;
   if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
    fm.ProcessEntry:=ProcessEntry;
    fm.ViewProcessInfo98;
   end else begin
    fm.ProcID:=Proc_id;
    fm.ViewProcessInfoNT;
   end;
  fm.ViewSystemInfo98;
  fm.FillInfoProcess;
  fm.ShowModal;
  fm.Free;
end;

procedure TfmDumpMem.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

  procedure DrawCol0;
  var
   wh,Offset,th: Integer;
   dy: Integer;
  begin
   wh:=3;//sg.DefaultRowHeight;
   with sg.Canvas do  { draw on control canvas, not on the form }
   begin
    FillRect(Rect);       { clear the rectangle }
    Font.Color:=clWhite;
//    Font.Style:=[fsBold];
    Rectangle(rect);
    Offset:=wh;
    th:=TextHeight(sg.Cells[ACol,ARow]);
    dy:=((Rect.Bottom-Rect.Top)div 2)-th div 2;
    if (ACol=0) or (ARow=0) then begin
     if not((ACol=0) and (ARow=0)) then
      TextOut(Rect.Left + Offset, Rect.Top+dy, sg.Cells[ACol,ARow])  { display the text }
    end; 
   end;
  end;

begin
  if (Acol=0) then DrawCol0;
  if (ARow=0) then DrawCol0;
end;

procedure TfmDumpMem.ClearGrid;
var
  i: Integer;
begin
  for i:=0 to sg.ColCount-1 do begin
    sg.Cols[i].Clear;
  end;
  sg.RowCount:=2;
end;

procedure TfmDumpMem.btrefreshClick(Sender: TObject);
begin
  if btApply.Enabled then ApplyPage(CurrMemAddr,true);
  ViewMemBasic(CurrMemAddr);
  if cbRef.Checked then RefreshListView;
end;

procedure TfmDumpMem.btSearchClick(Sender: TObject);
var
  IndexM: Integer;
begin
  if btApply.Enabled then ApplyPage(CurrMemAddr,true);
  fmSearch.edStartAddr.MaxLength:=cbStart.MaxLength;
  fmSearch.FormStyle:=FormStyle;
  if fmSearch.ShowModal=mrOk then begin

   case fmSearch.cbBasePrioritet.ItemIndex of
     0: SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS);
     1: SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS);
     2: SetPriorityClass(GetCurrentProcess,HIGH_PRIORITY_CLASS);
     3: SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS);
   end;

   case fmSearch.cbdeltaPrioritet.ItemIndex of
     0: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_IDLE);
     1: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_LOWEST);
     2: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
     3: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_NORMAL);
     4: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_ABOVE_NORMAL);
     5: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST);
     6: SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
   end;

   Self.Update;
   if (not fmSearch.cbFast.Checked)and(not fmSearch.cbSuper.Checked) then begin
    IndexM:=0;
    if (not fmSearch.cbOnlyModules.Checked) and(not fmSearch.cbWithOutM.Checked)then IndexM:=0;
    if fmSearch.cbOnlyModules.Checked then IndexM:=1;
    if fmSearch.cbWithOutM.Checked then IndexM:=2;
    SearchValue(strtoint('$'+fmSearch.edStartAddr.text),
                strtoint('$'+fmSearch.cbFinish.text),
                        fmSearch.edString.text,
                        fmSearch.rbString.Checked,
                        fmSearch.cbCase.Checked,
                        fmSearch.cbStop.Checked,fmSearch.cbNoInfo.Checked,
                        fmSearch.cbShowTime.Checked,
                        IndexM);
   end;
   if fmSearch.cbFast.Checked then begin
    IndexM:=0;
    if (not fmSearch.cbOnlyModules.Checked) and(not fmSearch.cbWithOutM.Checked)then IndexM:=0;
    if fmSearch.cbOnlyModules.Checked then IndexM:=1;
    if fmSearch.cbWithOutM.Checked then IndexM:=2;
     SearchValueOptimize(strtoint('$'+fmSearch.edStartAddr.text),
                strtoint('$'+fmSearch.cbFinish.text),
                        fmSearch.edString.text,
                        fmSearch.rbString.Checked,
                        fmSearch.cbCase.Checked,
                        fmSearch.cbStop.Checked,fmSearch.cbNoInfo.Checked,
                        fmSearch.cbShowTime.Checked,
                        IndexM);
   end;
   if fmSearch.cbSuper.Checked then begin
    IndexM:=0;
    if (not fmSearch.cbOnlyModules.Checked) and(not fmSearch.cbWithOutM.Checked)then IndexM:=0;
    if fmSearch.cbOnlyModules.Checked then IndexM:=1;
    if fmSearch.cbWithOutM.Checked then IndexM:=2;
    if fmSearch.cbPreSearch.checked then begin
     if ListSearch.Count<>0 then begin
      SearchValueSuperFastForGame(fmSearch.edString.text,
                                  fmSearch.rbString.Checked,
                                  fmSearch.cbCase.Checked);
     end else begin
      SearchValueSuperFast(strtoint('$'+fmSearch.edStartAddr.text),
                strtoint('$'+fmSearch.cbFinish.text),
                        fmSearch.edString.text,
                        fmSearch.rbString.Checked,
                        fmSearch.cbCase.Checked,
                        fmSearch.cbStop.Checked,fmSearch.cbNoInfo.Checked,
                        fmSearch.cbShowTime.Checked,
                        IndexM);
     end;
    end else begin
     SearchValueSuperFast(strtoint('$'+fmSearch.edStartAddr.text),
                strtoint('$'+fmSearch.cbFinish.text),
                        fmSearch.edString.text,
                        fmSearch.rbString.Checked,
                        fmSearch.cbCase.Checked,
                        fmSearch.cbStop.Checked,fmSearch.cbNoInfo.Checked,
                        fmSearch.cbShowTime.Checked,
                        IndexM);
    end;
   end;
   SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS);
   SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_NORMAL);
  end;
end;

procedure TfmDumpMem.AddToLV(Addr: LongWord; isString: Boolean; OldValue,NewValue: string);
var
  tmps: string;
  li: TListItem;
  but: Integer;
begin
  tmps:=Inttohex(Addr,8);
  li:=LV.FindCaption(0,tmps,true,true,true);
  if Li<>nil then begin
    but:=MessageBox(Application.Handle,Pchar('Address '+tmps+' already exists.'+#13+'Rewrite ?'),
                   Pchar('Warning'),MB_YESNO+MB_ICONWARNING);
    if but=IDYES then begin
      with li.SubItems do begin
        if isString then  Strings[0]:='String'
        else Strings[0]:='HEX';
        Strings[1]:=OldValue;
        Strings[2]:=NewValue;
      end;
      exit;
    end;
    if but=IDCANCEL then begin
     exit;
    end;
  end;
  li:=LV.Items.Add;
  Li.Caption:=tmps;
  with li.SubItems do begin
     if isString then  li.SubItems.Add('String')
     else li.SubItems.Add('HEX');
     li.SubItems.Add(OldValue);
     li.SubItems.Add(NewValue);
     li.SubItems.Add('');
  end;
end;


procedure TfmDumpMem.pmPopup(Sender: TObject);
var
  li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then begin
   miRemoveAll.Enabled:=true;
   if LV.Items.Count=0 then begin
    miRemoveAll.Enabled:=false;
    miSpec.Enabled:=false;
   end;
    miRemove.Enabled:=false;
    miGotoAddr.Enabled:=false;
    miChange.Enabled:=false;
    miAdd.Enabled:=true;
  end else begin
    miRemoveAll.Enabled:=true;
    miRemove.Enabled:=true;
    miGotoAddr.Enabled:=true;
    miChange.Enabled:=true;
    miSpec.Enabled:=true;
    miAdd.Enabled:=true;
  end;
end;

procedure TfmDumpMem.LocateValue(BaseAddr,CurAddr: LongWord; IsString,Value: string);
var
  rid,cid: Integer;
  Minus: LongWord;
begin
  try
    Minus:=CurAddr-BaseAddr;
    rid:=1+(Minus div 16);
    cid:=1+(Minus mod 16);
    if miViewHex.Checked then begin
     sg.TopRow:=rid;
     sg.row:=rid;
     sg.Col:=cid;
     sg.SetFocus;
    end;
    if miViewString.Checked then begin
      re.SelStart:=Minus;
      re.SelLength:=1;
      re.SetFocus;
    end;


  except
    MessageBox(Application.handle,Pchar('Page no access !'),nil,MB_ICONERROR);
  end;
end;

procedure TfmDumpMem.miGotoAddrClick(Sender: TObject);
var
  news:string;
begin
  news:=Copy(lV.Selected.caption,1,Length(lV.Selected.caption)-3);
  ViewMemBasic(strtoint('$'+news+'000'));
  if sg.RowCount<>2 then
   LocateValue(strtoint('$'+news+'000'),strtoint('$'+lV.Selected.caption),
             lV.Selected.SubItems.Strings[0],
             lV.Selected.SubItems.Strings[1]);
end;

procedure TfmDumpMem.miRemoveClick(Sender: TObject);
var
  li: TlistItem;
  i: Integer;
begin
  for i:=LV.Items.Count-1 downto 0 do begin
   li:=LV.Items[i];
   if Li.Selected then Li.Delete;
  end;
  SetColumnWidth;
end;

procedure TfmDumpMem.miRemoveAllClick(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  try
   LV.Items.BeginUpdate;
   LV.Items.Clear;
   LV.Items.EndUpdate;
  finally
    Screen.Cursor:=crDefault;
  end;
  SetColumnWidth;
end;

procedure TfmDumpMem.LVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case Key of
     VK_RETURN: LVDblClick(nil);
     VK_DELETE: miRemoveClick(nil);
   end;
end;

procedure TfmDumpMem.LVDblClick(Sender: TObject);
var
  li: TListItem;
begin
  li:=Lv.Selected;
  if li<>nil then
   miGotoAddrClick(nil);
end;

procedure TfmDumpMem.RefreshListView;
var
  i: Integer;
  li: TListItem;
  ProcId: LongInt;
  PH: THandle;
  ProcMem: Pointer;
  MemSize,NumRead: LongWord;
  tmps: string;
  FromAddr: LongWord;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  for i:=0 to LV.Items.Count-1 do begin
    Li:=LV.Items[i];
    if Li.SubItems.Strings[0]='String' then begin
      MemSize:=Length(Li.SubItems.Strings[1]);
    end else begin
      MemSize:=Length(GetStringFromHex(Li.SubItems.Strings[1]));
    end;
    FromAddr:=strtoint('$'+Li.Caption);
    GetMem(ProcMem,MemSize);
    if readProcessMemory(PH,Pointer(FromAddr),
                        ProcMem,MemSize,NumRead)then begin
      if Li.SubItems.Strings[0]='String' then begin
        setlength(tmps,MemSize);
        Move(Pointer(LongWord(ProcMem))^,Pchar(tmps)^,MemSize);
        Li.SubItems.Strings[2]:=Copy(tmps,1,Length(tmps));
        Setlength(tmps,StrLen(Pchar(tmps)));
      end else begin
        setlength(tmps,MemSize);
        Move(Pointer(LongWord(ProcMem))^,Pchar(tmps)^,MemSize);
        Li.SubItems.Strings[2]:=GetHexFromString(tmps);
        Setlength(tmps,StrLen(Pchar(tmps)));
      end;
    end;
    FreeMem(ProcMem,MemSize);
  end;
  CloseHandle(PH);
  SetColumnWidth;
end;

procedure TfmDumpMem.lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
 if glSortSubItem>=0 then Compare:=CompareText(Item1.SubItems[glSortSubItem],Item2.SubItems[glSortSubItem])
 else Compare:=CompareText(Item1.Caption,Item2.Caption);
 if glSortForward=false then Compare:=-Compare;
end;

procedure TfmDumpMem.lvCompareInt(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
 i1,i2:LongWord;
begin
 if glSortSubItem>=0 then begin
  i1:=strtoint('$'+Item1.SubItems[glSortSubItem]);
  i2:=strtoint('$'+Item2.SubItems[glSortSubItem]);
 end else begin
  i1:=strtoint('$'+Item1.Caption);
  i2:=strtoint('$'+Item2.Caption);
 end;
 if i2>i1 then Compare:=-1
 else if i2<i1 then Compare:=1
 else Compare:=1;
 if glSortForward=false then Compare:=-Compare;
end;

procedure TfmDumpMem.LVColumnClick(Sender: TObject; Column: TListColumn);
var
 newSortItem:integer;
begin
 newSortItem:=Column.Index-1;
 if glSortSubItem=newSortItem then glSortForward:=not glSortForward
 else glSortForward:=true;
 glSortSubItem:=newSortItem;
 if Column.Index=0 then lv.OnCompare:=lvCompareInt
 else lv.OnCompare:=lvCompareStr;
 lv.AlphaSort;
end;

procedure TfmDumpMem.SetTextFromHex(Hideedit: Boolean);
var
  i: Integer;
  ch: char;
  tmps: string;
begin
  tmps:='';
  for i:=1 to 16 do begin
   ch:=Char(strtoint('$'+sg.Cells[i,sg.Row]));
   tmps:=tmps+ch;
  end;
  if HideEdit then sg.HideEditor;
  sg.Cells[17,sg.Row]:=tmps;
end;

procedure TfmDumpMem.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  i: Integer;
  ch: char;
  tmps: string;
begin
  if OldCol=17 then begin
     tmps:='';
     for i:=1 to 16 do begin
      ch:=Char(strtoint('$'+sg.Cells[i,OldRow]));
      tmps:=tmps+ch;
     end;
     sg.HideEditor;
     sg.Cells[OldCol,OldRow]:=tmps;
  end else begin
    tmps:=sg.Cells[OldCol,OldRow];
    if Trim(tmps)='' then begin
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(0,2);
    end else begin
     if Length(tmps)=1 then begin
      sg.Cells[OldCol,OldRow]:='0'+tmps;
     end;
    end; 
  end;
  if ACol=17 then begin
    sg.InplaceEditor.MaxLength:=16;
  end else begin
    sg.InplaceEditor.MaxLength:=2;
  end;
  OldText:=sg.Cells[ACol,ARow];
  Col17Change:=false;
  OldRow:=ARow;
  OldCol:=ACol;
end;

procedure TfmDumpMem.miChangeClick(Sender: TObject);
var
  fm: TfmChange;
  li: TListItem;
begin
  li:=lv.Selected;
  if li=nil then exit;
  fm:=TfmChange.Create(nil);
  fm.FormStyle:=FormStyle;
  fm.edAddr.Text:=li.caption;
  fm.cbType.ItemIndex:=fm.cbType.Items.IndexOf(li.SubItems.Strings[0]);
  fm.OldItemIndex:=fm.cbType.ItemIndex;
  fm.edOldValue.Text:=li.SubItems.Strings[1];
  fm.edNewValue.text:=li.SubItems.Strings[2];
  if fm.cbType.ItemIndex=0 then begin
    fm.edOldValue.PopupMenu:=nil;
    fm.edNewValue.PopupMenu:=nil;
    fm.edOldValue.OnKeyPress:=nil;
    fm.edNewValue.OnKeyPress:=nil;
    fm.btOldIns.Enabled:=false;
    fm.btNewIns.Enabled:=false;
  end else begin
    fm.edOldValue.OnKeyPress:=fm.edAddrKeyPress;
    fm.edNewValue.OnKeyPress:=fm.edAddrKeyPress;
    fm.btOldIns.Enabled:=true;
    fm.btNewIns.Enabled:=true;
  end;
  if fm.ShowModal=mrOk then begin
    li.Caption:=fm.edAddr.Text;
    li.SubItems.Strings[0]:=fm.cbType.Text;
    li.SubItems.Strings[1]:=fm.edOldValue.Text;
    li.SubItems.Strings[2]:=fm.edNewValue.text;
    li.SubItems.Strings[3]:=fm.edHint.text;
    SetColumnWidth;
  end;
  fm.Free;
end;

procedure TfmDumpMem.miAddClick(Sender: TObject);
var
  fm: TfmChange;
begin
  fm:=TfmChange.Create(nil);
  fm.FormStyle:=FormStyle;
  fm.cbType.ItemIndex:=0;
  fm.OldItemIndex:=fm.cbType.ItemIndex;
  fm.Caption:='Add';
  if fm.ShowModal=mrOk then begin
   AddToLV(strtoint('$'+fm.edAddr.Text),
           not Boolean(fm.cbType.ItemIndex),
           fm.edOldValue.text,
           fm.edNewValue.Text);
   SetColumnWidth;        
  end;
  fm.Free;
end;

procedure TfmDumpMem.sgExit(Sender: TObject);
begin
 if sg.RowCount<>2 then
  SetTextFromHex(true);
end;

procedure TfmDumpMem.sgSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
 if ACol<>17 then begin
   if Value<>'' then
    SetTextFromChar(Value,ACol,ARow);
 end else begin
   if Value<>'' then
     if Col17Change then
      SetTextFromText(oldText,Value,ACol,ARow);
 end;
end;

procedure TfmDumpMem.ApplyPage(CurAddr: LongWord; Question: Boolean);

   procedure FillFromGrid(Procmem: Pointer;MemSize: Longword);
   var
     i: LongWord;
     ch: char;
     celid,rowid: Integer;
     tmps: string;
   begin
     for i:=0 to MemSize-1 do begin
      celid:=1+(i mod 16);
      rowid:=(i div 16)+1;
      tmps:=sg.Cells[celid,rowid];
      ch:=char(strtoint('$'+tmps));
      FillChar(Pointer(LongWord(ProcMem)+i)^,1,ch);
     end;
   end;

   procedure ApplyP;
   var
    ProcId: LongInt;
    PH: THandle;
    MemSize: DWord;
    ProcMem: Pointer;
    numWrite: DWord;
   begin
     if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
      procid:=ProcessEntry.th32ProcessID;
     end else begin
      procid:=Proc_id;
     end;
     PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
     try
       if PH=0 then begin
        MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
        exit;
       end;
       MemSize:=PageSize;
       GetMem(ProcMem,MemSize);
       FillFromGrid(ProcMem,MemSize);
       numWrite:=0;
       if not WriteProcessMemory(PH,Pointer(CurAddr),ProcMem,MemSize,numWrite) then begin
         raise Exception.Create(SysErrorMessage(GetLastError));
       end;
//         ShowMessage(Inttostr(numWrite));
     finally
       FreeMem(ProcMem,MemSize);
       CloseHandle(PH);
     end;  
   end;

begin
  if Question then begin
   if MessageBox(Application.Handle,Pchar('Apply changes ?'),
                        Pchar('Confirm'),
                        MB_YESNO+MB_ICONQUESTION)=IDYES then begin
     ApplyP;
     btApply.Enabled:=false;
   end else
    btApply.Enabled:=false;
  end else begin
    ApplyP;
    btApply.Enabled:=false;
  end;
end;

procedure TfmDumpMem.btApplyClick(Sender: TObject);
begin
  if btApply.Enabled then ApplyPage(CurrMemAddr,false);
end;

procedure TfmDumpMem.seTimeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_Back,VK_DELETE: Key:=0;
  end;
  if (ssShift in Shift)and(key=VK_INSERT)then
   Key:=0;
  if (ssCtrl in Shift) then
   Key:=0;
end;

procedure TfmDumpMem.seTimeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Integer(Key)=VK_Back)or(Integer(Key)=VK_DELETE)then begin
    Key:=char(0);
  end;
end;

procedure TfmDumpMem.edStartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift)and(key=VK_INSERT)then
   Key:=0;
  if (ssCtrl in Shift) then
   Key:=0;
end;

procedure TfmDumpMem.cbOnTimerClick(Sender: TObject);
begin
  if cbOnTimer.Checked then
   tm.Enabled:=true
  else tm.Enabled:=false;              
end;

procedure TfmDumpMem.udTimeChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  tm.Interval:=udTime.Position;
end;

procedure TfmDumpMem.tmTimer(Sender: TObject);
begin
  ApplyListView;
end;

procedure TfmDumpMem.ApplyListView;

  function ApplyLVS(CurAddr: LongWord; Value: String): Boolean;

    procedure FillMem(ProcMem: Pointer; MemSize: LongWord);
    var
     i: LongWord;
     ch: char;
     tmps: string;
    begin
     if MemSize=0 then exit;
     for i:=0 to (MemSize * 2)-1 do begin
      if not Odd(i) then begin
       tmps:=Value[i+1]+Value[i+2];
       ch:=char(strtoint('$'+tmps));
       FillChar(Pointer(LongWord(ProcMem)+i div 2)^,1,ch);
      end;
     end;
    end;

  var
    ProcId: LongInt;
    PH: THandle;
    numWrite: DWord;
    ProcMem: Pointer;
    MemSize: Longword;
  begin
    result:=false;
    if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
     procid:=ProcessEntry.th32ProcessID;
    end else begin
     procid:=Proc_id;
    end;
    PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
    if PH=0 then begin
      MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
      exit;
    end;
    MemSize:=Length(Value)div 2;
    GetMem(ProcMem,MemSize);
    FillMem(ProcMem,MemSize);
    if WriteProcessMemory(PH,Pointer(CurAddr),ProcMem,MemSize,numWrite) then begin
    end;
    FreeMem(ProcMem,MemSize);
    CloseHandle(PH);
    result:=true;
  end;

var
  i: Integer;
  Li: TListItem;
  br: Boolean;
  Value: string;
  PH: THandle;
  procid: DWord;
begin
  if Lv.Items.Count=0 then cbOnTimer.Checked:=false;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
    cbOnTimer.Checked:=false;
    MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
    exit;
  end;
  CloseHandle(PH);
  for i:=0 to Lv.Items.Count-1 do begin
    Li:=LV.Items[i];
    if Li.Checked then begin
      if li.SubItems.Strings[0]='String' then begin
       Value:=Li.SubItems.Strings[2];
       br:=ApplyLVS(Strtoint('$'+Li.Caption),
                   GetHexFromString(Value));
       if not br then begin
        cbOnTimer.Checked:=false;
        break;
       end;
      end else begin
       Value:=Li.SubItems.Strings[2];
       br:=ApplyLVs(Strtoint('$'+Li.Caption),
                   Value);
       if not br then begin
        cbOnTimer.Checked:=false;
        break;
       end;
      end;
    end;
  end;
end;

procedure TfmDumpMem.ClearComboBox;
var
 i: Integer;
 P: PInfoModules;
begin
  for i:=0 to cbStart.Items.Count-1 do begin
    P:=PInfoModules(cbStart.Items.Objects[i]);
    dispose(P);
  end;
  cbStart.Clear;
end;

procedure TfmDumpMem.FillComboBox98(PENew: PProcessEntry32);
var
  M: TModuleEntry32;
  FSnap: Thandle;
  P: PInfoModules;
begin
  ClearComboBox;
  MaxSize:=0;
  FSnap := CreateToolHelp32Snapshot(TH32CS_SNAPMODULE, PENew^.th32ProcessID);
  M.dwSize := SizeOf(M);
  if Module32First(FSnap, M) then
    repeat
       New(P);
       P.Address:=strtoint64('$'+(Format('%p', [M.ModBaseAddr])));
       P.Size:=M.modBaseSize;
       P.Name:=M.szModule;
       MaxSize:=MaxSize+P.Size;
       cbStart.Items.AddObject(Format('%p', [M.ModBaseAddr]),TObject(P));
    until not Module32Next(FSnap, M);
end;

procedure TfmDumpMem.FillComboBoxNT;
const
  AddrMask = DWORD($FFFFF000);
var
  I: Integer;
  Count: DWORD;
  ProcHand: THandle;
  ModHandles: array[0..$3FFF - 1] of DWORD;
  ModInfo: TModuleInfo;
  ModName: array[0..MAX_PATH] of char;
  P: PInfoModules;
  
begin
  ClearComboBox;
  MaxSize:=0;
//  ProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False,Proc_ID);
  ProcHand := OpenProcess(PROCESS_ALL_ACCESS, False,Proc_ID);

  if ProcHand = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  try
    EnumProcessModules(ProcHand, @ModHandles, SizeOf(ModHandles), Count);
    for I := 0 to (Count div SizeOf(DWORD)) - 1 do
      if (GetModuleBaseName(ProcHand, ModHandles[I], ModName,
        SizeOf(ModName)) > 0) and GetModuleInformation(ProcHand,
        ModHandles[I], @ModInfo, SizeOf(ModInfo)) then begin
        New(P);
        P.Address:=strtoint64('$'+(Format('%p', [ModInfo.lpBaseOfDll])));
        P.Size:=ModInfo.SizeOfImage;
        P.Name:=ModName;
        MaxSize:=MaxSize+P.Size;
        cbStart.Items.AddObject(Format('%p', [ModInfo.lpBaseOfDll]),TObject(P));
    end;
  finally
    CloseHandle(ProcHand);
  end;
end;

procedure TfmDumpMem.btSaveClick(Sender: TObject);
var
  fs: TFileStream;
  wr: TWriter;
  i: Integer;
  li: TListItem;
begin
  if LV.Items.Count=0 then exit;
  sd.InitialDir:=ExtractFileDir(Application.ExeName);
  if not sd.Execute then exit;
  fs:=TFileStream.Create(sd.Filename,fmCreate);
  wr:=TWriter.Create(fs,4096);
  wr.WriteString(EXename);
  wr.WriteInteger(LV.Items.Count);
  for i:=0 to LV.Items.Count-1 do begin
   Li:=LV.Items[I];
   wr.WriteString(Li.Caption);
   wr.WriteString(Li.SubItems.Strings[0]);
   wr.WriteString(Li.SubItems.Strings[1]);
   wr.WriteString(Li.SubItems.Strings[2]);
   wr.WriteString(Li.SubItems.Strings[3]);
  end;
  wr.Free;
  fs.Free;
end;

procedure TfmDumpMem.btLoadClick(Sender: TObject);
var
  fs: TFileStream;
  rd: Treader;
  i: Integer;
  li: TListItem;
  NCount: Integer;
  ExeN: string;
begin
  od.InitialDir:=ExtractFileDir(Application.ExeName);
  if not od.Execute then exit;
  fs:=TFileStream.Create(od.Filename,fmOpenRead);
  rd:=TReader.Create(fs,4096);
  li:=nil;
  try
  try
   ExeN:=rd.ReadString;
   if UpperCaseEX(ExeN)<>UpperCaseEX(ExeName) then begin
     if MessageBox(Application.Handle,Pchar('Loading list for Process: '+#13+ExeN),
        Pchar('Warning'),MB_YESNO+MB_ICONWARNING)=IDNO then begin
      exit;
     end;
   end;
   LV.Items.Clear;
   NCount:=rd.ReadInteger;
   for i:=0 to NCount-1 do begin
    Li:=LV.Items.Add;
    li.Caption:=rd.ReadString;
    with li.SubItems do begin
      Add(rd.ReadString);
      Add(rd.ReadString);
      Add(rd.ReadString);
      Add(rd.ReadString);
    end;
   end;
  except
   MessageBox(Application.handle,Pchar('Bad format file: '+ExtractFilename(od.FileName)),nil,MB_ICONERROR);
   if Li<>nil then Li.Delete;
  end;
  SetColumnWidth;
  finally
   rd.Free;
   fs.Free;
  end;

end;

procedure TfmDumpMem.SetColumnWidth;
var
  i: Integer;
begin
 for i:=0 to Lv.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
 end;
 lbCount.Caption:='Count: '+inttostr(Lv.Items.Count);
end;


procedure TfmDumpMem.miAddToLVClick(Sender: TObject);
var
  rowS,ColS:Integer;
  AddrH,AddrS: LongWord;
  tmpsV: string;
  tmpsA: string;
  i,j: Integer;
  rc: TGridRect;
begin
 LV.Items.BeginUpdate;
 Screen.Cursor:=crHourGlass;
 Self.update;
 try
 if sg.RowCount<>2 then begin
  rowS:=sg.row;
  cols:=sg.col;
  if not cbMulti.Checked then begin
   tmpsV:=sg.Cells[cols,rowS];
   tmpsA:=sg.Cells[0,rowS];
   AddrS:=strtoint('$'+tmpsA);
   AddrH:=AddrS+LongWord(cols-1);
   if Cols=17 then begin
    AddToLV(AddrS,true,sg.Cells[17,rowS],'');
   end;
   if Cols in [1..16] then begin
    AddToLV(AddrH,false,tmpsV,'');
   end;
  end else begin
    rc:=sg.Selection;
    BreakFill:=false;
    for i:=rc.Left to rc.Right do begin
     for j:=rc.top to rc.Bottom do begin
      Application.ProcessMessages;
      if BreakFill then break;
      tmpsV:=sg.Cells[i,j];
      tmpsA:=sg.Cells[0,j];
      AddrS:=strtoint('$'+tmpsA);
      AddrH:=AddrS+LongWord(i-1);
      if i=17 then begin
        AddToLV(AddrS,true,sg.Cells[i,j],'');
        lbCount.Caption:='Count: '+inttostr(LV.Items.Count);
      end;
      if i in [1..16] then begin
        AddToLV(AddrH,false,tmpsV,'');
        lbCount.Caption:='Count: '+inttostr(LV.Items.Count);
      end;
     end;
    end;
  end;
  SetColumnWidth;
 end;
 finally
  LV.Items.EndUpdate;
  Screen.Cursor:=crDefault;
 end;
end;

procedure TfmDumpMem.pmROPopup(Sender: TObject);
var
  pt:TPoint;
  cols,rows: integer;
begin
  getCursorPos(pt);
  pt:=sg.ScreenToClient(pt);
  sg.MouseToCell(pt.x,pt.y,cols,rows);
  if (rows=0)and(cols=0) then begin
   miAddToLV.Enabled:=false;
  end else begin
   miAddToLV.Enabled:=true;
  end;
  if (rows=0) then begin
   miAddToLV.Enabled:=false;
  end else begin
//   miAddToLV.Enabled:=true;
  end;
  if (cols=0) then begin
   miAddToLV.Enabled:=false;
  end else begin
//   miAddToLV.Enabled:=true;
  end;
  if ColRowInRect(sg.Selection,cols,rows) then begin
   miAddToLV.Enabled:=true;
  end else begin
   miAddToLV.Enabled:=false;
  end;
end;

procedure TfmDumpMem.ClearSelectionInGrid;
var
  i,j: Integer;
  rc: TGridRect;
begin
  exit;
  rc:=sg.Selection;
  for i:=rc.Left to rc.Right do begin
    for j:=rc.top to rc.Bottom do begin
      rc.Left:=0;
      rc.Right:=0;
      rc.Top:=0;
      rc.Bottom:=0;
    end;
  end;
end;

function TfmDumpMem.ColRowInRect(rc:TGridrect; Col,Row: Integer): Boolean;
var
  i,j: Integer;
begin
  Result:=False;
  for i:=rc.Left to rc.Right do begin
    for j:=rc.top to rc.Bottom do begin
      if (Col=i)and(Row=j)then begin
        result:=true;
        exit;
      end;
    end;
  end;
end;

procedure TfmDumpMem.sgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cols,rows: integer;
begin
  if Button=mbRight then begin
   sg.MouseToCell(x,y,cols,rows);
   if not cbMulti.Checked then begin
    if (rows<>0) and (cols<>0) then begin
     sg.row:=rows;
     sg.Col:=cols;
    end;
   end else begin

   end;
  end;
end;

procedure TfmDumpMem.cbMultiClick(Sender: TObject);
begin
  if cbMulti.Checked then begin
   sg.Options:=sg.Options-[goEditing]+[goRangeSelect];
   ClearSelectionInGrid;
  end else begin
   sg.Options:=sg.Options+[goEditing]-[goRangeSelect];
   ClearSelectionInGrid;
  end;
end;

procedure TfmDumpMem.miSpecClick(Sender: TObject);
var
  fm: TfmSpecific;
  li: TListItem;
  index: Integer;
  IndexR: Integer;
begin
  fm:=TfmSpecific.Create(nil);
  fm.FormStyle:=FormStyle;
  li:=LV.Selected;
  if Li<>nil then begin
   fm.edValue.Text:=Li.SubItems.Strings[2];
  end;
  if fm.ShowModal=mrOk then begin
    index:=0;
    if fm.rbNewValue.Checked then index:=0;
    if fm.rbOldValue.Checked then index:=1;
    if fm.rbType.Checked then index:=2;
    if fm.rbAddress.Checked then index:=3;
    if fm.rbHint.Checked then index:=4;
    IndexR:=0;
    if fm.rbRemove.Checked then IndexR:=0;
    if fm.rbSelect.Checked then IndexR:=1;
    if fm.rbCheck.Checked then IndexR:=2;
    if fm.rbChange.Checked then IndexR:=3;

    OperatinsFromLV(Index,IndexR,fm.edValue.Text,fm.edChange.Text);
    SetColumnWidth;
  end;
  fm.Free;
end;

procedure TfmDumpMem.OperatinsFromLV(Index,IndexR: Integer;Value,ValueChange: string);
var
  i: Integer;
  li: TlistItem;
begin
  for i:=LV.Items.Count-1 downto 0 do begin
    li:=LV.Items[i];
    case Index of
      0: begin
       if AnsiUpperCase(Li.SubItems.Strings[2])=AnsiUpperCase(Value) then
         case IndexR of
           0: Li.Delete;
           1: Li.Selected:=true;
           2: Li.Checked:=true;
           3: Li.SubItems.Strings[2]:=ValueChange;
         end;
      end;
      1: begin
       if AnsiUpperCase(Li.SubItems.Strings[1])=AnsiUpperCase(Value) then
         case IndexR of
           0: Li.Delete;
           1: Li.Selected:=true;
           2: Li.Checked:=true;
           3: Li.SubItems.Strings[1]:=ValueChange;
         end;
      end;
      2: begin
       if AnsiUpperCase(Li.SubItems.Strings[0])=AnsiUpperCase(Value) then
         case IndexR of
           0: Li.Delete;
           1: Li.Selected:=true;
           2: Li.Checked:=true;
           3: Li.SubItems.Strings[0]:=ValueChange;
         end;
      end;
      3: begin
       if AnsiUpperCase(Li.Caption)=AnsiUpperCase(Value) then
         case IndexR of
           0: Li.Delete;
           1: Li.Selected:=true;
           2: Li.Checked:=true;
           3: Li.Caption:=ValueChange;
         end;
      end;
      4: begin
       if AnsiUpperCase(Li.SubItems.Strings[3])=AnsiUpperCase(Value) then
         case IndexR of
           0: Li.Delete;
           1: Li.Selected:=true;
           2: Li.Checked:=true;
           3: Li.SubItems.Strings[3]:=ValueChange;
         end;
      end;
    end;
  end;
end;

procedure TfmDumpMem.SearchValue(FromAddress, ToAddress: LongWord;
                           Value: string;
                           IsString,
                           IsCharcase,
                           IsStopFirst,DemoInfo,ShowTime: Boolean;
                           IndexM: Integer);

  function GetCanRead(PageProtect: DWORD): Boolean;
  begin
    result:=false;
    case PageProtect of
       PAGE_READONLY: Result:=fmSearch.chbPAGE_READONLY.Checked;
       PAGE_READWRITE:Result:=fmSearch.chbPAGE_READWRITE.Checked;
       PAGE_WRITECOPY:Result:=fmSearch.chbPAGE_WRITECOPY.Checked;
       PAGE_EXECUTE:Result:=fmSearch.chbPAGE_EXECUTE.Checked;
       PAGE_EXECUTE_READ:Result:=fmSearch.chbPAGE_EXECUTE_READ.Checked;
       PAGE_EXECUTE_READWRITE:Result:=fmSearch.chbPAGE_EXECUTE_READWRITE.Checked;
       PAGE_EXECUTE_WRITECOPY:Result:=fmSearch.chbPAGE_EXECUTE_WRITECOPY.Checked;
       PAGE_GUARD:Result:=fmSearch.chbPAGE_GUARD.Checked;
       PAGE_NOACCESS:Result:=fmSearch.chbPAGE_NOACCESS.Checked;
       PAGE_NOCACHE:Result:=fmSearch.chbPAGE_NOCACHE.Checked;
    end;
  end;

  procedure ViewInfo(i,fa,ta: Longword; CF: Integer; TMBI: TmemoryBasicInformation);
  var
    ppp: Integer;
    PM: PInfoModules;
  begin
       ppp:=Round(100*((i-FA)/1000)/((TA-FA)/1000));
       fmProgress.gag.Progress:=ppp;
      if DemoInfo then begin
       fmProgress.lbCurAddr.Caption:=inttohex(i,8);
       fmProgress.lbSize.Caption:=Format('%4.3f', [((i-FA)/1024)/1024]);
       fmProgress.lbFounded.caption:=inttostr(CF);
       PM:=GetModuleName(i);
       if PM<>nil then begin
         fmProgress.lbCurMod.Caption:=PM.Name;
         fmProgress.lbModSize.Caption:=Format('%4.3f', [(PM.Size/1024)/1024]);
       end else begin
         fmProgress.lbCurMod.Caption:='NONE';
         fmProgress.lbModSize.Caption:='0';
       end;
       fmProgress.lbPageProt.Caption:=getAllocationProtect(TMBI.Protect);
       fmProgress.lbRegSize.Caption:=inttostr(TMBI.RegionSize);
       fmProgress.LbSizeFromReg.caption:='0';
       fmProgress.lbPageState.Caption:=getState(TMBI.State);
      end;
       fmProgress.Update;
  end;

var
  ProcId: LongInt;
  PH: THandle;
  MemSize: LongWord;
  ProcMem: Pointer;
  NumRead: DWord;
  ToAddr: LongWord;
  i,j: LongWord;
  CountFonded: LongInt;
  TMBI: TmemoryBasicInformation;
  CanRead: Boolean;
  PM: PInfoModules;
  FromA,ToAd,TA: LonGWord;
  t1,t2: TDateTime;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  MemSize:=PageSize;
  Screen.Cursor := crHourGlass;
  ToAddr:=ToAddress;
  i:=FromAddress;
  fmProgress.BorderStyle:=bsSingle;
  fmProgress.btStop.Enabled:=true;
  fmProgress.pnProg.BevelOuter:=bvNone;
  fmProgress.pnProg.BevelInner:=bvNone;
  if not DemoInfo then begin
   fmProgress.pnSlow.Visible:=false;
   fmProgress.ClientHeight:=fmProgress.pnProg.Height;
   fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
  end else begin
   fmProgress.pnSlow.Visible:=true;
   fmProgress.ClientHeight:=fmProgress.pnProg.Height+134;
   fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
  end;
  //fmProgress.BorderIcons:=fmProgress.BorderIcons+[biSystemMenu];
  fmProgress.gag.Progress:=0;
  fmProgress.btStop.Caption:='Stop';
  fmProgress.btStop.OnClick:=fmProgress.btStopClick;
  fmProgress.Caption:=SearchCaption;
  fmProgress.show;
  self.Enabled:=false;
  CountFonded:=0;
  breaksearch:=false;
  FromA:=0;
  TA:=0;
  ToAd:=0;
  setValuesToProgress(i);
  t1:=Time;
  if cbStart.Items.Count<>0 then begin
     FromA:=PInfoModules(cbStart.Items.Objects[0]).Address;
     ToAd:=PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Address+
           PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Size;
     TA:=ToAd;
     if ToAddr<ToAd then begin
       ToAd:=ToAddr;
     end;
  end;
  case IndexM of
   0: begin
    while i<ToAddr do begin
     Application.ProcessMessages;
     if BreakSearch then break;
     VirtualQueryEx(PH,Pointer(i),TMBI,sizeof(TMBI));
     CanRead:=GetCanRead(TMBI.Protect);
     if CanRead then begin
      ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
      GetMem(ProcMem,MemSize);
      if readProcessMemory(PH,Pointer(i),ProcMem,MemSize,NumRead)then begin
       if IsString then begin
         CountFonded:=CountFonded+GetCountFoundedSFast(i,ToAddr,ProcMem,NumRead,Value,IsCharcase,
                    CountFonded,FromAddress,IsStopFirst,DemoInfo);
       end else begin
        CountFonded:=CountFonded+GetCountFoundedHFast(i,ToAddr,ProcMem,NumRead,Value,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
       end;
      end;
      FreeMem(ProcMem,MemSize);
     end;
     inc(i,MemSize);
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
  end;
  1: begin
     for i:=0 to cbStart.Items.Count-1 do begin
      PM:=PInfoModules(cbStart.Items.Objects[i]);
      j:=Pm.Address;
      if j>=ToAd then break;
      while j<(PM.Address+PM.Size) do begin
        Application.ProcessMessages;
        if BreakSearch then break;
        if j>=ToAd then break;
        VirtualQueryEx(PH,Pointer(j),TMBI,sizeof(TMBI));
         CanRead:=GetCanRead(TMBI.Protect);
         if CanRead then begin
          ViewInfo(j,FromA,TA,CountFonded,TMBI);
          GetMem(ProcMem,MemSize);
          if readProcessMemory(PH,Pointer(j),ProcMem,MemSize,NumRead)then begin
           if IsString then begin
            CountFonded:=CountFonded+GetCountFoundedSFast(j,ToAd,ProcMem,NumRead,Value,IsCharcase,
                    CountFonded,FromA,IsStopFirst,DemoInfo);
           end else begin
            CountFonded:=CountFonded+GetCountFoundedHFast(j,ToAd,ProcMem,NumRead,Value,
                     CountFonded,FromA,IsStopFirst,DemoInfo);
           end;
          end;
          FreeMem(ProcMem,MemSize);
         end;
         inc(j,MemSize);
      end;
     end;
     fmProgress.gag.Progress:=100;
     fmProgress.Update;
   end;
   2: begin
    while i<ToAd do begin
     Application.ProcessMessages;
     if BreakSearch then break;
     VirtualQueryEx(PH,Pointer(i),TMBI, sizeof(TMBI));
     PM:=GetModuleName(i);
     if PM=nil then begin
       CanRead:=GetCanRead(TMBI.Protect);
       if CanRead then begin
        ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
        GetMem(ProcMem,MemSize);
        if readProcessMemory(PH,Pointer(i),ProcMem,MemSize,NumRead)then begin
         if IsString then begin
          CountFonded:=CountFonded+GetCountFoundedSFast(i,ToAd,ProcMem,NumRead,Value,IsCharcase,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end else begin
          CountFonded:=CountFonded+GetCountFoundedHFast(i,ToAd,ProcMem,NumRead,Value,
                      CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end;
        end;// end of readmem
        FreeMem(ProcMem,MemSize);
       end;// end of canread
     end; // end of PM
     i:=i+MemSize;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
  end;
  fmProgress.btStopClick(nil);
//  if DemoInfo then fmProgress.Close;
  self.Enabled:=true;
  SetColumnWidth;
  Screen.Cursor := crDefault;
  CloseHandle(PH);
  t2:=Time;
  if ShowTime then begin
    MessageBox(Application.Handle,Pchar('Time is: '+TimeTostr(t2-t1)),Pchar('Info'),MB_ICONINFORMATION);
  end;
end;

procedure TfmDumpMem.SearchValueOptimize(FromAddress, ToAddress: LongWord;
                           Value: string;
                           IsString,
                           IsCharcase,
                           IsStopFirst,DemoInfo,ShowTime: Boolean;
                           IndexM: Integer);

  function GetCanRead(PageProtect: DWORD): Boolean;
  begin
    result:=false;
    case PageProtect of
       PAGE_READONLY: Result:=fmSearch.chbPAGE_READONLY.Checked;
       PAGE_READWRITE:Result:=fmSearch.chbPAGE_READWRITE.Checked;
       PAGE_WRITECOPY:Result:=fmSearch.chbPAGE_WRITECOPY.Checked;
       PAGE_EXECUTE:Result:=fmSearch.chbPAGE_EXECUTE.Checked;
       PAGE_EXECUTE_READ:Result:=fmSearch.chbPAGE_EXECUTE_READ.Checked;
       PAGE_EXECUTE_READWRITE:Result:=fmSearch.chbPAGE_EXECUTE_READWRITE.Checked;
       PAGE_EXECUTE_WRITECOPY:Result:=fmSearch.chbPAGE_EXECUTE_WRITECOPY.Checked;
       PAGE_GUARD:Result:=fmSearch.chbPAGE_GUARD.Checked;
       PAGE_NOACCESS:Result:=fmSearch.chbPAGE_NOACCESS.Checked;
       PAGE_NOCACHE:Result:=fmSearch.chbPAGE_NOCACHE.Checked;
    end;
  end;

  procedure ViewInfo(i,fa,ta: Longword; CF: Integer; TMBI: TmemoryBasicInformation);
  var
    ppp: Integer;
    PM: PInfoModules;
  begin
       ppp:=Round(100*((i-FA)/1000)/((TA-FA)/1000));
       fmProgress.gag.Progress:=ppp;
      if DemoInfo then begin
       fmProgress.lbCurAddr.Caption:=inttohex(i,8);
       fmProgress.lbSize.Caption:=Format('%4.3f', [((i-FA)/1024)/1024]);
       fmProgress.lbFounded.caption:=inttostr(CF);
       PM:=GetModuleName(i);
       if PM<>nil then begin
         fmProgress.lbCurMod.Caption:=PM.Name;
         fmProgress.lbModSize.Caption:=Format('%4.3f', [(PM.Size/1024)/1024]);
       end else begin
         fmProgress.lbCurMod.Caption:='NONE';
         fmProgress.lbModSize.Caption:='0';
       end;
       fmProgress.lbPageProt.Caption:=getAllocationProtect(TMBI.Protect);
       fmProgress.lbRegSize.Caption:=inttostr(TMBI.RegionSize);
       fmProgress.lbPageState.Caption:=getState(TMBI.State);
       fmProgress.LbSizeFromReg.caption:='0';
      end;
       fmProgress.Update;
  end;

var
  ProcId: LongInt;
  PH: THandle;
  ProcMem: Pointer;
  NumRead: DWord;
  ToAddr: LongWord;
  i,j: LongWord;
  CountFonded: LongInt;
  TMBI: TmemoryBasicInformation;
  CanRead: Boolean;
  FromA,ToAd,TA: LonGWord;
  PM: PInfoModules;
  t1,t2: TDateTime;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  Screen.Cursor := crHourGlass;
  ToAddr:=ToAddress;
  i:=FromAddress;
  fmProgress.BorderStyle:=bsSingle;
  fmProgress.btStop.Enabled:=true;
  fmProgress.pnProg.BevelOuter:=bvNone;
  fmProgress.pnProg.BevelInner:=bvNone;
  if not DemoInfo then begin
   fmProgress.pnSlow.Visible:=false;
   fmProgress.ClientHeight:=fmProgress.pnProg.Height;
   fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
  end else begin
   fmProgress.pnSlow.Visible:=true;
   fmProgress.ClientHeight:=fmProgress.pnProg.Height+134;
   fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
  end;
  //fmProgress.BorderIcons:=fmProgress.BorderIcons+[biSystemMenu];
  fmProgress.gag.Progress:=0;
  fmProgress.btStop.Caption:='Stop';
  fmProgress.btStop.OnClick:=fmProgress.btStopClick;
  fmProgress.Caption:=SearchCaption;
  fmProgress.show;

  self.Enabled:=false;
  CountFonded:=0;
  breaksearch:=false;
  FromA:=0;
  TA:=0;
  ToAd:=0;
  setValuesToProgress(i);
  t1:=time;
  if cbStart.Items.Count<>0 then begin
     FromA:=PInfoModules(cbStart.Items.Objects[0]).Address;
     ToAd:=PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Address+
           PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Size;
     TA:=ToAd;
     if ToAddr<ToAd then begin
       ToAd:=ToAddr;
     end;
  end;
  case IndexM of
   0: begin
    while i<ToAd do begin
     Application.ProcessMessages;
     if BreakSearch then break;
     VirtualQueryEx(PH,Pointer(i),TMBI, sizeof(TMBI));
     if TMBI.State=MEM_COMMIT then begin
      CanRead:=GetCanRead(TMBI.Protect);
      if CanRead then begin
       ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
       GetMem(ProcMem,TMBI.RegionSize);
       if readProcessMemory(PH,Pointer(i),ProcMem,TMBI.RegionSize,NumRead)then begin
        if IsString then begin
          CountFonded:=CountFonded+GetCountFoundedSFast(i,ToAd,ProcMem,NumRead,Value,IsCharcase,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end else begin
          CountFonded:=CountFonded+GetCountFoundedHFast(i,ToAd,ProcMem,NumRead,Value,
                      CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end;
        end;
        FreeMem(ProcMem,TMBI.RegionSize);
       end;
     end;
     i:=i+TMBI.RegionSize;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
   1: begin
     for i:=0 to cbStart.Items.Count-1 do begin
      PM:=PInfoModules(cbStart.Items.Objects[i]);
      j:=Pm.Address;
      if j>=ToAd then break;
      while j<(PM.Address+PM.Size) do begin
        Application.ProcessMessages;
        if BreakSearch then break;
        if j>=ToAd then break;
        VirtualQueryEx(PH,Pointer(j),TMBI, sizeof(TMBI));
        CanRead:=GetCanRead(TMBI.Protect);
         if CanRead then begin
          ViewInfo(j,FromA,TA,CountFonded,TMBI);
          GetMem(ProcMem,TMBI.RegionSize);
          if readProcessMemory(PH,Pointer(j),ProcMem,TMBI.RegionSize,NumRead)then begin
           if IsString then begin
            CountFonded:=CountFonded+GetCountFoundedSFast(j,ToAd,ProcMem,NumRead,Value,IsCharcase,
                    CountFonded,FromA,IsStopFirst,DemoInfo);
           end else begin
            CountFonded:=CountFonded+GetCountFoundedHFast(j,ToAd,ProcMem,NumRead,Value,
                     CountFonded,FromA,IsStopFirst,DemoInfo);
           end;
          end;
          FreeMem(ProcMem,TMBI.RegionSize);
         end;
       inc(j,TMBI.RegionSize);
      end;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
   2: begin
    while i<ToAd do begin
     Application.ProcessMessages;
     if BreakSearch then begin
      break;
     end;
     VirtualQueryEx(PH,Pointer(i),TMBI, sizeof(TMBI));
     PM:=GetModuleName(i);
     if PM=nil then begin
      if TMBI.State=MEM_COMMIT then begin
       CanRead:=GetCanRead(TMBI.Protect);
       if CanRead then begin
        ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
        GetMem(ProcMem,TMBI.RegionSize);
        if readProcessMemory(PH,Pointer(i),ProcMem,TMBI.RegionSize,NumRead)then begin
         if IsString then begin
          CountFonded:=CountFonded+GetCountFoundedSFast(i,ToAd,ProcMem,NumRead,Value,IsCharcase,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end else begin
          CountFonded:=CountFonded+GetCountFoundedHFast(i,ToAd,ProcMem,NumRead,Value,
                      CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end;
        end;// end of readmem
        FreeMem(ProcMem,TMBI.RegionSize);
       end;// end of canread
      end;// end of state
     end; // end of PM
     i:=i+TMBI.RegionSize;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
  end;
  fmProgress.btStopClick(nil);
//  if DemoInfo then fmProgress.Close;
  self.Enabled:=true;
  SetColumnWidth;
  Screen.Cursor := crDefault;
  CloseHandle(PH);
  t2:=Time;
  if ShowTime then begin
    MessageBox(Application.Handle,Pchar('Time is: '+TimeTostr(t2-t1)),Pchar('Info'),MB_ICONINFORMATION);
  end;
end;

function TfmDumpMem.GetCountFoundedSFast(CurAddr, ToAdV:LongWord; ProcMem: Pointer;
                    Numread: LongWord; Value: String; IsCharcase: Boolean;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

  function getCountFromPos(ind: LongWord): Boolean;
  var
    tmps: string;
    lv: Integer;
  begin
   result:=false;
    lv:=Length(Value);
    if (LongWord(ind)+LongWord(lv))>Numread then begin
     exit;
    end;
    setlength(tmps,lv);
    Move(Pointer(LongWord(ProcMem)+ind+0)^,Pchar(tmps)^,lv);
    if isCharCase then begin
      if Pos(tmps,Value)=1 then begin
       result:=true;
      end;
    end else begin
      if UpperCaseEX(tmps)=UpperCaseEX(Value) then begin
       result:=true;
       exit;
      end;
    end;
    Setlength(tmps,StrLen(Pchar(tmps)));
  end;

var
  i: LongWord;
  ch1,ch2: char;
  incCount: LongInt;
  newCount: Integer;
begin
  ch1:=Value[1];
  incCount:=0;
 if isCharCase then begin
  for i:=0 to Numread-1 do begin
    Application.ProcessMessages;
    if BreakSearch then break;
    if (CurAddr+i)>=ToAdV then break;
    Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
     if ch2=ch1 then begin
       newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then
         AddToLV(CurAddr+LongWord(i),true,Value,'');
       if incCount=1 then
         if IsStopFirst then Break;
       if DemoInfo then begin
        fmProgress.lbCurAddr.Caption:=inttohex(LongWord(CurAddr)+LongWord(i),8);
        fmProgress.lbSize.Caption:=floattostr((((CurAddr-FromAddress)+LongWord(i))/1024)/1024);
        fmProgress.lbSize.Caption:=Format('%4.3f', [(((CurAddr-FromAddress)+LongWord(i))/1024)/1024]);
        fmProgress.lbFounded.caption:=inttostr(CountFonded+incCount);
        fmProgress.LbSizeFromReg.caption:=inttostr(i);
        fmProgress.Update;
       end;
     end;
   end;
  end else begin
   ch1:=UpperCaseEX(ch1)[1];
   for i:=0 to Numread-1 do begin
     Application.ProcessMessages;
     if BreakSearch then break;
     if (CurAddr+i)>=ToAdV then break;
     Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
     if UpperCaseEX(ch2)=ch1 then begin
        newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then
         AddToLV(CurAddr+LongWord(i),true,UpperCaseEX(Value),'');
       if incCount=1 then
         if IsStopFirst then Break;
       if DemoInfo then begin
        fmProgress.lbCurAddr.Caption:=inttohex(LongWord(CurAddr)+LongWord(i),8);
        fmProgress.lbSize.Caption:=Format('%4.3f', [(((CurAddr-FromAddress)+LongWord(i))/1024)/1024]);
        fmProgress.lbFounded.caption:=inttostr(CountFonded+incCount);
        fmProgress.LbSizeFromReg.caption:=inttostr(i);
        fmProgress.Update;
       end;
     end;
    end;
  end;
  result:=incCount;
end;

function TfmDumpMem.GetCountFoundedHFast(CurAddr, ToAdV:LongWord; ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

  function getCountFromPos(ind: LongWord): Boolean;
  var
    news: string;
    tmps: string;
    lv: Integer;
  begin
   result:=false;
   try
    news:=GetStringFromHex(Value);
    lv:=Length(news);
    if (ind+LongWord(lv))>Numread then begin
     exit;
    end;
    setlength(tmps,lv);
    Move(Pointer(LongWord(ProcMem)+ind+0)^,Pchar(tmps)^,lv);
    if Pos(tmps,news)=1 then begin
       result:=true;
    end;
    Setlength(tmps,StrLen(Pchar(tmps)));
   except on E: Exception do begin
     caption:=inttostr(ind)+' - '+inttostr(LongWord(Length(news)));
    end;
   end;
  end;

var
  i: longWord;
  ch1,ch2: char;
  incCount: LongInt;
  newCount: Integer;
  isOdd: Boolean;
begin
  isOdd:=Odd(Length(Value));
  if isOdd then begin
    ch1:=Char(strtoint('$0'+Value[1]));
  end else begin
    ch1:=Char(strtoint('$'+Value[1]+Value[2]));
  end;
  incCount:=0;
  for i:=0 to Numread-1 do begin
    Application.ProcessMessages;
    if BreakSearch then break;
    if (CurAddr+i)>=ToAdV then break;

    Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
    if ch2=ch1 then begin
       newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then begin
         AddToLV(CurAddr+LongWord(i),false,Value,'');
       end;
       if incCount=1 then
         if IsStopFirst then Break;
       if DemoInfo then begin
        fmProgress.lbCurAddr.Caption:=inttohex(LongWord(CurAddr)+LongWord(i),8);
        fmProgress.lbSize.Caption:=Format('%4.3f', [(((CurAddr-FromAddress)+LongWord(i))/1024)/1024]);
        fmProgress.lbFounded.caption:=inttostr(CountFonded+incCount);
        fmProgress.LbSizeFromReg.caption:=inttostr(i);
        fmProgress.Update;
       end;
    end;
  end;
  result:=incCount;
end;

procedure TfmDumpMem.SearchValueSuperFast(FromAddress, ToAddress: LongWord;
                      Value: string; IsString,IsCharcase,IsStopFirst,DemoInfo,ShowTime: Boolean;
                      IndexM: Integer);
  function GetCanRead(PageProtect: DWORD): Boolean;
  begin
    result:=false;
    case PageProtect of
       PAGE_READONLY: Result:=fmSearch.chbPAGE_READONLY.Checked;
       PAGE_READWRITE:Result:=fmSearch.chbPAGE_READWRITE.Checked;
       PAGE_WRITECOPY:Result:=fmSearch.chbPAGE_WRITECOPY.Checked;
       PAGE_EXECUTE:Result:=fmSearch.chbPAGE_EXECUTE.Checked;
       PAGE_EXECUTE_READ:Result:=fmSearch.chbPAGE_EXECUTE_READ.Checked;
       PAGE_EXECUTE_READWRITE:Result:=fmSearch.chbPAGE_EXECUTE_READWRITE.Checked;
       PAGE_EXECUTE_WRITECOPY:Result:=fmSearch.chbPAGE_EXECUTE_WRITECOPY.Checked;
       PAGE_GUARD:Result:=fmSearch.chbPAGE_GUARD.Checked;
       PAGE_NOACCESS:Result:=fmSearch.chbPAGE_NOACCESS.Checked;
       PAGE_NOCACHE:Result:=fmSearch.chbPAGE_NOCACHE.Checked;
    end;
  end;

  procedure ViewInfo(i,fa,ta: Longword; CF: Integer; TMBI: TmemoryBasicInformation);
  var
    ppp: Integer;
  begin
       ppp:=Round(100*((i-FA)/1000)/((TA-FA)/1000));
       fmProgress.gag.Progress:=ppp;
       fmProgress.Update;
  end;

var
  ProcId: LongInt;
  PH: THandle;
  ProcMem: Pointer;
  NumRead: DWord;
  ToAddr: LongWord;
  i,j: LongWord;
  CountFonded: LongInt;
  TMBI: TmemoryBasicInformation;
  CanRead: Boolean;
  FromA,ToAd,TA: LonGWord;
  PM: PInfoModules;
  t1,t2: TDateTime;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  Screen.Cursor := crHourGlass;
  ToAddr:=ToAddress;
  i:=FromAddress;
  fmProgress.BorderStyle:=bsNone;
  fmProgress.btStop.Enabled:=false;
  fmProgress.pnSlow.Visible:=false;
  fmProgress.pnProg.BevelOuter:=bvRaised;
  fmProgress.pnProg.BevelInner:=bvRaised;
  fmProgress.ClientHeight:=fmProgress.pnProg.Height;
  fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
//  fmProgress.BorderIcons:=fmProgress.BorderIcons-[biSystemMenu];
  fmProgress.gag.Progress:=0;
  fmProgress.btStop.Caption:='Stop';
  fmProgress.btStop.OnClick:=fmProgress.btStopClick;
  fmProgress.Caption:=SearchCaption;
  fmProgress.show;
  self.Enabled:=false;
  CountFonded:=0;
  breaksearch:=false;
  FromA:=0;
  TA:=0;
  ToAd:=0;
  setValuesToProgress(i);
  ClearListSearch;
  t1:=time;
  if cbStart.Items.Count<>0 then begin
     FromA:=PInfoModules(cbStart.Items.Objects[0]).Address;
     ToAd:=PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Address+
           PInfoModules(cbStart.Items.Objects[cbStart.Items.Count-1]).Size;
     TA:=ToAd;
     if ToAddr<ToAd then begin
       ToAd:=ToAddr;
     end;
  end;
  case IndexM of
   0: begin
    while i<ToAd do begin
     VirtualQueryEx(PH,Pointer(i),TMBI, sizeof(TMBI));
     if TMBI.State=MEM_COMMIT then begin
      CanRead:=GetCanRead(TMBI.Protect);
      if CanRead then begin
       ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
       GetMem(ProcMem,TMBI.RegionSize);
       if readProcessMemory(PH,Pointer(i),ProcMem,TMBI.RegionSize,NumRead)then begin
        if IsString then begin
          CountFonded:=CountFonded+GetCountFoundedSSuperFast(i,ToAd,ProcMem,NumRead,Value,IsCharcase,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end else begin
          CountFonded:=CountFonded+GetCountFoundedHSuperFast(i,ToAd,ProcMem,NumRead,Value,
                      CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end;
        end;
        FreeMem(ProcMem,TMBI.RegionSize);
       end;
     end;
     i:=i+TMBI.RegionSize;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
   1: begin
     for i:=0 to cbStart.Items.Count-1 do begin
      PM:=PInfoModules(cbStart.Items.Objects[i]);
      j:=Pm.Address;
      if j>=ToAd then break;
      while j<(PM.Address+PM.Size) do begin
        if j>=ToAd then break;
        VirtualQueryEx(PH,Pointer(j),TMBI, sizeof(TMBI));
        CanRead:=GetCanRead(TMBI.Protect);
         if CanRead then begin
          ViewInfo(j,FromA,TA,CountFonded,TMBI);
          GetMem(ProcMem,TMBI.RegionSize);
          if readProcessMemory(PH,Pointer(j),ProcMem,TMBI.RegionSize,NumRead)then begin
           if IsString then begin
            CountFonded:=CountFonded+GetCountFoundedSSuperFast(j,ToAd,ProcMem,NumRead,Value,IsCharcase,
                    CountFonded,FromA,IsStopFirst,DemoInfo);
           end else begin
            CountFonded:=CountFonded+GetCountFoundedHSuperFast(j,ToAd,ProcMem,NumRead,Value,
                     CountFonded,FromA,IsStopFirst,DemoInfo);
           end;
          end;
          FreeMem(ProcMem,TMBI.RegionSize);
         end;
       inc(j,TMBI.RegionSize);
      end;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
   2: begin
    while i<ToAd do begin
     VirtualQueryEx(PH,Pointer(i),TMBI, sizeof(TMBI));
     PM:=GetModuleName(i);
     if PM=nil then begin
      if TMBI.State=MEM_COMMIT then begin
       CanRead:=GetCanRead(TMBI.Protect);
       if CanRead then begin
        ViewInfo(i,FromAddress,ToAddr,CountFonded,TMBI);
        GetMem(ProcMem,TMBI.RegionSize);
        if readProcessMemory(PH,Pointer(i),ProcMem,TMBI.RegionSize,NumRead)then begin
         if IsString then begin
          CountFonded:=CountFonded+GetCountFoundedSSuperFast(i,ToAd,ProcMem,NumRead,Value,IsCharcase,
                     CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end else begin
          CountFonded:=CountFonded+GetCountFoundedHSuperFast(i,ToAd,ProcMem,NumRead,Value,
                      CountFonded,FromAddress,IsStopFirst,DemoInfo);
         end;
        end;// end of readmem
        FreeMem(ProcMem,TMBI.RegionSize);
       end;// end of canread
      end;// end of state
     end; // end of PM
     i:=i+TMBI.RegionSize;
    end;
    fmProgress.gag.Progress:=100;
    fmProgress.Update;
   end;
  end;
  fmProgress.btStopClick(nil);
  fmProgress.btStop.Enabled:=true;
  fmProgress.Close;
  self.Enabled:=true;
  Screen.Cursor := crDefault;
  CloseHandle(PH);
  t2:=Time;
  if ShowTime then begin
    MessageBox(Application.Handle,Pchar('Time is: '+TimeTostr(t2-t1)),Pchar('Info'),MB_ICONINFORMATION);
  end;
   if ListSearch.Count<>0 then begin
    if MessageBox(Application.Handle,
                Pchar('Found is: '+inttostr(ListSearch.Count)+#13+
                'Insert to ListView ?'),
                Pchar('Question'),MB_YESNO+MB_ICONQUESTION)=IDYes then begin
     InsertToListViewFromListSearch;
    end;
    ViewCountMem;
   end;
end;

function TfmDumpMem.GetCountFoundedSSuperFast(CurAddr, ToAdV:LongWord; ProcMem: Pointer;
                    Numread: LongWord; Value: String; IsCharcase: Boolean;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

  function getCountFromPos(ind: LongWord): Boolean;
  var
    tmps: string;
    lv: Integer;
  begin
   result:=false;
    lv:=Length(Value);
    if (LongWord(ind)+LongWord(lv))>Numread then begin
     exit;
    end;
    setlength(tmps,lv);
    Move(Pointer(LongWord(ProcMem)+ind+0)^,Pchar(tmps)^,lv);
    if isCharCase then begin
      if Pos(tmps,Value)=1 then begin
       result:=true;
      end;
    end else begin
      if UpperCaseEX(tmps)=UpperCaseEX(Value) then begin
       result:=true;
       exit;
      end;
    end;
    Setlength(tmps,StrLen(Pchar(tmps)));
  end;

var
  i: LongWord;
  ch1,ch2: char;
  incCount: LongInt;
  newCount: Integer;
  lv1: Integer;
begin
  ch1:=Value[1];
  incCount:=0;
  lv1:=Length(Value);
  if isCharCase then begin
   for i:=0 to Numread-1 do begin
    if (CurAddr+i)>=ToAdV then break;
    Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
     if ch2=ch1 then begin
       newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then
         AddToListSearch(CurAddr+LongWord(i),Value,0,lv1);
       if incCount=1 then
         if IsStopFirst then Break;
     end;
   end;
   end else begin
    ch1:=UpperCaseEX(ch1)[1];
    for i:=0 to Numread-1 do begin
     if (CurAddr+i)>=ToAdV then break;
     Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
     if UpperCaseEX(ch2)=ch1 then begin
        newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then
         AddToListSearch(CurAddr+LongWord(i),UpperCaseEX(Value),0,lv1);
       if incCount=1 then
         if IsStopFirst then Break;
     end;
    end;
  end;
  result:=incCount;
end;

function TfmDumpMem.GetCountFoundedHSuperFast(CurAddr, ToAdV:LongWord; ProcMem: Pointer;
                    Numread: LongWord; Value: String;
                    CountFonded: LongInt; FromAddress: Longword;
                    isStopFirst,DemoInfo: Boolean): LongInt;

  function getCountFromPos(ind: LongWord): Boolean;
  var
    news: string;
    tmps: string;
    lv: Integer;
  begin
   result:=false;
    news:=GetStringFromHex(Value);
    lv:=Length(news);
    if (ind+LongWord(lv))>Numread then begin
     exit;
    end;
    setlength(tmps,lv);
    Move(Pointer(LongWord(ProcMem)+ind+0)^,Pchar(tmps)^,lv);
    if Pos(tmps,news)=1 then begin
       result:=true;
    end;
    Setlength(tmps,StrLen(Pchar(tmps)));
  end;

var
  i: longWord;
  ch1,ch2: char;
  incCount: LongInt;
  newCount: Integer;
  isOdd: Boolean;
  lv1: Integer;
begin
  isOdd:=Odd(Length(Value));
  if isOdd then begin
    ch1:=Char(strtoint('$0'+Value[1]));
  end else begin
    ch1:=Char(strtoint('$'+Value[1]+Value[2]));
  end;
  incCount:=0;
  lv1:=Length(Value);
  for i:=0 to Numread-1 do begin
    if (CurAddr+i)>=ToAdV then break;
    Move(Pointer(LongWord(ProcMem)+i)^,ch2,1);
    if ch2=ch1 then begin
       newCount:=Integer(getCountFromPos(i));
       incCount:=incCount+newCount;
       if newCount=1 then begin
        AddToListSearch(CurAddr+LongWord(i),Value,1,lv1 div 2);
       end;
       if incCount=1 then
         if IsStopFirst then Break;
    end;
  end;
  result:=incCount;
end;

procedure TfmDumpMem.setValuesToProgress(Addr: LongWord);
begin
   fmProgress.gag.Progress:=0;
   fmProgress.lbCurAddr.Caption:=inttohex(Addr,8);
   fmProgress.lbSize.Caption:='0';
   fmProgress.lbFounded.caption:='0';
   fmProgress.lbCurMod.Caption:='NONE';
   fmProgress.lbPageProt.Caption:='NONE';
   fmProgress.lbRegSize.Caption:='0';
   fmProgress.LbSizeFromReg.caption:='0';
   fmProgress.lbPageState.Caption:='NONE';
end;

procedure TfmDumpMem.ClearListSearch;
var
  P: PinfoSearch;
  i: Integer;
begin
  for i:=0 to ListSearch.Count-1 do begin
    P:=ListSearch.Items[i];
    Dispose(P);
  end;
  ListSearch.Clear;
end;

procedure TfmDumpMem.AddToListSearch(Addr: LongWord; Value: String;
                     TypeValue: Integer; LengthValue: Integer);
var
  P: PInfoSearch;
begin
  New(P);
  P.Address:=Addr;
  P.Value:=Value;
  P.TypeValue:=TypeValue;
  P.LengthValue:=P.LengthValue;
  ListSearch.Add(P);
end;

procedure TfmDumpMem.InsertToListViewFromListSearch;
var
  i: Integer;
  P: PInfoSearch;
begin
  if ListSearch.Count=MaxInt then begin
   ShowMessage('Found count is very big.');
   exit;
  end;
  BreakFill:=false;
  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
   for i:=0 to ListSearch.Count-1 do begin
    Application.ProcessMessages;
    if BreakFill then break;
    P:=ListsEARCH.iTEMS[I];
    AddToLV(P.Address,not Boolean(P.TypeValue),P.value,'');
    lbCount.Caption:='Count: '+inttostr(LV.Items.Count);
   end;
  SetColumnWidth;
  finally
   Screen.Cursor:=crdefault;
   LV.Items.EndUpdate;
  end; 
end;

function TfmDumpMem.GetModuleName(ca: LongWord): PInfoMOdules;
var
    i: Integer;
    PM: PInfoMOdules;
    MaxA,MinA: Longword;
begin
    Result:=nil;
    for i:=0 to cbStart.Items.Count-1 do begin
      PM:=PInfoModules(cbStart.Items.Objects[i]);
      MinA:=PM.Address;
      MaxA:=PM.Address+PM.Size;
      if (ca>=MinA)and(ca<=MaxA)then begin
        Result:=PM;
        break;
      end;
    end;
end;

procedure TfmDumpMem.btStopFillClick(Sender: TObject);
begin
 BreakFill:=true;
end;

function TfmDumpMem.UpperCaseEX(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  Result:=AnsiUpperCase(S);
  exit;
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    if (Ch >= 'à') and (Ch <= 'ÿ') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

procedure TfmDumpMem.btSaveMemClick(Sender: TObject);
var
  fm: Tfmsavemem;
begin
  fm:=Tfmsavemem.Create(nil);
  fm.FormStyle:=FormStyle;
  fm.FillModule(cbStart);
  fm.CurPageStart:=CurrMemAddr;
  fm.CurPageFinish:=CurrMemAddr+PageSize;
  if fm.ShowModal=mrOk then begin
     case fm.cbOper.ItemIndex of
      0,1,2: SaveMem(fm.FileName,strtoint('$'+fm.edStart.Text),strtoint('$'+fm.edFinish.Text));
     end;
  end;
  fm.Free;
end;

procedure TfmDumpMem.SaveMem(FileName: String;FromAd,ToAd: Longword);

  function GetCanRead(PageProtect: DWORD): Boolean;
  begin
    result:=false;
    case PageProtect of
       PAGE_READONLY: Result:=fmSearch.chbPAGE_READONLY.Checked;
       PAGE_READWRITE:Result:=fmSearch.chbPAGE_READWRITE.Checked;
       PAGE_WRITECOPY:Result:=fmSearch.chbPAGE_WRITECOPY.Checked;
       PAGE_EXECUTE:Result:=fmSearch.chbPAGE_EXECUTE.Checked;
       PAGE_EXECUTE_READ:Result:=fmSearch.chbPAGE_EXECUTE_READ.Checked;
       PAGE_EXECUTE_READWRITE:Result:=fmSearch.chbPAGE_EXECUTE_READWRITE.Checked;
       PAGE_EXECUTE_WRITECOPY:Result:=fmSearch.chbPAGE_EXECUTE_WRITECOPY.Checked;
       PAGE_GUARD:Result:=fmSearch.chbPAGE_GUARD.Checked;
       PAGE_NOACCESS:Result:=fmSearch.chbPAGE_NOACCESS.Checked;
       PAGE_NOCACHE:Result:=fmSearch.chbPAGE_NOCACHE.Checked;
    end;
  end;

  procedure ViewInfo(i,fa,ta: Longword;TMBI: TmemoryBasicInformation);
  var
    ppp: Integer;
    PM: PInfoModules;
  begin
       ppp:=Round(100*((i-FA)/1000)/((TA-FA)/1000));
       fmProgress.gag.Progress:=ppp;
       fmProgress.lbCurAddr.Caption:=inttohex(i,8);
       fmProgress.lbSize.Caption:=Format('%4.3f', [((i-FA)/1024)/1024]);
       PM:=GetModuleName(i);
       if PM<>nil then begin
         fmProgress.lbCurMod.Caption:=PM.Name;
         fmProgress.lbModSize.Caption:=Format('%4.3f', [(PM.Size/1024)/1024]);
       end else begin
         fmProgress.lbCurMod.Caption:='NONE';
         fmProgress.lbModSize.Caption:='0';
       end;
       fmProgress.lbPageProt.Caption:=getAllocationProtect(TMBI.Protect);
       fmProgress.lbRegSize.Caption:=inttostr(TMBI.RegionSize);
       fmProgress.lbPageState.Caption:=getState(TMBI.State);
       fmProgress.LbSizeFromReg.caption:='0';
       fmProgress.Update;
  end;

var
  fs: TFileStream;
  i: LongWord;
  MemSize: LongWord;
  NumRead: LongWord;
  ProcId: LongInt;
  PH: THandle;
  ProcMem: Pointer;
  TMBI: TmemoryBasicInformation;
begin
  if (ToAd-FromAd)<=0 then exit;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;

  if DiskFree(0)<(ToAd-FromAd) then begin
    MessageBox(Application.Handle,Pchar('Does not suffice disk space.'),nil,Mb_Ok+MB_Iconerror);
    exit;
  end;

  self.Enabled:=false;
  breaksearch:=false;
  Screen.Cursor := crHourGlass;
  fmProgress.BorderStyle:=bsSingle;
  fmProgress.btStop.Enabled:=true;
  fmProgress.pnProg.BevelOuter:=bvNone;
  fmProgress.pnProg.BevelInner:=bvNone;
  fmProgress.pnSlow.Visible:=true;
  fmProgress.lbF.Visible:=false;
  fmProgress.ClientHeight:=fmProgress.pnProg.Height+134;
  fmProgress.Top:=Screen.Height div 2 - fmProgress.Height div 2;
  fmProgress.gag.Progress:=0;
  fmProgress.btStop.Caption:='Stop';
  fmProgress.btStop.OnClick:=fmProgress.btStopClick;
  fmProgress.Caption:=SaveCaption;
  fmProgress.show;

  fs:=TFileStream.Create(FileName,fmCreate);
  i:=FromAd;
  while i<ToAd do begin
   Application.ProcessMessages;
   if BreakSearch then break;
   if ToAd-i>=PageSize then
    MemSize:=PageSize
   else MemSize:=ToAd-i;
   VirtualQueryEx(PH,Pointer(i),TMBI,sizeof(TMBI));
   ViewInfo(i,FromAd,ToAd,TMBI);
   GetMem(ProcMem,MemSize);
   if readProcessMemory(PH,Pointer(i),ProcMem,MemSize,NumRead)then begin
     SaveMemory(fs,ProcMem,MemSize);
   end else begin
     FillChar(Procmem^,memSize,0);
     SaveMemory(fs,ProcMem,MemSize);
   end;
   FreeMem(Procmem,MemSize);
   inc(i,memSize);
  end;
  fs.Free;
  fmProgress.gag.Progress:=100;
  fmProgress.Update;
  fmProgress.btStopClick(nil);
  self.Enabled:=true;
  Screen.Cursor := crDefault;
end;

procedure TfmDumpMem.SaveMemory(Stream: TStream;Prcmem: Pointer; SizeMem: LongWord);
begin
  Stream.WriteBuffer(Prcmem^,SizeMem);
end;

procedure TfmDumpMem.LVCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

  procedure DrawItem;
  var
    rt: Trect;
  begin
  //drBounds, drIcon, drLabel, drSelectBounds
    rt:=Item.DisplayRect(drIcon);
    with Sender.Canvas do begin
     brush.Style:=bsSolid;
     brush.Color:=clBtnFace;
     InflateRect(rt,0,-1);
     FillRect(rt);
    end;
  end;

begin
{   If Item=sender.Selected then begin
     if not(cdsSelected in State)then
      DrawItem;
   end;   }
end;

procedure TfmDumpMem.sgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP:begin
      if sg.row=1 then begin
        btPrev.Click;
        sg.row:=sg.RowCount-1;
      end;
    end;
    VK_DOWN:begin
      if sg.row=sg.RowCount-1 then begin
        btNext.Click;
        sg.row:=1;
      end;
    end;
    VK_PRIOR: begin
      if sg.row=1 then begin
        btPrev.Click;
        sg.row:=sg.RowCount-1;
      end;
    end;
    VK_NEXT: begin
      if sg.row=sg.RowCount-1 then begin
        btNext.Click;
        sg.row:=1;
      end;
    end;
  end;
end;

procedure TfmDumpMem.btClearMemClick(Sender: TObject);
begin
  ClearListSearch;
  ViewCountMem;
end;

procedure TfmDumpMem.ViewCountMem;
begin
  btClearMem.Caption:=inttostr(Listsearch.Count);
end;

procedure TfmDumpMem.SearchValueSuperFastForGame(Value: string; IsString,IsCharcase: Boolean);
var
  i: Integer;
  ProcId: LongInt;
  PH: THandle;
  ProcMem: Pointer;
  MemSize,NumRead: LongWord;
  tmps: string;
  FromAddr: LongWord;
  P: PInfoSearch;
  hexstr: string;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  for i:=ListSearch.Count-1 downto 0 do begin
    P:=ListSearch.Items[i];
    if P.TypeValue=0 then begin
      MemSize:=Length(P.Value);
    end else begin
      MemSize:=Length(GetStringFromHex(P.Value));
    end;
    FromAddr:=P.Address;
    GetMem(ProcMem,MemSize);
    if readProcessMemory(PH,Pointer(FromAddr),
                        ProcMem,MemSize,NumRead)then begin
      if P.TypeValue=0 then begin
        setlength(tmps,MemSize);
        Move(Pointer(LongWord(ProcMem))^,Pchar(tmps)^,MemSize);
        if isCharCase then begin
         if Value<>tmps then begin
           ListSearch.Delete(i);
         end;
        end else begin
         if UpperCaseEx(Value)<>UpperCaseEx(tmps) then begin
           ListSearch.Delete(i);
         end;
        end;
        Setlength(tmps,StrLen(Pchar(tmps)));
      end else begin
        setlength(tmps,MemSize);
        Move(Pointer(LongWord(ProcMem))^,Pchar(tmps)^,MemSize);
        hexstr:=GetHexFromString(tmps);
        if (hexstr<>Value) then begin
         ListSearch.Delete(i);
        end;
        Setlength(tmps,StrLen(Pchar(tmps)));
      end;
    end;
    FreeMem(ProcMem,MemSize);
  end;
  CloseHandle(PH);
  if ListSearch.Count<>0 then begin
    if MessageBox(Application.Handle,
                Pchar('Found is: '+inttostr(ListSearch.Count)+#13+
                'Insert to ListView ?'),
                Pchar('Question'),MB_YESNO+MB_ICONQUESTION)=IDYes then begin
     InsertToListViewFromListSearch;
    end;
  end;
  ViewCountMem;
end;

procedure TfmDumpMem.miFontClick(Sender: TObject);
begin
  fd.font.Assign(sg.font);
  if not fd.Execute then exit;
  sg.font.Assign(fd.font);
  re.Font.Assign(fd.font);
end;

procedure TfmDumpMem.cbProtectChange(Sender: TObject);
var
  PH: THandle;
  procid: Dword;
  lpAddress: Pointer;
  lpflOldProtect: DWord;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   procid:=ProcessEntry.th32ProcessID;
  end else begin
   procid:=Proc_id;
  end;
//  PH:=OpenProcess(PROCESS_VM_OPERATION,false,Procid);
  PH:=OpenProcess(PROCESS_ALL_ACCESS,false,Procid);
  if PH=0 then begin
   MessageBox(Application.Handle,Pchar('Process closed'),Pchar('Warning'),MB_ICONWARNING);
   exit;
  end;
  lpAddress:=Pointer(strtoint('$'+lbBaseAddress.Caption));
  if not VirtualProtectEx(
     PH,	// handle of process
     lpAddress,	// address of region of committed pages
     PageSize,	// size of region
     GetAllocProtect(cbProtect.Text),	// desired access protection
     lpflOldProtect 	// address of variable to get old protection
   )then begin
     MessageBox(Application.Handle,Pchar(SysErrorMessage(GetLastError)),nil,MB_ICONERROR);
     cbProtect.ItemIndex:= LastAllocProtectIndex;
   end else begin
     ViewMemBasic(Longword(lpAddress));
   end;
   CloseHandle(PH);
end;

function TfmDumpMem.GetAllocProtect(Text: String): DWord;
begin
    Result:=0;
    if Text='READONLY' then Result:=PAGE_READONLY;
    if Text='READWRITE' then Result:=PAGE_READWRITE;
    if Text='WRITECOPY' then Result:=PAGE_WRITECOPY;
    if Text='EXECUTE' then Result:=PAGE_EXECUTE;
    if Text='EXECUTE_READ' then Result:=PAGE_EXECUTE_READ;
    if Text='EXECUTE_READWRITE' then Result:=PAGE_EXECUTE_READWRITE;
    if Text='EXECUTE_WRITECOPY' then Result:=PAGE_EXECUTE_WRITECOPY;
    if Text='GUARD' then Result:=PAGE_GUARD;
    if Text='NOACCESS' then Result:=PAGE_NOACCESS;
    if Text='NOCACHE' then Result:=PAGE_NOCACHE;
end;

procedure TfmDumpMem.miViewStringClick(Sender: TObject);
begin
  if Sender=miViewHex then begin
   sg.BringToFront;
   cbMulti.Enabled:=true;
   miViewHex.Checked:=true;
   exit;
  end;
  if Sender=miViewString then begin
   pnMemo.BringToFront;
   cbMulti.Enabled:=false;
   miViewString.Checked:=true;
   exit;
  end;
end;

function TfmDumpMem.GetStepCoding: string;
var
  i: Integer;
begin
  Result:=defaultStr;
  for i:=0 to ListStepCoding.Count-1 do begin
    Result:=ConvertString(Result,TTypeCoding(Integer(ListStepCoding.Items[i])));
  end;
end;

procedure TfmDumpMem.cmbCodingChange(Sender: TObject);
begin
 if cmbCoding.ItemIndex<>-1 then begin
  if chbCodingClear.Checked then
   ListStepCoding.Clear;
   
  ListStepCoding.Add(Pointer(cmbCoding.ItemIndex));
  re.Lines.Text:=ParseBadChar(GetStepCoding);
  bibCodingBack.Caption:='Back '+inttostr(ListStepCoding.Count);
  bibCodingBack.Enabled:=true;
 end;
end;

procedure TfmDumpMem.bibCodingBackClick(Sender: TObject);
begin
   ListStepCoding.Delete(ListStepCoding.Count-1);
   re.Lines.Text:=ParseBadChar(GetStepCoding);
   if ListStepCoding.Count>0 then begin
    bibCodingBack.Caption:='Back '+inttostr(ListStepCoding.Count);
    cmbCoding.ItemIndex:=Integer(ListStepCoding.Items[ListStepCoding.Count-1]);
   end else begin
    cmbCoding.ItemIndex:=-1;
    bibCodingBack.Caption:='Back';
    bibCodingBack.Enabled:=false;
   end;
end;

procedure TfmDumpMem.bibCodingDefaultClick(Sender: TObject);
begin
   ListStepCoding.Clear;
   re.Lines.Text:=ParseBadChar(GetStepCoding);
   cmbCoding.ItemIndex:=-1;
   bibCodingBack.Caption:='Back';
   bibCodingBack.Enabled:=false;
end;

end.



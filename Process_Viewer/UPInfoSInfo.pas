unit UPInfoSInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, TlHelp32, ComCtrls, CommCtrl, psapi, Menus,
  ImgList, shellapi;

type

{  TThreadInfo = Record
    ftCreationTime: TFileTime;
    dwUnknown1: DWORD;
    dwStartAddress: DWORD;
    dwOwningPID: DWORD;
    dwThreadID: DWORD;
    dwCurrentPriority: DWORD;
    dwBasePriority: DWORD;
    dwContextSwitches: DWORD;
    dwThreadState: DWORD;
    dwThreadWaitReason: DWORD;
    dwUnknown3: DWORD;
    dwUnknown4: DWORD;
    dwUnknown5: DWORD;
    dwUnknown6: DWORD;
    dwUnknown7: DWORD;
  End;           }

  PThreadInfo=^TThreadInfo;
  TThreadInfo = packed Record
    KernelTime: DWORD;
    UserTime: DWORD;
    CreateTime: DWORD;
    dwStartAddress: DWORD;
    WaitTime: DWord;
    dwThreadID: DWORD;
    dwBasePriority: DWORD;
    dwCurrentPriority: DWORD;
    dwContextSwitches: DWORD;
    dwThreadState: DWORD;
    dwThreadWaitReason: DWORD;
    dwUnknown3: DWORD;
    dwUnknown4: DWORD;
    dwUnknown5: DWORD;
    dwUnknown6: DWORD;
    dwUnknown7: DWORD;
  End;

  PProcessInfo = ^TProcessInfo;
  TProcessInfo = packed  Record
    dwOffset: DWORD;
    dwThreadCount: DWORD;
    dwUnkown1: Array[0..5] Of DWORD;
    ftCreationTime: TFileTime;
    ftUserTime: DWORD;
    ftKernelTime: DWORD;
    dwUnkown4: DWORD;
    dwUnkown5: DWORD;
    dwUnkown6: DWORD;
    pszProcessName: pwideChar;
    dwBasePriority: DWORD;
    dwProcessID: DWORD;
    dwParentProcessID: DWORD;
    dwHandleCount: DWORD;
    dwUnkown7: DWORD;
    dwUnkown8: DWORD;
    dwVirtualBytesPeak: DWORD;
    dwVirtualBytes: DWORD;
    dwPageFaults: DWORD;
    dwWorkingSetPeak: DWORD;
    dwWorkingSet: DWORD;
    dwPeekPagedPoolUsage: DWORD;
    dwPagedPool: DWORD;
    dwPeekNonPagedPoolUsage: DWORD;
    dwNonPagedPool: DWORD;
    dwPageFileBytesPeak: DWORD;
    dwPageFileBytes: DWORD;
    dwPrivateBytes: DWORD;
    dwProcessorTime: DWORD;
    dwUnkown12: DWORD;
    dwUnkown13: DWORD;
    dwUnkown14: DWORD;
    dwUnkown___: Array[0..11] Of DWORD;
    ati: Array[0..0] Of TThreadInfo;
  End;

const
  MaxBufferOfQSI=65535;

type  
  TNtQuerySystemInformation = Function(a: Longint; Buffer: Pointer; SizeBuffer: Longint; Tmp:
    Longint): Longint; stdcall;

const
  OBJ_INHERIT             =$00000002;
  OBJ_PERMANENT           =$00000010;
  OBJ_EXCLUSIVE           =$00000020;
  OBJ_CASE_INSENSITIVE    =$00000040;
  OBJ_OPENIF              =$00000080;
  OBJ_OPENLINK            =$00000100;
  OBJ_VALID_ATTRIBUTES    =$000001F2;

type
  POBJECT_ATTRIBUTES=^TOBJECT_ATTRIBUTES;
  TOBJECT_ATTRIBUTES=packed record
    Length: DWord;
    RootDirectory: Thandle;
    ObjectName: PChar;
    Attributes: DWord;
    SecurityDescriptor: Pointer;
    SecurityQualityOfService: Pointer;
  end;

  PCLIENT_ID=^TCLIENT_ID;
  TCLIENT_ID=packed record
    pid: dword;
    tid: dword;
  end;

  TNtOpenThread=function(hThread: THandle; DesiredAccess: DWord;
                         ObjectAttributes: POBJECT_ATTRIBUTES;
                         ClientId: PCLIENT_ID):BOOL;stdcall;

const
  SYNCHRONIZE=$00100000;
  STANDARD_RIGHTS_REQUIRED=$000F0000;
  THREAD_ALL_ACCESS=(STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $FFF);

type
  TOpenThread=function(DesiredAccess: DWord;
                       bInheritHandle: BOOL;
                       dwThreadId: DWORD):THandle;stdcall;

  TfmPISI = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pc: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    LV: TListView;
    pmThreads: TPopupMenu;
    miThreadWindows: TMenuItem;
    N1: TMenuItem;
    miThreadPri: TMenuItem;
    miThAboveNormal: TMenuItem;
    miThBelowNormal: TMenuItem;
    miThHighest: TMenuItem;
    miThIdle: TMenuItem;
    miThLowest: TMenuItem;
    miThNormal: TMenuItem;
    miThTimeCritical: TMenuItem;
    pmModules: TPopupMenu;
    miModuleUnload: TMenuItem;
    btStopFill: TBitBtn;
    BitBtn1: TBitBtn;
    lbCount: TLabel;
    miFileInfo: TMenuItem;
    btFileInfo: TBitBtn;
    tbsInfo: TTabSheet;
    GroupBox2: TGroupBox;
    lbMemLoad: TLabel;
    lbAvailPageFile: TLabel;
    lbTotalPageFile: TLabel;
    lbPageSize: TLabel;
    lbTotalPhys: TLabel;
    lbAvailPhys: TLabel;
    lbTotalVirtual: TLabel;
    lbAvailVirtual: TLabel;
    ld1: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    GroupBox1: TGroupBox;
    lbProcessID: TLabel;
    lbProcessPID: TLabel;
    lbCountThreads: TLabel;
    lbSize: TLabel;
    lbUsage: TLabel;
    lbDefaultHeapId: TLabel;
    lbModuleId: TLabel;
    lbPrioritet: TLabel;
    lbFlag: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    miThreadTerminate: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    SmallIl: TImageList;
    ilThread: TImageList;
    procedure tbChange(Sender: TObject);
    procedure LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure BitBtn1Click(Sender: TObject);
    procedure btStopFillClick(Sender: TObject);
    procedure LVCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miThreadWindowsClick(Sender: TObject);
    procedure pmThreadsPopup(Sender: TObject);
    procedure pmModulesPopup(Sender: TObject);
    procedure miModuleUnloadClick(Sender: TObject);
    procedure miFileInfoClick(Sender: TObject);
    procedure btFileInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miThreadTerminateClick(Sender: TObject);
    procedure miThTimeCriticalClick(Sender: TObject);
  private
    glSortSubItem:integer;
    glSortForward:boolean;
    BreakFill: Boolean;
    procedure FillThreads98;
    procedure FillModules98;
    procedure FillModulesNT;
    procedure FillHeaps;
    procedure FillMemoryNT;
    procedure FillThreadNT;
    procedure ViewWindowsFromThread;
    procedure lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
     Data: Integer; var Compare: Integer);{compare by str}
    procedure lvCompareInt(Sender: TObject; Item1, Item2: TListItem;
     Data: Integer; var Compare: Integer);{compare by int}
  public
    ProcessEntry: PProcessEntry32;
    ProcID: DWord;
    FWinIcon: HICON;
    procedure ViewProcessInfo98;
    procedure ViewSystemInfo98;
    procedure FillInfoProcess;
    procedure ViewProcessInfoNT;
  end;

var
  fmPISI: TfmPISI;

implementation

uses UThreadWin, UMain, UFileInfo, RyMenus;

{$R *.DFM}

function MemoryTypeToString(Value: DWORD): string;
const
  TypeMask = DWORD($0000000F);
begin
  Result := '';
  case Value and TypeMask of
    1: Result := 'Read-only';
    2: Result := 'Executable';
    4: Result := 'Read/write';
    5: Result := 'Copy on write';
  else
    Result := 'Unknown';
  end;
  if Value and $100 <> 0 then
    Result := Result + ', Shareable';
end;


procedure TfmPISI.ViewProcessInfoNT;
var
  h: THandle;
//  ProcHand: THandle;
  ff: TNtQuerySystemInformation;
  pInfo: PProcessInfo;
  //ModHandles: array[0..$3FFF - 1] of DWORD;
 // ModInfo: TModuleInfo;
 // ModName: array[0..MAX_PATH] of char;
 // Count: DWord;

const
  MaxInfo=MaxBufferOfQSI;
var
  buf: Array[0..MaxInfo] Of Char;  
begin
  h := LoadLibrary('NTDLL.DLL');
  if h > 0 Then  Begin
   @ff := GetProcAddress(h, 'NtQuerySystemInformation');
   If @ff <> Nil Then Begin


     ff(5, @buf, sizeof(buf), 0);
     PInfo:=@buf;
     Repeat
        pInfo := Ptr(LongWord(pInfo) + pInfo.dwOffset);
{        Application.ProcessMessages;
        if BreakFill then break;}
        if PInfo.dwProcessID=ProcID then begin
{         ProcHand:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcId);
         try
         if GetModuleInformation(ProcHand,PInfo., @ModInfo, SizeOf(ModInfo) then begin}
           lbSize.Caption:=inttostr(0);
           lbUsage.Caption:=inttostr(0);
           lbProcessID.caption:=InttoHex(PInfo.dwProcessID,8);
           lbDefaultHeapId.Caption:='0';//InttoHex(ProcessEntry.th32DefaultHeapID,8);
           lbModuleId.Caption:='O';//InttoHex(ProcessEntry.th32ModuleID,8);
           lbCountThreads.Caption:=inttostr(PInfo.dwThreadCount);
           lbProcessPID.caption:=InttoHex(PInfo.dwParentProcessID,8);
           lbPrioritet.Caption:=inttostr(PInfo.dwBasePriority);
           lbFlag.Caption:='0';//inttostr(ProcessEntry.dwFlags);
           Break;
{          end;
          finally
           closeHandle(ProcHand);
          end;}
        end;
      Until pInfo.dwOffset = 0;

   end;
  end;
  if h>0 then FreeLibrary(h);
end;

procedure TfmPISI.ViewProcessInfo98;
{var
  PHE: PHeapEntry32;}
begin
  lbSize.Caption:=inttostr(ProcessEntry.dwSize);
  lbUsage.Caption:=inttostr(ProcessEntry.cntUsage);
  lbProcessID.caption:=InttoHex(ProcessEntry.th32ProcessID,8);
  lbDefaultHeapId.Caption:=InttoHex(ProcessEntry.th32DefaultHeapID,8);
  lbModuleId.Caption:=InttoHex(ProcessEntry.th32ModuleID,8);
  lbCountThreads.Caption:=inttostr(ProcessEntry.cntThreads);
  lbProcessPID.caption:=InttoHex(ProcessEntry.th32ParentProcessID,8);
  lbPrioritet.Caption:=inttostr(ProcessEntry.pcPriClassBase);
  lbFlag.Caption:=inttostr(ProcessEntry.dwFlags);
end;

procedure TfmPISI.ViewSystemInfo98;
var
   p: TSystemInfo;
   T: TmemoryStatus;
begin
 try
  //ZeroMemory(@P,sizeof(TSystemInfo));
  GetSystemInfo(p);
  GlobalMemoryStatus(T);
  lbPageSize.Caption:=inttostr(P.dwPageSize)+' byte';
  lbMemLoad.Caption:=inttostr(T.dwMemoryLoad)+' %';
  lbTotalPhys.Caption:=inttostr(round(T.dwTotalPhys/(1024*1024)))+' Mbyte';
  lbAvailPhys.Caption:=inttostr(T.dwAvailPhys)+' byte';
  lbTotalPageFile.Caption:=inttostr(round(T.dwTotalPageFile/(1024*1024)))+' Mbyte';
  lbAvailPageFile.Caption:=inttostr(round(T.dwAvailPageFile/(1024*1024)))+' Mbyte';
  lbTotalVirtual.Caption:=inttostr(round(T.dwTotalVirtual/(1024*1024)))+' Mbyte';
  lbAvailVirtual.Caption:=inttostr(round(T.dwAvailVirtual/(1024*1024)))+' Mbyte';
 except
 end; 
end;

  function getDeltaPri(DeltaPri: Integer): String;
  begin
    Result:=inttostr(DeltaPri)+' (NONE)';
    case DeltaPri of
      THREAD_PRIORITY_IDLE: result:=inttostr(DeltaPri)+' (IDLE)';
      THREAD_PRIORITY_LOWEST:  result:=inttostr(DeltaPri)+' (LOWEST)';
      THREAD_PRIORITY_BELOW_NORMAL: result:=inttostr(DeltaPri)+' (BELOW_NORMAL)';
      THREAD_PRIORITY_NORMAL: result:=inttostr(DeltaPri)+' (NORMAL)';
      THREAD_PRIORITY_ABOVE_NORMAL: result:=inttostr(DeltaPri)+' (ABOVE_NORMAL)';
      THREAD_PRIORITY_HIGHEST: result:=inttostr(DeltaPri)+' (HIGHEST)';
      THREAD_PRIORITY_TIME_CRITICAL: result:=inttostr(DeltaPri)+' (TIME_CRITICAL)';
    end;
  end;

  function getBasePri(BasePri: Integer): String;
  begin
   case BasePri of
     4:   Result := '%d (IDLE)';
     8:   Result := '%d (NORMAL)';
     13:  Result := '%d (HIGH)';
     24:  Result := '%d (REAL_TIME)';
   else
    Result := '%d (NONE)';
   end;
   Result := Format(Result, [BasePri]);
  end;

procedure TfmPISI.FillThreadNT;
var
  li: TListItem;
  lc: TListColumn;
  pInfo: PProcessInfo;
  h: THandle;
  ff: TNtQuerySystemInformation;
  i:Integer;
  ppp: TProcessInfo;
  Patinext: PThreadInfo;
  atinext: TThreadInfo;
const
  MaxInfo=MaxBufferOfQSI;
var
  buf: Array[0..MaxInfo] Of Char;
begin
  Screen.Cursor:=crHourGlass;
  try
  LV.Columns.Clear;
  LV.Items.Clear;
  lc:=LV.Columns.Add;
  lc.Caption:='ThreadID';
  lc.Alignment:=taRightJustify;
  lc:=LV.Columns.Add;
  lc.Caption:='BasePri';
  lc:=LV.Columns.Add;
  lc.Caption:='DeltaPri';
  lc:=LV.Columns.Add;
  lc.Caption:='Usage';
  lc.Alignment:=taCenter;
  lc:=LV.Columns.Add;
  lc.Caption:='OwnerProcessID';
  lc.Alignment:=taRightJustify;
  h := LoadLibrary('NTDLL.DLL');
  if h > 0 Then  Begin
   @ff := GetProcAddress(h, 'NtQuerySystemInformation');
   If @ff <> Nil Then Begin
    ff(5, @buf, sizeof(buf), 0);
    pInfo := @buf;
    Move(pInfo^,ppp,sizeof(ppp));
    Repeat
        pInfo := Ptr(LongWord(pInfo) + pInfo.dwOffset);
        Move(pInfo^,ppp,sizeof(ppp));
{        Application.ProcessMessages;
        if BreakFill then break;}
        if PInfo.dwProcessID=ProcID then begin
         Patinext:=@PInfo.ati[0];
         Move(Patinext^,atinext,sizeof(TThreadInfo));
         for i:=0 to PInfo.dwThreadCount-1 do begin
            Li:=LV.Items.Add;
            li.Data:=Pointer(atinext.dwThreadID);
            li.Caption:=inttohex(atinext.dwThreadID,8);
            with li.SubItems do begin
              Add(getBasePri(atinext.dwBasePriority));
              Add(getdeltaPri(atinext.dwCurrentPriority-atinext.dwBasePriority));
              Add(inttostr(0));
              Add(inttohex(ProcID,8));
            end;
            Patinext:=Pointer(Longword(Patinext)+sizeof(TThreadInfo));
            Move(Patinext^,atinext,sizeof(TThreadInfo));
            li.ImageIndex:=0;
{            LbCount.Caption:='Count Threads: '+inttostr(LV.Items.Count);
            LbCount.Update;}
         end;
        end;

    Until pInfo.dwOffset = 0;
    End;
   end;
  LbCount.Caption:='Count Threads: '+inttostr(LV.Items.Count);
  if h>0 then FreeLibrary(h);

  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;

procedure TfmPISI.FillThreads98;
var
  T: TThreadEntry32;
  FCurSnap: THandle;
  li: TListItem;
  lc: TListColumn;
  i: Integer;
begin
  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
  LV.Columns.Clear;
  LV.Items.Clear;
  FCurSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, ProcessEntry^.th32ProcessID);
  if FCurSnap = INVALID_HANDLE_VALUE then
    raise Exception.Create(SysErrorMessage(GetLastError));

  lc:=LV.Columns.Add;
  lc.Caption:='ThreadID';
  lc.Alignment:=taRightJustify;
  lc:=LV.Columns.Add;
  lc.Caption:='BasePri';
  lc:=LV.Columns.Add;
  lc.Caption:='DeltaPri';
  lc:=LV.Columns.Add;
  lc.Caption:='Usage';
  lc.Alignment:=taCenter;
  lc:=LV.Columns.Add;
  lc.Caption:='OwnerProcessID';
  lc.Alignment:=taRightJustify;

  T.dwSize := SizeOf(T);
  if Thread32First(FCurSnap, T) then
    repeat
{      Application.ProcessMessages;
      if BreakFill then break;}

      if T.th32OwnerProcessID= ProcessEntry.th32ProcessID then begin
       Li:=LV.Items.Add;
       li.data:=Pointer(T.th32ThreadID);
       li.Caption:=inttohex(T.th32ThreadID,8);
       with li.SubItems do begin
         Add(getBasePri(T.tpBasePri));
         Add(getdeltaPri(T.tpDeltaPri));
         Add(inttostr(T.cntUsage));
         Add(inttohex(T.th32OwnerProcessID,8));
       end;
       li.ImageIndex:=0;
{       LbCount.Caption:='Count Threads: '+inttostr(LV.Items.Count);
       LbCount.Update;}
      end;
    until not Thread32Next(FCurSnap, T);

  LbCount.Caption:='Count Threads: '+inttostr(LV.Items.Count);
  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
   LV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;


procedure TfmPISI.FillModules98;

  function GetProcessPointer(th32ModuleID: DWord): Pointer;
  var
    FSnap: THandle;
    PE: TProcessEntry32;
  begin
   Result:=nil;
   FSnap := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   PE.dwSize := SizeOf(PE);
   if Process32First(FSnap, PE) then               // get process
    repeat
 //   showmessage(PE.szExeFile);
     if th32ModuleID=PE.th32ModuleID then begin
       result:=Pointer(PE.th32ProcessID);
       exit;
     end;
    until not Process32Next(FSnap, PE);           // get next process
  end;

var
  M: TModuleEntry32;
  FCurSnap: THandle;
  li: TListItem;
  lc: TListColumn;
  i: Integer;
  HAppIcon: HICON;
begin
  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
  LV.Columns.Clear;
  LV.Items.Clear;
  ProcId:=ProcessEntry^.th32ProcessID;
  FCurSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessEntry^.th32ProcessID);
  if FCurSnap = INVALID_HANDLE_VALUE then
    raise Exception.Create(SysErrorMessage(GetLastError));

  lc:=LV.Columns.Add;
  lc.Caption:='Modules';
  lc:=LV.Columns.Add;
  lc.Caption:='BaseAddr';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='BaseSize in bytes';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='GlobalUsage';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='ProcUsage';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='ModuleID';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='ProcessID';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='hModule';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='ExePath';

  SmallIl.Clear;
  
  FWinIcon := LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
                        LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR
                        or LR_SHARED);

  M.dwSize := SizeOf(M);
  if Module32First(FCurSnap, M) then
    repeat
{       Application.ProcessMessages;
       if BreakFill then break;}
       Li:=LV.Items.Add;
       li.Data:=GetProcessPointer(M.th32ModuleID);
       li.Caption:=M.szModule;
       with li.SubItems do begin
         Add(Format('%p', [M.ModBaseAddr]));
         Add(Format('%d', [M.modBaseSize]));
         Add(inttostr(M.GlblcntUsage));
         Add(inttostr(M.ProccntUsage));
         Add(inttohex(M.th32ModuleID,8));
         Add(inttohex(M.th32ProcessID,8));
         Add(inttostr(M.hModule));
         Add(M.szExePath);
       end;
      HAppIcon := ExtractIcon(Hinstance, M.szExePath, 0);
      try
       if HAppIcon = 0 then HAppIcon := FWinIcon;
       li.ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);
       finally
        if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
      end;

{       LbCount.Caption:='Count Modules: '+inttostr(LV.Items.Count);
       LbCount.Update;}
    until not Module32Next(FCurSnap, M);

  LbCount.Caption:='Count Modules: '+inttostr(LV.Items.Count);
  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
    LV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;

procedure TfmPISI.FillHeaps;

  function GetHeapFlag(Flag: Integer): String;
  begin
    Result:='NONE';
    case Flag of
      LF32_FIXED:result:='FIXED';
      LF32_FREE: result:='FREE';
      LF32_MOVEABLE: result:='MOVEABLE';
    end;
  end;

var
  FCurSnap: THandle;
  li: TListItem;
  lc: TListColumn;
  i: Integer;
  HL: THeapList32;
  HE: THeapEntry32;
begin
  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
  LV.Columns.Clear;
  LV.Items.Clear;
  FCurSnap := CreateToolhelp32Snapshot(TH32CS_SNAPHEAPLIST, ProcessEntry^.th32ProcessID);
  if FCurSnap = INVALID_HANDLE_VALUE then
    raise Exception.Create(SysErrorMessage(GetLastError));


  lc:=LV.Columns.Add;
  lc.Caption:='HeapID';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='Address';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='BlockSize in bytes';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='Flags';

  lc:=LV.Columns.Add;
  lc.Caption:='LockCount';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='hHandle';
  lc.Alignment:=taRightJustify;

  HL.dwSize := SizeOf(HL);
  HE.dwSize := SizeOf(HE);
  if Heap32ListFirst(FCurSnap, HL) then
    repeat
      if Heap32First(HE, HL.th32ProcessID, HL.th32HeapID) then
        repeat
{         Application.ProcessMessages;
         if BreakFill then break;}
         Li:=LV.Items.Add;
         li.Caption:=inttohex(HL.th32HeapID,8);
         with li.SubItems do begin
          Add(inttohex(HE.dwAddress,8));
          Add(inttostr(HE.dwBlockSize));
          Add(GetHeapFlag(HE.dwFlags));
          Add(inttostr(HE.dwLockCount));
          Add(inttostr(HE.hHandle));
         end;
{         LbCount.Caption:='Count Heaps: '+inttostr(LV.Items.Count);
         LbCount.Update;}
        until not Heap32Next(HE);
    until not Heap32ListNext(FCurSnap, HL);

  LbCount.Caption:='Count Heaps: '+inttostr(LV.Items.Count);  
  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
   LV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;

procedure TfmPISI.FillInfoProcess;
begin
 pc.Enabled:=false;
 LV.SmallImages:=nil;
 if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
  ts4.TabVisible:=false;
  pc.Visible:=true;
  case pc.ActivePageIndex of
    0: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=pmModules;
     LV.SmallImages:=SmallIl;
     FillModules98;
    end;
    1: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=pmThreads;
     LV.SmallImages:=ilThread;
     FillThreads98;
    end;
    2: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=nil;
     FillHeaps;
    end;
  end;
 end else begin
//  ts2.TabVisible:=false;
  ts3.TabVisible:=false;
  pc.Visible:=true;
  case pc.ActivePageIndex of
    0: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=pmModules;
     LV.SmallImages:=SmallIl;
     FillModulesNT;
    end;
    1: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=pmThreads;
     LV.SmallImages:=ilThread;
     FillThreadNT;
    end;
    3: begin
     LV.parent:=pc.ActivePage;
     lv.PopupMenu:=nil;
     FillMemoryNT;
    end;
  end;
 end;
 pc.Enabled:=true;
end;


procedure TfmPISI.tbChange(Sender: TObject);
begin
  FillInfoProcess;
end;

procedure TfmPISI.LVColumnClick(Sender: TObject; Column: TListColumn);
var
 newSortItem:integer;
begin
 newSortItem:=Column.Index-1;
 if glSortSubItem=newSortItem then glSortForward:=not glSortForward
 else glSortForward:=true;
 glSortSubItem:=newSortItem;
 case pc.ActivePageIndex of
   0:begin
    case Column.Index of
      0,8: lv.OnCompare:=lvCompareStr;
      1,2,3,4,5,6,7:lv.OnCompare:=lvCompareInt;
    end;
   end;
   1:begin
    case Column.Index of
      0,3: lv.OnCompare:=lvCompareInt;
      1,2: lv.OnCompare:=lvCompareStr;
    end;
   end;
   2:begin
    case Column.Index of
      0,1,2,4,5:lv.OnCompare:=lvCompareInt;
      3:lv.OnCompare:=lvCompareStr;
    end;
   end;
   3:begin
    case Column.Index of
      0:lv.OnCompare:=lvCompareInt;
      1,2:lv.OnCompare:=lvCompareStr;
    end;
   end;

 end;
 lv.AlphaSort;
end;

procedure TfmPISI.lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
 if glSortSubItem>=0 then Compare:=CompareText(Item1.SubItems[glSortSubItem],Item2.SubItems[glSortSubItem])
 else Compare:=CompareText(Item1.Caption,Item2.Caption);
 if glSortForward=false then Compare:=-Compare;
end;

procedure TfmPISI.lvCompareInt(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
 i1,i2:Int64;
begin
 if glSortSubItem>=0 then begin
  i1:=strtoint64('$'+Item1.SubItems[glSortSubItem]);
  i2:=strtoint64('$'+Item2.SubItems[glSortSubItem]);
 end else begin
  i1:=strtoint64('$'+Item1.Caption);
  i2:=strtoint64('$'+Item2.Caption);
 end;
 if i2>i1 then Compare:=-1
 else if i2<i1 then Compare:=1
 else Compare:=1;
 if glSortForward=false then Compare:=-Compare;
end;

procedure TfmPISI.BitBtn1Click(Sender: TObject);
begin
  BreakFill:=true;
  Modalresult:=mrOk;
end;

procedure TfmPISI.btStopFillClick(Sender: TObject);
begin
  BreakFill:=true;
end;

procedure TfmPISI.LVCustomDrawItem(Sender: TCustomListView;
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
   end;      }
end;

procedure TfmPISI.FillModulesNT;
const
  AddrMask = DWORD($FFFFF000);
var
  I: Integer;
  li: TListItem;
  lc: TListColumn;
  ProcHand: THandle;
  ModHandles: array[0..$3FFF - 1] of DWORD;
  ModInfo: TModuleInfo;
  ModName: array[0..MAX_PATH] of char;
  Count: DWord;
  HAppIcon: HICON;
  varout: Word;
begin
  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
  LV.Columns.Clear;
  LV.Items.Clear;

  lc:=LV.Columns.Add;
  lc.Caption:='Modules';
  lc:=LV.Columns.Add;
  lc.Caption:='BaseAddr';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='BaseSize in bytes';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='EntryPoint';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='GlobalUsage';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='ProcUsage';
  lc.Alignment:=taCenter;

  lc:=LV.Columns.Add;
  lc.Caption:='ModuleID';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='ProcessID';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='hModule';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='ExePath';


  ProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False,ProcID);
  if ProcHand = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));

  SmallIl.Clear;
  FWinIcon := LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
                        LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR
                        or LR_SHARED);
  
    
  try
    EnumProcessModules(ProcHand, @ModHandles, SizeOf(ModHandles), Count);
    for I := 0 to (Count div SizeOf(DWORD)) - 1 do
      if (GetModuleFileNameEx(ProcHand, ModHandles[I], ModName,
        SizeOf(ModName)) > 0) and GetModuleInformation(ProcHand,
        ModHandles[I], @ModInfo, SizeOf(ModInfo)) then begin
{        Application.ProcessMessages;
        if BreakFill then break;}
         Li:=LV.Items.Add;
         li.Caption:=ExtractFileName(ModName);
         with li.SubItems do begin
           Add(format('%p',[ModInfo.lpBaseOfDll]));
           Add(format('%d',[ModInfo.SizeOfImage]));
           Add(format('%p',[ModInfo.EntryPoint]));
           Add('0');
           Add('0');
           Add('0');
           Add('0');
           Add(inttostr(ModHandles[I]));
           Add(ModName);
         end;
//         HAppIcon := ExtractIcon(HInstance, ModName, 0);
         HAppIcon := ExtractAssociatedIcon(HInstance, ModName, varout);
         try

          if HAppIcon = 0 then HAppIcon := FWinIcon;
          li.ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);

         finally
          if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
         end;

{         LbCount.Caption:='Count Modules: '+inttostr(LV.Items.Count);
         LbCount.Update;}
    end;
  finally
    CloseHandle(ProcHand);
  end;
  LbCount.Caption:='Count Modules: '+inttostr(LV.Items.Count);
  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
   LV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;

procedure TfmPISI.FillMemoryNT;
const
  AddrMask = DWORD($FFFFF000);
var
  I: Integer;
  Count: DWORD;
  ProcHand: THandle;
  WSPtr: Pointer;
  ModHandles: array[0..$3FFF - 1] of DWORD;
  WorkingSet: array[0..$3FFF - 1] of DWORD;
  ModInfo: TModuleInfo;
  ModName, MapFileName: array[0..MAX_PATH] of char;
  li: TListItem;
  lc: TListColumn;
begin

  Screen.Cursor:=crHourGlass;
  LV.Items.BeginUpdate;
  try
  LV.Columns.Clear;
  LV.Items.Clear;

  lc:=LV.Columns.Add;
  lc.Caption:='Page address';
  lc:=LV.Columns.Add;
  
  lc.Caption:='Type';
  lc.Alignment:=taRightJustify;

  lc:=LV.Columns.Add;
  lc.Caption:='Mem Map File';
  lc.Alignment:=taRightJustify;

  ProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False,ProcID);
  if ProcHand = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  try
    EnumProcessModules(ProcHand, @ModHandles, SizeOf(ModHandles), Count);
    for I := 0 to (Count div SizeOf(DWORD)) - 1 do
      if (GetModuleFileNameEx(ProcHand, ModHandles[I], ModName,
        SizeOf(ModName)) > 0) and GetModuleInformation(ProcHand,
        ModHandles[I], @ModInfo, SizeOf(ModInfo)) then begin
    end;
    if QueryWorkingSet(ProcHand, @WorkingSet, SizeOf(WorkingSet)) then begin
      for I := 1 to WorkingSet[0] do begin
{        Application.ProcessMessages;
        if BreakFill then break;}
        WSPtr := Pointer(WorkingSet[I] and AddrMask);
        MapFileName:='';
        GetMappedFileName(ProcHand, WSPtr, MapFileName, SizeOf(MapFileName));
         Li:=LV.Items.Add;
         li.Caption:=format('%p',[WSPtr]);
         with li.SubItems do begin
           Add(MemoryTypeToString(WorkingSet[I]));
           Add(format('%s',[MapFileName]));
         end;
{         LbCount.Caption:='Count Page Addr: '+inttostr(LV.Items.Count);
         LbCount.Update;}
      end;
     end;
  finally
    CloseHandle(ProcHand);
  end;
  LbCount.Caption:='Count Page Addr: '+inttostr(LV.Items.Count);
  for i:=0 to LV.Columns.Count-1 do begin
   ListView_SetColumnWidth(LV.Handle,i,LVSCW_AUTOSIZE_USEHEADER);
  end;
  finally
   LV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
   BreakFill:=false;
  end;
end;

procedure TfmPISI.LVMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  if (pc.ActivePageIndex=1){ or (pc.ActivePageIndex=0)} then begin
   if Shift=[ssRight] then begin
    if lv.Selected<>nil then begin
     pt:=Point(X,Y);
     pt:=lv.ClientToScreen(pt);
     lv.PopupMenu:=pmThreads;
   //  pmThreads.Popup(pt.X,pt.Y);
    end;
   end;
  end;
  if (pc.ActivePageIndex=0) then begin
   if Shift=[ssRight] then begin
    if lv.Selected<>nil then begin
     pt:=Point(X,Y);
     pt:=lv.ClientToScreen(pt);
     lv.PopupMenu:=pmModules;
  //   pmModules.Popup(pt.X,pt.Y);
    end;
   end;
  end;

end;

procedure TfmPISI.miThreadWindowsClick(Sender: TObject);
begin
  ViewWindowsFromThread;
end;

procedure TfmPISI.ViewWindowsFromThread;
var
  fm: TfmThWin;
  ThreadId: LongWord;
  li: TListItem;
begin
  li:=lv.Selected;
  if li=nil then exit;
  fm:=TfmThWin.Create(nil);
  try
   case pc.ActivePageIndex of
     1:begin
      ThreadId:=LongWord(li.data);
      fm.tv.Items.Clear;
      fm.FlagAllThread:=false;
      fm.FillWindowsFromThread(ThreadId);
     end;
   end;
   fm.ShowModal;
  finally
   fm.Free;
  end;
end;

procedure TfmPISI.pmThreadsPopup(Sender: TObject);
var
  li: TListItem;
  hThread: THandle;
  P: Integer;
  h: THandle;
  ff: TOpenThread;
  i: Integer;
begin
  li:=Lv.Selected;
  hThread:=0;
  if Li<>nil then begin
    miThreadWindows.Enabled:=true;
    miThreadTerminate.Enabled:=true;
    miThreadPri.Enabled:=true;
    if Win32Platform=VER_PLATFORM_WIN32_NT then begin
      h:=0;
      try
       h:=LoadLibrary(kernel32);
       if h=0 Then exit;
       @ff:=GetProcAddress(h,'OpenThread');
       If @ff=Nil Then exit;
       hThread:=ff(THREAD_ALL_ACCESS,false,Dword(li.Data));
       if hThread<>0 then begin
          P:=GetThreadPriority(hThread);
          case P of
           THREAD_PRIORITY_LOWEST:       miThLowest.Checked:=true;
           THREAD_PRIORITY_BELOW_NORMAL: miThBelowNormal.Checked:=true;
           THREAD_PRIORITY_NORMAL:       miThNormal.Checked:=true;
           THREAD_PRIORITY_HIGHEST:      miThHighest.Checked:=true;
           THREAD_PRIORITY_ABOVE_NORMAL: miThAboveNormal.Checked:=true;
           THREAD_PRIORITY_ERROR_RETURN: ;
           THREAD_PRIORITY_TIME_CRITICAL:miThTimeCritical.Checked:=true;
           THREAD_PRIORITY_IDLE:         miThIdle.Checked:=true;
          end;
          CloseHandle(hThread);
       end;
      finally
        if h>0 then FreeLibrary(h);
      end;  
    end else begin
       //ThHand:=Open
       P:=GetThreadPriority(hThread);
       case P of
        THREAD_PRIORITY_LOWEST:;
        THREAD_PRIORITY_BELOW_NORMAL:;
        THREAD_PRIORITY_NORMAL:;
        THREAD_PRIORITY_HIGHEST:;
        THREAD_PRIORITY_ABOVE_NORMAL:;
        THREAD_PRIORITY_ERROR_RETURN:;
        THREAD_PRIORITY_TIME_CRITICAL:;
        THREAD_PRIORITY_IDLE:;
       end;
    end;

    if LV.SelCount>1 then begin
     miThreadWindows.Enabled:=false;
    end;
    
  end else begin
    miThreadWindows.Enabled:=false;
    miThreadTerminate.Enabled:=false;
    miThreadPri.Enabled:=false;
  end;
end;

procedure TfmPISI.pmModulesPopup(Sender: TObject);
var
  li: TListItem;
begin
  li:=Lv.Selected;
  if Li<>nil then begin
//    miModuleUnload.Enabled:=true;
    miFileInfo.Enabled:=true;
    miModuleUnload.Enabled:=true;
  end else begin
  //  miModuleUnload.Enabled:=false;
    miFileInfo.Enabled:=false;
    miModuleUnload.Enabled:=false;
  end;
end;

procedure TfmPISI.miFileInfoClick(Sender: TObject);
begin
  btFileInfoClick(nil);
end;

procedure TfmPISI.btFileInfoClick(Sender: TObject);
var
  fm: TfmFileInfo;
  li: TListItem;
begin
  li:=lv.Selected;
  if li=nil then exit;
  fm:=TfmFileInfo.Create(nil);
  try
   fm.FillFileInfo(li.SubItems.Strings[li.SubItems.count-1]);
   fm.ShowModal;
  finally
   fm.Free;
  end;
end;

procedure TfmPISI.FormCreate(Sender: TObject);
begin
  RyMenu.Add(pmModules,nil);
  RyMenu.Add(pmThreads,nil);
end;

procedure TfmPISI.miThreadTerminateClick(Sender: TObject);
var
  hThread: Thandle;
  dwExitCode: DWORD;
  li: TListItem;
  i: Integer;
  h: THandle;
  ff: TOpenThread;
  tmps,MessInfo: string;
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
   h:=0;
   try
    h:=LoadLibrary(kernel32);
    if h>0 Then  Begin
     @ff:=GetProcAddress(h,'OpenThread');
      If @ff<>Nil Then Begin
       for i:=Lv.Items.Count-1 downto 0 do begin
        li:=Lv.Items[i];
        tmps:=li.caption;
        if li.Selected then begin
          hThread:=ff(THREAD_ALL_ACCESS,false,Dword(li.Data));
          try
           if hThread<>0 then begin
            if TerminateThread(hThread,dwExitCode) then begin
              li.Delete;
              MessInfo:=MessInfo+tmps+' - terminated'+#13;
            end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
           end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
          finally
           CloseHandle(hThread);
          end; 
        end;
       end;
      end;
     end;
    finally
      if h>0 then FreeLibrary(h);
    end;
    MessageBox(Application.Handle,Pchar(MessInfo),'Information',MB_ICONINFORMATION);
  end;
end;

{procedure TfmPISI.miThreadTerminateClick(Sender: TObject);
var
  hThread: Thandle;
  dwExitCode: DWORD;
  li: TListItem;
  i: Integer;
  h: THandle;
  ff: TNtOpenThread;
  oa: TOBJECT_ATTRIBUTES;
  ci: TCLIENT_ID;
  tmps,MessInfo: string;
const
  MAXIMUM_ALLOWED=$02000000;

begin
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
   try
    h:=LoadLibrary('NTDLL.DLL');
    if h>0 Then  Begin
     @ff:=GetProcAddress(h,'NtOpenThread');
      If @ff<>Nil Then Begin
       for i:=Lv.Items.Count-1 downto 0 do begin
        li:=Lv.Items[i];
        tmps:=li.caption;
        if li.Selected then begin
          FillChar(oa,sizeof(oa),0);
          oa.Length:=sizeof(oa);
          FillChar(ci,sizeof(ci),0);
          ci.pid:=ProcID;
          ci.tid:=strtoint(li.caption);
          ci.pid:=GetCurrentProcessId;
          ci.tid:=GetCurrentThreadId;

          hThread:=0;
          if ff(hThread,MAXIMUM_ALLOWED,@oa,@ci) then begin
           if hThread<>0 then begin
             if TerminateThread(hThread,dwExitCode) then begin
              li.Delete;
              MessInfo:=MessInfo+tmps+' - terminated'+#13;
             end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
           end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
          end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
        end;
       end;
      end;
     end;
    finally
      if h>0 then FreeLibrary(h);
    end;

    MessageBox(Application.Handle,Pchar(MessInfo),'Information',MB_ICONINFORMATION);
//   TerminateThread(hThread,dwExitCode);
  end;
end;
}

procedure TfmPISI.miThTimeCriticalClick(Sender: TObject);
var
  MI: TmenuItem;
  hThread: THandle;
  li: TListItem;
  i: Integer;
  h: THandle;
  ff: TOpenThread;
begin
  li:=lv.Selected;
  if li=nil then exit;
  Mi:=Sender as TMenuItem;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
   h:=0;
   try
    h:=LoadLibrary(kernel32);
    if h>0 Then  Begin
     @ff:=GetProcAddress(h,'OpenThread');
     If @ff<>Nil Then
       for i:=0 to LV.Items.Count-1 do begin
        li:=LV.Items[i];
        if li.Selected then begin
         hThread:=ff(THREAD_ALL_ACCESS,false,Dword(li.Data));
         try
          if mi=miThLowest then SetThreadPriority(hThread,THREAD_PRIORITY_LOWEST);
          if mi=miThBelowNormal then SetThreadPriority(hThread,THREAD_PRIORITY_BELOW_NORMAL);
          if mi=miThNormal then SetThreadPriority(hThread,THREAD_PRIORITY_NORMAL);
          if mi=miThHighest then SetThreadPriority(hThread,THREAD_PRIORITY_HIGHEST);
          if mi=miThAboveNormal then SetThreadPriority(hThread,THREAD_PRIORITY_ABOVE_NORMAL);
          if mi=miThTimeCritical then SetThreadPriority(hThread,THREAD_PRIORITY_TIME_CRITICAL);
          if mi=miThIdle then SetThreadPriority(hThread,THREAD_PRIORITY_IDLE);
        finally
         CloseHandle(hThread);
        end;
       end;
     end;
    end;
   finally
     if h>0 then FreeLibrary(h);
   end;
 end else begin

 end;
end;

procedure TfmPISI.miModuleUnloadClick(Sender: TObject);
var
  li: TListItem;
  hm: HMODULE;
  modname: string;
  hModule: Integer;
  dwExit: DWord;
begin
  li:=Lv.Selected;
  if Li<>nil then begin
    if Win32Platform=VER_PLATFORM_WIN32_NT then begin
      modname:=li.SubItems.Strings[li.SubItems.count-1];
      hModule:=StrToInt(li.SubItems.Strings[li.SubItems.count-2]);
    end else begin
      modname:=li.SubItems.Strings[li.SubItems.count-1];
      hModule:=StrToInt(li.SubItems.Strings[li.SubItems.count-2]);
    end;
    hm:=hModule;
    if hm<>0 then begin
     // DisableThreadLibraryCalls(hm);
     // dwExit:=0;
     // FreeLibraryAndExitThread(hm,dwExit);
{      if FreeLibrary(hm) then begin
        ShowMessage(SysErrorMessage(GetLastError));
        FillInfoProcess;
      end else
       MessageBox(Application.Handle,Pchar(SysErrorMessage(GetLastError)),nil,MB_iconERROR);}
    end;
  end;
end;


end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TlHelp32, shellApi, ExtCtrls, Unit2, ComCtrls, commctrl,
  ImgList, UPInfoSInfo, Menus,clipbrd, UAbout, psapi;

type
  TfmProcess = class(TForm)
    od: TOpenDialog;
    Panel1: TPanel;
    btKill: TBitBtn;
    sd: TSaveDialog;
    btDumpMem: TBitBtn;
    Panel2: TPanel;
    btClose: TBitBtn;
    btRefresh: TBitBtn;
    btExrract: TBitBtn;
    Panel3: TPanel;
    LV: TListView;
    Largeil: TImageList;
    btProcInfo: TBitBtn;
    pm: TPopupMenu;
    miCopyPath: TMenuItem;
    btAbout: TBitBtn;
    N1: TMenuItem;
    miWindows: TMenuItem;
    N2: TMenuItem;
    miPrioritet: TMenuItem;
    miIdle: TMenuItem;
    miNormal: TMenuItem;
    miHigh: TMenuItem;
    miRealTime: TMenuItem;
    miKill: TMenuItem;
    miExtractIcon: TMenuItem;
    miDump: TMenuItem;
    miInfo: TMenuItem;
    N3: TMenuItem;
    miRefresh: TMenuItem;
    btWindows: TBitBtn;
    btFileInfo: TBitBtn;
    miView: TMenuItem;
    N4: TMenuItem;
    miViewIcon: TMenuItem;
    miViewSmallIcon: TMenuItem;
    miViewList: TMenuItem;
    miViewReport: TMenuItem;
    SmallIl: TImageList;
    miPEInfo: TMenuItem;
    MainIl: TImageList;
    bibNew: TBitBtn;
    miNew: TMenuItem;
    tm: TTimer;
    miAutoRefresh: TMenuItem;
    procedure btKillClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btDumpMemClick(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure btExrractClick(Sender: TObject);
    procedure LVCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btProcInfoClick(Sender: TObject);
    procedure pmPopup(Sender: TObject);
    procedure miCopyPathClick(Sender: TObject);
    procedure btAboutClick(Sender: TObject);
    procedure miRealTimeClick(Sender: TObject);
    procedure miWindowsClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miKillClick(Sender: TObject);
    procedure miExtractIconClick(Sender: TObject);
    procedure miDumpClick(Sender: TObject);
    procedure miInfoClick(Sender: TObject);
    procedure btWindowsClick(Sender: TObject);
    procedure miViewReportClick(Sender: TObject);
    procedure btFileInfoClick(Sender: TObject);
    procedure miPEInfoClick(Sender: TObject);
    procedure bibNewClick(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure tmTimer(Sender: TObject);
    procedure miAutoRefreshClick(Sender: TObject);
  private
    NewFile: string;
    procedure AppOnRestore(Sender: TObject);
//    function getBaseAddr(PENew: PProcessEntry32): string;
  public
    FProcList: array of DWORD;
    FDrvlist: array of Pointer;
    FWinIcon: HICON;
    
    procedure ClearPointers;
    { Public declarations }
  end;

var
  fmProcess: TfmProcess;

const
  SFailMessage = 'Failed to enumerate processes or drivers.  Make sure ' +
    'PSAPI.DLL is installed on your system.';
  SDrvName = 'driver';
  SProcname = 'process';
  ProcessInfoCaptions: array[0..4] of string = (
    'Name', 'Type', 'ID', 'Handle', 'Priority');
  
implementation

uses UProgress, USearch, UThreadWin, UFileInfo;

{$R *.DFM}

function GetPriorityClassString(PriorityClass: Integer): string;
begin
  case PriorityClass of
    HIGH_PRIORITY_CLASS: Result := 'High';
    IDLE_PRIORITY_CLASS: Result := 'Idle';
    NORMAL_PRIORITY_CLASS: Result := 'Normal';
    REALTIME_PRIORITY_CLASS: Result := 'Realtime';
  else
    Result := Format('Unknown ($%x)', [PriorityClass]);
  end;
end;

function isStellsLoaded(StellsPath: string): LongInt;
var
  PE: TProcessEntry32;
  FSnap: THandle;
  ProcessId: LongInt;
  tmps: string;
begin
  ProcessID:=0;
  FSnap := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  PE.dwSize := SizeOf(PE);
  if Process32First(FSnap, PE) then               // get process
    repeat
     tmps:=PE.szExeFile;
     if LowerCase(tmps)=LowerCase(StellsPath) then begin
      ProcessID:=PE.th32ProcessID;
      Break;
     end;
    until not Process32Next(FSnap, PE);           // get next process
  Result:=ProcessID;
end;

procedure TfmProcess.btKillClick(Sender: TObject);
var
  ProcId: LongInt;
  ProcessHandle: LongInt;
  PENew: PProcessEntry32;
  tmps: string;
  Li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   PENew:=PProcessEntry32(Li.data);

   tmps:=PENew^.szExeFile;
   ProcId:=PENew^.th32ProcessID;
   if ProcId<>0 then begin
     ProcessHandle:=OpenProcess(PROCESS_TERMINATE,false,ProcId);
     if ProcessHandle<>0 then begin
      if TerminateProcess(ProcessHandle,0) then begin
        Dispose(PENew);
        Li.Delete;
        MessageBox(Self.Handle,Pchar('KILLED - '+tmps),'Information',MB_ICONINFORMATION);
      end else begin
        MessageBox(Self.Handle,Pchar(SysErrorMessage(GetLastError)),'Error',MB_iconERROR);
      end;
     end;
   end;
  end else begin
   ProcId:=Integer(Li.Data);
   tmps:=Li.Caption;
   if ProcId<>0 then begin
     ProcessHandle:=OpenProcess(PROCESS_TERMINATE,false,ProcId);
     if ProcessHandle<>0 then begin
      if TerminateProcess(ProcessHandle,0) then begin
        Li.Delete;
        MessageBox(Self.Handle,Pchar('KILLED - '+tmps),'Information',MB_ICONINFORMATION);
      end else begin
        MessageBox(Self.Handle,Pchar(SysErrorMessage(GetLastError)),'Error',MB_iconERROR);
      end;
     end;
   end;
  end;

{  if not od.Execute then exit;
  ProcId:=isStellsLoaded(od.FileName);
  if ProcId<>0 then begin
    ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcId);
    if ProcessHandle<>0 then
     if TerminateProcess(ProcessHandle,0) then begin
       showmessage('Stells killed');
     end;
  end;   }

end;

procedure TfmProcess.ClearPointers;
var
  i: Integer;
  PENew: PProcessEntry32;
  li: TlistItem;
begin
 if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   for i:=LV.Items.Count-1 downto 0 do begin
    li:=Lv.Items[i];
    PENew:=PProcessEntry32(Li.data);
    Dispose(PENew);
   end;
  end;
  LV.Items.Clear;
end;

procedure TfmProcess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearPointers;
end;

procedure Delay(ms : longint);
             {$IFNDEF WIN32}
             var
               TheTime : LongInt;
             {$ENDIF} 
             begin
             {$IFDEF WIN32}
               Sleep(ms);
             {$ELSE} 
               TheTime := GetTickCount + ms;
               while GetTickCount < TheTime do 
                 Application.ProcessMessages; 
             {$ENDIF} 
             end; 
 


procedure TfmProcess.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmProcess.FormCreate(Sender: TObject);
begin
  Application.OnRestore:=AppOnRestore;
// Application.OnMessage:=AppOnMess;
 btRefreshClick(nil);
end;

procedure TfmProcess.btDumpMemClick(Sender: TObject);
var
  PENew: PProcessEntry32;
  fm: TfmDumpMem;
  li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  fm:=TfmDumpMem.Create(nil);
  fm.Caption:=fm.Caption+' - '+li.Caption;

  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   PENew:=PProcessEntry32(Li.Data);
   fm.ProcessEntry:=PENew;
   fm.FillComboBox98(PENew);
  end else begin
   fm.Proc_ID:=Integer(li.data);
   fm.FillComboBoxNT;
  end;
  fm.cbStart.ItemIndex:=0;
  fmSearch.edStartAddr.Text:=fm.cbStart.text;
  fm.FirstMemAddr:=strtoint('$'+fm.cbStart.text);
  fm.ViewSystemInfo;
  fm.ViewMemBasic(fm.FirstMemAddr);
  fm.ShowModal;
  fmProgress.Close;
  fm.Free;
end;

{function TfmProcess.getBaseAddr(PENew: PProcessEntry32): string;
var
  M: TModuleEntry32;
  FSnap: Thandle;
begin
  FSnap := CreateToolHelp32Snapshot(TH32CS_SNAPMODULE, PENew^.th32ProcessID);
  M.dwSize := SizeOf(M);
  if Module32First(FSnap, M) then
    repeat
     if PENew.szExeFile=M.szExePath then begin
       result:=Format('%p', [M.ModBaseAddr]);
       exit;
     end;
    until not Module32Next(FSnap, M);
  result:='0';
end;
 }

procedure TfmProcess.btRefreshClick(Sender: TObject);
var
  PE: TProcessEntry32;
  PENew: pProcessEntry32;
  FSnap: THandle;
  tmps: string;
  li: TListItem;
  HIc: THandle;
  varOut: Word;
  ic: Ticon;
  I: Integer;
  Count: DWORD;
  BigArray: array[0..$3FFF - 1] of DWORD;
  ProcHand: THandle;
  HAppIcon: HICON;
  ModHand: HMODULE;
  ModName: array[0..MAX_PATH] of char;

begin
 ClearPointers;
 Smallil.Clear;
 Largeil.Clear;
 if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
  FSnap := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  PE.dwSize := SizeOf(PE);
  if Process32First(FSnap, PE) then               // get process
    repeat
     new(PENew);
     tmps:=PE.szExeFile;
     PENew^.dwSize:=PE.dwSize;
     PENew^.cntUsage:=PE.cntUsage;
     PENew^.th32ProcessID:=PE.th32ProcessID;
     PENew^.th32DefaultHeapID:=PE.th32DefaultHeapID;
     PENew^.th32ModuleID:=PE.th32ModuleID;
     PENew^.cntThreads:=PE.cntThreads;
     PENew^.th32ParentProcessID:=PE.th32ParentProcessID;
     PENew^.pcPriClassBase:=PE.pcPriClassBase;
     PENew^.dwFlags:=PE.dwFlags;
     PENew^.szExeFile:=PE.szExeFile;

     li:=LV.Items.Add;
     li.Caption:=tmps;
     li.data:=PENew;
     ic:=TIcon.Create;
     varOut:=0;
     HIc:= ExtractAssociatedIcon(
      PEnew.th32ProcessID,	// application instance handle
      PChar(tmps),	// path and filename of file for which icon is wanted
      varOut 	// pointer to icon index
     );
     ic.Handle:=Hic;
     li.ImageIndex:=Smallil.AddIcon(ic);
     Largeil.AddIcon(ic);
     ic.free;
    until not Process32Next(FSnap, PE);           // get next process
  end else begin
    if not EnumProcesses(@BigArray, SizeOf(BigArray), Count) then
    raise Exception.Create(SFailMessage);

    SetLength(FProcList, Count div SizeOf(DWORD));
    Move(BigArray, FProcList[0], Count);
    // Get array of Driver addresses
    if not EnumDeviceDrivers(@BigArray, SizeOf(BigArray), Count) then
      raise Exception.Create(SFailMessage);

    SetLength(FDrvList, Count div SizeOf(DWORD));
    Move(BigArray, FDrvList[0], Count);

    FWinIcon := LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
                          LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR
                          or LR_SHARED);

    for I := Low(FProcList) to High(FProcList) do begin
     ProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, FProcList[I]);
     if ProcHand > 0 then
      try
        EnumProcessModules(Prochand, @ModHand, sizeof(ModHand), Count);
        if GetModuleFileNameEx(Prochand, ModHand, ModName, SizeOf(ModName)) > 0 then begin
      //   if GetModuleBaseName (Prochand, ModHand, ModName, SizeOf(ModName)) > 0 then begin
          HAppIcon := ExtractIcon(HInstance, ModName, 0);
          try
            if HAppIcon = 0 then HAppIcon := FWinIcon;
            with LV.Items.Add, SubItems do begin
              Caption := ModName;                    // file name
              Data := Pointer(FProcList[I]);         // save ID
{              Add(SProcName);                        // "process"
              Add(IntToStr(FProcList[I]));           // process ID
              Add('$' + IntToHex(ProcHand, 8));      // process handle
              // priority class
              Add(GetPriorityClassString(GetPriorityClass(ProcHand)));}
              // icon
              if Smallil <> nil then
                ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);
              if Largeil<>nil then
                ImageIndex := ImageList_AddIcon(Largeil.Handle, HAppIcon);
            end;
          finally
            if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
          end;
        end;
       finally
         CloseHandle(ProcHand);
       end;
    end;
  end;
  ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE);
end;

procedure TfmProcess.btExrractClick(Sender: TObject);
var
  ic: TIcon;
  li: TlistItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  ic:=TIcon.Create;
  Smallil.GetIcon(li.ImageIndex,ic);
  if sd.Execute then begin
   ic.SaveToFile(sd.FileName);
  end;
  ic.Free;
{ Application.Icon.Handle:=windows.LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
    LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR or windows.LR_SHARED);}
end;

procedure TfmProcess.LVCustomDrawItem(Sender: TCustomListView;
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
   If Item=sender.Selected then begin
     if not(cdsSelected in State)then
      DrawItem;
   end;
end;

procedure TfmProcess.btProcInfoClick(Sender: TObject);
var
  fm: TfmPISI;
  li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  fm:=TfmPISI.Create(nil);
  try
   if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
    fm.ProcessEntry:=PProcessEntry32(Li.Data);
    fm.ViewProcessInfo98;
   end else begin
    fm.ProcID:=Integer(li.data);
    fm.ViewProcessInfoNT;
   end;
  fm.ViewSystemInfo98;
  fm.FillInfoProcess;

  fm.ShowModal;
  finally
   fm.Free;
  end; 
end;

procedure TfmProcess.AppOnRestore(Sender: TObject);
begin
  ShowWindow(Application.Handle,SW_RESTORE);
  if fmProgress.Visible then
  ShowWindow(fmProgress.Handle,SW_RESTORE);
end;


procedure TfmProcess.pmPopup(Sender: TObject);
var
  li: TListItem;
  P: DWord;
  PENew: pProcessEntry32;
  ProcHand: THandle;
begin
  li:=Lv.Selected;
  if Li<>nil then begin
    miKill.Enabled:=true;
    miNew.Enabled:=true;
    miExtractIcon.Enabled:=true;
    miDump.Enabled:=true;
    miInfo.Enabled:=true;


    miCopyPath.Enabled:=true;
    miWindows.Enabled:=true;
    miPEInfo.Enabled:=true;
    miPrioritet.Enabled:=true;
    if Win32Platform=VER_PLATFORM_WIN32_NT then begin
     ProcHand:=OpenProcess(PROCESS_QUERY_INFORMATION,false,LongWord(li.Data));
     if ProcHand=0 then miPrioritet.Enabled:=false;
     try
       P:=GetPriorityClass(ProcHand);
       if p=0 then miPrioritet.Enabled:=false;
       case P of
           NORMAL_PRIORITY_CLASS: begin
            miNormal.Checked:=true;
           end;
           IDLE_PRIORITY_CLASS: begin
            miIdle.Checked:=true;
           end;
           HIGH_PRIORITY_CLASS: begin
            miHigh.Checked:=true;
           end;
           REALTIME_PRIORITY_CLASS: begin
            miRealTime.Checked:=true;
           end;
       end;
     finally
      closehandle(ProcHand);
     end;
    end else begin
     PENew:=li.Data;
     ProcHand:=OpenProcess(PROCESS_QUERY_INFORMATION,false,PENew.th32ProcessID);
     if ProcHand=0 then miPrioritet.Enabled:=false;
     try
       P:=GetPriorityClass(ProcHand);
       if p=0 then miPrioritet.Enabled:=false;
       case P of
           NORMAL_PRIORITY_CLASS: begin
            miNormal.Checked:=true;
           end;
           IDLE_PRIORITY_CLASS: begin
            miIdle.Checked:=true;
           end;
           HIGH_PRIORITY_CLASS: begin
            miHigh.Checked:=true;
           end;
           REALTIME_PRIORITY_CLASS: begin
            miRealTime.Checked:=true;
           end;
       end;
     finally
      closehandle(ProcHand);
     end;
    end;
  end else begin
    miKill.Enabled:=false;
    miNew.Enabled:=true;
    miExtractIcon.Enabled:=false;
    miDump.Enabled:=false;
    miInfo.Enabled:=false;
    miCopyPath.Enabled:=false;
    miWindows.Enabled:=false;
    miPeInfo.Enabled:=true;
    miPrioritet.Enabled:=false;
  end;
end;

procedure TfmProcess.miCopyPathClick(Sender: TObject);
var
  li: TListItem;
begin
  li:=Lv.Selected;
  if li<>nil then begin
   clipboard.Clear;
   clipboard.AsText:=Li.Caption;
  end;
end;

procedure TfmProcess.btAboutClick(Sender: TObject);
var
 fm: TfmAbout;
begin
 fm:=TfmAbout.Create(nil);
 fm.showmodal;
 fm.Free;
end;

procedure TfmProcess.miRealTimeClick(Sender: TObject);
var
  MI: TmenuItem;
  ProcHand: THandle;
  li: TListItem;
begin
  li:=lv.Selected;
  if li=nil then exit;
  Mi:=Sender as TMenuItem;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
     ProcHand:=OpenProcess(PROCESS_SET_INFORMATION,false,LongWord(li.Data));
     try
      if mi=miNormal then SetPriorityClass(ProcHand,NORMAL_PRIORITY_CLASS);
      if mi=miHigh then SetPriorityClass(ProcHand,HIGH_PRIORITY_CLASS);
      if mi=miRealTime then SetPriorityClass(ProcHand,REALTIME_PRIORITY_CLASS);
      if mi=miIdle then SetPriorityClass(ProcHand,IDLE_PRIORITY_CLASS);
     finally
      CloseHandle(ProcHand);
     end;
  end else begin
     ProcHand:=OpenProcess(PROCESS_SET_INFORMATION,false,pProcessEntry32(li.Data).th32ProcessID);
     try
      if mi=miNormal then SetPriorityClass(ProcHand,NORMAL_PRIORITY_CLASS);
      if mi=miHigh then SetPriorityClass(ProcHand,HIGH_PRIORITY_CLASS);
      if mi=miRealTime then SetPriorityClass(ProcHand,REALTIME_PRIORITY_CLASS);
      if mi=miIdle then SetPriorityClass(ProcHand,IDLE_PRIORITY_CLASS);
     finally
      CloseHandle(ProcHand);
     end;
  end;
end;

procedure TfmProcess.miWindowsClick(Sender: TObject);
var
  li: TListItem;
  fm: TfmThWin;
  ProcessId: LongWord;
begin
  li:=lv.Selected;
  if li=nil then exit;
  fm:=TfmThWin.Create(nil);
  try
   if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    ProcessId:=LongWord(li.data);
   end else begin
    ProcessId:=pProcessEntry32(li.Data).th32ProcessID;
   end;
   fm.FlagAllThread:=true;
   fm.FillWindowsFromProcess(ProcessId);
   fm.ShowModal;
  finally
   fm.Free;
  end;
end;

procedure TfmProcess.miRefreshClick(Sender: TObject);
begin
  btRefreshClick(nil);
end;

procedure TfmProcess.miKillClick(Sender: TObject);
begin
  btKillClick(nil);
end;

procedure TfmProcess.miExtractIconClick(Sender: TObject);
begin
  btExrractClick(nil);
end;

procedure TfmProcess.miDumpClick(Sender: TObject);
begin
  btDumpMemClick(nil);
end;

procedure TfmProcess.miInfoClick(Sender: TObject);
begin
  btProcInfoClick(nil);
end;

procedure TfmProcess.btWindowsClick(Sender: TObject);
begin
  miWindowsClick(nil);
end;

procedure TfmProcess.miViewReportClick(Sender: TObject);
var
  MI: TMenuItem;
begin
  MI:=TMenuItem(Sender);
  MI.Checked:=true;
  if Mi=miViewIcon then LV.ViewStyle:=vsIcon;
  if Mi=miViewSmallIcon then LV.ViewStyle:=vsSmallIcon;
  if Mi=miViewList then begin
   LV.ViewStyle:=vsList;
   ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE);
  end;
  if Mi=miViewReport then begin
   LV.ViewStyle:=vsReport;
   ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE);
  end;
end;

procedure TfmProcess.miPEInfoClick(Sender: TObject);
begin
  btFileInfoClick(nil);
end;

procedure TfmProcess.btFileInfoClick(Sender: TObject);
var
  fm: TfmFileInfo;
  li: TListItem;
begin
  li:=lv.Selected;
  fm:=TfmFileInfo.Create(nil);
  try
   if li<>nil then
    fm.FillFileInfo(li.Caption);
   fm.ShowModal;
  finally
   fm.Free;
  end;
end;

procedure TfmProcess.bibNewClick(Sender: TObject);
begin
  od.FileName:=NewFile;
  if od.Execute then begin
    if ShellExecute(Handle,'Open',Pchar(od.FileName),nil,nil,SW_SHOW)>32 then begin
      miRefreshClick(nil);
      NewFile:=od.FileName;
    end;
  end;
end;

procedure TfmProcess.miNewClick(Sender: TObject);
begin
  bibNewClick(nil);
end;

procedure TfmProcess.tmTimer(Sender: TObject);
begin
  btRefreshClick(nil);
end;

procedure TfmProcess.miAutoRefreshClick(Sender: TObject);
begin
  if not miAutoRefresh.Checked then
   miAutoRefresh.Checked:=true
  else miAutoRefresh.Checked:=false;
  tm.Enabled:=miAutoRefresh.Checked;
end;

end.

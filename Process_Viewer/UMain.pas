unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TlHelp32, shellApi, ExtCtrls, UDump, ComCtrls, commctrl,
  ImgList, UPInfoSInfo, Menus,clipbrd, UAbout, psapi, XPMan;

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
    miObjectTree: TMenuItem;
    miMapFile: TMenuItem;
    N5: TMenuItem;
    miUnmapfile: TMenuItem;
    pnOnlyDriver: TPanel;
    rbProc: TRadioButton;
    rbDriv: TRadioButton;
    lbCount: TLabel;
    chbStayOnTop: TCheckBox;
    XPManifest1: TXPManifest;
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
    procedure miObjectTreeClick(Sender: TObject);
    procedure miMapFileClick(Sender: TObject);
    procedure miUnmapfileClick(Sender: TObject);
    procedure LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure rbProcClick(Sender: TObject);
    procedure chbStayOnTopClick(Sender: TObject);
  private
    NewFile: string;
    LastMapFile: string;
    glSortSubItem:integer;
    glSortForward:boolean;

    procedure AppOnRestore(Sender: TObject);

    function CreateFileMap(Value: String): Boolean;
    function GetSelfListItem: TListItem;
    procedure DumpFromAddress(Address: Longword; UseStart: Boolean);
    procedure FreeFileMap;
    procedure lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
     Data: Integer; var Compare: Integer);{compare by str}
    procedure ViewCount;
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
  FilterExe='Exe files (*.exe)|*.exe|All files (*.*)|*.*';
  FilterAll='All files (*.*)|*.*';

  
implementation

uses UProgress, USearch, UThreadWin, UFileInfo, UObjectTree, RyMenus,
     aclapi, Accctrl;

var
  HFile: THandle;
  hFileMap: Thandle;
  FileMapView: Pointer;
  
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

procedure SetDebugPrivilege;
var
  hToken:THandle;
  sedebugnameValue:Int64;
  tkp:TOKEN_PRIVILEGES;
  ReturnLength:Cardinal;
//  hProcess:THandle;
begin
  if not OpenProcessToken(GetCurrentProcess,
                          TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken) then exit;
  if not LookupPrivilegeValue(nil,'SeDebugPrivilege',sedebugnameValue)then begin
    CloseHandle(hToken);
    exit;
  end;

  tkp.PrivilegeCount:=1;
  tkp.Privileges[0].Luid:=sedebugnameValue;
  tkp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;

  if not AdjustTokenPrivileges(hToken,false,tkp,SizeOf(tkp),tkp,ReturnLength)then
   MessageBox(Application.Handle,Pchar(SysErrorMessage(GetLastError)),nil,MB_iconERROR);

  CloseHandle(hToken);
end;

procedure TfmProcess.btKillClick(Sender: TObject);
var
  ProcId: LongInt;
  ProcessHandle: LongInt;
  PENew: PProcessEntry32;
  tmps: string;
  Li: TListItem;
  i: Integer;
  MessInfo: string;
//  s: string;
begin
 try
  li:=Lv.Selected;
  if li=nil then exit;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   for i:=LV.Items.Count-1 downto 0  do begin
    li:=LV.Items[i];
    if li.Selected then begin
     PENew:=PProcessEntry32(Li.data);
     tmps:=PENew^.szExeFile;
     ProcId:=PENew^.th32ProcessID;
     if ProcId<>0 then begin
      ProcessHandle:=OpenProcess(PROCESS_TERMINATE,false,ProcId);
      if ProcessHandle<>0 then begin
       if TerminateProcess(ProcessHandle,0) then begin
         Dispose(PENew);
         Li.Delete;
         MessInfo:=MessInfo+tmps+' - killed'+#13;
       end else begin
         MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
       end;
      end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
     end;
    end;
   end;
    MessageBox(Application.Handle,Pchar(MessInfo),'Information',MB_ICONINFORMATION);

  end else begin
   for i:=LV.Items.Count-1 downto 0  do begin
    li:=LV.Items[i];
    if li.Selected then begin
     ProcId:=Integer(Li.Data);
     tmps:=Li.Caption;
     if ProcId<>0 then begin
      ProcessHandle:=OpenProcess(PROCESS_TERMINATE,false,ProcId);
      if ProcessHandle<>0 then begin
       if TerminateProcess(ProcessHandle,0) then begin
         Li.Delete;
         MessInfo:=MessInfo+tmps+' - killed'+#13;
       end else begin
         MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
       end;
      end else MessInfo:=MessInfo+tmps+' - '+SysErrorMessage(GetLastError)+#13;
     end;
    end;
   end;
   MessageBox(Application.Handle,Pchar(MessInfo),'Information',MB_ICONINFORMATION);
 end;

 finally
  ViewCount;
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
  if Win32Platform=VER_PLATFORM_WIN32_NT then
   SetDebugPrivilege;  
  RyMenu.Add(pm,nil);
  RyMenu.Visible:=true;
  Application.OnRestore:=AppOnRestore;
// Application.OnMessage:=AppOnMess;
  btRefreshClick(nil);
//  Application.AllowTesting:=true;
end;

procedure TfmProcess.btDumpMemClick(Sender: TObject);
begin
  DumpFromAddress(0,true);
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

function GetWinSysDir: string;
var
  wsd: PChar;
  WinSysDir:String;
begin
  Result:='';
  GetMem(wsd,256);
  GetSystemDirectory(wsd,256);
  WinSysDir:=StrPas(wsd);
  FreeMem(wsd,256);
  result:=WinSysDir;
end;

type
 PTOKEN_USER = ^TOKEN_USER;
 _TOKEN_USER = record
   User : TSidAndAttributes;
 end;
 TOKEN_USER = _TOKEN_USER;

function GetUserNameFromHandle(h: THandle): string;
var
 AcctName: array[0..255] of char;
 DomainName: array[0..255] of char;
 szAcctName: DWord;
 szDomainName: DWord;
 eUse: SID_NAME_USE;
 hToken: Thandle;
 ptu: PTOKEN_USER;
 dwReturnLength: DWord;
begin
 Result:='';
 eUse := SidTypeUnknown;
 dwReturnLength:=0;
 try
  if not OpenProcessToken(h,TOKEN_QUERY, hToken) then exit;
  GetTokenInformation(hToken,TokenUser,nil,0,dwReturnLength);
  if dwReturnLength=0 then exit;
  GetMem(ptu,dwReturnLength);
  try
    GetTokenInformation(hToken,TokenUser,ptu,dwReturnLength,dwReturnLength);
    if GetLastError<>ERROR_INSUFFICIENT_BUFFER then exit;
    FillChar(AcctName,Sizeof(AcctName),0);
    FillChar(DomainName,Sizeof(DomainName),0);
    szAcctName:=1;
    szDomainName:=1;
    LookupAccountSid(nil,ptu.User.Sid,@AcctName,szAcctName,@DomainName,szDomainName,eUse);
    if not LookupAccountSid(nil,ptu.User.Sid,@AcctName,szAcctName,@DomainName,szDomainName,eUse) then exit;

    Result:=DomainName;
    Result:=Result+'\';
    Result:=Result+AcctName;
  finally
    FreeMem(ptu,dwReturnLength);
  end;
 finally
   CloseHandle(hToken);
 end;
end;

procedure TfmProcess.btRefreshClick(Sender: TObject);
var
  PE: TProcessEntry32;
  PENew: pProcessEntry32;
  FSnap: THandle;
  tmps: string;
  li: TListItem;
  I: Integer;
  Count: DWORD;
  BigArray: array[0..$3FFF - 1] of DWORD;
  ProcHand: THandle;
  HAppIcon: HICON;
  ModHand: HMODULE;
  ModName: array[0..MAX_PATH] of char;
  DrvName: array[0..MAX_PATH] of char;
  cl: TListColumn;
  varout: word;
begin
 Screen.Cursor:=crHourGlass;
 Lv.Items.BeginUpdate;
 try
  Lv.Columns.Clear;
  cl:=Lv.Columns.Add;
  cl.AutoSize:=true;
  if rbProc.Checked then
   cl.Caption:='Process name';
  if rbDriv.Checked then
   cl.Caption:='Driver name';

  cl:=Lv.Columns.Add;
  cl.Caption:='Path';
  if rbDriv.Checked then begin
   cl:=Lv.Columns.Add;
   cl.Caption:='Base address';
  end;

  if rbProc.Checked then begin
   cl:=Lv.Columns.Add;
   cl.AutoSize:=true;
   cl.Caption:='User';
  end;

  FWinIcon := LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
                        LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR
                        or LR_SHARED);

  ClearPointers;
  Smallil.Clear;
  Largeil.Clear;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   if rbProc.Checked then begin
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
      li.Caption:=ExtractFileName(tmps);
      li.data:=PENew;
      li.SubItems.Add(tmps);

      if FileExists(tmps) then
       HAppIcon := ExtractAssociatedIcon(HInstance, PE.szExeFile, varout)
      else
       HAppIcon := ExtractIcon(HInstance, PE.szExeFile, 0);
      try

       if HAppIcon = 0 then HAppIcon := FWinIcon;
       if Smallil <> nil then
        li.ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);
       if Largeil<>nil then
        li.ImageIndex := ImageList_AddIcon(Largeil.Handle, HAppIcon);

      finally
        if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
      end;
     until not Process32Next(FSnap, PE);           // get next process
    end;
    if rbDriv.Checked then begin
      //
    end;

   end else begin
     if rbProc.Checked then begin

      if not EnumProcesses(@BigArray, SizeOf(BigArray), Count) then
       raise Exception.Create(SFailMessage);

      SetLength(FProcList, Count div SizeOf(DWORD));
      Move(BigArray, FProcList[0], Count);

      for I := Low(FProcList) to High(FProcList) do begin
       ProcHand := OpenProcess(PROCESS_ALL_ACCESS,False,FProcList[I]);
       if ProcHand > 0 then
        try
         ModHand:=0;
         if GetModuleFileNameEx(Prochand, ModHand, ModName, SizeOf(ModName)) > 0 then begin
             li:=LV.Items.Add;
             li.Caption := ExtractFileName(ModName);                    // file name
             li.Data := Pointer(FProcList[I]);         // save ID
             if FileExists(GetWinSysDir+'\'+li.Caption) then
              tmps:=GetWinSysDir+'\'+li.Caption
             else
              tmps:=ModName;
             li.SubItems.Add(tmps);
             li.SubItems.Add(GetUserNameFromHandle(ProcHand));

        //   HAppIcon := ExtractIcon(FProcList[I], ModName, 0);
           if FileExists(tmps) then
            HAppIcon := ExtractAssociatedIcon(HInstance, Pchar(tmps), varout)
           else
            HAppIcon := ExtractIcon(HInstance, Pchar(tmps), 0);
           try
             if HAppIcon = 0 then HAppIcon := FWinIcon;
             if Smallil <> nil then
               li.ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);
             if Largeil<>nil then
               li.ImageIndex := ImageList_AddIcon(Largeil.Handle, HAppIcon);
           finally
             if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
           end;
         end;
        finally
          CloseHandle(ProcHand);
        end;
      end;
     end;
     if rbDriv.Checked then begin

      if not EnumDeviceDrivers(@BigArray, SizeOf(BigArray), Count) then
       raise Exception.Create(SFailMessage);

      SetLength(FDrvList, Count div SizeOf(DWORD));
      Move(BigArray, FDrvList[0], Count);

      for i:=low(FDrvList) to High(FDrvList) do begin

        if GetDeviceDriverFileName(FDrvList[i],DrvName,sizeof(DrvName))>0 then begin

             li:=LV.Items.Add;
             li.Caption := ExtractFileName(DrvName);
             li.Data := Pointer(FDrvList[I]);

             if FileExists(GetWinSysDir+'\'+li.Caption) then
              tmps:=GetWinSysDir+'\'+li.Caption
             else if FileExists(GetWinSysDir+'\Drivers\'+li.Caption) then
              tmps:=GetWinSysDir+'\Drivers\'+li.Caption
             else
              tmps:=DrvName;
             li.SubItems.Add(tmps);
             li.SubItems.Add(Format('%p',[FDrvList[i]]));

           if FileExists(tmps) then
            HAppIcon := ExtractAssociatedIcon(HInstance, Pchar(tmps), varout)
           else
            HAppIcon := ExtractIcon(HInstance, Pchar(tmps), 0);
           try
             if HAppIcon = 0 then HAppIcon := FWinIcon;
             if Smallil <> nil then
               li.ImageIndex := ImageList_AddIcon(Smallil.Handle, HAppIcon);
             if Largeil<>nil then
               li.ImageIndex := ImageList_AddIcon(Largeil.Handle, HAppIcon);
           finally
             if HAppIcon <> FWinIcon then DestroyIcon(HAppIcon);
           end;

        end;
      end;

     end;

   end;
  finally
   if rbProc.Checked then begin
     LV.PopupMenu:=pm;
     btKill.Enabled:=true;
     bibNew.Enabled:=true;
     btExrract.Enabled:=true;
     btDumpMem.Enabled:=true;
     btProcInfo.Enabled:=true;
     btWindows.Enabled:=true;
     btFileInfo.Enabled:=true;
   end;

   if rbDriv.Checked then begin
     LV.PopupMenu:=nil;
     btKill.Enabled:=false;
     bibNew.Enabled:=false;
     btExrract.Enabled:=false;
     btDumpMem.Enabled:=false;
     btProcInfo.Enabled:=false;
     btWindows.Enabled:=false;
//     btFileInfo.Enabled:=false;
   end;
   
   if LV.Items.Count>0 then begin
    ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE);
    LV.Columns[1].width:=270;
//    ListView_SetColumnWidth(LV.Handle,1,LVSCW_AUTOSIZE_USEHEADER);
    ListView_SetColumnWidth(LV.Handle,2,LVSCW_AUTOSIZE);
   end else begin
    ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE_USEHEADER);
    ListView_SetColumnWidth(LV.Handle,1,LVSCW_AUTOSIZE_USEHEADER);
    ListView_SetColumnWidth(LV.Handle,2,LVSCW_AUTOSIZE_USEHEADER);
   end;    

    Lv.Items.EndUpdate;
    ViewCount;
    Screen.Cursor:=crDefault;
  end;

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
{   If Item=sender.Selected then begin
     if not(cdsSelected in State)then
      DrawItem;
   end;             }
end;

procedure TfmProcess.btProcInfoClick(Sender: TObject);
var
  fm: TfmPISI;
  li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  fm:=TfmPISI.Create(nil);
  fm.FormStyle:=FormStyle;
  try
   fm.Caption:=fm.Caption+' - '+li.SubItems.Strings[0];
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
  miUnmapfile.Enabled:=FileMapView<>nil;
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
    miObjectTree.Enabled:=true;
    miPrioritet.Enabled:=true;
    //miMapFile.Enabled:=false;

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

     if LV.SelCount>1 then begin
       miExtractIcon.Enabled:=false;
       miDump.Enabled:=false;
       miInfo.Enabled:=false;
       miWindows.Enabled:=false;
       miObjectTree.Enabled:=false;
       miCopyPath.Enabled:=false;
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
    miObjectTree.Enabled:=false;
    miPrioritet.Enabled:=false;
    //miMapFile.Enabled:=true;
  end;
end;

procedure TfmProcess.miCopyPathClick(Sender: TObject);
var
  li: TListItem;
begin
  li:=Lv.Selected;
  if li<>nil then begin
   clipboard.Clear;
   clipboard.AsText:=Li.SubItems.Strings[0];
  end;
end;

procedure TfmProcess.btAboutClick(Sender: TObject);
var
 fm: TfmAbout;
begin
 fm:=TfmAbout.Create(nil);
 fm.FormStyle:=FormStyle;
 fm.showmodal;
 fm.Free;
end;

procedure TfmProcess.miRealTimeClick(Sender: TObject);
var
  MI: TmenuItem;
  ProcHand: THandle;
  li: TListItem;
  i: Integer;
begin
  li:=lv.Selected;
  if li=nil then exit;
  Mi:=Sender as TMenuItem;
  if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    for i:=0 to LV.Items.Count-1 do begin
     li:=LV.Items[i];
     if li.Selected then begin
      ProcHand:=OpenProcess(PROCESS_SET_INFORMATION,false,LongWord(li.Data));
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
  end else begin
    for i:=0 to LV.Items.Count-1 do begin
     li:=LV.Items[i];
     if li.Selected then begin
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
  fm.FormStyle:=FormStyle;
  try
   fm.Caption:=fm.Caption+' - '+li.SubItems.Strings[0];
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
  fm.FormStyle:=FormStyle;
  try
   if li<>nil then begin
    fm.Caption:=fm.Caption+' - '+li.SubItems.Strings[0];
    fm.FillFileInfo(li.SubItems.Strings[0]);
   end; 
   fm.ShowModal;
  finally
   fm.Free;
  end;
end;

procedure TfmProcess.bibNewClick(Sender: TObject);
begin
  od.FileName:=NewFile;
  od.Filter:=FilterExe;
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

procedure TfmProcess.miObjectTreeClick(Sender: TObject);
var
  li: TListItem;
  ProcessId: LongWord;
begin
  li:=lv.Selected;
  if li=nil then exit;

  fmObjectTree:=TfmObjectTree.Create(nil);
  fmObjectTree.FormStyle:=FormStyle;
  try
   if Win32Platform=VER_PLATFORM_WIN32_NT then begin
    ProcessId:=LongWord(li.data);
   end else begin
    ProcessId:=pProcessEntry32(li.Data).th32ProcessID;
   end;
   fmObjectTree.ViewApplicationObjects(ProcessId);
   if fmObjectTree.isShow then
    fmObjectTree.ShowModal;
  finally
   fmObjectTree.Free;
  end;
end;

procedure TfmProcess.miMapFileClick(Sender: TObject);
{var
  tmps: string;}
begin
  od.FileName:=LastMapFile;
  od.Filter:=FilterAll;
  if od.Execute then begin
    if CreateFileMap(od.FileName) then begin
      LastMapFile:=od.FileName;
      Clipboard.AsText:=inttohex(Longword(FileMapView),8);
{      tmps:='File <'+LastMapFile+'>'+#13+'succsefull mapped on adress '+
            inttohex(Longword(FileMapView),8);
      MessageBox(Application.Handle,Pchar(tmps),'Information',MB_ICONINFORMATION);}
      lv.Selected:=GetSelfListItem;
      DumpFromAddress(Longword(FileMapView),false);


    end else begin
      MessageBox(Application.Handle,Pchar(SysErrorMessage(GetLastError)),nil,MB_iconERROR);
    end;
  end;
end;

procedure TfmProcess.FreeFileMap;
begin
 if HFile<>0 then begin
  if hFileMap<>0 then begin
    if FileMapView<>nil then
     UnmapViewOfFile(FileMapView);
    CloseHandle(hFileMap);
    hFileMap:=0;
    FileMapView:=nil;
  end;
  CloseHandle(hFile);
  hFile:=0;
 end;
end;

function TfmProcess.CreateFileMap(Value: String): Boolean;
begin
  FreeFileMap;
  result:=false;
  hFile := CreateFile(Pchar(Value), GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ+FILE_SHARE_WRITE, nil,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if hFile = INVALID_HANDLE_VALUE then exit;

  hFileMap:=CreateFileMapping(hFile,nil,PAGE_READWRITE,0,0,nil);
  if (HFileMap=INVALID_HANDLE_VALUE) or (HFileMap=0) then begin
    CloseHandle(hFile);
  end;

  FileMapView:=MapViewOfFile(hFileMap,FILE_MAP_ALL_ACCESS,0,0,0);
  if FileMapView=nil then begin
    CloseHandle(hFileMap);
    CloseHandle(hFile);
    hFileMap:=0;
    HFile:=0;
    exit;
  end;
  Result:=true;
end;

function TfmProcess.GetSelfListItem: TListItem;
var
  i: Integer;
  li: TListItem;
  CurProcId: LongWord;
  P: pProcessEntry32;
  ProcId: LongWord;
begin
  result:=nil;
  CurProcId:=GetCurrentProcessId;
  for i:=0 to LV.Items.Count-1 do begin
    li:=LV.Items.Item[i];
    if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
     P:=PProcessEntry32(Li.Data);
     if p.th32ProcessID=CurProcId then begin
      Result:=li;
      exit;
     end;
    end else begin
     ProcId:=Integer(li.data);
     if ProcId=CurProcId then begin
      Result:=li;
      exit;
     end;
    end;
  end;
end;

procedure TfmProcess.DumpFromAddress(Address: Longword; UseStart: Boolean);
var
  PENew: PProcessEntry32;
  fm: TfmDumpMem;
  li: TListItem;
begin
  li:=Lv.Selected;
  if li=nil then exit;
  fm:=TfmDumpMem.Create(nil);
  fm.FormStyle:=FormStyle;
  fm.Caption:=fm.Caption+' - '+li.SubItems.Strings[0];
  fm.ExeName:=li.SubItems.Strings[0];
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
   PENew:=PProcessEntry32(Li.Data);
   fm.ProcessEntry:=PENew;
   fm.FillComboBox98(PENew);
  end else begin
   fm.Proc_ID:=Integer(li.data);
   fm.FillComboBoxNT;
  end;
  if UseStart then begin
   fm.cbStart.ItemIndex:=0;
   fmSearch.edStartAddr.Text:=fm.cbStart.text;
   fm.FirstMemAddr:=strtoint('$'+fm.cbStart.text);
  end else begin
   fmSearch.edStartAddr.Text:=inttohex(Address,8);
   fm.cbStart.Text:=fmSearch.edStartAddr.Text;
   fm.FirstMemAddr:=Address;
  end;
  fm.ViewSystemInfo;
  fm.ViewMemBasic(fm.FirstMemAddr);
  fm.ShowModal;
  fmProgress.Close;
  FreeFileMap;
  fm.Free;
end;

procedure TfmProcess.miUnmapfileClick(Sender: TObject);
begin
  FreeFileMap;
end;

procedure TfmProcess.LVColumnClick(Sender: TObject; Column: TListColumn);
var
 newSortItem:integer;
begin
// if (Column.Index=2) then exit; 
 newSortItem:=Column.Index-1;
 if glSortSubItem=newSortItem then glSortForward:=not glSortForward
 else glSortForward:=true;
 glSortSubItem:=newSortItem;
 if (Column.Index=0) or (Column.Index=1) or (Column.Index=2)  
  then lv.OnCompare:=lvCompareStr;
 lv.AlphaSort;
end;

procedure TfmProcess.lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
 if glSortSubItem>=0 then Compare:=CompareText(Item1.SubItems[glSortSubItem],Item2.SubItems[glSortSubItem])
 else Compare:=CompareText(Item1.Caption,Item2.Caption);
 if glSortForward=false then Compare:=-Compare;
end;


procedure TfmProcess.rbProcClick(Sender: TObject);
begin
  btRefreshClick(nil);
end;

procedure TfmProcess.ViewCount;
begin
  lbCount.Caption:='Count: '+inttostr(lv.Items.Count);
end;

procedure TfmProcess.chbStayOnTopClick(Sender: TObject);
begin
 if chbStayOnTop.Checked then
  FormStyle:=fsStayOnTop
 else
  FormStyle:=fsNormal;

   if LV.Items.Count>0 then begin
    ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE);
    ListView_SetColumnWidth(LV.Handle,1,LVSCW_AUTOSIZE);
    ListView_SetColumnWidth(LV.Handle,2,LVSCW_AUTOSIZE);
   end else begin
    ListView_SetColumnWidth(LV.Handle,0,LVSCW_AUTOSIZE_USEHEADER);
    ListView_SetColumnWidth(LV.Handle,1,LVSCW_AUTOSIZE_USEHEADER);
    ListView_SetColumnWidth(LV.Handle,2,LVSCW_AUTOSIZE_USEHEADER);
   end;
end;

end.

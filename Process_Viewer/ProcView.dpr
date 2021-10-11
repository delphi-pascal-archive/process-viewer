program ProcView;

uses
  Forms,
  windows,
  UMain in 'UMain.pas' {fmProcess},
  USearch in 'USearch.pas' {fmSearch},
  UProgress in 'UProgress.pas' {fmProgress},
  Uins in 'Uins.pas',
  USpecific in 'USpecific.pas' {fmSpecific},
  Psapi in 'psapi.pas',
  UThreadWin in 'UThreadWin.pas' {fmThWin},
  UPInfoSInfo in 'UPInfoSInfo.pas' {fmPISI},
  UDump in 'UDump.pas' {fmDumpMem},
  UAbout in 'UAbout.pas' {fmAbout},
  USendMessage in 'USendMessage.pas' {fmSendMes},
  UMessages in 'UMessages.pas' {fmMess},
  UFileInfo in 'UFileInfo.pas' {fmFileInfo},
  UObjectTree in 'UObjectTree.pas' {fmObjectTree},
  USaveMem in 'USaveMem.pas' {fmSaveMem},
  tsvGrids in 'tsvGrids.pas',
  StrLEdit in 'StrLEdit.pas',
  RyMenus in 'RyMenus.pas',
  UCoding in 'UCoding.pas',
  AclApi in 'aclapi.pas';

{$R *.RES}

begin
  Application.Initialize;
 { Application.Icon.Handle:=windows.LoadImage(0, IDI_WINLOGO, IMAGE_ICON, LR_DEFAULTSIZE,
    LR_DEFAULTSIZE, LR_DEFAULTSIZE or LR_DEFAULTCOLOR or windows.LR_SHARED);   }
    Application.Title := 'Process Viewer';
  Application.CreateForm(TfmProcess, fmProcess);
  Application.CreateForm(TfmSearch, fmSearch);
  Application.CreateForm(TfmProgress, fmProgress);
  Application.CreateForm(TfmIns, fmIns);
  Application.CreateForm(TfmSendMes, fmSendMes);
  Application.CreateForm(TfmMess, fmMess);
  Application.Run;
end.

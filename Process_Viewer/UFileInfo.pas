unit UFileInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus,Clipbrd, PCGrids, ImgList,
  Tabnotbk, MPlayer;

const
  IMAGE_RESOURCE_NAME_IS_STRING    = $80000000;
  IMAGE_RESOURCE_DATA_IS_DIRECTORY = $80000000;
  IMAGE_OFFSET_STRIP_HIGH          = $7FFFFFFF;
  IMAGE_REL_BASED_ABSOLUTE=0;
  IMAGE_REL_BASED_HIGHLOW=3;

type

   PVSVERSIONINFO=^TVSVERSIONINFO;
   TVSVERSIONINFO=packed record
    wLength: Word;
    wValueLength: Word;
    wType: Word;
    szKey: array[0..255] of WideChar;
   end;

  PPkgName = ^TPkgName;
  TPkgName = packed record
    HashCode: Byte;
    Name: array[0..255] of Char;
  end;

  { PackageUnitFlags:
    bit      meaning
    -----------------------------------------------------------------------------------------
    0      | main unit
    1      | package unit (dpk source)
    2      | $WEAKPACKAGEUNIT unit
    3      | original containment of $WEAKPACKAGEUNIT (package into which it was compiled)
    4      | implicitly imported
    5..7   | reserved
  }
  PUnitName = ^TUnitName;
  TUnitName = packed record
    Flags : Byte;
    HashCode: Byte;
    Name: array[0..255] of Char;
  end;

  { Package flags:
    bit     meaning
    -----------------------------------------------------------------------------------------
    0     | 1: never-build                  0: always build
    1     | 1: design-time only             0: not design-time only      on => bit 2 = off
    2     | 1: run-time only                0: not run-time only         on => bit 1 = off
    3     | 1: do not check for dup units   0: perform normal dup unit check
    4..25 | reserved
    26..27| (producer) 0: pre-V4, 1: undefined, 2: c++, 3: Pascal
    28..29| reserved
    30..31| 0: EXE, 1: Package DLL, 2: Library DLL, 3: undefined
  }
  PPackageInfoHeader = ^TPackageInfoHeader;
  TPackageInfoHeader = packed record
    Flags: DWORD;
    RequiresCount: Integer;
    {Requires: array[0..9999] of TPkgName;
    ContainsCount: Integer;
    Contains: array[0..9999] of TUnitName;}
  end;

  PIconHeader = ^TIconHeader;
  TIconHeader = packed record
    wReserved: Word;         { Currently zero }
    wType: Word;             { 1 for icons }
    wCount: Word;            { Number of components }
  end;

  PIconResInfo = ^TIconResInfo;
  TIconResInfo = packed record
    bWidth: Byte;
    bHeight: Byte;
    bColorCount: Byte;
    bReserved: Byte;
    wPlanes: Word;
    wBitCount: Word;
    lBytesInRes: DWORD;
    wNameOrdinal: Word;      { Points to component }
  end;

  PCursorResInfo = ^TCursorResInfo;
  TCursorResInfo = packed record
    wWidth: Word;
    wHeight: Word;
    wPlanes: Word;
    wBitCount: Word;
    lBytesInRes: DWORD;
    wNameOrdinal: Word;      { Points to component }
  end;

  TtpNode=(tpnFileName,tpnDosHeader,tpnNtHeader,tpnFileHeader,tpnOptionalHeader,
           tpnSections,tpnSectionHeader,tpnExports,tpnExport,tpnImports,
           tpnImport,tpnResources,tpnResource,tpnException,tpnSecurity,
           tpnBaseRelocs,tpnBaseReloc,tpnDebugs,tpnCopyright,tpnGlobalptr,
           tpnTls,tpnLoadconfig,tpnBoundImport,tpnIat,tpn13,tpn14,tpn15);


  PIMAGE_TLS_DIRECTORY_ENTRY=^IMAGE_TLS_DIRECTORY_ENTRY;
  IMAGE_TLS_DIRECTORY_ENTRY=packed record
    StartData: DWord;
    EndData: DWord;
    Index: DWord;
    CallBackTable: DWord;
  end;

  PIMAGE_BASE_RELOCATION=^IMAGE_BASE_RELOCATION;
  IMAGE_BASE_RELOCATION=packed record
    VirtualAddress: DWord;
    SizeOfBlock: DWord;
  end;

  PIMAGE_IMPORT_BY_NAME=^IMAGE_IMPORT_BY_NAME;
  IMAGE_IMPORT_BY_NAME=packed record
    Hint: Word;
    Name: DWord;
  end;

  PIMAGE_THUNK_DATA=^IMAGE_THUNK_DATA;
  IMAGE_THUNK_DATA = packed record
    NameTable: DWord;
  end;

  PIMAGE_IMPORT_DESCRIPTOR=^IMAGE_IMPORT_DESCRIPTOR;
  IMAGE_IMPORT_DESCRIPTOR=packed record
    Characteristics: DWord;
    TimeDateStamp: DWord;
    ForwarderChain: DWord;
    Name: DWord;
    FirstThunk: DWord;
  end;

  PIMAGE_RESOURCE_DATA_ENTRY = ^IMAGE_RESOURCE_DATA_ENTRY;
  IMAGE_RESOURCE_DATA_ENTRY = packed record
    OffsetToData    : DWORD;
    Size            : DWORD;
    CodePage        : DWORD;
    Reserved        : DWORD;
  end;

  PIMAGE_RESOURCE_DIR_STRING_U = ^IMAGE_RESOURCE_DIR_STRING_U;
  IMAGE_RESOURCE_DIR_STRING_U = packed record
    Length          : WORD;
    NameString      : array [0..0] of WCHAR;
  end;

  PIMAGE_RESOURCE_DIRECTORY_ENTRY=^IMAGE_RESOURCE_DIRECTORY_ENTRY;
  IMAGE_RESOURCE_DIRECTORY_ENTRY=packed record
    Name: DWord;
    OffsetToData: DWord;
  end;

  PIMAGE_RESOURCE_DIRECTORY=^IMAGE_RESOURCE_DIRECTORY;
  IMAGE_RESOURCE_DIRECTORY=packed record
    Characteristics: DWord;
    TimeDateStamp: DWord;
    MajorVersion: Word;
    MinorVersion: Word;
    NumberOfNamedEntries: Word;
    NumberOfIdEntries: Word;
  end;

  TfmFileInfo = class(TForm)
    Panel1: TPanel;
    btClose: TBitBtn;
    btSelect: TBitBtn;
    od: TOpenDialog;
    pmMemo: TPopupMenu;
    miCancel: TMenuItem;
    N1: TMenuItem;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miDel: TMenuItem;
    N3: TMenuItem;
    miSelAll: TMenuItem;
    fd: TFontDialog;
    N2: TMenuItem;
    miSearch: TMenuItem;
    fdFileInfo: TFindDialog;
    TV: TTreeView;
    Splitter1: TSplitter;
    pnClient: TPanel;
    il: TImageList;
    Splitter2: TSplitter;
    pnTopStatus: TPanel;
    ntbInfo: TNotebook;
    lbFileName_Path: TLabel;
    edFileName_Path: TEdit;
    pnDosHeader_Main: TPanel;
    btApply: TBitBtn;
    pmNone: TPopupMenu;
    miNoneCopy: TMenuItem;
    pnNtHeader_Main: TPanel;
    pnFileHeader_Main: TPanel;
    pnOptionalHeader_Main: TPanel;
    pnListSections_Main: TPanel;
    lbTopStatus: TLabel;
    pnSectionHeader_Main: TPanel;
    pnExports_Main: TPanel;
    pnExports_Top: TPanel;
    Splitter3: TSplitter;
    pnImports_Main: TPanel;
    pnImport_Top: TPanel;
    Splitter4: TSplitter;
    pnImport_Main: TPanel;
    pnResources_Main: TPanel;
    pnResource_Top: TPanel;
    Splitter5: TSplitter;
    pnResource_Main: TPanel;
    lbException_Main: TLabel;
    lbSecurity_Main: TLabel;
    pnBaseRelocs_Main: TPanel;
    pnBaseReloc_Main: TPanel;
    pndebugs_Main: TPanel;
    lbCopyright_Main: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    sd: TSaveDialog;
    pmTVView: TPopupMenu;
    miViewFindInTv: TMenuItem;
    N8: TMenuItem;
    miExpand: TMenuItem;
    miCollapse: TMenuItem;
    miExpandAll: TMenuItem;
    miCollapseAll: TMenuItem;
    fdTvFileInfo: TFindDialog;
    pnResDataBottom: TPanel;
    bibSaveToFile: TBitBtn;
    re: TRichEdit;
    chbHexView: TCheckBox;
    pnResDataTop: TPanel;
    bibFont: TBitBtn;
    miTVSaveNode: TMenuItem;
    N4: TMenuItem;
    procedure btCloseClick(Sender: TObject);
    procedure btSelectClick(Sender: TObject);
    procedure pmMemoPopup(Sender: TObject);
    procedure miCancelClick(Sender: TObject);
    procedure miCutClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miPasteClick(Sender: TObject);
    procedure miDelClick(Sender: TObject);
    procedure miSelAllClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure miOpenFileClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure miSearchClick(Sender: TObject);
    procedure fdFileInfoFind(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure miNoneCopyClick(Sender: TObject);
    procedure TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure miExpandClick(Sender: TObject);
    procedure miCollapseClick(Sender: TObject);
    procedure miExpandAllClick(Sender: TObject);
    procedure miCollapseAllClick(Sender: TObject);
    procedure miViewFindInTvClick(Sender: TObject);
    procedure fdTvFileInfoFind(Sender: TObject);
    procedure chbHexViewClick(Sender: TObject);
    procedure pmTVViewPopup(Sender: TObject);
    procedure TVEdited(Sender: TObject; Node: TTreeNode; var S: String);
  private
    meText: Tmemo;
    Anim: TAnimate;
    OldRow,OldCol: Integer;
    OldRowNew,OldColNew: Integer;
    OldRowHex,OldColHex: Integer;
    Mems: TmemoryStream;
    pnResDataClient: TPanel;
    imResData: TImage;
    TypeNode: TtpNode;
    sg: TStringGrid;
    sgNew: TStringGrid;
    sgHex: TStringGrid;
    FindString: string;
    PosFind: Integer;
    FileName: string;
    hFileMap: THandle;
    hFile: THandle;
    FileMapView: Pointer;
    FindStringInTreeView: string;
    FPosInTreeView: Integer;
    function CreateFileMap(Value: String): Boolean;
    procedure FreeFileMap;
    function GetNameResource(resType,ResourceBase: DWord;
                     resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
                     level: Integer): string;
    function GetResourceTypeFromId(TypeID: Word): string;
    function GetResourceNameFromId(ResourceBase: DWord;
                      resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY): string;
    procedure DumpResourceDirectory(resDir: PIMAGE_RESOURCE_DIRECTORY;
                                      resourceBase: DWORD;
                                      level: DWORD;
                                      mHandle: DWord);
    procedure FillTreeView(mHandle: DWord);
    procedure ClearTreeView;
    function GetImageDirectory(I: Integer): String;
    function GetPointer(mHandle: DWord; Addr: DWord; StartAddress: DWord;
                                    NumSection: Word; var Delta: Integer):Pointer;
    function GetSectionHdr(const SectionName: string;
                           var Header: PImageSectionHeader;
                           FNTHeader: PImageNtHeaders): Boolean;
    procedure ActiveInfo(Node: TTreeNode; HexView: Boolean);
    procedure HideAllTabSheets;
    procedure sgKeyPress_DosHeader(Sender: TObject; var Key: Char);
    procedure sgKeyPress_ListSections(Sender: TObject; var Key: Char);
    procedure sgNewKeyPress_Exports(Sender: TObject; var Key: Char);
    procedure sgNewKeyPress_Resource(Sender: TObject; var Key: Char);

    procedure sgKeyPress_BaseRelocs(Sender: TObject; var Key: Char);

    procedure sgSelectCell_DosHeader(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
    procedure sgSelectCell_ListSections(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
    procedure sgNewSelectCell_Exports(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
    procedure sgNewSelectCell_Resource(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
    procedure sgHexSelectCell(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);

    procedure sgSelectCell_BaseRelocs(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);

    procedure edOnExit_DosHeader_Hex(Sender: TObject);
    function GetNtHeaderSignature(Signature: DWord): String;
    function GetFileHeaderMachine(Machine: Word): String;
    function GetTimeDateStamp(TimeDateStamp: DWORD): String;
    function GetFileHeaderCharacteristics(Characteristics: Word): string;
    function GetOptionalHeaderMagic(Magic: Word): string;
    function GetOptionalHeaderSubSystem(Subsystem: Word): string;
    function GetOptionalHeaderDllCharacteristics(DllCharacteristics: Word): string;
    procedure SetGridColWidth;
    procedure SetNewGridColWidth;
    function GetListSectionsCharacteristics(Characteristics: DWord): String;
    procedure GridFillFromMem(grid: TStringGrid; ProcMem: Pointer; MemSize: Integer; lpAddress: Integer;
                              Offset: Integer);
    procedure SetTextFromHex(Hideedit: Boolean);
    procedure sgHexExit(Sender: TObject);
    procedure sgHexDrawCell(Sender: TObject; ACol, ARow: Integer;
        Rect: TRect; State: TGridDrawState);
    procedure bibSaveToFileClick_sgHex(Sender: TObject);
    procedure bibSaveToFileClick_Text(Sender: TObject);
    procedure bibSaveToFileClick_Cursor(Sender: TObject);
    procedure bibSaveToFileClick_Avi(Sender: TObject);
    procedure bibSaveToFileClick_Bmp(Sender: TObject);
    procedure bibSaveToFileClick_Icon(Sender: TObject);

    procedure BMPGetStream(Mem: Pointer; Size: Integer; Stream: TMemoryStream);
    procedure MenuGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
    procedure StringGetStream(Memory: Pointer; Size: Integer;
                              Stream: TMemoryStream;
                              DirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY);
    procedure GroupCursorGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
    procedure GroupIconGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
    procedure GetPackageInfoText(Memory: Pointer; Size: Integer; List: TStrings);
    procedure GetVersionText(Memory: Pointer; Size: Integer; List: TStrings);
    procedure FontClick_Hex(Sender: TObject);
    procedure FontClick_Text(Sender: TObject);

    procedure FindInTreeView;

  public
    procedure FillFileInfo(Value: string);
  end;

var
  fmFileInfo: TfmFileInfo;

implementation

uses UMain, RyMenus;

type

  PInfNode=^TInfNode;
  TInfNode=packed record
    tpNode: TtpNode;
    PInfo: Pointer;
  end;

  PInfFileName=^TInfFileName;
  TInfFileName=packed record
    FileName: string;
  end;

  PInfListSections=^TInfListSections;
  TInfListSections=packed record
    List: TList;
  end;

  PInfListExports=^TInfListExports;
  TInfListExports=packed record
    IED: PImageExportDirectory;
    List: TList;
  end;

  PInfExport=^TInfExport;
  TInfExport=packed record
    EntryPoint: DWord;
    Ordinal: DWord;
    Name: String;
  end;

  PInfListImports=^TInfListImports;
  TInfListImports=packed record
    List: TList;
  end;

  PInfImport=^TInfImport;
  TInfImport=packed record
    PID: PIMAGE_IMPORT_DESCRIPTOR;
    Name: string;
    List: TList;
  end;

  PInfImportName=^TInfImportName;
  TInfImportName=packed record
    HintOrd: Word;
    Name: string;
  end;

  TResourceTypeList=(rtlData,rtlDir);

  PInfListResources=^TInfListResources;
  TInfListResources=packed record
    List: TList;
  end;

  PInfResource=^TInfResource;
  TInfResource=packed record
    TypeRes: TResourceTypeList;
    NameRes: String;
    TypeParentRes: Word;
    IsTypeParentName: Boolean;
    ParentNameRes: String;
    Level: Integer;
    ResDir: PIMAGE_RESOURCE_DIRECTORY;
    ResDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
    ResDirEntryParent: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
    ResList: TList;
    ResData: Pointer;
    ResDataMem: Pointer;
  end;

  PInfException=^TInfException;
  TInfException=packed record
  end;

  PInfSecurity=^TInfSecurity;
  TInfSecurity=packed record
  end;

  PInfListBaseRelocs=^TInfListBaseRelocs;
  TInfListBaseRelocs=packed record
    List: TList;
  end;

  PInfBaseReloc=^TInfBaseReloc;
  TInfBaseReloc=packed record
    PIB: PIMAGE_BASE_RELOCATION;
    List: TList; 
  end;

  PInfBaseRelocName=^TInfBaseRelocName;
  TInfBaseRelocName=packed record
    Address: DWord;
    TypeReloc: String;
  end;

  PInfListDebugs=^TInfListDebugs;
  TInfListDebugs=packed record
    List: TList;
  end;

  PInfDebug=^TImageDebugDirectory;

  PInfCopyright=^TInfCopyright;
  TInfCopyright=packed record
  end;

  PInfGlobalptr=^TInfGlobalptr;
  TInfGlobalptr=packed record
  end;

  PInfTls=^IMAGE_TLS_DIRECTORY_ENTRY;

  PInfLoadconfig=^TInfLoadconfig;
  TInfLoadconfig=packed record
  end;

  PInfBoundImport=^TInfBoundImport;
  TInfBoundImport=packed record
  end;

  PInfIat=^TInfIat;
  TInfIat=packed record
  end;

  PInf13=^TInf13;
  TInf13=packed record
  end;

  PInf14=^TInf14;
  TInf14=packed record
  end;

  PInf15=^TInf15;
  TInf15=packed record
  end;

  PInfDosHeader=^TImageDosHeader;
  PInfNtHeader=^TImageNtHeaders;
  PInfFileHeader=^TImageFileHeader;
  PInfOptionalHeader=^TImageOptionalHeader;
  PInfSectionHeader=^TImageSectionHeader;


const
  CaptionEx='File Information';
  FilterAllFiles='All Files (*.*)|*.*';
  FilterAviFiles='Video Files (*.avi)|*.avi';
  FilterTxtFiles='Text Files (*.txt)|*.txt';
  FilterCursorFiles='Cursor Files (*.cur)|*.cur';
  FilterBmpFiles='Bitmap Files (*.bmp)|*.bmp';
  FilterIcoFiles='Icon Files (*.ico)|*.ico';

var
  tmpFileAvi: string;

{$R *.DFM}

function GetRealCheckSum(Value: string): String;
var
  CheckSum: DWord;
  hFile: THandle;
  FileSize: Dword;
  i: Integer;
begin
  result:=' ';
  hFile:=CreateFile(Pchar(Value),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,
                    FILE_ATTRIBUTE_NORMAL+FILE_ATTRIBUTE_SYSTEM+FILE_ATTRIBUTE_READONLY,0);
  if hFile<>0 then begin
   FileSize:=GetFileSize(hFile,nil);
   for i:=1 to 32 do begin
    CheckSum:=FileSize shr i;
    Result:=Result+' '+inttohex(CheckSum,8);
   end;
   CloseHandle(hFile);
  end; 
end;

function HighBitSet(L: DWord): Boolean;
begin
  Result := (L and IMAGE_RESOURCE_DATA_IS_DIRECTORY) <> 0;
end;

function StripHighBit(L: DWord): Dword;
begin
  Result := L and IMAGE_OFFSET_STRIP_HIGH;
end;

function StripHighPtr(L: DWord): Pointer;
begin
  Result := Pointer(L and IMAGE_OFFSET_STRIP_HIGH);
end;

function WideCharToStr(WStr: PWChar; Len: Integer): string;
begin
  if Len = 0 then Len := -1;
  Len := WideCharToMultiByte(CP_ACP, 0, WStr, Len, nil, 0, nil, nil);
  SetLength(Result, Len);
  WideCharToMultiByte(CP_ACP, 0, WStr, Len, PChar(Result), Len, nil, nil);
end;

var
  NestLevel: Integer;
  NestStr: string;

procedure TfmFileInfo.MenuGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
var
  IsPopup: Boolean;
  Len: Word;
  MenuData: PWord;
  MenuEnd: PChar;
  MenuText: PWChar;
  MenuID: Word;
  MenuFlags: Word;
  S: string;
  str: TStringList;
begin
  str:=TStringList.Create;
  try
    with TStrings(str) do
    begin
      BeginUpdate;
      try
        Clear;
        MenuData := Memory;
        MenuEnd := PChar(Memory) + Size;
        Inc(MenuData, 2);
        NestLevel := 0;
        while PChar(MenuData) < MenuEnd do
        begin
          MenuFlags := MenuData^;
          Inc(MenuData);
          IsPopup := (MenuFlags and MF_POPUP) = MF_POPUP;
          MenuID := 0;
          if not IsPopup then
          begin
            MenuID := MenuData^;
            Inc(MenuData);
          end;
          MenuText := PWChar(MenuData);
          Len := lstrlenw(MenuText);
          if Len = 0 then
            S := 'MENUITEM SEPARATOR'
          else
          begin
            S := WideCharToStr(MenuText, Len);
            if IsPopup then
              S := Format('POPUP "%s"', [S]) else
              S := Format('MENUITEM "%s",  %d', [S, MenuID]);
          end;
          Inc(MenuData, Len + 1);
          Add(NestStr + S);
          if (MenuFlags and MF_END) = MF_END then
          begin
            NestLevel := NestLevel - 1;
            Add(NestStr + 'ENDPOPUP');
          end;
          if IsPopup then
            NestLevel := NestLevel + 1;
        end;
      finally
        EndUpdate;
      end;
    end;
    Str.SaveToStream(Stream);
    Stream.Position:=0;
  finally
   Str.Free;
  end;

end;


procedure TfmFileInfo.StringGetStream(Memory: Pointer; Size: Integer;
                                      Stream: TMemoryStream;
                                      DirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY);
var
  P: PWChar;
  ID: Integer;
  Cnt: Cardinal;
  Len: Word;
  str: TStringList;
const
  StringsPerBlock=16;
begin
  str:=TStringList.Create;
  try
    with TStrings(str) do
    begin
      BeginUpdate;
      try
        Clear;
        P := Memory;
        Cnt := 0;
        while Cnt < StringsPerBlock do
        begin
          Len := Word(P^);
          if Len > 0 then
          begin
            Inc(P);
            ID := ((DirEntry.Name - 1) shl 4) + Cnt;
            Add(Format('%d,  "%s"', [ID, WideCharToStr(P, Len)]));
            Inc(P, Len);
          end else Inc(P);
          Inc(Cnt);
        end;
      finally
        EndUpdate;
      end;
    end;
    Str.SaveToStream(Stream);
    Stream.Position:=0;
  finally
   Str.Free;
  end;

end;

procedure TfmFileInfo.BMPGetStream(Mem: Pointer; Size: Integer; Stream: TMemoryStream);

  function GetDInColors(BitCount: Word): Integer;
  begin
    case BitCount of
      1, 4, 8: Result := 1 shl BitCount;
    else
      Result := 0;
    end;
  end;

var
  BH: TBitmapFileHeader;
  BI: PBitmapInfoHeader;
  BC: PBitmapCoreHeader;
  ClrUsed: Integer;
  SelfSize: Integer;
begin
  SelfSize:=Size;
  FillChar(BH, sizeof(BH), #0);
  BH.bfType := $4D42;
  BH.bfSize := SelfSize + sizeof(BH);
  BI := PBitmapInfoHeader(Mem);
  if BI.biSize = sizeof(TBitmapInfoHeader) then
  begin
    ClrUsed := BI.biClrUsed;
    if ClrUsed = 0 then
      ClrUsed := GetDInColors(BI.biBitCount);
    BH.bfOffBits :=  ClrUsed * SizeOf(TRgbQuad) +
      sizeof(TBitmapInfoHeader) + sizeof(BH);
  end
  else
  begin
    BC := PBitmapCoreHeader(Mem);
    ClrUsed := GetDInColors(BC.bcBitCount);
    BH.bfOffBits :=  ClrUsed * SizeOf(TRGBTriple) +
      sizeof(TBitmapCoreHeader) + sizeof(BH);
  end;
  Stream.Write(BH, SizeOf(BH));
  Stream.Write(Mem^, SelfSize);
  Stream.Seek(0,0);
end;

procedure TfmFileInfo.TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
var
  rt: Trect;
begin
{  if GetFocus<>tv.Handle then begin
    if Node=Tv.Selected then begin
      tv.Canvas.Brush.Style:=bsSolid;
      tv.Canvas.Brush.Color:=clBtnFace;
      rt:=Node.DisplayRect(true);
      tv.Canvas.FillRect(rt);
      tv.Canvas.Brush.Style:=bsClear;
      tv.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
 //     tv.Canvas.DrawFocusRect(rt);
//      DefaultDraw:=false;
    end else begin
     DefaultDraw:=true;
    end;
  end else DefaultDraw:=true;    }
end;

procedure TfmFileInfo.btCloseClick(Sender: TObject);
begin
  Close;
end;

function TfmFileInfo.CreateFileMap(Value: String): Boolean;
begin
  FreeFileMap;
  result:=false;
  hFile := CreateFile(Pchar(Value), GENERIC_READ, FILE_SHARE_READ, nil,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if hFile = INVALID_HANDLE_VALUE then exit;

  hFileMap:=CreateFileMapping(hFile,nil,PAGE_READONLY,0,0,nil);
  if (HFileMap=INVALID_HANDLE_VALUE) or (HFileMap=0) then begin
    CloseHandle(hFile);
  end;

  FileMapView:=MapViewOfFile(hFileMap,FILE_MAP_READ,0,0,0);
  if FileMapView=nil then begin
    CloseHandle(hFileMap);
    CloseHandle(hFile);
    hFileMap:=0;
    HFile:=0;
    exit;
  end;
  Result:=true;
end;

procedure TfmFileInfo.FreeFileMap;
begin
 if HFile<>0 then begin
  if hFileMap<>0 then begin
    if FileMapView<>nil then
     UnmapViewOfFile(FileMapView);
    CloseHandle(hFileMap);
    hFileMap:=0;
  end;
  CloseHandle(hFile);
  hFile:=0;
 end;
end;


procedure TfmFileInfo.btSelectClick(Sender: TObject);
begin
  if FileExists(FileName) then begin
   od.InitialDir:=EXtractFileDir(FileName);
   od.FileName:=FileName;
   od.DefaultExt:='*'+ExtractFileExt(FileName);
  end;
  if od.Execute then begin
     FillFileInfo(od.FileName);
  end;
end;


procedure TfmFileInfo.pmMemoPopup(Sender: TObject);
begin
   miCancel.Enabled:=re.CanUndo;
   if re.SelText='' then begin
     miCut.Enabled:=false;
     miCopy.Enabled:=false;
     miDel.Enabled:=false;
   end else begin
     miCut.Enabled:=false;
     miCopy.Enabled:=true;
     miDel.Enabled:=false;
   end;
  if ClipBoard.HasFormat(CF_TEXT) then begin
    miPaste.Enabled:=false;
  end else begin
    miPaste.Enabled:=false;
  end;
end;

procedure TfmFileInfo.miCancelClick(Sender: TObject);
begin
  re.Undo;
end;

procedure TfmFileInfo.miCutClick(Sender: TObject);
begin
  re.CutToClipboard;
end;

procedure TfmFileInfo.miCopyClick(Sender: TObject);
begin
  re.CopyToClipboard;
end;

procedure TfmFileInfo.miPasteClick(Sender: TObject);
begin
  re.PasteFromClipboard;
end;

procedure TfmFileInfo.miDelClick(Sender: TObject);
begin
  re.ClearSelection;
end;

procedure TfmFileInfo.miSelAllClick(Sender: TObject);
begin
  re.SelectAll;
end;

procedure TfmFileInfo.miFontClick(Sender: TObject);
begin
 if re.SelText='' then begin
    fd.Font.Assign(re.Font);
 end else begin
   fd.Font.Charset:=re.SelAttributes.Charset;
   fd.Font.Color:=re.SelAttributes.Color;
   fd.Font.Name:=re.SelAttributes.Name;
   fd.Font.Pitch:=re.SelAttributes.Pitch;
   fd.Font.Size:=re.SelAttributes.Size;
   fd.Font.Style:=re.SelAttributes.Style;
   fd.Font.Height:=re.SelAttributes.Height;
 end;
 if fd.Execute then begin
   if re.SelText='' then begin
    re.Font.Assign(fd.Font);
   end else begin
    re.SelAttributes.Charset:=fd.Font.Charset;
    re.SelAttributes.Color:=fd.Font.Color;
    re.SelAttributes.Name:=fd.Font.Name;
    re.SelAttributes.Pitch:=fd.Font.Pitch;
    re.SelAttributes.Size:=fd.Font.Size;
    re.SelAttributes.Style:=fd.Font.Style;
    re.SelAttributes.Height:=fd.Font.Height;
   end; 
 end;
end;

procedure TfmFileInfo.miOpenFileClick(Sender: TObject);
begin
  btSelectClick(nil);
end;

procedure TfmFileInfo.btSearchClick(Sender: TObject);
begin
  fdFileInfo.FindText:=FindString;
  if fdFileInfo.Execute then begin
  end;
end;

procedure TfmFileInfo.miSearchClick(Sender: TObject);
begin
  btSearchClick(nil);
end;

var
  NextStr: string;

procedure TfmFileInfo.fdFileInfoFind(Sender: TObject);
var
  fdCase: Boolean;
  StartPos,FoundAt,FoundAtPlus: LongInt;
begin
  fdCase:=(frMatchCase in fdFileInfo.Options);
  if re.SelLength <> 0 then begin
    StartPos := re.SelStart + re.SelLength+1;
  end else begin
    StartPos := 1;
  end;
  NextStr:=Copy(re.Text,StartPos,Length(re.Text));
  if fdCase then begin
   FoundAtPlus :=StartPos+Pos(fdFileInfo.FindText,NextStr);

  end else begin
   FoundAtPlus :=StartPos+Pos(AnsiUpperCase(fdFileInfo.FindText),AnsiUpperCase(NextStr));
  end;

  FoundAt:=FoundAtPlus-StartPos;
  if FoundAt<>0 then begin
    re.SetFocus;
    re.SelStart:=FoundAtPlus-2;
    re.SelLength:=Length(fdFileInfo.FindText);
    FindString:=fdFileInfo.FindText;
  end else begin
   re.SelLength:=0;
   MessageBox(Application.Handle,Pchar('Text à <'+fdFileInfo.FindText+'> anymore found.'),
             'Information',MB_ICONINFORMATION);
  end;
end;


procedure TfmFileInfo.FormCreate(Sender: TObject);
begin
  RyMenu.Add(pmTVView,nil);
  RyMenu.Add(pmNone,nil);
  RyMenu.Add(pmMemo,nil);

  tmpFileAvi:=ExtractFileDir(Application.ExeName)+'\tmpAvi.avi';


  meText:=Tmemo.Create(Self);
  meText.ScrollBars:=ssBoth;
  meText.ReadOnly:=true;
  meText.Visible:=false;
//  meText.PopupMenu:=pmMemo;

  Mems:=TmemoryStream.Create;


  pnResDataClient:=TPanel.Create(nil);
  pnResDataClient.BevelOuter:=bvNone;
  pnResDataClient.Caption:='';
  pnResDataClient.Parent:=pnResource_Main;
  pnResDataClient.Align:=alClient;

  pnResDataTop.Parent:=pnResDataClient;
  pnResDataTop.Align:=alTop;
  pnResDataTop.Height:=45;

  Anim:=TAnimate.Create(Self);
  Anim.Align:=alClient;
  Anim.parent:=pnResDataClient;
  Anim.Center:=true;

  re.parent:=pnResDataClient;
  Re.Align:=alClient;

  imResData:=TImage.Create(nil);
  imResData.Center:=true;
  imResData.parent:=pnResDataClient;
  imResData.Align:=alClient;


  PosFind:=0;
  sg:=TStringGrid.Create(nil);
//  sg.Parent:=pnClient;
  sg.Align:=alClient;
  sg.FixedRows:=1;
  sg.FixedCols:=0;
  sg.ColCount:=3;
  sg.RowCount:=2;
  sg.ColWidths[0]:=150;
  sg.ColWidths[1]:=100;
  sg.ColWidths[2]:=300;

  sg.DefaultRowHeight:=16;
  sg.Options:=sg.Options+[goEditing]+[goRangeSelect]+[gocolSizing]+[goDrawFocusSelected];
  sg.Visible:=false;

  sgNew:=TStringGrid.Create(nil);
  sgNew.Align:=alClient;
  sgNew.FixedRows:=1;
  sgNew.FixedCols:=0;
  sgNew.ColCount:=3;
  sgNew.RowCount:=2;
  sgNew.ColWidths[0]:=150;
  sgNew.ColWidths[1]:=100;
  sgNew.ColWidths[2]:=300;

  sgNew.DefaultRowHeight:=16;
  sgNew.Options:=sgNew.Options+[goEditing]+[goRangeSelect]+[gocolSizing]+[goDrawFocusSelected];
  sgNew.Visible:=false;

  sgHex:=TStringGrid.Create(nil);
  sgHex.Align:=alClient;
  sgHex.FixedRows:=1;
  sgHex.FixedCols:=0;
  sgHex.ColCount:=3;
  sgHex.RowCount:=2;
  sgHex.ColWidths[0]:=150;
  sgHex.ColWidths[1]:=100;
  sgHex.ColWidths[2]:=300;

  sgHex.DefaultRowHeight:=16;
  sgHex.OnDrawCell:=sgHexDrawCell;
  sgHex.Options:=sgHex.Options+[goEditing]+[goRangeSelect]+[gocolSizing]+[goDrawFocusSelected];
  sgHex.Visible:=false;

  ntbInfo.Visible:=false;
  HideAllTabSheets;
end;

procedure TfmFileInfo.FillFileInfo(Value: string);

  procedure FillImageDosHeader(pDOSHead: TImageDosHeader);
  var
    str: string;
    i: integer;
  begin
    re.Lines.Add('');
    re.SelAttributes.Style:=[fsbold];
    re.Lines.Add('IMAGE_DOS_HEADER');
    re.SelAttributes.Style:=[];
    re.Lines.Add('');
    str:='Magic number: '+inttohex(pDOSHead.e_magic,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Bytes on last page of file: '+inttohex(pDOSHead.e_cblp,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Pages in file: '+inttohex(pDOSHead.e_cp,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Relocations: '+inttohex(pDOSHead.e_crlc,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Size of header in paragraphs: '+inttohex(pDOSHead.e_cparhdr,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Minimum extra paragraphs needed: '+inttohex(pDOSHead.e_minalloc,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Maximum extra paragraphs needed: '+inttohex(pDOSHead.e_maxalloc,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Initial (relative) SS value: '+inttohex(pDOSHead.e_ss,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Initial SP value: '+inttohex(pDOSHead.e_sp,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Checksum: '+inttohex(pDOSHead.e_csum,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Initial IP value: '+inttohex(pDOSHead.e_ip,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Initial (relative) CS value: '+inttohex(pDOSHead.e_cs,2*sizeof(Word));
    re.Lines.Add(str);
    str:='File address of relocation table: '+inttohex(pDOSHead.e_lfarlc,2*sizeof(Word));
    re.Lines.Add(str);
    str:='Overlay number: '+inttohex(pDOSHead.e_ovno,2*sizeof(Word));
    re.Lines.Add(str);
    for i:=0 to 2 do begin
     str:='Reserved words 1['+inttostr(i)+']: '+inttohex(pDOSHead.e_res[i],2*sizeof(Word));
     re.Lines.Add(str);
    end;
    str:='OEM identifier (for e_oeminfo): '+inttohex(pDOSHead.e_oemid,2*sizeof(Word));
    re.Lines.Add(str);
    str:='OEM information; e_oemid specific: '+inttohex(pDOSHead.e_oeminfo,2*sizeof(Word));
    re.Lines.Add(str);
    for i:=0 to 9 do begin
     str:='Reserved words 2['+inttostr(i)+']: '+inttohex(pDOSHead.e_res2[i],2*sizeof(Word));
     re.Lines.Add(str);
    end;
    str:='File address of new exe header: '+inttohex(pDOSHead._lfanew,2*sizeof(LongInt));
    re.Lines.Add(str);
  end;

  procedure FillImageNtHeaders(Addr: Dword; pPEHeader: TImageNtHeaders);
  var
    str: string;
  begin
    re.Lines.Add('');
    re.SelAttributes.Style:=[fsbold];
    re.Lines.Add('IMAGE_NT_HEADERS');
    re.SelAttributes.Style:=[];
    re.Lines.Add('');
    str:='Signature: '+inttohex(pPEHeader.Signature,2*sizeof(pPEHeader.Signature));
    re.Lines.Add(str);
    str:='FileHeader address: '+inttohex(Addr+sizeof(pPEHeader.Signature),2*sizeof(DWORD));
    re.Lines.Add(str);
    str:='OptionalHeader address: '+inttohex(Addr+sizeof(pPEHeader.Signature)+
                                     sizeof(pPEHeader.FileHeader),2*sizeof(DWORD));
    re.Lines.Add(str);
  end;

  procedure FillImageFileHeader(FileHeader: TImageFileHeader);
  var
    str: string;
  begin
    re.Lines.Add('');
    re.SelAttributes.Style:=[fsbold];
    re.Lines.Add('IMAGE_FILE_HEADER');
    re.SelAttributes.Style:=[];
    re.Lines.Add('');
    str:='Machine: '+inttohex(FileHeader.Machine,2*sizeof(FileHeader.Machine));
    re.Lines.Add(str);
    str:='NumberOfSections: '+inttohex(FileHeader.NumberOfSections,2*sizeof(FileHeader.NumberOfSections));
    re.Lines.Add(str);
    str:='TimeDateStamp: '+inttohex(FileHeader.TimeDateStamp,2*sizeof(FileHeader.TimeDateStamp));
    re.Lines.Add(str);
    str:='PointerToSymbolTable: '+inttohex(FileHeader.PointerToSymbolTable,2*sizeof(FileHeader.PointerToSymbolTable));
    re.Lines.Add(str);
    str:='NumberOfSymbols: '+inttohex(FileHeader.NumberOfSymbols,2*sizeof(FileHeader.NumberOfSymbols));
    re.Lines.Add(str);
    str:='SizeOfOptionalHeader: '+inttohex(FileHeader.SizeOfOptionalHeader,2*sizeof(FileHeader.SizeOfOptionalHeader));
    re.Lines.Add(str);
    str:='Characteristics: '+inttohex(FileHeader.Characteristics,2*sizeof(FileHeader.Characteristics));
    re.Lines.Add(str);
  end;


  procedure FillImageOptionalHeader(OptionalHeader: TImageOptionalHeader);
  var
    str: string;
    i: Integer;
  begin
    re.Lines.Add('');
    re.SelAttributes.Style:=[fsbold];
    re.Lines.Add('IMAGE_OPTIONAL_HEADER');
    re.SelAttributes.Style:=[];
    re.Lines.Add('');
    str:='Magic: '+inttohex(OptionalHeader.Magic,2*sizeof(OptionalHeader.Magic));
    re.Lines.Add(str);
    str:='MajorLinkerVersion: '+inttohex(OptionalHeader.MajorLinkerVersion,
            2*sizeof(OptionalHeader.MajorLinkerVersion));
    re.Lines.Add(str);
    str:='MinorLinkerVersion: '+inttohex(OptionalHeader.MinorLinkerVersion,
            2*sizeof(OptionalHeader.MinorLinkerVersion));
    re.Lines.Add(str);
    str:='SizeOfCode: '+inttohex(OptionalHeader.SizeOfCode,
            2*sizeof(OptionalHeader.SizeOfCode));
    re.Lines.Add(str);
    str:='SizeOfInitializedData: '+inttohex(OptionalHeader.SizeOfInitializedData,
            2*sizeof(OptionalHeader.SizeOfInitializedData));
    re.Lines.Add(str);
    str:='SizeOfUninitializedData: '+inttohex(OptionalHeader.SizeOfUninitializedData,
            2*sizeof(OptionalHeader.SizeOfUninitializedData));
    re.Lines.Add(str);
    str:='AddressOfEntryPoint: '+inttohex(OptionalHeader.AddressOfEntryPoint,
            2*sizeof(OptionalHeader.AddressOfEntryPoint));
    re.Lines.Add(str);
    str:='BaseOfCode: '+inttohex(OptionalHeader.BaseOfCode,
            2*sizeof(OptionalHeader.BaseOfCode));
    re.Lines.Add(str);
    str:='BaseOfData: '+inttohex(OptionalHeader.BaseOfData,
            2*sizeof(OptionalHeader.BaseOfData));
    re.Lines.Add(str);
    str:='ImageBase: '+inttohex(OptionalHeader.ImageBase,
            2*sizeof(OptionalHeader.ImageBase));
    re.Lines.Add(str);
    str:='SectionAlignment: '+inttohex(OptionalHeader.SectionAlignment,
            2*sizeof(OptionalHeader.SectionAlignment));
    re.Lines.Add(str);
    str:='FileAlignment: '+inttohex(OptionalHeader.FileAlignment,
            2*sizeof(OptionalHeader.FileAlignment));
    re.Lines.Add(str);
    str:='MajorOperatingSystemVersion: '+inttohex(OptionalHeader.MajorOperatingSystemVersion,
                   2*sizeof(OptionalHeader.MajorOperatingSystemVersion));
    re.Lines.Add(str);
    str:='MinorOperatingSystemVersion: '+inttohex(OptionalHeader.MinorOperatingSystemVersion,
                2*sizeof(OptionalHeader.MinorOperatingSystemVersion));
    re.Lines.Add(str);
    str:='MajorImageVersion: '+inttohex(OptionalHeader.MajorImageVersion,
            2*sizeof(OptionalHeader.MajorImageVersion));
    re.Lines.Add(str);
    str:='MinorImageVersion: '+inttohex(OptionalHeader.MinorImageVersion,
          2*sizeof(OptionalHeader.MinorImageVersion));
    re.Lines.Add(str);
    str:='MajorSubsystemVersion: '+inttohex(OptionalHeader.MajorSubsystemVersion,
          2*sizeof(OptionalHeader.MajorSubsystemVersion));
    re.Lines.Add(str);
    str:='MinorSubsystemVersion: '+inttohex(OptionalHeader.MinorSubsystemVersion,
          2*sizeof(OptionalHeader.MinorSubsystemVersion));
    re.Lines.Add(str);
    str:='Win32VersionValue: '+inttohex(OptionalHeader.Win32VersionValue,
          2*sizeof(OptionalHeader.Win32VersionValue));
    re.Lines.Add(str);
    str:='SizeOfImage: '+inttohex(OptionalHeader.SizeOfImage,
          2*sizeof(OptionalHeader.SizeOfImage));
    re.Lines.Add(str);
    str:='SizeOfHeaders: '+inttohex(OptionalHeader.SizeOfHeaders,
          2*sizeof(OptionalHeader.SizeOfHeaders));
    re.Lines.Add(str);
    str:='CheckSum: '+inttohex(OptionalHeader.CheckSum,2*sizeof(OptionalHeader.CheckSum))+
         '  RealCheckSum: '+GetRealCheckSum(Value);
    re.Lines.Add(str);
    str:='Subsystem: '+inttohex(OptionalHeader.Subsystem,2*sizeof(OptionalHeader.Subsystem));
    re.Lines.Add(str);
    str:='DllCharacteristics: '+inttohex(OptionalHeader.DllCharacteristics,
         2*sizeof(OptionalHeader.DllCharacteristics));
    re.Lines.Add(str);
    str:='SizeOfStackReserve: '+inttohex(OptionalHeader.SizeOfStackReserve,
         2*sizeof(OptionalHeader.SizeOfStackReserve));
    re.Lines.Add(str);
    str:='SizeOfStackCommit: '+inttohex(OptionalHeader.SizeOfStackCommit,
         2*sizeof(OptionalHeader.SizeOfStackCommit));
    re.Lines.Add(str);
    str:='SizeOfHeapReserve: '+inttohex(OptionalHeader.SizeOfHeapReserve,
         2*sizeof(OptionalHeader.SizeOfHeapReserve));
    re.Lines.Add(str);
    str:='SizeOfHeapCommit: '+inttohex(OptionalHeader.SizeOfHeapCommit,
         2*sizeof(OptionalHeader.SizeOfHeapCommit));
    re.Lines.Add(str);
    str:='LoaderFlags: '+inttohex(OptionalHeader.LoaderFlags,
         2*sizeof(OptionalHeader.LoaderFlags));
    re.Lines.Add(str);
    str:='NumberOfRvaAndSizes: '+inttohex(OptionalHeader.NumberOfRvaAndSizes,
         2*sizeof(OptionalHeader.NumberOfRvaAndSizes));
    re.Lines.Add(str);
    for i:=0 to IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1 do begin
     str:='DataDirectory [ '+GetImageDirectory(I)+' ] VirtualAddress: '+
          inttohex(OptionalHeader.DataDirectory[i].VirtualAddress,
                   2*sizeof(OptionalHeader.DataDirectory[i].VirtualAddress))+
                   ' Size: '+inttohex(OptionalHeader.DataDirectory[i].Size,
                   2*sizeof(OptionalHeader.DataDirectory[i].Size));
     re.Lines.Add(str);
    end;
  end;

  procedure FillSection(StartAddress: DWord; NumSection: Word);
  var
    i: Word;
    SecHeader: TImageSectionHeader;
    P: Pchar;
    str: string;
    tmps: string;
  begin
    for i:=0 to NumSection-1 do begin
       MOve(Pointer(StartAddress)^,SecHeader,Sizeof(TImageSectionHeader));
       StartAddress:=StartAddress+Sizeof(TImageSectionHeader);
       re.Lines.Add('');
       re.SelAttributes.Style:=[fsbold];
       if SecHeader.Name[7]=0 then begin
        P:=Pchar(@SecHeader.Name);
        re.Lines.Add('Section ['+P+']');
       end else begin
        setlength(tmps,length(SecHeader.Name));
        StrCopy(Pchar(tmps),@SecHeader.Name);
        re.Lines.Add('Section ['+tmps+']');
       end;

       re.SelAttributes.Style:=[];
       re.Lines.Add('');
       str:='Misc PhysicalAddress: '+inttohex(SecHeader.Misc.PhysicalAddress,
         2*sizeof(SecHeader.Misc.PhysicalAddress));
       str:=str+' VirtualSize: '+inttohex(SecHeader.Misc.VirtualSize,
         2*sizeof(SecHeader.Misc.VirtualSize));
       re.Lines.Add(str);
       str:='VirtualAddress: '+inttohex(SecHeader.VirtualAddress,
         2*sizeof(SecHeader.VirtualAddress));
       re.Lines.Add(str);
       str:='SizeOfRawData: '+inttohex(SecHeader.SizeOfRawData,
         2*sizeof(SecHeader.SizeOfRawData));
       re.Lines.Add(str);
       str:='PointerToRawData: '+inttohex(SecHeader.PointerToRawData,
         2*sizeof(SecHeader.PointerToRawData));
       re.Lines.Add(str);
       str:='PointerToRelocations: '+inttohex(SecHeader.PointerToRelocations,
         2*sizeof(SecHeader.PointerToRelocations));
       re.Lines.Add(str);
       str:='PointerToLinenumbers: '+inttohex(SecHeader.PointerToLinenumbers,
         2*sizeof(SecHeader.PointerToLinenumbers));
       re.Lines.Add(str);
       str:='NumberOfRelocations: '+inttohex(SecHeader.NumberOfRelocations,
         2*sizeof(SecHeader.NumberOfRelocations));
       re.Lines.Add(str);
       str:='NumberOfLinenumbers: '+inttohex(SecHeader.NumberOfLinenumbers,
         2*sizeof(SecHeader.NumberOfLinenumbers));
       re.Lines.Add(str);
       str:='Characteristics: '+inttohex(SecHeader.Characteristics,
         2*sizeof(SecHeader.Characteristics));
       re.Lines.Add(str);

    end;
  end;


  procedure FillDataDirectory(mHandle: DWord; OptionalHeader: TImageOptionalHeader;
                              SectionAddress: DWord; NumberOfSections: Word);

    procedure FillDirectoryExport(Addr: DWord; Size: Dword);
    var
      IED: PImageExportDirectory;
      str: string;
      P: Pchar;
      nameFa:DWord;
      i: DWord;
      stfuninc: DWord;
      nameAddr: DWord;
      ordAddr: Dword;
      listNames: TStringList;
      ListOrd: TList;
      ordvalue: Word;
      tmps: string;
      nameValue: string;
      Delta: Integer;
    begin
       IED:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
       str:='Characteristics: '+inttohex(IED.Characteristics,
         2*sizeof(IED.Characteristics));
       re.Lines.Add(str);
       str:='TimeDateStamp: '+inttohex(IED.TimeDateStamp,2*sizeof(IED.TimeDateStamp));
       re.Lines.Add(str);
       str:='MajorVersion: '+inttohex(IED.MajorVersion, 2*sizeof(IED.MajorVersion));
       re.Lines.Add(str);
       str:='MinorVersion: '+inttohex(IED.MinorVersion,2*sizeof(IED.MinorVersion));
       re.Lines.Add(str);
       namefa:=mHandle+IED.Name+Dword(delta);
       P:=Pchar(nameFa);
       str:='Name: '+strPas(P);
       nameValue:=strPas(P);
       nameValue:=Copy(nameValue,1,Length(nameValue)-4);
       re.Lines.Add(str);
       str:='Base: '+inttohex(IED.Base,2*sizeof(IED.Base));
       re.Lines.Add(str);
       str:='NumberOfFunctions: '+inttohex(IED.NumberOfFunctions,2*sizeof(IED.NumberOfFunctions));
       re.Lines.Add(str);
       str:='NumberOfNames: '+inttohex(IED.NumberOfNames,2*sizeof(IED.NumberOfNames));
       re.Lines.Add(str);

       listNames:=TStringList.Create;
       ListOrd:=TList.Create;
       try
         nameAddr:=nameFa+DWord(Length(strPas(P)))+1;
         if IED.NumberOfNames>0 then
          for i:=0 to IED.NumberOfNames-1 do begin
           listNames.Add(Pchar(nameAddr));
           nameAddr:=nameAddr+DWord(length(strPas(Pchar(nameAddr))))+1;
          end;

         ordAddr:=mHandle+DWord(IED.AddressOfNameOrdinals)+Dword(delta);
         if IED.NumberOfNames>0 then
          for i:=0 to IED.NumberOfNames-1 do begin
           ordvalue:=DWord(Pointer(ordAddr)^);
           ListOrd.Add(Pointer(ordvalue));
           ordAddr:=ordAddr+sizeof(Word);
          end;

         stfuninc:=DWord(IED.AddressOfFunctions)+DWord(delta);
         if IED.NumberOfFunctions>0 then begin
          str:='Functions: ';
          re.Lines.Add(str);
          str:=#9+'EntryPoint'+#9+'Ordinal'+#9+'Name';
          re.Lines.Add(str);

          for i:=0 to IED.NumberOfFunctions-1 do begin
           if ListOrd.IndexOf(Pointer(i))<>-1 then
            tmps:=listNames.Strings[ListOrd.IndexOf(Pointer(i))]
           else tmps:=nameValue+'.'+inttostr(IED.Base+i);
           str:=#9+inttohex(stfuninc,8)+#9+inttostr(IED.Base+i)+#9+tmps;
           stfuninc:=stfuninc+sizeof(DWord);
           re.Lines.Add(str);
          end;
         end;
       finally
        ListOrd.Free;
        listNames.Free;
       end;

    end;

    procedure FillDirectoryImport(Addr: DWord; Size: Dword);
    var
      IID: PIMAGE_IMPORT_DESCRIPTOR;
      Delta: Integer;
      str: string;
      nameFa: DWord;
      thunk: DWord;
      pOrdinalName: PIMAGE_IMPORT_BY_NAME;
      nameFun: Pchar;
      oldOrd: Word;
      Funstr: string;
      Flag: Integer;
    begin
      Flag:=0;
      IID:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
      while (true) do begin
       if IID.Name=0 then begin
        break;
       end else begin
        if Flag>=1 then
         re.Lines.Add('');
       end;
       inc(Flag);
       str:='Characteristics: '+inttohex(IID.Characteristics,2*sizeof(IID.Characteristics));
       re.Lines.Add(str);
       str:='TimeDateStamp: '+inttohex(IID.TimeDateStamp,2*sizeof(IID.TimeDateStamp));
       re.Lines.Add(str);
       str:='ForwarderChain: '+inttohex(IID.ForwarderChain,2*sizeof(IID.ForwarderChain));
       re.Lines.Add(str);
       nameFa:=mHandle+IID.Name+Dword(delta);
       str:='Name: '+strPas(Pchar(nameFa));
       re.Lines.Add(str);
       if IID.Characteristics=0 then begin
        thunk:=mHandle+IID.FirstThunk+DWord(delta);// Borland
       end else begin
        thunk:=mHandle+IID.Characteristics+DWord(delta);
       end;
       str:='FirstThunk: '+inttohex(thunk-mHandle,2*sizeof(IID.FirstThunk));
       re.Lines.Add(str);
       str:='Functions: ';
       re.Lines.Add(str);
       str:=#9+'Hint/Ord'+#9+'Name';
       re.Lines.Add(str);
       while (true) do begin
         pOrdinalName:=PIMAGE_IMPORT_BY_NAME(PIMAGE_THUNK_DATA(thunk).NameTable);
         oldOrd:=Word(pOrdinalName);
         if pOrdinalName=nil then break;
         pOrdinalName:=PIMAGE_IMPORT_BY_NAME(mHandle+Dword(pOrdinalName)+DWord(Delta));
         if not IsBadCodePtr(pOrdinalName) then begin
          nameFun:=Pchar(DWord(pOrdinalName)+sizeof(pOrdinalName.Hint));
          str:=#9+inttohex(pOrdinalName.Hint,2*sizeof(Word))+#9+strPas(nameFun);
          re.Lines.Add(str);
         end else begin
          nameFun:=Pchar(nameFa);
          Funstr:=strPas(nameFun);
          Funstr:=Copy(Funstr,1,Length(Funstr)-4);
          Funstr:=Funstr+'.'+inttostr(oldOrd);
          str:=#9+inttohex(oldOrd,4)+#9+Funstr;
          re.Lines.Add(str);
         end;
         thunk:=thunk+sizeof(IMAGE_THUNK_DATA);
       end;
       Dword(IID):=DWord(IID)+sizeof(IMAGE_IMPORT_DESCRIPTOR);
//       inc(IID);
      end;
    end;

    procedure FillDirectoryResource(Addr: DWord; Size: Dword);
    var
      IRD: PIMAGE_RESOURCE_DIRECTORY;
      Delta: Integer;
    begin
      IRD:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
      if not IsBadCodePtr(IRD) then
       DumpResourceDirectory(IRD,DWord(IRD),0,mHandle);
    end;

    procedure FillDirectoryBASERELOC(Addr: DWord; Size: Dword);
    var
      IBR: PIMAGE_BASE_RELOCATION;
      Delta: Integer;
      cEntries: Integer;
      str: string;
      relocType: Word;
      pEntry: PWord;
      i: Integer;
      typestr: string;
    const
      SzRelocTypes :array [0..7] of string =('ABSOLUTE','HIGH','LOW',
                                              'HIGHLOW','HIGHADJ','MIPS_JMPADDR',
                                              'I860_BRADDR','I860_SPLIT');

    begin
      IBR:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
      while IBR.SizeOfBlock<>0 do begin
        if IsBadCodePtr(IBR) then exit;
        cEntries:=(IBR.SizeOfBlock-sizeof(IMAGE_BASE_RELOCATION))div sizeof(WORD);
        pEntry:= PWORD(DWord(IBR)+sizeof(IMAGE_BASE_RELOCATION));
        str:='VirtualAddress: '+inttohex(IBR.VirtualAddress,8)+'  ';
        str:=str+'SizeOfBlock: '+inttohex(IBR.SizeOfBlock,8);
        re.Lines.Add(str);
        for i:=0 to cEntries-1 do begin
          relocType:= (pEntry^ and $F000) shr 12;
          if relocType<8 then typestr:=SzRelocTypes[relocType]
          else typestr:='Unknown';
          str:=#9+inttohex((pEntry^ and $0FFF)+IBR.VirtualAddress,8)+'  ';
          str:=str+typestr;
          re.Lines.Add(str);
          inc(pEntry);
        end;
        IBR:=PIMAGE_BASE_RELOCATION(DWord(IBR)+IBR.SizeOfBlock);
      end;
    end;

    procedure FillDirectoryDEBUG(Addr: DWord; Size: Dword);
    var
      PNtHeader: PImageNtHeaders;
      pDOSHead: PImageDosHeader;
      debugDir: PImageDebugDirectory;
      header: PImageSectionHeader;
      i,cDebugFormats: Integer;
      offsetInto_rdata: DWord;
      va_debug_dir: DWord;
      szDebugFormat: string;
      str: string;
    const
      SzDebugFormats :array [0..6] of string =('UNKNOWN/BORLAND',
                                             'COFF','CODEVIEW','FPO',
                                             'MISC','EXCEPTION','FIXUP');
    begin
      pDOSHead:=Pointer(mHandle);
      PNtHeader:=Pointer(mHandle+Dword(pDOSHead._lfanew));
      va_debug_dir:= pNTHeader.OptionalHeader.
                     Datadirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].VirtualAddress;
      if GetSectionHdr('.debug',header,pNTHeader) then begin
        if header.VirtualAddress=va_debug_dir then begin
          debugDir:= PImageDebugDirectory(header.PointerToRawData+mhandle);
          cDebugFormats:= pNTHeader.OptionalHeader.
                          DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].Size;

        end;
      end else begin
//        if not GetSectionHdr('.rdata',header,pNTHeader) then exit;
        cDebugFormats:= pNTHeader.OptionalHeader.
			DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].Size div
   			sizeof(IMAGE_DEBUG_DIRECTORY);
        if cDebugFormats=0 then exit;
        offsetInto_rdata:= va_debug_dir - header.VirtualAddress;
	debugDir:= PImageDebugDirectory(mhandle+header.PointerToRawData+offsetInto_rdata);
      end;
      str:='Type'+#9+'Size'+#9+'Address'+#9+'FilePtr'+#9+'Charactr'+#9+'TimeData'+
           #9+'Version';
      re.Lines.Add(str);
      for i:=0 to cDebugFormats-1 do begin
        if debugDir._Type<7 then
         szDebugFormat:= SzDebugFormats[debugDir._Type]
        else szDebugFormat:='UNKNOWN';
        str:='';
        str:=szDebugFormat+'  '+#9;
        str:=str+inttohex(debugDir.SizeOfData,8)+'  '+#9;
        str:=str+inttohex(debugDir.AddressOfRawData,8)+'  '+#9;
        str:=str+inttohex(debugDir.PointerToRawData,8)+'  '+#9;
        str:=str+inttohex(debugDir.Characteristics,8)+'  '+#9;
        str:=str+inttohex(debugDir.TimeDateStamp,8)+'  '+#9;
        str:=str+inttostr(debugDir.MajorVersion)+'.'+inttostr(debugDir.MinorVersion);
        re.Lines.Add(str);
        inc(debugDir);
      end;

      
    end;

    procedure FillDirectoryTLS(Addr: DWord; Size: Dword);
    var
      PITDE: PIMAGE_TLS_DIRECTORY_ENTRY;
      Delta: Integer;
      str: string;
    begin
      PITDE:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
      if IsBadCodePtr(PITDE) then exit;
      str:='StartData: '+inttohex(PITDE.StartData,8);
      re.Lines.Add(str);
      str:='EndData: '+inttohex(PITDE.EndData,8);
      re.Lines.Add(str);
      str:='Index: '+inttohex(PITDE.Index,8);
      re.Lines.Add(str);
      str:='CallBackTable: '+inttohex(PITDE.CallBackTable,8);
      re.Lines.Add(str);

    end;

    procedure FillDirectoryLoadConfig(Addr: DWord; Size: Dword);
    var
      PILCD: PImageLoadConfigDirectory;
      Delta: Integer;
      str: string;
    begin
      PILCD:=GetPointer(mHandle,Addr,SectionAddress,NumberOfSections,Delta);
      if IsBadCodePtr(PILCD) then exit;
      str:='Characteristics: '+inttohex(PILCD.Characteristics,8);
      re.Lines.Add(str);
      str:='TimeDateStamp: '+inttohex(PILCD.TimeDateStamp,8);
      re.Lines.Add(str);
      str:='MajorVersion: '+inttohex(PILCD.MajorVersion,8);
      re.Lines.Add(str);
      str:='MinorVersion: '+inttohex(PILCD.MinorVersion,8);
      re.Lines.Add(str);
      str:='GlobalFlagsClear: '+inttohex(PILCD.GlobalFlagsClear,8);
      re.Lines.Add(str);
      str:='GlobalFlagsSet: '+inttohex(PILCD.GlobalFlagsSet,8);
      re.Lines.Add(str);
      str:='CriticalSectionDefaultTimeout: '+inttohex(PILCD.CriticalSectionDefaultTimeout,8);
      re.Lines.Add(str);
      str:='DeCommitFreeBlockThreshold: '+inttohex(PILCD.DeCommitFreeBlockThreshold,8);
      re.Lines.Add(str);
      str:='DeCommitTotalFreeThreshold: '+inttohex(PILCD.DeCommitTotalFreeThreshold,8);
      re.Lines.Add(str);
      str:='MaximumAllocationSize: '+inttohex(PILCD.MaximumAllocationSize,8);
      re.Lines.Add(str);
      str:='VirtualMemoryThreshold: '+inttohex(PILCD.VirtualMemoryThreshold,8);
      re.Lines.Add(str);
      str:='ProcessHeapFlags: '+inttohex(PILCD.ProcessHeapFlags,8);
      re.Lines.Add(str);
      str:='ProcessAffinityMask: '+inttohex(PILCD.ProcessAffinityMask,8);
      re.Lines.Add(str);
    end;

    procedure FillDirectoryIAT(Addr: DWord; Size: Dword);
    begin

    end;


  var
    i: Integer;
  begin
    for i:=0 to IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1 do begin
      if (OptionalHeader.DataDirectory[i].VirtualAddress<>0)and
         (OptionalHeader.DataDirectory[i].Size<>0) then begin
         re.Lines.Add('');
         re.SelAttributes.Style:=[fsbold];
         re.Lines.Add(GetImageDirectory(I));
         re.SelAttributes.Style:=[];
         re.Lines.Add('');
         case I of

{            IMAGE_DIRECTORY_ENTRY_EXPORT:
               FillDirectoryExport(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);}
            IMAGE_DIRECTORY_ENTRY_IMPORT:
               FillDirectoryImport(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);
{            IMAGE_DIRECTORY_ENTRY_RESOURCE:
               FillDirectoryResource(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);
            IMAGE_DIRECTORY_ENTRY_EXCEPTION:; //-
            IMAGE_DIRECTORY_ENTRY_SECURITY:; //-
            IMAGE_DIRECTORY_ENTRY_BASERELOC:
               FillDirectoryBASERELOC(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);}
            IMAGE_DIRECTORY_ENTRY_DEBUG:
               FillDirectoryDEBUG(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);
            IMAGE_DIRECTORY_ENTRY_COPYRIGHT:;//-
            IMAGE_DIRECTORY_ENTRY_GLOBALPTR:;//-
            IMAGE_DIRECTORY_ENTRY_TLS:
               FillDirectoryTLS(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);

            IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG:
               FillDirectoryLoadConfig(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);

            IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT:; //-
            IMAGE_DIRECTORY_ENTRY_IAT:
               FillDirectoryIAT(OptionalHeader.DataDirectory[i].VirtualAddress,
                                   OptionalHeader.DataDirectory[i].Size);


         end;
      end;
    end;
  end;

var
 pDOSHead: TImageDosHeader;
 pPEHeader: TImageNtHeaders;
 peHeaderAddr,SectionAddress: Dword;
 mHandle: DWord;
begin
  Screen.Cursor:=crHourGlass;
  try
   try
    if not CreateFileMap(Value) then exit;
    FileName:=Value;
//    Caption:=CaptionEx+' - '+FileName;
    mHandle:=Thandle(FileMapView);
    if mHandle=0 then exit;
    FillTreeView(mHandle);
    exit;

    Move(Pointer(mHandle)^,pDOSHead,sizeof(TImageDosHeader));
    if pDOSHead.e_magic<>IMAGE_DOS_SIGNATURE then exit;

    re.Lines.Clear;
    re.Lines.Add(FileName);
//    re.Lines.Add('Base Loading Address: '+inttoHex(mHandle,8));

    FillImageDosHeader(pDOSHead);

    peHeaderAddr:=mHandle+Dword(pDOSHead._lfanew);
    Move(Pointer(peHeaderAddr)^,pPEHeader,sizeof(TImageNtHeaders));
    if pPEHeader.Signature<>IMAGE_NT_SIGNATURE  then exit;

    FillImageNtHeaders(Dword(pDOSHead._lfanew),pPEHeader);

    FillImageFileHeader(pPEHeader.FileHeader);

    FillImageOptionalHeader(pPEHeader.OptionalHeader);

    SectionAddress:=peHeaderAddr+sizeof(TImageNtHeaders);
    FillSection(SectionAddress,pPEHeader.FileHeader.NumberOfSections);

    FillDataDirectory(mHandle,pPEHeader.OptionalHeader,
                      SectionAddress,pPEHeader.FileHeader.NumberOfSections);

{     IMAGE_EXPORT_DIRECTORY

      IMAGE_DIRECTORY_ENTRY_EXPORT}


   except
    on E: Exception do begin
     MessageBox(Application.Handle,Pchar(E.Message),nil,MB_ICONERROR);
    end;
   end;
  finally
   FreeFileMap;
   Screen.Cursor:=crDefault;
  end;
end;


function TfmFileInfo.GetResourceTypeFromId(TypeID: Word): string;
begin
     Result:='Unknown ('+inttostr(TypeID)+')';
     case TypeID of
        $2000: Result:='NEWRESOURCE'; // RT_NEWRESOURCE
        $7FFF: Result:='ERROR'; // RT_ERROR
        1: Result:='CURSOR'; // RT_CURSOR
        2: Result:='BITMAP'; // RT_BITMAP
        3: Result:='ICON'; // RT_ICON
        4: Result:='MENU'; // RT_MENU
        5: Result:='DIALOG'; // RT_DIALOG
        6: Result:='STRING'; // RT_STRING
        7: Result:='FONTDIR'; // RT_FONTDIR
        8: Result:='FONT'; // RT_FONT
        9: Result:='ACCELERATORS'; // RT_ACCELERATORS
        10: Result:='RCDATA'; // RT_RCDATA
        11: Result:='MESSAGETABLE'; // RT_MESSAGETABLE
        12: Result:='GROUP CURSOR'; // RT_GROUP_CURSOR
        14: Result:='GROUP ICON'; // RT_GROUP_ICON
        16: Result:='VERSION'; // RT_VERSION
        2 or $2000: Result:='NEWBITMAP'; // RT_BITMAP|RT_NEWRESOURCE
        4 or $2000: Result:='NEWMENU'; // RT_MENU|RT_NEWRESOURCE
        5 or $2000: Result:='NEWDIALOG'; // RT_DIALOG|RT_NEWRESOURCE
     end;
end;

function TfmFileInfo.GetResourceNameFromId(ResourceBase: DWord;
                      resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY): string;
var
  PDirStr: PIMAGE_RESOURCE_DIR_STRING_U;
begin
  PDirStr := PIMAGE_RESOURCE_DIR_STRING_U(StripHighBit(resDirEntry.Name)+ResourceBase);
  Result:=WideCharToStr(@PDirStr.NameString, PDirStr.Length);
end;

function TfmFileInfo.GetNameResource(resType: DWord; ResourceBase: DWord;
                     resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
                     level: Integer): string;
begin
  if resDirEntry=nil then begin
   result:=GetResourceTypeFromId(resType);
   exit;
  end;

  if not HighBitSet(resDirEntry.Name) and  (resDirEntry.Name <= 16)and (level<1) then
  begin
    Result := GetResourceTypeFromId(resType);
    Exit;
  end;

  if HighBitSet(resDirEntry.Name) then
  begin
    Result :=GetResourceNameFromId(ResourceBase,resDirEntry);
    Exit;
  end;
  Result := Format('%d', [resDirEntry.Name]);
end;


procedure TfmFileInfo.DumpResourceDirectory(resDir: PIMAGE_RESOURCE_DIRECTORY;
                                            resourceBase: DWORD;
                                            level: DWORd;
                                            mHandle: DWord);

   procedure DumpPlus(resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
                      str,plus,oldstr: string);
   var
     resType: DWord;
     resDataEntry: PIMAGE_RESOURCE_DATA_ENTRY;
   begin
        resType:=resDirEntry.Name;
        str:=oldstr;
        str:=str+'Type: '+GetNameResource(resType,resourceBase,resDirEntry,level)+plus;
        str:=str+'Char: '+inttohex(resDir.Characteristics,8)+plus;
        str:=str+'TimeDate: '+inttohex(resDir.TimeDateStamp,8)+plus;
        str:=str+'Ver: '+inttostr(resDir.MajorVersion)+'.'+inttostr(resDir.MinorVersion)+plus;
//        str:=str+'Named: '+inttohex(resDir.NumberOfNamedEntries,4)+plus;
//        str:=str+'Id: '+inttohex(resDir.NumberOfIdEntries,4)+plus;
        str:=str+'Next: '+inttohex(StripHighBit(resDirEntry.OffsetToData),8);
        re.Lines.Add(str);
        if HighBitSet(resDirEntry.OffsetToData) then begin
          DumpResourceDirectory(Pointer(resourceBase+StripHighBit(resDirEntry.OffsetToData)),
                                resourceBase,
                                Level+1,
                                mHandle);
        end else begin
         resDataEntry:=Pointer(resourceBase+StripHighBit(resDirEntry.OffsetToData));
         str:=oldstr+#9+'OffsetToData: '+inttohex(resDataEntry.OffsetToData,8);
         re.Lines.Add(str);
         str:=oldstr+#9+'Size: '+inttohex(resDataEntry.Size,8);
         re.Lines.Add(str);
         str:=oldstr+#9+'CodePage: '+inttohex(resDataEntry.CodePage,8);
         re.Lines.Add(str);
         str:=oldstr+#9+'Reserved: '+inttohex(resDataEntry.Reserved,8);
         re.Lines.Add(str);
         re.Lines.Add('');
        end;
   end;

var
   resDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
   i: DWord;
   str: string;
   oldstr: string;
   plus: string;
begin
     str:='';
     plus:='  ';
     if level>0 then
     for i:=0 to level do str:=str+#9;
     oldstr:=str;

     resDirEntry:=PIMAGE_RESOURCE_DIRECTORY_ENTRY(resDir);
     inc(PIMAGE_RESOURCE_DIRECTORY(resDirEntry));

     re.Lines.Add('');
     str:=str+'[ Named: '+inttohex(resDir.NumberOfNamedEntries,4)+plus;
     str:=str+'Id: '+inttohex(resDir.NumberOfIdEntries,4)+' ]';
     re.Lines.Add(str);

     if resDir.NumberOfNamedEntries>0 then
      for i:=0 to resDir.NumberOfNamedEntries-1 do begin
        DumpPlus(resDirEntry,str,plus,oldstr);
        inc(resDirEntry);
      end;

     if resDir.NumberOfIdEntries>0 then
      for i:=0 to resDir.NumberOfIdEntries-1 do begin
        DumpPlus(resDirEntry,str,plus,oldstr);
        inc(resDirEntry);
      end;
end;

procedure TfmFileInfo.FormDestroy(Sender: TObject);
begin
  Mems.Free;
  sg.Free;
  sgNew.Free;
  sgHex.Free;
  imResData.Free;
  pnResDataTop.Free;
  pnResDataClient.Free;

  ClearTreeView;
end;

function TfmFileInfo.GetSectionHdr(const SectionName: string;
                                   var Header: PImageSectionHeader;
                                   FNTHeader: PImageNtHeaders): Boolean;
var
  I: Integer;
  P: PChar;
begin
  Header := PImageSectionHeader(FNTHeader);
  Inc(PIMAGENTHEADERS(Header));
  Result := True;
  for I := 0 to FNTHeader.FileHeader.NumberOfSections - 1 do
  begin
  p:=@Header.Name;
    if Strlicomp(P, PChar(SectionName), IMAGE_SIZEOF_SHORT_NAME) = 0 then Exit;
    Inc(Header);
  end;
  Result := False;
end;

function TfmFileInfo.GetImageDirectory(I: Integer): String;
  begin
   Result:='DataDirectory ('+inttostr(I)+')';
   case I of
    IMAGE_DIRECTORY_ENTRY_EXPORT:      Result:='Export';
    IMAGE_DIRECTORY_ENTRY_IMPORT:      Result:='Import';
    IMAGE_DIRECTORY_ENTRY_RESOURCE:    Result:='Resource';
    IMAGE_DIRECTORY_ENTRY_EXCEPTION:   Result:='Exception';
    IMAGE_DIRECTORY_ENTRY_SECURITY:    Result:='Security';
    IMAGE_DIRECTORY_ENTRY_BASERELOC:   Result:='Basereloc';
    IMAGE_DIRECTORY_ENTRY_DEBUG:       Result:='Debug';
    IMAGE_DIRECTORY_ENTRY_COPYRIGHT:   Result:='Copyright';
    IMAGE_DIRECTORY_ENTRY_GLOBALPTR:   Result:='Globalptr';
    IMAGE_DIRECTORY_ENTRY_TLS:         Result:='Tls';
    IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG: Result:='Load Config';
    IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT:Result:='Bound Import';
    IMAGE_DIRECTORY_ENTRY_IAT:         Result:='Iat';
    13: Result:='Delay Import';
    14: Result:='Com Description';
   end;
end;

function TfmFileInfo.GetPointer(mHandle: DWord; Addr: DWord; StartAddress: DWord;
                   NumSection: Word; var Delta: Integer):Pointer;
  var
    i: Word;
    SecHeader: TImageSectionHeader;
  begin
    Result:=Pointer(mHandle+Addr);
    Delta:=0;
    for i:=0 to NumSection-1 do begin
       MOve(Pointer(StartAddress)^,SecHeader,Sizeof(TImageSectionHeader));
       StartAddress:=StartAddress+Sizeof(TImageSectionHeader);
       if (SecHeader.VirtualAddress<=Addr)and
          (SecHeader.VirtualAddress+SecHeader.SizeOfRawData>Addr) then begin
         Result:=Pointer(mHandle+Addr-SecHeader.VirtualAddress+SecHeader.PointerToRawData);
         Delta:=-SecHeader.VirtualAddress+SecHeader.PointerToRawData;
         exit;
       end;
    end;

end;

procedure TfmFileInfo.ClearTreeView;

  procedure DestroyResource(P: PInfResource);
  begin
    Dispose(P.ResDir);
    case P.TypeRes of
      rtlData: begin
        Dispose(PIMAGE_RESOURCE_DATA_ENTRY(P.ResData));
      end;
      rtlDir: begin
{       if P.Level>0 then begin
        for i:=0 to P.ResList.Count-1 do begin
         PInfo:=P.ResList.Items[i];
         RDataE:=PInfo.ResData;
         if RDataE<>nil then begin
          PMem:=PInfo.ResDataMem;
          if PMem<>nil then FreeMem(PMem,RDataE.Size);
          DIspose(RDataE);
         end;
        end;
        P.ResList.Free;
       end else begin}
        P.ResList.Free;
//       end;

      end;
    end;
    Dispose(P);
  end;

var
  i,j: integer;
  P: PinfNode;
begin
  for i:=0 to tv.Items.Count-1 do begin
    P:=tv.Items[i].Data;
    case P.tpNode of
      tpnFileName: begin
        Dispose(PInfFileName(P.PInfo));
      end;
      tpnDosHeader: begin
        Dispose(PInfDosHeader(P.PInfo));
      end;
      tpnNtHeader: begin
        Dispose(PInfNtHeader(P.PInfo));
      end;
      tpnFileHeader: begin
        Dispose(PInfFileHeader(P.PInfo));
      end;
      tpnOptionalHeader: begin
        Dispose(PInfOptionalHeader(P.PInfo));
      end;
      tpnSections: begin
        PInfListSections(P.PInfo).List.Free;
        Dispose(PInfListSections(P.PInfo));
      end;
      tpnSectionHeader: begin
        Dispose(PInfSectionHeader(P.PInfo));
      end;
      tpnExports: begin
        Dispose(PInfListExports(P.PInfo).IED);
        for j:=0 to PInfListExports(P.PInfo).List.Count-1 do begin
          Dispose(PInfExport(PInfListExports(P.PInfo).List.Items[j]));
        end;
        PInfListExports(P.PInfo).List.Free;
        Dispose(PInfListExports(P.PInfo));
      end;
      tpnExport: begin
//        Dispose(PInfExport(P.PInfo));
      end;
      tpnImports: begin
        PInfListImports(P.PInfo).List.Free;
        Dispose(PInfListImports(P.PInfo));
      end;
      tpnImport: begin
        Dispose(PInfImport(P.PInfo).PID);
        for j:=0 to PInfImport(P.PInfo).List.Count-1 do begin
          Dispose(PInfImportName(PInfImport(P.PInfo).List.Items[j]));
        end;
        PInfImport(P.PInfo).List.Free;
        Dispose(PInfImport(P.PInfo));
      end;
      tpnResources: begin
        PInfListResources(P.PInfo).List.Free;
        Dispose(PInfListResources(P.PInfo));
      end;
      tpnResource: begin
        DestroyResource(PInfResource(P.PInfo));
      end;
      tpnException: begin
        Dispose(PInfException(P.PInfo));
      end;
      tpnSecurity: begin
        Dispose(PInfSecurity(P.PInfo));
      end;
      tpnBaseRelocs: begin
        PInfListBaseRelocs(P.PInfo).List.Free;
        Dispose(PInfListBaseRelocs(P.PInfo));
      end;
      tpnBaseReloc: begin
        Dispose(PInfBaseReloc(P.PInfo).PIB);
        for j:=0 to PInfBaseReloc(P.PInfo).List.Count-1 do begin
          Dispose(PInfBaseReloc(P.PInfo).List.Items[j]);
        end;
        PInfBaseReloc(P.PInfo).List.Free;
        Dispose(PInfBaseReloc(P.PInfo));
      end;
      tpnDebugs: begin
        PInfListDebugs(P.PInfo).List.Free;
        Dispose(PInfListDebugs(P.PInfo));
      end;
      tpnCopyright: begin
        Dispose(PInfCopyright(P.PInfo));
      end;
      tpnGlobalptr: begin
        Dispose(PInfGlobalptr(P.PInfo));
      end;
      tpnTls: begin
        Dispose(PInfTls(P.PInfo));
      end;
      tpnLoadconfig: begin
        Dispose(PInfLoadconfig(P.PInfo));
      end;
      tpnBoundImport: begin
        Dispose(PInfBoundImport(P.PInfo));
      end;
      tpnIat: begin
        Dispose(PInfIat(P.PInfo));
      end;
      tpn13: begin
        Dispose(PInf13(P.PInfo));
      end;
      tpn14: begin
        Dispose(PInf14(P.PInfo));
      end;
      tpn15: begin
        Dispose(PInf15(P.PInfo));
      end;


    end;
    Dispose(P);
  end;
  tv.Items.Clear;
end;

procedure TfmFileInfo.FillTreeView(mHandle: DWord);
var
 DosHeader: TImageDosHeader;
 NtHeader: TImageNtHeaders;
 FileHeader: TImageFileHeader;
 OptionalHeader: TImageOptionalHeader;
 ListSections: TList;

  function AddToTreeView(Text: String; ParentNode: TTreeNode;
                         TypeNode: TtpNode; PInfo: Pointer): TTreeNode;
  var
    P: PInfNode;
  begin
    new(P);
    P.tpNode:=TypeNode;
    P.PInfo:=PInfo;
    Result:=tv.Items.AddChildObject(ParentNode,Text,P);
    Result.Data:=P;
    Result.SelectedIndex:=1;
    Result.ImageIndex:=0;
  end;
  
  function FillFileName(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfFileName;
  begin
    New(PInfo);
    PInfo.FileName:=FileName;
    Result:=AddToTreeView(ExtractFileName(FileName),ParentNode,
                          tpnFileName,PInfo);
  end;

  function FillDosHeader(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfDosHeader;
  begin
    New(PInfo);
    Move(DosHeader,PInfo^,sizeof(TImageDosHeader));
    Result:=AddToTreeView('Dos header',ParentNode,tpnDosHeader,PInfo);
  end;

  function FillNtHeader(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfNtHeader;
  begin
    New(PInfo);
    Move(NtHeader,PInfo^,sizeof(TImageNtHeaders));
    Result:=AddToTreeView('Nt header',ParentNode,tpnNtHeader,PInfo);
  end;

  function FillFileHeader(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfFileHeader;
  begin
    New(PInfo);
    Move(FileHeader,PInfo^,sizeof(TImageFileHeader));
    Result:=AddToTreeView('File header',ParentNode,tpnFileHeader,PInfo);
  end;

  function FillOptionalHeader(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfOptionalHeader;
  begin
    New(PInfo);
    Move(OptionalHeader,PInfo^,sizeof(TImageOptionalHeader));
    Result:=AddToTreeView('Optional header',ParentNode,tpnOptionalHeader,PInfo);
  end;

  function FillSections(ParentNode: TTreeNode): TTreeNode;
  var
    PInfo: PInfListSections;
    PSec: PInfSectionHeader;
    i: DWord;
    StartAddress: DWord;
    NameSection: string;
    P: Pchar;
  begin
    ListSections:=TList.Create;
    New(PInfo);
    PInfo.List:=ListSections;
    Result:=AddToTreeView('Sections',ParentNode,tpnSections,PInfo);
    if FileHeader.NumberOfSections>0 then begin
     StartAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
     for i:=0 to FileHeader.NumberOfSections-1 do begin
       new(PSec);
       ListSections.Add(Psec);
       MOve(Pointer(StartAddress)^,PSec^,Sizeof(TImageSectionHeader));
       if PSec.Name[7]=0 then begin
        P:=Pchar(@PSec.Name);
        NameSection:=strPas(P);
       end else begin
        setlength(NameSection,length(PSec.Name));
        StrCopy(Pchar(NameSection),@PSec^.Name);
       end;

       AddToTreeView(Copy(NameSection,1,8),Result,tpnSectionHeader,PSec);
       StartAddress:=StartAddress+Sizeof(TImageSectionHeader);
     end;
    end;
  end;

  procedure FillDataDirectory(ParentNode: TTreeNode);

    procedure FillDirectoryExport(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfListExports;
      ListExports: TList;
      IED,PImExDir: PImageExportDirectory;
      SectionAddress: DWord;
      NumberOfSections: DWord;
      Delta: Integer;
      namefa: DWord;
      listNames: TStringList;
      ListOrd: TList;
      nameAddr,ordAddr,stfuninc: DWord;
      ordvalue: WOrd;
      i: DWord;
      tmps,nameValue: string;
      PExport: PInfExport;
    begin
      New(PInfo);
      ListExports:=TList.Create;
      PInfo.List:=ListExports;
      AddToTreeView(DataName,ParentNode,tpnExports,PInfo);
      SectionAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
      NumberOfSections:=FileHeader.NumberOfSections;
      IED:=GetPointer(mHandle,VirtualAddress,SectionAddress,NumberOfSections,Delta);
      new(PImExDir);
      MOve(IED^,PImExDir^,Sizeof(TImageExportDirectory));
      PInfo.IED:=PImExDir;
      namefa:=mHandle+IED.Name+Dword(delta);
      nameValue:=strPas(Pchar(namefa));
      nameValue:=Copy(nameValue,1,Length(nameValue)-4);

      listNames:=TStringList.Create;
      ListOrd:=TList.Create;
      try
        nameAddr:=nameFa+DWord(Length(strPas(Pchar(namefa))))+1;
        ordAddr:=mHandle+DWord(IED.AddressOfNameOrdinals)+Dword(delta);
        if IED.NumberOfNames>0 then
         for i:=0 to IED.NumberOfNames-1 do begin
          listNames.Add(Pchar(nameAddr));
          nameAddr:=nameAddr+DWord(length(strPas(Pchar(nameAddr))))+1;
          ordvalue:=DWord(Pointer(ordAddr)^);
          ListOrd.Add(Pointer(ordvalue));
          ordAddr:=ordAddr+sizeof(Word);
         end;

        stfuninc:=DWord(IED.AddressOfFunctions)+DWord(delta);
        if IED.NumberOfFunctions>0 then begin
         for i:=0 to IED.NumberOfFunctions-1 do begin
           if ListOrd.IndexOf(Pointer(i))<>-1 then
            tmps:=listNames.Strings[ListOrd.IndexOf(Pointer(i))]
           else tmps:=nameValue+'.'+inttostr(IED.Base+i);
           New(PExport);
           PExport.EntryPoint:=stfuninc;
           PExport.Ordinal:=IED.Base+i;
           PExport.Name:=tmps;
           ListExports.Add(PExport);
//           AddToTreeView(tmps,prtNode,tpnExport,PExport);
           stfuninc:=stfuninc+sizeof(DWord);
         end;
        end;
      finally
       ListOrd.Free;
       listNames.Free;
      end;
    end;

    procedure FillDirectoryImport(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfListImports;
      IID,PID: PIMAGE_IMPORT_DESCRIPTOR;
      ListImports,ImportList: TList;
      prtNode: TTreeNode;
      Delta: Integer;
      SectionAddress,NumberOfSections:DWord;
      PImport: PInfImport;
      nameFa: DWord;
      thunk: DWord;
      pOrdinalName: PIMAGE_IMPORT_BY_NAME;
      nameFun: Pchar;
      oldOrd: Word;
      PImportName: PInfImportName;
      Funstr: string;
    begin
      New(PInfo);
      ListImports:=TList.Create;
      PInfo.List:=ListImports;
      prtNode:=AddToTreeView(DataName,ParentNode,tpnImports,PInfo);
      SectionAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
      NumberOfSections:=FileHeader.NumberOfSections;
      IID:=GetPointer(mHandle,VirtualAddress,SectionAddress,NumberOfSections,Delta);
      while (true) do begin

       if IID.Name=0 then begin
        break;
       end;
       New(PImport);
       New(PID);
       MOve(IID^,PID^,Sizeof(IMAGE_IMPORT_DESCRIPTOR));
       PImport.PID:=PID;
       ImportList:=TList.Create;
       PImport.List:=ImportList;
       ListImports.Add(PImport);
       nameFa:=mHandle+IID.Name+Dword(delta);
       PImport.Name:=strPas(Pchar(nameFa));
       AddToTreeView(PImport.Name,prtNode,tpnImport,PImport);
       if IID.Characteristics=0 then begin
        thunk:=mHandle+IID.FirstThunk+DWord(delta);// Borland
       end else begin
        thunk:=mHandle+IID.Characteristics+DWord(delta);
       end;
       while (true) do begin
         pOrdinalName:=PIMAGE_IMPORT_BY_NAME(PIMAGE_THUNK_DATA(thunk).NameTable);
         oldOrd:=Word(pOrdinalName);
         if pOrdinalName=nil then break;
         pOrdinalName:=PIMAGE_IMPORT_BY_NAME(mHandle+Dword(pOrdinalName)+DWord(Delta));
         New(PImportName);
         ImportList.Add(PImportName);
         if not IsBadCodePtr(pOrdinalName) then begin
          nameFun:=Pchar(DWord(pOrdinalName)+sizeof(pOrdinalName.Hint));
          PImportName.HintOrd:=pOrdinalName.Hint;
          PImportName.Name:=strPas(nameFun);
         end else begin
          nameFun:=Pchar(nameFa);
          Funstr:=strPas(nameFun);
          Funstr:=Copy(Funstr,1,Length(Funstr)-4);
          Funstr:=Funstr+'.'+inttostr(oldOrd);
          PImportName.HintOrd:=oldOrd;
          PImportName.Name:=Funstr;
         end;
         thunk:=thunk+sizeof(IMAGE_THUNK_DATA);
       end;
       Dword(IID):=DWord(IID)+sizeof(IMAGE_IMPORT_DESCRIPTOR);
      end;
    end;

    procedure FillDirectoryResource(DataName: String; VirtualAddress,Size: DWord);
    var
     Delta: Integer;
     FirstChildDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;

      procedure DumpResource(Node: TTreeNode; ListResources: TList;
                             resDir,resDirParent: PIMAGE_RESOURCE_DIRECTORY;
                             resourceBase: DWord;
                             Level: Integer;
                             TypeParentRes: Word;
                             IsTypeParentName: Boolean;
                             ParentNameRes: string);

         procedure DumpResourcePlus(resDirEntry,resDirEntryParent: PIMAGE_RESOURCE_DIRECTORY_ENTRY);
         var
          resType: DWord;
          resDataEntry: PIMAGE_RESOURCE_DATA_ENTRY;
          PInfo: PInfResource;
          RDirE: PIMAGE_RESOURCE_DIRECTORY;
          RDirEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
          RDirEntryParent: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
          RDataE: PIMAGE_RESOURCE_DATA_ENTRY;
          newNode: TTreeNode;
          NameRes: string;
          NewListRes: TList;
          PMem: Pointer;
          TypeParentName: Boolean;
         begin
          New(PInfo);
          ListResources.Add(PInfo);
          if Level=0 then
           resType:=resDirEntry.Name
          else begin
            resType:=TypeParentRes;
          end;  
          New(RDirE);
          MOve(resDir^,RDirE^,Sizeof(IMAGE_RESOURCE_DIRECTORY));
          PInfo.ResDir:=RDirE;
          new(RDirEntry);
          MOve(resDirEntry^,RDirEntry^,Sizeof(IMAGE_RESOURCE_DIRECTORY_ENTRY));
          PInfo.ResDirEntry:=RDirEntry;
          new(RDirEntryParent);
          FillChar(RDirEntryParent^,SizeOf(RDirEntryParent^),0);
          MOve(resDirEntryParent^,RDirEntryParent^,Sizeof(IMAGE_RESOURCE_DIRECTORY_ENTRY));
          PInfo.ResDirEntryParent:=RDirEntryParent;
          PInfo.TypeParentRes:=TypeParentRes;
          NameRes:=GetNameResource(resType,resourceBase,resDirEntry,level);
          PInfo.NameRes:=NameRes;
          PInfo.Level:=Level;
          PInfo.IsTypeParentName:=IsTypeParentName;
          if Level=0 then
           ParentNameRes:=NameRes;
          PInfo.ParentNameRes:=ParentNameRes;
          if not HighBitSet(resDirEntry.Name) and
                 (resDirEntry.Name <= 16)then begin
           TypeParentName:=false;
          end else begin
           if (Level>0)and(not IsTypeParentName)then begin
            TypeParentName:=false;
           end else begin
            TypeParentName:=true;
           end;
          end;
            newNode:=AddToTreeView(NameRes,Node,tpnResource,PInfo);

          if HighBitSet(resDirEntry.OffsetToData) then begin
            NewListRes:=TList.Create;
            PInfo.ResList:=NewListRes;
            PInfo.TypeRes:=rtlDir;
            PInfo.ResData:=nil;
            PInfo.ResDataMem:=nil;

            DumpResource(newNode,NewListRes,
                         Pointer(resourceBase+StripHighBit(resDirEntry.OffsetToData)),
                         Pointer(resDirEntry),resourceBase,Level+1,resType,TypeParentName,ParentNameRes);
          end else begin
            resDataEntry:=Pointer(resourceBase+StripHighBit(resDirEntry.OffsetToData));
            New(RDataE);
            MOve(resDataEntry^,RDataE^,Sizeof(IMAGE_RESOURCE_DATA_ENTRY));
            PInfo.ResData:=RDataE;
            GetMem(PMem,RDataE.Size);
            MOve(Pointer(Integer(mHandle+RDataE.OffsetToData)+Delta)^,PMem^,RDataE.Size);

            PInfo.ResDataMem:=PMem;
            PInfo.TypeRes:=rtlData;
          end;
         end;

      var
        resDirEntry,resDirEntryParent: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
        i: DWord;
      begin
       resDirEntry:=PIMAGE_RESOURCE_DIRECTORY_ENTRY(resDir);
       resDirEntryParent:=PIMAGE_RESOURCE_DIRECTORY_ENTRY(resDirParent);
       inc(PIMAGE_RESOURCE_DIRECTORY(resDirEntry));

       if resDir.NumberOfNamedEntries>0 then
        for i:=0 to resDir.NumberOfNamedEntries-1 do begin
         DumpResourcePlus(resDirEntry,resDirEntryParent);
         inc(resDirEntry);
        end;

       if resDir.NumberOfIdEntries>0 then
        for i:=0 to resDir.NumberOfIdEntries-1 do begin
         DumpResourcePlus(resDirEntry,resDirEntryParent);
         inc(resDirEntry);
        end;
      end;

    var
      PInfo: PInfListResources;
      IRD: PIMAGE_RESOURCE_DIRECTORY;
      ListResources: TList;
      prtNode: TTreeNode;
      SectionAddress,NumberOfSections: DWord;
    begin
      New(PInfo);
      FirstChildDirEntry:=nil;
      ListResources:=TList.Create;
      PInfo.List:=ListResources;
      prtNode:=AddToTreeView(DataName,ParentNode,tpnResources,PInfo);
      SectionAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
      NumberOfSections:=FileHeader.NumberOfSections;
      IRD:=GetPointer(mHandle,VirtualAddress,SectionAddress,NumberOfSections,Delta);
      if not IsBadCodePtr(IRD) then begin
        DumpResource(prtNode,ListResources,IRD,IRD,DWord(IRD),0,0,false,'');
      end; 
    end;

    procedure FillDirectoryException(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfException;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnException,PInfo);
    end;

    procedure FillDirectorySecurity(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfSecurity;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnSecurity,PInfo);
    end;

    procedure FillDirectoryBaseReloc(DataName: String; VirtualAddress,Size: DWord);
    var
      IBR,PIB: PIMAGE_BASE_RELOCATION;
      Delta: Integer;
      cEntries: Integer;
      relocType: Word;
      pEntry: PWord;
      i: Integer;
      typestr: string;
      PInfo: PInfListBaseRelocs;
      ListBaseRelocs: TList;
      SectionAddress,NumberOfSections: DWord;
      prtNode: TTreeNode;
      PBaseReloc: PInfBaseReloc;
      BaseRelocList: TList;
      PRelocName: PInfBaseRelocName;
      str: string;
    const
      SzRelocTypes :array [0..7] of string =('ABSOLUTE','HIGH','LOW',
                                              'HIGHLOW','HIGHADJ','MIPS_JMPADDR',
                                              'I860_BRADDR','I860_SPLIT');

    begin
      New(PInfo);
      ListBaseRelocs:=TList.Create;
      PInfo.List:=ListBaseRelocs;
      prtNode:=AddToTreeView(DataName,ParentNode,tpnBaseRelocs,PInfo);
      SectionAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
      NumberOfSections:=FileHeader.NumberOfSections;
      IBR:=GetPointer(mHandle,VirtualAddress,SectionAddress,NumberOfSections,Delta);
      while IBR.SizeOfBlock<>0 do begin
        if IsBadCodePtr(IBR) then exit;
        new(PBaseReloc);
        new(PIB);
        MOve(IBR^,PIB^,Sizeof(IMAGE_BASE_RELOCATION));
        PBaseReloc.PIB:=PIB;
        BaseRelocList:=TList.Create;
        PBaseReloc.List:=BaseRelocList;
        ListBaseRelocs.Add(PBaseReloc);
        str:='VA: '+inttohex(IBR.VirtualAddress,8)+' - S:'+inttohex(IBR.SizeOfBlock,8);
        AddToTreeView(str,prtNode,tpnBaseReloc,PBaseReloc);
        cEntries:=(IBR.SizeOfBlock-sizeof(IMAGE_BASE_RELOCATION))div sizeof(WORD);
        pEntry:= PWORD(DWord(IBR)+sizeof(IMAGE_BASE_RELOCATION));
        for i:=0 to cEntries-1 do begin
          relocType:= (pEntry^ and $F000) shr 12;
          if relocType<8 then typestr:=SzRelocTypes[relocType]
          else typestr:='UNKNOWN';
          New(PRelocName);
          PRelocName.Address:=(pEntry^ and $0FFF)+IBR.VirtualAddress;
          PRelocName.TypeReloc:=typestr;
          BaseRelocList.Add(PRelocName);
          inc(pEntry);
        end;
        IBR:=PIMAGE_BASE_RELOCATION(DWord(IBR)+IBR.SizeOfBlock);
      end;
    end;

    procedure FillDirectoryDebug(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfListDebugs;
      ListDebugs: TList;
      va_debug_dir: DWord;
      Header: PImageSectionHeader;
      debugDir: PImageDebugDirectory;
      cDebugFormats: Integer;
      offsetInto_rdata: DWord;
      i: Integer;
      szDebugFormat: string;
      PDebug: PInfDebug;
      pNtHeader: PImageNtHeaders;
      pDOSHead: PImageDosHeader;
    const
      SzDebugFormats :array [0..6] of string =('UNKNOWN/BORLAND',
                                             'COFF','CODEVIEW','FPO',
                                             'MISC','EXCEPTION','FIXUP');
    begin
      va_debug_dir:= NTHeader.OptionalHeader.
                     Datadirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].VirtualAddress;
      pDOSHead:=Pointer(mHandle);
      PNtHeader:=Pointer(mHandle+Dword(pDOSHead._lfanew));
      if GetSectionHdr('.debug',header,pNtHeader) then begin
        if header.VirtualAddress=va_debug_dir then begin
          debugDir:= PImageDebugDirectory(header.PointerToRawData+mhandle);
          cDebugFormats:= NTHeader.OptionalHeader.
                          DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].Size;

        end;
      end else begin
//        if not GetSectionHdr('.rdata',header,pNTHeader) then exit;
        cDebugFormats:= NTHeader.OptionalHeader.
			DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].Size div
   			sizeof(IMAGE_DEBUG_DIRECTORY);
        if cDebugFormats=0 then exit;
        offsetInto_rdata:= va_debug_dir - header.VirtualAddress;
	debugDir:= PImageDebugDirectory(mhandle+header.PointerToRawData+offsetInto_rdata);
        New(PInfo);
        ListDebugs:=TList.Create;
        PInfo.List:=ListDebugs;
        AddToTreeView(DataName,ParentNode,tpnDebugs,PInfo);
      end;
      for i:=0 to cDebugFormats-1 do begin
        new(PDebug);
        MOve(debugDir^,PDebug^,Sizeof(TImageDebugDirectory));
        ListDebugs.Add(PDebug);
        if debugDir._Type<7 then
         szDebugFormat:= SzDebugFormats[debugDir._Type]
        else szDebugFormat:='UNKNOWN';
        inc(debugDir);
      end;
    end;

    procedure FillDirectoryCopyright(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfCopyright;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnCopyright,PInfo);
    end;

    procedure FillDirectoryGlobalptr(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfGlobalptr;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnGlobalptr,PInfo);
    end;

    procedure FillDirectoryTls(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfTls;
      PITDE: PIMAGE_TLS_DIRECTORY_ENTRY;
      Delta: Integer;
      SectionAddress,NumberOfSections: DWord;
    begin
      SectionAddress:=mhandle+DWord(DosHeader._lfanew)+sizeof(TImageNtHeaders);
      NumberOfSections:=FileHeader.NumberOfSections;
      PITDE:=GetPointer(mHandle,VirtualAddress,SectionAddress,NumberOfSections,Delta);
      if IsBadCodePtr(PITDE) then exit;
      New(PInfo);
      MOve(PITDE^,PInfo^,Sizeof(IMAGE_TLS_DIRECTORY_ENTRY));
      AddToTreeView(DataName,ParentNode,tpnTls,PInfo);
    end;

    procedure FillDirectoryLoadconfig(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfLoadconfig;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnLoadconfig,PInfo);
    end;

    procedure FillDirectoryBoundImport(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfBoundImport;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnBoundImport,PInfo);
    end;

    procedure FillDirectoryIat(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInfIat;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpnIat,PInfo);
    end;

    procedure FillDirectory13(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInf13;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpn13,PInfo);
    end;

    procedure FillDirectory14(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInf14;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpn14,PInfo);
    end;

    procedure FillDirectory15(DataName: String; VirtualAddress,Size: DWord);
    var
      PInfo: PInf15;
    begin
      nEW(PInfo);
      AddToTreeView(DataName,ParentNode,tpn15,PInfo);
    end;

  var
    i: Integer;
    VirtualAddress,Size: DWord;
    DataName: string;
  begin
    for i:=0 to IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1 do begin
      VirtualAddress:=OptionalHeader.DataDirectory[i].VirtualAddress;
      Size:=OptionalHeader.DataDirectory[i].Size;
      DataName:=GetImageDirectory(I);
      if (VirtualAddress<>0)and (Size<>0) then begin
       case I of
        IMAGE_DIRECTORY_ENTRY_EXPORT: FillDirectoryExport(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_IMPORT: FillDirectoryImport(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_RESOURCE: FillDirectoryResource(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_EXCEPTION: FillDirectoryException(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_SECURITY: FillDirectorySecurity(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_BASERELOC: FillDirectoryBaseReloc(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_DEBUG: FillDirectoryDebug(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_COPYRIGHT: FillDirectoryCopyright(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_GLOBALPTR: FillDirectoryGlobalptr(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_TLS: FillDirectoryTls(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG: FillDirectoryLoadconfig(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT: FillDirectoryBoundImport(DataName,VirtualAddress,Size);
        IMAGE_DIRECTORY_ENTRY_IAT: FillDirectoryIat(DataName,VirtualAddress,Size);
        13: FillDirectory13(DataName,VirtualAddress,Size);
        14: FillDirectory14(DataName,VirtualAddress,Size);
        15: FillDirectory15(DataName,VirtualAddress,Size);
      end;
     end;
    end;
  end;

var
  parentNode: TTreeNode;
  NodeFileName: TTreeNode;
begin
  NodeFileName:=nil;
  Screen.Cursor:=crHourGlass;
  tv.Items.BeginUpdate;
  try
   try
    ClearTreeView;
    parentNode:=nil;
    parentNode:=FillFileName(parentNode);
    NodeFileName:=parentNode;
    Move(Pointer(mHandle)^,DosHeader,sizeof(TImageDosHeader));
    if DosHeader.e_magic<>IMAGE_DOS_SIGNATURE then exit;
    parentNode:=FillDosHeader(parentNode);

    Move(Pointer(mhandle+DWord(DosHeader._lfanew))^,NtHeader,sizeof(TImageNtHeaders));
    if NtHeader.Signature<>IMAGE_NT_SIGNATURE  then exit;
    parentNode:=FillNtHeader(parentNode);
    Move(NtHeader.FileHeader,FileHeader,sizeof(TImageFileHeader));
    FillFileHeader(parentNode);
    Move(NtHeader.OptionalHeader,OptionalHeader,sizeof(TImageOptionalHeader));
    FillOptionalHeader(parentNode);

    FillSections(NodeFileName);

    FillDataDirectory(NodeFileName);


   except
     MessageBox(Handle,'Bad PE format.',nil,MB_ICONERROR);
   end;
  finally
   tv.Items.EndUpdate;
   if NodeFileName<>nil then begin
    NodeFileName.MakeVisible;
    NodeFileName.Selected:=true;
    NodeFileName.Expand(false);
    ActiveInfo(NodeFileName,chbHexView.Checked);
   end;
   Screen.Cursor:=crdefault;
  end;
end;

procedure TfmFileInfo.HideAllTabSheets;
var
    i: Integer;
begin
{    for i:=0 to pcInfo.PageCount-1 do begin
      pcInfo.Pages[i].TabVisible:=false;
    end;}
end;

procedure TfmFileInfo.TVChange(Sender: TObject; Node: TTreeNode);
begin
  ActiveInfo(Node,chbHexView.Checked);
end;

procedure TfmFileInfo.edOnExit_DosHeader_Hex(Sender: TObject);
begin
{  if Trim(sg.InplaceEditor.Text)='' then
   sg.InplaceEditor.Text:='0';}
end;

procedure TfmFileInfo.sgKeyPress_DosHeader(Sender: TObject; var Key: Char);
var
  ch:char;
  SizeText: Integer;
begin
 if sg.col=sg.ColCount-2 then begin
  SizeText:=Integer(Pointer(sg.Objects[sg.col,sg.row]));
  sg.InplaceEditor.MaxLength:=SizeText;
  sg.InplaceEditor.OnExit:=edOnExit_DosHeader_Hex;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
     if Integer(Key)<>VK_RETURN then
      Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sg.InplaceEditor.ReadOnly) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
   sg.InplaceEditor.OnExit:=nil;

 end;
end;

procedure TfmFileInfo.sgSelectCell_DosHeader(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
begin
  if ACol=sg.ColCount-2 then begin
   sg.InplaceEditor.ReadOnly:=false;
  end else begin
    sg.InplaceEditor.ReadOnly:=true;
  end;
  if OldCol=sg.ColCount-2 then begin
    if Trim(sg.Cells[OldCol,OldRow])='' then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(0,SizeText);
    end else begin
     if (OldRow>sg.FixedRows-1) and (OldCol>sg.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      value:=strtoint('$'+Trim(sg.Cells[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
  //  sg.Options:=sg.Options-[goEditing];
  end;
  OldRow:=ARow;
  OldCol:=ACol;
end;

procedure TfmFileInfo.miNoneCopyClick(Sender: TObject);
var
  ct: TControl;
  pt: TPoint;
begin
 GetCursorPos(pt);
 pt:=ScreenToClient(pt);
 ct:=ControlAtPos(pt,true);
 if ct is TStringGrid then begin
  if TStringGrid(ct).InplaceEditor<>nil then
   TStringGrid(ct).InplaceEditor.CopyToClipboard;
 end;   
end;

function TfmFileInfo.GetNtHeaderSignature(Signature: DWord): String;
begin
  Result:='UNKNOWN';
  case Signature of
   IMAGE_DOS_SIGNATURE: Result:='DOS';
   IMAGE_OS2_SIGNATURE: Result:='OS2';
   IMAGE_OS2_SIGNATURE_LE: Result:='OS2 LE';
   IMAGE_NT_SIGNATURE: Result:='NT/VXD';
  end;
end;

function TfmFileInfo.GetFileHeaderMachine(Machine: Word): String;
begin
  Result:='Unknown';
  case Machine of
   IMAGE_FILE_MACHINE_UNKNOWN: Result:='Unknown';
   IMAGE_FILE_MACHINE_I386: Result:='Intel 386';
   IMAGE_FILE_MACHINE_R3000: Result:='MIPS little-endian, 0x160 big-endian';
   IMAGE_FILE_MACHINE_R4000: Result:='MIPS little-endian';
   IMAGE_FILE_MACHINE_R10000: Result:='MIPS little-endian';
   IMAGE_FILE_MACHINE_ALPHA: Result:='Alpha AXP';
   IMAGE_FILE_MACHINE_POWERPC: Result:='IBM PowerPC Little-Endian';
  end;
end;

function TfmFileInfo.GetTimeDateStamp(TimeDateStamp: DWORD): String;
var
  ts: TTimeStamp;
  tdstart: TDateTime;
  tdcurr: TDateTime;
  retval: TDateTime;

const
  StartTimeDate='01.01.1970 4:00:00';//December 31st, 1969, at 4:00 P.M.';
begin
  try
    ts:=MSecsToTimeStamp(TimeDateStamp);
    tdstart:=StrToDateTime(StartTimeDate);
    tdcurr:=TimeStampToDateTime(ts);
    retval:=tdstart+tdcurr;
    Result:='The time that the linker produced this file';//+DateTimeTostr(tdcurr);
  except

  end;  
end;

function TfmFileInfo.GetFileHeaderCharacteristics(Characteristics: Word): string;
begin
  Result:='Unknown';
  case Characteristics of
   IMAGE_FILE_RELOCS_STRIPPED: Result:='Relocation info stripped from file';
   IMAGE_FILE_EXECUTABLE_IMAGE: Result:='File is executable  (i.e. no unresolved externel references)';
   IMAGE_FILE_LINE_NUMS_STRIPPED: Result:='Line nunbers stripped from file';
   IMAGE_FILE_LOCAL_SYMS_STRIPPED: Result:='Local symbols stripped from file';
   IMAGE_FILE_AGGRESIVE_WS_TRIM: Result:='Agressively trim working set';
   IMAGE_FILE_BYTES_REVERSED_LO: Result:='Bytes of machine word are reversed';
   IMAGE_FILE_32BIT_MACHINE: Result:='32 bit word machine';
   IMAGE_FILE_DEBUG_STRIPPED: Result:='Debugging info stripped from file in .DBG file';
   IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP: Result:='If Image is on removable media, copy and run from the swap file';
   IMAGE_FILE_NET_RUN_FROM_SWAP: Result:='If Image is on Net, copy and run from the swap file';
   IMAGE_FILE_SYSTEM: Result:='System File';
   IMAGE_FILE_DLL: Result:='File is a DLL';
   IMAGE_FILE_UP_SYSTEM_ONLY: Result:='File should only be run on a UP machine';
   IMAGE_FILE_BYTES_REVERSED_HI: Result:='Bytes of machine word are reversed';
  end;
end;

function TfmFileInfo.GetOptionalHeaderMagic(Magic: Word): string;
begin
  Result:='Unknown';
  case Magic of
   IMAGE_NT_OPTIONAL_HDR_MAGIC: Result:='The file is an executable image';
   IMAGE_ROM_OPTIONAL_HDR_MAGIC: Result:='The file is a ROM image';
  end;
end;

function TfmFileInfo.GetOptionalHeaderSubSystem(Subsystem: Word): string;
begin
  Result:='Unknown';
  case Subsystem of
   IMAGE_SUBSYSTEM_UNKNOWN: Result:='Unknown subsystem';
   IMAGE_SUBSYSTEM_NATIVE: Result:='Image doesn''t require a subsystem';
   IMAGE_SUBSYSTEM_WINDOWS_GUI: Result:='Image runs in the Windows GUI subsystem';
   IMAGE_SUBSYSTEM_WINDOWS_CUI: Result:='Image runs in the Windows character subsystem';
   IMAGE_SUBSYSTEM_OS2_CUI: Result:='image runs in the OS/2 character subsystem';
   IMAGE_SUBSYSTEM_POSIX_CUI: Result:='image run  in the Posix character subsystem';
   IMAGE_SUBSYSTEM_RESERVED8: Result:='image run  in the 8 subsystem';
  end;
end;

function TfmFileInfo.GetOptionalHeaderDllCharacteristics(DllCharacteristics: Word): string;
begin
  Result:='Unknown';
  case DllCharacteristics of
    $0001: Result:='Reserved';
    $0002: Result:='Reserved';
    $0004: Result:='Reserved';
    $0008: Result:='Reserved';
    $2000: Result:='A WDM driver';
  end;
end;

procedure TfmFileInfo.sgKeyPress_ListSections(Sender: TObject; var Key: Char);
var
  ch:char;
  SizeText: Integer;
begin
 if sg.col in [1..sg.ColCount-2] then begin
  SizeText:=Integer(Pointer(sg.Objects[sg.col,sg.row]));
  sg.InplaceEditor.MaxLength:=SizeText;
  sg.InplaceEditor.OnExit:=edOnExit_DosHeader_Hex;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
     if Integer(Key)<>VK_RETURN then
      Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sg.InplaceEditor.ReadOnly) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
   sg.InplaceEditor.OnExit:=nil;

 end;
end;

procedure TfmFileInfo.sgSelectCell_ListSections(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
begin
  if ACol in [1..sg.ColCount-2]  then begin
   sg.InplaceEditor.ReadOnly:=false;
  end else begin
    sg.InplaceEditor.ReadOnly:=true;
  end;
  if OldCol in [1..sg.ColCount-2]  then begin
    if Trim(sg.Cells[OldCol,OldRow])='' then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(0,SizeText);
    end else begin
     if (OldRow>sg.FixedRows-1) and (OldCol>sg.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      value:=strtoint('$'+Trim(sg.Cells[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
  //  sg.Options:=sg.Options-[goEditing];
  end;
  OldRow:=ARow;
  OldCol:=ACol;
end;

procedure TfmFileInfo.SetGridColWidth;
var
  i,j: Integer;
  w1: Integer;
  wstart: Integer;
begin
 if sg.parent=nil then exit;
  for i:=0 to sg.ColCount-1 do begin
   wstart:=0;
   w1:=0;
   for j:=0 to sg.RowCount-1 do begin
    w1:=sg.Canvas.TextWidth(sg.cells[i,j]);
    if wstart<w1 then wstart:=W1;
   end;
   sg.ColWidths[i]:=wstart+10;
  end;
end;

procedure TfmFileInfo.SetNewGridColWidth;
var
  i,j: Integer;
  w1: Integer;
  wstart: Integer;
begin
 if sgNew.parent=nil then exit;
  for i:=0 to sgNew.ColCount-1 do begin
   wstart:=0;
   w1:=0;
   for j:=0 to sgNew.RowCount-1 do begin
    w1:=sgNew.Canvas.TextWidth(sgNew.cells[i,j]);
    if wstart<w1 then wstart:=W1;
   end;
   sgNew.ColWidths[i]:=wstart+10;
  end;
end;

function TfmFileInfo.GetListSectionsCharacteristics(Characteristics: DWord): String;

   function GetChara(Chara: Dword): string;
   begin
     Result:='';
     case Chara of
        IMAGE_SCN_TYPE_NO_PAD: Result:='Reserved.';
        IMAGE_SCN_CNT_CODE: Result:='Executable code.';
        IMAGE_SCN_CNT_INITIALIZED_DATA: Result:='Initialized data.';
        IMAGE_SCN_CNT_UNINITIALIZED_DATA: Result:='Uninitialized data.';
        IMAGE_SCN_LNK_OTHER: Result:='Reserved.';
        IMAGE_SCN_LNK_INFO: Result:='Reserved.';
        IMAGE_SCN_LNK_REMOVE: Result:='Reserved.';
        IMAGE_SCN_LNK_COMDAT: Result:='COMDAT data.';
        IMAGE_SCN_MEM_FARDATA: Result:='Reserved.';
        IMAGE_SCN_MEM_PURGEABLE: Result:='Reserved.';
 //    IMAGE_SCN_MEM_16BIT: Result:='Reserved';
        IMAGE_SCN_MEM_LOCKED: Result:='Reserved.';
        IMAGE_SCN_MEM_PRELOAD: Result:='Reserved.';
        IMAGE_SCN_ALIGN_1BYTES: Result:='Align data on a 1-byte.';
        IMAGE_SCN_ALIGN_2BYTES: Result:='Align data on a 2-byte.';
        IMAGE_SCN_ALIGN_4BYTES: Result:='Align data on a 4-byte.';
        IMAGE_SCN_ALIGN_8BYTES: Result:='Align data on a 8-byte.';
        IMAGE_SCN_ALIGN_16BYTES: Result:='Align data on a 16-byte.';
        IMAGE_SCN_ALIGN_32BYTES: Result:='Align data on a 32-byte.';
        IMAGE_SCN_ALIGN_64BYTES: Result:='Align data on a 64-byte.';
        IMAGE_SCN_LNK_NRELOC_OVFL: Result:='Extended relocations.';
        IMAGE_SCN_MEM_DISCARDABLE: Result:='Can be discarded as needed.';
        IMAGE_SCN_MEM_NOT_CACHED: Result:='Cannot be cached.';
        IMAGE_SCN_MEM_NOT_PAGED: Result:='Cannot be paged.';
        IMAGE_SCN_MEM_SHARED: Result:='Can be shared in memory.';
        IMAGE_SCN_MEM_EXECUTE: Result:='Can be executed as code.';
        IMAGE_SCN_MEM_READ: Result:='Can be read.';
        IMAGE_SCN_MEM_WRITE: Result:='Can be write.';
     end;
   end;

   function GetMaxValue(Chara: DWord): DWord;
   var
     list: TList;
     i: Integer;
     num: DWord;
     maxnum: DWord;
   begin
     list:=TList.Create;
     try
       list.Add(Pointer(IMAGE_SCN_TYPE_NO_PAD));
       list.Add(Pointer(IMAGE_SCN_CNT_CODE));
       list.Add(Pointer(IMAGE_SCN_CNT_INITIALIZED_DATA));
       list.Add(Pointer(IMAGE_SCN_CNT_UNINITIALIZED_DATA));
       list.Add(Pointer(IMAGE_SCN_LNK_OTHER));
       list.Add(Pointer(IMAGE_SCN_LNK_INFO));
       list.Add(Pointer(IMAGE_SCN_LNK_REMOVE));
       list.Add(Pointer(IMAGE_SCN_LNK_COMDAT));
       list.Add(Pointer(IMAGE_SCN_MEM_FARDATA));
       list.Add(Pointer(IMAGE_SCN_MEM_PURGEABLE));
       list.Add(Pointer(IMAGE_SCN_MEM_PURGEABLE));
       list.Add(Pointer(IMAGE_SCN_MEM_LOCKED));
       list.Add(Pointer(IMAGE_SCN_MEM_PRELOAD));
       list.Add(Pointer(IMAGE_SCN_ALIGN_1BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_2BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_4BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_8BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_16BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_32BYTES));
       list.Add(Pointer(IMAGE_SCN_ALIGN_64BYTES));
       list.Add(Pointer(IMAGE_SCN_LNK_NRELOC_OVFL));
       list.Add(Pointer(IMAGE_SCN_MEM_DISCARDABLE));
       list.Add(Pointer(IMAGE_SCN_MEM_NOT_CACHED));
       list.Add(Pointer(IMAGE_SCN_MEM_NOT_PAGED));
       list.Add(Pointer(IMAGE_SCN_MEM_SHARED));
       list.Add(Pointer(IMAGE_SCN_MEM_EXECUTE));
       list.Add(Pointer(IMAGE_SCN_MEM_READ));
       list.Add(Pointer(IMAGE_SCN_MEM_WRITE));
       maxnum:=0;
       for i:=0 to List.Count-1 do begin
        num:=Integer(List.Items[i]);
        if (maxnum<num) and (num<=Chara) then maxnum:=num;
       end;
       Result:=maxnum;

     finally
      List.Free;
     end;
   end;

var
  Chara: DWord;
  MaxValue: DWord;
begin
  Result:='';
  Chara:=Characteristics;
  while Chara<>0 do begin
    MaxValue:=GetMaxValue(Chara);
    Chara:=Chara-MaxValue;
    Result:=Result+GetChara(MaxValue);

  end;
end;

procedure TfmFileInfo.sgNewKeyPress_Exports(Sender: TObject; var Key: Char);
var
  ch:char;
  SizeText: Integer;
begin
 if sgNew.col in [0..sgNew.ColCount-2] then begin
  SizeText:=Integer(Pointer(sgNew.Objects[sgNew.col,sgNew.row]));
  sgNew.InplaceEditor.MaxLength:=SizeText;
  sgNew.InplaceEditor.OnExit:=edOnExit_DosHeader_Hex;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
     if Integer(Key)<>VK_RETURN then
      Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sgNew.InplaceEditor.ReadOnly) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
   sgNew.InplaceEditor.OnExit:=nil;

 end;
end;

procedure TfmFileInfo.sgNewSelectCell_Exports(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
begin
  if ACol in [0..sgNew.ColCount-2]  then begin
   sgNew.InplaceEditor.ReadOnly:=false;
  end else begin
    sgNew.InplaceEditor.ReadOnly:=true;
  end;
  if OldColNew in [0..sgNew.ColCount-2]  then begin
    if Trim(sgNew.Cells[OldColNew,OldRowNew])='' then begin
      SizeText:=Integer(Pointer(sgNew.Objects[OldColNew,OldRowNew]));
      sgNew.HideEditor;
      sgNew.Cells[OldColNew,OldRowNew]:=inttohex(0,SizeText);
    end else begin
     if (OldRowNew>sgNew.FixedRows-1) and (OldColNew>sgNew.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sgNew.Objects[OldColNew,OldRowNew]));
      value:=strtoint('$'+Trim(sgNew.Cells[OldColNew,OldRowNew]));
      sgNew.HideEditor;
      sgNew.Cells[OldColNew,OldRowNew]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
  //  sgNew.Options:=sgNew.Options-[goEditing];
  end;
  OldRowNew:=ARow;
  OldColNew:=ACol;
end;

procedure TfmFileInfo.sgKeyPress_BaseRelocs(Sender: TObject; var Key: Char);
var
  ch:char;
  SizeText: Integer;
begin
 if sg.col in [0..sg.ColCount-2] then begin
  SizeText:=Integer(Pointer(sg.Objects[sg.col,sg.row]));
  sg.InplaceEditor.MaxLength:=SizeText;
  sg.InplaceEditor.OnExit:=edOnExit_DosHeader_Hex;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
     if Integer(Key)<>VK_RETURN then
      Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sg.InplaceEditor.ReadOnly) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
   sg.InplaceEditor.OnExit:=nil;

 end;
end;

procedure TfmFileInfo.sgSelectCell_BaseRelocs(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
begin
  if ACol in [0..sg.ColCount-2]  then begin
   sg.InplaceEditor.ReadOnly:=false;
  end else begin
    sg.InplaceEditor.ReadOnly:=true;
  end;
  if OldCol in [0..sg.ColCount-2]  then begin
    if Trim(sg.Cells[OldCol,OldRow])='' then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(0,SizeText);
    end else begin
     if (OldRow>sg.FixedRows-1) and (OldCol>sg.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sg.Objects[OldCol,OldRow]));
      value:=strtoint('$'+Trim(sg.Cells[OldCol,OldRow]));
      sg.HideEditor;
      sg.Cells[OldCol,OldRow]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
  //  sgNew.Options:=sgNew.Options-[goEditing];
  end;
  OldRow:=ARow;
  OldCol:=ACol;
end;

procedure TfmFileInfo.sgNewKeyPress_Resource(Sender: TObject; var Key: Char);
var
  ch:char;
  SizeText: Integer;
begin
 if sgNew.col in [1..sgNew.ColCount-2] then begin
  SizeText:=Integer(Pointer(sgNew.Objects[sgNew.col,sgNew.row]));
  sgNew.InplaceEditor.MaxLength:=SizeText;
  sgNew.InplaceEditor.OnExit:=edOnExit_DosHeader_Hex;
  if (not (Key in ['0'..'9']))and(Integer(Key)<>VK_Back)
     and(not(Key in ['A'..'F']))and (not(Key in ['a'..'f']))then begin
     if Integer(Key)<>VK_RETURN then
      Key:=Char(nil);
  end else begin
    if Key in ['a'..'f'] then begin
      ch:=Key;
      Dec(ch, 32);
      Key:=ch;
    end;
    if (not sgNew.InplaceEditor.ReadOnly) then begin
     btApply.Enabled:=true;
    end;
  end;
 end else begin
   sgNew.InplaceEditor.OnExit:=nil;

 end;
end;

procedure TfmFileInfo.sgNewSelectCell_Resource(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
begin
  if ACol in [1..sgNew.ColCount-2]  then begin
   sgNew.InplaceEditor.ReadOnly:=false;
  end else begin
    sgNew.InplaceEditor.ReadOnly:=true;
  end;
  if OldColNew in [1..sgNew.ColCount-2]  then begin
    if Trim(sgNew.Cells[OldColNew,OldRowNew])='' then begin
      SizeText:=Integer(Pointer(sgNew.Objects[OldColNew,OldRowNew]));
      sgNew.HideEditor;
      sgNew.Cells[OldColNew,OldRowNew]:=inttohex(0,SizeText);
    end else begin
     if (OldRowNew>sgNew.FixedRows-1) and (OldColNew>sgNew.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sgNew.Objects[OldColNew,OldRowNew]));
      value:=strtoint('$'+Trim(sgNew.Cells[OldColNew,OldRowNew]));
      sgNew.HideEditor;
      sgNew.Cells[OldColNew,OldRowNew]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
  //  sgNew.Options:=sgNew.Options-[goEditing];
  end;
  OldRowNew:=ARow;
  OldColNew:=ACol;
end;

procedure TfmFileInfo.ActiveInfo(Node: TTreeNode; HexView: Boolean);

  procedure ClearGrid;
  var
    i: Integer;
  begin
    sg.FixedCols:=0;
    sg.FixedRows:=0;
    sg.RowCount:=0;
    for i:=0 to sg.ColCount-1 do begin
      sg.Cols[i].Clear;
    end;
    sg.ColCount:=3;
    sg.RowCount:=2;
    sg.FixedRows:=1;
    sg.OnKeyPress:=nil;
    sg.OnSelectCell:=nil;
    sg.Visible:=false;
    sg.parent:=nil;
    sg.InplaceEditor.ReadOnly:=true;
    sg.Visible:=false;
  end;

  procedure ClearNewGrid;
  var
    i: Integer;
  begin
    sgNew.FixedCols:=0;
    sgNew.FixedRows:=0;
    sgNew.RowCount:=0;
    for i:=0 to sgNew.ColCount-1 do begin
      sgNew.Cols[i].Clear;
    end;
    sgNew.ColCount:=3;
    sgNew.RowCount:=2;
    sgNew.FixedRows:=1;
    sgNew.OnKeyPress:=nil;
    sgNew.OnSelectCell:=nil;
    sgNew.Visible:=false;
    sgNew.parent:=nil;
    sgNew.InplaceEditor.ReadOnly:=true;
    sgNew.Visible:=false;
  end;

  procedure AddToCell_DosHeader(Text1,Text2,Text3: string;
                                SizeText13,SizeText2: Integer; Col1,Col2: Integer);
  begin
    sg.Cells[Col1,sg.RowCount-1]:=Text1;
    sg.Objects[Col1,sg.RowCount-1]:=TObject(Pointer(SizeText13));
    sg.Cells[Col2,sg.RowCount-1]:=Text2;
    sg.Objects[Col2,sg.RowCount-1]:=TObject(Pointer(SizeText2));
    sg.Cells[sg.ColCount-1,sg.RowCount-1]:=Text3;
    sg.Objects[sg.ColCount-1,sg.RowCount-1]:=TObject(Pointer(SizeText13));
    sg.RowCount:=sg.RowCount+1;
  end;

  function GetTextNode: String;
  var
    nd: TTreeNode;
  begin
   nd:=Node;
   Result:=nd.text;
   while nd.Parent<>nil do begin
     nd:=nd.Parent;
     Result:=nd.Text+'\'+Result;
   end;
  end;

  procedure ActiveFileName(PInfo: PInfFileName);
  begin
    edFileName_Path.Text:=PInfo.FileName;
  end;

  procedure ActiveDosHeader(PInfo: PInfDosHeader);
  var
    i: Integer;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnDosHeader_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';

    AddToCell_DosHeader('e_magic',inttohex(PInfo.e_magic,4),'Magic number',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_cblp',inttohex(PInfo.e_cblp,4),'Bytes on last page of file',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_cp',inttohex(PInfo.e_cp,4),'Pages in file',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_crlc',inttohex(PInfo.e_crlc,4),'Relocations',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_cparhdr',inttohex(PInfo.e_cparhdr,4),'Size of header in paragraphs',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_minalloc',inttohex(PInfo.e_minalloc,4),'Minimum extra paragraphs needed',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_maxalloc',inttohex(PInfo.e_maxalloc,4),'Maximum extra paragraphs needed',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_ss',inttohex(PInfo.e_ss,4),'Initial (relative) SS value',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_sp',inttohex(PInfo.e_sp,4),'Initial SP value',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_csum',inttohex(PInfo.e_csum,4),'Checksum',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_ip',inttohex(PInfo.e_ip,4),'Initial IP value',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_cs',inttohex(PInfo.e_cs,4),'Initial (relative) CS value',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_lfarlc',inttohex(PInfo.e_lfarlc,4),'File address of relocation table',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_ovno',inttohex(PInfo.e_ovno,4),'Overlay number',sizeof(Integer),4,0,1);
    for i:=0 to 2 do begin
     AddToCell_DosHeader('Reserved1 ['+inttostr(i)+']',
                         inttohex(PInfo.e_res[i],4),'Reserved words',sizeof(Integer),4,0,1);

    end;
    AddToCell_DosHeader('e_oemid',inttohex(PInfo.e_oemid,4),'OEM identifier (for e_oeminfo)',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('e_oeminfo',inttohex(PInfo.e_oeminfo,4),'OEM information; e_oemid specific',sizeof(Integer),4,0,1);
    for i:=0 to 9 do begin
     AddToCell_DosHeader('Reserved2 ['+inttostr(i)+']',
                         inttohex(PInfo.e_res2[i],4),'Reserved words',sizeof(Integer),4,0,1);
    end;
    AddToCell_DosHeader('_lfanew',inttohex(PInfo._lfanew,8),'File address of new exe header',sizeof(Integer),8,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveNtHeader(PInfo: PInfNtHeader);
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnNtHeader_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('Signature',inttohex(PInfo.Signature,8),
                        GetNtHeaderSignature(PInfo.Signature),sizeof(Integer),8,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveFileHeader(PInfo: PInfFileHeader);
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnFileHeader_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('Machine',inttohex(PInfo.Machine,4),
                        GetFileHeaderMachine(PInfo.Machine),sizeof(Integer),4,0,1);
    AddToCell_DosHeader('NumberOfSections',inttohex(PInfo.NumberOfSections,4),
                        'The number of sections in the file',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('TimeDateStamp',inttohex(PInfo.TimeDateStamp,8),
                        GetTimeDateStamp(PInfo.TimeDateStamp),sizeof(Integer),8,0,1);
    AddToCell_DosHeader('PointerToSymbolTable',inttohex(PInfo.PointerToSymbolTable,8),
                        'The file offset of the COFF symbol table',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('NumberOfSymbols',inttohex(PInfo.NumberOfSymbols,8),
                        'The number of symbols in the COFF symbol table',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfOptionalHeader',inttohex(PInfo.SizeOfOptionalHeader,4),
                        'The size of an optional header that can follow this structure',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('Characteristics',inttohex(PInfo.Characteristics,4),
                        GetFileHeaderCharacteristics(PInfo.Characteristics),sizeof(Integer),4,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveOptionalHeader(PInfo: PInfOptionalHeader);
  var
    i: Integer;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnOptionalHeader_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('Magic',inttohex(PInfo.Magic,4),
                        GetOptionalHeaderMagic(PInfo.Magic),sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MajorLinkerVersion',inttohex(PInfo.MajorLinkerVersion,2),
                        'Major version number of the linker',sizeof(Integer),2,0,1);
    AddToCell_DosHeader('MinorLinkerVersion',inttohex(PInfo.MinorLinkerVersion,2),
                        'Minor version number of the linker',sizeof(Integer),2,0,1);
    AddToCell_DosHeader('SizeOfCode',inttohex(PInfo.SizeOfCode,8),
                        'The size of the code section',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfInitializedData',inttohex(PInfo.SizeOfInitializedData,8),
                        'The size of the initialized data section',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfUninitializedData',inttohex(PInfo.SizeOfUninitializedData,8),
                        'The size of the uninitialized data section',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('AddressOfEntryPoint',inttohex(PInfo.AddressOfEntryPoint,8),
                        'Pointer to the entry point function, relative to the image base address',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('BaseOfCode',inttohex(PInfo.BaseOfCode,8),
                        'Pointer to the beginning of the code section, relative to the image base',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('BaseOfData',inttohex(PInfo.BaseOfData,8),
                        'Pointer to the beginning of the data section, relative to the image base',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('ImageBase',inttohex(PInfo.ImageBase,8),
                        'Preferred address of the first byte of the image when it is loaded in memory',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SectionAlignment',inttohex(PInfo.SectionAlignment,8),
                        'The alignment, in bytes, of sections loaded in memory',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('FileAlignment',inttohex(PInfo.FileAlignment,8),
                        'The alignment, in bytes, of the raw data of sections in the image file',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('MajorOperatingSystemVersiont',inttohex(PInfo.MajorOperatingSystemVersion,4),
                        'Major version number of the required operating system',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MinorOperatingSystemVersion',inttohex(PInfo.MinorOperatingSystemVersion,4),
                        'Minor version number of the required operating system',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MajorImageVersion',inttohex(PInfo.MajorImageVersion,4),
                        'Major version number of the image',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MinorImageVersion',inttohex(PInfo.MinorImageVersion,4),
                        'Minor version number of the image',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MajorSubsystemVersion',inttohex(PInfo.MajorSubsystemVersion,4),
                        'Major version number of the subsystem',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MinorSubsystemVersion',inttohex(PInfo.MinorSubsystemVersion,4),
                        'Minor version number of the subsystem',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('Win32VersionValue',inttohex(PInfo.Win32VersionValue,8),
                        'This member is reserved',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfImage',inttohex(PInfo.SizeOfImage,8),
                        'The size of the image, in bytes, including all headers',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfHeaders',inttohex(PInfo.SizeOfHeaders,8),
                        'Combined size of the MS-DOS stub, the PE header, and the section headers, rounded to a multiple of the value specified in the FileAlignment member',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('CheckSum',inttohex(PInfo.CheckSum,8),
                        'Image file checksum',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('Subsystem',inttohex(PInfo.Subsystem,4),
                        GetOptionalHeaderSubSystem(PInfo.Subsystem),sizeof(Integer),4,0,1);
    AddToCell_DosHeader('DllCharacteristics',inttohex(PInfo.DllCharacteristics,4),
                        GetOptionalHeaderDllCharacteristics(PInfo.DllCharacteristics),sizeof(Integer),4,0,1);
    AddToCell_DosHeader('SizeOfStackReserve',inttohex(PInfo.SizeOfStackReserve,8),
                        'The number of bytes to reserve for the stack',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfStackCommit',inttohex(PInfo.SizeOfStackCommit,8),
                        'The number of bytes to commit for the stack',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfHeapReserve',inttohex(PInfo.SizeOfHeapReserve,8),
                        'The number of bytes to reserve for the local heap',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfHeapCommit',inttohex(PInfo.SizeOfHeapCommit,8),
                        'The number of bytes to commit for the local heap',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('LoaderFlags',inttohex(PInfo.LoaderFlags,8),
                        'This member is obsolete',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('NumberOfRvaAndSizes',inttohex(PInfo.NumberOfRvaAndSizes,8),
                        'Number of directory entries',sizeof(Integer),8,0,1);
    for i:=0 to IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1 do begin
     AddToCell_DosHeader(GetImageDirectory(I),inttohex(PInfo.DataDirectory[i].VirtualAddress,8),
                        'DataDirectory ['+GetImageDirectory(I)+'] VirtualAddress',sizeof(Integer),8,0,1);
     AddToCell_DosHeader(GetImageDirectory(I),inttohex(PInfo.DataDirectory[i].Size,8),
                        'DataDirectory ['+GetImageDirectory(I)+'] Size',sizeof(Integer),8,0,1);
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveSections(PInfo: PInfListSections);
  var
    i: Integer;
    PSec: PInfSectionHeader;
    tmps: Pchar;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_ListSections;
    sg.OnSelectCell:=sgSelectCell_ListSections;
    sg.parent:=pnListSections_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=12;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='PhysicalAddress';
    sg.Cells[2,0]:='VirtualSize';
    sg.Cells[3,0]:='VirtualAddress';
    sg.Cells[4,0]:='SizeOfRawData';
    sg.Cells[5,0]:='PointerToRawData';
    sg.Cells[6,0]:='PointerToRelocations';
    sg.Cells[7,0]:='PointerToLinenumbers';
    sg.Cells[8,0]:='NumberOfRelocations';
    sg.Cells[9,0]:='NumberOfLinenumbers';
    sg.Cells[10,0]:='Characteristics';
    sg.Cells[11,0]:='Hint';

    for i:=0 to PInfo.List.Count-1 do begin
     PSec:=PInfo.List.Items[i];
     tmps:=Pchar(@PSec.Name);
     sg.Cells[0,i+1]:=Copy(tmps,1,Length(PSec.Name));
     sg.Objects[0,i+1]:=TObject(Pointer(SizeOf(Integer)));
     sg.Cells[1,i+1]:=inttohex(PSec.Misc.PhysicalAddress,8);
     sg.Objects[1,i+1]:=TObject(Pointer(8));
     sg.Cells[2,i+1]:=inttohex(PSec.Misc.VirtualSize,8);
     sg.Objects[2,i+1]:=TObject(Pointer(8));
     sg.Cells[3,i+1]:=inttohex(PSec.VirtualAddress,8);
     sg.Objects[3,i+1]:=TObject(Pointer(8));
     sg.Cells[4,i+1]:=inttohex(PSec.SizeOfRawData,8);
     sg.Objects[4,i+1]:=TObject(Pointer(8));
     sg.Cells[5,i+1]:=inttohex(PSec.PointerToRawData,8);
     sg.Objects[5,i+1]:=TObject(Pointer(8));
     sg.Cells[6,i+1]:=inttohex(PSec.PointerToRelocations,8);
     sg.Objects[6,i+1]:=TObject(Pointer(8));
     sg.Cells[7,i+1]:=inttohex(PSec.PointerToLinenumbers,8);
     sg.Objects[7,i+1]:=TObject(Pointer(8));
     sg.Cells[8,i+1]:=inttohex(PSec.NumberOfRelocations,4);
     sg.Objects[8,i+1]:=TObject(Pointer(4));
     sg.Cells[9,i+1]:=inttohex(PSec.NumberOfLinenumbers,4);
     sg.Objects[9,i+1]:=TObject(Pointer(4));
     sg.Cells[10,i+1]:=inttohex(PSec.Characteristics,8);
     sg.Objects[10,i+1]:=TObject(Pointer(8));
     sg.Cells[11,i+1]:=GetListSectionsCharacteristics(PSec.Characteristics);
     sg.Objects[11,i+1]:=TObject(Pointer(sizeof(Integer)));
     sg.RowCount:=sg.RowCount+1;
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveSectionHeader(PInfo: PInfSectionHeader);
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnSectionHeader_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=3;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('PhysicalAddress',inttohex(PInfo.Misc.PhysicalAddress,8),
                        'Specifies the file address',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('VirtualSize',inttohex(PInfo.Misc.VirtualSize,8),
                        'Total size of the section when loaded into memory',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('VirtualAddress',inttohex(PInfo.VirtualAddress,8),
                        'The address of the first byte of the section when loaded into memory, relative to the image base',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('SizeOfRawData',inttohex(PInfo.SizeOfRawData,8),
                        'The size of the initialized data on disk',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('PointerToRawData',inttohex(PInfo.PointerToRawData,8),
                        'File pointer to the first page within the COFF file',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('PointerToRelocations',inttohex(PInfo.PointerToRelocations,8),
                        'File pointer to the beginning of the relocation entries for the section',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('PointerToLinenumbers',inttohex(PInfo.PointerToLinenumbers,8),
                        'File pointer to the beginning of the line-number entries for the section',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('NumberOfRelocations',inttohex(PInfo.NumberOfRelocations,4),
                        'Number of relocation entries for the section',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('NumberOfLinenumbers',inttohex(PInfo.NumberOfLinenumbers,4),
                        'Number of line-number entries for the section',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('Characteristics',inttohex(PInfo.Characteristics,8),
                        GetListSectionsCharacteristics(PInfo.Characteristics),sizeof(Integer),8,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveExports(PInfo: PInfListExports);
  var
    i: Integer;
    PExport: PInfExport;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnExports_Top;
    pnExports_Top.Height:=200;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=3;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('Characteristics',inttohex(PInfo.IED.Characteristics,8),
                        'This field appears to be unused and is always set to 0',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('TimeDateStamp',inttohex(PInfo.IED.TimeDateStamp,8),
                        GetTimeDateStamp(PInfo.IED.TimeDateStamp),sizeof(Integer),8,0,1);
    AddToCell_DosHeader('MajorVersion',inttohex(PInfo.IED.MajorVersion,4),
                        'These fields appear to be unused and are set to 0',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('MinorVersion',inttohex(PInfo.IED.MinorVersion,4),
                        'These fields appear to be unused and are set to 0',sizeof(Integer),4,0,1);
    AddToCell_DosHeader('Name',inttohex(PInfo.IED.Name,8),
                        'The RVA of an ASCIIZ string with the name of this DLL',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('Base',inttohex(PInfo.IED.Base,8),
                        'The starting ordinal number for exported functions',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('NumberOfFunctions',inttohex(PInfo.IED.NumberOfFunctions,8),
                        'The number of elements in the AddressOfFunctions array',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('NumberOfNames',inttohex(PInfo.IED.NumberOfNames,8),
                        'The number of elements in the AddressOfNames array',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('AddressOfFunctions',inttohex(DWord(PInfo.IED.AddressOfFunctions),8),
                        'This field is an RVA and points to an array of function addresses',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('AddressOfNames',inttohex(DWord(PInfo.IED.AddressOfNames),8),
                        'This field is an RVA and points to an array of string pointers',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('AddressOfNameOrdinals',inttohex(DWord(PInfo.IED.AddressOfNameOrdinals),8),
                        'This field is an RVA and points to an array of WORDs',sizeof(Integer),8,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
    ClearNewGrid;
    sgNew.OnKeyPress:=sgNewKeyPress_Exports;
    sgNew.OnSelectCell:=sgNewSelectCell_Exports;
    sgNew.parent:=pnExports_Main;
//    sgNew.InplaceEditor.PopupMenu:=pmNone;
    sgNew.InplaceEditor.ReadOnly:=true;
    sgNew.ColCount:=3;
    sgNew.Cells[0,0]:='EntryPoint';
    sgNew.Cells[1,0]:='Ordinal';
    sgNew.Cells[2,0]:='Name';
    for i:=0 to PInfo.List.count-1 do begin
      PExport:=PInfo.List.Items[i];
      sgNew.Cells[0,i+1]:=inttohex(PExport.EntryPoint,8);
      sgNew.Objects[0,i+1]:=TObject(Pointer(8));
      sgNew.Cells[1,i+1]:=inttohex(PExport.Ordinal,8);
      sgNew.Objects[1,i+1]:=TObject(Pointer(8));
      sgNew.Cells[2,i+1]:=PExport.Name;
      sgNew.Objects[2,i+1]:=TObject(Pointer(sizeof(Integer)));
      sgNew.RowCount:=sgNew.RowCount+1;
    end;
    sgNew.RowCount:=sgNew.RowCount-1;
    if sgNew.RowCount>=2 then begin
     sgNew.Row:=1;
     sgNew.Col:=0;
    end;
    sgNew.Visible:=true; 
  end;

  procedure ActiveImports(PInfo: PInfListImports);
  var
    PImport: PInfImport;
    i: Integer;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_ListSections;
    sg.OnSelectCell:=sgSelectCell_ListSections;
    sg.parent:=pnImports_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=7;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Characteristics';
    sg.Cells[2,0]:='TimeDateStamp';
    sg.Cells[3,0]:='ForwarderChain';
    sg.Cells[4,0]:='AddressOfName';
    sg.Cells[5,0]:='FirstThunk';
    sg.Cells[6,0]:='Hint';

    for i:=0 to PInfo.List.Count-1 do begin
      PImport:=PInfo.List.Items[i];
      sg.Cells[0,i+1]:=PImport.Name;
      sg.Objects[0,i+1]:=TObject(Pointer(sizeof(Integer)));
      sg.Cells[1,i+1]:=inttohex(PImport.PID.Characteristics,8);
      sg.Objects[1,i+1]:=TObject(Pointer(8));
      sg.Cells[2,i+1]:=inttohex(PImport.PID.TimeDateStamp,8);
      sg.Objects[2,i+1]:=TObject(Pointer(8));
      sg.Cells[3,i+1]:=inttohex(PImport.PID.ForwarderChain,8);
      sg.Objects[3,i+1]:=TObject(Pointer(8));
      sg.Cells[4,i+1]:=inttohex(PImport.PID.Name,8);
      sg.Objects[4,i+1]:=TObject(Pointer(8));
      sg.Cells[5,i+1]:=inttohex(PImport.PID.FirstThunk,8);
      sg.Objects[5,i+1]:=TObject(Pointer(8));
      sg.Cells[6,i+1]:='';
      sg.Objects[6,i+1]:=TObject(Pointer(sizeof(Integer)));
      sg.RowCount:=sg.RowCount+1;
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveImport(PInfo: PInfImport);
  var
    i: Integer;
    PImportName: PInfImportName;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_DosHeader;
    sg.OnSelectCell:=sgSelectCell_DosHeader;
    sg.parent:=pnImport_Top;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    pnImport_Top.Height:=150;
    sg.ColCount:=3;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Value';
    sg.Cells[2,0]:='Hint';
    AddToCell_DosHeader('Characteristics',inttohex(PInfo.PID.Characteristics,8),
                       'Each of these pointers points to an IMAGE_IMPORT_BY_NAME structure',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('Characteristics',inttohex(PInfo.PID.TimeDateStamp,8),
                       GetTimeDateStamp(PInfo.PID.TimeDateStamp),sizeof(Integer),8,0,1);
    AddToCell_DosHeader('ForwarderChain',inttohex(PInfo.PID.ForwarderChain,8),
                       'This field relates to forwarding',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('Name',inttohex(PInfo.PID.Name,8),
                       'This is an RVA to a NULL-terminated ASCII string containing the imported DLL''s name',sizeof(Integer),8,0,1);
    AddToCell_DosHeader('FirstThunk',inttohex(PInfo.PID.FirstThunk,8),
                       'This field is an offset (an RVA) to an IMAGE_THUNK_DATA union',sizeof(Integer),8,0,1);
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
    ClearNewGrid;
    sgNew.OnKeyPress:=sgNewKeyPress_Exports;
    sgNew.OnSelectCell:=sgNewSelectCell_Exports;
    sgNew.parent:=pnImport_Main;
//    sgNew.InplaceEditor.PopupMenu:=pmNone;
    sgNew.InplaceEditor.ReadOnly:=true;
    sgNew.ColCount:=2;
    sgNew.Cells[0,0]:='Hint/Ordinal';
    sgNew.Cells[1,0]:='Name';
    for i:=0 to PInfo.List.count-1 do begin
      PImportName:=PInfo.List.Items[i];
      sgNew.Cells[0,i+1]:=inttohex(PImportName.HintOrd,4);
      sgNew.Objects[0,i+1]:=TObject(Pointer(4));
      sgNew.Cells[1,i+1]:=PImportName.Name;
      sgNew.Objects[1,i+1]:=TObject(Pointer(sizeof(Integer)));
      sgNew.RowCount:=sgNew.RowCount+1;
    end;
    sgNew.RowCount:=sgNew.RowCount-1;
    sgNew.Row:=1;
    sgNew.Col:=0;
    sgNew.Visible:=true;
  end;

  procedure ActiveResources(PInfo: PInfListResources);
  var
    PRes: PInfResource;
    i: Integer;
    tmps: string;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_ListSections;
    sg.OnSelectCell:=sgSelectCell_ListSections;
    sg.parent:=pnResources_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=8;
    sg.Cells[0,0]:='Name';
    sg.Cells[1,0]:='Characteristics';
    sg.Cells[2,0]:='TimeDateStamp';
    sg.Cells[3,0]:='MajorVersion';
    sg.Cells[4,0]:='MinorVersion';
    sg.Cells[5,0]:='NumberOfNamedEntries';
    sg.Cells[6,0]:='NumberOfIdEntries';
    sg.Cells[7,0]:='Hint';
    for i:=0 to PInfo.List.Count-1 do begin
      PRes:=PInfo.List.Items[i];
      sg.Cells[0,i+1]:=Pres.NameRes;
      sg.Objects[0,i+1]:=TObject(Pointer(sizeof(Integer)));
      sg.Cells[1,i+1]:=inttohex(PRes.ResDir.Characteristics,8);
      sg.Objects[1,i+1]:=TObject(Pointer(8));
      sg.Cells[2,i+1]:=inttohex(PRes.ResDir.TimeDateStamp,8);
      sg.Objects[2,i+1]:=TObject(Pointer(8));
      sg.Cells[3,i+1]:=inttohex(PRes.ResDir.MajorVersion,4);
      sg.Objects[3,i+1]:=TObject(Pointer(4));
      sg.Cells[4,i+1]:=inttohex(PRes.ResDir.MinorVersion,4);
      sg.Objects[4,i+1]:=TObject(Pointer(4));
      sg.Cells[5,i+1]:=inttohex(PRes.ResDir.NumberOfNamedEntries,4);
      sg.Objects[5,i+1]:=TObject(Pointer(4));
      sg.Cells[6,i+1]:=inttohex(PRes.ResDir.NumberOfIdEntries,4);
      sg.Objects[6,i+1]:=TObject(Pointer(4));
      case PRes.TypeRes of
        rtlData: begin
          tmps:='This is data';
        end;
        rtlDir: begin
          tmps:='This is directory';
        end;
      end;
      sg.Cells[7,i+1]:=tmps;
      sg.Objects[7,i+1]:=TObject(Pointer(sizeof(Integer)));
      sg.RowCount:=sg.RowCount+1;
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveResource(PInfo: PInfResource);

    procedure ActiveResourceHead;
    begin
     ClearGrid;
     sg.OnKeyPress:=sgKeyPress_DosHeader;
     sg.OnSelectCell:=sgSelectCell_DosHeader;
     sg.parent:=pnResource_Top;
//     sg.InplaceEditor.PopupMenu:=pmNone;
     pnResource_Top.Height:=150;
     sg.ColCount:=3;
     sg.Cells[0,0]:='Name';
     sg.Cells[1,0]:='Value';
     sg.Cells[2,0]:='Hint';
     AddToCell_DosHeader('Characteristics',inttohex(PInfo.ResDir.Characteristics,8),
                       'Always be 0',sizeof(Integer),8,0,1);
     AddToCell_DosHeader('TimeDateStamp',inttohex(PInfo.ResDir.TimeDateStamp,8),
                       GetTimeDateStamp(PInfo.ResDir.TimeDateStamp),sizeof(Integer),8,0,1);
     AddToCell_DosHeader('MajorVersion',inttohex(PInfo.ResDir.MajorVersion,4),
                       'Theoretically these field would hold a version number for the resource',
                       sizeof(Integer),4,0,1);
     AddToCell_DosHeader('MinorVersion',inttohex(PInfo.ResDir.MinorVersion,4),
                       'Theoretically these field would hold a version number for the resource',
                       sizeof(Integer),4,0,1);
     AddToCell_DosHeader('NumberOfNamedEntries',inttohex(PInfo.ResDir.NumberOfNamedEntries,4),
                       'The number of array elements that use names and that follow this structure',
                       sizeof(Integer),4,0,1);
     AddToCell_DosHeader('NumberOfIdEntries',inttohex(PInfo.ResDir.NumberOfIdEntries,4),
                       'The number of array elements that use integer IDs',
                       sizeof(Integer),4,0,1);
     sg.RowCount:=sg.RowCount-1;
     sg.Visible:=true;
    end;

    procedure ActiveResourceDir;
    var
      PRes: PInfResource;
      tmps: string;
      i: Integer;
    begin
     ClearNewGrid;
     pnResDataBottom.Visible:=false;
     sgNew.OnKeyPress:=sgNewKeyPress_Resource;
     sgNew.OnSelectCell:=sgNewSelectCell_Resource;
     sgNew.parent:=pnResource_Main;
//     sgNew.InplaceEditor.PopupMenu:=pmNone;
     sgNew.InplaceEditor.ReadOnly:=true;
     sgNew.ColCount:=8;
     sgNew.Cells[0,0]:='Name';
     sgNew.Cells[1,0]:='Characteristics';
     sgNew.Cells[2,0]:='TimeDateStamp';
     sgNew.Cells[3,0]:='MajorVersion';
     sgNew.Cells[4,0]:='MinorVersion';
     sgNew.Cells[5,0]:='NumberOfNamedEntries';
     sgNew.Cells[6,0]:='NumberOfIdEntries';
     sgNew.Cells[7,0]:='Hint';
     for i:=0 to PInfo.ResList.Count-1 do begin
      PRes:=PInfo.ResList.Items[i];
      sgNew.Cells[0,i+1]:=Pres.NameRes;
      sgNew.Objects[0,i+1]:=TObject(Pointer(sizeof(Integer)));
      sgNew.Cells[1,i+1]:=inttohex(PRes.ResDir.Characteristics,8);
      sgNew.Objects[1,i+1]:=TObject(Pointer(8));
      sgNew.Cells[2,i+1]:=inttohex(PRes.ResDir.TimeDateStamp,8);
      sgNew.Objects[2,i+1]:=TObject(Pointer(8));
      sgNew.Cells[3,i+1]:=inttohex(PRes.ResDir.MajorVersion,4);
      sgNew.Objects[3,i+1]:=TObject(Pointer(4));
      sgNew.Cells[4,i+1]:=inttohex(PRes.ResDir.MinorVersion,4);
      sgNew.Objects[4,i+1]:=TObject(Pointer(4));
      sgNew.Cells[5,i+1]:=inttohex(PRes.ResDir.NumberOfNamedEntries,4);
      sgNew.Objects[5,i+1]:=TObject(Pointer(4));
      sgNew.Cells[6,i+1]:=inttohex(PRes.ResDir.NumberOfIdEntries,4);
      sgNew.Objects[6,i+1]:=TObject(Pointer(4));
      case PRes.TypeRes of
        rtlData: begin
          tmps:='This is data';
        end;
        rtlDir: begin
          tmps:='This is directory';
        end;
      end;
      sgNew.Cells[7,i+1]:=tmps;
      sgNew.Objects[7,i+1]:=TObject(Pointer(sizeof(Integer)));
      sgNew.RowCount:=sgNew.RowCount+1;
     end;
     sgNew.RowCount:=sgNew.RowCount-1;
     sgNew.Row:=1;
     sgNew.Col:=0;
     sgNew.Visible:=true;
    end;

    procedure ActiveResourceData;
    var
      RDataE: PIMAGE_RESOURCE_DATA_ENTRY;
      P: PInfResource;
      PMem: Pointer;
      i: Integer;
      CursorResInfo: PCursorResInfo;
      isNot: Boolean;
      hIco: HIcon;
      NewS: TMemoryStream;
      rcdataFlag: Boolean;
      tmps: string;
    begin
      MemS.Clear;
      ClearNewGrid;
      imResData.Visible:=false;
      re.Visible:=false;
      Anim.Visible:=false;
      sgHex.Visible:=false;
      pnResDataBottom.Visible:=true;
      bibSaveToFile.OnClick:=nil;
      bibFont.OnClick:=nil;
      isNot:=true;

      sgNew.OnKeyPress:=nil;
      sgNew.OnSelectCell:=nil;
      sgNew.parent:=pnResDataTop;
      sgNew.InplaceEditor.ReadOnly:=true;
      sgNew.ColCount:=5;
      sgNew.Cells[0,0]:='OffsetToData';
      sgNew.Cells[1,0]:='Size';
      sgNew.Cells[2,0]:='CodePage';
      sgNew.Cells[3,0]:='Reserved';
      sgNew.Cells[4,0]:='Hint';

      i:=0;
      RDataE:=PInfo.ResData;
      if RDataE=nil then exit;
      PMem:=PInfo.ResDataMem;
      if PMem=nil then exit;
      Mems.Write(PMem^,RDataE.Size);
      Mems.Position:=0;
//      ms.SaveToFile('c:\ttt.txt');

      sgNew.Cells[0,i+1]:=inttohex(RDataE.OffsetToData,8);
      sgNew.Objects[0,i+1]:=TObject(Pointer(8));
      sgNew.Cells[1,i+1]:=inttohex(RDataE.Size,8);
      sgNew.Objects[1,i+1]:=TObject(Pointer(8));
      sgNew.Cells[2,i+1]:=inttohex(RDataE.CodePage,8);
      sgNew.Objects[2,i+1]:=TObject(Pointer(8));
      sgNew.Cells[3,i+1]:=inttohex(RDataE.Reserved,8);
      sgNew.Objects[3,i+1]:=TObject(Pointer(8));
      sgNew.Cells[4,i+1]:=Node.Parent.Text;
      sgNew.Objects[4,i+1]:=TObject(Pointer(sizeof(Integer)));

      sgNew.Row:=1;
      sgNew.Col:=0;
      sgNew.Visible:=true;

     try
     if not HexView then
      if PInfo.IsTypeParentName  then begin

       if PInfo.ParentNameRes='TEXT' then begin
        re.Lines.BeginUpdate;
        try
         re.Lines.Clear;
         Re.Lines.LoadFromStream(Mems);
         Re.Visible:=true;
         isNot:=false;
         bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
         bibFont.OnClick:=FontClick_Text;

         pnResDataBottom.Visible:=true;
        finally
         Re.Lines.EndUpdate;
        end;
       end;

       if PInfo.ParentNameRes='REGINST' then begin
        Re.Lines.BeginUpdate;
        try
         Re.Lines.Clear;
         Re.Lines.LoadFromStream(Mems);
         Re.Visible:=true;
         isNot:=false;
         bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
         bibFont.OnClick:=FontClick_Text;
         pnResDataBottom.Visible:=true;
        finally
         Re.Lines.EndUpdate;
        end;
       end;

       if PInfo.ParentNameRes='AVI' then begin
        Anim.Active:=false;
        Anim.FileName:='';
{        if FileExists(tmpFileAvi) then
          DeleteFile(tmpFileAvi); }
        Mems.SaveToFile(tmpFileAvi);
        Anim.FileName:=tmpFileAvi;
        Anim.CommonAVI:=aviNone;
        Anim.Active:=true;
        Anim.Visible:=true;
        isNot:=false;
        bibSaveToFile.OnClick:=bibSaveToFileClick_Avi;
        pnResDataBottom.Visible:=true;
       end;

      end else begin
       case PInfo.TypeParentRes of
        $2000: ; // RT_NEWRESOURCE
        $7FFF: ; // RT_ERROR
        1: begin
          hIco := CreateIconFromResource(Mems.Memory, Mems.Size,false, $30000);
          imResData.Picture.Icon.Handle:=hIco;
          imResData.Visible:=true;
          isNot:=false;
          bibSaveToFile.OnClick:=bibSaveToFileClick_Cursor;
          pnResDataBottom.Visible:=true;
        end; // RT_CURSOR
        2: begin
          NewS:=TMemoryStream.Create;
          try
           BMPGetStream(MemS.Memory,MemS.Size,NewS);
           imResData.Picture.Bitmap.LoadFromStream(NewS);
           imResData.Visible:=true;
           isNot:=false;
           bibSaveToFile.OnClick:=bibSaveToFileClick_Bmp;
           pnResDataBottom.Visible:=true;
          finally
           NewS.Free;
          end;
        end; // RT_BITMAP
        3: begin
          hIco := CreateIconFromResource(Mems.Memory, Mems.Size,true, $30000);
          imResData.Picture.Icon.Handle:=hIco;
          imResData.Visible:=true;
          isNot:=false;
          bibSaveToFile.OnClick:=bibSaveToFileClick_Icon;
          pnResDataBottom.Visible:=true;
        end; // RT_ICON
        4: begin
         NewS:=TMemoryStream.Create;
         try
          Re.Lines.Clear;
          Re.parent:=pnResDataClient;
          Re.Align:=alClient;
          MenuGetStream(MemS.Memory,MemS.Size,NewS);
          Re.Lines.LoadFromStream(NewS);
          Re.Visible:=true;
          isNot:=false;
          bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
          bibFont.OnClick:=FontClick_Text;
          pnResDataBottom.Visible:=true;
         finally
          NewS.Free;
         end;
        end; // RT_MENU
        5: ; // RT_DIALOG
        6: begin
         NewS:=TMemoryStream.Create;
         try
          Re.Lines.Clear;
          Re.parent:=pnResDataClient;
          Re.Align:=alClient;
          StringGetStream(MemS.Memory,MemS.Size,NewS,PInfo.ResDirEntryParent);
          Re.Lines.LoadFromStream(NewS);
          if Trim(Re.Lines.Text)='' then begin
           isNot:=true;
          end else begin
           Re.Visible:=true;
           isNot:=false;
           bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
           bibFont.OnClick:=FontClick_Text;
           pnResDataBottom.Visible:=true;
          end;

         finally
          NewS.Free;
         end;
        end; // RT_STRING
        7: ; // RT_FONTDIR
        8: ; // RT_FONT
        9: ; // RT_ACCELERATORS
        10: begin
         rcdataFlag:=AnsiPos('TPF0',StrPas(Pchar(MemS.Memory)))=0;
         if node.Parent.Text='PACKAGEINFO' then begin
           re.Lines.Clear;
           re.parent:=pnResDataClient;
           re.Align:=alClient;
           GetPackageInfoText(MemS.Memory,MemS.Size,re.Lines);
           if Trim(re.Lines.Text)='' then begin
            isNot:=true;
           end else begin
            re.Visible:=true;
            isNot:=false;
            bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
            bibFont.OnClick:=FontClick_Text;
            pnResDataBottom.Visible:=true;
           end;
           rcdataFlag:=true;
         end;
         if node.Parent.Text='DESCRIPTION' then begin
           re.Lines.Clear;
           re.parent:=pnResDataClient;
           re.Align:=alClient;
           re.Lines.Text:=PWideChar(MemS.Memory);
           if Trim(re.Lines.Text)='' then begin
            isNot:=true;
           end else begin
            re.Visible:=true;
            isNot:=false;
            bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
            bibFont.OnClick:=FontClick_Text;
            pnResDataBottom.Visible:=true;
           end;
           rcdataFlag:=true;
         end;
         if not rcdataFlag then begin
          NewS:=TMemoryStream.Create;
          try
           re.Lines.Clear;
           re.parent:=pnResDataClient;
           re.Align:=alClient;
           ObjectBinaryToText(MemS,NewS);
           NewS.Position:=0;

           re.Lines.LoadFromStream(NewS);
           if Trim(re.Lines.Text)='' then begin
            isNot:=true;
           end else begin
            re.Visible:=true;
            isNot:=false;
            bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
            bibFont.OnClick:=FontClick_Text;
            pnResDataBottom.Visible:=true;
           end;
          finally
           NewS.Free;
          end;
         end;
        end; // RT_RCDATA
        11: ; // RT_MESSAGETABLE
        12: begin
         NewS:=TMemoryStream.Create;
         try
          Re.Lines.Clear;
          Re.parent:=pnResDataClient;
          Re.Align:=alClient;
          GroupCursorGetStream(MemS.Memory,MemS.Size,NewS);
          Re.Lines.LoadFromStream(NewS);
          if Trim(Re.Lines.Text)='' then begin
           isNot:=true;
          end else begin
           Re.Visible:=true;
           isNot:=false;
           bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
           bibFont.OnClick:=FontClick_Text;
           pnResDataBottom.Visible:=true;
          end;

         finally
          NewS.Free;
         end;
        end; // RT_GROUP_CURSOR
        14: begin
         NewS:=TMemoryStream.Create;
         try
          Re.Lines.Clear;
          Re.parent:=pnResDataClient;
          Re.Align:=alClient;
          GroupIconGetStream(MemS.Memory,MemS.Size,NewS);
          Re.Lines.LoadFromStream(NewS);
          if Trim(Re.Lines.Text)='' then begin
           isNot:=true;
          end else begin
           Re.Visible:=true;
           isNot:=false;
           bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
           bibFont.OnClick:=FontClick_Text;
           pnResDataBottom.Visible:=true;
          end;

         finally
          NewS.Free;
         end;
        end; // RT_GROUP_ICON
        16: begin
          Re.Lines.Clear;
          Re.parent:=pnResDataClient;
          Re.Align:=alClient;
          GetVersionText(MemS.Memory,MemS.Size,Re.Lines);
          if Trim(Re.Lines.Text)='' then begin
           isNot:=true;
          end else begin
           Re.Visible:=true;
           isNot:=false;
           bibSaveToFile.OnClick:=bibSaveToFileClick_Text;
           bibFont.OnClick:=FontClick_Text;
           pnResDataBottom.Visible:=true;
          end;
        end; // RT_VERSION
        2 or $2000: ; // RT_BITMAP|RT_NEWRESOURCE
        4 or $2000: ; // RT_MENU|RT_NEWRESOURCE
        5 or $2000: ; // RT_DIALOG|RT_NEWRESOURCE
       end;
      end;

     except
      MessageBox(Application.Handle,'Unknown format.',nil,MB_ICONERROR);
     end;

      if isNot then begin
        sgHex.parent:=pnResDataClient;
        sgHex.Align:=alClient;
        sgHex.OnSelectCell:=sgHexSelectCell;
        sgHex.OnExit:=sgHexExit;
        sgHex.InplaceEditor.ReadOnly:=true;
        sgHex.FixedCols:=1;
        sgHex.FixedColor:=clBtnShadow;
        sgHex.Visible:=true;
        sgHex.RowCount:=2;
        sgHex.ColCount:=18;
        sgHex.ColWidths[0]:=58;
        for i:=0 to 15 do begin
         sgHex.Cells[i+1,0]:=inttohex(i,2);
         sgHex.ColWidths[i+1]:=18;
        end;
        sgHex.ColWidths[17]:=120;
        sgHex.Cells[17,0]:='Text';
        GridFillFromMem(sgHex,Mems.Memory,Mems.Size,Integer(Mems.Memory),RDataE.OffsetToData);
        bibSaveToFile.OnClick:=bibSaveToFileClick_sgHex;
        bibFont.OnClick:=FontClick_Hex;
        pnResDataBottom.Visible:=true;
       end;

       if re.Visible then
        re.Invalidate;
    end;

  begin
     ActiveResourceHead;
//     if PInfo.Level<1 then begin
      case PInfo.TypeRes of
       rtlData: begin
         ActiveResourceData;
       end;
       rtlDir: begin
         ActiveResourceDir;
       end;
     end;
  {  end else begin
     ActiveResourceData;
    end;}
  end;

  procedure ActiveException(PInfo: PInfException);
  begin

  end;

  procedure ActiveSecurity(PInfo: PInfSecurity);
  begin

  end;

  procedure ActiveBaseRelocs(PInfo: PInfListBaseRelocs);
  var
    PBaseReloc: PInfBaseReloc;
    i: Integer;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_BaseRelocs;
    sg.OnSelectCell:=sgSelectCell_BaseRelocs;
    sg.parent:=pnBaseRelocs_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=3;
    sg.Cells[0,0]:='VirtualAddress';
    sg.Cells[1,0]:='SizeOfBlock';
    sg.Cells[2,0]:='Hint';
    for i:=0 to PInfo.List.Count-1 do begin
      PBaseReloc:=PInfo.List.Items[i];
      sg.Cells[0,i+1]:=inttohex(PBaseReloc.PIB.VirtualAddress,8);
      sg.Objects[0,i+1]:=TObject(Pointer(8));
      sg.Cells[1,i+1]:=inttohex(PBaseReloc.PIB.SizeOfBlock,8);
      sg.Objects[1,i+1]:=TObject(Pointer(8));
      sg.Cells[2,i+1]:='';
      sg.Objects[2,i+1]:=TObject(Pointer(sizeof(INteger)));
      sg.RowCount:=sg.RowCount+1;
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveBaseReloc(PInfo: PInfBaseReloc);
  var
    PBaseRelocName: PInfBaseRelocname;
    i: integer;
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_BaseRelocs;
    sg.OnSelectCell:=sgSelectCell_BaseRelocs;
    sg.parent:=pnBaseReloc_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=2;
    sg.Cells[0,0]:='Address';
    sg.Cells[1,0]:='TypeReloc';
    for i:=0 to PInfo.List.Count-1 do begin
     PBaseRelocName:=PInfo.List.Items[i];
     sg.Cells[0,i+1]:=inttohex(PBaseRelocName.Address,8);
     sg.Objects[0,i+1]:=TObject(Pointer(8));
     sg.Cells[1,i+1]:=PBaseRelocName.TypeReloc;
     sg.Objects[1,i+1]:=TObject(Pointer(sizeof(Integer)));
     sg.RowCount:=sg.RowCount+1;
    end;
    sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveDebugs(PInfo: PInfListDebugs);
  var
    PDebug: PInfDebug;
    i: Integer;
    szDebugFormat: string;
  const
     SzDebugFormats :array [0..6] of string =('UNKNOWN/BORLAND',
                                             'COFF','CODEVIEW','FPO',
                                             'MISC','EXCEPTION','FIXUP');
  begin
    ClearGrid;
    sg.OnKeyPress:=sgKeyPress_BaseRelocs;
    sg.OnSelectCell:=sgSelectCell_BaseRelocs;
    sg.parent:=pndebugs_Main;
//    sg.InplaceEditor.PopupMenu:=pmNone;
    sg.ColCount:=9;
    sg.Cells[0,0]:='Characteristics';
    sg.Cells[1,0]:='TimeDateStamp';
    sg.Cells[2,0]:='MajorVersion';
    sg.Cells[3,0]:='MinorVersion';
    sg.Cells[4,0]:='_Type';
    sg.Cells[5,0]:='SizeOfData';
    sg.Cells[6,0]:='AddressOfRawData';
    sg.Cells[7,0]:='PointerToRawData';
    sg.Cells[8,0]:='Hint';

    for i:=0 to PInfo.List.Count-1 do begin
      PDebug:=PInfo.List.Items[i];
      sg.Cells[0,i+1]:=inttohex(PDebug.Characteristics,8);
      sg.Objects[0,i+1]:=TObject(Pointer(8));
      sg.Cells[1,i+1]:=inttohex(PDebug.TimeDateStamp,8);
      sg.Objects[1,i+1]:=TObject(Pointer(8));
      sg.Cells[2,i+1]:=inttohex(PDebug.MajorVersion,4);
      sg.Objects[2,i+1]:=TObject(Pointer(4));
      sg.Cells[3,i+1]:=inttohex(PDebug.MinorVersion,4);
      sg.Objects[3,i+1]:=TObject(Pointer(4));
      sg.Cells[4,i+1]:=inttohex(PDebug._Type,8);
      sg.Objects[4,i+1]:=TObject(Pointer(8));
      sg.Cells[5,i+1]:=inttohex(PDebug.SizeOfData,8);
      sg.Objects[5,i+1]:=TObject(Pointer(8));
      sg.Cells[6,i+1]:=inttohex(PDebug.AddressOfRawData,8);
      sg.Objects[6,i+1]:=TObject(Pointer(8));
      sg.Cells[7,i+1]:=inttohex(PDebug.PointerToRawData,8);
      sg.Objects[7,i+1]:=TObject(Pointer(8));
      if PDebug._Type<7 then
       szDebugFormat:= SzDebugFormats[PDebug._Type]
      else szDebugFormat:='UNKNOWN';
      sg.Cells[8,i+1]:=szDebugFormat;
      sg.Objects[8,i+1]:=TObject(Pointer(sizeof(Integer)));
      sg.RowCount:=sg.RowCount+1;
    end;
    if sg.RowCount>2 then
     sg.RowCount:=sg.RowCount-1;
    sg.Visible:=true;
  end;

  procedure ActiveCopyright(PInfo: PInfCopyright);
  begin

  end;

  procedure ActiveGlobalPtr(PInfo: PInfGlobalPtr);
  begin

  end;

  procedure ActiveTls(PInfo: PInfTls);
  begin

  end;

  procedure ActiveLoadconfig(PInfo: PInfLoadConfig);
  begin

  end;

  procedure ActiveBoundImport(PInfo: PInfBoundImport);
  begin

  end;

  procedure ActiveIat(PInfo: PInfIat);
  begin

  end;

  procedure Active13(PInfo: PInf13);
  begin

  end;

  procedure Active14(PInfo: PInf14);
  begin

  end;

  procedure Active15(PInfo: PInf15);
  begin

  end;


var
  P: PInfNode;
begin
  P:=Node.Data;
  if P=nil then exit;
  Screen.Cursor:=crHourGlass;
  try
   fdFileInfo.CloseDialog;
   btApply.Enabled:=false;
   ntbInfo.Visible:=true;
   ntbInfo.PageIndex:=Integer(P.tpNode);
   TypeNode:=P.tpNode;
   pnTopStatus.Visible:=true;
   lbTopStatus.Caption:=Node.Text;
   case P.tpNode of
    tpnFileName: ActiveFileName(P.PInfo);
    tpnDosHeader: ActiveDosHeader(P.PInfo);
    tpnNtHeader: ActiveNtHeader(P.PInfo);
    tpnFileHeader: ActiveFileHeader(P.PInfo);
    tpnOptionalHeader: ActiveOptionalHeader(P.PInfo);
    tpnSections: ActiveSections(P.PInfo);
    tpnSectionHeader: ActiveSectionHeader(P.PInfo);
    tpnExports: ActiveExports(P.PInfo);
    tpnImports: ActiveImports(P.PInfo);
    tpnImport: ActiveImport(P.PInfo);
    tpnResources: ActiveResources(P.PInfo);
    tpnResource:
      ActiveResource(P.PInfo);
    tpnException: ActiveException(P.PInfo);
    tpnSecurity: ActiveSecurity(P.PInfo);
    tpnBaseRelocs: ActiveBaseRelocs(P.PInfo);
    tpnBaseReloc: ActiveBaseReloc(P.PInfo);
    tpnDebugs: ActiveDebugs(P.PInfo);
    tpnCopyright: ActiveCopyright(P.PInfo);
    tpnGlobalptr: ActiveGlobalptr(P.PInfo);
    tpnTls: ActiveTls(P.PInfo);
    tpnLoadconfig: ActiveLoadconfig(P.PInfo);
    tpnBoundImport: ActiveBoundImport(P.PInfo);
    tpnIat: ActiveIat(P.PInfo);
    tpn13: Active13(P.PInfo);
    tpn14: Active14(P.PInfo);
    tpn15: Active15(P.PInfo);
   end;
   SetGridColWidth;
   SetNewGridColWidth;

  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmFileInfo.GridFillFromMem(grid: TStringGrid; ProcMem: Pointer; MemSize: Integer;
                                     lpAddress,Offset: Integer);

  function GetStrFromLine(IndLine: Integer): string;
  var
   ret: string;
   i: Integer;
   b: byte;
   ch: char;
   tmps: string;
  begin
    for i:=1 to 16 do begin
      tmps:=sgHex.Cells[IndLine,i];
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
  rw: Integer;
  dw: Byte;
begin
  badr:=Integer(lpAddress);
  if (MemSize mod 16)<>0 then
   dw:=1 else dw:=0;
  rw:=(MemSize div 16)+dw+1;
  sgHex.RowCount:=rw;
  j:=0;
  for i:=badr to badr+MemSize+(16-(MemSize mod 16)) do begin
    if (i>=badr) and (i<=badr+MemSize) then
     Move(Pointer(LongInt(ProcMem)+j)^,ch,1)
    else
     ch:=#0; 
    b:=Byte(ch);
    tmps:=tmps+ch;
    celid:=1+(j mod 16);
    rowid:=(j div 16)+1;
    sgHex.Cells[celid,rowid]:=inttohex(b,2);
    if (j mod 16)=0 then begin
      sgHex.Cells[0,(j div 16)+1]:=inttohex(Offset,8);
    end;
    inc(Offset);
    inc(j);
    if (j mod 16)=0 then begin
      sgHex.Cells[17,(j div 16)]:=tmps;
      tmps:='';
    end;
  end;
end;

procedure TfmFileInfo.sgHexSelectCell(Sender: TObject; ACol, ARow: Integer;
                       var CanSelect: Boolean);
var
  SizeText: Integer;
  value: integer;
  tmps: string;
  i: Integer;
  ch: Char;
begin
  if OldColHex=sg.ColCount-2 then begin
    if Trim(sg.Cells[OldColHex,OldRowHex])='' then begin
      SizeText:=Integer(Pointer(sg.Objects[OldColHex,OldRowHex]));
      sg.HideEditor;
//      sg.Cells[OldCol,OldRow]:=inttohex(0,SizeText);
    end else begin
     if (OldRowHex>sg.FixedRows-1) and (OldColHex>sg.FixedCols-1) then begin
      SizeText:=Integer(Pointer(sg.Objects[OldColHex,OldRowHex]));
//      value:=strtoint('$'+Trim(sg.Cells[OldCol,OldRow]));
      sg.HideEditor;
//      sg.Cells[OldCol,OldRow]:=inttohex(value,SizeText);
     end;
    end;
  end else begin
    sg.HideEditor;
    SetTextFromHex(true);
  end;
  OldRowHex:=ARow;
  OldColHex:=ACol;
end;

procedure TfmFileInfo.SetTextFromHex(Hideedit: Boolean);
var
  i: Integer;
  ch: char;
  tmps: string;
begin
  tmps:='';
  for i:=1 to 16 do begin
   ch:=Char(strtoint('$'+sgHex.Cells[i,sgHex.Row]));
   tmps:=tmps+ch;
  end;
  if HideEdit then sgHex.HideEditor;
  sgHex.Cells[17,sgHex.Row]:=tmps;
end;

procedure TfmFileInfo.sgHexExit(Sender: TObject);
begin
 if sgHex.RowCount<>2 then
  SetTextFromHex(true);
end;

procedure TfmFileInfo.sgHexDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

  procedure DrawCol0;
  var
   wh,Offset,th: Integer;
   dy: Integer;
  begin
   wh:=3;//sg.DefaultRowHeight;
   with sgHex.Canvas do  { draw on control canvas, not on the form }
   begin
    FillRect(Rect);       { clear the rectangle }
    Font.Color:=clWhite;
//    Font.Style:=[fsBold];
    Rectangle(rect);
    Offset:=wh;
    th:=TextHeight(sgHex.Cells[ACol,ARow]);
    dy:=((Rect.Bottom-Rect.Top)div 2)-th div 2;
    if (ACol=0) or (ARow=0) then begin
     if not((ACol=0) and (ARow=0)) then
      TextOut(Rect.Left + Offset, Rect.Top+dy, sgHex.Cells[ACol,ARow])  { display the text }
    end;
   end;
  end;

begin
  if (Acol=0) then DrawCol0;
  if (ARow=0) then DrawCol0;
end;

procedure TfmFileInfo.bibSaveToFileClick_sgHex(Sender: TObject);
begin
  sd.Filter:=FilterAllFiles;
  if not sd.Execute then exit;
  Mems.SaveToFile(sd.FileName);
end;

procedure TfmFileInfo.bibSaveToFileClick_Text(Sender: TObject);
var
  ms: TMemoryStream;
begin
  sd.Filter:=FilterTxtFiles;
  if not sd.Execute then exit;
  ms:=TMemoryStream.Create;
  try
   ms.Write(Pchar(Re.Text)^,length(Re.Text));
   ms.SaveToFile(sd.FileName);
  finally
   ms.Free;
  end;
end;

procedure TfmFileInfo.bibSaveToFileClick_Cursor(Sender: TObject);
begin
  exit;
  sd.Filter:=FilterCursorFiles;
  if not sd.Execute then exit;
  if not imResData.Picture.Icon.Empty then
   imResData.Picture.SaveToFile(sd.FileName);
end;

procedure TfmFileInfo.bibSaveToFileClick_Avi(Sender: TObject);
begin
  sd.Filter:=FilterAviFiles;
  if not sd.Execute then exit;
  Mems.SaveToFile(sd.FileName);
end;

procedure TfmFileInfo.bibSaveToFileClick_Bmp(Sender: TObject);
begin
  sd.Filter:=FilterBmpFiles;
  if not sd.Execute then exit;
  if not imResData.Picture.Bitmap.Empty then
   imResData.Picture.Bitmap.SaveToFile(sd.FileName);
end;

procedure TfmFileInfo.bibSaveToFileClick_Icon(Sender: TObject);
begin
  sd.Filter:=FilterIcoFiles;
  if not sd.Execute then exit;
  if not imResData.Picture.Icon.Empty then
   imResData.Picture.SaveToFile(sd.FileName);
end;

procedure TfmFileInfo.miExpandClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  nd:=tv.Selected;
  if nd=nil then exit;
  nd.Expand(true);
end;

procedure TfmFileInfo.miCollapseClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  nd:=tv.Selected;
  if nd=nil then exit;
  nd.Collapse(true);
end;

procedure TfmFileInfo.miExpandAllClick(Sender: TObject);
begin
  TV.FullExpand;
end;

procedure TfmFileInfo.miCollapseAllClick(Sender: TObject);
begin
  TV.FullCollapse;
end;

procedure TfmFileInfo.miViewFindInTvClick(Sender: TObject);
begin
 fdTvFileInfo.FindText:=FindStringInTreeView;
 if Tv.Selected<>nil then
   FPosInTreeView:=Tv.Selected.AbsoluteIndex+1;
 if fdTvFileInfo.Execute then begin

 end;
end;

procedure TfmFileInfo.fdTvFileInfoFind(Sender: TObject);
begin
  FindInTreeView;
end;

procedure TfmFileInfo.FindInTreeView;

   function GetNodeFromText(Text: string; fdDown,fdCase,fdWholeWord: Boolean): TTreeNode;
   var
     i: Integer;
     nd: TTreeNode;
     APos: Integer;
   begin
    result:=nil;
    if fdDown then begin
     if FPosInTreeView>=Tv.Items.Count-1 then begin
      FPosInTreeView:=0;
     end;
     for i:=FPosInTreeView to Tv.Items.Count-1 do begin
       nd:=Tv.Items[i];
       if fdCase then begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(Text,nd.Text)
         else APos:=0;
        end else Apos:=Pos(Text,nd.Text);
       end else begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text))
         else APos:=0;
        end else Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text));
       end;
       if Apos<>0 then begin
         FPosInTreeView:=i+1;
         result:=nd;
         exit;
       end;
     end;
    end else begin
     if FPosInTreeView<=0 then FPosInTreeView:=Tv.Items.Count-1;
     for i:=FPosInTreeView downto 0 do begin
       nd:=Tv.Items[i];
       if fdCase then begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(Text,nd.Text)
         else APos:=0;
        end else Apos:=Pos(Text,nd.Text);
       end else begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text))
         else APos:=0;
        end else Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text));
       end;
       if Apos<>0 then begin
         FPosInTreeView:=i-1;
         result:=nd;
         exit;
       end;
     end;
    end;
   end;

var
  nd: TTreeNode;
  fdDown,fdCase,fdWholeWord: Boolean;
begin
  fdDown:=(frDown in fdTvFileInfo.Options);
  fdCase:=(frMatchCase in fdTvFileInfo.Options);
  fdWholeWord:=(frWholeWord in fdTvFileInfo.Options);
  nd:=GetNodeFromText(fdTvFileInfo.FindText,fdDown,fdCase,fdWholeWord);
  if nd<>nil then begin
   FindStringInTreeView:=fdTvFileInfo.FindText;
   nd.MakeVisible;
   nd.Expand(false);
   tv.Selected:=nd;
  end else
   FPosInTreeView:=0;
end;


procedure TfmFileInfo.chbHexViewClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  ActiveInfo(nd,chbHexView.Checked);
end;

procedure TfmFileInfo.GroupCursorGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
var
  str: TStringList;
  P: PCursorResInfo;
  PIcon: PIconHeader;
  tmps: string;
  i: Integer;
const
  fmtPlus='%d X %d %d Bit(s); Cursor Ordinal: %d';
begin
  str:=TStringList.Create;
  try
   str.BeginUpdate;
   try
     str.Clear;
     P:=Pointer(Integer(Memory)+sizeof(TIconHeader));
     PIcon:=Memory;
     tmps:=Format(fmtPlus,[P.wWidth, P.wWidth, P.wBitCount,P.wNameOrdinal]);
     str.Add(tmps);
     for i:=0 to PIcon^.wCount-2 do begin
       inc(P);
       tmps:=Format(fmtPlus,[P.wWidth, P.wWidth, P.wBitCount,P.wNameOrdinal]);
       str.Add(tmps);
     end;
   finally
     str.EndUpdate;
   end;
   str.SaveToStream(Stream);
   Stream.Position:=0;
  finally
   str.Free;
  end;
end;

procedure TfmFileInfo.GroupIconGetStream(Memory: Pointer; Size: Integer; Stream: TMemoryStream);
var
  str: TStringList;
  P: PIconResInfo;
  PIcon: PIconHeader;
  tmps: string;
  i: Integer;
const
  fmtPlus='%d X %d %d Bit(s); Icon Ordinal: %d';
begin
  str:=TStringList.Create;
  try
   str.BeginUpdate;
   try
     str.Clear;
     P:=Pointer(Integer(Memory)+sizeof(TIconHeader));
     PIcon:=Memory;
     tmps:=Format(fmtPlus,[P.bWidth, P.bWidth, P.wBitCount,P.wNameOrdinal]);
     str.Add(tmps);
     for i:=0 to PIcon^.wCount-2 do begin
       inc(P);
       tmps:=Format(fmtPlus,[P.bWidth, P.bWidth, P.wBitCount,P.wNameOrdinal]);
       str.Add(tmps);
     end;
   finally
     str.EndUpdate;
   end;
   str.SaveToStream(Stream);
   Stream.Position:=0;
  finally
   str.Free;
  end;
end;

procedure TfmFileInfo.GetPackageInfoText(Memory: Pointer; Size: Integer; List: TStrings);
var
  InfoTable: PPackageInfoHeader;
  I: Integer;
  PkgName: PPkgName;
  UName: PUnitName;
  Count: Integer;
  tmps: string;
begin
  InfoTable := PPackageInfoHeader(Memory);
  List.BeginUpdate;
  try
   tmps:=Format('Flags: %x RequiresCount: %x',[InfoTable.Flags, InfoTable.RequiresCount]);
   List.Add(tmps);
   with InfoTable^ do
   begin
    PkgName := PPkgName(Integer(InfoTable) + SizeOf(InfoTable^));
    Count := RequiresCount;
    if Count>0 then begin
     List.Add('');
     List.Add('Packages:');
     List.Add('HashCode'+#9+'Name');
     List.Add('--------------------------------------------');
    end;
    for I := 0 to Count - 1 do
    begin
      tmps:=Format('%x'+#9+#9+'%s',[PkgName.HashCode, PkgName.Name]);
      List.Add(tmps);
      Inc(Integer(PkgName), StrLen(PkgName.Name) + 2);
    end;
    Count := Integer(Pointer(PkgName)^);
    UName := PUnitName(Integer(PkgName) + 4);
    if Count>0 then begin
     List.Add('');
     List.Add('Units:');
     List.Add('Flags'+#9+'HashCode'+#9+'Name');
     List.Add('------------------------------------------------------------');

    end;
    for I := 0 to Count - 1 do
    begin
      tmps:=inttohex(UName.Flags,2)+#9+inttohex(UName.HashCode,2)+#9+#9+Format('%s',[UName.Name]);
      List.Add(tmps);
      Inc(Integer(UName), StrLen(UName.Name) + 3);
    end;
   end;
  finally
    List.EndUpdate;
  end;
end;

procedure TfmFileInfo.FontClick_Hex(Sender: TObject);
begin
  fd.Font.Assign(sgHex.Font);
  if not fd.Execute then exit;
  sgHex.Font.Assign(fd.Font);
end;

procedure TfmFileInfo.FontClick_Text(Sender: TObject);
begin
  fd.Font.Assign(RE.Font);
  if not fd.Execute then exit;
  re.Font.Assign(fd.Font);
end;

procedure TfmFileInfo.GetVersionText(Memory: Pointer; Size: Integer; List: TStrings);

  function GetFileFlags(Flag: Cardinal): string;
  begin
    Result:='UNKNOWN';
    case Flag of
      VS_FF_DEBUG: Result:='DEBUG';
      VS_FF_PRERELEASE: Result:='PRERELEASE';
      VS_FF_PATCHED: Result:='PATCHED';
      VS_FF_PRIVATEBUILD: Result:='PRIVATEBUILD';
      VS_FF_INFOINFERRED: Result:='INFOINFERRED';
      VS_FF_SPECIALBUILD: Result:='SPECIALBUILD';
    end;
  end;

  function GetFileOs(Flag: Cardinal): string;
  begin
    Result:='UNKNOWN';
    case Flag of
      VOS_UNKNOWN: Result:='UNKNOWN';
      VOS_DOS: Result:='DOS';
      VOS_OS216: Result:='OS216';
      VOS_OS232: Result:='OS232';
      VOS_NT: Result:='NT';
      VOS__WINDOWS16: Result:='WINDOWS16';
      VOS__PM16: Result:='PM16';
      VOS__PM32: Result:='PM32';
      VOS__WINDOWS32: Result:='WINDOWS32';
      VOS_DOS_WINDOWS16: Result:='DOS_WINDOWS16';
      VOS_DOS_WINDOWS32: Result:='DOS_WINDOWS32';
      VOS_OS216_PM16: Result:='OS216_PM16';
      VOS_OS232_PM32: Result:='OS232_PM32';
      VOS_NT_WINDOWS32: Result:='NT_WINDOWS32';
    end;
  end;

  function GetFileType(FileType: Cardinal): string;
  begin
    Result:='UNKNOWN';
    case FileType of
       VFT_UNKNOWN: Result:='UNKNOWN';
       VFT_APP: Result:='APP';
       VFT_DLL: Result:='DLL';
       VFT_DRV: Result:='DRV';
       VFT_FONT: Result:='FONT';
       VFT_VXD: Result:='VXD';
       VFT_STATIC_LIB: Result:='STATIC_LIB';
    end;
  end;

  function GetFileSubType(FileType: Cardinal): string;
  begin
    Result:='UNKNOWN';
    case FileType of
       VFT2_UNKNOWN: Result:='UNKNOWN';
       VFT2_DRV_PRINTER: Result:='PRINTER';
       VFT2_DRV_KEYBOARD: Result:='KEYBOARD';
       VFT2_DRV_LANGUAGE: Result:='LANGUAGE';
       VFT2_DRV_DISPLAY: Result:='DISPLAY';
       VFT2_DRV_MOUSE: Result:='MOUSE';
       VFT2_DRV_NETWORK: Result:='NETWORK';
       VFT2_DRV_SYSTEM: Result:='SYSTEM';
       VFT2_DRV_INSTALLABLE: Result:='INSTALLABLE';
       VFT2_DRV_SOUND: Result:='SOUND';
       VFT2_DRV_COMM: Result:='COMM';
    end;
  end;

  function GetFileDate(FileDateMS,FileDateLS: Cardinal): string;
  begin
    Result:='00:00:00  00.00.0000';
    //Inttohex(FileDateMS,8)+#9+inttohex(FileDateLS,8);
  end;

var
  VerValue: PVSFixedFileInfo;
  VarFileInfo,StringVarFileInfo: PVSVERSIONINFO;
  PInfo: PVSVERSIONINFO;
  dwLen: DWord;
  tmps: string;
begin
  List.BeginUpdate;
  try
    PInfo:=Memory;
    tmps:='Length: '+inttohex(PInfo.wLength,4);
    List.Add(tmps);
    tmps:='ValueLength: '+inttohex(PInfo.wValueLength,4);
    List.Add(tmps);
    tmps:='Type: '+inttohex(PInfo.wType,4);
    List.Add(tmps);
    tmps:=Format('Name: %s',[PInfo.szKey]);
    List.Add(tmps);
    VerValue:=nil;
    VerQueryValue(Memory,'\', Pointer(VerValue), dwLen);
    if VerValue<>nil then begin
     List.Add('');
     tmps:='FixedFileInfo:';
     List.Add(tmps);
     tmps:='Signature: '+inttohex(VerValue.dwSignature,8);
     List.Add(tmps);
     tmps:=Format('StrucVersion: %d.%d',[HiWord(VerValue.dwStrucVersion),LoWord(VerValue.dwStrucVersion)]);
     List.Add(tmps);
     tmps:=Format('FileVersion: %d.%d.%d.%d',[HiWord(VerValue.dwFileVersionMS),
                                             LoWord(VerValue.dwFileVersionMS),
                                             HiWord(VerValue.dwFileVersionLS),
                                             LoWord(VerValue.dwFileVersionLS)]);
     List.Add(tmps);
     tmps:=Format('ProductVersion: %d.%d.%d.%d',[HiWord(VerValue.dwProductVersionMS),
                                             LoWord(VerValue.dwProductVersionMS),
                                             HiWord(VerValue.dwProductVersionLS),
                                             LoWord(VerValue.dwProductVersionLS)]);
     List.Add(tmps);
     tmps:=Format('FileFlagsMask: %d.%d',[HiWord(VerValue.dwFileFlagsMask),
                                             LoWord(VerValue.dwFileFlagsMask)]);
     List.Add(tmps);
     tmps:='FileFlags: '+GetFileFlags(VerValue.dwFileFlags);
     List.Add(tmps);
     tmps:='FileOS: '+GetFileOs(VerValue.dwFileOS);
     List.Add(tmps);
     tmps:='FileType: '+GetFileType(VerValue.dwFileType);
     List.Add(tmps);
     tmps:='FileSubtype: '+GetFileSubType(VerValue.dwFileSubtype);
     List.Add(tmps);
     tmps:='FileDate: '+GetFileDate(VerValue.dwFileDateMS,VerValue.dwFileDateLS);
     List.Add(tmps);
    end;
{    StringVarFileInfo:=nil;
    VerQueryValue(Memory,'\StringFileInfo', Pointer(StringVarFileInfo), dwLen);
    if StringVarFileInfo<>nil then begin
     List.Add('');
     tmps:='StringFileInfo:';
     List.Add(tmps);
     tmps:='Length: '+inttohex(StringVarFileInfo.wLength,4);
     List.Add(tmps);
     tmps:='ValueLength: '+inttohex(StringVarFileInfo.wValueLength,4);
     List.Add(tmps);
     tmps:='Type: '+inttohex(StringVarFileInfo.wType,4);
     List.Add(tmps);
     tmps:=Format('Name: %s',[StringVarFileInfo.szKey]);
     List.Add(tmps);
    end;
    VarFileInfo:=nil;
    VerQueryValue(Memory,'\VarFileInfo', Pointer(VarFileInfo), dwLen);
    if VarFileInfo<>nil then begin
     List.Add('');
     tmps:='VarFileInfo:';
     List.Add(tmps);
     tmps:='Length: '+inttohex(VarFileInfo.wLength,4);
     List.Add(tmps);
     tmps:='ValueLength: '+inttohex(VarFileInfo.wValueLength,4);
     List.Add(tmps);
     tmps:='Type: '+inttohex(VarFileInfo.wType,4);
     List.Add(tmps);
     tmps:=Format('Name: %s',[VarFileInfo.szKey]);
     List.Add(tmps);
    end;     }

  finally
   List.EndUpdate;
  end;
end;


procedure TfmFileInfo.pmTVViewPopup(Sender: TObject);
var
  P: PInfNode;
  Pres: PInfResource;
begin
  miViewFindInTv.Enabled:=true;
  miTVSaveNode.Enabled:=false;
  miTVSaveNode.OnClick:=nil;
  if tv.Selected<>nil then begin
    miExpand.Enabled:=true;
    miCollapse.Enabled:=true;
    P:=tv.Selected.data;
    if P=nil then exit;
    if P.tpNode=tpnResource then begin
     Pres:=P.PInfo;
     if PRes.TypeRes=rtlData then begin
      miTVSaveNode.Enabled:=true;
      miTVSaveNode.OnClick:=bibSaveToFile.OnClick;
     end else begin
       
     end;
    end;
  end else begin
    miExpand.Enabled:=false;
    miCollapse.Enabled:=false;
  end;
end;

procedure TfmFileInfo.TVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  S:=Node.Text;
end;

end.


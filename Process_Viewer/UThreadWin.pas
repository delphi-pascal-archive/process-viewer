unit UThreadWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, UPInfoSInfo, TlHelp32, Menus,
  ImgList, CheckLst;

type
  TfmThWin = class(TForm)
    pnBut: TPanel;
    tv: TTreeView;
    pmTV: TPopupMenu;
    miSend: TMenuItem;
    btRefresh: TBitBtn;
    btSearch: TBitBtn;
    fd: TFindDialog;
    ImageList1: TImageList;
    btClose: TBitBtn;
    btSendMessage: TBitBtn;
    miRefresh: TMenuItem;
    miSearch: TMenuItem;
    N1: TMenuItem;
    MainIl: TImageList;
    pnProp: TPanel;
    pcProp: TPageControl;
    tbsStyles: TTabSheet;
    tbsExStyles: TTabSheet;
    clbStyles: TCheckListBox;
    clbExStyles: TCheckListBox;
    splProp: TSplitter;
    tbsClsStyle: TTabSheet;
    clbClsStyles: TCheckListBox;
    procedure Button1Click(Sender: TObject);
    procedure tvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmTVPopup(Sender: TObject);
    procedure miSendClick(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure fdFind(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miSearchClick(Sender: TObject);
    procedure btSendMessageClick(Sender: TObject);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure clbStylesClickCheck(Sender: TObject);
    procedure clbExStylesClickCheck(Sender: TObject);
    procedure clbClsStylesClickCheck(Sender: TObject);
  private
    FindString: string;

    FPosNode: Integer;
    ProcessIdOld: Longword;
    ThreadIdOld: LongWord;
    procedure FillWindowsFromListThread(const ListThread: TList);
    procedure FillStyles;
    procedure FillExStyles;
    procedure FillClsStyles;
    procedure ClearCheck(clb: TCheckListBox);
    procedure SetStyles(h: HWND);
    procedure SetExStyles(h: HWND);
    procedure SetClsStyles(h: HWND);
  public

    FlagAllThread: Boolean;
    procedure FillWindowsFromThread(ThreadId: LongWord);
    procedure FillWindowsFromProcess(ParentProcessId: LongWord);
  end;

var
  fmThWin: TfmThWin;
  Listtmp: Tlist;

implementation

uses USendMessage, RyMenus;


{$R *.DFM}

function HandleExists(HandleWindow: hwnd): Boolean;
var
  val: Integer;
begin
  result:=false;
  if Listtmp<>nil then begin
   val:=Listtmp.IndexOf(Pointer(HandleWindow));
   if val<>-1 then
     Result:=true;
  end;
end;


function T_EnumThreadWndProc(HandleWindow: hwnd; lParam: Pointer): BOOL;stdcall;
var
  str: array[0..500] of char;
  lp: Integer;
  nd1,nd2: TTreeNode;
  tmps: string;
  clsname: array[0..255] of char;
  Hinst: Longword;
begin
  if not HandleExists(HandleWindow) then begin
   nd1:=TTreeNode(lParam);
   GetClassName(HandleWindow,clsname,Sizeof(clsname));
   Hinst:=GetWindowLong(HandleWindow,GWL_HINSTANCE);
   GetWindowText(HandleWindow,str,Sizeof(str));
   tmps:=str;
   if Trim(tmps)='' then tmps:='...???';
   tmps:='H('+inttoHex(HandleWindow,8)+') CN('+
    clsname+') T('+tmps+') HI('+inttohex(Hinst,8)+')';
   nd2:=fmThWin.tv.Items.AddChild(nd1,tmps);
   nd2.Data:=Pointer(HandleWindow);
   Listtmp.Add(Pointer(HandleWindow));
   nd2.ImageIndex:=1;
   nd2.SelectedIndex:=1;
   lp:=Integer(Pointer(nd2));
   EnumChildWindows(HandleWindow,@T_EnumThreadWndProc,lp);
  end;
   Result:=True;
end;

procedure TfmThWin.FillWindowsFromThread(ThreadId: LongWord);
var
  lParam: LongWord;
  nd: TTreeNode;
begin
 fmThWin:=Self;
 Screen.Cursor:=crHourGlass;
 tv.Items.BeginUpdate;
 try
  Listtmp.Clear;
  ThreadIdOld:=ThreadId;
  nd:=tv.Items.AddChild(nil,'Thread('+inttohex(ThreadId,8)+')');
  nd.ImageIndex:=0;
  nd.SelectedIndex:=0;
  lParam:=LongWord(nd);
  EnumThreadWindows(ThreadId,@T_EnumThreadWndProc,lParam);
  nd.Expand(false);
 finally
  tv.Items.EndUpdate;
  Screen.Cursor:=crDefault;
 end;
end;

procedure TfmThWin.Button1Click(Sender: TObject);
var
  nd: TTreeNode;
  Hh: HWND;
begin
  nd:=tv.selected;
  if nd=nil then exit;
  if nd.AbsoluteIndex=0 then exit;
  Hh:=Longword(nd.Data);
  CloseWindow(Hh);
end;

procedure TfmThWin.FillWindowsFromProcess(ParentProcessId: LongWord);
var
  i: Integer;
  ListThread: TList;
  pInfo: PProcessInfo;
  h: THandle;
  ff: TNtQuerySystemInformation;
  T: TThreadEntry32;
  FCurSnap: THandle;
const
  MaxInfo=65535;
var
  buf: Array[0..MaxInfo] Of Char;
begin
  ProcessIdOld:=ParentProcessId;
  ListThread:=TList.Create;
  try
   if Win32Platform=VER_PLATFORM_WIN32_NT  then begin
    h := LoadLibrary('NTDLL.DLL');
    if h > 0 Then  Begin
     @ff := GetProcAddress(h, 'NtQuerySystemInformation');
     If @ff <> Nil Then Begin
      ff(5, @buf, sizeof(buf), 0);
      pInfo := @buf;
      Repeat
         pInfo := Ptr(LongWord(pInfo) + pInfo.dwOffset);
        if PInfo.dwProcessID=ParentProcessId then begin
         for i:=0 to PInfo.dwThreadCount-1 do begin
            ListThread.Add(Pointer(PInfo.ati[i].dwThreadID));
         end;
        end;

      Until pInfo.dwOffset = 0;
      End;
     end;
    if h>0 then FreeLibrary(h);

   end else begin

     FCurSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, ParentProcessId);
     if FCurSnap = INVALID_HANDLE_VALUE then
       raise Exception.Create(SysErrorMessage(GetLastError));

    T.dwSize := SizeOf(T);
    if Thread32First(FCurSnap, T) then
     repeat
      if T.th32OwnerProcessID=ParentProcessId then begin
        ListThread.Add(Pointer(T.th32ThreadID));
      end;
     until not Thread32Next(FCurSnap, T);

  end;
  FillWindowsFromListThread(ListThread);
  finally
    ListThread.Free;
  end;
end;

procedure TfmThWin.FillWindowsFromListThread(const ListThread: TList);
var
  i: Integer;
  ThreadId: LongWord;
begin
  tv.Items.Clear;
  for i:=0 to ListThread.Count-1 do begin
    ThreadId:=LongWord(ListThread.Items[i]);
    FillWindowsFromThread(ThreadId);
  end;
end;

procedure TfmThWin.tvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  if Shift=[ssRight] then begin
   pt:=Point(X,Y);
   pt:=tv.ClientToScreen(pt);
   pmTV.Popup(pt.x,pt.y);
  end;
end;

procedure TfmThWin.pmTVPopup(Sender: TObject);
var
  nd: TTreeNode;
begin
  miRefresh.Enabled:=true;
  miSearch.Enabled:=true;
  nd:=tv.Selected;
  if nd=nil then begin
    miSend.Enabled:=false;
  end else begin
    if nd.data=nil then miSend.Enabled:=false
    else  miSend.Enabled:=true;
  end;
end;

procedure TfmThWin.btRefreshClick(Sender: TObject);
begin
  if FlagAllThread then begin
    FillWindowsFromProcess(ProcessIdOld);
  end else begin
    tv.Items.Clear;
    FillWindowsFromThread(ThreadIdOld);
  end;
end;

procedure TfmThWin.miSendClick(Sender: TObject);
var
  nd: TTreeNode;
  han: hwnd;
  mes: UINT;
  wp: WPARAM;
  lp: LPARAM;
begin
  nd:=Tv.Selected;
  if nd=nil then exit;
  if nd.data=nil then exit;
  if fmSendMes.rbHex.Checked then begin
   fmSendMes.edHWND.Text:=inttohex(Longword(nd.Data),8);
  end else begin
   fmSendMes.edHWND.Text:=inttostr(Longword(nd.Data));
  end;
  if fmSendMes.ShowModal=mrOk then begin
   if fmSendMes.rbHex.Checked then begin
    han:=hwnd(strtoint('$'+fmSendMes.edHWND.Text));
    mes:=UINT(strtoint('$'+fmSendMes.edMessage.Text));
    wp:=WPARAM(strtoint('$'+fmSendMes.edwParam.Text));
    lp:=LPARAM(strtoint('$'+fmSendMes.edlParam.Text));
   end else begin
    han:=strtoint(fmSendMes.edHWND.Text);
    mes:=strtoint(fmSendMes.edMessage.Text);
    wp:=strtoint(fmSendMes.edwParam.Text);
    lp:=strtoint(fmSendMes.edlParam.Text);
   end;
   SendMessage(han,mes,wp,lp);
//   ShowMessage('Message successfully sent.');
  end;
end;


procedure TfmThWin.btSearchClick(Sender: TObject);
begin
  fd.FindText:=FindString;
  if Tv.Selected<>nil then
   FPosNode:=Tv.Selected.AbsoluteIndex+1;
  if fd.Execute then begin
  end;
end;

procedure TfmThWin.fdFind(Sender: TObject);

   function GetNodeFromText(Text: string; fdDown,fdCase,fdWholeWord: Boolean): TTreeNode;
   var
     i: Integer;
     nd: TTreeNode;
     APos: Integer;
   begin
    result:=nil;
    if fdDown then begin
     if FPosNode>=Tv.Items.Count-1 then begin
      FPosNode:=0;
     end;
     for i:=FPosNode to Tv.Items.Count-1 do begin
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
         FPosNode:=i+1;
         result:=nd;
         exit;
       end;
     end;
    end else begin
     if FPosNode<=0 then FPosNode:=Tv.Items.Count-1;
     for i:=FPosNode downto 0 do begin
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
         FPosNode:=i-1;
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
  fdDown:=(frDown in fd.Options);
  fdCase:=(frMatchCase in fd.Options);
  fdWholeWord:=(frWholeWord in fd.Options);
  nd:=GetNodeFromText(fd.FindText,fdDown,fdCase,fdWholeWord);
  if nd<>nil then begin
   FindString:=fd.FindText;
   nd.MakeVisible;
   nd.Expand(false);
   tv.Selected:=nd;
  end else
   FPosNode:=0;
end;

procedure TfmThWin.FillStyles;
begin
  clbStyles.Items.AddObject('WS_OVERLAPPED',TObject(WS_OVERLAPPED));
  clbStyles.Items.AddObject('WS_POPUP',TObject(WS_POPUP));
  clbStyles.Items.AddObject('WS_CHILD',TObject(WS_CHILD));
  clbStyles.Items.AddObject('WS_MINIMIZE',TObject(WS_MINIMIZE));
  clbStyles.Items.AddObject('WS_VISIBLE',TObject(WS_VISIBLE));
  clbStyles.Items.AddObject('WS_DISABLED',TObject(WS_DISABLED));
  clbStyles.Items.AddObject('WS_CLIPSIBLINGS',TObject(WS_CLIPSIBLINGS));
  clbStyles.Items.AddObject('WS_CLIPCHILDREN',TObject(WS_CLIPCHILDREN));
  clbStyles.Items.AddObject('WS_MAXIMIZE',TObject(WS_MAXIMIZE));
  clbStyles.Items.AddObject('WS_CAPTION',TObject(WS_CAPTION));
  clbStyles.Items.AddObject('WS_BORDER',TObject(WS_BORDER));
  clbStyles.Items.AddObject('WS_DLGFRAME',TObject(WS_DLGFRAME));
  clbStyles.Items.AddObject('WS_VSCROLL',TObject(WS_VSCROLL));
  clbStyles.Items.AddObject('WS_HSCROLL',TObject(WS_HSCROLL));
  clbStyles.Items.AddObject('WS_SYSMENU',TObject(WS_SYSMENU));
  clbStyles.Items.AddObject('WS_THICKFRAME',TObject(WS_THICKFRAME));
  clbStyles.Items.AddObject('WS_GROUP',TObject(WS_GROUP));
  clbStyles.Items.AddObject('WS_TABSTOP',TObject(WS_TABSTOP));
  clbStyles.Items.AddObject('WS_MINIMIZEBOX',TObject(WS_MINIMIZEBOX));
  clbStyles.Items.AddObject('WS_MAXIMIZEBOX',TObject(WS_MAXIMIZEBOX));
{  clbStyles.Items.AddObject('WS_TILED',TObject(WS_TILED));
  clbStyles.Items.AddObject('WS_ICONIC',TObject(WS_ICONIC));
  clbStyles.Items.AddObject('WS_SIZEBOX',TObject(WS_SIZEBOX));
  clbStyles.Items.AddObject('WS_OVERLAPPEDWINDOW',TObject(WS_OVERLAPPEDWINDOW));
  clbStyles.Items.AddObject('WS_TILEDWINDOW',TObject(WS_TILEDWINDOW));
  clbStyles.Items.AddObject('WS_POPUPWINDOW',TObject(WS_POPUPWINDOW));
  clbStyles.Items.AddObject('WS_CHILDWINDOW',TObject(WS_CHILDWINDOW));
 }
end;

procedure TfmThWin.FillExStyles;
begin
  clbExStyles.Items.AddObject('WS_EX_DLGMODALFRAME',TObject(WS_EX_DLGMODALFRAME));
  clbExStyles.Items.AddObject('WS_EX_NOPARENTNOTIFY',TObject(WS_EX_NOPARENTNOTIFY));
  clbExStyles.Items.AddObject('WS_EX_TOPMOST',TObject(WS_EX_TOPMOST));
  clbExStyles.Items.AddObject('WS_EX_ACCEPTFILES',TObject(WS_EX_ACCEPTFILES));
  clbExStyles.Items.AddObject('WS_EX_TRANSPARENT',TObject(WS_EX_TRANSPARENT));
  clbExStyles.Items.AddObject('WS_EX_MDICHILD',TObject(WS_EX_MDICHILD));
  clbExStyles.Items.AddObject('WS_EX_TOOLWINDOW',TObject(WS_EX_TOOLWINDOW));
  clbExStyles.Items.AddObject('WS_EX_WINDOWEDGE',TObject(WS_EX_WINDOWEDGE));
  clbExStyles.Items.AddObject('WS_EX_CLIENTEDGE',TObject(WS_EX_CLIENTEDGE));
  clbExStyles.Items.AddObject('WS_EX_CONTEXTHELP',TObject(WS_EX_CONTEXTHELP));
  clbExStyles.Items.AddObject('WS_EX_RIGHT',TObject(WS_EX_RIGHT));
  clbExStyles.Items.AddObject('WS_EX_LEFT',TObject(WS_EX_LEFT));
  clbExStyles.Items.AddObject('WS_EX_RTLREADING',TObject(WS_EX_RTLREADING));
  clbExStyles.Items.AddObject('WS_EX_LTRREADING',TObject(WS_EX_LTRREADING));
  clbExStyles.Items.AddObject('WS_EX_LEFTSCROLLBAR',TObject(WS_EX_LEFTSCROLLBAR));
  clbExStyles.Items.AddObject('WS_EX_RIGHTSCROLLBAR',TObject(WS_EX_RIGHTSCROLLBAR));
  clbExStyles.Items.AddObject('WS_EX_CONTROLPARENT',TObject(WS_EX_CONTROLPARENT));
  clbExStyles.Items.AddObject('WS_EX_STATICEDGE',TObject(WS_EX_STATICEDGE));
  clbExStyles.Items.AddObject('WS_EX_APPWINDOW',TObject(WS_EX_APPWINDOW));
end;

procedure TfmThWin.FillClsStyles;
begin
  clbClsStyles.Items.AddObject('CS_VREDRAW',TObject(CS_VREDRAW));
  clbClsStyles.Items.AddObject('CS_HREDRAW',TObject(CS_HREDRAW));
  clbClsStyles.Items.AddObject('CS_KEYCVTWINDOW',TObject(CS_KEYCVTWINDOW));
  clbClsStyles.Items.AddObject('CS_DBLCLKS',TObject(CS_DBLCLKS));
  clbClsStyles.Items.AddObject('CS_OWNDC',TObject(CS_OWNDC));
  clbClsStyles.Items.AddObject('CS_CLASSDC',TObject(CS_CLASSDC));
  clbClsStyles.Items.AddObject('CS_PARENTDC',TObject(CS_PARENTDC));
  clbClsStyles.Items.AddObject('CS_NOKEYCVT',TObject(CS_NOKEYCVT));
  clbClsStyles.Items.AddObject('CS_NOCLOSE',TObject(CS_NOCLOSE));
  clbClsStyles.Items.AddObject('CS_SAVEBITS',TObject(CS_SAVEBITS));
  clbClsStyles.Items.AddObject('CS_BYTEALIGNCLIENT',TObject(CS_BYTEALIGNCLIENT));
  clbClsStyles.Items.AddObject('CS_BYTEALIGNWINDOW',TObject(CS_BYTEALIGNWINDOW));
  clbClsStyles.Items.AddObject('CS_GLOBALCLASS',TObject(CS_GLOBALCLASS));
  clbClsStyles.Items.AddObject('CS_IME',TObject(CS_IME));
end;

procedure TfmThWin.FormCreate(Sender: TObject);
begin
  RyMenu.Add(pmTV,nil);
  FPosNode:=0;
  Listtmp:=Tlist.Create;
  FillStyles;
  FillExStyles;
  FillClsStyles;

end;

procedure TfmThWin.tvAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
{var
  rt: Trect;}
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

procedure TfmThWin.FormDestroy(Sender: TObject);
begin
  Listtmp.Free;
end;

procedure TfmThWin.miRefreshClick(Sender: TObject);
begin
  btRefreshClick(nil);
end;

procedure TfmThWin.miSearchClick(Sender: TObject);
begin
 btSearchClick(nil);
end;

procedure TfmThWin.btSendMessageClick(Sender: TObject);
begin
  miSendClick(nil);
end;

procedure TfmThWin.tvChange(Sender: TObject; Node: TTreeNode);
var
  nd: tTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if nd.data=nil then begin
    clbStyles.Color:=clBtnFace;
    clbStyles.Enabled:=false;
    clbExStyles.Color:=clBtnFace;
    clbExStyles.Enabled:=false;
    clbClsStyles.Color:=clBtnFace;
    clbClsStyles.Enabled:=false;
    ClearCheck(clbStyles);
    ClearCheck(clbExStyles);
    ClearCheck(clbClsStyles);

  end else begin
    clbStyles.Color:=clWindow;
    clbStyles.Enabled:=true;
    clbExStyles.Color:=clWindow;
    clbExStyles.Enabled:=true;
    clbClsStyles.Color:=clWindow;
    clbClsStyles.Enabled:=true;
    ClearCheck(clbStyles);
    ClearCheck(clbExStyles);
    ClearCheck(clbClsStyles);
    SetStyles(Longword(nd.data));
    SetExStyles(Longword(nd.data));
    SetClsStyles(Longword(nd.data));

  end;
end;

procedure TfmThWin.ClearCheck(clb: TCheckListBox);
var
  i: Integer;
begin
  for i:=0 to clb.Items.Count-1 do begin
   clb.Checked[i]:=false;
  end;
end;

procedure TfmThWin.SetStyles(h: HWND);
var
  WL: LongInt;
  i: Integer;
begin
  WL:=GetWindowLong(h,GWL_STYLE);
  for i:= 0 to clbStyles.Items.Count -1 do
   if ((LongInt(clbStyles.Items.Objects[i])) and WL) <> 0 then
    clbStyles.Checked[i]:= True
   else
    clbStyles.Checked[i]:= False;
end;

procedure TfmThWin.SetExStyles(h: HWND);
var
  WL: LongInt;
  i: Integer;
begin
  WL:=GetWindowLong(h, GWL_EXSTYLE);
  for i:= 0 to clbExStyles.Items.Count -1 do
   if ((LongInt(clbExStyles.Items.Objects[i])) and WL) <> 0 then
    clbExStyles.Checked[i]:= True
   else
    clbExStyles.Checked[i]:= False;
end;

procedure TfmThWin.SetClsStyles(h: HWND);
var
  WL: LongInt;
  i: Integer;
begin
  WL:=GetWindowLong(h, GCL_STYLE);
  for i:= 0 to clbClsStyles.Items.Count -1 do
   if ((LongInt(clbClsStyles.Items.Objects[i])) and WL) <> 0 then
    clbClsStyles.Checked[i]:= True
   else
    clbClsStyles.Checked[i]:= False;
end;

procedure TfmThWin.clbStylesClickCheck(Sender: TObject);
var
  NewStyle: Longint;
  nd: tTreeNode;
  i: Integer;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if nd.data=nil then exit;
  NewStyle:= 0;
  for i:=0 to clbStyles.Items.Count -1 do begin
   if clbStyles.Checked[i] then
    NewStyle:=NewStyle or LongInt(clbStyles.Items.Objects[i]);
  end;
  SetWindowLong(LongWord(nd.data),GWL_STYLE,NewStyle);
end;

procedure TfmThWin.clbExStylesClickCheck(Sender: TObject);
var
  NewStyle: Longint;
  nd: tTreeNode;
  i: Integer;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if nd.data=nil then exit;
  NewStyle:= 0;
  for i:=0 to clbExStyles.Items.Count -1 do begin
   if clbExStyles.Checked[i] then
    NewStyle:=NewStyle or LongInt(clbExStyles.Items.Objects[i]);
  end;
  SetWindowLong(LongWord(nd.data),GWL_EXSTYLE,NewStyle);
end;

procedure TfmThWin.clbClsStylesClickCheck(Sender: TObject);
var
  NewStyle: Longint;
  nd: tTreeNode;
  i: Integer;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if nd.data=nil then exit;
  NewStyle:= 0;
  for i:=0 to clbClsStyles.Items.Count -1 do begin
   if clbClsStyles.Checked[i] then
    NewStyle:=NewStyle or LongInt(clbClsStyles.Items.Objects[i]);
  end;
  SetWindowLong(LongWord(nd.data),GCL_STYLE,NewStyle);
end;

end.

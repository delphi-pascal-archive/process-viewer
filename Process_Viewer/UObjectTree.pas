unit UObjectTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, tsvgrids, Tabnotbk, Menus;

type

  TTypeCompiler=(tcUknown,tcBorlandDelphi);

  TfmObjectTree = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btSend: TBitBtn;
    BitBtn2: TBitBtn;
    pnTop: TPanel;
    lbCompiler: TLabel;
    IL: TImageList;
    ntb: TNotebook;
    pnR: TPanel;
    spl: TSplitter;
    pnTV: TPanel;
    TV: TTreeView;
    pnCase: TPanel;
    rbtOwner: TRadioButton;
    rbtParent: TRadioButton;
    btRefresh: TBitBtn;
    btSearch: TBitBtn;
    pmTV: TPopupMenu;
    miRefresh: TMenuItem;
    miSearch: TMenuItem;
    fd: TFindDialog;
    MainIl: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TVClick(Sender: TObject);
    procedure TVKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rbtOwnerClick(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miSearchClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure fdFind(Sender: TObject);
  private
    FObjectInstance: Pointer;
    FDefClientProc: TFarProc;
    FClientHandle: THandle;
    FindString: string;
    FPosNode: Integer;
    tpCompiler: TTypeCompiler;
    ObjInsp: TtsvPnlInspector;
    LastNode: TTreeNode;
    newApp: TApplication;
    newScr: TScreen;
    function GetCompilerStr:String;
    procedure FillTreeView;
    procedure UpdateInspector(nd: TTreeNode);
    procedure GetNodeFromComponent(Com: TComponent; List: TList);
    function GetStrFromComp(ct: TComponent): String;
    procedure WndProc(var Message: TMessage); override;
    procedure ActiveObjectTree;
  public
    isShow: Boolean;
    procedure ChangeTreeNode(Com: TComponent);
    procedure ViewApplicationObjects(ProcessID: LongWord);
  end;

var
  fmObjectTree: TfmObjectTree;
const
  WMUserdef=WM_USER+1;

implementation

uses RyMenus;


{$R *.DFM}

function TfmObjectTree.GetCompilerStr:String;
const
  Compiler='Compiler: ';
  CompilerUnknown='Unknown';
  CompilerBorland='Borland Delphi';
begin
  case tpCompiler of
    tcUknown: Result:=Compiler+CompilerUnknown;
    tcBorlandDelphi: Result:=Compiler+CompilerBorland;
  end;
end;

procedure TfmObjectTree.ViewApplicationObjects(ProcessID: LongWord);
var
  AtomText: array[0..31] of Char;
  atm: ATOM;
begin
  StrFmt(AtomText, 'Delphi%.8X',[ProcessID]);
  atm:=GlobalFindAtom(AtomText);
  if atm<>0 then begin
    tpCompiler:=tcBorlandDelphi;
  end;
  lbCompiler.Caption:=GetCompilerStr;
{  if FObjectInstance <> nil then FreeObjectInstance(FObjectInstance);
  FObjectInstance := MakeObjectInstance(WndProc);
  FClientHandle:= FindWindow(Pchar('TApplication'),nil);
  FDefClientProc := Pointer(GetWindowLong(FClientHandle, GWL_WNDPROC));
  SetWindowLong(FClientHandle, GWL_WNDPROC, Longint(FObjectInstance));
  SendMessage(FClientHandle,WMUserdef,0,0);

  {GetClassInfo(MainInstance,);}
  newApp:=Application;
  newScr:=Screen;
  ActiveObjectTree;
end;

function TfmObjectTree.GetStrFromComp(ct: TComponent): String;
var
     strClsName,strName: string;
begin
     if trim(ct.Name)='' then
      strName:='None'
     else strName:=ct.Name;
     strClsName:=ct.ClassName;
     Result:=strName+': '+strClsName;
end;


procedure TfmObjectTree.FillTreeView;

   procedure FillTreeViewObjectsOwner(ct: TComponent; ndcur: TTreeNode);
   var
     i: Integer;
     ndnew: TTreeNode;
     ctnew: TComponent;
   begin
     for i:=0 to ct.ComponentCount-1 do begin
       ctnew:=ct.Components[i];
       ndnew:=TV.Items.AddChildObject(ndcur,GetStrFromComp(ctnew),Pointer(ctnew));
       ndnew.ImageIndex:=0;
       ndnew.SelectedIndex:=1;
       if ctnew.ComponentCount>0 then begin
         FillTreeViewObjectsOwner(ctnew,ndNew);
       end;
     end;
   end;

   procedure FillTreeViewObjectsParent(ct: TComponent; ndcur: TTreeNode);
   var
     ndNew: TTreeNode;
     i: Integer;
     ctNew: TControl;
     ctCom: TComponent;
   begin
     ndnew:=TV.Items.AddChildObject(ndcur,GetStrFromComp(ct),Pointer(ct));
     ndnew.SelectedIndex:=1;
     if ct is TWincontrol then begin
      for i:=0 to TWinControl(ct).ControlCount-1 do begin
        ctNew:=TWinControl(ct).Controls[i];
        FillTreeViewObjectsParent(ctNew,ndNew);
      end;
     end else begin
      for i:=0 to ct.ComponentCount-1 do begin
        ctCom:=ct.Components[i];
        FillTreeViewObjectsParent(ctCom,ndNew);
      end;
     end;
   end;

var
  ndApp,ndScr: TTreeNode;
  Com: TComponent;
  i: integer;
  dm: TDataModule;
  fm: TForm;
  isUpdateNil: Boolean;
begin
 TV.Items.BeginUpdate;
 try
  TV.Items.Clear;
  isUpdateNil:=true;
  { TApplication }
  if not Assigned(newApp) then exit;
  com:=newApp;
  ndApp:=TV.Items.AddChildObject(nil,GetStrFromComp(Com),Pointer(Com));
  ndApp.SelectedIndex:=1;
  FillTreeViewObjectsOwner(Com,ndApp);

  { TScreen }
  if not Assigned(newScr) then exit;
  com:=newScr;
  ndScr:=TV.Items.AddChildObject(nil,GetStrFromComp(Com),Pointer(Com));
  ndScr.SelectedIndex:=1;
  for i:=0 to newScr.FormCount-1 do begin
    fm:=newScr.Forms[i];
    FillTreeViewObjectsParent(fm,ndScr);
  end;
  for i:=0 to newScr.DataModuleCount-1 do begin
    dm:=newScr.DataModules[i];
    FillTreeViewObjectsParent(dm,ndScr);
  end;


  if ndApp<>nil then begin
    ndApp.MakeVisible;
    ndApp.Selected:=true;
    ndApp.Expand(false);
    UpdateInspector(ndApp);
    isUpdateNil:=false;
  end;

  if ndScr<>nil then begin
    ndScr.Expand(false);
    isUpdateNil:=false;
  end;

  if isUpdateNil then
    ObjInsp.UpdateInspector(nil);

 finally
  TV.Items.EndUpdate;
 end;
end;

procedure TfmObjectTree.FormCreate(Sender: TObject);
begin
    RyMenu.Add(pmTV,nil);
    
    ObjInsp:=TtsvPnlInspector.Create(Self);
    ObjInsp.parent:=pnR;
    ObjInsp.Combo.Clear;
    ObjInsp.Combo.Visible:=false;
    ObjInsp.Align:=alClient;
    ObjInsp.cmLabel.Visible:=false;
    ObjInsp.TSEven.Caption:='1';
    ObjInsp.TSEven.TabVisible:=false;
    ObjInsp.TSProp.Caption:='Properties';
//    ObjInsp.Filter:=true;
    ObjInsp.GridP.ColWidths[0]:=140;
end;

procedure TfmObjectTree.FormDestroy(Sender: TObject);
begin
  ObjInsp.Free;
  fmObjectTree:=nil;
  if FObjectInstance <> nil then FreeObjectInstance(FObjectInstance);

end;

procedure TfmObjectTree.UpdateInspector(nd: TTreeNode);
var
  ct: TComponent;
begin
  if nd=nil then exit;
  lastNode:=nd;
  ct:=TComponent(nd.Data);
  ObjInsp.UpdateInspector(ct);
end;

procedure TfmObjectTree.TVClick(Sender: TObject);
begin
  if Tv.Selected<>LastNode then
   UpdateInspector(Tv.Selected);
end;

procedure TfmObjectTree.TVKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
  VK_LEFT,VK_RIGHT,VK_DOWN,VK_UP: begin
   if Tv.Selected<>LastNode then
    UpdateInspector(Tv.Selected);
  end;
  VK_RETURN: begin
    UpdateInspector(Tv.Selected);
  end;
 end;
end;

procedure TfmObjectTree.GetNodeFromComponent(Com: TComponent; List: TList);
var
  i: Integer;
  nd: TTreeNode;
begin
  for i:=0 to TV.Items.Count-1 do begin
    nd:=TV.Items.Item[i];
    if nd.data<>nil then
     if nd.data=com then begin
       List.Add(nd);
     end;
  end;
end;

procedure TfmObjectTree.ChangeTreeNode(Com: TComponent);
var
  nd: TTReeNode;
  list: TList;
  i: Integer;
begin
  list:=TList.Create;
  try
   GetNodeFromComponent(Com,List);
   for i:=0 to List.Count-1 do begin
     nd:=List.Items[i];
     nd.Text:=GetStrFromComp(Com);
   end;
  finally
    List.Free;
  end; 
end;

procedure TfmObjectTree.ActiveObjectTree;
begin
  case tpCompiler of
    tcUknown: begin
     btRefresh.Visible:=false;
     btSearch.Visible:=false;
     ntb.PageIndex:=0;
     isShow:=false;
    end;
    tcBorlandDelphi: begin
     btRefresh.Visible:=true;
     btSearch.Visible:=true;
     ntb.PageIndex:=1;
     FillTreeView;
     isShow:=true;
    end;
  end;   
end;

procedure TfmObjectTree.rbtOwnerClick(Sender: TObject);
begin
  ActiveObjectTree;
end;

procedure TfmObjectTree.btRefreshClick(Sender: TObject);
begin
  miRefreshClick(nil);
end;

procedure TfmObjectTree.miRefreshClick(Sender: TObject);
begin
  ActiveObjectTree;
end;

procedure TfmObjectTree.miSearchClick(Sender: TObject);
begin
  fd.FindText:=FindString;
  if Tv.Selected<>nil then
   FPosNode:=Tv.Selected.AbsoluteIndex+1;
  if fd.Execute then begin
  end;
end;

procedure TfmObjectTree.btSearchClick(Sender: TObject);
begin
  miSearchClick(nil);
end;

procedure TfmObjectTree.TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
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
  end else DefaultDraw:=true;     }
end;

procedure TfmObjectTree.fdFind(Sender: TObject);

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
   UpdateInspector(nd);
   tv.Selected:=nd;
  end else
   FPosNode:=0;
end;

procedure TfmObjectTree.WndProc(var Message: TMessage); 

  procedure Default;
  begin
   if FDefClientProc<>nil then
     with Message do
       Result := CallWindowProc(FDefClientProc, FClientHandle, Msg, wParam, lParam);
  end;

begin
  inherited;
  exit;
{  with Message do
    case Msg of
      WMUserdef://!
        begin
          Default;
          MessageBox(0,'ok',nil,MB_OK);
        end;
    else
      Default;
    end;}
end;

end.


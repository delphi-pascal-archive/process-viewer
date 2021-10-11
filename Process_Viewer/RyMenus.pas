{***********************************************************************}
{                         Класс TRyMenu.                                }
{ Описание:                                                             }
{   * Принимает на себя отрисовку меню в стиле OfficаXP.                }
{     [Только я этот офис только еще толком не видел, но у меня его     }
{      картинка есть. :o)]                                              }
{                                                                       }
{ Версия  : 1.03, 15 января 2002 г.                                     }
{ Автор   : Алексей Румянцев.                                           }
{ E-mail  : skitl@mail.ru                                               }
{-----------------------------------------------------------------------}
{    Специально для Королевства Дельфи http://www.delphikingdom.com     }
{-----------------------------------------------------------------------}
{ Написано на Delphi5. Тестировалось на Win98. WinXP.                   }
{ В случае обнаружения ошибки или несовместимости с другими версиями    }
{ Delphi и Windows, просьба сообщить автору.                            }
{-----------------------------------------------------------------------}
{ P.S. Создавал для личной цели, потом решил адаптировать(привести      }
{ к читабельному виду) и прислать в Королевство, может кому-нибудь      }
{ понравится.                                                           }
{ Естественно не перекрываются никакие процедуры и функции стандартного }
{ меню, так что при необходимости легко будет от него отказаться.       }
{-----------------------------------------------------------------------}
{ HISTORY.                                                              }
{ 13.01.2002 - Появились первые пользователи - выплыли первые недочеты. }
{   Недочеты пока мелкие и их легче исправить чем описывать здесь.      }
{ 14.01.2001 - Сообщение о проблеме перерисовки верхней полоски         }
{   TMainMenu. Загвоздка в том, что непонятно от куда ноги у этой       }
{   проблемы растут.                                                    }
{   Описание : При RunTime'овом изменении OwnerDraw к положительному    }
{     значению, при любом из условий                                    }
{       а. нет imagelist'а                                              }
{       б. создании pagecontrol'а на форме                              }
{       в. в НЕ основных формах                                         }
{     меню отказывается перерисовывать верхнюю полоску TMainMenu,       }
{     при чем без вопросов отрисовывая подменю.                         }
{     При выставлении этого свойства в DesignTime проблем не возникает. }
{   Вопрос: Где искать причину?                                         }
{ 15.01.2002 - послана обновленная версия в Королевство.                }
{***********************************************************************}

unit RyMenus;

interface

uses Windows, SysUtils, Classes, Messages, Graphics, ImgList, Menus, Forms;

type
  TRyMenu = class(TObject)
  private
    ListMenus: TList;
    FFont: TFont;
    FGutterColor: TColor;
    FMenuColor: TColor;
    FSelectedColor: TColor;
    FVisible: Boolean;
    procedure SetFont(const Value: TFont);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetVisible(Value: Boolean);
    procedure Refresh;
    procedure InitItem(Item : TMenuItem);
    procedure InitItems(Item : TMenuItem);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Menu: TMenu; Item: TMenuItem);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas;
              var Width, Height: Integer);
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
              ARect: TRect; State: TOwnerDrawState);
    property MenuColor: TColor read FMenuColor write FMenuColor;
    property GutterColor: TColor read FGutterColor write FGutterColor;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
    property Font: TFont read FFont write SetFont; {можете поменять фонт у меню}
    property Visible: Boolean read FVisible write SetVisible;
  end;

var
  RyMenu: TRyMenu; {это чтобы вам не мучиться - для каждого меню создавать
  свой TRyMenu. он инициализируется сам и рисует все в стандартные цвета.}

implementation

var
  _DefSelColor: TColor = $00FFAEB0;
//  _DefSelColor: TColor = clBtnFace;
  BmpCheck: array[Boolean] of TBitmap; {две bmp 16x16 для чекнутых пунктов меню}

//uses RyUtils;

function Max(A, B: Integer): Integer;
begin
  if A < B then Result := B
  else Result := A
end;

{ TRyMenuItem }

constructor TRyMenu.Create;
begin
  FGutterColor := clBtnFace;{серая полоска}
  FMenuColor := clWindow;
  FSelectedColor := _DefSelColor;{выделенный пункт меню}
  FFont := TFont.Create;
  Font := Screen.MenuFont;{получает фонт стандартного меню}
  FVisible:=false;
  ListMenus:=TList.Create;
end;

destructor TRyMenu.Destroy;
begin
  ListMenus.Free;
  FFont.Free;
  inherited;
end;

{чтобы самому не перичислять все итемы меню, вызовите эту процедуру,
 передав в качестве параметра либо само меню либо какой либо
 итем(например созданный в рантайме), указав в качестве другого
 параметра NIL}

procedure TRyMenu.InitItem(Item : TMenuItem);
begin
  if FVisible then begin
    Item.OnAdvancedDrawItem := Self.AdvancedDrawItem;
    if not (Item.GetParentComponent is TMainMenu) then
      Item.OnMeasureItem := Self.MeasureItem;
  end else begin
    Item.OnAdvancedDrawItem :=nil;
    if not (Item.GetParentComponent is TMainMenu) then
      Item.OnMeasureItem := nil;
  end;
end;

procedure TRyMenu.InitItems(Item : TMenuItem);
  {бежит по всем пунктам, при случае заглядывая в подпункты}
var
  I: Word;
begin
    I := 0;
    while I < Item.Count do
    begin
      InitItem(Item[I]);
      if Item[I].Count > 0 then InitItems(Item[I]);
      Inc(I);
    end;
end;
 
procedure TRyMenu.Add(Menu: TMenu; Item: TMenuItem);
begin
  if Assigned(Menu) then
  begin
    InitItems(Menu.Items);
    ListMenus.Add(Menu);
    Menu.OwnerDraw := FVisible; {Прошу знающих людей обратить на этот момент внимание
    и помоч разобраться. описание проблемы в History от 14.01.2002.}
  end;
  if Assigned(Item) then
  begin
    InitItem(Item);
    InitItems(Item);
  end;
end;

{собственно отрисовка-c}
procedure TRyMenu.AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
          ARect: TRect; State: TOwnerDrawState);
const
  {текстовые флаги}
  _Flags: LongInt = DT_NOCLIP or DT_VCENTER or DT_END_ELLIPSIS or DT_SINGLELINE;
  _FlagsTopLevel: array[Boolean] of Longint = (DT_LEFT, DT_CENTER);
  _FlagsShortCut: {array[Boolean] of} Longint = (DT_RIGHT);
  _RectEl: array[Boolean] of Byte = (0, 6);{закругленный прямоугольник}
var
  TopLevel: Boolean;
  Gutter: Word;{ширина серой полоски}
  ImageList: TCustomImageList;
begin
  with TMenuItem(Sender), ACanvas do
  begin
    TopLevel := GetParentComponent is TMainMenu;

    ImageList := GetImageList; {интиресуемся есть ли у меню ImageList}

    Font := FFont; {указываем канве каким фонтом пользоваться}

    if Assigned(ImageList) then
      Gutter := ImageList.Width + 9 {четыре точки до картинки + картинка + пять после}
    else
    if IsLine then
      Gutter := Max(TextHeight('W'), 18)
    else
      Gutter := ARect.Bottom - ARect.Top; {ширина = высоте}

    Pen.Color := clBlack;
    if (odSelected in State) then {если пункт меню выделен}
    begin
      Brush.Color := SelectedColor;
      Rectangle(Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom))
    end else
    if TopLevel then {если это полоска основного меню}
    begin
      if (odHotLight in State) then {если мышь над пунктом меню}
        Brush.Color := SelectedColor
      else Brush.Color := clBtnFace;
      FillRect(ARect);
    end else
      begin {ничем не примечательный пункт меню}
        Brush.Color := GutterColor; {полоска}
        FillRect(Rect(ARect.Left, ARect.Top, Gutter, ARect.Bottom));
        Brush.Color := MenuColor;
        FillRect(Rect(Gutter, ARect.Top, ARect.Right, ARect.Bottom));
      end;

    if Checked then
    begin {подсвечиваем чекнутый пункт меню}
      Brush.Color := SelectedColor;
      if Assigned(ImageList) and (ImageIndex > -1) then
         {если имеется картинка то рисуем квадратик вокруг нее}
         RoundRect(ARect.Left + 2, ARect.Top, Gutter - 2 - 1,
           ARect.Bottom, _RectEl[RadioItem], _RectEl[RadioItem])
      else {просто рисуем квадратик}
        Draw((ARect.Left + 2 + Gutter - 1 - 2 - BmpCheck[RadioItem].Width) div 2,
          (ARect.Top + ARect.Bottom - BmpCheck[RadioItem].Height) div 2,
          BmpCheck[RadioItem])
    end;

    if Assigned(ImageList) and ((ImageIndex > -1) and (not TopLevel)) then
      ImageList.Draw(ACanvas, ARect.Left + 4,
        (ARect.Top + ARect.Bottom - ImageList.Height) div 2,
        ImageIndex, Enabled); {рисуем картинку}

    with Font do
    begin
      if (odDefault in State) then Style := [fsBold];
      if (odDisabled in State) then Color := clGray
      else Color := clBlack;
    end;

    Brush.Style := bsClear;
    if TopLevel then {пусто}
    else Inc(ARect.Left, Gutter + 5); {отступ для текста}

    if IsLine then {если разделитель}
    begin
      MoveTo(ARect.Left, ARect.Top + (ARect.Bottom - ARect.Top) div 2);
      LineTo(ARect.Right, ARect.Top + (ARect.Bottom - ARect.Top) div 2);    
    end else
    begin {текст меню}
      Windows.DrawText(Handle, PChar(Caption), Length(Caption), ARect,
        _Flags or _FlagsTopLevel[TopLevel]);
      if ShortCut <> 0 then {разпальцовка}
      begin
        Dec(ARect.Right, 5);
        Windows.DrawText(Handle, PChar(ShortCutToText(ShortCut)),
          Length(ShortCutToText(ShortCut)), ARect,
          _Flags or _FlagsShortCut);
      end
    end
  end
end;

{размеры меню}
procedure TRyMenu.MeasureItem(Sender: TObject; ACanvas: TCanvas;
          var Width, Height: Integer);
var
  ImageList: TCustomImageList;
begin
  with TMenuItem(Sender) do
  begin
    ImageList := GetImageList;
    ACanvas.Font := FFont; {указываем канве на наш фонт}
    if Assigned(ImageList) then
    begin
      if IsLine then
        if ImageList.Height > 20 then {при большем 20 узкая полоска некрасива}
           Height := 11 else Height := 5
      else
        with ACanvas do
        begin
          Width := ImageList.Width;
          if Width < 8 then Width := 16 else Width := Width + 8;
          Width := Width + TextWidth(Caption + ShortCutToText(ShortCut)) + 15;
          Height := Max(ACanvas.TextHeight('W'), ImageList.Height);
          if Height < 14 then Height := 18 else Height := Height + 4;
        end
    end else
      with ACanvas do
      begin
        Height := Max(TextHeight('W'), 18);
        if IsLine then
          if Height > 20 then {при большем 20 узкая полоска некрасива}
             Height := 11 else Height := 5;
        Width := {Max(Height,} 16 + 15 +
          TextWidth(Caption + ShortCutToText(ShortCut));
      end
  end
end;

procedure TRyMenu.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure InitBmp(Bmp: TBitmap; Radio: Boolean);
begin
  with Bmp, Canvas do
  begin
    Width := 14;
    Height := 14;
    Pen.Color := clBlack;
    Brush.Color := _DefSelColor;
    Rectangle(0, 0, Width, Height);
    Brush.Color := clBlack;
    if Radio then Ellipse(3, 3, Width - 1 - 2, Height - 1 - 2)
    else Rectangle(3, 3, Width - 1 - 2, Height - 1 - 2);
  end
end;

procedure TRyMenu.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
  {_DefSelColor := Value;          не знаю нужно ли перерисовывать чекнутые bmp
  InitBmp(BmpCheck[False], False); под цвет выделенного пункта меню но пока таких
  InitBmp(BmpCheck[True], True);   заказов не поступало}
end;

procedure TRyMenu.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then begin
    FVisible:=Value;
    Refresh;     
  end;  
end;

procedure TRyMenu.Refresh;
var
  i: Integer;
  me: TMenu;
begin
  for i:=0 to ListMenus.Count-1 do begin
    me:=ListMenus.Items[i];
    if Assigned(me) then begin
     InitItems(me.Items);
     me.OwnerDraw := FVisible;
    end; 
  end;
end;

initialization
  BmpCheck[False]:= TBitmap.Create;
  BmpCheck[True]:= TBitmap.Create;
  InitBmp(BmpCheck[False], False);
  InitBmp(BmpCheck[True], True);
  RyMenu := TRyMenu.Create;

finalization
  BmpCheck[False].Free;
  BmpCheck[True].Free;
  RyMenu.Free;

end.

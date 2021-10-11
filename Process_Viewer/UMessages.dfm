object fmMess: TfmMess
  Left = 374
  Top = 187
  BorderStyle = bsDialog
  ClientHeight = 232
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 189
    Width = 329
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 144
      Top = 0
      Width = 185
      Height = 43
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btSend: TBitBtn
        Left = 23
        Top = 11
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 104
        Top = 11
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object pn: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 189
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object sgMess: TStringGrid
      Left = 5
      Top = 5
      Width = 319
      Height = 179
      Align = alClient
      ColCount = 2
      DefaultColWidth = 150
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goEditing]
      TabOrder = 0
      OnDblClick = sgMessDblClick
    end
  end
end

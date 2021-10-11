object fmChange: TfmChange
  Left = 277
  Top = 253
  BorderStyle = bsDialog
  Caption = 'Change'
  ClientHeight = 178
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 12
    Width = 41
    Height = 13
    Caption = 'Address:'
  end
  object Label2: TLabel
    Left = 13
    Top = 65
    Width = 46
    Height = 13
    Caption = 'OldValue:'
  end
  object Label3: TLabel
    Left = 7
    Top = 92
    Width = 52
    Height = 13
    Caption = 'NewValue:'
  end
  object Label4: TLabel
    Left = 32
    Top = 38
    Width = 27
    Height = 13
    Caption = 'Type:'
  end
  object Label5: TLabel
    Left = 35
    Top = 120
    Width = 22
    Height = 13
    Caption = 'Hint:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 137
    Width = 217
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object Panel2: TPanel
      Left = 32
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btOk: TBitBtn
        Left = 23
        Top = 11
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = btOkClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
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
  object edAddr: TEdit
    Left = 65
    Top = 8
    Width = 96
    Height = 21
    MaxLength = 8
    TabOrder = 0
    OnKeyDown = edAddrKeyDown
    OnKeyPress = edAddrKeyPress
  end
  object edOldValue: TEdit
    Left = 65
    Top = 62
    Width = 122
    Height = 21
    TabOrder = 2
    OnChange = edOldValueChange
  end
  object edNewValue: TEdit
    Left = 65
    Top = 89
    Width = 122
    Height = 21
    TabOrder = 4
  end
  object cbType: TComboBox
    Left = 65
    Top = 35
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbTypeChange
    Items.Strings = (
      'String'
      'HEX')
  end
  object btOldIns: TBitBtn
    Left = 187
    Top = 62
    Width = 22
    Height = 22
    Caption = '...'
    Enabled = False
    TabOrder = 3
    OnClick = btOldInsClick
  end
  object btNewIns: TBitBtn
    Left = 187
    Top = 89
    Width = 22
    Height = 22
    Caption = '...'
    Enabled = False
    TabOrder = 5
    OnClick = btNewInsClick
  end
  object edHint: TEdit
    Left = 65
    Top = 117
    Width = 143
    Height = 21
    TabOrder = 7
  end
end

object fmSearch: TfmSearch
  Left = 206
  Top = 153
  BorderStyle = bsDialog
  Caption = 'Search options'
  ClientHeight = 295
  ClientWidth = 398
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
  object Label1: TLabel
    Left = 12
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Start address:'
  end
  object Label2: TLabel
    Left = 15
    Top = 77
    Width = 30
    Height = 13
    Caption = 'Value:'
  end
  object Label3: TLabel
    Left = 7
    Top = 33
    Width = 70
    Height = 13
    Caption = 'Finish address:'
  end
  object Label4: TLabel
    Left = 6
    Top = 235
    Width = 66
    Height = 13
    Caption = 'Delta Prioritet:'
  end
  object Label5: TLabel
    Left = 7
    Top = 210
    Width = 65
    Height = 13
    Caption = 'Base Prioritet:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 253
    Width = 398
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 20
    object Panel2: TPanel
      Left = 213
      Top = 0
      Width = 185
      Height = 42
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 23
        Top = 11
        Width = 75
        Height = 25
        Caption = 'Search'
        Default = True
        TabOrder = 0
        OnClick = BitBtn1Click
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
  object edStartAddr: TEdit
    Left = 83
    Top = 5
    Width = 111
    Height = 21
    MaxLength = 8
    TabOrder = 0
    OnKeyDown = edStartAddrKeyDown
    OnKeyPress = edStartAddrKeyPress
  end
  object rbString: TRadioButton
    Left = 14
    Top = 54
    Width = 46
    Height = 18
    Caption = 'String'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = rbHexClick
  end
  object edString: TEdit
    Left = 52
    Top = 73
    Width = 123
    Height = 21
    MaxLength = 256
    TabOrder = 5
  end
  object rbHex: TRadioButton
    Left = 73
    Top = 54
    Width = 43
    Height = 18
    Caption = 'HEX'
    TabOrder = 3
    OnClick = rbHexClick
  end
  object cbCase: TCheckBox
    Left = 127
    Top = 54
    Width = 67
    Height = 17
    Caption = 'Char case'
    TabOrder = 4
  end
  object cbStop: TCheckBox
    Left = 6
    Top = 100
    Width = 112
    Height = 17
    Caption = 'Stop on first occurs'
    TabOrder = 7
  end
  object btMore: TBitBtn
    Left = 129
    Top = 106
    Width = 66
    Height = 19
    Caption = 'More ->'
    TabOrder = 9
    OnClick = btMoreClick
  end
  object GroupBox1: TGroupBox
    Left = 203
    Top = 29
    Width = 190
    Height = 198
    Caption = 'Page protect'
    TabOrder = 18
    object chbPAGE_READONLY: TCheckBox
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Caption = 'PAGE_READONLY'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbPAGE_READWRITE: TCheckBox
      Left = 8
      Top = 32
      Width = 127
      Height = 17
      Caption = 'PAGE_READWRITE'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbPAGE_WRITECOPY: TCheckBox
      Left = 8
      Top = 48
      Width = 127
      Height = 17
      Caption = 'PAGE_WRITECOPY'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chbPAGE_EXECUTE: TCheckBox
      Left = 8
      Top = 64
      Width = 121
      Height = 17
      Caption = 'PAGE_EXECUTE'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chbPAGE_EXECUTE_READ: TCheckBox
      Left = 8
      Top = 80
      Width = 146
      Height = 17
      Caption = 'PAGE_EXECUTE_READ'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object chbPAGE_EXECUTE_READWRITE: TCheckBox
      Left = 8
      Top = 112
      Width = 178
      Height = 17
      Caption = 'PAGE_EXECUTE_READWRITE'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object chbPAGE_EXECUTE_WRITECOPY: TCheckBox
      Left = 8
      Top = 96
      Width = 178
      Height = 17
      Caption = 'PAGE_EXECUTE_WRITECOPY'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object chbPAGE_GUARD: TCheckBox
      Left = 8
      Top = 128
      Width = 97
      Height = 17
      Caption = 'PAGE_GUARD'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object chbPAGE_NOACCESS: TCheckBox
      Left = 8
      Top = 144
      Width = 117
      Height = 17
      Caption = 'PAGE_NOACCESS'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object chbPAGE_NOCACHE: TCheckBox
      Left = 8
      Top = 160
      Width = 110
      Height = 17
      Caption = 'PAGE_NOCACHE'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
    object chbCheck: TCheckBox
      Left = 26
      Top = 176
      Width = 66
      Height = 17
      Caption = 'Check all'
      Checked = True
      State = cbChecked
      TabOrder = 10
      OnClick = chbCheckClick
    end
  end
  object btIns: TBitBtn
    Left = 175
    Top = 73
    Width = 20
    Height = 22
    Caption = '...'
    Enabled = False
    TabOrder = 6
    OnClick = btInsClick
  end
  object cbOnlyModules: TCheckBox
    Left = 6
    Top = 134
    Width = 89
    Height = 17
    Caption = 'Only modules'
    TabOrder = 10
    OnClick = cbOnlyModulesClick
  end
  object cbShowTime: TCheckBox
    Left = 6
    Top = 185
    Width = 144
    Height = 17
    Caption = 'Show Time after search'
    TabOrder = 14
  end
  object cbFast: TCheckBox
    Left = 6
    Top = 117
    Width = 107
    Height = 17
    Caption = 'Optimizing search'
    TabOrder = 8
    OnClick = cbFastClick
  end
  object cbFinish: TComboBox
    Left = 83
    Top = 30
    Width = 112
    Height = 21
    ItemHeight = 13
    MaxLength = 8
    TabOrder = 1
    OnChange = cbFinishChange
    OnKeyPress = edStartAddrKeyPress
    Items.Strings = (
      '40000000'
      '80000000'
      'C0000000'
      'FFFFFFFF')
  end
  object cbWithOutM: TCheckBox
    Left = 95
    Top = 134
    Width = 103
    Height = 17
    Caption = 'With out modules'
    TabOrder = 11
    OnClick = cbWithOutMClick
  end
  object cbNoInfo: TCheckBox
    Left = 6
    Top = 151
    Width = 163
    Height = 17
    Caption = 'Demonstrate the information'
    TabOrder = 12
  end
  object cbSuper: TCheckBox
    Left = 6
    Top = 168
    Width = 123
    Height = 17
    Caption = 'Super Fast Search'
    TabOrder = 13
    OnClick = cbSuperClick
  end
  object cbDeltaPrioritet: TComboBox
    Left = 77
    Top = 231
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
    Items.Strings = (
      'IDLE'
      'LOWEST'
      'BELOW_NORMAL'
      'NORMAL'
      'ABOVE_NORMAL'
      'HIGHEST'
      'TIME_CRITICAL')
  end
  object cbBasePrioritet: TComboBox
    Left = 77
    Top = 206
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 15
    Items.Strings = (
      'IDLE'
      'NORMAL'
      'HIGH'
      'REALTIME')
  end
  object cbInfo: TCheckBox
    Left = 208
    Top = 7
    Width = 177
    Height = 17
    Caption = 'Information from address space:'
    TabOrder = 17
  end
  object cbPreSearch: TCheckBox
    Left = 204
    Top = 232
    Width = 149
    Height = 17
    Caption = 'Check Pre-search results'
    Enabled = False
    TabOrder = 19
  end
end

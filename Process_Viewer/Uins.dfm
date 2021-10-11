object fmIns: TfmIns
  Left = 276
  Top = 180
  BorderStyle = bsDialog
  Caption = 'Insert'
  ClientHeight = 141
  ClientWidth = 298
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
    Top = 105
    Width = 298
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 113
      Top = 0
      Width = 185
      Height = 36
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 23
        Top = 5
        Width = 75
        Height = 25
        Caption = 'OK'
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
        Top = 5
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 298
    Height = 105
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 5
      Top = 5
      Width = 288
      Height = 95
      Align = alClient
      Caption = 'Selection'
      TabOrder = 0
      object Label1: TLabel
        Left = 36
        Top = 68
        Width = 30
        Height = 13
        Caption = 'Value:'
      end
      object rbInt: TRadioButton
        Left = 8
        Top = 17
        Width = 80
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Integer value'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbIntClick
      end
      object rbFloat: TRadioButton
        Left = 17
        Top = 42
        Width = 71
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Float value'
        TabOrder = 2
        OnClick = rbIntClick
      end
      object edValue: TEdit
        Left = 73
        Top = 65
        Width = 205
        Height = 21
        TabOrder = 4
        OnKeyDown = edValueKeyDown
      end
      object cbFloatType: TComboBox
        Left = 94
        Top = 40
        Width = 184
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          '6 bytes (Real48)'
          '4 bytes (Single)'
          '8 bytes (Double/Real)'
          '10 bytes (Extended)'
          '8 bytes (Comp)'
          '8 bytes (Currency)')
      end
      object cbIntType: TComboBox
        Left = 94
        Top = 15
        Width = 184
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          'signed 8-bit (Shortint)'
          'signed 16-bit (Smallint)'
          'signed 32-bit (Longint/Integer)'
          'signed 64-bit (Int64)'
          'unsigned 8-bit (Byte)'
          'unsigned 16-bit (Word)'
          'unsigned 32-bit (Longword/Cardinal)')
      end
    end
  end
end

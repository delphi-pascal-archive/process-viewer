object fmSendMes: TfmSendMes
  Left = 301
  Top = 211
  BorderStyle = bsDialog
  Caption = 'Send Message'
  ClientHeight = 167
  ClientWidth = 234
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
  object lbHWND: TLabel
    Left = 16
    Top = 16
    Width = 74
    Height = 13
    Caption = 'Window handle'
  end
  object lbMessage: TLabel
    Left = 47
    Top = 40
    Width = 43
    Height = 13
    Caption = 'Message'
  end
  object lbwParam: TLabel
    Left = 52
    Top = 64
    Width = 38
    Height = 13
    Caption = 'wParam'
  end
  object lblParam: TLabel
    Left = 58
    Top = 88
    Width = 32
    Height = 13
    Caption = 'lParam'
  end
  object Panel1: TPanel
    Left = 0
    Top = 124
    Width = 234
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object Panel2: TPanel
      Left = 49
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
        Caption = 'Send'
        Default = True
        TabOrder = 0
        OnClick = btSendClick
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
  object edHWND: TEdit
    Left = 100
    Top = 13
    Width = 122
    Height = 21
    Color = clBtnFace
    MaxLength = 8
    ReadOnly = True
    TabOrder = 0
  end
  object edMessage: TEdit
    Left = 100
    Top = 37
    Width = 102
    Height = 21
    MaxLength = 8
    TabOrder = 1
  end
  object edwParam: TEdit
    Left = 100
    Top = 61
    Width = 122
    Height = 21
    MaxLength = 8
    TabOrder = 3
  end
  object edlParam: TEdit
    Left = 100
    Top = 85
    Width = 122
    Height = 21
    MaxLength = 8
    TabOrder = 4
  end
  object btMess: TBitBtn
    Left = 201
    Top = 37
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = btMessClick
  end
  object rbHex: TRadioButton
    Left = 96
    Top = 112
    Width = 57
    Height = 17
    Caption = 'HEX'
    Checked = True
    TabOrder = 6
    TabStop = True
    OnClick = rbHexClick
  end
  object rbDec: TRadioButton
    Left = 168
    Top = 112
    Width = 55
    Height = 17
    Caption = 'DEC'
    TabOrder = 7
    OnClick = rbHexClick
  end
end

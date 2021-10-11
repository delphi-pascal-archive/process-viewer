object fmSaveMem: TfmSaveMem
  Left = 264
  Top = 45
  BorderStyle = bsDialog
  Caption = 'Save memory'
  ClientHeight = 209
  ClientWidth = 229
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
    Top = 173
    Width = 229
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 44
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
    Width = 229
    Height = 173
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnModule: TPanel
      Left = 0
      Top = 30
      Width = 502
      Height = 26
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 10
        Top = 7
        Width = 67
        Height = 13
        Caption = 'Module name:'
      end
      object cbModule: TComboBox
        Left = 84
        Top = 4
        Width = 130
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbModuleChange
      end
    end
    object pnAddr: TPanel
      Left = 0
      Top = 56
      Width = 502
      Height = 56
      BevelOuter = bvNone
      TabOrder = 2
      object Label3: TLabel
        Left = 12
        Top = 8
        Width = 65
        Height = 13
        Caption = 'Start address:'
      end
      object Label4: TLabel
        Left = 7
        Top = 35
        Width = 70
        Height = 13
        Caption = 'Finish address:'
      end
      object edStart: TEdit
        Left = 84
        Top = 5
        Width = 130
        Height = 21
        MaxLength = 8
        TabOrder = 0
        OnKeyPress = edStartKeyPress
      end
      object edFinish: TEdit
        Left = 84
        Top = 32
        Width = 130
        Height = 21
        MaxLength = 8
        TabOrder = 1
        OnKeyPress = edStartKeyPress
      end
    end
    object pnTop: TPanel
      Left = 0
      Top = 0
      Width = 229
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 48
        Top = 12
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Case:'
      end
      object cbOper: TComboBox
        Left = 84
        Top = 8
        Width = 130
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbOperChange
        Items.Strings = (
          'Current Page'
          'Module'
          'Custom Memory')
      end
    end
  end
end

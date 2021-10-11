object fmAbout: TfmAbout
  Left = 333
  Top = 161
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 124
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 84
    Width = 302
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      302
      40)
    object lbTotalPhys: TLabel
      Left = 5
      Top = 4
      Width = 72
      Height = 16
      Caption = 'lbTotalPhys'
    end
    object lbMemLoad: TLabel
      Left = 5
      Top = 20
      Width = 72
      Height = 16
      Caption = 'lbMemLoad'
    end
    object BitBtn1: TBitBtn
      Left = 204
      Top = 6
      Width = 93
      Height = 30
      Anchors = [akLeft, akTop, akRight, akBottom]
      Cancel = True
      Caption = 'OK'
      ModalResult = 2
      TabOrder = 0
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
  end
  object pnParent: TPanel
    Left = 0
    Top = 0
    Width = 302
    Height = 84
    Align = alClient
    BevelInner = bvRaised
    TabOrder = 1
    object Label1: TLabel
      Left = 2
      Top = 2
      Width = 298
      Height = 26
      Align = alTop
      Alignment = taCenter
      Caption = 'Process Viewer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbVer: TLabel
      Left = 2
      Top = 28
      Width = 298
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = 'Version'
    end
    object pn: TPanel
      Left = 2
      Top = 44
      Width = 298
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pn'
      TabOrder = 0
      object Label7: TLabel
        Left = 0
        Top = -2
        Width = 110
        Height = 27
        Alignment = taCenter
        AutoSize = False
        Caption = 'Programmer:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlBottom
      end
      object lbTom: TLabel
        Left = 100
        Top = 2
        Width = 165
        Height = 25
        Hint = 'tsv@nextsoft.ru'
        AutoSize = False
        Caption = 'Sergey Tomilov'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
        Visible = False
        OnClick = lbTomClick
      end
    end
  end
end

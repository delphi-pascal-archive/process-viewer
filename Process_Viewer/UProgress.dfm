object fmProgress: TfmProgress
  Left = 271
  Top = 172
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Searching...'
  ClientHeight = 203
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 203
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnSlow: TPanel
      Left = 0
      Top = 0
      Width = 259
      Height = 134
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 7
        Top = 7
        Width = 95
        Height = 13
        Caption = 'Current Address:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbF: TLabel
        Left = 162
        Top = 7
        Width = 54
        Height = 13
        Caption = 'Founded:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 7
        Top = 22
        Width = 195
        Height = 13
        Caption = 'Size from Start address in MBytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbFounded: TLabel
        Left = 219
        Top = 7
        Width = 3
        Height = 13
      end
      object lbSize: TLabel
        Left = 204
        Top = 22
        Width = 3
        Height = 13
      end
      object lbCurAddr: TLabel
        Left = 105
        Top = 7
        Width = 3
        Height = 13
      end
      object Label4: TLabel
        Left = 7
        Top = 37
        Width = 91
        Height = 13
        Caption = 'Current Module:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbCurMod: TLabel
        Left = 100
        Top = 37
        Width = 3
        Height = 13
      end
      object Label5: TLabel
        Left = 8
        Top = 53
        Width = 133
        Height = 13
        Caption = 'Module Size in MBytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbModSize: TLabel
        Left = 143
        Top = 53
        Width = 3
        Height = 13
      end
      object Label6: TLabel
        Left = 8
        Top = 117
        Width = 79
        Height = 13
        Caption = 'Page Protect:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbPageProt: TLabel
        Left = 89
        Top = 117
        Width = 3
        Height = 13
      end
      object Label7: TLabel
        Left = 8
        Top = 165
        Width = 102
        Height = 13
        Caption = 'Searching time is:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbSearchTime: TLabel
        Left = 114
        Top = 165
        Width = 3
        Height = 13
      end
      object Label8: TLabel
        Left = 8
        Top = 85
        Width = 121
        Height = 13
        Caption = 'Region Size in bytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbRegSize: TLabel
        Left = 133
        Top = 85
        Width = 3
        Height = 13
      end
      object Label9: TLabel
        Left = 8
        Top = 101
        Width = 68
        Height = 13
        Caption = 'Page State:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbPageState: TLabel
        Left = 82
        Top = 101
        Width = 3
        Height = 13
      end
      object Label10: TLabel
        Left = 8
        Top = 69
        Width = 149
        Height = 13
        Caption = 'Size from Region in bytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LbSizeFromReg: TLabel
        Left = 159
        Top = 69
        Width = 3
        Height = 13
      end
    end
    object pnProg: TPanel
      Left = 0
      Top = 134
      Width = 259
      Height = 69
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 9
        Top = 10
        Width = 244
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 0
        object gag: TGauge
          Left = 2
          Top = 2
          Width = 240
          Height = 17
          Align = alClient
          BorderStyle = bsNone
          ForeColor = clBlue
          Progress = 50
        end
      end
      object btStop: TBitBtn
        Left = 93
        Top = 39
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Stop'
        ModalResult = 2
        TabOrder = 1
        OnClick = btStopClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
  end
end

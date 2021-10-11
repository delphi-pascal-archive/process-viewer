object fmPISI: TfmPISI
  Left = 189
  Top = 84
  Width = 550
  Height = 470
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Process Info and System Info'
  Color = clBtnFace
  Constraints.MinHeight = 388
  Constraints.MinWidth = 550
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 443
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 0
      Top = 402
      Width = 542
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      DesignSize = (
        542
        41)
      object lbCount: TLabel
        Left = 12
        Top = 14
        Width = 36
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'lbCount'
      end
      object btStopFill: TBitBtn
        Left = 355
        Top = 6
        Width = 85
        Height = 27
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Stop Fill'
        TabOrder = 1
        OnClick = btStopFillClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333FFFFF333333000033333388888833333333333F888888FFF333
          000033338811111188333333338833FFF388FF33000033381119999111833333
          38F338888F338FF30000339119933331111833338F388333383338F300003391
          13333381111833338F8F3333833F38F3000039118333381119118338F38F3338
          33F8F38F000039183333811193918338F8F333833F838F8F0000391833381119
          33918338F8F33833F8338F8F000039183381119333918338F8F3833F83338F8F
          000039183811193333918338F8F833F83333838F000039118111933339118338
          F3833F83333833830000339111193333391833338F33F8333FF838F300003391
          11833338111833338F338FFFF883F83300003339111888811183333338FF3888
          83FF83330000333399111111993333333388FFFFFF8833330000333333999999
          3333333333338888883333330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
      object BitBtn1: TBitBtn
        Left = 448
        Top = 6
        Width = 85
        Height = 27
        Anchors = [akRight, akBottom]
        Caption = 'Close'
        TabOrder = 2
        OnClick = BitBtn1Click
        Kind = bkCancel
      end
      object btFileInfo: TBitBtn
        Left = 262
        Top = 6
        Width = 85
        Height = 27
        Hint = 'File Info'
        Anchors = [akRight, akBottom]
        Caption = 'File Info'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = btFileInfoClick
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888800000000000888880FFFFFFFFF0888880F777F777F08
          88880FFFFFFFFF0888880F777F777F0888880FFFFFFF0F0888880F707F708008
          88840F080F080800084444408080808880444444080808888844888880808888
          8844888888088888804488888880000008448888888888888888}
        Margin = 5
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 542
      Height = 402
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 1
      object pc: TPageControl
        Left = 5
        Top = 5
        Width = 532
        Height = 392
        ActivePage = ts1
        Align = alClient
        TabIndex = 0
        TabOrder = 0
        Visible = False
        OnChange = tbChange
        object ts1: TTabSheet
          Caption = 'Modules'
          object LV: TListView
            Left = 0
            Top = 0
            Width = 524
            Height = 364
            Align = alClient
            Columns = <>
            GridLines = True
            HideSelection = False
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pmModules
            TabOrder = 0
            ViewStyle = vsReport
            OnColumnClick = LVColumnClick
            OnCustomDrawItem = LVCustomDrawItem
            OnMouseDown = LVMouseDown
          end
        end
        object ts2: TTabSheet
          Caption = 'Threads'
          ImageIndex = 1
        end
        object ts3: TTabSheet
          Caption = 'Heaps'
          ImageIndex = 2
        end
        object ts4: TTabSheet
          Caption = 'Memory'
          ImageIndex = 3
        end
        object tbsInfo: TTabSheet
          Caption = 'Information'
          ImageIndex = 4
          object GroupBox2: TGroupBox
            Left = 9
            Top = 5
            Width = 187
            Height = 158
            Caption = 'System Info'
            TabOrder = 0
            object lbMemLoad: TLabel
              Left = 93
              Top = 32
              Width = 57
              Height = 13
              Caption = 'lbProcessID'
            end
            object lbAvailPageFile: TLabel
              Left = 94
              Top = 96
              Width = 64
              Height = 13
              Caption = 'lbProcessPID'
            end
            object lbTotalPageFile: TLabel
              Left = 94
              Top = 80
              Width = 75
              Height = 13
              Caption = 'lbCountThreads'
            end
            object lbPageSize: TLabel
              Left = 93
              Top = 16
              Width = 28
              Height = 13
              Caption = 'lbSize'
            end
            object lbTotalPhys: TLabel
              Left = 93
              Top = 47
              Width = 77
              Height = 13
              Caption = 'lbDefaultHeapId'
            end
            object lbAvailPhys: TLabel
              Left = 94
              Top = 64
              Width = 52
              Height = 13
              Caption = 'lbModuleId'
            end
            object lbTotalVirtual: TLabel
              Left = 94
              Top = 112
              Width = 43
              Height = 13
              Caption = 'lbPrioritet'
            end
            object lbAvailVirtual: TLabel
              Left = 94
              Top = 128
              Width = 28
              Height = 13
              Caption = 'lbFlag'
            end
            object ld1: TLabel
              Left = 7
              Top = 16
              Width = 54
              Height = 13
              Caption = 'PageSize'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label21: TLabel
              Left = 7
              Top = 32
              Width = 72
              Height = 13
              Caption = 'MemoryLoad'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label22: TLabel
              Left = 7
              Top = 48
              Width = 57
              Height = 13
              Caption = 'TotalPhys'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label23: TLabel
              Left = 7
              Top = 64
              Width = 56
              Height = 13
              Caption = 'AvailPhys'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label24: TLabel
              Left = 7
              Top = 80
              Width = 79
              Height = 13
              Caption = 'TotalPageFile'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label25: TLabel
              Left = 7
              Top = 96
              Width = 78
              Height = 13
              Caption = 'AvailPageFile'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label26: TLabel
              Left = 7
              Top = 112
              Width = 66
              Height = 13
              Caption = 'TotalVirtual'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label27: TLabel
              Left = 7
              Top = 128
              Width = 65
              Height = 13
              Caption = 'AvailVirtual'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
          object GroupBox1: TGroupBox
            Left = 204
            Top = 5
            Width = 209
            Height = 158
            Caption = 'Process Info'
            TabOrder = 1
            object lbProcessID: TLabel
              Left = 105
              Top = 44
              Width = 57
              Height = 13
              Caption = 'lbProcessID'
            end
            object lbProcessPID: TLabel
              Left = 106
              Top = 108
              Width = 64
              Height = 13
              Caption = 'lbProcessPID'
            end
            object lbCountThreads: TLabel
              Left = 106
              Top = 92
              Width = 75
              Height = 13
              Caption = 'lbCountThreads'
            end
            object lbSize: TLabel
              Left = 105
              Top = 12
              Width = 28
              Height = 13
              Caption = 'lbSize'
            end
            object lbUsage: TLabel
              Left = 105
              Top = 28
              Width = 39
              Height = 13
              Caption = 'lbUsage'
            end
            object lbDefaultHeapId: TLabel
              Left = 105
              Top = 60
              Width = 77
              Height = 13
              Caption = 'lbDefaultHeapId'
            end
            object lbModuleId: TLabel
              Left = 106
              Top = 76
              Width = 52
              Height = 13
              Caption = 'lbModuleId'
            end
            object lbPrioritet: TLabel
              Left = 106
              Top = 124
              Width = 43
              Height = 13
              Caption = 'lbPrioritet'
            end
            object lbFlag: TLabel
              Left = 106
              Top = 140
              Width = 28
              Height = 13
              Caption = 'lbFlag'
            end
            object Label1: TLabel
              Left = 7
              Top = 12
              Width = 25
              Height = 13
              Caption = 'Size'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label2: TLabel
              Left = 7
              Top = 28
              Width = 37
              Height = 13
              Caption = 'Usage'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label3: TLabel
              Left = 7
              Top = 44
              Width = 57
              Height = 13
              Caption = 'ProcessId'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label4: TLabel
              Left = 7
              Top = 60
              Width = 42
              Height = 13
              Caption = 'HeapId'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 7
              Top = 76
              Width = 53
              Height = 13
              Caption = 'ModuleId'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label6: TLabel
              Left = 7
              Top = 92
              Width = 80
              Height = 13
              Caption = 'CountThreads'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label7: TLabel
              Left = 7
              Top = 108
              Width = 94
              Height = 13
              Caption = 'ProcessParentId'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label8: TLabel
              Left = 7
              Top = 124
              Width = 45
              Height = 13
              Caption = 'Prioritet'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label9: TLabel
              Left = 7
              Top = 140
              Width = 25
              Height = 13
              Caption = 'Flag'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
      end
    end
  end
  object pmThreads: TPopupMenu
    OnPopup = pmThreadsPopup
    Left = 177
    Top = 160
    object miThreadTerminate: TMenuItem
      Caption = 'Terminate'
      Default = True
      OnClick = miThreadTerminateClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miThreadPri: TMenuItem
      Caption = 'Prioritet'
      object miThIdle: TMenuItem
        Caption = 'IDLE'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThLowest: TMenuItem
        Caption = 'LOWEST'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThBelowNormal: TMenuItem
        Caption = 'BELOW NORMAL'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThNormal: TMenuItem
        Caption = 'NORMAL'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThAboveNormal: TMenuItem
        Caption = 'ABOVE NORMAL'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThHighest: TMenuItem
        Caption = 'HIGHEST'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
      object miThTimeCritical: TMenuItem
        Caption = 'TIME CRITICAL'
        GroupIndex = 2
        RadioItem = True
        OnClick = miThTimeCriticalClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miThreadWindows: TMenuItem
      Caption = 'Windows'
      ImageIndex = 5
      OnClick = miThreadWindowsClick
    end
  end
  object pmModules: TPopupMenu
    OnPopup = pmModulesPopup
    Left = 105
    Top = 184
    object miFileInfo: TMenuItem
      Caption = 'File Information'
      Default = True
      ImageIndex = 6
      OnClick = miFileInfoClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miModuleUnload: TMenuItem
      Caption = 'Unload'
      Enabled = False
      Visible = False
      OnClick = miModuleUnloadClick
    end
  end
  object SmallIl: TImageList
    Left = 80
    Top = 128
  end
  object ilThread: TImageList
    Left = 121
    Top = 125
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000BF000000BF0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000BF000000BF0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000BF000000BF000000BF000000BF000000BF000000BF0000FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000BF000000BF000000BF000000BF000000BF000000BF0000FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000BF000000BF0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000BF000000BF0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C000000000000000
      8000000000000000800000000000000080000000000000008000000000000000
      8000000000000000800000000000000080000000000000008000000000000000
      8000000000000000800000000000000080000000000000008001000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end

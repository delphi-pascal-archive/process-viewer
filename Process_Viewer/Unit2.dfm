object fmDumpMem: TfmDumpMem
  Left = 76
  Top = 99
  Width = 685
  Height = 435
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Dump Memory'
  Color = clBtnFace
  Constraints.MinHeight = 435
  Constraints.MinWidth = 685
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 677
    Height = 408
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 677
      Height = 408
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      object Panel4: TPanel
        Left = 5
        Top = 223
        Width = 667
        Height = 180
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Panel2: TPanel
          Left = 582
          Top = 0
          Width = 85
          Height = 180
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
          object lbCount: TLabel
            Left = 8
            Top = 13
            Width = 40
            Height = 13
            Caption = 'Count: 0'
          end
          object btClose: TBitBtn
            Left = 7
            Top = 150
            Width = 75
            Height = 25
            Cancel = True
            Caption = 'Close'
            ModalResult = 1
            TabOrder = 4
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
          object btInfo: TBitBtn
            Left = 7
            Top = 120
            Width = 75
            Height = 25
            Caption = 'Process'
            TabOrder = 3
            OnClick = btInfoClick
            Glyph.Data = {
              66010000424D6601000000000000760000002800000014000000140000000100
              040000000000F000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333300003333333333333333333300003333333333333333333300003333
              3333003333333333000033333330FF033333333300003333330FFFF033333333
              00003333330FF08703333333000033333338FF0033333333000033333330FF83
              333333330000333333338FF0333333330000333333300FF83333333300003333
              330780FF03333333000033333330FFFF033333330000333333330FF033333333
              00003333333330033333333300003333333333003333333300003333333330FF
              0333333300003333333330FF0333333300003333333333003333333300003333
              33333333333333330000}
            Margin = 0
          end
          object btSave: TBitBtn
            Left = 7
            Top = 60
            Width = 75
            Height = 25
            Caption = 'Save List'
            TabOrder = 1
            OnClick = btSaveClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
              DADAAD0000000000000DD03300000088030AA03300000088030DD03300000088
              030AA03300000000030DD03333333333330AA03300000000330DD03088888888
              030AA03088888888030DD03088888888030AA03088888888030DD03088888888
              000AA03088888888080DD00000000000000AADADADADADADADAD}
          end
          object btLoad: TBitBtn
            Left = 7
            Top = 90
            Width = 75
            Height = 25
            Caption = 'Load List'
            TabOrder = 2
            OnClick = btLoadClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
              DADAADADADADADADADAD00000000000ADADA003333333330ADAD0B0333333333
              0ADA0FB03333333330AD0BFB03333333330A0FBFB000000000000BFBFBFBFB0A
              DADA0FBFBFBFBF0DADAD0BFB0000000ADADAA000ADADADAD000DDADADADADADA
              D00AADADADAD0DAD0D0DDADADADAD000DADAADADADADADADADAD}
          end
          object btStopFill: TBitBtn
            Left = 7
            Top = 30
            Width = 75
            Height = 25
            Cancel = True
            Caption = 'Stop Fill'
            TabOrder = 0
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
        end
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 244
          Height = 180
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object Label33: TLabel
            Left = 9
            Top = 9
            Width = 65
            Height = 13
            Caption = 'Start address:'
          end
          object GroupBox3: TGroupBox
            Left = 0
            Top = 32
            Width = 242
            Height = 143
            Caption = 'Memory Basic Information'
            TabOrder = 2
            object lbAllocationBase: TLabel
              Left = 98
              Top = 30
              Width = 6
              Height = 13
              Caption = '0'
            end
            object lbProtect: TLabel
              Left = 99
              Top = 93
              Width = 26
              Height = 13
              Caption = 'None'
            end
            object lbState: TLabel
              Left = 99
              Top = 77
              Width = 26
              Height = 13
              Caption = 'None'
            end
            object lbBaseAddress: TLabel
              Left = 98
              Top = 15
              Width = 6
              Height = 13
              Caption = '0'
            end
            object lbAllocationProtect: TLabel
              Left = 98
              Top = 45
              Width = 26
              Height = 13
              Caption = 'None'
            end
            object lbRegionSize: TLabel
              Left = 99
              Top = 61
              Width = 6
              Height = 13
              Caption = '0'
            end
            object lbType_9: TLabel
              Left = 99
              Top = 109
              Width = 26
              Height = 13
              Caption = 'None'
            end
            object Label17: TLabel
              Left = 11
              Top = 15
              Width = 62
              Height = 13
              Caption = 'BaseAddress'
            end
            object Label18: TLabel
              Left = 11
              Top = 30
              Width = 70
              Height = 13
              Caption = 'AllocationBase'
            end
            object Label19: TLabel
              Left = 11
              Top = 45
              Width = 80
              Height = 13
              Caption = 'AllocationProtect'
            end
            object Label20: TLabel
              Left = 11
              Top = 61
              Width = 54
              Height = 13
              Caption = 'RegionSize'
            end
            object Label28: TLabel
              Left = 11
              Top = 77
              Width = 25
              Height = 13
              Caption = 'State'
            end
            object Label29: TLabel
              Left = 11
              Top = 93
              Width = 34
              Height = 13
              Caption = 'Protect'
            end
            object Label30: TLabel
              Left = 11
              Top = 109
              Width = 36
              Height = 13
              Caption = 'Type_9'
            end
            object Label31: TLabel
              Left = 11
              Top = 125
              Width = 35
              Height = 13
              Caption = 'Module'
            end
            object lbModule: TLabel
              Left = 99
              Top = 125
              Width = 26
              Height = 13
              Caption = 'None'
            end
          end
          object btGo: TBitBtn
            Left = 168
            Top = 6
            Width = 74
            Height = 21
            Caption = 'Go'
            TabOrder = 1
            OnClick = btGoClick
          end
          object cbStart: TComboBox
            Left = 80
            Top = 6
            Width = 88
            Height = 21
            ItemHeight = 13
            MaxLength = 8
            Sorted = True
            TabOrder = 0
            OnKeyDown = edStartKeyDown
            OnKeyPress = edStartKeyPress
          end
        end
        object Panel8: TPanel
          Left = 244
          Top = 0
          Width = 338
          Height = 180
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 1
          object LV: TListView
            Left = 5
            Top = 41
            Width = 328
            Height = 134
            Align = alClient
            Checkboxes = True
            Columns = <
              item
                AutoSize = True
                Caption = 'Address'
              end
              item
                AutoSize = True
                Caption = 'Type'
              end
              item
                Alignment = taRightJustify
                AutoSize = True
                Caption = 'OldValue'
              end
              item
                Alignment = taRightJustify
                AutoSize = True
                Caption = 'NewValue'
              end
              item
                AutoSize = True
                Caption = 'Hint'
              end>
            GridLines = True
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = pm
            TabOrder = 1
            ViewStyle = vsReport
            OnColumnClick = LVColumnClick
            OnCustomDrawItem = LVCustomDrawItem
            OnDblClick = LVDblClick
            OnKeyDown = LVKeyDown
          end
          object Panel9: TPanel
            Left = 5
            Top = 5
            Width = 328
            Height = 36
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object cbOnTimer: TCheckBox
              Left = 2
              Top = 17
              Width = 233
              Height = 17
              Caption = 'Write NewValue in ListView from delay in ms:'
              TabOrder = 1
              OnClick = cbOnTimerClick
            end
            object cbRef: TCheckBox
              Left = 2
              Top = 0
              Width = 138
              Height = 17
              Caption = 'Update on Refresh Click'
              TabOrder = 0
            end
            object edTime: TEdit
              Left = 235
              Top = 11
              Width = 40
              Height = 21
              MaxLength = 5
              ReadOnly = True
              TabOrder = 2
              Text = '500'
            end
            object udTime: TUpDown
              Left = 275
              Top = 11
              Width = 15
              Height = 21
              Associate = edTime
              Min = 100
              Max = 10000
              Increment = 100
              Position = 500
              TabOrder = 3
              Thousands = False
              Wrap = False
              OnChanging = udTimeChanging
            end
          end
        end
      end
      object Panel5: TPanel
        Left = 5
        Top = 5
        Width = 667
        Height = 218
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object sg: TStringGrid
          Left = 0
          Top = 0
          Width = 576
          Height = 218
          Align = alClient
          ColCount = 18
          DefaultColWidth = 20
          DefaultRowHeight = 18
          FixedColor = clBtnShadow
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing]
          ParentFont = False
          PopupMenu = pmRO
          TabOrder = 0
          OnDrawCell = sgDrawCell
          OnExit = sgExit
          OnKeyDown = sgKeyDown
          OnKeyPress = sgKeyPress
          OnMouseDown = sgMouseDown
          OnSelectCell = sgSelectCell
          OnSetEditText = sgSetEditText
        end
        object Panel6: TPanel
          Left = 576
          Top = 0
          Width = 91
          Height = 218
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btPrev: TBitBtn
            Left = 11
            Top = 0
            Width = 78
            Height = 25
            Caption = 'Prev Page'
            TabOrder = 0
            OnClick = btPrevClick
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077770000077770007777066607777000777706660777
              7000777706660777700070000666000070007706666666077000777066666077
              7000777706660777700077777060777770007777770777777000777777777777
              7000}
          end
          object btNext: TBitBtn
            Left = 11
            Top = 29
            Width = 78
            Height = 25
            Caption = 'Next Page'
            TabOrder = 1
            OnClick = btNextClick
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777707777770007777706077777000777706660777
              7000777066666077700077066666660770007000066600007000777706660777
              7000777706660777700077770666077770007777000007777000777777777777
              7000}
          end
          object btrefresh: TBitBtn
            Left = 11
            Top = 58
            Width = 78
            Height = 25
            Caption = 'Refresh'
            TabOrder = 2
            OnClick = btrefreshClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DA0000000000
              000AAD0FFFFFFFFFFF0DDA0FFFFF2FFFFF0AAD0FFFF22FFFFF0DDA0FFF22222F
              FF0AAD0FFFF22FF2FF0DDA0FFFFF2FF2FF0AAD0FF2FFFFF2FF0DDA0FF2FF2FFF
              FF0AAD0FF2FF22FFFF0DDA0FFF22222FFF0AAD0FFFFF22FFFF0DDA0FFFFF2FF0
              000AAD0FFFFFFFF0F0ADDA0FFFFFFFF00ADAAD0000000000ADAD}
            Margin = 6
          end
          object btSearch: TBitBtn
            Left = 11
            Top = 87
            Width = 78
            Height = 25
            Caption = 'Search'
            TabOrder = 3
            OnClick = btSearchClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
              DADAADADADADADADADAD00000ADADA00000A0F000DADAD0F000D0F000ADADA0F
              000A0000000D0000000D00F000000F00000A00F000A00F00000D00F000D00F00
              000AA0000000000000ADDA0F000A0F000ADAAD00000D00000DADDAD000DAD000
              DADAADA0F0ADA0F0ADADDAD000DAD000DADAADADADADADADADAD}
          end
          object btApply: TBitBtn
            Left = 11
            Top = 145
            Width = 78
            Height = 25
            Caption = 'Apply'
            Enabled = False
            TabOrder = 5
            OnClick = btApplyClick
            Glyph.Data = {
              42010000424D4201000000000000760000002800000011000000110000000100
              040000000000CC00000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7777700000007777777777777777700000007777777774F77777700000007777
              7777444F77777000000077777774444F777770000000700000444F44F7777000
              000070FFF444F0744F777000000070F8884FF0774F777000000070FFFFFFF077
              74F77000000070F88888F077774F7000000070FFFFFFF0777774F000000070F8
              8777F07777774000000070FFFF00007777777000000070F88707077777777000
              000070FFFF007777777770000000700000077777777770000000777777777777
              777770000000}
            Margin = 10
          end
          object cbMulti: TCheckBox
            Left = 11
            Top = 200
            Width = 74
            Height = 17
            Caption = 'Multiselect'
            TabOrder = 7
            OnClick = cbMultiClick
          end
          object btSaveMem: TBitBtn
            Left = 11
            Top = 174
            Width = 78
            Height = 25
            Caption = 'Save Mem'
            TabOrder = 6
            OnClick = btSaveMemClick
          end
          object btClearMem: TBitBtn
            Left = 11
            Top = 116
            Width = 78
            Height = 25
            Caption = '0'
            TabOrder = 4
            OnClick = btClearMemClick
          end
        end
      end
    end
  end
  object pm: TPopupMenu
    OnPopup = pmPopup
    Left = 346
    Top = 268
    object miGotoAddr: TMenuItem
      Caption = 'Go to Address'
      OnClick = miGotoAddrClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miAdd: TMenuItem
      Caption = 'Add'
      OnClick = miAddClick
    end
    object miChange: TMenuItem
      Caption = 'Change'
      OnClick = miChangeClick
    end
    object miRemove: TMenuItem
      Caption = 'Remove'
      OnClick = miRemoveClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miSpec: TMenuItem
      Caption = 'Specific'
      OnClick = miSpecClick
    end
    object miRemoveAll: TMenuItem
      Caption = 'Remove all'
      OnClick = miRemoveAllClick
    end
  end
  object pmRO: TPopupMenu
    OnPopup = pmROPopup
    Left = 261
    Top = 117
    object miAddToLV: TMenuItem
      Caption = 'Add to ListView'
      OnClick = miAddToLVClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miFont: TMenuItem
      Caption = 'Font'
      OnClick = miFontClick
    end
  end
  object pmSETime: TPopupMenu
    Left = 477
    Top = 269
  end
  object tm: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmTimer
    Left = 442
    Top = 268
  end
  object sd: TSaveDialog
    DefaultExt = '*.pvd'
    Filter = '(Process View files *.pvd)|*.pvd|(All files *.*)|*.*'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 541
    Top = 253
  end
  object od: TOpenDialog
    DefaultExt = '*.pvd'
    Filter = '(Process View files *.pvd)|*.pvd|(All files *.*)|*.*'
    Options = [ofEnableSizing]
    Left = 539
    Top = 276
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 349
    Top = 117
  end
end

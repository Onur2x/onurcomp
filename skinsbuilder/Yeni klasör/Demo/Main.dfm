object wndMain: TwndMain
  Left = 334
  Height = 899
  Top = 262
  Width = 974
  Caption = 'MiTeC Object Inspector Test'
  ClientHeight = 899
  ClientWidth = 974
  Color = clBtnFace
  DesignTimePPI = 120
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Shell Dlg 2'
  OnCreate = FormCreate
  Position = poScreenCenter
  object Tree: TTreeView
    Left = 10
    Height = 314
    Top = 10
    Width = 328
    HideSelection = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    OnClick = TreeClick
    Options = [tvoAutoItemHeight, tvoKeepCollapsedNodes, tvoReadOnly, tvoShowButtons, tvoShowLines, tvoShowRoot, tvoToolTips, tvoThemedDraw]
  end
  object ScrollBox: TScrollBox
    Left = 345
    Height = 849
    Top = 10
    Width = 613
    HorzScrollBar.Page = 588
    VertScrollBar.Page = 481
    Anchors = [akTop, akLeft, akRight, akBottom]
    ClientHeight = 845
    ClientWidth = 609
    Color = clWhite
    ParentColor = False
    TabOrder = 1
    object Panel1: TPanel
      Left = 22
      Height = 460
      Top = 21
      Width = 566
      BorderWidth = 3
      Caption = ' '
      ClientHeight = 460
      ClientWidth = 566
      TabOrder = 0
      OnClick = ObjectClick
      object Label1: TLabel
        Left = 201
        Height = 17
        Top = 60
        Width = 39
        Caption = 'Label1'
        OnClick = ObjectClick
      end
      object Shape1: TShape
        Left = 274
        Height = 49
        Top = 46
        Width = 81
        Shape = stRoundSquare
      end
      object Panel2: TPanel
        Left = 4
        Height = 28
        Top = 4
        Width = 558
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = ' TForm'
        Color = 9392694
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = ObjectClick
        OnMouseDown = Panel2MouseDown
      end
      object RadioButton1: TRadioButton
        Left = 385
        Height = 21
        Top = 59
        Width = 105
        Caption = 'RadioButton1'
        OnClick = ObjectClick
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 29
        Height = 25
        Top = 60
        Width = 151
        OnClick = ObjectClick
        TabOrder = 2
        Text = 'Edit1'
      end
      object Button1: TButton
        Left = 29
        Height = 31
        Top = 101
        Width = 94
        Caption = 'Button1'
        OnClick = ObjectClick
        TabOrder = 3
      end
      object ListBox1: TListBox
        Left = 21
        Height = 121
        Top = 175
        Width = 151
        Color = 15921906
        Items.Strings = (
          'item1'
          'item2'
          'item3'
        )
        ItemHeight = 17
        OnClick = ObjectClick
        TabOrder = 4
      end
      object StatusBar1: TStatusBar
        Left = 4
        Height = 29
        Top = 427
        Width = 558
        Panels = <>
        SimplePanel = False
        OnClick = ObjectClick
      end
    end
  end
  object tc: TTabControl
    Cursor = crHandPoint
    Left = 10
    Height = 528
    Top = 331
    Width = 328
    OnChange = tcChange
    TabIndex = 0
    Tabs.Strings = (
      'Properties'
      'Events'
    )
    Anchors = [akTop, akLeft, akBottom]
    TabOrder = 2
    object List: TListView
      Left = 2
      Height = 476
      Top = 25
      Width = 324
      Align = alClient
      Columns = <      
        item
          Caption = '     Name'
          Width = 125
        end      
        item
          Caption = 'Value'
          Width = 156
        end>
      ColumnClick = False
      HideSelection = False
      ParentShowHint = False
      ReadOnly = True
      RowSelect = True
      ShowHint = True
      SmallImages = ImageList1
      TabOrder = 0
      ViewStyle = vsReport
      OnAdvancedCustomDrawItem = ListAdvancedCustomDrawItem
      OnAdvancedCustomDrawSubItem = ListAdvancedCustomDrawSubItem
      OnDblClick = ListDblClick
      OnKeyUp = ListKeyUp
      OnMouseUp = ListMouseUp
      OnSelectItem = ListSelectItem
    end
    object StatPanel: TPanel
      Left = 2
      Height = 25
      Top = 501
      Width = 324
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
  object ImageList1: TImageList
    BkColor = clCream
    Left = 141
    Top = 260
    Bitmap = {
      4C7A020000001000000010000000A50000000000000078DAEDD32B0EC3300C80
      611FA9C7D83176A41C21B030702C8683818581858695065C3BC9A4AEAA945405
      ABAA829FF953D287E9C34017099DF512A4FA6506D01A783E3A5FF1C0CCBF4D12
      111045F5B0CB17CB6263C0BAEFEDA6A5513CBA66AF73EBDABCC9E74EE5DC280D
      0148EE1E5EB6D1AFEC80FB7C7957F1EDD29DD57DAB79FDBE5BCFBEC8D385FEF7
      BB73EFBFCE1FD9FFECFFB7FF69FEC0FE677FEFFF999B01AFD34983
    }
  end
end

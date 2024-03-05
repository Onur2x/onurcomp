object Form1: TForm1
  Left = 122
  Top = 105
  Width = 609
  Height = 458
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object panelresimli5: TPanel
    Left = 414
    Top = 0
    Width = 187
    Height = 424
    Align = alRight
    TabOrder = 0
    AutoSize = False
    Stili = Normal
    object Label1: TLabel
      Left = 2
      Top = 30
      Width = 15
      Height = 13
      Caption = 'Sol'
    end
    object Label2: TLabel
      Left = 2
      Top = 52
      Width = 16
      Height = 13
      Caption = #220'st'
    end
    object Label3: TLabel
      Left = 3
      Top = 78
      Width = 46
      Height = 13
      Caption = 'Y'#252'kseklik'
    end
    object Label4: TLabel
      Left = 3
      Top = 103
      Width = 37
      Height = 13
      Caption = 'Geni'#351'lik'
    end
    object Label5: TLabel
      Left = 3
      Top = 129
      Width = 26
      Height = 13
      Caption = 'Renk'
    end
    object Label6: TLabel
      Left = 2
      Top = 154
      Width = 29
      Height = 13
      Caption = 'Resim'
    end
    object Label7: TLabel
      Left = 2
      Top = 172
      Width = 86
      Height = 13
      Caption = 'Transparent Renk'
    end
    object Label8: TLabel
      Left = 2
      Top = 192
      Width = 57
      Height = 13
      Caption = 'Transparent'
    end
    object Label9: TLabel
      Left = 3
      Top = 216
      Width = 51
      Height = 13
      Caption = 'Kontrol Ad'#305
    end
    object ac: TSpeedButton
      Left = 161
      Top = 145
      Width = 21
      Height = 22
      Caption = '...'
      OnClick = acClick
    end
    object SpeedButton1: TSpeedButton
      Left = 162
      Top = 121
      Width = 21
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label12: TLabel
      Left = 3
      Top = 248
      Width = 65
      Height = 13
      Caption = 'Resim D'#252'zeni'
    end
    object Edit1: TEdit
      Left = 91
      Top = 24
      Width = 89
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = Edit1Change
    end
    object Edit2: TEdit
      Left = 91
      Top = 48
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = Edit2Change
    end
    object Edit3: TEdit
      Left = 91
      Top = 72
      Width = 89
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = Edit3Change
    end
    object Edit4: TEdit
      Left = 91
      Top = 96
      Width = 89
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = Edit4Change
    end
    object Edit5: TEdit
      Left = 91
      Top = 120
      Width = 70
      Height = 21
      TabOrder = 4
      Text = '0000000000'
    end
    object Edit6: TEdit
      Left = 91
      Top = 144
      Width = 69
      Height = 21
      TabOrder = 5
    end
    object Edit7: TEdit
      Left = 91
      Top = 168
      Width = 89
      Height = 21
      TabOrder = 6
      Text = '0000000000'
    end
    object Edit8: TEdit
      Left = 91
      Top = 216
      Width = 89
      Height = 21
      Enabled = False
      TabOrder = 7
      Text = 'Bo'#351
    end
    object ComboBox1: TComboBox
      Left = 91
      Top = 192
      Width = 89
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 8
      Text = 'Aktif'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Aktif'
        'Pasif')
    end
    object ComboBox2: TComboBox
      Left = 90
      Top = 240
      Width = 89
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 9
      Text = 'Normal'
      OnChange = ComboBox2Change
      Items.Strings = (
        'Normal'
        'D'#246#351'e'
        'Kapla')
    end
  end
  object ana: Tpanel
    Left = 0
    Top = 0
    Width = 57
    Height = 424
    Align = alLeft
    TabOrder = 1
    AutoSize = False
    Stili = Normal
    object transparent: TLabel
      Left = 400
      Top = 24
      Width = 3
      Height = 13
      Visible = False
    end
    object secili: TLabel
      Left = 24
      Top = 48
      Width = 3
      Height = 13
      Visible = False
    end
    object sayi: TLabel
      Left = 40
      Top = 128
      Width = 6
      Height = 13
      Caption = '0'
      Visible = False
    end
    object o1: Tpanel
      Left = 8
      Top = 0
      Width = 273
      Height = 112
      Color = clSkyBlue
      TabOrder = 0
      AutoSize = False
      Stili = dose
      OnClick = o1Click
      OnMouseDown = o1MouseDown
      object o2: Tpanel
        Left = 8
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 0
        AutoSize = False
        Stili = Normal
        OnMouseDown = o2MouseDown
      end
      object o3: Tpanel
        Left = 38
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 1
        AutoSize = False
        Stili = Normal
        OnMouseDown = o3MouseDown
      end
      object o4: Tpanel
        Left = 65
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 2
        AutoSize = False
        Stili = Normal
        OnMouseDown = o4MouseDown
      end
      object o5: Tpanel
        Left = 90
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 3
        AutoSize = False
        Stili = Normal
        OnMouseDown = o5MouseDown
      end
      object o6: Tpanel
        Left = 115
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 4
        AutoSize = False
        Stili = Normal
        OnMouseDown = o6MouseDown
      end
      object o7: Tpanel
        Left = 141
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 5
        AutoSize = False
        Stili = Normal
        OnMouseDown = o7MouseDown
      end
      object o8: Tpanel
        Left = 167
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 6
        AutoSize = False
        Stili = Normal
        OnMouseDown = o8MouseDown
      end
      object o9: Tpanel
        Left = 192
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 7
        AutoSize = False
        Stili = Normal
        OnMouseDown = o9MouseDown
      end
      object o10: Tpanel
        Left = 217
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 8
        AutoSize = False
        Stili = Normal
        OnMouseDown = o10MouseDown
      end
      object o11: Tpanel
        Left = 242
        Top = 88
        Width = 22
        Height = 21
        TabOrder = 9
        AutoSize = False
        Stili = Normal
        OnMouseDown = o11MouseDown
      end
    end
    object o12: Tpanel
      Left = 8
      Top = 112
      Width = 273
      Height = 127
      Color = clSkyBlue
      TabOrder = 1
      AutoSize = False
      Stili = Normal
      OnMouseDown = o12MouseDown
      object o13: Tpanel
        Left = 5
        Top = 8
        Width = 39
        Height = 21
        TabOrder = 0
        AutoSize = False
        Stili = Normal
        OnMouseDown = o13MouseDown
      end
    end
    object o14: Tpanel
      Left = 8
      Top = 239
      Width = 273
      Height = 183
      Color = clSkyBlue
      TabOrder = 2
      AutoSize = False
      Stili = Normal
      OnMouseDown = o14MouseDown
    end
  end
  object panelresimli1: Tpanel
    Left = 289
    Top = 0
    Width = 125
    Height = 424
    Align = alClient
    TabOrder = 2
    AutoSize = False
    Stili = Normal
    object Label10: TLabel
      Left = 16
      Top = 176
      Width = 3
      Height = 13
    end
    object Label11: TLabel
      Left = 16
      Top = 240
      Width = 38
      Height = 13
      Caption = 'Label11'
    end
    object Button1: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Kaydet'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Yeni'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 88
      Width = 75
      Height = 25
      Caption = #214'nizleme'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 16
      Top = 128
      Width = 75
      Height = 25
      Caption = 'Button4'
      TabOrder = 3
    end
  end
  object Panel1: TPanel
    Left = 57
    Top = 0
    Width = 232
    Height = 424
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 3
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 571
    Top = 40
  end
  object ColorDialog1: TColorDialog
    Left = 561
    Top = 80
  end
end

object Form3: TForm3
  Left = 140
  Top = 108
  Width = 544
  Height = 375
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object JimZoomImage1: TJimZoomImage
    Left = 16
    Top = 8
    Width = 417
    Height = 137
  end
  object Label1: TLabel
    Left = 456
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 456
    Top = 72
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 152
    Width = 121
    Height = 185
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = ListBox1DblClick
  end
  object ResimPanel1: TResimPanel
    Left = 142
    Top = 152
    Width = 387
    Height = 185
    TabOrder = 1
    AutoSize = False
    Stili = Normal
    OnMouseMove = ResimPanel1MouseMove
  end
  object Button1: TButton
    Left = 440
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end

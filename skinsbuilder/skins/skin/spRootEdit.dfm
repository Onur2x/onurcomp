object spRootPathEditDlg: TspRootPathEditDlg
  Left = 266
  Top = 245
  Width = 376
  Height = 235
  Caption = 'Select Root Path'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Button1: TButton
    Left = 159
    Top = 165
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 265
    Top = 165
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 18
    Top = 4
    Width = 335
    Height = 61
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    object cbFolderType: TComboBox
      Left = 20
      Top = 26
      Width = 295
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
    end
  end
  object rbUseFolder: TRadioButton
    Left = 20
    Top = 4
    Width = 155
    Height = 21
    Caption = 'Use Standard &Folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = rbUseFolderClick
  end
  object GroupBox2: TGroupBox
    Left = 18
    Top = 76
    Width = 335
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    object ePath: TEdit
      Left = 20
      Top = 25
      Width = 294
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'C:\'
    end
    object rbUsePath: TRadioButton
      Left = 10
      Top = 0
      Width = 90
      Height = 21
      Caption = 'Use &Path'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbUsePathClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 288
    Top = 8
  end
end

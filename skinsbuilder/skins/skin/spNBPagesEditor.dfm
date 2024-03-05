object NBPagesForm: TNBPagesForm
  Left = 260
  Top = 247
  BorderStyle = bsDialog
  Caption = 'Pages'
  ClientHeight = 201
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 42
    Width = 58
    Height = 13
    Caption = 'ImageIndex:'
  end
  object PageListBox: TListBox
    Left = 8
    Top = 72
    Width = 169
    Height = 121
    ItemHeight = 13
    TabOrder = 0
    OnClick = PageListBoxClick
  end
  object CaptionEdit: TEdit
    Left = 8
    Top = 8
    Width = 169
    Height = 21
    TabOrder = 1
    OnChange = CaptionEditChange
  end
  object AddButton: TButton
    Left = 192
    Top = 72
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 2
    OnClick = AddButtonClick
  end
  object DeleteButton: TButton
    Left = 192
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Del&ete'
    TabOrder = 3
    OnClick = DeleteButtonClick
  end
  object MoveUpButton: TButton
    Left = 192
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Move &Up'
    TabOrder = 4
    OnClick = MoveUpButtonClick
  end
  object MoveDownButton: TButton
    Left = 192
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Move &Down'
    TabOrder = 5
    OnClick = MoveDownButtonClick
  end
  object IIndexBox: TComboBox
    Left = 96
    Top = 40
    Width = 81
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 6
    OnChange = IIndexBoxChange
  end
end

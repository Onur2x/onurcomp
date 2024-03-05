object FormTest: TFormTest
  Left = 192
  Top = 107
  BorderStyle = bsNone
  Caption = 'FormTest'
  ClientHeight = 513
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TSkinPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 513
    SkinChargeur = Chargeur
  end
  object Button: TSkinButton
    Left = 160
    Top = 88
    Width = 73
    Height = 89
    SkinChargeur = Chargeur
    visible = False
  end
  object Lab: TSkinLabel
    Left = 304
    Top = 88
    Width = 169
    Height = 65
    SkinChargeur = Chargeur
    visible = False
    Caption = 'Text'
    Couleur = clBlack
  end
  object Check: TSkinCheck
    Left = 528
    Top = 120
    Width = 137
    Height = 57
    SkinChargeur = Chargeur
    visible = False
    Etat = False
  end
  object Chargeur: TSkinChargeur
    DefaultSkin.Data = {70A0400100000030}
    Left = 56
    Top = 24
  end
end


{*******************************************************************}
{                                                                   }
{       SkinEngine                                                  }
{       Version 1                                                   }
{                                                                   }
{       Copyright (c) 1998-2003 Evgeny Kryukov                      }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT KS DEVELOPMENT WRITTEN   }
{   CONSENT AND PERMISSION FROM KS DEVELOPMENT.                     }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{   DISTRIBUTION OF THIS FILE IS NOT ALLOWED!                       }
{                                                                   }
{       Home:  http://www.ksdev.com                                 }
{       Support: support@ksdev.com                                  }
{       Questions: faq@ksdev.com                                    }
{                                                                   }
{*******************************************************************}
{
 $Id: SkinObjectStore.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinObjectStore;

{$I KSSKIN.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, Dialogs, KSDevBmp, SkinConst, SkinTypes, SkinObjects, SkinSound,
  SkinIniFiles, SkinUtils;

procedure LoadObjectFromStrings(Images: TList; SkinObject: TscSkinObject;
  ObjectName: string; Data: TscCustomIniFile);
procedure SaveObjectToStrings(SkinObject: TscSkinObject; Data: TscCustomIniFile);

{ internal }

function ExtractColor(S: string): TColor; 
function ExtractImage(SourceImage: TksBmp; S: string): TksBmp;
function GetImage(Images: TList; Name: string): TksBmp;
function GetSound(Sounds: TList; Name: string): TscSound;

implementation {===============================================================}

{ Extract from string }

function ExtractColor(S: string): TColor; // extract color from 0,0,0 string
var
  R, G, B: byte;
begin
  R := StrToInt(GetToken(S));
  G := StrToInt(GetToken(S));
  B := StrToInt(GetToken(S));
  Result := RGB(R, G, B);
end;

function ExtractAlign(S: string): TscAlign;
begin
  Result := saNone;
  if LowerCase(S) = 'mostleft' then Result := saMostLeft;
  if LowerCase(S) = 'mostright' then Result := saMostRight;
  if LowerCase(S) = 'mosttop' then Result := saMostTop;
  if LowerCase(S) = 'mostbottom' then Result := saMostBottom;
  if LowerCase(S) = 'left' then Result := saLeft;
  if LowerCase(S) = 'top' then Result := saTop;
  if LowerCase(S) = 'right' then Result := saRight;
  if LowerCase(S) = 'bottom' then Result := saBottom;
  if LowerCase(S) = 'client' then Result := saClient;
  if LowerCase(S) = 'topleft' then Result := saTopLeft;
  if LowerCase(S) = 'topright' then Result := saTopRight;
  if LowerCase(S) = 'bottomleft' then Result := saBottomLeft;
  if LowerCase(S) = 'bottomright' then Result := saBottomRight;
  if LowerCase(S) = 'center' then Result := saCenter;
  if LowerCase(S) = 'text' then Result := saText;
end;

function ExtractKind(S: string): TscKind;
begin
  Result := skNone;
  if LowerCase(S) = 'form' then Result := skForm;
  if LowerCase(S) = 'caption' then Result := skCaption;
  if LowerCase(S) = 'title' then Result := skTitle;
  if LowerCase(S) = 'top' then Result := skTop;
  if LowerCase(S) = 'left' then Result := skLeft;
  if LowerCase(S) = 'right' then Result := skRight;
  if LowerCase(S) = 'bottom' then Result := skBottom;
  if LowerCase(S) = 'topleft' then Result := skTopLeft;
  if LowerCase(S) = 'topright' then Result := skTopRight;
  if LowerCase(S) = 'bottomleft' then Result := skBottomLeft;
  if LowerCase(S) = 'bottomright' then Result := skBottomRight;

  if LowerCase(S) = 'menubar' then Result := skMenuBar;
  if LowerCase(S) = 'menubaritem' then Result := skMenuBarItem;

  if LowerCase(S) = 'popupmenu' then Result := skPopupMenu;
  if LowerCase(S) = 'popupmenuclient' then Result := skPopupMenuClient;
  if LowerCase(S) = 'popupmenuitem' then Result := skPopupMenuItem;

  if LowerCase(S) = 'sysbutton' then Result := skSysButton;
  if LowerCase(S) = 'client' then Result := skClient;

  if LowerCase(S) = 'button' then Result := skButton;
  if LowerCase(S) = 'buttonglyph' then Result := skButtonGlyph;
  if LowerCase(S) = 'buttontext' then Result := skButtonText;

  if LowerCase(S) = 'progressbar' then Result := skProgressBar;
  if LowerCase(S) = 'progressbarback' then Result := skProgressBarBack;
  if LowerCase(S) = 'progressbarfore' then Result := skProgressBarFore;

  if LowerCase(S) = 'panel' then Result := skPanel;
  if LowerCase(S) = 'paneltext' then Result := skPanelText;

  if LowerCase(S) = 'checkbox' then Result := skCheckBox;
  if LowerCase(S) = 'checkboxglyph' then Result := skCheckBoxGlyph;
  if LowerCase(S) = 'checkboxtext' then Result := skCheckBoxText;

  if LowerCase(S) = 'radiobutton' then Result := skRadioButton;
  if LowerCase(S) = 'radiobuttonglyph' then Result := skRadioButtonGlyph;
  if LowerCase(S) = 'radiobuttontext' then Result := skRadioButtonText;

  if LowerCase(S) = 'pagecontrol' then Result := skPageControl;
  if LowerCase(S) = 'pagecontroltab' then Result := skPageControlTab;
  if LowerCase(S) = 'pagecontrolclient' then Result := skPageControlClient;
end;

function ExtractTileStyle(S: string): TscTileStyle;
begin
  Result := tsTile;
  if LowerCase(S) = 'tile' then Result := tsTile;
  if LowerCase(S) = 'stretch' then Result := tsStretch;
  if LowerCase(S) = 'stretchlinear' then Result := tsStretchLinear;
  if LowerCase(S) = 'center' then Result := tsCenter;
end;

function ExtractTextAlign(S: string): TscTextAlign;
begin
  Result := taCenter;
  if LowerCase(S) = 'topleft' then Result := taTopLeft;
  if LowerCase(S) = 'topcenter' then Result := taTopCenter;
  if LowerCase(S) = 'topright' then Result := taTopRight;
  if LowerCase(S) = 'left' then Result := taLeft;
  if LowerCase(S) = 'center' then Result := taCenter;
  if LowerCase(S) = 'right' then Result := taRight;
  if LowerCase(S) = 'bottomleft' then Result := taBottomLeft;
  if LowerCase(S) = 'bottomcenter' then Result := taBottomCenter;
  if LowerCase(S) = 'bottomright' then Result := taBottomRight;
end;

function ExtractFontStyle(S: string): TFontStyles;
var
  Token: string;
begin
  Result := [];
  while S <> '' do
  begin
    Token := GetToken(S);
    if LowerCase(Token) = 'bold' then Result := Result + [fsBold];
    if LowerCase(Token) = 'italic' then Result := Result + [fsItalic];
  end;
end;

function ExtractVisible(S: string): TscVisibleSet;
var
  Token: string;
begin
  Result := [];
  while S <> '' do
  begin
    Token := LowerCase(GetToken(S));
    if Token = 'always' then Result := Result + [svAlways];
    if Token = 'active' then Result := Result + [svActive];
    if Token = 'inactive' then Result := Result + [svInactive];
    if Token = 'maximized' then Result := Result + [svMaximized];
    if Token = 'nomaximized' then Result := Result + [svNoMaximized];
    if Token = 'rollup' then Result := Result + [svRollup];
    if Token = 'norollup' then Result := Result + [svNoRollup];
    if Token = 'stayontop' then Result := Result + [svStayOnTop];
    if Token = 'nostayontop' then Result := Result + [svNoStayOnTop];

    if Token = 'help' then Result := Result + [svHelp];
    if Token = 'nohelp' then Result := Result + [svNoHelp];
    if Token = 'max' then Result := Result + [svMax];
    if Token = 'nomax' then Result := Result + [svNoMax];
    if Token = 'min' then Result := Result + [svMin];
    if Token = 'nomin' then Result := Result + [svNoMin];
    if Token = 'minmax' then Result := Result + [svMinMax];
    if Token = 'nominmax' then Result := Result + [svNoMinMax];
    if Token = 'sizeable' then Result := Result + [svSizeable];
    if Token = 'nosizeable' then Result := Result + [svNoSizeable];
    if Token = 'sysmenu' then Result := Result + [svSysMenu];
    if Token = 'nosysmenu' then Result := Result + [svNoSysMenu];
    if Token = 'close' then Result := Result + [svClose];
    if Token = 'noclose' then Result := Result + [svNoClose];
    if Token = 'menubar' then Result := Result + [svMenuBar];
    if Token = 'nomenubar' then Result := Result + [svNoMenuBar];
    { for WinControls }
    if Token = 'focused' then Result := Result + [svFocused];
    if Token = 'nofocused' then Result := Result + [svNoFocused];
    { for Buttons }
    if Token = 'default' then Result := Result + [svDefault];
    if Token = 'disabled' then Result := Result + [svDisabled];
    if Token = 'clicked' then Result := Result + [svClicked];
    { checkbox and radiobutton }
    if Token = 'checked' then Result := Result + [svChecked];
    if Token = 'nochecked' then Result := Result + [svNoChecked];
    if Token = 'grayed' then Result := Result + [svGrayed];
    { never visible }
    if Token = 'never' then Result := Result + [svNever];
    { PageControl }
    if Token = 'tabactive' then Result := Result + [svTabActive];
    if Token = 'tabnoactive' then Result := Result + [svTabNoActive];
  end;
end;

procedure ExtractEvent(Event: TStrings; S: string);
var
  str: string;

 function GetScriptLine(var S: string): string;
 var
   i: byte;
   CopyS: string; 
 begin
   Result := '';
   CopyS := S;
   for i := 1 to Length(S) do
   begin
     if CopyS[i] = ';' then Break;
     Result := Result + CopyS[i];
     Delete(S, 1, 1);
   end;
   Delete(S, 1, 1);
   Trim(Result);
   Trim(S);
 end;

begin
  Event.Clear;
  if S = '' then Exit;

  repeat
    str := GetScriptLine(S);
    Event.Add(str);
  until S = '';
end;

function ExtractImage(SourceImage: TksBmp; S: string): TksBmp;
var
  R: TRect;
  str: string;
begin
  if S = '' then
  begin
    Result := SourceImage.GetCopy;
  end
  else
  begin
    // Load rectangle
    try
      R := Rect(0, 0, SourceImage.Width, SourceImage.Height);
      str := GetToken(S);
      if str <> '' then R.left := StrToInt(str);
      str := GetToken(S);
      if str <> '' then R.top := StrToInt(str);
      str := GetToken(S);
      if str <> '' then R.right := StrToInt(str);
      str := GetToken(S);
      if str <> '' then R.bottom := StrToInt(str);

      Result := TksBmp.Create(R.right-R.left+1, R.bottom-R.top+1);
      SourceImage.CopyRect1(Result, R, 0, 0);
      Result.Rect := R;
    except
    end;
  end;
end;

function PackImage(Image: TksBmp): string;
begin
  Result := Image.Name;
  if (Image.Rect.Right <> 0) and
     (Image.Rect.Bottom <> 0) then
  with Image.Rect do
  begin
    Result := Result + ',' + IntToStr(left)+','+IntToStr(top)+','+IntToStr(right)+','+IntToStr(bottom);
  end;
end;

{ Pack to string }

function PackColor(C: TColor): string; // Pack color from 0,0,0 string
begin
  C := ColorToRGB(C);
  Result := IntToStr(GetRValue(C))+','+IntToStr(GetGValue(C))+','+IntToStr(GetBValue(C));
end;

function PackAlign(A: TscAlign): string;
begin
  case A of
    saLeft: Result := 'left';
    saMostLeft: Result := 'mostleft';
    saTop: Result := 'top';
    saMostTop: Result := 'mosttop';
    saRight: Result := 'right';
    saMostRight: Result := 'mostright';
    saBottom: Result := 'bottom';
    saMostBottom: Result := 'mostbottom';
    saClient: Result := 'client';
    saTopLeft: Result := 'topleft';
    saTopRight: Result := 'topright';
    saBottomLeft: Result := 'bottomleft';
    saBottomRight: Result := 'bottomright';
    saCenter: Result := 'center';
    saText: Result := 'text';
  else
    Result := '';
  end;
end;

function PackKind(K: TscKind): string;
begin
  case K of
    skForm: Result := 'form';
    skCaption: Result := 'caption';
    skTitle: Result := 'title';
    skTop: Result := 'top';
    skLeft: Result := 'left';
    skRight: Result := 'right';
    skBottom: Result := 'bottom';
    skTopLeft: Result := 'topleft';
    skTopRight: Result := 'topright';
    skBottomLeft: Result := 'bottomleft';
    skBottomRight: Result := 'bottomright';
    skMenuBar: Result := 'menubar';
    skMenuBarItem: Result := 'menubaritem';
    skPopupMenu: Result := 'popupmenu';
    skPopupMenuItem: Result := 'popupmenuitem';
    skPopupMenuClient: Result := 'popupmenuclient';
    skSysButton: Result := 'sysbutton';
    skClient: Result := 'client';

    skButton: Result := 'button';
    skButtonGlyph: Result := 'buttonglyph';
    skButtonText: Result := 'buttontext';

    skProgressBar: Result := 'progressbar';
    skProgressBarBack: Result := 'progressbarback';
    skProgressBarFore: Result := 'progressbarfore';

    skPanel: Result := 'panel';
    skPanelText: Result := 'paneltext';

    skCheckBox: Result := 'checkbox';
    skCheckBoxGlyph: Result := 'checkboxglyph';
    skCheckBoxText: Result := 'checkboxtext';

    skRadioButton: Result := 'radiobutton';
    skRadioButtonGlyph: Result := 'radiobuttonglyph';
    skRadioButtonText: Result := 'radiobuttontext';

    skPageControl: Result := 'pagecontrol';
    skPageControlTab: Result := 'pagecontroltab';
    skPageControlClient: Result := 'pagecontrolclient';
  else
    Result := '';
  end;
end;

function PackTileStyle(TS: TscTileStyle): string;
begin
  case TS of
    tsTile: Result := 'tile';
    tsStretch: Result := 'stretch';
    tsStretchLinear: Result := 'stretchlinear';
    tsCenter: Result := 'center';
  end;
end;

function PackTextAlign(TA: TscTextAlign): string;
begin
  case TA of
    taTopLeft: Result := 'topleft';
    taTopCenter: Result := 'topcenter';
    taTopRight: Result := 'topright';
    taLeft: Result := 'left';
    taCenter: Result := 'center';
    taRight: Result := 'right';
    taBottomLeft: Result := 'bottomleft';
    taBottomCenter: Result := 'bottomleft';
    taBottomRight: Result := 'bottomleft';
  end;
end;

function PackFontStyle(FS: TFontStyles): string;
var
  Token: string;
begin
  Result := '';
  if fsBold in FS then Result := Result + 'bold';
  if fsItalic in FS then
    if Result = '' then
      Result := Result + 'italic'
    else
      Result := Result + ',italic';
end;

function PackVisible(VS: TscVisibleSet): string;
 procedure AddStr(S: string);
 begin
   if Result <> '' then
     Result := Result + ',' + S
   else
     Result := S;
 end;
begin
  Result := '';
  if svAlways in VS then AddStr('always');
  { window state }
  if svActive in VS then AddStr('active');
  if svInactive in VS then AddStr('inactive');
  if svMaximized in VS then AddStr('maximized');
  if svNoMaximized in VS then AddStr('nomaximized');
  if svRollup in VS then AddStr('rollup');
  if svNoRollup in VS then AddStr('norollup');
  if svStayOnTop in VS then AddStr('stayontop');
  if svNoStayOnTop in VS then AddStr('nostayontop');
  if svMenuBar in VS then AddStr('menubar');
  if svNoMenuBar in VS then AddStr('nomenubar');
  { System button }
  if svHelp in VS then AddStr('help');
  if svNoHelp in VS then AddStr('nohelp');
  if svMax in VS then AddStr('max');
  if svNoMax in VS then AddStr('nomax');
  if svMin in VS then AddStr('min');
  if svNoMin in VS then AddStr('nomin');
  if svMinMax in VS then AddStr('minmax');
  if svNoMinMax in VS then AddStr('nominmax');
  if svSizeable in VS then AddStr('sizeable');
  if svNoSizeable in VS then AddStr('nosizeable');
  if svSysMenu in VS then AddStr('sysmenu');
  if svNoSysMenu in VS then AddStr('nosysmenu');
  if svClose in VS then AddStr('close');
  if svNoClose in VS then AddStr('noclose');
  { for WinControls }
  if svFocused in VS then AddStr('focused');
  if svNoFocused in VS then AddStr('nofocused');
  { for Buttons }
  if svDefault in VS then AddStr('default');
  if svDisabled in VS then AddStr('disabled');
  if svClicked in VS then AddStr('clicked');
  { for CheckBox and RadioButton }
  if svChecked in VS then AddStr('checked');
  if svNoChecked in VS then AddStr('nochecked');
  if svGrayed in VS then AddStr('grayed');
  { never visible }
  if svNever in VS then AddStr('never');
  { for PageControl }
  if svTabActive in VS then AddStr('tabactive');
  if svTabNoActive in VS then AddStr('tabnoactive');
end;

function PackEvent(Event: TStrings): string;
var
  i: integer;
begin
  Result := '';
  if Event.Text = '' then Exit;
  for i := 0 to Event.Count-1 do
    if Result = '' then
      Result := Event[i]
    else
      Result := Result + ';' + Event[i]
end;

{ Load functions ==============================================================}

function GetImage(Images: TList; Name: string): TksBmp;
var
  i: integer;
begin
  for i := 0 to Images.Count-1 do
    if LowerCase(TksBmp(Images[i]).Name) = LowerCase(Name) then
    begin
      Result := Images[i];
      Exit;
    end;
  Result := nil;
end;

function GetSound(Sounds: TList; Name: string): TscSound;
var
  i: integer;
begin
  for i := 0 to Sounds.Count-1 do
    if LowerCase(TscSound(Sounds[i]).Name) = LowerCase(Name) then
    begin
      Result := Sounds[i];
      Exit;
    end;
  Result := nil;
end;

procedure LoadObjectFromStrings(Images: TList; SkinObject: TscSkinObject;
  ObjectName: string; Data: TscCustomIniFile);
var
  S, Word: string;
  Obj: TscSkinObject;
  TempImage: TksBmp;
begin
  with SkinObject do
  begin
    Name := ObjectName;
    
    S := Data.ReadString(ObjectName, 'Align', '');
    if S <> '' then Align := ExtractAlign(S);

    S := Data.ReadString(ObjectName, 'Transparency', '');
    if S <> '' then Transparency := StrToInt(S);

    S := Data.ReadString(ObjectName, 'TileStyle', '');
    if S <> '' then TileStyle := ExtractTileStyle(S);

    S := Data.ReadString(ObjectName, 'Kind', '');
    if S <> '' then Kind := ExtractKind(S);

    S := Data.ReadString(ObjectName, 'Visible', '');
    if S <> '' then Visible := ExtractVisible(S);

    S := Data.ReadString(ObjectName, 'Color', '');
    if S <> '' then Color := ExtractColor(S);

    S := Data.ReadString(ObjectName, 'FontName', '');
    if S <> '' then FontName := S;
    S := Data.ReadString(ObjectName, 'FontSize', '');
    if S <> '' then FontSize := StrToInt(S);
    S := Data.ReadString(ObjectName, 'FontStyle', '');
    if S <> '' then FontStyle := ExtractFontStyle(S);

    S := Data.ReadString(ObjectName, 'TextColor', '');
    if S <> '' then TextColor := ExtractColor(S);
    S := Data.ReadString(ObjectName, 'DisabledTextColor', '');
    if S <> '' then DisabledTextColor := ExtractColor(S);
    S := Data.ReadString(ObjectName, 'TextAlign', '');;
    if S <> '' then TextAlign := ExtractTextAlign(S);

    { Extract image }
    S := Data.ReadString(ObjectName, 'Image', '');
    if S <> '' then
    begin
      TempImage := GetImage(Images, GetToken(S));
      if TempImage <> nil then
      begin
        if Image <> nil then
          Image.FreeBmp;
        Image := ExtractImage(TempImage, S);
        Image.Name := TempImage.Name;
        case Align of
          saTop, saBottom, saMostTop, saMostBottom: Height := Image.Height;
          saLeft, saRight, saMostLeft, saMostRight: Width := Image.Width;
          saTopLeft, saTopRight, saBottomLeft, saBottomRight:
          begin
            Width := Image.Width;
            Height := Image.Height;
          end;
        end;
      end;
    end;
    { Extract origin and size }
    S := Data.ReadString(ObjectName, 'Left', '');
    if S <> '' then FLeft := StrToInt(S);
    FAlignLeft := FLeft;
    S := Data.ReadString(ObjectName, 'Top', '');
    if S <> '' then FTop := StrToInt(S);
    FAlignTop := FTop;
    S := Data.ReadString(ObjectName, 'Width', '');
    if S <> '' then FWidth := StrToInt(S);
    S := Data.ReadString(ObjectName, 'Height', '');
    if S <> '' then FHeight := StrToInt(S);
    { Extract events }
    S := Data.ReadString(ObjectName, 'HoverEvent', '');
    ExtractEvent(HoverEvent, S);
    S := Data.ReadString(ObjectName, 'LeaveEvent', '');
    ExtractEvent(LeaveEvent, S);
    S := Data.ReadString(ObjectName, 'ClickEvent', '');
    ExtractEvent(ClickEvent, S);
    S := Data.ReadString(ObjectName, 'RightClickEvent', '');
    ExtractEvent(RightClickEvent, S);
    S := Data.ReadString(ObjectName, 'DoubleClickEvent', '');
    ExtractEvent(DoubleClickEvent, S);
    S := Data.ReadString(ObjectName, 'UnClickEvent', '');
    ExtractEvent(UnClickEvent, S);
    S := Data.ReadString(ObjectName, 'SetFocusEvent', '');
    ExtractEvent(SetFocusEvent, S);
    S := Data.ReadString(ObjectName, 'KillFocusEvent', '');
    ExtractEvent(KillFocusEvent, S);
    { Extract mask }
    S := Data.ReadString(ObjectName, 'MaskColor', '');
    if S <> '' then
    begin
      MaskColor := ExtractColor(S);
      MaskType := smColor;
    end;
    S := Data.ReadString(ObjectName, 'MaskImage', '');
    if S <> '' then
    begin
      TempImage := GetImage(Images, GetToken(S));
      if TempImage <> nil then
      begin
        if MaskImage <> nil then
          MaskImage.FreeBmp;
        MaskImage := ExtractImage(TempImage, S);
        MaskImage.Name := TempImage.Name;
      end;
      MaskType := smImage;
    end;
    { Extract children }
    S := Data.ReadString(ObjectName, 'Child', '');
    while S <> '' do
    begin
      Word := GetToken(S);
      Obj := TscSkinObject.Create;
      LoadObjectFromStrings(Images, Obj, Word, Data);
      AddChild(Obj);
    end;
  end;
end;

procedure SaveObjectToStrings(SkinObject: TscSkinObject; Data: TscCustomIniFile);
var
  S, ObjectName: string;
  i: integer;
begin
  if SkinObject.Name = '' then Exit;
  
  with SkinObject do
  begin
    ObjectName := Name;

    Data.WriteString(ObjectName, 'Align', PackAlign(Align));
    Data.WriteString(ObjectName, 'Transparency', IntToStr(Transparency));
    Data.WriteString(ObjectName, 'TileStyle', PackTileStyle(TileStyle));
    Data.WriteString(ObjectName, 'Kind', PackKind(Kind));
    Data.WriteString(ObjectName, 'Visible', PackVisible(Visible));
    Data.WriteString(ObjectName, 'Color', PackColor(Color));

    if FontName <> 'Arial' then
      Data.WriteString(ObjectName, 'FontName', FontName);
    if FontSize <> 8 then
      Data.WriteString(ObjectName, 'FontSize', IntToStr(FontSize));
    S := PackFontStyle(FontStyle);
    if S <> '' then Data.WriteString(ObjectName, 'FontStyle', PackFontStyle(FontStyle));

    Data.WriteString(ObjectName, 'TextColor', PackColor(TextColor));
    Data.WriteString(ObjectName, 'DisabledTextColor', PackColor(DisabledTextColor));
    Data.WriteString(ObjectName, 'TextAlign', PackTextAlign(TextAlign));
    { Extract image }
    if Image <> nil then
      Data.WriteString(ObjectName, 'Image', PackImage(Image));
    { Extract origin and size }
    if Align = saNone then
    begin
      Data.WriteString(ObjectName, 'Left', IntToStr(Left));
      Data.WriteString(ObjectName, 'Top', IntToStr(Top));
    end
    else
    begin
      if AlignLeft <> 0 then
        Data.WriteString(ObjectName, 'Left', IntToStr(AlignLeft));
      if ALignTop <> 0 then
        Data.WriteString(ObjectName, 'Top', IntToStr(AlignTop));
    end;
    Data.WriteString(ObjectName, 'Width', IntToStr(Width));
    Data.WriteString(ObjectName, 'Height', IntToStr(Height));
    { Extract events }
    Data.WriteString(ObjectName, 'HoverEvent', PackEvent(HoverEvent));
    Data.WriteString(ObjectName, 'LeaveEvent', PackEvent(LeaveEvent));
    Data.WriteString(ObjectName, 'ClickEvent', PackEvent(ClickEvent));
    Data.WriteString(ObjectName, 'RightClickEvent', PackEvent(RightClickEvent));
    Data.WriteString(ObjectName, 'DoubleClickEvent', PackEvent(DoubleClickEvent));
    Data.WriteString(ObjectName, 'UnClickEvent', PackEvent(UnClickEvent));
    Data.WriteString(ObjectName, 'SetFocusEvent', PackEvent(SetFocusEvent));
    Data.WriteString(ObjectName, 'KillFocusEvent', PackEvent(KillFocusEvent));
    { Extract mask }
    case MaskType of
      smColor: Data.WriteString(ObjectName, 'MaskColor', PackColor(MaskColor));
      smImage: if MaskImage <> nil then
        Data.WriteString(ObjectName, 'MaskImage', PackImage(MaskImage));
    end;
    { Extract children }
    S := '';
    for i := 0 to ChildCount-1 do
    begin
      if Child[i].Name = '' then Continue;
      SaveObjectToStrings(Child[i], Data);
      if S = '' then
        S := Child[i].Name
      else
        S := S + ','+Child[i].Name;
    end;
    if S <> '' then
      Data.WriteString(ObjectName, 'Child', S);
  end;
end;

end.

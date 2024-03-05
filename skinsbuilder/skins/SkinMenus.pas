{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }     
{       DynamicSkinForm                                             }
{       Version 5.86                                                }
{                                                                   }
{       Copyright (c) 2000-2004 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit SkinMenus;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ImgList, SkinData, SPUtils, spEffBMp;

type

  TspSkinPopupWindow = class;
  TspSkinMenuItem = class(TObject)
  protected
    Parent: TspSkinPopupWindow;
    MI: TspDataSkinMenuItem;
    ActivePicture: TBitMap;
    FMorphKf: Double;
    procedure SetMorphKf(Value: Double);
    procedure Redraw;
  public
    MenuItem: TMenuItem;
    ObjectRect: TRect;
    Active: Boolean;
    Down: Boolean;
    FVisible: Boolean;
    WaitCommand: Boolean;
    constructor Create(AParent: TspSkinPopupWindow; AMenuItem: TMenuItem;
                       AData: TspDataSkinMenuItem);
    procedure Draw(Cnvs: TCanvas);
    procedure DefaultDraw(Cnvs: TCanvas);
    function CanMorphing: Boolean; virtual;
    procedure DoMorphing;
    property MorphKf: Double read FMorphKf write SetMorphKf;
    procedure MouseDown(X, Y: Integer);
    procedure MouseEnter(Kb: Boolean);
    procedure MouseLeave;
  end;

  TspSkinMenu = class;

  TspSkinPopupWindow = class(TCustomControl)
  private
    DSMI: TspDataSkinMenuItem;
    VisibleCount: Integer;
    VisibleStartIndex: Integer;
    Scroll: Boolean;
    ScrollCode: Integer;
    NewLTPoint, NewRTPoint,
    NewLBPoint, NewRBPoint: TPoint;
    NewItemsRect: TRect;
    FRgn: HRGN;
    ShowX, ShowY: Integer;
    WT: TTimer;
    OMX, OMY: Integer;
    procedure WTProc(Sender: TObject);
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure WMEraseBkGrnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CreateMenu(Item: TMenuItem; StartIndex: Integer);
    procedure CreateMenu2(Item, Item2: TMenuItem; StartIndex: Integer);
    procedure CreateRealImage(B: TBitMap);
    procedure SetMenuWindowRegion;
    procedure DrawUpMarker(Cnvs: TCanvas);
    procedure DrawDownMarker(Cnvs: TCanvas);
    procedure StartScroll;
    procedure StopScroll;
  protected
    ImgL: TCustomImageList;
    GlyphWidth: Integer;
    WindowPicture, MaskPicture: TBitMap;
    OldActiveItem: Integer;
    MouseTimer, MorphTimer: TTimer;
    ParentMenu: TspSkinMenu;
    SD: TspSkinData;
    PW: TspDataSkinPopupWindow;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    function CanScroll(AScrollCode: Integer): Boolean;
    procedure ScrollUp(Cycle: Boolean);
    procedure ScrollDown(Cycle: Boolean);
    function GetEndStartVisibleIndex: Integer;
    procedure CalcItemRects;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure TestMouse(Sender: TObject);
    procedure TestActive(X, Y: Integer);
    function InWindow(P: TPoint): Boolean;
    procedure TestMorph(Sender: TObject);
    procedure UpDatePW;
    function GetActive(X, Y: Integer): Boolean;
  public
    Sc: TBitMap;
    ESc: TspEffectBmp;
    AlphaBlend: Boolean;
    AlphaBlendValue: Byte;
    AlphaBlendAnimation: Boolean;
    ItemList: TList;
    ActiveItem: Integer;
    constructor CreateEx(AOwner: TComponent; AParentMenu: TspSkinMenu;
                       AData: TspDataSkinPopupWindow);
    destructor Destroy; override;
     procedure Hide;
    procedure Show(R: TRect; AItem: TMenuItem; StartIndex: Integer;
                   PopupByItem: Boolean;  PopupUp: Boolean);
    procedure Show2(R: TRect; AItem, AItem2: TMenuItem; StartIndex: Integer;
                   PopupByItem: Boolean;  PopupUp: Boolean);
    procedure PaintMenu(DC: HDC);
    procedure PopupKeyDown(CharCode: Integer);
  end;

  TspSkinMenu = class(TComponent)
  protected
    FUseSkinFont: Boolean;
    FFirst: Boolean;
    FDefaultMenuItemHeight: Integer;
    FDefaultMenuItemFont: TFont;
    PopupCtrl, DCtrl: TControl;
    FForm: TForm;
    WaitTimer: TTimer;
    WItem: TspSkinMenuItem;
    WorkArea: TRect;
    FVisible: Boolean;
    SkinData: TspSkinData;
    procedure SetDefaultMenuItemFont(Value: TFont);
    function GetWorkArea: TRect;
    function GetPWIndex(PW: TspSkinPopupWindow): Integer;
    procedure CheckItem(PW: TspSkinPopupWindow; MI: TspSkinMenuItem; Down: Boolean; Kb: Boolean);
    procedure CloseMenu(EndIndex: Integer);
    procedure PopupSub(R: TRect; AItem: TMenuItem; StartIndex: Integer;
                       PopupByItem, PopupUp: Boolean);
    procedure PopupSub2(R: TRect; AItem, AItem2: TMenuItem; StartIndex: Integer;
                       PopupByItem, PopupUp: Boolean);
    procedure WaitItem(Sender: TObject);
  public
    { Public declarations }
    FPopupList: TList;
    AlphaBlend: Boolean;
    AlphaBlendValue: Byte;
    AlphaBlendAnimation: Boolean;
    property Visible: Boolean read FVisible;
    constructor CreateEx(AOwner: TComponent; AForm: TForm);
    destructor Destroy; override;
    procedure Popup(APopupCtrl: TControl; ASkinData: TspSkinData; StartIndex: Integer;
                    R: TRect; AItem: TMenuItem; PopupUp: Boolean);
    procedure Popup2(APopupCtrl: TControl; ASkinData: TspSkinData; StartIndex: Integer;
                    R: TRect; AItem, AItem2: TMenuItem; PopupUp: Boolean);
    procedure Hide;
    property First: Boolean read FFirst;
    property DefaultMenuItemFont: TFont
      read FDefaultMenuItemFont write SetDefaultMenuItemFont;
    property DefaultMenuItemHeight: Integer
      read FDefaultMenuItemHeight write FDefaultMenuItemHeight;
    property UseSkinFont: Boolean
     read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinPopupMenu = class(TPopupMenu)
  protected
    FSD: TspSkinData;
    FComponentForm: TForm;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(X, Y: Integer); override;
    procedure PopupFromRect(R: TRect; APopupUp: Boolean);
    procedure Popup2(ACtrl: TControl; X, Y: Integer);
    procedure PopupFromRect2(ACtrl: TControl; R: TRect; APopupUp: Boolean);
    property ComponentForm: TForm read FComponentForm write FComponentForm;
  published
    property SkinData: TspSkinData read FSD write FSD;
  end;


  function CanMenuClose(Msg: Cardinal): Boolean;

const
    WM_CLOSESKINMENU = WM_USER + 204;
    WM_AFTERDISPATCH = WM_USER + 205;

implementation
   Uses DynamicSkinForm;

const
    MorphInc = 0.2;
    MouseTimerInterval = 50;
    MorphTimerInterval = 20;
    WaitTimerInterval = 500;
    MarkerItemHeight = 10;
    ScrollTimerInterval = 100;

    MI_MINNAME = 'DSF_MINITEM';
    MI_MAXNAME = 'DSF_MAXITEM';
    MI_CLOSENAME = 'DSF_CLOSE';
    MI_RESTORENAME = 'DSF_RESTORE';
    MI_MINTOTRAYNAME = 'DSF_MINTOTRAY';
    MI_ROLLUPNAME = 'DSF_ROLLUP';

    TMI_RESTORENAME = 'TRAY_DSF_RESTORE';
    TMI_CLOSENAME = 'TRAY_DSF_CLOSE';

    CS_DROPSHADOW_ = $20000;

procedure DrawCheckImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
var
  i: Integer;
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    for i := 0 to 2 do
    begin
      MoveTo(X, Y + 5 - i);
      LineTo(X + 2, Y + 7 - i);
      LineTo(X + 7, Y + 2 - i);
    end;
  end;
end;

procedure DrawSubImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
var
  i: Integer;
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    for i := 0 to 3 do
    begin
      MoveTo(X + i, Y + i);
      LineTo(X + i, Y + 7 - i);
    end;
  end;
end;

procedure DrawRadioImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    Brush.Color := Color;
    Ellipse(X, Y, X + 6, Y + 6);
  end;
end;

function RectWidth(R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

function CanMenuClose;
begin
  Result := False;
  case Msg of
    WM_MOUSEACTIVATE, WM_ACTIVATE,
    WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN,
    WM_NCLBUTTONDOWN, WM_NCMBUTTONDOWN, WM_NCRBUTTONDOWN,
    WM_KILLFOCUS, WM_MOVE, WM_SIZE, WM_CANCELMODE, WM_PARENTNOTIFY:
      Result := True;
  end;
end;

//===============TspSkinMenuItem===================//
constructor TspSkinMenuItem.Create;
begin
  WaitCommand := False;
  Parent := AParent;
  MenuItem := AMenuItem;
  FVisible := True;
  MI := AData;
  if MI <> nil then 
  with AData do
  begin
    if (ActivePictureIndex <> - 1) and
       (ActivePictureIndex < Self.Parent.SD.FActivePictures.Count)
    then
      ActivePicture := Self.Parent.SD.FActivePictures.Items[ActivePictureIndex]
    else
      begin
        ActivePicture := nil;
        SkinRect := NullRect;
        ActiveSkinRect := NullRect;
      end;
  end;
  FMorphKf := 0;
end;

function TspSkinMenuItem.CanMorphing;
var
  AD: Boolean;
begin
  AD := Active or Down;
  Result := FVisible and ((AD and (MorphKf < 1)) or
                         (not AD and (MorphKf > 0)));
  if not FVisible and (FMorphKf <> 0)
  then
    begin
      Active := False;
      Down := False;
      FMorphKf := 0;
    end;
end;

procedure TspSkinMenuItem.DoMorphing;
begin
  if Active or Down
  then MorphKf := MorphKf + MorphInc
  else MorphKf := MorphKf - MorphInc;
  Draw(Parent.Canvas);
end;

procedure TspSkinMenuItem.SetMorphKf(Value: Double);
begin
  FMorphKf := Value;
  if FMorphKf < 0 then FMorphKf := 0 else
  if FMorphKf > 1 then FMorphKf := 1;
end;

procedure TspSkinMenuItem.ReDraw;
begin
  if (MI <> nil) and MI.Morphing
  then Parent.MorphTimer.Enabled := True
  else Draw(Parent.Canvas);
end;

procedure TspSkinMenuItem.MouseDown(X, Y: Integer);
begin
  WaitCommand := False;
  if not Down and MenuItem.Enabled
  then
    Parent.ParentMenu.CheckItem(Parent, Self, True, False);
end;

procedure TspSkinMenuItem.MouseEnter;
var
  i: Integer;
begin
  Active := True;

  for i := 0 to Parent.ItemList.Count - 1 do
    if (TspSkinMenuItem(Parent.ItemList.Items[i]) <> Self)
       and TspSkinMenuItem(Parent.ItemList.Items[i]).Down
    then
      with TspSkinMenuItem(Parent.ItemList.Items[i]) do
      begin
        Down := False;
        ReDraw;
      end;

  if WaitCommand and not Kb
  then
    begin
      ReDraw;
    end
  else
  if not Down
  then
    begin
      ReDraw;
      Parent.ParentMenu.CheckItem(Parent, Self, False, Kb);
    end
  else
    with Parent.ParentMenu do
    begin
      i := GetPWIndex(Parent);
      if i + 2 < FPopupList.Count
      then
        TspSkinPopupWindow(FPopupList.Items[i + 1]).UpDatePW;
    end;
    
end;

procedure TspSkinMenuItem.MouseLeave;
begin
  WaitCommand := False;
  Active := False;
  if not Down then ReDraw;
  with Parent.ParentMenu do
  begin
    if (WItem <> nil) and (WItem = Self)
    then
      begin
        WaitTimer.Enabled := False;
        WItem := nil;
      end;
  end;
end;

procedure TspSkinMenuItem.DefaultDraw(Cnvs: TCanvas);
var
  MIShortCut: String;
  B: TBitMap;
  TextOffset: Integer;
  R, TR, SR: TRect;
  DrawGlyph: Boolean;
  GX, GY, IX, IY: Integer;
  EB1: TspEffectBmp;
  kf: Double;
begin
  if MenuItem.ShortCut <> 0
  then
    MIShortCut := ShortCutToText(MenuItem.ShortCut)
  else
    MIShortCut := '';

  B := TBitMap.Create;
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);

  if Parent.ImgL = nil
  then TextOffset := 19
  else TextOffset := Parent.GlyphWidth;
  
  with B.Canvas do
  begin
    R := Rect(0, 0, B.Width, B.Height);
    Font.Assign(Parent.ParentMenu.FDefaultMenuItemFont);
    if (Parent.ParentMenu.SkinData <> nil) and
       (Parent.ParentMenu.SkinData.ResourceStrData <> nil)
    then
      Font.CharSet := Self.Parent.ParentMenu.SkinData.ResourceStrData.Charset;
    if (Active or Down) and (MenuItem.Caption <> '-')
    then
      begin
        Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNACTIVECOLOR;
        Font.Color := clWindowText;
        FillRect(R);
      end
    else
      begin
        R := Rect(0, 0, TextOffset, B.Height);
        Brush.Color := clBtnFace;
        FillRect(R);
        R := Rect(TextOffset, 0, B.Width, B.Height);
        Brush.Color := clWindow;
        if MenuItem.Enabled
        then
          Font.Color := clWindowText
        else
          Font.Color := clBtnShadow;
        FillRect(R);
      end;
  end;

  if MenuItem.Caption = '-'
  then
    begin
      R.Left := TextOffset;
      R.Top := B.Height div 2;
      R.Right := B.Width;
      R.Bottom := B.Height div 2 + 1;
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
      if Parent.AlphaBlend and not CheckW2KWXP
      then
        begin
          EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
          kf := 1 - Parent.AlphaBlendValue / 255;
          EB1.MorphRect(Parent.ESc, kf, Rect(0, 0, B.Width, B.Height),
            ObjectRect.Left, ObjectRect.Top);
          EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
          EB1.Free;
        end
      else
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, B);
      B.Free;
      Exit;
    end;


  TR := Rect(2, 2, B.Width - 2, B.Height - 2);
  // text
  R := Rect(TR.Left + TextOffset, 0, TR.Right - 19, 0);
  DrawText(B.Canvas.Handle, PChar(MenuItem.Caption), Length(MenuItem.Caption), R,
             DT_CALCRECT);
  OffsetRect(R, 0, TR.Top + RectHeight(TR) div 2 - R.Bottom div 2);
  Inc(R.Right, 2);
  DrawText(B.Canvas.Handle,
           PChar(MenuItem.Caption), Length(MenuItem.Caption), R, DT_CENTER or DT_VCENTER);
  // short cut
  if MIShortCut <> ''
  then
    begin
      SR := Rect(0, 0, 0, 0);
      DrawText(B.Canvas.Handle, PChar(MIShortCut), Length(MIShortCut), SR,
               DT_CALCRECT);
      SR := Rect(TR.Right - SR.Right - 19, R.Top, TR.Right - 19, R.Bottom);
      DrawText(B.Canvas.Handle,
        PChar(MIShortCut), Length(MIShortCut), SR, DT_CENTER or DT_VCENTER);
    end;
  //
  if MenuItem.Count <> 0
  then
    DrawSubImage(B.Canvas,
                 TR.Right - 7, TR.Top + RectHeight(TR) div 2 - 4,
                 B.Canvas.Font.Color);
  //
  DrawGlyph := (Parent.ImgL <> nil) and (MenuItem.ImageIndex > -1) and
       (MenuItem.ImageIndex < Parent.ImgL.Count);
  if DrawGlyph
  then
    begin
      GX := TR.Left;
      GY := TR.Top + RectHeight(TR) div 2 - Parent.ImgL.Height div 2;
      if MenuItem.Checked
      then
        with B.Canvas do
        begin
          Brush.Style := bsClear;
          Pen.Color := Font.Color;
          Rectangle(GX - 1, GY - 1,
                    GX + Parent.ImgL.Width + 1,
                    GY + Parent.ImgL.Height + 1);
        end;
    end
  else
    begin
      GX := 0; GY := 0;
      IY := TR.Top + RectHeight(TR) div 2 - 4;
      IX := TR.Left + 2;
      if (MenuItem.Name = MI_CLOSENAME) or (MenuItem.Name = TMI_CLOSENAME)
      then DrawCloseImage(B.Canvas, IX, IY, B.Canvas.Font.Color) else
      if MenuItem.Name = MI_MINNAME
      then DrawMinimizeImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
      else
      if MenuItem.Name = MI_MAXNAME
      then DrawMaximizeImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
      else
      if (MenuItem.Name = MI_RESTORENAME) or (MenuItem.Name = TMI_RESTORENAME)
      then DrawRestoreImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
      else
      if MenuItem.Name = MI_ROLLUPNAME
      then DrawRollUpImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
      else
      if MenuItem.Name = MI_MINTOTRAYNAME
      then DrawMTImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
      else
      if MenuItem.Checked
      then
      if MenuItem.RadioItem
      then
        DrawRadioImage(B.Canvas,
                       TR.Left + 3, TR.Top + RectHeight(TR) div 2 - 3,
                       B.Canvas.Font.Color)
      else
        DrawCheckImage(B.Canvas,
                       TR.Left + 3, TR.Top + RectHeight(TR) div 2 - 4,
                       B.Canvas.Font.Color);
    end;
  //
  if DrawGlyph
  then
    Parent.ImgL.Draw(B.Canvas, GX, GY, MenuItem.ImageIndex, MenuItem.Enabled);

  if Parent.AlphaBlend and not CheckW2KWXP
  then
    begin
      EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
      kf := 1 - Parent.AlphaBlendValue / 255;
      EB1.MorphRect(Parent.ESc, kf, Rect(0, 0, B.Width, B.Height),
       ObjectRect.Left, ObjectRect.Top);
      EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
      EB1.Free;
    end
  else
    Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, B);
  B.Free;
end;


procedure TspSkinMenuItem.Draw;
var
  GX, GY: Integer;
  DrawGlyph: Boolean;
  EB1: TspEffectBmp;
  kf: Double;

procedure CreateItemImage(B: TBitMap; AActive: Boolean);
var
  R, TR, SR, Rct: TRect;
  TextOffset: Integer;
  MIShortCut: String;
  IX, IY: Integer;
begin

  if MenuItem.ShortCut <> 0
  then
    MIShortCut := ShortCutToText(MenuItem.ShortCut)
  else
    MIShortCut := '';

  if AActive
  then Rct := MI.ActiveSkinRect
  else Rct := MI.SkinRect;

  CreateHSkinImage(MI.ItemLO, MI.ItemRO,
   B, ActivePicture, Rct,
   RectWidth(ObjectRect), RectHeight(ObjectRect));

  if Parent.ImgL = nil
  then TextOffset := 16
  else TextOffset := Parent.GlyphWidth;

  TR := MI.TextRct;
  TR.Right := B.Width - (RectWidth(MI.SkinRect) - MI.TextRct.Right);

  with B.Canvas do
  begin
    Brush.Style := bsClear;
    if Self.Parent.ParentMenu.UseSkinFont
    then
      begin
        Font.Name := MI.FontName;
        Font.Style := MI.FontStyle;
        Font.Height := MI.FontHeight;
        Font.CharSet := Self.Parent.ParentMenu.FDefaultMenuItemFont.Charset;
      end
    else
      Font.Assign(Self.Parent.ParentMenu.DefaultMenuItemFont);

    if (Self.Parent.ParentMenu.SkinData <> nil) and
       (Self.Parent.ParentMenu.SkinData.ResourceStrData <> nil)
    then
      Font.CharSet := Self.Parent.ParentMenu.SkinData.ResourceStrData.Charset
    else
      Font.CharSet := Self.Parent.ParentMenu.FDefaultMenuItemFont.Charset;

    if AActive
    then
      Font.Color := MI.ActiveFontColor
    else
      if MenuItem.Enabled
      then
        Font.Color := MI.FontColor
      else
        Font.Color := MI.UnEnabledFontColor;
    //
    R := Rect(TR.Left + TextOffset, 0, TR.Right - 16, 0);
    DrawText(B.Canvas.Handle, PChar(MenuItem.Caption), Length(MenuItem.Caption), R,
             DT_CALCRECT);
    OffsetRect(R, 0, TR.Top + RectHeight(TR) div 2 - R.Bottom div 2);
    Inc(R.Right, 2);
    DrawText(B.Canvas.Handle,
             PChar(MenuItem.Caption), Length(MenuItem.Caption), R, DT_CENTER or DT_VCENTER);
    // shortcut
    if MIShortCut <> ''
    then
      begin
        SR := Rect(0, 0, 0, 0);
        DrawText(B.Canvas.Handle, PChar(MIShortCut), Length(MIShortCut), SR,
                 DT_CALCRECT);
        SR := Rect(TR.Right - SR.Right - 16, R.Top, TR.Right - 16, R.Bottom);
        DrawText(B.Canvas.Handle,
           PChar(MIShortCut), Length(MIShortCut), SR, DT_CENTER or DT_VCENTER);
      end;
    //
    if MenuItem.Count <> 0
    then
      DrawSubImage(B.Canvas,
                   TR.Right - 7, TR.Top + RectHeight(TR) div 2 - 4,
                   B.Canvas.Font.Color);
    //
    DrawGlyph := (Parent.ImgL <> nil) and (MenuItem.ImageIndex > -1) and
       (MenuItem.ImageIndex < Parent.ImgL.Count);
    if DrawGlyph
    then
      begin
        GX := TR.Left + 2;
        GY := TR.Top + RectHeight(TR) div 2 - Parent.ImgL.Height div 2;
        if MenuItem.Checked
        then
          begin
            Brush.Style := bsClear;
            Pen.Color := Font.Color;
            Rectangle(GX - 1, GY - 1,
                      GX + Parent.ImgL.Width + 1,
                      GY + Parent.ImgL.Height + 1);
          end;
      end
    else
      begin
        IY := TR.Top + RectHeight(TR) div 2 - 4;
        IX := TR.Left + 2;
        if (MenuItem.Name = MI_CLOSENAME) or (MenuItem.Name = TMI_CLOSENAME) 
        then DrawCloseImage(B.Canvas, IX, IY, B.Canvas.Font.Color) else
        if MenuItem.Name = MI_MINNAME
        then DrawMinimizeImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
        else
        if MenuItem.Name = MI_MAXNAME
        then DrawMaximizeImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
        else
        if (MenuItem.Name = MI_RESTORENAME) or (MenuItem.Name = TMI_RESTORENAME)
        then DrawRestoreImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
        else
        if MenuItem.Name = MI_ROLLUPNAME
        then DrawRollUpImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
        else
        if MenuItem.Name = MI_MINTOTRAYNAME
        then DrawMTImage(B.Canvas, IX, IY, B.Canvas.Font.Color)
        else
        if MenuItem.Checked
        then
          if MenuItem.RadioItem
          then
            DrawRadioImage(B.Canvas,
                           TR.Left + 2, TR.Top + RectHeight(TR) div 2 - 3,
                           B.Canvas.Font.Color)
          else
            DrawCheckImage(B.Canvas,
                           TR.Left + 2, TR.Top + RectHeight(TR) div 2 - 4,
                           B.Canvas.Font.Color);
      end;
  end;
  //
  if DrawGlyph
  then
    Parent.ImgL.Draw(B.Canvas, GX, GY, MenuItem.ImageIndex, MenuItem.Enabled);
end;

var
  B, AB: TBitMap;
  EffB, EffAB: TspEffectBmp;
  AD: Boolean;
begin
  if not FVisible then Exit;
  if MI = nil
  then
    begin
      DefaultDraw(Cnvs);
      Exit;
    end;
  B := TBitMap.Create;
  if MenuItem.Caption = '-'
  then
    begin
      CreateHSkinImage(MI.DividerLO, MI.DividerRO,
        B, ActivePicture, MI.DividerRect,
        RectWidth(ObjectRect), RectHeight(ObjectRect));
      if Parent.AlphaBlend and not CheckW2KWXP
      then
        begin
          EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
          kf := 1 - Parent.AlphaBlendValue / 255;
          EB1.MorphRect(Parent.ESc, kf, Rect(0, 0, B.Width, B.Height),
            ObjectRect.Left, ObjectRect.Top);
          EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
          EB1.Free;
        end
      else
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, B);
     end
  else
    begin
      AD := Active or Down;
      if not MI.Morphing or
      ((AD and (MorphKf = 1)) or (not AD and (MorphKf  = 0)))
      then
        begin
          CreateItemImage(B, AD);
          if Parent.AlphaBlend and not CheckW2KWXP
          then
            begin
              EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
              kf := 1 - Parent.AlphaBlendValue / 255;
              EB1.MorphRect(Parent.ESc, kf, Rect(0, 0, B.Width, B.Height),
                ObjectRect.Left, ObjectRect.Top);
              EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
              EB1.Free;
            end
          else
            Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, B);
        end
      else
        begin
          CreateItemImage(B, False);
          AB := TBitMap.Create;
          CreateItemImage(AB, True);
          EffB := TspEffectBmp.CreateFromhWnd(B.Handle);
          EffAB := TspEffectBmp.CreateFromhWnd(AB.Handle);
          case MI.MorphKind of
            mkDefault: EffB.Morph(EffAB, MorphKf);
            mkGradient: EffB.MorphGrad(EffAB, MorphKf);
            mkLeftGradient: EffB.MorphLeftGrad(EffAB, MorphKf);
            mkRightGradient: EffB.MorphRightGrad(EffAB, MorphKf);
            mkLeftSlide: EffB.MorphLeftSlide(EffAB, MorphKf);
            mkRightSlide: EffB.MorphRightSlide(EffAB, MorphKf);
            mkPush: EffB.MorphPush(EffAB, MorphKf);
          end;
          if Parent.AlphaBlend and not CheckW2KWXP
          then
            begin
              kf := 1 - Parent.AlphaBlendValue / 255;
              EffB.MorphRect(Parent.ESc, kf, Rect(0, 0, B.Width, B.Height),
                ObjectRect.Left, ObjectRect.Top);
            end;
          EffB.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
          AB.Free;
          EffB.Free;
          EffAB.Free;
        end;
    end;
  B.Free;
end;

//================TspSkinPopupWindow======================//
constructor TspSkinPopupWindow.CreateEx;
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable,
                  csAcceptsControls];

  ParentMenu := AParentMenu;

  AlphaBlend := ParentMenu.AlphaBlend;
  AlphaBlendValue := ParentMenu.AlphaBlendValue;
  AlphaBlendAnimation := ParentMenu.AlphaBlendAnimation;

  Ctl3D := False;
  ParentCtl3D := False;
  Visible := False;
  ItemList := TList.Create;

  MouseTimer := TTimer.Create(Self);
  MouseTimer.Enabled := False;
  MouseTimer.OnTimer := TestMouse;
  MouseTimer.Interval := MouseTimerInterval;

  MorphTimer := TTimer.Create(Self);
  MorphTimer.Enabled := False;
  MorphTimer.OnTimer := TestMorph;
  MorphTimer.Interval := MorphTimerInterval;

  FRgn := 0;

  WindowPicture := nil;
  MaskPicture := nil;

  if (AData = nil) or (AData.WindowPictureIndex = -1)
  then
    begin
      PW := nil;
      SD := nil;
    end
  else
    begin
      PW := AData;
      SD := ParentMenu.SkinData;
      with PW do
      begin
        if (WindowPictureIndex <> - 1) and
           (WindowPictureIndex < SD.FActivePictures.Count)
        then
          WindowPicture := SD.FActivePictures.Items[WindowPictureIndex];

        if (MaskPictureIndex <> - 1) and
           (MaskPictureIndex < SD.FActivePictures.Count)
        then
          MaskPicture := SD.FActivePictures.Items[MaskPictureIndex];
      end;
    end;

  ActiveItem := -1;
  OldActiveItem := -1;

  OMX := -1;
  OMY := -1;

  Sc := TBitMap.Create;
  Esc := nil;

  WT := TTimer.Create(Self);
  WT.Enabled := False;
  WT.OnTimer := WTProc;
  WT.Interval := 100;

  DSMI := nil;
  ScrollCode := 0;
end;

destructor TspSkinPopupWindow.Destroy;
var
  i: Integer;
begin
  for i := 0 to ItemList.Count - 1 do
    TspSkinMenuItem(ItemList.Items[i]).Free;
  ItemList.Clear;
  ItemList.Free;
  MouseTimer.Free;
  MorphTimer.Free;
  Sc.Free;
  if Esc <> nil then Esc.Free;
  inherited Destroy;
  if FRgn <> 0 then DeleteObject(FRgn);
end;

function TspSkinPopupWindow.CanScroll;
begin
  Result := False;
  case AScrollCode of
    1: Result := VisibleStartIndex > 0;
    2: Result := VisibleStartIndex + VisibleCount - 1 < ItemList.Count - 1;
  end;
end;

procedure TspSkinPopupWindow.WMTimer;
begin
  inherited;
  case ScrollCode of
    1: if CanScroll(1) then ScrollUp(False) else StopScroll;
    2: if CanScroll(2) then ScrollDown(False) else StopScroll;
  end;
end;

procedure TspSkinPopupWindow.DrawUpMarker;
var
  R: TRect;
  C: TColor;
begin
  if PW <> nil
  then
    begin
      R := Rect(NewItemsRect.Left, NewItemsRect.Top,
                NewItemsRect.Right, NewItemsRect.Top + MarkerItemHeight);
      if ScrollCode = 1
      then C := PW.ScrollMarkerActiveColor
      else C := PW.ScrollMarkerColor;
    end
  else
    begin
      R := Rect(3, 3, Width - 3, 3 + MarkerItemHeight);
      if ScrollCode = 1
      then C := clBtnText
      else C := clBtnShadow;
    end;  
  DrawArrowImage(Cnvs, R, C, 3);
end;

procedure TspSkinPopupWindow.DrawDownMarker;
var
  R: TRect;
  C: TColor;
begin
  if PW <> nil
  then
    begin
      R := Rect(NewItemsRect.Left, NewItemsRect.Bottom - MarkerItemHeight,
            NewItemsRect.Right, NewItemsRect.Bottom);
      if ScrollCode = 2
      then C := PW.ScrollMarkerActiveColor
      else C := PW.ScrollMarkerColor;
    end
  else
    begin
      R := Rect(3, Height - MarkerItemHeight, Width - 3, Height - 3);
      if ScrollCode = 2
      then C := clBtnText
      else C := clBtnShadow;
    end;
  DrawArrowImage(Cnvs, R, C, 4);
end;

procedure TspSkinPopupWindow.StartScroll;
var
  i: Integer;
begin
  i := ParentMenu.GetPWIndex(Self);
  WT.Enabled := False;
  ParentMenu.CloseMenu(i + 1);
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, ScrollTimerInterval, nil);
end;

procedure TspSkinPopupWindow.StopScroll;
begin
  ScrollCode := 0;
  DrawUpMarker(Canvas);
  DrawDownMarker(Canvas);
  KillTimer(Handle, 1);
end;

procedure TspSkinPopupWindow.ScrollUp;
begin
  if VisibleStartIndex > 0
  then
    begin
      VisibleStartIndex := VisibleStartIndex - 1;
      CalcItemRects;
      RePaint;
    end
  else
    if Cycle
    then
      begin
        VisibleStartIndex := GetEndStartVisibleIndex;
        CalcItemRects;
        RePaint;
      end;
end;

procedure TspSkinPopupWindow.ScrollDown(Cycle: Boolean);
begin
  if VisibleStartIndex + VisibleCount - 1 < ItemList.Count - 1
  then
    begin
      VisibleStartIndex := VisibleStartIndex + 1;
      CalcItemRects;
      RePaint;
    end
  else
    if Cycle
    then
      begin
        VisibleStartIndex := 0;
        CalcItemRects;
        RePaint;
      end;
end;

procedure TspSkinPopupWindow.PopupKeyDown(CharCode: Integer);
var
  PW: TspSkinPopupWindow;

 procedure NextItem;
 var
   i, j: Integer;
 begin
   if Scroll and (ScrollCode = 0) and (ActiveItem = VisibleStartIndex + VisibleCount - 1)
   then ScrollDown(True);
   OldActiveItem := ActiveItem;
   if ActiveItem < 0 then j := 0 else j := ActiveItem + 1;
   if j = ItemList.Count then j := 0;
   for i := j to ItemList.Count - 1 do
     with TspSkinMenuItem(ItemList.Items[i]) do
     begin
       if MenuItem.Enabled and (MenuItem.Caption <> '-')
       then
         begin
           ActiveItem := i;
           Break;
         end
       else
         begin
           if Scroll and (ScrollCode = 0) and (i = VisibleStartIndex + VisibleCount - 1)
           then ScrollDown(True);
         end;
     end;

   if OldActiveItem <> ActiveItem
   then
     begin
       if ActiveItem > -1 then
       with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
       begin
         MouseEnter(True);
       end;
       if OldActiveItem > -1 then
       with TspSkinMenuItem(ItemList.Items[OldActiveItem]) do
        begin
          MouseLeave;
        end;
     end;
 end;

 procedure PriorItem;
 var
   i, j: Integer;
 begin
   if Scroll and (ScrollCode = 0) and (ActiveItem = VisibleStartIndex)
   then ScrollUp(True);
   OldActiveItem := ActiveItem;
   if ActiveItem < 0 then j := ItemList.Count - 1 else j := ActiveItem - 1;
   if (j = -1) then j := ItemList.Count - 1;
   for i := j downto 0 do
     with TspSkinMenuItem(ItemList.Items[i]) do
     begin
       if MenuItem.Enabled and (MenuItem.Caption <> '-')
       then
         begin
           ActiveItem := i;
           Break;
         end
       else
         begin
           if Scroll and (ScrollCode = 0) and  (i = VisibleStartIndex)
           then ScrollUp(True);
         end;
     end;

   if OldActiveItem <> ActiveItem
   then
     begin
       if ActiveItem > -1 then
       with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
       begin
         MouseEnter(True);
       end;
       if OldActiveItem > -1 then
       with TspSkinMenuItem(ItemList.Items[OldActiveItem]) do
        begin
          MouseLeave;
        end;
     end;
 end;

function FindHotKeyItem: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemList.Count - 1 do
      with TspSkinMenuItem(ItemList.Items[i]) do
      begin
        if Enabled and IsAccel(CharCode, MenuItem.Caption)
        then
          begin
            MouseEnter(False);
            OldActiveItem := ActiveItem;
            ActiveItem := i;
            if OldActiveItem <> -1
            then
              TspSkinMenuItem(ItemList.Items[OldActiveItem]).MouseLeave;
            MouseDown(0, 0);
            Result := True;
            Break;
          end;
      end
end;

begin
  if not Visible then Exit;
  if not FindHotKeyItem
  then 
  case CharCode of
    VK_DOWN:
      NextItem;
    VK_UP:
      PriorItem;
    VK_RIGHT:
      begin
        if ActiveItem <> -1
        then
          with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
          begin
            if MenuItem.Count <> 0 then MouseDown(0, 0);
          end;
      end;
    VK_RETURN:
      begin
        if ActiveItem <> -1
        then
          with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
          begin
            MouseDown(0, 0);
          end;
      end;
    VK_LEFT:
      begin
        if ParentMenu.FPopupList.Count > 1
        then
          begin
            ParentMenu.CloseMenu(ParentMenu.FPopupList.Count - 1);
            PW := TspSkinPopupWindow(ParentMenu.FPopupList.Items[ParentMenu.FPopupList.Count - 1]);
            if PW.ActiveItem <> -1
            then
              TspSkinMenuItem(PW.ItemList.Items[PW.ActiveItem]).Down := False;
          end
      end;
    VK_ESCAPE:
      begin
        ParentMenu.CloseMenu(ParentMenu.FPopupList.Count - 1);
        if ParentMenu.FPopupList.Count > 0
        then
          begin
            PW := TspSkinPopupWindow(ParentMenu.FPopupList.Items[ParentMenu.FPopupList.Count - 1]);
            if PW.ActiveItem <> -1
            then
              TspSkinMenuItem(PW.ItemList.Items[PW.ActiveItem]).Down := False;
          end;   
      end;
  end;
end;

procedure TspSkinPopupWindow.WTProc;
begin
  Sc.Width := Width + 1;
  Sc.Height := Height + 1;

  GetScreenImage(ShowX, ShowY, Sc);
  ESc := TspEffectBMP.CreateFromhWnd(Sc.Handle);

  //
  if (PW <> nil) and (PW.CursorIndex <> -1)
  then
    Cursor := SD.StartCursorIndex + PW.CursorIndex;
  //

  SetWindowPos(Handle, HWND_TOPMOST, ShowX, ShowY, 0, 0,
      SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  Visible := True;

  MouseTimer.Enabled := True;
  if ItemList.Count > 0
  then
    begin
      ActiveItem := 0;
      TspSkinMenuItem(ItemList.Items[0]).MouseEnter(True);
    end;

  WT.Enabled := False;
end;

procedure TspSkinPopupWindow.UpDatePW;
var
  i: Integer;
  j: Integer;
begin
  j := ParentMenu.GetPWIndex(Self);
  if j + 1 < ParentMenu.FPopupList.Count
  then ParentMenu.CloseMenu(j + 1);
  for i := 0 to ItemList.Count - 1 do
    if TspSkinMenuItem(ItemList.Items[i]).Down
    then
      with TspSkinMenuItem(ItemList.Items[i]) do
      begin
        Down := False;
        ReDraw;
      end;
end;

procedure TspSkinPopupWindow.TestMorph;
var
  i: Integer;
  StopMorph: Boolean;
begin
  if PW = nil then Exit;
  StopMorph := True;
  for i := 0 to ItemList.Count  - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
    begin
      if MI.Morphing and CanMorphing
      then
        begin
          DoMorphing;
          StopMorph := False;
        end;
    end;
  if StopMorph then MorphTimer.Enabled := False;
end;

procedure TspSkinPopupWindow.SetMenuWindowRegion;
var
  TempRgn: HRgn;
begin
  if PW = nil then Exit;
  TempRgn := FRgn;
  CreateSkinRegion
    (FRgn, PW.LTPoint, PW.RTPoint, PW.LBPoint, PW.RBPoint, PW.ItemsRect,
     NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewItemsRect,
     MaskPicture, Width, Height);
  SetWindowRgn(Handle, FRgn, True);
  if TempRgn <> 0 then DeleteObject(TempRgn);
end;

procedure TspSkinPopupWindow.CreateRealImage;
var
  EB1: TspEffectBmp;
  Kf: Double;
  R: TRect;
  TextOffset: Integer;
begin
  if PW <> nil
  then
    CreateSkinImageBS(PW.LTPoint, PW.RTPoint, PW.LBPoint, PW.RBPoint,
      PW.ItemsRect, NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint,
      NewItemsRect, B, WindowPicture,
      Rect(0, 0, WindowPicture.Width, WindowPicture.Height),
      Width, Height, Scroll,
      PW.LeftStretch, PW.TopStretch,
      PW.RightStretch, PW.BottomStretch)
  else
    begin
      B.Width := Width;
      B.Height := Height;
      with B.Canvas do
      begin
        if ImgL = nil
        then TextOffset := 22
        else TextOffset := GlyphWidth + 3;
        R := Rect(0, 0, TextOffset, Height);
        Brush.Color := clBtnFace;
        FillRect(R);
        R := Rect(TextOffset, 0, Width, Height);
        Brush.Color := clWindow;
        FillRect(R);
      end;
      R := Rect(0, 0, Width, Height);
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
      Frame3D(B.Canvas, R, clWindow, clWindow, 1);
    end;

  if AlphaBlend and not CheckW2KWXP
  then
    begin
      EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
      kf := 1 - AlphaBlendValue / 255;
      EB1.MorphRect(ESc, kf, Rect(0, 0, B.Width, B.Height), 0, 0);
      EB1.Draw(B.Canvas.Handle, 0, 0);
      EB1.Free;
    end;
end;

procedure TspSkinPopupWindow.CreateMenu;
var
  sw, sh: Integer;
  i, j: Integer;
  Menu: TMenu;

  function CalcItemTextWidth(Item: TMenuItem): Integer;
  var
    R: TRect;
    MICaption: String;
  begin
   if Item.ShortCut <> 0
   then
     MICaption := Item.Caption + '  ' + ShortCutToText(Item.ShortCut)
   else
     MICaption := Item.Caption;
    R := Rect(0, 0, 0, 0);
    DrawText(Canvas.Handle, PChar(MICaption), Length(MICaption), R,
             DT_CALCRECT);
    Result := R.Right + 2;
  end;

  function GetMenuWindowHeight: Integer;
  var
    i, j, ih: integer;
  begin
    j := 0;
    for i := VisibleStartIndex to VisibleCount - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
      if PW <> nil
      then
        begin
          if MenuItem.Caption = '-'
          then ih := RectHeight(DSMI.DividerRect)
          else ih := RectHeight(DSMI.SkinRect);
        end
      else
        begin
          if MenuItem.Caption = '-'
          then ih := 4
          else ih := ParentMenu.DefaultMenuItemHeight;
        end;
      inc(j, ih);
    end;
    if PW <> nil
    then
      Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
    else
      Result := j + 6;
  end;

  function GetMenuWindowWidth: Integer;
  var
    i, iw: Integer;
  begin
    iw := 0;
    for i := 0 to ItemList.Count - 1 do
    begin
      j := CalcItemTextWidth(TspSkinMenuItem(ItemList.Items[i]).MenuItem);
      if j > iw then iw := j;
    end;
    inc(iw, 16);
    if ImgL <> nil
    then
      GlyphWidth := ImgL.Width + 5
    else
      GlyphWidth := 16;
    Inc(iw, GlyphWidth);
    if (PW <> nil)
    then
      begin
        Inc(iw, DSMI.TextRct.Left);
        Inc(iw, RectWidth(DSMI.SkinRect) - DSMI.TextRct.Right);
        Result := iw + PW.ItemsRect.Left + (WindowPicture.Width - PW.ItemsRect.Right);
      end
    else
      Result := iw + 10;
  end;


procedure CalcSizes;
var
  W, H: Integer;
begin
  //
  VisibleStartIndex := 0;
  VisibleCount := ItemList.Count;
  W := GetMenuWindowWidth;
  H := GetMenuWindowHeight;
  Scroll := False;
  //
  if H > RectHeight(ParentMenu.WorkArea)
  then
    begin
      H := RectHeight(ParentMenu.WorkArea);
      Scroll := True;
    end;  
  //
  Width := W;
  Height := H;
end;

begin
  if SD <> nil
  then
    begin
      i := SD.GetIndex('MENUITEM');
      if i = -1 then i := SD.GetIndex('menuitem');
    end
  else
    i := -1;

  if (PW <> nil) and (i <> - 1) and ParentMenu.UseSkinFont
  then
    begin
      // init menu
      DSMI := TspDataSkinMenuItem(SD.ObjectList.Items[i]);
      with Canvas.Font do
      begin
        Height := DSMI.FontHeight;
        Style := DSMI.FontStyle;
        Name := DSMI.FontName;
        CharSet := ParentMenu.FDefaultMenuItemFont.Charset;
      end;
    end
  else
    begin
      if (i <> -1)
      then
        DSMI := TspDataSkinMenuItem(SD.ObjectList.Items[i])
      else
        DSMI := nil;
      Canvas.Font.Assign(Self.ParentMenu.FDefaultMenuItemFont);
    end;

  Menu := Item.GetParentMenu;
  ImgL := Menu.Images;
  j := Item.Count;
  for i := StartIndex to  j - 1 do
   if TMenuItem(Item.Items[i]).Visible
   then
     begin
       if TMenuItem(Item.Items[i]).Action <> nil
       then
         TMenuItem(Item.Items[i]).Action.Update;
       ItemList.Add(TspSkinMenuItem.Create(Self, TMenuItem(Item.Items[i]), DSMI));
     end;
  //

  CalcSizes;

  if PW <> nil
  then
    begin
      sw := WindowPicture.Width;
      sh := WindowPicture.Height;
      NewLTPoint := PW.LTPoint;
      NewRTPoint := Point(Width - (sw - PW.RTPoint.X), PW.RTPoint.Y);
      NewLBPoint := Point(PW.LBPoint.X, Height - (sh - PW.LBPoint.Y));
      NewRBPoint := Point(Width - (sw - PW.RBPoint.X),
                          Height - (sh - PW.RBPoint.Y));

      NewItemsRect := Rect(PW.ItemsRect.Left, PW.ItemsRect.Top,
                           Width - (sw - PW.ItemsRect.Right),
                           Height - (sh - PW.ItemsRect.Bottom));

    end
  else
    NewItemsRect := Rect(3, 3, Width - 3, Height - 3);
  CalcItemRects;
  if MaskPicture <> nil then SetMenuWindowRegion;
end;

procedure TspSkinPopupWindow.CreateMenu2;
var
  sw, sh: Integer;
  i, j: Integer;
  Menu: TMenu;

  function CalcItemTextWidth(Item: TMenuItem): Integer;
  var
    R: TRect;
    MICaption: String;
  begin
   if Item.ShortCut <> 0
   then
     MICaption := Item.Caption + '  ' + ShortCutToText(Item.ShortCut)
   else
     MICaption := Item.Caption;
    R := Rect(0, 0, 0, 0);
    DrawText(Canvas.Handle, PChar(MICaption), Length(MICaption), R,
             DT_CALCRECT);
    Result := R.Right + 2;
  end;

  function GetMenuWindowHeight: Integer;
  var
    i, j, ih: integer;
  begin
    j := 0;
    for i := VisibleStartIndex to VisibleCount - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
      if PW <> nil
      then
        begin
          if MenuItem.Caption = '-'
          then ih := RectHeight(DSMI.DividerRect)
          else ih := RectHeight(DSMI.SkinRect);
        end
      else
        begin
          if MenuItem.Caption = '-'
          then ih := 4
          else ih := ParentMenu.DefaultMenuItemHeight;
        end;
      inc(j, ih);
    end;
    if PW <> nil
    then
      Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
    else
      Result := j + 6;
  end;

  function GetMenuWindowWidth: Integer;
  var
    i, iw: Integer;
  begin
    iw := 0;
    for i := 0 to ItemList.Count - 1 do
    begin
      j := CalcItemTextWidth(TspSkinMenuItem(ItemList.Items[i]).MenuItem);
      if j > iw then iw := j;
    end;
    inc(iw, 16);
    if ImgL <> nil
    then
      GlyphWidth := ImgL.Width + 5
    else
      GlyphWidth := 16;
    Inc(iw, GlyphWidth);
    if (PW <> nil)
    then
      begin
        Inc(iw, DSMI.TextRct.Left);
        Inc(iw, RectWidth(DSMI.SkinRect) - DSMI.TextRct.Right);
        Result := iw + PW.ItemsRect.Left + (WindowPicture.Width - PW.ItemsRect.Right);
      end
    else
      Result := iw + 10;
  end;


procedure CalcSizes;
var
  W, H: Integer;
begin
  //
  VisibleStartIndex := 0;
  VisibleCount := ItemList.Count;
  W := GetMenuWindowWidth;
  H := GetMenuWindowHeight;
  Scroll := False;
  //
  if H > RectHeight(ParentMenu.WorkArea)
  then
    begin
      H := RectHeight(ParentMenu.WorkArea);
      Scroll := True;
    end;  
  //
  Width := W;
  Height := H;
end;

var
  TmpStartIndex: Integer;
begin
  if SD <> nil
  then
    begin
      i := SD.GetIndex('MENUITEM');
      if i = -1 then i := SD.GetIndex('menuitem');
    end
  else
    i := -1;

  if (PW <> nil) and (i <> - 1) and ParentMenu.UseSkinFont
  then
    begin
      // init menu
      DSMI := TspDataSkinMenuItem(SD.ObjectList.Items[i]);
      with Canvas.Font do
      begin
        Height := DSMI.FontHeight;
        Style := DSMI.FontStyle;
        Name := DSMI.FontName;
      end;
    end
  else
    begin
      if (i <> -1)
      then
        DSMI := TspDataSkinMenuItem(SD.ObjectList.Items[i])
      else
        DSMI := nil;
      Canvas.Font.Assign(Self.ParentMenu.FDefaultMenuItemFont);
    end;


  if (ParentMenu.SkinData <> nil) and
     (ParentMenu.SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.CharSet := ParentMenu.SkinData.ResourceStrData.Charset
  else
    Canvas.Font.CharSet := ParentMenu.FDefaultMenuItemFont.Charset;
    
  Menu := Item.GetParentMenu;
  ImgL := Menu.Images;
  j := Item.Count;
  if StartIndex < j then
  for i := StartIndex to  j - 1 do
   if TMenuItem(Item.Items[i]).Visible
   then
     begin
       if TMenuItem(Item.Items[i]).Action <> nil
       then
         TMenuItem(Item.Items[i]).Action.Update;
       ItemList.Add(TspSkinMenuItem.Create(Self, TMenuItem(Item.Items[i]), DSMI));
     end;

  TmpStartIndex := StartIndex - Item.Count;
  if TmpStartIndex < 0 then TmpStartIndex := 0;
  j := Item2.Count;
  if TmpStartIndex < j then
  for i := TmpStartIndex to  j - 1 do
   if TMenuItem(Item2.Items[i]).Visible
   then
     begin
       if TMenuItem(Item2.Items[i]).Action <> nil
       then
         TMenuItem(Item2.Items[i]).Action.Update;
       ItemList.Add(TspSkinMenuItem.Create(Self, TMenuItem(Item2.Items[i]), DSMI));
     end;
  //

  CalcSizes;

  if PW <> nil
  then
    begin
      sw := WindowPicture.Width;
      sh := WindowPicture.Height;
      NewLTPoint := PW.LTPoint;
      NewRTPoint := Point(Width - (sw - PW.RTPoint.X), PW.RTPoint.Y);
      NewLBPoint := Point(PW.LBPoint.X, Height - (sh - PW.LBPoint.Y));
      NewRBPoint := Point(Width - (sw - PW.RBPoint.X),
                          Height - (sh - PW.RBPoint.Y));

      NewItemsRect := Rect(PW.ItemsRect.Left, PW.ItemsRect.Top,
                           Width - (sw - PW.ItemsRect.Right),
                           Height - (sh - PW.ItemsRect.Bottom));

    end
  else
    NewItemsRect := Rect(3, 3, Width - 3, Height - 3);
  CalcItemRects;
  if MaskPicture <> nil then SetMenuWindowRegion;
end;

function TspSkinPopupWindow.GetEndStartVisibleIndex: Integer;
var
  i, j, k, ih, H: Integer;
begin
  j := NewItemsRect.Bottom - MarkerItemHeight;
  H := MarkerItemHeight;
  k := 0;
  for i := ItemList.Count - 1 downto 0 do
  begin
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
       if DSMI <> nil
       then
         begin
           if MenuItem.Caption = '-'
           then ih := RectHeight(DSMI.DividerRect)
           else ih := RectHeight(DSMI.SkinRect);
         end
       else
         begin
           if MenuItem.Caption = '-'
           then ih := 4
           else ih := ParentMenu.DefaultMenuItemHeight;
         end;
       j := j - ih;
       if j >= H
       then
         inc(k)
       else
         Break;
     end;
  end;
  Result := ItemList.Count - k;
end;

procedure TspSkinPopupWindow.CalcItemRects;
var
  i, j, ih, H: Integer;
begin
  j := NewItemsRect.Top;
  H := NewItemsRect.Bottom;
  if Scroll
  then
    begin
      H := H - MarkerItemHeight;
      j := j + MarkerItemHeight;
    end;
  VisibleCount := 0;
  for i := VisibleStartIndex to ItemList.Count - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
      if DSMI <> nil
      then
        begin
          if MenuItem.Caption = '-'
          then ih := RectHeight(DSMI.DividerRect)
          else ih := RectHeight(DSMI.SkinRect)
        end
      else
        begin
          if MenuItem.Caption = '-'
          then ih := 4
          else ih := ParentMenu.DefaultMenuItemHeight;
        end;
      ObjectRect.Left := NewItemsRect.Left;
      ObjectRect.Right := NewItemsRect.Right;
      ObjectRect.Top := j;
      ObjectRect.Bottom :=  j + ih;
      if ObjectRect.Bottom <= H
      then
        begin
          FVisible := True;
          Inc(VisibleCount)
        end
      else
        Break;
      inc(j, ih);
    end;

  if Scroll
  then
    begin
      if VisibleStartIndex > 0
      then
        for i := 0 to VisibleStartIndex - 1 do
          TspSkinMenuItem(ItemList.Items[i]).FVisible := False;
      if VisibleCount + VisibleStartIndex <= ItemList.Count - 1
      then
        for i := VisibleCount + VisibleStartIndex to ItemList.Count - 1 do
          TspSkinMenuItem(ItemList.Items[i]).FVisible := False;
    end;

end;

procedure TspSkinPopupWindow.CMMouseEnter;
begin
  inherited;
end;

procedure TspSkinPopupWindow.CMMouseLeave;
begin
  inherited;
end;

procedure TspSkinPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_ ;
  end;
end;

procedure TspSkinPopupWindow.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspSkinPopupWindow.Hide;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  MouseTimer.Enabled := False;
  Visible := False;
end;

procedure TspSkinPopupWindow.Show;

procedure CalcMenuPos(var X, Y: Integer; R: TRect);
var
  WA: TRect;
  ChangeY: Boolean;

  function GetY: Integer;
  var
    Offset: Integer;
  begin
    if Scroll
    then
      Result := WA.Top
    else
      begin
        if PopupByItem
        then
          begin
            Offset := R.Top + Height - NewItemsRect.Top - WA.Bottom;
            if Offset > 0
            then
              begin
                if R.Top < WA.Top + RectHeight(WA) div 2
                then
                  Result := WA.Bottom - Height
                else
                  begin
                    Result := R.Bottom - Height + NewItemsRect.Top;
                    if Result  < WA.Top then Result := WA.Top;
                  end
              end
            else
              Result := R.Top - NewItemsRect.Top;
          end
        else
          begin
            if PopupUp
            then
              begin
                if R.Top - Height < WA.Top
                then
                  begin
                    if R.Top < WA.Top + RectHeight(WA) div 2
                    then
                      begin
                        Result := R.Bottom;
                        Offset := Result + Height - WA.Bottom;
                        if Offset > 0
                        then
                          begin
                            Result  := Result - Offset;
                            ChangeY := True;
                          end;
                       end
                     else
                       begin
                         Result := WA.Top;
                         ChangeY := True;
                       end;
                  end
                else
                  Result  := R.Top - Height;
              end
            else
              begin
                Offset := R.Bottom + Height - WA.Bottom;
                if Offset > 0
                then
                  begin
                    if R.Top < WA.Top + RectHeight(WA) div 2
                    then
                      begin
                        Result := R.Bottom - Offset;
                        ChangeY := True
                      end
                    else
                      begin
                        if R.Top - Height < WA.Top
                        then
                          begin
                            Result := WA.Top;
                            ChangeY := True;
                          end
                        else
                          Result := R.Top - Height;
                      end
                  end
                else
                  Result := R.Bottom;
              end;
          end;
      end;
  end;

  function GetX: Integer;
  begin
    if PopupByItem or Scroll or ChangeY
    then
      begin
        if R.Right + Width + 1 > WA.Right
        then Result := R.Left - Width - 1 else Result := R.Right + 1;
      end
    else
      begin
        if R.Left + Width > WA.Right
        then Result := WA.Right - Width else
        if R.Left < WA.Left then Result := WA.Left else Result := R.Left;
      end;
  end;

begin
  WA := ParentMenu.WorkArea;
  ChangeY := False;
  Y := GetY;
  X := GetX;
end;

const
  WS_EX_LAYERED = $80000;
var
  i: Integer;
  ABV: Byte;
begin
  if CheckW2KWXP and ParentMenu.AlphaBlend and ParentMenu.AlphaBlendAnimation and
     ParentMenu.First
  then
    Application.ProcessMessages;

  CreateMenu(AItem, StartIndex);
  CalcMenuPos(ShowX, ShowY, R);

  if AlphaBlend and not CheckW2KWXP
  then
    WT.Enabled := True
  else
    begin
      //
      if (PW <> nil) and (PW.CursorIndex <> -1)
      then
        Cursor := SD.StartCursorIndex + PW.CursorIndex;
      //
      if CheckW2KWXP and ParentMenu.AlphaBlend
      then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE,
                        GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
          if ParentMenu.First and ParentMenu.AlphaBlendAnimation
          then SetAlphaBlendTransparent(Handle, 0)
          else SetAlphaBlendTransparent(Handle, ParentMenu.AlphaBlendValue);
        end;
      //
      SetWindowPos(Handle, HWND_TOPMOST, ShowX, ShowY, 0, 0,
      SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
      Visible := True;
      //
      if CheckW2KWXP and ParentMenu.AlphaBlend and ParentMenu.AlphaBlendAnimation and
         ParentMenu.First
      then
        begin
          i := 0;
          ABV := ParentMenu.AlphaBlendValue;
          repeat
            Inc(i, 2);
            if i > ABV then i := ABV;
            SetAlphaBlendTransparent(Handle, i);
          until i >= ABV;
        end;
      //
      MouseTimer.Enabled := True;
      ActiveItem := -1;
      if ItemList.Count > 0
      then
        for i := 0 to ItemList.Count - 1 do
        with TspSkinMenuItem(ItemList.Items[i]) do
        begin
          if (MenuItem.Enabled) and (MenuItem.Caption <> '-')
          then
            begin
              WaitCommand := True;
              ActiveItem := i;
              MouseEnter(True);
              Break;
            end;
        end;
      //
    end;
end;

procedure TspSkinPopupWindow.Show2;

procedure CalcMenuPos(var X, Y: Integer; R: TRect);
var
  WA: TRect;
  ChangeY: Boolean;

  function GetY: Integer;
  var
    Offset: Integer;
  begin
    if Scroll
    then
      Result := WA.Top
    else
      begin
        if PopupByItem
        then
          begin
            Offset := R.Top + Height - NewItemsRect.Top - WA.Bottom;
            if Offset > 0
            then
              begin
                if R.Top < WA.Top + RectHeight(WA) div 2
                then
                  Result := WA.Bottom - Height
                else
                  begin
                    Result := R.Bottom - Height + NewItemsRect.Top;
                    if Result  < WA.Top then Result := WA.Top;
                  end
              end
            else
              Result := R.Top - NewItemsRect.Top;
          end
        else
          begin
            if PopupUp
            then
              begin
                if R.Top - Height < WA.Top
                then
                  begin
                    if R.Top < WA.Top + RectHeight(WA) div 2
                    then
                      begin
                        Result := R.Bottom;
                        Offset := Result + Height - WA.Bottom;
                        if Offset > 0
                        then
                          begin
                            Result  := Result - Offset;
                            ChangeY := True;
                          end;
                       end
                     else
                       begin
                         Result := WA.Top;
                         ChangeY := True;
                       end;
                  end
                else
                  Result  := R.Top - Height;
              end
            else
              begin
                Offset := R.Bottom + Height - WA.Bottom;
                if Offset > 0
                then
                  begin
                    if R.Top < WA.Top + RectHeight(WA) div 2
                    then
                      begin
                        Result := R.Bottom - Offset;
                        ChangeY := True
                      end
                    else
                      begin
                        if R.Top - Height < WA.Top
                        then
                          begin
                            Result := WA.Top;
                            ChangeY := True;
                          end
                        else
                          Result := R.Top - Height;
                      end
                  end
                else
                  Result := R.Bottom;
              end;
          end;
      end;
  end;

  function GetX: Integer;
  begin
    if PopupByItem or Scroll or ChangeY
    then
      begin
        if R.Right + Width + 1 > WA.Right
        then Result := R.Left - Width - 1 else Result := R.Right + 1;
      end
    else
      begin
        if R.Left + Width > WA.Right
        then Result := WA.Right - Width else
        if R.Left < WA.Left then Result := WA.Left else Result := R.Left;
      end;
  end;

begin
  WA := ParentMenu.WorkArea;
  ChangeY := False;
  Y := GetY;
  X := GetX;
end;

const
  WS_EX_LAYERED = $80000;
var
  i: Integer;
  ABV: Byte;
begin
  if CheckW2KWXP and ParentMenu.AlphaBlend and ParentMenu.AlphaBlendAnimation and
     ParentMenu.First
  then
    Application.ProcessMessages;

  CreateMenu2(AItem, AItem2, StartIndex);
  CalcMenuPos(ShowX, ShowY, R);

  if AlphaBlend and not CheckW2KWXP
  then
    WT.Enabled := True
  else
    begin
      //
      if (PW <> nil) and (PW.CursorIndex <> -1)
      then
        Cursor := SD.StartCursorIndex + PW.CursorIndex;
      //
      if CheckW2KWXP and ParentMenu.AlphaBlend
      then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE,
                        GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
          if ParentMenu.First and ParentMenu.AlphaBlendAnimation
          then SetAlphaBlendTransparent(Handle, 0)
          else SetAlphaBlendTransparent(Handle, ParentMenu.AlphaBlendValue);
        end;
      //
      SetWindowPos(Handle, HWND_TOPMOST, ShowX, ShowY, 0, 0,
      SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
      Visible := True;
      //
      if CheckW2KWXP and ParentMenu.AlphaBlend and ParentMenu.AlphaBlendAnimation and
         ParentMenu.First
      then
        begin
          i := 0;
          ABV := ParentMenu.AlphaBlendValue;
          repeat
            Inc(i, 2);
            if i > ABV then i := ABV;
            SetAlphaBlendTransparent(Handle, i);
          until i >= ABV;
        end;
      //
      MouseTimer.Enabled := True;
      ActiveItem := -1;
      if ItemList.Count > 0
      then
        for i := 0 to ItemList.Count - 1 do
        with TspSkinMenuItem(ItemList.Items[i]) do
        begin
          if MenuItem.Enabled and (MenuItem.Caption <> '-')
          then
            begin
              WaitCommand := True;
              ActiveItem := i;
              MouseEnter(True);
              Break;
            end;
        end;
      //
    end;
end;

procedure TspSkinPopupWindow.PaintMenu;
var
  C: TCanvas;
  i: Integer;
  B: TBitMap;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  B := TBitMap.Create;
  CreateRealImage(B);
  // Draw items
  for i := VisibleStartIndex to VisibleStartIndex + VisibleCount - 1 do
    TspSkinMenuItem(ItemList.Items[i]).Draw(B.Canvas);
  // markers
  if Scroll
  then
    begin
      DrawUpMarker(B.Canvas);
      DrawDownMarker(B.Canvas);
    end;
  C.Draw(0, 0, B);
  B.Free;
  C.Free;
end;

procedure TspSkinPopupWindow.WMEraseBkgrnd;
begin
  PaintMenu(Message.WParam);
end;

procedure TspSkinPopupWindow.MouseUp;
begin
  TestActive(X, Y);
  if (ActiveItem <> -1) and (Button = mbleft) and GetActive(X, Y)
  then
    with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
     if MenuItem.Caption <> '-' then MouseDown(X, Y);
end;

procedure TspSkinPopupWindow.TestMouse;
var
  P, P1: TPoint;
begin
  GetCursorPos(P1);
  P := ScreenToClient(P1);
  if (OMX <> P.X) or (OMY <> P.Y)
  then 
    if InWindow(P1)
    then
      TestActive(P.X, P.Y)
    else
      if Scroll
      then
        begin
          ScrollCode := 0;
          DrawUpMarker(Canvas);
          DrawDownMarker(Canvas);
        end;
  OMX := P.X;
  OMY := P.Y;
end;

function TspSkinPopupWindow.GetActive;
var
  i: Integer;
begin
  i := -1;
  if ItemList.Count = 0
  then
    Result := False
  else
  repeat
    Inc(i);
    with TspSkinMenuItem(ItemList.Items[i]) do
      Result := FVisible and PtInRect(ObjectRect, Point(X, Y));
  until Result or (i = ItemList.Count - 1);
end;

procedure TspSkinPopupWindow.TestActive;
var
  i: Integer;
  B: Boolean;
  R1, R2: TRect;
begin
  if Scroll
  then
    begin
      R1 := Rect(NewItemsRect.Left, NewItemsRect.Top,
            NewItemsRect.Right, NewItemsRect.Top + MarkerItemHeight);
      R2 := Rect(NewItemsRect.Left, NewItemsRect.Bottom - MarkerItemHeight,
            NewItemsRect.Right, NewItemsRect.Bottom);

      if PtInRect(R1, Point(X, Y)) and (ScrollCode = 0) and CanScroll(1)
      then
        begin
          ScrollCode := 1;
          DrawUpMarker(Canvas);
          StartScroll;
        end
      else
      if PtInRect(R2, Point(X, Y)) and (ScrollCode = 0)  and CanScroll(2)
      then
        begin
          ScrollCode := 2;
          DrawDownMarker(Canvas);
          StartScroll;
        end
      else
        if (ScrollCode <> 0) and not PtInRect(R1, Point(X, Y)) and
                                 not PtInRect(R2, Point(X, Y))
        then
          StopScroll;
     end;

  if (ItemList.Count = 0) then Exit;

  OldActiveItem := ActiveItem;

  i := -1;
  repeat
    Inc(i);
    with TspSkinMenuItem(ItemList.Items[i]) do
    begin
      B := FVisible and PtInRect(ObjectRect, Point(X, Y));
    end;
  until B or (i = ItemList.Count - 1);

  if B then ActiveItem := i;

  if OldActiveItem >= ItemList.Count then OldActiveItem := -1;
  if ActiveItem >= ItemList.Count then ActiveItem := -1;

  if (OldActiveItem = ActiveItem) and (ActiveItem <> -1)
  then
    begin
      with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
       if WaitCommand
       then
         begin
           WaitCommand := False;
           if MenuItem.Count <> 0
           then
             MouseEnter(False);
         end;
    end
  else
  if (OldActiveItem <> ActiveItem)
  then
    begin
      if OldActiveItem <> - 1
      then
        with TspSkinMenuItem(ItemList.Items[OldActiveItem]) do
        begin
          if MenuItem.Enabled and (MenuItem.Caption <> '-')
          then
            MouseLeave;
        end;

      if ActiveItem <> - 1
      then
        with TspSkinMenuItem(ItemList.Items[ActiveItem]) do
        begin
          if MenuItem.Enabled and (MenuItem.Caption <> '-')
          then
            MouseEnter(False);
        end;
    end;

end;

function TspSkinPopupWindow.InWindow;
var
  H: HWND;
begin
  H := WindowFromPoint(P);
  Result := H = Handle;
end;

//====================TspSkinMenu===================//
constructor TspSkinMenu.CreateEx;
begin
  inherited Create(AOwner);
  FUseSkinFont := True;
  FPopupList := TList.Create;
  WaitTimer := TTimer.Create(Self);
  WaitTimer.Enabled := False;
  WaitTimer.OnTimer := WaitItem;
  WaitTimer.Interval := WaitTimerInterval;
  WItem := nil;
  FVisible := False;
  FForm := AForm;
  AlphaBlend := False;
  AlphaBlendValue := 200;
  PopupCtrl := nil;
  DCtrl := nil;
  FDefaultMenuItemHeight := 20;
  FDefaultMenuItemFont := TFont.Create;
  with FDefaultMenuItemFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
end;

destructor TspSkinMenu.Destroy;
begin
  CloseMenu(0);
  FPopupList.Free;
  WaitTimer.Free;
  FDefaultMenuItemFont.Free;
  inherited Destroy;
end;

procedure TspSkinMenu.SetDefaultMenuItemFont(Value: TFont);
begin
  FDefaultMenuItemFont.Assign(Value);
end;

function TspSkinMenu.GetWorkArea;
begin
  Result := GetMonitorWorkArea(FForm.Handle, True);
end;

procedure TspSkinMenu.WaitItem(Sender: TObject);
begin
  if WItem <> nil then CheckItem(WItem.Parent, WItem, True, False);
  WaitTimer.Enabled := False;
end;

function TspSkinMenu.GetPWIndex;
var
  i: Integer;
begin
  for i := 0 to FPopupList.Count - 1 do
    if PW = TspSkinPopupWindow(FPopupList.Items[i]) then Break;
  Result := i;
end;

procedure TspSkinMenu.CheckItem;
var
  Menu: TMenu;
  MenuI: TMenuItem;
  i: Integer;
  R: TRect;
begin
  if (MI.MenuItem.Count = 0) and not Down
  then
    begin
      WaitTimer.Enabled := False;
      WItem := nil;
      i := GetPWIndex(PW);
      if i < FPopupList.Count - 1 then CloseMenu(i + 1);
    end
  else
  if (MI.MenuItem.Count = 0) and Down
  then
    begin
      WaitTimer.Enabled := False;
      WItem := nil;
      MenuI := MI.MenuItem;
      Hide;
      Menu := MenuI.GetParentMenu;
      Menu.DispatchCommand(MenuI.Command);
      //
      if DCtrl <> nil
      then
        if DCtrl is TWinControl
        then
          SendMessage(TWinControl(DCtrl).Handle, WM_AFTERDISPATCH, 0, 0)
        else
          DCtrl.Perform(WM_AFTERDISPATCH, 0, 0);
      //
    end
  else
  if (MI.MenuItem.Count <> 0) and not Down and not Kb
  then
    begin
      WaitTimer.Enabled := False;
      WItem := nil;
      i := GetPWIndex(PW);
      if i < FPopupList.Count - 1 then CloseMenu(i + 1);
      WItem := MI;
      WaitTimer.Enabled := True;
    end
  else
  if (MI.MenuItem.Count <> 0) and Down
  then
    begin
      //
      MenuI := MI.MenuItem;
      Menu := MenuI.GetParentMenu;
      Menu.DispatchCommand(MenuI.Command);
      //
      WaitTimer.Enabled := False;
      WItem := nil;
      MI.Down := True;
      R.Left := PW.Left + MI.ObjectRect.Left;
      R.Top := PW.Top + MI.ObjectRect.Top;
      R.Right := PW.Left + MI.ObjectRect.Right;
      R.Bottom := PW.Top + MI.ObjectRect.Bottom;
      PopupSub(R, MI.MenuItem, 0, True, False);
    end
end;

procedure TspSkinMenu.Popup;
begin
  FFirst := not FVisible;
  PopupCtrl := APopupCtrl;
  if FPopupList.Count <> 0 then CloseMenu(0);
  WorkArea := GetWorkArea;
  SkinData := ASkinData;
  if (AItem.Count = 0) or (StartIndex >= AItem.Count) then Exit;
  FVisible := True;
  PopupSub(R, AItem, StartIndex, False, PopupUp);
  FFirst := False;
end;

procedure TspSkinMenu.Popup2;
begin
  FFirst := not FVisible;
  PopupCtrl := APopupCtrl;
  if FPopupList.Count <> 0 then CloseMenu(0);
  WorkArea := GetWorkArea;
  SkinData := ASkinData;
   if (AItem.Count = 0) or (StartIndex >= AItem.Count + AItem2.Count) then Exit;
  FVisible := True;
  PopupSub2(R, AItem, AItem2, StartIndex, False, PopupUp);
  FFirst := False;
end;

procedure TspSkinMenu.PopupSub;
begin
  if (SkinData = nil) or (SkinData.Empty)
  then
    FPopupList.Add(TspSkinPopupWindow.CreateEx(Self, Self, nil))
  else
    FPopupList.Add(TspSkinPopupWindow.CreateEx(Self, Self, SkinData.PopupWindow));
  with TspSkinPopupWindow(FPopupList.Items[FPopupList.Count - 1]) do
    Show(R, AItem, StartIndex, PopupByItem, PopupUp);
end;

procedure TspSkinMenu.PopupSub2;
begin
  if (SkinData = nil) or (SkinData.Empty)
  then
    FPopupList.Add(TspSkinPopupWindow.CreateEx(Self, Self, nil))
  else
    FPopupList.Add(TspSkinPopupWindow.CreateEx(Self, Self, SkinData.PopupWindow));
  with TspSkinPopupWindow(FPopupList.Items[FPopupList.Count - 1]) do
    Show2(R, AItem, AItem2, StartIndex, PopupByItem, PopupUp);
end;

procedure TspSkinMenu.CloseMenu;
var
  i: Integer;
begin
  for i := FPopupList.Count - 1 downto EndIndex do
  begin
    TspSkinPopupWindow(FPopupList.Items[i]).Free;
    FPopupList.Delete(i);
  end;
  if EndIndex = 0
  then
    begin
      WaitTimer.Enabled := False;
      FVisible := False;
      DCtrl := PopupCtrl;
      if PopupCtrl <> nil
      then
        begin
          if PopupCtrl is TWinControl
          then
            SendMessage(TWinControl(PopupCtrl).Handle, WM_CLOSESKINMENU, 0, 0)
          else
            PopupCtrl.Perform(WM_CLOSESKINMENU, 0, 0);
          PopupCtrl := nil;
        end;
    end;
end;

procedure TspSkinMenu.Hide;
begin
  CloseMenu(0);
  WaitTimer.Enabled := False;
  WItem := nil;
  if FForm <> nil then
  SendMessage(FForm.Handle, WM_CLOSESKINMENU, 0, 0);
  if PopupCtrl <> nil
  then
    begin
      if PopupCtrl is TWinControl
      then
        SendMessage(TWinControl(PopupCtrl).Handle, WM_CLOSESKINMENU, 0, 0)
       else
         PopupCtrl.Perform(WM_CLOSESKINMENU, 0, 0);
      PopupCtrl := nil;
    end;
end;

//============= TspSkinPopupMenu =============//
function FindDSFComponent(AForm: TForm): TSpDynamicSkinForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to AForm.ComponentCount - 1 do
   if AForm.Components[i] is TspDynamicSkinForm
   then
     begin
       Result := TspDynamicSkinForm(AForm.Components[i]);
       Break;
     end;
end;

constructor TspSkinPopupMenu.Create;
begin
  inherited Create(AOwner);
  FComponentForm := nil;
  FSD := nil;
end;

procedure TspSkinPopupMenu.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinPopupMenu.PopupFromRect;
var
  DSF: TspDynamicSkinForm;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FComponentForm = nil
  then
    begin
      //DSF := FindDSFComponent(TForm(Owner))
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
    end
  else
    DSF := FindDSFComponent(FComponentForm);
  if (DSF <> nil) and (FSD = nil)
  then
    if DSF.MenusSkinData = nil
    then
      FSD := DSF.SkinData
    else
      FSD := DSF.MenusSkinData;
  if DSF <> nil
  then
    begin
      DSF.SkinMenuOpen;
      DSF.SkinMenu.Popup(nil, FSD, 0, R, Items, APopupUp);
    end;
end;

procedure TspSkinPopupMenu.Popup;
var
  DSF: TspDynamicSkinForm;
var
  R: TRect;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FComponentForm = nil
  then
    begin
      //DSF := FindDSFComponent(TForm(Owner))
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
    end
  else
    DSF := FindDSFComponent(FComponentForm);
  if (DSF <> nil) and (FSD = nil)
  then
    if DSF.MenusSkinData = nil
    then
      FSD := DSF.SkinData
    else
      FSD := DSF.MenusSkinData;
  if DSF <> nil
  then
    begin
      DSF.SkinMenuOpen;
      R := Rect(X, Y, X, Y);
      DSF.SkinMenu.Popup(nil, FSD, 0, R, Items, False);
    end;
end;

procedure TspSkinPopupMenu.PopupFromRect2;
var
  DSF: TspDynamicSkinForm;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FComponentForm = nil
  then
    begin
      //DSF := FindDSFComponent(TForm(Owner))
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
    end
  else
    DSF := FindDSFComponent(FComponentForm);
  if (DSF <> nil) and (FSD = nil)
  then
    if DSF.MenusSkinData = nil
    then
      FSD := DSF.SkinData
    else
      FSD := DSF.MenusSkinData;
  if DSF <> nil
  then
    begin
      DSF.SkinMenuOpen;
      DSF.SkinMenu.Popup(ACtrl, FSD, 0, R, Items, APopupUp);
    end;
end;

procedure TspSkinPopupMenu.Popup2;
var
  R: TRect;
  DSF: TspDynamicSkinForm;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FComponentForm = nil
  then
    begin
      //DSF := FindDSFComponent(TForm(Owner))
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
    end
  else
    DSF := FindDSFComponent(FComponentForm);
  if (DSF <> nil) and (FSD = nil)
  then
    if DSF.MenusSkinData = nil
    then
      FSD := DSF.SkinData
    else
      FSD := DSF.MenusSkinData;
  if (DSF <> nil) and (FSD <> nil)
  then
    begin
      DSF.SkinMenuOpen;
      R := Rect(X, Y, X, Y);
      DSF.SkinMenu.Popup(ACtrl, FSD, 0, R, Items, False);
    end;
end;

end.

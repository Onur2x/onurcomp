{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }     
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
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
//{$DEFINE TNTUNICODE}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ImgList, SkinData, SPUtils, spEffBMp,
  SkinHint{$IFDEF TNTUNICODE}, TntMenus {$ENDIF};

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
    procedure DrawSkinCheckImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
    procedure DrawSkinRadioImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
    procedure DrawSkinArrowImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
   public
    MenuItem: TMenuItem;
    ObjectRect: TRect;
    Active: Boolean;
    Down: Boolean;
    FVisible: Boolean;
    WaitCommand: Boolean;
    //
    CurrentFrame: Integer;
    //
    constructor Create(AParent: TspSkinPopupWindow; AMenuItem: TMenuItem;
                       AData: TspDataSkinMenuItem);
    function EnableMorphing: Boolean;
    function EnableAnimation: Boolean;
    procedure Draw(Cnvs: TCanvas);
    procedure ResizeDraw(Cnvs: TCanvas);
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
    Scroll2: Boolean;
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
    procedure CreateRealImage(B: TBitMap; ADrawClient: Boolean);
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
    procedure DrawScrollArea(Cnvs: TCanvas; R: TRect);
    function GetItemHeight: Integer;
  public
    Sc: TBitMap;
    ESc: TspEffectBmp;
    AlphaBlend: Boolean;
    AlphaBlendValue: Byte;
    AlphaBlendAnimation: Boolean;
    ItemList: TList;
    ActiveItem: Integer;
    FPaintBuffer: TBitMap;
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
    FUseSkinSize: Boolean;
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
    FOnMenuClose: TNotifyEvent;
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
    MaxMenuItemsInWindow: Integer;
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
    property UseSkinSize: Boolean
     read FUseSkinSize write FUseSkinSize; 
    property OnMenuClose: TNotifyEvent read FOnMenuClose write FOnMenuClose;
  end;

  {$IFDEF TNTUNICODE}
  TspSkinPopupMenu = class(TTntPopupMenu)
  {$ELSE}
  TspSkinPopupMenu = class(TPopupMenu)
  {$ENDIF}
  private
    FPopupPoint: TPoint;
  protected
    FSD: TspSkinData;
    FComponentForm: TForm;
    FSkinComponent: TComponent;
    FOnMenuClose: TNotifyEvent;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property PopupPoint: TPoint read FPopupPoint;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(X, Y: Integer); override;
    procedure PopupFromRect(R: TRect; APopupUp: Boolean);
    procedure Popup2(ACtrl: TControl; X, Y: Integer);
    procedure PopupFromRect2(ACtrl: TControl; R: TRect; APopupUp: Boolean);
    property ComponentForm: TForm read FComponentForm write FComponentForm;
    property SkinComponent: TComponent read FSkinComponent write FSkinComponent;
  published
    property SkinData: TspSkinData read FSD write FSD;
    property OnMenuClose: TNotifyEvent read FOnMenuClose write FOnMenuClose;
  end;


  // Images menu ---------------------------------------------------------------
  TspSkinImagesMenu = class;

  TspImagesMenuItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FCaption: String;
    FOnClick: TNotifyEvent;
    FButton: Boolean;
    FHeader: Boolean;
    FHint: String;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetCaption(const Value: String); virtual;
  public
    ItemRect: TRect;
    FColor: TColor;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Button: Boolean read FButton write FButton;
    property Header: Boolean read FHeader write FHeader;
    property Caption: String read FCaption write SetCaption;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TspImagesMenuItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspImagesMenuItem;
    procedure SetItem(Index: Integer; Value:  TspImagesMenuItem);
  protected
    function GetOwner: TPersistent; override;
  public
    ImagesMenu: TspSkinImagesMenu;
    constructor Create(AImagesMenu: TspSkinImagesMenu);
    property Items[Index: Integer]:  TspImagesMenuItem read GetItem write SetItem; default;
  end;

  TspSkinImagesMenuPopupWindow = class(TCustomControl)
  private
    FSkinSupport: Boolean;
    OldAppMessage: TMessageEvent;
    ImagesMenu: TspSkinImagesMenu;
    FRgn: HRGN;
    NewLTPoint, NewRTPoint,
    NewLBPoint, NewRBPoint: TPoint;
    NewItemsRect: TRect;
    WindowPicture, MaskPicture: TBitMap;
    MouseInItem, OldMouseInItem: Integer;
    FDown: Boolean;
    FItemDown: Boolean;
    procedure AssignItemRects;
    procedure CreateMenu;
    procedure HookApp;
    procedure UnHookApp;
    procedure NewAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure SetMenuWindowRegion;
    procedure DrawItems(ActiveIndex, SelectedIndex: Integer; C: TCanvas);
    function GetItemRect(Index: Integer): TRect;
    function GetItemFromPoint(P: TPoint): Integer;
    procedure DrawItemCaption(ACaption: String; R: TRect; C: TCanvas; AActive, ADown: Boolean);
    procedure DrawActiveItem(R: TRect; C: TCanvas; ASelected: Boolean);
    procedure TestActive(X, Y: Integer);
    function GetLabelDataControl: TspDataSkinLabelControl;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure WMEraseBkGrnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WndProc(var Message: TMessage); override;
    procedure ProcessKey(KeyCode: Integer);
    procedure FindLeft;
    procedure FindRight;
    procedure FindUp;
    procedure FindDown;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Show(PopupRect: TRect);
    procedure Hide(AProcessEvents: Boolean);
    procedure Paint; override;
 end;

  TspSkinImagesMenu = class(TComponent)
  private
    FImages: TCustomImageList;
    FImagesItems: TspImagesMenuItems;
    FItemIndex: Integer;
    FColumnsCount: Integer;
    FOnItemClick: TNotifyEvent;
    FSkinData: TspSkinData;
    FPopupWindow: TspSkinImagesMenuPopupWindow;
    FShowSelectedItem: Boolean;
    FOldItemIndex: Integer;
    FOnChange: TNotifyEvent;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    FOnInternalChange: TNotifyEvent;
    FOnMenuClose: TNotifyEvent;
    FOnMenuPopup: TNotifyEvent;
    FOnInternalMenuClose: TNotifyEvent;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FSkinHint: TspSkinHint;
    FShowHints: Boolean;
    procedure SetDefaultFont(Value: TFont);
    procedure SetImagesItems(Value: TspImagesMenuItems);
    procedure SetImages(Value: TCustomImageList);
    procedure SetColumnsCount(Value: Integer);
    procedure SetSkinData(Value: TspSkinData);
    function GetSelectedItem: TspImagesMenuItem;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ProcessEvents(ACanProcess: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Popup(X, Y: Integer);
    procedure PopupFromRect(R: TRect);
    procedure Hide;
    property SelectedItem: TspImagesMenuItem read GetSelectedItem;
    property OnInternalChange: TNotifyEvent read FOnInternalChange write FOnInternalChange;
    property OnInternalMenuClose: TNotifyEvent read FOnInternalMenuClose write FOnInternalMenuClose;
  published
    property Images: TCustomImageList read FImages write SetImages;
    property SkinHint: TspSkinHint read FSkinHint write FSkinHint;
    property ShowHints: Boolean read FShowHints write FShowHints;
    property ImagesItems: TspImagesMenuItems read FImagesItems write SetImagesItems;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property ColumnsCount: Integer read FColumnsCount write SetColumnsCount;
    property SkinData: TspSkinData read FSkinData write SetSkinData;
    property ShowSelectedItem: Boolean read FShowSelectedItem write FShowSelectedItem;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property OnItemClick: TNotifyEvent read FOnItemClick write FOnItemClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMenuPopup: TNotifyEvent read FOnMenuPopup write FOnMenuPopup;
    property OnMenuClose: TNotifyEvent read FOnMenuClose write FOnMenuClose;
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
  CurrentFrame := 0;
end;

procedure TspSkinMenuItem.DrawSkinCheckImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  if AActive then SR := MI.ActiveCheckImageRect else SR := MI.CheckImageRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    ActivePicture.Canvas, SR);
  Buffer.Transparent := True;
  X := R.Left + RectWidth(R) div 2 - Buffer.Width div 2;
  if X < R.Left then X := R.Left;
  Y := R.Top + RectHeight(R) div 2 - Buffer.Height div 2;
  if Y < R.Top then Y := R.Top;
  Cnvs.Draw(X, Y, Buffer);
  Buffer.Free;
end;

procedure TspSkinMenuItem.DrawSkinRadioImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  if AActive then SR := MI.ActiveRadioImageRect else SR := MI.RadioImageRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    ActivePicture.Canvas, SR);
  Buffer.Transparent := True;
  X := R.Left + RectWidth(R) div 2 - Buffer.Width div 2;
  if X < R.Left then X := R.Left;
  Y := R.Top + RectHeight(R) div 2 - Buffer.Height div 2;
  if Y < R.Top then Y := R.Top;
  Cnvs.Draw(X, Y, Buffer);
  Buffer.Free;
end;

procedure TspSkinMenuItem.DrawSkinArrowImage(Cnvs: TCanvas; R: TRect; AActive: Boolean);
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  if AActive then SR := MI.ActiveArrowImageRect else SR := MI.ArrowImageRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    ActivePicture.Canvas, SR);
  Buffer.Transparent := True;
  X := R.Left + RectWidth(R) div 2 - Buffer.Width div 2;
  if X < R.Left then X := R.Left;
  Y := R.Top + RectHeight(R) div 2 - Buffer.Height div 2;
  if Y < R.Top then Y := R.Top;
  Cnvs.Draw(X, Y, Buffer);
  Buffer.Free;
end;

function TspSkinMenuItem.EnableAnimation: Boolean;
begin
  Result := (MI <> nil) and not IsNullRect(MI.AnimateSkinRect) and (Parent.SD <> nil) and
             not (Parent.SD.Empty) and
             Parent.SD.EnableSkinEffects;
end;

function TspSkinMenuItem.EnableMorphing: Boolean;
begin
  Result := (MI <> nil) and MI.Morphing and (Parent.SD <> nil) and
             Parent.SD.EnableSkinEffects;
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
  if (MI <> nil) and EnableAnimation
  then
    begin
      if  Parent.MorphTimer.Interval <> MI.AnimateInterval
      then
        Parent.MorphTimer.Interval := MI.AnimateInterval;
       if EnableAnimation and not MI.InActiveAnimation and not Active
       then
        begin
          CurrentFrame := 0;
          Draw(Parent.Canvas);
       end
      else
        Parent.MorphTimer.Enabled := True
    end
  else
  if (MI <> nil) and EnableMorphing
  then
    begin
      if Parent.MorphTimer.Interval <> MorphTimerInterval
      then
        Parent.MorphTimer.Interval := MorphTimerInterval;
      Parent.MorphTimer.Enabled := True
    end
  else
    Draw(Parent.Canvas);
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
  if EnableAnimation then CurrentFrame := 0;   
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
  if Parent.Hint <> MenuItem.Hint then Parent.Hint := MenuItem.Hint;  
end;

procedure TspSkinMenuItem.MouseLeave;
begin
  WaitCommand := False;
  Active := False;
  if EnableAnimation then CurrentFrame := MI.FrameCount + 1;
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
  MIShortCut, S: WideString;
  B: TBitMap;
  TextOffset: Integer;
  R, TR, SR: TRect;
  DrawGlyph: Boolean;
  GX, GY, IX, IY: Integer;
  EB1: TspEffectBmp;
  kf: Double;
begin
  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(TTNTMenuItem(MenuItem).ShortCut)
      else
        MIShortCut := '';
     end
  else
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(MenuItem.ShortCut)
      else
        MIShortCut := '';
    end;
  {$ELSE}
  if MenuItem.ShortCut <> 0
  then
    MIShortCut := ShortCutToText(MenuItem.ShortCut)
  else
    MIShortCut := '';
  {$ENDIF}

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

  {$IFDEF TNTUNICODE}
  if MenuItem is TTntMenuItem
  then
    S := TTntMenuItem(MenuItem).Caption
  else
    S := MenuItem.Caption;
  {$ELSE}
  S := MenuItem.Caption;
  {$ENDIF}


  TR := Rect(2, 2, B.Width - 2, B.Height - 2);
  // text
  R := Rect(TR.Left + TextOffset, 0, TR.Right - 19, 0);
  SPDrawSkinText(B.Canvas, S, R,
             DT_CALCRECT);
  OffsetRect(R, 0, TR.Top + RectHeight(TR) div 2 - R.Bottom div 2);
  Inc(R.Right, 2);
   SPDrawSkinText(B.Canvas, S, R,
    Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
  // short cut
  if MIShortCut <> ''
  then
    begin
      SR := Rect(0, 0, 0, 0);
      SPDrawSkinText(B.Canvas, MIShortCut, SR, DT_CALCRECT);
      SR := Rect(TR.Right - SR.Right - 19, R.Top, TR.Right - 19, R.Bottom);
      SPDrawSkinText(B.Canvas, MIShortCut, SR,
       Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
    end;
  //
  if MenuItem.Count <> 0
  then
    DrawSubImage(B.Canvas,
                 TR.Right - 7, TR.Top + RectHeight(TR) div 2 - 4,
                 B.Canvas.Font.Color);
  //
  DrawGlyph := (not MenuItem.Bitmap.Empty) or  ((Parent.ImgL <> nil) and (MenuItem.ImageIndex > -1) and
       (MenuItem.ImageIndex < Parent.ImgL.Count));

  if DrawGlyph
  then
    begin
      if not MenuItem.Bitmap.Empty
        then
          begin
            GX := TR.Left + 2;
            GY := TR.Top + RectHeight(TR) div 2 - MenuItem.Bitmap.Height div 2;
            if MenuItem.Checked
            then
              with B.Canvas do
              begin
                Brush.Style := bsClear;
                Pen.Color := Font.Color;
                Rectangle(GX - 1, GY - 1,
                          GX + MenuItem.Bitmap.Width + 1,
                          GY + MenuItem.Bitmap.Height + 1);
             end;
          end
        else
          begin
            GX := TR.Left + 2;
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
    if not MenuItem.Bitmap.Empty
    then
      B.Canvas.Draw(GX, GY, MenuItem.BitMap)
    else
      Parent.ImgL.Draw(B.Canvas, GX, GY,
        MenuItem.ImageIndex, MenuItem.Enabled);


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

procedure TspSkinMenuItem.ResizeDraw(Cnvs: TCanvas);
var
  GX, GY: Integer;
  DrawGlyph: Boolean; 
  kf: Double;
  SpecRect: TRect;

procedure DrawGroupCaptionItem(Cnvs: TCanvas; R: TRect; Caption: WideString);
var
  LData: TspDataSkinLabelControl;
  I: Integer;
  Buffer: TBitmap;
  Picture: TBitMap;
  LO, RO: Integer;
  R1, R2: TRect;
begin
  if (Parent.PW <> nil)
  then
    begin
      I := Parent.SD.GetControlIndex('menuheader');
      if I = -1
      then
        I := Parent.SD.GetControlIndex('label');
      if I <> -1
      then
        begin
          LData := TspDataSkinLabelControl(Parent.SD.CtrlList[I]);
          Picture := Parent.SD.FActivePictures[LData.PictureIndex];
          Buffer := TBitMap.Create;
          with LData do
          begin
            R1 := Rect(LTPoint.X, RectHeight(SkinRect) div 4,
            RectWidth(SkinRect) - (RectWidth(SkinRect) - RTPoint.X),
            RectHeight(SkinRect) - RectHeight(SkinRect) div 4);
            //
            Buffer.Width := RectWidth(ObjectRect);
            Buffer.Height := RectHeight(ObjectRect);
            CreateStretchImage(Buffer, Picture, SkinRect, R1, True);
          end;
          // caption
          with Buffer.Canvas do
          begin
            Font.Assign(Parent.ParentMenu.DefaultMenuItemFont);
            Font.Color := LData.FontColor;
            Brush.Style := bsClear;
            Delete(Caption, 1, 1);
            Delete(Caption, Length(Caption), 1);
          end;
          R1 := Rect(LData.ClRect.Left, LData.ClRect.Top,
                     Buffer.Width - (RectWidth(LData.SkinRect) - LData.ClRect.Right),
                     Buffer.Height - (RectHeight(LData.SkinRect) - LData.ClRect.Bottom));
          //
          if (Buffer.Canvas.Font.Height div 2) <> (Buffer.Canvas.Font.Height / 2) then Dec(R1.Top, 1);
          //
          R2 := R1;
          SPDrawSkinText(Buffer.Canvas, Caption, R2, DT_CALCRECT);
          R1.Top := R1.Top + RectHeight(R1) div 2 - RectHeight(R2) div 2;
          R1.Bottom := R1.Top + RectHeight(R2);
          //
          SPDrawSkinText(Buffer.Canvas, Caption, R1,
            Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
          //
          Cnvs.Draw(R.Left, R.Top, Buffer);
          Buffer.Free;
        end;
    end;
end;

procedure CreateItemImage(B: TBitMap; AActive: Boolean; FromSpecRect: Boolean);
var
  R, TR, SR, Rct, DR, GR: TRect;
  TextOffset: Integer;
  MIShortCut, S: WideString;
  IX, IY: Integer;
  SE: Boolean;
begin

  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(TTNTMenuItem(MenuItem).ShortCut)
      else
        MIShortCut := '';
     end
  else
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(MenuItem.ShortCut)
      else
        MIShortCut := '';
    end;
  {$ELSE}
  if MenuItem.ShortCut <> 0
  then
    MIShortCut := ShortCutToText(MenuItem.ShortCut)
  else
    MIShortCut := '';
  {$ENDIF}


  if AActive
  then
    begin
      Rct := MI.ActiveSkinRect;
      SE := MI.StretchEffect;
    end
  else
    begin
      Rct := MI.SkinRect;
      SE := MI.InActiveStretchEffect;
      if not MI.InActiveStretchEffect and MI.StretchEffect
      then
        SE := MI.StretchEffect and FromSpecRect;
    end;

  if FromSpecRect then Rct := SpecRect;

  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);

  if not AACtive and MI.InActiveTransparent and
     (Parent.FPaintBuffer <> nil)
  then
    begin
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
       Parent.FPaintBuffer.Canvas, ObjectRect);
    end
  else
   begin
     TR := Rect(MI.ItemLO, RectHeight(Rct) div 4, RectWidth(Rct) - MI.ItemRO,
     RectHeight(Rct) - RectHeight(Rct) div 4);
     CreateStretchImage(B, ActivePicture, Rct, TR, True);
   end;

  if Parent.ImgL = nil
  then TextOffset := 16
  else TextOffset := Parent.GlyphWidth;

  if not IsNullRect(MI.ImageRct) then TextOffset := 0;

  TR := MI.TextRct;
  TR.Right := B.Width - (RectWidth(MI.SkinRect) - MI.TextRct.Right);
  TR.Bottom := B.Height - (RectHeight(MI.SkinRect) - MI.TextRct.Bottom);

  with B.Canvas do
  begin
    Brush.Style := bsClear;

    if Self.Parent.ParentMenu.UseSkinFont
    then
      begin
        Font.Name := MI.FontName;
        Font.Style := MI.FontStyle;
        Font.Height := MI.FontHeight;
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

    if Assigned(MenuItem.OnDrawItem)
    then
      begin
        MenuItem.OnDrawItem(Self, B.Canvas, TR, AActive);
        Exit;
      end;
    //
    {$IFDEF TNTUNICODE}
    if MenuItem is TTntMenuItem
    then
      S := TTntMenuItem(MenuItem).Caption
    else
      S := MenuItem.Caption;
    {$ELSE}
     S := MenuItem.Caption;
    {$ENDIF}
    //
    if (Length(S) > 0) and (S[1] = '-') and (S[Length(S)] = '-') and not MenuItem.Enabled
    then
      begin
        DrawGroupCaptionItem(B.Canvas, Rect(0, 0, B.Width, B.Height), S);
        Exit;
      end;
    //
    R := Rect(TR.Left + TextOffset, 0, TR.Right - 16, 0);
    SPDrawSkinText(B.Canvas, S, R, DT_CALCRECT);
    OffsetRect(R, 0, TR.Top + RectHeight(TR) div 2 - R.Bottom div 2);
    Inc(R.Right, 2);
    //
    if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(R.Top, 1);
    //
    SPDrawSkinText(B.Canvas, S, R,
      Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
    // shortcut
    if MIShortCut <> ''
    then
      begin
        SR := Rect(0, 0, 0, 0);
        SPDrawSkinText(B.Canvas, MIShortCut, SR, DT_CALCRECT);
        SR := Rect(TR.Right - SR.Right - 16, R.Top, TR.Right - 16, R.Bottom);
        //
        if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(SR.Top, 1);
        //
        SPDrawSkinText(B.Canvas,  MIShortCut, SR,
         Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
      end;
    //
    if MenuItem.Count <> 0
    then
      begin
        if IsNullRect(MI.ArrowImageRect)
        then
          DrawSubImage(B.Canvas,
                     TR.Right - 7, TR.Top + RectHeight(TR) div 2 - 4,
                     B.Canvas.Font.Color)
        else
          DrawSkinArrowImage(B.Canvas,
                             Rect(TR.Right - RectWidth(MI.ArrowImageRect) - 5,
                             TR.Top, TR.Right, TR.Bottom),
                             AActive);
      end;
    //


    DrawGlyph := (not MenuItem.Bitmap.Empty) or  ((Parent.ImgL <> nil) and (MenuItem.ImageIndex > -1) and
       (MenuItem.ImageIndex < Parent.ImgL.Count));

    if MI.UseImageColor
    then
      begin
        if AActive
        then
          Font.Color := MI.ActiveImageColor
        else
          Font.Color := MI.ImageColor;
      end;

    if DrawGlyph
    then
      begin
        if not MenuItem.Bitmap.Empty
        then
          begin
            if IsNullRect(MI.ImageRct)
            then
              begin
                GX := TR.Left + 2;
                GY := TR.Top + RectHeight(TR) div 2 - MenuItem.Bitmap.Height div 2;
              end
            else
              begin
                GX := MI.ImageRct.Left + RectWidth(MI.ImageRct) div 2 -
                      MenuItem.Bitmap.Width div 2;
                GY := MI.ImageRct.Top + RectHeight(MI.ImageRct) div 2 - MenuItem.Bitmap.Height div 2;
              end;

            if MenuItem.Checked
            then
              begin
                Brush.Style := bsClear;
                Pen.Color := Font.Color;
                Rectangle(GX - 1, GY - 1,
                          GX + MenuItem.Bitmap.Width + 1,
                          GY + MenuItem.Bitmap.Height + 1);
             end;
          end
        else
          begin
            if IsNullRect(MI.ImageRct)
            then
              begin
                GX := TR.Left + 2;
                GY := TR.Top + RectHeight(TR) div 2 - Parent.ImgL.Height div 2;
              end
            else
              begin
                GR := MI.ImageRct;
                GR.Bottom :=  B.Height - (RectHeight(MI.SkinRect) - MI.ImageRct.Bottom);
                //
                GX := GR.Left + RectWidth(GR) div 2 - Parent.ImgL.Width div 2;
                GY := GR.Top + RectHeight(GR) div 2 - Parent.ImgL.Height div 2;
              end;
            if MenuItem.Checked
            then
              begin
                Brush.Style := bsClear;
                Pen.Color := Font.Color;
                Rectangle(GX - 1, GY - 1,
                          GX + Parent.ImgL.Width + 1,
                          GY + Parent.ImgL.Height + 1);
             end;
           end;
      end
    else
      begin
        if IsNullRect(MI.ImageRct)
        then
          begin
            IY := TR.Top + RectHeight(TR) div 2 - 4;
            IX := TR.Left + 2;
          end
        else
          begin
            GR := MI.ImageRct;
            GR.Bottom :=  B.Height - (RectHeight(MI.SkinRect) - MI.ImageRct.Bottom);
            IY := GR.Top + RectHeight(GR) div 2 - 4;
            IX := GR.Left + RectWidth(GR) div 2 - 4
          end;

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
            begin
              if IsNullRect(MI.RadioImageRect)
              then
                DrawRadioImage(B.Canvas,
                               IX, IY + 1,
                               B.Canvas.Font.Color)
              else
                begin
                  if not IsNullRect(MI.ImageRct)
                  then
                    begin
                      GR := MI.ImageRct;
                      GR.Bottom :=  B.Height - (RectHeight(MI.SkinRect) - MI.ImageRct.Bottom);
                      DR := GR;
                    end
                  else
                    DR := Rect(MI.TextRct.Left + 2, MI.TextRct.Top, MI.TextRct.Left + 16,
                      MI.TextRct.Bottom);
                  DrawSkinRadioImage(B.Canvas, DR,  AActive);
                end;

            end
          else
            begin
              if IsNullRect(MI.RadioImageRect)
              then
                DrawCheckImage(B.Canvas,
                              IX, IY,
                               B.Canvas.Font.Color)
              else
                begin
                  if not IsNullRect(MI.ImageRct)
                  then
                    begin
                      GR := MI.ImageRct;
                      GR.Bottom :=  B.Height - (RectHeight(MI.SkinRect) - MI.ImageRct.Bottom);
                      DR := GR;
                    end
                  else
                    DR := Rect(MI.TextRct.Left + 2, MI.TextRct.Top, MI.TextRct.Left + 16,
                      MI.TextRct.Bottom);
                   DrawSkinCheckImage(B.Canvas, DR, AActive);
                end;  
            end;                 
      end;
  end;
  //
  if DrawGlyph
  then
    if not MenuItem.Bitmap.Empty
    then
      B.Canvas.Draw(GX, GY, MenuItem.BitMap)
    else
      Parent.ImgL.Draw(B.Canvas, GX, GY,
        MenuItem.ImageIndex, MenuItem.Enabled);
end;


function GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectHeight(MI.AnimateSkinRect) > RectHeight(MI.SkinRect)
  then
    begin
      fs := RectHeight(MI.AnimateSkinRect) div MI.FrameCount;
      Result := Rect(MI.AnimateSkinRect.Left,
                     MI.AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     MI.AnimateSkinRect.Right,
                     MI.AnimateSkinRect.Top + CurrentFrame * fs);
    end
  else
    begin
      fs := RectWidth(MI.AnimateSkinRect) div MI.FrameCount;
      Result := Rect(MI.AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 MI.AnimateSkinRect.Top,
                 MI.AnimateSkinRect.Left + CurrentFrame * fs,
                 MI.AnimateSkinRect.Bottom);
    end;
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
       RectWidth(ObjectRect), RectHeight(ObjectRect), MI.DividerStretchEffect);
    end   
  else
    begin
      AD := Active or Down;
      if EnableAnimation and  
      (CurrentFrame >= 1) and (CurrentFrame <= MI.FrameCount)
      then
        begin
          SpecRect := GetAnimationFrameRect;
          CreateItemImage(B, AD, True);
        end
      else
      if not EnableMorphing or
      ((AD and (MorphKf = 1)) or (not AD and (MorphKf  = 0)))
      then
        CreateItemImage(B, AD, False)
      else
        begin
          CreateItemImage(B, False, False);
          AB := TBitMap.Create;
          CreateItemImage(AB, True, False);
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
          EffB.Draw(B.Canvas.Handle, 0, 0);
          AB.Free;
          EffB.Free;
          EffAB.Free;
        end;
    end;
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, B);
  B.Free;
end;


procedure TspSkinMenuItem.Draw;
var
  GX, GY: Integer;
  DrawGlyph: Boolean;
  EB1: TspEffectBmp;
  kf: Double;
  SpecRect: TRect;


procedure DrawGroupCaptionItem(Cnvs: TCanvas; R: TRect; Caption: WideString);
var
  LData: TspDataSkinLabelControl;
  I: Integer;
  Buffer: TBitmap;
  Picture: TBitMap;
  LO, RO: Integer;
  R1: TRect;
begin
  if (Parent.PW <> nil)
  then
    begin
      I := Parent.SD.GetControlIndex('menuheader');
      if I = -1
      then
        I := Parent.SD.GetControlIndex('label');
      if I <> -1
      then
        begin
          LData := TspDataSkinLabelControl(Parent.SD.CtrlList[I]);
          Picture := Parent.SD.FActivePictures[LData.PictureIndex];
          Buffer := TBitMap.Create;
          with LData do
          CreateHSkinImage(LTPoint.X, RectWidth(SkinRect) - RTPoint.X,
            Buffer, Picture, SkinRect, RectWidth(R), RectHeight(SkinRect), StretchEffect);
          // caption
          with Buffer.Canvas do
          begin
            Font.Color := LData.FontColor;
            Font.Name := LData.FontName;
            Font.Height := LData.FontHeight;
            Font.Charset := Cnvs.Font.Charset;
            Brush.Style := bsClear;
            Delete(Caption, 1, 1);
            Delete(Caption, Length(Caption), 1);
          end;
          R1 := Rect(0, LData.ClRect.Top, Buffer.Width,
                     Buffer.Height);
          //
          if (Buffer.Canvas.Font.Height div 2) <> (Buffer.Canvas.Font.Height / 2) then Dec(R1.Top, 1);
          //
          SPDrawSkinText(Buffer.Canvas, Caption, R1,
            Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
          //
          Cnvs.Draw(R.Left, R.Top + RectHeight(R) div 2 - Buffer.Height div 2,
                    Buffer);
          Buffer.Free;
        end;
    end;
end;

procedure CreateItemImage(B: TBitMap; AActive: Boolean; FromSpecRect: Boolean);
var
  DR, R, TR, SR, Rct: TRect;
  TextOffset: Integer;
  MIShortCut, S: WideString;
  IX, IY: Integer;
  SE: Boolean;
begin

  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(TTNTMenuItem(MenuItem).ShortCut)
      else
        MIShortCut := '';
     end
  else
    begin
      if MenuItem.ShortCut <> 0
      then
        MIShortCut := ShortCutToText(MenuItem.ShortCut)
      else
        MIShortCut := '';
    end;
  {$ELSE}
  if MenuItem.ShortCut <> 0
  then
    MIShortCut := ShortCutToText(MenuItem.ShortCut)
  else
    MIShortCut := '';
  {$ENDIF}


  if AActive
  then
    begin
      Rct := MI.ActiveSkinRect;
      SE := MI.StretchEffect;
    end
  else
    begin
      Rct := MI.SkinRect;
      SE := MI.InActiveStretchEffect;
      if not MI.InActiveStretchEffect and MI.StretchEffect
      then
        SE := MI.StretchEffect and FromSpecRect;
    end;

  if FromSpecRect then Rct := SpecRect;


  if not AACtive and MI.InActiveTransparent and
     (Parent.FPaintBuffer <> nil)
  then
    begin
      B.Width := RectWidth(ObjectRect);
      B.Height := RectHeight(ObjectRect);
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
      Parent.FPaintBuffer.Canvas, ObjectRect);
    end
  else
   CreateHSkinImage(MI.ItemLO, MI.ItemRO,
     B, ActivePicture, Rct,
     RectWidth(ObjectRect), RectHeight(ObjectRect), SE);


  if Parent.ImgL = nil
  then TextOffset := 16
  else TextOffset := Parent.GlyphWidth;

  if not IsNullRect(MI.ImageRct) then TextOffset := 0; 

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
    if Assigned(MenuItem.OnDrawItem)
    then
      begin
        MenuItem.OnDrawItem(Self, B.Canvas, TR, AActive);
        Exit;
      end;
    //
    {$IFDEF TNTUNICODE}
    if MenuItem is TTntMenuItem
    then
      S := TTntMenuItem(MenuItem).Caption
    else
      S := MenuItem.Caption;
    {$ELSE}
     S := MenuItem.Caption;
    {$ENDIF}
    //
    if (Length(S) > 0) and (S[1] = '-') and (S[Length(S)] = '-') and not MenuItem.Enabled
    then
      begin
        DrawGroupCaptionItem(B.Canvas, Rect(0, 0, B.Width, B.Height), S);
        Exit;
      end;
    //
    R := Rect(TR.Left + TextOffset, 0, TR.Right - 16, 0);
    SPDrawSkinText(B.Canvas, S, R, DT_CALCRECT);
    OffsetRect(R, 0, TR.Top + RectHeight(TR) div 2 - R.Bottom div 2);
    Inc(R.Right, 2);
    //
    if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(R.Top, 1);
    //
    SPDrawSkinText(B.Canvas, S, R,
      Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
    // shortcut
    if MIShortCut <> ''
    then
      begin
        SR := Rect(0, 0, 0, 0);
        SPDrawSkinText(B.Canvas, MIShortCut, SR, DT_CALCRECT);
        SR := Rect(TR.Right - SR.Right - 16, R.Top, TR.Right - 16, R.Bottom);
        //
        if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(SR.Top, 1);
        //
        SPDrawSkinText(B.Canvas,  MIShortCut, SR,
         Parent.ParentMenu.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
      end;
    //
    if MenuItem.Count <> 0
    then
      begin
        if IsNullRect(MI.ArrowImageRect)
        then
          DrawSubImage(B.Canvas,
                     TR.Right - 7, TR.Top + RectHeight(TR) div 2 - 4,
                     B.Canvas.Font.Color)
        else
          DrawSkinArrowImage(B.Canvas,
                             Rect(TR.Right - RectWidth(MI.ArrowImageRect) - 5,
                             TR.Top, TR.Right, TR.Bottom),
                             AActive);
      end;
    //
    DrawGlyph := (not MenuItem.Bitmap.Empty) or
       ((Parent.ImgL <> nil) and (MenuItem.ImageIndex > -1) and
       (MenuItem.ImageIndex < Parent.ImgL.Count));

    if MI.UseImageColor
    then
    begin
      if AActive
      then
        Font.Color := MI.ActiveImageColor
      else
        Font.Color := MI.ImageColor;
    end;

    if DrawGlyph
    then
      begin
        if not MenuItem.Bitmap.Empty
        then
          begin
            if IsNullRect(MI.ImageRct)
            then
              begin
                GX := TR.Left + 2;
                GY := TR.Top + RectHeight(TR) div 2 - MenuItem.Bitmap.Height div 2;
              end
            else
              begin
                GX := MI.ImageRct.Left + RectWidth(MI.ImageRct) div 2 -
                      MenuItem.Bitmap.Width div 2;
                GY := MI.ImageRct.Top + RectHeight(MI.ImageRct) div 2 - MenuItem.Bitmap.Height div 2;
              end;

            if MenuItem.Checked
            then
              begin
                Brush.Style := bsClear;
                Pen.Color := Font.Color;
                Rectangle(GX - 1, GY - 1,
                          GX + MenuItem.Bitmap.Width + 1,
                          GY + MenuItem.Bitmap.Height + 1);
             end;
          end
        else
          begin
             if IsNullRect(MI.ImageRct)
            then
              begin
                GX := TR.Left + 2;
                GY := TR.Top + RectHeight(TR) div 2 - Parent.ImgL.Height div 2;
              end
            else
              begin
                GX := MI.ImageRct.Left + RectWidth(MI.ImageRct) div 2 -
                       Parent.ImgL.Width div 2;
                GY := MI.ImageRct.Top + RectHeight(MI.ImageRct) div 2 - Parent.ImgL.Height div 2;
              end;
            if MenuItem.Checked
            then
              begin
                Brush.Style := bsClear;
                Pen.Color := Font.Color;
                Rectangle(GX - 1, GY - 1,
                          GX + Parent.ImgL.Width + 1,
                          GY + Parent.ImgL.Height + 1);
             end;
           end;
      end
    else
      begin
        if IsNullRect(MI.ImageRct)
        then
          begin
            IY := TR.Top + RectHeight(TR) div 2 - 4;
            IX := TR.Left + 2;
          end
        else
          begin
            IY := MI.ImageRct.Top + RectHeight(MI.ImageRct) div 2 - 4;
            IX := MI.ImageRct.Left + RectWidth(MI.ImageRct) div 2 - 4
          end;
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
            begin
              if IsNullRect(MI.RadioImageRect)
              then
                DrawRadioImage(B.Canvas,
                               IX, IY + 1,
                               B.Canvas.Font.Color)
              else
                begin
                  if not IsNullRect(MI.ImageRct)
                  then
                    DR := MI.ImageRct
                  else
                    DR := Rect(MI.TextRct.Left + 2, MI.TextRct.Top, MI.TextRct.Left + 16,
                      MI.TextRct.Bottom);
                  DrawSkinRadioImage(B.Canvas, DR,  AActive);
                end;

            end
          else
            begin
              if IsNullRect(MI.RadioImageRect)
              then
                DrawCheckImage(B.Canvas,
                              IX, IY,
                               B.Canvas.Font.Color)
              else
                begin
                  if not IsNullRect(MI.ImageRct)
                  then
                    DR := MI.ImageRct
                  else
                    DR := Rect(MI.TextRct.Left + 2, MI.TextRct.Top, MI.TextRct.Left + 16,
                      MI.TextRct.Bottom);
                   DrawSkinCheckImage(B.Canvas, DR, AActive);
                end;  
            end;
      end;
  end;
  //
  if DrawGlyph
  then
    if not MenuItem.Bitmap.Empty
    then
      B.Canvas.Draw(GX, GY, MenuItem.BitMap)
    else
      Parent.ImgL.Draw(B.Canvas, GX, GY,
        MenuItem.ImageIndex, MenuItem.Enabled);
end;


function GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectHeight(MI.AnimateSkinRect) > RectHeight(MI.SkinRect)
  then
    begin
      fs := RectHeight(MI.AnimateSkinRect) div MI.FrameCount;
      Result := Rect(MI.AnimateSkinRect.Left,
                     MI.AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     MI.AnimateSkinRect.Right,
                     MI.AnimateSkinRect.Top + CurrentFrame * fs);
    end
  else
    begin
      fs := RectWidth(MI.AnimateSkinRect) div MI.FrameCount;
      Result := Rect(MI.AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 MI.AnimateSkinRect.Top,
                 MI.AnimateSkinRect.Left + CurrentFrame * fs,
                 MI.AnimateSkinRect.Bottom);
    end;
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

  if (Parent <> nil) and (Parent.ParentMenu <> nil) and
      not Parent.ParentMenu.UseSkinSize
  then
    begin
      ResizeDraw(Cnvs);
      Exit;
    end;

  B := TBitMap.Create;
  if MenuItem.Caption = '-'
  then
    begin
      CreateHSkinImage(MI.DividerLO, MI.DividerRO,
        B, ActivePicture, MI.DividerRect,
        RectWidth(ObjectRect), RectHeight(ObjectRect), MI.DividerStretchEffect);
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
      if EnableAnimation and
      (CurrentFrame >= 1) and (CurrentFrame <= MI.FrameCount)
      then
        begin
          SpecRect := GetAnimationFrameRect;
          CreateItemImage(B, AD, True);
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
      if not EnableMorphing or
      ((AD and (MorphKf = 1)) or (not AD and (MorphKf  = 0)))
      then
        begin
          CreateItemImage(B, AD, False);
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
          CreateItemImage(B, False, False);
          AB := TBitMap.Create;
          CreateItemImage(AB, True, False);
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

  FPaintBuffer := nil;

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
  Scroll2 := False;
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
  if FPaintBuffer <> nil then FPaintBuffer.Free;
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
  if PW <> nil then DrawScrollArea(Cnvs, R);
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
  if PW <> nil then DrawScrollArea(Cnvs, R);
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
            PW := TspSkinPopupWindow(ParentMenu.FPopupList.Items[ParentMenu.FPopupList.Count - 2]);
            if PW.ActiveItem <> -1
            then
              TspSkinMenuItem(PW.ItemList.Items[PW.ActiveItem]).Down := False;
            ParentMenu.CloseMenu(ParentMenu.FPopupList.Count - 1);
          end
      end;
    VK_ESCAPE:
      begin
        if ParentMenu.FPopupList.Count > 1
        then
          begin
            PW := TspSkinPopupWindow(ParentMenu.FPopupList.Items[ParentMenu.FPopupList.Count - 2]);
            if PW.ActiveItem <> -1
            then
              TspSkinMenuItem(PW.ItemList.Items[PW.ActiveItem]).Down := False;
          end;
        ParentMenu.CloseMenu(ParentMenu.FPopupList.Count - 1);
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
        if EnableAnimation and not MI.InActiveAnimation
        then
          begin
            CurrentFrame := 0;
            Draw(Canvas);
          end
        else
          ReDraw;
      end;
end;

procedure TspSkinPopupWindow.DrawScrollArea(Cnvs: TCanvas; R: TRect);
var
  Buffer, Buffer2: TBitMap;
  MI: TspDataSkinMenuItem;
  I: Integer;
  ActivePicture: TBitMap;
begin
  I := SD.GetIndex('menuitem');
  if I = -1 then SD.GetIndex('MENUITEM');
  if I = -1 then Exit;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  MI := TspDataSkinMenuItem(SD.ObjectList[I]);
  ActivePicture := TBitMap(SD.FActivePictures.Items[MI.ActivePictureIndex]);
  if DSMI.InActiveTransparent and (FPaintBuffer <> nil)
  then
    begin
      Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
       FPaintBuffer.Canvas, R);
    end
  else
  CreateHSkinImage(MI.ItemLO, MI.ItemRO,
    Buffer, ActivePicture, MI.SkinRect,
   RectWidth(R), RectHeight(MI.SkinRect), MI.InActiveStretchEffect);
  Buffer.Height := RectHeight(R);
  Cnvs.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
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
      if EnableMorphing and CanMorphing
      then
        begin
          DoMorphing;
          StopMorph := False;
        end
      else
      if EnableAnimation
      then
        begin
          if Active and (CurrentFrame <= MI.FrameCount)
            then
              begin
                Inc(CurrentFrame);
                Draw(Canvas);
                StopMorph := False;
              end
            else
            if not Active and (CurrentFrame > 0)
            then
              begin
                Dec(CurrentFrame);
                Draw(Canvas);
                StopMorph := False;
              end;
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

function TspSkinPopupWindow.GetItemHeight: Integer;
begin
  if ParentMenu.UseSkinSize
  then
    Result := RectHeight(DSMI.SkinRect)
  else
    Result := ParentMenu.DefaultMenuItemHeight;
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
      Width, Height, ADrawClient,
      PW.LeftStretch, PW.TopStretch,
      PW.RightStretch, PW.BottomStretch, PW.StretchEffect, PW.StretchType)
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
    MICaption: WideString;
  begin
   if Item.ShortCut <> 0
   then
     MICaption := Item.Caption + '  ' + ShortCutToText(Item.ShortCut)
   else
     MICaption := Item.Caption;
    R := Rect(0, 0, 0, 0);
    SPDrawSkinText(Canvas, MICaption, R, DT_CALCRECT);
    Result := R.Right + 2;
  end;

  function GetMenuWindowHeight: Integer;
  var
    i, j, k, ih: integer;
  begin
    j := 0;
    k := 0;
    for i := VisibleStartIndex to VisibleCount - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
      if PW <> nil
      then
        begin
          if MenuItem.Caption = '-'
          then ih := RectHeight(DSMI.DividerRect)
          else ih := GetItemHeight;
        end
      else
        begin
          if MenuItem.Caption = '-'
          then ih := 4
          else ih := ParentMenu.DefaultMenuItemHeight;
        end;
      inc(j, ih);
      inc(k);
    end;

    if (ParentMenu.MaxMenuItemsInWindow <> 0) and (ParentMenu.MaxMenuItemsInWindow < k)
    then
      begin
        if PW <> nil
        then
          ih := GetItemHeight
        else
          ih := ParentMenu.DefaultMenuItemHeight;
        j := ParentMenu.MaxMenuItemsInWindow * ih;
        if PW <> nil
        then
          Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
        else
          Result := j + 6;
        Result := Result + MarkerItemHeight * 2;
        Self.Scroll := True;
        Self.Scroll2 := True;
      end
    else
      begin
        if PW <> nil
        then
          Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
        else
          Result := j + 6;
      end;
      
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
  Scroll := False;
  Scroll2 := False;
  W := GetMenuWindowWidth;
  H := GetMenuWindowHeight;
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

  if (Menu <> nil) and (Menu.AutoLineReduction = maAutomatic)
  then
    Item.RethinkLines;

  if Menu <> nil
  then
    ImgL := Menu.Images
  else
    ImgL := nil;

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
    MICaption: WideString;
  begin
   if Item.ShortCut <> 0
   then
     MICaption := Item.Caption + '  ' + ShortCutToText(Item.ShortCut)
   else
     MICaption := Item.Caption;
    R := Rect(0, 0, 0, 0);
    SPDrawSkinText(Canvas, MICaption, R, DT_CALCRECT);
    Result := R.Right + 2;
  end;

  function GetMenuWindowHeight: Integer;
  var
    i, j, k, ih: integer;
  begin
    j := 0;
    k := 0;
    for i := VisibleStartIndex to VisibleCount - 1 do
    with TspSkinMenuItem(ItemList.Items[i]) do
     begin
      if PW <> nil
      then
        begin
          if MenuItem.Caption = '-'
          then ih := RectHeight(DSMI.DividerRect)
          else ih := GetItemHeight;
        end
      else
        begin
          if MenuItem.Caption = '-'
          then ih := 4
          else ih := ParentMenu.DefaultMenuItemHeight;
        end;
      inc(j, ih);
      inc(k)
    end;
    if (ParentMenu.MaxMenuItemsInWindow <> 0) and (ParentMenu.MaxMenuItemsInWindow < k)
    then
      begin
        if PW <> nil
        then
          ih := GetItemHeight
        else
          ih := ParentMenu.DefaultMenuItemHeight;
        j := ParentMenu.MaxMenuItemsInWindow * ih;
        if PW <> nil
        then
          Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
        else
          Result := j + 6;
        Result := Result + MarkerItemHeight * 2;
        Self.Scroll := True;
        Self.Scroll2 := True;
      end
    else
      begin
        if PW <> nil
        then
          Result := j + PW.ItemsRect.Top + (WindowPicture.Height - PW.ItemsRect.Bottom)
        else
          Result := j + 6;
      end;
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
  Scroll := False;
  Scroll2 := False;
  W := GetMenuWindowWidth;
  H := GetMenuWindowHeight;
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

  if (Menu <> nil) and (Menu.AutoLineReduction = maAutomatic)
  then
    Item.RethinkLines;

  if Menu <> nil
  then
    ImgL := Menu.Images
  else
    ImgL := nil;

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
           else ih := GetItemHeight;
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
          then
            ih := RectHeight(DSMI.DividerRect)
          else
            ih := GetItemHeight;
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
    if Scroll and not Scroll2
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
    if PopupByItem or (Scroll and not Scroll2) or ChangeY
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
  TickCount: DWORD;
  AnimationStep: Integer;
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
          TickCount := 0;
          i := 0;
          ABV := ParentMenu.AlphaBlendValue;
          AnimationStep := ABV div 15;
          if AnimationStep = 0 then AnimationStep := 1;
          repeat
            if (GetTickCount - TickCount > 5)
            then
              begin
                TickCount := GetTickCount;
                 Inc(i, AnimationStep );
                 if i > ABV then i := ABV;
                 SetAlphaBlendTransparent(Handle, i);
              end;
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
    if Scroll and not Scroll2
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
    if PopupByItem or (Scroll and not Scroll2) or ChangeY
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
  TickCount: DWORD;
  AnimationStep: Integer; 
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
          TickCount := 0;
          ABV := ParentMenu.AlphaBlendValue;
          AnimationStep  := ABV div 15;
          if AnimationStep = 0 then AnimationStep := 1;
          repeat
            if (GetTickCount - TickCount > 5)
            then
              begin
                TickCount := GetTickCount;
                Inc(i, AnimationStep);
                if i > ABV then i := ABV;
                SetAlphaBlendTransparent(Handle, i);
              end;
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
  Y: Integer;
  R: TRect;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  B := TBitMap.Create;
  CreateRealImage(B, Scroll);
  if (PW <> nil) and (DSMI <> nil)
  then
    begin
      if DSMI.InActiveTransparent
      then
        begin
          if FPaintBuffer <> nil then FPaintBuffer.Free;
          FPaintBuffer := TBitMap.Create;
          CreateRealImage(FPaintBuffer, True);
        end;
    end;
  for i := VisibleStartIndex to VisibleStartIndex + VisibleCount - 1 do
  begin
    TspSkinMenuItem(ItemList.Items[i]).Draw(B.Canvas);
    Y := TspSkinMenuItem(ItemList.Items[i]).ObjectRect.Bottom;
  end;
  // markers
  if Scroll
  then
    begin
      DrawUpMarker(B.Canvas);
      DrawDownMarker(B.Canvas);
      R := Rect(NewItemsRect.Left, NewItemsRect.Bottom - MarkerItemHeight,
            NewItemsRect.Right, NewItemsRect.Bottom);
      if R.Top > Y
      then
        begin
          DrawScrollArea(B.Canvas, Rect(R.Left, Y, R.Right, R.Top));
        end;
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
  MaxMenuItemsInWindow := 0;
  FUseSkinFont := True;
  FUseSkinSize := True;
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
    Name := 'Tahoma';
    Style := [];
    Height := 13;
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
      if Assigned(FOnMenuClose) then FOnMenuClose(Self);
      FOnMenuClose := nil;
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
  FOnMenuClose := nil;
  FComponentForm := nil;
  FSD := nil;
  FSkinComponent := nil;
  FPopupPoint := Point(-1,-1);
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
  if FSkinComponent <> nil
  then
    begin
      DSF := TspDynamicSkinForm(FSkinComponent);
    end
  else
  if FComponentForm = nil
  then
    begin
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
      if (DSF <> nil) and (DSF.FForm.FormStyle = fsMDIChild)
      then
        DSF := FindDSFComponent(Application.MainForm);
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
      if DSF.SkinMenu.Visible then DSF.SkinMenuClose;
      FPopupPoint := Point(R.Left, R.Top);
      DSF.SkinMenuOpen;
      DSF.SkinMenu.Popup(nil, FSD, 0, R, Items, APopupUp);
      if Assigned(FOnMenuClose)
      then
        DSF.SkinMenu.OnMenuClose := Self.FOnMenuClose;
    end;
end;

procedure TspSkinPopupMenu.Popup;
var
  DSF: TspDynamicSkinForm;
var
  R: TRect;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FSkinComponent <> nil
  then
    begin
      DSF := TspDynamicSkinForm(FSkinComponent);
    end
  else
  if FComponentForm = nil
  then
    begin
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
      if (DSF <> nil) and (DSF.FForm.FormStyle = fsMDIChild)
      then
        DSF := FindDSFComponent(Application.MainForm);
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
      if DSF.SkinMenu.Visible then DSF.SkinMenuClose;
      DSF.SkinMenuOpen;
      R := Rect(X, Y, X, Y);
      FPopupPoint := Point(R.Left, R.Top);
      DSF.SkinMenu.Popup(nil, FSD, 0, R, Items, False);
      if Assigned(FOnMenuClose)
      then
        DSF.SkinMenu.OnMenuClose := Self.FOnMenuClose;
    end;
end;

procedure TspSkinPopupMenu.PopupFromRect2;
var
  DSF: TspDynamicSkinForm;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FSkinComponent <> nil
  then
    begin
      DSF := TspDynamicSkinForm(FSkinComponent);
    end
  else
  if FComponentForm = nil
  then
    begin
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
      if (DSF <> nil) and (DSF.FForm.FormStyle = fsMDIChild)
      then
        DSF := FindDSFComponent(Application.MainForm);
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
      if DSF.SkinMenu.Visible then DSF.SkinMenuClose;
      DSF.SkinMenuOpen;
      FPopupPoint := Point(R.Left, R.Top);
      DSF.SkinMenu.Popup(ACtrl, FSD, 0, R, Items, APopupUp);
      if Assigned(FOnMenuClose)
      then
        DSF.SkinMenu.OnMenuClose := Self.FOnMenuClose;
    end;
end;

procedure TspSkinPopupMenu.Popup2;
var
  R: TRect;
  DSF: TspDynamicSkinForm;
begin
  if Assigned(OnPopup) then OnPopup(Self);
  if FSkinComponent <> nil
  then
    begin
      DSF := TspDynamicSkinForm(FSkinComponent);
    end
  else
  if FComponentForm = nil
  then
    begin
      if Owner.InheritsFrom(TForm) then
        DSF := FindDSFComponent(TForm(Owner)) else
         if Owner.Owner.InheritsFrom(TForm) then
         DSF := FindDSFComponent(TForm(Owner.Owner)) else
           DSF := nil;
      if (DSF <> nil) and (DSF.FForm.FormStyle = fsMDIChild)
      then
        DSF := FindDSFComponent(Application.MainForm);
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
      if DSF.SkinMenu.Visible then DSF.SkinMenuClose;
      DSF.SkinMenuOpen;
      R := Rect(X, Y, X, Y);
      FPopupPoint := Point(R.Left, R.Top);
      DSF.SkinMenu.Popup(ACtrl, FSD, 0, R, Items, False);
      if Assigned(FOnMenuClose)
      then
        DSF.SkinMenu.OnMenuClose := Self.FOnMenuClose;
    end;
end;

// TspSkinImagesMenu ===========================================================

constructor TspImagesMenuItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FCaption := '';
  FButton := False;
  FHint := '';
  FHeader := False; 
end;

procedure TspImagesMenuItem.Assign(Source: TPersistent);
begin
  if Source is TspImagesMenuItem then
  begin
    FImageIndex := TspImagesMenuItem(Source).ImageIndex;
    FCaption := TspImagesMenuItem(Source).Caption;
    FButton := TspImagesMenuItem(Source).Button;
    FHint := TspImagesMenuItem(Source).Hint;
  end
  else
    inherited Assign(Source);
end;

procedure TspImagesMenuItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
end;

procedure TspImagesMenuItem.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

constructor TspImagesMenuItems.Create;
begin
  inherited Create(TspImagesMenuItem);
  ImagesMenu := AImagesMenu;
end;

function TspImagesMenuItems.GetOwner: TPersistent;
begin
  Result := ImagesMenu;
end;

function TspImagesMenuItems.GetItem(Index: Integer):  TspImagesMenuItem;
begin
  Result := TspImagesMenuItem(inherited GetItem(Index));
end;

procedure TspImagesMenuItems.SetItem(Index: Integer; Value:  TspImagesMenuItem);
begin
  inherited SetItem(Index, Value);
end;

constructor TspSkinImagesMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImagesItems := TspImagesMenuItems.Create(Self);
  FShowHints := True;
  FItemIndex := -1;
  FColumnsCount := 1;
  FSkinHint := nil;
  FOnItemClick := nil;
  FSkinData := nil;
  FPopupWindow := nil;
  FShowSelectedItem := True;
  FAlphaBlend := False;
  FAlphaBlendValue := 200;
  FAlphaBlendAnimation := False;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FUseSkinFont := True;
end;

function TspSkinImagesMenu.GetSelectedItem;
begin
  if (ItemIndex >=0) and (ItemIndex < FImagesItems.Count)
  then
    Result := FImagesItems[ItemIndex]
  else
    Result := nil;
end;

procedure TspSkinImagesMenu.SetSkinData;
begin
  FSkinData := Value;
end;

destructor TspSkinImagesMenu.Destroy;
begin
  if FPopupWindow <> nil then FPopupWindow.Free;
  FDefaultFont.Free;
  FImagesItems.Free;
  inherited Destroy;
end;

procedure TspSkinImagesMenu.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;


procedure TspSkinImagesMenu.SetColumnsCount(Value: Integer);
begin
  if (Value > 0) and (Value < 51)
  then
    FColumnsCount := Value;
end;

procedure TspSkinImagesMenu.SetImagesItems(Value: TspImagesMenuItems);
begin
  FImagesItems.Assign(Value);
end;

procedure TspSkinImagesMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
  if (Operation = opRemove) and (AComponent = SkinData) then
    SkinData := nil;
  if (Operation = opRemove) and (AComponent = FSkinHint) then
    FSkinHint := nil;
end;

procedure TspSkinImagesMenu.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TspSkinImagesMenu.Popup(X, Y: Integer);
begin
  if FPopupWindow <> nil then FPopupWindow.Hide(False);

  if Assigned(FOnMenuPopup) then FOnMenuPopup(Self);

  if (FImages = nil) or (FImages.Count = 0) then Exit;
  FOldItemIndex := ItemIndex;
  FPopupWindow := TspSkinImagesMenuPopupWindow.Create(Self);
  FPopupWindow.Show(Rect(X, Y, X, Y));
end;

procedure TspSkinImagesMenu.PopupFromRect(R: TRect);
begin
  if FPopupWindow <> nil then FPopupWindow.Hide(False);

  if Assigned(FOnMenuPopup) then FOnMenuPopup(Self);

  if (FImages = nil) or (FImages.Count = 0) then Exit;
  FOldItemIndex := ItemIndex;
  FPopupWindow := TspSkinImagesMenuPopupWindow.Create(Self);
  FPopupWindow.Show(R);
end;

procedure TspSkinImagesMenu.ProcessEvents;
begin
  if FPopupWindow = nil then Exit;
  FPopupWindow.Free;
  FPopupWindow := nil;

  if Assigned(FOnInternalMenuClose)
  then
    FOnInternalMenuClose(Self);

  if Assigned(FOnMenuClose)
  then
    FOnMenuClose(Self);

  if ACanProcess and (ItemIndex <> -1)
  then
   begin
      if Assigned(FImagesItems[ItemIndex].OnClick)
      then
        FImagesItems[ItemIndex].OnClick(Self);
      if Assigned(FOnItemClick) then FOnItemClick(Self);

      if (FOldItemIndex <> ItemIndex) and
         Assigned(FOnInternalChange) then FOnInternalChange(Self);

      if (FOldItemIndex <> ItemIndex) and
         Assigned(FOnChange) then FOnChange(Self);
    end;
end;

procedure TspSkinImagesMenu.Hide;
begin
  if FPopupWindow <> nil then FPopupWindow.Hide(False);
end;

constructor TspSkinImagesMenuPopupWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  ImagesMenu := TspSkinImagesMenu(AOwner);
  FRgn := 0;
  WindowPicture := nil;
  MaskPicture := nil;
  FSkinSupport := False;
  MouseInItem := -1;
  OldMouseInItem := -1;
  FDown := False;
  FItemDown := False;
end;

destructor TspSkinImagesMenuPopupWindow.Destroy;
begin
  inherited Destroy;
  if FRgn <> 0 then DeleteObject(FRgn);
end;

procedure TspSkinImagesMenuPopupWindow.FindUp;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := ImagesMenu.ImagesItems.Count  - 1;
    RePaint;
    Exit;
  end;
  for I := MouseInItem - 1 downto 0 do
  if not ImagesMenu.ImagesItems[I].Header
  then
   begin
   if  (ImagesMenu.ImagesItems[I].ItemRect.Top <
        ImagesMenu.ImagesItems[MouseInItem].ItemRect.Top) and
      (ImagesMenu.ImagesItems[I].Button or
       (ImagesMenu.ImagesItems[I].ItemRect.Left =
        ImagesMenu.ImagesItems[MouseInItem].ItemRect.Left))
    then
      begin
        MouseInItem := I;
        RePaint;
        Break;
      end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.FindDown;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := 0;
    if (ImagesMenu.ImagesItems[MouseInItem].Header)
    then
      Inc(MouseInItem);
    RePaint;
    Exit;
  end;

  for I := MouseInItem + 1 to ImagesMenu.ImagesItems.Count - 1 do
  if not ImagesMenu.ImagesItems[I].Header
  then
  begin
    if (ImagesMenu.ImagesItems[I].ItemRect.Top >
       ImagesMenu.ImagesItems[MouseInItem].ItemRect.Top) and
       (ImagesMenu.ImagesItems[I].Button or
       (ImagesMenu.ImagesItems[I].ItemRect.Left =
        ImagesMenu.ImagesItems[MouseInItem].ItemRect.Left))
     then
      begin
        MouseInItem := I;
        RePaint;
        Break;
      end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.FindRight;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := 0;
    if (ImagesMenu.ImagesItems[MouseInItem].Header)
    then
      Inc(MouseInItem);
    RePaint;
    Exit;
  end
  else
  if MouseInItem = ImagesMenu.ImagesItems.Count  - 1
  then
    begin
      MouseInItem := 0;
      if (ImagesMenu.ImagesItems[MouseInItem].Header)
      then
        Inc(MouseInItem);
      RePaint;
      Exit;
    end;
  for I := MouseInItem + 1 to ImagesMenu.ImagesItems.Count - 1 do
  if not ImagesMenu.ImagesItems[I].Header
  then
  begin
    MouseInItem := I;
    RePaint;
    Break;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.FindLeft;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := ImagesMenu.ImagesItems.Count  - 1;
    RePaint;
    Exit;
  end
  else
  if (MouseInItem = 0) or ((ImagesMenu.ImagesItems[0].Header) and
     (ImagesMenu.ImagesItems.Count > 1) and (MouseInItem = 1))
  then
    begin
      MouseInItem := ImagesMenu.ImagesItems.Count  - 1;
      RePaint;
      Exit;
    end;
  for I := MouseInItem - 1 downto 0 do
  if not ImagesMenu.ImagesItems[I].Header
  then
  begin
    MouseInItem := I;
    RePaint;
    Break;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.ProcessKey(KeyCode: Integer);
begin
  case KeyCode of
   VK_ESCAPE: Self.Hide(False);
   VK_RETURN, VK_SPACE:
    begin
      if MouseInItem <> -1
      then
        ImagesMenu.ItemIndex := MouseInItem;
      Self.Hide(True);
    end;
    VK_RIGHT: FindRight;
    VK_LEFT: FindLeft;
    VK_UP: FindUp;
    VK_DOWN: FindDown;
  end;
end;

function TspSkinImagesMenuPopupWindow.GetLabelDataControl: TspDataSkinLabelControl;
var
  I: Integer;
begin
  if (ImagesMenu.SkinData = nil) or
     (ImagesMenu.SkinData.Empty)
  then
    begin
      Result := nil;
      Exit;
    end;
  I := ImagesMenu.SkinData.GetControlIndex('label');
  if I <> -1
  then
    Result := TspDataSkinLabelControl(ImagesMenu.SkinData.CtrlList[I])
  else
    Result := nil;
end;

procedure TspSkinImagesMenuPopupWindow.WMEraseBkGrnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

function TspSkinImagesMenuPopupWindow.GetItemFromPoint;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;
  for I := 0 to ImagesMenu.ImagesItems.Count - 1 do
  if not ImagesMenu.ImagesItems[I].Header then
  begin
    R := GetItemRect(I);
    if PointInRect(R, P)
    then
      begin
        Result := i;
        Break;
      end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.AssignItemRects;
var
  I, W, X, Y,StartX, StartY: Integer;
  ItemWidth, ItemHeight: Integer;
  R: TRect;
  LabelData: TspDataSkinLabelControl;
begin
  LabelData := GetLabelDataControl;
  ItemWidth := ImagesMenu.FImages.Width + 10;
  ItemHeight := ImagesMenu.FImages.Height + 10;
  W := ItemWidth * ImagesMenu.ColumnsCount;
  if FSkinSupport
  then
    begin
      StartX := ImagesMenu.SkinData.PopupWindow.ItemsRect.Left;
      StartY := ImagesMenu.SkinData.PopupWindow.ItemsRect.Top;
    end
  else
    begin
      StartX := 5;
      StartY := 5;
    end;
  X := StartX;
  Y := StartY;
  for I := 0 to ImagesMenu.ImagesItems.Count - 1 do
  with ImagesMenu.ImagesItems[I] do
  begin
   if Header
   then
      begin
        if X <> StartX then Inc(Y, ItemHeight + 1);
        if LabelData <> nil
        then
          begin
            ItemRect := Rect(StartX, Y, StartX + W, Y + RectHeight(LabelData.SkinRect));
            Inc(Y, RectHeight(LabelData.SkinRect) + 1);
          end
        else
          begin
            ItemRect := Rect(StartX, Y, StartX + W, Y + ItemHeight);
            Inc(Y, ItemHeight + 1);
          end;
        X := StartX;
      end
    else
    if Button
    then
      begin
        if X <> StartX then Inc(Y, ItemHeight + 1);
        ItemRect := Rect(StartX, Y, StartX + W, Y + ItemHeight);
        Inc(Y, ItemHeight + 1);
        X := StartX;
      end
    else
      begin
        ItemRect := Rect(X, Y, X + ItemWidth, Y + ItemHeight);
        X := X + ItemWidth;
        if X + ItemWidth > StartX + W
        then
          begin
            X := StartX;
            Inc(Y, ItemHeight + 1);
          end;
      end;
  end;
end;


function TspSkinImagesMenuPopupWindow.GetItemRect(Index: Integer): TRect;
begin
  Result := ImagesMenu.ImagesItems[Index].ItemRect;
end;

procedure TspSkinImagesMenuPopupWindow.TestActive(X, Y: Integer);
begin
  MouseInItem := GetItemFromPoint(Point(X, Y));
  if (ImagesMenu.SkinHint <> nil) and
     (MouseInItem = -1)
  then
    ImagesMenu.SkinHint.HideHint;
  if (MouseInItem <> OldMouseInItem)
  then
    begin
      OldMouseInItem := MouseInItem;
      RePaint;
      if ImagesMenu.ShowHints and (MouseInItem <> -1) and (ImagesMenu.SkinHint <> nil)
      then
        begin
          ImagesMenu.SkinHint.HideHint;
          with ImagesMenu.ImagesItems[MouseInItem] do
          begin
            if Hint <> '' then ImagesMenu.SkinHint.ActivateHint2(Hint);
           end;
        end;
    end;
end;

procedure TspSkinImagesMenuPopupWindow.Show(PopupRect: TRect);

procedure CorrectMenuPos(var X, Y: Integer);
var
  WorkArea: TRect;
begin
   if (Screen.ActiveCustomForm <> nil)
  then
    begin
      WorkArea := GetMonitorWorkArea(Screen.ActiveCustomForm.Handle, True);
    end
  else
  if (Application.MainForm <> nil) and (Application.MainForm.Visible)
  then
    WorkArea := GetMonitorWorkArea(Application.MainForm.Handle, True)
  else
    WorkArea := GetMonitorWorkArea(TForm(ImagesMenu.Owner).Handle, True);
  if Y + Height > WorkArea.Bottom
  then
    Y := Y - Height - RectHeight(PopupRect);
  if X + Width > WorkArea.Right
  then
    X := X - ((X + Width) - WorkArea.Right);
  if X < WorkArea.Left then X := WorkArea.Left;
  if Y < WorkArea.Top then Y := WorkArea.Top;
end;

const
  WS_EX_LAYERED = $80000;

var
  ShowX, ShowY: Integer;
  I: Integer;
  TickCount: DWORD;
  AnimationStep: Integer;
begin
  CreateMenu;
  ShowX := PopupRect.Left;
  ShowY := PopupRect.Bottom;
  CorrectMenuPos(ShowX, ShowY);

  if CheckW2KWXP and ImagesMenu.AlphaBlend
  then
    begin
      SetWindowLong(Handle, GWL_EXSTYLE,
                    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
      if ImagesMenu.AlphaBlendAnimation
      then
        SetAlphaBlendTransparent(Handle, 0)
      else
        SetAlphaBlendTransparent(Handle, ImagesMenu.AlphaBlendValue);
    end;

  SetWindowPos(Handle, HWND_TOPMOST, ShowX, ShowY, 0, 0,
               SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);


  Visible := True;

  if ImagesMenu.AlphaBlendAnimation and ImagesMenu.AlphaBlend and CheckW2KWXP
  then
    begin
      Application.ProcessMessages;
      I := 0;
      TickCount := 0;
      AnimationStep := ImagesMenu.AlphaBlendValue div 15;
      if AnimationStep = 0 then AnimationStep := 1;
      repeat
        if (GetTickCount - TickCount > 5)
        then
          begin
            TickCount := GetTickCount;
            Inc(i, AnimationStep);
            if i > ImagesMenu.AlphaBlendValue then i := ImagesMenu.AlphaBlendValue;
            SetAlphaBlendTransparent(Handle, i);
          end;  
      until i >= ImagesMenu.AlphaBlendValue;
    end;

  HookApp;

  SetCapture(Handle);
end;

procedure TspSkinImagesMenuPopupWindow.Hide;
begin
  if ImagesMenu.ShowHints and (ImagesMenu.SkinHint <> nil)
  then
    ImagesMenu.SkinHint.HideHint;
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
  UnHookApp;
  if GetCapture = Handle then ReleaseCapture;
  ImagesMenu.ProcessEvents(AProcessEvents);
end;

procedure TspSkinImagesMenuPopupWindow.DrawItems(ActiveIndex, SelectedIndex: Integer; C: TCanvas);
var
  I: Integer;
  R: TRect;
  IX, IY: Integer;
  Offset: Integer;
  IsActive, IsDown: Boolean;

procedure DrawHeader(Cnvs: TCanvas; R: TRect; ACaption: String);
var
  LData: TspDataSkinLabelControl;
  Buffer: TBitmap;
  Picture: TBitMap;
  R1: TRect;
begin
  LData := Self.GetLabelDataControl;
  if LData = nil
  then
    begin
      DrawText(Canvas.Handle, PChar(ACaption), Length(ACaption), R,
        DT_VCENTER or DT_SINGLELINE or DT_CENTER);
      Exit;
    end;

  Picture := Self.ImagesMenu.SkinData.FActivePictures[LData.PictureIndex];
  Buffer := TBitMap.Create;
  with LData do
     CreateHSkinImage(LTPoint.X, RectWidth(SkinRect) - RTPoint.X,
       Buffer, Picture, SkinRect, RectWidth(R), RectHeight(SkinRect), StretchEffect);
   // caption
   with Buffer.Canvas do
   begin
     Font.Color := LData.FontColor;
     Font.Name := LData.FontName;
     Font.Height := LData.FontHeight;
     Font.Style := LData.FontStyle;
     Font.Charset := Cnvs.Font.Charset;
     Brush.Style := bsClear;
   end;

   R1 := Rect(LData.ClRect.Left, LData.ClRect.Top,
              Buffer.Width - (RectWidth(LData.SkinRect) - LData.ClRect.Right),
              Buffer.Height);

   DrawText(Buffer.Canvas.Handle, PChar(ACaption), Length(ACaption), R1,
     DT_VCENTER or DT_SINGLELINE or DT_CENTER);

  Cnvs.Draw(R.Left, R.Top,  Buffer);

  Buffer.Free;
end;

begin
  for I := 0 to ImagesMenu.ImagesItems.Count - 1 do
  begin
    R := GetItemRect(I);
    IX := R.Left + 5;
    IY := R.Top + 5;
    Offset := 0;
    if ImagesMenu.ImagesItems[I].Header
    then
      begin
        DrawHeader(C, ImagesMenu.ImagesItems[I].ItemRect, ImagesMenu.ImagesItems[I].Caption);
        Continue;
      end;
    if (I = SelectedIndex) and not FItemDown then DrawActiveItem(R, C, True) else
    if I = ActiveIndex then DrawActiveItem(R, C, FItemDown);
    if (ImagesMenu.ImagesItems[I].ImageIndex >= 0) and
       (ImagesMenu.ImagesItems[I].ImageIndex < ImagesMenu.Images.Count)
    then
      begin
        ImagesMenu.Images.Draw(C, IX, IY, ImagesMenu.ImagesItems[I].ImageIndex, True);
        Offset := ImagesMenu.Images.Width + 5;
      end;
    if ImagesMenu.ImagesItems[I].Button and (ImagesMenu.ImagesItems[I].Caption <> '') then
    begin
      R.Left := R.Left + Offset;
      isDown := False;
      isActive := False;
      if (I = SelectedIndex) and not FItemDown
      then
        isDown := True
      else
      if I = ActiveIndex
      then
        begin
          if FItemDown then isDown := True else isActive := True;
        end;
      DrawItemCaption(ImagesMenu.ImagesItems[I].Caption, R, C, isActive, isDown);
    end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.DrawItemCaption;
var
  MenuItemData: TspDataSkinMenuItem;
  ButtonData: TspDataSkinButtonControl;
  I: Integer;
begin
  MenuItemData := nil;
  ButtonData := nil;
  if FSKinSupport
  then
    begin
      I := ImagesMenu.SkinData.GetIndex('menuitem');
      if I = -1 then I := ImagesMenu.SkinData.GetIndex('MENUITEM');
      if I = -1
      then MenuItemData := nil
      else MenuItemData := TspDataSkinMenuItem(ImagesMenu.SkinData.ObjectList[I]);

      I := ImagesMenu.SkinData.GetControlIndex('menuitembutton');
      if I = -1
      then
      I := ImagesMenu.SkinData.GetControlIndex('resizebutton');
      if I = -1
      then ButtonData := nil
      else ButtonData := TspDataSkinButtonControl(ImagesMenu.SkinData.CtrlList[I]);
    end;
  if (MenuItemData <> nil) and (ButtonData <> nil)
  then
    begin
      if ImagesMenu.UseSkinFont
      then
        begin
          C.Font.Name := ButtonData.FontName;
          C.Font.Height := ButtonData.FontHeight;
          C.Font.Style := ButtonData.FontStyle;
        end
      else
        C.Font.Assign(ImagesMenu.DefaultFont);

      if (ImagesMenu.SkinData <> nil) and (ImagesMenu.SkinData.ResourceStrData <> nil)
      then
        C.Font.Charset := ImagesMenu.SkinData.ResourceStrData.CharSet
      else
        C.Font.CharSet := ImagesMenu.FDefaultFont.Charset;

      if ADown
      then
        C.Font.Color := ButtonData.DownFontColor
      else
      if AActive
      then
        C.Font.Color := ButtonData.ActiveFontColor
      else
        C.Font.Color := MenuItemData.FontColor;
    end
  else
    begin
      C.Font.Assign(ImagesMenu.DefaultFont);
      C.Font.Color := clWindowText;
    end;
  C.Brush.Style := bsClear;
  if RectWidth(R) < C.TextWidth(ACaption)
  then
   DrawText(C.Handle, PChar(ACaption), Length(ACaption), R,
     DT_VCENTER or DT_SINGLELINE or DT_LEFT)
  else
    DrawText(C.Handle, PChar(ACaption), Length(ACaption), R,
     DT_VCENTER or DT_SINGLELINE or DT_CENTER);
end;


procedure TspSkinImagesMenuPopupWindow.DrawActiveItem(R: TRect; C: TCanvas; ASelected: Boolean);
var
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  XO, YO: Integer;
  FSkinPicture: TBitMap;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewCLRect: TRect;
  SknR: TRect;
begin
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  ButtonData := nil;
  if FSkinSupport
  then
    begin
      CIndex := ImagesMenu.SkinData.GetControlIndex('menuitembutton');
      if CIndex = -1
      then
        CIndex := ImagesMenu.SkinData.GetControlIndex('resizebutton');
      if CIndex <> -1
      then
        ButtonData := TspDataSkinButtonControl(ImagesMenu.SkinData.CtrlList[CIndex]);
    end;
  if ButtonData <> nil
  then
    with ButtonData do
    begin
      XO := RectWidth(R) - RectWidth(SkinRect);
      YO := RectHeight(R) - RectHeight(SkinRect);
      NewLTPoint := LTPoint;
      NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
      NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
      NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
      FSkinPicture := TBitMap(ImagesMenu.SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
      if (ASelected and not IsNullRect(DownSkinRect))
      then
        SknR := DownSkinRect
      else
        SknR := ActiveSkinRect;
      if IsNullRect(SknR) then SknR := SkinRect;
      CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          Buffer, FSkinPicture, SknR, Buffer.Width, Buffer.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
    end
  else
    begin
      SknR := Rect(0, 0, Buffer.Width, Buffer.Height);
      Frame3D(Buffer.Canvas, SknR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
      if ASelected
      then
        Buffer.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR
      else
        Buffer.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
      Buffer.Canvas.FillRect(SknR);
    end;
  C.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinImagesMenuPopupWindow.Paint;
var
  Buffer: TBitMap;
  SelectedIndex: Integer;
begin
  FSkinSupport := (ImagesMenu.SkinData <> nil) and (not ImagesMenu.SkinData.Empty) and
                  (ImagesMenu.SkinData.PopupWindow.WindowPictureIndex <> -1);

  if ImagesMenu.ShowSelectedItem
  then SelectedIndex := ImagesMenu.ItemIndex
  else SelectedIndex := -1;


  Buffer := TBitMap.Create;
  Buffer.Width := Width;
  Buffer.Height := Height;
  if FSkinSupport
  then
    with ImagesMenu.SkinData.PopupWindow do
    begin
      CreateSkinImageBS(LTPoint, RTPoint, LBPoint, RBPoint,
      ItemsRect, NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint,
      NewItemsRect, Buffer, WindowPicture,
      Rect(0, 0, WindowPicture.Width, WindowPicture.Height),
      Width, Height, True, LeftStretch, TopStretch,
      RightStretch, BottomStretch, StretchEffect, StretchType);
      DrawItems(MouseInItem, SelectedIndex, Buffer.Canvas);
    end
  else
    with Buffer.Canvas do
    begin
      Pen.Color := clBtnShadow;
      Brush.Color := clWindow;
      Rectangle(0, 0, Buffer.Width, Buffer.Height);
      DrawItems(MouseInItem, SelectedIndex, Buffer.Canvas);
    end;
  Canvas.Draw(0, 0, Buffer);
  Buffer.Free;
end;

procedure TspSkinImagesMenuPopupWindow.CreateMenu;
var
  ItemsWidth, ItemsHeight: Integer;
  ItemsR: TRect;
begin

  FSkinSupport := (ImagesMenu.SkinData <> nil) and (not ImagesMenu.SkinData.Empty) and
                  (ImagesMenu.SkinData.PopupWindow.WindowPictureIndex <> -1);

  AssignItemRects;

  ItemsWidth := (ImagesMenu.Images.Width + 10) * ImagesMenu.ColumnsCount;

  ItemsR := Rect(ImagesMenu.ImagesItems[0].ItemRect.Left,
                 ImagesMenu.ImagesItems[0].ItemRect.Top,
                 ImagesMenu.ImagesItems[0].ItemRect.Left + ItemsWidth,
                 ImagesMenu.ImagesItems[ImagesMenu.ImagesItems.Count - 1].ItemRect.Bottom);


  ItemsHeight := RectHeight(ItemsR);

  if (ImagesMenu.SkinData <> nil) and (not ImagesMenu.SkinData.Empty) and
     (ImagesMenu.SkinData.PopupWindow.WindowPictureIndex <> -1)
  then
    with ImagesMenu.SkinData.PopupWindow do
    begin
      if (WindowPictureIndex <> - 1) and
         (WindowPictureIndex < ImagesMenu.SkinData.FActivePictures.Count)
      then
        WindowPicture := ImagesMenu.SkinData.FActivePictures.Items[WindowPictureIndex];

      if (MaskPictureIndex <> - 1) and
           (MaskPictureIndex < ImagesMenu.SkinData.FActivePictures.Count)
      then
        MaskPicture := ImagesMenu.SkinData.FActivePictures.Items[MaskPictureIndex]
      else
        MaskPicture := nil;

      Self.Width := ItemsWidth + (WindowPicture.Width - RectWidth(ItemsRect));
      Self.Height := ItemsHeight + (WindowPicture.Height - RectHeight(ItemsRect));

      NewLTPoint := LTPoint;
      NewRTPoint := Point(Width - (WindowPicture.Width - RTPoint.X), RTPoint.Y);
      NewLBPoint := Point(LBPoint.X, Height - (WindowPicture.Height - LBPoint.Y));
      NewRBPoint := Point(Width - (WindowPicture.Width - RBPoint.X),
                          Height - (WindowPicture.Height - RBPoint.Y));

      NewItemsRect := Rect(ItemsRect.Left, ItemsRect.Top,
                           Width - (WindowPicture.Width - ItemsRect.Right),
                           Height - (WindowPicture.Height - ItemsRect.Bottom));

      if MaskPicture <> nil then SetMenuWindowRegion;
    end
  else
    begin
      Self.Width := ItemsWidth + 10;
      Self.Height := ItemsHeight + 10;
    end;
end;

procedure TspSkinImagesMenuPopupWindow.CreateParams(var Params: TCreateParams);
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

procedure TspSkinImagesMenuPopupWindow.CMMouseLeave(var Message: TMessage);
begin
  if ImagesMenu.ShowHints and (ImagesMenu.SkinHint <> nil)
  then
    ImagesMenu.SkinHint.HideHint;
  MouseInItem := -1;
  OldMouseInItem := -1;
  RePaint;
end;

procedure TspSkinImagesMenuPopupWindow.CMMouseEnter(var Message: TMessage);
begin

end;

procedure TspSkinImagesMenuPopupWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
   X, Y: Integer);
begin
  inherited;
  if ImagesMenu.ShowHints and (ImagesMenu.SkinHint <> nil)
  then
    ImagesMenu.SkinHint.HideHint;
  FDown := True;
  if GetItemFromPoint(Point(X, Y)) <> -1
    then FItemDown := True else FItemDown := False;
  RePaint;
end;

procedure TspSkinImagesMenuPopupWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
   X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  if not FDown
  then
    begin
      if GetCapture = Handle then ReleaseCapture;
      SetCapture(Handle);
    end
  else
    begin
      I := GetItemFromPoint(Point(X, Y));
      if I <> -1 then ImagesMenu.ItemIndex := I;
      if I <> -1 then Hide(I <> -1)
      else
        begin
          if GetCapture = Handle then ReleaseCapture;
          SetCapture(Handle);
        end;
    end;
end;

procedure TspSkinImagesMenuPopupWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TestActive(X, Y);
end;

procedure TspSkinImagesMenuPopupWindow.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspSkinImagesMenuPopupWindow.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
     begin
       if Windows.WindowFromPoint(Mouse.CursorPos) <> Self.Handle
       then
         Hide(False);
     end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.HookApp;
begin
  OldAppMessage := Application.OnMessage;
  Application.OnMessage := NewAppMessage;
end;

procedure TspSkinImagesMenuPopupWindow.UnHookApp;
begin
  Application.OnMessage := OldAppMessage;
end;

procedure TspSkinImagesMenuPopupWindow.NewAppMessage;
begin
  if (Msg.message = WM_KEYDOWN)
  then
    begin
      ProcessKey(Msg.wParam);
      Msg.message := 0;
    end
  else
  case Msg.message of
     WM_MOUSEACTIVATE, WM_ACTIVATE,
     WM_RBUTTONDOWN, WM_MBUTTONDOWN,
     WM_NCLBUTTONDOWN, WM_NCMBUTTONDOWN, WM_NCRBUTTONDOWN,
     WM_KILLFOCUS, WM_MOVE, WM_SIZE, WM_CANCELMODE, WM_PARENTNOTIFY,
     WM_SYSKEYDOWN, WM_SYSCHAR:
      begin
        Hide(False);
      end;
  end;
end;

procedure TspSkinImagesMenuPopupWindow.SetMenuWindowRegion;
var
  TempRgn: HRgn;
begin
  TempRgn := FRgn;
  with ImagesMenu.FSkinData.PopupWindow do
  CreateSkinRegion
    (FRgn, LTPoint, RTPoint, LBPoint, RBPoint, ItemsRect,
     NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewItemsRect,
     MaskPicture, Width, Height);
  SetWindowRgn(Handle, FRgn, True);
  if TempRgn <> 0 then DeleteObject(TempRgn);
end;



end.

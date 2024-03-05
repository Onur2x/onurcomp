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

unit SkinCtrls;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

{$IFDEF VER230}
{$DEFINE VER200}
{$DEFINE VER200_UP}
{$ENDIF}


{$IFDEF VER220}
{$DEFINE VER200}
{$DEFINE VER200_UP}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200}
{$DEFINE VER200_UP}
{$ENDIF}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, SkinData, spEffBmp, StdCtrls, SkinMenus, ComCtrls, ImgList,
  SkinHint, spUtils;


const
  // Billenium Effects messages
  BE_ID           = $41A2;
  BE_BASE         = CM_BASE + $0C4A;
  CM_BEPAINT      = BE_BASE + 0; // Paint client area to Billenium Effects' DC
  CM_BENCPAINT    = BE_BASE + 1; // Paint non client area to Billenium Effects' DC
  CM_BEFULLRENDER = BE_BASE + 2; // Paint whole control to Billenium Effects' DC
  CM_BEWAIT       = BE_BASE + 3; // Don't execute effect yet
  CM_BERUN        = BE_BASE + 4; // Execute effect now!

type

  TspControlButton = record
    R: TRect;
    MouseIn: Boolean;
    Down: Boolean;
    Visible: Boolean;
  end;

  TspSkinControl = class(TCustomControl)
  protected
    FromWMPaint: Boolean;
    FSD: TspSkinData;
    FAreaName: String;
    FSkinDataName: String;
    FRgn: HRgn;
    FDrawDefault: Boolean;
    CursorIndex: Integer;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FUseSkinCursor: Boolean;
    FHintTitle: String;
    FHintImageIndex: Integer;
    FHintImageList: TCustomImageList;
    procedure SetAlphaBlend(AValue: Boolean); virtual;
    procedure SetAlphaBlendValue(AValue: Byte); virtual;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure GetSkinData; virtual;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure SetSkinData(Value: TspSkinData); virtual;
    procedure SetSkinDataName(Value: String); virtual;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;

    procedure CreateControlDefaultImage(B: TBitMap); virtual;
    procedure CreateControlSkinImage(B: TBitMap); virtual;

  public
    FIndex: Integer;
    procedure ChangeSkinData; virtual;
    procedure BeforeChangeSkinData; virtual;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure CheckParentBackground; virtual;
    procedure CheckControlsBackground;
    
  published
    {$IFDEF VER200_UP}
    property Touch;
    {$ENDIF}
    property HintTitle: String read FHintTitle write FHintTitle;
    property HintImageIndex: Integer read FHintImageIndex write FHintImageIndex;
    property HintImageList: TCustomImageList read FHintImageList write FHintImageList;
    property Anchors;
    property TabOrder;
    property Visible;
    property DrawDefault: Boolean
      read FDrawDefault write FDrawDefault;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property AreaName: String read FAreaName write FAreaName;
    property SkinDataName: String read FSkinDataName write SetSkinDataName;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property AlphaBlend: Boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte
      read FAlphaBlendValue write SetAlphaBlendValue;
    property UseSkinCursor: Boolean read FUseSkinCursor write FUseSkinCursor;
  end;

  TspSkinCustomControl = class(TspSkinControl)
  protected
    FForceBackground: Boolean;
    FDrawbackground: Boolean;
    
    FUseSkinFont: Boolean;
    FDefaultWidth: Integer;
    FDefaultHeight: Integer;
    FDefaultFont: TFont;

    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    NewClRect: TRect;
    Picture, MaskPicture: TBitMap;
    ResizeMode: Integer;
    StretchEffect: Boolean;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchType: TspStretchType;

    procedure OnDefaultFontChange(Sender: TObject);
    procedure SetDefaultWidth(Value: Integer);
    procedure SetDefaultHeight(Value: Integer);
    procedure SetDefaultFont(Value: TFont);
    procedure DefaultFontChange; virtual;
    function GetNewRect(R: TRect): TRect;
    function GetResizeMode: Integer;
    procedure CalcSize(var W, H: Integer); virtual;

    procedure CreateSkinControlImage(B, SB: TBitMap; R: TRect);

    procedure GetSkinData; override;
    procedure CreateControlRegion;
    procedure SetControlRegion; virtual;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    function GetRealClientWidth: Integer;
    function GetRealClientHeight: Integer;
    function GetRealClientLeft: Integer;
    function GetRealClientTop: Integer;



  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
    property RealClientRect: TRect read NewClRect;
    property RealClientWidth: integer read GetRealClientWidth;
    property RealClientHeight: integer read GetRealClientHeight;
    property RealClientLeft: integer read GetRealClientLeft;
    property RealClientTop: integer read GetRealClientTop;
    property ForcebackGround: Boolean read FForceBackGround write FForceBackGround;
    property DrawbackGround: Boolean read FDrawBackground write FDrawBackground;
    procedure Paint; override;
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
  end;


  TspSkinBorderStyle = (bvFrame, bvRaised, bvLowered, bvNone);
  TspSkinPanelNumGlyphs = 1..2;

  TspImagePosition = (spipDefault, spipLeft);

  TspSkinPanel = class(TspSkinCustomControl)
  protected
    FUseSkinSize: Boolean;
    FEmptyDrawing: Boolean;
    FRibbonStyle: Boolean;
    FInChangingRollUp: Boolean;
    FImagePosition: TspImagePosition;
    FTransparentMode: Boolean;
    FCMaxWidth, FCMinWidth, FCMaxHeight, FCMinHeight: Integer;
    FOnChangeRollUpState: TNotifyEvent;
    FCheckedMode: Boolean;
    FChecked: Boolean;
    FOnChecked: TNotifyEvent;
    FAutoEnabledControls: Boolean;
    FGlyph: TBitMap;
    FNumGlyphs: TspSkinPanelNumGlyphs;
    FSpacing: Integer;
    FRealHeight: Integer;
    FRollUpState: Boolean;
    FRollUpMode: Boolean;
    FCaptionMode: Boolean;
    FBorderStyle: TspSkinBorderStyle;
    FDefaultCaptionHeight: Integer;
    FDefaultAlignment: TAlignment;
    FCaptionImageList: TCustomImageList;
    FCaptionImageIndex: Integer;
    procedure SetRibbonStyle(Value: Boolean);
    function GetTranparentClientRect: TRect;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure SetTransparentMode(Value: Boolean);
    procedure SetCaptionImageIndex(Value: Integer);
    procedure SetCheckedMode(Value: Boolean);
    procedure SetChecked(Value: Boolean);
    procedure SetGlyph(Value: TBitMap);
    procedure SetNumGlyphs(Value: TspSkinPanelNumGlyphs);
    procedure SetSpacing(Value: Integer);
    procedure SetRollUpMode(Value: Boolean); 
    procedure SetDefaultAlignment(Value: TAlignment);
    procedure SetDefaultCaptionHeight(Value: Integer); virtual;
    procedure SetBorderStyle(Value: TspSkinBorderStyle);
    procedure SetRollUpState(Value: Boolean);
    procedure SetCaptionMode(Value: Boolean); virtual;
    procedure SetAlphaBlend(AValue: Boolean); override;
    procedure SetAlphaBlendValue(AValue: Byte); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure GetSkinData; override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CreateControlResizeImage(B: TBitMap);

    procedure HideControls;
    procedure ShowControls;
    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure PaintTransparent(C: TCanvas); virtual;
    procedure SetImagePosition(Value: TspImagePosition);
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    Alignment: TAlignment;
    CaptionRect: TRect;
    NewCaptionRect: TRect;
    BGPictureIndex: Integer;
    CheckImageRect, UnCheckImageRect: TRect;
    MarkFrameRect, FrameRect: TRect;
    FrameLeftOffset, FrameRightOffset: Integer;
    FrameTextRect: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure DoRollUp(ARollUp: Boolean);
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function GetSkinClientRect: TRect;
    property UseSkinSize: Boolean
      read FUseSkinSize write FUseSkinSize;
  published
    property EmptyDrawing: Boolean read FEmptyDrawing write FEmptyDrawing;
    property RibbonStyle: Boolean
     read FRibbonStyle write SetRibbonStyle;
    property ImagePosition: TspImagePosition
      read FImagePosition  write SetImagePosition;
    property TransparentMode: Boolean read FTransparentMode write SetTransparentMode;
    property CaptionImageList: TCustomImageList read FCaptionImageList write FCaptionImageList;
    property CaptionImageIndex: Integer read FCaptionImageIndex write SetCaptionImageIndex;
    property RealHeight: Integer read FRealHeight write FRealHeight;
    property AutoEnabledControls: Boolean
      read FAutoEnabledControls write FAutoEnabledControls;
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property Checked: Boolean read FChecked write SetChecked;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspSkinPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Spacing: Integer read FSpacing write SetSpacing;
    property DefaultAlignment: TAlignment
      read FDefaultAlignment write SetDefaultAlignment;
    property DefaultCaptionHeight: Integer
      read FDefaultCaptionHeight write SetDefaultCaptionHeight;
    property BorderStyle: TspSkinBorderStyle
      read FBorderStyle write SetBorderStyle;
    property CaptionMode: Boolean read FCaptionMode write SetCaptionMode;
    property RollUpMode: Boolean read FRollUpMode write SetRollUpMode;
    property RollUpState: Boolean read FRollUpState write SetRollUpState;
    property Constraints;
    property Caption;
    property Align;
    property AutoSize;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChecked: TNotifyEvent read FOnChecked write FOnChecked;
    property OnChangeRollUpState: TNotifyEvent
     read FOnChangeRollUpState write FOnChangeRollUpState;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TspPaintPanelEvent = procedure(Cnvs: TCanvas; R: TRect) of object;

  TspSkinPaintPanel = class(TspSkinPanel)
  private
    FOnPanelPaint: TspPaintPanelEvent;
  protected
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure PaintTransparent(C: TCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnPanelPaint: TspPaintPanelEvent
      read FOnPanelPaint write FOnPanelPaint;
  end;

  TspExPanelRollKind = (rkRollHorizontal, rkRollVertical);

  TspSkinExPanel = class(TspSkinCustomControl)
  private
    FUseSkinSize: Boolean; 
    FCMaxWidth, FCMinWidth, FCMaxHeight, FCMinHeight: Integer;
    FGlyph: TBitMap;
    FNumGlyphs: TspSkinPanelNumGlyphs;
    FSpacing: Integer;
    FOnChangeRollState: TNotifyEvent;
    FOnClose: TNotifyEvent;
    StopCheckSize: Boolean;
    FRollState: Boolean;
    FRollKind: TspExPanelRollKind;
    FDefaultCaptionHeight: Integer;
    FRealWidth, FRealHEight: Integer;
    FShowRollButton: Boolean;
    FShowCloseButton: Boolean;
    FCaptionImageList: TCustomImageList;
    FCaptionImageIndex: Integer;
    FMoveable, FSizeable: Boolean;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure SetCaptionImageIndex(Value: Integer);
    function GetRollWidth: Integer;
    function GetRollHeight: Integer;
    procedure SetShowRollButton(Value: Boolean);
    procedure SetShowCloseButton(Value: Boolean);
    procedure SetGlyph(Value: TBitMap);
    procedure SetNumGlyphs(Value: TspSkinPanelNumGlyphs);
    procedure SetSpacing(Value: Integer);
  protected
    Buttons: array[0..1] of TspControlButton;
    OldActiveButton, ActiveButton, CaptureButton: Integer;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CreateControlResizeImage(B: TBitMap);
    function DrawResizeButton(C: TCanvas; R: TRect;
      AMouseIn, ADown: Boolean): TColor;
   
    procedure SetDefaultCaptionHeight(Value: Integer);
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure HideControls;
    procedure ShowControls;
    procedure SetRollState(Value: Boolean);
    procedure SetRollKind(Value: TspExPanelRollKind);
    //
    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure DrawButton(Cnvs: TCanvas; i: Integer);
    procedure TestActive(X, Y: Integer);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure GetSkinData; override;

    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMSIZING(var Message: TWMSIZE); message WM_SIZING;
  public
    //
    RollHSkinRect, RollVSkinRect: TRect;
    RollLeftOffset, RollRightOffset,
    RollTopOffset, RollBottomOffset: Integer;
    RollVCaptionRect, RollHCaptionRect: TRect;
    CloseButtonRect, CloseButtonActiveRect, CloseButtonDownRect: TRect;
    HRollButtonRect, HRollButtonActiveRect, HRollButtonDownRect: TRect;
    HRestoreButtonRect, HRestoreButtonActiveRect, HRestoreButtonDownRect: TRect;
    VRollButtonRect, VRollButtonActiveRect, VRollButtonDownRect: TRect;
    VRestoreButtonRect, VRestoreButtonActiveRect, VRestoreButtonDownRect: TRect;
    CaptionRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    //
    ButtonsTransparent: Boolean;
    ButtonsTransparentColor: TColor;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
    procedure Close;
  published
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property CaptionImageList: TCustomImageList read FCaptionImageList write FCaptionImageList;
    property CaptionImageIndex: Integer read FCaptionImageIndex write SetCaptionImageIndex;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspSkinPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Spacing: Integer read FSpacing write SetSpacing;
    
    property RealWidth: Integer read FRealWidth write FRealWidth;
    property RealHeight: Integer read FRealHeight write FRealHeight;
    property ShowRollButton: Boolean
      read FShowRollButton write SetShowRollButton;
    property ShowCloseButton: Boolean
      read FShowCloseButton write SetShowCloseButton;
    property DefaultCaptionHeight: Integer
      read FDefaultCaptionHeight write SetDefaultCaptionHeight;
    property RollState: Boolean read FRollState write SetRollState;
    property RollKind: TspExPanelRollKind read FRollKind write SetRollKind;
    property Moveable: Boolean read FMoveable write FMoveable;
    property Sizeable: Boolean read FSizeable write FSizeable;
    property Align;
    property Caption;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property OnChangeRollState: TNotifyEvent
      read FOnChangeRollState write FOnChangeRollState;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

  TspSkinStatusBar = class(TspSkinPanel)
  private
    FSizeGrip: Boolean;
    FShowGrip: Boolean;
    procedure SetSizeGrip(Value: Boolean);
    procedure SetShowGrip(Value: Boolean);
  protected
    procedure SetSkinData(Value: TspSkinData); override;
    procedure GetSkinData; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure DrawDefaultGripper(R: TRect; Cnvs: TCanvas; C1, C2: TColor);
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    function GetGripRect: TRect;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  public
    GripperRect: TRect;
    GripperTransparent: Boolean;
    GripperTransparentColor: TColor;
    constructor Create(AOwner: TComponent); override;
    property ShowGrip: Boolean read FShowGrip write SetShowGrip;
  published
    property SizeGrip: Boolean read FSizeGrip write SetSizeGrip;
  end;
  
  TspSkinToolBar = class(TspSkinPanel)
  private
    FAdjustControls: Boolean;
    // scroll
    FMouseIn: Boolean;
    FCanScroll: Boolean;
    FHotScroll: Boolean;
    TimerMode: Integer;
    SMax, SPosition, SPage, SOldPosition: Integer;
    FHSizeOffset: Integer;
    FScrollOffset: Integer;
    FScrollTimerInterval: Integer;
    Buttons: array[0..1] of TspControlButton;
    ButtonData: TspDataSkinButtonControl;
    //
    FImages: TCustomImageList;
    FDisabledImages: TCustomImageList;
    FHotImages: TCustomImageList;
    FFlat: Boolean;
    FAutoShowHideCaptions: Boolean;
    FShowCaptions: Boolean;
    FWidthWithCaptions: Integer;
    FWidthWithoutCaptions: Integer;
    procedure SetFlat(Value: Boolean);
    procedure SetDisabledImages(Value: TCustomImageList);
    procedure SetHotImages(Value: TCustomImageList);
    procedure SetImages(Value: TCustomImageList);
    procedure SetShowCaptions(Value: Boolean);
    // scroll
    procedure SetScrollOffset(Value: Integer);
    procedure SetScrollTimerInterval(Value: Integer);
    procedure DrawButton(Cnvs: TCanvas; i: Integer);
    function CheckActivation: Boolean;
  protected
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure GetSkinData; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure SetSkinDataName(Value: String); override;
    // scroll
    procedure WMSETCURSOR(var Message: TWMSetCursor); message WM_SetCursor;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMMouseEnter;
    procedure CMMouseLeave;
    procedure WndProc(var Message: TMessage); override;
    procedure SetButtonsVisible(AVisible: Boolean);
    procedure ButtonClick(I: Integer);
    procedure ButtonDown(I: Integer);
    procedure ButtonUp(I: Integer);
    procedure GetHRange;
    procedure GetScrollInfo;
    procedure HScrollControls(AOffset: Integer);
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure StartTimer;
    procedure StopTimer;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMDESTROY(var Message: TMessage); message WM_DESTROY;
    procedure AdjustAllControls;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property AdjustControls: Boolean read FAdjustControls write FAdjustControls;
    // scroll
    property CanScroll: Boolean read FCanScroll write FCanScroll;
    property HotScroll: Boolean read FHotScroll write FHotScroll;
    property ScrollOffset: Integer read FScrollOffset write SetScrollOffset;
    property ScrollTimerInterval: Integer
      read FScrollTimerInterval write SetScrollTimerInterval;
    //
    property WidthWithCaptions: Integer
      read FWidthWithCaptions write FWidthWithCaptions;
    property WidthWithoutCaptions: Integer
      read FWidthWithoutCaptions write FWidthWithoutCaptions;
    property AutoShowHideCaptions: Boolean
      read FAutoShowHideCaptions write FAutoShowHideCaptions;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions;  
    property Flat: Boolean read FFlat write SetFlat;
    property Images: TCustomImageList read FImages write SetImages;
    property HotImages: TCustomImageList read FHotImages write SetHotImages;
    property DisabledImages: TCustomImageList read FDisabledImages write SetDisabledImages;
  end;

  TspSkinGroupBox = class(TspSkinPanel)
  protected
    procedure GetSkinData; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property UseSkinSize;  
  end;

   TspButtonPaintEvent = procedure(Sender: TObject; Cnvs: TCanvas; R: TRect; ADown, AMouseIn: Boolean;
   var DrawDefault: Boolean) of object;

  TspSkinButton = class(TspSkinCustomControl)
  protected
    // checked
    FCheckedMode: Boolean;
    FStopMouseUp: Boolean;
    // layer
    FAlwaysShowGlowFrame: Boolean;
    FLayerManager: TspLayerManager;
    // animation
    AnimateTimer: TTimer;
    CurrentFrame: Integer;
    AnimateInc: Boolean;
    //
    FSkinImagesMenu: TspSkinImagesMenu;
    FUseImagesMenuImage: Boolean;
    FUseImagesMenuCaption: Boolean;
    FSpaceSupport: Boolean;
    //
    FUseSkinFontColor: Boolean;
    FUseSkinSize: Boolean;
    RepeatTimer: TTimer;
    FRepeatMode: Boolean;
    FRepeatInterval: Integer;
    FActive: Boolean;
    FAllowAllUp: Boolean;
    FAllowAllUpCheck: Boolean;
    FDefault: Boolean;
    FCancel: Boolean;
    FModalResult: TModalResult;
    FClicksDisabled: Boolean;
    FCanFocused: Boolean;
    FMorphKf: Double;
    FDown: Boolean;
    FMouseIn, FMouseDown: Boolean;
    FGroupIndex: Integer;
    FGlyph: TBitMap;
    FNumGlyphs: TspNumGlyphs;
    FOnClick: TNotifyEvent;
    FOnPaint: TspButtonPaintEvent;
    FMargin: Integer;
    FSpacing: Integer;
    FLayout: TspButtonLayout;
    MorphTimer: TTimer;
    //
    FImageList: TCustomImageList;
    FImageIndex: Integer;
    procedure SetCheckedMode(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure StartAnimate(AInc: Boolean);
    procedure StopAnimate;
    procedure DoAnimate(Sender: TObject);
    function GetAnimationFrameRect: TRect;
    function GetGlyphNum(AIsDown, AIsMouseIn: Boolean): Integer;
    //
    procedure RepeatTimerProc(Sender: TObject);
    procedure BeforeRepeatTimerProc(Sender: TObject);
    procedure StartRepeat;
    procedure StopRepeat;
    procedure StartMorph;
    procedure StopMorph;
    procedure SetDefault(Value: Boolean);
    function IsFocused: Boolean;
    procedure SetCanFocused(Value: Boolean);
    procedure DoMorph(Sender: TObject);
    procedure CreateStrechButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean);
    procedure CreateButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean); virtual;
    procedure SetLayout(Value : TspButtonLayout);
    procedure SetGroupIndex(Value: Integer);
    procedure SetDown(Value: Boolean);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
    procedure DoAllUp;
    procedure SetNumGlyphs(Value: TspNumGlyphs);
    procedure SetGlyph(Value: TBitMap);
    procedure GetSkinData; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ReDrawControl;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    //
    procedure WMSHOWLAYER(var Message: TMessage); message WM_SHOWLAYER;
    procedure WMHIDELAYER(var Message: TMessage); message WM_HIDELAYER;
    //
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CreateWnd; override;
    procedure CalcSize(var W, H: Integer); override;
    function EnableMorphing: Boolean;
    function EnableAnimation: Boolean;
    procedure DrawMenuMarker(C: TCanvas; R: TRect; AActive, ADown: Boolean);
    procedure OnImagesMenuChanged(Sender: TObject);
    procedure SetSkinImagesMenu(Value: TspSkinImagesMenu);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;

    property SkinImagesMenu: TspSkinImagesMenu
     read FSkinImagesMenu write SetSkinImagesMenu;
    property UseImagesMenuImage: Boolean
      read FUseImagesMenuImage write FUseImagesMenuImage;
    property UseImagesMenuCaption: Boolean
      read FUseImagesMenuCaption write FUseImagesMenuCaption;

  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, DisabledFontColor: TColor;
    ActiveSkinRect, DownSkinRect, DisabledSkinRect, FocusedSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    ShowFocus: Boolean;
    //
    MenuMarkerFlatRect,
    MenuMarkerRect,
    MenuMarkerActiveRect,
    MenuMarkerDownRect: TRect;
    MenuMarkerTransparentColor: TColor;
    //
    GlowLayerPictureIndex: Integer;
    GlowLayerMaskPictureIndex: Integer;
    GlowLayerOffsetLeft: Integer;
    GlowLayerOffsetRight: Integer;
    GlowLayerOffsetTop: Integer;
    GlowLayerOffsetBottom: Integer;
    GlowLayerShowOffsetX: Integer;
    GlowLayerShowOffsetY: Integer;
    GlowLayerAlphaBlendValue: Integer;
    //
    FStopAnimate: Boolean;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
    procedure Click; override;
    procedure RefreshButton;
    procedure BeforeChangeSkinData; override;
    procedure ButtonClick; virtual;
     //
    procedure ShowLayer;
    procedure HideLayer;
  published
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ImageList: TCustomImageList read FImageList write FImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property AlwaysShowLayeredFrame: Boolean
     read FAlwaysShowGlowFrame write FAlwaysShowGlowFrame;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property UseSkinFontColor: Boolean read FUseSkinFontColor write FUseSkinFontColor;
    property RepeatMode: Boolean read FRepeatMode write FRepeatMode;
    property RepeatInterval: Integer
      read  FRepeatInterval write FRepeatInterval;
    property AllowAllUp: Boolean read FAllowAllUp write FAllowAllUp;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property CanFocused: Boolean read FCanFocused write SetCanFocused;
    property Action;
    property Down: Boolean read FDown write SetDown;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Caption;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Align;
    property Margin: Integer read FMargin write SetMargin default -1;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Layout: TspButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Enabled;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Default: Boolean read FDefault write SetDefault default False;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnPaint: TspButtonPaintEvent
      read FOnPaint write FOnPaint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;


  TspSkinMenuButton = class(TspSkinButton)
  protected
    FOnShowTrackMenu: TNotifyEvent;
    FOnHideTrackMenu: TNotifyEvent;
    FTrackButtonMode: Boolean;
    FMenuTracked: Boolean;
    FSkinPopupMenu: TspSkinPopupMenu;

    procedure CreateButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean); override;

    function CanMenuTrack(X, Y: Integer): Boolean;
    procedure TrackMenu;
    procedure SetTrackButtonMode(Value: Boolean);
    procedure GetSkinData; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMCLOSESKINMENU(var Message: TMessage); message WM_CLOSESKINMENU;
    function GetNewTrackButtonRect: TRect;
    procedure WndProc(var Message: TMessage); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinResizeImage(B: TBitMap);
    procedure CreateControlSkinResizeImage2(B: TBitMap);
    procedure OnImagesMenuClose(Sender: TObject);
  public
    TrackButtonRect: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property SkinImagesMenu;
    property UseImagesMenuImage;
    property UseImagesMenuCaption;

    property SkinPopupMenu: TspSkinPopupMenu read FSkinPopupMenu
                                             write FSkinPopupMenu;
    property TrackButtonMode: Boolean read FTrackButtonMode
                                      write SetTrackButtonMode;
    property OnShowTrackMenu: TNotifyEvent read FOnShowTrackMenu
                                           write FOnShowTrackMenu;
    property OnHideTrackMenu: TNotifyEvent read FOnHideTrackMenu
                                           write FOnHideTrackMenu;
  end;

  TspSkinCheckRadioBox = class(TspSkinCustomControl)
  protected
    FDown: Boolean;
    FUseSkinFontColor: Boolean;
    FWordWrap: Boolean;
    FAllowGrayed: Boolean;
    FState: TCheckBoxState;
    FImages: TCustomImageList;
    FImageIndex: Integer;
    FFlat: Boolean;
    FClicksDisabled: Boolean;
    FCanFocused: Boolean;
    FMouseIn: Boolean;
    FGroupIndex: Integer;
    FOnClick: TNotifyEvent;
    FChecked: Boolean;
    CIRect, NewTextArea: TRect;
    FRadio: Boolean;
    MorphTimer: TTimer;
    FMorphKf: Double;
    procedure SetWordWrap(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetImages(Value: TCustomImageList);
    procedure StartMorph;
    procedure StopMorph;
    function IsFocused: Boolean;
    procedure SetCheckState; virtual;
    procedure SetFlat(Value: Boolean);
    procedure SetCanFocused(Value: Boolean);
    procedure SetRadio(Value: Boolean);
    procedure SetChecked(Value: Boolean);
    procedure DoMorph(Sender: TObject);
    procedure CreateImage(B: TBitMap; R: TRect; AMouseIn: Boolean);
    procedure UnCheckAll;
    procedure GetSkinData; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;  
    procedure ReDrawControl;
    procedure CalcSize(var W, H: Integer); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMMOVE(var Message: TWMSETFOCUS); message WM_MOVE;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
    procedure SkinDrawGrayedCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    function EnableMorphing: Boolean;
    procedure SetState(Value: TCheckBoxState);
    procedure SetAllowGrayed(Value: Boolean);
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FrameFontColor, UnEnabledFontColor: TColor;
    ActiveSkinRect, CheckImageArea, TextArea,
    CheckImageRect, UnCheckImageRect: TRect;
    ActiveCheckImageRect, ActiveUnCheckImageRect: TRect;
    UnEnabledCheckImageRect, UnEnabledUnCheckImageRect: TRect;
    GrayedCheckImageRect, ActiveGrayedCheckImageRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
    procedure CheckParentBackground; override;
  published
    property WordWrap: boolean read FWordWrap write SetWordWrap;
    property AllowGrayed: Boolean read FAllowGrayed write SetAllowGrayed;
    property State: TCheckBoxState read FState write SetState;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property UseSkinFontColor: Boolean
      read FUseSkinFontColor write FUseSkinFontColor;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property CanFocused: Boolean read FCanFocused write SetCanFocused;
    property Action;
    property Radio: Boolean read FRadio write SetRadio;
    property Checked: Boolean read FChecked write SetChecked;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex;
    property Flat: Boolean read FFlat write SetFlat;
    property Caption;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

  TspGaugePaintEvent = procedure(Cnvs: TCanvas; AProgressArea, AProgressRect: TRect) of object;

  TspSkinGauge = class(TspSkinCustomControl)
  protected

    FAnimationFrame: Integer;
    FAnimationPauseTimer: TTimer;
    FAnimationTimer: TTimer;
    FProgressAnimationPause: Integer;

    FUseSkinSize: Boolean;
    FMinValue, FMaxValue, FValue: Integer;
    FVertical: Boolean;
    FProgressText: String;
    FShowPercent: Boolean;
    FShowProgressText: Boolean;
    FTextAlphaBlend: Boolean;
    FTextAlphaBlendValue: Byte;
    FOnGaugePaint: TspGaugePaintEvent;

    procedure OnAnimationPauseTimer(Sender: TObject);
    procedure OnAnimationTimer(Sender: TObject);

    procedure SetTextAlphaBlendValue(Value: Byte);
    procedure SetTextAlphaBlend(Value: Boolean);
    procedure SetShowProgressText(Value: Boolean);
    procedure SetShowPercent(Value: Boolean);
    procedure SetProgressText(Value: String);
    procedure SetVertical(AValue: Boolean);
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    procedure SetValue(AValue: Integer);
    procedure GetSkinData; override;
    procedure CreateImage(B: TBitMap);
    procedure CalcSize(var W, H: Integer); override;
    procedure DrawProgressText(C: TCanvas);

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;


    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    function GetAnimationFrameRect: TRect;
    procedure SetProgressAnimationPause(Value: Integer);
  public
    ProgressRect, ProgressArea: TRect;
    NewProgressArea: TRect;
    BeginOffset, EndOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ProgressTransparent: Boolean;
    ProgressTransparentColor: TColor;
    ProgressStretch: Boolean;
    //
    ProgressAnimationSkinRect: TRect;
    ProgressAnimationCountFrames: Integer;
    ProgressAnimationTimerInterval: Integer;
    //
    procedure StartProgressAnimation;
    procedure StopProgressAnimation;

    procedure StartInternalAnimation;
    procedure StopInternalAnimation;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CalcProgressRect(R: TRect; AV: Boolean): TRect;
    procedure Paint; override;
    procedure ChangeSkinData; override;
  published
    property ProgressAnimationPause: Integer
      read  FProgressAnimationPause write SetProgressAnimationPause;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property TextAlphaBlend: Boolean read FTextAlphaBlend
                                      write SetTextAlphaBlend;
    property TextAlphaBlendValue: Byte read FTextAlphaBlendValue
                                      write SetTextAlphaBlendValue;
    property ProgressText: String read FProgressText write SetProgressText;
    property ShowProgressText: Boolean read FShowProgressText write SetShowProgressText;
    property ShowPercent: Boolean read FShowPercent write SetShowPercent;

    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property Value: Integer read FValue write SetValue;
    property Vertical: Boolean
      read FVertical write SetVertical;
    property OnGaugePaint: TspGaugePaintEvent
      read  FOnGaugePaint write FOnGaugePaint;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property PopupMenu;
    property ShowHint;
  end;

  TspSkinButtonLabel = class(TGraphicControl)
  protected
    FUseCustomGlowColor: Boolean;
    FCustomGlowColor: TColor;
    FGlowEffect: Boolean;
    FGlowSize: Integer;
    FDoubleBuffered: Boolean;
    FWebStyle: Boolean;
    FMouseIn, FDown: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultActiveFontColor: TColor;
    FGlyph: TBitMap;
    FNumGlyphs: TspNumGlyphs;
    FMargin: Integer;
    FSpacing: Integer;
    FLayout: TspButtonLayout;
    FImageList: TCustomImageList;
    FImageIndex: Integer;
    FActiveImageIndex: Integer;
    procedure SetImageIndex(Value: Integer);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure SetDefaultFont(Value: TFont);
    procedure SetLayout(Value : TspButtonLayout);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
    procedure SetNumGlyphs(Value: TspNumGlyphs);
    procedure SetGlyph(Value: TBitMap);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;  
    procedure SetWebStyle(Value: Boolean);
    procedure SetDoubleBuffered(Value: Boolean);
  public
    FontColor: TColor;
    ActiveFontColor: TColor;
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure Paint; override;
  published
    property UseCustomGlowColor: Boolean
     read FUseCustomGlowColor write FUseCustomGlowColor;
    property CustomGlowColor: TColor
      read FCustomGlowColor write FCustomGlowColor;
    property GlowEffect: Boolean read FGlowEffect write FGlowEffect;
    property GlowSize: Integer read FGlowSize write FGlowSize;
    property DoubleBuffered: Boolean
      read FDoubleBuffered write SetDoubleBuffered;
    property ImageList: TCustomImageList read FImageList write FImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property ActiveImageIndex: Integer read FActiveImageIndex write FActiveImageIndex;
    property WebStyle: Boolean read FWebStyle write SetWebStyle;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Margin: Integer read FMargin write SetMargin default -1;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Layout: TspButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultActiveFontColor: TColor
      read FDefaultActiveFontColor write FDefaultActiveFontColor;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinTextLabel = class(TGraphicControl)
  private
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FUseSkinColor: Boolean;
    //
    FLines: TStrings;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FLayout: TTextLayout;
    FWordWrap: Boolean;

    procedure SetSkinData(Value: TspSkinData);
    procedure SetDefaultFont(Value: TFont);
    procedure SetLines(Value: TStrings);
    procedure SetAlignment(Value: TAlignment);
    procedure SetLayout(Value: TTextLayout);
    procedure SetWordWrap(Value: Boolean);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure OnTextChange(Sender: TObject);
  protected
    procedure AdjustBounds; dynamic;
    function GetLabelText: string; virtual;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetAutoSize(Value: Boolean); virtual;
    procedure DoDrawText(var Rect: TRect; Flags: Longint);
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
    procedure ChangeSkinData;
    procedure GetSkinData;
    procedure Paint; override;
  published
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property UseSkinColor: Boolean read FUseSkinColor write FUseSkinColor;
    property Lines: TStrings read FLines write SetLines;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Font;
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property Layout: TTextLayout read FLayout write SetLayout default tlTop;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property Anchors;
    property BiDiMode;
    property Constraints;                                      
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspEllipsType = (spetNone, spetEndEllips, spetPathEllips);

  TspSkinStdLabel = class(TCustomLabel)
  protected
    FEllipsType: TspEllipsType;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FUseSkinColor: Boolean;
    procedure SetEllipsType(const Value: TspEllipsType);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure SetDefaultFont(Value: TFont);
    property Transparent;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetSkinData;
    procedure ChangeSkinData;
  published
    property EllipsType: TspEllipsType read FEllipsType write SetEllipsType;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property UseSkinColor: Boolean read FUseSkinColor write FUseSkinColor;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Font;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  TspEllipsType2 = (spetNoneEllips, spetEllips);

  TspSkinLabel = class(TspSkinCustomControl)
  protected
    FShadowEffect: Boolean;
    FShadowOffset: Integer;
    FShadowSize: Integer;
    FShadowColor: TColor;
    FReflectionEffect: Boolean;
    FReflectionOffset: Integer;
    FEllipsType: TspEllipsType2;
    FUseSkinSize: Boolean;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FBorderStyle: TspSkinBorderStyle;
    FUseSkinFontColor: Boolean;
    FTransparent: Boolean;
    procedure SetEllipsType(Value: TspEllipsType2);
    procedure SetBorderStyle(Value: TspSkinBorderStyle);
    procedure DrawLabelText(Cnvs: TCanvas; R: TRect);
    function CalcWidthOffset: Integer; virtual;
    procedure AdjustBounds;
    procedure PaintLabel(B: TBitMap);
    procedure SetAutoSizeX(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure CalcSize(var W, H: Integer); override;
    procedure GetSkinData; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure SetControlRegion; override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure SetReflectionOffset(Value: Integer);
    procedure SetReflectionEffect(Value: Boolean);
    procedure SetShadowEffect(Value: Boolean);
    procedure SetShadowOffset(Value: Integer);
    procedure SetShadowSize(Value: Integer);
    procedure SetShadowColor(Value: TColor);
    procedure SetTransparent(Value: Boolean);
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AOwner: TComponent); override;
  published
    property Transparent: Boolean
      read FTransparent write SetTransparent;
    property ShadowEffect: Boolean
      read FShadowEffect write SetShadowEffect;
    property ShadowColor: TColor
      read FShadowColor write SetShadowColor;
    property ShadowOffset: Integer
      read FShadowOffset write SetShadowOffset;
    property ShadowSize: Integer
      read FShadowSize write SetShadowSize;
    property ReflectionEffect: Boolean
      read FReflectionEffect write SetReflectionEffect;
    property ReflectionOffset: Integer
      read FReflectionOffset write SetReflectionOffset;
    property EllipsType: TspEllipsType2 read FEllipsType write SetEllipsType;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property UseSkinFontColor: Boolean
      read FUseSkinFontColor write FUseSkinFontColor;
    property BorderStyle: TspSkinBorderStyle
      read FBorderStyle write SetBorderStyle;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property Align;
    property Caption;
    property DragCursor;
    property BiDiMode;
    property DragKind;
    property DragMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeX;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinTrackBar = class(TspSkinCustomControl)
  protected
    FClicksDisabled: Boolean;
    FCanFocused: Boolean;
    Offset1, Offset2, BOffset: Integer;
    BR: TRect;
    FMinValue, FMaxValue, FValue: Integer;
    FVertical: Boolean;
    FMouseSupport, FDown: Boolean;
    OMPos: Integer;
    OldBOffset: Integer;
    FOnChange: TNotifyEvent;
    FOnLastChange: TNotifyEvent;
    FOnStartDragButton: TNotifyEvent;
    FJumpWhenClick: Boolean;
    function IsFocused: Boolean;
    procedure SetCanFocused(Value: Boolean);
    procedure SetVertical(AValue: Boolean);
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    procedure SetValue(AValue: Integer);
    procedure GetSkinData; override;
    procedure CreateImage(B: TBitMap);
    procedure CalcSize(var W, H: Integer); override;
    function CalcButtonRect(R: TRect; AV: Boolean): TRect;
    function CalcValue(AOffset: Integer): Integer;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

  public
    ActiveSkinRect: TRect;
    TrackArea, NewTrackArea, ButtonRect, ActiveButtonRect: TRect;
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    constructor Create(AOwner: TComponent); override;
  published
    property JumpWhenClick: Boolean read FJumpWhenClick write FJumpWhenClick;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property CanFocused: Boolean read FCanFocused write SetCanFocused;
    property MouseSupport: Boolean read FMouseSupport write FMouseSupport;
    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property Value: Integer read FValue write SetValue;
    property Vertical: Boolean read FVertical write SetVertical;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnLastChange: TNotifyEvent read FOnLastChange write FOnLastChange;
    property OnStartDragButton: TNotifyEvent
      read FOnStartDragButton write FOnStartDragButton;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TspSkinScrollBar = class(TspSkinCustomControl)
  private
    FNormalSkinDataName: String;
    FBothSkinDataName: String;
    Offset1, Offset2, BOffset: Integer;
    NewTrackArea: TRect;
    FDown: Boolean;
    OMPos, OldPosition, FScrollWidth: Integer;
    OldBOffset: Integer;
    WaitMode: Boolean;
    MX, MY: Integer;
    MouseD: Boolean;
  protected
    FBothMarkerWidth: Integer;
    FClicksDisabled: Boolean;
    FCanFocused: Boolean;

    FOnChange: TNotifyEvent;
    FOnLastChange: TNotifyEvent;
    FOnUpButtonClick: TNotifyEvent;
    FOnDownButtonClick: TNotifyEvent;
    FOnPageUp: TNotifyEvent;
    FOnPageDown: TNotifyEvent;

    TimerMode: Integer;
    ActiveButton, OldActiveButton, CaptureButton: Integer;
    Buttons: array[0..2] of TspControlButton;
    FMin, FMax, FSmallChange,
    FLargeChange, FPosition: Integer;
    FKind: TScrollBarKind;
    FPageSize: Integer;
    procedure SetBothMarkerWidth(Value: Integer);
    function IsFocused: Boolean;
    procedure SetCanFocused(Value: Boolean);
    procedure TestActive(X, Y: Integer);
    procedure SetPageSize(AValue: Integer);
    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure CalcRects;
    function CalcValue(AOffset: Integer): Integer;
    procedure SetKind(AValue: TScrollBarKind);
    procedure SetPosition(AValue: Integer);
    procedure SetMin(AValue: Integer);
    procedure SetMax(AValue: Integer);
    procedure SetSmallChange(AValue: Integer);
    procedure SetLargeChange(AValue: Integer);
    procedure SetBoth(Value: Boolean);

    procedure CalcSize(var W, H: Integer); override;
    procedure GetSkinData; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure StartScroll;
    procedure StopTimer;

    procedure DrawButton(Cnvs: TCanvas; i: Integer);

    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WndProc(var Message: TMessage); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    
  public
    FBoth: Boolean;
    TrackArea: TRect;
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    ThumbRect, ActiveThumbRect, DownThumbRect: TRect;
    ThumbOffset1, ThumbOffset2: Integer;
    ThumbTransparent: Boolean;
    ThumbTransparentColor: TColor;
    GlyphRect, ActiveGlyphRect, DownGlyphRect: TRect;
    ThumbStretchEffect: Boolean;
    ThumbMinSize: TColor;
    ThumbMinPageSize: TColor;
    GlyphTransparent: Boolean;
    GlyphTransparentColor: TColor;
    procedure SimplySetPosition(AValue: Integer);
    constructor Create(AOwner: TComponent); override;
    procedure SetRange(AMin, AMax, APosition, APageSize: Integer);
  published
    property Both: Boolean read FBoth write SetBoth;
    property BothMarkerWidth: Integer
      read FBothMarkerWidth write SetBothMarkerWidth;
    property BothSkinDataName: String
      read FBothSkinDataName write FBothSkinDataName;
    property TabStop;
    property TabOrder;
    property CanFocused: Boolean read FCanFocused write SetCanFocused;
    property Align;
    property Kind: TScrollBarKind read FKind write SetKind;
    property PageSize: Integer read FPageSize write SetPageSize;
    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property Position: Integer read FPosition write SetPosition;
    property SmallChange: Integer read FSmallChange write SetSmallChange;
    property LargeChange: Integer read FLargeChange write SetLargeChange;
    property OnUpButtonClick: TNotifyEvent read FOnUpButtonClick write FOnUpButtonClick;
    property OnDownButtonClick: TNotifyEvent read FOnDownButtonClick write FOnDownButtonClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnLastChange: TNotifyEvent read FOnLastChange write FOnLastChange;
    property OnPageUp: TNotifyEvent read FOnPageUp write FOnPageUp;
    property OnPageDown: TNotifyEvent read FOnPageDown write FOnPageDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;


  TspSkinCoolBar = class(TCoolBar)
  protected
    FSkinBevel: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    procedure DrawGrip(C: TCanvas; R: TRect);
    procedure PaintNCSkin(ADC: HDC; AUseExternalDC: Boolean);
    procedure SetSkinBevel(Value: Boolean);
    procedure SetSkinData(Value: TspSkinData);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CMBENCPaint(var Message: TMessage); message CM_BENCPAINT;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function GetCaptionSize(Band: TCoolBand): Integer;
    function GetCaptionFontHeight: Integer;
    procedure CheckControlsBackground;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
  public
    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect, NewClRect, ItemRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    FSkinPicture: TBitMap;
    BGPictureIndex: Integer;
    HGripRect, VGripRect: TRect;
    GripOffset1, GripOffset2: Integer;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchType: TspStretchType;
    StretchEffect: Boolean;
    ItemStretchEffect: Boolean;
    GripTransparent: Boolean;
    GripTransparentColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetSkinData;
    procedure ChangeSkinData;
  published
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinBevel: Boolean read FSkinBevel write SetSkinBevel;
    property Align;
    property Anchors;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TspSkinControlBar = class(TCustomControlBar)
  protected
    FSkinBevel: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    procedure PaintNCSkin(ADC: HDC; AUseExternalDC: Boolean);
    procedure SetSkinBevel(Value: Boolean);
    procedure SetSkinData(Value: TspSkinData);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure PaintControlFrame(Canvas: TCanvas; AControl: TControl;
      var ARect: TRect); override;
    procedure CMBENCPaint(var Message: TMessage); message CM_BENCPAINT;
    procedure CheckControlsBackground;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
  public
    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect, NewClRect, ItemRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    FSkinPicture: TBitMap;
    BGPictureIndex: Integer;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchEffect: Boolean;
    StretchType: TspStretchType;
    ItemStretchEffect: Boolean;
    ItemOffset1, ItemOffset2: Integer;
    ItemTransparent: Boolean;
    ItemTransparentColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Canvas;
    procedure GetSkinData;
    procedure ChangeSkinData;
  published
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinBevel: Boolean read FSkinBevel write SetSkinBevel;
    property Align;
    property Anchors;
    property AutoDrag;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PopupMenu;
    property RowSize;
    property RowSnap;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnBandDrag;
    property OnBandInfo;
    property OnBandMove;
    property OnBandPaint;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


  TspCustomSplitter = class(TspSkinControl)
  private
    FActiveControl: TWinControl;
    FAutoSnap: Boolean;
    FControl: TControl;
    FDownPos: TPoint;
    FMinSize: NaturalNumber;
    FMaxSize: Integer;
    FNewSize: Integer;
    FOldKeyDown: TKeyEvent;
    FOldSize: Integer;
    FSplit: Integer;
    FOnCanResize: TCanResizeEvent;
    FOnMoved: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    procedure CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
    function FindControl: TControl;
    procedure FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateControlSize;
    procedure UpdateSize(X, Y: Integer);
  protected
    function CanResize(var NewSize: Integer): Boolean; reintroduce; virtual;
    function DoCanResize(var NewSize: Integer): Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure RequestAlign; override;
    procedure StopSizing; dynamic;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property Align default alLeft;
    property AutoSnap: Boolean read FAutoSnap write FAutoSnap default True;
    property Color;
    property Cursor default crHSplit;
    property Constraints;
    property MinSize: NaturalNumber read FMinSize write FMinSize default 30;
    property ParentColor;
    property Visible;
    property Width default 3;
    property OnCanResize: TCanResizeEvent read FOnCanResize write FOnCanResize;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TspSkinSplitter = class(TSplitter)
  protected
    FTransparent: Boolean;
    FDefaultSize: Integer;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    StretchEffect: Boolean;
    procedure SetSkinData(Value: TspSkinData);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetTransparent(Value: Boolean);
    procedure RequestAlign; override;
  public
    LTPt, RTPt, LBPt: TPoint;
    SkinRect: TRect;
    FSkinPicture: TBitMap;
    GripperRect: TRect;
    GripperTransparent: Boolean;
    GripperTransparentColor: TColor;
    procedure GetSkinData;
    procedure ChangeSkinData;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Transparent: Boolean read FTransparent write SetTransparent;
    property DefaultSize: Integer read FDefaultSize write FDefaultSize;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property OnClick;
    property OnDblClick;
  end;

  TspSkinCustomRadioGroup = class(TspSkinGroupBox)
  private
    FImages: TCustomImageList;
    FButtonSkinDataName: String;
    FButtons: TList;
    FItems: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    FButtonDefaultFont: TFont;

    procedure SetButtonDefaultFont(Value: TFont);
    procedure SetImages(Value: TCustomImageList);
    procedure SetButtonSkinDataName(Value: String);
    procedure ArrangeButtons;
    procedure ButtonClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure SetButtonCount(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure UpdateButtons;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure SetSkinData(Value: TspSkinData); override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;
    function CanModify: Boolean; virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure UpdateButtonsFont;
    procedure FlipChildren(AllLevels: Boolean); override;
    property ButtonDefaultFont: TFont
      read FButtonDefaultFont write SetButtonDefaultFont;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write SetButtonSkinDataName;
    property Images: TCustomImageList read FImages write SetImages;
  end;

  TspSkinCustomCheckGroup = class(TspSkinGroupBox)
  private
    FImages: TCustomImageList;
    FItemIndex: Integer;
    FButtonSkinDataName: String;
    FButtons: TList;
    FItems: TStrings;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    FButtonDefaultFont: TFont;
    procedure SetImages(Value: TCustomImageList);
    procedure SetButtonDefaultFont(Value: TFont);
    procedure SetButtonSkinDataName(Value: String);
    procedure ArrangeButtons;
    procedure ButtonClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure SetButtonCount(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure UpdateButtons;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;
    function CanModify: Boolean; virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;

    function GetCheckedStatus(Index: Integer): Boolean;
    procedure SetCheckedStatus(Index: Integer; Value: Boolean);

    property Columns: Integer read FColumns write SetColumns default 1;
    property Items: TStrings read FItems write SetItems;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure UpdateButtonsFont;
    procedure FlipChildren(AllLevels: Boolean); override;
    property ButtonDefaultFont: TFont
      read FButtonDefaultFont write SetButtonDefaultFont;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write SetButtonSkinDataName;
    property ItemChecked[Index: Integer]: Boolean read GetCheckedStatus write SetCheckedStatus;
    property ItemIndex: Integer read FItemIndex;
    property Images: TCustomImageList read FImages write SetImages;
  end;

  TspSkinCheckGroup = class(TspSkinCustomCheckGroup)
  published
    property Images;
    property ButtonSkinDataName;
    property ButtonDefaultFont;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Columns;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Items;
    property ItemIndex;
    property Constraints;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinRadioGroup = class(TspSkinCustomRadioGroup)
  published
    property Images;
    property ButtonSkinDataName;
    property ButtonDefaultFont;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Columns;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ItemIndex;
    property Items;
    property Constraints;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinCustomTreeView = class(TCustomTreeView)
  protected
    FExpandImage, FNoExpandImage: TBitmap;
    //
    FThirdImages, FThirdImageWidth, FThirdImageHeight,
    FThirdImagesCount: Integer;
    //
    FButtonImageList: TCustomImageList;
    FButtonNoExpandImageIndex: Integer;
    FButtonExpandImageIndex: Integer;
    FItemSkinDataName: String;
    FCheckSkinDataName: String;
    FLineColor: TColor;
    FButtonColor: TColor;
    FButtonSize: Integer;
    FDrawSkin: Boolean;
    FInCheckScrollBars: Boolean;
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultColor: TColor;

    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;

    procedure SetDrawSkin(Value: Boolean); virtual;

    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure SetDefaultColor(Value: TColor);
    procedure SetDefaultFont(Value: TFont);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WMNCHITTEST(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WndProc(var Message: TMessage); override;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change(Node: TTreeNode); override;
    procedure Loaded; override;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;

    procedure NewAdvancedCustomDrawItem(
      Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);

    procedure DrawButton(ARect: TRect; Node: TTreeNode);
    procedure DrawImage(NodeRect: TRect; ImageIndex: Integer);
    procedure SetButtonImageList(Value: TCustomImageList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; virtual;
    procedure UpDateScrollBars;
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;

    property DrawSkin: Boolean read FDrawSkin write SetDrawSkin;

    property ItemSkinDataName: String
      read FItemSkinDataName write FItemSkinDataName;

    property CheckSkinDataName: String
      read FCheckSkinDataName write FCheckSkinDataName;

    property ButtonImageList: TCustomImageList
      read FButtonImageList write SetButtonImageList;

    property ButtonNoExpandImageIndex: Integer
      read FButtonNoExpandImageIndex write FButtonNoExpandImageIndex;

    property ButtonExpandImageIndex: Integer
      read FButtonExpandImageIndex write FButtonExpandImageIndex;
  end;

  TspSkinTreeView = class(TspSkinCustomTreeView)
  published
    property DrawSkin;
    property ButtonImageList;
    property ButtonExpandImageIndex;
    property ButtonNoExpandImageIndex;
    property ItemSkinDataName;
    property CheckSkinDataName;
    property Items;
    property HScrollBar;
    property VScrollBar;
    property DefaultFont;
    property UseSkinFont;
    property SkinData;
    property SkinDataName;
    property DefaultColor;

    property Align;
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property ChangeDelay;
    property Color;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HotTrack;
    property Images;
    property Indent;
    {$IFDEF VER140}
    property MultiSelect;
    property MultiSelectStyle;
    {$ENDIF}

   {$IFDEF VER150}
    property MultiSelect;
    property MultiSelectStyle;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property RowSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ToolTips;
    property Visible;
    {$IFDEF VER140}
    property OnAddition;
    {$ENDIF}
    {$IFDEF VER150}
    property OnAddition;
    {$ENDIF}
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;
    {$IFDEF VER140}
    property OnCreateNodeClass;
    {$ENDIF}
    {$IFDEF VER150}
    property OnCreateNodeClass;
    {$ENDIF}
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding;
    property OnExpanded;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspDrawHeaderSectionEvent = procedure (Cnvs: TCanvas; Column: TListColumn;
                                Pressed: Boolean; R: TRect) of object;

  TspDrawSkinSubItemEvent = procedure(Sender: TCustomListView;
     Item: TListItem; SubItemIndex: Integer; State: TCustomDrawState;
     ACanvas: TCanvas; ADrawRect: TRect) of object;

  TspSkinCustomListView = class(TCustomListView)
  protected
    FOnDrawSkinSubItem: TspDrawSkinSubItemEvent;
    
    FThirdImages, FThirdImageWidth, FThirdImageHeight,
    FThirdImagesCount: Integer;

    FLineColor: TColor;
    FItemSkinDataName: String;
    FCheckSkinDataName: String;
    FDrawSkin: Boolean;
    FDrawSkinLines: Boolean;
    FDevDown: Boolean;
    FHeaderSkinDataName: String;
    FInCheckScrollBars: Boolean;
    FromSB: Boolean;
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultColor: TColor;
    //
    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;
    FOldVScrollBarPos: Integer;
    FOldHScrollBarPos: Integer;
    //
    FHeaderHandle: HWND;
    FHeaderInstance: Pointer;
    FDefHeaderProc: Pointer;
    FActiveSection: Integer;
    FHeaderDown: Boolean;
    FHeaderInDivider: Boolean;
    //
    FHIndex: Integer;
    HLTPt, HRTPt, HLBPt, HRBPt: TPoint;
    HSkinRect, HClRect: TRect;
    HNewLTPoint, HNewRTPoint, HNewLBPoint, HNewRBPoint: TPoint;
    HNewClRect: TRect;
    HPicture: TBitMap;
    HFontColor, HActiveFontColor, HDownFontColor: TColor;
    HActiveSkinRect, HDownSkinRect: TRect;
    HStretchEffect: Boolean;
    HLeftStretch, HTopStretch, HRightStretch, HBottomStretch: Boolean;
    HStretchType: TspStretchType;
    //
    FOnDrawHeaderSection: TspDrawHeaderSectionEvent;
    //
    procedure SetDrawSkin(Value: Boolean); virtual;
    procedure SetDrawSkinLines(Value: Boolean);
    procedure HGetSkinData;
    function GetHeaderSectionRect(Index: Integer): TRect;
    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure SetDefaultColor(Value: TColor);
    procedure SetDefaultFont(Value: TFont);
    procedure SetSkinData(Value: TspSkinData);

    procedure UpDateScrollBars1;
    procedure UpDateScrollBars2;
    procedure UpDateScrollBars3;
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHITTEST(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WndProc(var Message: TMessage); override;
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    //
    procedure HeaderWndProc(var Message: TMessage);
    procedure DrawHeaderSection(Cnvs: TCanvas; Column: TListColumn;
      Active, Pressed: Boolean; R: TRect);
    procedure PaintHeader(DC: HDC);
    procedure CreateWnd; override;
    //
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
    procedure CMSEPaint(var Message: TMessage); message CM_SEPAINT;
    procedure Change(Item: TListItem; Change: Integer); override;

    procedure NewCustomDrawItem(Sender: TCustomListView;
     Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpDateScrollBars;
    procedure ChangeSkinData;
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;

    property DrawSkin: Boolean
      read FDrawSkin write SetDrawSkin;

    property DrawSkinLines: Boolean read FDrawSkinLines write SetDrawSkinLines;

    property ItemSkinDataName: String
      read FItemSkinDataName write FItemSkinDataName;

    property CheckSkinDataName: String
      read FCheckSkinDataName write FCheckSkinDataName;

    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;
    property HeaderSkinDataName: String
      read FHeaderSkinDataName write FHeaderSkinDataName;
    property OnDrawHeaderSection: TspDrawHeaderSectionEvent
      read FOnDrawHeaderSection write FOnDrawHeaderSection;
    property OnDrawSkinSubItem: TspDrawSkinSubItemEvent
      read FOnDrawSkinSubItem write FOnDrawSkinSubItem;
  end;

  TspSkinListView = class(TspSkinCustomListView)
  published
    property DrawSkin;
    property DrawSkinLines;
    property ItemSkinDataName;
    property CheckSkinDataName;
    property DefaultFont;
    property DefaultColor;
    property UseSkinFont;
    property SkinData;
    property SkinDataName;
    property Anchors;
    property Action;
    property Align;
    property AllocBy;
    property BiDiMode;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullDrag;
    property GridLines;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property HoverTime;
    property IconOptions;
    property Items;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ReadOnly default False;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property ShowWorkAreas;
    property ShowHint;
    property SmallImages;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;
    property HeaderSkinDataName;
    property HScrollBar;
    property VScrollBar;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnDrawHeaderSection;
    property OnDrawSkinSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSubItemImage;
    property OnDragDrop;
    property OnDragOver;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
  end;
      
  TspStatusPanelNumGlyphs = 1..2;

  TspSkinStatusPanel = class(TspSkinLabel)
  private
    FImageList: TCustomImageList;
    FImageIndex: Integer;
    FGlyph: TBitMap;
    FNumGlyphs: TspStatusPanelNumGlyphs;
    procedure SetNumGlyphs(Value: TspStatusPanelNumGlyphs);
    procedure SetGlyph(Value: TBitMap);
    procedure SetImageIndex(Value: Integer);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    function CalcWidthOffset: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ImageList: TCustomImageList read FImageList write FImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspStatusPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
  end;

  TspSkinRichEdit = class(TCustomRichEdit)
  protected
    FTransparent: Boolean;
    FWallpaper: TBitMap;
    FWallpaperStretch: Boolean;
    FSkinSupport: Boolean;
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDefaultFont: TFont;
    FDefaultColor: TColor;
    //
    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;
    FOldVScrollBarPos: Integer;
    FOldHScrollBarPos: Integer;

    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure SetDefaultColor(Value: TColor);
    procedure SetDefaultFont(Value: TFont);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetWallPaper(Value: TBitmap);
    procedure SetWallPaperStretch(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    function VScrollDisabled: boolean;
    function HScrollDisabled: boolean;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHITTEST(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WMPAINT(var Message: TWMPAINT); message WM_PAINT;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure WndProc(var Message: TMessage); override;
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);
    procedure DrawBackGround(C: TCanvas);
    procedure Loaded; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure OnVScrollBarUpButtonClick(Sender: TObject);
    procedure OnVScrollBarDownButtonClick(Sender: TObject);
    procedure Change; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpDateScrollBars;
    procedure ChangeSkinData;
  published
    property ScrollBars;
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property Color;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property SkinSupport: Boolean read FSkinSupport write FSkinSupport;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property Wallpaper: TBitMap read FWallpaper write SetWallpaper;
    property WallpaperStretch: Boolean read FWallpaperStretch write SetWallpaperStretch;
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspGraphicSkinControl = class(TGraphicControl)
  protected
    FSD: TspSkinData;
    FAreaName: String;
    FSkinDataName: String;
    FDrawDefault: Boolean;
    CursorIndex: Integer;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FUseSkinCursor: Boolean;
    FHintTitle: String;
    FHintImageIndex: Integer;
    FHintImageList: TCustomImageList;
    procedure SetAlphaBlend(AValue: Boolean); virtual;
    procedure SetAlphaBlendValue(AValue: Byte); virtual;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure GetSkinData; virtual;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure SetSkinData(Value: TspSkinData); virtual;

    procedure CreateControlDefaultImage(B: TBitMap); virtual;
    procedure CreateControlSkinImage(B: TBitMap); virtual;

  public
    FIndex: Integer;
    procedure ChangeSkinData; virtual;
    procedure BeforeChangeSkinData; virtual;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
  published
    property HintTitle: String read FHintTitle write FHintTitle;
    property HintImageIndex: Integer read FHintImageIndex write FHintImageIndex;
    property HintImageList: TCustomImageList read FHintImageList write FHintImageList;
    property Anchors;
    property Visible;
    property DrawDefault: Boolean
      read FDrawDefault write FDrawDefault;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property AreaName: String read FAreaName write FAreaName;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property AlphaBlend: Boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte
      read FAlphaBlendValue write SetAlphaBlendValue;
    property UseSkinCursor: Boolean read FUseSkinCursor write FUseSkinCursor;
  end;

  TspGraphicSkinCustomControl = class(TspGraphicSkinControl)
  protected
    FDefaultWidth: Integer;
    FDefaultHeight: Integer;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;

    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    NewClRect: TRect;
    Picture: TBitMap;
    ResizeMode: Integer;
    StretchEffect: Boolean;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchType: TspStretchType;
    procedure OnDefaultFontChange(Sender: TObject);
    procedure SetDefaultWidth(Value: Integer);
    procedure SetDefaultHeight(Value: Integer);
    procedure SetDefaultFont(Value: TFont);
    procedure DefaultFontChange; virtual;
    function GetNewRect(R: TRect): TRect;
    function GetResizeMode: Integer;
    procedure CalcSize(var W, H: Integer); virtual;

    procedure CreateSkinControlImage(B, SB: TBitMap; R: TRect);

    procedure GetSkinData; override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    function GetRealClientWidth: Integer;
    function GetRealClientHeight: Integer;
    function GetRealClientLeft: Integer;
    function GetRealClientTop: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
    property RealClientRect: TRect read NewClRect;
    property RealClientWidth: integer read GetRealClientWidth;
    property RealClientHeight: integer read GetRealClientHeight;
    property RealClientLeft: integer read GetRealClientLeft;
    property RealClientTop: integer read GetRealClientTop;
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
  end;

  TspSkinSpeedButton = class(TspGraphicSkinCustomControl)
  protected
    // checked
    FCheckedMode: Boolean;
    FStopMouseUp: Boolean;
    // animation
    AnimateTimer: TTimer;
    CurrentFrame: Integer;
    AnimateInc: Boolean;
    //
    FSkinImagesMenu: TspSkinImagesMenu;
    FUseImagesMenuImage: Boolean;
    FUseImagesMenuCaption: Boolean;
    FDrawColorMarker: Boolean;
    FColorMarkerValue: TColor;
    //
    FUseSkinSize: Boolean;
    FUseSkinFontColor: Boolean;
    FButtonImages: TCustomImageList;
    FImageIndex: Integer;
    RepeatTimer: TTimer;
    FRepeatMode: Boolean;
    FRepeatInterval: Integer;
    FFlat: Boolean;
    FAllowAllUp: Boolean;
    FAllowAllUpCheck: Boolean;
    FClicksDisabled: Boolean;
    FMorphKf: Double;
    FDown: Boolean;
    FMouseIn, FMouseDown: Boolean;
    FGroupIndex: Integer;
    FGlyph: TBitMap;
    FNumGlyphs: TspNumGlyphs;
    FMargin: Integer;
    FSpacing: Integer;
    FLayout: TspButtonLayout;
    MorphTimer: TTimer;
    FWidthWithCaption: Integer;
    FWidthWithoutCaption: Integer;
    FShowCaption: Boolean;
    FOnPaint: TspButtonPaintEvent;
    //
    procedure SetTempTransparent(Value: Boolean); virtual;
    function IsTransparent: Boolean;
    //
    procedure SetCheckedMode(Value: Boolean);
    //
    procedure StartAnimate(AInc: Boolean);
    procedure StopAnimate;
    procedure DoAnimate(Sender: TObject);
    function GetAnimationFrameRect: TRect;
    //
    function GetGlyphNum(AIsDown, AIsMouseIn: Boolean): Integer;
    procedure SetShowCaption(const Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure RepeatTimerProc(Sender: TObject);
    procedure BeforeRepeatTimerProc(Sender: TObject);
    procedure StartRepeat;
    procedure StopRepeat;
    procedure SetFlat(Value: Boolean);
    procedure StartMorph;
    procedure StopMorph;
    procedure DoMorph(Sender: TObject);
    procedure CreateStrechButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean);
    procedure CreateButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean); virtual;
    procedure SetLayout(Value : TspButtonLayout);
    procedure SetGroupIndex(Value: Integer);
    procedure SetDown(Value: Boolean);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
    procedure DoAllUp;
    procedure SetNumGlyphs(Value: TspNumGlyphs);
    procedure SetGlyph(Value: TBitMap);
    procedure GetSkinData; override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ReDrawControl;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure CalcSize(var W, H: Integer); override;
    function EnableMorphing: Boolean;
    function EnableAnimation: Boolean;
    procedure DrawMenuMarker(C: TCanvas; R: TRect; AActive, ADown: Boolean; AFlat: Boolean);
     //
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure SetSkinImagesMenu(Value: TspSkinImagesMenu);
    procedure OnImagesMenuChanged(Sender: TObject);
    property SkinImagesMenu: TspSkinImagesMenu
     read FSkinImagesMenu write SetSkinImagesMenu;
    property UseImagesMenuImage: Boolean
      read FUseImagesMenuImage write FUseImagesMenuImage;
    property UseImagesMenuCaption: Boolean
      read FUseImagesMenuCaption write FUseImagesMenuCaption;
    procedure Loaded; override;  
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, DisabledFontColor: TColor;
    ActiveSkinRect, DownSkinRect, DisabledSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    //
    MenuMarkerRect,
    MenuMarkerActiveRect,
    MenuMarkerDownRect: TRect;
    MenuMarkerFlatRect: TRect;
    MenuMarkerTransparentColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
    procedure ButtonClick; virtual;
    procedure RefreshButton;
  published
    property CheckedMode: Boolean read FCheckedMode write SetCheckedMode;
    property ImageList: TCustomImageList read FButtonImages write FButtonImages;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property UseSkinFontColor: Boolean read FUseSkinFontColor write FUseSkinFontColor;
    property WidthWithCaption: Integer
     read FWidthWithCaption write FWidthWithCaption;
    property WidthWithoutCaption: Integer
      read FWidthWithoutCaption write FWidthWithoutCaption;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property RepeatMode: Boolean read FRepeatMode write FRepeatMode;
    property RepeatInterval: Integer
      read  FRepeatInterval write FRepeatInterval;
    property Flat: Boolean read FFlat write SetFlat;
    property AllowAllUp: Boolean read FAllowAllUp write FAllowAllUp;
    property PopupMenu;
    property ShowHint;
    property Action;
    property Down: Boolean read FDown write SetDown;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Caption;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption;
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Align;
    property Margin: Integer read FMargin write SetMargin default -1;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Layout: TspButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Enabled;
    property OnPaint: TspButtonPaintEvent
      read FOnPaint write FOnPaint;
    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;


  TspTrackPosition = (sptpRight, sptpBottom);

  TspSkinMenuSpeedButton = class(TspSkinSpeedButton)
  protected
    FOnShowTrackMenu: TNotifyEvent;
    FOnHideTrackMenu: TNotifyEvent;
    FTrackButtonMode: Boolean;
    FMenuTracked: Boolean;
    FSkinPopupMenu: TspSkinPopupMenu;
    FNewStyle: Boolean;
    FTrackPosition: TspTrackPosition;

    procedure CreateButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean); override;

    function CanMenuTrack(X, Y: Integer): Boolean;
    procedure TrackMenu;
    procedure SetTrackButtonMode(Value: Boolean);
    procedure GetSkinData; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMCLOSESKINMENU(var Message: TMessage); message WM_CLOSESKINMENU;
    function GetNewTrackButtonRect: TRect;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinResizeImage(B: TBitMap; ADown, AMouseIn: Boolean);
    procedure CreateControlSkinResizeImage2(B: TBitMap; ADown, AMouseIn: Boolean);
    procedure CreateNewStyleControlSkinResizeImage(B: TBitMap; ADown, AMouseIn: Boolean);
    procedure OnImagesMenuClose(Sender: TObject);
    procedure CreateNewStyleControlDefaultImage(B: TBitMap);
    procedure SetNewStyle(Value: Boolean);
    procedure SetTrackPosition(Value: TspTrackPosition);
    procedure DrawResizeButton(ButtonData: TspDataSkinButtonControl; C: TCanvas; ButtonR: TRect; AMouseIn, ADown: Boolean);
  public
    TrackButtonRect: TRect;
    FDrawStandardArrow: Boolean;
    FArrowType: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property NewStyle: Boolean read FNewStyle write SetNewStyle;
    property TrackPosition: TspTrackPosition
      read FTrackPosition write SetTrackPosition;

    property SkinImagesMenu;
    property UseImagesMenuImage;
    property UseImagesMenuCaption;

    property SkinPopupMenu: TspSkinPopupMenu read FSkinPopupMenu
                                             write FSkinPopupMenu;
    property TrackButtonMode: Boolean read FTrackButtonMode
                                      write SetTrackButtonMode;
    property OnShowTrackMenu: TNotifyEvent read FOnShowTrackMenu
                                           write FOnShowTrackMenu;
    property OnHideTrackMenu: TNotifyEvent read FOnHideTrackMenu
                                           write FOnHideTrackMenu;
  end;

  TspCustomDrawSkinSectionEvent = procedure(HeaderControl: THeaderControl;
    Section: THeaderSection; const Rect: TRect; Active, Pressed: Boolean;
    Cnvs: TCanvas) of object;

  TspSkinHeaderControl = class(THeaderControl)
  protected
    //
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultHeight: Integer;
    //
    InDivider: Boolean;
    FDown: Boolean;
    FDownInDivider: Boolean;
    FInTracking: Boolean;
    FActiveSection, FOldActiveSection: Integer;
    FOnSkinSectionClick: TSectionNotifyEvent;
    FOnDrawSkinSection: TspCustomDrawSkinSectionEvent;
    procedure SetDefaultHeight(Value: Integer);
    function GetSkinItemRect(Index: Integer): TRect;
    procedure PaintWindow(DC: HDC); override;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    function DrawSkinSection(Cnvs: TCanvas; Index: Integer; Active, Pressed: Boolean): TRect;
    procedure DrawSkinSectionR(Cnvs: TCanvas; Section: THeaderSection; Active, Pressed: Boolean; R: TRect);
     procedure CreateParams(var Params: TCreateParams); override;
    procedure TestActive(X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WndProc(var Message:TMessage); override;
    procedure CreateWnd; override;
    procedure DrawSection(Section: THeaderSection; const Rect: TRect;
      Pressed: Boolean); override;
    procedure SetDefaultFont(Value: TFont);
    procedure SetSkinData(Value: TspSkinData);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
  public
    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    NewClRect: TRect;
    Picture: TBitMap;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor: TColor;
    ActiveSkinRect, DownSkinRect: TRect;
    StretchEffect: Boolean;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchType: TspStretchType;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetSkinData;
    procedure ChangeSkinData;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override; 
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property OnSkinSectionClick: TSectionNotifyEvent
      read FOnSkinSectionClick write FOnSkinSectionClick;
    property OnDrawSkinSection: TspCustomDrawSkinSectionEvent
      read FOnDrawSkinSection write FOnDrawSkinSection;
  end;

  TspNumThumbStates = 1..2;
  TspSliderOrientation = (soHorizontal, soVertical);
  TspSliderOption = (soShowFocus, soShowPoints, soSmooth,
                     soRulerOpaque, soThumbOpaque);
  TspSliderOptions = set of TspSliderOption;
  TspSliderImage = (siHThumb, siHRuler, siVThumb, siVRuler);
  TspSliderImages = set of TspSliderImage;
  TspSliderImageArray = array[TspSliderImage] of TBitmap;
  TspJumpMode = (jmNone, jmHome, jmEnd, jmNext, jmPrior);

  TspSkinCustomSlider = class(TspSkinControl)
  private
    FThumbImageList: TCustomImageList;
    FThumbImageIndex: Integer;
    FThumbActiveImageIndex: Integer;
    FUseSkinThumb: Boolean;
    FTransparent: Boolean;
    FUserImages: TspSliderImages;
    FImages: TspSliderImageArray;
    FEdgeSize: Integer;
    FRuler: TBitmap;
    FPaintBuffered: Boolean;
    FRulerOrg: TPoint;
    FThumbRect: TRect;
    FThumbDown: Boolean;
    FNumThumbStates: TspNumThumbStates;
    FPointsRect: TRect;
    FOrientation: TspSliderOrientation;
    FOptions: TspSliderOptions;
    FBevelWidth: Integer;
    FMinValue: Longint;
    FMaxValue: Longint;
    FIncrement: Longint;
    FValue: Longint;
    FHit: Integer;
    FFocused: Boolean;
    FSliding: Boolean;
    FTracking: Boolean;
    FTimerActive: Boolean;
    FMousePos: TPoint;
    FStartJump: TspJumpMode;
    FReadOnly: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanged: TNotifyEvent;
    FOnDrawPoints: TNotifyEvent;
    procedure SetTransparent(Value: Boolean);
    function GetImage(Index: Integer): TBitmap;
    procedure SetImage(Index: Integer; Value: TBitmap);
    procedure SliderImageChanged(Sender: TObject);
    procedure SetEdgeSize(Value: Integer);
    function GetNumThumbStates: TspNumThumbStates;
    procedure SetNumThumbStates(Value: TspNumThumbStates);
    procedure SetOrientation(Value: TspSliderOrientation);
    procedure SetOptions(Value: TspSliderOptions);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetIncrement(Value: Longint);
    procedure SetReadOnly(Value: Boolean);
    function GetThumbOffset: Integer;
    procedure SetThumbOffset(Value: Integer);
    procedure SetValue(Value: Longint);
    procedure ThumbJump(Jump: TspJumpMode);
    function GetThumbPosition(var Offset: Integer): TPoint;
    function JumpTo(X, Y: Integer): TspJumpMode;
    procedure InvalidateThumb;
    procedure StopTracking;
    procedure TimerTrack;
    function StoreImage(Index: Integer): Boolean;
    procedure CreateElements;
    procedure BuildRuler(R: TRect);
    procedure BuildSkinRuler(R: TRect);
    procedure AdjustElements;
    procedure ReadUserImages(Stream: TStream);
    procedure WriteUserImages(Stream: TStream);
    procedure InternalDrawPoints(ACanvas: TCanvas; PointsStep, PointsHeight,
      ExtremePointsHeight: Longint);
    procedure DrawThumb(Canvas: TCanvas; Origin: TPoint; Highlight: Boolean);
    procedure DrawSkinThumb(Canvas: TCanvas; Origin: TPoint; Highlight: Boolean);
    procedure DrawImageThumb(Canvas: TCanvas; Origin: TPoint; Highlight: Boolean);
    function GetValueByOffset(Offset: Integer): Longint;
    function GetOffsetByValue(Value: Longint): Integer;
    function GetRulerLength: Integer;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Message: TMessage); message WM_TIMER;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
 protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function CanModify: Boolean; virtual;
    function GetSliderRect: TRect; virtual;
    function GetSliderValue: Longint; virtual;
    procedure Change; dynamic;
    procedure Changed; dynamic;
    procedure Sized; virtual;
    procedure RangeChanged; virtual;
    procedure SetRange(Min, Max: Longint);
    procedure ThumbMouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual;
    procedure ThumbMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure ThumbMouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual;
    property ThumbOffset: Integer read GetThumbOffset write SetThumbOffset;
    property SliderRect: TRect read GetSliderRect;
    property ImageHThumb: TBitmap index Ord(siHThumb) read GetImage
      write SetImage stored StoreImage;
    property ImageHRuler: TBitmap index Ord(siHRuler) read GetImage
      write SetImage  stored StoreImage;
    property ImageVThumb: TBitmap index Ord(siVThumb) read GetImage
      write SetImage stored StoreImage;
    property ImageVRuler: TBitmap index Ord(siVRuler) read GetImage
      write SetImage stored StoreImage;
    property NumThumbStates: TspNumThumbStates read GetNumThumbStates
      write SetNumThumbStates default 2;
    property Orientation: TspSliderOrientation read FOrientation
      write SetOrientation default soHorizontal;
    property EdgeSize: Integer read FEdgeSize write SetEdgeSize default 2;
    property Options: TspSliderOptions read FOptions write SetOptions
      default [soShowFocus, soShowPoints, soSmooth];
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnDrawPoints: TNotifyEvent read FOnDrawPoints write FOnDrawPoints;
    procedure GetSkinData; override;
  public
    HRulerRect: TRect;
    HThumbRect: TRect;
    VRulerRect: TRect;
    VThumbRect: TRect;
    SkinEdgeSize: Integer;
    BGColor: TColor;
    PointsColor: TColor;
    Picture: TBitMap;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure DefaultDrawPoints(PointsStep, PointsHeight,
      ExtremePointsHeight: Longint); virtual;
    procedure ChangeSkinData; override;
    property Canvas;
    property Increment: Longint read FIncrement write SetIncrement default 10;
    property MinValue: Longint read FMinValue write SetMinValue default 0;
    property MaxValue: Longint read FMaxValue write SetMaxValue default 100;
    property Value: Longint read FValue write SetValue default 0;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property UseSkinThumb: Boolean read FUseSkinThumb write FUseSkinThumb;
    property ThumbImageList: TCustomImageList
      read FThumbImageList write FThumbImageList;
    property ThumbImageIndex: Integer
      read FThumbImageIndex write FThumbImageIndex;
    property ThumbActiveImageIndex: Integer
      read FThumbActiveImageIndex write FThumbActiveImageIndex;
  end;

{ TspSlider }

  TspSkinSlider = class(TspSkinCustomSlider)
  published
    property ThumbImageList;
    property ThumbImageIndex;
    property ThumbActiveImageIndex;
    property Align;
    property Color;
    property Cursor;
    property DragMode;
    property DragCursor;
    property Enabled;
    property ImageHThumb;
    property ImageHRuler;
    property ImageVThumb;
    property ImageVRuler;
    property Increment;
    property MinValue;
    property MaxValue;
    property NumThumbStates;
    property Orientation;
    property EdgeSize;
    property Options;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Value;
    property Transparent;
    property UseSkinThumb;
    property Visible;
    property Anchors;
    property Constraints;
    property DragKind;
    property OnChange;
    property OnChanged;
    property OnDrawPoints;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnKeyDown;
    property OnKeyUp;
    property OnKeyPress;
    property OnDragOver;
    property OnDragDrop;
    property OnEndDrag;
    property OnStartDrag;
    property OnContextPopup;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnEndDock;
    property OnStartDock;
  end;

  TspSkinBevel = class(TBevel)
  protected
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDividerMode: Boolean;
    procedure SetDividerMode(Value: Boolean);
    procedure SetSkinData(Value: TspSkinData);
  public
    LightColor, DarkColor: TColor;
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure ChangeSkinData;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property DividerMode: Boolean read FDividerMode write SetDividerMode;
  end;

  TspSkinButtonsBar = class;
  TspButtonBarSection = class;
  TspButtonBarItems = class;

  TspButtonBarItem = class(TCollectionItem)
  private
    FText: String;
    FImageIndex: Integer;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FTag: Integer;
    FLayout: TspButtonLayout;
    FMargin: Integer;
    FSpacing: Integer;
    FHint: String;
    FEnabled: Boolean;
    procedure SetText(const Value: string);
    procedure SetImageIndex(const Value: Integer);
    procedure ItemClick(const Value: TNotifyEvent);
    procedure ItemDBlClick(const Value: TNotifyEvent);
    procedure SetLayout(Value: TspButtonLayout);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
  protected
    function GetDisplayName: string; override;
    procedure Click;
    procedure DblClick;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property Text: string read FText write SetText;
    property Hint: string read FHint write FHint;
    property ImageIndex:integer read FImageIndex write SetImageIndex;
    property Tag: Integer read FTag write FTag;
    property Layout: TspButtonLayout read FLayout write SetLayout;
    property Margin: Integer read FMargin write SetMargin;
    property Spacing: Integer read FSpacing write SetSpacing;
    property OnClick:TNotifyEvent read FonClick write ItemClick;
    property OnDblClick:TNotifyEvent read FonDblClick write ItemDblClick;
  end;


  TspButtonBarItems = class(TCollection)
  private
    FSection: TspButtonBarSection;
    function GetItem(Index: Integer): TspButtonBarItem;
    procedure SetItem(Index: Integer; Value: TspButtonBarItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Section: TspButtonBarSection);
    function Add: TspButtonBarItem;
    property Items[Index: Integer]: TspButtonBarItem read GetItem write SetItem; default;
  end;

  TspButtonBarSection = class(TCollectionItem)
  private
    FText: string;
    FItems: TspButtonBarItems;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FImageIndex: Integer;
    FTag: Integer;
    FHint: String;
    FMargin: Integer;
    FSpacing: Integer;
    FEnabled: Boolean;
    procedure SetText(const Value: string);
    procedure SetItems(const Value: TspButtonBarItems);
    procedure SectionClick(const Value: TNotifyEvent);
    procedure SectionDblClick(const Value: TNotifyEvent);
    procedure SetImageIndex(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
  protected
    function GetDisplayName: string; override;
    procedure Click;
    procedure DblClick;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property Text: string read FText write SetText;
    property Hint: string read FHint write FHint;
    property Items: TspButtonBarItems read FItems write SetItems;
    property Tag: Integer read FTag write FTag;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Margin: Integer read FMargin write SetMargin;
    property Spacing: Integer read FSpacing write SetSpacing;
    property OnClick:TNotifyEvent read FOnClick write SectionClick;
    property OnDblClick:TNotifyEvent read FOnDblClick write SectionDblClick;
  end;

  TspButtonBarSections = class(TCollection)
  private
    FButtonsBar: TspSkinButtonsBar;
    function GetItem(Index: Integer): TspButtonBarSection;
    procedure SetItem(Index: Integer; Value: TspButtonBarSection);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    function GetButtonsBar: TspSkinButtonsBar;
    constructor Create(ButtonsBar: TspSkinButtonsBar);
    function Add: TspButtonBarSection;
    property Items[Index: Integer]: TspButtonBarSection read GetItem write SetItem; default;
  end;

  TspSectionButton = class(TspSkinSpeedButton)
  private
    FItemIndex: Integer;
    FButtonsBar: TspSkinButtonsBar;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;  
  public
    constructor CreateEx(AOwner: TComponent; AButtonsBar: TspSkinButtonsBar; AIndex: Integer);
    procedure ButtonClick; override;
  end;

  TspSectionItem = class(TspSkinSpeedButton)
  private
    FItemIndex: Integer;
    FButtonsBar: TspSkinButtonsBar;
    FSectionIndex: Integer;
  protected
    FWebStyle: Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SetTempTransparent(Value: Boolean); override;
  public
    constructor CreateEx(AOwner: TComponent; AButtonsBar: TspSkinButtonsBar; ASectionIndex, AIndex: Integer; AWebStyle: Boolean);
    procedure ButtonClick; override;
    procedure Paint; override;
  end;

  TspSkinButtonsBar = class(TspSkinPanel)
  private
    FItemGlowEffect: Boolean;
    FShowSelectedItem: Boolean;
    FOnChanging: TNotifyEvent;
    FOnChange: TNotifyEvent;
    FWebStyle: Boolean;
    FShowItemHint: Boolean;
    FShowButtons: Boolean;
    FDefaultSectionFont: TFont;
    FDefaultItemFont: TFont;
    FUpButton, FDownButton: TspSkinButton;
    TopIndex: Integer;
    VisibleCount: Integer;
    FItemHeight: Integer;
    FItemsTransparent: Boolean;
    FItemsPanel: TspSkinPanel;
    FSections: TspButtonBarSections;
    FSectionIndex: Integer;
    FItemImages: TCustomImageList;
    FSectionImages: TCustomImageList;
    FSectionButtonSkinDataName: String;
    FDefaultButtonHeight: Integer;
    procedure SetShowButtons(Value: Boolean);
    procedure SetDefaultButtonHeight(Value: Integer);
    procedure SetDefaultSectionFont(Value: TFont);
    procedure SetDefaultItemFont(Value: TFont);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemsTransparent(Value: Boolean);
    procedure SetSections(Value: TspButtonBarSections);
    procedure UpdateSection(Index: Integer);
    procedure UpdateSections;
    procedure UpdateItems;
    procedure SetSectionIndex(const Value: integer);
    procedure SetItemImages(const Value: TCustomImageList);
    procedure SetSectionImages(const Value: TCustomImageList);
    procedure CheckVisibleItems;
    procedure OnItemPanelResize(Sender: TObject);
  protected
    FItemIndex: Integer;
    procedure CreateWnd; override;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure ClearSections;
    procedure ClearItems;
  procedure ArangeItems;
    procedure ShowUpButton;
    procedure ShowDownButton;
    procedure HideUpButton;
    procedure HideDownButton;
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure SetItemIndex2(ASectionIndex, AItemIndex: Integer);
  public
    FSectionButtons: TList;
    FSectionItems: TList;
    procedure OpenSection(Index: Integer);
    procedure ScrollUp;
    procedure ScrollDown;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent:TComponent; Operation:TOperation);override;
    procedure UpDateSectionButtons;
    procedure ChangeSkinData; override;
    function GetItemIndex: Integer;
    procedure SetItemIndex(ASectionIndex, AItemIndex: Integer);
     //
    procedure AddItem(ASectionIndex: Integer;
                      AItem: TspButtonBarItem);
    procedure InsertItem(AItemIndex, ASectionIndex: Integer;
                         AItem: TspButtonBarItem);
    procedure DeleteItem(AItemIndex, ASectionIndex: Integer);
    //
  published
    property ItemGlowEffect: Boolean read FItemGlowEffect write FItemGlowEffect;
    property ShowSelectedItem: Boolean
      read FShowSelectedItem write FShowSelectedItem;
    property WebStyle: Boolean read FWebStyle write FWebStyle;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons;
    property ShowItemHint: Boolean read FShowItemHint write FShowItemHint;
    property DefaultSectionFont: TFont read FDefaultSectionFont write SetDefaultSectionFont;
    property DefaultButtonHeight: Integer
      read FDefaultButtonHeight write SetDefaultButtonHeight;
    property DefaultItemFont: TFont read FDefaultItemFont write SetDefaultItemFont;
    property Align default alLeft;
    property Enabled;
    property SectionButtonSkinDataName: String
      read FSectionButtonSkinDataName
      write FSectionButtonSkinDataName;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property ItemsTransparent: Boolean read FItemsTransparent write SetItemsTransparent;
    property ItemImages: TCustomImageList read FItemImages write SetItemImages;
    property SectionImages:TCustomImageList read FSectionImages write SetSectionImages;
    property Sections: TspButtonBarSections read FSections write SetSections;
    property SectionIndex:integer read FSectionIndex write SetSectionIndex;
    property PopupMenu;
    property ShowHint;
    property Hint;
    property Visible;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnContextPopup;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

  {TspSkinNoteBook}

  TspSkinPage = class(TspSkinPanel)
  private
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    FImageIndex: Integer;
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property Caption;
    property Height stored False;
    property TabOrder stored False;
    property Visible stored False;
    property Width stored False;
  end;

  TspSkinNotebook = class(TspSkinPanel)
  private
    FAccess: TStrings;
    FPageIndex: Integer;
    FOnPageChanged: TNotifyEvent;
    FButtonsMode: Boolean;
    FButtons: TList;
    FImages: TCustomImageList;
    FButtonSkinDataName: String;
    procedure SetImages(const Value: TCustomImageList);
    procedure ClearButtons;
    procedure SetPages(Value: TStrings);
    procedure SetActivePage(const Value: string);
    function GetActivePage: string;
    procedure SetPageIndex(Value: Integer);
    procedure SetButtonsMode(Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure CreateParams(var Params: TCreateParams); override;
    function GetChildOwner: TComponent; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure ReadState(Reader: TReader); override;
    procedure ShowControl(AControl: TControl); override;
    procedure UpdateButtons;
  public
    FPageList: TList;
    procedure UpdateButton(APageIndex: Integer; ACaption: String);
    procedure Loaded; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActivePage: string read GetActivePage write SetActivePage stored False;
    property ButtonsMode: Boolean read FButtonsMode write SetButtonsMode;
     property ButtonSkinDataName: String
      read FButtonSkinDataName
      write FButtonSkinDataName;
    property Images: TCustomImageList read FImages write SetImages;
    property Align;
    property Anchors;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Font;
    property Enabled;
    property Constraints;
    property PageIndex: Integer read FPageIndex write SetPageIndex default 0;
    property Pages: TStrings read FAccess write SetPages stored False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspPageButton = class(TspSkinSpeedButton)
  private
    FPageIndex: Integer;
    FNoteBook: TspSkinNoteBook;
  public
    constructor CreateEx(AOwner: TComponent; ANoteBook: TspSkinNoteBook; APageIndex: Integer);
    procedure ButtonClick; override;
  end;

 TspScrollType = (stHorizontal, stVertical);
 TspSkinScrollPanel = class(TspSkinControl)
 private
   FMouseIn: Boolean;
   FClicksDisabled: Boolean;
   FCanFocused: Boolean;
   FHotScroll: Boolean;
   TimerMode: Integer;
   SMax, SPosition, SPage, SOldPosition: Integer;
   FAutoSize: Boolean;
   FVSizeOffset: Integer;
   FHSizeOffset: Integer;
   FScrollType: TspScrollType;
   FScrollOffset: Integer;
   FScrollTimerInterval: Integer;
   Buttons: array[0..1] of TspControlButton;
   PanelData: TspDataSkinPanelControl;
   ButtonData: TspDataSkinButtonControl;
   procedure SetScrollType(Value: TspScrollType);
   procedure SetScrollOffset(Value: Integer);
   procedure SetScrollTimerInterval(Value: Integer);
   procedure DrawButton(Cnvs: TCanvas; i: Integer);
   procedure SetPosition(const Value: integer);
   function CheckActivation: Boolean;
 protected
   procedure GetSkinData; override;
   procedure KeyDown(var Key: Word; Shift: TShiftState); override;
   procedure WMSETCURSOR(var Message: TWMSetCursor); message WM_SetCursor;
   procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
   procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
   procedure WMTimer(var Message: TWMTimer); message WM_Timer;
   procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
   procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
   procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
   procedure CMMouseEnter;
   procedure CMMouseLeave;
   procedure CreateControlDefaultImage(B: TBitMap); override;
   procedure CreateControlSkinImage(B: TBitMap); override;
   procedure WndProc(var Message: TMessage); override;
   procedure SetButtonsVisible(AVisible: Boolean);
   procedure ButtonClick(I: Integer);
   procedure ButtonDown(I: Integer);
   procedure ButtonUp(I: Integer);
   procedure GetHRange;
   procedure GetVRange;
   procedure VScrollControls(AOffset: Integer);
   procedure HScrollControls(AOffset: Integer);
   procedure AdjustClientRect(var Rect: TRect); override;
   procedure StartTimer;
   procedure StopTimer;
   procedure Loaded; override;
   procedure CMBENCPaint(var Message: TMessage); message CM_BENCPAINT;
   procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
   procedure WMDESTROY(var Message: TMessage); message WM_DESTROY;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Paint; override;
   procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
   procedure UpDateSize;
   procedure GetScrollInfo;
   property Position: Integer read SPosition write SetPosition;
 published
   property CanFocused: Boolean read FCanFocused write FCanFocused;
   property HotScroll: Boolean read FHotScroll write FHotScroll;
   property AutoSize: Boolean read FAutoSize write FAutoSize;
   property Align;
   property ScrollType: TspScrollType read FScrollType write SetScrollType;
   property ScrollOffset: Integer read FScrollOffset write SetScrollOffset;
   property ScrollTimerInterval: Integer
     read FScrollTimerInterval write SetScrollTimerInterval;
 end;


  TspSkinSplitterEx = class(TspCustomSplitter)
  protected
    FDefaultSize: Integer;
  public
    LTPt, RTPt, LBPt: TPoint;
    SkinRect: TRect;
    FSkinPicture: TBitMap;
    StretchEffect: Boolean;
    GripperRect: TRect;
    GripperTransparent: Boolean;
    GripperTransparentColor: TColor;
    procedure GetSkinData; override;
    procedure ChangeSkinData; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property DefaultSize: Integer read FDefaultSize write FDefaultSize;
    property OnClick;
    property OnDblClick;
  end;


 procedure NotebookHandlesNeeded(Notebook: TspSkinNotebook);


implementation

{$R *.res}

Uses DynamicSkinForm, ActnList, SkinTabs, CommCtrl;


const
  MorphTimerInterval = 20;
  MorphInc = 0.2;

type
  TParentControl = class(TWinControl);

const
  ImagesResNames: array[TspSliderImage] of PChar =
    ('SP_HTB', 'SP_HRL', 'SP_VTB', 'SP_VRL');
  Indent = 6;
  JumpInterval = 400;

// Call HandleNeeded for each page in notebook.  Used to allow anchors to work
// on invisible pages.
procedure NotebookHandlesNeeded(Notebook: TspSkinNotebook);
var
  I: Integer;
begin
  if Notebook <> nil then
    for I := 0 to Notebook.FPageList.Count - 1 do
      with TspSkinPage(Notebook.FPageList[I]) do
      begin
        DisableAlign;
        try
          HandleNeeded;
          ControlState := ControlState - [csAlignmentNeeded];
        finally
          EnableAlign;
        end;
      end;
end;

constructor TspSkinControl.Create;
begin
  inherited Create(AOwner);
  FSD := nil;
  FAreaName := '';
  Frgn := 0;
  FIndex := -1;
  FDrawDefault := True;
  CursorIndex := -1;
  FAlphaBlend := False;
  FAlphaBlendValue := 200;
  FUseSkinCursor := False;
  FromWMPaint := False;
  FHintTitle := '';
  FHintImageIndex := 0;
  FHintImageList := nil;
end;

destructor TspSkinControl.Destroy;
begin
  inherited Destroy;
end;

procedure TspSkinControl.CheckControlsBackground;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  if Controls[i] is TWinControl
  then
    SendMessage(TWinControl(Controls[i]).Handle, WM_CHECKPARENTBG, 0, 0)
  else
  if Controls[i] is TGraphicControl
  then
    TGraphicControl(Controls[i]).Perform(WM_CHECKPARENTBG, 0, 0);
end;

procedure TspSkinControl.WMCHECKPARENTBG;
begin
  CheckParentBackground;
end;

procedure TspSkinControl.CheckParentBackground;
begin
  if AlphaBlend
  then
    begin
      RePaint;
      CheckControlsBackground;
    end;
end;

procedure TspSkinControl.SetAlphaBlend;
begin
  FAlphaBlend := AValue;
  RePaint;
end;

procedure TspSkinControl.SetAlphaBlendValue;
begin
  FAlphaBlendValue := AValue;
  RePaint;
end;

procedure TspSkinControl.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TspSkinControl.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TspSkinControl.WMPaint(var Msg: TWMPaint);
begin
  FromWMPaint := True;
  inherited;
  FromWMPaint := False;
end;

procedure TspSkinControl.WMEraseBkGnd;
begin
end;

procedure TspSkinControl.WMMOVE;
begin
  inherited;
  if AlphaBlend then RePaint;
end;

procedure TspSkinControl.BeforeChangeSkinData;
begin
  FIndex := -1;
end;

procedure TspSkinControl.ChangeSkinData;
begin
  GetSkinData;
  if FUseSkinCursor
  then 
  if CursorIndex <> -1
  then
    Cursor := FSD.StartCursorIndex + CursorIndex
  else
    Cursor := crDefault;
  RePaint;
end;

procedure TspSkinControl.SetSkinDataName;
begin
  FSkinDataName := Value;
end;

procedure TspSkinControl.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinControl.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
end;

procedure TspSkinControl.Paint;
var
  Buffer: TBitMap;
  ParentImage: TBitMap;
  PBuffer, PIBuffer: TspEffectBmp;
  kf: Double;
begin
  if (Width <= 0) or (Height <= 0) then Exit;
  GetSkinData;
  Buffer := TBitMap.Create;
  Buffer.Width := Width;
  Buffer.Height := Height;
  if FIndex <> -1
  then
    CreateControlSkinImage(Buffer)
  else
  if FDrawDefault
  then
    CreateControlDefaultImage(Buffer);
  if FAlphaBlend
  then
    begin
      ParentImage := TBitMap.Create;
      ParentImage.Width := Width;
      ParentImage.Height := Height;
      GetParentImage(Self, ParentImage.Canvas);
      PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
      PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
      kf := 1 - FAlphaBlendValue / 255;
      PBuffer.Morph(PIBuffer, Kf);
      PBuffer.Draw(Canvas.Handle, 0, 0);
      PBuffer.Free;
      PIBuffer.Free;
      ParentImage.Free;
    end
  else
    Canvas.Draw(0, 0, Buffer);
  Buffer.Free;
end;

procedure TspSkinControl.CreateControlDefaultImage;
begin
end;

procedure TspSkinControl.CreateControlSkinImage;
begin
end;

procedure TspSkinControl.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FHintImageList) then FHintImageList := nil;
end;

constructor TspSkinCustomControl.Create;
begin
  inherited Create(AOwner);
  FForceBackground := False;
  FDrawBackground := True;
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  StretchEffect := False;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FUseSkinFont := True;
end;


destructor TspSkinCustomControl.Destroy;
begin
  if FRgn <> 0
  then
    begin
      DeleteObject(FRgn);
      FRgn := 0;
    end;
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinCustomControl.Paint;
var
  LB, RB, TB, BB, ClB, Buffer2: TBitMap;
  SaveIndex, X, Y, XCnt, YCnt, w, h, w1, h1: Integer;
begin
  if (Width <= 0) or (Height <= 0) then Exit;
  GetSkinData;
  W := Width;
  H := Height;
  CalcSize(W, H);
  if (FIndex <> -1) and FForceBackground and (ResizeMode = 1) and
     not AlphaBlend
  then
    begin
     LB := TBitMap.Create;
      TB := TBitMap.Create;
      RB := TBitMap.Create;
      BB := TBitMap.Create;
      CreateSkinBorderImages(LtPt, RTPt, LBPt, RBPt, ClRect,
         NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewClRect,
         LB, TB, RB, BB, Picture, SkinRect, Width, Height,
           LeftStretch, TopStretch, RightStretch, BottomStretch);
      CreateControlSkinImage(TB);
      // draw backgound
      if FDrawBackground
      then
      begin
      w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      w1 := RectWidth(NewClRect);
      h1 := REctHeight(NewCLRect);
      XCnt := w1 div w;
      YCnt := h1 div h;
      Clb := TBitMap.Create;
      Clb.Width := w;
      Clb.Height := h;
      Clb.Canvas.CopyRect(Rect(0, 0, w, h), Picture.Canvas,
      Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
           SkinRect.Left + ClRect.Right,
           SkinRect.Top + ClRect.Bottom));
      SaveIndex := SaveDC(Canvas.Handle);
      IntersectClipRect(Canvas.Handle, NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NewClRect.Bottom);
      if StretchEffect
      then
        begin
          if (RectWidth(NewClRect) > 0) and (RectHeight(NewClRect) > 0) then
          case StretchType of
            spstFull:
              Canvas.StretchDraw(NewClRect, Clb);
            spstHorz:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := Clb.Width;
                Buffer2.Height := RectHeight(NewClRect);
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Clb);
                XCnt := RectWidth(NewClRect) div Buffer2.Width;
                 for X := 0 to XCnt do
                   Canvas.Draw(NewClRect.Left + X * Buffer2.Width, NewClRect.Top, Buffer2);
                 Buffer2.Free;
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := RectWidth(NewClRect);
                Buffer2.Height := Clb.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Clb);
                YCnt := RectHeight(NewClRect) div Buffer2.Height;
                for Y := 0 to YCnt do
                  Canvas.Draw(NewClRect.Left, NewClRect.Top + Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
          end;
        end
      else
        for X := 0 to XCnt do
        for Y := 0 to YCnt do
         begin
           Canvas.Draw(NewClRect.Left + X * w, NewClRect.Top + Y * h, Clb);
         end;
      Clb.Free;

      RestoreDC(Canvas.Handle, SaveIndex);
      end;
      //
      Canvas.Draw(0, 0, TB);
      Canvas.Draw(0, TB.Height, LB);
      Canvas.Draw(Width - RB.Width, TB.Height, RB);
      Canvas.Draw(0, Height - BB.Height, BB);
      LB.Free;
      TB.Free;
      RB.Free;
      BB.Free;
    end
  else
    inherited;
end;

function TspSkinCustomControl.GetRealClientWidth: integer;
begin
  Result := NewClRect.Right - NewClRect.Left;
end;

function TspSkinCustomControl.GetRealClientHeight: integer;
begin
  Result := NewClRect.Bottom - NewClRect.Top;
end;

function TspSkinCustomControl.GetRealClientLeft: integer;
begin
  Result := NewClRect.Left;
end;

function TspSkinCustomControl.GetRealClientTop: integer;
begin
  Result := NewClRect.Top;
end;

procedure TspSkinCustomControl.SetDefaultWidth;
begin
  FDefaultWidth := Value;
  if (FIndex = -1) and (FDefaultWidth > 0) then Width := FDefaultWidth;
end;

procedure TspSkinCustomControl.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;

procedure TspSkinCustomControl.DefaultFontChange;
begin
end;

procedure TspSkinCustomControl.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  DefaultFontChange;
end;

procedure TspSkinCustomControl.OnDefaultFontChange;
begin
  DefaultFontChange;
  if FIndex = -1 then RePaint;
end;

procedure TspSkinCustomControl.CreateControlDefaultImage;
var
  R: TRect;
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
end;

procedure TspSkinCustomControl.ChangeSkinData;
var
  W, H: Integer;
  UpDate: Boolean;
begin
  GetSkinData;

  if FUseSkinCursor
  then
  if CursorIndex <> -1
  then
    Cursor := FSD.StartCursorIndex + CursorIndex
  else
    Cursor := crDefault;

  W := Width;
  H := Height;

  if FIndex <> -1
  then
    begin
      CalcSize(W, H);
      Update := (W <> Width) or (H <> Height);
      if W <> Width then Width := W;
      if H <> Height then Height := H;
    end
  else
    begin
      UpDate := False;
      if FDefaultWidth > 0 then Width := FDefaultWidth;
      if FDefaultHeight > 0 then Height := FDefaultHeight;
    end;

  if (not UpDate) or (FIndex = -1)
  then
    begin
      SetControlRegion;
      RePaint;
    end;

end;

procedure TspSkinCustomControl.SetBounds;
var
  UpDate: Boolean;
  R: TRect;
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and (FIndex <> -1);
  if UpDate
  then
    begin
      CalcSize(AWidth, AHeight);
      if ResizeMode = 0 then NewClRect := ClRect;
    end;

  if Parent is TspSkinToolbar
  then
    begin
      if TspSkinToolbar(Parent).AdjustControls
      then
        with TspSkinToolbar(Parent) do
        begin
          R := GetSkinClientRect;
          ATop := R.Top + RectHeight(R) div 2 - AHeight div 2;
        end;
    end;

  inherited;
  if UpDate
  then
    begin
      SetControlRegion;
      RePaint;
    end;
  if (FIndex <> -1) and StretchEffect
  then
    Self.CheckControlsBackground;
end;

procedure TspSkinCustomControl.CalcSize;
var
  XO, YO: Integer;
begin
  if ResizeMode > 0
  then
    begin
      XO := W - RectWidth(SkinRect);
      YO := H - RectHeight(SkinRect);
      NewLTPoint := LTPt;
      case ResizeMode of
        1:
          begin
            NewRTPoint := Point(RTPt.X + XO, RTPt.Y);
            NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
            NewRBPoint := Point(RBPt.X + XO, RBPt.Y + YO);
            NewClRect := Rect(CLRect.Left, ClRect.Top,
              CLRect.Right + XO, ClRect.Bottom + YO);
          end;
        2:
          begin
            H := RectHeight(SkinRect);
            NewRTPoint := Point(RTPt.X + XO, RTPt.Y );
            NewClRect := ClRect;
            Inc(NewClRect.Right, XO);
          end;
        3:
          begin
            W := RectWidth(SkinRect);
            NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
            NewClRect := ClRect;
            Inc(NewClRect.Bottom, YO);
          end;
      end;
    end
  else
    if (FIndex <> -1) and (ResizeMode = 0)
    then
      begin
        W := RectWidth(SkinRect);
        H := RectHeight(SkinRect);
        NewClRect := CLRect;
      end;
end;

procedure TspSkinCustomControl.CreateControlSkinImage;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinCustomControl.CreateSkinControlImage;
begin
  case ResizeMode of
    0:
      begin
        B.Width := RectWidth(R);
        B.Height := RectHeight(R);
        B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), SB.Canvas, R);
      end;
    1: if not FForcebackground
       then
         CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
           NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
           B, SB, R, Width, Height, True,
           LeftStretch, TopStretch, RightStretch, BottomStretch,
           StretchEffect, StretchType);
    2: CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, SB, R, Width, Height,  StretchEffect);
    3: CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          B, SB, R, Width, Height,  StretchEffect);
  end;
end;

function TspSkinCustomControl.GetResizeMode;
begin
  if IsNullRect(SkinRect)
  then
    Result := -1
  else   
  if (RBPt.X <> 0) and (RBPt.Y <> 0)
  then
    Result := 1
  else
  if (RTPt.X <> 0) or (RTPT.Y <> 0)
  then
    Result := 2
  else
  if (LBPt.X <> 0) or (LBPt.Y <> 0)
  then
    Result := 3
  else
    Result := 0;  
end;

function TspSkinCustomControl.GetNewRect;
var
  XO, YO: Integer;
  LeftTop, LeftBottom, RightTop, RightBottom: TRect;

function CorrectResizeRect: TRect;
var
  NR: TRect;
begin
  NR := R;
  if PointInRect(LeftTop, R.TopLeft) and
     PointInRect(RightBottom, R.BottomRight)
  then
    begin
      Inc(NR.Right, XO);
      Inc(NR.Bottom, YO);
    end
  else
  if PointInRect(LeftTop, R.TopLeft) and
     PointInRect(RightTop, R.BottomRight)
  then
    Inc(NR.Right, XO)
  else
    if PointInRect(LeftBottom, R.TopLeft) and
       PointInRect(RightBottom, R.BottomRight)
    then
      begin
        Inc(NR.Right, XO);
        OffsetRect(NR, 0, YO);
      end
    else
      if PointInRect(LeftTop, R.TopLeft) and
         PointInRect(LeftBottom, R.BottomRight)
      then
        Inc(NR.Bottom, YO)
      else
        if PointInRect(RightTop, R.TopLeft) and
           PointInRect(RightBottom, R.BottomRight)
        then
          begin
            OffsetRect(NR, XO, 0);
            Inc(NR.Bottom, YO);
          end;
  Result := NR;
end;

begin
  XO := Width - RectWidth(SkinRect);
  YO := Height - RectHeight(SkinRect);
  Result := R;
  case ResizeMode of
    1:
      begin
        LeftTop := Rect(0, 0, LTPt.X, LTPt.Y);
        LeftBottom := Rect(0, LBPt.Y, LBPt.X, RectHeight(SkinRect));
        RightTop := Rect(RTPt.X, 0, RectWidth(SkinRect), RTPt.Y);
        RightBottom := Rect(RBPt.X, RBPt.Y,
          RectWidth(SkinRect), RectHeight(SkinRect));
        Result := R;
        if RectInRect(R, LeftTop)
        then Result := R
        else
        if RectInRect(R, RightTop)
        then OffsetRect(Result, XO, 0)
        else
        if RectInRect(R, LeftBottom)
        then OffsetRect(Result, 0, YO)
        else
        if RectInRect(R, RightBottom)
        then
          OffsetRect(Result,  XO, YO)
        else
          Result := CorrectResizeRect;
      end;
    2:
      begin
        if (R.Left <= LTPt.X) and (R.Right >= RTPt.X)
        then
          Inc(Result.Right, XO)
        else
        if (R.Left >= RTPt.X) and (R.Right > RTPt.X)
        then
          OffsetRect(Result, XO, 0);
      end;
     3:
      begin
        if (R.Top <= LTPt.Y) and (R.Bottom >= LBPt.Y)
        then
          Inc(Result.Bottom, YO)
        else
          if (R.Top >= LBPt.Y) and (R.Bottom > LBPt.X)
          then
            OffsetRect(Result, 0, YO);
      end;
  end;
end;

procedure TspSkinCustomControl.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinCustomControl
    then
      with TspDataSkinCustomControl(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        RBPt := RBPoint;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        Self.CursorIndex := CursorIndex;
        Self.StretchEffect := StretchEffect;
        Self.LeftStretch := LeftStretch;
        Self.TopStretch := TopStretch;
        Self.RightStretch := RightStretch;
        Self.BottomStretch := BottomStretch;
        Self.StretchEffect := StretchEffect;
        Self.StretchType := StretchType;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        if (MaskPictureIndex <> -1) and (MaskPictureIndex < FSD.FActivePictures.Count)
        then
          MaskPicture := TBitMap(FSD.FActivePictures.Items[MaskPictureIndex])
        else
          MaskPicture := nil;
        ResizeMode := GetResizeMode;
      end
    else
      begin
        ResizeMode := 0;
        Picture := nil;
        MaskPicture := nil;
      end;
end;

procedure TspSkinCustomControl.CreateControlRegion;
var
  TempRgn: HRGN;
  Offset: Integer;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  CalcSize(W, H);
  TempRgn := FRgn;
  case ResizeMode of
    0:
      CreateSkinSimplyRegion(FRgn, MaskPicture);
    1:
      CreateSkinRegion
       (FRgn, LTPt, RTPt, LBPt, RBPt, ClRect,
        NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewClRect,
        MaskPicture, Width, Height);
    2:
      begin
        Offset := Width - RectWidth(SkinRect);
        CreateSkinRegion(FRgn,
          LTPt, RTPt, LTPt, RTPt, ClRect,
          LTPt, Point(RTPt.X + Offset, RTPt.Y),
          LTPt, Point(RTPt.X + Offset, RTPt.Y), NewClRect,
          MaskPicture, Width, Height);
      end;
    3:
      begin
        Offset := Height - RectHeight(SkinRect);
        CreateSkinRegion(FRgn,
          LTPt, LTPt, LBPt, LBPt, ClRect,
          LTPt, LTPt,
          Point(LBPt.X, LBPt.Y + Offset),
          Point(LBPt.X, LBPt.Y + Offset), NewClRect,
          MaskPicture, Width, Height);
      end;
  end;
  SetWindowRgn(Handle, FRgn, True);
  if TempRgn <> 0 then DeleteObject(TempRgn);
end;

procedure TspSkinCustomControl.SetControlRegion;
begin
  if Parent = nil then Exit;
  if ((MaskPicture = nil) or (FIndex = -1)) and (FRgn <> 0)
  then
    begin
      SetWindowRgn(Handle, 0, True);
      DeleteObject(FRgn);
      FRgn := 0;
    end
  else
    if (MaskPicture <> nil) and (FIndex <> -1)
    then CreateControlRegion;
end;

//=========== TspSkinButton ===============
constructor TspSkinButton.Create;
begin
  inherited;
  FLayerManager := TspLayerManager.Create(Self);
  FAlwaysShowGlowFrame := False;
  FStopAnimate := False;
  FCheckedMode := False;
  FStopMouseUp := False;
  FUseSkinSize := True;
  FUseSkinFontColor := True;
  FSpaceSupport := True;
  AnimateTimer := nil;
  RepeatTimer := nil;
  FRepeatMode := False;
  FRepeatInterval := 100;
  FActive := False;
  FSkinDataName := 'button';
  FCanFocused := True;
  FDown := False;
  FMouseDown := False;
  FMouseIn := False;
  Width := 75;
  Height := 25;
  FGroupIndex := 0;
  FGlyph := TBitMap.Create;
  FNumGlyphs := 1;
  FMargin := -1;
  FSpacing := 1;
  FLayout := blGlyphLeft;
  FMorphKf := 0;

  MorphTimer := nil;

  Morphing := False;
  FMorphKf := 0;

  FAllowAllUp := False;
  FAllowAllUpCheck := False;

  FSkinImagesMenu := nil;
  FUseImagesMenuImage := False;
  FUseImagesMenuCaption := False;

  FImageList := nil;
  FImageIndex := -1;
end;

function TspSkinButton.GetGlyphNum;
begin
  if AIsDown and AIsMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if AIsMouseIn and (FNumGlyphs > 3)
  then
    Result := 4
  else
    if not Enabled and (FNumGlyphs > 1)
    then
      Result := 2
    else
      Result := 1;
end;

procedure TspSkinButton.SetCheckedMode(Value: Boolean);
begin
  if FCheckedMode <> Value
  then
    begin
      FCheckedMode := Value;
      if FCheckedMode then GroupIndex := -1 else
      if GroupIndex = -1 then GroupIndex := 0;
    end;
end;

procedure TspSkinButton.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      RePaint;
    end;
end;

procedure TspSkinButton.DrawMenuMarker;
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  if ADown then SR := MenuMarkerDownRect else
    if AActive then SR := MenuMarkerActiveRect else
        SR := MenuMarkerRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);

  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    Picture.Canvas, SR);

  Buffer.Transparent := True;
  Buffer.TransparentMode := tmFixed;
  Buffer.TransparentColor := MenuMarkerTransparentColor;

  X := R.Left + RectWidth(R) div 2 - RectWidth(SR) div 2;
  Y := R.Top + RectHeight(R) div 2 - RectHeight(SR) div 2;

  C.Draw(X, Y, Buffer);

  Buffer.Free;
end;

procedure TspSkinButton.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinImagesMenu)
  then FSkinImagesMenu := nil;
  if (Operation = opRemove) and (AComponent = FImageList)
  then FImageList := nil;
end;

procedure TspSkinButton.OnImagesMenuChanged(Sender: TObject);
begin
  RePaint;
end;

procedure TspSkinButton.SetSkinImagesMenu(Value: TspSkinImagesMenu);
begin
  FSkinImagesMenu := Value;
  if Value <> nil
  then
    begin
      FSkinImagesMenu.OnInternalChange := OnImagesMenuChanged;
    end;
  OnImagesMenuChanged(Self);
end;

procedure TspSkinButton.RefreshButton;
begin
  FMouseIn := False;
  FDown := False;
  if EnableMorphing then FMorphKf := 0;
  if EnableAnimation then StopAnimate;
  RePaint;
end;

function TspSkinButton.EnableMorphing: Boolean;
begin
  Result := Morphing and (SkinData <> nil) and not SkinData.Empty and
            SkinData.EnableSkinEffects;
end;

function TspSkinButton.EnableAnimation: Boolean;
begin
  Result := (SkinData <> nil) and not SkinData.Empty and
            SkinData.EnableSkinEffects;
end;

function TspSkinButton.GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectWidth(AnimateSkinRect) > RectWidth(SkinRect)
  then
    begin
      fs := RectWidth(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 AnimateSkinRect.Top,
                 AnimateSkinRect.Left + CurrentFrame * fs,
                 AnimateSkinRect.Bottom);
    end
  else
    begin
      fs := RectHeight(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left,
                     AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     AnimateSkinRect.Right,
                     AnimateSkinRect.Top + CurrentFrame * fs);
    end;
end;


procedure TspSkinButton.StartAnimate;
begin
  StopAnimate;
  AnimateInc := AInc;
  if not AnimateInc then CurrentFrame := FrameCount else  CurrentFrame := 1;
  AnimateTimer := TTimer.Create(Self);
  AnimateTimer.Enabled := False;
  AnimateTimer.OnTimer := DoAnimate;
  AnimateTimer.Interval := AnimateInterval;
  AnimateTimer.Enabled := True;
end;

procedure TspSkinButton.StopAnimate;
begin
  CurrentFrame := 0;
  if AnimateTimer <> nil
  then
    begin
      AnimateTimer.Enabled := False;
      AnimateTimer.Free;
      AnimateTimer := nil;
    end;
end;

procedure TspSkinButton.DoAnimate(Sender: TObject);
begin
  if AnimateInc
  then
    begin
      if CurrentFrame <= FrameCount
      then
        begin
         Inc(CurrentFrame);
         RePaint;
       end;
      if CurrentFrame > FrameCount then StopAnimate;
    end
  else
    begin
      if CurrentFrame >= 0
      then
        begin
          Dec(CurrentFrame);
          RePaint;
        end;
      if CurrentFrame <= 0 then StopAnimate;
    end;
end;

procedure TspSkinButton.CalcSize(var W, H: Integer);
var
  XO, YO: Integer;
begin
  if FUseSkinSize or (ResizeMode = 1) then inherited;
  if (not FUseSkinSize) and (ResizeMode <> 1)
  then
    begin
      XO := W - RectWidth(SkinRect);
      YO := H - RectHeight(SkinRect);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
    end;
end;

procedure TspSkinButton.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinButton.Click;
begin
  if ActionLink = nil then inherited;
end;

destructor TspSkinButton.Destroy;
begin
  FLayerManager.Free;
  FGlyph.Free;
  StopMorph;
  if RepeatTimer <> nil then RepeatTimer.Free;
  RepeatTimer := nil;
  if AnimateTimer <> nil then StopAnimate;
  inherited;
end;

procedure TspSkinButton.WMSHOWLAYER(var Message: TMessage);
begin
  ShowLayer;
end;

procedure TspSkinButton.WMHIDELAYER(var Message: TMessage);
begin
  HideLayer;
end;

procedure TspSkinButton.ShowLayer;
var
  B, BM, RealB, RealBM: TBitmap;
  P: TPoint;
  R: TRect;
  F: TCustomForm;
  CanShow: Boolean;
begin
  CanShow := not ((SkinData = nil) or (SkinData.Empty)) and CheckW2KWXP;
  if not CanShow then Exit;

  CanShow := (SkinData.ShowButtonGlowFrames or FAlwaysShowGlowFrame)
             and (GlowLayerPictureIndex <> -1);

  if not CanShow then Exit;

  F := GetParentForm(Self);
  if (F <> nil) and (F is TForm)
  then
    FLayerManager.TopMostMode := TForm(F).FormStyle = fsStayOnTop;
  if ResizeMode = 0
  then
    begin
      B := TBitMap(FSD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(FSD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      P := ClientToScreen(Point(0, 0));
      P.X := P.X - GlowLayerShowOffsetX;
      P.Y := P.Y - GlowLayerShowOffsetY;
      FLayerManager.Show(P.X, P.Y, B, BM, GlowLayerAlphaBlendValue);
    end
  else
  if (ResizeMode = 2) and FUseSkinSize
  then
    begin
      B := TBitMap(FSD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(FSD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      RealB := TBitMap.Create;
      RealB.Width := Width + (B.Width - RectWidth(SkinRect));
      RealB.Height := B.Height;
       CreateHSkinImage(GlowLayerOffsetLeft, GlowLayerOffsetRight, RealB, B,
        Rect(0, 0, B.Width, B.Height), RealB.Width, RealB.Height, True);
      RealBM := TBitMap.Create;
      RealBM.Width := Width + (BM.Width - RectWidth(SkinRect));
      RealBM.Height := BM.Height;
       CreateHSkinImage(GlowLayerOffsetLeft, GlowLayerOffsetRight, RealBM, BM,
        Rect(0, 0, BM.Width, BM.Height), RealBM.Width, RealBM.Height, True);
      //
      P := ClientToScreen(Point(0, 0));
      P.X := P.X - GlowLayerShowOffsetX;
      P.Y := P.Y - GlowLayerShowOffsetY;
      FLayerManager.Show(P.X, P.Y, RealB, RealBM, GlowLayerAlphaBlendValue);
      RealB.Free;
      RealBM.Free;
    end
  else
  if ResizeMode = 1
  then
    begin
      B := TBitMap(FSD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(FSD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      RealB := TBitMap.Create;
      RealB.Width := Width + (B.Width - RectWidth(SkinRect));
      RealB.Height := Height + (B.Height - RectHeight(SkinRect));
      R := Rect(GlowLayerOffsetLeft, GlowLayerOffsetTop,
        B.Width - GlowLayerOffsetRight, B.Height - GlowLayerOffsetBottom);
      CreateStretchImage(RealB, B, Rect(0, 0, B.Width, B.Height), R, True);
      RealBM := TBitMap.Create;
      RealBM.Width := Width + (BM.Width - RectWidth(SkinRect));
      RealBM.Height := Height + (BM.Height - RectHeight(SkinRect));
      R := Rect(GlowLayerOffsetLeft, GlowLayerOffsetTop,
        BM.Width - GlowLayerOffsetRight, BM.Height - GlowLayerOffsetBottom);
      CreateStretchImage(RealBM, BM, Rect(0, 0, BM.Width, BM.Height), R, True);
      //
      P := ClientToScreen(Point(0, 0));
      P.X := P.X - GlowLayerShowOffsetX;
      P.Y := P.Y - GlowLayerShowOffsetY;
      FLayerManager.Show(P.X, P.Y, RealB, RealBM, GlowLayerAlphaBlendValue);
      RealB.Free;
      RealBM.Free;
    end;
end;

procedure TspSkinButton.HideLayer;
begin
  if (SkinData = nil) or (SkinData.Empty) or
  (not SkinData.ShowButtonGlowFrames) then Exit;
  
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and
     ((ResizeMode = 0) or ((ResizeMode = 2) and FUseSkinSize) or (ResizeMode = 1))
  then
    FLayerManager.Hide;
end;


procedure TspSkinButton.BeforeRepeatTimerProc(Sender: TObject);
begin
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := RepeatTimerProc;
  RepeatTimer.Interval := FRepeatInterval;
  RepeatTimer.Enabled := True;
end;

procedure TspSkinButton.StartRepeat;
begin
  if RepeatTimer <> nil then RepeatTimer.Free;
  RepeatTimer := TTimer.Create(Self);
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := BeforeRepeatTimerProc;
  RepeatTimer.Interval := 500;
  RepeatTimer.Enabled := True;
end;


procedure TspSkinButton.RepeatTimerProc;
begin
  ButtonClick;
end;

procedure TspSkinButton.StopRepeat;
begin
  if RepeatTimer = nil then Exit;
  RepeatTimer.Enabled := False;
  RepeatTimer.Free;
  RepeatTimer := nil;
end;

procedure TspSkinButton.CreateWnd;
begin
  inherited CreateWnd;
  FActive := FDefault;
end;

procedure TspSkinButton.CMEnabledChanged;
begin
  inherited;
  if EnableMorphing
  then
    begin
      StopMorph;
      FMorphKf := 0;
    end;
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinButton.StartMorph;
begin
  if MorphTimer <> nil then Exit;
  MorphTimer := TTimer.Create(Self);
  MorphTimer.Interval := MorphTimerInterval;
  MorphTimer.OnTimer := DoMorph;
  MorphTimer.Enabled := True;
end;

procedure TspSkinButton.StopMorph;
begin
  if MorphTimer = nil then Exit;
  MorphTimer.Free;
  MorphTimer := nil;
end;


procedure TspSkinButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
   if FActive and (CharCode = VK_RETURN) and Enabled
   then
     begin
       ButtonClick;
       Result := 1;
     end
   else
   if (CharCode = VK_ESCAPE) and FCancel and FCanFocused and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus
   then
     begin
       ButtonClick;
       Result := 1;
     end
   else
     inherited;
end;

procedure TspSkinButton.CMFocusChanged(var Message: TCMFocusChanged);
begin

  with Message do
   if Sender is TspSkinButton then
      FActive := Sender = Self
   else
     FActive := FDefault;

  if FCanFocused and FDefault
  then
    if (Message.Sender <> Self) and (Message.Sender is TspSkinButton)
    then
      begin
        FMouseIn := False;
        ReDrawControl;
      end
    else
    if (Message.Sender <> Self) and not (Message.Sender is TspSkinButton)
    then
      begin
        FMouseIn := True;
        if EnableMorphing then FMorphKf := 1;
        RePaint;
      end;

  inherited;
end;

procedure TspSkinButton.ButtonClick;
var
  Form: TCustomForm;
begin
  if FCanFocused
  then
    begin
      Form := GetParentForm(Self);
      if Form <> nil then Form.ModalResult := ModalResult;
    end;
 { Call OnClick if assigned and not equal to associated action's OnExecute.
    If associated action's OnExecute assigned then call it, otherwise, call
    OnClick. }
  if Assigned(FOnClick) and (Action <> nil) and (@FOnClick <> @Action.OnExecute)
  then
    FOnClick(Self)
  else
    if not (csDesigning in ComponentState) and (ActionLink <> nil)
    then
      ActionLink.Execute
     else
       if Assigned(FOnClick) then FOnClick(Self);
// if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TspSkinButton.SetDefault(Value: Boolean);
var
  Form: TCustomForm;
begin
  FDefault := Value;
  if HandleAllocated and FCanFocused and not (csDesigning in ComponentState)
  then
    begin
      Form := GetParentForm(Self);
      if Form <> nil then
        Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
    end;
end;

procedure TspSkinButton.BeforeChangeSkinData;
begin
  inherited;
  if FLayerManager.IsVisible then FLayerManager.Hide;
end;

procedure TspSkinButton.ChangeSkinData;
begin
  StopMorph;
  StopAnimate;
  FMorphKf := 0;
  inherited;
  if EnableMorphing and (FIndex <> -1) and (IsFocused or FMouseIn)
  then
    FMorphKf := 1;
  if FMouseIn then PostMessage(Handle, WM_SHOWLAYER, 0, 0);
end;

procedure TspSkinButton.SetGroupIndex;
begin
  FGroupIndex := Value;
  if FGroupIndex <> 0 then CanFocused := False;
end;

function TspSkinButton.IsFocused;
begin
  Result := Focused and FCanFocused;
end;

procedure TspSkinButton.CMDialogChar;
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus and FCanFocused
    then
      begin
        SetFocus;
        ButtonClick;
        Result := 1;
      end
    else
     inherited;
end;

procedure TspSkinButton.SetCanFocused;
begin
  FCanFocused := Value;
  TabStop := FCanFocused;
end;

procedure TspSkinButton.WMSETFOCUS;
begin
  inherited;
  if FCanFocused
  then
    begin
      if (FIndex <> -1) and EnableAnimation and not IsNullRect(AnimateSkinRect) then StartAnimate(True);
      ReDrawControl;
    end;
end;

procedure TspSkinButton.WMKILLFOCUS;
begin
  if FRepeatMode and (RepeatTimer <> nil) then StopRepeat;
  if (GroupIndex = 0) and FDown then FDown := False;
  inherited;
  if FCanFocused
  then
    begin
      if (FIndex <> -1) and EnableAnimation and not IsNullRect(AnimateSkinRect) then StartAnimate(False);
//      ReDrawControl;
      if EnableMorphing and (FIndex <> -1)
      then StartMorph
      else Invalidate;
    end;
end;

procedure TspSkinButton.WndProc(var Message: TMessage);
begin
  if FCanFocused then
  case Message.Msg of
    WM_KEYDOWN:
      if (TWMKEYDOWN(Message).CharCode = VK_SPACE) and FSpaceSupport
      then
        begin
          Down := True;
          if FRepeatMode then ButtonClick;
        end
      else
      if TWMKEYDOWN(Message).CharCode = VK_RETURN
      then
        begin
          ButtonClick;
        end;
    WM_KEYUP:
      if (TWMKEYUP(Message).CharCode = VK_SPACE) and FSpaceSupport
      then
        begin
          Down := False;
          ButtonClick;
        end;
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) and not Focused then
      begin
        FClicksDisabled := True;
        Windows.SetFocus(Handle);
        FClicksDisabled := False;
        if not Focused then Exit;
      end;
    CN_COMMAND:
      if FClicksDisabled then Exit;
  end;
  inherited WndProc(Message);
end;

procedure TspSkinButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if (FGlyph.Empty) and (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
      begin
        Self.ImageList := ActionList.Images;
        Self.ImageIndex := ImageIndex;
        RePaint;
      end;
    end;
end;

procedure TspSkinButton.ReDrawControl;
begin
  if EnableMorphing and (FIndex <> -1)
  then StartMorph
  else RePaint;
end;

procedure TspSkinButton.DoMorph;
begin

  if FStopAnimate and Focused and EnableMorphing
  then
     begin
       FStopAnimate := False;
       FMorphKf := 1;
       StopMorph;
       RePaint;
       Exit;
     end;

  if (FIndex = -1) or not EnableMorphing
  then
    begin
      if (FMouseIn or IsFocused) then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
    end
  else
  if (FMouseIn or IsFocused) and (FMorphKf < 1)
  then
    begin
      FMorphKf := FMorphKf + MorphInc;
      RePaint;
    end
  else
  if not (FMouseIn or IsFocused) and (FMorphKf > 0)
  then
    begin
      FMorphKf := FMorphKf - MorphInc;
      RePaint;
    end
  else
    begin
      if (FMouseIn or IsFocused) then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
      RePaint;
    end;
end;

procedure TspSkinButton.SetLayout;
begin
  if FLayout <> Value
  then
    begin
      FLayout := Value;
      RePaint;
    end;
end;

procedure TspSkinButton.SetSpacing;
begin
  if Value <> FSpacing
  then
    begin
      FSpacing := Value;
      RePaint;
    end;
end;

procedure TspSkinButton.SetMargin;
begin
  if (Value <> FMargin) and (Value >= -1)
  then
    begin
      FMargin := Value;
      RePaint;
    end;
end;

procedure TspSkinButton.SetDown;
begin
  FDown := Value;
  if EnableMorphing
  then
     begin
       FMorphKf := 1;
       if not FDown then StartMorph else StopMorph; 
     end;
  RePaint;
  if (GroupIndex > 0) and FDown and not FAllowAllUp then DoAllUp;
end;

procedure TspSkinButton.DoAllUp;
var
  PC: TWinControl;
  i: Integer;
begin
  if Parent = nil then Exit;
  PC := TWinControl(Parent);
  for i := 0 to PC.ControlCount - 1 do
   if (PC.Controls[i] is TspSkinButton) and
      (PC.Controls[i] <> Self)
   then
     with TspSkinButton(PC.Controls[i]) do
       if (GroupIndex = Self.GroupIndex) and
          (GroupIndex > 0) and FDown
       then
         Down := False;
end;

procedure TspSkinButton.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinButton.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinButton.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinButtonControl
      then
        with TspDataSkinButtonControl(FSD.CtrlList.Items[FIndex]) do
        begin
          if  not FUseSkinSize and (MaskPictureIndex <> -1)
          then
            MaskPicture := nil;
          Self.FontName := FontName;
          Self.FontColor := FontColor;
          Self.ActiveFontColor := ActiveFontColor;
          Self.DownFontColor := DownFontColor;
          Self.FontStyle := FontStyle;
          Self.FontHeight := FontHeight;
          Self.ActiveSkinRect := ActiveSkinRect;
          Self.DownSkinRect := DownSkinRect;
          Self.Morphing := Morphing;
          Self.MorphKind := MorphKind;
          if IsNullRect(ActiveSkinRect) then Self.ActiveSkinRect := SkinRect;
          if IsNullRect(DownSkinRect) then Self.DownSkinRect := Self.ActiveSkinRect;
          Self.DisabledSkinRect := DisabledSkinRect;
          Self.FocusedSkinRect := FocusedSkinRect;
          Self.DisabledFontColor := DisabledFontColor;
          Self.AnimateSkinRect := AnimateSkinRect; 
          Self.FrameCount := FrameCount;
          Self.AnimateInterval := AnimateInterval;
          Self.ShowFocus := ShowFocus;
          //
          Self.MenuMarkerRect := MenuMarkerRect;
          Self.MenuMarkerActiveRect := MenuMarkerActiveRect;
          Self.MenuMarkerDownRect := MenuMarkerDownRect;
          Self.MenuMarkerFlatRect := MenuMarkerFlatRect;
          Self.MenuMarkerTransparentColor := MenuMarkerTransparentColor;
          if IsNullRect(Self.MenuMarkerActiveRect)
          then
            Self.MenuMarkerActiveRect := Self.MenuMarkerRect;
          if IsNullRect(Self.MenuMarkerDownRect)
          then
            Self.MenuMarkerDownRect := Self.MenuMarkerActiveRect;
          //
          if Self.DisabledFontColor = Self.FontColor
          then
             Self.DisabledFontColor := clGray;
           //
          Self.GlowLayerPictureIndex := GlowLayerPictureIndex;
          Self.GlowLayerMaskPictureIndex := GlowLayerMaskPictureIndex;
          Self.GlowLayerOffsetLeft := GlowLayerOffsetLeft;
          Self.GlowLayerOffsetRight := GlowLayerOffsetRight;
          Self.GlowLayerOffsetTop := GlowLayerOffsetTop;
          Self.GlowLayerOffsetBottom := GlowLayerOffsetBottom;
          Self.GlowLayerShowOffsetX := GlowLayerShowOffsetX;
          Self.GlowLayerShowOffsetY := GlowLayerShowOffsetY;
          Self.GlowLayerAlphaBlendValue := GlowLayerAlphaBlendValue;
          //
        end;
     if EnableAnimation and (AnimateTimer <> nil) and (CurrentFrame <= FrameCount) and
        (CurrentFrame > 0)
     then
       begin
         if AnimateInc
         then
           ActiveSkinRect := GetAnimationFrameRect
         else
           SkinRect := GetAnimationFrameRect;
       end;
   end
 else
   begin
     Morphing := False;
     AnimateSkinRect := NullRect;
   end;
end;

procedure TspSkinButton.CreateStrechButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean);
var
  TR: TRect;
  S: String;
  FDrawButtonDefault: Boolean;
begin
  //
  if ResizeMode = 0
  then
    B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, R)
  else
  if (ResizeMode = 2) or (ResizeMode = 3)
  then
    CreateStretchImage(B, Picture, R, ClRect, True);
  //
  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;

    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if ADown and AMouseIn
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;
  TR := ClRect;
  TR.Right := TR.Right + (B.Width - RectWidth(R));
  TR.Bottom := TR.Bottom + (B.Height - RectHeight(R));

  if ShowFocus and Focused
  then
    begin
      B.Canvas.Brush.Style := bsSolid;
      B.Canvas.Brush.Color := FSD.SkinColors.cBtnFace;
      DrawSkinFocusRect(B.Canvas, TR);
      B.Canvas.Brush.Style := bsClear;
    end;

  FDrawButtonDefault := True;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, NewClRect, ADown, AMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault then

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, TR, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, TR, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
  DrawGlyphAndText(B.Canvas,
    TR, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False, False, 0);
end;

procedure TspSkinButton.CreateButtonImage(B: TBitMap; R: TRect;
  ADown, AMouseIn: Boolean);
var
  S: String;
  FDrawButtonDefault: Boolean;
begin
  if (not FUseSkinSize) and (ResizeMode <> 1)
  then
    begin
      CreateStrechButtonImage(B, R, ADown, AMouseIn);
      Exit;
    end;
  
  CreateSkinControlImage(B, Picture, R);
  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;
  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;

    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if ADown and AMouseIn
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;


  if ShowFocus and Focused
  then
    begin
      B.Canvas.Brush.Style := bsSolid;
      B.Canvas.Brush.Color := FSD.SkinColors.cBtnFace;
      DrawSkinFocusRect(B.Canvas, NewClRect);
      B.Canvas.Brush.Style := bsClear;
    end;


  FDrawButtonDefault := True;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, NewClRect, ADown, AMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault then
  
  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
   DrawGlyphAndText(B.Canvas,
    NewClRect, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIN),  False, False, 0);
end;

procedure TspSkinButton.CreateControlDefaultImage;
var
  R: TRect;
  IsDown: Boolean;
  S: String;
  FDrawButtonDefault: Boolean;
begin
  inherited;
  IsDown := False;
  R := ClientRect;
  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;

    
  if not Enabled then B.Canvas.Font.Color := clBtnShadow;
  if FDown and (((FMouseIn or (IsFocused and not FMouseDown)) and
     (GroupIndex = 0)) or (GroupIndex  <> 0))
  then
    begin
      Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
      B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
      B.Canvas.FillRect(R);
      IsDown := True;
    end
  else
    if FMouseIn or IsFocused
    then
      begin
        Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
        B.Canvas.FillRect(R);
      end
    else
      begin
        Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
        B.Canvas.Brush.Color := clBtnFace;
        B.Canvas.FillRect(R);
      end;

  FDrawButtonDefault := True;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, ClientRect, FDown, FMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault then

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, ClientRect, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, ClientRect, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
  DrawGlyphAndText(B.Canvas,
    ClientRect, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False, False, 0);
end;

procedure TspSkinButton.CreateControlSkinImage;
begin
end;

procedure TspSkinButton.Paint;
var
  PBuffer, APBuffer, PIBuffer: TspEffectBmp;
  ParentImage, Buffer, ABuffer: TBitMap;
  kf: Double;
begin
  GetSkinData;
  if FIndex = -1
  then
    inherited
  else
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      ParentImage := nil;
      if FAlphaBlend
      then
        begin
          ParentImage := TBitMap.Create;
          ParentImage.Width := Width;
          ParentImage.Height := Height;
          GetParentImage(Self, ParentImage.Canvas);
          PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
          kf := 1 - FAlphaBlendValue / 255;
        end;

      if EnableMorphing and (FMorphKf <> 1) and (FMorphKf <> 0) and Enabled
      then
        begin
          ABuffer := TBitMap.Create;
          ABuffer.Width := Width;
          ABuffer.Height := Height;
          CreateButtonImage(Buffer, SkinRect, False, False);
          CreateButtonImage(ABuffer, ActiveSkinRect, False, True);
          PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
          APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
          case MorphKind of
            mkDefault: PBuffer.Morph(APBuffer, FMorphKf);
            mkGradient: PBuffer.MorphGrad(APBuffer, FMorphKf);
            mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, FMorphKf);
            mkRightGradient: PBuffer.MorphRightGrad(APBuffer, FMorphKf);
            mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, FMorphKf);
            mkRightSlide: PBuffer.MorphRightSlide(APBuffer, FMorphKf);
            mkPush: PBuffer.MorphPush(APBuffer, FMorphKf);
          end;
          if FAlphaBlend then PBuffer.Morph(PIBuffer, Kf);
          PBuffer.Draw(Canvas.Handle, 0, 0);
          PBuffer.Free;
          APBuffer.Free;
          ABuffer.Free;
        end
      else
        begin
          if (not Enabled) and not IsNullRect(DisabledSkinRect)
          then
            CreateButtonImage(Buffer, DisabledSkinRect, False, False)
          else
          if FDown and (((FMouseIn or (IsFocused and not FMouseDown)) and
            (GroupIndex = 0)) or (GroupIndex  <> 0))
          then
            CreateButtonImage(Buffer, DownSkinRect, True, True)
          else
            if IsFocused and not IsNullRect(FocusedSkinRect) and
               (AnimateTimer = nil)
            then
              begin
                CreateButtonImage(Buffer, FocusedSkinRect, False, True);
              end
            else
            if (IsFocused or FMouseIn) or (not (IsFocused or FMouseIn) and
                EnableMorphing and (FMorphKf = 1))
            then
              CreateButtonImage(Buffer, ActiveSkinRect, False, True)
            else
              CreateButtonImage(Buffer, SkinRect, False, False);
          if FAlphaBlend
          then
            begin
              PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
              PBuffer.Morph(PIBuffer, Kf);
              PBuffer.Draw(Canvas.Handle, 0, 0);
              PBuffer.Free;
             end
          else
            Canvas.Draw(0, 0, Buffer);
        end;

      if FAlphaBlend
      then
        begin
          PIBuffer.Free;
          ParentImage.Free;
        end;
      Buffer.Free;
    end;
end;

procedure TspSkinButton.CMTextChanged;
begin
  if (FIndex <> -1) or
     (csDesigning in ComponentState) or DrawDefault
  then
    RePaint;
end;

procedure TspSkinButton.CMMouseEnter(var Message: TMessage);
var
  CanPaint: Boolean;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  if GroupIndex <> 0
  then
    CanPaint := not FDown
  else
    CanPaint := not IsFocused or FDown;
  if CanPaint
  then
    begin
      if FDown
      then
        begin
          if EnableMorphing then FMorphKf := 1; 
          RePaint;
        end  
      else
        begin
          if (FIndex <> -1) and EnableAnimation  and  not IsNullRect(AnimateSkinRect) then StartAnimate(True);
          ReDrawControl;
        end;
    end;
  if FDown and FRepeatMode and (GroupIndex = 0) then StartRepeat;
  //
  PostMessage(Handle, WM_SHOWLAYER, 0, 0);
end;


procedure TspSkinButton.CMMouseLeave(var Message: TMessage);
var
  CanPaint: Boolean;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;

  if not (FCanFocused and FDefault and FActive and not Focused)
  then
    FMouseIn := False;

  if GroupIndex <> 0
  then
    CanPaint := not FDown
  else
    CanPaint := not IsFocused or FDown;

  if CanPaint
  then
    begin
      if (FIndex <> -1) and EnableAnimation  and  not IsNullRect(AnimateSkinRect) then StartAnimate(False);
      ReDrawControl;
    end;  

  if FDown and FRepeatMode and (RepeatTimer <> nil) and (GroupIndex = 0) then StopRepeat;
  //
  PostMessage(Handle, WM_HIDELAYER, 0, 0);
end;

procedure TspSkinButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {$IFDEF VER200}
  if ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and (FMouseIn) and FDown
  then
    Perform(CM_MOUSELEAVE, 0, 0)
  else
  if not ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and not FMouseIn and FDown
  then
    Perform(CM_MOUSEENTER, 0, 0);
  {$ENDIF}
end;

procedure TspSkinButton.MouseDown;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      if (FIndex <> -1) and EnableAnimation  and not IsNullRect(AnimateSkinRect) then StopAnimate;
      FMouseDown := True;
      if not FDown
      then
        begin
          FMouseIn := True;
          Down := True;
          if FCheckedMode
          then
            begin
              FStopMouseUp := True;
              ButtonClick;
            end
          else
          if FRepeatMode and (GroupIndex = 0)
          then
            StartRepeat
          else
            if (GroupIndex <> 0) then ButtonClick;
          FAllowAllUpCheck := False;
        end
      else
        if (GroupIndex <> 0) then FAllowAllUpCheck := True;
    end;
end;

procedure TspSkinButton.MouseUp;
var
  CheckDown: Boolean;
begin
  if Button = mbLeft
  then
    begin
      FMouseDown := False;
      CheckDown := FDown;
      if FCheckedMode
      then
        begin
          if not FStopMouseUp
          then
            begin
              Down := False;
              ButtonClick;
            end
          else
            FStopMouseUp := False;
      end
      else
      if GroupIndex = 0
      then
        begin
          if FMouseIn
          then
            begin
              Down := False;
              if FRepeatMode and (RepeatTimer <> nil) then StopRepeat;
              if CheckDown then ButtonClick;
            end
            else
              begin
                FDown := False;
                if FRepeatMode and (RepeatTimer <> nil) then StopRepeat;
              end;
        end
      else
        if (GroupIndex <> 0) and FDown and FAllowAllUp and
           FAllowAllUpCheck and FMouseIn
        then
          begin
            Down := False;
            ButtonClick;
          end;
    end;
 if HandleAllocated and Visible then inherited;
end;

//==============TspSkinMenuButton==========//
constructor TspSkinMenuButton.Create;
begin
  inherited;
  FSkinDataName := 'toolmenubutton';
  FTrackButtonMode := False;
  FMenuTracked := False;
  FSkinPopupMenu := nil;
  FSpaceSupport := False;
end;

destructor TspSkinMenuButton.Destroy;
begin
  inherited;
end;

procedure TspSkinMenuButton.CreateControlSkinResizeImage2(B: TBitMap);
var
  R, R1: TRect;
  isDown: Boolean;
  E: Boolean;
  B1, B2: TBitMap;
  SRect, ARect, DRect: TRect;
  S: String;
begin
  isDown := False;
  R := Rect(0, 0, Width, Height);
  SRect := SkinRect;
  if IsNullRect(ActiveSkinRect) then ARect := SRect else ARect := ActiveSkinRect;
  if IsNullRect(DownSkinRect) then DRect := ARect else DRect := DownSkinRect;

  if FTrackButtonMode
  then
    begin
      B1 := TBitMap.Create;
      B1.Width := Width - 15;
      B1.Height := Height;
      B2 := TBitMap.Create;
      B2.Width := 15;
      B2.Height := Height;
      if FMenuTracked
      then
        begin
          CreateStretchImage(B1, Picture, ARect, ClRect, True);
          CreateStretchImage(B2, Picture, DRect, ClRect, True);
        end
      else
        begin
          if FDown and FMouseIn
          then
            begin
              CreateStretchImage(B1, Picture, DRect, ClRect, True);
              CreateStretchImage(B2, Picture, DRect, ClRect, True);
              isDown := True;
            end
          else
          if FMouseIn
          then
            begin
              CreateStretchImage(B1, Picture, ARect, ClRect, True);
              CreateStretchImage(B2, Picture, ARect, ClRect, True);
            end
          else
            begin
              CreateStretchImage(B1, Picture, SRect, ClRect, True);
              CreateStretchImage(B2, Picture, SRect, ClRect, True);
            end;
        end;
      B.Canvas.Draw(0, 0, B1);
      B.Canvas.Draw(Width - 15, 0, B2);
      B1.Free;
      B2.Free;  
    end
  else
    begin
      if FDown and FMouseIn
      then
        begin
          CreateStretchImage(B, Picture, DRect, ClRect, True);
          IsDown := True;
        end
      else
        if FMouseIn
        then
          begin
            CreateStretchImage(B, Picture, ARect, ClRect, True);
          end
        else
          begin
            CreateStretchImage(B, Picture, SRect, ClRect, True);
          end;
    end;

  R := ClientRect;
  Dec(R.Right, 15);

  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;

    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else  
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if IsDown
    then
      Color := DownFontColor
    else
      if FMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  if ShowFocus and Focused
  then
    begin
      B.Canvas.Brush.Style := bsSolid;
      B.Canvas.Brush.Color := FSD.SkinColors.cBtnFace;
      DrawSkinFocusRect(B.Canvas, NewClRect);
      B.Canvas.Brush.Style := bsClear;
    end;


  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
   if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                   Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False, False, 0);



  R.Left := Width - 15;
  Inc(R.Right, 15);
  if (FDown and FMouseIn) or FMenuTracked
  then
    begin
      Inc(R.Top, 2);
      Inc(R.Left, 2);
    end;

  if not IsNullRect(MenuMarkerRect)
  then
    begin
      DrawMenuMarker(B.Canvas, R, FMouseIn, (FDown and FMouseIn) or FMenuTracked);
    end
  else
  if FMenuTracked
  then
    DrawTrackArrowImage(B.Canvas, R, DownFontColor)
  else
    DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;

procedure TspSkinMenuButton.CreateControlSkinResizeImage(B: TBitMap);
var
  R, R1: TRect;
  isDown: Boolean;
  E: Boolean;
  B1, B2: TBitMap;
  SRect, ARect, DRect: TRect;
  NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1: TPoint;
  NewClRect1: TRect;
  NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2: TPoint;
  NewClRect2: TRect;
  XO, YO: Integer;
  S: String;
begin
  isDown := False;
  R := Rect(0, 0, Width, Height);
  SRect := SkinRect;
  if IsNullRect(ActiveSkinRect) then ARect := SRect else ARect := ActiveSkinRect;
  if IsNullRect(DownSkinRect) then DRect := ARect else DRect := DownSkinRect;

  if FTrackButtonMode
  then
    begin
      XO := (Width - 15) - RectWidth(SRect);
      YO := Height - RectHeight(SRect);

      NewLTPoint1 := LTPt;
      NewRTPoint1 := Point(RTPt.X + XO, RTPt.Y);
      NewLBPoint1 := Point(LBPt.X, LBPt.Y + YO);
      NewRBPoint1 := Point(RBPt.X + XO, RBPt.Y + YO);
      NewClRect1 := Rect(CLRect.Left, ClRect.Top,
       CLRect.Right + XO, ClRect.Bottom + YO);

      XO := 15 - RectWidth(SRect);
      YO := Height - RectHeight(SRect);

      NewLTPoint2 := LTPt;
      NewRTPoint2 := Point(RTPt.X + XO, RTPt.Y);
      NewLBPoint2 := Point(LBPt.X, LBPt.Y + YO);
      NewRBPoint2 := Point(RBPt.X + XO, RBPt.Y + YO);
      NewClRect2 := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    end;  

  if FTrackButtonMode
  then
    begin
      R := Rect(0, 0, Width - 15, Height);
      R1 := Rect(Width - 15, 0, Width, Height);
      B1 := TBitMap.Create;
      B2 := TBitMap.Create;
      if FMenuTracked
      then
        begin
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
            B1, Picture, ARect, Self.Width - 15, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
            B.Canvas.Draw(0, 0, B1);
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
            B2, Picture, DRect, 15, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          B.Canvas.Draw(Self.Width - 15, 0, B2);
        end
      else
        begin
          if FDown and FMouseIn
          then
            begin
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
                B1, Picture, DRect, Self.Width - 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(0, 0, B1);
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                B2, Picture, DRect, 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
              isDown := True;
            end
          else
          if FMouseIn
          then
            begin
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
                B1, Picture, ARect, Self.Width - 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(0, 0, B1);
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                B2, Picture, ARect, 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
            end
          else
            begin
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
               NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
               B1, Picture, SRect, Self.Width - 15, Height, True,
               LeftStretch, TopStretch, RightStretch, BottomStretch,
               StretchEffect, StretchType);
              B.Canvas.Draw(0, 0, B1);
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                B2, Picture, SRect, 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
              end;
        end;
      B1.Free;
      B2.Free;
    end
  else
    begin
      if FDown and FMouseIn
      then
        begin
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, DRect, Width, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          IsDown := True;
        end
      else
        if FMouseIn
        then
          begin
            CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
              NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, ARect, Width, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          end
       else
         begin
            CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
            NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
              B, Picture, SRect, Width, Height, True,
              LeftStretch, TopStretch, RightStretch, BottomStretch,
              StretchEffect, StretchType);
         end;
    end;
  R := ClientRect;
  Dec(R.Right, 15);

  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;

    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if IsDown
    then
      Color := DownFontColor
    else
      if FMouseIn 
      then Color := ActiveFontColor
      else Color := FontColor;
  end;


  if ShowFocus and Focused
  then
    begin
      B.Canvas.Brush.Style := bsSolid;
      B.Canvas.Brush.Color := FSD.SkinColors.cBtnFace;
      DrawSkinFocusRect(B.Canvas, NewClRect);
      B.Canvas.Brush.Style := bsClear;
    end;

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
    DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                     Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False, False, 0);

  R.Left := Width - 15;
  Inc(R.Right, 15);

  if not IsNullRect(MenuMarkerRect)
  then
    begin
      DrawMenuMarker(B.Canvas, R, FMouseIn, (FDown and FMouseIn) or FMenuTracked);
    end
  else
  if FMenuTracked
  then
    DrawTrackArrowImage(B.Canvas, R, DownFontColor)
  else
    DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;

procedure TspSkinMenuButton.CreateButtonImage;
begin
  if (SkinDataName = 'toolbutton') or (SkinDataName = 'bigtoolbutton')
  then
    begin
      CreateControlSkinResizeImage2(B);
    end
  else
  if (SkinDataName = 'resizebutton') or (SkinDataName = 'resizetoolbutton')
  then
    begin
      CreateControlSkinResizeImage(B);
    end
  else
  if FMenuTracked and FTrackButtonMode and
     not IsNullRect(TrackButtonRect) and not IsNullRect(DownSkinRect)
  then
    begin
      inherited CreateButtonImage(B, ActiveSkinRect, False, True);
      R := TrackButtonRect;
      OffsetRect(R, DownSkinRect.Left, DownSkinRect.Top);
        B.Canvas.CopyRect(GetNewTrackButtonRect, Picture.Canvas,
       R);
    end
  else
    inherited;
end;


procedure TspSkinMenuButton.CreateControlDefaultImage;
var
  R, R1: TRect;
  isDown: Boolean;
  S: String;
begin
  IsDown := False;
  if FTrackButtonMode
  then
    begin
      R := Rect(0, 0, Width - 15, Height);
      R1 := Rect(Width - 15, 0, Width, Height);
      if FMenuTracked
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          B.Canvas.FillRect(R);
          Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R1);
        end
      else
        begin
          if FDown and FMouseIn
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
              B.Canvas.FillRect(R1);
              isDown := True;
            end
          else
          if FMouseIn or IsFocused
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R1);
            end
          else
            begin
              Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
              B.Canvas.Brush.Color := clBtnFace;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, clBtnShadow, clBtnShadow, 1);
              B.Canvas.Brush.Color := clBtnFace;
              B.Canvas.FillRect(R1);
            end;
        end;
    end
  else
    begin
      R := Rect(0, 0, Width, Height);
      if FDown and FMouseIn
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R);
        end
      else
        if FMouseIn or IsFocused
        then
          begin
            Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
            B.Canvas.FillRect(R);
          end
       else
         begin
           Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
           B.Canvas.Brush.Color := clBtnFace;
           B.Canvas.FillRect(R);
         end;
    end;
  R := ClientRect;
  Dec(R.Right, 15);
  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;
    
  if not Enabled then B.Canvas.Font.Color := clBtnShadow;

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
    DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn),  False,
                  False, 0);
  R.Left := Width - 15;
  Inc(R.Right, 15);
  DrawTrackArrowImage(B.Canvas, R, clBtnText);
end;



procedure TspSkinMenuButton.CMDialogChar;
begin
  if not FTrackButtonMode and CanMenuTrack(0, 0)
  then
    begin
      with Message do
      if IsAccel(CharCode, Caption) and CanFocus and FCanFocused
      then
        begin
          SetFocus;
          FMenuTracked := True;
          Down := True;
          TrackMenu;
          Result := 1;
        end
      else
        inherited;
    end
  else
    inherited;  
end;

procedure TspSkinMenuButton.WndProc;
var
  FOld: Boolean;
begin
  FOld := True;
  if FCanFocused and (FSkinPopupMenu <> nil) then
  case Message.Msg of
    WM_KEYDOWN:
      if TWMKEYDOWN(Message).CharCode = VK_SPACE
      then
        begin
          if not FTrackButtonMode and CanMenuTrack(0, 0)
          then
            begin
              FMenuTracked := True;
              Down := True;
              TrackMenu;
              FOld := False;
            end;
        end;
    WM_KEYUP:
      if (TWMKEYUP(Message).CharCode = VK_SPACE) and not FMenuTracked
      then
        begin
          Down := False;
          if Assigned(FOnClick) then FOnClick(Self);
          FOld := False;
        end
      else
      if (TWMKEYUP(Message).CharCode = VK_RETURN) and not FMenuTracked
      then
        begin
          if Assigned(FOnClick) then FOnClick(Self);
        end
   end;
  if FOld then inherited;
end;

function TspSkinMenuButton.GetNewTrackButtonRect;
var
  RM, Off: Integer;
  R: TRect;
begin
  RM := GetResizeMode;
  R := TrackButtonRect;
  case RM of
    2:
      begin
        Off := Width - RectWidth(SkinRect);
        OffsetRect(R, Off, 0);
      end;
    3:
      begin
        Off := Height - RectHeight(SkinRect);
        OffsetRect(R, 0, Off);
      end;
  end;
  Result := R;
end;

function TspSkinMenuButton.CanMenuTrack;
var
  R: TRect;
begin
  if (FSkinPopupMenu = nil) and (FSkinImagesMenu = nil)
  then
    begin
     Result := False;
     Exit;
   end;
   if not FTrackButtonMode
   then
     Result := True
   else
     begin
       if (FIndex <> -1) and (SkinDataName <> 'resizebutton') and
       (SkinDataName <> 'resizetoolbutton') and (SkinDataName <> 'toolbutton')
       and (SkinDataName <> 'bigtoolbutton')
       then R := GetNewTrackButtonRect
       else R := Rect(Width - 15, 0, Width, Height);
       Result := PointInRect(R, Point(X, Y));
     end;
end;

procedure TspSkinMenuButton.WMCLOSESKINMENU;
var
  P: TPoint;
begin
  FMenuTracked := False;
  Down := False;
  GetCursorPos(P);
  FMouseIn := WindowFromPoint(P) = Self.Handle;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
  if FLayerManager.IsVisible and not FMouseIn
  then
    begin
      FLayerManager.Hide;
    end;
  RePaint;  
end;

procedure TspSkinMenuButton.OnImagesMenuClose;
var
  P: TPoint;
begin
  FMenuTracked := False;
  Down := False;
  GetCursorPos(P);
  FMouseIn := WindowFromPoint(P) = Self.Handle;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
  if FLayerManager.IsVisible and not FMouseIn
  then
    begin
      FLayerManager.Hide;
   end;
  ReDrawControl;
end;

procedure TspSkinMenuButton.TrackMenu;
var
  R: TRect;
  P: TPoint;
begin
  if FSkinPopupMenu <> nil
  then
    begin
      if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self);
      P := ClientToScreen(Point(0, 0));
      R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
      FSkinPopupMenu.PopupFromRect2(Self, R, False);
    end;
  if FSkinImagesMenu <> nil
  then
    begin
      if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self);
      P := ClientToScreen(Point(0, 0));
      R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
      FSkinImagesMenu.OnInternalMenuClose := OnImagesMenuClose;
      FSkinImagesMenu.PopupFromRect(R);
    end;
end;

procedure TspSkinMenuButton.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinPopupMenu)
  then FSkinPopupMenu := nil;
end;

procedure TspSkinMenuButton.CMMouseEnter(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then Exit;
  if not FMenuTracked then inherited else FMouseIn := True;
end;

procedure TspSkinMenuButton.CMMouseLeave(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then Exit;
  if not FMenuTracked then inherited else FMouseIn := False;
end;

procedure TspSkinMenuButton.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinMenuButtonControl
    then
      with TspDataSkinMenuButtonControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.TrackButtonRect := TrackButtonRect;
      end;
end;

procedure TspSkinMenuButton.SetTrackButtonMode;
begin
  FTrackButtonMode := Value;
  if FIndex = - 1 then RePaint;
end;

procedure TspSkinMenuButton.MouseDown;
begin
  if Button <> mbLeft
  then
    begin
      inherited;
      Exit;
    end;
  FMenuTracked := CanMenuTrack(X, Y);
  FMouseIn := True;
  if (FIndex <> -1) and not IsNullRect(AnimateSkinRect) then StopAnimate;
  if FMenuTracked
  then
    begin
      if not FDown then Down := True;
      TrackMenu;
    end
  else
    inherited;
end;

procedure TspSkinMenuButton.MouseUp;
begin
  if not FMenuTracked then inherited;
end;

//=========== TspSkinPanel ================

constructor TspSkinPanel.Create;
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  FEmptyDrawing := False;
  FRibbonStyle := False;
  FUseSkinSize := True;   
  FInChangingRollUp := False;  
  FImagePosition := spipDefault;  
  FForceBackGround := True;
  FTransparentMode := False;
  FGlyph := TBitMap.Create;
  FSpacing := 2;
  FNumGlyphs := 1;
  Width := 150;
  Height := 150;
  NewClRect := NullRect;
  FRollUpMode := False;
  FCaptionMode := False;
  FRealHeight := -1;
  FSkinDataName := 'panel';
  BGPictureIndex := -1;
  FDefaultCaptionHeight := 22;
  FAutoEnabledControls := True;
  FCheckedMode := False;
  FCMaxWidth := 0;
  FCMinWidth := 0;
  FCMaxHeight := 0;
  FCMinHeight := 0;
  FCaptionImageList := nil;
  FCaptionImageIndex := -1;
end;

destructor TspSkinPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TspSkinPanel.SetRibbonStyle(Value: Boolean);
begin
  if FRibbonStyle <> Value
  then
    begin
      FRibbonStyle := Value;
      RePaint;
    end;  
end;

procedure TspSkinPanel.PaintTransparent(C: TCanvas);
begin

end;

function TspSkinPanel.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  if FRollUpMode and FInChangingRollUp and AutoSize then Result := False else
    Result := inherited CanAutoSize(NewWidth, NewHeight);
end;


procedure TspSkinPanel.WMMOVE(var Msg: TWMMOVE);
begin
  inherited;
  if FTransparentMode
  then
    begin
      RePaint;
      CheckControlsBackground;
      if Parent is TspSkinControlBar
      then
        TspSkinControlBar(Parent).RePaint;
    end;
end;

procedure TspSkinPanel.SetImagePosition(Value: TspImagePosition);
begin
  if Value <> FImagePosition
  then
    begin
      FImagePosition := Value;
      RePaint;
    end;
end;

procedure TspSkinPanel.WMCHECKPARENTBG;
begin
  if FTransparentMode or AlphaBlend
  then
    begin
      RePaint;
      CheckControlsBackground;
    end;
end;

procedure TspSkinPanel.SetTransparentMode;
begin
  if Value <> FTransparentMode
  then
    begin
      FTransparentMode := Value;
      RePaint;
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        Self.CheckControlsBackground;
    end;
end;

function TspSkinPanel.GetSkinClientRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
  AdjustClientRect(Result);
end;

procedure TspSkinPanel.Notification;
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FCaptionImageList)
  then FCaptionImageList := nil;
end;

procedure TspSkinPanel.SetCaptionImageIndex(Value: Integer);
begin
  if FCaptionImageIndex <> Value
  then
    begin
      FCaptionImageIndex := Value;
      RePaint;
    end;
end;

procedure TspSkinPanel.SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Width := RectWidth(IR);
  B.Height := RectHeight(IR);
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs, IR);
  B.Transparent := True;
  DestCnvs.Draw(X, Y, B);
  B.Free;
end;

procedure TspSkinPanel.SetCheckedMode;
begin
  FCheckedMode := Value;
  RePaint;
end;

procedure TspSkinPanel.SetChecked;
var
  i: Integer;
begin
  FChecked := Value;
  if FCheckedMode then RePaint;
  if FAutoEnabledControls and FCheckedMode
  then
    begin
      for i := 0 to ControlCount -1 do
        Controls[i].Enabled := FChecked;
    end;
  if Assigned(FOnChecked) then FOnChecked(Self);
end;

procedure TspSkinPanel.ShowControls;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
    Controls[i].Visible := True;
  EnableAlign;
end;

procedure TspSkinPanel.HideControls;
var
  i: Integer;
begin
  DisableAlign;
  for i := 0 to ControlCount - 1 do
    Controls[i].Visible := False;
end;

procedure TspSkinPanel.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinPanel.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinPanel.SetSpacing;
begin
  FSpacing := Value;
  RePaint;
end;


procedure TspSkinPanel.SetDefaultAlignment(Value: TAlignment);
begin
  FDefaultAlignment := Value;
  if (FIndex = -1) and FCaptionMode then RePaint;
end;

procedure TspSkinPanel.SetDefaultCaptionHeight;
begin
  FDefaultCaptionHeight := Value;
  if ((FIndex = -1) or not FUseSkinSize) and FCaptionMode
  then
    begin
      RePaint;
      ReAlign;
    end
end;

procedure TspSkinPanel.SetBorderStyle;
begin
  FBorderStyle := Value;
  if FIndex = -1
  then
    begin
      RePaint;
      ReAlign;
    end;
end;

procedure TspSkinPanel.SetRollUpMode(Value: Boolean);
begin
  FRollUpMode := Value;
  if (FIndex = -1) and CaptionMode then RePaint;
end;

procedure  TspSkinPanel.CreateControlResizeImage(B: TBitMap);
var
  R, CR, R1: TRect;
  GlyphNum, BW, CROffset, TX, TY, GX, GY: Integer;
  F: TLogFont;
  W, H: Integer;
  S: String;
  Buffer: TBitMap;
begin
  W := Width;
  H := Height;
  S := FSkinDataName;
  FSkinDataName := 'panel';
  GetSkinData;
  if FIndex <> -1
  then
    begin
      CalcSize(W, H);
      CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
        NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
        B, Picture, SkinRect, Width, Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
    end
  else
    begin
      Exit;
    end;
  FSkinDataName := S;
  GetSkinData;
  //
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(NewClRect);
  Buffer.Height := FDefaultCaptionHeight - NewClRect.Top - 1;
  R1 := CaptionRect;
  InflateRect(R1, -1, -1);
  OffsetRect(R1, SkinRect.Left, SkinRect.Top);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Picture.Canvas, R1);
  B.Canvas.Draw(NewClRect.Left, NewClRect.Top, Buffer);
  Buffer.Free;
  //
  NewCaptionRect := Rect(NewClRect.Left, NewClRect.Top, NewClRect.Right, FDefaultCaptionHeight - 1);
  CreateControlSkinImage(B);
end;

procedure TspSkinPanel.CreateControlDefaultImage;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

var
  R, CR: TRect;
  TX, TY, CS: Integer;
  GX, GY: Integer;
  GlyphNum: Integer;
begin
  inherited;
  R := Rect(0, 0, Width, Height);
  case FBorderStyle of
    bvLowered:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnHighLight, 1);
    bvRaised:
      Frame3D(B.Canvas, R, clBtnHighLight, clBtnShadow, 1);
    bvFrame:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  end;
  if FCaptionMode
  then
    begin
      if FBorderStyle = bvFrame
      then
        begin
          if FRibbonStyle
          then
            R := Rect(0, Height - FDefaultCaptionHeight, Width, Height)
          else
            R := Rect(0, 0, Width, FDefaultCaptionHeight);
          Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
          Frame3D(B.Canvas, R, clBtnHighLight, clBtnFace, 1);
        end
      else
        begin
          if FRibbonStyle
          then
            R := Rect(1, Height - FDefaultCaptionHeight - 1, Width - 1, Height - 1)
          else
            R := Rect(1, 1, Width - 1, FDefaultCaptionHeight);
          Frame3D(B.Canvas, R, clBtnShadow, clBtnHighLight, 1);
          Frame3D(B.Canvas, R, clBtnHighLight, clBtnShadow, 1);
        end;

      if FCheckedMode
      then
        Inc(R.Left, 20);

      if RollUpMode
      then
        Dec(R.Right, 10);

      with B.Canvas do
      begin
        Font.Assign(FDefaultFont);
        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet;
          
        TY := R.Top + RectHeight(R) div 2 - TextHeight(Caption) div 2;
        TX := R.Left + 2;
        case FDefaultAlignment of
          taCenter: TX := TX + RectWidth(R) div 2 - GetGlyphTextWidth div 2;
          taRightJustify: TX := R.Right - GetGlyphTextWidth;
        end;
        if FCheckedMode
        then
          begin
            CS := 14;
            CR.Left := 5;
            CR.Top := R.Top + RectHeight(R) div 2 - CS div 2;
            CR.Right := CR.Left + CS;
            CR.Bottom := CR.Top + CS;
            Frame3D(B.Canvas, CR, clBtnShadow, clBtnShadow, 1);
            if FChecked then DrawCheckImage(B.Canvas, CR.Left + 3, CR.Top + 2,
            clBtnText);
          end;

        if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
          (FCaptionImageIndex < FCaptionImageList.Count)
        then
          begin
           GY := R.Top + RectHeight(R) div 2 - FCaptionImageList.Height div 2;
           GX := TX;
           TX := GX + FCaptionImageList.Width + FSpacing;
          end
       else
        if not FGlyph.Empty
        then
          begin
            GY := R.Top + RectHeight(R) div 2 - FGlyph.Height div 2;
            GX := TX;
            TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
            GlyphNum := 1;
            if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
          end;
        Brush.Style := bsClear;
        TextRect(R, TX, TY, Caption);
        if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
          (FCaptionImageIndex < FCaptionImageList.Count)
        then
         begin
          FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
         end
        else
        if not FGlyph.Empty
        then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
      end;
      if FRollUpMode
      then
        begin
          R.Left := R.Right;
          R.Right := R.Left + 10;
          if FRollUpState
          then DrawArrowImage(B.Canvas, R, clBtnText, 4)
          else DrawArrowImage(B.Canvas, R, clBtnText, 3);
        end;
  end;
end;

procedure TspSkinPanel.MouseUp;
begin
  if (FRollUpMode or FCheckedMode) and FCaptionMode and (Button = mbLeft)
  then
    begin
      if ( (FIndex <> -1) and PointInRect(NewCaptionRect, Point(X, Y)))
         or
         ((FIndex = -1) and PointInRect(Rect(1, 1, Width - 1, FDefaultCaptionHeight),
           Point(X, Y)))
      then
        begin
          if CheckedMode
          then
            Checked := not Checked;

          if RollUpMode
          then
            RollUpState := not FRollUpState;
        end;
    end;
  inherited;
end;

procedure TspSkinPanel.DoRollUp(ARollUp: Boolean);
begin
  FInChangingRollUp := True;
  if FIndex <> -1
  then
    begin
      if ARollUp and (FRealHeight = -1)
      then
        begin
          FRealHeight := Height;
          HideControls;
          if not FUseSkinSize
          then
            Height := FDefaultCaptionHeight + 1
          else
            Height := NewClRect.Top + (Height - NewClRect.Bottom);
        end
      else
        if not ARollUp and (FRealHeight <> -1)
        then
          begin
            Height := FRealHeight;
            FRealHeight := -1;
            ShowControls;
          end;
    end
  else
    begin
      if ARollUp and (FRealHeight = -1)
      then
        begin
          FRealHeight := Height;
          HideControls;
          Height := FDEfaultCaptionHeight + 1;
        end
      else
        if not ARollUp and (FRealHeight <> -1)
        then
          begin
            Height := FRealHeight;
            FRealHeight := -1;
            ShowControls;
          end;
    end;
  FInChangingRollUp := False;
end;

procedure TspSkinPanel.SetRollUpState;
begin
  if FRollUpState = Value then Exit;
  if FRollUpMode
  then
    begin
      //
      FCMaxWidth := Constraints.MaxWidth;
      FCMinWidth := Constraints.MinWidth;
      FCMaxHeight := Constraints.MaxHeight;
      FCMinHeight := Constraints.MinHeight;
      Constraints.MaxWidth := 0;
      Constraints.MaxHeight := 0;
      Constraints.MinHeight := 0;
      Constraints.MinWidth := 0;
      //
      FRollUpState := Value;
      DoRollUp(FRollUpState);
      if Assigned (FOnChangeRollUpState) then FOnChangeRollUpState(Self); 
    end
  else
    begin
      //
      Constraints.MaxWidth := FCMaxWidth;
      Constraints.MinWidth := FCMinWidth;
      Constraints.MaxHeight := FCMaxHeight;
      Constraints.MinHeight := FCMinHeight;
      //
      FRollUpState := False;
    end;
end;

procedure TspSkinPanel.SetCaptionMode;
begin
  FCaptionMode := Value;
  RePaint;
  ReAlign;
end;

procedure TspSkinPanel.SetBounds;
begin
  inherited;
  if FIndex = -1 then RePaint;
end;

procedure TspSkinPanel.SetAlphaBlend;
begin
  FAlphaBlend := AValue;
  RePaint;
end;

procedure TspSkinPanel.SetAlphaBlendValue;
begin
  FAlphaBlendValue := AValue;
  RePaint;
end;

procedure TspSkinPanel.GetSkinData;
begin
  inherited;
  BGPictureIndex := -1;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinPanelControl
    then
      with TspDataSkinPanelControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.CaptionRect := CaptionRect;
        Self.Alignment := Alignment;
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.BGPictureIndex := BGPictureIndex;
        Self.CheckImageRect := CheckImageRect;
        Self.UnCheckImageRect := UnCheckImageRect;
        Self.MarkFrameRect := MarkFrameRect;
        Self.FrameRect := FrameRect;
        Self.FrameTextRect := FrameTextRect;
        Self.FrameLeftOffset := FrameLeftOffset;
        Self.FrameRightOffset := FrameRightOffset;
      end;
end;

function TspSkinPanel.GetTranparentClientRect;
begin
  if FTransparentMode and not CaptionMode and (FIndex <> -1)
  then
    Result := Rect(2, 2, Width - 2, Height - 2)
  else
    with Canvas do
    begin
      if FUseSkinFont
      then
       begin
         Font.Name := FontName;
         Font.Height := FontHeight;
         Font.Style := FontStyle;
       end
       else
      Font.Assign(FDefaultFont);
      Result := Rect(2, TextHeight(Caption), Width - 2, Height - 2);
    end;
end;


procedure TspSkinPanel.AdjustClientRect(var Rect: TRect);
var
  R: TRect;
begin
  inherited AdjustClientRect(Rect);
  if FEmptyDrawing then Exit;
  if (FIndex <> -1) and  FTransparentMode
  then
    begin
      Rect := GetTranparentClientRect;
    end
  else
  if (FIndex <> -1) and not (csDesigning in ComponentState)
  then
    begin
      R := Rect;
      if (BGPictureIndex = -1) and not ((BorderStyle = bvNone) and not CaptionMode and
         (ResizeMode = 1))
      then Rect := NewClRect;
      if not FUseSkinSize and CaptionMode
      then
        begin
          if not FRibbonStyle
          then
            Rect.Top := R.Top + FDefaultCaptionHeight
          else
            Rect.Bottom := R.Bottom - FDefaultCaptionHeight;
        end;
    end
  else
    begin
      if FBorderStyle <> bvNone then InflateRect(Rect, -1, -1);
      if FCaptionMode
      then
        if FRibbonStyle
        then
          Rect.Bottom := Rect.Bottom - FDefaultCaptionHeight
        else
          Rect.Top := Rect.Top + FDefaultCaptionHeight;
    end;
end;

procedure TspSkinPanel.CreateControlSkinImage;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

procedure DrawCaption;
var
  TX, TY, GX, GY, CW, CH: Integer;
  GlyphNum: Integer;
  MR, CR, CapRect, R: TRect;
  FX, W, Offset: Integer;
  Buffer: TBitMap;
begin
  CapRect := NewCaptionRect;
  if FRollUpMode then Dec(CapRect.Right, 12);

  if FCheckedMode
  then
    begin
      CW := RectWidth(CheckImageRect);
      CH := RectHeight(CheckImageRect);
      CR.Left := CapRect.Left;
      CR.Top := CapRect.Top + RectHeight(CapRect) div 2 - CH div 2;
      CR.Right := CR.Left + CW;
      CR.Bottom := CR.Top + CH;
      if FChecked
      then
        SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, CheckImageRect, B.Canvas)
      else
        SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, UnCheckImageRect, B.Canvas);
      Inc(CapRect.Left, CW + 2);
    end;

  with B.Canvas do
  begin
    if FUseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Height := FontHeight;
        Font.Style := FontStyle;
        Font.CharSet := FDefaultFont.Charset;
      end
    else
      Font.Assign(FDefaultFont);

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
   then
     Font.Charset := SkinData.ResourceStrData.CharSet
   else
     Font.CharSet := FDefaultFont.Charset;

    Font.Color := FontColor;
    TY := CapRect.Top +
      RectHeight(CapRect) div 2 - TextHeight(Caption) div 2;

    //
    if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(TY, 1);
    //

    TX := CapRect.Left;
    case Alignment of
      taCenter: TX := TX +
        RectWidth(CapRect) div 2 - GetGlyphTextWidth div 2;
      taRightJustify: TX := CapRect.Right - GetGlyphTextWidth;
    end;

    Brush.Style := bsClear;

     if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
    then
      begin
        GY := CapRect.Top + RectHeight(CapRect) div 2 - FCaptionImageList.Height div 2;
        if ImagePosition = spipDefault
        then
          begin
            GX := TX;
            TX := GX + FCaptionImageList.Width + FSpacing;
          end
        else
          begin
            GX := CapRect.Left + 2;
            TX := GX + FCaptionImageList.Width + FSpacing;
            case Alignment of
              taCenter: TX := CapRect.Left + RectWidth(CapRect) div 2 -
                TextWidth(Caption) div 2;
              taRightJustify: TX := CapRect.Right - TextWidth(Caption);
            end;
            if TX < GX + FCaptionImageList.Width + FSpacing
            then
              TX := GX + FCaptionImageList.Width + FSpacing;
          end;
      end
    else
    if not FGlyph.Empty
    then
      begin
        GY := CapRect.Top + RectHeight(CapRect) div 2 - FGlyph.Height div 2;
        if ImagePosition = spipDefault
        then
          begin
            GX := TX;
            TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
          end
        else
          begin
            GX := CapRect.Left + 2;
            TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
            case Alignment of
              taCenter: TX := CapRect.Left + RectWidth(CapRect) div 2 -
                TextWidth(Caption) div 2;
              taRightJustify: TX := CapRect.Right - TextWidth(Caption);
            end;
            if TX < GX + FGlyph.Width div FNumGlyphs + FSpacing
            then
              TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
          end;
        GlyphNum := 1;
        if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
       end;


     if FRollUpMode
     then
       begin
         R := CapRect;
         R.Left := R.Right;
         R.Right := R.Right + 10;
         if not IsNullRect(MarkFrameRect)
         then
           begin
             MR := Rect(R.Left, R.Top,
                        R.Left + RectWidth(MarkFrameRect),
                        CaptionRect.Top + RectHeight(MarkFrameRect));
             B.Canvas.CopyRect(MR, Picture.Canvas, MarkFrameRect);
           end;
         if FRollUpState
         then DrawArrowImage(B.Canvas, R, FontColor, 4)
         else DrawArrowImage(B.Canvas, R, FontColor, 3);
       end;

    if not IsNullRect(Self.FrameRect)
    then
      begin
        Offset := RectWidth(Self.FrameRect) - RectWidth(Self.FrameTextRect);
        W := TextWidth(Caption) + Offset;
        Buffer := TBitMap.Create;
        CreateHSkinImage(FrameLeftOffset, FrameRightOffset, Buffer,
        Picture, Self.FrameRect, W, RectHeight(Self.FrameRect), False);
        //
        case Alignment of
          taLeftJustify:
            begin
              FX := TX;
              TX := FX + Self.FrameTextRect.Left;
            end;
          taCenter:
            begin
              FX := TX - Self.FrameTextRect.Left - 2;
              GX := GX - Self.FrameTextRect.Left;
              TX := FX + Self.FrameTextRect.Left;
            end;
          taRightJustify:
            begin
              FX := TX - Offset;
              TX := FX + Self.FrameTextRect.Left;
              GX := GX - Offset;
            end;
        end;
        //
        Draw(FX, CaptionRect.Top, Buffer);
        Buffer.Free;
      end;


    TextRect(CapRect, TX, TY, Caption);
    if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
    then
      begin
        FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
      end
    else
    if not FGlyph.Empty
    then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
  end;
end;

var
  X, Y, XCnt, YCnt, XO, YO, w, h, w1, h1: Integer;
begin
 if (BorderStyle = bvNone) and (ResizeMode = 1) and not CaptionMode and
     not StretchEffect
  then
    with B.Canvas do
    begin
      w1 := Width;
      h1 := Height;
      w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      XCnt := w1 div w;
      YCnt := h1 div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
      begin
        if X * w + w > w1 then XO := X * w + w - w1 else XO := 0;
        if Y * h + h > h1 then YO := Y * h + h - h1 else YO := 0;
        CopyRect(Rect(X * w, Y * h, X * w + w - XO, Y * h + h - YO),
                 Picture.Canvas,
                 Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                 SkinRect.Left + ClRect.Right - XO,
                 SkinRect.Top + ClRect.Bottom - YO));
      end;           
    end
  else
    begin
      inherited;
      if FUseSkinSize
      then
        if ResizeMode > 0
        then NewCaptionRect := GetNewRect(CaptionRect)
        else NewCaptionRect := CaptionRect;
      if (Caption <> '') and not IsNullRect(CaptionRect)
      then DrawCaption;
    end;
end;

procedure TspSkinPanel.Paint;

function GetCaptionColor: TColor;
var
  CIndex: integer;
begin
  CIndex := FSD.GetControlIndex('stdlabel');
  if CIndex = -1
  then Result := FSD.SkinColors.cBtnText
  else Result := TspDataSkinStdLabelControl(FSD.CtrlList[CIndex]).FontColor;
end;



var
  RealPicture, Buffer2: TBitMap;
  FrameColor, LeftOffset: TColor;
  GlyphNum, GX, GY, X, Y, XCnt, YCnt: Integer;
  w, h, w1, h1, CW, CH: Integer;
  ICR, CR, R: TRect;
begin
   if (Width <= 0) or (Height <= 0) or
    (FEmptyDrawing and not (csDesigning in ComponentState)) then Exit;
  
  GetSkinData;
   //
  if (FIndex <> -1) and not FUseSkinSize and not FTransparentMode and FCaptionMode
  then
    begin
      Buffer2 := TBitMap.Create;
      Buffer2.Width := Self.Width;
      Buffer2.Height := Self.Height;
      CreateControlResizeImage(Buffer2);
      Canvas.Draw(0, 0, Buffer2);
      Buffer2.Free;
      Exit;
    end;
  //
  if FTransparentMode and not CaptionMode and (FIndex <> -1)
  then
    begin
      Buffer2 := TBitMap.Create;
      Buffer2.Width := Width;
      Buffer2.Height := Height;
      GetParentImage(Self, Buffer2.Canvas);
      if BorderStyle <> bvNone
      then
        with Buffer2.Canvas do
        begin
          Brush.Style := bsClear;
          FrameColor := FSD.SkinColors.cBtnShadow;
          Pen.Color := FrameColor;
          Rectangle(0, 0, Width, Height);
        end;
      PaintTransparent(Buffer2.Canvas);
      Canvas.Draw(0, 0, Buffer2);
      Buffer2.Free;
      Exit;
    end
  else  
  if FTransparentMode and CaptionMode and (FIndex <> -1)
  then
    begin
      Buffer2 := TBitMap.Create;
      Buffer2.Width := Width;
      Buffer2.Height := Height;
      GetParentImage(Self, Buffer2.Canvas);
      // draw frame
      with Buffer2.Canvas do
      begin
        FrameColor := FSD.SkinColors.cBtnShadow;
        Pen.Color := FrameColor;
        Pen.Width := 1;
        Brush.Style := bsClear;
        // draw text
        if FUseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Height := FontHeight;
            Font.Style := FontStyle;
          end
        else
          Font.Assign(FDefaultFont);
        LeftOffset := 5;
        CR := Rect(LeftOffset, 0, Buffer2.Width, TextHeight(Caption) + 5);

        NewCaptionRect := CR;

        // draw check image

        if FCheckedMode
        then
          begin
            CW := RectWidth(CheckImageRect);
            CH := RectHeight(CheckImageRect);
            ICR.Left := CR.Left;
            ICR.Top := CR.Top + RectHeight(CR) div 2 - CH div 2;
            ICR.Right := ICR.Left + CW;
            ICR.Bottom := ICR.Top + CH;
            if FChecked
            then
              SkinDrawCheckImage(ICR.Left, ICR.Top, Picture.Canvas, CheckImageRect, Buffer2.Canvas)
            else
              SkinDrawCheckImage(ICR.Left, ICR.Top, Picture.Canvas, UnCheckImageRect, Buffer2.Canvas);
            Inc(LeftOffset, CW + 5);
          end;

        // calc image pos

        if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
          (FCaptionImageIndex < FCaptionImageList.Count)
        then
          begin
            GY := CR.Top + RectHeight(CR) div 2 - FCaptionImageList.Height div 2;
            GX := LeftOffset;
            Inc(LeftOffset, FCaptionImageList.Width + 2)
          end
        else
         if not FGlyph.Empty
          then
            begin
              GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
              GX := LeftOffset;
              Inc(LeftOffset, FGlyph.Width div FNumGlyphs + 2);
              GlyphNum := 1;
              if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
            end;

        // draw text

        CR := Rect(LeftOffset, 0, Buffer2.Width, TextHeight(Caption) + 5);
        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet
        else
          Font.CharSet := FDefaultFont.Charset;

        Font.Color := GetCaptionColor;

        SPDrawText(Buffer2.Canvas, Caption, CR);
        R := Rect(0, 0, 0, 0);
        DrawText(Buffer2.Canvas.Handle, PChar(Caption), Length(Caption), R,
            DT_CALCRECT or DT_LEFT);

        // draw image

        if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
          FCaptionImageList.Draw(Buffer2.Canvas, GX, GY, FCaptionImageIndex, Enabled);
        end
       else
         if not FGlyph.Empty
         then DrawGlyph(Buffer2.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);

        // draw rollup marker

        if FRollUpMode
        then
          begin
            ICR := Rect(CR.Left + RectWidth(R) + 3, CR.Top,
                        CR.Left + RectWidth(R) + 10, CR.Bottom);
            if FRollUpState
            then DrawArrowImage(Buffer2.Canvas, ICR,  Font.Color, 4)
            else DrawArrowImage(Buffer2.Canvas, ICR,  Font.Color, 3);
            Pen.Color := FrameColor;
            MoveTo(CR.Left + RectWidth(R) + 12, RectHeight(CR) div 2);
            LineTo(Width, RectHeight(CR) div 2);
          end
        else
          begin
            Pen.Color := FrameColor;
            MoveTo(CR.Left + RectWidth(R) + 3, RectHeight(CR) div 2);
            LineTo(Width, RectHeight(CR) div 2);
          end;
        //
        Pen.Color := FrameColor;
        MoveTo(0, RectHeight(CR) div 2);
        LineTo(4, RectHeight(CR) div 2) ;
        MoveTo(CR.Right + 2, RectHeight(CR) div 2);
        LineTo(Width - 1, CR.Top + RectHeight(CR) div 2);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, RectHeight(CR) div 2);
      end;
      //
      PaintTransparent(Buffer2.Canvas);
      Canvas.Draw(0, 0, Buffer2);
      Buffer2.Free;
      Exit;
    end;

  if (FIndex =-1) or ((FIndex <> -1) and not FForceBackground and StretchEffect)
  then
    inherited
  else
  if (BorderStyle = bvNone) and (ResizeMode = 1) and not CaptionMode and
      FForcebackground and not AlphaBlend
  then
    begin
       w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      w1 := Width;
      h1 := Height;
      XCnt := w1 div w;
      YCnt := h1 div h;
      RealPicture := TBitMap.Create;
      RealPicture.Width := w;
      RealPicture.Height := h;
      RealPicture.Canvas.CopyRect(Rect(0, 0, w, h), Picture.Canvas,
      Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
           SkinRect.Left + ClRect.Right,
           SkinRect.Top + ClRect.Bottom));
      if StretchEffect
      then
        begin
          case StretchType of
            spstFull:
              Canvas.StretchDraw(Rect(0, 0, Width, Height), RealPicture);
            spstHorz:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := RealPicture.Width;
                Buffer2.Height := h1;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                XCnt := w1 div Buffer2.Width;
                 for X := 0 to XCnt do
                   Canvas.Draw(X * Buffer2.Width, 0, Buffer2);
                 Buffer2.Free;
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := w1;
                Buffer2.Height := RealPicture.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                YCnt := h1 div Buffer2.Height;
                for Y := 0 to YCnt do
                  Canvas.Draw(0, Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
          end;
        end
      else
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
       begin
         Canvas.Draw(X * w, Y * h, RealPicture);
       end;
      RealPicture.Free;
    end
  else
  if BGPictureIndex <> -1
  then
    begin
      RealPicture := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
      if (Width > 0) and (Height > 0)
      then
        begin
          if StretchEffect
          then
            begin
              case StretchType of
                spstFull:
                 Canvas.StretchDraw(NewClRect, RealPicture);
                spstHorz:
                  begin
                    Buffer2 := TBitMap.Create;
                    Buffer2.Width := RealPicture.Width;
                    Buffer2.Height := h1;
                    Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                    XCnt := w1 div Buffer2.Width;
                    for X := 0 to XCnt do
                      Canvas.Draw(X * Buffer2.Width, 0, Buffer2);
                    Buffer2.Free;
                  end;
               spstVert:
                 begin
                   Buffer2 := TBitMap.Create;
                   Buffer2.Width := w1;
                   Buffer2.Height := RealPicture.Height;
                   Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                   YCnt := h1 div Buffer2.Height;
                   for Y := 0 to YCnt do
                     Canvas.Draw(0, Y * Buffer2.Height, Buffer2);
                   Buffer2.Free;
                 end;
              end;
            end
          else
            begin
              XCnt := Width div RealPicture.Width;
              YCnt := Height div RealPicture.Height;
              for X := 0 to XCnt do
              for Y := 0 to YCnt do
              Canvas.Draw(X * RealPicture.Width, Y * RealPicture.Height, RealPicture);
            end;
        end;
    end
  else
    inherited;
end;

procedure TspSkinPanel.ChangeSkinData;
var
  TempOldHeight: Integer;
begin
  inherited;
  if FRollUpState
  then
    begin
      TempOldHeight := FRealHeight;
      FRealHeight := -1;
      DoRollUp(True);
      FRealHeight := TempOldHeight;
    end
  else
    ReAlign;
end;

procedure TspSkinPanel.CMTextChanged;
begin
  if FCaptionMode then RePaint;
end;

procedure TspSkinPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

constructor TspSkinPaintPanel.Create;
begin
  inherited Create(AOwner);
  FForceBackground := False;
end;

procedure TspSkinPaintPanel.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinPaintPanel.PaintTransparent;
begin
  if Assigned(FOnPanelPaint) then FOnPanelPaint(C, Self.GetSkinClientRect);
end;

procedure TspSkinPaintPanel.CreateControlDefaultImage(B: TBitMap);
begin
  inherited;
  if Assigned(FOnPanelPaint) then FOnPanelPaint(B.Canvas, Self.GetSkinClientRect);
end;

procedure TspSkinPaintPanel.CreateControlSkinImage(B: TBitMap); 
begin
  inherited;
  if Assigned(FOnPanelPaint) then FOnPanelPaint(B.Canvas, Self.GetSkinClientRect);
end;

constructor TspSkinGroupBox.Create;
begin
  inherited;
  FSkinDataName := 'groupbox';
  CaptionMode := True;
end;

procedure TspSkinGroupBox.GetSkinData; 
begin
  inherited;
  if CaptionRect.Top > ClRect.Bottom
  then
    FForceBackground := False;
end;


constructor TspSkinStatusBar.Create;
begin
  inherited;
  FSkinDataName := 'statusbar';
  Align := alBottom;
  Height := 21;
  BorderStyle := bvNone;
  FSizeGrip := False;
  FShowGrip := True;
  FForceBackGround := False;
end;

procedure TspSkinStatusBar.WMNCHitTest;
var
  R: TRect;
  P: TPoint;
begin
  if not (csDesigning in ComponentState) and FSizeGrip and FShowGrip
  then
    begin
      R := GetGripRect;
      P := ScreenToClient(SmallPointToPoint(TWMNCHitTest(Message).Pos));
      if PointInRect(R, P)
      then
        Message.Result := HTBOTTOMRIGHT
      else
        Message.Result := HTCLIENT;
    end
  else
    inherited;
end;

function TspSkinStatusBar.GetGripRect: TRect;
var
  R: TRect;
begin
  R := GetSkinClientRect;
  if (FIndex <> -1) and not IsNullRect(GripperRect)
  then
    begin
      Result := Rect(R.Right, R.Bottom - RectHeight(GripperRect),
        R.Right + RectWidth(GripperRect), R.Bottom);
    end
  else
    begin
      Result := Rect(R.Right, R.Top, R.Right + RectHeight(R), R.Bottom);
      Dec(Result.Bottom, 2);
      Inc(Result.Left, 2);
    end;
end;

procedure TspSkinStatusBar.CreateControlDefaultImage(B: TBitMap);
var
  R: TRect;
begin
  inherited;
  if FSizeGrip and FShowGrip
  then
    begin
      R := GetGripRect;
      DrawDefaultGripper(R, B.Canvas, clBtnShadow, clBtnHighLight);
    end;
end;

procedure TspSkinStatusBar.CreateControlSkinImage(B: TBitMap);
var
  R: TRect;
  GripperBuffer: TBitMap;
begin
  inherited;
  R := GetGripRect;
  if FSizeGrip and FShowGrip
  then
    begin
      if IsNullRect(GripperRect)
      then
         DrawDefaultGripper(R, B.Canvas, SkinData.SkinColors.cBtnShadow, SkinData.SkinColors.cBtnHighLight)
      else
        begin
          GripperBuffer := TBitMap.Create;
          GripperBuffer.Width := RectWidth(GripperRect);
          GripperBuffer.Height := RectHeight(GripperRect);
          GripperBuffer.Canvas.CopyRect(
             Rect(0, 0, GripperBuffer.Width, GripperBuffer.Height),
            Picture.Canvas, GripperRect);
          if GripperTransparent
          then
            begin
              GripperBuffer.Transparent := True;
              GripperBuffer.TransparentMode := tmFixed;
              GripperBuffer.TransparentColor := GripperTransparentColor;
            end;
          B.Canvas.Draw(R.Left, R.Top, GripperBuffer);
          GripperBuffer.Free;
        end;
    end;
end;

procedure TspSkinStatusBar.DrawDefaultGripper(R: TRect; Cnvs: TCanvas; C1, C2: TColor);
var
  I, Count: Integer;
  k: Integer;
begin
  Count := RectWidth(R) div 3;
  k := 3;
  with Cnvs do
  begin
    for i := 0 to Count do
    if R.Left + k + 2 <= R.Right then
    begin
      Pen.Color := C1;
      MoveTo(R.Left + k, R.Bottom);
      LineTo(R.Right, R.Top + k);
      Pen.Color := C2;
      MoveTo(R.Left + k + 1, R.Bottom);
      LineTo(R.Right, R.Top + k + 1);
      Inc(k, 3);
    end;
  end;
end;

procedure TspSkinStatusBar.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if FSizeGrip and FShowGrip
  then
    begin
      if (FIndex <> -1) and not IsNullRect(GripperRect)
      then
        Dec(Rect.Right, RectWidth(GripperRect))
      else
        Dec(Rect.Right, RectHeight(Rect));
    end;
end;

procedure TspSkinStatusBar.SetShowGrip(Value: Boolean);
begin
  FShowGrip := Value;
  RePaint;
  ReAlign;
end;

procedure TspSkinStatusBar.SetSizeGrip(Value: Boolean);
begin
  FSizeGrip := Value;
  RePaint;
  ReAlign;
end;

procedure TspSkinStatusBar.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinPanelControl
      then
        with TspDataSkinPanelControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.GripperRect := GripperRect;
          Self.GripperTransparent := GripperTransparent;
          Self.GripperTransparentColor := GripperTransparentColor;
        end;
     end;
end;

procedure TspSkinStatusBar.SetSkinData;
var
  I: Integer;
begin
  inherited;
  for I := 0 to ControlCount - 1 do
  if Controls[I] is TspSkinControl
  then
    TspSkinControl(Controls[I]).SkinData := Self.SkinData
end;

//=========== TspSkinCheckRadioBox ===============
constructor TspSkinCheckRadioBox.Create;
begin
  inherited;
  FDown := False;
  FUseSkinFontColor := True;
  FWordWrap := False;
  FCanFocused := True;
  TabStop := False;
  FMouseIn := False;
  Width := 150;
  Height := 25;
  FGroupIndex := 0;
  FMorphKf := 0;
  MorphTimer := nil;
  FSkinDataName := 'checkbox';
  FFlat := True;
end;

destructor TspSkinCheckRadioBox.Destroy;
begin
  StopMorph;
  inherited;
end;

procedure TspSkinCheckRadioBox.CheckParentBackground;
begin
  if FFlat then RePaint;
end;


procedure TspSkinCheckRadioBox.SetWordWrap;
begin
  if FWordWrap <> Value
  then
    begin
      FWordWrap := Value;
      if FFlat then RePaint;
    end;  
end;

procedure TspSkinCheckRadioBox.SkinDrawGrayedCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
var
  B: TBitMap;
  Buffer: TspEffectBmp;
  R: TRect;
begin
  B := TBitMap.Create;
  if IsNullRect(GrayedCheckImageRect)
  then
    begin
      B.Width := RectWidth(IR);
      B.Height := RectHeight(IR);
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs, IR);
      Buffer := TspEffectBmp.CreateFromhWnd(B.Handle);
      Buffer.ChangeBrightness(0.5);
      Buffer.Draw(B.Canvas.Handle, 0, 0);
      Buffer.Free;
     end
  else
    begin
      if FMouseIn and not IsNullRect(ActiveGrayedCheckImageRect)
      then
        R := ActiveGrayedCheckImageRect
      else
        R := GrayedCheckImageRect;
      B.Width := RectWidth(R);
      B.Height := RectHeight(R);
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs, R);
    end;
  B.Transparent := True;
  DestCnvs.Draw(X, Y, B);
  B.Free;
end;

procedure TspSkinCheckRadioBox.SetAllowGrayed(Value: Boolean);
begin
  FAllowGrayed := Value;
  RePaint;
end;

procedure TspSkinCheckRadioBox.SetState(Value: TCheckBoxState);
begin
  FState := Value;
  if FState = cbChecked
  then
    FChecked := True
  else
    FChecked := False;
  RePaint;  
  if Assigned(FOnClick) then FOnClick(Self);
end;

function TspSkinCheckRadioBox.EnableMorphing: Boolean;
begin
  Result := Morphing and (SkinData <> nil) and not SkinData.Empty and
            SkinData.EnableSkinEffects;
end;

procedure TspSkinCheckRadioBox.WMEraseBkgnd;
begin
  if not FromWMPaint and not Flat
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinCheckRadioBox.CMEnabledChanged;
begin
  inherited;
  if EnableMorphing
  then
    begin
      StopMorph;
      FMorphKf := 0;
    end;
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinCheckRadioBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then Images := nil;
  end;
end;

procedure TspSkinCheckRadioBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
  RePaint;
end;

procedure TspSkinCheckRadioBox.SetImageIndex(Value: Integer);
begin
  FImageIndex := Value;
  RePaint;
end;

procedure TspSkinCheckRadioBox.WMMOVE;
begin
  inherited;
  Invalidate;
end;

procedure TspSkinCheckRadioBox.SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Width := RectWidth(IR);
  B.Height := RectHeight(IR);
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs, IR);
  B.Transparent := True;
  DestCnvs.Draw(X, Y, B);
  B.Free;
end;

procedure TspSkinCheckRadioBox.SetFlat;
begin
  FFlat := Value;
  RePaint;
end;

procedure TspSkinCheckRadioBox.StartMorph;
begin
  if MorphTimer <> nil then Exit;
  MorphTimer := TTimer.Create(Self);
  MorphTimer.Interval := MorphTimerInterval;
  MorphTimer.OnTimer := DoMorph;
  MorphTimer.Enabled := True;
end;

procedure TspSkinCheckRadioBox.StopMorph;
begin
  if MorphTimer = nil then Exit;
  MorphTimer.Enabled := False;
  MorphTimer.Free;
  MorphTimer := nil;
end;

procedure TspSkinCheckRadioBox.Paint;
var
  PBuffer, APBuffer, PIBuffer: TspEffectBmp;
  ParentImage, Buffer, ABuffer: TBitMap;
  kf: Double;
  TR, IR, TR1: TRect;
  IX, IY, TY: Integer;
  ImX, ImY: Integer;
  C: TColor;
begin
  GetSkinData;
  if FFlat
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      GetParentImage(Self, Buffer.Canvas);
      if FIndex = -1
      then
        with Buffer.Canvas do
        begin
          IR := Rect(3, Height div 2 - 7, 17, Height div 2 + 7);
          // draw caption
          Font := DefaultFont;
          if (SkinData <> nil) and (SkinData.ResourceStrData <>  nil)
          then
            Font.Charset := SkinData.ResourceStrData.CharSet;
          Brush.Style := bsClear;
          if not FWordWrap
          then
            begin
              TR := Rect(0, 0, 0, 0);
              DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
                DT_CALCRECT)
            end
          else
            begin
              TR := ClientRect;
              TR.Left := 22;
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                begin
                  TR.Left := TR.Left + FImages.Width;
                end;
              TR1 := TR;  
              DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR1,
                DT_EXPANDTABS or DT_WORDBREAK  or DT_CALCRECT);
              TY := Height div 2 - RectHeight(TR1) div 2;
              if TY < 0 then TY := 0;
              TR1 := Rect(TR1.Left, TY, TR1.Right, TY + RectHeight(TR1));
              TR := ClientRect;
            end;
          OffsetRect(TR, 22, Height div 2 - RectHeight(TR) div 2);
          if TR.Right > Width - 2 then TR.Right := Width - 2;
          if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
          then
            begin
              ImX := TR.Left;
              ImY := Height div 2 - FImages.Height div 2;
              FIMages.Draw(Buffer.Canvas, ImX, ImY, FImageIndex, Enabled);
              OffsetRect(TR, FImages.Width + 5, 0);
            end;
          Brush.Style := bsClear;
          if not Enabled then Font.Color := clBtnShadow;
          if FWordWrap
          then
            DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR1,
               DT_EXPANDTABS or DT_WORDBREAK)
          else
            SPDrawText(Buffer.Canvas, Caption, TR);
          // draw glyph
          if FMouseIn
          then
            Frame3D(Buffer.Canvas, IR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1)
          else
            Frame3D(Buffer.Canvas, IR, clbtnShadow, clbtnShadow, 1);
          Pen.Color := clBlack;
          if (FState = cbGrayed) and not FRadio
          then
            begin
              C := clGrayText;
              DrawCheckImage(Buffer.Canvas, 7, Height div 2 - 4, C);
           end
          else
          if FChecked
          then
            begin
              if Enabled then C := clBlack else C := clBtnShadow;
              if FRadio
              then DrawRadioImage(Buffer.Canvas, 7, Height div 2 - 3, C)
              else DrawCheckImage(Buffer.Canvas, 7, Height div 2 - 4, C);
            end;
          // draw focus
          InflateRect(TR, 2, 1);
          Inc(TR.Right, 1 );
          Brush.Style := bsSolid;
          Brush.Color := clBtnFace;
          if IsFocused
          then
            if Caption <> ''
            then
              begin
                if FWordWrap
                then
                  begin
                    InflateRect(TR1, 2, 1);
                    DrawSkinFocusRect(Buffer.Canvas, TR1);
                  end
                else
                  DrawSkinFocusRect(Buffer.Canvas, TR)
              end
            else
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                DrawSkinFocusRect(Buffer.Canvas, Rect(ImX - 1, ImY - 1,
                  ImX + FImages.Width + 1, ImY + FImages.Height + 1));
        end
      else
        with Buffer.Canvas do
        begin
          // draw glyph
          IX := 3;
          IY := Height div 2 - RectHeight(CheckImageRect) div 2;
          if not Enabled
          then
            begin
              if FState = cbGrayed
              then
                SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas,  UnEnabledCheckImageRect, Buffer.Canvas)
              else
              if FChecked
              then
                SkinDrawCheckImage(IX, IY, Picture.Canvas, UnEnabledCheckImageRect, Buffer.Canvas)
              else
                SkinDrawCheckImage(IX, IY, Picture.Canvas, UnEnabledUnCheckImageRect, Buffer.Canvas);
            end
          else
          if FMouseIn
          then
            begin
              if FState = cbGrayed
              then
                SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas, ActiveCheckImageRect, Buffer.Canvas)
              else
              if FChecked
              then
                SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveCheckImageRect, Buffer.Canvas)
              else
                SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveUnCheckImageRect, Buffer.Canvas);
            end
          else
            begin
              if FState = cbGrayed
              then
                SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas, CheckImageRect, Buffer.Canvas)
              else
              if FChecked
              then
                SkinDrawCheckImage(IX, IY, Picture.Canvas, CheckImageRect, Buffer.Canvas)
              else
                SkinDrawCheckImage(IX, IY, Picture.Canvas, UnCheckImageRect, Buffer.Canvas);
            end;

          // draw caption
          if FUseSkinFont
          then
            begin
              Font.Name := FontName;
              Font.Height := FontHeight;
              Font.Style := FontStyle;
             end
          else
            Font.Assign(FDefaultFont);
          if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
          then
            Font.Charset := SkinData.ResourceStrData.CharSet
          else
            Font.CharSet := FDefaultFont.Charset;
          if not FWordWrap
          then
            begin
              TR := Rect(0, 0, 0, 0);
              DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
                DT_CALCRECT);
             end
           else
            begin
              TR := ClientRect;
              TR.Left := RectWidth(CheckIMageRect) + 7;
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                begin
                  TR.Left := TR.Left + FImages.Width;
                end;
              TR1 := TR;
              DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR1,
                DT_EXPANDTABS or DT_WORDBREAK  or DT_CALCRECT);
              TY := Height div 2 - RectHeight(TR1) div 2;
              if TY < 0 then TY := 0;
              TR1 := Rect(TR1.Left, TY, TR1.Right, TY + RectHeight(TR1));
              TR := ClientRect;
            end;
          OffsetRect(TR, IX + RectWidth(CheckIMageRect) + 4, Height div 2 - RectHeight(TR) div 2);
          if TR.Right > Width - 2 then TR.Right := Width - 2;
          //
          if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
          then
            begin
              ImX := TR.Left;
              ImY := Height div 2 - FImages.Height div 2;
              FIMages.Draw(Buffer.Canvas, ImX, ImY, FImageIndex, Enabled);
              OffsetRect(TR, FImages.Width + 8, 0);
            end;
          //
          Brush.Style := bsClear;
          if not Enabled
          then Font.Color := UnEnabledFontColor
          else Font.Color := FrameFontColor;

          if not FUseSkinFontColor then Font.Color := FDefaultFont.Color;

          if FWordWrap
          then
            DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR1,
               DT_EXPANDTABS or DT_WORDBREAK)
          else
            SPDrawText(Buffer.Canvas, Caption, TR);
          // drawfocus
          InflateRect(TR, 2, 1);
          Inc(TR.Right, 1 );
          Brush.Style := bsSolid;
          if IsFocused
          then
            if Caption <> ''
            then
              begin
                Brush.Color := FSD.SkinColors.cBtnFace;
                if FWordWrap
                then
                  begin
                    InflateRect(TR1, 2, 1);
                    DrawSkinFocusRect(Buffer.Canvas, TR1);
                  end
                else
                  DrawSkinFocusRect(Buffer.Canvas, TR)
              end
            else
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                begin
                  Brush.Color := FSD.SkinColors.cBtnFace;
                  DrawSkinFocusRect(Buffer.Canvas, Rect(ImX - 1, ImY - 1,
                    ImX + FImages.Width + 1, ImY + FImages.Height + 1));
                end;
        end;
      Self.Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end
  else
  if FIndex = -1
  then
    inherited
  else
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      if FAlphaBlend
      then
        begin
          ParentImage := TBitMap.Create;
          ParentImage.Width := Width;
          ParentImage.Height := Height;
          GetParentImage(Self, ParentImage.Canvas);
          PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
          kf := 1 - FAlphaBlendValue / 255;
        end;
      if EnableMorphing and (FMorphKf <> 1) and (FMorphKf <> 0)
      then
        begin
          ABuffer := TBitMap.Create;
          CreateImage(Buffer, SkinRect, False);
          CreateImage(ABuffer, ActiveSkinRect, True);
          PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
          APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
          case MorphKind of
            mkDefault: PBuffer.Morph(APBuffer, FMorphKf);
            mkGradient: PBuffer.MorphGrad(APBuffer, FMorphKf);
            mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, FMorphKf);
            mkRightGradient: PBuffer.MorphRightGrad(APBuffer, FMorphKf);
            mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, FMorphKf);
            mkRightSlide: PBuffer.MorphRightSlide(APBuffer, FMorphKf);
            mkPush: PBuffer.MorphPush(APBuffer, FMorphKf);
          end;
          if FAlphaBlend then PBuffer.Morph(PIBuffer, Kf);
          PBuffer.Draw(Canvas.Handle, 0, 0);
          PBuffer.Free;
          APBuffer.Free;
          ABuffer.Free;
        end
      else
        begin
          if FMouseIn or IsFocused
          then CreateImage(Buffer, ActiveSkinRect, FMouseIn or IsFocused)
          else CreateImage(Buffer, SkinRect, FMouseIn or IsFocused);
          if FAlphaBlend
          then
            begin
              PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
              PBuffer.Morph(PIBuffer, Kf);
              PBuffer.Draw(Canvas.Handle, 0, 0);
              PBuffer.Free;
             end
          else
            Canvas.Draw(0, 0, Buffer);
        end;
      if FAlphaBlend
      then
        begin
          PIBuffer.Free;
          ParentImage.Free;
        end;
      Buffer.Free;
    end;
end;

function TspSkinCheckRadioBox.IsFocused;
begin
  Result := Focused and FCanFocused;
end;

procedure TspSkinCheckRadioBox.SetCheckState;
begin
  if FRadio
  then
    begin
      if not Checked
      then
        Checked := True
    end
  else
    Checked := not FChecked;
end;

procedure TspSkinCheckRadioBox.CMDialogChar;
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus and FCanFocused
    then
      begin
        SetFocus;
        SetCheckState;
        Result := 1;
      end
    else
     inherited;
end;

procedure TspSkinCheckRadioBox.SetCanFocused;
begin
  FCanFocused := Value;
  if FCanFocused then TabStop := True else TabStop := False;
end;

procedure TspSkinCheckRadioBox.WMSETFOCUS;
begin
  inherited;
  if FCanFocused
  then
    begin
      ReDrawControl;
      //Invalidate;
    end;
end;

procedure TspSkinCheckRadioBox.WMKILLFOCUS;
begin
  inherited;
  if FCanFocused
  then
    begin
      ReDrawControl;
      //Invalidate;
    end;  
end;

procedure TspSkinCheckRadioBox.WndProc(var Message: TMessage);
begin
  if FCanFocused then
  case Message.Msg of
    WM_KEYUP:
      if IsFocused then
        with TWMKeyUp(Message) do
        begin
          if CharCode = VK_SPACE then SetCheckState;
        end;
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) and not Focused then
      begin
        FClicksDisabled := True;
        Windows.SetFocus(Handle);
        FClicksDisabled := False;
        if not Focused then Exit;
      end;
    CN_COMMAND:
      if FClicksDisabled then Exit;
  end;
  inherited WndProc(Message);
end;

procedure TspSkinCheckRadioBox.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Checked = False) then
        Self.Checked := Checked;
    end;
end;

procedure TspSkinCheckRadioBox.SetRadio;
begin
  FRadio := Value;
  if ((FIndex = -1) and FDrawDefault) or
     (csDesigning in ComponentState)
  then
    RePaint;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FRadio
      then
        begin
          FSkinDataName := 'radiobox';
          FGroupIndex := 1;
        end
      else
        begin
          FSkinDataName := 'checkbox';
          FGroupIndex := 0;
        end;
    end;
end;

procedure TspSkinCheckRadioBox.CalcSize;
var
  NewCIArea: TRect;
  Offset: Integer;
  CIW, CIH: Integer;
begin
  if FFlat then Exit;
  inherited;
  Offset := W - RectWidth(SkinRect);
  NewTextArea := TextArea;
  Inc(NewTextArea.Right, Offset);
  NewCIArea := CheckImageArea;
  if CheckImageArea.Right > TextArea.Right
  then
    OffsetRect(NewCIArea, Offset, 0);
  CIW := RectWidth(CheckImageRect);
  CIH := RectHeight(CheckImageRect);
  CIRect.Left := NewCIArea.Left + RectWidth(NewCIArea) div 2 - CIW div 2;
  CIRect.Top := NewCIArea.Top + RectHeight(NewCIArea) div 2 - CIH div 2;
  CIRect.Right := CIRect.Left + CIW;
  CIRect.Bottom := CIRect.Top + CIH;
end;

procedure TspSkinCheckRadioBox.SetChecked;
begin
  FChecked := Value;
  if FChecked then FState := cbChecked else
  if FState = cbChecked then  FState := cbUnChecked;
  RePaint;
  if FChecked and (GroupIndex <> 0) then UnCheckAll;
  if (FRadio and FChecked) or not FRadio
  then
    if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TspSkinCheckRadioBox.ReDrawControl;
begin
  if EnableMorphing and (FIndex <> -1)
  then StartMorph
  else Invalidate;
end;

procedure TspSkinCheckRadioBox.DoMorph;
begin
  if (FIndex = -1) or not EnableMorphing
  then
    begin
      if (FMouseIn or IsFocused) then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
    end
  else
  if (FMouseIn or IsFocused) and (FMorphKf < 1)
  then
    begin
      FMorphKf := FMorphKf + MorphInc;
      RePaint;
    end
  else
  if (not FMouseIn and not IsFocused) and (FMorphKf > 0)
  then
    begin
      FMorphKf := FMorphKf - MorphInc;
      RePaint;
    end
  else
    begin
      if (FMouseIn or IsFocused) then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
      RePaint;
    end;
end;

procedure TspSkinCheckRadioBox.UnCheckAll;
var
  PC: TWinControl;
  i: Integer;
begin
  if Parent = nil then Exit;
  PC := TWinControl(Parent);
  for i := 0 to PC.ControlCount - 1 do
   if (PC.Controls[i] is TspSkinCheckRadioBox) and
      (PC.Controls[i] <> Self)
   then
     with TspSkinCheckRadioBox(PC.Controls[i]) do
       if (GroupIndex = Self.GroupIndex) and
          (GroupIndex <> 0) and Checked
       then
         Checked := False;
end;

procedure TspSkinCheckRadioBox.ChangeSkinData;
begin
  if FFlat
  then
    begin
      GetSkinData;
      RePaint;
    end
  else
    begin
      StopMorph;
      inherited;
      if EnableMorphing and (FIndex <> -1) and (IsFocused or FMouseIn)
      then
        FMorphKf := 1;
    end;
end;

procedure TspSkinCheckRadioBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinCheckRadioControl
      then
        with TspDataSkinCheckRadioControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.FontName := FontName;
          Self.FontColor := FontColor;
          Self.ActiveFontColor := ActiveFontColor;
          Self.FrameFontColor := FrameFontColor;
          Self.UnEnabledFontColor := UnEnabledFontColor;
          Self.FontStyle := FontStyle;
          Self.FontHeight := FontHeight;
          Self.ActiveSkinRect := ActiveSkinRect;
          Self.Morphing := Morphing;
          Self.MorphKind := MorphKind;
          if IsNullRect(ActiveSkinRect) then Self.ActiveSkinRect := SkinRect;
          Self.CheckImageArea := CheckImageArea;
          Self.TextArea := TextArea;
          Self.CheckImageRect := CheckImageRect;
          Self.UnCheckImageRect := UnCheckImageRect;
          Self.ActiveCheckImageRect := ActiveCheckImageRect;
          Self.UnEnabledCheckImageRect := UnEnabledCheckImageRect;
          Self.UnEnabledUnCheckImageRect := UnEnabledUnCheckImageRect;
          if IsNullRect(UnEnabledCheckImageRect)
          then
            Self.UnEnabledCheckImageRect := CheckImageRect;
          if IsNullRect(UnEnabledUnCheckImageRect)
          then
            Self.UnEnabledUnCheckImageRect := UnCheckImageRect;
          if IsNullRect(ActiveCheckImageRect)
          then
            Self.ActiveCheckImageRect := CheckImageRect;
          Self.ActiveUnCheckImageRect := ActiveUnCheckImageRect;
          if IsNullRect(ActiveUnCheckImageRect)
          then
            Self.ActiveUnCheckImageRect := UnCheckImageRect;
          Self.Morphing := Morphing;
          Self.MorphKind := MorphKind;
          if FFlat
          then
            begin
              Self.Morphing := False;
              MaskPicture := nil;
            end;
          Self.GrayedCheckImageRect := GrayedCheckImageRect;
          Self.ActiveGrayedCheckImageRect := ActiveGrayedCheckImageRect;  
        end;
     end
   else
     begin
       Morphing := False;
       FMorphKf := 0;
     end;
end;

procedure TspSkinCheckRadioBox.CreateImage;
var
  IX, IY: Integer;
  TR: TRect;
begin
  CreateSkinControlImage(B, Picture, R);
  with B.Canvas do
  begin
    IX := CIRect.Left;
    IY := CIRect.Top + RectHeight(CIRect) div 2 - RectHeight(CheckImageRect) div 2;
    if not Enabled
    then
      begin
        if FState = cbGrayed
        then
          SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas,  UnEnabledCheckImageRect, B.Canvas)
        else
        if FChecked
        then
          SkinDrawCheckImage(IX, IY, Picture.Canvas, UnEnabledCheckImageRect, B.Canvas)
        else
          SkinDrawCheckImage(IX, IY, Picture.Canvas, UnEnabledUnCheckImageRect, B.Canvas);
      end
    else
    if FMouseIn
    then
      begin
        if FState = cbGrayed
        then
          SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas,  ActiveCheckImageRect, B.Canvas)
        else
        if FChecked
        then
          SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveCheckImageRect, B.Canvas)
        else
          SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveUnCheckImageRect, B.Canvas);
      end
    else
      begin
        if FState = cbGrayed
        then
          SkinDrawGrayedCheckImage(IX, IY, Picture.Canvas,  CheckImageRect, B.Canvas)
        else
        if FChecked
        then
          SkinDrawCheckImage(IX, IY, Picture.Canvas, CheckImageRect, B.Canvas)
        else
          SkinDrawCheckImage(IX, IY, Picture.Canvas, UnCheckImageRect, B.Canvas);
      end;

    if FUseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Height := FontHeight;
        Font.Style := FontStyle;
      end
    else
      Font.Assign(FDefaultFont);

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := FDefaultFont.Charset;

    if AMouseIn
    then Font.Color := ActiveFontColor
    else Font.Color := FontColor;
    if not Self.Enabled then Font.Color := UnEnabledFontColor;
    Brush.Style := bsClear;
  end;
  SPDrawText(B.Canvas, Caption, NewTextArea);
end;

procedure TspSkinCheckRadioBox.CreateControlDefaultImage(B: TBitMap);
var
  R, IR, TR: TRect;
  C: TColor;
begin
  inherited;
  if isFocused or FMouseIn
  then
    begin
      R := ClientRect;
      Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
    end;
  with B.Canvas do
  begin
    Font.Assign(DefaultFont);
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet;
    if not Enabled then Font.Color := clBtnShadow;
    Pen.Color := clBlack;
    Brush.Style := bsClear;
    IR := Rect(3, Height div 2 - 7, 17, Height div 2 + 7);
    TR := Rect(19, 0, Width, Height);
    SPDrawText(B.Canvas, Caption, TR);
    R := TR;
  end;
  if FMouseIn
  then
    Frame3D(B.Canvas, IR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1)
  else
    Frame3D(B.Canvas, IR, clbtnShadow, clbtnShadow, 1);

  if (FState = cbGrayed) and not FRadio
  then
    begin
      C := clGrayText;
      DrawCheckImage(B.Canvas, 7, Height div 2 - 4, C);
    end
  else
  if FChecked
  then
    begin
      if Enabled then C := clBlack else C := clBtnShadow;
      if FRadio
      then DrawRadioImage(B.Canvas, 7, Height div 2 - 3, C)
      else DrawCheckImage(B.Canvas, 7, Height div 2 - 4, C);
    end;
end;

procedure TspSkinCheckRadioBox.CMTextChanged;
begin
  if (FIndex <> -1) or
     (csDesigning in ComponentState) or DrawDefault
  then
    RePaint;
end;

procedure TspSkinCheckRadioBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  ReDrawControl;
end;

procedure TspSkinCheckRadioBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
  ReDrawControl;
end;

procedure TspSkinCheckRadioBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {$IFDEF VER200}
  if ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and (FMouseIn) and FDown
  then
    Perform(CM_MOUSELEAVE, 0, 0)
  else
  if not ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and not FMouseIn and FDown
  then
    Perform(CM_MOUSEENTER, 0, 0);
  {$ENDIF}
end;

procedure TspSkinCheckRadioBox.MouseDown;
begin
  if (Button = mbLeft) then FDown := True;
  if not FMouseIn
  then
    begin
      FMouseIn := True;
      RedrawControl;
    end;
  inherited;
end;

procedure TspSkinCheckRadioBox.MouseUp;
begin
  inherited;
  if (Button = mbLeft) and FMouseIn and FDown
  then
    begin
      FDown := False; 
      if (not FAllowGrayed) or FRadio
      then
        SetCheckState
      else
        begin
          if FState = cbUnchecked
          then
            begin
              FState := cbGrayed;
              RePaint;
              if Assigned(FOnClick) then FOnClick(Self);
            end
          else
            SetCheckState;
        end;
    end;
end;

constructor TspSkinGauge.Create;
begin
  inherited;
  FUseSkinSize := True;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
  FVertical := False;
  Width := 100;
  Height := 20;
  BeginOffset := 0;
  EndOffset := 0;
  FProgressText := '';
  FShowPercent := False;
  FShowProgressText := False;
  FTextAlphaBlend := False;
  FTextAlphaBlendValue := 200;
  FSkinDataName := 'gauge';
  FProgressAnimationPause := 1000;
  FAnimationPauseTimer := nil;
  FAnimationTimer := nil;
  FAnimationFrame := 0;
end;

destructor TspSkinGauge.Destroy;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Free;
  if FAnimationTimer <> nil then FAnimationTimer.Free;
  inherited;
end;

procedure TspSkinGauge.ChangeSkinData;
var
  FAnimation: Boolean;
begin
  FAnimation := FAnimationTimer <> nil;
  if FAnimation then StopProgressAnimation;
  inherited;
  if FAnimation then StartProgressAnimation;
end;

procedure TspSkinGauge.OnAnimationPauseTimer(Sender: TObject);
begin
  StartInternalAnimation;
end;

procedure TspSkinGauge.OnAnimationTimer(Sender: TObject);
begin
  Inc(FAnimationFrame);
  if FAnimationFrame > ProgressAnimationCountFrames
  then
    StopInternalAnimation;
  RePaint;
end;

procedure TspSkinGauge.SetProgressAnimationPause;
begin
  if Value >= 0
  then
    FProgressAnimationPause := Value;
end;

procedure TspSkinGauge.StartInternalAnimation;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Enabled := False;
  FAnimationFrame := 0;
  FAnimationTimer.Enabled := True;
  RePaint;
end;

procedure TspSkinGauge.StopInternalAnimation;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Enabled := True;
  FAnimationTimer.Enabled := False;
  FAnimationFrame := 0;
  RePaint;
end;

procedure TspSkinGauge.StartProgressAnimation;
begin
  if (FIndex = -1) or ((FIndex <> -1) and
     IsNullRect(Self.ProgressAnimationSkinRect))
  then
    Exit;

  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Free;
  if FAnimationTimer <> nil then FAnimationTimer.Free;

  FAnimationPauseTimer := TTimer.Create(Self);
  FAnimationPauseTimer.Enabled := False;
  FAnimationPauseTimer.OnTimer := OnAnimationPauseTimer;
  FAnimationPauseTimer.Interval := FProgressAnimationPause;
  FAnimationPauseTimer.Enabled := True;

  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.OnTimer := OnAnimationTimer;
  FAnimationTimer.Interval := Self.ProgressAnimationTimerInterval;

  StartInternalAnimation;
end;

procedure TspSkinGauge.StopProgressAnimation;
begin
  FAnimationFrame := 0;
  if FAnimationTimer = nil then  Exit;

  if FAnimationPauseTimer <> nil
  then
    begin
      FAnimationPauseTimer.Enabled := False;
      FAnimationPauseTimer.Free;
      FAnimationPauseTimer := nil;
    end;

  if FAnimationTimer <> nil
  then
    begin
      FAnimationTimer.Enabled := False;
      FAnimationTimer.Free;
      FAnimationTimer := nil;
    end;
end;

function TspSkinGauge.GetAnimationFrameRect;
var
  fs: Integer;
begin
  if RectWidth(ProgressAnimationSkinRect) > RectWidth(ProgressRect)
  then
    begin
      fs := RectWidth(ProgressAnimationSkinRect) div ProgressAnimationCountFrames;
      Result := Rect(ProgressAnimationSkinRect.Left + (FAnimationFrame - 1) * fs,
                 ProgressAnimationSkinRect.Top,
                 ProgressAnimationSkinRect.Left + FAnimationFrame * fs,
                 ProgressAnimationSkinRect.Bottom);
    end
  else
    begin
      fs := RectHeight(ProgressAnimationSkinRect) div ProgressAnimationCountFrames;
      Result := Rect(ProgressAnimationSkinRect.Left,
                     ProgressAnimationSkinRect.Top + (FAnimationFrame - 1) * fs,
                     ProgressAnimationSkinRect.Right,
                     ProgressAnimationSkinRect.Top + FAnimationFrame * fs);
    end;
end;

procedure TspSkinGauge.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinGauge.Paint;
var
  B1, B2: TBitMap;
  ParentImage: TBitMap;
  PBuffer, PIBuffer: TspEffectBmp;
  kf: Double;
begin
  if FUseSkinSize or (FIndex = -1)
  then
    inherited
  else
    begin
      B1 := TBitMap.Create;
      B1.Width := Width;
      B1.Height := Height;
      B2 := TBitMap.Create;
      GetSkinData;
      CreateControlSkinImage(B2);
      B1.Canvas.StretchDraw(Rect(0, 0, B1.Width, B1.Height), B2);
      B2.Free;
      DrawProgressText(B1.Canvas);
      if FAlphaBlend
      then
        begin
          ParentImage := TBitMap.Create;
          ParentImage.Width := Width;
          ParentImage.Height := Height;
          GetParentImage(Self, ParentImage.Canvas);
          PBuffer := TspEffectBmp.CreateFromhWnd(B1.Handle);
          PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
          kf := 1 - FAlphaBlendValue / 255;
          PBuffer.Morph(PIBuffer, Kf);
          PBuffer.Draw(Canvas.Handle, 0, 0);
          PBuffer.Free;
          PIBuffer.Free;
          ParentImage.Free;
        end
      else
        Canvas.Draw(0, 0, B1);
      B1.Free;
   end;
end;

procedure TspSkinGauge.SetTextAlphaBlendValue;
begin
  FTextAlphaBlendValue := Value;
  if (FIndex <> -1) and FTextAlphaBlend and
     (FShowProgressText or FShowPercent)
  then
    RePaint;
end;

procedure TspSkinGauge.SetTextAlphaBlend;
begin
  FTextAlphaBlend := Value;
  if (FIndex <> -1) and (FShowProgressText or FShowPercent)
  then
    RePaint;
end;

procedure TspSkinGauge.DrawProgressText;
var
  Percent: Integer;
  S: String;
  TX, TY: Integer;
  F: TLogFont;
begin
  if (FIndex = -1)
  then
    C.Font.Assign(FDefaultFont)
  else
  if (FIndex <> -1) and not FUseSkinFont
  then
    begin    
      C.Font.Assign(FDefaultFont);
      C.Font.Color := FontColor;
    end
  else
    with C do
    begin
      Font.Name := FontName;
      Font.Height := FontHeight;
      Font.Style := FontStyle;
      Font.Color := FontColor;
    end;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    C.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    C.Font.CharSet := FDefaultFont.Charset;

  if MaxValue = MinValue
  then
    Percent := 0
  else
    Percent := Trunc((FValue - FMinValue) / (FMaxValue - FMinValue) * 100);
  S := '';
  if FShowProgressText then S := S + FProgressText;
  if FShowPercent then S := S + IntToStr(Percent) + '%';
  if S = '' then Exit;
  with C do
  begin
    if FVertical
    then
      begin
        GetObject(Font.Handle, SizeOf(F), @F);
        F.lfEscapement := round(900);
        Font.Handle := CreateFontIndirect(F);
        TX := Width div 2 - TextHeight(S) div 2;
        TY := Height div 2 + TextWidth(S) div 2;
      end
    else
      begin
        TX := Width div 2 - TextWidth(S) div 2;
        TY := Height div 2 - TextHeight(S) div 2;
      end;
    Brush.Style := bsClear;
    //
    if (C.Font.Height div 2) <> (C.Font.Height / 2) then Dec(TY, 1);
    //
    TextOut(TX, TY, S);
  end;
end;

procedure TspSkinGauge.SetShowProgressText;
begin
  FShowProgressText := Value;
  RePaint;
end;

procedure TspSkinGauge.SetShowPercent;
begin
  FShowPercent := Value;
  RePaint;
end;

procedure TspSkinGauge.SetProgressText;
begin
  FProgressText := Value;
  RePaint;
end;

function TspSkinGauge.CalcProgressRect;
var
  kf: Double;
  Offset: Integer;
begin
  if FMinValue = FMaxValue
  then
    Kf := 0
  else
    kf := (FValue - FMinValue) / (FMaxValue - FMinValue);
  if FVertical
  then
    begin
      Offset := Trunc(RectHeight(R) * kf);
      R.Top := R.Bottom - Offset;
      Result := R;
    end
  else
    begin
      Offset := Trunc(RectWidth(R) * kf);
      R.Right := R.Left + Offset;
      Result := R;
    end;
end;

procedure TspSkinGauge.CalcSize;
var
  Offset: Integer;
  W1, H1: Integer;
begin
  if not FUseSkinSize
  then
    begin
      W1 := W;
      H1 := H;
    end;
  inherited;
  if ResizeMode > 0
  then
    begin
      if FVertical
      then
        begin
          Offset := H - RectHeight(SkinRect);
          NewProgressArea := ProgressArea;
          Inc(NewProgressArea.Bottom, Offset);
        end
      else
        begin
          Offset := W - RectWidth(SkinRect);
          NewProgressArea := ProgressArea;
          Inc(NewProgressArea.Right, Offset);
        end
    end
  else
    NewProgressArea := ProgressArea;
  if not FUseSkinSize
  then
    begin
      W := W1;
      H := H1;
    end;
end;


procedure TspSkinGauge.CreateControlSkinImage;
var
  PR, PR1, PR2: TRect;
  i, Cnt, Off: Integer;
  w1, w2: Integer;
  B1: TBitMap;
  EB1, EB2: TspEffectBmp;
  kf: Double;
  Buffer, Buffer2: TBitMap;
begin
  inherited;
  PR := CalcProgressRect(NewProgressArea, FVertical);
  //
  if Assigned(FOnGaugePaint)
  then
    begin
      FOnGaugePaint(B.Canvas, NewProgressArea, PR);
      Exit;
    end;

  //
  if (RectHeight(PR) = 0) or (RectWidth(PR) = 0)
  then
    begin
      if FUseSkinSize
      then
      if FTextAlphaBlend and (FShowProgressText or FShowPercent)
      then
        begin
          B1 := TBitMap.Create;
          B1.Width := B.Width;
          B1.Height := B.Height;
          B1.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), B.Canvas,
                             Rect(0, 0, B.Width, B.Height));
          DrawProgressText(B.Canvas);
          EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
          EB2 := TspEffectBmp.CreateFromhWnd(B1.Handle);
          kf := 1 - FTextAlphaBlendValue / 255;
          EB1.Morph(EB2, kf);
          EB1.Draw(B.Canvas.Handle, 0, 0);
          EB1.Free;
          EB2.Free;
          B1.Free;
        end
      else
        DrawProgressText(B.Canvas);
      Exit;
    end;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(PR);
  Buffer.Height := RectHeight(PR);
  with Buffer.Canvas do
  begin
    if FVertical
    then
      begin
        if RectHeight(PR) - BeginOffset - EndOffset > 0
        then
          begin
            PR1 := Rect(0, 0, Buffer.Width, Buffer.Height);
            Inc(PR1.Top, BeginOffset);
            Dec(PR1.Bottom, EndOffset);
            if (FAnimationTimer <> nil) and (FAnimationTimer.Enabled)
                and (FAnimationFrame <> 0) and (ProgressAnimationCountFrames <> 0)
            then
              PR2 := GetAnimationFrameRect
            else
              PR2 := ProgressRect;
            Inc(PR2.Top, BeginOffset);
            Dec(PR2.Bottom, EndOffset);
            w1 := RectHeight(PR1);
            w2 := RectHeight(PR2);
            if w2 = 0 then Exit;
            Cnt := w1 div w2;
            if (ProgressStretch) or ((FAnimationTimer <> nil) and (FAnimationTimer.Enabled)
                and (FAnimationFrame <> 0))
            then
              begin
                if (RectWidth(PR2) > 0) and (RectHeight(PR2) > 0)
                then
                  begin
                    Buffer2 := TBitMap.Create;
                    Buffer2.Width := RectWidth(PR2);
                    Buffer2.Height := RectHeight(PR2);
                    Buffer2.Canvas.CopyRect(Rect(0, 0, Buffer2.Width, Buffer2.Height),
                                            Picture.Canvas, PR2);
                    StretchDraw(PR1, Buffer2);
                    Buffer2.Free;
                  end;
              end
            else
            for i := 0 to Cnt do
            begin
              if i * w2 + w2 > w1 then Off := i * w2 + w2 - w1 else Off := 0;
                CopyRect(Rect(PR1.Left, PR1.Bottom - (i * w2 + w2 - Off),
                              PR1.Right, PR1.Bottom - i * w2),
                         Picture.Canvas,
                         Rect(PR2.Left, PR2.Top + Off,
                              PR2.Right, PR2.Bottom));
            end;
          end;

        PR1 := Rect(0, 0, Buffer.Width, Buffer.Height);

         CopyRect(Rect(PR1.Left, PR1.Top,
                  PR1.Right, PR1.Top + BeginOffset),
                  Picture.Canvas,
                  Rect(ProgressRect.Left, ProgressRect.Top,
                  ProgressRect.Right, ProgressRect.Top + BeginOffset));

         CopyRect(Rect(PR1.Left, PR1.Bottom - EndOffset,
                  PR1.Right, PR1.Bottom),
                  Picture.Canvas,
                  Rect(ProgressRect.Left, ProgressRect.Bottom - EndOffset,
                  ProgressRect.Right, ProgressRect.Bottom));
      end
    else
      begin
        if RectWidth(PR) - BeginOffset - EndOffset > 0
        then
          begin
            PR1 := Rect(0, 0, Buffer.Width, Buffer.Height);
            Inc(PR1.Left, BeginOffset);
            Dec(PR1.Right, EndOffset);
            if (FAnimationTimer <> nil) and (FAnimationTimer.Enabled) and
               (FAnimationFrame <> 0) and (ProgressAnimationCountFrames <> 0)
            then
              PR2 := GetAnimationFrameRect
            else
              PR2 := ProgressRect;
            Inc(PR2.Left, BeginOffset);
            Dec(PR2.Right, EndOffset);
            w1 := RectWidth(PR1);
            w2 := RectWidth(PR2);
            if w2 = 0 then Exit;
            Cnt := w1 div w2;
            if ProgressStretch or ((FAnimationTimer <> nil) and
               (FAnimationTimer.Enabled) and (FAnimationFrame <> 0))
            then
              begin
                if (RectWidth(PR2) > 0) and (RectHeight(PR2) > 0)
                then
                  begin
                    Buffer2 := TBitMap.Create;
                    Buffer2.Width := RectWidth(PR2);
                    Buffer2.Height := RectHeight(PR2);
                    Buffer2.Canvas.CopyRect(Rect(0, 0, Buffer2.Width, Buffer2.Height),
                                            Picture.Canvas, PR2);
                    StretchDraw(PR1, Buffer2);
                    Buffer2.Free;
                  end;
              end
            else
            for i := 0 to Cnt do
            begin
              if i * w2 + w2 > w1 then Off := i * w2 + w2 - w1 else Off := 0;
                CopyRect(Rect(PR1.Left + i * w2, PR1.Top,
                         PR1.Left + i * w2 + w2 - Off, PR1.Bottom),
                     Picture.Canvas,
                     Rect(PR2.Left, PR2.Top, PR2.Right - Off, PR2.Bottom));
            end;
          end;

        PR1 := Rect(0, 0, Buffer.Width, Buffer.Height);
        
        CopyRect(Rect(PR1.Left, PR1.Top,
                 PR1.Left + BeginOffset, PR1.Bottom),
                 Picture.Canvas,
                 Rect(ProgressRect.Left, ProgressRect.Top,
                 ProgressRect.Left + BeginOffset, ProgressRect.Bottom));
        CopyRect(Rect(PR1.Right - EndOffset, PR1.Top,
                 PR1.Right, PR1.Bottom),
                 Picture.Canvas,
                 Rect(ProgressRect.Right - EndOffset, ProgressRect.Top,
                 ProgressRect.Right, ProgressRect.Bottom));
      end;
  end;

  if ProgressTransparent
  then
    begin
      Buffer.Transparent := True;
      Buffer.TransparentMode := tmFixed;
      Buffer.TransparentColor := ProgressTransparentColor;
    end;

  B.Canvas.Draw(PR.Left, PR.Top, Buffer);

  Buffer.Free;

  if FUseSkinSize
  then
    if FTextAlphaBlend and (FShowProgressText or FShowPercent)
    then
      begin
        B1 := TBitMap.Create;
        B1.Width := B.Width;
        B1.Height := B.Height;
        B1.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), B.Canvas,
                           Rect(0, 0, B.Width, B.Height));
        DrawProgressText(B.Canvas);
        EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
        EB2 := TspEffectBmp.CreateFromhWnd(B1.Handle);
        kf := 1 - FTextAlphaBlendValue / 255;
        EB1.Morph(EB2, kf);
        EB1.Draw(B.Canvas.Handle, 0, 0);
        EB1.Free;
        EB2.Free;
        B1.Free;
      end
    else
      DrawProgressText(B.Canvas);
end;

procedure TspSkinGauge.CreateImage;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinGauge.CreateControlDefaultImage(B: TBitMap);
var
  R, PR: TRect;
begin
  R := ClientRect;
  B.Canvas.Brush.Color := clWindow;
  B.Canvas.FillRect(R);
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  R := Rect(1, 1, Width - 1, Height - 1);
  PR := CalcProgressRect(R, FVertical);

  if Assigned(FOnGaugePaint)
  then
    begin
      FOnGaugePaint(B.Canvas, R, PR);
      Exit;
    end;

  if not IsNullRect(PR)
  then
    begin
      B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
      B.Canvas.FillRect(PR);
    end;
  DrawProgressText(B.Canvas);
end;

procedure TspSkinGauge.SetVertical;
begin
  FVertical:= AValue;
  RePaint;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FVertical
      then FSkinDataName := 'vgauge'
      else FSkinDataName := 'gauge';
    end;
end;

procedure TspSkinGauge.SetMinValue;
begin
  FMinValue := AValue;
  if FValue < FMinValue then FValue := FMinValue;
  RePaint;
end;

procedure TspSkinGauge.SetMaxValue;
begin
  FMaxValue := AValue;
  if FValue > FMaxValue then FValue := FMaxValue;
  RePaint;
end;

procedure TspSkinGauge.SetValue;
begin
  if AValue > FMaxValue
  then AValue := FMaxValue else
  if AValue < FMinValue
  then AValue := FMinValue;
  if AValue <> FValue
  then
    begin
      FValue := AValue;
      // RePaint;
      Invalidate;
    end;
end;

procedure TspSkinGauge.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinGaugeControl
    then
      with TspDataSkinGaugeControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if not FUseSkinSize and (MaskPictureIndex <> -1)
        then
          MaskPicture := nil;
        Self.FVertical := Vertical;
        Self.ProgressRect := ProgressRect;
        Self.ProgressArea := ProgressArea;
        Self.BeginOffset := BeginOffset;
        Self.EndOffset := EndOffset;
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.ProgressTransparent := ProgressTransparent;
        Self.ProgressTransparentColor := ProgressTransparentColor;
        Self.ProgressStretch := ProgressStretch;
        Self.ProgressAnimationSkinRect := ProgressAnimationSkinRect;
        Self.ProgressAnimationCountFrames := ProgressAnimationCountFrames;
        Self.ProgressAnimationTimerInterval := ProgressAnimationTimerInterval;
      end;
end;

constructor TspSkinTrackBar.Create;
begin
  inherited;
  FJumpWhenClick := False;
  FCanFocused := False;
  TabStop := False;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
  FVertical := False;
  Width := 100;
  Height := 20;
  FMouseSupport := True;
  FDown := False;
  FSkinDataName := 'htrackbar';
end;

procedure TspSkinTrackBar.KeyDown;
begin
  inherited KeyDown(Key, Shift);
  if FCanFocused then
  case Key of
    VK_UP, VK_RIGHT:
      begin
        Value := Value + 1;
        if Assigned(FOnLastChange) then FOnLastChange(Self);
      end;
    VK_DOWN, VK_LEFT:
     begin
       Value := Value - 1;
       if Assigned(FOnLastChange) then FOnLastChange(Self);
     end;
  end;
end;

procedure TspSkinTrackBar.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinTrackBar.WMMOUSEWHEEL;
begin
  if IsFocused
  then
    if Vertical
    then
      begin
        if Message.WParam > 0
        then
          Value := Value + 1
        else
          Value := Value - 1;
        if Assigned(FOnLastChange) then FOnLastChange(Self);
      end
    else
      begin
        if Message.WParam > 0
        then
          Value := Value - 1
        else
          Value := Value + 1;
        if Assigned(FOnLastChange) then FOnLastChange(Self);  
      end;
end;

procedure TspSkinTrackBar.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if FCanFocused then 
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT: Msg.Result := 1;
  end;
end;

function TspSkinTrackBar.IsFocused;
begin
  Result := Focused and FCanFocused;
end;

procedure TspSkinTrackBar.SetCanFocused;
begin
  FCanFocused := Value;
  if FCanFocused then TabStop := True else TabStop := False;
end;

procedure TspSkinTrackBar.WMSETFOCUS;
begin
  inherited;
  if FCanFocused then RePaint;
end;

procedure TspSkinTrackBar.WMKILLFOCUS;
begin
  inherited;
  if FCanFocused then RePaint;
end;

procedure TspSkinTrackBar.WndProc(var Message: TMessage);
begin
  if FCanFocused then
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) and not Focused then
      begin
        FClicksDisabled := True;
        Windows.SetFocus(Handle);
        FClicksDisabled := False;
        if not Focused then Exit;
      end;
    CN_COMMAND:
      if FClicksDisabled then Exit;
  end;
  inherited WndProc(Message);
end;

function TspSkinTrackBar.CalcValue;
var
  kf: Double;
begin
  if (Offset2 - Offset1) <= 0
  then kf := 0
  else kf := AOffset / (Offset2 - Offset1);
  if kf > 1 then kf := 1 else
  if kf < 0 then kf := 0;
  Result := FMinValue + Round((FMaxValue - FMinValue) * kf);
end;

function TspSkinTrackBar.CalcButtonRect;
var
  kf: Double;
  BW, BH: Integer;
begin
  if FMinValue = FMaxValue
  then
    Kf := 0
  else
    kf := (FValue - FMinValue) / (FMaxValue - FMinValue);
  if FIndex = -1
  then
    begin
      if FVertical
      then
        begin
          BW := Width - 4;
          BH := BW div 2;
        end
      else
        begin
          BH := Height - 4;
          BW := BH div 2;
         end;
    end
  else
    begin
      BW := RectWidth(ButtonRect);
      BH := RectHeight(ButtonRect);
    end;
  if FVertical
  then
    begin
      Offset1 := R.Top + BH div 2;
      Offset2 := R.Bottom - BH div 2;
      BOffset := Round((Offset2 - Offset1) * Kf);
      Result := Rect(R.Left + RectWidth(R) div 2 - BW div 2,
       Offset2 - BOffset - BH div 2,
       R.Left + RectWidth(R) div 2 - BW div 2 + BW,
       Offset2 - BOffset - BH div 2 + BH);
    end
  else
    begin
      Offset1 := R.Left + BW div 2;
      Offset2 := R.Right - BW div 2;
      BOffset := Round((Offset2 - Offset1) * kf);
      Result := Rect(Offset1 + BOffset - BW div 2,
        R.Top + RectHeight(R) div 2 - BH div 2,
        Offset1 + BOffset - BW div 2 + BW,
        R.Top + RectHeight(R) div 2 - BH div 2 + BH);
    end;
end;

procedure TspSkinTrackBar.CalcSize;
var
  Offset: Integer;
begin
  inherited;
  if ResizeMode > 0
  then
    begin
      if FVertical
      then
        begin
          Offset := H - RectHeight(SkinRect);
          NewTrackArea := TrackArea;
          Inc(NewTrackArea.Bottom, Offset);
        end
      else
        begin
          Offset := W - RectWidth(SkinRect);
          NewTrackArea := TrackArea;
          Inc(NewTrackArea.Right, Offset);
        end
    end
  else
    NewTrackArea := TrackArea;
end;

procedure TspSkinTrackBar.CreateControlSkinImage;
var
  B1, B2: TBitMap;
  EB1, EB2: TspEffectBmp;
  kf: Double;
  Buffer: TBitMap;
  R: TRect;
begin
  inherited;
  BR := CalcButtonRect(NewTrackArea, FVertical);

  if not isNullRect(ActiveSkinRect)
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := B.Width;
      Buffer.Width := B.Height;
      CreateSkinControlImage(Buffer, Picture, ActiveSkinRect);
      if Self.Vertical
      then
        begin
          R := Rect(0, BR.Top + RectHeight(BR) div 2, B.Width, B.Height);
          B.Canvas.CopyRect(R, Buffer.Canvas, R);
        end
      else
        begin
          if BR.Left + RectWidth(BR) div 2 > 0
          then
            begin
              Buffer.Width := BR.Left + RectWidth(BR) div 2;
              B.Canvas.Draw(0, 0, Buffer);
            end;
        end;
      Buffer.Free;
    end;

  B1 := TBitMap.Create;
  B1.Width := RectWidth(BR);
  B1.Height := RectHeight(BR);
  with B1.Canvas do
  if FDown or IsFocused
  then
    CopyRect(Rect(0, 0, B1.Width, B1.Height),
             Picture.Canvas, ActiveButtonRect)
  else
    CopyRect(Rect(0, 0, B1.Width, B1.Height),
             Picture.Canvas, ButtonRect);
  if FAlphaBlend and not ButtonTransparent
  then
    begin
      B2 := TBitMap.Create;
      B2.Width := RectWidth(BR);
      B2.Height := RectHeight(BR);
      B2.Canvas.CopyRect(Rect(0, 0, B2.Width, B2.Height), B.Canvas, BR);
      //
      EB1 := TspEffectBmp.CreateFromhWnd(B1.Handle);
      EB2 := TspEffectBmp.CreateFromhWnd(B2.Handle);
      kf := 1 - FAlphaBlendValue / 255;
      EB1.Morph(EB2, Kf);
      EB1.Draw(B1.Canvas.Handle, 0, 0);
      B.Canvas.Draw(BR.Left, BR.Top, B1);
      //
      EB1.Free;
      EB2.Free;
      B2.Free;
    end
  else
    begin
      if ButtonTransparent
      then
        begin
          B1.Transparent := True;
          B1.TransparentMode := tmFixed;
          B1.TransparentColor := ButtonTransparentColor;
        end;
      B.Canvas.Draw(BR.Left, BR.Top, B1);
    end;
  B1.Free;
end;

procedure TspSkinTrackBar.CreateImage;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinTrackBar.MouseDown;
begin
  inherited;
  if FMouseSupport and
     PtInRect(Rect(BR.Left, BR.Top, BR.Right + 1, BR.Bottom + 1), Point(X, Y))
  then
    begin
      if FVertical then OMPos := Y else OMPos := X;
      OldBOffset := BOffset;
      FDown := True;
      RePaint;
      if Assigned(FOnStartDragButton) then FOnStartDragButton(Self);
    end;
end;

procedure TspSkinTrackBar.MouseUp;
var
  Off: Integer;
  Off2: Integer;
begin
  inherited;
  if FMouseSupport and FDown
  then
    begin
      FDown := False;
      RePaint;
      if Assigned(FOnLastChange) then FOnLastChange(Self);
    end
  else
  if FMouseSupport and not FDown and FJumpWhenClick
  then
    begin
      if FIndex <> -1
      then
        begin
          if FVertical
          then
            Off2 := NewTrackArea.Top
          else
            Off2 := NewTrackArea.Left;
        end
      else
        Off2 := 2;
      if FVertical
      then
        Off := Height - Y - RectHeight(BR) div 2 - Off2
      else
        Off := X - RectWidth(BR) div 2 - Off2;
      Value := CalcValue(Off);
    end;
end;

procedure TspSkinTrackBar.MouseMove;
var
  Off: Integer;
begin
  if FMouseSupport and FDown
  then
    begin
      if Vertical
      then
        begin
          Off := OMPos - Y;
          Off := OldBOffset + Off;
        end
      else
        begin
          Off := X - OMPos;
          Off := OldBOffset + Off;
        end;
      Value := CalcValue(Off);
    end;
  inherited;  
end;

procedure TspSkinTrackBar.CreateControlDefaultImage;
var
  R, LR, BR1: TRect;
begin
  inherited;
  R := ClientRect;
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  R := Rect(2, 2, Width - 2, Height - 2);
  if FVertical
  then
    LR := Rect(Width div 2 - 1, 4, Width div 2 + 1, Height - 4)
  else
    LR := Rect(4, Height div 2 - 1, Width - 4, Height div 2 + 1);
  BR := CalcButtonRect(R, FVertical);
  Frame3D(B.Canvas, LR, clbtnShadow, clBtnHighLight, 1);
  with B.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    FillRect(BR);
  end;
  BR1 := BR;
  with B.Canvas do
  begin
    Brush.Style := bsSolid;
    if FDown
    then
      begin
        Frame3D(B.Canvas, BR1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNDOWNCOLOR;
        FillRect(BR1);
      end
    else
    if IsFocused
    then
      begin
        Frame3D(B.Canvas, BR1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNACTIVECOLOR;
        FillRect(BR1);
      end
    else
      begin
        Frame3D(B.Canvas, BR1, clBtnShadow, clBtnShadow, 1);
        Brush.Color := clBtnFace;
        FillRect(BR1);
      end;
  end;
end;

procedure TspSkinTrackBar.SetVertical;
begin
  FVertical:= AValue;
  RePaint;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FVertical
      then FSkinDataName := 'trackbar'
      else FSkinDataName := 'htrackbar';
    end;
end;

procedure TspSkinTrackBar.SetMinValue;
begin
  FMinValue := AValue;
  if FValue < FMinValue then FValue := FMinValue;
  RePaint;
end;

procedure TspSkinTrackBar.SetMaxValue;
begin
  FMaxValue := AValue;
  if FValue > FMaxValue then FValue := FMaxValue;
  RePaint;
end;

procedure TspSkinTrackBar.SetValue;
begin
  if AValue > MaxValue then AValue := MaxValue else
    if AValue < MinValue then AValue := MinValue;
  if AValue <> FValue
  then
    begin
      FValue := AValue;
      RePaint;
      if Assigned(FOnChange) then FOnChange(Self);
    end;
end;

procedure TspSkinTrackBar.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinTrackBarControl
    then
      with TspDataSkinTrackBarControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.FVertical := Vertical;
        Self.ButtonRect := ButtonRect;
        if IsNullRect(ActiveButtonRect)
        then
          Self.ActiveButtonRect := ButtonRect
        else
          Self.ActiveButtonRect := ActiveButtonRect;
        Self.TrackArea := TrackArea;
        Self.ButtonTransparent := ButtonTransparent;
        Self.ButtonTransparentColor := ButtonTransparentColor;
      end;
end;


const
  ELLIPSSTYLE : array[TspEllipsType] of DWORD = (0, DT_END_ELLIPSIS, DT_PATH_ELLIPSIS);
  
constructor TspSkinStdLabel.Create;
begin
  inherited;
  FEllipsType := spetNone;
  Transparent := True;
  FSD := nil;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  FUseSkinFont := True;
  FUseSkinColor := True;
end;

destructor TspSkinStdLabel.Destroy;
begin
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinStdLabel.SetEllipsType(const Value: TspEllipsType);
begin
  if FEllipsType <> Value
  then
    begin
      FEllipsType := Value;
      Invalidate;
    end;
end;

procedure TspSkinStdLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  LText: string;
begin
  GetSkinData;

  LText := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((LText = '') or ShowAccelChar and
    (LText[1] = '&') and (LText[2] = #0)) then LText := LText + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;

  Flags := Flags or ELLIPSSTYLE[FEllipsType];

  Flags := DrawTextBiDiModeFlags(Flags);

  if FIndex <> -1
  then
    with Canvas.Font do
    begin
      if FUseSkinFont
      then
        begin
          Name := FontName;
          Style := FontStyle;
          Height := FontHeight;
        end
      else
        Canvas.Font := Self.Font;
      if FUseSkinColor then Color := FontColor else Color := Self.Font.Color;
    end
  else
    if FUseSkinFont
    then
      Canvas.Font := DefaultFont
    else
      Canvas.Font := Self.Font;

   if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Canvas.Font.CharSet := FDefaultFont.Charset;

  if not Enabled
  then
    begin
      OffsetRect(Rect, 1, 1);
      if FIndex <> -1
      then
        Canvas.Font.Color := FSD.SkinColors.cBtnHighLight
      else
        Canvas.Font.Color := clBtnHighlight;
      if Self.EllipsType <> spetNone
      then
        DrawTextEx(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags, nil)
      else
        DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
      OffsetRect(Rect, -1, -1);
      if FIndex <> -1
      then
        Canvas.Font.Color := FSD.SkinColors.cBtnShadow
      else
        Canvas.Font.Color := clBtnShadow;
      if Self.EllipsType <> spetNone
      then
        DrawTextEx(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags, nil)
      else
        DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
   end
 else
  if Self.EllipsType <> spetNone
  then
    DrawTextEx(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags, nil)
  else
    DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
end;

procedure TspSkinStdLabel.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinStdLabel.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinStdLabel.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if (FIndex <> -1)
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinStdLabelControl
    then
      with TspDataSkinStdLabelControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
      end
end;

procedure TspSkinStdLabel.ChangeSkinData;
begin
  GetSkinData;
  if AutoSize then AdjustBounds;
  RePaint;
end;

procedure TspSkinStdLabel.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then ChangeSkinData;
end;

constructor TspSkinLabel.Create;
begin
  inherited;
  FTransparent := False;
  FEllipsType := spetNoneEllips;
  FReflectionEffect := False;
  FReflectionOffset := -5;
  FShadowEffect := False;
  FShadowSize := 3;
  FShadowOffset := 0;
  FShadowColor := clBlack;
  FUseSkinFontColor := True;
  FUseSkinSize := True;
  Width := 75;
  Height := 21;
  FAutoSize := False;
  FSkinDataName := 'label';
end;

procedure TspSkinLabel.WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); 
begin
  if FTransparent then RePaint;
end;

procedure TspSkinLabel.SetTransparent;
begin
  if Value <> FTransparent
  then
    begin
      FTransparent := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetShadowEffect(Value: Boolean);
begin
  if FShadowEffect <> Value
  then
    begin
      FShadowEffect := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetShadowOffset(Value: Integer);
begin
  if FShadowOffset <> Value
  then
    begin
      FShadowOffset := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetShadowSize(Value: Integer);
begin
  if FShadowSize <> Value
  then
    begin
      FShadowSize := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetShadowColor(Value: TColor);
begin
 if FShadowColor <> Value
  then
    begin
      FShadowColor := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetReflectionOffset(Value: Integer);
begin
  if FReflectionOffset <> Value
  then
    begin
      FReflectionOffset := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetReflectionEffect(Value: Boolean);
begin
  if FReflectionEffect <> Value
  then
    begin
      FReflectionEffect := Value;
      RePaint;
    end;
end;


procedure TspSkinLabel.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinLabel.SetEllipsType(Value: TspEllipsType2);
begin
  if FEllipsType <> Value
  then
    begin
      FEllipsType := Value;
      Invalidate;
    end;
end;

procedure TspSkinLabel.SetControlRegion; 
begin
  if UseSkinSize then inherited;
end;

procedure TspSkinLabel.SetBorderStyle;
begin
  FBorderStyle := Value;
  if FIndex = -1
  then
    begin
      RePaint;
      ReAlign;
    end;
end;

procedure TspSkinLabel.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinLabelControl
    then
      with TspDataSkinLabelControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        if ResizeMode = 0 then FAutoSize := False;
      end;
end;

procedure TspSkinLabel.DrawLabelText;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  TX, TY: Integer;
  S: String;
  C: TColor;
begin
  with Cnvs do
  begin
    if (FIndex <> -1) and UseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
        Font.Color := FontColor;
      end
    else
    if (FIndex <> -1) and not UseSkinFont
    then
      begin
        Font.Assign(DefaultFont);
        Font.Color := FontColor;
      end
    else
      Font.Assign(DefaultFont);

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := FDefaultFont.Charset;
      
    S := Caption;

    if FEllipsType <> spetNoneEllips
    then
      CorrectTextbyWidth(Cnvs, S, RectWidth(R));

    TY := R.Top + RectHeight(R) div 2 - TextHeight(S) div 2;
    //
    if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TY, 1);
    //
    TX := R.Left;
    case FAlignment of
      taRightJustify: TX := R.Right - TextWidth(S);
      taCenter: TX := R.Left + RectWidth(R) div 2 - TextWidth(S) div 2;
    end;
    Brush.Style := bsClear;
    if not FUseSkinFontColor then Font.Color := FDefaultFont.Color;
    if FShadowEffect
    then
      begin
        if (FIndex <> -1) and FUseSkinFontColor
        then
          C := Darker(SkinData.SkinColors.cBtnFace, 70)
        else
          C := FShadowColor;
        R.Top := TY;
        DrawEffectText(Cnvs, R, S, Alignments[FAlignment],
          FShadowOffset, C, FShadowSize);
      end
    else
    if FReflectionEffect
    then
      begin
        DrawReflectionText(Cnvs, R, S, Alignments[FAlignment],
         FReflectionOffset, Cnvs.Font.Color);
      end
    else
      TextRect(R, TX, TY, S);
  end;
end;

procedure TspSkinLabel.CreateControlDefaultImage;
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  if FTransparent
  then
    begin
      GetParentImage(Self, B.Canvas);
      R := Rect(0, 0, B.Width, B.Height);
    end
  else
  case FBorderStyle of
    bvLowered:
      Frm3D(B.Canvas, R, clBtnShadow, clBtnHighLight);
    bvRaised:
      Frm3D(B.Canvas, R, clBtnHighLight, clBtnShadow);
    bvFrame:
      Frm3D(B.Canvas, R, clBtnShadow, clBtnShadow);
  end;
  if FTransparent
  then
    DrawLabelText(B.Canvas, R)
  else
    DrawLabelText(B.Canvas, Rect(3, 3, Width - 3, Height - 3));
end;

procedure TspSkinLabel.CreateControlSkinImage;
var
  R: TRect;
begin
  if FTransparent
  then
    begin
      GetParentImage(Self, B.Canvas);
      R := Rect(0, 0, B.Width, B.Height);
      DrawLabelText(B.Canvas, R);
    end
  else
  if FUseSkinSize or (ResizeMode = 1)
  then
    begin
      inherited;
      DrawLabelText(B.Canvas, NewClRect);
    end
  else
    begin
      R := NewClRect;
      Inc(R.Bottom, Height - RectHeight(SkinRect));
      CreateStretchImage(B, Picture, SkinRect, ClRect, True);
      DrawLabelText(B.Canvas, R);
    end;
end;

procedure TspSkinLabel.PaintLabel;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinLabel.CalcSize;
var
  Offset: Integer;
  XO: Integer;
begin
  if UseSkinSize or (ResizeMode = 1)
  then
    inherited
  else
    begin
      XO := W - RectWidth(SkinRect);
      NewLTPoint := LTPt;
      NewRTPoint := Point(RTPt.X + XO, RTPt.Y );
      NewClRect := ClRect;
      Inc(NewClRect.Right, XO);
    end;
  Offset := CalcWidthOffset;
  if (Offset > 0) and FAutoSize then W := W + Offset;
end;

function TspSkinLabel.CalcWidthOffset;
begin
  if (FIndex <> -1)
  then
    begin
      with Canvas do
      begin
        if FUseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Height := FontHeight;
            Font.Style := FontStyle;
          end
        else
           Font.Assign(DefaultFont);
        if ResizeMode = 0
        then
          Result := 0
        else
          Result := TextWidth(Caption) - RectWidth(NewClRect);
      end;
    end
  else
    begin
      Canvas.Font.Assign(DefaultFont);
      Result := Canvas.TextWidth(Caption) - (Width - 4);
    end;
end;

procedure TspSkinLabel.AdjustBounds;
var
  Offset: Integer;
begin
  if (Align = alTop) or (Align = alBottom)  or (Align = alClient) then Exit;
  Offset := CalcWidthOffset;
  if Offset <> 0 then Width := Width + Offset;
end;

procedure TspSkinLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value
  then
    begin
      FAlignment := Value;
      RePaint;
    end;
end;

procedure TspSkinLabel.SetAutoSizeX(Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then AdjustBounds;
end;

procedure TspSkinLabel.CMTextChanged(var Message: TMessage);
begin
  if FAutoSize then AdjustBounds;
  RePaint;
end;



//============ TspSkinScrollBar ===============
const
  SBUTTONW = 16;
  BUTCOUNT = 3;
  THUMB = 0;
  UPBUTTON = 1;
  DOWNBUTTON = 2;


constructor TspSkinScrollBar.Create;
begin
  inherited;
  FCanFocused := False;
  TabStop := False;
  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FSmallChange := 1;
  FLargeChange := 1;
  FPageSize := 0;
  WaitMode := False;
  TimerMode := 0;
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  FOnChange := nil;
  Width := 200;
  Height := 19;
  FBothMarkerWidth := 19;
  FDefaultHeight := 19;
  FBothMarkerWidth := 0;
  FBothMarkerWidth := 0;
  FNormalSkinDataName := '';
  FBothSkinDataName := 'bothhscrollbar';
  FSkinDataName := 'hscrollbar';
end;


procedure TspSkinScrollBar.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinScrollBar.SetBoth(Value: Boolean);
begin
  if FBoth <> Value
  then
    begin
      FBoth := Value;
      if not (csDesigning in ComponentState)
      then
        if FBoth
        then
          begin
            FNormalSkinDataName := SkinDataName;
            SkinDataName := FBothSkinDataName;
          end
        else
          if FNormalSkinDataName <> ''
          then
            SkinDataName := FNormalSkinDataName;
        if FIndex = -1
        then
          RePaint
        else
         ChangeSkinData;
    end;
end;

procedure TspSkinScrollBar.CMEnabledChanged;
begin
  inherited;
  RePaint;
end;

procedure TspSkinScrollBar.SetBothMarkerWidth;
begin
  if Value >= 0
  then
    begin
      FBothMarkerWidth := Value;
      if FIndex = -1 then RePaint;
    end;
end;

procedure TspSkinScrollBar.KeyDown;
begin
  inherited KeyDown(Key, Shift);
  if FCanFocused then 
  case Key of
    VK_DOWN, VK_RIGHT: Position := Position + FSmallChange;
    VK_UP, VK_LEFT: Position := Position - FSmallChange;
  end;
end;

procedure TspSkinScrollBar.WMMOUSEWHEEL;
begin
  if IsFocused
  then
    if Message.WParam > 0
    then
      Position := FPosition - FSmallChange
    else
      Position := FPosition + FSmallChange;
end;

procedure TspSkinScrollBar.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if FCanFocused then 
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT: Msg.Result := 1;
  end;
end;

function TspSkinScrollBar.IsFocused;
begin
  Result := Focused and FCanFocused;
end;

procedure TspSkinScrollBar.SetCanFocused;
begin
  FCanFocused := Value;
  if FCanFocused then TabStop := True else TabStop := False;
end;

procedure TspSkinScrollBar.WMSETFOCUS;
begin
  inherited;
  if FCanFocused then RePaint;
end;

procedure TspSkinScrollBar.WMKILLFOCUS;
begin
  inherited;
  if FCanFocused then RePaint;
end;

procedure TspSkinScrollBar.WndProc(var Message: TMessage);
begin
  if FCanFocused then
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) and not Focused then
      begin
        FClicksDisabled := True;
        Windows.SetFocus(Handle);
        FClicksDisabled := False;
        if not Focused then Exit;
      end;
    CN_COMMAND:
      if FClicksDisabled then Exit;
  end;
  inherited WndProc(Message);
end;

procedure TspSkinScrollBar.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinScrollBarControl
    then
      with TspDataSkinScrollBarControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.TrackArea := TrackArea;
        Self.UpButtonRect := UpButtonRect;

        Self.ActiveUpButtonRect := ActiveUpButtonRect;
        Self.DownUpButtonRect := DownUpButtonRect;

        if IsNullRect(Self.DownUpButtonRect)
        then
          Self.DownUpButtonRect := Self.ActiveUpButtonRect;

        Self.DownButtonRect := DownButtonRect;
        Self.ActiveDownButtonRect := ActiveDownButtonRect;
        Self.DownDownButtonRect := DownDownButtonRect;

        if IsNullRect(Self.DownDownButtonRect)
        then
          Self.DownDownButtonRect := Self.ActiveDownButtonRect;

        Self.ThumbRect := ThumbRect;
        Self.ActiveThumbRect := ActiveThumbRect;
        if IsNullRect(Self.ActiveThumbRect)
        then
          Self.ActiveThumbRect := Self.ThumbRect;

        Self.DownThumbRect := DownThumbRect;
        if IsNullRect(Self.DownThumbRect)
        then
          Self.DownThumbRect := Self.ActiveThumbRect;
        Self.ThumbOffset1 := ThumbOffset1;
        Self.ThumbOffset2 := ThumbOffset2;
        Self.ThumbTransparent := ThumbTransparent;
        Self.ThumbTransparentColor := ThumbTransparentColor;
        Self.GlyphRect := GlyphRect;
        Self.ActiveGlyphRect := ActiveGlyphRect;
        if isNullRect(ActiveGlyphRect)
        then Self.ActiveGlyphRect := GlyphRect;
        Self.DownGlyphRect := DownGlyphRect;
        if isNullRect(DownGlyphRect)
        then Self.DownGlyphRect := Self.ActiveGlyphRect;

        Self.GlyphTransparent := GlyphTransparent;
        Self.GlyphTransparentColor := GlyphTransparentColor;

        Self.ThumbStretchEffect := ThumbStretchEffect;
        Self.ThumbMinSize := ThumbMinSize;
        Self.ThumbMinPageSize := ThumbMinPageSize;
      end;
end;


procedure TspSkinScrollBar.CalcSize;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinScrollBar.SetPageSize;
begin
  if AValue + FPosition <= FMax - FMin + 1
  then
    FPageSize := AValue;
  RePaint;
end;

procedure TspSkinScrollBar.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinScrollBar.TestActive(X, Y: Integer);
var
  i, j: Integer;
begin
  j := -1;
  OldActiveButton := ActiveButton;
  for i := 0 to BUTCOUNT - 1 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinScrollBar.CreateControlSkinImage;
var
  i: Integer;
begin
  inherited;
  CalcRects;
  for i := 1 to BUTCOUNT - 1 do DrawButton(B.Canvas, i);
  if Enabled then 
  DrawButton(B.Canvas, THUMB);
end;

procedure TspSkinScrollBar.DrawButton;
var
  R1, R2: TRect;
  C: TColor;
  GlyphB, ThumbB: TBitMap;
  B1: TBitMap;
  EB1, EB2: TspEffectBmp;
  kf: Double;
begin
  if FIndex = -1
  then
  with Buttons[i] do
  begin
    if FIndex = -1
    then
      with Buttons[i] do
      begin
        R1 := R;
        with Cnvs do
        begin
          if (Down and MouseIn) or ((i = THUMB) and (Down or IsFocused))
          then
            begin
              Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              Brush.Color := SP_XP_BTNDOWNCOLOR;
              FillRect(R1);
            end
          else
            if MouseIn
            then
              begin
                Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
                Brush.Color := SP_XP_BTNACTIVECOLOR;
                FillRect(R1);
              end
             else
               begin
                 Frame3D(Cnvs, R1, clBtnShadow, clBtnShadow, 1);
                 Brush.Color := clBtnFace;
                 FillRect(R1);
               end;
        end;

     C := clBlack;

     case i of
       DOWNBUTTON:
         case Kind of
           sbHorizontal:
             DrawArrowImage(Cnvs, R1, C, 1);
           sbVertical:
             DrawArrowImage(Cnvs, R1, C, 3);
          end;
        UPBUTTON:
          case Kind of
            sbHorizontal:
              DrawArrowImage(Cnvs, R1, C, 2);
            sbVertical:
              DrawArrowImage(Cnvs, R1, C, 4);
          end;
        end;
      end
    end
  else
    begin
      if I = THUMB
      then
        with Buttons[THUMB] do
        begin
          if Down or IsFocused
          then R1 := DownThumbRect
          else if MouseIn then R1 := ActiveThumbRect
          else R1 := ThumbRect;
          ThumbB := TBitMap.Create;
          ThumbB.Width := RectWidth(R);
          ThumbB.Height := RectHeight(R);
          if FPageSize = 0
          then
            begin
              if ThumbMinPageSize <> 0
              then
                begin
                  case Kind of
                    sbHorizontal:
                    CreateHSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                      ThumbB.Width, ThumbB.Height, ThumbStretchEffect);
                    sbVertical:
                    CreateVSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                     ThumbB.Width, ThumbB.Height, ThumbStretchEffect);
                  end;
                end
              else
                ThumbB.Canvas.CopyRect(Rect(0, 0, ThumbB.Width, ThumbB.Height), Picture.Canvas, R1);
            end
          else
            case Kind of
              sbHorizontal:
                CreateHSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                  ThumbB.Width, ThumbB.Height, ThumbStretchEffect);
              sbVertical:
                CreateVSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                  ThumbB.Width, ThumbB.Height, ThumbStretchEffect);
            end;
          // draw glyph
          if Down or IsFocused
          then R1 := DownGlyphRect
          else if MouseIn then R1 := ActiveGlyphRect
          else R1 := GlyphRect;
          if not IsNullRect(R1)
          then
            begin
              R2 := Rect(ThumbB.Width div 2 - RectWidth(R1) div 2,
                         ThumbB.Height div 2 - RectHeight(R1) div 2,
                         ThumbB.Width div 2 - RectWidth(R1) div 2 + RectWidth(R1),
                         ThumbB.Height div 2 - RectHeight(R1) div 2 + RectHeight(R1));
              if GlyphTransparent
              then
                begin
                  GlyphB := TBitMap.Create;
                  GlyphB.Width := RectWidth(R1);
                  GlyphB.Height := RectHeight(R1);
                  GlyphB.Canvas.CopyRect(Rect(0, 0, GlyphB.Width, GlyphB.Height),
                    Picture.Canvas, R1);
                  GlyphB.Transparent := True;
                  GlyphB.TransparentMode := tmFixed;
                  GlyphB.TransparentColor := GlyphTransparentColor;
                  ThumbB.Canvas.Draw(R2.Left, R2.Top, GlyphB);
                  GlyphB.Free;
                end
              else
                ThumbB.Canvas.CopyRect(R2, Picture.Canvas, R1);
            end;
          //
          if FAlphaBlend
          then
            begin
              B1 := TBitMap.Create;
              B1.Width := ThumbB.Width;
              B1.Height := ThumbB.Height;
              B1.Canvas.CopyRect(Rect(0, 0, B1.Width - 1, B1.Height),
                                 Cnvs, R);
              EB1 := TspEffectBmp.CreateFromhWnd(ThumbB.Handle);
              EB2 := TspEffectBmp.CreateFromhWnd(B1.Handle);
              kf := 1 - FAlphaBlendValue / 255;
              EB1.Morph(EB2, Kf);
              EB1.Draw(ThumbB.Canvas.Handle, 0, 0);
              EB1.Free;
              EB2.Free;
              B1.Free;
            end;
          if ThumbTransparent
          then
            begin
              ThumbB.Transparent := True;
              ThumbB.TransparentMode := tmFixed;
              ThumbB.TransparentColor := ThumbTransparentColor;
            end;
          Cnvs.Draw(R.Left, R.Top, ThumbB);
          ThumbB.Free;
        end
      else
        begin
          R1 := NullRect;
          case I of
            UPBUTTON:
            with Buttons[UPBUTTON] do
            begin
              if Down and MouseIn
              then R1 := DownUpButtonRect
              else if MouseIn then R1 := ActiveUpButtonRect;
            end;
            DOWNBUTTON:
            with Buttons[DOWNBUTTON] do
            begin
              if Down and MouseIn
              then R1 := DownDownButtonRect
              else if MouseIn then R1 := ActiveDownButtonRect;
            end
          end;
          if not IsNullRect(R1)
          then
            Cnvs.CopyRect(Buttons[i].R, Picture.Canvas, R1);
        end;
    end;
end;


procedure TspSkinScrollBar.CalcRects;
var
  Kf: Double;
  i, j, k, XMin, XMax: Integer;
  Offset: Integer;
  ThumbW, ThumbH: Integer;
  NewWidth: Integer;
begin
  if FMin = FMax
  then Kf := 0
  else kf := (FPosition - FMin) / (FMax - FMin);

  if FIndex = -1
  then
    begin
      ThumbW := SBUTTONW;
      if FBoth
      then
        NewWidth := Width - BothMarkerWidth
      else
        NewWidth := Width;
      case FKind of
        sbHorizontal:
          begin
            Buttons[DOWNBUTTON].R := Rect(1, 1, 1 + SBUTTONW, Height - 1);
            Buttons[UPBUTTON].R := Rect(NewWidth - SBUTTONW - 1, 1, NewWidth - 1, Height - 1);
            NewTrackArea := Rect(SBUTTONW + 1, 1, NewWidth - SBUTTONW - 1, Height - 1);
            if FPageSize = 0
            then
              begin
                Offset1 := NewTrackArea.Left + ThumbW div 2;
                Offset2 := NewTrackArea.Right - ThumbW div 2;
                BOffset := Round((Offset2 - Offset1) * kf);
                Buttons[THUMB].R :=
                 Rect(Offset1 + BOffset - ThumbW div 2, NewTrackArea.Top,
                     Offset1 + BOffset + ThumbW div 2, NewTrackArea.Bottom);
              end
            else
              begin
                i := RectWidth(NewTrackArea);
                j := FMax - FMin + 1;
                if j = 0 then kf := 0 else kf := FPageSize / j;
                j := Round(i * kf);
                if j < ThumbW then j := ThumbW;
                XMin := FMin;
                XMax := FMax - FPageSize + 1;
                if XMax > XMin
                then
                  kf := (FPosition - XMin) / (XMax - XMin)
                else
                  kf := 1;
                Offset1 := NewTrackArea.Left + j div 2;
                Offset2 := NewTrackArea.Right - j div 2;
                BOffset := Round((Offset2 - Offset1) * kf);
                Buttons[THUMB].R :=
                 Rect(Offset1 + BOffset - j div 2, NewTrackArea.Top,
                     Offset1 + BOffset + j div 2, NewTrackArea.Bottom);
              end;
          end;
        sbVertical:
          begin
            Buttons[DOWNBUTTON].R := Rect(1, 1, Width - 1, 1 + SBUTTONW);
            Buttons[UPBUTTON].R := Rect(1, Height - SBUTTONW - 1, Width - 1, Height - 1);
            NewTrackArea := Rect(1, SBUTTONW + 1, Width - 1, Height - SBUTTONW - 1);
            if PageSize = 0
            then
              begin
                Offset1 := NewTrackArea.Top + ThumbW div 2;
                Offset2 := NewTrackArea.Bottom - ThumbW div 2;
                BOffset := Round((Offset2 - Offset1) * kf);
                Buttons[THUMB].R :=
                  Rect(NewTrackArea.Left, Offset1 + BOffset - ThumbW div 2,
                       NewTrackArea.Right, Offset1 + BOffset + ThumbW div 2);
              end
            else
              begin
                i := RectHeight(NewTrackArea);
                j := FMax - FMin + 1;
                if j = 0 then kf := 0 else kf := FPageSize / j;
                j := Round(i * kf);
                if j < ThumbW then j := ThumbW;
                XMin := FMin;
                XMax := FMax - FPageSize + 1;
                if XMax - XMin > 0
                then
                  kf := (FPosition - XMin) / (XMax - XMin)
                else
                  kf := 0;
                Offset1 := NewTrackArea.Top + j div 2;
                Offset2 := NewTrackArea.Bottom - j div 2;
                BOffset := Round((Offset2 - Offset1) * kf);
                Buttons[THUMB].R :=
                  Rect(NewTrackArea.Left, Offset1 + BOffset - j div 2,
                      NewTrackArea.Right, Offset1 + BOffset + j div 2);
             end;
          end;
      end;
    end
   else
     begin
       ThumbW := RectWidth(ThumbRect);
       ThumbH := RectHeight(ThumbRect);
       case FKind of
         sbHorizontal:
           begin
             if ThumbMinSize <> 0
             then
               begin
                 ThumbW := ThumbMinSize;
               end;
             Offset := Width - RectWidth(SkinRect);
             NewTrackArea := TrackArea;
             Inc(NewTrackArea.Right, Offset);
             Buttons[UPBUTTON].R := UpButtonRect;
             Buttons[DOWNBUTTON].R := DownButtonRect;
             //
             if UpButtonRect.Left > RTPt.X
             then
               OffsetRect(Buttons[UPBUTTON].R, Offset, 0);
             if DownButtonRect.Left > RTPt.X
             then
               OffsetRect(Buttons[DOWNBUTTON].R, Offset, 0);
             if FPageSize = 0
             then
               begin
                 if ThumbMinPageSize <> 0  then ThumbW := ThumbMinPageSize;
                 Offset1 := NewTrackArea.Left + ThumbW div 2;
                 Offset2 := NewTrackArea.Right - ThumbW div 2;
                 BOffset := Round((Offset2 - Offset1) * kf);
                 Buttons[THUMB].R :=
                   Rect(Offset1 + BOffset - ThumbW div 2,
                        NewTrackArea.Top + RectHeight(NewTrackArea) div 2 - ThumbH div 2,
                        Offset1 + BOffset + ThumbW div 2,
                        NewTrackArea.Top + RectHeight(NewTrackArea) div 2 - ThumbH div 2 + ThumbH);
               end
             else
               begin
                 i := RectWidth(NewTrackArea);
                 j := FMax - FMin + 1;
                 if j = 0 then kf := 0 else kf := FPageSize / j;
                 j := Round(i * kf);
                 if j < ThumbW then j := ThumbW;
                 XMin := FMin;
                 XMax := FMax - FPageSize + 1;
                 if XMax <= XMin
                 then
                   kf := 1
                 else
                   kf := (FPosition - XMin) / (XMax - XMin);
                 Offset1 := NewTrackArea.Left + j div 2;
                 Offset2 := NewTrackArea.Right - j div 2;
                 BOffset := Round((Offset2 - Offset1) * kf);
                 Buttons[THUMB].R :=
                 Rect(Offset1 + BOffset - j div 2,
                      NewTrackArea.Top + RectHeight(NewTrackArea) div 2 - ThumbH div 2,
                      Offset1 + BOffset + j div 2,
                      NewTrackArea.Top + RectHeight(NewTrackArea) div 2 - ThumbH div 2 +
                      ThumbH);
              end;
           end;
         sbVertical:
           begin
             if ThumbMinSize <> 0
             then
               begin
                 ThumbH := ThumbMinSize;
               end;
             Offset := Height - RectHeight(SkinRect);
             NewTrackArea := TrackArea;
             Inc(NewTrackArea.Bottom, Offset);
             Buttons[UPBUTTON].R := UpButtonRect;
             Buttons[DOWNBUTTON].R := DownButtonRect;
             if UpButtonRect.Top > LBPt.Y
             then
               OffsetRect(Buttons[UPBUTTON].R, 0, Offset);
             if DownButtonRect.Top > LBPt.Y
             then
               OffsetRect(Buttons[DOWNBUTTON].R, 0, Offset);
             if PageSize = 0
             then
              begin
                if ThumbMinPageSize <> 0  then ThumbH := ThumbMinPageSize;
                Offset1 := NewTrackArea.Top + ThumbH div 2;
                Offset2 := NewTrackArea.Bottom - ThumbH div 2;
                BOffset := Round((Offset2 - Offset1) * kf);
                Buttons[THUMB].R :=
                  Rect(NewTrackArea.Left + RectWidth(NewTrackArea) div 2 -
                       ThumbW div 2,
                       Offset1 + BOffset - ThumbH div 2,
                       NewTrackArea.Left + RectWidth(NewTrackArea) div 2 -
                       ThumbW div 2 + ThumbW,
                       Offset1 + BOffset + ThumbH div 2);
              end
             else
               begin
                 i := RectHeight(NewTrackArea);
                 j := FMax - FMin + 1;
                 if j = 0 then kf := 0 else kf := FPageSize / j;
                 j := Round(i * kf);
                 if j < ThumbH then j := ThumbH;
                 XMin := FMin;
                 XMax := FMax - FPageSize + 1;
                 if XMax - XMin <= 0
                 then
                   kf := 0
                 else
                   kf := (FPosition - XMin) / (XMax - XMin);
                 Offset1 := NewTrackArea.Top + j div 2;
                 Offset2 := NewTrackArea.Bottom - j div 2;
                 BOffset := Round((Offset2 - Offset1) * kf);
                 Buttons[THUMB].R :=
                   Rect(NewTrackArea.Left + RectWidth(NewTrackArea) div 2 -
                        ThumbW div 2,
                        Offset1 + BOffset - j div 2,
                        NewTrackArea.Left + RectWidth(NewTrackArea) div 2 -
                        ThumbW div 2 + ThumbW,
                        Offset1 + BOffset + j div 2);
               end;
           end;
       end;
     end;
end;

procedure TspSkinScrollBar.SetKind;
var
  S: Integer;
begin
  if AValue <> FKind
  then
    begin
      FKind := AValue;
      RePaint;
    end;
 if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FKind = sbVertical
      then
        begin
          FSkinDataName := 'vscrollbar';
          if Width > Height
          then
            begin
              S := Width;
              Width := Height;
              Height := S;
            end;
          FDefaultWidth := FDefaultHeight;
          FDefaultHeight := 0;  
        end
      else
        begin
          FSkinDataName := 'hscrollbar';
          if Width < Height
          then
            begin
              S := Width;
              Width := Height;
              Height := S;
            end;
          FDefaultHeight := FDefaultWidth;
          FDefaultWidth := 0;
        end;
    end;
end;

procedure TspSkinScrollBar.SimplySetPosition;
var
  TempValue: Integer;
begin
  if FPageSize = 0
  then
    begin
      if AValue < FMin then TempValue := FMin else
      if AValue > FMax then TempValue := FMax else
      TempValue := AValue;
    end
  else
    begin
      if AValue < FMin then TempValue := FMin else
      if AValue > FMax - FPageSize + 1 then
      TempValue := FMax - FPageSize + 1  else
      TempValue := AValue;
    end;
  if TempValue <> FPosition
  then
    begin
      FPosition := TempValue;
      RePaint;
   end;
end;

procedure TspSkinScrollBar.SetPosition;
var
  TempValue: Integer;
begin
  if FPageSize = 0
  then
    begin
      if AValue < FMin then TempValue := FMin else
      if AValue > FMax then TempValue := FMax else
      TempValue := AValue;
    end
  else
    begin
      if AValue < FMin then TempValue := FMin else
      if AValue > FMax - FPageSize + 1 then
      TempValue := FMax - FPageSize + 1  else
      TempValue := AValue;
    end;
  if TempValue <> FPosition
  then
    begin
      FPosition := TempValue;
      RePaint;
      if Assigned(FOnChange) then FOnChange(Self);
    end;

end;

procedure TspSkinScrollBar.SetRange;
begin
  FMin := AMin;
  FMax := AMax;
  FPageSize := APageSize;
  if FPageSize = 0
  then
    begin
      if APosition < FMin then FPosition := FMin else
      if APosition > FMax then FPosition := FMax else
      FPosition := APosition;
    end
  else
    begin
      if APosition < FMin then FPosition := FMin else
      if APosition > FMax - FPageSize + 1 then
      FPosition := FMax - FPageSize + 1  else
      FPosition := APosition;
    end;
  RePaint;
end;

procedure TspSkinScrollBar.SetMax;
begin
  FMax := AValue;
  if FPageSize = 0
  then
    begin
      if FPosition > FMax then FPosition := FMax;
    end
  else
    begin
      if FPageSize + FPosition > FMax - FMin
      then
        FPosition := (FMax - FMin) - FPageSize + 1;
      if FPosition < FMin then FPosition := FMin;
    end;
  RePaint;
end;

procedure TspSkinScrollBar.SetMin;
begin
  FMin := AValue;
  if FPosition < FMin then FPosition := FMin;
  RePaint;
end;

procedure TspSkinScrollBar.SetSmallChange;
begin
  FSmallChange := AValue;
  RePaint;
end;

procedure TspSkinScrollBar.SetLargeChange;
begin
  FLargeChange := AValue;
  RePaint;
end;

procedure TspSkinScrollBar.CreateControlDefaultImage;
var
  R: TRect;
  i: Integer;
  j: Integer;
begin
  CalcRects;
  R := ClientRect;
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(R);
  end;
  Frame3D(B.Canvas, R, clBtnFace, clBtnFace, 1);
  if Enabled then j :=  0 else j := 1;
  for i := j to BUTCOUNT - 1 do DrawButton(B.Canvas, i);
end;

procedure TspSkinScrollBar.MouseDown;
var
  i: Integer;
  j: Integer;
begin
  inherited;
  if Button <> mbLeft
  then
    begin
      inherited;
      Exit;
    end;
  MouseD := True;
  CalcRects;
  TimerMode := 0;
  WaitMode := True;
  j := -1;
  for i := 0 to BUTCOUNT - 1 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;
  if j <> -1
  then
    begin
      CaptureButton := j;
      ButtonDown(j, X, Y);
    end
  else
    begin
      if PtInRect(NewTrackArea, Point(X, Y))
      then
        case Kind of
          sbHorizontal:
            begin
              if X < Buttons[THUMB].R.Left
              then
                begin
                  Position := Position - LargeChange;
                  TimerMode := 3;
                  SetTimer(Handle, 1, 500, nil);
                  if Assigned(FOnPageUp) then FOnPageUp(Self);
                end
              else
                begin
                  Position := Position + LargeChange;
                  TimerMode := 4;
                  SetTimer(Handle, 1, 500, nil);
                  if Assigned(FOnPageDown) then FOnPageDown(Self);
                end;
            end;
          sbVertical:
           begin
             if Y < Buttons[THUMB].R.Top
              then
                begin
                  Position := Position - LargeChange;
                  TimerMode := 3;
                  SetTimer(Handle, 1, 500, nil);
                  if Assigned(FOnPageUp) then FOnPageUp(Self);
                end
              else
                begin
                  Position := Position + LargeChange;
                  TimerMode := 4;
                  SetTimer(Handle, 1, 500, nil);
                  if Assigned(FOnPageDown) then FOnPageDown(Self);
                end;
           end;
        end;
    end;
end;

procedure TspSkinScrollBar.MouseUp;
begin
  inherited;
  MouseD := False;
  if (TimerMode >= 3) then StopTimer;
  if CaptureButton <> -1 then ButtonUp(CaptureButton, X, Y);
  if (Button = mbLeft) and (CaptureButton = 0) and Assigned(FOnLastChange)
  then
    FOnLastChange(Self);
  CaptureButton := -1;
end;

function TspSkinScrollBar.CalcValue;
var
  kf: Double;
  TempPos: Integer;
begin
  if FPageSize = 0
  then
    begin
      if (Offset2 - Offset1) <= 0
      then kf := 0
      else kf := AOffset / (Offset2 - Offset1);
      if kf > 1 then kf := 1 else
      if kf < 0 then kf := 0;
      Result := FMin + Round((FMax - FMin) * kf);
    end
  else
    begin
      case Kind of
        sbVertical:
          begin
            Offset1 := NewTrackArea.Top + RectHeight(Buttons[THUMB].R) div 2;
            Offset2 := NewTrackArea.Bottom - RectHeight(Buttons[THUMB].R) div 2;
          end;
        sbHorizontal:
          begin
            Offset1 := NewTrackArea.Left + RectWidth(Buttons[THUMB].R) div 2;
            Offset2 := NewTrackArea.Right - RectWidth(Buttons[THUMB].R) div 2;
          end;
      end;
      TempPos := OldBOffset + AOffset;
      if (Offset2 - Offset1) <= 0
      then kf := 0
      else kf := TempPos / (Offset2 - Offset1);
      if kf > 1 then kf := 1 else
      if kf < 0 then kf := 0;
      Result := FMin + Round((FMax - FMin - FPageSize + 1) * kf);
    end;
end;

procedure TspSkinScrollBar.MouseMove;
var
  Off: Integer;
begin
  MX := X; MY := Y;
  TestActive(X, Y);
  if FDown
  then
    case Kind of
      sbVertical:
        begin
          if PageSize = 0
          then
            begin
              Off := Y - OMPos;
              Off := OldBOffset + Off;
              Position := CalcValue(Off);
            end
          else
            Off := Y - OMPos;
          Position := CalcValue(Off);
        end;
      sbHorizontal:
        begin
          if PageSize = 0
          then
            begin
              Off := X - OMPos;
              Off := OldBOffset + Off;
              Position := CalcValue(Off);
            end
          else
            Off := X - OMPos;
          Position := CalcValue(Off);
        end;
    end;
  inherited;
end;

procedure TspSkinScrollBar.ButtonDown;
begin
  Buttons[i].Down := True;
  RePaint;
  case i of
    THUMB:
      with Buttons[THUMB] do
      begin
        if Kind = sbVertical then OMPos := Y else OMPos := X;
        OldBOffset := BOffset;
        OldPosition := Position;
        case Kind of
         sbHorizontal:
           begin
             FScrollWidth := NewTrackArea.Right - R.Right;
             if FScrollWidth <= 0
             then FScrollWidth := R.Left - NewTrackArea.Left;
           end;
         sbVertical:
           begin
             FScrollWidth := NewTrackArea.Bottom - R.Bottom;
             if FScrollWidth <= 0
             then FScrollWidth := R.Top - NewTrackArea.Top;
           end;
        end;     
        FDown := True;
        RePaint;
      end;
    DOWNBUTTON:
      with Buttons[UPBUTTON] do
      begin
        if Assigned(FOnDownButtonClick)
        then
          FOnDownButtonClick(Self)
        else
          Position := Position - SmallChange;
        TimerMode := 1;
        SetTimer(Handle, 1, 500, nil);
      end;
    UPBUTTON:
      with Buttons[DOWNBUTTON] do
      begin
        if Assigned(FOnUpButtonClick)
        then
          FOnUpButtonClick(Self)
        else
          Position := Position + SmallChange;
        TimerMode := 2;
        SetTimer(Handle, 1, 500, nil);
      end;
  end;
end;

procedure TspSkinScrollBar.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  RePaint;
  case i of
    THUMB:
      begin
        FDown := False;
      end;
    UPBUTTON:
      with Buttons[UPBUTTON] do
      begin
        StopTimer;
      end;
    DOWNBUTTON:
      with Buttons[DOWNBUTTON] do
      begin
        StopTimer;
      end;
  end;
end;

procedure TspSkinScrollBar.ButtonEnter(I: Integer);
begin
  Buttons[i].MouseIn := True;
  RePaint;
  case i of
    THUMB:
      with Buttons[THUMB] do
      begin
      end;
    UPBUTTON:
      with Buttons[UPBUTTON] do
      begin
        if Down then SetTimer(Handle, 1, 50, nil);
      end;
    DOWNBUTTON:
      with Buttons[DOWNBUTTON] do
      begin
        if Down then SetTimer(Handle, 1, 50, nil);
      end;
  end;
end;

procedure TspSkinScrollBar.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  RePaint;
  case i of
    THUMB:
      with Buttons[THUMB] do
      begin
      end;
    UPBUTTON:
      with Buttons[UPBUTTON] do
      begin
        if Down then  KillTimer(Handle, 1);
      end;
    DOWNBUTTON:
      with Buttons[DOWNBUTTON] do
      begin
        if Down then  KillTimer(Handle, 1);
      end;
  end;
end;


procedure TspSkinScrollBar.StartScroll;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 50, nil);
end;

procedure TspSkinScrollBar.WMTimer;
var
  CanScroll: Boolean;
begin
  inherited;
  if WaitMode
  then
    begin
      WaitMode := False;
      StartScroll;
      Exit;
    end;
  case TimerMode of
    1:
      begin
        if Assigned(FOnDownButtonClick)
        then
          FOnDownButtonClick(Self)
        else
          Position := Position - SmallChange;
      end;
    2:
      begin
        if Assigned(FOnUpButtonClick)
        then
          FOnUpButtonClick(Self)
        else
          Position := Position + SmallChange;
      end;
    3:
      begin
        TestActive(MX, MY);
        case Kind of
          sbHorizontal: CanScroll := MX < Buttons[THUMB].R.Left;
          sbVertical: CanScroll := MY < Buttons[THUMB].R.Top;
        end;
        if CanScroll
        then
          begin
            Position := Position - LargeChange;
            if Assigned(FOnPageUp) then FOnPageUp(Self);
          end
        else
          StopTimer;
      end;
    4:
      begin
        TestActive(MX, MY);
        case Kind of
          sbHorizontal: CanScroll := MX > Buttons[THUMB].R.Right;
          sbVertical: CanScroll := MY > Buttons[THUMB].R.Bottom;
        end;
        if CanScroll
        then
          begin
            Position := Position + LargeChange;
            if Assigned(FOnPageDown) then FOnPageDown(Self);
          end
        else
          StopTimer;
      end;
  end;
end;

procedure TspSkinScrollBar.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if (ActiveButton <> -1) and (CaptureButton = -1) and not FDown
  then
    begin
      Buttons[ActiveButton].MouseIn := False;
      RePaint;
      ActiveButton := -1;
    end;
  if MouseD and (TimerMode > 3) then StopTimer;
end;

procedure TspSkinScrollBar.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
end;

constructor TspSkinSplitter.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque];
  FSkinPicture := nil;
  FIndex := -1;
  FDefaultSize := 10;
  FSkinDataName := 'vsplitter';
  StretchEffect := False;
  FTransparent := False;
end;

destructor  TspSkinSplitter.Destroy;
begin
  inherited;
end;

procedure TspSkinSplitter.RequestAlign;
begin
  inherited RequestAlign;
  if (csDesigning in ComponentState)
  then
    if Align in [alBottom, alTop]
    then
      FSkinDataName := 'hsplitter'
    else
      FSkinDataName := 'vsplitter';
end;


procedure TspSkinSplitter.SetTransparent;
begin
  if FTransparent = Value then Exit;
  FTransparent := Value;
  if FTransparent
  then
    ControlStyle := ControlStyle - [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque];
  Repaint;
end;

procedure TspSkinSplitter.Paint;
var
  Buffer: TBitMap;
  GripperBuffer: TBitMap;
  GX, GY: Integer;
begin

  if FTransparent then Exit;

  if (Width <= 0) or (Height <= 0) then Exit;
  ControlStyle := ControlStyle - [csOpaque];
  GetSkinData;
  if (FIndex <> -1) and (Align <> alNone) and (Align <> alClient)
  then
    begin
      Buffer := TBitMap.Create;
      if (Align = alTop) or (Align = alBottom)
      then
        CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RtPt.X,
          Buffer, FSkinPicture, SkinRect, Width, RectHeight(SkinRect), StretchEffect)
      else
        CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          Buffer, FSkinPicture, SkinRect, RectWidth(SkinRect), Height, StretchEffect);
      // draw gripper
      if not IsNullRect(GripperRect)
      then
        begin
          GripperBuffer := TBitMap.Create;
          GripperBuffer.Width := RectWidth(GripperRect);
          GripperBuffer.Height := RectHeight(GripperRect);
          GripperBuffer.Canvas.CopyRect(
            Rect(0, 0, GripperBuffer.Width, GripperBuffer.Height),
            FSkinPicture.Canvas, GripperRect);
          GX := Buffer.Width div 2 - GripperBuffer.Width div 2;
          GY := Buffer.Height div 2 - GripperBuffer.Height div 2;
          if GripperTransparent
          then
            begin
              GripperBuffer.Transparent := True;
              GripperBuffer.TransparentMode := tmFixed;
              GripperBuffer.TransparentColor := GripperTransparentColor;
            end;
          Buffer.Canvas.Draw(GX, GY, GripperBuffer);
          GripperBuffer.Free;
        end;
      //
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end
  else
    inherited;
  ControlStyle := ControlStyle + [csOpaque];
end;

procedure TspSkinSplitter.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinSplitter.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  FSkinPicture := nil;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinSplitterControl
    then
      with TspDataSkinSplitterControl(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        Self.SkinRect := SkinRect;
        Self.StretchEffect := StretchEffect;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          FSkinPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          FSkinPicture := nil;
        Self.GripperRect := GripperRect;
        Self.GripperTransparent := GripperTransparent;
        Self.GripperTransparentColor := GripperTransparentColor;
      end;
end;

procedure TspSkinSplitter.ChangeSkinData;
var
  lMinSize: Integer;
begin
  GetSkinData;
  if (Align = alTop) or (Align = alBottom)
  then
    begin
      if (FIndex = -1) or FTransparent
      then
        lMinSize := FDefaultSize
      else
        lMinSize := RectHeight(SkinRect);
      Height := lMinSize;
    end
  else
    begin
      if (FIndex = -1) or FTransparent
      then
        lMinSize := FDefaultSize
      else
        lMinSize := RectWidth(SkinRect);
     Width := lMinSize;
    end;
  RePaint;
end;

procedure TspSkinSplitter.SetSkinData;
begin
  FSD := Value;
  ChangeSkinData;
end;

constructor TspSkinControlBar.Create(AOwner: TComponent);
begin
  inherited;
  FSkinPicture := nil;
  FIndex := -1;
  if (csDesigning in ComponentState)
  then
    begin
      AutoSize := True;
      AutoDrag := False;
      RowSnap := False;
    end;
  BevelKind := bkNone;
  FSkinDataName := 'controlbar';
  ItemOffset1 := 3;
  ItemOffset2 := 3;
  ItemStretchEffect := False;
end;

destructor TspSkinControlBar.Destroy;
begin
  inherited;
end;

procedure TspSkinControlBar.CMSENCPaint(var Message: TMessage);
begin
  if (Message.wParam <> 0) and FSkinBevel
  then
    begin
      PaintNCSkin(Message.wParam, True);
      Message.Result := SE_RESULT;
    end
  else
    Message.Result := 0;
end;

procedure TspSkinControlBar.CMBENCPAINT;
begin
   if (Message.LParam = BE_ID)
  then
    begin
      if (Message.wParam <> 0) and FSkinBevel
      then
        begin
          PaintNCSkin(Message.wParam, True);
        end;
      Message.Result := BE_ID;
    end
  else
    inherited;
end;

procedure TspSkinControlBar.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinControlBar.WMSIZE;
begin
  inherited;
  GetSkinData;
  if (FIndex <> -1) and FSkinBevel then PaintNCSkin(0, False);
  if (FIndex <> -1) and StretchEffect then CheckControlsBackground;
end;

procedure TspSkinControlBar.CheckControlsBackground;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TWinControl
    then
      SendMessage(TWinControl(Controls[i]).Handle, WM_CHECKPARENTBG, 0, 0)
    else
    if Controls[i] is TGraphicControl
    then
      TGraphicControl(Controls[i]).Perform(WM_CHECKPARENTBG, 0, 0);
  end;
end;


procedure TspSkinControlBar.SetSkinBevel;
begin
  FSkinBevel := Value;
  if FIndex <> -1 then RecreateWnd;
end;

procedure TspSkinControlBar.PaintNCSkin;
var
  LeftBitMap, TopBitMap, RightBitMap, BottomBitMap: TBitMap;
  DC: HDC;
  Cnvs: TControlCanvas;
  OX, OY: Integer;
begin
  if not AUseExternalDC then  DC := GetWindowDC(Handle) else DC := ADC;
  Cnvs := TControlCanvas.Create;
  Cnvs.Handle := DC;
  LeftBitMap := TBitMap.Create;
  TopBitMap := TBitMap.Create;
  RightBitMap := TBitMap.Create;
  BottomBitMap := TBitMap.Create;
  //
  OX := Width - RectWidth(SkinRect);
  OY := Height - RectHeight(SkinRect);
  NewLTPoint := LTPt;
  NewRTPoint := Point(RTPt.X + OX, RTPt.Y);
  NewLBPoint := Point(LBPt.X, LBPt.Y + OY);
  NewRBPoint := Point(RBPt.X + OX, RBPt.Y + OY);
  NewClRect := Rect(ClRect.Left, ClRect.Top,
    ClRect.Right + OX, ClRect.Bottom + OY);
  //
  CreateSkinBorderImages(LTPt, RTPt, LBPt, RBPt, ClRect,
      NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftBitMap, TopBitMap, RightBitMap, BottomBitMap,
      FSkinPicture, SkinRect, Width, Height,
      LeftStretch, TopStretch, RightStretch, BottomStretch);

  if NewClRect.Bottom > NewClRect.Top
  then
    ExcludeClipRect(Cnvs.Handle,
      NewClRect.Left, NewClRect.Top, NewClRect.Right, NewClRect.Bottom);

  Cnvs.Draw(0, 0, TopBitMap);
  Cnvs.Draw(0, TopBitMap.Height, LeftBitMap);
  Cnvs.Draw(Width - RightBitMap.Width, TopBitMap.Height, RightBitMap);
  Cnvs.Draw(0, Height - BottomBitMap.Height, BottomBitMap);
  //
  TopBitMap.Free;
  LeftBitMap.Free;
  RightBitMap.Free;
  BottomBitMap.Free;
  Cnvs.Handle := 0;
  if not AUseExternalDC then ReleaseDC(Handle, DC);
  Cnvs.Free;
end;

procedure TspSkinControlBar.Paint;
var
  X, Y, XCnt, YCnt, w, h,
  rw, rh, XO, YO: Integer;
  Buffer, Buffer2: TBitMap;
  i: Integer;
  R: TRect;
  B: TBitMap;
  SaveIndex: Integer;
begin
  GetSkinData;
  if FIndex = -1
  then
    begin
      inherited;
      Exit;
    end;
  if (ClientWidth > 0) and (ClientHeight > 0) and
     StretchEffect
  then
    begin
      B := TBitMap.Create;
      B.Width := ClientWidth;
      B.Height := ClientHeight;
      if BGPictureIndex = -1
      then
        begin
          Buffer := TBitMap.Create;
          Buffer.Width := RectWidth(ClRect);
          Buffer.Height := RectHeight(ClRect);
          Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
            FSkinPicture.Canvas,
              Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                   SkinRect.Left + ClRect.Right,
                   SkinRect.Top + ClRect.Bottom));
        end
      else
        Buffer := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);

      case StretchType of
            spstFull:
              begin
                B.Canvas.StretchDraw(Rect(0, 0, Width, Height), Buffer);
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := Width;
                Buffer2.Height := Buffer.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
                YCnt := Height div Buffer2.Height;
                for Y := 0 to YCnt do
                  B.Canvas.Draw(0, Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
           spstHorz:
             begin
               Buffer2 := TBitMap.Create;
               Buffer2.Width := Buffer.Width;
               Buffer2.Height := Height;
               Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
               XCnt := Width div Buffer2.Width;
               for X := 0 to XCnt do
                 B.Canvas.Draw(X * Buffer2.Width, 0, Buffer2);
               Buffer2.Free;
             end;
          end;

      if BGPictureIndex = -1 then Buffer.Free;

      for i := 0 to ControlCount - 1 do
        if Controls[i].Visible
        then
          begin
            R := Controls[i].BoundsRect;
            Dec(R.Left, 11);
            Dec(R.Top, 2);
            Inc(R.Right, 2);
            Inc(R.Bottom, 2);
            PaintControlFrame(B.Canvas, Controls[i], R);
          end;
      Canvas.Draw(0, 0, B);
      B.Free;
    end
  else
  if (ClientWidth > 0) and (ClientHeight > 0)
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := ClientWidth;
      Buffer.Height := ClientHeight;

      if BGPictureIndex = -1
      then
        begin
          w := RectWidth(ClRect);
          h := RectHeight(ClRect);
          rw := Buffer.Width;
          rh := Buffer.Height;
          with Buffer.Canvas do
          begin
            XCnt := rw div w;
            YCnt := rh div h;
            for X := 0 to XCnt do
            for Y := 0 to YCnt do
            begin
              if X * w + w > rw then XO := X * W + W - rw else XO := 0;
              if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
                CopyRect(Rect(X * w, Y * h,X * w + w - XO, Y * h + h - YO),
                   FSkinPicture.Canvas,
                   Rect(SkinRect.Left + ClRect.Left,
                        SkinRect.Top + ClRect.Top,
                        SkinRect.Left + ClRect.Right - XO,
                         SkinRect.Top + ClRect.Bottom - YO));
            end;
          end;
        end
      else
        begin
          B := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
          XCnt := Width div B.Width;
          YCnt := Height div B.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
            Buffer.Canvas.Draw(X * B.Width, Y * B.Height, B);
        end;

        // draw controls frame
          for i := 0 to ControlCount - 1 do
            if Controls[i].Visible
            then
               begin
                 R := Controls[i].BoundsRect;
                 Dec(R.Left, 11);
                 Dec(R.Top, 2);
                 Inc(R.Right, 2);
                 Inc(R.Bottom, 2);
                 PaintControlFrame(Buffer.Canvas, Controls[i], R);
               end;
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end;
end;

procedure TspSkinControlBar.PaintControlFrame;
var
  LeftB, TopB, RightB, BottomB: TBitMap;
  W, H, IW, IH: Integer;
begin
  GetSkinData;
  if FIndex <> -1
  then
    begin
      LeftB := TBitMap.Create;
      TopB := TBitMap.Create;
      RightB := TBitMap.Create;
      BottomB := TBitMap.Create;
      W := RectWidth(ARect);
      H := RectHeight(ARect);
      IW := RectWidth(ItemRect);
      IH := RectHeight(ItemRect);
      //
      CreateSkinBorderImages(
        Point(12, ItemOffset1), Point(IW - 3, 3),
        Point(12, IH - ItemOffset2), Point(IW - 3, IH - 3),
        Rect(11, 2, IW - 2, IH - 2),
        Point(12, ItemOffset1), Point(W - 3, 3),
        Point(12, H - ItemOffset2), Point(W - 3, H - 3),
        Rect(11, 2, W - 2, H - 2),
        LeftB, TopB, RightB, BottomB,
        FSkinPicture, ItemRect,  W, H, ItemStretchEffect,
          ItemStretchEffect, ItemStretchEffect, ItemStretchEffect);
      //
      if ItemTransparent
      then
        begin
          TopB.Transparent := True;
          TopB.TransparentMode := tmFixed;
          TopB.TransparentColor := ItemTransparentColor;
          LeftB.Transparent := True;
          LeftB.TransparentMode := tmFixed;
          LeftB.TransparentColor := ItemTransparentColor;
          RightB.Transparent := True;
          RightB.TransparentMode := tmFixed;
          RightB.TransparentColor := ItemTransparentColor;
          BottomB.Transparent := True;
          BottomB.TransparentMode := tmFixed;
          BottomB.TransparentColor := ItemTransparentColor;
        end;
      //  
      Canvas.Draw(ARect.Left, ARect.Top, TopB);
      Canvas.Draw(ARect.Left, ARect.Top + TopB.Height, LeftB);
      Canvas.Draw(ARect.Right - RightB.Width, ARect.Top + TopB.Height, RightB);
      Canvas.Draw(ARect.Left, ARect.Bottom - BottomB.Height, BottomB);
      //
      LeftB.Free;
      TopB.Free;
      RightB.Free;
      BottomB.Free;
    end
  else
    inherited;
end;

procedure TspSkinControlBar.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  BGPictureIndex := -1;  
  FSkinPicture := nil;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinControlBar
    then
      with TspDataSkinControlBar(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        RBPt := RBPoint;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          FSkinPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          FSkinPicture := nil;
        Self.ItemRect := ItemRect;
        Self.BGPictureIndex := BGPictureIndex;
        Self.LeftStretch := LeftStretch;
        Self.TopStretch := TopStretch;
        Self.RightStretch := RightStretch;
        Self.BottomStretch := BottomStretch;
        Self.StretchEffect := StretchEffect;
        Self.StretchType := StretchType;
        Self.ItemStretchEffect := ItemStretchEffect;
        Self.ItemOffset1 := ItemOffset1;
        Self.ItemOffset2 := ItemOffset2;
        Self.ItemTransparent := ItemTransparent;
        Self.ItemTransparentColor := ItemTransparentColor;
      end;
end;

procedure TspSkinControlBar.ChangeSkinData;
var
  R: TRect;
begin
  GetSkinData;
  if FIndex <> -1
  then
    DoubleBuffered := False
  else
    DoubleBuffered := True;
  if FSkinBevel then ReCreateWnd;
  R := ClientRect;
  AdjustClientRect(R);
  RePaint;
end;

procedure TspSkinControlBar.SetSkinData;
begin
  FSD := Value;
  ChangeSkinData;
end;

procedure TspSkinControlBar.WMNCCALCSIZE;
begin
  GetSkinData;
  if FIndex <> -1
  then
    begin
      if FSkinBevel then 
      with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
      begin
        Inc(Left, ClRect.Left);
        Inc(Top,  ClRect.Top);
        Dec(Right, RectWidth(SkinRect) - ClRect.Right);
        Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
        if Right < Left then Right := Left;
        if Bottom < Top
        then Bottom := Top;
      end;  
    end
  else
    inherited;
end;

procedure TspSkinControlBar.WMNCPAINT(var Message: TMessage);
begin
  GetSkinData;
  if FIndex <> -1
  then
    begin
      if FSkinBevel then PaintNCSkin(0, False);
    end
  else
    inherited;
end;

procedure TspSkinControlBar.CreateParams;
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
  end;
end;

procedure TspSkinControlBar.WMEraseBkgnd;
begin
  GetSkinData;
  if FIndex = -1 then inherited else Message.Result := 1;
end;


{ TspGroupButton }

type
  TspGroupButton = class(TspSkinCheckRadioBox)
  private
    FInClick: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor InternalCreate(RadioGroup: TspSkinCustomRadioGroup);
    destructor Destroy; override;
  end;

  TspCheckGroupButton = class(TspSkinCheckRadioBox)
  private
    FInClick: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor InternalCreate(CheckGroup: TspSkinCustomCheckGroup);
    destructor Destroy; override;
  end;


constructor TspGroupButton.InternalCreate(RadioGroup: TspSkinCustomRadioGroup);
begin
  inherited Create(RadioGroup);
  FFlat := True;
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  RadioGroup.FButtons.Add(Self);
  Visible := False;
  Enabled := RadioGroup.Enabled;
  ParentShowHint := False;
  OnClick := RadioGroup.ButtonClick;
  Parent := RadioGroup;
  Radio := True;
  CanFocused := True;
  SkinDataName := 'radiobox';
  GroupIndex := 1;
end;

destructor TspGroupButton .Destroy;
begin
  TspSkinCustomRadioGroup(Owner).FButtons.Remove(Self);
  inherited Destroy;
end;

procedure TspGroupButton .CNCommand(var Message: TWMCommand);
begin
  if not FInClick then
  begin
    FInClick := True;
    try
      if ((Message.NotifyCode = BN_CLICKED) or
        (Message.NotifyCode = BN_DOUBLECLICKED)) and
        TspSkinCustomRadioGroup(Parent).CanModify then
        inherited;
    except
      Application.HandleException(Self);
    end;
    FInClick := False;
  end;
end;

procedure TspGroupButton .KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  TspSkinCustomRadioGroup(Parent).KeyPress(Key);
  if (Key = #8) or (Key = ' ') then
  begin
    if not TspSkinCustomRadioGroup(Parent).CanModify then Key := #0;
  end;
end;

procedure TspGroupButton .KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  TspSkinCustomRadioGroup(Parent).KeyDown(Key, Shift);
end;


constructor TspCheckGroupButton.InternalCreate(CheckGroup: TspSkinCustomCheckGroup);
begin
  inherited Create(CheckGroup);
  CheckGroup.FButtons.Add(Self);
  Visible := False;
  Enabled := CheckGroup.Enabled;
  ParentShowHint := False;
  OnClick := CheckGroup.ButtonClick;
  Parent := CheckGroup;
  Radio := False;
  CanFocused := True;
  SkinDataName := 'checkbox';
  Flat := True;
end;

destructor TspCheckGroupButton .Destroy;
begin
  TspSkinCustomCheckGroup(Owner).FButtons.Remove(Self);
  inherited Destroy;
end;

function TspSkinCustomCheckGroup.CanModify: Boolean;
begin
  Result := True;
end;

procedure TspSkinCustomCheckGroup.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TspCheckGroupButton .CNCommand(var Message: TWMCommand);
begin
  if not FInClick then
  begin
    FInClick := True;
    try
      if ((Message.NotifyCode = BN_CLICKED) or
        (Message.NotifyCode = BN_DOUBLECLICKED)) and
        TspSkinCustomCheckGroup(Parent).CanModify then
        inherited;
    except
      Application.HandleException(Self);
    end;
    FInClick := False;
  end;
end;

procedure TspCheckGroupButton.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  TspSkinCustomCheckGroup(Parent).KeyPress(Key);
  if (Key = #8) or (Key = ' ') then
  begin
    if not TspSkinCustomCheckGroup(Parent).CanModify then Key := #0;
  end;
end;

procedure TspCheckGroupButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  TspSkinCustomCheckGroup(Parent).KeyDown(Key, Shift);
end;


{ TspSkinCustomRadioGroup }

constructor TspSkinCustomRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csDoubleClicks];
  FButtons := TList.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FItemIndex := -1;
  FColumns := 1;
  FButtonSkinDataName := 'radiobox';
  FButtonDefaultFont := TFont.Create;
  with FButtonDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinCustomRadioGroup.Destroy;
begin
  SetButtonCount(0);
  TStringList(FItems).OnChange := nil;
  FItems.Free;
  FButtons.Free;
  FButtonDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinCustomRadioGroup.UpDateButtonsFont;
var
  i: Integer;
begin
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspGroupButton (FButtons[I]) do
     begin
       DefaultFont.Assign(FButtonDefaultFont);
       UseSkinFont := Self.UseSkinFont;
       Invalidate;
     end;
end;

procedure TspSkinCustomRadioGroup.SetButtonDefaultFont;
var
  I: Integer;
begin
  FButtonDefaultFont.Assign(Value);
  if FButtons.Count > 0
  then
    for I := 0 to FButtons.Count - 1 do
      with TspGroupButton (FButtons[I]) do
        DefaultFont.Assign(FButtonDefaultFont);
end;

procedure TspSkinCustomRadioGroup.SetImages(Value: TCustomImageList);
var
  I: Integer;
begin
  FImages := Value;
  if FButtons.Count > 0
  then
    for I := 0 to FButtons.Count - 1 do
      with TspGroupButton (FButtons[I]) do
        Images := Self.Images;
end;

procedure TspSkinCustomRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then Images := nil;
  end;
end;

procedure TspSkinCustomRadioGroup.ChangeSkinData;
begin
  inherited;
  Self.ArrangeButtons;
end;

procedure TspSkinCustomRadioGroup.SetSkinData;
var
  I: Integer;
begin
  inherited;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspGroupButton (FButtons[I]) do
       SkinData := Value;
end;

procedure TspSkinCustomRadioGroup.SetButtonSkinDataName;
var
  I: Integer;
begin
  FButtonSkinDataName := Value;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspGroupButton (FButtons[I]) do
       SkinDataName := Value;
end;

procedure TspSkinCustomRadioGroup.FlipChildren(AllLevels: Boolean);
begin
  { The radio buttons are flipped using BiDiMode }
end;

procedure TspSkinCustomRadioGroup.ArrangeButtons;
var
  ButtonsPerCol, ButtonWidth, ButtonHeight, TopMargin, I: Integer;
  DeferHandle: THandle;
  ALeft: Integer;
  ButtonsRect: TRect;
begin
  if (FButtons.Count <> 0) and not FReading then
  begin
    ButtonsRect := Rect(0, 0, Width, Height);
    AdjustClientRect(ButtonsRect);
    ButtonsPerCol := (FButtons.Count + FColumns - 1) div FColumns;
    ButtonWidth := RectWidth(ButtonsRect) div FColumns - 2;
    I := RectHeight(ButtonsRect);
    ButtonHeight := I div ButtonsPerCol;
    TopMargin := ButtonsRect.Top;
    DeferHandle := BeginDeferWindowPos(FButtons.Count);
    try
      for I := 0 to FButtons.Count - 1 do
        with TspGroupButton (FButtons[I]) do
        begin
          BiDiMode := Self.BiDiMode;
          ALeft := (I div ButtonsPerCol) * ButtonWidth + ButtonsRect.Left + 1;
          if UseRightToLeftAlignment then
            ALeft := RectWidth(ButtonsRect) - ALeft - ButtonWidth;
          DeferHandle := DeferWindowPos(DeferHandle, Handle, 0,
            ALeft,
            (I mod ButtonsPerCol) * ButtonHeight + TopMargin,
            ButtonWidth, ButtonHeight,
            SWP_NOZORDER or SWP_NOACTIVATE);
          Visible := True;
        end;
    finally
      EndDeferWindowPos(DeferHandle);
    end;
  end;
end;

procedure TspSkinCustomRadioGroup.ButtonClick(Sender: TObject);
begin
  if not FUpdating then
  begin
    FItemIndex := FButtons.IndexOf(Sender);
    Changed;
    Click;
  end;
end;

procedure TspSkinCustomRadioGroup.ItemsChange(Sender: TObject);
begin
  if not FReading then
  begin
    if FItemIndex >= FItems.Count then FItemIndex := FItems.Count - 1;
    UpdateButtons;
  end;
end;

procedure TspSkinCustomRadioGroup.Loaded;
begin
  inherited Loaded;
  ArrangeButtons;
end;

procedure TspSkinCustomRadioGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  inherited ReadState(Reader);
  FReading := False;
  UpdateButtons;
end;

procedure TspSkinCustomRadioGroup.SetButtonCount(Value: Integer);
var
  i: Integer;
begin
  while FButtons.Count < Value do TspGroupButton .InternalCreate(Self);
  while FButtons.Count > Value do TspGroupButton (FButtons.Last).Free;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspGroupButton (FButtons[I]) do
     begin
       ImageIndex := I;
       SkinData := Self.SkinData;
       SkinDataName := ButtonSkinDataName;
       DefaultFont.Assign(FButtonDefaultFont);
       UseSkinFont := Self.UseSkinFont;
     end;
end;

procedure TspSkinCustomRadioGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 16 then Value := 16;
  if FColumns <> Value then
  begin
    FColumns := Value;
    ArrangeButtons;
    Invalidate;
  end;
end;

procedure TspSkinCustomRadioGroup.SetItemIndex(Value: Integer);
begin
  if FReading then FItemIndex := Value else
  begin
    if Value < -1 then Value := -1;
    if Value >= FButtons.Count then Value := FButtons.Count - 1;
    if FItemIndex <> Value then
    begin
      if FItemIndex >= 0 then
        TspGroupButton (FButtons[FItemIndex]).Checked := False;
      FItemIndex := Value;
      if FItemIndex >= 0 then
        TspGroupButton (FButtons[FItemIndex]).Checked := True;
    end;
  end;
end;

procedure TspSkinCustomRadioGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TspSkinCustomRadioGroup.UpdateButtons;
var
  I: Integer;
begin
  SetButtonCount(FItems.Count);
  for I := 0 to FButtons.Count - 1 do
    TspGroupButton (FButtons[I]).Caption := FItems[I];
  if FItemIndex >= 0 then
  begin
    FUpdating := True;
    TspGroupButton (FButtons[FItemIndex]).Checked := True;
    FUpdating := False;
  end;
  ArrangeButtons;
  Invalidate;
end;

procedure TspSkinCustomRadioGroup.CMEnabledChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FButtons.Count - 1 do
    TspGroupButton(FButtons[I]).Enabled := Enabled;
end;

procedure TspSkinCustomRadioGroup.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ArrangeButtons;
end;

procedure TspSkinCustomRadioGroup.WMSize(var Message: TWMSize);
begin
  inherited;
  ArrangeButtons;
end;

function TspSkinCustomRadioGroup.CanModify: Boolean;
begin
  Result := True;
end;

procedure TspSkinCustomRadioGroup.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

constructor TspSkinCustomTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FExpandImage := TBitMap.Create;
  FNoExpandImage := TBitMap.Create;
  FThirdImages := 0;
  FThirdImageWidth := 0;
  FThirdImageHeight := 0;
  FThirdImagesCount := 0;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FButtonImageList := nil;
  FButtonNoExpandImageIndex := 0;
  FButtonExpandImageIndex := 1;
  FDrawSkin := False;
  FSD := nil;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FDefaultColor := clWindow;
  FSkinDataName := 'treeview';
  FItemSkinDataName  := 'listbox';
  FCheckSkinDataName  := 'checkbox';
  FInCheckScrollBars := False;
  FUseSkinFont := True;
  FButtonSize := 5;
end;

destructor TspSkinCustomTreeView.Destroy;
begin
  FDefaultFont.Free;
  FExpandImage.Free;
  FNoExpandImage.Free;
  inherited;
end;

procedure TspSkinCustomTreeView.SetButtonImageList(Value: TCustomImageList);
begin
  FButtonImageList := Value;
end;

procedure TspSkinCustomTreeView.DrawButton(ARect: TRect; Node: TTreeNode);

procedure DrawHorzAlphaLine(X1, X2, Y: Integer);
var
  B: TspBitMap;
  A, i, Step: Integer;
  DstP: PspColor;
begin
  if Abs(X2 - X1) = 0 then Exit;
  B := TspBitMap.Create;
  B.SetSize(Abs(X2 - X1), 1);
  with B.Canvas do
  begin
    Pen.Color := FLineColor;
    MoveTo(0, 0);
    LineTo(B.Width, 0);
  end;
  B.AlphaBlend := True;
  for i := 0 to B.Width - 1 do
  begin
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := 255;
  end;
  Step := Round (255 / (B.Width div 2));
  A := 255;
  for i := B.Width div 2 to B.Width - 1 do
  begin
    if A < 0 then A := 0;
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := A;
    Dec(A, Step);
  end;
  B.Draw(Canvas, X1, Y);
  B.Free;
end;


var
  cx, cy: Integer;
  FC: TColor;
  R: TRect;
begin
  if (FButtonImageList = nil)
  then
    begin
      if (not FExpandImage.Empty) and (not FNoExpandImage.Empty)
      then
        FButtonSize := FExpandImage.Width div 2 - 2
      else
        FButtonSize := 5;
    end  
  else
    begin
      if FButtonImageList.Width >= FButtonImageList.Height
      then
        FButtonSize := FButtonImageList.Width div 2
      else
        FButtonSize := FButtonImageList.Height div 2;
    end;
  cx := ARect.Left + Indent div 2;
  cy := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  with Canvas do
  begin
    Pen.Color := FLineColor;

    if ShowLines
    then
    if Node.HasChildren then
    begin
      begin
        DrawHorzAlphaLine(cx + FButtonSize - 1, ARect.Left + Indent + FButtonSize - 5, cy - 1);
      end;
    end
    else
      begin
        DrawHorzAlphaLine(cx - 1, ARect.Left + Indent, cy - 1);
      end;

    if ShowLines
    then
    if Node.AbsoluteIndex <> 0
    then
      begin
        MoveTo(cx - 1, cy - 1);
        LineTo(cx - 1, ARect.Top - 1);
      end;

    if ShowLines
    then
    if ((Node.GetNextVisible <> nil) and (Node.GetNextVisible.Level = Node.Level))
    or (Node.GetNextSibling <> nil) then
    begin
      MoveTo(cx - 1, cy);
      LineTo(cx - 1, ARect.Bottom + 1);
    end;

    if Node.HasChildren and (ButtonImageList = nil) and ShowButtons then
    begin
      Pen.Color := FButtonColor;
      Rectangle(cx - FButtonSize, cy - FButtonSize, cx + FButtonSize - 1, cy + FButtonSize - 1);
      Pen.Color := Self.Font.Color;
      PenPos := Point(cx - FButtonSize + 2, cy - 1);
      LineTo(cx + FButtonSize - 3, cy - 1);
      if not Node.Expanded then
      begin
        PenPos := Point(cx - 1, cy - FButtonSize + 2);
        LineTo(cx - 1, cy + FButtonSize - 3);
      end;
      Pen.Color := FLineColor;
    end;

    if Node.HasChildren and (ButtonImageList <> nil) and ShowButtons then
    begin
      Canvas.Brush.Color := Self.Color;
      R := Rect(cx - FButtonSize, cy - FButtonSize,
                cx + FButtonSize, cy + FButtonSize);
      Canvas.FillRect(R);
      if not Node.Expanded
      then
        begin
          if (ButtonNoExpandImageIndex >= 0) and
             (ButtonNoExpandImageIndex < ButtonImageList.Count)
          then
            ButtonImageList.Draw(Canvas, cx - FButtonSize, cy - FButtonSize,
              ButtonNoExpandImageIndex, True);
        end
      else
        begin
          if (ButtonExpandImageIndex >= 0) and
             (ButtonExpandImageIndex < ButtonImageList.Count)
          then
            ButtonImageList.Draw(Canvas, cx - FButtonSize, cy - FButtonSize,
              ButtonExpandImageIndex, True);
        end;
    end;

    if Node.HasChildren and (ButtonImageList = nil) and ShowButtons and
       (not FExpandImage.Empty) and (not FNoExpandImage.Empty)
    then
      begin
        Canvas.Brush.Color := Self.Color;
        R := Rect(cx - FButtonSize, cy - FButtonSize,
                  cx + FButtonSize, cy + FButtonSize);
        OffsetRect(R, -2, -2);          
        Canvas.FillRect(R);
        if not Node.Expanded
        then
          Canvas.Draw(cx - FButtonSize - 3, cy - FButtonSize - 3, FNoExpandImage)
        else
          Canvas.Draw(cx - FButtonSize - 3, cy - FButtonSize - 3, FExpandImage);
      end;

    Node := Node.Parent;
    if ShowLines
    then
    while Node <> nil do
    begin
      cx := cx - Indent;
      if Node.GetNextSibling <> nil then
      begin
        MoveTo(cx - 1, ARect.Top);
        LineTo(cx - 1, ARect.Bottom + 1);
      end;
      Node := Node.Parent;
    end;
  end;
end;

procedure TspSkinCustomTreeView.DrawImage(NodeRect: TRect; ImageIndex: Integer);
var
  cy: Integer;
begin
  //
  if Images = nil
  then
    begin
      FThirdImages := TreeView_GetImageList(Self.Handle, TVSIL_NORMAL);
      if FThirdImages <> 0
      then
        begin
          ImageList_GetIconSize(FThirdImages, FThirdImageWidth, FThirdImageHeight);
          FThirdImagesCount := ImageList_GetImageCount(FThirdImages);
          if (ImageIndex >= 0) and (ImageIndex < FThirdImagesCount)
          then
            begin
              cy := NodeRect.Top + (NodeRect.Bottom - NodeRect.Top) div 2;
              ImageList_DrawEx(FThirdImages, ImageIndex, Canvas.Handle,
              NodeRect.Left - FButtonSize,  cy - FThirdImageHeight div 2,
              FThirdImageWidth, FThirdImageHeight, CLR_NONE, CLR_NONE, ILD_NORMAL);
            end;
        end;
      Exit;
    end;
  //
  cy := NodeRect.Top + (NodeRect.Bottom - NodeRect.Top) div 2;
  if (Images <> nil) and (ImageIndex >= 0) and (ImageIndex < Images.Count)
  then
    begin
      Images.Draw(Canvas, NodeRect.Left - FButtonSize, cy - Images.Height div 2, ImageIndex, True);
    end;
end;

procedure TspSkinCustomTreeView.NewAdvancedCustomDrawItem;
var
  NodeRect, TempNodeRect, TextNodeRect: TRect;
  Picture, B: TBitMap;
  ListBoxData: TspDataSkinListBox;
  CIndex: Integer;
  SI: TScrollInfo;
begin
  //
  if (FSD = nil) or (FSD.Empty) then Exit;
  CIndex := SkinData.GetControlIndex(FItemSkinDataName);
  if CIndex = -1 then Exit;
  //
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Picture := TBitMap(FSD.FActivePictures.Items[ListBoxData.PictureIndex]);
  DefaultDraw := False;
  SI.cbSize := SizeOf(TScrollInfo);
  SI.fMask := SIF_ALL;
  GetScrollInfo(Handle, SB_HORZ, SI);
  //
  Canvas.Brush.Color := Self.Color;
  Treeview_GetItemRect(Handle, Node.ItemId, NodeRect, False);
  OffsetRect(NodeRect, -SI.nPos, 0);
  Canvas.FillRect(NodeRect);
  Treeview_GetItemRect(Handle, Node.ItemId, TempNodeRect, True);
  Canvas.FillRect(TempNodeRect);
  with Canvas do
  begin
    Brush.Style := bsClear;
    if ShowRoot
    then
      NodeRect.Left := NodeRect.Left + (Node.Level  * Indent)
    else
      NodeRect.Left := NodeRect.Left + ((Node.Level - 1) * Indent);
    DrawButton(NodeRect, Node);
    //
    NodeRect.Left := NodeRect.Left + Indent + FButtonSize;
    DrawImage(NodeRect, Node.ImageIndex);
    if Images <> nil
    then
      NodeRect.Left := NodeRect.Left + Images.Width
    else
      begin
        if FThirdImages <> 0
        then
          NodeRect.Left := NodeRect.Left + FThirdImageWidth;
      end;
    //
    if not (cdsSelected in State)
    then
      begin
        Treeview_GetItemRect(Self.Handle, Node.ItemId, TempNodeRect, True);
        Inc(TempNodeRect.Top);
        SPDrawText(Canvas, Node.Text, Rect(TempNodeRect.Left + 2,TempNodeRect.Top,
        TempNodeRect.Right, TempNodeRect.Bottom));
      end
    else
      begin
        Treeview_GetItemRect(Self.Handle, Node.ItemId, TempNodeRect, True);
        if RectWidth(TempNodeRect) > 0 then begin
        B := TBitmap.Create;
        B.Width := RectWidth(TempNodeRect);
        B.Height := RectHeight(TempNodeRect);
        //
        with ListBoxData do
        if Focused
        then
          CreateStretchImage(B, Picture, FocusItemRect, ItemTextRect, True)
        else
          CreateStretchImage(B, Picture, ActiveItemRect, ItemTextRect, True);
        // draw text
        B.Canvas.Font.Assign(Self.Font);
        if Focused
        then
          B.Canvas.Font.Color := ListBoxData.FocusFontColor
        else
          B.Canvas.Font.Color := ListBoxData.ActiveFontColor;
        B.Canvas.Brush.Style := bsClear;
        SPDrawText(B.Canvas, Node.Text, Rect(2, 1, B.Width, B.Height));
        Canvas.Draw(TempNodeRect.Left, TempNodeRect.Top, B);
        B.Free;
        end;
      end;
  end;
end;

procedure TspSkinCustomTreeView.SetDrawSkin;
begin
  FDrawSkin := Value;
  if FDrawSkin and not (csDesigning in ComponentState)
  then
     OnAdvancedCustomDrawItem := NewAdvancedCustomDrawItem;
end;

procedure TspSkinCustomTreeView.CMSENCPaint(var Message: TMessage); 
begin
  Message.Result := SE_RESULT;
end;

procedure TspSkinCustomTreeView.CMVisibleChanged;
begin
  inherited;
  if FVScrollBar <> nil then FVScrollBar.Visible := Self.Visible;
  if FHScrollBar <> nil then FHScrollBar.Visible := Self.Visible;
end;

procedure TspSkinCustomTreeView.Loaded;
begin
  inherited;
  ChangeSkinData;
end;

procedure TspSkinCustomTreeView.SetDefaultColor;
begin
  FDefaultColor := Value;
  if FIndex = -1 then Color := Value;
end;

procedure TspSkinCustomTreeView.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex =  -1 then Font.Assign(Value);
end;

procedure TspSkinCustomTreeView.ChangeSkinData;
var
  Picture: TBitmap;
begin
  if (csLoading in ComponentState) then Exit;
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);

  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is
         TspDataSkinTreeView
      then
        with TspDataSkinTreeView(FSD.CtrlList.Items[FIndex]) do
        begin
          if FUseSkinFont
          then
            begin
              Font.Name := FontName;
              Font.Style := FontStyle;
              Font.Height := FontHeight;
            end
          else
            Font.Assign(FDefaultFont);
            Font.Color := FontColor;
            Color := BGColor;
          FLineColor := MiddleColor(FontColor, BGColor);
          FLineColor := MiddleColor(FLineColor, BGColor);
          FButtonColor := MiddleColor(FontColor, BGColor);
          //
          if not IsNullRect(ExpandImageRect) and not IsNullRect(NoExpandImageRect) and
             (PictureIndex <> -1)
          then
            begin
              Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex]);
              //
              FExpandImage.Width := RectWidth(ExpandImageRect);
              FExpandImage.Height := RectWidth(ExpandImageRect);
              FExpandImage.Canvas.CopyRect(Rect(0, 0, FExpandImage.Width, FExpandImage.Height),
                Picture.Canvas, ExpandImageRect);
              FExpandImage.Transparent := True;
              //
              FNoExpandImage.Width := RectWidth(NoExpandImageRect);
              FNoExpandImage.Height := RectWidth(NoExpandImageRect);
              FNoExpandImage.Canvas.CopyRect(Rect(0, 0, FNoExpandImage.Width, FNoExpandImage.Height),
                Picture.Canvas, NoExpandImageRect);
              FNoExpandImage.Transparent := True;
            end
          else
            begin
              FExpandImage.Assign(nil);
              FNoExpandImage.Assign(nil);
            end;
          //
        end;
    end
  else
    begin
      Color := FDefaultColor;
      Font.Assign(FDefaultFont);
      FLineColor := clGray;
    end;

   if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
   then
     Font.Charset := SkinData.ResourceStrData.CharSet
   else
     Font.Charset := FDefaultFont.Charset;

  if Images <> nil then Images.BkColor := Self.Color;
  if StateImages <> nil then StateImages.BkColor := Self.Color;
  UpDateScrollBars;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
  if FHScrollBar <> nil then FHScrollBar.Align := FHScrollBar.Align;
end;


procedure TspSkinCustomTreeView.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinCustomTreeView.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FVScrollBar)
  then FVScrollBar := nil;
  if (Operation = opRemove) and (AComponent = FHScrollBar)
  then FHScrollBar := nil;
  if (Operation = opRemove) and (AComponent = FButtonImageList)
  then FButtonImageList := nil;
end;

procedure TspSkinCustomTreeView.Change;
begin
  inherited;
  UpDateScrollBars;
end;

procedure TspSkinCustomTreeView.WMNCCALCSIZE;
begin
end;

procedure TspSkinCustomTreeView.WMNCHITTEST(var Message: TWMNCHITTEST);
begin
  Message.Result := HTCLIENT;
end;

procedure TspSkinCustomTreeView.WMNCPAINT;
begin
end;

procedure TspSkinCustomTreeView.SetVScrollBar;
begin
  FVScrollBar := Value;
  if FVScrollBar <> nil
  then
    with FVScrollBar do
    begin
      Enabled := True;
      Visible := False;
      OnChange := OnVScrollBarChange;
    end;
  UpDateScrollBars;
end;

procedure TspSkinCustomTreeView.SetHScrollBar;
begin
  FHScrollBar := Value;
  if FHScrollBar <> nil
  then
    with FHScrollBar do
    begin
      Enabled := True;
      Visible := False;
      OnChange := OnHScrollBarChange;
    end;
  UpDateScrollBars;
end;

procedure TspSkinCustomTreeView.WndProc;
begin
  inherited;
  case Message.Msg of
    WM_SIZE, WM_PAINT:
      if not FInCheckScrollBars then UpDateScrollBars;
    WM_KEYDOWN, WM_LBUTTONUP:
       UpDateScrollBars;
  end;
end;

procedure TspSkinCustomTreeView.UpDateScrollBars;
var
  Min, Max, Pos, Page: Integer;
  R: TRect;
  OldVisible, HVisibleChanged, VVisibleChanged: Boolean;
begin
  if (csLoading in ComponentState) or FInCheckScrollBars then Exit;
  VVisibleChanged := False;
  HVisibleChanged := False;
  if FVScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_VERT, Min, Max);
      Pos := GetScrollPos(Handle, SB_VERT);
      Page := TreeView_GetVisibleCount(Handle);
      FInCheckScrollBars := True;
      OldVisible := FVScrollBar.Visible;
      FVScrollBar.Visible := (Max > 0) and (Max >= Page) and
                   (Max < treeview_GetCount(Handle)) and Self.Visible;
      VVisibleChanged := FVScrollBar.Visible <> OldVisible;
      FInCheckScrollBars := False;
      if FVScrollBar.Visible
      then
         FVScrollBar.SetRange(Min, Max, Pos, Page);
    end;

  if FHScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(Handle, SB_HORZ);
      FInCheckScrollBars := True;
      OldVisible := FHScrollBar.Visible;
      FHScrollBar.Visible := (Max > Width) and Self.Visible;
      HVisibleChanged := FHScrollBar.Visible <> OldVisible;
      FInCheckScrollBars := False;
      if FHScrollBar.Visible
      then
        FHScrollBar.SetRange(Min, Max, Pos, Width);
    end;

  if (FVScrollBar <> nil) and (FHScrollBar <> nil)
  then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if (Self.Align <> alNone) and (HVisibleChanged or VVisibleChanged)
  then
    begin
      FInCheckScrollBars := True;
      R := Parent.ClientRect;
      TParentControl(Parent).AlignControls(nil, R);
      FInCheckScrollBars := False;
    end;
end;

procedure TspSkinCustomTreeView.OnVScrollBarChange;
var
  info: TScrollInfo;
begin
 if (Win32MajorVersion >= 6) then
 begin
  FillChar(info, SizeOf(info), 0);
  with info do
  begin
   cbsize := SizeOf(info);
   fmask  := SIF_ALL;
   GetScrollInfo(Handle, SB_VERT, info);
   nPage := 0;
   fmask  := SIF_POS;
   nPos  := FVSCROLLBAR.Position;
  end;
  SetScrollInfo(Handle, SB_VERT, info, True);
 end;
 SendMessage(Handle, WM_VSCROLL,
   MakeWParam(SB_THUMBPOSITION, FVSCROLLBAR.Position), 0);
end;

procedure TspSkinCustomTreeView.OnHScrollBarChange;
begin
  SendMessage(Handle, WM_HSCROLL,
    MakeWParam(SB_THUMBPOSITION, FHSCROLLBAR.Position), 0);
end;

procedure TspSkinCustomTreeView.CreateParams;
begin
  inherited;
  with Params do
    Style := Style and not (WS_HSCROLL or WS_VSCROLL);
end;


constructor TspSkinCustomListView.Create(AOwner: TComponent);
begin
  inherited;
  FHeaderSkinDataName := 'resizetoolbutton';
  FItemSkinDataName  := 'listbox';
  FCheckSkinDataName  := 'checkbox';
  FThirdImages := 0;
  FThirdImageWidth := 0;
  FThirdImageHeight := 0;
  FThirdImagesCount := 0;
  FDrawSkin := False;
  FDrawSkinLines := False;
  FDevDown := False;
  FHIndex := -1;
  FHeaderHandle := 0;
  FHeaderInstance := MakeObjectInstance(HeaderWndProc);
  FDefHeaderProc := nil;
  FInCheckScrollBars := False;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FOldVScrollBarPos := 0;
  FOldHScrollBarPos := 0;
  FSD := nil;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  Font.Assign(FDefaultFont);
  FDefaultColor := clWindow;
  FUseSkinFont := True;
  FDefaultColor := clWindow;
  FSkinDataName := 'listview';
end;

destructor TspSkinCustomListView.Destroy;
begin
  FDefaultFont.Free;
  if FHeaderHandle <> 0 then
    SetWindowLong(FHeaderHandle, GWL_WNDPROC, LongInt(FDefHeaderProc));
  FreeObjectInstance(FHeaderInstance);
  FHeaderHandle := 0;
  inherited;
end;

procedure TspSkinCustomListView.NewCustomDrawItem(Sender: TCustomListView;
     Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

var
  SelectBounds, TextBounds, IconBounds, ItemBounds, R, CR: TRect;
  B, Buffer: TBitmap;
  ListBoxData: TspDataSkinListBox;
  CheckBoxData: TspDataSkinCheckRadioControl;
  CIndex, CX, CY, i: Integer;
  Picture: TBitmap;
  S: String;
  w1, w2: Integer;
  IL: TCustomImageList;
begin
  //
  if (csDesigning in ComponentState) or (FSD = nil) or FSD.Empty
  then
    begin
      Exit;
    end;
  //
  if (SmallImages = nil) and (LargeImages = nil)
  then
    begin
      if ViewStyle = vsIcon
      then
        FThirdImages := ListView_GetImageList(Self.Handle, LVSIL_NORMAL)
      else
        FThirdImages := ListView_GetImageList(Self.Handle, LVSIL_SMALL);
      if FThirdImages <> 0
      then
        begin
          ImageList_GetIconSize(FThirdImages, FThirdImageWidth, FThirdImageHeight);
          FThirdImagesCount := ImageList_GetImageCount(FThirdImages);
        end;
    end;
  //
  CIndex := SkinData.GetControlIndex(FItemSkinDataName);
  if CIndex = -1 then Exit;
  DefaultDraw := False;
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Picture := TBitMap(FSD.FActivePictures.Items[ListBoxData.PictureIndex]);
  if (ViewStyle <> vsList)
  then
    TextBounds :=  Item.DisplayRect(drLabel)
  else
    begin
      TextBounds :=  Item.DisplayRect(drLabel);
      R := Rect(0, 0, 0, 0);
      DrawText(Canvas.Handle, PChar(Item.Caption), Length(Item.Caption), R,
        DT_CALCRECT or DT_LEFT);
      TextBounds.Right := TextBounds.Left + RectWidth(R) + 2;
    end;

  IconBounds := Item.DisplayRect(drIcon);
  if ViewStyle = vsIcon
  then
    begin
      OffsetRect(TextBounds, 2, 0);
      IL := LargeImages;
    end
  else
    IL := SmallImages;
  ItemBounds := Item.DisplayRect(drBounds);
  //
  if (ViewStyle = vsIcon)
  then
    SelectBounds := Item.DisplayRect(drLabel)
  else
    begin
      SelectBounds := Item.DisplayRect(drSelectBounds);
      if (ViewStyle = vsList)
      then
        begin
          SelectBounds := TextBounds;
          if Item.Caption = ''
          then
            Inc(SelectBounds.Right, 20)
          else
            Inc(SelectBounds.Right, 4);
        end
      else
        SelectBounds.Left := TextBounds.Left;
    end;
  Dec(SelectBounds.Bottom); 
  //
  CheckBoxData := nil;
  CIndex := SkinData.GetControlIndex(FCheckSkinDataName);
  if CIndex <> -1
  then
    CheckBoxData := TspDataSkinCheckRadioControl(SkinData.CtrlList[CIndex]);
  //
  if (Item.Selected) and (RectWidth(SelectBounds) > 0)
  then
    begin
      B := TBitmap.Create;
      B.Width := RectWidth(SelectBounds);
      B.Height := RectHeight(SelectBounds);
      with ListBoxData do
      if Focused
      then
        CreateStretchImage(B, Picture, FocusItemRect, ItemTextRect, True)
      else
        CreateStretchImage(B, Picture, ActiveItemRect, ItemTextRect, True);
      R := TextBounds;
      OffsetRect(R, -SelectBounds.Left, -SelectBounds.Top);
      B.Canvas.Font.Assign(Self.Font);
      if Self.Focused
      then
        B.Canvas.Font.Color := ListBoxData.FocusFontColor
      else
        B.Canvas.Font.Color := ListBoxData.ActiveFontColor;
      B.Canvas.Brush.Style := bsClear;
      S := Item.Caption;
      if ViewStyle = vsList
      then
        CorrectTextbyWidth(Canvas, S, RectWidth(TextBounds))
      else
      if ViewStyle = vsReport
      then
        CorrectTextbyWidth(Canvas, S, RectWidth(TextBounds) - 3)
      else
        CorrectTextbyWidth(Canvas, S, RectWidth(TextBounds) - 2);
      if IconOptions.WrapText and (ViewStyle = vsIcon)
      then
        begin
          Dec(R.Right, 4);
          SPDrawTextCenterMultiLine(B.Canvas, Item.Caption, R, True);
        end
      else
        begin
          if ViewStyle = vsReport then Inc(R.Left, 3) else Inc(R.Left, 2);
          SPDrawText(B.Canvas, S, R);
        end;
      //
     if (ViewStyle = vsReport) and (Item.SubItems.Count > 0) and RowSelect
      then
        begin
          w2 := ListView_GetColumnWidth(Handle, 0);
          for i := 0 to Item.SubItems.Count - 1 do
          if Columns.Count > i + 1 then
          begin
            w1 := ListView_GetColumnWidth(Handle, i + 1);
            R := Rect(ItemBounds.Left + w2,
              0, ItemBounds.Left + w1 + w2, B.Height);
            OffsetRect(R, -SelectBounds.Left, 0);
            Inc(R.Left, 3);
            Dec(R.Right, 3);
            if Assigned(FOnDrawSkinSubItem)
            then
              begin
                FOnDrawSkinSubItem(Self, Item, i, State, B.Canvas, R);
              end
            else
            begin
              // draw icon
              if (SmallImages <> nil) and (Item.SubItemImages[i] >= 0) and
                 (Item.SubItemImages[i] < SmallImages.Count)
              then
                begin
                  SmallImages.Draw(B.Canvas, R.Left, R.Top, Item.SubItemImages[i], True);
                  Inc(R.Left, SmallImages.Width + 3);
                end;
               //
               S := Item.SubItems[i];
               CorrectTextbyWidth(B.Canvas, S, RectWidth(R));
               B.Canvas.Brush.Style := bsClear;
               //
               if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Inc(R.Top, 1);
               //
               SPDrawTextAlignment(B.Canvas, S, R, Columns[i + 1].Alignment);
             end;
             w2 := w2 + w1;
           end;
         end;
      //
      Canvas.Draw(SelectBounds.Left, SelectBounds.Top, B);
      B.Free;
    end
   else
     begin
       R := ItemBounds;
       Dec(R.Bottom);
       Canvas.FillRect(R);
       S := Item.Caption;
       if ViewStyle = vsReport
       then
         CorrectTextbyWidth(Canvas, S, RectWidth(TextBounds) - 3)
       else
         CorrectTextbyWidth(Canvas, S, RectWidth(TextBounds) - 2);
       if IconOptions.WrapText and (ViewStyle = vsIcon)
       then
         begin
           R := TextBounds;
           Dec(R.Right, 4);
           SPDrawTextCenterMultiLine(Canvas, Item.Caption, R, False);
         end  
       else
         begin
           R := TextBounds;
           if ViewStyle = vsReport then Inc(R.Left, 3) else Inc(R.Left, 2);
           SPDrawText(Canvas, S, R);
         end;
     end;  
   // draw icon
   if FThirdImages <> 0
   then
     begin
       if ViewStyle = vsIcon
       then
         begin
           CX := IconBounds.Left + RectWidth(IconBounds) div 2 - FThirdImageWidth div 2;
           CY := IconBounds.Top + 2;
           Canvas.FillRect(Rect(CX, CY, CX + FThirdImageWidth, CY + FThirdImageHeight));
           ImageList_DrawEx(FThirdImages, Item.ImageIndex, Canvas.Handle,
              CX,  CY,
              FThirdImageWidth, FThirdImageHeight, CLR_NONE, CLR_NONE, ILD_NORMAL);
           if CheckBoxes
           then
             IconBounds.Left := CX;
         end
       else
         begin
           Canvas.FillRect(Rect(IconBounds.Left, IconBounds.Top,
           IconBounds.Left + FThirdImageWidth, IconBounds.Top + FThirdImageHeight));
           ImageList_DrawEx(FThirdImages, Item.ImageIndex, Canvas.Handle,
             IconBounds.Left, IconBounds.Top,
              FThirdImageWidth, FThirdImageHeight, CLR_NONE, CLR_NONE, ILD_NORMAL);
         end;     
     end
   else
   if (IL <> nil) and (Item.ImageIndex >= 0) and
      (Item.ImageIndex < IL.Count)
   then
     begin
       if ViewStyle = vsIcon
       then
         begin
           CX := IconBounds.Left + RectWidth(IconBounds) div 2 - IL.Width div 2;
           CY := IconBounds.Top + 2;
           IL.Draw(Canvas, CX, CY, Item.ImageIndex, True);
           if CheckBoxes
           then
             IconBounds.Left := CX;
         end
       else
         IL.Draw(Canvas, IconBounds.Left, IconBounds.Top, Item.ImageIndex, True);
     end;
    // draw check
    if Checkboxes and (CheckBoxData <> nil)
    then
      begin
        Buffer := TBitmap.Create;
        if Item.Checked
        then
          CR := CheckBoxData.CheckImageRect
        else
          CR := CheckBoxData.UnCheckImageRect;
        Picture := TBitMap(FSD.FActivePictures.Items[CheckBoxData.PictureIndex]);
        Buffer.Width := RectWidth(CR);
        Buffer.Height:= RectHeight(CR);
        CX := IconBounds.Left - Buffer.Width - 1;
        if ViewStyle = vsIcon
        then
          CY := IconBounds.Bottom - RectHeight(CR) - 1
        else
          CY := ItemBounds.Top + RectHeight(IconBounds) div 2 - Buffer.Height div 2 - 1;
        if CY < ItemBounds.Top then CY := ItemBounds.Top;
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Picture.Canvas, CR);
        Buffer.Transparent := True;
        Canvas.Draw(CX, CY, Buffer);
        Buffer.Free;
      end;
  //
  if (ViewStyle = vsReport) and (Item.SubItems.Count > 0) and (not Item.Selected or not RowSelect)
  then
    begin
      w2 := ListView_GetColumnWidth(Handle, 0);
      for i := 0 to Item.SubItems.Count -1 do
      if Columns.Count > i + 1
      then
      begin
        w1 := ListView_GetColumnWidth(Handle, i + 1);
        R := Rect(ItemBounds.Left + w2,
              ItemBounds.Top, ItemBounds.Left + w1 + w2, ItemBounds.Bottom);
        CR := R;
        Canvas.FillRect(R);
        Inc(R.Left, 3);
        Dec(R.Right, 3);
        if Assigned(FOnDrawSkinSubItem)
         then
           begin
             FOnDrawSkinSubItem(Self, Item, i, State, Canvas, R);
           end
         else
         begin
          // draw icon
          if (SmallImages <> nil) and (Item.SubItemImages[i] >= 0) and
            (Item.SubItemImages[i] < SmallImages.Count)
          then
            begin
              SmallImages.Draw(Canvas, R.Left, R.Top, Item.SubItemImages[i], True);
              Inc(R.Left, SmallImages.Width + 3);
            end;
          //
          S := Item.SubItems[i];
          CorrectTextbyWidth(Canvas, S, RectWidth(R));
          SPDrawTextAlignment(Canvas, S, R, Columns[i + 1].Alignment);
        end;  
        w2 := w2 + w1;
      end;
     end;

   w2 := 0;

   if (ViewStyle = vsReport) and (Columns.Count > 0) and FDrawSkinLines
   then
     for i := 0 to Columns.Count - 1 do
     begin
       w1 := ListView_GetColumnWidth(Handle, i);
       Canvas.Pen.Color := FLineColor;
       Canvas.MoveTo(ItemBounds.Left + w1 + w2, ItemBounds.Top);
       Canvas.LineTo(ItemBounds.Left + w1 + w2, ItemBounds.Bottom);
       w2 := w2 + w1;
     end;

   if (ViewStyle = vsReport) and FDrawSkinLines
   then
     begin
       R := ItemBounds;
       R.Right := Width;
       Dec(R.Bottom);
       Canvas.Pen.Color := FLineColor;
       Canvas.MoveTo(R.Left, R.Bottom);
       Canvas.LineTo(R.Right, R.Bottom);
       if Item.Index = 0
       then
         begin
           Canvas.MoveTo(R.Left, R.Top - 1);
           Canvas.LineTo(R.Right, R.Top - 1);
         end;
     end;
end;

procedure TspSkinCustomListView.SetDrawSkin(Value: Boolean);
begin
  FDrawSkin := Value;
  if FDrawSkin and not (csDesigning in ComponentState)
  then
    begin
      OnCustomDrawItem := NewCustomDrawItem;
      FullDrag := False;
    end;
end;

procedure TspSkinCustomListView.SetDrawSkinLines(Value: Boolean);
begin
  FDrawSkinLines := Value;
  if FDrawSkinLines and (csDesigning in ComponentState) 
  then
    GridLines := False;
end;

procedure TspSkinCustomListView.Change(Item: TListItem; Change: Integer);
begin
  inherited;
  if not FInCheckScrollBars then UpdateScrollBars;
end;

procedure TspSkinCustomListView.CMSENCPaint(var Message: TMessage);
begin
  Message.Result := SE_RESULT;
end;

procedure TspSkinCustomListView.CMSEPaint(var Message: TMessage);
begin
  if FHeaderHandle <> 0 then PaintHeader(Message.WParam);
end;

procedure TspSkinCustomListView.HGetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FHIndex := -1
  else
    FHIndex := FSD.GetControlIndex(FHeaderSkinDataName);
  if FHIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FHIndex]) is TspDataSkinButtonControl
    then
      with TspDataSkinButtonControl(FSD.CtrlList.Items[FHIndex]) do
      begin
        HLTPt := LTPoint;
        HRTPt := RTPoint;
        HLBPt := LBPoint;
        HRBPt := RBPoint;
        HSkinRect := SkinRect;
        HClRect := ClRect;
        HStretchEffect := StretchEffect;
        HLeftStretch := LeftStretch;
        HTopStretch := TopStretch;
        HRightStretch := RightStretch;
        HBottomStretch := BottomStretch;
        HStretchType := StretchType;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          HPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          HPicture := nil;

        //
        HFontColor := FontColor;
        HActiveFontColor := ActiveFontColor;
        HDownFontColor := DownFontColor;
        HActiveSkinRect := ActiveSkinRect;
        HDownSkinRect := DownSkinRect;
        if IsNullRect(HActiveSkinRect) then HActiveSkinRect := SkinRect;
        if IsNullRect(HDownSkinRect) then HDownSkinRect := HActiveSkinRect;
      end
    else
      HPicture := nil;
end;

procedure TspSkinCustomListView.CreateWnd;
begin
  inherited;
end;

procedure TspSkinCustomListView.DrawHeaderSection;
var
  SR, BR, DR: TRect;
  S: String;
  B, B1: TBitMap;
  W, H, TX, TY, GX, GY, XO, YO: Integer;
begin
  if (RectWidth(R) <= 0) or (RectHeight(R) <= 0) then Exit;
  S := Column.Caption;
  B := TBitMap.Create;
  W := RectWidth(R);
  H := RectHeight(R);
  B.Width := W;
  B.Height := H;
  BR := Rect(0, 0, B.Width, B.Height);
  HGetSkinData;
  if FHIndex = -1
  then
  with B.Canvas do
  begin
    //
    if Pressed
    then
      begin
        Frame3D(B.Canvas, BR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNDOWNCOLOR;
      end
    else
    if Active
    then
      begin
        Frame3D(B.Canvas, BR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNACTIVECOLOR;
      end
    else
      begin
        Frame3D(B.Canvas, BR, clBtnShadow, clBtnShadow, 1);
        Brush.Color := clBtnFace;
      end;
    //
    FillRect(BR);
    Brush.Style := bsClear;
    Font := Self.Font;
    Font.Color := clBtnText;
  end
  else
  with B.Canvas do
  begin
    Font := Self.Font;
    if Pressed
    then
       begin
         SR := HDownSkinRect;
         Font.Color := HDownFontColor;
       end
     else
       begin
         SR := HSkinRect;
         Font.Color := HFontColor;
       end;
      //
      XO := RectWidth(BR) - RectWidth(HSkinRect);
      YO := RectHeight(BR) - RectHeight(HSkinRect);

      if (HLBPt.X = 0) and (HLBPt.Y = 0)
      then
        begin
          B1 := TBitMap.Create;
          B1.Width := RectWidth(R);
          B1.Height := RectHeight(HSkinRect);
          CreateHSkinImage(HLTPt.X, RectWidth(SR) - HRTPt.X,
            B1, HPicture, SR, B1.Width, B1.Height, HStretchEffect);
          DR := Rect(0, 0, B.Width, B.Height);
          B.Canvas.StretchDraw(DR, B1);
          B1.Free;
        end
      else
        begin
          HNewLTPoint := HLTPt;
          HNewRTPoint := Point(HRTPt.X + XO, HRTPt.Y);
          HNewLBPoint := Point(HLBPt.X, HLBPt.Y + YO);
          HNewRBPoint := Point(HRBPt.X + XO, HRBPt.Y + YO);
          HNewClRect := Rect(HCLRect.Left, HClRect.Top,
          HCLRect.Right + XO, HClRect.Bottom + YO);
          CreateSkinImage(HLTPt, HRTPt, HLBPt, HRBPt, hCLRect,
            HNewLtPoint, HNewRTPoint, HNewLBPoint, HNewRBPoint, HNewCLRect,
            B, HPicture, SR, B.Width, B.Height, True,
            HLeftStretch, HTopStretch, HRightStretch, HBottomStretch,
            HStretchEffect, HStretchType);
        end;
  end;

  if Assigned(FOnDrawHeaderSection)
  then
    FOnDrawHeaderSection(B.Canvas, Column, Pressed, Rect(0, 0, B.Width, B.Height))
  else
  with B.Canvas do
  begin
    Brush.Style := bsClear;
    Inc(BR.Left, 5); Dec(BR.Right, 5);
    if (SmallImages <> nil) and (Column.ImageIndex >= 0) and
        (Column.ImageIndex < SmallImages.Count)
    then
      begin
        CorrectTextbyWidth(B.Canvas, S, RectWidth(BR) - 10 - SmallImages.Width);
        GX := BR.Left;
        if S = Column.Caption then
         case Column.Alignment of
           taRightJustify: GX := BR.Right - TextWidth(S) - SmallImages.Width - 10;
           taCenter: GX := BR.Left + RectWidth(BR) div 2 -
                     (TextWidth(S) + SmallImages.Width + 10) div 2;
         end;
        TX := GX + SmallImages.Width + 10;
        TY := BR.Top + RectHeight(BR) div 2 - TextHeight(S) div 2;
        GY := BR.Top + RectHeight(BR) div 2 - SmallImages.Height div 2;
        SmallImages.Draw(B.Canvas, GX, GY, Column.ImageIndex, True);
      end
     else
       begin
         CorrectTextbyWidth(B.Canvas, S, RectWidth(BR));
         TX := BR.Left;
         TY := BR.Top + RectHeight(BR) div 2 - TextHeight(S) div 2;
         case Column.Alignment of
           taRightJustify: TX := BR.Right - TextWidth(S);
           taCenter: TX := BR.Left + RectWidth(BR) div 2 - TextWidth(S) div 2;
         end;
       end;
    //
    if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(TY, 1);
    //
    TextRect(BR, TX, TY, S);
  end;
  Cnvs.Draw(R.Left, R.Top, B);
  B.Free;
end;

function TspSkinCustomListView.GetHeaderSectionRect(Index: Integer): TRect;
var
  SectionOrder: array of Integer;
  R: TRect;
begin
  if Self.FullDrag
  then
    begin
      SetLength(SectionOrder, Columns.Count);
      Header_GetOrderArray(FHeaderHandle, Columns.Count, PInteger(SectionOrder));
      Header_GETITEMRECT(FHeaderHandle, SectionOrder[Index] , @R);
    end
  else
    Header_GETITEMRECT(FHeaderHandle, Index, @R);
  Result := R;
end;

procedure TspSkinCustomListView.PaintHeader;

var
  Cnvs: TControlCanvas;
  i, RightOffset, Xo, YO: Integer;
  DR, R, BGR, HR: TRect;
  PS: TPaintStruct;
  B, B1: TBitMap;
begin
  if DC = 0 then DC := BeginPaint(FHeaderHandle, PS);
  try
    Cnvs := TControlCanvas.Create;
    Cnvs.Handle := DC;
    RightOffset := 0;
    with Cnvs do
    begin
      for i := 0 to Header_GetItemCount(FHeaderHandle) - 1 do
      begin
        R := GetHeaderSectionRect(i);
        DrawHeaderSection(Cnvs, Columns[i], False, (FActiveSection = I) and FHeaderDown, R);
        if RightOffset < R.Right then RightOffset := R.Right;
      end;
    end;
    Windows.GetWindowRect(FHeaderHandle, HR);
    BGR := Rect(RightOffset, 0, RectWidth(HR) + 1, RectHeight(HR));
    HGetSkinData;
    if BGR.Left < BGR.Right then
    if FhIndex = -1
    then
      with Cnvs do
      begin
        Brush.Color := clBtnFace;
        Fillrect(BGR);
        Frame3D(Cnvs, BGR, clBtnShadow, clBtnShadow, 1);
      end
    else
      begin
        //
        B := TBitMap.Create;
        B.Width := RectWidth(BGR);
        B.Height := RectHeight(BGR);
        XO := RectWidth(BGR) - RectWidth(HSkinRect);
        YO := RectHeight(BGR) - RectHeight(HSkinRect);
        if (HLBPt.X = 0) and (HLBPt.Y = 0)
        then
          begin
            B1 := TBitMap.Create;
            B1.Width := RectWidth(BGR);
            B1.Height := RectHeight(HSkinRect);
            CreateHSkinImage2(HLtPt.X, RectWidth(HSkinRect) - HRTPt.X,
              B1, HPicture, HSkinRect, B1.Width, B1.Height, HStretchEffect);
            DR := Rect(0, 0, B.Width, B.Height);
            B.Canvas.StretchDraw(DR, B1);
            B1.Free;
          end
        else
          begin
            HNewLTPoint := HLTPt;
            HNewRTPoint := Point(HRTPt.X + XO, HRTPt.Y);
            HNewLBPoint := Point(HLBPt.X, HLBPt.Y + YO);
            HNewRBPoint := Point(HRBPt.X + XO, HRBPt.Y + YO);
            HNewClRect := Rect(HCLRect.Left, HClRect.Top,
            HCLRect.Right + XO, HClRect.Bottom + YO);
            CreateSkinImage2(HLTPt, HRTPt, HLBPt, HRBPt, HCLRect,
              HNewLtPoint, HNewRTPoint, HNewLBPoint, HNewRBPoint, HNewCLRect,
              B, HPicture, HSkinRect, B.Width, B.Height, True,
              HLeftStretch, HTopStretch, HRightStretch, HBottomStretch,
              HStretchEffect, HStretchType);
          end;
        Cnvs.Draw(BGR.Left, BGR.Top, B);
        B.Free;
      end;
    Cnvs.Handle := 0;
    Cnvs.Free;
  finally
    if DC = 0
    then
      EndPaint(FHeaderHandle, PS)
    else
      ReleaseDC(FHeaderHandle, DC);
  end;
  //
end;

procedure TspSkinCustomListView.HeaderWndProc(var Message: TMessage);
var
  X, Y: Integer;

function GetSectionFromPoint(P: TPoint): Integer;
var
  i: Integer;
  R: TRect;
begin
  FActiveSection := -1;
  for i := 0 to Columns.Count - 1 do
  begin
    R := GetHeaderSectionRect(i);
    if PtInRect(R, Point(X, Y))
    then
      begin
        FActiveSection := i;
        Break;
      end;
  end;
end;

var
  Info: THDHitTestInfo;
begin
  if Message.Msg  = WM_WINDOWPOSCHANGING
  then
    begin
      TWMWINDOWPOSCHANGING(Message).WindowPos.cx := TWMWINDOWPOSCHANGING(Message).WindowPos.cx + 25;
    end
  else
  if Message.Msg  = WM_PAINT
  then
    begin
      PaintHeader(TWMPAINT(MESSAGE).DC);
    end
  else
  if Message.Msg  = WM_ERASEBKGND
  then
    begin
      Message.Result := 1;
    end
  else
    Message.Result := CallWindowProc(FDefHeaderProc, FHeaderHandle,
      Message.Msg, Message.WParam, Message.LParam);
  case Message.Msg of
    WM_MOUSEMOVE:
      begin
        if FDevDown
        then
          RedrawWindow(FHeaderHandle, 0, 0, RDW_INVALIDATE);
      end;
    WM_LBUTTONDOWN:
      begin
        X := TWMLBUTTONDOWN(Message).XPos;
        Y := TWMLBUTTONDOWN(Message).YPos;
        GetSectionFromPoint(Point(X, Y));
        //
        Info.Point.X := X;
        Info.Point.Y := Y;
        SendMessage(FHeaderHandle, HDM_HITTEST, 0, Integer(@Info));
        FHeaderDown := not (Info.Flags = HHT_ONDIVIDER);
        FDevDown := Info.Flags = HHT_ONDIVIDER;
        //
        RedrawWindow(FHeaderHandle, 0, 0, RDW_INVALIDATE);
      end;
    WM_LBUTTONUP:
      begin
        FHeaderDown := False;
        FDevDown := False;
        FActiveSection := -1;
        RedrawWindow(FHeaderHandle, 0, 0, RDW_INVALIDATE);
      end;
  end;
end;

procedure TspSkinCustomListView.CMVisibleChanged;
begin
  inherited;
  if FVScrollBar <> nil then FVScrollBar.Visible := Self.Visible;
  if FHScrollBar <> nil then FHScrollBar.Visible := Self.Visible;
end;

procedure TspSkinCustomListView.SetDefaultColor;
begin
  FDefaultColor := Value;
  if FIndex = -1 then Color := Value;
end;

procedure TspSkinCustomListView.Loaded;
begin
  FInCheckScrollBars := True;
  inherited;
  FInCheckScrollBars := False;
  ChangeSkinData;
end;

procedure TspSkinCustomListView.ChangeSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is
         TspDataSkinListView
      then
      with TspDataSkinListView(FSD.CtrlList.Items[FIndex]) do
      begin
        if FUseSkinFont
          then
            begin
              Font.Name := FontName;
              Font.Style := FontStyle;
              Font.Height := FontHeight;
            end
          else
            Font.Assign(FDefaultFont);
          Font.Color := FontColor;
          Color := BGColor;
        FLineColor := MiddleColor(FontColor, BGColor);
        FLineColor := MiddleColor(FLineColor, BGColor);
        FLineColor := MiddleColor(FLineColor, BGColor);
      end;
    end
  else
    begin
      Color := FDefaultColor;
      Font := FDefaultFont;
    end;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Font.CharSet := FDefaultFont.CharSet;
  UpDateScrollBars;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
  if FHScrollBar <> nil then FHScrollBar.Align := FHScrollBar.Align;
  if (ViewStyle = vsReport) and (FHeaderHandle <> 0)
  then
    InvalidateRect(FHeaderHandle, nil, True);
end;

procedure TspSkinCustomListView.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex =  -1 then Font.Assign(Value);
end;

procedure TspSkinCustomListView.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinCustomListView.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FVScrollBar)
  then FVScrollBar := nil;
  if (Operation = opRemove) and (AComponent = FHScrollBar)
  then FHScrollBar := nil;
end;

procedure TspSkinCustomListView.WMNCCALCSIZE;
begin
end;

procedure TspSkinCustomListView.WMNCHITTEST(var Message: TWMNCHITTEST);
begin
  Message.Result := HTCLIENT;
end;

procedure TspSkinCustomListView.WMNCPAINT;
begin
end;

procedure TspSkinCustomListView.SetVScrollBar;
begin
  FVScrollBar := Value;
  if FVScrollBar <> nil
  then
    with FVScrollBar do
    begin
      Enabled := True;
      Visible := False;
      OnChange := OnVScrollBarChange;
    end;
  UpDateScrollBars;
end;

procedure TspSkinCustomListView.SetHScrollBar;
begin
  FHScrollBar := Value;
  if FHScrollBar <> nil
  then
    with FHScrollBar do
    begin
      Enabled := True;
      Visible := False;
      OnChange := OnHScrollBarChange;
    end;
  UpDateScrollBars;
end;

procedure TspSkinCustomListView.WndProc;
var
  WndClass: String;
  HR: TRect;
begin
  case Message.Msg of
    WM_PARENTNOTIFY:
       with TWMPARENTNOTIFY(Message) do
       begin
         SetLength(WndClass, 80);
         SetLength(WndClass, GetClassName(ChildWnd, PChar(WndClass), Length(WndClass)));
         if (Event = WM_CREATE) and (FHeaderHandle <> 0) and ShowColumnHeaders and
            (WndClass = 'SysHeader32')
         then
           begin
             SetWindowLong(FHeaderHandle, GWL_WNDPROC, LongInt(FDefHeaderProc));
             FHeaderHandle := 0;
           end;

         if (Event = WM_CREATE) and (FHeaderHandle = 0) and ShowColumnHeaders and
            (WndClass = 'SysHeader32')
         then
           begin
             FHeaderHandle := ChildWnd;
             FDefHeaderProc := Pointer(GetWindowLong(FHeaderHandle, GWL_WNDPROC));
             SetWindowLong(FHeaderHandle, GWL_WNDPROC, LongInt(FHeaderInstance));
           end;
        end;
  end;
  inherited;
  case Message.Msg of
     WM_SIZE:
       begin
         if not FInCheckScrollBars and (Items.Count <> 0)
         then
           UpDateScrollBars;
           
         if (ViewStyle = vsReport) and (FHeaderHandle <> 0)
         then
           InvalidateRect(FHeaderHandle, nil, False);
       end;

     WM_PAINT:
       begin
         if not FInCheckScrollBars then UpDateScrollBars;
         if (ViewStyle = vsReport) and (FHeaderHandle <> 0) and (GridLines or FDrawSkin)
         then
           begin
             Windows.GetWindowRect(FHeaderHandle, HR);
             if (Self.Canvas <> nil) and (Self.Canvas.Handle <> 0)
             then
               begin
                 Canvas.Brush.Color := Self.Color;
                 Canvas.FillRect(Rect(0, RectHeight(HR), Width, RectHeight(HR) + 1));
               end;
           end;
       end;

     WM_KEYDOWN, WM_LBUTTONUP:
      UpDateScrollBars;
  end;
end;

procedure TspSkinCustomListView.UpDateScrollBars;
begin
  if HandleAllocated and not FromSB and (Width > 5) and (Height > 5) then
  case ViewStyle of
    vsIcon, vsSmallIcon: UpDateScrollBars1;
    vsReport: UpDateScrollBars2;
    vsList: UpDateScrollBars3;
  end;
end;

procedure TspSkinCustomListView.UpDateScrollBars3;
var
  IC, IPP, Min, Max, Pos, Page: Integer;
  R: TRect;
  IH: Integer;
  OldVisible, HVisibleChanged, VVisibleChanged: Boolean;
begin
  if FInCheckScrollBars then Exit;

  VVisibleChanged := False;
  HVisibleChanged := False;

  if (FVScrollBar <> nil) and FVScrollBar.Visible
  then
    begin
      FInCheckScrollBars := True;
      FVScrollBar.Visible := False;
      FInCheckScrollBars := False;
      VVisibleChanged := True;
    end;
    
  if FHScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(Handle, SB_HORZ);
      IH := 1;
      if Items.Count > 0
      then
        begin
          ListView_GetItemRect(Handle, 0, R, LVIR_BOUNDS);
          IH := RectWidth(R);
        end;
      if IH = 0 then IH := 1;
      Page := Width div IH;
      IC := ListView_GetItemCount(Handle);
      IPP := ListView_GetCountPerPage(Handle);
      OldVisible := FHScrollBar.Visible;
      FInCheckScrollBars := True;
      FHScrollBar.Visible := (IC > IPP) and Self.Visible;
      FInCheckScrollBars := False;
      HVisibleChanged := FHScrollBar.Visible <> OldVisible;
      if FHScrollBar.Visible
      then
        begin
          FHScrollBar.SetRange(Min, Max, Pos, Page);
          FHScrollBar.SmallChange := 1;
          FHScrollBar.LargeChange := 1;
          FOldHScrollBarPos := Pos;
        end;
   end;

  if (FVScrollBar <> nil) and (FHScrollBar <> nil)
  then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if (Self.Align <> alNone) and (HVisibleChanged or VVisibleChanged)
  then
    begin
      FInCheckScrollBars := True;
      R := Parent.ClientRect;
      TParentControl(Parent).AlignControls(nil, R);
      FInCheckScrollBars := False;
    end;
end;

procedure TspSkinCustomListView.UpDateScrollBars2;
var
  Min, Max, Pos: Integer;
  OldVisible, HVisibleChanged, VVisibleChanged: Boolean;
  R: TRect;
begin
  if FInCheckScrollBars then Exit;

  VVisibleChanged := False;
  HVisibleChanged := False;

  if FVScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_VERT, Min, Max);
      Pos := GetScrollPos(Handle, SB_VERT);
      OldVisible := FVScrollBar.Visible;
      FInCheckScrollBars := True;
      FVScrollBar.Visible := (Max + 1 > ListView_GetCountPerPage(Handle)) and Self.Visible;;
      FInCheckScrollBars := False;
      VVisibleChanged := FVScrollBar.Visible <> OldVisible;
      if FVScrollBar.Visible
      then
        begin
          FVScrollBar.SetRange(Min, Max, Pos, ListView_GetCountPerPage(Handle));
          FOldVScrollBarPos := Pos;
          FVScrollBar.SmallChange := 1;
          FVScrollBar.LargeChange := ListView_GetCountPerPage(Handle);
          if FVScrollBar.LargeChange < 1 then FVScrollBar.LargeChange := 1;
        end;
    end;
  if FHScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(Handle, SB_HORZ);
      OldVisible := FHScrollBar.Visible;
      FInCheckScrollBars := True;
      FHScrollBar.Visible  := (Max > Width) and Self.Visible;
      FInCheckScrollBars := False;
      HVisibleChanged := FHScrollBar.Visible <> OldVisible;
      if FHScrollBar.Visible
      then
        begin
          FHScrollBar.SetRange(Min, Max, Pos, Width);
          FOldHScrollBarPos := Pos;
        end;
   end;

  if (FVScrollBar <> nil) and (FHScrollBar <> nil)
  then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if (Self.Align <> alNone) and (HVisibleChanged or VVisibleChanged)
  then
    begin
      FInCheckScrollBars := True;
      R := Parent.ClientRect;
      TParentControl(Parent).AlignControls(nil, R);
      FInCheckScrollBars := False;
    end;
end;

procedure TspSkinCustomListView.UpDateScrollBars1;
var
  Min, Max, Pos: Integer;
  R: TRect;
  OldVisible, HVisibleChanged, VVisibleChanged: Boolean;
begin
  if FInCheckScrollBars then Exit;

  VVisibleChanged := False;
  HVisibleChanged := False;

  if FVScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_VERT, Min, Max);
      Pos := GetScrollPos(Handle, SB_VERT);
      OldVisible := FVScrollBar.Visible;
      FInCheckScrollBars := True;
      FVScrollBar.Visible  := (Max > Height) and Self.Visible;;
      FInCheckScrollBars := False;
      VVisibleChanged := FVScrollBar.Visible <> OldVisible;
      if FVScrollBar.Visible
      then
        begin
          Listview_GEtItemRect(Handle, 0, R, LVIR_BOUNDS);
          FVScrollBar.SmallChange := RectHeight(R) div 2;
          FVScrollBar.LargeChange := RectHeight(R) div 2;
          if FVScrollBar.SmallChange = 0 then FVScrollBar.SmallChange := 1;
          if FVScrollBar.LargeChange = 0 then FVScrollBar.LargeChange := 1;
          FVScrollBar.SetRange(Min, Max, Pos, Height);
          FOldVScrollBarPos := Pos;
        end;
    end;

  if FHScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(Handle, SB_HORZ);
      OldVisible := FHScrollBar.Visible;
      FInCheckScrollBars := True;
      FHScrollBar.Visible  := (Max > Width) and Self.Visible;
      FInCheckScrollBars := False;
      HVisibleChanged := FHScrollBar.Visible <> OldVisible;
      if FHScrollBar.Visible
      then
        begin
          Listview_GEtItemRect(Handle, 0, R, LVIR_BOUNDS);
          FHScrollBar.SmallChange := RectHeight(R) div 2;
          FHScrollBar.LargeChange := RectHeight(R) div 2;
          if FHScrollBar.SmallChange = 0 then FHScrollBar.SmallChange := 1;
          if FHScrollBar.LargeChange = 0 then FHScrollBar.LargeChange := 1;
          FHScrollBar.SetRange(Min, Max, Pos, Width);
          FOldHScrollBarPos := Pos;
        end;
   end;

  if (FVScrollBar <> nil) and (FHScrollBar <> nil)
  then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if (Self.Align <> alNone) and (HVisibleChanged or VVisibleChanged)
  then
    begin
      FInCheckScrollBars := True;
      R := Parent.ClientRect;
      TParentControl(Parent).AlignControls(nil, R);
      FInCheckScrollBars := False;
    end;
end;

procedure TspSkinCustomListView.OnVScrollBarChange;
var
  H: Integer;
  R: TRect;
begin
  FromSB := True;
  //
  if (Selected <> nil) and IsEditing then Selected.CancelEdit;
  //
  if (ViewStyle = vsIcon) or (ViewStyle = vsSmallIcon)
  then
    Scroll(0, FVSCROLLBAR.Position - FOldVScrollBarPos)
  else
    begin
      ListView_GetItemRect(Handle, 0, R, LVIR_BOUNDS);
      H := RectHeight(R);
      Scroll(0, (FVSCROLLBAR.Position - FOldVScrollBarPos) * H);
    end;

  FOldVScrollBarPos := FVSCROLLBAR.Position;
  FromSB := False;
end;

procedure TspSkinCustomListView.OnHScrollBarChange;
var
  i: Integer;
begin
  FromSB := True;
  //
  if (Selected <> nil) and IsEditing then Selected.CancelEdit;
  //
  if ViewStyle = vsList
  then
    begin
      if FOldHScrollBarPos > FHSCROLLBAR.Position
      then
        begin
          for i := 1 to FOldHScrollBarPos - FHSCROLLBAR.Position do
            SendMessage(Handle, WM_HSCROLL, MakeWParam(SB_LINEUP, 0) , 0)
        end
      else
        begin
          for i := 1 to FHSCROLLBAR.Position - FOldHScrollBarPos do
            SendMessage(Handle, WM_HSCROLL, MakeWParam(SB_LINEDOWN, 0), 0);
        end;
     end
  else
    Scroll(FHSCROLLBAR.Position - FOldHScrollBarPos, 0);
  FOldHScrollBarPos := FHSCROLLBAR.Position;
  FromSB := False;
end;

procedure TspSkinCustomListView.CreateParams;
begin
  inherited;
  with Params do
    Style := Style and not (WS_HSCROLL or WS_VSCROLL);
end;

constructor TspSkinStatusPanel.Create;
begin
  inherited;
  FGlyph := TBitMap.Create;
  FNumGlyphs := 1;
  FSkinDataName := 'statuspanel';
  FImageList := nil;
  FImageIndex := -1;
  Width := 120;
end;

destructor TspSkinStatusPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TspSkinStatusPanel.Notification(AComponent: TComponent;  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImageList)
  then FImageList:= nil;
end;

procedure TspSkinStatusPanel.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      RePaint;
    end;
end;

function TspSkinStatusPanel.CalcWidthOffset;
  var
  X: Integer;
begin
  if FGlyph.Empty and (FImageList <> nil) and (FImageIndex >= 0) and
  (FImageIndex < FImageList.Count)
  then
    begin
      X := FImageList.Width + 3
    end
  else
  if not FGlyph.Empty
  then
    X := FGlyph.Width div FNumGlyphs + 3
  else
    X := 0;
  if FIndex <> -1
  then
    begin
      with Canvas do
      begin
        if UseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Height := FontHeight;
            Font.Style := FontStyle;
          end
        else
          Font.Assign(DefaultFont);    
        if ResizeMode = 0
        then
          Result := 0
        else
          Result := TextWidth(Caption) + X - RectWidth(NewClRect);
     end
   end
 else
   begin
     Canvas.Font.Assign(DefaultFont);
     Result := Canvas.TextWidth(Caption) + X - (Width - 4);
   end;
end;

procedure TspSkinStatusPanel.CMEnabledChanged;
begin
  inherited;
  RePaint;
end;

procedure TspSkinStatusPanel.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
  if FAutoSize then AdjustBounds;
end;

procedure TspSkinStatusPanel.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
  if FAutoSize then AdjustBounds;
end;

procedure TspSkinStatusPanel.CreateControlDefaultImage;
var
  R: TRect;
  GW, GX, GY: Integer;
  GlyphNum: Integer;
begin
  R := ClientRect;
  with  B.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(R);
  end;
  case FBorderStyle of
    bvLowered:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnHighLight, 1);
    bvRaised:
      Frame3D(B.Canvas, R, clBtnHighLight, clBtnShadow, 1);
    bvFrame:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  end;
  R := Rect(3, 3, Width - 3, Height - 3);
  if FGlyph.Empty and (FImageList <> nil) and (FImageIndex >= 0) and
  (FImageIndex < FImageList.Count)
  then
    begin
      GW := FImageList.Width;
      GX := R.Left;
      GY := R.Top + RectHeight(R) div 2 - FImageList.Height div 2;
      FImageList.Draw(B.Canvas, GX, GY, FImageIndex, Enabled);
      Inc(R.Left, GW + 2);
    end
  else
  if not FGlyph.Empty
  then
    begin
      GW := FGlyph.Width div FNumGlyphs;
      Inc(R.Left, GW + 2);
      if Enabled then GlyphNum := 1 else GlyphNum := 2; 
      DrawGlyph(B.Canvas, 3, B.Height div 2 - FGlyph.Height div 2, Glyph, NumGlyphs, GlyphNum);
    end;
  DrawLabelText(B.Canvas, R);
end;

procedure TspSkinStatusPanel.CreateControlSkinImage;
var
  R: TRect;
  GlyphNum, GX, GY, GW: Integer;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
  R := NewClRect;
  if FGlyph.Empty and (FImageList <> nil) and (FImageIndex >= 0) and
  (FImageIndex < FImageList.Count)
  then
    begin
      GW := FImageList.Width;
      GX := R.Left;
      GY := R.Top + RectHeight(R) div 2 - FImageList.Height div 2;
      FImageList.Draw(B.Canvas, GX, GY, FImageIndex, Enabled);
      Inc(R.Left, GW + 2);
    end
  else
  if not FGlyph.Empty
  then
    begin
      GW := FGlyph.Width div FNumGlyphs;
      GX := R.Left;
      GY := R.Top + RectHeight(R) div 2 - FGlyph.Height div 2;
      if Enabled then GlyphNum := 1 else GlyphNum := 2;
      DrawGlyph(B.Canvas, GX, GY, Glyph, NumGlyphs, GlyphNum);
      Inc(R.Left, GW + 2);
    end;
  DrawLabelText(B.Canvas, R);
end;

constructor TspSkinRichEdit.Create(AOwner: TComponent);
begin
  inherited;
  FSkinSupport := False;
  FTransparent := False;
  FWallpaper := TBitMap.Create;
  FWallpaperStretch := False;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FOldVScrollBarPos := 0;
  FOldHScrollBarPos := 0;
  FSD := nil;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  Font.Assign(FDefaultFont);
  FDefaultColor := clWindow;
  FSkinDataName := 'richedit';
  ScrollBars := ssBoth;
end;

destructor TspSkinRichEdit.Destroy;
begin
  FDefaultFont.Free;
  FWallpaper.Free;
  inherited;
end;

procedure TspSkinRichEdit.DrawBackGround(C: TCanvas);

procedure PaintWallPaper;
var
  X, Y, XCnt, YCnt: Integer;
begin
  if FWallPaperStretch and (FWallpaper.Width <> 0) and(FWallpaper.Height <> 0)
  then
    begin
      C.StretchDraw(Rect(0, 0, Width, Height), FWallPaper)
    end
  else
  if (FWallpaper.Width <> 0) and(FWallpaper.Height <> 0) then
  begin
    XCnt := Width div FWallpaper.Width;
    YCnt := Height div FWallpaper.Height;
    for X := 0 to XCnt do
    for Y := 0 to YCnt do
      C.Draw(X * FWallpaper.Width, Y * FWallpaper.Height,
                            FWallpaper);
  end;
end;

var
  B: TBitmap;
begin
  if FWallpaper.Empty
  then
    begin
      B := TBitMap.Create;
      B.Width := Width;
      B.Height := Height;
      GetParentImage(Self, B.Canvas);
      C.Draw(0, 0, B);
      B.Free;
    end
  else
    PaintWallPaper;
end;

procedure TspSkinRichEdit.WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); 
begin
  if FTransparent then
   RedrawWindow(Handle, 0, 0, RDW_INVALIDATE or RDW_UPDATENOW);
end;

procedure TspSkinRichEdit.WMPAINT(var Message: TWMPAINT);
begin
  inherited;
end;

procedure TspSkinRichEdit.WMEraseBkgnd(var Msg: TWMEraseBkgnd); 
var
  C: TCanvas;
begin
  if FTransparent 
  then
    begin
      C := TCanvas.Create;
      C.Handle := Msg.DC;
      DrawBackGround(C);
      C.Handle := 0;
      C.Free;
      Msg.Result := 1;
    end
  else
    inherited;
end;

procedure TspSkinRichEdit.CreateWnd;
begin
  inherited;
  if FTransparent
  then
    SetWindowLong(Handle, GWL_EXSTYLE,
      GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
end;

procedure TspSkinRichEdit.SetWallPaper(Value: TBitmap);
begin
  FWallpaper.Assign(Value);
  if Value <> nil then FTransparent := True;
  RePaint;
end;

procedure TspSkinRichEdit.SetWallPaperStretch(Value: Boolean);
begin
  FWallpaperStretch := Value;
  if not FWallpaper.Empty then RePaint;
end;

procedure TspSkinRichEdit.SetTransparent;
begin
  if FTransparent <> Value
  then
    begin
      FTransparent := Value;
      RecreateWnd;
    end;
end;


function TspSkinRichEdit.HScrollDisabled: boolean;
var
  P: TPoint;
  BarInfo: TScrollBarInfo;
begin
  BarInfo.cbSize := SizeOf(BarInfo);
  MyGetScrollBarInfo(Handle, OBJID_HSCROLL, BarInfo);
  if STATE_SYSTEM_INVISIBLE and BarInfo.rgstate[0] = STATE_SYSTEM_INVISIBLE
  then
    Result := true
  else
    Result := false;
end;

function TspSkinRichEdit.VScrollDisabled: boolean;
var
  P: TPoint;
  BarInfo: TScrollBarInfo;
begin
  BarInfo.cbSize := SizeOf(BarInfo);
  MyGetScrollBarInfo(Handle, OBJID_VSCROLL, BarInfo);
  if STATE_SYSTEM_INVISIBLE and BarInfo.rgstate[0] = STATE_SYSTEM_INVISIBLE
  then
    Result := true
  else
    Result := false;
end;

procedure TspSkinRichEdit.Change;
begin
  inherited;
  UpDateScrollBars;
end;

procedure TspSkinRichEdit.SetDefaultColor;
begin
  FDefaultColor := Value;
  if (FIndex = -1) and FSkinSupport then Color := Value;
end;

procedure TspSkinRichEdit.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if (FIndex =  -1) and FSkinSupport then Font.Assign(Value);
end;

procedure TspSkinRichEdit.Loaded;
begin
  ChangeSkinData;
end;

procedure TspSkinRichEdit.ChangeSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if FSkinSupport
  then
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is
         TspDataSkinRichEdit
      then
      with TspDataSkinRichEdit(FSD.CtrlList.Items[FIndex]) do
      begin
        Font.Name := FontName;
        Font.Color := FontColor;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
        Color := BGColor;
      end;
    end
  else
    begin
      Color := FDefaultColor;
      Font.Assign(FDefaultFont);
    end;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Font.CharSet := FDefaultFont.CharSet;

  UpDateScrollBars;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
  if FHScrollBar <> nil then FHScrollBar.Align := FHScrollBar.Align;
end;

procedure TspSkinRichEdit.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinRichEdit.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinRichEdit.WMNCCALCSIZE;
begin
end;

procedure TspSkinRichEdit.WMNCHITTEST(var Message: TWMNCHITTEST);
begin
  Message.Result := HTCLIENT;
end;


procedure TspSkinRichEdit.WMNCPAINT;
begin
  inherited;
end;

procedure TspSkinRichEdit.SetVScrollBar;
begin
  FVScrollBar := Value;
  if FVScrollBar <> nil
  then
    with FVScrollBar do
    begin
      OnChange := OnVScrollBarChange;
      OnUpButtonClick := OnVScrollBarUpButtonClick;
      OnDownButtonClick := OnVScrollBarDownButtonClick;
    end;
  UpDateScrollBars;
end;

procedure TspSkinRichEdit.SetHScrollBar;
begin
  FHScrollBar := Value;
  if FHScrollBar <> nil
  then
    with FHScrollBar do
    begin
      OnChange := OnHScrollBarChange;
    end;
  UpDateScrollBars;
end;

procedure TspSkinRichEdit.WndProc;
begin
  inherited;
  case Message.Msg of
    WM_SIZE, WM_KEYDOWN, WM_LBUTTONUP, WM_LBUTTONDOWN:
    UpDateScrollBars;
  end;
end;

procedure TspSkinRichEdit.UpDateScrollBars;
var
  Min, Max, Pos, Page: Integer;
  SI: TScrollInfo;
begin
  if FVScrollBar <> nil
  then
    begin
      SI.cbSize := SizeOf(TScrollInfo);
      SI.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_VERT, SI);
      Min := SI.nMin;
      Max := SI.nMax;
      Page := SI.nPage;
      Pos := SI.nPos;
      if not VScrollDisabled
      then
        begin
          if not FVScrollBar.Enabled
          then
            FVScrollBar.Enabled := True;
          FVScrollBar.SetRange(Min, Max, Pos, Page);
        end
      else
        begin
          FVScrollBar.Enabled := False;
          SetScrollRange(Handle, SB_VERT, 0, 0, False);
        end;
    end;

  if FHScrollBar <> nil
  then
    begin
      SI.cbSize := SizeOf(TScrollInfo);
      SI.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_HORZ, SI);
      Min := SI.nMin;
      Max := SI.nMax;
      Page := SI.nPage;
      Pos := SI.nPos;
      if not HScrollDisabled
      then
        begin
          if not FHScrollBar.Enabled
          then
            FHScrollBar.Enabled := True;
          FHScrollBar.SetRange(Min, Max, Pos, Page);
        end
      else
        begin
          FHScrollBar.Enabled := False;
          SetScrollRange(Handle, SB_HORZ, 0, 0, False);
        end;
    end;
end;

procedure TspSkinRichEdit.OnVScrollBarChange;
begin
  SendMessage(Handle, WM_VSCROLL,
   MakeWParam(SB_THUMBPOSITION, FVSCROLLBAR.Position), 0);
end;

procedure TspSkinRichEdit.OnVScrollBarUpButtonClick;
begin
  if FVScrollBar.Position < FVScrollBar.Max - FVScrollBar.PageSize + 1
  then
    SendMessage(Handle, WM_VSCROLL,
     MakeWParam(SB_LINEDOWN, FVSCROLLBAR.Position), 0);
  UpDateScrollBars;
end;

procedure TspSkinRichEdit.OnVScrollBarDownButtonClick;
begin
  if FVScrollBar.Position <> 0
  then
    SendMessage(Handle, WM_VSCROLL,
  MakeWParam(SB_LINEUP, FVSCROLLBAR.Position), 0);
  UpDateScrollBars;
end;

procedure TspSkinRichEdit.OnHScrollBarChange;
begin
  SendMessage(Handle, WM_HSCROLL,
   MakeWParam(SB_THUMBPOSITION, FHSCROLLBAR.Position), 0);
end;

procedure TspSkinRichEdit.CreateParams;
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
  end;
end;

constructor TspGraphicSkinControl.Create;
begin
  inherited Create(AOwner);
  FSD := nil;
  FAreaName := '';
  FIndex := -1;
  FDrawDefault := True;
  CursorIndex := -1;
  FAlphaBlend := False;
  FAlphaBlendValue := 200;
  FUseSkinCursor := False;
  FHintTitle := '';
  FHintImageIndex := 0;
  FHintImageList := nil;
end;

destructor TspGraphicSkinControl.Destroy;
begin
  inherited Destroy;
end;

procedure TspGraphicSkinControl.WMCHECKPARENTBG;
begin
  if AlphaBlend
  then
    begin
      RePaint;
    end;
end;

procedure TspGraphicSkinControl.SetAlphaBlend;
begin
  FAlphaBlend := AValue;
  RePaint;
end;

procedure TspGraphicSkinControl.SetAlphaBlendValue;
begin
  FAlphaBlendValue := AValue;
  RePaint;
end;

procedure TspGraphicSkinControl.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TspGraphicSkinControl.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TspGraphicSkinControl.WMEraseBkGnd;
begin
end;

procedure TspGraphicSkinControl.WMMOVE;
begin
  inherited;
  if AlphaBlend then RePaint;
end;

procedure TspGraphicSkinControl.BeforeChangeSkinData;
begin
  FIndex := -1;
end;

procedure TspGraphicSkinControl.ChangeSkinData;
begin
  GetSkinData;
  if FUseSkinCursor
  then 
  if CursorIndex <> -1
  then
    Cursor := FSD.StartCursorIndex + CursorIndex
  else
    Cursor := crDefault;
  RePaint;
end;

procedure TspGraphicSkinControl.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspGraphicSkinControl.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
end;

procedure TspGraphicSkinControl.Paint;
var
  Buffer: TBitMap;
  ParentImage: TBitMap;
  PBuffer, PIBuffer: TspEffectBmp;
  kf: Double;
begin
  if (Width <= 0) or (Height <= 0) then Exit;
  GetSkinData;
  Buffer := TBitMap.Create;
  Buffer.Width := Width;
  Buffer.Height := Height;
  if FIndex <> -1
  then
    CreateControlSkinImage(Buffer)
  else
  if FDrawDefault
  then
    CreateControlDefaultImage(Buffer);
  if FAlphaBlend
  then
    begin
      ParentImage := TBitMap.Create;
      ParentImage.Width := Width;
      ParentImage.Height := Height;
      GetParentImage(Self, ParentImage.Canvas);
      PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
      PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
      kf := 1 - FAlphaBlendValue / 255;
      PBuffer.Morph(PIBuffer, Kf);
      PBuffer.Draw(Canvas.Handle, 0, 0);
      PBuffer.Free;
      PIBuffer.Free;
      ParentImage.Free;
    end
  else
    Canvas.Draw(0, 0, Buffer);
  Buffer.Free;
end;

procedure TspGraphicSkinControl.CreateControlDefaultImage;
begin
end;

procedure TspGraphicSkinControl.CreateControlSkinImage;
begin
end;

procedure TspGraphicSkinControl.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FHintImageList) then FHintImageList := nil;
end;


constructor TspGraphicSkinCustomControl.Create;
begin
  inherited Create(AOwner);
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  StretchEffect := False;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FUseSkinFont := True;
end;

destructor TspGraphicSkinCustomControl.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;

function TspGraphicSkinCustomControl.GetRealClientWidth: integer;
begin
  Result := NewClRect.Right - NewClRect.Left;
end;

function TspGraphicSkinCustomControl.GetRealClientHeight: integer;
begin
  Result := NewClRect.Bottom - NewClRect.Top;
end;

function TspGraphicSkinCustomControl.GetRealClientLeft: integer;
begin
  Result := NewClRect.Left;
end;

function TspGraphicSkinCustomControl.GetRealClientTop: integer;
begin
  Result := NewClRect.Top;
end;

procedure TspGraphicSkinCustomControl.SetDefaultWidth;
begin
  FDefaultWidth := Value;
  if (FIndex = -1) and (FDefaultWidth > 0) then Width := FDefaultWidth;
end;

procedure TspGraphicSkinCustomControl.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;

procedure TspGraphicSkinCustomControl.DefaultFontChange;
begin
end;

procedure TspGraphicSkinCustomControl.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  DefaultFontChange;
end;

procedure TspGraphicSkinCustomControl.OnDefaultFontChange;
begin
  DefaultFontChange;
  if FIndex = -1 then RePaint;
end;

procedure TspGraphicSkinCustomControl.CreateControlDefaultImage;
var
  R: TRect;
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
end;

procedure TspGraphicSkinCustomControl.ChangeSkinData;
var
  W, H: Integer;
  UpDate: Boolean;
begin
  GetSkinData;

  if FUseSkinCursor
  then
  if CursorIndex <> -1
  then
    Cursor := FSD.StartCursorIndex + CursorIndex
  else
    Cursor := crDefault;

  W := Width;
  H := Height;

  if FIndex <> -1
  then
    begin
      CalcSize(W, H);
      Update := (W <> Width) or (H <> Height);
      if W <> Width then Width := W;
      if H <> Height then Height := H;
    end
  else
    begin
      UpDate := False;
      if FDefaultWidth > 0 then Width := FDefaultWidth;
      if FDefaultHeight > 0 then Height := FDefaultHeight;
    end;

  if (not UpDate) or (FIndex = -1) then RePaint;
    
end;

procedure TspGraphicSkinCustomControl.SetBounds;
var
  UpDate: Boolean;
  R: TRect;
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and (FIndex <> -1);
  if UpDate
  then
    begin
      CalcSize(AWidth, AHeight);
      if ResizeMode = 0 then NewClRect := ClRect;
    end;

if Parent is TspSkinToolbar
  then
    begin
      if TspSkinToolbar(Parent).AdjustControls
      then
        with TspSkinToolbar(Parent) do
        begin
          R := GetSkinClientRect;
          ATop := R.Top + RectHeight(R) div 2 - AHeight div 2;
        end;
    end;
    
  inherited;
  if UpDate then RePaint;
end;

procedure TspGraphicSkinCustomControl.CalcSize;
var
  XO, YO: Integer;
begin
  if ResizeMode > 0
  then
    begin
      XO := W - RectWidth(SkinRect);
      YO := H - RectHeight(SkinRect);
      NewLTPoint := LTPt;
      case ResizeMode of
        1:
          begin
            NewRTPoint := Point(RTPt.X + XO, RTPt.Y);
            NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
            NewRBPoint := Point(RBPt.X + XO, RBPt.Y + YO);
            NewClRect := Rect(CLRect.Left, ClRect.Top,
              CLRect.Right + XO, ClRect.Bottom + YO);
          end;
        2:
          begin
            H := RectHeight(SkinRect);
            NewRTPoint := Point(RTPt.X + XO, RTPt.Y );
            NewClRect := ClRect;
            Inc(NewClRect.Right, XO);
          end;
        3:
          begin
            W := RectWidth(SkinRect);
            NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
            NewClRect := ClRect;
            Inc(NewClRect.Bottom, YO);
          end;
      end;
    end
  else
    if (FIndex <> -1) and (ResizeMode = 0)
    then
      begin
        W := RectWidth(SkinRect);
        H := RectHeight(SkinRect);
        NewClRect := CLRect;
      end;
end;

procedure TspGraphicSkinCustomControl.CreateControlSkinImage;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspGraphicSkinCustomControl.CreateSkinControlImage;
begin
  case ResizeMode of
    0:
      begin
        B.Width := RectWidth(R);
        B.Height := RectHeight(R);
        B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), SB.Canvas, R);
      end;
    1: CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
         NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
         B, SB, R, Width, Height, True,
         LeftStretch, TopStretch, RightStretch, BottomStretch,
         StretchEffect, StretchType);
    2: CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, SB, R, Width, Height, StretchEffect);
    3: CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          B, SB, R, Width, Height, StretchEffect);
  end;
end;

function TspGraphicSkinCustomControl.GetResizeMode;
begin
  if IsNullRect(SkinRect)
  then
    Result := -1
  else   
  if (RBPt.X <> 0) and (RBPt.Y <> 0)
  then
    Result := 1
  else
  if (RTPt.X <> 0) or (RTPT.Y <> 0)
  then
    Result := 2
  else
  if (LBPt.X <> 0) or (LBPt.Y <> 0)
  then
    Result := 3
  else
    Result := 0;  
end;

function TspGraphicSkinCustomControl.GetNewRect;
var
  XO, YO: Integer;
  LeftTop, LeftBottom, RightTop, RightBottom: TRect;

function CorrectResizeRect: TRect;
var
  NR: TRect;
begin
  NR := R;
  if PointInRect(LeftTop, R.TopLeft) and
     PointInRect(RightBottom, R.BottomRight)
  then
    begin
      Inc(NR.Right, XO);
      Inc(NR.Bottom, YO);
    end
  else
  if PointInRect(LeftTop, R.TopLeft) and
     PointInRect(RightTop, R.BottomRight)
  then
    Inc(NR.Right, XO)
  else
    if PointInRect(LeftBottom, R.TopLeft) and
       PointInRect(RightBottom, R.BottomRight)
    then
      begin
        Inc(NR.Right, XO);
        OffsetRect(NR, 0, YO);
      end
    else
      if PointInRect(LeftTop, R.TopLeft) and
         PointInRect(LeftBottom, R.BottomRight)
      then
        Inc(NR.Bottom, YO)
      else
        if PointInRect(RightTop, R.TopLeft) and
           PointInRect(RightBottom, R.BottomRight)
        then
          begin
            OffsetRect(NR, XO, 0);
            Inc(NR.Bottom, YO);
          end;
  Result := NR;
end;

begin
  XO := Width - RectWidth(SkinRect);
  YO := Height - RectHeight(SkinRect);
  Result := R;
  case ResizeMode of
    1:
      begin
        LeftTop := Rect(0, 0, LTPt.X, LTPt.Y);
        LeftBottom := Rect(0, LBPt.Y, LBPt.X, RectHeight(SkinRect));
        RightTop := Rect(RTPt.X, 0, RectWidth(SkinRect), RTPt.Y);
        RightBottom := Rect(RBPt.X, RBPt.Y,
          RectWidth(SkinRect), RectHeight(SkinRect));
        Result := R;
        if RectInRect(R, LeftTop)
        then Result := R
        else
        if RectInRect(R, RightTop)
        then OffsetRect(Result, XO, 0)
        else
        if RectInRect(R, LeftBottom)
        then OffsetRect(Result, 0, YO)
        else
        if RectInRect(R, RightBottom)
        then
          OffsetRect(Result,  XO, YO)
        else
          Result := CorrectResizeRect;
      end;
    2:
      begin
        if (R.Left <= LTPt.X) and (R.Right >= RTPt.X)
        then
          Inc(Result.Right, XO)
        else
        if (R.Left >= RTPt.X) and (R.Right > RTPt.X)
        then
          OffsetRect(Result, XO, 0);
      end;
     3:
      begin
        if (R.Top <= LTPt.Y) and (R.Bottom >= LBPt.Y)
        then
          Inc(Result.Bottom, YO)
        else
          if (R.Top >= LBPt.Y) and (R.Bottom > LBPt.X)
          then
            OffsetRect(Result, 0, YO);
      end;
  end;
end;

procedure TspGraphicSkinCustomControl.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinCustomControl
    then
      with TspDataSkinCustomControl(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        RBPt := RBPoint;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        Self.CursorIndex := CursorIndex;
        Self.StretchEffect := StretchEffect;
        Self.LeftStretch := LeftStretch;
        Self.TopStretch := TopStretch;
        Self.RightStretch := RightStretch;
        Self.BottomStretch := BottomStretch;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        ResizeMode := GetResizeMode;
      end
    else
      begin
        ResizeMode := 0;
        Picture := nil;
      end;
end;

constructor TspSkinSpeedButton.Create;
begin
  inherited;
  AnimateTimer := nil;
  FUseSkinSize := True;
  FCheckedMode := False;
  FStopMouseUp := False;
  UseSkinFontColor := True;
  FImageIndex := 0;
  FButtonImages := nil;
  ControlStyle := [csCaptureMouse, csDoubleClicks, csOpaque];
  RepeatTimer := nil;
  FRepeatMode := False;
  FRepeatInterval := 100;
  FSkinDataName := 'toolbutton';
  FDown := False;
  FMouseDown := False;
  FMouseIn := False;
  Width := 25;
  Height := 25;
  FGroupIndex := 0;
  FGlyph := TBitMap.Create;
  FNumGlyphs := 1;
  FMargin := -1;
  FSpacing := 1;
  FLayout := blGlyphLeft;
  FMorphKf := 0;

  MorphTimer := nil;

  Morphing := False;
  FMorphKf := 0;

  FAllowAllUp := False;
  FAllowAllUpCheck := False;
  FShowCaption := True;
  FWidthWithCaption := 0;
  FWidthWithoutCaption := 0;

  FSkinImagesMenu := nil;
  FUseImagesMenuImage := False;
  FUseImagesMenuCaption := False;

  FDrawColorMarker := False;
  FColorMarkerValue := 0;
end;

destructor TspSkinSpeedButton.Destroy;
begin
  if RepeatTimer <> nil then StopRepeat;
  if AnimateTimer <> nil then StopAnimate;
  FGlyph.Free;
  StopMorph;
  inherited;
end;

procedure TspSkinSpeedButton.Loaded;
begin
  inherited;
  if FFlat and IsTransparent and FDown then
  SetTempTransparent(False);
end;

function TspSkinSpeedButton.IsTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TspSkinSpeedButton.SetTempTransparent(Value: Boolean);
begin
  if Value
  then ControlStyle := ControlStyle - [csOpaque]
  else ControlStyle := ControlStyle + [csOpaque];
end;

procedure TspSkinSpeedButton.SetCheckedMode(Value: Boolean);
begin
  if FCheckedMode <> Value
  then
    begin
      FCheckedMode := Value;
      if FCheckedMode then GroupIndex := -1 else
      if GroupIndex = -1 then GroupIndex := 0;
    end;
end;

procedure TspSkinSpeedButton.DrawMenuMarker;
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  if ADown then SR := MenuMarkerDownRect else
    if AActive then SR := MenuMarkerActiveRect else
      if AFlat then SR := MenuMarkerFlatRect else
        SR := MenuMarkerRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);

  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    Picture.Canvas, SR);

  Buffer.Transparent := True;
  Buffer.TransparentMode := tmFixed;
  Buffer.TransparentColor := MenuMarkerTransparentColor;

  X := R.Left + RectWidth(R) div 2 - RectWidth(SR) div 2;
  Y := R.Top + RectHeight(R) div 2 - RectHeight(SR) div 2;

  C.Draw(X, Y, Buffer);

  Buffer.Free;
end;

procedure TspSkinSpeedButton.OnImagesMenuChanged(Sender: TObject);
begin
  RePaint;
end;

procedure TspSkinSpeedButton.SetSkinImagesMenu(Value: TspSkinImagesMenu);
begin
  FSkinImagesMenu := Value;
  if Value <> nil
  then
    begin
      FSkinImagesMenu.OnInternalChange := OnImagesMenuChanged;
    end;
  OnImagesMenuChanged(Self);
end;

procedure TspSkinSpeedButton.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinImagesMenu)
  then FSkinImagesMenu := nil;
  if (Operation = opRemove) and (AComponent = FButtonImages)
  then FButtonImages := nil;
end;

function TspSkinSpeedButton.GetGlyphNum;
begin
  if AIsDown and AIsMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if AIsMouseIn and (FNumGlyphs > 3)
  then
    Result := 4
  else
    if not Enabled and (FNumGlyphs > 1)
    then
      Result := 2
    else
      Result := 1;
end;

procedure TspSkinSpeedButton.RefreshButton;
begin
  FMouseIn := False;
  FDown := False;
  if EnableMorphing then FMorphKf := 0;
  if EnableAnimation then StopAnimate;
  RePaint;
end;

procedure TspSkinSpeedButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      ButtonClick;
      Result := 1;
    end else
      inherited;
end;

function TspSkinSpeedButton.EnableAnimation: Boolean;
begin
  Result := (SkinData <> nil) and not SkinData.Empty and
            SkinData.EnableSkinEffects;
end;

function TspSkinSpeedButton.EnableMorphing: Boolean;
begin
  Result := Morphing and (SkinData <> nil) and not SkinData.Empty and
            SkinData.EnableSkinEffects;
end;

function TspSkinSpeedButton.GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectWidth(AnimateSkinRect) > RectWidth(SkinRect)
  then
    begin
      fs := RectWidth(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 AnimateSkinRect.Top,
                 AnimateSkinRect.Left + CurrentFrame * fs,
                 AnimateSkinRect.Bottom);
    end
  else
    begin
      fs := RectHeight(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left,
                     AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     AnimateSkinRect.Right,
                     AnimateSkinRect.Top + CurrentFrame * fs);
    end;
end;

procedure TspSkinSpeedButton.StartAnimate;
begin
  if Self.Flat then Exit;
  StopAnimate;
  AnimateInc := AInc;
  if not AnimateInc then CurrentFrame := FrameCount else  CurrentFrame := 1;
  AnimateTimer := TTimer.Create(Self);
  AnimateTimer.Enabled := False;
  AnimateTimer.OnTimer := DoAnimate;
  AnimateTimer.Interval := AnimateInterval;
  AnimateTimer.Enabled := True;
end;

procedure TspSkinSpeedButton.StopAnimate;
begin
  CurrentFrame := 0;
  if AnimateTimer <> nil
  then
    begin
      AnimateTimer.Enabled := False;
      AnimateTimer.Free;
      AnimateTimer := nil;
    end;
end;

procedure TspSkinSpeedButton.DoAnimate(Sender: TObject);
begin
  if AnimateInc
  then
    begin
      if CurrentFrame <= FrameCount
      then
        begin
         Inc(CurrentFrame);
         RePaint;
       end;
      if CurrentFrame > FrameCount then StopAnimate;
    end
  else
    begin
      if CurrentFrame >= 0
      then
        begin
          Dec(CurrentFrame);
          RePaint;
        end;
      if CurrentFrame <= 0 then StopAnimate;
    end;
end;


procedure TspSkinSpeedButton.CalcSize(var W, H: Integer);
var
  XO, YO: Integer;
begin
  if FUseSkinSize or (ResizeMode = 1) then inherited;
  if (not FUseSkinSize) and (ResizeMode <> 1)
  then
    begin
      XO := W - RectWidth(SkinRect);
      YO := H - RectHeight(SkinRect);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
    end;
end;

procedure TspSkinSpeedButton.SetShowCaption(const Value: Boolean);
begin
  if FShowCaption <> Value
  then
    begin
      FShowCaption := Value;
      if (FWidthWithCaption > 0) and (FWidthWithoutCaption > 0)
      then
        begin
          if FShowCaption
          then Width := FWidthWithCaption
          else Width := FWidthWithoutCaption;
        end
      else
        RePaint;
    end;
end;    

procedure TspSkinSpeedButton.SetImageIndex(Value: Integer);
begin
  FImageIndex := Value;
  if (Parent is TspSkinToolBar) or (FButtonImages <> nil)
  then
    RePaint;
end;

procedure TspSkinSpeedButton.RepeatTimerProc;
begin
  ButtonClick;
end;

procedure TspSkinSpeedButton.BeforeRepeatTimerProc(Sender: TObject);
begin
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := RepeatTimerProc;
  RepeatTimer.Interval := FRepeatInterval;
  RepeatTimer.Enabled := True;
end;

procedure TspSkinSpeedButton.StartRepeat;
begin
  if RepeatTimer <> nil then RepeatTimer.Free;
  RepeatTimer := TTimer.Create(Self);
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := BeforeRepeatTimerProc;
  RepeatTimer.Interval := 500;
  RepeatTimer.Enabled := True;
end;

procedure TspSkinSpeedButton.StopRepeat;
begin
  if RepeatTimer = nil then Exit;
  RepeatTimer.Enabled := False;
  RepeatTimer.Free;
  RepeatTimer := nil;
end;

procedure TspSkinSpeedButton.CMEnabledChanged;
begin
  inherited;
  if EnableMorphing
  then
    begin
      StopMorph;
      FMorphKf := 0;
    end;
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinSpeedButton.SetFlat;
begin
  FFlat := Value;
  if Value
  then ControlStyle := ControlStyle - [csOpaque]
  else ControlStyle := ControlStyle + [csOpaque];
  RePaint;
end;

procedure TspSkinSpeedButton.StartMorph;
begin
  if MorphTimer <> nil then Exit;
  MorphTimer := TTimer.Create(Self);
  MorphTimer.Interval := MorphTimerInterval;
  MorphTimer.OnTimer := DoMorph;
  MorphTimer.Enabled := True;
end;

procedure TspSkinSpeedButton.StopMorph;
begin
  if MorphTimer = nil then Exit;
  MorphTimer.Free;
  MorphTimer := nil;
end;


procedure TspSkinSpeedButton.ButtonClick;
begin
  if Assigned(OnClick) and (Action <> nil) and (@OnClick <> @Action.OnExecute)
  then
    OnClick(Self)
  else
    if not (csDesigning in ComponentState) and (ActionLink <> nil)
    then
      ActionLink.Execute
     else
       if Assigned(OnClick) then OnClick(Self);
end;

procedure TspSkinSpeedButton.ChangeSkinData;
begin
  StopAnimate;
  StopMorph;
  inherited;
  if EnableMorphing and (FIndex <> -1) and FMouseIn
  then
    FMorphKf := 1;
end;

procedure TspSkinSpeedButton.SetGroupIndex;
begin
  FGroupIndex := Value;
end;

procedure TspSkinSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if (FGlyph.Empty) and (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
      begin
        Self.ImageList := ActionList.Images;
        Self.ImageIndex := ImageIndex;
        RePaint;
      end;
    end;
end;

procedure TspSkinSpeedButton.ReDrawControl;
begin
  if EnableMorphing and (FIndex <> -1) and not IsTransparent and not FFlat
  then StartMorph
  else RePaint;
end;

procedure TspSkinSpeedButton.DoMorph;
begin
  if (FIndex = -1) or not EnableMorphing
  then
    begin
      if FMouseIn then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
    end
  else
  if FMouseIn and (FMorphKf < 1)
  then
    begin
      FMorphKf := FMorphKf + MorphInc;
      RePaint;
    end
  else
  if not FMouseIn and (FMorphKf > 0)
  then
    begin
      FMorphKf := FMorphKf - MorphInc;
      RePaint;
    end
  else
    begin
      if FMouseIn then FMorphKf := 1 else FMorphKf := 0;
      StopMorph;
      RePaint;
    end;
end;

procedure TspSkinSpeedButton.SetLayout;
begin
  if FLayout <> Value
  then
    begin
      FLayout := Value;
      RePaint;
    end;
end;

procedure TspSkinSpeedButton.SetSpacing;
begin
  if Value <> FSpacing
  then
    begin
      FSpacing := Value;
      RePaint;
    end;
end;

procedure TspSkinSpeedButton.SetMargin;
begin
  if (Value <> FMargin) and (Value >= -1)
  then
    begin
      FMargin := Value;
      RePaint;
    end;
end;

procedure TspSkinSpeedButton.SetDown;
begin
  FDown := Value;
  if EnableMorphing
  then
     begin
       FMorphKf := 1;
       if not FDown then StartMorph else StopMorph; 
     end;
  //
  if not FMouseIn and FFlat and not IsTransparent and not FDown and
     not (csDesigning in ComponentState)
  then
    SetTempTransparent(True);
  //   
  RePaint;
  if (GroupIndex > 0) and FDown and not FAllowAllUp then DoAllUp;
end;

procedure TspSkinSpeedButton.DoAllUp;
var
  PC: TWinControl;
  i: Integer;
begin
  if Parent = nil then Exit;
  PC := TWinControl(Parent);
  for i := 0 to PC.ControlCount - 1 do
   if (PC.Controls[i] is TspSkinSpeedButton) and
      (PC.Controls[i] <> Self)
   then
     with TspSkinSpeedButton(PC.Controls[i]) do
       if (GroupIndex = Self.GroupIndex) and
          (GroupIndex > 0) and FDown
       then
         Down := False;
end;

procedure TspSkinSpeedButton.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinSpeedButton.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinSpeedButton.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinButtonControl
      then
        with TspDataSkinButtonControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.FontName := FontName;
          Self.FontColor := FontColor;
          Self.ActiveFontColor := ActiveFontColor;
          Self.DownFontColor := DownFontColor;
          Self.FontStyle := FontStyle;
          Self.FontHeight := FontHeight;
          Self.ActiveSkinRect := ActiveSkinRect;
          Self.DownSkinRect := DownSkinRect;
          Self.Morphing := Morphing;
          Self.MorphKind := MorphKind;
          if IsNullRect(ActiveSkinRect) then Self.ActiveSkinRect := SkinRect;
          if IsNullRect(DownSkinRect) then Self.DownSkinRect := Self.ActiveSkinRect;
          if FFlat and Morphing then Self.Morphing := False;
          Self.DisabledSkinRect := DisabledSkinRect;
          Self.DisabledFontColor := DisabledFontColor;
          Self.AnimateSkinRect := AnimateSkinRect; 
          Self.FrameCount := FrameCount;
          Self.AnimateInterval := AnimateInterval;
          //
          Self.MenuMarkerRect := MenuMarkerRect;
          Self.MenuMarkerActiveRect := MenuMarkerActiveRect;
          Self.MenuMarkerDownRect := MenuMarkerDownRect;
          Self.MenuMarkerFlatRect := MenuMarkerFlatRect;
          Self.MenuMarkerTransparentColor := MenuMarkerTransparentColor;
          if IsNullRect(Self.MenuMarkerActiveRect)
          then
            Self.MenuMarkerActiveRect := Self.MenuMarkerRect;
          if IsNullRect(Self.MenuMarkerDownRect)
          then
            Self.MenuMarkerDownRect := Self.MenuMarkerActiveRect;
          if IsNullRect(Self.MenuMarkerFlatRect)
          then
            Self.MenuMarkerFlatRect := Self.MenuMarkerRect;
          //
          if Self.DisabledFontColor = Self.FontColor
          then
             Self.DisabledFontColor := clGray;
        end;
     if EnableAnimation and (AnimateTimer <> nil) and (CurrentFrame <= FrameCount) and
       (CurrentFrame > 0)
     then
       begin
         if AnimateInc
         then
           ActiveSkinRect := GetAnimationFrameRect
         else
           SkinRect := GetAnimationFrameRect;
       end;
   end
 else
   begin
     Morphing := False;
     ActiveSkinRect := NullRect;
   end;
end;

procedure TspSkinSpeedButton.CreateStrechButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean);
var
  TR: TRect;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  FDrawButtonDefault: Boolean;
begin
  //
  if ResizeMode = 0
  then
    B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, R)
  else
  if (ResizeMode = 2) or (ResizeMode = 3)
  then
    CreateStretchImage(B, Picture, R, ClRect, True);
  //
  TR := ClRect;
  TR.Right := TR.Right + (B.Width - RectWidth(R));
  TR.Bottom := TR.Bottom + (B.Height - RectHeight(R));
  if FShowCaption then _Caption := Caption else _Caption := '';
  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;
  with B.Canvas.Font do
  begin
    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if ADown and AMouseIn
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  FDrawButtonDefault := True;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, NewClRect, ADown, AMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault
  then

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;

      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (AMouseIn or ADown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := True;
      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil)
  then
    begin
      DrawImageAndText(B.Canvas, TR, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled,
        FDrawColorMarker, FColorMarkerValue);
    end
  else
    DrawGlyphAndText(B.Canvas,
      TR, FMargin, FSpacing, FLayout,
      _Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False,
      FDrawColorMarker, FColorMarkerValue);
end;

procedure TspSkinSpeedButton.CreateButtonImage(B: TBitMap; R: TRect;
  ADown, AMouseIn: Boolean);

var
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  FDrawButtonDefault: Boolean; 
begin
  if (not FUseSkinSize) and (ResizeMode <> 1)
  then
    begin
      CreateStrechButtonImage(B, R, ADown, AMouseIn);
      Exit;
    end;
  
  if FShowCaption then _Caption := Caption else _Caption := '';
  CreateSkinControlImage(B, Picture, R);
  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;

  with B.Canvas.Font do
  begin
    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if ADown and AMouseIn
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  FDrawButtonDefault := True;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, NewClRect, ADown, AMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault then

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;

      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (AMouseIn or ADown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := True;
      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil)
  then
    begin
      DrawImageAndText(B.Canvas, NewClRect, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled,
        FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas,
    NewClRect, FMargin, FSpacing, FLayout,
    _Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn),  False,
    FDrawColorMarker, FColorMarkerValue);
end;

procedure TspSkinSpeedButton.CreateControlDefaultImage;
var
  R: TRect;
  IsDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  FDrawButtonDefault: Boolean;
begin
  if FShowCaption then _Caption := Caption else _Caption := '';
  inherited;
  IsDown := False;
  R := ClientRect;
  if FDown and ((FMouseIn and (GroupIndex = 0)) or (GroupIndex  <> 0))
  then
    begin
      Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
      B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
      B.Canvas.FillRect(R);
      IsDown := True;
    end
  else
    if FMouseIn
    then
      begin
        Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
        B.Canvas.FillRect(R);
      end
    else
      begin
        Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
        B.Canvas.Brush.Color := clBtnFace;
        B.Canvas.FillRect(R);
      end;
  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;

   FDrawButtonDefault := True;
   if Assigned(FOnPaint)
    then
      FOnPaint(Self, Canvas, ClientRect, FDown, FMouseIn, FDrawButtonDefault);

  if FDrawButtonDefault then 

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;

      DrawImageAndText(B.Canvas, ClientRect, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if not Enabled then B.Canvas.Font.Color := clBtnShadow;
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (FMouseIn or FDown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := True;
      DrawImageAndText(B.Canvas, ClientRect, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil)
  then
    begin
      DrawImageAndText(B.Canvas, ClientRect, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled,
        FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas,
    ClientRect, FMargin, FSpacing, FLayout,
    _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False,
    FDrawColorMarker, FColorMarkerValue);
end;

procedure TspSkinSpeedButton.CreateControlSkinImage;
begin
end;

procedure TspSkinSpeedButton.Paint;
var
  PBuffer, APBuffer, PIBuffer: TspEffectBmp;
  ParentImage, Buffer, ABuffer: TBitMap;
  kf: Double;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  FDrawButtonDefault: Boolean;
begin
  if FShowCaption then _Caption := Caption else _Caption := '';
  GetSkinData;
  if FIndex = -1
  then
    begin
      if FDown and (((FMouseIn and (GroupIndex = 0)) or (GroupIndex  <> 0)))
      then
        inherited
      else
      if FMouseIn
      then
        inherited
      else
        if FFlat
        then
          begin
            Canvas.Font.Assign(FDefaultFont);
            if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
            then
              Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
            else
              Canvas.Font.CharSet := FDefaultFont.Charset;

            if not Enabled then Canvas.Font.Color := clBtnShadow;

            FDrawButtonDefault := True;

            if Assigned(FOnPaint)
            then
              FOnPaint(Self, Canvas, ClientRect, FDown, FMouseIn, FDrawButtonDefault);

            if FDrawButtonDefault then

            if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
                FUseImagesMenuImage
            then
              begin
                if FUseImagesMenuCaption
                then
                  _Caption := FSkinImagesMenu.SelectedItem.Caption;
                DrawImageAndText(Canvas, ClientRect, FMargin, FSpacing, FLayout,
                 _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
                False, Enabled, FDrawColorMarker, FColorMarkerValue);
              end
            else
            if FGlyph.Empty and (Parent is TspSkinToolBar)
            then
              begin
                if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
                then
                  IL := TspSkinToolBar(Parent).DisabledImages
                else
                  IL := TspSkinToolBar(Parent).Images;
                 E := Enabled;
                 if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
                 then
                   E := True;
                  DrawImageAndText(Canvas, ClientRect, FMargin, FSpacing, FLayout,
                    _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
              end
            else
            if FGlyph.Empty and (FButtonImages <> nil)
            then
              begin
                DrawImageAndText(Canvas, ClientRect, FMargin, FSpacing, FLayout,
                  _Caption, FImageIndex, FButtonImages, False, Enabled,
                  FDrawColorMarker, FColorMarkerValue);
              end
            else
            DrawGlyphAndText(Canvas,
              ClientRect, FMargin, FSpacing, FLayout,
              _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False,
              FDrawColorMarker, FColorMarkerValue);
          end
        else
          inherited;
    end
  else
    if FFlat and not FMouseIn and not (FDown and (FGroupIndex <> 0))
    then
      begin
        with Canvas.Font do
        begin
           if FUseSkinFont
           then
              begin
                Name := FontName;
                Style := FontStyle;
              end
            else
              Canvas.Font.Assign(FDefaultFont);

            if Self.Enabled
            then
              begin
                if FUseSkinFontColor
                then
                  Color := SkinData.SkinColors.cBtnText
                else
                  Color := FDefaultFont.Color;
              end
            else
              Color := SkinData.SkinColors.cBtnShadow;

           if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
           then
             Charset := SkinData.ResourceStrData.CharSet
           else
            CharSet := FDefaultFont.Charset;

           if FUseSkinFont
           then
            Height := FontHeight;
        end;

        FDrawButtonDefault := True;

        if Assigned(FOnPaint)
        then
          FOnPaint(Self, Canvas, NewClRect, FDown, FMouseIn, FDrawButtonDefault);

        if FDrawButtonDefault then
        
        if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
            FUseImagesMenuImage
         then
           begin
             if FUseImagesMenuCaption
             then
               _Caption := FSkinImagesMenu.SelectedItem.Caption;
                DrawImageAndText(Canvas, NewClRect, FMargin, FSpacing, FLayout,
                 _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
                False, Enabled, FDrawColorMarker, FColorMarkerValue);
           end
        else
        if FGlyph.Empty and (Parent is TspSkinToolBar)
        then
          begin
            if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
            then
              IL := TspSkinToolBar(Parent).DisabledImages
            else
              IL := TspSkinToolBar(Parent).Images;
            E := Enabled;
            if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
            then
              E := True;

             DrawImageAndText(Canvas, NewClRect, FMargin, FSpacing, FLayout,
               _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
           end
        else
        if FGlyph.Empty and (FButtonImages <> nil)
        then
          begin
            DrawImageAndText(Canvas, NewClRect, FMargin, FSpacing, FLayout,
                    _Caption, FImageIndex, FButtonImages, False, Enabled,
                    FDrawColorMarker, FColorMarkerValue);
          end
        else
         DrawGlyphAndText(Canvas,
          NewClRect, FMargin, FSpacing, FLayout,
          _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False,
          FDrawColorMarker, FColorMarkerValue);
      end
    else
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      ParentImage := nil;
      if FAlphaBlend
      then
        begin
          ParentImage := TBitMap.Create;
          ParentImage.Width := Width;
          ParentImage.Height := Height;
          GetParentImage(Self, ParentImage.Canvas);
          PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
          kf := 1 - FAlphaBlendValue / 255;
        end;

      if EnableMorphing and (FMorphKf <> 1) and (FMorphKf <> 0) and Enabled
      then
        begin
          ABuffer := TBitMap.Create;
          ABuffer.Width := Width;
          ABuffer.Height := Height;
          CreateButtonImage(Buffer, SkinRect, False, False);
          CreateButtonImage(ABuffer, ActiveSkinRect, False, True);
          PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
          APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
          case MorphKind of
            mkDefault: PBuffer.Morph(APBuffer, FMorphKf);
            mkGradient: PBuffer.MorphGrad(APBuffer, FMorphKf);
            mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, FMorphKf);
            mkRightGradient: PBuffer.MorphRightGrad(APBuffer, FMorphKf);
            mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, FMorphKf);
            mkRightSlide: PBuffer.MorphRightSlide(APBuffer, FMorphKf);
            mkPush: PBuffer.MorphPush(APBuffer, FMorphKf);
          end;
          if FAlphaBlend then PBuffer.Morph(PIBuffer, Kf);
          PBuffer.Draw(Canvas.Handle, 0, 0);
          PBuffer.Free;
          APBuffer.Free;
          ABuffer.Free;
        end
      else
        begin
          if (not Enabled) and not IsNullRect(DisabledSkinRect)
          then
            CreateButtonImage(Buffer, DisabledSkinRect, False, False)
          else
          if FDown and ((FMouseIn and (GroupIndex = 0)) or (GroupIndex  <> 0))
          then
            CreateButtonImage(Buffer, DownSkinRect, True, True)
          else
            if FMouseIn or (not FMouseIn and EnableMorphing and (FMorphKf = 1))
            then
              CreateButtonImage(Buffer, ActiveSkinRect, False, True)
            else
              CreateButtonImage(Buffer, SkinRect, False, False);

          if FAlphaBlend
          then
            begin
              PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
              PBuffer.Morph(PIBuffer, Kf);
              PBuffer.Draw(Canvas.Handle, 0, 0);
              PBuffer.Free;
             end
          else
            Canvas.Draw(0, 0, Buffer);
        end;

      if FAlphaBlend
      then
        begin
          PIBuffer.Free;
          ParentImage.Free;
        end;
      Buffer.Free;
    end;
end;

procedure TspSkinSpeedButton.CMTextChanged;
begin
  if (FIndex <> -1) or
     (csDesigning in ComponentState) or DrawDefault
  then
    RePaint;
end;

procedure TspSkinSpeedButton.CMMouseEnter(var Message: TMessage);
var
  CanPaint: Boolean;
begin
  CanPaint := ((GroupIndex <> 0) and not FDown) or (GroupIndex = 0);
  if CanPaint and not Enabled then CanPaint := False;
  //
  if FFlat and CanPaint and not (csDesigning in ComponentState)
  then SetTempTransparent(False);
  //
  inherited;
  if not Enabled then Exit;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  if CanPaint
  then
    begin
      if FDown
      then
        begin
          if EnableMorphing then FMorphKf := 1; 
          RePaint;
        end  
      else
        begin
          if (FIndex <> -1) and EnableAnimation and not IsNullRect(AnimateSkinRect) then StartAnimate(True);
          ReDrawControl;
        end;
    end;
  if FDown and RepeatMode and (GroupIndex = 0) then StartRepeat;  
end;


procedure TspSkinSpeedButton.CMMouseLeave(var Message: TMessage);
var
  CanPaint: Boolean;
begin
  CanPaint := ((GroupIndex <> 0) and not FDown) or (GroupIndex = 0);
  if CanPaint and not Enabled then CanPaint := False;
  //
  if FFlat and CanPaint and not (csDesigning in ComponentState)
  then SetTempTransparent(True);
  //
  inherited;
  if not Enabled then Exit;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
  if CanPaint
  then
    begin
      if (FIndex <> -1) and EnableAnimation and not IsNullRect(AnimateSkinRect) then StartAnimate(False);
      ReDrawControl;
    end;
  if FDown and RepeatMode and (RepeatTimer <> nil) and (GroupIndex = 0) then StopRepeat;
end;

procedure TspSkinSpeedButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {$IFDEF VER200}
  if ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and FMouseIn and FDown
  then
    Perform(CM_MOUSELEAVE, 0, 0)
  else
  if not ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and not FMouseIn and FDown
  then
    Perform(CM_MOUSEENTER, 0, 0);
  {$ENDIF}
end;

procedure TspSkinSpeedButton.MouseDown;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      if (FIndex <> -1) and EnableAnimation and not IsNullRect(AnimateSkinRect) then StopAnimate;
      FMouseDown := True;
      if not FDown
      then
        begin
          FMouseIn := True;
          Down := True;
          //
          if FCheckedMode
          then
            begin
              FStopMouseUp := True;
              ButtonClick;
            end
          else
          if FRepeatMode and (GroupIndex = 0)
          then
            StartRepeat
          else
            if (GroupIndex <> 0) then ButtonClick;
          //
          FAllowAllUpCheck := False;
        end
      else
        if (GroupIndex <> 0) then FAllowAllUpCheck := True;
    end;
end;

procedure TspSkinSpeedButton.MouseUp;
var
  CheckDown: Boolean;
begin
  if Button = mbLeft
  then
    begin
      FMouseDown := False;
      CheckDown := FDown;
       if FCheckedMode
      then
        begin
          if not FStopMouseUp
          then
            begin
              Down := False;
              ButtonClick;
            end
          else
            FStopMouseUp := False;
      end
      else
      if GroupIndex = 0
      then
        begin
          if FMouseIn
          then
            begin
              Down := False;
              if RepeatMode then StopRepeat;
              if CheckDown then ButtonClick
           end
            else
              begin
                FDown := False;
                if RepeatMode and (RepeatTimer <> nil) then StopRepeat;
              end;
         end
      else
        if (GroupIndex <> 0) and FDown and FAllowAllUp and
           FAllowAllUpCheck and FMouseIn
        then
          begin
            Down := False;
            ButtonClick;
          end;  
    end;
  inherited;
end;

//==============TspSkinMenuSpeedButton==========//
constructor TspSkinMenuSpeedButton.Create;
begin
  inherited;
  FSkinDataName := 'toolmenubutton';
  FDrawStandardArrow := False;
  FTrackButtonMode := False;
  FMenuTracked := False;
  FSkinPopupMenu := nil;
  FNewStyle := False;
  FTrackPosition := sptpRight;
end;

destructor TspSkinMenuSpeedButton.Destroy;
begin
  inherited;
end;

procedure TspSkinMenuSpeedButton.SetTrackPosition(Value: TspTrackPosition);
begin
  FTrackPosition := Value;
  RePaint;
end;

procedure TspSkinMenuSpeedButton.SetNewStyle;
begin
  FNewStyle := Value;
  if FNewStyle then SkinDataName := 'resizetoolbutton';
end;

procedure TspSkinMenuSpeedButton.DrawResizeButton(ButtonData: TspDataSkinButtonControl;
  C: TCanvas; ButtonR: TRect; AMouseIn, ADown: Boolean);
var
  Buffer: TBitMap;
  CIndex: Integer;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  BSR, ABSR, DBSR, R1: TRect;
  XO, YO: Integer;
begin
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(ButtonR);
  Buffer.Height := RectHeight(ButtonR);
  //
  with ButtonData do
  begin
    XO := RectWidth(ButtonR) - RectWidth(SkinRect);
    YO := RectHeight(ButtonR) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(SkinData.FActivePictures.Items[ButtonData.PictureIndex]);

    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if ADown and AMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
      end
    else
    if AMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
      end
    else
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
      end;
   end;
  C.Draw(ButtonR.Left, ButtonR.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinMenuSpeedButton.CreateNewStyleControlSkinResizeImage;
var
  isDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  R, R1, R2: TRect;
  ButtonData1, ButtonData2: TspDataSkinButtonControl;
  CIndex: Integer;
begin
  if FShowCaption then _Caption := Caption  else _Caption := '';

  R1 := Rect(0, 0, Width, Height);

  if TrackButtonMode and AMouseIn
  then
    begin
      if (TrackPosition = sptpRight)
      then
       begin
         R1 := Rect(0, 0, Width - 15, Height);
         R2 := Rect(Width - 15, 0, Width, Height);
       end
      else
       begin
         R1 := Rect(0, 0, Width, Height - 15);
         R2 := Rect(0, Height - 15, Width, Height);
       end;
     end
  else
    if (TrackPosition = sptpRight)
    then
      R2 := Rect(Width - 15, 0, Width, Height)
    else
      R2 := Rect(0, Height - 15, Width, Height);

  CIndex := FSD.GetControlIndex('resizetoolbutton');
  if CIndex = -1 then CIndex := FSD.GetControlIndex('resizebutton');
  if CIndex = -1 then Exit;
  ButtonData1 := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);

  if FTrackButtonMode and AMouseIn
  then
    begin
      if TrackPosition = sptpRight
      then
        CIndex := FSD.GetControlIndex('vtracktoolbutton')
      else
        CIndex := FSD.GetControlIndex('htracktoolbutton');
      if CIndex = -1
      then
        ButtonData2 := ButtonData1
      else
        begin
          ButtonData2 := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);
          R1 := Rect(0, 0, Width, Height);
        end;
    end;

  IsDown := AMouseIn and ADown;

  if FTrackButtonMode and FMenuTracked then isDown := False;

  DrawResizeButton(ButtonData1, B.Canvas, R1, AMouseIn, IsDown);

  if TrackPosition = sptpRight
  then
    R1 := Rect(0, 0, Width - 15, Height)
  else
    R1 := Rect(0, 0, Width, Height - 15);

  if FTrackButtonMode and AMouseIn
  then
    begin
      DrawResizeButton(ButtonData2, B.Canvas, R2, AMouseIn, FMenuTracked);
    end;

  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if IsDown
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;

      DrawImageAndText(B.Canvas, R1, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (AMouseIn or ADown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := False;
      DrawImageAndText(B.Canvas, R1, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FButtonImages.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R1, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas, R1, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False,
                  FDrawColorMarker, FColorMarkerValue);

  R := R2;

  IsDown := AMouseIn and ADown;

  if FTrackButtonMode and not FMenuTracked then isDown := False;

 if not IsNullRect(MenuMarkerRect)
  then
    begin
      DrawMenuMarker(B.Canvas, R, AMouseIn, False, False);
    end
  else
  if FMenuTracked
  then
    DrawTrackArrowImage(B.Canvas, R, DownFontColor)
  else
    DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;

procedure TspSkinMenuSpeedButton.CreateNewStyleControlDefaultImage(B: TBitMap);
var
  R, R1: TRect;
  isDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
begin
  if FShowCaption then _Caption := Caption  else _Caption := '';
  isDown := False;

  R := Rect(0, 0, Width, Height);

  if TrackPosition = sptpBottom
  then
    R1 := Rect(0, Height - 15, Width, Height)
  else
    R1 := Rect(Width - 15, 0, Width, Height);

  if FTrackButtonMode and FMouseIn
  then
    begin
      if TrackPosition = sptpBottom
      then
        begin
          R := Rect(0, 0, Width, Height - 15);
          R1 := Rect(0, Height - 15, Width, Height);
        end
      else
        begin
          R := Rect(0, 0, Width - 15, Height);
          R1 := Rect(Width - 15, 0, Width, Height);
        end;
      if FMenuTracked
      then
        begin
          B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          B.Canvas.FillRect(R);
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R1);
          Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        end
      else
        begin
          if FDown and FMouseIn
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R1);
              isDown := True;
            end
          else
          if FMouseIn
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R1);
            end
          else
            if not FFlat
            then
              begin
                Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
                B.Canvas.Brush.Color := clBtnFace;
                B.Canvas.FillRect(R);
                Frame3D(B.Canvas, R1, clBtnShadow, clBtnShadow, 1);
                B.Canvas.Brush.Color := clBtnFace;
                B.Canvas.FillRect(R1);
              end
            else
              begin
                B.Canvas.Brush.Color := clBtnFace;
                B.Canvas.FillRect(R);
                B.Canvas.FillRect(R1);
              end;
        end;
    end
  else
    begin
      if FDown and FMouseIn
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R);
          IsDown := True;
        end
      else
        if FMouseIn
        then
          begin
            Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
            B.Canvas.FillRect(R);
          end
       else
         begin
           if not FFlat
           then
             Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
           B.Canvas.Brush.Color := clBtnFace;
           B.Canvas.FillRect(R);
         end;
    end;

  R := ClientRect;

  if TrackPosition = sptpBottom
  then
    Dec(R.Bottom, 15)
  else
    Dec(R.Right, 15);

  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;

  if not Enabled then B.Canvas.Font.Color := clBtnShadow;
  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
     then
      begin
        if FUseImagesMenuCaption
        then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;

        DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
          _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
      end
   else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (FMouseIn or FDown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := False;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FButtonImages.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn),  False, FDrawColorMarker, FColorMarkerValue);

  R := R1;

  IsDown := FMouseIn and FDown;

  if FTrackButtonMode and not FMenuTracked then isDown := False;

  DrawTrackArrowImage(B.Canvas, R, clBtnText);
end;

procedure TspSkinMenuSpeedButton.Paint;
var
  R: TRect;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
begin
  if FShowCaption then _Caption := Caption else _Caption := '';
  GetSkinData;
  if FFlat and not FMouseIn and not FDown and not FMenuTracked
  then
    begin
       if (FIndex = -1) or (SkinDataName = 'resizebutton') or (SkinDataName = 'toolbutton')
         or (SkinDataName = 'bigtoolbutton') or (SkinDataName = 'resizetoolbutton')
      then
        begin
          R := ClientRect;
          if NewStyle and (FTrackPosition = sptpBottom)
          then
            Dec(R.Bottom, 15)
          else
            Dec(R.Right, 15);
        end
      else
        R := NewClRect;
        

     if FUseSkinFont and (FIndex <> -1)
     then
       with Canvas.Font do
       begin
         Name := FontName;
         Style := FontStyle;
         Height := FontHeight;
       end
     else
       Canvas.Font.Assign(FDefaultFont);

     if FIndex <> -1
     then
       with Canvas.Font do
       begin
         if Enabled
         then
           begin
             if FUseSkinFontColor
             then Color := FSD.SkinColors.cBtnText
             else Color := FDefaultFont.Color;
           end
         else
           Color := FSD.SkinColors.cBtnShadow;
       end;


      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Canvas.Font.CharSet := FDefaultFont.Charset;

      if not Enabled then Canvas.Font.Color := clBtnShadow;
      if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
          FUseImagesMenuImage
      then
        begin
          if FUseImagesMenuCaption
          then
            _Caption := FSkinImagesMenu.SelectedItem.Caption;
           DrawImageAndText(Canvas, R, FMargin, FSpacing, FLayout,
            _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
           False, Enabled, FDrawColorMarker, FColorMarkerValue);
        end
      else
      if FGlyph.Empty and (Parent is TspSkinToolBar)
      then
        begin
          if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
          then
            IL := TspSkinToolBar(Parent).DisabledImages
          else
            IL := TspSkinToolBar(Parent).Images;
          E := Enabled;
          if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
          then
            E := True;
          DrawImageAndText(Canvas, R, FMargin, FSpacing, FLayout,
           _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
        end
      else
      if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
       (FImageIndex < FButtonImages.Count)
      then
        begin
          DrawImageAndText(Canvas, R, FMargin, FSpacing, FLayout,
         _Caption, FImageIndex, FButtonImages, False, Enabled, FDrawColorMarker, FColorMarkerValue);
       end
      else
      DrawGlyphAndText(Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), False,
                  FDrawColorMarker, FColorMarkerValue);

      if (FIndex <> -1) and (SkinDataName <> 'resizebutton') and
         (SkinDataName <> 'toolbutton') and (SkinDataName <> 'bigtoolbutton') and
         (SkinDataName <> 'resizetoolbutton')
      then
        begin
          R.Left := R.Right;
          R.Right := Width;
        end
      else
        begin
          if NewStyle and (FTrackPosition = sptpBottom)
          then
            begin
              R.Top := Height - 15;
              R.Bottom := Height;
            end
          else
            begin
              R.Left := Width - 15;
              R.Right := Width;
            end;  
         end;

      if (FIndex <> -1) and not IsNullRect(MenuMarkerFlatRect)
      then
        begin
          DrawMenuMarker(Canvas, R, False, False, True);
        end
      else
      if FIndex = -1
      then
        DrawTrackArrowImage(Canvas, R, clBtnText)
      else
        DrawTrackArrowImage(Canvas, R, SkinData.SkinColors.cBtnText);
    end
  else
    inherited;
end;

procedure TspSkinMenuSpeedButton.CreateControlSkinResizeImage2;
var
  R, R1: TRect;
  isDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  B1, B2: TBitMap;
  SRect, ARect, DRect: TRect;
begin
  if FShowCaption then _Caption := Caption  else _Caption := '';
  isDown := False;
  R := Rect(0, 0, Width, Height);
  SRect := SkinRect;
  if IsNullRect(ActiveSkinRect) then ARect := SRect else ARect := ActiveSkinRect;
  if IsNullRect(DownSkinRect) then DRect := ARect else DRect := DownSkinRect;

  if FTrackButtonMode
  then
    begin
      B1 := TBitMap.Create;
      B1.Width := Width - 15;
      B1.Height := Height;
      B2 := TBitMap.Create;
      B2.Width := 15;
      B2.Height := Height;
      if FMenuTracked
      then
        begin
          CreateStretchImage(B1, Picture, ARect, ClRect, True);
          CreateStretchImage(B2, Picture, DRect, ClRect, True);
          B.Canvas.Draw(0, 0, B1);
          B.Canvas.Draw(Width - 15, 0, B2);
        end
      else
        begin
          if ADown and AMouseIn
          then
            begin
              CreateStretchImage(B1, Picture, DRect, ClRect, True);
              CreateStretchImage(B2, Picture, DRect, ClRect, True);
              B.Canvas.Draw(0, 0, B1);
              B.Canvas.Draw(Width - 15, 0, B2);
              isDown := True;
            end
          else
          if AMouseIn
          then
            begin
              CreateStretchImage(B1, Picture, ARect, ClRect, True);
              CreateStretchImage(B2, Picture, ARect, ClRect, True);
              B.Canvas.Draw(0, 0, B1);
              B.Canvas.Draw(Width - 15, 0, B2);
            end
          else
            if not FFlat
            then
              begin
                CreateStretchImage(B1, Picture, SRect, ClRect, True);
                CreateStretchImage(B2, Picture, SRect, ClRect, True);
                B.Canvas.Draw(0, 0, B1);
                B.Canvas.Draw(Width - 15, 0, B2);
              end;
        end;
      B1.Free;
      B2.Free;
    end
  else
    begin
      if ADown and AMouseIn
      then
        begin
          CreateStretchImage(B, Picture, DRect, ClRect, True);
          IsDown := True;
        end
      else
        if AMouseIn
        then
          begin
            CreateStretchImage(B, Picture, ARect, ClRect, True);
          end
       else
         begin
           if not FFlat
           then
             begin
               CreateStretchImage(B, Picture, SRect, ClRect, True);
             end;
         end;
    end;

  R := ClientRect;
  Dec(R.Right, 15);

  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if IsDown
    then
      Color := DownFontColor
    else
      if AMouseIn
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
          FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;
        DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (AMouseIn or ADown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := False;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FButtonImages.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else  
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False,
                  FDrawColorMarker, FColorMarkerValue);
  R.Left := Width - 15;
  Inc(R.Right, 15);

  if FDrawStandardArrow
  then
    begin
      DrawArrowImage(B.Canvas, R, B.Canvas.Font.Color, FArrowType);
    end
  else
  if not IsNullRect(MenuMarkerRect)
  then
    begin
      DrawMenuMarker(B.Canvas, R, AMouseIn, (ADown and AMouseIn) or FMenuTracked, False);
    end
  else
  if FMenuTracked
  then
    DrawTrackArrowImage(B.Canvas, R, DownFontColor)
  else
    DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;

procedure TspSkinMenuSpeedButton.CreateControlSkinResizeImage;
var
  R, R1: TRect;
  isDown: Boolean;

  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
  B1, B2: TBitMap;
  SRect, ARect, DRect: TRect;
  NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1: TPoint;
  NewClRect1: TRect;
  NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2: TPoint;
  NewClRect2: TRect;
  XO, YO: Integer;
begin
  if FShowCaption then _Caption := Caption  else _Caption := '';
  isDown := False;
  R := Rect(0, 0, Width, Height);
  SRect := SkinRect;
  if IsNullRect(ActiveSkinRect) then ARect := SRect else ARect := ActiveSkinRect;
  if IsNullRect(DownSkinRect) then DRect := ARect else DRect := DownSkinRect;

  if FTrackButtonMode
  then
    begin
      XO := (Width - 15) - RectWidth(SRect);
      YO := Height - RectHeight(SRect);

      NewLTPoint1 := LTPt;
      NewRTPoint1 := Point(RTPt.X + XO, RTPt.Y);
      NewLBPoint1 := Point(LBPt.X, LBPt.Y + YO);
      NewRBPoint1 := Point(RBPt.X + XO, RBPt.Y + YO);
      NewClRect1 := Rect(CLRect.Left, ClRect.Top,
       CLRect.Right + XO, ClRect.Bottom + YO);

      XO := 15 - RectWidth(SRect);
      YO := Height - RectHeight(SRect);

      NewLTPoint2 := LTPt;
      NewRTPoint2 := Point(RTPt.X + XO, RTPt.Y);
      NewLBPoint2 := Point(LBPt.X, LBPt.Y + YO);
      NewRBPoint2 := Point(RBPt.X + XO, RBPt.Y + YO);
      NewClRect2 := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    end;  

  if FTrackButtonMode
  then
    begin
      R := Rect(0, 0, Width - 15, Height);
      R1 := Rect(Width - 15, 0, Width, Height);
      B1 := TBitMap.Create;
      B2 := TBitMap.Create;
      if FMenuTracked
      then
        begin
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
            B1, Picture, ARect, Self.Width - 15, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
            B.Canvas.Draw(0, 0, B1);
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
            B2, Picture, DRect, 15, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          B.Canvas.Draw(Self.Width - 15, 0, B2);
        end
      else
        begin
          if ADown and AMouseIn
          then
            begin
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
                B1, Picture, DRect, Self.Width - 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(0, 0, B1);
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                B2, Picture, DRect, 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
              isDown := True;
            end
          else
          if AMouseIn
          then
            begin
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
                B1, Picture, ARect, Self.Width - 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(0, 0, B1);
              CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                B2, Picture, ARect, 15, Height, True,
                LeftStretch, TopStretch, RightStretch, BottomStretch,
                StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
            end
          else
            if not FFlat
            then
              begin
                CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                  NewLtPoint1, NewRTPoint1, NewLBPoint1, NewRBPoint1, NewCLRect1,
                  B1, Picture, SRect, Self.Width - 15, Height, True,
                  LeftStretch, TopStretch, RightStretch, BottomStretch,
                  StretchEffect, StretchType);
                B.Canvas.Draw(0, 0, B1);
                CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
                  NewLtPoint2, NewRTPoint2, NewLBPoint2, NewRBPoint2, NewCLRect2,
                  B2, Picture, SRect, 15, Height, True,
                  LeftStretch, TopStretch, RightStretch, BottomStretch,
                  StretchEffect, StretchType);
                B.Canvas.Draw(Self.Width - 15, 0, B2);
              end;
        end;
      B1.Free;
      B2.Free;
    end
  else
    begin
      if ADown and AMouseIn
      then
        begin
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, DRect, Width, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          IsDown := True;
        end
      else
        if AMouseIn
        then
          begin
            CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
              NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, ARect, Width, Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
          end
       else
         begin
           if not FFlat
           then
             begin
               CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
               NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
                 B, Picture, SRect, Width, Height, True,
                 LeftStretch, TopStretch, RightStretch, BottomStretch,
                 StretchEffect, StretchType);
             end;
         end;
    end;
  R := ClientRect;
  Dec(R.Right, 15);

  if not FUseSkinFont
  then
    B.Canvas.Font.Assign(FDefaultFont)
  else
    with B.Canvas.Font do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  with B.Canvas.Font do
  begin

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;

    if Enabled and not FUseSkinFontColor
    then
      begin
        Color := FDefaultFont.Color;
      end
    else
    if not Enabled
    then
      Color := DisabledFontColor
    else
    if IsDown
    then
      Color := DownFontColor
    else
      if AMouseIn 
      then Color := ActiveFontColor
      else Color := FontColor;
  end;

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
          FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;
        DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (AMouseIn or ADown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := False;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FButtonImages.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn),  False,
                  FDrawColorMarker, FColorMarkerValue);
  R.Left := Width - 15;
  Inc(R.Right, 15);

  if FDrawStandardArrow
  then
    begin
      DrawArrowImage(B.Canvas, R, B.Canvas.Font.Color, FArrowType);
    end
  else
  if not IsNullRect(MenuMarkerRect)
  then
    begin
      DrawMenuMarker(B.Canvas, R, AMouseIn, (ADown and AMouseIn) or FMenuTracked, False);
    end
  else
  if FMenuTracked
  then
    DrawTrackArrowImage(B.Canvas, R, DownFontColor)
  else
    DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;

procedure TspSkinMenuSpeedButton.CreateButtonImage;
begin
  if NewStyle and (SkinDataName = 'resizetoolbutton')
  then
    begin
      CreateNewStyleControlSkinResizeImage(B, ADown, AMouseIn);
    end
  else
  if (SkinDataName = 'toolbutton') or (SkinDataName = 'bigtoolbutton')
  then
    begin
      CreateControlSkinResizeImage2(B, ADown, AMouseIn);
    end
  else
  if (SkinDataName = 'resizebutton') or (SkinDataName = 'resizetoolbutton')
  then
    begin
      CreateControlSkinResizeImage(B, ADown, AMouseIn);
    end
  else
  if FMenuTracked and FTrackButtonMode and
     not IsNullRect(TrackButtonRect) and not IsNullRect(DownSkinRect)
  then
    begin
      inherited CreateButtonImage(B, ActiveSkinRect, False, True);
      R := TrackButtonRect;
      OffsetRect(R, DownSkinRect.Left, DownSkinRect.Top);
        B.Canvas.CopyRect(GetNewTrackButtonRect, Picture.Canvas,
       R);
    end
  else
    inherited;
end;

procedure TspSkinMenuSpeedButton.CreateControlDefaultImage;
var
  R, R1: TRect;
  isDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
begin
  if FNewStyle
  then
    begin
      CreateNewStyleControlDefaultImage(B);
      Exit;
    end;

  if FShowCaption then _Caption := Caption else _Caption := '';
  isDown := False;
  R := Rect(0, 0, Width, Height);
  if FTrackButtonMode
  then
    begin
      R := Rect(0, 0, Width - 15, Height);
      R1 := Rect(Width - 15, 0, Width, Height);
      if FMenuTracked
      then
        begin
          B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          B.Canvas.FillRect(R);
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R1);
          Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        end
      else
        begin
          if FDown and FMouseIn
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
              B.Canvas.FillRect(R1);
              isDown := True;
            end
          else
          if FMouseIn
          then
            begin
              Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
              B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
              B.Canvas.FillRect(R1);
            end
          else
            begin
              Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
              B.Canvas.Brush.Color := clBtnFace;
              B.Canvas.FillRect(R);
              Frame3D(B.Canvas, R1, clBtnShadow, clBtnShadow, 1);
              B.Canvas.Brush.Color := clBtnFace;
              B.Canvas.FillRect(R1);
            end
        end;
    end
  else
    begin
      if FDown and FMouseIn
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R);
          IsDown := True;
        end
      else
        if FMouseIn
        then
          begin
            Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
            B.Canvas.FillRect(R);
          end
       else
         begin
           Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
           B.Canvas.Brush.Color := clBtnFace;
           B.Canvas.FillRect(R);
         end;
    end;
  R := ClientRect;
  Dec(R.Right, 15);
  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;
    
  if not Enabled then B.Canvas.Font.Color := clBtnShadow;
   if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
          FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        _Caption := FSkinImagesMenu.SelectedItem.Caption;
        DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        False, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (Parent is TspSkinToolBar)
  then
    begin
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        IL := TspSkinToolBar(Parent).DisabledImages
      else
      if (FMouseIn or FDown) and (TspSkinToolBar(Parent).HotImages <> nil)
      then
        IL := TspSkinToolBar(Parent).HotImages
      else
        IL := TspSkinToolBar(Parent).Images;
      E := Enabled;
      if not Enabled and (TspSkinToolBar(Parent).DisabledImages <> nil)
      then
        E := False;
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, IL, False, E, FDrawColorMarker, FColorMarkerValue);
    end
  else
  if FGlyph.Empty and (FButtonImages <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FButtonImages.Count)
  then
    begin
      DrawImageAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
        _Caption, FImageIndex, FButtonImages, isDown, Enabled, FDrawColorMarker, FColorMarkerValue);
    end
  else
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn),  isDown,
                  FDrawColorMarker, FColorMarkerValue);
  R.Left := Width - 15;
  Inc(R.Right, 15);
  if (FDown and FMouseIn) or FMenuTracked
  then
    begin
      Inc(R.Top, 2);
      Inc(R.Left, 2);
    end;
  DrawTrackArrowImage(B.Canvas, R, clBtnText);
end;


function TspSkinMenuSpeedButton.GetNewTrackButtonRect;
var
  RM, Off: Integer;
  R: TRect;
begin
  RM := GetResizeMode;
  R := TrackButtonRect;
  case RM of
    2:
      begin
        Off := Width - RectWidth(SkinRect);
        OffsetRect(R, Off, 0);
      end;
    3:
      begin
        Off := Height - RectHeight(SkinRect);
        OffsetRect(R, 0, Off);
      end;
  end;
  Result := R;
end;

function TspSkinMenuSpeedButton.CanMenuTrack;
var
  R: TRect;
begin
   if (FSkinPopupMenu = nil) and (FSkinImagesMenu = nil)
  then
    begin
     Result := False;
     Exit;
   end;
   if not FTrackButtonMode
   then
     Result := True
   else
     begin
       if (FIndex <> -1) and (SkinDataName <> 'resizebutton') and
       (SkinDataName <> 'resizetoolbutton') and (SkinDataName <> 'toolbutton')
       and (SkinDataName <> 'bigtoolbutton')
       then R := GetNewTrackButtonRect
       else
         if NewStyle
         then
           begin
             if TrackPosition = sptpRight
             then
               R := Rect(Width - 15, 0, Width, Height)
             else
               R := Rect(0, Height - 15, Width, Height);
           end
         else
          R := Rect(Width - 15, 0, Width, Height);
       Result := PointInRect(R, Point(X, Y));
     end;
end;

procedure TspSkinMenuSpeedButton.WMCLOSESKINMENU;
begin
  FMenuTracked := False;
  Down := False;
  FMouseIn := False;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
  RePaint;
end;

procedure TspSkinMenuSpeedButton.OnImagesMenuClose;
begin
  FMenuTracked := False;
  Down := False;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinMenuSpeedButton.TrackMenu;
var
  R: TRect;
  P: TPoint;
begin
  if FSkinPopupMenu <> nil
  then
    begin
      //
      if FFlat and not IsTransparent then SetTempTransparent(True);
      //
      if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self);
      P := ClientToScreen(Point(0, 0));
      R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
      FSkinPopupMenu.PopupFromRect2(Self, R, False);
    end;
  if FSkinImagesMenu <> nil
  then
    begin
      //
      if FFlat and not IsTransparent then SetTempTransparent(True);
      //
      if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self);
      P := ClientToScreen(Point(0, 0));
      R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
      FSkinImagesMenu.OnInternalMenuClose := OnImagesMenuClose;
      FSkinImagesMenu.PopupFromRect(R);
    end;
end;

procedure TspSkinMenuSpeedButton.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinPopupMenu)
  then FSkinPopupMenu := nil;
end;

procedure TspSkinMenuSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then Exit;
  if not FMenuTracked then inherited else FMouseIn := True;
end;

procedure TspSkinMenuSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then Exit;
  if not FMenuTracked then inherited else FMouseIn := False;
end;

procedure TspSkinMenuSpeedButton.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinMenuButtonControl
    then
      with TspDataSkinMenuButtonControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.TrackButtonRect := TrackButtonRect;
      end;
end;

procedure TspSkinMenuSpeedButton.SetTrackButtonMode;
begin
  FTrackButtonMode := Value;
  if FIndex = - 1 then RePaint;
end;

procedure TspSkinMenuSpeedButton.MouseDown;
begin
 if Button <> mbLeft
  then
    begin
      inherited;
      Exit;
    end;
  FMenuTracked := CanMenuTrack(X, Y);
  FMouseIn := True;
  if FMenuTracked
  then
    begin
      if not FDown then Down := True;
      TrackMenu;
    end
  else
    inherited;
end;

procedure TspSkinMenuSpeedButton.MouseUp;
begin
  if not FMenuTracked then inherited;
end;

constructor TspSkinTextLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable] - [csOpaque];
  Width := 65;
  Height := 65;
  FAutoSize := True;
  FLines := TStringList.Create;
  TStringList(FLines).OnChange := OnTextChange;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  FUseSkinFont := True;
  FUseSkinColor := True;
end;

destructor TspSkinTextLabel.Destroy;
begin
  FLines.Free;
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinTextLabel.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinTextLabel.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;


procedure TspSkinTextLabel.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinStdLabelControl
    then
      with TspDataSkinStdLabelControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
      end;
end;

procedure TspSkinTextLabel.ChangeSkinData;
begin
  GetSkinData;
  if FAutoSize then AdjustBounds;
  RePaint;
end;

procedure TspSkinTextLabel.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then ChangeSkinData;
end;

procedure TspSkinTextLabel.SetLines;
begin
  FLines.Assign(Value);
  RePaint;
end;

function TspSkinTextLabel.GetLabelText: string;
begin
  Result := FLines.Text;
end;

procedure TspSkinTextLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  LText: string;
begin
  GetSkinData;

  LText := GetLabelText;
  Flags := DrawTextBiDiModeFlags(Flags);

  if FIndex <> -1
  then
    with Canvas.Font do
    begin
      if FUseSkinFont
      then
        begin
          Name := FontName;
          Style := FontStyle;
          Height := FontHeight;
        end
      else
        Canvas.Font := Self.Font;
      if FUseSkinColor then Color := FontColor else Color := Self.Font.Color;
    end
  else
    if FUseSkinFont
    then
      Canvas.Font := DefaultFont
    else
      Canvas.Font := Self.Font;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Canvas.Font.CharSet := FDefaultFont.Charset;

  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    if FIndex <> -1
    then
      Canvas.Font.Color := FSD.SkinColors.cBtnHighLight
    else
      Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    if FIndex <> -1
    then
      Canvas.Font.Color := FSD.SkinColors.cBtnShadow
    else
      Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
  end
  else
   begin
      DrawText(Canvas.Handle, PChar(LText), Length(LText), Rect, Flags);
    end;
end;

procedure TspSkinTextLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    Rect := ClientRect;
    { DoDrawText takes care of BiDi alignments }
    DrawStyle := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];
    { Calculate vertical layout }
    if FLayout <> tlTop then
    begin
      CalcRect := Rect;
      DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
      Dec(CalcRect.Bottom, Canvas.TextHeight('A'));
      if FLayout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
    DoDrawText(Rect, DrawStyle);
  end;
end;

procedure TspSkinTextLabel.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TspSkinTextLabel.OnTextChange(Sender: TObject);
begin
  if FAutoSize then AdjustBounds;
  RePaint;
end;

procedure TspSkinTextLabel.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  X: Integer;
  Rect, R: TRect;
  AAlignment: TAlignment;
begin
  if not (csReading in ComponentState) and FAutoSize then
  begin
    Rect := ClientRect;
    DC := GetDC(0);
    Canvas.Handle := DC;
    DoDrawText(Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    X := Left;
    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
    if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
    Dec(Rect.Bottom, Canvas.TextHeight('A'));
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    SetBounds(X, Top, Rect.Right, Rect.Bottom);
  end;
end;

procedure TspSkinTextLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TspSkinTextLabel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TspSkinTextLabel.SetLayout(Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TspSkinTextLabel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TspSkinTextLabel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

// ======================== TspSkinExPanel ============================= //

constructor TspSkinExPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  FUseSkinSize := True;
  FMoveable := False;
  FSizeable := False;  
  Forcebackground := True;
  DrawBackground := True;  
  FNumGlyphs := 1;
  FGlyph := TBitMap.Create;
  FSpacing := 2;
  FDefaultCaptionHeight := 21;
  Width := 150;
  Height := 100;
  FRollKind := rkRollVertical;
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  FShowRollButton := True;
  FShowCloseButton := True;
  FRollState := False;
  FRealWidth := 0;
  FRealHeight := 0;
  StopCheckSize := False;
  FSkinDataName := 'expanel';
  FCMaxWidth := 0;
  FCMinWidth := 0;
  FCMaxHeight := 0;
  FCMinHeight := 0;
  FCaptionImageList := nil;
  FCaptionImageIndex := -1;
end;

destructor TspSkinExPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;


procedure TspSkinExPanel.WMSIZING(var Message: TWMSIZE);
var
  R: TRect;
begin
  inherited;
  if FSizeable
  then
   begin
     if FIndex <> -1 then R := NewClRect else R := ClientRect;
     AdjustClientRect(R);
     ReAlign;
   end;
end;

procedure TspSkinExPanel.WMSIZE(var Message: TWMSIZE);
var
  R: TRect;
begin
  inherited;
  if FSizeable
  then
   begin
     if FIndex <> -1 then R := NewClRect else R := ClientRect;
     AdjustClientRect(R);
     ReAlign;
   end;
end;

procedure TspSkinExPanel.WMNCHitTest(var Message: TWMNCHitTest);
var
  RBRect: TRect;
  RRect: TRect;
  BRect: TRect;
  CR: TRect;
  P: TPoint;
begin
  If (FSizeable or FMoveable) and  not (csDesigning in ComponentState) 
  then
    begin
      P := ScreenToClient(SmallPointToPoint(TWMNCHitTest(Message).Pos));
      if FIndex  = -1
      then
        begin
          CR := Rect (2, 2, Width - 2, FDefaultCaptionHeight - 1);
          RBRect := Rect(Width - 2, Height - 2, Width, Height);
          RRect := Rect(Width - 2, 0, Width, Height - 2);
          BRect := Rect(0, Height - 2, Width - 2, Height);
        end
      else
        begin
          if FRollState
          then
            begin
              if FRollKind = rkRollVertical
              then
                begin
                  CR := RollVCaptionRect;
                  Inc(CR.Right, Width - RectWidth(RollVSkinRect));
                end
              else
                begin
                  CR := RollHCaptionRect;
                  Inc(CR.Bottom, Height - RectHeight(RollHSkinRect));
                end;
            end
          else
            begin
              CR := CaptionRect;
              Inc(CR.Right, Width - RectWidth(SkinRect));
            end;  
          RBRect := Rect(NewClRect.Right, NewClRect.Bottom, Width, Height);
          RRect := Rect(NewClRect.Right, 0, Width, NewClRect.Bottom);
          BRect := Rect(0, NewClRect.Bottom, NewClRect.Right, Height);
       end;

      if FMoveable and
        PointInRect(CR, P) and
        not (FShowCloseButton and PointInRect(Buttons[0].R, P)) and
        not (FShowRollButton and PointInRect(Buttons[1].R, P))
      then
        begin
          Message.Result := HTCAPTION;
          if ActiveButton <> -1
          then
            begin                                     
              ActiveButton := -1;
              Buttons[0].MouseIn := False;
              Buttons[1].MouseIn := False;
              RePaint;
            end;
        end
      else
      if FSizeable and PtInRect(RBRect, P) and not FRollState
      then
        Message.Result := HTBOTTOMRIGHT
      else
      if FSizeable and PtInRect(BRect, P) and not FRollState
      then
        Message.Result := HTBOTTOM
      else
      if FSizeable and PtInRect(RRect, P) and not FRollState
      then
        Message.Result := HTRIGHT
      else
        inherited;
    end
  else
    inherited;
end;


procedure TspSkinExPanel.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinExPanel.Notification;
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FCaptionImageList)
  then FCaptionImageList := nil;
end;

procedure TspSkinExPanel.SetCaptionImageIndex(Value: Integer);
begin
  if FCaptionImageIndex <> Value
  then
    begin
      FCaptionImageIndex := Value;
      RePaint;
    end;
end;

procedure TspSkinExPanel.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinExPanel.SetSpacing;
begin
  FSpacing := Value;
  RePaint;
end;

procedure TspSkinExPanel.ChangeSkinData;
begin                
  inherited;
  if FRollState
  then
    begin
      if FRollKind = rkRollVertical
      then Height := GetRollHeight
      else Width := GetRollWidth;
    end
  else
    ReAlign;
end;

procedure TspSkinExPanel.Close;
begin
  Visible := False;
  if not (csDesigning in ComponentState) and
    Assigned(FOnClose)
  then
    FOnClose(Self);
end;

procedure TspSkinExPanel.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinExPanelControl
    then
      with TspDataSkinExPanelControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.CaptionRect := CaptionRect;
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.RollHSkinRect := RollHSkinRect;
        Self.RollVSkinRect := RollVSkinRect;
        Self.RollLeftOffset := RollLeftOffset;
        Self.RollRightOffset := RollRightOffset;
        Self.RollTopOffset := RollTopOffset;
        Self.RollBottomOffset := RollBottomOffset;
        Self.RollVCaptionRect := RollVCaptionRect;
        Self.RollHCaptionRect := RollHCaptionRect;
        Self.CloseButtonRect := CloseButtonRect;
        Self.CloseButtonActiveRect := CloseButtonActiveRect;
        Self.CloseButtonDownRect := CloseButtonDownRect;

        Self.HRollButtonRect := HRollButtonRect;
        Self.HRollButtonActiveRect := HRollButtonActiveRect;
        if IsNullRect(Self.HRollButtonActiveRect)
        then Self.HRollButtonActiveRect := Self.HRollButtonRect;
        Self.HRollButtonDownRect := HRollButtonDownRect;
        if IsNullRect(Self.HRollButtonDownRect)
        then Self.HRollButtonDownRect := Self.HRollButtonActiveRect;

        Self.HRestoreButtonRect := HRestoreButtonRect;
        Self.HRestoreButtonActiveRect := HRestoreButtonActiveRect;
        if IsNullRect(Self.HRestoreButtonActiveRect)
        then Self.HRestoreButtonActiveRect := Self.HRestoreButtonRect;
        Self.HRestoreButtonDownRect := HRestoreButtonDownRect;
        if IsNullRect(Self.HRestoreButtonDownRect)
        then Self.HRestoreButtonDownRect := Self.HRestoreButtonActiveRect;

        Self.VRollButtonRect := VRollButtonRect;
        Self.VRollButtonActiveRect := VRollButtonActiveRect;
        if IsNullRect(Self.VRollButtonActiveRect)
        then Self.VRollButtonActiveRect := Self.VRollButtonRect;
        Self.VRollButtonDownRect := VRollButtonDownRect;
        if IsNullRect(Self.VRollButtonDownRect)
        then Self.VRollButtonDownRect := Self.VRollButtonActiveRect;

        Self.VRestoreButtonRect := VRestoreButtonRect;
        Self.VRestoreButtonActiveRect := VRestoreButtonActiveRect;
        if IsNullRect(Self.VRestoreButtonActiveRect)
        then Self.VRestoreButtonActiveRect := Self.VRestoreButtonRect;
        Self.VRestoreButtonDownRect := VRestoreButtonDownRect;
        if IsNullRect(Self.VRestoreButtonDownRect)
        then Self.VRestoreButtonDownRect := Self.VRestoreButtonActiveRect;

        Self.ButtonsTransparent := ButtonsTransparent;
        Self.ButtonsTransparentColor := ButtonsTransparentColor;

      end;
end;

procedure TspSkinExPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if FRollState and not StopCheckSize
  then
    begin
      if (FRollKind = rkRollHorizontal) and (AWidth <> GetRollWidth)
      then AWidth := GetRollWidth
      else
      if (FRollKind = rkRollVertical) and (AHeight <> GetRollHeight)
      then AHeight := GetRollHeight
    end;
  inherited;
end;

procedure TspSkinExPanel.CMTextChanged;
begin
  inherited;
  RePaint;
end;

procedure TspSkinExPanel.SetShowRollButton(Value: Boolean);
begin
  FShowRollButton := Value;
  RePaint;
end;

procedure TspSkinExPanel.SetShowCloseButton(Value: Boolean);
begin
  FShowCloseButton := Value;
  RePaint;
end;

function TspSkinExPanel.GetRollWidth: Integer;
begin
   if (FIndex = -1) or not FUseSkinSize
  then
    Result := FDefaultCaptionHeight
  else
    Result := RectWidth(RollHSkinRect);
end;

function TspSkinExPanel.GetRollHeight: Integer;
begin
  if (FIndex = -1) or not FUseSkinSize
  then
    Result := FDefaultCaptionHeight
  else
    Result := RectHeight(RollVSkinRect);
end;

procedure TspSkinExPanel.SetRollKind(Value: TspExPanelRollKind);
begin
  FRollKind := Value;
  RePaint;
end;

procedure TspSkinExPanel.SetDefaultCaptionHeight;
begin
  FDefaultCaptionHeight := Value;
  if (FIndex = -1) or not FUseSkinSize
  then
    begin
      RePaint;
      ReAlign;
    end;
end;

procedure TspSkinExPanel.Paint; 
var
  B: TBitMap;
begin
  GetSkinData;
  if (FIndex <> -1) and not FUseSkinSize
  then
    begin
      B := TBitMap.Create;
      B.Width := Self.Width;
      B.Height := Self.Height;
      CreateControlResizeImage(B);
      Canvas.Draw(0, 0, B);
      B.Free;
    end
  else
    inherited;
end;

function TspSkinExPanel.DrawResizeButton(C: TCanvas; R: TRect;
   AMouseIn, ADown: Boolean): TColor;
var
  Buffer: TBitMap;
  CIndex: Integer;
  ButtonData: TspDataSkinButtonControl;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  BSR, ABSR, DBSR, R1: TRect;
  XO, YO: Integer;
  ArrowColor: TColor;
begin
  ArrowColor := SkinData.SkinColors.cBtnText;
  CIndex := SkinData.GetControlIndex('resizetoolbutton');
  if CIndex =-1
  then
    begin
      Result := ArrowColor;
      Exit;
    end;
  //
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);
  //
   with ButtonData do
  begin
    XO := RectWidth(R) - RectWidth(SkinRect);
    YO := RectHeight(R) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if ADown and AMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        ArrowColor := DownFontColor;
      end
    else
    if AMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        ArrowColor := ActiveFontColor;
      end
    else
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        ArrowColor := FontColor;
      end;
     if not Self.Enabled then ArrowColor := DisabledFontColor;
   end;
  //
  C.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
  Result := ArrowColor;
end;

procedure TspSkinExPanel.CreateControlResizeImage(B: TBitMap);

procedure DrawRotate90_1_H(B: TBitMap);
var
  B1, B2: TspEffectBmp;
  w, h: Integer;
begin
  w := B.Width;
  h := B.Height;
  B1 := TspEffectBmp.CreateFromhWnd(B.Handle);
  B2 := TspEffectBmp.Create(B1.Height, B1.Width);
  B1.Rotate90_1(B2);
  B.Width := h;
  B.Height := w;
  B2.Draw(B.Canvas.Handle, 0, 0);
  B1.Free;
  B2.Free;
end;

var
  R, CR, R1: TRect;
  GlyphNum, BW, CROffset, TX, TY, GX, GY: Integer;
  F: TLogFont;
  W, H: Integer;
  S: String;
  Buffer: TBitMap;
begin
  W := Width;
  H := Height;
  S := FSkinDataName;
  FSkinDataName := 'panel';
  GetSkinData;
  if FIndex <> -1
  then
    begin
      CalcSize(W, H);
      CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
        NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
        B, Picture, SkinRect, Width, Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
    end
  else
    begin
      Exit;
    end;
  FSkinDataName := S;
  GetSkinData;
  //
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(NewClRect);
  Buffer.Height := FDefaultCaptionHeight - NewClRect.Top - 1;
  R1 := CaptionRect;
  OffsetRect(R1, SkinRect.Left, SkinRect.Top);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Picture.Canvas, R1);
  if FRollState and (FRollKind = rkRollHorizontal)
  then
    begin
      DrawRotate90_1_H(Buffer);
      B.Canvas.StretchDraw(NewClRect, Buffer);
    end
  else
    B.Canvas.Draw(NewClRect.Left, NewClRect.Top, Buffer);
  Buffer.Free;
  //
  BW := FDefaultCaptionHeight - 2;
  R := NewClRect;
  if FRollState and (FRollKind = rkRollHorizontal)
  then
    with B.Canvas do
    begin
      CR := R;
      CROffset := 0;
      if FShowCloseButton
      then
        begin
          begin
            Buttons[0].R := Rect(1, 1, 1 + BW, 1 + BW);
            CROffset := CROffset + RectHeight(Buttons[0].R);
          end;
        end
      else
        Buttons[0].R := Rect(0, 0, 0, 3);

      if FShowRollButton
      then
        begin
          Buttons[1].R := Rect(1, Buttons[0].R.Bottom, 1 + BW, Buttons[0].R.Bottom + BW);
          CROffset := CROffset + RectHeight(Buttons[1].R);
        end
      else
        Buttons[1].R := Rect(0, 0, 0, 0);
      //
      Font := DefaultFont;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
        
      GetObject(Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(900);
      Font.Handle := CreateFontIndirect(F);
      Inc(CR.Top, CROffset + 2);
      TX := CR.Left + RectWidth(CR) div 2 - TextHeight(Caption) div 2;
      TY := CR.Bottom - 2 ;
      Brush.Style := bsClear;
      if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left + RectWidth(CR) div 2 - FCaptionImageList.Width div 2;
           GY := CR.Bottom - FCaptionImageList.Height - 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           TY := TY - FCaptionImageList.Height - FSpacing - 2;
         end
       else
      if not FGlyph.Empty
      then
        begin
          GX := CR.Left + RectWidth(CR) div 2 - (FGlyph.Width div NumGlyphs) div 2;
          GY := CR.Bottom - FGlyph.Height - 2;
          GlyphNum := 1;
          if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
          DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
          TY := TY - FGlyph.Height - FSpacing - 2;
        end;
      Font.Color := Self.FontColor;
      TextRect(CR, TX, TY, Caption);
      //
    end
  else
    with B.Canvas do
    begin
      CR := Rect(NewClRect.Left, NewClRect.Top, NewClRect.Right, FDefaultCaptionHeight);
      CROffset := 0;
      if not FRollState
      then
        Frm3D(B.Canvas, Rect(CR.Left, CR.Bottom -1, CR.Right, CR.Bottom),
          SkinData.SkinColors.cBtnHighLight , SkinData.SkinColors.cBtnShadow);

      if FShowCloseButton
      then
        begin
          Buttons[0].R := Rect(Width - BW - 1, 1, Width - 1, 1 + BW);
          CROffset := CROffset + RectWidth(Buttons[1].R);
        end
      else
        Buttons[0].R := Rect(Width - 2, 0, 0, 0);

      if FShowRollButton
      then
        begin
          Buttons[1].R := Rect(Buttons[0].R.Left - BW, 1, Buttons[0].R.Left, 1 + BW);
          CROffset := CROffset + RectWidth(Buttons[1].R);
        end
      else
        Buttons[1].R := Rect(0, 0, 0, 0);
      //
      Inc(CR.Left, 2);
      Dec(CR.Right, CROffset + 2);
      //
      Brush.Style := bsClear;
      Font := DefaultFont;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
      //
       if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FCaptionImageList.Height div 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           Inc(CR.Left, FCaptionImageList.Width + FSpacing);
         end
       else
      if not FGlyph.Empty
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width div NumGlyphs + FSpacing);
         end;
       Font.Color := Self.FontColor;
       SPDrawText2(B.Canvas, Caption, CR);
     end;
  if FShowCloseButton then DrawButton(B.Canvas, 0);
  if FShowRollButton then DrawButton(B.Canvas, 1);
end;

procedure TspSkinExPanel.CreateControlDefaultImage(B: TBitMap);
var
  R, CR: TRect;
  GlyphNum, BW, CROffset, TX, TY, GX, GY: Integer;
  F: TLogFont;
begin
 BW := FDefaultCaptionHeight - 6;
  R := Rect(0, 0, Width, Height);
  if FRollState and (FRollKind = rkRollHorizontal)
  then
    with B.Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(R);
      CR := R;
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
      Frame3D(B.Canvas, R, clBtnHighLight, clBtnFace, 1);
      CROffset := 0;
      if FShowCloseButton
      then
        begin
          begin
            Buttons[0].R := Rect(3, 3, 3 + BW, 3 + BW);
            CROffset := CROffset + RectHeight(Buttons[0].R);
          end;
        end
      else
        Buttons[0].R := Rect(0, 0, 0, 3);

      if FShowRollButton
      then
        begin
          Buttons[1].R := Rect(3, Buttons[0].R.Bottom, 3 + BW, Buttons[0].R.Bottom + BW);
          CROffset := CROffset + RectHeight(Buttons[1].R);
        end
      else
        Buttons[1].R := Rect(0, 0, 0, 0);
      //
      Font := DefaultFont;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
        
      GetObject(Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(900);
      Font.Handle := CreateFontIndirect(F);
      Inc(CR.Top, CROffset + 2);
      TX := CR.Left + RectWidth(CR) div 2 - TextHeight(Caption) div 2;
      TY := CR.Bottom - 2 ;
      Brush.Style := bsClear;
      if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left + RectWidth(CR) div 2 - FCaptionImageList.Width div 2;
           GY := CR.Bottom - FCaptionImageList.Height - 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           TY := TY - FCaptionImageList.Height - FSpacing - 2;
         end
       else
      if not FGlyph.Empty
      then
        begin
          GX := CR.Left + RectWidth(CR) div 2 - (FGlyph.Width div NumGlyphs) div 2;
          GY := CR.Bottom - FGlyph.Height - 2;
          GlyphNum := 1;
          if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
          DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
          TY := TY - FGlyph.Height - FSpacing - 2;
        end;
      TextRect(CR, TX, TY, Caption);
      //
    end
  else
    with B.Canvas do
    begin
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
      Brush.Color := clBtnFace;
      FillRect(R);
      CR := Rect(0, 0, Width, FDefaultCaptionHeight);
      CROffset := 0;
      Frame3D(B.Canvas, CR, clBtnShadow, clBtnShadow, 1);
      Frame3D(B.Canvas, CR, clBtnHighLight, clBtnFace, 1);

      if FShowCloseButton
      then
        begin
          Buttons[0].R := Rect(Width - BW - 2, 3, Width - 2, 3 + BW);
          CROffset := CROffset + RectWidth(Buttons[1].R);
        end
      else
        Buttons[0].R := Rect(Width - 2, 0, 0, 0);

      if FShowRollButton
      then
        begin
          Buttons[1].R := Rect(Buttons[0].R.Left - BW, 3, Buttons[0].R.Left, 3 + BW);
          CROffset := CROffset + RectWidth(Buttons[1].R);
        end
      else
        Buttons[1].R := Rect(0, 0, 0, 0);
      //
      Inc(CR.Left, 2);
      Dec(CR.Right, CROffset + 2);
      //
      Brush.Style := bsClear;
      Font := DefaultFont;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
      //
       if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FCaptionImageList.Height div 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           Inc(CR.Left, FCaptionImageList.Width + FSpacing);
         end
       else
      if not FGlyph.Empty
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width div NumGlyphs + FSpacing);
         end;
       SPDrawText2(B.Canvas, Caption, CR);
     end;
  if FShowCloseButton then DrawButton(B.Canvas, 0);
  if FShowRollButton then DrawButton(B.Canvas, 1);
end;

procedure TspSkinExPanel.CreateControlSkinImage(B: TBitMap);
var
  CR: TRect;
  F: TLogFont;
  CROffset, BO, TX, TY, GX, GY, GlyphNum: Integer;
begin
 with B.Canvas.Font do
  begin
    if FUseSkinFont
    then
      begin
        Name := FontName;
        Style := FontStyle;
        Height := FontHeight;
      end
    else
      Assign(FDefaultFont);
    Color := FontColor;
  end;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := FDefaultFont.Charset;

  B.Canvas.Brush.Style := bsClear;
  if FRollState and (FRollKind = rkRollHorizontal)
  then
    begin
      CreateVSkinImage(RollTopOffset, RollBottomOffset,
        B, Picture, RollHSkinRect, GetRollWidth, Height, TopStretch);
      CR := RollHCaptionRect;
      Inc(CR.Bottom, Height - RectHeight(RollHSkinRect));

      CROffset := 0;
      BO := 0;
      if FShowCloseButton
      then
        begin
          begin
            Buttons[0].R := Rect(CR.Left, CR.Top,
              CR.Left + RectWidth(Self.CloseButtonRect),
              CR.Top + RectHeight(Self.CloseButtonRect));
            CROffset := CROffset + RectHeight(Buttons[0].R);
            BO := 2;
          end;
        end
      else
        Buttons[0].R := Rect(0, 0, 0, CR.Top);

      if FShowRollButton
      then
        begin
          Buttons[1].R := Rect(CR.Left, Buttons[0].R.Bottom + BO,
            CR.Left + RectWidth(Self.HRollButtonRect),
            Buttons[0].R.Bottom + RectHeight(Self.HRollButtonRect) + BO);
          CROffset := CROffset + RectHeight(Buttons[1].R) + BO;
        end
      else
        Buttons[1].R := Rect(0, 0, 0, 0);
      Inc(CR.Top, CROffset);
      GetObject(B.Canvas.Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(900);
      B.Canvas.Font.Handle := CreateFontIndirect(F);
      TX := CR.Left + RectWidth(CR) div 2 - B.Canvas.TextHeight(Caption) div 2;
      TY := CR.Bottom;

      if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left + RectWidth(CR) div 2 - FCaptionImageList.Width div 2;
           GY := CR.Bottom - FCaptionImageList.Height;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           TY := TY - FCaptionImageList.Height - FSpacing;
         end
       else
      if not FGlyph.Empty
       then
         begin
           GX := CR.Left + RectWidth(CR) div 2 - (FGlyph.Width div NumGlyphs) div 2;
           GY := CR.Bottom - FGlyph.Height;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           TY := TY - FGlyph.Height - FSpacing;
         end;
      B.Canvas.TextRect(CR, TX, TY, Caption);
    end
  else
    if FRollState and (FRollKind = rkRollVertical)
    then
      begin
        CreateHSkinImage(RollLeftOffset, RollRightOffset,
          B, Picture, RollVSkinRect, Width, GetRollHeight, TopStretch);
        CR := RollVCaptionRect;
        Inc(CR.Right, Width - RectWidth(RollVSkinRect));
        CROffset := 0;
        BO := 0;
        if FShowCloseButton
        then
         begin
           Buttons[0].R := Rect(CR.Right - RectWidth(CloseButtonRect), CR.Top,
             CR.Right, CR.Top + RectHeight(CloseButtonRect));
           CROffset := CROffset + RectWidth(Buttons[1].R);
           BO := 2;
         end
        else
          Buttons[0].R := Rect(CR.Right, 0, 0, 0);

        if FShowRollButton
        then
          begin
            Buttons[1].R := Rect(Buttons[0].R.Left - RectWidth(VRollButtonRect) - BO,
            CR.Top, Buttons[0].R.Left - BO, CR.Top + RectHeight(VRollButtonRect));
            CROffset := CROffset + RectWidth(Buttons[1].R) + BO;
          end
        else
          Buttons[1].R := Rect(0, 0, 0, 0);
        Dec(CR.Right, CROffset);
        
       if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FCaptionImageList.Height div 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           Inc(CR.Left, FCaptionImageList.Width + FSpacing);
         end
       else
        if not FGlyph.Empty
        then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width div NumGlyphs + FSpacing);
         end;
        SPDrawText2(B.Canvas, Caption, CR);
      end
   else
     begin
       inherited;
       CR := CaptionRect;
       Inc(CR.Right, Width - RectWidth(SkinRect));
       CROffset := 0;
       BO := 0;
       if FShowCloseButton
       then
        begin
          Buttons[0].R := Rect(CR.Right - RectWidth(CloseButtonRect), CR.Top,
           CR.Right, CR.Top + RectHeight(CloseButtonRect));
          CROffset := CROffset + RectWidth(Buttons[1].R);
          BO := 2;
        end
       else
         Buttons[0].R := Rect(CR.Right, 0, 0, 0);

       if FShowRollButton
       then
         begin
           Buttons[1].R := Rect(Buttons[0].R.Left - RectWidth(VRollButtonRect) - BO,
           CR.Top, Buttons[0].R.Left - BO, CR.Top + RectHeight(VRollButtonRect));
           CROffset := CROffset + RectWidth(Buttons[1].R) + BO;
         end
       else
         Buttons[1].R := Rect(0, 0, 0, 0);
       Dec(CR.Right, CROffset);

       if FGlyph.Empty and (FCaptionImageList <> nil) and (FCaptionImageIndex >= 0) and
       (FCaptionImageIndex < FCaptionImageList.Count)
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FCaptionImageList.Height div 2;
           FCaptionImageList.Draw(B.Canvas, GX, GY, FCaptionImageIndex, Enabled);
           Inc(CR.Left, FCaptionImageList.Width + FSpacing);
         end
       else
       if not FGlyph.Empty
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width div NumGlyphs + FSpacing);
         end;
       SPDrawText2(B.Canvas, Caption, CR);
     end;
  if FShowCloseButton then DrawButton(B.Canvas, 0);
  if FShowRollButton then DrawButton(B.Canvas, 1);
end;

procedure TspSkinExPanel.AdjustClientRect(var Rect: TRect);
var
  R: TRect;
begin
  inherited AdjustClientRect(Rect);
  if (FIndex <> -1) and not (csDesigning in ComponentState)
  then
    begin
      R := Rect;
      Rect := NewClRect;
      if not FUseSkinSize
      then
        Rect.Top := R.Top + FDefaultCaptionHeight
    end
  else
    begin
      Rect.Top := Rect.Top + FDefaultCaptionHeight;
      Inc(Rect.Left, 1);
      Dec(Rect.Right, 1);
      Dec(Rect.Bottom, 1);
    end;
end;

procedure TspSkinExPanel.ShowControls;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
    Controls[i].Visible := True;
  EnableAlign;  
end;

procedure TspSkinExPanel.HideControls;
var
  i: Integer;
begin
  DisableAlign;
  for i := 0 to ControlCount - 1 do
    Controls[i].Visible := False;
end;


procedure TspSkinExPanel.SetRollState;
begin
  if FRollState = Value then Exit;
  FRollState := Value;
  StopCheckSize := True;
  if FRollState
  then
    begin
      FForceBackground := False;
      //
      FCMaxWidth := Constraints.MaxWidth;
      FCMinWidth := Constraints.MinWidth;
      FCMaxHeight := Constraints.MaxHeight;
      FCMinHeight := Constraints.MinHeight;
      Constraints.MaxWidth := 0;
      Constraints.MaxHeight := 0;
      Constraints.MinHeight := 0;
      Constraints.MinWidth := 0;
      //
      HideControls;
      case FRollKind of
        rkRollVertical:
          if FRealHeight = 0 then
          begin
            FRealHeight := Height;
            Height := GetRollHeight;
          end;
        rkRollHorizontal:
          if FRealWidth = 0 then
          begin
            FRealWidth := Width;
            Width := GetRollWidth;
          end;
      end;
    end
  else
    begin
      FForceBackground := True;
      //
      Constraints.MaxWidth := FCMaxWidth;
      Constraints.MinWidth := FCMinWidth;
      Constraints.MaxHeight := FCMaxHeight;
      Constraints.MinHeight := FCMinHeight;
      //
      case FRollKind of
        rkRollVertical:
          begin
            Height := FRealHeight;
            FRealHeight := 0;
          end;
        rkRollHorizontal:
          begin
            Width := FRealWidth;
            FRealWidth := 0;
          end;
      end;
      ShowControls;
    end;
  StopCheckSize := False;
  if not (csDesigning in ComponentState) and
    Assigned(FOnChangeRollState)
  then
    FOnChangeRollState(Self);
end;


procedure TspSkinExPanel.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  TestActive(-1, -1);
end;

procedure TspSkinExPanel.CMMouseLeave;
var
  i: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  for i := 0 to 1 do
    if Buttons[i].MouseIn
    then
       begin
         Buttons[i].MouseIn := False;
         DrawButton(Canvas, i);
       end;
end;

procedure TspSkinExPanel.MouseDown;
begin
  TestActive(X, Y);
  if ActiveButton <> -1
  then
    begin
      CaptureButton := ActiveButton;
      ButtonDown(ActiveButton, X, Y);
    end;
  inherited;
end;

procedure TspSkinExPanel.MouseUp;
begin
  inherited;
  if CaptureButton <> -1
  then ButtonUp(CaptureButton, X, Y);
  CaptureButton := -1;
end;

procedure TspSkinExPanel.MouseMove;
begin
  inherited;
  TestActive(X, Y);
end;

procedure TspSkinExPanel.TestActive(X, Y: Integer);
var
  i, j: Integer;
  i1, i2: Integer;
begin
  if FShowCloseButton then i1 := 0 else i1 := 1;
  if FShowRollButton then i2 := 1 else i2 := 0;

  if i1 > i2 then Exit;

  j := -1;
  OldActiveButton := ActiveButton;

  for i := i1 to i2 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinExPanel.ButtonDown;
begin
  Buttons[i].MouseIn := True;
  Buttons[i].Down := True;
  DrawButton(Canvas, i);
end;

procedure TspSkinExPanel.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
  if Buttons[i].MouseIn
  then
  case i of
    0:  Close;
    1:
        begin
          RollState := not RollState;
          TestActive(X, Y);
          RePaint;
        end;
  end;
end;

procedure TspSkinExPanel.ButtonEnter(I: Integer);
begin
  Buttons[i].MouseIn := True;
  DrawButton(Canvas, i);
end;

procedure TspSkinExPanel.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
end;

procedure TspSkinExPanel.DrawButton;
var
  C: TColor;
  R1: TRect;
  SR, AR, DR: TRect;
  DrawR: TRect;
  Buffer: TBitMap;
begin
  if FIndex = -1
  then
    begin
    with Buttons[i] do
    if not IsNullRect(R) then
    begin
      R1 := R;
      Cnvs.Brush.Color := clBtnface;
      Cnvs.FillRect(R);
      if Down and MouseIn
      then
        begin
          Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Cnvs.Brush.Color := SP_XP_BTNDOWNCOLOR;
          Cnvs.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR;
            Cnvs.FillRect(R1);
          end
        else
          begin
            Cnvs.Brush.Color := clBtnFace;
            Cnvs.FillRect(R1);
          end;
      C := clBlack;
      R1 := R;
      if Down and MouseIn
      then
        begin
          Inc(R1.Left, 2);
          Inc(R1.Top, 2);
        end;
      case i of
        1:
          if FRollKind = rkRollVertical
          then
            begin
              if FRollState
              then
                DrawArrowImage(Cnvs, R1, C, 4)
              else
                DrawArrowImage(Cnvs, R1, C, 3);
            end
          else
            begin
              if FRollState
              then
                DrawArrowImage(Cnvs, R1, C, 2)
              else
                DrawArrowImage(Cnvs, R1, C, 1);
            end;
        0: DrawRCloseImage(Cnvs, R1, C);
      end;
    end
    end
  else
  if not FUseSkinSize
  then
    begin
      with Buttons[i] do
    if not IsNullRect(R) then
    begin
      R1 := R;
      C := DrawResizeButton(Cnvs, R1, MouseIn, Down);
      case i of
        1:
          if FRollKind = rkRollVertical
          then
            begin
              if FRollState
              then
                DrawArrowImage(Cnvs, R1, C, 4)
              else
                DrawArrowImage(Cnvs, R1, C, 3);
            end
          else
            begin
              if FRollState
              then
                DrawArrowImage(Cnvs, R1, C, 2)
              else
                DrawArrowImage(Cnvs, R1, C, 1);
            end;
        0: DrawRCloseImage(Cnvs, R1, C);
      end;
     end
    end  
  else
  if not IsNullRect(Buttons[i].R)
  then 
    with Buttons[i] do
    begin
      if i = 0
      then
        begin
          SR := CloseButtonRect;
          AR := CloseButtonActiveRect;
          DR := CloseButtonDownRect;
        end
      else
        if not FRollState
        then
          begin
            case RollKind of
              rkRollHorizontal:
                begin
                  SR := HRollButtonRect;
                  AR := HRollButtonActiveRect;
                  DR := HRollButtonDownRect;
                end;
              rkRollVertical:
                begin
                  SR := VRollButtonRect;
                  AR := VRollButtonActiveRect;
                  DR := VRollButtonDownRect;
                end;
            end;
          end
        else
          begin
            case RollKind of
              rkRollHorizontal:
                begin
                  SR := HRestoreButtonRect;
                  AR := HRestoreButtonActiveRect;
                  DR := HRestoreButtonDownRect;
                end;
              rkRollVertical:
                begin
                  SR := VRestoreButtonRect;
                  AR := VRestoreButtonActiveRect;
                  DR := VRestoreButtonDownRect;
                end;
            end;
          end;

     if Down and MouseIn
      then
        DrawR := DR
      else
      if MouseIn
      then
        DrawR := AR
      else
        DrawR := SR;

     if ButtonsTransparent and not IsNullRect(DrawR)
     then
       begin
         Buffer := TBitMap.Create;
         Buffer.Width := RectWidth(DrawR);
         Buffer.Height := RectHeight(DrawR);
         Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
         Picture.Canvas, DrawR);

         Buffer.Transparent := True;
         Buffer.TransparentMode := tmFixed;
         Buffer.TransparentColor := ButtonsTransparentColor;

         Cnvs.Draw(R.Left, R.Top, Buffer);
         Buffer.Free;
       end
     else
       Cnvs.CopyRect(R, Picture.Canvas, DrawR);

   end;
end;

constructor TspSkinHeaderControl.Create(AOwner: TComponent);
begin
  inherited;
  FOldActiveSection := -1;
  FActiveSection := -1;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  FDefaultHeight := 0;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FSkinDataName := 'resizebutton';
  FUseSkinFont := True;
  FDownInDivider := False;
  InDivider := False;
  FDown := False;
end;

destructor TspSkinHeaderControl.Destroy;
begin
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinHeaderControl.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;

procedure TspSkinHeaderControl.CMSENCPaint(var Message: TMessage);
begin
  Message.Result := SE_RESULT;
end;

procedure TspSkinHeaderControl.SetBounds;
var
  UpDate: Boolean;
begin
  GetSkinData;
  UpDate := Height <> AHeight;
  if UpDate
  then
    begin
      if (FIndex <> -1) and (LBPt.X = 0) and (LBPt.Y = 0)
      then
        AHeight := RectHeight(SkinRect)
      else
      if (FIndex = -1) and (FDefaultHeight <> 0)
      then
        AHeight := FDefaultHeight;
    end;
  inherited;
end;

procedure TspSkinHeaderControl.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinHeaderControl.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinButtonControl
    then
      with TspDataSkinButtonControl(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        RBPt := RBPoint;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        Self.StretchEffect := StretchEffect;
        Self.LeftStretch := LeftStretch;
        Self.TopStretch := TopStretch;
        Self.RightStretch := RightStretch;
        Self.BottomStretch := BottomStretch;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        //
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.DownFontColor := DownFontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.DownSkinRect := DownSkinRect;
        if IsNullRect(ActiveSkinRect) then Self.ActiveSkinRect := SkinRect;
        if IsNullRect(DownSkinRect) then Self.DownSkinRect := Self.ActiveSkinRect;
      end
    else
      Picture := nil;
end;

procedure TspSkinHeaderControl.ChangeSkinData;
begin
  GetSkinData;
  if (FIndex <> -1) and (LBPt.X = 0) and (LBPt.Y = 0)
  then
    Height := RectHeight(SkinRect)
  else
    if (FIndex = -1) and (FDefaultHeight <> 0)
    then
      Height := FDefaultHeight;
  RePaint;
end;

procedure TspSkinHeaderControl.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex =  -1 then Font.Assign(Value);
end;

procedure TspSkinHeaderControl.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

function TspSkinHeaderControl.GetSkinItemRect;
var
  SectionOrder: array of Integer;
  R: TRect;
begin
  if Self.DragReorder
  then
    begin
      SetLength(SectionOrder, Sections.Count);
      Header_GetOrderArray(Handle, Sections.Count, PInteger(SectionOrder));
      Header_GETITEMRECT(Handle, SectionOrder[Index] , @R);
    end
  else
    Header_GETITEMRECT(Handle, Index, @R);
  Result := R;
end;

procedure TspSkinHeaderControl.DrawSkinSectionR;
var
  BR, SR, TR: TRect;
  S: String;
  B: TBitMap;
  W, H, TX, TY, GX, GY, XO, YO, TXO, TYO: Integer;
begin
  GetSkinData;
  if (RectWidth(R) <= 0) or (RectHeight(R) <= 0) then Exit;
  S := Section.Text;
  B := TBitMap.Create;
  W := RectWidth(R);
  if (LBPt.X = 0) and (LBPt.Y = 0) and (FIndex <> -1)
  then
    H := RectHeight(SkinRect)
  else
    H := RectHeight(R);
  B.Width := W;
  B.Height := H;
  BR := Rect(0, 0, B.Width, B.Height);
  if FIndex = -1
  then
    with B.Canvas do
    begin
      //
      if Pressed
      then
        begin
          Frame3D(B.Canvas, BR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Brush.Color := SP_XP_BTNDOWNCOLOR;
        end
      else
      if Active
      then
        begin
          Frame3D(B.Canvas, BR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Brush.Color := SP_XP_BTNACTIVECOLOR;
        end
      else
        begin
          Frame3D(B.Canvas, BR, clBtnShadow, clBtnShadow, 1);
          Brush.Color := clBtnFace;
        end;
      //
      FillRect(BR);
      Font := FDefaultFont;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := FDefaultFont.Charset;
    end
  else
    with B.Canvas do
    begin
      if FUseSkinFont
      then
        with Font do
        begin
          Name := FontName;
          Height := FontHeight;
          Style := FontStyle;
          CharSet := FDefaultFont.Charset;
        end
      else
        Font := FDefaultFont;

      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := FDefaultFont.Charset;

      if Pressed
      then
        begin
          SR := DownSkinRect;
          Font.Color := DownFontColor;
        end
      else
      if Active
      then
        begin
          SR := ActiveSkinRect;
          Font.Color := ActiveFontColor;
        end
      else
        begin
          SR := SkinRect;
          Font.Color := FontColor;
        end;
      //
      XO := RectWidth(BR) - RectWidth(SkinRect);
      if (LBPt.X = 0) and (LBPt.Y = 0)
      then
        begin
          CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, Picture, SR, B.Width, B.Height, StretchEffect);
        end
      else
        begin
          YO := RectHeight(BR) - RectHeight(SkinRect);
          NewLTPoint := LTPt;
          NewRTPoint := Point(RTPt.X + XO, RTPt.Y);
          NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
          NewRBPoint := Point(RBPt.X + XO, RBPt.Y + YO);
          NewClRect := Rect(CLRect.Left, ClRect.Top,
          CLRect.Right + XO, ClRect.Bottom + YO);
          //
          CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
            NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, SR, B.Width, B.Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
        end;
    end;

  if FIndex = -1
  then
    TR := Rect(2, 2, B.Width - 2, B.Height - 2)
  else
    begin
      TXO := RectWidth(SkinRect) - ClRect.Right;
      TYO := RectHeight(SkinRect) - ClRect.Bottom;
      TR := Rect(ClRect.Left, ClRect.Top, B.Width - TXO, B.Height - TYO);
    end;

  if Assigned(FOnDrawSkinSection)
  then
    begin
      FOnDrawSkinSection(Self, Section, TR, Active, Pressed, B.Canvas)
    end
  else
    with B.Canvas do
    begin
      Brush.Style := bsClear;
      Inc(BR.Left, 5); Dec(BR.Right, 5);
      if (Images <> nil) and (Section.ImageIndex >= 0) and
      (Section.ImageIndex < Images.Count)
        then
          begin
           CorrectTextbyWidth(B.Canvas, S, RectWidth(TR) - 10 - Images.Width);
           GX := TR.Left;
           if S = Section.Text then
           case Section.Alignment of
             taRightJustify: GX := TR.Right - TextWidth(S) - Images.Width - 10;
             taCenter: GX := TR.Left + RectWidth(TR) div 2 -
                          (TextWidth(S) + Images.Width + 10) div 2;
           end;
           TX := GX + Images.Width + 10;
           TY := TR.Top + RectHeight(TR) div 2 - TextHeight(S) div 2;
           GY := TR.Top + RectHeight(TR) div 2 - Images.Height div 2;
           Images.Draw(B.Canvas, GX, GY, Section.ImageIndex, True);
         end
       else
         begin
           CorrectTextbyWidth(B.Canvas, S, RectWidth(TR));
           TX := TR.Left;
           case Section.Alignment of
             taRightJustify: TX := TR.Right - TextWidth(S) - 10;
             taCenter: TX := TR.Left + RectWidth(TR) div 2 - TextWidth(S) div 2;
           end;
           TY := TR.Top + RectHeight(TR) div 2 - TextHeight(S) div 2;
         end;
      //
      if (B.Canvas.Font.Height div 2) <> (B.Canvas.Font.Height / 2) then Dec(TY, 1);
      //
      TextRect(TR, TX, TY, S);
    end;
  Cnvs.Draw(R.Left, R.Top, B);
  B.Free;
end;


function TspSkinHeaderControl.DrawSkinSection;
var
  R: TRect;
begin
  R := GetSkinItemRect(Index);
  Result := R;
  DrawSkinSectionR(Cnvs, Sections[Index], Active, Pressed, R);
end;

procedure TspSkinHeaderControl.PaintWindow(DC: HDC);
var
  i, SaveIndex: Integer;
  RightOffset, XO, YO: Integer;
  R1, BGR: TRect;
  B: TBitMap;
begin
  GetSkinData;
  if not HandleAllocated or (Handle = 0) then Exit;
  if (Width <= 0) or (Height <=0) then Exit;
  SaveIndex := SaveDC(DC);
  try
    Canvas.Handle := DC;
    RightOffset := 0;
    for I := 0 to Sections.Count - 1 do
    begin
      R1 := DrawSkinSection(Canvas, I, (I = FActiveSection) and not FDown,
       (I = FActiveSection) and FDown);
      if RightOffset < R1.Right then RightOffset := R1.Right;
    end;
    BGR := Rect(RightOffset, 0, Width + 1, Height);
    if BGR.Left < BGR.Right then
    if FIndex = -1
    then
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Fillrect(BGR);
        Frame3D(Canvas, BGR, clBtnShadow, clBtnShadow, 1);
      end
    else
      begin
        //
        B := TBitMap.Create;
        B.Width := RectWidth(BGR);
        if (LBPt.X = 0) and (LBPt.Y = 0)
        then
          B.Height := RectHeight(SkinRect)
        else
          B.Height := RectHeight(BGR);

        XO := RectWidth(BGR) - RectWidth(SkinRect);

        if (LBPt.X = 0) and (LBPt.Y = 0)
        then
          begin
            CreateHSkinImage2(LTPt.X, RectWidth(SkinRect) - RTPt.X,
            B, Picture, SkinRect, B.Width, B.Height, StretchEffect);
          end
        else
          begin
            YO := RectHeight(BGR) - RectHeight(SkinRect);
            NewLTPoint := LTPt;
            NewRTPoint := Point(RTPt.X + XO, RTPt.Y);
            NewLBPoint := Point(LBPt.X, LBPt.Y + YO);
            NewRBPoint := Point(RBPt.X + XO, RBPt.Y + YO);
            NewClRect := Rect(CLRect.Left, ClRect.Top,
            CLRect.Right + XO, ClRect.Bottom + YO);
            //
            CreateSkinImage2(LTPt, RTPt, LBPt, RBPt, CLRect,
              NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
              B, Picture, SkinRect, B.Width, B.Height, True,
              LeftStretch, TopStretch, RightStretch, BottomStretch,
              StretchEffect, StretchType);
          end;
        Canvas.Draw(BGR.Left, BGR.Top, B);
        B.Free;  
      end;
    Canvas.Handle := 0;
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TspSkinHeaderControl.WMPaint;
begin
  PaintHandler(Msg);
end;

procedure TspSkinHeaderControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TspSkinHeaderControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TspSkinHeaderControl.TestActive(X, Y: Integer);
var
  i: Integer;
  R: TRect;
begin
  FOldActiveSection := FActiveSection;

  FActiveSection := -1;
  for i := 0 to Sections.Count - 1 do
  begin
    R := GetSkinItemRect(i);
    if PtInRect(R, Point(X, Y))
    then
      begin
        FActiveSection := i;
        Break;
      end;
  end;

  if (FOldActiveSection <> FActiveSection)
  then
    begin
      if (FOldActiveSection <> - 1) and not FInTracking
      then
        DrawSkinSection(Canvas, FOldActiveSection, False, False);
      if (FActiveSection <> -1) and not FInTracking
      then
        DrawSkinSection(Canvas, FActiveSection, True, False);
    end;
end;

procedure TspSkinHeaderControl.MouseMove;
begin
 inherited;
 if FDown and DragReOrder then FInTracking := True else FInTracking := False;
 if not (csDesigning in ComponentState) and not FInTracking
 then
   TestActive(X, Y);
  if FDownInDivider then Invalidate;  
end;

procedure TspSkinHeaderControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  if (Button = mbLeft) and not InDivider and (Style = hsButtons)
  then
    begin
      FDown := True;
      Invalidate;
    end;

  if (Button = mbLeft) and InDivider
  then FDownInDivider := True
  else FDownInDivider := False;

  inherited;
end;

procedure TspSkinHeaderControl.MouseUp;
var
  FTempTracking: Boolean;
begin
  inherited;
  FTempTracking := FInTracking;
  FInTracking := False;
  FDownInDivider := False;
  FActiveSection := -1;
  FOldActiveSection := -1;
  if (Button = mbLeft) and not (csDesigning in ComponentState) and (Style = hsButtons)
  then
    begin
      TestActive(X, Y);
      Invalidate;
      FDown := False;
      if (FActiveSection <> -1) and not InDivider and not FTempTracking and
         Assigned(FOnSkinSectionClick)
      then
        FOnSkinSectionClick(Self, Sections[FActiveSection]);
    end;
end;

procedure TspSkinHeaderControl.CMMouseEnter;
begin
  if (csDesigning in ComponentState) then Exit;
  if not FDown then Invalidate;
end;

procedure TspSkinHeaderControl.CMMouseLeave;
begin
  if (csDesigning in ComponentState) then Exit;
  FActiveSection := -1;
  FOldActiveSection := -1;
  if not FDown then Invalidate;
end;

procedure TspSkinHeaderControl.WndProc;
begin
  inherited;
  case Message.Msg of
     HDM_HITTEST:
        begin
          if PHDHitTestInfo(Message.LParam)^.Flags = HHT_ONDIVIDER
          then
            InDivider := True
          else
            InDivider := False;
        end;
    end;
end;

procedure TspSkinHeaderControl.CreateWnd;
var
  i: Integer;
begin
  inherited;
  for i := 0 to Sections.Count - 1 do Sections[i].Style := hsOwnerDraw;
end;

procedure TspSkinHeaderControl.DrawSection(Section: THeaderSection; const Rect: TRect;
                                           Pressed: Boolean);
var
  SectionOrder: array of Integer;
  i, Index: Integer;
begin
  inherited;
  if Self.DragReorder
  then
    begin
      SetLength(SectionOrder, Sections.Count);
      Header_GetOrderArray(Handle, Sections.Count, PInteger(SectionOrder));
      for i := 0 to Sections.Count - 1 do
       if SectionOrder[i] = Section.Index then Break;
      Index := i;
    end
  else
    Index := Section.Index;

  Self.DrawSkinSectionR(Canvas, Sections[Index], False, Pressed, Rect);
end;

// ======================== TspSkinCustomSlider ======================= //

constructor TspSkinCustomSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlState := ControlState + [csCreating];
  ControlStyle := [csClickEvents, csCaptureMouse, csAcceptsControls,
    csDoubleClicks, csOpaque];
  FThumbImageList := nil;
  FThumbImageIndex := 0;
  FThumbActiveImageIndex := 1;
  TabStop := True;  
  Width := 150;
  Height := 40;
  FNumThumbStates := 2;
  FBevelWidth := 1;
  FOrientation := soHorizontal;
  FOptions := [soShowFocus, soShowPoints, soSmooth];
  FEdgeSize := 2;
  FMinValue := 0;
  FMaxValue := 100;
  FIncrement := 10;
  CreateElements;
  FSkinDataName := 'slider';
  Picture := nil;
  FUseSkinThumb := True;
  ControlState := ControlState - [csCreating];
end;

destructor TspSkinCustomSlider.Destroy;
var
  I: TspSliderImage;
begin
  FOnChange := nil;
  FOnChanged := nil;
  FOnDrawPoints := nil;
  FRuler.Free;
  for I := Low(FImages) to High(FImages) do begin
    FImages[I].OnChange := nil;
    FImages[I].Free;
  end;
  inherited Destroy;
end;

procedure TspSkinCustomSlider.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FThumbImageList) then FThumbImageList := nil;
end;

procedure TspSkinCustomSlider.WMCHECKPARENTBG(var Msg: TWMEraseBkgnd);
begin
  if Transparent then RePaint;
end;

procedure TspSkinCustomSlider.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinSlider
    then
      with TspDataSkinSlider(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.HRulerRect := HRulerRect;
        Self.HThumbRect := HThumbRect;
        Self.VRulerRect := VRulerRect;
        Self.VThumbRect := VThumbRect;
        Self.SkinEdgeSize := EdgeSize;
        Self.BGColor := BGColor;
        Self.PointsColor := PointsColor;
      end;
end;

procedure TspSkinCustomSlider.ChangeSkinData;
begin
  AdjustElements;
end;

procedure TspSkinCustomSlider.WMMOVE(var Msg: TWMMOVE);
begin
  inherited;
  if FTransparent then Invalidate;
end;

procedure TspSkinCustomSlider.SetTransparent(Value: Boolean);
begin
  FTransparent := Value;
  Invalidate;
end;

procedure TspSkinCustomSlider.Loaded;
var
  I: TspSliderImage;
begin
  inherited Loaded;
  for I := Low(FImages) to High(FImages) do
    if I in FUserImages then SetImage(Ord(I), FImages[I]);
end;

procedure TspSkinCustomSlider.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
end;

procedure TspSkinCustomSlider.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
begin
  if FPaintBuffered then inherited
  else begin
    Canvas.Lock;
    try
      MemDC := GetDC(0);
      MemBitmap := CreateCompatibleBitmap(MemDC, ClientWidth, ClientHeight);
      ReleaseDC(0, MemDC);
      MemDC := CreateCompatibleDC(0);
      OldBitmap := SelectObject(MemDC, MemBitmap);
      try
        DC := Message.DC;
        Perform(WM_ERASEBKGND, MemDC, MemDC);
        FPaintBuffered := True;
        Message.DC := MemDC;
        try
          WMPaint(Message);
        finally
          Message.DC := DC;
          FPaintBuffered := False;
        end;
        if DC = 0 then DC := BeginPaint(Handle, PS);
        BitBlt(DC, 0, 0, ClientWidth, ClientHeight, MemDC, 0, 0, SRCCOPY);
        if Message.DC = 0 then EndPaint(Handle, PS);
      finally
        SelectObject(MemDC, OldBitmap);
        DeleteDC(MemDC);
        DeleteObject(MemBitmap);
      end;
    finally
      Canvas.Unlock;
    end;
  end;
end;

procedure TspSkinCustomSlider.Paint;
var
  R: TRect;
  HighlightThumb: Boolean;
  P: TPoint;
  Offset: Integer;
  Buffer: TBitMap;
begin
  GetSkinData;
  if csPaintCopy in ControlState then begin
    Offset := GetOffsetByValue(GetSliderValue);
    P := GetThumbPosition(Offset);
  end else
  P := Point(FThumbRect.Left, FThumbRect.Top);
  R := GetClientRect;

  if FTransparent
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      GetParentImage(Self, Buffer.Canvas);
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end
  else
    with Canvas do begin
      if FIndex = -1
      then
        Brush.Color := Color
      else
        Brush.Color := BGColor;
      FillRect(R);
    end;

  if FRuler.Width > 0 then begin
    if (soRulerOpaque in Options) and (FIndex = -1)
    then FRuler.Transparent := False else FRuler.Transparent := True;
    Canvas.Draw(FRulerOrg.X, FRulerOrg.Y, FRuler);
  end;

  if (soShowFocus in Options) and FFocused and
    not (csDesigning in ComponentState) then
  begin
    R := SliderRect;
    InflateRect(R, -2, -2);
    if FIndex <> -1
    then
      Canvas.Font.Color := SkinData.SkinColors.cBtnText;
    DrawSkinFocusRect(Canvas, R);
  end;

  if (soShowPoints in Options) then begin
    if Assigned(FOnDrawPoints) then FOnDrawPoints(Self)
    else InternalDrawPoints(Canvas, Increment, 3, 5);
  end;

  if csPaintCopy in ControlState then
    HighlightThumb := not Enabled else
  HighlightThumb := FThumbDown or not Enabled;

  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      if FThumbImageList <> nil
      then
        DrawImageThumb(Canvas, P, HighlightThumb)
      else
        DrawThumb(Canvas, P, HighlightThumb)
    end
  else
    DrawSkinThumb(Canvas, P, HighlightThumb);
end;

function TspSkinCustomSlider.CanModify: Boolean;
begin
  Result := True;
end;

function TspSkinCustomSlider.GetSliderValue: Longint;
begin
  Result := FValue;
end;

function TspSkinCustomSlider.GetSliderRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

procedure TspSkinCustomSlider.DrawSkinThumb;
var
  Buffer: TBitMap;
  R: TRect;
begin
  if Orientation = soHorizontal
  then R := HThumbRect
  else R := VThumbRect;

  if Highlight
  then R.Left := R.Left + (R.Right - R.Left) div 2
  else R.Right := R.Left + (R.Right - R.Left) div 2;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Picture.Canvas, R);
  Buffer.Transparent := True;
  Canvas.Draw(Origin.X, Origin.Y, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomSlider.DrawImageThumb(Canvas: TCanvas; Origin: TPoint; Highlight: Boolean);
begin
  if Highlight
  then
    begin
      if (FThumbActiveImageIndex >=0) and (FThumbActiveImageIndex < FThumbImageList.Count)
      then
        FThumbImageList.Draw(Canvas, Origin.X, Origin.Y, FThumbActiveImageIndex);
    end
  else
   if (FThumbImageIndex >=0) and (FThumbImageIndex < FThumbImageList.Count)
   then
      FThumbImageList.Draw(Canvas, Origin.X, Origin.Y, FThumbImageIndex);
end;

procedure TspSkinCustomSlider.DrawThumb(Canvas: TCanvas; Origin: TPoint;
  Highlight: Boolean);
var
  R: TRect;
  Image: TBitmap;
  Buffer: TBitMap;
begin

  if Orientation = soHorizontal then Image := ImageHThumb
  else Image := ImageVThumb;
  R := Rect(0, 0, Image.Width, Image.Height);
  if NumThumbStates = 2 then begin
    if Highlight then R.Left := (R.Right - R.Left) div 2
    else R.Right := (R.Right - R.Left) div 2;
  end;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Image.Canvas, R);
  if soThumbOpaque in Options
  then Buffer.Transparent := False else Buffer.Transparent := True;
  Canvas.Draw(Origin.X, Origin.Y, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomSlider.InternalDrawPoints(ACanvas: TCanvas; PointsStep,
  PointsHeight, ExtremePointsHeight: Longint);
const
  MinInterval = 3;
var
  RulerLength: Integer;
  Interval, Scale, PointsCnt, I, Val: Longint;
  X, H, X1, X2, Y1, Y2: Integer;
  Range: Double;
  HThumbWidth, VThumbHeight: Integer;
  NumStates: Integer;
begin

  RulerLength := GetRulerLength;
  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      HThumbWidth := FImages[siHThumb].Width;
      VThumbHeight := FImages[siVThumb].Height;
      NumStates := NumThumbStates;
    end
  else
    begin
      HThumbWidth := RectWidth(HThumbRect);
      VThumbHeight := RectHeight(VThumbRect);
      NumStates := 2;
    end;

  if (FIndex = -1)
  then
    ACanvas.Pen.Color := clWindowText
  else
    ACanvas.Pen.Color := PointsColor;

  Scale := 0;
  Range := MaxValue - MinValue;
  repeat
    Inc(Scale);
    PointsCnt := Round(Range / (Scale * PointsStep)) + 1;
    if PointsCnt > 1 then
      Interval := RulerLength div (PointsCnt - 1)
    else Interval := RulerLength;
  until (Interval >= MinInterval + 1) or (Interval >= RulerLength);
  Val := MinValue;
  for I := 1 to PointsCnt do begin
    H := PointsHeight;
    if I = PointsCnt then Val := MaxValue;
    if (Val = MaxValue) or (Val = MinValue) then H := ExtremePointsHeight;
    X := GetOffsetByValue(Val);
    if Orientation = soHorizontal then begin
      X1 := X + (HThumbWidth div NumStates) div 2;
      Y1 := FPointsRect.Top;
      X2 := X1;
      Y2 := Y1 + H;
    end
    else begin
      X1 := FPointsRect.Left;
      Y1 := X + VThumbHeight div 2;
      X2 := X1 + H;
      Y2 := Y1;
    end;
    with ACanvas do begin
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end;
    Inc(Val, Scale * PointsStep);
  end;
end;

procedure TspSkinCustomSlider.DefaultDrawPoints(PointsStep, PointsHeight,
  ExtremePointsHeight: Longint);
begin
  InternalDrawPoints(Canvas, PointsStep, PointsHeight, ExtremePointsHeight);
end;

procedure TspSkinCustomSlider.CreateElements;
var
  I: TspSliderImage;
begin
  FRuler := TBitmap.Create;
  for I := Low(FImages) to High(FImages) do SetImage(Ord(I), nil);
  AdjustElements;
end;

procedure TspSkinCustomSlider.BuildSkinRuler(R: TRect);
var
  TmpBmp: TBitmap;
begin
  TmpBmp := TBitmap.Create;
  try
    if Orientation = soHorizontal
    then
     begin
       TmpBmp.Width := R.Right - R.Left - 2 * Indent;
       TmpBmp.Height := RectHeight(HRulerRect);
       CreateHSkinImage(SkinEdgeSize, SkinEdgeSize, TmpBmp, Picture, HRulerRect,
         TmpBmp.Width, TmpBmp.Height, False);
      end
    else
      begin
        TmpBmp.Height := R.Bottom - R.Top - 2 * Indent;
        TmpBmp.Width := RectWidth(HRulerRect);
        CreateVSkinImage(SkinEdgeSize, SkinEdgeSize, TmpBmp, Picture, VRulerRect,
          TmpBmp.Width, TmpBmp.Height, False);
      end;
    FRuler.Assign(TmpBmp);
  finally
    TmpBmp.Free;
  end;
end;

procedure TspSkinCustomSlider.BuildRuler(R: TRect);
var
  DstR, BmpR: TRect;
  I, L, B, N, C, Offs, Len, RulerWidth: Integer;
  TmpBmp: TBitmap;
  Index: TspSliderImage;
begin
  TmpBmp := TBitmap.Create;
  try
    if Orientation = soHorizontal then Index := siHRuler
    else Index := siVRuler;
    if Orientation = soHorizontal then begin
      L := R.Right - R.Left - 2 * Indent;
      if L < 0 then L := 0;
      TmpBmp.Width := L;
      TmpBmp.Height := FImages[Index].Height;
      L := TmpBmp.Width - 2 * FEdgeSize;
      B := FImages[Index].Width - 2 * FEdgeSize;
      RulerWidth := FImages[Index].Width;
    end
    else begin
      TmpBmp.Width := FImages[Index].Width;
      TmpBmp.Height := R.Bottom - R.Top - 2 * Indent;
      L := TmpBmp.Height - 2 * FEdgeSize;
      B := FImages[Index].Height - 2 * FEdgeSize;
      RulerWidth := FImages[Index].Height;
    end;
    N := (L div B) + 1;
    C := L mod B;
    for I := 0 to N - 1 do begin
      if I = 0 then begin
        Offs := 0;
        Len := RulerWidth - FEdgeSize;
      end
      else begin
        Offs := FEdgeSize + I * B;
        if I = N - 1 then Len := C + FEdgeSize
        else Len := B;
      end;
      if Orientation = soHorizontal then
        DstR := Rect(Offs, 0, Offs + Len, TmpBmp.Height)
      else DstR := Rect(0, Offs, TmpBmp.Width, Offs + Len);
      if I = 0 then Offs := 0
      else
        if I = N - 1 then Offs := FEdgeSize + B - C
        else Offs := FEdgeSize;
      if Orientation = soHorizontal then
        BmpR := Rect(Offs, 0, Offs + DstR.Right - DstR.Left, TmpBmp.Height)
      else
        BmpR := Rect(0, Offs, TmpBmp.Width, Offs + DstR.Bottom - DstR.Top);
      TmpBmp.Canvas.CopyRect(DstR, FImages[Index].Canvas, BmpR);
    end;
    FRuler.Assign(TmpBmp);
  finally
    TmpBmp.Free;
  end;
end;

procedure TspSkinCustomSlider.AdjustElements;
var
  SaveValue: Longint;
  R: TRect;
  HThumbHeight, HThumbWidth,
  VThumbHeight, VThumbWidth: Integer;
  NumStates: Integer;
begin
  GetSkinData;

  SaveValue := Value;
  R := SliderRect;

  if FIndex = -1
  then
    BuildRuler(R)
  else
    BuildSkinRuler(R);

  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      if FThumbImageList <> nil
      then
        begin
          HThumbHeight := FThumbImageList.Height;
          HThumbWidth := FThumbImageList.Width;
          VThumbHeight := FThumbImageList.Height;
          VThumbWidth := FThumbImageList.Width;
          NumStates := 1;
        end
      else
        begin
          HThumbHeight := FImages[siHThumb].Height;
          HThumbWidth := FImages[siHThumb].Width;
          VThumbHeight := FImages[siVThumb].Height;
          VThumbWidth := FImages[siVThumb].Width;
          NumStates := NumThumbStates;
        end;
    end
  else
    begin
      HThumbHeight := RectHeight(HThumbRect);
      HThumbWidth := RectWidth(HThumbRect);
      VThumbHeight := RectHeight(VThumbRect);
      VThumbWidth := RectWidth(VThumbRect);
      NumStates := 2;
    end;

    if Orientation = soHorizontal then begin
    if HThumbHeight > FRuler.Height then begin
      FThumbRect := Bounds(R.Left + Indent, R.Top + Indent,
        HThumbWidth div NumStates, HThumbHeight);
      FRulerOrg := Point(R.Left + Indent, R.Top + Indent +
        (HThumbHeight - FRuler.Height) div 2);
      FPointsRect := Rect(FRulerOrg.X, R.Top + Indent +
        HThumbHeight + 1,
        FRulerOrg.X + FRuler.Width, R.Bottom - R.Top - 1);
    end
    else begin
      FThumbRect := Bounds(R.Left + Indent, R.Top + Indent +
        (FRuler.Height - HThumbHeight) div 2,
        HThumbWidth div NumStates, HThumbHeight);
      FRulerOrg := Point(R.Left + Indent, R.Top + Indent);
      FPointsRect := Rect(FRulerOrg.X, R.Top + Indent + FRuler.Height + 1,
        FRulerOrg.X + FRuler.Width, R.Bottom - R.Top - 1);
    end;
  end
  else begin
    if VThumbWidth div NumThumbStates > FRuler.Width then
    begin
      FThumbRect := Bounds(R.Left + Indent, R.Top + Indent,
        VThumbWidth div NumStates, VThumbHeight);
      FRulerOrg := Point(R.Left + Indent + (VThumbWidth div NumStates -
        FRuler.Width) div 2, R.Top + Indent);
      FPointsRect := Rect(R.Left + Indent + VThumbWidth div NumStates + 1,
        FRulerOrg.Y, R.Right - R.Left - 1, FRulerOrg.Y + FRuler.Height);
    end
    else begin
      FThumbRect := Bounds(R.Left + Indent + (FRuler.Width -
        VThumbWidth div NumStates) div 2, R.Top + Indent,
        VThumbWidth div NumStates, VThumbHeight);
      FRulerOrg := Point(R.Left + Indent, R.Top + Indent);
      FPointsRect := Rect(R.Left + Indent + FRuler.Width + 1, FRulerOrg.Y,
        R.Right - R.Left - 1, FRulerOrg.Y + FRuler.Height);
    end;
  end;

  Value := SaveValue;
  Invalidate;
end;

procedure TspSkinCustomSlider.Sized;
begin
  AdjustElements;
end;

procedure TspSkinCustomSlider.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinCustomSlider.Changed;
begin
  if Assigned(FOnChanged) then FOnChanged(Self);
end;

procedure TspSkinCustomSlider.RangeChanged;
begin
end;

procedure TspSkinCustomSlider.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Assigned(Filer.Ancestor) then
      Result := FUserImages <> TspSkinCustomSlider(Filer.Ancestor).FUserImages
    else Result := FUserImages <> [];
  end;

begin
  if Filer is TReader then inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('UserImages', ReadUserImages, WriteUserImages,
     DoWrite);
end;

procedure TspSkinCustomSlider.ReadUserImages(Stream: TStream);
begin
  Stream.ReadBuffer(FUserImages, SizeOf(FUserImages));
end;

procedure TspSkinCustomSlider.WriteUserImages(Stream: TStream);
begin
  Stream.WriteBuffer(FUserImages, SizeOf(FUserImages));
end;

function TspSkinCustomSlider.StoreImage(Index: Integer): Boolean;
begin
  Result := TspSliderImage(Index) in FUserImages;
end;

function TspSkinCustomSlider.GetImage(Index: Integer): TBitmap;
begin
  Result := FImages[TspSliderImage(Index)];
end;

procedure TspSkinCustomSlider.SliderImageChanged(Sender: TObject);
begin
  if not (csCreating in ControlState) then Sized;
end;

procedure TspSkinCustomSlider.SetImage(Index: Integer; Value: TBitmap);
var
  Idx: TspSliderImage;
begin
  Idx := TspSliderImage(Index);
  if FImages[Idx] = nil then begin
    FImages[Idx] := TBitmap.Create;
    FImages[Idx].OnChange := SliderImageChanged;
  end;
  if Value = nil then begin
    FImages[Idx].Handle := LoadBitmap(HInstance, ImagesResNames[Idx]);
    Exclude(FUserImages, Idx);
    if not (csReading in ComponentState) then begin
      if Idx in [siHThumb, siVThumb] then Exclude(FOptions, soThumbOpaque)
      else Exclude(FOptions, soRulerOpaque);
      Invalidate;
    end;
  end
  else begin
    FImages[Idx].Assign(Value);
    Include(FUserImages, Idx);
  end;
end;

procedure TspSkinCustomSlider.SetEdgeSize(Value: Integer);
var
  MaxSize: Integer;
begin
  if Orientation = soHorizontal then MaxSize := FImages[siHRuler].Width
  else MaxSize := FImages[siVRuler].Height;
  if Value * 2 < MaxSize then
    if Value <> FEdgeSize then begin
      FEdgeSize := Value;
      Sized;
    end;
end;

function TspSkinCustomSlider.GetNumThumbStates: TspNumThumbStates;
begin
  Result := FNumThumbStates;
end;

procedure TspSkinCustomSlider.SetNumThumbStates(Value: TspNumThumbStates);
begin
  if FNumThumbStates <> Value then begin
    FNumThumbStates := Value;
    AdjustElements;
  end;
end;

procedure TspSkinCustomSlider.SetOrientation(Value: TspSliderOrientation);
begin
  if Orientation <> Value then begin
    FOrientation := Value;
    Sized;
    if ComponentState * [csLoading, csUpdating] = [] then
      SetBounds(Left, Top, Height, Width);
  end;
end;

procedure TspSkinCustomSlider.SetOptions(Value: TspSliderOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;
    Invalidate;
  end;
end;

procedure TspSkinCustomSlider.SetRange(Min, Max: Longint);
begin
  if (Min < Max) or (csReading in ComponentState) then begin
    FMinValue := Min;
    FMaxValue := Max;
    if not (csReading in ComponentState) then
      if Min + Increment > Max then FIncrement := Max - Min;
    if (soShowPoints in Options) then Invalidate;
    Self.Value := FValue;
    RangeChanged;
  end;
end;

procedure TspSkinCustomSlider.SetMinValue(Value: Longint);
begin
  if FMinValue <> Value then SetRange(Value, MaxValue);
end;

procedure TspSkinCustomSlider.SetMaxValue(Value: Longint);
begin
  if FMaxValue <> Value then SetRange(MinValue, Value);
end;

procedure TspSkinCustomSlider.SetIncrement(Value: Longint);
begin
  if (Value > 0) and (FIncrement <> Value) then begin
    FIncrement := Value;
    Self.Value := FValue;
    Invalidate;
  end;
end;

function TspSkinCustomSlider.GetValueByOffset(Offset: Integer): Longint;
var
  Range: Double;
  R: TRect;
  VThumbHeight: Integer;
begin
  // *
  R := SliderRect;

  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      if FThumbImageList <> nil
      then
        VThumbHeight := FThumbImageList.Height
      else
        VThumbHeight := FImages[siVThumb].Height;
    end
  else
    VThumbHeight := RectHeight(VThumbRect);

  if Orientation = soVertical then
    Offset := ClientHeight - Offset - VThumbHeight;
  Range := MaxValue - MinValue;
  Result := Round((Offset - R.Left - Indent) * Range / GetRulerLength);
  if not (soSmooth in Options) then
    Result := Round(Result / Increment) * Increment;
  Result := Min(MinValue + Max(Result, 0), MaxValue);
end;

function TspSkinCustomSlider.GetOffsetByValue(Value: Longint): Integer;
var
  Range: Double;
  R: TRect;
  MinIndent: Integer;
  VThumbHeight: Integer;
begin
  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      if FThumbImageList <> nil
      then
        VThumbHeight := FThumbImageList.Height
      else
        VThumbHeight := FImages[siVThumb].Height;
    end
  else
    VThumbHeight := RectHeight(VThumbRect);

  R := SliderRect;
  Range := MaxValue - MinValue;
  if Orientation = soHorizontal then
    MinIndent := R.Left + Indent
  else
    MinIndent := R.Top + Indent;
  Result := Round((Value - MinValue) / Range * GetRulerLength) + MinIndent;
  if Orientation = soVertical then
    Result := R.Top + R.Bottom - Result - VThumbHeight;
  Result := Max(Result, MinIndent);
end;

function TspSkinCustomSlider.GetThumbPosition(var Offset: Integer): TPoint;
var
  R: TRect;
  MinIndent: Integer;
begin
  R := SliderRect;
  if Orientation = soHorizontal then
    MinIndent := R.Left + Indent
  else
    MinIndent := R.Top + Indent;
  Offset := Min(GetOffsetByValue(GetValueByOffset(Min(Max(Offset, MinIndent),
    MinIndent + GetRulerLength))), MinIndent + GetRulerLength);
  if Orientation = soHorizontal then begin
    Result.X := Offset;
    Result.Y := FThumbRect.Top;
  end
  else begin
    Result.Y := Offset;
    Result.X := FThumbRect.Left;
  end;
end;

function TspSkinCustomSlider.GetThumbOffset: Integer;
begin
  if Orientation = soHorizontal then Result := FThumbRect.Left
  else Result := FThumbRect.Top;
end;

procedure TspSkinCustomSlider.InvalidateThumb;
begin
  if HandleAllocated then
    InvalidateRect(Handle, @FThumbRect, not (csOpaque in ControlStyle));
end;

procedure TspSkinCustomSlider.SetThumbOffset(Value: Integer);
var
  ValueBefore: Longint;
  P: TPoint;
begin
  ValueBefore := FValue;
  P := GetThumbPosition(Value);
  InvalidateThumb;
  FThumbRect := Bounds(P.X, P.Y, RectWidth(FThumbRect), RectHeight(FThumbRect));
  InvalidateThumb;
  if FSliding then begin
    FValue := GetValueByOffset(Value);
    if ValueBefore <> FValue then Change;
  end;
end;

function TspSkinCustomSlider.GetRulerLength: Integer;
begin
  if (FIndex = -1) or not FUseSkinThumb
  then
    begin
      if FThumbImageList <> nil
      then
        begin
          if Orientation = soHorizontal then begin
            Result := FRuler.Width;
            Dec(Result, FThumbImageList.Width);
          end
          else begin
            Result := FRuler.Height;
            Dec(Result, FThumbImageList.Height);
          end;
        end
      else
      if Orientation = soHorizontal then begin
        Result := FRuler.Width;
        Dec(Result, FImages[siHThumb].Width div NumThumbStates);
      end
      else begin
        Result := FRuler.Height;
        Dec(Result, FImages[siVThumb].Height);
      end;
    end
  else
    begin
      if Orientation = soHorizontal then begin
        Result := FRuler.Width;
        Dec(Result, RectWidth(HThumbRect) div 2);
      end
      else begin
        Result := FRuler.Height;
        Dec(Result, RectHeight(VThumbRect));
      end;
    end;
end;

procedure TspSkinCustomSlider.SetValue(Value: Longint);
var
  ValueChanged: Boolean;
begin
  if Value > MaxValue then Value := MaxValue;
  if Value < MinValue then Value := MinValue;
  ValueChanged := FValue <> Value;
  FValue := Value;
  ThumbOffset := GetOffsetByValue(Value);
  if ValueChanged then Change;
end;

procedure TspSkinCustomSlider.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then begin
    if Value then begin
      StopTracking;
      if FSliding then ThumbMouseUp(mbLeft, [], 0, 0);
    end;
    FReadOnly := Value;
  end;
end;

procedure TspSkinCustomSlider.ThumbJump(Jump: TspJumpMode);
var
  NewValue: Longint;
begin
  if Jump <> jmNone then begin
    case Jump of
      jmHome: NewValue := MinValue;
      jmPrior:
        NewValue := (Round(Value / Increment) * Increment) - Increment;
      jmNext:
        NewValue := (Round(Value / Increment) * Increment) + Increment;
      jmEnd: NewValue := MaxValue;
      else Exit;
    end;
    if NewValue >= MaxValue then NewValue := MaxValue
    else if NewValue <= MinValue then NewValue := MinValue;
    if (NewValue <> Value) then Value := NewValue;
  end;
end;

function TspSkinCustomSlider.JumpTo(X, Y: Integer): TspJumpMode;
begin
  Result := jmNone;
  if Orientation = soHorizontal then begin
    if FThumbRect.Left > X then Result := jmPrior
    else if FThumbRect.Right < X then Result := jmNext;
  end
  else if Orientation = soVertical then begin
    if FThumbRect.Top > Y then Result := jmNext
    else if FThumbRect.Bottom < Y then Result := jmPrior;
  end;
end;

procedure TspSkinCustomSlider.WMTimer(var Message: TMessage);
begin
  TimerTrack;
end;

procedure TspSkinCustomSlider.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  InvalidateThumb;
end;

procedure TspSkinCustomSlider.CMFocusChanged(var Message: TCMFocusChanged);
var
  Active: Boolean;
begin
  with Message do Active := (Sender = Self);
  if Active <> FFocused then begin
    FFocused := Active;
    if (soShowFocus in Options) then Invalidate;
  end;
  inherited;
end;

procedure TspSkinCustomSlider.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TspSkinCustomSlider.WMSize(var Message: TWMSize);
begin
  inherited;
  if not (csReading in ComponentState) then Sized;
end;

procedure TspSkinCustomSlider.StopTracking;
begin
  if FTracking then begin
    if FTimerActive then begin
      KillTimer(Handle, 1);
      FTimerActive := False;
    end;
    FTracking := False;
    MouseCapture := False;
    Changed;
  end;
end;

procedure TspSkinCustomSlider.TimerTrack;
var
  Jump: TspJumpMode;
begin
  Jump := JumpTo(FMousePos.X, FMousePos.Y);
  if Jump = FStartJump then begin
    ThumbJump(Jump);
    if not FTimerActive then begin
      SetTimer(Handle, 1, JumpInterval, nil);
      FTimerActive := True;
    end;
  end;
end;

procedure TspSkinCustomSlider.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Rect: TRect;
  P: TPoint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and not (ssDouble in Shift) then begin
    if CanFocus then SetFocus;
    P := Point(X, Y);
    if PtInRect(FThumbRect, P) then
      ThumbMouseDown(Button, Shift, X, Y)
    else begin
      with FRulerOrg, FRuler do
        Rect := Bounds(X, Y, Width, Height);
      InflateRect(Rect, Ord(Orientation = soVertical) * 3,
        Ord(Orientation = soHorizontal) * 3);
      if PtInRect(Rect, P) and CanModify and not ReadOnly then begin
        MouseCapture := True;
        FTracking := True;
        FMousePos := P;
        FStartJump := JumpTo(X, Y);
        TimerTrack;
      end;
    end;
  end;
end;

procedure TspSkinCustomSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (csLButtonDown in ControlState) and FSliding then
    ThumbMouseMove(Shift, X, Y)
  else if FTracking then FMousePos := Point(X, Y);
  inherited MouseMove(Shift, X, Y);
end;

procedure TspSkinCustomSlider.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  StopTracking;
  if FSliding then ThumbMouseUp(Button, Shift, X, Y);
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TspSkinCustomSlider.KeyDown(var Key: Word; Shift: TShiftState);
var
  Jump: TspJumpMode;
begin
  Jump := jmNone;
  if Shift = [] then begin
    if Key = VK_HOME then Jump := jmHome
    else if Key = VK_END then Jump := jmEnd;
    if Orientation = soHorizontal then begin
      if Key = VK_LEFT then Jump := jmPrior
      else if Key = VK_RIGHT then Jump := jmNext;
    end
    else begin
      if Key = VK_UP then Jump := jmNext
      else if Key = VK_DOWN then Jump := jmPrior;
    end;
  end;
  if (Jump <> jmNone) and CanModify and not ReadOnly then begin
    Key := 0;
    ThumbJump(Jump);
    Changed;
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TspSkinCustomSlider.ThumbMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if CanFocus then SetFocus;
  if (Button = mbLeft) and CanModify and not ReadOnly then begin
    FSliding := True;
    FThumbDown := True;
    if Orientation = soHorizontal then FHit := X - FThumbRect.Left
    else FHit := Y - FThumbRect.Top;
    InvalidateThumb;
    Update;
  end;
end;

procedure TspSkinCustomSlider.ThumbMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (csLButtonDown in ControlState) and CanModify and not ReadOnly then
  begin
    if Orientation = soHorizontal then ThumbOffset := X - FHit
    else ThumbOffset := Y - FHit;
  end;
end;

procedure TspSkinCustomSlider.ThumbMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then begin
    FSliding := False;
    FThumbDown := False;
    InvalidateThumb;
    Update;
    if CanModify and not ReadOnly then Changed;
  end;
end;

constructor TspSkinButtonLabel.Create;
begin
  inherited;
  FIndex := -1;
  ControlStyle := ControlStyle + [csSetCaption] - [csOpaque];
  FUseCustomGlowColor := False;
  FCustomGlowColor := clAqua;
  FGlowEffect := False;
  FGlowSize := 7;
  FDoubleBuffered := False;
  FWebStyle := False;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FUseSkinFont := True;
  FDefaultActiveFontColor := clBlue;
  FNumGlyphs := 1;
  FMargin := -1;
  FSpacing := 1;
  FImageIndex := -1;
  FActiveImageIndex := -1;
  FImageList := nil;
  FLayout := blGlyphLeft;
  FGlyph := TBitMap.Create;
  Width := 100;
  Height := 50;
end;

destructor TspSkinButtonLabel.Destroy;
begin
  FDefaultFont.Free;
  FGlyph.Free;
  inherited;
end;

procedure TspSkinButtonLabel.SetDoubleBuffered(Value: Boolean);
begin
  FDoubleBuffered := Value;
  if FDoubleBuffered
  then ControlStyle := ControlStyle + [csOpaque]
  else ControlStyle := ControlStyle - [csOpaque];
end;

procedure TspSkinButtonLabel.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      RePaint;
    end;
end;

procedure TspSkinButtonLabel.CMTextChanged;
begin
  inherited;
  RePaint;
end;

procedure TspSkinButtonLabel.MouseDown;
begin
  FDown := True;
  if not FWebStyle then RePaint;
  inherited;
end;

procedure TspSkinButtonLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {$IFDEF VER200}
  if ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and FMouseIn and FDown
  then
    Perform(CM_MOUSELEAVE, 0, 0)
  else
  if not ((X < 0) or (Y < 0) or (X > Width) or (Y > Height)) and not FMouseIn and FDown
  then
    Perform(CM_MOUSEENTER, 0, 0);
  {$ENDIF}
end;

procedure TspSkinButtonLabel.MouseUp;
begin
  FDown := False;
  if not FWebStyle then RePaint;
  inherited;
end;

procedure TspSkinButtonLabel.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinButtonLabel.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinButtonLabel.SetLayout;
begin
  if FLayout <> Value
  then
    begin
      FLayout := Value;
      RePaint;
    end;
end;

procedure TspSkinButtonLabel.SetSpacing;
begin
  if Value <> FSpacing
  then
    begin
      FSpacing := Value;
      RePaint;
    end;
end;

procedure TspSkinButtonLabel.SetMargin;
begin
  if (Value <> FMargin) and (Value >= -1)
  then
    begin
      FMargin := Value;
      RePaint;
    end;
end;

procedure TspSkinButtonLabel.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) or not Enabled then Exit;
  FMouseIn := True;
  RePaint;
end;

procedure TspSkinButtonLabel.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) or not Enabled then Exit;
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinButtonLabel.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  RePaint;
end;

procedure TspSkinButtonLabel.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FImageList)
  then FImageList := nil;
end;

procedure TspSkinButtonLabel.ChangeSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);

  if (FIndex <> -1)
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinStdLabelControl
      then
        with TspDataSkinStdLabelControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.FontName := FontName;
          Self.FontColor := FontColor;
          Self.FontHeight := FontHeight;
          Self.ActiveFontColor := ActiveFontColor;
          Self.FontStyle := FontStyle;
        end
    end;

  RePaint;
end;

procedure TspSkinButtonLabel.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then ChangeSkinData;
end;

procedure TspSkinButtonLabel.SetWebStyle(Value: Boolean);
begin
  FWebStyle := Value;
  if (csDesigning in ComponentState) then
   if Value then Cursor := crHandPoint else Cursor := crDefault;	
end;

procedure TspSkinButtonLabel.Paint;

function GetGlyphNum: Integer;
begin
  if FDown and FMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if FMouseIn and (FNumGlyphs > 3)
  then
    Result := 4
  else
    if not Enabled and (FNumGlyphs > 1)
    then
      Result := 2
    else
      Result := 1;
end;

var
  Buffer: TBitMap;
  C: TCanvas;
  GlowColor: TColor;
  IIndex: Integer;
begin
  if FDoubleBuffered
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      GetParentImage(Self, Buffer.Canvas);
      C := Buffer.Canvas;
    end
  else
    C := Canvas;

  if FIndex <> -1
  then
    with C.Font do
    begin
      if FUseSkinFont
      then
        begin
          Name := FontName;
          Height := FontHeight;
          Style := FontStyle;
        end
      else
        C.Font := FDefaultFont;

      if FMouseIn and not FGlowEffect
      then
        Color := ActiveFontColor
      else
        Color := FontColor;
    end
  else
    begin
      C.Font := FDefaultFont;
      if FMouseIn
      then
        C.Font.Color := FDefaultActiveFontColor;
   end;

  if FIndex <> -1
  then
    begin
      GlowColor := ActiveFontColor;
    end
  else
    begin
      GlowColor := FCustomGlowColor;
    end;

  if FUseCustomGlowColor then GlowColor := CustomGlowColor;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    C.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    C.Font.CharSet := FDefaultFont.Charset;

  if FWebStyle
  then
    if FMouseIn
    then C.Font.Style := C.Font.Style + [fsUnderLine]
    else C.Font.Style := C.Font.Style - [fsUnderLine];

  if (FImageList <> nil) and (FActiveImageIndex >= 0) and
     (FActiveImageIndex < FImageList.Count) and FMouseIn
  then
    IIndex := FActiveImageIndex
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    IIndex := FImageIndex
  else
    IIndex := -1;

  if FIndex <> -1
  then
    begin
      if not Enabled then C.Font.Color := FSD.SkinColors.cBtnShadow;
    end
  else
    begin
      if not Enabled then C.Font.Color := clGray;
    end;


  if IIndex <> -1
  then
    begin
      if FGlowEffect and FMouseIn and Enabled
      then
        DrawImageAndTextGlow(C, ClientRect, FMargin, FSpacing, FLayout,
        Caption, IIndex, FImageList,
        False, Enabled, False, 0, GlowColor, FGlowSize)
      else
      DrawImageAndText(C, ClientRect, FMargin, FSpacing, FLayout,
        Caption, IIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
  begin
    if FGlowEffect and FMouseIn and Enabled
    then
      DrawGlyphAndTextGlow(C,
        ClientRect, FMargin, FSpacing, FLayout,
        Caption, FGlyph, FNumGlyphs, GetGlyphNum, False, False, 0,
        GlowColor, FGlowSize)
    else
      DrawGlyphAndText(C,
        ClientRect, FMargin, FSpacing, FLayout,
        Caption, FGlyph, FNumGlyphs, GetGlyphNum, False, False, 0);
  end;    

  if FDoubleBuffered
  then
    begin
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end;
end;


{ TspSkinCustomCheckGroup }

constructor TspSkinCustomCheckGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csDoubleClicks];
  FButtons := TList.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FColumns := 1;
  FItemIndex := -1;
  FButtonSkinDataName := 'checkbox';
  FButtonDefaultFont := TFont.Create;
  with FButtonDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

procedure TspSkinCustomCheckGroup.SetImages(Value: TCustomImageList);
var
  I: Integer;
begin
  FImages := Value;
  if FButtons.Count > 0
  then
    for I := 0 to FButtons.Count - 1 do
      with TspCheckGroupButton (FButtons[I]) do
        Images := Self.Images;
end;

procedure TspSkinCustomCheckGroup.UpDateButtonsFont;
var
  i: Integer;
begin
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspCheckGroupButton(FButtons[I]) do
     begin
       DefaultFont.Assign(FButtonDefaultFont);
       UseSkinFont := Self.UseSkinFont;
       Invalidate;
     end;
end;

procedure TspSkinCustomCheckGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then Images := nil;
  end;
end;

procedure TspSkinCustomCheckGroup.SetButtonDefaultFont;
var
  I: Integer;
begin
  FButtonDefaultFont.Assign(Value);
  if FButtons.Count > 0
  then
    for I := 0 to FButtons.Count - 1 do
      with TspCheckGroupButton (FButtons[I]) do
        DefaultFont.Assign(FButtonDefaultFont);
end;

destructor TspSkinCustomCheckGroup.Destroy;
begin
  FButtonDefaultFont.Free;
  SetButtonCount(0);
  TStringList(FItems).OnChange := nil;
  FItems.Free;
  FButtons.Free;
  inherited Destroy;
end;

function TspSkinCustomCheckGroup.GetCheckedStatus(Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FButtons.Count)
  then
    Result := TspCheckGroupButton(FButtons[Index]).Checked
  else
    Result := False;
end;

procedure TspSkinCustomCheckGroup.SetCheckedStatus(Index: Integer; Value: Boolean);
begin
  if (Index >= 0) and (Index < FButtons.Count)
  then
    TspCheckGroupButton(FButtons[Index]).Checked := Value;
end;

procedure TspSkinCustomCheckGroup.UpdateButtons;
var
  I: Integer;
begin
  SetButtonCount(FItems.Count);
  for I := 0 to FButtons.Count - 1 do
    TspGroupButton (FButtons[I]).Caption := FItems[I];
  ArrangeButtons;
  Invalidate;
end;

procedure TspSkinCustomCheckGroup.ChangeSkinData;
begin
  inherited;
  Self.ArrangeButtons;
end;

procedure TspSkinCustomCheckGroup.SetSkinData;
var
  I: Integer;
begin
  inherited;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspCheckGroupButton (FButtons[I]) do
       SkinData := Value;
end;

procedure TspSkinCustomCheckGroup.SetButtonSkinDataName;
var
  I: Integer;
begin
  FButtonSkinDataName := Value;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspCheckGroupButton (FButtons[I]) do
       SkinDataName := Value;
end;

procedure TspSkinCustomCheckGroup.FlipChildren(AllLevels: Boolean);
begin
  { The radio buttons are flipped using BiDiMode }
end;

procedure TspSkinCustomCheckGroup.ArrangeButtons;
var
  ButtonsPerCol, ButtonWidth, ButtonHeight, TopMargin, I: Integer;
  DeferHandle: THandle;
  ALeft: Integer;
  ButtonsRect: TRect;
begin
  if (FButtons.Count <> 0) and not FReading then
  begin
    ButtonsRect := Rect(0, 0, Width, Height);
    AdjustClientRect(ButtonsRect);
    ButtonsPerCol := (FButtons.Count + FColumns - 1) div FColumns;
    ButtonWidth := RectWidth(ButtonsRect) div FColumns - 2;
    I := RectHeight(ButtonsRect);
    ButtonHeight := I div ButtonsPerCol;
{    if FIndex <> -1
    then
      if FButtons.Count > 0
      then
        with TspGroupButton(FButtons[0]) do
        begin
          GetSkinData;
          if FIndex <> -1 then ButtonHeight := RectHeight(SkinRect);
        end;}
    TopMargin := ButtonsRect.Top;
    DeferHandle := BeginDeferWindowPos(FButtons.Count);
    try
      for I := 0 to FButtons.Count - 1 do
        with TspCheckGroupButton(FButtons[I]) do
        begin
          BiDiMode := Self.BiDiMode;
          ALeft := (I div ButtonsPerCol) * ButtonWidth + ButtonsRect.Left + 1;
          if UseRightToLeftAlignment then
            ALeft := RectWidth(ButtonsRect) - ALeft - ButtonWidth;
          DeferHandle := DeferWindowPos(DeferHandle, Handle, 0,
            ALeft,
            (I mod ButtonsPerCol) * ButtonHeight + TopMargin,
            ButtonWidth, ButtonHeight,
            SWP_NOZORDER or SWP_NOACTIVATE);
          Visible := True;
        end;
    finally
      EndDeferWindowPos(DeferHandle);
    end;
  end;
end;

procedure TspSkinCustomCheckGroup.ButtonClick(Sender: TObject);
begin
  if not FUpdating then
  begin
    FItemIndex := FButtons.IndexOf(Sender);
    Changed;
    Click;
  end;
end;

procedure TspSkinCustomCheckGroup.ItemsChange(Sender: TObject);
begin
  if not FReading then
  begin
    UpdateButtons;
  end;
end;

procedure TspSkinCustomCheckGroup.Loaded;
begin
  inherited Loaded;
  ArrangeButtons;
end;

procedure TspSkinCustomCheckGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  inherited ReadState(Reader);
  FReading := False;
  UpdateButtons;
end;

procedure TspSkinCustomCheckGroup.SetButtonCount(Value: Integer);
var
  i: Integer;
begin
  while FButtons.Count < Value do TspCheckGroupButton .InternalCreate(Self);
  while FButtons.Count > Value do TspCheckGroupButton (FButtons.Last).Free;
  if FButtons.Count > 0
  then
   for I := 0 to FButtons.Count - 1 do
     with TspCheckGroupButton (FButtons[I]) do
     begin
       ImageIndex := I;
       SkinData := Self.SkinData;
       SkinDataName := ButtonSkinDataName;
       DefaultFont.Assign(FButtonDefaultFont);
       UseSkinFont := Self.UseSkinFont;
     end;
end;

procedure TspSkinCustomCheckGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 16 then Value := 16;
  if FColumns <> Value then
  begin
    FColumns := Value;
    ArrangeButtons;
    Invalidate;
  end;
end;

procedure TspSkinCustomCheckGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TspSkinCustomCheckGroup.CMEnabledChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FButtons.Count - 1 do
    TspCheckGroupButton(FButtons[I]).Enabled := Enabled;
end;

procedure TspSkinCustomCheckGroup.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ArrangeButtons;
end;

procedure TspSkinCustomCheckGroup.WMSize(var Message: TWMSize);
begin
  inherited;
  ArrangeButtons;
end;


constructor TspSkinBevel.Create;
begin
  inherited;
  FSD := nil;
  FSkinDataName := 'bevel';
  LightColor := clBtnHighLight;
  DarkColor := clBtnShadow;
  FIndex := -1;
  FDividerMode := False;
end;

procedure TspSkinBevel.SetBounds;
var
  R: TRect;
begin
  if Parent is TspSkinToolbar
  then
    begin
      with TspSkinToolbar(Parent) do
      begin
        R := GetSkinClientRect;
        ATop := R.Top + RectHeight(R) div 2 - AHeight div 2;
      end;
    end;
  inherited;
end;

procedure TspSkinBevel.SetSkinData(Value: TspSkinData);
begin
  FSD := Value;
  ChangeSkinData;
end;

procedure TspSkinBevel.SetDividerMode(Value: Boolean);
begin
  FDividerMode := Value;
  RePaint;
end;

procedure TspSkinBevel.ChangeSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  if FIndex = -1
  then
    begin
      LightColor := clBtnHighLight;
      DarkColor := clBtnShadow;
    end
  else
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinBevel
    then
      with TspDataSkinBevel(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.LightColor := LightColor;
        Self.DarkColor := DarkColor;
      end;
  RePaint;
end;

procedure TspSkinBevel.Paint;
const
  XorColor = $00FFD8CE;
var
  Color1, Color2: TColor;
  Temp: TColor;

  procedure BevelRect(const R: TRect);
  begin
    with Canvas do
    begin
      Pen.Color := Color1;
      PolyLine([Point(R.Left, R.Bottom), Point(R.Left, R.Top),
        Point(R.Right, R.Top)]);
      Pen.Color := Color2;
      PolyLine([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
        Point(R.Left, R.Bottom)]);
    end;
  end;

  procedure BevelLine(C: TColor; X1, Y1, X2, Y2: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := C;
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end;
  end;

begin
  with Canvas do
  begin
    if (csDesigning in ComponentState) then
    begin
      if (Shape = bsSpacer) then
      begin
        Pen.Style := psDot;
        Pen.Mode := pmXor;
        Pen.Color := XorColor;
        Brush.Style := bsClear;
        Rectangle(0, 0, ClientWidth, ClientHeight);
        Exit;
      end
      else
      begin
        Pen.Style := psSolid;
        Pen.Mode  := pmCopy;
        Pen.Color := clBlack;
        Brush.Style := bsSolid;
      end;
    end;

    Pen.Width := 1;

    // must be skin

    if Style = bsLowered then
    begin
      Color1 := DarkColor;
      Color2 := LightColor;
    end
    else
    begin
      Color1 := LightColor;
      Color2 := DarkColor;
    end;

    //
    if FDividerMode
    then
      begin
        case Shape of
          bsTopLine, bsBottomLine:
            BevelRect(Rect(2, Height div 2 - 1, Width - 2, Height div 2));
          bsLeftLine, bsRightLine, bsBox, bsFrame:
            BevelRect(Rect(Width div 2 - 1, 2, Width div 2, Height - 2));
        end;
      end
    else
    case Shape of
      bsBox: BevelRect(Rect(0, 0, Width - 1, Height - 1));
      bsFrame:
        begin
          Temp := Color1;
          Color1 := Color2;
          BevelRect(Rect(1, 1, Width - 1, Height - 1));
          Color2 := Temp;
          Color1 := Temp;
          BevelRect(Rect(0, 0, Width - 2, Height - 2));
        end;
      bsTopLine:
        begin
          BevelLine(Color1, 0, 0, Width, 0);
          BevelLine(Color2, 0, 1, Width, 1);
        end;
      bsBottomLine:
        begin
          BevelLine(Color1, 0, Height - 2, Width, Height - 2);
          BevelLine(Color2, 0, Height - 1, Width, Height - 1);
        end;
      bsLeftLine:
        begin
          BevelLine(Color1, 0, 0, 0, Height);
          BevelLine(Color2, 1, 0, 1, Height);
        end;
      bsRightLine:
        begin
          BevelLine(Color1, Width - 2, 0, Width - 2, Height);
          BevelLine(Color2, Width - 1, 0, Width - 1, Height);
        end;
    end;
  end;
end;

// TspSkinButtonsBar

constructor TspButtonBarSection.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FItems := TspButtonBarItems.create(self);
  FHint := '';
  FTag := 0;
  FSpacing := 1;
  FMargin := -1;
  FEnabled := True;
end;

procedure TspButtonBarSection.SetMargin;
begin
  FMargin := Value;
  Changed(False);
end;

procedure TspButtonBarSection.SetSpacing;
begin
  FSpacing := Value;
  Changed(False);
end;


procedure TspButtonBarSection.Assign(Source: TPersistent);
begin
  if Source is TspButtonBarSection then
  begin
    Text := TspButtonBarSection(Source).Text;
    ImageIndex := TspButtonBarSection(Source).ImageIndex;
    Tag := TspButtonBarSection(Source).Tag;
    OnClick := TspButtonBarSection(source).OnClick;
    OnDblClick := TspButtonBarSection(source).OnDblClick;
    Margin := TspButtonBarSection(source).Margin;
    Spacing := TspButtonBarSection(source).Spacing;
    Enabled := TspButtonBarSection(source).Enabled;
  end
  else inherited Assign(Source);
end;

function TspButtonBarSection.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;


procedure TspButtonBarSection.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure TspButtonBarSection.SetItems(const Value: TspButtonBarItems);
begin
  FItems.assign(Value);
end;

destructor TspButtonBarSection.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TspButtonBarSection.SectionClick(const Value: TNotifyEvent);
begin
  FonClick := Value;
end;

procedure TspButtonBarSection.SectionDblClick(const Value: TNotifyEvent);
begin
  FonDblClick := Value;
end;


procedure TspButtonBarSection.Click;
begin
  if assigned(onClick) then
    onclick(self);
end;

procedure TspButtonBarSection.DblClick;
begin
  if assigned(onDblClick) then
    onDblclick(self);
end;

procedure TspButtonBarSection.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

constructor TspButtonBarSections.Create(ButtonsBar: TspSkinButtonsBar);
begin
  inherited Create(TspButtonBarSection);
  FButtonsBar := ButtonsBar;
end;

function TspButtonBarSections.GetButtonsBar: TspSkinButtonsBar;
begin
  Result := FButtonsBar;
end;

function TspButtonBarSections.Add: TspButtonBarSection;
begin
  Result := TspButtonBarSection(inherited Add);
end;

function TspButtonBarSections.GetItem(Index: Integer): TspButtonBarSection;
begin
  Result := TspButtonBarSection(inherited GetItem(Index));
end;

function TspButtonBarSections.GetOwner: TPersistent;
begin
  Result := FButtonsBar;
end;

procedure TspButtonBarSections.SetItem(Index: Integer; Value: TspButtonBarSection);
begin
  inherited SetItem(Index, Value);
end;

procedure TspButtonBarSections.Update(Item: TCollectionItem);
begin
  if Item = nil
  then FButtonsBar.UpdateSections
  else FButtonsBar.UpdateSection(Item.Index);
end;

constructor TspSkinButtonsBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FItemGlowEffect := False;

  FItemIndex := -1;

  FShowSelectedItem := False;

  FWebStyle := False;
  FShowButtons := True;
  FShowItemHint := True;

  FDefaultSectionFont := TFont.Create;
  with FDefaultSectionFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  FDefaultItemFont := TFont.Create;
  with FDefaultItemFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  FUpButton := nil;
  FDownButton := nil;

  FSectionButtonSkinDataName := 'toolbutton';

  BorderStyle := bvFrame;
  FItemsPanel := TspSkinPanel.Create(Self);
  with FItemsPanel do
  begin
    Parent := Self;
    Align := alClient;
    BorderStyle := bvNone;
    OnResize := OnItemPanelResize;
  end;
  Width := 150;
  FDefaultButtonHeight := 25;
  FItemHeight := 60;
  FItemsTransparent := True;
  Align := alLeft;
  FSectionButtons := TList.Create;
  FSectionItems := TList.Create ;
  FSections := TspButtonBarSections.Create(Self);
end;

destructor TspSkinButtonsBar.Destroy;
begin
  FDefaultSectionFont.Free;
  FDefaultItemFont.Free;
  ClearItems;
  ClearSections;
  FSectionButtons.Free;
  FSectionItems.Free;
  FItemsPanel.Free;
  FSections.Free;
  inherited Destroy;
end;

procedure TspSkinButtonsBar.AddItem(ASectionIndex: Integer;
                                    AItem: TspButtonBarItem);
var
  I: TspButtonBarItem;
begin
  I := TspButtonBarItem(Sections[ASectionIndex].Items.Add);
  if (I <> nil) and (AItem <> nil)
  then
    I.Assign(AItem);
  if SectionIndex = ASectionIndex then UpdateSection(ASectionIndex);
  if AItem <> nil then AItem.Free;
end;

procedure TspSkinButtonsBar.InsertItem(AItemIndex, ASectionIndex: Integer;
                                       AItem: TspButtonBarItem);
var
  I: TspButtonBarItem;
begin
  I := TspButtonBarItem(Sections[ASectionIndex].Items.Insert(AItemIndex));
  if (I <> nil) and (AItem <> nil)
  then
    I.Assign(AItem);
  if SectionIndex = ASectionIndex then UpdateSection(ASectionIndex);
  if AItem <> nil then AItem.Free;
end;

procedure TspSkinButtonsBar.DeleteItem(AItemIndex, ASectionIndex: Integer);
begin
  Sections[ASectionIndex].Items.Delete(AItemIndex);
  if SectionIndex = ASectionIndex then UpdateSection(ASectionIndex);
end;

function TspSkinButtonsBar.GetItemIndex;
begin
  Result := FItemIndex;
end;

procedure TspSkinButtonsBar.SetItemIndex;
begin
  if (ASectionIndex >= 0) and (ASectionIndex < Self.Sections.Count)
  then
    OpenSection(ASectionIndex);
  if (AItemIndex >= 0) and (AItemIndex < Sections[ASectionIndex].Items.Count)
  then
    with TspSectionItem(FSectionItems[AItemIndex]) do
    begin
      if FShowSelectedItem then SetDown(True);
      ButtonClick;
    end;
end;

procedure TspSkinButtonsBar.SetItemIndex2;
begin
  if (AItemIndex >= 0) and (AItemIndex < Sections[ASectionIndex].Items.Count)
  then
    with TspSectionItem(FSectionItems[AItemIndex]) do
    begin
      if FShowSelectedItem then SetDown(True);
    end;
end;

procedure TspSkinButtonsBar.SetShowButtons;
begin
  FShowButtons := Value;
  UpdateSections;
end;

procedure TspSkinButtonsBar.OnItemPanelResize(Sender: TObject);
begin
  CheckVisibleItems;
end;

procedure TspSkinButtonsBar.SetDefaultButtonHeight(Value: Integer);
begin
  FDefaultButtonHeight := Value;
  UpDateSectionButtons;
end;

procedure TspSkinButtonsBar.SetDefaultSectionFont;
begin
  FDefaultSectionFont.Assign(Value);
end;

procedure TspSkinButtonsBar.SetDefaultItemFont;
begin
  FDefaultItemFont.Assign(Value);
end;

procedure TspSkinButtonsBar.ChangeSkinData;
var
  i: Integer;
begin
  inherited;
  CheckVisibleItems;
  i := Self.FItemIndex;
  UpdateSectionButtons;
  if (i <> -1) and ShowSelectedItem
  then
    Self.SetItemIndex2(Self.SectionIndex, i);
end;


procedure TspSkinButtonsBar.ShowUpButton;
begin
  FUpButton := TspSkinButton.Create(Self);
  with FUpButton do
  begin
    Visible := False;
    Parent := FItemsPanel;
    CanFocused := False;
    Width := 18;
    Height := 18;
    Spacing := 0;
    SkinDataName := 'resizebutton';
    RepeatMode := True;
    RepeatInterval := 150;
    Caption := '';
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_BB_UP');
    OnClick := UpButtonClick;
    SkinData := Self.SkinData;
    Top := - Height;
    Visible := True;
  end;
end;

procedure TspSkinButtonsBar.ShowDownButton;
begin
  FDownButton := TspSkinButton.Create(Self);
  with FDownButton do
  begin
    Visible := False;
    Parent := FItemsPanel;
    CanFocused:= False;
    Width := 18;
    Height := 18;
    Spacing := 0;
    SkinDataName := 'resizebutton';
    RepeatMode := True;
    RepeatInterval := 150;
    Glyph.LoadFromResourceName(HInstance, 'SP_BB_DOWN');
    Caption := '';
    NumGlyphs := 1;
    OnClick := DownButtonClick;
    SkinData := Self.SkinData;
    Top := - Height;
    Visible := True;
  end;
end;

procedure TspSkinButtonsBar.HideUpButton;
begin
  FUpButton.Free;
  FUpButton := nil;
end;

procedure TspSkinButtonsBar.HideDownButton;
begin
  FDownButton.Free;
  FDownButton := nil;
end;

procedure TspSkinButtonsBar.UpButtonClick(Sender: TObject);
begin
  ScrollUp;
end;

procedure TspSkinButtonsBar.DownButtonClick(Sender: TObject);
begin
  ScrollDown;
end;

procedure TspSkinButtonsBar.ArangeItems;
var
  I, J: Integer;
begin

  if (TopIndex > 0) and (FUpButton = nil)
  then
    ShowUpButton
  else
    if (TopIndex = 0) and (FUpButton <> nil) then HideUpButton;

  if (TopIndex + VisibleCount < FSectionItems.Count) and (FDownButton = nil)
  then
    ShowDownButton
  else
  if (TopIndex + VisibleCount >= FSectionItems.Count) and (FDownButton <> nil)
  then
    HideDownButton;


  if FUpButton <> nil
  then
    with FUpButton do
      SetBounds(FItemsPanel.Width - Width - 5, 5, Width, Height);

  if FDownButton <> nil
  then
    with FDownButton do
      SetBounds(FItemsPanel.Width - Width - 5, FItemsPanel.Height - Height - 5, Width, Height);

  J := 0;
  for I := 0 to FSectionItems.Count - 1 do
  with TspSectionItem(FSectionItems.Items[I]) do
  if Visible
  then
    begin
      SetBounds(0, J, FItemsPanel.Width, FItemHeight);
      Inc(J, FItemHeight);
      Parent := FItemsPanel;
    end;

end;

procedure TspSkinButtonsBar.CheckVisibleItems;
var
  I: Integer;
  OldVisibleCount, OldTopIndex: Integer;
  CanVisible: Boolean;
begin
  OldVisibleCount := VisibleCount;
  OldTopIndex := TopIndex;
  VisibleCount := FItemsPanel.Height div FItemHeight;

  if VisibleCount > FSectionItems.Count
  then VisibleCount := FSectionItems.Count;

  if VisibleCount = FSectionItems.Count
  then
    TopIndex := 0
  else
    if (TopIndex + VisibleCount > FSectionItems.Count) and (TopIndex > 0)
    then
     begin
       TopIndex := TopIndex - (VisibleCount - OldVisibleCount);
       if TopIndex < 0 then TopIndex := 0;
     end;

  for I := 0 to FSectionItems.Count - 1 do
  with TspSectionItem(FSectionItems.Items[I]) do
  begin
    CanVisible := (I >= TopIndex) and (I <= TopIndex + VisibleCount - 1);
    if CanVisible and not Visible
    then
      begin
        if I < OldTopIndex
        then
          begin
            Top := 0;
            Visible := CanVisible;
          end
        else
          begin
            Top := FItemsPanel.Height;
            Visible := CanVisible;
          end;
      end
    else
      begin
        Visible := CanVisible;
        if not Visible then Parent := nil;
      end;
  end;

  ArangeItems;
end;

procedure TspSkinButtonsBar.ScrollUp;
begin
  if (TopIndex = 0) or (VisibleCount = 0) then Exit;
  TspSectionItem(FSectionItems.Items[TopIndex + VisibleCount - 1]).Visible := False;
  Dec(TopIndex);
  TspSectionItem(FSectionItems.Items[TopIndex]).Visible := True;
  ArangeItems;
end;

procedure TspSkinButtonsBar.ScrollDown;
begin
  if VisibleCount = 0 then Exit;
  if TopIndex + VisibleCount >= FSectionItems.Count then Exit;
  TspSectionItem(FSectionItems.Items[TopIndex]).Visible := False;
  Inc(TopIndex);
  TspSectionItem(FSectionItems.Items[TopIndex + VisibleCount - 1]).Visible := True;
  ArangeItems;
end;

procedure TspSkinButtonsBar.SetItemHeight;
begin
  FItemHeight := Value;
  UpdateItems;
end;

procedure TspSkinButtonsBar.SetItemsTransparent;
begin
  FItemsTransparent := Value;
  UpdateItems;
end;

procedure TspSkinButtonsBar.UpDateSectionButtons;
var
  I: Integer;
begin
  if Sections.Count = 0 then Exit;
  for I := 0 to Sections.Count - 1 do UpdateSection(I);
end;

procedure TspSkinButtonsBar.OpenSection(Index: Integer);
var
  I: Integer;
begin

  if FSectionIndex = Index then Exit;

  if not (csDesigning in ComponentState) and not (csLoading in ComponentState)
  then
    if Assigned(FOnChanging) then FOnChanging(Self);


  FSectionIndex := Index;

  if FShowButtons and (FSectionIndex <> -1)
  then
    begin
      for I := 0 to FSectionButtons.Count - 1 do
      with TspSectionButton(FSectionButtons.Items[I]) do
      begin
       if (FItemIndex > FSectionIndex) and (Align <> alBottom) then Align := alBottom;
      end;

      for I := FSectionButtons.Count - 1 downto 0 do
      with TspSectionButton(FSectionButtons.Items[I]) do
      begin
        if (FItemIndex <= FSectionIndex) and (Align <> alTop) then Align := alTop;
      end;
    end
  else
  if FShowButtons and (FSectionIndex = -1)
  then
    begin
      for I := FSectionButtons.Count - 1 downto 0 do
      with TspSectionButton(FSectionButtons.Items[I]) do
      begin
        Align := alTop;
      end;
    end;

  UpdateItems;

  if Index <> -1 then Sections[Index].Click;

  if not (csDesigning in ComponentState) and not (csLoading in ComponentState)
  then
    if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinButtonsBar.ClearItems;
var
  I: Integer;
begin
  if FSectionItems = nil then Exit;
  if FSectionItems.Count = 0 then Exit;
  for I := FSectionItems.Count - 1 downto 0 do
  begin
    TspSectionItem(FSectionItems.Items[I]).Free;
  end;
  FSectionItems.Clear;
end;

procedure TspSkinButtonsBar.ClearSections;
var
  I: Integer;
begin
  if FSectionButtons = nil then Exit;
  if FSectionButtons.Count = 0 then Exit;
  for I := 0 to FSectionButtons.Count - 1 do
  begin
    TspSectionButton(FSectionButtons.Items[I]).Free;
  end;
  FSectionButtons.Clear;
end;

procedure TspSkinButtonsBar.SetSkinData;
begin
  inherited;
  if FItemsPanel <> nil
  then
    begin
      FItemsPanel.SkinDataName := Self.SkindataName;
      FItemsPanel.SkinData := Value;
      UpdateSections;
    end;
end;

procedure TspSkinButtonsBar.CreateWnd;
begin
  inherited CreateWnd;
  UpdateSections;
  UpdateItems;
end;

procedure TspSkinButtonsBar.SetSections(Value: TspButtonBarSections);
begin
  FSections.Assign(Value);
end;

procedure TspSkinButtonsBar.UpdateSection(Index: Integer);
var
  S: TspButtonBarSection;
  I: Integer;
  B: Boolean;
begin
  if not HandleAllocated then Exit;
  if FSections.Count = 0 then Exit;
  if not FShowButtons
  then
    begin
      UpdateItems;
      Exit;
    end;
  S := TspButtonBarSection(Sections.Items[Index]);
  for I := 0 to FSectionButtons.Count - 1 do
  with TspSectionButton(FSectionButtons.Items[I]) do
  if FItemIndex = Index then
  begin
    DefaultHeight := DefaultButtonHeight;
    Hint := S.Hint;
    Margin := S.Margin;
    Spacing := S.Spacing;
    ShowHint := Self.ShowItemHint;
    B := Caption <> S.Text;
    Enabled := S.Enabled;
    if B then Caption := S.Text;
    if (S.ImageIndex <> -1) and (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
    then
      begin
        ImageIndex := S.ImageIndex;
        FButtonImages := FSectionImages;
      end
    else
      begin
        ImageIndex := -1;
        FButtonImages := nil;
      end;
    RePaint;
    if (FSectionIndex = Index) and not B then UpdateItems;
    Break;
  end;
end;

procedure TspSkinButtonsBar.UpdateSections;
var
  I: Integer;
  S: TspButtonBarSection;
  WantUpdateItems: Boolean;
begin
  if not HandleAllocated then Exit;
  if FSections.Count = 0 then Exit;

  WantUpdateItems := False;

  if FSectionIndex > FSections.Count - 1
  then
    begin
      FSectionIndex := FSections.Count - 1;
      WantUpdateItems := True;
    end;

  ClearSections;

  if not FShowButtons
  then
    begin
      CheckVisibleItems;
      Exit;
    end;

  for I := FSectionIndex downto 0  do
  begin
    S := TspButtonBarSection(Sections.Items[I]);
    FSectionButtons.Add(TspSectionButton.CreateEx(Self, Self, I));
    with TspSectionButton(FSectionButtons.Items[FSectionButtons.Count - 1]) do
    begin
      Align := alTop;
      Parent := Self;
      DefaultHeight := DefaultButtonHeight;
      SkinData := Self.SkinData;
      Caption := S.Text;
      Hint := S.Hint;
      Margin := S.Margin;
      Spacing := S.Spacing;
      ShowHint := Self.ShowItemHint;
      Enabled := S.Enabled;
      if (S.ImageIndex <> -1) and (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
      then
        begin
          ImageIndex := S.ImageIndex;
          FButtonImages := FSectionImages;
        end
      else
        begin
          ImageIndex := -1;
          FButtonImages := nil;
        end;
    end;
  end;

  for I := Sections.Count - 1 downto  FSectionIndex + 1  do
  begin
    S := TspButtonBarSection(Sections.Items[I]);
    FSectionButtons.Add(TspSectionButton.CreateEx(Self, Self, I));
    with TspSectionButton(FSectionButtons.Items[FSectionButtons.Count - 1]) do
    begin
      Align := alBottom;
      Parent := Self;
      DefaultHeight := DefaultButtonHeight;
      SkinData := Self.SkinData;
      Caption := S.Text;
      Hint := S.Hint;
      Margin := S.Margin;
      Spacing := S.Spacing;
      ShowHint := Self.ShowItemHint;
      Enabled := S.Enabled;
      if (S.ImageIndex <> -1) and (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
      then
        begin
          ImageIndex := S.ImageIndex;
          FButtonImages := FSectionImages;
        end
      else
        begin
          ImageIndex := -1;
          FButtonImages := nil;
        end;
    end;
  end;
  //
  if WantUpdateItems then UpdateItems else CheckVisibleItems;
end;

procedure TspSkinButtonsBar.UpdateItems;
var
  I: Integer;
  It: TspButtonBarItem;
begin
  if not HandleAllocated then Exit;
  if FSections.Count = 0 then Exit;
  if FShowButtons and (FSectionButtons.Count = 0) then Exit;
  ClearItems;

  if FSectionIndex = -1
  then
    begin
      if FUpButton <> nil then HideUpButton;
      if FDownButton <> nil then HideDownButton;
      Exit;
    end;
 
  if FUpButton <> nil then HideUpButton;
  if FDownButton <> nil then HideDownButton;
  if FSections.Items[FSectionIndex].Items.Count = 0 then Exit;
  TopIndex := 0;
  for I := 0 to FSections.Items[FSectionIndex].Items.Count - 1 do
  begin
    It := TspButtonBarItem(FSections.Items[FSectionIndex].Items[I]);
    FSectionItems.Add(TspSectionItem.CreateEx(FItemsPanel, Self, FSectionIndex, I, FWebStyle));
    with TspSectionItem(FSectionItems.Items[FSectionItems.Count - 1]) do
    begin
      FWebStyle := Self.WebStyle;
      Flat := FItemsTransparent or FWebStyle;
      if FWebStyle then Cursor := crHandPoint else Cursor := crDefault;
      DefaultHeight := FItemHeight;
      SkinData := Self.SkinData;
      Caption := It.Text;
      Hint := It.Hint;
      ShowHint := Self.ShowItemHint;
      Enabled := It.Enabled;
      if FShowSelectedItem then GroupIndex := 1;
      if (It.ImageIndex <> -1) and (FItemImages <> nil) and (It.ImageIndex < FitemImages.Count)
      then
        begin
          ImageIndex := It.ImageIndex;
          FButtonImages := FItemImages;
        end
      else
        begin
          ImageIndex := -1;
          FButtonImages := nil;
        end;
      Layout := It.Layout;
      Margin := It.Margin;
      Spacing := It.Spacing;
    end;
  end;
  CheckVisibleItems;
end;

procedure TspSkinButtonsBar.SetSectionIndex(const Value: integer);
begin
  if (Value >= -1) and (Value <> FSectionIndex) and (Value < Sections.Count)
  then
    begin
      OpenSection(Value);
    end;
end;

procedure TspSkinButtonsBar.SetItemImages(const Value: TCustomImageList);
begin
  FItemImages := Value;
  UpdateItems;
end;

procedure TspSkinButtonsBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (operation=opremove) and (Acomponent = FItemImages) then
    SetItemImages(nil);
  if (operation=opremove) and (Acomponent=FSectionImages) then
    SetSectionImages(nil);
end;


procedure TspSkinButtonsBar.SetSectionImages(const Value: TCustomImageList);
begin
  FSectionImages := Value;
  UpDateSectionButtons;
end;

procedure TspButtonBarItem.Assign(Source: TPersistent);
begin
  if Source is TspButtonBarItem then
  begin
    Text := TspButtonBarItem(Source).Text;
    ImageIndex:=TspButtonBarItem(source).ImageIndex;
    OnClick:=TspButtonBarItem(source).OnClick;
    OnDblClick := TspButtonBarItem(source).OnDblClick;
    Tag :=TspButtonBarItem(source).Tag;
    Layout :=TspButtonBarItem(source).Layout;
    Margin := TspButtonBarItem(source).Margin;
    Spacing := TspButtonBarItem(source).Spacing;
    Enabled := TspButtonBarItem(source).Enabled;
  end
  else inherited Assign(Source);
end;

procedure TspButtonBarItem.SetLayout;
begin
  FLayout := Value;
  Changed(False);
end;

procedure TspButtonBarItem.Click;
begin
  if assigned(onClick) then
    onClick(self);
end;

procedure TspButtonBarItem.DblClick;
begin
  if assigned(onDblClick) then
    onDblClick(self);
end;


constructor TspButtonBarItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTag := 0;
  FLayout := blGlyphTop;
  FMargin := -1;
  FSpacing := 1;
  FHint := '';
  FEnabled := True;
end;

procedure TspButtonBarItem.SetMargin;
begin
  FMargin := Value;
  Changed(False);
end;

procedure TspButtonBarItem.SetSpacing;
begin
  FSpacing := Value;
  Changed(False);
end;

function TspButtonBarItem.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;


procedure TspButtonBarItem.SetImageIndex(const Value: integer);
begin
  if FImageIndex<>value then
  begin
    FImageIndex := Value;
    changed(false)
  end;
end;

procedure TspButtonBarItem.ItemClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;

procedure TspButtonBarItem.ItemDblClick(const Value: TNotifyEvent);
begin
  FOnDblClick := Value;
end;


procedure TspButtonBarItem.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;

end;

function TspButtonBarItems.Add: TspButtonBarItem;
begin
  Result := TspButtonBarItem(inherited Add);
end;

constructor TspButtonBarItems.Create(Section: TspButtonBarSection);
begin
  inherited Create(TspButtonBarItem);
  FSection := Section;
end;

function TspButtonBarItems.GetItem(Index: Integer): TspButtonBarItem;
begin
  Result := TspButtonBarItem(inherited GetItem(Index));
end;

function TspButtonBarItems.GetOwner: TPersistent;
begin
  Result := FSection;
end;

procedure TspButtonBarItems.SetItem(Index: Integer; Value: TspButtonBarItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TspButtonBarItems.Update(Item: TCollectionItem);
begin
  FSection.Changed(False);
end;

constructor TspSectionButton.CreateEx;
begin
  inherited Create(AOwner);
  FButtonsBar := AButtonsBar;
  FItemIndex := AIndex;
  NumGlyphs := 1;
  Spacing := 5;
  SkinDataName := FButtonsBar.SectionButtonSkinDataName;
  DefaultFont := FButtonsBar.DefaultSectionFont;
  UseSkinFont := FButtonsBar.UseSkinFont;
end;

procedure TspSectionButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); 
begin
  inherited;
  if (Button = mbLeft) and (ssDouble in Shift)
  then
    FButtonsBar.Sections[FItemIndex].DblClick;
end;

procedure TspSectionButton.ButtonClick;
begin
  FButtonsBar.Sections[FItemIndex].Click;
  FButtonsBar.OpenSection(FItemIndex);
  inherited;
end;

constructor TspSectionItem.CreateEx;
begin
  inherited Create(AOwner);
  FWebStyle := AWebStyle;
  if FWebStyle
  then
    begin
      Cursor := crHandPoint;
      Flat := True;
     end;
  FButtonsBar := AButtonsBar;
  FItemIndex := AIndex;
  FSectionIndex := ASectionIndex;
  Flat := True;
  AlphaBlend := False;
  SkinDataName := 'resizebutton';
  NumGlyphs := 1;
  Layout := blGlyphTop;
  Spacing := 5;
  DefaultFont := FButtonsBar.DefaultItemFont;
  UseSkinFont := FButtonsBar.UseSkinFont;
end;

procedure  TspSectionItem.SetTempTransparent(Value: Boolean); 
begin
  if not FWebStyle then inherited;
end;

procedure TspSectionItem.Paint;

function GetGlyphNum: Integer;
begin
  if FDown and FMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if FMouseIn and (FNumGlyphs > 3)
  then
    Result := 4
  else
    if not Enabled and (FNumGlyphs > 1)
    then
      Result := 2
    else
      Result := 1;
end;

var
  LabelFontColor, LabelActiveFontColor: TColor;
  LabelData: TspDataSkinStdLabelControl;
  CIndex: Integer;
  GlowColor: TColor;
  R: TRect;
begin
  if not FWebStyle
  then
    begin
      inherited;
      Exit;
    end
  else
  if FDown and (GroupIndex > 0) then FMouseIn := FDown;
  //
  if (FSD = nil) or FSD.Empty
  then
    CIndex := -1
  else
    CIndex := FSD.GetControlIndex('stdlabel');
  if CIndex <> -1
  then
    with TspDataSkinStdLabelControl(FSD.CtrlList[CIndex]) do
    begin
      GlowColor := ActiveFontColor;
      LabelFontColor := FontColor;
      LabelActiveFontColor := ActiveFontColor;
    end
  else
    begin
      GlowColor := clAqua;
      LabelFontColor := DefaultFont.Color;
      LabelActiveFontColor := clBlue;
    end;
  //
  GetSkinData;
  if FIndex <> -1
  then
    with Canvas.Font do
    begin
      if FUseSkinFont
      then
        begin
          Name := FontName;
          Height := FontHeight;
          Style := FontStyle;
        end
      else
        Canvas.Font := FDefaultFont;

      if FMouseIn and not FButtonsBar.ItemGlowEffect
      then
        Color := LabelActiveFontColor
      else
        Color := LabelFontColor;
        
      if not Enabled then Color := DisabledFontColor; 
    end
  else
    begin
      Canvas.Font := FDefaultFont;
      if FMouseIn
      then
        Canvas.Font.Color := clBlue;
   end;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Canvas.Font.CharSet := FDefaultFont.Charset;

  if FMouseIn and not FButtonsBar.ItemGlowEffect
  then Canvas.Font.Style := Canvas.Font.Style + [fsUnderLine]
  else Canvas.Font.Style := Canvas.Font.Style - [fsUnderLine];
  
  R := Rect(2, 2, Width - 2, Height - 2);

  if FMouseIn and FButtonsBar.ItemGlowEffect
  then
    DrawImageAndTextGlow(Canvas, R, FMargin, FSpacing, FLayout,
                 Caption, FImageIndex, FButtonImages, False, Enabled, False, 0,
                 GlowColor, 8)
  else
    DrawImageAndText(Canvas, R, FMargin, FSpacing, FLayout,
                     Caption, FImageIndex, FButtonImages, False, Enabled, False, 0);

end;

procedure TspSectionItem.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); 
begin
  if not FWebStyle then inherited;
end;

procedure TspSectionItem.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  if not FWebStyle then inherited else ButtonClick;
  if (Button = mbLeft) and (ssDouble in Shift)
  then
    FButtonsBar.Sections[FSectionIndex].Items[FItemIndex].DblClick;
end;

procedure TspSectionItem.ButtonClick;
begin
  FButtonsBar.Sections[FSectionIndex].Items[FItemIndex].Click;
  inherited;
end;


{TspSkinNoteBook}

{TspSkinNoteBook}
type
  TspPageAccess = class(TStrings)
  private
    PageList: TList;
    Notebook: TspSkinNoteBook;
  protected
    function GetCount: Integer; override;
    function Get(Index: Integer): string; override;
    procedure Put(Index: Integer; const S: string); override;
    function GetObject(Index: Integer): TObject; override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    constructor Create(APageList: TList; ANotebook: TspSkinNoteBook);
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    function Add(const S: string): Integer; override;
    procedure Move(CurIndex, NewIndex: Integer); override;
  end;

constructor TspPageAccess.Create(APageList: TList; ANotebook: TspSkinNoteBook);
begin
  inherited Create;
  PageList := APageList;
  Notebook := ANotebook;
end;

function TspPageAccess.GetCount: Integer;
begin
  Result := PageList.Count;
end;

function TspPageAccess.Get(Index: Integer): string;
begin
  Result := TspSkinPage(PageList[Index]).Caption;
end;

procedure TspPageAccess.Put(Index: Integer; const S: string);
var
  Form: TCustomForm;
begin
  TspSkinPage(PageList[Index]).Caption := S;
  if NoteBook.ButtonsMode then NoteBook.UpdateButton(Index, S);
  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
end;

function TspPageAccess.GetObject(Index: Integer): TObject;
begin
  Result := PageList[Index];
end;

procedure TspPageAccess.SetUpdateState(Updating: Boolean);
begin
  { do nothing }
end;

procedure TspPageAccess.Clear;
var
  I: Integer;
  Form: TCustomForm;
begin
  for I := 0 to PageList.Count - 1 do
    TspSkinPage(PageList[I]).Free;
  PageList.Clear;
  if NoteBook.ButtonsMode then NoteBook.UpdateButtons;
  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
end;

procedure TspPageAccess.Delete(Index: Integer);
var
  Form: TCustomForm;
begin
  TspSkinPage(PageList[Index]).Free;
  PageList.Delete(Index);
  NoteBook.PageIndex := 0;
  if NoteBook.ButtonsMode then NoteBook.UpdateButtons;
  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
end;

function TspPageAccess.Add;
var
  Page: TspSkinPage;
  Form: TCustomForm;
begin
  Page := TspSkinPage.Create(Notebook);
  with Page do
  begin
    Parent := Notebook;
    Caption := S;
  end;
  PageList.Add(Page);
  NoteBook.PageIndex := PageList.Count - 1;
  Result := PageList.Count - 1;
  if NoteBook.ButtonsMode then NoteBook.UpdateButtons;
  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
end;

procedure TspPageAccess.Insert(Index: Integer; const S: string);
var
  Page: TspSkinPage;
  Form: TCustomForm;
begin
  Page := TspSkinPage.Create(Notebook);
  with Page do
  begin
    Parent := Notebook;
    Caption := S;
  end;
  PageList.Insert(Index, Page);

  NoteBook.PageIndex := Index;
  if NoteBook.ButtonsMode then NoteBook.UpdateButtons;

  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
end;

procedure TspPageAccess.Move(CurIndex, NewIndex: Integer);
var
  AObject: TObject;
begin
  if CurIndex <> NewIndex then
  begin
    AObject := PageList[CurIndex];
    PageList[CurIndex] := PageList[NewIndex];
    PageList[NewIndex] := AObject;
  end;
  if NoteBook.ButtonsMode then NoteBook.UpdateButtons;
end;

constructor TspSkinPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  ControlStyle := ControlStyle + [csNoDesignVisible];
  Align := alClient;
  BorderStyle := bvNone;
  FImageIndex := -1;
end;

procedure TspSkinPage.ReadState(Reader: TReader);
begin
  if Reader.Parent is TspSkinNoteBook then
    TspSkinNotebook(Reader.Parent).FPageList.Add(Self); 
  inherited ReadState(Reader);
end;

procedure TspSkinPage.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if not (csDesigning in ComponentState) then
    Message.Result := HTTRANSPARENT
  else
    inherited;
end;

constructor TspPageButton.CreateEx;
begin
  inherited Create(AOwner);
  FNoteBook := ANoteBook;
  FPageIndex := APageIndex;
  NumGlyphs := 1;
  Spacing := 5;
  SkinDataName := FNoteBook.ButtonSkinDataName;
end;

procedure TspPageButton.ButtonClick;
begin
  FNoteBook.PageIndex := FPageIndex;
  inherited;
end;

var
  Registered: Boolean = False;
  
constructor TspSkinNoteBook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls,
   csCaptureMouse, csClickEvents];
  FButtonsMode := False;
  FButtonSkinDataName := 'toolbutton';
  FButtons := TList.Create;
  BorderStyle := bvFrame;
  Width := 150;
  Height := 150;
  FPageList := TList.Create;
  FAccess := TspPageAccess.Create(FPageList, Self);
  FPageIndex := -1;
  FAccess.Add('Default');
  PageIndex := 0;
  Exclude(FComponentStyle, csInheritable);
  if not Registered then
  begin
    Classes.RegisterClasses([TspSkinPage]);
    Registered := True;
  end;
end;

destructor TspSkinNoteBook.Destroy;
begin
  FAccess.Free;
  FPageList.Free;
  ClearButtons;
  FButtons.Free;
  inherited Destroy;
end;

procedure TspSkinNoteBook.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (operation=opremove) and (Acomponent = FImages) then
    SetImages(nil);
end;

procedure TspSkinNoteBook.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  if FButtonsMode then UpDateButtons;
end;

procedure TspSkinNoteBook.UpdateButton;
var
  I: Integer;
  P: TspSkinPage;
begin
  for I := 0 to FButtons.Count - 1 do
  with TspPageButton(FButtons.Items[I]) do
  if FPageIndex = APageIndex
  then
    begin
      P := TspSkinPage(FPageList.Items[APageIndex]);
      Caption := ACaption;
      FButtonImages := FImages;
      ImageIndex := P.ImageIndex;
      RePaint;
    end;
end;

procedure TspSkinNoteBook.UpdateButtons;
var
  I: Integer;
  P: TspSkinPage;
begin
  if Pages.Count = 0 then Exit;
  ClearButtons;
  for I := 0 to Pages.Count - 1  do
  begin
    FButtons.Add(TspPageButton.CreateEx(Self, Self, I));
    P := TspSkinPage(FPageList.Items[I]);
    with TspPageButton(FButtons.Items[FButtons.Count - 1]) do
    begin
      if I <= Self.PageIndex
      then
        begin
          Top := Self.Height;
          Align := alTop;
        end
      else
        begin
          Top := Self.Height;
          Align := alBottom;
        end;
      Parent := Self;
      DefaultHeight := 25;
      SkinData := Self.SkinData;
      Caption := Pages[I];
      if (P.ImageIndex <> -1) and (FImages <> nil) and (P.ImageIndex < FImages.Count)
      then
        begin
          FButtonImages := FImages;
          ImageIndex := P.ImageIndex;
        end
      else
        begin
          FButtonImages := nil;
          ImageIndex := -1;
        end;
    end;
  end;
end;

procedure TspSkinNoteBook.ClearButtons;
var
  I: Integer;
begin
  if FButtons = nil then Exit;
  if FButtons.Count = 0 then Exit;
  for I := 0 to FButtons.Count - 1 do
  begin
    TspSkinSpeedButton(FButtons.Items[I]).Free;
  end;
  FButtons.Clear;
end;

procedure TspSkinNoteBook.SetButtonsMode(Value: Boolean);
begin
  FButtonsMode := Value;
  if FButtonsMode then UpDateButtons else ClearButtons;
end;

procedure TspSkinNoteBook.Loaded;
begin
  inherited;
  if (FPageIndex <> -1) and (FPageIndex >= 0) and (FPageIndex < FPageList.Count)
  then
    with TspSkinPage(FPageList[FPageIndex]) do
      SkinData := Self.SkinData;
  if FButtonsMode then UpDateButtons;
  NotebookHandlesNeeded(Self);
end;

procedure TspSkinNoteBook.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

function TspSkinNoteBook.GetChildOwner: TComponent;
begin
  Result := Self;
end;

procedure TspSkinNoteBook.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FPageList.Count - 1 do Proc(TControl(FPageList[I]));
end;

procedure TspSkinNoteBook.ReadState(Reader: TReader);
begin
  Pages.Clear;
  inherited ReadState(Reader);
  if (FPageIndex <> -1) and (FPageIndex >= 0) and (FPageIndex < FPageList.Count) then
    with TspSkinPage(FPageList[FPageIndex]) do
    begin
      BringToFront;
      SkinData := Self.SkinData;
      Visible := True;
      Align := alClient;
    end
  else FPageIndex := -1;
end;

procedure TspSkinNoteBook.ShowControl(AControl: TControl);
var
  I: Integer;
begin
  for I := 0 to FPageList.Count - 1 do
    if FPageList[I] = AControl then
    begin
      SetPageIndex(I);
      Exit;
    end;
  inherited ShowControl(AControl);
end;

procedure TspSkinNoteBook.SetPages(Value: TStrings);
begin
  FAccess.Assign(Value);
  UpdateButtons;
end;

procedure TspSkinNoteBook.SetPageIndex(Value: Integer);
var
  ParentForm: TCustomForm;
  I: Integer;
begin
  if csLoading in ComponentState then
  begin
    FPageIndex := Value;
    Exit;
  end;
  if (Value <> FPageIndex) and (Value >= 0) and (Value < FPageList.Count) then
  begin
    ParentForm := GetParentForm(Self);
    if ParentForm <> nil then
      if ContainsControl(ParentForm.ActiveControl) then
        ParentForm.ActiveControl := Self;
    with TspSkinPage(FPageList[Value]) do
    begin
      BringToFront;
      SkinData := Self.SkinData;
      Visible := True;
      Align := alClient;
    end;
    if (FPageIndex >= 0) and (FPageIndex < FPageList.Count) then
      TspSkinPage(FPageList[FPageIndex]).Visible := False;
    FPageIndex := Value;
    if ParentForm <> nil then
      if ParentForm.ActiveControl = Self then SelectFirst;
    //
    if FButtonsMode
    then
      begin
        for I := FButtons.Count - 1 downto 0 do
          with TspPageButton(FButtons.Items[I]) do
          begin
            if (FPageIndex > Self.PageIndex) and (Align <> alBottom) then Align := alBottom;
          end;
        for I := 0 to FButtons.Count - 1 do
          with TspPageButton(FButtons.Items[I]) do
          begin
            if (FPageIndex <= Self.PageIndex) and (Align <> alTop) then Align := alTop;
          end;
      end;
    //
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);
  end;
end;

procedure TspSkinNoteBook.SetActivePage(const Value: string);
begin
  SetPageIndex(FAccess.IndexOf(Value));
end;

function TspSkinNoteBook.GetActivePage: string;
begin
  Result := FAccess[FPageIndex];
end;

{TspSkinScrollPanel}

const
  ButtonSize = 12;
  HTBUTTON1 = HTOBJECT + 100;
  HTBUTTON2 = HTOBJECT + 101;

constructor TspSkinScrollPanel.Create;
begin
  inherited;
  FMouseIn := False;
  FClicksDisabled := False;
  FCanFocused := False;
  FHotScroll := False;
  TimerMode := 0;
  PanelData := nil;
  ButtonData := nil;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FScrollOffset := 0;
  FScrollTimerInterval := 50;
  Width := 150;
  Height := 30;
  FIndex := -1;
  Buttons[0].Visible := False;
  Buttons[1].Visible := False;
  FVSizeOffset := 0;
  FHSizeOffset := 0;
  SMax := 0;
  SPosition := 0;
  SOldPosition := 0;
  SPage := 0;
  FAutoSize := False;
  FSkinDataName := 'panel';
end;

function TspSkinScrollPanel.CheckActivation: Boolean;
begin
  Result := Buttons[0].Visible or Buttons[1].Visible;
end;

procedure TspSkinScrollPanel.CMSENCPaint(var Message: TMessage);
var
  C: TCanvas;
begin
  if (Message.wParam <> 0) and (Buttons[0].Visible or Buttons[1].Visible)
  then
    begin
      C := TControlCanvas.Create;
      C.Handle := Message.wParam;
      if Buttons[0].Visible then DrawButton(C, 0);
      if Buttons[1].Visible then DrawButton(C, 1);
      C.Handle := 0;
      C.Free;
      Message.Result := SE_RESULT;
    end
  else
    Message.Result := 0;
end;

procedure TspSkinScrollPanel.CMBENCPAINT;
var
  C: TCanvas;
begin
  if (Message.LParam = BE_ID)
  then
    begin
      if (Message.wParam <> 0) and (Buttons[0].Visible or Buttons[1].Visible)
      then
        begin
          C := TControlCanvas.Create;
          C.Handle := Message.wParam;
          if Buttons[0].Visible then DrawButton(C, 0);
          if Buttons[1].Visible then DrawButton(C, 1);
          C.Handle := 0;
          C.Free;
        end;
      Message.Result := BE_ID;
    end
  else
    inherited;
end;

procedure TspSkinScrollPanel.WMDESTROY(var Message: TMessage);
begin
  KillTimer(Handle, 1);
  KillTimer(Handle, 2);
  FMouseIn := False;
  inherited;
end;

procedure TspSkinScrollPanel.WMSETCURSOR(var Message: TWMSetCursor);
begin
  if (Message.HitTest = HTBUTTON1) or
     (Message.HitTest = HTBUTTON2)
  then
    begin
      Message.HitTest :=  HTCLIENT;
    end;
  inherited;
end;

procedure TspSkinScrollPanel.SetPosition(const Value: integer);
begin
  if Value <> SPosition
  then
    begin
      SPosition := Value;
      GetScrollInfo;
    end;
end;

procedure TspSkinScrollPanel.WMMOUSEWHEEL;
begin
  if Focused and FCanFocused
  then
    if Message.WParam > 0
    then
      ButtonClick(0)
    else
      ButtonClick(1);
end;

procedure TspSkinScrollPanel.KeyDown;
begin
  inherited KeyDown(Key, Shift);
  if FCanFocused then
  case Key of
    VK_UP, VK_LEFT: ButtonClick(0);
    VK_DOWN, VK_RIGHT: ButtonClick(1);
  end;
end;

procedure TspSkinScrollPanel.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if FCanFocused then
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT: Msg.Result := 1;
  end;
end;

procedure TspSkinScrollPanel.Loaded;
begin
  inherited Loaded;
  if FAutoSize then UpDateSize;
end;

procedure TspSkinScrollPanel.GetSkinData;
var
  CIndex: Integer;
begin
  PanelData := nil;
  ButtonData := nil;
  if (FSD = nil) or FSD.Empty then Exit;
  CIndex := FSD.GetControlIndex(FSkinDataName);
  if CIndex <> -1
  then
    PanelData := TspDataSkinPanelControl(FSD.CtrlList[CIndex]);
  CIndex := FSD.GetControlIndex('resizebutton');
  if CIndex <> -1
  then
    ButtonData := TspDataSkinButtonControl(FSD.CtrlList[CIndex]);
end;

destructor TspSkinScrollPanel.Destroy;
begin
  inherited;
end;

procedure TspSkinScrollPanel.UpDateSize;
begin
  SetBounds(Left, Top, Width, Height);
end;

procedure TspSkinScrollPanel.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, Self.ScrollTimerInterval, nil);
end;

procedure TspSkinScrollPanel.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinScrollPanel.WMTimer;
var
  P: TPoint;
begin
  inherited;

  if Message.TimerID = 1
  then
    begin
      case TimerMode of
        1: ButtonClick(0);
        2: ButtonClick(1);
      end;
    end;

  if Message.TimerID = 2
  then
    begin
      GetCursorPos(P);
      if WindowFromPoint(P) <> Handle
      then
        begin
          KillTimer(Handle, 2);
          CMMouseLeave;
        end;
    end;
end;


procedure TspSkinScrollPanel.AdjustClientRect(var Rect: TRect);
var
  RLeft, RTop, VMax, HMax: Integer;
begin
  case FScrollType of
    stHorizontal:
      begin
        RTop := 0;
        RLeft := - SPosition;
        HMax := Max(SMax, ClientWidth);
        VMax := ClientHeight;
      end;
    stVertical:
      begin
        RLeft := 0;
        RTop := - SPosition;
        VMax := Max(SMax, ClientHeight);
        HMax := ClientWidth;
      end;
  end;
  Rect := Bounds(RLeft, RTop,  HMax, VMax);
  inherited AdjustClientRect(Rect);
end;

procedure TspSkinScrollPanel.VScrollControls(AOffset: Integer);
begin
  ScrollBy(0, -AOffset);
  GetSkinData;
  if (PanelData <> nil) and PanelData.StretchEffect then  RePaint;
end;

procedure TspSkinScrollPanel.HScrollControls(AOffset: Integer);
begin
  ScrollBy(-AOffset, 0);
  GetSkinData;
  if (PanelData <> nil) and (PanelData.StretchEffect) then  RePaint;
end;

procedure TspSkinScrollPanel.SetBounds;
var
  i, MaxHeight, MaxWidth, OldHeight, OldWidth: Integer;
begin
  OldWidth := Width;
  OldHeight := Height;
  if FAutoSize
  then
    if FScrollType = stHorizontal
    then
      begin
        MaxHeight := 0;
        if ControlCount > 0
        then
          for i := 0 to ControlCount - 1 do
          with Controls[i] do
          begin
            if Visible
            then
            if Top + Height > MaxHeight then MaxHeight := Top + Height;
          end;
        if MaxHeight <> 0 then AHeight := MaxHeight;
      end
    else
      begin
        MaxWidth := 0;
        if ControlCount > 0
        then
          for i := 0 to ControlCount - 1 do
          with Controls[i] do
          begin
            if Visible
            then
            if Left + Width > MaxWidth then MaxWidth := Left + Width;
          end;
        if MaxWidth <> 0 then AWidth := MaxWidth;
      end;
  inherited;
  if (OldWidth <> Width)
  then
    begin
      if (OldWidth < Width) and (OldWidth <> 0)
      then FHSizeOffset := Width - OldWidth
      else FHSizeOffset := 0;
    end
  else
    FHSizeOffset := 0;
  if (OldHeight <> Height)
  then
    begin
      if (OldHeight < Height) and (OldHeight <> 0)
      then FVSizeOffset := Height - OldHeight
      else FVSizeOffset := 0;
    end
  else
    FVSizeOffset := 0;
  GetScrollInfo;
end;

procedure TspSkinScrollPanel.GetHRange;
var
  i, FMax, W, MaxRight, Offset: Integer;
begin
  MaxRight := 0;
  if ControlCount > 0
  then
  for i := 0 to ControlCount - 1 do
  with Controls[i] do
  begin
   if Visible
   then
     if Left + Width > MaxRight then MaxRight := left + Width;
  end;
  if MaxRight = 0
  then
    begin
      if Buttons[1].Visible then SetButtonsVisible(False);
      Exit;
    end;
  W := ClientWidth;
  FMax := MaxRight + SPosition;
  if (FMax > W)
  then
    begin
      if not Buttons[1].Visible then  SetButtonsVisible(True);
      if (SPosition > 0) and (MaxRight < W) and (FHSizeOffset > 0)
      then
        begin
          if FHSizeOffset > SPosition then FHSizeOffset := SPosition;
          SMax := FMax - 1;
          SPosition := SPosition - FHSizeOffset;
          SPage := W;
          HScrollControls(-FHSizeOffset);
          SOldPosition := SPosition;
        end
     else
       begin
         if (FHSizeOffset = 0) and ((FMax - 1) < SMax) and (SPosition > 0) and
            (MaxRight < W)
         then
           begin
             SMax := FMax - 1;
             SPosition := SPosition - (W - MaxRight);
             SPage := W;
             HScrollControls(MaxRight - W);
             FHSizeOffset := 0;
             SOldPosition := SPosition;
           end
         else
           begin
             SMax := FMax - 1;
             SPage := W;
           end;
          FHSizeOffset := 0;
          SOldPosition := SPosition;
        end;
    end
  else
    begin
      if SPosition > 0 then HScrollControls(-SPosition);
      FHSizeOffset := 0;
      SMax := 0;
      SPosition := 0;
      SPage := 0;
      if Buttons[1].Visible then SetButtonsVisible(False);
   end;
end;

procedure TspSkinScrollPanel.GetVRange;
var
  i, MaxBottom, H, Offset: Integer;
  FMax: Integer;
begin
  MaxBottom := 0;
  if ControlCount > 0
  then
    for i := 0 to ControlCount - 1 do
    with Controls[i] do
    begin
      if Visible
      then
        if Top + Height > MaxBottom then MaxBottom := Top + Height;
    end;
  if MaxBottom = 0
  then
    begin
      if Buttons[1].Visible then SetButtonsVisible(False);
      Exit;
    end;
  H := ClientHeight;
  FMax := MaxBottom + SPosition;
  if FMax > H
  then
    begin
      if not Buttons[1].Visible
      then
        begin
          SetButtonsVisible(True);
        end;
      if (SPosition > 0) and (MaxBottom < H) and (FVSizeOffset > 0)
      then
        begin
          if FVSizeOffset > SPosition then FVSizeOffset := SPosition;
          SMax := FMax - 1;
          SPosition := SPosition - FVSizeOffset;
          SPage := H;
          VScrollControls(- FVSizeOffset);
          FVSizeOffset := 0;
          SOldPosition := SPosition;
        end
      else
        begin
          if (FVSizeOffset = 0) and ((FMax - 1) < SMax) and (SPosition > 0) and
             (MaxBottom < H)
            then
              begin
                SMax := FMax - 1;
                SPosition := SPosition - (H - MaxBottom);
                SPage := H;
                VScrollControls(MaxBottom - H);
                FVSizeOffset := 0;
                SOldPosition := SPosition;
              end
            else
              begin
                SMax := FMax - 1;
                SPage := H;
              end;
          FVSizeOffset := 0;
          SOldPosition := SPosition;
        end;
    end
   else
     begin
       if SPosition > 0 then VScrollControls(-SPosition);
       FVSizeOffset := 0;
       SOldPosition := 0;
       SMax := 0;
       SPage := 0;
       SPosition := 0;
       if Buttons[1].Visible then SetButtonsVisible(False);
     end;
end;

procedure TspSkinScrollPanel.GetScrollInfo;
begin
  if FScrollType = stHorizontal
  then
    GetHRange
  else
    GetVRange;
end;

procedure TspSkinScrollPanel.SetButtonsVisible;
var
  F: TCustomForm;
  C: TWinControl;
begin
  if Buttons[0].Visible <> AVisible
  then
    begin
      Buttons[0].Visible := AVisible;
      Buttons[1].Visible := AVisible;
      if not (Parent is TspSkinCoolBar)
      then
        begin
          //
          C := nil;
          F := GetParentForm(Self);
          if F <> nil then C := F.ActiveControl;
          if (C <> nil) and C.Focused and
             (C.Parent <> nil) and (C.Parent.Parent <> nil)
          then
            begin
              if not ((C.Parent = Self) or (C.Parent.Parent = Self))
              then
                C := nil;
            end
          else
            C := nil;
          //
          FMouseIn := False;
          ReCreateWnd;
          HandleNeeded;
          //
          if (C <> nil) and C.Visible and not C.Focused and C.CanFocus then C.SetFocus;
          //
        end;
    end;
end;

procedure TspSkinScrollPanel.ButtonDown(I: Integer);
begin
  case I of
    0:
      begin
        TimerMode := 1;
        StartTimer;
      end;
    1:
      begin
        TimerMode := 2;
        StartTimer;
      end;
  end;
end;

procedure TspSkinScrollPanel.ButtonUp(I: Integer);
begin
  case I of
    0:
      begin
        StopTimer;
        TimerMode := 0;
        ButtonClick(0);
      end;
    1:
      begin
        StopTimer;
        TimerMode := 0;
        ButtonClick(1);
      end;
  end;
end;

procedure TspSkinScrollPanel.ButtonClick;
var
  SOffset: Integer;
begin
  if FScrollOffset = 0
  then
    SOffset := ClientWidth
  else
    SOffset := FScrollOffset;
  case I of
    0:
      if FScrollType = stHorizontal
      then
        begin
          SPosition := SPosition - SOffset;
          if SPosition < 0 then SPosition := 0;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              HScrollControls(SPosition - SOldPosition);
              GetHRange;
            end
          else
            StopTimer;
        end
      else
        begin
          SPosition := SPosition - SOffset;
          if SPosition < 0 then SPosition := 0;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              VScrollControls(SPosition - SOldPosition);
              GetVRange;
            end
          else
            StopTimer;
        end;
    1:
      if FScrollType = stHorizontal
      then
        begin
          SPosition := SPosition + SOffset;
          if SPosition > SMax - SPage + 1 then SPosition := SMax - SPage + 1;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              HScrollControls(SPosition - SOldPosition);
              GetHRange;
            end
          else
            StopTimer;
        end
      else
        begin
          SPosition := SPosition + SOffset;
          if SPosition > SMax - SPage + 1 then SPosition := SMax - SPage + 1;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              VScrollControls(SPosition - SOldPosition);
              GetVRange;
            end
          else
            StopTimer;
        end;
  end;
end;

procedure TspSkinScrollPanel.CMMouseEnter;
begin
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  if CheckActivation
  then
    begin
      KillTimer(Handle, 2);
      SetTimer(Handle, 2, 100, nil);
    end;
end;

procedure TspSkinScrollPanel.CMMouseLeave;
var
  P: TPoint;
begin
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
  GetCursorPos(P);
  if WindowFromPoint(P) <> Handle
  then
    if Buttons[0].MouseIn and Buttons[0].Visible
    then
      begin
        if TimerMode <> 0 then StopTimer;
        Buttons[0].MouseIn := False;
        SendMessage(Handle, WM_NCPAINT, 0, 0);
      end
    else
      if Buttons[1].MouseIn and Buttons[1].Visible
      then
        begin
          if TimerMode <> 0 then StopTimer;
          Buttons[1].MouseIn := False;
          SendMessage(Handle, WM_NCPAINT, 0, 0);
        end;
end;



procedure TspSkinScrollPanel.WndProc;
var
  B: Boolean;
  P: TPoint;
begin
  B := True;
  case Message.Msg of
    WM_WINDOWPOSCHANGING:
      if Self.HandleAllocated and (Align = alNone)
      then
        GetScrollInfo;
    WM_NCHITTEST:
      if not (csDesigning in ComponentState) then
      begin
        //
        if not FMouseIn then CMMouseEnter; 
        //
        P.X := LoWord(Message.lParam);
        P.Y := HiWord(Message.lParam);
        P := ScreenToClient(P);
        if (((FScrollType = stVertical) and (P.Y < 0)) or
           ((FScrollType = stHorizontal) and (P.X < 0))) and Buttons[0].Visible
        then
          begin
            Message.Result := HTBUTTON1;
            B := False;
          end
        else
        if (((FScrollType = stVertical) and (P.Y > ClientHeight)) or
           ((FScrollType = stHorizontal) and (P.X > ClientWidth))) and Buttons[1].Visible
        then
          begin
            Message.Result := HTBUTTON2;
            B := False;
          end;
      end;

    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
    begin
      if FCanFocused and not (csDesigning in ComponentState) and not Focused
      then
        begin
          FClicksDisabled := True;
          Windows.SetFocus(Handle);
          FClicksDisabled := False;
          if not Focused then Exit;
        end;
    end;

    WM_NCLBUTTONDOWN, WM_NCLBUTTONDBLCLK:
       begin
         if Message.wParam = HTBUTTON1
         then
           begin
             Buttons[0].Down := True;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonDown(0);
           end
         else
         if Message.wParam = HTBUTTON2
         then
           begin
             Buttons[1].Down := True;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonDown(1);
           end;

         if FCanFocused and not (csDesigning in ComponentState) and not Focused
         then
           begin
             FClicksDisabled := True;
             Windows.SetFocus(Handle);
             FClicksDisabled := False;
             if not Focused then Exit;
           end;

       end;

    WM_NCLBUTTONUP:
       begin
         if Message.wParam = HTBUTTON1
         then
           begin
             Buttons[0].Down := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonUp(0);
           end
         else
         if Message.wParam = HTBUTTON2
         then
           begin
             Buttons[1].Down := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonUp(1);
           end;
       end;

     WM_NCMOUSEMOVE:
       begin
         if (Message.wParam = HTBUTTON1) and (not Buttons[0].MouseIn)
         then
           begin
             Buttons[0].MouseIn := True;
             Buttons[1].MouseIn := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             if FHotScroll
             then
               begin
                 TimerMode := 1;
                 StartTimer;
               end;
           end
         else
         if (Message.wParam = HTBUTTON2) and (not Buttons[1].MouseIn)
         then
           begin
             Buttons[1].MouseIn := True;
             Buttons[0].MouseIn := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             if FHotScroll
             then
               begin
                 TimerMode := 2;
                 StartTimer;
               end;
           end;
       end;

    WM_MOUSEMOVE:
      begin
        if Buttons[0].MouseIn and Buttons[0].Visible
        then
          begin
            if TimerMode <> 0 then StopTimer;
            Buttons[0].MouseIn := False;
            SendMessage(Handle, WM_NCPAINT, 0, 0);
          end
        else
        if Buttons[1].MouseIn and Buttons[1].Visible
        then
          begin
            if TimerMode <> 0 then StopTimer;
            Buttons[1].MouseIn := False;
            SendMessage(Handle, WM_NCPAINT, 0, 0);
          end;
      end;
  end;
  if B then inherited;
end;

procedure TspSkinScrollPanel.Paint;
var
  X, Y, XCnt, YCnt, w, h,
  w1, h1, rw, rh, XO, YO: Integer;
  Buffer2, RealPicture, FSkinPicture: TBitMap;
begin


  GetSkinData;
  if PanelData = nil
  then
    BEGIN
      inherited;
      Exit;
    end;

  FSkinPicture := TBitMap(FSD.FActivePictures.Items[PanelData.PictureIndex]);

  if (ClientWidth > 0) and (ClientHeight > 0)
  then
    with PanelData do
    begin
      w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      w1 := Width;
      h1 := Height;
      XCnt := w1 div w;
      YCnt := h1 div h;
      RealPicture := TBitMap.Create;
      RealPicture.Width := w;
      RealPicture.Height := h;
      RealPicture.Canvas.CopyRect(Rect(0, 0, w, h),  FSkinPicture.Canvas,
      Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
           SkinRect.Left + ClRect.Right,
           SkinRect.Top + ClRect.Bottom));
      if StretchEffect
      then
        begin
          case StretchType of
            spstFull:
              Canvas.StretchDraw(Rect(0, 0, Width, Height), RealPicture);
            spstHorz:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := RealPicture.Width;
                Buffer2.Height := h1;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                XCnt := w1 div Buffer2.Width;
                 for X := 0 to XCnt do
                   Canvas.Draw(X * Buffer2.Width, 0, Buffer2);
                 Buffer2.Free;
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := w1;
                Buffer2.Height := RealPicture.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), RealPicture);
                YCnt := h1 div Buffer2.Height;
                for Y := 0 to YCnt do
                  Canvas.Draw(0, Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
          end;
        end
      else
        begin
          XCnt := Width div RealPicture.Width;
          YCnt := Height div RealPicture.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
           begin
             Canvas.Draw(X * w, Y * h, RealPicture);
           end;
        end;
     RealPicture.Free;
   end;
end;

procedure TspSkinScrollPanel.SetScrollOffset;
begin
  if Value >= 0 then FScrollOffset := Value;
end;

procedure TspSkinScrollPanel.SetScrollType(Value: TspScrollType);
begin
  if FScrollType <> Value
  then
    begin
      FScrollType := Value;
      SMax := 0;
      SPosition := 0;
      SOldPosition := 0;
      SPage := 0;
      Buttons[0].Visible := False;
      Buttons[1].Visible := False;
      ReCreateWnd;
    end;  
end;

procedure TspSkinScrollPanel.CreateControlDefaultImage(B: TBitMap);
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(ClientRect);
  end;
end;

procedure TspSkinScrollPanel.CreateControlSkinImage(B: TBitMap);
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(ClientRect);
  end;
end;

procedure TspSkinScrollPanel.WMNCCALCSIZE;
begin
  GetSkinData;
  with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
  begin
    if FScrollType = stHorizontal
    then
      begin
        if Buttons[0].Visible then Inc(Left, ButtonSize);
        if Buttons[1].Visible then Dec(Right, ButtonSize);
      end
    else
      begin
        if Buttons[0].Visible then Inc(Top, ButtonSize);
        if Buttons[1].Visible then Dec(Bottom, ButtonSize);
      end;
  end;
  inherited;
end;

procedure TspSkinScrollPanel.WMNCPaint;
var
  Cnvs: TCanvas;
  DC: HDC;
begin
  if Buttons[0].Visible or Buttons[1].Visible
  then
    begin
      DC := GetWindowDC(Handle);
      Cnvs := TCanvas.Create;
      Cnvs.Handle := DC;
      if Buttons[0].Visible then DrawButton(Cnvs, 0);
      if Buttons[1].Visible then DrawButton(Cnvs, 1);
      Cnvs.Handle := 0;
      ReleaseDC(Handle, DC);
      Cnvs.Free;
    end;
  inherited;
end;

procedure TspSkinScrollPanel.WMSIZE;
begin
  inherited;
  if ScrollType = stHorizontal
  then
    begin
      Buttons[0].R := Rect(0, 0, ButtonSize, Height);
      Buttons[1].R := Rect(Width - ButtonSize, 0, Width, Height);
    end
  else
    begin
      Buttons[0].R := Rect(0, 0, Width, ButtonSize);
      Buttons[1].R := Rect(0, Height - ButtonSize, Width, Height);
    end;
  if Buttons[0].Visible
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
  inherited;
end;

procedure TspSkinScrollPanel.SetScrollTimerInterval;
begin
  if Value > 0 then FScrollTimerInterval := Value;
end;

procedure TspSkinScrollPanel.DrawButton;
var
  B: TBitMap;
  R, NewCLRect: TRect;
  FSkinPicture: TBitMap;
  NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  XO, YO: Integer;
  C: TColor;
begin
  B := TBitMap.Create;
  B.Width := RectWidth(Buttons[i].R);
  B.Height := RectHeight(Buttons[i].R);
  R := Rect(0, 0, B.Width, B.Height);
  GetSkinData;
  if ButtonData = nil
  then
    begin
      C := clBtnText;
      if ((Buttons[I].Down and Buttons[I].MouseIn)) or
          (Buttons[I].MouseIn and HotScroll)
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R);
        end
      else
      if Buttons[I].MouseIn
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          B.Canvas.FillRect(R);
        end
      else
        begin
          Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
          B.Canvas.Brush.Color := clBtnFace;
          B.Canvas.FillRect(R);
        end;
    end
  else
    with ButtonData, Buttons[I] do
    begin
      //
      XO := RectWidth(R) - RectWidth(SkinRect);
      YO := RectHeight(R) - RectHeight(SkinRect);
      NewLTPoint := LTPoint;
      NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
      NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
      NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
      FSkinPicture := TBitMap(FSD.FActivePictures.Items[ButtonData.PictureIndex]);
      //
      if (Down and not IsNullRect(DownSkinRect) and MouseIn) or
         (MouseIn and HotScroll and not IsNullRect(DownSkinRect))
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, DownSkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := DownFontColor;
        end
      else
      if MouseIn and not IsNullRect(ActiveSkinRect)
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, ActiveSkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := ActiveFontColor;
        end
      else
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, SkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := FontColor;
        end;
   end;
  //
  if FScrollType = stHorizontal
  then
    begin
      case I of
        0: DrawArrowImage(B.Canvas, R, C, 1);
        1: DrawArrowImage(B.Canvas, R, C, 2);
      end;
    end
  else
    begin
      case I of
        0: DrawArrowImage(B.Canvas, R, C, 3);
        1: DrawArrowImage(B.Canvas, R, C, 4);
      end;
    end;
  //
  Cnvs.Draw(Buttons[I].R.Left, Buttons[I].R.Top, B);
  B.Free;
end;

constructor TspSkinToolBar.Create;
begin
  inherited;
  FMouseIn := False;
  FAdjustControls := True;
  ForcebackGround := False;
  FCanScroll := False;
  FSkinDataName := 'toolpanel';
  FDefaultHeight := 0;
  Height := 25;
  BorderStyle := bvNone;
  FAutoShowHideCaptions := False;
  FShowCaptions := False;
  FWidthWithCaptions := 0;
  FWidthWithoutCaptions := 0;
  // scroll
  FHotScroll := False;
  TimerMode := 0;
  ButtonData := nil;
  FScrollOffset := 0;
  FScrollTimerInterval := 50;
  Buttons[0].Visible := False;
  Buttons[1].Visible := False;
  FHSizeOffset := 0;
  SMax := 0;
  SPosition := 0;
  SOldPosition := 0;
  SPage := 0;
  //
end;


procedure TspSkinToolBar.WMDESTROY(var Message: TMessage);
begin
  KillTimer(Handle, 1);
  KillTimer(Handle, 2);
  FMouseIn := False;
  inherited;
end;


procedure TspSkinToolBar.WMSETCURSOR(var Message: TWMSetCursor);
begin
  if (Message.HitTest = HTBUTTON1) or
     (Message.HitTest = HTBUTTON2)
  then
    begin
      Message.HitTest :=  HTCLIENT;
    end;
  inherited;
end;

procedure TspSkinToolBar.AdjustAllControls;
var
  i: Integer;
  R: TRect;
begin
  R := Self.GetSkinClientRect;
  for i := 0 to Self.ControlCount - 1 do
  begin
    if not (Controls[I] is TspSkinControl) and
       not (Controls[I] is TspGraphicSkinControl)
       and (Controls[I].Align = alNone)
   then
     begin
       if Controls[I].Top <> R.Top + RectHeight(R) div 2 - Controls[I].Height div 2
       then
         Controls[I].Top := R.Top + RectHeight(R) div 2 - Controls[I].Height div 2;
     end;
  end;
end;

function TspSkinToolBar.CheckActivation;
begin
  Result := Buttons[0].Visible or Buttons[1].Visible;
end;


procedure TspSkinToolBar.WMWindowPosChanging;
begin
  inherited;
  if HandleAllocated and Self.AdjustControls
  then
    begin
      AdjustAllControls;
    end;
end;


procedure TspSkinToolBar.CreateControlSkinImage(B: TBitMap);
begin
  if ((Buttons[0].Visible) or (Buttons[1].Visible)) and (ResizeMode = 2) 
  then
    begin
      CreateHSkinImage3(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, Picture, SkinRect, Width, Height, StretchEffect);
    end
  else
    inherited;
end;

procedure TspSkinToolBar.SetBounds;
var
  MaxWidth, OldWidth: Integer;
  i: Integer;
begin
  OldWidth := Width;
  inherited;
  if FAdjustControls then
    for i := 0 to ControlCount - 1 do
      with Controls[I] do SetBounds(Left, Top, Width, Height);

  if not FCanScroll then Exit;
  if (OldWidth <> Width)
  then
    begin
      if (OldWidth < Width) and (OldWidth <> 0)
      then FHSizeOffset := Width - OldWidth
      else FHSizeOffset := 0;
    end
  else
    FHSizeOffset := 0;
  if FCanScroll then GetScrollInfo;
end;

procedure TspSkinToolBar.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, Self.ScrollTimerInterval, nil);
end;

procedure TspSkinToolBar.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinToolBar.AdjustClientRect(var Rect: TRect);
var
  RLeft, RTop, VMax, HMax: Integer;
begin
 inherited;
  if FCanScroll and (Buttons[0].Visible) or (Buttons[1].Visible)
  then
    begin
      RTop := 0;
      RLeft := - SPosition;
      HMax := Max(SMax, ClientWidth);
      VMax := ClientHeight;
      Rect := Bounds(RLeft, RTop,  HMax, VMax);
      if (FIndex <> -1) and not (csDesigning in ComponentState)
      then
        begin
          if (BorderStyle <> bvNone) or (ResizeMode <> 1)
          then
            begin
              Rect.Top := NewClRect.Top;
              Rect.Bottom := NewClRect.Bottom;
            end;
        end
     else
       begin
          Rect.Top := 1;
          Rect.Bottom := Rect.Bottom - 1;
       end;
    end;
end;

procedure TspSkinToolBar.HScrollControls(AOffset: Integer);
begin
  ScrollBy(-AOffset, 0);
  RePaint;
end;

procedure TspSkinToolBar.GetScrollInfo;
begin
  GetHRange;
end;

procedure TspSkinToolBar.GetHRange;
var
  i, FMax, W, MaxRight, Offset: Integer;
begin
  MaxRight := 0;
  if ControlCount > 0
  then
  for i := 0 to ControlCount - 1 do
  with Controls[i] do
  begin
   if Visible
   then
     if Left + Width > MaxRight then MaxRight := left + Width;
  end;
  if MaxRight = 0
  then
    begin
      if Buttons[1].Visible then SetButtonsVisible(False);
      Exit;
    end;
  W := ClientWidth;
  FMax := MaxRight + SPosition;
  if (FMax > W)
  then
    begin
      if not Buttons[1].Visible then  SetButtonsVisible(True);
      if (SPosition > 0) and (MaxRight < W) and (FHSizeOffset > 0)
      then
        begin
          if FHSizeOffset > SPosition then FHSizeOffset := SPosition;
          SMax := FMax - 1;
          SPosition := SPosition - FHSizeOffset;
          SPage := W;
          HScrollControls(-FHSizeOffset);
          SOldPosition := SPosition;
        end
     else
       begin
         if (FHSizeOffset = 0) and ((FMax - 1) < SMax) and (SPosition > 0) and
            (MaxRight < W)
         then
           begin
             SMax := FMax - 1;
             SPosition := SPosition - (W - MaxRight);
             SPage := W;
             HScrollControls(MaxRight - W);
             FHSizeOffset := 0;
             SOldPosition := SPosition;
           end
         else
           begin
             SMax := FMax - 1;
             SPage := W;
           end;
          FHSizeOffset := 0;
          SOldPosition := SPosition;
        end;
    end
  else
    begin
      if SPosition > 0 then HScrollControls(-SPosition);
      FHSizeOffset := 0;
      SMax := 0;
      SPosition := 0;
      SPage := 0;
      if Buttons[1].Visible then SetButtonsVisible(False);
   end;
end;

procedure TspSkinToolBar.ButtonUp(I: Integer);
begin
  case I of
    0:
      begin
        StopTimer;
        TimerMode := 0;
        ButtonClick(0);
      end;
    1:
      begin
        StopTimer;
        TimerMode := 0;
        ButtonClick(1);
      end;
  end;
end;

procedure TspSkinToolBar.ButtonDown(I: Integer);
begin
  case I of
    0:
      begin
        TimerMode := 1;
        StartTimer;
      end;
    1:
      begin
        TimerMode := 2;
        StartTimer;
      end;
  end;
end;

procedure TspSkinToolBar.ButtonClick;
var
  SOffset: Integer;
begin
  if FScrollOffset = 0
  then
    SOffset := ClientWidth
  else
    SOffset := FScrollOffset;
  case I of
    0:
        begin
          SPosition := SPosition - SOffset;
          if SPosition < 0 then SPosition := 0;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              HScrollControls(SPosition - SOldPosition);
              GetHRange;
            end
          else
            StopTimer;
        end;
    1:
        begin
          SPosition := SPosition + SOffset;
          if SPosition > SMax - SPage + 1 then SPosition := SMax - SPage + 1;
          if (SPosition - SOldPosition <> 0)
          then
            begin
              HScrollControls(SPosition - SOldPosition);
              GetHRange;
            end
          else
            StopTimer;
        end;
  end;
end;

procedure TspSkinToolBar.SetButtonsVisible;
var
  F: TCustomForm;
  C: TWinControl;
begin
  if Buttons[0].Visible <> AVisible
  then
    begin
      Buttons[0].Visible := AVisible;
      Buttons[1].Visible := AVisible;
      if not (Parent is TspSkinCoolBar)
      then
        begin
          //
          C := nil;
          F := GetParentForm(Self);
          if F <> nil then C := F.ActiveControl;
          if (C <> nil) and C.Focused and
             (C.Parent <> nil) and (C.Parent.Parent <> nil)
          then
            begin
              if not ((C.Parent = Self) or (C.Parent.Parent = Self))
              then
                C := nil;
            end
          else
            C := nil;
          //
          FMouseIn := False;
          ReCreateWnd;
          HandleNeeded;
          //
          if (C <> nil) and C.Visible and not C.Focused and C.CanFocus then C.SetFocus;
          //
        end;
    end;
end;

procedure TspSkinToolBar.WndProc;
var
  B: Boolean;
  P: TPoint;
begin
 B := True;
  case Message.Msg of
    WM_WINDOWPOSCHANGING:
      if Self.HandleAllocated and (Align = alNone)
      then
        GetScrollInfo;
    WM_NCHITTEST:
      if not (csDesigning in ComponentState) and FCanScroll then
      begin
        //
        if not FMouseIn then CMMouseEnter;
        //
        P.X := LoWord(Message.lParam);
        P.Y := HiWord(Message.lParam);
        P := ScreenToClient(P);
        if (P.X < 0) and Buttons[0].Visible
        then
          begin
            Message.Result := HTBUTTON1;
            B := False;
          end
        else
        if (P.X > ClientWidth) and Buttons[1].Visible
        then
          begin
            Message.Result := HTBUTTON2;
            B := False;
          end;
      end;

    WM_NCLBUTTONDOWN, WM_NCLBUTTONDBLCLK:
       if FCanScroll then
       begin
         if Message.wParam = HTBUTTON1
         then
           begin
             Buttons[0].Down := True;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonDown(0);
           end
         else
         if Message.wParam = HTBUTTON2
         then
           begin
             Buttons[1].Down := True;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonDown(1);
           end;
       end;

    WM_NCLBUTTONUP:
       if FCanScroll then
       begin
         if Message.wParam = HTBUTTON1
         then
           begin
             Buttons[0].Down := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonUp(0);
           end
         else
         if Message.wParam = HTBUTTON2
         then
           begin
             Buttons[1].Down := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             ButtonUp(1);
           end;
       end;

     WM_NCMOUSEMOVE:
       if FCanScroll then
       begin
         if (Message.wParam = HTBUTTON1) and (not Buttons[0].MouseIn)
         then
           begin
             Buttons[0].MouseIn := True;
             Buttons[1].MouseIn := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             if FHotScroll
             then
               begin
                 TimerMode := 1;
                 StartTimer;
               end;
           end
         else
         if (Message.wParam = HTBUTTON2) and (not Buttons[1].MouseIn)
         then
           begin
             Buttons[1].MouseIn := True;
             Buttons[0].MouseIn := False;
             SendMessage(Handle, WM_NCPAINT, 0, 0);
             if FHotScroll
             then
               begin
                 TimerMode := 2;
                 StartTimer;
               end;
           end;
       end;

    WM_MOUSEMOVE:
      begin
        if Buttons[0].MouseIn and Buttons[0].Visible
        then
          begin
            if TimerMode <> 0 then StopTimer;
            Buttons[0].MouseIn := False;
            SendMessage(Handle, WM_NCPAINT, 0, 0);
          end
        else
        if Buttons[1].MouseIn and Buttons[1].Visible
        then
          begin
            if TimerMode <> 0 then StopTimer;
            Buttons[1].MouseIn := False;
            SendMessage(Handle, WM_NCPAINT, 0, 0);
          end;
      end;
  end;
  if B then inherited;
end;

procedure TspSkinToolBar.CMMouseEnter;
begin
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  if CheckActivation
  then
    begin
      KillTimer(Handle, 2);
      SetTimer(Handle, 2, 100, nil);
    end;
end;

procedure TspSkinToolBar.CMMOUSELEAVE;
var
  P: TPoint;
begin
  if (csDesigning in ComponentState) or not FCanScroll then Exit;
  FMouseIn := False;
  GetCursorPos(P);
  if WindowFromPoint(P) <> Handle
  then
    if Buttons[0].MouseIn and Buttons[0].Visible
    then
      begin
        if TimerMode <> 0 then StopTimer;
        Buttons[0].MouseIn := False;
        SendMessage(Handle, WM_NCPAINT, 0, 0);
      end
    else
      if Buttons[1].MouseIn and Buttons[1].Visible
      then
        begin
          if TimerMode <> 0 then StopTimer;
          Buttons[1].MouseIn := False;
          SendMessage(Handle, WM_NCPAINT, 0, 0);
        end;
end;


procedure TspSkinToolBar.WMSIZE;
begin
  inherited;
  if FCanScroll and (Buttons[0].Visible or Buttons[1].Visible)
  then
    begin
      Buttons[0].R := Rect(0, 0, ButtonSize, Height);
      Buttons[1].R := Rect(Width - ButtonSize, 0, Width, Height);
      SendMessage(Handle, WM_NCPAINT, 0, 0);
    end;  
end;

procedure TspSkinToolBar.WMNCPaint;
var
  Cnvs: TCanvas;
  DC: HDC;
begin
  if FCanScroll and (Buttons[0].Visible or Buttons[1].Visible)
  then
    begin
      DC := GetWindowDC(Handle);
      Cnvs := TCanvas.Create;
      Cnvs.Handle := DC;
      if Buttons[0].Visible then DrawButton(Cnvs, 0);
      if Buttons[1].Visible then DrawButton(Cnvs, 1);
      Cnvs.Handle := 0;
      ReleaseDC(Handle, DC);
      Cnvs.Free;
    end;  
end;

procedure TspSkinToolBar.WMNCCALCSIZE;
begin
  if FCanScroll
  then
    begin
      GetSkinData;
      with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
      begin
        if Buttons[0].Visible then Inc(Left, ButtonSize);
        if Buttons[1].Visible then Dec(Right, ButtonSize);
      end;
    end;  
end;

procedure TspSkinToolBar.GetSkinData;
var
  CIndex: Integer;
begin
  inherited;
  ButtonData := nil;
  if FIndex <> -1
  then
    begin
      CIndex := FSD.GetControlIndex('resizebutton');
      if CIndex <> -1
      then
       ButtonData := TspDataSkinButtonControl(FSD.CtrlList[CIndex]);
    end;   
end;


procedure TspSkinToolBar.WMTimer;
var
  P: TPoint;
begin
  inherited;

  if FCanScroll
  then
    begin
      if Message.TimerID = 1
      then
        begin
          case TimerMode of
            1: ButtonClick(0);
            2: ButtonClick(1);
          end;
       end;
     if Message.TimerID = 2
     then
       begin
         GetCursorPos(P);
         if WindowFromPoint(P) <> Handle
         then
           begin
             KillTimer(Handle, 2);
             CMMouseLeave;
           end;
       end;
    end;
end;

procedure TspSkinToolBar.SetScrollTimerInterval;
begin
  if Value > 0 then FScrollTimerInterval := Value;
end;

procedure TspSkinToolBar.SetScrollOffset;
begin
  if Value >= 0 then FScrollOffset := Value;
end;

procedure TspSkinToolBar.DrawButton;
var
  B: TBitMap;
  R, NewCLRect: TRect;
  FSkinPicture: TBitMap;
  NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  XO, YO: Integer;
  C: TColor;
begin
  B := TBitMap.Create;
  B.Width := RectWidth(Buttons[i].R);
  B.Height := RectHeight(Buttons[i].R);
  R := Rect(0, 0, B.Width, B.Height);
  GetSkinData;
  if ButtonData = nil
  then
    begin
      C := clBtnText;
      if ((Buttons[I].Down and Buttons[I].MouseIn)) or
          (Buttons[I].MouseIn and HotScroll)
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          B.Canvas.FillRect(R);
        end
      else
      if Buttons[I].MouseIn
      then
        begin
          Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          B.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          B.Canvas.FillRect(R);
        end
      else
        begin
          Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
          B.Canvas.Brush.Color := clBtnFace;
          B.Canvas.FillRect(R);
        end;
    end
  else
    with ButtonData, Buttons[I] do
    begin
      //
      XO := RectWidth(R) - RectWidth(SkinRect);
      YO := RectHeight(R) - RectHeight(SkinRect);
      NewLTPoint := LTPoint;
      NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
      NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
      NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
      FSkinPicture := TBitMap(FSD.FActivePictures.Items[ButtonData.PictureIndex]);
      //
      if (Down and not IsNullRect(DownSkinRect) and MouseIn) or
         (MouseIn and HotScroll and not IsNullRect(DownSkinRect))
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, DownSkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := DownFontColor;
        end
      else
      if MouseIn and not IsNullRect(ActiveSkinRect)
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, ActiveSkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := ActiveFontColor;
        end
      else
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, SkinRect, B.Width, B.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
          C := FontColor;
        end;
   end;
  //
  case I of
    0: DrawArrowImage(B.Canvas, R, C, 1);
    1: DrawArrowImage(B.Canvas, R, C, 2);
  end;
  //
  Cnvs.Draw(Buttons[I].R.Left, Buttons[I].R.Top, B);
  B.Free;
end;

procedure TspSkinToolBar.SetShowCaptions(Value: Boolean);
var
  I: Integer;
begin
  if FShowCaptions <> Value
  then
    begin
      FShowCaptions := Value;
      if FAutoShowHideCaptions
      then
        for I := 0 to ControlCount - 1 do
          if Controls[I] is TspSkinSpeedButton
          then
            TspSkinSpeedButton(Controls[I]).ShowCaption := FShowCaptions;
      if (FWidthWithCaptions <> 0) and (FWidthWithoutCaptions <> 0)
      then
        begin
          if FShowCaptions
          then Width := FWidthWithCaptions
          else Width := FWidthWithoutCaptions;
        end;
    end;
end;

procedure TspSkinToolBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then Images := nil;
    if AComponent = FHotImages then HotImages := nil;
    if AComponent = FDisabledImages then DisabledImages := nil;
  end;
end;

procedure TspSkinToolBar.SetSkinDataName(Value: String);
var
  I: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
  for I := 0 to ControlCount - 1 do
  if Controls[I] is TspSkinMenuSpeedButton
  then
    with TspSkinMenuSpeedButton(Controls[I]) do
    begin
      if Self.SkinDataName = 'resizetoolpanel'
      then
        SkinDataName := 'resizetoolbutton'
      else
      if Self.SkinDataName = 'panel'
      then
        SkinDataName := 'resizebutton'
      else
      if TrackButtonMode
      then
        begin
          if Self.SkinDataName = 'bigtoolpanel'
          then
            SkinDataName := 'bigtoolmenutrackbutton'
          else
            SkinDataName := 'toolmenutrackbutton';
        end
      else
        begin
          if Self.SkinDataName = 'bigtoolpanel'
          then
            SkinDataName := 'bigtoolmenubutton'
          else
            SkinDataName := 'toolmenubutton';
        end;
    end
  else
  if Controls[I] is TspSkinSpeedButton
  then
    with TspSkinSpeedButton(Controls[I]) do
    begin
      if Self.SkinDataName = 'resizetoolpanel'
      then
        SkinDataName := 'resizetoolbutton'
      else
      if Self.SkinDataName = 'panel'
      then
        SkinDataName := 'resizebutton'
      else
      if Self.SkinDataName = 'bigtoolpanel'
      then
        SkinDataName := 'bigtoolbutton'
      else
        SkinDataName := 'toolbutton';
    end;
end;

procedure TspSkinToolBar.SetSkinData(Value: TspSkinData);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TspSkinSpeedButton
    then
      TspSkinSpeedButton(Controls[I]).SkinData := Self.SkinData
    else
    if Controls[I] is TspSkinBevel
    then
      TspSkinBevel(Controls[I]).SkinData := Self.SkinData
end;

procedure TspSkinToolBar.SetFlat(Value: Boolean);
var
  I: Integer;
begin
  FFlat := Value;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TspSkinSpeedButton
     then
       TspSkinSpeedButton(Controls[I]).Flat := FFlat;
end;

procedure TspSkinToolBar.SetDisabledImages(Value: TCustomImageList);
begin
  FDisabledImages := Value;
end;

procedure TspSkinToolBar.SetHotImages(Value: TCustomImageList);
begin
  FHotImages := Value;
end;

procedure TspSkinToolBar.SetImages(Value: TCustomImageList);
var
  I: Integer;
begin
  FImages := Value;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TspSkinSpeedButton
     then
       TspSkinSpeedButton(Controls[I]).RePaint;
end;


// TspSkinCoolBar

const
  GripSizeIE3 = 8;
  GripSizeIE4 = 5;
  ControlMargin = 4;
  BandBorderSize = 2;
  IDMask = $7FFFFFFF;

constructor TspSkinCoolBar.Create(AOwner: TComponent);
begin
  inherited;
  FSkinPicture := nil;
  FIndex := -1;
  FSkinDataName := 'controlbar';
  FSkinBevel := True;
end;

destructor TspSkinCoolBar.Destroy;
begin
  inherited;
end;

procedure TspSkinCoolBar.CMSENCPaint(var Message: TMessage);
begin
  if (Message.wParam <> 0) and FSkinBevel
  then
    begin
      PaintNCSkin(Message.wParam, True);
      Message.Result := SE_RESULT;
    end
  else
    Message.Result := 0;
end;


procedure TspSkinCoolBar.CheckControlsBackground;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TWinControl
    then
      SendMessage(TWinControl(Controls[i]).Handle, WM_CHECKPARENTBG, 0, 0)
    else
    if Controls[i] is TGraphicControl
    then
      TGraphicControl(Controls[i]).Perform(WM_CHECKPARENTBG, 0, 0);
  end;
end;


function TspSkinCoolBar.GetCaptionFontHeight: Integer;
var
  TxtMetric: TTextMetric;
begin
  Result := 0;
  if HandleAllocated then
    with TControlCanvas.Create do
    try
      Control := Self;
      Font := Self.Font;
      if (GetTextMetrics(Handle, TxtMetric)) then
        Result := TxtMetric.tmHeight;
    finally
      Free;
    end;
end;

function TspSkinCoolBar.GetCaptionSize(Band: TCoolBand): Integer;
var
  Text: string;
  Adjust, DesignText: Boolean;
begin
  Result := 0;
  Adjust := False;
  if (Band <> nil) and ((csDesigning in ComponentState) or Band.Visible) then
  begin
    DesignText := (csDesigning in ComponentState) and
      (Band.Control = nil) and (Band.Text = '');
    if ShowText or DesignText then
    begin
      if DesignText then
        Text := Band.DisplayName
      else
        Text := Band.Text;
      if Text <> '' then
      begin
        Adjust := True;
        if Vertical then
          Result := GetCaptionFontHeight
        else
          with TControlCanvas.Create do
          try
            Control := Self;
            Font := Self.Font;
            Result := TextWidth(Text)
          finally
            Free;
          end;
      end;
    end;
    if Band.ImageIndex >= 0 then
    begin
      if Adjust then Inc(Result, 2);
      if Images <> nil then
      begin
        Adjust := True;
        if Vertical then
          Inc(Result, Images.Height)
        else
          Inc(Result, Images.Width)
      end
      else if not Adjust then
        Inc(Result, ControlMargin);
    end;
    if Adjust then Inc(Result, ControlMargin);
    if (not FixedOrder or (Band.ID and IDMask > 0)) and not Band.FixedSize then
    begin
      Inc(Result, ControlMargin);
      if GetComCtlVersion < ComCtlVersionIE4 then
        Inc(Result, GripSizeIE3)
      else
        Inc(Result, GripSizeIE4);
    end;
  end;
end;

procedure TspSkinCoolBar.CMBENCPAINT;
begin
   if (Message.LParam = BE_ID)
  then
    begin
      if (Message.wParam <> 0) and FSkinBevel
      then
        begin
          PaintNCSkin(Message.wParam, True);
        end;
      Message.Result := BE_ID;
    end
  else
    inherited;
end;

procedure TspSkinCoolBar.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinCoolBar.AlignControls(AControl: TControl; var Rect: TRect);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ControlCount - 1 do
  begin
    Controls[i].Invalidate;
  end;
end;

procedure TspSkinCoolBar.WMSIZE;
var
  i: Integer;
begin
  inherited;
  GetSkinData;
  if (FIndex <> -1) and FSkinBevel then PaintNCSkin(0, False);
  if (FIndex <> -1) and StretchEffect then CheckControlsBackground;
end;

procedure TspSkinCoolBar.SetSkinBevel;
begin
  FSkinBevel := Value;
  if FIndex <> -1 then RecreateWnd;
end;

procedure TspSkinCoolBar.PaintNCSkin;
var
  LeftBitMap, TopBitMap, RightBitMap, BottomBitMap: TBitMap;
  DC: HDC;
  Cnvs: TControlCanvas;
  OX, OY: Integer;
begin
  if not AUseExternalDC then  DC := GetWindowDC(Handle) else DC := ADC;
  Cnvs := TControlCanvas.Create;
  Cnvs.Handle := DC;
  LeftBitMap := TBitMap.Create;
  TopBitMap := TBitMap.Create;
  RightBitMap := TBitMap.Create;
  BottomBitMap := TBitMap.Create;
  //
  OX := Width - RectWidth(SkinRect);
  OY := Height - RectHeight(SkinRect);
  NewLTPoint := LTPt;
  NewRTPoint := Point(RTPt.X + OX, RTPt.Y);
  NewLBPoint := Point(LBPt.X, LBPt.Y + OY);
  NewRBPoint := Point(RBPt.X + OX, RBPt.Y + OY);
  NewClRect := Rect(ClRect.Left, ClRect.Top,
    ClRect.Right + OX, ClRect.Bottom + OY);
  //
  CreateSkinBorderImages(LTPt, RTPt, LBPt, RBPt, ClRect,
      NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftBitMap, TopBitMap, RightBitMap, BottomBitMap,
      FSkinPicture, SkinRect, Width, Height,
      LeftStretch, TopStretch, RightStretch, BottomStretch);

  if NewClRect.Bottom > NewClRect.Top
  then
    ExcludeClipRect(Cnvs.Handle,
      NewClRect.Left, NewClRect.Top, NewClRect.Right, NewClRect.Bottom);

  Cnvs.Draw(0, 0, TopBitMap);
  Cnvs.Draw(0, TopBitMap.Height, LeftBitMap);
  Cnvs.Draw(Width - RightBitMap.Width, TopBitMap.Height, RightBitMap);
  Cnvs.Draw(0, Height - BottomBitMap.Height, BottomBitMap);
  //
  TopBitMap.Free;
  LeftBitMap.Free;
  RightBitMap.Free;
  BottomBitMap.Free;
  Cnvs.Handle := 0;
  if not AUseExternalDC then ReleaseDC(Handle, DC);
  Cnvs.Free;
end;

procedure TspSkinCoolBar.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  BGPictureIndex := -1;
  FSkinPicture := nil;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinControlBar
    then
      with TspDataSkinControlBar(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        RBPt := RBPoint;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          FSkinPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          FSkinPicture := nil;
        Self.ItemRect := ItemRect;
        Self.BGPictureIndex := BGPictureIndex;
        Self.HGripRect := HGripRect;
        Self.GripOffset1 := GripOffset1;
        Self.VGripRect := VGripRect;
        Self.GripOffset2 := GripOffset2;
        Self.LeftStretch := LeftStretch;
        Self.TopStretch := TopStretch;
        Self.RightStretch := RightStretch;
        Self.BottomStretch := BottomStretch;
        Self.StretchEffect := StretchEffect;
        Self.StretchType := StretchType;
        Self.ItemStretchEffect := ItemStretchEffect;
        Self.GripTransparent := GripTransparent;
        Self.GripTransparentColor := GripTransparentColor;
      end;
end;

procedure TspSkinCoolBar.ChangeSkinData;
begin
  GetSkinData;
  ReCreateWnd;
end;

procedure TspSkinCoolBar.SetSkinData;
begin
  FSD := Value;
  ChangeSkinData;
end;

procedure TspSkinCoolBar.WMNCCALCSIZE;
begin
  GetSkinData;
  if FIndex <> -1
  then
    begin
      if FSkinBevel then
      with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
      begin
        Inc(Left, ClRect.Left);
        Inc(Top,  ClRect.Top);
        Dec(Right, RectWidth(SkinRect) - ClRect.Right);
        Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
        if Right < Left then Right := Left;
        if Bottom < Top
        then Bottom := Top;
      end;
    end
  else
    inherited;
end;

procedure TspSkinCoolBar.WMNCPAINT(var Message: TMessage);
begin
  GetSkinData;
  if FIndex <> -1
  then
    begin
      if FSkinBevel then PaintNCSkin(0, False);
    end
  else
    inherited;
end;

procedure TspSkinCoolBar.CreateParams;
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
  end;
end;

procedure TspSkinCoolBar.WMEraseBkgnd;
var
  FCanvas: TControlCanvas;
  DC: HDC;
  i: Integer;
  R: TRect;
  X, Y, XCnt, YCnt, w, h,
  rw, rh, XO, YO: Integer;
  Buffer, Buffer2: TBitMap;
  B: TBitMap;
begin
  GetSkinData;
  if FIndex = -1
  then
    begin
      inherited;
      Exit;
    end;
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;
  DC := Message.DC;
  FCanvas.Handle := DC;
  if (ClientWidth > 0) and (ClientHeight > 0) and
     StretchEffect
  then
    begin
      if BGPictureIndex = -1
      then
        begin
          Buffer := TBitMap.Create;
          Buffer.Width := RectWidth(ClRect);
          Buffer.Height := RectHeight(ClRect);
          Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
            FSkinPicture.Canvas,
              Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                   SkinRect.Left + ClRect.Right,
                   SkinRect.Top + ClRect.Bottom));
        end
      else
        Buffer := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);

      case StretchType of
            spstFull:
              begin
                FCanvas.StretchDraw(Rect(0, 0, Width, Height), Buffer);
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := Width;
                Buffer2.Height := Buffer.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
                YCnt := Height div Buffer2.Height;
                for Y := 0 to YCnt do
                  FCanvas.Draw(0, Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
           spstHorz:
             begin
               Buffer2 := TBitMap.Create;
               Buffer2.Width := Buffer.Width;
               Buffer2.Height := Height;
               Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
               XCnt := Width div Buffer2.Width;
               for X := 0 to XCnt do
                 FCanvas.Draw(X * Buffer2.Width, 0, Buffer2);
               Buffer2.Free;
             end;
          end;

      if BGPictureIndex = -1 then Buffer.Free;
      //

      //
    end
  else
  if (ClientWidth > 0) and (ClientHeight > 0)
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := ClientWidth;
      Buffer.Height := ClientHeight;

      if BGPictureIndex = -1
      then
        begin
          w := RectWidth(ClRect);
          h := RectHeight(ClRect);
          rw := Buffer.Width;
          rh := Buffer.Height;
          with Buffer.Canvas do
          begin
            XCnt := rw div w;
            YCnt := rh div h;
            for X := 0 to XCnt do
            for Y := 0 to YCnt do
            begin
              if X * w + w > rw then XO := X * W + W - rw else XO := 0;
              if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
                CopyRect(Rect(X * w, Y * h,X * w + w - XO, Y * h + h - YO),
                   FSkinPicture.Canvas,
                   Rect(SkinRect.Left + ClRect.Left,
                        SkinRect.Top + ClRect.Top,
                        SkinRect.Left + ClRect.Right - XO,
                         SkinRect.Top + ClRect.Bottom - YO));
            end;
          end;
        end
      else
        begin
          B := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
          XCnt := Width div B.Width;
          YCnt := Height div B.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
            Buffer.Canvas.Draw(X * B.Width, Y * B.Height, B);
        end;
     FCanvas.Draw(0, 0, Buffer);
     Buffer.Free;
   end;
  FCanvas.Handle := 0;
  FCanvas.Free;
end;

procedure TspSkinCoolBar.DrawGrip(C: TCanvas; R: TRect);
var
  Buffer: TBitMap;
begin
  if IsNullRect(HGripRect) or IsNullRect(VGripRect)
  then
    begin
      if Vertical
      then
        begin
          Frm3D(C, Rect(R.Left, R.Top + 1, R.Right, R.Top + 3),
                FSD.SkinColors.cBtnHighLight,
                FSD.SkinColors.cBtnShadow);
          Frm3D(C, Rect(R.Left, R.Top + 3, R.Right, R.Top + 5),
                FSD.SkinColors.cBtnHighLight,
                FSD.SkinColors.cBtnShadow);
        end
      else
        begin
          Frm3D(C, Rect(R.Left + 1, R.Top, R.Left + 3, R.Bottom),
                FSD.SkinColors.cBtnHighLight,
                FSD.SkinColors.cBtnShadow);
          Frm3D(C, Rect(R.Left + 3, R.Top, R.Left + 5, R.Bottom),
                FSD.SkinColors.cBtnHighLight,
                FSD.SkinColors.cBtnShadow);
        end;
    end
  else
    if Vertical
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R);
        Buffer.Height := RectHeight(HGripRect);
        CreateHSkinImage(GripOffset1, GripOffset2, Buffer, FSkinPicture, HGripRect,
        Buffer.Width, Buffer.Height, ItemStretchEffect);
        if GripTransparent
        then
           begin
             Buffer.Transparent := True;
             Buffer.TransparentMode := tmFixed;
             Buffer.TransparentColor := GripTransparentColor;
           end;  
        C.Draw(R.Left, R.Top, Buffer);
        Buffer.Free;
      end
    else
      begin
        Buffer := TBitMap.Create;
        Buffer.Height := RectHeight(R);
        Buffer.Width := RectWidth(VGripRect);
        CreateVSkinImage(GripOffset1, GripOffset2, Buffer, FSkinPicture, VGripRect,
        Buffer.Width, Buffer.Height, ItemStretchEffect);
        if GripTransparent
        then
           begin
             Buffer.Transparent := True;
             Buffer.TransparentMode := tmFixed;
             Buffer.TransparentColor := GripTransparentColor;
           end;
        C.Draw(R.Left, R.Top, Buffer);
        Buffer.Free;
      end;
end;

procedure TspSkinCoolBar.WMPaint(var Message: TWMPaint);
var
  FCanvas: TControlCanvas;
  DC: HDC;
  PS: TPaintStruct;
  i: Integer;
  R, R1, TR: TRect;
  X, Y: Integer;
begin
  GetSkindata;
  if FIndex = -1
  then
    begin
      inherited;
      Exit;
    end;
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;
  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  if Vertical
  then
  for i := 0 to Self.Bands.Count - 1 do
  begin
    R.Top := Bands[i].Control.Top - GetCaptionSize(Bands[i]);
    R.Left :=  Bands[i].Control.Left;
    R.Bottom := Bands[i].Control.Top;
    R.Right := R.Left + Bands[i].Control.Width;
    //
    R1.Top := R.Top + 1;
    R1.Bottom := R1.Top + 4;
    R1.Left := R.Left;
    R1.Right := R.Right;
    DrawGrip(FCanvas, R1);
    Y := R1.Bottom + 2;
    // draw glyph
    if (Images <> nil) and (Bands[i].ImageIndex >= 0) and (Bands[i].ImageIndex < Images.Count)
    then
      begin
        X := R1.Left + RectWidth(R1) div 2 - Images.Width div 2;
        Images.Draw(FCanvas, X, Y, Bands[i].ImageIndex, True);
        Y := Y + Images.Height + 1;
      end;
    // draw text
    if (Bands[i].Text <> '') and ShowText
    then
      begin
        FCanvas.Font := Self.Font;
        FCanvas.Font.Color := FSD.SkinColors.cBtnText;
        TR := Rect(R.Left, Y, R.Right, R.Bottom);
        DrawText(FCanvas.Handle, PChar(Bands[i].Text), Length(Bands[i].Text), TR,
        DT_VCENTER or DT_SINGLELINE or DT_CENTER);
      end;
  end
  else
  for i := 0 to Self.Bands.Count - 1 do
  begin
    R.Left := Bands[i].Control.Left - GetCaptionSize(Bands[i]);
    R.Top :=  Bands[i].Control.Top;
    R.Right := Bands[i].Control.Left;
    R.Bottom := R.Top + Bands[i].Control.Height;
    //
    R1.Left := R.Left + 1;
    R1.Right := R1.Left + 4;
    R1.Top := R.Top;
    R1.Bottom := R.Bottom;
    DrawGrip(FCanvas, R1);
    X := R1.Right + 2;
    // draw glyph
    if (Images <> nil) and (Bands[i].ImageIndex >= 0) and (Bands[i].ImageIndex < Images.Count)
    then
      begin
        Y := R1.Top + RectHeight(R1) div 2 - Images.Height div 2;
        Images.Draw(FCanvas, X, Y, Bands[i].ImageIndex, True);
        X := X + Images.Width + 1;
      end;
    // draw text
    if (Bands[i].Text <> '') and ShowText
    then
      begin
        FCanvas.Font := Self.Font;
        FCanvas.Font.Color := FSD.SkinColors.cBtnText;
        TR := Rect(X, R.Top, R.Right, R.Bottom);
        DrawText(FCanvas.Handle, PChar(Bands[i].Text), Length(Bands[i].Text), TR,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT);
      end;
  end;
  FCanvas.Handle := 0;
  FCanvas.Free;
  if Message.DC = 0 then EndPaint(Handle, PS);
end;

{ TspCustomSplitter }

type
  TWinControlAccess = class(TWinControl);

constructor TspCustomSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoSnap := True;
  Align := alLeft;
  Width := 3;
  Cursor := crHSplit;
  FMinSize := 30;
  FOldSize := -1;
end;

destructor TspCustomSplitter.Destroy;
begin
  inherited Destroy;
end;

function TspCustomSplitter.FindControl: TControl;
var
  P: TPoint;
  I: Integer;
  R: TRect;
begin
  Result := nil;
  P := Point(Left, Top);
  case Align of
    alLeft: Dec(P.X);
    alRight: Inc(P.X, Width);
    alTop: Dec(P.Y);
    alBottom: Inc(P.Y, Height);
  else
    Exit;
  end;
  for I := 0 to Parent.ControlCount - 1 do
  begin
    Result := Parent.Controls[I];
    if Result.Visible and Result.Enabled then
    begin
      R := Result.BoundsRect;
      if (R.Right - R.Left) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Left)
        else
          Inc(R.Right);
      if (R.Bottom - R.Top) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Top)
        else
          Inc(R.Bottom);
      if PtInRect(R, P) then Exit;
    end;
  end;
  Result := nil;
end;

procedure TspCustomSplitter.RequestAlign;
begin
  inherited RequestAlign;

  if (csDesigning in ComponentState)
  then
    if Align in [alBottom, alTop]
    then
      FSkinDataName := 'hsplitter'
    else
      FSkinDataName := 'vsplitter';

  if (Cursor <> crVSplit) and (Cursor <> crHSplit) then Exit;

  if Align in [alBottom, alTop]
  then
    Cursor := crVSplit
  else
    Cursor := crHSplit;
end;

procedure TspCustomSplitter.WMEraseBkgnd;
begin
end;

procedure TspCustomSplitter.Paint;
begin
end;

function TspCustomSplitter.DoCanResize(var NewSize: Integer): Boolean;
begin
  Result := CanResize(NewSize);
  if Result and (NewSize <= MinSize) and FAutoSnap then
    NewSize := 0;
end;

function TspCustomSplitter.CanResize(var NewSize: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnCanResize) then FOnCanResize(Self, NewSize, Result);
end;

procedure TspCustomSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FControl := FindControl;
    FDownPos := Point(X, Y);
    if Assigned(FControl) then
    begin
      if Align in [alLeft, alRight] then
      begin
        FMaxSize := Parent.ClientWidth - FMinSize;
        for I := 0 to Parent.ControlCount - 1 do
          with Parent.Controls[I] do
            if Visible and (Align in [alLeft, alRight]) then Dec(FMaxSize, Width);
        Inc(FMaxSize, FControl.Width);
      end
      else
      begin
        FMaxSize := Parent.ClientHeight - FMinSize;
        for I := 0 to Parent.ControlCount - 1 do
          with Parent.Controls[I] do
            if Align in [alTop, alBottom] then Dec(FMaxSize, Height);
        Inc(FMaxSize, FControl.Height);
      end;
      UpdateSize(X, Y);
      with ValidParentForm(Self) do
        if ActiveControl <> nil then
        begin
          FActiveControl := ActiveControl;
          FOldKeyDown := TWinControlAccess(FActiveControl).OnKeyDown;
          TWinControlAccess(FActiveControl).OnKeyDown := FocusKeyDown;
        end;
    end;
  end;
end;

procedure TspCustomSplitter.UpdateControlSize;
begin
  if FNewSize <> FOldSize then
  begin
    case Align of
      alLeft:
        begin
          FControl.Width := FNewSize;
        end;  
      alTop: FControl.Height := FNewSize;
      alRight:
        begin
          Parent.DisableAlign;
          try
            FControl.Left := FControl.Left + (FControl.Width - FNewSize);
            FControl.Width := FNewSize;
          finally
            Parent.EnableAlign;
          end;
        end;
      alBottom:
        begin
          Parent.DisableAlign;
          try
            FControl.Top := FControl.Top + (FControl.Height - FNewSize);
            FControl.Height := FNewSize;
          finally
            Parent.EnableAlign;
          end;
        end;
    end;
    Update;
    if Assigned(FOnMoved) then FOnMoved(Self);
    FOldSize := FNewSize;
  end;
end;

procedure TspCustomSplitter.CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
var
  S: Integer;
begin
  if Align in [alLeft, alRight] then
    Split := X - FDownPos.X
  else
    Split := Y - FDownPos.Y;
  S := 0;
  case Align of
    alLeft: S := FControl.Width + Split;
    alRight: S := FControl.Width - Split;
    alTop: S := FControl.Height + Split;
    alBottom: S := FControl.Height - Split;
  end;
  NewSize := S;
  if S < FMinSize then
    NewSize := FMinSize
  else if S > FMaxSize then
    NewSize := FMaxSize;
  if S <> NewSize then
  begin
    if Align in [alRight, alBottom] then
      S := S - NewSize else
      S := NewSize - S;
    Inc(Split, S);
  end;
end;

procedure TspCustomSplitter.UpdateSize(X, Y: Integer);
begin
  CalcSplitSize(X, Y, FNewSize, FSplit);
end;

procedure TspCustomSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewSize, Split: Integer;
begin
  inherited;
  if (ssLeft in Shift) and Assigned(FControl) then
  begin
    CalcSplitSize(X, Y, NewSize, Split);
    if DoCanResize(NewSize) then
    begin
      FNewSize := NewSize;
      FSplit := Split;
      UpdateControlSize;
    end;
  end;
end;

procedure TspCustomSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Assigned(FControl) then
  begin
    UpdateControlSize;
    StopSizing;
  end;
end;

procedure TspCustomSplitter.FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    StopSizing
  else if Assigned(FOldKeyDown) then
    FOldKeyDown(Sender, Key, Shift);
end;

procedure TspCustomSplitter.StopSizing;
begin
  if Assigned(FControl) then
  begin
    FControl := nil;
    if Assigned(FActiveControl) then
    begin
      TWinControlAccess(FActiveControl).OnKeyDown := FOldKeyDown;
      FActiveControl := nil;
    end;
  end;
  if Assigned(FOnMoved) then
    FOnMoved(Self);
end;

constructor TspSkinSplitterEx.Create(AOwner: TComponent);
begin
  inherited;
  FSkinPicture := nil;
  FIndex := -1;
  FDefaultSize := 10;
  FSkinDataName := 'vsplitter';
  StretchEffect := False;
end;

destructor  TspSkinSplitterEx.Destroy;
begin
  inherited;
end;

procedure TspSkinSplitterEx.Paint;
var
  Buffer: TBitMap;
  GripperBuffer: TBitMap;
  GX, GY: Integer;
begin

  if (Width <= 0) or (Height <= 0) then Exit;
  GetSkinData;
  if (FIndex <> -1) and (Align <> alNone) and (Align <> alClient)
  then
    begin
      Buffer := TBitMap.Create;
      if (Align = alTop) or (Align = alBottom)
      then
        CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RtPt.X,
          Buffer, FSkinPicture, SkinRect, Width, RectHeight(SkinRect), StretchEffect)
      else
        CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          Buffer, FSkinPicture, SkinRect, RectWidth(SkinRect), Height, StretchEffect);
      // draw gripper
      if not IsNullRect(GripperRect)
      then
        begin
          GripperBuffer := TBitMap.Create;
          GripperBuffer.Width := RectWidth(GripperRect);
          GripperBuffer.Height := RectHeight(GripperRect);
          GripperBuffer.Canvas.CopyRect(
            Rect(0, 0, GripperBuffer.Width, GripperBuffer.Height),
            FSkinPicture.Canvas, GripperRect);
          GX := Buffer.Width div 2 - GripperBuffer.Width div 2;
          GY := Buffer.Height div 2 - GripperBuffer.Height div 2;
          if GripperTransparent
          then
            begin
              GripperBuffer.Transparent := True;
              GripperBuffer.TransparentMode := tmFixed;
              GripperBuffer.TransparentColor := GripperTransparentColor;
            end;
          Buffer.Canvas.Draw(GX, GY, GripperBuffer);
          GripperBuffer.Free;
        end;
      //
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end
  else
    with Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(ClientRect);
    end;  
end;

procedure TspSkinSplitterEx.GetSkinData;
begin
  if (FSD = nil) or FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  FSkinPicture := nil;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinSplitterControl
    then
      with TspDataSkinSplitterControl(FSD.CtrlList.Items[FIndex]) do
      begin
        LTPt := LTPoint;
        RTPt := RTPoint;
        LBPt := LBPoint;
        Self.SkinRect := SkinRect;
        Self.StretchEffect := StretchEffect;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          FSkinPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          FSkinPicture := nil;
        Self.GripperRect := GripperRect;
        Self.GripperTransparent := GripperTransparent;
        Self.GripperTransparentColor := GripperTransparentColor;
      end;
end;

procedure TspSkinSplitterEx.ChangeSkinData;
var
  lMinSize: Integer;
begin
  GetSkinData;
  if (Align = alTop) or (Align = alBottom)
  then
    begin
      if (FIndex = -1)
      then
        lMinSize := FDefaultSize
      else
        lMinSize := RectHeight(SkinRect);
      Height := lMinSize;
    end
  else
    begin
      if (FIndex = -1)
      then
        lMinSize := FDefaultSize
      else
        lMinSize := RectWidth(SkinRect);
     Width := lMinSize;
    end;
  RePaint;
end;


end.

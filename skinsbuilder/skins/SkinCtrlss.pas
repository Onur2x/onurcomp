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

unit SkinCtrlss;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, SkinData, spEffBmp, StdCtrls, SkinMenus, ComCtrls, ImgList;

type

  TspControlButton = record
    R: TRect;
    MouseIn: Boolean;
    Down: Boolean;
    Visible: Boolean;
  end;

  TspSkinControl = class(TCustomControl)
  protected
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
    procedure SetAlphaBlend(AValue: Boolean); virtual;
    procedure SetAlphaBlendValue(AValue: Byte); virtual;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure GetSkinData; virtual;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure SetSkinData(Value: TspSkinData); virtual;
    procedure SetSkinDataName(Value: String); virtual;

    procedure CreateControlDefaultImage(B: TBitMap); virtual;
    procedure CreateControlSkinImage(B: TBitMap); virtual;

  public
    FIndex: Integer;
    procedure ChangeSkinData; virtual;
    procedure BeforeChangeSkinData; virtual;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Anchors;
    property TabOrder;
    property Visible;
    property  canvas;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
  end;

  TspFrameSkinControl = class(TspSkinControl)
  protected
    FRgn: HRgn;
    FFrame: Integer;
    FrameW, FrameH: Integer;
    Picture, MaskPicture: TBitMap;

    FDefaultImage: TBitMap;
    FDefaultMask: TBitMap;
    FDefaultFramesCount: Integer;
    FDefaultFramesPlacement: TFramesPlacement;

    procedure CalcDefaultFrameSize; virtual;
    procedure SetDefaultImage(Value: TBitMap);
    procedure SetDefaultMask(Value: TBitMap);
    procedure SetDefaultFramesCount(Value: Integer);
    procedure SetDefaultFramesPlacement(Value: TFramesPlacement);

    procedure SetFrame(Value: Integer);
    procedure SetControlRegion;
    procedure GetSkinData; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure Loaded; override;
  public
    SkinRect: TRect;
    FramesCount: Integer;
    FramesPlacement: TFramesPlacement;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
    property Frame: Integer read FFrame write SetFrame;
  published
    property DefaultImage: TBitMap read FDefaultImage write SetDefaultImage;
    property DefaultMask: TBitMap read FDefaultMask write SetDefaultMask;
    property DefaultFramesPlacement: TFramesPlacement
      read FDefaultFramesPlacement write SetDefaultFramesPlacement;
    property DefaultFramesCount: Integer
      read FDefaultFramesCount write SetDefaultFramesCount;
    property ShowHint;  
  end;

  TspSkinSwitchState = (swOff, swOn);

  TspSkinSwitch = class(TspFrameSkinControl)
  protected
    FAnimateTimer: TTimer;
    FState: TspSkinSwitchState;
    FOnChange: TNotifyEvent;
    FMouseIn: Boolean;
    function GetTimerInterval: Cardinal;
    procedure SetTimerInterval(Value: Cardinal);
    procedure SetState(Value: TspSkinSwitchState);
    procedure ChangeState(Value: TspSkinSwitchState);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure DoAnimate(Sender: TObject);
    procedure Start;
    procedure Stop;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
  published
    property TimerInterval: Cardinal read GetTimerInterval write SetTimerInterval;
    property State: TspSkinSwitchState read FState write SetState;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
  end;

  TspSkinAnimate = class(TspFrameSkinControl)
  protected
    FAnimateTimer: TTimer;
    FCycleMode: Boolean;
    FButtonMode: Boolean;
    FMouseIn: Boolean;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetTimerInterval: Cardinal;
    procedure SetTimerInterval(Value: Cardinal);
    procedure DoAnimate(Sender: TObject);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
  published
    property Active: Boolean read FActive write SetActive;
    property Enabled;
    property CycleMode: Boolean read FCycleMode write FCycleMode;
    property ButtonMode: Boolean read FButtonMode write FButtonMode;
    property TimerInterval: Cardinal read GetTimerInterval write SetTimerInterval;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
  end;

  TspSkinFrameGauge = class(TspFrameSkinControl)
  protected
    FMinValue, FMaxValue, FValue: Integer;
    FVertical: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    procedure SetValue(AValue: Integer);
    procedure CalcFrame;
  public
    procedure ChangeSkinData; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Value: Integer read FValue write SetValue;
    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property PopupMenu;
    property ShowHint;
  end;

  TspSkinFrameRegulator = class(TspFrameSkinControl)
  protected
    FPixInc, FValInc: Integer;
    FDown: Boolean;
    StartV, CurV, TempValue: Integer;
    FMinValue, FMaxValue, FValue: Integer;
    FOnChange: TNotifyEvent;
    FDefaultKind: TRegulatorKind;
    procedure CalcDefaultFrameSize; override;
    procedure SetDefaultKind(Value: TRegulatorKind);
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    procedure SetValue(AValue: Integer);
    procedure GetSkinData; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CalcValue;
    procedure CalcFrame;
  public
    Kind: TRegulatorKind;
    constructor Create(AOwner: TComponent); override;
    procedure ChangeSkinData; override;
  published
    property DefaultKind: TRegulatorKind read FDefaultKind write SetDefaultKind;
    property Value: Integer read FValue write SetValue;
    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property PopupMenu;
    property ShowHint;
  end;

  TspSkinBorderStyle = (bvFrame, bvRaised, bvLowered, bvNone);
  TspSkinPanelNumGlyphs = 1..2;

  TspSkinPanel = class(TspSkinCustomControl)
  protected
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
    VisibleControls: TList;
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

    procedure HideControls;
    procedure ShowControls;
    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure DoRollUp(ARollUp: Boolean);
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
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

  TspExPanelRollKind = (rkRollHorizontal, rkRollVertical);

  TspSkinExPanel = class(TspSkinCustomControl)
  private
    FGlyph: TBitMap;
    FNumGlyphs: TspSkinPanelNumGlyphs;
    FSpacing: Integer;
    FOnChangeRollState: TNotifyEvent;
    FOnClose: TNotifyEvent;
    StopCheckSize: Boolean;
    FRollState: Boolean;
    FRollKind: TspExPanelRollKind;
    FDefaultCaptionHeight: Integer;
    VisibleControls: TList;
    FRealWidth, FRealHEight: Integer;
    FShowRollButton: Boolean;
    FShowCloseButton: Boolean;
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
    procedure Close;
  published
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
  protected
    procedure SetSkinData(Value: TspSkinData); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;
  
  TspSkinToolBar = class(TspSkinPanel)
  private
    // scroll
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
  protected
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure GetSkinData; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure SetSkinDataName(Value: String); override;
    // scroll
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
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
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
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
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TspNumGlyphs = 1..4;
  TspButtonLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);

  TspSkinButton = class(TspSkinCustomControl)
  protected
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
    FMargin: Integer;
    FSpacing: Integer;
    FLayout: TspButtonLayout;
    MorphTimer: TTimer;
    procedure RepeatTimerProc(Sender: TObject);
    procedure StartRepeat;
    procedure StopRepeat;
    procedure StartMorph;
    procedure StopMorph;
    procedure SetDefault(Value: Boolean);
    function IsFocused: Boolean;
    procedure SetCanFocused(Value: Boolean);
    procedure DoMorph(Sender: TObject);
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
    procedure ReDrawControl;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure ButtonClick; virtual;

    procedure CreateWnd; override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, DisabledFontColor: TColor;
    ActiveSkinRect, DownSkinRect, DisabledSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
    procedure Click; override; 
  published
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
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

  public
    TrackButtonRect: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
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
    procedure SetImageIndex(Value: Integer);
    procedure SetImages(Value: TCustomImageList);
    procedure StartMorph;
    procedure StopMorph;
    function IsFocused: Boolean;
    procedure SetCheckState;
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
    procedure ReDrawControl;
    procedure CalcSize(var W, H: Integer); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMMOVE(var Message: TWMSETFOCUS); message WM_MOVE;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FrameFontColor, UnEnabledFontColor: TColor;
    ActiveSkinRect, CheckImageArea, TextArea,
    CheckImageRect, UnCheckImageRect: TRect;
    ActiveCheckImageRect, ActiveUnCheckImageRect: TRect;
    UnEnabledCheckImageRect, UnEnabledUnCheckImageRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
  published
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
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
  end;
 
  TspSkinGauge = class(TspSkinCustomControl)
  protected
    FUseSkinSize: Boolean;
    FMinValue, FMaxValue, FValue: Integer;
    FVertical: Boolean;
    FProgressText: String;
    FShowPercent: Boolean;
    FShowProgressText: Boolean;
    FTextAlphaBlend: Boolean;
    FTextAlphaBlendValue: Byte;
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

  public
    ProgressRect, ProgressArea: TRect;
    NewProgressArea: TRect;
    BeginOffset, EndOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AOwner: TComponent); override;
    function CalcProgressRect(R: TRect; AV: Boolean): TRect;
    procedure Paint; override;
  published
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
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
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

  TspSkinLinkImage = class(TImage)
  private
    FURL: String;
  protected
    procedure Click; override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property URL: string read FURL write FURL;
  end;

  TspSkinLinkLabel = class(TCustomLabel)
  protected
    FMouseIn: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultActiveFontColor: TColor;
     FURL: String;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure SetDefaultFont(Value: TFont);
    property Transparent;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure GetSkinData;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor: TColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure Click; override;
  published
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultActiveFontColor: TColor
      read FDefaultActiveFontColor write FDefaultActiveFontColor;
    property URL: String read FURL write FURL;
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

  TspSkinTextLabel = class(TGraphicControl)
  private
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
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

  TspSkinStdLabel = class(TCustomLabel)
  protected
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
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
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
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


  TspSkinLabel = class(TspSkinCustomControl)
  protected
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FBorderStyle: TspSkinBorderStyle;
    procedure SetBorderStyle(Value: TspSkinBorderStyle);
    procedure DrawLabelText(Cnvs: TCanvas; R: TRect);
    function CalcWidthOffset: Integer; virtual;
    procedure AdjustBounds;
    procedure PaintLabel(B: TBitMap);
    procedure SetAutoSizeX(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CalcSize(var W, H: Integer); override;
    procedure GetSkinData; override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AOwner: TComponent); override;
  published
    property BorderStyle: TspSkinBorderStyle
      read FBorderStyle write SetBorderStyle;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property Align;
    property Caption;
    property DragCursor;
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

  TspSkinBitLabel = class(TspSkinCustomControl)
  protected
    FAutoSize: Boolean;
    FFixLength: Integer;
    function GetFixWidth: Integer;
    procedure SetFixLength(Value: Integer);
    procedure AdjustBounds;
    procedure GetSkinData; override;
    procedure PaintLabel(B: TBitMap);
    procedure CalcSize(var W, H: Integer); override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
  public
    SkinTextRect: TRect;
    SymbolWidth: Integer;
    SymbolHeight: Integer;
    Symbols: TStrings;
    procedure SetAutoSizeX(Value: Boolean);
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeX;
    property FixLength: Integer read FFixLength write SetFixLength;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
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

    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WndProc(var Message: TMessage); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

  public
    TrackArea, NewTrackArea, ButtonRect, ActiveButtonRect: TRect;
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
    GlyphRect, ActiveGlyphRect, DownGlyphRect: TRect;
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


  TspSkinControlBar = class(TCustomControlBar)
  protected
    FSkinBevel: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    procedure PaintNCSkin;
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
  public
    LTPt, RTPt, LBPt, RBPt: TPoint;
    SkinRect, ClRect, NewClRect, ItemRect: TRect;
    NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
    FSkinPicture: TBitMap;
    BGPictureIndex: Integer;
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

  TspSkinSplitter = class(TSplitter)
  protected
    FDefaultSize: Integer;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    procedure SetSkinData(Value: TspSkinData);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
      
  public
    LTPt, RTPt, LBPt: TPoint;
    SkinRect: TRect;
    FSkinPicture: TBitMap;
    procedure GetSkinData;
    procedure ChangeSkinData;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
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
    procedure FlipChildren(AllLevels: Boolean); override;
    property ButtonDefaultFont: TFont
      read FButtonDefaultFont write SetButtonDefaultFont;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write SetButtonSkinDataName;
    property Checked[Index: Integer]: Boolean read GetCheckedStatus write SetCheckedStatus;
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
    {$IFDEF VER130}
    property OnContextPopup;
    {$ENDIF}
    {$IFDEF VER140}
    property OnContextPopup;
    {$ENDIF}
    {$IFDEF VER150}
    property OnContextPopup;
    {$ENDIF}
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
    FInCheckScrollBars: Boolean;
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FDefaultFont: TFont;
    FDefaultColor: TColor;
    FUseSkinFont: Boolean;

    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;

    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure SetDefaultColor(Value: TColor);
    procedure SetDefaultFont(Value: TFont);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WndProc(var Message: TMessage); override;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change(Node: TTreeNode); override;
    procedure Loaded; override;
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
  end;

  TspSkinTreeView = class(TspSkinCustomTreeView)
  published
    property UseSkinFont;
    property Items;
    property HScrollBar;
    property VScrollBar;
    property DefaultFont;
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
  TspSkinCustomListView = class(TCustomListView)
  protected
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
    FOnDrawHeaderSection: TspDrawHeaderSectionEvent;
    //
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
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpDateScrollBars;
    procedure ChangeSkinData;
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property HeaderSkinDataName: String
      read FHeaderSkinDataName write FHeaderSkinDataName;
    property OnDrawHeaderSection: TspDrawHeaderSectionEvent
      read FOnDrawHeaderSection write FOnDrawHeaderSection;
  end;

  TspSkinListView = class(TspSkinCustomListView)
  published
    property Action;
    property Align;
    property AllocBy;
    property Anchors;
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
    property DefaultFont;
    property SkinData;
    property SkinDataName;
    property DefaultColor;
    property UseSkinFont;
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
    FGlyph: TBitMap;
    FNumGlyphs: TspStatusPanelNumGlyphs;
    procedure SetNumGlyphs(Value: TspStatusPanelNumGlyphs);
    procedure SetGlyph(Value: TBitMap);
  protected
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    function CalcWidthOffset: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspStatusPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
  end;

  TspSkinRichEdit = class(TCustomRichEdit)
  protected
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

    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WndProc(var Message: TMessage); override;
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);

    procedure Loaded; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure OnVScrollBarUpButtonClick(Sender: TObject);
    procedure OnVScrollBarDownButtonClick(Sender: TObject);
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpDateScrollBars;
    procedure ChangeSkinData;
  published
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
    procedure SetAlphaBlend(AValue: Boolean); virtual;
    procedure SetAlphaBlendValue(AValue: Byte); virtual;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure GetSkinData; virtual;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
  end;

  TspSkinSpeedButton = class(TspGraphicSkinCustomControl)
  protected
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
    procedure SetShowCaption(const Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure RepeatTimerProc(Sender: TObject);
    procedure StartRepeat;
    procedure StopRepeat;
    procedure SetFlat(Value: Boolean);
    procedure StartMorph;
    procedure StopMorph;
    procedure DoMorph(Sender: TObject);
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
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure ReDrawControl;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

    procedure ButtonClick; virtual;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, DisabledFontColor: TColor;
    ActiveSkinRect, DownSkinRect, DisabledSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure Paint; override;
  published
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
    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

  TspSkinMenuSpeedButton = class(TspSkinSpeedButton)
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
    procedure CreateControlDefaultImage(B: TBitMap); override;

  public
    TrackButtonRect: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
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
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
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
  end;

{ TspSlider }

  TspSkinSlider = class(TspSkinCustomSlider)
  published
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
    FTag: Integer;
    FLayout: TspButtonLayout;
    FMargin: Integer;
    FSpacing: Integer;
    FHint: String;
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
    procedure SetText(const Value: string);
    procedure SetImageIndex(const Value: Integer);
    procedure ItemClick(const Value: TNotifyEvent);
    procedure SetLayout(Value: TspButtonLayout);
  protected
    function GetDisplayName: string; override;
    procedure Click;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Text: string read FText write SetText;
    property Hint: string read FHint write FHint;
    property ImageIndex:integer read FImageIndex write SetImageIndex;
    property Tag: Integer read FTag write FTag;
    property Layout: TspButtonLayout read FLayout write SetLayout;
    property Margin: Integer read FMargin write SetMargin;
    property Spacing: Integer read FSpacing write SetSpacing;
    property OnClick:TNotifyEvent read FonClick write ItemClick;
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
    FImageIndex: Integer;
    FTag: Integer;
    FHint: String;
    FMargin: Integer;
    FSpacing: Integer;
    procedure SetText(const Value: string);
    procedure SetItems(const Value: TspButtonBarItems);
    procedure SectionClick(const Value: TNotifyEvent);
    procedure SetImageIndex(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure SetSpacing(Value: Integer);
  protected
    function GetDisplayName: string; override;
    procedure Click;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property Text: string read FText write SetText;
    property Hint: string read FHint write FHint;
    property Tag: Integer read FTag write FTag;
    property Items: TspButtonBarItems read FItems write SetItems;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Margin: Integer read FMargin write SetMargin;
    property Spacing: Integer read FSpacing write SetSpacing;
    property OnClick:TNotifyEvent read FOnClick write SectionClick;
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
  public
    constructor CreateEx(AOwner: TComponent; AButtonsBar: TspSkinButtonsBar; AIndex: Integer);
    procedure ButtonClick; override;
  end;

  TspSectionItem = class(TspSkinSpeedButton)
  private
    FItemIndex: Integer;
    FButtonsBar: TspSkinButtonsBar;
    FSectionIndex: Integer;
  public
    constructor CreateEx(AOwner: TComponent; AButtonsBar: TspSkinButtonsBar; ASectionIndex, AIndex: Integer);
    procedure ButtonClick; override;
  end;

  TspSkinButtonsBar = class(TspSkinPanel)
  private
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
    FItemImages: TImagelist;
    FSectionImages: TImageList;
    FSectionButtons: TList;
    FSectionItems: TList;
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
    procedure SetItemImages(const Value: TImagelist);
    procedure SetSectionImages(const Value: TImageList);
    procedure CheckVisibleItems;
    procedure OnItemPanelResize(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure ClearSections;
    procedure ClearItems;
    procedure OpenSection(Index: Integer);
    procedure ArangeItems;
    procedure ShowUpButton;
    procedure ShowDownButton;
    procedure HideUpButton;
    procedure HideDownButton;
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
  public
    procedure ScrollUp;
    procedure ScrollDown;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent:TComponent; Operation:TOperation);override;
    procedure UpDateSectionButtons;
    procedure ChangeSkinData; override;
  published
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
    property ItemImages: TImagelist read FItemImages write SetItemImages;
    property SectionImages:TImageList read FSectionImages write SetSectionImages;
    property Sections: TspButtonBarSections read FSections write SetSections;
    property SectionIndex:integer read FSectionIndex write SetSectionIndex;
    property PopupMenu;
    property ShowHint;
    property Hint;
    property Visible;
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
    FImages: TImageList;
    FButtonSkinDataName: String;
    procedure SetImages(const Value: TImageList);
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
    property Images: TImageList read FImages write SetImages;
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

 TspSkinXFormButton = class(TspSkinButton)
 private
   FDefImage: TBitMap;
   FDefActiveImage: TBitMap;
   FDefDownImage: TBitMap;
   FDefMask: TBitMap;
   FDefActiveFontColor: TColor;
   FDefDownFontColor: TColor;
   procedure SetDefImage(Value: TBitMap);
   procedure SetDefActiveImage(Value: TBitMap);
   procedure SetDefDownImage(Value: TBitMap);
   procedure SetDefMask(Value: TBitMap);
 protected
    procedure SetControlRegion; override;
    procedure DrawDefaultButton(C: TCanvas);
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure Loaded; override;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure ChangeSkinData; override;
   procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
 published
   property DefImage: TBitMap read FDefImage write SetDefImage;
   property DefActiveImage: TBitMap read FDefActiveImage write SetDefActiveImage;
   property DefDownImage: TBitMap read FDefDownImage write SetDefDownImage;
   property DefMask: TBitMap read FDefMask write SetDefMask;
   property DefActiveFontColor: TColor
    read FDefActiveFontColor write FDefActiveFontColor;
   property DefDownFontColor: TColor
    read FDefDownFontColor write FDefDownFontColor;
 end;


 TspScrollType = (stHorizontal, stVertical);
 TspSkinScrollPanel = class(TspSkinControl)
 private
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
 protected
   procedure GetSkinData; override;
   procedure WMTimer(var Message: TWMTimer); message WM_Timer;
   procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
   procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
   procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
   procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
   procedure CreateControlDefaultImage(B: TBitMap); override;
   procedure CreateControlSkinImage(B: TBitMap); override;
   procedure WndProc(var Message: TMessage); override;
   procedure SetButtonsVisible(AVisible: Boolean);
   procedure ButtonClick(I: Integer);
   procedure ButtonDown(I: Integer);
   procedure ButtonUp(I: Integer);
   procedure GetHRange;
   procedure GetVRange;
   procedure GetScrollInfo;
   procedure VScrollControls(AOffset: Integer);
   procedure HScrollControls(AOffset: Integer);
   procedure AdjustClientRect(var Rect: TRect); override;
   procedure StartTimer;
   procedure StopTimer;
   procedure Loaded; override;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Paint; override;
   procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
   procedure UpDateSize;
   property Position: Integer read SPosition;
 published
   property HotScroll: Boolean read FHotScroll write FHotScroll;
   property AutoSize: Boolean read FAutoSize write FAutoSize;
   property Align;
   property ScrollType: TspScrollType read FScrollType write SetScrollType;
   property ScrollOffset: Integer read FScrollOffset write SetScrollOffset;
   property ScrollTimerInterval: Integer
     read FScrollTimerInterval write SetScrollTimerInterval;
 end;

 procedure NotebookHandlesNeeded(Notebook: TspSkinNotebook);

implementation

{$R *.res}

Uses spUtils, DynamicSkinForm, ActnList, SkinTabs, CommCtrl, ShellAPI;


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

procedure CalcLCoord(Layout: TspButtonLayout; R: TRect; gw, gh, tw, th: Integer;
  Spacing, Margin: Integer; var tx, ty, gx, gy: Integer);
var
  H, W, H1, W1: Integer;
begin
 H := R.Top + RectHeight(R) div 2;
 W := R.Left + RectWidth(R) div 2;
 if Margin = -1
 then
   begin
     W1 := (tw + gw + Spacing) div 2;
     H1 := (th + gh + Spacing) div 2;
     case Layout of
       blGlyphRight:
         begin
           tx := W - W1;
           ty := H - th div 2;
           gx := W + W1 - gw;
           gy := H - gh div 2;
         end;
      blGlyphLeft:
         begin
           gx := W - W1;
           gy := H - gh div 2;
           tx := W + W1 - tw;
           ty := H - th div 2;
         end;
      blGlyphTop:
         begin
           tx := W - tw div 2;
           ty := H + H1 - th;
           gx := W - gw div 2;
           gy := H - H1;
        end;
     blGlyphBottom:
        begin
          gx := W - gw div 2;
          gy := H + H1 - gh;
          tx := W - tw div 2;
          ty := H - H1;
       end;
     end;
   end
 else
   begin
     case Layout of
       blGlyphRight:
         begin
           gy := H - gh div 2;
           gx := R.Right - gw - Margin;
           tx := gx - Spacing - tw;
           ty := H - th div 2;
         end;
       blGlyphLeft:
         begin
           gy := H - gh div 2;
           gx := R.Left + Margin;
           tx := gx + gw + Spacing;
           ty := H - th div 2;
         end;
       blGlyphTop:
          begin
            gy := R.Top +  Margin;
            gx := W - gw div 2;
            ty := gy + gh + Spacing;
            tx := W - tw div 2;
          end;
      blGlyphBottom:
          begin
            gy := R.Bottom - gh - Margin;
            gx := W - gw div 2;
            ty := gy - Spacing - th;
            tx := W - tw div 2;
         end;
       end;
    end;
end;

procedure DrawImageAndText(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean);

var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    TR := NullRect;
    DrawText(Handle, PChar(Caption), Length(Caption), TR,
             DT_CALCRECT);
    tw := RectWidth(TR);
    th := RectHeight(TR);
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  TR := Rect(TX, TY, TX, TY);
  DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_CALCRECT);
  Inc(TR.Right, 2);
  DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_VCENTER or DT_CENTER);
  if gw <> 0 then IL.Draw(Cnvs, GX, GY, ImageIndex, AEnabled);
end;

procedure DrawGlyphAndText(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean);
var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if Glyph.Empty
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := Glyph.Width div NumGlyphs;
      gh := Glyph.Height;
    end;
  with Cnvs do
  begin
    TR := NullRect;
    DrawText(Handle, PChar(Caption), Length(Caption), TR,
             DT_CALCRECT);
    tw := RectWidth(TR);
    th := RectHeight(TR);
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  TR := Rect(TX, TY, TX, TY);
  DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_CALCRECT);
  Inc(TR.Right, 2);
  DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_VCENTER or DT_CENTER);
  if not Glyph.Empty then DrawGlyph(Cnvs, GX, GY, Glyph, NumGlyphs, GlyphNum);
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
end;

destructor TspSkinControl.Destroy;
begin
  inherited Destroy;
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

procedure TspSkinControl.WMEraseBkGnd;
begin
end;

procedure TspSkinControl.WMMOVE;
begin
  inherited;
  if FAlphaBlend then RePaint;
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
end;

constructor TspFrameSkinControl.Create(AOwner: TComponent);
begin
  inherited;
  FFrame := 1;
  FrameW := 0;
  FrameH := 0;
  Picture := nil;
  MaskPicture := nil;
  FDefaultImage := TBitMap.Create;
  FDefaultMask := TBitMap.Create;
  FDefaultFramesCount := 1;
end;

destructor TspFrameSkinControl.Destroy;
begin
  FDefaultImage.Free;
  FDefaultMask.Free;
  if FRgn <> 0
  then
    begin
      DeleteObject(FRgn);
      FRgn := 0;
    end;
  inherited;
end;

procedure TspFrameSkinControl.Loaded;
begin
  inherited;
  CalcDefaultFrameSize;
  if (FIndex = -1) and (FSD = nil)
  then
    SetControlRegion;
end;

procedure TspFrameSkinControl.CalcDefaultFrameSize;
begin
  if FDefaultImage.Empty then Exit;
  FramesCount := FDefaultFramesCount;
  FramesPlacement := FDefaultFramesPlacement;
  case FramesPlacement of
   fpHorizontal:
     begin
       FrameW := FDefaultImage.Width div FramesCount;
       FrameH := FDefaultImage.Height;
     end;
   fpVertical:
     begin
       FrameW := FDefaultImage.Width;
       FrameH := FDefaultImage.Height div FramesCount;
     end;
  end;
end;

procedure TspFrameSkinControl.SetDefaultMask;
begin
  FDefaultMask.Assign(Value);
  SetControlRegion;
  RePaint;
end;

procedure TspFrameSkinControl.SetDefaultImage;
begin
  FDefaultImage.Assign(Value);
  FFrame := 1;
  CalcDefaultFrameSize;
  SetBounds(Left, Top, FrameW, FrameH);
  RePaint;
end;

procedure TspFrameSkinControl.SetDefaultFramesCount;
begin
  if Value <= 0
  then
    FDefaultFramesCount := 1
  else
    FDefaultFramesCount := Value;
  CalcDefaultFrameSize;
  SetBounds(Left, Top, FrameW, FrameH);
  RePaint;
end;

procedure TspFrameSkinControl.SetDefaultFramesPlacement;
begin
  FDefaultFramesPlacement := Value;
  CalcDefaultFrameSize;
  SetBounds(Left, Top, FrameW, FrameH);
  RePaint;
end;

procedure TspFrameSkinControl.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinFrameControl
    then
      begin
        with TspDataSkinFrameControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.SkinRect := SkinRect;
          Self.CursorIndex := CursorIndex;
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
          Self.FramesCount := FramesCount;
          Self.FramesPlacement := FramesPlacement;
        end;
        if FramesCount < 2 then FramesCount := 2;
        case FramesPlacement of
          fpHorizontal:
             begin
               FrameW := RectWidth(SkinRect) div FramesCount;
               FrameH := RectHeight(SkinRect);
             end;
          fpVertical:
            begin
              FrameH := RectHeight(SkinRect) div FramesCount;
              FrameW := RectWidth(SkinRect);
            end;
        end;
      end;
end;

procedure TspFrameSkinControl.SetBounds;
var
  UpDate: Boolean;
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and
  ((FIndex <> -1) or (not FDefaultImage.Empty and (FIndex = -1)));

  if UpDate
  then
    begin
      AWidth := FrameW;
      AHeight := FrameH;
    end;  

  inherited;

  if UpDate
  then
    begin
      SetControlRegion;
      RePaint;
    end;
end;

procedure TspFrameSkinControl.ChangeSkinData;
var
  UpDate: Boolean;
begin
  GetSkinData;

  if (FIndex = -1) and (not FDefaultImage.Empty)
  then
    begin
      CalcDefaultFrameSize;
      SetControlRegion;
      SetBounds(Left, Top, FrameW, FrameH);
      RePaint;
      Exit;
    end;

  if (FIndex <> -1) and (FFrame > FramesCount)
  then FFrame := FramesCount;

  if FUseSkinCursor
  then
  if (CursorIndex <> -1) and (FIndex <> -1)
  then
    Cursor := FSD.StartCursorIndex + CursorIndex
  else
    Cursor := crDefault;

  if FIndex <> -1
  then
    begin
      UpDate := (Width <> FrameW) or (Height <> FrameH);
      SetBounds(Left, Top, FrameW, FrameH);
    end
  else
    UpDate := False;

  if not UpDate
  then
    begin
      SetControlRegion;
      RePaint;
    end;
end;

procedure TspFrameSkinControl.CreateControlDefaultImage;
var
  R: TRect;
begin
  if FDefaultImage.Empty
  then
    begin
      with B.Canvas do
      begin
        R := ClientRect;
        Brush.Color := clBtnFace;
        FillRect(R);
      end;
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
    end
  else
    begin
      CalcDefaultFrameSize;
      if B.Width <> FrameW then B.Width := FrameW;
      if B.Height <> FrameH then B.Height := FrameH;
      case FramesPlacement of
         fpHorizontal:
           R := Rect((FFrame - 1) * FrameW, 0,
                      FFrame * FrameW, FrameH);
         fpVertical:
           R := Rect(0, (FFrame - 1) * FrameH,
                     FrameW, FFrame * FrameH);
      end;
      B.Canvas.CopyRect(Rect(0, 0, FrameW, FrameH), FDefaultImage.Canvas, R);
    end;
end;

procedure TspFrameSkinControl.CreateControlSkinImage;
var
  R: TRect;
begin
  if B.Width <> FrameW then B.Width := FrameW;
  if B.Height <> FrameH then B.Height := FrameH;
  case FramesPlacement of
    fpHorizontal:
       R := Rect(SkinRect.Left + (FFrame - 1) * FrameW, SkinRect.Top,
                 SkinRect.Left + FFrame * FrameW, SkinRect.Top + FrameH);
   fpVertical:
       R := Rect(SkinRect.Left, SkinRect.Top + (FFrame - 1) * FrameH,
                 SkinRect.Left + FrameW, SkinRect.Top + FFrame * FrameH);
  end;
  B.Canvas.CopyRect(Rect(0, 0, FrameW, FrameH), Picture.Canvas, R);
end;

procedure TspFrameSkinControl.SetControlRegion;
var
  TempRgn: HRgn;
begin
  if (FIndex = -1) and not FDefaultMask.Empty
  then
    begin
      TempRgn := FRgn;
      CreateSkinSimplyRegion(FRgn, FDefaultMask);
      SetWindowRgn(Handle, FRgn, True);
      if TempRgn <> 0 then DeleteObject(TempRgn);
    end
  else  
  if ((MaskPicture = nil) or (FIndex = -1)) and (FRgn <> 0)
  then
    begin
      SetWindowRgn(Handle, 0, True);
      DeleteObject(FRgn);
      FRgn := 0;
    end
  else
    if (MaskPicture <> nil) and (FIndex <> -1)
    then
      begin
        TempRgn := FRgn;
        CreateSkinSimplyRegion(FRgn, MaskPicture);
        SetWindowRgn(Handle, FRgn, True);
        if TempRgn <> 0 then DeleteObject(TempRgn);
      end;
end;

procedure TspFrameSkinControl.SetFrame;
begin
  if (FIndex = -1) and FDefaultImage.Empty then Exit;
  if Value < 1 then Value := 1 else
  if Value > FramesCount then Value := FramesCount;
  if FFrame <> Value
  then
    begin
      FFrame := Value;
      RePaint;
    end;
end;

constructor TspSkinSwitch.Create;
begin
  inherited Create(AOwner);
  Width := 25;
  Height := 50;
  FMouseIn := False;
  FAnimateTimer := TTimer.Create(Self);
  FAnimateTimer.Interval := 50;
  FAnimateTimer.Enabled := False;
  FAnimateTimer.OnTimer := DoAnimate;
end;

destructor TspSkinSwitch.Destroy;
begin
  FAnimateTimer.Free;
  inherited;
end;

procedure TspSkinSwitch.DoAnimate;
begin
  if (FIndex = -1) and FDefaultImage.Empty then Exit;
  if State = swOff
  then
    begin
      if Frame > 0 then Frame := Frame - 1 else Stop;
    end
  else
    begin
      if Frame < FramesCount then Frame := Frame + 1 else Stop;
    end;
end;

procedure TspSkinSwitch.Start;
begin
  FAnimateTimer.Enabled := True;
end;

procedure TspSkinSwitch.Stop;
begin
  FAnimateTimer.Enabled := False;
end;

procedure TspSkinSwitch.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
end;

procedure TspSkinSwitch.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
end;


procedure TspSkinSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                X, Y: Integer);
begin
  if (Button = mbLeft) and FMouseIn
  then
    begin
      if State = swOff then State := swOn else State := swOff;
    end;
  inherited;
end;

procedure TspSkinSwitch.ChangeSkinData;
begin
  inherited;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    if FState = swOn
    then Frame := FramesCount
    else Frame := 1;
end;

procedure TspSkinSwitch.ChangeState;
begin
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    begin
      if FramesCount = 2
      then
        begin
          if FState = swOn
          then Frame := 2
          else Frame := 1;
        end
      else
        Start;  
    end
  else
    RePaint;
end;

procedure TspSkinSwitch.SetState;
begin
  FState := Value;
  ChangeState(Value);
  if not (csDesigning in ComponentState)
  then
    if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinSwitch.SetTimerInterval;
begin
  FAnimateTimer.Interval := Value;
end;

function TspSkinSwitch.GetTimerInterval;
begin
  Result := FAnimateTimer.Interval;
end;

constructor TspSkinAnimate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAnimateTimer := TTimer.Create(Self);
  FAnimateTimer.Interval := 50;
  FAnimateTimer.Enabled := False;
  FAnimateTimer.OnTimer := DoAnimate;
  Width := 50;
  Height := 50;
end;

destructor TspSkinAnimate.Destroy;
begin
  FAnimateTimer.Enabled := False;
  FAnimateTimer.Free;
  inherited;
end;

procedure TspSkinAnimate.SetActive;
begin
  FActive := Value;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    if FActive then Start else Stop;
end;

procedure TspSkinAnimate.SetTimerInterval;
begin
  FAnimateTimer.Interval := Value;
end;

function TspSkinAnimate.GetTimerInterval;
begin
  Result := FAnimateTimer.Interval;
end;

procedure TspSkinAnimate.DoAnimate;
begin
  if (FIndex = -1) and FDefaultImage.Empty then Exit;

  if FButtonMode and not FMouseIn
  then
    begin
      if Frame > 0 then Frame := Frame - 1 else Stop;
    end
  else
    begin
      if Frame = FramesCount
      then
        begin
          if FCycleMode then Frame := 0
        end
      else
        begin
          if Frame < FramesCount then Frame := Frame + 1 else Stop;
        end;
    end;
end;


procedure TspSkinAnimate.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if (FIndex = -1) and FDefaultImage.Empty then Exit;
  FMouseIn := True;
  if FButtonMode then Start;
end;

procedure TspSkinAnimate.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if (FIndex = -1) and FDefaultImage.Empty then Exit;
  FMouseIn := False;
  if FButtonMode then Start;
end;

procedure TspSkinAnimate.Start;
begin
  if not FCycleMode and not FButtonMode then FFrame := 1;
  FAnimateTimer.Enabled := True;
  if Assigned(FOnStart) then FOnStart(Self);
end;

procedure TspSkinAnimate.Stop;
begin
  FAnimateTimer.Enabled := False;
  if Assigned(FOnStop) then FOnStop(Self);
end;

constructor TspSkinFrameGauge.Create;
begin
  inherited;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
  Width := 50;
  Height := 50;
end;

procedure TspSkinFrameGauge.ChangeSkinData;
begin
  inherited;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then CalcFrame;
end;

procedure TspSkinFrameGauge.CalcFrame;
var
  FValInc: Integer;
begin
  FValInc := (FMaxValue - FMinValue) div (FramesCount - 1);
  Frame := Abs(FValue - FMinValue) div FValInc + 1;
end;

procedure TspSkinFrameGauge.SetMinValue;
begin
  FMinValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    begin
      if FValue < FMinValue then FValue := FMinValue;
      CalcFrame;
    end;
end;

procedure TspSkinFrameGauge.SetMaxValue;
begin
  FMaxValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    begin
      if FValue > FMaxValue then FValue := FMaxValue;
      CalcFrame;
    end;
end;

procedure TspSkinFrameGauge.SetValue;
begin
  if (FValue = AValue) or (AValue > FMaxValue) or
     (AValue < FMinValue) then Exit;
  FValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty) then CalcFrame;
end;

constructor TspSkinFrameRegulator.Create;
begin
  inherited;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
  Width := 50;
  Height := 50;
  FDown := False;
  FFrame := 1;
  Kind := rkRound;
end;

procedure TspSkinFrameRegulator.SetDefaultKind;
begin
  FDefaultKind := Value;
  Kind := FDefaultKind;
end;

procedure TspSkinFrameRegulator.CalcDefaultFrameSize;
begin
  inherited;
  Kind := FDefaultKind;
end;

procedure TspSkinFrameRegulator.ChangeSkinData;
begin
  inherited;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty) then CalcFrame;
end;

procedure TspSkinFrameRegulator.CalcValue;
var
  Offset: Integer;
  Plus: Boolean;
  FW: Integer;
  FC: Integer;
begin
  if (FIndex = -1) and not FDefaultImage.Empty then CalcDefaultFrameSize;

  FW := 0;

  case Kind of
    rkRound: if FrameW > FrameH then FW := FrameH else FW := FrameW;
    rkVertical: FW := FrameH;
    rkHorizontal: FW := FrameW;
  end;

  if FramesCount - 1 > 0 then FC := FramesCount - 1 else FC := 1;

  FPixInc := FW div FC;
  FValInc := (FMaxValue - FMinValue) div FC;

  if FPixInc = 0 then FPixInc := 1;
  if FValInc = 0 then FValInc := 1;

  Plus := CurV >= StartV;

  if Plus
  then Offset := CurV - StartV
  else Offset := StartV - CurV;

  if Offset >= FPixInc
  then
    begin
      StartV := CurV;
      if Plus
      then TempValue := TempValue + FValInc
      else TempValue := TempValue - FValInc;

      if TempValue < FMinValue then TempValue := FMinValue;
      if TempValue > FMaxValue then TempValue := FMaxValue;

      Value := TempValue;
    end;
end;

procedure TspSkinFrameRegulator.CalcFrame;
var
  FC: Integer;
begin
  if (FIndex = -1) and not FDefaultImage.Empty then CalcDefaultFrameSize;
  if FramesCount - 1 > 0 then FC := FramesCount - 1 else FC := 1;
  FValInc := (FMaxValue - FMinValue) div FC;
  Frame := Abs(FValue - FMinValue) div FValInc + 1;
end;

procedure TspSkinFrameRegulator.SetMinValue;
begin
  FMinValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    begin
      if FValue < FMinValue then FValue := FMinValue;
      CalcFrame;
    end;
end;

procedure TspSkinFrameRegulator.SetMaxValue;
begin
  FMaxValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty)
  then
    begin
      if FValue > FMaxValue then FValue := FMaxValue;
      CalcFrame;
    end;
end;

procedure TspSkinFrameRegulator.SetValue;
begin
  if (FValue = AValue) or (AValue > FMaxValue) or
     (AValue < FMinValue) then Exit;
  FValue := AValue;
  if (FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty) then CalcFrame;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinFrameRegulator.GetSkinData; 
begin
  inherited;
  if (FIndex <> -1) 
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinFrameRegulator
    then
      with TspDataSkinFrameRegulator(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.Kind := Kind;
      end;
end;

procedure TspSkinFrameRegulator.MouseDown;
begin
  FDown := True;
  TempValue := FValue;
  case Kind of
    rkRound: StartV := X - Y;
    rkVertical: StartV := -Y;
    rkHorizontal: StartV := X;
  end;
  inherited;
end;

procedure TspSkinFrameRegulator.MouseUp;
begin
  FDown := False;
  inherited;
end;

procedure TspSkinFrameRegulator.MouseMove;
begin
  if FDown and ((FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty))
  then
    begin
      case Kind of
        rkRound: CurV := X - Y;
        rkVertical: CurV := -Y;
        rkHorizontal: CurV := X;
      end;
      CalcValue;
    end;
  inherited;
end;

constructor TspSkinCustomControl.Create;
begin
  inherited Create(AOwner);
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
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
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and (FIndex <> -1);
  if UpDate
  then
    begin
      CalcSize(AWidth, AHeight);
      if ResizeMode = 0 then NewClRect := ClRect;
    end;
  inherited;
  if UpDate
  then
    begin
      SetControlRegion;
      RePaint;
    end;
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
    1: CreateSkinImage(LTPt, RTPt, LBPt, RBPt, CLRect,
         NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
         B, SB, R, Width, Height, True);
    2: CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, SB, R, Width, Height);
    3: CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          B, SB, R, Width, Height);
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
begin
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
  RepeatTimer := nil;
  FRepeatMode := False;
  FRepeatInterval := 100;
  FActive := False;
  FSkinDataName := 'button';
  FCanFocused := True;
  TabStop := True;
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
end;

procedure TspSkinButton.Click;
begin
  if ActionLink = nil then inherited;
end;

destructor TspSkinButton.Destroy;
begin
  FGlyph.Free;
  StopMorph;
  inherited;
end;

procedure TspSkinButton.RepeatTimerProc;
begin
  ButtonClick;
end;

procedure TspSkinButton.StartRepeat;
begin
  if RepeatTimer <> nil then RepeatTimer.Free;
  RepeatTimer := TTimer.Create(Self);
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := RepeatTimerProc;
  RepeatTimer.Interval := FRepeatInterval;
  RepeatTimer.Enabled := True;
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
  if Morphing
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
        if Morphing then FMorphKf := 1;
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

procedure TspSkinButton.ChangeSkinData;
begin
  StopMorph;
  inherited;
  if Morphing and (FIndex <> -1) and (IsFocused or FMouseIn)
  then
    FMorphKf := 1;
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
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    TabStop := FCanFocused;
end;

procedure TspSkinButton.WMSETFOCUS;
begin
  inherited;
  if FCanFocused then ReDrawControl;
end;

procedure TspSkinButton.WMKILLFOCUS;
begin
  if FRepeatMode and (RepeatTimer <> nil) then StopRepeat;
  if (GroupIndex = 0) and FDown then FDown := False;
  inherited;
  if FCanFocused then ReDrawControl;
end;

procedure TspSkinButton.WndProc(var Message: TMessage);
begin
  if FCanFocused then
  case Message.Msg of
    WM_KEYDOWN:
      if TWMKEYDOWN(Message).CharCode = VK_SPACE
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
      if TWMKEYUP(Message).CharCode = VK_SPACE
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

  procedure CopyImage(ImageList: TCustomImageList; Index: Integer);
  begin
    with FGlyph do
    begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia;
      Canvas.FillRect(Rect(0, 0, Width, Height));
      ImageList.Draw(Canvas, 0, 0, Index);
    end;
  end;

begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if (FGlyph.Empty) and (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
      begin
        CopyImage(ActionList.Images, ImageIndex);
        RePaint;
      end;
    end;
end;

procedure TspSkinButton.ReDrawControl;
begin
  if Morphing and (FIndex <> -1)
  then StartMorph
  else RePaint;
end;

procedure TspSkinButton.DoMorph;
begin
  if (FIndex = -1) or not Morphing
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
  if Morphing
  then
     begin
       FMorphKf := 1;
       if not FDown then StartMorph else StopMorph; 
     end;
  RePaint;
  if (GroupIndex <> 0) and FDown and not FAllowAllUp then DoAllUp;
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
          (GroupIndex <> 0) and FDown
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
          Self.DisabledFontColor := DisabledFontColor;
        end;
   end
 else
   begin
     Morphing := False;
   end;
end;

procedure TspSkinButton.CreateButtonImage(B: TBitMap; R: TRect;
  ADown, AMouseIn: Boolean);

function GetGlyphNum: Integer;
begin
  if ADown and AMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if AMouseIn and (FNumGlyphs > 3)
  then
    Result := 4
  else
    if not Enabled and (FNumGlyphs > 1)
    then
      Result := 2
    else
      Result := 1;
end;

begin
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
  DrawGlyphAndText(B.Canvas,
    NewClRect, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum,  ADown and AMouseIn);
end;

procedure TspSkinButton.CreateControlDefaultImage;
var
  R: TRect;
  IsDown: Boolean;
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
  DrawGlyphAndText(B.Canvas,
    ClientRect, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, 1, IsDown);
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

      if Morphing and (FMorphKf <> 1) and (FMorphKf <> 0) and Enabled
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
            if (IsFocused or FMouseIn) or (not (IsFocused or FMouseIn) and
                Morphing and (FMorphKf = 1))
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
          if Morphing then FMorphKf := 1; 
          RePaint;
        end  
      else
        ReDrawControl;
    end;
  if FDown and FRepeatMode and (GroupIndex = 0) then StartRepeat;
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
  then ReDrawControl;

  if FDown and FRepeatMode and (RepeatTimer <> nil) and (GroupIndex = 0) then StopRepeat;
end;

procedure TspSkinButton.MouseDown;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      FMouseDown := True;
      if not FDown
      then
        begin
          FMouseIn := True;
          Down := True;
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
begin
  if Button = mbLeft
  then
    begin
      FMouseDown := False;
      if GroupIndex = 0
      then
        begin
          if FMouseIn
          then
            begin
              Down := False;
              if FRepeatMode and (RepeatTimer <> nil) then StopRepeat;
              ButtonClick;
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
end;

destructor TspSkinMenuButton.Destroy;
begin
  inherited;
end;

procedure TspSkinMenuButton.CreateButtonImage;
begin
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
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  Caption, FGlyph, FNumGlyphs, 1,  isDown);
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
  if FCanFocused then
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
  if FSkinPopupMenu = nil
  then
    begin
      Result := False;
      Exit;
    end
  else
    begin
      if not FTrackButtonMode
      then
        Result := True
      else
        begin
          if FIndex <> -1
          then R := GetNewTrackButtonRect
          else R := Rect(Width - 15, 0, Width, Height);
          Result := PointInRect(R, Point(X, Y));
        end;
    end
end;

procedure TspSkinMenuButton.WMCLOSESKINMENU;
begin
  FMenuTracked := False;
  Down := False;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
end;

procedure TspSkinMenuButton.TrackMenu;
var
  R: TRect;
  P: TPoint;
begin
  if FSkinPopupMenu = nil then Exit;
  if Morphing then FMorphKf := 1;
  P := ClientToScreen(Point(0, 0));
  R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
  FSkinPopupMenu.PopupFromRect2(Self, R, False);
  if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self); 
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
end;

destructor TspSkinPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
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
  if VisibleControls = nil then Exit;
  for i := 0 to VisibleControls.Count - 1 do
    TControl(VisibleControls.Items[i]).Visible := True;
  VisibleControls.Clear;
  VisibleControls.Free;
  VisibleControls := nil;
end;

procedure TspSkinPanel.HideControls;
var
  i: Integer;
begin
  if VisibleControls <> nil then VisibleControls.Free;
  VisibleControls := TList.Create;
  VisibleControls.Clear;
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i].Visible
    then
      begin
        VisibleControls.Add(Controls[i]);
        Controls[i].Visible := False;
      end;
  end;
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
  if (FIndex = -1) and FCaptionMode
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
          R := Rect(0, 0, Width, FDefaultCaptionHeight);
          Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
          Frame3D(B.Canvas, R, clBtnHighLight, clBtnFace, 1);
        end
      else
        begin
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
 if FIndex <> -1
  then
    begin
      if ARollUp and (FRealHeight = -1)
      then
        begin
          FRealHeight := Height;
          if VisibleControls = nil then HideControls;
          Height := NewClRect.Top + (Height - NewClRect.Bottom);
        end
      else
        if not ARollUp and (FRealHeight <> -1)
        then
          begin
            Height := FRealHeight;
            FRealHeight := -1;
            if VisibleControls <> nil then ShowControls;
          end;
    end
  else
    begin
      if ARollUp and (FRealHeight = -1)
      then
        begin
          FRealHeight := Height;
          if VisibleControls = nil then HideControls;
          Height := FDEfaultCaptionHeight + 1;
        end
      else
        if not ARollUp and (FRealHeight <> -1)
        then
          begin
            Height := FRealHeight;
            FRealHeight := -1;
            if VisibleControls <> nil then ShowControls;
          end;
    end;
end;

procedure TspSkinPanel.SetRollUpState;
begin
  if FRollUpState = Value then Exit; 
  if FRollUpMode
  then
    begin
      FRollUpState := Value;
      DoRollUp(FRollUpState);
    end
  else
    FRollUpState := False;
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
      end;
end;

procedure TspSkinPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if (FIndex <> -1) and not (csDesigning in ComponentState)
  then
    begin
      if BGPictureIndex = -1 then Rect := NewClRect;
    end
  else
    begin
      if FBorderStyle <> bvNone then InflateRect(Rect, -1, -1);
      if FCaptionMode then Rect.Top := Rect.Top + FDefaultCaptionHeight;
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
  CR, CapRect, R: TRect;
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
    TX := CapRect.Left;
    case Alignment of
      taCenter: TX := TX +
        RectWidth(CapRect) div 2 - GetGlyphTextWidth div 2;
      taRightJustify: TX := CapRect.Right - GetGlyphTextWidth;
    end;

    Brush.Style := bsClear;

    if not FGlyph.Empty
    then
      begin
        GY := CapRect.Top + RectHeight(CapRect) div 2 - FGlyph.Height div 2;
        GX := TX;
        TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
        GlyphNum := 1;
        if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
       end;


     if FRollUpMode
     then
       begin
         R := CapRect;
         R.Left := R.Right;
         R.Right := R.Right + 10;
         if FRollUpState
         then DrawArrowImage(B.Canvas, R, FontColor, 4)
         else DrawArrowImage(B.Canvas, R, FontColor, 3);
       end;

    TextRect(CapRect, TX, TY, Caption);
    if not FGlyph.Empty
    then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
  end;
end;

var
  X, Y, XCnt, YCnt, XO, YO, w, h, w1, h1: Integer;
begin
  if (BorderStyle = bvNone) and (ResizeMode = 1) and not CaptionMode
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
      if ResizeMode > 0
      then NewCaptionRect := GetNewRect(CaptionRect)
      else NewCaptionRect := CaptionRect;
      if (Caption <> '') and not IsNullRect(CaptionRect)
      then DrawCaption;
    end;
end;

procedure TspSkinPanel.Paint;
var
  RealPicture: TBitMap;
  X, Y, XCnt, YCnt: Integer;
begin
  GetSkinData;
  if FIndex =-1
  then
    inherited
  else
  if BGPictureIndex <> -1
  then
    begin
      RealPicture := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
      if (Width > 0) and (Height > 0)
      then
        begin
          XCnt := Width div RealPicture.Width;
          YCnt := Height div RealPicture.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
          Canvas.Draw(X * RealPicture.Width, Y * RealPicture.Height, RealPicture);
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

constructor TspSkinGroupBox.Create;
begin
  inherited;
  FSkinDataName := 'groupbox';
  CaptionMode := True;
end;

constructor TspSkinStatusBar.Create;
begin
  inherited;
  FSkinDataName := 'statusbar';
  Align := alBottom;
  DefaultHeight := 21;
  BorderStyle := bvNone;
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
  FCanFocused := False;
  TabStop := False;
  FMouseIn := False;
  Width := 150;
  Height := 25;
  FGroupIndex := 0;
  FMorphKf := 0;
  MorphTimer := nil;
  FSkinDataName := 'checkbox';
  FFlat := False;
end;

destructor TspSkinCheckRadioBox.Destroy;
begin
  StopMorph;
  inherited;
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
  TR, IR: TRect;
  IX, IY: Integer;
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
      GetParentImage2(Self, Buffer.Canvas);
      if FIndex = -1
      then
        with Buffer.Canvas do
        begin
          IR := Rect(3, Height div 2 - 7, 17, Height div 2 + 7);
          // draw caption
          TR := Rect(0, 0, 0, 0);
          Font := DefaultFont;
          if (SkinData <> nil) and (SkinData.ResourceStrData <>  nil)
          then
            Font.Charset := SkinData.ResourceStrData.CharSet;

          Brush.Style := bsClear;
          DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
             DT_CALCRECT);
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
          SPDrawText(Buffer.Canvas, Caption, TR);
          // draw glyph
          if FMouseIn
          then
            Frame3D(Buffer.Canvas, IR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1)
          else
            Frame3D(Buffer.Canvas, IR, clbtnShadow, clbtnShadow, 1);
          Pen.Color := clBlack;
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
              DrawFocusRect(TR)
            else
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                DrawFocusRect(Rect(ImX - 1, ImY - 1,
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
              if FChecked
              then
                SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveCheckImageRect, Buffer.Canvas)
              else
                SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveUnCheckImageRect, Buffer.Canvas);
            end
          else
            begin
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
              
          if not Enabled
          then Font.Color := UnEnabledFontColor
          else Font.Color := FrameFontColor;
          TR := Rect(0, 0, 0, 0);
          DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
             DT_CALCRECT);
          OffsetRect(TR, IX + RectWidth(CheckIMageRect) + 4, Height div 2 - RectHeight(TR) div 2);
          if TR.Right > Width - 2 then TR.Right := Width - 2;
          //
          if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
          then
            begin
              ImX := TR.Left;
              ImY := Height div 2 - FImages.Height div 2;
              FIMages.Draw(Buffer.Canvas, ImX, ImY, FImageIndex, Enabled);
              OffsetRect(TR, FImages.Width + 5, 0);
            end;
          //
          Brush.Style := bsClear;
          if not Enabled
          then Font.Color := UnEnabledFontColor
          else Font.Color := FrameFontColor;
          SPDrawText(Buffer.Canvas, Caption, TR);
          // drawfocus
          InflateRect(TR, 2, 1);
          Inc(TR.Right, 1 );
          Brush.Style := bsSolid;
          if IsFocused
          then
            if Caption <> ''
            then
              DrawFocusRect(TR)
            else
              if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count)
              then
                DrawFocusRect(Rect(ImX - 1, ImY - 1,
                  ImX + FImages.Width + 1, ImY + FImages.Height + 1));
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
      if Morphing and (FMorphKf <> 1) and (FMorphKf <> 0)
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
  if FCanFocused then ReDrawControl;
end;

procedure TspSkinCheckRadioBox.WMKILLFOCUS;
begin
  inherited;
  if FCanFocused then ReDrawControl;
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
  RePaint;
  if FChecked and (GroupIndex <> 0) then UnCheckAll;
  if (FRadio and FChecked) or not FRadio
  then
    if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TspSkinCheckRadioBox.ReDrawControl;
begin
  if Morphing and (FIndex <> -1)
  then StartMorph
  else RePaint;
end;

procedure TspSkinCheckRadioBox.DoMorph;
begin
  if (FIndex = -1) or not Morphing
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
      if Morphing and (FIndex <> -1) and (IsFocused or FMouseIn)
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
begin
  CreateSkinControlImage(B, Picture, R);
  with B.Canvas do
  begin
    IX := CIRect.Left;
    IY := CIRect.Top + RectHeight(CIRect) div 2 - RectHeight(CheckImageRect) div 2;
    if not Enabled
    then
      begin
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
        if FChecked
        then
          SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveCheckImageRect, B.Canvas)
        else
          SkinDrawCheckImage(IX, IY, Picture.Canvas, ActiveUnCheckImageRect, B.Canvas);
      end
    else
      begin
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
  end;
  if FMouseIn
  then
    Frame3D(B.Canvas, IR, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1)
  else
    Frame3D(B.Canvas, IR, clbtnShadow, clbtnShadow, 1);
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

procedure TspSkinCheckRadioBox.MouseDown;
begin
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
  if (Button = mbLeft) and FMouseIn then SetCheckState;
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
    Percent := Round((FValue - FMinValue) / (FMaxValue - FMinValue) * 100);
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
      Offset := Round(RectHeight(R) * kf);
      R.Top := R.Bottom - Offset;
      Result := R;
    end
  else
    begin
      Offset := Round(RectWidth(R) * kf);
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
begin
  inherited;
  with B.Canvas do
  begin
    PR := CalcProgressRect(NewProgressArea, FVertical);
    if FVertical
    then
      begin
        if RectHeight(PR) - BeginOffset - EndOffset > 0
        then
          begin
            PR1 := PR;
            Inc(PR1.Top, BeginOffset);
            Dec(PR1.Bottom, EndOffset);
            PR2 := ProgressRect;
            Inc(PR2.Top, BeginOffset);
            Dec(PR2.Bottom, EndOffset);
            w1 := RectHeight(PR1);
            w2 := RectHeight(PR2);
            if w2 = 0 then Exit;
            Cnt := w1 div w2;
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

        if RectHeight(PR) >= BeginOffset + EndOffset
        then
          begin
            CopyRect(Rect(PR.Left, PR.Top,
                     PR.Right, PR.Top + BeginOffset),
                   Picture.Canvas,
                   Rect(ProgressRect.Left, ProgressRect.Top,
                   ProgressRect.Right, ProgressRect.Top + BeginOffset));

            CopyRect(Rect(PR.Left, PR.Bottom - EndOffset,
                     PR.Right, PR.Bottom),
                   Picture.Canvas,
                   Rect(ProgressRect.Left, ProgressRect.Bottom - EndOffset,
                   ProgressRect.Right, ProgressRect.Bottom));
          end;
      end
    else
      begin
        if RectWidth(PR) - BeginOffset - EndOffset > 0
        then
          begin
            PR1 := PR;
            Inc(PR1.Left, BeginOffset);
            Dec(PR1.Right, EndOffset);
            PR2 := ProgressRect;
            Inc(PR2.Left, BeginOffset);
            Dec(PR2.Right, EndOffset);
            w1 := RectWidth(PR1);
            w2 := RectWidth(PR2);
            if w2 = 0 then Exit;
            Cnt := w1 div w2;
            for i := 0 to Cnt do
            begin
              if i * w2 + w2 > w1 then Off := i * w2 + w2 - w1 else Off := 0;
                CopyRect(Rect(PR1.Left + i * w2, PR1.Top,
                         PR1.Left + i * w2 + w2 - Off, PR1.Bottom),
                     Picture.Canvas,
                     Rect(PR2.Left, PR2.Top, PR2.Right - Off, PR2.Bottom));
            end;
          end;

        if RectWidth(PR) >= BeginOffset + EndOffset
        then
          begin
            CopyRect(Rect(PR.Left, PR.Top,
                     PR.Left + BeginOffset, PR.Bottom),
                   Picture.Canvas,
                   Rect(ProgressRect.Left, ProgressRect.Top,
                   ProgressRect.Left + BeginOffset, ProgressRect.Bottom));

            CopyRect(Rect(PR.Right - EndOffset, PR.Top,
                     PR.Right, PR.Bottom),
                   Picture.Canvas,
                   Rect(ProgressRect.Right - EndOffset, ProgressRect.Top,
                   ProgressRect.Right, ProgressRect.Bottom));
          end;
      end;
  end;

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
      RePaint;
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
    VK_UP, VK_RIGHT: Value := Value + 1;
    VK_DOWN, VK_LEFT: Value := Value - 1;
  end;
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
      end
    else
      begin
        if Message.WParam > 0
        then
          Value := Value - 1
        else
          Value := Value + 1;
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
begin
  inherited;
  BR := CalcButtonRect(NewTrackArea, FVertical);
  if FAlphaBlend
  then
    begin
      //
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
      //
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
      B1.Free;
      B2.Free;
    end
  else
    with B.Canvas do
    begin
      if FDown or IsFocused
      then
        CopyRect(BR, Picture.Canvas, ActiveButtonRect)
      else
        CopyRect(BR, Picture.Canvas, ButtonRect);
    end;
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
        Self.FVertical := Vertical;
        Self.ButtonRect := ButtonRect;
        if IsNullRect(ActiveButtonRect)
        then
          Self.ActiveButtonRect := ButtonRect
        else
          Self.ActiveButtonRect := ActiveButtonRect;
        Self.TrackArea := TrackArea;
      end;
end;


constructor TspSkinStdLabel.Create;
begin
  inherited;
  Transparent := True;
  FSD := nil;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  FUseSkinFont := True;
end;

destructor TspSkinStdLabel.Destroy;
begin
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinStdLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  GetSkinData;

  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
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
      Color := FontColor;
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
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
   begin
      Canvas.Font := Self.Font;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;
      DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    end;
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
  RePaint;
end;

procedure TspSkinStdLabel.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then ChangeSkinData;
end;

constructor TspSkinBitLabel.Create;
begin
  inherited;
  Symbols := nil;
  Width := 100;
  Height := 20;
  FSkinDataName := 'bitlabel';
end;

function TspSkinBitLabel.GetFixWidth;
var
  LO, RO: Integer;
begin
  LO := ClRect.Left;
  RO := RectWidth(SkinRect) - ClRect.Right;
  Result := SymbolWidth * FFixLength + LO + RO;
end;

procedure TspSkinBitLabel.SetFixLength;
begin
  FFixLength := Value;
  if FFixLength > 0
  then
    begin
      FAutoSize := False;
      if FIndex <> -1
      then
        Width := GetFixWidth;
    end;
end;

procedure TspSkinBitLabel.CMTextChanged(var Message: TMessage);
begin
  if FAutoSize then AdjustBounds;
  RePaint;
end;

procedure TspSkinBitLabel.AdjustBounds;
var
  Offset: Integer;
begin
  if Align <> alNone then Exit;
  if FIndex = -1
  then Offset := 0
  else Offset := Length(Caption) * SymbolWidth - RectWidth(NewClRect);
  if Offset <> 0 then Width := Width + Offset;
end;

procedure TspSkinBitLabel.CalcSize;
var
  Offset: Integer;
begin
  inherited;
  if FFixLength > 0
  then
    begin
      if FIndex <> -1
      then
        W := GetFixWidth;
    end
  else
    begin
      if FIndex = -1
      then Offset := 0
      else Offset := Length(Caption) * SymbolWidth - RectWidth(NewClRect);
      if (Offset > 0) or FAutoSize then W := W + Offset;
    end;  
end;

procedure TspSkinBitLabel.CreateControlDefaultImage;
begin
  inherited;
  with B.Canvas do
  begin
    Brush.Style := bsClear;
    TextRect(Rect(1, 1, Width - 1, Height - 1), 2,
             Height div 2 - TextHeight(Caption) div 2,
             Caption);
  end;
end;

procedure TspSkinBitLabel.PaintLabel;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinBitLabel.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinBitLabelControl
    then
      begin
        with TspDataSkinBitLabelControl(FSD.CtrlList.Items[FIndex]) do
        begin
          Self.SkinTextRect := SkinTextRect;
          Self.SymbolWidth := SymbolWidth;
          Self.SymbolHeight := SymbolHeight;
          Self.Symbols := Symbols;
        end;
      end;
end;

procedure TspSkinBitLabel.CreateControlSkinImage;
var
  SymbolX, SymbolY: Integer;
  i: Integer;
  XO: Integer;
  LO, RO: Integer;

procedure GetSymbolPos(Ch: Char);
var
  i, j: Integer;
begin
  SymbolX := -1;
  SymbolY := -1;
  for i := 0 to Symbols.Count - 1 do
  begin
    j := Pos(Ch, Symbols[i]);
    if j <> 0
    then
      begin
        SymbolX := j - 1;
        SymbolY := i;
        Exit;
      end;
  end;
end;

begin
  inherited;
  LO := ClRect.Left;
  RO := RectWidth(SkinRect) - ClRect.Right;
  with B.Canvas do
  begin
    for i := 1 to Length(Caption) do
    begin
      if (i * SymbolWidth) > B.Width
      then XO := i * SymbolWidth - B.Width - LO - RO
      else XO := 0;
      GetSymbolPos(Caption[i]);
      if SymbolX <> -1
      then
        begin
          CopyRect(
            Rect(LO + (i - 1) * SymbolWidth, NewClRect.Top, LO + i * SymbolWidth - XO, NewClRect.Top + SymbolHeight),
            Picture.Canvas,
            Rect(SkinTextRect.Left + SymbolX * SymbolWidth,
                 SkinTextRect.Top + SymbolY * SymbolHeight,
                 SkinTextRect.Left + (SymbolX + 1) * SymbolWidth - XO,
                 SkinTextRect.Top + (SymbolY + 1) * SymbolHeight));
          if XO > 0 then Break;
        end;
    end;
  end;
end;

procedure TspSkinBitLabel.SetAutoSizeX;
begin
  FAutoSize := Value;
  AdjustBounds;
  RePaint;
end;

constructor TspSkinLabel.Create;
begin
  inherited;
  Width := 75;
  Height := 21;
  FAutoSize := False;
  FSkinDataName := 'label';
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
var
  TX, TY: Integer;
begin
  with Cnvs do
  begin
    if FIndex <> -1
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
        Font.Color := FontColor;
      end
    else
      Font.Assign(DefaultFont);


    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := FDefaultFont.Charset;

    TY := R.Top + RectHeight(R) div 2 - TextHeight(Caption) div 2;
    TX := R.Left;
    case FAlignment of
      taRightJustify: TX := R.Right - TextWidth(Caption);
      taCenter: TX := R.Left + RectWidth(R) div 2 - TextWidth(Caption) div 2;
    end;
    Brush.Style := bsClear;
    TextRect(R, TX, TY, Caption);
  end;
end;

procedure TspSkinLabel.CreateControlDefaultImage;
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  case FBorderStyle of
    bvLowered:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnHighLight, 1);
    bvRaised:
      Frame3D(B.Canvas, R, clBtnHighLight, clBtnShadow, 1);
    bvFrame:
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  end;
  DrawLabelText(B.Canvas, Rect(2, 2, Width - 2, Height - 2));
end;

procedure TspSkinLabel.CreateControlSkinImage;
begin
  inherited;
  DrawLabelText(B.Canvas, NewClRect);
end;

procedure TspSkinLabel.PaintLabel;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinLabel.CalcSize;
var
  Offset: Integer;
begin
  inherited;
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
        Self.GlyphRect := GlyphRect;
        Self.ActiveGlyphRect := ActiveGlyphRect;
        if isNullRect(ActiveGlyphRect)
        then Self.ActiveGlyphRect := GlyphRect;
        Self.DownGlyphRect := DownGlyphRect;
        if isNullRect(DownGlyphRect)
        then Self.DownGlyphRect := Self.ActiveGlyphRect;
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
  ThumbB: TBitMap;
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
            ThumbB.Canvas.CopyRect(Rect(0, 0, ThumbB.Width, ThumbB.Height), Picture.Canvas, R1)
          else
            case Kind of
              sbHorizontal:
                CreateHSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                  ThumbB.Width, ThumbB.Height);
              sbVertical:
                CreateVSkinImage(ThumbOffset1, ThumbOffset2, ThumbB, Picture, R1,
                  ThumbB.Width, ThumbB.Height);
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
              ThumbB.Canvas.CopyRect(R2, Picture.Canvas, R1)
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
                  kf := 1;
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
                 if XMax - XMin = 0
                 then
                   kf := 0
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
end;

destructor  TspSkinSplitter.Destroy;
begin
  inherited;
end;

procedure TspSkinSplitter.Paint;
var
  Buffer: TBitMap;
begin
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
          Buffer, FSkinPicture, SkinRect, Width, RectHeight(SkinRect))
      else
        CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          Buffer, FSkinPicture, SkinRect, RectWidth(SkinRect), Height);
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
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          FSkinPicture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          FSkinPicture := nil;
      end;
end;

procedure TspSkinSplitter.ChangeSkinData;
begin
  GetSkinData;
  if (Align = alTop) or (Align = alBottom)
  then
    begin
      if FIndex = -1
      then
        MinSize := FDefaultSize
      else
        MinSize := RectHeight(SkinRect);
      Height := MinSize;
    end
  else
    begin
      if FIndex = -1
      then
        MinSize := FDefaultSize
      else
        MinSize := RectWidth(SkinRect);
     Width := MinSize;
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
  FSkinDataName := 'controlbar';  
end;

destructor TspSkinControlBar.Destroy;
begin
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
  if (FIndex <> -1) and FSkinBevel then PaintNCSkin;
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
  DC := GetWindowDC(Handle);
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
      False, False, False, False);

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
  ReleaseDC(Handle, DC);
  Cnvs.Free;
end;

procedure TspSkinControlBar.Paint;
var
  X, Y, XCnt, YCnt, w, h,
  rw, rh, XO, YO: Integer;
  Buffer: TBitMap;
  i: Integer;
  R: TRect;
  B: TBitMap;
begin
  GetSkinData;
  if FIndex = -1
  then
    begin
      inherited;
      Exit
    end;
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
        Point(12, 3), Point(IW - 3, 3),
        Point(12, IH - 3), Point(IW - 3, IH - 3),
        Rect(11, 2, IW - 2, IH - 2),
        Point(12, 3), Point(W - 3, 3),
        Point(12, H - 3), Point(W - 3, H - 3),
        Rect(11, 2, W - 2, H - 2),
        LeftB, TopB, RightB, BottomB,
        FSkinPicture, ItemRect,  W, H,
        False, False, False, False);
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
      end;
end;

procedure TspSkinControlBar.ChangeSkinData;
var
  R: TRect;
begin
  GetSkinData;
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
      if FSkinBevel then PaintNCSkin;
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
    Name := 'Arial';
    Style := [];
    Height := 14;
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
  UseSkinFont := True;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FSD := nil;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FDefaultColor := clWindow;
  FSkinDataName := 'treeview';
  FInCheckScrollBars := False;
end;

destructor TspSkinCustomTreeView.Destroy;
begin
  FDefaultFont.Free;
  inherited;
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
end;

procedure TspSkinCustomTreeView.Change;
begin
  inherited;
  UpDateScrollBars;
end;

procedure TspSkinCustomTreeView.WMNCCALCSIZE;
begin
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
    WM_SIZE:
      if not FInCheckScrollBars then UpDateScrollBars;
    WM_PAINT, WM_KEYDOWN, WM_LBUTTONUP:
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
begin
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
  FUseSkinFont := True;
  FHeaderSkinDataName := 'resizebutton';
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
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  Font.Assign(FDefaultFont);
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
            B1, HPicture, SR, B1.Width, B1.Height);
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
            B, HPicture, SR, B.Width, B.Height, True);
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
            taRightJustify: TX := BR.Right - TextWidth(S) - 10;
           taCenter: TX := RectWidth(BR) div 2 - TextWidth(S) div 2;
         end;
       end;
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
    BGR := Rect(RightOffset, 0, RectWidth(HR) + 1, RectHeight(R));
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
              B1, HPicture, HSkinRect, B1.Width, B1.Height);
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
              B, HPicture, HSkinRect, B.Width, B.Height, True);
          end;    
        Cnvs.Draw(BGR.Left, BGR.Top, B);
        B.Free;
      end;
    Cnvs.Handle := 0;
    Cnvs.Free;
  finally
    if DC = 0
    then EndPaint(FHeaderHandle, PS)
    else ReleaseDC(FHeaderHandle, DC);
  end;
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
        //
        RedrawWindow(FHeaderHandle, 0, 0, RDW_INVALIDATE);
      end;
    WM_LBUTTONUP:
      begin
        FHeaderDown := False;
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
     WM_SIZE, WM_PAINT:
      if not FInCheckScrollBars then UpDateScrollBars;
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
  Width := 120;
end;

destructor TspSkinStatusPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

function TspSkinStatusPanel.CalcWidthOffset;
  var
  X: Integer;
begin
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
end;

procedure TspSkinStatusPanel.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinStatusPanel.CreateControlDefaultImage;
var
  R: TRect;
  GW: Integer;
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
  FVScrollBar := nil;
  FHScrollBar := nil;
  FOldVScrollBarPos := 0;
  FOldHScrollBarPos := 0;
  FSD := nil;
  FIndex := -1;
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  Font.Assign(FDefaultFont);
  FDefaultColor := clWindow;
  FSkinDataName := 'richedit';
  ScrollBars := ssBoth;
end;

destructor TspSkinRichEdit.Destroy;
begin
  FDefaultFont.Free;
  inherited;
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
begin
  if FVScrollBar <> nil
  then
    begin
      GetScrollRange(Handle, SB_VERT, Min, Max);
      Pos := GetScrollPos(Handle, SB_VERT);
      Page := Height;
      if (Max > Min) and (Page < Max) and (Lines.Count > 0)
      then
        begin
          if not FVScrollBar.Enabled
          then
            FVScrollBar.Enabled := True;
          FVScrollBar.SetRange(Min, Max, Pos, Page);
          FVScrollBar.RePaint;
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
      GetScrollRange(Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(Handle, SB_HORZ);
      Page := Width;
      if (Max > Min) and (Page < Max) and (Lines.Count > 0)
      then
        begin
          if not FHScrollBar.Enabled
          then
            FHScrollBar.Enabled := True;
          FHScrollBar.SetRange(Min, Max, Pos, Page);
          FHScrollBar.RePaint;
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
end;

destructor TspGraphicSkinControl.Destroy;
begin
  inherited Destroy;
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
      GetParentImage2(Self, ParentImage.Canvas);
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
end;


constructor TspGraphicSkinCustomControl.Create;
begin
  inherited Create(AOwner);
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FUseSkinFont := True;
end;

destructor TspGraphicSkinCustomControl.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
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
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and (FIndex <> -1);
  if UpDate
  then
    begin
      CalcSize(AWidth, AHeight);
      if ResizeMode = 0 then NewClRect := ClRect;
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
         B, SB, R, Width, Height, True);
    2: CreateHSkinImage(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, SB, R, Width, Height);
    3: CreateVSkinImage(LTPt.Y, RectHeight(SkinRect) - LBPt.Y,
          B, SB, R, Width, Height);
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
constructor Tresimkutusu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
 ControlStyle := ControlStyle + [csReplicatable];
 
  FDefaultWidth := 0;
  FDefaultHeight := 0;
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FUseSkinFont := True;
end;


destructor Tresimkutusu.Destroy;
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

constructor TspSkinSpeedButton.Create;
begin
  inherited;
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
end;

destructor TspSkinSpeedButton.Destroy;
begin
  FGlyph.Free;
  StopMorph;
  inherited;
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
  if Parent is TspSkinToolBar then RePaint;
end;

procedure TspSkinSpeedButton.RepeatTimerProc;
begin
  ButtonClick;
end;

procedure TspSkinSpeedButton.StartRepeat;
begin
  if RepeatTimer <> nil then RepeatTimer.Free;
  RepeatTimer := TTimer.Create(Self);
  RepeatTimer.Enabled := False;
  RepeatTimer.OnTimer := RepeatTimerProc;
  RepeatTimer.Interval := FRepeatInterval;
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
  if Morphing
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
  if Assigned(OnClick) then OnClick(Self);
end;

procedure TspSkinSpeedButton.ChangeSkinData;
begin
  StopMorph;
  inherited;
  if Morphing and (FIndex <> -1) and FMouseIn
  then
    FMorphKf := 1;
end;

procedure TspSkinSpeedButton.SetGroupIndex;
begin
  FGroupIndex := Value;
end;

procedure TspSkinSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);

  procedure CopyImage(ImageList: TCustomImageList; Index: Integer);
  begin
    with FGlyph do
    begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia;
      Canvas.FillRect(Rect(0, 0, Width, Height));
      ImageList.Draw(Canvas, 0, 0, Index);
    end;
  end;

begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if (FGlyph.Empty) and (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
      begin
        CopyImage(ActionList.Images, ImageIndex);
        RePaint;
      end;
    end;
end;

procedure TspSkinSpeedButton.ReDrawControl;
begin
  if Morphing and (FIndex <> -1)
  then StartMorph
  else RePaint;
end;

procedure TspSkinSpeedButton.DoMorph;
begin
  if (FIndex = -1) or not Morphing
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
  if Morphing
  then
     begin
       FMorphKf := 1;
       if not FDown then StartMorph else StopMorph; 
     end;
  RePaint;
  if (GroupIndex <> 0) and FDown and not FAllowAllUp then DoAllUp;
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
          (GroupIndex <> 0) and FDown
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
        end;
   end
 else
   begin
     Morphing := False;
   end;
end;

procedure TspSkinSpeedButton.CreateButtonImage(B: TBitMap; R: TRect;
  ADown, AMouseIn: Boolean);

function GetGlyphNum: Integer;
begin
  if ADown and AMouseIn and (FNumGlyphs > 2)
  then
    Result := 3
  else
  if AMouseIn and (FNumGlyphs > 3)
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
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
begin
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
        _Caption, FImageIndex, IL, ADown and AMouseIn, E);
    end
  else
  DrawGlyphAndText(B.Canvas,
    NewClRect, FMargin, FSpacing, FLayout,
    _Caption, FGlyph, FNumGlyphs, GetGlyphNum,  ADown and AMouseIn);
end;

procedure TspSkinSpeedButton.CreateControlDefaultImage;

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
  R: TRect;
  IsDown: Boolean;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
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
        _Caption, FImageIndex, IL, FDown and FMouseIn, E);
    end
  else
  DrawGlyphAndText(B.Canvas,
    ClientRect, FMargin, FSpacing, FLayout,
    _Caption, FGlyph, FNumGlyphs, GetGlyphNum, IsDown);
end;

procedure TspSkinSpeedButton.CreateControlSkinImage;
begin
end;

procedure TspSkinSpeedButton.Paint;

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
  PBuffer, APBuffer, PIBuffer: TspEffectBmp;
  ParentImage, Buffer, ABuffer: TBitMap;
  kf: Double;
  IL: TCustomImageList;
  E: Boolean;
  _Caption: String;
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
                   E := False;
                  DrawImageAndText(Canvas, ClientRect, FMargin, FSpacing, FLayout,
                    _Caption, FImageIndex, IL, False, E);
              end
            else
            DrawGlyphAndText(Canvas,
              ClientRect, FMargin, FSpacing, FLayout,
              _Caption, FGlyph, FNumGlyphs, GetGlyphNum, False);
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
          Name := FontName;
          Style := FontStyle;
          if Self.Enabled
          then
            Color := FontColor
          else
            Color := DisabledFontColor;
           if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
           then
             Charset := SkinData.ResourceStrData.CharSet
           else
            CharSet := FDefaultFont.Charset;
          Height := FontHeight;
        end;
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
               _Caption, FImageIndex, IL, False, E);
           end
        else
         DrawGlyphAndText(Canvas,
          NewClRect, FMargin, FSpacing, FLayout,
          _Caption, FGlyph, FNumGlyphs, GetGlyphNum, False);
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
          GetParentImage2(Self, ParentImage.Canvas);
          PIBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
          kf := 1 - FAlphaBlendValue / 255;
        end;

      if Morphing and (FMorphKf <> 1) and (FMorphKf <> 0) and Enabled
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
            if FMouseIn or (not FMouseIn and Morphing and (FMorphKf = 1))
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
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  CanPaint := ((GroupIndex <> 0) and not FDown) or (GroupIndex = 0);
  if CanPaint
  then
    begin
      if FDown
      then
        begin
          if Morphing then FMorphKf := 1; 
          RePaint;
        end  
      else
        ReDrawControl;
    end;
  if FDown and RepeatMode and (GroupIndex = 0) then StartRepeat;  
end;


procedure TspSkinSpeedButton.CMMouseLeave(var Message: TMessage);
var
  CanPaint: Boolean;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
  CanPaint := ((GroupIndex <> 0) and not FDown) or (GroupIndex = 0);
  if CanPaint
  then ReDrawControl;
  if FDown and RepeatMode and (RepeatTimer <> nil) and (GroupIndex = 0) then StopRepeat;
end;

procedure TspSkinSpeedButton.MouseDown;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      FMouseDown := True;
      if not FDown
      then
        begin
          FMouseIn := True;
          Down := True;
          //
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
begin
  if Button = mbLeft
  then
    begin
      FMouseDown := False;
      if GroupIndex = 0
      then
        begin
          if FMouseIn
          then
            begin
              Down := False;
              if RepeatMode then StopRepeat;
              ButtonClick;
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
  FSkinDataName := 'menubutton';
  FTrackButtonMode := False;
  FMenuTracked := False;
  FSkinPopupMenu := nil;
end;

destructor TspSkinMenuSpeedButton.Destroy;
begin
  inherited;
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
  if not FMouseIn and not FDown and not FMenuTracked and FFlat
  then
    begin
      if FIndex = -1
      then
        begin
          R := ClientRect;
          Dec(R.Right, 15);
        end
      else
        R := NewClRect;
      Canvas.Font.Assign(FDefaultFont);
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Canvas.Font.CharSet := FDefaultFont.Charset;

      if not Enabled then Canvas.Font.Color := clBtnShadow;
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
            E := False;
          DrawImageAndText(Canvas, R, FMargin, FSpacing, FLayout,
           _Caption, FImageIndex, IL, False, E);
        end
      else
      DrawGlyphAndText(Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, 1, False);

      if FIndex <> -1
      then
        begin
          R.Left := R.Right;
          R.Right := Width;
        end
      else
        begin
          R.Left := Width - 15;
          R.Right := Width;
        end;

      if (FDown and FMouseIn) or FMenuTracked
      then
        begin
          Inc(R.Top, 2);
          Inc(R.Left, 2);
        end;
      DrawTrackArrowImage(Canvas, R, clBtnText);
    end
  else
    inherited;
end;

procedure TspSkinMenuSpeedButton.CreateButtonImage;
begin
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
        _Caption, FImageIndex, IL, isDown, E);
    end
  else
  DrawGlyphAndText(B.Canvas, R, FMargin, FSpacing, FLayout,
                  _Caption, FGlyph, FNumGlyphs, 1,  isDown);
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
  if FSkinPopupMenu = nil
  then
    begin
      Result := False;
      Exit;
    end
  else
    begin
      if not FTrackButtonMode
      then
        Result := True
      else
        begin
          if FIndex <> -1
          then R := GetNewTrackButtonRect
          else R := Rect(Width - 15, 0, Width, Height);
          Result := PointInRect(R, Point(X, Y));
        end;
    end
end;

procedure TspSkinMenuSpeedButton.WMCLOSESKINMENU;
begin
  FMenuTracked := False;
  Down := False;
  if Assigned(FOnHideTrackMenu) then FOnHideTrackMenu(Self);
end;

procedure TspSkinMenuSpeedButton.TrackMenu;
var
  R: TRect;
  P: TPoint;
begin
  if FSkinPopupMenu = nil then Exit;
  if Morphing then FMorphKf := 1;
  P := ClientToScreen(Point(0, 0));
  R := Rect(P.X, P.Y, P.X + Width, P.Y + Height);
  FSkinPopupMenu.PopupFromRect2(Self, R, False);
  if Assigned(FOnShowTrackMenu) then FOnShowTrackMenu(Self); 
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
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  FUseSkinFont := True;
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
  if FAutoSize then AdjustBounds;
  RePaint;
end;

function TspSkinTextLabel.GetLabelText: string;
begin
  Result := FLines.Text;
end;

procedure TspSkinTextLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  GetSkinData;

  Text := GetLabelText;
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
      Color := FontColor;
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
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
   begin
      Canvas.Font := Self.Font;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;
      DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
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

procedure TspSkinTextLabel.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  X: Integer;
  Rect: TRect;
  AAlignment: TAlignment;
begin
  if not (csReading in ComponentState) and FAutoSize then
  begin
    Rect := ClientRect;
    DC := GetDC(0);
    Canvas.Handle := DC;
    DoDrawText(Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    X := Left;
    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
    if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
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
  FNumGlyphs := 1;
  FGlyph := TBitMap.Create;
  FSpacing := 2;
  FDefaultCaptionHeight := 21;
  Width := 150;
  Height := 100;
  VisibleControls := nil;
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
end;

destructor TspSkinExPanel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TspSkinExPanel.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
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
  if FIndex = -1
  then
    Result := FDefaultCaptionHeight
  else
    Result := RectWidth(RollHSkinRect);
end;

function TspSkinExPanel.GetRollHeight: Integer;
begin
  if FIndex = -1
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
  if FIndex = -1
  then
    begin
      RePaint;
      ReAlign;
    end
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
      if not FGlyph.Empty
      then
        begin
          GX := CR.Left + RectWidth(CR) div 2 - FGlyph.Width div 2;
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
      if not FGlyph.Empty
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width + FSpacing);
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
        B, Picture, RollHSkinRect, GetRollWidth, Height);
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
      if not FGlyph.Empty
       then
         begin
           GX := CR.Left + RectWidth(CR) div 2 - FGlyph.Width div 2;
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
          B, Picture, RollVSkinRect, Width, GetRollHeight);
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
        if not FGlyph.Empty
        then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width + FSpacing);
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
       if not FGlyph.Empty
       then
         begin
           GX := CR.Left;
           GY := CR.Top + RectHeight(CR) div 2 - FGlyph.Height div 2;
           GlyphNum := 1;
           if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
           DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
           Inc(CR.Left, FGlyph.Width + FSpacing);
         end;
       SPDrawText2(B.Canvas, Caption, CR);
     end;

  if FShowCloseButton then DrawButton(B.Canvas, 0);
  if FShowRollButton then DrawButton(B.Canvas, 1);
end;

procedure TspSkinExPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if (FIndex <> -1) and not (csDesigning in ComponentState)
  then
    Rect := NewClRect
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
  if VisibleControls = nil then Exit;
  for i := 0 to VisibleControls.Count - 1 do
    TControl(VisibleControls.Items[i]).Visible := True;
  VisibleControls.Clear;
  VisibleControls.Free;
  VisibleControls := nil;
end;

procedure TspSkinExPanel.HideControls;
var
  i: Integer;
begin
  if VisibleControls <> nil then VisibleControls.Free;
  VisibleControls := TList.Create;
  VisibleControls.Clear;
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i].Visible
    then
      begin
        VisibleControls.Add(Controls[i]);
        Controls[i].Visible := False;
      end;
  end;
end;

procedure TspSkinExPanel.SetRollState;
begin
  if FRollState = Value then Exit;
  FRollState := Value;
  StopCheckSize := True;
  if FRollState
  then
    begin
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
        Cnvs.CopyRect(R, Picture.Canvas, DR)
      else
      if MouseIn
      then
        Cnvs.CopyRect(R, Picture.Canvas, AR)
      else
        Cnvs.CopyRect(R, Picture.Canvas, SR);
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
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FSkinDataName := 'resizebutton';
  FUseSkinFont := True;
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
          B, Picture, SR, B.Width, B.Height);
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
            B, Picture, SR, B.Width, B.Height, True);
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
            B, Picture, SkinRect, B.Width, B.Height);
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
              B, Picture, SkinRect, B.Width, B.Height, True);
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
  inherited;
end;

procedure TspSkinHeaderControl.MouseUp;
var
  FTempTracking: Boolean;
begin
  inherited;
  FTempTracking := FInTracking;
  FInTracking := False;
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
  TabStop := True;
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
      GetParentImage2(Self, Buffer.Canvas);
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
    Canvas.DrawFocusRect(R);
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
    DrawThumb(Canvas, P, HighlightThumb)
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
         TmpBmp.Width, TmpBmp.Height);
      end
    else
      begin
        TmpBmp.Height := R.Bottom - R.Top - 2 * Indent;
        TmpBmp.Width := RectWidth(HRulerRect);
        CreateVSkinImage(SkinEdgeSize, SkinEdgeSize, TmpBmp, Picture, VRulerRect,
          TmpBmp.Width, TmpBmp.Height);
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
      HThumbHeight := FImages[siHThumb].Height;
      HThumbWidth := FImages[siHThumb].Width;
      VThumbHeight := FImages[siVThumb].Height;
      VThumbWidth := FImages[siVThumb].Width;
      NumStates := NumThumbStates;
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
    VThumbHeight := FImages[siVThumb].Height
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
    VThumbHeight := FImages[siVThumb].Height
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

constructor TspSkinLinkImage.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  AutoSize := True;
  Cursor := crHandPoint;
end;

procedure TspSkinLinkImage.Click;
begin
  inherited Click;
  ShellExecute(0, 'open', PChar(FURL), nil, nil, SW_SHOWNORMAL);
end;

constructor TspSkinLinkLabel.Create;
begin
  inherited;
  FIndex := -1;
  Transparent := True;
  FSD := nil;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Height := 14;
    Style := [fsUnderLine];
  end;
  Font.Assign(FDefaultFont);
  Cursor := crHandPoint;
  FUseSkinFont := True;
  FDefaultActiveFontColor := clBlue;
  FURL := '';
end;

destructor TspSkinLinkLabel.Destroy;
begin
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinLinkLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  GetSkinData;

  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
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
          Style := Style + [fsUnderLine];
        end
      else
        Canvas.Font := Self.Font;

      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Charset := SkinData.ResourceStrData.CharSet
      else
        CharSet := FDefaultFont.Charset;

      if FMouseIn
      then
        Color := ActiveFontColor
      else
        Color := FontColor;
    end
  else
    begin
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

  
      if FMouseIn then Canvas.Font.Color := FDefaultActiveFontColor;
      Canvas.Font.Style := Canvas.Font.Style + [fsUnderLine];
    end;

  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TspSkinLinkLabel.Click;
begin
  inherited;
  ShellExecute(0, 'open', PChar(FURL), nil, nil, SW_SHOWNORMAL);
end;

procedure TspSkinLinkLabel.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  RePaint;
end;

procedure TspSkinLinkLabel.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := False;
  RePaint;
end;

procedure TspSkinLinkLabel.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinLinkLabel.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinLinkLabel.GetSkinData;
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
        Self.ActiveFontColor := ActiveFontColor;
      end
end;

procedure TspSkinLinkLabel.ChangeSkinData;
begin
  GetSkinData;
  RePaint;
end;

procedure TspSkinLinkLabel.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then ChangeSkinData;
end;

constructor TspSkinButtonLabel.Create;
begin
  inherited;
  FIndex := -1;
  ControlStyle := ControlStyle + [csSetCaption] - [csOpaque];
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FUseSkinFont := True;
  FDefaultActiveFontColor := clBlue;
  FNumGlyphs := 1;
  FMargin := -1;
  FSpacing := 1;
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

procedure TspSkinButtonLabel.MouseDown;
begin
  FDown := True;
  RePaint;
  inherited;
end;

procedure TspSkinButtonLabel.MouseUp;
begin
  FDown := False;
  RePaint;
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
  if (csDesigning in ComponentState) then Exit;
  FMouseIn := True;
  RePaint;
end;

procedure TspSkinButtonLabel.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
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


begin
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
      if FMouseIn
      then
        Color := ActiveFontColor
      else
        Color := FontColor;
    end
  else
    begin
      Canvas.Font := FDefaultFont;
      if FMouseIn
      then
        Canvas.Font.Color := FDefaultActiveFontColor;
    end;

  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Canvas.Font.CharSet := FDefaultFont.Charset;
    
  DrawGlyphAndText(Canvas,
    ClientRect, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum, FDown);
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
    Name := 'Arial';
    Style := [];
    Height := 14;
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
    Margin := TspButtonBarSection(source).Margin;
    Spacing := TspButtonBarSection(source).Spacing;
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

procedure TspButtonBarSection.Click;
begin
  if assigned(onClick) then
    onclick(self);
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

  FShowButtons := True;
  FShowItemHint := True;

  FDefaultSectionFont := TFont.Create;
  with FDefaultSectionFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;

  FDefaultItemFont := TFont.Create;
  with FDefaultItemFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
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
begin
  inherited;
  CheckVisibleItems;
end;

procedure TspSkinButtonsBar.ShowUpButton;
begin
  FUpButton := TspSkinButton.Create(Self);
  with FUpButton do
  begin
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
    Parent := FItemsPanel;
  end;
end;

procedure TspSkinButtonsBar.ShowDownButton;
begin
  FDownButton := TspSkinButton.Create(Self);
  with FDownButton do
  begin
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
    Parent := FItemsPanel;
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

  FSectionIndex := Index;

  if FShowButtons
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
    end;

  UpdateItems;

  Sections[Index].Click;
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
    if B then Caption := S.Text;
    Glyph.Assign(nil);
    if (S.ImageIndex <> -1) and (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
    then
      FSectionImages.GetBitmap(S.ImageIndex, Glyph);
    RePaint;
    if (FSectionIndex = Index) and not B then UpdateItems;
    Break;
  end;
end;

procedure TspSkinButtonsBar.UpdateSections;
var
  I: Integer;
  S: TspButtonBarSection;
begin
  if not HandleAllocated then Exit;
  if FSections.Count = 0 then Exit;
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
      if (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
      then
        begin
          FSectionImages.GetBitmap(S.ImageIndex, Glyph);
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
      if (FSectionImages <> nil) and (S.ImageIndex < FSectionImages.Count)
      then
        begin
          FSectionImages.GetBitmap(S.ImageIndex, Glyph);
        end;
    end;
  end;
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
  if FUpButton <> nil then HideUpButton;
  if FDownButton <> nil then HideDownButton;
  if FSections.Items[FSectionIndex].Items.Count = 0 then Exit;
  TopIndex := 0;
  for I := 0 to FSections.Items[FSectionIndex].Items.Count - 1 do
  begin
    It := TspButtonBarItem(FSections.Items[FSectionIndex].Items[I]);
    FSectionItems.Add(TspSectionItem.CreateEx(FItemsPanel, Self, FSectionIndex, I));
    with TspSectionItem(FSectionItems.Items[FSectionItems.Count - 1]) do
    begin
      DefaultHeight := FItemHeight;
      Flat := FItemsTransparent;
      SkinData := Self.SkinData;
      Caption := It.Text;
      Hint := It.Hint;
      ShowHint := Self.ShowItemHint;
      if (FItemImages <> nil) and (It.ImageIndex < FitemImages.Count)
      then
        begin
          FItemImages.GetBitmap(It.ImageIndex, Glyph);
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
  if (Value >= 0) and (Value <> FSectionIndex) and (Value < Sections.Count)
  then
    begin
      OpenSection(Value);
    end;
end;

procedure TspSkinButtonsBar.SetItemImages(const Value: TImagelist);
begin
  FItemImages := Value;
  UpdateItems;
end;

procedure TspSkinButtonsBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (operation=opremove) and (Acomponent = FItemImages) then
    SetItemImages(nil);
  if (operation=opremove) and (Acomponent=FSectionImages) then
    SetSectionImages(nil);
end;


procedure TspSkinButtonsBar.SetSectionImages(const Value: TImageList);
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
    Tag :=TspButtonBarItem(source).Tag;
    Layout :=TspButtonBarItem(source).Layout;
    Margin := TspButtonBarItem(source).Margin;
    Spacing := TspButtonBarItem(source).Spacing;
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

constructor TspButtonBarItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTag := 0;
  FLayout := blGlyphTop;
  FMargin := -1;
  FSpacing := 1;
  FHint := '';
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

procedure TspSectionButton.ButtonClick;
begin
  FButtonsBar.OpenSection(FItemIndex);
  inherited;
end;

constructor TspSectionItem.CreateEx;
begin
  inherited Create(AOwner);
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

procedure TspSkinNoteBook.SetImages(const Value: TImageList);
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
      Glyph.Assign(nil);
      if P.ImageIndex <> -1
      then
        FImages.GetBitmap(P.ImageIndex, Glyph);
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
      Glyph.Assign(nil);
      if (P.ImageIndex <> -1) and (FImages <> nil) and (P.ImageIndex < FImages.Count)
      then
        FImages.GetBitmap(P.ImageIndex, Glyph);
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


constructor TspSkinXFormButton.Create(AOwner: TComponent);
begin
  inherited;
  FDefImage := TBitMap.Create;
  FDefActiveImage := TBitMap.Create;
  FDefDownImage := TBitMap.Create;
  FDefMask := TBitMap.Create;
  CanFocused := False;
  FDefActiveFontColor := 0;
  FDefDownFontColor := 0;
end;

destructor TspSkinXFormButton.Destroy;
begin
  FDefImage.Free;
  FDefActiveImage.Free;
  FDefDownImage.Free;
  FDefMask.Free;
  inherited;
end;

procedure TspSkinXFormButton.SetControlRegion;
var
  TempRgn: HRGN;
begin
  if (FIndex = -1) and (FDefImage <> nil) and not FDefImage.Empty
  then
    begin
      TempRgn := FRgn;
      
      if FDefMask.Empty and (FRgn <> 0)
      then
        begin
          SetWindowRgn(Handle, 0, True);
        end
      else
        begin
          CreateSkinSimplyRegion(FRgn, FDefMask);
          SetWindowRgn(Handle, FRgn, True);
        end;
        
      if TempRgn <> 0 then DeleteObject(TempRgn);
    end
  else
    inherited;
end;

procedure TspSkinXFormButton.SetBounds;
begin
  inherited;
  if (FIndex = -1) and (FDefImage <> nil) and not FDefImage.Empty
  then
    begin
      if Width <> FDefImage.Width then Width := FDefImage.Width;
      if Height <> FDefImage.Height then Height := FDefImage.Height;
    end;
end;

procedure TspSkinXFormButton.DrawDefaultButton;
var
  IsDown: Boolean;
  R: TRect;
begin
  with C do
  begin
    R := ClientRect;
    Font.Assign(FDefaultFont);
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.Charset := FDefaultFont.CharSet;
    IsDown := FDown and (((FMouseIn or (IsFocused and not FMouseDown)) and
             (GroupIndex = 0)) or (GroupIndex  <> 0));
    if IsDown and not FDefDownImage.Empty
    then
      Draw(0, 0, FDefDownImage)
    else
    if (FMouseIn or IsFocused) and not FDefActiveImage.Empty
    then
      Draw(0, 0, FDefActiveImage)
    else
      Draw(0, 0, FDefImage);
    if IsDown
    then
      Font.Color := FDefDownFontColor
    else
    if FMouseIn or IsFocused
    then
      Font.Color := FDefActiveFontColor;
    DrawGlyphAndText(C, ClientRect, FMargin, FSpacing, FLayout,
     Caption, FGlyph, FNumGlyphs, 1, IsDown);
  end;
end;

procedure TspSkinXFormButton.CreateControlDefaultImage;
begin
  if (FIndex = -1) and not FDefImage.Empty
  then
    DrawDefaultButton(B.Canvas)
  else
    inherited;
end;

procedure TspSkinXFormButton.ChangeSkinData;
begin
  GetSkinData;
  if (FIndex = -1) and not FDefImage.Empty
  then
    begin
      Width := FDefImage.Width;
      Height := FDEfImage.Height;
      SetControlRegion;
      RePaint;
    end
  else
    inherited;  
end;

procedure TspSkinXFormButton.SetDefImage(Value: TBitMap);
begin
  FDefImage.Assign(Value);
  if not FDefImage.Empty
  then
    begin
      DefaultHeight := FDefImage.Height;
      DefaultWidth := FDefImage.Width;
    end;
end;

procedure TspSkinXFormButton.SetDefActiveImage(Value: TBitMap);
begin
  FDefActiveImage.Assign(Value);
end;

procedure TspSkinXFormButton.SetDefDownImage(Value: TBitMap);
begin
  FDefDownImage.Assign(Value);
end;

procedure TspSkinXFormButton.SetDefMask(Value: TBitMap);
begin
  FDefMask.Assign(Value);
  if not FDefImage.Empty
  then
    SetControlRegion;
end;

procedure TspSkinXFormButton.Loaded;
begin
  inherited;
  if (FIndex = -1) and (FDefMask <> nil) and not FDefMask.Empty
  then
    SetControlRegion;
end;

{TspSkinScrollPanel}

const
  ButtonSize = 12;
  HTBUTTON1 = HTOBJECT + 100;
  HTBUTTON2 = HTOBJECT + 101;

constructor TspSkinScrollPanel.Create;
begin
  inherited;
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
  CIndex := FSD.GetControlIndex('panel');
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
begin
  inherited;
  case TimerMode of
    1: ButtonClick(0);
    2: ButtonClick(1);
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
end;

procedure TspSkinScrollPanel.HScrollControls(AOffset: Integer);
begin
  ScrollBy(-AOffset, 0);
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
  if Align <> alNone then GetScrollInfo;
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
             Offset := SMax - (FMax - 1);
             Offset := Offset + (SMax - SPage + 1) + SPosition;
             if Offset > SPosition then  Offset := SPosition;
             HScrollControls(-Offset);
             SMax := FMax - 1;
             SPosition := SPosition - Offset;
             SPage := W;
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
      if not Buttons[1].Visible then SetButtonsVisible(True);
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
                Offset := SMax - (FMax - 1);
                Offset := Offset + (SMax - SPage + 1) + SPosition;
                if Offset > SPosition then  Offset := SPosition;
                VScrollControls(-Offset);
                SMax := FMax - 1;
                SPosition := SPosition - OffSet;
                SPage := H;
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
begin
  if Buttons[0].Visible <> AVisible
  then
    begin
      Buttons[0].Visible := AVisible;
      Buttons[1].Visible := AVisible;
      ReCreateWnd;
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
            HScrollControls(SPosition - SOldPosition)
          else
            StopTimer;
        end
      else
        begin
          SPosition := SPosition - SOffset;
          if SPosition < 0 then SPosition := 0;
          if (SPosition - SOldPosition <> 0)
          then
            VScrollControls(SPosition - SOldPosition)
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
            HScrollControls(SPosition - SOldPosition)
          else
            StopTimer;
        end
      else
        begin
          SPosition := SPosition + SOffset;
          if SPosition > SMax - SPage + 1 then SPosition := SMax - SPage + 1;
          if (SPosition - SOldPosition <> 0)
          then
            VScrollControls(SPosition - SOldPosition)
          else
            StopTimer;
        end;
  end;
end;

procedure TspSkinScrollPanel.CMMOUSELEAVE;
var
  P: TPoint;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
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
  rw, rh, XO, YO: Integer;
  Buffer: TBitMap;
  B, FSkinPicture: TBitMap;
begin
  GetSkinData;
  if PanelData = nil
  then
    begin
      inherited;
      Exit;
    end;

  FSkinPicture := TBitMap(FSD.FActivePictures.Items[PanelData.PictureIndex]);

  if (ClientWidth > 0) and (ClientHeight > 0)
  then
    with PanelData do
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
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
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
  SendMessage(Handle, WM_NCPAINT, 0, 0);
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
          B, FSkinPicture, DownSkinRect, B.Width, B.Height, True);
          C := DownFontColor;
        end
      else
      if MouseIn and not IsNullRect(ActiveSkinRect)
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, ActiveSkinRect, B.Width, B.Height, True);
          C := ActiveFontColor;
        end
      else
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, SkinRect, B.Width, B.Height, True);
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
  FCanScroll := False;
  FSkinDataName := 'toolpanel';
  DefaultHeight := 25;
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

procedure TspSkinToolBar.CreateControlSkinImage(B: TBitMap);
begin
  if ((Buttons[0].Visible) or (Buttons[1].Visible)) and (ResizeMode = 2) 
  then
    begin
      CreateHSkinImage3(LTPt.X, RectWidth(SkinRect) - RTPt.X,
          B, Picture, SkinRect, Width, Height);
    end
  else
    inherited;
end;

procedure TspSkinToolBar.SetBounds;
var
  MaxWidth, OldWidth: Integer;
begin
  OldWidth := Width;
  inherited;
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
  if Align <> alNone then GetScrollInfo;
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
          Rect.Top := NewClRect.Top;
          Rect.Bottom := NewClRect.Bottom;
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
             Offset := SMax - (FMax - 1);
             Offset := Offset + (SMax - SPage + 1) + SPosition;
             if Offset > SPosition then  Offset := SPosition;
             HScrollControls(-Offset);
             SMax := FMax - 1;
             SPosition := SPosition - Offset;
             SPage := W;
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
            HScrollControls(SPosition - SOldPosition)
          else
            StopTimer;
        end;
    1:
        begin
          SPosition := SPosition + SOffset;
          if SPosition > SMax - SPage + 1 then SPosition := SMax - SPage + 1;
          if (SPosition - SOldPosition <> 0)
          then
            HScrollControls(SPosition - SOldPosition)
          else
            StopTimer;
        end;
  end;
end;

procedure TspSkinToolBar.SetButtonsVisible;
begin
  if Buttons[0].Visible <> AVisible
  then
    begin
      Buttons[0].Visible := AVisible;
      Buttons[1].Visible := AVisible;
      ReCreateWnd;
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

procedure TspSkinToolBar.CMMOUSELEAVE;
var
  P: TPoint;
begin
  inherited;
  if (csDesigning in ComponentState) or not FCanScroll then Exit;
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
begin
  inherited;
  if FCanScroll then
  case TimerMode of
    1: ButtonClick(0);
    2: ButtonClick(1);
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
          B, FSkinPicture, DownSkinRect, B.Width, B.Height, True);
          C := DownFontColor;
        end
      else
      if MouseIn and not IsNullRect(ActiveSkinRect)
      then
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, ActiveSkinRect, B.Width, B.Height, True);
          C := ActiveFontColor;
        end
      else
        begin
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          B, FSkinPicture, SkinRect, B.Width, B.Height, True);
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


end.

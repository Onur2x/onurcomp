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

unit SkinExCtrls;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

{$IFDEF VER230}
{$DEFINE VER200_UP}
{$ENDIF}


{$IFDEF VER220}
{$DEFINE VER200_UP}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200_UP}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ExtCtrls, SkinData, spUtils, SkinCtrls, SkinBoxCtrls,
  StdCtrls, ImgList, spEffBmp, SkinHint, spPngImageList, SkinMenus;

type
  TspSkinAnimateGauge = class(TspSkinCustomControl)
  protected
    FImitation: Boolean;
    FCountFrames: Integer;
    FAnimationFrame: Integer;
    FAnimationPauseTimer: TTimer;
    FAnimationTimer: TTimer;
    FAnimationPause: Integer;
    FProgressText: String;
    FShowProgressText: Boolean;
    procedure OnAnimationPauseTimer(Sender: TObject);
    procedure OnAnimationTimer(Sender: TObject);
    procedure SetShowProgressText(Value: Boolean);
    procedure SetProgressText(Value: String);
    procedure GetSkinData; override;
    procedure CreateImage(B: TBitMap);
    procedure DrawProgressText(C: TCanvas);
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    function GetAnimationFrameRect: TRect;
    procedure CalcSize(var W, H: Integer); override;
    function CalcProgressRect: TRect;
    procedure StartInternalAnimation;
    procedure StopInternalAnimation;
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
    AnimationBeginOffset,
    AnimationEndOffset: Integer; 
    //
    AnimationSkinRect: TRect;
    AnimationCountFrames: Integer;
    AnimationTimerInterval: Integer;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartAnimation;
    procedure StopAnimation;
    procedure SetAnimationPause(Value: Integer);
    procedure ChangeSkinData; override;
  published
    property ProgressText: String read FProgressText write SetProgressText;
    property ShowProgressText: Boolean read FShowProgressText write SetShowProgressText;
    property AnimationPause: Integer
      read  FAnimationPause write SetAnimationPause;
    property Align;
    property Enabled;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property PopupMenu;
    property ShowHint;
  end;

  TspSkinButtonEx = class(TspSkinButton)
  protected
    FTitleAlignment: TAlignment;
    FTitle: String;
    FGlowEffect: Boolean;
    FGlowSize: Integer;
    procedure SetTitle(Value: String);
    procedure SetTitleAlignment(Value: TAlignment);
    procedure CreateButtonImage(B: TBitMap; R: TRect;
      ADown, AMouseIn: Boolean); override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Title: String read FTitle write SetTitle;
    property TitleAlignment: TAlignment read FTitleAlignment write SetTitleAlignment;
    property GlowEffect: Boolean read FGlowEffect write FGlowEffect;
    property GlowSize: Integer read FGlowSize write FGlowSize;
  end;


  TspSkinShadowLabel = class(TspGraphicSkinControl)
  private
    FDoubleBuffered: Boolean;
    FFocusControl: TWinControl;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FLayout: TTextLayout;
    FWordWrap: Boolean;
    FShowAccelChar: Boolean;
    FUseSkinColor: Boolean;
    FShadowColor: TColor;
    FShadowSize: Integer;
    FShadowOffset: Integer;
    procedure SetShadowColor(Value: TColor);
    procedure SetShadowSize(Value: Integer);
    procedure SetShadowOffset(Value: Integer);
    procedure SetDoubleBuffered(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetFocusControl(Value: TWinControl);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetLayout(Value: TTextLayout);
    procedure SetWordWrap(Value: Boolean);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    procedure AdjustBounds; dynamic;
    procedure DoDrawText(Cnvs: TCanvas; var Rect: TRect; Flags: Longint); dynamic;
    function GetLabelText: string; virtual;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure Paint; override;
    procedure SetAutoSize(Value: Boolean);
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeSkinData; override;
  published
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Layout: TTextLayout read FLayout write SetLayout default tlTop;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property FocusControl: TWinControl read FFocusControl write SetFocusControl;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property DoubleBuffered: Boolean read
      FDoubleBuffered write SetDoubleBuffered;
    property ShadowSize: Integer read FShadowSize write SetShadowSize;
    property ShadowOffset: Integer read FShadowOffset write SetShadowOffset;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property Caption;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
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

  TspSkinVistaGlowLabel = class(TspGraphicSkinControl)
  private
    FDoubleBuffered: Boolean;
    FFocusControl: TWinControl;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FLayout: TTextLayout;
    FWordWrap: Boolean;
    FShowAccelChar: Boolean;
    FGlowColor: TColor;
    FGlowSize: Integer;
    procedure SetGlowColor(Value: TColor);
    procedure SetDoubleBuffered(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetFocusControl(Value: TWinControl);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetLayout(Value: TTextLayout);
    procedure SetWordWrap(Value: Boolean);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    procedure AdjustBounds; dynamic;
    procedure DoDrawText(Cnvs: TCanvas; var Rect: TRect; Flags: Longint); dynamic;
    function GetLabelText: string; virtual;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure Paint; override;
    procedure SetAutoSize(Value: Boolean);
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure ChangeSkinData; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Layout: TTextLayout read FLayout write SetLayout default tlTop;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property FocusControl: TWinControl read FFocusControl write SetFocusControl;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property DoubleBuffered: Boolean read
      FDoubleBuffered write SetDoubleBuffered;
    property GlowColor: TColor read FGlowColor write SetGlowColor;
    property Caption;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
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


 TspSkinWaveLabel = class(TspGraphicSkinControl)
 private
   FXDiv, FYDiv, FRatioVal: Integer;
   FUseSkinColor: Boolean;
   FAntialiasing: Boolean;
   FAlignment: TAlignment;
   procedure SetAlignment(Value: TAlignment);
   procedure SetXDiv(Value: Integer);
   procedure SetYDiv(Value: Integer);
   procedure SetRatioVal(Value: Integer);
   procedure SetAntialiasing(Value: Boolean);
 protected
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
 public
   procedure Paint; override;
   constructor Create(AOwner: TComponent); override;
 published
   property Antialiasing: Boolean read FAntialiasing write SetAntialiasing;
   property UseSkinColor: Boolean read FUseSkinColor write FUseSkinColor;
   property XDiv: Integer read FXDiv write SetXDiv;
   property YDiv: Integer read FYDiv write SetYDiv;
   property RatioVal: Integer read FRatioVal write SetRatioVal;
   property Caption;
   property Font;
   property Align;
   property Alignment: TAlignment read FAlignment write SetAlignment;
   property Anchors;
   property Constraints;
   property DragCursor;
   property DragKind;
   property DragMode;
   property Enabled;
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
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
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
    StartV, CurV, OldCurV, TempValue: Integer;
    FMinValue, FMaxValue, FValue: Integer;
    FOnChange: TNotifyEvent;
    FDefaultKind: TRegulatorKind;
    function GetRoundValue(X, Y: Integer): Integer;
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
    procedure CalcRoundValue;
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
    FGlowEffect: Boolean;
    FGlowSize: Integer;
    FMouseIn: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultActiveFontColor: TColor;
     FURL: String;
    FUseUnderLine: Boolean;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure SetDefaultFont(Value: TFont);
    property Transparent;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure GetSkinData;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
    procedure SetUseUnderLine(Value: Boolean);
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
    property GlowEffect: Boolean read FGlowEffect write FGlowEffect;
    property GlowSize: Integer read FGlowSize write FGlowSize;
    property UseUnderLine: Boolean read FUseUnderLine write SetUseUnderLine;
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
  

  TspSkinOfficeItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FTitle: String;
    FCaption: String;
    FEnabled: Boolean;
    FData: Pointer;
    FHeader: Boolean;
    FOnClick: TNotifyEvent;
    FChecked: Boolean;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetTitle(const Value: String); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetData(const Value: Pointer); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetHeader(Value: Boolean); virtual;
    procedure SetChecked(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    IsVisible: Boolean;
    Active: Boolean;
    constructor Create(Collection: TCollection); override;
    property Data: Pointer read FData write SetData;
    procedure Assign(Source: TPersistent); override;
  published
    property Header: Boolean read FHeader write SetHeader;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Title: String read FTitle write SetTitle;
    property Caption: String read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property Checked: Boolean  read FChecked write SetChecked;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;


  TspSkinOfficeListBox = class;

  TspSkinOfficeItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinOfficeItem;
    procedure SetItem(Index: Integer; Value:  TspSkinOfficeItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    OfficeListBox: TspSkinOfficeListBox;
    constructor Create(AListBox: TspSkinOfficeListBox);
    property Items[Index: Integer]: TspSkinOfficeItem read GetItem write SetItem; default;
    function Add: TspSkinOfficeItem;
    function Insert(Index: Integer): TspSkinOfficeItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspDrawSkinOfficeItemEvent = procedure(Cnvs: TCanvas; Index: Integer;
    TextRct: TRect) of object;

  TspSkinOfficeListBox = class(TspSkinCustomControl)
  protected
    FCheckOffset: Integer;
    FShowCheckBoxes: Boolean;
    FInUpdateItems: Boolean;
    FHeaderLeftAlignment: Boolean;
    FOnDrawItem: TspDrawSkinOfficeItemEvent;
    FMouseMoveChangeIndex: Boolean;
    FDisabledFontColor: TColor;
    FShowLines: Boolean;
    FClicksDisabled: Boolean;
    FMouseDown: Boolean;
    FMouseActive: Integer;
    FMax: Integer;
    FRealMax: Integer;
    FItemsRect: TRect;
    FScrollOffset: Integer;
    FItems: TspSkinOfficeItems;
    FImages: TCustomImageList;
    FShowItemTitles: Boolean;
    FItemHeight: Integer;
    FHeaderHeight: Integer;
    FOldHeight: Integer;
    ScrollBar: TspSkinScrollBar;
    FItemIndex: Integer;
    FOnItemClick: TNotifyEvent;
    FOnItemCheckClick: TNotifyEvent;
    FItemSkinDataName: String;
    FHeaderSkinDataName: String;
    procedure SetShowLines(Value: Boolean);
    procedure SetShowCheckBoxes(Value: Boolean);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemActive(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetHeaderHeight(Value: Integer);
    procedure SetHeaderLeftAlignment(Value: Boolean);
    procedure SetItems(Value: TspSkinOfficeItems);
    procedure SetImages(Value: TCustomImageList);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetShowItemTitles(Value: Boolean);  public

    procedure DrawItem(Index: Integer; Cnvs: TCanvas);

    procedure SkinDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CalcItemRects;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure ShowScrollbar;
    procedure HideScrollBar;
    procedure UpdateScrollInfo;
    procedure AdjustScrollBar;
    procedure SBChange(Sender: TObject);
    procedure Loaded; override;
    function ItemAtPos(X, Y: Integer): Integer;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;

    procedure WndProc(var Message: TMessage); override;

    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure FindUp;
    procedure FindDown;
    procedure FindPageUp;
    procedure FindPageDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    function CalcHeight(AItemCount: Integer): Integer;
    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollToItem(Index: Integer);
    procedure Scroll(AScrollOffset: Integer);
    procedure GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
    procedure ChangeSkinData; override;
    procedure BeginUpdateItems;
    procedure EndUpdateItems;
  published
    property ShowCheckBoxes: Boolean
      read FShowCheckBoxes write SetShowCheckBoxes;
    property HeaderLeftAlignment: Boolean
     read FHeaderLeftAlignment write SetHeaderLeftAlignment;
    property HeaderSkinDataName: String
     read FHeaderSkinDataName write FHeaderSkinDataName;
    property ItemSkinDataName: String
      read FItemSkinDataName write FItemSkinDataName;
    property Items:  TspSkinOfficeItems read FItems write SetItems;
    property Images: TCustomImageList read FImages write SetImages;
    property ShowItemTitles: Boolean
      read FShowItemTitles write SetShowItemTitles;
    property ItemHeight: Integer
      read FItemHeight write SetItemHeight;
    property HeaderHeight: Integer
      read FHeaderHeight write SetHeaderHeight;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ShowLines: Boolean read FShowLines write SetShowLines;
    property MouseMoveChangeIndex: Boolean
      read FMouseMoveChangeIndex write FMouseMoveChangeIndex;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property TabStop;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnDrawItem: TspDrawSkinOfficeItemEvent
      read FOnDrawItem write FOnDrawItem;
    property OnItemClick: TNotifyEvent
      read FOnItemClick write FOnItemClick;
    property OnItemCheckClick: TNotifyEvent
      read FOnItemCheckClick write FOnItemCheckClick;
    property OnClick;
    property OnContextPopup;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  TspPopupOfficeListBox = class(TspSkinOfficeListBox)
  private
    FOldAlphaBlend: Boolean;
    FOldAlphaBlendValue: Byte;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
    procedure Show(Origin: TPoint);
  end;

  TspSkinCustomOfficeComboBox = class(TspSkinCustomControl)
  protected
    FOnDrawItem: TspDrawSkinOfficeItemEvent;
    FShowItemTitle: Boolean;
    FShowItemImage: Boolean;
    FShowItemText: Boolean;
    FDropDownCount: Integer;
    FDropDown: Boolean;
    FToolButtonStyle: Boolean;
    FDefaultColor: TColor;
    FUseSkinSize: Boolean;
    WasInLB: Boolean;
    TimerMode: Integer;
    FListBoxWidth: Integer;
    FListBoxHeight: Integer;
    FHideSelection: Boolean;
    FLastTime: Cardinal;

    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;

    FOnChange: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;

    FMouseIn: Boolean;
    FOldItemIndex: Integer;
    FLBDown: Boolean;
    //
    FListBox: TspPopupOfficeListBox;
    FListBoxWindowProc: TWndMethod;
    //
    CBItem: TspCBItem;
    Button: TspCBButtonX;

    procedure SetShowItemTitle(Value: Boolean);
    procedure SetShowItemImage(Value: Boolean);
    procedure SetShowItemText(Value: Boolean);

    function GetListBoxHeaderLeftAlignment: Boolean;
    procedure SetListBoxHeaderLeftAlignment(Value: Boolean);

    procedure ListBoxWindowProcHook(var Message: TMessage);

    procedure DrawMenuMarker(C: TCanvas; R: TRect; AActive, ADown: Boolean;
     ButtonData: TspDataSkinButtonControl);

    procedure ProcessListBox;
    procedure StartTimer;
    procedure StopTimer;

    function GetImages: TCustomImageList;
    procedure SetImages(Value: TCustomImageList);

    function GetListBoxDefaultFont: TFont;
    procedure SetListBoxDefaultFont(Value: TFont);

    function GetListBoxUseSkinFont: Boolean;
    procedure SetListBoxUseSkinFont(Value: Boolean);

    procedure CheckButtonClick(Sender: TObject);

    procedure DrawDefaultItem(Cnvs: TCanvas);
    procedure DrawSkinItem(Cnvs: TCanvas);
    procedure DrawResizeSkinItem(Cnvs: TCanvas);

    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);

    procedure SetItems(Value: TspSkinOfficeItems);
    function GetItems: TspSkinOfficeItems;

    procedure SetDropDownCount(Value: Integer);
    procedure DrawButton(C: TCanvas);
    procedure DrawResizeButton(C: TCanvas);
    procedure CalcRects;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer; 
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure GetSkinData; override;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;

    procedure DefaultFontChange; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure CreateControlDefaultImage2(B: TBitMap);
    procedure CreateControlSkinImage2(B: TBitMap);
    procedure CreateControlToolSkinImage(B: TBitMap; AText: String);
    procedure CreateControlToolDefaultImage(B: TBitMap; AText: String);

    procedure Change; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CalcSize(var W, H: Integer); override;
    procedure SetControlRegion; override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure SetDefaultColor(Value: TColor);
    function GetDisabledFontColor: TColor;
    procedure SetToolButtonStyle(Value: Boolean);

    procedure EditUp1(AChange: Boolean);
    procedure EditDown1(AChange: Boolean);
    procedure EditPageUp1(AChange: Boolean);
    procedure EditPageDown1(AChange: Boolean);
    //
    function GetListBoxSkinDataName: String;
    procedure SetListBoxSkinDataName(Value: String);
    function GetListBoxShowLines: Boolean;
    procedure SetListBoxShowLines(Value: Boolean);
    function GetListBoxItemHeight: Integer;
    procedure SetListBoxItemHeight(Value: Integer);
    function GetListBoxHeaderHeight: Integer;
    procedure SetListBoxHeaderHeight(Value: Integer);
    function GetListBoxShowItemTitles: Boolean;
    procedure SetListBoxShowItemTitles(Value: Boolean);
    //
    {$IFDEF VER200_UP}
    function GetListBoxTouch: TTouchManager;
    procedure SetListBoxTouch(Value: TTouchManager);
    {$ENDIF}
  public
    ActiveSkinRect: TRect;
    ActiveFontColor: TColor;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, FocusItemRect, ActiveItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, FocusFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect, UnEnabledButtonRect: TRect;
    ListBoxName: String;
    ItemStretchEffect, FocusItemStretchEffect: Boolean;
    ShowFocus: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintSkinTo(C: TCanvas; X, Y: Integer; AText: String);
    procedure ChangeSkinData; override;
    procedure CloseUp(Value: Boolean);
    procedure BeginUpdateItems;
    procedure EndUpdateItems;
    procedure DropDown; virtual;
    function IsPopupVisible: Boolean;
    function CanCancelDropDown: Boolean;
    procedure Invalidate; override;
    property ToolButtonStyle: Boolean
      read FToolButtonStyle write SetToolButtonStyle;
    property HideSelection: Boolean
      read FHideSelection write FHideSelection;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property Images: TCustomImageList read GetImages write SetImages;
    //
    property ListBoxHeaderLeftAlignment: Boolean
      read GetListBoxHeaderLeftAlignment
      write SetListBoxHeaderLeftAlignment;
    property ShowItemTitle: Boolean read FShowItemTitle write SetShowItemTitle;
    property ShowItemImage: Boolean read FShowItemImage write SetShowItemImage;
    property ShowItemText: Boolean read FShowItemText write SetShowItemText;

    //
    {$IFDEF VER200_UP}
    property ListBoxTouch: TTouchManager
      read GetListBoxTouch write SetListBoxTouch;
    {$ENDIF}
    //
    property ListBoxWidth: Integer read FListBoxWidth write FListBoxWidth;
    property ListBoxHeight: Integer read FListBoxHeight write FListBoxHeight;
    property ListBoxDefaultFont: TFont
      read GetListBoxDefaultFont write SetListBoxDefaultFont;
    property ListBoxUseSkinFont: Boolean
      read GetListBoxUseSkinFont write SetListBoxUseSkinFont;
    property ListBoxShowItemTitles: Boolean
      read GetListBoxShowItemTitles write SetListBoxShowItemTitles;
    property ListBoxSkinDataName: String read
      GetListBoxSkinDataName write SetListBoxSkinDataName;
    property ListBoxShowLines: Boolean
      read GetListBoxShowLines write SetListBoxShowLines;
    property ListBoxItemHeight: Integer
      read GetListBoxItemHeight write SetListBoxItemHeight;
    property ListBoxHeaderHeight: Integer
      read GetListBoxHeaderHeight write SetListBoxHeaderHeight;
    //
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    //
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;
    property Align;
    property Items: TspSkinOfficeItems read GetItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount;
     property OnDrawItem: TspDrawSkinOfficeItemEvent
      read FOnDrawItem write FOnDrawItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  published
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
  end;

  TspSkinOfficeComboBox = class(TspSkinCustomOfficeComboBox)
  published
    {$IFDEF VER200_UP}
    property ListBoxTouch;
    {$ENDIF}
    property ToolButtonStyle;
    property AlphaBlend;
    property AlphaBlendValue;
    property AlphaBlendAnimation;
    property ListBoxHeaderLeftAlignment;
    property ListBoxDefaultFont;
    property ListBoxUseSkinFont;
    property ListBoxWidth;
    property ListBoxHeight;
    property ListBoxShowItemTitles;
    property ListBoxSkinDataName;
    property ListBoxShowLines;
    property ListBoxItemHeight;
    property ListBoxHeaderHeight;

    property HideSelection;
    property Images;

    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    //
    property ShowItemTitle;
    property ShowItemImage;
    property ShowItemText;
    //
    property DefaultColor;
    property Align;
    property Items;
    property ItemIndex;
    property DropDownCount;
    property Font;
    property OnDrawItem;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

  // TspSkinLinkBar ============================================================

  TspSkinLinkBarItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FActiveImageIndex: TImageIndex;
    FUseCustomGlowColor: Boolean;
    FCustomGlowColor: TColor;
    FCaption: String;
    FEnabled: Boolean;
    FHeader: Boolean;
    FOnClick: TNotifyEvent;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetActiveImageIndex(const Value: TImageIndex); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetHeader(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    IsVisible: Boolean;
    Active: Boolean;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Header: Boolean read FHeader write SetHeader;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Caption: String read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property ActiveImageIndex: TImageIndex read FActiveImageIndex
      write SetActiveImageIndex default -1;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property UseCustomGlowColor: Boolean
      read FUseCustomGlowColor write FUseCustomGlowColor;
    property CustomGlowColor: TColor
      read FCustomGlowColor write FCustomGlowColor;
  end;

  TspSkinLinkBar = class;

  TspSkinLinkBarItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinLinkBarItem;
    procedure SetItem(Index: Integer; Value:  TspSkinLinkBarItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    LinkBar: TspSkinLinkBar;
    constructor Create(AListBox: TspSkinLinkBar);
    property Items[Index: Integer]: TspSkinLinkBarItem read GetItem write SetItem; default;
    function Add: TspSkinLinkBarItem;
    function Insert(Index: Integer): TspSkinLinkBarItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspSkinLinkBar = class(TspSkinCustomControl)
  protected
    FHeaderLeftAlignment: Boolean;
    FHeaderSkinDataName: String;
    FHeaderBold: Boolean;
    FGlowEffect: Boolean;
    FGlowSize: Integer;
    FShowTextUnderLine: Boolean;
    FHoldSelectedItem: Boolean;
    FShowBlurMarker: Boolean;
    FSpacing: Integer;
    FDisabledFontColor: TColor;
    FShowLines: Boolean;
    FClicksDisabled: Boolean;
    FMouseDown: Boolean;
    FMouseActive: Integer;
    FMax: Integer;
    FRealMax: Integer;
    FItemsRect: TRect;
    FScrollOffset: Integer;
    FItems: TspSkinLinkBarItems;
    FImages: TCustomImageList;
    FShowItemTitles: Boolean;
    FItemHeight: Integer;
    FHeaderHeight: Integer;
    FOldHeight: Integer;
    ScrollBar: TspSkinScrollBar;
    FItemIndex: Integer;
    FOnItemClick: TNotifyEvent;
    //
    FSkinActiveFontColor: TColor;
    FSkinFontColor: TColor;
    //

    procedure SetHoldSelectedItem(Value: Boolean);
    procedure GetSkinData; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetShowLines(Value: Boolean);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemActive(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetHeaderHeight(Value: Integer);
    procedure SetHeaderLeftAlignment(Value: Boolean);
    procedure SetItems(Value: TspSkinLinkBarItems);
    procedure SetImages(Value: TCustomImageList);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetShowItemTitles(Value: Boolean);  public

    procedure DrawItem(Index: Integer; Cnvs: TCanvas);

    procedure SkinDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CalcItemRects;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure ShowScrollbar;
    procedure HideScrollBar;
    procedure UpdateScrollInfo;
    procedure AdjustScrollBar;
    procedure SBChange(Sender: TObject);
    procedure Loaded; override;
    function ItemAtPos(X, Y: Integer): Integer;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure WndProc(var Message: TMessage); override;

    function CalcHeight(AItemCount: Integer): Integer;
    procedure SetSpacing(Value: Integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollToItem(Index: Integer);
    procedure Scroll(AScrollOffset: Integer);
    procedure GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
    procedure ChangeSkinData; override;

  published
    property HeaderLeftAlignment: Boolean
      read FHeaderLeftAlignment write SetHeaderLeftAlignment;
    property HeaderSkinDataName: String
      read FHeaderSkinDataName write FHeaderSkinDataName;
    property HeaderBold: Boolean
     read FHeaderBold write FHeaderBold;
    property GlowEffect: Boolean read FGlowEffect write FGlowEffect;
    property GlowSize: Integer read FGlowSize write FGlowSize;
    property ShowTextUnderLine: Boolean
      read FShowTextUnderLine write FShowTextUnderLine;
    property HoldSelectedItem: Boolean
      read FHoldSelectedItem write SetHoldSelectedItem;
      
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ShowBlurMarker: Boolean
      read FShowBlurMarker write FShowBlurMarker;
    property Spacing: Integer
     read FSpacing write SetSpacing;
    property Items:  TspSkinLinkBarItems read FItems write SetItems;
    property Images: TCustomImageList read FImages write SetImages;
    property ShowItemTitles: Boolean
      read FShowItemTitles write SetShowItemTitles;
    property ItemHeight: Integer
      read FItemHeight write SetItemHeight;
    property HeaderHeight: Integer
      read FHeaderHeight write SetHeaderHeight;
    property ShowLines: Boolean read FShowLines write SetShowLines;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property TabStop;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnItemClick: TNotifyEvent
      read FOnItemClick write FOnItemClick;
    property OnClick;
    property OnContextPopup;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  // TspSkinToolBarEx ==========================================================

  TspSkinToolBarExItem = class(TCollectionItem)
  private
    FHint: String;
    FImageIndex: TImageIndex;
    FActiveImageIndex: TImageIndex;
    FEnabled: Boolean;
    FOnClick: TNotifyEvent;
    FUseCustomGlowColor: Boolean;
    FCustomGlowColor: TColor;
    FCaption: String;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetActiveImageIndex(const Value: TImageIndex); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetCaption(Value: String); virtual;
  public
    ItemRect: TRect;
    IsVisible: Boolean;
    Active: Boolean;
    Down: Boolean;
    FReflectionBitmap: TspBitmap;
    FReflectionActiveBitmap: TspBitmap;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure InitReflectionBitmaps;
  published
    property UseCustomGlowColor: Boolean
      read FUseCustomGlowColor write FUseCustomGlowColor;
    property CustomGlowColor: TColor
      read FCustomGlowColor write FCustomGlowColor;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property ActiveImageIndex: TImageIndex read FActiveImageIndex
      write SetActiveImageIndex default -1;
    property Caption: String read FCaption write SetCaption;  
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TspSkinToolBarEx = class;

  TspSkinToolBarExItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinToolBarExItem;
    procedure SetItem(Index: Integer; Value:  TspSkinToolBarExItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    ToolBarEx: TspSkinToolBarEx;
    constructor Create(AListBox: TspSkinToolBarEx);
    property Items[Index: Integer]: TspSkinToolBarExItem read GetItem write SetItem; default;
    function Add: TspSkinToolBarExItem;
    function Insert(Index: Integer): TspSkinToolBarExItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspMenuExPosition = (spmpAuto, spmpTop, spmpBottom);
  
  TspSkinToolBarEx = class(TspSkinCustomControl)
  protected
    Buttons: array [0..1] of TspControlButton;
    //
    FSkinActiveArrowColor: TColor;
    FSkinArrowColor: TColor;
    //
    FMenuExPosition: TspMenuExPosition;
    //
    FArrowImages: TspPngImageList;
    FShowCaptions: Boolean;
    FOnChange: TNotifyEvent;
    FItemIndex: Integer;
    FHoldSelectedItem: Boolean;
    FScrollIndex, FScrollMax: Integer;
    FShowBorder: Boolean;
    FCursorColor: TColor;
    FAutoSize: Boolean;
    FSkinHint: TspSkinHint;
    FShowActiveCursor: Boolean;
    FItemSpacing: Integer;
    FItems: TspSkinToolBarExItems;
    FImages: TspPngImageList;
    FShowItemHints: Boolean;
    FShowHandPointCursor: Boolean;
    FShowGlow: Boolean;
    function GetVisibleCount: Integer;
    procedure DrawButtons(Cnvs: TCanvas);
    procedure CheckScroll;
    function ItemAtPos(X, Y: Integer): Integer;
    procedure SetShowBorder(Value: Boolean);
    procedure SetAutoSize(Value: Boolean);
    procedure SetItemSpacing(Value: Integer);
    procedure SetItems(Value: TspSkinToolBarExItems);
    procedure SetImages(Value: TspPngImageList);
    procedure SetArrowImages(Value: TspPngImageList);
    //
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    //
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure DrawItem(Cnvs: TCanvas; Index: Integer);
    procedure CalcItemRects;
    procedure Loaded; override;
    procedure TestActive(X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
     procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure AdjustBounds;
    procedure GetSkinData; override;
    procedure SetItemIndex(Value: Integer);
    procedure SetShowGlow(Value: Boolean);
    procedure SetShowCaptions(Value: Boolean);
  public
    MouseInItem, OldMouseInItem: Integer;
    procedure DecScroll;
    procedure IncScroll;
    procedure UpdatedSelected;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdateItems;
    procedure EndUpdateItems;
  published
    property MenuExPosition: TspMenuExPosition
      read FMenuExPosition write FMenuExPosition;
    property ShowGlow: Boolean read
      FShowGlow write SetShowGlow;
    property HoldSelectedItem: Boolean
      read FHoldSelectedItem write FHoldSelectedItem;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property SkinHint: TspSkinHint read FSkinHint write FSkinHint;
    property ShowCaptions: Boolean
      read FShowCaptions write SetShowCaptions;
    property ShowBorder: Boolean
      read FShowBorder write SetShowBorder;
    property ShowHandPointCursor: Boolean
      read FShowHandPointCursor write FShowHandPointCursor; 
    property ShowActiveCursor: Boolean
      read FShowActiveCursor write FShowActiveCursor;
    property ItemSpacing: Integer read FItemSpacing write SetItemSpacing;
    property ShowItemHints: Boolean read FShowItemHints write FShowItemHints;
    property Images: TspPngImageList read FImages write SetImages;
    property ArrowImages: TspPngImageList read FArrowImages write SetArrowImages;
    property Items:  TspSkinToolBarExItems read FItems write SetItems;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property PopupMenu;
    property Visible;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnContextPopup;
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

  TspSkinMenuEx = class;

  TspSkinMenuExItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FActiveImageIndex: TImageIndex;
    FHint: String;
    FUseCustomGlowColor: Boolean;
    FCustomGlowColor: TColor;
    FOnClick: TNotifyEvent;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetActiveImageIndex(const Value: TImageIndex); virtual;
  public
    ItemRect: TRect;
    FColor: TColor;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property UseCustomGlowColor: Boolean
      read FUseCustomGlowColor write FUseCustomGlowColor;
    property CustomGlowColor: TColor
      read FCustomGlowColor write FCustomGlowColor;
    property Hint: String read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property ActiveImageIndex: TImageIndex read FActiveImageIndex
      write SetActiveImageIndex default -1;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TspSkinMenuExItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinMenuExItem;
    procedure SetItem(Index: Integer; Value:  TspSkinMenuExItem);
  protected
    function GetOwner: TPersistent; override;
  public
    MenuEx: TspSkinMenuEx;
    constructor Create(AMenuEx: TspSkinMenuEx);
    property Items[Index: Integer]:  TspSkinMenuExItem read GetItem write SetItem; default;
  end;

  TspSkinMenuExPopupWindow = class(TCustomControl)
  private
    FSkinSupport: Boolean;
    OldAppMessage: TMessageEvent;
    MenuEx: TspSkinMenuEx;
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
    procedure TestActive(X, Y: Integer);
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

  TspSkinMenuEx = class(TComponent)
  private
    FShowGlow: Boolean;
    FShowActiveCursor: Boolean;
    FImages: TspPngImageList;
    FItems: TspSkinMenuExItems;
    FItemIndex: Integer;
    FColumnsCount: Integer;
    FOnItemClick: TNotifyEvent;
    FSkinData: TspSkinData;
    FPopupWindow: TspSkinMenuExPopupWindow;
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
    procedure SetItems(Value: TspSkinMenuExItems);
    procedure SetImages(Value: TspPngImageList);
    procedure SetColumnsCount(Value: Integer);
    procedure SetSkinData(Value: TspSkinData);
    function GetSelectedItem: TspSkinMenuExItem;
  protected
    ToolBarEx: TspSkinToolBarEx;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ProcessEvents(ACanProcess: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Popup(AToolBarEx: TspSkinToolBarEx); overload;
    procedure Popup(X, Y: Integer); overload;
    procedure Hide;
    property SelectedItem: TspSkinMenuExItem read GetSelectedItem;
    property OnInternalChange: TNotifyEvent read FOnInternalChange write FOnInternalChange;
    property OnInternalMenuClose: TNotifyEvent read FOnInternalMenuClose write FOnInternalMenuClose;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
  published
    property ShowActiveCursor: Boolean read FShowActiveCursor write FShowActiveCursor;
    property ShowGlow: Boolean read FShowGlow write FShowGlow;
    property Images: TspPngImageList read FImages write SetImages;
    property SkinHint: TspSkinHint read FSkinHint write FSkinHint;
    property ShowHints: Boolean read FShowHints write FShowHints;
    property Items: TspSkinMenuExItems read FItems write SetItems;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property ColumnsCount: Integer read FColumnsCount write SetColumnsCount;
    property SkinData: TspSkinData read FSkinData write SetSkinData;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property OnItemClick: TNotifyEvent read FOnItemClick write FOnItemClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMenuPopup: TNotifyEvent read FOnMenuPopup write FOnMenuPopup;
    property OnMenuClose: TNotifyEvent read FOnMenuClose write FOnMenuClose;
  end;

    // TspSkinHorzListBox

  TspSkinHorzListBox = class;

  TspSkinHorzItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FCaption: String;
    FEnabled: Boolean;
    FData: Pointer;
    FOnClick: TNotifyEvent;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetData(const Value: Pointer); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    IsVisible: Boolean;
    Active: Boolean;
    constructor Create(Collection: TCollection); override;
    property Data: Pointer read FData write SetData;
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Caption: String read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TspSkinHorzItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinHorzItem;
    procedure SetItem(Index: Integer; Value:  TspSkinHorzItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    HorzListBox: TspSkinHorzListBox;
    constructor Create(AListBox: TspSkinHorzListBox);
    property Items[Index: Integer]: TspSkinHorzItem read GetItem write SetItem; default;
    function Add: TspSkinHorzItem;
    function Insert(Index: Integer): TspSkinHorzItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspSkinHorzListBox = class(TspSkinCustomControl)
  protected
    FInUpdateItems: Boolean;
    FOnDrawItem: TspDrawSkinOfficeItemEvent;
    FShowGlow: Boolean;
    FItemLayout: TspButtonLayout;
    FItemMargin: Integer;
    FItemSpacing: Integer;
    FMouseMoveChangeIndex: Boolean;
    FDisabledFontColor: TColor;
    FClicksDisabled: Boolean;
    FMouseDown: Boolean;
    FMouseActive: Integer;
    FMax: Integer;
    FRealMax: Integer;
    FItemsRect: TRect;
    FScrollOffset: Integer;
    FItems: TspSkinHorzItems;
    FImages: TCustomImageList;
    FShowItemTitles: Boolean;
    FItemWidth: Integer;
    FOldWidth: Integer;
    ScrollBar: TspSkinScrollBar;
    FItemIndex: Integer;
    FOnItemClick: TNotifyEvent;
    procedure SetShowGlow(Value: Boolean);
    procedure SetItemLayout(Value: TspButtonLayout);
    procedure SetItemMargin(Value: Integer);
    procedure SetItemSpacing(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemActive(Value: Integer);
    procedure SetItemWidth(Value: Integer);
    procedure SetItems(Value: TspSkinHorzItems);
    procedure SetImages(Value: TCustomImageList);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetShowItemTitles(Value: Boolean);  public

    procedure DrawItem(Index: Integer; Cnvs: TCanvas);

    procedure SkinDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure DefaultDrawItem(Index: Integer; Cnvs: TCanvas);

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CalcItemRects;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure ShowScrollbar;
    procedure HideScrollBar;
    procedure UpdateScrollInfo;
    procedure AdjustScrollBar;
    procedure SBChange(Sender: TObject);
    procedure Loaded; override;
    function ItemAtPos(X, Y: Integer): Integer;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    
    procedure WndProc(var Message: TMessage); override;

    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure FindUp;
    procedure FindDown;
    procedure FindPageUp;
    procedure FindPageDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function CalcWidth(AItemCount: Integer): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollToItem(Index: Integer);
    procedure Scroll(AScrollOffset: Integer);
    procedure GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
    procedure ChangeSkinData; override;
    procedure BeginUpdateItems;
    procedure EndUpdateItems;
  published
    property ShowGlow: Boolean read FShowGlow write SetShowGlow;
    property ItemLayout: TspButtonLayout read FItemLayout write SetItemLayout;
    property ItemMargin: Integer read FItemMargin write SetItemMargin;
    property ItemSpacing: Integer read FItemSpacing write SetItemSpacing;
    property Items:  TspSkinHorzItems read FItems write SetItems;
    property Images: TCustomImageList read FImages write SetImages;
    property ShowItemTitles: Boolean
      read FShowItemTitles write SetShowItemTitles;
    property ItemWidth: Integer
      read FItemWidth write SetItemWidth;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property MouseMoveChangeIndex: Boolean
      read FMouseMoveChangeIndex write FMouseMoveChangeIndex; 
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property TabStop;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnDrawItem: TspDrawSkinOfficeItemEvent
      read FOnDrawItem write FOnDrawItem;
    property OnItemClick: TNotifyEvent
      read FOnItemClick write FOnItemClick;
    property OnClick;
    property OnContextPopup;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TspSkinDividerType = (spdtVerticalLine, spdtHorizontalLine);

  TspSkinDivider = class(TspGraphicSkinControl)
  private
    FDividerType: TspSkinDividerType;
    procedure SetDividerType(Value: TspSkinDividerType);
  protected
    procedure GetSkinData; override;
    procedure DrawLineV;
    procedure DrawLineH;
  public
    DarkColor: TColor;
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property DividerType: TspSkinDividerType
      read FDividerType write SetDividerType;
    property Align;
  end;

 TspSkinGraphicButton = class(TspSkinMenuSpeedButton)
 protected
   FGraphicMenu: TspSkinImagesMenu;
   FGraphicImages: TCustomImageList;

   procedure InitImages; virtual;
   procedure InitItems; virtual;

   function GetMenuDefaultFont: TFont;
   procedure SetMenuDefaultFont(Value: TFont);
   function GetMenuUseSkinFont: Boolean;
   procedure SetMenuUseSkinFont(Value: Boolean);
   function GetMenuAlphaBlend: Boolean;
   procedure SetMenuAlphaBlend(Value: Boolean);
   function GetMenuAlphaBlendAnimation: Boolean;
   procedure SetMenuAlphaBlendAnimation(Value: Boolean);
   function GetMenuAlphaBlendValue: Integer;
   procedure SetMenuAlphaBlendValue(Value: Integer);

   function GetMenuShowHints: Boolean;
   procedure SetMenuShowHints(Value: Boolean);

   function GetMenuSkinHint: TspSkinHint;
   procedure SetMenuSkinHint(Value: TspSkinHint);

   function GetGraphicMenuItems: TspImagesMenuItems;
   function GetSelectedItem: TspImagesMenuItem;

   function GetItemIndex: Integer;
   procedure SetItemIndex(Value: Integer);

   procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelectedItem: TspImagesMenuItem read GetSelectedItem;
  published
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property MenuSkinHint: TspSkinHint read GetMenuSkinHint write SetMenuSkinHint;
    property MenuShowHints: Boolean read GetMenuShowHints write SetMenuShowHints;
    property GraphicItems: TspImagesMenuItems read GetGraphicMenuItems;
    property MenuUseSkinFont: Boolean read GetMenuUseSkinFont write SetMenuUseSkinFont;
    property MenuDefaultFont: TFont read GetMenuDefaultFont write SetMenuDefaultFont;
    property MenuAlphaBlend: Boolean read GetMenuAlphaBlend write SetMenuAlphaBlend;
    property MenuAlphaBlendValue: Integer read GetMenuAlphaBlendValue write SetMenuAlphaBlendValue;
    property MenuAlphaBlendAnimation: Boolean read GetMenuAlphaBlendAnimation write SetMenuAlphaBlendAnimation;
  end;

 TspSkinGradientStyleButton = class(TspSkinGraphicButton)
 protected
   procedure InitImages; override;
   procedure InitItems; override;
 end;

 TspSkinBrushStyleButton = class(TspSkinGraphicButton)
 protected
   procedure InitImages; override;
   procedure InitItems; override;
 end;

 TspSkinPenStyleButton = class(TspSkinGraphicButton)
 protected
   procedure InitImages; override;
   procedure InitItems; override;
 end;

 TspSkinPenWidthButton = class(TspSkinGraphicButton)
 protected
   procedure InitImages; override;
   procedure InitItems; override;
 end;

 TspSkinShadowStyleButton = class(TspSkinGraphicButton)
 protected
   procedure InitImages; override;
   procedure InitItems; override;
 end;


 // TspSkinGridView =====================================================

  TspSkinGridViewItem = class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FCaption: String;
    FEnabled: Boolean;
    FData: Pointer;
    FHeader: Boolean;
    FOnClick: TNotifyEvent;
  protected
    procedure SetImageIndex(const Value: TImageIndex); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetData(const Value: Pointer); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetHeader(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    IsVisible: Boolean;
    Active: Boolean;
    constructor Create(Collection: TCollection); override;
    property Data: Pointer read FData write SetData;
    procedure Assign(Source: TPersistent); override;
  published
    property Header: Boolean read FHeader write SetHeader;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Caption: String read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex
      write SetImageIndex default -1;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TspSkinGridView = class;

  TspSkinGridViewItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspSkinGridViewItem;
    procedure SetItem(Index: Integer; Value:  TspSkinGridViewItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    GridView: TspSkinGridView;
    constructor Create(AGridView: TspSkinGridView);
    property Items[Index: Integer]: TspSkinGridViewItem read GetItem write SetItem; default;
    function Add: TspSkinGridViewItem;
    function Insert(Index: Integer): TspSkinGridViewItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspSkinGridView = class(TspSkinCustomControl)
  protected
    FMouseMoveChangeIndex: Boolean;
    FItemLayout: TspButtonLayout;
    FItemMargin: Integer;
    FItemSpacing: Integer;
    RowCount, ColCount: Integer;
    FInUpdateItems: Boolean;
    FOnDrawItem: TspDrawSkinOfficeItemEvent;
    FDisabledFontColor: TColor;
    FClicksDisabled: Boolean;
    FMouseDown: Boolean;
    FMouseActive: Integer;
    FMax: Integer;
    FRealMax: Integer;
    FItemsRect: TRect;
    FScrollOffset: Integer;
    FItems: TspSkinGridViewItems;
    FImages: TCustomImageList;
    FItemHeight: Integer;
    FItemWidth: Integer;
    FHeaderHeight: Integer;
    FOldHeight: Integer;
    ScrollBar: TspSkinScrollBar;
    FItemIndex: Integer;
    FOnItemClick: TNotifyEvent;
    FHeaderLeftAlignment: Boolean;
    FItemSkinDataName: String;
    FHeaderSkinDataName: String;
    procedure SetItemLayout(Value: TspButtonLayout);
    procedure SetItemMargin(Value: Integer);
    procedure SetItemSpacing(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemActive(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemWidth(Value: Integer);
    procedure SetHeaderHeight(Value: Integer);
    procedure SetHeaderLeftAlignment(Value: Boolean);
    procedure SetItems(Value: TspSkinGridViewItems);
    procedure SetImages(Value: TCustomImageList);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    procedure DrawItem(Index: Integer; Cnvs: TCanvas);

    procedure SkinDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
    procedure SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure CalcItemRects;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure ShowScrollbar;
    procedure HideScrollBar;
    procedure UpdateScrollInfo;
    procedure AdjustScrollBar;
    procedure SBChange(Sender: TObject);
    procedure Loaded; override;
    function ItemAtPos(X, Y: Integer): Integer;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;

    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;

    procedure WndProc(var Message: TMessage); override;

    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure FindUp;
    procedure FindDown;
    procedure FindLeft;
    procedure FindRight;
    procedure FindPageUp;
    procedure FindPageDown;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function CalcHeight(AItemCount: Integer): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollToItem(Index: Integer);
    procedure Scroll(AScrollOffset: Integer);
    procedure GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
    procedure ChangeSkinData; override;
    procedure BeginUpdateItems;
    procedure EndUpdateItems;
  published
    property ItemLayout: TspButtonLayout read FItemLayout write SetItemLayout;
    property ItemMargin: Integer read FItemMargin write SetItemMargin;
    property ItemSpacing: Integer read FItemSpacing write SetItemSpacing;
    property HeaderLeftAlignment: Boolean
     read FHeaderLeftAlignment write SetHeaderLeftAlignment;
    property HeaderSkinDataName: String
     read FHeaderSkinDataName write FHeaderSkinDataName;
    property ItemSkinDataName: String
      read FItemSkinDataName write FItemSkinDataName;
    property Items:  TspSkinGridViewItems read FItems write SetItems;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemHeight: Integer
      read FItemHeight write SetItemHeight;
    property ItemWidth: Integer
      read FItemWidth write SetItemWidth;
    property HeaderHeight: Integer
      read FHeaderHeight write SetHeaderHeight;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property MouseMoveChangeIndex: Boolean
      read FMouseMoveChangeIndex write FMouseMoveChangeIndex;  
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property TabStop;
    property Font;
    property ParentBiDiMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnDrawItem: TspDrawSkinOfficeItemEvent
      read FOnDrawItem write FOnDrawItem;
    property OnItemClick: TNotifyEvent
      read FOnItemClick write FOnItemClick;
    property OnClick;
    property OnContextPopup;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;                     
       
implementation

  Uses ShellAPI;

  
const
  DEF_GAUGE_FRAMES = 10;
  WS_EX_LAYERED = $80000;
  CS_DROPSHADOW_ = $20000;


// TspSkinAnimateGauge

constructor TspSkinAnimateGauge.Create;
begin
  inherited;
  Width := 100;
  Height := 20;
  BeginOffset := 0;
  EndOffset := 0;
  FProgressText := '';
  FShowProgressText := False;
  FSkinDataName := 'gauge';
  FAnimationPause := 1000;
  FAnimationPauseTimer := nil;
  FAnimationTimer := nil;
  FAnimationFrame := 0;
  FCountFrames := 0;
  FImitation := False;
end;

destructor TspSkinAnimateGauge.Destroy;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Free;
  if FAnimationTimer <> nil then FAnimationTimer.Free;
  inherited;
end;

procedure TspSkinAnimateGauge.OnAnimationPauseTimer(Sender: TObject);
begin
  StartInternalAnimation;
end;

procedure TspSkinAnimateGauge.OnAnimationTimer(Sender: TObject);
begin
  Inc(FAnimationFrame);
  if FAnimationFrame > FCountFrames
  then
    StopInternalAnimation;
  RePaint;
end;

procedure TspSkinAnimateGauge.SetAnimationPause;
begin
  if Value >= 0
  then
    FAnimationPause := Value;
end;

procedure TspSkinAnimateGauge.StartInternalAnimation;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Enabled := False;
  FAnimationFrame := 0;
  FAnimationTimer.Enabled := True;
  RePaint;
end;

procedure TspSkinAnimateGauge.StopInternalAnimation;
begin
  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Enabled := True;
  FAnimationTimer.Enabled := False;
  FAnimationFrame := 0;
  RePaint;
end;

procedure TspSkinAnimateGauge.StartAnimation;
begin
  if (FIndex = -1) or ((FIndex <> -1) and
     IsNullRect(Self.AnimationSkinRect))
  then
    begin
      FImitation := True;
      FCountFrames := DEF_GAUGE_FRAMES + 5;
    end
  else
    begin
      FImitation := False;
      if AnimationCountFrames = 1
      then
        FCountFrames :=  (RectWidth(NewProgressArea) + RectWidth(AnimationSkinRect) * 2)
         div (RectWidth(AnimationSkinRect) div 3)
      else
        FCountFrames := AnimationCountFrames;
    end;

  if FAnimationPauseTimer <> nil then FAnimationPauseTimer.Free;
  if FAnimationTimer <> nil then FAnimationTimer.Free;

  FAnimationPauseTimer := TTimer.Create(Self);
  FAnimationPauseTimer.Enabled := False;
  FAnimationPauseTimer.OnTimer := OnAnimationPauseTimer;
  FAnimationPauseTimer.Interval := FAnimationPause;
  FAnimationPauseTimer.Enabled := True;

  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.OnTimer := OnAnimationTimer;
  if FImitation
  then
    FAnimationTimer.Interval := 40
  else
    FAnimationTimer.Interval := Self.AnimationTimerInterval;
  StartInternalAnimation;
end;

procedure TspSkinAnimateGauge.StopAnimation;
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
  RePaint;  
end;


procedure TspSkinAnimateGauge.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
end;

procedure TspSkinAnimateGauge.DrawProgressText;
var
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

  S := '';
  if FShowProgressText then S := S + FProgressText;
  if S = '' then Exit;
  with C do
  begin
    TX := Width div 2 - TextWidth(S) div 2;
    TY := Height div 2 - TextHeight(S) div 2;
    Brush.Style := bsClear;
    TextOut(TX, TY, S);
  end;
end;

procedure TspSkinAnimateGauge.SetShowProgressText;
begin
  FShowProgressText := Value;
  RePaint;
end;

procedure TspSkinAnimateGauge.SetProgressText;
begin
  FProgressText := Value;
  RePaint;
end;

procedure TspSkinAnimateGauge.CalcSize;
var
  Offset: Integer;
  W1, H1: Integer;
begin
  inherited;
  if ResizeMode > 0
  then
    begin
      Offset := W - RectWidth(SkinRect);
      NewProgressArea := ProgressArea;
      Inc(NewProgressArea.Right, Offset);
     end
  else
    NewProgressArea := ProgressArea;

  if (FIndex <> -1) and not IsNullRect(AnimationSkinRect) and
     (Self.AnimationCountFrames = 1)
   then
     begin
       FCountFrames :=  (RectWidth(NewProgressArea) + RectWidth(AnimationSkinRect) * 2)
       div (RectWidth(AnimationSkinRect) div 3);
       if (FAnimationTimer <> nil) and FAnimationTimer.Enabled
       then
         if FAnimationFrame > FCountFrames then  FAnimationFrame := 1;
     end;
end;

function TspSkinAnimateGauge.GetAnimationFrameRect;
var
  fs: Integer;
begin
  if RectWidth(AnimationSkinRect) > RectWidth(AnimationSkinRect)
  then
    begin
      fs := RectWidth(AnimationSkinRect) div AnimationCountFrames;
      Result := Rect(AnimationSkinRect.Left + (FAnimationFrame - 1) * fs,
                 AnimationSkinRect.Top,
                 AnimationSkinRect.Left + FAnimationFrame * fs,
                 AnimationSkinRect.Bottom);
    end
  else
    begin
      fs := RectHeight(AnimationSkinRect) div AnimationCountFrames;
      Result := Rect(AnimationSkinRect.Left,
                     AnimationSkinRect.Top + (FAnimationFrame - 1) * fs,
                     AnimationSkinRect.Right,
                     AnimationSkinRect.Top + FAnimationFrame * fs);
    end;
end;

function TspSkinAnimateGauge.CalcProgressRect: TRect;
var
  R: TRect;
  FrameWidth: Integer;
begin
  R.Top := NewProgressArea.Top;
  R.Bottom := R.Top + RectHeight(ProgressRect);
  FrameWidth := Width div DEF_GAUGE_FRAMES;
  R.Left := NewProgressArea.Left + (FAnimationFrame - 1) * FrameWidth - 3 * FrameWidth;
  R.Right := R.Left + FrameWidth;
  Result := R;
end;

procedure TspSkinAnimateGauge.CreateControlSkinImage;
var
  Buffer: TBitMap;
  R, R1: TRect;
  X, Y: Integer;
  XStep: Integer;
begin
  inherited;
  if (FAnimationTimer = nil) or (FCountFrames = 0) or (FAnimationFrame = 0)
  then
    begin
      if ShowProgressText then DrawProgressText(B.Canvas);
      Exit;
    end;
  if FImitation
  then
    begin
      R := CalcProgressRect;
      R.Left := R.Left - RectWidth(R) div 2;
      R.Right := R.Right + RectWidth(R) div 2;
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      CreateHSkinImage(BeginOffset, EndOffset, Buffer, Picture, ProgressRect,
                  Buffer.Width, Buffer.Height, ProgressStretch);
      if ProgressTransparent
      then
        begin
          Buffer.Transparent := True;
          Buffer.TransparentMode := tmFixed;
          Buffer.TransparentColor := ProgressTransparentColor;
        end;
      IntersectClipRect(B.Canvas.Handle,
        NewProgressArea.Left, NewProgressArea.Top,
        NewProgressArea.Right, NewProgressArea.Bottom);
      B.Canvas.Draw(R.Left, R.Top, Buffer);
      if ShowProgressText then DrawProgressText(B.Canvas);
      Buffer.Free;
    end
  else
  if not FImitation and (AnimationCountFrames > 1)
  then
    begin
      R := NewProgressArea;
      R1 := GetAnimationFrameRect;
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      CreateHSkinImage(AnimationBeginOffset,
        AnimationEndOffset, Buffer, Picture, R1,
          Buffer.Width, Buffer.Height, True);
      IntersectClipRect(B.Canvas.Handle,
        NewProgressArea.Left, NewProgressArea.Top,
        NewProgressArea.Right, NewProgressArea.Bottom);
      B.Canvas.Draw(R.Left, R.Top, Buffer);
      if ShowProgressText then DrawProgressText(B.Canvas);
      Buffer.Free;
    end
  else
  if not FImitation and (AnimationCountFrames = 1)
  then
    begin
      FCountFrames :=  (RectWidth(NewProgressArea) + RectWidth(AnimationSkinRect) * 2)
         div (RectWidth(AnimationSkinRect) div 3);
      if FAnimationFrame > FCountFrames then  FAnimationFrame := 1;
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(AnimationSkinRect);
      Buffer.Height := RectHeight(AnimationSkinRect);
      Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Picture.Canvas,
       AnimationSkinRect);
      XStep := RectWidth(AnimationSkinRect) div 3;
      X := NewProgressArea.Left +  XStep * (FAnimationFrame - 1) -
        RectWidth(AnimationSkinRect);
      Y := NewProgressArea.Top;
      IntersectClipRect(B.Canvas.Handle,
        NewProgressArea.Left, NewProgressArea.Top,
        NewProgressArea.Right, NewProgressArea.Bottom);
      B.Canvas.Draw(X, Y, Buffer);
      if ShowProgressText then DrawProgressText(B.Canvas);
      Buffer.Free;
    end;
end;

procedure TspSkinAnimateGauge.CreateImage;
begin
  CreateSkinControlImage(B, Picture, SkinRect);
end;

procedure TspSkinAnimateGauge.CreateControlDefaultImage(B: TBitMap);
var
  R, PR: TRect;
  V: Integer;
begin
  R := ClientRect;
  B.Canvas.Brush.Color := clWindow;
  B.Canvas.FillRect(R);
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  DrawProgressText(B.Canvas);
end;

procedure TspSkinAnimateGauge.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinGaugeControl
    then
      with TspDataSkinGaugeControl(FSD.CtrlList.Items[FIndex]) do
      begin
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
        Self.AnimationSkinRect := AnimationSkinRect;
        Self.AnimationCountFrames := AnimationCountFrames;
        Self.AnimationTimerInterval := AnimationTimerInterval;
        Self.AnimationBeginOffset := AnimationBeginOffset;
        Self.AnimationEndOffset := AnimationEndOffset;
      end;
end;

procedure TspSkinAnimateGauge.ChangeSkinData;
var
  FAnimation: Boolean;
begin
  FAnimation := FAnimationTimer <> nil;
  if FAnimation then StopAnimation;
  inherited;
  if FAnimation then StartAnimation;
end;

// ===================== TpSkinWaveLabel ==================== //

constructor TspSkinWaveLabel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque];
  FSkinDataName := 'stdlabel';
  Width := 200;
  Height := 40;
  //
  Font.Name := 'Tahoma';
  Font.Size := 15;
  Font.Style := [fsBold];
  //
  FAntialiasing := True;
  FXDiv := 20;
  FYDiv := 20;
  FRatioVal := 5;
  FUseSkinColor := True;
  FAlignment := taCenter;
end;

procedure TspSkinWaveLabel.WMMOVE;
begin
  inherited;
  if not AlphaBlend then RePaint;
end;

procedure TspSkinWaveLabel.Paint;
var
  MaskBuffer: TBitMap;
  FXMaskBuffer: TspEffectBmp;
  TX, TY: Integer;
  ParentImage: TBitMap;
  FXBuffer: TspEffectBmp;
  C: TColor;
begin
  if (Width < 1) or (Height < 1) then Exit;
  // create mask
  MaskBuffer := TBitMap.Create;
  MaskBuffer.Width := Width;
  MaskBuffer.Height := Height;
  with MaskBuffer.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect(Rect(0, 0, Width, Height));
    Font.Assign(Self.Font);
    Font.Color := clBlack;
    case Alignment of
      taLeftJustify: TX := 10;
      taCenter:  TX := Width div 2 - TextWidth(Caption) div 2;
      taRightJustify: TX := Width - 10 - TextWidth(Caption);
    end;
    TY := Height div 2 - TextHeight(Caption) div 2;
    if TX < 0 then TX := 0;
    if TY < 0 then TY := 0;
    Canvas.Brush.Style := bsClear;
    TextOut(TX, TY, Caption);
  end;
  FXMaskBuffer := TspEffectBmp.CreateFromhWnd(MaskBuffer.Handle);
  MaskBuffer.Free;
  // create parent image
  ParentImage := TBitMap.Create;
  ParentImage.Width := Width;
  ParentImage.Height := Height;
  GetParentImage(Self, ParentImage.Canvas);
  FXBuffer := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
  ParentImage.Free;
  // add effects
  FXMaskBuffer.Wave(FXDiv, FYDiv, FRatioVal);
  //
  GetSkinData;
  if FUseSkinColor and (SkinData <> nil) and (not SkinData.Empty) and (FIndex <> -1)
  then
    begin
      if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinStdLabelControl
      then
        C := TspDataSkinStdLabelControl(FSD.CtrlList.Items[FIndex]).FontColor
      else
        C := Font.Color;
     end
  else
    C := Font.Color;
  //
  if FAlphaBlend
  then
    FXBuffer.MaskFillColor(FXMaskBuffer, C, FAlphaBlendValue / 255)
  else
    FXBuffer.MaskFillColor(FXMaskBuffer, C, 1);
  if FAntialiasing
  then
    FXBuffer.MaskAntialiasing(FXMaskBuffer, 1);
  FXBuffer.Draw(Canvas.Handle, 0, 0);
  //
  FXBuffer.Free;
  FXMaskBuffer.Free;
end;

procedure TspSkinWaveLabel.CMTextChanged;
begin
  inherited;
  RePaint;
end;

procedure TspSkinWaveLabel.SetXDiv;
begin
  FXDiv := Value;
  RePaint;
end;

procedure TspSkinWaveLabel.SetYDiv;
begin
  FYDiv := Value;
  RePaint;
end;


procedure TspSkinWaveLabel.SetRatioVal;
begin
  FRatioVal := Value;
  RePaint;
end;

procedure TspSkinWaveLabel.SetAntialiasing;
begin
  FAntialiasing := Value;
  RePaint;
end;

procedure TspSkinWaveLabel.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  RePaint;
end;

{TspSkinButtonEx}

constructor TspSkinButtonEx.Create(AOwner: TComponent); 
begin
  inherited;
  FTitle := 'Title';
  Width := 100;
  Height := 50;
  FTitleAlignment := taLeftJustify;
  FSkinDataName := 'resizebutton';
  FGlowEffect := False;
  FGlowSize := 3;
end;

procedure TspSkinButtonEx.SetTitle(Value: String);
begin
  if FTitle <> Value
  then
    begin
      FTitle := Value;
      RePaint;
    end;  
end;

procedure TspSkinButtonEx.SetTitleAlignment(Value: TAlignment);
begin
  if FTitleAlignment <> Value
  then
    begin
      FTitleAlignment := Value;
      RePaint;
   end;
end;

procedure TspSkinButtonEx.CreateButtonImage;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  S: String;
  FDrawDefault: Boolean;
  NewClRect2: TRect;
  TR: TRect;
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
      B.Canvas.DrawFocusRect(NewClRect);
      B.Canvas.Brush.Style := bsClear;
    end;

  FDrawDefault := True;

  NewClRect2 := NewClRect;
  if FTitle <> ''
  then
    begin
      B.Canvas.Font.Style := B.Canvas.Font.Style + [fsBold];
      TR := NewClRect;
      if FTitleAlignment = taLeftJustify
      then
        begin
          Inc(TR.Top, 2);
          Inc(TR.Left, 2);
        end
      else
      if FTitleAlignment = taRightJustify
      then
        begin
          Inc(TR.Top, 2);
          Dec(TR.Right, 2);
        end;
      TR.Bottom := TR.Top + B.Canvas.TextHeight(FTitle);
      B.Canvas.Brush.Style := bsClear;
      DrawText(B.Canvas.Handle, PChar(FTitle), Length(FTitle), TR,
        DT_EXPANDTABS or Alignments[FTitleAlignment]);
      Inc(NewClRect2.Top, B.Canvas.TextHeight(FTitle));
      B.Canvas.Font.Style := B.Canvas.Font.Style - [fsBold];
    end;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, NewClRect2, ADown, AMouseIn, FDrawDefault);

  if FDrawDefault then
  
  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      if FGlowEffect and AMouseIn
      then
       DrawImageAndTextGlow2(B.Canvas, NewClRect2, FMargin, FSpacing, FLayout,
         S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
          False, Enabled, False, 0,
          FSD.SkinColors.cHighLight,
          FGlowSize)
      else
        DrawImageAndText2(B.Canvas, NewClRect2, FMargin, FSpacing, FLayout,
         S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
          False, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      if FGlowEffect and AMouseIn
      then
        DrawImageAndTextGlow2(B.Canvas, NewClRect2, FMargin, FSpacing, FLayout,
         Caption, FImageIndex, FImageList,
         False, Enabled, False, 0,
         FSD.SkinColors.cHighLight,
         FGlowSize)
      else
      DrawImageAndText2(B.Canvas, NewClRect2, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        False, Enabled, False, 0);
    end
  else
    begin
      if FGlowEffect and AMouseIn
      then
        DrawGlyphAndTextGlow2(B.Canvas,
         NewClRect2, FMargin, FSpacing, FLayout,
         Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False, False, 0,
         FSD.SkinColors.cHighLight,
         FGlowSize)
      else
      DrawGlyphAndText2(B.Canvas,
       NewClRect2, FMargin, FSpacing, FLayout,
        Caption, FGlyph, FNumGlyphs, GetGlyphNum(ADown, AMouseIn), False, False, 0);
    end;

end;


procedure TspSkinButtonEx.CreateControlDefaultImage;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  R, TR: TRect;
  IsDown: Boolean;
  S: String;
  FDrawDefault: Boolean;
  ClientRect2: TRect;
begin
  IsDown := False;
  R := ClientRect;
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

  B.Canvas.Font.Assign(FDefaultFont);
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;
    
  if not Enabled then B.Canvas.Font.Color := clBtnShadow;

  FDrawDefault := True;

  ClientRect2 := ClientRect;

  if FTitle <> ''
  then
    begin
      B.Canvas.Font.Style := B.Canvas.Font.Style + [fsBold];
      TR := ClientRect;
      if FTitleAlignment = taLeftJustify
      then
        begin
          Inc(TR.Top, 2);
          Inc(TR.Left, 2);
        end
      else
      if FTitleAlignment = taRightJustify
      then
        begin
          Inc(TR.Top, 2);
          Dec(TR.Right, 2);
        end;
      if FDown and FMouseIn
      then
        begin
          Inc(TR.Top);
          Inc(TR.Left);
        end;
      TR.Bottom := TR.Top + B.Canvas.TextHeight(FTitle);
      B.Canvas.Brush.Style := bsClear;
      DrawText(B.Canvas.Handle, PChar(FTitle), Length(FTitle), TR,
        DT_EXPANDTABS or Alignments[FTitleAlignment]);
      Inc(ClientRect2.Top, B.Canvas.TextHeight(FTitle));
      B.Canvas.Font.Style := B.Canvas.Font.Style - [fsBold];
    end;

  if Assigned(FOnPaint)
  then
    FOnPaint(Self, B.Canvas, ClientRect2, FDown, FMouseIn, FDrawDefault);

  if FDrawDefault then

  if (FSkinImagesMenu <> nil) and (FSkinImagesMenu.SelectedItem <> nil) and
      FUseImagesMenuImage
  then
    begin
      if FUseImagesMenuCaption
      then
        S := FSkinImagesMenu.SelectedItem.Caption
      else
        S := Caption;
      DrawImageAndText2(B.Canvas, ClientRect2, FMargin, FSpacing, FLayout,
        S, FSkinImagesMenu.SelectedItem.ImageIndex, FSkinImagesMenu.Images,
        FDown and FMouseIn, Enabled, False, 0);
    end
  else
  if (FImageList <> nil) and (FImageIndex >= 0) and
     (FImageIndex < FImageList.Count)
  then
    begin
      DrawImageAndText2(B.Canvas, ClientRect2, FMargin, FSpacing, FLayout,
        Caption, FImageIndex, FImageList,
        FDown and FMouseIn, Enabled, False, 0);
    end
  else
    DrawGlyphAndText2(B.Canvas,
    ClientRect2, FMargin, FSpacing, FLayout,
    Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), IsDown, False, 0);
end;

{ TspSkinShadowLabel }

constructor TspSkinShadowLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque] + [csReplicatable];
  Width := 65;
  Height := 17;
  FAutoSize := True;
  FShowAccelChar := True;
  FDoubleBuffered := False;
  FShadowColor := clBlack;
  FShadowOffset := 0;
  FShadowSize := 2;
end;


procedure TspSkinShadowLabel.SetShadowColor(Value: TColor);
begin
  if Value <> FShadowColor
  then
    begin
      FShadowColor := Value;
      RePaint;
    end;
end;

procedure TspSkinShadowLabel.SetShadowSize(Value: Integer);
begin
  if (Value <> FShadowSize) and (Value > 0) and (Value < 11)
  then
    begin
      FShadowSize := Value;
      RePaint;
    end;
end;

procedure TspSkinShadowLabel.SetShadowOffset(Value: Integer);
begin
  if (Value <> FShadowOffset) and (Value >= 0) and (Value < 101)
  then
    begin
      FShadowOffset := Value;
      RePaint;
    end;
end;

procedure TspSkinShadowLabel.SetDoubleBuffered;
begin
  if Value <> FDoubleBuffered
  then
    begin
      FDoubleBuffered := Value;
      if FDoubleBuffered
      then ControlStyle := ControlStyle + [csOpaque]
      else ControlStyle := ControlStyle - [csOpaque];
    end;
end;

function TspSkinShadowLabel.GetLabelText: string;
begin
  Result := Caption;
end;

procedure TspSkinShadowLabel.WMMOVE;
begin
  inherited;
  if FDoubleBuffered then RePaint;
end;

procedure TspSkinShadowLabel.DoDrawText(Cnvs: TCanvas; var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Windows.DrawText(Cnvs.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TspSkinShadowLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Text: string;
  Flags: Longint;
  R: TRect;
  FBuffer: TspBitmap;
begin
  //
  Canvas.Font := Self.Font;
  //
  Text := GetLabelText;
  R := Rect(FShadowSize - FShadowOffset, FShadowSize - FShadowOffset,
            Width - FShadowSize - FShadowOffset, Height - FShadowSize - FShadowOffset);
  if R.Left < 0 then R.Left := 0;
  if R.Top < 0 then R.Top := 0;
  Flags := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  if FDoubleBuffered
  then
    begin
      FBuffer := TspBitmap.Create;
      FBuffer.SetSize(Width, Height);
      GetParentImage(Self, FBuffer.Canvas);
      FBuffer.Canvas.Font := Self.Font;
      DrawEffectText(FBuffer.Canvas, R, Text, Flags, FShadowOffset, FShadowColor, FShadowSize);
      FBuffer.Draw(Canvas.Handle, 0, 0);
      FBuffer.Free;
    end
  else
    DrawEffectText(Canvas, R, Text, Flags, FShadowOffset, FShadowColor, FShadowSize);
end;

procedure TspSkinShadowLabel.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TspSkinShadowLabel.AdjustBounds;
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
    Canvas.Font := Self.Font;
    Rect := ClientRect;
    DC := GetDC(0);
    Canvas.Handle := DC;
    DoDrawText(Canvas, Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    X := Left;
    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
    if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
    Rect.Right := Rect.Right + FShadowOffset + FShadowSize * 2 + 8;
    Rect.Bottom := Rect.Bottom + FShadowOffset + FShadowSize * 2 + 8;
    SetBounds(X, Top, Rect.Right, Rect.Bottom);
  end;
end;

procedure TspSkinShadowLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RePaint;
  end;
end;

procedure TspSkinShadowLabel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TspSkinShadowLabel.SetFocusControl(Value: TWinControl);
begin
  FFocusControl := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TspSkinShadowLabel.SetShowAccelChar(Value: Boolean);
begin
  if FShowAccelChar <> Value then
  begin
    FShowAccelChar := Value;
    RePaint;
  end;
end;

procedure TspSkinShadowLabel.SetLayout(Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RePaint;
  end;
end;

procedure TspSkinShadowLabel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    AdjustBounds;
    RePaint;
  end;
end;

procedure TspSkinShadowLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TspSkinShadowLabel.CMTextChanged(var Message: TMessage);
begin
  AdjustBounds;
  RePaint;
end;

procedure TspSkinShadowLabel.CMFontChanged(var Message: TMessage);
begin
  AdjustBounds;
  RePaint;
end;

procedure TspSkinShadowLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FFocusControl <> nil) and Enabled and ShowAccelChar and
    IsAccel(Message.CharCode, Caption) then
    with FFocusControl do
      if CanFocus then
      begin
        SetFocus;
        Message.Result := 1;
      end;
end;

procedure TspSkinShadowLabel.ChangeSkinData;
begin
  inherited;
  if (FSD <> nil) and (not FSD.Empty)
  then
    begin
      Font.Color := FSD.SkinColors.cBtnText;
      ShadowColor := Darker(FSD.SkinColors.cBtnFace, 80);
      RePaint;
    end;
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

procedure TspFrameSkinControl.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Msg.DC);
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
  if not FDefaultImage.Empty
  then
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
  if not FDefaultImage.Empty
  then
    SetBounds(Left, Top, FrameW, FrameH);
  RePaint;
end;

procedure TspFrameSkinControl.SetDefaultFramesPlacement;
begin
  FDefaultFramesPlacement := Value;
  CalcDefaultFrameSize;
  if not FDefaultImage.Empty
  then
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
      if not FDefaultImage.Empty
      then
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

procedure TspSkinFrameRegulator.CalcRoundValue;
var
  Offset: Integer;
  Plus: Boolean;
  FW: Integer;
  FC: Integer;
  OffsetCount: Integer;
begin
  if (FIndex = -1) and not FDefaultImage.Empty then CalcDefaultFrameSize;
  if FramesCount - 1 > 0 then FC := FramesCount - 1 else FC := 1;

  FPixInc := 360 div FC;
  FValInc := (FMaxValue - FMinValue) div FC;

  if FPixInc = 0 then FPixInc := 1;
  if FValInc = 0 then FValInc := 1;

  if Abs(CurV - OldCurV) > 300
  then
    begin
      StartV := CurV;
      Offset := FPixInc;
      Plus := CurV < OldCurV
    end
  else
    begin
      Plus := CurV >= StartV;
      if Plus
      then Offset := CurV - StartV
      else Offset := StartV - CurV;
    end;

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
    rkRound:
      begin
        StartV := GetRoundValue(X, Y);
        OldCurV := StartV;
      end;
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

function TspSkinFrameRegulator.GetRoundValue(X, Y: Integer): Integer;
var
  CX, CY: Integer;
  X1, Y1: Integer;
  midAngle: Integer;
  sinMidAngle, MidAngle1: Double;
begin
  CX := Width div 2;
  CY := Height div 2;
  X1 := CX - X;
  Y1 := CY - Y;
  if (X <= CX) and (Y < CY) then midAngle := 90;
  if (X < CX) and (Y >= CY) then midAngle := 180;
  If (X >= CX) and (Y > CY) then midAngle := 270;
  If (X > CX) and (Y <= CY) Then midAngle := 0;
  if (midAngle = 0) or (midAngle = 180)
  then sinMidAngle := Abs(Trunc(Y1))/(Sqrt(Sqr(X1)+Sqr(Y1)));
  if (midAngle = 90) or (midAngle = 270)
  then sinMidAngle:= Abs(Trunc(X1))/(Sqrt(Sqr(X1)+Sqr(Y1)));
  midAngle1 := ArcTan(sinMidAngle/Sqrt(1-sqr(sinMidAngle)));
  midAngle1 := (midAngle1/Pi) * 180;
  midAngle := Trunc(midAngle + midAngle1);
  Result := 270 - MidAngle;
  if Result < 0 then Result := Result + 360;
end;

procedure TspSkinFrameRegulator.MouseMove;
begin
  if FDown and ((FIndex <> -1) or ((FIndex = -1) and not FDefaultImage.Empty))
  then
    begin
      case Kind of
        rkRound: CurV := GetRoundValue(X, Y);
        rkVertical: CurV := -Y;
        rkHorizontal: CurV := X;
      end;
      if Kind = rkRound then CalcRoundValue else CalcValue;
      OldCurV := CurV;
    end;
  inherited;
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
     Caption, FGlyph, FNumGlyphs, GetGlyphNum(FDown, FMouseIn), IsDown, False, 0);
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


constructor TspSkinLinkImage.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Cursor := crHandPoint;
end;

procedure TspSkinLinkImage.Click;
begin
  inherited Click;
  if FURL <> ''
  then
    ShellExecute(0, 'open', PChar(FURL), nil, nil, SW_SHOWNORMAL);
end;

constructor TspSkinLinkLabel.Create;
begin
  inherited;
  FGlowEffect := False;
  FGlowSize := 7;
  FUseUnderLine := True;
  FIndex := -1;
  Transparent := True;
  FSD := nil;
  FSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Height := 13;
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

procedure TspSkinLinkLabel.SetUseUnderLine;
begin
  if FUseUnderLine <> Value
  then
    begin
      FUseUnderLine := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
  GlowColor: TColor;
  R: TRect;
begin
  GetSkinData;

  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);

  R := Rect;
  if FGlowEffect
  then
    OffsetRect(R, 0, FGlowSize);

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
          if FUseUnderLine
          then
            Style := Style + [fsUnderLine]
          else
            Style := Style - [fsUnderLine];
        end
      else
        begin
          Canvas.Font := Self.Font;
          if FUseUnderLine
          then
            Style := Style + [fsUnderLine]
          else
            Style := Style - [fsUnderLine];
        end;  
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Charset := SkinData.ResourceStrData.CharSet
      else
        CharSet := FDefaultFont.Charset;
      if FMouseIn and not FGlowEffect
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

  if FIndex <> -1
  then
    begin
      GlowColor := ActiveFontColor;
    end
  else
    begin
      GlowColor := FDefaultActiveFontColor;
    end;

  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    if FIndex <> -1
    then
      Canvas.Font.Color := FSD.SkinColors.cBtnHighLight
    else
      Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
    OffsetRect(Rect, -1, -1);
    if FIndex <> -1
    then
      Canvas.Font.Color := FSD.SkinColors.cBtnShadow
    else
      Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  end
  else
    begin
      if FUseUnderLine
      then
        Canvas.Font.Style := Canvas.Font.Style + [fsUnderLine]
      else
        Canvas.Font.Style := Canvas.Font.Style - [fsUnderLine];
      if FMouseIn and FGlowEffect
      then
        DrawEffectText2(Canvas, R, Text, Flags, 0, GlowColor, FGlowSize)
      else
        DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
    end;
end;


procedure TspSkinLinkLabel.Click;
begin
  inherited;
  if FURL <> ''
  then
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


// TspSkinComboBoxEx ==========================================================

constructor TspSkinOfficeItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FHeader := False;
  FImageIndex := -1;
  FCaption := '';
  FTitle := '';
  FEnabled := True;
  FChecked := False;
  if TspSkinOfficeItems(Collection).OfficeListBox.ItemIndex = Self.Index
  then
    Active := True
  else
    Active := False;
end;

procedure TspSkinOfficeItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinOfficeItem then
  begin
    FImageIndex := TspSkinOfficeItem(Source).ImageIndex;
    FCaption := TspSkinOfficeItem(Source).Caption;
    FTitle := TspSkinOfficeItem(Source).Title;
    FEnabled := TspSkinOfficeItem(Source).Enabled;
    FChecked := TspSkinOfficeItem(Source).Checked;
    FHeader := TspSkinOfficeItem(Source).Header;
  end
  else
    inherited Assign(Source);
end;

procedure TspSkinOfficeItem.SetChecked;
begin
  FChecked := Value;
  Changed(False);
end;


procedure TspSkinOfficeItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspSkinOfficeItem.SetCaption(const Value: String);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TspSkinOfficeItem.SetHeader(Value: Boolean);
begin
  FHeader := Value;
  Changed(False);
end;

procedure TspSkinOfficeItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  Changed(False);
end;

procedure TspSkinOfficeItem.SetTitle(const Value: String);
begin
  FTitle := Value;
  Changed(False);
end;

procedure TspSkinOfficeItem.SetData(const Value: Pointer);
begin
  FData := Value;
end;

constructor TspSkinOfficeItems.Create;
begin
  inherited Create(TspSkinOfficeItem);
  OfficeListBox := AListBox;
end;

function TspSkinOfficeItems.GetOwner: TPersistent;
begin
  Result := OfficeListBox;
end;

procedure  TspSkinOfficeItems.Update(Item: TCollectionItem);
begin
  OfficeListBox.Repaint;
  OfficeListBox.UpdateScrollInfo;
end; 

function TspSkinOfficeItems.GetItem(Index: Integer):  TspSkinOfficeItem;
begin
  Result := TspSkinOfficeItem(inherited GetItem(Index));
end;

procedure TspSkinOfficeItems.SetItem(Index: Integer; Value:  TspSkinOfficeItem);
begin
  inherited SetItem(Index, Value);
  OfficeListBox.RePaint;
end;

function TspSkinOfficeItems.Add: TspSkinOfficeItem;
begin
  Result := TspSkinOfficeItem(inherited Add);
  OfficeListBox.RePaint;
end;

function TspSkinOfficeItems.Insert(Index: Integer): TspSkinOfficeItem;
begin
  Result := TspSkinOfficeItem(inherited Insert(Index));
  OfficeListBox.RePaint;
end;

procedure TspSkinOfficeItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  OfficeListBox.RePaint;
end;

procedure TspSkinOfficeItems.Clear;
begin
  inherited Clear;
  OfficeListBox.RePaint;
end;

constructor TspSkinOfficeListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csAcceptsControls];
  FInUpdateItems := False;
  FCheckOffset := 0;
  FClicksDisabled := False;
  FShowCheckBoxes := False;
  FHeaderLeftAlignment := False;
  FMouseMoveChangeIndex := False;
  FMouseDown := False;
  FShowLines := False;
  FMouseActive := -1;
  ScrollBar := nil;
  FScrollOffset := 0;
  FItems := TspSkinOfficeItems.Create(Self);
  FImages := nil;
  Width := 150;
  Height := 150;
  FItemHeight := 30;
  FHeaderHeight := 20;
  FItemSkinDataName := 'listbox';
  FSkinDataName := 'listbox';
  FHeaderSkinDataName := 'menuheader';
  FShowItemTitles := True;
  FMax := 0;
  FRealMax := 0;
  FOldHeight := -1;
  FItemIndex := -1;
  FDisabledFontColor := clGray;
end;

destructor TspSkinOfficeListBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinOfficeListBox.SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
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


procedure TspSkinOfficeListBox.SetShowCheckBoxes;
begin
  if FShowCheckBoxes <> Value
  then
    begin
      FShowCheckBoxes := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.BeginUpdateItems;
begin
  FInUpdateItems := True;
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TspSkinOfficeListBox.EndUpdateItems;
begin
  FInUpdateItems := False;
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  RePaint;
  UpdateScrollInfo;
end;

function TspSkinOfficeListBox.CalcHeight;
var
  H: Integer;
begin
  if AItemCount > FItems.Count then AItemCount := FItems.Count;
  H := AItemCount * ItemHeight;
  if FIndex = -1
  then
    begin
      H := H + 5;
    end
  else
    begin
      H := H + Height - RectHeight(RealClientRect) + 1;
    end;
  Result := H;  
end;

procedure TspSkinOfficeListBox.SetHeaderLeftAlignment(Value: Boolean);
begin
  if FHeaderLeftAlignment <> Value
  then
    begin
      FHeaderLeftAlignment := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.SetShowLines;
begin
  if FShowLines <> Value
  then
    begin
      FShowLines := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.ChangeSkinData;
var
  CIndex: Integer;
begin
  inherited;
  //
  if SkinData <> nil
  then
    CIndex := SkinData.GetControlIndex('edit');
  if CIndex = -1
  then
    FDisabledFontColor := SkinData.SkinColors.cBtnShadow
  else
    FDisabledFontColor := TspDataSkinEditControl(SkinData.CtrlList[CIndex]).DisabledFontColor;
  //
  if ScrollBar <> nil
  then
    begin
      ScrollBar.SkinData := SkinData;
      AdjustScrollBar;
    end;
  CalcItemRects;
  RePaint;
end;

procedure TspSkinOfficeListBox.SetItemHeight(Value: Integer);
begin
  if FItemHeight <> Value
  then
    begin
      FItemHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.SetHeaderHeight(Value: Integer);
begin
  if FHeaderHeight <> Value
  then
    begin
      FHeaderHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.SetItems(Value: TspSkinOfficeItems);
begin
  FItems.Assign(Value);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinOfficeListBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TspSkinOfficeListBox.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Images) then
   FImages := nil;
end;

procedure TspSkinOfficeListBox.SetShowItemTitles(Value: Boolean);
begin
  if FShowItemTitles <> Value
  then
    begin
      FShowItemTitles := Value;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.DrawItem;
var
  Buffer: TBitMap;
  R: TRect;
begin
  if FIndex <> -1
  then
    SkinDrawItem(Index, Cnvs)
  else
    DefaultDrawItem(Index, Cnvs);
end;

procedure TspSkinOfficeListBox.CreateControlDefaultImage(B: TBitMap);
var
  I, SaveIndex: Integer;
  R: TRect;
begin
  //
  R := Rect(0, 0, Width, Height);
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  InflateRect(R, -1, -1);
  with B.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(R);
  end;
  //
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinOfficeListBox.CreateControlSkinImage(B: TBitMap);
var
  I, SaveIndex: Integer;
begin
  inherited;
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinOfficeListBox.CalcItemRects;
var
  I: Integer;
  X, Y, W, H: Integer;
begin
  FRealMax := 0;
  if FIndex <> -1
  then
    FItemsRect := RealClientRect
  else
    FItemsRect := Rect(2, 2, Width - 2, Height - 2);
  if ScrollBar <> nil then Dec(FItemsRect.Right, ScrollBar.Width);  
  X := FItemsRect.Left;
  Y := FItemsRect.Top;
  W := RectWidth(FItemsRect);
  for I := 0 to FItems.Count - 1 do
    with TspSkinOfficeItem(FItems[I]) do
    begin
      if not Header then H := ItemHeight else H := HeaderHeight;
      ItemRect := Rect(X, Y, X + W, Y + H);
      OffsetRect(ItemRect, 0, - FScrollOffset);
      IsVisible := RectToRect(ItemRect, FItemsRect);
      if not IsVisible and (ItemRect.Top <= FItemsRect.Top) and
        (ItemRect.Bottom >= FItemsRect.Bottom)
      then
        IsVisible := True;
      if IsVisible then FRealMax := ItemRect.Bottom;
      Y := Y + H;
    end;
  FMax := Y;
end;

procedure TspSkinOfficeListBox.Scroll(AScrollOffset: Integer);
begin
  FScrollOffset := AScrollOffset;
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinOfficeListBox.GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
begin
  CalcItemRects;
  AMin := 0;
  AMax := FMax - FItemsRect.Top;
  APage := RectHeight(FItemsRect);
  if AMax <= APage
  then
    begin
      APage := 0;
      AMax := 0;
    end;  
  APosition := FScrollOffset;
end;

procedure TspSkinOfficeListBox.WMSize(var Msg: TWMSize);
begin
  inherited;
  if (FOldHeight <> Height) and (FOldHeight <> -1)
  then
    begin
      CalcItemRects;
      if (FRealMax <= FItemsRect.Bottom) and (FScrollOffset > 0)
      then
        begin
          FScrollOffset := FScrollOffset - (FItemsRect.Bottom - FRealMax);
          if FScrollOffset < 0 then FScrollOffset := 0;
          CalcItemRects;
          Invalidate;
        end;
    end;
  AdjustScrollBar;
  UpdateScrollInfo;
  FOldHeight := Height;
end;

procedure TspSkinOfficeListBox.ScrollToItem(Index: Integer);
var
  R, R1: TRect;
begin
  CalcItemRects;
  R1 := FItems[Index].ItemRect;
  R := R1;
  OffsetRect(R, 0, FScrollOffset);
  if (R1.Top <= FItemsRect.Top)
  then
    begin
      if (Index = 1) and FItems[Index - 1].Header
      then
        FScrollOffset := 0
      else
        FScrollOffset := R.Top - FItemsRect.Top;
      CalcItemRects;
      Invalidate;
    end
  else
  if R1.Bottom >= FItemsRect.Bottom
  then
    begin
      FScrollOffset := R.Top;
      FScrollOffset := FScrollOffset - RectHeight(FItemsRect) + RectHeight(R) -
        Height + FItemsRect.Bottom + 1;
      CalcItemRects;
      Invalidate;
    end;
  UpdateScrollInfo;  
end;

procedure TspSkinOfficeListBox.ShowScrollbar;
begin
  if ScrollBar = nil
  then
    begin
      ScrollBar := TspSkinScrollBar.Create(Self);
      ScrollBar.Visible := False;
      ScrollBar.Parent := Self;
      ScrollBar.DefaultHeight := 0;
      ScrollBar.DefaultWidth := 19;
      ScrollBar.SmallChange := ItemHeight;
      ScrollBar.LargeChange := ItemHeight;
      ScrollBar.SkinDataName := 'vscrollbar';
      ScrollBar.Kind := sbVertical;
      ScrollBar.SkinData := Self.SkinData;
      ScrollBar.OnChange := SBChange;
      AdjustScrollBar;
      ScrollBar.Visible := True;
      RePaint;
    end;
end;

procedure TspSkinOfficeListBox.HideScrollBar;
begin
  if ScrollBar = nil then Exit;
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  RePaint;
end;

procedure TspSkinOfficeListBox.UpdateScrollInfo;
var
  SMin, SMax, SPage, SPos: Integer;
begin
  if FInUpdateItems then Exit;
  GetScrollInfo(SMin, SMax, SPage, SPos);
  if SMax <> 0
  then
    begin
      if ScrollBar = nil then ShowScrollBar;
      ScrollBar.SetRange(SMin, SMax, SPos, SPage);
      ScrollBar.LargeChange := SPage;
    end
  else
  if (SMax = 0) and (ScrollBar <> nil)
  then
    begin
      HideScrollBar;
    end;
end;

procedure TspSkinOfficeListBox.AdjustScrollBar;
var
  R: TRect;
begin
  if ScrollBar = nil then Exit;
  if FIndex = -1
  then
    R := Rect(2, 2, Width - 2, Height - 2)
  else
    R := RealClientRect;
  Dec(R.Right, ScrollBar.Width);
  ScrollBar.SetBounds(R.Right, R.Top, ScrollBar.Width,
   RectHeight(R));
end;

procedure TspSkinOfficeListBox.SBChange(Sender: TObject);
begin
  Scroll(ScrollBar.Position);
end;

procedure TspSkinOfficeListBox.SkinDrawItem(Index: Integer; Cnvs: TCanvas);
var
  ListBoxData: TspDataSkinListBox;
  CheckListBoxData: TspDataSkinCheckListBox;
  CIndex, TX, TY: Integer;
  R, R1, CR: TRect;
  Buffer: TBitMap;
  C: TColor;
  SaveIndex: Integer;
begin
  if  FItems[Index].Header
  then
    begin
      SkinDrawHeaderItem(Index, Cnvs);
      Exit;
    end;

  CIndex := SkinData.GetControlIndex(FItemSkinDataName);
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  InflateRect(R, -2, -2);
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Cnvs.Brush.Style := bsClear;
  //
  if FShowCheckBoxes
  then
    begin
      CIndex := SkinData.GetControlIndex('checklistbox');
      if CIndex <> -1
      then
        begin
          CheckListBoxData := TspDataSkinCheckListBox(SkinData.CtrlList[CIndex])
        end
      else
        CheckListBoxData := nil;
    end;
  //
  if (FDisabledFontColor = ListBoxData.FontColor) and
     (FDisabledFontColor = clBlack)
  then
    FDisabledFontColor := clGray;
  //
  if not FUseSkinFont
  then
    Cnvs.Font.Assign(FDefaultFont)
  else
    with Cnvs.Font, ListBoxData do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  if FItems[Index].Enabled
  then
    begin
      if (FSkinDataName = 'listbox') or
         (FSkinDataName = 'memo')
      then
        Cnvs.Font.Color := ListBoxData.FontColor
      else
        Cnvs.Font.Color := FSD.SkinColors.cBtnText;
    end
  else
    Cnvs.Font.Color := FDisabledFontColor;


  with Cnvs.Font do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
  end;
  //
  if (not FItems[Index].Active) or (not FItems[Index].Enabled)
  then
    with FItems[Index] do
    begin
      SaveIndex := SaveDC(Cnvs.Handle);
      IntersectClipRect(Cnvs.Handle, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom);

    if Assigned(FOnDrawItem)
    then
      begin
        Cnvs.Brush.Style := bsClear;
        FOnDrawItem(Cnvs, Index, R);
      end
    else
     begin
       if FShowCheckBoxes and (CheckListBoxData <> nil)
       then
         begin
           CR := Rect(R.Left, R.Top,
             R.Left + RectWidth(CheckListBoxData.CheckImageRect), R.Bottom);
           CR.Top := CR.Top + RectHeight(CR) div 2 -
            RectHeight(CheckListBoxData.CheckImageRect) div 2;
           if Checked
           then
             SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, CheckListBoxData.CheckImageRect, Cnvs)
           else
             SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, CheckListBoxData.UnCheckImageRect, Cnvs);
           Inc(R.Left, RectWidth(CheckListBoxData.CheckImageRect) + 5);
           FCheckOffset := RectWidth(CheckListBoxData.CheckImageRect) + 5;
         end
      else
        if FShowCheckBoxes and (CheckListBoxData = nil)
        then
         begin
           CR := Rect(R.Left, R.Top,
             R.Left + 12, R.Bottom);
           CR.Top := CR.Top + RectHeight(CR) div 2 - 10 div 2;
           C := Cnvs.Pen.Color;
           if Checked
           then
             DrawCheckImage(Cnvs, CR.Left + 2, CR.Top, FSD.SkinColors.cWindowText);
           Cnvs.Pen.Color := C;
           Inc(R.Left, 14);
           FCheckOffset := 14;
         end;
      if (Title <> '') and FShowItemTitles
      then
        begin
          R1 := R;
          Cnvs.Font.Style := Cnvs.Font.Style + [fsBold];
          R1.Bottom := R1.Top + Cnvs.TextHeight(Title);
          Cnvs.Brush.Style := bsClear;
          DrawText(Cnvs.Handle, PChar(Title), Length(FTitle), R1, DT_LEFT);
          Cnvs.Font.Style := Cnvs.Font.Style - [fsBold];
          R.Top := R1.Bottom;
        end;
        if (FImages <> nil) and (ImageIndex >= 0) and
           (ImageIndex < FImages.Count)
        then
         begin
           DrawImageAndText2(Cnvs, R, 0, 2, blGlyphLeft,
             Caption, FImageIndex, FImages,
             False, Enabled, False, 0);
         end
       else
         begin
           Cnvs.Brush.Style := bsClear;
           if FShowItemTitles
           then
             Inc(R.Left, 10);
           R1 := Rect(0, 0, RectWidth(R), RectHeight(R));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R1,
             DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
           TX := R.Left;
           TY := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
           if TY < R.Top then TY := R.Top;
           R := Rect(TX, TY, TX + RectWidth(R1), TY + RectHeight(R1));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
             DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT);
         end;
      end;   
      if FShowLines
      then
        begin
          C := Cnvs.Pen.Color;
          Cnvs.Pen.Color := SkinData.SkinColors.cBtnShadow;
          Cnvs.MoveTo(FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.LineTo(FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.Pen.Color := C;
        end;
      RestoreDC(Cnvs.Handle, SaveIndex);
    end
  else
    with FItems[Index] do
    begin
      Buffer := TBitMap.Create;
      R := FItems[Index].ItemRect;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      //
      with ListBoxData do
      if Focused
      then
        CreateStretchImage(Buffer, Picture, FocusItemRect, ItemTextRect, True)
      else
        CreateStretchImage(Buffer, Picture, ActiveItemRect, ItemTextRect, True);
      //
     if not FUseSkinFont
     then
       Buffer.Canvas.Font.Assign(FDefaultFont)
     else
       with Buffer.Canvas.Font, ListBoxData do
       begin
         Name := FontName;
         Height := FontHeight;
         Style := FontStyle;
       end;

       if Focused
       then
         Buffer.Canvas.Font.Color := ListBoxData.FocusFontColor
       else
         Buffer.Canvas.Font.Color := ListBoxData.ActiveFontColor;

       with Buffer.Canvas.Font do
       begin
         if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
         then
           Charset := SkinData.ResourceStrData.CharSet
         else
           CharSet := FDefaultFont.Charset;
        end;

       R := Rect(2, 2, Buffer.Width - 2, Buffer.Height - 2);

      if Assigned(FOnDrawItem)
      then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R);
        end
      else
      begin

       if FShowCheckBoxes and (CheckListBoxData <> nil)
       then
         begin
           CR := Rect(R.Left, R.Top,
             R.Left + RectWidth(CheckListBoxData.CheckImageRect), R.Bottom);
           CR.Top := CR.Top + RectHeight(CR) div 2 -
            RectHeight(CheckListBoxData.CheckImageRect) div 2;
           if Checked
           then
             SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, CheckListBoxData.CheckImageRect, Buffer.Canvas)
           else
             SkinDrawCheckImage(CR.Left, CR.Top, Picture.Canvas, CheckListBoxData.UnCheckImageRect, Buffer.Canvas);
           Inc(R.Left, RectWidth(CheckListBoxData.CheckImageRect) + 5);
           FCheckOffset := RectWidth(CheckListBoxData.CheckImageRect) + 5;
         end
       else
        if FShowCheckBoxes and (CheckListBoxData = nil)
        then
         begin
           CR := Rect(R.Left, R.Top,
             R.Left + 12, R.Bottom);
           CR.Top := CR.Top + RectHeight(CR) div 2 - 10 div 2;
           if Checked
           then
             DrawCheckImage(Buffer.Canvas, CR.Left + 2, CR.Top, ListBoxData.ActiveFontColor);
           Inc(R.Left, 14);
           FCheckOffset := 14;
         end;

      if (Title <> '') and FShowItemTitles
      then
        begin
          R1 := R;
          Buffer.Canvas.Font.Style := Cnvs.Font.Style + [fsBold];
          R1.Bottom := R1.Top + Buffer.Canvas.TextHeight(Title);
          Buffer.Canvas.Brush.Style := bsClear;
          DrawText(Buffer.Canvas.Handle, PChar(Title), Length(FTitle), R1, DT_LEFT);
          Buffer.Canvas.Font.Style := Cnvs.Font.Style - [fsBold];
          R.Top := R1.Bottom;
        end;
        if (FImages <> nil) and (ImageIndex >= 0) and
           (ImageIndex < FImages.Count)
        then
         begin
           DrawImageAndText2(Buffer.Canvas, R, 0, 2, blGlyphLeft,
             Caption, FImageIndex, FImages,
             False, Enabled, False, 0);
         end
       else
         begin
           Buffer.Canvas.Brush.Style := bsClear;
           if FShowItemTitles
           then
             Inc(R.Left, 10);
           R1 := Rect(0, 0, RectWidth(R), RectHeight(R));
           DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), R1,
             DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
           TX := R.Left;
           TY := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
           if TY < R.Top then TY := R.Top;
           R := Rect(TX, TY, TX + RectWidth(R1), TY + RectHeight(R1));
           DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), R,
             DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT);
         end;
        end;
      Cnvs.Draw(FItems[Index].ItemRect.Left,
        FItems[Index].ItemRect.Top, Buffer);
      Buffer.Free;
    end;
end;

procedure TspSkinOfficeListBox.DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
var
  R, R1, CR: TRect;
  C, FC: TColor;
  TX, TY: Integer;
  SaveIndex: Integer;
begin
  if FItems[Index].Header
  then
    begin
      C := clBtnShadow;
      FC := clBtnHighLight;
    end
  else
  if FItems[Index].Active
  then
    begin
      C := clHighLight;
      FC := clHighLightText;
     end
  else
    begin
      C := clWindow;
      if FItems[Index].Enabled
      then
        FC := clWindowText
      else
        FC := clGray;  
    end;
  //
  Cnvs.Font := FDefaultFont;
  Cnvs.Font.Color := FC;
  //
  R := FItems[Index].ItemRect;
  SaveIndex := SaveDC(Cnvs.Handle);
  IntersectClipRect(Cnvs.Handle, R.Left, R.Top, R.Right, R.Bottom);
  //
  Cnvs.Brush.Color := C;
  Cnvs.Brush.Style := bsSolid;
  Cnvs.FillRect(R);
  Cnvs.Brush.Style := bsClear;
  //
  InflateRect(R, -2, -2);
  if FItems[Index].Header
  then
    with FItems[Index] do
    begin
      if FHeaderLeftAlignment
      then
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_LEFT or DT_VCENTER or DT_SINGLELINE)
      else
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
  else
    with FItems[Index] do
    begin
      if Assigned(FOnDrawItem)
      then
        begin
          Cnvs.Brush.Style := bsClear;
          FOnDrawItem(Cnvs, Index, FItems[Index].ItemRect);
        end
      else
      begin

       if FShowCheckBoxes
        then
         begin
           Inc(R.Left, 14);
           FCheckOffset := 14;
         end;

      if (Title <> '') and FShowItemTitles
      then
        begin
          R1 := R;
          Cnvs.Font.Style := Cnvs.Font.Style + [fsBold];
          R1.Bottom := R1.Top + Cnvs.TextHeight(Title);
          DrawText(Cnvs.Handle, PChar(Title), Length(FTitle), R1, DT_LEFT);
          Cnvs.Font.Style := Cnvs.Font.Style - [fsBold];
          R.Top := R1.Bottom;
        end;
        if (FImages <> nil) and (ImageIndex >= 0) and
           (ImageIndex < FImages.Count)
        then
         begin
           DrawImageAndText2(Cnvs, R, 0, 2, blGlyphLeft,
             Caption, FImageIndex, FImages,
             False, Enabled, False, 0);
         end
       else
         begin
           if FShowItemTitles
           then
             Inc(R.Left, 10);
           R1 := Rect(0, 0, RectWidth(R), RectHeight(R));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R1,
             DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
           TX := R.Left;
           TY := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
           if TY < R.Top then TY := R.Top;
           R := Rect(TX, TY, TX + RectWidth(R1), TY + RectHeight(R1));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
             DT_WORDBREAK or DT_LEFT);
         end;
      end;

      if FShowLines
      then
        begin
          C := Cnvs.Pen.Color;
          Cnvs.Pen.Color := clBtnFace;
          Cnvs.MoveTo(FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.LineTo(FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.Pen.Color := C;
        end;

       if FShowCheckBoxes
       then
        begin
          R := FItems[Index].ItemRect;
          CR := Rect(R.Left, R.Top,
            R.Left + 12, R.Bottom);
          CR.Top := CR.Top + RectHeight(CR) div 2 - 10 div 2;
          C := Cnvs.Pen.Color;
          if Checked
          then
            DrawCheckImage(Cnvs, CR.Left + 2, CR.Top, FC);
          Cnvs.Pen.Color := C;
        end;

    end;
  if FItems[Index].Active and Focused
  then
    Cnvs.DrawFocusRect(FItems[Index].ItemRect);
  RestoreDC(Cnvs.Handle, SaveIndex);   
end;

procedure TspSkinOfficeListBox.SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);
var
  Buffer: TBitMap;
  CIndex: Integer;
  LData: TspDataSkinLabelControl;
  R, TR: TRect;
  CPicture: TBitMap;
begin
  CIndex := SkinData.GetControlIndex(FHeaderSkinDataName);
  if CIndex = -1
  then
    CIndex := SkinData.GetControlIndex('label');
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  LData := TspDataSkinLabelControl(SkinData.CtrlList[CIndex]);
  CPicture := TBitMap(FSD.FActivePictures.Items[LData.PictureIndex]);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  with LData do
  begin
    CreateStretchImage(Buffer, CPicture, SkinRect, ClRect, True);
  end;

  TR := Rect(1, 1, Buffer.Width - 1, Buffer.Height - 1);

  if FHeaderLeftAlignment then TR.Left := LData.ClRect.Left;

  with Buffer.Canvas, LData do
  begin
    Font.Name := FontName;
    Font.Color := FontColor;
    Font.Height := FontHeight;
    Font.Style := FontStyle;
    Brush.Style := bsClear;
  end;
  with FItems[Index] do
    if FHeaderLeftAlignment
    then
      DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
       DT_LEFT or DT_VCENTER or DT_SINGLELINE)
    else
      DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
       DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  Cnvs.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
end;


procedure TspSkinOfficeListBox.SetItemIndex(Value: Integer);
var
  I: Integer;
  IsFind: Boolean;
begin
  if Value < 0
  then
    begin
      FItemIndex := Value;
      RePaint;
    end
  else
    begin
      FItemIndex := Value;
      IsFind := False;
      for I := 0 to FItems.Count - 1 do
        with FItems[I] do
        begin
          if I = FItemIndex
          then
            begin
              Active := True;
              IsFind := True;
            end
          else
             Active := False;
        end;
      RePaint;
      ScrollToItem(FItemIndex);
      if IsFind and not (csDesigning in ComponentState)
         and not (csLoading in ComponentState)
      then
      begin
        if Assigned(FItems[FItemIndex].OnClick) then
          FItems[FItemIndex].OnClick(Self);
        if Assigned(FOnItemClick) then
          FOnItemClick(Self);
      end;    
    end;
end;

procedure TspSkinOfficeListBox.Loaded;
begin
  inherited;
end;

function TspSkinOfficeListBox.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(FItems[I].ItemRect, Point(X, Y)) and (FItems[I].Enabled)
    then
      begin
        Result := I;
        Break;
      end;  
end;


procedure TspSkinOfficeListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft)
  then
    begin
      SetItemActive(I);
      FMouseDown := True;
      FMouseActive := I;
    end;
end;

procedure TspSkinOfficeListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
  P: TPoint;
begin
  inherited;
  FMouseDown := False;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft) then ItemIndex := I;
  if FShowCheckBoxes and (I <> -1) and (I = ItemIndex)
  then
    begin
      P.X := FItems[I].ItemRect.Left;
      if X < P.X + FCheckOffset
      then
        begin
          Items[I].Checked := not Items[I].Checked;
          if Assigned(FOnItemCheckClick) then FOnItemCheckClick(Self);
        end;
    end;
end;

procedure TspSkinOfficeListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (FMouseDown or FMouseMoveChangeIndex)
   and (I <> FMouseActive)
  then
    begin
      SetItemActive(I);
      FMouseActive := I;
    end;
end;

procedure TspSkinOfficeListBox.SetItemActive(Value: Integer);
var
  I: Integer;
begin
  FItemIndex := Value;
  for I := 0 to FItems.Count - 1 do
  with FItems[I] do
   if I = Value then Active := True else Active := False;
  RePaint;
  ScrollToItem(Value);
end;

type
  TspHookScrollBar = class(TspSkinScrollBar);

procedure TspSkinOfficeListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
  inherited;
  if ScrollBar = nil then Exit;
  if Message.WParam < 0
  then
    ScrollBar.Position :=  ScrollBar.Position + ScrollBar.SmallChange
  else
    ScrollBar.Position :=  ScrollBar.Position - ScrollBar.SmallChange;

end;

procedure TspSkinOfficeListBox.WMSETFOCUS(var Message: TWMSETFOCUS);
begin
  inherited;
  RePaint;
end;

procedure TspSkinOfficeListBox.WMKILLFOCUS(var Message: TWMKILLFOCUS); 
begin
  inherited;
  RePaint;
end;

procedure TspSkinOfficeListBox.WndProc(var Message: TMessage);
begin
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

procedure TspSkinOfficeListBox.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TspSkinOfficeListBox.FindUp;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  for I := Start downto 0 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;  
  end;
end;

procedure TspSkinOfficeListBox.FindDown;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  for I := Start to FItems.Count - 1 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;
  end;
end;

procedure TspSkinOfficeListBox.FindPageUp;
var
  I, J, Start: Integer;
  PageCount: Integer;
  FindHeader: Boolean;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  PageCount := RectHeight(FItemsRect) div FItemHeight;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start - PageCount;
  if PageCount < 0 then PageCount := 0;
  FindHeader := False;
  J := -1;
  for I := Start downto PageCount do
  begin
    if not FItems[I].Header and FindHeader and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end
    else
    if FItems[I].Header
    then
      begin
        FindHeader := True;
        Continue;
      end
    else
    if not FItems[I].Header and FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;


procedure TspSkinOfficeListBox.FindPageDown;
var
  I, J, Start: Integer;
  PageCount: Integer;
  FindHeader: Boolean;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  PageCount := RectHeight(FItemsRect) div FItemHeight;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start + PageCount;
  if PageCount > FItems.Count - 1 then PageCount := FItems.Count - 1;
  FindHeader := False;
  J := -1;
  for I := Start to PageCount do
  begin
    if not FItems[I].Header and FindHeader  and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end
    else
    if FItems[I].Header
    then
      begin
        FindHeader := True;
        Continue;
      end
    else
    if not FItems[I].Header  and FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;

procedure TspSkinOfficeListBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FShowCheckBoxes and (Key = 32) and (ItemIndex <> -1)
  then
    begin
      Items[ItemIndex].Checked := not Items[ItemIndex].Checked;
      if Assigned(FOnItemCheckClick) then FOnItemCheckClick(Self);
    end;
end;

procedure TspSkinOfficeListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
 inherited KeyDown(Key, Shift);
 case Key of
   VK_NEXT:  FindPageDown;
   VK_PRIOR: FindPageUp;
   VK_UP, VK_LEFT: FindUp;
   VK_DOWN, VK_RIGHT: FindDown;
 end;
end;


constructor TspPopupOfficeListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable,
    csAcceptsControls];
  Visible := False;
  FOldAlphaBlend := False;
  FOldAlphaBlendValue := 0;
end;

procedure TspPopupOfficeListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP or WS_CLIPCHILDREN;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_;
  end;
end;

procedure TspPopupOfficeListBox.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspPopupOfficeListBox.Hide;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
end;

procedure TspPopupOfficeListBox.Show(Origin: TPoint);
var
  PLB: TspSkinOfficeComboBox;
  I: Integer;
  TickCount: DWORD;
  AnimationStep: Integer;
begin
  PLB := nil;
  //
  if CheckW2KWXP and (Owner is TspSkinCustomOfficeComboBox)
  then
    begin
      PLB := TspSkinOfficeComboBox(Owner);
      if PLB.AlphaBlend and not FOldAlphaBlend
      then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE,
                        GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
        end
      else
      if not PLB.AlphaBlend and FOldAlphaBlend
      then
        begin
         SetWindowLong(Handle, GWL_EXSTYLE,
            GetWindowLong(Handle, GWL_EXSTYLE) and (not WS_EX_LAYERED));
        end;
      FOldAlphaBlend := PLB.AlphaBlend;
      if (FOldAlphaBlendValue <> PLB.AlphaBlendValue) and PLB.AlphaBlend
      then
        begin
          if PLB.AlphaBlendAnimation
          then
            begin
              SetAlphaBlendTransparent(Handle, 0);
              FOldAlphaBlendValue := 0;
            end
          else
            begin
              SetAlphaBlendTransparent(Handle, PLB.AlphaBlendValue);
              FOldAlphaBlendValue := PLB.AlphaBlendValue;
             end;
        end;
    end;
  //
  SetWindowPos(Handle, HWND_TOP, Origin.X, Origin.Y, 0, 0,
    SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
  Visible := True;
  if CheckW2KWXP and (PLB <> nil) and PLB.AlphaBlendAnimation and PLB.AlphaBlend 
  then
    begin
      Application.ProcessMessages;
      PLB.FLBDown := False;
      I := 0;
      TickCount := 0;
      AnimationStep := PLB.AlphaBlendValue div 15;
      if AnimationStep = 0 then AnimationStep := 1;
      repeat
        if (GetTickCount - TickCount > 5)
        then
          begin
            TickCount := GetTickCount;
            Inc(i, AnimationStep);
            if i > PLB.AlphaBlendValue then i := PLB.AlphaBlendValue;
            SetAlphaBlendTransparent(Handle, i);
          end;
      until i >= PLB.FAlphaBlendValue;
    end;
end;

// combobox

constructor TspSkinCustomOfficeComboBox.Create;
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csReplicatable, csOpaque, csDoubleClicks, csAcceptsControls];
  FListBox := TspPopupOfficeListBox.Create(Self);
  FShowItemTitle := True;
  FShowItemImage := True;
  FShowItemText := True;
  FDropDown := False;
  FToolButtonStyle := False;
  TabStop := True;
  //
  FUseSkinSize := True;
  FLBDown := False;
  WasInLB := False;
  TimerMode := 0;
  FHideSelection := True;
  FDefaultColor := clWindow;
  FAlphaBlendAnimation := False;
  FAlphaBlend := False;
  Font.Name := 'Tahoma';
  Font.Color := clWindowText;
  Font.Style := [];
  Font.Height := 13;
  Width := 120;
  Height := 41;
  //
  FListBoxWindowProc := FlistBox.WindowProc;
  FlistBox.WindowProc := ListBoxWindowProcHook;
  FListBox.Visible := False;
  FlistBox.MouseMoveChangeIndex := True;
  if not (csDesigning in ComponentState)
  then
    FlistBox.Parent := Self;
  FLBDown := False;
  //
  CalcRects;
  FSkinDataName := 'combobox';
  FUseSkinSize := False;
  FLastTime := 0;
  FListBoxWidth := 0;
  FListBoxHeight := 0;
  FDropDownCount := 7;
end;

{$IFDEF VER200_UP}
function TspSkinCustomOfficeComboBox.GetListBoxTouch: TTouchManager;
begin
  Result := FListBox.Touch;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxTouch(Value: TTouchManager);
begin
  FListBox.Touch := Value;
end;
{$ENDIF}

function TspSkinCustomOfficeComboBox.GetListBoxHeaderLeftAlignment: Boolean;
begin
  Result := FListBox.HeaderLeftAlignment;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxHeaderLeftAlignment(Value: Boolean);
begin
  FListBox.HeaderLeftAlignment := Value;
end;

procedure TspSkinCustomOfficeComboBox.BeginUpdateItems;
begin
  FListBox.BeginUpdateItems;
end;

procedure TspSkinCustomOfficeComboBox.EndUpdateItems;
begin
  FListBox.EndUpdateItems;
end;

procedure TspSkinCustomOfficeComboBox.ListBoxWindowProcHook(var Message: TMessage);
var
  FOld: Boolean;
begin
  FOld := True;
  case Message.Msg of
     WM_LBUTTONDOWN:
       begin
         FOLd := False;
         FLBDown := True;
         WasInLB := True;
         SetCapture(Self.Handle);
       end;
     WM_LBUTTONUP,
     WM_RBUTTONDOWN, WM_RBUTTONUP,
     WM_MBUTTONDOWN, WM_MBUTTONUP:
       begin
         FOLd := False;
       end;
     WM_MOUSEACTIVATE:
      begin
        Message.Result := MA_NOACTIVATE;
      end;
  end;
  if FOld then FListBoxWindowProc(Message);
end;

procedure TspSkinCustomOfficeComboBox.DrawMenuMarker;
var
  Buffer: TBitMap;
  SR: TRect;
  X, Y: Integer;
begin
  with ButtonData do
  begin
    if ADown and not IsNullRect(MenuMarkerDownRect)
     then SR := MenuMarkerDownRect else
      if AActive and not IsNullRect(MenuMarkerActiveRect)
      then SR := MenuMarkerActiveRect else SR := MenuMarkerRect;

    if ADown and IsNullRect(MenuMarkerDownRect) and
        not IsNullRect(MenuMarkerActiveRect)
    then SR := MenuMarkerActiveRect;
    
  end;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SR);
  Buffer.Height := RectHeight(SR);

  Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
    Picture.Canvas, SR);

  Buffer.Transparent := True;
  Buffer.TransparentMode := tmFixed;
  Buffer.TransparentColor := ButtonData.MenuMarkerTransparentColor;

  X := R.Left + RectWidth(R) div 2 - RectWidth(SR) div 2;
  Y := R.Top + RectHeight(R) div 2 - RectHeight(SR) div 2;

  C.Draw(X, Y, Buffer);

  Buffer.Free;
end;


procedure TspSkinCustomOfficeComboBox.SetToolButtonStyle;
begin
  if FToolButtonStyle <> Value
  then
    begin
      FToolButtonStyle := Value;
      if FToolButtonStyle
      then
        begin
          UseSkinSize := False;
        end;
      RePaint;  
    end;
end;

procedure TspSkinCustomOfficeComboBox.SetDefaultColor(Value: TColor);
begin
  FDefaultColor := Value;
  if FIndex = -1 then Invalidate;
end;

procedure TspSkinCustomOfficeComboBox.PaintSkinTo(C: TCanvas; X, Y: Integer; AText: String);
var
  B: TBitMap;
  R: TRect;
  S: String;
begin
  B := TBitmap.Create;
  B.Width := Width;
  B.Height := Height;
  GetSkinData;
  S := Self.Text;
  Text := AText;

  if FToolButtonStyle
  then
    begin
      if FIndex <> -1
      then
        CreateControlToolSkinImage(B, AText)
      else
        Self.CreateControlToolDefaultImage(B, AText);
    end
  else
  if Findex = -1
  then
    begin
      CreateControlDefaultImage2(B);
      with B.Canvas.Font do
      begin
        Name := Self.DefaultFont.Name;
        Style := Self.DefaultFont.Style;
        Color := Self.DefaultFont.Color;
        Height := Self.DefaultFont.Height;
      end;
    end
  else
    begin
      CreateControlSkinImage2(B);
      with B.Canvas.Font do
      begin
        Style := FontStyle;
        Color := FontColor;
        Height := FontHeight;
        Name := FontName;
      end;
    end;
  // draw item area

  if not FToolButtonStyle
  then
    begin
      B.Canvas.Brush.Style := bsClear;
      SPDrawText2(B.Canvas, AText, CBItem.R);
    end;
  C.Draw(X, Y, B);
  B.Free;
  Text := S;  
end;


procedure TspSkinCustomOfficeComboBox.SetControlRegion;
begin
  if FUseSkinSize then inherited;
end;

procedure TspSkinCustomOfficeComboBox.WMEraseBkgnd;
var
  SaveIndex: Integer;
begin
  if not FromWMPaint
  then
    begin
      PaintWindow(Msg.DC);
    end;
end;

procedure TspSkinCustomOfficeComboBox.CalcSize(var W, H: Integer);
var
  XO, YO: Integer;
begin
  if FUseSkinSize
  then
    inherited
  else
    begin
      XO := W - RectWidth(SkinRect);
      YO := H - RectHeight(SkinRect);
      NewLTPoint := LTPt;
      NewRTPoint := Point(RTPt.X + XO, RTPt.Y );
      NewClRect := ClRect;
      Inc(NewClRect.Right, XO);
    end;
end;

procedure TspSkinCustomOfficeComboBox.KeyPress;
begin
  inherited;
end;

destructor TspSkinCustomOfficeComboBox.Destroy;
begin
  FlistBox.Free;
  FlistBox := nil;
  inherited;
end;

procedure TspSkinCustomOfficeComboBox.CMEnabledChanged;
begin
  inherited;
  RePaint;
end;

function TspSkinCustomOfficeComboBox.GetListBoxUseSkinFont: Boolean;
begin
  Result := FListBox.UseSkinFont;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxUseSkinFont(Value: Boolean);
begin
  FListBox.UseSkinFont := Value;
end;

procedure TspSkinCustomOfficeComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

function TspSkinCustomOfficeComboBox.GetImages: TCustomImageList;
begin
  if FListBox <> nil
  then
    Result := FListBox.Images
   else
    Result := nil;
end;

procedure TspSkinCustomOfficeComboBox.CMCancelMode;
begin
  inherited;
  if (Message.Sender = nil) or (
     (Message.Sender <> Self) and
     (Message.Sender <> Self.FListBox) and
     (Message.Sender <> Self.FListBox.ScrollBar))
  then
    CloseUp(False);
end;

procedure TspSkinCustomOfficeComboBox.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinCustomOfficeComboBox.GetListBoxDefaultFont;
begin
  Result := FListBox.DefaultFont;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxDefaultFont;
begin
  FListBox.DefaultFont.Assign(Value);
end;

procedure TspSkinCustomOfficeComboBox.DefaultFontChange;
begin
  Font.Assign(FDefaultFont);
end;

procedure TspSkinCustomOfficeComboBox.CheckButtonClick;
begin
  CloseUp(True);
end;

procedure TspSkinCustomOfficeComboBox.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:  Msg.Result := 1;
  end;
end;

procedure TspSkinCustomOfficeComboBox.KeyDown;
var
  I: Integer;
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_UP, VK_LEFT:
      if ssAlt in Shift
      then
        begin
          if FListBox.Visible then CloseUp(False);
        end
      else
        EditUp1(True);
    VK_DOWN, VK_RIGHT:
      if ssAlt in Shift
      then
        begin
          if not FListBox.Visible then DropDown;
        end
      else
        EditDown1(True);

    VK_NEXT: EditPageDown1(True);
    VK_PRIOR: EditPageUp1(True);
    VK_ESCAPE: if FListBox.Visible then CloseUp(False);
    VK_RETURN: if FListBox.Visible then CloseUp(True);
  end;
end;


procedure TspSkinCustomOfficeComboBox.WMMOUSEWHEEL;
begin
  inherited;
  if Message.WParam > 0
  then
    EditUp1(not FListBox.Visible)
  else
    EditDown1(not FListBox.Visible);
end;

procedure TspSkinCustomOfficeComboBox.WMSETFOCUS;
begin
  inherited;
  RePaint;
end;

procedure TspSkinCustomOfficeComboBox.WMKILLFOCUS;
begin
  inherited;
  if FListBox.Visible  then CloseUp(False);
  RePaint;
end;

procedure TspSkinCustomOfficeComboBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinComboBox
    then
      with TspDataSkinComboBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.ActiveFontColor := ActiveFontColor;
        Self.SItemRect := SItemRect;
        Self.ActiveItemRect := ActiveItemRect;
        Self.FocusItemRect := FocusItemRect;
        if isNullRect(FocusItemRect)
        then
          Self.FocusItemRect := SItemRect;
        Self.ItemLeftOffset := ItemLeftOffset;
        Self.ItemRightOffset := ItemRightOffset;
        Self.ItemTextRect := ItemTextRect;

        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.FocusFontColor := FocusFontColor;

        Self.ButtonRect := ButtonRect;
        Self.ActiveButtonRect := ActiveButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.UnEnabledButtonRect := UnEnabledButtonRect;
        Self.ListBoxName := ListBoxName;
        Self.ItemStretchEffect := ItemStretchEffect;
        Self.FocusItemStretchEffect := FocusItemStretchEffect;
        Self.ShowFocus := ShowFocus;
      end;
end;

procedure TspSkinCustomOfficeComboBox.Invalidate;
begin
  inherited;
end;


function TspSkinCustomOfficeComboBox.GetItemIndex;
begin
  Result := FListBox.ItemIndex;
end;

procedure TspSkinCustomOfficeComboBox.SetItemIndex;
begin
  FListBox.ItemIndex := Value;
  FOldItemIndex := FListBox.ItemIndex;
  RePaint;
  if not (csDesigning in ComponentState) and
     not (csLoading in ComponentState)
  then
    begin
      if Assigned(FOnClick) then FOnClick(Self);
      Change;
    end;
end;

function TspSkinCustomOfficeComboBox.IsPopupVisible: Boolean;
begin
  Result := FListBox.Visible;
end;

function TspSkinCustomOfficeComboBox.CanCancelDropDown;
begin
  Result := FListBox.Visible and not FMouseIn;
end;

procedure TspSkinCustomOfficeComboBox.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 25, nil);
end;

procedure TspSkinCustomOfficeComboBox.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinCustomOfficeComboBox.WMTimer;
begin
  inherited;
  case TimerMode of
    1: FListBox.FindUp;
    2: FListBox.FindDown;
  end;
end;

procedure TspSkinCustomOfficeComboBox.ProcessListBox;
var
  R: TRect;
  P: TPoint;
  LBP: TPoint;
begin
  GetCursorPos(P);
  P := FListBox.ScreenToClient(P);
  if (P.Y < 0) and (FListBox.ScrollBar <> nil) and WasInLB
  then
    begin
      if (TimerMode <> 1)
      then
        begin
          TimerMode := 1;
          StartTimer;
        end;
    end
  else
  if (P.Y > FListBox.Height) and (FListBox.ScrollBar <> nil) and WasInLB
  then
    begin
      if (TimerMode <> 2)
      then
        begin
          TimerMode := 2;
          StartTimer;
        end
    end
  else
    if (P.Y >= 0) and (P.Y <= FListBox.Height)
    then
      begin
        if TimerMode <> 0 then StopTimer;
        FListBox.MouseMove([], P.X, P.Y);
        WasInLB := True;
        if not FLBDown
        then
          begin
            FLBDown := True;
            WasInLB := False;
          end;  
      end;
end;

procedure TspSkinCustomOfficeComboBox.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
  //
  if ((FIndex <> -1) and not IsNullRect(ActiveSkinRect)) or FToolButtonStyle
  then
    Invalidate;
end;

procedure TspSkinCustomOfficeComboBox.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end;
  //
 if ((FIndex <> -1) and not IsNullRect(ActiveSkinRect)) or FToolButtonStyle
 then
   Invalidate;
end;

procedure TspSkinCustomOfficeComboBox.SetDropDownCount(Value: Integer);
begin
  if Value >= 0
  then
    FDropDownCount := Value;
end;

procedure TspSkinCustomOfficeComboBox.SetItems;
begin
  FListBox.Items.Assign(Value);
end;

function TspSkinCustomOfficeComboBox.GetItems;
begin
  Result := FListBox.Items;
end;

procedure TspSkinCustomOfficeComboBox.MouseDown;
begin
  inherited;
  if not Focused then SetFocus;
  if Button <> mbLeft then Exit;
  if Self.Button.MouseIn or
     PtInRect(CBItem.R, Point(X, Y)) or
     FToolButtonStyle
  then
    begin
      Self.Button.Down := True;
      RePaint;
      if FListBox.Visible then CloseUp(False)
      else
        begin
          WasInLB := False;
          FLBDown := True;
          DropDown;
        end;
    end
  else
    if FListBox.Visible then CloseUp(False);
end;

procedure TspSkinCustomOfficeComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  P: TPoint;
begin
  if FLBDown and WasInLB
  then
    begin
      ReleaseCapture;
      FLBDown := False;
      GetCursorPos(P);
      if WindowFromPoint(P) = FListBox.Handle
      then
        CloseUp(True)
      else
        CloseUp(False);
    end
  else
     FLBDown := False;
  inherited;
  if Self.Button.Down
  then
    begin
      Self.Button.Down := False;
      RePaint;
    end;
end;

procedure TspSkinCustomOfficeComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FListBox.Visible then ProcessListBox;
  if PtInRect(Button.R, Point(X, Y)) and not Button.MouseIn
  then
    begin
      Button.MouseIn := True;
      RePaint;
    end
  else
  if not PtInRect(Button.R, Point(X, Y)) and Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end
end;

procedure TspSkinCustomOfficeComboBox.CloseUp;
begin
  if TimerMode <> 0 then StopTimer;
  if not FListBox.Visible then Exit;
  FListBox.Hide;
  if (FListBox.ItemIndex >= 0) and
     (FListBox.ItemIndex < FListBox.Items.Count) and Value
  then
    begin
       RePaint;
       if Assigned(FOnClick) then FOnClick(Self);
       Change;
     end
  else
    FListBox.ItemIndex := FOldItemIndex;
  FDropDown := False;  
  RePaint;
  if Value
  then
    if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TspSkinCustomOfficeComboBox.DropDown;
function GetForm(AControl : TControl) : TForm;
  var
    temp : TControl;
  begin
    result := nil;
    temp := AControl;
    repeat
      if assigned(temp) then
      begin
        if temp is TForm then
        break;
      end;
      temp := temp.Parent;
    until temp = nil;
  end;

var
  P: TPoint;
  WorkArea: TRect;
begin
  if Items.Count = 0 then Exit;
  WasInLB := False;
  if TimerMode <> 0 then StopTimer;
  if Assigned(FOnDropDown) then FOnDropDown(Self);

  if FListBoxWidth = 0
  then
    FListBox.Width := Width
  else
    FListBox.Width := FListBoxWidth;

  FListBox.OnDrawItem := Self.OnDrawItem;

  // P := Point(Left, Top + Height);
  P := Point(Left + Width - FListBox.Width, Top + Height);
  P := Parent.ClientToScreen (P);

  WorkArea := GetMonitorWorkArea(Handle, True);

  if P.Y + FListBox.Height > WorkArea.Bottom
  then
    P.Y := P.Y - Height - FListBox.Height;

  FOldItemIndex := FListBox.ItemIndex;

  if (FListBox.ItemIndex = 0) and (FListBox.Items.Count > 1)
  then
    begin
      FListBox.ItemIndex := 1;
      FListBox.ItemIndex := 0;
    end;
  FDropDown := True;
  if Self.FToolButtonStyle then  RePaint;
  FListBox.SkinData := SkinData;
   if FListBoxHeight > 0
  then
    FListBox.Height := FListBoxHeight
  else
  if FDropDownCount > 0
  then
    begin
      FListBox.Height := FListBox.CalcHeight(FDropDownCount); 
    end;
  FListBox.Show(P);
end;

procedure TspSkinCustomOfficeComboBox.WMSIZE;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinCustomOfficeComboBox.DrawResizeButton;
var
  Buffer, Buffer2: TBitMap;
  CIndex: Integer;
  ButtonData: TspDataSkinButtonControl;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  SR, BtnCLRect: TRect;
  BSR, ABSR, DBSR: TRect;
  XO, YO: Integer;
  ArrowColor: TColor;
  X, Y: Integer;
begin
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(Button.R);
  Buffer.Height := RectHeight(Button.R);
  //
  CIndex := SkinData.GetControlIndex('combobutton');
  if CIndex = -1
  then
    CIndex := SkinData.GetControlIndex('editbutton');
  if CIndex = -1 then CIndex := SkinData.GetControlIndex('resizebutton');
  if CIndex = -1
  then
    begin
      Buffer.Free;
      Exit;
    end
  else
    ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);
  //
  with ButtonData do
  begin
    XO := RectWidth(Button.R) - RectWidth(SkinRect);
    YO := RectHeight(Button.R) - RectHeight(SkinRect);
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
    if Button.Down and Button.MouseIn
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
    if Button.MouseIn
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
   end;
  //
  if not IsNullRect(ButtonData.MenuMarkerRect)
  then
    with ButtonData do
    begin
      if Button.Down and Button.MouseIn and not IsNullRect(MenuMarkerDownRect)
      then SR := MenuMarkerDownRect else
        if Button.MouseIn and not IsNullRect(MenuMarkerActiveRect)
          then SR := MenuMarkerActiveRect else SR := MenuMarkerRect;

      Buffer2 := TBitMap.Create;
      Buffer2.Width := RectWidth(SR);
      Buffer2.Height := RectHeight(SR);

      Buffer2.Canvas.CopyRect(Rect(0, 0, Buffer2.Width, Buffer2.Height),
       Picture.Canvas, SR);

      Buffer2.Transparent := True;
      Buffer2.TransparentMode := tmFixed;
      Buffer2.TransparentColor := MenuMarkerTransparentColor;

      X := RectWidth(Button.R) div 2 - RectWidth(SR) div 2;
      Y := RectHeight(Button.R) div 2 - RectHeight(SR) div 2;
      if Button.Down and Button.MouseIn then Y := Y + 1;
      Buffer.Canvas.Draw(X, Y, Buffer2);
      Buffer2.Free;
    end
  else
  if Enabled
  then
    begin
      if Button.Down and Button.MouseIn
      then
        DrawArrowImage(Buffer.Canvas, Rect(0, 2, Buffer.Width, Buffer.Height), ArrowColor, 4)
      else
        DrawArrowImage(Buffer.Canvas, Rect(0, 0, Buffer.Width, Buffer.Height), ArrowColor, 4);
    end;
  //
  C.Draw(Button.R.Left, Button.R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomOfficeComboBox.DrawButton;
var
  ArrowColor: TColor;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Button do
    begin
      R1 := R;
      if Down and MouseIn
      then
        begin
          Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          C.Brush.Color := SP_XP_BTNDOWNCOLOR;
          C.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            C.Brush.Color := SP_XP_BTNACTIVECOLOR;
            C.FillRect(R1);
          end
        else
          begin
            Frame3D(C, R1, clBtnShadow, clBtnShadow, 1);
            C.Brush.Color := clBtnFace;
            C.FillRect(R1);
          end;
      if Enabled
      then
        ArrowColor := clBlack
      else
        ArrowColor := clBtnShadow;
      DrawArrowImage(C, R, ArrowColor, 4);
    end
  else
    with Button do
    begin
      R1 := NullRect;
      if not Enabled and not IsNullRect(UnEnabledButtonRect)
      then
        R1 := UnEnabledButtonRect
      else
      if Down and MouseIn
      then R1 := DownButtonRect
      else if MouseIn then R1 := ActiveButtonRect;
      if not IsNullRect(R1)
      then
        C.CopyRect(R, Picture.Canvas, R1);
    end;
end;

procedure TspSkinCustomOfficeComboBox.DrawDefaultItem;
var
  Buffer: TBitMap;
  R, R1, TR: TRect;
  Index, IIndex, IX, IY: Integer;
begin
  if RectWidth(CBItem.R) <=0 then Exit;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(CBItem.R);
  Buffer.Height := RectHeight(CBItem.R);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    Font.Name := Self.Font.Name;
    Font.Style := Self.Font.Style;
    Font.Height := Self.Font.Height;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.Charset := FDefaultFont.Charset;
    if Focused
    then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := FDefaultColor;
        Font.Color := FDefaultFont.Color;
      end;
    FillRect(R);
  end;

  if FListBox.Visible
  then Index := FOldItemIndex
  else Index := FListBox.ItemIndex;

  CBItem.State := [];

  if Focused then CBItem.State := [odFocused];

  R1 := Rect(R.Left + 2, R.Top, R.Right - 2, R.Bottom);
  if (Index > -1) and (Index < FListBox.Items.Count)
  then
    begin
       if Assigned(FOnDrawItem)
      then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R1);
        end
      else
      begin

       if FShowItemText and FShowItemTitle and (Items[Index].Title <> '')
        then
          begin
            Buffer.Canvas.Font.Style := Buffer.Canvas.Font.Style + [fsBold];
            TR := R1;
            TR.Bottom := TR.Top + Buffer.Canvas.TextHeight(Items[Index].Title);
            DrawText(Buffer.Canvas.Handle, PChar(Items[Index].Title),
              Length(Items[Index].Title), TR, DT_LEFT);
            Buffer.Canvas.Font.Style := Buffer.Canvas.Font.Style - [fsBold];
            R1.Top := TR.Bottom - 2;
          end;
        if FShowItemText and not FShowItemImage
        then
          SPDrawText2(Buffer.Canvas, Items[Index].Caption, R1)
        else
        if FShowItemImage
        then
          begin
            if FShowItemText
            then
              DrawImageAndText2(Buffer.Canvas, R1, 0, 2, blGlyphLeft,
               Items[Index].Caption, Items[Index].ImageIndex, Images,
               False, Enabled, False, 0)
            else
               DrawImageAndText2(Buffer.Canvas, R1, 0, 2, blGlyphLeft,
               '', Items[Index].ImageIndex, Images, False, Enabled, False, 0)
          end;
       end;
    end;
  if Focused then DrawFocusRect(Buffer.Canvas.Handle, R);
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomOfficeComboBox.DrawResizeSkinItem(Cnvs: TCanvas);
var
  Buffer: TBitMap;
  R, R2, TR: TRect;
  W, H: Integer;
  Index, IIndex, IX, IY: Integer;
  Offset: Integer;
begin
  W := RectWidth(CBItem.R);
  if W <= 0 then Exit;
  H := RectHeight(SItemRect);
  if H = 0 then H := RectHeight(FocusItemRect);
  if H = 0 then H := RectWidth(CBItem.R);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(CBItem.R);
  Buffer.Height := RectHeight(CBItem.R);
  if Focused
  then
    begin
      if not IsNullRect(FocusItemRect)
      then
        begin
          R2 := ItemTextRect;
          InflateRect(R2, -1, -1);
          
          if RectWidth(SItemRect) > RectWidth(FocusItemRect)
          then
            Dec(R2.Right, RectWidth(SItemRect) - RectWidth(FocusItemRect));

          if RectHeight(SItemRect) > RectHeight(FocusItemRect)
          then
            Dec(R2.Top, RectHeight(SItemRect) - RectHeight(FocusItemRect));

          CreateStretchImage(Buffer, Picture, FocusItemRect, R2, True);
        end
      else
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Cnvs, CBItem.R);
    end
  else
    begin
      if not IsNullRect(ActiveItemRect) and not IsNullRect(ActiveSkinRect) and
         FMouseIn
      then
        begin
           R2 := ItemTextRect;
          if RectWidth(SItemRect) > RectWidth(ActiveItemRect)
          then
            Dec(R2.Right, RectWidth(SItemRect) - RectWidth(ActiveItemRect));

          if RectHeight(SItemRect) > RectHeight(ActiveItemRect)
          then
            Dec(R2.Top, RectHeight(SItemRect) - RectHeight(ActiveItemRect));

          CreateStretchImage(Buffer, Picture, ActiveItemRect, R2, True)
        end
      else
      if not IsNullRect(SItemRect)
      then
        CreateStretchImage(Buffer, Picture, SItemRect, ItemTextRect, True)
      else
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Cnvs, CBItem.R);
    end;

  R := ItemTextRect;
  if not IsNullRect(SItemRect)
  then
    Inc(R.Right, W - RectWidth(SItemRect))
  else
    Inc(R.Right, W - RectWidth(ClRect));
  Inc(ItemTextRect.Bottom, Height - RectHeight(SkinRect));
  Inc(R.Bottom, Height - RectHeight(SkinRect));
  with Buffer.Canvas do
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

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := FDefaultFont.CharSet;

    if Focused
    then
      Font.Color := FocusFontColor
    else
      if FMouseIn and not IsNullRect(ActiveSkinRect)
      then
        Font.Color := ActiveFontColor
      else
        Font.Color := FontColor;
    Brush.Style := bsClear;
  end;

  if FListBox.Visible
  then Index := FOldItemIndex
  else Index := FListBox.ItemIndex;

  if (Index > -1) and (Index < FListBox.Items.Count)
  then
      begin
       if Focused and ShowFocus
       then
        begin
          Buffer.Canvas.Brush.Style := bsSolid;
          Buffer.Canvas.Brush.Color := FSD.SkinColors.cBtnFace;
          Buffer.Canvas.DrawFocusRect(Rect(0, 0, Buffer.Width, Buffer.Height));
          Buffer.Canvas.Brush.Style := bsClear;
        end;
        Inc(R.Left, 1);

         if Assigned(FOnDrawItem)
       then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R);
        end
      else
        begin

        if FShowItemText and FShowItemTitle and (Items[Index].Title <> '')
        then
          begin
            Buffer.Canvas.Font.Style := Buffer.Canvas.Font.Style + [fsBold];
            TR := R;
            TR.Bottom := TR.Top + Buffer.Canvas.TextHeight(Items[Index].Title);
            DrawText(Buffer.Canvas.Handle, PChar(Items[Index].Title),
              Length(Items[Index].Title), TR, DT_LEFT);
            Buffer.Canvas.Font.Style := Buffer.Canvas.Font.Style - [fsBold];
            R.Top := TR.Bottom - 2;
          end;
        if FShowItemText and not FShowItemImage
        then
          SPDrawText2(Buffer.Canvas, Items[Index].Caption, R)
        else
        if FShowItemImage
        then
          begin
            if FShowItemText
            then
              DrawImageAndText2(Buffer.Canvas, R, 0, 2, blGlyphLeft,
               Items[Index].Caption, Items[Index].ImageIndex, Images,
               False, Enabled, False, 0)
            else
               DrawImageAndText2(Buffer.Canvas, R, 0, 2, blGlyphLeft,
               '', Items[Index].ImageIndex, Images, False, Enabled, False, 0)
          end;
        end;  
      end;
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;


function TspSkinCustomOfficeComboBox.GetDisabledFontColor: TColor;
var
  i: Integer;
begin
  i := -1;
  if FIndex <> -1 then i := SkinData.GetControlIndex('edit');
  if i = -1
  then
    Result := clGrayText
  else
    Result := TspDataSkinEditControl(SkinData.CtrlList[i]).DisabledFontColor;
end;

procedure TspSkinCustomOfficeComboBox.DrawSkinItem;
var
  Buffer: TBitMap;
  R, R2: TRect;
  W, H: Integer;
  Index, IIndex, IX, IY: Integer;
begin
  W := RectWidth(CBItem.R);
  if W <= 0 then Exit;
  H := RectHeight(SItemRect);
  if H = 0 then H := RectHeight(FocusItemRect);
  if H = 0 then H := RectWidth(CBItem.R);
  Buffer := TBitMap.Create;
  if Focused
  then
    begin
      if not IsNullRect(FocusItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          FocusItemRect, W, H, FocusItemStretchEffect)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end
  else
    begin
      if not IsNullRect(ActiveItemRect) and not IsNullRect(ActiveSkinRect) and
         FMouseIn
      then
        begin
          CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
            ActiveItemRect, W, H, ItemStretchEffect)
        end
      else
      if not IsNullRect(SItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          SItemRect, W, H, ItemStretchEffect)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end;

  R := ItemTextRect;
  
  if not IsNullRect(SItemRect)
  then
    Inc(R.Right, W - RectWidth(SItemRect))
  else
    Inc(R.Right, W - RectWidth(ClRect));

  with Buffer.Canvas do
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

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := FDefaultFont.CharSet;

    if Focused
    then
      Font.Color := FocusFontColor
    else
      if FMouseIn and not IsNullRect(ActiveSkinRect)
      then
        Font.Color := ActiveFontColor
      else
        Font.Color := FontColor;
    if not Enabled then Font.Color := GetDisabledFontColor;
    Brush.Style := bsClear;
  end;

  if FListBox.Visible
  then Index := FOldItemIndex
  else Index := FListBox.ItemIndex;

  if (Index > -1) and (Index < FListBox.Items.Count)
  then
      begin

      if Assigned(FOnDrawItem)
      then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R);
        end
      else
      begin

        if FShowItemText and not FShowItemImage
        then
          SPDrawText2(Buffer.Canvas, FListBox.Items[Index].Caption, R)
        else
        if FShowItemImage
        then
          begin
            if FShowItemText
            then
              DrawImageAndText2(Buffer.Canvas, R, 0, 2, blGlyphLeft,
               Items[Index].Caption, Items[Index].ImageIndex, Images,
               False, Enabled, False, 0)
            else
               DrawImageAndText2(Buffer.Canvas, R, 0, 2, blGlyphLeft,
               '', Items[Index].ImageIndex, Images, False, Enabled, False, 0)
          end;
        end;  
      end;
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomOfficeComboBox.CalcRects;
const
  ButtonW = 17;
var
  OX, OY: Integer;
begin
  if (FIndex = -1) or FToolButtonStyle
  then
    begin
      Button.R := Rect(Width - ButtonW - 2, 2, Width - 2, Height - 2);
      CBItem.R := Rect(2, 2, Button.R.Left - 1 , Height -  2);
    end
  else
    begin
      OX := Width - RectWidth(SkinRect);
      Button.R := ButtonRect;
      if ButtonRect.Left >= RectWidth(SkinRect) - RTPt.X
      then
        OffsetRect(Button.R, OX, 0);
      CBItem.R := ClRect;
      Inc(CBItem.R.Right, OX);
      if not UseSkinSize
      then
        begin
          OY := Height - RectHeight(SkinRect);
          Inc(CBItem.R.Bottom, OY);
          Inc(Button.R.Bottom, OY);
        end;
    end;
end;

procedure TspSkinCustomOfficeComboBox.ChangeSkinData;
var
  W, H: Integer;
begin
  inherited;
  CalcRects;

  RePaint;

  if FIndex = -1
  then
    begin
      FListBox.SkinDataName := '';
    end  
  else
    FListBox.SkinDataName := ListBoxSkinDataName;
  FListBox.SkinData := SkinData;
  //
  CalcRects;
end;


procedure TspSkinCustomOfficeComboBox.CreateControlDefaultImage2;
var
  R: TRect;
begin
  CalcRects;
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  with B.Canvas do
  begin
    InflateRect(R, -1, -1);
    Brush.Color := FDefaultColor;
    FillRect(R);
  end;
  DrawButton(B.Canvas);
end;


procedure TspSkinCustomOfficeComboBox.CreateControlDefaultImage;
var
  R: TRect;
begin
  CalcRects;
  if FToolButtonStyle
  then
    begin
      CreateControlToolDefaultImage(B, '');
      Exit;
    end;
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  with B.Canvas do
  begin
    InflateRect(R, -1, -1);
    Brush.Color := FDefaultColor;
    FillRect(R);
  end;
  DrawButton(B.Canvas);
  DrawDefaultItem(B.Canvas);
end;

procedure TspSkinCustomOfficeComboBox.CreateControlToolDefaultImage(B: TBitMap; AText: String);
var
  XO, YO: Integer;
  R, TR: TRect;
  IX, IY, Index, IIndex: Integer;
  S: String;
begin

  R := Rect(0, 0, Width, Height);
  //
  if FDropDown
  then
    begin
      Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
      B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
      B.Canvas.FillRect(R);
    end
  else
  if FMouseIn or Focused
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
  // draw item

  R := Rect(2, 2, Width - 17, Height - 2);

  with B.Canvas do
  begin
    Font.Assign(FDefaultFont);
    Brush.Style := bsClear;
    if FListBox.Visible
    then Index := FOldItemIndex
    else Index := FListBox.ItemIndex;
    if (Index > -1) and (Index < FListBox.Items.Count)
    then
      begin
        if AText <> ''
        then
          S := AText
        else
          S := FListBox.Items[Index].Caption;
        if FShowItemText and FShowItemTitle and (Items[Index].Title <> '')
        then
          begin
            B.Canvas.Font.Style := B.Canvas.Font.Style + [fsBold];
            TR := R;
            TR.Bottom := TR.Top + B.Canvas.TextHeight(Items[Index].Title);
            DrawText(B.Canvas.Handle, PChar(Items[Index].Title),
              Length(Items[Index].Title), TR, DT_LEFT);
            B.Canvas.Font.Style := B.Canvas.Font.Style - [fsBold];
            R.Top := TR.Bottom - 2;
          end;
        if FShowItemText and not FShowItemImage
        then
          SPDrawText2(B.Canvas, S, R)
        else
        if FShowItemImage
        then
          begin
            if FShowItemText
            then
              DrawImageAndText2(B.Canvas, R, 0, 2, blGlyphLeft,
               S, Items[Index].ImageIndex, Images,
               False, Enabled, False, 0)
            else
               DrawImageAndText2(B.Canvas, R, 0, 2, blGlyphLeft,
               '', Items[Index].ImageIndex, Images, False, Enabled, False, 0)
          end;
       end;
  end;

  R := Rect(Width - 15, 0, Width, Height);

  DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
end;


procedure TspSkinCustomOfficeComboBox.CreateControlToolSkinImage(B: TBitMap; AText: String);
var
  ButtonData: TspDataSkinButtonControl;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  XO, YO: Integer;
  SR: TRect;
  CIndex: Integer;
  R, TR: TRect;
  IX, IY, Index, IIndex: Integer;
  S: String;
begin
  GetSkindata;
  if FIndex = -1 then Exit;

  CIndex := SkinData.GetControlIndex('resizetoolbutton');
  if CIndex = -1
  then
    begin
      CIndex := SkinData.GetControlIndex('resizebutton');
      if CIndex = -1 then Exit else
        ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);
    end
  else
    ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);

  R := Rect(0, 0, Width, Height);

  with ButtonData do
  begin
    //
    if FDropDown then SR := DownSkinRect else
      if (FMouseIn or Focused) then SR := ActiveSkinRect else SR := SkinRect;
    if IsNullRect(SR) then SR := SkinRect;
    //

    XO := RectWidth(R) - RectWidth(SkinRect);
    YO := RectHeight(R) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
    if IsNullRect(SR) then SR := ActiveSkinRect;
    CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        B, BtnSkinPicture, SR, B.Width, B.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);

    // draw item
    R := Rect(2, 2, Width - 17, Height - 2);

    with B.Canvas do
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
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := FDefaultFont.CharSet;

      if FDropDown then Font.Color := DownFontColor else
       if (FMouseIn or Focused) then Font.Color := ActiveFontColor else
         if not Enabled then Font.Color := DisabledFontColor else
           Font.Color := FontColor;
      Brush.Style := bsClear;
      if FListBox.Visible
      then Index := FOldItemIndex
      else Index := FListBox.ItemIndex;
      if (Index > -1) and (Index < FListBox.Items.Count)
      then
        begin
          if AText <> ''
          then
            S := AText
          else
            S := FListBox.Items[Index].Caption;

        if FShowItemText and FShowItemTitle and (Items[Index].Title <> '')
        then
          begin
            B.Canvas.Font.Style := B.Canvas.Font.Style + [fsBold];
            TR := R;
            TR.Bottom := TR.Top + B.Canvas.TextHeight(Items[Index].Title);
            DrawText(B.Canvas.Handle, PChar(Items[Index].Title),
              Length(Items[Index].Title), TR, DT_LEFT);
            B.Canvas.Font.Style := B.Canvas.Font.Style - [fsBold];
            R.Top := TR.Bottom - 2;
          end;
        if FShowItemText and not FShowItemImage
        then
          SPDrawText2(B.Canvas, S, R)
        else
        if FShowItemImage
        then
          begin
            if FShowItemText
            then
              DrawImageAndText2(B.Canvas, R, 0, 2, blGlyphLeft,
               S, Items[Index].ImageIndex, Images,
               False, Enabled, False, 0)
            else
               DrawImageAndText2(B.Canvas, R, 0, 2, blGlyphLeft,
               '', Items[Index].ImageIndex, Images, False, Enabled, False, 0)
          end;
        end;
    end;

    //

    R := Rect(Width - 15, 0, Width, Height);

   if not IsNullRect(MenuMarkerRect)
   then
     begin
       DrawMenuMarker(B.Canvas, R, FMouseIn, FDropDown, ButtonData);
     end
   else
   if FDropDown
   then
     DrawTrackArrowImage(B.Canvas, R, DownFontColor)
   else
     DrawTrackArrowImage(B.Canvas, R, B.Canvas.Font.Color);
  end;
end;


procedure TspSkinCustomOfficeComboBox.CreateControlSkinImage2;
begin
  CalcRects;
  if FUseSkinSize
  then
    begin
      if not IsNullRect(ActiveSkinRect) and (FMouseIn or Focused)
      then
        CreateHSkinImage(LTPt.X, RectWidth(ActiveSkinRect) - RTPt.X,
          B, Picture, ActiveSkinRect, Width, RectHeight(ActiveSkinRect), StretchEffect)
      else
        inherited CreateControlSkinImage(B);
    end
  else
    begin
      if not IsNullRect(ActiveSkinRect) and (FMouseIn or Focused)
      then
        CreateStretchImage(B, Picture, SkinRect, ClRect, True)
      else
        CreateStretchImage(B, Picture, SkinRect, ClRect, True);
    end;

  if (FUseSkinSize) or (FIndex = -1)
  then
    DrawButton(B.Canvas)
  else
    DrawResizeButton(B.Canvas);
end;


procedure TspSkinCustomOfficeComboBox.CreateControlSkinImage;
begin
  CalcRects;
  if FToolButtonStyle
  then
    begin
      Self.CreateControlToolSkinImage(B, '');
    end
  else
  if FUseSkinSize
  then
    begin
      if not IsNullRect(ActiveSkinRect) and (FMouseIn or Focused)
      then
        CreateHSkinImage(LTPt.X, RectWidth(ActiveSkinRect) - RTPt.X,
          B, Picture, ActiveSkinRect, Width, RectHeight(ActiveSkinRect), StretchEffect)
      else
        inherited;
    end
  else
    begin
      if not IsNullRect(ActiveSkinRect) and (FMouseIn or Focused)
      then
        CreateStretchImage(B, Picture, ActiveSkinRect, ClRect, True)
      else
        CreateStretchImage(B, Picture, SkinRect, ClRect, True);
    end;


  if not FToolButtonStyle
  then
    begin
      if (FUseSkinSize) or (FIndex = -1)
      then
        DrawButton(B.Canvas)
      else
        DrawResizeButton(B.Canvas);
      
        if FUseSkinSize
        then
          DrawSkinItem(B.Canvas)
        else
          DrawResizeSkinItem(B.Canvas);
    end;
end;

procedure TspSkinCustomOfficeComboBox.EditPageUp1;
begin
  FListBox.FindPageUp;
  if AChange then ItemIndex := FListBox.ItemIndex;
end;

procedure TspSkinCustomOfficeComboBox.EditPageDown1(AChange: Boolean);
begin
  FListBox.FindPageDown;
  if AChange then ItemIndex := FListBox.ItemIndex;
end;

procedure TspSkinCustomOfficeComboBox.EditUp1;
begin
  FListBox.FindUp;
  if AChange then ItemIndex := FListBox.ItemIndex;
end;

procedure TspSkinCustomOfficeComboBox.EditDown1;
begin
  FListBox.FindDown;
  if AChange then ItemIndex := FListBox.ItemIndex;
end;

procedure TspSkinCustomOfficeComboBox.SetImages(Value: TCustomImageList);
begin
  FListBox.Images := Value;
end;


function TspSkinCustomOfficeComboBox.GetListBoxShowItemTitles: Boolean;
begin
  Result := FListBox.ShowItemTitles;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxShowItemTitles(Value: Boolean);
begin
  FListBox.ShowItemTitles := Value;
end;

function TspSkinCustomOfficeComboBox.GetListBoxSkinDataName: String;
begin
  Result := FListBox.SkinDataName;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxSkinDataName(Value: String);
begin
  FListBox.SkinDataName := Value;
end;

function TspSkinCustomOfficeComboBox.GetListBoxShowLines: Boolean;
begin
  Result := FListBox.ShowLines;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxShowLines(Value: Boolean);
begin
  FListBox.ShowLines := Value;
end;

function TspSkinCustomOfficeComboBox.GetListBoxItemHeight: Integer;
begin
  Result := FlistBox.ItemHeight;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxItemHeight(Value: Integer);
begin
  FlistBox.ItemHeight := Value;
end;

function TspSkinCustomOfficeComboBox.GetListBoxHeaderHeight: Integer;
begin
  Result := FListBox.HeaderHeight;
end;

procedure TspSkinCustomOfficeComboBox.SetListBoxHeaderHeight(Value: Integer);
begin
  FListBox.HeaderHeight := Value;
end;

procedure TspSkinCustomOfficeComboBox.SetShowItemTitle(Value: Boolean);
begin
  if FShowItemTitle <> Value
  then
    begin
      FShowItemTitle := Value;
      RePaint;
    end;  
end;

procedure TspSkinCustomOfficeComboBox.SetShowItemImage(Value: Boolean);
begin
  if FShowItemImage <> Value
  then
    begin
      FShowItemImage := Value;
      RePaint;
    end;  
end;

procedure TspSkinCustomOfficeComboBox.SetShowItemText(Value: Boolean);
begin
  if FShowItemText <> Value
  then
    begin
      FShowItemText := Value;
      RePaint
    end;  
end;

// TspSkinLinkBar ===============================================================

constructor TspSkinLinkBarItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FHeader := False;
  FImageIndex := -1;
  FActiveImageIndex := -1;
  FCaption := '';
  FEnabled := True;
  if TspSkinLinkBarItems(Collection).LinkBar.ItemIndex = Self.Index
  then
    Active := True
  else
    Active := False;
  FUseCustomGlowColor := False;
  FCustomGlowColor := clAqua;  
end;

procedure TspSkinLinkBarItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinLinkBarItem then
  begin
    FImageIndex := TspSkinLinkBarItem(Source).ImageIndex;
    FActiveImageIndex := TspSkinLinkBarItem(Source).ActiveImageIndex;
    FCaption := TspSkinLinkBarItem(Source).Caption;
    FEnabled := TspSkinLinkBarItem(Source).Enabled;
    FHeader := TspSkinLinkBarItem(Source).Header;
    FUseCustomGlowColor := TspSkinLinkBarItem(Source).UseCustomGlowColor;
    FCustomGlowColor := TspSkinLinkBarItem(Source).CustomGlowColor;
  end
  else
    inherited Assign(Source);
end;

procedure TspSkinLinkBarItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspSkinLinkBarItem.SetActiveImageIndex(const Value: TImageIndex);
begin
  FActiveImageIndex := Value;
  Changed(False);
end;

procedure TspSkinLinkBarItem.SetCaption(const Value: String);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TspSkinLinkBarItem.SetHeader(Value: Boolean);
begin
  FHeader := Value;
  Changed(False);
end;

procedure TspSkinLinkBarItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  Changed(False);
end;

constructor TspSkinLinkBarItems.Create;
begin
  inherited Create(TspSkinLinkBarItem);
  LinkBar := AListBox;
end;

function TspSkinLinkBarItems.GetOwner: TPersistent;
begin
  Result := LinkBar;
end;

procedure  TspSkinLinkBarItems.Update(Item: TCollectionItem);
begin
  LinkBar.Repaint;
  LinkBar.UpdateScrollInfo;
end; 

function TspSkinLinkBarItems.GetItem(Index: Integer):  TspSkinLinkBarItem;
begin
  Result := TspSkinLinkBarItem(inherited GetItem(Index));
end;

procedure TspSkinLinkBarItems.SetItem(Index: Integer; Value:  TspSkinLinkBarItem);
begin
  inherited SetItem(Index, Value);
  LinkBar.RePaint;
end;

function TspSkinLinkBarItems.Add: TspSkinLinkBarItem;
begin
  Result := TspSkinLinkBarItem(inherited Add);
  LinkBar.RePaint;
end;

function TspSkinLinkBarItems.Insert(Index: Integer): TspSkinLinkBarItem;
begin
  Result := TspSkinLinkBarItem(inherited Insert(Index));
  LinkBar.RePaint;
end;

procedure TspSkinLinkBarItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  LinkBar.RePaint;
end;

procedure TspSkinLinkBarItems.Clear;
begin
  inherited Clear;
  LinkBar.RePaint;
end;

constructor TspSkinLinkBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csAcceptsControls];
  FHeaderSkinDataName := 'menuheader';
  FHeaderLeftAlignment := False;
  FGlowEffect := False;
  FHeaderBold := True;
  FGlowSize := 10;
  FShowTextUnderLine := True;
  FHoldSelectedItem := False;
  FShowBlurMarker := False;
  FClicksDisabled := False;
  FSpacing := 5;
  FMouseDown := False;
  FShowLines := False;
  FMouseActive := -1;
  ScrollBar := nil;
  FScrollOffset := 0;
  FItems := TspSkinLinkBarItems.Create(Self);
  FImages := nil;
  Width := 150;
  Height := 150;
  FItemHeight := 30;
  FHeaderHeight := 20;
  FSkinDataName := 'listbox';
  FShowItemTitles := True;
  FMax := 0;
  FRealMax := 0;
  FOldHeight := -1;
  FItemIndex := -1;
  FDisabledFontColor := clGray;
end;

procedure TspSkinLinkBar.SetHeaderLeftAlignment(Value: Boolean);
begin
  if FHeaderLeftAlignment <> Value
  then
    begin
      FHeaderLeftAlignment := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.GetSkinData;
var
  CIndex: Integer;
begin
  inherited;
  if (FSD = nil) or FSD.Empty
  then
    CIndex := -1
  else
    CIndex := FSD.GetControlIndex('stdlabel');
  if CIndex <> -1
  then
    begin
      FSkinFontColor := TspDataSkinStdLabelControl(FSD.CtrlList.Items[CIndex]).FontColor;
      FSkinActiveFontColor := TspDataSkinStdLabelControl(FSD.CtrlList.Items[CIndex]).ActiveFontColor;
    end
  else
  if (FSD <> nil) and not FSD.Empty
  then
    begin
      FSkinFontColor := FSD.SkinColors.cBtnText;
      FSkinActiveFontColor := FSD.SkinColors.cBtnHighLight;
    end;
end;

destructor TspSkinLinkBar.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinLinkBar.SetHoldSelectedItem(Value: Boolean);
begin
  FHoldSelectedItem := Value;
  if not FHoldSelectedItem then FItemIndex := -1;
end;

procedure TspSkinLinkBar.SetSpacing;
begin
  if FSpacing <> Value
  then
    begin
      FSpacing := Value;
      RePaint;
    end;
end;

function TspSkinLinkBar.CalcHeight;
var
  H: Integer;
begin
  if AItemCount > FItems.Count then AItemCount := FItems.Count;
  H := AItemCount * ItemHeight;
  if FIndex = -1
  then
    begin
      H := H + 5;
    end
  else
    begin
      H := H + Height - RectHeight(RealClientRect) + 1;
    end;
  Result := H;  
end;

procedure TspSkinLinkBar.SetShowLines;
begin
  if FShowLines <> Value
  then
    begin
      FShowLines := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.ChangeSkinData;
var
  CIndex: Integer;
begin
  inherited;
  //
  if SkinData <> nil
  then
    CIndex := SkinData.GetControlIndex('edit');
  if CIndex = -1
  then
    FDisabledFontColor := SkinData.SkinColors.cBtnShadow
  else
    FDisabledFontColor := TspDataSkinEditControl(SkinData.CtrlList[CIndex]).DisabledFontColor;
  //
  if ScrollBar <> nil
  then
    begin
      ScrollBar.SkinData := SkinData;
      AdjustScrollBar;
    end;
  CalcItemRects;
  RePaint;
end;

procedure TspSkinLinkBar.SetItemHeight(Value: Integer);
begin
  if FItemHeight <> Value
  then
    begin
      FItemHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.SetHeaderHeight(Value: Integer);
begin
  if FHeaderHeight <> Value
  then
    begin
      FHeaderHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.SetItems(Value: TspSkinLinkBarItems);
begin
  FItems.Assign(Value);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinLinkBar.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TspSkinLinkBar.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Images) then
   FImages := nil;
end;

procedure TspSkinLinkBar.SetShowItemTitles(Value: Boolean);
begin
  if FShowItemTitles <> Value
  then
    begin
      FShowItemTitles := Value;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.DrawItem;
var
  Buffer: TBitMap;
  R: TRect;
begin
  if FIndex <> -1
  then
    SkinDrawItem(Index, Cnvs)
  else
    DefaultDrawItem(Index, Cnvs);
end;

procedure TspSkinLinkBar.CreateControlDefaultImage(B: TBitMap);
var
  I, SaveIndex: Integer;
  R: TRect;
begin
  //
  R := Rect(0, 0, Width, Height);
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  InflateRect(R, -1, -1);
  with B.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(R);
  end;
  //
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinLinkBar.CreateControlSkinImage(B: TBitMap);
var
  I, SaveIndex: Integer;
  R: TRect;
  C: TColor;
begin
  inherited;
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);

  if FShowBlurMarker
  then
  if FItemIndex <> -1
  then
    with FItems[FItemIndex] do
    begin
      R := ItemRect;
      Inc(R.Left, 5);
      Dec(R.Right, 5);
      R.Top := R.Bottom - 10;
      R.Bottom := R.Top + 10;
      C := FSD.SkinColors.cHighLight;
      DrawBlurMarker(B.Canvas, R, C);
    end;

  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinLinkBar.CalcItemRects;
var
  I: Integer;
  X, Y, W, H: Integer;
begin
  FRealMax := 0;
  if FIndex <> -1
  then
    FItemsRect := RealClientRect
  else
    FItemsRect := Rect(2, 2, Width - 2, Height - 2);
  if ScrollBar <> nil then Dec(FItemsRect.Right, ScrollBar.Width);
  X := FItemsRect.Left;
  Y := FItemsRect.Top;
  W := RectWidth(FItemsRect);
  for I := 0 to FItems.Count - 1 do
    with TspSkinLinkBarItem(FItems[I]) do
    begin
      if not Header then H := ItemHeight else H := HeaderHeight;
      if FGlowEffect and not Header then X := FItemsRect.Left + FGlowSize - 5
      else X := FItemsRect.Left;
      if X < FItemsRect.Left then X := FItemsRect.Left;
      ItemRect := Rect(X, Y, X + W, Y + H);
      OffsetRect(ItemRect, 0, - FScrollOffset);
      IsVisible := RectToRect(ItemRect, FItemsRect);
      if not IsVisible and (ItemRect.Top <= FItemsRect.Top) and
        (ItemRect.Bottom >= FItemsRect.Bottom)
      then
        IsVisible := True;
      if IsVisible then FRealMax := ItemRect.Bottom;
      Y := Y + H;
    end;
  FMax := Y;
end;

procedure TspSkinLinkBar.Scroll(AScrollOffset: Integer);
begin
  FScrollOffset := AScrollOffset;
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinLinkBar.GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
begin
  CalcItemRects;
  AMin := 0;
  AMax := FMax - FItemsRect.Top;
  APage := RectHeight(FItemsRect);
  if AMax <= APage
  then
    begin
      APage := 0;
      AMax := 0;
    end;
  APosition := FScrollOffset;
end;

procedure TspSkinLinkBar.CMMouseLeave;
begin
  inherited;
  SetItemActive(-1);
  FMouseActive := -1;
  Cursor := crDefault;
end;

procedure TspSkinLinkBar.WMSize(var Msg: TWMSize);
begin
  inherited;
  if (FOldHeight <> Height) and (FOldHeight <> -1)
  then
    begin
      CalcItemRects;
      if (FRealMax <= FItemsRect.Bottom) and (FScrollOffset > 0)
      then
        begin
          FScrollOffset := FScrollOffset - (FItemsRect.Bottom - FRealMax);
          if FScrollOffset < 0 then FScrollOffset := 0;
          CalcItemRects;
          Invalidate;
        end;
    end;
  AdjustScrollBar;
  UpdateScrollInfo;
  FOldHeight := Height;
end;

procedure TspSkinLinkBar.ScrollToItem(Index: Integer);
var
  R, R1: TRect;
begin
  CalcItemRects;
  R1 := FItems[Index].ItemRect;
  R := R1;
  OffsetRect(R, 0, FScrollOffset);
  if (R1.Top <= FItemsRect.Top)
  then
    begin
      if (Index = 1) and FItems[Index - 1].Header
      then
        FScrollOffset := 0
      else
        FScrollOffset := R.Top - FItemsRect.Top;
      CalcItemRects;
      Invalidate;
    end
  else
  if R1.Bottom >= FItemsRect.Bottom
  then
    begin
      FScrollOffset := R.Top;
      FScrollOffset := FScrollOffset - RectHeight(FItemsRect) + RectHeight(R) -
        Height + FItemsRect.Bottom + 1;
      CalcItemRects;
      Invalidate;
    end;
  UpdateScrollInfo;
end;

procedure TspSkinLinkBar.ShowScrollbar;
begin
  if ScrollBar = nil
  then
    begin
      ScrollBar := TspSkinScrollBar.Create(Self);
      ScrollBar.Visible := False;
      ScrollBar.Parent := Self;
      ScrollBar.DefaultHeight := 0;
      ScrollBar.DefaultWidth := 19;
      ScrollBar.SmallChange := ItemHeight;
      ScrollBar.LargeChange := ItemHeight;
      ScrollBar.SkinDataName := 'vscrollbar';
      ScrollBar.Kind := sbVertical;
      ScrollBar.SkinData := Self.SkinData;
      ScrollBar.OnChange := SBChange;
      AdjustScrollBar;
      ScrollBar.Visible := True;
      RePaint;
    end;
end;

procedure TspSkinLinkBar.HideScrollBar;
begin
  if ScrollBar = nil then Exit;
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  RePaint;
end;

procedure TspSkinLinkBar.UpdateScrollInfo;
var
  SMin, SMax, SPage, SPos: Integer;
begin
  GetScrollInfo(SMin, SMax, SPage, SPos);
  if SMax <> 0
  then
    begin
      if ScrollBar = nil then ShowScrollBar;
      ScrollBar.SetRange(SMin, SMax, SPos, SPage);
      ScrollBar.LargeChange := SPage;
    end
  else
  if (SMax = 0) and (ScrollBar <> nil)
  then
    begin
      HideScrollBar;
    end;
end;

procedure TspSkinLinkBar.AdjustScrollBar;
var
  R: TRect;
begin
  if ScrollBar = nil then Exit;
  if FIndex = -1
  then
    R := Rect(2, 2, Width - 2, Height - 2)
  else
    R := RealClientRect;
  Dec(R.Right, ScrollBar.Width);
  ScrollBar.SetBounds(R.Right, R.Top, ScrollBar.Width,
   RectHeight(R));
end;

procedure TspSkinLinkBar.SBChange(Sender: TObject);
begin
  Scroll(ScrollBar.Position);
end;

procedure TspSkinLinkBar.SkinDrawItem(Index: Integer; Cnvs: TCanvas);
var
  ListBoxData: TspDataSkinListBox;
  CIndex, TX, TY: Integer;
  R, R1: TRect;
  Buffer: TBitMap;
  C: TColor;
  IIndex: Integer;
  FGlowColor: TColor;
begin
  if  FItems[Index].Header
  then
    begin
      SkinDrawHeaderItem(Index, Cnvs);
      Exit;
    end;  

  CIndex := SkinData.GetControlIndex('listbox');
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  InflateRect(R, -2, -2);
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Cnvs.Brush.Style := bsClear;
  //
  if (FDisabledFontColor = ListBoxData.FontColor) and
     (FDisabledFontColor = clBlack)
  then
    FDisabledFontColor := clGray;   
  //
  if not FUseSkinFont
  then
    Cnvs.Font.Assign(FDefaultFont)
  else
    with Cnvs.Font, ListBoxData do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;



  if FItems[Index].Enabled
  then
    begin
      if (SkinDataName = 'listbox') or
         (SkinDataName = 'memo')
      then
        Cnvs.Font.Color := ListBoxData.FontColor
      else
        Cnvs.Font.Color := FSkinFontColor;
    end   
  else
    Cnvs.Font.Color := FDisabledFontColor;


  with Cnvs.Font do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
  end;

  if (FItems[Index].Active) or (FHoldSelectedItem and (FItemIndex = Index))
  then
    begin
      if FShowTextUnderLine
      then
        Cnvs.Font.Style := Cnvs.Font.Style + [fsUnderline];
      if not FGlowEffect
      then
        if (SkinDataName = 'listbox') or (SkinDataName = 'memo')
        then
          Cnvs.Font.Color := SkinData.SkinColors.cHighLight
        else
          Cnvs.Font.Color := FSkinActiveFontColor;
      IIndex := FItems[Index].ActiveImageIndex;
      if IIndex = -1 then IIndex := FItems[Index].ImageIndex;
    end
  else
    begin
      Cnvs.Font.Style := Cnvs.Font.Style - [fsUnderline];
      IIndex := FItems[Index].ImageIndex;
    end;  

   if FItems[Index].UseCustomGlowColor
   then
     FGlowColor := FItems[Index].CustomGlowColor
   else
     FGlowColor := FSkinActiveFontColor;

  //
    with FItems[Index] do
    begin
       if (FImages <> nil) and (IIndex >= 0) and
           (IIndex < FImages.Count)
        then
         begin
            if FGlowEffect and
            (FItems[Index].Active) or (FHoldSelectedItem and (FItemIndex = Index))
            then
              DrawImageAndTextGlow2(Cnvs, R, 0, FSpacing, blGlyphLeft,
               Caption, IIndex, FImages, False, Enabled, False, 0,
               FGlowColor, FGlowSize)
            else
              DrawImageAndText2(Cnvs, R, 0, FSpacing, blGlyphLeft,
               Caption, IIndex, FImages, False, Enabled, False, 0);
         end
       else
         begin
           Cnvs.Brush.Style := bsClear;
           if FShowItemTitles
           then
             Inc(R.Left, 10);
           R1 := Rect(0, 0, RectWidth(R), RectHeight(R));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R1,
             DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
           TX := R.Left;
           TY := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
           if TY < R.Top then TY := R.Top;
           R := Rect(TX, TY, TX + RectWidth(R1), TY + RectHeight(R1));
           if FGlowEffect and
             (FItems[Index].Active) or (FHoldSelectedItem and (FItemIndex = Index))
           then
             DrawEffectText2(Cnvs, R, Caption, DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT,
               0, FGlowColor, FGlowSize);
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
             DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT);
         end;

      if FShowLines
      then
        begin
          C := Cnvs.Pen.Color;
          Cnvs.Pen.Color := SkinData.SkinColors.cBtnShadow;
          Cnvs.MoveTo(FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.LineTo(FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.Pen.Color := C;
        end;
    end;
end;

procedure TspSkinLinkBar.DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
var
  R, R1: TRect;
  C, FC: TColor;
  TX, TY: Integer;
  IIndex: Integer;
  FGlowColor: TColor;
begin
  if FItems[Index].UseCustomGlowColor
  then
    FGlowColor := FItems[Index].CustomGlowColor
  else
    FGlowColor := clAqua;
  if FItems[Index].Header
  then
    begin
      C := clBtnShadow;
      FC := clBtnHighLight;
    end
  else
  if FItems[Index].Active
  then
    begin
      C := clWindow;
      if FGlowEffect
      then
        FC := clWindowText
      else
        FC := clHighLight;
     end
  else
    begin
      C := clWindow;
      if FItems[Index].Enabled
      then
        FC := clWindowText
      else
        FC := clGray;  
    end;
  //
  Cnvs.Font := FDefaultFont;
  Cnvs.Font.Color := FC;
  if FHeaderBold and  FItems[Index].Header then Cnvs.Font.Style :=  Cnvs.Font.Style + [fsBold];
  //
  if (FItems[Index].Active or (FHoldSelectedItem and (ItemIndex = Index))) and not FItems[Index].Header
  then
    begin
      if Self.ShowTextUnderLine
      then
        Cnvs.Font.Style := Cnvs.Font.Style + [fsUnderline];
      IIndex := FItems[Index].ActiveImageIndex;
      if IIndex = -1 then IIndex := FItems[Index].ImageIndex;
    end
  else
    begin
      Cnvs.Font.Style := Cnvs.Font.Style - [fsUnderline];
      IIndex := FItems[Index].ImageIndex;
    end;
  //
  R := FItems[Index].ItemRect;
  //
  Cnvs.Brush.Color := C;
  Cnvs.Brush.Style := bsSolid;
  Cnvs.FillRect(R);
  Cnvs.Brush.Style := bsClear;
  //
  InflateRect(R, -2, -2);
  if FItems[Index].Header
  then
    with FItems[Index] do
    begin
      if FHeaderLeftAlignment
      then
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_LEFT or DT_VCENTER or DT_SINGLELINE)
      else
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
  else
    with FItems[Index] do
    begin
       if (FImages <> nil) and (IIndex >= 0) and
           (IIndex < FImages.Count)
        then
         begin
           if FGlowEffect and
            (FItems[Index].Active) or (FHoldSelectedItem and (FItemIndex = Index))
            then
              DrawImageAndTextGlow2(Cnvs, R, 0, FSpacing, blGlyphLeft,
              Caption, IIndex, FImages,
               False, Enabled, False, 0, FGlowColor, FGlowSize)
           else
             DrawImageAndText2(Cnvs, R, 0, FSpacing, blGlyphLeft,
              Caption, IIndex, FImages,
               False, Enabled, False, 0);
         end
       else
         begin
           if FShowItemTitles
           then
             Inc(R.Left, 10);
           R1 := Rect(0, 0, RectWidth(R), RectHeight(R));
           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R1,
             DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
           TX := R.Left;
           TY := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
           if TY < R.Top then TY := R.Top;
           R := Rect(TX, TY, TX + RectWidth(R1), TY + RectHeight(R1));
           if FGlowEffect and
             (FItems[Index].Active) or (FHoldSelectedItem and (FItemIndex = Index))
           then
             DrawEffectText2(Cnvs, R, Caption, DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT,
               0, FGlowColor, FGlowSize);

           DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
             DT_WORDBREAK or DT_LEFT);
         end;
      if FShowLines
      then
        begin
          C := Cnvs.Pen.Color;
          Cnvs.Pen.Color := clBtnFace;
          Cnvs.MoveTo(FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.LineTo(FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom - 1);
          Cnvs.Pen.Color := C;
        end;
    end;
end;

procedure TspSkinLinkBar.SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);
var
  Buffer: TBitMap;
  CIndex: Integer;
  LData: TspDataSkinLabelControl;
  R, TR: TRect;
  CPicture: TBitMap;
begin
  CIndex := SkinData.GetControlIndex(FHeaderSkinDataName);
  if CIndex = -1
  then
    CIndex := SkinData.GetControlIndex('label');
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  LData := TspDataSkinLabelControl(SkinData.CtrlList[CIndex]);
  CPicture := TBitMap(FSD.FActivePictures.Items[LData.PictureIndex]);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  with LData do
  begin
    CreateStretchImage(Buffer, CPicture, SkinRect, ClRect, True);
  end;

  TR := Rect(1, 1, Buffer.Width - 1, Buffer.Height - 1);

  if FHeaderLeftAlignment then TR.Left := LData.ClRect.Left;

  with Buffer.Canvas, LData do
  begin
    Font.Name := FontName;
    Font.Color := FontColor;
    Font.Height := FontHeight;
    Font.Style := FontStyle;
    if FHeaderBold then  Font.Style :=  Font.Style + [fsBold];
    Brush.Style := bsClear;
  end;
  with FItems[Index] do
   if FHeaderLeftAlignment
   then
     DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
      DT_LEFT or DT_VCENTER or DT_SINGLELINE)
   else
     DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
      DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  Cnvs.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
end;


procedure TspSkinLinkBar.SetItemIndex(Value: Integer);
var
  I: Integer;
  IsFind: Boolean;
begin
  if (csDesigning in ComponentState) and not FHoldSelectedItem
  then
    begin
      FItemIndex := -1;
      Exit;
    end;

  FItemIndex := Value;

  if FItemIndex < 0
  then
    begin
      FItemIndex := -1;
      RePaint;
      Exit;
    end;

    if (FItemIndex >= 0) and (FItemIndex < FItems.Count) and not
       (csDesigning in ComponentState)
    then
     begin
      IsFind := False;
      for I := 0 to FItems.Count - 1 do
        with FItems[I] do
        begin
          if I = FItemIndex
          then
            begin
              Active := True;
              IsFind := True;
            end
          else
             Active := False;
        end;
      RePaint;
      ScrollToItem(FItemIndex);
      if IsFind then
      begin
        if Assigned(FItems[FItemIndex].OnClick) then
          FItems[FItemIndex].OnClick(Self);
        if Assigned(FOnItemClick) then
          FOnItemClick(Self);
      end;    
    end;
end;

procedure TspSkinLinkBar.Loaded;
begin
  inherited;
end;

function TspSkinLinkBar.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(FItems[I].ItemRect, Point(X, Y)) and (FItems[I].Enabled)
    then
      begin
        Result := I;
        Break;
      end;
end;

procedure TspSkinLinkBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft)
  then
    begin
      SetItemActive(I);
      if FHoldSelectedItem
      then
        begin
          ItemIndex := I;
        end;
      FMouseDown := True;
      FMouseActive := I;
    end;
end;

procedure TspSkinLinkBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  FMouseDown := False;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft) and
     not FHoldSelectedItem
  then
    ItemIndex := I;
end;

procedure TspSkinLinkBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1)and FItems[I].Header then I := -1;
  if (I <> -1) and (I <> FMouseActive)
  then
    begin
      SetItemActive(I);
      FMouseActive := I;
      Cursor := crHandPoint;
    end
  else
  if (I = -1) and (I <> FMouseActive)
  then
    begin
      SetItemActive(-1);
      Cursor := crDefault;
      FMouseActive := -1;
    end;
end;

procedure TspSkinLinkBar.SetItemActive(Value: Integer);
var
  I: Integer;
begin

  if not FHoldSelectedItem then FItemIndex := Value;

  if not FHoldSelectedItem and (FItemIndex = -1)
  then
    begin
      for I := 0 to FItems.Count - 1 do FItems[I].Active := False;
      RePaint;
      Exit;
    end;

  for I := 0 to FItems.Count - 1 do
  with FItems[I] do
   if I = Value then Active := True else Active := False;
  RePaint;
end;

procedure TspSkinLinkBar.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
end;


// TspSkinVistaGlowLabel========================================================

constructor TspSkinVistaGlowLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque] + [csReplicatable];
  Width := 65;
  Height := 17;
  FAutoSize := True;
  FShowAccelChar := True;
  FDoubleBuffered := False;
  FGlowColor := clWhite;
  FGlowSize := 10;
end;

procedure TspSkinVistaGlowLabel.SetGlowColor(Value: TColor);
begin
  if Value <> FGlowColor
  then
    begin
      FGlowColor := Value;
      RePaint;
    end;
end;

procedure TspSkinVistaGlowLabel.SetDoubleBuffered;
begin
  if Value <> FDoubleBuffered
  then
    begin
      FDoubleBuffered := Value;
      if FDoubleBuffered
      then ControlStyle := ControlStyle + [csOpaque]
      else ControlStyle := ControlStyle - [csOpaque];
    end;
end;

function TspSkinVistaGlowLabel.GetLabelText: string;
begin
  Result := Caption;
end;

procedure TspSkinVistaGlowLabel.WMMOVE;
begin
  inherited;
  if FDoubleBuffered then RePaint;
end;

procedure TspSkinVistaGlowLabel.DoDrawText(Cnvs: TCanvas; var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Windows.DrawText(Cnvs.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TspSkinVistaGlowLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Text: string;
  Flags: Longint;
  R: TRect;
  FBuffer: TspBitmap;
begin
  //
  Canvas.Font := Self.Font;
  //
  Text := GetLabelText;
  R := Rect(FGlowSize, FGlowSize,
            Width - FGlowSize, Height - FGlowSize);
  if R.Left < 0 then R.Left := 0;
  if R.Top < 0 then R.Top := 0;
  Flags := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  if FDoubleBuffered
  then
    begin
      FBuffer := TspBitmap.Create;
      FBuffer.SetSize(Width, Height);
      GetParentImage(Self, FBuffer.Canvas);
      FBuffer.Canvas.Font := Self.Font;
      DrawVistaEffectText(FBuffer.Canvas, R, Text, Flags, FGlowColor);
      FBuffer.Draw(Canvas.Handle, 0, 0);
      FBuffer.Free;
    end
  else
    DrawVistaEffectText(Canvas, R, Text, Flags, FGlowColor);
end;

procedure TspSkinVistaGlowLabel.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TspSkinVistaGlowLabel.AdjustBounds;
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
    Canvas.Font := Self.Font;
    Rect := ClientRect;
    DC := GetDC(0);
    Canvas.Handle := DC;
    DoDrawText(Canvas, Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    Canvas.Handle := 0;
    ReleaseDC(0, DC);
    X := Left;
    AAlignment := FAlignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
    if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
    Rect.Right := Rect.Right + FGlowSize * 2 + 8;
    Rect.Bottom := Rect.Bottom + FGlowSize * 2 + 8;
    SetBounds(X, Top, Rect.Right, Rect.Bottom);
  end;
end;

procedure TspSkinVistaGlowLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RePaint;
  end;
end;

procedure TspSkinVistaGlowLabel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TspSkinVistaGlowLabel.SetFocusControl(Value: TWinControl);
begin
  FFocusControl := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TspSkinVistaGlowLabel.SetShowAccelChar(Value: Boolean);
begin
  if FShowAccelChar <> Value then
  begin
    FShowAccelChar := Value;
    RePaint;
  end;
end;

procedure TspSkinVistaGlowLabel.SetLayout(Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RePaint;
  end;
end;

procedure TspSkinVistaGlowLabel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    AdjustBounds;
    RePaint;
  end;
end;

procedure TspSkinVistaGlowLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TspSkinVistaGlowLabel.CMTextChanged(var Message: TMessage);
begin
  AdjustBounds;
  RePaint;
end;

procedure TspSkinVistaGlowLabel.CMFontChanged(var Message: TMessage);
begin
  AdjustBounds;
  RePaint;
end;

procedure TspSkinVistaGlowLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FFocusControl <> nil) and Enabled and ShowAccelChar and
    IsAccel(Message.CharCode, Caption) then
    with FFocusControl do
      if CanFocus then
      begin
        SetFocus;
        Message.Result := 1;
      end;
end;

procedure TspSkinVistaGlowLabel.ChangeSkinData;
begin
  inherited;
  if (FSD <> nil) and (not FSD.Empty)
  then
    begin
      GlowColor := FSD.SkinColors.cHighLight;
      RePaint;
    end;
end;

// TspSkinToolBarEx ============================================================

constructor TspSkinToolBarExItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FHint := '';
  FCaption := '';
  FImageIndex := -1;
  FActiveImageIndex := -1;
  FEnabled := True;
  IsVisible := True;
  Active := False;
  FUseCustomGlowColor := False;
  FCustomGlowColor := clAqua;
  FReflectionBitmap := TspBitmap.Create;
  FReflectionActiveBitmap := TspBitmap.Create;
end;

destructor TspSkinToolBarExItem.Destroy;
begin
  FReflectionBitmap.Free;
  FReflectionActiveBitmap.Free;
  inherited;
end;

procedure TspSkinToolBarExItem.InitReflectionBitmaps;
var
  IL: TspPngImageList;
begin
  FReflectionBitmap.SetSize(0, 0);
  FReflectionActiveBitmap.SetSize(0, 0);
  if (Collection <> nil) and (TspSkinToolBarExItems(Collection).ToolBarEx <> nil)
     and
     (TspSkinToolBarExItems(Collection).ToolBarEx.FImages <> nil)
  then
    begin
      IL := TspSkinToolBarExItems(Collection).ToolBarEx.FImages;
      if (FImageIndex >= 0) and (FImageIndex < IL.Count)
      then
        with TspPngImageList(IL) do
        begin
          MakeCopyFromPng(FReflectionBitmap,
          PngImages.Items[Self.FImageIndex].PngImage);
          if FEnabled
          then
            FReflectionBitmap.Reflection
          else
            FReflectionBitmap.Reflection2;
        end;
      if (FActiveImageIndex >= 0) and (FActiveImageIndex < IL.Count)
      then
        with TspPngImageList(IL) do
        begin
          MakeCopyFromPng(FReflectionActiveBitmap,
          PngImages.Items[Self.FActiveImageIndex].PngImage);
          FReflectionActiveBitmap.Reflection;
        end;
   end;
end;

procedure TspSkinToolBarExItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinToolBarExItem then
  begin
    FImageIndex := TspSkinToolBarExItem(Source).ImageIndex;
    FActiveImageIndex := TspSkinToolBarExItem(Source).ActiveImageIndex;
    FEnabled := TspSkinToolBarExItem(Source).Enabled;
    FHint := TspSkinToolBarExItem(Source).Hint;
    FUseCustomGlowColor := TspSkinToolBarExItem(Source).UseCustomGlowColor;
    FCaption := TspSkinToolBarExItem(Source).Caption;
    FCustomGlowColor := TspSkinToolBarExItem(Source).CustomGlowColor;
   end
 else
   inherited Assign(Source);
end;

procedure TspSkinToolBarExItem.SetCaption(Value: String);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TspSkinToolBarExItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  InitReflectionBitmaps;
  Changed(False);
end;

procedure TspSkinToolBarExItem.SetActiveImageIndex(const Value: TImageIndex);
begin
  FActiveImageIndex := Value;
  InitReflectionBitmaps;
  Changed(False);
end;

procedure TspSkinToolBarExItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  InitReflectionBitmaps;
  Changed(False);
end;

constructor TspSkinToolBarExItems.Create;
begin
  inherited Create(TspSkinToolBarExItem);
  ToolBarEx := AListBox;
end;

function TspSkinToolBarExItems.GetOwner: TPersistent;
begin
  Result := ToolBarEx;
end;

procedure  TspSkinToolBarExItems.Update(Item: TCollectionItem);
begin
  ToolBarEx.Repaint;
end; 

function TspSkinToolBarExItems.GetItem(Index: Integer):  TspSkinToolBarExItem;
begin
  Result := TspSkinToolBarExItem(inherited GetItem(Index));
end;

procedure TspSkinToolBarExItems.SetItem(Index: Integer; Value:  TspSkinToolBarExItem);
begin
  inherited SetItem(Index, Value);
  ToolBarEx.RePaint;
end;

function TspSkinToolBarExItems.Add: TspSkinToolBarExItem;
begin
  Result := TspSkinToolBarExItem(inherited Add);
  ToolBarEx.RePaint;
end;

function TspSkinToolBarExItems.Insert(Index: Integer): TspSkinToolBarExItem;
begin
  Result := TspSkinToolBarExItem(inherited Insert(Index));
  ToolBarEx.RePaint;
end;

procedure TspSkinToolBarExItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  ToolBarEx.RePaint;
end;

procedure TspSkinToolBarExItems.Clear;
begin
  inherited Clear;
  ToolBarEx.RePaint;
end;

constructor TspSkinToolBarEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csAcceptsControls];
  FMenuExPosition := spmpAuto;
  FShowGlow := True;
  FShowCaptions := False;
  FItemIndex := -1;
  FHoldSelectedItem := False;
  FShowBorder := True;
  FAutoSize := False;
  FShowHandPointCursor := False;
  FSkinHint := nil;
  FShowItemHints := False;
  FItemSpacing := 10;
  FItems := TspSkinToolBarExItems.Create(Self);
  Height := 50;
  Width := 300;
  FImages := nil;
  FArrowImages := nil;
  FSkinDataName := 'resizetoolpanel';
  FShowActiveCursor := True;
  MouseInItem := -1;
  OldMouseInItem := -1;
  FScrollIndex := 0;
  FScrollMax := 0;

  Buttons[0].MouseIn := False;
  Buttons[1].MouseIn := False;

end;

destructor TspSkinToolBarEx.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinToolBarEx.SetShowCaptions;
begin
  FShowCaptions := Value;
  RePaint;
end;

procedure TspSkinToolBarEx.BeginUpdateItems;
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TspSkinToolBarEx.EndUpdateItems;
begin
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  Repaint;
end;


procedure TspSkinToolBarEx.UpdatedSelected;
begin
  TestActive(-1, -1);
end;

procedure TspSkinToolBarEx.SetShowGlow;
begin
  if Value <> FShowGlow
  then
    begin
       FShowGlow := Value;
       if FHoldSelectedItem then RePaint;
    end;
end;

procedure TspSkinToolBarEx.SetItemIndex;
var
  OldValue: Integer;
begin
  OldValue := FItemIndex;
  FItemIndex := Value;
  if (OldValue <> FItemIndex) then RePaint;
  if (FItemIndex >= 0) and (FItemIndex < FItems.Count) and
     not (csDesigning in ComponentState) and
     not (csLoading in ComponentState)
  then
    begin
      if Assigned(FItems[FItemIndex].OnClick)
      then
        FItems[FItemIndex].OnClick(Self);
        if (OldValue <> FItemIndex) and Assigned(FOnChange)
        then
          FOnChange(Self);
     end;
end;

procedure TspSkinToolBarEx.SetShowBorder(Value: Boolean);
begin
  if Value <> FShowBorder
  then
    begin
      FShowBorder := Value;
      RePaint;
    end;
end;

procedure TspSkinToolBarEx.AdjustBounds;
begin
  if FImages = nil
  then
    Exit
  else
     Height := 10 + FImages.Height + FImages.Height div 2 + 2;
end;

procedure TspSkinToolBarEx.SetAutoSize;
begin
  FAutoSize := Value;
  if FAutoSize then AdjustBounds;
end;

procedure TspSkinToolBarEx.Loaded; 
var
  i: Integer;
begin
  inherited;
  for i := 0 to FItems.Count - 1 do FItems[I].InitReflectionBitmaps;
end;

procedure TspSkinToolBarEx.SetItemSpacing;
begin
  if (Value >= 0) and (Value <> FItemSpacing)
  then
    begin
      FItemSpacing := Value;
      RePaint;
    end;
end;


function TspSkinToolBarEx.GetVisibleCount: Integer;
var
  i, j: Integer;

begin
  j := 0;
  for i := 0 to FItems.Count - 1 do
    if FItems[i].IsVisible then Inc(j);
  Result := j;
  if Result = 0 then Result := 1;
end;

procedure TspSkinToolBarEx.CalcItemRects;
var
  i, X, Y, Count: Integer;
begin
  if FImages = nil then Exit;
  Count := GetVisibleCount;
  X := Count * FImages.Width + (FItemSpacing * (Count - 1));
  X := Width div 2 - X div 2;
  if X < 2 then X := 2;
  Y := 10;
  for i := 0 to FItems.Count - 1 do
  with FItems[i] do
  if IsVisible then
  begin
    ItemRect := Rect(X, Y, X + FImages.Width, Y + FImages.Height);
    X := X + FImages.Width + FItemSpacing;
  end;
  if FArrowImages = nil
  then
    begin
      Buttons[0].R := Rect(2, Y + FImages.Height, 9, Height);
      Buttons[1].R := Rect(Width - 9, Y + FImages.Height, Width - 2, Height);
      if FShowCaptions
      then
        begin
          Buttons[0].R.Top := Buttons[0].R.Bottom - 20;
          Buttons[1].R.Top := Buttons[1].R.Bottom - 20;
        end;
    end
  else
    begin
      Buttons[0].R := Rect(2, Y + FImages.Height, 2 + FArrowImages.PngWidth, Height);
      Buttons[1].R := Rect(Width - 2 - FArrowImages.PngWidth, Y + FImages.Height, Width - 2, Height);
      if FShowCaptions
      then
        begin
          Buttons[0].R.Top := Buttons[0].R.Bottom - FArrowImages.Height - 3;
          Buttons[1].R.Top := Buttons[1].R.Bottom - FArrowImages.Height - 3;
        end;
    end;
end;

procedure TspSkinToolBarEx.DrawItem;
var
  C: TColor;
  R: TRect;
  B: TspBitMap;
  i, j: Integer;
begin
  if (FItems[Index].Active or ((Index = ItemIndex) and FHoldSelectedItem)) and
      FShowGlow
  then
    begin
      i := -1;

      if (FItems[Index].ActiveImageIndex >= 0) and
         (FItems[Index].ActiveImageIndex < FImages.Count)
      then
        i := FItems[Index].ActiveImageIndex
      else
      if (FItems[Index].ImageIndex >= 0) and
         (FItems[Index].ImageIndex < FImages.Count)
      then
        i := FItems[Index].ImageIndex;

      if i = -1 then Exit;  

      B := TspBitMap.Create;
      B.SetSize(Images.Width + 20, Images.Height + 20);

      MakeBlurBlank(B, FImages.PngImages.Items[i].PngImage, 10);
      //

      Blur(B, 10);
      
     if (FIndex <> -1) and not FSD.Empty
      then
        begin
          if FItems[Index].UseCustomGlowColor
          then
            C := FItems[Index].CustomGlowColor
          else
            C := FSD.SkinColors.cHighLight
        end  
      else
        C := clAqua;
        
      for i := 0 to B.Width - 1 do
        for j := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(C) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
      //
      B.Draw(Cnvs, FItems[Index].ItemRect.Left - 10,
        FItems[Index].ItemRect.Top - 10);
      B.Reflection3;
      B.Draw(Cnvs, FItems[Index].ItemRect.Left - 10,
        FItems[Index].ItemRect.Bottom - 10);
      B.Free;
    end;
  //

  if (FItems[Index].Active or ((Index = ItemIndex) and FHoldSelectedItem))
      and (FItems[Index].ActiveImageIndex >= 0) and
     (FItems[Index].ActiveImageIndex < FImages.Count)
  then
    begin
      FImages.Draw(Cnvs, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].FActiveImageIndex, True);
      if not FItems[Index].FReflectionActiveBitmap.Empty
      then
        FItems[Index].FReflectionActiveBitmap.Draw(Cnvs, FItems[Index].ItemRect.Left,
        FItems[Index].ItemRect.Bottom);
    end
  else
  if (FItems[Index].ImageIndex >= 0) and (FItems[Index].ImageIndex < FImages.Count)
  then
    begin
      FImages.Draw(Cnvs, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].FImageIndex, FItems[Index].Enabled);
      if not FItems[Index].FReflectionBitmap.Empty
      then
        begin
          FItems[Index].FReflectionBitmap.Draw(Cnvs, FItems[Index].ItemRect.Left,
              FItems[Index].ItemRect.Bottom)
        end;    
    end;

  // draw caption
  if FShowCaptions then
  with Cnvs do
  begin
    Cnvs.Brush.Style := bsClear;
    if FIndex <> -1 then
    begin
      if FItems[Index].Enabled and Self.Enabled
      then
        Cnvs.Font.Color := FSD.SkinColors.cBtnText
      else
        Cnvs.Font.Color := MiddleColor(FSD.SkinColors.cBtnText, FSD.SkinColors.cBtnFace);
    end  
    else
      begin
        if FItems[Index].Enabled and Self.Enabled
        then
          Cnvs.Font.Color := clBtnText
        else
          Cnvs.Font.Color := clBtnShadow;
      end;  
    R := FItems[Index].ItemRect;
    R.Left := R.Left - FItemSpacing div 2;
    R.Right := R.Right + FItemSpacing div 2;
    R.Top := R.Bottom + 10;
    R.Bottom := Height;
    DrawText(Cnvs.Handle, PChar(FItems[Index].Caption), Length(FItems[Index].Caption), R,
      DT_CENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
  end;
  //

  if ((FItems[Index].Active and not FHoldSelectedItem) or
      (Index = ItemIndex) and FHoldSelectedItem)
     and FShowActiveCursor
  then
    begin
      if FItems[Index].UseCustomGlowColor
      then
        C:= FItems[Index].CustomGlowColor
      else  
      if (FIndex <> -1) and not FSD.Empty
      then
        C := FSD.SkinColors.cHighLight
      else
        C := clAqua;
      R := FItems[Index].ItemRect;
      R.Top := Height - 20;
      R.Bottom := Height;
      DrawBlurMarker(Cnvs, R, C);
    end;

end;

procedure TspSkinToolBarEx.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then FImages := nil;
  if (Operation = opRemove) and (AComponent = FArrowImages) then FArrowImages := nil;
  if (Operation = opRemove) and (AComponent = FSkinHint) then FSkinHint := nil;
end;


procedure TspSkinToolBarEx.SetItems(Value: TspSkinToolBarExItems);
begin
  FItems.Assign(Value);
  RePaint;
end;

procedure TspSkinToolBarEx.SetImages(Value: TspPngImageList);
begin
  FImages := Value;
end;

procedure TspSkinToolBarEx.SetArrowImages(Value: TspPngImageList);
begin
  if FArrowImages <> Value
  then
    begin
      FArrowImages := Value;
      RePaint;
    end;
end;

procedure TspSkinToolBarEx.CreateControlDefaultImage(B: TBitMap);
var
  i: Integer;
begin
  inherited;
  if FShowBorder then
  Frm3D(B.Canvas, Rect(0, 0, Width, Height), clBtnShadow, clBtnShadow);
  if FImages = nil then Exit;
  CheckScroll;
  CalcItemRects;
  B.Canvas.Font.Assign(Self.Font);
  if FItems.Count > 0
  then
    for i := 0 to FItems.Count - 1 do
      if FItems[I].IsVisible then DrawItem(B.Canvas, I);

  if FScrollMax <> 0
  then
    DrawButtons(B.Canvas);
    
end;

procedure TspSkinToolBarEx.CreateControlSkinImage(B: TBitMap);
var
  i: Integer;
begin
  if FShowBorder
  then
    inherited
  else
    CreateSkinBG(ClRect, Rect(0, 0, Width, Height),
      B, Picture, SkinRect, Width, Height, StretchEffect, StretchType);
  if FImages = nil then Exit;
  CheckScroll;
  CalcItemRects;
  B.Canvas.Font.Assign(Self.Font);
  if FItems.Count > 0
  then
    for i := 0 to FItems.Count - 1 do
      if FItems[I].IsVisible then DrawItem(B.Canvas, I);

  if FScrollMax <> 0
  then
    DrawButtons(B.Canvas);
    
end;

function TspSkinToolBarEx.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(FItems[I].ItemRect, Point(X, Y)) and (FItems[I].Enabled) and
       (FItems[I].IsVisible)
    then
      begin
        Result := I;
        Break;
      end;  
end;

procedure TspSkinToolBarEx.TestActive(X, Y: Integer);
var
  P: TPoint;
  R: TRect;
begin
  MouseInItem := ItemAtPos(X, Y);
  if (FSkinHint <> nil) and (MouseInItem = -1) and FShowItemHints
  then
    FSkinHint.HideHint;
  if (MouseInItem <> OldMouseInItem)
  then
    begin
      if OldMouseInItem <> -1 then FItems[OldMouseInItem].Active := False;
      OldMouseInItem := MouseInItem;
      if MouseInItem <> -1 then FItems[MouseInItem].Active := True;
      RePaint;
      if FShowHandPointCursor
      then
        begin
          if MouseInItem <> -1
          then
            Cursor := crHandPoint
          else
            Cursor := crDefault;
        end;
      if FShowItemHints and (MouseInItem <> -1) and (FSkinHint <> nil)
      then
        begin
          FSkinHint.HideHint;
          with FItems[MouseInItem] do
          begin
            if Hint <> ''
            then
              begin
                P := ClientToScreen(Point(0, 0));
                P.X := P.X + FItems[MouseInItem].ItemRect.Left;
                R := Rect(P.X, P.Y, P.X + RectWidth(FItems[MouseInItem].ItemRect),
                P.Y + Self.Height);
                FSkinHint.ActivateHint3(R, Hint, Align = alBottom);
              end;
           end;
        end;
    end;
end;

procedure TspSkinToolBarEx.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  if FShowItemHints and (FSkinHint <> nil) then FSkinHint.HideHint;
  if FHoldSelectedItem and (Button = mbLeft)
  then
    begin
      I := ItemAtPos(X, Y);
      if I <> -1 then ItemIndex := I;
    end;
end;

procedure TspSkinToolBarEx.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  inherited;
  TestActive(X, Y);
  //
  if FScrollMax <> 0
  then
    for i := 0 to 1 do
    begin
      if PtInRect(Buttons[i].R, Point(X, Y))
      then
        begin
          if not Buttons[i].MouseIn
          then
             begin
              Buttons[i].MouseIn := True;
              RePaint;
            end;
         end
       else
       if Buttons[i].MouseIn
       then
         begin
           Buttons[i].MouseIn := False;
           RePaint;
         end;
    end;
end;

procedure TspSkinToolBarEx.CMMouseLeave;
begin
  inherited;
  TestActive(-1, -1);
end;

procedure TspSkinToolBarEx.CMMouseEnter;
begin
  inherited;
end;

procedure TspSkinToolBarEx.MouseUp(Button: TMouseButton; Shift: TShiftState;
           X, Y: Integer); 
var
  I: Integer;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      I := ItemAtPos(X, Y);
      if (I <> -1) and not FHoldSelectedItem
      then
        begin
          ItemIndex := I;
        end
      else
      if FScrollMax <> 0
      then
        begin
          if PtInRect(Buttons[0].R, Point(X, Y))
          then
            DecScroll
          else
          if PtInRect(Buttons[1].R, Point(X, Y))
          then
            IncScroll;
        end;
    end;
end;

procedure TspSkinToolBarEx.CheckScroll;
var
  i, j, X, Y: Integer;
  W, Count: Integer;
begin
  if FImages = nil then Exit;

  Count := 0;

  X := 2;
  
  for i := 0 to FItems.Count - 1 do
  begin
    if X + FImages.Width <= Width - 2
    then
      Inc(Count);
    X := X + FImages.Width + FItemSpacing;
  end;

  if FItems.Count > Count
  then
    FScrollMax := FItems.Count - Count           
  else
    begin
      FScrollMax := 0;
      FScrollIndex := 0;
      Buttons[0].MouseIn := False;
      Buttons[1].MouseIn := False;
    end;

  if FScrollIndex <> 0
  then
    begin
      if FScrollIndex + Count > FItems.Count
      then
        Dec(FScrollIndex, FScrollIndex + Count - FItems.Count);
      if FScrollIndex < 0 then FScrollIndex := 0;
    end;

  if Count = 0
  then
    begin
      for i := 0 to FItems.Count - 1 do
        FItems[i].IsVisible := False;
    end
  else
  for i := 0 to FItems.Count - 1 do
    if FScrollMax <> 0
    then
      FItems[i].IsVisible := (i >= FScrollIndex) and (i < FScrollIndex + Count)
    else
      FItems[i].IsVisible := True;
end;

procedure TspSkinToolBarEx.DecScroll;
begin
  if FScrollMax <> 0
  then
    begin
      Dec(FScrollIndex);
      if FScrollIndex < 0 then FScrollIndex := 0;
    end
  else
    FScrollIndex := 0;
  RePaint;
end;

procedure TspSkinToolBarEx.IncScroll;
begin
 if FScrollMax <> 0
  then
    begin
      Inc(FScrollIndex);
      if FScrollIndex > FScrollMax then FScrollIndex := FScrollMax;
    end
  else
    FScrollIndex := 0;
  RePaint;
end;

procedure TspSkinToolBarEx.GetSkinData;
var
  CIndex: Integer;
begin
  inherited;
  if (FSD = nil) or FSD.Empty
  then
    CIndex := -1
  else
    CIndex := FSD.GetControlIndex('stdlabel');
  if CIndex <> -1
  then
    begin
      FSkinArrowColor := TspDataSkinStdLabelControl(FSD.CtrlList.Items[CIndex]).FontColor;
      FSkinActiveArrowColor := TspDataSkinStdLabelControl(FSD.CtrlList.Items[CIndex]).ActiveFontColor;
    end
  else
  if (FSD <> nil) and not FSD.Empty
  then
    begin
      FSkinArrowColor := FSD.SkinColors.cBtnText;
      FSkinActiveArrowColor := FSD.SkinColors.cBtnHighLight;
    end;
end;

procedure TspSkinToolBarEx.DrawButtons;
var
  R: TRect;
  C: TColor;
  i, j, y: Integer;
begin
  if (FArrowImages <> nil) and (FArrowImages.Count >= 2)
  then
    begin
      for i := 0 to 1 do
      begin
        R := Buttons[i].R;
        if Buttons[i].MouseIn
        then
          begin
            j := i + 2;
            if j > FArrowImages.Count - 1 then j := i;
          end
        else
          j := i;
        y := R.Top + RectHeight(R) div 2 - FArrowImages.PngHeight div 2;
        FArrowImages.Draw(Cnvs, R.Left + 2, y, j, True);
      end;
    end
  else
  if FIndex <> -1
  then
    begin
      for i := 0 to 1 do
      begin
        R := Buttons[i].R;
        if Buttons[i].MouseIn
        then
          C := Self.FSkinActiveArrowColor
        else
          C := FSkinArrowColor;
        DrawArrowImage(Cnvs, R, C, i + 1);
      end;   
    end
  else
    begin
      for i := 0 to 1 do
      begin
        R := Buttons[i].R;
        if Buttons[i].MouseIn
        then
          C := clBtnText
        else
          C := clBtnHighLight;
         DrawArrowImage(Cnvs, R, C, i + 1);
      end;
    end;  
end;

// TspSkinMenuEx ===============================================================

constructor TspSkinMenuExItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FActiveImageIndex := -1;
  FHint := '';
  FUseCustomGlowColor := False;
  FCustomGlowColor := clAqua;
end;

procedure TspSkinMenuExItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinMenuExItem then
  begin
    FImageIndex := TspSkinMenuExItem(Source).ImageIndex;
    FActiveImageIndex := TspSkinMenuExItem(Source).ActiveImageIndex;
    FUseCustomGlowColor := TspSkinMenuExItem(Source).FUseCustomGlowColor;
    FCustomGlowColor := TspSkinMenuExItem(Source).FCustomGlowColor;
    FHint := TspSkinMenuExItem(Source).Hint;
  end
  else
    inherited Assign(Source);
end;

procedure TspSkinMenuExItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
end;

procedure TspSkinMenuExItem.SetActiveImageIndex(const Value: TImageIndex);
begin
  FActiveImageIndex := Value;
end;

constructor TspSkinMenuExItems.Create;
begin
  inherited Create(TspSkinMenuExItem);
  MenuEx := AMenuEx;
end;

function TspSkinMenuExItems.GetOwner: TPersistent;
begin
  Result := MenuEx;
end;

function TspSkinMenuExItems.GetItem(Index: Integer):  TspSkinMenuExItem;
begin
  Result := TspSkinMenuExItem(inherited GetItem(Index));
end;

procedure TspSkinMenuExItems.SetItem(Index: Integer; Value:  TspSkinMenuExItem);
begin
  inherited SetItem(Index, Value);
end;

constructor TspSkinMenuEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TspSkinMenuExItems.Create(Self);
  FShowActiveCursor := True;
  FShowGlow := True;
  FShowHints := True;
  FItemIndex := -1;
  FColumnsCount := 1;
  FSkinHint := nil;
  FOnItemClick := nil;
  FSkinData := nil;
  FPopupWindow := nil;
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
  ToolBarEx := nil;
end;

function TspSkinMenuEx.GetSelectedItem;
begin
  if (ItemIndex >=0) and (ItemIndex < FItems.Count)
  then
    Result := FItems[ItemIndex]
  else
    Result := nil;
end;

procedure TspSkinMenuEx.SetSkinData;
begin
  FSkinData := Value;
end;

destructor TspSkinMenuEx.Destroy;
begin
  if FPopupWindow <> nil then FPopupWindow.Free;
  FDefaultFont.Free;
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinMenuEx.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;


procedure TspSkinMenuEx.SetColumnsCount(Value: Integer);
begin
  if (Value > 0) and (Value < 51)
  then
    FColumnsCount := Value;
end;

procedure TspSkinMenuEx.SetItems(Value: TspSkinMenuExItems);
begin
  FItems.Assign(Value);
end;

procedure TspSkinMenuEx.Notification(AComponent: TComponent;
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

procedure TspSkinMenuEx.SetImages;
begin
  FImages := Value;
end;

procedure TspSkinMenuEx.Popup(AToolBarEx: TspSkinToolBarEx);
begin
  ToolBarEx := AToolBarEx;
  Popup(0, 0);
end;

procedure TspSkinMenuEx.Popup(X, Y: Integer);
begin
  if FPopupWindow <> nil then FPopupWindow.Hide(False);

  if Assigned(FOnMenuPopup) then FOnMenuPopup(Self);

  if (FImages = nil) or (FImages.Count = 0) then Exit;
  FOldItemIndex := ItemIndex;
  FPopupWindow := TspSkinMenuExPopupWindow.Create(Self);
  FPopupWindow.Show(Rect(X, Y, X, Y));
end;

procedure TspSkinMenuEx.ProcessEvents;
begin
  if FPopupWindow = nil then Exit;
  FPopupWindow.Free;
  FPopupWindow := nil;
  if ToolBarEx <> nil then ToolBarEx.UpdatedSelected;
  ToolBarEx := nil;

  if Assigned(FOnInternalMenuClose)
  then
    FOnInternalMenuClose(Self);

  if Assigned(FOnMenuClose)
  then
    FOnMenuClose(Self);

  if ACanProcess and (ItemIndex <> -1)
  then
   begin
      if Assigned(FItems[ItemIndex].OnClick)
      then
        FItems[ItemIndex].OnClick(Self);
      if Assigned(FOnItemClick) then FOnItemClick(Self);

      if (FOldItemIndex <> ItemIndex) and
         Assigned(FOnInternalChange) then FOnInternalChange(Self);

      if (FOldItemIndex <> ItemIndex) and
         Assigned(FOnChange) then FOnChange(Self);
    end;
end;

procedure TspSkinMenuEx.Hide;
begin
  if FPopupWindow <> nil then FPopupWindow.Hide(False);
  if ToolBarEx <> nil then ToolBarEx.UpdatedSelected;
end;

constructor TspSkinMenuExPopupWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  MenuEx := TspSkinMenuEx(AOwner);
  FRgn := 0;
  WindowPicture := nil;
  MaskPicture := nil;
  FSkinSupport := False;
  MouseInItem := -1;
  OldMouseInItem := -1;
  FDown := False;
  FItemDown := False;
end;

destructor TspSkinMenuExPopupWindow.Destroy;
begin
  inherited Destroy;
  if FRgn <> 0 then DeleteObject(FRgn);
end;

procedure TspSkinMenuExPopupWindow.FindUp;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := MenuEx.Items.Count  - 1;
    RePaint;
    Exit;
  end;
  for I := MouseInItem - 1 downto 0 do
   begin
   if  (MenuEx.Items[I].ItemRect.Top <
        MenuEx.Items[MouseInItem].ItemRect.Top) and
       (MenuEx.Items[I].ItemRect.Left =
        MenuEx.Items[MouseInItem].ItemRect.Left)
    then
      begin
        MouseInItem := I;
        RePaint;
        Break;
      end;
  end;
end;

procedure TspSkinMenuExPopupWindow.FindDown;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := 0;
    RePaint;
    Exit;
  end;

  for I := MouseInItem + 1 to MenuEx.Items.Count - 1 do
  begin
    if (MenuEx.Items[I].ItemRect.Top >
       MenuEx.Items[MouseInItem].ItemRect.Top) and
       (MenuEx.Items[I].ItemRect.Left =
        MenuEx.Items[MouseInItem].ItemRect.Left)
     then
      begin
        MouseInItem := I;
        RePaint;
        Break;
      end;
  end;
end;

procedure TspSkinMenuExPopupWindow.FindRight;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := 0;
    RePaint;
    Exit;
  end
  else
  if MouseInItem = MenuEx.Items.Count  - 1
  then
    begin
      MouseInItem := 0;
      RePaint;
      Exit;
    end;
  for I := MouseInItem + 1 to MenuEx.Items.Count - 1 do
  begin
    MouseInItem := I;
    RePaint;
    Break;
  end;
end;

procedure TspSkinMenuExPopupWindow.FindLeft;
var
  I: Integer;
begin
  if Self.MouseInItem = -1 then
  begin
    MouseInItem := MenuEx.Items.Count  - 1;
    RePaint;
    Exit;
  end
  else
  if (MouseInItem = 0)
  then
    begin
      MouseInItem := MenuEx.Items.Count  - 1;
      RePaint;
      Exit;
    end;
  for I := MouseInItem - 1 downto 0 do
  begin
    MouseInItem := I;
    RePaint;
    Break;
  end;
end;


procedure TspSkinMenuExPopupWindow.ProcessKey(KeyCode: Integer);
begin
  case KeyCode of
   VK_ESCAPE: Self.Hide(False);
   VK_RETURN, VK_SPACE:
    begin
      if MouseInItem <> -1
      then
        MenuEx.ItemIndex := MouseInItem;
      Self.Hide(True);
    end;
    VK_RIGHT: FindRight;
    VK_LEFT: FindLeft;
    VK_UP: FindUp;
    VK_DOWN: FindDown;
  end;
end;

procedure TspSkinMenuExPopupWindow.WMEraseBkGrnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

function TspSkinMenuExPopupWindow.GetItemFromPoint;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;
  for I := 0 to MenuEx.Items.Count - 1 do
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

procedure TspSkinMenuExPopupWindow.AssignItemRects;
var
  I, W, X, Y,StartX, StartY: Integer;
  ItemWidth, ItemHeight: Integer;
  R: TRect;
begin
  ItemWidth := MenuEx.FImages.Width + 10;
  ItemHeight := MenuEx.FImages.Height + 10;
  W := ItemWidth * MenuEx.ColumnsCount;
  if FSkinSupport
  then
    begin
      StartX := MenuEx.SkinData.PopupWindow.ItemsRect.Left + 10;
      StartY := MenuEx.SkinData.PopupWindow.ItemsRect.Top + 10;
    end
  else
    begin
      StartX := 10;
      StartY := 10;
    end;
  X := StartX;
  Y := StartY;
  for I := 0 to MenuEx.Items.Count - 1 do
  with MenuEx.Items[I] do
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


function TspSkinMenuExPopupWindow.GetItemRect(Index: Integer): TRect;
begin
  Result := MenuEx.Items[Index].ItemRect;
end;

procedure TspSkinMenuExPopupWindow.TestActive(X, Y: Integer);
begin
  MouseInItem := GetItemFromPoint(Point(X, Y));
  if (MenuEx.SkinHint <> nil) and
     (MouseInItem = -1)
  then
    MenuEx.SkinHint.HideHint;
  if (MouseInItem <> OldMouseInItem)
  then
    begin
      OldMouseInItem := MouseInItem;
      RePaint;
      if MenuEx.ShowHints and (MouseInItem <> -1) and (MenuEx.SkinHint <> nil)
      then
        begin
          MenuEx.SkinHint.HideHint;
          with MenuEx.Items[MouseInItem] do
          begin
            if Hint <> '' then MenuEx.SkinHint.ActivateHint2(Hint);
           end;
        end;
    end;
end;

procedure TspSkinMenuExPopupWindow.Show(PopupRect: TRect);

procedure CorrectMenuPos(var X, Y: Integer);
var
  WorkArea: TRect;
  P: TPoint;
begin
  if MenuEx.ToolBarEx <> nil
  then
    with MenuEx do
    begin
      P := ToolBarEx.ClientToScreen(Point(ToolBarEx.Width div 2, ToolBarEx.Height));
      X := P.X - Self.Width div 2;
      if ToolBarEx.MenuExPosition = spmpAuto
      then
        begin
          if ToolBarEx.Align = alBottom
          then
            Y := P.Y - ToolBarEx.Height - Height
           else
             Y := P.Y;
         end
      else
        case ToolBarEx.MenuExPosition of
          spmpTop: Y := P.Y - ToolBarEx.Height - Height;
          spmpBottom: Y := P.Y;
        end;
    end;

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
    WorkArea := GetMonitorWorkArea(TForm(MenuEx.Owner).Handle, True);
  if Y + Height > WorkArea.Bottom
  then
    begin
      if MenuEx.ToolBarEx <> nil
      then
        Y := P.Y - MenuEx.ToolBarEx.Height - Height
      else
        Y := Y - Height - RectHeight(PopupRect);
    end;
  if X + Width > WorkArea.Right
  then
    X := X - ((X + Width) - WorkArea.Right);
  if X < WorkArea.Left then X := WorkArea.Left;
  if Y < WorkArea.Top
  then
    begin
      if MenuEx.ToolBarEx <> nil
      then
        Y := P.Y
      else
        Y := WorkArea.Top;
    end;
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

  if CheckW2KWXP and MenuEx.AlphaBlend
  then
    begin
      SetWindowLong(Handle, GWL_EXSTYLE,
                    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
      if MenuEx.AlphaBlendAnimation
      then
        SetAlphaBlendTransparent(Handle, 0)
      else
        SetAlphaBlendTransparent(Handle, MenuEx.AlphaBlendValue);
    end;

  SetWindowPos(Handle, HWND_TOPMOST, ShowX, ShowY, 0, 0,
               SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);


  Visible := True;

  if MenuEx.AlphaBlendAnimation and MenuEx.AlphaBlend and CheckW2KWXP
  then
    begin
      Application.ProcessMessages;
      I := 0;
      TickCount := 0;
      AnimationStep := MenuEx.AlphaBlendValue div 15;
      if AnimationStep = 0 then AnimationStep := 1;
      repeat
        if (GetTickCount - TickCount > 5)
        then
          begin
            TickCount := GetTickCount;
            Inc(i, AnimationStep);
            if i > MenuEx.AlphaBlendValue then i := MenuEx.AlphaBlendValue;
            SetAlphaBlendTransparent(Handle, i);
          end;  
      until i >= MenuEx.AlphaBlendValue;
    end;

  HookApp;

  SetCapture(Handle);
end;

procedure TspSkinMenuExPopupWindow.Hide;
begin
  if MenuEx.ShowHints and (MenuEx.SkinHint <> nil)
  then
    MenuEx.SkinHint.HideHint;
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
  UnHookApp;
  if GetCapture = Handle then ReleaseCapture;
  MenuEx.ProcessEvents(AProcessEvents);
end;

procedure TspSkinMenuExPopupWindow.DrawItems(ActiveIndex, SelectedIndex: Integer; C: TCanvas);
var
  I, J: Integer;
  R: TRect;
  IX, IY: Integer;
  IsActive, IsDown: Boolean;
  B: TspBitmap;
  GC: TColor;
begin
  for I := 0 to MenuEx.Items.Count - 1 do
  begin
    R := GetItemRect(I);
    IX := R.Left + 5;
    IY := R.Top + 5;
    if (MenuEx.Items[I].ImageIndex >= 0) and
       (MenuEx.Items[I].ImageIndex < MenuEx.Images.Count) and (I <> ActiveIndex)
    then
      begin
        MenuEx.Images.Draw(C, IX, IY, MenuEx.Items[I].ImageIndex, True);
      end;
  end;
  //
  if (ActiveIndex >= 0) and (ActiveIndex < MenuEx.Items.Count)
  then
    begin
      R := GetItemRect(ActiveIndex);
      IX := R.Left + 5;
      IY := R.Top + 5;
      // draw glow effect
      if MenuEx.ShowGlow
      then
        begin
          B := TspBitMap.Create;
          B.SetSize(MenuEx.FImages.Width + 20, MenuEx.Images.Height + 20);
          MakeBlurBlank(B, MenuEx.FImages.PngImages.Items[MenuEx.FItems[ActiveIndex].ImageIndex].PngImage, 10);
          Blur(B, 10);
          //
          if Self.FSkinSupport
          then
            begin
              if MenuEx.FItems[ActiveIndex].UseCustomGlowColor
              then
                GC := MenuEx.FItems[ActiveIndex].CustomGlowColor
              else
                GC := MenuEx.SkinData.SkinColors.cHighLight
            end
          else
            GC := clAqua;
          //
          for I := 0 to B.Width - 1 do
          for J := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(GC) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
          //
          B.Draw(C, IX - 10, IY - 10);
          B.Free;  
        end;
      //
      if (MenuEx.Items[ActiveIndex].ActiveImageIndex >= 0) and
         (MenuEx.Items[ActiveIndex].ActiveImageIndex < MenuEx.Images.Count)
      then
        MenuEx.Images.Draw(C, IX, IY, MenuEx.Items[ActiveIndex].ActiveImageIndex, True)
      else
      if (MenuEx.Items[ActiveIndex].ImageIndex >= 0) and
         (MenuEx.Items[ActiveIndex].ImageIndex < MenuEx.Images.Count)
      then
        MenuEx.Images.Draw(C, IX, IY, MenuEx.Items[ActiveIndex].ImageIndex, True);
      //  
      if MenuEx.ShowActiveCursor
      then
        begin
          if  MenuEx.Items[ActiveIndex].UseCustomGlowColor
          then
            GC := MenuEx.Items[ActiveIndex].CustomGlowColor
          else
          if Self.FSkinSupport
          then
            GC := MenuEx.SkinData.SkinColors.cHighLight
          else
            GC := clAqua;
          R := MenuEx.Items[ActiveIndex].ItemRect;
          R.Top := R.Bottom - 5;
          R.Bottom := R.Top + 10;
          DrawBlurMarker(C, R, GC);
        end;
    end;
end;

procedure TspSkinMenuExPopupWindow.Paint;
var
  Buffer: TBitMap;
  SelectedIndex: Integer;
begin
  FSkinSupport := (MenuEx.SkinData <> nil) and (not MenuEx.SkinData.Empty) and
                  (MenuEx.SkinData.PopupWindow.WindowPictureIndex <> -1);


  SelectedIndex := MenuEx.ItemIndex;

  Buffer := TBitMap.Create;
  Buffer.Width := Width;
  Buffer.Height := Height;
  if FSkinSupport
  then
    with MenuEx.SkinData.PopupWindow do
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

procedure TspSkinMenuExPopupWindow.CreateMenu;
var
  ItemsWidth, ItemsHeight: Integer;
  ItemsR: TRect;
begin

  FSkinSupport := (MenuEx.SkinData <> nil) and (not MenuEx.SkinData.Empty) and
                  (MenuEx.SkinData.PopupWindow.WindowPictureIndex <> -1);

  AssignItemRects;

  ItemsWidth := (MenuEx.Images.Width + 10) * MenuEx.ColumnsCount;

  ItemsR := Rect(MenuEx.Items[0].ItemRect.Left,
                 MenuEx.Items[0].ItemRect.Top,
                 MenuEx.Items[0].ItemRect.Left + ItemsWidth,
                 MenuEx.Items[MenuEx.Items.Count - 1].ItemRect.Bottom);


  ItemsHeight := RectHeight(ItemsR);

  if (MenuEx.SkinData <> nil) and (not MenuEx.SkinData.Empty) and
     (MenuEx.SkinData.PopupWindow.WindowPictureIndex <> -1)
  then
    with MenuEx.SkinData.PopupWindow do
    begin
      if (WindowPictureIndex <> - 1) and
         (WindowPictureIndex < MenuEx.SkinData.FActivePictures.Count)
      then
        WindowPicture := MenuEx.SkinData.FActivePictures.Items[WindowPictureIndex];

      if (MaskPictureIndex <> - 1) and
           (MaskPictureIndex < MenuEx.SkinData.FActivePictures.Count)
      then
        MaskPicture := MenuEx.SkinData.FActivePictures.Items[MaskPictureIndex]
      else
        MaskPicture := nil;

      Self.Width := ItemsWidth + (WindowPicture.Width - RectWidth(ItemsRect)) + 20;
      Self.Height := ItemsHeight + (WindowPicture.Height - RectHeight(ItemsRect)) + 20;

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
      Self.Width := ItemsWidth + 20;
      Self.Height := ItemsHeight + 20;
    end;
end;

procedure TspSkinMenuExPopupWindow.CreateParams(var Params: TCreateParams);
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

procedure TspSkinMenuExPopupWindow.CMMouseLeave(var Message: TMessage);
begin
  if MenuEx.ShowHints and (MenuEx.SkinHint <> nil)
  then
    MenuEx.SkinHint.HideHint;
  MouseInItem := -1;
  OldMouseInItem := -1;
  RePaint;
end;

procedure TspSkinMenuExPopupWindow.CMMouseEnter(var Message: TMessage);
begin

end;

procedure TspSkinMenuExPopupWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
   X, Y: Integer);
begin
  inherited;
  if MenuEx.ShowHints and (MenuEx.SkinHint <> nil)
  then
    MenuEx.SkinHint.HideHint;
  FDown := True;
  if GetItemFromPoint(Point(X, Y)) <> -1
    then FItemDown := True else FItemDown := False;
  RePaint;
end;

procedure TspSkinMenuExPopupWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
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
      if I <> -1 then MenuEx.ItemIndex := I;
      if I <> -1 then Hide(I <> -1)
      else
        begin
          if GetCapture = Handle then ReleaseCapture;
          SetCapture(Handle);
        end;
    end;
end;

procedure TspSkinMenuExPopupWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TestActive(X, Y);
end;

procedure TspSkinMenuExPopupWindow.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspSkinMenuExPopupWindow.WndProc(var Message: TMessage);
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

procedure TspSkinMenuExPopupWindow.HookApp;
begin
  OldAppMessage := Application.OnMessage;
  Application.OnMessage := NewAppMessage;
end;

procedure TspSkinMenuExPopupWindow.UnHookApp;
begin
  Application.OnMessage := OldAppMessage;
end;

procedure TspSkinMenuExPopupWindow.NewAppMessage;
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

procedure TspSkinMenuExPopupWindow.SetMenuWindowRegion;
var
  TempRgn: HRgn;
begin
  TempRgn := FRgn;
  with MenuEx.FSkinData.PopupWindow do
  CreateSkinRegion
    (FRgn, LTPoint, RTPoint, LBPoint, RBPoint, ItemsRect,
     NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewItemsRect,
     MaskPicture, Width, Height);
  SetWindowRgn(Handle, FRgn, True);
  if TempRgn <> 0 then DeleteObject(TempRgn);
end;


// TspSkinHorzListBox

constructor TspSkinHorzItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FCaption := '';
  FEnabled := True;
  if TspSkinHorzItems(Collection).HorzListBox.ItemIndex = Self.Index
  then
    Active := True
  else
    Active := False;
end;

procedure TspSkinHorzItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinHorzItem then
  begin
    FImageIndex := TspSkinHorzItem(Source).ImageIndex;
    FCaption := TspSkinHorzItem(Source).Caption;
    FEnabled := TspSkinHorzItem(Source).Enabled;
  end
  else
    inherited Assign(Source);
end;

procedure TspSkinHorzItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspSkinHorzItem.SetCaption(const Value: String);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TspSkinHorzItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  Changed(False);
end;

procedure TspSkinHorzItem.SetData(const Value: Pointer);
begin
  FData := Value;
end;

constructor TspSkinHorzItems.Create;
begin
  inherited Create(TspSkinHorzItem);
  HorzListBox := AListBox;
end;

function TspSkinHorzItems.GetOwner: TPersistent;
begin
  Result := HorzListBox;
end;

procedure  TspSkinHorzItems.Update(Item: TCollectionItem);
begin
  HorzListBox.Repaint;
  HorzListBox.UpdateScrollInfo;
end; 

function TspSkinHorzItems.GetItem(Index: Integer):  TspSkinHorzItem;
begin
  Result := TspSkinHorzItem(inherited GetItem(Index));
end;

procedure TspSkinHorzItems.SetItem(Index: Integer; Value:  TspSkinHorzItem);
begin
  inherited SetItem(Index, Value);
  HorzListBox.RePaint;
end;

function TspSkinHorzItems.Add: TspSkinHorzItem;
begin
  Result := TspSkinHorzItem(inherited Add);
  HorzListBox.RePaint;
end;

function TspSkinHorzItems.Insert(Index: Integer): TspSkinHorzItem;
begin
  Result := TspSkinHorzItem(inherited Insert(Index));
  HorzListBox.RePaint;
end;

procedure TspSkinHorzItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  HorzListBox.RePaint;
end;

procedure TspSkinHorzItems.Clear;
begin
  inherited Clear;
  HorzListBox.RePaint;
end;

constructor TspSkinHorzListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csAcceptsControls];
  FInUpdateItems := False;
  FShowGlow := False;
  FItemMargin := -1;
  FItemSpacing := 1;
  FItemLayout := blGlyphTop;
  FClicksDisabled := False;
  FMouseMoveChangeIndex := False;
  FMouseDown := False;
  FMouseActive := -1;
  ScrollBar := nil;
  FScrollOffset := 0;
  FItems := TspSkinHorzItems.Create(Self);
  FImages := nil;
  Width := 250;
  Height := 100;
  FItemWidth := 70;
  FSkinDataName := 'listbox';
  FShowItemTitles := True;
  FMax := 0;
  FRealMax := 0;
  FOldWidth := -1;
  FItemIndex := -1;
  FDisabledFontColor := clGray;
end;

destructor TspSkinHorzListBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinHorzListBox.SetShowGlow;
begin
  if FShowGlow <> Value
  then
    begin
      FShowGlow := Value;
      RePaint;
    end;
end;

procedure TspSkinHorzListBox.SetItemLayout(Value: TspButtonLayout);
begin
  FItemLayout := Value;
  Invalidate;
end;

procedure TspSkinHorzListBox.SetItemMargin(Value: Integer);
begin
  FItemMargin := Value;
  Invalidate;
end;


procedure TspSkinHorzListBox.SetItemSpacing(Value: Integer);
begin
  FItemSpacing := Value;
  Invalidate;
end;

function TspSkinHorzListBox.CalcWidth;
var
  W: Integer;
begin
  if AItemCount > FItems.Count then AItemCount := FItems.Count;
  W := AItemCount * ItemWidth;
  if FIndex = -1
  then
    begin
      W := W + 5;
    end
  else
    begin
      W := W + Width - RectWidth(RealClientRect) + 1;
    end;
  Result := W;
end;

procedure TspSkinHorzListBox.BeginUpdateItems;
begin
  FInUpdateItems := True;
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TspSkinHorzListBox.EndUpdateItems;
begin
  FInUpdateItems := False;
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinHorzListBox.ChangeSkinData;
var
  CIndex: Integer;
begin
  inherited;
  //
  if SkinData <> nil
  then
    CIndex := SkinData.GetControlIndex('edit');
  if CIndex = -1
  then
    FDisabledFontColor := SkinData.SkinColors.cBtnShadow
  else
    FDisabledFontColor := TspDataSkinEditControl(SkinData.CtrlList[CIndex]).DisabledFontColor;
  //
  if ScrollBar <> nil
  then
    begin
      ScrollBar.SkinData := SkinData;
      AdjustScrollBar;
    end;
  CalcItemRects;
  RePaint;
end;

procedure TspSkinHorzListBox.SetItemWidth(Value: Integer);
begin
  if FItemWidth <> Value
  then
    begin
      FItemWidth := Value;
      RePaint;
    end;
end;

procedure TspSkinHorzListBox.SetItems(Value: TspSkinHorzItems);
begin
  FItems.Assign(Value);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinHorzListBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TspSkinHorzListBox.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Images) then
   FImages := nil;
end;

procedure TspSkinHorzListBox.SetShowItemTitles(Value: Boolean);
begin
  if FShowItemTitles <> Value
  then
    begin
      FShowItemTitles := Value;
      RePaint;
    end;
end;

procedure TspSkinHorzListBox.DrawItem;
var
  Buffer: TBitMap;
  R: TRect;
begin
  if FIndex <> -1
  then
    SkinDrawItem(Index, Cnvs)
  else
    DefaultDrawItem(Index, Cnvs);
end;

procedure TspSkinHorzListBox.CreateControlDefaultImage(B: TBitMap);
var
  I, SaveIndex: Integer;
  R: TRect;
begin
  //
  R := Rect(0, 0, Width, Height);
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  InflateRect(R, -1, -1);
  with B.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(R);
  end;
  //
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinHorzListBox.CreateControlSkinImage(B: TBitMap);
var
  I, SaveIndex: Integer;
begin
  inherited;
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinHorzListBox.CalcItemRects;
var
  I: Integer;
  X, Y, W, H: Integer;
begin
  FRealMax := 0;
  if FIndex <> -1
  then
    FItemsRect := RealClientRect
  else
    FItemsRect := Rect(2, 2, Width - 2, Height - 2);
  if ScrollBar <> nil then Dec(FItemsRect.Bottom, ScrollBar.Height);  
  X := FItemsRect.Left;
  Y := FItemsRect.Top;
  H:= RectHeight(FItemsRect);
  for I := 0 to FItems.Count - 1 do
    with TspSkinHorzItem(FItems[I]) do
    begin
      W := ItemWidth;
      ItemRect := Rect(X, Y, X + W, Y + H);
      OffsetRect(ItemRect, - FScrollOffset, 0);
      IsVisible := RectToRect(ItemRect, FItemsRect);
      if not IsVisible and (ItemRect.Left <= FItemsRect.Left) and
        (ItemRect.Right >= FItemsRect.Right)
      then
        IsVisible := True;
      if IsVisible then FRealMax := ItemRect.Right;
      X := X + W;
    end;
  FMax := X;
end;

procedure TspSkinHorzListBox.Scroll(AScrollOffset: Integer);
begin
  FScrollOffset := AScrollOffset;
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinHorzListBox.GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
begin
  CalcItemRects;
  AMin := 0;
  AMax := FMax - FItemsRect.Left;
  APage := RectWidth(FItemsRect);
  if AMax <= APage
  then
    begin
      APage := 0;
      AMax := 0;
    end;  
  APosition := FScrollOffset;
end;

procedure TspSkinHorzListBox.WMSize(var Msg: TWMSize);
begin
  inherited;
  if (FOldWidth <> Height) and (FOldWidth <> -1)
  then
    begin
      CalcItemRects;
      if (FRealMax <= FItemsRect.Right) and (FScrollOffset > 0)
      then
        begin
          FScrollOffset := FScrollOffset - (FItemsRect.Right - FRealMax);
          if FScrollOffset < 0 then FScrollOffset := 0;
          CalcItemRects;
          Invalidate;
        end;
    end;
  AdjustScrollBar;
  UpdateScrollInfo;
  FOldWidth := Width;
end;

procedure TspSkinHorzListBox.ScrollToItem(Index: Integer);
var
  R, R1: TRect;
begin
  CalcItemRects;
  R1 := FItems[Index].ItemRect;
  R := R1;
  OffsetRect(R, FScrollOffset, 0);
  if (R1.Left <= FItemsRect.Left)
  then
    begin
      FScrollOffset := R.Left - FItemsRect.Left;
      CalcItemRects;
      Invalidate;
    end
  else
  if R1.Right >= FItemsRect.Right
  then
    begin
      FScrollOffset := R.Left;
      FScrollOffset := FScrollOffset - RectWidth(FItemsRect) + RectWidth(R) -
        Width + FItemsRect.Right + 1;
      CalcItemRects;
      Invalidate;
    end;
  UpdateScrollInfo;  
end;

procedure TspSkinHorzListBox.ShowScrollbar;
begin
  if ScrollBar = nil
  then
    begin
      ScrollBar := TspSkinScrollBar.Create(Self);
      ScrollBar.Visible := False;
      ScrollBar.Parent := Self;
      ScrollBar.DefaultHeight := 19;
      ScrollBar.DefaultWidth := 0;
      ScrollBar.SmallChange := ItemWidth;
      ScrollBar.LargeChange := ItemWidth;
      ScrollBar.SkinDataName := 'hscrollbar';
      ScrollBar.Kind := sbHorizontal;
      ScrollBar.SkinData := Self.SkinData;
      ScrollBar.OnChange := SBChange;
      AdjustScrollBar;
      ScrollBar.Visible := True;
      RePaint;
    end;
end;

procedure TspSkinHorzListBox.HideScrollBar;
begin
  if ScrollBar = nil then Exit;
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  RePaint;
end;

procedure TspSkinHorzListBox.UpdateScrollInfo;
var
  SMin, SMax, SPage, SPos: Integer;
begin
  if FInUpdateItems then Exit;
  GetScrollInfo(SMin, SMax, SPage, SPos);
  if SMax <> 0
  then
    begin
      if ScrollBar = nil then ShowScrollBar;
      ScrollBar.SetRange(SMin, SMax, SPos, SPage);
      ScrollBar.LargeChange := SPage;
    end
  else
  if (SMax = 0) and (ScrollBar <> nil)
  then
    begin
      HideScrollBar;
    end;
end;

procedure TspSkinHorzListBox.AdjustScrollBar;
var
  R: TRect;
begin
  if ScrollBar = nil then Exit;
  if FIndex = -1
  then
    R := Rect(2, 2, Width - 2, Height - 2)
  else
    R := RealClientRect;
  Dec(R.Bottom, ScrollBar.Height);
  ScrollBar.SetBounds(R.Left, R.Bottom, RectWidth(R), ScrollBar.Height);
end;

procedure TspSkinHorzListBox.SBChange(Sender: TObject);
begin
  Scroll(ScrollBar.Position);
end;

procedure TspSkinHorzListBox.SkinDrawItem(Index: Integer; Cnvs: TCanvas);
var
  ListBoxData: TspDataSkinListBox;
  CIndex, TX, TY: Integer;
  R, R1: TRect;
  Buffer: TBitMap;
  C: TColor;
  SaveIndex: Integer;
begin
  CIndex := SkinData.GetControlIndex('listbox');
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  InflateRect(R, -2, -2);
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Cnvs.Brush.Style := bsClear;
  //
  if (FDisabledFontColor = ListBoxData.FontColor) and
     (FDisabledFontColor = clBlack)
  then
    FDisabledFontColor := clGray;   
  //
  if not FUseSkinFont
  then
    Cnvs.Font.Assign(FDefaultFont)
  else
    with Cnvs.Font, ListBoxData do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  if FItems[Index].Enabled
  then
    begin
      if (FSkinDataName = 'listbox') or
         (FSkinDataName = 'memo')
      then
        Cnvs.Font.Color := ListBoxData.FontColor
      else
        Cnvs.Font.Color := FSD.SkinColors.cBtnText;
    end
  else
    Cnvs.Font.Color := FDisabledFontColor;


  with Cnvs.Font do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
  end;
  //
  if (not FItems[Index].Active) or (not FItems[Index].Enabled)
  then
    with FItems[Index] do
    begin
      SaveIndex := SaveDC(Cnvs.Handle);
      IntersectClipRect(Cnvs.Handle, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom);
      //
      if Assigned(FOnDrawItem)
      then
        begin
          Cnvs.Brush.Style := bsClear;
          FOnDrawItem(Cnvs, Index, R);
        end
      else
        DrawImageAndText(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
          Caption, FImageIndex, FImages,
          False, Enabled, False, 0);
      //
      RestoreDC(Cnvs.Handle, SaveIndex);
    end
  else
  if FShowGlow
  then
    begin
      SaveIndex := SaveDC(Cnvs.Handle);
      IntersectClipRect(Cnvs.Handle, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom);
      //
      if Assigned(FOnDrawItem)
      then
        begin
          Cnvs.Brush.Style := bsClear;
          FOnDrawItem(Cnvs, Index, R);
        end
      else
         DrawImageAndTextGlow(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
           FItems[Index].Caption, FItems[Index].FImageIndex, FImages,
           False, Enabled, False, 0, SkinData.SkinColors.cHighLight, 7);
      //
      RestoreDC(Cnvs.Handle, SaveIndex);
    end
  else
    with FItems[Index] do
    begin
      Buffer := TBitMap.Create;
      R := FItems[Index].ItemRect;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      //
      with ListBoxData do
      if Focused
      then
        CreateStretchImage(Buffer, Picture, FocusItemRect, ItemTextRect, True)
      else
        CreateStretchImage(Buffer, Picture, ActiveItemRect, ItemTextRect, True);
      //
     if not FUseSkinFont
     then
       Buffer.Canvas.Font.Assign(FDefaultFont)
     else
       with Buffer.Canvas.Font, ListBoxData do
       begin
         Name := FontName;
         Height := FontHeight;
         Style := FontStyle;
       end;

       if Focused
       then
         Buffer.Canvas.Font.Color := ListBoxData.FocusFontColor
       else
         Buffer.Canvas.Font.Color := ListBoxData.ActiveFontColor;

       with Buffer.Canvas.Font do
       begin
         if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
         then
           Charset := SkinData.ResourceStrData.CharSet
         else
           CharSet := FDefaultFont.Charset;
        end;

       R := Rect(2, 2, Buffer.Width - 2, Buffer.Height - 2);

       //
       if Assigned(FOnDrawItem)
      then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R);
        end
      else
         DrawImageAndText(Buffer.Canvas, R, FItemMargin, FItemSpacing, FItemLayout,
           Caption, FImageIndex, FImages,
           False, Enabled, False, 0);
       //
       Cnvs.Draw(FItems[Index].ItemRect.Left,
         FItems[Index].ItemRect.Top, Buffer);
      Buffer.Free;
    end;
end;

procedure TspSkinHorzListBox.DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
var
  R, R1: TRect;
  C, FC: TColor;
  TX, TY: Integer;
  SaveIndex: Integer;
begin
  if (FItems[Index].Active) and not FShowGlow
  then
    begin
      C := clHighLight;
      FC := clHighLightText;
     end
  else
    begin
      C := clWindow;
      if FItems[Index].Enabled
      then
        FC := clWindowText
      else
        FC := clGray;  
    end;
  //
  Cnvs.Font := FDefaultFont;
  Cnvs.Font.Color := FC;
  //
  R := FItems[Index].ItemRect;
  SaveIndex := SaveDC(Cnvs.Handle);
  IntersectClipRect(Cnvs.Handle, R.Left, R.Top, R.Right, R.Bottom);
  //
  Cnvs.Brush.Color := C;
  Cnvs.Brush.Style := bsSolid;
  Cnvs.FillRect(R);
  Cnvs.Brush.Style := bsClear;
  //
  InflateRect(R, -2, -2);
   if Assigned(FOnDrawItem)
  then
    begin
      Cnvs.Brush.Style := bsClear;
      FOnDrawItem(Cnvs, Index, R);
    end
  else
  with FItems[Index] do
  begin
    if FShowGlow and FItems[Index].Active
    then
      DrawImageAndTextGlow(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
        Caption, FImageIndex, FImages,
        False, Enabled, False, 0, clAqua, 7)
    else
      DrawImageAndText(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
        Caption, FImageIndex, FImages,
        False, Enabled, False, 0);
  end;
  if FItems[Index].Active and Focused
  then
    Cnvs.DrawFocusRect(FItems[Index].ItemRect);
  RestoreDC(Cnvs.Handle, SaveIndex);
end;

procedure TspSkinHorzListBox.SetItemIndex(Value: Integer);
var
  I: Integer;
  IsFind: Boolean;
begin
  if Value < 0
  then
    begin
      FItemIndex := Value;
      RePaint;
    end
  else
    begin
      FItemIndex := Value;
      IsFind := False;
      for I := 0 to FItems.Count - 1 do
        with FItems[I] do
        begin
          if I = FItemIndex
          then
            begin
              Active := True;
              IsFind := True;
            end
          else
             Active := False;
        end;
      RePaint;
      ScrollToItem(FItemIndex);
      if IsFind and not (csDesigning in ComponentState)
         and not (csLoading in ComponentState)
      then
      begin
        if Assigned(FItems[FItemIndex].OnClick) then
          FItems[FItemIndex].OnClick(Self);
        if Assigned(FOnItemClick) then
          FOnItemClick(Self);
      end;    
    end;
end;

procedure TspSkinHorzListBox.Loaded;
begin
  inherited;
  if FItemIndex <> -1 then ScrollToItem(FItemIndex);
end;

function TspSkinHorzListBox.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(FItems[I].ItemRect, Point(X, Y)) and (FItems[I].Enabled)
    then
      begin
        Result := I;
        Break;
      end;  
end;


procedure TspSkinHorzListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and (Button = mbLeft)
  then
    begin
      SetItemActive(I);
      FMouseDown := True;
      FMouseActive := I;
    end;
end;

procedure TspSkinHorzListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  FMouseDown := False;
  I := ItemAtPos(X, Y);
  if (I <> -1) and  (Button = mbLeft) then ItemIndex := I;
end;

procedure TspSkinHorzListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and (FMouseDown or FMouseMoveChangeIndex)
   and (I <> FMouseActive)
  then
    begin
      SetItemActive(I);
      FMouseActive := I;
    end;
end;

procedure TspSkinHorzListBox.SetItemActive(Value: Integer);
var
  I: Integer;
begin
  FItemIndex := Value;
  for I := 0 to FItems.Count - 1 do
  with FItems[I] do
   if I = Value then Active := True else Active := False;
  RePaint;
  ScrollToItem(Value);
end;

procedure TspSkinHorzListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
  inherited;
  if ScrollBar = nil then Exit;
  if Message.WParam < 0
  then
    ScrollBar.Position :=  ScrollBar.Position + ScrollBar.SmallChange
  else
    ScrollBar.Position :=  ScrollBar.Position - ScrollBar.SmallChange;

end;

procedure TspSkinHorzListBox.WMSETFOCUS(var Message: TWMSETFOCUS);
begin
  inherited;
  RePaint;
end;

procedure TspSkinHorzListBox.WMKILLFOCUS(var Message: TWMKILLFOCUS);
begin
  inherited;
  RePaint;
end;

procedure TspSkinHorzListBox.WndProc(var Message: TMessage);
begin
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

procedure TspSkinHorzListBox.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TspSkinHorzListBox.FindUp;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  for I := Start downto 0 do
  begin
    if FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;  
  end;
end;

procedure TspSkinHorzListBox.FindDown;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  for I := Start to FItems.Count - 1 do
  begin
    if FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;
  end;
end;

procedure TspSkinHorzListBox.FindPageUp;
var
  I, J, Start: Integer;
  PageCount: Integer;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  PageCount := RectWidth(FItemsRect) div FItemWidth;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start - PageCount;
  if PageCount < 0 then PageCount := 0;
  J := -1;
  for I := Start downto PageCount do
  begin
    if FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;


procedure TspSkinHorzListBox.FindPageDown;
var
  I, J, Start: Integer;
  PageCount: Integer;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  PageCount := RectWidth(FItemsRect) div FItemWidth;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start + PageCount;
  if PageCount > FItems.Count - 1 then PageCount := FItems.Count - 1;
  J := -1;
  for I := Start to PageCount do
  begin
    if FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;

procedure TspSkinHorzListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
 inherited KeyDown(Key, Shift);
 case Key of
   VK_NEXT:  FindPageDown;
   VK_PRIOR: FindPageUp;
   VK_UP, VK_LEFT: FindUp;
   VK_DOWN, VK_RIGHT: FindDown;
 end;
end;


constructor TspSkinDivider.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csOpaque];
  FSkinDataName := 'bevel';
  FDividerType := spdtVerticalLine;
  Width := 20;
  Height := 50;
end;

procedure TspSkinDivider.SetDividerType(Value: TspSkinDividerType);
begin
  FDividerType := Value;
  Invalidate;
end;

procedure TspSkinDivider.DrawLineH;
var
  B: TspBitMap;
  i, h, Step, A: Integer;
  DstP: PspColor;
begin
  if Width <= 0 then Exit;
  B := TspBitMap.Create;
  B.SetSize(Width, 1);
  with B.Canvas do
  begin
    Pen.Color := DarkColor;
    MoveTo(0, 0);
    LineTo(B.Width, 0);
  end;
  //
  B.CheckingAlphaBlend;
  for i := 0 to B.Width - 1 do
  begin
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := 255;
  end;
  h := B.Width div 3;
  Step := Round (255 / h);
  A := 0;
  for i := 0 to h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  A := 0;
  for i := B.Width - 1 downto B.Width - 1 - h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  //
  B.AlphaBlend := True;
  B.Draw(Canvas, 0, Height div 2);
  B.Free;
end;

procedure TspSkinDivider.DrawLineV;
var
  B: TspBitMap;
  i, h, Step, A: Integer;
  DstP: PspColor;
begin
  if Height <= 0 then Exit;
  B := TspBitMap.Create;
  B.SetSize(1, Height);
  with B.Canvas do
  begin
    Pen.Color := DarkColor;
    MoveTo(0, 0);
    LineTo(0, B.Height);
  end;
  //
  B.CheckingAlphaBlend;
  for i := 0 to B.Height - 1 do
  begin
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := 255;
  end;
  h := B.Height div 3;
  Step := Round (255 / h);
  A := 0;
  for i := 0 to h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  A := 0;
  for i := B.Height - 1 downto B.Height - 1 - h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  //
  B.AlphaBlend := True;
  B.Draw(Canvas, Width div 2, 0);
  B.Free;
end;

procedure TspSkinDivider.GetSkinData;
begin
  inherited;
  if FIndex = -1
  then
    begin
      if (FSD <> nil) and not FSD.Empty
      then
        begin
          DarkColor := FSD.SkinColors.cBtnShadow;
        end
      else
        begin
          DarkColor := clBtnShadow;
        end;  
    end
  else
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinBevel
    then
      with TspDataSkinBevel(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.DarkColor := DarkColor;
      end;
end;

procedure TspSkinDivider.Paint;
begin
  GetSkinData;
  case FDividerType of
    spdtVerticalLine: DrawLineV;
    spdtHorizontalLine: DrawLineH;
  end;
end;

// Graphic controls

constructor TspSkinGraphicButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := 65;
  FGraphicImages := TCustomImageList.Create(Self);
  FGraphicMenu := TspSkinImagesMenu.Create(Self);
  FGraphicMenu.Images := FGraphicImages;
  SkinImagesMenu := FGraphicMenu;
  FUseImagesMenuImage := True;
  InitImages;
  InitItems;
end;

destructor TspSkinGraphicButton.Destroy;
begin
  FGraphicImages.Clear;
  FGraphicImages.Free;
  FGraphicMenu.Free;
  inherited;
end;

procedure TspSkinGraphicButton.Loaded;
begin
  inherited;
  SkinImagesMenu := FGraphicMenu;
  FGraphicMenu.Skindata := Self.SkinData;
end;

function TspSkinGraphicButton.GetItemIndex: Integer;
begin
  Result := FGraphicMenu.ItemIndex;
end;

procedure TspSkinGraphicButton.SetItemIndex(Value: Integer);
begin
  FGraphicMenu.ItemIndex := Value;
  RePaint;
end;

function TspSkinGraphicButton.GetSelectedItem;
begin
  Result := FGraphicMenu.SelectedItem;
end;

function TspSkinGraphicButton.GetMenuShowHints: Boolean;
begin
  Result := FGraphicMenu.ShowHints;
end;

procedure TspSkinGraphicButton.SetMenuShowHints(Value: Boolean);
begin
  FGraphicMenu.ShowHints := Value;
end;

function TspSkinGraphicButton.GetMenuSkinHint: TspSkinHint;
begin
  Result := FGraphicMenu.SkinHint;
end;

procedure TspSkinGraphicButton.SetMenuSkinHint(Value: TspSkinHint);
begin
  FGraphicMenu.SkinHint := Value;
end;

procedure TspSkinGraphicButton.InitImages;
begin
end;

procedure TspSkinGraphicButton.InitItems;
begin
end;

function TspSkinGraphicButton.GetGraphicMenuItems: TspImagesMenuItems;
begin
  Result := FGraphicMenu.ImagesItems;
end;

function TspSkinGraphicButton.GetMenuDefaultFont: TFont;
begin
  Result := FGraphicMenu.DefaultFont;
end;

procedure TspSkinGraphicButton.SetMenuDefaultFont(Value: TFont);
begin
  FGraphicMenu.DefaultFont.Assign(Value);
end;

function TspSkinGraphicButton.GetMenuUseSkinFont: Boolean;
begin
  Result := FGraphicMenu.UseSkinFont;
end;

procedure TspSkinGraphicButton.SetMenuUseSkinFont(Value: Boolean);
begin
  FGraphicMenu.UseSkinFont := Value;
end;

function TspSkinGraphicButton.GetMenuAlphaBlend: Boolean;
begin
   Result := FGraphicMenu.AlphaBlend;
end;

procedure TspSkinGraphicButton.SetMenuAlphaBlend(Value: Boolean);
begin
  FGraphicMenu.AlphaBlend := Value;
end;

function TspSkinGraphicButton.GetMenuAlphaBlendAnimation: Boolean;
begin
  Result := FGraphicMenu.AlphaBlendAnimation;
end;

procedure TspSkinGraphicButton.SetMenuAlphaBlendAnimation(Value: Boolean);
begin
  FGraphicMenu.AlphaBlendAnimation := Value;
end;

function TspSkinGraphicButton.GetMenuAlphaBlendValue: Integer;
begin
  Result := FGraphicMenu.AlphaBlendValue;
end;

procedure TspSkinGraphicButton.SetMenuAlphaBlendValue(Value: Integer);
begin
  FGraphicMenu.AlphaBlendValue := Value;
end;

procedure TspSkinGradientStyleButton.InitImages;
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.LoadFromResourceName(HInstance, 'SP_GRAD_HORZ_IN');
  FGraphicImages.Width := B.Width;
  FGraphicImages.Height := B.Height;
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_GRAD_HORZ_OUT');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_GRAD_HORZ_INOUT');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_GRAD_VERT_IN');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_GRAD_VERT_OUT');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_GRAD_VERT_INOUT');
  FGraphicImages.Add(B, nil);
  B.Free;
end;

procedure TspSkinGradientStyleButton.InitItems;
var
 Item: TspImagesMenuItem;
begin
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 0;
    Hint := 'HorizotalIn';
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 1;
    Hint := 'HorizotalOut';
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 2;
    Hint := 'HorizotalInOut';
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 3;
    Hint := 'VerticalIn';
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 4;
    Hint := 'VerticalOut';
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 5;
    Hint := 'VerticalInOut';
  end;
  FGraphicMenu.ColumnsCount := 2;
  FGraphicMenu.ItemIndex := 0;
end;


procedure TspSkinBrushStyleButton.InitImages;
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_CLEAR');
  FGraphicImages.Width := B.Width;
  FGraphicImages.Height := B.Height;
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_SOLID');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_CROSS');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_DCROSS');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_FD');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_BD');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_H');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_BRUSH_V');
  FGraphicImages.Add(B, nil);
  B.Free;
end;

procedure TspSkinBrushStyleButton.InitItems;
var
 Item: TspImagesMenuItem;
begin
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 0;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 1;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 2;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 3;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 4;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 5;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 6;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 7;
  end;
  FGraphicMenu.ColumnsCount := 2;
  FGraphicMenu.ItemIndex := 0;
end;


procedure TspSkinPenStyleButton.InitImages;
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.LoadFromResourceName(HInstance, 'SP_PEN_SOLID');
  FGraphicImages.Width := B.Width;
  FGraphicImages.Height := B.Height;
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN_DASH');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN_DASHDOT');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN_DOT');
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN_DASHDOTDOT');
  FGraphicImages.Add(B, nil);
  B.Free;
end;

procedure TspSkinPenStyleButton.InitItems;
var
 Item: TspImagesMenuItem;
begin
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 0;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 1;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 2;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 3;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 4;
  end;
  FGraphicMenu.ColumnsCount := 1;
  FGraphicMenu.ItemIndex := 0;
end;


procedure TspSkinPenWidthButton.InitImages;
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.LoadFromResourceName(HInstance, 'SP_PEN1');
  FGraphicImages.Width := B.Width;
  FGraphicImages.Height := B.Height;
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN2');
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN3');
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN4');
  FGraphicImages.Add(B, nil);
  FGraphicImages.Add(B, nil);
  B.LoadFromResourceName(HInstance, 'SP_PEN6');
  FGraphicImages.Add(B, nil);
  B.Free;
end;

procedure TspSkinPenWidthButton.InitItems;
var
 Item: TspImagesMenuItem;
begin
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 0;
    Button := True;
    Caption := '1/4 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 1;
    Button := True;
    Caption := '1/2 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 2;
    Button := True;
    Caption := '3/4 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 3;
    Button := True;
    Caption := '1 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 4;
    Button := True;
    Caption := '1 1/4 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 5;
    Button := True;
    Caption := '1 1/2 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 6;
    Button := True;
    Caption := '1 3/4 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 7;
    Button := True;
    Caption := '2 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 8;
    Button := True;
    Caption := '2 1/2 pt'
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 9;
    Button := True;
    Caption := '3 pt'
  end;
    Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 10;
    Button := True;
    Caption := '4 pt'
  end;
    Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    ImageIndex := 11;
    Button := True;
    Caption := '6 pt'
  end;
  FGraphicMenu.ColumnsCount := 2;
  FGraphicMenu.ItemIndex := 0;
end;


procedure TspSkinShadowStyleButton.InitImages;
var
  B: TBitMap;
begin
  FGraphicImages.Width := 20;
  FGraphicImages.Height := 20;
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW1', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW2', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW3', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW4', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW5', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW6', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW7', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW8', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW9', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW10', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW11', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW12', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW13', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW14', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW15', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW16', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW17', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW18', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW19', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW20', clWhite);
  FGraphicImages.ResInstLoad(HInstance, rtBitmap, 'SP_SHADOW21', clWhite);
end;

procedure TspSkinShadowStyleButton.InitItems;
var
 Item: TspImagesMenuItem;
 i: Integer;
begin
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    Button := True;
    Caption := 'No shadow';
  end;
  for i := 0 to 19 do
  begin
    Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
    Item.ImageIndex := i;
  end;
  Item := TspImagesMenuItem(FGraphicMenu.ImagesItems.Add);
  with Item do
  begin
    Button := True;
    Caption := 'More settings';
    ImageIndex := 20;
  end;
  FGraphicMenu.ColumnsCount := 4;
  FGraphicMenu.ItemIndex := 0;
end;

// TspSkinOfficeGridView =======================================================

constructor TspSkinGridViewItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FHeader := False;
  FImageIndex := -1;
  FCaption := '';
  FEnabled := True;
  if TspSkinGridViewItems(Collection).GridView.ItemIndex = Self.Index
  then
    Active := True
  else
    Active := False;
end;

procedure TspSkinGridViewItem.Assign(Source: TPersistent);
begin
  if Source is TspSkinGridViewItem then
  begin
    FImageIndex := TspSkinGridViewItem(Source).ImageIndex;
    FCaption := TspSkinGridViewItem(Source).Caption;
    FEnabled := TspSkinGridViewItem(Source).Enabled;
    FHeader := TspSkinGridViewItem(Source).Header;
  end
  else
    inherited Assign(Source);
end;


procedure TspSkinGridViewItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspSkinGridViewItem.SetCaption(const Value: String);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TspSkinGridViewItem.SetHeader(Value: Boolean);
begin
  FHeader := Value;
  Changed(False);
end;

procedure TspSkinGridViewItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  Changed(False);
end;

procedure TspSkinGridViewItem.SetData(const Value: Pointer);
begin
  FData := Value;
end;

constructor TspSkinGridViewItems.Create;
begin
  inherited Create(TspSkinGridViewItem);
  GridView := AGridView;
end;

function TspSkinGridViewItems.GetOwner: TPersistent;
begin
  Result := GridView;
end;

procedure  TspSkinGridViewItems.Update(Item: TCollectionItem);
begin
  GridView.Repaint;
  GridView.UpdateScrollInfo;
end; 

function TspSkinGridViewItems.GetItem(Index: Integer):  TspSkinGridViewItem;
begin
  Result := TspSkinGridViewItem(inherited GetItem(Index));
end;

procedure TspSkinGridViewItems.SetItem(Index: Integer; Value:  TspSkinGridViewItem);
begin
  inherited SetItem(Index, Value);
  GridView.RePaint;
end;

function TspSkinGridViewItems.Add: TspSkinGridViewItem;
begin
  Result := TspSkinGridViewItem(inherited Add);
  GridView.RePaint;
end;

function TspSkinGridViewItems.Insert(Index: Integer): TspSkinGridViewItem;
begin
  Result := TspSkinGridViewItem(inherited Insert(Index));
  GridView.RePaint;
end;

procedure TspSkinGridViewItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  GridView.RePaint;
end;

procedure TspSkinGridViewItems.Clear;
begin
  inherited Clear;
  GridView.RePaint;
end;

constructor TspSkinGridView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csAcceptsControls];
  FMouseMoveChangeIndex := False;
  RowCount := 1;
  ColCount := 1;
  FInUpdateItems := False;
  FClicksDisabled := False;
  FHeaderLeftAlignment := False;
  FMouseDown := False;
  FMouseActive := -1;
  ScrollBar := nil;
  FScrollOffset := 0;
  FItems := TspSkinGridViewItems.Create(Self);
  FItemMargin := -1;
  FItemSpacing := 1;
  FItemLayout := blGlyphTop;
  FImages := nil;
  Width := 150;
  Height := 150;
  FItemHeight := 30;
  FItemWidth := 30;
  FHeaderHeight := 20;
  FItemSkinDataName := 'listbox';
  FSkinDataName := 'listbox';
  FHeaderSkinDataName := 'menuheader';
  FMax := 0;
  FRealMax := 0;
  FOldHeight := -1;
  FItemIndex := -1;
  FDisabledFontColor := clGray;
end;

destructor TspSkinGridView.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TspSkinGridView.SetItemLayout(Value: TspButtonLayout);
begin
  FItemLayout := Value;
  RePaint;
end;

procedure TspSkinGridView.SetItemMargin(Value: Integer);
begin
  FItemMargin := Value;
  RePaint;
end;

procedure TspSkinGridView.SetItemSpacing(Value: Integer);
begin
  FItemSpacing := Value;
  RePaint;
end;

procedure TspSkinGridView.BeginUpdateItems;
begin
  FInUpdateItems := True;
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TspSkinGridView.EndUpdateItems;
begin
  FInUpdateItems := False;
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinGridView.SetHeaderLeftAlignment(Value: Boolean);
begin
  if FHeaderLeftAlignment <> Value
  then
    begin
      FHeaderLeftAlignment := Value;
      RePaint;
    end;
end;

function TspSkinGridView.CalcHeight;
var
  H: Integer;
begin
  if AItemCount > FItems.Count then AItemCount := FItems.Count;
  H := AItemCount * ItemHeight;
  if FIndex = -1
  then
    begin
      H := H + 5;
    end
  else
    begin
      H := H + Height - RectHeight(RealClientRect) + 1;
    end;
  Result := H;  
end;

procedure TspSkinGridView.ChangeSkinData;
var
  CIndex: Integer;
begin
  inherited;
  //
  if SkinData <> nil
  then
    CIndex := SkinData.GetControlIndex('edit');
  if CIndex = -1
  then
    FDisabledFontColor := SkinData.SkinColors.cBtnShadow
  else
    FDisabledFontColor := TspDataSkinEditControl(SkinData.CtrlList[CIndex]).DisabledFontColor;
  //
  if ScrollBar <> nil
  then
    begin
      ScrollBar.SkinData := SkinData;
      AdjustScrollBar;
    end;
  CalcItemRects;
  RePaint;
end;

procedure TspSkinGridView.SetItemHeight(Value: Integer);
begin
  if FItemHeight <> Value
  then
    begin
      FItemHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinGridView.SetItemWidth(Value: Integer);
begin
  if FItemWidth <> Value
  then
    begin
      FItemWidth := Value;
      RePaint;
    end;
end;

procedure TspSkinGridView.SetHeaderHeight(Value: Integer);
begin
  if FHeaderHeight <> Value
  then
    begin
      FHeaderHeight := Value;
      RePaint;
    end;
end;

procedure TspSkinGridView.SetItems(Value: TspSkinGridViewItems);
begin
  FItems.Assign(Value);
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinGridView.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TspSkinGridView.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Images) then
   FImages := nil;
end;

procedure TspSkinGridView.DrawItem;
var
  Buffer: TBitMap;
  R: TRect;
begin
  if FIndex <> -1
  then
    SkinDrawItem(Index, Cnvs)
  else
    DefaultDrawItem(Index, Cnvs);
end;

procedure TspSkinGridView.CreateControlDefaultImage(B: TBitMap);
var
  I, SaveIndex: Integer;
  R: TRect;
begin
  //
  R := Rect(0, 0, Width, Height);
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  InflateRect(R, -1, -1);
  with B.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(R);
  end;
  //
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinGridView.CreateControlSkinImage(B: TBitMap);
var
  I, SaveIndex: Integer;
begin
  inherited;
  CalcItemRects;
  SaveIndex := SaveDC(B.Canvas.Handle);
  IntersectClipRect(B.Canvas.Handle,
    FItemsRect.Left, FItemsRect.Top, FItemsRect.Right, FItemsRect.Bottom);
  for I := 0 to FItems.Count - 1 do
   if FItems[I].IsVisible then DrawItem(I, B.Canvas);
  RestoreDC(B.Canvas.Handle, SaveIndex);
end;

procedure TspSkinGridView.CalcItemRects;
var
  I, J, Col: Integer;
  X, Y, W, H: Integer;
begin
  if FIndex <> -1
  then
    FItemsRect := RealClientRect
  else
    FItemsRect := Rect(2, 2, Width - 2, Height - 2);
  if ScrollBar <> nil then Dec(FItemsRect.Right, ScrollBar.Width);
  //
  RowCount := RectHeight(FItemsRect) div ItemHeight;
  ColCount := RectWidth(FItemsRect) div ItemWidth;
  if RowCount = 0 then RowCount := 1;
  if ColCount = 0 then ColCount := 1;
  //
  FRealMax := 0;
  Y := FItemsRect.Top;
  X := FItemsRect.Left;
  Col := 0;
  for i := 0 to Items.Count - 1 do
  begin
    if Items[i].Header
    then
      begin
        X := FItemsRect.Left;
        if i <> 0 then Y := Y + ItemHeight;
        Items[i].ItemRect := Rect(X, Y, X + RectWidth(FItemsRect), Y + HeaderHeight);
        Y := Y + HeaderHeight;
        Col := 0;
      end
    else
    if Col = ColCount
    then
      begin
        X := FItemsRect.Left;
        Y := Y + ItemHeight;
        Col := 0
      end;
    //
    if not Items[i].Header
    then
      Items[i].ItemRect := Rect(X, Y, X + ItemWidth, Y + ItemHeight);
    //
    OffsetRect(Items[i].ItemRect, 0, - FScrollOffset);
    Items[i].IsVisible := RectToRect(Items[i].ItemRect, FItemsRect);
    if not Items[i].IsVisible and (Items[i].ItemRect.Top <= FItemsRect.Top) and
       (Items[i].ItemRect.Bottom >= FItemsRect.Bottom)
    then
      Items[i].IsVisible := True;
    if Items[i].IsVisible then FRealMax := Items[i].ItemRect.Bottom;
    //
    if not Items[i].Header
    then
      begin
        X := X + ItemWidth;
        Inc(Col);
      end;
  end;
  FMax := Y + ItemHeight;
end;


procedure TspSkinGridView.Scroll(AScrollOffset: Integer);
begin
  FScrollOffset := AScrollOffset;
  RePaint;
  UpdateScrollInfo;
end;

procedure TspSkinGridView.GetScrollInfo(var AMin, AMax, APage, APosition: Integer);
begin
  CalcItemRects;
  AMin := 0;
  AMax := FMax - FItemsRect.Top;
  APage := RectHeight(FItemsRect);
  if AMax <= APage
  then
    begin
      APage := 0;
      AMax := 0;
    end;  
  APosition := FScrollOffset;
end;

procedure TspSkinGridView.WMSize(var Msg: TWMSize);
begin
  inherited;
  if (FOldHeight <> Height) and (FOldHeight <> -1)
  then
    begin
      CalcItemRects;
      if (FRealMax <= FItemsRect.Bottom) and (FScrollOffset > 0)
      then
        begin
          FScrollOffset := FScrollOffset - (FItemsRect.Bottom - FRealMax);
          if FScrollOffset < 0 then FScrollOffset := 0;
          CalcItemRects;
          Invalidate;
        end;
    end;
  AdjustScrollBar;
  UpdateScrollInfo;
  FOldHeight := Height;
end;

procedure TspSkinGridView.ScrollToItem(Index: Integer);
var
  R, R1: TRect;
begin
  CalcItemRects;
  R1 := FItems[Index].ItemRect;
  R := R1;
  OffsetRect(R, 0, FScrollOffset);
  if (R1.Top <= FItemsRect.Top)
  then
    begin
      if (Index = 1) and FItems[Index - 1].Header
      then
        FScrollOffset := 0
      else
        FScrollOffset := R.Top - FItemsRect.Top;
      CalcItemRects;
      Invalidate;
    end
  else
  if R1.Bottom >= FItemsRect.Bottom
  then
    begin
      FScrollOffset := R.Top;
      FScrollOffset := FScrollOffset - RectHeight(FItemsRect) + RectHeight(R) -
        Height + FItemsRect.Bottom + 1;
      CalcItemRects;
      Invalidate;
    end;
  UpdateScrollInfo;  
end;

procedure TspSkinGridView.ShowScrollbar;
begin
  if ScrollBar = nil
  then
    begin
      ScrollBar := TspSkinScrollBar.Create(Self);
      ScrollBar.Visible := False;
      ScrollBar.Parent := Self;
      ScrollBar.DefaultHeight := 0;
      ScrollBar.DefaultWidth := 19;
      ScrollBar.SmallChange := ItemHeight;
      ScrollBar.LargeChange := ItemHeight;
      ScrollBar.SkinDataName := 'vscrollbar';
      ScrollBar.Kind := sbVertical;
      ScrollBar.SkinData := Self.SkinData;
      ScrollBar.OnChange := SBChange;
      AdjustScrollBar;
      ScrollBar.Visible := True;
      RePaint;
    end;
end;

procedure TspSkinGridView.HideScrollBar;
begin
  if ScrollBar = nil then Exit;
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  RePaint;
end;

procedure TspSkinGridView.UpdateScrollInfo;
var
  SMin, SMax, SPage, SPos: Integer;
begin
  //
  if not HandleAllocated then Exit;
  //
  if FInUpdateItems then Exit;
  GetScrollInfo(SMin, SMax, SPage, SPos);
  if SMax <> 0
  then
    begin
      if ScrollBar = nil then ShowScrollBar;
      ScrollBar.SetRange(SMin, SMax, SPos, SPage);
      ScrollBar.LargeChange := SPage;
    end
  else
  if (SMax = 0) and (ScrollBar <> nil)
  then
    begin
      HideScrollBar;
    end;
end;

procedure TspSkinGridView.AdjustScrollBar;
var
  R: TRect;
begin
  if ScrollBar = nil then Exit;
  if FIndex = -1
  then
    R := Rect(2, 2, Width - 2, Height - 2)
  else
    R := RealClientRect;
  Dec(R.Right, ScrollBar.Width);
  ScrollBar.SetBounds(R.Right, R.Top, ScrollBar.Width,
   RectHeight(R));
end;

procedure TspSkinGridView.SBChange(Sender: TObject);
begin
  Scroll(ScrollBar.Position);
end;

procedure TspSkinGridView.SkinDrawItem(Index: Integer; Cnvs: TCanvas);
var
  ListBoxData: TspDataSkinListBox;
  CheckListBoxData: TspDataSkinCheckListBox;
  CIndex, TX, TY: Integer;
  R, R1, CR: TRect;
  Buffer: TBitMap;
  C: TColor;
  SaveIndex: Integer;
begin
  if  FItems[Index].Header
  then
    begin
      SkinDrawHeaderItem(Index, Cnvs);
      Exit;
    end;

  CIndex := SkinData.GetControlIndex(FItemSkinDataName);
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  InflateRect(R, -2, -2);
  ListBoxData := TspDataSkinListBox(SkinData.CtrlList[CIndex]);
  Cnvs.Brush.Style := bsClear;
  //
  if (FDisabledFontColor = ListBoxData.FontColor) and
     (FDisabledFontColor = clBlack)
  then
    FDisabledFontColor := clGray;   
  //
  if not FUseSkinFont
  then
    Cnvs.Font.Assign(FDefaultFont)
  else
    with Cnvs.Font, ListBoxData do
    begin
      Name := FontName;
      Height := FontHeight;
      Style := FontStyle;
    end;

  if FItems[Index].Enabled
  then
    begin
      if (FSkinDataName = 'listbox') or
         (FSkinDataName = 'memo') or
         (FSkinDataName = 'menupagepanel')
      then
        Cnvs.Font.Color := ListBoxData.FontColor
      else
        Cnvs.Font.Color := FSD.SkinColors.cBtnText;
    end
  else
    Cnvs.Font.Color := FDisabledFontColor;


  with Cnvs.Font do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Charset := SkinData.ResourceStrData.CharSet
    else
      CharSet := FDefaultFont.Charset;
  end;
  //
  if (not FItems[Index].Active) or (not FItems[Index].Enabled)
  then
    with FItems[Index] do
    begin
      SaveIndex := SaveDC(Cnvs.Handle);
      IntersectClipRect(Cnvs.Handle, FItems[Index].ItemRect.Left, FItems[Index].ItemRect.Top,
        FItems[Index].ItemRect.Right, FItems[Index].ItemRect.Bottom);
      if Assigned(FOnDrawItem)
      then
        begin
          Cnvs.Brush.Style := bsClear;
          FOnDrawItem(Cnvs, Index, R);
        end
      else
        begin
          DrawImageAndText(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
             Caption, FImageIndex, FImages, False, Enabled, False, 0);
        end;
      RestoreDC(Cnvs.Handle, SaveIndex);
    end
  else
    with FItems[Index] do
    begin
      Buffer := TBitMap.Create;
      R := FItems[Index].ItemRect;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      //
      with ListBoxData do
      if Focused
      then
        CreateStretchImage(Buffer, Picture, FocusItemRect, ItemTextRect, True)
      else
        CreateStretchImage(Buffer, Picture, ActiveItemRect, ItemTextRect, True);
      //
     if not FUseSkinFont
     then
       Buffer.Canvas.Font.Assign(FDefaultFont)
     else
       with Buffer.Canvas.Font, ListBoxData do
       begin
         Name := FontName;
         Height := FontHeight;
         Style := FontStyle;
       end;

       if Focused
       then
         Buffer.Canvas.Font.Color := ListBoxData.FocusFontColor
       else
         Buffer.Canvas.Font.Color := ListBoxData.ActiveFontColor;

       with Buffer.Canvas.Font do
       begin
         if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
         then
           Charset := SkinData.ResourceStrData.CharSet
         else
           CharSet := FDefaultFont.Charset;
        end;

       R := Rect(2, 2, Buffer.Width - 2, Buffer.Height - 2);

      if Assigned(FOnDrawItem)
      then
        begin
          Buffer.Canvas.Brush.Style := bsClear;
          FOnDrawItem(Buffer.Canvas, Index, R);
        end
      else
       begin
         DrawImageAndText(Buffer.Canvas, R, FItemMargin, FItemSpacing, FItemLayout,
          Caption, FImageIndex, FImages, False, Enabled, False, 0);
        end;

      Cnvs.Draw(FItems[Index].ItemRect.Left,
        FItems[Index].ItemRect.Top, Buffer);
        
      Buffer.Free;
    end;
end;

procedure TspSkinGridView.DefaultDrawItem(Index: Integer; Cnvs: TCanvas);
var
  R, R1, CR: TRect;
  C, FC: TColor;
  TX, TY: Integer;
  SaveIndex: Integer;
begin
  if FItems[Index].Header
  then
    begin
      C := clBtnShadow;
      FC := clBtnHighLight;
    end
  else
  if FItems[Index].Active
  then
    begin
      C := clHighLight;
      FC := clHighLightText;
     end
  else
    begin
      C := clWindow;
      if FItems[Index].Enabled
      then
        FC := clWindowText
      else
        FC := clGray;  
    end;
  //
  Cnvs.Font := FDefaultFont;
  Cnvs.Font.Color := FC;
  //
  R := FItems[Index].ItemRect;
  SaveIndex := SaveDC(Cnvs.Handle);
  IntersectClipRect(Cnvs.Handle, R.Left, R.Top, R.Right, R.Bottom);
  //
  Cnvs.Brush.Color := C;
  Cnvs.Brush.Style := bsSolid;
  Cnvs.FillRect(R);
  Cnvs.Brush.Style := bsClear;
  //
  InflateRect(R, -2, -2);
  if FItems[Index].Header
  then
    with FItems[Index] do
    begin
      if FHeaderLeftAlignment
      then
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_LEFT or DT_VCENTER or DT_SINGLELINE)
      else
        DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), R,
          DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
  else
    with FItems[Index] do
    begin
      if Assigned(FOnDrawItem)
      then
        begin
          Cnvs.Brush.Style := bsClear;
          FOnDrawItem(Cnvs, Index, FItems[Index].ItemRect);
        end
      else
        begin
         DrawImageAndText(Cnvs, R, FItemMargin, FItemSpacing, FItemLayout,
             Caption, FImageIndex, FImages, False, Enabled, False, 0);
        end;
    end;
  if FItems[Index].Active and Focused
  then
    Cnvs.DrawFocusRect(FItems[Index].ItemRect);
  RestoreDC(Cnvs.Handle, SaveIndex);   
end;



procedure TspSkinGridView.SkinDrawHeaderItem(Index: Integer; Cnvs: TCanvas);
var
  Buffer: TBitMap;
  CIndex: Integer;
  LData: TspDataSkinLabelControl;
  R, TR: TRect;
  CPicture: TBitMap;
begin
  CIndex := SkinData.GetControlIndex(FHeaderSkinDataName);
  if CIndex = -1
  then
    CIndex := SkinData.GetControlIndex('label');
  if CIndex = -1 then Exit;
  R := FItems[Index].ItemRect;
  LData := TspDataSkinLabelControl(SkinData.CtrlList[CIndex]);
  CPicture := TBitMap(FSD.FActivePictures.Items[LData.PictureIndex]);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectHeight(R);
  with LData do
  begin
    CreateStretchImage(Buffer, CPicture, SkinRect, ClRect, True);
  end;
  TR := Rect(1, 1, Buffer.Width - 1, Buffer.Height - 1);

  if FHeaderLeftAlignment then TR.Left := LData.ClRect.Left;

  with Buffer.Canvas, LData do
  begin
    Font.Name := FontName;
    Font.Color := FontColor;
    Font.Height := FontHeight;
    Font.Style := FontStyle;
    Brush.Style := bsClear;
  end;
  with FItems[Index] do
    if FHeaderLeftAlignment
    then
      DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
       DT_LEFT or DT_VCENTER or DT_SINGLELINE)
    else
      DrawText(Buffer.Canvas.Handle, PChar(Caption), Length(Caption), TR,
       DT_CENTER or DT_VCENTER or DT_SINGLELINE);

  Cnvs.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
end;


procedure TspSkinGridView.SetItemIndex(Value: Integer);
var
  I: Integer;
  IsFind: Boolean;
begin
  if Value < 0
  then
    begin
      FItemIndex := Value;
      RePaint;
    end
  else
    begin
      FItemIndex := Value;
      IsFind := False;
      for I := 0 to FItems.Count - 1 do
        with FItems[I] do
        begin
          if I = FItemIndex
          then
            begin
              Active := True;
              IsFind := True;
            end
          else
             Active := False;
        end;
      RePaint;
      ScrollToItem(FItemIndex);
      if IsFind and not (csDesigning in ComponentState) and not (csLoading in ComponentState)
      then
      begin
        if Assigned(FItems[FItemIndex].OnClick) then
          FItems[FItemIndex].OnClick(Self);
        if Assigned(FOnItemClick) then
          FOnItemClick(Self);
      end;    
    end;
end;

procedure TspSkinGridView.Loaded;
begin
  inherited;
end;

function TspSkinGridView.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(FItems[I].ItemRect, Point(X, Y)) and (FItems[I].Enabled)
    then
      begin
        Result := I;
        Break;
      end;  
end;


procedure TspSkinGridView.MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft)
  then
    begin
      SetItemActive(I);
      FMouseDown := True;
      FMouseActive := I;
    end;
end;

procedure TspSkinGridView.MouseUp(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
var
  I: Integer;
  P: TPoint;
begin
  inherited;
  FMouseDown := False;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (Button = mbLeft)
  then
    begin
      ItemIndex := I;
    end;  
end;

procedure TspSkinGridView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  I := ItemAtPos(X, Y);
  if (I <> -1) and not (FItems[I].Header) and (FMouseDown or FMouseMoveChangeIndex)
   and (I <> FMouseActive)
  then
    begin
      SetItemActive(I);
      FMouseActive := I;
    end;
end;

procedure TspSkinGridView.SetItemActive(Value: Integer);
var
  I: Integer;
begin
  FItemIndex := Value;
  for I := 0 to FItems.Count - 1 do
  with FItems[I] do
   if I = Value then Active := True else Active := False;
  RePaint;
  ScrollToItem(Value);
end;

procedure TspSkinGridView.WMMOUSEWHEEL(var Message: TMessage);
begin
  inherited;
  if ScrollBar = nil then Exit;
  if Message.WParam < 0
  then
    ScrollBar.Position :=  ScrollBar.Position + ScrollBar.SmallChange
  else
    ScrollBar.Position :=  ScrollBar.Position - ScrollBar.SmallChange;

end;

procedure TspSkinGridView.WMSETFOCUS(var Message: TWMSETFOCUS);
begin
  inherited;
  RePaint;
end;

procedure TspSkinGridView.WMKILLFOCUS(var Message: TWMKILLFOCUS); 
begin
  inherited;
  RePaint;
end;

procedure TspSkinGridView.WndProc(var Message: TMessage);
begin
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

procedure TspSkinGridView.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TspSkinGridView.FindUp;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - ColCount;
  if Start < 0 then Start := 0;
  //
  for I := FItemIndex downto Start do
    if FItems[I].Header
    then
      begin
        Start := I;
        Break;
      end;
  //
  for I := Start downto 0 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled and (ItemIndex <> I)
    then
      begin
        ItemIndex := I;
        Exit;
      end;  
  end;
end;

procedure TspSkinGridView.FindDown;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + ColCount;
  if Start > FItems.Count - 1 then Start := FItems.Count - 1;
  //
  for I := FItemIndex to Start do
    if FItems[I].Header
    then
      begin
        Start := I;
        Break;
      end;
  //
  for I := Start to FItems.Count - 1 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled and (ItemIndex <> I)
    then
      begin
        ItemIndex := I;
        Exit;
      end;
  end;
end;

procedure TspSkinGridView.FindLeft;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  for I := Start downto 0 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;  
  end;
end;

procedure TspSkinGridView.FindRight;
var
  I, Start: Integer;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  for I := Start to FItems.Count - 1 do
  begin
    if (not FItems[I].Header) and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end;
  end;
end;

procedure TspSkinGridView.FindPageUp;
var
  I, J, Start: Integer;
  PageCount: Integer;
  FindHeader: Boolean;
begin
  if ItemIndex <= -1 then Exit;
  Start := FItemIndex - 1;
  if Start < 0 then Exit;
  PageCount := (RectHeight(FItemsRect) div FItemHeight) * ColCount;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start - PageCount;
  if PageCount < 0 then PageCount := 0;
  FindHeader := False;
  J := -1;
  for I := Start downto PageCount do
  begin
    if not FItems[I].Header and FindHeader and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end
    else
    if FItems[I].Header
    then
      begin
        FindHeader := True;
        Continue;
      end
    else
    if not FItems[I].Header and FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;


procedure TspSkinGridView.FindPageDown;
var
  I, J, Start: Integer;
  PageCount: Integer;
  FindHeader: Boolean;
begin
  if ItemIndex <= -1 then Start := 0 else Start := FItemIndex + 1;
  if Start > FItems.Count - 1 then Exit;
  PageCount := (RectHeight(FItemsRect) div FItemHeight) * ColCount;
  if PageCount = 0 then PageCount := 1;
  PageCount := Start + PageCount;
  if PageCount > FItems.Count - 1 then PageCount := FItems.Count - 1;
  FindHeader := False;
  J := -1;
  for I := Start to PageCount do
  begin
    if not FItems[I].Header and FindHeader  and FItems[I].Enabled
    then
      begin
        ItemIndex := I;
        Exit;
      end
    else
    if FItems[I].Header
    then
      begin
        FindHeader := True;
        Continue;
      end
    else
    if not FItems[I].Header  and FItems[I].Enabled
    then
      begin
        J := I;
      end;
  end;
  if J <> -1 then ItemIndex := J;
end;

procedure TspSkinGridView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;


procedure TspSkinGridView.KeyDown(var Key: Word; Shift: TShiftState);
begin
 inherited KeyDown(Key, Shift);
 case Key of
   VK_NEXT:  FindPageDown;
   VK_PRIOR: FindPageUp;
   VK_LEFT: FindLeft;
   VK_UP: FindUp;
   VK_DOWN: FindDown;
   VK_RIGHT: FindRight;
 end;
end;

end.

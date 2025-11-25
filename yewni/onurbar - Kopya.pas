unit onurbar;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  WIndows,{$ELSE}unIx, LCLIntf, {$ENDIF}LMessages, Classes, ExtCtrls, Controls, Graphics, SysUtils, Math,
  BGRABItmap, BGRABItmapTypes, onurctrl;

type
  // Common definitions
  TONURState = (obsNormal, obsHover, obsPressed, obsDisabled);
  TONUROrientation = (oroHorizontal, oroVertical);
  TONURStyle = (osModern, osClassic, osMinimal, osFull, osHalf,
    osQuarter, osThreeQuarter, osSolid, osSegmented, osDotted, osLinear,
    osCircular, osDots, osBars, osArc);
  TONURProgressBarTextStyle = (ptsNone, ptsPercentage, ptsValue, ptsCustom);
  TONURRangeBarThumb = (rbtLeft, rbtRIght);
  TONURAutoHide = (oahNever, oahOnMouseLeave, oahAlways);
  // Time Bar
  TONURTimeBarMode = (tbmClock, tbmCountdown, tbmStopwatch, tbmProgress);

  // Loading Bar
  TONURLoadingBarMode = (ormDeterminate, ormIndeterminate);

  // Progress Ring
  //  TONURProgressRingMode = (ormDeterminate, ormIndeterminate);
  { TONURProgressBar }

  TONURProgressBar = class(TONURGraphIcControl)
  private
    FOrIentatIon: TONUROrientation;
    FPosItIon, FMin, FMax: integer;
    FTextStyle: TONURProgressBarTextStyle;
    FCustomText: string;
    FAnImated: boolean;
    FAnImatIonSpeed: real;
    FTargetPosItIon: integer;
    FAnImatIonTImer: TTImer;

    // 3-parca background
    FBackLeftNormal, FBackCenterNormal, FBackRIghtNormal: TONURCUSTOMCROP;
    FBackLeftDIsabled, FBackCenterDIsabled, FBackRIghtDIsabled: TONURCUSTOMCROP;

    // Bar
    FBarNormal, FBarHover, FBarDIsabled: TONURCUSTOMCROP;

    // Overlay (glossy effect)
    FOverlayNormal, FOverlayDIsabled: TONURCUSTOMCROP;

    FOnChange: TNotifyEvent;

    procedure SetOrIentatIon(Value: TONUROrientation);
    procedure SetPosItIon(Value: integer);
    procedure SetMIn(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetTextStyle(Value: TONURProgressBarTextStyle);
    procedure SetCustomText(Value: string);
    procedure SetAnImated(Value: boolean);
    procedure SetAnImatIonSpeed(Value: real);

    procedure UpdateLayout;
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DrawBaseProgressBar;

    procedure DoAnImatIonTImer(Sender: TObject);
    function GetPercentage: integer;
    function GetBarRect: TRect;
    function GetTextRect: TRect;
    function GetDIsplayText: string;

  protected
    procedure PaInt; override;
    procedure ResIze; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetPercentage(Value: integer);
    procedure IncrementBy(Value: integer = 1);

  published
    property OrIentatIon: TONUROrientation read FOrIentatIon
      write SetOrIentatIon default oroHorIzontal;
    property PosItIon: integer read FPosItIon write SetPosItIon default 0;
    property MIn: integer read FMin write SetMIn default 0;
    property Max: integer read FMax write SetMax default 100;
    property TextStyle: TONURProgressBarTextStyle
      read FTextStyle write SetTextStyle default ptsPercentage;
    property CustomText: string read FCustomText write SetCustomText;
    property AnImated: boolean read FAnImated write SetAnImated default True;
    property AnImatIonSpeed: real read FAnImatIonSpeed write SetAnImatIonSpeed;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Alpha;
    property SkIndata;
    property AlIgn;
    property Anchors;
    property BorderSpacIng;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property Font;
    property ParentFont;
    property ShowHInt;
    property PopupMenu;
    property OnClIck;
    property OnDblClIck;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResIze;
  end;

  { TONURScrollBar }

  TONURScrollBar = class(TONURGraphIcControl)
  private
    FOrIentatIon: TONUROrientation;
    FPosItIon, FMin, FMax: integer;
    FPageSIze: integer;
    FAutoHIde: TONURAutoHide;
    FIsVIsIble: boolean;
    FMouseOver: boolean;

    FLeftButtonState, FRIghtButtonState, FThumbState: TONURState;
    FIsDraggIng: boolean;
    FDragStartPos: integer;
    FDragStartValue: integer;

    FAutoHIdeTImer: TTImer;
    FAnImatIonTImer: TTImer;
    FAnImatIonProgress: real;
    FThumbSIze: integer;
    FTargetThumbSIze: integer;

    //FBackNormal, FBackHover, FBackDIsabled: TONURCUSTOMCROP;
    FBackLeftNormal, FBackCenterNormal, FBackRIghtNormal: TONURCUSTOMCROP;
    FBackLeftHover, FBackCenterHover, FBackRIghtHover: TONURCUSTOMCROP;
    FBackLeftDIsabled, FBackCenterDIsabled, FBackRIghtDIsabled: TONURCUSTOMCROP;
    FLeftNormal, FLeftHover, FLeftPressed, FLeftDIsabled: TONURCUSTOMCROP;
    FRIghtNormal, FRIghtHover, FRIghtPressed, FRIghtDIsabled: TONURCUSTOMCROP;
    FThumbNormal, FThumbHover, FThumbPressed, FThumbDIsabled: TONURCUSTOMCROP;

    FLeftRect, FRIghtRect, FThumbRect, FTrackRect: TRect;

    FOnChange: TNotifyEvent;
    FOnScroll: TNotifyEvent;

    procedure SetOrIentatIon(Value: TONUROrientation);
    procedure SetPosItIon(Value: integer);
    procedure SetMIn(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetPageSIze(Value: integer);
    procedure SetAutoHIde(Value: TONURAutoHide);

    procedure UpdateLayout;
    procedure UpdateThumbSIze;
    procedure StartAutoHIdeTImer;
    procedure StopAutoHIdeTImer;
    procedure DrawBaseScrollBar;

    procedure DoAutoHIdeTImer(Sender: TObject);
    procedure DoAnImatIonTImer(Sender: TObject);

    function GetThumbRect: TRect;
    function PoIntInThumb(X, Y: integer): boolean;
    function PoIntInLeftButton(X, Y: integer): boolean;
    function PoIntInRIghtButton(X, Y: integer): boolean;
    function PoIntInTrack(X, Y: integer): boolean;

    procedure ScrollToPosItIon(NewPosItIon: integer);
    procedure BeginDrag(X, Y: integer);
    procedure EndDrag;
    procedure UpdateDrag(X, Y: integer);

  protected
    procedure PaInt; override;
    procedure MouseDown(Button: TMouseButton; ShIft: TShIftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; ShIft: TShIftState; X, Y: integer); override;
    procedure MouseMove(ShIft: TShIftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    function DoMouseWheel(ShIft: TShIftState; WheelDelta: integer;
      MousePos: TPoInt): boolean; override;
    //    procedure MouseWheel(Sender: TObject; ShIft: TShIftState; WheelDelta: Integer; MousePos: TPoInt; var Handled: Boolean); overrIde;
    procedure ResIze; override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;

    procedure ScrollBy(Delta: integer);
    procedure ScrollToTop;
    procedure ScrollToBottom;
    procedure ShowScrollBar;
    procedure HIdeScrollBar;

  published
    property OrIentatIon: TONUROrientation read FOrIentatIon
      write SetOrIentatIon default oroHorIzontal;
    property PosItIon: integer read FPosItIon write SetPosItIon default 0;
    property MIn: integer read FMin write SetMIn default 0;
    property Max: integer read FMax write SetMax default 100;
    property PageSIze: integer read FPageSIze write SetPageSIze default 10;
    property AutoHIde: TONURAutoHide read FAutoHIde write SetAutoHIde default
    oahNever;

    property Alpha;
    property SkIndata;
    property AlIgn;
    property Anchors;
    property BorderSpacIng;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property ParentShowHInt;
    property ShowHInt;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheel;
    property OnResIze;
  end;



  { TONURTrackBar }



  TONURTrackBar = class(TONURGraphIcControl)
  private
    FOrIentatIon: TONUROrientation;
    FPosItIon, FMin, FMax: integer;
    FState: TONURState;
    FIsPressed: boolean;
    FDragStartPos: integer;
    FDragStartValue: integer;
    FThumbRect, FTrackRect: TRect;
    FOnChange: TNotifyEvent;

    // Additional properties
    FShowValue: boolean;
    FShowTicks: boolean;
    FTickCount: integer;
    FThumbSize: integer;
    FTrackHeight: integer;
    FTargtValue: integer;
    FIsDragging: boolean;

    // Track parts
    FTrackNormal, FTrackHover, FTrackPressed, FTrackDisabled: TONURCUSTOMCROP;

    // 3-parca background
    FBackLeftNormal, FBackCenterNormal, FBackRIghtNormal: TONURCUSTOMCROP;
    FBackLeftDIsabled, FBackCenterDIsabled, FBackRIghtDIsabled: TONURCUSTOMCROP;

    // Thumb
    FThumbNormal, FThumbHover, FThumbPressed, FThumbDIsabled: TONURCUSTOMCROP;

    procedure SetOrIentatIon(Value: TONUROrientation);
    procedure SetPosItIon(Value: integer);
    procedure SetMIn(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetShowValue(Value: boolean);
    procedure SetShowTicks(Value: boolean);
    procedure SetTickCount(Value: integer);
    procedure SetThumbSize(Value: integer);
    procedure SetTrackHeight(Value: integer);

    procedure UpdateLayout;
    procedure UpdateThumbRect;

    function GetPercentage: integer;
    function PosItIonFromPoInt(X, Y: integer): integer;

    // procedure BGRAReplaceCustomCrops(Canvas: TCanvas; CustomCrop: TONURCUSTOMCROP);


    procedure DrawBaseTrackBar;

    function PoIntInTrack(X, Y: integer): boolean;
    function PoIntInThumb(X, Y: integer): boolean;
    procedure UpdateDrag(X, Y: integer);
    procedure EndDrag;
    procedure BeginDrag(X, Y: integer);


  protected
    procedure PaInt; override;
    procedure MouseDown(Button: TMouseButton; ShIft: TShIftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; ShIft: TShIftState; X, Y: integer); override;
    procedure MouseMove(ShIft: TShIftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure ResIze; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetPercentage(Value: integer);

  published
    property OrIentatIon: TONUROrientation read FOrIentatIon
      write SetOrIentatIon default oroHorIzontal;
    property PosItIon: integer read FPosItIon write SetPosItIon default 0;
    property MIn: integer read FMin write SetMIn default 0;
    property Max: integer read FMax write SetMax default 100;
    property Percentage: integer read GetPercentage write SetPercentage;
    property ShowValue: boolean read FShowValue write SetShowValue default True;
    property ShowTicks: boolean read FShowTicks write SetShowTicks default True;
    property TickCount: integer read FTickCount write SetTickCount default 10;
    property ThumbSize: integer read FThumbSize write SetThumbSize default 20;
    property TrackHeight: integer read FTrackHeight write SetTrackHeight default 6;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Alpha;
    property SkIndata;
    property AlIgn;
    property Anchors;
    property BorderSpacIng;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property Font;
    property ParentFont;
    property ShowHInt;
    property PopupMenu;
    property OnClIck;
    property OnDblClIck;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResIze;
  end;

  { TONURRangeBar }

  { TONURSliderBar }

  TONURSliderBar = class(TONURGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FStyle: TONURStyle;
    FState: TONURState;
    FOrientation: TONUROrientation;
    FAnimated: boolean;
    FTargetValue: integer;
    FAnimationSpeed: real;
    FAnimationTimer: TTimer;
    FOnChange: TNotifyEvent;

    // Visual properties
    FShowValue: boolean;
    FShowTicks: boolean;
    FTickCount: integer;
    FThumbSize: integer;
    FTrackHeight: integer;
    FIsDragging: boolean;
    FDragStartPos: integer;
    FDragStartValue: integer;
    FTrackRect, FThumbRect: TRect;

    // Skin parts
    FTrackNormal, FTrackHover, FTrackPressed, FTrackDisabled: TONURCUSTOMCROP;
    FThumbNormal, FThumbHover, FThumbPressed, FThumbDisabled: TONURCUSTOMCROP;

    // Setters
    procedure DrawWithSkins;
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetStyle(Value: TONURStyle);
    procedure SetOrientation(Value: TONUROrientation);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);
    procedure SetShowValue(Value: boolean);
    procedure SetShowTicks(Value: boolean);
    procedure SetTickCount(Value: integer);
    procedure SetThumbSize(Value: integer);
    procedure SetTrackHeight(Value: integer);
    procedure SetPercentage(Value: integer);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimationTimer(Sender: TObject);

    // Layout
    procedure UpdateLayout;
    procedure UpdateThumbRect;
    procedure DrawBaseSliderBar;

    // Helpers
    function GetPercentage: integer;
    function PositionFromPoint(X, Y: integer): integer;
    function PointInThumb(X, Y: integer): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
      override;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  published
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Style: TONURStyle read FStyle write SetStyle default osModern;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default oroHorizontal;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;
    property ShowValue: boolean read FShowValue write SetShowValue default True;
    property ShowTicks: boolean read FShowTicks write SetShowTicks default True;
    property TickCount: integer read FTickCount write SetTickCount default 10;
    property ThumbSize: integer read FThumbSize write SetThumbSize default 20;
    property TrackHeight: integer read FTrackHeight write SetTrackHeight default 6;
    property Percentage: integer read GetPercentage write SetPercentage;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property Font;
    property ParentFont;
    property ShowHint;
    property PopupMenu;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

  TONURRangeBar = class(TONURGraphIcControl)
  private
    FOrIentatIon: TONUROrientation;
    FMin, FMax: integer;
    FRangeStart, FRangeEnd: integer;
    FState: TONURState;
    FActIveThumb: TONURRangeBarThumb;
    FIsPressed: boolean;
    FDragStartPos: integer;
    FDragStartValue: integer;
    FLeftThumbRect, FRIghtThumbRect, FTrackRect, FRangeRect: TRect;
    FOnChange: TNotifyEvent;

    // 3-parca background
    FBackLeftNormal, FBackCenterNormal, FBackRIghtNormal: TONURCUSTOMCROP;
    FBackLeftDIsabled, FBackCenterDIsabled, FBackRIghtDIsabled: TONURCUSTOMCROP;

    // Thumblar
    FLeftThumbNormal, FLeftThumbHover, FLeftThumbPressed,
    FLeftThumbDIsabled: TONURCUSTOMCROP;
    FRIghtThumbNormal, FRIghtThumbHover, FRIghtThumbPressed,
    FRIghtThumbDIsabled: TONURCUSTOMCROP;

    procedure SetOrIentatIon(Value: TONUROrientation);
    procedure SetMIn(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetRangeStart(Value: integer);
    procedure SetRangeEnd(Value: integer);
    procedure SetRange(StartValue, EndValue: integer);

    procedure UpdateLayout;
    procedure UpdateThumbRects;

    function GetPercentageStart: integer;
    function GetPercentageEnd: integer;
    function GetRangeLength: integer;
    function PosItIonFromPoInt(X, Y: integer): integer;
    function PoIntInLeftThumb(X, Y: integer): boolean;
    function PoIntInRIghtThumb(X, Y: integer): boolean;
    function PoIntInTrack(X, Y: integer): boolean;
    function PoIntInRange(X, Y: integer): boolean;

    procedure BeginDrag(Thumb: TONURRangeBarThumb; X, Y: integer);
    procedure EndDrag;
    procedure UpdateDrag(X, Y: integer);
    procedure DrawBaseRangeBar;

  protected
    procedure PaInt; override;
    procedure MouseDown(Button: TMouseButton; ShIft: TShIftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; ShIft: TShIftState; X, Y: integer); override;
    procedure MouseMove(ShIft: TShIftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure ResIze; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SelectAll;
    procedure SelectNone;
    procedure SetPercentageRange(StartPerc, EndPerc: integer);

  published
    property OrIentatIon: TONUROrientation read FOrIentatIon
      write SetOrIentatIon default oroHorIzontal;
    property MIn: integer read FMin write SetMIn default 0;
    property Max: integer read FMax write SetMax default 100;
    property RangeStart: integer read FRangeStart write SetRangeStart default 25;
    property RangeEnd: integer read FRangeEnd write SetRangeEnd default 75;
    property PercentageStart: integer read GetPercentageStart;
    property PercentageEnd: integer read GetPercentageEnd;
    property RangeLength: integer read GetRangeLength;

    property Alpha;
    property SkIndata;
    property AlIgn;
    property Anchors;
    property BorderSpacIng;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property Font;
    property ParentFont;
    property ShowHInt;
    property PopupMenu;
    property OnClIck;
    property OnDblClIck;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResIze;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TONURGaugeBar }



  TONURGaugeBar = class(TONURGraphIcControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FStyle: TONURStyle;
    FState: TONURState;
    FStartAngle, FEndAngle: integer;  // Derece cinsinden
    FCenterX, FCenterY: integer;
    FRadius, FInnerRadius: integer;
    FShowScale: boolean;
    FScaleCount: integer;
    FShowNeedle: boolean;
    FNeedleLength: integer;
    FNeedleColor: TColor;
    FAnImated: boolean;
    FTargtValue: integer;
    FAnImatIonSpeed: real;
    FAnImatIonTImer: TTImer;
    FOnChange: TNotifyEvent;

    // Background parts
    FBackNormal, FBackHover, FBackPressed, FBackDIsabled: TONURCUSTOMCROP;

    // Needle parts
    FNeedleNormal, FNeedleHover, FNeedlePressed, FNeedleDIsabled: TONURCUSTOMCROP;

    procedure SetMIn(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetStyle(Value: TONURStyle);
    procedure SetShowScale(Value: boolean);
    procedure SetScaleCount(Value: integer);
    procedure SetShowNeedle(Value: boolean);
    procedure SetNeedleLength(Value: integer);
    procedure SetNeedleColor(Value: TColor);
    procedure SetAnImated(Value: boolean);
    procedure SetAnImatIonSpeed(Value: real);

    procedure UpdateLayout;
    procedure UpdateAngles;
    function ValueToAngle(Value: integer): integer;
    function AngleToValue(Angle: integer): integer;
    function GetPercentage: integer;

    procedure StartAnImatIon;
    procedure StopAnImatIon;
    procedure DoAnImatIonTImer(Sender: TObject);
    procedure DrawBaseGaugeBar;

  protected
    procedure PaInt; override;
    procedure MouseDown(Button: TMouseButton; ShIft: TShIftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; ShIft: TShIftState; X, Y: integer); override;
    procedure MouseMove(ShIft: TShIftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure ResIze; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetPercentage(Value: integer);
    procedure AnimateToValue(Value: integer);

  published
    property MIn: integer read FMin write SetMIn default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Percentage: integer read GetPercentage;
    property Style: TONURStyle read FStyle write SetStyle default osFull;
    property ShowScale: boolean read FShowScale write SetShowScale default True;
    property ScaleCount: integer read FScaleCount write SetScaleCount default 10;
    property ShowNeedle: boolean read FShowNeedle write SetShowNeedle default True;
    property NeedleLength: integer read FNeedleLength write SetNeedleLength default 80;
    property NeedleColor: TColor read FNeedleColor write SetNeedleColor;
    property AnImated: boolean read FAnImated write SetAnImated default True;
    property AnImatIonSpeed: real read FAnImatIonSpeed write SetAnImatIonSpeed;

    property Alpha;
    property SkIndata;
    property AlIgn;
    property Anchors;
    property BorderSpacIng;
    property Color;
    property Enabled;
    property Visible;
    property ParentColor;
    property Font;
    property ParentFont;
    property ShowHInt;
    property PopupMenu;
    property OnClIck;
    property OnDblClIck;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResIze;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  // Meter Bar

  TONURMeterBar = class(TONURGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FStyle: TONURStyle;
    FState: TONURState;
    FStartAngle, FEndAngle: integer;
    FCenterX, FCenterY: integer;
    FRadius, FInnerRadius: integer;
    FShowScale: boolean;
    FScaleCount: integer;
    FShowLabels: boolean;
    FShowValue: boolean;
    FAnimated: boolean;
    FTargetValue: integer;
    FAnimationSpeed: real;
    FAnimationTimer: TTimer;
    FMeterRect: TRect;
    FOnChange: TNotifyEvent;

    // Setters
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetStyle(Value: TONURStyle);
    procedure SetStartAngle(Value: integer);
    procedure SetEndAngle(Value: integer);
    procedure SetShowScale(Value: boolean);
    procedure SetScaleCount(Value: integer);
    procedure SetShowLabels(Value: boolean);
    procedure SetShowValue(Value: boolean);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimation(Sender: TObject);

    // Layout
    procedure UpdateLayout;
    procedure UpdateAngles;

    // Drawing
    procedure DrawBaseMeterBar;

    // Helpers
    function ValueToAngle(Value: integer): integer;
    function AngleToValue(Angle: integer): integer;
    function GetPercentage: integer;
    function PositionFromPoint(X, Y: integer): integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure SetPercentage(Value: integer);
    procedure AnimateToValue(Value: integer);
    procedure Reset;

  published
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Percentage: integer read GetPercentage;
    property Style: TONURStyle read FStyle write SetStyle;
    property StartAngle: integer read FStartAngle write SetStartAngle default -90;
    property EndAngle: integer read FEndAngle write SetEndAngle default 90;
    property ShowScale: boolean read FShowScale write SetShowScale default True;
    property ScaleCount: integer read FScaleCount write SetScaleCount default 10;
    property ShowLabels: boolean read FShowLabels write SetShowLabels default True;
    property ShowValue: boolean read FShowValue write SetShowValue default True;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  // Switch Bar

  TONURSwitchBar = class(TONURGraphicControl)
  private
    FChecked: boolean;
    FState: TONURState;
    FShowText: boolean;
    FTextOn: string;
    FTextOff: string;
    FAnimated: boolean;
    FAnimationProgress: real;
    FAnimationSpeed: real;
    FAnimationTimer: TTimer;
    FThumbRect: TRect;
    FTrackRect: TRect;
    FIsDragging: boolean;
    FOnChange: TNotifyEvent;

    // Skin parts
    FTrackNormal, FTrackHover, FTrackPressed, FTrackDisabled: TONURCUSTOMCROP;
    FThumbOnNormal, FThumbOnHover, FThumbOnPressed, FThumbOnDisabled: TONURCUSTOMCROP;
    FThumbOffNormal, FThumbOffHover, FThumbOffPressed,
    FThumbOffDisabled: TONURCUSTOMCROP;

    // Setters
    procedure SetChecked(Value: boolean);
    procedure SetShowText(Value: boolean);
    procedure SetTextOn(Value: string);
    procedure SetTextOff(Value: string);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimation(Sender: TObject);

    // Layout
    procedure UpdateLayout;
    procedure UpdateThumbRect;

    // Drawing
    procedure DrawBaseSwitchBar;
    procedure DrawWithSkins;

    // Helpers
    function PointInThumb(X, Y: integer): boolean;
    function PointInTrack(X, Y: integer): boolean;

  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure Toggle;
    procedure TurnOn;
    procedure TurnOff;

  published
    property Checked: boolean read FChecked write SetChecked default False;
    property ShowText: boolean read FShowText write SetShowText default True;
    property TextOn: string read FTextOn write SetTextOn;
    property TextOff: string read FTextOff write SetTextOff;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;
  // Time Bar

  TONURTimeBar = class(TONURGraphicControl)
  private
    FMode: TONURTimeBarMode;
    FState: TONURState;
    FCurrentTime: TDateTime;
    FTargetTime: TDateTime;
    FStartTime: TDateTime;
    FEndTime: TDateTime;
    FShowSeconds: boolean;
    FShowDate: boolean;
    FShowLabels: boolean;
    FShowMarkers: boolean;
    FMarkerCount: integer;
    FAnimated: boolean;
    FAnimationSpeed: real;
    FAnimationTimer: TTimer;
    FTrackRect: TRect;
    FThumbRect: TRect;
    FOnTimeChange: TNotifyEvent;

    // Skin parts
    FTrackNormal, FTrackHover, FTrackPressed, FTrackDisabled: TONURCUSTOMCROP;
    FThumbNormal, FThumbHover, FThumbPressed, FThumbDisabled: TONURCUSTOMCROP;
    FMarkerNormal, FMarkerHover, FMarkerPressed, FMarkerDisabled: TONURCUSTOMCROP;

    // Setters
    procedure SetMode(Value: TONURTimeBarMode);
    procedure SetCurrentTime(Value: TDateTime);
    procedure SetTargetTime(Value: TDateTime);
    procedure SetStartTime(Value: TDateTime);
    procedure SetEndTime(Value: TDateTime);
    procedure SetShowSeconds(Value: boolean);
    procedure SetShowDate(Value: boolean);
    procedure SetShowLabels(Value: boolean);
    procedure SetShowMarkers(Value: boolean);
    procedure SetMarkerCount(Value: integer);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimation(Sender: TObject);
    procedure DoTimer(Sender: TObject);

    // Layout
    procedure UpdateLayout;
    procedure UpdateThumbRect;

    // Drawing
    procedure DrawBaseTimeBar;
    procedure DrawWithSkins;

    // Helpers
    function GetPercentage: real;
    function TimeFromPoint(X, Y: integer): TDateTime;
    function GetDisplayTime: string;

  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure Start;
    procedure Stop;
    procedure Reset;

  published
    property Mode: TONURTimeBarMode read FMode write SetMode default tbmClock;
    property CurrentTime: TDateTime read FCurrentTime write SetCurrentTime;
    property TargetTime: TDateTime read FTargetTime write SetTargetTime;
    property StartTime: TDateTime read FStartTime write SetStartTime;
    property EndTime: TDateTime read FEndTime write SetEndTime;
    property ShowSeconds: boolean read FShowSeconds write SetShowSeconds default True;
    property ShowDate: boolean read FShowDate write SetShowDate default False;
    property ShowLabels: boolean read FShowLabels write SetShowLabels default True;
    property ShowMarkers: boolean read FShowMarkers write SetShowMarkers default True;
    property MarkerCount: integer read FMarkerCount write SetMarkerCount default 10;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnTimeChange: TNotifyEvent read FOnTimeChange write FOnTimeChange;
  end;

  // Loading Bar

  TONURLoadingBar = class(TONURGraphicControl)
  private
    FStyle: TONURStyle;
    FState: TONURState;
    FMin: integer;
    FMax: integer;
    FPosition: integer;
    FMode: TONURLoadingBarMode;
    FIsLoading: boolean;
    FAnimated: boolean;
    FAnimationSpeed: real;
    FAnimationPosition: real;
    FAnimationTimer: TTimer;
    FDotCount: integer;
    FBarCount: integer;
    FShowPercentage: boolean;
    FCustomText: string;
    FTrackRect: TRect;
    FOnProgressChange: TNotifyEvent;

    // Skin parts
    FBackNormal, FBackHover, FBackPressed, FBackDisabled: TONURCUSTOMCROP;
    FProgressNormal, FProgressHover, FProgressPressed,
    FProgressDisabled: TONURCUSTOMCROP;
    FOverlayNormal, FOverlayHover, FOverlayPressed, FOverlayDisabled: TONURCUSTOMCROP;

    // Setters
    procedure SetStyle(Value: TONURStyle);
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetPosition(Value: integer);
    procedure SetMode(Value: TONURLoadingBarMode);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);
    procedure SetDotCount(Value: integer);
    procedure SetBarCount(Value: integer);
    procedure SetShowPercentage(Value: boolean);
    procedure SetCustomText(Value: string);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimation(Sender: TObject);

    // Layout
    procedure UpdateLayout;

    // Drawing
    procedure DrawBaseLoadingBar;
    procedure DrawWithSkins;

    // Helpers
    function GetPercentage: integer;
    function GetDisplayText: string;

  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure StartLoading;
    procedure StopLoading;
    procedure Reset;

  published
    property Style: TONURStyle read FStyle write SetStyle default osLinear;
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Position: integer read FPosition write SetPosition default 0;
    property Mode: TONURLoadingBarMode read FMode write SetMode default ormDeterminate;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;
    property DotCount: integer read FDotCount write SetDotCount default 3;
    property BarCount: integer read FBarCount write SetBarCount default 5;
    property ShowPercentage: boolean
      read FShowPercentage write SetShowPercentage default False;
    property CustomText: string read FCustomText write SetCustomText;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnProgressChange: TNotifyEvent read FOnProgressChange
      write FOnProgressChange;
  end;

  // Progress Ring

  TONURProgressRing = class(TONURGraphicControl)
  private
    FStyle: TONURStyle;
    FState: TONURState;
    FMin: integer;
    FMax: integer;
    FValue: integer;
    FMode: TONURLoadingBarMode;
    FStartAngle: integer;
    FEndAngle: integer;
    FThickness: integer;
    FShowPercentage: boolean;
    FShowText: boolean;
    FCustomText: string;
    FAnimated: boolean;
    FAnimationSpeed: real;
    FTargetValue: integer;
    FAnimationAngle: real;
    FIsLoading: boolean;
    FCenterX: integer;
    FCenterY: integer;
    FOuterRadius: integer;
    FInnerRadius: integer;
    FMeterRect: TRect;
    FAnimationTimer: TTimer;
    FOnChange: TNotifyEvent;

    // Skin parts
    FBackNormal, FBackHover, FBackPressed, FBackDisabled: TONURCUSTOMCROP;
    FProgressNormal, FProgressHover, FProgressPressed,
    FProgressDisabled: TONURCUSTOMCROP;
    FCenterNormal, FCenterHover, FCenterPressed, FCenterDisabled: TONURCUSTOMCROP;

    // Setters
    procedure SetStyle(Value: TONURStyle);
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetMode(Value: TONURLoadingBarMode);
    procedure SetStartAngle(Value: integer);
    procedure SetEndAngle(Value: integer);
    procedure SetThickness(Value: integer);
    procedure SetShowPercentage(Value: boolean);
    procedure SetShowText(Value: boolean);
    procedure SetCustomText(Value: string);
    procedure SetAnimated(Value: boolean);
    procedure SetAnimationSpeed(Value: real);

    // Animation
    procedure StartAnimation;
    procedure StopAnimation;
    procedure DoAnimation(Sender: TObject);

    // Layout
    procedure UpdateLayout;

    // Drawing
    procedure DrawBaseProgressRing;
    procedure DrawWithSkins;

    // Helpers
    function ValueToAngle(Value: integer): integer;
    function AngleToValue(Angle: integer): integer;
    function GetPercentage: integer;
    function GetDisplayValue: string;

  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure StartLoading;
    procedure StopLoading;
    procedure Reset;
    procedure AnimateToValue(Value: integer);
    procedure SetPercentage(Value: integer);

  published
    property Style: TONURStyle read FStyle write SetStyle default osModern;
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Mode: TONURLoadingBarMode read FMode write SetMode default ormDeterminate;
    property StartAngle: integer read FStartAngle write SetStartAngle default -90;
    property EndAngle: integer read FEndAngle write SetEndAngle default 270;
    property Thickness: integer read FThickness write SetThickness default 8;
    property ShowPercentage: boolean
      read FShowPercentage write SetShowPercentage default True;
    property ShowText: boolean read FShowText write SetShowText default True;
    property CustomText: string read FCustomText write SetCustomText;
    property Animated: boolean read FAnimated write SetAnimated default True;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;

    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  // Knob

  TONURKnob = class(TONURGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FStyle: TONURStyle;
    FState: TONURState;
    FShowScale: boolean;
    FScaleCount: integer;
    FShowPointer: boolean;
    FPointerLength: integer;
    FPointerColor: TColor;
    FStep: integer;
    FScrollStep: integer;
    FAnimated: boolean;
    FTargetValue: integer;
    FAnimationSpeed: real;
    FAnimationTimer: TTimer;
    FOnChange: TNotifyEvent;

    // Layout and dragging
    FCenterX, FCenterY: integer;
    FRadius: integer;
    FStartAngle: integer;
    FEndAngle: integer;
    FIsDragging: boolean;
    FDragStartAngle: integer;
    FDragStartValue: integer;

    // Background parts
    FBackNormal, FBackHover, FBackPressed, FBackDisabled: TONURCUSTOMCROP;

    // Pointer parts
    FPointerNormal, FPointerHover, FPointerPressed, FPointerDisabled: TONURCUSTOMCROP;

    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetStyle(Value: TONURStyle);
    procedure SetShowScale(Value: boolean);
    procedure SetScaleCount(Value: integer);
    procedure SetShowPointer(Value: boolean);
    procedure SetPointerLength(Value: integer);
    procedure SetPointerColor(Value: TColor);
    procedure SetStep(Value: integer);
    procedure SetScrollStep(Value: integer);


    procedure UpdateLayout;
    procedure UpdateAngles;
    function ValueToAngle(Value: integer): integer;
    function AngleToValue(Angle: integer): integer;
    function GetPercentage: integer;
    function SnapToStep(Value: integer): integer;
    procedure SetPercentage(Value: integer);


    procedure DrawBaseKnob;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Resize; override;
    function DoMouseWheel(ShIft: TShIftState; WheelDelta: integer;
      MousePos: TPoInt): boolean; override;

  published
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Style: TONURStyle read FStyle write SetStyle default osModern;
    property ShowScale: boolean read FShowScale write SetShowScale default True;
    property ScaleCount: integer read FScaleCount write SetScaleCount default 10;
    property ShowPointer: boolean read FShowPointer write SetShowPointer default True;
    property PointerLength: integer
      read FPointerLength write SetPointerLength default 80;
    property PointerColor: TColor read FPointerColor write SetPointerColor default clRed;
    property Step: integer read FStep write SetStep default 1;
    property ScrollStep: integer read FScrollStep write SetScrollStep default 10;


    property Alpha;
    property Skindata;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color;
    property Enabled;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegIsterComponents('ONUR', [TONURProgressBar, TONURScrollBar,
    TONURTrackBar, TONURRangeBar, TONURGaugeBar, TONURKnob, TONURSliderBar,
    TONURSwitchBar, TONURTimeBar, TONURLoadingBar, TONURProgressRing, TONURMeterBar]);
end;

procedure BGRAReplaceCustomCrops(Canvas: TCanvas; CustomCrop: TONURCUSTOMCROP);
begin
  // Simple implementation - draws CustomCrop object on canvas
  if Assigned(CustomCrop) and Assigned(Canvas) then
  begin
    // Draw CustomCrop.CropRect area on Canvas
    // This is a simple rectangle drawing - real skinning system may be more complex
    Canvas.Brush.Color := clGray;
    Canvas.FillRect(CustomCrop.CropRect);
    Canvas.Pen.Color := clBlack;
    Canvas.FrameRect(CustomCrop.CropRect);
  end;
end;



constructor TONURRangeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOrIentatIon := oroHorIzontal;
  FMin := 0;
  FMax := 100;
  FRangeStart := 25;
  FRangeEnd := 75;
  FState := obsNormal;
  FIsPressed := False;
  FDragStartPos := 0;
  FDragStartValue := 0;
  FActIveThumb := rbtLeft;

  // 3-parca background
  FBackLeftNormal := TONURCUSTOMCROP.Create('LEFT');
  FBackCenterNormal := TONURCUSTOMCROP.Create('CENTER');
  FBackRIghtNormal := TONURCUSTOMCROP.Create('RIGHT');
  FBackLeftDIsabled := TONURCUSTOMCROP.Create('DISABLEDLEFT');
  FBackCenterDIsabled := TONURCUSTOMCROP.Create('DISABLEDCENTER');
  FBackRIghtDIsabled := TONURCUSTOMCROP.Create('DISABLEDRIGHT');

  // Left thumb
  FLeftThumbNormal := TONURCUSTOMCROP.Create('LEFTTHUMBNORMAL');
  FLeftThumbHover := TONURCUSTOMCROP.Create('LEFTTHUMBHOVER');
  FLeftThumbPressed := TONURCUSTOMCROP.Create('LEFTTHUMBPRESSED');
  FLeftThumbDIsabled := TONURCUSTOMCROP.Create('LEFTTHUMBDISABLED');

  // RIght thumb
  FRIghtThumbNormal := TONURCUSTOMCROP.Create('RIGHTTHUMBNORMAL');
  FRIghtThumbHover := TONURCUSTOMCROP.Create('RIGHTTHUMBHOVER');
  FRIghtThumbPressed := TONURCUSTOMCROP.Create('RIGHTTHUMBPRESSED');
  FRIghtThumbDIsabled := TONURCUSTOMCROP.Create('RIGHTTHUMBDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackLeftNormal);
  CustomcroplIst.Add(FBackCenterNormal);
  CustomcroplIst.Add(FBackRIghtNormal);
  CustomcroplIst.Add(FBackLeftDIsabled);
  CustomcroplIst.Add(FBackCenterDIsabled);
  CustomcroplIst.Add(FBackRIghtDIsabled);
  CustomcroplIst.Add(FLeftThumbNormal);
  CustomcroplIst.Add(FLeftThumbHover);
  CustomcroplIst.Add(FLeftThumbPressed);
  CustomcroplIst.Add(FLeftThumbDIsabled);
  CustomcroplIst.Add(FRIghtThumbNormal);
  CustomcroplIst.Add(FRIghtThumbHover);
  CustomcroplIst.Add(FRIghtThumbPressed);
  CustomcroplIst.Add(FRIghtThumbDIsabled);

  // Set default sIze
  Width := 200;
  Height := 30;
  SkInname := 'rangebarh';

  UpdateLayout;
end;

destructor TONURRangeBar.Destroy;
begin
  inherited Destroy;
end;

procedure TONURRangeBar.SetOrIentatIon(Value: TONUROrientation);
var
  Temp: integer;
begin
  if FOrIentatIon = Value then ExIt;
  FOrIentatIon := Value;

  // Swap wIdth/heIght for orIentatIon change
  if FOrIentatIon = oroHorIzontal then
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    SkInname := 'rangebarh';
  end
  else
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    SkInname := 'rangebarv';
  end;

  UpdateLayout;
  InvalIdate;
end;

procedure TONURRangeBar.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FRangeStart < FMin then SetRangeStart(FMin);
  if FRangeEnd < FMin then SetRangeEnd(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURRangeBar.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FRangeStart > FMax then SetRangeStart(FMax);
  if FRangeEnd > FMax then SetRangeEnd(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURRangeBar.SetRangeStart(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if Value > FRangeEnd then Value := FRangeEnd;
  if FRangeStart = Value then ExIt;

  FRangeStart := Value;
  UpdateThumbRects;
  InvalIdate;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURRangeBar.SetRangeEnd(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if Value < FRangeStart then Value := FRangeStart;
  if FRangeEnd = Value then ExIt;

  FRangeEnd := Value;
  UpdateThumbRects;
  InvalIdate;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURRangeBar.SetRange(StartValue, EndValue: integer);
var
  Temp: integer;
begin
  if StartValue > EndValue then
  begin
    Temp := StartValue;
    StartValue := EndValue;
    EndValue := Temp;
  end;

  SetRangeStart(StartValue);
  SetRangeEnd(EndValue);
end;

procedure TONURRangeBar.UpdateLayout;
begin
  // Track rect
  if FOrIentatIon = oroHorIzontal then
  begin
    FTrackRect := Rect(10, Height div 2 - 3, Width - 10, Height div 2 + 3);
  end
  else
  begin
    FTrackRect := Rect(Width div 2 - 3, 10, Width div 2 + 3, Height - 10);
  end;

  UpdateThumbRects;
end;

procedure TONURRangeBar.UpdateThumbRects;
var
  StartPos, EndPos: integer;
  TrackSIze: integer;
  ThumbSIze: integer;
begin
  if FOrIentatIon = oroHorIzontal then
  begin
    TrackSIze := FTrackRect.RIght - FTrackRect.Left;
    ThumbSIze := 16;
    StartPos := FTrackRect.Left + Round((FRangeStart - FMin) /
      (FMax - FMin) * (TrackSIze - ThumbSIze));
    EndPos := FTrackRect.Left + Round((FRangeEnd - FMin) / (FMax - FMin) *
      (TrackSIze - ThumbSIze));

    FLeftThumbRect := Rect(StartPos, FTrackRect.Top - 5, StartPos +
      ThumbSIze, FTrackRect.Bottom + 5);
    FRIghtThumbRect := Rect(EndPos, FTrackRect.Top - 5, EndPos +
      ThumbSIze, FTrackRect.Bottom + 5);

    // Range rect (selected area)
    FRangeRect := Rect(FLeftThumbRect.RIght, FTrackRect.Top,
      FRIghtThumbRect.Left, FTrackRect.Bottom);
  end
  else
  begin
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;
    ThumbSIze := 16;
    StartPos := FTrackRect.Top + Round((FRangeStart - FMin) /
      (FMax - FMin) * (TrackSIze - ThumbSIze));
    EndPos := FTrackRect.Top + Round((FRangeEnd - FMin) / (FMax - FMin) *
      (TrackSIze - ThumbSIze));

    FLeftThumbRect := Rect(FTrackRect.Left - 5, StartPos, FTrackRect.RIght +
      5, StartPos + ThumbSIze);
    FRIghtThumbRect := Rect(FTrackRect.Left - 5, EndPos, FTrackRect.RIght +
      5, EndPos + ThumbSIze);

    // Range rect (selected area)
    FRangeRect := Rect(FTrackRect.Left, FLeftThumbRect.Bottom,
      FTrackRect.RIght, FRIghtThumbRect.Top);
  end;
end;

function TONURRangeBar.GetPercentageStart: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FRangeStart - FMin) / (FMax - FMin) * 100);
end;

function TONURRangeBar.GetPercentageEnd: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FRangeEnd - FMin) / (FMax - FMin) * 100);
end;

function TONURRangeBar.GetRangeLength: integer;
begin
  Result := FRangeEnd - FRangeStart;
end;

procedure TONURRangeBar.SetPercentageRange(StartPerc, EndPerc: integer);
var
  StartPos: int64;
  EndPos: int64;
begin
  StartPerc := EnsureRange(StartPerc, 0, 100);
  EndPerc := EnsureRange(EndPerc, 0, 100);

  StartPos := FMin + Round((FMax - FMin) * StartPerc / 100);
  EndPos := FMin + Round((FMax - FMin) * EndPerc / 100);

  SetRange(StartPos, EndPos);
end;

procedure TONURRangeBar.SelectAll;
begin
  SetRange(FMin, FMax);
end;

procedure TONURRangeBar.SelectNone;
begin
  SetRange(FMin, FMin);
end;

function TONURRangeBar.PosItIonFromPoInt(X, Y: integer): integer;
var
  TrackSIze, Pos: integer;
begin
  if FOrIentatIon = oroHorIzontal then
    Pos := X - FTrackRect.Left
  else
    Pos := Y - FTrackRect.Top;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

  if TrackSIze > 0 then
    Result := FMin + Round(Pos / TrackSIze * (FMax - FMin))
  else
    Result := FMin;

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURRangeBar.PoIntInLeftThumb(X, Y: integer): boolean;
begin
  Result := PtInRect(FLeftThumbRect, PoInt(X, Y));
end;

function TONURRangeBar.PoIntInRIghtThumb(X, Y: integer): boolean;
begin
  Result := PtInRect(FRIghtThumbRect, PoInt(X, Y));
end;

function TONURRangeBar.PoIntInTrack(X, Y: integer): boolean;
begin
  Result := PtInRect(FTrackRect, PoInt(X, Y));
end;

function TONURRangeBar.PoIntInRange(X, Y: integer): boolean;
begin
  Result := PtInRect(FRangeRect, PoInt(X, Y));
end;

procedure TONURRangeBar.BeginDrag(Thumb: TONURRangeBarThumb; X, Y: integer);
begin
  FIsPressed := True;
  FActIveThumb := Thumb;
  FDragStartPos := X;

  if Thumb = rbtLeft then
    FDragStartValue := FRangeStart
  else
    FDragStartValue := FRangeEnd;

  FState := obsPressed;
  InvalIdate;
end;

procedure TONURRangeBar.EndDrag;
begin
  FIsPressed := False;
  FState := obsNormal;
  InvalIdate;
end;

procedure TONURRangeBar.UpdateDrag(X, Y: integer);
var
  Delta: integer;
  NewPos: integer;
  TrackSIze: integer;
begin
  if not FIsPressed then ExIt;

  if FOrIentatIon = oroHorIzontal then
    Delta := X - FDragStartPos
  else
    Delta := Y - FDragStartPos;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

  if TrackSIze > 0 then
  begin
    NewPos := FDragStartValue + Round(Delta * (FMax - FMin) / TrackSIze);

    if FActIveThumb = rbtLeft then
      SetRangeStart(NewPos)
    else
      SetRangeEnd(NewPos);
  end;
end;

procedure TONURRangeBar.Paint;
var
  BackLeftSrc, BackCenterSrc, BackRIghtSrc: TRect;
  BackLeftRect, BackCenterRect, BackRIghtRect: TRect;
  LeftThumbSrc, RIghtThumbSrc: TRect;
  LeftWIdth, RIghtWIdth: integer;
  TopHeIght, BottomHeIght: integer;
begin
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Background - 3-parca sistem
    if not Enabled then
    begin
      BackLeftSrc := FBackLeftDIsabled.Croprect;
      BackCenterSrc := FBackCenterDIsabled.Croprect;
      BackRIghtSrc := FBackRIghtDIsabled.Croprect;
    end
    else
    begin
      BackLeftSrc := FBackLeftNormal.Croprect;
      BackCenterSrc := FBackCenterNormal.Croprect;
      BackRIghtSrc := FBackRIghtNormal.Croprect;
    end;

    // 3-parca background cizimi
    if FOrientation = oroHorizontal then
    begin
      LeftWIdth := BackLeftSrc.RIght - BackLeftSrc.Left;
      RIghtWIdth := BackRIghtSrc.RIght - BackRIghtSrc.Left;

      BackLeftRect := Rect(0, 0, LeftWIdth, Height);
      BackCenterRect := Rect(LeftWIdth, 0, Width - RIghtWIdth, Height);
      BackRIghtRect := Rect(Width - RIghtWIdth, 0, Width, Height);

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);
      if BackCenterRect.RIght > BackCenterRect.Left then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);
      DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);
    end
    else
    begin
      TopHeIght := BackLeftSrc.Bottom - BackLeftSrc.Top;
      BottomHeIght := BackRIghtSrc.Bottom - BackRIghtSrc.Top;

      BackLeftRect := Rect(0, 0, Width, TopHeIght);  // Top
      BackCenterRect := Rect(0, TopHeIght, Width, Height - BottomHeIght);  // Center
      BackRIghtRect := Rect(0, Height - BottomHeIght, Width, Height);  // Bottom

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);  // Top
      if BackCenterRect.Bottom > BackCenterRect.Top then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);  // Center
      DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);  // Bottom
    end;

    // Track (arka plan)
    resim.FillRect(FTrackRect, BGRA(150, 150, 150, Alpha), dmSet);

    // Range (selected area)
    if (FRangeRect.RIght > FRangeRect.Left) and (FRangeRect.Bottom > FRangeRect.Top) then
      resim.FillRect(FRangeRect, BGRA(0, 120, 215, Alpha), dmSet);

    // Left thumb
    if not Enabled then
      LeftThumbSrc := FLeftThumbDIsabled.Croprect
    else
    begin
      case FState of
        obsNormal: LeftThumbSrc := FLeftThumbNormal.Croprect;
        obsHover:
          if (FActIveThumb = rbtLeft) then
            LeftThumbSrc := FLeftThumbPressed.Croprect
          else
            LeftThumbSrc := FLeftThumbHover.Croprect;
        obsPressed:
          if (FActIveThumb = rbtLeft) then
            LeftThumbSrc := FLeftThumbPressed.Croprect
          else
            LeftThumbSrc := FLeftThumbNormal.Croprect;
        else
          LeftThumbSrc := FLeftThumbNormal.Croprect;
      end;
    end;

    if (FLeftThumbRect.RIght > FLeftThumbRect.Left) and
      (FLeftThumbRect.Bottom > FLeftThumbRect.Top) then
      DrawPartnormal(LeftThumbSrc, Self, FLeftThumbRect, Alpha);

    // RIght thumb
    if not Enabled then
      RIghtThumbSrc := FRIghtThumbDIsabled.Croprect
    else
    begin
      case FState of
        obsNormal: RIghtThumbSrc := FRIghtThumbNormal.Croprect;
        obsHover:
          if (FActIveThumb = rbtRIght) then
            RIghtThumbSrc := FRIghtThumbPressed.Croprect
          else
            RIghtThumbSrc := FRIghtThumbHover.Croprect;
        obsPressed:
          if (FActIveThumb = rbtRIght) then
            RIghtThumbSrc := FRIghtThumbPressed.Croprect
          else
            RIghtThumbSrc := FRIghtThumbNormal.Croprect;
        else
          RIghtThumbSrc := FRIghtThumbNormal.Croprect;
      end;
    end;

    if (FRIghtThumbRect.RIght > FRIghtThumbRect.Left) and
      (FRIghtThumbRect.Bottom > FRIghtThumbRect.Top) then
      DrawPartnormal(RIghtThumbSrc, Self, FRIghtThumbRect, Alpha);
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseRangeBar;
  end;

  inherited Paint;
end;

procedure TONURRangeBar.DrawBaseRangeBar;
var
  BorderColor, BackColor, TrackColor, RangeColor, ThumbColor: TBGRAPixel;
  GlossRect: Windows.RECT;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    BorderColor := BGRA(180, 180, 180, Alpha);
    BackColor := BGRA(220, 220, 220, Alpha);
    TrackColor := BGRA(150, 150, 150, Alpha);
    RangeColor := BGRA(120, 120, 120, Alpha);
    ThumbColor := BGRA(140, 140, 140, Alpha);
  end
  else
  begin
    BorderColor := BGRA(200, 200, 200, Alpha);
    BackColor := BGRA(240, 240, 240, Alpha);
    TrackColor := BGRA(160, 160, 160, Alpha);
    RangeColor := BGRA(0, 120, 215, Alpha);  // Windows mavi
    ThumbColor := BGRA(0, 100, 180, Alpha);   // Koyu mavi
  end;

  // Border ve background
  resim.FillRect(0, 0, ClientWidth, ClientHeight, BorderColor, dmSet);
  resim.FillRect(1, 1, ClientWidth - 1, ClientHeight - 1, BackColor, dmSet);

  // Track (arka plan)
  resim.FillRect(FTrackRect, TrackColor, dmSet);

  // Range (selected area)
  if (FRangeRect.RIght > FRangeRect.Left) and (FRangeRect.Bottom > FRangeRect.Top) then
  begin
    resim.FillRect(FRangeRect, RangeColor, dmSet);

    // Range gradient efekti
    if Enabled then
    begin
      resim.FillRect(FRangeRect.Left, FRangeRect.Top, FRangeRect.Right,
        FRangeRect.Top + FRangeRect.Height div 2,
        BGRA(RangeColor.red + 20, RangeColor.green + 20, RangeColor.blue + 20,
        Alpha), dmSet);
    end;
  end;

  // Left thumb
  if (FLeftThumbRect.RIght > FLeftThumbRect.Left) and
    (FLeftThumbRect.Bottom > FLeftThumbRect.Top) then
  begin
    resim.FillRect(FLeftThumbRect, ThumbColor, dmSet);

    // Thumb gradient efekti
    if Enabled then
    begin
      resim.FillRect(FLeftThumbRect.Left, FLeftThumbRect.Top,
        FLeftThumbRect.Right, FLeftThumbRect.Top + FLeftThumbRect.Height div 2,
        BGRA(ThumbColor.red + 30, ThumbColor.green + 30, ThumbColor.blue + 30,
        Alpha), dmSet);

      // Thumb glossy overlay
      GlossRect := Rect(FLeftThumbRect.Left + 2, FLeftThumbRect.Top +
        2, FLeftThumbRect.Right - 2, FLeftThumbRect.Top + FLeftThumbRect.Height div 3);
      resim.FillRect(GlossRect, BGRA(255, 255, 255, Alpha div 4), dmSet);
    end;
  end;

  // RIght thumb
  if (FRIghtThumbRect.RIght > FRIghtThumbRect.Left) and
    (FRIghtThumbRect.Bottom > FRIghtThumbRect.Top) then
  begin
    resim.FillRect(FRIghtThumbRect, ThumbColor, dmSet);

    // Thumb gradient efekti
    if Enabled then
    begin
      resim.FillRect(FRIghtThumbRect.Left, FRIghtThumbRect.Top,
        FRIghtThumbRect.Right, FRIghtThumbRect.Top + FRIghtThumbRect.Height div 2,
        BGRA(ThumbColor.red + 30, ThumbColor.green + 30, ThumbColor.blue + 30,
        Alpha), dmSet);

      // Thumb glossy overlay
      GlossRect := Rect(FRIghtThumbRect.Left + 2, FRIghtThumbRect.Top +
        2, FRIghtThumbRect.Right - 2, FRIghtThumbRect.Top + FRIghtThumbRect.Height div 3);
      resim.FillRect(GlossRect, BGRA(255, 255, 255, Alpha div 4), dmSet);
    end;
  end;
end;

procedure TONURRangeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  LeftDist: longint;
  RIghtDist: longint;
  ClickPos: integer;
  RangeMid: integer;
begin
  if not Enabled then Exit;

  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if PointInLeftThumb(X, Y) then
    begin
      BeginDrag(rbtLeft, X, Y);
    end
    else if PointInRIghtThumb(X, Y) then
    begin
      BeginDrag(rbtRIght, X, Y);
    end
    else if PointInRange(X, Y) then
    begin
      // Range area - move nearest thumb
      LeftDist := Abs(X - (FLeftThumbRect.Left + FLeftThumbRect.RIght) div 2);
      RIghtDist := Abs(X - (FRIghtThumbRect.Left + FRIghtThumbRect.RIght) div 2);

      if LeftDist < RIghtDist then
        BeginDrag(rbtLeft, X, Y)
      else
        BeginDrag(rbtRIght, X, Y);
    end
    else if PointInTrack(X, Y) then
    begin
      // Track area - set new range
      ClickPos := PositionFromPoint(X, Y);
      RangeMid := (FRangeStart + FRangeEnd) div 2;

      if ClickPos < RangeMid then
      begin
        SetRangeStart(ClickPos);
        BeginDrag(rbtLeft, X, Y);
      end
      else
      begin
        SetRangeEnd(ClickPos);
        BeginDrag(rbtRIght, X, Y);
      end;
    end;

    Invalidate;
  end;
end;

procedure TONURRangeBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not Enabled then Exit;

  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    EndDrag;
    Invalidate;
  end;
end;

procedure TONURRangeBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewState: TONURState;
begin
  if not Enabled then Exit;

  inherited MouseMove(Shift, X, Y);

  if FIsPressed then
  begin
    UpdateDrag(X, Y);
  end
  else
  begin
    if PointInLeftThumb(X, Y) or PointInRIghtThumb(X, Y) then
      NewState := obsHover
    else
      NewState := obsNormal;

    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURRangeBar.MouseEnter;
var
  MousePos: TPoint;
begin
  inherited MouseEnter;

  if not FIsPressed then
  begin
    MousePos := ScreenToClient(Mouse.CursorPos);
    if PointInLeftThumb(MousePos.X, MousePos.Y) or
      PointInRIghtThumb(MousePos.X, MousePos.Y) then
    begin
      FState := obsHover;
      Invalidate;
    end;
  end;
end;

procedure TONURRangeBar.MouseLeave;
begin
  inherited MouseLeave;

  if not FIsPressed then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURRangeBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

{ TONURTrackBar }

constructor TONURTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOrIentatIon := oroHorIzontal;
  FPosItIon := 0;
  FMin := 0;
  FMax := 100;
  FState := obsNormal;
  FIsPressed := False;
  FDragStartPos := 0;
  FDragStartValue := 0;

  // Additional properties
  FShowValue := True;
  FShowTicks := True;
  FTickCount := 10;
  FThumbSize := 16;
  FTrackHeight := 4;
  FTargtValue := 0;
  FIsDragging := False;

  // 3-parca background
  FBackLeftNormal := TONURCUSTOMCROP.Create('LEFT');
  FBackCenterNormal := TONURCUSTOMCROP.Create('CENTER');
  FBackRIghtNormal := TONURCUSTOMCROP.Create('RIGHT');
  FBackLeftDIsabled := TONURCUSTOMCROP.Create('DISABLEDLEFT');
  FBackCenterDIsabled := TONURCUSTOMCROP.Create('DISABLEDCENTER');
  FBackRIghtDIsabled := TONURCUSTOMCROP.Create('DISABLEDRIGHT');

  // Track parts
  FTrackNormal := TONURCUSTOMCROP.Create('TRACKNORMAL');
  FTrackHover := TONURCUSTOMCROP.Create('TRACKHOVER');
  FTrackPressed := TONURCUSTOMCROP.Create('TRACKPRESSED');
  FTrackDisabled := TONURCUSTOMCROP.Create('TRACKDISABLED');

  // Thumb
  FThumbNormal := TONURCUSTOMCROP.Create('THUMBNORMAL');
  FThumbHover := TONURCUSTOMCROP.Create('THUMBHOVER');
  FThumbPressed := TONURCUSTOMCROP.Create('THUMBPRESSED');
  FThumbDIsabled := TONURCUSTOMCROP.Create('THUMBDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackLeftNormal);
  CustomcroplIst.Add(FBackCenterNormal);
  CustomcroplIst.Add(FBackRIghtNormal);
  CustomcroplIst.Add(FBackLeftDIsabled);
  CustomcroplIst.Add(FBackCenterDIsabled);
  CustomcroplIst.Add(FBackRIghtDIsabled);
  CustomcroplIst.Add(FTrackNormal);
  CustomcroplIst.Add(FTrackHover);
  CustomcroplIst.Add(FTrackPressed);
  CustomcroplIst.Add(FTrackDisabled);
  CustomcroplIst.Add(FThumbNormal);
  CustomcroplIst.Add(FThumbHover);
  CustomcroplIst.Add(FThumbPressed);
  CustomcroplIst.Add(FThumbDIsabled);

  // Set default sIze
  Width := 200;
  Height := 30;
  SkInname := 'trackbarh';

  UpdateLayout;
end;

destructor TONURTrackBar.Destroy;
begin
  inherited Destroy;
end;

procedure TONURTrackBar.SetOrIentatIon(Value: TONUROrientation);
var
  Temp: integer;
begin
  if FOrIentatIon = Value then ExIt;
  FOrIentatIon := Value;

  // Swap wIdth/heIght for orIentatIon change
  if FOrIentatIon = oroHorIzontal then
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    SkInname := 'trackbarh';
  end
  else
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    SkInname := 'trackbarv';
  end;

  UpdateLayout;
  InvalIdate;
end;

procedure TONURTrackBar.SetPosItIon(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FPosItIon = Value then ExIt;

  FPosItIon := Value;
  UpdateThumbRect;
  InvalIdate;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURTrackBar.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FPosItIon < FMin then SetPosItIon(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURTrackBar.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FPosItIon > FMax then SetPosItIon(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURTrackBar.SetShowValue(Value: boolean);
begin
  if FShowValue = Value then ExIt;
  FShowValue := Value;
  InvalIdate;
end;

procedure TONURTrackBar.SetShowTicks(Value: boolean);
begin
  if FShowTicks = Value then ExIt;
  FShowTicks := Value;
  InvalIdate;
end;

procedure TONURTrackBar.SetTickCount(Value: integer);
begin
  if FTickCount = Value then ExIt;
  FTickCount := Value;
  InvalIdate;
end;

procedure TONURTrackBar.SetThumbSize(Value: integer);
begin
  if FThumbSize = Value then ExIt;
  FThumbSize := Value;
  UpdateLayout;
  InvalIdate;
end;

procedure TONURTrackBar.SetTrackHeight(Value: integer);
begin
  if FTrackHeight = Value then ExIt;
  FTrackHeight := Value;
  UpdateLayout;
  InvalIdate;
end;

procedure TONURTrackBar.UpdateLayout;
begin
  // Track rect
  if FOrIentatIon = oroHorIzontal then
  begin
    FTrackRect := Rect(10, Height div 2 - 3, Width - 10, Height div 2 + 3);
  end
  else
  begin
    FTrackRect := Rect(Width div 2 - 3, 10, Width div 2 + 3, Height - 10);
  end;

  UpdateThumbRect;
end;

procedure TONURTrackBar.UpdateThumbRect;
var
  ThumbPos: integer;
  TrackSIze: integer;
  ThumbSIzee: integer;
begin
  if FOrIentatIon = oroHorIzontal then
  begin
    TrackSIze := FTrackRect.RIght - FTrackRect.Left;
    ThumbSIzee := 16;
    ThumbPos := FTrackRect.Left + Round((FPosItIon - FMin) / (FMax - FMin) *
      (TrackSIze - ThumbSIzee));
    FThumbRect := Rect(ThumbPos, FTrackRect.Top - 5, ThumbPos + ThumbSIzee,
      FTrackRect.Bottom + 5);
  end
  else
  begin
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;
    ThumbSIzee := 16;
    ThumbPos := FTrackRect.Top + Round((FPosItIon - FMin) / (FMax - FMin) *
      (TrackSIze - ThumbSIzee));
    FThumbRect := Rect(FTrackRect.Left - 5, ThumbPos, FTrackRect.RIght + 5,
      ThumbPos + ThumbSIzee);
  end;
end;

function TONURTrackBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FPosItIon - FMin) / (FMax - FMin) * 100);
end;

procedure TONURTrackBar.SetPercentage(Value: integer);
var
  NewPos: int64;
begin
  Value := EnsureRange(Value, 0, 100);
  NewPos := FMin + Round((FMax - FMin) * Value / 100);
  SetPosItIon(NewPos);
end;

function TONURTrackBar.PosItIonFromPoInt(X, Y: integer): integer;
var
  TrackSIze, Pos: integer;
begin
  if FOrIentatIon = oroHorIzontal then
    Pos := X - FTrackRect.Left
  else
    Pos := Y - FTrackRect.Top;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

  if TrackSIze > 0 then
    Result := FMin + Round(Pos / TrackSIze * (FMax - FMin))
  else
    Result := FMin;

  Result := EnsureRange(Result, FMin, FMax);
end;




function TONURTrackBar.PoIntInThumb(X, Y: integer): boolean;
begin
  Result := PtInRect(FThumbRect, PoInt(X, Y));
end;

function TONURTrackBar.PoIntInTrack(X, Y: integer): boolean;
begin
  Result := PtInRect(FTrackRect, PoInt(X, Y));
end;

procedure TONURTrackBar.BeginDrag(X, Y: integer);
begin
  FIsPressed := True;
  FDragStartPos := X;
  FDragStartValue := FPosItIon;
  FState := obsPressed;
  InvalIdate;
end;

procedure TONURTrackBar.EndDrag;
begin
  FIsPressed := False;
  FState := obsNormal;
  InvalIdate;
end;

procedure TONURTrackBar.UpdateDrag(X, Y: integer);
var
  Delta: integer;
  NewPos: integer;
  TrackSIze: integer;
begin
  if not FIsPressed then ExIt;

  if FOrIentatIon = oroHorIzontal then
    Delta := X - FDragStartPos
  else
    Delta := Y - FDragStartPos;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

  if TrackSIze > 0 then
  begin
    NewPos := FDragStartValue + Round(Delta * (FMax - FMin) / TrackSIze);
    SetPosItIon(NewPos);
  end;
end;

procedure TONURTrackBar.Paint;
var
  BackLeftSrc, BackCenterSrc, BackRIghtSrc: TRect;
  BackLeftRect, BackCenterRect, BackRIghtRect: TRect;
  ThumbSrc: TRect;
  LeftWIdth, RIghtWIdth: integer;
  TopHeIght, BottomHeIght: integer;
begin
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Background - 3-parca sistem
    if not Enabled then
    begin
      BackLeftSrc := FBackLeftDIsabled.Croprect;
      BackCenterSrc := FBackCenterDIsabled.Croprect;
      BackRIghtSrc := FBackRIghtDIsabled.Croprect;
    end
    else
    begin
      BackLeftSrc := FBackLeftNormal.Croprect;
      BackCenterSrc := FBackCenterNormal.Croprect;
      BackRIghtSrc := FBackRIghtNormal.Croprect;
    end;

    // 3-parca background cizimi
    if FOrientation = oroHorizontal then
    begin
      LeftWIdth := BackLeftSrc.RIght - BackLeftSrc.Left;
      RIghtWIdth := BackRIghtSrc.RIght - BackRIghtSrc.Left;

      BackLeftRect := Rect(0, 0, LeftWIdth, Height);
      BackCenterRect := Rect(LeftWIdth, 0, Width - RIghtWIdth, Height);
      BackRIghtRect := Rect(Width - RIghtWIdth, 0, Width, Height);

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);
      if BackCenterRect.RIght > BackCenterRect.Left then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);
      DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);
    end
    else
    begin
      TopHeIght := BackLeftSrc.Bottom - BackLeftSrc.Top;
      BottomHeIght := BackRIghtSrc.Bottom - BackRIghtSrc.Top;

      BackLeftRect := Rect(0, 0, Width, TopHeIght);  // Top
      BackCenterRect := Rect(0, TopHeIght, Width, Height - BottomHeIght);  // Center
      BackRIghtRect := Rect(0, Height - BottomHeIght, Width, Height);  // Bottom

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);  // Top
      if BackCenterRect.Bottom > BackCenterRect.Top then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);  // Center
      DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);  // Bottom
    end;

    // Track
    resim.FillRect(FTrackRect, BGRA(150, 150, 150, Alpha), dmSet);

    // Thumb
    if not Enabled then
      ThumbSrc := FThumbDIsabled.Croprect
    else
    begin
      case FState of
        obsNormal: ThumbSrc := FThumbNormal.Croprect;
        obsHover: ThumbSrc := FThumbHover.Croprect;
        obsPressed: ThumbSrc := FThumbPressed.Croprect;
        else
          ThumbSrc := FThumbNormal.Croprect;
      end;
    end;

    if (FThumbRect.RIght > FThumbRect.Left) and (FThumbRect.Bottom > FThumbRect.Top) then
      DrawPartnormal(ThumbSrc, Self, FThumbRect, Alpha);
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseTrackBar;
  end;

  inherited Paint;
end;

procedure TONURTrackBar.DrawBaseTrackBar;
var
  BorderColor, BackColor, TrackColor, ThumbColor: TBGRAPixel;
  GlossRect: Windows.RECT;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    BorderColor := BGRA(180, 180, 180, Alpha);
    BackColor := BGRA(220, 220, 220, Alpha);
    TrackColor := BGRA(150, 150, 150, Alpha);
    ThumbColor := BGRA(140, 140, 140, Alpha);
  end
  else
  begin
    BorderColor := BGRA(200, 200, 200, Alpha);
    BackColor := BGRA(240, 240, 240, Alpha);
    TrackColor := BGRA(160, 160, 160, Alpha);
    ThumbColor := BGRA(0, 120, 215, Alpha);  // Windows mavi
  end;

  // Border ve background
  resim.FillRect(0, 0, ClientWidth, ClientHeight, BorderColor, dmSet);
  resim.FillRect(1, 1, ClientWidth - 1, ClientHeight - 1, BackColor, dmSet);

  // Track
  resim.FillRect(FTrackRect, TrackColor, dmSet);

  // Thumb
  if (FThumbRect.RIght > FThumbRect.Left) and (FThumbRect.Bottom > FThumbRect.Top) then
  begin
    resim.FillRect(FThumbRect, ThumbColor, dmSet);

    // Thumb gradient efekti
    if Enabled then
    begin
      resim.FillRect(FThumbRect.Left, FThumbRect.Top, FThumbRect.Right,
        FThumbRect.Top + FThumbRect.Height div 2,
        BGRA(ThumbColor.red + 30, ThumbColor.green + 30, ThumbColor.blue + 30,
        Alpha), dmSet);

      // Thumb glossy overlay
      GlossRect := Rect(FThumbRect.Left + 2, FThumbRect.Top + 2,
        FThumbRect.Right - 2, FThumbRect.Top + FThumbRect.Height div 3);
      resim.FillRect(GlossRect, BGRA(255, 255, 255, Alpha div 4), dmSet);
    end;
  end;
end;

procedure TONURTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  if not Enabled then Exit;

  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if PointInThumb(X, Y) then
    begin
      BeginDrag(X, Y);
    end
    else if PointInTrack(X, Y) then
    begin
      SetPosition(PositionFromPoint(X, Y));
      BeginDrag(X, Y);
    end;

    Invalidate;
  end;
end;

procedure TONURTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not Enabled then Exit;

  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    EndDrag;

    if PointInThumb(X, Y) then
      FState := obsHover
    else
      FState := obsNormal;

    Invalidate;
  end;
end;

procedure TONURTrackBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewState: TONURState;
begin
  if not Enabled then Exit;

  inherited MouseMove(Shift, X, Y);

  if FIsPressed then
  begin
    UpdateDrag(X, Y);
  end
  else
  begin
    if PointInThumb(X, Y) then
      NewState := obsHover
    else
      NewState := obsNormal;

    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURTrackBar.MouseEnter;
begin
  inherited MouseEnter;

  if not FIsPressed and PointInThumb(ScreenToClient(Mouse.CursorPos).X,
    ScreenToClient(Mouse.CursorPos).Y) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURTrackBar.MouseLeave;
begin
  inherited MouseLeave;

  if not FIsPressed then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURTrackBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

{ TONURProgressBar }

constructor TONURProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOrIentatIon := oroHorIzontal;
  FPosItIon := 0;
  FMin := 0;
  FMax := 100;
  FTextStyle := ptsPercentage;
  FCustomText := '';
  FAnImated := True;
  FAnImatIonSpeed := 0.1;
  FTargetPosItIon := 0;

  // AnImatIon tImer
  FAnImatIonTImer := TTImer.Create(Self);
  FAnImatIonTImer.Enabled := False;
  FAnImatIonTImer.Interval := 16; // 60fps
  FAnImatIonTImer.OnTImer := @DoAnImatIonTImer;
  Skinname := 'progressbarh';
  // 3-parca background
  FBackLeftNormal := TONURCUSTOMCROP.Create('LEFT');
  FBackCenterNormal := TONURCUSTOMCROP.Create('CENTER');
  FBackRIghtNormal := TONURCUSTOMCROP.Create('RIGHT');
  FBackLeftDIsabled := TONURCUSTOMCROP.Create('BACKLEFTDISABLED');
  FBackCenterDIsabled := TONURCUSTOMCROP.Create('BACKCENTERDISABLED');
  FBackRIghtDIsabled := TONURCUSTOMCROP.Create('BACKRIGHTDISABLED');

  // Bar
  FBarNormal := TONURCUSTOMCROP.Create('BAR');
  FBarHover := TONURCUSTOMCROP.Create('BARHOVER');
  FBarDIsabled := TONURCUSTOMCROP.Create('BARDISABLED');

  // Overlay
  FOverlayNormal := TONURCUSTOMCROP.Create('OVERLAYNORMAL');
  FOverlayDIsabled := TONURCUSTOMCROP.Create('OVERLAYDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackLeftNormal);
  CustomcroplIst.Add(FBackCenterNormal);
  CustomcroplIst.Add(FBackRIghtNormal);
  CustomcroplIst.Add(FBackLeftDIsabled);
  CustomcroplIst.Add(FBackCenterDIsabled);
  CustomcroplIst.Add(FBackRIghtDIsabled);
  CustomcroplIst.Add(FBarNormal);
  CustomcroplIst.Add(FBarHover);
  CustomcroplIst.Add(FBarDIsabled);
  CustomcroplIst.Add(FOverlayNormal);
  CustomcroplIst.Add(FOverlayDIsabled);

  // Set default sIze
  Width := 200;
  Height := 20;
end;

destructor TONURProgressBar.Destroy;
begin
  FreeAndNil(FAnImatIonTImer);
  inherited Destroy;
end;

procedure TONURProgressBar.SetOrIentatIon(Value: TONUROrientation);
var
  Temp: integer;
begin
  if FOrIentatIon = Value then ExIt;
  FOrIentatIon := Value;

  // Swap wIdth/heIght for orIentatIon change
  if FOrIentatIon = oroHorizontal then
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    skinname := 'progressbarh';
  end
  else
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    skinname := 'progressbarv';
  end;

  UpdateLayout;
  InvalIdate;
end;

procedure TONURProgressBar.SetPosItIon(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);

  if FAnImated then
  begin
    FTargetPosItIon := Value;
    StartAnImatIon;
  end
  else
  begin
    FPosItIon := Value;
    FTargetPosItIon := Value;
    InvalIdate;
  end;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURProgressBar.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FPosItIon < FMin then SetPosItIon(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURProgressBar.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FPosItIon > FMax then SetPosItIon(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURProgressBar.SetTextStyle(Value: TONURProgressBarTextStyle);
begin
  if FTextStyle = Value then ExIt;
  FTextStyle := Value;
  InvalIdate;
end;

procedure TONURProgressBar.SetCustomText(Value: string);
begin
  if FCustomText = Value then ExIt;
  FCustomText := Value;
  InvalIdate;
end;

procedure TONURProgressBar.SetAnImated(Value: boolean);
begin
  if FAnImated = Value then ExIt;
  FAnImated := Value;

  if not FAnImated then
  begin
    FPosItIon := FTargetPosItIon;
    StopAnImatIon;
  end;
end;

procedure TONURProgressBar.SetAnImatIonSpeed(Value: real);
begin
  if FAnImatIonSpeed = Value then ExIt;
  FAnImatIonSpeed := Value;
end;

procedure TONURProgressBar.UpdateLayout;
begin
  // Layout updated In PaInt method based on current sIze
end;

procedure TONURProgressBar.StartAnImatIon;
begin
  if FAnImated and (FPosItIon <> FTargetPosItIon) then
    FAnImatIonTImer.Enabled := True;
end;

procedure TONURProgressBar.StopAnImatIon;
begin
  FAnImatIonTImer.Enabled := False;
end;

procedure TONURProgressBar.DoAnImatIonTImer(Sender: TObject);
var
  DIff: integer;
  Step: int64;
begin
  if FPosItIon = FTargetPosItIon then
  begin
    StopAnImatIon;
    ExIt;
  end;

  // Smooth anImatIon
  DIff := FTargetPosItIon - FPosItIon;
  Step := Round(DIff * FAnImatIonSpeed);

  if Abs(Step) < 1 then
    Step := SIgn(DIff);

  FPosItIon := FPosItIon + Step;

  // Clamp to target
  if SIgn(DIff) <> SIgn(FTargetPosItIon - FPosItIon) then
    FPosItIon := FTargetPosItIon;

  InvalIdate;
end;

function TONURProgressBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FPosItIon - FMin) / (FMax - FMin) * 100);
end;

function TONURProgressBar.GetBarRect: TRect;
var
  BarSIze: integer;
begin
  if FOrIentatIon = oroHorizontal then
  begin
    BarSIze := Round((Width - 4) * GetPercentage / 100);
    Result := Rect(2, 2, 2 + BarSIze, Height - 2);
  end
  else
  begin
    BarSIze := Round((Height - 4) * GetPercentage / 100);
    Result := Rect(2, Height - 2 - BarSIze, Width - 2, Height - 2);
  end;
end;

function TONURProgressBar.GetTextRect: TRect;
begin
  Result := ClIentRect;
  InflateRect(Result, -4, -4);
end;

function TONURProgressBar.GetDIsplayText: string;
begin
  case FTextStyle of
    ptsNone: Result := '';
    ptsPercentage: Result := IntToStr(GetPercentage) + '%';
    ptsValue: Result := IntToStr(FPosItIon) + '/' + IntToStr(FMax);
    ptsCustom: Result := FCustomText;
  end;
end;

procedure TONURProgressBar.SetPercentage(Value: integer);
var
  NewPos: int64;
begin
  Value := EnsureRange(Value, 0, 100);
  NewPos := FMin + Round((FMax - FMin) * Value / 100);
  SetPosItIon(NewPos);
end;

procedure TONURProgressBar.IncrementBy(Value: integer = 1);
begin
  SetPosItIon(FPosItIon + Value);
end;

procedure TONURProgressBar.Paint;
var
  BackLeftSrc, BackCenterSrc, BackRightSrc: TRect;
  BackLeftRect, BackCenterRect, BackRightRect: TRect;
  BarSrc, OverlaySrc: TRect;
  BarRect, TextRect: TRect;
  LeftWidth, RightWidth: integer;
  DisplayText: string;
  TopHeight: longint;
  BottomHeight: longint;
begin
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Background - 3-parca sistem
    if not Enabled then
    begin
      BackLeftSrc := FBackLeftDisabled.Croprect;
      BackCenterSrc := FBackCenterDisabled.Croprect;
      BackRightSrc := FBackRightDisabled.Croprect;
      BarSrc := FBarDisabled.Croprect;
      OverlaySrc := FOverlayDisabled.Croprect;
    end
    else
    begin
      BackLeftSrc := FBackLeftNormal.Croprect;
      BackCenterSrc := FBackCenterNormal.Croprect;
      BackRightSrc := FBackRightNormal.Croprect;
      BarSrc := FBarNormal.Croprect;
      OverlaySrc := FOverlayNormal.Croprect;
    end;

    // 3-parca background cizimi
    if FOrientation = oroHorizontal then
    begin
      LeftWidth := BackLeftSrc.Right - BackLeftSrc.Left;
      RightWidth := BackRightSrc.Right - BackRightSrc.Left;

      BackLeftRect := Rect(0, 0, LeftWidth, Height);
      BackCenterRect := Rect(LeftWidth, 0, Width - RightWidth, Height);
      BackRightRect := Rect(Width - RightWidth, 0, Width, Height);

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);
      if BackCenterRect.Right > BackCenterRect.Left then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);
      DrawPartnormal(BackRightSrc, Self, BackRightRect, Alpha);
    end
    else
    begin
      TopHeight := BackLeftSrc.Bottom - BackLeftSrc.Top;
      BottomHeight := BackRightSrc.Bottom - BackRightSrc.Top;

      BackLeftRect := Rect(0, 0, Width, TopHeight);  // Top
      BackCenterRect := Rect(0, TopHeight, Width, Height - BottomHeight);  // Center
      BackRightRect := Rect(0, Height - BottomHeight, Width, Height);  // Bottom

      DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);  // Top
      if BackCenterRect.Bottom > BackCenterRect.Top then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);  // Center
      DrawPartnormal(BackRightSrc, Self, BackRightRect, Alpha);  // Bottom
    end;

    // Progress bar
    BarRect := GetBarRect;
    if (BarRect.Right > BarRect.Left) and (BarRect.Bottom > BarRect.Top) then
    begin
      DrawPartnormal(BarSrc, Self, BarRect, Alpha);

      // Overlay (glossy effect)
      if Enabled and (OverlaySrc.Right > OverlaySrc.Left) then
        DrawPartnormal(OverlaySrc, Self, BarRect, Alpha);
    end;

    // Text
    DisplayText := GetDisplayText;
    if DisplayText <> '' then
    begin
      TextRect := GetTextRect;
      yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, DisplayText, taCenter);
    end;
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseProgressBar;
  end;

  inherited Paint;
end;

procedure TONURProgressBar.DrawBaseProgressBar;
var
  BarRect, TextRect: TRect;
  DisplayText: string;
  BorderColor, BackColor, BarColor, TextColor: TBGRAPixel;
  GlossRect: Windows.RECT;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    BorderColor := BGRA(180, 180, 180, Alpha);
    BackColor := BGRA(220, 220, 220, Alpha);
    BarColor := BGRA(160, 160, 160, Alpha);
    TextColor := BGRA(120, 120, 120, Alpha);
  end
  else
  begin
    BorderColor := BGRA(200, 200, 200, Alpha);
    BackColor := BGRA(240, 240, 240, Alpha);
    BarColor := BGRA(0, 120, 215, Alpha);  // Windows mavi
    TextColor := BGRA(0, 0, 0, Alpha);
  end;

  // Border ve background
  resim.FillRect(0, 0, ClientWidth, ClientHeight, BorderColor, dmSet);
  resim.FillRect(1, 1, ClientWidth - 1, ClientHeight - 1, BackColor, dmSet);

  // Progress bar
  BarRect := GetBarRect;
  if (BarRect.Right > BarRect.Left) and (BarRect.Bottom > BarRect.Top) then
  begin
    // Gradient efekti
    if Enabled then
    begin
      resim.FillRect(BarRect.Left, BarRect.Top, BarRect.Right,
        BarRect.Top + BarRect.Height div 2,
        BGRA(BarColor.red + 30, BarColor.green + 30, BarColor.blue + 30, Alpha), dmSet);
      resim.FillRect(BarRect.Left, BarRect.Top + BarRect.Height div
        2, BarRect.Right, BarRect.Bottom,
        BarColor, dmSet);
    end
    else
    begin
      resim.FillRect(BarRect, BarColor, dmSet);
    end;

    // Glossy overlay (basit)
    if Enabled then
    begin
      GlossRect := Rect(BarRect.Left + 2, BarRect.Top + 2, BarRect.Right - 2,
        BarRect.Top + BarRect.Height div 3);
      resim.FillRect(GlossRect, BGRA(255, 255, 255, Alpha div 3), dmSet);
    end;
  end;

  // Text
  DisplayText := GetDisplayText;
  if DisplayText <> '' then
  begin
    TextRect := GetTextRect;
    resim.CanvasBGRA.Font.Color := TextColor;
    resim.CanvasBGRA.Font.Style := [];
    yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, DisplayText, taCenter);
  end;
end;

procedure TONURProgressBar.ResIze;
begin
  inherited ResIze;
  UpdateLayout;
  InvalIdate;
end;

{ TONURScrollBar }

constructor TONURScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOrIentatIon := oroHorIzontal;
  FPosItIon := 0;
  FMin := 0;
  FMax := 100;
  FPageSIze := 10;
  FAutoHIde := oahNever;
  FIsVIsIble := True;

  FMouseOver := False;
  FIsDraggIng := False;

  FLeftButtonState := obsNormal;
  FRIghtButtonState := obsNormal;
  FThumbState := obsNormal;

  FAnImatIonProgress := 0.0;
  FThumbSIze := 20;
  FTargetThumbSIze := 20;

  FAutoHIdeTImer := TTImer.Create(Self);
  FAutoHIdeTImer.Enabled := False;
  FAutoHIdeTImer.Interval := 1000;
  FAutoHIdeTImer.OnTImer := @DoAutoHIdeTImer;

  FAnImatIonTImer := TTImer.Create(Self);
  FAnImatIonTImer.Enabled := False;
  FAnImatIonTImer.Interval := 16;
  FAnImatIonTImer.OnTImer := @DoAnImatIonTImer;

  Skinname:='scrollbarh';

  // 3-parca background sIstemI
  FBackLeftNormal := TONURCUSTOMCROP.Create('TOP');
  FBackCenterNormal := TONURCUSTOMCROP.Create('NORMAL');
  FBackRIghtNormal := TONURCUSTOMCROP.Create('BOTTOM');
  FBackLeftHover := TONURCUSTOMCROP.Create('TOP');
  FBackCenterHover := TONURCUSTOMCROP.Create('HOVER');
  FBackRIghtHover := TONURCUSTOMCROP.Create('BOTTOM');

  FBackLeftDIsabled := TONURCUSTOMCROP.Create('DISABLED');

  FBackCenterDIsabled := TONURCUSTOMCROP.Create('BACKCENTERDISABLED');
  FBackRIghtDIsabled := TONURCUSTOMCROP.Create('BACKRIGHTDISABLED');
  FLeftNormal := TONURCUSTOMCROP.Create('LEFTBUTTONNORMAL');
  FLeftHover := TONURCUSTOMCROP.Create('LEFTBUTTONHOVER');
  FLeftPressed := TONURCUSTOMCROP.Create('LEFTBUTTONPRESSED');
  FLeftDIsabled := TONURCUSTOMCROP.Create('LEFTBUTTONDISABLED');
  FRIghtNormal := TONURCUSTOMCROP.Create('RIGHTBUTTONNORMAL');
  FRIghtHover := TONURCUSTOMCROP.Create('RIGHTBUTTONHOVER');
  FRIghtPressed := TONURCUSTOMCROP.Create('RIGHTBUTTONPRESSED');
  FRIghtDIsabled := TONURCUSTOMCROP.Create('RIGHTBUTTONDISABLED');
  FThumbNormal := TONURCUSTOMCROP.Create('CENTERBUTTONNORMAL');
  FThumbHover := TONURCUSTOMCROP.Create('CENTERBUTTONHOVER');
  FThumbPressed := TONURCUSTOMCROP.Create('CENTERBUTTONPRESSED');
  FThumbDIsabled := TONURCUSTOMCROP.Create('CENTERBUTTONDISABLED');



  // 3-parca background nesnelerI
  Customcroplist.Add(FBackLeftNormal);
  CustomcroplIst.Add(FBackCenterNormal);
  CustomcroplIst.Add(FBackRIghtNormal);
  CustomcroplIst.Add(FBackLeftHover);
  CustomcroplIst.Add(FBackCenterHover);
  CustomcroplIst.Add(FBackRIghtHover);
  CustomcroplIst.Add(FBackLeftDIsabled);
  CustomcroplIst.Add(FBackCenterDIsabled);
  CustomcroplIst.Add(FBackRIghtDIsabled);
  CustomcroplIst.Add(FLeftNormal);
  CustomcroplIst.Add(FLeftHover);
  CustomcroplIst.Add(FLeftPressed);
  CustomcroplIst.Add(FLeftDIsabled);
  CustomcroplIst.Add(FRIghtNormal);
  CustomcroplIst.Add(FRIghtHover);
  CustomcroplIst.Add(FRIghtPressed);
  CustomcroplIst.Add(FRIghtDIsabled);
  CustomcroplIst.Add(FThumbNormal);
  CustomcroplIst.Add(FThumbHover);
  CustomcroplIst.Add(FThumbPressed);
  CustomcroplIst.Add(FThumbDIsabled);



  if FOrIentatIon = oroHorIzontal then
  begin
    Width := 200;
    Height := 20;
  end
  else
  begin
    Width := 20;
    Height := 200;
  end;

    // Set AutoHide property and show scrollbar
  SetAutoHIde(oahNever);

  UpdateLayout;
end;

destructor TONURScrollBar.Destroy;
begin
  CustomcroplIst.Clear;
  FreeAndNil(FAutoHIdeTImer);
  FreeAndNil(FAnImatIonTImer);
  inherited Destroy;
end;

procedure TONURScrollBar.SetOrIentatIon(Value: TONUROrientation);
begin
  if FOrIentatIon = Value then ExIt;

  FOrIentatIon := Value;

  if Value = oroHorIzontal then
  begin
    Width := 200;
    Height := 20;
    skinname := 'scrollbarh';
  end
  else
  begin
    Width := 20;
    Height := 200;
    skinname := 'scrollbarv';
  end;

  UpdateLayout;
  InvalIdate;
end;

procedure TONURScrollBar.SetPosItIon(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FPosItIon = Value then ExIt;

  FPosItIon := Value;
  UpdateLayout;

  if AssIgned(FOnChange) then FOnChange(Self);
  if AssIgned(FOnScroll) then FOnScroll(Self);

  InvalIdate;
end;

procedure TONURScrollBar.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FPosItIon < FMin then SetPosItIon(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURScrollBar.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FPosItIon > FMax then SetPosItIon(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURScrollBar.SetPageSIze(Value: integer);
begin
  if FPageSIze = Value then ExIt;
  FPageSIze := Value;
  UpdateThumbSIze;
  UpdateLayout;
  InvalIdate;
end;

procedure TONURScrollBar.SetAutoHIde(Value: TONURAutoHIde);
begin
  if FAutoHIde = Value then ExIt;
  FAutoHIde := Value;

  case Value of
    oahNever:
    begin
      StopAutoHIdeTImer;
      ShowScrollBar;
    end;
    oahOnMouseLeave:
    begin
      if not FMouseOver then
        StartAutoHIdeTImer;
    end;
    oahAlways:
    begin
      HIdeScrollBar;
    end;
  end;
end;

procedure TONURScrollBar.UpdateLayout;
var
  TrackWIdth, TrackHeIght, ThumbPos: integer;
begin
  // Check if control dimensions are valid
  if (Width <= 0) or (Height <= 0) then Exit;
  
  if FOrIentatIon = oroHorIzontal then
  begin
    // Left button (decrease) on left, right button (increase) on right
    FLeftRect := Rect(0, 0, Height, Height);
    FRIghtRect := Rect(Width - Height, 0, Width, Height);
    FTrackRect := Rect(FLeftRect.RIght, 0, FRIghtRect.Left, Height);

    UpdateThumbSIze;
    if FMax > FMin then
    begin
      TrackWIdth := FTrackRect.RIght - FTrackRect.Left;
      if TrackWIdth > 0 then
      begin
        ThumbPos := FTrackRect.Left + Round((FPosItIon - FMin) /
          (FMax - FMin) * (TrackWIdth - FThumbSIze));
        // Ensure thumb has minimum size
        if FThumbSIze > 0 then
          FThumbRect := Rect(ThumbPos, 2, ThumbPos + FThumbSIze, Height - 2)
        else
          FThumbRect := Rect(ThumbPos, 2, ThumbPos + 20, Height - 2);
      end
      else
        FThumbRect := Rect(0, 0, 0, 0);
    end
    else
      FThumbRect := Rect(0, 0, 0, 0);
  end
  else
  begin
    FLeftRect := Rect(0, 0, Width, Width);
    FRIghtRect := Rect(0, Height - Width, Width, Height);
    FTrackRect := Rect(0, FLeftRect.Bottom, Width, FRIghtRect.Top);

    UpdateThumbSIze;
    if FMax > FMin then
    begin
      TrackHeIght := FTrackRect.Bottom - FTrackRect.Top;
      if TrackHeIght > 0 then
      begin
        ThumbPos := FTrackRect.Top + Round((FPosItIon - FMin) /
          (FMax - FMin) * (TrackHeIght - FThumbSIze));
        // Ensure thumb has minimum size
        if FThumbSIze > 0 then
          FThumbRect := Rect(2, ThumbPos, Width - 2, ThumbPos + FThumbSIze)
        else
          FThumbRect := Rect(2, ThumbPos, Width - 2, ThumbPos + 20);
      end
      else
        FThumbRect := Rect(0, 0, 0, 0);
    end
    else
      FThumbRect := Rect(0, 0, 0, 0);
  end;
end;

procedure TONURScrollBar.UpdateThumbSIze;
var
  Range, TrackSIze: integer;
begin
  Range := FMax - FMin + 1;
  if Range <= 0 then
  begin
    FThumbSIze := 20;
    ExIt;
  end;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

  // Ensure minimum thumb size of 20 pixels
  if TrackSIze > 0 then
  begin
    FThumbSIze := Round(TrackSIze * FPageSIze / Range);
    FThumbSIze := EnsureRange(FThumbSIze, 20, TrackSIze div 2);
  end
  else
    FThumbSIze := 20;

  if FMouseOver then
    FTargetThumbSIze := FThumbSIze + 4
  else
    FTargetThumbSIze := FThumbSIze;
end;

procedure TONURScrollBar.StartAutoHIdeTImer;
begin
  if FAutoHIde = oahOnMouseLeave then
  begin
    if Assigned(FAutoHIdeTImer) then
    begin
      FAutoHIdeTImer.Enabled := True;
      FAutoHIdeTImer.Interval := 1000;
    end;
  end;
end;

procedure TONURScrollBar.StopAutoHIdeTImer;
begin
  if Assigned(FAutoHIdeTImer) then
    FAutoHIdeTImer.Enabled := False;
end;

procedure TONURScrollBar.DoAutoHIdeTImer(Sender: TObject);
begin
  StopAutoHIdeTImer;
  if not FMouseOver and (FAutoHIde = oahOnMouseLeave) then
    HIdeScrollBar;
end;

procedure TONURScrollBar.DoAnImatIonTImer(Sender: TObject);
begin
  // Check if timer is still valid
  if not Assigned(FAnImatIonTImer) then Exit;
  
  if FThumbSIze <> FTargetThumbSIze then
  begin
    if FThumbSIze < FTargetThumbSIze then
      FThumbSIze := Math.MIn(FThumbSIze + 1, FTargetThumbSIze)
    else
      FThumbSIze := Math.Max(FThumbSIze - 1, FTargetThumbSIze);

    UpdateLayout;
    InvalIdate;
  end
  else
  begin
    if Assigned(FAnImatIonTImer) then
      FAnImatIonTImer.Enabled := False;
  end;
end;

function TONURScrollBar.GetThumbRect: TRect;
begin
  Result := FThumbRect;
end;

function TONURScrollBar.PoIntInThumb(X, Y: integer): boolean;
begin
  // Check if thumb rectangle is valid
  if (FThumbRect.Right <= FThumbRect.Left) or (FThumbRect.Bottom <= FThumbRect.Top) then
  begin
    Result := False;
    Exit;
  end;
  
  Result := PtInRect(FThumbRect, PoInt(X, Y));
end;

function TONURScrollBar.PoIntInLeftButton(X, Y: integer): boolean;
begin
  // Check if left button rectangle is valid
  if (FLeftRect.Right <= FLeftRect.Left) or (FLeftRect.Bottom <= FLeftRect.Top) then
  begin
    Result := False;
    Exit;
  end;
  
  Result := PtInRect(FLeftRect, PoInt(X, Y));
end;

function TONURScrollBar.PoIntInRIghtButton(X, Y: integer): boolean;
begin
  // Check if right button rectangle is valid
  if (FRIghtRect.Right <= FRIghtRect.Left) or (FRIghtRect.Bottom <= FRIghtRect.Top) then
  begin
    Result := False;
    Exit;
  end;
  
  Result := PtInRect(FRIghtRect, PoInt(X, Y));
end;

function TONURScrollBar.PoIntInTrack(X, Y: integer): boolean;
begin
  // Check if track rectangle is valid
  if (FTrackRect.Right <= FTrackRect.Left) or (FTrackRect.Bottom <= FTrackRect.Top) then
  begin
    Result := False;
    Exit;
  end;
  
  Result := PtInRect(FTrackRect, PoInt(X, Y)) and not PoIntInThumb(X, Y);
end;

procedure TONURScrollBar.ScrollToPosItIon(NewPosItIon: integer);
begin
  SetPosItIon(NewPosItIon);
end;

procedure TONURScrollBar.BeginDrag(X, Y: integer);
begin
  FIsDraggIng := True;
  if FOrIentatIon = oroHorIzontal then
    FDragStartPos := X
  else
    FDragStartPos := Y;
  FDragStartValue := FPosItIon;
  FThumbState := obsPressed;
end;

procedure TONURScrollBar.EndDrag;
begin
  FIsDraggIng := False;
  if FMouseOver then
    FThumbState := obsHover
  else
    FThumbState := obsNormal;
end;

procedure TONURScrollBar.UpdateDrag(X, Y: integer);
var
  Delta, NewPos, TrackSIze: integer;
begin
  if not FIsDraggIng then ExIt;

  // Check if track rectangle is valid
  if (FTrackRect.Right <= FTrackRect.Left) or (FTrackRect.Bottom <= FTrackRect.Top) then
    Exit;

  if FOrIentatIon = oroHorIzontal then
    Delta := X - FDragStartPos
  else
    Delta := Y - FDragStartPos;

  if FOrIentatIon = oroHorIzontal then
    TrackSIze := FTrackRect.RIght - FTrackRect.Left - FThumbSIze
  else
    TrackSIze := FTrackRect.Bottom - FTrackRect.Top - FThumbSIze;

  if TrackSIze > 0 then
  begin
    NewPos := FDragStartValue + Round(Delta * (FMax - FMin + 1) / TrackSIze);
    ScrollToPosItIon(NewPos);
  end;
end;

procedure TONURScrollBar.PaInt;
var
  BackSrc, LeftSrc, RIghtSrc, ThumbSrc: TRect;
  BackLeftSrc, BackCenterSrc, BackRIghtSrc: TRect;
  BackLeftRect, BackCenterRect, BackRIghtRect: TRect;
  LeftWIdth: longint;
  RIghtWIdth: longint;
  TopHeIght: longint;
  BottomHeIght: longint;
begin

  if not Visible or not FIsVIsIble then ExIt;

  // Check dimensions to prevent image too big error
  if (ClientWidth <= 0) or (ClientHeight <= 0) then ExIt;
  
  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (SkIndata <> nil) and not (csDesIgnIng in ComponentState) then
  begin
    // Background - 3-parca sIstem


    if not Enabled then
    begin
      if FBackLeftDIsabled <> nil then
        BackLeftSrc := FBackLeftDIsabled.Croprect;
      if FBackCenterDIsabled <> nil then
        BackCenterSrc := FBackCenterDIsabled.Croprect;
      if FBackRIghtDIsabled <> nil then
        BackRIghtSrc := FBackRIghtDIsabled.Croprect;
    end
    else if FMouseOver then
    begin
      if FBackLeftHover <> nil then
        BackLeftSrc := FBackLeftHover.Croprect;
      if FBackCenterHover <> nil then
        BackCenterSrc := FBackCenterHover.Croprect;
      if FBackRIghtHover <> nil then
        BackRIghtSrc := FBackRIghtHover.Croprect;
    end
    else
    begin
      if FBackLeftNormal <> nil then
        BackLeftSrc := FBackLeftNormal.Croprect;
      if FBackCenterNormal <> nil then
        BackCenterSrc := FBackCenterNormal.Croprect;
      if FBackRIghtNormal <> nil then
        BackRIghtSrc := FBackRIghtNormal.Croprect;
    end;

    // 3-parca cIzIm
    if FOrIentatIon = oroHorIzontal then
    begin
      // HorIzontal: Left - Center - RIght
      if (BackLeftSrc.Right > BackLeftSrc.Left) and (FBackLeftNormal <> nil) then
        LeftWIdth := BackLeftSrc.RIght - BackLeftSrc.Left
      else
        LeftWIdth := 0;
      
      if (BackRIghtSrc.Right > BackRIghtSrc.Left) and (FBackRIghtNormal <> nil) then
        RIghtWIdth := BackRIghtSrc.RIght - BackRIghtSrc.Left
      else
        RIghtWIdth := 0;

      BackLeftRect := Rect(0, 0, LeftWIdth, Height);
      BackCenterRect := Rect(LeftWIdth, 0, Width - RIghtWIdth, Height);
      BackRIghtRect := Rect(Width - RIghtWIdth, 0, Width, Height);

      if (FBackLeftNormal <> nil) and (BackLeftRect.Right > BackLeftRect.Left) then
        DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);
      if (BackCenterRect.RIght > BackCenterRect.Left) and (FBackCenterNormal <> nil) then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);
      if (FBackRIghtNormal <> nil) and (BackRIghtRect.Right > BackRIghtRect.Left) then
        DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);
    end
    else
    begin
      // VertIcal: Top - Center - Bottom
      if (BackLeftSrc.Bottom > BackLeftSrc.Top) and (FBackLeftNormal <> nil) then
        TopHeIght := BackLeftSrc.Bottom - BackLeftSrc.Top  // BackLeft as Top
      else
        TopHeIght := 0;
      
      if (BackRIghtSrc.Bottom > BackRIghtSrc.Top) and (FBackRIghtNormal <> nil) then
        BottomHeIght := BackRIghtSrc.Bottom - BackRIghtSrc.Top  // BackRIght as Bottom
      else
        BottomHeIght := 0;

      BackLeftRect := Rect(0, 0, Width, TopHeIght);  // Top
      BackCenterRect := Rect(0, TopHeIght, Width, Height - BottomHeIght);  // Center
      BackRIghtRect := Rect(0, Height - BottomHeIght, Width, Height);  // Bottom

      if (FBackLeftNormal <> nil) and (BackLeftRect.Bottom > BackLeftRect.Top) then
        DrawPartnormal(BackLeftSrc, Self, BackLeftRect, Alpha);  // Top
      if (BackCenterRect.Bottom > BackCenterRect.Top) and (FBackCenterNormal <> nil) then
        DrawPartnormal(BackCenterSrc, Self, BackCenterRect, Alpha);  // Center
      if (FBackRIghtNormal <> nil) and (BackRIghtRect.Bottom > BackRIghtRect.Top) then
        DrawPartnormal(BackRIghtSrc, Self, BackRIghtRect, Alpha);  // Bottom
    end;

    // Left button
    if not Enabled then
    begin
      if FLeftDIsabled <> nil then
        LeftSrc := FLeftDIsabled.Croprect;
    end
    else
    begin
      case FLeftButtonState of
        obsNormal: 
          if FLeftNormal <> nil then
            LeftSrc := FLeftNormal.Croprect;
        obsHover: 
          if FLeftHover <> nil then
            LeftSrc := FLeftHover.Croprect;
        obsPressed: 
          if FLeftPressed <> nil then
            LeftSrc := FLeftPressed.Croprect;
        else
          if FLeftNormal <> nil then
            LeftSrc := FLeftNormal.Croprect;
      end;
    end;
    if (FLeftRect.Right > FLeftRect.Left) and (FLeftRect.Bottom > FLeftRect.Top) then
      DrawPartnormal(LeftSrc, Self, FLeftRect, Alpha);

    // RIght button
    if not Enabled then
    begin
      if FRIghtDIsabled <> nil then
        RIghtSrc := FRIghtDIsabled.Croprect;
    end
    else
    begin
      case FRIghtButtonState of
        obsNormal: 
          if FRIghtNormal <> nil then
            RIghtSrc := FRIghtNormal.Croprect;
        obsHover: 
          if FRIghtHover <> nil then
            RIghtSrc := FRIghtHover.Croprect;
        obsPressed: 
          if FRIghtPressed <> nil then
            RIghtSrc := FRIghtPressed.Croprect;
        else
          if FRIghtNormal <> nil then
            RIghtSrc := FRIghtNormal.Croprect;
      end;
    end;
    if (FRIghtRect.Right > FRIghtRect.Left) and (FRIghtRect.Bottom > FRIghtRect.Top) then
      DrawPartnormal(RIghtSrc, Self, FRIghtRect, Alpha);

    // Thumb
    if (FMax > FMin) and (FThumbRect.RIght > FThumbRect.Left) then
    begin
      if not Enabled then
      begin
        if FThumbDIsabled <> nil then
          ThumbSrc := FThumbDIsabled.Croprect;
      end
      else
      begin
        case FThumbState of
          obsNormal: 
            if FThumbNormal <> nil then
              ThumbSrc := FThumbNormal.Croprect;
          obsHover: 
            if FThumbHover <> nil then
              ThumbSrc := FThumbHover.Croprect;
          obsPressed: 
            if FThumbPressed <> nil then
              ThumbSrc := FThumbPressed.Croprect;
          else
            if FThumbNormal <> nil then
              ThumbSrc := FThumbNormal.Croprect;
        end;
      end;
      DrawPartnormal(ThumbSrc, Self, FThumbRect, Alpha);
    end;
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseScrollBar;
  end;

  inherited PaInt;
end;

procedure TONURScrollBar.DrawBaseScrollBar;
var
  BorderColor, BackColor, TrackColor, ButtonColor, ThumbColor, TextColor: TBGRAPixel;
  LeftArrow, RightArrow: string;
  GlossRect: Windows.RECT;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    BorderColor := BGRA(180, 180, 180, Alpha);
    BackColor := BGRA(220, 220, 220, Alpha);
    TrackColor := BGRA(200, 200, 200, Alpha);
    ButtonColor := BGRA(160, 160, 160, Alpha);
    ThumbColor := BGRA(140, 140, 140, Alpha);
    TextColor := BGRA(120, 120, 120, Alpha);
  end
  else
  begin
    BorderColor := BGRA(200, 200, 200, Alpha);
    BackColor := BGRA(240, 240, 240, Alpha);
    TrackColor := BGRA(210, 210, 210, Alpha);
    ButtonColor := BGRA(180, 180, 180, Alpha);
    ThumbColor := BGRA(160, 160, 160, Alpha);
    TextColor := BGRA(0, 0, 0, Alpha);
  end;

  // Border ve background
  resim.FillRect(0, 0, ClientWidth, ClientHeight, BorderColor, dmSet);
  resim.FillRect(1, 1, ClientWidth - 1, ClientHeight - 1, BackColor, dmSet);

  // Track
  resim.FillRect(FTrackRect, TrackColor, dmSet);

  // Buttons
  resim.FillRect(FLeftRect, ButtonColor, dmSet);
  resim.FillRect(FRightRect, ButtonColor, dmSet);

  // Button gradient efekti
  if Enabled then
  begin
    resim.FillRect(FLeftRect.Left, FLeftRect.Top, FLeftRect.Right,
      FLeftRect.Top + FLeftRect.Height div 2,
      BGRA(ButtonColor.red + 20, ButtonColor.green + 20, ButtonColor.blue +
      20, Alpha), dmSet);
    resim.FillRect(FRightRect.Left, FRightRect.Top, FRightRect.Right,
      FRightRect.Top + FRightRect.Height div 2,
      BGRA(ButtonColor.red + 20, ButtonColor.green + 20, ButtonColor.blue +
      20, Alpha), dmSet);
  end;

  // Thumb
  if (FMax > FMin) and (FThumbRect.Right > FThumbRect.Left) then
  begin
    resim.FillRect(FThumbRect, ThumbColor, dmSet);

    // Thumb gradient efekti
    if Enabled then
    begin
      resim.FillRect(FThumbRect.Left, FThumbRect.Top, FThumbRect.Right,
        FThumbRect.Top + FThumbRect.Height div 2,
        BGRA(ThumbColor.red + 15, ThumbColor.green + 15, ThumbColor.blue + 15,
        Alpha), dmSet);

      // Thumb glossy overlay
      GlossRect := Rect(FThumbRect.Left + 2, FThumbRect.Top + 2,
        FThumbRect.Right - 2, FThumbRect.Top + FThumbRect.Height div 3);
      resim.FillRect(GlossRect, BGRA(255, 255, 255, Alpha div 4), dmSet);
    end;
  end;

  // Arrow text
  if FOrientation = oroHorizontal then
  begin
    LeftArrow := '<';   // Left button - back/decrease
    RightArrow := '>';  // Right button - forward/increase
  end
  else
  begin
    LeftArrow := '^';    // Top button - back/decrease
    RightArrow := 'v';   // Bottom button - forward/increase
  end;

  // Draw arrows
  resim.CanvasBGRA.Font.Color := TextColor;
  resim.CanvasBGRA.Font.Style := [fsBold];
  yaziyazBGRA(resim.CanvasBGRA, Font, FLeftRect, LeftArrow, taCenter);
  yaziyazBGRA(resim.CanvasBGRA, Font, FRightRect, RightArrow, taCenter);
end;

procedure TONURScrollBar.MouseDown(Button: TMouseButton; ShIft: TShIftState;
  X, Y: integer);
var
  ClIckPos, TrackSIze, NewPos: integer;
begin
  if not Enabled then ExIt;

  inherited MouseDown(Button, ShIft, X, Y);

  if Button = mbLeft then
  begin
    // Check if rectangles are valid before testing mouse position
    if (FLeftRect.Right <= FLeftRect.Left) or (FThumbRect.Right <= FThumbRect.Left) then
      Exit;
      
    if PoIntInThumb(X, Y) then
    begin
      BeginDrag(X, Y);
    end
    else if PoIntInLeftButton(X, Y) then
    begin
      FLeftButtonState := obsPressed;
      ScrollBy(-1);
    end
    else if PoIntInRIghtButton(X, Y) then
    begin
      FRIghtButtonState := obsPressed;
      ScrollBy(1);
    end
    else if PoIntInTrack(X, Y) then
    begin
      // Check if track rectangle is valid
      if (FTrackRect.Right <= FTrackRect.Left) or (FTrackRect.Bottom <= FTrackRect.Top) then
        Exit;
        
      if FOrIentatIon = oroHorIzontal then
        ClIckPos := X
      else
        ClIckPos := Y;

      if FOrIentatIon = oroHorIzontal then
        TrackSIze := FTrackRect.RIght - FTrackRect.Left
      else
        TrackSIze := FTrackRect.Bottom - FTrackRect.Top;

      if TrackSIze > 0 then
      begin
        if FOrIentatIon = oroHorIzontal then
          NewPos := FMin + Round((ClIckPos - FTrackRect.Left - FThumbSIze / 2) /
            TrackSIze * (FMax - FMin + 1))
        else
          NewPos := FMin + Round((ClIckPos - FTrackRect.Top - FThumbSIze / 2) /
            TrackSIze * (FMax - FMin + 1));

        ScrollToPosItIon(NewPos);
      end;
    end;

    InvalIdate;
  end;
end;

procedure TONURScrollBar.MouseUp(Button: TMouseButton; ShIft: TShIftState;
  X, Y: integer);
begin
  if not Enabled then ExIt;

  inherited MouseUp(Button, ShIft, X, Y);

  if Button = mbLeft then
  begin
    EndDrag;

    if PoIntInLeftButton(X, Y) then
      FLeftButtonState := obsHover
    else
      FLeftButtonState := obsNormal;

    if PoIntInRIghtButton(X, Y) then
      FRIghtButtonState := obsHover
    else
      FRIghtButtonState := obsNormal;

    if PoIntInThumb(X, Y) then
      FThumbState := obsHover
    else
      FThumbState := obsNormal;

    InvalIdate;
  end;
end;

procedure TONURScrollBar.MouseMove(ShIft: TShIftState; X, Y: integer);
var
  StateChanged: boolean;
  NewLeftState, NewRIghtState, NewThumbState: TONURState;
begin
  if not Enabled then ExIt;

  inherited MouseMove(ShIft, X, Y);

  if FIsDraggIng then
  begin
    UpdateDrag(X, Y);
    ExIt;
  end;

  // Check if rectangles are valid before testing mouse position
  if (FLeftRect.Right <= FLeftRect.Left) or (FThumbRect.Right <= FThumbRect.Left) then
    Exit;

  StateChanged := False;

  if PoIntInLeftButton(X, Y) then
    NewLeftState := obsHover
  else
    NewLeftState := obsNormal;

  if NewLeftState <> FLeftButtonState then
  begin
    FLeftButtonState := NewLeftState;
    StateChanged := True;
  end;

  if PoIntInRIghtButton(X, Y) then
    NewRIghtState := obsHover
  else
    NewRIghtState := obsNormal;

  if NewRIghtState <> FRIghtButtonState then
  begin
    FRIghtButtonState := NewRIghtState;
    StateChanged := True;
  end;

  if PoIntInThumb(X, Y) then
    NewThumbState := obsHover
  else
    NewThumbState := obsNormal;

  if NewThumbState <> FThumbState then
  begin
    FThumbState := NewThumbState;
    StateChanged := True;
  end;

  if StateChanged then
    InvalIdate;
end;

procedure TONURScrollBar.MouseEnter;
var
  MousePos: TPoInt;
begin
  inherited MouseEnter;

  FMouseOver := True;
  StopAutoHIdeTImer;

  if FAutoHIde <> oahAlways then
    ShowScrollBar;

  // Check if rectangles are valid before testing mouse position
  if (FLeftRect.Right <= FLeftRect.Left) or (FThumbRect.Right <= FThumbRect.Left) then
  begin
    Invalidate;
    Exit;
  end;

  MousePos := ScreenToClIent(Mouse.CursorPos);

  if PoIntInLeftButton(MousePos.X, MousePos.Y) then
    FLeftButtonState := obsHover;

  if PoIntInRIghtButton(MousePos.X, MousePos.Y) then
    FRIghtButtonState := obsHover;

  if PoIntInThumb(MousePos.X, MousePos.Y) then
    FThumbState := obsHover;

  UpdateThumbSIze;
  if FThumbSIze <> FTargetThumbSIze then
    FAnImatIonTImer.Enabled := True;

  InvalIdate;
end;

procedure TONURScrollBar.MouseLeave;
begin
  inherited MouseLeave;

  FMouseOver := False;

  FLeftButtonState := obsNormal;
  FRIghtButtonState := obsNormal;
  FThumbState := obsNormal;

  if FAutoHIde = oahOnMouseLeave then
    StartAutoHIdeTImer;

  UpdateThumbSIze;
  if FThumbSIze <> FTargetThumbSIze then
    FAnImatIonTImer.Enabled := True;

  InvalIdate;
end;

function TONURScrollBar.DoMouseWheel(ShIft: TShIftState; WheelDelta: integer;
  MousePos: TPoInt): boolean;
var
  ScrollAmount: integer;
begin
  Result := False;
  if not Enabled then ExIt;

  // Mouse pozIsyonu kontrol et
  if PtInRect(ClIentRect, ScreenToClIent(MousePos)) then
  begin
    if WheelDelta > 0 then
      ScrollAmount := -1    // YukarI scroll
    else
      ScrollAmount := 1;    // AsagI scroll

    if ssShIft in ShIft then
      ScrollAmount := ScrollAmount * 3;  // HIzlI scroll

    ScrollBy(ScrollAmount);
    Result := True;  // Event handled
  end;
end;

procedure TONURScrollBar.ResIze;
begin
  inherited ResIze;
  UpdateLayout;
end;

procedure TONURScrollBar.ScrollBy(Delta: integer);
begin
  ScrollToPosItIon(FPosItIon + Delta);
end;

procedure TONURScrollBar.ScrollToTop;
begin
  ScrollToPosItIon(FMin);
end;

procedure TONURScrollBar.ScrollToBottom;
begin
  ScrollToPosItIon(FMax);
end;

procedure TONURScrollBar.ShowScrollBar;
begin
  if not FIsVIsIble then
  begin
    FIsVIsIble := True;
    InvalIdate;
  end;
end;

procedure TONURScrollBar.HIdeScrollBar;
begin
  if FIsVIsIble then
  begin
    FIsVIsIble := False;
    InvalIdate;
  end;
end;

{ TONURGaugeBar }

constructor TONURGaugeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMin := 0;
  FMax := 100;
  FValue := 0;
  FStyle := osFull;
  FState := obsNormal;
  FShowScale := True;
  FScaleCount := 10;
  FShowNeedle := True;
  FNeedleLength := 80;
  FNeedleColor := clRed;
  FAnImated := True;
  FTargtValue := 0;
  FAnImatIonSpeed := 0.1;

  // Background parts
  FBackNormal := TONURCUSTOMCROP.Create('NORMAL');
  FBackHover := TONURCUSTOMCROP.Create('HOVER');
  FBackPressed := TONURCUSTOMCROP.Create('PRESSED');
  FBackDIsabled := TONURCUSTOMCROP.Create('DISABLED');

  // Needle parts
  FNeedleNormal := TONURCUSTOMCROP.Create('NEEDLENORMAL');
  FNeedleHover := TONURCUSTOMCROP.Create('NEEDLEHOVER');
  FNeedlePressed := TONURCUSTOMCROP.Create('NEEDLEPRESSED');
  FNeedleDIsabled := TONURCUSTOMCROP.Create('NEEDLEDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackNormal);
  CustomcroplIst.Add(FBackHover);
  CustomcroplIst.Add(FBackPressed);
  CustomcroplIst.Add(FBackDIsabled);
  CustomcroplIst.Add(FNeedleNormal);
  CustomcroplIst.Add(FNeedleHover);
  CustomcroplIst.Add(FNeedlePressed);
  CustomcroplIst.Add(FNeedleDIsabled);

  // AnImatIon TImer
  FAnImatIonTImer := TTImer.Create(Self);
  FAnImatIonTImer.Interval := 16;  // 60 FPS
  FAnImatIonTImer.OnTImer := @DoAnImatIonTImer;

  // Set default sIze
  Width := 200;
  Height := 200;
  SkInname := 'gaugebar';

  UpdateLayout;
  UpdateAngles;
end;

destructor TONURGaugeBar.Destroy;
begin
  if AssIgned(FAnImatIonTImer) then
  begin
    FAnImatIonTImer.Enabled := False;
    FreeAndNil(FAnImatIonTImer);
  end;

  inherited Destroy;
end;

procedure TONURGaugeBar.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FValue < FMin then SetValue(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURGaugeBar.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FValue > FMax then SetValue(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURGaugeBar.SetValue(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FValue = Value then ExIt;

  if FAnImated then
    AnimateToValue(Value)
  else
  begin
    FValue := Value;
    InvalIdate;
  end;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURGaugeBar.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then ExIt;
  FStyle := Value;
  UpdateAngles;
  UpdateLayout;
  InvalIdate;
end;

procedure TONURGaugeBar.SetShowScale(Value: boolean);
begin
  if FShowScale = Value then ExIt;
  FShowScale := Value;
  InvalIdate;
end;

procedure TONURGaugeBar.SetScaleCount(Value: integer);
begin
  if FScaleCount = Value then ExIt;
  FScaleCount := EnsureRange(Value, 2, 50);
  InvalIdate;
end;

procedure TONURGaugeBar.SetShowNeedle(Value: boolean);
begin
  if FShowNeedle = Value then ExIt;
  FShowNeedle := Value;
  InvalIdate;
end;

procedure TONURGaugeBar.SetNeedleLength(Value: integer);
begin
  if FNeedleLength = Value then ExIt;
  FNeedleLength := EnsureRange(Value, 10, 100);
  InvalIdate;
end;

procedure TONURGaugeBar.SetNeedleColor(Value: TColor);
begin
  if FNeedleColor = Value then ExIt;
  FNeedleColor := Value;
  InvalIdate;
end;

procedure TONURGaugeBar.SetAnImated(Value: boolean);
begin
  if FAnImated = Value then ExIt;
  FAnImated := Value;

  if not FAnImated then
    StopAnImatIon;
end;

procedure TONURGaugeBar.SetAnImatIonSpeed(Value: real);
begin
  if FAnImatIonSpeed = Value then ExIt;
  FAnImatIonSpeed := EnsureRange(Value, 0.01, 1.0);
end;

procedure TONURGaugeBar.UpdateLayout;
begin
  // Center poInt
  FCenterX := Width div 2;
  FCenterY := Height div 2;

  // Radius
  if Width < Height then
    FRadius := (Width div 2) - 10
  else
    FRadius := (Height div 2) - 10;

  // Inner radius (donut effect)
  FInnerRadius := FRadius div 3;
end;

procedure TONURGaugeBar.UpdateAngles;
begin
  case FStyle of
    osFull:
    begin
      FStartAngle := -135;  // Top left
      FEndAngle := 135;     // Top right
    end;
    osHalf:
    begin
      FStartAngle := -90;   // Left
      FEndAngle := 90;      // Right
    end;
    osQuarter:
    begin
      FStartAngle := 0;     // Top
      FEndAngle := 90;      // Right
    end;
    osThreeQuarter:
    begin
      FStartAngle := -90;   // Left
      FEndAngle := 270;     // Bottom (almost full circle)
    end;
  end;
end;

function TONURGaugeBar.ValueToAngle(Value: integer): integer;
begin
  if FMax = FMin then
    Result := FStartAngle
  else
    Result := FStartAngle + Round((Value - FMin) / (FMax - FMin) *
      (FEndAngle - FStartAngle));
end;

function TONURGaugeBar.AngleToValue(Angle: integer): integer;
begin
  if FEndAngle = FStartAngle then
    Result := FMin
  else
    Result := FMin + Round((Angle - FStartAngle) / (FEndAngle - FStartAngle) *
      (FMax - FMin));

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURGaugeBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FValue - FMin) / (FMax - FMin) * 100);
end;

procedure TONURGaugeBar.SetPercentage(Value: integer);
var
  NewValue: int64;
begin
  Value := EnsureRange(Value, 0, 100);
  NewValue := FMin + Round((FMax - FMin) * Value / 100);
  SetValue(NewValue);
end;

procedure TONURGaugeBar.AnimateToValue(Value: integer);
begin
  FTargtValue := Value;
  StartAnImatIon;
end;

procedure TONURGaugeBar.StartAnImatIon;
begin
  if FAnImated and not FAnImatIonTImer.Enabled then
    FAnImatIonTImer.Enabled := True;
end;

procedure TONURGaugeBar.StopAnImatIon;
begin
  if AssIgned(FAnImatIonTImer) then
    FAnImatIonTImer.Enabled := False;
end;

procedure TONURGaugeBar.DoAnImatIonTImer(Sender: TObject);
var
  Delta: integer;
  NewValue: integer;
begin
  if FValue = FTargtValue then
  begin
    StopAnImatIon;
    ExIt;
  end;

  Delta := FTargtValue - FValue;
  NewValue := FValue + Round(Delta * FAnImatIonSpeed);

  if Abs(FTargtValue - NewValue) < 1 then
    NewValue := FTargtValue;

  if NewValue <> FValue then
  begin
    FValue := NewValue;
    InvalIdate;
  end;
end;

procedure TONURGaugeBar.Paint;
var
  BackSrc, NeedleSrc: TRect;
  Angle: integer;
  NeedleEndX, NeedleEndY: integer;
  I: integer;
  ScaleAngle: integer;
  ScaleX, ScaleY: integer;
  ScaleValue: integer;
  Texti: string;
  TextRect: Windows.RECT;
begin
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Background
    if not Enabled then
      BackSrc := FBackDIsabled.Croprect
    else
    begin
      case FState of
        obsNormal: BackSrc := FBackNormal.Croprect;
        obsHover: BackSrc := FBackHover.Croprect;
        obsPressed: BackSrc := FBackPressed.Croprect;
        else
          BackSrc := FBackNormal.Croprect;
      end;
    end;

    DrawPartnormal(BackSrc, Self, Rect(0, 0, Width, Height), Alpha);

    // Needle
    if FShowNeedle then
    begin
      Angle := ValueToAngle(FValue);
      NeedleEndX := FCenterX + Round(FRadius * FNeedleLength / 100 *
        Cos(DegToRad(Angle - 90)));
      NeedleEndY := FCenterY + Round(FRadius * FNeedleLength / 100 *
        Sin(DegToRad(Angle - 90)));

      // Draw needle as a lIne
      resim.DrawLineAntialias(FCenterX, FCenterY, NeedleEndX, NeedleEndY,
        FNeedleColor, 3);

      // Center dot
      resim.FillEllipseAntialias(FCenterX, FCenterY, 5, 5, FNeedleColor);
    end;

    // Scale
    if FShowScale then
    begin
      resim.CanvasBGRA.Font.Color := BGRA(100, 100, 100, Alpha);
      resim.CanvasBGRA.Font.Height := 8;

      for I := 0 to FScaleCount - 1 do
      begin
        ScaleAngle := FStartAngle + Round(I * (FEndAngle - FStartAngle) /
          (FScaleCount - 1));
        ScaleX := FCenterX + Round((FRadius - 15) * Cos(DegToRad(ScaleAngle - 90)));
        ScaleY := FCenterY + Round((FRadius - 15) * Sin(DegToRad(ScaleAngle - 90)));

        // Draw scale mark
        resim.DrawLineAntialias(
          FCenterX + Round((FRadius - 5) * Cos(DegToRad(ScaleAngle - 90))),
          FCenterY + Round((FRadius - 5) * Sin(DegToRad(ScaleAngle - 90))),
          ScaleX, ScaleY, BGRA(100, 100, 100, Alpha), 1
          );

        // Draw value text
        ScaleValue := AngleToValue(ScaleAngle);
        Texti := IntToStr(ScaleValue);
        TextRect := Rect(ScaleX - 10, ScaleY - 10, ScaleX + 10, ScaleY + 10);
        yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, Texti, taCenter);
      end;
    end;
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseGaugeBar;
  end;

  inherited Paint;
end;

procedure TONURGaugeBar.DrawBaseGaugeBar;
var
  Angle: integer;
  NeedleEndX, NeedleEndY: integer;
  I: integer;
  ScaleAngle: integer;
  ScaleX, ScaleY: integer;
  OuterColor, InnerColor, ScaleColor, NeedleColore: TBGRAPixel;
  ScaleValue: integer;
  Texti: string;
  TextRect: Windows.RECT;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    OuterColor := BGRA(200, 200, 200, Alpha);
    InnerColor := BGRA(240, 240, 240, Alpha);
    ScaleColor := BGRA(150, 150, 150, Alpha);
    NeedleColore := ColorToBGRA(FNeedleColor, Alpha);
  end
  else
  begin
    OuterColor := BGRA(220, 220, 220, Alpha);
    InnerColor := BGRA(250, 250, 250, Alpha);
    ScaleColor := BGRA(100, 100, 100, Alpha);
    NeedleColore := ColorToBGRA(FNeedleColor, Alpha);
  end;

  // Outer circle
  resim.FillEllipseAntialias(FCenterX, FCenterY, FRadius, FRadius, OuterColor);

  // Inner circle (donut)
  resim.FillEllipseAntialias(FCenterX, FCenterY, FInnerRadius, FInnerRadius, InnerColor);

  // Scale
  if FShowScale then
  begin
    for I := 0 to FScaleCount - 1 do
    begin
      ScaleAngle := FStartAngle + Round(I * (FEndAngle - FStartAngle) /
        (FScaleCount - 1));
      ScaleX := FCenterX + Round((FRadius - 15) * Cos(DegToRad(ScaleAngle - 90)));
      ScaleY := FCenterY + Round((FRadius - 15) * Sin(DegToRad(ScaleAngle - 90)));

      // Draw scale mark
      resim.DrawLineAntialias(
        FCenterX + Round((FRadius - 5) * Cos(DegToRad(ScaleAngle - 90))),
        FCenterY + Round((FRadius - 5) * Sin(DegToRad(ScaleAngle - 90))),
        ScaleX, ScaleY, ScaleColor, 2
        );

      // Draw value text
      ScaleValue := AngleToValue(ScaleAngle);
      Texti := IntToStr(ScaleValue);
      resim.CanvasBGRA.Font.Color := ScaleColor;
      resim.CanvasBGRA.Font.Height := 8;
      TextRect := Rect(ScaleX - 10, ScaleY - 10, ScaleX + 10, ScaleY + 10);
      yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, Texti, taCenter);
    end;
  end;

  // Needle
  if FShowNeedle then
  begin
    Angle := ValueToAngle(FValue);
    NeedleEndX := FCenterX + Round(FRadius * FNeedleLength / 100 *
      Cos(DegToRad(Angle - 90)));
    NeedleEndY := FCenterY + Round(FRadius * FNeedleLength / 100 *
      Sin(DegToRad(Angle - 90)));

    // Draw needle
    resim.DrawLineAntialias(FCenterX, FCenterY, NeedleEndX, NeedleEndY, NeedleColore, 4);

    // Center dot
    resim.FillEllipseAntialias(FCenterX, FCenterY, 6, 6, NeedleColore);

    // Glossy effect on center
    if Enabled then
      resim.FillEllipseAntialias(FCenterX - 2, FCenterY - 2, 3, 3,
        BGRA(255, 255, 255, Alpha div 2));
  end;
end;

procedure TONURGaugeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  DX: integer;
  DY: integer;
  Angle: int64;
begin
  if not Enabled then Exit;

  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FState := obsPressed;

    // Calculate value from mouse posItIon
    DX := X - FCenterX;
    DY := Y - FCenterY;
    Angle := Round(RadToDeg(ArcTan2(DY, DX))) + 90;

    // Normalize angle to range
    while Angle < FStartAngle do Angle := Angle + 360;
    while Angle > FEndAngle do Angle := Angle - 360;

    if (Angle >= FStartAngle) and (Angle <= FEndAngle) then
      SetValue(AngleToValue(Angle));

    Invalidate;
  end;
end;

procedure TONURGaugeBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not Enabled then Exit;

  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURGaugeBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewState: TONURState;
  DX: integer;
  DY: integer;
  Angle: int64;
  DIstance: ValReal;
begin
  if not Enabled then Exit;

  inherited MouseMove(Shift, X, Y);

  if ssLeft in Shift then
  begin
    // Drag to set value
    DX := X - FCenterX;
    DY := Y - FCenterY;
    Angle := Round(RadToDeg(ArcTan2(DY, DX))) + 90;

    // Normalize angle to range
    while Angle < FStartAngle do Angle := Angle + 360;
    while Angle > FEndAngle do Angle := Angle - 360;

    if (Angle >= FStartAngle) and (Angle <= FEndAngle) then
      SetValue(AngleToValue(Angle));
  end
  else
  begin
    // Check if mouse is over gauge
    DX := X - FCenterX;
    DY := Y - FCenterY;
    DIstance := Sqrt(DX * DX + DY * DY);

    if DIstance <= FRadius then
      NewState := obsHover
    else
      NewState := obsNormal;

    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURGaugeBar.MouseEnter;
begin
  inherited MouseEnter;

  if not (ssLeft in GetKeyShiftState) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURGaugeBar.MouseLeave;
begin
  inherited MouseLeave;

  if not (ssLeft in GetKeyShiftState) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURGaugeBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;



{ TONURKnob }

constructor TONURKnob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMin := 0;
  FMax := 100;
  FValue := 0;
  FStyle := osFull;
  FState := obsNormal;
  FShowScale := True;
  FScaleCount := 10;
  FShowPointer := True;
  FPointerLength := 80;
  FPointerColor := BGRA(255, 255, 255, Alpha);
  FStep := 1;
  FScrollStep := 5;
  FIsDragging := False;
  FDragStartAngle := 0;
  FDragStartValue := 0;

  // Background parts
  FBackNormal := TONURCUSTOMCROP.Create('NORMAL');
  FBackHover := TONURCUSTOMCROP.Create('HOVER');
  FBackPressed := TONURCUSTOMCROP.Create('PRESSED');
  FBackDIsabled := TONURCUSTOMCROP.Create('DISABLED');

  // Pointer parts
  FPointerNormal := TONURCUSTOMCROP.Create('POINTERNORMAL');
  FPointerHover := TONURCUSTOMCROP.Create('POINTERHOVER');
  FPointerPressed := TONURCUSTOMCROP.Create('POINTERPRESSED');
  FPointerDIsabled := TONURCUSTOMCROP.Create('POINTERDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackNormal);
  CustomcroplIst.Add(FBackHover);
  CustomcroplIst.Add(FBackPressed);
  CustomcroplIst.Add(FBackDIsabled);
  CustomcroplIst.Add(FPointerNormal);
  CustomcroplIst.Add(FPointerHover);
  CustomcroplIst.Add(FPointerPressed);
  CustomcroplIst.Add(FPointerDIsabled);

  // Set default sIze
  Width := 80;
  Height := 80;
  SkInname := 'knob';

  UpdateLayout;
  UpdateAngles;
end;

destructor TONURKnob.Destroy;
begin
  inherited Destroy;
end;

procedure TONURKnob.SetMIn(Value: integer);
begin
  if FMin = Value then ExIt;
  FMin := Value;
  if FValue < FMin then SetValue(FMin);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURKnob.SetMax(Value: integer);
begin
  if FMax = Value then ExIt;
  FMax := Value;
  if FValue > FMax then SetValue(FMax);
  UpdateLayout;
  InvalIdate;
end;

procedure TONURKnob.SetValue(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  Value := SnapToStep(Value);
  if FValue = Value then ExIt;

  FValue := Value;
  InvalIdate;

  if AssIgned(FOnChange) then FOnChange(Self);
end;

procedure TONURKnob.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then ExIt;
  FStyle := Value;
  UpdateAngles;
  UpdateLayout;
  InvalIdate;
end;

procedure TONURKnob.SetShowScale(Value: boolean);
begin
  if FShowScale = Value then ExIt;
  FShowScale := Value;
  InvalIdate;
end;

procedure TONURKnob.SetScaleCount(Value: integer);
begin
  if FScaleCount = Value then ExIt;
  FScaleCount := EnsureRange(Value, 2, 50);
  InvalIdate;
end;

procedure TONURKnob.SetShowPointer(Value: boolean);
begin
  if FShowPointer = Value then ExIt;
  FShowPointer := Value;
  InvalIdate;
end;

procedure TONURKnob.SetPointerLength(Value: integer);
begin
  if FPointerLength = Value then ExIt;
  FPointerLength := EnsureRange(Value, 10, 100);
  InvalIdate;
end;

procedure TONURKnob.SetPointerColor(Value: TColor);
begin
  if FPointerColor = Value then ExIt;
  FPointerColor := Value;
  InvalIdate;
end;

procedure TONURKnob.SetStep(Value: integer);
begin
  if FStep = Value then ExIt;
  FStep := EnsureRange(Value, 1, FMax - FMin);
  SetValue(FValue);  // Re-snap to step
end;

procedure TONURKnob.SetScrollStep(Value: integer);
begin
  if FScrollStep = Value then ExIt;
  FScrollStep := EnsureRange(Value, 1, FMax - FMin);
end;

procedure TONURKnob.UpdateLayout;
begin
  // Center poInt
  FCenterX := Width div 2;
  FCenterY := Height div 2;

  // Radius
  if Width < Height then
    FRadius := (Width div 2) - 5
  else
    FRadius := (Height div 2) - 5;
end;

procedure TONURKnob.UpdateAngles;
begin
  case FStyle of
    osFull:
    begin
      FStartAngle := -135;  // Top left
      FEndAngle := 135;     // Top right
    end;
    osHalf:
    begin
      FStartAngle := -90;   // Left
      FEndAngle := 90;      // Right
    end;
    osQuarter:
    begin
      FStartAngle := 0;     // Top
      FEndAngle := 90;      // Right
    end;
  end;
end;

function TONURKnob.ValueToAngle(Value: integer): integer;
begin
  if FMax = FMin then
    Result := FStartAngle
  else
    Result := FStartAngle + Round((Value - FMin) / (FMax - FMin) *
      (FEndAngle - FStartAngle));
end;

function TONURKnob.AngleToValue(Angle: integer): integer;
begin
  if FEndAngle = FStartAngle then
    Result := FMin
  else
    Result := FMin + Round((Angle - FStartAngle) / (FEndAngle - FStartAngle) *
      (FMax - FMin));

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURKnob.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FValue - FMin) / (FMax - FMin) * 100);
end;

function TONURKnob.SnapToStep(Value: integer): integer;
begin
  if FStep <= 1 then
    Result := Value
  else
    Result := FMin + Round((Value - FMin) / FStep) * FStep;
end;

procedure TONURKnob.SetPercentage(Value: integer);
var
  NewValue: int64;
begin
  Value := EnsureRange(Value, 0, 100);
  NewValue := FMin + Round((FMax - FMin) * Value / 100);
  SetValue(NewValue);
end;

procedure TONURKnob.Paint;
var
  BackSrc, PointerSrc: TRect;
  Angle: integer;
  PointerEndX, PointerEndY: integer;
  I: integer;
  ScaleAngle: integer;
  ScaleX, ScaleY: integer;
  ScaleValue: integer;
  Texti: string;
  TextRect: Windows.RECT;
begin
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Background
    if not Enabled then
      BackSrc := FBackDIsabled.Croprect
    else
    begin
      case FState of
        obsNormal: BackSrc := FBackNormal.Croprect;
        obsHover: BackSrc := FBackHover.Croprect;
        obsPressed: BackSrc := FBackPressed.Croprect;
        else
          BackSrc := FBackNormal.Croprect;
      end;
    end;

    DrawPartnormal(BackSrc, Self, Rect(0, 0, Width, Height), Alpha);

    // Pointer
    if FShowPointer then
    begin
      if not Enabled then
        PointerSrc := FPointerDIsabled.Croprect
      else
      begin
        case FState of
          obsNormal: PointerSrc := FPointerNormal.Croprect;
          obsHover: PointerSrc := FPointerHover.Croprect;
          obsPressed: PointerSrc := FPointerPressed.Croprect;
          else
            PointerSrc := FPointerNormal.Croprect;
        end;
      end;

      Angle := ValueToAngle(FValue);
      PointerEndX := FCenterX + Round(FRadius * FPointerLength / 100 *
        Cos(DegToRad(Angle - 90)));
      PointerEndY := FCenterY + Round(FRadius * FPointerLength / 100 *
        Sin(DegToRad(Angle - 90)));

      // Draw pointer as a lIne
      resim.DrawLineAntialias(FCenterX, FCenterY, PointerEndX, PointerEndY,
        FPointerColor, 4);

      // Center dot
      resim.FillEllipseAntialias(FCenterX, FCenterY, 4, 4, FPointerColor);
    end;

    // Scale
    if FShowScale then
    begin
      resim.CanvasBGRA.Font.Color := BGRA(100, 100, 100, Alpha);
      resim.CanvasBGRA.Font.Height := 6;

      for I := 0 to FScaleCount - 1 do
      begin
        ScaleAngle := FStartAngle + Round(I * (FEndAngle - FStartAngle) /
          (FScaleCount - 1));
        ScaleX := FCenterX + Round((FRadius - 8) * Cos(DegToRad(ScaleAngle - 90)));
        ScaleY := FCenterY + Round((FRadius - 8) * Sin(DegToRad(ScaleAngle - 90)));

        // Draw scale mark
        resim.DrawLineAntialias(
          FCenterX + Round((FRadius - 3) * Cos(DegToRad(ScaleAngle - 90))),
          FCenterY + Round((FRadius - 3) * Sin(DegToRad(ScaleAngle - 90))),
          ScaleX, ScaleY, BGRA(100, 100, 100, Alpha), 1
          );

        // Draw value text
        ScaleValue := AngleToValue(ScaleAngle);
        Texti := IntToStr(ScaleValue);
        TextRect := Rect(ScaleX - 8, ScaleY - 8, ScaleX + 8, ScaleY + 8);
        yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, Texti, taCenter);
      end;
    end;
  end
  else
  begin
    // BASE RENKLI CIIZM - Skindata yoksa veya design time
    DrawBaseKnob;
  end;

  inherited Paint;
end;

procedure TONURKnob.DrawBaseKnob;
var
  Angle: integer;
  PointerEndX, PointerEndY: integer;
  I: integer;
  ScaleAngle: integer;
  ScaleX, ScaleY: integer;
  OuterColor, InnerColor, ScaleColor, PointerColore: TBGRAPixel;
  TextRect: Windows.RECT;
  ScaleValue: integer;
  Texti: string;
begin
  // Renkleri belirle
  if not Enabled then
  begin
    OuterColor := BGRA(180, 180, 180, Alpha);
    InnerColor := BGRA(220, 220, 220, Alpha);
    ScaleColor := BGRA(140, 140, 140, Alpha);
    PointerColore := BGRA(100, 100, 100, Alpha);
  end
  else
  begin
    OuterColor := BGRA(200, 200, 200, Alpha);
    InnerColor := BGRA(240, 240, 240, Alpha);
    ScaleColor := BGRA(100, 100, 100, Alpha);
    PointerColore := BGRA(255, 255, 255, Alpha);  // White pointer
  end;

  // Outer circle
  resim.FillEllipseAntialias(FCenterX, FCenterY, FRadius, FRadius, OuterColor);

  // Inner circle (knob face)
  resim.FillEllipseAntialias(FCenterX, FCenterY, FRadius - 5, FRadius - 5, InnerColor);

  // Add grAdIent effect
  if Enabled then
  begin
    resim.FillEllipseAntialias(FCenterX - FRadius div 3, FCenterY - FRadius div 3,
      FRadius div 3, FRadius div 3,
      BGRA(255, 255, 255, Alpha div 3));
  end;

  // Scale
  if FShowScale then
  begin
    for I := 0 to FScaleCount - 1 do
    begin
      ScaleAngle := FStartAngle + Round(I * (FEndAngle - FStartAngle) /
        (FScaleCount - 1));
      ScaleX := FCenterX + Round((FRadius - 8) * Cos(DegToRad(ScaleAngle - 90)));
      ScaleY := FCenterY + Round((FRadius - 8) * Sin(DegToRad(ScaleAngle - 90)));

      // Draw scale mark
      resim.DrawLineAntialias(
        FCenterX + Round((FRadius - 3) * Cos(DegToRad(ScaleAngle - 90))),
        FCenterY + Round((FRadius - 3) * Sin(DegToRad(ScaleAngle - 90))),
        ScaleX, ScaleY, ScaleColor, 2
        );

      // Draw value text
      ScaleValue := AngleToValue(ScaleAngle);
      Texti := IntToStr(ScaleValue);
      resim.CanvasBGRA.Font.Color := ScaleColor;
      resim.CanvasBGRA.Font.Height := 6;
      TextRect := Rect(ScaleX - 8, ScaleY - 8, ScaleX + 8, ScaleY + 8);
      yaziyazBGRA(resim.CanvasBGRA, Font, TextRect, Texti, taCenter);
    end;
  end;

  // Pointer
  if FShowPointer then
  begin
    Angle := ValueToAngle(FValue);
    PointerEndX := FCenterX + Round(FRadius * FPointerLength / 100 *
      Cos(DegToRad(Angle - 90)));
    PointerEndY := FCenterY + Round(FRadius * FPointerLength / 100 *
      Sin(DegToRad(Angle - 90)));

    // Draw pointer
    resim.DrawLineAntialias(FCenterX, FCenterY, PointerEndX, PointerEndY,
      PointerColore, 5);

    // Center dot
    resim.FillEllipseAntialias(FCenterX, FCenterY, 5, 5, PointerColore);

    // Glossy effect on center
    if Enabled then
      resim.FillEllipseAntialias(FCenterX - 2, FCenterY - 2, 3, 3,
        BGRA(255, 255, 255, Alpha div 2));
  end;
end;

procedure TONURKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  DX: integer;
  DY: integer;
begin
  if not Enabled then Exit;

  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FState := obsPressed;
    FIsDragging := True;

    // Calculate start angle from mouse posItIon
    DX := X - FCenterX;
    DY := Y - FCenterY;
    FDragStartAngle := Round(RadToDeg(ArcTan2(DY, DX))) + 90;
    FDragStartValue := FValue;

    Invalidate;
  end;
end;

procedure TONURKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not Enabled then Exit;

  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FState := obsNormal;
    FIsDragging := False;
    Invalidate;
  end;
end;

procedure TONURKnob.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewState: TONURState;
  DeltaAngle: integer;
  NewValue: integer;
  DX: integer;
  DY: integer;
  CurrentAngle: int64;
  DIstance: ValReal;
begin
  if not Enabled then Exit;

  inherited MouseMove(Shift, X, Y);

  if FIsDragging then
  begin
    // Calculate angle change
    DX := X - FCenterX;
    DY := Y - FCenterY;
    CurrentAngle := Round(RadToDeg(ArcTan2(DY, DX))) + 90;

    DeltaAngle := CurrentAngle - FDragStartAngle;

    // Handle angle wrap around
    if DeltaAngle > 180 then DeltaAngle := DeltaAngle - 360;
    if DeltaAngle < -180 then DeltaAngle := DeltaAngle + 360;

    // Convert angle to value
    NewValue := FDragStartValue + Round(DeltaAngle * (FMax - FMin) /
      (FEndAngle - FStartAngle));
    SetValue(NewValue);
  end
  else
  begin
    // Check if mouse is over knob
    DX := X - FCenterX;
    DY := Y - FCenterY;
    DIstance := Sqrt(DX * DX + DY * DY);

    if DIstance <= FRadius then
      NewState := obsHover
    else
      NewState := obsNormal;

    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURKnob.MouseEnter;
begin
  inherited MouseEnter;

  if not (ssLeft in GetKeyShiftState) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURKnob.MouseLeave;
begin
  inherited MouseLeave;

  if not (ssLeft in GetKeyShiftState) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURKnob.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

function TONURKnob.DoMouseWheel(ShIft: TShIftState; WheelDelta: integer;
  MousePos: TPoInt): boolean;
var
  ClientPos: TPoint;
  DX: integer;
  DY: integer;
  DIstance: ValReal;
begin
  Result := False;
  if not Enabled then Exit;

  inherited;

  // Check if mouse is over knob
  ClientPos := ScreenToClient(MousePos);
  DX := ClientPos.X - FCenterX;
  DY := ClientPos.Y - FCenterY;
  DIstance := Sqrt(DX * DX + DY * DY);

  if DIstance <= FRadius then
  begin
    if WheelDelta > 0 then
      SetValue(FValue + FScrollStep)
    else
      SetValue(FValue - FScrollStep);

    Result := True;
  end;
end;



{ TONURSliderBar }

constructor TONURSliderBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize basic properties
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FStyle := osModern;
  FState := obsNormal;
  FOrientation := oroHorizontal;
  FAnimated := True;
  FAnimationSpeed := 0.1;
  FTargetValue := 0;
  FIsDragging := False;
  FDragStartPos := 0;
  FDragStartValue := 0;

  // Initialize visual properties
  FShowValue := True;
  FShowTicks := True;
  FTickCount := 10;
  FThumbSize := 20;
  FTrackHeight := 6;

  // Create skin parts
  FTrackNormal := TONURCUSTOMCROP.Create('TRACKNORMAL');
  FTrackHover := TONURCUSTOMCROP.Create('TRACKHOVER');
  FTrackPressed := TONURCUSTOMCROP.Create('TRACKPRESSED');
  FTrackDisabled := TONURCUSTOMCROP.Create('TRACKDISABLED');

  FThumbNormal := TONURCUSTOMCROP.Create('THUMBNORMAL');
  FThumbHover := TONURCUSTOMCROP.Create('THUMBHOVER');
  FThumbPressed := TONURCUSTOMCROP.Create('THUMBPRESSED');
  FThumbDisabled := TONURCUSTOMCROP.Create('THUMBDISABLED');

  // Add to custom crop list
  CustomcroplIst.Add(FTrackNormal);
  CustomcroplIst.Add(FTrackHover);
  CustomcroplIst.Add(FTrackPressed);
  CustomcroplIst.Add(FTrackDisabled);
  CustomcroplIst.Add(FThumbNormal);
  CustomcroplIst.Add(FThumbHover);
  CustomcroplIst.Add(FThumbPressed);
  CustomcroplIst.Add(FThumbDisabled);

  // Set default size and skin
  Width := 200;
  Height := 30;
  Skinname := 'sliderbarh';

  UpdateLayout;
end;

destructor TONURSliderBar.Destroy;
begin
  if Assigned(FAnimationTimer) then
  begin
    FAnimationTimer.Enabled := False;
    FreeAndNil(FAnimationTimer);
  end;

  inherited Destroy;
end;

// Property setters
procedure TONURSliderBar.SetMin(Value: integer);
begin
  if FMin = Value then Exit;
  FMin := Value;
  if FValue < FMin then SetValue(FMin);
  if FMax < FMin then SetMax(FMin);
  UpdateLayout;
  Invalidate;
end;

procedure TONURSliderBar.SetMax(Value: integer);
begin
  if FMax = Value then Exit;
  FMax := Value;
  if FValue > FMax then SetValue(FMax);
  if FMin > FMax then SetMin(FMax);
  UpdateLayout;
  Invalidate;
end;

procedure TONURSliderBar.SetValue(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FValue = Value then Exit;

  if FAnimated and not (csDesigning in ComponentState) then
  begin
    FTargetValue := Value;
    StartAnimation;
  end
  else
  begin
    FValue := Value;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TONURSliderBar.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then Exit;
  FStyle := Value;
  Invalidate;
end;

procedure TONURSliderBar.SetOrientation(Value: TONUROrientation);
var
  Temp: integer;
begin
  if FOrientation = Value then Exit;
  FOrientation := Value;

  // Swap width/height for orientation change
  if FOrientation = oroHorizontal then
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    Skinname := 'sliderbarh';
  end
  else
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    Skinname := 'sliderbarv';
  end;

  UpdateLayout;
  Invalidate;
end;

procedure TONURSliderBar.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURSliderBar.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

procedure TONURSliderBar.SetShowValue(Value: boolean);
begin
  if FShowValue = Value then Exit;
  FShowValue := Value;
  Invalidate;
end;

procedure TONURSliderBar.SetShowTicks(Value: boolean);
begin
  if FShowTicks = Value then Exit;
  FShowTicks := Value;
  Invalidate;
end;

procedure TONURSliderBar.SetTickCount(Value: integer);
begin
  if FTickCount = Value then Exit;
  FTickCount := Value;
  Invalidate;
end;

procedure TONURSliderBar.SetThumbSize(Value: integer);
begin
  if FThumbSize = Value then Exit;
  FThumbSize := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURSliderBar.SetTrackHeight(Value: integer);
begin
  if FTrackHeight = Value then Exit;
  FTrackHeight := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURSliderBar.SetPercentage(Value: integer);
begin
  SetValue(FMin + Round(Value / 100 * (FMax - FMin)));
end;

// Animation methods
procedure TONURSliderBar.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 16; // 60 FPS
    FAnimationTimer.OnTimer := @DoAnimationTimer;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURSliderBar.StopAnimation;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURSliderBar.DoAnimationTimer(Sender: TObject);
var
  Diff: integer;
  Step: real;
begin
  Diff := FTargetValue - FValue;

  if Abs(Diff) < 1 then
  begin
    FValue := FTargetValue;
    StopAnimation;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end
  else
  begin
    Step := Diff * FAnimationSpeed;
    FValue := FValue + Round(Step);
    UpdateThumbRect;
    Invalidate;
  end;
end;

// Layout methods
procedure TONURSliderBar.UpdateLayout;
begin
  // Calculate track rectangle
  if FOrientation = oroHorizontal then
  begin
    FTrackRect := Rect(FThumbSize div 2, Height div 2 - FTrackHeight div 2,
      Width - FThumbSize div 2, Height div 2 + FTrackHeight div 2);
  end
  else
  begin
    FTrackRect := Rect(Width div 2 - FTrackHeight div 2, FThumbSize div
      2, Width div 2 + FTrackHeight div 2, Height - FThumbSize div 2);
  end;

  UpdateThumbRect;
end;

procedure TONURSliderBar.UpdateThumbRect;
var
  Position: integer;
  TrackSize: integer;
begin
  if FOrientation = oroHorizontal then
  begin
    TrackSize := FTrackRect.Right - FTrackRect.Left;
    Position := FTrackRect.Left + Round((FValue - FMin) / (FMax - FMin) * TrackSize);

    FThumbRect := Rect(Position - FThumbSize div 2, Height div 2 -
      FThumbSize div 2, Position + FThumbSize div 2,
      Height div 2 + FThumbSize div 2);
  end
  else
  begin
    TrackSize := FTrackRect.Bottom - FTrackRect.Top;
    Position := FTrackRect.Top + Round((FValue - FMin) / (FMax - FMin) * TrackSize);

    FThumbRect := Rect(Width div 2 - FThumbSize div 2, Position -
      FThumbSize div 2, Width div 2 + FThumbSize div
      2, Position + FThumbSize div 2);
  end;
end;

// Drawing methods
procedure TONURSliderBar.DrawBaseSliderBar;
var
  I: integer;
  TickPos: integer;
  TextRect: TRect;
  TextStr: string;
  TrackColor, ThumbColor: TColor;
begin
  // Set colors based on state
  if Enabled then
  begin
    if FState = obsHover then
    begin
      TrackColor := $00D0D0D0; // Light gray
      ThumbColor := $00A0A0A0; // Medium gray
    end
    else
    begin
      TrackColor := $00E0E0E0; // Lighter gray
      ThumbColor := $00909090; // Darker gray
    end;
  end
  else
  begin
    TrackColor := $00F0F0F0; // Very light gray
    ThumbColor := $00C0C0C0; // Disabled gray
  end;

  // Draw track
  Canvas.Brush.Color := TrackColor;
  Canvas.Pen.Color := $00808080; // Border color
  Canvas.RoundRect(FTrackRect, 3, 3);

  // Draw ticks
  if FShowTicks and (FTickCount > 0) then
  begin
    Canvas.Pen.Color := $00606060;
    Canvas.Pen.Width := 1;

    for I := 0 to FTickCount do
    begin
      if FOrientation = oroHorizontal then
      begin
        TickPos := FTrackRect.Left + Round(I / FTickCount *
          (FTrackRect.Right - FTrackRect.Left));
        Canvas.MoveTo(TickPos, FTrackRect.Top - 2);
        Canvas.LineTo(TickPos, FTrackRect.Top);
        Canvas.MoveTo(TickPos, FTrackRect.Bottom);
        Canvas.LineTo(TickPos, FTrackRect.Bottom + 2);
      end
      else
      begin
        TickPos := FTrackRect.Top + Round(I / FTickCount *
          (FTrackRect.Bottom - FTrackRect.Top));
        Canvas.MoveTo(FTrackRect.Left - 2, TickPos);
        Canvas.LineTo(FTrackRect.Left, TickPos);
        Canvas.MoveTo(FTrackRect.Right, TickPos);
        Canvas.LineTo(FTrackRect.Right + 2, TickPos);
      end;
    end;
  end;

  // Draw thumb
  Canvas.Brush.Color := ThumbColor;
  Canvas.Pen.Color := $00404040; // Dark border
  Canvas.RoundRect(FThumbRect, 5, 5);

  // Add thumb highlight effect
  if Enabled then
  begin
    Canvas.Brush.Color := $00FFFFFF; // White highlight
    Canvas.Pen.Color := $00FFFFFF;
    Canvas.RoundRect(
      Rect(FThumbRect.Left + 2, FThumbRect.Top + 2, FThumbRect.Left +
      8, FThumbRect.Top + 8), 3, 3);
  end;

  // Draw value text
  if FShowValue then
  begin
    TextStr := IntToStr(FValue);
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURSliderBar.Paint;
begin
  inherited Paint;

  // Clear background
  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  // Check if skin data is assigned
  if Assigned(Skindata) and Assigned(Skindata.Fimage) then
  begin
    // Use skins if available
    DrawWithSkins;
  end
  else
  begin
    // Use basic drawing if no skins
    DrawBaseSliderBar;
  end;
end;

procedure TONURSliderBar.DrawWithSkins;
var
  I: integer;
  TickPos: integer;
  TextRect: TRect;
  TextStr: string;
begin
  // Draw track with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FTrackHover)
    else
      BGRAReplaceCustomCrops(Canvas, FTrackNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FTrackDisabled);
  end;

  // Draw ticks
  if FShowTicks and (FTickCount > 0) then
  begin
    Canvas.Pen.Color := clGray;
    Canvas.Pen.Width := 1;

    for I := 0 to FTickCount do
    begin
      if FOrientation = oroHorizontal then
      begin
        TickPos := FTrackRect.Left + Round(I / FTickCount *
          (FTrackRect.Right - FTrackRect.Left));
        Canvas.MoveTo(TickPos, FTrackRect.Top - 2);
        Canvas.LineTo(TickPos, FTrackRect.Top);
        Canvas.MoveTo(TickPos, FTrackRect.Bottom);
        Canvas.LineTo(TickPos, FTrackRect.Bottom + 2);
      end
      else
      begin
        TickPos := FTrackRect.Top + Round(I / FTickCount *
          (FTrackRect.Bottom - FTrackRect.Top));
        Canvas.MoveTo(FTrackRect.Left - 2, TickPos);
        Canvas.LineTo(FTrackRect.Left, TickPos);
        Canvas.MoveTo(FTrackRect.Right, TickPos);
        Canvas.LineTo(FTrackRect.Right + 2, TickPos);
      end;
    end;
  end;

  // Draw thumb with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FThumbHover)
    else if FState = obsPressed then
      BGRAReplaceCustomCrops(Canvas, FThumbPressed)
    else
      BGRAReplaceCustomCrops(Canvas, FThumbNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FThumbDisabled);
  end;

  // Draw value text
  if FShowValue then
  begin
    TextStr := IntToStr(FValue);
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

// Helper functions
function TONURSliderBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FValue - FMin) / (FMax - FMin) * 100);
end;

function TONURSliderBar.PositionFromPoint(X, Y: integer): integer;
var
  Position: integer;
  TrackSize: integer;
begin
  if FOrientation = oroHorizontal then
  begin
    Position := X - FTrackRect.Left;
    TrackSize := FTrackRect.Right - FTrackRect.Left;
  end
  else
  begin
    Position := Y - FTrackRect.Top;
    TrackSize := FTrackRect.Bottom - FTrackRect.Top;
  end;

  if TrackSize > 0 then
    Result := FMin + Round(Position / TrackSize * (FMax - FMin))
  else
    Result := FMin;

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURSliderBar.PointInThumb(X, Y: integer): boolean;
begin
  Result := PtInRect(FThumbRect, Point(X, Y));
end;

// Mouse event handlers
procedure TONURSliderBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not Enabled then Exit;

  FState := obsPressed;

  if PointInThumb(X, Y) then
  begin
    FIsDragging := True;
    if FOrientation = oroHorizontal then
      FDragStartPos := X
    else
      FDragStartPos := Y;
    FDragStartValue := FValue;
  end
  else
  begin
    SetValue(PositionFromPoint(X, Y));
  end;

  Invalidate;
end;

procedure TONURSliderBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  FIsDragging := False;

  if Enabled then
    FState := obsNormal
  else
    FState := obsDisabled;

  Invalidate;
end;

procedure TONURSliderBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewValue: integer;
  NewState: TONURState;
begin
  inherited MouseMove(Shift, X, Y);

  if not Enabled then Exit;

  if FIsDragging then
  begin
    if FOrientation = oroHorizontal then
      NewValue := FDragStartValue + (X - FDragStartPos)
    else
      NewValue := FDragStartValue + (Y - FDragStartPos);
    SetValue(NewValue);
  end
  else
  begin
    if PointInThumb(X, Y) then
      NewState := obsHover
    else
      NewState := obsNormal;

    if FState <> NewState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURSliderBar.MouseEnter;
begin
  inherited MouseEnter;

  if Enabled and (FState = obsNormal) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURSliderBar.MouseLeave;
begin
  inherited MouseLeave;

  if Enabled and (FState = obsHover) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURSliderBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

{ TONURSwitchBar }

constructor TONURSwitchBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FChecked := False;
  FState := obsNormal;
  FShowText := True;
  FTextOn := 'ON';
  FTextOff := 'OFF';
  FAnimated := True;
  FAnimationProgress := 0;
  FAnimationSpeed := 0.1;
  FIsDragging := False;

  FThumbRect := Rect(0, 0, 0, 0);
  FTrackRect := Rect(0, 0, 0, 0);

  FTrackNormal := TONURCUSTOMCROP.Create('TRACKNORMAL');
  FTrackHover := TONURCUSTOMCROP.Create('TRACKHOVER');
  FTrackPressed := TONURCUSTOMCROP.Create('TRACKPRESSED');
  FTrackDisabled := TONURCUSTOMCROP.Create('TRACKDISABLED');

  FThumbOnNormal := TONURCUSTOMCROP.Create('THUMBONNORMAL');
  FThumbOnHover := TONURCUSTOMCROP.Create('THUMBONHOVER');
  FThumbOnPressed := TONURCUSTOMCROP.Create('THUMBONPRESSED');
  FThumbOnDisabled := TONURCUSTOMCROP.Create('THUMBONDISABLED');

  FThumbOffNormal := TONURCUSTOMCROP.Create('THUMBOFFNORMAL');
  FThumbOffHover := TONURCUSTOMCROP.Create('THUMBOFFHOVER');
  FThumbOffPressed := TONURCUSTOMCROP.Create('THUMBOFFPRESSED');
  FThumbOffDisabled := TONURCUSTOMCROP.Create('THUMBOFFDISABLED');

  Customcroplist.Add(FTrackNormal);
  Customcroplist.Add(FTrackHover);
  Customcroplist.Add(FTrackPressed);
  Customcroplist.Add(FTrackDisabled);
  Customcroplist.Add(FThumbOnNormal);
  Customcroplist.Add(FThumbOnHover);
  Customcroplist.Add(FThumbOnPressed);
  Customcroplist.Add(FThumbOnDisabled);
  Customcroplist.Add(FThumbOffNormal);
  Customcroplist.Add(FThumbOffHover);
  Customcroplist.Add(FThumbOffPressed);
  Customcroplist.Add(FThumbOffDisabled);

  Width := 60;
  Height := 30;
  Skinname := 'switchbar';

  UpdateLayout;
end;

destructor TONURSwitchBar.Destroy;
begin
  if Assigned(FAnimationTimer) then
  begin
    FAnimationTimer.Enabled := False;
    FreeAndNil(FAnimationTimer);
  end;

  inherited Destroy;
end;

procedure TONURSwitchBar.SetChecked(Value: boolean);
begin
  if FChecked = Value then Exit;

  if FAnimated and not (csDesigning in ComponentState) then
  begin
    FAnimationProgress := 0;
    StartAnimation;
  end
  else
  begin
    FChecked := Value;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TONURSwitchBar.SetShowText(Value: boolean);
begin
  if FShowText = Value then Exit;
  FShowText := Value;
  Invalidate;
end;

procedure TONURSwitchBar.SetTextOn(Value: string);
begin
  if FTextOn = Value then Exit;
  FTextOn := Value;
  Invalidate;
end;

procedure TONURSwitchBar.SetTextOff(Value: string);
begin
  if FTextOff = Value then Exit;
  FTextOff := Value;
  Invalidate;
end;

procedure TONURSwitchBar.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURSwitchBar.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

procedure TONURSwitchBar.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 16; // 60 FPS
    FAnimationTimer.OnTimer := @DoAnimation;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURSwitchBar.StopAnimation;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURSwitchBar.DoAnimation(Sender: TObject);
var
  TargetProgress: real;
  Diff: real;
  Step: real;
begin
  if FChecked then
    TargetProgress := 1.0
  else
    TargetProgress := 0.0;
  Diff := TargetProgress - FAnimationProgress;

  if Abs(Diff) < 0.01 then
  begin
    FAnimationProgress := TargetProgress;
    StopAnimation;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end
  else
  begin
    Step := Diff * FAnimationSpeed;
    FAnimationProgress := FAnimationProgress + Step;
    UpdateThumbRect;
    Invalidate;
  end;
end;

procedure TONURSwitchBar.UpdateLayout;
begin
  FTrackRect := Rect(5, Height div 2 - 8, Width - 5, Height div 2 + 8);

  UpdateThumbRect;
end;

procedure TONURSwitchBar.UpdateThumbRect;
var
  ThumbX: integer;
  ThumbWidth: integer;
  ThumbHeight: integer;
  CurrentPos: real;
begin
  ThumbWidth := 24;
  ThumbHeight := 20;

  if FAnimated then
    CurrentPos := FAnimationProgress
  else
  begin
    if FChecked then
      CurrentPos := 1.0
    else
      CurrentPos := 0.0;
  end;

  ThumbX := Round(5 + CurrentPos * (Width - 10 - ThumbWidth));

  FThumbRect := Rect(ThumbX, Height div 2 - ThumbHeight div 2,
    ThumbX + ThumbWidth, Height div 2 + ThumbHeight div 2);
end;

procedure TONURSwitchBar.DrawBaseSwitchBar;
var
  TextRect: TRect;
  TextStr: string;
  TrackColor, ThumbColor: TColor;
begin
  if Enabled then
  begin
    if FState = obsHover then
      TrackColor := $00D0D0D0
    else
      TrackColor := $00E0E0E0;
  end
  else
    TrackColor := $00F0F0F0;

  if Enabled then
  begin
    if FState = obsHover then
      ThumbColor := $00A0A0A0
    else
      ThumbColor := $00909090;
  end
  else
    ThumbColor := $00C0C0C0;

  Canvas.Brush.Color := TrackColor;
  Canvas.Pen.Color := $00808080;
  Canvas.RoundRect(FTrackRect, 8, 8);

  Canvas.Brush.Color := ThumbColor;
  Canvas.Pen.Color := $00404040;
  Canvas.RoundRect(FThumbRect, 5, 5);

  if Enabled then
  begin
    Canvas.Brush.Color := $00FFFFFF; // White highlight
    Canvas.Pen.Color := $00FFFFFF;
    Canvas.RoundRect(
      Rect(FThumbRect.Left + 2, FThumbRect.Top + 2, FThumbRect.Left +
      8, FThumbRect.Top + 8), 3, 3);
  end;

  if FShowText then
  begin
    if FChecked then
      TextStr := FTextOn
    else
      TextStr := FTextOff;
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Size := 8;
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURSwitchBar.DrawWithSkins;
var
  TextRect: TRect;
  TextStr: string;
begin
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FTrackHover)
    else
      BGRAReplaceCustomCrops(Canvas, FTrackNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FTrackDisabled);
  end;

  if Enabled then
  begin
    if FState = obsHover then
    begin
      if FChecked then
        BGRAReplaceCustomCrops(Canvas, FThumbOnHover)
      else
        BGRAReplaceCustomCrops(Canvas, FThumbOffHover);
    end
    else if FState = obsPressed then
    begin
      if FChecked then
        BGRAReplaceCustomCrops(Canvas, FThumbOnPressed)
      else
        BGRAReplaceCustomCrops(Canvas, FThumbOffPressed);
    end
    else
    begin
      if FChecked then
        BGRAReplaceCustomCrops(Canvas, FThumbOnNormal)
      else
        BGRAReplaceCustomCrops(Canvas, FThumbOffNormal);
    end;
  end
  else
  begin
    if FChecked then
      BGRAReplaceCustomCrops(Canvas, FThumbOnDisabled)
    else
      BGRAReplaceCustomCrops(Canvas, FThumbOffDisabled);
  end;

  if FShowText then
  begin
    if FChecked then
      TextStr := FTextOn
    else
      TextStr := FTextOff;
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Size := 8;
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURSwitchBar.Paint;
begin
  inherited Paint;

  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  if Assigned(Skindata) and Assigned(Skindata.Fimage) then
  begin
    DrawWithSkins;
  end
  else
  begin
    DrawBaseSwitchBar;
  end;
end;

function TONURSwitchBar.PointInThumb(X, Y: integer): boolean;
begin
  Result := PtInRect(FThumbRect, Point(X, Y));
end;

function TONURSwitchBar.PointInTrack(X, Y: integer): boolean;
begin
  Result := PtInRect(FTrackRect, Point(X, Y));
end;

procedure TONURSwitchBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not Enabled then Exit;

  FState := obsPressed;
  FIsDragging := PointInThumb(X, Y);

  if PointInTrack(X, Y) then
    SetChecked(not FChecked);

  Invalidate;
end;

procedure TONURSwitchBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  FIsDragging := False;

  if Enabled then
    FState := obsNormal
  else
    FState := obsDisabled;

  Invalidate;
end;

procedure TONURSwitchBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  InThumb: boolean;
  NewState: TONURState;
  CenterX: longint;
begin
  inherited MouseMove(Shift, X, Y);

  if not Enabled then Exit;

  if FIsDragging then
  begin
    CenterX := FTrackRect.Left + (FTrackRect.Right - FTrackRect.Left) div 2;
    SetChecked(X > CenterX);
  end
  else
  begin
    InThumb := PointInThumb(X, Y);

    if InThumb then
      NewState := obsHover
    else
      NewState := obsNormal;

    if FState <> NewState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TONURSwitchBar.MouseEnter;
begin
  inherited MouseEnter;

  if Enabled and (FState = obsNormal) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURSwitchBar.MouseLeave;
begin
  inherited MouseLeave;

  if Enabled and (FState = obsHover) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURSwitchBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

procedure TONURSwitchBar.Toggle;
begin
  SetChecked(not FChecked);
end;

procedure TONURSwitchBar.TurnOn;
begin
  SetChecked(True);
end;

procedure TONURSwitchBar.TurnOff;
begin
  SetChecked(False);
end;

{ TONURTimeBar }

constructor TONURTimeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize basic properties
  FMode := tbmClock;
  FState := obsNormal;
  FCurrentTime := Now;
  FTargetTime := Now + 1; // 1 hour later
  FStartTime := Now;
  FEndTime := Now + 1;
  FShowSeconds := True;
  FShowDate := False;
  FShowLabels := True;
  FShowMarkers := True;
  FMarkerCount := 10;
  FAnimated := True;
  FAnimationSpeed := 0.1;

  // Initialize rectangles
  FTrackRect := Rect(0, 0, 0, 0);
  FThumbRect := Rect(0, 0, 0, 0);

  // Create skin parts
  FTrackNormal := TONURCUSTOMCROP.Create('TRACKNORMAL');
  FTrackHover := TONURCUSTOMCROP.Create('TRACKHOVER');
  FTrackPressed := TONURCUSTOMCROP.Create('TRACKPRESSED');
  FTrackDisabled := TONURCUSTOMCROP.Create('TRACKDISABLED');

  FThumbNormal := TONURCUSTOMCROP.Create('THUMBNORMAL');
  FThumbHover := TONURCUSTOMCROP.Create('THUMBHOVER');
  FThumbPressed := TONURCUSTOMCROP.Create('THUMBPRESSED');
  FThumbDisabled := TONURCUSTOMCROP.Create('THUMBDISABLED');

  FMarkerNormal := TONURCUSTOMCROP.Create('MARKERNORMAL');
  FMarkerHover := TONURCUSTOMCROP.Create('MARKERHOVER');
  FMarkerPressed := TONURCUSTOMCROP.Create('MARKERPRESSED');
  FMarkerDisabled := TONURCUSTOMCROP.Create('MARKERDISABLED');

  // Add to custom crop list
  Customcroplist.Add(FTrackNormal);
  Customcroplist.Add(FTrackHover);
  Customcroplist.Add(FTrackPressed);
  Customcroplist.Add(FTrackDisabled);
  Customcroplist.Add(FThumbNormal);
  Customcroplist.Add(FThumbHover);
  Customcroplist.Add(FThumbPressed);
  Customcroplist.Add(FThumbDisabled);
  Customcroplist.Add(FMarkerNormal);
  Customcroplist.Add(FMarkerHover);
  Customcroplist.Add(FMarkerPressed);
  Customcroplist.Add(FMarkerDisabled);

  // Set default size
  Width := 300;
  Height := 40;
  Skinname := 'timebar';

  UpdateLayout;
end;

destructor TONURTimeBar.Destroy;
begin
  if Assigned(FAnimationTimer) then
  begin
    FAnimationTimer.Enabled := False;
    FreeAndNil(FAnimationTimer);
  end;

  inherited Destroy;
end;

// Property setters
procedure TONURTimeBar.SetMode(Value: TONURTimeBarMode);
begin
  if FMode = Value then Exit;
  FMode := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetCurrentTime(Value: TDateTime);
begin
  Value := EnsureRange(Value, FStartTime, FEndTime);
  if FCurrentTime = Value then Exit;

  if FAnimated and not (csDesigning in ComponentState) then
  begin
    FTargetTime := Value;
    StartAnimation;
  end
  else
  begin
    FCurrentTime := Value;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnTimeChange) then FOnTimeChange(Self);
  end;
end;

procedure TONURTimeBar.SetTargetTime(Value: TDateTime);
begin
  if FTargetTime = Value then Exit;
  FTargetTime := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURTimeBar.SetStartTime(Value: TDateTime);
begin
  if FStartTime = Value then Exit;
  FStartTime := Value;
  if FCurrentTime < FStartTime then SetCurrentTime(FStartTime);
  if FEndTime < FStartTime then SetEndTime(FStartTime);
  UpdateLayout;
  Invalidate;
end;

procedure TONURTimeBar.SetEndTime(Value: TDateTime);
begin
  if FEndTime = Value then Exit;
  FEndTime := Value;
  if FCurrentTime > FEndTime then SetCurrentTime(FEndTime);
  if FStartTime > FEndTime then SetStartTime(FEndTime);
  UpdateLayout;
  Invalidate;
end;

procedure TONURTimeBar.SetShowSeconds(Value: boolean);
begin
  if FShowSeconds = Value then Exit;
  FShowSeconds := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetShowDate(Value: boolean);
begin
  if FShowDate = Value then Exit;
  FShowDate := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetShowLabels(Value: boolean);
begin
  if FShowLabels = Value then Exit;
  FShowLabels := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetShowMarkers(Value: boolean);
begin
  if FShowMarkers = Value then Exit;
  FShowMarkers := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetMarkerCount(Value: integer);
begin
  if FMarkerCount = Value then Exit;
  FMarkerCount := Value;
  Invalidate;
end;

procedure TONURTimeBar.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURTimeBar.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

// Animation methods
procedure TONURTimeBar.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 16; // 60 FPS
    FAnimationTimer.OnTimer := @DoAnimation;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURTimeBar.StopAnimation;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURTimeBar.DoAnimation(Sender: TObject);
var
  TargetProgress: real;
  CurrentProgress: real;
  Diff: real;
  Step: real;
begin
  TargetProgress := (FTargetTime - FStartTime) / (FEndTime - FStartTime);
  CurrentProgress := (FCurrentTime - FStartTime) / (FEndTime - FStartTime);
  Diff := TargetProgress - CurrentProgress;

  if Abs(Diff) < 0.001 then
  begin
    FCurrentTime := FTargetTime;
    StopAnimation;
    UpdateThumbRect;
    Invalidate;

    if Assigned(FOnTimeChange) then FOnTimeChange(Self);
  end
  else
  begin
    Step := Diff * FAnimationSpeed;
    FCurrentTime := FCurrentTime + (Step * (FEndTime - FStartTime));
    UpdateThumbRect;
    Invalidate;
  end;
end;

procedure TONURTimeBar.DoTimer(Sender: TObject);
begin
  case FMode of
    tbmClock:
    begin
      FCurrentTime := Now;
      UpdateThumbRect;
      Invalidate;

      if Assigned(FOnTimeChange) then FOnTimeChange(Self);
    end;

    tbmCountdown:
    begin
      if FCurrentTime > FStartTime then
      begin
        FCurrentTime := FCurrentTime - (1 / 86400); // 1 second
        UpdateThumbRect;
        Invalidate;

        if Assigned(FOnTimeChange) then FOnTimeChange(Self);
      end
      else
      begin
        Stop;
      end;
    end;

    tbmStopwatch:
    begin
      if FCurrentTime < FEndTime then
      begin
        FCurrentTime := FCurrentTime + (1 / 86400); // 1 second
        UpdateThumbRect;
        Invalidate;

        if Assigned(FOnTimeChange) then FOnTimeChange(Self);
      end
      else
      begin
        Stop;
      end;
    end;
  end;
end;

// Layout methods
procedure TONURTimeBar.UpdateLayout;
begin
  // Track rect
  FTrackRect := Rect(20, Height div 2 - 4, Width - 20, Height div 2 + 4);

  UpdateThumbRect;
end;

procedure TONURTimeBar.UpdateThumbRect;
var
  Position: real;
  TrackSize: integer;
  ThumbSize: integer;
  ThumbX: integer;
begin
  TrackSize := FTrackRect.Right - FTrackRect.Left;
  ThumbSize := 16;

  Position := GetPercentage / 100.0;
  ThumbX := FTrackRect.Left + Round(Position * (TrackSize - ThumbSize));

  FThumbRect := Rect(ThumbX, Height div 2 - ThumbSize div 2,
    ThumbX + ThumbSize, Height div 2 + ThumbSize div 2);
end;

// Drawing methods
procedure TONURTimeBar.DrawBaseTimeBar;
var
  I: integer;
  MarkerPos: integer;
  TextRect: TRect;
  TextStr: string;
  TrackColor, ThumbColor, MarkerColor: TColor;
begin
  // Set colors based on state
  if Enabled then
  begin
    if FState = obsHover then
      TrackColor := $00D0D0D0
    else
      TrackColor := $00E0E0E0;
  end
  else
    TrackColor := $00F0F0F0;

  if Enabled then
  begin
    if FState = obsHover then
      ThumbColor := $00A0A0A0
    else
      ThumbColor := $00909090;
  end
  else
    ThumbColor := $00C0C0C0;

  MarkerColor := $00606060;

  // Draw track
  Canvas.Brush.Color := TrackColor;
  Canvas.Pen.Color := $00808080;
  Canvas.RoundRect(FTrackRect, 4, 4);

  // Draw thumb
  Canvas.Brush.Color := ThumbColor;
  Canvas.Pen.Color := $00404040;
  Canvas.RoundRect(FThumbRect, 3, 3);

  // Draw markers
  if FShowMarkers and (FMarkerCount > 0) then
  begin
    Canvas.Pen.Color := MarkerColor;
    Canvas.Pen.Width := 1;

    for I := 0 to FMarkerCount do
    begin
      MarkerPos := FTrackRect.Left + Round(I / FMarkerCount *
        (FTrackRect.Right - FTrackRect.Left));
      Canvas.MoveTo(MarkerPos, FTrackRect.Top - 2);
      Canvas.LineTo(MarkerPos, FTrackRect.Top);
      Canvas.MoveTo(MarkerPos, FTrackRect.Bottom);
      Canvas.LineTo(MarkerPos, FTrackRect.Bottom + 2);
    end;
  end;

  // Draw labels
  if FShowLabels then
  begin
    // Start time label
    TextStr := FormatDateTime('hh:nn', FStartTime);
    TextRect := Rect(FTrackRect.Left - 30, FTrackRect.Top - 20,
      FTrackRect.Left, FTrackRect.Top);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Size := 8;
    Canvas.TextRect(TextRect, 0, 0, TextStr);

    // End time label
    TextStr := FormatDateTime('hh:nn', FEndTime);
    TextRect := Rect(FTrackRect.Right, FTrackRect.Top - 20,
      FTrackRect.Right + 30, FTrackRect.Top);
    Canvas.TextRect(TextRect, 0, 0, TextStr);

    // Current time label
    TextStr := GetDisplayTime;
    TextRect := Rect(0, 0, Width, FTrackRect.Top - 5);
    Canvas.Font.Style := [fsBold];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURTimeBar.DrawWithSkins;
var
  I: integer;
  MarkerPos: integer;
  TextRect: TRect;
  TextStr: string;
begin
  // Draw track with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FTrackHover)
    else
      BGRAReplaceCustomCrops(Canvas, FTrackNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FTrackDisabled);
  end;

  // Draw thumb with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FThumbHover)
    else if FState = obsPressed then
      BGRAReplaceCustomCrops(Canvas, FThumbPressed)
    else
      BGRAReplaceCustomCrops(Canvas, FThumbNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FThumbDisabled);
  end;

  // Draw markers with skins
  if FShowMarkers and (FMarkerCount > 0) then
  begin
    for I := 0 to FMarkerCount do
    begin
      MarkerPos := FTrackRect.Left + Round(I / FMarkerCount *
        (FTrackRect.Right - FTrackRect.Left));

      if Enabled then
        BGRAReplaceCustomCrops(Canvas, FMarkerNormal)
      else
        BGRAReplaceCustomCrops(Canvas, FMarkerDisabled);
    end;
  end;

  // Draw labels
  if FShowLabels then
  begin
    // Start time label
    TextStr := FormatDateTime('hh:nn', FStartTime);
    TextRect := Rect(FTrackRect.Left - 30, FTrackRect.Top - 20,
      FTrackRect.Left, FTrackRect.Top);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Size := 8;
    Canvas.TextRect(TextRect, 0, 0, TextStr);

    // End time label
    TextStr := FormatDateTime('hh:nn', FEndTime);
    TextRect := Rect(FTrackRect.Right, FTrackRect.Top - 20,
      FTrackRect.Right + 30, FTrackRect.Top);
    Canvas.TextRect(TextRect, 0, 0, TextStr);

    // Current time label
    TextStr := GetDisplayTime;
    TextRect := Rect(0, 0, Width, FTrackRect.Top - 5);
    Canvas.Font.Style := [fsBold];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURTimeBar.Paint;
begin
  inherited Paint;

  // Clear background
  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  // Check if skin data is assigned
  if Assigned(Skindata) and Assigned(Skindata.Fimage) then
  begin
    // Use skins if available
    DrawWithSkins;
  end
  else
  begin
    // Use basic drawing if no skins
    DrawBaseTimeBar;
  end;
end;

// Helper functions
function TONURTimeBar.GetPercentage: real;
var
  TimeSpan: real;
  CurrentSpan: real;
begin
  TimeSpan := FEndTime - FStartTime;
  if TimeSpan = 0 then
    Result := 0
  else
  begin
    CurrentSpan := FCurrentTime - FStartTime;
    Result := (CurrentSpan / TimeSpan) * 100;
  end;
end;

function TONURTimeBar.TimeFromPoint(X, Y: integer): TDateTime;
var
  Position: real;
  TimeSpan: real;
  Offset: real;
begin
  Position := X - FTrackRect.Left;
  TimeSpan := FEndTime - FStartTime;
  Offset := (Position / (FTrackRect.Right - FTrackRect.Left)) * TimeSpan;
  Result := FStartTime + Offset;
end;

function TONURTimeBar.GetDisplayTime: string;
var
  FormatStr: string;
begin
  FormatStr := 'hh:nn';
  if FShowSeconds then
    FormatStr := FormatStr + ':ss';
  if FShowDate then
    FormatStr := 'dd/mm/yyyy ' + FormatStr;

  Result := FormatDateTime(FormatStr, FCurrentTime);
end;

// Mouse event handlers
procedure TONURTimeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not Enabled then Exit;

  FState := obsPressed;

  if PtInRect(FTrackRect, Point(X, Y)) then
    SetCurrentTime(TimeFromPoint(X, Y));

  Invalidate;
end;

procedure TONURTimeBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Enabled then
    FState := obsNormal
  else
    FState := obsDisabled;

  Invalidate;
end;

procedure TONURTimeBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  InTrack: boolean;
  NewState: TONURState;
begin
  inherited MouseMove(Shift, X, Y);

  if not Enabled then Exit;

  InTrack := PtInRect(FTrackRect, Point(X, Y));

  if InTrack then
    NewState := obsHover
  else
    NewState := obsNormal;

  if FState <> NewState then
  begin
    FState := NewState;
    Invalidate;
  end;
end;

procedure TONURTimeBar.MouseEnter;
begin
  inherited MouseEnter;

  if Enabled and (FState = obsNormal) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURTimeBar.MouseLeave;
begin
  inherited MouseLeave;

  if Enabled and (FState = obsHover) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURTimeBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

// Public methods
procedure TONURTimeBar.Start;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 1000; // 1 second
    FAnimationTimer.OnTimer := @DoTimer;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURTimeBar.Stop;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURTimeBar.Reset;
begin
  case FMode of
    tbmClock:
      FCurrentTime := Now;
    tbmCountdown:
      FCurrentTime := FEndTime;
    tbmStopwatch:
      FCurrentTime := FStartTime;
    tbmProgress:
      FCurrentTime := FStartTime;
  end;

  UpdateThumbRect;
  Invalidate;
end;

{ TONURLoadingBar }

constructor TONURLoadingBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize basic properties
  FStyle := osLinear;
  FState := obsNormal;
  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FMode := ormDeterminate;
  FIsLoading := False;
  FAnimated := True;
  FAnimationSpeed := 0.05;
  FAnimationPosition := 0.0;
  FDotCount := 3;
  FBarCount := 5;
  FShowPercentage := False;
  FCustomText := '';

  // Initialize track rect
  FTrackRect := Rect(0, 0, 0, 0);

  // Background parts
  FBackNormal := TONURCUSTOMCROP.Create('BACKNORMAL');
  FBackHover := TONURCUSTOMCROP.Create('BACKHOVER');
  FBackPressed := TONURCUSTOMCROP.Create('BACKPRESSED');
  FBackDIsabled := TONURCUSTOMCROP.Create('BACKDISABLED');

  // Progress parts
  FProgressNormal := TONURCUSTOMCROP.Create('PROGRESSNORMAL');
  FProgressHover := TONURCUSTOMCROP.Create('PROGRESSHOVER');
  FProgressPressed := TONURCUSTOMCROP.Create('PROGRESSPRESSED');
  FProgressDIsabled := TONURCUSTOMCROP.Create('PROGRESSDISABLED');

  // Overlay parts
  FOverlayNormal := TONURCUSTOMCROP.Create('OVERLAYNORMAL');
  FOverlayHover := TONURCUSTOMCROP.Create('OVERLAYHOVER');
  FOverlayPressed := TONURCUSTOMCROP.Create('OVERLAYPRESSED');
  FOverlayDIsabled := TONURCUSTOMCROP.Create('OVERLAYDISABLED');

  // Add to custom crop lIst
  CustomcroplIst.Add(FBackNormal);
  CustomcroplIst.Add(FBackHover);
  CustomcroplIst.Add(FBackPressed);
  CustomcroplIst.Add(FBackDIsabled);
  CustomcroplIst.Add(FProgressNormal);
  CustomcroplIst.Add(FProgressHover);
  CustomcroplIst.Add(FProgressPressed);
  CustomcroplIst.Add(FProgressDIsabled);
  CustomcroplIst.Add(FOverlayNormal);
  CustomcroplIst.Add(FOverlayHover);
  CustomcroplIst.Add(FOverlayPressed);
  CustomcroplIst.Add(FOverlayDIsabled);

  // Set default sIze
  Width := 200;
  Height := 20;
  SkInname := 'loadingbar';

  UpdateLayout;
end;

destructor TONURLoadingBar.Destroy;
begin
  if AssIgned(FAnImatIonTImer) then
  begin
    FAnImatIonTImer.Enabled := False;
    FreeAndNil(FAnImatIonTImer);
  end;

  inherited Destroy;
end;

// Property setters
procedure TONURLoadingBar.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then Exit;
  FStyle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURLoadingBar.SetMin(Value: integer);
begin
  if FMin = Value then Exit;
  FMin := Value;
  if FPosition < FMin then SetPosition(FMin);
  if FMax < FMin then SetMax(FMin);
  Invalidate;
end;

procedure TONURLoadingBar.SetMax(Value: integer);
begin
  if FMax = Value then Exit;
  FMax := Value;
  if FPosition > FMax then SetPosition(FMax);
  if FMin > FMax then SetMin(FMax);
  Invalidate;
end;

procedure TONURLoadingBar.SetPosition(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FPosition = Value then Exit;

  FPosition := Value;
  Invalidate;

  if Assigned(FOnProgressChange) then FOnProgressChange(Self);
end;

procedure TONURLoadingBar.SetMode(Value: TONURLoadingBarMode);
begin
  if FMode = Value then Exit;
  FMode := Value;

  if FMode = ormIndeterminate then
    StartAnimation
  else
    StopAnimation;

  Invalidate;
end;

procedure TONURLoadingBar.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURLoadingBar.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

procedure TONURLoadingBar.SetDotCount(Value: integer);
begin
  if FDotCount = Value then Exit;
  FDotCount := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURLoadingBar.SetBarCount(Value: integer);
begin
  if FBarCount = Value then Exit;
  FBarCount := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURLoadingBar.SetShowPercentage(Value: boolean);
begin
  if FShowPercentage = Value then Exit;
  FShowPercentage := Value;
  Invalidate;
end;

procedure TONURLoadingBar.SetCustomText(Value: string);
begin
  if FCustomText = Value then Exit;
  FCustomText := Value;
  Invalidate;
end;

// Animation methods
procedure TONURLoadingBar.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 50; // 20 FPS
    FAnimationTimer.OnTimer := @DoAnimation;
  end;

  FIsLoading := True;
  FAnimationPosition := 0.0;
  FAnimationTimer.Enabled := True;
end;

procedure TONURLoadingBar.StopAnimation;
begin
  FIsLoading := False;
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURLoadingBar.DoAnimation(Sender: TObject);
begin
  FAnimationPosition := FAnimationPosition + FAnimationSpeed;

  if FAnimationPosition >= 1.0 then
    FAnimationPosition := FAnimationPosition - 1.0;

  Invalidate;
end;

procedure TONURLoadingBar.StartLoading;
begin
  StartAnimation;
end;

procedure TONURLoadingBar.StopLoading;
begin
  StopAnimation;
end;

// Helper functions
function TONURLoadingBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FPosition - FMin) / (FMax - FMin) * 100);
end;

function TONURLoadingBar.GetDisplayText: string;
begin
  if FCustomText <> '' then
    Result := FCustomText
  else if FShowPercentage then
    Result := IntToStr(GetPercentage) + '%'
  else
    Result := '';
end;

// Layout method
procedure TONURLoadingBar.UpdateLayout;
var
  Size: integer;
begin
  case FStyle of
    osLinear:
    begin
      FTrackRect := Rect(10, Height div 2 - 6, Width - 10, Height div 2 + 6);
    end;

    osDots:
    begin
      Size := FDotCount * 12 + (FDotCount - 1) * 4;
      FTrackRect := Rect((Width - Size) div 2, 0, (Width + Size) div 2, Height);
    end;

    osBars:
    begin
      Size := FBarCount * 4 + (FBarCount - 1) * 2;
      FTrackRect := Rect((Width - Size) div 2, 0, (Width + Size) div 2, Height);
    end;
  end;
end;

// Drawing methods
procedure TONURLoadingBar.DrawBaseLoadingBar;
var
  I: integer;
  DotRect: TRect;
  BarRect: TRect;
  TextRect: TRect;
  TextStr: string;
  ProgressWidth: integer;
  DotSize: integer;
  BarSize: integer;
  DotSpacing: integer;
  BarSpacing: integer;
  BackColor, ProgressColor, DotColor, BarColor: TColor;
  BarHeight: integer;
begin
  // Set colors based on state
  if Enabled then
  begin
    if FState = obsHover then
      BackColor := $00D0D0D0
    else
      BackColor := $00E0E0E0;
  end
  else
    BackColor := $00F0F0F0;

  ProgressColor := $0078D7;
  DotColor := $004CA5;
  BarColor := $002B57;

  case FStyle of
    osLinear:
    begin
      // Draw background track
      Canvas.Brush.Color := BackColor;
      Canvas.Pen.Color := $00808080;
      Canvas.RoundRect(FTrackRect, 4, 4);

      // Draw progress
      if FMode = ormDeterminate then
      begin
        ProgressWidth := Round((FPosition - FMin) / (FMax - FMin) *
          (FTrackRect.Right - FTrackRect.Left));
        Canvas.Brush.Color := ProgressColor;
        Canvas.Pen.Color := $00404040;
        Canvas.RoundRect(Rect(FTrackRect.Left, FTrackRect.Top,
          FTrackRect.Left + ProgressWidth, FTrackRect.Bottom), 4, 4);
      end
      else
      begin
        // Indeterminate animation
        ProgressWidth := Round(FAnimationPosition *
          (FTrackRect.Right - FTrackRect.Left));
        Canvas.Brush.Color := ProgressColor;
        Canvas.Pen.Color := $00404040;
        Canvas.RoundRect(Rect(FTrackRect.Left, FTrackRect.Top,
          FTrackRect.Left + ProgressWidth, FTrackRect.Bottom), 4, 4);
      end;
    end;

    osDots:
    begin
      // Draw dots
      DotSize := 8;
      DotSpacing := 12;

      for I := 0 to FDotCount - 1 do
      begin
        DotRect.Left := FTrackRect.Left + I * DotSpacing +
          (FTrackRect.Right - FTrackRect.Left - (FDotCount - 1) *
          DotSpacing) div 2;
        DotRect.Top := Height div 2 - DotSize div 2;
        DotRect.Right := DotRect.Left + DotSize;
        DotRect.Bottom := DotRect.Top + DotSize;

        if FIsLoading then
        begin
          // Animated dots
          if (I + Round(FAnimationPosition * FDotCount)) mod FDotCount = 0 then
            Canvas.Brush.Color := DotColor
          else
            Canvas.Brush.Color := BackColor;
        end
        else
        begin
          // Static dots based on progress
          if I < Round((FPosition - FMin) / (FMax - FMin) * FDotCount) then
            Canvas.Brush.Color := DotColor
          else
            Canvas.Brush.Color := BackColor;
        end;

        Canvas.Pen.Color := $00606060;
        Canvas.Ellipse(DotRect);
      end;
    end;

    osBars:
    begin
      // Draw bars
      BarSize := 4;
      BarSpacing := 6;

      for I := 0 to FBarCount - 1 do
      begin
        BarRect.Left := FTrackRect.Left + I * BarSpacing +
          (FTrackRect.Right - FTrackRect.Left - (FBarCount - 1) *
          BarSpacing) div 2;
        BarRect.Top := Height div 2 - 12;
        BarRect.Right := BarRect.Left + BarSize;
        BarRect.Bottom := Height div 2 + 12;

        if FIsLoading then
        begin
          // Animated bars

          BarHeight := Round(Abs(Sin((I + FAnimationPosition) * Pi / 2)) * 12);
          BarRect.Top := Height div 2 - BarHeight;
          BarRect.Bottom := Height div 2 + BarHeight;
          Canvas.Brush.Color := BarColor;
        end
        else
        begin
          // Static bars based on progress
          if I < Round((FPosition - FMin) / (FMax - FMin) * FBarCount) then
            Canvas.Brush.Color := BarColor
          else
            Canvas.Brush.Color := BackColor;
        end;

        Canvas.Pen.Color := $00606060;
        Canvas.RoundRect(BarRect, 2, 2);
      end;
    end;
  end;

  // Draw text
  if FShowPercentage or (FCustomText <> '') then
  begin
    TextStr := GetDisplayText;
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURLoadingBar.DrawWithSkins;
var
  I: integer;
  DotRect: TRect;
  BarRect: TRect;
  TextRect: TRect;
  TextStr: string;
  ProgressWidth: integer;
  DotSize: integer;
  BarSize: integer;
  DotSpacing: integer;
  BarSpacing: integer;
  BarHeight: integer;
begin
  // Draw background with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FBackHover)
    else
      BGRAReplaceCustomCrops(Canvas, FBackNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FBackDisabled);
  end;

  case FStyle of
    osLinear:
    begin
      // Draw progress with skins
      if FMode = ormDeterminate then
      begin
        ProgressWidth := Round((FPosition - FMin) / (FMax - FMin) *
          (FTrackRect.Right - FTrackRect.Left));

        if Enabled then
        begin
          if FState = obsHover then
            BGRAReplaceCustomCrops(Canvas, FProgressHover)
          else
            BGRAReplaceCustomCrops(Canvas, FProgressNormal);
        end
        else
        begin
          BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
        end;
      end
      else
      begin
        // Indeterminate animation with skins
        ProgressWidth := Round(FAnimationPosition *
          (FTrackRect.Right - FTrackRect.Left));

        if Enabled then
          BGRAReplaceCustomCrops(Canvas, FProgressNormal)
        else
          BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
      end;
    end;

    osDots:
    begin
      // Draw dots with skins
      DotSize := 8;
      DotSpacing := 12;

      for I := 0 to FDotCount - 1 do
      begin
        DotRect.Left := FTrackRect.Left + I * DotSpacing +
          (FTrackRect.Right - FTrackRect.Left - (FDotCount - 1) *
          DotSpacing) div 2;
        DotRect.Top := Height div 2 - DotSize div 2;
        DotRect.Right := DotRect.Left + DotSize;
        DotRect.Bottom := DotRect.Top + DotSize;

        if FIsLoading then
        begin
          // Animated dots
          if (I + Round(FAnimationPosition * FDotCount)) mod FDotCount = 0 then
          begin
            if Enabled then
              BGRAReplaceCustomCrops(Canvas, FProgressNormal)
            else
              BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
          end;
        end
        else
        begin
          // Static dots based on progress
          if I < Round((FPosition - FMin) / (FMax - FMin) * FDotCount) then
          begin
            if Enabled then
              BGRAReplaceCustomCrops(Canvas, FProgressNormal)
            else
              BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
          end;
        end;
      end;
    end;

    osBars:
    begin
      // Draw bars with skins
      BarSize := 4;
      BarSpacing := 6;

      for I := 0 to FBarCount - 1 do
      begin
        BarRect.Left := FTrackRect.Left + I * BarSpacing +
          (FTrackRect.Right - FTrackRect.Left - (FBarCount - 1) *
          BarSpacing) div 2;
        BarRect.Top := Height div 2 - 12;
        BarRect.Right := BarRect.Left + BarSize;
        BarRect.Bottom := Height div 2 + 12;

        if FIsLoading then
        begin
          // Animated bars
          BarHeight := Round(Abs(Sin((I + FAnimationPosition) * Pi / 2)) * 12);
          BarRect.Top := Height div 2 - BarHeight;
          BarRect.Bottom := Height div 2 + BarHeight;

          if Enabled then
            BGRAReplaceCustomCrops(Canvas, FProgressNormal)
          else
            BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
        end
        else
        begin
          // Static bars based on progress
          if I < Round((FPosition - FMin) / (FMax - FMin) * FBarCount) then
          begin
            if Enabled then
              BGRAReplaceCustomCrops(Canvas, FProgressNormal)
            else
              BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
          end;
        end;
      end;
    end;
  end;

  // Draw overlay with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FOverlayHover)
    else
      BGRAReplaceCustomCrops(Canvas, FOverlayNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FOverlayDisabled);
  end;

  // Draw text
  if FShowPercentage or (FCustomText <> '') then
  begin
    TextStr := GetDisplayText;
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;


procedure TONURLoadingBar.Paint;
begin
  inherited Paint;

  // Clear background
  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  // Check if skin data is assigned
  if Assigned(Skindata) and Assigned(Skindata.Fimage) then
  begin
    // Use skins if available
    DrawWithSkins;
  end
  else
  begin
    // Use basic drawing if no skins
    DrawBaseLoadingBar;
  end;
end;

// Mouse event handlers
procedure TONURLoadingBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not Enabled then Exit;

  FState := obsPressed;
  Invalidate;
end;

procedure TONURLoadingBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Enabled then
    FState := obsNormal
  else
    FState := obsDisabled;

  Invalidate;
end;

procedure TONURLoadingBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  InTrack: boolean;
  NewState: TONURState;
begin
  inherited MouseMove(Shift, X, Y);

  if not Enabled then Exit;

  InTrack := PtInRect(FTrackRect, Point(X, Y));

  if InTrack then
    NewState := obsHover
  else
    NewState := obsNormal;

  if FState <> NewState then
  begin
    FState := NewState;
    Invalidate;
  end;
end;

procedure TONURLoadingBar.MouseEnter;
begin
  inherited MouseEnter;

  if Enabled and (FState = obsNormal) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURLoadingBar.MouseLeave;
begin
  inherited MouseLeave;

  if Enabled and (FState = obsHover) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURLoadingBar.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;

// Public methods
procedure TONURLoadingBar.Reset;
begin
  SetPosition(FMin);
  StopLoading;
end;




{ TONURProgressRing }

constructor TONURProgressRing.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize basic properties
  FStyle := osModern;
  FState := obsNormal;
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FMode := ormDeterminate;
  FStartAngle := -90;
  FEndAngle := 270;
  FThickness := 8;
  FShowPercentage := True;
  FShowText := True;
  FCustomText := '';
  FAnimated := True;
  FAnimationSpeed := 0.1;
  FTargetValue := 0;
  FAnimationAngle := 0.0;
  FIsLoading := False;
  FCenterX := 0;
  FCenterY := 0;
  FOuterRadius := 0;
  FInnerRadius := 0;
  FMeterRect := Rect(0, 0, 0, 0);

  // Create skin parts
  FBackNormal := TONURCUSTOMCROP.Create('BACKNORMAL');
  FBackHover := TONURCUSTOMCROP.Create('BACKHOVER');
  FBackPressed := TONURCUSTOMCROP.Create('BACKPRESSED');
  FBackDisabled := TONURCUSTOMCROP.Create('BACKDISABLED');

  FProgressNormal := TONURCUSTOMCROP.Create('PROGRESSNORMAL');
  FProgressHover := TONURCUSTOMCROP.Create('PROGRESSHOVER');
  FProgressPressed := TONURCUSTOMCROP.Create('PROGRESSPRESSED');
  FProgressDisabled := TONURCUSTOMCROP.Create('PROGRESSDISABLED');

  FCenterNormal := TONURCUSTOMCROP.Create('CENTERNORMAL');
  FCenterHover := TONURCUSTOMCROP.Create('CENTERHOVER');
  FCenterPressed := TONURCUSTOMCROP.Create('CENTERPRESSED');
  FCenterDisabled := TONURCUSTOMCROP.Create('CENTERDISABLED');

  // Add to custom crop list
  Customcroplist.Add(FBackNormal);
  Customcroplist.Add(FBackHover);
  Customcroplist.Add(FBackPressed);
  Customcroplist.Add(FBackDisabled);
  Customcroplist.Add(FProgressNormal);
  Customcroplist.Add(FProgressHover);
  Customcroplist.Add(FProgressPressed);
  Customcroplist.Add(FProgressDisabled);
  Customcroplist.Add(FCenterNormal);
  Customcroplist.Add(FCenterHover);
  Customcroplist.Add(FCenterPressed);
  Customcroplist.Add(FCenterDisabled);

  // Set default size
  Width := 80;
  Height := 80;
  Skinname := 'progressring';

  UpdateLayout;
end;

destructor TONURProgressRing.Destroy;
begin
  if Assigned(FAnimationTimer) then
  begin
    FAnimationTimer.Enabled := False;
    FreeAndNil(FAnimationTimer);
  end;

  inherited Destroy;
end;

// Property setters
procedure TONURProgressRing.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then Exit;
  FStyle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetMin(Value: integer);
begin
  if FMin = Value then Exit;
  FMin := Value;
  if FValue < FMin then SetValue(FMin);
  if FMax < FMin then SetMax(FMin);
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetMax(Value: integer);
begin
  if FMax = Value then Exit;
  FMax := Value;
  if FValue > FMax then SetValue(FMax);
  if FMin > FMax then SetMin(FMax);
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetValue(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FValue = Value then Exit;

  if FAnimated and not (csDesigning in ComponentState) then
  begin
    FTargetValue := Value;
    StartAnimation;
  end
  else
  begin
    FValue := Value;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TONURProgressRing.SetMode(Value: TONURLoadingBarMode);
begin
  if FMode = Value then Exit;
  FMode := Value;

  if FMode = ormIndeterminate then
    StartLoading
  else
    StopLoading;

  Invalidate;
end;

procedure TONURProgressRing.SetStartAngle(Value: integer);
begin
  if FStartAngle = Value then Exit;
  FStartAngle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetEndAngle(Value: integer);
begin
  if FEndAngle = Value then Exit;
  FEndAngle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetThickness(Value: integer);
begin
  if FThickness = Value then Exit;
  FThickness := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURProgressRing.SetShowPercentage(Value: boolean);
begin
  if FShowPercentage = Value then Exit;
  FShowPercentage := Value;
  Invalidate;
end;

procedure TONURProgressRing.SetShowText(Value: boolean);
begin
  if FShowText = Value then Exit;
  FShowText := Value;
  Invalidate;
end;

procedure TONURProgressRing.SetCustomText(Value: string);
begin
  if FCustomText = Value then Exit;
  FCustomText := Value;
  Invalidate;
end;

procedure TONURProgressRing.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURProgressRing.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

procedure TONURProgressRing.UpdateLayout;
var
  MaxRadius: integer;
begin
  FCenterX := Width div 2;
  FCenterY := Height div 2;

  MaxRadius := Math.Min(Width, Height) div 2 - FThickness div 2 - 2;
  FOuterRadius := MaxRadius;
  FInnerRadius := MaxRadius - FThickness;

  FMeterRect := Rect(FCenterX - FOuterRadius, FCenterY - FOuterRadius,
    FCenterX + FOuterRadius, FCenterY + FOuterRadius);
end;

function TONURProgressRing.ValueToAngle(Value: integer): integer;
begin
  if FMax = FMin then
    Result := FStartAngle
  else
    Result := FStartAngle + Round((Value - FMin) / (FMax - FMin) *
      (FEndAngle - FStartAngle));
end;

function TONURProgressRing.AngleToValue(Angle: integer): integer;
var
  NormalizedAngle: integer;
begin
  if FEndAngle = FStartAngle then
    Result := FMin
  else
  begin
    NormalizedAngle := Angle - FStartAngle;
    if NormalizedAngle < 0 then NormalizedAngle := NormalizedAngle + 360;
    if NormalizedAngle > (FEndAngle - FStartAngle) then
      NormalizedAngle := FEndAngle - FStartAngle;

    Result := FMin + Round(NormalizedAngle / (FEndAngle - FStartAngle) * (FMax - FMin));
  end;

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURProgressRing.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FValue - FMin) / (FMax - FMin) * 100);
end;

function TONURProgressRing.GetDisplayValue: string;
begin
  if FCustomText <> '' then
    Result := FCustomText
  else if FShowPercentage then
    Result := IntToStr(GetPercentage) + '%'
  else
    Result := IntToStr(FValue);
end;

procedure TONURProgressRing.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 16; // 60 FPS
    FAnimationTimer.OnTimer := @DoAnimation;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURProgressRing.StopAnimation;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURProgressRing.DoAnimation(Sender: TObject);
var
  Diff: integer;
  Step: integer;
begin
  if FMode = ormIndeterminate then
  begin
    // Indeterminate animation - rotate
    FAnimationAngle := FAnimationAngle + FAnimationSpeed;
    if FAnimationAngle >= 360 then
      FAnimationAngle := FAnimationAngle - 360;
    Invalidate;
  end
  else
  begin
    // Determinate animation - smooth value transition
    Diff := FTargetValue - FValue;
    if Diff <> 0 then
    begin
      Step := Math.Max(1, Round(Abs(Diff) * FAnimationSpeed));
      if Diff > 0 then
        FValue := FValue + Step
      else
        FValue := FValue - Step;

      FValue := EnsureRange(FValue, FMin, FMax);

      if FValue = FTargetValue then
        FAnimationTimer.Enabled := False;

      Invalidate;
    end;
  end;
end;
// Public methods
procedure TONURProgressRing.StartLoading;
begin
  FIsLoading := True;
  FAnimationAngle := 0.0;
  StartAnimation;
end;

procedure TONURProgressRing.StopLoading;
begin
  FIsLoading := False;
  StopAnimation;
end;

procedure TONURProgressRing.Reset;
begin
  SetValue(FMin);
  StopLoading;
end;

procedure TONURProgressRing.AnimateToValue(Value: integer);
begin
  FTargetValue := EnsureRange(Value, FMin, FMax);
  StartAnimation;
end;

procedure TONURProgressRing.SetPercentage(Value: integer);
begin
  SetValue(FMin + Round(Value / 100 * (FMax - FMin)));
end;



// Drawing methods
procedure TONURProgressRing.DrawBaseProgressRing;
var
  TextRect: TRect;
  TextStr: string;
  StartAng, EndAng: integer;
  ProgressColor, BackColor, TextColor: TColor;
begin
  // Set colors based on state
  if Enabled then
  begin
    if FState = obsHover then
      BackColor := $00D0D0D0
    else
      BackColor := $00E0E0E0;
    ProgressColor := $0078D7;
    TextColor := clBlack;
  end
  else
  begin
    BackColor := $00F0F0F0;
    ProgressColor := $00A0A0A0;
    TextColor := clGray;
  end;

  // Draw background ring
  Canvas.Pen.Color := BackColor;
  Canvas.Pen.Width := FThickness;
  Canvas.Brush.Style := bsClear;
  Canvas.Ellipse(FCenterX - FOuterRadius, FCenterY - FOuterRadius,
    FCenterX + FOuterRadius, FCenterY + FOuterRadius);

  // Draw progress arc
  Canvas.Pen.Color := ProgressColor;
  Canvas.Pen.Width := FThickness;

  if FMode = ormDeterminate then
  begin
    StartAng := FStartAngle;
    EndAng := ValueToAngle(FValue);
  end
  else
  begin
    // Indeterminate - rotating arc
    StartAng := Round(FAnimationAngle);
    EndAng := StartAng + 90;
  end;

  // Draw arc using multiple small lines (simplified arc drawing)
  Canvas.Arc(FCenterX - FOuterRadius, FCenterY - FOuterRadius,
    FCenterX + FOuterRadius, FCenterY + FOuterRadius,
    StartAng, EndAng);

  // Draw text
  if (FShowText or FShowPercentage) and (FShowText or FShowPercentage) then
  begin
    TextStr := GetDisplayValue;
    TextRect := Rect(0, 0, Width, Height);

    Canvas.Font.Color := TextColor;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Size := 12;
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURProgressRing.DrawWithSkins;
var
  TextRect: TRect;
  TextStr: string;
  StartAng, EndAng: integer;
begin
  // Draw background with skins
  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FBackHover)
    else
      BGRAReplaceCustomCrops(Canvas, FBackNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FBackDisabled);
  end;

  // Draw progress with skins
  if FMode = ormDeterminate then
  begin
    StartAng := FStartAngle;
    EndAng := ValueToAngle(FValue);
  end
  else
  begin
    // Indeterminate - rotating arc
    StartAng := Round(FAnimationAngle);
    EndAng := StartAng + 90;
  end;

  if Enabled then
  begin
    if FState = obsHover then
      BGRAReplaceCustomCrops(Canvas, FProgressHover)
    else
      BGRAReplaceCustomCrops(Canvas, FProgressNormal);
  end
  else
  begin
    BGRAReplaceCustomCrops(Canvas, FProgressDisabled);
  end;

  // Draw center with skins
  if FShowText or FShowPercentage then
  begin
    if Enabled then
      BGRAReplaceCustomCrops(Canvas, FCenterNormal)
    else
      BGRAReplaceCustomCrops(Canvas, FCenterDisabled);
  end;

  // Draw text
  if FShowText then
  begin
    TextStr := GetDisplayValue;
    TextRect := Rect(0, 0, Width, Height);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Size := 12;
    Canvas.TextRect(TextRect, 0, 0, TextStr);
  end;
end;

procedure TONURProgressRing.Paint;
begin
  inherited Paint;

  // Clear background
  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  // Check if skin data is assigned
  if Assigned(Skindata) and Assigned(Skindata.Fimage) then
  begin
    // Use skins if available
    DrawWithSkins;
  end
  else
  begin
    // Use basic drawing if no skins
    DrawBaseProgressRing;
  end;
end;

// Mouse event handlers
procedure TONURProgressRing.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not Enabled then Exit;

  FState := obsPressed;
  Invalidate;
end;

procedure TONURProgressRing.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Enabled then
    FState := obsNormal
  else
    FState := obsDisabled;

  Invalidate;
end;

procedure TONURProgressRing.MouseMove(Shift: TShiftState; X, Y: integer);
var
  InRing: boolean;
  NewState: TONURState;
begin
  inherited MouseMove(Shift, X, Y);

  if not Enabled then Exit;

  InRing := ((int64(Sqr(X - FCenterX)) + int64(Sqr(Y - FCenterY))) <=
    int64(Sqr(FOuterRadius))) and ((int64(Sqr(X - FCenterX)) +
    int64(Sqr(Y - FCenterY))) >= int64(Sqr(FInnerRadius)));

  if InRing then
    NewState := obsHover
  else
    NewState := obsNormal;

  if FState <> NewState then
  begin
    FState := NewState;
    Invalidate;
  end;
end;

procedure TONURProgressRing.MouseEnter;
begin
  inherited MouseEnter;

  if Enabled and (FState = obsNormal) then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;

procedure TONURProgressRing.MouseLeave;
begin
  inherited MouseLeave;

  if Enabled and (FState = obsHover) then
  begin
    FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURProgressRing.Resize;
begin
  inherited Resize;
  UpdateLayout;
  Invalidate;
end;


{ TONURMeterBar }


{ TONURMeterBar }

constructor TONURMeterBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize basic properties
  FMin := 0;
  FMax := 100;
  FValue := 0;
  FStyle := osClassic;
  FState := obsNormal;
  FStartAngle := -90;
  FEndAngle := 90;
  FCenterX := 0;
  FCenterY := 0;
  FRadius := 0;
  FInnerRadius := 0;
  FMeterRect := Rect(0, 0, 0, 0);

  // Initialize visual properties
  FShowScale := True;
  FScaleCount := 10;
  FShowLabels := True;
  FShowValue := True;
  FAnimated := True;
  FTargetValue := 0;
  FAnimationSpeed := 0.1;

  // Set default size
  Width := 200;
  Height := 30;
  Skinname := 'meterbar';

  UpdateLayout;
end;

destructor TONURMeterBar.Destroy;
begin
  if Assigned(FAnimationTimer) then
  begin
    FAnimationTimer.Enabled := False;
    FreeAndNil(FAnimationTimer);
  end;

  inherited Destroy;
end;

// Property setters
procedure TONURMeterBar.SetMin(Value: integer);
begin
  if FMin = Value then Exit;
  FMin := Value;
  if FValue < FMin then SetValue(FMin);
  if FMax < FMin then SetMax(FMin);
  UpdateLayout;
  Invalidate;
end;

procedure TONURMeterBar.SetMax(Value: integer);
begin
  if FMax = Value then Exit;
  FMax := Value;
  if FValue > FMax then SetValue(FMax);
  if FMin > FMax then SetMin(FMax);
  UpdateLayout;
  Invalidate;
end;

procedure TONURMeterBar.SetValue(Value: integer);
begin
  Value := EnsureRange(Value, FMin, FMax);
  if FValue = Value then Exit;

  if FAnimated and not (csDesigning in ComponentState) then
  begin
    FTargetValue := Value;
    StartAnimation;
  end
  else
  begin
    FValue := Value;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TONURMeterBar.SetStyle(Value: TONURStyle);
begin
  if FStyle = Value then Exit;
  FStyle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURMeterBar.SetStartAngle(Value: integer);
begin
  if FStartAngle = Value then Exit;
  FStartAngle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURMeterBar.SetEndAngle(Value: integer);
begin
  if FEndAngle = Value then Exit;
  FEndAngle := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TONURMeterBar.SetShowScale(Value: boolean);
begin
  if FShowScale = Value then Exit;
  FShowScale := Value;
  Invalidate;
end;

procedure TONURMeterBar.SetScaleCount(Value: integer);
begin
  if FScaleCount = Value then Exit;
  FScaleCount := Value;
  Invalidate;
end;

procedure TONURMeterBar.SetShowLabels(Value: boolean);
begin
  if FShowLabels = Value then Exit;
  FShowLabels := Value;
  Invalidate;
end;

procedure TONURMeterBar.SetShowValue(Value: boolean);
begin
  if FShowValue = Value then Exit;
  FShowValue := Value;
  Invalidate;
end;

procedure TONURMeterBar.SetAnimated(Value: boolean);
begin
  if FAnimated = Value then Exit;
  FAnimated := Value;

  if not FAnimated and Assigned(FAnimationTimer) then
    StopAnimation;
end;

procedure TONURMeterBar.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then Exit;
  FAnimationSpeed := Value;
end;

// Animation methods
procedure TONURMeterBar.StartAnimation;
begin
  if not Assigned(FAnimationTimer) then
  begin
    FAnimationTimer := TTimer.Create(nil);
    FAnimationTimer.Interval := 16; // 60 FPS
    FAnimationTimer.OnTimer := @DoAnimation;
  end;

  FAnimationTimer.Enabled := True;
end;

procedure TONURMeterBar.StopAnimation;
begin
  if Assigned(FAnimationTimer) then
    FAnimationTimer.Enabled := False;
end;

procedure TONURMeterBar.DoAnimation(Sender: TObject);
var
  Diff: integer;
  Step: real;
begin
  Diff := FTargetValue - FValue;

  if Abs(Diff) < 1 then
  begin
    FValue := FTargetValue;
    StopAnimation;
    Invalidate;

    if Assigned(FOnChange) then FOnChange(Self);
  end
  else
  begin
    Step := Diff * FAnimationSpeed;
    FValue := FValue + Round(Step);
    Invalidate;
  end;
end;

// Layout methods
procedure TONURMeterBar.UpdateLayout;
begin
  case FStyle of
    osClassic:
    begin
      FMeterRect := Rect(20, Height div 2 - 4, Width - 20, Height div 2 + 4);
    end;

    osModern:
    begin
      FMeterRect := Rect(Width div 2 - 4, 20, Width div 2 + 4, Height - 20);
    end;

    osArc, osCircular:
    begin
      FCenterX := Width div 2;
      FCenterY := Height div 2;
      FRadius := Math.Min(Width, Height) div 2 - 20;
      FInnerRadius := FRadius div 3;
      FMeterRect := Rect(FCenterX - FRadius, FCenterY - FRadius,
        FCenterX + FRadius, FCenterY + FRadius);
    end;
  end;
end;

procedure TONURMeterBar.UpdateAngles;
begin
  // Update angles for arc/circular styles
  case FStyle of
    osArc:
    begin
      FStartAngle := -90;
      FEndAngle := 90;
    end;

    osCircular:
    begin
      FStartAngle := 0;
      FEndAngle := 360;
    end;
  end;
end;

// Drawing methods
procedure TONURMeterBar.DrawBaseMeterBar;
var
  I: integer;
  ScalePos: integer;
  TextRect: TRect;
  TextStr: string;
  MeterPos: integer;
  Angle: integer;
  MeterColor, ScaleColor: TColor;
  Y: int64;
  ScaleRadius: integer;
  ScalexX: int64;
  ScaleyY: int64;
begin
  // Set colors based on state
  if Enabled then
  begin
    if FState = obsHover then
      MeterColor := $00A0A0A0
    else
      MeterColor := $00909090;
  end
  else
    MeterColor := $00C0C0C0;

  ScaleColor := $00606060;

  // Draw background
  Canvas.Brush.Color := Color;
  Canvas.FillRect(0, 0, Width, Height);

  // Draw meter based on style
  case FStyle of
    osClassic://Horizontal:
    begin
      MeterPos := FMeterRect.Left + Round((FValue - FMin) /
        (FMax - FMin) * (FMeterRect.Right - FMeterRect.Left));

      Canvas.Brush.Color := MeterColor;
      Canvas.Pen.Color := $00404040;
      Canvas.RoundRect(FMeterRect, 2, 2);

      // Draw value indicator
      Canvas.Brush.Color := $00FF0000; // Red indicator
      Canvas.Pen.Color := $00800000;
      Canvas.Rectangle(MeterPos - 2, FMeterRect.Top - 2,
        MeterPos + 2, FMeterRect.Bottom + 2);
    end;

    osModern://Vertical:
    begin
      MeterPos := FMeterRect.Bottom - Round(
        (FValue - FMin) / (FMax - FMin) * (FMeterRect.Bottom -
        FMeterRect.Top));

      Canvas.Brush.Color := MeterColor;
      Canvas.Pen.Color := $00404040;
      Canvas.RoundRect(FMeterRect, 2, 2);

      // Draw value indicator
      Canvas.Brush.Color := $00FF0000; // Red indicator
      Canvas.Pen.Color := $00800000;
      Canvas.Rectangle(FMeterRect.Left - 2, MeterPos - 2,
        FMeterRect.Right + 2, MeterPos + 2);
    end;

    osArc, osCircular:
    begin
      Angle := ValueToAngle(FValue);

      // Draw arc background
      Canvas.Pen.Color := $00808080;
      Canvas.Pen.Width := 8;
      Canvas.Arc(FCenterX - FRadius, FCenterY - FRadius,
        FCenterX + FRadius, FCenterY + FRadius,
        FStartAngle, FEndAngle);

      // Draw value arc
      Canvas.Pen.Color := $00FF0000; // Red value
      Canvas.Pen.Width := 6;
      Canvas.Arc(FCenterX - FRadius, FCenterY - FRadius,
        FCenterX + FRadius, FCenterY + FRadius,
        FStartAngle, Angle);
    end;
  end;

  // Draw scale
  if FShowScale and (FScaleCount > 0) then
  begin
    Canvas.Pen.Color := ScaleColor;
    Canvas.Pen.Width := 1;

    for I := 0 to FScaleCount do
    begin
      case FStyle of
        osClassic://Horizontal:
        begin
          ScalePos := FMeterRect.Left + Round(I / FScaleCount *
            (FMeterRect.Right - FMeterRect.Left));
          Canvas.MoveTo(ScalePos, FMeterRect.Top - 2);
          Canvas.LineTo(ScalePos, FMeterRect.Top);
          Canvas.MoveTo(ScalePos, FMeterRect.Bottom);
          Canvas.LineTo(ScalePos, FMeterRect.Bottom + 2);
        end;

        osModern://Vertical:
        begin
          ScalePos := FMeterRect.Top + Round(I / FScaleCount *
            (FMeterRect.Bottom - FMeterRect.Top));
          Canvas.MoveTo(FMeterRect.Left - 2, ScalePos);
          Canvas.LineTo(FMeterRect.Left, ScalePos);
          Canvas.MoveTo(FMeterRect.Right, ScalePos);
          Canvas.LineTo(FMeterRect.Right + 2, ScalePos);
        end;

        osArc, osCircular:
        begin
          Angle := ValueToAngle(FMin + Round(I / FScaleCount * (FMax - FMin)));
          ScalePos := Round(FRadius * Cos(Angle * PI / 180));
          Y := Round(FRadius * Sin(Angle * PI / 180));

          Canvas.Ellipse(FCenterX + ScalePos - 2, FCenterY + Y - 2,
            FCenterX + ScalePos + 2, FCenterY + Y + 2);
        end;
      end;

      // Draw scale labels
      if FShowLabels then
      begin
        TextStr := IntToStr(FMin + Round(I / FScaleCount * (FMax - FMin)));

        if Enabled then
          Canvas.Font.Color := clBlack
        else
          Canvas.Font.Color := clGray;
        Canvas.Font.Size := 8;

        case FStyle of
          osClassic://osHorizontal:
          begin
            TextRect := Rect(ScalePos - 15, FMeterRect.Bottom + 2,
              ScalePos + 15, Height);
            Canvas.TextRect(TextRect, 0, 0, TextStr);
          end;

          osModern://Vertical:
          begin
            TextRect := Rect(0, ScalePos - 10, FMeterRect.Left - 5, ScalePos + 10);
            Canvas.TextRect(TextRect, 0, 0, TextStr);
          end;

          osArc, osCircular:
          begin
            ScaleRadius := FRadius - 15;
            ScalexX := FCenterX + Round(ScaleRadius * Cos(Angle * PI / 180));
            ScaleyY := FCenterY + Round(ScaleRadius * Sin(Angle * PI / 180));

            TextRect := Rect(ScaleXx - 10, ScaleyY - 10, ScaleXx + 10, ScaleyY + 10);
            Canvas.TextRect(TextRect, 0, 0, TextStr);
          end;
        end;
      end;
    end;
  end;

  // Draw value text
  if FShowValue then
  begin
    TextStr := IntToStr(FValue);

    if Enabled then
      Canvas.Font.Color := clBlack
    else
      Canvas.Font.Color := clGray;
    Canvas.Font.Style := [fsBold];

    case FStyle of
      osClassic://Horizontal:
      begin
        TextRect := Rect(0, 0, Width, FMeterRect.Top - 5);
        Canvas.TextRect(TextRect, 0, 0, TextStr);
      end;

      osModern://Vertical:
      begin
        TextRect := Rect(FMeterRect.Right + 5, 0, Width, Height);
        Canvas.TextRect(TextRect, 0, 0, TextStr);
      end;

      osArc, osCircular:
      begin
        TextRect := Rect(FCenterX - 20, FCenterY - 10, FCenterX + 20, FCenterY + 10);
        Canvas.TextRect(TextRect, 0, 0, TextStr);
      end;
    end;
  end;
end;

procedure TONURMeterBar.Paint;
begin
  inherited Paint;

  DrawBaseMeterBar;
end;

// Helper functions
function TONURMeterBar.ValueToAngle(Value: integer): integer;
begin
  if FMax = FMin then
    Result := FStartAngle
  else
    Result := FStartAngle + Round((Value - FMin) / (FMax - FMin) *
      (FEndAngle - FStartAngle));
end;

function TONURMeterBar.AngleToValue(Angle: integer): integer;
begin
  if FEndAngle = FStartAngle then
    Result := FMin
  else
    Result := FMin + Round((Angle - FStartAngle) / (FEndAngle - FStartAngle) *
      (FMax - FMin));

  Result := EnsureRange(Result, FMin, FMax);
end;

function TONURMeterBar.GetPercentage: integer;
begin
  if FMax = FMin then
    Result := 0
  else
    Result := Round((FValue - FMin) / (FMax - FMin) * 100);
end;

function TONURMeterBar.PositionFromPoint(X, Y: integer): integer;
var
  DX: integer;
  DY: integer;
  Angle: int64;
begin
  case FStyle of
    osClassic://Horizontal:
      Result := FMin + Round((X - FMeterRect.Left) /
        (FMeterRect.Right - FMeterRect.Left) * (FMax - FMin));

    osModern://Vertical:
      Result := FMin + Round((FMeterRect.Bottom - Y) /
        (FMeterRect.Bottom - FMeterRect.Top) * (FMax - FMin));

    else // Arc/Circular
    begin
      DX := X - FCenterX;
      DY := Y - FCenterY;
      Angle := Round(ArcTan2(DY, DX) * 180 / PI);
      Result := AngleToValue(Angle);
    end;
  end;

  Result := EnsureRange(Result, FMin, FMax);
end;

// Public methods
procedure TONURMeterBar.SetPercentage(Value: integer);
begin
  SetValue(FMin + Round(Value / 100 * (FMax - FMin)));
end;

procedure TONURMeterBar.AnimateToValue(Value: integer);
begin
  FTargetValue := EnsureRange(Value, FMin, FMax);
  StartAnimation;
end;

procedure TONURMeterBar.Reset;
begin
  SetValue(FMin);
end;

end.

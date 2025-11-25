unit onurbutton;

{$mode objfpc}{$H+}

interface

uses
  LCLType,Types,{$IFDEF WINDOWS}
  Windows,{$ELSE}unix, LCLIntf, {$ENDIF}StdCtrls,LMessages,SysUtils,Classes,Controls,Graphics,ExtCtrls,
  BGRABitmap,BGRABitmapTypes,ComponentEditors,PropEdits,onurctrl;

  type
  //SYSTEM BUTTON -- close minimize help tray etc..

   TONURButtonType       = (OBTNClose, OBTNMinimize,OBTNMaximize, OBTNHelp);
    // Animation types
  TONURAnimation = (laNone, laScroll, laFade, laScale, laColor, laBounce, laRotate, laShake,laBlink,laPulse, laColorCycle, laGlow,  laWave, laRainbow, laStrobe, laRandom);

   { TONURsystemButton }

   TONURsystemButton = class(TONURGraphicControl)
   private
    FNormal      : TONURCUSTOMCROP;
    FPress       : TONURCUSTOMCROP;
    FEnter       : TONURCUSTOMCROP;
    FDisable     : TONURCUSTOMCROP;
    FState       : TONURButtonState;
    FAutoWidth   : boolean;
    FButtonType : TONURButtonType;
    function GetButtonType: TONURButtonType;
    procedure SetButtonType(AValue: TONURButtonType);
   protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure Click; override;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property ButtonType : TONURButtonType read GetButtonType write SetButtonType;
    property Alpha;
    property Skindata;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;




  { TONURCropButton }

  TONURCropButton = class(TONURCustomControl)
  private
    FNormalTL,FNormalTR,FNormalT,
    FNormalBL,FNormalBR,FNormalB,
    FNormalL,FNormalR,FNormalC,

    FHoverTL,FHoverTR,FHoverT,
    FHoverBL,FHoverBR,FHoverB,
    FHoverL,FHoverR,FHoverC,

    FPressTL,FPressTR,FPressT,
    FPressBL,FPressBR,FPressB,
    FPressL,FPressR,FPressC,

    FDisableTL,FDisableTR,FDisableT,
    FDisableBL,FDisableBR,FDisableB,
    FDisableL,FDisableR,FDisableC : TONURCUSTOMCROP;

    FState           : TONURButtonState;
    FAutoWidth       : boolean;
    FOldHeight, FOldWidth: Integer;
    function GetAutoWidth: boolean;
    procedure DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c: TRect; FontColor: TColor);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Alpha;
    property Skindata;
    property AutoWidth  : boolean       read GetAutoWidth write SetAutoWidth default True;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  { TONURGraphicsButton }

  TONURGraphicsButton = class(TONURGraphicControl)
  private
    FNormalTL,FNormalTR,FNormalT,
    FNormalBL,FNormalBR,FNormalB,
    FNormalL,FNormalR,FNormalC,

    FHoverTL,FHoverTR,FHoverT,
    FHoverBL,FHoverBR,FHoverB,
    FHoverL,FHoverR,FHoverC,

    FPressTL,FPressTR,FPressT,
    FPressBL,FPressBR,FPressB,
    FPressL,FPressR,FPressC,

    FDisableTL,FDisableTR,FDisableT,
    FDisableBL,FDisableBR,FDisableB,
    FDisableL,FDisableR,FDisableC : TONURCUSTOMCROP;

    FState: TONURButtonState;
    FAutoWidth: boolean;
    FOldHeight, FOldWidth: Integer;
 //   FClientPicture:Tpoint;
 //   FBGDisable,FBGHover,FBGNormal,FBGPress:TBGRABitmap;
    function GetAutoWidth: boolean;
    procedure DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c: TRect; FontColor: TColor);

  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize;override;
    procedure Resizing;
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Alpha;
    property Skindata;
    property AutoWidth: boolean read GetAutoWidth write SetAutoWidth default True;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  TONURNavMenuButton = class;




  { TONURNavButton }

  TONURNavButton=class(TONURGraphicControl)
  private
    FState       : TONURButtonState;
    FAutoWidth   : boolean;
   // FButtonControl: TONURNavMenuButton;
    function GetButtonOrderIndex: integer;
    function GetOrderIndex: integer;
    procedure Getposition;
    procedure SetButtonControl(ANavButton: TONURNavMenuButton);
    procedure SetButtonOrderIndex(Value: integer);
  protected
    procedure ReadState(Reader: TReader); override;
    procedure Loaded; override;
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
  public
    FButtonControl : TONURNavMenuButton;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property ButtonControl  : TONURNavMenuButton read FButtonControl write SetButtonControl;

  published
    property Skindata;
    property ButtonOrderIndex: integer read GetButtonOrderIndex
      write SetButtonOrderIndex stored False;
    property AutoWidth: boolean read FAutoWidth write SetAutoWidth default True;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  { TONURNavMenuButton }
   TButtonChangingEvent = procedure(Sender: TObject; NewButtonIndex: integer;
    var AllowChange: boolean) of object;



  TONURNavMenuButton = class(TONURCustomControl)
  private
   Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
   FTop, FBottom, FCenter: TONURCUSTOMCROP;

   // for button
   FNormal    : TONURCUSTOMCROP;
   FPress     : TONURCUSTOMCROP;
   FEnter     : TONURCUSTOMCROP;
   FDisable   : TONURCUSTOMCROP;

  // fbuttonleft,Fbuttonright,fbuttoncenter,Fsplitter : TONURCUSTOMCROP;
   FButton         : TList;
   FButtonChanged  : TNotifyEvent;
   FButtonChanging : TButtonChangingEvent;
   FActiveButton   : TONURNavButton;
   FMousePoint     : TPoint;
   FFormPoint      : TPoint;
   FMoveable       : Boolean;
   function GetMovable: Boolean;
   procedure SetMovable(AValue: Boolean);
   function GetButtons(Index: integer): TONURNavButton;
   function GetButtonCount: integer;
   function GetActiveButtonIndex: integer;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure ShowControl(AControl: TControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetActiveButton(Buttoni: TONURNavButton); virtual;
    procedure SetActiveButtonIndex(ButtonIndex: integer); virtual;
    procedure DoButtonChanged; virtual;
    function DoButtonChanging(NewButtonIndex: integer): boolean; virtual;
    property ActiveButtonIndex: integer read GetActiveButtonIndex
      write SetActiveButtonIndex stored False;
    property OnButtonChanging: TButtonChangingEvent read FButtonChanging write FButtonChanging;
    property OnButtonChanged: TNotifyEvent read FButtonChanged write FButtonChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    function NewButton: TONURNavButton;
    procedure InsertButton(Buttoni: TONURNavButton); virtual;
    procedure RemoveButton(Buttoni: TONURNavButton); virtual;
    function NextButton(CurButton: TONURNavButton; GoForward: boolean): TONURNavButton;
    procedure SelectNextButton(GoForward: boolean);
    property ButtonCount: integer read GetButtonCount;
    property Buttons[Index: integer]: TONURNavButton read GetButtons;
  published
    property Movable : Boolean read GetMovable write SetMovable;
    property ActiveButton: TONURNavButton read FActiveButton write SetActiveButton;
    property Alpha;
    property Skindata;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;



  { TONURSwich }

  TONURSwich = class(TONURGraphicControl)
  private
    FOpen, Fclose, Fopenhover, Fclosehover, FDisableOff,FDisableOn: TONURCUSTOMCROP;
    FState: TONURButtonState;
    FChecked: boolean;
    FOnCap,FOffCap:string;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    procedure CMonmouseenter(var Messages: TLmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: TLmessage); message CM_MOUSELEAVE;
    protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property ONCaption  : string read FOnCap  write FOnCap;
    property OFFCaption : string read FOffCap write FOffCap;
    property Alpha;
    property Skindata;
    property Checked    : boolean read FChecked write SetChecked default False;
    property OnChange   : TNotifyEvent read FOnChange write FOnChange;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;



  { TONURCheckbox }

  TONURCheckbox = class(TONURGraphicControl)
  private
    obenter, obleave, obdown, FDisableOn,FDisableOFF, obcheckenters, obcheckleaves: TONURCUSTOMCROP;
    FState: TONURButtonState;
    FCheckWidth: integer;
    FCaptionDirection: TONURCapDirection;
    FChecked: boolean;
   // textx, Texty: integer;
  //  FClientRect: TRect;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: TONURCapDirection);
    function GetCaptionmod: TONURCapDirection;
    procedure CMonmouseenter(var Messages: TLmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: TLmessage); message CM_MOUSELEAVE;
    procedure CMHittest(var msg: TCMHIttest);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

  published
    property Alpha;
    property Skindata;
     property Checked: boolean
      read FChecked write SetChecked default False;
    property CheckWidth: integer read GetCheckWidth write SetCheckWidth;
    property CaptionDirection: TONURCapDirection read GetCaptionmod write SetCaptionmod;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  { TONURRadioButton }

  TONURRadioButton = class(TONURGraphicControl)
  private
    obenter, obleave,
    obdown, FDisableOn,FDisableOFF,
    obcheckenters,
    obcheckleaves     : TONURCUSTOMCROP;
    Fstate            : TONURButtonState;
    FCheckWidth       : integer;
    FCaptionDirection : TONURCapDirection;
    FChecked          : boolean;
    textx, Texty      : integer;
    FClientRect: TRect;
    FOnChange         : TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: TONURCapDirection);
    function GetCaptionmod: TONURCapDirection;
    procedure deaktifdigerleri;  /// for radiobutton
    procedure CMonmouseenter(var Messages: TLmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: TLmessage); message CM_MOUSELEAVE;
    procedure CMHittest(var msg: TCMHIttest);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Checked: boolean
      read FChecked write SetChecked default False;
  published
    property Alpha;
    property Skindata;
    property CheckWidth: integer read GetCheckWidth write SetCheckWidth;
    property CaptionDirection: TONURCapDirection read GetCaptionmod write SetCaptionmod;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;



  { TONURLabel }



  TONURlabel = class(TONURGraphicControl)
  private
    { Private declarations }
    FClientP: TONURCUSTOMCROP;
    FBitmap: TBGRABitmap;
    tempbitmap: TBGRABitmap;
    Flist: TStringList;
    FTimer: TTimer;
    FInterval: cardinal;
    FActive: boolean;
    FStretch: boolean;
    FScrollBy: integer;
    FCurPos: integer;
    FWait: integer;
    FWaiting: boolean;
    FCaption: TCaption;
    FScale: real;
    FCharWidth, FCharHeight: integer;
    
    // New animation properties
    FAnimationType: TONURAnimation;
    FAnimationProgress: real;
    FAnimationDirection: integer;
    FCurrentAlpha: byte;
    FCurrentScale: real;
    FCurrentRotation: real;
    FCurrentBounce: real;
    FCurrentShake: real;
    FStartColor, FEndColor: TColor;
    FAnimationSpeed: real;
    FLoopAnimation: boolean;

    procedure Getbmp;
    function GetScrollBy: integer;
    procedure SetActive(Value: boolean);
    procedure Setcaption(Avalue: Tcaption);
    procedure SetStretch(Value: boolean);
    procedure SetInterval(Value: cardinal);
    procedure Activate;
    procedure Deactivate;
    procedure UpdatePos;
    procedure DoOnTimer(Sender: TObject);
    procedure SetCharWidth(Value: integer);
    procedure SetCharHeight(Value: integer);
    procedure SetString(AValue: TStringList); virtual;
    procedure listchange(Sender: TObject);
    
    // New animation methods
    procedure SetAnimationType(Value: TONURAnimation);
    procedure SetAnimationSpeed(Value: real);
    procedure SetLoopAnimation(Value: boolean);
    procedure SetStartColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure UpdateAnimation;
    procedure ApplyFadeAnimation;
    procedure ApplyScaleAnimation;
    procedure ApplyColorAnimation;
    procedure ApplyBounceAnimation;
    procedure ApplyRotateAnimation;
    procedure ApplyShakeAnimation;
  protected
    Procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    { Published declarations }
    property Strings: TStringList read Flist write SetString;
    property Active: boolean read FActive write SetActive;
    property Stretch: boolean read FStretch write SetStretch;
    property ScrollBy: integer read GetScrollBy write FScrollBy;
    property Interval: cardinal read FInterval write SetInterval;
    property CharHeight: integer read FCharHeight write SetCharHeight default 75;
    property CharWidth: integer read FCharWidth write SetCharWidth default 44;
    property WaitOnEnd: integer read FWait write FWait;
    property Align;
    property Caption: TCaption read FCaption write SetCaption;
    property Alpha;
    
    // New animation properties
    property AnimationType: TONURAnimation read FAnimationType write SetAnimationType default laNone;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;
    property LoopAnimation: boolean read FLoopAnimation write SetLoopAnimation default False;
    property StartColor: TColor read FStartColor write SetStartColor default clWhite;
    property EndColor: TColor read FEndColor write SetEndColor default clBlack;

    property ParentColor;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  {$IFDEF WINDOWS}
   { TOnThreadTimerClass }

  TOnThreadTimerClass = class(TThread)
  protected
    procedure Call;
    procedure Execute; override;
  public
  private
    FInterval: word;
    FOnCall: TNotifyEvent;
    FSender: TObject;
  end;

  { TOnThreadTimer }

  TOnThreadTimer = class(TComponent)
  private
    { Private declarations }
    FEnabled: boolean;
    FThread: TOnThreadTimerClass;
    procedure SetEnabled(const Value: boolean);
    function GetInterval: word;
    procedure SetInterval(const Value: word);
    function GetOnTimer: TNotifyEvent;
    procedure SetOnTimer(const Value: TNotifyEvent);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Enabled: boolean read FEnabled write SetEnabled default False;
    property Interval: word read GetInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read GetOnTimer write SetOnTimer;
  end;

  {$ENDIF}
  TTextDirection = (tdLeftToRight, tdRightToLeft);
  TTextStylee = (tsPingPong, tsScroll);

  { TONURNormalLabel }

  TONURNormalLabel = class(TGraphicControl)
  private
    clr        : Tcolor;
    FBuffer    : TBGRABitmap;
    FText      : string;
    FAnimate   : boolean;
    FBiLink    : boolean;
    FBiLinki   : boolean;
    FBlinkTimer: TTimer;
    FTimer     : {$IFDEF WINDOWS} TOnThreadTimer{$ELSE}TTimer{$ENDIF};
    FDirection : TTextDirection;
    FStyle     : TTextStylee;
    FWait      : byte;
    FPos       : integer;
    FScrollBy  : integer;
    FWaiting   : byte;
    FYazibuyuk : boolean;
    FBlinkInterval : integer;
    FTimerInterval : integer;
    
    // New animation properties
    FAnimationType: TONURAnimation;
    FAnimationProgress: real;
    FAnimationSpeed: real;
    FAnimationDirection: integer;
    FCurrentAlpha: byte;
    FCurrentScale: real;
    FCurrentRotation: real;
    FCurrentBounce: real;
    FCurrentShake: real;
    FStartColor, FEndColor: TColor;
    FLoopAnimation: boolean;
    
    const
    wWaiting    : byte = 15;


    procedure DrawFontTextcolor(incolor, outcolor: TBGRAPixel);
    function GetScroll: integer;
    function GetTextDefaultPos: smallint;
    procedure SetAnimate(AValue: boolean);
    procedure SetBilink(AValue: boolean);
    procedure Setblinkinterval(AValue: integer);
    procedure Setclr(AValue: TBGRAPixel);
    procedure SetScrollBy(AValue: integer);

    procedure Settimerinterval(AValue: integer);
    procedure Setwaiting(AValue: byte);
    procedure SetYazibuyuk(AValue: boolean);
    procedure TimerEvent(Sender: TObject);
    procedure DrawFontText;
    procedure FreeTimer;
    procedure Blinktimerevent(sender:TObject);
    
    // New animation methods
    procedure SetAnimationType(Value: TONURAnimation);
    procedure SetAnimationSpeed(Value: real);
    procedure SetLoopAnimation(Value: boolean);
    procedure SetStartColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure UpdateAnimation;
    procedure ApplyFadeAnimation;
    procedure ApplyScaleAnimation;
    procedure ApplyColorAnimation;
    procedure ApplyBounceAnimation;
    procedure ApplyRotateAnimation;
    procedure ApplyShakeAnimation;
  protected
    procedure Loaded; override;
    procedure SetText(AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    { Published declarations }
    property Flash           : boolean      read FBiLink        write SetBilink default False;
    property FlashColor      : Tcolor       read clr            write clr; // for Blink color
    property Flashinterval   : integer      read FBlinkInterval write Setblinkinterval;
    property Animate         : boolean      read FAnimate       write SetAnimate default False;
    property Animateinterval : integer      read FTimerInterval write Settimerinterval;
    property Animatewait     : byte         read FWaiting       write Setwaiting;
    //property Style         : TTextStylee  read FStyle         write FStyle;
    property Text            : string       read FText          write SetText;
    property Scroll          : integer      read GetScroll      write SetScrollBy;
    
    // New animation properties
    property AnimationType: TONURAnimation read FAnimationType write SetAnimationType default laNone;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;
    property LoopAnimation: boolean read FLoopAnimation write SetLoopAnimation default False;
    property StartColor: TColor read FStartColor write SetStartColor default clWhite;
    property EndColor: TColor read FEndColor write SetEndColor default clBlack;
    property Align;
    property Font;
    //property Yazibuyuk : boolean read fyazibuyuk write SetYazibuyuk;
     property ParentColor;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


 { TONURLed }


  TONURLed = class(TONURGraphicControl)
private
    FCheck,FMouseOn:boolean;
    FOnChange: TNotifyEvent;
    Fonclientp, Foffclientp, Fonclientph, Foffclientph,Fdisabled: TONURCUSTOMCROP;
    
    // Animation properties
    FAnimationType: TONURAnimation;
    FAnimationTimer: TTimer;
    FAnimationProgress: real;
    FAnimationSpeed: real;
    FAnimationDirection: integer;
    FCurrentAlpha: byte;
    FCurrentColor: TColor;
    FStartColor, FEndColor: TColor;
    FLoopAnimation: boolean;
    FAnimationActive: boolean;
    FGlowRadius: integer;
    FShakeX, FShakeY: real;
    FWaveOffset: real;
    FRainbowHue: real;
    FStrobeState: boolean;
    FRandomValue: real;
    
    procedure Setledonoff(val:boolean);
    procedure SetAnimationType(Value: TONURAnimation);
    procedure SetAnimationSpeed(Value: real);
    procedure SetLoopAnimation(Value: boolean);
    procedure SetStartColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure DoAnimationTimer(Sender: TObject);
    procedure UpdateAnimation;
    procedure ApplyBlinkAnimation;
    procedure ApplyFadeAnimation;
    procedure ApplyPulseAnimation;
    procedure ApplyColorCycleAnimation;
    procedure ApplyGlowAnimation;
    procedure ApplyShakeAnimation;
    procedure ApplyWaveAnimation;
    procedure ApplyRainbowAnimation;
    procedure ApplyStrobeAnimation;
    procedure ApplyRandomAnimation;
    function GetRainbowColor(Hue: real): TColor;
 public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
 protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
 published
    property Alpha;
    Property LedOn          : Boolean       Read FCheck       write Setledonoff;
    property Onchange       : TNotifyEvent  read FOnChange    write FOnChange;
    property Skindata;
    
    // Animation properties
    property AnimationType: TONURAnimation read FAnimationType write SetAnimationType default laNone;
    property AnimationSpeed: real read FAnimationSpeed write SetAnimationSpeed;
    property LoopAnimation: boolean read FLoopAnimation write SetLoopAnimation default False;
    property StartColor: TColor read FStartColor write SetStartColor default clRed;
    property EndColor: TColor read FEndColor write SetEndColor default clLime;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;


  { TONURButtonControlEditor }

  TONURButtonControlEditor = class(TComponentEditor)
  private
    procedure AddButton;
  public
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

   { TONURButtonActiveButtonProperty }

   TONURButtonActiveButtonProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;
procedure Register;



implementation

uses LazUnicode,Forms,Dialogs,LazUTF8;

const
  StringAddButton  = 'New Button';
  StringNextButton = 'Next Button';
  StringPrevButton = 'Previous Button';


procedure Register;
begin
  RegisterComponents('ONUR', [TONURsystemButton]);
  RegisterComponents('ONUR', [TONURCropButton]);
  RegisterComponents('ONUR', [TONURGraphicsButton]);
  RegisterComponents('ONUR', [TONURNavMenuButton]);
  RegisterComponents('ONUR', [TONURSwich]);
  RegisterComponents('ONUR', [TONURCheckbox]);
  RegisterComponents('ONUR', [TONURRadioButton]);
  RegisterComponents('ONUR', [TONURlabel]);
  RegisterComponents('ONUR', [TONURNormalLabel]);
  RegisterComponents('ONUR', [TONURLed]);

  

  RegisterClasses([TONURNavMenuButton, TONURNavButton]);
  RegisterNoIcon([TONURNavButton]);

  RegisterPropertyEditor(TypeInfo(TONURNavButton), TONURNavMenuButton, 'ActiveButton',
    TONURButtonActiveButtonProperty);
  RegisterComponentEditor(TONURNavMenuButton, TONURButtonControlEditor);
  RegisterComponentEditor(TONURNavButton, TONURButtonControlEditor);
end;



{ TONURButtonControlEditor }

procedure TONURButtonControlEditor.AddButton;
var
  P: TONURNavButton;
  C: TONURNavMenuButton;
  Hook: TPropertyEditorHook = nil;
begin
  if not GetHook(Hook) then
    Exit;

  if Component is TONURNavButton then
    c := TONURNavButton(Component).ButtonControl
  else
    c := TONURNavMenuButton(Component);


    P := TONURNavButton.Create(C.Owner);
  try
    P.Parent := C;
    P.Name := GetDesigner.CreateUniqueComponentName(p.ClassName);
    p.Caption := p.Name;
    P.ButtonControl:= C;
    c.ActiveButton:=P;
    Hook.PersistentAdded(P, True);
    GlobalDesignHook.SelectOnlyThis(P);
    Modified;
  except
    P.Free;
    raise;
  end;
end;



function TONURButtonControlEditor.GetVerb(Index: integer): string;
var
  NavmenuControl: TONURNavMenuButton;
begin
  case Index of
    0: Result := StringAddButton;
    1: Result := StringNextButton;
    2: Result := StringPrevButton;
    else
    begin
      Result := '';
      if Component is TONURNavButton then
        NavmenuControl := TONURNavButton(Component).ButtonControl
      else
        NavmenuControl := TONURNavMenuButton(Component);

      if NavmenuControl <> nil then
      begin
        Dec(Index, 3);
        if Index < NavmenuControl.ButtonCount then
          Result := 'Open ' + NavmenuControl.Buttons[Index].Name;
      end;
    end;
  end;
end;


function TONURButtonControlEditor.GetVerbCount: integer;
var
  NavmenuControl: TONURNavMenuButton;
  ButtonCount: integer;
begin
  ButtonCount := 0;
  if Component is TONURNavButton then
    NavmenuControl := TONURNavButton(Component).ButtonControl
  else
    NavmenuControl := TONURNavMenuButton(Component);

  if NavmenuControl <> nil then
    ButtonCount := NavmenuControl.ButtonCount;


  Result := 3 + ButtonCount;
end;


procedure TONURButtonControlEditor.ExecuteVerb(Index: integer);
var
  NavmenuControl: TONURNavMenuButton;
  Button: TONURNavButton;
begin
  if Component is TONURNavButton then
    NavmenuControl := TONURNavButton(Component).ButtonControl
  else
    NavmenuControl := TONURNavMenuButton(Component);

  if NavmenuControl <> nil then
  begin
    if Index = 0 then
    begin
      AddButton;
    end
    else
    if Index < 3 then
    begin
      Button := NavmenuControl.NextButton(NavmenuControl.ActiveButton, Index = 1);
      if (Button <> nil) and (Button <> NavmenuControl.ActiveButton) then
      begin
        NavmenuControl.ActiveButton := Button;
        if Component is TONURNavButton then
          GetDesigner.SelectOnlyThisComponent(Button);
        GetDesigner.Modified;
      end;
    end
    else
    begin
      Dec(Index, 3);
      if Index < NavmenuControl.ButtonCount then
      begin
        Button := NavmenuControl.Buttons[Index];
        if (Button <> nil) and (Button <> NavmenuControl.ActiveButton) then
        begin
          NavmenuControl.ActiveButton := Button;
          if Component is TONURNavButton then
            GetDesigner.SelectOnlyThisComponent(Button);
          GetDesigner.Modified;
        end;
      end;
    end;
  end;
end;

{ TONURButtonActiveButtonProperty }

function TONURButtonActiveButtonProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paValueList];
end;

procedure TONURButtonActiveButtonProperty.GetValues(Proc: TGetStrProc);
  var
    I: integer;
    Component: TComponent;
  begin
    if (GlobalDesignHook <> nil) and (GlobalDesignHook.LookupRoot <> nil) and
      (GlobalDesignHook.LookupRoot is TComponent) then
      for I := 0 to TComponent(GlobalDesignHook.LookupRoot).ComponentCount - 1 do
      begin
        Component := TComponent(GlobalDesignHook.LookupRoot).Components[I];
        if (Component.Name <> '') and (Component is TONURNavButton) and
          (TONURNavButton(Component).ButtonControl = GetComponent(0)) then
          Proc(Component.Name);
      end;
end; 

{ TONURsystemButton }


function TONURsystemButton.GetButtonType: TONURButtonType;
begin
  Result:=FButtonType;
end;

procedure TONURsystemButton.SetButtonType(AValue: TONURButtonType);
begin
  if AValue<>FButtonType then
  begin
    FButtonType:=AValue;
    case FButtonType of
      OBTNClose    : skinname := 'closebutton';
      OBTNMinimize : skinname := 'minimizebutton';
      OBTNMaximize : skinname := 'maximizebutton';
      OBTNHelp     : skinname := 'helpbutton';
    end;
  end;

end;


procedure TONURsystemButton.Click;
begin

  {$IFNDEF SKINBUILDIER}
  if Assigned(Skindata) and (Enabled) and not (csDesigning in ComponentState) then
  case FButtonType of
    OBTNClose    : GetFirstParentForm(self).close;//Skindata.Fparent.Close;
    OBTNMinimize : Application.Minimize; //Skindata.Fparent.WindowState:=wsma;
    OBTNMaximize :
    begin
      if Skindata.WindowState<>wsMaximized then
      Skindata.WindowState:=wsMaximized
      else
      Skindata.WindowState:=wsNormal;

      Skindata.Refresh;
    end;
    OBTNHelp     : 
      begin
        Application.HelpCommand(HELP_FINDER, 0);
      end;
  end;
  {$ENDIF}
end;

procedure TONURsystemButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURsystemButton.Resize;
begin
  inherited Resize;
end;

constructor TONURsystemButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonType       := OBTNClose;
  skinname          := 'closebutton';
  FNormal           := TONURCUSTOMCROP.Create('NORMAL');
  FPress            := TONURCUSTOMCROP.Create('PRESSED');
  FEnter            := TONURCUSTOMCROP.Create('HOVER');
  FDisable          := TONURCUSTOMCROP.Create('DISABLE');
  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(FDisable);

  FState            := obsNormal;
  Height            := 20;
  Width             := 20;
  Transparent       := True;
  FAutoWidth        := True;
  Resim.SetSize(Width, Height);

  //Align := alRight; // for parent right

end;

destructor TONURsystemButton.Destroy;
begin
  Customcroplist.Clear;
  inherited Destroy;
end;

procedure TONURsystemButton.Paint;
var
  DR: TRect;
begin

   if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

      if Enabled = True then
      begin
        case FState of
          obsNormal:
          begin
            DR := FNormal.Croprect;
            Self.Font.Color := FNormal.Fontcolor;
          end;
          obspressed:
          begin
            DR :=FPress.Croprect;
            Self.Font.Color := FPress.Fontcolor;
          end;
          obshover:
          begin
            DR :=FEnter.Croprect;
            Self.Font.Color := FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := FDisable.Croprect;
        Self.Font.Color := FDisable.Fontcolor;
      end;

      DrawPartstrech(DR, self, Width, Height, alpha);

  end
  else
  begin
    resim.Fill(BGRA(90, 90, 90), dmSet);
  end;
  inherited Paint;
end;

procedure TONURsystemButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obshover) then
  Exit;

  inherited MouseEnter;
  FState := obshover;
  Invalidate;
end;

procedure TONURsystemButton.MouseLeave;
begin
   if (csDesigning in ComponentState) then
  exit;
  if (Enabled = false) or (FState = obsnormal) then
  Exit;

  inherited MouseLeave;
  FState := obsnormal;
  Invalidate;
end;

procedure TONURsystemButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obspressed) then
  Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obspressed;
    Invalidate;
  end;
end;

procedure TONURsystemButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obshover) then
  Exit;


  inherited MouseUp(Button, Shift, X, Y);
  FState := obshover;
  Invalidate;
end;


{ TONURRadioButton }

procedure TONURRadioButton.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    deaktifdigerleri;
    doonchange;
    Invalidate;
  end;
end;

function TONURRadioButton.GetCheckWidth: integer;
begin
 Result := FCheckWidth;
end;

procedure TONURRadioButton.SetCheckWidth(AValue: integer);
begin
  if FCheckWidth = AValue then exit;
  FCheckWidth := AValue;
  Invalidate;
end;

procedure TONURRadioButton.SetCaptionmod(const val: TONURCapDirection);
begin
   if FCaptionDirection = val then
    exit;
  FCaptionDirection := val;
  Invalidate;
end;

function TONURRadioButton.GetCaptionmod: TONURCapDirection;
begin
  Result := FCaptionDirection;
end;

procedure TONURRadioButton.deaktifdigerleri;
var
  i: integer;
  Sibling: TControl;
begin
  if self.Parent = nil then exit;
  with self.Parent do
  begin
    for i := 0 to ControlCount - 1 do
    begin
      Sibling := Controls[i];
      if (Controls[i] is TONURRadioButton) and (Sibling <> Self) then
      begin
        TONURRadioButton(Sibling).FChecked:=false;
        TONURRadioButton(Sibling).FState := obsnormal;
        Invalidate;
      end;
    end;
  end;
end;

procedure TONURRadioButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURRadioButton.Resize;
begin
  inherited Resize;
end;

procedure TONURRadioButton.resizing;
begin
  //
end;

procedure TONURRadioButton.CMonmouseenter(var Messages: TLmessage);
begin
  FState := obshover;
  Invalidate;
end;

procedure TONURRadioButton.CMonmouseleave(var Messages: TLmessage);
begin
 FState := obsnormal;
  Invalidate;
end;

procedure TONURRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if FChecked=true then exit;

  if Button = mbLeft then
  begin
    FState := obspressed;
    SetChecked(true);
  end;
end;

procedure TONURRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FState := obshover;
  Invalidate;
end;

procedure TONURRadioButton.DoOnChange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TONURRadioButton.CMHittest(var msg: TCMHIttest);
begin
  inherited;
 {  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;   }
end;

constructor TONURRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname          := 'radiobox';
  FCheckWidth       := 12;
  FCaptionDirection := ocright;
  FState            := obsnormal;
  FChecked          := False;
  Captionvisible    := False;
  textx             := 10;
  Texty             := 10;
  obenter           := TONURCUSTOMCROP.Create('NORMALHOVER');
  obleave           := TONURCUSTOMCROP.Create('NORMAL');
  obdown            := TONURCUSTOMCROP.Create('PRESSED');
  obcheckleaves     := TONURCUSTOMCROP.Create('CHECK');
  obcheckenters     := TONURCUSTOMCROP.Create('CHECKHOVER');
  FDisableOn     := TONURCUSTOMCROP.Create('DISABLEON');
  FDisableOFF    := TONURCUSTOMCROP.Create('DISABLEOFF');

  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obenter);
  Customcroplist.Add(obleave);
  Customcroplist.Add(FDisableOn);
  Customcroplist.Add(FDisableOFF);
  Captionvisible := false;

end;

destructor TONURRadioButton.Destroy;
begin
 Customcroplist.Clear;
 inherited Destroy;
end;

procedure TONURRadioButton.Paint;
var
  DR: TRect;
  RadioRect: TRect;
  TextRect: TRect;
  TextStyle: TTextStyle;
begin
  if not Visible then Exit;
  
  // Prepare canvas
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  // Initialize radio button rectangle (fixed size)
  RadioRect := Rect(0, 0, FCheckWidth, FCheckWidth);
  
  // Calculate positions based on caption direction
  case FCaptionDirection of
    ocup: // Radio button above text
    begin
      RadioRect.Left := (self.ClientWidth - FCheckWidth) div 2;
      RadioRect.Top := 0;
      RadioRect.Right := RadioRect.Left + FCheckWidth;
      RadioRect.Bottom := FCheckWidth;
      
      TextRect.Left := 0;
      TextRect.Top := FCheckWidth + 2;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := self.ClientHeight;
    end;
    
    ocdown: // Radio button below text
    begin
      RadioRect.Left := (self.ClientWidth - FCheckWidth) div 2;
      RadioRect.Top := self.ClientHeight - FCheckWidth;
      RadioRect.Right := RadioRect.Left + FCheckWidth;
      RadioRect.Bottom := self.ClientHeight;
      
      TextRect.Left := 0;
      TextRect.Top := 0;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := RadioRect.Top - 2;
    end;
    
    ocleft: // Radio button left of text
    begin
      RadioRect.Left := 0;
      RadioRect.Top := (self.ClientHeight - FCheckWidth) div 2;
      RadioRect.Right := FCheckWidth;
      RadioRect.Bottom := RadioRect.Top + FCheckWidth;
      
      TextRect.Left := FCheckWidth + 5;
      TextRect.Top := 0;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := self.ClientHeight;
    end;
    
    ocright: // Radio button right of text
    begin
      RadioRect.Left := self.ClientWidth - FCheckWidth;
      RadioRect.Top := (self.ClientHeight - FCheckWidth) div 2;
      RadioRect.Right := self.ClientWidth;
      RadioRect.Bottom := RadioRect.Top + FCheckWidth;
      
      TextRect.Left := 0;
      TextRect.Top := 0;
      TextRect.Right := RadioRect.Left - 5;
      TextRect.Bottom := self.ClientHeight;
    end;
  end;

  // Skin drawing
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Select crop area based on state
    if Enabled then
    begin
      if Checked then
      begin
        case FState of
          obsNormal: DR := obcheckleaves.Croprect;
          obshover: DR := obcheckenters.Croprect;
          obspressed: DR := obdown.Croprect;
        end;
      end
      else
      begin
        case FState of
          obsNormal: DR := obleave.Croprect;
          obshover: DR := obenter.Croprect;
          obspressed: DR := obdown.Croprect;
        end;
      end;
    end
    else
    begin
      if Checked then
        DR := FDisableOn.Croprect
      else
        DR := FDisableOff.Croprect;
    end;
    
    // Draw radio button with skin
    DrawPartnormal(DR, Self, RadioRect, Alpha);
  end
  else
  begin
    // No skin - draw default radio button (ellipse)
    if Checked then
      resim.EllipseInRect(RadioRect, BGRA(0, 0, 0), BGRA(155, 155, 155), dmSet)
    else
      resim.EllipseInRect(RadioRect, BGRA(0, 0, 0), BGRA(255, 255, 255), dmSet);
  end;

  // Draw caption
  if Length(Caption) > 0 then
  begin
    TextStyle.Alignment := taCenter;
    TextStyle.Layout := tlCenter;
    TextStyle.Wordbreak := False;
    TextStyle.SingleLine := True;
    
    resim.FontName := self.font.Name;
    resim.FontHeight := 10 + self.font.Size;
    resim.TextRect(TextRect, 0, 0, Caption, TextStyle, ColorToBGRA(self.font.Color));
  end;

  inherited Paint;
end;


 {$IFDEF WINDOWS}
{ TOnThreadTimerClass }

procedure TOnThreadTimerClass.Call;
begin
  if Assigned(FOnCall) then
    FOnCall(FSender);
end;

procedure TOnThreadTimerClass.Execute;
begin
  try
    while not Terminated do
    begin

      WaitForSingleObject(self.Handle, FInterval);
      Synchronize(@Call);
    end;
  except
  end;
end;

{ TOnThreadTimer }

procedure TOnThreadTimer.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;

    if not (csDesigning in ComponentState) then
      if FEnabled then
        FThread.Resume
      else
        FThread.Suspend;
  end;
end;

function TOnThreadTimer.GetInterval: word;
begin
  Result := FThread.FInterval;
end;

procedure TOnThreadTimer.SetInterval(const Value: word);
begin
  FThread.FInterval := Value;
end;

function TOnThreadTimer.GetOnTimer: TNotifyEvent;
begin
  Result := FThread.FOnCall;
end;

procedure TOnThreadTimer.SetOnTimer(const Value: TNotifyEvent);
begin
  FThread.FOnCall := Value;
end;

constructor TOnThreadTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FThread := TOnThreadTimerClass.Create(True);
  FThread.FreeOnTerminate := True;
  FThread.FInterval := 1000;
  FThread.FOnCall := nil;
  FThread.FSender := Self;
end;

destructor TOnThreadTimer.Destroy;
begin
  FThread.Terminate;
  FThread.FSender := nil;
  inherited Destroy;
end;

{$ENDIF}
{ TONURNormalLabel }

function TONURNormalLabel.GetTextDefaultPos: smallint;
begin
  if (FBuffer.Width<self.ClientWidth) then
  Result := (self.ClientWidth - FBuffer.Width) div 2
  else
  Result :=0;

end;

procedure TONURNormalLabel.SetBilink(AValue: boolean);
begin
  if FBiLink = AValue then Exit;
  FBiLink := AValue;

  if not (csDesigning in ComponentState) then
  FBlinkTimer.Enabled:=AValue;

  if AValue=false then
  begin
    FBiLink:=false;
    Invalidate;
  end;

end;

procedure TONURNormalLabel.Setblinkinterval(AValue: integer);
begin
  if FBlinkInterval=AValue then Exit;
  FBlinkInterval:=AValue;
  FBlinkTimer.Interval:=AValue;

end;


procedure TONURNormalLabel.SetAnimate(AValue: boolean);
begin
  if AValue = FAnimate then exit;

  if AValue then
  begin
    FPos := GetTextDefaultPos;
    FWait := FWaiting;// Waiting;
    FDirection := tdLeftToRight;
    FAnimate := True;
    SetText(FText);
    FreeTimer;
    FTimer := {$IFDEF WINDOWS} TOnThreadTimer.Create(Self){$ELSE}TTimer.Create(Self){$ENDIF};
    FTimer.Interval := FTimerInterval;//100;
    FTimer.OnTimer := @TimerEvent;
    if not (csDesigning in ComponentState) then
    FTimer.Enabled := True;
  end
  else
  begin
    FreeTimer;
    FAnimate := False;
    FWait := 0;
    FPos := GetTextDefaultPos;
    SetText(FText);
  end;
end;

procedure TONURNormalLabel.Setclr(AValue: TBGRAPixel);
begin
  if clr = AValue then Exit;
  clr := AValue;
end;

procedure TONURNormalLabel.SetScrollBy(AValue: integer);
begin
  if FScrollBy = AValue then exit;
  FScrollBy := AValue;
end;



function TONURNormalLabel.GetScroll: integer;
begin
  Result := ABS(FScrollBy);
end;

procedure TONURNormalLabel.SetText(AValue: string);
begin
  FText := AValue;
  DrawFontText;
  FPos := GetTextDefaultPos;
  FDirection := tdLeftToRight;
  FWait := FWaiting;// Waiting;
  Invalidate;
end;

procedure TONURNormalLabel.Settimerinterval(AValue: integer);
begin
  if FTimerInterval=AValue then Exit;
  FTimerInterval:=AValue;
  if (FAnimate) and Assigned(FTimer) then
    FTimer.Interval := FTimerInterval;//100;
end;

procedure TONURNormalLabel.Setwaiting(AValue: byte);
begin
  if FWaiting=AValue then Exit;
  FWaiting:=AValue;
end;

procedure TONURNormalLabel.SetYazibuyuk(AValue: boolean);
begin
  if FYazibuyuk=AValue then Exit;
  FYazibuyuk:=AValue;
end;

procedure TONURNormalLabel.TimerEvent(Sender: TObject);
begin
  if FWait > 0 then
  begin
    Dec(FWait);
    Exit;
  end;
  
  // Update animation based on type
  if FAnimationType <> laNone then
    UpdateAnimation
  else
  begin
    // Original scroll behavior
    if (FBuffer.Width < self.Width) then
    begin

      if (FPos >= 0) and (FPos <= (self.Width - FBuffer.Width)) then
        if FDirection = tdRightToLeft then
          FPos -= FScrollBy
        else if FDirection = tdLeftToRight then
          FPos += FScrollBy;

      if FPos < 0 then
      begin
        FPos := 0;
        FDirection := tdLeftToRight;
        FWait := FWaiting;//Waiting;
      end;

      if FPos > (self.Width - FBuffer.Width) then
      begin
        FPos := (self.Width - FBuffer.Width);
        FDirection := tdRightToLeft;
        FWait := FWaiting;// Waiting;
      end;
    end else
    begin
      if (FPos >= -(FBuffer.Width - self.Width)) and (FPos <= (FBuffer.Width - self.Width)) then
       if FDirection = tdRightToLeft then
         FPos -=FScrollBy
       else if FDirection = tdLeftToRight then
          FPos += FScrollBy;
      if FPos > 0 then
      begin
        FPos := 0;
        FDirection := tdRightToLeft;
        FWait := FWaiting;//Waiting;
      end
      else
      if FPos < -(FBuffer.Width - self.Width) then
      begin
        FPos := -(FBuffer.Width - self.Width);
        FDirection := tdLeftToRight;
        FWait := FWaiting;//Waiting;
      end;
    end;
  end;
  
  Invalidate;
end;

procedure TONURNormalLabel.DrawFontText;
begin
  FBuffer.SetSize(0, 0);
  FBuffer.FontStyle:=self.Font.Style;
  FBuffer.FontName := self.font.Name;
  FBuffer.FontFullHeight := self.font.Size;
  FBuffer.SetSize(FBuffer.TextSize(FText).cx, self.ClientHeight);
  FBuffer.TextRect(FBuffer.ClipRect,FText,taLeftJustify,tlcenter,BGRAToColor(self.font.color));

  if FBuffer.Width> self.Width then
   FYazibuyuk:=true
  else
   FYazibuyuk:=false;
end;

procedure TONURNormalLabel.DrawFontTextcolor(incolor,outcolor:TBGRAPixel);
begin
  FBuffer.SetSize(0, 0);
  FBuffer.SetSize(FBuffer.TextSize(FText).cx, self.ClientHeight);
  FBuffer.FontName:=self.Font.Name;
  FBuffer.FontFullHeight:=-self.font.size;
  FBuffer.TextOut(0, 0, FText, BGRAToColor(self.font.color), False);

  if FBuffer.Width> self.Width then
   FYazibuyuk:=true
  else
   FYazibuyuk:=false;

  Invalidate;
end;


procedure TONURNormalLabel.FreeTimer;
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
    FTimer := nil;
  end;
end;

procedure TONURNormalLabel.Blinktimerevent(sender: TObject);
begin
  FBiLink:= not FBiLinki;
  FBiLinki:= not FBiLinki;
  if FAnimate=false then
  Invalidate;
end;

procedure TONURNormalLabel.Loaded;
begin
  inherited Loaded;
    DrawFontText;
end;

procedure TONURNormalLabel.Paint;
var
  DrawX, DrawY: integer;
  TempBuffer: TBGRABitmap;
  NewWidth:Int64;
  NewHeight:Int64;
  ScaledBuffer:TBGRABitmap;
  StartBGRA:TBGRAPixel;
  EndBGRA:TBGRAPixel;
  MixColor:TBGRAPixel;
begin
  Inherited Paint;
  
  // Apply animations if active
  if FAnimationType <> laNone then
  begin
    // Create temporary buffer for animation effects
    TempBuffer := TBGRABitmap.Create(FBuffer.Width, FBuffer.Height);
    try
      TempBuffer.PutImage(0, 0, FBuffer, dmDrawWithTransparency);
      
      // Apply animation effects
      case FAnimationType of
        laFade, laBlink, laPulse, laGlow, laStrobe:
        begin
          // Apply alpha effect
          TempBuffer.ReplaceColor(TempBuffer.GetPixel(0,0), BGRA(TempBuffer.GetPixel(0,0).red, TempBuffer.GetPixel(0,0).green, TempBuffer.GetPixel(0,0).blue, FCurrentAlpha));
        end;
        laScale:
        begin
          // Apply scale effect
           NewWidth := Round(FBuffer.Width * FCurrentScale);
           NewHeight := Round(FBuffer.Height * FCurrentScale);
           ScaledBuffer := TempBuffer.Resample(NewWidth, NewHeight, rmFineResample);
          TempBuffer.Assign(ScaledBuffer);
          ScaledBuffer.Free;
        end;
        laColor, laColorCycle, laRainbow:
        begin
          // Apply color effect
           StartBGRA := ColorToBGRA(FStartColor);
           EndBGRA := ColorToBGRA(FEndColor);
           MixColor := BGRA(
            Round(StartBGRA.red + (EndBGRA.red - StartBGRA.red) * FAnimationProgress),
            Round(StartBGRA.green + (EndBGRA.green - StartBGRA.green) * FAnimationProgress),
            Round(StartBGRA.blue + (EndBGRA.blue - StartBGRA.blue) * FAnimationProgress),
            FCurrentAlpha
          );
          TempBuffer.Fill(MixColor, dmLinearBlend);
        end;
        laBounce:
        begin
          // Apply bounce effect
          DrawY := Round(FCurrentBounce);
        end;
        laRotate:
        begin
          // Apply rotation effect (simplified - just offset)
          DrawX := Round(Sin(FCurrentRotation * Pi / 180) * 5);
          DrawY := Round(Cos(FCurrentRotation * Pi / 180) * 5);
        end;
        laShake, laWave, laRandom:
        begin
          // Apply shake/wave/random effect
          DrawX := Round(FCurrentShake);
          DrawY := Round(FCurrentShake / 2);
        end;
      end;
      
      // Draw the animated buffer
      if FBiLink then
      begin
        canvas.Brush.Color := clr;
        canvas.FillRect(ClientRect);
      end;
      
      DrawX := FPos;
      if DrawX = 0 then DrawX := FPos;
      if DrawY = 0 then DrawY := 0;
      
      TempBuffer.Draw(self.Canvas, DrawX, DrawY, False);
    finally
      TempBuffer.Free;
    end;
  end
  else
  begin
    // Original drawing without animations
    if FBiLink then
    begin
      canvas.Brush.Color := clr;
      canvas.FillRect(ClientRect);
    end;

    FBuffer.Draw(self.Canvas, FPos, 0, False);
  end;
end;



constructor TONURNormalLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width                 := 150;
  Height                := 30;
  FBuffer               := TBGRABitmap.Create;
  FTimer                := nil;
  FDirection            := tdLeftToRight;
  FStyle                := tsPingPong;
  FAnimate              := False;
  FText                 := 'ONNORMALLABEL';
  FWait                 := 0;
  FPos                  := 0;
  FScrollBy             := 8;
  FWaiting              := 15;
  FBlinkInterval        := 500;
  FTimerInterval        := 100;
  clr                   := clRed;
  FBiLink               := false;
  FYazibuyuk            := false;
  FBlinkTimer           := TTimer.Create(nil);
  FBlinkTimer.Enabled   := False;
  FBlinkTimer.Interval  := FBlinkInterval;
  FBlinkTimer.OnTimer   := @Blinktimerevent;

  // Initialize new animation properties
  FAnimationType := laNone;
  FAnimationProgress := 0.0;
  FAnimationSpeed := 0.02;
  FAnimationDirection := 1;
  FCurrentAlpha := 255;
  FCurrentScale := 1.0;
  FCurrentRotation := 0.0;
  FCurrentBounce := 0.0;
  FCurrentShake := 0.0;
  FStartColor := clWhite;
  FEndColor := clBlack;
  FLoopAnimation := False;

end;

destructor TONURNormalLabel.Destroy;
begin
  FreeTimer;
  if FBlinkTimer.Enabled then FBlinkTimer.Enabled:=false;

  FreeAndNil(FBlinkTimer);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;

// TONURNormalLabel Animation implementation
procedure TONURNormalLabel.SetAnimationType(Value: TONURAnimation);
begin
  if FAnimationType = Value then exit;
  FAnimationType := Value;
  FAnimationProgress := 0.0;
  FAnimationDirection := 1;
  Invalidate;
end;

procedure TONURNormalLabel.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then exit;
  FAnimationSpeed := Value;
  Invalidate;
end;

procedure TONURNormalLabel.SetLoopAnimation(Value: boolean);
begin
  if FLoopAnimation = Value then exit;
  FLoopAnimation := Value;
  Invalidate;
end;

procedure TONURNormalLabel.SetStartColor(Value: TColor);
begin
  if FStartColor = Value then exit;
  FStartColor := Value;
  Invalidate;
end;

procedure TONURNormalLabel.SetEndColor(Value: TColor);
begin
  if FEndColor = Value then exit;
  FEndColor := Value;
  Invalidate;
end;

procedure TONURNormalLabel.UpdateAnimation;
begin
  // Update animation progress
  FAnimationProgress := FAnimationProgress + (FAnimationSpeed * FAnimationDirection);
  
  // Handle animation boundaries
  if FAnimationProgress >= 1.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 0.0;
    end
    else
    begin
      FAnimationProgress := 1.0;
      FAnimationDirection := -1;
    end;
  end
  else if FAnimationProgress <= 0.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 1.0;
    end
    else
    begin
      FAnimationProgress := 0.0;
      FAnimationDirection := 1;
    end;
  end;
  
  // Apply specific animation
  case FAnimationType of
    laFade: ApplyFadeAnimation;
    laScale: ApplyScaleAnimation;
    laColor: ApplyColorAnimation;
    laBounce: ApplyBounceAnimation;
    laRotate: ApplyRotateAnimation;
    laShake: ApplyShakeAnimation;
    laBlink: ApplyFadeAnimation; // Use fade for blink
    laPulse: ApplyFadeAnimation; // Use fade for pulse
    laColorCycle: ApplyColorAnimation; // Use color for color cycle
    laGlow: ApplyFadeAnimation; // Use fade for glow
    laWave: ApplyShakeAnimation; // Use shake for wave
    laRainbow: ApplyColorAnimation; // Use color for rainbow
    laStrobe: ApplyFadeAnimation; // Use fade for strobe
    laRandom: ApplyShakeAnimation; // Use shake for random
  end;
end;

procedure TONURNormalLabel.ApplyFadeAnimation;
begin
  FCurrentAlpha := Round(255 * FAnimationProgress);
end;

procedure TONURNormalLabel.ApplyScaleAnimation;
begin
  FCurrentScale := 1.0 + (0.5 * Sin(FAnimationProgress * Pi * 2));
end;

procedure TONURNormalLabel.ApplyColorAnimation;
var
  StartBGRA: TBGRAPixel;
  EndBGRA: TBGRAPixel;
begin
  // Interpolate between start and end colors
  StartBGRA := ColorToBGRA(FStartColor);
  EndBGRA := ColorToBGRA(FEndColor);
  FCurrentAlpha := Round(StartBGRA.alpha + (EndBGRA.alpha - StartBGRA.alpha) * FAnimationProgress);
end;

procedure TONURNormalLabel.ApplyBounceAnimation;
begin
  FCurrentBounce := Abs(Sin(FAnimationProgress * Pi * 4)) * 10;
end;

procedure TONURNormalLabel.ApplyRotateAnimation;
begin
  FCurrentRotation := FAnimationProgress * 360;
end;

procedure TONURNormalLabel.ApplyShakeAnimation;
begin
  FCurrentShake := (Random(21) - 10) * FAnimationProgress; // -10 to +10
end;






{ TONURLed }

procedure TONURLed.Setledonoff(val: boolean);
Begin
  if val <> FCheck then
  begin
   FCheck:=val;
   if Assigned(FOnChange) then FOnChange(Self);
   Invalidate;
  End;
End;



constructor TONURLed.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  Self.Height           := 30;
  Self.Width            := 30;
  Fonclientp            := TONURCUSTOMCROP.Create('LEDONNORMAL');
  Fonclientph           := TONURCUSTOMCROP.Create('LEDONHOVER');
  Foffclientp           := TONURCUSTOMCROP.Create('LEDOFFNORMAL');
  Foffclientph          := TONURCUSTOMCROP.Create('LEDOFFHOVER');
  Fdisabled             := TONURCUSTOMCROP.Create('LEDDISABLE');

  Customcroplist.Add(Fonclientp);
  Customcroplist.Add(Fonclientph);
  Customcroplist.Add(Foffclientp);
  Customcroplist.Add(Foffclientph);
  Customcroplist.Add(Fdisabled);

  // Initialize animation properties
  FAnimationType := laNone;
  FAnimationProgress := 0.0;
  FAnimationSpeed := 0.05;
  FAnimationDirection := 1;
  FCurrentAlpha := 255;
  FCurrentColor := clRed;
  FStartColor := clRed;
  FEndColor := clLime;
  FLoopAnimation := False;
  FAnimationActive := False;
  FGlowRadius := 5;
  FShakeX := 0;
  FShakeY := 0;
  FWaveOffset := 0;
  FRainbowHue := 0;
  FStrobeState := True;
  FRandomValue := 0;

  // Create animation timer
  FAnimationTimer := TTimer.Create(nil);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.Interval := 50;
  FAnimationTimer.OnTimer := @DoAnimationTimer;

  skinname              := 'led';
  Skindata              := nil;
  FCheck                := true;
  Captionvisible        := False;
  resim.SetSize(self.clientWidth, self.clientHeight);
end;

// -----------------------------------------------------------------------------
destructor TONURLed.Destroy;
begin
  FAnimationTimer.Free;
  Customcroplist.Clear;
  inherited Destroy;
End;


procedure TONURLed.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURLed.Resize;
begin
  inherited Resize;
end;

procedure TONURLed.resizing;
begin

end;

// LED Animation implementation
procedure TONURLed.SetAnimationType(Value: TONURAnimation);
begin
  if FAnimationType = Value then exit;
  FAnimationType := Value;
  FAnimationProgress := 0.0;
  FAnimationDirection := 1;
  FAnimationActive := (Value <> laNone);
  FAnimationTimer.Enabled := FAnimationActive;
  Invalidate;
end;

procedure TONURLed.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then exit;
  FAnimationSpeed := Value;
  Invalidate;
end;

procedure TONURLed.SetLoopAnimation(Value: boolean);
begin
  if FLoopAnimation = Value then exit;
  FLoopAnimation := Value;
  Invalidate;
end;

procedure TONURLed.SetStartColor(Value: TColor);
begin
  if FStartColor = Value then exit;
  FStartColor := Value;
  Invalidate;
end;

procedure TONURLed.SetEndColor(Value: TColor);
begin
  if FEndColor = Value then exit;
  FEndColor := Value;
  Invalidate;
end;

procedure TONURLed.DoAnimationTimer(Sender: TObject);
begin
  if FAnimationType <> laNone then
    UpdateAnimation;
  Invalidate;
end;

procedure TONURLed.UpdateAnimation;
begin
  // Update animation progress
  FAnimationProgress := FAnimationProgress + (FAnimationSpeed * FAnimationDirection);
  
  // Handle animation boundaries
  if FAnimationProgress >= 1.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 0.0;
    end
    else
    begin
      FAnimationProgress := 1.0;
      FAnimationDirection := -1;
    end;
  end
  else if FAnimationProgress <= 0.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 1.0;
    end
    else
    begin
      FAnimationProgress := 0.0;
      FAnimationDirection := 1;
    end;
  end;
  
  // Apply specific animation
  case FAnimationType of
    laBlink: ApplyBlinkAnimation;
    laFade: ApplyFadeAnimation;
    laPulse: ApplyPulseAnimation;
    laColorCycle: ApplyColorCycleAnimation;
    laGlow: ApplyGlowAnimation;
    laShake: ApplyShakeAnimation;
    laWave: ApplyWaveAnimation;
    laRainbow: ApplyRainbowAnimation;
    laStrobe: ApplyStrobeAnimation;
    laRandom: ApplyRandomAnimation;
  end;
end;

procedure TONURLed.ApplyBlinkAnimation;
begin
  FCurrentAlpha := Round(255 * (1.0 - FAnimationProgress));
end;

procedure TONURLed.ApplyFadeAnimation;
begin
  FCurrentAlpha := Round(255 * FAnimationProgress);
end;

procedure TONURLed.ApplyPulseAnimation;
begin
  FCurrentAlpha := Round(255 * (0.5 + 0.5 * Sin(FAnimationProgress * Pi * 2)));
end;

procedure TONURLed.ApplyColorCycleAnimation;
var
  StartBGRA:TBGRAPixel;
  EndBGRA:TBGRAPixel;
begin
  // Simple color interpolation
   StartBGRA := ColorToBGRA(FStartColor);
    EndBGRA := ColorToBGRA(FEndColor);
  FCurrentColor := RGBToColor(
    Round(StartBGRA.red + (EndBGRA.red - StartBGRA.red) * FAnimationProgress),
    Round(StartBGRA.green + (EndBGRA.green - StartBGRA.green) * FAnimationProgress),
    Round(StartBGRA.blue + (EndBGRA.blue - StartBGRA.blue) * FAnimationProgress)
  );
end;

procedure TONURLed.ApplyGlowAnimation;
begin
  // Glow effect - increase radius with progress
  FGlowRadius := Round(5 + 10 * FAnimationProgress);
  FCurrentAlpha := Round(255 * (1.0 - FAnimationProgress * 0.5)); // Fade glow
end;

procedure TONURLed.ApplyShakeAnimation;
begin
  // Shake effect - random movement
  FShakeX := (Random(21) - 10) * FAnimationProgress; // -10 to +10
  FShakeY := (Random(21) - 10) * FAnimationProgress; // -10 to +10
end;

procedure TONURLed.ApplyWaveAnimation;
begin
  // Wave effect - sine wave movement
  FWaveOffset := Sin(FAnimationProgress * Pi * 4) * 5;
  FCurrentAlpha := Round(255 * (0.7 + 0.3 * Sin(FAnimationProgress * Pi * 2)));
end;

procedure TONURLed.ApplyRainbowAnimation;
begin
  // Rainbow effect - cycle through HSL colors
  FRainbowHue := FRainbowHue + FAnimationSpeed * 10;
  if FRainbowHue >= 360 then
    FRainbowHue := FRainbowHue - 360;
  FCurrentColor := GetRainbowColor(FRainbowHue);
  FCurrentAlpha := 255;
end;

procedure TONURLed.ApplyStrobeAnimation;
begin
  // Strobe effect - rapid on/off
  if Random(100) < (50 + 50 * Sin(FAnimationProgress * Pi * 20)) then
    FCurrentAlpha := 255
  else
    FCurrentAlpha := 0;
end;

procedure TONURLed.ApplyRandomAnimation;
begin
  // Random effect - mix of random values
  FRandomValue := Random;
  FCurrentAlpha := Round(255 * (0.3 + 0.7 * FRandomValue));
  FShakeX := (Random(11) - 5) * FRandomValue;
  FShakeY := (Random(11) - 5) * FRandomValue;
  
  // Random color changes
  if Random(100) < 10 then // 10% chance to change color
    FCurrentColor := RGBToColor(Random(256), Random(256), Random(256));
end;

function TONURLed.GetRainbowColor(Hue: real): TColor;
var
  R, G, B: byte;
  H, S, L: real;
  C:ValReal;
  X:ValReal;
  m:ValReal;
begin
  // Convert HSL to RGB (simplified)
  H := Hue / 60; // 0-6 range
  S := 1.0;
  L := 0.5;
  
  C := (1 - Abs(2 * L - 1)) * S;
  X := C * (1 - Abs((H - Round(H / 2) * 2) - 1));
  m := L - C / 2;
  
  if H < 1 then
  begin
    R := Round((C + m) * 255);
    G := Round((X + m) * 255);
    B := Round(m * 255);
  end
  else if H < 2 then
  begin
    R := Round((X + m) * 255);
    G := Round((C + m) * 255);
    B := Round(m * 255);
  end
  else if H < 3 then
  begin
    R := Round(m * 255);
    G := Round((C + m) * 255);
    B := Round((X + m) * 255);
  end
  else if H < 4 then
  begin
    R := Round(m * 255);
    G := Round((X + m) * 255);
    B := Round((C + m) * 255);
  end
  else if H < 5 then
  begin
    R := Round((X + m) * 255);
    G := Round(m * 255);
    B := Round((C + m) * 255);
  end
  else
  begin
    R := Round((C + m) * 255);
    G := Round(m * 255);
    B := Round((X + m) * 255);
  end;
  
  Result := RGBToColor(R, G, B);
end;

procedure TONURLed.Paint;
var
  TrgtRect, SrcRect: TRect;
  LEDColor: TBGRAPixel;
  tempAlpha:Int64;
  CenterX:Integer;
  CenterY:Integer;
  GlowColor:TBGRAPixel;
  i:Integer;
  fAlpha:Int64;
  OffsetX:Int64;
  OffsetY:Int64;
  WaveY:Int64;
  ColorBGRA:TBGRAPixel;
  OffsetRect1:TRect;
begin
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);
  
  // Apply animations if active
  if FAnimationType <> laNone then
  begin
    if (Skindata <> nil) and not (csDesigning in ComponentState) then
    begin
      try
        if FCheck then
        begin
          if FMouseOn=false then
           SrcRect :=Fonclientp.Croprect
          else
           SrcRect := Fonclientph.Croprect;
        end else
        begin
          if FMouseOn=false then
           SrcRect := Foffclientp.Croprect
          else
           SrcRect := Foffclientph.Croprect;
        End;
        TrgtRect := Rect(0, 0, self.ClientWidth,self.ClientHeight);
        
        // Apply animation effects to skin drawing
        case FAnimationType of
          laBlink, laFade, laPulse:
          begin
            // Apply alpha effect
            tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, TrgtRect, tempAlpha);
          end;
          laColorCycle, laRainbow:
          begin
            // Apply color effect (simplified - just use alpha)
            tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, TrgtRect, tempAlpha);
          end;
          laGlow:
          begin
            // Draw glow effect with skin
            tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, TrgtRect, tempAlpha);
            
            // Add glow overlay
             CenterX := resim.Width div 2;
             CenterY := resim.Height div 2;
             GlowColor := ColorToBGRA(clYellow);
            GlowColor.alpha := Round(Alpha * 0.2);
            
            for  i := FGlowRadius downto 1 do
            begin
              fAlpha := Round(GlowColor.alpha * (i / FGlowRadius));
              resim.FillEllipseAntialias(CenterX, CenterY, i, i, BGRA(GlowColor.red, GlowColor.green, GlowColor.blue, fAlpha));
            end;
          end;
          laShake:
          begin
            // Apply shake offset to skin
             OffsetX := Round(FShakeX);
             OffsetY := Round(FShakeY);
             OffsetRect1 := Rect(OffsetX, OffsetY, OffsetX + self.ClientWidth, OffsetY + self.ClientHeight);
             tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, OffsetRect1, tempAlpha);
          end;
          laWave:
          begin
            // Apply wave offset to skin
             WaveY := Round(FWaveOffset);
             OffsetRect1 := Rect(0, WaveY, self.ClientWidth, WaveY + self.ClientHeight);
             tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, OffsetRect1, tempAlpha);
          end;
          laStrobe:
          begin
            // Apply strobe to skin
            if FCurrentAlpha > 0 then
            begin
              tempAlpha := Alpha;
              DrawPartnormal(SrcRect, self, TrgtRect, tempAlpha);
            end;
          end;
          laRandom:
          begin
            // Apply random offset to skin
             OffsetX := Round(FShakeX);
             OffsetY := Round(FShakeY);
             OffsetRect1 := Rect(OffsetX, OffsetY, OffsetX + self.ClientWidth, OffsetY + self.ClientHeight);
             tempAlpha := Round(Alpha * (FCurrentAlpha / 255));
            DrawPartnormal(SrcRect, self, OffsetRect1, tempAlpha);
          end;
        end;
      finally
        //  FreeAndNil(img);
      end;
    end
    else
    begin
      // Default drawing with animations
      case FAnimationType of
        laBlink, laFade, laPulse:
        begin
          if FCheck then
            LEDColor := BGRA(115, 115, 115, FCurrentAlpha)
          else
            LEDColor := BGRA(90, 90, 90, FCurrentAlpha);
          resim.Fill(LEDColor, dmSet);
        end;
        laColorCycle, laRainbow:
        begin
           ColorBGRA := ColorToBGRA(FCurrentColor);
          ColorBGRA.alpha := FCurrentAlpha;
          resim.Fill(ColorBGRA, dmSet);
        end;
        laGlow:
        begin
          // Draw glow effect
           CenterX := resim.Width div 2;
           CenterY := resim.Height div 2;
           GlowColor := ColorToBGRA(clYellow);
          GlowColor.alpha := Round(FCurrentAlpha * 0.3);
          
          // Draw multiple circles for glow
          for  i := FGlowRadius downto 1 do
          begin
            fAlpha := Round(GlowColor.alpha * (i / FGlowRadius));
            resim.FillEllipseAntialias(CenterX, CenterY, i, i, BGRA(GlowColor.red, GlowColor.green, GlowColor.blue, fAlpha));
          end;
          
          // Draw center LED
          if FCheck then
            LEDColor := BGRA(255, 255, 200, FCurrentAlpha)
          else
            LEDColor := BGRA(100, 100, 100, FCurrentAlpha);
          resim.FillEllipseAntialias(CenterX, CenterY, 5, 5, LEDColor);
        end;
        laShake:
        begin
          // Draw with shake offset
           OffsetX := Round(FShakeX);
           OffsetY := Round(FShakeY);
          if FCheck then
            LEDColor := BGRA(115, 115, 115, FCurrentAlpha)
          else
            LEDColor := BGRA(90, 90, 90, FCurrentAlpha);
          resim.FillRect(OffsetX, OffsetY, OffsetX + resim.Width, OffsetY + resim.Height, LEDColor, dmSet);
        end;
        laWave:
        begin
          // Draw wave effect
           WaveY := Round(FWaveOffset);
          if FCheck then
            LEDColor := BGRA(115, 115, 115, FCurrentAlpha)
          else
            LEDColor := BGRA(90, 90, 90, FCurrentAlpha);
          resim.FillRect(0, WaveY, resim.Width, WaveY + resim.Height, LEDColor, dmSet);
        end;
        laStrobe:
        begin
          // Draw strobe effect
          if FCurrentAlpha > 0 then
          begin
            if FCheck then
              LEDColor := BGRA(255, 255, 255, FCurrentAlpha)
            else
              LEDColor := BGRA(50, 50, 50, FCurrentAlpha);
            resim.Fill(LEDColor, dmSet);
          end;
        end;
        laRandom:
        begin
          // Draw random effect
           OffsetX := Round(FShakeX);
           OffsetY := Round(FShakeY);
           ColorBGRA := ColorToBGRA(FCurrentColor);
          ColorBGRA.alpha := FCurrentAlpha;
          resim.FillRect(OffsetX, OffsetY, OffsetX + resim.Width, OffsetY + resim.Height, ColorBGRA, dmSet);
        end;
      end;
    end;
  end
  else
  begin
    // Original drawing without animations
    if (Skindata <> nil) and not (csDesigning in ComponentState) then
    begin
      try
        if FCheck then
        begin
          if FMouseOn=false then
           SrcRect :=Fonclientp.Croprect
          else
           SrcRect := Fonclientph.Croprect;
        end else
        begin
          if FMouseOn=false then
           SrcRect := Foffclientp.Croprect
          else
           SrcRect := Foffclientph.Croprect;
        End;
        TrgtRect := Rect(0, 0, self.ClientWidth,self.ClientHeight);
        DrawPartnormal(SrcRect, self, TrgtRect, Alpha);
      finally
        //  FreeAndNil(img);
      end;
    end
    else
    begin
     if FCheck then
      resim.Fill(BGRA(115, 115, 115,alpha), dmSet)
     else
      resim.Fill(BGRA(90, 90, 90,alpha), dmSet);
    end;
  end;
  
  inherited Paint;
End;

procedure TONURLed.MouseEnter;
Begin
  Inherited Mouseenter;
  FMouseOn:=true;
  Invalidate;
End;

procedure TONURLed.MouseLeave;
Begin
  Inherited Mouseleave;
  FMouseOn:=false;
  Invalidate;
End;



{ TONURLabel }


function TONURlabel.GetScrollBy: integer;
begin
  Result := ABS(FScrollBy);
end;

procedure TONURlabel.SetActive(Value: boolean);
begin
  if Value <> FActive then
  begin
    FActive := Value;
    if FActive then
    begin
      Activate;
    end
    else
      Deactivate;
    FWaiting := False;
  end;
end;

procedure TONURlabel.Setcaption(Avalue: Tcaption);
begin
  if FCaption = Avalue then Exit;
  FCaption := Avalue;
  Getbmp;
  Invalidate;
end;

procedure TONURlabel.SetStretch(Value: boolean);
var
  Rec: TRect;
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    Rec.Top := 0;
    Rec.Left := 0;
    Rec.Bottom := Height;
    Rec.Right := Width;
    Canvas.Brush.Color := Color;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rec);
    Invalidate;
  end;
  if not FStretch then FScale := 1;
end;

procedure TONURlabel.SetInterval(Value: cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    FTimer.Interval := Value;
  end;
end;



procedure TONURlabel.Activate;
begin
  FActive := True;
  FTimer.Enabled := True;
  FTimer.Interval := FInterval;
  FWaiting := False;

  FCurPos := 0;
  FScrollBy := ABS(FScrollBy);
  Invalidate;
end;

procedure TONURlabel.Deactivate;
begin
  FTimer.Enabled := False;
  FActive := False;
  Invalidate;
end;

procedure TONURlabel.UpdatePos;
begin
  if (Length(Caption) * CharWidth) * FScale > Self.Width then
  begin
    FCurPos := FCurPos + FScrollBy;
    if FCurPos <= 0 then
    begin
      FScrollBy := Abs(FScrollBy);
      if FWait <> 0 then
      begin
        FWaiting := True;
        FTimer.Interval := FWait;
      end;
    end;

    if (Length(Caption) * CharWidth - (FCurPos)) <=
      (Self.Width / FScale) then
    begin
      FScrollBy := Abs(FScrollBy) * -1;
      if FWait <> 0 then
      begin
        FWaiting := True;
        FTimer.Interval := FWait;
      end;
    end;
  end
  else
    FCurPos := 0;

end;

procedure TONURlabel.DoOnTimer(Sender: TObject);
begin
  if FWaiting then
  begin
    FTimer.Interval := FInterval;
    FWaiting := False;
  end;

  // Update animation based on type
  if FAnimationType <> laNone then
    UpdateAnimation
  else
    UpDatePos;
    
  Invalidate;
end;

procedure TONURlabel.SetCharWidth(Value: integer);
begin
  if Value = CharWidth then exit;
  FCharWidth := Value;
  Getbmp;
  Invalidate;
end;

procedure TONURlabel.SetCharHeight(Value: integer);
begin
  if Value = CharHeight then exit;
  FCharHeight := Value;
  Getbmp;
  Invalidate;
end;



procedure TONURlabel.SetString(AValue: TStringList);
begin
  if AValue = nil then
    Flist.Clear
  else
    Flist.Assign(AValue);
  Getbmp;
  Invalidate;
end;

procedure TONURlabel.SetAnimationType(Value: TONURAnimation);
begin
  if FAnimationType = Value then exit;
  FAnimationType := Value;
  FAnimationProgress := 0.0;
  FAnimationDirection := 1;
  Invalidate;
end;

procedure TONURlabel.SetAnimationSpeed(Value: real);
begin
  if FAnimationSpeed = Value then exit;
  FAnimationSpeed := Value;
  Invalidate;
end;

procedure TONURlabel.SetLoopAnimation(Value: boolean);
begin
  if FLoopAnimation = Value then exit;
  FLoopAnimation := Value;
  Invalidate;
end;

procedure TONURlabel.SetStartColor(Value: TColor);
begin
  if FStartColor = Value then exit;
  FStartColor := Value;
  Invalidate;
end;

procedure TONURlabel.SetEndColor(Value: TColor);
begin
  if FEndColor = Value then exit;
  FEndColor := Value;
  Invalidate;
end;

procedure TONURlabel.UpdateAnimation;
begin
  // Update animation progress
  FAnimationProgress := FAnimationProgress + (FAnimationSpeed * FAnimationDirection);
  
  // Handle animation boundaries
  if FAnimationProgress >= 1.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 0.0;
    end
    else
    begin
      FAnimationProgress := 1.0;
      FAnimationDirection := -1;
    end;
  end
  else if FAnimationProgress <= 0.0 then
  begin
    if FLoopAnimation then
    begin
      FAnimationProgress := 1.0;
    end
    else
    begin
      FAnimationProgress := 0.0;
      FAnimationDirection := 1;
    end;
  end;
  
  // Apply specific animation
  case FAnimationType of
    laFade: ApplyFadeAnimation;
    laScale: ApplyScaleAnimation;
    laColor: ApplyColorAnimation;
    laBounce: ApplyBounceAnimation;
    laRotate: ApplyRotateAnimation;
    laShake: ApplyShakeAnimation;
  end;
end;

procedure TONURlabel.ApplyFadeAnimation;
begin
  FCurrentAlpha := Round(255 * FAnimationProgress);
end;

procedure TONURlabel.ApplyScaleAnimation;
begin
  FCurrentScale := 1.0 + (0.5 * Sin(FAnimationProgress * Pi * 2));
end;

procedure TONURlabel.ApplyColorAnimation;
var
  StartBGRA, EndBGRA: TBGRAPixel;
begin
  // Convert TColor to TBGRAPixel
  StartBGRA := ColorToBGRA(FStartColor);
  EndBGRA := ColorToBGRA(FEndColor);
  
  // Interpolate between start and end colors
  FCurrentAlpha := Round(StartBGRA.alpha + (EndBGRA.alpha - StartBGRA.alpha) * FAnimationProgress);
end;

procedure TONURlabel.ApplyBounceAnimation;
begin
  FCurrentBounce := Abs(Sin(FAnimationProgress * Pi * 4)) * 5;
end;

procedure TONURlabel.ApplyRotateAnimation;
begin
  FCurrentRotation := FAnimationProgress * 360;
end;

procedure TONURlabel.ApplyShakeAnimation;
begin
  FCurrentShake := (Random(10) - 5) * FAnimationProgress;
end;

procedure TONURlabel.listchange(Sender: TObject);
begin
  Getbmp;
end;



constructor TONURlabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'label';
  FClientP := TONURCUSTOMCROP.Create('CLIENT');
  Customcroplist.Add(FClientP);

  FInterval := 100;
  FBitmap := TBGRABitmap.Create;
  tempbitmap:= TBGRABitmap.Create;

  FCharWidth := 21;
  FCharHeight := 27;
  FScale := 1;
  FStretch := True;
  FScrollBy := 2;
  FWait := 1000;

  // Initialize new animation properties
  FAnimationType := laNone;
  FAnimationProgress := 0.0;
  FAnimationDirection := 1;
  FCurrentAlpha := 255;
  FCurrentScale := 1.0;
  FCurrentRotation := 0.0;
  FCurrentBounce := 0.0;
  FCurrentShake := 0.0;
  FStartColor := clWhite;
  FEndColor := clBlack;
  FAnimationSpeed := 0.02;
  FLoopAnimation := False;

  Self.Height := FCharHeight * 2;
  Self.Width := 100;
  resim.SetSize(Width, Height);
  Captionvisible := False;
  Caption := '0';






  FTimer := TTimer.Create(nil);
  with FTimer do
  begin
    Enabled := False;
    Interval := FInterval;
    OnTimer := @DoOnTimer;
  end;
  FActive := False;
  //Activate;
  FList := TStringList.Create;
  FList.add('ABCDEFGHIJKLMNOPQRSTUVWXYZQXW');
  FList.add('0123456789:.,<> ');

  Skindata := nil;

  FCharWidth  := tempbitmap.TextSize('ABCDEFGHIJKLMNOPQRSTUVWXYZQXW').cx div 32;
  FCharHeight := tempbitmap.TextSize('AG').cy;// * 2) div FList.Count;

  //ShowMessage(inttostr(FCharWidth)+'   '+inttostr(FCharHeight));
  Getbmp;
end;

// ...
destructor TONURlabel.Destroy;
begin
  Deactivate;
  FBitmap.Free;
  tempbitmap.Free;
  FTimer.Free;
  FList.Free;
//  fclientp.Free;
  Customcroplist.Clear;
  inherited Destroy;
end;


procedure TONURlabel.Getbmp;
var
  i, w, h, a, n: integer;
  tmpText:
{$IFDEF FPC}AnsiString{$ELSE}
  string
{$ENDIF}
  ;
  s, ch: string;

 ucIter: TUnicodeCharacterEnumerator;
 partial: TBGRACustomBitmap;
begin
  FBitmap.SetSize(0,0);
  if self.Caption = '' then exit;

  if tempbitmap.Empty then exit;

 // if (Skindata = nil) then  exit;


  if Caption <> '' then
    w := (Length(self.Caption) * CharWidth)
  else
    w := Self.Width;

  FBitmap.SetSize(w, CharHeight);

  tmpText := self.Caption;
  s := AnsiUpperCase(tmpText);

  i := 0;
  for ch in s do
  begin
    w := 0;
    h := 0;
    a := 0;
    for n := 0 to FList.Count - 1 do
    begin
      ucIter := TUnicodeCharacterEnumerator.Create(FList[n]);
      while ucIter.MoveNext do
      begin
        if ch = ucIter.Current then
        begin
          w := a * CharWidth;
          h := n * CharHeight;
        end;
        Inc(a);
      end;
      ucIter.Free;
      a := 0;
    end;

    partial:=tempbitmap.GetPart( Rect(w, h, w + CharWidth, h + CharHeight));
    if partial <> nil then
     FBitmap.StretchPutImage(Rect((i * CharWidth), 0, (i * CharWidth)+ CharWidth, CharHeight), partial, dmDrawWithTransparency, Alpha);

    FreeAndNil(partial);
    Inc(i);
  end;
 end;


procedure TONURlabel.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  if FList.Count<1 then exit;
  FCharWidth  := FClientP.Croprect.Width div UTF8LengthFast(FList[0]);
  FCharHeight := FClientP.Croprect.Height div FList.Count;


end;

procedure TONURlabel.Resize;
begin
  inherited Resize;
end;

procedure TONURlabel.resizing;
begin

end;

procedure TONURlabel.paint;
var
  TrgtRect: TRect;
 rotatedImg,  scaledImg, img: TBGRACustomBitmap;
   offsetY,offsetx,i:integer;
begin
  if not Visible then exit;



 if (Skindata <> nil) and not (csDesigning in ComponentState) then
 begin

    resim.SetSize(0,0);

    resim.Setsize((Length(self.Caption) * CharWidth),self.ClientHeight);
    resim.Fill(BGRAPixelTransparent);
    tempbitmap.SetSize(0,0);

    tempbitmap.SetSize(FClientP.Croprect.Width, FClientP.Croprect.Height);
    FBitmap.SetSize(0,0);

    TrgtRect := Rect(0, 0, tempbitmap.Width, tempbitmap.Height);
    DrawPartnormalbmp(FClientP.Croprect, self, tempbitmap, TrgtRect, Alpha);
    Getbmp;

 end
 else
 begin
   resim.SetSize(0,0);
   resim.Setsize((Length(self.Caption) * CharWidth),self.ClientHeight);
   resim.Fill(BGRAPixelTransparent);
   FBitmap.SetSize(0,0);

   tempbitmap.SetSize(0,0);

   if Strings.count>0 then
   begin
    tempbitmap.SetSize((32 * CharWidth),CharHeight*FList.count);
    tempbitmap.Fill(BGRAPixelTransparent);
    for i:=0 to FList.Count - 1 do
    tempbitmap.TextOut(0,i*tempbitmap.TextSize(FList[i]).cy ,FList[i],BGRAWhite);
   end;
  // tempbitmap.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\aa.png');
   Getbmp;
 end;




  // Apply animations based on type
  if FAnimationType <> laNone then
  begin
    case FAnimationType of
      laFade:
      begin
        // Apply fade effect
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height));
          if img <> nil then
          begin
            img.ApplyGlobalOpacity(FCurrentAlpha);
            resim.PutImage(0,0,img,dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            img.ApplyGlobalOpacity(FCurrentAlpha);
            resim.PutImage(0,0,img,dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end;
      end;
      
      laScale:
      begin
        // Apply scale effect
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            img.ResampleFilter := rfBestQuality;
            scaledImg := img.Resample(Round(img.Width * FCurrentScale), Round(img.Height * FCurrentScale), rmSimpleStretch);
            offsetX := (resim.Width - scaledImg.Width) div 2;
            offsetY := (resim.Height - scaledImg.Height) div 2;
            resim.Fill(BGRAPixelTransparent);
            resim.PutImage(offsetX, offsetY, scaledImg, dmDrawWithTransparency);
            scaledImg.Free;
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            img.ResampleFilter := rfBestQuality;
             scaledImg := img.Resample(Round(img.Width * FCurrentScale), Round(img.Height * FCurrentScale), rmSimpleStretch);
             offsetX := (resim.Width - scaledImg.Width) div 2;
             offsetY := (resim.Height - scaledImg.Height) div 2;
            resim.Fill(BGRAPixelTransparent);
            resim.PutImage(offsetX, offsetY, scaledImg, dmDrawWithTransparency);
            scaledImg.Free;
          end;
          FreeAndNil(img);
        end;
      end;
      
      laBounce:
      begin
        // Apply bounce effect
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height));
          if img <> nil then
          begin
            resim.PutImage(0, Round(FCurrentBounce), img, dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            resim.PutImage(0, Round(FCurrentBounce), img, dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end;
      end;
      
      laShake:
      begin
        // Apply shake effect
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height));
          if img <> nil then
          begin
            resim.PutImage(Round(FCurrentShake), 0, img, dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            resim.PutImage(Round(FCurrentShake), 0, img, dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end;
      end;
      
      laRotate:
      begin
        // Apply rotation effect
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height));
          if img <> nil then
          begin
             // Use RotateCW based on rotation angle
             if FCurrentRotation >= 0 then
               rotatedImg := img.RotateCW(true)   // Clockwise
             else
               rotatedImg := img.RotateCW(false); // Counter-clockwise
             offsetX := (resim.Width - rotatedImg.Width) div 2;
             offsetY := (resim.Height - rotatedImg.Height) div 2;
            resim.Fill(BGRAPixelTransparent);
            resim.PutImage(offsetX, offsetY, rotatedImg, dmDrawWithTransparency);
            rotatedImg.Free;
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            // Use RotateCW based on rotation angle
            if FCurrentRotation >= 0 then
              rotatedImg := img.RotateCW(true)   // Clockwise
            else
              rotatedImg := img.RotateCW(false); // Counter-clockwise
            offsetX := (resim.Width - rotatedImg.Width) div 2;
            offsetY := (resim.Height - rotatedImg.Height) div 2;
            resim.Fill(BGRAPixelTransparent);
            resim.PutImage(offsetX, offsetY, rotatedImg, dmDrawWithTransparency);
            rotatedImg.Free;
          end;
          FreeAndNil(img);
        end;
      end;
      
      laColor:
      begin
        // Apply color effect (use alpha for color transition)
        if FActive then
        begin
          img := FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height));
          if img <> nil then
          begin
            img.ApplyGlobalOpacity(FCurrentAlpha);
            resim.PutImage(0,0,img,dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end
        else
        begin
          img := FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight));
          if img <> nil then
          begin
            img.ApplyGlobalOpacity(FCurrentAlpha);
            resim.PutImage(0,0,img,dmDrawWithTransparency);
          end;
          FreeAndNil(img);
        end;
      end;
    end;
  end
  else
  begin
    // Original scroll behavior
    if not FStretch then
    begin
      if FActive then
        resim:=FBitmap.GetPart(rect(FCurPos, 0,FBitmap.Width,FBitmap.Height))
      else
        resim.PutImage(0,0,FBitmap,dmDrawWithTransparency);
    end
    else
    begin
      FScale :=  resim.Height / CharHeight;
      if FActive then
      begin
           img := FBitmap.GetPart(rect(FCurPos,0,FBitmap.Width, CharHeight));
        if img <> nil then
        begin
          img.ResampleFilter := rfBestQuality;
          BGRAReplace(resim, img.Resample(img.Width, resim.Height, rmSimpleStretch));
        end;
        FreeAndNil(img);
      end else
        resim.StretchPutImage(rect(0,0,self.ClientWidth,self.ClientHeight),FBitmap.GetPart(Rect(0,0,FBitmap.Width, CharHeight)),dmDrawWithTransparency, Alpha);
    end;
  end;

  inherited paint;
end;





{ TONURCropButton }

// -----------------------------------------------------------------------------
constructor TONURCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.Width              := 100;
  self.Height             := 30;
  FOldWidth               := Width;
  FOldHeight              := Height;
  FState                  := obsNormal;
  FAutoWidth              := false;
  crop                    := True;
  resim.SetSize(ClientWidth, ClientHeight); 

  skinname                := 'cropbutton';
  FNormalTL               := TONURCUSTOMCROP.Create('NORMALTOPLEFT');
  FNormalTR               := TONURCUSTOMCROP.Create('NORMALTOPRIGHT');
  FNormalT                := TONURCUSTOMCROP.Create('NORMALTOP');
  FNormalBL               := TONURCUSTOMCROP.Create('NORMALBOTTOMLEFT');
  FNormalBR               := TONURCUSTOMCROP.Create('NORMALBOTTOMRIGHT');
  FNormalB                := TONURCUSTOMCROP.Create('NORMALBOTTOM');
  FNormalL                := TONURCUSTOMCROP.Create('NORMALLEFT');
  FNormalR                := TONURCUSTOMCROP.Create('NORMALRIGHT');
  FNormalC                := TONURCUSTOMCROP.Create('NORMALCENTER');

  FHoverTL                := TONURCUSTOMCROP.Create('HOVERTOPLEFT');
  FHoverTR                := TONURCUSTOMCROP.Create('HOVERTOPRIGHT');
  FHoverT                 := TONURCUSTOMCROP.Create('HOVERTOP');
  FHoverBL                := TONURCUSTOMCROP.Create('HOVERBOTTOMLEFT');
  FHoverBR                := TONURCUSTOMCROP.Create('HOVERBOTTOMRIGHT');
  FHoverB                 := TONURCUSTOMCROP.Create('HOVERBOTTOM');
  FHoverL                 := TONURCUSTOMCROP.Create('HOVERLEFT');
  FHoverR                 := TONURCUSTOMCROP.Create('HOVERRIGHT');
  FHoverC                 := TONURCUSTOMCROP.Create('HOVERCENTER');

  FPressTL                := TONURCUSTOMCROP.Create('PRESSTOPLEFT');
  FPressTR                := TONURCUSTOMCROP.Create('PRESSTOPRIGHT');
  FPressT                 := TONURCUSTOMCROP.Create('PRESSTOP');
  FPressBL                := TONURCUSTOMCROP.Create('PRESSBOTTOMLEFT');
  FPressBR                := TONURCUSTOMCROP.Create('PRESSBOTTOMRIGHT');
  FPressB                 := TONURCUSTOMCROP.Create('PRESSBOTTOM');
  FPressL                 := TONURCUSTOMCROP.Create('PRESSLEFT');
  FPressR                 := TONURCUSTOMCROP.Create('PRESSRIGHT');
  FPressC                 := TONURCUSTOMCROP.Create('PRESSCENTER');

  FDisableTL              := TONURCUSTOMCROP.Create('DISABLETOPLEFT');
  FDisableTR              := TONURCUSTOMCROP.Create('DISABLETOPRIGHT');
  FDisableT               := TONURCUSTOMCROP.Create('DISABLETOP');
  FDisableBL              := TONURCUSTOMCROP.Create('DISABLEBOTTOMLEFT');
  FDisableBR              := TONURCUSTOMCROP.Create('DISABLEBOTTOMRIGHT');
  FDisableB               := TONURCUSTOMCROP.Create('DISABLEBOTTOM');
  FDisableL               := TONURCUSTOMCROP.Create('DISABLELEFT');
  FDisableR               := TONURCUSTOMCROP.Create('DISABLERIGHT');
  FDisableC               := TONURCUSTOMCROP.Create('DISABLECENTER');



  Customcroplist.Add(FNormalTL);
  Customcroplist.Add(FNormalTR);
  Customcroplist.Add(FNormalT);
  Customcroplist.Add(FNormalBL);
  Customcroplist.Add(FNormalBR);
  Customcroplist.Add(FNormalB);
  Customcroplist.Add(FNormalL);
  Customcroplist.Add(FNormalR);
  Customcroplist.Add(FNormalC);

  Customcroplist.Add(FHoverTL);
  Customcroplist.Add(FHoverTR);
  Customcroplist.Add(FHoverT);
  Customcroplist.Add(FHoverBL);
  Customcroplist.Add(FHoverBR);
  Customcroplist.Add(FHoverB);
  Customcroplist.Add(FHoverL);
  Customcroplist.Add(FHoverR);
  Customcroplist.Add(FHoverC);

  Customcroplist.Add(FPressTL);
  Customcroplist.Add(FPressTR);
  Customcroplist.Add(FPressT);
  Customcroplist.Add(FPressBL);
  Customcroplist.Add(FPressBR);
  Customcroplist.Add(FPressB);
  Customcroplist.Add(FPressL);
  Customcroplist.Add(FPressR);
  Customcroplist.Add(FPressC);

  Customcroplist.Add(FDisableTL);
  Customcroplist.Add(FDisableTR);
  Customcroplist.Add(FDisableT);
  Customcroplist.Add(FDisableBL);
  Customcroplist.Add(FDisableBR);
  Customcroplist.Add(FDisableB);
  Customcroplist.Add(FDisableL);
  Customcroplist.Add(FDisableR);
  Customcroplist.Add(FDisableC);
  Resizing;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TONURCropButton.Destroy;
begin
  Customcroplist.Clear;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.CheckAutoWidth;
var
  TextWidth, TextHeight: Integer;
  Padding: Integer;
begin
  if FAutoWidth then //and Assigned(resim) then
  begin
    FOldWidth  := Width;
    FOldHeight := Height;
    
    // Calculate text dimensions
    TextWidth := canvas.TextWidth(Caption);
    TextHeight := canvas.TextHeight(Caption);
    
    // Add padding (space around text)
    Padding := 10; // 5px left and right
    
    // Width: left padding + text + right padding + border widths
    Width := Padding + TextWidth + Padding + FNormalL.Croprect.Width + FNormalR.Croprect.Width;
    
    // Height: text height + padding + top/bottom borders
    Height := Padding + TextHeight + Padding + FNormalT.Croprect.Height + FNormalB.Croprect.Height;
    
    // Guarantee minimum dimensions
    if Width < 50 then Width := 50;
    if Height < 25 then Height := 25;
  end else
  begin
    Width      := FOldWidth;
    Height     := FOldHeight;
  end;

//  if Skindata<>nil then
//    setSkindata(self.Skindata); // resize
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.SetAutoWidth(const Value: boolean);
begin
  if FAutoWidth=value then exit;
  FAutoWidth := Value;
  CheckAutoWidth;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONURCropButton.GetAutoWidth: boolean;
begin
   Result:=FAutoWidth;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  // Initialize Targetrect when skin is loaded
  if Assigned(Aimg) then
    Resizing;
end;

procedure TONURCropButton.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURCropButton.Resizing;
begin
  // Check if crop parts are initialized before setting Targetrect
  if not Assigned(FNormalTL) then Exit;
  
  // Set Targetrect for all crop parts - needed for DrawPartnormal
  FNormalTL.Targetrect := Rect(0, 0, FNormalTL.Croprect.Width, FNormalTL.Croprect.Height);
  FNormalTR.Targetrect := Rect(self.clientWidth - FNormalTR.Croprect.Width,
    0, self.clientWidth, FNormalTR.Croprect.Height);
  FNormalT.Targetrect := Rect(FNormalTL.Croprect.Width, 0, self.clientWidth -
    FNormalTR.Croprect.Width, FNormalT.Croprect.Height);
  FNormalBL.Targetrect := Rect(0, self.ClientHeight - FNormalBL.Croprect.Height,
    FNormalBL.Croprect.Width, self.ClientHeight);
  FNormalBR.Targetrect := Rect(self.clientWidth - FNormalBR.Croprect.Width,
    self.clientHeight - FNormalBR.Croprect.Height, self.clientWidth, self.clientHeight);
  FNormalB.Targetrect := Rect(FNormalBL.Croprect.Width, self.clientHeight -
    FNormalB.Croprect.Height, self.clientWidth - FNormalBR.Croprect.Width, self.clientHeight);
  FNormalL.Targetrect := Rect(0, FNormalTL.Croprect.Height, FNormalL.Croprect.Width, self.clientHeight -
    FNormalBL.Croprect.Height);
  FNormalR.Targetrect := Rect(self.clientWidth - FNormalR.Croprect.Width, FNormalTR.Croprect.Height,
    self.clientWidth, self.clientHeight - FNormalBR.Croprect.Height);
  FNormalC.Targetrect := Rect(FNormalL.Croprect.Width, FNormalT.Croprect.Height, self.clientWidth -
    FNormalR.Croprect.Width, self.clientHeight - FNormalB.Croprect.Height);

  // Set Targetrect for Hover state
  FHoverTL.Targetrect := FNormalTL.Targetrect;
  FHoverTR.Targetrect := FNormalTR.Targetrect;
  FHoverT.Targetrect := FNormalT.Targetrect;
  FHoverBL.Targetrect := FNormalBL.Targetrect;
  FHoverBR.Targetrect := FNormalBR.Targetrect;
  FHoverB.Targetrect := FNormalB.Targetrect;
  FHoverL.Targetrect := FNormalL.Targetrect;
  FHoverR.Targetrect := FNormalR.Targetrect;
  FHoverC.Targetrect := FNormalC.Targetrect;

  // Set Targetrect for Press state
  FPressTL.Targetrect := FNormalTL.Targetrect;
  FPressTR.Targetrect := FNormalTR.Targetrect;
  FPressT.Targetrect := FNormalT.Targetrect;
  FPressBL.Targetrect := FNormalBL.Targetrect;
  FPressBR.Targetrect := FNormalBR.Targetrect;
  FPressB.Targetrect := FNormalB.Targetrect;
  FPressL.Targetrect := FNormalL.Targetrect;
  FPressR.Targetrect := FNormalR.Targetrect;
  FPressC.Targetrect := FNormalC.Targetrect;

  // Set Targetrect for Disable state
  FDisableTL.Targetrect := FNormalTL.Targetrect;
  FDisableTR.Targetrect := FNormalTR.Targetrect;
  FDisableT.Targetrect := FNormalT.Targetrect;
  FDisableBL.Targetrect := FNormalBL.Targetrect;
  FDisableBR.Targetrect := FNormalBR.Targetrect;
  FDisableB.Targetrect := FNormalB.Targetrect;
  FDisableL.Targetrect := FNormalL.Targetrect;
  FDisableR.Targetrect := FNormalR.Targetrect;
  FDisableC.Targetrect := FNormalC.Targetrect;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.Paint;
var
  tl,t,tr,bl,b,br,l,r,c: TRect;
  StateTL, StateTR, StateT, StateBL, StateBR, StateB, StateL, StateR, StateC: TONURCUSTOMCROP;
  FontColor: TColor;
begin
  if not Visible then exit;
  
  // Prepare canvas
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);
  
  // 9-part drawing if skin available
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
     // At the beginning of Paint method
    if not Assigned(FNormalTL) or (FNormalTL.Targetrect.Left = 0) then
      Resizing;

    // Select correct crop areas based on state
    if Enabled then
    begin
      case FState of
        obsNormal:
        begin
          StateTL := FNormalTL; StateTR := FNormalTR; StateT := FNormalT;
          StateBL := FNormalBL; StateBR := FNormalBR; StateB := FNormalB;
          StateL := FNormalL; StateR := FNormalR; StateC := FNormalC;
          FontColor := FNormalC.Fontcolor;
        end;
        obspressed:
        begin
          StateTL := FPressTL; StateTR := FPressTR; StateT := FPressT;
          StateBL := FPressBL; StateBR := FPressBR; StateB := FPressB;
          StateL := FPressL; StateR := FPressR; StateC := FPressC;
          FontColor := FPressC.Fontcolor;
        end;
        obshover:
        begin
          StateTL := FHoverTL; StateTR := FHoverTR; StateT := FHoverT;
          StateBL := FHoverBL; StateBR := FHoverBR; StateB := FHoverB;
          StateL := FHoverL; StateR := FHoverR; StateC := FHoverC;
          FontColor := FHoverC.Fontcolor;
        end
        else
        begin
          StateTL := FNormalTL; StateTR := FNormalTR; StateT := FNormalT;
          StateBL := FNormalBL; StateBR := FNormalBR; StateB := FNormalB;
          StateL := FNormalL; StateR := FNormalR; StateC := FNormalC;
          FontColor := FNormalC.Fontcolor;
        end;
      end;
    end
    else
    begin
      // Disabled state
      StateTL := FDisableTL; StateTR := FDisableTR; StateT := FDisableT;
      StateBL := FDisableBL; StateBR := FDisableBR; StateB := FDisableB;
      StateL := FDisableL; StateR := FDisableR; StateC := FDisableC;
      FontColor := FDisableC.Fontcolor;
    end;
    
    // Get crop areas
    tl := StateTL.Croprect;
    tr := StateTR.Croprect;
    t  := StateT.Croprect;
    bl := StateBL.Croprect;
    br := StateBR.Croprect;
    b  := StateB.Croprect;
    l  := StateL.Croprect;
    r  := StateR.Croprect;
    c  := StateC.Croprect;
    
    // 9-part drawing - scaled according to size
    DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c, FontColor);
    if Crop then
    CropToimg(resim);
  end
  else
  begin
    // Gradient drawing if no skin
    case FState of
      obsNormal:
        resim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
      obshover:
        resim.GradientFill(0, 0, Width, Height, BGRA(90, 90, 90), BGRA(120, 120, 120), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
      obspressed:
        resim.GradientFill(0, 0, Width, Height, BGRA(20, 20, 20), BGRA(40, 40, 40), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
    end;
  end;
  
  inherited Paint;
end;

procedure TONURCropButton.DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c: TRect; FontColor: TColor);
var
  CornerWidth, CornerHeight: Integer;
  TextRect: TRect;
  ttt:TTextStyle;
begin
  // Get corner dimensions
  CornerWidth := tl.Width;
  CornerHeight := tl.Height;
  
  // Draw corners - fixed size
  DrawPartnormal(tl, self, Rect(0, 0, CornerWidth, CornerHeight), Alpha);
  DrawPartnormal(tr, self, Rect(ClientWidth - CornerWidth, 0, ClientWidth, CornerHeight), Alpha);
  DrawPartnormal(bl, self, Rect(0, ClientHeight - CornerHeight, CornerWidth, ClientHeight), Alpha);
  DrawPartnormal(br, self, Rect(ClientWidth - CornerWidth, ClientHeight - CornerHeight, ClientWidth, ClientHeight), Alpha);
  
  // Draw edges - flexible size
  // Top edge
  DrawPartnormal(t, self, Rect(CornerWidth, 0, ClientWidth - CornerWidth, CornerHeight), Alpha);
  // Bottom edge
  DrawPartnormal(b, self, Rect(CornerWidth, ClientHeight - CornerHeight, ClientWidth - CornerWidth, ClientHeight), Alpha);
  // Left edge
  DrawPartnormal(l, self, Rect(0, CornerHeight, CornerWidth, ClientHeight - CornerHeight), Alpha);
  // Right edge
  DrawPartnormal(r, self, Rect(ClientWidth - CornerWidth, CornerHeight, ClientWidth, ClientHeight - CornerHeight), Alpha);
  
  // Draw center - flexible size
  DrawPartnormal(c, self, Rect(CornerWidth, CornerHeight, ClientWidth - CornerWidth, ClientHeight - CornerHeight), Alpha);
  
  // Draw text
  Self.Font.Color := FontColor;
  TextRect := Rect(CornerWidth + 5, CornerHeight + 2, ClientWidth - CornerWidth - 5, ClientHeight - CornerHeight - 2);
  ttt.Alignment:= taCenter;//, tlCenter,
  ttt.Layout:=tlCenter;
  resim.TextRect(TextRect, 0, 0, Caption,ttt, FontColor);
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obsnormal) then
  Exit;
  inherited MouseLeave;
  FState := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obspressed) then
  Exit;
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obspressed;
    Invalidate;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FState := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then    exit;
  if (Enabled=false) or (FState = obshover) then  Exit;
  inherited MouseEnter;
  FState := obshover;
  Invalidate;
end;
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURCropButton.CMHittest(var msg: TCMHittest);
begin
  inherited;
{  if csDesigning in ComponentState then
    Exit;
  if PtInRegion(WindowRgn, msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
  }
end;
// -----------------------------------------------------------------------------




{ TONURGraphicsButton }

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseEnter;
begin
 if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (FState = obshover) then
  Exit;
  inherited MouseEnter;
  FState := obshover;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FState := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then   exit;
  if (Enabled = false) or (FState = obsnormal) then  Exit;

  inherited MouseLeave;
  FState := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then  exit;
  if (Enabled=false) or (FState = obspressed) then  Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obspressed;
    Invalidate;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
constructor TONURGraphicsButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname                := 'button';
  FState                  := obsNormal;
  Width                   := 100;
  Height                  := 30;
  FOldWidth               := Width;
  FOldHeight              := Height;
  Transparent             := True;
  FAutoWidth              := false;
  //Skindata                := nil;
  resim.SetSize(ClientWidth, ClientHeight);

  FNormalTL               := TONURCUSTOMCROP.Create('NORMALTOPLEFT');
  FNormalTR               := TONURCUSTOMCROP.Create('NORMALTOPRIGHT');
  FNormalT                := TONURCUSTOMCROP.Create('NORMALTOP');
  FNormalBL               := TONURCUSTOMCROP.Create('NORMALBOTTOMLEFT');
  FNormalBR               := TONURCUSTOMCROP.Create('NORMALBOTTOMRIGHT');
  FNormalB                := TONURCUSTOMCROP.Create('NORMALBOTTOM');
  FNormalL                := TONURCUSTOMCROP.Create('NORMALLEFT');
  FNormalR                := TONURCUSTOMCROP.Create('NORMALRIGHT');
  FNormalC                := TONURCUSTOMCROP.Create('NORMALCENTER');

  FHoverTL                := TONURCUSTOMCROP.Create('HOVERTOPLEFT');
  FHoverTR                := TONURCUSTOMCROP.Create('HOVERTOPRIGHT');
  FHoverT                 := TONURCUSTOMCROP.Create('HOVERTOP');
  FHoverBL                := TONURCUSTOMCROP.Create('HOVERBOTTOMLEFT');
  FHoverBR                := TONURCUSTOMCROP.Create('HOVERBOTTOMRIGHT');
  FHoverB                 := TONURCUSTOMCROP.Create('HOVERBOTTOM');
  FHoverL                 := TONURCUSTOMCROP.Create('HOVERLEFT');
  FHoverR                 := TONURCUSTOMCROP.Create('HOVERRIGHT');
  FHoverC                 := TONURCUSTOMCROP.Create('HOVERCENTER');

  FPressTL                := TONURCUSTOMCROP.Create('PRESSTOPLEFT');
  FPressTR                := TONURCUSTOMCROP.Create('PRESSTOPRIGHT');
  FPressT                 := TONURCUSTOMCROP.Create('PRESSTOP');
  FPressBL                := TONURCUSTOMCROP.Create('PRESSBOTTOMLEFT');
  FPressBR                := TONURCUSTOMCROP.Create('PRESSBOTTOMRIGHT');
  FPressB                 := TONURCUSTOMCROP.Create('PRESSBOTTOM');
  FPressL                 := TONURCUSTOMCROP.Create('PRESSLEFT');
  FPressR                 := TONURCUSTOMCROP.Create('PRESSRIGHT');
  FPressC                 := TONURCUSTOMCROP.Create('PRESSCENTER');

  FDisableTL              := TONURCUSTOMCROP.Create('DISABLETOPLEFT');
  FDisableTR              := TONURCUSTOMCROP.Create('DISABLETOPRIGHT');
  FDisableT               := TONURCUSTOMCROP.Create('DISABLETOP');
  FDisableBL              := TONURCUSTOMCROP.Create('DISABLEBOTTOMLEFT');
  FDisableBR              := TONURCUSTOMCROP.Create('DISABLEBOTTOMRIGHT');
  FDisableB               := TONURCUSTOMCROP.Create('DISABLEBOTTOM');
  FDisableL               := TONURCUSTOMCROP.Create('DISABLELEFT');
  FDisableR               := TONURCUSTOMCROP.Create('DISABLERIGHT');
  FDisableC               := TONURCUSTOMCROP.Create('DISABLECENTER');



  Customcroplist.Add(FNormalTL);
  Customcroplist.Add(FNormalTR);
  Customcroplist.Add(FNormalT);
  Customcroplist.Add(FNormalBL);
  Customcroplist.Add(FNormalBR);
  Customcroplist.Add(FNormalB);
  Customcroplist.Add(FNormalL);
  Customcroplist.Add(FNormalR);
  Customcroplist.Add(FNormalC);

  Customcroplist.Add(FHoverTL);
  Customcroplist.Add(FHoverTR);
  Customcroplist.Add(FHoverT);
  Customcroplist.Add(FHoverBL);
  Customcroplist.Add(FHoverBR);
  Customcroplist.Add(FHoverB);
  Customcroplist.Add(FHoverL);
  Customcroplist.Add(FHoverR);
  Customcroplist.Add(FHoverC);

  Customcroplist.Add(FPressTL);
  Customcroplist.Add(FPressTR);
  Customcroplist.Add(FPressT);
  Customcroplist.Add(FPressBL);
  Customcroplist.Add(FPressBR);
  Customcroplist.Add(FPressB);
  Customcroplist.Add(FPressL);
  Customcroplist.Add(FPressR);
  Customcroplist.Add(FPressC);

  Customcroplist.Add(FDisableTL);
  Customcroplist.Add(FDisableTR);
  Customcroplist.Add(FDisableT);
  Customcroplist.Add(FDisableBL);
  Customcroplist.Add(FDisableBR);
  Customcroplist.Add(FDisableB);
  Customcroplist.Add(FDisableL);
  Customcroplist.Add(FDisableR);
  Customcroplist.Add(FDisableC);
  Resizing;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TONURGraphicsButton.Destroy;
begin
  Customcroplist.Clear;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.CheckAutoWidth;
var
  TextWidth, TextHeight: Integer;
  Padding: Integer;
begin
  if FAutoWidth then //and Assigned(resim) then
  begin
    FOldWidth  := Width;
    FOldHeight := Height;

    // Calculate text dimensions
    TextWidth := canvas.TextWidth(Caption);
    TextHeight := canvas.TextHeight(Caption);

    // Add padding (space around text)
    Padding := 10; // 5px left and right

    // Width: left padding + text + right padding + border widths
    Width := Padding + TextWidth + Padding + FNormalL.Croprect.Width + FNormalR.Croprect.Width;

    // Height: text height + padding + top/bottom borders
    Height := Padding + TextHeight + Padding + FNormalT.Croprect.Height + FNormalB.Croprect.Height;

    // Guarantee minimum dimensions
    if Width < 50 then Width := 50;
    if Height < 25 then Height := 25;
  end else
  begin
    Width      := FOldWidth;
    Height     := FOldHeight;
  end;

//  if Skindata<>nil then
//    setSkindata(self.Skindata); // resize
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONURGraphicsButton.GetAutoWidth: boolean;
begin
  Result := FAutoWidth;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.SetAutoWidth(const Value: boolean);
begin
  if FAutoWidth=value then exit;
  FAutoWidth := Value;
  CheckAutoWidth;
end;

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  // Initialize Targetrect when skin is loaded
  if Assigned(Aimg) then
    Resizing;
end;


procedure TONURGraphicsButton.resize;
begin
{  inherited Resize;
  FoldWidth  := Width;
  FOldHeight := Height;
  CheckAutoWidth;
  if Assigned(Skindata) then
  Resizing;  }

  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURGraphicsButton.resizing;
begin
 // Check if crop parts are initialized before setting Targetrect
  if not Assigned(FNormalTL) then Exit;

  // Set Targetrect for all crop parts - needed for DrawPartnormal
  FNormalTL.Targetrect := Rect(0, 0, FNormalTL.Croprect.Width, FNormalTL.Croprect.Height);
  FNormalTR.Targetrect := Rect(self.clientWidth - FNormalTR.Croprect.Width,
    0, self.clientWidth, FNormalTR.Croprect.Height);
  FNormalT.Targetrect := Rect(FNormalTL.Croprect.Width, 0, self.clientWidth -
    FNormalTR.Croprect.Width, FNormalT.Croprect.Height);
  FNormalBL.Targetrect := Rect(0, self.ClientHeight - FNormalBL.Croprect.Height,
    FNormalBL.Croprect.Width, self.ClientHeight);
  FNormalBR.Targetrect := Rect(self.clientWidth - FNormalBR.Croprect.Width,
    self.clientHeight - FNormalBR.Croprect.Height, self.clientWidth, self.clientHeight);
  FNormalB.Targetrect := Rect(FNormalBL.Croprect.Width, self.clientHeight -
    FNormalB.Croprect.Height, self.clientWidth - FNormalBR.Croprect.Width, self.clientHeight);
  FNormalL.Targetrect := Rect(0, FNormalTL.Croprect.Height, FNormalL.Croprect.Width, self.clientHeight -
    FNormalBL.Croprect.Height);
  FNormalR.Targetrect := Rect(self.clientWidth - FNormalR.Croprect.Width, FNormalTR.Croprect.Height,
    self.clientWidth, self.clientHeight - FNormalBR.Croprect.Height);
  FNormalC.Targetrect := Rect(FNormalL.Croprect.Width, FNormalT.Croprect.Height, self.clientWidth -
    FNormalR.Croprect.Width, self.clientHeight - FNormalB.Croprect.Height);

  // Set Targetrect for Hover state
  FHoverTL.Targetrect := FNormalTL.Targetrect;
  FHoverTR.Targetrect := FNormalTR.Targetrect;
  FHoverT.Targetrect := FNormalT.Targetrect;
  FHoverBL.Targetrect := FNormalBL.Targetrect;
  FHoverBR.Targetrect := FNormalBR.Targetrect;
  FHoverB.Targetrect := FNormalB.Targetrect;
  FHoverL.Targetrect := FNormalL.Targetrect;
  FHoverR.Targetrect := FNormalR.Targetrect;
  FHoverC.Targetrect := FNormalC.Targetrect;

  // Set Targetrect for Press state
  FPressTL.Targetrect := FNormalTL.Targetrect;
  FPressTR.Targetrect := FNormalTR.Targetrect;
  FPressT.Targetrect := FNormalT.Targetrect;
  FPressBL.Targetrect := FNormalBL.Targetrect;
  FPressBR.Targetrect := FNormalBR.Targetrect;
  FPressB.Targetrect := FNormalB.Targetrect;
  FPressL.Targetrect := FNormalL.Targetrect;
  FPressR.Targetrect := FNormalR.Targetrect;
  FPressC.Targetrect := FNormalC.Targetrect;

  // Set Targetrect for Disable state
  FDisableTL.Targetrect := FNormalTL.Targetrect;
  FDisableTR.Targetrect := FNormalTR.Targetrect;
  FDisableT.Targetrect := FNormalT.Targetrect;
  FDisableBL.Targetrect := FNormalBL.Targetrect;
  FDisableBR.Targetrect := FNormalBR.Targetrect;
  FDisableB.Targetrect := FNormalB.Targetrect;
  FDisableL.Targetrect := FNormalL.Targetrect;
  FDisableR.Targetrect := FNormalR.Targetrect;
  FDisableC.Targetrect := FNormalC.Targetrect;
end;

// -----------------------------------------------------------------------------




procedure TONURGraphicsButton.Paint;
var
  tl,t,tr,bl,b,br,l,r,c: TRect;
  StateTL, StateTR, StateT, StateBL, StateBR, StateB, StateL, StateR, StateC: TONURCUSTOMCROP;
  FontColor: TColor;
begin
  if not Visible then exit;

  // Prepare canvas
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  // 9-part drawing if skin available
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
     // At the beginning of Paint method
    if not Assigned(FNormalTL) or (FNormalTL.Targetrect.Left = 0) then
      Resizing;

    // Select correct crop areas based on state
    if Enabled then
    begin
      case FState of
        obsNormal:
        begin
          StateTL := FNormalTL; StateTR := FNormalTR; StateT := FNormalT;
          StateBL := FNormalBL; StateBR := FNormalBR; StateB := FNormalB;
          StateL := FNormalL; StateR := FNormalR; StateC := FNormalC;
          FontColor := FNormalC.Fontcolor;
        end;
        obspressed:
        begin
          StateTL := FPressTL; StateTR := FPressTR; StateT := FPressT;
          StateBL := FPressBL; StateBR := FPressBR; StateB := FPressB;
          StateL := FPressL; StateR := FPressR; StateC := FPressC;
          FontColor := FPressC.Fontcolor;
        end;
        obshover:
        begin
          StateTL := FHoverTL; StateTR := FHoverTR; StateT := FHoverT;
          StateBL := FHoverBL; StateBR := FHoverBR; StateB := FHoverB;
          StateL := FHoverL; StateR := FHoverR; StateC := FHoverC;
          FontColor := FHoverC.Fontcolor;
        end
        else
        begin
          StateTL := FNormalTL; StateTR := FNormalTR; StateT := FNormalT;
          StateBL := FNormalBL; StateBR := FNormalBR; StateB := FNormalB;
          StateL := FNormalL; StateR := FNormalR; StateC := FNormalC;
          FontColor := FNormalC.Fontcolor;
        end;
      end;
    end
    else
    begin
      // Disabled state
      StateTL := FDisableTL; StateTR := FDisableTR; StateT := FDisableT;
      StateBL := FDisableBL; StateBR := FDisableBR; StateB := FDisableB;
      StateL := FDisableL; StateR := FDisableR; StateC := FDisableC;
      FontColor := FDisableC.Fontcolor;
    end;

    // Get crop areas
    tl := StateTL.Croprect;
    tr := StateTR.Croprect;
    t  := StateT.Croprect;
    bl := StateBL.Croprect;
    br := StateBR.Croprect;
    b  := StateB.Croprect;
    l  := StateL.Croprect;
    r  := StateR.Croprect;
    c  := StateC.Croprect;

    // 9-part drawing - scaled according to size
    DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c, FontColor);

  end
  else
  begin
    // Gradient drawing if no skin
    case FState of
      obsNormal:
        resim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
      obshover:
        resim.GradientFill(0, 0, Width, Height, BGRA(90, 90, 90), BGRA(120, 120, 120), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
      obspressed:
        resim.GradientFill(0, 0, Width, Height, BGRA(20, 20, 20), BGRA(40, 40, 40), gtLinear,
          PointF(0, 0), PointF(0, Height), dmSet);
    end;
  end;

  inherited Paint;
end;


procedure TONURGraphicsButton.DrawNinePartButton(tl, tr, t, bl, br, b, l, r, c: TRect; FontColor: TColor);
var
  CornerWidth, CornerHeight: Integer;
  TextRect: TRect;
  ttt:TTextStyle;
begin
  // Get corner dimensions
  CornerWidth := tl.Width;
  CornerHeight := tl.Height;

  // Draw corners - fixed size
  DrawPartnormal(tl, self, Rect(0, 0, CornerWidth, CornerHeight), Alpha);
  DrawPartnormal(tr, self, Rect(ClientWidth - CornerWidth, 0, ClientWidth, CornerHeight), Alpha);
  DrawPartnormal(bl, self, Rect(0, ClientHeight - CornerHeight, CornerWidth, ClientHeight), Alpha);
  DrawPartnormal(br, self, Rect(ClientWidth - CornerWidth, ClientHeight - CornerHeight, ClientWidth, ClientHeight), Alpha);

  // Draw edges - flexible size
  // Top edge
  DrawPartnormal(t, self, Rect(CornerWidth, 0, ClientWidth - CornerWidth, CornerHeight), Alpha);
  // Bottom edge
  DrawPartnormal(b, self, Rect(CornerWidth, ClientHeight - CornerHeight, ClientWidth - CornerWidth, ClientHeight), Alpha);
  // Left edge
  DrawPartnormal(l, self, Rect(0, CornerHeight, CornerWidth, ClientHeight - CornerHeight), Alpha);
  // Right edge
  DrawPartnormal(r, self, Rect(ClientWidth - CornerWidth, CornerHeight, ClientWidth, ClientHeight - CornerHeight), Alpha);

  // Draw center - flexible size
  DrawPartnormal(c, self, Rect(CornerWidth, CornerHeight, ClientWidth - CornerWidth, ClientHeight - CornerHeight), Alpha);

  // Draw text
  Self.Font.Color := FontColor;
  TextRect := Rect(CornerWidth + 5, CornerHeight + 2, ClientWidth - CornerWidth - 5, ClientHeight - CornerHeight - 2);
  ttt.Alignment:= taCenter;//, tlCenter,
  ttt.Layout:=tlCenter;
  resim.TextRect(TextRect, 0, 0, Caption,ttt, FontColor);
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------


{ TONURNavMenuButton }

function TONURNavMenuButton.GetMovable: Boolean;
begin
  Result:=FMoveable;
end;

procedure TONURNavMenuButton.SetMovable(AValue: Boolean);
begin
 if AValue<> FMoveable then
  FMoveable := AValue;
end;

function TONURNavMenuButton.GetButtons(Index: integer): TONURNavButton;
begin
  Result := TONURNavButton(FButton[Index]);
end;

function TONURNavMenuButton.GetButtonCount: integer;
begin
  Result := FButton.Count;
end;

function TONURNavMenuButton.GetActiveButtonIndex: integer;
begin
  if Assigned(FActiveButton) then
    Result := FButton.IndexOf(FActiveButton)
  else
    Result := -1;
end;

procedure TONURNavMenuButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  resizing;
end;

procedure TONURNavMenuButton.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURNavMenuButton.resizing;
var
  i:integer;
begin
  FTopleft.Targetrect      := Rect(0, 0, FTopleft.Croprect.Width,FTopleft.Croprect.Height);
  FTopRight.Targetrect     := Rect(self.clientWidth - FTopRight.Croprect.Width, 0, self.clientWidth, FTopRight.Croprect.Height);
  FTop.Targetrect          := Rect(FTopleft.Croprect.Width, 0, self.clientWidth - FTopRight.Croprect.Width, FTop.Croprect.Height);
  FBottomleft.Targetrect   := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height, FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect  := Rect(self.clientWidth - FBottomRight.Croprect.Width,  self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect       := Rect(FBottomleft.Croprect.Width,self.clientHeight - FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
  Fleft.Targetrect         := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.clientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect        := Rect(self.clientWidth - FRight.Croprect.Width,FTopRight.Croprect.Height, self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect       := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth - FRight.Croprect.Width, self.clientHeight -FBottom.Croprect.Height);


   if FButton.Count > 0 then
   begin
    ChildSizing.TopBottomSpacing := FTop.Croprect.Height;
    ChildSizing.LeftRightSpacing := FLeft.Targetrect.Width;
    ChildSizing.VerticalSpacing  := FTop.Croprect.Height;

    for i := 0 to FButton.Count - 1 do
    begin
      if self.Skindata <> nil then
      Buttons[i].Skindata := self.Skindata;
    end;
   end;
end;

procedure TONURNavMenuButton.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (GetKeyState(VK_LBUTTON) < 0) and (FMoveable = true) then
  begin
    self.Parent.left := Mouse.CursorPos.X - (FMousePoint.X - FFormPoint.X);
    self.Parent.top  := Mouse.CursorPos.Y - (FMousePoint.Y - FFormPoint.Y);
  end;
end;


procedure TONURNavMenuButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (GetKeyState(VK_LBUTTON) < 0) and (FMoveable = true) then
  begin
    FMousePoint := Mouse.CursorPos;
    FFormPoint  := Point(self.Parent.Left, self.Parent.Top);
  end;
end;


procedure TONURNavMenuButton.ShowControl(AControl: TControl);
begin
   if (AControl is TONURNavButton) and (TONURNavButton(AControl).ButtonControl = Self) then
    SetActiveButton(TONURNavButton(AControl));
  inherited ShowControl(AControl);
end;

procedure TONURNavMenuButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
   if Operation = opRemove then
   begin
     if (AComponent is TONURNavButton) and (TONURNavButton(AComponent).ButtonControl = Self) then
       RemoveButton(TONURNavButton(AComponent));
   end;
end;

procedure TONURNavMenuButton.SetActiveButton(Buttoni: TONURNavButton);
var
  AOldButton: TONURGraphicControl;
  AButtonChanged: boolean;
begin
  AButtonChanged := False;
  if not (csDestroying in ComponentState) then
  begin
    if (Assigned(Buttoni) and (Buttoni.ButtonControl = Self)) or (Buttoni = nil) then
    begin
      if Assigned(FActiveButton) then
      begin
        if FActiveButton <> Buttoni then
        begin
          AOldButton := FActiveButton;
          FActiveButton := Buttoni;
         // AOldButton.Visible := False;
     //     AOldButton.Enabled := True;
     //     FActiveButton.Enabled := False;
      //    FActiveButton.Visible := False;


          AButtonChanged := True;
        end;
      end
      else
      begin
        FActiveButton := Buttoni;
       // FActiveButton.Visible := True;
      //  factiveButton.Enabled := False;
        AButtonChanged := True;
      end;
    end;
  end;
  if AButtonChanged then DoButtonChanged;


end;

procedure TONURNavMenuButton.SetActiveButtonIndex(ButtonIndex: integer);
begin
  if not (csLoading in ComponentState) then
    if DoButtonChanging(ButtonIndex) then
      SetActiveButton(Buttons[ButtonIndex]);
end;

procedure TONURNavMenuButton.DoButtonChanged;
begin
  if not (csDestroying in ComponentState) and Assigned(FButtonChanged) then
    FButtonChanged(Self);
end;

function TONURNavMenuButton.DoButtonChanging(NewButtonIndex: integer): boolean;
begin
   Result := True;
  if Assigned(FButtonChanging) then
    FButtonChanging(Self, NewButtonIndex, Result);
end;


constructor TONURNavMenuButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent                := TWinControl(Aowner);
  Width                 := 300;
  Height                := 40;
  TabStop               := True;
  FButton               := TList.Create;
  Font.Name             := 'Calibri';
  Font.Size             := 9;
  TabStop               := True;
  Align                 := alTop;
  skinname              := 'Navmenu';
  FTop                  := TONURCUSTOMCROP.Create('TOP');
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  // for button
  FNormal               := TONURCUSTOMCROP.Create('BUTTONNORMAL');
  FPress                := TONURCUSTOMCROP.Create('BUTTONDOWN');
  FEnter                := TONURCUSTOMCROP.Create('BUTTONHOVER');
  FDisable              := TONURCUSTOMCROP.Create('BUTTONDISABLE');

  Captionvisible        := False;
  FMoveable             := true;

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);

  Customcroplist.Add(Fnormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);

end;

destructor TONURNavMenuButton.Destroy;
 var
  A: integer;
begin
  for A := FButton.Count - 1 downto 0 do
    Buttons[A].Free;

{   for A:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[A]).free;
 }
  Customcroplist.Clear;
  FButton.Free;
  inherited Destroy;
end;

procedure TONURNavMenuButton.Paint;
begin
   // WriteLn('OK');
   if not Visible then exit;

     resim.SetSize(0, 0);
     resim.SetSize(self.ClientWidth, self.ClientHeight);
     resim.Fill(BGRAPixelTransparent);

     if (Skindata <> nil) and not (csDesigning in ComponentState) then
     begin

       //CENTER //CENTER
       DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);

       //TOPLEFT   //TOP LEFT
       DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
       //TOPRIGHT //RIGHT TOP
       DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
       //TOP  //TOP
       DrawPartnormal(ftop.Croprect, self, FTop.Targetrect, alpha);
       //BOTTOMLEFT // BOTTOM LEFT
       DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
       //BOTTOMRIGHT  //BOTTOM RIGHT
       DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
       //BOTTOM  //BOTTOM
       DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
       //LEFT CENTERLEFT // LEFT CENTER
       DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
       //CENTERRIGHT // CENTER RIGHT
       DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);

     //  if Crop then
     //    CropToimg(resim);
     end
     else
     begin
       resim.Fill(BGRA(80, 80, 80, alpha), dmSet);

     end;



  inherited Paint;
end;

function TONURNavMenuButton.NewButton: TONURNavButton;
begin
  Result := TONURNavButton.Create(self);
  Result.ButtonControl := Self;
  ActiveButton := Result;
end;

procedure TONURNavMenuButton.InsertButton(Buttoni: TONURNavButton);
begin
  FButton.Add(Buttoni);
  Buttoni.FButtonControl := Self;
  Buttoni.FreeNotification(Self);
end;

procedure TONURNavMenuButton.RemoveButton(Buttoni: TONURNavButton);
 var
   AButton: TONURNavButton;
 begin
   if FActiveButton = Buttoni then
   begin
     AButton := NextButton(FActiveButton, True);
     if AButton = Buttoni then FActiveButton := nil
     else
       FActiveButton := AButton;
   end;
   FButton.Remove(Buttoni);
   Buttoni.FButtonControl := nil;
   if not (csDestroying in ComponentState) then
     Invalidate;

end;

function TONURNavMenuButton.NextButton(CurButton: TONURNavButton;
  GoForward: boolean): TONURNavButton;
  var
    StartIndex: integer;
  begin
    Result := nil;
    if FButton.Count <> 0 then
    begin
      StartIndex := FButton.IndexOf(CurButton);
      if StartIndex = -1 then
      begin
        if GoForward then
          StartIndex := FButton.Count - 1
        else
          StartIndex := 0;
      end;
      if GoForward then
      begin
        Inc(StartIndex);
        if StartIndex = FButton.Count then
          StartIndex := 0;
      end
      else
      begin
        if StartIndex = 0 then
          StartIndex := FButton.Count;
        Dec(StartIndex);
      end;
      Result := Buttons[StartIndex];
    end;
end;

procedure TONURNavMenuButton.SelectNextButton(GoForward: boolean);
begin
  SetActiveButton(NextButton(ActiveButton, GoForward));
end;





{ TONURNavButton }

function TONURNavButton.GetButtonOrderIndex: integer;
begin
  if FButtonControl <> nil then
    Result := FButtonControl.FButton.IndexOf(Self)
  else
    Result := -1;
end;

function TONURNavButton.GetOrderIndex: integer;
begin

end;

procedure TONURNavButton.Getposition;
begin

end;

procedure TONURNavButton.SetButtonControl(ANavButton: TONURNavMenuButton);
begin
 if FButtonControl <> ANavButton then
  begin

    if FButtonControl <> nil then
      FButtonControl.RemoveButton(Self);

    FButtonControl := ANavButton;

    Parent := FButtonControl;

    if FButtonControl <> nil then
    begin
      FButtonControl.InsertButton(Self);
      Skindata := FButtonControl.Skindata;
      Getposition;
      Invalidate;
    end;
  end;
end;

procedure TONURNavButton.SetButtonOrderIndex(Value: integer);
 var
    MaxPageIndex: integer;
  begin
    if FButtonControl <> nil then
    begin
      MaxPageIndex := FButtonControl.FButton.Count - 1;
      if Value > MaxPageIndex then
        raise EListError.CreateFmt('Sheet Index Error', [Value, MaxPageIndex]);
      FButtonControl.FButton.Move(ButtonOrderIndex, Value);
    end;
end;


procedure TONURNavButton.ReadState(Reader: TReader);
begin
   inherited ReadState(Reader);
  if Reader.Parent is TONURNavMenuButton then
    ButtonControl := TONURNavMenuButton(Reader.Parent);
end;

procedure TONURNavButton.Loaded;
begin
   inherited Loaded;
  if (csDesigning in ComponentState) and not Visible then
    SendToBack;
end;

procedure TONURNavButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;

end;

procedure TONURNavButton.CheckAutoWidth;
 var
   a: Tsize;
 begin
   if FAutoWidth and Assigned(resim) then
   begin

     a := resim.TextSize(Caption);
     resim.SetSize(a.cX, self.Height);
     Width := a.cx;// resim.Width;
     // Height :=a.cy;// resim.Height;
 {  end else
   begin
    Width :=  resim.Width;
    Height := resim.Height;   }
   end;
end;

procedure TONURNavButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (FState = obshover) then
    Exit;

  inherited MouseEnter;
  FState := obshover;
  Invalidate;
end;

procedure TONURNavButton.MouseLeave;
begin
    if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (FState = obsnormal) then
    Exit;

  inherited MouseLeave;
  FState := obsnormal;
  Invalidate;
end;

procedure TONURNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
   if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (FState = obspressed) then
    Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obspressed;
    Invalidate;
  end;
end;

procedure TONURNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FState := obsnormal;
  Invalidate;
end;


constructor TONURNavButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align:=alLeft;
  Enabled:=true;
  Width := 100;
  Height := 30;
  FAutoWidth := True;
  FState := obsNormal;

end;

destructor TONURNavButton.Destroy;
begin
  inherited Destroy;
end;

procedure TONURNavButton.Paint;
var
  DR: TRect;
begin

  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) and Assigned(FButtonControl) then
  begin
    if Enabled = True then
    begin
      case FState of
        obsNormal:
        begin
          DR := FButtonControl.Fnormal.Croprect;
          Self.Font.Color := FButtonControl.Fnormal.Fontcolor;
        end;
        obspressed:
        begin
          DR := FButtonControl.FPress.Croprect;
          Self.Font.Color := FButtonControl.FPress.Fontcolor;
        end;
        obshover:
        begin
          DR := FButtonControl.FEnter.Croprect;
          Self.Font.Color := FButtonControl.FEnter.Fontcolor;
        end;
      end;
    end
    else
    begin
      DR := FButtonControl.Fdisable.Croprect;
      Self.Font.Color := FButtonControl.Fdisable.Fontcolor;
    end;
    DrawPartnormal(DR, self, Rect(0, 0, self.ClientWidth, self.ClientHeight), Alpha);
  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.ClientWidth, Self.ClientHeight);
    case FState of
      obsNormal:
      resim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
        PointF(0, 0), PointF(0, Height), dmSet);

      obshover:
      resim.GradientFill(0, 0, Width, Height, BGRA(90, 90, 90), BGRA(120, 120, 120), gtLinear,
        PointF(0, 0), PointF(0, Height), dmSet);
      obspressed:
      resim.GradientFill(0, 0, Width, Height, BGRA(20, 20, 20), BGRA(40, 40, 40), gtLinear,
        PointF(0, 0), PointF(0, Height), dmSet);
    end;
  end;

  inherited Paint;
end;




{ TONURSwich }

procedure TONURSwich.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;



procedure TONURSwich.CMonmouseenter(var Messages: TLmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  FState := obshover;
  Invalidate;
end;

procedure TONURSwich.CMonmouseleave(var Messages: TLmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  FState := obsnormal;
  Invalidate;
end;



procedure TONURSwich.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mousedown(button, shift, x, y);
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Button = mbLeft then
  begin
    FChecked := not FChecked;
    FState := obsnormal;//obspressed;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end;
end;

procedure TONURSwich.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  FState := obsnormal;
  Invalidate;
end;



constructor TONURSwich.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname       := 'swich';
  FState         := obsnormal;
  FChecked       := False;
  Captionvisible := False;
  FOpen          := TONURCUSTOMCROP.Create('OPEN');
  Fclose         := TONURCUSTOMCROP.Create('CLOSE');
  Fopenhover     := TONURCUSTOMCROP.Create('OPENHOVER');
  Fclosehover    := TONURCUSTOMCROP.Create('CLOSEHOVER');
  FDisableOn     := TONURCUSTOMCROP.Create('DISABLEON');
  FDisableOFF    := TONURCUSTOMCROP.Create('DISABLEOFF');
  FOnCap         := 'ON';
  FOffCap        := 'OFF';

  Customcroplist.Add(FOpen);
  Customcroplist.Add(Fopenhover);
  Customcroplist.Add(FdisableOn);
  Customcroplist.Add(Fclose);
  Customcroplist.Add(Fclosehover);
  Customcroplist.Add(FdisableOff);


  //  FOnChange:=TNotifyEvent;
end;

destructor TONURSwich.Destroy;
begin
  Customcroplist.Clear;
  inherited Destroy;
end;


procedure TONURSwich.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURSwich.Resize;
begin
  inherited Resize;
end;

procedure TONURSwich.Resizing;
begin

end;

procedure TONURSwich.Paint;
var
  DR: TRect;
begin
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
      if Enabled = True then
      begin
        if Checked = True then
        begin
          case FState of
            obsNormal:
            begin
              DR := FOpen.Croprect;
              Self.Font.Color := FOpen.Fontcolor;
            end;
            obshover:
            begin
              DR := Fopenhover.Croprect;
              Self.Font.Color := Fopenhover.Fontcolor;
            end;
          end;
        end
        else
        begin
          case FState of
            obsNormal:
            begin
              DR := Fclose.Croprect;
              Self.Font.Color := Fclose.Fontcolor;
            end;
            obshover:
            begin
              DR := Fclosehover.Croprect;
              Self.Font.Color := Fclosehover.Fontcolor;
            end;
          end;
        end;
      end
      else
      begin
        if Checked = True then
        begin
          DR := FDisableOn.Croprect;
          Self.Font.Color := FDisableOn.Fontcolor;
        end else
        begin
          DR := FDisableOff.Croprect;
          Self.Font.Color := FDisableOff.Fontcolor;
        end;
      end;

      DrawPartstrech(DR, self, self.ClientWidth, self.ClientHeight, alpha);

  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.ClientWidth, Self.ClientHeight);
    resim.Fill(BGRAPixelTransparent);
    case FState of
      obsNormal:
      resim.GradientFill(0, 0, ClientWidth, ClientHeight, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
        PointF(0, 0), PointF(0, ClientHeight), dmSet);
      obshover:
      resim.GradientFill(0, 0, ClientWidth, ClientHeight, BGRA(90, 90, 90), BGRA(120, 120, 120), gtLinear,
        PointF(0, 0), PointF(0, ClientHeight), dmSet);
      obspressed:
      resim.GradientFill(0, 0, ClientWidth, ClientHeight, BGRA(20, 20, 20), BGRA(40, 40, 40), gtLinear,
        PointF(0, 0), PointF(0, ClientHeight), dmSet);
    end;

    if Checked = True then
      resim.FillRect(rect(0,0,ClientWidth div 2,ClientHeight),BGRA(155, 155, 155),dmset)
    else
     resim.FillRect(rect(ClientWidth div 2,0,ClientWidth,ClientHeight),BGRA(155, 155, 155),dmset);
  end;

   if Checked = True then
     yaziyazBGRA(resim.CanvasBGRA,self.font,rect(ClientWidth div 2,0,ClientWidth,ClientHeight),FOnCap,tacenter)
   else
     yaziyazBGRA(resim.CanvasBGRA,self.font,rect(0,0,ClientWidth div 2,ClientHeight),FOffCap,tacenter);

  inherited Paint;
end;




{ TONURCheckbox }

procedure TONURCheckbox.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
  end;
end;

function TONURCheckbox.GetCheckWidth: integer;
begin
  Result := FCheckWidth;
end;

procedure TONURCheckbox.SetCheckWidth(AValue: integer);
begin
  if FCheckWidth = AValue then exit;
  FCheckWidth := AValue;
  Invalidate;
end;

procedure TONURCheckbox.SetCaptionmod(const val: TONURCapDirection);
begin
  if FCaptionDirection = val then  exit;
  FCaptionDirection := val;
  Invalidate;
end;

function TONURCheckbox.GetCaptionmod: TONURCapDirection;
begin
  Result := FCaptionDirection;
end;


procedure TONURCheckbox.CMonmouseenter(var Messages: TLmessage);
begin
  FState := obshover;
  Invalidate;
end;

procedure TONURCheckbox.CMonmouseleave(var Messages: TLmessage);
begin
  FState := obsnormal;
  Invalidate;
end;

procedure TONURCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mousedown(button, shift, x, y);
  if Button = mbLeft then
  begin
    FChecked := not FChecked;
    FState := obspressed;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end;
end;

procedure TONURCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mouseup(button, shift, x, y);
  FState := obshover;
  Invalidate;
end;

procedure TONURCheckbox.DoOnChange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TONURCheckbox.CMHittest(var msg: TCMHIttest);
begin
 { inherited;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE; }
end;

constructor TONURCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname          := 'checkbox';
  FCheckWidth       := 12;
  FCaptionDirection := ocright;
  FState            := obsnormal;
  FChecked          := False;
  Captionvisible    := False;
//  textx             := 10;
//  Texty             := 10;
  obenter           := TONURCUSTOMCROP.Create('NORMALHOVER');
  obleave           := TONURCUSTOMCROP.Create('NORMAL');
  obdown            := TONURCUSTOMCROP.Create('PRESSED');
  obcheckleaves     := TONURCUSTOMCROP.Create('CHECK');
  obcheckenters     := TONURCUSTOMCROP.Create('CHECKHOVER');
  FDisableOFF       := TONURCUSTOMCROP.Create('DISABLENORMAL');
  FDisableOn        := TONURCUSTOMCROP.Create('DISABLECHECK');



  Customcroplist.Add(obleave);
  Customcroplist.Add(obenter);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(FDisableOn);
  Customcroplist.Add(FDisableOFF);
  Captionvisible:=false;


end;

destructor TONURCheckbox.Destroy;
begin
  Customcroplist.Clear;
  inherited Destroy;
end;

procedure TONURCheckbox.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURCheckbox.Resize;
begin
  inherited Resize;
end;

procedure TONURCheckbox.Resizing;
begin

end;

procedure TONURCheckbox.Paint;
var
  DR: TRect;
  CheckRect: TRect;
  TextRect: TRect;
  TextStyle: TTextStyle;
begin
  if not Visible then Exit;
  
  // Prepare canvas
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  // Initialize checkbox rectangle (12x12 pixels)
  CheckRect := Rect(0, 0, FCheckWidth, FCheckWidth);
  
  // Calculate positions based on caption direction
  case FCaptionDirection of
    ocup: // Checkbox above text
    begin
      CheckRect.Left := (self.ClientWidth - FCheckWidth) div 2;
      CheckRect.Top := 0;
      CheckRect.Right := CheckRect.Left + FCheckWidth;
      CheckRect.Bottom := FCheckWidth;
      
      TextRect.Left := 0;
      TextRect.Top := FCheckWidth + 2;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := self.ClientHeight;
    end;
    
    ocdown: // Checkbox below text
    begin
      CheckRect.Left := (self.ClientWidth - FCheckWidth) div 2;
      CheckRect.Top := self.ClientHeight - FCheckWidth;
      CheckRect.Right := CheckRect.Left + FCheckWidth;
      CheckRect.Bottom := self.ClientHeight;
      
      TextRect.Left := 0;
      TextRect.Top := 0;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := CheckRect.Top - 2;
    end;
    
    ocleft: // Checkbox left of text
    begin
      CheckRect.Left := 0;
      CheckRect.Top := (self.ClientHeight - FCheckWidth) div 2;
      CheckRect.Right := FCheckWidth;
      CheckRect.Bottom := CheckRect.Top + FCheckWidth;
      
      TextRect.Left := FCheckWidth + 5;
      TextRect.Top := 0;
      TextRect.Right := self.ClientWidth;
      TextRect.Bottom := self.ClientHeight;
    end;
    
    ocright: // Checkbox right of text
    begin
      CheckRect.Left := self.ClientWidth - FCheckWidth;
      CheckRect.Top := (self.ClientHeight - FCheckWidth) div 2;
      CheckRect.Right := self.ClientWidth;
      CheckRect.Bottom := CheckRect.Top + FCheckWidth;
      
      TextRect.Left := 0;
      TextRect.Top := 0;
      TextRect.Right := CheckRect.Left - 5;
      TextRect.Bottom := self.ClientHeight;
    end;
  end;

  // Skin drawing
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // Select crop area based on state
    if Enabled then
    begin
      if Checked then
      begin
        case FState of
          obsNormal: DR := obcheckleaves.Croprect;
          obshover: DR := obcheckenters.Croprect;
          obspressed: DR := obdown.Croprect;
        end;
      end
      else
      begin
        case FState of
          obsNormal: DR := obleave.Croprect;
          obshover: DR := obenter.Croprect;
          obspressed: DR := obdown.Croprect;
        end;
      end;
    end
    else
    begin
     if Checked then
     DR:=FDisableOn.Croprect
     else
      DR := FDisableOff.Croprect;
    end;
    
    // Draw checkbox with skin
    DrawPartnormal(DR, Self, CheckRect, Alpha);
  end
  else
  begin
    // No skin - draw default checkbox
    if Checked then
      resim.Rectangle(CheckRect, BGRA(0, 0, 0), BGRA(155, 155, 155), dmSet)
    else
      resim.Rectangle(CheckRect, BGRA(0, 0, 0), BGRA(255, 255, 255), dmSet);
  end;

  // Draw caption
  if Length(Caption) > 0 then
  begin
    TextStyle.Alignment := taCenter;
    TextStyle.Layout := tlCenter;
    TextStyle.Wordbreak := False;
    TextStyle.SingleLine := True;
    
    resim.FontName := self.font.Name;
    resim.FontHeight := 10+self.font.Size;
    resim.TextRect(TextRect, 0, 0, Caption, TextStyle, ColorToBGRA(self.font.Color));
  end;

  inherited Paint;
end;



end.


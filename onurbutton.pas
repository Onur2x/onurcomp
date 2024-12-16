unit onurbutton;

{$mode objfpc}{$H+}

interface

uses
  Types,Windows,StdCtrls,LMessages,SysUtils,Classes,Controls,Graphics,ExtCtrls,
  BGRABitmap,BGRABitmapTypes,ComponentEditors,PropEdits,onurctrl;

  type
  //SYSTEM BUTTON -- close minimize help tray etc..

   TONURButtonType       = (OBTNClose, OBTNMinimize,OBTNMaximize, OBTNHelp);



   TDenemeCheckBox = class(TCheckBox)
   private
    obenter, obleave, obdown, obdisableON,obdisableoff, obcheckenters, obcheckleaves: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    Fskindata    : TONURImg;
    resim       : TBGRABitmap;
   protected
    procedure SetSkindata(Aimg: TONURImg);
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
    public
    Customcroplist     : TFPList;
    alpha              : byte;
    skinname           : string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   // procedure Paint; override;
   published
    property Skindata :TONURImg read Fskindata write SetSkindata;
   end;

   TdenemeButton = class(TButton)
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

    Fstate: TONURButtonState;
    Fskindata    : TONURImg;
    Fresim,FBGDisable,FBGHover,FBGNormal,FBGPress:TBGRABitmap;


   protected
    procedure SetSkindata(Aimg: TONURImg);
     procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
    public
    Customcroplist     : TFPList;
    alpha              : byte;
    skinname           : string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   // procedure Paint; override;
   published
    property Skindata :TONURImg read Fskindata write SetSkindata;
   end;

   TDenemeEdit = class(TEdit)
   private
    resim,fback,fhback:TBGRABitmap;
   // obenter, obleave, obdown, obdisableON,obdisableoff, obcheckenters, obcheckleaves: TONURCUSTOMCROP;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    Fhleft, FhTopleft, FhBottomleft, FhRight, FhTopRight, FhBottomRight,
    FhTop, FhBottom, FhCenter: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    Fskindata    : TONURImg;
    FCanvas: TCanvas;
    procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
   protected
    procedure SetSkindata(Aimg: TONURImg);
    procedure MouseLeave; override;
    procedure MouseEnter; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Paint; virtual;
    procedure PaintWindow(DC: HDC); override;
    property Canvas: TCanvas read FCanvas;
  {  procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;  }

    public
    Customcroplist     : TFPList;
    alpha              : byte;
    skinname           : string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   // procedure Paint; override;
   published
    property Skindata :TONURImg read Fskindata write SetSkindata;
   end;

   { TONURsystemButton }

   TONURsystemButton = class(TONURGraphicControl)
   private
    Fnormal      : TONURCUSTOMCROP;
    FPress       : TONURCUSTOMCROP;
    FEnter       : TONURCUSTOMCROP;
    Fdisable     : TONURCUSTOMCROP;
    Fstate       : TONURButtonState;
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

    Fstate           : TONURButtonState;
    FAutoWidth       : boolean;
    FoldHeight, FoldWidth: Integer;
    FBGDisable,FBGHover,FBGNormal,FBGPress:TBGRABitmap;
    function GetAutoWidth: boolean;
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

    Fstate: TONURButtonState;
    FAutoWidth: boolean;
    FoldHeight, FoldWidth: Integer;
 //   FClientPicture:Tpoint;
    FBGDisable,FBGHover,FBGNormal,FBGPress:TBGRABitmap;
   // procedure Drawbutton(a:Tbgrabitmap;des,trgt:Trect);
    function GetAutoWidth: boolean;

  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure resize;override;
    procedure resizing;
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
    Fstate       : TONURButtonState;
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
   Fnormal    : TONURCUSTOMCROP;
   FPress     : TONURCUSTOMCROP;
   FEnter     : TONURCUSTOMCROP;
   Fdisable   : TONURCUSTOMCROP;

  // fbuttonleft,Fbuttonright,fbuttoncenter,Fsplitter : TONURCUSTOMCROP;
   FButton         : TList;
   FButtonChanged  : TNotifyEvent;
   FButtonChanging : TButtonChangingEvent;
   factiveButton   : TONURNavButton;
   FMousePoint     : TPoint;
   FFormPoint      : TPoint;
   fmoveable       : Boolean;
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
    FOpen, Fclose, Fopenhover, Fclosehover, FdisableOff,FdisableOn: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    FChecked: boolean;
    foncap,foffcap:string;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
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
    property ONCaption  : string read foncap  write foncap;
    property OFFCaption : string read foffcap write foffcap;
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
    obenter, obleave, obdown, obdisableON,obdisableoff, obcheckenters, obcheckleaves: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    fcheckwidth: integer;
    fcaptiondirection: TONURCapDirection;
    FChecked: boolean;
    textx, Texty: integer;
    Fclientrect:Trect;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: TONURCapDirection);
    function GetCaptionmod: TONURCapDirection;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
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
    obdown, obdisableON,obdisableoff,
    obcheckenters,
    obcheckleaves     : TONURCUSTOMCROP;
    Fstate            : TONURButtonState;
    fcheckwidth       : integer;
    fcaptiondirection : TONURCapDirection;
    FChecked          : boolean;
    textx, Texty      : integer;
    Fclientrect       : Trect;
    FOnChange         : TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: TONURCapDirection);
    function GetCaptionmod: TONURCapDirection;
    procedure deaktifdigerleri;  /// for radiobutton
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
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
    fclientp: TONURCUSTOMCROP;
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
    fCharWidth, fCharHeight: integer;

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
    property CharHeight: integer read fCharHeight write SetCharHeight default 75;
    property CharWidth: integer read fCharWidth write SetCharWidth default 44;
    property WaitOnEnd: integer read FWait write FWait;
    property Align;
    property Caption: TCaption read FCaption write SetCaption;
    property Alpha;

    property ParentColor;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


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


  TTextDirection = (tdLeftToRight, tdRightToLeft);
  TTextStylee = (tsPingPong, tsScroll);

  { TONURNormalLabel }

  TONURNormalLabel = class(TGraphicControl)
  private
    clr        : Tcolor;
    FBuffer    : TBGRABitmap;
    FText      : string;
    FAnimate   : boolean;
    fbilink    : boolean;
    fbilinki   : boolean;
    fblinktimer: TTimer;
    FTimer     : TOnThreadTimer;
    FDirection : TTextDirection;
    FStyle     : TTextStylee;
    FWait      : byte;
    FPos       : integer;
    FScrollBy  : integer;
    Fwaiting   : byte;
    fyazibuyuk : boolean;
    fblinkinterval : integer;
    ftimerinterval : integer;
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
    property Flash           : boolean      read fbilink        write SetBilink default False;
    property FlashColor      : Tcolor       read clr            write clr; // for Blink color
    property Flashinterval   : integer      read fblinkinterval write Setblinkinterval;
    property Animate         : boolean      read FAnimate       write SetAnimate default False;
    property Animateinterval : integer      read ftimerinterval write Settimerinterval;
    property Animatewait     : byte         read Fwaiting       write Setwaiting;
    //property Style         : TTextStylee  read FStyle         write FStyle;
    property Text            : string       read FText          write SetText;
    property Scroll          : integer      read GetScroll      write SetScrollBy;
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
    fcheck,fmouseon:boolean;
    FOnChange: TNotifyEvent;
    Fonclientp, Foffclientp, Fonclientph, Foffclientph,Fdisabled: TONURCUSTOMCROP;
    procedure Setledonoff(val:boolean);
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
    Property LedOn          : Boolean       Read fcheck       write Setledonoff;
    property Onchange       : TNotifyEvent  read FOnChange    write FOnChange;
    property Skindata;
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

  RegisterComponents('ONUR', [TdenemeButton]);
  RegisterComponents('ONUR', [TDenemeCheckBox]);

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

procedure TDenemeCheckBox.SetSkindata(Aimg:TONURImg);
begin
 if (Aimg <> nil) then
 begin
    fSkindata := nil;
    fSkindata := Aimg;

    Skindata.ReadskinsComp(self);
   // Invalidate;
 end
 else
 begin
    FSkindata := nil;
 end;

end;

procedure TDenemeCheckBox.MouseEnter;
begin
  inherited MouseEnter;
  fstate := obshover;
//  Invalidate;
end;

procedure TDenemeCheckBox.MouseLeave;
begin
  inherited MouseLeave;
  fstate := obsnormal;
//  Invalidate;
end;

procedure TDenemeCheckBox.MouseDown(Button:TMouseButton;Shift:TShiftState;X:
  integer;Y:integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if Button = mbLeft then
  begin
   // checked := not fchecked;
    fState := obspressed;
//    if Assigned(FOnChange) then FOnChange(Self);
 //   Invalidate;
  end;
end;

procedure TDenemeCheckBox.MouseUp(Button:TMouseButton;Shift:TShiftState;X:
  integer;Y:integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  fstate := obshover;
//  Invalidate;
end;

procedure TDenemeCheckBox.WMPaint(var Msg:TLMPaint);
const
  SPACEs: Integer = 2;
var
  txtW, txtH, txtX, BtnWidth: Integer;
  PS     : TPaintStruct;
  canv   : TControlCanvas; //    DC,MemDC: HDC;
  DR, rc : TRect;
begin
  inherited;

  if not Assigned(resim) then exit;
  if resim.Width<0 then exit;
  if not Visible then exit;

  txtW:= resim.canvas.TextWidth(Caption);
  txtH:= resim.canvas.TextHeight(Caption);
  BtnWidth:=20;

  if BiDiMode in [bdRightToLeft, bdRightToLeftReadingOnly] then
    txtX:= self.clientWidth - BtnWidth - SPACEs - txtW
  else
    txtX:= BtnWidth + SPACEs;
   // SetBkMode(canv.Handle,TRANSPARENT);


        if (Skindata <> nil) and not (csDesigning in ComponentState) then
        begin
          resim.SetSize(0,0);
          resim.SetSize(clientWidth,clientHeight);






          if Enabled = True then
          begin
            if Checked = True then
            begin
              case Fstate of
                obsNormal:
                begin
                  DR :=obcheckleaves.Croprect;
                  Self.Font.Color := obcheckleaves.Fontcolor;
                end;
                obshover:
                begin
                  DR :=obcheckenters.Croprect;
                  Self.Font.Color := obcheckenters.Fontcolor;
                end;
                obspressed:
                begin
                  DR := obdown.Croprect;
                  Self.Font.Color := obdown.Fontcolor;
                end;
              end;
            end
            else
            begin
              case Fstate of
                obsNormal:
                begin
                  DR := obleave.Croprect;
                  Self.Font.Color := obleave.Fontcolor;
                end;
                obshover:
                begin
                  DR := obenter.Croprect;
                  Self.Font.Color := obenter.Fontcolor;
                end;
                obspressed:
                begin
                  DR := obdown.Croprect;
                  Self.Font.Color := obdown.Fontcolor;
                end;
              end;
            end;
          end
          else
          begin
            if Checked = True then
            begin
                DR := obdisableon.Croprect;
                Self.Font.Color := obdisableon.Fontcolor;
            end else
            begin
                DR := obdisableoff.Croprect;
                Self.Font.Color := obdisableoff.Fontcolor;
            end;
          end;

         DrawPartnormal(DR, Self.skindata.fimage,self.resim, rect({txtX}0,0,BtnWidth,self.ClientHeight), alpha);

        end else
        begin
          if Checked = True then
           resim.Rectangle(rect(0{txtX},0,BtnWidth,self.ClientHeight),bgrablack,bgra(155, 155, 155),dmset)
          else
           resim.Rectangle(rect(0{txtX},0,BtnWidth,self.ClientHeight),bgrablack,BGRAPixelTransparent,dmset);

        end;
       // canv.TextRect(ClientRect,0,0,caption,[tfSingleLine, tfVerticalCenter, tfCenter, tfEndEllipsis]);
      //  DrawText(canv.Handle,Pchar(Caption),Length(Caption),rc,DT_CENTER or DT_VCENTER or DT_SINGLELINE);

        try

           canv := TControlCanvas.Create;
       //    writeln('YES');
           canv.Control := Self;

         //   resim.Canvas.Brush.Style:=bsClear;

           // StateImages.Draw(canv,0,0,Ord(Self.Checked)); // checkbox
        //    resim.canvas.TextOut(txtX, (Height - txtH) div 2 + 1, Caption);

          //  resim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\backup\aa.png');

          //  resim.Draw(canv,0,0);


             if Msg.DC = 0 then
              canv.Handle := BeginPaint(Handle, PS)
            else
              canv.Handle := Msg.DC;


            resim.Canvas.Brush.Style:=bsClear;

           // StateImages.Draw(canv,0,0,Ord(Self.Checked)); // checkbox
            //resim.canvas.TextOut(Txtlft,TxtTop, text);
            rc:=ClientRect;
            DrawText(resim.Canvas.Handle,Pchar(Caption),Length(Caption),rc,DT_LEFT or DT_VCENTER or DT_SINGLELINE);

          //  resim.canvas.TextOut(txtX, (Height - txtH) div 2 + 1, Caption);
            resim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\backup\aa.png');

            resim.Draw(canv,0,0);

            canv.Handle := 0;
            if Msg.DC = 0 then EndPaint(Handle, PS);

        finally
         canv.Free;
        end;

end;

constructor TDenemeCheckBox.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  skinname          := 'checkbox';
  alpha             := 255;
  Fstate            := obsNormal;
  Resim             := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  Customcroplist    := TFPList.create;
//  crop              := True;
  obenter           := TONURCUSTOMCROP.Create('NORMALHOVER');
  obleave           := TONURCUSTOMCROP.Create('NORMAL');
  obdown            := TONURCUSTOMCROP.Create('PRESSED');
  obcheckleaves     := TONURCUSTOMCROP.Create('CHECK');
  obcheckenters     := TONURCUSTOMCROP.Create('CHECKHOVER');
  obdisableoff      := TONURCUSTOMCROP.Create('DISABLENORMAL');
  obdisableon       := TONURCUSTOMCROP.Create('DISABLECHECK');

  Customcroplist.Add(obleave);
  Customcroplist.Add(obenter);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obdisableon);
  Customcroplist.Add(obdisableoff);
end;

destructor TDenemeCheckBox.Destroy;
var
i:byte;
begin
  for i:=0 to Customcroplist.count-1 do
   TONURCustomCrop(Customcroplist[i]).free;

  Customcroplist.Clear;
  FreeAndNil(Customcroplist);
  FreeAndNil(Resim);
  inherited Destroy;
end;



procedure TdenemeButton.SetSkindata(Aimg:TONURImg);
var
  tl,t,tr,bl,b,br,l,r,c:Trect;
begin
 if (Aimg <> nil) then
  begin
    fSkindata := nil;
    fSkindata := Aimg;

    Skindata.ReadskinsComp(self);

  end
  else
  begin
    FSkindata := nil;
  end;

  FBGNormal.SetSize(0,0);
  FBGHover.SetSize(0,0);
  FBGPress.SetSize(0,0);
  FBGDisable.SetSize(0,0);


  if Fskindata=nil then exit;

  FBGNormal.SetSize(FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height+FNormalBL.Croprect.Height);
  FBGHover.SetSize(FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height+FHoverBL.Croprect.Height);
  FBGPress.SetSize(FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height+FPressBL.Croprect.Height);
  FBGDisable.SetSize(FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height+FDisableBL.Croprect.Height);


  //RECT LOAD
  tl := Rect(0,0,FNormalTL.Croprect.Width,FNormalTL.Croprect.Height);
  t  := Rect(FNormalTL.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width,FNormalT.Croprect.Height);
  tr := Rect(FNormalTL.Croprect.Width+FNormalT.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTR.Croprect.Height);
  bl := Rect(0,FBGNormal.Height-FNormalbl.Croprect.Height,FNormalbl.Croprect.Width,FBGNormal.Height);
  b  := Rect(FNormalBL.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height,FBGNormal.Width-(FNormalBR.Croprect.Width),FBGNormal.Height);
  br := Rect(FBGNormal.Width-FNormalBR.Croprect.Width,FBGNormal.Height-FNormalBR.Croprect.Height,FBGNormal.Width,FBGNormal.Height);
  l  := Rect(0,FNormalTL.Croprect.Height,FNormalL.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height);
  r  := Rect(FBGNormal.Width-FNormalR.Croprect.Width,FNormalTR.Croprect.Height,FBGNormal.Width, FBGNormal.Height- FNormalBR.Croprect.Height);
  c  := Rect(FNormalL.Croprect.Width,FNormalT.Croprect.Height,FBGNormal.Width-FNormalR.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height);

  /// LOAD FORM SKIN IMAGE TO NORMAL BUTTON IMAGE


  // NORMAL BUTTON IMAGE
 // DrawPartstrechRegion(FNormalTL.rect,FBGNormal,fSkindata.fimage,
  DrawPartnormal(FNormalTL.Croprect,FBGNormal,fSkindata.Fimage,tl,alpha);
  DrawPartnormal(FNormalT.Croprect,FBGNormal,fSkindata.Fimage,t,alpha);
  DrawPartnormal(FNormalTr.Croprect,FBGNormal,fSkindata.Fimage,tr,alpha);
  DrawPartnormal(FNormalbL.Croprect,FBGNormal,fSkindata.Fimage,bl,alpha);
  DrawPartnormal(FNormalb.Croprect,FBGNormal,fSkindata.Fimage,b,alpha);
  DrawPartnormal(FNormalBr.Croprect,FBGNormal,fSkindata.Fimage,br,alpha);
  DrawPartnormal(FNormalL.Croprect,FBGNormal,fSkindata.Fimage,l,alpha);
  DrawPartnormal(FNormalR.Croprect,FBGNormal,fSkindata.Fimage,r,alpha);
  DrawPartnormal(FNormalC.Croprect,FBGNormal,fSkindata.Fimage,c,alpha);

  BGRAReplace(FBGNormal,FBGNormal.Resample(clientWidth,clientHeight));



  //RECT LOAD
  tl := Rect(0,0,FHoverTL.Croprect.Width,FHoverTL.Croprect.Height);
  t  := Rect(FHoverTL.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width,FHoverT.Croprect.Height);
  tr := Rect(FHoverTL.Croprect.Width+FHoverT.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTR.Croprect.Height);
  bl := Rect(0,FBGHover.Height-FHoverbl.Croprect.Height,FHoverbl.Croprect.Width,FBGHover.Height);
  b  := Rect(FHoverBL.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height,FBGHover.Width-(FHoverBR.Croprect.Width),FBGHover.Height);
  br := Rect(FBGHover.Width-FHoverBR.Croprect.Width,FBGHover.Height-FHoverBR.Croprect.Height,FBGHover.Width,FBGHover.Height);
  l  := Rect(0,FHoverTL.Croprect.Height,FHoverL.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height);
  r  := Rect(FBGHover.Width-FHoverR.Croprect.Width,FHoverTR.Croprect.Height,FBGHover.Width, FBGHover.Height- FHoverBR.Croprect.Height);
  c  := Rect(FHoverL.Croprect.Width,FHoverT.Croprect.Height,FBGHover.Width-FHoverR.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height);


  // HOVER BUTTON IMAGE
  DrawPartnormal(FHoverTL.Croprect,FBGHover,fSkindata.Fimage,tl,alpha);
  DrawPartnormal(FHoverT.Croprect,FBGHover,fSkindata.Fimage,t,alpha);
  DrawPartnormal(FHoverTr.Croprect,FBGHover,fSkindata.Fimage,tr,alpha);
  DrawPartnormal(FHoverbL.Croprect,FBGHover,fSkindata.Fimage,bl,alpha);
  DrawPartnormal(FHoverb.Croprect,FBGHover,fSkindata.Fimage,b,alpha);
  DrawPartnormal(FHoverBr.Croprect,FBGHover,fSkindata.Fimage,br,alpha);
  DrawPartnormal(FHoverL.Croprect,FBGHover,fSkindata.Fimage,l,alpha);
  DrawPartnormal(FHoverR.Croprect,FBGHover,fSkindata.Fimage,r,alpha);
  DrawPartnormal(FHoverC.Croprect,FBGHover,fSkindata.Fimage,c,alpha);

  BGRAReplace(FBGHover,FBGHover.Resample(clientWidth,clientHeight));



  //RECT LOAD
  tl := Rect(0,0,FPressTL.Croprect.Width,FPressTL.Croprect.Height);
  t  := Rect(FPressTL.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width,FPressT.Croprect.Height);
  tr := Rect(FPressTL.Croprect.Width+FPressT.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTR.Croprect.Height);
  bl := Rect(0,FBGPress.Height-FPressbl.Croprect.Height,FPressbl.Croprect.Width,FBGPress.Height);
  b  := Rect(FPressBL.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height,FBGPress.Width-(FPressBR.Croprect.Width),FBGPress.Height);
  br := Rect(FBGPress.Width-FPressBR.Croprect.Width,FBGPress.Height-FPressBR.Croprect.Height,FBGPress.Width,FBGPress.Height);
  l  := Rect(0,FPressTL.Croprect.Height,FPressL.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height);
  r  := Rect(FBGPress.Width-FPressR.Croprect.Width,FPressTR.Croprect.Height,FBGPress.Width, FBGPress.Height- FPressBR.Croprect.Height);
  c  := Rect(FPressL.Croprect.Width,FPressT.Croprect.Height,FBGPress.Width-FPressR.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height);



 // HOVER BUTTON IMAGE
  DrawPartnormal(FPressTL.Croprect,FBGPress,fSkindata.Fimage,tl,alpha);
  DrawPartnormal(FPressT.Croprect,FBGPress,fSkindata.Fimage,t,alpha);
  DrawPartnormal(FPressTr.Croprect,FBGPress,fSkindata.Fimage,tr,alpha);
  DrawPartnormal(FPressbL.Croprect,FBGPress,fSkindata.Fimage,bl,alpha);
  DrawPartnormal(FPressb.Croprect,FBGPress,fSkindata.Fimage,b,alpha);
  DrawPartnormal(FPressBr.Croprect,FBGPress,fSkindata.Fimage,br,alpha);
  DrawPartnormal(FPressL.Croprect,FBGPress,fSkindata.Fimage,l,alpha);
  DrawPartnormal(FPressR.Croprect,FBGPress,fSkindata.Fimage,r,alpha);
  DrawPartnormal(FPressC.Croprect,FBGPress,fSkindata.Fimage,c,alpha);

  BGRAReplace(FBGPress,FBGPress.Resample(clientWidth,clientHeight));

 //RECT LOAD
  tl := Rect(0,0,FDisableTL.Croprect.Width,FDisableTL.Croprect.Height);
  t  := Rect(FDisableTL.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width,FDisableT.Croprect.Height);
  tr := Rect(FDisableTL.Croprect.Width+FDisableT.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTR.Croprect.Height);
  bl := Rect(0,FBGDisable.Height-FDisablebl.Croprect.Height,FDisablebl.Croprect.Width,FBGDisable.Height);
  b  := Rect(FDisableBL.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height,FBGDisable.Width-(FDisableBR.Croprect.Width),FBGDisable.Height);
  br := Rect(FBGDisable.Width-FDisableBR.Croprect.Width,FBGDisable.Height-FDisableBR.Croprect.Height,FBGDisable.Width,FBGDisable.Height);
  l  := Rect(0,FDisableTL.Croprect.Height,FDisableL.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height);
  r  := Rect(FBGDisable.Width-FDisableR.Croprect.Width,FDisableTR.Croprect.Height,FBGDisable.Width, FBGDisable.Height- FDisableBR.Croprect.Height);
  c  := Rect(FDisableL.Croprect.Width,FDisableT.Croprect.Height,FBGDisable.Width-FDisableR.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height);



 // PRESS BUTTON IMAGE
  DrawPartnormal(FDisableTL.Croprect,FBGDisable,fSkindata.Fimage,tl,alpha);
  DrawPartnormal(FDisableT.Croprect,FBGDisable,fSkindata.Fimage,t,alpha);
  DrawPartnormal(FDisableTr.Croprect,FBGDisable,fSkindata.Fimage,tr,alpha);
  DrawPartnormal(FDisablebL.Croprect,FBGDisable,fSkindata.Fimage,bl,alpha);
  DrawPartnormal(FDisableb.Croprect,FBGDisable,fSkindata.Fimage,b,alpha);
  DrawPartnormal(FDisableBr.Croprect,FBGDisable,fSkindata.Fimage,br,alpha);
  DrawPartnormal(FDisableL.Croprect,FBGDisable,fSkindata.Fimage,l,alpha);
  DrawPartnormal(FDisableR.Croprect,FBGDisable,fSkindata.Fimage,r,alpha);
  DrawPartnormal(FDisableC.Croprect,FBGDisable,fSkindata.Fimage,c,alpha);

  BGRAReplace(FBGDisable,FBGDisable.Resample(clientWidth,clientHeight));



// Invalidate;
end;

procedure TdenemeButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then    exit;
  if (Enabled=false) or (Fstate = obshover) then  Exit;
  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;

procedure TdenemeButton.MouseLeave;
begin
   if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obsnormal) then
  Exit;
  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;

procedure TdenemeButton.MouseDown(Button:TMouseButton;Shift:TShiftState;X:
  integer;Y:integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obspressed) then
  Exit;
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;
end;

procedure TdenemeButton.MouseUp(Button:TMouseButton;Shift:TShiftState;X:integer;
  Y:integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TdenemeButton.WMPaint(var Msg:TLMPaint);
var
//  tl,t,tr,bl,b,br,l,r,c:Trect;
    //PS : TPaintStruct;
    canv : TControlCanvas;
 //    DC,MemDC: HDC;
     rc:TRect;
  x, y: integer;
  hdc1, SpanRgn: hdc;//integer;
  WindowRgn: HRGN;
  p: PBGRAPixel;

begin
  inherited;
  if not Assigned(fresim) then exit;
  if fresim.Width<0 then exit;
  if not Visible then exit;


      try

        if (Skindata <> nil) and not (csDesigning in ComponentState) then
        begin
          fresim.SetSize(0,0);
          fresim.SetSize(clientWidth,clientHeight);

          if Enabled = True then
          begin
            case Fstate of
                  obsNormal  : begin fresim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
                  obshover   : begin fresim.PutImage(0,0,FBGHover,dmDrawWithTransparency); self.font.Color:=FHoverC.Fontcolor end;
                  obspressed : begin fresim.PutImage(0,0,FBGPress,dmDrawWithTransparency); self.font.Color:=FPressC.Fontcolor end;
                  else
                  begin fresim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
            end;
          end else
          begin
            fresim.PutImage(0,0,FBGDisable,dmDrawWithTransparency); self.font.Color:=FDisableC.Fontcolor;
          end;
        end
        else
        begin
          fresim.SetSize(0,0);
          fresim.SetSize(self.Width, Self.Height);
          case Fstate of
            obsNormal:
            fresim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
              PointF(0, 0), PointF(0, Height), dmSet);

            obshover:
            fresim.GradientFill(0, 0, Width, Height, BGRA(90, 90, 90), BGRA(120, 120, 120), gtLinear,
              PointF(0, 0), PointF(0, Height), dmSet);
            obspressed:
            fresim.GradientFill(0, 0, Width, Height, BGRA(20, 20, 20), BGRA(40, 40, 40), gtLinear,
              PointF(0, 0), PointF(0, Height), dmSet);
          end;
        end;

         canv := TControlCanvas.Create;
       //  writeln('YES');
         canv.Control := Self;

        if fresim.Width>0 then
        begin
           WindowRgn := CreateRectRgn(0, 0, fresim.Width, fresim.Height);

            for Y := 0 to fresim.Height - 1 do
            begin
              p := fresim.Scanline[Y];
              for X := fresim.Width - 1 downto 0 do
              begin

                if p^.Alpha < 20 then//<255 then
                begin
                  p^ := BGRAPixelTransparent;
                  SpanRgn := CreateRectRgn(x, y, x + 1, y + 1);
                  CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
                  DeleteObject(SpanRgn);
                end;
                Inc(p);
              end;
            end;

            fresim.InvalidateBitmap;


            SetWindowRgn(self.Handle, WindowRgn, True);
            hdc1 := GetDC(self.Handle);
            ReleaseDC(self.Handle, hdc1);
            DeleteObject(WindowRgn);
            DeleteObject(hdc1);

            rc:=ClientRect;
            fresim.Canvas.Brush.Style:=bsClear;
            DrawText(fresim.Canvas.Handle,Pchar(Caption),Length(Caption),rc,DT_CENTER or DT_VCENTER or DT_SINGLELINE);



            fresim.Draw(canv,0,0);
        end;
       // canv.TextRect(ClientRect,0,0,caption,[tfSingleLine, tfVerticalCenter, tfCenter, tfEndEllipsis]);
      //  DrawText(canv.Handle,Pchar(Caption),Length(Caption),rc,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
      finally
        canv.Free;
      end;




//  inherited WMPaint;
end;

constructor TdenemeButton.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  self.Width              := 100;
  self.Height             := 30;
  alpha                   := 255;
  Fstate                  := obsNormal;
  FResim                  := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
//  crop                    := True;
  fresim.SetSize(self.Width, self.Height);
  Customcroplist          := TFPList.Create;


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



  FBGDisable              := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGHover                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGNormal               := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGPress                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);



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
end;

destructor TdenemeButton.Destroy;
var
i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
   TONURCUSTOMCROP(Customcroplist.Items[i]).free;
//  Customcroplist.Clear;
  FreeAndNil(FBGDisable);
  FreeAndNil(FBGHover);
  FreeAndNil(FBGNormal);
  FreeAndNil(FBGPress);
  FreeAndNil(Fresim);
  FreeAndNil(Customcroplist);
  inherited Destroy;

end;

procedure TDenemeEdit.SetSkindata(Aimg:TONURImg);
begin
    if (Aimg <> nil) then
  begin
    fSkindata := nil;
    fSkindata := Aimg;
    Skindata.ReadskinsComp(self);
 //   Invalidate;
  end
  else
  begin
    FSkindata := nil;
  end;
  if Fskindata=nil then exit;

  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect    := Rect(self.clientWidth - FTopRight.Croprect.Width, 0, self.clientWidth, FTopRight.Croprect.Height);
  ftop.Targetrect         := Rect(FTopleft.Croprect.Width, 0, self.clientWidth -  FTopRight.Croprect.Width, FTop.Croprect.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Croprect.Width,self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width, self.clientHeight - FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width, self.clientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect       := Rect(self.clientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth - FRight.Croprect.Width, self.clientHeight - FBottom.Croprect.Height);

  FBack.SetSize(0, 0);
  FBack.SetSize(self.ClientWidth, self.ClientHeight);
  //ORTA CENTER
  DrawPartnormal(FCenter.Croprect,FBack,Aimg.fimage, fcenter.Targetrect, alpha);
  //SOL ÜST TOPLEFT
  DrawPartnormal(FTopleft.Croprect, FBack,Aimg.fimage, FTopleft.Targetrect, alpha);
  //SAĞ ÜST TOPRIGHT
  DrawPartnormal(FTopRight.Croprect, FBack,Aimg.fimage, FTopRight.Targetrect, alpha);
  //UST TOP
  DrawPartnormal(FTop.Croprect, FBack,Aimg.fimage,FTop.Targetrect, alpha);
  // SOL ALT BOTTOMLEFT
  DrawPartnormal(FBottomleft.Croprect, FBack,Aimg.fimage,FBottomleft.Targetrect, alpha);
  //SAĞ ALT BOTTOMRIGHT
  DrawPartnormal(FBottomRight.Croprect, FBack,Aimg.fimage, FBottomRight.Targetrect, alpha);
  //ALT BOTTOM
  DrawPartnormal(FBottom.Croprect, FBack,Aimg.fimage, FBottom.Targetrect, alpha);
  // SOL ORTA CENTERLEFT
  DrawPartnormal(Fleft.Croprect, FBack,Aimg.fimage, Fleft.Targetrect, alpha);
  // SAĞ ORTA CENTERRIGHT
  DrawPartnormal(FRight.Croprect, FBack,Aimg.fimage, FRight.Targetrect, alpha);




  FhTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FhTopRight.Targetrect    := Rect(self.clientWidth - FTopRight.Croprect.Width, 0, self.clientWidth, FTopRight.Croprect.Height);
  fhtop.Targetrect         := Rect(FTopleft.Croprect.Width, 0, self.clientWidth -  FTopRight.Croprect.Width, FTop.Croprect.Height);
  FhBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
  FhBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Croprect.Width,self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
  FhBottom.Targetrect      := Rect(FBottomleft.Croprect.Width, self.clientHeight - FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
  Fhleft.Targetrect        := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width, self.clientHeight - FBottomleft.Croprect.Height);
  FhRight.Targetrect       := Rect(self.clientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
  FhCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth - FRight.Croprect.Width, self.clientHeight - FBottom.Croprect.Height);

  FhBack.SetSize(0, 0);
  FhBack.SetSize(self.ClientWidth, self.ClientHeight);

  //ORTA CENTER
  DrawPartnormal(FhCenter.Croprect,FhBack,Aimg.fimage, fhcenter.Targetrect, alpha);
  //SOL ÜST TOPLEFT
  DrawPartnormal(FhTopleft.Croprect, FhBack,Aimg.fimage, FhTopleft.Targetrect, alpha);
  //SAĞ ÜST TOPRIGHT
  DrawPartnormal(FhTopRight.Croprect, FhBack,Aimg.fimage, FhTopRight.Targetrect, alpha);
  //UST TOP
  DrawPartnormal(FhTop.Croprect, FhBack,Aimg.fimage,FhTop.Targetrect, alpha);
  // SOL ALT BOTTOMLEFT
  DrawPartnormal(FhBottomleft.Croprect, FhBack,Aimg.fimage,FhBottomleft.Targetrect, alpha);
  //SAĞ ALT BOTTOMRIGHT
  DrawPartnormal(FhBottomRight.Croprect, FhBack,Aimg.fimage, FhBottomRight.Targetrect, alpha);
  //ALT BOTTOM
  DrawPartnormal(FhBottom.Croprect, FhBack,Aimg.fimage, FhBottom.Targetrect, alpha);
  // SOL ORTA CENTERLEFT
  DrawPartnormal(Fhleft.Croprect, FhBack,Aimg.fimage, Fhleft.Targetrect, alpha);
  // SAĞ ORTA CENTERRIGHT
  DrawPartnormal(FhRight.Croprect, FhBack,Aimg.fimage, FhRight.Targetrect, alpha);

//  Invalidate;
end;

procedure TDenemeEdit.MouseLeave;
begin
if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FhCenter.croprect.width<1 then exit;
  fState := obsnormal;
  inherited MouseLeave;

end;

procedure TDenemeEdit.MouseEnter;
begin
  if csDesigning in ComponentState then  Exit;
  if not Enabled then                    Exit;
  if FhCenter.croprect.width<1 then    Exit;

  fState:=obshover;
  inherited MouseEnter;
end;

procedure TDenemeEdit.WndProc(var Message:TMessage);
begin
 inherited WndProc(Message);
  with Message do
    case Msg of
      CM_MOUSEENTER, CM_MOUSELEAVE, WM_LBUTTONUP, WM_LBUTTONDOWN,
      WM_KEYDOWN, WM_KEYUP,
      WM_SETFOCUS, WM_KILLFOCUS,
      CM_FONTCHANGED, CM_TEXTCHANGED:
      begin
        Invalidate;
      end;
   end;
end;

procedure TDenemeEdit.Paint;

 var
  R: TRect;
  I: Integer;
  S: String;

  x, y: integer;
  hdc1, SpanRgn: hdc;//integer;
  WindowRgn: HRGN;
  p: PBGRAPixel;
begin

  resim.Canvas.Brush.Assign(Self.Brush);
  resim.Canvas.Font.Assign(Self.Font);

  resim.SetSize(0, 0);

  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent,dmset);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

     if (fState = obshover) and (FhCenter.croprect.width>0) and (Enabled) then
     begin
       resim.PutImage(0,0,fhback,dmDrawWithTransparency);
       self.font.Color:=FhCenter.Fontcolor;
     end
     else
     begin
       resim.PutImage(0,0,fback,dmDrawWithTransparency);
       self.font.Color:=FCenter.Fontcolor;
     end;

     if resim.Width>0 then
     begin
        WindowRgn := CreateRectRgn(0, 0, resim.Width, resim.Height);

        for Y := 0 to resim.Height - 1 do
        begin
          p := resim.Scanline[Y];
          for X := resim.Width - 1 downto 0 do
          begin

           // if p^.Alpha < 20 then//<255 then
            if p^ = BGRAPixelTransparent then//<255 then

            begin
           //   p^ := BGRAPixelTransparent;
              SpanRgn := CreateRectRgn(x, y, x + 1, y + 1);
              CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
              DeleteObject(SpanRgn);
            end;
            Inc(p);
          end;
        end;

        resim.InvalidateBitmap;


        SetWindowRgn(self.Handle, WindowRgn, True);
        hdc1 := GetDC(self.Handle);
        ReleaseDC(self.Handle, hdc1);
        DeleteObject(WindowRgn);
        DeleteObject(hdc1);
      end;


  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);

  end;


  resim.Canvas.Brush.Style:=bsClear;
  R := ClientRect;
//  Inc(R.Left, 1);
 // Inc(R.Top, 1);
 //WSSetText(text);
  //RealSetText(text);
  DrawText(resim.Canvas.Handle, PChar(Text),Length(text), R,  DT_VCENTER and DT_SINGLELINE);
  AdjustSize;
 { for I := 1 to Length(Text) do
  begin
   // if Text[I] in ['0'..'9'] then
   //   Canvas.Font.Color := clRed
  //  else
   //   Canvas.Font.Color := clGreen;
    S := Text[I];
    DrawText(resim.Canvas.Handle, PChar(S), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK);
    Inc(R.Left,resim.Canvas.TextWidth(S));
  end;
  }
  resim.Draw(Canvas,0,0);
end;

procedure TDenemeEdit.PaintWindow(DC:HDC);
begin
 FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
     // TControlCanvas(FCanvas).UpdateTextFlags;
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
 // inherited PaintWindow(DC);
end;

procedure TDenemeEdit.WMPaint(var Msg:TLMPaint);
var
canv : TControlCanvas;
 PS: TPaintStruct;
 Txtlft,TxtTop:integer;
 rc:TRect;

   x, y: integer;
  hdc1, SpanRgn: hdc;//integer;
  WindowRgn: HRGN;
  p: PBGRAPixel;
begin
  ControlState := ControlState+[csCustomPaint];
  inherited;
{
  if not Assigned(resim) then exit;
  if resim.Width<0 then exit;
  if not Visible then exit;



  resim.SetSize(0, 0);

  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent,dmset);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

     if (fState = obshover) and (FhCenter.croprect.width>0) and (Enabled) then
     begin
       resim.PutImage(0,0,fhback,dmDrawWithTransparency);
       self.font.Color:=FhCenter.Fontcolor;
       Txtlft := Fhleft.Targetrect.Width;
       TxtTop := Fhtop.Targetrect.Height;
     end
     else
     begin
       resim.PutImage(0,0,fback,dmDrawWithTransparency);
       self.font.Color:=FCenter.Fontcolor;
       Txtlft := Fleft.Targetrect.Width;
       TxtTop := Ftop.Targetrect.Height;
     end;

     if resim.Width>0 then
     begin
        WindowRgn := CreateRectRgn(0, 0, resim.Width, resim.Height);

        for Y := 0 to resim.Height - 1 do
        begin
          p := resim.Scanline[Y];
          for X := resim.Width - 1 downto 0 do
          begin

           // if p^.Alpha < 20 then//<255 then
            if p^ = BGRAPixelTransparent then//<255 then

            begin
           //   p^ := BGRAPixelTransparent;
              SpanRgn := CreateRectRgn(x, y, x + 1, y + 1);
              CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
              DeleteObject(SpanRgn);
            end;
            Inc(p);
          end;
        end;

        resim.InvalidateBitmap;


        SetWindowRgn(self.Handle, WindowRgn, True);
        hdc1 := GetDC(self.Handle);
        ReleaseDC(self.Handle, hdc1);
        DeleteObject(WindowRgn);
        DeleteObject(hdc1);
      end;


  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);

  end;




       try

           canv := TControlCanvas.Create;
          // writeln('EDITTTTTTtt');
           canv.Control := Self;
           if Msg.DC = 0 then
              canv.Handle := BeginPaint(Handle, PS)
            else
              canv.Handle := Msg.DC;


            resim.Canvas.Brush.Style:=bsClear;

           // StateImages.Draw(canv,0,0,Ord(Self.Checked)); // checkbox
            //resim.canvas.TextOut(Txtlft,TxtTop, text);
            rc:=ClientRect;
            DrawText(resim.Canvas.Handle,Pchar(Caption),Length(Caption),rc,DT_LEFT or DT_VCENTER or DT_SINGLELINE);


       //     resim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\backup\aa.png');

            resim.Draw(canv,0,0);
           // RealSetText(Text);
            canv.Handle := 0;
            if Msg.DC = 0 then EndPaint(Handle, PS);
        finally
         canv.Free;
        end;
      }
    ControlState := ControlState-[csCustomPaint];
end;

constructor TDenemeEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Customcroplist        := TFPList.Create;
  skinname              := 'edit';
  BorderStyle           := bsNone;
//  BorderWidth           := 1;
  alpha                 := 255;
  FTop                  := TONURCUSTOMCROP.Create('TOP');
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');

  FhTop                 := TONURCUSTOMCROP.Create('HOVERTOP');
  FhBottom              := TONURCUSTOMCROP.Create('HOVERBOTTOM');
  FhCenter              := TONURCUSTOMCROP.Create('HOVERCENTER');
  FhRight               := TONURCUSTOMCROP.Create('HOVERRIGHT');
  FhTopRight            := TONURCUSTOMCROP.Create('HOVERTOPRIGHT');
  FhBottomRight         := TONURCUSTOMCROP.Create('HOVERBOTTOMRIGHT');
  Fhleft                := TONURCUSTOMCROP.Create('HOVERLEFT');
  FhTopleft             := TONURCUSTOMCROP.Create('HOVERTOPLEFT');
  FhBottomleft          := TONURCUSTOMCROP.Create('HOVERBOTTOMLEFT');

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);

  Customcroplist.Add(FhTopleft);
  Customcroplist.Add(FhTop);
  Customcroplist.Add(FhTopRight);
  Customcroplist.Add(FhBottomleft);
  Customcroplist.Add(FhBottom);
  Customcroplist.Add(FhBottomRight);
  Customcroplist.Add(Fhleft);
  Customcroplist.Add(FhRight);
  Customcroplist.Add(FhCenter);

  Self.Height        := 30;
  Self.Width         := 80;
  resim              := TBGRABitmap.Create(Width,Height);
  fback              := TBGRABitmap.Create(Width,Height);
  fhback             := TBGRABitmap.create(Width,Height);

  fState             := obsnormal;
  FCanvas            := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

end;

destructor TDenemeEdit.Destroy;
var
  i: byte;
begin

  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;


  Customcroplist.Clear;
  FreeAndNil(fback);
  FreeAndNil(fhback);
  FreeAndNil(resim);
  FreeAndNil(FCanvas);
  inherited Destroy;
end;


{ TONURsystemButton }


function TONURsystemButton.GetButtonType: TONURButtonType;
begin
  Result:=fButtonType;
end;

procedure TONURsystemButton.SetButtonType(AValue: TONURButtonType);
begin
  if AValue<>fButtonType then
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
    //OBTNHelp     : nil?;
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
  Fdisable          := TONURCUSTOMCROP.Create('DISABLE');

  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);

  Fstate            := obsNormal;
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

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

      if Enabled = True then
      begin
        case Fstate of
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
        DR := Fdisable.Croprect;
        Self.Font.Color := Fdisable.Fontcolor;
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
  if (Enabled=false) or (Fstate = obshover) then
  Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;

procedure TONURsystemButton.MouseLeave;
begin
   if (csDesigning in ComponentState) then
  exit;
  if (Enabled = false) or (Fstate = obsnormal) then
  Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURsystemButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obspressed) then
  Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;
end;

procedure TONURsystemButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obshover) then
  Exit;


  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obshover;
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
 Result := fcheckwidth;
end;

procedure TONURRadioButton.SetCheckWidth(AValue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;

procedure TONURRadioButton.SetCaptionmod(const val: TONURCapDirection);
begin
   if fcaptiondirection = val then
    exit;
  fcaptiondirection := val;
  Invalidate;
end;

function TONURRadioButton.GetCaptionmod: TONURCapDirection;
begin
  Result := fcaptiondirection;
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
        TONURRadioButton(Sibling).fchecked:=false;
        TONURRadioButton(Sibling).fstate := obsnormal;
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

procedure TONURRadioButton.CMonmouseenter(var Messages: Tmessage);
begin
  fstate := obshover;
  Invalidate;
end;

procedure TONURRadioButton.CMonmouseleave(var Messages: Tmessage);
begin
 fstate := obsnormal;
  Invalidate;
end;

procedure TONURRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if fchecked=true then exit;

  if Button = mbLeft then
  begin
    fState := obspressed;
    SetChecked(true);
  end;
end;

procedure TONURRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  fstate := obshover;
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
   if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

constructor TONURRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname          := 'radiobox';
  fcheckwidth       := 12;
  fcaptiondirection := ocright;
  Fstate            := obsnormal;
  FChecked          := False;
  Captionvisible    := False;
  textx             := 10;
  Texty             := 10;
  obenter           := TONURCUSTOMCROP.Create('NORMALHOVER');
  obleave           := TONURCUSTOMCROP.Create('NORMAL');
  obdown            := TONURCUSTOMCROP.Create('PRESSED');
  obcheckleaves     := TONURCUSTOMCROP.Create('CHECK');
  obcheckenters     := TONURCUSTOMCROP.Create('CHECKHOVER');
  obdisableoff      := TONURCUSTOMCROP.Create('DISABLENORMAL');
  obdisableon       := TONURCUSTOMCROP.Create('DISABLECHECK');

  Customcroplist.Add(obenter);
  Customcroplist.Add(obleave);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obdisableON);
  Customcroplist.Add(obdisableOFF);

end;

destructor TONURRadioButton.Destroy;
begin
 Customcroplist.Clear;
 inherited Destroy;
end;

procedure TONURRadioButton.Paint;
var
  DR: TRect;
  fbuttoncenter,a,b: integer;
begin
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);



  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Enabled = True then
    begin
      if Checked = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR :=obcheckleaves.Croprect;
            Self.Font.Color := obcheckleaves.Fontcolor;
          end;
          obshover:
          begin
            DR :=obcheckenters.Croprect;
            Self.Font.Color := obcheckenters.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end
      else
      begin
        case Fstate of
          obsNormal:
          begin
            DR := obleave.Croprect;
            Self.Font.Color := obleave.Fontcolor;
          end;
          obshover:
          begin
            DR := obenter.Croprect;
            Self.Font.Color := obenter.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end;
    end
    else
    begin

      if Checked = True then
        begin
          DR := obdisableON.Croprect;
          Self.Font.Color := OBdisableon.Fontcolor;
        end else
        begin
          DR := obdisableoff.Croprect;
          Self.Font.Color := obdisableoff.Fontcolor;
        end;
    end;


    case fCaptionDirection of
      ocup:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := DR.top;//obleave.Croprect.Top;//fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) + (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocdown:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := ((self.clientHeight div 2)) + DR.Top;//obleave.Croprect.Top;// + fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) - (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocleft:
      begin
        textx := self.ClientWidth - (fcheckwidth + self.canvas.TextWidth(Caption) + 5);
        Texty := (self.clientHeight div 2) - (self.canvas.TextHeight(Caption) div 2);
        fbuttoncenter := (self.clientHeight div 2) - (fcheckwidth div 2);
        Fclientrect := Rect(self.ClientWidth - fcheckwidth, fbuttoncenter, self.ClientWidth,
          fbuttoncenter + fcheckwidth);
      end;
      ocright:
      begin
        textx := fcheckwidth + 5;
        Texty := (self.clientHeight div 2) - (self.canvas.TextHeight(Caption) div 2);
        fbuttoncenter := (self.clientHeight div 2) - (fcheckwidth div 2);
        Fclientrect := Rect(0, fbuttoncenter, fcheckwidth, fbuttoncenter + fcheckwidth);
      end;
    end;

    DrawPartnormal(DR, Self, Fclientrect, alpha);
  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
    resim.Fill(BGRAPixelTransparent);


    case fCaptionDirection of
      ocup:
      begin
        a:= (self.ClientWidth div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx := a - (resim.CanvasBGRA.TextWidth(Caption) div 2);
        Texty := 0;
        Fclientrect :=rect(a,b, a+fcheckwidth,b+fcheckwidth);
      end;
      ocdown:
      begin
        a:= (self.ClientWidth div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx := a - (resim.CanvasBGRA.TextWidth(Caption) div 2);
        Texty := self.ClientHeight-b;
        Fclientrect :=rect(a,0, a+fcheckwidth,fcheckwidth);
      end;
      ocleft:
      begin
        a:= (self.clientHeight div 2);
        b:= resim.CanvasBGRA.TextWidth(Caption);
        textx :=5;
        Texty := a - resim.CanvasBGRA.TextHeight(Caption);
        Fclientrect := Rect(b+resim.CanvasBGRA.TextHeight(Caption),0,b+fcheckwidth+resim.CanvasBGRA.TextHeight(Caption),fcheckwidth);
      end;
      ocright:
      begin
        a:= (self.clientHeight div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx :=fcheckwidth+5;
        Texty := a - b;
        Fclientrect := Rect(0,0,CheckWidth,fcheckwidth);
      end;
    end;

    if Checked = True then
     resim.EllipseInRect(Fclientrect,bgrablack,bgra(155, 155, 155),dmset)
    else
     resim.EllipseInRect(Fclientrect,bgrablack,BGRAPixelTransparent,dmset);
  end;


  yaziyazBGRA(resim.CanvasBGRA,self.font,Rect(textx,Texty,textx+resim.CanvasBGRA.TextWidth(Caption),Texty+resim.CanvasBGRA.TextHeight(Caption)),caption,taCenter);

  inherited paint;

 { if (Length(Caption) > 0) and (Skindata<>nil) then
  begin
    canvas.Brush.Style := bsClear;
    canvas.TextOut(Textx, Texty, (Caption));
  end;    }
end;



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
  if fbilink = AValue then Exit;
  fbilink := AValue;

  if not (csDesigning in ComponentState) then
  fblinktimer.Enabled:=AValue;

  if AValue=false then
  begin
    fbilink:=false;
    Invalidate;
  end;

end;

procedure TONURNormalLabel.Setblinkinterval(AValue: integer);
begin
  if fblinkinterval=AValue then Exit;
  fblinkinterval:=AValue;
  fblinktimer.Interval:=AValue;

end;


procedure TONURNormalLabel.SetAnimate(AValue: boolean);
begin
  if AValue = FAnimate then exit;

  if AValue then
  begin
    FPos := GetTextDefaultPos;
    FWait := Fwaiting;// Waiting;
    FDirection := tdLeftToRight;
    FAnimate := True;
    SetText(FText);
    FreeTimer;
    ftimer := TOnThreadTimer.Create(Self);
    FTimer.Interval := ftimerinterval;//100;
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
  FWait := Fwaiting;// Waiting;
  Invalidate;
end;

procedure TONURNormalLabel.Settimerinterval(AValue: integer);
begin
  if ftimerinterval=AValue then Exit;
  ftimerinterval:=AValue;
  if (fAnimate) and Assigned(ftimer) then
    FTimer.Interval := ftimerinterval;//100;
end;

procedure TONURNormalLabel.Setwaiting(AValue: byte);
begin
  if Fwaiting=AValue then Exit;
  Fwaiting:=AValue;
end;

procedure TONURNormalLabel.SetYazibuyuk(AValue: boolean);
begin
  if fyazibuyuk=AValue then Exit;
  fyazibuyuk:=AValue;
end;

procedure TONURNormalLabel.TimerEvent(Sender: TObject);
begin
  if FWait > 0 then
  begin
    Dec(FWait);
    Exit;
  end;
    if (FBuffer.Width < self.Width) then
    begin

      if (fpos >= 0) and (fpos <= (self.Width - FBuffer.Width)) then
        if FDirection = tdRightToLeft then
          fpos -= FScrollBy
        else if FDirection = tdLeftToRight then
          fpos += FScrollBy;

      if fpos < 0 then
      begin
        fpos := 0;
        FDirection := tdLeftToRight;
        FWait := Fwaiting;//Waiting;
      end;

      if fpos > (self.Width - FBuffer.Width) then
      begin
        fpos := (self.Width - FBuffer.Width);
        FDirection := tdRightToLeft;
        FWait := Fwaiting;// Waiting;
      end;
    end else
    begin
      if (fpos >= -(FBuffer.Width - self.Width)) and (fpos <= (FBuffer.Width - self.Width)) then
       if FDirection = tdRightToLeft then
         fpos -=FScrollBy
       else if FDirection = tdLeftToRight then
          fpos += FScrollBy;
      if fpos > 0 then
      begin
        fpos := 0;
        FDirection := tdRightToLeft;
        FWait := Fwaiting;//Waiting;
      end
      else
      if fpos < -(FBuffer.Width - self.Width) then
      begin
        fpos := -(FBuffer.Width - self.Width);
        FDirection := tdLeftToRight;
        FWait := Fwaiting;//Waiting;
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
   fyazibuyuk:=true
  else
   fyazibuyuk:=false;
end;

procedure TONURNormalLabel.DrawFontTextcolor(incolor,outcolor:TBGRAPixel);
begin
  FBuffer.SetSize(0, 0);
  FBuffer.SetSize(FBuffer.TextSize(FText).cx, self.ClientHeight);
  FBuffer.FontName:=self.Font.Name;
  FBuffer.FontFullHeight:=-self.font.size;
  FBuffer.TextOut(0, 0, FText, BGRAToColor(self.font.color), False);

  if FBuffer.Width> self.Width then
   fyazibuyuk:=true
  else
   fyazibuyuk:=false;

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
  fbilink:= not fbilinki;
  fbilinki:= not fbilinki;
  if FAnimate=false then
  Invalidate;
end;

procedure TONURNormalLabel.Loaded;
begin
  inherited Loaded;
    DrawFontText;
end;

procedure TONURNormalLabel.Paint;
begin
 Inherited Paint;
  if fbilink then
  begin
    canvas.Brush.Color := clr;
    canvas.FillRect(ClientRect);
  end;

  FBuffer.Draw(self.Canvas, fpos, 0, False);
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
  Fwaiting              := 15;
  fblinkinterval        := 500;
  ftimerinterval        := 100;
  clr                   := clRed;
  fbilink               := false;
  fyazibuyuk            := false;
  fblinktimer           := TTimer.Create(nil);
  fblinktimer.Enabled   := False;
  fblinktimer.Interval  := fblinkinterval;
  fblinktimer.OnTimer   := @Blinktimerevent;

end;

destructor TONURNormalLabel.Destroy;
begin
  FreeTimer;
  if fblinktimer.Enabled then fblinktimer.Enabled:=false;

  FreeAndNil(fblinktimer);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;






{ TONURLed }

procedure TONURLed.Setledonoff(val: boolean);
Begin
  if val <> fcheck then
  begin
   fcheck:=val;
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


  skinname              := 'led';
  Skindata              := nil;
  fcheck                := true;
  Captionvisible        := False;
  resim.SetSize(self.clientWidth, self.clientHeight);
end;

// -----------------------------------------------------------------------------
destructor TONURLed.Destroy;
begin
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

procedure TONURLed.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try

      if fcheck then
      begin
        if fmouseon=false then
         SrcRect :=Fonclientp.Croprect
        else
         SrcRect := Fonclientph.Croprect;
      end else
      begin
        if fmouseon=false then
         SrcRect := Foffclientp.Croprect
        else
         SrcRect := Foffclientph.Croprect
      End;
      TrgtRect := Rect(0, 0, self.ClientWidth,self.ClientHeight);
      DrawPartnormal(SrcRect, self, TrgtRect, Alpha);


    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
   if fcheck then
    resim.Fill(BGRA(115, 115, 115,alpha), dmSet)
   else
   resim.Fill(BGRA(90, 90, 90,alpha), dmSet);
  end;
  inherited Paint;
End;

procedure TONURLed.MouseEnter;
Begin
  Inherited Mouseenter;
  fmouseon:=true;
  Invalidate;
End;

procedure TONURLed.MouseLeave;
Begin
  Inherited Mouseleave;
  fmouseon:=false;
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
  if fcaption = Avalue then Exit;
  fcaption := Avalue;
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

  UpDatePos;
  Invalidate;
end;

procedure TONURlabel.SetCharWidth(Value: integer);
begin
  if Value = CharWidth then exit;
  fCharWidth := Value;
  Getbmp;
  Invalidate;
end;

procedure TONURlabel.SetCharHeight(Value: integer);
begin
  if Value = CharHeight then exit;
  fCharHeight := Value;
  Getbmp;
  Invalidate;
end;



procedure TONURlabel.SetString(AValue: TStringList);
begin
  if Flist = AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
  Getbmp;
end;

procedure TONURlabel.listchange(Sender: TObject);
begin
  Getbmp;
end;



constructor TONURlabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'label';
  fclientp := TONURCUSTOMCROP.Create('CLIENT');
  Customcroplist.Add(fclientp);

  FInterval := 100;
  FBitmap := TBGRABitmap.Create;
  tempbitmap:= TBGRABitmap.Create;

  fCharWidth := 21;
  fCharHeight := 27;
  FScale := 1;
  FStretch := True;
  FScrollBy := 2;
  FWait := 1000;



  Self.Height := fCharHeight * 2;
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
  Flist := TStringList.Create;
  Flist.add('ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZQXW');
  Flist.add('0123456789:.,<> ');

  Skindata := nil;

  FCharWidth  := tempbitmap.TextSize('ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZQXW').cx div 32;
  FCharHeight := tempbitmap.TextSize('ÇĞ').cy;// * 2) div Flist.Count;

  //ShowMessage(inttostr(fCharWidth)+'   '+inttostr(FCharHeight));
  Getbmp;
end;

destructor TONURlabel.Destroy;
begin
  Deactivate;
  FBitmap.Free;
  tempbitmap.Free;
  FTimer.Free;
  Flist.Free;
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
    for n := 0 to Flist.Count - 1 do
    begin
      ucIter := TUnicodeCharacterEnumerator.Create(Flist[n]);
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
  if Flist.Count<1 then exit;
  FCharWidth  := fclientp.Croprect.Width div UTF8LengthFast(Flist[0]);
  FCharHeight := fclientp.Croprect.Height div Flist.Count;


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
   img: TBGRACustomBitmap;
   i:integer;
begin
  if not Visible then exit;



 if (Skindata <> nil) and not (csDesigning in ComponentState) then
 begin

    resim.SetSize(0,0);

    resim.Setsize((Length(self.Caption) * CharWidth),self.ClientHeight);
    tempbitmap.SetSize(0,0);

    tempbitmap.SetSize(fclientp.Croprect.Width, fclientp.Croprect.Height);
    FBitmap.SetSize(0,0);

    TrgtRect := Rect(0, 0, tempbitmap.Width, tempbitmap.Height);
    DrawPartnormalbmp(fclientp.Croprect, self, tempbitmap, TrgtRect, Alpha);
    Getbmp;

 end
 else
 begin
   resim.SetSize(0,0);
   resim.Setsize((Length(self.Caption) * CharWidth),self.ClientHeight);
   FBitmap.SetSize(0,0);

   tempbitmap.SetSize(0,0);

   if Strings.count>0 then
   begin
    tempbitmap.SetSize((32 * CharWidth),CharHeight*Flist.count);
    tempbitmap.Fill(BGRAPixelTransparent);
    for i:=0 to Flist.Count - 1 do
    tempbitmap.TextOut(0,i*tempbitmap.TextSize(Flist[i]).cy ,Flist[i],BGRAWhite);
   end;
  // tempbitmap.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\aa.png');
   Getbmp;
 end;




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

  inherited paint;
end;





{ TONURCropButton }

// -----------------------------------------------------------------------------
constructor TONURCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.Width              := 100;
  self.Height             := 30;
  foldWidth               := Width;
  foldHeight              := Height;
  Fstate                  := obsNormal;
  FAutoWidth              := false;
  crop                    := True;
  resim.SetSize(self.Width, self.Height);

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



  FBGDisable              := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGHover                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGNormal               := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGPress                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);



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
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TONURCropButton.Destroy;
begin
  Customcroplist.Clear;
  FreeAndNil(FBGDisable);
  FreeAndNil(FBGHover);
  FreeAndNil(FBGNormal);
  FreeAndNil(FBGPress);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.CheckAutoWidth;
begin
  if FAutoWidth then //and Assigned(resim) then
  begin
    foldWidth  := Width;
    foldHeight := Height;
    Width      := canvas.TextWidth(Caption)+FNormalL.Croprect.Width+FNormalr.Croprect.Width;//resim.TextSize(caption).cx;
    Height     := Fnormalc.Croprect.Height; //resim.Height;
  end else
  begin
    Width      := foldWidth;
    Height     := foldHeight;
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
  var
  tl,t,tr,bl,b,br,l,r,c:Trect;
begin
  inherited SetSkindata(Aimg);
  resizing;

  FBGNormal.SetSize(FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height+FNormalBL.Croprect.Height);
  FBGHover.SetSize(FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height+FHoverBL.Croprect.Height);
  FBGPress.SetSize(FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height+FPressBL.Croprect.Height);
  FBGDisable.SetSize(FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height+FDisableBL.Croprect.Height);


  //RECT LOAD
  tl := Rect(0,0,FNormalTL.Croprect.Width,FNormalTL.Croprect.Height);
  t  := Rect(FNormalTL.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width,FNormalT.Croprect.Height);
  tr := Rect(FNormalTL.Croprect.Width+FNormalT.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTR.Croprect.Height);
  bl := Rect(0,FBGNormal.Height-FNormalbl.Croprect.Height,FNormalbl.Croprect.Width,FBGNormal.Height);
  b  := Rect(FNormalBL.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height,FBGNormal.Width-(FNormalBR.Croprect.Width),FBGNormal.Height);
  br := Rect(FBGNormal.Width-FNormalBR.Croprect.Width,FBGNormal.Height-FNormalBR.Croprect.Height,FBGNormal.Width,FBGNormal.Height);
  l  := Rect(0,FNormalTL.Croprect.Height,FNormalL.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height);
  r  := Rect(FBGNormal.Width-FNormalR.Croprect.Width,FNormalTR.Croprect.Height,FBGNormal.Width, FBGNormal.Height- FNormalBR.Croprect.Height);
  c  := Rect(FNormalL.Croprect.Width,FNormalT.Croprect.Height,FBGNormal.Width-FNormalR.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height);

  /// LOAD FORM SKIN IMAGE TO NORMAL BUTTON IMAGE


  // NORMAL BUTTON IMAGE
 // DrawPartstrechRegion(FNormalTL.rect,FBGNormal,skindata.fimage,
  DrawPartnormal(FNormalTL.Croprect,FBGNormal,skindata.Fimage,tl,alpha);
  DrawPartnormal(FNormalT.Croprect,FBGNormal,skindata.Fimage,t,alpha);
  DrawPartnormal(FNormalTr.Croprect,FBGNormal,skindata.Fimage,tr,alpha);
  DrawPartnormal(FNormalbL.Croprect,FBGNormal,skindata.Fimage,bl,alpha);
  DrawPartnormal(FNormalb.Croprect,FBGNormal,skindata.Fimage,b,alpha);
  DrawPartnormal(FNormalBr.Croprect,FBGNormal,skindata.Fimage,br,alpha);
  DrawPartnormal(FNormalL.Croprect,FBGNormal,skindata.Fimage,l,alpha);
  DrawPartnormal(FNormalR.Croprect,FBGNormal,skindata.Fimage,r,alpha);
  DrawPartnormal(FNormalC.Croprect,FBGNormal,skindata.Fimage,c,alpha);

  BGRAReplace(FBGNormal,FBGNormal.Resample(clientWidth,clientHeight));



  //RECT LOAD
  tl := Rect(0,0,FHoverTL.Croprect.Width,FHoverTL.Croprect.Height);
  t  := Rect(FHoverTL.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width,FHoverT.Croprect.Height);
  tr := Rect(FHoverTL.Croprect.Width+FHoverT.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTR.Croprect.Height);
  bl := Rect(0,FBGHover.Height-FHoverbl.Croprect.Height,FHoverbl.Croprect.Width,FBGHover.Height);
  b  := Rect(FHoverBL.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height,FBGHover.Width-(FHoverBR.Croprect.Width),FBGHover.Height);
  br := Rect(FBGHover.Width-FHoverBR.Croprect.Width,FBGHover.Height-FHoverBR.Croprect.Height,FBGHover.Width,FBGHover.Height);
  l  := Rect(0,FHoverTL.Croprect.Height,FHoverL.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height);
  r  := Rect(FBGHover.Width-FHoverR.Croprect.Width,FHoverTR.Croprect.Height,FBGHover.Width, FBGHover.Height- FHoverBR.Croprect.Height);
  c  := Rect(FHoverL.Croprect.Width,FHoverT.Croprect.Height,FBGHover.Width-FHoverR.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height);


  // HOVER BUTTON IMAGE
  DrawPartnormal(FHoverTL.Croprect,FBGHover,skindata.Fimage,tl,alpha);
  DrawPartnormal(FHoverT.Croprect,FBGHover,skindata.Fimage,t,alpha);
  DrawPartnormal(FHoverTr.Croprect,FBGHover,skindata.Fimage,tr,alpha);
  DrawPartnormal(FHoverbL.Croprect,FBGHover,skindata.Fimage,bl,alpha);
  DrawPartnormal(FHoverb.Croprect,FBGHover,skindata.Fimage,b,alpha);
  DrawPartnormal(FHoverBr.Croprect,FBGHover,skindata.Fimage,br,alpha);
  DrawPartnormal(FHoverL.Croprect,FBGHover,skindata.Fimage,l,alpha);
  DrawPartnormal(FHoverR.Croprect,FBGHover,skindata.Fimage,r,alpha);
  DrawPartnormal(FHoverC.Croprect,FBGHover,skindata.Fimage,c,alpha);

  BGRAReplace(FBGHover,FBGHover.Resample(clientWidth,clientHeight));



  //RECT LOAD
  tl := Rect(0,0,FPressTL.Croprect.Width,FPressTL.Croprect.Height);
  t  := Rect(FPressTL.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width,FPressT.Croprect.Height);
  tr := Rect(FPressTL.Croprect.Width+FPressT.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTR.Croprect.Height);
  bl := Rect(0,FBGPress.Height-FPressbl.Croprect.Height,FPressbl.Croprect.Width,FBGPress.Height);
  b  := Rect(FPressBL.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height,FBGPress.Width-(FPressBR.Croprect.Width),FBGPress.Height);
  br := Rect(FBGPress.Width-FPressBR.Croprect.Width,FBGPress.Height-FPressBR.Croprect.Height,FBGPress.Width,FBGPress.Height);
  l  := Rect(0,FPressTL.Croprect.Height,FPressL.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height);
  r  := Rect(FBGPress.Width-FPressR.Croprect.Width,FPressTR.Croprect.Height,FBGPress.Width, FBGPress.Height- FPressBR.Croprect.Height);
  c  := Rect(FPressL.Croprect.Width,FPressT.Croprect.Height,FBGPress.Width-FPressR.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height);



 // HOVER BUTTON IMAGE
  DrawPartnormal(FPressTL.Croprect,FBGPress,skindata.Fimage,tl,alpha);
  DrawPartnormal(FPressT.Croprect,FBGPress,skindata.Fimage,t,alpha);
  DrawPartnormal(FPressTr.Croprect,FBGPress,skindata.Fimage,tr,alpha);
  DrawPartnormal(FPressbL.Croprect,FBGPress,skindata.Fimage,bl,alpha);
  DrawPartnormal(FPressb.Croprect,FBGPress,skindata.Fimage,b,alpha);
  DrawPartnormal(FPressBr.Croprect,FBGPress,skindata.Fimage,br,alpha);
  DrawPartnormal(FPressL.Croprect,FBGPress,skindata.Fimage,l,alpha);
  DrawPartnormal(FPressR.Croprect,FBGPress,skindata.Fimage,r,alpha);
  DrawPartnormal(FPressC.Croprect,FBGPress,skindata.Fimage,c,alpha);

  BGRAReplace(FBGPress,FBGPress.Resample(clientWidth,clientHeight));

 //RECT LOAD
  tl := Rect(0,0,FDisableTL.Croprect.Width,FDisableTL.Croprect.Height);
  t  := Rect(FDisableTL.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width,FDisableT.Croprect.Height);
  tr := Rect(FDisableTL.Croprect.Width+FDisableT.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTR.Croprect.Height);
  bl := Rect(0,FBGDisable.Height-FDisablebl.Croprect.Height,FDisablebl.Croprect.Width,FBGDisable.Height);
  b  := Rect(FDisableBL.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height,FBGDisable.Width-(FDisableBR.Croprect.Width),FBGDisable.Height);
  br := Rect(FBGDisable.Width-FDisableBR.Croprect.Width,FBGDisable.Height-FDisableBR.Croprect.Height,FBGDisable.Width,FBGDisable.Height);
  l  := Rect(0,FDisableTL.Croprect.Height,FDisableL.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height);
  r  := Rect(FBGDisable.Width-FDisableR.Croprect.Width,FDisableTR.Croprect.Height,FBGDisable.Width, FBGDisable.Height- FDisableBR.Croprect.Height);
  c  := Rect(FDisableL.Croprect.Width,FDisableT.Croprect.Height,FBGDisable.Width-FDisableR.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height);



 // PRESS BUTTON IMAGE
  DrawPartnormal(FDisableTL.Croprect,FBGDisable,skindata.Fimage,tl,alpha);
  DrawPartnormal(FDisableT.Croprect,FBGDisable,skindata.Fimage,t,alpha);
  DrawPartnormal(FDisableTr.Croprect,FBGDisable,skindata.Fimage,tr,alpha);
  DrawPartnormal(FDisablebL.Croprect,FBGDisable,skindata.Fimage,bl,alpha);
  DrawPartnormal(FDisableb.Croprect,FBGDisable,skindata.Fimage,b,alpha);
  DrawPartnormal(FDisableBr.Croprect,FBGDisable,skindata.Fimage,br,alpha);
  DrawPartnormal(FDisableL.Croprect,FBGDisable,skindata.Fimage,l,alpha);
  DrawPartnormal(FDisableR.Croprect,FBGDisable,skindata.Fimage,r,alpha);
  DrawPartnormal(FDisableC.Croprect,FBGDisable,skindata.Fimage,c,alpha);

  BGRAReplace(FBGDisable,FBGDisable.Resample(clientWidth,clientHeight));

end;

procedure TONURCropButton.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURCropButton.Resizing;
begin

{  FNormalleft.Targetrect   := RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect  := RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);
  FNormaltop.Targetrect    := RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);
  FNormalbottom.Targetrect := RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect       := RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight-FNormalbottom.Height);
}
{  FNormalTL.Targetrect := Rect(0, 0, FNormalTL.Width, FNormalTL.Height);
  FNormalTR.Targetrect := Rect(self.clientWidth - FNormalTR.Width,
    0, self.clientWidth, FNormalTR.Height);
  FNormalT.Targetrect := Rect(FNormalTL.Width, 0, self.clientWidth -
    FNormalTR.Width, FNormalT.Height);
  FNormalBL.Targetrect := Rect(0, self.ClientHeight - FNormalBL.Height,
    FNormalBL.Width, self.ClientHeight);
  FNormalBR.Targetrect := Rect(self.clientWidth - FNormalBR.Width,
    self.clientHeight - FNormalBR.Height, self.clientWidth, self.clientHeight);
  FNormalB.Targetrect := Rect(FNormalBL.Width, self.clientHeight -
    FNormalB.Height, self.clientWidth - FNormalBR.Width, self.clientHeight);
  FNormalL.Targetrect := Rect(0, FNormalTL.Height, FNormalL.Width, self.clientHeight -
    FNormalBL.Height);
  FNormalR.Targetrect := Rect(self.clientWidth - FNormalR.Width, FNormalTR.Height,
    self.clientWidth, self.clientHeight - FNormalBR.Height);
  FNormalC.Targetrect := Rect(FNormalL.Width, FNormalT.Height, self.clientWidth -
    FNormalR.Width, self.clientHeight - FNormalB.Height);
}
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.Paint;
var
  tl,t,tr,bl,b,br,l,r,c:Trect;
begin
{  if not Visible then exit;
//  resim.SetSize(0,0);
//  resim.SetSize(self.Width, Self.Height);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            TL  := FNormalTL.Croprect;
            TR  := FNormalTR.Croprect;
            T   := FNormalT.Croprect;
            BL  := FNormalBL.Croprect;
            BR  := FNormalBR.Croprect;
            B   := FNormalB.Croprect;
            L   := FNormalL.Croprect;
            R   := FNormalR.Croprect;
            C   := FNormalC.Croprect;
            Self.Font.Color := FNormalC.Fontcolor;
          end;
          obspressed:
          begin
            TL  := FPressTL.Croprect;
            TR  := FPressTR.Croprect;
            T   := FPressT.Croprect;
            BL  := FPressBL.Croprect;
            BR  := FPressBR.Croprect;
            B   := FPressB.Croprect;
            L   := FPressL.Croprect;
            R   := FPressR.Croprect;
            C   := FPressC.Croprect;
            Self.Font.Color := FPressC.Fontcolor;
          end;
          obshover:
          begin
            TL  := FHoverTL.Croprect;
            TR  := FHoverTR.Croprect;
            T   := FHoverT.Croprect;
            BL  := FHoverBL.Croprect;
            BR  := FHoverBR.Croprect;
            B   := FHoverB.Croprect;
            L   := FHoverL.Croprect;
            R   := FHoverR.Croprect;
            C   := FHoverC.Croprect;
            Self.Font.Color := FHoverC.Fontcolor;
          end;
        end;
      end
      else
      begin
        TL  := FDisableTL.Croprect;
        TR  := FDisableTR.Croprect;
        T   := FDisableT.Croprect;
        BL  := FDisableBL.Croprect;
        BR  := FDisableBR.Croprect;
        B   := FDisableB.Croprect;
        L   := FDisableL.Croprect;
        R   := FDisableR.Croprect;
        C   := FDisableC.Croprect;
        Self.Font.Color := FDisableC.Fontcolor;
      end;


    resim.SetSize(0,0);
    resim.SetSize(tl.Width+t.Width+tr.Width,tl.Height+l.Height+bl.Height);
    if resim.Width<1 then resim.SetSize(1,resim.Height);
    if resim.Height<1 then resim.SetSize(resim.Width,1);


    //TOPLEFT   //SOLÜST
    DrawPartnormal(tl, self,Rect(0,0,tl.Width,tl.Height),Alpha);//  FNormalTL.Targetrect, alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(tr, self,Rect(resim.Width-tr.Width,0,resim.Width,tr.Height),Alpha);// FNormalTR.Targetrect, alpha);
    //TOP  //ÜST
    DrawPartnormal(T, self, Rect(tl.Width,0,resim.Width-tr.Width,t.Height),Alpha);//FNormalT.Targetrect, alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(Bl, self, Rect(0,resim.Height-bl.Height,bl.Width,resim.Height),Alpha);//FNormalBL.Targetrect, alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(br, self,Rect(resim.Width-br.Width,resim.Height-br.Height,resim.Width,resim.Height),Alpha);// FNormalBR.Targetrect, alpha);
    //BOTTOM  //ALT
    DrawPartnormal(b, self, Rect(bl.Width,resim.Height-b.Height,resim.Width-(br.Width),resim.Height),Alpha);//FNormalB.Targetrect, alpha);
    //CENTERLEFT // SOLORTA
    DrawPartnormal(l, self, Rect(0,tl.Height,l.Width,resim.Height-bl.Height),Alpha);// FNormalL.Targetrect, alpha);
    //CENTERRIGHT // SAĞORTA
    DrawPartnormal(r, self, Rect(resim.Width-r.Width,tr.Height,resim.Width, resim.Height- br.Height),Alpha);// FNormalR.Targetrect, alpha);
    //CENTER //ORTA
    DrawPartnormal(c, self, Rect(l.Width,t.Height,resim.Width-r.Width,resim.Height-b.Height),Alpha);// FNormalC.Targetrect, alpha);


    resim.ResampleFilter:=rfBestQuality;
    BGRAReplace(resim, resim.Resample(self.ClientWidth,self.ClientHeight,rmFineResample));

 //     if Crop = True then
 //       CropToimg(resim);

  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
  //  resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    case Fstate of
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
  inherited Paint;  }


  if not Visible then exit;
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    resim.SetSize(0,0);
    resim.SetSize(clientWidth,clientHeight);

    if Enabled = True then
    begin
      case Fstate of
            obsNormal  : begin resim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
            obshover   : begin resim.PutImage(0,0,FBGHover,dmDrawWithTransparency); self.font.Color:=FHoverC.Fontcolor end;
            obspressed : begin resim.PutImage(0,0,FBGPress,dmDrawWithTransparency); self.font.Color:=FPressC.Fontcolor end;
            else
            begin resim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
      end;
    end else
    begin
      resim.PutImage(0,0,FBGDisable,dmDrawWithTransparency); self.font.Color:=FDisableC.Fontcolor;
    end;
  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
    case Fstate of
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
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obsnormal) then
  Exit;
  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obspressed) then
  Exit;
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURCropButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then    exit;
  if (Enabled=false) or (Fstate = obshover) then  Exit;
  inherited MouseEnter;
  Fstate := obshover;
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
  if (Enabled=false) or (Fstate = obshover) then
  Exit;
  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then   exit;
  if (Enabled = false) or (Fstate = obsnormal) then  Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) then  exit;
  if (Enabled=false) or (Fstate = obspressed) then  Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
constructor TONURGraphicsButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname                := 'button';
  Fstate                  := obsNormal;
  Width                   := 100;
  Height                  := 30;
  foldWidth               := Width;
  foldHeight              := Height;
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


  FBGDisable              := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGHover                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGNormal               := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);
  FBGPress                := TBGRABitmap.Create(self.ClientWidth,self.ClientHeight);



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
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TONURGraphicsButton.Destroy;
begin
  FreeAndNil(FBGDisable);
  FreeAndNil(FBGHover);
  FreeAndNil(FBGNormal);
  FreeAndNil(FBGPress);
  Customcroplist.Clear;
  inherited Destroy;
end;
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.CheckAutoWidth;
begin
  {if FAutoWidth then //and Assigned(resim) then
  begin
    foldWidth  := Width;
    foldHeight := Height;
    Width      := canvas.TextWidth(Caption)+FNormalL.Width+FNormalR.Width;//resim.TextSize(caption).cx;
    Height     := canvas.TextHeight(Caption)+FNormalT.Height+FNormalB.Height;//FnormalC.Height; //resim.Height;
  end else
  begin
    Width  := foldWidth;
    Height := foldHeight;
  end;
       }
  //if Skindata<>nil then
 //   setSkindata(self.Skindata); // resize
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONURGraphicsButton.GetAutoWidth: boolean;
begin
//  Result:=FAutoWidth;
end;
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.SetSkindata(Aimg: TONURImg);
var
  tl,t,tr,bl,b,br,l,r,c:Trect;
begin
  inherited SetSkindata(Aimg);
  resizing;

  FBGNormal.SetSize(FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height+FNormalBL.Croprect.Height);
  FBGHover.SetSize(FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height+FHoverBL.Croprect.Height);
  FBGPress.SetSize(FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height+FPressBL.Croprect.Height);
  FBGDisable.SetSize(FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height+FDisableBL.Croprect.Height);


  //RECT LOAD
  tl := Rect(0,0,FNormalTL.Croprect.Width,FNormalTL.Croprect.Height);
  t  := Rect(FNormalTL.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width,FNormalT.Croprect.Height);
  tr := Rect(FNormalTL.Croprect.Width+FNormalT.Croprect.Width,0,FNormalTL.Croprect.Width+FNormalT.Croprect.Width+FNormalTR.Croprect.Width,FNormalTR.Croprect.Height);
  bl := Rect(0,FBGNormal.Height-FNormalbl.Croprect.Height,FNormalbl.Croprect.Width,FBGNormal.Height);
  b  := Rect(FNormalBL.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height,FBGNormal.Width-(FNormalBR.Croprect.Width),FBGNormal.Height);
  br := Rect(FBGNormal.Width-FNormalBR.Croprect.Width,FBGNormal.Height-FNormalBR.Croprect.Height,FBGNormal.Width,FBGNormal.Height);
  l  := Rect(0,FNormalTL.Croprect.Height,FNormalL.Croprect.Width,FNormalTL.Croprect.Height+FNormalL.Croprect.Height);
  r  := Rect(FBGNormal.Width-FNormalR.Croprect.Width,FNormalTR.Croprect.Height,FBGNormal.Width, FBGNormal.Height- FNormalBR.Croprect.Height);
  c  := Rect(FNormalL.Croprect.Width,FNormalT.Croprect.Height,FBGNormal.Width-FNormalR.Croprect.Width,FBGNormal.Height-FNormalB.Croprect.Height);

  /// LOAD FORM SKIN IMAGE TO NORMAL BUTTON IMAGE


  // NORMAL BUTTON IMAGE
  DrawPartnormal(FNormalTL.Croprect,FBGNormal,skindata.Fimage,tl,alpha);
  DrawPartnormal(FNormalT.Croprect,FBGNormal,skindata.Fimage,t,alpha);
  DrawPartnormal(FNormalTr.Croprect,FBGNormal,skindata.Fimage,tr,alpha);
  DrawPartnormal(FNormalbL.Croprect,FBGNormal,skindata.Fimage,bl,alpha);
  DrawPartnormal(FNormalb.Croprect,FBGNormal,skindata.Fimage,b,alpha);
  DrawPartnormal(FNormalBr.Croprect,FBGNormal,skindata.Fimage,br,alpha);
  DrawPartnormal(FNormalL.Croprect,FBGNormal,skindata.Fimage,l,alpha);
  DrawPartnormal(FNormalR.Croprect,FBGNormal,skindata.Fimage,r,alpha);
  DrawPartnormal(FNormalC.Croprect,FBGNormal,skindata.Fimage,c,alpha);

  BGRAReplace(FBGNormal,FBGNormal.Resample(clientWidth,clientHeight));

//  DrawPartstrechRegion(FNormalL.Croprect,FBGNormal,self.skindata.Fimage,FNormalL.Croprect.Width,ClientHeight-(FNormalTL.Croprect.Height+FNormalBl.Croprect.Height),l,alpha);
//  DrawPartstrechRegion(FNormalR.Croprect,FBGNormal,self.skindata.Fimage,FNormalR.Croprect.Width,ClientHeight-(FNormalTR.Croprect.Height+FNormalBR.Croprect.Height),r,alpha);
//  DrawPartstrechRegion(FNormalC.Croprect,FBGNormal,self.skindata.Fimage,ClientWidth-(FNormalL.Croprect.Width+FNormalR.Croprect.Width),ClientHeight-(FNormalTL.Croprect.Height+FNormalBl.Croprect.Height),c,alpha);


  //RECT LOAD
  tl := Rect(0,0,FHoverTL.Croprect.Width,FHoverTL.Croprect.Height);
  t  := Rect(FHoverTL.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width,FHoverT.Croprect.Height);
  tr := Rect(FHoverTL.Croprect.Width+FHoverT.Croprect.Width,0,FHoverTL.Croprect.Width+FHoverT.Croprect.Width+FHoverTR.Croprect.Width,FHoverTR.Croprect.Height);
  bl := Rect(0,FBGHover.Height-FHoverbl.Croprect.Height,FHoverbl.Croprect.Width,FBGHover.Height);
  b  := Rect(FHoverBL.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height,FBGHover.Width-(FHoverBR.Croprect.Width),FBGHover.Height);
  br := Rect(FBGHover.Width-FHoverBR.Croprect.Width,FBGHover.Height-FHoverBR.Croprect.Height,FBGHover.Width,FBGHover.Height);
  l  := Rect(0,FHoverTL.Croprect.Height,FHoverL.Croprect.Width,FHoverTL.Croprect.Height+FHoverL.Croprect.Height);
  r  := Rect(FBGHover.Width-FHoverR.Croprect.Width,FHoverTR.Croprect.Height,FBGHover.Width, FBGHover.Height- FHoverBR.Croprect.Height);
  c  := Rect(FHoverL.Croprect.Width,FHoverT.Croprect.Height,FBGHover.Width-FHoverR.Croprect.Width,FBGHover.Height-FHoverB.Croprect.Height);


  // HOVER BUTTON IMAGE
  DrawPartnormal(FHoverTL.Croprect,FBGHover,skindata.Fimage,tl,alpha);
  DrawPartnormal(FHoverT.Croprect,FBGHover,skindata.Fimage,t,alpha);
  DrawPartnormal(FHoverTr.Croprect,FBGHover,skindata.Fimage,tr,alpha);
  DrawPartnormal(FHoverbL.Croprect,FBGHover,skindata.Fimage,bl,alpha);
  DrawPartnormal(FHoverb.Croprect,FBGHover,skindata.Fimage,b,alpha);
  DrawPartnormal(FHoverBr.Croprect,FBGHover,skindata.Fimage,br,alpha);
  DrawPartnormal(FHoverL.Croprect,FBGHover,skindata.Fimage,l,alpha);
  DrawPartnormal(FHoverR.Croprect,FBGHover,skindata.Fimage,r,alpha);
  DrawPartnormal(FHoverC.Croprect,FBGHover,skindata.Fimage,c,alpha);

  BGRAReplace(FBGHover,FBGHover.Resample(clientWidth,clientHeight));



  //RECT LOAD
  tl := Rect(0,0,FPressTL.Croprect.Width,FPressTL.Croprect.Height);
  t  := Rect(FPressTL.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width,FPressT.Croprect.Height);
  tr := Rect(FPressTL.Croprect.Width+FPressT.Croprect.Width,0,FPressTL.Croprect.Width+FPressT.Croprect.Width+FPressTR.Croprect.Width,FPressTR.Croprect.Height);
  bl := Rect(0,FBGPress.Height-FPressbl.Croprect.Height,FPressbl.Croprect.Width,FBGPress.Height);
  b  := Rect(FPressBL.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height,FBGPress.Width-(FPressBR.Croprect.Width),FBGPress.Height);
  br := Rect(FBGPress.Width-FPressBR.Croprect.Width,FBGPress.Height-FPressBR.Croprect.Height,FBGPress.Width,FBGPress.Height);
  l  := Rect(0,FPressTL.Croprect.Height,FPressL.Croprect.Width,FPressTL.Croprect.Height+FPressL.Croprect.Height);
  r  := Rect(FBGPress.Width-FPressR.Croprect.Width,FPressTR.Croprect.Height,FBGPress.Width, FBGPress.Height- FPressBR.Croprect.Height);
  c  := Rect(FPressL.Croprect.Width,FPressT.Croprect.Height,FBGPress.Width-FPressR.Croprect.Width,FBGPress.Height-FPressB.Croprect.Height);



 // HOVER BUTTON IMAGE
  DrawPartnormal(FPressTL.Croprect,FBGPress,skindata.Fimage,tl,alpha);
  DrawPartnormal(FPressT.Croprect,FBGPress,skindata.Fimage,t,alpha);
  DrawPartnormal(FPressTr.Croprect,FBGPress,skindata.Fimage,tr,alpha);
  DrawPartnormal(FPressbL.Croprect,FBGPress,skindata.Fimage,bl,alpha);
  DrawPartnormal(FPressb.Croprect,FBGPress,skindata.Fimage,b,alpha);
  DrawPartnormal(FPressBr.Croprect,FBGPress,skindata.Fimage,br,alpha);
  DrawPartnormal(FPressL.Croprect,FBGPress,skindata.Fimage,l,alpha);
  DrawPartnormal(FPressR.Croprect,FBGPress,skindata.Fimage,r,alpha);
  DrawPartnormal(FPressC.Croprect,FBGPress,skindata.Fimage,c,alpha);

  BGRAReplace(FBGPress,FBGPress.Resample(clientWidth,clientHeight));


//RECT LOAD
  tl := Rect(0,0,FDisableTL.Croprect.Width,FDisableTL.Croprect.Height);
  t  := Rect(FDisableTL.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width,FDisableT.Croprect.Height);
  tr := Rect(FDisableTL.Croprect.Width+FDisableT.Croprect.Width,0,FDisableTL.Croprect.Width+FDisableT.Croprect.Width+FDisableTR.Croprect.Width,FDisableTR.Croprect.Height);
  bl := Rect(0,FBGDisable.Height-FDisablebl.Croprect.Height,FDisablebl.Croprect.Width,FBGDisable.Height);
  b  := Rect(FDisableBL.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height,FBGDisable.Width-(FDisableBR.Croprect.Width),FBGDisable.Height);
  br := Rect(FBGDisable.Width-FDisableBR.Croprect.Width,FBGDisable.Height-FDisableBR.Croprect.Height,FBGDisable.Width,FBGDisable.Height);
  l  := Rect(0,FDisableTL.Croprect.Height,FDisableL.Croprect.Width,FDisableTL.Croprect.Height+FDisableL.Croprect.Height);
  r  := Rect(FBGDisable.Width-FDisableR.Croprect.Width,FDisableTR.Croprect.Height,FBGDisable.Width, FBGDisable.Height- FDisableBR.Croprect.Height);
  c  := Rect(FDisableL.Croprect.Width,FDisableT.Croprect.Height,FBGDisable.Width-FDisableR.Croprect.Width,FBGDisable.Height-FDisableB.Croprect.Height);



 // PRESS BUTTON IMAGE
  DrawPartnormal(FDisableTL.Croprect,FBGDisable,skindata.Fimage,tl,alpha);
  DrawPartnormal(FDisableT.Croprect,FBGDisable,skindata.Fimage,t,alpha);
  DrawPartnormal(FDisableTr.Croprect,FBGDisable,skindata.Fimage,tr,alpha);
  DrawPartnormal(FDisablebL.Croprect,FBGDisable,skindata.Fimage,bl,alpha);
  DrawPartnormal(FDisableb.Croprect,FBGDisable,skindata.Fimage,b,alpha);
  DrawPartnormal(FDisableBr.Croprect,FBGDisable,skindata.Fimage,br,alpha);
  DrawPartnormal(FDisableL.Croprect,FBGDisable,skindata.Fimage,l,alpha);
  DrawPartnormal(FDisableR.Croprect,FBGDisable,skindata.Fimage,r,alpha);
  DrawPartnormal(FDisableC.Croprect,FBGDisable,skindata.Fimage,c,alpha);

  BGRAReplace(FBGDisable,FBGDisable.Resample(clientWidth,clientHeight));


end;

procedure TONURGraphicsButton.resize;
begin
  inherited Resize;
  {
  FoldWidth  := Width;
  FoldHeight := Height;
 // CheckAutoWidth;  }
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURGraphicsButton.resizing;
//var
//   tl,t,tr,bl,b,br,l,r,c:Tpoint;
begin
 { FNormalleft.Targetrect   := RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect  := RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);
  FNormaltop.Targetrect    := RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);
  FNormalbottom.Targetrect := RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect       := RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,self.ClientHeight-FNormalbottom.Height);
}
//  tl.x:=self.ClientWidth div 3;
//  tl.y:=self.ClientHeight div 3;
//  ShowMessage(inttostr(tl.x)+'   '+inttostr(FNormalTL.Width)+'   '+inttostr(tl.y)+'   '+inttostr(FNormalTL.Height));


 {
   FNormalTL.Targetrect  := Rect(0, 0,FNormalTL.Width,FNormalTL.Height);
   FNormalTR.Targetrect  := Rect(self.ClientWidth - FNormalTR.Width,0, self.ClientWidth, FNormalTR.Height);
   FNormalT.Targetrect   := Rect(FNormalTL.Width, 0,self.ClientWidth - FNormalTR.Width,FNormalT.Height);
   FNormalBL.Targetrect  := Rect(0, self.ClientHeight - FNormalBL.Height,FNormalBL.Width, self.ClientHeight);
   FNormalBR.Targetrect  := Rect(self.ClientWidth - FNormalBR.Width,self.ClientHeight - FNormalBR.Height, self.ClientWidth, self.ClientHeight);
   FNormalB.Targetrect   := Rect(FNormalBL.Width,self.ClientHeight - FNormalB.Height, self.ClientWidth - FNormalBR.Width, self.ClientHeight);
   FNormalL.Targetrect   := Rect(0, FNormalTL.Height,FNormalL.Width, self.ClientHeight - FNormalBL.Height);
   FNormalR.Targetrect   := Rect(self.ClientWidth - FNormalR.Width, FNormalTR.Height, self.ClientWidth, self.ClientHeight - FNormalBR.Height);
   FNormalC.Targetrect   := Rect(FNormalL.Width, FNormalT.Height, self.ClientWidth - FNormalR.Width, self.ClientHeight -(FNormalB.Height));
 }
{
  FBGDisable.setsize(self.ClientWidth,Self.ClientHeight);
  FBGHover.setsize(self.ClientWidth,Self.ClientHeight);
  FBGNormal.setsize(self.ClientWidth,Self.ClientHeight);
  FBGPress.setsize(self.ClientWidth,Self.ClientHeight);

}
end;

// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.Paint;
begin
  if not Visible then exit;
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    resim.SetSize(0,0);
    resim.SetSize(clientWidth,clientHeight);

    if Enabled = True then
    begin
      case Fstate of
            obsNormal  : begin resim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
            obshover   : begin resim.PutImage(0,0,FBGHover,dmDrawWithTransparency); self.font.Color:=FHoverC.Fontcolor end;
            obspressed : begin resim.PutImage(0,0,FBGPress,dmDrawWithTransparency); self.font.Color:=FPressC.Fontcolor end;
            else
            begin resim.PutImage(0,0,FBGNormal,dmDrawWithTransparency); self.font.Color:=FNormalC.Fontcolor end;
      end;
    end else
    begin
      resim.PutImage(0,0,FBGDisable,dmDrawWithTransparency); self.font.Color:=FDisableC.Fontcolor;
    end;
  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
    case Fstate of
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
// -----------------------------------------------------------------------------


{ TONURNavMenuButton }

function TONURNavMenuButton.GetMovable: Boolean;
begin
  Result:=fmoveable;
end;

procedure TONURNavMenuButton.SetMovable(AValue: Boolean);
begin
 if AValue<> fmoveable then
  fmoveable := AValue;
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
  if Assigned(factiveButton) then
    Result := FButton.IndexOf(factiveButton)
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
  Ftop.Targetrect          := Rect(FTopleft.Croprect.Width, 0, self.clientWidth - FTopRight.Croprect.Width, FTop.Croprect.Height);
  FBottomleft.Targetrect   := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height, FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect  := Rect(self.clientWidth - FBottomRight.Croprect.Width,  self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect       := Rect(FBottomleft.Croprect.Width,self.clientHeight - FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
  Fleft.Targetrect         := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.clientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect        := Rect(self.clientWidth - FRight.Croprect.Width,FTopRight.Croprect.Height, self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect       := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth - FRight.Croprect.Width, self.clientHeight -FBottom.Croprect.Height);


   if Fbutton.Count > 0 then
   begin
    ChildSizing.TopBottomSpacing := Ftop.Croprect.Height;
    ChildSizing.LeftRightSpacing := Fleft.Targetrect.Width;
    ChildSizing.VerticalSpacing  := Ftop.Croprect.Height;

    for i := 0 to Fbutton.Count - 1 do
    begin
      if self.Skindata <> nil then
      Buttons[i].Skindata := self.Skindata;
    end;
   end;
end;

procedure TONURNavMenuButton.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (GetKeyState(VK_LBUTTON) < 0) and (fmoveable = true) then
  begin
    self.Parent.left := Mouse.CursorPos.X - (FMousePoint.X - FFormPoint.X);
    self.Parent.top  := Mouse.CursorPos.Y - (FMousePoint.Y - FFormPoint.Y);
  end;
end;


procedure TONURNavMenuButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (GetKeyState(VK_LBUTTON) < 0) and (fmoveable = true) then
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
    SetActiveButton(Buttons[ButtonIndex]);
end;

procedure TONURNavMenuButton.DoButtonChanged;
begin
  if not (csDestroying in ComponentState) and Assigned(FbuttonChanged) then
    FbuttonChanged(Self);
end;

function TONURNavMenuButton.DoButtonChanging(NewButtonIndex: integer): boolean;
begin
   Result := True;
  if Assigned(FbuttonChanging) then
    FbuttonChanging(Self, NewbuttonIndex, Result);
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
  Fdisable              := TONURCUSTOMCROP.Create('BUTTONDISABLE');

  Captionvisible        := False;
  fmoveable             := true;

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
  for A := Fbutton.Count - 1 downto 0 do
    Buttons[A].Free;

{   for A:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[A]).free;
 }
  Customcroplist.Clear;
  Fbutton.Free;
  inherited Destroy;
end;

procedure TONURNavMenuButton.Paint;
begin
   // WriteLn('OK');
   if not Visible then exit;

     resim.SetSize(0, 0);
     resim.SetSize(self.ClientWidth, self.ClientHeight);

     if (Skindata <> nil) and not (csDesigning in ComponentState) then
     begin

       //CENTER //ORTA
       DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);

       //TOPLEFT   //SOLÜST
       DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
       //TOPRIGHT //SAĞÜST
       DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
       //TOP  //ÜST
       DrawPartnormal(ftop.Croprect, self, FTop.Targetrect, alpha);
       //BOTTOMLEFT // SOLALT
       DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
       //BOTTOMRIGHT  //SAĞALT
       DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
       //BOTTOM  //ALT
       DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
       //LEFT CENTERLEFT // SOLORTA
       DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
       //CENTERRIGHT // SAĞORTA
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
   if factiveButton = Buttoni then
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
  if (Enabled = False) or (Fstate = obshover) then
    Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;

procedure TONURNavButton.MouseLeave;
begin
    if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (Fstate = obsnormal) then
    Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
   if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (Fstate = obspressed) then
    Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;
end;

procedure TONURNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
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
  Fstate := obsNormal;

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

  if (Skindata <> nil) and not (csDesigning in ComponentState) and Assigned(FButtonControl) then
  begin
    try


      if Enabled = True then
      begin
        case Fstate of
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
      DrawPartnormal(DR, self, Rect(0, 0, self.Width, self.Height), Alpha);
    finally

    end;
  end
  else
  begin
  //  resim.Fill(BGRA(100, 150, 100, alpha), dmSet);
     resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
  //  resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    case Fstate of
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



procedure TONURSwich.CMonmouseenter(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obshover;
  Invalidate;
end;

procedure TONURSwich.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obsnormal;
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
    fchecked := not fchecked;
    fState := obsnormal;//obspressed;
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
  fstate := obsnormal;
  Invalidate;
end;



constructor TONURSwich.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname       := 'swich';
  Fstate         := obsnormal;
  FChecked       := False;
  Captionvisible := False;
  FOpen          := TONURCUSTOMCROP.Create('OPEN');
  Fclose         := TONURCUSTOMCROP.Create('CLOSE');
  Fopenhover     := TONURCUSTOMCROP.Create('OPENHOVER');
  Fclosehover    := TONURCUSTOMCROP.Create('CLOSEHOVER');
  FdisableOn     := TONURCUSTOMCROP.Create('DISABLEON');
  FdisableOFF    := TONURCUSTOMCROP.Create('DISABLEOFF');
  foncap         := 'ON';
  foffcap        := 'OFF';

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

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
      if Enabled = True then
      begin
        if Checked = True then
        begin
          case Fstate of
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
          case Fstate of
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
          DR := Fdisableon.Croprect;
          Self.Font.Color := Fdisableon.Fontcolor;
        end else
        begin
          DR := Fdisableoff.Croprect;
          Self.Font.Color := Fdisableoff.Fontcolor;
        end;
      end;

      DrawPartstrech(DR, self, self.ClientWidth, self.ClientHeight, alpha);

  end
  else
  begin
    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
    resim.Fill(BGRAPixelTransparent);
    case Fstate of
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

    if Checked = True then
      resim.FillRect(rect(0,0,Width div 2,Height),BGRA(155, 155, 155),dmset)
    else
     resim.FillRect(rect(Width div 2,0,Width,Height),BGRA(155, 155, 155),dmset);
  end;

   if Checked = True then
     yaziyazBGRA(resim.CanvasBGRA,self.font,rect(Width div 2,0,Width,Height),foncap,tacenter)
   else
     yaziyazBGRA(resim.CanvasBGRA,self.font,rect(Height div 2,0,Width div 2,Height),foffcap,tacenter);

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
  Result := fcheckwidth;
end;

procedure TONURCheckbox.SetCheckWidth(AValue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;

procedure TONURCheckbox.SetCaptionmod(const val: TONURCapDirection);
begin
  if fcaptiondirection = val then  exit;
  fcaptiondirection := val;
  Invalidate;
end;

function TONURCheckbox.GetCaptionmod: TONURCapDirection;
begin
  Result := fcaptiondirection;
end;


procedure TONURCheckbox.CMonmouseenter(var Messages: Tmessage);
begin
  fstate := obshover;
  Invalidate;
end;

procedure TONURCheckbox.CMonmouseleave(var Messages: Tmessage);
begin
  fstate := obsnormal;
  Invalidate;
end;

procedure TONURCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mousedown(button, shift, x, y);
  if Button = mbLeft then
  begin
    fchecked := not fchecked;
    fState := obspressed;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end;
end;

procedure TONURCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mouseup(button, shift, x, y);
  fstate := obshover;
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
  fcheckwidth       := 12;
  fcaptiondirection := ocright;
  Fstate            := obsnormal;
  FChecked          := False;
  Captionvisible    := False;
  textx             := 10;
  Texty             := 10;
  obenter           := TONURCUSTOMCROP.Create('NORMALHOVER');
  obleave           := TONURCUSTOMCROP.Create('NORMAL');
  obdown            := TONURCUSTOMCROP.Create('PRESSED');
  obcheckleaves     := TONURCUSTOMCROP.Create('CHECK');
  obcheckenters     := TONURCUSTOMCROP.Create('CHECKHOVER');
  obdisableoff      := TONURCUSTOMCROP.Create('DISABLENORMAL');
  obdisableon       := TONURCUSTOMCROP.Create('DISABLECHECK');



  Customcroplist.Add(obleave);
  Customcroplist.Add(obenter);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obdisableon);
  Customcroplist.Add(obdisableoff);



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
  fbuttoncenter,a,b: integer;
begin

  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Enabled = True then
    begin
      if Checked = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR :=obcheckleaves.Croprect;
            Self.Font.Color := obcheckleaves.Fontcolor;
          end;
          obshover:
          begin
            DR :=obcheckenters.Croprect;
            Self.Font.Color := obcheckenters.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end
      else
      begin
        case Fstate of
          obsNormal:
          begin
            DR := obleave.Croprect;
            Self.Font.Color := obleave.Fontcolor;
          end;
          obshover:
          begin
            DR := obenter.Croprect;
            Self.Font.Color := obenter.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end;
    end
    else
    begin
      if Checked = True then
        begin
          DR := obdisableon.Croprect;
          Self.Font.Color := obdisableon.Fontcolor;
        end else
        begin
          DR := obdisableoff.Croprect;
          Self.Font.Color := obdisableoff.Fontcolor;
        end;
    end;





    case fCaptionDirection of
      ocup:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := DR.Top; //obleave.Croprect.Top;//fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) + (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocdown:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := (self.clientHeight div 2) + Dr.Top;//obleave.Croprect.Top;// + fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) - (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocleft:
      begin
        textx := self.ClientWidth - (fcheckwidth + self.canvas.TextWidth(Caption) + 5);
        Texty := (self.clientHeight div 2) - (self.canvas.TextHeight(Caption) div 2);
        fbuttoncenter := (self.clientHeight div 2) - (fcheckwidth div 2);
        Fclientrect := Rect(self.ClientWidth - fcheckwidth, fbuttoncenter, self.ClientWidth,
          fbuttoncenter + fcheckwidth);
      end;
      ocright:
      begin
        textx := fcheckwidth + 5;
        Texty := (self.clientHeight div 2) - (self.canvas.TextHeight(Caption) div 2);
        fbuttoncenter := (self.clientHeight div 2) - (fcheckwidth div 2);
        Fclientrect := Rect(0, fbuttoncenter, fcheckwidth, fbuttoncenter + fcheckwidth);
      end;
    end;

    DrawPartnormal(DR, Self, Fclientrect, alpha);
  end
  else
  begin

    resim.SetSize(0,0);
    resim.SetSize(self.Width, Self.Height);
    resim.Fill(BGRAPixelTransparent);


    case fCaptionDirection of
      ocup:
      begin
        a:= (self.ClientWidth div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx := a - (resim.CanvasBGRA.TextWidth(Caption) div 2);
        Texty := 0;
        Fclientrect :=rect(a,b, a+fcheckwidth,b+fcheckwidth);
      end;
      ocdown:
      begin
        a:= (self.ClientWidth div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx := a - (resim.CanvasBGRA.TextWidth(Caption) div 2);
        Texty := self.ClientHeight-b;
        Fclientrect :=rect(a,0, a+fcheckwidth,fcheckwidth);
      end;
      ocleft:
      begin
        a:= (self.clientHeight div 2);
        b:= resim.CanvasBGRA.TextWidth(Caption);
        textx :=5;
        Texty := a - resim.CanvasBGRA.TextHeight(Caption);
        Fclientrect := Rect(b+resim.CanvasBGRA.TextHeight(Caption),0,b+fcheckwidth+resim.CanvasBGRA.TextHeight(Caption),fcheckwidth);
      end;
      ocright:
      begin
        a:= (self.clientHeight div 2);
        b:= resim.CanvasBGRA.TextHeight(Caption);
        textx :=fcheckwidth+5;
        Texty := a - b;
        Fclientrect := Rect(0,0,CheckWidth,fcheckwidth);
      end;
    end;
    //resim.FillRectAntialias(a+b,a+b,a-b,a-b,BGRA(155, 155, 155))

    if Checked = True then
     resim.Rectangle(Fclientrect,bgrablack,bgra(155, 155, 155),dmset)
    else
     resim.Rectangle(Fclientrect,bgrablack,BGRAPixelTransparent,dmset);


  end;

  yaziyazBGRA(resim.CanvasBGRA,self.font,Rect(textx,Texty,textx+resim.CanvasBGRA.TextWidth(Caption),Texty+resim.CanvasBGRA.TextHeight(Caption)),caption,taCenter);


  inherited paint;

  {
  if (Length(Caption) > 0) and  (Skindata <> nil) then
  begin
    //self.resim.TextOut(textx,Texty,(Caption+' RRR'),ColorToBGRA(self.font.Color));
    canvas.Brush.Style := bsClear;
    canvas.TextOut(Textx, Texty, Caption);
  end;
  }
  //inherited paint;
end;


end.


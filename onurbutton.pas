unit onurbutton;

{$mode objfpc}{$H+}

interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Dialogs, types, LazUTF8, Contnrs,onurctrl;

type

  //SYSTEM BUTTON -- close minimize help tray etc..

   { TONURsystemButton }

   TONURsystemButton = class(TONURGraphicControl)
  private
    Fnormal    : TONURCUSTOMCROP;
    FPress     : TONURCUSTOMCROP;
    FEnter     : TONURCUSTOMCROP;
    Fdisable   : TONURCUSTOMCROP;
    Fstate     : TONURButtonState;
    FAutoWidth : boolean;
    procedure SetSkindata(Aimg: TONURImg); override;
  protected
  {  }
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    //    procedure MouseMove(Shift: TShiftState; X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    property ONORMAL: TONURCUSTOMCROP read FNormal write FNormal;
    property OPRESSED: TONURCUSTOMCROP read FPress write FPress;
    property OHOVER: TONURCUSTOMCROP read FEnter write FEnter;
    property ODISABLE: TONURCUSTOMCROP read Fdisable write Fdisable;
  protected
  published
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
    property Transparent;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;




  TONURCropButton = class(TONURCustomControl)
  private
    FNormalleft,FNormalright,
    FNormaltop,FNormalbottom,
    Fnormal : TONURCUSTOMCROP;

    FPressleft,FPressright,
    FPresstop,FPressbottom,
    FPress  : TONURCUSTOMCROP;

    FEnterleft,FEnterright,
    FEntertop,FEnterbottom,
    FEnter  : TONURCUSTOMCROP;

    Fdisableleft,Fdisableright,
    Fdisabletop,Fdisablebottom,
    Fdisable  : TONURCUSTOMCROP;

    Fstate           : TONURButtonState;
    FAutoWidth       : boolean;
    procedure SetSkindata(Aimg: TONURImg); override;
  protected
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

    property ONORMAL: TONURCUSTOMCROP read FNormal write FNormal;
    property ONORMALLEFT: TONURCUSTOMCROP read FNormalleft write FNormalleft;
    property ONORMALRIGHT: TONURCUSTOMCROP read FNormalright write FNormalright;
    property ONORMALTOP: TONURCUSTOMCROP read FNormaltop write FNormaltop;
    property ONORMALBOTTOM: TONURCUSTOMCROP read FNormalbottom write FNormalbottom;


    property OPRESSED: TONURCUSTOMCROP read FPress write FPress;
    property OPRESSEDLEFT: TONURCUSTOMCROP read FPressleft write FPressleft;
    property OPRESSEDRIGHT: TONURCUSTOMCROP read FPressright write FPressright;
    property OPRESSEDTOP: TONURCUSTOMCROP read FPresstop write FPresstop;
    property OPRESSEDBOTTOM: TONURCUSTOMCROP read FPressbottom write FPressbottom;

    property OHOVER: TONURCUSTOMCROP read FEnter write FEnter;
    property OHOVERLEFT: TONURCUSTOMCROP read FEnterleft write FEnterleft;
    property OHOVERRIGHT: TONURCUSTOMCROP read FEnterright write FEnterright;
    property OHOVERTOP: TONURCUSTOMCROP read FEntertop write FEntertop;
    property OHOVERBOTTOM: TONURCUSTOMCROP read FEnterbottom write FEnterbottom;

    property ODISABLE: TONURCUSTOMCROP read Fdisable write Fdisable;
    property ODISABLELEFT: TONURCUSTOMCROP read Fdisableleft write Fdisableleft;
    property ODISABLERIGHT: TONURCUSTOMCROP read Fdisableright write Fdisableright;
    property ODISABLETOP: TONURCUSTOMCROP read Fdisabletop write Fdisabletop;
    property ODISABLEBOTTOM: TONURCUSTOMCROP read Fdisablebottom write Fdisablebottom;

  published
    property Alpha;
    property Skindata;
    property AutoWidth  : boolean       read FAutoWidth write SetAutoWidth default True;
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


  { TONURGraphicsButton }

  { TONURGraphicsButton }

  TONURGraphicsButton = class(TONURGraphicControl)
  private
    FNormalleft,FNormalright,
    FNormaltop,FNormalbottom,
    Fnormal : TONURCUSTOMCROP;

    FPressleft,FPressright,
    FPresstop,FPressbottom,
    FPress  : TONURCUSTOMCROP;

    FEnterleft,FEnterright,
    FEntertop,FEnterbottom,
    FEnter  : TONURCUSTOMCROP;

    Fdisableleft,Fdisableright,
    Fdisabletop,Fdisablebottom,
    Fdisable  : TONURCUSTOMCROP;

    Fstate: TONURButtonState;
    FAutoWidth: boolean;
    procedure SetSkindata(Aimg: TONURImg); override;
  protected
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    //    procedure MouseMove(Shift: TShiftState; X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;

    property ONORMAL: TONURCUSTOMCROP read FNormal write FNormal;
    property ONORMALLEFT: TONURCUSTOMCROP read FNormalleft write FNormalleft;
    property ONORMALRIGHT: TONURCUSTOMCROP read FNormalright write FNormalright;
    property ONORMALTOP: TONURCUSTOMCROP read FNormaltop write FNormaltop;
    property ONORMALBOTTOM: TONURCUSTOMCROP read FNormalbottom write FNormalbottom;


    property OPRESSED: TONURCUSTOMCROP read FPress write FPress;
    property OPRESSEDLEFT: TONURCUSTOMCROP read FPressleft write FPressleft;
    property OPRESSEDRIGHT: TONURCUSTOMCROP read FPressright write FPressright;
    property OPRESSEDTOP: TONURCUSTOMCROP read FPresstop write FPresstop;
    property OPRESSEDBOTTOM: TONURCUSTOMCROP read FPressbottom write FPressbottom;

    property OHOVER: TONURCUSTOMCROP read FEnter write FEnter;
    property OHOVERLEFT: TONURCUSTOMCROP read FEnterleft write FEnterleft;
    property OHOVERRIGHT: TONURCUSTOMCROP read FEnterright write FEnterright;
    property OHOVERTOP: TONURCUSTOMCROP read FEntertop write FEntertop;
    property OHOVERBOTTOM: TONURCUSTOMCROP read FEnterbottom write FEnterbottom;

    property ODISABLE: TONURCUSTOMCROP read Fdisable write Fdisable;
    property ODISABLELEFT: TONURCUSTOMCROP read Fdisableleft write Fdisableleft;
    property ODISABLERIGHT: TONURCUSTOMCROP read Fdisableright write Fdisableright;
    property ODISABLETOP: TONURCUSTOMCROP read Fdisabletop write Fdisabletop;
    property ODISABLEBOTTOM: TONURCUSTOMCROP read Fdisablebottom write Fdisablebottom;
  protected
  published
    property Alpha;
    property Skindata;
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



  { TONURSwich }

  TONURSwich = class(TONURGraphicControl)
  private
    FOpen, Fclose, Fopenhover, Fclosehover, Fdisable: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    FChecked: boolean;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    property OOPEN: TONURCUSTOMCROP read FOpen write FOpen;
    property OCLOSE: TONURCUSTOMCROP read Fclose write Fclose;
    property OOPENHOVER: TONURCUSTOMCROP read Fopenhover write Fopenhover;
    property OCLOSEHOVER: TONURCUSTOMCROP read Fclosehover write Fclosehover;
    property ODISABLE: TONURCUSTOMCROP read Fdisable write Fdisable;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Alpha;
    property Skindata;
    property Checked: boolean read FChecked write SetChecked default False;
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
    obenter, obleave, obdown, obdisabled, obcheckenters, obcheckleaves: TONURCUSTOMCROP;
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
    procedure deaktifdigerleri;  /// for radiobutton
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
    procedure CMHittest(var msg: TCMHIttest);

    property ONORMAL: TONURCUSTOMCROP read obleave write obleave;
    property ONORMALHOVER: TONURCUSTOMCROP read obenter write obenter;
    property ONORMALDOWN: TONURCUSTOMCROP read obdown write obdown;
    property OCHECKED: TONURCUSTOMCROP read obcheckleaves write obcheckleaves;
    property OCHECKEDHOVER: TONURCUSTOMCROP read obcheckenters write obcheckenters;
    property ODISABLE: TONURCUSTOMCROP read obdisabled write obdisabled;
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
    obdown, obdisabled,
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
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
    procedure CMHittest(var msg: TCMHIttest);

    property ONORMAL: TONURCUSTOMCROP read obleave write obleave;
    property ONORMALHOVER: TONURCUSTOMCROP read obenter write obenter;
    property ONORMALDOWN: TONURCUSTOMCROP read obdown write obdown;
    property OCHECKED: TONURCUSTOMCROP read obcheckleaves write obcheckleaves;
    property OCHECKEDHOVER: TONURCUSTOMCROP read obcheckenters write obcheckenters;
    property ODISABLE: TONURCUSTOMCROP read obdisabled write obdisabled;
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
    Flist: TStrings;
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
    procedure SetString(AValue: TStrings); virtual;
    procedure listchange(Sender: TObject);
    Procedure SetSkindata(Aimg: TONURImg); override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;


    property OCLIENT: TONURCUSTOMCROP  read fclientp write fclientp;

  published
    { Published declarations }
    property Strings: TStrings read Flist write SetString;
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

  { TONNormalLabel }

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
    procedure SetText(AValue: string);
    procedure Settimerinterval(AValue: integer);
    procedure Setwaiting(AValue: byte);
    procedure SetYazibuyuk(AValue: boolean);
    procedure TimerEvent(Sender: TObject);
    procedure DrawFontText;
    procedure FreeTimer;
    procedure Blinktimerevent(sender:TObject);
    procedure Loaded; override;
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
    procedure SetSkindata(Aimg: TONURImg); override;
 public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
 protected
    procedure MouseEnter; override;
    procedure MouseLeave; override;
 public
    property OLEDONNORMAL  : TONURCUSTOMCROP read Fonclientp   write Fonclientp;
    property OLEDONHOVER   : TONURCUSTOMCROP read Fonclientph  write Fonclientph;
    property OLEDOFFNORMAL : TONURCUSTOMCROP read Foffclientp  write Foffclientp;
    property OLEDOFFHOVER  : TONURCUSTOMCROP read Foffclientph write Foffclientph;
    property ODISABLED     : TONURCUSTOMCROP read Fdisabled    write Fdisabled;
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
    property Caption;
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


procedure Register;



implementation

uses BGRAPath, LazUnicode,BGRAFreeType, LazFreeTypeFontCollection,BGRATransform;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURsystemButton]);
  RegisterComponents('ONUR', [TONURCropButton]);
  RegisterComponents('ONUR', [TONURGraphicsButton]);
  RegisterComponents('ONUR', [TONURSwich]);
  RegisterComponents('ONUR', [TONURCheckbox]);
  RegisterComponents('ONUR', [TONURRadioButton]);
  RegisterComponents('ONUR', [TONURlabel]);
  RegisterComponents('ONUR', [TONURNormalLabel]);
  RegisterComponents('ONUR', [TONURLed]);
end;



{ TONURsystemButton }



procedure TONURsystemButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

constructor TONURsystemButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname          := 'closebutton';
  FNormal           := TONURCUSTOMCROP.Create;
  FNormal.cropname  := 'NORMAL';
  FPress            := TONURCUSTOMCROP.Create;
  FPress.cropname   := 'PRESSED';
  FEnter            := TONURCUSTOMCROP.Create;
  FEnter.cropname   := 'HOVER';
  Fdisable          := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';

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
end;

destructor TONURsystemButton.Destroy;
var
  A: integer;
begin
   for A:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[A]).free;

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
    try
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

    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190), dmSet);
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
  //  paint;
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
var
 fbuttoncenter: integer;
begin
  inherited SetSkindata(Aimg);

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
   // fchecked := not fchecked;
    fState := obspressed;
    //if Assigned(FOnChange) then FOnChange(Self);
    SetChecked(true);
   // deaktifdigerleri;
   //  Invalidate;

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
  skinname := 'radiobox';
  fcheckwidth := 12;
  fcaptiondirection := ocright;
  obenter := TONURCUSTOMCROP.Create;
  obenter.cropname := 'NORMALHOVER';
  obleave := TONURCUSTOMCROP.Create;
  obleave.cropname := 'NORMAL';
  obdown := TONURCUSTOMCROP.Create;
  obdown.cropname := 'PRESSED';
  obcheckleaves := TONURCUSTOMCROP.Create;
  obcheckleaves.cropname := 'CHECK';
  obcheckenters := TONURCUSTOMCROP.Create;
  obcheckenters.cropname := 'CHECKHOVER';
  obdisabled := TONURCUSTOMCROP.Create;
  obdisabled.cropname := 'DISABLE';

  Customcroplist.Add(obenter);
  Customcroplist.Add(obleave);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obdisabled);


  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;
  textx:=10;
  Texty:=10;
end;

destructor TONURRadioButton.Destroy;
var
 i:byte;
begin
 for i:=0 to Customcroplist.Count-1 do
 TONURCUSTOMCROP(Customcroplist.Items[i]).free;

 Customcroplist.Clear;
{begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);
  FreeAndNil(obdisabled); }
  inherited Destroy;
end;

procedure TONURRadioButton.Paint;
var
  DR: TRect;
  fbuttoncenter: integer;
begin
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin



     case fCaptionDirection of
      ocup:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := obleave.Croprect.Top;//fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) + (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocdown:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := ((self.clientHeight div 2)) + obleave.Croprect.Top;// + fborderWidth;
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
      DR := obdisabled.Croprect;
      Self.Font.Color := obdisabled.Fontcolor;
    end;
    DrawPartnormal(DR, Self, Fclientrect, alpha);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited paint;

  if Length(Caption) > 0 then
  begin
    canvas.Brush.Style := bsClear;
    canvas.TextOut(Textx, Texty, (Caption));
  end;
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
  FBuffer.FontName := self.font.Name;
  FBuffer.FontHeight := -self.font.Size;
  FBuffer.SetSize(FBuffer.TextSize(FText).cx, self.ClientHeight);
  FBuffer.TextRect(FBuffer.ClipRect,FText,taLeftJustify,tlcenter,BGRAToColor(self.font.color));

  //FBuffer.TextOut(0, 0, FText, BGRAToColor(self.font.color), False);

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
  Fonclientp            := TONURCUSTOMCROP.Create;
  Fonclientp.cropname   := 'LEDONNORMAL';
  Fonclientph           := TONURCUSTOMCROP.Create;
  Fonclientph.cropname  := 'LEDONHOVER';
  Foffclientp           := TONURCUSTOMCROP.Create;
  Foffclientp.cropname  := 'LEDOFFNORMAL';
  Foffclientph          := TONURCUSTOMCROP.Create;
  Foffclientph.cropname := 'LEDOFFHOVER';
  Fdisabled             := TONURCUSTOMCROP.Create;
  Fdisabled.cropname    := 'LEDDISABLE';

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
var
 i:byte;
begin
 for i:=0 to Customcroplist.Count-1 do
 TONURCUSTOMCROP(Customcroplist.Items[i]).free;

 Customcroplist.Clear;
{begin
  FreeAndNil(Fonclientp);
  FreeAndNil(Fonclientph);
  FreeAndNil(Foffclientp);
  FreeAndNil(Foffclientph);
  FreeAndNil(Fdisabled); }


  inherited Destroy;
End;


procedure TONURLed.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURLed.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
//  if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
//  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
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
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
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


function TONURLabel.GetScrollBy: integer;
begin
  Result := ABS(FScrollBy);
end;

procedure TONURLabel.SetActive(Value: boolean);
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

procedure TONURLabel.Setcaption(Avalue: Tcaption);
begin
  if fcaption = Avalue then Exit;
  fcaption := Avalue;
  Getbmp;
  Invalidate;
end;

procedure TONURLabel.SetStretch(Value: boolean);
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

procedure TONURLabel.SetInterval(Value: cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    FTimer.Interval := Value;
  end;
end;



procedure TONURLabel.Activate;
begin
  FActive := True;
  FTimer.Enabled := True;
  FTimer.Interval := FInterval;
  FWaiting := False;

  FCurPos := 0;
  FScrollBy := ABS(FScrollBy);
  Invalidate;
end;

procedure TONURLabel.Deactivate;
begin
  FTimer.Enabled := False;
  FActive := False;
  Invalidate;
end;

procedure TONURLabel.UpdatePos;
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

procedure TONURLabel.DoOnTimer(Sender: TObject);
begin
  if FWaiting then
  begin
    FTimer.Interval := FInterval;
    FWaiting := False;
  end;

  UpDatePos;
  Invalidate;
end;

procedure TONURLabel.SetCharWidth(Value: integer);
begin
  if Value = CharWidth then exit;
  fCharWidth := Value;
  Getbmp;
  Invalidate;
end;

procedure TONURLabel.SetCharHeight(Value: integer);
begin
  if Value = CharHeight then exit;
  fCharHeight := Value;
  Getbmp;
  Invalidate;
end;



procedure TONURLabel.SetString(AValue: TStrings);
begin
  if Flist = AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
  Getbmp;
end;

procedure TONURLabel.listchange(Sender: TObject);
begin
  Getbmp;
end;



constructor TONURLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'label';
  fclientp := TONURCUSTOMCROP.Create;
  fclientp.cropname := 'ONCLIENT';
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




  Flist := TStringList.Create;

  FTimer := TTimer.Create(nil);
  with FTimer do
  begin
    Enabled := False;
    Interval := FInterval;
    OnTimer := @DoOnTimer;
  end;
  FActive := False;
  //Activate;
  Flist.add('ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZXW');
  Flist.add('0123456789:.,<> ');

  Skindata := nil;

  Getbmp;
end;

destructor TONURLabel.Destroy;
begin
  Deactivate;
  FBitmap.Free;
  tempbitmap.Free;
  FTimer.Free;
  Flist.Free;
  fclientp.Free;
  Customcroplist.Clear;
  inherited Destroy;
end;


procedure TONURLabel.Getbmp;
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
  if (Skindata = nil) then  exit;
  if tempbitmap.Empty then exit;



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


procedure TONURLabel.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURLabel.paint;
var
  TrgtRect, SrcRect: TRect;
   img: TBGRACustomBitmap;
begin

//  if csDesigning in ComponentState then
//     exit;
   if not Visible then exit;

  resim.SetSize(0,0);

  resim.Setsize((Length(self.Caption) * CharWidth),self.ClientHeight);
  tempbitmap.SetSize(0,0);

  tempbitmap.SetSize(fclientp.Croprect.Width, fclientp.Croprect.Height);
  FBitmap.SetSize(0,0);

//  if (Skindata <> nil) then
 if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    TrgtRect := Rect(0, 0, tempbitmap.Width, tempbitmap.Height);
    DrawPartnormalbmp(fclientp.Croprect, self, tempbitmap, TrgtRect, Alpha);
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

  self.Width := 100;
  self.Height := 30;

  skinname := 'cropbutton';

  FNormal := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FNormalleft   := TONURCUSTOMCROP.Create;
  FNormalleft.cropname:='NORMALLEFT';
  FNormalright  := TONURCUSTOMCROP.Create;
  FNormalright.cropname:='NORMALRIGHT';
  FNormaltop    := TONURCUSTOMCROP.Create;
  FNormaltop.cropname:='NORMALTOP';
  FNormalbottom := TONURCUSTOMCROP.Create;
  FNormalbottom.cropname:='NORMALBOTTOM';

  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  FPressleft    := TONURCUSTOMCROP.Create;
  FPressleft.cropname := 'PRESSEDLEFT';
  FPressright   := TONURCUSTOMCROP.Create;
  FPressright.cropname := 'PRESSEDRIGHT';
  FPresstop     := TONURCUSTOMCROP.Create;
  FPresstop.cropname := 'PRESSEDTOP';
  FPressbottom  := TONURCUSTOMCROP.Create;
  FPressbottom.cropname := 'PRESSEDBOTTOM';



  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'ENTER';
  FEnterleft    := TONURCUSTOMCROP.Create;
  FEnterleft.cropname := 'ENTERLEFT';
  FEnterright   := TONURCUSTOMCROP.Create;
  FEnterright.cropname := 'ENTERRIGHT';
  FEntertop     := TONURCUSTOMCROP.Create;
  FEntertop.cropname := 'ENTERTOP';
  FEnterbottom  := TONURCUSTOMCROP.Create;
  FEnterbottom.cropname := 'ENTERBOTTOM';



  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fdisableleft    := TONURCUSTOMCROP.Create;
  Fdisableleft.cropname := 'DISABLELEFT';
  Fdisableright   := TONURCUSTOMCROP.Create;
  Fdisableright.cropname := 'DISABLERIGHT';
  Fdisabletop     := TONURCUSTOMCROP.Create;
  Fdisabletop.cropname := 'DISABLETOP';
  Fdisablebottom  := TONURCUSTOMCROP.Create;
  Fdisablebottom.cropname := 'DISABLEBOTTOM';
  Fstate := obsNormal;
  FAutoWidth := True;
  resim.SetSize(self.Width, self.Height);
  crop := True;

  Customcroplist.Add(Fnormal);
  Customcroplist.Add(FNormalleft);
  Customcroplist.Add(FNormaltop);
  Customcroplist.Add(FNormalright);
  Customcroplist.Add(FNormalbottom);

  Customcroplist.Add(FEnter);
  Customcroplist.Add(FEnterleft);
  Customcroplist.Add(FEntertop);
  Customcroplist.Add(FEnterright);
  Customcroplist.Add(FEnterbottom);

  Customcroplist.Add(FPress);
  Customcroplist.Add(FPressleft);
  Customcroplist.Add(FPresstop);
  Customcroplist.Add(FPressright);
  Customcroplist.Add(FPressbottom);

  Customcroplist.Add(Fdisable);
  Customcroplist.Add(Fdisableleft);
  Customcroplist.Add(Fdisabletop);
  Customcroplist.Add(Fdisableright);
  Customcroplist.Add(Fdisablebottom);
end;

// -----------------------------------------------------------------------------

destructor TONURCropButton.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

 { FreeAndNil(FNormal);
  FreeAndNil(FNormalleft);
  FreeAndNil(FNormalright);
  FreeAndNil(FNormaltop);
  FreeAndNil(FNormalbottom);

  FreeAndNil(FPress);
  FreeAndNil(FPressleft);
  FreeAndNil(FPressright);
  FreeAndNil(FPresstop);
  FreeAndNil(FPressbottom);

  FreeAndNil(FEnter);
  FreeAndNil(FEnterleft);
  FreeAndNil(FEnterright);
  FreeAndNil(FEntertop);
  FreeAndNil(FEnterbottom);

  FreeAndNil(Fdisable);
  FreeAndNil(Fdisableleft);
  FreeAndNil(Fdisableright);
  FreeAndNil(Fdisabletop);
  FreeAndNil(Fdisablebottom);  }

  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONURCropButton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(resim) then
  begin
    Width := resim.Width;
    Height := resim.Height;
  end;

end;

procedure TONURCropButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONURCropButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  FNormalleft.Targetrect:=RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect:=RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);

  FNormaltop.Targetrect:=RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);

  FNormalbottom.Targetrect:=RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect:=RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight-FNormalbottom.Height);

end;

procedure TONURCropButton.Paint;
var
  DR,DRL,DRR,DRT,DRB: TRect;
begin
//  if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.Width, Self.Height);
//  if (Skindata <> nil) then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR  := FNormal.Croprect;
            DRL := FNormalleft.Croprect;
            DRR := FNormalright.Croprect;
            DRT := FNormaltop.Croprect;
            DRB := FNormalbottom.Croprect;
            Self.Font.Color := FNormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := FPress.Croprect;
            DRL := FPressleft.Croprect;
            DRR := FPressright.Croprect;
            DRT := FPresstop.Croprect;
            DRB := FPressbottom.Croprect;
            Self.Font.Color := FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := FEnter.Croprect;
            DRL := FEnterleft.Croprect;
            DRR := FEnterright.Croprect;
            DRT := FEntertop.Croprect;
            DRB := FEnterbottom.Croprect;
            Self.Font.Color := FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := Fdisable.Croprect;
        DRL := FDisableleft.Croprect;
        DRR := FDisableright.Croprect;
        DRT := FDisabletop.Croprect;
        DRB := FDisablebottom.Croprect;
        Self.Font.Color := Fdisable.Fontcolor;
      end;
      DrawPartnormal(DRL, self,FNormalleft.Targetrect,alpha);
      DrawPartnormal(DRR, self,FNormalright.Targetrect,alpha);
      DrawPartnormal(DRT, self,FNormaltop.Targetrect,alpha);
      DrawPartnormal(DRB, self,FNormalbottom.Targetrect,alpha);
      DrawPartnormal(DR, self, Fnormal.Targetrect,alpha); //Width, ClientHeight, falpha);

      if Crop = True then
        CropToimg(resim);
    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;
end;



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
procedure TONURCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;

end;



procedure TONURCropButton.MouseEnter;
begin

  if (csDesigning in ComponentState) then    exit;
  if (Enabled=false) or (Fstate = obshover) then  Exit;
  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;

end;


procedure TONURCropButton.CMHittest(var msg: TCMHittest);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if PtInRegion(WindowRgn, msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

// -----------------------------------------------------------------------------




{ TONURGraphicsButton }


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


procedure TONURGraphicsButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURGraphicsButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then
  exit;
  if (Enabled = false) or (Fstate = obsnormal) then
  Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------
procedure TONURGraphicsButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

constructor TONURGraphicsButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'button';
  FNormal   := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FNormalleft   := TONURCUSTOMCROP.Create;
  FNormalleft.cropname:='NORMALLEFT';
  FNormalright  := TONURCUSTOMCROP.Create;
  FNormalright.cropname:='NORMALRIGHT';
  FNormaltop    := TONURCUSTOMCROP.Create;
  FNormaltop.cropname:='NORMALTOP';
  FNormalbottom := TONURCUSTOMCROP.Create;
  FNormalbottom.cropname:='NORMALBOTTOM';

  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  FPressleft    := TONURCUSTOMCROP.Create;
  FPressleft.cropname := 'PRESSEDLEFT';
  FPressright   := TONURCUSTOMCROP.Create;
  FPressright.cropname := 'PRESSEDRIGHT';
  FPresstop     := TONURCUSTOMCROP.Create;
  FPresstop.cropname := 'PRESSEDTOP';
  FPressbottom  := TONURCUSTOMCROP.Create;
  FPressbottom.cropname := 'PRESSEDBOTTOM';



  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'ENTER';
  FEnterleft    := TONURCUSTOMCROP.Create;
  FEnterleft.cropname := 'ENTERLEFT';
  FEnterright   := TONURCUSTOMCROP.Create;
  FEnterright.cropname := 'ENTERRIGHT';
  FEntertop     := TONURCUSTOMCROP.Create;
  FEntertop.cropname := 'ENTERTOP';
  FEnterbottom  := TONURCUSTOMCROP.Create;
  FEnterbottom.cropname := 'ENTERBOTTOM';



  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fdisableleft    := TONURCUSTOMCROP.Create;
  Fdisableleft.cropname := 'DISABLELEFT';
  Fdisableright   := TONURCUSTOMCROP.Create;
  Fdisableright.cropname := 'DISABLERIGHT';
  Fdisabletop     := TONURCUSTOMCROP.Create;
  Fdisabletop.cropname := 'DISABLETOP';
  Fdisablebottom  := TONURCUSTOMCROP.Create;
  Fdisablebottom.cropname := 'DISABLEBOTTOM';

  Customcroplist.Add(Fnormal);
  Customcroplist.Add(FNormalleft);
  Customcroplist.Add(FNormaltop);
  Customcroplist.Add(FNormalright);
  Customcroplist.Add(FNormalbottom);

  Customcroplist.Add(FEnter);
  Customcroplist.Add(FEnterleft);
  Customcroplist.Add(FEntertop);
  Customcroplist.Add(FEnterright);
  Customcroplist.Add(FEnterbottom);

  Customcroplist.Add(FPress);
  Customcroplist.Add(FPressleft);
  Customcroplist.Add(FPresstop);
  Customcroplist.Add(FPressright);
  Customcroplist.Add(FPressbottom);

  Customcroplist.Add(Fdisable);
  Customcroplist.Add(Fdisableleft);
  Customcroplist.Add(Fdisabletop);
  Customcroplist.Add(Fdisableright);
  Customcroplist.Add(Fdisablebottom);

  Fstate := obsNormal;
  Width := 100;
  Height := 30;
  Transparent := True;

  //  ControlStyle := ControlStyle + [csClickEvents, csDoubleClicks, csCaptureMouse];
  FAutoWidth := True;
  resim.SetSize(ClientWidth, ClientHeight);
end;

// -----------------------------------------------------------------------------

destructor TONURGraphicsButton.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{  FreeAndNil(FNormal);
  FreeAndNil(FNormalleft);
  FreeAndNil(FNormalright);
  FreeAndNil(FNormaltop);
  FreeAndNil(FNormalbottom);

  FreeAndNil(FPress);
  FreeAndNil(FPressleft);
  FreeAndNil(FPressright);
  FreeAndNil(FPresstop);
  FreeAndNil(FPressbottom);

  FreeAndNil(FEnter);
  FreeAndNil(FEnterleft);
  FreeAndNil(FEnterright);
  FreeAndNil(FEntertop);
  FreeAndNil(FEnterbottom);

  FreeAndNil(Fdisable);
  FreeAndNil(Fdisableleft);
  FreeAndNil(Fdisableright);
  FreeAndNil(Fdisabletop);
  FreeAndNil(Fdisablebottom); }
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONURGraphicsButton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(resim) then
  begin
    Width := resim.Width;
    Height := resim.Height;
  end;

end;

procedure TONURGraphicsButton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  FNormalleft.Targetrect:=RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect:=RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);
  FNormaltop.Targetrect:=RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);
  FNormalbottom.Targetrect:=RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect:=RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,self.ClientHeight-FNormalbottom.Height);

end;

procedure TONURGraphicsButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONURGraphicsButton.Paint;
var
  DR,DRL,DRR,DRT,DRB: TRect;
begin
//  if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;

  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  //if (Skindata <> nil) then
 if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR  := FNormal.Croprect;
            DRL := FNormalleft.Croprect;
            DRR := FNormalright.Croprect;
            DRT := FNormaltop.Croprect;
            DRB := FNormalbottom.Croprect;
            Self.Font.Color := FNormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := FPress.Croprect;
            DRL := FPressleft.Croprect;
            DRR := FPressright.Croprect;
            DRT := FPresstop.Croprect;
            DRB := FPressbottom.Croprect;
            Self.Font.Color := FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := FEnter.Croprect;
            DRL := FEnterleft.Croprect;
            DRR := FEnterright.Croprect;
            DRT := FEntertop.Croprect;
            DRB := FEnterbottom.Croprect;
            Self.Font.Color := FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := Fdisable.Croprect;
        DRL := FDisableleft.Croprect;
        DRR := FDisableright.Croprect;
        DRT := FDisabletop.Croprect;
        DRB := FDisablebottom.Croprect;
        Self.Font.Color := Fdisable.Fontcolor;
      end;
      DrawPartnormal(DRL, self,FNormalleft.Targetrect,alpha);
      DrawPartnormal(DRR, self,FNormalright.Targetrect,alpha);
      DrawPartnormal(DRT, self,FNormaltop.Targetrect,alpha);
      DrawPartnormal(DRB, self,FNormalbottom.Targetrect,alpha);
      DrawPartnormal(DR, self, Fnormal.Targetrect,alpha); //Width, ClientHeight, falpha);

    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
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
  skinname := 'swich';
  FOpen := TONURCUSTOMCROP.Create;
  FOpen.cropname := 'OPEN';
  Fclose := TONURCUSTOMCROP.Create;
  Fclose.cropname := 'CLOSE';
  Fopenhover := TONURCUSTOMCROP.Create;
  Fopenhover.cropname := 'OPENHOVER';
  Fclosehover := TONURCUSTOMCROP.Create;
  Fclosehover.cropname := 'CLOSEHOVER';
  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;

  Customcroplist.Add(FOpen);
  Customcroplist.Add(Fopenhover);
  Customcroplist.Add(Fclose);
  Customcroplist.Add(Fclosehover);
  Customcroplist.Add(Fdisable);

  //  FOnChange:=TNotifyEvent;
end;

destructor TONURSwich.Destroy;
  var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{  FreeAndNil(FOpen);
  FreeAndNil(Fclose);
  FreeAndNil(Fopenhover);
  FreeAndNil(Fclosehover);
  FreeAndNil(Fdisable);}
  inherited Destroy;
end;


procedure TONURSwich.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);

end;

procedure TONURSwich.Paint;
var
  //  HEDEF,
  DR: TRect;
begin
//  if csDesigning in ComponentState then
//    Exit;
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
 // if (Skindata <> nil) then
    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
      if Enabled = True then
      begin
        if Checked = True then
        begin
          case Fstate of
            obsNormal:
            begin
              DR := FOpen.Croprect;//Rect(FOpen.FSLeft, FOpen.FSTop, FOpen.FSRight, FOpen.FSBottom);
              Self.Font.Color := FOpen.Fontcolor;
            end;
            obshover:
            begin
              DR := Fopenhover.Croprect;//Rect(Fopenhover.FSLeft, Fopenhover.FSTop, Fopenhover.FSRight, Fopenhover.FSBottom);
              Self.Font.Color := Fopenhover.Fontcolor;
            end;
          {  obspressed:
            begin
              DR := Rect(FDown.FSLeft, FEnter.FSTop,
                FEnter.FSRight, FEnter.FSBottom);
              Self.Font.Color:=FEnter.Fontcolor;
            end;       }
          end;
        end
        else
        begin
          case Fstate of
            obsNormal:
            begin
              DR := Fclose.Croprect;//Rect(Fclose.FSLeft, Fclose.FSTop, Fclose.FSRight, Fclose.FSBottom);
              Self.Font.Color := Fclose.Fontcolor;
            end;
            obshover:
            begin
              DR := Fclosehover.Croprect;//Rect(Fclosehover.FSLeft, Fclosehover.FSTop, Fclosehover.FSRight, Fclosehover.FSBottom);
              Self.Font.Color := Fclosehover.Fontcolor;
            end;
          {  obspressed:
            begin
              DR := Rect(FDown.FSLeft, FEnter.FSTop,
                FEnter.FSRight, FEnter.FSBottom);
              Self.Font.Color:=FEnter.Fontcolor;
            end;       }
          end;
        end;
      end
      else
      begin
        DR := Fdisable.Croprect;//Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
        Self.Font.Color := Fdisable.Fontcolor;
      end;

      DrawPartstrech(DR, self, self.ClientWidth, self.ClientHeight, alpha);

    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;
end;




{ TONURCheckbox }



procedure TONURCheckbox.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;

 //   if (self is TONURRadioButton) then
 //     deaktifdigerleri;

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

procedure TONURCheckbox.deaktifdigerleri;
var
  i: integer;
  Sibling: TControl;
begin

  if self.Parent <> nil then
    with self.Parent do
    begin
      for i := 0 to ControlCount - 1 do
      begin
        Sibling := Controls[i];
        if (Controls[i] is TONURRadioButton) and (Sibling <> Self)  then
        begin
          TONURRadioButton(Sibling).SetChecked(False);// Checked := False;
          TONURRadioButton(Sibling).fstate := obsnormal;// Checked := False;
      //    ShowMessage(self.Parent.Name);
         // Invalidate;
        end;
      end;

    end;
  fChecked:=true;
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
  inherited;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

constructor TONURCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname := 'checkbox';
  fcheckwidth := 12;
  fcaptiondirection := ocright;
  obenter := TONURCUSTOMCROP.Create;
  obenter.cropname := 'NORMALHOVER';
  obleave := TONURCUSTOMCROP.Create;
  obleave.cropname := 'NORMAL';
  obdown := TONURCUSTOMCROP.Create;
  obdown.cropname := 'PRESSED';
  obcheckleaves := TONURCUSTOMCROP.Create;
  obcheckleaves.cropname := 'CHECK';
  obcheckenters := TONURCUSTOMCROP.Create;
  obcheckenters.cropname := 'CHECKHOVER';
  obdisabled := TONURCUSTOMCROP.Create;
  obdisabled.cropname := 'DISABLE';


  Customcroplist.Add(obleave);
  Customcroplist.Add(obenter);
  Customcroplist.Add(obdown);
  Customcroplist.Add(obcheckleaves);
  Customcroplist.Add(obcheckenters);
  Customcroplist.Add(obdisabled);

  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;
  textx:=10;
  Texty:=10;
end;

destructor TONURCheckbox.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);
  FreeAndNil(obdisabled);

  }
  inherited Destroy;
end;

procedure TONURCheckbox.SetSkindata(Aimg: TONURImg);
var
   fbuttoncenter: integer;

begin
  inherited SetSkindata(Aimg);
end;

procedure TONURCheckbox.Paint;
var
  DR: TRect; 
   fbuttoncenter: integer;
begin
//  if csDesigning in ComponentState then
//     Exit;
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
//  if (Skindata <> nil) then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Enabled = True then
    begin
      if Checked = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR :=obcheckleaves.Croprect;// Rect(obcheckleaves.FSLeft, obcheckleaves.FSTop,obcheckleaves.FSRight, obcheckleaves.FSBottom);
            Self.Font.Color := obcheckleaves.Fontcolor;
          end;
          obshover:
          begin
            DR :=obcheckenters.Croprect;// Rect(obcheckenters.FSLeft, obcheckenters.FSTop, obcheckenters.FSRight, obcheckenters.FSBottom);
            Self.Font.Color := obcheckenters.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;//Rect(obdown.FSLeft, obdown.FSTop, obdown.FSRight, obdown.FSBottom);
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end
      else
      begin
        case Fstate of
          obsNormal:
          begin
            DR := obleave.Croprect;// Rect(obleave.FSLeft, obleave.FSTop, obleave.FSRight, obleave.FSBottom);
            Self.Font.Color := obleave.Fontcolor;
          end;
          obshover:
          begin
            DR := obenter.Croprect;//Rect(obenter.FSLeft, obenter.FSTop,obenter.FSRight, obenter.FSBottom);
            Self.Font.Color := obenter.Fontcolor;
          end;
          obspressed:
          begin
            DR := obdown.Croprect;//Rect(obdown.FSLeft, obdown.FSTop, obdown.FSRight, obdown.FSBottom);
            Self.Font.Color := obdown.Fontcolor;
          end;
        end;
      end;
    end
    else
    begin
      DR := obdisabled.Croprect;//Rect(obdisabled.FSLeft, obdisabled.FSTop, obdisabled.FSRight, obdisabled.FSBottom);
      Self.Font.Color := obdisabled.Fontcolor;
    end;



    //  DrawPartstrech(DR, self, fcheckwidth,fcheckwidth);//Width, Height);
   // DrawPartnormal(DR, Self, Fclientrect, alpha);

  end
  else
  begin
   resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;


  case fCaptionDirection of
      ocup:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := obleave.Croprect.Top;//fborderWidth;
        fbuttoncenter := ((self.clientHeight div 2) div 2) + (fcheckwidth div 2);
        Fclientrect := Rect((self.ClientWidth div 2) - (fcheckwidth div 2),
          fbuttoncenter, (self.ClientWidth div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
      end;
      ocdown:
      begin
        textx := (self.ClientWidth div 2) - (self.canvas.TextWidth(Caption) div 2);
        Texty := ((self.clientHeight div 2)) + obleave.Croprect.Top;// + fborderWidth;
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

  inherited paint;

  if Length(Caption) > 0 then
  begin
    canvas.Brush.Style := bsClear;
    canvas.TextOut(Textx, Texty, (Caption));
  end;
end;


end.

unit onurbutton;

{$mode objfpc}{$H+}

interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Dialogs, types, LazUTF8, Contnrs,onurctrl;

type

  { TONCropButton }

  TONCropButton = class(TONCustomControl)
  private
    FNormalleft,FNormalright,
    FNormaltop,FNormalbottom,
    Fnormal : TONCUSTOMCROP;

    FPressleft,FPressright,
    FPresstop,FPressbottom,
    FPress  : TONCUSTOMCROP;

    FEnterleft,FEnterright,
    FEntertop,FEnterbottom,
    FEnter  : TONCUSTOMCROP;

    Fdisableleft,Fdisableright,
    Fdisabletop,Fdisablebottom,
    Fdisable  : TONCUSTOMCROP;

    Fstate           : TONButtonState;
    FAutoWidth       : boolean;
    procedure SetSkindata(Aimg: TONImg); override;
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

    property ONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONNORMALLEFT: TONCUSTOMCROP read FNormalleft write FNormalleft;
    property ONNORMALRIGHT: TONCUSTOMCROP read FNormalright write FNormalright;
    property ONNORMALTOP: TONCUSTOMCROP read FNormaltop write FNormaltop;
    property ONNORMALBOTTOM: TONCUSTOMCROP read FNormalbottom write FNormalbottom;


    property ONPRESSED: TONCUSTOMCROP read FPress write FPress;
    property ONPRESSEDLEFT: TONCUSTOMCROP read FPressleft write FPressleft;
    property ONPRESSEDRIGHT: TONCUSTOMCROP read FPressright write FPressright;
    property ONPRESSEDTOP: TONCUSTOMCROP read FPresstop write FPresstop;
    property ONPRESSEDBOTTOM: TONCUSTOMCROP read FPressbottom write FPressbottom;

    property ONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONHOVERLEFT: TONCUSTOMCROP read FEnterleft write FEnterleft;
    property ONHOVERRIGHT: TONCUSTOMCROP read FEnterright write FEnterright;
    property ONHOVERTOP: TONCUSTOMCROP read FEntertop write FEntertop;
    property ONHOVERBOTTOM: TONCUSTOMCROP read FEnterbottom write FEnterbottom;

    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
    property ONDISABLELEFT: TONCUSTOMCROP read Fdisableleft write Fdisableleft;
    property ONDISABLERIGHT: TONCUSTOMCROP read Fdisableright write Fdisableright;
    property ONDISABLETOP: TONCUSTOMCROP read Fdisabletop write Fdisabletop;
    property ONDISABLEBOTTOM: TONCUSTOMCROP read Fdisablebottom write Fdisablebottom;

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


  { TONGraphicsButton }

  TONGraphicsButton = class(TONGraphicControl)
  private
    FNormalleft,FNormalright,
    FNormaltop,FNormalbottom,
    Fnormal : TONCUSTOMCROP;

    FPressleft,FPressright,
    FPresstop,FPressbottom,
    FPress  : TONCUSTOMCROP;

    FEnterleft,FEnterright,
    FEntertop,FEnterbottom,
    FEnter  : TONCUSTOMCROP;

    Fdisableleft,Fdisableright,
    Fdisabletop,Fdisablebottom,
    Fdisable  : TONCUSTOMCROP;

    Fstate: TONButtonState;
    FAutoWidth: boolean;
    procedure SetSkindata(Aimg: TONImg); override;
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

    property ONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONNORMALLEFT: TONCUSTOMCROP read FNormalleft write FNormalleft;
    property ONNORMALRIGHT: TONCUSTOMCROP read FNormalright write FNormalright;
    property ONNORMALTOP: TONCUSTOMCROP read FNormaltop write FNormaltop;
    property ONNORMALBOTTOM: TONCUSTOMCROP read FNormalbottom write FNormalbottom;


    property ONPRESSED: TONCUSTOMCROP read FPress write FPress;
    property ONPRESSEDLEFT: TONCUSTOMCROP read FPressleft write FPressleft;
    property ONPRESSEDRIGHT: TONCUSTOMCROP read FPressright write FPressright;
    property ONPRESSEDTOP: TONCUSTOMCROP read FPresstop write FPresstop;
    property ONPRESSEDBOTTOM: TONCUSTOMCROP read FPressbottom write FPressbottom;

    property ONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONHOVERLEFT: TONCUSTOMCROP read FEnterleft write FEnterleft;
    property ONHOVERRIGHT: TONCUSTOMCROP read FEnterright write FEnterright;
    property ONHOVERTOP: TONCUSTOMCROP read FEntertop write FEntertop;
    property ONHOVERBOTTOM: TONCUSTOMCROP read FEnterbottom write FEnterbottom;

    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
    property ONDISABLELEFT: TONCUSTOMCROP read Fdisableleft write Fdisableleft;
    property ONDISABLERIGHT: TONCUSTOMCROP read Fdisableright write Fdisableright;
    property ONDISABLETOP: TONCUSTOMCROP read Fdisabletop write Fdisabletop;
    property ONDISABLEBOTTOM: TONCUSTOMCROP read Fdisablebottom write Fdisablebottom;
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



  { TOnSwich }

  TOnSwich = class(TONGraphicControl)
  private
    FOpen, Fclose, Fopenhover, Fclosehover, Fdisable: TONCUSTOMCROP;
    Fstate: TONButtonState;
    FChecked: boolean;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    procedure SetSkindata(Aimg: TONImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    property ONOPEN: TONCUSTOMCROP read FOpen write FOpen;
    property ONCLOSE: TONCUSTOMCROP read Fclose write Fclose;
    property ONOPENHOVER: TONCUSTOMCROP read Fopenhover write Fopenhover;
    property ONCLOSEHOVER: TONCUSTOMCROP read Fclosehover write Fclosehover;
    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;

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



  { TOnCheckbox }

  TOnCheckbox = class(TONGraphicControl)
  private
    obenter, obleave, obdown, obdisabled, obcheckenters, obcheckleaves: TONCUSTOMCROP;
    Fstate: TONButtonState;
    fcheckwidth: integer;
    fcaptiondirection: Tcapdirection;
    FChecked: boolean;
    textx, Texty: integer;
    Fclientrect:Trect;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: Tcapdirection);
    function GetCaptionmod: Tcapdirection;
    procedure deaktifdigerleri;  /// for radiobutton
    procedure SetSkindata(Aimg: TONImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
    procedure CMHittest(var msg: TCMHIttest);

    property ONNORMAL: TONCUSTOMCROP read obleave write obleave;
    property ONNORMALHOVER: TONCUSTOMCROP read obenter write obenter;
    property ONNORMALDOWN: TONCUSTOMCROP read obdown write obdown;
    property ONCHECKED: TONCUSTOMCROP read obcheckleaves write obcheckleaves;
    property ONCHECKEDHOVER: TONCUSTOMCROP read obcheckenters write obcheckenters;
    property ONDISABLE: TONCUSTOMCROP read obdisabled write obdisabled;
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
    property CaptionDirection: Tcapdirection read GetCaptionmod write SetCaptionmod;
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

  { TOnRadioButton }

  TOnRadioButton = class(TONGraphicControl)
  private
    obenter, obleave,
    obdown, obdisabled,
    obcheckenters,
    obcheckleaves     : TONCUSTOMCROP;
    Fstate            : TONButtonState;
    fcheckwidth       : integer;
    fcaptiondirection : Tcapdirection;
    FChecked          : boolean;
    textx, Texty      : integer;
    Fclientrect       : Trect;
    FOnChange         : TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: Tcapdirection);
    function GetCaptionmod: Tcapdirection;
    procedure deaktifdigerleri;  /// for radiobutton
    procedure SetSkindata(Aimg: TONImg); override;
  public
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
    procedure CMHittest(var msg: TCMHIttest);

    property ONNORMAL: TONCUSTOMCROP read obleave write obleave;
    property ONNORMALHOVER: TONCUSTOMCROP read obenter write obenter;
    property ONNORMALDOWN: TONCUSTOMCROP read obdown write obdown;
    property ONCHECKED: TONCUSTOMCROP read obcheckleaves write obcheckleaves;
    property ONCHECKEDHOVER: TONCUSTOMCROP read obcheckenters write obcheckenters;
    property ONDISABLE: TONCUSTOMCROP read obdisabled write obdisabled;
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
    property CaptionDirection: Tcapdirection read GetCaptionmod write SetCaptionmod;
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

  { TONlabel }

  TONlabel = class(TonGraphicControl)
  private
    { Private declarations }
    fclientp: TONCUSTOMCROP;
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
    Procedure SetSkindata(Aimg: TONImg); override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;


    property ONCLIENT: TONCUSTOMCROP  read fclientp write fclientp;

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

  TONNormalLabel = class(TGraphicControl)
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


 { TONLed }

 TONLed = class(TONGraphicControl)
 private
    fcheck,fmouseon:boolean;
    FOnChange: TNotifyEvent;
    Fonclientp, Foffclientp, Fonclientph, Foffclientph,Fdisabled: TONCUSTOMCROP;
    procedure Setledonoff(val:boolean);
    procedure SetSkindata(Aimg: TONImg); override;
 public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
 protected
    procedure MouseEnter; override;
    procedure MouseLeave; override;
 public
    property ONLEDONNORMAL  : TONCUSTOMCROP read Fonclientp   write Fonclientp;
    property ONLEDONHOVER   : TONCUSTOMCROP read Fonclientph  write Fonclientph;
    property ONLEDOFFNORMAL : TONCUSTOMCROP read Foffclientp  write Foffclientp;
    property ONLEDOFFHOVER  : TONCUSTOMCROP read Foffclientph write Foffclientph;
    property ONDISABLED     : TONCUSTOMCROP read Fdisabled    write Fdisabled;
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
  RegisterComponents('ONUR', [TONCropButton]);
  RegisterComponents('ONUR', [TONGraphicsButton]);
  RegisterComponents('ONUR', [TOnSwich]);
  RegisterComponents('ONUR', [TOnCheckbox]);
  RegisterComponents('ONUR', [TOnRadioButton]);
  RegisterComponents('ONUR', [TONlabel]);
  RegisterComponents('ONUR', [TONNormalLabel]);
  RegisterComponents('ONUR', [TONLed]);
end;

{ TOnRadioButton }

procedure TOnRadioButton.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    deaktifdigerleri;
    doonchange;
    Invalidate;
  end;
end;

function TOnRadioButton.GetCheckWidth: integer;
begin
 Result := fcheckwidth;
end;

procedure TOnRadioButton.SetCheckWidth(AValue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;

procedure TOnRadioButton.SetCaptionmod(const val: Tcapdirection);
begin
   if fcaptiondirection = val then
    exit;
  fcaptiondirection := val;
  //  paint;
  Invalidate;
end;

function TOnRadioButton.GetCaptionmod: Tcapdirection;
begin
  Result := fcaptiondirection;
end;

procedure TOnRadioButton.deaktifdigerleri;
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
      if (Controls[i] is TOnRadioButton) and (Sibling <> Self) then
      begin
        TOnRadioButton(Sibling).fchecked:=false;
        TOnRadioButton(Sibling).fstate := obsnormal;
        Invalidate;
      end;
    end;
  end;
end;

procedure TOnRadioButton.SetSkindata(Aimg: TONImg);
var
 fbuttoncenter: integer;
begin
  inherited SetSkindata(Aimg);
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
end;

procedure TOnRadioButton.CMonmouseenter(var Messages: Tmessage);
begin
  fstate := obshover;
  Invalidate;
end;

procedure TOnRadioButton.CMonmouseleave(var Messages: Tmessage);
begin
 fstate := obsnormal;
  Invalidate;
end;

procedure TOnRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TOnRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  fstate := obshover;
  Invalidate;
end;

procedure TOnRadioButton.DoOnChange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TOnRadioButton.CMHittest(var msg: TCMHIttest);
begin
  inherited;
   if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

constructor TOnRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'radiobox';
  fcheckwidth := 12;
  fcaptiondirection := ocright;
  obenter := TONCUSTOMCROP.Create;
  obenter.cropname := 'NORMALHOVER';
  obleave := TONCUSTOMCROP.Create;
  obleave.cropname := 'NORMAL';
  obdown := TONCUSTOMCROP.Create;
  obdown.cropname := 'PRESSED';
  obcheckleaves := TONCUSTOMCROP.Create;
  obcheckleaves.cropname := 'CHECK';
  obcheckenters := TONCUSTOMCROP.Create;
  obcheckenters.cropname := 'CHECKHOVER';
  obdisabled := TONCUSTOMCROP.Create;
  obdisabled.cropname := 'DISABLE';
  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;
  textx:=10;
  Texty:=10;
end;

destructor TOnRadioButton.Destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);
  FreeAndNil(obdisabled);
  inherited Destroy;
end;

procedure TOnRadioButton.Paint;
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


{ TONNormalLabel }

function TONNormalLabel.GetTextDefaultPos: smallint;
begin
  if (FBuffer.Width<self.ClientWidth) then
  Result := (self.ClientWidth - FBuffer.Width) div 2
  else
  Result :=0;

end;

procedure TONNormalLabel.SetBilink(AValue: boolean);
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

procedure TONNormalLabel.Setblinkinterval(AValue: integer);
begin
  if fblinkinterval=AValue then Exit;
  fblinkinterval:=AValue;
  fblinktimer.Interval:=AValue;

end;


procedure TONNormalLabel.SetAnimate(AValue: boolean);
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

procedure TONNormalLabel.Setclr(AValue: TBGRAPixel);
begin
  if clr = AValue then Exit;
  clr := AValue;
end;

procedure TONNormalLabel.SetScrollBy(AValue: integer);
begin
  if FScrollBy = AValue then exit;
  FScrollBy := AValue;
end;



function TONNormalLabel.GetScroll: integer;
begin
  Result := ABS(FScrollBy);
end;

procedure TONNormalLabel.SetText(AValue: string);
begin
  FText := AValue;
  DrawFontText;
  FPos := GetTextDefaultPos;
  FDirection := tdLeftToRight;
  FWait := Fwaiting;// Waiting;
  Invalidate;
end;

procedure TONNormalLabel.Settimerinterval(AValue: integer);
begin
  if ftimerinterval=AValue then Exit;
  ftimerinterval:=AValue;
  if (fAnimate) and Assigned(ftimer) then
    FTimer.Interval := ftimerinterval;//100;
end;

procedure TONNormalLabel.Setwaiting(AValue: byte);
begin
  if Fwaiting=AValue then Exit;
  Fwaiting:=AValue;
end;

procedure TONNormalLabel.SetYazibuyuk(AValue: boolean);
begin
  if fyazibuyuk=AValue then Exit;
  fyazibuyuk:=AValue;
end;

procedure TONNormalLabel.TimerEvent(Sender: TObject);
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

procedure TONNormalLabel.DrawFontText;
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

procedure TONNormalLabel.DrawFontTextcolor(incolor,outcolor:TBGRAPixel);
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


procedure TONNormalLabel.FreeTimer;
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
    FTimer := nil;
  end;
end;

procedure TONNormalLabel.Blinktimerevent(sender: TObject);
begin
  fbilink:= not fbilinki;
  fbilinki:= not fbilinki;
  if FAnimate=false then
  Invalidate;
end;

procedure TONNormalLabel.Loaded;
begin
  inherited Loaded;
    DrawFontText;
end;

procedure TONNormalLabel.Paint;
begin
  if fbilink then
  begin
    canvas.Brush.Color := clr;
    canvas.FillRect(ClientRect);
  end;

  FBuffer.Draw(self.Canvas, fpos, 0, False);
end;



constructor TONNormalLabel.Create(AOwner: TComponent);
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

destructor TONNormalLabel.Destroy;
begin
  FreeTimer;
  if fblinktimer.Enabled then fblinktimer.Enabled:=false;

  FreeAndNil(fblinktimer);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;






{ TONLed }

procedure TONLed.Setledonoff(val: boolean);
Begin
  if val <> fcheck then
  begin
   fcheck:=val;
   if Assigned(FOnChange) then FOnChange(Self);
   Invalidate;
  End;
End;



constructor TONLed.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  Self.Height           := 30;
  Self.Width            := 30;
  Fonclientp            := TONCUSTOMCROP.Create;
  Fonclientp.cropname   := 'LEDONNORMAL';
  Fonclientph           := TONCUSTOMCROP.Create;
  Fonclientph.cropname  := 'LEDONHOVER';
  Foffclientp           := TONCUSTOMCROP.Create;
  Foffclientp.cropname  := 'LEDOFFNORMAL';
  Foffclientph          := TONCUSTOMCROP.Create;
  Foffclientph.cropname := 'LEDOFFHOVER';
  Fdisabled             := TONCUSTOMCROP.Create;
  Fdisabled.cropname    := 'LEDDISABLE';
  skinname              := 'led';
  Skindata              := nil;
  fcheck                := true;
  Captionvisible        := False;
  resim.SetSize(self.clientWidth, self.clientHeight);
end;

// -----------------------------------------------------------------------------
destructor TONLed.Destroy;
begin
  FreeAndNil(Fonclientp);
  FreeAndNil(Fonclientph);
  FreeAndNil(Foffclientp);
  FreeAndNil(Foffclientph);
  FreeAndNil(Fdisabled);
  inherited Destroy;
End;


procedure TONLed.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONLed.Paint;
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

procedure TONLed.MouseEnter;
Begin
  Inherited Mouseenter;
  fmouseon:=true;
  Invalidate;
End;

procedure TONLed.MouseLeave;
Begin
  Inherited Mouseleave;
  fmouseon:=false;
  Invalidate;
End;

{ TONlabel }


function TONlabel.GetScrollBy: integer;
begin
  Result := ABS(FScrollBy);
end;

procedure TONlabel.SetActive(Value: boolean);
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

procedure TONlabel.Setcaption(Avalue: Tcaption);
begin
  if fcaption = Avalue then Exit;
  fcaption := Avalue;
  Getbmp;
  Invalidate;
end;

procedure TONlabel.SetStretch(Value: boolean);
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

procedure TONlabel.SetInterval(Value: cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    FTimer.Interval := Value;
  end;
end;



procedure TONlabel.Activate;
begin
  FActive := True;
  FTimer.Enabled := True;
  FTimer.Interval := FInterval;
  FWaiting := False;

  FCurPos := 0;
  FScrollBy := ABS(FScrollBy);
  Invalidate;
end;

procedure TONlabel.Deactivate;
begin
  FTimer.Enabled := False;
  FActive := False;
  Invalidate;
end;

procedure TONlabel.UpdatePos;
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

procedure TONlabel.DoOnTimer(Sender: TObject);
begin
  if FWaiting then
  begin
    FTimer.Interval := FInterval;
    FWaiting := False;
  end;

  UpDatePos;
  Invalidate;
end;

procedure TONlabel.SetCharWidth(Value: integer);
begin
  if Value = CharWidth then exit;
  fCharWidth := Value;
  Getbmp;
  Invalidate;
end;

procedure TONlabel.SetCharHeight(Value: integer);
begin
  if Value = CharHeight then exit;
  fCharHeight := Value;
  Getbmp;
  Invalidate;
end;



procedure TONlabel.SetString(AValue: TStrings);
begin
  if Flist = AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
  Getbmp;
end;

procedure TONlabel.listchange(Sender: TObject);
begin
  Getbmp;
end;



constructor TONlabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'label';
  fclientp := TONCustomCrop.Create;
  fclientp.cropname := 'ONCLIENT';

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

destructor TONlabel.Destroy;
begin
  Deactivate;
  FBitmap.Free;
  tempbitmap.Free;
  FTimer.Free;

  Flist.Free;
  inherited Destroy;
end;


procedure TONlabel.Getbmp;
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


procedure TONlabel.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONlabel.paint;
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





{ TONCropButton }

// -----------------------------------------------------------------------------
constructor TONCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  self.Width := 100;
  self.Height := 30;

  skinname := 'cropbutton';

  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FNormalleft   := TONCustomCrop.Create;
  FNormalleft.cropname:='NORMALLEFT';
  FNormalright  := TONCustomCrop.Create;
  FNormalright.cropname:='NORMALRIGHT';
  FNormaltop    := TONCustomCrop.Create;
  FNormaltop.cropname:='NORMALTOP';
  FNormalbottom := TONCustomCrop.Create;
  FNormalbottom.cropname:='NORMALBOTTOM';

  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  FPressleft    := TONCustomCrop.Create;
  FPressleft.cropname := 'PRESSEDLEFT';
  FPressright   := TONCustomCrop.Create;
  FPressright.cropname := 'PRESSEDRIGHT';
  FPresstop     := TONCustomCrop.Create;
  FPresstop.cropname := 'PRESSEDTOP';
  FPressbottom  := TONCustomCrop.Create;
  FPressbottom.cropname := 'PRESSEDBOTTOM';



  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'ENTER';
  FEnterleft    := TONCustomCrop.Create;
  FEnterleft.cropname := 'ENTERLEFT';
  FEnterright   := TONCustomCrop.Create;
  FEnterright.cropname := 'ENTERRIGHT';
  FEntertop     := TONCustomCrop.Create;
  FEntertop.cropname := 'ENTERTOP';
  FEnterbottom  := TONCustomCrop.Create;
  FEnterbottom.cropname := 'ENTERBOTTOM';



  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fdisableleft    := TONCustomCrop.Create;
  Fdisableleft.cropname := 'DISABLELEFT';
  Fdisableright   := TONCustomCrop.Create;
  Fdisableright.cropname := 'DISABLERIGHT';
  Fdisabletop     := TONCustomCrop.Create;
  Fdisabletop.cropname := 'DISABLETOP';
  Fdisablebottom  := TONCustomCrop.Create;
  Fdisablebottom.cropname := 'DISABLEBOTTOM';
  Fstate := obsNormal;
  FAutoWidth := True;
  resim.SetSize(self.Width, self.Height);
  crop := True;
end;

// -----------------------------------------------------------------------------

destructor TONCropButton.Destroy;
begin
  FreeAndNil(FNormal);
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
  FreeAndNil(Fdisablebottom);

  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONCropButton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(resim) then
  begin
    Width := resim.Width;
    Height := resim.Height;
  end;

end;

procedure TONCropButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONCropButton.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
  FNormalleft.Targetrect:=RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect:=RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);

  FNormaltop.Targetrect:=RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);

  FNormalbottom.Targetrect:=RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect:=RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight-FNormalbottom.Height);

end;

procedure TONCropButton.Paint;
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



procedure TONCropButton.MouseLeave;
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
procedure TONCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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
procedure TONCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;

end;



procedure TONCropButton.MouseEnter;
begin

  if (csDesigning in ComponentState) then    exit;
  if (Enabled=false) or (Fstate = obshover) then  Exit;
  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;

end;


procedure TONCropButton.CMHittest(var msg: TCMHittest);
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




{ TONGraphicsButton }


procedure TONGraphicsButton.MouseEnter;
begin
 if (csDesigning in ComponentState) then
  exit;
  if (Enabled=false) or (Fstate = obshover) then
  Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;


procedure TONGraphicsButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONGraphicsButton.MouseLeave;
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
procedure TONGraphicsButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

constructor TONGraphicsButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'button';
  FNormal   := TONCustomCrop.Create;
  FNormal.cropname := 'NORMAL';
  FNormalleft   := TONCustomCrop.Create;
  FNormalleft.cropname:='NORMALLEFT';
  FNormalright  := TONCustomCrop.Create;
  FNormalright.cropname:='NORMALRIGHT';
  FNormaltop    := TONCustomCrop.Create;
  FNormaltop.cropname:='NORMALTOP';
  FNormalbottom := TONCustomCrop.Create;
  FNormalbottom.cropname:='NORMALBOTTOM';

  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  FPressleft    := TONCustomCrop.Create;
  FPressleft.cropname := 'PRESSEDLEFT';
  FPressright   := TONCustomCrop.Create;
  FPressright.cropname := 'PRESSEDRIGHT';
  FPresstop     := TONCustomCrop.Create;
  FPresstop.cropname := 'PRESSEDTOP';
  FPressbottom  := TONCustomCrop.Create;
  FPressbottom.cropname := 'PRESSEDBOTTOM';



  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'ENTER';
  FEnterleft    := TONCustomCrop.Create;
  FEnterleft.cropname := 'ENTERLEFT';
  FEnterright   := TONCustomCrop.Create;
  FEnterright.cropname := 'ENTERRIGHT';
  FEntertop     := TONCustomCrop.Create;
  FEntertop.cropname := 'ENTERTOP';
  FEnterbottom  := TONCustomCrop.Create;
  FEnterbottom.cropname := 'ENTERBOTTOM';



  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fdisableleft    := TONCustomCrop.Create;
  Fdisableleft.cropname := 'DISABLELEFT';
  Fdisableright   := TONCustomCrop.Create;
  Fdisableright.cropname := 'DISABLERIGHT';
  Fdisabletop     := TONCustomCrop.Create;
  Fdisabletop.cropname := 'DISABLETOP';
  Fdisablebottom  := TONCustomCrop.Create;
  Fdisablebottom.cropname := 'DISABLEBOTTOM';

  Fstate := obsNormal;
  Width := 100;
  Height := 30;
  Transparent := True;

  //  ControlStyle := ControlStyle + [csClickEvents, csDoubleClicks, csCaptureMouse];
  FAutoWidth := True;
  resim.SetSize(ClientWidth, ClientHeight);
end;

// -----------------------------------------------------------------------------

destructor TONGraphicsButton.Destroy;
begin
  FreeAndNil(FNormal);
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
  FreeAndNil(Fdisablebottom);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONGraphicsButton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(resim) then
  begin
    Width := resim.Width;
    Height := resim.Height;
  end;

end;

procedure TONGraphicsButton.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
  FNormalleft.Targetrect:=RECT(0,0,FNormalleft.Width,SELF.ClientHeight);
  FNormalright.Targetrect:=RECT(SELF.ClientWidth-FNormalright.Width,0,SELF.ClientWidth,SELF.ClientHeight);
  FNormaltop.Targetrect:=RECT(FNormalleft.Width,0,SELF.ClientWidth-FNormalright.Width,FNormaltop.Height);
  FNormalbottom.Targetrect:=RECT(FNormalleft.Width,Self.ClientHeight-FNormalbottom.Height,SELF.ClientWidth-FNormalright.Width,ClientHeight);
  FNormal.Targetrect:=RECT(FNormalleft.Width,FNormaltop.Height,SELF.ClientWidth-FNormalright.Width,self.ClientHeight-FNormalbottom.Height);

end;

procedure TONGraphicsButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONGraphicsButton.Paint;
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






{ TOnSwich }

procedure TOnSwich.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;



procedure TOnSwich.CMonmouseenter(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obshover;
  Invalidate;
end;

procedure TOnSwich.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obsnormal;
  Invalidate;
end;



procedure TOnSwich.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TOnSwich.MouseUp(Button: TMouseButton; Shift: TShiftState;
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



constructor TOnSwich.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname := 'swich';
  FOpen := TONCUSTOMCROP.Create;
  FOpen.cropname := 'OPEN';
  Fclose := TONCUSTOMCROP.Create;
  Fclose.cropname := 'CLOSE';
  Fopenhover := TONCUSTOMCROP.Create;
  Fopenhover.cropname := 'OPENHOVER';
  Fclosehover := TONCUSTOMCROP.Create;
  Fclosehover.cropname := 'CLOSEHOVER';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;
  //  FOnChange:=TNotifyEvent;
end;

destructor TOnSwich.Destroy;
begin
  FreeAndNil(FOpen);
  FreeAndNil(Fclose);
  FreeAndNil(Fopenhover);
  FreeAndNil(Fclosehover);
  FreeAndNil(Fdisable);
  inherited Destroy;
end;


procedure TOnSwich.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);

end;

procedure TOnSwich.Paint;
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




{ TOnCheckbox }



procedure TOnCheckbox.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;

 //   if (self is TOnRadioButton) then
 //     deaktifdigerleri;

    Invalidate;
  end;
end;

function TOnCheckbox.GetCheckWidth: integer;
begin
  Result := fcheckwidth;
end;

procedure TOnCheckbox.SetCheckWidth(AValue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;

procedure TOnCheckbox.SetCaptionmod(const val: Tcapdirection);
begin
  if fcaptiondirection = val then  exit;
  fcaptiondirection := val;
  Invalidate;
end;

function TOnCheckbox.GetCaptionmod: Tcapdirection;
begin
  Result := fcaptiondirection;
end;

procedure TOnCheckbox.deaktifdigerleri;
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
        if (Controls[i] is TOnRadioButton) and (Sibling <> Self)  then
        begin
          TonRadiobutton(Sibling).SetChecked(False);// Checked := False;
          TonRadiobutton(Sibling).fstate := obsnormal;// Checked := False;
      //    ShowMessage(self.Parent.Name);
         // Invalidate;
        end;
      end;

    end;
  fChecked:=true;
end;




procedure TOnCheckbox.CMonmouseenter(var Messages: Tmessage);
begin
  fstate := obshover;
  Invalidate;
end;

procedure TOnCheckbox.CMonmouseleave(var Messages: Tmessage);
begin
  fstate := obsnormal;
  Invalidate;
end;

procedure TOnCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TOnCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mouseup(button, shift, x, y);
  fstate := obshover;
  Invalidate;
end;

procedure TOnCheckbox.DoOnChange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TOnCheckbox.CMHittest(var msg: TCMHIttest);
begin
  inherited;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

constructor TOnCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname := 'checkbox';
  fcheckwidth := 12;
  fcaptiondirection := ocright;
  obenter := TONCUSTOMCROP.Create;
  obenter.cropname := 'NORMALHOVER';
  obleave := TONCUSTOMCROP.Create;
  obleave.cropname := 'NORMAL';
  obdown := TONCUSTOMCROP.Create;
  obdown.cropname := 'PRESSED';
  obcheckleaves := TONCUSTOMCROP.Create;
  obcheckleaves.cropname := 'CHECK';
  obcheckenters := TONCUSTOMCROP.Create;
  obcheckenters.cropname := 'CHECKHOVER';
  obdisabled := TONCUSTOMCROP.Create;
  obdisabled.cropname := 'DISABLE';
  Fstate := obsnormal;
  FChecked := False;
  Captionvisible := False;
  textx:=10;
  Texty:=10;
end;

destructor TOnCheckbox.Destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);
  FreeAndNil(obdisabled);
  inherited Destroy;
end;

procedure TOnCheckbox.SetSkindata(Aimg: TONImg);
var
   fbuttoncenter: integer;

begin
  inherited SetSkindata(Aimg);
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
end;

procedure TOnCheckbox.Paint;
var
  DR: TRect;

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


end.

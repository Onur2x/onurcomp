unit butonu;

 {$mode ObjFPC} {$H+}

interface

uses
  Classes, LMessages,
  {$IFDEF UNIX}unix{$ELSE} Windows{$ENDIF}, SysUtils,
  Forms, Controls, Graphics, Messages, Dialogs,
  ExtCtrls, Types,LCLType,  LazUTF8,StdCtrls;




type

  Tobutonstate = (obenters, obleaves, obdowns);
  ToExpandStatus = (oExpanded, oCollapsed); // collapsed panel
  Tcapdirection = (ocup, ocdown, ocleft, ocright);
  Tbutondirection = (obleft, obright);
  Tokindstate = (oVertical, oHorizontal);
  ToswichState = (fon,foff);

  { TOcolors }
  TOPersistent = class(TPersistent)
    owner: TPersistent;
    constructor Create(Aowner: TPersistent); overload virtual;
  end;

  Tocolor = class(TOPersistent)
  private
  //  owner:TPersistent;
    Fstartc, fstopc, fborderc, ffontcolor: Tcolor;
    fborder: integer;
    function getborder: integer;
    function getbordercolor: Tcolor;
    function getstartcolor: Tcolor;
    function getstopcolor: Tcolor;
    function getfontcolor: Tcolor;
    procedure Setborder(const Value: integer);
    procedure Setbordercolor(const Value: Tcolor);
    procedure Setstartcolor(const Value: Tcolor);
    procedure Setstopcolor(const Value: Tcolor);
    procedure setfontcolor(const Value: Tcolor);
  public
    function paint: boolean;
  published
    property Border      : integer read getborder      write Setborder default 1;
    property Startcolor  : TColor  read getstartcolor  write setstartcolor;
    property Stopcolor   : TColor  read getstopcolor   write setstopcolor;
    property Bordercolor : TColor  read getbordercolor write setbordercolor;
    property Fontcolor   : TColor  read getfontcolor   write Setfontcolor;
  end;



  { ToCustomcontrol }

  ToCustomcontrol = class(TCustomControl)
  private
    fbackground: Tocolor;
    Fkind: Tokindstate;
//    fbackgroundcolored: boolean;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure Drawtorect(Cnv: Tcanvas; rc: Trect; tc: ToColor; Fkindi: Tokindstate);
    function Getkind: Tokindstate;
    procedure SetKind(AValue: Tokindstate);
  protected
  public
    Backgroundcolored : boolean;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    property Kind: Tokindstate read Getkind write SetKind;
    property Caption;

  published
    property Background: Tocolor read fbackground write fbackground;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ChildSizing;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;



  { TOGraphicControl }

  TOGraphicControl = class(TGraphicControl)
  private
    fbackground: Tocolor;
    Fkind: Tokindstate;
//    fbackgroundcolored: boolean;
    function Getkind: Tokindstate;
    function GetTransparent: boolean;
    procedure Setkind(Value: Tokindstate);
    procedure Drawtorect(Cnv: Tcanvas; rc: Trect; tc: ToColor; Fkindi: Tokindstate);
    procedure SetTransparent(AValue: boolean);
  public
    Backgroundcolored : boolean;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    property Kind: Tokindstate read Getkind          write Setkind default oHorizontal;
    property Caption;
  published
    property Background: Tocolor read fbackground write fbackground;
    property Transparent: boolean read GetTransparent
      write SetTransparent default True;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { TOled }
 type

 // TledStyle = (fHorz, fVert, fRectangle, fDiagonal, fCircle);
  TOled = class(TOGraphicControl)
  private
   //Fbar: Tocolor;
   fcheck:boolean;
   foncolor: Tocolor;
   foffcolor: Tocolor;
   FOnChange: TNotifyEvent;
   procedure Setoncolor(const Val: Tocolor);
   procedure Setoffcolor(const Val: Tocolor);
   procedure Setledonoff(val:boolean);
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Background;
    property Oncolor: Tocolor read foncolor write Setoncolor;
    property Offcolor: Tocolor read foffcolor write Setoffcolor;
    Property LedOnOff:Boolean Read fcheck write Setledonoff;
    property Onchange: TNotifyEvent read FOnChange write FOnChange;
    property Transparent;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  End;

  { TOCustomProgressBar }

  TOProgressBar = class(TOGraphicControl)
  private
    fbar: Tocolor;
    FOnChange: TNotifyEvent;
    fposition, fmax, fmin: Int64;
    ftext: string;
    FCaptonvisible: boolean;
    procedure setposition(const Val: Int64);
    procedure setmax(const Val: Int64);
    procedure setmin(const Val: Int64);
    function Getposition: Int64;
    function Getmin: Int64;
    function Getmax: Int64;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Captonvisible: boolean read FCaptonvisible write FCaptonvisible;
    property Background;
    property Bar: Tocolor read fbar write fbar;
    property Min: Int64 read Getmin write setmin;
    property Max: Int64 read Getmax write setmax;
    property Position: Int64 read Getposition write setposition;
    property Onchange: TNotifyEvent read FOnChange write FOnChange;
    property Kind;
    property Transparent;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { Tobuton }

  Tobuton = class(ToGraphicControl)
  private
    fenter, fleave, fdown, fdisabled: Tocolor;
    fstate: Tobutonstate;
    //    fonstatechange: Tobutonstatechange;
    procedure SetenterC(val:Tocolor);
    procedure SetLeaveC(val:Tocolor);
    procedure SetDownC(val:Tocolor);
    procedure SetDisableC(val:Tocolor);

  protected
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property ColorEnter: Tocolor read fenter write SetenterC;
    property ColorLeave: Tocolor read fleave write SetLeaveC;
    property ColorDown: Tocolor read fdown write SetDownC;
    property ColorDisable: Tocolor read fdisabled write SetDisableC;
    property State: Tobutonstate read fstate write fstate;
    property Caption;
    property Transparent;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ParentColor;
    property ShowHint;
    property Visible;

  end;

  { TOGraphicPanel }

  TOGraphicPanel = class(ToGraphicControl)
  public
    procedure paint; override;
  published
    property Background;
    property Kind;
    property Caption;
    property Transparent;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


  TOpanel = class(ToCustomcontrol)
  public
    procedure paint; override;
  published
    property Background;
    property Kind;
    property Caption;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ChildSizing;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { TCollapExpandpanel }

  TCollapExpandpanel = class(ToCustomcontrol)
  private
    FStatus: ToExpandStatus;
    FOnCollapse: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    FExpandButton: Tobuton;
    FAutoCollapse: boolean;
    fminheight: integer;
    fnormalheight: integer;
    //    fheight         : integer;
    fbutonen, fbutonle, fbutondown: Tocolor;
    fbutondirection: Tbutondirection;
    procedure SetStatus(const AValue: ToExpandStatus);
    procedure SetAutoCollapse(const AValue: boolean);
    procedure SetOnCollapse(const AValue: TNotifyEvent);
    procedure SetOnExpand(const AValue: TNotifyEvent);
    function GetMinheight: integer;
    function GetNormalheight: integer;
    procedure Setminheight(const Avalue: integer);
    procedure Setnormalheight(const Avalue: integer);
    procedure ResizePanel();
  protected
    procedure OnMyButtonClick(Sender: TObject);
    procedure DblClick; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property OnExpand: TNotifyEvent read FOnExpand write SetOnExpand;
    property OnCollapse: TNotifyEvent
      read FOnCollapse write SetOnCollapse;
    property AutoCollapse: boolean
      read FAutoCollapse write SetAutoCollapse;
    property Status: ToExpandStatus read FStatus write SetStatus;
    property Minheight: integer read GetMinheight write Setminheight;
    property Normalheight: integer
      read GetNormalheight write Setnormalheight;
    property Caption;//String            read Gettexti         write Settexti;
    property Kind;
    property ButtonEnter: Tocolor read fbutonen write fbutonen;
    property ButtonLeave: Tocolor read fbutonle write fbutonle;
    property ButtonDown: Tocolor read fbutondown write fbutondown;
    property ButtonPosition: Tbutondirection
      read fbutondirection write fbutondirection;
    property Background;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ChildSizing;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

  end;


  { Toswich }

  Toswich = class(ToGraphicControl)
   private
    obenter, obleave, obdown, obdisabled: ToColor;
    fstate      : Tobutonstate;
    fswichstate : ToswichState;
    fcheckwidth : integer;
    froundx,froundy : integer;
    fcaptionoff,fcaptionon:string;
   // fchecked    : boolean;
   // fcaptiondirection : Tcapdirection;
    FOnChange : TNotifyEvent;
    function GetChecWidth: integer;
    procedure SetChecWidth(AValue: integer);
   // procedure SetCaptionmod(const val: Tcapdirection);
   // procedure SetChecked(const Value: boolean);
   // function GetChecked: boolean;
    procedure SetState(const Value: Tobutonstate);
    function GetState: Tobutonstate;
    procedure SetSwState(const Value: ToswichState);
    function GetSwState: ToswichState;
  protected
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure CMHittest(var msg: TCMHIttest);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property ColorEnter: Tocolor read obenter write obenter;
    property ColorLeave: Tocolor read obleave write obleave;
    property ColorDown: Tocolor read obdown write obdown;
    property ColorDisable: Tocolor read obdisabled write obdisabled;
    property CaptionOn  : String read fcaptionon write fcaptionon;
    property CaptionOff : String read fcaptionoff write fcaptionoff;
    property State: Tobutonstate read GetState write SetState;
    property SwichState: ToswichState read GetSwState write SetSwState;
    property RoundX : integer read froundx write froundx;
    property RoundY : integer read froundy write froundy;

  //  property Checked: boolean read GetChecked write SetChecked;
    property ChecWidth: integer read GetChecWidth write SetChecWidth;
  //  property CaptionDirection: Tcapdirection read GetCaptionmod write SetCaptionmod;
    property Transparent;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


  { Toswich }

   { ToImgradio }

   ToImgradio = class(TGraphicControl)
   private
    fkind          : Tokindstate;
    fres           : TPortableNetworkGraphic;//TPicture;
    FOnChange      : TNotifyEvent;
    fframe,fframee : integer;
    Function Getitemat(Pos: Tpoint): Integer;
    function GetTransparent: boolean;
    procedure setbitmap(const AValue: TPortableNetworkGraphic);// TPicture);
    Procedure Setfframe(Avalue: Integer);
    Procedure Setframe(Const Avalue: Integer);
    procedure SetTransparent(const AValue: boolean);
    procedure ImageSet(Sender: TObject);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    Procedure Change; Virtual;

  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Picture: TPortableNetworkGraphic{ TPicture} read fres write Setbitmap;
    property PictureKind : Tokindstate read fkind write fkind;
    property Transparent: boolean read GetTransparent
      write SetTransparent default True;
    property FrameCount : integer read fframe write SetFrame;
    Property Frameindex : integer read fframee write SetFframe;//fframee;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;
  { ToImgswich }

  ToImgswich = class(TGraphicControl)
   private
    fkind          : Tokindstate;
    fres           : TPortableNetworkGraphic;//TPicture;
    FOnChange      : TNotifyEvent;
    fframe,fframee : integer;
    fclickable     : Boolean;
    Function Getitemat(Pos: Tpoint): Integer;
    function GetTransparent: boolean;
    procedure setbitmap(const AValue: TPortableNetworkGraphic);// TPicture);
    Procedure Setclickable(Avalue: Boolean);
    Procedure Setfframe(Const Avalue: Integer);
    Procedure Setframe(Const Avalue: Integer);
    procedure SetTransparent(const AValue: boolean);
    procedure ImageSet(Sender: TObject);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
 //   procedure DoOnChange; virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;

  published
    property Picture     : TPortableNetworkGraphic{TPicture} read fres       write Setbitmap;
    property PictureKind : Tokindstate                       read fkind      write fkind;
    property Transparent : boolean                           read GetTransparent
      write SetTransparent;// default True;
    property FrameCount  : integer                           read fframe     write SetFrame;
    property Frameindex  : integer                           read fframee    write SetFframe;// fframee;
    property Clickable   : Boolean                           read fclickable write fclickable;//SetClickable;//  Default False;
    property OnChange    : TNotifyEvent                      read FOnChange  write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { Tocheckbox }

  Tocheckbox = class(ToGraphicControl)
  private
    obenter, obleave, obdown, obdisabled, obcheckenters, obcheckleaves: ToColor;
    fstate: Tobutonstate;
    fcheckwidth: integer;
    fchecked: boolean;
    fcaptiondirection: Tcapdirection;
    FOnChange: TNotifyEvent;
    function GetChecWidth: integer;
    procedure SetChecWidth(AValue: integer);
    procedure SetCaptionmod(const val: Tcapdirection);
    procedure SetChecked(const Value: boolean);
    function GetChecked: boolean;
    procedure SetState(const Value: Tobutonstate);
    function GetState: Tobutonstate;
    function GetCaptionmod: Tcapdirection;
    procedure deaktifdigerleri;
  protected
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure CMHittest(var msg: TCMHIttest);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property ColorEnter: Tocolor read obenter write obenter;
    property ColorLeave: Tocolor read obleave write obleave;
    property ColorDown: Tocolor read obdown write obdown;
    property ColorCheckEnter: Tocolor read obcheckenters write obcheckenters;
    property ColorCheckLeave: Tocolor read obcheckleaves write obcheckleaves;
    property ColorDisable: Tocolor read obdisabled write obdisabled;
    property Caption;
    property State: Tobutonstate read GetState write SetState;
    property Checked: boolean read GetChecked write SetChecked;
    property ChecWidth: integer read GetChecWidth write SetChecWidth;
    property CaptionDirection: Tcapdirection read GetCaptionmod write SetCaptionmod;
    property Transparent;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { ToRadiobutton }

  ToRadiobutton = class(ToGraphicControl)
    private
    obenter, obleave, obdown, obdisabled, obcheckenters, obcheckleaves: ToColor;
    fstate: Tobutonstate;
    fcheckwidth: integer;
    fchecked: boolean;
    fcaptiondirection: Tcapdirection;
    FOnChange: TNotifyEvent;
    function GetChecWidth: integer;
    procedure SetChecWidth(AValue: integer);
    procedure SetCaptionmod(const val: Tcapdirection);
    procedure SetChecked(const Value: boolean);
    function GetChecked: boolean;
    procedure SetState(const Value: Tobutonstate);
    function GetState: Tobutonstate;
    function GetCaptionmod: Tcapdirection;
    procedure deaktifdigerleri;
  protected
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure CMHittest(var msg: TCMHIttest);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure DoOnChange; virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property ColorEnter: Tocolor read obenter write obenter;
    property ColorLeave: Tocolor read obleave write obleave;
    property ColorDown: Tocolor read obdown write obdown;
    property ColorCheckEnter: Tocolor read obcheckenters write obcheckenters;
    property ColorCheckLeave: Tocolor read obcheckleaves write obcheckleaves;
    property ColorDisable: Tocolor read obdisabled write obdisabled;
    property Caption;
    property State: Tobutonstate read GetState write SetState;
    property Checked: boolean read GetChecked write SetChecked;
    property ChecWidth: integer read GetChecWidth write SetChecWidth;
    property CaptionDirection: Tcapdirection read GetCaptionmod write SetCaptionmod;
    property Transparent;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;


    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;

    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { TOTrackBar }

  TOTrackBar = class(ToGraphicControl)
  private
    obenter, obleave, obdown, fdisabled: ToColor;
    fcbutons: Tobutonstate;
    fcenterbuttonarea: TRect;
    FW, FH: integer;
    FPosition, FXY, FPosValue: integer;
    FMin, FMax: integer;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;
    procedure centerbuttonareaset;
    function CheckRange(const Value: integer): integer;
    function Getcolors(xx: Tobutonstate): Tocolor;
    function MaxMin: integer;
    function CalculatePosition(const Value: integer): integer;
    function GetPosition: integer;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    function SliderFromPosition(const Value: integer): integer;
    function PositionFromSlider(const Value: integer): integer;
    procedure SetPosition(Value: integer); virtual;
    procedure SetPercentage(Value: integer);
    procedure Changed;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    function GetPercentage: integer;
    //    property Positioning : Boolean read FIsPressed;
  published
    { Published declarations }
    property Background;//   : Tocolor          read fbackground    write fbackground;
    property ButtonLeave: Tocolor read obleave write obleave;
    property ButtonEnter: Tocolor read obenter write obenter;
    property ButtonDown: Tocolor read obdown write obdown;
    property ButtonDisabled: Tocolor read fdisabled write fdisabled;
    property Position: integer read GetPosition write SetPosition;
    property Percentage: integer read GetPercentage write SetPercentage;
    property Kind;//         : Tokindstate    read Getkind          write Setkind;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
  end;

  { TOCustomScrollBar }

  { ToScrollBar }

  ToScrollBar = class(ToGraphicControl)
  private
    obenter, obleave, obdown, fdisabled: ToColor;
    fcbutons, flbutons, frbutons: Tobutonstate;
    flbuttonrect, frbuttonrect, Ftrackarea, fcenterbuttonarea: TRect;
    FW, FH: integer;
    FPosition, FXY, FPosValue: integer;
    FMin, FMax: integer;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;
    procedure centerbuttonareaset;
    function Getcolors(xx: Tobutonstate): Tocolor;
    procedure SetPosition(Value: integer);
    procedure SetMax(Val: integer);
    procedure Setmin(Val: integer);
    function Getposition: integer;
    function Getmin: integer;
    function Getmax: integer;
    function CheckRange(const Value: integer): integer;
    function MaxMin: integer;
    function CalculatePosition(const Value: integer): integer;
    function SliderFromPosition(const Value: integer): integer;
    function PositionFromSlider(const Value: integer): integer;
    procedure SetPercentage(Value: integer);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;

    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    function GetPercentage: integer;
  published
    property Background;
    property ButtonLeave    : Tocolor      read obleave     write obleave;
    property ButtonEnter    : Tocolor      read obenter     write obenter;
    property ButtonDown     : Tocolor      read obdown      write obdown;
    property ButtonDisabled : Tocolor      read fdisabled   write fdisabled;
    property Min            : integer      read Getmin      write setmin;
    property Max            : integer      read Getmax      write setmax;
    property Position       : integer      read Getposition write setposition;
    property OnChange       : TNotifyEvent read FOnChange   write FOnChange;
    property Kind;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
  end;



  { ToListBox }

  ToListBox = class(ToCustomcontrol)
  private
    Flist: TStrings;//List;
    findex: integer;
    fvert, fhorz: ToScrollBar;
    FItemsShown, FitemHeight, Fitemoffset: integer;
    //FFocusedItem: integer;
    Fselectedcolor:Tcolor;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;   override;

    function GetItemAt(Pos: TPoint): integer;
    function getitemheight: integer;
    function GetItemIndex: integer;
    function ItemRect(Item: integer): TRect;
    procedure LinesChanged(Sender: TObject);
    procedure MoveDown;
    procedure MoveEnd;
    procedure MoveHome;
    procedure MoveUp;
    procedure setitemheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure Scrollchange(Sender: TObject);
  protected
    procedure KeyDown(var Key: word; Shift: TShiftState);virtual;
    procedure SetString(AValue: TStrings); virtual;
   // procedure KeyDown(var Key: word; Shift: TShiftState); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Clear;
  published
    property Items            : TStrings    read Flist          write SetString;
    property ItemIndex        : integer     read GetItemIndex   write SetItemIndex;
    property ItemHeight       : integer     read GetItemHeight  write SetItemHeight;
    property HorizontalScroll : ToScrollBar read fhorz          write fhorz;
    property VertialScroll    : ToScrollBar read fvert          write fvert;
    property Selectedcolor    : Tcolor      Read Fselectedcolor write Fselectedcolor;
    property Background;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property TabOrder;
    property TabStop default true;
  end;



  { ToChecklistbox }
  TCheckEvent = procedure ( Sender : TObject ; Index : Integer ) of object;

  ToChecklistbox = class(ToCustomcontrol)
  private
    obenter, obleave, obdown, obdisabled, obcheckenters, obcheckleaves: ToColor;
    Flist: TStrings;
    findex,fstateindex: integer;
    Fstate:Tobutonstate;
    Fstatelist,Fchecklist: TList;
    fvert, fhorz: ToScrollBar;
    FItemsShown, FitemHeight, Fitemoffset: integer;
    Fbuttonheight:integer;
    Fselectedcolor:Tcolor;
    FOnCheck 	  : TCheckEvent;
    FOnUnCheck    : TCheckEvent;
    FUserCheck    : Boolean;
    FClickInBox   : Boolean;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;   override;
    function getbuttonheight: integer;
    function GetItemAt(Pos: TPoint): integer;
    function GetItemIndex: integer;
    function getstatenumber(index: integer): integer;
    function ItemRect(Item: integer): TRect;
    function CheckBoxRect( Index : Integer ) : TRect;
    procedure LinesChanged(Sender: TObject);
    procedure MoveDown;
    procedure MoveEnd;
    procedure MoveHome;
    procedure MoveUp;
    procedure setbuttonheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure Scrollchange(Sender: TObject);
    procedure KeyDown(var Key: word; Shift: TShiftState);
    procedure SetString(AValue: TStrings);

    function  IsChecked( Index : Integer ) : Boolean;
    procedure Check( Index : Integer ; AChecked : Boolean );
    function GetAllChecked : Boolean;
    function GetNoneChecked : Boolean;
  protected
    procedure CheckEvent( Index : Integer ); virtual;
    procedure UnCheckEvent( Index : Integer ); virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Clear;
    procedure CheckSelection(AChecked : Boolean);
    procedure Toggle(Index : Integer);
    procedure CheckAll(AChecked : Boolean);
    property Checked[Index : Integer] : Boolean read 	IsChecked write Check;
  published
    property Items            : TStrings    read Flist          write SetString;
    property ItemIndex        : integer     read GetItemIndex   write SetItemIndex;
    property ButtonHeight     : integer     read GetButtonHeight write SetButtonHeight;
    property HorizontalScroll : ToScrollBar read fhorz          write fhorz;
    property VertialScroll    : ToScrollBar read fvert          write fvert;
    property Selectedcolor    : Tcolor      read Fselectedcolor write Fselectedcolor;
    property OnCheck 	      : TCheckEvent read FOnCheck       write FOnCheck;
    property OnUncheck 	      : TCheckEvent read FOnUncheck     write FOnUnCheck;
    property ColorEnter       : Tocolor     read obenter        write obenter;
    property ColorLeave       : Tocolor     read obleave        write obleave;
    property ColorDown        : Tocolor     read obdown         write obdown;
    property ColorDisable     : Tocolor     read obdisabled     write obdisabled;
    property ColorCheckEnter  : Tocolor     read obcheckenters  write obcheckenters;
    property ColorCheckLeave  : Tocolor     read obcheckleaves  write obcheckleaves;
    property AllChecked       : Boolean     read GetAllChecked;
    property NoneChecked      : Boolean     read GetNoneChecked;
    property Background;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ChildSizing;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


  Tocustomedit = class;
  { Toncaret }

  Toncaret = class(TOPersistent)
  private
    parent: Tocustomedit;
    FHeight, FWidth: integer;
    fvisibled: boolean;
    fblinkcolor: Tcolor;
    fblinktime: integer;
    function Getblinktime: integer;
    procedure Setblinktime(const Value: integer);
    function Getvisible: boolean;
    procedure Setvisible(const Value: boolean);
    procedure ontimerblink(Sender: TObject);
    function Paint: boolean;
  public
    CaretPos: TPoint;
    //PositionX, PositionY: integer;
    caretvisible: boolean;
    blinktimer: Ttimer;
    constructor Create(aowner: TPersistent);
    destructor Destroy; override;
  published
    //    property PositionX : integer read FPosx        write FPosx;
    //    property PositionY : integer read FPosy        write FPosy;
    property Visible: boolean read Getvisible write Setvisible;
    //    property Caretvisible : boolean read fcaretvisible write fcaretvisible;
    property Blinktime: integer read Getblinktime write Setblinktime;
    property Height: integer read FHeight write FHeight;
    property Width: integer read FWidth write FWidth;
    property Color: Tcolor read fblinkcolor write fblinkcolor;
    //    property Blink     : TTimer  read fblinktimer  write fblinktimer;


  end;


  ToCharCase = (ecNormal, ecUppercase, ecLowerCase);
  TOEchoMode = (emNormal, emNone, emPassword);


  { Tocustomedit }

  Tocustomedit = class(ToCustomControl)
  private
    fSelStart: TPoint;
    fSelLength: integer;
    fVisibleTextStart: TPoint;
    fMultiLine: boolean;
    //  fLines: TStrings; // Just a reference, never Free
    fFullyVisibleLinesCount, fLineHeight: integer;
    // Filled on drawing to be used in customdrawncontrols.pas
    fPasswordChar: char;
    // customizable extra margins, zero is the base value
    fLeftTextMargin, fRightTextMargin: integer;
    FNumbersOnly: boolean;
    Fcharcase: ToCharCase;
    fEchoMode: TOEchoMode;
    DragDropStarted: boolean;
    FLines: TStrings;
    FOnChange: TNotifyEvent;
    FReadOnly: boolean;
    FCarets: Toncaret;
    function Caretttopos(leftch: integer): integer;
    procedure DrawCaret;
    procedure DrawText;
    function GetCaretPos: TPoint;
    function GetCharCase: ToCharCase;
    function GetEchoMode: TOEchoMode;
    function GetLeftTextMargin: integer;
    function GetMultiLine: boolean;


    function GetRightTextMargin: integer;
    function GetPasswordChar: char;
    //    procedure HandleCaretTimer(Sender: TObject);
    procedure DoDeleteSelection;
    procedure DoClearSelection;
    procedure DoManageVisibleTextStart;
    procedure SetCaretPost(AValue: TPoint);
    procedure SetCharCase(const Value: ToCharCase);
    procedure SetEchoMode(const Value: TOEchoMode);
    procedure SetLeftTextMargin(AValue: integer);
    procedure SetLines(AValue: TStrings);
    procedure SetMultiLine(AValue: boolean);
    procedure SetNumberOnly(const Value: boolean);

    procedure SetRightTextMargin(AValue: integer);
    procedure SetText(AValue: string);
    procedure SetPasswordChar(AValue: char);
    function MousePosToCaretPos(X, Y: integer): TPoint;
    function IsSomethingSelected: boolean;
//    function GetMeasures(AMeasureID: integer): integer;// virtual; abstract;
  protected
    function GetText: string; virtual;
    function GetNumberOnly: boolean; virtual;
    function GetReadOnly: boolean; virtual;
    procedure setreadonly(avalue: boolean); virtual;
    procedure RealSetText(const Value: TCaption); override;

    // to update on caption changes, don't change this as it might break descendents
    // for descendents to override
    procedure DoChange; virtual;
    // keyboard
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    // mouse
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKILLFOCUS); message LM_KILLFOCUS;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCurrentLine(): string;
    procedure SetCurrentLine(AStr: string);
    property LeftTextMargin: integer read GetLeftTextMargin write SetLeftTextMargin;
    property RightTextMargin: integer read GetRightTextMargin write SetRightTextMargin;
    // selection info in a format compatible with TEdit
    function GetSelStartX: integer;
    function GetSelLength: integer;
    procedure SetSelStartX(ANewX: integer);
    procedure SetSelLength(ANewLength: integer);
    property CaretPos: TPoint read GetCaretPos write SetCaretPost;
    property Lines: TStrings read FLines write SetLines;
    property MultiLine: boolean read GetMultiLine
      write SetMultiLine default False;
    property PasswordChar: char read GetPasswordChar
      write SetPasswordChar default #0;
    procedure paint; override;
  published
    property Background: Tocolor read fbackground write fbackground;
    property ReadOnly: boolean read GetReadOnly   write SetReadOnly default False;
    property Text: string read GetText
      write SetText stored False; // This is already stored in Lines
    property NumberOnly: boolean read GetNumberOnly write SetNumberOnly;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property CharCase: ToCharCase read GetCharCase write SetCharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property TabStop;
    property TabOrder;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

  end;


  Toedit = class(Tocustomedit)
  protected
    //    property Carets;
    property Background;
    property Text;
    //    property Selstart;
    //    property SelEnd;
    //    property SelText;
    property PasswordChar;
    property OnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property TabStop;
    property TabOrder;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ReadOnly;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { Tomemo }

  Tomemo = class(Tocustomedit)
  public
    constructor Create(AOwner: TComponent); override;
  protected
    //    property Carets;
    property Lines;
    property Background;
    property Text;
    //    property Selstart;
    //    property SelEnd;
    //    property SelText;
    property PasswordChar;
    property OnChange;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property TabStop;
    property TabOrder;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ReadOnly;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;



  { ToSpinEdit }

  ToSpinEdit = class(ToCustomcontrol)
  private
   Fdbutton       : Tobuton;
   Fubutton       : Tobuton;
   Fedit          : Toedit;
   Fonchange      : TNotifyEvent;
   fReadOnly      : Boolean;
   fvalue         : integer;
   fmin,Fmax      : integer;
   Fbuttonwidth   : integer;
   Fbuttonheight  : integer;
   procedure feditchange(sender: tobject);
   function getbuttonheight: integer;
   function getbuttonwidth: integer;
   function Getmax: integer;
   function Getmin: integer;
   procedure kclick(Sender: TObject);
   function Gettext: integer;
   procedure setbuttonheight(avalue: integer);
   procedure setbuttonwidth(avalue: integer);
   procedure Setmax(AValue: integer);
   procedure Setmin(AValue: integer);
   procedure Settext(Avalue: integer);
   procedure KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
   procedure Resize;override;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Paint;override;
  published
    property Value         : integer       read Gettext         write SetText;
    property MaxValue      : integer       read Getmin          write Setmin;
    property MinValue      : integer       read Getmax          write Setmax;
    property Buttonwidth   : integer       read GetButtonwidth  write SetButtonwidth;
    property Buttonheight  : integer       read GetButtonheight write SetButtonheight;
    property OnChange      : TNotifyEvent  read FOnChange       write FOnChange;
    property ReadOnly      : boolean       read freadonly       write freadonly;
{    property ButtonEnter   : Tocolor      read fobenter       write fobenter;
    property ButtonLeave   : Tocolor      read fobleave       write fobleave;
    property ButtonDown    : Tocolor      read fobdown        write fobdown;
    property ButtonDisable : Tocolor      read ffdisabled     write ffdisabled;     }
  //  property Background;
    property Action;
    property Align;
    property Anchors;
//    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property TabStop;
    property TabOrder;
    property ParentBidiMode;
    property OnChangeBounds;
    property ParentFont;
    property ParentShowHint;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  { Tocombobox }

  Tocombobox = class(ToCustomcontrol)
  private
   fobenter       : Tocolor;
   fobleave       : Tocolor;
   fobdown        : Tocolor;
   ffdisabled     : ToColor;
   Fliste         : TStrings;
   Fedit          : Toedit;
   FOnChange      : TNotifyEvent;
   FOnCloseUp     : TNotifyEvent;
   FOnDropDown    : TNotifyEvent;
   FOnGetItems    : TNotifyEvent;
   FOnSelect      : TNotifyEvent;
   fReadOnly      : Boolean;
   Fitemindex     : integer;
   fbutonarea     : Trect;
   FItemsShown    : integer;
   FitemHeight    : integer;
   Fitemoffset    : integer;
   Fselectedcolor : Tcolor;
   fdropdown      : boolean;
   Fbutton        : Tobuton;
   fpopupopen     : boolean;
   procedure kclick(Sender: TObject);
   function Gettext: string;
   function GetItemIndex: integer;
   procedure LinesChanged(Sender: TObject);
   procedure MoveDown;
   procedure MoveEnd;
   procedure MoveHome;
   procedure MoveUp;

   procedure setitemheight(avalue: integer);
   procedure SetItemIndex(Avalue: integer);
   procedure SetText(AValue: string);
   procedure SetButtonenter(val:Tocolor);
   procedure SetButtonLeave(val:Tocolor);
   procedure SetButtonDown(val:Tocolor);
   procedure SetButtonDisable(val:Tocolor);

   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;

   procedure LstPopupReturndata(Sender: TObject; const Str:string; const indx:integer);
   procedure LstPopupShowHide(Sender: TObject);
  protected
    procedure Change; virtual;
    procedure Select; virtual;
    procedure DropDown; virtual;
    procedure GetItems; virtual;
    procedure CloseUp; virtual;
    procedure SetStrings(AValue: TStrings); virtual;
    procedure KeyDown(var Key: word; Shift: TShiftState);  virtual;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnGetItems: TNotifyEvent read FOnGetItems write FOnGetItems;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Paint;override;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
  published
    property Text          : string       read Gettext        write SetText;
    property Items         : TStrings     read Fliste         write SetStrings;
    property OnChange      : TNotifyEvent read FOnChange      write FOnChange;
    property ReadOnly      : boolean      read freadonly      write freadonly;
    property Itemindex     : integer      read Getitemindex   write Setitemindex;
    property Selectedcolor : Tcolor       read Fselectedcolor write Fselectedcolor;
    property ButtonEnter   : Tocolor      read fobenter       write SetButtonenter;
    property ButtonLeave   : Tocolor      read fobleave       write SetButtonLeave;
    property ButtonDown    : Tocolor      read fobdown        write SetButtonDown;
    property ButtonDisable : Tocolor      read ffdisabled     write SetButtonDisable;
    property ItemHeight    : integer      read FitemHeight    write SetItemHeight;
  //  property Background;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property TabStop;
    property TabOrder;
    property ParentBidiMode;
    property OnChangeBounds;
    property ParentFont;
    property ParentShowHint;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;





  { Tpopupformcombobox }

  TReturnStintEvent = procedure (Sender: TObject; const ftext: string; const itemind:integer) of object;

  Tpopupformcombobox= class(TcustomForm)
    procedure listboxDblClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
//    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    FCaller: Tocombobox;
    FClosed: boolean;
    oblist :ToListBox;
    FOnReturnDate: TReturnStintEvent;
    constructor Create(TheOwner: TComponent);override;
    procedure CMDeactivate(var Message: TLMessage); message CM_DEACTIVATE;
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure DoShow;override;
    procedure KeepInView(const PopupOrigin: TPoint);
    procedure ReturnstringAnditemindex;
  protected
    procedure Paint; override;
  end;


  TBalloonType     = (blnInfo, blnError, blnWarning);
  TBalloonHoriz    = (blnLeft, blnMiddle, blnRight);
  TBalloonVert     = (blnTop, blnCenter, blnBottom);
  TBalloonPosition = (blnArrowTopLeft, blnArrowTopRight, blnArrowBottomLeft, blnArrowBottomRight);


  ToBalloonControl = Class(TComponent)
  private
    FTitle: String;
    FText: TStringList;
    FDuration, FPixelCoordinateX, FPixelCoordinateY: Integer;
    FHorizontal: TBalloonHoriz;
    FVertical: TBalloonVert;
    FPosition: TBalloonPosition;
    FControl: TwinControl;
    FBalloonType: TBalloonType;
    procedure SetText(Value: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowControlBalloon;
    procedure ShowPixelBalloon;
  published
    property Text: TStringList read FText write SetText;
    property Title: String read FTitle write FTitle;
    property Duration: Integer read FDuration write FDuration;
    property Horizontal: TBalloonHoriz read FHorizontal write FHorizontal;
    property Vertical: TBalloonVert read FVertical write FVertical;
    property Position: TBalloonPosition read FPosition write FPosition;
    property Control: TWinControl read FControl write FControl;
    property PixelCoordinateX: Integer read FPixelCoordinateX write FPixelCoordinateX;
    property PixelCoordinateY: Integer read FPixelCoordinateY write FPixelCoordinateY;
    property BalloonType: TBalloonType read FBalloonType write FBalloonType;
  end;


  TBalloon = Class(TCustomForm)
  private
    lblTitle: TLabel;
    lblText: TLabel;
    pnlAlign: TPanel;
    iconBitmap: TImage;
    tmrExit: TTimer;
    Procedure FormPaint(Sender: TObject);
  protected
    Procedure CreateParams(Var Params: TCreateParams); override;
    Procedure OnMouseClick(Sender: TObject);
    Procedure OnExitTimer(Sender: TObject);
    Procedure OnChange(Sender: TObject);
    Procedure WndProc(Var Message: TMessage); override;
  public
    Constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    Procedure ShowBalloon(blnLeft, blnTop: Integer; blnTitle, blnText: String; blnType: TBalloonType; blnDuration: Integer; blnPosition: TBalloonPosition);
    procedure ShowControlBalloon(blnControl: TWinControl; blnHoriz: TBalloonHoriz;
      blnVert: TBalloonVert; blnTitle, blnText: String; blnType: TBalloonType;
  blnDuration: Integer);
  End;

  TOlist = class;
  { TOlistItem }


  TOlistItem = class(TCollectionItem)
  private
    FCaption    : String;
    flist       : TStrings;
    fvisible    : Boolean;
    FCurrent    : Boolean;
    FSelected   : Boolean;
    fwidth      : integer;
    ffont       : TFont;

  public
    constructor Create(Collectioni: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Selected : Boolean read FSelected write FSelected;
    property Current  : Boolean read FCurrent  write FCurrent;
    property Index;
    procedure delete(Indexi: integer);
  protected
     procedure SetString(AValue: TStrings); virtual;
     procedure listchange(Sender: TObject);
  published
    property Caption   : String      read FCaption   write FCaption;
    property Visible   : Boolean     read fvisible   write fvisible default true;
    property Items     : TStrings    read Flist      write SetString;
    property Width     : integer     read fwidth     write fwidth;
    property Font      : TFont       read ffont      write ffont;

  end;

  { TOlistItems }

  TOlistItems = class(TOwnedCollection)
  private

    function GetItem(Indexi: Integer): TOlistItem;
    procedure SetItem(Indexi: Integer; const Value: TOlistItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClassi: TCollectionItemClass);
    function Add: TOlistItem;
    procedure Clear;
    procedure Delete(Indexi: Integer);
    function Insert(Indexi: Integer): TOlistItem;
    function IndexOf(Value: TOlistItem): Integer;
    property Items[Indexi: Integer]: TOlistItem read GetItem write SetItem; default;

  end;

 {  TOListColumns = class(TOwnedCollection)
  private

    function GetItem(Index: Integer): TOlistItem;
    procedure SetItem(Index: Integer; const Value: TOlistItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClassi: TCollectionItemClass);
    function Add: TOlistItem;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TOlistItem;
    function IndexOf(Value: TOlistItem): Integer;
    property Items[Index: Integer]: TOlistItem read GetItem write SetItem; default;

  end;
  }
  TOnDeleteItem = procedure(Sender: TObject) of object;
  TOnCellClick = procedure(Sender: TObject;Column:TOlistItem) of object;
  ToStatelist = (fnormal,fwarning,fconfirmation);
  TOlist = class(TOCustomControl)
  private
    fheaderfont            : Tfont;
    Fstatelist             : ToStatelist;
    FListItems             : TOlistItems;
    fItemscount            : integer;
//    Fcolunmsitems          : TOlistItems;
    FItemOffset            : Integer;
    FItemhOffset           : integer;
    vscroll                : ToScrollBar;
    FItemsShown            : SmallInt;
    FFocusedItem           : Integer;
    FItemHeight            : integer;
    FheaderHeight          : integer;
    fgridwidth             : integer;
    fgridlines             : Boolean;
    FAutoHideScrollBar     : Boolean;
    fheadervisible         : Boolean;
    fmodusewhelll          : Boolean;
    fcolumindex            : integer;
    Fobdown                : Tocolor;
    Fobenter               : Tocolor;
    Fobleave               : Tocolor;
    Ffdisabled             : Tocolor;
    fselectcolor           : TColor;
    fgridcolor             : Tcolor;
    fheadercolor           : Tcolor;
    fitemcolor             : Tcolor;
    fbackgroundvisible     : Boolean;
    ScrollBar              : TOScrollBar;
    FItemDblClick          : TNotifyEvent;
    FItemEnterKey          : TNotifyEvent;
    FOnDeleteItem          : TOnDeleteItem;
    FOnCellclick           : TOnCellClick;

    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    Function Getcells(Acol, Arow: Integer): String;
    function Getgridview: Boolean;
    Procedure Setbuttondisable(Avalue: Tocolor);
    Procedure Setbuttondown(Avalue: Tocolor);
    Procedure Setbuttonenter(Avalue: Tocolor);
    Procedure Setbuttonleave(Avalue: Tocolor);
    Procedure Setcells(Acol, Arow: Integer; Avalue: String);
    procedure SetGridview(AValue: Boolean);
    procedure SetItems(Value: TOlistItems);
    function ItemRect(Item: Integer): TRect;
    Function GetItemAt(Pos: TPoint): Integer;
    procedure ScrollBarChange(Sender: TObject);
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure HScrollBarChange(Sender: TObject);
  protected
    procedure Paint; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
//    procedure ClearSelection(RepaintAll: Boolean = False);
//    procedure SelectAll;
    procedure Clear;
    procedure MoveUp;
    procedure MoveDown;
    procedure MoveHome;
    procedure MoveEnd;
//    procedure FindItem(Texti: String);
    procedure Delete(indexi: integer);
    property  Cells[ACol, ARow: Integer]: string read GetCells write SetCells;

  published
    property OnCellClick           : TOnCellClick   read FOnCellclick          write FOnCellclick;
    property Columns               : TOlistItems    read FListItems            write SetItems;
    property ItemIndex             : Integer        read FFocusedItem          write FFocusedItem;
    property Itemscount            : Integer        read FItemscount;//           write FFocusedItem;
    property Backgroundvisible     : Boolean        read fbackgroundvisible    write fbackgroundvisible;
    property Columindex            : Integer        read fcolumindex           write fcolumindex;
    property ItemHeight            : Integer        read FItemHeight           write FItemHeight;
    property Itemcolor             : Tcolor         read fitemcolor            write fitemcolor;
    property Itemstate             : ToStatelist    read Fstatelist            write Fstatelist;
    property HeaderHeight          : Integer        read FheaderHeight         write FheaderHeight;
    property Gridwidth             : Integer        read fgridwidth            write fgridwidth;
    property Gridbordercolor       : TColor         read fgridcolor            write fgridcolor;
    property Gridview              : Boolean        read Getgridview           write SetGridview;
    property Selectedcolor         : Tcolor         read fselectcolor          write fselectcolor;
    property Headercolor           : Tcolor         read fheadercolor          write fheadercolor;
    property Headervisible         : Boolean        read fheadervisible        write fheadervisible;
    property Headerfont            : TFont          read fheaderfont           write fheaderfont;
    property AutoHideScrollBar     : Boolean        read FAutoHideScrollBar    write FAutoHideScrollBar;
    property OnItemDblClick        : TNotifyEvent   read FItemDblClick         write FItemDblClick;
    property OnItemEnterKey        : TNotifyEvent   read FItemEnterKey         write FItemEnterKey;
    property OnDeleteItem          : TOnDeleteItem  read FOnDeleteItem         write FOnDeleteItem;
    property VertialScroll         : ToScrollBar    read ScrollBar             write ScrollBar;
    property HorizontalScroll      : ToScrollBar    read vscroll               write vscroll;

    property ButtonEnter           : Tocolor        read fobenter              write SetButtonenter;
    property ButtonLeave           : Tocolor        read fobleave              write SetButtonLeave;
    property ButtonDown            : Tocolor        read fobdown               write SetButtonDown;
    property ButtonDisable         : Tocolor        read ffdisabled            write SetButtonDisable;
    property Anchors;
    property Font;
    property OnDblClick;
    property TabOrder;
    property TabStop;
    property Visible;
  end;


  { TOnurCellStrings }

  TOnurCellStrings = class
  private
    FCells: array of array of string;
    FSize: TPoint;
    function GetCell(X, Y: integer): string;
    function GetColCount: integer;
    function GetRowCount: integer;
    procedure SetCell(X, Y: integer; AValue: string);
    procedure SetColCount(AValue: integer);
    procedure SetRowCount(AValue: integer);
    procedure SetSize(AValue: TPoint);
    procedure Savetofile(s: string);
    procedure Loadfromfile(s: string);
  public
    procedure Clear;
    function arrayofstring(col: integer; aranan: string): integer;
    property Cells[Col, Row: integer]: string read GetCell write SetCell;
    property ColCount: integer read GetColCount write SetColCount;
    property RowCount: integer read GetRowCount write SetRowCount;
    property Size: TPoint read FSize write SetSize;
  end;


  { Tostringgrid }
  TOnCellClickSG = procedure(Sender: TObject;Column:integer) of object;

  Tostringgrid= class(ToCustomControl)
  private
   // FBackground: Tocolor;
    ffdisabled: Tocolor;
    fobdown: Tocolor;
    fobenter: Tocolor;
    fobleave: Tocolor;
    FItemHeight:integer;
    FItemhOffset:Integer;
    FItemvOffset:Integer;
    fcolwidth:integer;
    fcolvisible:integer;
    fscroll:ToScrollBar;
    yscroll:ToScrollBar;
    
    FOnCellclick           : TOnCellClickSG;

    fItemscount            : integer;
    FItemsvShown           : integer;
    FItemsHShown           : integer;
    FFocusedItem           : Integer;
    FheaderHeight          : integer;
    fgridwidth             : integer;
    fgridlines             : Boolean;
    FAutoHideScrollBar     : Boolean;
    fheadervisible         : Boolean;
    fmodusewhelll          : Boolean;
    fcolumindex            : integer;
    fselectcolor           : TColor;
    fgridcolor             : Tcolor;
    fheadercolor           : Tcolor;
    fitemcolor             : Tcolor;
    fbackgroundvisible     : Boolean;

    FCells: array of array of string;
    FcolwitdhA :array of integer;
    FSize: TPoint;


    function GetColWidths(aCol: Integer): Integer;
    function GetItemAt(Pos: TPoint): Integer;
    procedure SetBackground(AValue: Tocolor);
    procedure SetButtonDisable(AValue: Tocolor);
    procedure SetButtonDown(AValue: Tocolor);
    procedure SetButtonenter(AValue: Tocolor);
    procedure SetButtonLeave(AValue: Tocolor);
    procedure SetColWidths(aCol: Integer; AValue: Integer);
    procedure VscrollBarChange(Sender: Tobject);
    procedure HScrollBarChange(Sender: TObject);


    function GetCell(X, Y: integer): string;
    function GetColCount: integer;
    function GetRowCount: integer;

    procedure SetColCount(AValue: integer);
    procedure SetRowCount(AValue: integer);
    procedure SetSize(AValue: TPoint);
  protected

    procedure SetCell(X, Y: integer; AValue: string); virtual;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;


  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure SaveToFile(s: string);
    procedure LoadFromFile(s: string);

    procedure Clear;
    function Searchstring(col: integer; Search: string): integer;
    property Cells[Col, Row: integer]: string read GetCell write SetCell;
    property ColCount: integer read GetColCount write SetColCount;
    property RowCount: integer read GetRowCount write SetRowCount;
    property Size: TPoint read FSize write SetSize;

    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property ColWidths[aCol: Integer]: Integer       read GetColWidths    write SetColWidths;


  published
    property ItemHeight            : integer         read FItemHeight     write FItemHeight;
    Property VScrollbar            : ToScrollBar     read fscroll         write fscroll;
    Property HScrollbar            : ToScrollBar     read yscroll         write yscroll;
    property ButtonEnter           : Tocolor         read fobenter        write SetButtonenter;
    property ButtonLeave           : Tocolor         read fobleave        write SetButtonLeave;
    property ButtonDown            : Tocolor         read fobdown         write SetButtonDown;
    property ButtonDisable         : Tocolor         read ffdisabled      write SetButtonDisable;
    property Background            : Tocolor         read FBackground     write SetBackground;
    property Gridcolor             : Tcolor          read fgridcolor      write fgridcolor;
    property GridBordersize        : integer         read fgridwidth      write fgridwidth;
    property GridShow              : Boolean         read fgridlines      write fgridlines;
    property GridWidth             : integer         read fcolwidth       write fcolwidth;
    property Itemscolor            : Tcolor          read fitemcolor      write fItemcolor;
    property Selectedcolor         : Tcolor          read fselectcolor    write fselectcolor;
    property OnCellClick           : TOnCellClickSG  read FOnCellclick    write FOnCellclick;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


   { TOnurStrings }

  TOnurStrings = class
  private
    fparent :Tcontrol;
    FCells: array of string;
    FSize: integer;
    function GetCell(X: integer): string;
    function GetRowCount: integer;
    procedure SetCell(X: integer; AValue: string);
    procedure SetRowCount(AValue: integer);
  public
    constructor Create;
    procedure Insert(index:integer;Avalue:string);
    procedure Add(s: string);
    procedure Savetofile(s: string);
    procedure Loadfromfile(s: string);
    procedure Clear;
    function arrayofstring(aranan: string): integer;
    property Cells[Row: integer]: string read GetCell write SetCell;
    property Count: integer read GetRowCount write SetRowCount;
  end;

   { Totransprentlistbox }

   Totransprentlistbox= class(TGraphicControl)
   private
    FBackground: Tocolor;
    ffdisabled: Tocolor;
    fobdown: Tocolor;
    fobenter: Tocolor;
    fobleave: Tocolor;

    FCells: TOnurStrings;//array of array of string;
    FItemHeight:integer;
    FItemhOffset:Integer;
    FItemOffset:Integer;
    fcolwidth:integer;
    fcolvisible:integer;
    fscroll:ToScrollBar;
    yscroll:ToScrollBar;
    procedure SetBackground(AValue: Tocolor);
    procedure SetButtonDisable(AValue: Tocolor);
    procedure SetButtonDown(AValue: Tocolor);
    procedure SetButtonenter(AValue: Tocolor);
    procedure SetButtonLeave(AValue: Tocolor);
    procedure VscrollBarChange(Sender: Tobject);
    procedure HScrollBarChange(Sender: TObject);
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    property Items: TOnurStrings read Fcells write FCells;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
  published
    property ItemHeight            : integer       read FItemHeight     write FItemHeight;
    Property Scrollbar             : ToScrollBar   read fscroll         write fscroll;
    Property HScrollbar            : ToScrollBar   read yscroll         write yscroll;
    property ButtonEnter           : Tocolor       read fobenter        write SetButtonenter;
    property ButtonLeave           : Tocolor       read fobleave        write SetButtonLeave;
    property ButtonDown            : Tocolor       read fobdown         write SetButtonDown;
    property ButtonDisable         : Tocolor       read ffdisabled      write SetButtonDisable;
    property Background            : Tocolor       read FBackground     write SetBackground;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;




  { Totransprentlist }

  Totransprentlist= class(TGraphicControl)
    private
      FCells: array of array of string;
      FSize: TPoint;
      fitemindex : Integer;
      FItemHeight:integer;
      FItemhOffset:Integer;
      FItemsvShown : integer;
      FItemsHShown : integer;
      FItemvOffset:Integer;
      fcolwidth:integer;
      fcolvisible:integer;
      fscroll:ToScrollBar;
      yscroll:ToScrollBar;
      Fselectedcolor:Tcolor;
      procedure VScrollBarChange(Sender: Tobject);
      function GetCell(X, Y: Integer): string;
      function GetColCount: Integer;
      function GetItemAt(Pos: TPoint): integer;
      function GetItemIndex: integer;
      function GetRowCount: Integer;

      procedure SetCell(X, Y: Integer; AValue: string);
      procedure SetColCount(AValue: Integer);
      Procedure Setcolwidth(Const Avalue: Integer);
      procedure SetItemIndex(Avalue: integer);
      procedure SetRowCount(AValue: Integer);
      procedure SetSize(AValue: TPoint);
      procedure HScrollBarChange(Sender: TObject);
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;

  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    property Cells[Col,Row : Integer]: string read GetCell write SetCell;
    property Size: TPoint read FSize write SetSize;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
  published
    property ItemHeight    : integer     read FItemHeight    write FItemHeight;
    property Itemindex     : integer     read GetItemIndex   write SetItemIndex;
    property ColCount      : Integer     read GetColCount    write SetColCount;
    property RowCount      : Integer     read GetRowCount    write SetRowCount;
    property Colwidth      : Integer     read fcolwidth      write SetColwidth;
    Property Scrollbar     : ToScrollBar read fscroll        write fscroll;
    Property HScrollbar    : ToScrollBar read yscroll        write yscroll;
    property NoVisiblecol  : integer     read fcolvisible    write fcolvisible;
    property SelectedColor : Tcolor      read Fselectedcolor write Fselectedcolor;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

type

  { TOlabel }

  TOlabel = class(TGraphicControl)
  private
    { Private declarations }
    FBitmap     : TPortableNetworkGraphic;//TBitmap;
    Flist       : Tstrings;
    FPicture    : TPortableNetworkGraphic;
    FTimer      : TTimer;
    FInterval   : Cardinal;
    FActive     : Boolean;
    FStretch    : Boolean;
    FScrollBy   : Integer;
    FCurPos     : Integer;
    FWait       : Integer;
    FWaiting    : Boolean;
 //   Fmousemm    : Boolean;
    FCaption    : TCaption;
    FScale      : Real;
    fCharWidth,fCharHeight:integer;
    ftransparent:Boolean;

    Procedure Getbmp;
    Function  GetScrollBy:Integer;
    procedure SetActive(Value : Boolean);
    Procedure Setcaption(Value: TTranslateString);
    procedure SetStretch(Value : Boolean);
    procedure SetInterval(Value : Cardinal);
    procedure SetPicture(Value : TPortableNetworkGraphic);//Picture);
    procedure Activate;
    procedure Deactivate;
    procedure UpdatePos;
    procedure DoOnTimer(Sender : TObject);
    procedure SetCharWidth(value:integer);
    procedure SetCharHeight(value:integer);
    procedure SetTransparent(const value:boolean);
     procedure SetString(AValue: TStrings); virtual;
     procedure listchange(Sender: TObject);
  public
    { Public declarations }
    constructor create(AOwner: TComponent);override;
    destructor destroy; override;
    procedure paint; override;



  published
    { Published declarations }
    property Strings    : TStrings    read Flist      write SetString;
    property Active     : Boolean read FActive write SetActive;
    property Stretch    : Boolean read FStretch write SetStretch;
    property ScrollBy   : Integer read GetScrollBy write FScrollBy;
    property Interval   : Cardinal read FInterval write SetInterval;
    property CharHeight  : integer read fCharHeight write SetCharHeight default 75;
    property CharWidth   : integer read fCharWidth write SetCharWidth default 44;
    property WaitOnEnd  : Integer read FWait write FWait;
    property SkinBitmap : TPortableNetworkGraphic read FPicture write SetPicture;// TPicture read FPicture write SetPicture;
    property Align;
    property Transparent : boolean    read fTransparent     write SetTransparent default True;
    property Caption   : TCaption      read FCaption   write SetCaption;
//    property Caption;
    property ParentColor;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

  end;

  { TONNormalLabel }
  TTextDirection = (tdLeftToRight, tdRightToLeft);
  TTextStylee = (tsPingPong, tsScroll);

  TONormalLabel = class(TGraphicControl)
  private
    clr        : Tcolor;
    FBuffer    : TBitmap;//TPortableNetworkGraphic;
    FText      : string;
    FAnimate   : boolean;
    fbilink    : boolean;
    fbilinki   : boolean;
    fblinktimer: TTimer;
    FTimer     : TTimer;
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


//    procedure DrawFontTextcolor(incolor, outcolor: TColor);
    function GetScroll: integer;
    function GetTextDefaultPos: smallint;
    procedure SetAnimate(AValue: boolean);
    procedure SetBilink(AValue: boolean);
    procedure Setblinkinterval(AValue: integer);
    procedure Setclr(AValue: Tcolor);
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
    property Color;
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

 { TOKnob }

 TOKnob = class(TOGraphicControl)//Customcontrol)
  private
    FClick: Boolean;
    FPos: Integer;
    FValue: Integer;
    FInit: Integer;
    FMaxValue: Integer;
    FMinValue: Integer;
    FStep: Integer;
    FScroolStep: Integer;
    fstate: Tobutonstate;
    FOnChange: TNotifyEvent;
    obenter, obleave, obdown, obdisabled: ToColor;
    procedure SetMaxValue(const aValue: Integer);
    procedure SetMinValue(const aValue: Integer);
  protected
    procedure cmonmouseleave(var messages: tmessage);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure SetValue(const aValue: Integer);
    procedure DoOnChange; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Paint;override;

  published
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property MinValue: Integer read FMinValue write SetMinValue;
    property Step: Integer read FStep write FStep;
    property ScroolStep: Integer read FScroolStep write FScroolStep;
    property CurrentValue: Integer read FValue write SetValue;
    property ColorEnter: Tocolor read obenter write obenter;
    property ColorLeave: Tocolor read obleave write obleave;
    property ColorDown: Tocolor read obdown write obdown;
    property ColorDisable: Tocolor read obdisabled write obdisabled;
    property Transparent;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;


  type
  TSimbaEdit = class(TCustomControl)
  protected
  type
    {$SCOPEDENUMS ON}
    EPaintCache = (TEXT, CARET_VISIBLE, SEL_START, SEL_END);
    {$SCOPEDENUMS OFF}
  public
    FTextWidthCache: array[EPaintCache] of record
      Str: String;
      Width: Integer;
    end;

    FCaretTimer: TTimer;
    FCaretX: Integer;
    FCaretFlash: Integer;

    FDrawOffsetX: Integer;

    FSelecting: Boolean;
    FSelectingStartX: Integer;
    FSelectingEndX: Integer;

    FHintText: String;
    FHintTextColor: TColor;
    FHintTextStyle: TFontStyles;

    FColorBorder: TColor;
    FColorBorderActive: TColor;
    FColorSelection: TColor;

    FOnChange: TNotifyEvent;

    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;

    procedure DoCaretTimer(Sender: TObject);

    procedure ClearCache;

    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer; WithThemeSpace: Boolean); override;
    function GetTextWidthCache(const Cache: EPaintCache; const Str: String): Integer;

    procedure SelectAll;
    procedure ClearSelection;
    function GetSelectionLen: Integer;
    function HasSelection: Boolean;
    function CharIndexAtXY(X, Y: Integer): Integer;
    function CalculateHeight: Integer;

    function GetAvailableWidth: Integer;
    function GetSelectedText: String;

    procedure AddCharAtCursor(C: Char);
    procedure AddStringAtCursor(Str: String; ADeleteSelection: Boolean = False);
    procedure DeleteCharAtCursor;
    procedure DeleteSelection;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ParentFontChanged; override;

    procedure FontChanged(Sender: TObject); override;
    procedure TextChanged; override;
    procedure Paint; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;

    procedure SetCaretPos(Pos: Integer);
    procedure SetColor(Value: TColor); override;
    procedure SetColorBorder(Value: TColor);
    procedure SetColorSelection(Value: TColor);
    procedure SetColorBorderActive(Value: TColor);

    procedure SetHintText(Value: String);
    procedure SetHintTextColor(Value: TColor);
    procedure SetHintTextStyle(Value: TFontStyles);
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property ColorBorderActive: TColor read FColorBorderActive write SetColorBorderActive;
    property ColorBorder: TColor read FColorBorder write SetColorBorder;
    property ColorSelection: TColor read FColorSelection write SetColorSelection;
    property Color;
    property Font;
    property Text;

    property HintText: String read FHintText write SetHintText;
    property HintTextColor: TColor read FHintTextColor write SetHintTextColor;
    property HintTextStyle: TFontStyles read FHintTextStyle write SetHintTextStyle;
  end;

  TSimbaLabeledEdit = class(TCustomControl)
  protected
    FLabel: TLabel;
    FEdit: TSimbaEdit;

    procedure TextChanged; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Edit: TSimbaEdit read FEdit;
  end;


    function GetDefaultFontSize: Integer;
function GetFontSize(Control: TWinControl; IncAmount: Integer = 0): Integer;
function IsFontFixed(FontName: String): Boolean;
function GetFixedFonts: TStringArray;
function GetDefaultFontName: String;


var
  DefaultFontName: String;
  DefaultFontNameDone: Boolean = False;

procedure Register;
 {$R Balloon.res}
implementation
uses strutils,LazUnicode,Math,IntfGraphics, FPImage, GraphType,LazCanvas,Clipbrd;//,utf8scanner;
{$IFDEF UNIX}uses math;{$ENDIF}

procedure Register;
begin
  RegisterComponents('Standard', [TOlabel]);
  RegisterComponents('Standard', [TONormalLabel]);
  RegisterComponents('Standard', [Tobuton]);
  RegisterComponents('Standard', [Topanel]);
  RegisterComponents('Standard', [TOGraphicPanel]);
  RegisterComponents('Standard', [TCollapExpandpanel]);
  RegisterComponents('Standard', [Toedit]);
  RegisterComponents('Standard', [ToSpinEdit]);
  RegisterComponents('Standard', [Tomemo]);
  RegisterComponents('Standard', [Tocombobox]);
  RegisterComponents('Standard', [Tocheckbox]);
  RegisterComponents('Standard', [ToRadiobutton]);
  RegisterComponents('Standard', [TOProgressBar]);
  RegisterComponents('Standard', [TOTrackBar]);
  RegisterComponents('Standard', [ToScrollBar]);
  RegisterComponents('Standard', [ToBalloonControl]);
  RegisterComponents('Standard', [ToListBox]);
  RegisterComponents('Standard', [ToChecklistbox]);
  RegisterComponents('Standard', [Totransprentlist]);
  RegisterComponents('Standard', [Totransprentlistbox]);
  RegisterComponents('Standard', [TOlist]);
  RegisterComponents('Standard', [Tostringgrid]);
  RegisterComponents('Standard', [TOled]);
  RegisterComponents('Standard', [Toswich]);
  RegisterComponents('Standard', [ToImgswich]);
  RegisterComponents('Standard', [ToImgradio]);
  RegisterComponents('Standard', [TOKnob]);

  RegisterComponents('Standard', [TSimbaEdit]);
    RegisterComponents('Standard', [TSimbaLabeledEdit]);
end;

function GetDefaultFontSize: Integer;
begin
  with TBitmap.Create() do
  try
    Result := Round(Abs(GetFontData(Canvas.Font.Reference.Handle).Height) * 72 / Canvas.Font.PixelsPerInch);
  finally
    Free();
  end;
end;

// Font size can be zero, so this is needed!
function GetFontSize(Control: TWinControl; IncAmount: Integer): Integer;
begin
  Result := Round(Abs(GetFontData(Control.Font.Handle).Height) * 72 / Control.Font.PixelsPerInch) + IncAmount;
end;

function FontIsPitched(var Font: TEnumLogFontEx; var Metric: TNewTextMetricEx; FontType: LongInt; Data: LParam): LongInt; stdcall;
begin
  Result := 1;

  with Font.elfLogFont do
    if (lfPitchAndFamily and FIXED_PITCH) = FIXED_PITCH then
      Result := 0; // Stop enumeration
end;

function FontIsPitchedGetName(var Font: TEnumLogFontEx; var Metric: TNewTextMetricEx; FontType: LongInt; Data: LParam): LongInt; stdcall;
begin
  Result := 1;

  with Font.elfLogFont do
    if (lfPitchAndFamily and FIXED_PITCH) = FIXED_PITCH then
      TStringList(PtrUInt(Data)).Add(lfFaceName);
end;

function IsFontFixed(FontName: String): Boolean;
var
  DC: HDC;
  Font: TLogFont;
begin
  Result := False;
  if (FontName = '') then
    Exit;

  Font := Default(TLogFont);
  Font.lfCharSet := DEFAULT_CHARSET;
  Font.lfFaceName := PChar(FontName);
  Font.lfPitchAndFamily := {$IFDEF LINUX}FIXED_PITCH{$ELSE}0{$ENDIF};

  DC := GetDC(0);
  try
//    Result := EnumFontFamiliesEx(DC, @Font, @FontIsPitched, 0, 0) = 0;
  finally
    ReleaseDC(0, DC);
  end;
end;

function GetFixedFonts: TStringArray;
var
  DC: HDC;
  Font: TLogFont;
  Strings: TStringList;
begin
  Result := nil;

  Strings := TStringList.Create();
  Strings.Sorted := True;
  Strings.Duplicates := dupIgnore;

  try
    Font := Default(TLogFont);
    Font.lfCharSet := DEFAULT_CHARSET;
    Font.lfFaceName := '';
    Font.lfPitchAndFamily := {$IFDEF LINUX}FIXED_PITCH{$ELSE}0{$ENDIF};

    DC := GetDC(0);
    try
  //    EnumFontFamiliesEx(DC, @Font, @FontIsPitchedGetName, PtrUInt(Strings), 0);
    finally
      ReleaseDC(0, DC);
    end;

    Result := Strings.ToStringArray();
  finally
    Strings.Free();
  end;
end;

function GetDefaultFontName: String;
begin
  if DefaultFontNameDone then
    Result := DefaultFontName
  else
  begin
    with TBitmap.Create() do
    try
      DefaultFontName := GetFontData(Canvas.Font.Reference.Handle).Name;
      DefaultFontNameDone := True;

      Result := DefaultFontName;
    finally
      Free();
    end;
  end;
end;



Procedure Ocolortoocolor(Too, From: Tocolor);
begin
 if Assigned(from) and Assigned(too) then
 begin
 too.Border      := from.Border;
 too.Bordercolor := from.Bordercolor;
 too.Fontcolor   := from.Fontcolor;
 too.Startcolor  := from.Startcolor;
 too.Stopcolor   := from.Stopcolor;
 End;
End;

function ValueRange(const Value, Min, Max: integer): integer;
begin
  if Value < Min then
    Result := Min
  else if Value > Max then
    Result := Max
  else
    Result := Value;
end;


procedure DrawTransparentRectangle(Canvas: TCanvas; Rect: TRect;
  Color: TColor; Transparency: integer);
var
  X, Y: integer;
  C: TColor;
  R, G, B: integer;
  RR, RG, RB: integer;
begin
  RR := GetRValue(Color);
  RG := GetGValue(Color);
  RB := GetBValue(Color);
  for Y := Rect.Top to Rect.Bottom - 1 do
    for X := Rect.Left to Rect.Right - 1 do
    begin
      C := Canvas.Pixels[X, Y];
      R := Round(0.01 * (Transparency * GetRValue(C) + (100 - Transparency) * RR));
      G := Round(0.01 * (Transparency * GetGValue(C) + (100 - Transparency) * RG));
      B := Round(0.01 * (Transparency * GetBValue(C) + (100 - Transparency) * RB));
      Canvas.Pixels[X, Y] := RGB(R, G, B);
    end;
end;


procedure ShowCombolistPopup(const APosition: TPoint;
  const OnReturnDate: TReturnStintEvent; const OnShowHide: TNotifyEvent;
  ACaller: Tocombobox);
var
  PopupForm: Tpopupformcombobox;
  a,b:integer;
begin
  b:=ACaller.Height;
 // for a:=0 to ACaller.Items.Count-1 do
 // begin
   b:=b+(ACaller.ItemHeight*ACaller.Items.Count);
 // End;
  PopupForm := Tpopupformcombobox.Create(Application);
  PopupForm.SetBounds(APosition.x,APosition.y,ACaller.Width,b);//150,250);
  PopupForm.BorderStyle:=bsNone;
//  PopupForm.Name:='xyzzyx';
{  PopupForm.Width:=150;
  PopupForm.Height:=250;  }
  PopupForm.FCaller := ACaller;
  PopupForm.FOnReturnDate := OnReturnDate;
  PopupForm.OnShow := OnShowHide;
  PopupForm.OnHide := OnShowHide;
  PopupForm.Show;
  PopupForm.KeepInView(APosition);   // must be after Show for PopupForm.AutoSize to be in effect.



end;

{ TOKnob }

procedure TOKnob.SetMaxValue(const aValue: Integer);
begin
  FMaxValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TOKnob.SetMinValue(const aValue: Integer);
begin
  FMinValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TOKnob.SetValue(const aValue: Integer);
begin
 fvalue:=ValueRange(aValue,FMinValue,FMaxValue);
 Invalidate;
end;

procedure TOKnob.DoOnChange;
begin
 if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TOKnob.cmonmouseleave(var messages: tmessage);
begin

  fstate := obleaves;
  FClick:= False;
  Invalidate;
end;

procedure TOKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FPos:= Y;
  FClick:= True;
  FInit:= FValue;
  fState := obdowns;
end;

procedure TOKnob.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if FClick then
  begin
  SetValue (FInit - (Y - FPos) * FStep);
  DoOnChange;
  end;
end;

procedure TOKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer
  );
begin
  inherited MouseUp(Button, Shift, X, Y);
   FClick:= False;
   fstate := obenters;
end;

function TOKnob.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
 if WheelDelta > 0 then
    SetValue (FValue + FScroolStep)
  else if WheelDelta < 0 then
    SetValue (FValue - FScroolStep);
  Result:=inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;



constructor TOKnob.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
//  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks, csSetCaption];
  backgroundcolored := False;
  self.Width := 50;
  self.Height := 50;
  Caption:= IntToStr(FValue);
  FMaxValue:= +100;
  FMinValue:= -100;
  FStep:= 2;
  FScroolStep:= 5;


  obenter := Tocolor.Create(self);
  with obenter do
  begin
    //Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;



  obleave := Tocolor.Create(self);
  with obleave do
  begin
 //   Aownerr:=self;
    border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdown := Tocolor.Create(self);
  with obdown do
  begin
 //   Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  obdisabled := Tocolor.Create(self);
  with obdisabled do
  begin
    // Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;


end;
destructor TOKnob.destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obdisabled);
  inherited Destroy;
end;



procedure TOKnob.Paint;
var
  x, y: Integer;
  w, h: Integer;
  dialH, dialW: Integer;
  zValue: Integer;
  fborderWidth:integer;
   obstart, obend, checkendstart, checkedend, oborder: Tcolor;



const
  dialRadius = 4;
  offset = 5;
begin
  if csLoading in ComponentState then exit;
  inherited paint;

  if Enabled = False then
  begin
    obstart           := obdisabled.Startcolor;
    obend             := obdisabled.Stopcolor;
    oborder           := obdisabled.Bordercolor;
    fborderWidth      := obdisabled.Border;
    canvas.Font.Color := obdisabled.Fontcolor;
  end
  else
  begin
      case fstate of
        obenters:
        begin
          obstart           := obenter.Startcolor;
          obend             := obenter.Stopcolor;
          oborder           := obenter.Bordercolor;
          fborderWidth      := obenter.Border;
          canvas.Font.Color := obenter.Fontcolor;
        end;
        obleaves:
        begin
          obstart           := obleave.Startcolor;
          obend             := obleave.Stopcolor;
          oborder           := obleave.Bordercolor;
          fborderWidth      := obleave.Border;
          canvas.Font.Color := obleave.Fontcolor;
        end;
        obdowns:
        begin
          obstart           := obdown.Startcolor;
          obend             := obdown.Stopcolor;
          fborderWidth      := obdown.Border;
          oborder           := obdown.Bordercolor;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;
  end;

  w:= Canvas.TextWidth(Caption);
  h:= Canvas.TextHeight(Caption);



  Canvas.Brush.Color:= Background.Startcolor;
  Canvas.Brush.Style:= bsSolid;
  Canvas.Ellipse(ClientRect);

  dialW:= ClientWidth div 2 - offset;
  dialH:= ClientHeight div 2 - offset;


  Canvas.Pen.Color:= Background.Bordercolor;// clBlack;
  Canvas.Pen.Width:= Background.Border;
  Canvas.Ellipse(ClientRect);


  Canvas.Brush.Style:=  bsSolid;
  Canvas.Brush.Color:= obstart;//clRed;



  zValue:= Round (270 / (MaxValue - MinValue) * (FValue - MinValue)) + 45;

  x:= Round (sin(degToRad(-zValue)) * dialW + dialW) + offset;
  y:= Round (cos(degToRad(-zValue)) * dialW + dialW) + offset;

  Canvas.Ellipse(x - dialRadius, y - dialRadius,
    x + dialRadius, y + dialRadius);

  Caption:= IntToStr(FValue);
  Canvas.Brush.Style:= bsClear;
  Canvas.TextOut((ClientWidth - w)div 2, (ClientHeight - h)div 2,  Caption);

end;
{ Totransprentlistbox }


function Totransprentlistbox.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): boolean;
begin
inherited;
 if not fscroll.Visible then exit;
 if FItemOffset =fscroll.max then exit;

 fscroll.Position := fscroll.Position + Mouse.WheelScrollLines;
 FItemOffset := fscroll.Position;
 Result := True;
 Invalidate;
//  fmodusewhelll := False;
end;

function Totransprentlistbox.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
 inherited;
// fmodusewhelll := True;
 if not fscroll.Visible then exit;
 if FItemOffset =0 then exit;
 fscroll.Position := fscroll.Position - Mouse.WheelScrollLines;
 FItemOffset := fscroll.Position;
 Result := True;
 Invalidate;
// fmodusewhelll := False;
end;



constructor Totransprentlistbox.Create(Aowner: TComponent);
Begin
 Inherited Create(Aowner);
  parent := TWinControl(Aowner);
 ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
   csCaptureMouse, csDoubleClicks];
 FCells:=TOnurStrings.Create;
 FBackground:=Tocolor.Create(self);
// FBackground.// Aownerr:=self;
 fobenter:=Tocolor.Create(self);
// fobenter.// Aownerr:=self;
 fobleave:=Tocolor.Create(self);
// fobleave.// Aownerr:=self;
 fobdown:=Tocolor.Create(self);
// fobdown.// Aownerr:=self;
 ffdisabled:=Tocolor.Create(self);
//ffdisabled.// Aownerr:=self;



 FCells.fparent:=self;
 FItemHeight:=15;
 Width:=150;
 Height:=250;
 fcolwidth:=80;
 FItemOffset:=0;
 fcolvisible:=-1;
 FItemhOffset:=0;
 fscroll:=ToScrollBar.Create(nil);
 fscroll.Parent:=Parent;
 fscroll.Kind:=oVertical;
 fscroll.Left:=self.Left+self.Width;
 fscroll.top:=self.top;
 fscroll.Width:=20;
 fscroll.Height:=self.Height;
 fscroll.OnChange:=@VScrollBarChange;
 fscroll.Visible:=false;


 yscroll:=ToScrollBar.Create(nil);
 yscroll.Parent:=Parent;
 yscroll.Kind:=oHorizontal;
 yscroll.Left:=self.Left;
 yscroll.top:=self.top+self.Height;
 yscroll.Width:=self.Width;
 yscroll.Height:=20;
 yscroll.OnChange:=@HScrollBarChange;
 yscroll.Visible:=false;
End;

destructor Totransprentlistbox.Destroy;
Begin
 FCells.free;
 if Assigned(fscroll) then FreeAndNil(fscroll);
 if Assigned(yscroll) then FreeAndNil(yscroll);
 freeandnil(fbackground);
 freeandnil(fobenter);
 freeandnil(fobleave);
 freeandnil(fobdown);
 freeandnil(ffdisabled);
 Inherited Destroy;
End;


procedure Totransprentlistbox.VscrollBarChange(Sender: Tobject);
begin
FItemOffset:=fscroll.Position;
Invalidate;
End;

procedure Totransprentlistbox.SetBackground(AValue: Tocolor);
begin
  if FBackground=AValue then Exit;
  FBackground.border:=AValue.Border;
  FBackground.Startcolor:=AValue.Startcolor;
  FBackground.Stopcolor:=AValue.Stopcolor;
  FBackground.Fontcolor:=AValue.Fontcolor;

end;

procedure Totransprentlistbox.SetButtonDisable(AValue: Tocolor);
begin
  if ffdisabled=AValue then Exit;
  ffdisabled:=AValue;
end;

procedure Totransprentlistbox.SetButtonDown(AValue: Tocolor);
begin
  if fobdown=AValue then Exit;
  fobdown:=AValue;
end;

procedure Totransprentlistbox.SetButtonenter(AValue: Tocolor);
begin
  if fobenter=AValue then Exit;
  fobenter:=AValue;
end;

procedure Totransprentlistbox.SetButtonLeave(AValue: Tocolor);
begin
  if fobleave=AValue then Exit;
  fobleave:=AValue;
end;

procedure Totransprentlistbox.HScrollBarChange(Sender: TObject);
begin
FItemhOffset := yscroll.Position;
Invalidate;
end;




procedure Totransprentlistbox.paint;
var
i,a,b,FItemsShown,fark:integer;
begin
 if Visible=false then exit;
 inherited paint;

 if fcells.GetRowCount > 0 then
 begin
    try

      FItemsShown := self.Height div FItemHeight;

      if fcells.GetRowCount * FItemHeight > self.Height then
       fscroll.Visible := True
      else
       fscroll.Visible := False;

    //  writeln(FItemsShown,'  ',fcells.GetRowCount,'  ',fcells.GetRowCount * FItemHeight,'  ', self.Height);

      if fcells.GetRowCount-FItemsShown+1 > 0 then
      begin
         with fscroll do
         begin
           Width := 25;
           left := self.Left+Self.ClientWidth-25;
           Top := self.top;
           Height := Self.Height;
           Max:= fcells.GetRowCount-FItemsShown;
           Ocolortoocolor(Background,self.Background);
           Ocolortoocolor(ButtonDown,self.ButtonDown);
           Ocolortoocolor(ButtonLeave,self.ButtonLeave);
           Ocolortoocolor(ButtonEnter,self.ButtonEnter);
           Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
         end;
      end;


  {
        fark:=0;
        fark:=(fcells.FSize.X-2)*fcolwidth;

        if (fark>0) and (fark>self.ClientWidth) then
         yscroll.Max :=(fcells.FSize.X-2)-1;

        if fark> self.ClientWidth then
        begin
          yscroll.Visible := True;
          yscroll.Left:=self.Left;
          yscroll.top:=self.top+self.Height;
          yscroll.Width:=self.Width;
        end else
          yscroll.Visible := False;
 }
       a := 15;
       canvas.Brush.Style := bsClear;
       b:=a;
       for i := FItemOffset to (FItemOffset + (Height) div FItemHeight) - 1 do
       begin
           if (i < Fcells.GetRowCount) and (i>-1) then
           begin
               Canvas.TextOut(a, b, Fcells.GetCell(i));
               b := b + FitemHeight;
             if (b >= Height) then Break;
           end;
       end;

   finally

   end;
 end;
end;





{ TOnurStrings }

{ TOnurStrings }

function TOnurStrings.GetCell(X: integer): string;
begin
  Result := FCells[x];
end;

function TOnurStrings.GetRowCount: integer;
begin
  Result := Length(FCells);//FSize;
  // SetLength(FCells,1);
end;

procedure TOnurStrings.SetCell(X: integer; AValue: string);
begin
  if Length(FCells) <= x then
    SetLength(FCells, X);

  if x > 0 then
    FCells[x - 1] := AValue
  else
    FCells[x] := AValue;

  FSize := Length(FCells);

  if Assigned(fparent) then
  fparent.Invalidate;
end;

procedure TOnurStrings.SetRowCount(AValue: integer);
begin
  if (Length(FCells) >= AValue) then Exit;
  SetLength(FCells, AValue);
  FSize := AValue;
end;

constructor TOnurStrings.Create;
begin
  FSize := 0;
  SetLength(FCells, 0);
end;

procedure TOnurStrings.Insert(index: integer; Avalue: string);
var
  Temp : string;
  CurIndex,NewIndex:integer;
begin
  SetCell(FSize + 1, Avalue);
  CurIndex:=Length(FCells)-1;
  NewIndex:=index;

  Temp := FCells[CurIndex];

//   ShowMessage('ok '+temp);

  if NewIndex > CurIndex then
    System.Move(FCells[CurIndex+1], FCells[CurIndex], (NewIndex - CurIndex) * SizeOf(Pointer))
  else
    System.Move(FCells[NewIndex], FCells[NewIndex+1], (CurIndex - NewIndex) * SizeOf(Pointer));

  FCells[NewIndex] := Temp;



  if Assigned(fparent) then
  fparent.Invalidate;
end;


procedure TOnurStrings.Add(s: string);
begin
  SetCell(FSize + 1, s);
end;

procedure TOnurStrings.Savetofile(s: string);
var
  i: integer;
  s1: TStringList;
begin
  s1 := TStringList.Create;
  for i := 0 to Count - 1 do
    s1.Add(FCells[i]);
  s1.SaveToFile(s);
  FreeAndNil(s1);

end;


procedure TOnurStrings.Loadfromfile(s: string);
var
  i: integer;
  s1: TStringList;
begin
  s1 := TStringList.Create;
  s1.LoadFromFile(s);
  for i := 0 to s1.Count - 1 do
    add(s1[i]);

  FreeAndNil(s1);
end;

procedure TOnurStrings.Clear;
begin
  FSize := 0;
  SetLength(FCells, 0);
end;

function TOnurStrings.arrayofstring(aranan: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Length(FCells) - 1 do
  begin
    if FCells[i] = aranan then
    begin
      Result := i;
      break;
    end;
  end;
end;


{ TOlabel }

Function Tolabel.Getscrollby: Integer;
Begin
  Result:=ABS(FScrollBy);
End;

Procedure Tolabel.Setactive(Value: Boolean);
Begin
  IF Value <> FActive then
  Begin
    FActive:=Value;
    IF FActive then
     Begin
       Activate;
     end
    else Deactivate;
    FWaiting:=False;
  end;
End;

Procedure Tolabel.Setcaption(Value: Ttranslatestring);
Begin
  If fcaption=value Then Exit;
  fcaption:=value;
  Getbmp;
  Invalidate;
End;

Procedure Tolabel.Setstretch(Value: Boolean);
Var
 Rec : TRect;
begin
 IF Value <> FStretch then
  Begin
    FStretch:=Value;
     Rec.Top:=0; Rec.Left:=0; Rec.Bottom:=Height; Rec.Right:=Width;
     Canvas.Brush.Color:=Color;
     Canvas.Brush.Style:=bsSolid;
     Canvas.FillRect(Rec);
     Paint;
  end;
  IF Not FStretch then FScale:=1;

End;

Procedure Tolabel.Setinterval(Value: Cardinal);
Begin
  IF Value <> FInterval then
  Begin
    FInterval:=Value;
    FTimer.Interval:=Value;
  end;
End;

Procedure Tolabel.Setpicture(Value: Tportablenetworkgraphic);
Begin
  FPicture.Assign(Value);
 // IF (FPicture.Bitmap.Width<>155) or (FPicture.Bitmap.Height<>18) then
 //  ShowMessage('Dimensions not valid. Not valid Winamp Skin Text!');
 // FCaption:='';
 Getbmp;
 Invalidate;
End;


Procedure Tolabel.Activate;
Begin
 FActive:=True;
 FTimer.Enabled:=True;
 FTimer.Interval:=FInterval;
 FWaiting:=False;

 FCurPos:=0;
 FScrollBy:=ABS(FScrollBy);
// FillBitMap;
 Getbmp;
End;

Procedure Tolabel.Deactivate;
Begin
  FTimer.Enabled:=False;
  FActive:=False;
  Invalidate;
End;

Procedure Tolabel.Updatepos;
begin
If (Length(Caption)*CharWidth)*FScale > Self.Width then
   Begin
     FCurPos:=FCurPos+FScrollBy;
     IF FCurPos <= 0 then
      Begin
        FScrollBy:=Abs(FScrollBy);
        IF FWait<>0 then
         Begin
           FWaiting:=True;
           FTimer.Interval:=FWait;
         end;
      end;

     IF (Length(Caption)*CharWidth{(FBitMap.Width)}-(FCurPos)) <= (Self.Width/FScale) then
      Begin
       FScrollBy:=Abs(FScrollBy)*-1;
       IF FWait<>0 then
         Begin
           FWaiting:=True;
           FTimer.Interval:=FWait;
         end;
      end;
   end Else FCurPos:=0;


End;

Procedure Tolabel.Doontimer(Sender: Tobject);
Begin
  IF FWaiting then
   Begin
    FTimer.Interval:=FInterval;
    FWaiting:=False;
   end;

  UpDatePos;
  Invalidate;
End;

Procedure Tolabel.Setcharwidth(Value: Integer);
Begin
  if Value=CharWidth then exit;
 fCharWidth:=Value;
 Getbmp;
 Invalidate;
End;

Procedure Tolabel.Setcharheight(Value: Integer);
Begin
  if Value=CharHeight then exit;
 fCharHeight:=Value;
 Getbmp;
 Invalidate;
End;

Procedure Tolabel.Settransparent(Const Value: Boolean);
Begin
   if ftransparent = Value then
    exit;
  if Value then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
End;

Procedure Tolabel.Setstring(Avalue: Tstrings);
Begin
 if Flist=AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
End;

Procedure Tolabel.Listchange(Sender: Tobject);
Begin
 Getbmp;
End;

Constructor Tolabel.Create(Aowner: Tcomponent);
Begin
 inherited Create(AOwner);

//  AutoSize:=False;
  FInterval:=100;
 // AutoSize:=false;
  FPicture:=TPortableNetworkGraphic.create;
  FBitmap:=TPortableNetworkGraphic.Create;
  FPicture.PixelFormat:=pf32bit;
  fbitmap.PixelFormat:=pf32bit;
  fbitmap.TransparentColor:=clBlack;
  fbitmap.Transparent:=true;
  fbitmap.TransparentMode:=tmAuto;

  //FCaption:='';
  fCharWidth:= 44;
  fCharHeight:= 75;
  Width:=100;
  Height:=fCharHeight*2;
  FScale:=1;

  FStretch:=True;
  FScrollBy:=2;
  FWait:=1000;
  Color:=clNone;

  Flist:=TStringList.Create;

  FTimer:=TTimer.Create(nil);
  With FTimer do
   Begin
    Enabled:=False;
    Interval:=FInterval;
    OnTimer:=@DoOnTimer;
   end;
  FActive:=False;
  Activate;
End;

Destructor Tolabel.Destroy;
Begin
 Deactivate;
 FBitmap.Free;
 FPicture.Free;
 FTimer.Free;
 Flist.free;
 inherited Destroy;
End;






Procedure Tolabel.Getbmp;//:Trect;
var
i,w,h,a,n:integer;
place:word;
tmpText: {$IFDEF FPC}AnsiString{$ELSE}String{$ENDIF};
s, ch: String;
cpIter: TCodePointEnumerator;
ucIter: TUnicodeCharacterEnumerator;

{  const
  Row1 :AnsiString = 'ABCDEFGHIJKLMNOPRSTUVYZ';// String[29] = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
  Row2 :AnsiString = '0123456789.:<> '; //String[29] = '0123456789.:<> ';
  Row3 :AnsiString = 'ÇĞİÖŞÜ';// String[29] = '';
}

begin

  FBitmap.Clear;
 if self.Caption='' then exit;

{ If Caption<>'' then
   FBitMap.Width:=(Length(self.Caption)*CharWidth)
   else FBitMap.Width:=Self.Width;

   FBitmap.Height:=CharHeight;
}
//   IF FBitMap.Width < Self.Width then
//     FBitmap.Width:=Self.Width;


   tmpText:=self.Caption;
   s:=ansiuppercase(tmpText);

//    FBitmap.SetSize(Length(s)*CharWidth,CharHeight);

   i:=0;
  for ch in s do
  begin
    w:=0;
    h:=0;
    a:=0;
    for n:=0 to Flist.Count-1 do
    begin
      ucIter := TUnicodeCharacterEnumerator.Create(Flist[n]);
      while ucIter.MoveNext do
      begin
        if ch=ucIter.Current then
        begin
          w:=a*CharWidth;
          h:=n*CharHeight;
        End;
        Inc(a);
      End;
    ucIter.Free;
    a:=0;
    End;
    FBitmap.SetSize((i*CharWidth)+CharWidth,CharHeight);
    FBitmap.Canvas.CopyRect(Rect((i*CharWidth),0,(i*CharWidth)+CharWidth,CharHeight),FPicture.Canvas,Rect(w,h,w+CharWidth,h+CharHeight));
    inc(i);
  end;
End;

Procedure Tolabel.Paint;
 begin
  if color<> clnone then
  begin
   Canvas.Brush.Color:=self.color;
   canvas.FillRect(ClientRect);
  end;

  IF not FStretch then
   Begin
    IF FActive then
      canvas.Draw(-FCurPos,0,FBitmap)
    //  BitBlt(Canvas.Handle,0,0,Width,CharHeight,FBitmap.Canvas.Handle,FCurPos,0,SrcCopy)
    else
     Begin
   //  BitBlt(Canvas.Handle,0,0,Width,CharHeight,FBitmap.Canvas.Handle,0,0,SRCPAINT);
      canvas.Draw(0,0,FBitmap);
     end;
   end
  Else
  Begin
    FScale:=Height/CharHeight;
     IF FActive then

     // canvas.CopyRect(rect(0,0,Width,Height),fbitmap.canvas,Rect(FCurPos,0,FCurPos+Width,CharHeight))
       StretchBlt(Canvas.Handle,0,0,Width,Height,FBitmap.Canvas.Handle,FCurPos,0,Round(Width/FScale),CharHeight,SrcCopy)
     else
   //  canvas.StretchDraw(rect(0,0,Width,Height){Rect(0,0,Round(Width/FScale),CharHeight)},fbitmap);//
     canvas.CopyRect(Rect(0,0,self.Width,self.Height),FBitmap.Canvas,Rect(0,0,FBitmap.Width,FBitmap.Height));//Round(Width/FScale),CharHeight))
    //  StretchBlt(Canvas.Handle,0,0,Width,Height,FBitmap.Canvas.Handle,0,0,Round(Width/FScale),CharHeight,SrcCopy);
  end;
End;



{ TONNormalLabel }

function TONormalLabel.GetScroll: integer;
begin
 Result := ABS(FScrollBy);
end;

function TONormalLabel.GetTextDefaultPos: smallint;
begin
 if (FBuffer.Width<self.ClientWidth) then
   Result := (self.ClientWidth - FBuffer.Width) div 2
   else
   Result :=0;
end;

procedure TONormalLabel.SetAnimate(AValue: boolean);
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
    ftimer := TTimer.Create(Self);
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

procedure TONormalLabel.SetBilink(AValue: boolean);
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

procedure TONormalLabel.Setblinkinterval(AValue: integer);
begin
 if fblinkinterval=AValue then Exit;
  fblinkinterval:=AValue;
  fblinktimer.Interval:=AValue;
end;

procedure TONormalLabel.Setclr(AValue: Tcolor);
begin
  if clr = AValue then Exit;
  clr := AValue;
end;

procedure TONormalLabel.SetScrollBy(AValue: integer);
begin
 if FScrollBy = AValue then exit;
  FScrollBy := AValue;
end;

procedure TONormalLabel.SetText(AValue: string);
begin
  FText := AValue;
  DrawFontText;
  FPos := GetTextDefaultPos;
  FDirection := tdLeftToRight;
  FWait := Fwaiting;// Waiting;
  Invalidate;
end;

procedure TONormalLabel.Settimerinterval(AValue: integer);
begin
 if ftimerinterval=AValue then Exit;
  ftimerinterval:=AValue;
  if (fAnimate) and Assigned(ftimer) then
    FTimer.Interval := ftimerinterval;//100;
end;

procedure TONormalLabel.Setwaiting(AValue: byte);
begin
 if Fwaiting=AValue then Exit;
  Fwaiting:=AValue;
end;

procedure TONormalLabel.SetYazibuyuk(AValue: boolean);
begin
 if fyazibuyuk=AValue then Exit;
  fyazibuyuk:=AValue;
end;

procedure TONormalLabel.TimerEvent(Sender: TObject);
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

procedure TONormalLabel.DrawFontText;
var
b:Tcolor;
begin
  FBuffer.SetSize(0, 0);
  FBuffer.canvas.Font := self.font;
  FBuffer.SetSize(FBuffer.canvas.TextExtent(FText).cx, self.ClientHeight);
  if self.font.Color<>clBlack then
   b:=clBlack
  else
   b:=clwhite;

  FBuffer.Canvas.Brush.Color:=b;
  FBuffer.Canvas.FillRect(0,0,FBuffer.Width,FBuffer.Height);
  FBuffer.TransparentColor := b;
  FBuffer.Transparent := True;
 // FBuffer.Canvas.Brush.Style := bsClear;
  //FBuffer.Canvas.Pen.Color := clRed;
  FBuffer.Canvas.Brush.Color:=self.font.color;
  FBuffer.canvas.TextRect(FBuffer.Canvas.ClipRect,0,0,FText);


  if FBuffer.Width> self.Width then
   fyazibuyuk:=true
  else
   fyazibuyuk:=false;
end;




procedure TONormalLabel.FreeTimer;
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
    FTimer := nil;
  end;
end;

procedure TONormalLabel.Blinktimerevent(sender: TObject);
begin
   fbilink:= not fbilinki;
  fbilinki:= not fbilinki;
  if FAnimate=false then
  Invalidate;
end;

procedure TONormalLabel.Loaded;
begin
  inherited Loaded;
    DrawFontText;
end;

procedure TONormalLabel.Paint;
begin
  inherited Paint;
    if fbilink then
  begin
    canvas.Brush.Color := clr;
    canvas.FillRect(ClientRect);
  end;

    self.Canvas.Draw(fpos,0,FBuffer);
end;

constructor TONormalLabel.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  Width                 := 150;
  Height                := 30;
  FBuffer               := TBitmap.Create;//TPortableNetworkGraphic.Create;
  FBuffer.SetSize(150,30);
  FBuffer.Transparent := True;
  FTimer                := nil;
  FDirection            := tdLeftToRight;
  FStyle                := tsPingPong;
  FAnimate              := False;
  FText                 := 'ONORMALLABEL';
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

destructor TONormalLabel.Destroy;
begin
    FreeTimer;
  if fblinktimer.Enabled then fblinktimer.Enabled:=false;

  FreeAndNil(fblinktimer);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;


{ Totransprentlist }
 
function Totransprentlist.GetCell(X, Y: Integer): string;
Begin
   Result := FCells[Y, X];
End;

function Totransprentlist.GetColCount: Integer;
Begin
  Result := FSize.X;
End;

{
Function Totransprentlist.Getcolwidth: Integer;
Begin
 Result:=fcolwidth;
End;
}

function Totransprentlist.GetRowCount: Integer;
Begin
  Result := FSize.Y;
End;

procedure Totransprentlist.SetCell(X, Y: Integer; AValue: string);
Var
  i,p:integer;
Begin
  i:=FSize.X;
  p:=FSize.y;
  if x>=i then
  Inc(i);
  if y>=p then
  inc(p);
  SetSize(point(i,p));


  FCells[Y, X] := AValue;


  FItemsvShown := self.ClientHeight div FItemHeight;
  FItemsHShown := self.ClientWidth div fcolwidth;//FItemHeight;



  if fsize.y * FItemHeight > self.Height then
   fscroll.Visible := True
  else
   fscroll.Visible := False;



  if fsize.y-FItemsvShown+1 > 0 then
  begin
     with fscroll do
     begin
       Width := 25;
       left := self.Left+Self.ClientWidth;
       Top := self.top;
       Height := Self.Height;
       Max:= fsize.y-FItemsvShown;
     end;
  end;



 // fark:=0;
 // fark:=(FSize.X-2)*fcolwidth;

//  if (fark>0) and (fark>self.ClientWidth) then
//   yscroll.Max :=(FSize.X-2)-1;//({( FSize.X) div }(fark div self.ClientWidth))+1;

 // if fark> self.ClientWidth then
  if FSize.x-FItemsHShown>0 then
  begin
    with yscroll do
    begin
      Visible := True;
      Left:=self.Left;
      top:=self.top+self.ClientHeight;
      Width:=self.ClientWidth;
      max := (FSize.x-FItemsHShown);
    end;
  end else
  begin
    yscroll.Visible := False;
  end;
  Invalidate;
End;

procedure Totransprentlist.SetColCount(AValue: Integer);
Begin
   Size := Point(AValue, FSize.Y);// RowCount);
End;

procedure Totransprentlist.Setcolwidth(const Avalue: Integer);
Begin
 if Avalue=fcolwidth then exit;
 fcolwidth:=Avalue;
 Invalidate;

End;

procedure Totransprentlist.SetRowCount(AValue: Integer);
Begin          //ColCount;
 Size := Point(FSize.X, AValue);
End;

procedure Totransprentlist.SetSize(AValue: TPoint);
Begin
   if (FSize.X = AValue.X) and (FSize.Y = AValue.Y) then Exit;
  FSize := AValue;
  SetLength(FCells, FSize.Y, FSize.X);
End;

function Totransprentlist.GetItemIndex: integer;
begin
  Result := fitemindex;
end;

procedure Totransprentlist.SetItemIndex(Avalue: integer);
var
  Shown: integer;
begin
  if FSize.Y = 0 then exit;
  if fitemindex = aValue then Exit;
  if fitemindex = -1 then exit;
  Shown := Height div FItemHeight;

  if (fsize.Y > 0) and (aValue >= -1) and (aValue <= FSize.Y) then
  begin
    fitemindex := aValue;

    if (aValue < FItemvOffset) then
      FItemvOffset := aValue
    else if aValue > (FItemvOffset + (Shown - 1)) then
      FItemvOffset := ValueRange(aValue - (Shown - 1), 0, FSize.Y - Shown);
  end
  else
  begin
    fitemindex := -1;
  end;
  Invalidate;
end;

function Totransprentlist.GetItemAt(Pos: TPoint): integer;
var
  w: Integer;
begin
  Result := -1;

  w := 3;//((Height) div FItemHeight-1);//FTop.Height;

  //if (Pos.Y >= 0) and (PtInRect(itempaintHeight,pos)) then
  if Pos.Y >= 0 then                                    //(FItemOffset + (Height) div FItemHeight) - 1
  begin
    Result := FItemvOffset + ((Pos.Y - w) div FItemHeight);

    if (Result > FSize.Y - 1) or (Result > (FItemvOffset + FItemsvShown )-1) then
      Result := -1;
  end;
end;

procedure Totransprentlist.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
var
  ClickedItem: integer;
begin
  if button = mbLeft then
  begin
    ClickedItem := GetItemAt(Point(X, Y));
    if ClickedItem > -1 then fitemindex := ClickedItem;
  end;

  Invalidate;
  inherited MouseDown(Button, Shift, X, Y);
end;


function Totransprentlist.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
//  fmodusewhelll := True;
  inherited;
  if not fscroll.Visible then exit;
  if FItemvOffset =fscroll.max then exit;

  fscroll.Position := fscroll.Position + Mouse.WheelScrollLines;
  FItemvOffset := fscroll.Position;
  Result := True;
  Invalidate;
//  fmodusewhelll := False;
end;

function Totransprentlist.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  inherited;
 // fmodusewhelll := True;
  if not fscroll.Visible then exit;
  if FItemvOffset =0 then exit;
  fscroll.Position := fscroll.Position - Mouse.WheelScrollLines;
  FItemvOffset := fscroll.Position;
  Result := True;
  Invalidate;
 // fmodusewhelll := False;
end;

constructor Totransprentlist.Create(Aowner: TComponent);
Begin
  Inherited Create(Aowner);
   parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks];
  FItemHeight:=15;
  fitemindex := -1;
  Width:=150;
  Height:=250;
  fcolwidth:=80;
  FItemvOffset:=0;
  fcolvisible:=-1;
  FItemhOffset:=0;

  FItemsvShown :=10;
  FItemsHShown :=3;
  Fselectedcolor :=clBlue;

  fscroll:=ToScrollBar.Create(nil);
  fscroll.Parent:=Parent;
  fscroll.Kind:=oVertical;
  fscroll.Left:=self.Left+self.Width;
  fscroll.top:=self.top;
  fscroll.Width:=20;
  fscroll.Height:=self.Height;
  fscroll.OnChange:=@VScrollBarChange;
  fscroll.Visible:=false;


  yscroll:=ToScrollBar.Create(nil);
  yscroll.Parent:=Parent;
  yscroll.Kind:=oHorizontal;
  yscroll.Left:=self.Left;
  yscroll.top:=self.top+self.Height;
  yscroll.Width:=self.Width;
  yscroll.Height:=20;
  yscroll.OnChange:=@HScrollBarChange;
  yscroll.Visible:=false;
End;

destructor Totransprentlist.Destroy;
Begin
  if Assigned(fscroll) then FreeAndNil(fscroll);
  if Assigned(yscroll) then FreeAndNil(yscroll);

  Inherited Destroy;
End;


procedure Totransprentlist.VScrollBarChange(Sender: Tobject);
begin
 FItemvOffset := fscroll.Position;
 Invalidate;
End;
procedure Totransprentlist.HScrollBarChange(Sender: TObject);
begin
 FItemhOffset := yscroll.Position;
 Invalidate;
end;

Procedure Totransprentlist.Paint;
var
 i,z,x4 ,a,b:integer;
begin
  if Visible=false then exit;
  inherited paint;


  if fsize.x-1 > 0 then
  begin
     try
      a := 1;
      x4:=0;
      FItemsvShown := Height div FitemHeight;
      FItemsHShown := (self.Width div fcolwidth)-1;

      canvas.Brush.Style := bsClear;
        for z:=0+FItemhOffset to fsize.x -1 do  // columns
        begin

         b:=a;
          if z<>fcolvisible then
          begin
            for i := FItemvOffset to (FItemvOffset + (Height) div FItemHeight) - 1 do
            begin
                if (i < GetRowCount) and (i>-1) then
                begin
                  if i=fitemindex then
                  begin
                    canvas.Brush.Color:=Fselectedcolor;
                    canvas.FillRect(a+x4,b,a+x4+fcolwidth, b+FitemHeight);
                  end;
                  canvas.Brush.Style := bsClear;
                  Canvas.TextOut(a+x4, b, GetCell(z,i));

                  b := b + FitemHeight;
                  if (b >= Height) then Break;
                end;
             //   b := a+FItemHeight;
            end;

            x4:=x4+fcolwidth;
          end;
        end;
    finally

    end;

  end;
End;






Procedure Toimgswich.Setbitmap(Const Avalue: Tportablenetworkgraphic);// Tpicture);
begin
  if fres=AValue then exit;
  fres.Assign(AValue);
  fres.Transparent:=true;
end;

Procedure Toimgswich.Setclickable(Avalue: Boolean);
Begin
  If Fclickable=Avalue Then Exit;
  fclickable:=Avalue;
End;

Procedure Toimgswich.Setfframe(Const Avalue: Integer);
Begin
  If (Fframee=Avalue) and (Avalue>fframe) Then Exit;
  Fframee:=Avalue;
  Invalidate;
End;

Procedure Toimgswich.Setframe(Const Avalue: Integer);
Begin
  if fframe=Avalue then exit;
  fframe:=Avalue;
  fframee:=Avalue-1;
  Invalidate;
End;


Function Toimgswich.Gettransparent: Boolean;
begin
 Result := Color = clNone;
end;




Procedure Toimgswich.Settransparent(Const Avalue: Boolean);
begin
  if transparent = AValue then
    exit;
  if AValue then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;





Constructor Toimgswich.Create(Aowner: Tcomponent);
begin
  inherited Create(Aowner);
   parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks];
  Width            := 100;
  Height           := 20;
  fframe           := 2;
  fframee          := fframe-1;
  fkind            := oVertical;
//  fclickable       := false;
  fres             := TPortableNetworkGraphic.Create;// TPicture.Create;
  fres.OnChange    := @imageset;
  fres.transparent := true;
//  fres.Graphic.Transparent:=true;
end;

Destructor Toimgswich.Destroy;
begin
  fres.OnChange := nil;
//  fres.Graphic  := nil;
  fres.Free;
  inherited Destroy;
end;

Procedure Toimgswich.Imageset(Sender: Tobject);
begin
  Invalidate;
end;

Procedure Toimgswich.Paint;
  procedure DrawFrame;
  begin
    with Canvas do
    begin
      Pen.Color := clBlack;
      Pen.Style := psDash;
      MoveTo(0, 0);
      LineTo(Self.Width-1, 0);
      LineTo(Self.Width-1, Self.Height-1);
      LineTo(0, Self.Height-1);
      LineTo(0, 0);
    end;
  end;
var
//  fbitmap:Tbitmap;
  SrcRect, DstRect: TRect;
  framewi:integer;
begin
  if csDesigning in ComponentState  then
  DrawFrame;

  inherited paint;
//  if not Assigned(fres.Graphic)then exit;// fres.Bitmap.Empty then exit;
//  if fres.Graphic.Empty then exit;
//  if fres.Graphic= nil then exit;


  if fkind=oVertical then
  begin
   framewi:=fres.Height div fframe;
   DstRect := Rect(0, framewi*fframee, fres.Width,framewi*(fframee+1))
  End
  else
  begin
   framewi:=fres.Width div fframe;
   DstRect := Rect(framewi*fframee, 0, framewi*(fframee+1), fres.Height);
  end;
  SrcRect := Rect(0, 0,self.Width,self.Height);

  Canvas.CopyRect(SrcRect,fres.Canvas,DstRect);

//  fbitmap:=TBitmap.Create;
//  fbitmap.SetSize(SrcRect.Right,SrcRect.Bottom);// .Width,self.Height);
//  fbitmap.Canvas.CopyRect(SrcRect,fres.bitmap.Canvas,DstRect);

  // fbitmap.Canvas.StretchDraw(SrcRect,fres.Graphic);
//  Canvas.StretchDraw(SrcRect,fbitmap);//
//   FreeAndNil(fbitmap);

//  inherited paint;
end;
Procedure Toimgswich.Mousedown(Button: Tmousebutton; Shift: Tshiftstate;
  X: Integer; Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if fclickable then
  begin
    Inc(fframee);
    if fframee>=fframe then
    fframee:=0;
    if Assigned(FOnChange) then FOnChange(self);
    Invalidate;
  End;
end;

Function Toimgswich.Getitemat(Pos: Tpoint): Integer;
begin

  Result := -1;
  if fkind=oVertical then
  begin

    if Pos.Y >= 0 then
    begin
      Result := ({fframe + }Pos.Y div (Height div fframe));
    end;
  End else
  begin

    if Pos.X >= 0 then
    begin
      Result := ({fframe + }Pos.X div (Width div fframe));
    end;
  End;
end;





















{ ToImgradio }



Procedure Toimgradio.Setbitmap(Const Avalue: Tportablenetworkgraphic);//Tpicture);
begin
  if fres=AValue then exit;
  fres.Assign(AValue);
  fres.Transparent:=true;
end;

Procedure Toimgradio.Setfframe(Avalue: Integer);
Begin
  If (Fframee=Avalue) and (Avalue>fframe) Then Exit;
  Fframee:=Avalue;
  Invalidate;
End;

Procedure Toimgradio.Setframe(Const Avalue: Integer);
Begin
  if fframe=Avalue then exit;
  fframe:=Avalue;
  fframee:=Avalue-1;
  Invalidate;
End;


Function Toimgradio.Gettransparent: Boolean;
begin
 Result := Color = clNone;
end;




Procedure Toimgradio.Settransparent(Const Avalue: Boolean);
begin
  if transparent = AValue then
    exit;
  if AValue then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;





Constructor Toimgradio.Create(Aowner: Tcomponent);
begin
  inherited Create(Aowner);
   parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csClickEvents,
    csCaptureMouse, csDoubleClicks];
  Width       := 100;
  Height      := 20;
  fframe       := 2;
  fframee      := fframe-1;
  fkind       := oVertical;
//  Color       := clRed;
  fres        := TPortableNetworkGraphic.Create;
  //fres.Clear;
 // fres.Mask(clBlack);
 // fres.Masked:=true;
  FOnChange:=nil;
  fres.OnChange:=@imageset;
  fres.Transparent:=true;
end;

Destructor Toimgradio.Destroy;
begin
  fres.OnChange := nil;
 // fres.Graphic  := nil;
  fres.Free;
  inherited Destroy;
end;

Procedure Toimgradio.Imageset(Sender: Tobject);
begin
  Invalidate;
end;

Procedure Toimgradio.Paint;
  procedure DrawFrame;
  begin
    with Canvas do
    begin
      Pen.Color := clBlack;
      Pen.Style := psDash;
      MoveTo(0, 0);
      LineTo(Self.Width-1, 0);
      LineTo(Self.Width-1, Self.Height-1);
      LineTo(0, Self.Height-1);
      LineTo(0, 0);
    end;
  end;
var
//  fbitmap:TPortableNetworkGraphic;
  SrcRect, DstRect: TRect;
  framewi:integer;
begin
  if csDesigning in ComponentState  then
  DrawFrame;

  inherited paint;
//  if not Assigned(fres.Graphic)then exit;// fres.Bitmap.Empty then exit;
 // if fres.Graphic.Empty then exit;
//  if fres.Graphic= nil then exit;


  if fkind=oVertical then
  begin
   framewi:=fres.Height div fframe;
   DstRect := Rect(0, framewi*fframee, fres.Width,framewi*(fframee+1))
  End
  else
  begin
   framewi:=fres.Width div fframe;
   DstRect := Rect(framewi*fframee, 0, framewi*(fframee+1), fres.Height);
  end;
  SrcRect := Rect(0, 0,self.Width,self.Height);
  Canvas.CopyRect(SrcRect,fres.Canvas,DstRect);


 { fbitmap:=TPortableNetworkGraphic.Create;// TBitmap.Create;
  fbitmap.SetSize(SrcRect.Right,SrcRect.Bottom);// .Width,self.Height);
  fbitmap.Canvas.CopyRect(SrcRect,fres.Canvas,DstRect);
  fBitmap.TransparentColor := fres.Canvas.Pixels[1,1];
  fBitmap.Transparent:=true;      }
  // fbitmap.Canvas.StretchDraw(SrcRect,fres.Graphic);
  //Canvas.StretchDraw(SrcRect,fbitmap);//

//  Tform(Parent).Canvas.CopyRect(SrcRect,fres.Canvas,DstRect);//
//   FreeAndNil(fbitmap);

//  inherited paint;
end;
Procedure Toimgradio.Mousedown(Button: Tmousebutton; Shift: Tshiftstate;
  X: Integer; Y: Integer);
var
  oldf:integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  oldf:=fframee;
  fframee:= getitemat(point(X, Y));

  If oldf=fframee then exit;
  Invalidate;
  Change;

end;

Procedure Toimgradio.change;
Begin
  if Assigned(FOnChange) then FOnChange(Self);





End;

Function Toimgradio.Getitemat(Pos: Tpoint): Integer;
begin

  Result := -1;
  if fkind=oVertical then
  begin

    if Pos.Y >= 0 then
    begin
      Result := ({fframe + }Pos.Y div (Height div fframe));
    end;
  End else
  begin

    if Pos.X >= 0 then
    begin
      Result := ({fframe + }Pos.X div (Width div fframe));
    end;
  End;
end;

{ TOlist }

constructor TOlist.Create(Aowner: TComponent);

begin
  inherited Create(AOwner);

  ControlStyle            := ControlStyle + [csOpaque];
  Width                   := 150;
  Height                  := 150;
  Parent                  := TWinControl(AOwner); // Remover!?

  FListItems              := TOlistItems.Create(Self, TOlistItem);
  fselectcolor            := Clblue;
  FItemOffset             := 0;
  FItemhOffset            := 0;
  fItemscount             := 0;
  FItemHeight             := 24;
  FheaderHeight           := 24;
  FFocusedItem            := -1;
  FAutoHideScrollBar      := true;
  Font.Name               := 'Calibri';
  Font.Size               := 9;
  Font.Style              := [];
//  fcolumwidth             := 80;
  TabStop                 := True;
  fbackgroundvisible      := True;
  fheadervisible          := True;
  FItemsShown             := 0;
  fcolumindex             := 0;
  Fheaderfont             := Tfont.Create;
  Fheaderfont.Name        := 'Calibri';
  Fheaderfont.Size        := 10;
  Fheaderfont.Style       := [];
  fitemcolor              := clBtnFace;
  fgridlines              := true;
  fgridwidth              := 1;
  fgridcolor              := clBlack;
  fheadercolor            := clBtnFace;
 // Backgroundcolored       := true;

   fobenter := Tocolor.Create(self);
  with fobenter do
  begin
   // Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  fobleave := Tocolor.Create(self);
  with fobleave do
  begin
    // Aownerr:=self;
     border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  fobdown := Tocolor.Create(self);
  with fobdown do
  begin
    // Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  ffdisabled := Tocolor.Create(self);
  with ffdisabled do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;


  ScrollBar := ToScrollBar.Create(self);
  with ScrollBar do
  begin
    Parent := self;
    Kind := oVertical;
    Width := 25;
    left := Self.Width - (25 + Background.Border);
    Top := Background.Border;
    Height := Self.Height - (Background.Border * 2);
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @Scrollbarchange;
    Position := 0;
    Visible  := false;


  end;


  vscroll := ToScrollBar.Create(self);
  with vscroll do
  begin
    Parent := self;
    Kind := oHorizontal;
    Width := self.Width- (Background.Border * 2);
    left := Background.Border;
    Top := Self.Height - (25 + Background.Border);
    Height := 25+ Background.Border;
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @HScrollBarChange;
    Position := 0;
    Visible  := false;

  end;
end;

destructor TOlist.Destroy;
begin
   FListItems.Free; FListItems := NIL;
   ScrollBar.Free;  ScrollBar  := NIL;
   vscroll.free; vscroll:=nil;
   if Assigned(headerfont) then
   FreeAndNil(Fheaderfont);

   if Assigned(fobdown) then
   FreeAndNil(fobdown);

   if Assigned(fobenter) then
   FreeAndNil(fobenter);

   if Assigned(fobleave) then
   FreeAndNil(fobleave);

   if Assigned(ffdisabled) then
   FreeAndNil(ffdisabled);

  inherited Destroy;
end;

procedure TOlist.Paint;
var
  i, z   : Integer;
  x1, x2,x3,x4 : SmallInt;
  a,b, fark,farki:integer;
  itmclr:Tcolor;
  FItemshShown:integer;
  gt:integer;
begin
  if Visible=false then exit;
  inherited paint;
  if Columns.Count > 0 then
  begin
     try

      FItemsShown := self.Height div FItemHeight;

      fark:=0;

      for z := 0 to Columns.Count - 1 do
      begin
        if Columns[z].Visible=true then
        fark+=Columns[z].Width; //:= fark+Fcolumns[z].Width;
      end;

   //   inc(fItemscount);
   //   writeln(FItemhOffset,'  ',fItemscount);

     // FItemshShown:=0;
      farki:=0;
      //if FItemshShown<=0 then
      for z := 0 to Columns.Count - 1 do
      begin
        farki+=Columns[z].Width;
        if farki>=self.ClientWidth then
        begin
          FItemshShown:=z;
          Break;
        end;
      end;



      if FAutoHideScrollBar then
      begin
        if Columns[0].Items.Count * FItemHeight > Height then
          ScrollBar.Visible := True
        else
          ScrollBar.Visible := False;

       if fark>self.ClientWidth then
         vscroll.Visible := True
        else
         vscroll.Visible := False;
      end;
    //  else
    //    ScrollBar.Visible := True;







        if Columns[0].Items.Count-FItemsShown+1 > 0 then
        begin
           with ScrollBar do
           begin
             Width := 25;
             left := Self.Width - (ScrollBar.Width);// + Background.Border);
             Top := Background.Border;
             Height := Self.Height - (Background.Border * 2);
             Max:=((Columns[0].Items.Count+1)-FItemsShown)+1;
             Ocolortoocolor(Background,self.Background);
             Ocolortoocolor(ButtonDown,self.ButtonDown);
             Ocolortoocolor(ButtonLeave,self.ButtonLeave);
             Ocolortoocolor(ButtonEnter,self.ButtonEnter);
             Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
           end;
        end;

        if fark>self.ClientWidth then
        with vscroll do
        begin
          if ScrollBar.Visible then
           Width := self.Width- ((Background.Border * 2)+ScrollBar.Width)
          else
           Width := self.Width- (Background.Border * 2);

          left := Background.Border;
          Top := Self.Height - (25 + Background.Border);
          Height := 25+ Background.Border;

          if (fark>0) and (fark>self.ClientWidth) then
            Max :=(Columns.Count-FItemshShown)-1;// div (fark div self.ClientWidth))+1;

     //     writeln(fark,'  ',self.ClientWidth);
         // ShowMessage(inttostr((Columns.Count div (fark div self.ClientWidth))+1));

          if fark> self.Width then
            Visible := True
          else
            Visible := False;

          Ocolortoocolor(Background,self.Background);
          Ocolortoocolor(ButtonDown,self.ButtonDown);
          Ocolortoocolor(ButtonLeave,self.ButtonLeave);
          Ocolortoocolor(ButtonEnter,self.ButtonEnter);
          Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
        end;


     // z:=0;
      a := Background.Border;
      b := a+FItemHeight;
      x1:=0;
      x2:=0;
      x3:=0;
      x4:=0;

      canvas.Brush.Style := bsClear;
        for z:=0+FItemhOffset to Columns.Count-1 do  // columns
        begin

           if Columns[z].Visible=true then
           begin

              a := Background.Border;
              if fheadervisible = True then
               b := a+FItemHeight
              else
               b:=a;




              if z>0 then
              x1:=x3
              else
              x1:=a;

              x2:=a;
              x3:=x1+(Columns[z].width);
              x4:=a+ FheaderHeight;


              if fheadervisible = True then
              begin
                canvas.Brush.Color := fgridcolor;// Background.Bordercolor;  // başlık border
                canvas.Brush.Style := bsSolid;
                canvas.FillRect(x1, x2, x3,x4);


              //  Canvas.Pen.Color:=clLime;// Background.Bordercolor;
              //  canvas.Pen.Width:=fgridwidth;//Background.Border;

                canvas.Brush.Color := fheadercolor;          // başlık rengi
                canvas.FillRect(x1+fgridwidth, x2+fgridwidth, x3-fgridwidth,x4-fgridwidth);

                canvas.Font.Assign(Fheaderfont);
                canvas.TextOut(x1+fgridwidth+5, x2+fgridwidth, Columns[z].Caption);   // başlık yazısı
               end;





              canvas.Font.Assign(Columns[z].font);

              if vscroll.Visible then
              gt:=(FItemOffset + ((self.Height-vscroll.Height) div FItemHeight))
              else
              gt:=(FItemOffset + ((self.Height) div FItemHeight));


              for i := FItemOffset to gt  do
              begin
                  if (i < Columns[z].Flist.Count) and (i>-1) then
                  begin
                      if fbackgroundvisible= True then
                      begin
                       // item border
                          if fgridlines then
                          begin
                            canvas.Brush.Color := fgridcolor;
                            canvas.Brush.Style := bsSolid;
                            canvas.FillRect(x1, b, x3,b + FitemHeight);
                          End;


                          if Columns.Count>=2 then
                          begin
                             if Columns[1].Flist[i]='2uy' then
                              itmclr:=clred
                              else if Columns[1].flist[i]='1bil' then
                              itmclr:=clGreen
                              else if Columns[1].flist[i]='0nor' then
                              itmclr:=fitemcolor
                              else
                              itmclr:=fitemcolor
                          End else
                          begin
                            itmclr:=fitemcolor;
                          end;

                          //tüm itemler boyancak

                          //item color
                          canvas.Brush.Color := itmclr;//fitemcolor;
                          canvas.Brush.Style := bsSolid;

                          canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);

                         // DrawFocusRect(self.canvas.Handle,rect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth));

                        //  Fstatelist:=fnormal;


                          if i = FFocusedItem then     // item seçili ise
                          begin
                              canvas.Brush.Color := fselectcolor;
                              canvas.Brush.Style := bsSolid;

                              if z=Columns.Count-1 then    // son item scrollbarı geçmesin
                              begin
                                if ScrollBar.Visible then
                                 canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-(fgridwidth+ScrollBar.Width),(b + FitemHeight)-fgridwidth)
                                else
                                 canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);
                              end else
                              begin
                               canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);
                              end;
                          end;

                          canvas.Brush.Style := bsClear;
                          Canvas.TextOut(x1+5, x2+b, Columns[z].Flist[i]);

                      end else
                      begin

                        if i = FFocusedItem then     // item seçili ise
                        begin
                          canvas.Brush.Color := fselectcolor;
                          canvas.Brush.Style := bsSolid;

                          if fheadervisible = True then
                           canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,b -fgridwidth)
                          else
                           canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);

                        end;

                        canvas.Brush.Style := bsClear;
                        canvas.TextOut(x1+5, x2+b, Columns[z].Flist[i]);

                      end;
                    b := b + FitemHeight;
                    if (b >= Height) then Break;
                  end;
              end;

           end;
        end;
     finally

     end;
  end;
end;



procedure TOlist.SetItems(Value: TOlistItems);
begin
   FListItems.Assign(Value);
  Invalidate;
end;

function TOlist.ItemRect(Item: Integer): TRect;
var
  r :TRect;
begin
  r := Rect(0, 0, 0, 0);

  if (Item >= FItemOffset - 1) and ((Item - FItemOffset) * FItemHeight < Height) then
  begin
    r.Top    := (Item - FItemOffset) * FItemHeight; // + 2; // 2 = TOP MARGIN!!
    r.Bottom := r.Top + FItemHeight;
    r.Left   := 0;

    if ScrollBar.Visible then
      r.Right := ScrollBar.Left
    else
      r.Right := Width;
  end;

  Result := r;

end;


function TOlist.GetItemAt(Pos: TPoint): Integer;
var
  i,m,w: Integer;
begin
   Result := -1;

//  Dec(Pos.Y, 2); // TOP MARGIN!

  if fheadervisible = True then
  w:=FheaderHeight
  else
  w:=0;

  if Pos.Y >= w then// FheaderHeight then
  begin
    Result := FItemOffset + (Pos.Y div FItemHeight);
    if fheadervisible = True then
    Result := Result -1;
   end;




  m:=0;
  fcolumindex:=-1;
  w:=0;
  if (pos.X>=0) then
  for i:=0 to Columns.Count-1 do
  begin
  {  if i=Columns.Count-1 then
     w:=width
    else }
     w:=w+Columns[i].Width;

    if (m<=Pos.x) and (w>=pos.x)then
    begin
     fcolumindex:=i;
     break;
    end;

    m:=w;
  end;
end;

{
procedure TOlist.ClearSelection(RepaintAll: Boolean);
var
  i: Integer;
begin
  if Columns.Count > 0 then
  begin
    for i := 0 to Columns.Count-1 do
      Columns[i].FSelected := False;

    if RepaintAll then Paint;
  end;
end;
  }


procedure TOlist.CMEnabledChanged(var Message: TMessage);
begin
 inherited;
   Invalidate;
end;



procedure TOlist.Setbuttondisable(Avalue: Tocolor);
Begin
  If Ffdisabled=Avalue Then Exit;
  Ffdisabled:=Avalue;
End;

procedure TOlist.Setbuttondown(Avalue: Tocolor);
Begin
  If Fobdown=Avalue Then Exit;
  Fobdown:=Avalue;
End;

procedure TOlist.Setbuttonenter(Avalue: Tocolor);
Begin
  If Fobenter=Avalue Then Exit;
  Fobenter:=Avalue;
End;

procedure TOlist.Setbuttonleave(Avalue: Tocolor);
Begin
  If Fobleave=Avalue Then Exit;
  Fobleave:=Avalue;
End;

function TOlist.Getcells(Acol, Arow: Integer): String;
Begin

  if (Columns.Count>-1) and (Columns.Count<=Acol) then
  Result:=''
  else
  begin
   if (Columns[Acol].Items.Count>-1) and (Columns[Acol].Items.Count<=Arow) then
   Result:=''
   else
    Result:=Columns[Acol].Items[Arow];
  end;

End;

function TOlist.Getgridview: Boolean;
begin
  Result:=fgridlines;
end;

procedure TOlist.Setcells(Acol, Arow: Integer; Avalue: String);
var
  i:integer;
Begin
   if (Columns.Count>-1) and (Columns.Count<=Acol) then
   begin
     Columns.Add;
   end;
   if (Columns[Acol].Items.Count>-1) and (Columns[Acol].Items.Count<=Arow) then
   begin
     Columns[Acol].Items.BeginUpdate;
    for i:=Columns[Acol].Items.Count+1 to arow do
    Columns[Acol].Items.Add('');

    Columns[Acol].Items.Insert(Arow,Avalue);
    Columns[Acol].Items.EndUpdate;
   end else
   begin
   //  Columns[Acol].Items.BeginUpdate;
     Columns[Acol].Items[Arow]:=Avalue;
   //  Columns[Acol].Items.EndUpdate;
   end;

   fItemscount :=Columns[acol].flist.Count;
   Invalidate;
End;

procedure TOlist.SetGridview(AValue: Boolean);
begin
   if fgridlines=AValue then exit;
   fgridlines:=AValue;
end;


procedure TOlist.CNKeyDown(var Message: TWMKeyDown);
var
  x: Integer;
begin

  case Message.CharCode of
    VK_RETURN : if (Columns.Count > 0) and (FFocusedItem > -1) then
                begin
                  Invalidate;
                  if Assigned(FItemEnterKey) then FItemEnterKey(Self);
                end;
    VK_UP     : begin
                  MoveUp;
                  Invalidate;
                end;
    VK_DOWN   : begin
                  MoveDown;
                  Invalidate;
                end;
    VK_HOME   : begin
                  MoveHome;
                  Invalidate;
                end;
    VK_END    : begin
                  MoveEnd;
                  Invalidate;
                end;
    VK_PRIOR  : if Columns[0].items.Count > 0 then
                begin
                  x := FItemOffset-FItemsShown;
                  if x < 0 then x := 0;
                  FItemOffset  := x;
                  FFocusedItem := x;
                  Invalidate;

                end;
    VK_NEXT   : if Columns[0].items.Count > 0 then
                begin
                  x := FItemOffset+FItemsShown;
                  if x >= Columns[0].items.Count then x := Columns[0].items.Count-1;
                  if Columns[0].items.Count <= FItemsShown then
                    FItemOffset  := 0
                  else if x > (Columns[0].items.Count - FItemsShown) then
                    FItemOffset  := Columns[0].items.Count - FItemsShown
                  else
                    FItemOffset  := x;
                  FFocusedItem := x;
                  Invalidate;
                end;
  else
    inherited;
  end;

end;

procedure TOlist.HScrollBarChange(Sender: TObject);
begin
 if fmodusewhelll=false then
 begin
   FItemhOffset := vscroll.Position;
   Invalidate;
 end;
end;

procedure TOlist.ScrollBarChange(Sender: TObject);
begin
 if fmodusewhelll=false then
 begin
   FItemOffset := ScrollBar.Position;
   Invalidate;
 end;
end;




function TOlist.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
 //  ScrollBar.Position := ScrollBar.Position+Mouse.WheelScrollLines;
//   FItemOffset := ScrollBar.Position+Mouse.WheelScrollLines;
//   Result := True;
  fmodusewhelll:=True;
  inherited;
  if not ScrollBar.visible then exit;
  ScrollBar.Position := ScrollBar.Position+Mouse.WheelScrollLines;
  FItemOffset := ScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll:=false;
end;

function TOlist.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
// ScrollBar.Position := ScrollBar.Position-Mouse.WheelScrollLines;
// FItemOffset := ScrollBar.Position-Mouse.WheelScrollLines;
//   Result := True;

   inherited;
   fmodusewhelll:=True;
   if not ScrollBar.visible then exit;
   ScrollBar.Position := ScrollBar.Position-Mouse.WheelScrollLines;
   FItemOffset := ScrollBar.Position;
   Result := True;
   Invalidate;
   fmodusewhelll:=false;
end;


procedure TOlist.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var
  Clickeditem: Integer;
begin

  if Columns.Count>0 then
  begin
    //if Items.Items.Count>0 then
    if button = mbLeft then
    begin
     FFocusedItem:= -1;
     Clickeditem := -1;

      ClickedItem := GetItemAt(Point(X, Y));

      if (ClickedItem>-1) and (fcolumindex>-1) then
      begin

      // FFocusedItem:=ClickedItem;

       if (Clickeditem<=Columns[fcolumindex].Items.Count-1) then FFocusedItem:=ClickedItem;

       if Assigned(FOnCellclick) then  FOnCellclick(self,Columns[fcolumindex]);
       Invalidate;

     //  ShowMessage(inttostr(FFocusedItem));

      end;
      SetFocus;
    end else
    begin
     // FFocusedItem:=-1;
     // Invalidate;
    End;
  end;
  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TOlist.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer
  );
begin
 if (Button = mbLeft) then
   inherited MouseUp(Button, Shift, X, Y)
 else if (Button = mbRight) and Assigned(PopupMenu) and (not PopupMenu.AutoPopup) then
   PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

end;

procedure TOlist.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
 inherited MouseMove(Shift, X, Y);

end;


{
procedure TOlist.SelectAll;
 var
  i: Integer;
begin
  if Columns.Count > 0 then
  begin
    Columns.BeginUpdate;
    try
      for i := 0 to Columns.Count-1 do
        Columns[i].FSelected := True;
    finally
      Columns.EndUpdate;
    end;
  end;
end;
}
procedure TOlist.Clear;
var
 i:integeR;
begin
   for i:=0 to Columns.Count-1 do
   begin
     Columns[i].Items.Clear;
   end;
end;


procedure TOlist.MoveUp;
 begin
   if Columns.Count > 0 then
   begin


     if (FFocusedItem > (FItemOffset+FItemsShown)) or (FFocusedItem < (FItemOffset)) then
     begin
       FFocusedItem := FItemOffset;
     end
     else if (FFocusedItem > 0) and (FFocusedItem < Columns[0].items.Count) then
     begin
      dec(FFocusedItem);

       if ((FFocusedItem-FItemOffset) = 0) and (FItemOffset > 0) then
         dec(FItemOffset);


     end;
   end;

end;

procedure TOlist.MoveDown;
 begin
   if Columns.Count > 0 then
   begin
      if (FFocusedItem > (FItemOffset+FItemsShown)) or (FFocusedItem < (FItemOffset)) then
     begin
       FFocusedItem := FItemOffset;
     end
     else if (FFocusedItem >= 0) and (FFocusedItem < Columns[0].items.Count-1) then
     begin
       Inc(FFocusedItem);
       // eğer scrollbar kaydırılması gerekiyorssa
       if (FFocusedItem-FItemOffset) > FItemsShown-1 then
       begin
         inc(FItemOffset);
       end;
     end;
   end;
 end;

procedure TOlist.MoveHome;
 var
   i: Integer;
 begin
   if Columns.Count > 0 then
   begin
     FFocusedItem := 0;
     FItemOffset  := 0;
   end;
end;

procedure TOlist.MoveEnd;
 var
   i: Integer;
 begin
   if Columns.Count > 0 then
   begin

     FFocusedItem := Columns[0].items.Count-1;

     if (Columns[0].items.Count-FItemsShown) >= 0 then
       FItemOffset := Columns[0].items.Count-FItemsShown
     else
       FItemOffset := 0;
   end;


end;

{
procedure TOlist.FindItem(Texti: String);
begin

end;
}

procedure TOlist.Delete(indexi: integer);
 var
   i:integer;
 begin
  for i:=0 to Columns.Count-1 do
   Columns[i].items.delete(Indexi);
end;


{ TOnurCellStrings }

function TOnurCellStrings.GetCell(X, Y: integer): string;
begin
  Result := FCells[Y, X];
end;

function TOnurCellStrings.GetColCount: integer;
begin
  Result := Size.x;
end;

function TOnurCellStrings.GetRowCount: integer;
begin
  Result := Size.Y;
end;

procedure TOnurCellStrings.SetCell(X, Y: integer; AValue: string);
var
  i, p: integer;
begin
  i := FSize.X;
  p := FSize.y;
  if x >= i then
    Inc(i);
  if y >= p then
    Inc(p);

  SetSize(point(i, p));

  FCells[Y, X] := AValue;

end;

procedure TOnurCellStrings.SetColCount(AValue: integer);
begin
  Size := Point(AValue, RowCount);
end;

procedure TOnurCellStrings.SetRowCount(AValue: integer);
begin
  Size := Point(ColCount, AValue);
end;

procedure TOnurCellStrings.SetSize(AValue: TPoint);
begin
  if (FSize.X = AValue.X) and (FSize.Y = AValue.Y) then Exit;
  FSize := AValue;
  SetLength(FCells, FSize.Y, FSize.X);
end;

procedure TOnurCellStrings.Savetofile(s: string);
var
  f: TextFile;
  i, k: integer;
begin
  AssignFile(f, s);
  Rewrite(f);
  Writeln(f, ColCount);
  Writeln(f, RowCount);
  for i := 0 to ColCount - 1 do
    for k := 0 to RowCount - 1 do
      Writeln(F, Cells[i, k]);
  //    end;
  CloseFile(F);
end;

procedure TOnurCellStrings.Loadfromfile(s: string);
var
  f: TextFile;
  iTmp, i, k: integer;
  strTemp: string;
begin
  AssignFile(f, s);
  Reset(f);

  // Get number of columns
  Readln(f, iTmp);
  ColCount := iTmp;
  // Get number of rows
  Readln(f, iTmp);
  RowCount := iTmp;
  // loop through cells & fill in values
  for i := 0 to ColCount - 1 do
    for k := 0 to RowCount - 1 do
    begin
      Readln(f, strTemp);
      Cells[i, k] := strTemp;
    end;

  CloseFile(f);
end;


procedure TOnurCellStrings.Clear;
begin
  FSize.x := 0;
  FSize.y := 0;

  SetLength(FCells, 0);
  Finalize(fsize);
end;

function TOnurCellStrings.arrayofstring(col: integer; aranan: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FSize.y - 1 do
  begin
    if FCells[i, col] = aranan then
    begin
      Result := i;
      break;
    end;
  end;
end;

{ Tostringgrid }

procedure Tostringgrid.SetBackground(AValue: Tocolor);
begin

end;



procedure Tostringgrid.SetButtonDisable(AValue: Tocolor);
begin

end;

procedure Tostringgrid.SetButtonDown(AValue: Tocolor);
begin

end;

procedure Tostringgrid.SetButtonenter(AValue: Tocolor);
begin

end;

procedure Tostringgrid.SetButtonLeave(AValue: Tocolor);
begin

end;

procedure Tostringgrid.SetColWidths(aCol: Integer; AValue: Integer);
begin

 if Length(FcolwitdhA)>0 then
 begin
  FcolwitdhA[acol]:=AValue;
  Invalidate;
 end;
end;

procedure Tostringgrid.SetCell(X, Y: integer; AValue: string);
var
  i, p: integer;
begin

  i := FSize.X;
  p := FSize.y;
  if x >= i then
    Inc(i);
  if y >= p then
    Inc(p);


  SetSize(point(i, p));

  FCells[Y, X] := AValue;

  SetLength(FcolwitdhA,fsize.x); // For colwidth
  FcolwitdhA[x]:=fcolwidth;  // default colwidth
  Invalidate;
end;

procedure Tostringgrid.SetColCount(AValue: integer);
begin
  SetSize(Point(AValue, RowCount));
  //fsize.x:=AValue;
 // SetLength(FCells,  FSize.X);
end;

procedure Tostringgrid.SetRowCount(AValue: integer);
begin
  SetSize(Point(ColCount, AValue));
  //fsize.y:=AValue;
  //SetLength(FCells, FSize.Y);
end;

procedure Tostringgrid.SetSize(AValue: TPoint);
begin
  if (FSize.X = AValue.X) and (FSize.Y = AValue.Y) then Exit;
   FSize := AValue;
   SetLength(FCells, FSize.Y, FSize.X);
end;

function Tostringgrid.GetCell(X, Y: integer): string;
begin
   Result := FCells[Y, X];
end;

function Tostringgrid.GetColCount: integer;
begin
   Result := fSize.x;
end;

function Tostringgrid.GetRowCount: integer;
begin
 Result := fSize.Y;
end;

procedure Tostringgrid.VscrollBarChange(Sender: Tobject);
begin
  if fmodusewhelll=false then
   begin
     FItemvOffset := vScrollBar.Position;
   //  WriteLn(FItemvOffset,'  ',FItemhOffset);
     Invalidate;
   end;
end;

procedure Tostringgrid.HScrollBarChange(Sender: TObject);
begin
 if fmodusewhelll=false then
 begin
   FItemhOffset := hScrollBar.Position;
   //WriteLn(FItemvOffset,'  ',FItemhOffset);
   Invalidate;
 end;
end;

constructor Tostringgrid.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  ControlStyle            := ControlStyle + [csOpaque];
  Width                   := 150;
  Height                  := 150;
  Parent                  := TWinControl(AOwner); // Remover!?
  fselectcolor            := Clblue;
  FItemvOffset            := 0;
  FItemhOffset            := 0;
  fItemscount             := 0;
  FItemHeight             := 24;
  FheaderHeight           := 24;
  FFocusedItem            := -1;
  FAutoHideScrollBar      := true;
  Font.Name               := 'Calibri';
  Font.Size               := 9;
  Font.Style              := [];
  fcolwidth               := 80;
  TabStop                 := True;
  fbackgroundvisible      := True;
  fheadervisible          := True;
  FItemsvShown            := 10;
  FItemshShown            := 5;

  fcolumindex             := 0;

  fitemcolor              := clBtnFace;
  fgridlines              := true;
  fgridwidth              := 1;
  fgridcolor              := clBlack;
  fheadercolor            := clBtnFace;
 // Backgroundcolored       := true;

   fobenter := Tocolor.Create(self);
  with fobenter do
  begin
   // Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  fobleave := Tocolor.Create(self);
  with fobleave do
  begin
    // Aownerr:=self;
     border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  fobdown := Tocolor.Create(self);
  with fobdown do
  begin
    // Aownerr:=self;
     border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  ffdisabled := Tocolor.Create(self);
  with ffdisabled do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;


  vScrollBar := ToScrollBar.Create(self);
  with vScrollBar do
  begin
    Parent := self;
    Kind := oVertical;
    Width := 25;
    left := Self.Width - (25 + Background.Border);
    Top := Background.Border;
    Height := Self.Height - (Background.Border * 2);
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @vScrollbarchange;
    Position := 0;
    Visible  := false;


  end;


  hScrollBar := ToScrollBar.Create(self);
  with hScrollBar do
  begin
    Parent := self;
    Kind := oHorizontal;
    Width := self.Width- (Background.Border * 2);
    left := Background.Border;
    Top := Self.Height - (25 + Background.Border);
    Height := 25+ Background.Border;
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @hScrollBarChange;
    Position := 0;
    Visible  := false;

  end;

end;

destructor Tostringgrid.Destroy;
begin

 vScrollBar.Free; vScrollBar  := NIL;
 hScrollBar.free; hScrollBar := nil;


   if Assigned(fobdown) then
   FreeAndNil(fobdown);

   if Assigned(fobenter) then
   FreeAndNil(fobenter);

   if Assigned(fobleave) then
   FreeAndNil(fobleave);

   if Assigned(ffdisabled) then
   FreeAndNil(ffdisabled);

  inherited Destroy;
end;

procedure Tostringgrid.SaveToFile(s: string);
var
  f: TextFile;
  i, k: integer;
begin
  AssignFile(f, s);
  Rewrite(f);
  Writeln(f, ColCount);
  Writeln(f, RowCount);
  for i := 0 to ColCount - 1 do
    for k := 0 to RowCount - 1 do
      Writeln(F, Cells[i, k]);
  //    end;
  CloseFile(F);
end;

procedure Tostringgrid.LoadFromFile(s: string);
var
  f: TextFile;
  iTmp, i, k: integer;
  strTemp: string;
begin
  AssignFile(f, s);
  Reset(f);

  // Get number of columns
  Readln(f, iTmp);
  ColCount := iTmp;
  // Get number of rows
  Readln(f, iTmp);
  RowCount := iTmp;
  // loop through cells & fill in values
  for i := 0 to ColCount - 1 do
    for k := 0 to RowCount - 1 do
    begin
      Readln(f, strTemp);
      Cells[i, k] := strTemp;
    end;

  CloseFile(f);
end;

procedure Tostringgrid.Clear;
begin
 FSize.x := 0;
 FSize.y := 0;

 SetLength(FCells, 0);
 Finalize(fsize);
 Invalidate;
end;

function Tostringgrid.Searchstring(col: integer; Search: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FSize.y - 1 do
  begin
    if FCells[i, col] = search then
    begin
      Result := i;
      break;
    end;
  end;

end;



function Tostringgrid.GetItemAt(Pos: TPoint): Integer;
var
  i,m,w: Integer;
begin
   Result := -1;

//  Dec(Pos.Y, 2); // TOP MARGIN!

  if fheadervisible = True then
  w:=FheaderHeight
  else
  w:=0;

  if Pos.Y >= w then// FheaderHeight then
  begin
    Result := FItemvOffset + (Pos.Y div FItemHeight);
    if fheadervisible = True then
    Result := Result -1;
   end;




  m:=0;
  fcolumindex:=-1;
  w:=0;
  if (pos.X>=0) then
  for i:=0 to ColCount-1 do
  begin
  {  if i=Columns.Count-1 then
     w:=width
    else }
     w:=w+fcolwidth; //Columns[i].Width;

    if (m<=Pos.x) and (w>=pos.x)then
    begin
     fcolumindex:=i;
     break;
    end;

    m:=w;
  end;
end;

function Tostringgrid.GetColWidths(aCol: Integer): Integer;
begin
  result:=FcolwitdhA[acol];
end;

procedure Tostringgrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var
  Clickeditem: Integer;
begin

  if fsize.x>0 then
  begin
    //if Items.Items.Count>0 then
    if button = mbLeft then
    begin
     FFocusedItem:= -1;
     Clickeditem := -1;

      ClickedItem := GetItemAt(Point(X, Y));

      if (ClickedItem>-1) and (fcolumindex>-1) then
      begin

      // FFocusedItem:=ClickedItem;

       if (Clickeditem<=RowCount-1) then FFocusedItem:=ClickedItem;

       if Assigned(FOnCellclick) then  FOnCellclick(self,fcolumindex);
       Invalidate;

     //  ShowMessage(inttostr(FFocusedItem));

      end;
      SetFocus;
    end else
    begin
     // FFocusedItem:=-1;
     // Invalidate;
    End;
  //  ShowMessage(inttostr(Clickeditem));
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure Tostringgrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure Tostringgrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
end;

procedure Tostringgrid.paint;
 var
  i, z   : Integer;
  x1, x2,x3,x4,xx : SmallInt;
  a,b, fark,farki:integer;
 // itmclr:Tcolor;
 // FItemshShown:integer;
  gt:integer;
begin
  if Visible=false then exit;

  inherited paint;

 //          11            1501
 // WriteLn(FSize.X,'   ',FSize.y);

  if FSize.X>0 then
  begin
     try

      FItemsvShown := self.ClientHeight div FItemHeight;

      fark:=0;

      for z := 0 to FSize.x - 1 do
      fark+= FcolwitdhA[z];

      farki:=0;
      FItemsHShown:=0;

      for z := 0 to fsize.x - 1 do
      begin
        farki+=FcolwitdhA[z];
        if farki>=self.ClientWidth then
        begin
          FItemshShown:=z;
          Break;
        end;
      end;

      //WriteLn(fark,'  ', FSize.x*fcolwidth);
      //fark:= fsize.x * fcolwidth;


      if FAutoHideScrollBar then
      begin
        if fark > self.ClientWidth then
          hScrollBar.Visible := True
        else
          hScrollBar.Visible := False;

       if (FSize.y * FItemHeight)>self.ClientHeight then
         vScrollbar.Visible := True
        else
         vScrollbar.Visible := False;
      end;

    //  else
    //    ScrollBar.Visible := True;

      {  if Columns[0].Items.Count-FItemsShown+1 > 0 then
        begin }
        if vScrollbar.Visible then
           with vScrollBar do
           begin
             Width := 25;
             left := Self.Width - (vScrollBar.Width);// + Background.Border);
             Top := Background.Border;
             Height := Self.clientHeight - (Background.Border * 2);
             Max:=((fsize.y)-FItemsvShown);
             Ocolortoocolor(Background,self.Background);
             Ocolortoocolor(ButtonDown,self.ButtonDown);
             Ocolortoocolor(ButtonLeave,self.ButtonLeave);
             Ocolortoocolor(ButtonEnter,self.ButtonEnter);
             Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
           end;

        if hScrollbar.Visible then
        with hScrollbar do
        begin
          if vScrollBar.Visible then
           Width := self.ClientWidth- ((Background.Border * 2)+vScrollBar.Width)
          else
           Width := self.ClientWidth- (Background.Border * 2);

          left := Background.Border;
          Top := Self.ClientHeight - (25 + Background.Border);
          Height := 25+ Background.Border;

          //if (fark>0) and (fark>self.ClientWidth) then
            Max :=(fsize.x-FItemsHShown);// div (fark div self.ClientWidth))+1;

     //     writeln(fark,'  ',self.ClientWidth);
         // ShowMessage(inttostr((Columns.Count div (fark div self.ClientWidth))+1));

       //   if fark> self.Width then
       //     Visible := True
       //   else
       //     Visible := False;

          Ocolortoocolor(Background,self.Background);
          Ocolortoocolor(ButtonDown,self.ButtonDown);
          Ocolortoocolor(ButtonLeave,self.ButtonLeave);
          Ocolortoocolor(ButtonEnter,self.ButtonEnter);
          Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
        end;

        {end;

        if fark>self.ClientWidth then
        with vscroll do
        begin
          if ScrollBar.Visible then
           Width := self.Width- ((Background.Border * 2)+ScrollBar.Width)
          else
           Width := self.Width- (Background.Border * 2);

          left := Background.Border;
          Top := Self.Height - (25 + Background.Border);
          Height := 25+ Background.Border;

          if (fark>0) and (fark>self.ClientWidth) then
            Max :=(Columns.Count-FItemshShown)-1;// div (fark div self.ClientWidth))+1;

     //     writeln(fark,'  ',self.ClientWidth);
         // ShowMessage(inttostr((Columns.Count div (fark div self.ClientWidth))+1));

          if fark> self.Width then
            Visible := True
          else
            Visible := False;

          Ocolortoocolor(Background,self.Background);
          Ocolortoocolor(ButtonDown,self.ButtonDown);
          Ocolortoocolor(ButtonLeave,self.ButtonLeave);
          Ocolortoocolor(ButtonEnter,self.ButtonEnter);
          Ocolortoocolor(ButtonDisabled,self.ButtonDisable);
        end;
         }

     // z:=0;

      if hScrollbar.Visible then
      vScrollbar.Max:=((fsize.y)-FItemsvShown)+1;


      a := Background.Border;
      b := a+FItemHeight;
      x1:=0;
      x2:=0;
      x3:=0;
      x4:=0;
      xx:=0;
      canvas.Brush.Style := bsClear;

        for z:=0+FItemhOffset to Fsize.x-1 do  // columns   // YATAY
        begin

         //  if Columns[z].Visible=true then
         //  begin

              a := Background.Border;
           //   if fheadervisible = True then
           //    b := a+FItemHeight
           //   else
               b:=a;




              if z>0 then
              x1:=x3
              else
              x1:=a;

              x2:=a;
              x3:=x1+FcolwitdhA[z];//fcolwidth;//(Columns[z].width);
              x4:=a+ FheaderHeight;


            {  if fheadervisible = True then
              begin
                canvas.Brush.Color := fgridcolor;// Background.Bordercolor;  // başlık border
                canvas.Brush.Style := bsSolid;
                canvas.FillRect(x1, x2, x3,x4);


              //  Canvas.Pen.Color:=clLime;// Background.Bordercolor;
              //  canvas.Pen.Width:=fgridwidth;//Background.Border;

                canvas.Brush.Color := fheadercolor;          // başlık rengi
                canvas.FillRect(x1+fgridwidth, x2+fgridwidth, x3-fgridwidth,x4-fgridwidth);

                canvas.Font.Assign(Fheaderfont);
                canvas.TextOut(x1+fgridwidth+5, x2+fgridwidth, Columns[z].Caption);   // başlık yazısı
               end;
               }




            //  canvas.Font.Assign(Columns[z].font);

              if hScrollbar.Visible then
              gt:=(FItemvOffset + ((self.ClientHeight-hScrollbar.Height) div FItemHeight))
              else
              gt:=FItemvOffset + (self.ClientHeight div FItemHeight);

             // WriteLn(FItemvOffset,'  ',((self.ClientHeight-VScrollbar.Height)),'  ',FItemHeight,' ',gt);



              for i := FItemvOffset to gt  do
              begin
                  if (i < Fsize.y) and (i>-1) then
                  begin
                      if fbackgroundvisible= True then
                      begin
                       // item border
                          if fgridlines then
                          begin
                            canvas.Brush.Color := fgridcolor;
                            canvas.Brush.Style := bsSolid;
                            canvas.FillRect(x1, b, x3,b + FitemHeight);
                          End;



                         // itmclr:=fitemcolor;


                          //tüm itemler boyancak

                          //item color
                          canvas.Brush.Color := fitemcolor;
                          canvas.Brush.Style := bsSolid;

                          canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);

                         // DrawFocusRect(self.canvas.Handle,rect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth));

                        //  Fstatelist:=fnormal;


                          if i = FFocusedItem then     // item seçili ise
                          begin
                              canvas.Brush.Color := fselectcolor;
                              canvas.Brush.Style := bsSolid;

                              if z=fsize.x-1 then    // son item scrollbarı geçmesin
                              begin
                                if hScrollBar.Visible then
                                 canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-(fgridwidth+hScrollBar.Width),(b + FitemHeight)-fgridwidth)
                                else
                                 canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);
                              end else
                              begin
                               canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);
                              end;
                          end;

                          canvas.Brush.Style := bsClear;
                          Canvas.TextOut(x1+5, x2+b, FCells[i,z]);

                      end else
                      begin

                        if i = FFocusedItem then     // item seçili ise
                        begin
                          canvas.Brush.Color := fselectcolor;
                          canvas.Brush.Style := bsSolid;

                          if fheadervisible = True then
                           canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,b -fgridwidth)
                          else
                           canvas.FillRect(x1+fgridwidth, b+fgridwidth, x3-fgridwidth,(b + FitemHeight)-fgridwidth);

                        end;

                        canvas.Brush.Style := bsClear;
                        canvas.TextOut(x1+5, x2+b, FCells[i,z]);

                      end;
                    b := b + FitemHeight;

                    if (b >= self.ClientHeight) then Break;
                  end;
              end;

          // end;
          xx:=xx+FcolwitdhA[z];
          if xx>self.ClientWidth then break;
        end;
     finally

     end;
  end;
end;

function Tostringgrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  fmodusewhelll:=True;
  if not HscrollBar.visible then exit;
  HscrollBar.Position := HscrollBar.Position+Mouse.WheelScrollLines;
  FItemvOffset := VscrollBar.Position;
  FItemHOffset := HscrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll:=false;
end;

function Tostringgrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);

   fmodusewhelll:=True;
   if not HscrollBar.visible then exit;
   HscrollBar.Position := HscrollBar.Position-Mouse.WheelScrollLines;
   FItemvOffset := VscrollBar.Position;
   FItemHOffset := HscrollBar.Position;

   Result := True;
   Invalidate;
   fmodusewhelll:=false;
end;

{ TOlistItem }

constructor TOlistItem.Create(Collectioni: TCollection);
begin
  FCaption       := '';
  fwidth         := 80;
  fvisible       := true;
  flist          := TStringList.Create;
  ffont          := TFont.Create;
  fFont.Name     := 'Calibri';
  fFont.Size     := 9;
  fFont.Style    := [];
  TStringList(Flist).OnChange := @listchange;
  inherited Create(Collectioni);
end;

destructor TOlistItem.Destroy;
begin
    with TOlist(TOwnedCollection(GetOwner).Owner) do
    if not (csDestroying in ComponentState) then
      if Assigned(FOnDeleteItem) then
      begin
        FOnDeleteItem(Self);

      end;
   if Assigned(flist) then
        FreeAndNil(flist);
        if Assigned(ffont) then
        FreeAndNil(ffont);
  inherited Destroy;
end;

procedure TOlistItem.delete(Indexi: integer);
begin
 if (flist.Count>0) and (flist.Count>Indexi) then
  flist.Delete(indexi);
 end;

procedure TOlistItem.Assign(Source: TPersistent);
begin
  if (Source is TOlistItem) then
    with (Source as TOlistItem) do
    begin
      Self.FCaption  := FCaption;
      self.flist.Assign(flist);
    end
  else
  inherited Assign(Source);
end;

procedure TOlistItem.SetString(AValue: TStrings);
begin
  if Flist=AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
 //  TOlist(TOwnedCollection(GetOwner).Owner).Paint;


end;

procedure TOlistItem.listchange(Sender: TObject);
begin
  TOlist(TOwnedCollection(GetOwner).Owner).Invalidate;// Paint;

end;

{ TOlistItems }

Function Tolistitems.Getitem(Indexi: Integer): Tolistitem;
begin
  if Indexi <> -1 then
 Result := TOlistItem(inherited GetItem(Indexi));
end;

Procedure Tolistitems.Setitem(Indexi: Integer; Const Value: Tolistitem);
begin
  inherited SetItem(Indexi, Value);
  Changed;
end;

Procedure Tolistitems.Update(Item: Tcollectionitem);
begin
  TOlist(GetOwner).Invalidate;//Paint;
 // inherited Update(Item);
end;

Constructor Tolistitems.Create(Aowner: Tpersistent;
  Itemclassi: Classes.Tcollectionitemclass);
begin
 inherited Create(AOwner, ItemClassi);
end;

Function Tolistitems.Add: Tolistitem;
begin
   Result := TOlistItem(inherited Add);
end;

Procedure Tolistitems.Clear;
begin
 with TOlist(GetOwner) do
 begin
   FItemOffset  := 0;  FFocusedItem := -1;
 end;

end;

Procedure Tolistitems.Delete(Indexi: Integer);
var
  i:integer;
begin


 for i:=0 to Count-1 do
  Items[i].delete(Indexi);

  Changed;
end;

Function Tolistitems.Insert(Indexi: Integer): Tolistitem;
begin
   Result := TOlistItem(inherited Insert(Indexi));
end;

Function Tolistitems.Indexof(Value: Tolistitem): Integer;
var
  i : Integer;
begin
  Result := -1;
  i      := 0;

  while (i < Count) and (Result = -1) do
    if Items[i] = Value then
      Result := i;

end;

{ ToRadiobutton }




function ToRadiobutton.getchecwidth: integer;
begin
  Result := fcheckwidth;
end;

procedure ToRadiobutton.setchecwidth(avalue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;


function ToRadiobutton.getcaptionmod: tcapdirection;
begin
  Result := fcaptiondirection;
end;

procedure ToRadiobutton.setcaptionmod(const val: tcapdirection);
begin
  if fcaptiondirection = val then
    exit;
  fcaptiondirection := val;
  //  paint;
  Invalidate;
end;


procedure ToRadiobutton.cmonmouseenter(var messages: tmessage);
begin
  fstate := obenters;
  Invalidate;
end;

procedure ToRadiobutton.cmonmouseleave(var messages: tmessage);
begin
  fstate := obleaves;
  Invalidate;
end;

procedure ToRadiobutton.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if fchecked=true then exit;

  if Button = mbLeft then
  begin
   // fchecked := not fchecked;

    fState := obdowns;

    //if Assigned(FOnChange) then FOnChange(Self);

    SetChecked(true);
   // deaktifdigerleri;
   //  Invalidate;

  end;
end;

procedure ToRadiobutton.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  state := obenters;
  Invalidate;
end;

procedure ToRadiobutton.doonchange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure ToRadiobutton.setchecked(const value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;

    deaktifdigerleri;
     doonchange;
    //   paint;
    Invalidate;
  end;
end;

function ToRadiobutton.getchecked: boolean;
begin
  Result := fchecked;
end;

{
procedure ToCustomcheckbox.SetCaption(const Value: string);
begin
  if Ftext <> Value then
  begin
    Ftext := Value;
 //   paint;
    Invalidate;
  end;
end;

function ToCustomcheckbox.GetCaption: string;
begin
  Result := Ftext;
end;
}
procedure ToRadiobutton.setstate(const value: tobutonstate);
begin
  if fstate <> Value then
  begin
    fstate := Value;

    //if (self is Toradiobutton) then
    //  deaktifdigerleri;

    //  paint;
    //  Invalidate;
  end;
end;

function ToRadiobutton.getstate: tobutonstate;
begin
  Result := fstate;
end;

procedure ToRadiobutton.deaktifdigerleri;
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
        if (Controls[i] is ToRadiobutton) and (Sibling <> Self) then
        begin
          ToRadiobutton(Sibling).fchecked:=false;//SetChecked(False);// Checked := False;
          ToRadiobutton(Sibling).fstate := obleaves;// Checked := False;
          Invalidate;
        end;

      end;


    {

      for i := 0 to ControlCount - 1 do
        if (Controls[i] <> Self) and (Controls[i] is ToRadiobutton) and
          ((Controls[i] as ToRadiobutton).FGroupIndex =
          (Self as ToRadiobutton).FGroupIndex) then
          ToRadiobutton(Controls[i]).SetChecked(False);
      }
    end;

//  fchecked := true;

end;

procedure ToRadiobutton.cmhittest(var msg: tcmhittest);
begin
  inherited;
  //  if csDesigning in ComponentState then
  //    Exit;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;

end;

constructor ToRadiobutton.create(aowner: tcomponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks, csSetCaption];
  Width := 100;
  Height := 20;
  fcheckwidth := 20;
  fchecked := False;
  //fCaptionDirection:=cleft;
  obenter := Tocolor.Create(self);
  with obenter do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  obleave := Tocolor.Create(self);
  with obleave do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdown := Tocolor.Create(self);
  with obdown do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  obcheckenters := Tocolor.Create(self);
  with obcheckenters do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clBlack;
    stopcolor := clBlack;
    Fontcolor := clBlue;
  end;

  obcheckleaves := Tocolor.Create(self);
  with obcheckleaves do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clBlack;
    stopcolor := clBlack;
    Fontcolor := clblack;
  end;

  obdisabled := Tocolor.Create(self);
  with obdisabled do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;

{  if (self is Toradiobutton) then
    Ftext := 'Radiobutton'
  else
    Ftext := 'Checkbox';
 }

  fstate := obleaves;
  fcaptiondirection := ocright; //cleft;
  backgroundcolored := False;
  // Transparent := True;
end;

destructor ToRadiobutton.destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);

  inherited Destroy;
end;
{
procedure DrawEllipticRegion(wnd: HWND; rect: TRect);
var
  rgn: HRGN;
begin
  rgn := CreateEllipticRgn(rect.left, rect.top, rect.right, rect.bottom);
  SetWindowRgn(wnd, rgn, True);
end;
 }
procedure ToRadiobutton.wmerasebkgnd(var message: twmerasebkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;

procedure ToRadiobutton.createparams(var params: tcreateparams);
begin
  inherited;// CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or
   {$IFNDEF UNIX}WS_EX_LAYERED or{$ENDIF}
    WS_CLIPCHILDREN;
  //  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED)
end;

procedure ToRadiobutton.paint;
var
  gradienrect1, gradienrect2, checkrect, Radiorect, Textrectt, borderect: Types.Trect;
  textx, Texty, fborderWidth, fborderWidthT: integer;
  obstart, obend, checkendstart, checkedend, oborder: Tcolor;
  //Com:TComponent;
  //Brush: ibrus IGradientBrush;
  fbuttoncenter,x,y: integer;
  Tc:Tocolor;
begin
  inherited paint;

  // com:=self;

  if Enabled = False then
  begin
    obstart := obdisabled.Startcolor;
    obend := obdisabled.Stopcolor;
    oborder := obdisabled.Bordercolor;
    fborderWidth := obdisabled.Border;
    canvas.Font.Color := obdisabled.Fontcolor;
    if Checked = True then
    begin
      checkendstart := obcheckenters.Startcolor;
      checkedend := obcheckenters.Stopcolor;
    end;
  end
  else
  begin
    if Checked = True then
    begin

      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          checkendstart := obcheckenters.Startcolor;
          checkedend := obcheckenters.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obcheckenters.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          checkendstart := obcheckleaves.Startcolor;
          checkedend := obcheckleaves.Stopcolor;
          oborder := obcheckleaves.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obcheckleaves.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          fborderWidth := obdown.Border;
          oborder := obdown.Bordercolor;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;
    end
    else
    begin
      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obenter.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          oborder := obleave.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obleave.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          oborder := obdown.Bordercolor;
          fborderWidth := obdown.Border;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;

    end;
  end;
{
  if Enabled = False then
  begin
    tc:=obdisabled;
  end
  else
  begin
    if Checked = True then
    begin
     case fstate of
         obenters:tc:=obcheckenters;
         obleaves:tc:=obcheckleaves;
         obdowns:tc:=obdown;
       end;
    end
    else
    begin
       case fstate of
         obenters:tc:=obenter;
         obleaves:tc:=obleave;
         obdowns:tc:=obdown;
       end;
     end;
  end;
}
  fborderWidthT := fborderWidth + 2;


  case fCaptionDirection of
    ocup:
    begin
      textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
      Texty := fborderWidth;
      fbuttoncenter := ((Height div 2) div 2) + (fcheckwidth div 2);
      borderect := Rect((Width div 2) - (fcheckwidth div 2), fbuttoncenter,
        (Width div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
    end;
    ocdown:
    begin
      textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
      Texty := ((Height div 2)) + fborderWidth;
      fbuttoncenter := ((Height div 2) div 2) - (fcheckwidth div 2);
      borderect := Rect((Width div 2) - (fcheckwidth div 2), fbuttoncenter,
        (Width div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
    end;
    ocleft:
    begin
      textx := Width - (fcheckwidth + self.canvas.TextWidth(Caption) + 5);
      Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
      fbuttoncenter := (Height div 2) - (fcheckwidth div 2);
      borderect := Rect(Width - fcheckwidth, fbuttoncenter, Width, fbuttoncenter + fcheckwidth);
    end;
    ocright:
    begin
      textx := fcheckwidth + 5;
      Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
      fbuttoncenter := (Height div 2) - (fcheckwidth div 2);
      borderect := Rect(0, fbuttoncenter, fcheckwidth, fbuttoncenter + fcheckwidth);
    end;
  end;

 { gradienrect1 := Rect(borderect.left + fborderWidth, borderect.top + fborderWidth,
    borderect.Right - fborderWidth, borderect.top + (borderect.Height div 2));
  gradienrect2 := Rect(gradienrect1.left, gradienrect1.Bottom, gradienrect1.Right,
    (borderect.Bottom - fborderWidth));

  checkrect := Rect(gradienrect1.left + fborderWidtht, gradienrect1.top +
    fborderWidtht, gradienrect2.Right - fborderWidtht, gradienrect2.bottom -
    fborderWidtht); }



//   Drawtorect(self.Canvas,borderect,Tc,Fkind);


  with canvas do
  begin
   // if (self is Toradiobutton) then
   // begin

    {  Brush.Color := oborder;
      Radiorect := Rect(gradienrect1.Left - fborderWidth, gradienrect1.top -
        fborderWidth, gradienrect2.Right + fborderWidth, gradienrect2.Bottom +
        fborderWidth);

      Ellipse(Radiorect);

      Radiorect := Rect(Radiorect.left + fborderWidth, Radiorect.top +
        fborderWidth, Radiorect.Right - fborderWidth, Radiorect.Bottom - fborderWidth);
      Brush.Color := obstart;
      Ellipse(Radiorect);

     }


  //      checkrect := Rect(borderect.left + fborderWidtht, borderect.top +
 //   fborderWidtht, borderect.Right - fborderWidtht, borderect.bottom -
 //   fborderWidtht);

      Brush.Color := obstart;
      Pen.Width := fborderWidth;
      Pen.Color := oborder;
      Ellipse(borderect);


   //   Arc(borderect.left + fborderWidth,borderect.top + fborderWidth,borderect.Right - fborderWidth,
   //  borderect.Bottom - (borderect.Height div 2),0,0,width,Height);

  // Canvas.Arc(Sol-üst x, Sol-üst y, Sağ-alt x, Sağ-alt y, Başlangıç x, Başlangıç y, Bitiş x, Bitiş y);

 //      x:=trunc(midx+20*cos(50));
 //   y:=trunc(midy+20*sin(50));
 //   canvas.brush.color:=clyellow;

 //   ellipse(x-r,y-r,x+r,y+r);

      if Checked then
      begin
        fborderWidtht+=2;
        checkrect := Rect(borderect.left + (fborderWidtht), borderect.top +
        (fborderWidtht), borderect.Right - (fborderWidtht), borderect.bottom -
        (fborderWidtht));

        Brush.Color := checkendstart;
        Pen.Width := fborderWidth;
        Pen.Color := oborder;
        Ellipse(checkrect);
       { Brush.Color := checkendstart;
        Radiorect := Rect(Radiorect.left + fborderWidthT, Radiorect.top +
          fborderWidthT, Radiorect.Right - fborderWidthT, Radiorect.Bottom -
          fborderWidthT);

        Ellipse(Radiorect);

        Brush.Color := checkedend;
        Radiorect := Rect(Radiorect.left + fborderWidth, Radiorect.top +
          fborderWidth, Radiorect.Right - fborderWidth, Radiorect.Bottom - fborderWidth);
        Ellipse(Radiorect);   }
      end;

    {end
    else
    begin

    {  Drawtorect(self.Canvas,borderect,Tc,Fkind);
      if fchecked = True then
      Drawtorect(self.Canvas,checkrect,Tc,Fkind);
      }
      Brush.Color := oborder;
      FillRect(borderect);
      GradientFill(gradienrect1, obstart, obend, gdVertical);
      GradientFill(gradienrect2, obend, obstart, gdVertical);

      if fchecked = True then
      begin
        Brush.Color := oborder;
        FillRect(checkrect);
   //     Brush.Style := bsClear;
   //     TextOut(checkrect.Width div 2, checkrect.Height div 2 , '֍');
        checkrect := Rect(checkrect.Left + fborderWidth, checkrect.top +
          fborderWidth, checkrect.Right - fborderWidth, checkrect.Bottom - fborderWidth);
        GradientFill(checkrect, checkendstart, checkedend, gdVertical);
        //√
      end;
    end;
    }
    if Length(Caption) > 0 then
    begin
      Brush.Style := bsClear;
      TextOut(Textx, Texty, (Caption));
    end;

  end;

end;


























{ TOled }



Procedure Toled.Setoncolor(Const Val: Tocolor);
Begin
  if val <> foncolor then
  begin
   foncolor:=val;
   Invalidate;
  End;
End;



Procedure Toled.Setoffcolor(Const Val: Tocolor);
Begin
  if val <> foffcolor then
   begin
    foffcolor:=val;
    Invalidate;
   End;
End;

Procedure Toled.Setledonoff(Val: Boolean);
Begin
  if val <> fcheck then
  begin
   fcheck:=val;
   if Assigned(FOnChange) then FOnChange(Self);
   Invalidate;
  End;
End;

Constructor Toled.Create(Aowner: Tcomponent);
Begin
  Inherited Create(Aowner);
   Width:=50;
  Height:=50;
  fcheck:=false;
  Fkind := oHorizontal;
  Transparent := True;
  backgroundcolored := false;

  foncolor := Tocolor.Create(self);

 // foncolor.// Aownerr:=self;
  foncolor.Startcolor := clLime;
  foncolor.Stopcolor := clGreen;
  foncolor.Border := 1;
  foncolor.Bordercolor := clBlack;

  foffcolor := Tocolor.Create(self);
//  foffcolor.// Aownerr:=self;
  foffcolor.Startcolor := clred;
  foffcolor.Stopcolor := clMaroon;
  foffcolor.Border := 1;
  foffcolor.Bordercolor := clBlack;


  fbackground.Startcolor := $00BF9259;
  fbackground.Stopcolor := $00BF9259;
  fbackground.Border := 1;
  fbackground.Bordercolor := clBlack;
End;

Destructor Toled.Destroy;
Begin
  Inherited Destroy;
  FreeAndNil(foncolor);
  FreeAndNil(foffcolor);
End;


Procedure Toled.Paint;
//const
//  BORDERR = 3;
var// x,y,
  r:integer;
  a,b,c:TColor;
//   Bmp : TBitmap;
  w, h: Integer;
  x, y: Integer;


Begin
  Inherited Paint;
  if fcheck then
  begin
   a:=foncolor.Startcolor;
   b:=foncolor.Stopcolor;
   c:=foncolor.Bordercolor;
   r:=foncolor.Border;
  End
  else
  begin
   a:=foffcolor.Startcolor;
   b:=foffcolor.Stopcolor;
   c:=foffcolor.Bordercolor;
   r:=foffcolor.Border;
  End;


    w          := Width div 2;// Bmp.Canvas.TextWidth('A');   //calculate the width of the image
    h          := Height div 2;//.Canvas.TextHeight('A');  //calculate the height of the image
   // Width  := Max(w, h) + BORDERr * 2;                       // get a square
  //  Height := Max(w, h) + BORDERr * 2;                       // get a square
    x          := (Width  - w) div 2;                       // center
    y          := (Height - h) div 2;                       // center

//    Canvas.Pen.Width:=r;                                 // border
//    Canvas.Pen.Color   := c;//Red;
//    Canvas.Brush.Color := Background.Startcolor;                           //set the background
//    Canvas.FillRect(Rect(0,0, Width, Height));      //paint the background which is transparent
                               // circle in red

 //   Canvas.Pen.Width:=r+5;
  //  Canvas.Pen.Color   := b;//Red;                            // circle in red
  //  Canvas.Ellipse(x, y, W, H);            // draw the circle


  //  Canvas.Pen.Width:=r+2;
  //  Canvas.Pen.Color   := a;//Red;                            // circle in red
  //  Canvas.Ellipse(1, 1, Width-1, Height-1);            // draw the circle

 //   Canvas.Pen.Width:=r+2;                                 // border
 //   Canvas.Pen.Color   := a;//Red;

   // Canvas.Pen.Width:=r;                                 // border
   // Canvas.Pen.Color   := c;//Red;
   // Canvas.Ellipse(0, 0, Width, Height);

    Canvas.Pen.Color   := b;
    Canvas.Brush.Color := b;
    Canvas.Ellipse(r, r, Width-r, Height-r);


    Canvas.Pen.Color   := c;
    Canvas.Brush.Color := a; // circle in red
    Canvas.Ellipse(r*2, r*2, Width-(r*2), Height-(r*2));            // draw the circle
End;



{ Tpopupformcombobox }

procedure Tpopupformcombobox.listboxDblClick(Sender: TObject);
begin
//Fedit.Text:=ToListBox(sender).Items[ToListBox(sender).ItemIndex];
//Fitemindex:=ToListBox(sender).ItemIndex;
//Tform(ToListBox(sender).parent).Close;
  if ToListBox(sender).items.Count>0 then
  ReturnstringAnditemindex;
end;



 procedure Tpopupformcombobox.DoClose(var CloseAction: TCloseAction);
begin
  FClosed := true;
  Application.RemoveOnDeactivateHandler(@FormDeactivate);
  CloseAction:=caFree;
  inherited DoClose(CloseAction);
  //Application.Terminate;
end;

 procedure Tpopupformcombobox.DoShow;
begin
  inherited DoShow;
  Width:=FCaller.Width;
  oblist.Font.Assign(FCaller.Font);
  oblist.items:=FCaller.items;

end;

constructor Tpopupformcombobox.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner);

 FClosed := false;
 Application.AddOnDeactivateHandler(@FormDeactivate);

 oblist :=ToListBox.Create(self);
 oblist.Parent:=self;
 oblist.Align:=alClient;

//  oblist.items.Assign(FCaller.Fliste);//:=FCaller.items;// .Assign(FCaller.Items);
  oblist.OnClick:=@listboxDblClick;

end;


procedure Tpopupformcombobox.CMDeactivate(var Message: TLMessage);
begin
 FormDeactivate(self);
end;

procedure Tpopupformcombobox.FormDeactivate(Sender: TObject);
begin
  Hide;
  if (not FClosed) then
   Close;
end;



procedure Tpopupformcombobox.KeepInView(const PopupOrigin: TPoint);
var
  ABounds: TRect;
  //P: TPoint;
begin
  ABounds := Screen.MonitorFromPoint(PopupOrigin).WorkAreaRect; // take care of taskbar
  if PopupOrigin.X + Width > ABounds.Right then
    Left := ABounds.Right - Width
  else if PopupOrigin.X < ABounds.Left then
    Left := ABounds.Left
  else
    Left := PopupOrigin.X;
  if PopupOrigin.Y + Height > ABounds.Bottom then
  begin
    if Assigned(FCaller) then
      Top := PopupOrigin.Y - FCaller.Height - Height
    else
      Top := ABounds.Bottom - Height;
  end else if PopupOrigin.Y < ABounds.Top then
    Top := ABounds.Top
  else
    Top := PopupOrigin.Y;
  if Left < ABounds.Left then Left := 0;
  if Top < ABounds.Top then Top := 0;


  if Assigned(oblist) then
 Ocolortoocolor(oblist.Background,FCaller.Background);

 if Assigned(oblist.VertialScroll) then
 begin
   Ocolortoocolor(oblist.VertialScroll.Background,FCaller.Background);
   Ocolortoocolor(oblist.VertialScroll.ButtonDown,FCaller.ButtonDown);
   Ocolortoocolor(oblist.VertialScroll.ButtonLeave,FCaller.ButtonLeave);
   Ocolortoocolor(oblist.VertialScroll.ButtonEnter,FCaller.ButtonEnter);
   Ocolortoocolor(oblist.VertialScroll.ButtonDisabled,FCaller.ButtonDisable);
 End;

end;

procedure Tpopupformcombobox.ReturnstringAnditemindex;
begin
  if oblist.itemindex>=0 then
  begin
   if Assigned(FOnReturnDate) then
   begin
    FOnReturnDate(Self, oblist.items[oblist.itemindex],oblist.itemindex);
    fCaller.change;
   end;
  end;
  if not FClosed then
    Close;
end;

procedure Tpopupformcombobox.Paint;
begin
  inherited Paint;

  {  if Assigned(fCaller) then
  begin
   if Assigned(oblist) then
   begin
     oblist.Background:=fCaller.Background;
     if Assigned(oblist.VertialScroll) then
     begin
        oblist.VertialScroll.Background:=fCaller.Background;
        oblist.VertialScroll.ButtonDisabled:=fCaller.ButtonDisable;
        oblist.VertialScroll.ButtonDown:=fCaller.ButtonDown;
        oblist.VertialScroll.ButtonEnter:=fCaller.ButtonEnter;
        oblist.VertialScroll.ButtonLeave:=fCaller.ButtonLeave;
     End;
    End;
  End;  }
end;




{ TOcolors }

constructor TOPersistent.Create(Aowner: TPersistent);
begin
  inherited Create;
  owner := Aowner;
end;

{ Tocolor }

function Tocolor.paint: boolean;
begin
  if (self.owner is TOProgressBar) and Assigned(self.owner) then
    TOProgressBar(self.owner).paint;
  if (self.owner is Tobuton) and Assigned(self.owner) then
    Tobuton(self.owner).paint;
  if (self.owner is Tocheckbox) and Assigned(self.owner) then
    Tocheckbox(self.owner).paint;
  if (self.owner is ToRadiobutton) and Assigned(self.owner) then
    ToRadiobutton(self.owner).paint;
  if (self.owner is Topanel) and Assigned(self.owner) then
    Topanel(self.owner).paint;


//  if (aownerr is TOKnob) and Assigned(aownerr) then
//    TOKnob(aownerr).paint;

//  if (self.owner is ToCustomcontrol) and Assigned(Self.owner) then
//    ToCustomcontrol(self.owner).paint;
//  if (self.owner is TOGraphicControl) and Assigned(Self.owner) then
//    TOGraphicControl(self.owner).paint;
  Result := True;
end;

function Tocolor.getborder: integer;
begin
  Result := fborder;
end;

function Tocolor.getbordercolor: Tcolor;
begin
  Result := fborderc;
end;

function Tocolor.getstartcolor: Tcolor;
begin
  Result := Fstartc;
end;

function Tocolor.getstopcolor: Tcolor;
begin
  Result := fstopc;
end;

function Tocolor.getfontcolor: Tcolor;
begin
  Result := ffontcolor;
end;

procedure Tocolor.Setborder(const Value: integer);
begin
  if Value <> fborder then
  begin
    fborder := Value;
    if Assigned(Tcontrol(self.owner)) then
    Tcontrol(self.owner).Invalidate;
  end;
end;

procedure Tocolor.Setbordercolor(const Value: Tcolor);
begin
  if Value <> fborderc then
  begin
    fborderc := Value;
    if Assigned(Tcontrol(self.owner)) then
    Tcontrol(self.owner).Invalidate;
  end;
end;

procedure Tocolor.Setstartcolor(const Value: Tcolor);
begin
  if Value <> Fstartc then
  begin
    Fstartc := Value;
    if Assigned(Tcontrol(self.owner)) then
    Tcontrol(self.owner).Invalidate;
  end;
end;

procedure Tocolor.Setstopcolor(const Value: Tcolor);
begin
  if Value <> fstopc then
  begin
    fstopc := Value;
    if Assigned(Tcontrol(self.owner)) then
    Tcontrol(self.owner).Invalidate;
  end;
end;

procedure Tocolor.setfontcolor(const Value: Tcolor);
begin
  if Value <> ffontcolor then
  begin
    ffontcolor := Value;
    if Assigned(Tcontrol(self.owner)) then
    Tcontrol(self.owner).Invalidate;
  end;
end;



{ TOGraphicControl }

function TOGraphicControl.Getkind: Tokindstate;
begin
  Result := Fkind;
end;

function TOGraphicControl.GetTransparent: boolean;
begin
  Result := Color = clNone;
end;


procedure TOGraphicControl.Setkind(Value: Tokindstate);
var
  x: integer;
begin
  if Fkind = Value then exit;
  Fkind := Value;
  if ((csDesigning in ComponentState) and (not (csLoading in ComponentState))) then
  begin
    X := self.Width;
    self.Width := Height;
    self.Height := X;
  end;

end;

procedure TOGraphicControl.Drawtorect(Cnv: Tcanvas; rc: Trect; tc: ToColor;
  Fkindi: Tokindstate);
var
  gradienrect1, gradienrect2: Trect;
begin
  Cnv.Brush.Color := tc.bordercolor;
  cnv.FillRect(rc);

  rc := Rect(rc.Left + tc.Border, rc.Top + tc.Border, rc.Right - tc.Border, rc.Bottom - tc.Border);

  if Fkindi = oHorizontal then
  begin
    gradienrect1 := Rect(rc.Left, rc.top, rc.Right, rc.Bottom div 2);
    gradienrect2 := Rect(rc.Left, rc.bottom div 2, rc.Right, rc.Bottom);
    Cnv.GradientFill(gradienrect1, tc.startcolor, tc.stopcolor, gdVertical);
    Cnv.GradientFill(gradienrect2, tc.stopcolor, tc.startcolor, gdVertical);
  end
  else
  begin
    gradienrect1 := Rect(rc.Left, rc.top, rc.Right div 2, rc.Bottom);
    gradienrect2 := Rect(rc.Right div 2, rc.top, rc.Right, rc.Bottom);
    Cnv.GradientFill(gradienrect1, tc.startcolor, tc.stopcolor, gdHorizontal);
    Cnv.GradientFill(gradienrect2, tc.stopcolor, tc.startcolor, gdHorizontal);
  end;

end;

procedure TOGraphicControl.SetTransparent(AValue: boolean);
begin
  if transparent = AValue then
    exit;
  if AValue then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

constructor TOGraphicControl.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks];
  self.Width := 250;
  self.Height := 150;
  background := Tocolor.Create(self);
 // Background.// Aownerr:=self;
  background.Startcolor := clActiveBorder;
  background.Stopcolor := clMenu;
  background.Border := 1;
  background.Bordercolor := clBlack;
  Fkind := oHorizontal;
  Transparent := True;
  backgroundcolored := True;
  ParentColor:=true;
end;

destructor TOGraphicControl.Destroy;
begin
  if Assigned(fbackground) then FreeAndNil(fbackground);
  inherited Destroy;
end;

procedure TOGraphicControl.paint;
begin
  inherited paint;
  if backgroundcolored = True then  // do have a component clientrect paint?
    Drawtorect(self.canvas, ClientRect, fbackground, Fkind);
end;


{ ToCustomcontrol }

constructor ToCustomcontrol.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csAcceptsControls,
    csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  self.Width := 250;
  self.Height := 150;
  background := Tocolor.Create(self);
//  Background.// Aownerr:=self;
  background.Startcolor := clActiveBorder;
  background.Stopcolor := clMenu;
  background.Border := 1;
  background.Bordercolor := clBlack;
  ParentBackground := True;
  Fkind := oHorizontal;
  backgroundcolored := True;
end;

destructor ToCustomcontrol.Destroy;
begin
  if Assigned(fbackground) then FreeAndNil(fbackground);
  inherited Destroy;
end;

procedure ToCustomcontrol.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;

procedure ToCustomcontrol.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or {$IFNDEF UNIX} WS_EX_LAYERED or{$ENDIF}
    WS_CLIPCHILDREN;
end;

 {
procedure ToCustomcontrol.drawstateb(xx: Tobutonstate; out gg: integer; out ff,
  st, en, fn: Tcolor);
begin

end;
}
procedure ToCustomcontrol.Drawtorect(Cnv: Tcanvas; rc: Trect;
  tc: ToColor; Fkindi: Tokindstate);
var
  gradienrect1, gradienrect2: Trect;
begin
  Cnv.Brush.Color := tc.bordercolor;
  cnv.FillRect(rc);
  //Cnv.FrameRect(rc);// FillRect(rc);
  //border

 { rc:=Rect(rc.Left+tc.Border,rc.Top+tc.Border,rc.Right-tc.Border,rc.Bottom-tc.Border);
  Cnv.Brush.Color :=tc.Stopcolor;
  Cnv.FrameRect(rc);
  rc:=Rect(rc.Left+tc.Border,rc.Top+tc.Border,rc.Right-tc.Border,rc.Bottom-tc.Border);
  Cnv.Brush.Color := tc.bordercolor;
  Cnv.FrameRect(rc);}
  rc := Rect(rc.Left + tc.Border, rc.Top + tc.Border, rc.Right - tc.Border, rc.Bottom - tc.Border);

  if Fkindi = oHorizontal then
  begin
    gradienrect1 := Rect(rc.Left, rc.top, rc.Right, rc.Bottom div 2);
    gradienrect2 := Rect(rc.Left, rc.bottom div 2, rc.Right, rc.Bottom);
    Cnv.GradientFill(gradienrect1, tc.startcolor, tc.stopcolor, gdVertical);
    Cnv.GradientFill(gradienrect2, tc.stopcolor, tc.startcolor, gdVertical);
  end
  else
  begin
    gradienrect1 := Rect(rc.Left, rc.top, rc.Right div 2, rc.Bottom);
    gradienrect2 := Rect(rc.Right div 2, rc.top, rc.Right, rc.Bottom);
    Cnv.GradientFill(gradienrect1, tc.startcolor, tc.stopcolor, gdHorizontal);
    Cnv.GradientFill(gradienrect2, tc.stopcolor, tc.startcolor, gdHorizontal);
  end;

end;

function ToCustomcontrol.Getkind: Tokindstate;
begin
  Result := Fkind;
end;

procedure ToCustomcontrol.SetKind(AValue: Tokindstate);
var
  x: integer;
begin
  if Fkind = Avalue then exit;
  Fkind := Avalue;
  if ((csDesigning in ComponentState) and (not (csLoading in ComponentState))) then
  begin
    X := self.Width;
    self.Width := Height;
    self.Height := X;
  end;

end;



procedure ToCustomcontrol.paint;
begin
  inherited paint;
  if backgroundcolored = True then  // do have a component clientrect paint?
    Drawtorect(self.canvas, ClientRect, fbackground, Fkind);
end;




{ Topanel }

procedure Topanel.paint;
var
  textx, Texty: integer;
begin
  inherited paint;

  if Length(Caption) > 0 then
  begin
    self.Canvas.Font.Color := fbackground.fontcolor;
    textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
    Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
    self.canvas.Brush.Style := bsClear;
    self.canvas.TextOut(Textx, Texty, (Caption));
  end;
end;




{ TOGraphicPanel }

procedure Tographicpanel.paint;
var
  textx, Texty: integer;
begin
  inherited paint;
  if Length(Caption) > 0 then
  begin
    self.Canvas.Font.Color := fbackground.fontcolor;
    textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
    Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
    self.canvas.Brush.Style := bsClear;
    self.canvas.TextOut(Textx, Texty, (Caption));
  end;
end;

{ TOCustomTrackBar }


constructor TOTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Parent := AOwner as TWinControl;
  Width := 180;
  Height := 20;
  FPosValue := 0;
  obleave := Tocolor.Create(self);
  with obleave do
  begin
    // Aownerr:=self;
    Startcolor := clActiveBorder;
    Stopcolor := clMenu;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clBlack;

  end;

  obenter := Tocolor.Create(self);
  with obenter do
  begin
    Startcolor := $00CDCDCD;
    Stopcolor := clMenu;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clBlue;
  end;
  obdown := Tocolor.Create(self);
  with obdown do
  begin
    Startcolor := clMenu;
    Stopcolor := $00A0A0A0;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clRed;
  end;

  fdisabled := Tocolor.Create(self);
  with fdisabled do
  begin
    Startcolor := clMenu;
    Stopcolor := $005D5D5D;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := $002C2C2C;
  end;
  Fkind := oHorizontal;
  fcenterbuttonarea := Rect(1, 1, 19, 19);
  FIsPressed := False;
  FW := 0;
  FH := 0;
  FPosition := 0;
  FXY := 0;
  FPosValue := 0;
  FMin := 0;
  FMax := 100;
  backgroundcolored := True;

end;

destructor TOTrackBar.Destroy;
begin
  FreeAndNil(fdisabled);
  FreeAndNil(obleave);
  FreeAndNil(obenter);
  FreeAndNil(obdown);
  inherited Destroy;
end;

function TOTrackBar.CheckRange(const Value: integer): integer;
begin
  if FKind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Width - fcenterbuttonarea.Width))));
  FPosValue := SliderFromPosition(Result);
end;



// -----------------------------------------------------------------------------

function TOTrackBar.MaxMin: integer;
begin
  Result := FMax - FMin;
end;

// -----------------------------------------------------------------------------

function TOTrackBar.Getcolors(xx: Tobutonstate): Tocolor;
begin
  if Enabled = False then exit(fdisabled);// begin Result:=fdisabled; exit; end;
  case xx of
    obleaves: Result := obleave;
    obenters: Result := obenter;
    obdowns: Result := obdown;
  end;
end;

procedure TOTrackBar.Paint;
begin
  if csDesigning in ComponentState then
    Exit;
  inherited paint;
  centerbuttonareaset;
  Drawtorect(self.canvas, fcenterbuttonarea, Getcolors(fcbutons), Kind);
end;

// -----------------------------------------------------------------------------

function TOTrackBar.CalculatePosition(const Value: integer): integer;
begin

  if FKind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;// FMax-Value; //for revers
end;

// -----------------------------------------------------------------------------

function TOTrackBar.GetPosition: integer;
begin
  Result := CalculatePosition(SliderFromPosition(FPosition));
end;


// -----------------------------------------------------------------------------

procedure TOTrackBar.SetPosition(Value: integer);
begin
  if FIsPressed then Exit;
  Value := ValueRange(Value, FMin, FMax);


  if FKind = oHorizontal then
  begin
    FPosition := PositionFromSlider(Value);
    FPosValue := Value - FMin;
  end
  else
  begin
    FPosition := PositionFromSlider(FMax - Value);
    FPosValue := Value; //FMax - Value;
  end;

  //  centerbuttonareaset;
  Changed;
  Invalidate;
end;

// -----------------------------------------------------------------------------

procedure TOTrackBar.SetMax(const Value: integer);
begin
  if Value <> FMax then FMax := Value;
end;

// -----------------------------------------------------------------------------

procedure TOTrackBar.SetMin(const Value: integer);
begin
  if Value <> FMin then FMin := Value;
end;

// -----------------------------------------------------------------------------

function TOTrackBar.GetPercentage: integer;
var
  Maxi, Pos, Z: integer;
begin
  Maxi := FMax + Abs(FMin);
  Pos := FPosValue + Abs(FMin);

  if FKind = oHorizontal then
    Z := 0
  else
    Z := 100;

  Result := Abs(Round(Z - (Pos / Maxi) * 100));
end;

// -----------------------------------------------------------------------------

procedure TOTrackBar.SetPercentage(Value: integer);
begin
  Value := ValueRange(Value, 0, 100);

  if FKind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
  //invalidate;
end;

// -----------------------------------------------------------------------------

function TOTrackBar.SliderFromPosition(const Value: integer): integer;
begin

  if FKind = oVertical then
    Result := Round(Value / (self.Height - fcenterbuttonarea.Height) * MaxMin)
  else
    Result := Round(Value / (self.Width - fcenterbuttonarea.Width) * MaxMin);

end;

// -----------------------------------------------------------------------------

function TOTrackBar.PositionFromSlider(const Value: integer): integer;
begin
  if FKind = oHorizontal then
    Result := Round(((self.Width - fcenterbuttonarea.Width) / MaxMin) * Value)
  else
    Result := Round(((self.Height - fcenterbuttonarea.Height) / MaxMin) * Value);
end;


// -----------------------------------------------------------------------------

procedure TOTrackBar.centerbuttonareaset;
begin
  if FKind = oHorizontal then
  begin
    fcenterbuttonarea.Width := self.Height - (Background.Border * 2);
    fcenterbuttonarea.Height := self.Width - (Background.Border * 2);

    if fPosition <= 0 then
      fcenterbuttonarea := Rect(Background.Border * 2, Background.Border * 2,
        fcenterbuttonarea.Width + (Background.Border * 2), Height - (Background.Border * 2))
    else if fPosition >= (Width - fcenterbuttonarea.Width) then
      fcenterbuttonarea := Rect(Width - (fcenterbuttonarea.Width + (Background.Border * 2)),
        Background.Border * 2, Width - Background.Border, Height - (Background.Border * 2))
    else
      fcenterbuttonarea := Rect(FPosition, Background.Border * 2,
        FPosition + fcenterbuttonarea.Width, Height - (Background.Border * 2));
  end
  else
  begin
    fcenterbuttonarea.Height := self.Width - (Background.Border * 2);
    fcenterbuttonarea.Width := self.Height - (Background.Border * 2);


    if fPosition <= 0 then
      fcenterbuttonarea := Rect(Background.Border * 2, Background.Border * 2,
        Width - (Background.Border * 2), fcenterbuttonarea.Height - (Background.Border * 2))
    else if fPosition >= (Height - fcenterbuttonarea.Height) then
      fcenterbuttonarea := Rect(Background.Border * 2, Height -
        (fcenterbuttonarea.Height + (Background.Border * 2)), Width - (Background.Border * 2),
        Height - (Background.Border * 2))
    else
      fcenterbuttonarea := Rect(Background.Border * 2, FPosition, Width -
        (Background.Border * 2), FPosition + fcenterbuttonarea.Height);
    // Height-(Background.Border*2))
  end;

end;

// -----------------------------------------------------------------------------

procedure TOTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FIsPressed := True;
    fcbutons := obdowns;
    if FKind = oHorizontal then
      FPosition := CheckRange(X)
    else
      FPosition := CheckRange(Y);

    Changed;
    invalidate;

  end;
end;

procedure TOTrackBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  MAXi: smallint;
begin
  inherited MouseMove(Shift, X, Y);
  if FIsPressed then
  begin
    if FKind = oHorizontal then
      MAXi := X
    else
      MAXi := Y;

    FPosition := CheckRange(MAXi);
    fcbutons := obdowns;
    Changed;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOTrackBar.CMonmouseenter(var Messages: Tmessage);
begin
  if (not FIsPressed) and (Enabled) then
  begin
    fcbutons := obenters;
    Invalidate;
  end;
end;

procedure TOTrackBar.CMonmouseleave(var Messages: Tmessage);
begin
  if Enabled then
  begin
    if not FIsPressed then
    begin
      fcbutons := obleaves;
      Invalidate;
    end;
    inherited;
  end;
end;


procedure TOTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FIsPressed then
  begin
    fcbutons := obenters;
    FIsPressed := False;
    Invalidate;
  end
  else
  begin
    if (Button = mbRight) and Assigned(PopupMenu) and not PopupMenu.AutoPopup then
    begin
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
    fcbutons := obleaves;
    Invalidate;
  end;
end;


procedure TOTrackBar.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;



// -----------------------------------------------------------------------------

constructor ToScrollBar.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  Parent := AOwner as TWinControl;


  obleave := Tocolor.Create(self);
  with obleave do
  begin
    Startcolor := clActiveBorder;
    Stopcolor := clMenu;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clBlack;
  end;

  obenter := Tocolor.Create(self);
  with obenter do
  begin
    Startcolor := $00CDCDCD;
    Stopcolor := clMenu;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clBlue;
  end;
  obdown := Tocolor.Create(self);
  with obdown do
  begin
    Startcolor := clMenu;
    Stopcolor := $00A0A0A0;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := clRed;
  end;

  fdisabled := Tocolor.Create(self);
  with fdisabled do
  begin
    Startcolor := clMenu;
    Stopcolor := $005D5D5D;
    Border := 1;
    Bordercolor := clBlack;
    Fontcolor := $002C2C2C;
  end;
  Flbuttonrect := Rect(1, 1, 20, 21);
  Frbuttonrect := Rect(179, 1, 199, 21);
  Ftrackarea := Rect(21, 1, 178, 21);
  Fkind := oHorizontal;
  fcbutons := obleaves;
  flbutons := obleaves;
  frbutons := obleaves;
  Width := 200;
  Height := 22;
  fmax := 100;
  fmin := 0;
  fposition := 0;
end;

destructor ToScrollBar.Destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(fdisabled);
  inherited Destroy;
end;

function ToScrollBar.Getcolors(xx: Tobutonstate): Tocolor;
begin
  if Enabled = False then exit(fdisabled);// begin Result:=fdisabled; exit; end;
  case xx of
    obleaves: Result := obleave;
    obenters: Result := obenter;
    obdowns: Result := obdown;
  end;
end;

procedure ToScrollBar.paint;
var
  Textx, Texty,textw,Texth: integer;

begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  inherited paint;
  centerbuttonareaset;
  Drawtorect(self.canvas, flbuttonrect, Getcolors(flbutons), Kind);
  Drawtorect(self.canvas, frbuttonrect, Getcolors(frbutons), Kind);
  Drawtorect(self.canvas, fcenterbuttonarea, Getcolors(fcbutons), Kind);

  canvas.Font.Name:='wingdings 3';//'webdings';// arial';
  Canvas.Font.Color:=Getcolors(flbutons).Fontcolor;

  textw:=self.canvas.TextWidth('x') div 2;//'◄') div 2;
  texth:=self.canvas.TextHeight('x') div 2;//'▲') div 2;

  textx := (flbuttonrect.Width div 2) - (textw); //(self.canvas.TextWidth('◄') div 2);
  Texty := (flbuttonrect.Height div 2) - (texth); //(self.canvas.TextHeight('▲') div 2);

  self.canvas.Brush.Style := bsClear;
  if Kind = oHorizontal then
    self.canvas.TextOut(Textx, Texty, '◄')//'◄')//'3')
  else
    self.canvas.TextOut(Textx, Texty, '▲');//'▲');//'5');




  Canvas.Font.Color:=Getcolors(frbutons).Fontcolor;

  textx := (frbuttonrect.Right  - frbuttonrect.Width div 2) - (textw);  //(self.canvas.TextWidth('◄') div 2);
  Texty := (frbuttonrect.bottom  - frbuttonrect.Height div 2) - (texth); // (self.canvas.TextHeight('▼') div 2);


  self.canvas.Brush.Style := bsClear;
  if Kind = oHorizontal then              //  ▼ ▲ ▼ ► ◄
    self.canvas.TextOut(Textx, Texty,'►') //'►')//'4') u
  else
    self.canvas.TextOut(Textx, Texty,'▼'); //'▼');//▲ ▼ ► ◄ ‡ // ALT+30 ALT+31 ALT+16 ALT+17 ALT+0135


    Canvas.Font.Color:=Getcolors(fcbutons).Fontcolor;
  textx := (fcenterbuttonarea.Right - fcenterbuttonarea.Width div 2) - (textw);  //    (self.canvas.TextWidth('◄') div 2);
  Texty := (fcenterbuttonarea.bottom - fcenterbuttonarea.Height div 2) - (texth);  //    (self.canvas.TextHeight('▼') div 2);
  // self.canvas.TextOut(Textx, Texty, '‡‡');


    self.canvas.Brush.Style := bsClear;
  if Kind = oHorizontal then
    self.canvas.TextOut(Textx, Texty, '||')//'4')
  else
    self.canvas.TextOut(Textx, Texty, '=');//▲ ▼ ► ◄ ‡ // ALT+30 ALT+31 ALT+16 ALT+17 ALT+0135


end;


procedure ToScrollBar.centerbuttonareaset;
var
  buttonh, borderwh: integer;
begin
  borderwh := Background.Border * 2; // border top, border bottom
  if FKind = oHorizontal then
  begin
    buttonh := self.Height - (borderwh);  // button Width and Height;
    Flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// left button
    Frbuttonrect := Rect(self.Width - (buttonh + borderwh), borderwh,
      self.Width - borderwh, buttonh); // right button
    Ftrackarea := Rect(flbuttonrect.Right, flbuttonrect.top,
      frbuttonrect.Left, frbuttonrect.Bottom);

    if fPosition <= 0 then
      fcenterbuttonarea := Rect(Flbuttonrect.Right,
        borderwh, Flbuttonrect.Right + buttonh + borderwh, self.Height - (borderwh))
    else if fPosition >= (Ftrackarea.Width) then //or position 100
      fcenterbuttonarea := Rect(Ftrackarea.Width - (buttonh + borderwh),
        borderwh, Ftrackarea.Width - borderwh, self.Height - borderwh)
    else
      fcenterbuttonarea := Rect(FPosition + buttonh, borderwh,
        FPosition + buttonh + buttonh, self.Height - borderwh);
    // fposition+leftbutton             // fposition+rightbutton  + centerbutton
  end
  else
  begin
    buttonh := self.Width - (borderwh);  // button Width and Height;
    Flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// top button
    Frbuttonrect := Rect(borderwh, self.Height -
      (buttonh + borderwh), self.Width - borderwh, self.Height - borderwh); // bottom button
    Ftrackarea := Rect(flbuttonrect.left, flbuttonrect.bottom,
      frbuttonrect.Right, frbuttonrect.top);


    if fPosition <= 0 then
      fcenterbuttonarea := Rect(borderwh, flbuttonrect.bottom + borderwh,
        self.Width - borderwh, flbuttonrect.bottom + buttonh + borderwh)
    else if fPosition >= (Ftrackarea.Height) then
      fcenterbuttonarea := Rect(borderwh, frbuttonrect.Top -
        (buttonh + borderwh), Width - borderwh, frbuttonrect.Top + borderwh)
    else
      fcenterbuttonarea := Rect(borderwh, FPosition + buttonh, Width -
        borderwh, FPosition + buttonh + buttonh);
    // fposition+topbutton             // fposition+bottombutton  + centerbutton
  end;

end;




function ToScrollBar.CheckRange(const Value: integer): integer;
begin
  if FKind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;


// -----------------------------------------------------------------------------

function ToScrollBar.MaxMin: integer;
begin
  Result := FMax - FMin;
end;

function ToScrollBar.CalculatePosition(const Value: integer): integer;
begin
  if FKind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;//FMax-Value; //for revers
end;



// -----------------------------------------------------------------------------

function ToScrollBar.Getposition: integer;
begin
  Result :=FPosValue; //CalculatePosition(SliderFromPosition(FPosition));

end;

function ToScrollBar.Getmin: integer;
begin
  Result := fmin;
end;

function ToScrollBar.Getmax: integer;
begin
  Result := fmax;
end;


// -----------------------------------------------------------------------------






procedure ToScrollBar.SetPosition( Value: integer);
begin
  if FIsPressed then Exit;
  Value := ValueRange(Value, FMin, FMax);

  if FKind = oHorizontal then
  begin
    FPosition := PositionFromSlider(Value);
     FPosValue := Value - FMin;
  end
  else
  begin
    FPosition := PositionFromSlider(value);// FMax - Val);
    FPosValue := Value; //FMax - Value;
  end;
  Changed;
  Invalidate;
end;

// -----------------------------------------------------------------------------

procedure ToScrollBar.SetMax(Val: integer);
begin
  if Val <> FMax then FMax := Val;
end;

// -----------------------------------------------------------------------------

procedure ToScrollBar.Setmin(Val: integer);
begin
  if Val <> FMin then FMin := Val;
end;



// -----------------------------------------------------------------------------

function ToScrollBar.GetPercentage: integer;
var
  Maxi, Pos, Z: integer;
begin
  Maxi := FMax + Abs(FMin);
  Pos := FPosValue + Abs(FMin);

  if FKind = oHorizontal then
    Z := 0
  else
    Z := 100;

  Result := Abs(Round(Z - (Pos / Maxi) * 100));
end;

// -----------------------------------------------------------------------------

procedure ToScrollBar.SetPercentage(Value: integer);
begin
  Value := ValueRange(Value, 0, 100);

  if FKind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
 // Repaint;
end;


function ToScrollBar.SliderFromPosition(const Value: integer): integer;
var
  iHW: Integer;
begin
  iHW := 0;
  case FKind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;

  Result := Round(Value / iHW * MaxMin);

 {
begin

  if FKind = oVertical then
    Result := Round (Value / (Ftrackarea.Height - fcenterbuttonarea.Height) * MaxMin)
  else
    Result := round(Value / (Ftrackarea.Width - fcenterbuttonarea.Width) * MaxMin);
}
//WriteLn(Result, '   dssds'); //pozisyon  sliderden poziyona
end;

// -----------------------------------------------------------------------------

function ToScrollBar.PositionFromSlider(const Value: integer): integer;
var
  iHW: Integer;
begin
  iHW := 0;
  case FKind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;
  Result := Round((iHW / MaxMin) * Value);
{begin
 // WriteLn(round2(((Ftrackarea.Width - fcenterbuttonarea.Width) / MaxMin) * Value));

   if FKind = oHorizontal then
     Result := round(((Ftrackarea.Width - fcenterbuttonarea.Width) / MaxMin) * Value)
  else
    Result := round(((Ftrackarea.Height - fcenterbuttonarea.Height) / MaxMin) * Value);
  }
//     WriteLn(Result,'  ii'); // pozisyondan slider konumuna
 end;




procedure ToScrollBar.CMonmouseenter(var Messages: Tmessage);
var
  Cursorpos: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;

  if (fcbutons = obenters) and (flbutons = obenters) and (frbutons = obenters) then
    Exit;

  inherited MouseEnter;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);


  if (PtInRect(flbuttonrect, Cursorpos)) then
  begin
    flbutons := obenters;
    frbutons := obleaves;
    fcbutons := obleaves;
     Invalidate;
  end
  else
  begin
    if (PtInRect(frbuttonrect, Cursorpos)) then
    begin
      flbutons := obleaves;
      frbutons := obenters;
      fcbutons := obleaves;
       Invalidate;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, Cursorpos)) then
      begin
        flbutons := obleaves;
        frbutons := obleaves;
        fcbutons := obenters;
         Invalidate;
      end
      else
      begin
        flbutons := obleaves;
        frbutons := obleaves;
        fcbutons := obleaves;
         Invalidate;
      end;
    end;
  end;

end;



procedure ToScrollBar.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;
  flbutons := obleaves;
  frbutons := obleaves;
  fcbutons := obleaves;
  Invalidate;
end;

procedure ToScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
var
  a:int64;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  FIsPressed := true;
  if (Button = mbleft) and (PtInRect(flbuttonrect, point(X, Y))) then  // left button down
  begin
    flbutons := obdowns;
    position := position-1;
    frbutons := obleaves;
    fcbutons := obleaves;
    if Assigned(FOnChange) then FOnChange(Self);

  //  flbutons := obleaves;
   // Invalidate;
  end
  else
  begin
    if (Button = mbleft) and (PtInRect(frbuttonrect, point(X, Y))) then   // right button down
    begin
      frbutons := obdowns;
      Position := Position + 1;
      flbutons := obleaves;
      fcbutons := obleaves;
      if Assigned(FOnChange) then FOnChange(Self);
    //  frbutons := obleaves;
    //  Invalidate;
    end
    else
    begin
      if (Button = mbleft) and (PtInRect(fcenterbuttonarea, point(X, Y))) then
        // right button down
      begin
        flbutons := obleaves;
        frbutons := obleaves;
        fcbutons := obdowns;
        fispressed := True;
        Invalidate;
      end
      else
      begin
        if (Button = mbleft) and (PtInRect(Ftrackarea, point(X, Y))) then
          // right button down
        begin
          flbutons := obleaves;
          frbutons := obleaves;
          fcbutons := obleaves;
          if Fkind = oHorizontal then
            FPosition :=
              CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition :=
              CheckRange(y - (fcenterbuttonarea.Height + (fcenterbuttonarea.Height div 2)));
           if Assigned(FOnChange) then FOnChange(Self);
          Invalidate;
        end
        else
        begin
          flbutons := obleaves;
          frbutons := obleaves;
          fcbutons := obleaves;
          FIsPressed := False;
          Invalidate;
        end;
      end;
    end;
  end;
 // paint;

end;

procedure ToScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FIsPressed := False;
  flbutons := obleaves;
  frbutons := obleaves;
  fcbutons := obleaves;
  Invalidate;
end;



procedure ToScrollBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;
  if (PtInRect(flbuttonrect, point(X, Y))) {and (fispressed)} then
  begin
    fcbutons := obleaves;
    flbutons := obenters;
    frbutons := obleaves;
    Invalidate;
  end
  else
  begin
    if (PtInRect(frbuttonrect, point(X, Y))) {and (fispressed)} then
    begin
      fcbutons := obleaves;
      flbutons := obleaves;
      frbutons := obenters;
      Invalidate;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, point(X, Y))) then
      begin

        if fispressed then
        begin
          if Fkind = oHorizontal then
            FPosition := CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition := CheckRange(y - (fcenterbuttonarea.Height + (fcenterbuttonarea.Height div 2)));

         if Assigned(FOnChange) then FOnChange(Self);

         fcbutons := obenters;
         flbutons := obleaves;
         frbutons := obleaves;
         Invalidate;
        end;

        fcbutons := obleaves;
        flbutons := obleaves;
        frbutons := obleaves;

      end
      else
      begin
        if fispressed then
        begin
          if Fkind = oHorizontal then
            FPosition := CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition := CheckRange(y - (fcenterbuttonarea.Height + (fcenterbuttonarea.Height div 2)));
         if Assigned(FOnChange) then FOnChange(Self);


      {   fcbutons := obleaves;
         flbutons := obleaves;
         frbutons := obleaves;
         Invalidate;  }
        end;
    //   fcbutons := obleaves;
   //    flbutons := obleaves;
   //    frbutons := obleaves;
    //   Invalidate;
      end;
    end;
  end;

end;




{ Toncaret }

function Toncaret.Getblinktime: integer;
begin
  Result := fblinktime;
end;

procedure Toncaret.Setblinktime(const Value: integer);
begin
  if (Value <> fblinktime) and (Value > 10) then
  begin
    fblinktime := Value;
    blinktimer.Interval := fBlinktime;
  end;
end;

function Toncaret.Getvisible: boolean;
begin
  Result := fvisibled;
end;

procedure Toncaret.Setvisible(const Value: boolean);
begin
  if Value <> fvisibled then
    fvisibled := Value;

  blinktimer.Enabled := Value;

  if Value = False then
  begin
    caretvisible := False;
    paint;
  end;
end;


procedure Toncaret.ontimerblink(Sender: TObject);
begin
  caretvisible := not caretvisible;
  paint;
end;

function Toncaret.Paint: boolean;
begin
  //  if parent is Tocustomedit then
  //    Tocustomedit(parent).paint;

  if parent is Tocustomedit then
    Tocustomedit(parent).Invalidate;
  Result := True;
end;




constructor Toncaret.Create(aowner: TPersistent);
begin
  inherited Create;
  parent := Tocustomedit(aowner);
  // Self.owner:=Toedit;
  FHeight := 20;//Toedit(Self.owner).Height;
  FWidth := 2;
  fblinkcolor := clBlack; //- toedit(Self.owner).Background.Stopcolor;
  fblinktime := 600;
  blinktimer := TTimer.Create(nil);
  blinktimer.Interval := blinktime;
  blinktimer.OnTimer := @ontimerblink;
  blinktimer.Enabled := False;
  CaretPos.X := 0;
  CaretPos.Y := 0;
  caretvisible := False;

end;

destructor Toncaret.Destroy;
begin
  inherited Destroy;
  FreeAndNil(blinktimer);
end;


{ Tocustomedit }


{
function Tocustomedit.getpassword: char;
begin
  Result := fpassword;
end;

procedure Tocustomedit.setpassword(const Value: char);
begin
  if fpassword = Value then
    exit;

  fpassword := Value;
  case fpassword of
    #0: EchoMode := emNormal;
    ' ': EchoMode := emNone;
    else
      EchoMode := emPassword;
  end;
  paint;
end;
 }

function tocustomedit.getcharcase: tocharcase;
begin
  Result := FCharCase;
end;

function tocustomedit.getechomode: toechomode;
begin
  Result := fEchoMode;
end;

procedure tocustomedit.setechomode(const value: toechomode);
begin
  if fEchoMode = Value then
    exit;
  fEchoMode := Value;
  case fEchoMode of
    emNormal: PasswordChar := #0;
    emPassWord:
      if (PasswordChar = #0) or (PasswordChar = ' ') then
        PasswordChar := '*';
    emNone:
      PasswordChar := ' ';
  end;
  Invalidate;
end;

procedure tocustomedit.setcharcase(const value: tocharcase);
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    Invalidate;
  end;
end;

procedure tocustomedit.setlefttextmargin(avalue: integer);
begin
  if FLeftTextMargin = AValue then Exit;
  FLeftTextMargin := AValue;
  Invalidate;
end;

procedure tocustomedit.setlines(avalue: tstrings);
begin
  if FLines = AValue then Exit;
  FLines.Assign(AValue);
  DoChange();
  Invalidate;
end;

procedure tocustomedit.setmultiline(avalue: boolean);
begin
  if FMultiLine = AValue then Exit;
  FMultiLine := AValue;
  Invalidate;
end;

procedure tocustomedit.setnumberonly(const value: boolean);
begin
 if FNumbersOnly<>value then FNumbersOnly:=value;
end;

procedure tocustomedit.setreadonly(avalue: boolean);
begin
  if FReadOnly<>avalue then FReadOnly:=avalue;
end;

procedure tocustomedit.setrighttextmargin(avalue: integer);
begin
  if FRightTextMargin = AValue then Exit;
  FRightTextMargin := AValue;
  Invalidate;
end;

procedure tocustomedit.settext(avalue: string);
begin
  Lines.Text := aValue;
end;

procedure tocustomedit.setpasswordchar(avalue: char);
begin
  if AValue = FPasswordChar then Exit;
  FPasswordChar := AValue;
  Invalidate;
end;

 {
function Tocustomedit.GetControlId: TCDControlID;
begin
  Result := cidEdit;
end;

procedure Tocustomedit.CreateControlStateEx;
begin
  FEditState := TCDEditStateEx.Create;
  FStateEx := FEditState;
end;
}
procedure tocustomedit.realsettext(const value: tcaption);
begin
  inherited RealSetText(Value);
  Lines.Text := Value;
  Invalidate;
end;

procedure tocustomedit.dochange;
begin
  Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;

{
procedure Tocustomedit.HandleCaretTimer(Sender: TObject);
begin
  if FEventArrived then
  begin
    FEditState.CaretIsVisible := True;
    FEditState.EventArrived := False;
  end
  else FEditState.CaretIsVisible := not FEditState.CaretIsVisible;

  Invalidate;
end;    }

function tocustomedit.getlefttextmargin: integer;
begin
  Result := FLeftTextMargin;
end;

function tocustomedit.getcaretpos: tpoint;
begin
  Result := FCarets.CaretPos;//FEditState.CaretPos;
end;

function tocustomedit.getmultiline: boolean;
begin
  Result := FMultiLine;
end;

function tocustomedit.getreadonly: boolean;
begin
  Result:=FReadOnly;
end;

function tocustomedit.getnumberonly: boolean;
begin
 Result:= FNumbersOnly;
end;

function tocustomedit.getrighttextmargin: integer;
begin
  Result := FRightTextMargin;
end;

function tocustomedit.gettext: string;
begin
  if Multiline then
    Result := Lines.Text
  else if Lines.Count = 0 then
    Result := ''
  else
    Result := Lines[0];
end;

function tocustomedit.getpasswordchar: char;
begin
  Result := FPasswordChar;
end;

procedure tocustomedit.dodeleteselection;
var
  lSelLeftPos, lSelRightPos, lSelLength: integer;
  lControlText, lTextLeft, lTextRight: string;
begin
  if IsSomethingSelected then
  begin
    lSelLeftPos := FSelStart.X;
    if FSelLength < 0 then lSelLeftPos := lSelLeftPos + FSelLength;
    lSelRightPos := FSelStart.X;
    if FSelLength > 0 then lSelRightPos := lSelRightPos + FSelLength;
    lSelLength := FSelLength;
    if lSelLength < 0 then lSelLength := lSelLength * -1;
    lControlText := GetCurrentLine();

    // Text left of the selection
    lTextLeft := UTF8Copy(lControlText, FVisibleTextStart.X,
      lSelLeftPos - FVisibleTextStart.X + 1);

    // Text right of the selection
    lTextRight := UTF8Copy(lControlText, lSelLeftPos + lSelLength + 1, Length(lControlText));

    // Execute the deletion
    SetCurrentLine(lTextLeft + lTextRight);

    // Correct the caret position
    // FEditState.CaretPos.X
    FCarets.CaretPos.X := Length(lTextLeft);
  end;

  DoClearSelection;
end;

procedure tocustomedit.doclearselection;
begin
  FSelStart.X := 1;
  FSelStart.Y := 0;
  FSelLength := 0;
end;

// Imposes sanity limits to the visible text start
// and also imposes sanity limits on the caret
procedure tocustomedit.domanagevisibletextstart;
var
  lVisibleText, lLineText: string;
  lVisibleTextCharCount: integer;
  lAvailableWidth: integer;
begin
  // Moved to the left and we need to adjust the text start
  FVisibleTextStart.X := Min(FCarets.CaretPos.X{FEditState.CaretPos.X} + 1,
    FVisibleTextStart.X);

  // Moved to the right and we need to adjust the text start
  lLineText := GetCurrentLine();
  lVisibleText := UTF8Copy(lLineText, FVisibleTextStart.X, Length(lLineText));
  lAvailableWidth := Width - 3 -3;
  lVisibleTextCharCount := Canvas.TextFitInfo(lVisibleText, lAvailableWidth);
  FVisibleTextStart.X := Max(FCarets.CaretPos.X{FCaretPos.X} - lVisibleTextCharCount + 1,
    FVisibleTextStart.X);

  // Moved upwards and we need to adjust the text start
  FVisibleTextStart.Y := Min(FCarets.CaretPos.Y{FCaretPos.Y}, FVisibleTextStart.Y);

  // Moved downwards and we need to adjust the text start
  FVisibleTextStart.Y := Max(FCarets.CaretPos.Y{FCaretPos.Y} - FFullyVisibleLinesCount,
    FVisibleTextStart.Y);

  // Impose limits in the caret too
  //  FCaretPos.X
  FCarets.CaretPos.X := Min(FCarets.CaretPos.X{FCaretPos.X}, UTF8Length(lLineText));
  //  FCaretPos.Y
  FCarets.CaretPos.Y := Min(FCarets.CaretPos.Y{FCaretPos.Y}, FLines.Count - 1);
  //  FCaretPos.Y
  FCarets.CaretPos.Y := Max(FCarets.CaretPos.Y{FCaretPos.Y}, 0);
end;

procedure tocustomedit.setcaretpost(avalue: tpoint);
begin
  // FCaretPos.X
  FCarets.CaretPos.X := AValue.X;
  // FCaretPos.Y
  FCarets.CaretPos.Y := AValue.Y;
  Invalidate;
end;

function VisibleText(const aVisibleText: TCaption; const APasswordChar: char): TCaption;
begin
  if aPasswordChar = #0 then
    Result := aVisibleText
  else
    Result := StringOfChar(aPasswordChar, UTF8Length(aVisibleText));

end;
// Result.X -> returns a zero-based position of the caret
function tocustomedit.mousepostocaretpos(x, y: integer): tpoint;
var
  lStrLen, i: PtrInt;
  lVisibleStr, lCurChar: string;
  lPos, lCurCharLen: integer;
  lBestDiff: cardinal = $FFFFFFFF;
  lLastDiff: cardinal = $FFFFFFFF;
  lCurDiff, lBestMatch: integer;
begin
  // Find the best Y position
  lPos := Y - 3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  if FLineHeight < 1 then FLineHeight := 1;
  // WriteLn('linehegit :',FLineHeight, lPos);
  Result.Y := lPos div FLineHeight;
  Result.Y := Min(Result.Y, FFullyVisibleLinesCount);
  Result.Y := Min(Result.Y, FLines.Count - 1);
  if Result.Y < 0 then
  begin
    Result.X := 1;
    Result.Y := 0;
    Exit;
  end;

  // Find the best X position
  Canvas.Font := Font;
  lVisibleStr := FLines.Strings[Result.Y];
  lVisibleStr := UTF8Copy(lVisibleStr, FVisibleTextStart.X, Length(lVisibleStr));
  lVisibleStr := VisibleText(lVisibleStr, FPasswordChar);
  lStrLen := UTF8Length(lVisibleStr);
  lPos := 3;//GetMeasures(TCDEDIT_LEFT_TEXT_SPACING);
  lBestMatch := 0;
  for i := 0 to lStrLen do
  begin
    lCurDiff := X - lPos;
    if lCurDiff < 0 then lCurDiff := lCurDiff * -1;

    if lCurDiff < lBestDiff then
    begin
      lBestDiff := lCurDiff;
      lBestMatch := i;
    end;

    // When the diff starts to grow we already found the caret pos, so exit
    if lCurDiff > lLastDiff then Break
    else
      lLastDiff := lCurDiff;

    if i <> lStrLen then
    begin
      lCurChar := UTF8Copy(lVisibleStr, i + 1, 1);
      lCurCharLen := Canvas.TextWidth(lCurChar);
      lPos := lPos + lCurCharLen;
    end;
  end;

  Result.X := lBestMatch + (FVisibleTextStart.X - 1);
  Result.X := Min(Result.X, FVisibleTextStart.X + lStrLen - 1);
end;

function tocustomedit.issomethingselected: boolean;
begin
  Result := FSelLength <> 0;
end;



procedure tocustomedit.doenter;
begin
  //  FCaretTimer.Enabled := True;
  FCarets.Visible := True;
  //FCaretIsVisible := True;
  inherited DoEnter;
end;

procedure tocustomedit.doexit;
begin
  //  FCaretTimer.Enabled := False;
  FCarets.Visible := False;
  // FCaretIsVisible := False;
  DoClearSelection();
  inherited DoExit;
end;

procedure tocustomedit.keydown(var key: word; shift: tshiftstate);
var
  lLeftText, lRightText, lOldText: string;
  lOldTextLength: PtrInt;
  lKeyWasProcessed: boolean = True;
begin
  inherited KeyDown(Key, Shift);


  lOldText := GetCurrentLine();
  lOldTextLength := UTF8Length(lOldText);
  FSelStart.Y := FCarets.CaretPos.Y;
  //FCaretPos.Y;//ToDo: Change this when proper multi-line selection is implemented

  case Key of
    // Backspace
    VK_BACK:
    begin
      // Selection backspace
      if IsSomethingSelected() then
        DoDeleteSelection()
      // Normal backspace
      else if FCarets.CaretPos.X > 0 then
      begin
        lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X - 1);
        lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X + 1,
          lOldTextLength);
        SetCurrentLine(lLeftText + lRightText);
        Dec(FCarets.CaretPos.X);
        DoManageVisibleTextStart();
        Invalidate;
      end;
    end;
    // DEL
    VK_DELETE:
    begin
      // Selection delete
      if IsSomethingSelected() then
        DoDeleteSelection()
      // Normal delete
      else if  FCarets.CaretPos.X < lOldTextLength then
      begin
        lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X);
        lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X+ 2,
          lOldTextLength);
        SetCurrentLine(lLeftText + lRightText);
        Invalidate;
      end;
    end;
    VK_LEFT:
    begin
      if (FCarets.CaretPos.X > 0) then
      begin
        // Selecting to the left
        if [ssShift] = Shift then
        begin
          if FSelLength = 0 then FSelStart.X := FCarets.CaretPos.X;
          Dec(FSelLength);
        end
        // Normal move to the left
        else
          FSelLength := 0;

        Dec(FCarets.CaretPos.X);
        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_HOME:
    begin
      if ( FCarets.CaretPos.X > 0) then
      begin
        // Selecting to the left
        if [ssShift] = Shift then
        begin
          if FSelLength = 0 then
          begin
            FSelStart.X := FCarets.CaretPos.X;
            FSelLength := -1 * FCarets.CaretPos.X;
          end
          else
            FSelLength := -1 * FSelStart.X;
        end
        // Normal move to the left
        else
          FSelLength := 0;


        FCarets.CaretPos.X := 0;
        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if (FSelLength <> 0) and ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_RIGHT:
    begin
      if FCarets.CaretPos.X < lOldTextLength then
      begin
        // Selecting to the right
        if [ssShift] = Shift then
        begin
          if FSelLength = 0 then FSelStart.X := FCarets.CaretPos.X;
          Inc(FSelLength);
        end
        // Normal move to the right
        else
          FSelLength := 0;

        Inc(FCarets.CaretPos.X);
        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_END:
    begin
      if FCarets.CaretPos.X < lOldTextLength then
      begin
        // Selecting to the right
        if [ssShift] = Shift then
        begin
          if FSelLength = 0 then
            FSelStart.X := FCarets.CaretPos.X;
          FSelLength := lOldTextLength - FSelStart.X;
        end
        // Normal move to the right
        else
          FSelLength := 0;

         FCarets.CaretPos.X := lOldTextLength;
        DoManageVisibleTextStart();
        //  FCaretIsVisible := True;
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if (FSelLength <> 0) and ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_UP:
    begin
      if (FCarets.CaretPos.Y > 0) then
      begin
        // Selecting downwards
      {if [ssShift] = Shift then
      begin
        if FSelLength = 0 then FSelStart.X := FCaretPos.X;
        Dec(FSelLength);
      end
      // Normal move downwards
      else} FSelLength := 0;

        Dec(FCarets.CaretPos.Y);
        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_DOWN:
    begin
      if FCarets.CaretPos.Y < FLines.Count - 1 then
      begin
      {// Selecting to the right
      if [ssShift] = Shift then
      begin
        if FSelLength = 0 then FSelStart.X := FCaretPos.X;
        Inc(FSelLength);
      end
      // Normal move to the right
      else} FSelLength := 0;

        Inc(FCarets.CaretPos.Y{FCaretPos.Y});
        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end
      // if we are not moving, at least deselect
      else if ([ssShift] <> Shift) then
      begin
        FSelLength := 0;
        Invalidate;
      end;
    end;
    VK_RETURN:
    begin
      if not MultiLine then Exit;
      // Selection delete
      if IsSomethingSelected() then
        DoDeleteSelection();
      // If the are no contents at the moment, add two lines, because the first one always exists for the user
      if FLines.Count = 0 then
      begin
        FLines.Add('');
        FLines.Add('');
        // FCaretPos
        FCarets.CaretPos := Point(0, 1);
      end
      else
      begin
        // Get the two halves of the text separated by the cursor
        lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X {FCaretPos.X});
        lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X{FCaretPos.X} + 1,
          lOldTextLength);
        // Move the right part to a new line
        SetCurrentLine(lLeftText);
        FLines.Insert({FCaretPos.Y}FCarets.CaretPos.Y + 1, lRightText);
        // FCaretPos
        FCarets.CaretPos := Point(0, FCarets.CaretPos.Y{FCaretPos.Y} + 1);
      end;
      Invalidate;
    end;

    else
      lKeyWasProcessed := False;
  end; // case

  if lKeyWasProcessed then
  begin
    //    FEventArrived := True;
    Key := 0;
  end;
end;

procedure tocustomedit.keyup(var key: word; shift: tshiftstate);
begin
  inherited KeyUp(Key, Shift);

  // copy, paste, cut, etc
  if Shift = [ssCtrl] then
  begin
    case Key of
      VK_C:
      begin
      end;
    end;
  end;
end;

procedure tocustomedit.utf8keypress(var utf8key: tutf8char);
var
  lLeftText, lRightText, lOldText: string;
begin
  inherited UTF8KeyPress(UTF8Key);

  // ReadOnly disables key input
  if FReadOnly then Exit;

  // LCL-Carbon sends Backspace as a UTF-8 Char
  // LCL-Qt sends arrow left,right,up,down (#28..#31), <enter>, ESC, etc
  // Don't handle any non-char keys here because they are already handled in KeyDown
  if (UTF8Key[1] in [#0..#$1F, #$7F]) or ((UTF8Key[1] = #$c2) and
    (UTF8Key[2] in [#$80..#$9F])) then Exit;

  if (FNumbersOnly=true) and not ((UTF8Key[1] in [#30..#$39])  or (UTF8Key[1]=#$2e) or (UTF8Key[1]=#$2c)) then exit;
  // (UTF8Key[1] in [#30..#$39, #$2e, #$2c])  then Exit;



  DoDeleteSelection;                          //▲ ▼ ► ◄ ‡ // ALT+30 ALT+31 ALT+16 ALT+17 ALT+0135

  // Normal characters
  lOldText := GetCurrentLine();
  lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X {FCaretPos.X});
  lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X {FCaretPos.X} + 1,
    UTF8Length(lOldText));
  SetCurrentLine(lLeftText + UTF8Key + lRightText);
  Inc(FCarets.CaretPos.X{FCaretPos.X});
  DoManageVisibleTextStart();
  FCarets.Visible := True;
  Invalidate;
end;

procedure tocustomedit.mousedown(button: tmousebutton; shift: tshiftstate; x,
  y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  DragDropStarted := True;

  // Caret positioning
  // FCaretPos
  FCarets.CaretPos := MousePosToCaretPos(X, Y);
  FSelLength := 0;
  FSelStart.X := FCarets.CaretPos.X;
  FSelStart.Y := FCarets.CaretPos.Y;
  FCarets.Visible := True;
  FCarets.caretvisible:=true;

  SetFocus;

  Invalidate;
end;

procedure tocustomedit.mousemove(shift: tshiftstate; x, y: integer);
begin
  inherited MouseMove(Shift, X, Y);

  // Mouse dragging selection
  if DragDropStarted then
  begin
    // FEditState.CaretPos
    FCarets.CaretPos := MousePosToCaretPos(X, Y);
    FSelLength := FCarets.CaretPos.X{FCaretPos.X} - FSelStart.X;
    //    FEventArrived := True;
    //  FCaretIsVisible := True;
    FCarets.Visible := True;
    Invalidate;
  end;
end;

procedure tocustomedit.mouseup(button: tmousebutton; shift: tshiftstate; x,
  y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  DragDropStarted := False;
end;

procedure tocustomedit.mouseenter;
begin
  inherited MouseEnter;
end;

procedure tocustomedit.mouseleave;
begin
  inherited MouseLeave;
end;

procedure tocustomedit.wmsetfocus(var message: tlmsetfocus);
begin
 DoEnter;
end;

procedure tocustomedit.wmkillfocus(var message: tlmkillfocus);
begin
  DoExit;
end;

constructor tocustomedit.create(aowner: tcomponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  Width := 80;
  Height := 25;
  TabStop := True;
  Cursor  := crIBeam;
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks,
    csRequiresKeyboardInput];
{  fbackground := Tocolor.Create(self);
  with fbackground do
  begin
    Border := 1;
    Startcolor := clActiveBorder;
    Stopcolor := clMenu;
  end;
 }
  FLines := TStringList.Create;
  FVisibleTextStart := Point(1, 0);

  FPasswordChar := #0;
  FCarets := Toncaret.Create(self);

end;

destructor tocustomedit.destroy;
begin
  FreeAndNil(fbackground);

  FreeAndNil(FLines);
  inherited Destroy;
  //FCaretTimer.Free; Don't free here because it is assigned with a owner
end;

function tocustomedit.getcurrentline: string;
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y{FCaretPos.Y} >= FLines.Count) then
    Result := ''
  else
    Result := FLines.Strings[FCarets.CaretPos.Y{FCaretPos.Y}];
end;

procedure tocustomedit.setcurrentline(astr: string);
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y{FCaretPos.Y} >= FLines.Count) then
  begin
    FLines.Text := AStr;
    FVisibleTextStart.X := 1;
    FVisibleTextStart.Y := 0;
    FCarets.CaretPos.X := 0;
    FCarets.CaretPos.Y := 0;
    // FCaretPos.X := 0;
    // FCaretPos.Y := 0;
  end
  else
    FLines.Strings[{FCaretPos.Y}FCarets.CaretPos.Y] := AStr;
  DoChange();
end;

function tocustomedit.getselstartx: integer;
begin
  Result := FSelStart.X;
end;

function tocustomedit.getsellength: integer;
begin
  Result := FSelLength;
  if Result < 0 then Result := Result * -1;
end;

procedure tocustomedit.setselstartx(anewx: integer);
begin
  FSelStart.X := ANewX;
end;

procedure tocustomedit.setsellength(anewlength: integer);
begin
  FSelLength := ANewLength;
end;

function tocustomedit.caretttopos(leftch: integer): integer;
var
  a, i: integer;
begin
  a := 0;
  for i := leftch to Lines.Text.Length do
  begin
    a := a + Canvas.TextExtent(Lines.Text[i]).cx;
    if i >= fcarets.CaretPos.X then
      break;
  end;
end;

procedure tocustomedit.paint;
var
//  gradienrect1, gradienrect2, Selrect,
  caretrect: Trect;
//  textx, Texty, i, a: integer;
  lControlText, lTmpText: string;
  lCaretPixelPos: integer;
  lTextBottomSpacing, lTextTopSpacing, lCaptionHeight, lLineHeight, lLineTop: integer;
  lSize: TSize;
begin
  inherited paint;


  //  textx := (self.Width div 2) - (self.canvas.TextWidth(Lines.Text) div 2);
  //  Texty := (self.Height div 2) - (self.canvas.TextHeight(Lines.Text) div 2);
  //  fborderWidth := fbackground.Border;


  lCaptionHeight := self.canvas.TextHeight(self.Text);//GetMeasures(TCDEDIT_CAPTION_HEIGHT);
  lTextBottomSpacing := 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
  lTextTopSpacing := 3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lLineHeight := self.canvas.TextHeight('ŹÇ');
  lSize := Size(self.Width, self.Height);
  lLineHeight := Min(lSize.cy - lTextBottomSpacing, lLineHeight);
  lLineTop := lTextTopSpacing + Fcarets.CaretPos.Y * lLineHeight;




  //  gradienrect1 := Rect(fborderWidth, fborderWidth, self.Width - fborderWidth, (self.Height div 2));
  //  gradienrect2 := Rect(fborderWidth, (self.Height div 2), self.Width - fborderWidth, self.Height - fborderWidth);


  if Lines.Count = 0 then lControlText := ''
  else
    lControlText := Lines.Strings[Fcarets.CaretPos.Y];

  lTmpText := UTF8Copy(lControlText, fVisibleTextStart.X,
    Fcarets.CaretPos.X - fVisibleTextStart.X + 1);
  lTmpText := VisibleText(lTmpText, fPasswordChar);
  lCaretPixelPos := self.canvas.TextWidth(lTmpText) +3+ fLeftTextMargin;

  caretrect := Rect(lCaretPixelPos, lLineTop, lCaretPixelPos +
    FCarets.Width, lLineTop + lCaptionHeight);


 { with canvas do
  begin
    Brush.Color := fbackground.Bordercolor;
    FillRect(ClipRect);

    GradientFill(gradienrect1, fbackground.Startcolor, fbackground.Stopcolor,
      gdVertical);
    GradientFill(gradienrect2, fbackground.Stopcolor, fbackground.Startcolor,
      gdVertical);
  end;
  }
  Drawtorect(self.Canvas, ClientRect, Background, Kind);
  DrawText;


  if Fcarets.Caretvisible then
  begin
    canvas.Brush.Color := FCarets.Color;
    canvas.FillRect(caretrect);
  end;


  //    Brush.Color := selectcolor;//clActiveCaption;

  //  if fselected then
  //   if SelEnd>0 then
  //      FillRect(Selrect);

  //  Brush.Style := bsClear;
  //  TextOut(fborderWidth, Texty, Lines.Text);

  //   if FCarets.Caretvisible then
  //  begin
  //     DrawCaret;
  //   Brush.Color := FCarets.Color;
  //    FillRect(caretrect);
  //  end;
  // end;

end;

procedure tocustomedit.drawcaret;
//(ADest: TCanvas; ADestPos: TPoint; ASize: TSize; AState: TCDControlState; AStateEx: TCDEditStateEx);
var
  lTextTopSpacing, lCaptionHeight, lLineHeight, lLineTop: integer;
  lControlText, lTmpText: string;
  lTextBottomSpacing, lCaretPixelPos: integer;
  lSize: TSize;
  textx, Texty: integer;
begin

{



  if Lines.Count = 0 then lControlText := ''
  else lControlText := Lines.Strings[Fcarets.CaretPos.Y];
//  lCaptionHeight := GetMeasures(TCDEDIT_CAPTION_HEIGHT);
//  lTextBottomSpacing := GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
//  lTextTopSpacing := GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
///  lLineHeight := self.canvas.TextHeight(cddTestStr)+2;
//  lSize := Size(self.Width, self.Height);
//  lLineHeight := Min(lSize.cy-lTextBottomSpacing, lLineHeight);
//  lLineTop := lTextTopSpacing + Fcarets.CaretPos.Y * lLineHeight;

  lTmpText := UTF8Copy(lControlText, fVisibleTextStart.X, Fcarets.CaretPos.X-fVisibleTextStart.X+1);
  lTmpText :=  VisibleText(lTmpText, fPasswordChar);
  lCaretPixelPos := self.canvas.TextWidth(lTmpText) //+ GetMeasures(TCDEDIT_LEFT_TEXT_SPACING)
    + fLeftTextMargin;

  textx := (self.Width div 2) - (self.canvas.TextWidth(Lines.Text) div 2);
  Texty := (self.Height div 2) - (self.canvas.TextHeight(Lines.Text) div 2);
  fborderWidth := fbackground.Border;

  self.canvas.Brush.Style := bsClear;
  //self.canvas.Pen.Color := clBlack;
  self.Canvas.TextOut(fborderWidth, Texty, lTmpText);

 if not Fcarets.Caretvisible then Exit;
  self.canvas.Pen.Color := clBlack;
  self.canvas.Pen.Style := psSolid;
  self.canvas.Line(lCaretPixelPos, fbackground.Border, lCaretPixelPos, self.Height-fbackground.Border);//lLineTop+lCaptionHeight);

  WriteLn(fVisibleTextStart.X,'   ',lCaretPixelPos,'   ',FCarets.CaretPos.X,'    ',FCarets.CaretPos.Y);
}
end;




procedure tocustomedit.drawtext;
//  ASize: TSize; AState: TCDControlState; AStateEx: TCDEditStateEx);
var
  lVisibleText, lControlText: TCaption;
  lSelLeftPos, lSelLeftPixelPos, lSelLength, lSelRightPos: integer;
  lTextWidth, lLineHeight, lLineTop: integer;
  lControlTextLen: PtrInt;
  lTextLeftSpacing, lTextTopSpacing, lTextBottomSpacing: integer;
  lTextColor: TColor;
  i, lVisibleLinesCount: integer;

  ASize: TSize;
begin
  // Background
  //DrawEditBackground(ADest, Point(0, 0), ASize, AState, AStateEx);
  // ADest:=self.Canvas;
  lTextColor := self.Font.Color;
  ASize := Size(self.Width, Self.Height);

  //  self.Canvas.Brush.Style := bsClear;
  self.Canvas.Font.Assign(self.Font);
  //  self.Canvas.Font.Color := lTextColor;
  lTextLeftSpacing := 3;//GetMeasures(TCDEDIT_LEFT_TEXT_SPACING);
  //lTextRightSpacing := GetMeasures(TCDEDIT_RIGHT_TEXT_SPACING);
  lTextTopSpacing := 3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lTextBottomSpacing := 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);

  lLineHeight := self.Canvas.TextHeight('ŹÇ') + 2;
  lLineHeight := Min(ASize.cy - lTextBottomSpacing, lLineHeight);

  // Fill this to be used in other parts
  fLineHeight := lLineHeight;
  fFullyVisibleLinesCount := ASize.cy - lTextTopSpacing - lTextBottomSpacing;
  fFullyVisibleLinesCount := fFullyVisibleLinesCount div lLineHeight;
  fFullyVisibleLinesCount := Min(fFullyVisibleLinesCount, Lines.Count);

  // Calculate how many lines to draw
  if Multiline then
    lVisibleLinesCount := fFullyVisibleLinesCount + 1
  else
    lVisibleLinesCount := 1;

  lVisibleLinesCount := Min(lVisibleLinesCount, Lines.Count);

  // Now draw each line
  for i := 0 to lVisibleLinesCount - 1 do
  begin
    lControlText := Lines.Strings[fVisibleTextStart.Y + i];
    lControlText := VisibleText(lControlText, fPasswordChar);
    lControlTextLen := UTF8Length(lControlText);
    lLineTop := lTextTopSpacing + i * lLineHeight;

    // The text
    // self.Canvas.Pen.Style := psClear;
    self.Canvas.Brush.Style := bsClear;
    // ToDo: Implement multi-line selection
    if (fSelLength = 0) or (fSelStart.Y <> fVisibleTextStart.Y + i) then
    begin
      lVisibleText := UTF8Copy(lControlText, fVisibleTextStart.X, lControlTextLen);
      self.Canvas.TextOut(lTextLeftSpacing, lLineTop, lVisibleText);
    end
    // Text and Selection
    else
    begin
      lSelLeftPos := fSelStart.X;
      if fSelLength < 0 then lSelLeftPos := lSelLeftPos + fSelLength;

      lSelRightPos := fSelStart.X;
      if fSelLength > 0 then lSelRightPos := lSelRightPos + fSelLength;

      lSelLength := fSelLength;
      if lSelLength < 0 then lSelLength := lSelLength * -1;

      // Text left of the selection
      lVisibleText := UTF8Copy(lControlText, fVisibleTextStart.X,
        lSelLeftPos - fVisibleTextStart.X + 1);
      self.Canvas.TextOut(lTextLeftSpacing, lLineTop, lVisibleText);
      lSelLeftPixelPos := self.Canvas.TextWidth(lVisibleText) + lTextLeftSpacing;

      // The selection background
      lVisibleText := UTF8Copy(lControlText, lSelLeftPos + 1, lSelLength);
      lTextWidth := self.Canvas.TextWidth(lVisibleText);
      self.Canvas.Brush.Color := clblue; //fselectolor; //WIN2000_SELECTION_BACKGROUND;
      self.Canvas.Brush.Style := bsSolid;
      self.Canvas.Rectangle(Bounds(lSelLeftPixelPos, lLineTop, lTextWidth, lLineHeight));
      self.Canvas.Brush.Style := bsClear;

      // The selection text
      self.Canvas.Font.Color := clWhite;
      self.Canvas.TextOut(lSelLeftPixelPos, lLineTop, lVisibleText);
      lSelLeftPixelPos := lSelLeftPixelPos + lTextWidth;

      // Text right of the selection
      //  self.Canvas.Brush.Color := clWhite;
      self.Canvas.Brush.Style := bsClear;
      self.Canvas.Font.Color := lTextColor;
      lVisibleText := UTF8Copy(lControlText, lSelLeftPos + lSelLength + 1, lControlTextLen);
      self.Canvas.TextOut(lSelLeftPixelPos, lLineTop, lVisibleText);

    end;

  end;

  // And the caret
  // DrawCaret(ADest, Point(0, 0), ASize, AState, AStateEx);

  // In the end the frame, because it must be on top of everything
  //  DrawEditFrame(ADest, Point(0, 0), ASize, AState, AStateEx);
end;


{ Tomemo }

constructor Tomemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MultiLine:=true;
end;

{ TOProgressBar }
constructor TOProgressBar.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csClickEvents, csCaptureMouse, csDoubleClicks, csSetCaption];
  Fkind := oHorizontal;
  self.Width := 150;
  self.Height := 10;
  fmin := 0;
  fmax := 100;
  fposition := 10;

  fbar := Tocolor.Create(self);
  fbar.Startcolor := clWhite;
  fbar.Stopcolor := $00FF9E28;
  fbar.Bordercolor := $008E4F00;
  fbar.Border := 2;
  FCaptonvisible := True;
end;

destructor TOProgressBar.Destroy;
begin
  FreeAndNil(fbar);
  inherited Destroy;
end;

procedure TOProgressBar.setposition(const Val: Int64);
begin
  fposition := ValueRange(Val, fmin, fmax);
  ftext := IntToStr(fposition);
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure TOProgressBar.setmax(const Val: Int64);
begin
  if fmax <> val then
  begin
    fmax := Val;
  end;
end;

procedure TOProgressBar.setmin(const Val: Int64);
begin
  if fmin <> val then
  begin
    fmin := Val;
  end;
end;

function TOProgressBar.Getposition: Int64;
begin
  Result := fposition;
end;

function TOProgressBar.Getmin: Int64;
begin
  Result := fmin;
end;

function TOProgressBar.Getmax: Int64;
begin
  Result := fmax;
end;


procedure TOProgressBar.paint;
var
  barborderrect: Trect;
  textx, Texty, fborderWidth: integer;
begin
  inherited paint;
  fborderWidth := fbar.Border;
  barborderrect := self.ClientRect;
  if Fkind = oHorizontal then
    barborderrect := Rect(barborderrect.Left + fborderWidth,
      barborderrect.Top + fborderWidth, (fposition * self.Width) div fmax,
      barborderrect.bottom - fborderWidth)
  else
    barborderrect := Rect(barborderrect.Left + fborderWidth,
      barborderrect.Top + fborderWidth, barborderrect.Right - fborderWidth,
      (fposition * self.Height) div fmax);

  Drawtorect(self.Canvas, barborderrect, fbar, self.Fkind);

  if FCaptonvisible = True then
  begin
    Canvas.Font.Color := Background.Fontcolor;
    // if Fkind=oVertical then
    // canvas.Font.Orientation:=-900;
    textx := (self.Width div 2) - (self.canvas.TextWidth(ftext) div 2);
    Texty := (self.Height div 2) - (self.canvas.TextHeight(Ftext) div 2);
    self.canvas.Brush.Style := bsClear;
    self.canvas.TextOut(Textx, Texty, ftext);
  end;

end;




{ ToCustomcheckbox }

function tocheckbox.getchecwidth: integer;
begin
  Result := fcheckwidth;
end;

procedure tocheckbox.setchecwidth(avalue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;


function tocheckbox.getcaptionmod: tcapdirection;
begin
  Result := fcaptiondirection;
end;

procedure tocheckbox.setcaptionmod(const val: tcapdirection);
begin
  if fcaptiondirection = val then
    exit;
  fcaptiondirection := val;
  //  paint;
  Invalidate;
end;


procedure tocheckbox.cmonmouseenter(var messages: tmessage);
begin
  fstate := obenters;
  Invalidate;
end;

procedure tocheckbox.cmonmouseleave(var messages: tmessage);
begin
  fstate := obleaves;
  Invalidate;
end;

procedure tocheckbox.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    fchecked := not fchecked;
    fState := obdowns;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end;
end;

procedure tocheckbox.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  state := obenters;
  Invalidate;
end;

procedure tocheckbox.doonchange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure tocheckbox.setchecked(const value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    //   paint;
    Invalidate;
  end;
end;

function tocheckbox.getchecked: boolean;
begin
  Result := fchecked;
end;

{
procedure ToCustomcheckbox.SetCaption(const Value: string);
begin
  if Ftext <> Value then
  begin
    Ftext := Value;
 //   paint;
    Invalidate;
  end;
end;

function ToCustomcheckbox.GetCaption: string;
begin
  Result := Ftext;
end;
}
procedure tocheckbox.setstate(const value: tobutonstate);
begin
  if fstate <> Value then
  begin
    fstate := Value;

   // if (self is Toradiobutton) then
  //    deaktifdigerleri;

    //  paint;
    //  Invalidate;
  end;
end;

function tocheckbox.getstate: tobutonstate;
begin
  Result := fstate;
end;

procedure tocheckbox.deaktifdigerleri;
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
        if (Controls[i] is ToRadiobutton) and (Sibling <> Self) then
        begin
          ToRadiobutton(Sibling).SetChecked(False);// Checked := False;
          ToRadiobutton(Sibling).fstate := obleaves;// Checked := False;
          Invalidate;
        end;
      end;


    {

      for i := 0 to ControlCount - 1 do
        if (Controls[i] <> Self) and (Controls[i] is ToRadiobutton) and
          ((Controls[i] as ToRadiobutton).FGroupIndex =
          (Self as ToRadiobutton).FGroupIndex) then
          ToRadiobutton(Controls[i]).SetChecked(False);
      }
    end;
end;

procedure tocheckbox.cmhittest(var msg: tcmhittest);
begin
  inherited;
  //  if csDesigning in ComponentState then
  //    Exit;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;

end;

constructor tocheckbox.create(aowner: tcomponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks, csSetCaption];
  Width := 100;
  Height := 20;
  fcheckwidth := 20;
  fchecked := False;
  //fCaptionDirection:=cleft;
  obenter := Tocolor.Create(self);
  with obenter do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  obleave := Tocolor.Create(self);
  with obleave do
  begin
    border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdown := Tocolor.Create(self);
  with obdown do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  obcheckenters := Tocolor.Create(self);
  with obcheckenters do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clBlack;
    stopcolor := clBlack;
    Fontcolor := clBlue;
  end;

  obcheckleaves := Tocolor.Create(self);
  with obcheckleaves do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clBlack;
    stopcolor := clBlack;
    Fontcolor := clblack;
  end;

  obdisabled := Tocolor.Create(self);
  with obdisabled do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;

{  if (self is Toradiobutton) then
    Ftext := 'Radiobutton'
  else
    Ftext := 'Checkbox';
 }

  fstate := obleaves;
  fcaptiondirection := ocright; //cleft;
  backgroundcolored := False;
  // Transparent := True;
end;

destructor tocheckbox.destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);

  inherited Destroy;
end;



procedure tocheckbox.wmerasebkgnd(var message: twmerasebkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;

procedure tocheckbox.createparams(var params: tcreateparams);
begin
  inherited;// CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or
   {$IFNDEF UNIX}WS_EX_LAYERED or{$ENDIF}
    WS_CLIPCHILDREN;
  //  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED)
end;

procedure tocheckbox.paint;
var
  gradienrect1, gradienrect2, checkrect, Radiorect, Textrectt, borderect: Types.Trect;
  textx, Texty, fborderWidth, fborderWidthT: integer;
  obstart, obend, checkendstart, checkedend, oborder: Tcolor;
  //Com:TComponent;
  //Brush: ibrus IGradientBrush;
  fbuttoncenter: integer;
  Tc:Tocolor;
begin
  inherited paint;

  // com:=self;

  if Enabled = False then
  begin
    obstart := obdisabled.Startcolor;
    obend := obdisabled.Stopcolor;
    oborder := obdisabled.Bordercolor;
    fborderWidth := obdisabled.Border;
    canvas.Font.Color := obdisabled.Fontcolor;
    if Checked = True then
    begin
      checkendstart := obcheckenters.Startcolor;
      checkedend := obcheckenters.Stopcolor;
    end;
  end
  else
  begin
    if Checked = True then
    begin

      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          checkendstart := obcheckenters.Startcolor;
          checkedend := obcheckenters.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obcheckenters.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          checkendstart := obcheckleaves.Startcolor;
          checkedend := obcheckleaves.Stopcolor;
          oborder := obcheckleaves.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obcheckleaves.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          fborderWidth := obdown.Border;
          oborder := obdown.Bordercolor;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;
    end
    else
    begin
      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obenter.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          oborder := obleave.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obleave.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          oborder := obdown.Bordercolor;
          fborderWidth := obdown.Border;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;

    end;
  end;
{
  if Enabled = False then
  begin
    tc:=obdisabled;
  end
  else
  begin
    if Checked = True then
    begin
     case fstate of
         obenters:tc:=obcheckenters;
         obleaves:tc:=obcheckleaves;
         obdowns:tc:=obdown;
       end;
    end
    else
    begin
       case fstate of
         obenters:tc:=obenter;
         obleaves:tc:=obleave;
         obdowns:tc:=obdown;
       end;
     end;
  end;
}
  fborderWidthT := fborderWidth + 2;


  case fCaptionDirection of
    ocup:
    begin
      textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
      Texty := fborderWidth;
      fbuttoncenter := ((Height div 2) div 2) + (fcheckwidth div 2);
      borderect := Rect((Width div 2) - (fcheckwidth div 2), fbuttoncenter,
        (Width div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
    end;
    ocdown:
    begin
      textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
      Texty := ((Height div 2)) + fborderWidth;
      fbuttoncenter := ((Height div 2) div 2) - (fcheckwidth div 2);
      borderect := Rect((Width div 2) - (fcheckwidth div 2), fbuttoncenter,
        (Width div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
    end;
    ocleft:
    begin
      textx :=0;// Width - (fcheckwidth + self.canvas.TextWidth(Caption) + 5);
      Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
      fbuttoncenter := (Height div 2) - (fcheckwidth div 2);
      borderect := Rect(Width - fcheckwidth, fbuttoncenter, Width, fbuttoncenter + fcheckwidth);
    end;
    ocright:
    begin
      textx := fcheckwidth + 5;
      Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
      fbuttoncenter := (Height div 2) - (fcheckwidth div 2);
      borderect := Rect(0, fbuttoncenter, fcheckwidth, fbuttoncenter + fcheckwidth);
    end;
  end;

  gradienrect1 := Rect(borderect.left + fborderWidth, borderect.top + fborderWidth,
    borderect.Right - fborderWidth, borderect.top + (borderect.Height div 2));
  gradienrect2 := Rect(gradienrect1.left, gradienrect1.Bottom, gradienrect1.Right,
    (borderect.Bottom - fborderWidth));

  checkrect := Rect(gradienrect1.left + fborderWidtht, gradienrect1.top +
    fborderWidtht, gradienrect2.Right - fborderWidtht, gradienrect2.bottom -
    fborderWidtht);

//   Drawtorect(self.Canvas,borderect,Tc,Fkind);

  with canvas do
  begin



    {  Drawtorect(self.Canvas,borderect,Tc,Fkind);
      if fchecked = True then
      Drawtorect(self.Canvas,checkrect,Tc,Fkind);
      }
      Brush.Color := oborder;
      FillRect(borderect);
      GradientFill(gradienrect1, obstart, obend, gdVertical);
      GradientFill(gradienrect2, obend, obstart, gdVertical);

      if fchecked = True then
      begin
        Brush.Color := oborder;
        FillRect(checkrect);
   //     Brush.Style := bsClear;
   //     TextOut(checkrect.Width div 2, checkrect.Height div 2 , '֍');
        checkrect := Rect(checkrect.Left + fborderWidth, checkrect.top +
          fborderWidth, checkrect.Right - fborderWidth, checkrect.Bottom - fborderWidth);
        GradientFill(checkrect, checkendstart, checkedend, gdVertical);
        //√
      end;



    if Length(Caption) > 0 then
    begin
      Brush.Style := bsClear;
      TextOut(Textx, Texty, (Caption));
    end;

  end;

end;

Procedure Tobuton.Setenterc(Val: Tocolor);
Begin
  if val<>fenter then
  begin
    fenter:=val;
    Invalidate;
  End;
End;

Procedure Tobuton.Setleavec(Val: Tocolor);
Begin
  if val<>fleave then
  begin
    fleave:=val;
    Invalidate;
  End;
End;

Procedure Tobuton.Setdownc(Val: Tocolor);
Begin
   if val<>fdown then
  begin
    fdown:=val;
    Invalidate;
  End;
End;

Procedure Tobuton.Setdisablec(Val: Tocolor);
Begin
   if val<>fdisabled then
  begin
    fdisabled:=val;
    Invalidate;
  End;
End;

Procedure Tobuton.Cmonmouseenter(Var Messages: Tmessage);
begin
  inherited;
  fstate := obenters;
  Invalidate;
  //paint;
end;

Procedure Tobuton.Cmonmouseleave(Var Messages: Tmessage);
begin
  inherited;
  fstate := obleaves;
  Invalidate;
  //paint;
end;

Procedure Tobuton.Mousedown(Button: Tmousebutton; Shift: Tshiftstate;
  X: Integer; Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    fstate := obdowns;
    Invalidate;
  end;
end;

Procedure Tobuton.Mouseup(Button: Tmousebutton; Shift: Tshiftstate; X: Integer;
  Y: Integer);
begin
  inherited;
  fstate := obenters;
  Invalidate;
end;

Constructor Tobuton.Create(Aowner: Tcomponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks, csSetCaption];
  backgroundcolored := False;
  self.Width := 120;
  self.Height := 40;
  fenter := Tocolor.Create(self);
  with fenter do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;
  fleave := Tocolor.Create(self);
  with fleave do
  begin
    border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;
  fdown := Tocolor.Create(self);
  with fdown do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;
  fdisabled := Tocolor.Create(self);
  with fdisabled do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;

  fstate := obleaves;

  // Ftext := 'Obutton';
end;

Destructor Tobuton.Destroy;
begin
  FreeAndNil(fenter);
  FreeAndNil(fleave);
  FreeAndNil(fdown);
  FreeAndNil(fdisabled);
  inherited Destroy;
end;

Procedure Tobuton.Paint;
var
  textx, Texty: integer;
  fontcolor: Tcolor;
begin
  inherited paint;

  if Enabled = False then
  begin
    Drawtorect(Self.Canvas, ClientRect, fdisabled, Fkind);
    fontcolor := fdisabled.Fontcolor;
  end
  else
  begin
    case fstate of
      obleaves:
      begin
        Drawtorect(Self.Canvas, ClientRect, fleave, Fkind);
        fontcolor := fleave.Fontcolor;
      end;
      obenters:
      begin
        Drawtorect(Self.Canvas, ClientRect, fenter, Fkind);
        fontcolor := fenter.Fontcolor;
      end;
      obdowns:
      begin
        Drawtorect(Self.Canvas, ClientRect, fdown, Fkind);
        fontcolor := fdown.Fontcolor;
      end;
    end;
  end;


  textx := (self.Width div 2) - (self.canvas.TextWidth(Caption) div 2);
  Texty := (self.Height div 2) - (self.canvas.TextHeight(Caption) div 2);

  self.Font.Color := fontcolor;
  if Length(Caption) > 0 then
  begin
    self.canvas.Brush.Style := bsClear;
    self.canvas.TextOut(Textx, Texty, Caption);
  end;
end;



{ TCollapExpandpanel }

procedure TCollapExpandpanel.SetStatus(const AValue: ToExpandStatus);
begin
  if FStatus = AValue then Exit;
  FStatus := AValue;
  if (FAutoCollapse) then ResizePanel();
end;

function TCollapExpandpanel.GetMinheight: integer;
begin
  Result := fminheight;
end;

function TCollapExpandpanel.GetNormalheight: integer;
begin
  Result := fnormalheight;
end;

procedure TCollapExpandpanel.SetAutoCollapse(const AValue: boolean);
begin
  if FAutoCollapse = AValue then Exit;
  FAutoCollapse := AValue;
  ResizePanel();
end;

procedure TCollapExpandpanel.SetOnCollapse(const AValue: TNotifyEvent);
begin
  if FOnCollapse = AValue then Exit;
  FOnCollapse := AValue;
end;

procedure TCollapExpandpanel.SetOnExpand(const AValue: TNotifyEvent);
begin
  if FOnExpand = AValue then Exit;
  FOnExpand := AValue;
end;

procedure TCollapExpandpanel.Setminheight(const Avalue: integer);
begin
  if fminheight = AValue then Exit;
  fminheight := AValue;
  Self.Constraints.MinHeight := fminheight;
end;

procedure TCollapExpandpanel.Setnormalheight(const Avalue: integer);
begin
  if fnormalheight = AValue then Exit;
  fnormalheight := AValue;
  Self.Constraints.MaxHeight := fnormalheight;
end;




procedure TCollapExpandpanel.ResizePanel();
begin
  if (FStatus = oExpanded) then
  begin
    Self.Height := Normalheight;
  end
  else
  begin
    Self.Height := Minheight;
  end;

end;

procedure TCollapExpandpanel.OnMyButtonClick(Sender: TObject);
begin

  if (FStatus = oExpanded) then
  begin
    if Assigned(FOnCollapse) then FOnCollapse(Self);
    FStatus := oCollapsed;
    FExpandButton.Caption := '▼'; //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
  end
  else
  begin
    if Assigned(FOnExpand) then FOnExpand(Self);
    FStatus := oExpanded;
    FExpandButton.Caption := '▲';//▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
  end;


  ResizePanel();

end;




procedure TCollapExpandpanel.DblClick;
var
  aPnt: TPoint;
begin
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(Rect(Background.Border, Background.Border, self.Width -
    Background.Border, fminheight - Background.Border), aPnt) then
    OnMyButtonClick(self);
end;



constructor TCollapExpandpanel.Create(Aowner: TComponent);
begin

  inherited Create(Aowner);
  parent := TWinControl(Aowner);

  ControlStyle := ControlStyle + [csAcceptsControls, csParentBackground,
    csClickEvents, csCaptureMouse, csDoubleClicks, csSetCaption];

  Width := 250;
  Height := 150;

  FStatus := oExpanded;
  FAutoCollapse := False;
  fminheight := 30;
  fnormalheight := Height;
  //  Self.Constraints.MinHeight := fminheight;

  ParentBackground := True;
  fbutondirection := obright;

  fbutonen := Tocolor.Create(self);
  with fbutonen do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
  end;
  fbutonle := Tocolor.Create(self);
  with fbutonle do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
  end;
  fbutondown := Tocolor.Create(self);
  with fbutondown do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00BD936C;
    stopcolor := clmenu;
  end;

  with Background do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
  end;

  if not Assigned(FExpandButton) then
  begin
    FExpandButton := Tobuton.Create(Self);
    with FExpandButton do
    begin
      Parent := self;
      Width := fminheight - self.Background.Border;
      Height := fminheight - self.Background.Border;
      Left := self.Width - (Width + self.Background.Border);
      top := self.Background.border + 1;
      Font.Size := 12;
      Caption := '▲'; //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
    //  Font.Name := 'Webdings';
      OnClick := @OnMyButtonClick;
      ColorDown := fbutondown;
      ColorEnter := fbutonen;
      ColorLeave := fbutonle;
    end;
  end;
end;

destructor TCollapExpandpanel.Destroy;
begin

  if Assigned(FExpandButton) then FreeAndNil(FExpandButton);
  inherited Destroy;
end;

procedure TCollapExpandpanel.paint;
var
  headerrect: TRect;
  textx, Texty: integer;
begin
  inherited paint;
  //headerrect:=Rect(Background.Border,Background.Border,self.Width-Background.Border,fminheight-Background.Border);

  headerrect := Rect(0, 0, self.Width, fminheight - Background.Border);

  //  fborderWidth:=Background.Border;

  if Height>fNormalheight then fNormalheight:=Height;

  if Assigned(FExpandButton) then
    with FExpandButton do
    begin
      Width := headerrect.Height;//-(self.Background.Border);
      Height := headerrect.Height;//-(self.Background.Border);
      if ButtonPosition = obright then
        Left := self.Width - Width
      else
        Left := 0;//self.Background.Border;

      top := 0;//self.Background.border;
    end;

  Drawtorect(self.canvas, headerrect, Background, Fkind);

  if Length(Caption) > 0 then
  begin
    canvas.Font.Color := Background.Fontcolor;
    textx := (self.Width div 2) - (self.canvas.TextWidth(Caption) div 2);
    Texty := (Minheight div 2) - (self.canvas.TextHeight(Caption) div 2);
    self.canvas.Brush.Style := bsClear;
    self.canvas.TextOut(Textx, Texty, (Caption));
  end;
  //end;
end;



{ ToListBox }




constructor tolistbox.create(aowner: tcomponent);
begin
  inherited Create(Aowner);
  parent       := TWinControl(Aowner);
  Width        := 180;
  Height       := 200;
  TabStop      := True;
  Fselectedcolor :=clblue;
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  findex       := -1;
  Flist        := TStringList.Create;
  TStringList(Flist).OnChange := @LinesChanged;
  FItemsShown  := 0;
  FitemHeight  := self.canvas.TextExtent('Çİ').cy;
  Fitemoffset  := 0;
//  FFocusedItem := -1;
  fvert := ToScrollBar.Create(self);
  with fvert do
  begin
    Parent := self;
    Kind := oVertical;
    Width := 25;
    left := Self.Width - (25 + Background.Border);
    Top := Background.Border;
    Height := Self.Height - (Background.Border * 2);
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @Scrollchange;
    Position := 0;
    Visible  := false;
  end;

end;

destructor tolistbox.destroy;
begin

  if Assigned(fvert) then
    FreeAndNil(fvert);
  if Assigned(fhorz) then
    FreeAndNil(fhorz);
    FreeAndNil(Flist);
  inherited Destroy;
end;


function tolistbox.getitemindex: integer;
begin
  Result := findex;
end;

procedure tolistbox.setitemindex(avalue: integer);
var
 Shown: integer;
begin
  if Flist.Count = 0 then exit;
  if findex = aValue then Exit;
  Shown := Height div FItemHeight;

  if (Flist.Count > 0) and (aValue >= -1) and (aValue <= Flist.Count) then
  begin
    findex := aValue;

    if (aValue < FItemOffset) then
      FItemOffset := aValue
    else if aValue > (FItemOffset + (Shown - 1)) then
      FItemOffset := ValueRange(aValue - (Shown - 1), 0, Flist.Count - Shown);
  end
  else
  begin
    findex := -1;
  end;
  Invalidate;
end;

function tolistbox.getitemat(pos: tpoint): integer;
begin
  Result := -1;
  if Pos.Y >= 0 then
  begin
    Result := FItemOffset + Pos.Y div FItemHeight;
    if (Result > Items.Count - 1) or (Result > (FItemOffset + FItemsShown) - 1) then
      Result := -1;
  end;
end;

function tolistbox.getitemheight: integer;
begin
 Result:=FitemHeight;
end;

procedure tolistbox.setitemheight(avalue: integer);
begin
 if avalue<>FitemHeight then FitemHeight:=avalue;
end;

procedure tolistbox.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
var
  ClickedItem: integer;
begin
  if button = mbLeft then
  begin
    ClickedItem := GetItemAt(Point(X, Y));
    if ClickedItem>-1 then findex:=ClickedItem;
  end;
   // Invalidate;
    SetFocus;
    Invalidate;
  inherited MouseDown(Button, Shift, X, Y);
end;


function tolistbox.domousewheeldown(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  inherited;
  if not Fvert.visible then exit;
  Fvert.Position := Fvert.Position+Mouse.WheelScrollLines;
  FItemOffset := fvert.Position;
  Result := True;
  Invalidate;
end;

// -----------------------------------------------------------------------------

function tolistbox.domousewheelup(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  inherited;
  if not Fvert.visible then exit;
  Fvert.Position := Fvert.Position-Mouse.WheelScrollLines;
  FItemOffset := fvert.Position;
  Result := True;
  Invalidate;
end;


procedure tolistbox.scrollchange(sender: tobject);
begin
  FItemOffset := fvert.Position;
  Invalidate;
end;

function tolistbox.itemrect(item: integer): trect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);

  if (Item >= FItemOffset - 1) and ((Item - FItemOffset) * FItemHeight < Height) then
  begin
    r.Top := (Item - FItemOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left := 0;

    if Assigned(fvert) and (fvert.Visible) then
      r.Right := fvert.Left
    else
      r.Right := Width;

    if Assigned(fhorz) and (fhorz.Visible) then
      r.Bottom := fhorz.Top
    else
      r.Bottom := Height;
  end;

  Result := r;
end;



procedure tolistbox.paint;
var
  a, b,i: integer;
begin
  inherited paint;
  if Flist.Count > 0 then
  begin

    FItemsShown := self.Height div FitemHeight;

    if Flist.Count-FItemsShown+1 > 0 then
    begin
       with fvert do
       begin
         Width := 25;
         left := Self.Width - (Width + Background.Border);
         Top := Background.Border;
         Height := Self.Height - (Background.Border * 2);
         Max:=Flist.Count-FItemsShown;
       end;
    end;
    //else
    //fvert.Max:=0;


    if Flist.Count * FItemHeight > self.Height then
      fvert.Visible := True
    else
      fvert.Visible := False;



    a := Background.Border;
    b := a;
    canvas.Brush.Style := bsClear;

    for i := FItemOffset to (FItemOffset + (Height) div FItemHeight) - 1 do
    begin
      if i < Flist.Count then
      begin
        if i = findex then
        begin
          canvas.Brush.Color := Fselectedcolor;
          canvas.Brush.Style := bsSolid;
          if Assigned(fvert) then
           canvas.FillRect(a, b, self.Width-(fvert.Width+ (a*2)),b + FitemHeight)
          else
          canvas.FillRect(a, b, self.Width - a,b + FitemHeight);
          Canvas.TextOut(a, b, Flist[i]);
        end
        else
        begin
          canvas.Brush.Style := bsClear;
          Canvas.TextOut(a, b, Flist[i]);
        end;
        b := b + FitemHeight;
        if (b >= Height) then Break;
      end;
    end;
  end;
end;

procedure tolistbox.beginupdate;
begin
  Flist.BeginUpdate;
end;

procedure tolistbox.endupdate;
begin
  Flist.EndUpdate;
end;


procedure tolistbox.clear;
begin
  Flist.Clear;
end;

procedure tolistbox.lineschanged(sender: tobject);
begin
 Invalidate;
end;

procedure tolistbox.keydown(var key: word; shift: tshiftstate);
var
  x: integer;
begin

  case key of
    VK_RETURN: if (Flist.Count > 0) and (findex > -1) then
      begin
 //
      end;
    VK_UP: begin
      MoveUp;
      Invalidate;
     end;
    VK_DOWN: begin
      MoveDown;
      Invalidate;
    end;
    VK_HOME: begin
      MoveHome;
      Invalidate;
    end;
    VK_END: begin
      MoveEnd;
      Invalidate;
    end;
    VK_PRIOR: if flist.Count > 0 then
      begin
        x := FItemOffset - FItemsShown;
        if x < 0 then x := 0;
        FItemOffset := x;
        findex:=x;
        Invalidate;
      end;
    VK_NEXT: if Flist.Count > 0 then
      begin
        x := FItemOffset + FItemsShown;
        if x >= flist.Count then x := Flist.Count - 1;
        if Flist.Count <= FItemsShown then
          FItemOffset := 0
        else if x > (Flist.Count - FItemsShown) then
          FItemOffset := Flist.Count - FItemsShown
        else
          FItemOffset := x;

         findex:=x;
         Invalidate;
      end;
    else
  end;
// SetFocus;
// Self.DoEnter;
//  WriteLn('ok');
inherited;
end;

procedure tolistbox.setstring(avalue: tstrings);
begin
  if Flist=AValue then Exit;
  Flist.Assign(AValue);
  // this is correct statement
//  FStrings.Assign(AValue);
  // this is not correct
  // FStrings := AValue;
end;



procedure tolistbox.moveup;
var
  Shift: boolean;
begin
  if flist.Count > 0 then
  begin
    Shift := GetKeyState(VK_SHIFT) < 0;

    if (findex > (FItemOffset + FItemsShown)) or (findex < (FItemOffset)) then
    begin
      findex := FItemOffset;
    end
    else if (findex > 0) and (findex < Flist.Count) then
    begin
      // SCROLL?????
      if ((findex - FItemOffset) = 0) and (FItemOffset > 0) then
        Dec(FItemOffset);

      Dec(findex);

    end;
    Invalidate;
  end;
end;



// -----------------------------------------------------------------------------

procedure tolistbox.movedown;
var
  Shift: boolean;
begin
  if flist.Count > 0 then
  begin
    Shift := GetKeyState(VK_SHIFT) < 0;

    if (findex > (FItemOffset + FItemsShown)) or (findex < (FItemOffset)) then
    begin
      findex := FItemOffset;
    end
    else if (findex >= 0) and (findex < Flist.Count - 1) then
    begin
      Inc(findex);
      // SCROLL?????
      if (findex - FItemOffset) > FItemsShown - 1 then
        Inc(FItemOffset);
    end;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

procedure tolistbox.movehome;
var
  i: integer;
begin
  if flist.Count > 0 then
  begin
    findex := 0;
    FItemOffset := 0;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

procedure tolistbox.moveend;
var
  i: integer;
begin
  if flist.Count > 0 then
  begin
    findex := Flist.Count - 1;
    if (Flist.Count - FItemsShown) >= 0 then
      FItemOffset := Flist.Count - FItemsShown
    else
      FItemOffset := 0;
    Invalidate;
  end;
end;

{ ToChecklistbox }



constructor tochecklistbox.create(aowner: tcomponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  Width := 180;
  Height := 200;
  TabStop := True;
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];

//  fCaptionDirection := ocleft;
  obenter := Tocolor.Create(self);
  with obenter do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  obleave := Tocolor.Create(self);
  with obleave do
  begin
    border := 2;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdown := Tocolor.Create(self);
  with obdown do
  begin
    border := 2;
    bordercolor := clSilver;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  obcheckenters := Tocolor.Create(self);
  with obcheckenters do
  begin
    border := 2;
    bordercolor := clSilver;
    startcolor := clmenu;
    stopcolor := clActiveBorder;
    Fontcolor := clBlue;
  end;

  obcheckleaves := Tocolor.Create(self);
  with obcheckleaves do
  begin
    border := 2;
    bordercolor := clSilver;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdisabled := Tocolor.Create(self);
  with obdisabled do
  begin
    border := 2;
    bordercolor := clSilver;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;
  Fbuttonheight := 10;
  findex := -1;
  FItemsShown  := 0;
  FitemHeight  := self.canvas.TextExtent('Çİ').cy;
  Fitemoffset  := 0;
  Flist := TStringList.Create;
  TStringList(Flist).OnChange := @LinesChanged;
  Fchecklist := TList.Create;
  Fstatelist := Tlist.Create;
  fvert := ToScrollBar.Create(self);
  with fvert do
  begin
    Parent := self;
    Kind := oVertical;
    Width := 25;
    left := Self.Width - (25 + Background.Border);
    Top := Background.Border;
    Height := Self.Height - (Background.Border * 2);
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @Scrollchange;
    Position := 0;
    Visible  := false;
  end;
end;

destructor tochecklistbox.destroy;
begin
  FreeAndNil(Flist);
  FreeAndNil(Fchecklist);
  FreeAndNil(Fstatelist);
  FreeAndNil(fvert);
  inherited Destroy;
end;

procedure tochecklistbox.paint;
var
  a, b, k, i,p: integer;
  gr1,gr2:TRect;//color;
  obstart,obend,oborder,checkendstart,checkedend:Tcolor;
  fborderWidth:integer;
  chechrect:Trect;
begin
  inherited paint;
  if Flist.Count > 0 then
  begin

    FItemsShown := self.Height div FitemHeight;

    if Flist.Count-FItemsShown+1 > 0 then
    begin
       with fvert do
       begin
         Width := 25;
         left := Self.Width - (Width + Background.Border);
         Top := Background.Border;
         Height := Self.Height - (Background.Border * 2);
         Max:=Flist.Count-FItemsShown;
       end;
    end;
    //else
    //fvert.Max:=0;


    if Flist.Count * FItemHeight > self.Height then
      fvert.Visible := True
    else
      fvert.Visible := False;


    Fbuttonheight:=FitemHeight-3;
    a := Background.Border;
    b := a;
    canvas.Brush.Style := bsClear;

    for i := FItemOffset to (FItemOffset + (Height) div FItemHeight) - 1 do
    begin
      if i < Flist.Count then
      begin
        Fstate:=obleaves;
        case getstatenumber(i)of
        0:Fstate:=obenters;
        1:Fstate:=obleaves;
        2:Fstate:=obdowns;
        end;



          if Enabled = False then
          begin
            obstart := obdisabled.Startcolor;
            obend := obdisabled.Stopcolor;
            oborder := obdisabled.Bordercolor;
            fborderWidth := obdisabled.Border;
            canvas.Font.Color := obdisabled.Fontcolor;
            if (IsChecked(i)) and (fstateindex=i) then
            begin
              checkendstart := obcheckenters.Startcolor;
              checkedend := obcheckenters.Stopcolor;
            end;
          end
          else
          begin
             if (IsChecked(i)) and (fstateindex=i) then
             begin
                case fstate of
                  obenters:
                  begin
                    obstart := obenter.Startcolor;
                    obend := obenter.Stopcolor;
                    checkendstart := obcheckenters.Startcolor;
                    checkedend := obcheckenters.Stopcolor;
                    oborder := obenter.Bordercolor;
                    fborderWidth := obenter.Border;
                    canvas.Font.Color := obcheckenters.Fontcolor;
                  end;
                  obleaves:
                  begin
                    obstart := obleave.Startcolor;
                    obend := obleave.Stopcolor;
                    checkendstart := obcheckleaves.Startcolor;
                    checkedend := obcheckleaves.Stopcolor;
                    oborder := obcheckleaves.Bordercolor;
                    fborderWidth := obleave.Border;
                    canvas.Font.Color := obcheckleaves.Fontcolor;
                  end;
                  obdowns:
                  begin
                    obstart := obdown.Startcolor;
                    obend := obdown.Stopcolor;
                    fborderWidth := obdown.Border;
                    oborder := obdown.Bordercolor;
                    canvas.Font.Color := obdown.Fontcolor;
                  end;
                end;
              end
              else
              begin
                case fstate of
                  obenters:
                  begin
                    obstart := obenter.Startcolor;
                    obend := obenter.Stopcolor;
                    oborder := obenter.Bordercolor;
                    fborderWidth := obenter.Border;
                    canvas.Font.Color := obenter.Fontcolor;
                  end;
                  obleaves:
                  begin
                    obstart := obleave.Startcolor;
                    obend := obleave.Stopcolor;
                    oborder := obleave.Bordercolor;
                    fborderWidth := obleave.Border;
                    canvas.Font.Color := obleave.Fontcolor;
                  end;
                  obdowns:
                  begin
                    obstart := obdown.Startcolor;
                    obend := obdown.Stopcolor;
                    oborder := obdown.Bordercolor;
                    fborderWidth := obdown.Border;
                    canvas.Font.Color := obdown.Fontcolor;
                  end;
                end;
              end;
          end;






        if i = findex then
        begin
          canvas.Brush.Color := Fselectedcolor;
          canvas.Brush.Style := bsSolid;

       //  if IsChecked(I) then
       //   a:=a+FitemHeight;

          if Assigned(fvert) then
           canvas.FillRect(a, b, self.Width-(fvert.Width+ (a*2)),b + FitemHeight)
          else
          canvas.FillRect(a, b, self.Width - a,b + FitemHeight);
        end;
        //else
       // begin     /// not selected

        //   chechrect:= Rect(fborderWidth,b,fborderWidth+FitemHeight,b+(FitemHeight));
           chechrect:= Rect(fborderWidth,b,fborderWidth+Fbuttonheight,b+(Fbuttonheight));
           canvas.Brush.Color:=oborder;
           Canvas.FillRect(chechrect);  /// for border


           // background
           gr1:=rect(fborderWidth,b+fborderWidth,Fbuttonheight,b+Fbuttonheight div 2); //FitemHeight-fborderWidth,b+(FitemHeight div 2));
           gr2:=rect(gr1.Left,gr1.Bottom,gr1.Right,gr1.Bottom+(Fbuttonheight div 2));//(FitemHeight div 2));
           canvas.GradientFill(gr1, obstart,obend, gdVertical);
           canvas.GradientFill(gr2, obend,obstart,  gdVertical);


         {  chechrect:= Rect(fborderWidth,b+fborderWidth,fborderWidth+FitemHeight,b+(FitemHeight));
           canvas.Brush.Color:=oborder;
           Canvas.FillRect(chechrect);  /// for border


           // background
           gr1:=rect(fborderWidth,b+fborderWidth,FitemHeight-fborderWidth,b+(FitemHeight div 2));
           gr2:=rect(gr1.Left,gr1.Bottom,gr1.Right,gr1.Bottom+(FitemHeight div 2));
        //    gr1:=rect(fborderWidth,b+fborderWidth,Fbuttonheight,Fbuttonheight div 2);
        //    gr2:=rect(gr1.Left,gr1.Bottom,gr1.Right,gr1.Bottom+(Fbuttonheight div 2));
           canvas.GradientFill(gr1, obstart,obend, gdVertical);
           canvas.GradientFill(gr2, obend,obstart,  gdVertical);
         }
           // if checked?
          if (IsChecked(i)) then
          begin
            chechrect:= Rect(fborderWidth*2,b+fborderWidth,fborderWidth+Fbuttonheight-fborderWidth,b+(Fbuttonheight)-fborderWidth);
            canvas.Brush.Color := oborder;
            canvas.FillRect(chechrect);

            chechrect := Rect(chechrect.Left + fborderWidth, chechrect.top +
              fborderWidth, chechrect.Right - fborderWidth, chechrect.Bottom - fborderWidth);
            canvas.GradientFill(chechrect, checkendstart, checkedend, gdVertical);
            {chechrect:= Rect(fborderWidth*2,b+5,fborderWidth+FitemHeight-5,b+(FitemHeight)-5);
            canvas.Brush.Color := oborder;
            canvas.FillRect(chechrect);

            chechrect := Rect(chechrect.Left + fborderWidth, chechrect.top +
              fborderWidth, chechrect.Right - fborderWidth, chechrect.Bottom - fborderWidth);
            canvas.GradientFill(chechrect, checkendstart, checkedend, gdVertical);
            }
            //√
          end;
       // end;

        canvas.Brush.Style := bsClear;
        Canvas.TextOut(a+(FitemHeight * 2), b, Flist[i]);

        b := b + FitemHeight;
        if (b >= Height) then Break;
      end;
    end;
  end;
end;
 
function tochecklistbox.domousewheeldown(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
end;

function tochecklistbox.domousewheelup(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
end;

function tochecklistbox.getbuttonheight: integer;
begin
  Result:=Fbuttonheight;
end;

function tochecklistbox.getitemat(pos: tpoint): integer;
begin
Result := -1;
  if Pos.Y >= 0 then
  begin
    Result := FItemOffset + Pos.Y div FItemHeight;
    if (Result > Items.Count - 1) or (Result > (FItemOffset + FItemsShown) - 1) then
      Result := -1;
  end;
end;

function tochecklistbox.getitemindex: integer;
begin
  Result := findex;
end;

function tochecklistbox.itemrect(item: integer): trect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);

  if (Item >= FItemOffset - 1) and ((Item - FItemOffset) * FItemHeight < Height) then
  begin
    r.Top := (Item - FItemOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left := 0;

    if Assigned(fvert) and (fvert.Visible) then
      r.Right := fvert.Left
    else
      r.Right := Width;

    if Assigned(fhorz) and (fhorz.Visible) then
      r.Bottom := fhorz.Top
    else
      r.Bottom := Height;
  end;

  Result := r;

end;

function tochecklistbox.checkboxrect(index: integer): trect;
begin
    Result := ItemRect( Index );
  with Result do
    begin
    //  Inc( Left , 2 );
      left:=Background.Border+1;
      Top := Top + ( ( Bottom - Top ) - FitemHeight ) div 2;
      Right := Left + FitemHeight div 2 ;
      Bottom := Top + FitemHeight;
    end;
end;



procedure tochecklistbox.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
  var
 Rect      : TRect;
begin
inherited MouseDown(Button, Shift, X, Y);
  if ( Button = mbLeft ) then
   begin
   fIndex := GetItemAt(Point( X , Y ));
    if ( fIndex > -1 ) then
    begin
      //  if MustClickInBox then  // only check click ?
       //   Rect := CheckBoxRect( Index )
       // else
      Rect := ItemRect(fIndex);  // item click
       if PtInRect( Rect , Point( X , Y ) ) then { if the user clicked inside the check box }
       begin
     	    Toggle(fIndex );
            fstateindex:=findex;
            Fstatelist.Items[findex]:=Pointer(2);
            invalidate;
       end;
    end;
  end;
end;

procedure tochecklistbox.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin

end;

procedure tochecklistbox.mouseenter;
begin

end;

procedure tochecklistbox.mousemove(shift: tshiftstate; x, y: integer);
 var
  rect:Trect;
  i: Integer;
begin
  inherited MouseMove(Shift, X, Y);

  for i:=0 to Fstatelist.Count-1 do      // clear state
  if integer(Fstatelist.Items[i])<>2 then
  Fstatelist.Items[i]:=Pointer(1);

  fstateindex := GetItemAt(point(X,Y));
  if ( fstateindex > -1 ) then
  begin
    Rect := ItemRect(fstateindex);  // item click
    if PtInRect( Rect , point(x,Y) ) then
    Fstatelist.Items[fstateindex]:=Pointer(0);
  end;
  invalidate;
end;

procedure tochecklistbox.mouseleave;
var
  i: Integer;
begin
  inherited MouseLeave;
  for i:=0 to Fstatelist.Count-1 do
  if integer(Fstatelist.Items[i])<>2 then
  Fstatelist.Items[i]:=Pointer(1);
  Invalidate;
end;

procedure tochecklistbox.scrollchange(sender: tobject);
begin
  FItemOffset := fvert.Position;
  Invalidate;
end;

procedure tochecklistbox.keydown(var key: word; shift: tshiftstate);
begin

end;

procedure tochecklistbox.setstring(avalue: tstrings);
begin
 if Flist=AValue then Exit;
  Flist.Assign(AValue);
end;

function tochecklistbox.getstatenumber(index: integer): integer;
begin
 result:= 1;
 Result := integer(Fstatelist.Items[index]);

end;

function tochecklistbox.ischecked(index: integer): boolean;
begin
    Result := Fchecklist.IndexOf(Pointer(Index)) > -1;
end;

procedure tochecklistbox.check(index: integer; achecked: boolean);
begin
  if IsChecked( Index ) <> AChecked then
    begin
      if not AChecked then
        begin
        Fchecklist.Delete( Fchecklist.IndexOf(Pointer(Index)));
        Fstatelist.Items[index]:=Pointer(1);
       end else
       begin
        Fchecklist.Add(pointer(Index));
        Fstatelist.Items[index]:=Pointer(2);
       end;

       if ( AChecked ) then
       	CheckEvent( Index )
       else
       	UnCheckEvent( Index );
     end;

end;

function tochecklistbox.getallchecked: boolean;
begin
  Result := Fchecklist.Count = Items.Count;
end;

function tochecklistbox.getnonechecked: boolean;
begin
  Result := Fchecklist.Count = 0;
end;

procedure tochecklistbox.checkevent(index: integer);
begin
  if ( Assigned( FOnCheck ) ) then
    OnCheck( Self , Index );
end;

procedure tochecklistbox.uncheckevent(index: integer);
begin
  if ( Assigned( FOnUncheck ) ) then
   OnUnCheck( Self , Index );
end;

procedure tochecklistbox.setitemindex(avalue: integer);
begin
  if Flist.Count = 0 then exit;
  if Avalue = findex then exit;
  findex := Avalue;
end;

procedure tochecklistbox.beginupdate;
begin
Flist.BeginUpdate;
end;

procedure tochecklistbox.endupdate;
begin
 Flist.EndUpdate;
end;

procedure tochecklistbox.clear;
begin
  Flist.Clear;
  Fchecklist.Clear;
end;

procedure tochecklistbox.checkselection(achecked: boolean);
var
	Index : Integer;
begin
 {   if ( SelCount > 0 ) then
      for Index := 0 to Items.Count - 1 do
  if ( Selected[ Index ] ) then
      Checked[ Index ] := AChecked;
 }
end;

procedure tochecklistbox.toggle(index: integer);
begin
 Checked[ Index ] := not Checked[ Index ];
end;

procedure tochecklistbox.checkall(achecked: boolean);
var
Index : Integer;
begin
  for Index := 0 to Items.Count - 1 do
    Checked[ Index ] := AChecked;
end;

procedure tochecklistbox.lineschanged(sender: tobject);
var
i:integer;
begin
 Fstatelist.Clear;
 for i:=0 to flist.count-1 do
 Fstatelist.Add(Pointer(1));
 Invalidate;
end;

procedure tochecklistbox.movedown;
begin

end;

procedure tochecklistbox.moveend;
begin

end;

procedure tochecklistbox.movehome;
begin

end;

procedure tochecklistbox.moveup;
begin

end;

procedure tochecklistbox.setbuttonheight(avalue: integer);
begin
if Fbuttonheight<>avalue then Fbuttonheight:=avalue;
end;





{ Tocombobox }



Function Tocombobox.Gettext: String;
begin
 if Fitemindex>-1 then
 Result := Fliste[Fitemindex]
 else
 Result:='';
end;




Procedure Tocombobox.Setitemindex(Avalue: Integer);
var
 Shown: integer;
begin
  if Fliste.Count = 0 then exit;
  if Fitemindex = aValue then Exit;
  Shown := 1;// Height div FItemHeight;

  if (Fliste.Count > 0) and (aValue >= -1) and (aValue <= Fliste.Count) then
  begin
    Fitemindex := aValue;

    if (aValue < FItemOffset) then
      FItemOffset := aValue
    else if aValue > (FItemOffset + (Shown - 1)) then
      FItemOffset := ValueRange(aValue - (Shown - 1), 0, Fliste.Count - Shown);
  end
  else
  begin
    Fitemindex := -1;
  end;
  Invalidate;
end;

Procedure Tocombobox.Setstrings(Avalue: Tstrings);
begin
  if Fliste=AValue then Exit;
  Fliste.Assign(AValue);
end;


Procedure Tocombobox.Lstpopupreturndata(Sender: Tobject; Const Str: String;
  Const Indx: Integer);
begin
  try
   self.Text:=str;
   Fedit.Text:=str;
   Fitemindex:=indx;
   Invalidate;
  except
    on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

end;

Procedure Tocombobox.Lstpopupshowhide(Sender: Tobject);
begin
  fdropdown := (Sender as Tpopupformcombobox).Visible;
  if fdropdown=true then
  Fbutton.Caption :='▲'      //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
 else
  Fbutton.Caption :='▼';     //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
  Invalidate;
end;

Procedure Tocombobox.Change;
begin
    inherited Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;

Procedure Tocombobox.Select;
begin
 if Assigned(FOnSelect) and (ItemIndex >= 0) then
    FOnSelect(Self);
end;

Procedure Tocombobox.Dropdown;
begin
  if Assigned(FOnDropDown) then FOnDropDown(Self);
end;

Procedure Tocombobox.Getitems;
begin
 if Assigned(FOnGetItems) then FOnGetItems(Self);
end;

Procedure Tocombobox.Closeup;
begin
  if [csLoading,csDestroying,csDesigning]*ComponentState<>[] then exit;
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;



Procedure Tocombobox.Kclick(Sender: Tobject);
var
 aa:Tpoint;
begin
 if Fliste.Count=0 then  exit;
  if fpopupopen=false then
  begin
   aa := ControlToScreen(Point(0, Height));
   ShowCombolistPopup(aa, @LstPopupReturndata, @LstPopupShowHide, self);
   if Assigned(FOnChange) then FOnChange(self);
   fpopupopen:=true;
  end else
  begin
    fpopupopen:=false;
  end;

end;


Procedure Tocombobox.Mousedown(Button: Tmousebutton; Shift: Tshiftstate;
  X: Integer; Y: Integer);
begin
  if button = mbLeft then
  begin
   // GetOwningForm(self).ScreenToClient(Point(xx,yy));

  //  if not (PtInRect(ClientRect,point(x, y))) then
     begin
       kclick(self);
      Invalidate;
     end;

  end;
  inherited MouseDown(Button, Shift, X, Y);
end;



Function Tocombobox.Getitemindex: Integer;
begin
 Result := Fitemindex;
end;



Procedure Tocombobox.Settext(Avalue: String);
begin

end;

Procedure Tocombobox.Setbuttonenter(Val: Tocolor);
Begin
 if Val <> fobenter then
 begin
  fobenter:=Val;
  Invalidate;

 End;
End;

Procedure Tocombobox.Setbuttonleave(Val: Tocolor);
Begin
 if Val <> fobleave then
 begin
   fobleave:=Val;
   Invalidate;
 End;
End;

Procedure Tocombobox.Setbuttondown(Val: Tocolor);
Begin
 if Val <> fobdown then
 begin
   fobdown:=Val;
   Invalidate;

 End;
End;

Procedure Tocombobox.Setbuttondisable(Val: Tocolor);
Begin
  if Val <> ffdisabled then
  begin
   ffdisabled:=Val;
   Invalidate;
  End;
End;


Procedure Tocombobox.Beginupdate;
begin
 Fliste.BeginUpdate;
end;
Procedure Tocombobox.Endupdate;
begin
Fliste.EndUpdate;
end;
Procedure Tocombobox.Clear;
begin
Fliste.Clear;
end;

Constructor Tocombobox.Create(Aowner: Tcomponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
 // backgroundcolored:=false; // do not paint oncustomcontrol
  Width := 150;
  Height := 30;

//  TabStop := True;
  Fselectedcolor :=clblue;
  ControlStyle := ControlStyle +//- [csAcceptsControls] +
    [csAcceptsControls,csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
//  fbutonarea := Rect(Width-30,0,Width,30);
  Fitemindex := -1;
  FItemHeight :=10;
  fpopupopen  :=false;
  Fliste := TStringList.Create;
  TStringList(Fliste).OnChange := @LinesChanged;



  fobenter := Tocolor.Create(self);
  with fobenter do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clBlue;
  end;

  fobleave := Tocolor.Create(self);
  with fobleave do
  begin
    border := 1;
    bordercolor := $006E6E6E;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  fobdown := Tocolor.Create(self);
  with fobdown do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clRed;
  end;

  ffdisabled := Tocolor.Create(self);
  with ffdisabled do
  begin
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;

  Fbutton := Tobuton.Create(self);
  with fbutton do
  begin
   parent := self;
   Align  := alRight;
   Width  := Height;
   OnClick :=@kclick;
   Caption :='▼';         //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
  end;

  Fedit:=Toedit.Create(self);
  with Fedit do
  begin
    Parent := Self;
    Align  := alClient;
    Enabled:= false;
    ReadOnly:=true;
  end;


end;

Destructor Tocombobox.Destroy;
begin

  if Assigned(Fbutton) then FreeAndNil(Fbutton);
  if Assigned(Fedit) then FreeAndNil(Fedit);
  if Assigned(Fliste) then FreeAndNil(Fliste);

  if Assigned(fobdown) then FreeAndNil(fobdown);
  if Assigned(fobenter) then FreeAndNil(fobenter);
  if Assigned(fobleave) then FreeAndNil(fobleave);
  if Assigned(ffdisabled) then FreeAndNil(ffdisabled);

  inherited Destroy;
end;


Procedure Tocombobox.Paint;
begin
  inherited Paint;
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(Fbutton) then
    with fbutton do
    begin
      Ocolortoocolor(Background,self.fbackground);
      Ocolortoocolor(ColorEnter,self.fobenter);
      Ocolortoocolor(ColorLeave,self.fobleave);
      Ocolortoocolor(ColorDown,self.fobdown);
      Ocolortoocolor(ColorDisable,self.ffdisabled);
      Width  := Height;
    End;
   if Assigned(Fedit) then
   begin
    Ocolortoocolor(Fedit.Background,self.fbackground);
    if Fitemindex>-1 then
    begin
    Fedit.Text:=Fliste[Fitemindex];
    Text:=Fliste[Fitemindex];
    end;
   End;

  end;
end;



Procedure Tocombobox.Lineschanged(Sender: Tobject);
begin
 Invalidate;
end;

Procedure Tocombobox.Keydown(Var Key: Word; Shift: Tshiftstate);
var
  x: integer;
begin
   inherited KeyDown(Key, Shift);
  case key of
    VK_RETURN: if (Fliste.Count > 0) and (Fitemindex > -1) then
      begin
 //
      end;
    VK_UP: begin
      MoveUp;
      Invalidate;
     end;
    VK_DOWN: begin
      MoveDown;
      Invalidate;
    end;
    VK_HOME: begin
      MoveHome;
      Invalidate;
    end;
    VK_END: begin
      MoveEnd;
      Invalidate;
    end;
    VK_PRIOR: if fliste.Count > 0 then
      begin
        x := FItemOffset - FItemsShown;
        if x < 0 then x := 0;
        FItemOffset := x;
        Fitemindex  :=x;
        Invalidate;
      end;
    VK_NEXT: if Fliste.Count > 0 then
      begin
        x := FItemOffset + FItemsShown;
        if x >= fliste.Count then x := Fliste.Count - 1;
        if Fliste.Count <= FItemsShown then
          FItemOffset := 0
        else if x > (Fliste.Count - FItemsShown) then
          FItemOffset := Fliste.Count - FItemsShown
        else
          FItemOffset := x;

         Fitemindex:=x;
        Invalidate;
      end;
    else
  end;

//inherited;
end;



Procedure Tocombobox.Moveup;
begin
  if fliste.Count > 0 then
  begin

    if (Fitemindex > (FItemOffset + FItemsShown)) or (Fitemindex < (FItemOffset)) then
    begin
      Fitemindex := FItemOffset;
    end
    else if (Fitemindex > 0) and (Fitemindex < Fliste.Count) then
    begin
      // SCROLL?????
      if ((Fitemindex - FItemOffset) = 0) and (FItemOffset > 0) then
        Dec(FItemOffset);

       Dec(Fitemindex);

    end;
  //   Invalidate;
  end;
end;

Procedure Tocombobox.Setitemheight(Avalue: Integer);
begin
  if fitemheight=avalue then exit;
  fitemheight:=avalue;
end;

// -----------------------------------------------------------------------------

Procedure Tocombobox.Movedown;
begin
  if fliste.Count > 0 then
  begin

    if (Fitemindex > (FItemOffset + FItemsShown)) or (Fitemindex < (FItemOffset)) then
    begin
      Fitemindex := FItemOffset;
    end
    else if (Fitemindex >= 0) and (Fitemindex < Fliste.Count - 1) then
    begin
      Inc(Fitemindex);
      // SCROLL?????
      if (Fitemindex - FItemOffset) > FItemsShown - 1 then
        Inc(FItemOffset);
    end;
//   Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

Procedure Tocombobox.Movehome;
var
  i: integer;
begin
  if fliste.Count > 0 then
  begin
    Fitemindex := 0;
    FItemOffset := 0;
//    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

Procedure Tocombobox.Moveend;
var
  i: integer;
begin
  if fliste.Count > 0 then
  begin
    Fitemindex := Fliste.Count - 1;
    if (Fliste.Count - FItemsShown) >= 0 then
      FItemOffset := Fliste.Count - FItemsShown
    else
      FItemOffset := 0;
//    Invalidate;
  end;
end;






{ ToSpinEdit }

procedure tospinedit.kclick(sender: tobject);
begin
  if sender=Fubutton then
       inc(fvalue)
  else if sender=Fdbutton then
       dec(fvalue);

  Settext(fvalue);
// Fedit.Text:=inttostr(fvalue);
 Invalidate;
end;

function tospinedit.getmax: integer;
begin
  result:=Fmax;
end;

function tospinedit.getmin: integer;
begin
  result:=Fmin;
end;

function tospinedit.gettext: integer;
begin
  Result:=strtointdef(Fedit.Text,0);
end;

procedure tospinedit.setbuttonheight(avalue: integer);
begin
  if Fbuttonheight<>AValue then Fbuttonheight:=AValue;
end;

procedure tospinedit.setbuttonwidth(avalue: integer);
begin
   if Fbuttonwidth<>AValue then Fbuttonwidth:=AValue;
end;

procedure tospinedit.setmax(avalue: integer);
begin
 if Fmax<>AValue then Fmax:=AValue;
end;

procedure tospinedit.setmin(avalue: integer);
begin
 if Fmin<>AValue then Fmin:=AValue;
end;

procedure tospinedit.settext(avalue: integer);
begin
 fvalue:=Avalue;//ValueRange(fvalue,fmin,fmax);
 if fedit.Text<>'' then
  fedit.Text:=IntToStr(fvalue)
 else
 fedit.Text:='0';//IntToStr(fvalue)

 Changed;
 if Assigned(FOnChange) then FOnChange(Self);
end;

procedure tospinedit.keydown(sender: tobject; var key: word; shift: tshiftstate
  );
begin
 inherited KeyDown(Key, Shift);
 if Key=VK_UP then
 Inc(fvalue)
 else
 if Key=VK_DOWN then
 dec(fvalue);


  if (key=VK_UP) or (key=VK_DOWN) then
  Settext(fvalue);
end;

procedure tospinedit.resize;
begin
 if self.Width<20 then self.Width:=20;
 if Assigned(Fubutton) then
   fubutton.SetBounds((self.Width-(Fbuttonwidth+(self.Background.Border*2))),self.Background.Border,Fbuttonwidth,Fbuttonheight);

 if Assigned(Fdbutton) then
   fdbutton.SetBounds((self.Width-(Fbuttonwidth+(self.Background.Border*2))),self.Height-(Fbuttonheight+self.Background.Border),Fbuttonwidth,Fbuttonheight);


  if Assigned(Fedit) then
  with Fedit do
  begin
   Width  := self.Width-(Fubutton.Width+self.Background.Border);
   Height := self.Height-(self.Background.Border *2);
   Left   := self.Background.Border;
   top    := self.Background.Border;
  end;
end;

constructor tospinedit.create(aowner: tcomponent);
begin
  inherited Create(AOwner);
   Backgroundcolored:=False;
  parent := TWinControl(Aowner);
  Width := 100;
  Height := 25;

  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];

  Fbuttonwidth  := 15;
  Fbuttonheight := 15;


  fubutton := Tobuton.Create(self);
  with fubutton do
  begin
   parent := self;
   Width  := self.Height div 2;
   Height := Width;
   Left   := self.Width-(Width+self.Background.Border);
   top    := self.Background.Border;
   OnClick :=@kclick;
   Caption :='▲';     //► ◄ ▲ ▼  // ALT+30 ALT+31 ALT+16 ALT+17
  end;


  Fdbutton := Tobuton.Create(self);
  with Fdbutton do
  begin
   parent := self;
   Width  := self.Height div 2;
   Height := Width;
   Left   := self.Width-(Width+self.Background.Border);
   top    := fdbutton.Height+self.Background.Border;
   OnClick :=@kclick;
   Caption :='▼';
  end;

  Fedit:=Toedit.Create(self);
  with Fedit do
  begin
    Parent := Self;
   Enabled:= true;
   Width  := self.Width-(Fubutton.Width+self.Background.Border);
   Height := self.Height-(self.Background.Border *2);
   Left   := self.Background.Border;
   top    := self.Background.Border;
   text   := '0';
   NumberOnly:=true;
   onChange:=@Feditchange;
  end;
  fedit.onKeyDown :=@KeyDown;

 fmin := 0;
 fmax := 0;
 fvalue:= 0;
end;

destructor tospinedit.destroy;
begin
  if Assigned(Fedit) then FreeAndNil(Fedit);
  if Assigned(Fdbutton) then FreeAndNil(Fdbutton);
  if Assigned(Fubutton) then FreeAndNil(Fubutton);
  inherited Destroy;
end;

procedure tospinedit.feditchange(sender: tobject);
begin
 if Fedit.Text='' then Fedit.Text:='0';
  fvalue:=StrToIntDef(Fedit.Text,0);
  if Assigned(Fonchange) then Fonchange(self);
end;

function tospinedit.getbuttonheight: integer;
begin
  Result:=Fbuttonheight;
end;

function tospinedit.getbuttonwidth: integer;
begin
  Result:=Fbuttonwidth;
end;

procedure tospinedit.paint;
begin
  inherited Paint;
end;




Constructor ToBalloonControl.Create(AOwner: TComponent);
Begin
	Inherited;

	FText := TStringList.Create;
End;

Destructor ToBalloonControl.Destroy;
Begin
	FText.Free;

	Inherited;
End;

procedure ToBalloonControl.SetText(Value: TStringList);
begin
  FText.Assign(Value);
end;

Procedure ToBalloonControl.ShowControlBalloon();
Var
	Balloon: TBalloon;
Begin
	Balloon := TBalloon.CreateNew(Owner);
	Balloon.ShowControlBalloon(FControl, FHorizontal, FVertical, FTitle, Trim(FText.Text), FBalloonType, FDuration);
End;

Procedure ToBalloonControl.ShowPixelBalloon();
Var
	Balloon: TBalloon;
Begin
	Balloon := TBalloon.CreateNew(nil);
	Balloon.ShowBalloon(FPixelCoordinateX, FPixelCoordinateY, FTitle, Trim(FText.Text), FBalloonType, FDuration, FPosition);
End;

Procedure TBalloon.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);

  Params.Style     := (Params.Style and not WS_CAPTION) or WS_POPUP;
  Params.ExStyle   := Params.ExStyle or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE or WS_EX_TOPMOST;
  Params.WndParent := GetDesktopWindow;
End;

Procedure TBalloon.OnMouseClick(Sender: TObject);
Begin
  Release;
End;

Procedure TBalloon.OnExitTimer(Sender: TObject);
Begin
  Release;
End;

Procedure TBalloon.OnChange(Sender: TObject);
Begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
End;

Procedure TBalloon.WndProc(Var Message: TMessage);
Begin
  If (Message.Msg = WM_SIZE) and (Message.WParam = SIZE_MINIMIZED) Then
    Show;

  Inherited;
End;

Constructor TBalloon.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
Begin
  Inherited;

  OnActivate   := @OnChange;
  OnDeactivate := @OnChange;
  OnShow       := @OnChange;
  BorderStyle  := bsNone;
  FormStyle    := fsStayOnTop;
  OnPaint      := @FormPaint;
  Color        := $0034A831;
  Font.Name    := 'calibri';

  pnlAlign   := TPanel.Create(Self);
  lblTitle   := TLabel.Create(Self);
  lblText    := TLabel.Create(Self);
  iconBitmap := TImage.Create(Self);
  tmrExit    := TTimer.Create(Self);

  OnClick          := @OnMouseClick;
  iconBitmap.OnClick := @OnMouseClick;
  pnlAlign.OnClick := @OnMouseClick;
  lblTitle.OnClick := @OnMouseClick;
  lblText.OnClick  := @OnMouseClick;

  lblTitle.Parent      := Self;
  lblTitle.ParentColor := True;
  lblTitle.ParentFont  := True;
  lblTitle.AutoSize    := True;
  lblTitle.Font.Style  := [fsBold];
  lblTitle.Left        := 34;
  lblTitle.Top         := 12;

  lblText.Parent      := Self;
  lblText.ParentColor := True;
  lblText.ParentFont  := True;
  lblText.AutoSize    := True;
  lblText.Left        := 10;
  lblText.WordWrap    := True;

  iconBitmap.Parent      := Self;
  iconBitmap.Transparent := True;
  iconBitmap.Left        := 10;
  iconBitmap.Top         := 10;

  tmrExit.Enabled  := False;
  tmrExit.Interval := 0;
  tmrExit.OnTimer  := @OnExitTimer;
End;

Procedure TBalloon.FormPaint(Sender: TObject);
Var
  TempRegion: HRGN;
Begin
  With Canvas.Brush Do
   Begin
    Color := clBlack;
    Style := bsSolid;
   End;

  TempRegion := CreateRectRgn(0,0,1,1);
  GetWindowRgn(Handle, TempRegion);
  FrameRgn(Canvas.Handle, TempRegion, Canvas.Brush.handle, 1, 1);
  DeleteObject(TempRegion);
End;

Procedure TBalloon.ShowControlBalloon(blnControl: TWinControl; blnHoriz: TBalloonHoriz; blnVert: TBalloonVert; blnTitle, blnText: String; blnType: TBalloonType; blnDuration: Integer);
Var
  Rect: TRect;
  blnPosLeft, blnPosTop: Integer;
  blnPosition: TBalloonPosition;
Begin

  GetWindowRect(blnControl.Handle, Rect);

  blnPosTop  := 0;
  blnPosLeft := 0;

  If blnVert = blnTop Then
    blnPosTop := Rect.Top;

  If blnVert = blnCenter Then
    blnPosTop := Rect.Top + Round((Rect.Bottom - Rect.Top) / 2);

  If blnVert = blnBottom Then
    blnPosTop := Rect.Bottom;

  If blnHoriz = blnLeft Then
    blnPosLeft := Rect.Left;

  If blnHoriz = blnMiddle Then
    blnPosLeft := Rect.Left + Round((Rect.Right - Rect.Left) / 2);

  If blnHoriz = blnRight Then
    blnPosLeft := Rect.Right;

  blnPosition := blnArrowBottomRight;

  If ((blnHoriz = blnRight) and (blnVert = blnBottom)) or ((blnHoriz = blnMiddle) and (blnVert = blnBottom)) Then
    blnPosition := blnArrowBottomRight;

  If (blnHoriz = blnLeft) and (blnVert = blnBottom) or ((blnHoriz = blnLeft) and (blnVert = blnCenter)) Then
    blnPosition := blnArrowBottomLeft;

  If (blnHoriz = blnLeft) and (blnVert = blnTop) or ((blnHoriz = blnMiddle) and (blnVert = blnTop)) Then
    blnPosition := blnArrowTopLeft;

  If (blnHoriz = blnRight) and (blnVert = blnTop) or ((blnHoriz = blnRight) and (blnVert = blnCenter)) Then
    blnPosition := blnArrowTopRight;

  ShowBalloon(blnPosLeft, blnPosTop, blnTitle, blnText, blnType, blnDuration, blnPosition);
End;

Procedure TBalloon.ShowBalloon(blnLeft, blnTop: Integer; blnTitle, blnText: String; blnType: TBalloonType; blnDuration: Integer; blnPosition: TBalloonPosition);
Var
  ArrowHeight, ArrowWidth: Integer;
  FormRegion, ArrowRegion: HRGN;
  Arrow: Array [0..2] Of TPoint;
  ResName: String;
Begin
  ArrowHeight := 20;
  ArrowWidth  := 20;

  lblTitle.Caption := blnTitle;

  If blnPosition = blnArrowBottomRight Then
    lblTitle.Top := lblTitle.Top + ArrowHeight;

  If blnPosition = blnArrowBottomLeft Then
    lblTitle.Top := lblTitle.Top + ArrowHeight;

  lblText.Top     := lblTitle.Top + lblTitle.Height + 8;
  lblText.Caption := UTF8UpperCase(blnText,'tr');

  If blnPosition = blnArrowBottomRight Then
    iconBitmap.Top := iconBitmap.Top + ArrowHeight;

  If blnPosition = blnArrowBottomLeft Then
    iconBitmap.Top := iconBitmap.Top + ArrowHeight;

  Case blnType Of
    blnError:
      ResName := 'ERROR';
    blnInfo:
      ResName := 'INFO';
    blnWarning:
      ResName := 'WARNING';
    Else
      ResName := 'INFO';
   End;
  iconBitmap.Picture.Bitmap.LoadFromResourceName(HInstance, ResName);

  If blnPosition = blnArrowBottomRight Then
    ClientHeight := lblText.Top + lblText.Height + 10;
  If blnPosition = blnArrowBottomLeft Then
    ClientHeight := lblText.Top + lblText.Height + 10;
  If blnPosition = blnArrowTopLeft Then
    ClientHeight := lblText.Top + lblText.Height + 10 + ArrowHeight;
  If blnPosition = blnArrowTopRight Then
    ClientHeight := lblText.Top + lblText.Height + 10 + ArrowHeight;

  If (lblTitle.Left + lblTitle.Width) > (lblText.Left + lblText.Width) Then
    Width := lblTitle.Left + lblTitle.Width + 10
  Else
    Width := lblText.Left + lblText.Width + 10;

  If blnPosition = blnArrowTopLeft Then
   Begin
    Left := blnLeft - (Width - 20);
    Top  := blnTop - (Height);
   End;

  If blnPosition = blnArrowTopRight Then
   Begin
    Left := blnLeft - 20;
    Top  := blnTop - (Height);
   End;

  If blnPosition = blnArrowBottomRight Then
   Begin
    Left := blnLeft - 20;
    Top  := blnTop - 2;
   End;

  If blnPosition = blnArrowBottomLeft Then
   Begin
    Left := blnLeft - (Width - 20);
    Top  := blnTop - 2;
   End;

  FormRegion := 0;

  If blnPosition = blnArrowTopLeft Then
   Begin
    FormRegion := CreateRoundRectRgn(0, 0, Width, Height - (ArrowHeight - 2), 7, 7);

    Arrow[0] := Point(Width - ArrowWidth - 20, Height - ArrowHeight);
    Arrow[1] := Point(Width - 20, Height);
    Arrow[2] := Point(Width - 20, Height - ArrowHeight);
   End;

  If blnPosition = blnArrowTopRight Then
   Begin
    FormRegion := CreateRoundRectRgn(0, 0, Width, Height - (ArrowHeight - 2), 7, 7);

    Arrow[0] := Point(20, Height - ArrowHeight);
    Arrow[1] := Point(20, Height);
    Arrow[2] := Point(20 + ArrowWidth, Height - ArrowHeight);
   End;

  If blnPosition = blnArrowBottomRight Then
   Begin
    FormRegion := CreateRoundRectRgn(0, ArrowHeight + 2, Width, Height, 7, 7);

    Arrow[0] := Point(20, 2);
    Arrow[1] := Point(20, ArrowHeight + 2);
    Arrow[2] := Point(20 + ArrowWidth, ArrowHeight + 2);
   End;

  If blnPosition = blnArrowBottomLeft Then
   Begin
    FormRegion := CreateRoundRectRgn(0, ArrowHeight + 2, Width, Height, 7, 7);

    Arrow[0] := Point(Width - 20, 2);
    Arrow[1] := Point(Width - 20, ArrowHeight + 2);
    Arrow[2] := Point(Width - 20 - ArrowWidth, ArrowHeight + 2);
   End;

  ArrowRegion := CreatePolygonRgn(Arrow, 3, WINDING);

  CombineRgn(FormRegion, FormRegion, ArrowRegion, RGN_OR);
  DeleteObject(ArrowRegion);
  SetWindowRgn(Handle, FormRegion, True);

  Visible := False;
  ShowWindow(Handle, SW_SHOWNOACTIVATE);
  Visible := True;

  tmrExit.Interval := blnDuration * 1000;
  tmrExit.Enabled  := True;
End;




{ Toswich }

function Toswich.GetChecWidth: integer;
begin
  Result:=fcheckwidth;
end;

procedure Toswich.SetChecWidth(AValue: integer);
begin
 if fcheckwidth=avalue then exit;
 fcheckwidth:=AValue;
 Invalidate;
end;

procedure Toswich.SetState(const Value: Tobutonstate);
begin
  if fstate=value then exit;
 fstate:=Value;
 Invalidate;
end;

function Toswich.GetState: Tobutonstate;
begin
Result:=fstate;
end;

procedure Toswich.SetSwState(const Value: ToswichState);
begin
 if fswichstate=value then exit;
 fswichstate:=Value;
 Invalidate;
end;

function Toswich.GetSwState: ToswichState;
begin
Result:=fswichstate;
end;


procedure Toswich.cmonmouseenter(var messages: tmessage);
begin
  fstate := obenters;
  Invalidate;
end;

procedure Toswich.cmonmouseleave(var messages: tmessage);
begin
  fstate := obleaves;

  Invalidate;
end;

procedure Toswich.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin

    fState := obdowns;
    if fswichstate= fon then
   fswichstate:=foff else
   fswichstate:=fon;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end;
end;

procedure Toswich.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  state := obenters;
  Invalidate;
end;


procedure Toswich.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
 SetBkMode(Message.dc, 1);
 Message.Result := 1;
end;

procedure Toswich.CreateParams(var Params: TCreateParams);
begin
    inherited;// CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or
   {$IFNDEF UNIX}WS_EX_LAYERED or{$ENDIF}
    WS_CLIPCHILDREN;
end;

procedure Toswich.CMHittest(var msg: TCMHIttest);
begin
  inherited;
  //  if csDesigning in ComponentState then
  //    Exit;
  if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;


procedure Toswich.DoOnChange;
begin
 EditingDone;
 if Assigned(OnChange) then OnChange(Self);
end;

constructor Toswich.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks, csSetCaption];
  Width := 100;
  Height := 20;
  fcheckwidth := 20;
  froundx:=10;
  froundy:=10;

   fswichstate:=foff;
  //fCaptionDirection:=cleft;
  obenter := Tocolor.Create(self);
  with obenter do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := $00CDCDCD;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obleave := Tocolor.Create(self);
  with obleave do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clActiveBorder;
    stopcolor := clmenu;
    Fontcolor := clblack;
  end;

  obdown := Tocolor.Create(self);
  with obdown do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $00A0A0A0;
    Fontcolor := clblack;
  end;

  obdisabled := Tocolor.Create(self);
  with obdisabled do
  begin
    // Aownerr:=self;
    border := 1;
    bordercolor := clblack;
    startcolor := clmenu;
    stopcolor := $005D5D5D;
    Fontcolor := $002C2C2C;
  end;



  fstate := obleaves;
  backgroundcolored := False;
  fcaptionon:='ON';
  fcaptionoff:='OFF';

  // Transparent := True;
end;

destructor Toswich.Destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  inherited Destroy;
end;







procedure Toswich.paint;
var
  gradienrect1, gradienrect2, borderect,checkrect: Types.Trect;
  textxon, textxoff, Texty, fborderWidth, fborderWidthT: integer;
  obstart, obend,checkendstart,checkedend ,oborder: Tcolor;

  fbuttoncenter: integer;

begin
  inherited paint;

  // com:=self;

  if Enabled = False then
  begin
    obstart := obdisabled.Startcolor;
    obend := obdisabled.Stopcolor;
    oborder := obdisabled.Bordercolor;
    fborderWidth := obdisabled.Border;
    canvas.Font.Color := obdisabled.Fontcolor;

  end
  else
  begin
  {  if fswichstate = fon then
    begin

      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          checkendstart := obcheckenters.Startcolor;
          checkedend := obcheckenters.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obcheckenters.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          checkendstart := obcheckleaves.Startcolor;
          checkedend := obcheckleaves.Stopcolor;
          oborder := obcheckleaves.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obcheckleaves.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          fborderWidth := obdown.Border;
          oborder := obdown.Bordercolor;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;
    end
    else}
    begin
      case fstate of
        obenters:
        begin
          obstart := obenter.Startcolor;
          obend := obenter.Stopcolor;
          oborder := obenter.Bordercolor;
          fborderWidth := obenter.Border;
          canvas.Font.Color := obenter.Fontcolor;
        end;
        obleaves:
        begin
          obstart := obleave.Startcolor;
          obend := obleave.Stopcolor;
          oborder := obleave.Bordercolor;
          fborderWidth := obleave.Border;
          canvas.Font.Color := obleave.Fontcolor;
        end;
        obdowns:
        begin
          obstart := obdown.Startcolor;
          obend := obdown.Stopcolor;
          oborder := obdown.Bordercolor;
          fborderWidth := obdown.Border;
          canvas.Font.Color := obdown.Fontcolor;
        end;
      end;

    end;
  end;

  fborderWidthT := fborderWidth + 2;
  textxon :=fborderWidtht;// Width - (fcheckwidth + self.canvas.TextWidth(Caption) + 5);
  textxoff:= Width - (self.canvas.TextWidth(fCaptionOff) + 5);
  Texty := (Height div 2) - (self.canvas.TextHeight(fcaptionon) div 2);
  //  fbuttoncenter := (Height div 2) - (fcheckwidth div 2);

  borderect := Rect(0,0,Width ,Height);


  {gradienrect1 := Rect(borderect.left + fborderWidth, borderect.top + fborderWidth,
    borderect.Right - fborderWidth, borderect.top + (borderect.Height div 2));
  gradienrect2 := Rect(gradienrect1.left, gradienrect1.Bottom, gradienrect1.Right,
    (borderect.Bottom - fborderWidth));
  }
  if fswichstate = fon then
   checkrect := Rect(borderect.left + fborderWidth, borderect.top +
    fborderWidth, borderect.Right div 2, borderect.bottom -
    fborderWidth)
  else
   checkrect := Rect(borderect.Right div 2 , borderect.top +
    fborderWidth, borderect.Right - fborderWidth, borderect.bottom -
    fborderWidth);
//   Drawtorect(self.Canvas,borderect,Tc,Fkind);

  with canvas do
  begin



    {  Drawtorect(self.Canvas,borderect,Tc,Fkind);
      if fchecked = True then
      Drawtorect(self.Canvas,checkrect,Tc,Fkind);
      }
      pen.Color := oborder;
      Pen.Width:=fborderWidth;
      Brush.Color:=obend;//oborder;
     //  FillRect(borderect);
      //GradientFill(gradienrect1, obstart, obend, gdVertical);
      //GradientFill(gradienrect2, obend, obstart, gdVertical);
      RoundRect(borderect,froundx,froundy);    // arkaplan

      pen.Color := obstart;
      Pen.Width:=0;
      Brush.Color := obstart;
     // FloodFill(0,0,obstart,fsSurface);
      RoundRect(checkrect,froundx,froundy);

      checkrect:=rect(checkrect.left-fborderWidth,checkrect.top-fborderWidth,checkrect.Right+fborderWidth,checkrect.Bottom+fborderWidth);
      pen.Color := oborder;
      Pen.Width:=fborderWidth;
      RoundRect(checkrect,froundx,froundy);
    {  if fchecked = True then
      begin
        Brush.Color := oborder;
        FillRect(checkrect);
   //     Brush.Style := bsClear;
   //     TextOut(checkrect.Width div 2, checkrect.Height div 2 , '֍');
        checkrect := Rect(checkrect.Left + fborderWidth, checkrect.top +
          fborderWidth, checkrect.Right - fborderWidth, checkrect.Bottom - fborderWidth);
        GradientFill(checkrect, checkendstart, checkedend, gdVertical);
        //√
      end;
      }



    if Length(fcaptionoff) > 0 then
    begin
      Brush.Style := bsClear;
      TextOut(textxoff, Texty, (fCaptionoff));
    end;
    if Length(fcaptionon) > 0 then
    begin
      Brush.Style := bsClear;
    //  canvas.Font.Color:=;
      TextOut(textxon, Texty, (fCaptionon));
    end;
  end;

end;



procedure TSimbaEdit.SetHintText(Value: String);
begin
  if (FHintText = Value) then
    Exit;
  FHintText := Value;

  Invalidate();
end;

procedure TSimbaEdit.SetHintTextColor(Value: TColor);
begin
  if (FHintTextColor = Value) then
    Exit;
  FHintTextColor := Value;

  Invalidate();
end;

procedure TSimbaEdit.SetHintTextStyle(Value: TFontStyles);
begin
  if (FHintTextStyle = Value) then
    Exit;
  FHintTextStyle := Value;

  Invalidate();
end;

procedure TSimbaEdit.ClearCache;
var
  Cache: EPaintCache;
begin
  for Cache in EPaintCache do
  begin
    FTextWidthCache[Cache].Str   := '';
    FTextWidthCache[Cache].Width := 0;
  end;
end;

procedure TSimbaEdit.CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer; WithThemeSpace: Boolean);
begin
  inherited CalculatePreferredSize(PreferredWidth, PreferredHeight, WithThemeSpace);

  PreferredHeight := CalculateHeight();
end;

procedure TSimbaEdit.WMSetFocus(var Message: TLMSetFocus);
begin
  inherited;

  FCaretTimer.Enabled := True;
  Invalidate();
end;

procedure TSimbaEdit.WMKillFocus(var Message: TLMKillFocus);
begin
  inherited;

  FCaretTimer.Enabled := False;
  Invalidate();
end;

function TSimbaEdit.GetTextWidthCache(const Cache: EPaintCache; const Str: String): Integer;
begin
  if (Str <> FTextWidthCache[Cache].Str) then
  begin
    FTextWidthCache[Cache].Str := Str;
    FTextWidthCache[Cache].Width := Canvas.TextWidth(Str);
  end;

  Result := FTextWidthCache[Cache].Width;
end;

procedure TSimbaEdit.SelectAll;
begin
  FSelectingStartX := 0;
  FSelectingEndX   := Length(Text);

  Invalidate();
end;

procedure TSimbaEdit.ClearSelection;
begin
  FSelectingStartX := 0;
  FSelectingEndX := 0;
end;

function TSimbaEdit.GetSelectionLen: Integer;
begin
  Result := Abs(FSelectingStartX - FSelectingEndX);
end;

function TSimbaEdit.HasSelection: Boolean;
begin
  Result := GetSelectionLen > 0;
end;

function TSimbaEdit.CharIndexAtXY(X, Y: Integer): Integer;
var
  I, Test: Integer;
  W: Integer;
begin
  Result := Length(Text);

  Test := FDrawOffsetX;
  for I := 1 to Length(Text) do
  begin
    W := Canvas.TextWidth(Text[I]);
    Test += W;
    if ((Test-(W div 2)) >= X) then
    begin
      Result := I-1;
      Exit;
    end;
  end;
end;

function TSimbaEdit.CalculateHeight: Integer;
begin
  with TBitmap.Create() do
  try
    Canvas.Font := Self.Font;
    Canvas.Font.Size := GetFontSize(Self, 1);

    Result := Canvas.TextHeight('Tay') + (BorderWidth * 2);
  finally
    Free();
  end;
end;

function TSimbaEdit.GetAvailableWidth: Integer;
begin
  Result := Width - (BorderWidth * 4);
end;

function TSimbaEdit.GetSelectedText: String;
begin
  if (FSelectingStartX > FSelectingEndX) then
    Result := Copy(Text, FSelectingEndX + 1, FSelectingStartX - FSelectingEndX)
  else
    Result := Copy(Text, FSelectingStartX + 1, FSelectingEndX - FSelectingStartX);
end;

procedure TSimbaEdit.AddCharAtCursor(C: Char);
var
  NewText: String;
begin
  if (Ord(C) < 32) then
    Exit;

  if HasSelection then
    DeleteSelection();

  Inc(FCaretX);
  NewText := Text;
  Insert(C, NewText, FCaretX);
  Text := NewText;
end;

procedure TSimbaEdit.AddStringAtCursor(Str: String; ADeleteSelection: Boolean);
var
  NewText: String;
begin
  if ADeleteSelection then
    DeleteSelection();

  NewText := Text;

  Insert(Str, NewText, FCaretX + 1);
  Inc(FCaretX, Length(Str));

  Text := NewText;
end;

procedure TSimbaEdit.DeleteCharAtCursor;
var
  NewText: String;
begin
  if (FCaretX >= 1) and (FCaretX <= Length(Text)) then
  begin
    NewText := Text;

    Delete(NewText, FCaretX, 1);
    Dec(FCaretX);

    Text := NewText;
  end;
end;

procedure TSimbaEdit.DeleteSelection;
var
  NewText: String;
begin
  if HasSelection() then
  begin
    NewText := Text;

    if (FSelectingStartX > FSelectingEndX) then
      Delete(NewText, FSelectingEndX + 1, GetSelectionLen())
    else
      Delete(NewText, FSelectingStartX + 1, GetSelectionLen());

    if (FSelectingEndX > FSelectingStartX) then
      SetCaretPos(FCaretX - GetSelectionLen());
    Text := NewText;
    ClearSelection();
  end;
end;

procedure TSimbaEdit.DoCaretTimer(Sender: TObject);
begin
  Invalidate();
end;

procedure TSimbaEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  if FSelecting then
  begin
    SetCaretPos(CharIndexAtXY(X, Y));

    FSelectingEndX := CharIndexAtXY(X, Y);

    Invalidate();
  end;
end;

procedure TSimbaEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if CanSetFocus() then
    SetFocus();

  I := CharIndexAtXY(X, Y);

  SetCaretPos(I);

  FSelecting := True;
  FSelectingStartX := I;
  FSelectingEndX := I;
end;

procedure TSimbaEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  FSelecting := False;
  FSelectingEndX := CharIndexAtXY(X, Y);
end;

procedure TSimbaEdit.ParentFontChanged;
begin
  inherited ParentFontChanged;

  if Assigned(Parent) then
  begin
    Font.BeginUpdate();
    Font := Parent.Font;
 //   Font.Color := ColorFont;
    Font.EndUpdate();
  end;
end;

procedure TSimbaEdit.SetCaretPos(Pos: Integer);
begin
  if (Pos < 0) then
    FCaretX := 0
  else
  if (Pos > Length(Text)) then
    FCaretX := Length(Text)
  else
    FCaretX := Pos;

  Invalidate();
end;

procedure TSimbaEdit.FontChanged(Sender: TObject);
var
  NewHeight: Integer;
begin
  inherited FontChanged(Sender);

  NewHeight := CalculateHeight();

  Constraints.MinHeight := NewHeight;
  Constraints.MaxHeight := NewHeight;

  ClearCache();
end;

procedure TSimbaEdit.TextChanged;
begin
  inherited TextChanged();

  if Assigned(OnChange) then
    OnChange(Self);

  Invalidate();
end;

procedure TSimbaEdit.Paint;

  function IsCaretVisible: Boolean;
  begin
    Result := InRange(FDrawOffsetX + GetTextWidthCache(EPaintCache.CARET_VISIBLE, Copy(Text, 1, FCaretX)), 0, Width);
  end;

var
  Style: TTextStyle;
  OldFontStyles: TFontStyles;
  OldFontColor: TColor;
  TextWidth: Integer;
  X1, X2: Integer;
  DrawCaretX: Integer;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  Style := Canvas.TextStyle;
  Style.Layout := tlCenter;

  // Text
  if (Text <> '') then
  begin
    TextWidth := GetTextWidthCache(EPaintCache.TEXT, Copy(Text, 1, FCaretX));

    if (not IsCaretVisible()) then
    begin
      if (TextWidth > Width) then
        FDrawOffsetX := -(TextWidth - GetAvailableWidth()) + (BorderWidth*2)
      else
        FDrawOffsetX := 0;
    end;

    if (FDrawOffsetX = 0) then
      FDrawOffsetX := (BorderWidth * 2);

    // Selection
    if HasSelection() then
    begin
      if (FSelectingStartX > FSelectingEndX) then
      begin
        X1 := FSelectingEndX;
        X2 := FSelectingStartX;
      end else
      if (FSelectingStartX < FSelectingEndX) then
      begin
        X1 := FSelectingStartX;
        X2 := FSelectingEndX;
      end else
      begin
        X1 := FSelectingStartX;
        X2 := FSelectingStartX + 1;
      end;

      X1 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_START, Copy(Text, 1, FSelectingStartX));
      X2 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_END,   Copy(Text, 1, FSelectingEndX));

      Canvas.Brush.Color := FColorSelection;
      Canvas.FillRect(X1, BorderWidth, X2, Height - BorderWidth);
    end;

    Canvas.TextRect(ClientRect, FDrawOffsetX, 0, Text, Style);
    Canvas.Brush.Color := Color;
    Canvas.FillRect(0, 0, 2, Height);
    Canvas.FillRect(Width - 2, 0, Width, Height);
  end else
  if (FHintText <> '') then
  begin
    OldFontColor  := Canvas.Font.Color;
    OldFontStyles := Canvas.Font.Style;

    Canvas.Font.Color := FHintTextColor;
    Canvas.Font.Style := FHintTextStyle;

    Canvas.TextRect(ClientRect, BorderWidth*2, 0, FHintText, Style);

    Canvas.Font.Color := OldFontColor;
    Canvas.Font.Style := OldFontStyles;
  end;

  if Focused then
  begin
    // Caret
    if FCaretTimer.Enabled then
    begin
      Inc(FCaretFlash);
      if Odd(FCaretFlash) then
        Canvas.Pen.Color := clWhite
      else
        Canvas.Pen.Color := clBlack;

      Canvas.Pen.Mode := pmXor;

      if (Text = '') then
        DrawCaretX := (BorderWidth * 2)
      else
        DrawCaretX := (FDrawOffsetX + TextWidth) - 1;

      Canvas.Line(DrawCaretX, BorderWidth, DrawCaretX, Height - BorderWidth);
    end;

    Canvas.Brush.Color := ColorBorderActive;
  end else
    Canvas.Brush.Color := ColorBorder;

  Canvas.FrameRect(0, 0, Width, Height);
end;

procedure TSimbaEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if (ssCtrl in Shift) then
    case Key of
      VK_A:
        begin
          SelectAll();

          Key := 0;
        end;

      VK_V:
        begin
          AddStringAtCursor(Clipboard.AsText, True);

          Key := 0;
        end;

      VK_C:
        begin
          Clipboard.AsText := GetSelectedText();

          Key := 0;
        end;
    end;

  case Key of
    VK_BACK:
      begin
        if HasSelection() then
          DeleteSelection()
        else
          DeleteCharAtCursor();

        Key := 0;
      end;

    VK_LEFT:
      begin
        SetCaretPos(FCaretX-1);

        Key := 0;
      end;

    VK_RIGHT:
      begin
        SetCaretPos(FCaretX+1);

        Key := 0;
      end;

    VK_DELETE:
      begin
        DeleteSelection();

        Key := 0;
      end;
  end;
end;

procedure TSimbaEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  AddCharAtCursor(Key);

  Key := #0;
end;

procedure TSimbaEdit.UTF8KeyPress(var UTF8Key: TUTF8Char);
begin
  inherited UTF8KeyPress(UTF8Key);

  AddCharAtCursor(UTF8Decode(UTF8Key)[1]);

  UTF8Key := '';
end;

procedure TSimbaEdit.SetColor(Value: TColor);
begin
  inherited SetColor(Value);

  Invalidate();
end;

procedure TSimbaEdit.SetColorBorder(Value: TColor);
begin
  if (FColorBorder = Value) then
    Exit;
  FColorBorder := Value;

  Invalidate();
end;

procedure TSimbaEdit.SetColorSelection(Value: TColor);
begin
  if (FColorSelection = Value) then
    Exit;
  FColorSelection := Value;

  Invalidate();
end;

procedure TSimbaEdit.SetColorBorderActive(Value: TColor);
begin
  if (FColorBorderActive = Value) then
    Exit;
  FColorBorderActive := Value;
end;

constructor TSimbaEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCaretTimer := TTimer.Create(Self);
  FCaretTimer.Enabled := False;
  FCaretTimer.Interval := 500;
  FCaretTimer.OnTimer := @DoCaretTimer;

  ControlStyle := ControlStyle + [csOpaque];
  Cursor := crIBeam;
  TabStop := True;
  BorderWidth := 2;

//  Font.Color := SimbaTheme.ColorFont;

//  Color := SimbaTheme.ColorBackground;
//  ColorBorder := SimbaTheme.ColorBackground;
//  ColorBorderActive := SimbaTheme.ColorActive;
//  ColorSelection := SimbaTheme.ColorActive;

  HintTextStyle := [fsItalic];
  HintTextColor := clLtGray;

  Height := CalculateHeight();
end;

procedure TSimbaEdit.Clear;
begin
  Text := '';
end;

procedure TSimbaLabeledEdit.TextChanged;
begin
  inherited TextChanged();

  if Assigned(FLabel) then
    FLabel.Caption := Text;
end;

constructor TSimbaLabeledEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csOpaque];
 // Color := SimbaTheme.ColorBackground;
//  Font.Color := SimbaTheme.ColorFont;
  AutoSize := True;
  ParentFont := True;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Align := alLeft;
  FLabel.AutoSize := True;
  FLabel.Layout := tlCenter;
  FLabel.ParentFont := True;

  FEdit := TSimbaEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Align := alClient;
  FEdit.BorderSpacing.Around := 5;
end;

end.

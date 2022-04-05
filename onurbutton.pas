unit onurbutton;



{$mode objfpc}{$H+}
//{$mode delphi}
//{$R onres.res}
{$R 'onur.rc' onres.res}

interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf, Classes, StdCtrls, LazMethodList,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Calendar, Dialogs, types, LazUTF8;

type
  TONButtonState = (obshover, obspressed, obsnormal);
  TONExpandStatus = (oExpanded, oCollapsed);
  TONButtonDirection = (obleft, obright);
  TONSwichState = (FonN,FonH, FoffN,FoffH);
  TONKindState = (oVertical, oHorizontal);
  TONScroll = (FDown, FUp);
  Tcapdirection = (ocup, ocdown, ocleft, ocright);
 {
  TONMouseEvent = procedure(Msg: TWMMouse) of object;
  TONMouseOverEvent = procedure(Sender: TObject) of object;
  TONMouseOutEvent = procedure(Sender: TObject) of object;
  TONPaintEvent = procedure(Sender: TObject; var continue: boolean) of object;
  TONCheckDateEvent = function(Sender: TObject; Date: TDateTime): boolean of object;
 }

  { TonPersistent }

  TonPersistent = class(TPersistent)
    owner: TPersistent;
  public
    constructor Create(AOwner: TPersistent); overload virtual;
    //   destructor Destroy; override;
  end;



  TONCustomCrop = class(TPersistent)//(TonPersistent)
  public
    Fontcolor:Tcolor;
    cropname: string;
    FSLeft, FSTop, FSright, FSBottom: integer;
  published
    property Left: integer read FSLeft write FSLeft;
    property Top: integer read FSTop write FSTop;
    property Right: integer read FSright write FSright;
    property Bottom: integer read FSBottom write FSBottom;
  end;



  { TONImg }

  TONImg = class(TComponent)
  private

    FRes: TPicture;
    List: TStringList;
    fparent:TForm;
    procedure ImageSet(Sender: TObject);
    procedure Readskins;

    //    procedure Setpicture(val :TPicture);
  public
    Fimage: TBGRABitmap;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Readskins(formm: TForm);
    procedure ReadskinsComp(Com: TComponent);
    procedure Readskinsfile(filename: string);
    procedure Saveskinsfile(filename: string);
    procedure ReadskinsStream(STrm: TStream);
    procedure SaveskinsStream(Strm: TStream);

    //   property    Images  : TBGRABitmap read Fimage write Fimage;
  published
    property Picture: TPicture read FRes write Fres;//Setpicture;
  end;


  TONFrom = class(TComponent)
  private
//    fromm: TForm;
    FSkindata: TONImg;
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCustomCrop;
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Readskins(formm: TForm);
    //    procedure paint; override;
  published
    property Skindata: TONImg read FSkindata write SetSkindata;
  end;

  { TONGraphicControl }

  TONGraphicControl = class(TGraphicControl)
  private
    FSkindata: TONImg;
    FAlignment: TAlignment;
    Fresim: TBGRABitmap;
    Fkind: Tonkindstate;
    Fskinname:string;
    //    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    //    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetAlignment(const Value: TAlignment);
    function GetTransparent: boolean;
    procedure SetTransparent(NewTransparent: boolean);
    function Getkind: Tonkindstate;
    procedure SetKind(AValue: Tonkindstate); virtual;
    procedure SetSkindata(Aimg: TONImg);
    procedure Setskinname(avalue:string);
  public
    { Public declarations }
    Captionvisible: boolean;
    Backgroundbitmaped: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    property Kind: Tonkindstate read Getkind write Setkind default oHorizontal;
  published
    property Align;
    property Alignment: TAlignment read FAlignment
      write SetAlignment default taCenter;
    property Transparent: boolean read GetTransparent
      write SetTransparent default True;
    property Skindata: TONImg read FSkindata write SetSkindata;
    property Skinname: string read fskinname write Setskinname;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;//: string read FCaption write SetCaption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;//: TFont read FFont write SetFont stored True;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  { TONCustomControl }

  TONCustomControl = class(TCustomControl)
  private
    Fcrop: boolean;
    FSkindata: TONImg;
    FAlignment: TAlignment;
    Fresim: TBGRABitmap;
    WindowRgn: HRGN;
    Fkind: Tonkindstate;
    fskinname:string;
    procedure SetCrop(Value: boolean);
    function Getkind: Tonkindstate;
    procedure SetKind(AValue: Tonkindstate);
    procedure Setskinname(avalue:string);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetSkindata(Aimg: TONImg);
    //    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    //    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
  public
    { Public declarations }
    Captionvisible: boolean;
    Backgroundbitmaped: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure CropToimg(Buffer: TBGRABitmap); virtual;
    property Kind: Tonkindstate read Getkind write Setkind default oHorizontal;
  published
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Skindata: TONImg read FSkindata write SetSkindata;
    property Skinname: string read fskinname write Setskinname;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop: boolean read Fcrop write SetCrop default False;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
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
    property OnGetDockCaption;
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
    property OnUnDock;
  end;



  TONPanel = class(TONCustomControl)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint override;
  published
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
    property Skindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
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
    property OnGetDockCaption;
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
    property OnUnDock;
  end;


  { TONHeaderPanel }

  TONHeaderPanel = class(TONPanel)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ONLEFT;
    property ONRIGHT;
    property ONCENTER;
    property ONBOTTOM;
    property ONBOTTOMLEFT;
    property ONBOTTOMRIGHT;
    property ONTOP;
    property ONTOPLEFT;
    property ONTOPRIGHT;
    property Skindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
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
    property OnGetDockCaption;
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
    property OnUnDock;
  end;


  { TONCollapExpandPanel }

  TONCollapExpandPanel = class(TonCustomcontrol)
  private
    FStatus: TONExpandStatus;
    FOnCollapse: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    fbutonarea: TRect;
    FAutoCollapse: boolean;
    fminheight: integer;
    fnormalheight: integer;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter,FNormal,FPress,FEnter,Fdisable: TONCUSTOMCROP;
    FexNormal,FexPress,FexEnter,Fexdisable: TONCUSTOMCROP;
    Fstate:TONButtonState;
    Fheaderstate:Tcapdirection;
    fbutondirection: TONButtonDirection;
    procedure Setheaderstate(AValue:Tcapdirection);
    procedure SetStatus(const AValue: TONExpandStatus);
    procedure SetAutoCollapse(const AValue: boolean);
    procedure SetOnCollapse(const AValue: TNotifyEvent);
    procedure SetOnExpand(const AValue: TNotifyEvent);
    function GetMinheight: integer;
    function GetNormalheight: integer;
    procedure Setminheight(const Avalue: integer);
    procedure Setnormalheight(const Avalue: integer);
    procedure ResizePanel();
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: integer;
     Y: integer);override;
  protected
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
    property Status: TONExpandStatus read FStatus write SetStatus;
    property Minheight: integer read GetMinheight write Setminheight;
    property Normalheight: integer
      read GetNormalheight write Setnormalheight;
    property Caption;//String            read Gettexti         write Settexti;
//    property Kind;//
    property HeaderState: Tcapdirection read Fheaderstate write Setheaderstate;
    property ButtonPosition: TONButtonDirection
      read fbutondirection write fbutondirection;
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
    property ONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED: TONCUSTOMCROP read FPress write FPress;
    property ONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
    property ONEXNORMAL: TONCUSTOMCROP read FexNormal write FexNormal;
    property ONEXPRESSED: TONCUSTOMCROP read FexPress write FexPress;
    property ONEXHOVER: TONCUSTOMCROP read FexEnter write FexEnter;
    property ONEXDISABLE: TONCUSTOMCROP read Fexdisable write Fexdisable;

    property Skindata;
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



  { TONGraphicPanel }

  TONGraphicPanel = class(TONGraphicControl)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
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
    //    property OnEnter;
    //    property OnExit;
    //    property OnGetSiteInfo;
    //    property OnGetDockCaption;
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
    //    property OnUnDock;
  end;



  TONCropButton = class(TONCustomControl)
  private
    FNormal, FPress, FEnter, Fdisable: TONCUSTOMCROP;
    Fstate: TONButtonState;
    FAutoWidth: boolean;
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
  published
    property Skindata;
    property AutoWidth: boolean read FAutoWidth write SetAutoWidth default True;
    property ONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED: TONCUSTOMCROP read FPress write FPress;
    property ONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
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
    FNormal, FPress, FEnter, Fdisable: TONCUSTOMCROP;
    Fstate: TONButtonState;
    FAutoWidth: boolean;
  protected
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    //    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;

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
  published
    property Skindata;
    property AutoWidth: boolean read FAutoWidth write SetAutoWidth default True;
    property ONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED: TONCUSTOMCROP read FPress write FPress;
    property ONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
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


  Toncustomedit = class;
  { Toncaret }

  Toncaret = class(TOnPersistent)
  private
    parent: Toncustomedit;
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
    caretvisible: boolean;
    blinktimer: Ttimer;
    constructor Create(aowner: TPersistent);
    destructor Destroy; override;
  published
    property Visible: boolean read Getvisible write Setvisible;
    property Blinktime: integer read Getblinktime write Setblinktime;
    property Height: integer read FHeight write FHeight;
    property Width: integer read FWidth write FWidth;
    property Color: Tcolor read fblinkcolor write fblinkcolor;
  end;

  ToCharCase = (ecNormal, ecUppercase, ecLowerCase);
  TOEchoMode = (emNormal, emNone, emPassword);


  { Toncustomedit }

  Toncustomedit = class(TONCustomControl)
  private
    fSelStart: TPoint;
    fSelLength: integer;
    fVisibleTextStart: TPoint;
    fMultiLine: boolean;
    fFullyVisibleLinesCount, fLineHeight: integer;
    fPasswordChar: char;
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
    procedure DrawText;
    function GetCaretPos: TPoint;
    function GetCharCase: ToCharCase;
    function GetEchoMode: TOEchoMode;
    function GetLeftTextMargin: integer;
    function GetMultiLine: boolean;
    function GetRightTextMargin: integer;
    function GetPasswordChar: char;
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
    procedure SetPasswordChar(AValue: char);
    function MousePosToCaretPos(X, Y: integer): TPoint;
    function IsSomethingSelected: boolean;
    procedure SetText(AValue: string); virtual;
  protected
    function GetText: string; virtual;
    function GetNumberOnly: boolean; virtual;
    function GetReadOnly: boolean; virtual;
    procedure setreadonly(avalue: boolean); virtual;
    procedure RealSetText(const Value: TCaption); override;
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
    property Caption;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
     procedure paint;override;
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
    property MultiLine: boolean read GetMultiLine write SetMultiLine default False;
    property PasswordChar: char read GetPasswordChar write SetPasswordChar default #0;
  published
    property ReadOnly: boolean read GetReadOnly write SetReadOnly default False;
    property Text: string read GetText write SetText stored False;
    // This is already stored in Lines
    property NumberOnly: boolean read GetNumberOnly write SetNumberOnly;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Selstart: integer read GetSelStartX write SetSelStartX;
    //    property SelEnd;       : integer       read
    //    property SelText;
    property Skindata;
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


  { TonEdit }

  TonEdit = class(Toncustomedit)
  private
   Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
  public
   constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   procedure paint; override;
  published
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
    property Text;
    property Selstart;
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
    property Skindata;
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


  { TONMemo }

  TONMemo = class(Toncustomedit)
   private
   Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
  public
   constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   procedure paint; override;
  published
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
    property Lines;
    property Text;
    property Selstart;
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
    property Skindata;
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



  { TOnSpinEdit }

  TOnSpinEdit = class(Toncustomedit)
  private
//   Fedit          : Tonedit;
   //Fonchange      : TNotifyEvent;
  // fReadOnly      : Boolean;
   fvalue         : integer;
   fmin,Fmax      : integer;
   Fbuttonwidth   : integer;
   Fbuttonheight  : integer;
   Fubuttonarea   : Trect;
   Fdbuttonarea   : Trect;
   FuNormal, FuPress, FuEnter, Fudisable: TONCUSTOMCROP;   // up button picture
   FdNormal, FdPress, FdEnter, Fddisable: TONCUSTOMCROP;   // down button state

   Fustate,Fdstate : TONButtonState; // up buttonstate, down buttonstate


    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
//   procedure feditchange(sender: tobject);
   function getbuttonheight: integer;
   function getbuttonwidth: integer;
   function Getmax: integer;
   function Getmin: integer;
//   function Gettext: integer;
   procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: integer;
     Y: integer);override;
   procedure setbuttonheight(avalue: integer);
   procedure setbuttonwidth(avalue: integer);
   procedure Setmax(AValue: integer);
   procedure Setmin(AValue: integer);

   procedure KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
//   procedure Resize;override;
   procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
   procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
   procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
   procedure SetText(AValue: string); override;

   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Paint;override;
  published
    property Value         : integer    read fvalue write fvalue; //  read Gettext         write SetText;
    property MaxValue      : integer    read fvalue write fvalue; //   read Getmin          write Setmin;
    property MinValue      : integer    read fvalue write fvalue; //   read Getmax          write Setmax;
    property Buttonwidth   : integer    read fvalue write fvalue; //   read GetButtonwidth  write SetButtonwidth;
    property Buttonheight  : integer    read fvalue write fvalue; //   read GetButtonheight write SetButtonheight;
//    property OnChange      : TNotifyEvent  read FOnChange       write FOnChange;
//    property ReadOnly      : boolean       read freadonly       write freadonly;
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;

    property ONUPBUTONNORMAL    : TONCUSTOMCROP read FuNormal        write FuNormal;
    property ONUPBUTONPRESS     : TONCUSTOMCROP read FuPress         write FuPress;
    property ONUPBUTONHOVER     : TONCUSTOMCROP read FuEnter         write FuEnter;
    property ONUPBUTONDISABLE   : TONCUSTOMCROP read Fudisable       write Fudisable;
    property ONDOWNBUTONNORMAL  : TONCUSTOMCROP read FdNormal        write FdNormal;
    property ONDOWNBUTONPRESS   : TONCUSTOMCROP read FdPress         write FdPress;
    property ONDOWNBUTONHOVER   : TONCUSTOMCROP read FdEnter         write FdEnter;
    property ONDOWNBUTONDISABLE : TONCUSTOMCROP read Fddisable       write Fddisable;
    property Text;
    property Selstart;
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
    property Skindata;
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




  { ToNScrollBar }

  ToNScrollBar = class(ToNGraphicControl)
  private
    Fleft, FRight           : TONCustomCrop;
    FTop, FBottom           : TONCustomCrop;
    FNormali, Fbar          : TONCustomCrop;
    FbuttonNL,FbuttonUL,
    FbuttonBL,FbuttonDL,
    FbuttonNR,FbuttonUR,
    FbuttonBR,FbuttonDR,
    FbuttonCN,FbuttonCU,
    FbuttonCB,FbuttonCD  : TONCustomCrop;

    fcbutons, flbutons, frbutons: TONButtonState;

    flbuttonrect, frbuttonrect, Ftrackarea, fcenterbuttonarea: TRect;

    FPosition,  FPosValue: int64;
    FMin, FMax: int64;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;
    procedure centerbuttonareaset;
    procedure SetPosition(Value: int64);
    procedure SetMax(Val: int64);
    procedure Setmin(Val: int64);
    function Getposition: int64;
    function Getmin: int64;
    function Getmax: int64;
    function CheckRange(const Value: int64): int64;
    function MaxMin: int64;
    function CalculatePosition(const Value: integer): int64;
    function SliderFromPosition(const Value: integer): int64;
    function PositionFromSlider(const Value: integer): int64;
    procedure SetPercentage(Value: int64);
  protected
    procedure setkind(avalue: tonkindstate);override;
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
    function GetPercentage: int64;
  published
    property Min           : int64       read Getmin          write setmin;
    property Max           : int64       read Getmax          write setmax;
    property Position      : int64       read Getposition     write setposition;
    property OnChange      : TNotifyEvent  read FOnChange       write FOnChange;
    property ONLEFT            : TONCUSTOMCROP read Fleft      write Fleft;
    property ONRIGHT           : TONCUSTOMCROP read FRight      write FRight;
    property ONTOP             : TONCUSTOMCROP read FTop      write FTop;
    property ONBOTTOM          : TONCUSTOMCROP read FBottom      write FBottom;
    property ONNORMAL          : TONCUSTOMCROP read FNormali  write FNormali;
    property ONBAR             : TONCUSTOMCROP read Fbar      write Fbar;
    property ONLEFTBUTNORMAL   : TONCUSTOMCROP read FbuttonNL write FbuttonNL;
    property ONLEFTBUTONHOVER  : TONCUSTOMCROP read FbuttonUL write FbuttonUL;
    property ONLEFTBUTPRESS    : TONCUSTOMCROP read FbuttonBL write FbuttonBL;
    property ONLEFTBUTDISABLE  : TONCUSTOMCROP read FbuttonDL write FbuttonDL;
    property ONRIGHTBUTNORMAL  : TONCUSTOMCROP read FbuttonNR write FbuttonNR;
    property ONRIGHTBUTONHOVER : TONCUSTOMCROP read FbuttonUR write FbuttonUR;
    property ONRIGHTBUTPRESS   : TONCUSTOMCROP read FbuttonBR write FbuttonBR;
    property ONRIGHTBUTDISABLE : TONCUSTOMCROP read FbuttonDR write FbuttonDR;

    property ONCENTERBUTNORMAL   : TONCUSTOMCROP read FbuttonCN write FbuttonCN;
    property ONCENTERBUTONHOVER  : TONCUSTOMCROP read FbuttonCU write FbuttonCU;
    property ONCENTERBUTPRESS    : TONCUSTOMCROP read FbuttonCB write FbuttonCB;
    property ONCENTERBUTDISABLE  : TONCUSTOMCROP read FbuttonCD write FbuttonCD;

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

   
  { ToNListBox }

  ToNListBox = class(ToNCustomcontrol)
  private
    Flist: TStrings;//List;
    findex: integer;
    fvert, fhorz: ToNScrollBar;
    FItemsShown, FitemHeight, Fitemoffset: integer;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter,factiveitems: TONCUSTOMCROP;
    itempaintHeight:Trect;
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
    procedure dblclick; override;
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
    property Items            : TStrings      read Flist          write SetString;
    property ItemIndex        : integer       read GetItemIndex   write SetItemIndex;
    property ItemHeight       : integer       read GetItemHeight  write SetItemHeight;
    property HorizontalScroll : ToNScrollBar  read fhorz          write fhorz;
    property VertialScroll    : ToNScrollBar  read fvert          write fvert;
    property Selectedcolor    : Tcolor        read Fselectedcolor write Fselectedcolor;
    property ONLEFT           : TONCUSTOMCROP read Fleft          write Fleft;
    property ONRIGHT          : TONCUSTOMCROP read FRight         write FRight;
    property ONCENTER         : TONCUSTOMCROP read FCenter        write FCenter;
    property ONBOTTOM         : TONCUSTOMCROP read FBottom        write FBottom;
    property ONBOTTOMLEFT     : TONCUSTOMCROP read FBottomleft    write FBottomleft;
    property ONBOTTOMRIGHT    : TONCUSTOMCROP read FBottomRight   write FBottomRight;
    property ONTOP            : TONCUSTOMCROP read FTop           write FTop;
    property ONTOPLEFT        : TONCUSTOMCROP read FTopleft       write FTopleft;
    property ONTOPRIGHT       : TONCUSTOMCROP read FTopRight      write FTopRight;
    property ONACTIVEITEM     : TONCUSTOMCROP read factiveitems   write factiveitems;
    property Skindata;
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
    property PopupMenu;
    property ShowHint;
    property Visible;
    property TabOrder;
    property TabStop default true;
  end;



  { TONcombobox }

  TONcombobox = class(Toncustomedit)//(TonCustomcontrol)
  private
   Fliste         : TStrings;
   FOnCloseUp     : TNotifyEvent;
   FOnDropDown    : TNotifyEvent;
   FOnGetItems    : TNotifyEvent;
   FOnSelect      : TNotifyEvent;
   Fitemindex     : integer;
   fbutonarea     : Trect;
//   FItemsShown    : integer;
   FitemHeight    : integer;
   Fitemoffset    : integer;
   Fselectedcolor : Tcolor;
   fdropdown      : boolean;
   FNormal, FPress, FEnter, Fdisable: TONCUSTOMCROP;
   Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
   Fstate        : TONButtonState;
   procedure kclick(Sender: TObject);
   function Gettext: string;
   function GetItemIndex: integer;
   procedure LinesChanged(Sender: TObject);

   procedure setitemheight(avalue: integer);
   procedure SetItemIndex(Avalue: integer);
//   procedure SetText(AValue: string);


   procedure LstPopupReturndata(Sender: TObject; const Str:string; const indx:integer);
   procedure LstPopupShowHide(Sender: TObject);

   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
   procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: integer;
     Y: integer);override;
   procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
   procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;


  protected
//    procedure Change; virtual;
    procedure Select; virtual;
    procedure DropDown; virtual;
    procedure GetItems; virtual;
    procedure CloseUp; virtual;
    procedure SetStrings(AValue: TStrings); virtual;
//    procedure KeyDown(var Key: word; Shift: TShiftState);  virtual;
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
    property Text;//          : string        read Gettext        write SetText;
    property Items         : TStrings      read Fliste         write SetStrings;
    property OnChange;//      : TNotifyEvent  read FOnChange      write FOnChange;
    property ReadOnly;//      : boolean       read freadonly      write freadonly;
    property Itemindex     : integer       read Getitemindex   write Setitemindex;
    property Selectedcolor : Tcolor        read Fselectedcolor write Fselectedcolor;
    property ItemHeight    : integer       read FitemHeight    write SetItemHeight;
    property ONLEFT        : TONCUSTOMCROP read Fleft          write Fleft;
    property ONRIGHT       : TONCUSTOMCROP read FRight         write FRight;
    property ONCENTER      : TONCUSTOMCROP read FCenter        write FCenter;
    property ONBOTTOM      : TONCUSTOMCROP read FBottom        write FBottom;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FBottomleft    write FBottomleft;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FBottomRight   write FBottomRight;
    property ONTOP         : TONCUSTOMCROP read FTop           write FTop;
    property ONTOPLEFT     : TONCUSTOMCROP read FTopleft       write FTopleft;
    property ONTOPRIGHT    : TONCUSTOMCROP read FTopRight      write FTopRight;
    property ONBUTONNORMAL  : TONCUSTOMCROP read FNormal        write FNormal;
    property ONBUTONPRESS   : TONCUSTOMCROP read FPress         write FPress;
    property ONBUTONHOVER   : TONCUSTOMCROP read FEnter         write FEnter;
    property ONBUTONDISABLE : TONCUSTOMCROP read Fdisable       write Fdisable;
    property Skindata;
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
  type
  TReturnStintEvent = procedure (Sender: TObject; const ftext: string; const itemind:integer) of object;

  Tpopupformcombobox= class(TcustomForm)
    procedure listboxDblClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
//    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    FCaller: ToNcombobox;
    FClosed: boolean;
    oblist :TonListBox;
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


 
  { TOnSwich }

  TOnSwich = class(TONGraphicControl)
  private
    FOpen, Fclose, Fopenhover,Fclosehover, Fdisable: TONCUSTOMCROP;
    Fstate: TONButtonState;
    FChecked: boolean;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
  protected
   procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
   procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;

   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
     X: integer; Y: integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
     X: integer; Y: integer); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Skindata;
    property Checked      : boolean       read FChecked write SetChecked default False;
    property ONOPEN       : TONCUSTOMCROP read FOpen write FOpen;
    property ONCLOSE      : TONCUSTOMCROP read Fclose write Fclose;
    property ONOPENHOVER  : TONCUSTOMCROP read Fopenhover write Fopenhover;
    property ONCLOSEHOVER : TONCUSTOMCROP read Fclosehover write Fclosehover;
    property ONDISABLE    : TONCUSTOMCROP read Fdisable write Fdisable;
    property OnChange     : TNotifyEvent  read FOnChange write FOnChange;
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
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: boolean);
    function GetCheckWidth: integer;
    procedure SetCheckWidth(AValue: integer);
    procedure SetCaptionmod(const val: Tcapdirection);
    function GetCaptionmod: Tcapdirection;
    procedure deaktifdigerleri;  /// for radiobutton
  protected
   procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
   procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
     X: integer; Y: integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
     X: integer; Y: integer); override;
   procedure DoOnChange; virtual;
   procedure CMHittest(var msg: TCMHIttest);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Checked          : boolean       read FChecked write SetChecked default False;
  published
    property Skindata;
    property CheckWidth        : integer read GetCheckWidth write SetCheckWidth;
    property CaptionDirection : Tcapdirection read GetCaptionmod write SetCaptionmod;
    property ONNORMAL         : TONCUSTOMCROP read obleave write obleave;
    property ONNORMALHOVER    : TONCUSTOMCROP read obenter write obenter;
    property ONNORMALDOWN     : TONCUSTOMCROP read obdown write obdown;
    property ONCHECKED        : TONCUSTOMCROP read obcheckleaves write obcheckleaves;
    property ONCHECKEDHOVER   : TONCUSTOMCROP read obcheckenters write obcheckenters;
    property ONDISABLE        : TONCUSTOMCROP read obdisabled write obdisabled;
    property OnChange         : TNotifyEvent  read FOnChange write FOnChange;
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

  TOnRadioButton = class(TOnCheckbox)
  published
    property Skindata;
    property CheckWidth;//: integer read GetChecWidth write SetChecWidth;
    property CaptionDirection;//: Tcapdirection read GetCaptionmod write SetCaptionmod;
    property ONNORMAL       ;//: TONCUSTOMCROP read obleave write obleave;
    property ONNORMALHOVER  ;//: TONCUSTOMCROP read obenter write obenter;
    property ONNORMALDOWN  ;//: TONCUSTOMCROP read obdown write obdown;
    property ONCHECKED      ;//: TONCUSTOMCROP read obcheckleaves write obcheckleaves;
    property ONCHECKEDHOVER ;//: TONCUSTOMCROP read obcheckenters write obcheckenters;
    property ONDISABLE    ;//: TONCUSTOMCROP read obdisabled write obdisabled;
    property OnChange     ;//: TNotifyEvent  read FOnChange write FOnChange;
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

  { TONProgressBar }

  TONProgressBar = class(TONGraphicControl)
  private
    Fleft, FCenter,FRight,Fbar: TONCUSTOMCROP;
    FOnChange: TNotifyEvent;
    fposition, fmax, fmin: Int64;
    FCaptonvisible: boolean;
    procedure setposition(const Val: Int64);
    procedure setmax(const Val: Int64);
    procedure setmin(const Val: Int64);
    function Getposition: Int64;
    function Getmin: Int64;
    function Getmax: Int64;
  protected
    procedure setkind(avalue: tonkindstate); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Textvisible     : boolean read FCaptonvisible write FCaptonvisible;
    property Skindata;
    property ONLEFT_TOP      : TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT_BOTTOM  : TONCUSTOMCROP read FRight write FRight;
    property ONCENTER        : TONCUSTOMCROP read FCenter write FCenter;
    property ONBAR           : TONCUSTOMCROP read Fbar write Fbar;
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



  { TONTrackBar }

  TONTrackBar = class(ToNGraphicControl)
  private
    Fleft,FRight,FCenter,FNormal,FPress,FEnter,Fdisable:TONCustomCrop;
    FState: TONButtonState;
    fcenterbuttonarea: TRect;
    FW, FH: integer;
    FPosition, FXY, FPosValue: integer;
    FMin, FMax: integer;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;
    procedure centerbuttonareaset;
    function CheckRange(const Value: integer): integer;
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
  protected
    procedure setkind(avalue: tonkindstate); override;
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
    property ONLEFT        : TONCUSTOMCROP read Fleft          write Fleft;
    property ONRIGHT       : TONCUSTOMCROP read FRight         write FRight;
    property ONCENTER      : TONCUSTOMCROP read FCenter        write FCenter;
    property ONBUTONNORMAL  : TONCUSTOMCROP read FNormal        write FNormal;
    property ONBUTONPRESS   : TONCUSTOMCROP read FPress         write FPress;
    property ONBUTONHOVER   : TONCUSTOMCROP read FEnter         write FEnter;
    property ONBUTONDISABLE : TONCUSTOMCROP read Fdisable       write Fdisable;
    property Position: integer read GetPosition write SetPosition;
    property Percentage: integer read GetPercentage write SetPercentage;
    property Kind;//         : Tokindstate    read Getkind          write Setkind;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Skindata;
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



{




  TOnGroupBox = class(TOnControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    fbordercolor: TColor;
    FborderWidth: integer;
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Skindata      : TONImg        read FSkindata write SetSkindata;
    property ONLEFT        : TONCUSTOMCROP read FSol      write FSol;
    property ONRIGHT       : TONCUSTOMCROP read FSag      write FSag;
    property ONCENTER      : TONCUSTOMCROP read FOrta     write FOrta;
    property ONBOTTOM      : TONCUSTOMCROP read FAlt      write FAlt;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FSolalt   write FSolalt;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FSagalt   write FSagalt;
    property ONTOP         : TONCUSTOMCROP read FUst      write FUst;
    property ONTOPLEFT     : TONCUSTOMCROP read FSolust   write FSolust;
    property ONTOPRIGHT    : TONCUSTOMCROP read FSagust   write FSagust;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderColor: Tcolor read Fbordercolor write fbordercolor;
    property BorderWidth: integer read FborderWidth write fborderWidth;

    property BidiMode;
    //      property    BorderWidth;
    property BorderStyle;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
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
    property OnGetDockCaption;
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
    property OnUnDock;
  end;

  // TOnurscroll=class(Tmemo)

 }


procedure Register;



implementation

uses CalendarPopup, BGRAPath, IniFiles;

procedure Register;
begin
  RegisterComponents('ONUR', [TONImg]);
  RegisterComponents('ONUR', [TONPANEL]);
  RegisterComponents('ONUR', [TONHeaderPanel]);
  RegisterComponents('ONUR', [TONGraphicPanel]);
  RegisterComponents('ONUR', [TONCropButton]);
  RegisterComponents('ONUR', [TONGraphicsButton]);
  RegisterComponents('ONUR', [TOnEdit]);
  RegisterComponents('ONUR', [TOnSpinEdit]);
  RegisterComponents('ONUR', [TOnMemo]);
  RegisterComponents('ONUR', [TONCOMBOBOX]);
  RegisterComponents('ONUR', [TONScrollBar]);
  RegisterComponents('ONUR', [TONListbox]);
  RegisterComponents('ONUR', [TOnSwich]);
  RegisterComponents('ONUR', [TOnCheckbox]);
  RegisterComponents('ONUR', [TOnRadioButton]);
  RegisterComponents('ONUR', [TONProgressBar]);
  RegisterComponents('ONUR', [TONCollapExpandPanel]);
  RegisterComponents('ONUR', [TONTrackBar]);





{
  RegisterComponents('ONUR', [TOnCheckBox]);
  RegisterComponents('ONUR', [TOnRadioButton]);
  RegisterComponents('ONUR', [TONProgressBar]);
  RegisterComponents('ONUR', [TOnSwich]);
  RegisterComponents('ONUR', [TOnGroupBox]);
  RegisterComponents('ONUR', [TONCURREDIT]);
  RegisterComponents('ONUR', [TONDATEEDIT]);
  RegisterComponents('ONUR', [TOnPanelControl]);    }

end;

 Function StringLeftJustify(Space:Word;Str:String):String;
Var
str_all:String;
i:Word;
Begin
        str_all:='';
        IF Length(Str)<Space Then
        Begin
          For i:=1 To Space-Length(Str) Do
          Begin
            Insert(' ',str_all,1);
          end;
          str_all:=Concat(Str, str_all);
          Result:=str_all;
        end
        else
        Result:=Str;
end;

Function StringRigthJustify(Space:Word;Str:String):String;
Var
str_all:String;
i:Word;
Begin
        str_all:='';
        IF Length(Str)<Space Then
        Begin
          For i:=1 To Space-Length(Str) Do
          Begin
            Insert(' ',str_all,1);
          end;
          str_all:=Concat(str_all, Str);
          Result:=str_all;
        end
        else
        Result:=Str;
end;

function randomNumber(LowBound, HighBound: Integer):Integer;
begin
randomize;
Result := LowBound + random(HighBound - LowBound + 1);
end;
function RandomString(PWLen: integer): string;
const StrTable: string =
    '!#$%&/()=?@<>|{[]}\*~+#;:.-_' +
    'ABCDEFGHIJKLMabcdefghijklm' +
    '0123456789' +
    'NOPQRSTUVWXYZnopqrstuvwxyz';
var
  N, K, X, Y: integer;
begin

  Randomize;
  if (PWlen > Length(StrTable)) then K := Length(StrTable)-1
    else K := PWLen;
  SetLength(result, K);
  Y := Length(StrTable);
  N := 0;

  while N < K do begin
    X := Random(Y) + 1;
    if (pos(StrTable[X], result) = 0) then begin
      inc(N);
      Result[N] := StrTable[X];
    end;
  end;
end;

function colortohtml(clr: Tcolor):Tcolor;
var TheRgbValue : TColorRef;
begin
    TheRgbValue := ColorToRGB(Clr);
    result:=stringtocolor( Format('#%.2x%.2x%.2x',
   [GetRValue(TheRGBValue),
    GetGValue(TheRGBValue),
    GetBValue(TheRGBValue)]));

end;

function GetTempDir: string;
var
  lng:     DWORD;
begin
  SetLength(Result, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(Result));
  SetLength(Result, lng);
end;
procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);
// For caption
var
  stl: TTextStyle;
begin
  TT.Font.Quality := fqCleartype;
  TT.Font.Name := TF.Name;//'CALIBRI';
  TT.Font.Size := TF.size;
  TT.Font.Color := TF.Color;//$00FFC884;
  TT.Font.style := TF.style;//Fsbold;
  TT.Brush.Style := bsClear;
  stl.Alignment := asd;
  stl.Wordbreak := True;
  stl.Layout := tlCenter;
  stl.SingleLine := False;
  TT.TextRect(RE, 0, 0, Fcap, stl);
end;


function ValueRange(const Value, Min, Max: integer): integer;
begin
  if Value < Min then
    Result := Min
  else if Value > Max then
    Result := Max
  else
    Result := Value;
end;

// -----------------------------------------------------------------------------

function PercentValue(const Value, Percent: integer): integer;
begin
  Result := Round(Value / 100 * Percent);
end;

// -----------------------------------------------------------------------------

function PercentValue(const Value, Percent: double): double;
begin
  Result := Value / 100 * Percent;
end;


function GetScreenClient(Control: TControl): TPoint;
var
  p: TPoint;
begin
  p := Control.ClientOrigin;
  ScreenToClient(Control.Parent.Handle, p);
  Result := p;
end;


function RegionFromBGRABitmap(const ABMP: TBGRABitmap): HRGN;
var
  Rgn1, Rgn2: HRGN;
  x, y, z: integer;
begin
  Rgn1 := 0;
  for y := 0 to ABMP.Height - 1 do
  begin
    x := 0;
    while (x <= ABMP.Width) do
    begin
      while (ABMP.GetPixel(x, y).alpha {<255)  GetAlpha(ABMP.GetPixel(x, y]^)))} <
          255) and (x < ABMP.Width) do
        Inc(x);
      z := x;
      while (ABMP.GetPixel(x, y).alpha{(GetAlpha(ABMP.PixelPtr[x, y]^))} = 255) and
        (x < ABMP.Width) do
        Inc(x);

      if Rgn1 = 0 then
        Rgn1 := CreateRectRGN(z, y, x, y + 1)
      else
      begin
        Rgn2 := CreateRectRgn(z, y, x, y + 1);
        if Rgn2 <> 0 then
        begin
          CombineRgn(Rgn1, Rgn1, Rgn2, RGN_OR);
          DeleteObject(Rgn2);
        end;
      end;
      Inc(x);
    end;
  end;
  Result := Rgn1;
end;


procedure Premultiply(BMP: TBGRABitmap);
var
  iX, iY: integer;
  p: PBGRAPixel;
begin
  for iY := 0 to BMP.Height - 1 do
  begin
    p := BMP.Scanline[iY];
    for iX := BMP.Width - 1 downto 0 do
    begin
      if p^.Alpha = 0 then
        p^ := BGRAPixelTransparent
      else
      begin
        p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
        p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
        p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;
      end;
      Inc(p);
    end;
  end;
end;


procedure DrawPartstrech(ARect: TRect; Target: TOnCustomControl; w, h: integer);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    Target.fresim.PutImage(0,0,Target.FSkindata.Fimage,dmDrawWithTransparency,255)
//    hedef.FSkindata.Fimage.Draw(hedef.Fresim.Canvas, 0, 0, False)
  else
  begin
    img := Target.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      Target.Fresim.ResampleFilter := rfBestQuality;
      img.ResampleFilter := rfBestQuality;

      partial:=img.Resample(w, h, rmFineResample) as TBGRABitmap;
      if partial <> nil then
      Target.Fresim.PutImage(0,0,partial,dmDrawWithTransparency,255);
      FreeAndNil(partial);

  //    BGRAReplace(Target.Fresim, img.Resample(w, h, rmSimpleStretch));
    end;
    FreeAndNil(img);
  end;

end;

procedure DrawPartstrech(ARect: TRect; Target: TOnGraphicControl; w, h: integer);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
     Target.fresim.PutImage(0,0,Target.FSkindata.Fimage,dmDrawWithTransparency,255)
 //   Target.FSkindata.Fimage.Draw(Target.Fresim.Canvas, 0, 0, False)
  else
  begin
    img := Target.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      Target.Fresim.ResampleFilter := rfBestQuality;
      img.ResampleFilter := rfBestQuality;
      partial:=img.Resample(w, h, rmFineResample) as TBGRABitmap;
      if partial <> nil then
      Target.Fresim.PutImage(0,0,partial,dmDrawWithTransparency,255);
      FreeAndNil(partial);
     // BGRAReplace(Target.Fresim, img.Resample(w, h, rmSimpleStretch));
    end;
    FreeAndNil(img);
  end;

end;



procedure DrawPartnormal(ARect: TRect; Target: TOnCustomControl;
  ATargetRect: TRect; Opaque: boolean);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
   // Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, Opaque)
    Target.fresim.StretchPutImage(ATargetRect,Target.FSkindata.Fimage,dmSet,255)//(0,0,Target.FSkindata.Fimage,255)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
    Target.Fresim.StretchPutImage(ATargetRect,partial,dmDrawWithTransparency,255);
  //    partial.Draw(Target.Fresim.Canvas, ATargetRect, Opaque);

    FreeAndNil(partial);
  end;

end;


procedure DrawPartnormal(ARect: TRect; Target: TOnGraphicControl;
  ATargetRect: TRect; Opaque: boolean);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, Opaque)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
    //  partial.Draw(Target.Fresim.Canvas, ATargetRect, Opaque);
    Target.Fresim.StretchPutImage(ATargetRect,partial,dmDrawWithTransparency,255);

    FreeAndNil(partial);
  end;

end;



procedure DrawPartstrechRegion(ARect: TRect; Target: TOnGraphicControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: boolean);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
  img := Target.FSkindata.Fimage.GetPart(ARect);
  if img <> nil then
  begin
    partial := TBGRABitmap.Create(NewWidth, NewHeight);
    partial := img.Resample(NewWidth, NewHeight) as TBGRABitmap;

    if partial <> nil then
    //  partial.Draw(Target.Fresim.Canvas, ATargetRect, Opaque);

    Target.Fresim.StretchPutImage(ATargetRect,partial,dmDrawWithTransparency,255);


    FreeAndNil(partial);
  end;
  FreeAndNil(img);

end;


procedure DrawPartstrechRegion(ARect: TRect; Target: TOnCustomControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: boolean);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin

  img := Target.FSkindata.Fimage.GetPart(ARect);
  if img <> nil then
  begin
    partial := TBGRABitmap.Create(NewWidth,NewHeight);
    //      partial.ResampleFilter := rfBestQuality;
    //      BGRAReplace(partial, img.Resample(w, h, rmSimpleStretch));
    partial := img.Resample(NewWidth, NewHeight) as TBGRABitmap;
    if partial <> nil then
    begin
  //    partial.Draw(Target.Fresim.Canvas, ATargetRect, Opaque);
      Target.Fresim.StretchPutImage(ATargetRect,partial,dmDrawWithTransparency,255);
    end;
    FreeAndNil(partial);
  end;
  FreeAndNil(img);

end;


{
function strToWord(const str: string; startPos, len: integer): word;
var
  i: integer;
begin
  if (length(str) < startPos + len - 1) or (len < 1) or (startPos < 1) then
    raise Exception.Create(s_invalid_integer);
  Result := 0;
  for i := 1 to len do
  begin
    if not (str[startPos] in ['0'..'9']) then
      raise Exception.Create(s_invalid_integer);
    Result := (Result * 10) + Ord(str[startPos]) - Ord('0');
    Inc(startPos);
  end;
end;
}
{ Tpopupformcombobox }

procedure ShowCombolistPopup(const APosition: TPoint;
  const OnReturnDate: TReturnStintEvent; const OnShowHide: TNotifyEvent;
  ACaller: TONcombobox);
var
  PopupForm: Tpopupformcombobox;
begin

  PopupForm := Tpopupformcombobox.Create(Application);//Create(Application);
  PopupForm.SetBounds(APosition.x,APosition.y,150,250);
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

{ TONTrackBar }


function tontrackbar.checkrange(const value: integer): integer;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function tontrackbar.maxmin: integer;
begin
   Result := FMax - FMin;
end;

function tontrackbar.calculateposition(const value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;// FMax-Value; //for revers
end;

function tontrackbar.getposition: integer;
begin
  Result := CalculatePosition(SliderFromPosition(FPosition));
end;

procedure tontrackbar.cmonmouseenter(var messages: tmessage);
begin
   if (not FIsPressed) and (Enabled) then
  begin
    FState := obshover;
    Invalidate;
  end;
end;

procedure tontrackbar.cmonmouseleave(var messages: tmessage);
begin
   if Enabled then
   begin
     if not FIsPressed then
     begin
       FState := obsnormal;
       Invalidate;
     end;
     inherited;
   end;
end;

procedure tontrackbar.setmax(const value: integer);
begin
  if Value <> FMax then FMax := Value;
end;

procedure tontrackbar.setmin(const value: integer);
begin
  if Value <> FMin then FMin := Value;
end;

function tontrackbar.sliderfromposition(const value: integer): integer;
begin
  if Kind = oVertical then
    Result := Round(Value / (self.Height - fcenterbuttonarea.Height) * MaxMin)
  else
    Result := Round(Value / (self.Width - fcenterbuttonarea.Width) * MaxMin);

end;

function tontrackbar.positionfromslider(const value: integer): integer;
begin
   if Kind = oHorizontal then
    Result := Round(((self.Width - fcenterbuttonarea.Width) / MaxMin) * Value)
  else
    Result := Round(((self.Height - fcenterbuttonarea.Height) / MaxMin) * Value);
end;

procedure tontrackbar.setposition(value: integer);
begin
   if FIsPressed then Exit;
  Value := ValueRange(Value, FMin, FMax);


  if Kind = oHorizontal then
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

procedure tontrackbar.setpercentage(value: integer);
begin
    Value := ValueRange(Value, 0, 100);

  if FKind = oVertical then Value := Abs(FMax - Value);

  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;

function tontrackbar.getpercentage: integer;
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

procedure tontrackbar.changed;
begin
   if Assigned(FOnChange) then FOnChange(Self);
end;

procedure tontrackbar.setkind(avalue: tonkindstate);
var
  a:integer;
begin
  inherited setkind(avalue);
  a:=self.Width;
  if Kind = oHorizontal then
  begin
   fskinname      := 'trackbarh';
   self.Width:=self.Height;
   self.Height:=a;
  end
  else
  begin
   fskinname      := 'trackbarv';
   self.Width:=self.Height;
   self.Height:=a;
  end;
  Skindata:=self.Skindata;
  Invalidate;
end;

constructor tontrackbar.create(aowner: tcomponent);
begin
  inherited create(aowner);

  FState:=obsnormal;
  fskinname      := 'trackbarh';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';

  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';

  fcenterbuttonarea := Rect(1, 1, 19, 19);
  FIsPressed := False;
  FW := 0;
  FH := 0;
  FPosition := 0;
  FXY := 0;
  FPosValue := 0;
  FMin := 0;
  FMax := 100;
  FPosValue := 0;
  Self.Height := 30;
  Self.Width := 180;
  Fresim.SetSize(Width, Height);
end;

destructor tontrackbar.destroy;
begin
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited destroy;
end;

procedure tontrackbar.centerbuttonareaset;
//var
//  a:integer;
begin
  if Kind = oHorizontal then
  begin
//    a:=((Fleft.FSright-Fleft.FSLeft)+(FRight.FSright-FRight.FSLeft));
    fcenterbuttonarea.Width := self.Height;
    fcenterbuttonarea.Height := self.Height; //self.Width-a;

    if fPosition <= 0 then
      fcenterbuttonarea := Rect(0,0,Height, Height)
    else if fPosition >= (Width - fcenterbuttonarea.Width) then
      fcenterbuttonarea := Rect(Width - fcenterbuttonarea.Width, 0, Width, Height)
    else
      fcenterbuttonarea := Rect(FPosition, 0,
        FPosition + fcenterbuttonarea.Width, self.Height);
  end
  else
  begin
//    a:=((Fleft.FSBottom-Fleft.FSTop)+(FRight.FSBottom-FRight.FSTop));

    fcenterbuttonarea.Height := self.Width;
    fcenterbuttonarea.Width := self.Width;//self.Height;


    if fPosition <= 0 then
      fcenterbuttonarea := Rect(0, 0, self.Width, self.Width)
    else if fPosition >= (self.Height - self.Width) then
     fcenterbuttonarea := Rect(0, self.Height - self.Width, self.Width , self.Height)
    else
     fcenterbuttonarea := Rect(0, FPosition, self.Width, FPosition + self.Width);

  end;
end;
procedure tontrackbar.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin


     if Kind=oHorizontal then
     begin
      //LEFT   //SOL
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight,
        Fleft.FSBottom);
      TrgtRect := Rect(0, 0, FLeft.FSRight - Fleft.FSLeft,   Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //RIGHT //SAĞ
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight,
        FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        0, Width, Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER  //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), 0,
        self.Width - (FRight.FSRight - FRight.FSLeft),Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

     end else
     begin
       SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight,
        Fleft.FSBottom);
      TrgtRect := Rect(0, 0, Width, FLeft.FSBottom - Fleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //RIGHT //SAĞ
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight,
        FRight.FSBottom);
      TrgtRect := Rect(0,Height - (FRight.FSBottom - FRight.FSTop),
        Width, Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER  //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect(0,(Fleft.FSBottom - Fleft.FSTop), Width,
        self.Height - (FRight.FSBottom - FRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);
     end;


      // BUTTTON DRAW
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            SrcRect := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
          end;
          obspressed:
          begin
            SrcRect := Rect(FPress.FSLeft, FPress.FSTop,
              FPress.FSRight, FPress.FSBottom);
          end;
          obshover:
          begin
            SrcRect := Rect(FEnter.FSLeft, FEnter.FSTop,
              FEnter.FSRight, FEnter.FSBottom);
          end;
        end;
      end
      else
      begin
        SrcRect := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
      end;
     centerbuttonareaset;
      DrawPartnormal(SrcRect, self, fcenterbuttonarea, False);

  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;

procedure tontrackbar.mousedown(button: tmousebutton; shift: tshiftstate; x,
  y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FIsPressed := True;
    FState := obspressed;
    if FKind = oHorizontal then
      FPosition := CheckRange(X-((FPress.FSright-FPress.FSLeft) div 2))
    else
      FPosition := CheckRange(Y-((FPress.FSBottom-FPress.FSTop) div 2));

    Changed;
    invalidate;

  end;
end;

procedure tontrackbar.mouseup(button: tmousebutton; shift: tshiftstate; x,
  y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FIsPressed then
  begin
    FState := obshover;
    FIsPressed := False;
    Invalidate;
  end
  else
  begin
    if (Button = mbRight) and Assigned(PopupMenu) and not PopupMenu.AutoPopup then
    begin
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
    FState := obsnormal;
    Invalidate;
  end;
end;

procedure tontrackbar.mousemove(shift: tshiftstate; x, y: integer);
var
  MAXi: smallint;
begin
  inherited MouseMove(Shift, X, Y);
  if FIsPressed then
  begin
    if Kind = oHorizontal then
      MAXi := X-((FPress.FSright-FPress.FSLeft) div 2)
    else
      MAXi := Y-((FPress.FSBottom-FPress.FSTop) div 2);

    FPosition := CheckRange(MAXi);
    FState := obspressed;
    Changed;
    Invalidate;
  end;
end;



{ TONCollapExpandPanel }

procedure TONCollapExpandPanel.Setheaderstate(AValue: Tcapdirection);
begin
  if Fheaderstate = AValue then Exit;
  Fheaderstate := AValue;
  Invalidate;
end;

procedure TONCollapExpandPanel.SetStatus(const AValue: TONExpandStatus);
begin
  if FStatus = AValue then Exit;
  FStatus := AValue;
  if (FAutoCollapse) then ResizePanel();
end;

procedure TONCollapExpandPanel.SetAutoCollapse(const AValue: boolean);
begin
  if FAutoCollapse = AValue then Exit;
  FAutoCollapse := AValue;
  ResizePanel();
end;

procedure TONCollapExpandPanel.SetOnCollapse(const AValue: TNotifyEvent);
begin
  if FOnCollapse = AValue then Exit;
  FOnCollapse := AValue;
end;

procedure TONCollapExpandPanel.SetOnExpand(const AValue: TNotifyEvent);
begin
  if FOnExpand = AValue then Exit;
  FOnExpand := AValue;
end;

function TONCollapExpandPanel.GetMinheight: integer;
begin
  Result := fminheight;
end;

function TONCollapExpandPanel.GetNormalheight: integer;
begin
  Result := fnormalheight;
end;

procedure TONCollapExpandPanel.Setminheight(const Avalue: integer);
begin
   if fminheight = AValue then Exit;
  fminheight := AValue;
  Self.Constraints.MinHeight := fminheight;
end;

procedure TONCollapExpandPanel.Setnormalheight(const Avalue: integer);
begin
  if fnormalheight = AValue then Exit;
  fnormalheight := AValue;
  Self.Constraints.MaxHeight := fnormalheight;
end;

procedure TONCollapExpandPanel.ResizePanel;
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

procedure TONCollapExpandPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited mousedown(button, shift, x, y);
  if PtInRect(fbutonarea, Point(X,Y)) then
  begin
     if (FStatus = oExpanded) then
      begin
        if Assigned(FOnCollapse) then FOnCollapse(Self);
        FStatus := oCollapsed;
        Fstate  := obspressed;
     end
     else
     begin
        if Assigned(FOnExpand) then FOnExpand(Self);
        FStatus := oExpanded;
        Fstate  := obspressed;
     end;
     ResizePanel();
  end;

end;

procedure TONCollapExpandPanel.CMonmouseenter(var Messages: Tmessage);
 var
  aPnt: TPoint;
begin
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(fbutonarea, aPnt) then
  begin
    Fstate  := obshover;
    Invalidate;
  end else
  begin
    Fstate  := obsnormal;
    Invalidate;
  end;
end;

procedure TONCollapExpandPanel.CMonmouseleave(var Messages: Tmessage);
// var
//   aPnt: TPoint;
 begin
//   GetCursorPos(aPnt);
//   aPnt := ScreenToClient(aPnt);
 //  if PtInRect(fbutonarea, aPnt) then
//   begin
     Fstate  := obsnormal;
     Invalidate;
//   end;
end;

procedure TONCollapExpandPanel.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited mousemove(shift, x, y);
   if not PtInRect(fbutonarea, Point(X,Y)) then
   begin
    Fstate  := obsnormal;
    Invalidate;
   end;
end;

procedure TONCollapExpandPanel.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X: integer; Y: integer);
begin
  inherited mouseup(button, shift, x, y);
end;

procedure TONCollapExpandPanel.DblClick;
  var
  aPnt: TPoint;
begin
  inherited dblclick;
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(Rect(Fleft.fsLeft,FTop.fsTop, FRight.fsLeft, FTop.fsBottom), aPnt) then
  begin
     if (FStatus = oExpanded) then
      begin
        if Assigned(FOnCollapse) then FOnCollapse(Self);
        FStatus := oCollapsed;
//        Fstate  := obspressed;
     end
     else
     begin
        if Assigned(FOnExpand) then FOnExpand(Self);
        FStatus := oExpanded;
//         Fstate  := obspressed;
     end;
     ResizePanel();

  end;
end;

constructor TONCollapExpandPanel.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 250;
  Height := 150;
  FStatus := oExpanded;
  FAutoCollapse := False;
  fminheight := 30;
  fnormalheight := Height;
  //  Self.Constraints.MinHeight := fminheight;
  ParentBackground := True;
  fbutondirection := obright;

  fskinname:='expandpanel';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  FNormal:= TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress:= TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESS';
  FEnter:= TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable:= TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate            := obsnormal;
  fbutonarea:=Rect(Self.Width-self.Height,0,self.Width,self.Height);
  Fresim.SetSize(Width, Height);
  Captionvisible:=false;
  Fheaderstate:=ocup;
end;

destructor TONCollapExpandPanel.Destroy;
begin
  FreeAndNil(Fleft);
  FreeAndNil(FTop);
  FreeAndNil(FRight);
  FreeAndNil(FBottom);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FCenter);
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited destroy;
end;

procedure TONCollapExpandPanel.paint;
  var
    TrgtRect, SrcRect: TRect;
    textx,texty:integer;
  begin
    Fresim.SetSize(self.Width, self.Height);
    if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
    begin
      try



        //TOPLEFT   //SOLÜST
        SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
          FTopleft.FSBottom);
        TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
          FTopleft.FSBottom - FTopleft.FSTop);
        DrawPartnormal(SrcRect, self, TrgtRect, False);


        //TOPRIGHT //SAĞÜST
        SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
          FTopRight.FSBottom);
        TrgtRect := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft),
          0, Width, (FTopRight.FSBottom - FTopRight.FSTop));
        DrawPartnormal(SrcRect, self, TrgtRect, False);

        //TOP  //ÜST
        SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
        TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0,
          self.Width - (FTopRight.FSRight - FTopRight.FSLeft),
          (FTop.FSBottom - FTop.FSTop));
        DrawPartnormal(SrcRect, self, TrgtRect, False);




        //BOTTOMLEFT // SOLALT
        SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop,
          FBottomleft.FSRight, FBottomleft.FSBottom);
        TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
          (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
        DrawPartnormal(SrcRect, self, TrgtRect, False);

        //BOTTOMRIGHT  //SAĞALT
        SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
          FBottomRight.FSRight, FBottomRight.FSBottom);
        TrgtRect := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft),
          Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
        DrawPartnormal(SrcRect, self, TrgtRect, False);

        //BOTTOM  //ALT
        SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
        TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
          self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
          (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
        DrawPartnormal(SrcRect, self, TrgtRect, False);




        //CENTERLEFT // SOLORTA
        SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
        TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
          (Fleft.FSRight - Fleft.FSLeft), Height -
          (FBottomleft.FSBottom - FBottomleft.FSTop));
        DrawPartnormal(SrcRect, self, TrgtRect, False);

        //CENTERRIGHT // SAĞORTA
        SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
        TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
          (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
          (FBottomRight.FSBottom - FBottomRight.FSTop));
        DrawPartnormal(SrcRect, self, TrgtRect, False);

        //CENTER //ORTA
        SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
        TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
          Width - (FRight.FSRight - FRight.FSLeft), Height -
          (FBottom.FSBottom - FBottom.FSTop));
        DrawPartnormal(SrcRect, self, TrgtRect, False);



         // BUTTTON DRAW
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            SrcRect := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
          end;
          obspressed:
          begin
            SrcRect := Rect(FPress.FSLeft, FPress.FSTop,
              FPress.FSRight, FPress.FSBottom);
          end;
          obshover:
          begin
            SrcRect := Rect(FEnter.FSLeft, FEnter.FSTop,
              FEnter.FSRight, FEnter.FSBottom);
          end;
        end;
      end
      else
      begin
        SrcRect := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
      end;

      {case Fheaderstate of


      end;
       }

      if fbutondirection=obright then
         fbutonarea:=Rect(Self.Width-(FTop.FsBottom-FTop.FSTop),0,self.Width,FTop.FsBottom-FTop.FSTop)
      else
        fbutonarea:=Rect(0,0,Self.Width-(FTop.FsBottom-FTop.FSTop),FTop.FsBottom-FTop.FSTop);

       DrawPartnormal(SrcRect, self, fbutonarea, False);

       if Length(Caption) > 0 then
        begin
//          canvas.Font.Color := self.Fontcolor;
          textx := (self.Width div 2) - (self.canvas.TextWidth(Caption) div 2);
          Texty := ((FTop.FSBottom-FTop.FSTop) div 2) - (self.canvas.TextHeight(Caption) div 2);
          Fresim.CanvasBGRA.Brush.Style := bsClear;
          Fresim.CanvasBGRA.TextOut(Textx, Texty, (Caption));
        end;


        if Crop then
          CropToimg(Fresim);
      finally
        //  FreeAndNil(img);
      end;
    end
    else
    begin
      Fresim.Fill(BGRA(207, 220, 207), dmSet);
    end;
    inherited Paint;



end;

{ TONProgressBar }

procedure tonprogressbar.setposition(const val: int64);
begin
  fposition := ValueRange(Val, fmin, fmax);
  Caption := IntToStr(fposition);
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure tonprogressbar.setmax(const val: int64);
begin
  if fmax <> val then
  begin
    fmax := Val;
  end;
end;

procedure tonprogressbar.setmin(const val: int64);
begin
  if fmin <> val then
  begin
    fmin := Val;
  end;
end;

function tonprogressbar.getposition: int64;
begin
  Result := fposition;
end;

function tonprogressbar.getmin: int64;
begin
 Result := fmin;
end;

function tonprogressbar.getmax: int64;
begin
 Result := fmax;
end;

procedure tonprogressbar.setkind(avalue: tonkindstate);
var
  a:integer;
begin
  inherited setkind(avalue);
  a:=self.Width;
  if Kind = oHorizontal then
  begin
   fskinname      := 'progressbarh';
   self.Width:=self.Height;
   self.Height:=a;
  end
  else
  begin
   fskinname      := 'progressbarv';
   self.Width:=self.Height;
   self.Height:=a;
  end;
  Skindata:=self.Skindata;
  Invalidate;
end;

constructor tonprogressbar.create(aowner: tcomponent);
begin
  inherited Create(Aowner);
  Fskinname:='progressbarh';
  Fkind := oHorizontal;
  self.Width := 150;
  self.Height := 10;
  fmin := 0;
  fmax := 100;
  fposition := 10;

  Fleft := TONCustomCrop.Create;
  Fleft.cropname:='ONLEFT';
  FCenter := TONCustomCrop.Create;
  FCenter.cropname:='ONCENTER';
  FRight := TONCustomCrop.Create;
  FRight.cropname:='ONRIGHT';
  fbar := TONCustomCrop.Create;
  fbar.cropname:='ONBAR';
  FCaptonvisible := True;
end;

destructor tonprogressbar.destroy;
begin
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);
  FreeAndNil(Fbar);
  inherited destroy;
end;

procedure tonprogressbar.paint;
var
  DR,DBAR: TRect;
//  fbuttoncenter,textx, Texty: integer;
begin
 // if csDesigning in ComponentState then
 //   Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);
  Fresim.SetSize(self.Width, Self.Height);
  if (FSkindata <> nil) then    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin

    if self.Kind = oHorizontal then
    begin
      DR := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      DrawPartstrechRegion(DR,Self,Fleft.FSRight-Fleft.FSLeft,self.Height,Rect(0,0,Fleft.FSRight-Fleft.FSLeft,Height),false);
      DR := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      DrawPartstrechRegion(DR,Self,FRight.FSRight-FRight.FSLeft,self.Height,Rect(Width-(FRight.FSRight - FRight.FSLeft),0,Width,Height),false);
      DR := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      DrawPartstrechRegion(DR,Self,Width-((FRight.FSRight - FRight.FSLeft)+(Fleft.FSRight-Fleft.FSLeft)),self.Height,Rect((Fleft.FSRight - Fleft.FSLeft),0,Width-(FRight.FSRight - FRight.FSLeft),Height),false);
      DR:=Rect(Fbar.FSLeft, Fbar.FSTop, Fbar.FSright, Fbar.FSBottom);
      DBAR := Rect(Fleft.FSright-Fleft.FSLeft, 0 {(Fleft.FSBottom- Fleft.FSTop) div 2}, (fposition * self.Width) div fmax, Height);//-((FRight.FSBottom- FRight.FSTop) div 2));
      DrawPartnormal(DR,self,DBAR,false);

    end
    else
    begin
      DR := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
//      DrawPartstrech(DR,self,self.Width,Fleft.FSBottom - Fleft.FSTop);
      DrawPartstrechRegion(DR,Self,self.Width,Fleft.FSBottom-Fleft.FSTop,Rect(0,0,Width,Fleft.FSBottom-Fleft.FSTop),false);

      DR := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      DrawPartstrechRegion(DR,Self,self.Width,FRight.FSBottom-FRight.FSTop,Rect(0,Height-(FRight.FSBottom-FRight.FSTop) ,Width,Height),false);

 //     DrawPartstrech(DR,self,self.Width,(FRight.FSBottom - FRight.FSTop));

      DR := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
       DrawPartstrechRegion(DR,Self,Width,self.Height-((FRight.FSBottom - FRight.FSTop)+(Fleft.FSBottom-Fleft.FSTop)),Rect(0,(Fleft.FSBottom - Fleft.FSTop),Width,Height-(FRight.FSBottom - FRight.FSTop)),false);

  //    DrawPartnormal(DR,self,Rect(Fleft.FSright,Fleft.FSTop, self.Width,Height-((Fleft.FSBottom - Fleft.FSTop)+(FRight.FSBottom - FRight.FSTop)));

      DR:=Rect(Fbar.FSLeft, Fbar.FSTop, Fbar.FSRight, Fbar.FSBottom);
      DBAR := Rect({(Fleft.FSright-Fleft.FSLeft) div 2}0, Fleft.FSBottom-Fleft.FSTop, Width{-((FRight.FSRight- FRight.FSLeft) div 2)}, (fposition * self.Height) div fmax);

      DrawPartnormal(DR,self,DBAR,false);
    end;


  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  Captionvisible:=FCaptonvisible;
  inherited paint;
end;


{ TOnCheckbox }



procedure toncheckbox.setchecked(value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if (self is TOnRadioButton) then
      deaktifdigerleri;

    Invalidate;
  end;
end;

function toncheckbox.getcheckwidth: integer;
begin
  Result := fcheckwidth;
end;

procedure toncheckbox.setcheckwidth(avalue: integer);
begin
  if fcheckwidth = AValue then exit;
  fcheckwidth := AValue;
  Invalidate;
end;

procedure toncheckbox.setcaptionmod(const val: tcapdirection);
begin
  if fcaptiondirection = val then
    exit;
  fcaptiondirection := val;
  Invalidate;
end;

function toncheckbox.getcaptionmod: tcapdirection;
begin
  Result := fcaptiondirection;
end;

procedure toncheckbox.deaktifdigerleri;
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
        if (Controls[i] is TonRadiobutton) and (Sibling <> Self) then
        begin
          TonRadiobutton(Sibling).SetChecked(False);// Checked := False;
          TonRadiobutton(Sibling).fstate := obsnormal;// Checked := False;
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


procedure toncheckbox.cmonmouseenter(var messages: tmessage);
begin
 fstate := obshover;
  Invalidate;
end;

procedure toncheckbox.cmonmouseleave(var messages: tmessage);
begin
  fstate := obsnormal;
  Invalidate;
end;

procedure toncheckbox.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
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

procedure toncheckbox.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited mouseup(button, shift, x, y);
  fstate := obshover;
  Invalidate;
end;

procedure toncheckbox.doonchange;
begin
  EditingDone;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure toncheckbox.cmhittest(var msg: tcmhittest);
begin
  inherited;
   if PtInRegion(CreateRectRgn(0, 0, self.Width, self.Height), msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
end;

constructor toncheckbox.create(aowner: tcomponent);
begin
  inherited create(aowner);
  if self is TOnRadioButton then
  fskinname      := 'radiobox'
  else
  fskinname      := 'checkbox';
  fcheckwidth:=12;
  fcaptiondirection:=ocright;
  obenter:=TONCUSTOMCROP.Create;
  obenter.cropname := 'NORMALHOVER';
  obleave:=TONCUSTOMCROP.Create;
  obleave.cropname := 'NORMAL';
  obdown:=TONCUSTOMCROP.Create;
  obdown.cropname := 'PRESSED';
  obcheckleaves:=TONCUSTOMCROP.Create;
  obcheckleaves.cropname := 'CHECK';
  obcheckenters:=TONCUSTOMCROP.Create;
  obcheckenters.cropname := 'CHECKHOVER';
  obdisabled:=TONCUSTOMCROP.Create;
  obdisabled.cropname := 'DISABLE';
  Fstate:=obsnormal;
  FChecked:=False;
  Captionvisible:=false;
end;

destructor toncheckbox.destroy;
begin
  FreeAndNil(obenter);
  FreeAndNil(obleave);
  FreeAndNil(obdown);
  FreeAndNil(obcheckenters);
  FreeAndNil(obcheckleaves);
  FreeAndNil(obdisabled);
  inherited destroy;
end;

procedure toncheckbox.paint;
var
  DR,borderect: TRect;
  fbuttoncenter,textx, Texty: integer;
begin
 // if csDesigning in ComponentState then
 //   Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);
 // Self.Height:=self.canvas.TextHeight(Caption);
  Fresim.SetSize(self.Width, Self.Height);
  if (FSkindata <> nil) then    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin

      if Enabled = True then
      begin
         if Checked=true then
         begin
           case Fstate of
            obsNormal:
            begin
              DR := Rect(obcheckleaves.FSLeft, obcheckleaves.FSTop,
                obcheckleaves.FSRight, obcheckleaves.FSBottom);
              Self.Font.Color:=obcheckleaves.Fontcolor;
            end;
            obshover:
            begin
              DR := Rect(obcheckenters.FSLeft, obcheckenters.FSTop,
                obcheckenters.FSRight, obcheckenters.FSBottom);
              Self.Font.Color:=obcheckenters.Fontcolor;
            end;
            obspressed:
            begin
              DR := Rect(obdown.FSLeft, obdown.FSTop,
                obdown.FSRight, obdown.FSBottom);
              Self.Font.Color:=obdown.Fontcolor;
            end;
          end;
        end
        else
        begin
            case Fstate of
            obsNormal:
            begin
              DR := Rect(obleave.FSLeft, obleave.FSTop,
                obleave.FSRight, obleave.FSBottom);
              Self.Font.Color:=obleave.Fontcolor;
            end;
            obshover:
            begin
              DR := Rect(obenter.FSLeft, obenter.FSTop,
                obenter.FSRight, obenter.FSBottom);
              Self.Font.Color:=obenter.Fontcolor;
            end;
          obspressed:
            begin
              DR := Rect(obdown.FSLeft, obdown.FSTop,
                obdown.FSRight, obdown.FSBottom);
              Self.Font.Color:=obdown.Fontcolor;
            end;
          end;
        end;
      end
      else
      begin
        DR := Rect(obdisabled.FSLeft, obdisabled.FSTop, obdisabled.FSRight, obdisabled.FSBottom);
        Self.Font.Color:=obdisabled.Fontcolor;
      end;


      case fCaptionDirection of
        ocup:
        begin
          textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
          Texty := DR.Top;//fborderWidth;
          fbuttoncenter := ((Height div 2) div 2) + (fcheckwidth div 2);
          borderect := Rect((Width div 2) - (fcheckwidth div 2), fbuttoncenter,
        (Width div 2) + (fcheckwidth div 2), fbuttoncenter + fcheckwidth);
        end;
        ocdown:
        begin
          textx := (Width div 2) - (self.canvas.TextWidth(Caption) div 2);
          Texty := ((Height div 2))+DR.Top;// + fborderWidth;
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
          textx := fcheckwidth+5;
          Texty := (Height div 2) - (self.canvas.TextHeight(Caption) div 2);
          fbuttoncenter := (Height div 2) - (fcheckwidth div 2);
          borderect := Rect(0, fbuttoncenter, fcheckwidth, fbuttoncenter + fcheckwidth);
        end;
      end;


    //  DrawPartstrech(DR, self, fcheckwidth,fcheckwidth);//Width, Height);
      DrawPartnormal(DR,Self,borderect,False);

  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;




  inherited paint;
  if Length(Caption) > 0 then
    begin
      canvas.Brush.Style := bsClear;
      canvas.TextOut(Textx, Texty, (Caption));
    end;
end;

{ TOnSwich }

procedure tonswich.setchecked(value: boolean);
begin
  if FChecked<>value then
  begin
    FChecked:=value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure tonswich.CMonmouseenter(var Messages: Tmessage);
begin
   if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obshover;
  Invalidate;
end;

procedure tonswich.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  fstate := obsnormal;
  Invalidate;
end;



procedure tonswich.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
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

procedure tonswich.MouseUp(Button: TMouseButton; Shift: TShiftState;
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



constructor tonswich.create(aowner: tcomponent);
begin
  inherited create(aowner);
  fskinname      := 'swich';
  FOpen:=TONCUSTOMCROP.Create;
  FOpen.cropname := 'OPEN';
  Fclose:=TONCUSTOMCROP.Create;
  Fclose.cropname := 'CLOSE';
  Fopenhover:=TONCUSTOMCROP.Create;
  Fopenhover.cropname := 'OPENHOVER';
  Fclosehover:=TONCUSTOMCROP.Create;
  Fclosehover.cropname := 'CLOSEHOVER';
  Fdisable:=TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate:=obsnormal;
  FChecked:=False;
  Captionvisible:=false;
//  FOnChange:=TNotifyEvent;
end;

destructor tonswich.destroy;
begin
  FreeAndNil(FOpen);
  FreeAndNil(Fclose);
  FreeAndNil(Fopenhover);
  FreeAndNil(Fclosehover);
  FreeAndNil(Fdisable);
  inherited destroy;
end;

procedure tonswich.paint;
var
  //  HEDEF,
  DR: TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);
  Fresim.SetSize(self.Width, Self.Height);
  if (FSkindata <> nil) then    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin
    try
      if Enabled = True then
      begin
         if Checked=true then
         begin
           case Fstate of
            obsNormal:
            begin
              DR := Rect(FOpen.FSLeft, FOpen.FSTop,
                FOpen.FSRight, FOpen.FSBottom);
              Self.Font.Color:=FOpen.Fontcolor;
            end;
            obshover:
            begin
              DR := Rect(Fopenhover.FSLeft, Fopenhover.FSTop,
                Fopenhover.FSRight, Fopenhover.FSBottom);
              Self.Font.Color:=Fopenhover.Fontcolor;
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
              DR := Rect(Fclose.FSLeft, Fclose.FSTop,
                Fclose.FSRight, Fclose.FSBottom);
              Self.Font.Color:=Fclose.Fontcolor;
            end;
            obshover:
            begin
              DR := Rect(Fclosehover.FSLeft, Fclosehover.FSTop,
                Fclosehover.FSRight, Fclosehover.FSBottom);
              Self.Font.Color:=Fclosehover.Fontcolor;
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
        DR := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
        Self.Font.Color:=Fdisable.Fontcolor;
      end;

      DrawPartstrech(DR, self, Width, Height);

    finally

    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;


{ TONHeaderPanel }

constructor TONHeaderPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fskinname      := 'headerpanel';
end;

{ ToNListBox }


constructor tonlistbox.create(aowner: tcomponent);
begin
   inherited Create(Aowner);
  parent       := TWinControl(Aowner);
  Width        := 180;
  Height       := 200;
  TabStop      := True;
  Fselectedcolor :=clblue;
  fskinname      := 'listbox';
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  findex       := -1;
  Flist        := TStringList.Create;
  TStringList(Flist).OnChange := @LinesChanged;
  FItemsShown  := 0;
  FitemHeight  := self.canvas.TextExtent('Çİ').cy;
  Fitemoffset  := 0;
//  FFocusedItem := -1;
  fvert := TonScrollBar.Create(self);
  with fvert do
  begin
    Parent := self;
    Kind := oVertical;
    Skinname:='scrollbarv';
    Width := 25;
    left := Self.Width - (25);// + Background.Border);
    Top := 0;//Background.Border;
    Height := Self.Height;// - (Background.Border * 2);
    Max := 100;//Flist.Count;
    Min := 0;
    OnChange := @Scrollchange;
    Position := 0;
    Visible  := false;
  end;

  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  factiveitems:= TONCUSTOMCROP.Create;
  factiveitems.cropname := 'ACTIVEITEM';
  Captionvisible:=false;
//  Backgroundbitmaped:=false;
end;

destructor tonlistbox.destroy;
begin
  if Assigned(fvert) then
    FreeAndNil(fvert);
  if Assigned(fhorz) then
    FreeAndNil(fhorz);
    FreeAndNil(Flist);

    FreeAndNil(FTop);
    FreeAndNil(FBottom);
    FreeAndNil(FCenter);
    FreeAndNil(FRight);
    FreeAndNil(Fleft);
    FreeAndNil(FTopRight);
    FreeAndNil(FBottomRight);
    FreeAndNil(FTopleft);
    FreeAndNil(FBottomleft);
    FreeAndNil(factiveitems);
   inherited destroy;
end;

procedure tonlistbox.paint;
  var
  a, b, k, i: integer;
  Desc,Target:Trect;
  colr:Tcolor;

begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);

  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil) then
  begin

  //UST TOP
      Desc := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      Target := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.Width -
        (FTopRight.FSRight - FTopRight.FSLeft), (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(Desc, self, Target, False);

      //SOL ÜST TOPLEFT
      Desc := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight, FTopleft.FSBottom);
      Target := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft, FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(Desc, self, Target, False);

      //SAĞ ÜST TOPRIGHT
      Desc := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight, FTopRight.FSBottom);
      Target := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft), 0, Width,
        (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(Desc, self, Target, False);


      // SOL ALT BOTTOMLEFT
      Desc := Rect(FBottomleft.FSLeft, FBottomleft.FSTop, FBottomleft.FSRight, FBottomleft.FSBottom);
      Target := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(Desc, self, Target, False);


      //SAĞ ALT BOTTOMRIGHT
      Desc := Rect(FBottomRight.FSLeft, FBottomRight.FSTop, FBottomRight.FSRight, FBottomRight.FSBottom);
      Target := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft), Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
      DrawPartnormal(Desc, self, Target, False);


      //ALT BOTTOM                colr:TBGRAPixel;
      Desc := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      Target := Rect((FBottomleft.FSRight - FBottomleft.FSLeft), self.Height -
        (FBottom.FSBottom - FBottom.FSTop), Width - (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
      DrawPartnormal(Desc, self, Target, False);

      // SOL ORTA CENTERLEFT
      Desc := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      Target := Rect(0, FTopleft.FSBottom - FTopleft.FSTop, (Fleft.FSRight - Fleft.FSLeft),
        Height - (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(Desc, self, Target, False);

      // SAĞ ORTA CENTERRIGHT
      Desc := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      Target := Rect(Width - (FRight.FSRight - FRight.FSLeft), (FTopRight.FSBottom - FTopRight.FSTop),
        Width, Height - (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(Desc, self, Target, False);


      //ORTA CENTER
      Desc := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      Target := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - (FRight.FSRight - FRight.FSLeft), Height - (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(Desc, self, Target, False);

      itempaintHeight:=Target;
      if Crop then
        CropToimg(Fresim);
  end
  else
  begin
     Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;

    //   FitemHeight:=self.canvas.TextHeight('ŹÇ');

      if Flist.Count > 0 then
      begin
        FItemsShown := itempaintHeight.Height div FitemHeight;//(FCenter.FSBottom-FCenter.FSTop) div FitemHeight;//
       // FItemsShown := self.Height div FitemHeight;

        if Flist.Count-FItemsShown+1 > 0 then
        begin
           with fvert do
           begin
             Width := 25;
             left := Self.Width - (Width);
             Top := 1;
             Height := Self.Height;
             Max:=Flist.Count-FItemsShown;
             if Skindata=nil then
             Skindata:=Self.Skindata;
           end;
        end;
        //else
        //fvert.Max:=0;


        if Flist.Count * FItemHeight > itempaintHeight.Height then//self.Height then
          fvert.Visible := True
        else
          fvert.Visible := False;

          a := Fleft.FSright-Fleft.FSLeft;
          b := FTop.FSBottom-FTop.FSTop;

           for i := FItemOffset to (FItemOffset + (itempaintHeight.Height) div FItemHeight) -1 do //(Height) div FItemHeight)-1 do
      //     for i := FItemOffset to (FItemOffset + (Height) div FItemHeight)-1 do
            begin
              if i < Flist.Count then
              begin
                 if i = findex then
                  begin
                   if Assigned(fvert) then
//                   Target:=Rect(a, b-(FitemHeight div 2), self.Width-(fvert.Width+a)),b +(FitemHeight div 2))
                    Target:=Rect(a, b, self.Width-fvert.Width,b +FitemHeight)
                   else
               //    Target:=Rect(a, b-(FitemHeight div 2), self.Width - a,b + (FitemHeight div 2));
                   Target:=Rect(a, b, self.Width ,b + FitemHeight);

                   Desc := Rect(Factiveitems.FSLeft, Factiveitems.FSTop, Factiveitems.FSRight, Factiveitems.FSBottom);
                   DrawPartnormal(Desc, self, Target, False);
                   colr:=Fselectedcolor;
                 end else
                   colr:=self.Font.Color;//FTextColor;

               //  fresim.CanvasBGRA.Brush.Style := bsClear;
                Fresim.FontName:=self.Font.Name;
                Fresim.FontStyle:=self.Font.Style;
                Fresim.FontAntialias:=true;
                Fresim.FontHeight:=-self.Font.Height;
                Fresim.TextOut(a,b,Flist[i],colr);
               //  fresim.CanvasBGRA.TextOut(a, b, Flist[i]);
              //   end;
                // colr:=FTextCurrentColor;

             end;
             b := b + FitemHeight;
             if (b>=itempaintHeight.Height) then Break;
          //  if (b >= Height) then Break;
            end;
      end;
 inherited paint;
end;

function tonlistbox.domousewheeldown(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  inherited domousewheeldown(shift, mousepos);
  if not Fvert.visible then exit;
  Fvert.Position := Fvert.Position+Mouse.WheelScrollLines;
  FItemOffset := fvert.Position;
  Result := True;
  Invalidate;
end;

function tonlistbox.domousewheelup(shift: tshiftstate; mousepos: tpoint
  ): boolean;
begin
  inherited domousewheelup(shift, mousepos);
  if not Fvert.visible then exit;
  Fvert.Position := Fvert.Position-Mouse.WheelScrollLines;
  FItemOffset := fvert.Position;
  Result := True;
  Invalidate;
end;



function tonlistbox.getitemat(pos: tpoint): integer;
begin
  Result := -1;
  //if (Pos.Y >= 0) and (PtInRect(itempaintHeight,pos)) then
  if Pos.Y >= 0 then
  begin
    Result := FItemOffset + (pos.Y div FItemHeight)-1;
    if (Result > Items.Count-1) or (Result > (FItemOffset+FItemsShown)-1) then
      Result := -1;
  end;
end;

function tonlistbox.getitemheight: integer;
begin
 Result:=FitemHeight;
end;

procedure tonlistbox.setitemheight(avalue: integer);
begin
  if avalue<>FitemHeight then FitemHeight:=avalue;
end;


function tonlistbox.itemrect(item: integer): trect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);

  if (Item >= FItemOffset - 1) and ((Item - FItemOffset) * FItemHeight <  Height) then
  begin
    r.Top := (Item - FItemOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left := 0;

    if Assigned(fvert) and (fvert.Visible) then
      r.Right := fvert.Left
    else
      r.Right := Width-(Fleft.FSright-Fleft.FSLeft);

    if Assigned(fhorz) and (fhorz.Visible) then
      r.Bottom := fhorz.Top
    else
      r.Bottom := Height-(FBottom.FSBottom-FBottom.FSTop);
  end;

  Result := r;
end;

procedure tonlistbox.lineschanged(sender: tobject);
begin
  Invalidate;
end;

procedure tonlistbox.movedown;
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

    end;
end;

procedure tonlistbox.moveend;
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
    end;

end;

procedure tonlistbox.movehome;
  var
    i: integer;
  begin
    if flist.Count > 0 then
    begin
      findex := 0;
      FItemOffset := 0;
    end;

end;

procedure tonlistbox.moveup;

  begin
    if flist.Count > 0 then
    begin
//      Shift := GetKeyState(VK_SHIFT) < 0;

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

    end;

end;



function tonlistbox.getitemindex: integer;
begin
    Result := findex;
end;
procedure tonlistbox.setitemindex(avalue: integer);
  var
   Shown: integer;
  begin
    if Flist.Count = 0 then exit;
    if findex = aValue then Exit;
    if findex = -1 then exit;
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

procedure tonlistbox.mousedown(button: tmousebutton; shift: tshiftstate;
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

procedure tonlistbox.scrollchange(sender: tobject);
begin
  FItemOffset := fvert.Position;
  Invalidate;
end;

procedure tonlistbox.dblclick;
var
    pt : TPoint;
    i  : Integer;
 begin

    if Items.Count > 0 then
    begin
      GetCursorPos(pt);
      i := GetItemAt(ScreenToClient(pt));
      if i > -1 then
      begin
        findex    := i;
        Invalidate;
//        if Assigned(FItemDblClick) then FItemDblClick(Self);
      end;
    end;
  inherited dblclick;
end;

procedure tonlistbox.keydown(var key: word; shift: tshiftstate);
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
  inherited;
end;

procedure tonlistbox.setstring(avalue: tstrings);
begin
 if Flist=AValue then Exit;
  Flist.Assign(AValue);
end;


procedure tonlistbox.beginupdate;
begin
 flist.BeginUpdate;
end;

procedure tonlistbox.endupdate;
begin
Flist.EndUpdate;
end;

procedure tonlistbox.clear;
begin
 Flist.Clear;
end;




{ ToNScrollBar }


function tonscrollbar.getposition: int64;
begin
  Result :=FPosValue; //CalculatePosition(SliderFromPosition(FPosition));
end;

procedure tonscrollbar.setposition(value: int64);
begin
   if FIsPressed then Exit;
  Value := ValueRange(Value, FMin, FMax);

  if FKind = oHorizontal then
  begin
    FPosition := PositionFromSlider(Value);
     FPosValue := Value - FMin; // WriteLn(fposition,'   ',FPosValue);
  end
  else
  begin
    FPosition := PositionFromSlider(value);// FMax - Val);
    FPosValue := Value; //FMax - Value;
  end;
  Changed;
  Invalidate;
end;



function tonscrollbar.getmin: int64;
begin
  Result := FMin;
end;

procedure tonscrollbar.setmin(val: int64);
begin
   if Val <> FMin then FMin := Val;
end;


function tonscrollbar.getmax: int64;
begin
 Result := FMax;
end;

procedure tonscrollbar.setmax(val: int64);
begin
  if Val <> FMax then FMax := Val;
end;

function tonscrollbar.maxmin: int64;
begin
  Result := FMax - FMin;
end;


function tonscrollbar.checkrange(const value: int64): int64;
begin
  if FKind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function tonscrollbar.calculateposition(const value: integer): int64;
begin
  if FKind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;//FMax-Value; //for revers
end;

function tonscrollbar.sliderfromposition(const value: integer): int64;
var
  iHW: Integer;
begin
  iHW := 0;
  case FKind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;
  Result := Round(Value / iHW * MaxMin);
end;



function tonscrollbar.positionfromslider(const value: integer): int64;
var
  iHW: Integer;
begin
  iHW := 0;
  case FKind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;
  Result := Round((iHW / MaxMin) * Value);
 end;

function tonscrollbar.getpercentage: int64;
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

procedure tonscrollbar.setpercentage(value: int64);
begin
   Value := ValueRange(Value, 0, 100);

  if FKind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;

procedure tonscrollbar.setkind(avalue: tonkindstate);
var
  a:integer;
begin
  inherited setkind(avalue);
  a:=self.Width;
  if Kind = oHorizontal then
  begin
   fskinname      := 'scrollbarh';
   self.Width:=self.Height;
   self.Height:=a;
  end
  else
  begin
   fskinname      := 'scrollbarv';
   self.Width:=self.Height;
   self.Height:=a;
  end;
  Skindata:=self.Skindata;
  Invalidate;
end;

procedure tonscrollbar.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
var
  a:int64;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;

  if (Button = mbleft) and (PtInRect(flbuttonrect, point(X, Y))) then  // left button down
  begin
    position := position-1;
    flbutons := obspressed;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    if Assigned(FOnChange) then FOnChange(Self);
  end
  else
  begin
    if (Button = mbleft) and (PtInRect(frbuttonrect, point(X, Y))) then   // right button down
    begin
      flbutons := obsnormal;
      frbutons := obspressed;
      fcbutons := obsnormal;
      Position := Position + 1;
      if Assigned(FOnChange) then FOnChange(Self);
    end
    else
    begin
      if (Button = mbleft) and (PtInRect(fcenterbuttonarea, point(X, Y))) then
        // right button down
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obspressed;
        fispressed := True;
        Invalidate;
      end
      else
      begin
        if (Button = mbleft) and (PtInRect(Ftrackarea, point(X, Y))) then
          // right button down
        begin
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;
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
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;
          FIsPressed := False;
          Invalidate;
        end;
      end;
    end;
  end;
 // paint;
end;

procedure tonscrollbar.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FIsPressed := False;
  flbutons := obsnormal;
  frbutons := obsnormal;
  fcbutons := obsnormal;
  Invalidate;
end;

procedure tonscrollbar.mousemove(shift: tshiftstate; x, y: integer);
begin
inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;
  if (PtInRect(flbuttonrect, point(X, Y))) then
  begin
    fcbutons := obsnormal;
    flbutons := obshover;
    frbutons := obsnormal;
  end
  else
  begin
    if (PtInRect(frbuttonrect, point(X, Y))) then
    begin
      fcbutons := obsnormal;
      flbutons := obsnormal;
      frbutons := obshover;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, point(X, Y))) then
      begin

        if fispressed then
        begin
          if Fkind = oHorizontal then
            FPosition :=
              CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition :=
              CheckRange(y - (fcenterbuttonarea.Height + (fcenterbuttonarea.Height div 2)));

         if Assigned(FOnChange) then FOnChange(Self);
        end;

        fcbutons := obshover;
        flbutons := obsnormal;
        frbutons := obsnormal;
      end
      else
      begin
        if fispressed then
        begin
          if Fkind = oHorizontal then
            FPosition :=
              CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition :=
              CheckRange(y - (fcenterbuttonarea.Height + (fcenterbuttonarea.Height div 2)));
         if Assigned(FOnChange) then FOnChange(Self);
        end;
        fcbutons := obsnormal;
        flbutons := obsnormal;
        frbutons := obsnormal;
      end;
    end;
  end;
  Invalidate;
end;

procedure tonscrollbar.cmonmouseenter(var messages: tmessage);
var
  Cursorpos: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if (fcbutons = obshover) and (flbutons = obshover) and (frbutons = obshover) then
    Exit;
  inherited MouseEnter;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);


  if (PtInRect(flbuttonrect, Cursorpos)) then
  begin
    flbutons := obshover;
    frbutons := obsnormal;
    fcbutons := obsnormal;
  end
  else
  begin
    if (PtInRect(frbuttonrect, Cursorpos)) then
    begin
      flbutons := obsnormal;
      frbutons := obshover;
      fcbutons := obsnormal;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, Cursorpos)) then
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obshover;
      end
      else
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obsnormal;
      end;
    end;
  end;
  Invalidate;

end;

procedure tonscrollbar.cmonmouseleave(var messages: tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;
  flbutons := obsnormal;
  frbutons := obsnormal;
  fcbutons := obsnormal;
  Invalidate;
end;


constructor tonscrollbar.create(aowner: tcomponent);
begin
  inherited create(aowner);
//  Parent := AOwner as TWinControl;
  Flbuttonrect := Rect(1, 1, 20, 21);
  Frbuttonrect := Rect(179, 1, 199, 21);
  Ftrackarea := Rect(21, 1, 178, 21);
//  Kind := oHorizontal;
  Width := 200;
  Height := 22;
  fmax := 100;
  fmin := 0;
  fposition := 0;
  fskinname      := 'scrollbarh';
  flbutons := obsNormal;
  frbutons := obsNormal;
  fcbutons := obsNormal;


  FNormali           := TONCUSTOMCROP.Create;
  FNormali.cropname  := 'NORMAL';
  Fleft              := TONCUSTOMCROP.Create;
  Fleft.cropname     := 'LEFT';
  FRight             := TONCUSTOMCROP.Create;
  FRight.cropname    := 'RIGHT';
  FTop               := TONCUSTOMCROP.Create;
  FTop.cropname      := 'TOP';
  FBottom            := TONCUSTOMCROP.Create;
  FBottom.cropname   := 'BOTTOM';
  Fbar               := TONCUSTOMCROP.Create;
  Fbar.cropname      := 'BAR';

  FbuttonNL          := TONCUSTOMCROP.Create;
  FbuttonNL.cropname := 'BUTTONNORMALL';
  FbuttonUL          := TONCUSTOMCROP.Create;
  FbuttonUL.cropname := 'BUTTONHOVERL';
  FbuttonBL          := TONCUSTOMCROP.Create;
  FbuttonBL.cropname := 'BUTTONPRESSEDL';
  FbuttonDL          := TONCUSTOMCROP.Create;
  FbuttonDL.cropname := 'BUTTONDISABLEL';

  FbuttonNR          := TONCUSTOMCROP.Create;
  FbuttonNR.cropname := 'BUTTONNORMALR';
  FbuttonUR          := TONCUSTOMCROP.Create;
  FbuttonUR.cropname := 'BUTTONHOVERR';
  FbuttonBR          := TONCUSTOMCROP.Create;
  FbuttonBR.cropname := 'BUTTONPRESSEDR';
  FbuttonDR          := TONCUSTOMCROP.Create;
  FbuttonDR.cropname := 'BUTTONDISABLER';


  FbuttonCN          := TONCUSTOMCROP.Create;
  FbuttonCN.cropname := 'CENTERBUTTONNORMAL';
  FbuttonCU          := TONCUSTOMCROP.Create;
  FbuttonCU.cropname := 'CENTERBUTTONHOVER';
  FbuttonCB          := TONCUSTOMCROP.Create;
  FbuttonCB.cropname := 'CENTERBUTTONPRESSED';
  FbuttonCD          := TONCUSTOMCROP.Create;
  FbuttonCD.cropname := 'CENTERBUTTONDISABLE';

//  Backgroundbitmaped:=false;
  Captionvisible:=false;
end;

destructor tonscrollbar.destroy;
begin

  Skindata:=nil;
  FreeAndNil(FbuttonNL);
  FreeAndNil(FbuttonUL);
  FreeAndNil(FbuttonBL);
  FreeAndNil(FbuttonDL);
  FreeAndNil(FbuttonNR);
  FreeAndNil(FbuttonUR);
  FreeAndNil(FbuttonBR);
  FreeAndNil(FbuttonDR);

  FreeAndNil(FbuttonCN);
  FreeAndNil(FbuttonCU);
  FreeAndNil(FButtonCB);
  FreeAndNil(FButtonCD);
  FreeAndNil(FNormali);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(Fbar);
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  inherited destroy;
end;

procedure tonscrollbar.paint;
var
  DR:TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);
  centerbuttonareaset;
  Fresim.SetSize(self.Width, self.Height);
   if (FSkindata <> nil) then
   begin
        // BACKGROUND DRAW
      if self.Kind = oHorizontal then
      begin
        DR := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
        DrawPartstrechRegion(DR,self,Fleft.FSRight-Fleft.FSLeft,Height,flbuttonrect,false);      //   rect(0, 0, Fleft.FSRight - Fleft.FSLeft, Height), False);
        DR := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
        DrawPartstrechRegion(DR,self,(FRight.FSRight - FRight.FSLeft),self.Height,frbuttonrect,false);        //Rect(self.Width -(FRight.FSRight - FRight.FSLeft), 0, self.Width, self.Height),false);
        DR := Rect(FNormali.FSLeft, FNormali.FSTop, FNormali.FSRight, FNormali.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width-((Fleft.FSRight - Fleft.FSLeft)+(FRight.FSRight - FRight.FSLeft)),self.Height,Ftrackarea,false);
    //    self.Width-((Fleft.FSRight - Fleft.FSLeft)+(FRight.FSRight - FRight.FSLeft)),self.Height,Rect((Fleft.FSRight - Fleft.FSLeft), 0, (Width - (FRight.FSRight - FRight.FSLeft)), Height),false);
      end else
      begin
        DR := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,FTop.FSBottom - FTop.FSTop,flbuttonrect, False);
        DR := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,(FBottom.FSBottom - FBottom.FSTop),frbuttonrect,false);
        DR := Rect(FNormali.FSLeft, FNormali.FSTop, FNormali.FSRight, FNormali.FSBottom);
        DrawPartstrechRegion(DR,self,Width,Height-((FTop.FSBottom - FTop.FSTop)+(FBottom.FSBottom - FBottom.FSTop)),Ftrackarea,false);
      end;



      /////////// DRAW TO BUTTON ///////////



        if Enabled=true then  // LEFT OR TOP BUTTON
        begin
          case flbutons of
             obsnormal   : DR := Rect(FbuttonNL.FSLeft, FbuttonNL.FSTop, FbuttonNL.FSRight, FbuttonNL.FSBottom);
             obshover    : DR := Rect(FbuttonUL.FSLeft, FbuttonUL.FSTop, FbuttonUL.FSRight, FbuttonUL.FSBottom);
             obspressed  : DR := Rect(FbuttonBL.FSLeft, FbuttonBL.FSTop, FbuttonBL.FSRight, FbuttonBL.FSBottom);
          end;
        end else
        begin
         DR := Rect(FbuttonDL.FSLeft, FbuttonDL.FSTop, FbuttonDL.FSRight, FbuttonDL.FSBottom);
        end;
         DrawPartnormal(DR,self,flbuttonrect,false);  {left} {top}

        if Enabled=true then   // RIGHT OR BOTTOM BUTTON
        begin
          case frbutons of
             obsnormal   : DR := Rect(FbuttonNR.FSLeft, FbuttonNR.FSTop, FbuttonNR.FSRight, FbuttonNR.FSBottom);
             obshover    : DR := Rect(FbuttonUR.FSLeft, FbuttonUR.FSTop, FbuttonUR.FSRight, FbuttonUR.FSBottom);
             obspressed  : DR := Rect(FbuttonBR.FSLeft, FbuttonBR.FSTop, FbuttonBR.FSRight, FbuttonBR.FSBottom);
          end;
        end else
        begin
         DR := Rect(FbuttonDR.FSLeft, FbuttonDR.FSTop, FbuttonDR.FSRight, FbuttonDR.FSBottom);
        end;
        DrawPartnormal(DR,self,frbuttonrect,false);  {right}  {bottom}


        if Enabled=true then   // CENTER BUTTON
        begin
          case fcbutons of
             obsnormal   : DR := Rect(FbuttonCN.FSLeft, FbuttonCN.FSTop, FbuttonCN.FSRight, FbuttonCN.FSBottom);
             obshover    : DR := Rect(FbuttonCU.FSLeft, FbuttonCU.FSTop, FbuttonCU.FSRight, FbuttonCU.FSBottom);
             obspressed  : DR := Rect(FbuttonCB.FSLeft, FbuttonCB.FSTop, FbuttonCB.FSRight, FbuttonCB.FSBottom);
          end;
        end else
        begin
         DR := Rect(FbuttonCD.FSLeft, FbuttonCD.FSTop, FbuttonCD.FSRight, FbuttonCD.FSBottom);
        end;
        DrawPartnormal(DR,self,fcenterbuttonarea,false);  {center}

  end;
 inherited Paint;

end;


 
procedure tonscrollbar.centerbuttonareaset;
var
  buttonh, borderwh: integer;
begin
  borderwh:=2;
 // borderwh := Background.Border * 2; // border top, border bottom
  if self.Kind = oHorizontal then
  begin
    buttonh :=self.Height - (borderwh);  // button Width and Height;
    flbuttonrect :=Rect(borderwh, borderwh, buttonh, buttonh);// left button    ;
    Frbuttonrect := Rect(self.Width - (buttonh + borderwh), borderwh,     self.Width - borderwh, buttonh); // right button
    Ftrackarea := Rect(flbuttonrect.Right, flbuttonrect.top,frbuttonrect.Left, frbuttonrect.Bottom);


    if fPosition <= 0 then
      fcenterbuttonarea := Rect(Flbuttonrect.Right, borderwh, Flbuttonrect.Right + buttonh + borderwh, self.Height - (borderwh))
   else if fPosition >= (Ftrackarea.Width) then //or position 100
      fcenterbuttonarea := Rect(Ftrackarea.Width - (buttonh + borderwh), borderwh, Ftrackarea.Width - borderwh, self.Height - borderwh)
    else
      fcenterbuttonarea := Rect(FPosition + buttonh, borderwh, FPosition + buttonh + buttonh, self.Height - borderwh);

  end
  else
  begin
    buttonh := self.Width - (borderwh);  // button Width and Height;
    Flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// top button
    Frbuttonrect := Rect(borderwh, self.Height - (buttonh + borderwh), self.Width - borderwh, self.Height - borderwh); // bottom button
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





procedure tpopupformcombobox.listboxdblclick(sender: tobject);
begin
  if ToNListBox(sender).items.Count>0 then
  ReturnstringAnditemindex;
end;

procedure tpopupformcombobox.formdeactivate(sender: tobject);
begin
   Hide;
  if (not FClosed) then
   Close;
end;

constructor tpopupformcombobox.create(theowner: tcomponent);
begin
 // RequireDerivedFormResource:=false;
  inherited CreateNew(theowner);
 // Name:='comboboxform8899';
  Width:=100;
  Height:=200;
  BorderStyle:=bsNone;
  FClosed := false;
  Application.AddOnDeactivateHandler(@FormDeactivate);
  oblist :=ToNListBox.Create(self);
  oblist.Parent:=self;
  oblist.Align:=alClient;
//  oblist.Skindata:=FCaller.Skindata;
//  oblist.items.Assign(FCaller.Fliste);//:=FCaller.items;// .Assign(FCaller.Items);
  oblist.OnClick:=@listboxDblClick;
end;

procedure tpopupformcombobox.cmdeactivate(var message: tlmessage);
begin
  FormDeactivate(self);
end;

procedure tpopupformcombobox.doclose(var closeaction: tcloseaction);
begin
   FClosed := true;
  Application.RemoveOnDeactivateHandler(@FormDeactivate);
  CloseAction:=caFree;
  inherited DoClose(CloseAction);
end;

procedure tpopupformcombobox.doshow;
begin
  inherited doshow;
      oblist.items:=FCaller.items;
end;

procedure tpopupformcombobox.keepinview(const popuporigin: tpoint);
var
  ABounds: TRect;
  P: TPoint;
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

end;

procedure tpopupformcombobox.returnstringanditemindex;
begin
 if oblist.itemindex = -1 then exit;
    if Assigned(FOnReturnDate) then
    FOnReturnDate(Self, oblist.items[oblist.itemindex],oblist.itemindex);
  if not FClosed then
    Close;

end;

procedure tpopupformcombobox.paint;
begin
  inherited paint;
  oblist.Skindata:=FCaller.Skindata;
end;

{ TONcombobox }




function toncombobox.gettext: string;
begin
  if Fitemindex>-1 then
 Result := Fliste[Fitemindex]
 else
 Result:='';
end;

function toncombobox.getitemindex: integer;
begin
   Result := Fitemindex;
end;

procedure toncombobox.lineschanged(sender: tobject);
begin

end;



procedure toncombobox.setitemheight(avalue: integer);
begin

end;

procedure toncombobox.setitemindex(avalue: integer);
var
 Shown: integer;
begin
  if Fliste.Count = 0 then exit;
  if Fitemindex = aValue then Exit;
  if Fitemindex = -1 then Exit;

  Shown := Height div FItemHeight;

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





procedure toncombobox.mousedown(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
 { if button = mbLeft then
  begin
    if not (PtInRect(ClientRect,point(x, y))) then
     begin
 //      kclick(self);
 //     Invalidate;
     end;
  end; }
  inherited MouseDown(Button, Shift, X, Y);
//  fvalue:=strtoint(text);
  if Button=mbLeft then
  begin
    if (PtInRect(fbutonarea,point(x, y))) then
     begin
       Fstate := obspressed;
          kclick(self);
     end else
     begin
         Fstate := obsnormal;
      end;
     end;
//   Text:=inttostr(fvalue);
   Invalidate;
  end;

procedure toncombobox.mousemove(shift: tshiftstate; x, y: integer);
begin
  inherited mousemove(shift, x, y);
 if csDesigning in ComponentState then   Exit;
  if (PtInRect(fbutonarea, point(X, Y))) then
  begin
     Cursor:=crDefault;
     Fstate := obshover;
  end  else
  begin
      Cursor:=crIBeam;
      Fstate := obsnormal;
  end;

 Invalidate;
end;

procedure toncombobox.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  inherited mouseup(button, shift, x, y);
    if Button=mbLeft then
  begin
    Fstate := obsnormal;
    Invalidate;
  end;
end;

procedure toncombobox.cmonmouseenter(var messages: tmessage);
var
 aPnt:TPoint;
begin
 if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseEnter;
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(fbutonarea, aPnt) then
  begin
   Cursor:=crDefault;
  Fstate := obshover;
  end else
  begin
  Cursor:=criBeam;
    Fstate := obsnormal;

  end;
  Invalidate;
end;

procedure toncombobox.cmonmouseleave(var messages: tmessage);
begin
  if csDesigning in ComponentState then
      Exit;
    if not Enabled then
      Exit;
    inherited MouseLeave;
    Fstate := obsnormal;
    Invalidate;
end;







procedure TONcombobox.lstpopupreturndata(sender: tobject; const str: string;
  const indx: integer);
begin
  try
   self.Text:=str;
   Fitemindex:=indx;
   Invalidate;
  except
    on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TONcombobox.lstpopupshowhide(sender: tobject);
begin
  fdropdown := (Sender as Tpopupformcombobox).Visible;
//  if fdropdown=true then
//   Fbutton.Caption :='▲'      //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
//  else
//   Fbutton.Caption :='▼';     //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
   Invalidate;
end;

procedure toncombobox.beginupdate;
begin
 Fliste.BeginUpdate;
end;

procedure toncombobox.clear;
begin
  Fliste.Clear;
end;

procedure toncombobox.endupdate;
begin
 Fliste.EndUpdate;
end;

procedure toncombobox.kclick(sender: tobject);
var
 aa:Tpoint;
begin
if Fliste.Count= 0 then  exit;
aa := ControlToScreen(Point(0, Height));
ShowCombolistPopup(aa, @LstPopupReturndata, @LstPopupShowHide, self);
 //Invalidate;
end;


procedure TONcombobox.Select;
begin
  if Assigned(FOnSelect) and (ItemIndex >= 0) then
    FOnSelect(Self);
end;

procedure TONcombobox.DropDown;
begin
  if Assigned(FOnDropDown) then FOnDropDown(Self);
end;

procedure TONcombobox.getitems;
begin
  if Assigned(FOnGetItems) then FOnGetItems(Self);
end;

procedure TONcombobox.CloseUp;
begin
  if [csLoading,csDestroying,csDesigning]*ComponentState<>[] then exit;
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TONcombobox.SetStrings(avalue: tstrings);
begin
   if Fliste=AValue then Exit;
  Fliste.Assign(AValue);
end;



constructor TONcombobox.Create(Aowner: tcomponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  Width := 150;
  Height := 30;
  Fselectedcolor :=clblue;
  Fitemindex := -1;
  Fliste := TStringList.Create;
  TStringList(Fliste).OnChange := @LinesChanged;
  fskinname      := 'combobox';


  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  FNormal:= TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress:= TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESS';
  FEnter:= TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable:= TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate            := obsnormal;
  fbutonarea:=Rect(Self.Width-self.Height,0,self.Width,self.Height);

end;

destructor TONcombobox.destroy;
begin
  if Assigned(Fliste) then FreeAndNil(Fliste);
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);

  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FTopRight);
  inherited destroy;

end;

procedure TONcombobox.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);

   Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    fbutonarea:=Rect(Self.Width-self.Height,0,self.Width,self.Height);


      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - ((FTopRight.FSRight - FTopRight.FSLeft)+fbutonarea.Width),
        0, Width-(fbutonarea.Width), (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.Width -
        ((FTopRight.FSRight - FTopRight.FSLeft)+fbutonarea.Width), (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop, FBottomleft.FSRight,
        FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - ((FBottomRight.FSRight - FBottomRight.FSLeft)+fbutonarea.Width),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width-(fbutonarea.Width), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        ((FBottomRight.FSRight - FBottomRight.FSLeft)+fbutonarea.Width), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //LEFT // SOL
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      // RIGHT // SAĞ
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - ((FRight.FSRight - FRight.FSLeft) ), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);


     if Enabled=false then
     begin
      TrgtRect  := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
     end else
     begin
        case Fstate of
          obsnormal  : TrgtRect := Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
          obshover   : TrgtRect := Rect(FEnter.FSLeft, FEnter.FSTop, FEnter.FSRight, FEnter.FSBottom);
          obspressed : TrgtRect := Rect(FPress.FSLeft, FPress.FSTop, FPress.FSRight, FPress.FSBottom);
        end;

       DrawPartnormal(TrgtRect, self, fbutonarea, False);

     end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited paint;
end;







{ TOnSpinEdit }


function TOnSpinEdit.getbuttonheight: integer;
begin
 Result:=Fbuttonheight;
end;

function TOnSpinEdit.getbuttonwidth: integer;
begin
  Result:=Fbuttonwidth;
end;

function TOnSpinEdit.Getmax: integer;
begin
  result:=Fmax;
end;

function TOnSpinEdit.Getmin: integer;
begin
 result:=Fmin;
end;




procedure TOnSpinEdit.setbuttonheight(avalue: integer);
begin
  if Fbuttonheight<>AValue then Fbuttonheight:=AValue;
end;

procedure TOnSpinEdit.setbuttonwidth(avalue: integer);
begin
  if Fbuttonwidth<>AValue then Fbuttonwidth:=AValue;
end;

procedure TOnSpinEdit.Setmax(AValue: integer);
begin
 if Fmax<>AValue then Fmax:=AValue;
end;

procedure TOnSpinEdit.Setmin(AValue: integer);
begin
  if Fmin<>AValue then Fmin:=AValue;
end;

procedure TOnSpinEdit.Settext(Avalue: String);
begin
 inherited SetText(Avalue);
  fvalue:=StrToIntDef(Avalue,0);//ValueRange(fvalue,fmin,fmax);
//  Text:=avalue;
end;

procedure TOnSpinEdit.KeyDown(Sender: TObject; var Key: word; Shift: TShiftState
  );
begin
  inherited KeyDown(Key, Shift);
  fvalue:=StrToInt(Text);
 if Key=VK_UP then
 Inc(fvalue)
 else
 if Key=VK_DOWN then
 dec(fvalue);
  if (key=VK_UP) or (key=VK_DOWN) then
  text:=inttostr(fvalue);
end;


procedure TOnSpinEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  fvalue:=StrToIntDef(text,0);
  if Button=mbLeft then
  begin
    if (PtInRect(Fubuttonarea,point(x, y))) then
     begin
       inc(fvalue);
       Fustate := obspressed;
       Fdstate := obsnormal;
     end else
     begin
      if (PtInRect(Fdbuttonarea,point(x, y))) then
      begin
        dec(fvalue);
        Fustate := obsnormal;
        Fdstate := obspressed;
      end  else
      begin
         Fustate := obsnormal;
         Fdstate := obsnormal;
      end;
     end;
   //Fedit.
   Text:=inttostr(fvalue);
   Invalidate;//
  end;
end;
procedure TOnSpinEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button=mbLeft then
  begin
    Fustate := obsnormal;
    Fdstate := obsnormal;
    Invalidate;
  end;
end;

procedure TOnSpinEdit.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then   Exit;
  if (PtInRect(Fubuttonarea, point(X, Y))) then
  begin
     Cursor:=crDefault;
     Fustate := obshover;
     Fdstate := obsnormal;
  end
  else
  begin
    if (PtInRect(Fdbuttonarea, point(X, Y))) then
    begin
       Cursor:=crDefault;
       Fustate := obsnormal;
       Fdstate := obshover;
    end else
    begin
      Cursor:=crIBeam;
      Fustate := obsnormal;
      Fdstate := obsnormal;
    end;
  end;
 Invalidate;
end;

procedure TOnSpinEdit.CMonmouseenter(var Messages: Tmessage);
var
 aPnt:TPoint;
begin
 if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseEnter;
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(Fubuttonarea, aPnt) then
  begin
   Cursor:=crDefault;
  Fustate := obshover;
  Fdstate := obsnormal;
  end else
  begin
   if PtInRect(Fdbuttonarea, aPnt) then
  begin
  Cursor:=crDefault;
  Fustate := obsnormal;
  Fdstate := obshover;
  end else
  begin
  Cursor:=criBeam;
    Fustate := obsnormal;
    Fdstate := obsnormal;
  end;

  end;
  Invalidate;
end;

procedure TOnSpinEdit.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;
  Fustate := obsnormal;
  Fdstate := obsnormal;
  Invalidate;
end;

constructor TOnSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fskinname     := 'spinedit';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Self.Height := 25;
  Self.Width := 100;
  Fresim.SetSize(Width, Height);
  Captionvisible:=False;
  Text          := '';
  Text          := '0';
  Caption       := '0';
  NumberOnly    := true;

  Fbuttonwidth  := 11;
  Fbuttonheight := 11;

  fmin          := 0;
  fmax          := 0;
  fvalue        := 0;



  // up button
  FuNormal  := TONCUSTOMCROP.Create;
  FuNormal.cropname := 'UPBUTONNORMAL';
  FuPress   := TONCUSTOMCROP.Create;
  FuPress.cropname := 'UPBUTONPRESS';
  FuEnter   := TONCUSTOMCROP.Create;
  FuEnter.cropname := 'UPBUTONHOVER';
  Fudisable := TONCUSTOMCROP.Create;
  Fudisable.cropname := 'UPBUTONDISABLE';
  Fustate   := obsNormal;

  // Down button
  FdNormal  := TONCUSTOMCROP.Create;
  FdNormal.cropname := 'DOWNBUTONNORMAL';
  FdPress   := TONCUSTOMCROP.Create;
  FdPress.cropname := 'DOWNBUTONPRESS';
  FdEnter   := TONCUSTOMCROP.Create;
  FdEnter.cropname := 'DOWNBUTONHOVER';
  Fddisable := TONCUSTOMCROP.Create;
  Fddisable.cropname := 'DOWNBUTONDISABLE';
  Fdstate   := obsNormal;

  Fubuttonarea:=Rect(Self.Width-self.Height div 2,0,self.Width,self.Height div 2);
  Fdbuttonarea:=Rect(Self.Width-self.Height div 2,self.Height div 2,self.Width,self.Height);

end;

destructor TOnSpinEdit.Destroy;
begin
//  if Assigned(Fedit) then FreeAndNil(Fedit);
  FreeAndNil(FuNormal);
  FreeAndNil(FuPress);
  FreeAndNil(FuEnter);
  FreeAndNil(Fudisable);

  FreeAndNil(FdNormal);
  FreeAndNil(FdPress);
  FreeAndNil(FdEnter);
  FreeAndNil(Fddisable);

  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FTopRight);
  inherited destroy;
end;

procedure TOnSpinEdit.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);

   Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    Fubuttonarea:=Rect(Self.Width-self.Height div 2,0,self.Width,self.Height div 2);
    Fdbuttonarea:=Rect(Self.Width-self.Height div 2,self.Height div 2,self.Width,self.Height);


      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - ((FTopRight.FSRight - FTopRight.FSLeft)+Fubuttonarea.Width),
        0, Width-(Fubuttonarea.Width), (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.Width -
        ((FTopRight.FSRight - FTopRight.FSLeft)+Fubuttonarea.Width), (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop, FBottomleft.FSRight,
        FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - ((FBottomRight.FSRight - FBottomRight.FSLeft)+Fubuttonarea.Width),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width-(Fubuttonarea.Width), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        ((FBottomRight.FSRight - FBottomRight.FSLeft)+Fubuttonarea.Width), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //LEFT // SOL
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      // RIGHT // SAĞ
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - ((FRight.FSRight - FRight.FSLeft) ), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);


     if Enabled=false then
     begin
      SrcRect   := Rect(Fudisable.FSLeft, Fudisable.FSTop, Fudisable.FSRight, Fudisable.FSBottom);
      TrgtRect  := Rect(Fddisable.FSLeft, Fddisable.FSTop, Fddisable.FSRight, Fddisable.FSBottom);
     end else
     begin
        case Fustate of
          obsnormal  : SrcRect := Rect(FuNormal.FSLeft, FuNormal.FSTop, FuNormal.FSRight, FuNormal.FSBottom);
          obshover   : SrcRect := Rect(FuEnter.FSLeft, FuEnter.FSTop, FuEnter.FSRight, FuEnter.FSBottom);
          obspressed : SrcRect := Rect(FuPress.FSLeft, FuPress.FSTop, FuPress.FSRight, FuPress.FSBottom);
        end;
        case Fdstate of
          obsnormal  : TrgtRect := Rect(FdNormal.FSLeft, FdNormal.FSTop, FdNormal.FSRight, FdNormal.FSBottom);
          obshover   : TrgtRect := Rect(FdEnter.FSLeft, FdEnter.FSTop, FdEnter.FSRight, FdEnter.FSBottom);
          obspressed : TrgtRect := Rect(FdPress.FSLeft, FdPress.FSTop, FdPress.FSRight, FdPress.FSBottom);
        end;
       DrawPartnormal(SrcRect, self, Fubuttonarea, False);
       DrawPartnormal(TrgtRect, self, Fdbuttonarea, False);

     end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;

  inherited paint;
end;

{ TONMemo }

constructor TONMemo.Create(AOwner: TComponent);
begin
  inherited create(aowner);
  MultiLine:=true;
  Width:= 150;
  Height:=150;
  fskinname      := 'memo';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Fresim.SetSize(Width, Height);
  Captionvisible:=False;
end;

destructor TONMemo.Destroy;
begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft);
  inherited Destroy;
end;



procedure TONMemo.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);
   Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft),
        0, Width, (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.Width -
        (FTopRight.FSRight - FTopRight.FSLeft), (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop, FBottomleft.FSRight,
        FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //CENTERLEFT // SOLORTA
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTERRIGHT // SAĞORTA
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - (FRight.FSRight - FRight.FSLeft), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited paint;
end;



{ TonPersistent }

constructor tonpersistent.Create(aowner: TPersistent);
begin
  inherited Create;
  owner := Aowner;
end;


{ Toncaret }


function Toncaret.Getblinktime: integer;
begin
  Result := fblinktime;
end;

procedure toncaret.setblinktime(const Value: integer);
begin
  if (Value <> fblinktime) and (Value > 10) then
  begin
    fblinktime := Value;
    blinktimer.Interval := fBlinktime;
  end;
end;

function toncaret.getvisible: boolean;
begin
  Result := fvisibled;
end;

procedure toncaret.setvisible(const Value: boolean);
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

procedure toncaret.ontimerblink(Sender: TObject);
begin
  caretvisible := not caretvisible;
  paint;
end;

function toncaret.paint: boolean;
begin
  if parent is Toncustomedit then
    Toncustomedit(parent).Invalidate;
  Result := True;
end;

constructor toncaret.Create(aowner: TPersistent);
begin
  inherited Create;
  parent := Toncustomedit(aowner);
  FHeight := 20;
  FWidth := 2;
  fblinkcolor := clBlack;
  fblinktime := 600;
  blinktimer := TTimer.Create(nil);
  blinktimer.Interval := blinktime;
  blinktimer.OnTimer := @ontimerblink;
  blinktimer.Enabled := False;
  CaretPos.X := 0;
  CaretPos.Y := 0;
  caretvisible := False;
end;

destructor toncaret.Destroy;
begin
  FreeAndNil(blinktimer);
  inherited Destroy;
end;




// -----------------------------------------------------------------------------




{ Toncustomedit }

function VisibleText(const aVisibleText: TCaption; const APasswordChar: char): TCaption;
begin
  if aPasswordChar = #0 then
    Result := aVisibleText
  else
    Result := StringOfChar(aPasswordChar, UTF8Length(aVisibleText));

end;

constructor toncustomedit.Create(aowner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := True;
  Cursor := crIBeam;
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks,
    csRequiresKeyboardInput];

  FLines := TStringList.Create;
  FVisibleTextStart := Point(1, 0);
 // fskinname      := 'edit';
  FPasswordChar := #0;
  FCarets := Toncaret.Create(self);
  Self.Height := 30;
  Self.Width := 80;
  Fresim.SetSize(Width, Height);
  Captionvisible:=False;

end;

destructor toncustomedit.Destroy;
begin
  FreeAndNil(FLines);
  FreeAndNil(FCarets);
  inherited Destroy;
end;


procedure toncustomedit.paint;
var
  //  gradienrect1, gradienrect2, Selrect,
  caretrect: Trect;
  //  textx, Texty, i, a: integer;
  lControlText, lTmpText: string;
  lCaretPixelPos: integer;
  lTextBottomSpacing, lTextTopSpacing, lCaptionHeight, lLineHeight, lLineTop: integer;
  lSize: TSize;
begin

  if self is TOnSpinEdit then
  begin
  lTextTopSpacing :=TOnSpinEdit(self).ONTOP.fsBottom - TOnSpinEdit(self).ONTOP.fsTop; //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lTextBottomSpacing := TOnSpinEdit(self).ONBOTTOM.fsBottom - TOnSpinEdit(self).ONBOTTOM.fsTop; // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);

  end else
  if self is TonEdit then
  begin
  lTextTopSpacing :=TonEdit(self).ONTOP.fsBottom - TonEdit(self).ONTOP.fsTop; //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lTextBottomSpacing := TonEdit(self).ONBOTTOM.fsBottom - TonEdit(self).ONBOTTOM.fsTop; // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
  end else
  if self is TONMemo then
  begin
  lTextTopSpacing :=TONMemo(self).ONTOP.fsBottom - TONMemo(self).ONTOP.fsTop; //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lTextBottomSpacing := TONMemo(self).ONBOTTOM.fsBottom - TONMemo(self).ONBOTTOM.fsTop; // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
  end else
  if self is TONcombobox then
  begin
  lTextTopSpacing :=TONcombobox(self).ONTOP.fsBottom - TONcombobox(self).ONTOP.fsTop; //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
  lTextBottomSpacing := TONcombobox(self).ONBOTTOM.fsBottom - TONcombobox(self).ONBOTTOM.fsTop; // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
  end;

  lLineHeight := self.canvas.TextHeight('ŹÇ');
  lSize := Size(self.Width, self.Height);
  lLineHeight := Min(lSize.cy - lTextBottomSpacing, lLineHeight);
  lLineTop := lTextTopSpacing + Fcarets.CaretPos.Y * lLineHeight;




  if Lines.Count = 0 then lControlText := ''
  else
    lControlText := Lines.Strings[Fcarets.CaretPos.Y];

  lTmpText := UTF8Copy(lControlText, fVisibleTextStart.X, Fcarets.CaretPos.X -
    fVisibleTextStart.X + 1);
  lTmpText := VisibleText(lTmpText, fPasswordChar);

  if text='' then
  begin
     if self is TOnSpinEdit then
      lCaretPixelPos :=(TOnSpinEdit(self).ONLEFT.fsRight - TOnSpinEdit(self).ONLEFT.fsLeft)+ fLeftTextMargin
     else
     if self is TonEdit then
       lCaretPixelPos :=(TonEdit(self).ONLEFT.fsRight - TonEdit(self).ONLEFT.fsLeft)+ fLeftTextMargin
     else
     if self is TONMemo then
       lCaretPixelPos :=(TONMemo(self).ONLEFT.fsRight - TONMemo(self).ONLEFT.fsLeft)+ fLeftTextMargin
     else
     if self is TONcombobox then
      lCaretPixelPos :=(TONcombobox(self).ONLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft)+ fLeftTextMargin;


//  lCaretPixelPos := (Fleft.FSright - Fleft.FSLeft) + fLeftTextMargin;
   lCaptionHeight := lLineHeight;// self.canvas.TextHeight('ŹÇ');
  end
  else
  begin
    lCaptionHeight := self.canvas.TextHeight(self.Text);

     if self is TOnSpinEdit then
       lCaretPixelPos :=(TOnSpinEdit(self).ONLEFT.fsRight - TOnSpinEdit(self).ONLEFT.fsLeft)+ self.canvas.TextWidth(lTmpText)+fLeftTextMargin
     else
    if self is TonEdit then
       lCaretPixelPos :=(TonEdit(self).ONLEFT.fsRight - TonEdit(self).ONLEFT.fsLeft)+ self.canvas.TextWidth(lTmpText)+fLeftTextMargin
     else
     if self is TONMemo then
       lCaretPixelPos :=(TONMemo(self).ONLEFT.fsRight - TONMemo(self).ONLEFT.fsLeft)+ self.canvas.TextWidth(lTmpText)+fLeftTextMargin
     else
     if self is TONcombobox then
      lCaretPixelPos :=(TONcombobox(self).ONLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft)+ self.canvas.TextWidth(lTmpText)+fLeftTextMargin;

  // lCaretPixelPos := self.canvas.TextWidth(lTmpText) + (Fleft.FSright - Fleft.FSLeft) + fLeftTextMargin;
  end;


  inherited Paint;
  DrawText;
  caretrect := Rect(lCaretPixelPos, lLineTop, lCaretPixelPos +
    FCarets.Width, lLineTop + lCaptionHeight);

  if Fcarets.Caretvisible then
  begin
    canvas.Brush.Color := FCarets.Color;
    canvas.FillRect(caretrect);
  end;

end;



procedure toncustomedit.drawtext;
//  ASize: TSize; AState: TCDControlState; AStateEx: TCDEditStateEx);
var
  lVisibleText, lControlText: TCaption;
  lSelLeftPos, lSelLeftPixelPos, lSelLength, lSelRightPos: integer;
  lTextWidth, lLineHeight, lLineTop: integer;
  lControlTextLen: PtrInt;
  lTextLeftSpacing, lTextTopSpacing, lTextRightSpacing, lTextBottomSpacing: integer;
  lTextColor: TColor;
  i, lVisibleLinesCount: integer;

  ASize: TSize;
begin

  lTextColor := self.Font.Color;
  ASize := Size(self.Width, Self.Height);

//  lTextLeftSpacing := Fleft.FSright - Fleft.FSLeft;  //3;     //GetMeasures(TCDEDIT_LEFT_TEXT_SPACING);
//  lTextRightSpacing := FRight.FSright - FRight.FSLeft; //GetMeasures(TCDEDIT_RIGHT_TEXT_SPACING);
//  lTextTopSpacing := FTop.FSBottom - FTop.FSTop;  //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
//  lTextBottomSpacing := FBottom.FSBottom - FBottom.FSTop;   // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);

   if self is TOnSpinEdit then
   begin
     lTextLeftSpacing   :=TOnSpinEdit(self).ONLEFT.fsRight - TOnSpinEdit(self).ONLEFT.fsLeft;
     lTextRightSpacing  :=TOnSpinEdit(self).ONRIGHT.fsRight - TOnSpinEdit(self).ONRIGHT.fsLeft;
     lTextTopSpacing    :=TOnSpinEdit(self).ONTOP.fsBottom - TOnSpinEdit(self).ONTOP.fsTop;
     lTextBottomSpacing :=TOnSpinEdit(self).ONBOTTOM.fsBottom - TOnSpinEdit(self).ONBOTTOM.fsTop;
   end
   else
   if self is TonEdit  then
   begin
     lTextLeftSpacing   :=TonEdit(self).ONLEFT.fsRight - TonEdit(self).ONLEFT.fsLeft;
     lTextRightSpacing  :=TonEdit(self).ONRIGHT.fsRight - TonEdit(self).ONRIGHT.fsLeft;
     lTextTopSpacing    :=TonEdit(self).ONTOP.fsBottom - TonEdit(self).ONTOP.fsTop;
     lTextBottomSpacing :=TonEdit(self).ONBOTTOM.fsBottom - TonEdit(self).ONBOTTOM.fsTop;

   end
   else
   if self is TONMemo  then
   begin
     lTextLeftSpacing   :=TONMemo(self).ONLEFT.fsRight - TONMemo(self).ONLEFT.fsLeft;
     lTextRightSpacing  :=TONMemo(self).ONRIGHT.fsRight - TONMemo(self).ONRIGHT.fsLeft;
     lTextTopSpacing    :=TONMemo(self).ONTOP.fsBottom - TONMemo(self).ONTOP.fsTop;
     lTextBottomSpacing :=TONMemo(self).ONBOTTOM.fsBottom - TONMemo(self).ONBOTTOM.fsTop;
   end
   else
   if self is TONcombobox then
   begin
     lTextLeftSpacing   :=TONcombobox(self).ONLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft;
     lTextRightSpacing  :=TONcombobox(self).ONRIGHT.fsRight - TONcombobox(self).ONRIGHT.fsLeft;
     lTextTopSpacing    :=TONcombobox(self).ONTOP.fsBottom - TONcombobox(self).ONTOP.fsTop;
     lTextBottomSpacing :=TONcombobox(self).ONBOTTOM.fsBottom - TONcombobox(self).ONBOTTOM.fsTop;
   end;




  lLineHeight := self.Canvas.TextHeight('ŹÇ');
  lLineHeight := Min(ASize.cy - lTextBottomSpacing, lLineHeight);

  // Fill this to be used in other parts
  fLineHeight := lLineHeight;
  fFullyVisibleLinesCount := ASize.cy - lTextTopSpacing - lTextBottomSpacing;
  fFullyVisibleLinesCount := fFullyVisibleLinesCount div lLineHeight;
  fFullyVisibleLinesCount := Min(fFullyVisibleLinesCount, Lines.Count);


 // WriteLn(fFullyVisibleLinesCount,'     ', lTextTopSpacing,'   ',lTextBottomSpacing);


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
      lVisibleText := UTF8Copy(lControlText, lSelLeftPos + lSelLength +
        1, lControlTextLen);
      self.Canvas.TextOut(lSelLeftPixelPos, lLineTop, lVisibleText);

    end;

  end;

  // And the caret
  // DrawCaret(ADest, Point(0, 0), ASize, AState, AStateEx);

  // In the end the frame, because it must be on top of everything
  //  DrawEditFrame(ADest, Point(0, 0), ASize, AState, AStateEx);
end;


function toncustomedit.getcharcase: tocharcase;
begin
  Result := FCharCase;
end;

function toncustomedit.getechomode: toechomode;
begin
  Result := fEchoMode;
end;

procedure toncustomedit.setechomode(const Value: toechomode);
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

procedure toncustomedit.setcharcase(const Value: tocharcase);
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    Invalidate;
  end;
end;

procedure toncustomedit.setlefttextmargin(avalue: integer);
begin
  if FLeftTextMargin = AValue then Exit;
  FLeftTextMargin := AValue;
  Invalidate;
end;

procedure toncustomedit.setlines(avalue: TStrings);
begin
  if FLines = AValue then Exit;
  FLines.Assign(AValue);
  DoChange();
  Invalidate;
end;

procedure toncustomedit.setmultiline(avalue: boolean);
begin
  if FMultiLine = AValue then Exit;
  FMultiLine := AValue;
  Invalidate;
end;

procedure toncustomedit.setnumberonly(const Value: boolean);
begin
  if FNumbersOnly <> Value then FNumbersOnly := Value;
end;

procedure toncustomedit.setreadonly(avalue: boolean);
begin
  if FReadOnly <> avalue then FReadOnly := avalue;
end;

procedure toncustomedit.setrighttextmargin(avalue: integer);
begin
  if FRightTextMargin = AValue then Exit;
  FRightTextMargin := AValue;
  Invalidate;
end;

procedure toncustomedit.settext(avalue: string);
begin
  Lines.Text := aValue;
end;

procedure toncustomedit.setpasswordchar(avalue: char);
begin
  if AValue = FPasswordChar then Exit;
  FPasswordChar := AValue;
  Invalidate;
end;


procedure toncustomedit.realsettext(const Value: tcaption);
begin
  inherited RealSetText(Value);
  Lines.Text := Value;
  Invalidate;
end;

procedure toncustomedit.dochange;
begin
  Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;



function toncustomedit.getlefttextmargin: integer;
begin
  Result := FLeftTextMargin;
end;

function toncustomedit.getcaretpos: tpoint;
begin
  Result := FCarets.CaretPos;//FEditState.CaretPos;
end;

function toncustomedit.getmultiline: boolean;
begin
  Result := FMultiLine;
end;

function toncustomedit.getreadonly: boolean;
begin
  Result := FReadOnly;
end;

function toncustomedit.getnumberonly: boolean;
begin
  Result := FNumbersOnly;
end;

function toncustomedit.getrighttextmargin: integer;
begin
  Result := FRightTextMargin;
end;

function toncustomedit.gettext: string;
begin
  if Multiline then
    Result := Lines.Text
  else if Lines.Count = 0 then
    Result := ''
  else
    Result := Lines[0];
end;

function toncustomedit.getpasswordchar: char;
begin
  Result := FPasswordChar;
end;

procedure toncustomedit.dodeleteselection;
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
    lTextRight := UTF8Copy(lControlText, lSelLeftPos + lSelLength +
      1, Length(lControlText));

    // Execute the deletion
    SetCurrentLine(lTextLeft + lTextRight);

    // Correct the caret position
    // FEditState.CaretPos.X
    FCarets.CaretPos.X := Length(lTextLeft);
  end;

  DoClearSelection;
end;

procedure toncustomedit.doclearselection;
begin
  FSelStart.X := 1;
  FSelStart.Y := 0;
  FSelLength := 0;
end;

// Imposes sanity limits to the visible text start
// and also imposes sanity limits on the caret
procedure toncustomedit.domanagevisibletextstart;
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
 // lAvailableWidth := Width - (Fleft.FSright-Fleft.FSLeft)- (FRight.FSright-FRight.FSLeft);
   if self is TOnSpinEdit then
     lAvailableWidth :=Width-((TOnSpinEdit(self).ONLEFT.fsRight - TOnSpinEdit(self).ONLEFT.fsLeft)+(TOnSpinEdit(self).ONRIGHT.fsRight - TOnSpinEdit(self).ONRIGHT.fsLeft))
   else
   if self is TonEdit then
     lAvailableWidth :=Width-((TonEdit(self).ONLEFT.fsRight - TonEdit(self).ONLEFT.fsLeft)+(TonEdit(self).ONRIGHT.fsRight - TonEdit(self).ONRIGHT.fsLeft))
   else
   if self is TONMemo then
     lAvailableWidth :=Width-((TONMemo(self).ONLEFT.fsRight - TONMemo(self).ONLEFT.fsLeft)+(TONMemo(self).ONRIGHT.fsRight - TONMemo(self).ONRIGHT.fsLeft))
   else
   if self is TONcombobox then
    lAvailableWidth :=Width-((TONcombobox(self).ONLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft)+(TONcombobox(self).ONRIGHT.fsRight - TONcombobox(self).ONRIGHT.fsLeft));



  lVisibleTextCharCount := Canvas.TextFitInfo(lVisibleText, lAvailableWidth);
  FVisibleTextStart.X := Max(FCarets.CaretPos.X{FCaretPos.X} -
    lVisibleTextCharCount + 1, FVisibleTextStart.X);

  // Moved upwards and we need to adjust the text start
  FVisibleTextStart.Y := Min(FCarets.CaretPos.Y{FCaretPos.Y}, FVisibleTextStart.Y);

  // Moved downwards and we need to adjust the text start
  FVisibleTextStart.Y := Max(FCarets.CaretPos.Y{FCaretPos.Y} -
    FFullyVisibleLinesCount, FVisibleTextStart.Y);

  // Impose limits in the caret too
  //  FCaretPos.X
  FCarets.CaretPos.X := Min(FCarets.CaretPos.X{FCaretPos.X}, UTF8Length(lLineText));
  //  FCaretPos.Y
  FCarets.CaretPos.Y := Min(FCarets.CaretPos.Y{FCaretPos.Y}, FLines.Count - 1);
  //  FCaretPos.Y
  FCarets.CaretPos.Y := Max(FCarets.CaretPos.Y{FCaretPos.Y}, 0);
end;

procedure toncustomedit.setcaretpost(avalue: tpoint);
begin
  // FCaretPos.X
  FCarets.CaretPos.X := AValue.X;
  // FCaretPos.Y
  FCarets.CaretPos.Y := AValue.Y;
  Invalidate;
end;


// Result.X -> returns a zero-based position of the caret
function toncustomedit.mousepostocaretpos(x, y: integer): tpoint;
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
 // lPos := Fleft.FSright-Fleft.FSLeft;//- (FRight.FSright-FRight.FSLeft) 3;//GetMeasures(TCDEDIT_LEFT_TEXT_SPACING);
   if self is TOnSpinEdit then
     lPos :=Width-(TOnSpinEdit(self).ONLEFT.fsRight - TOnSpinEdit(self).ONLEFT.fsLeft)
   else
    if self is TonEdit then
     lPos :=(TonEdit(self).ONLEFT.fsRight - TonEdit(self).ONLEFT.fsLeft)
   else
   if self is TONMemo then
     lPos :=Width-(TONMemo(self).ONLEFT.fsRight - TONMemo(self).ONLEFT.fsLeft)
   else
   if self is TONcombobox then
     lPos :=Width-(TONcombobox(self).ONLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft);



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

function toncustomedit.issomethingselected: boolean;
begin
  Result := FSelLength <> 0;
end;



procedure toncustomedit.doenter;
begin
  //  FCaretTimer.Enabled := True;
  FCarets.Visible := True;
  //FCaretIsVisible := True;
  inherited DoEnter;
end;

procedure toncustomedit.doexit;
begin
  //  FCaretTimer.Enabled := False;
  FCarets.Visible := False;
  // FCaretIsVisible := False;
  DoClearSelection();
  inherited DoExit;
end;

procedure toncustomedit.keydown(var key: word; shift: tshiftstate);
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
      else if FCarets.CaretPos.X < lOldTextLength then
      begin
        lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X);
        lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X + 2, lOldTextLength);
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
      if (FCarets.CaretPos.X > 0) then
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

procedure toncustomedit.keyup(var key: word; shift: tshiftstate);
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

procedure toncustomedit.utf8keypress(var utf8key: tutf8char);
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

  if (FNumbersOnly = True) and not ((UTF8Key[1] in [#30..#$39]) or
    (UTF8Key[1] = #$2e) or (UTF8Key[1] = #$2c)) then exit;
  // (UTF8Key[1] in [#30..#$39, #$2e, #$2c])  then Exit;



  DoDeleteSelection;
  //▲ ▼ ► ◄ ‡ // ALT+30 ALT+31 ALT+16 ALT+17 ALT+0135

  // Normal characters
  lOldText := GetCurrentLine();
  lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X {FCaretPos.X});
  lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X {FCaretPos.X} +
    1, UTF8Length(lOldText));
  SetCurrentLine(lLeftText + UTF8Key + lRightText);
  Inc(FCarets.CaretPos.X{FCaretPos.X});
  DoManageVisibleTextStart();
  FCarets.Visible := True;
  Invalidate;
end;

procedure toncustomedit.mousedown(button: tmousebutton; shift: tshiftstate;
  x, y: integer);
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
  FCarets.caretvisible := True;

  SetFocus;

  Invalidate;
end;

procedure toncustomedit.mousemove(shift: tshiftstate; x, y: integer);
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

procedure toncustomedit.mouseup(button: tmousebutton; shift: tshiftstate;
  x, y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  DragDropStarted := False;
end;

procedure toncustomedit.mouseenter;
begin
  inherited MouseEnter;
end;

procedure toncustomedit.mouseleave;
begin
  inherited MouseLeave;
end;

procedure toncustomedit.wmsetfocus(var message: tlmsetfocus);
begin
  DoEnter;
end;

procedure toncustomedit.wmkillfocus(var message: tlmkillfocus);
begin
  DoExit;
end;


function toncustomedit.getcurrentline: string;
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y{FCaretPos.Y} >= FLines.Count) then
    Result := ''
  else
    Result := FLines.Strings[FCarets.CaretPos.Y{FCaretPos.Y}];
end;

procedure toncustomedit.setcurrentline(astr: string);
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

function toncustomedit.getselstartx: integer;
begin
  Result := FSelStart.X;
end;

function toncustomedit.getsellength: integer;
begin
  Result := FSelLength;
  if Result < 0 then Result := Result * -1;
end;

procedure toncustomedit.setselstartx(anewx: integer);
begin
  FSelStart.X := ANewX;
end;

procedure toncustomedit.setsellength(anewlength: integer);
begin
  FSelLength := ANewLength;
end;

function toncustomedit.caretttopos(leftch: integer): integer;
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


 
{ TonEdit }

constructor TonEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fskinname:='edit';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Self.Height := 30;
  Self.Width := 80;
  Fresim.SetSize(Width, Height);
  Captionvisible:=False;

end;

destructor TonEdit.Destroy;
begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft);
  inherited Destroy;
end;


procedure TonEdit.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  Fresim.SetSize(0,0);

   Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft),
        0, Width, (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.Width -
        (FTopRight.FSRight - FTopRight.FSLeft), (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop, FBottomleft.FSRight,
        FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //CENTERLEFT // SOLORTA
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTERRIGHT // SAĞORTA
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - (FRight.FSRight - FRight.FSLeft), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited paint;
end;


 {

procedure imageempty(img:TBGRABitmap);
begin
  if img<> nil then
  begin
    img.SetSize(0,0);
  end;
end;

function isimageemtpy(img:TBGRABitmap):boolean;
begin
 if img<>nil then
  begin
    if ((img.Width>0) and (img.Height>0)) or((img.Width>0) or(img.Height>0)) then
     Result:=false
    else
     Result:=true;
  end else
  begin
     Result:=true;
  end;
end;
}

// -----------------------------------------------------------------------------
constructor TONImg.Create(AOwner: TComponent);
var
  Strm: TResourceStream;
begin
  inherited Create(AOwner);
  fparent:=Tform(AOwner);
  Fimage := TBGRABitmap.Create();
  FRes := TPicture.Create;
  Fres.OnChange := @ImageSet;
  Fimage.LoadFromResource('panel');
  try
    List := TStringList.Create;
    Strm := TResourceStream.Create(HInstance, 'skins', RT_RCDATA);
    Strm.Position := 0;
    try
      List.LoadFromStream(Strm);
    finally
      Strm.Free;
    end;
    //  if (AOwner.GetParentComponent as TForm). then
    //      ShowMessage(self.GetParentComponent.Name);
    //   Readskins(GetOwningForm(AOwner));//tform(GetParentForm(Tcontrol(self))));//  tform(FindComponent(GetParentComponent.Name).);
  finally
  end;
end;



destructor TONImg.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FRes);
  FreeAndNil(List);
  inherited;
end;

procedure TONImg.ImageSet(Sender: TObject);
begin
  FreeAndNil(FImage);
  Fimage := TBGRABitmap.Create(Fres.Width, Fres.Height);
  Fimage.Assign(Fres.Bitmap);
end;

procedure TONImg.Readskinsfile(filename: string);
begin
 self.List.Clear;
 self.list.LoadFromFile(filename);
 self.Readskins;//(self.fparent);
end;

procedure TONImg.Saveskinsfile(filename: string);
begin
 if self.List.Count>-1 then
 self.list.SaveToFile(filename);
 //Readskins(self.fparent);
end;

procedure TONImg.ReadskinsStream(STrm: TStream);
begin
  self.List.Clear;
  self.List.LoadFromStream(STrm);
  self.Readskins;
end;

procedure TONImg.SaveskinsStream(Strm: TStream);
begin
  if self.List.Count>-1 then
  self.List.SaveToStream(STrm);
end;

 {
procedure tonimg.setpicture(val: tpicture);
//var
// FRes:TPicture;
begin
  if val.Bitmap.Empty then exit;
  FreeAndNil(FImage);
  FRes := TPicture.Create;
  Fres.Assign(val);
//  Fres.OnChange := @ImageSet;
  Fimage := TBGRABitmap.Create(Fres.Width, Fres.Height);
  Fimage.Assign(Fres.Bitmap);
  Freeandnil(Fres);
end;
 }
procedure cropRead(Crp: TONCUSTOMCROP; ini: TIniFile; isim: string);
begin
  Crp.fsLEFT := StrToInt(trim(ini.ReadString(isim, crp.cropname + '.LEFT', '0')));
  Crp.fsTOP := StrToInt(trim(ini.ReadString(isim, crp.cropname + '.TOP', '0')));
  Crp.fsBOTTOM := StrToInt(trim(ini.ReadString(isim, crp.cropname + '.BOTTOM', '0')));
  Crp.fsRIGHT := StrToInt(trim(ini.ReadString(isim, crp.cropname + '.RIGHT', '0')));
  Crp.Fontcolor:=StringToColor(ini.ReadString(isim, crp.cropname +'.FONTCOLOR', 'clBlack'));
end;

procedure TONImg.ReadskinsComp(Com: TComponent);
var
  fil: TIniFile;
  memm: TMemoryStream;
  i: integer;
  isim: string;
  T:TCustomform;
begin
  try
    memm := TMemoryStream.Create;
    try
      memm.Clear;
      List.SaveToStream(memm);
      memm.Position := 0;
      fil := TIniFile.Create(memm);
    finally
      FreeAndNil(memm);
    end;

    if Fimage.Empty = True then
    begin
      Fimage.LoadFromResource('PANEL');
    end;


    with fil do
    begin
   //   t:=GetParentForm(tcontrol(com));

     // if (t is TForm) then
        with (TForm(fparent)) do
        begin

          isim := 'FORM';
          Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(isim, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(isim, 'Fontsize', '9'));
          Font.Style := [fsBold];
          Color:=StringToColor(ReadString(isim, 'color', 'clNone'));  ;
        end;



      if (Com is TONPANEL) then
        with (TONPANEL(Com)) do
        begin
          case TAG of
            0: isim := 'PANEL_FREE';     //Normal panel not border
            1: isim := 'PANEL_MAIN';     // Normal Panel with border
            2: isim := 'PANEL_HEADER';   // Header Panel
          end;
          if Skindata = nil then
            Skindata := Self;

          Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
          Font.Style := [fsBold];

          cropRead(ONTOP, fil, Skinname);
          cropRead(ONBOTTOM, fil, Skinname);
          cropRead(ONLEFT, fil, Skinname);
          cropRead(ONRIGHT, fil, Skinname);
          cropRead(ONTOPLEFT, fil, Skinname);
          cropRead(ONTOPRIGHT, fil, Skinname);
          cropRead(ONCENTER, fil, Skinname);
          cropRead(ONBOTTOMLEFT, fil, Skinname);
          cropRead(ONBOTTOMRIGHT, fil, Skinname);
        end;

      if (Com is TONGraphicPanel) then
        with (TONGraphicPanel(Com)) do
        begin
          case TAG of
            0: isim := 'PANEL_FREE';     //Normal panel not border
            1: isim := 'PANEL_MAIN';     // Normal Panel with border
            2: isim := 'PANEL_HEADER';   // Header Panel
          end;
          if Skindata = nil then
            Skindata := Self;

          Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
          Font.Style := [fsBold];

          cropRead(ONTOP, fil, Skinname);
          cropRead(ONBOTTOM, fil, Skinname);
          cropRead(ONLEFT, fil, Skinname);
          cropRead(ONRIGHT, fil, Skinname);
          cropRead(ONTOPLEFT, fil, Skinname);
          cropRead(ONTOPRIGHT, fil, Skinname);
          cropRead(ONCENTER, fil, Skinname);
          cropRead(ONBOTTOMLEFT, fil, Skinname);
          cropRead(ONBOTTOMRIGHT, fil, Skinname);
        end;

      if (com is TONCropButton) then
        with (TONCropButton(com)) do
        begin
          isim := 'BUTTON';
          if Skindata = nil then
            Skindata := Self;
          Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
          Font.Style := [fsBold];

          cropRead(ONNORMAL, fil, Skinname);
          cropRead(ONHOVER, fil, Skinname);
          cropRead(ONPRESSED, fil, Skinname);
          cropRead(ONDISABLE, fil, Skinname);
        end;


      if (com is TONGraphicsButton) then
        with (TONGraphicsButton(com)) do
        begin
          isim := 'BUTTON';
          if Skindata = nil then
            Skindata := Self;
          Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
          Font.Style := [fsBold];

          cropRead(ONNORMAL, fil, Skinname);
          cropRead(ONHOVER, fil, Skinname);
          cropRead(ONPRESSED, fil, Skinname);
          cropRead(ONDISABLE, fil, Skinname);
        end;

      if (Com is TONEDIT) then
        with (TONEDIT(com)) do
        begin
          isim := 'EDIT';
          if Skindata = nil then
            Skindata := Self;
          Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
          Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
          Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
          Font.Style := [fsBold];

          cropRead(ONTOP, fil, Skinname);
          cropRead(ONBOTTOM, fil, Skinname);
          cropRead(ONLEFT, fil, Skinname);
          cropRead(ONRIGHT, fil, Skinname);
          cropRead(ONTOPLEFT, fil, Skinname);
          cropRead(ONTOPRIGHT, fil, Skinname);
          cropRead(ONCENTER, fil, Skinname);
          cropRead(ONBOTTOMLEFT, fil, Skinname);
          cropRead(ONBOTTOMRIGHT, fil, Skinname);

        end;


       if (Com is TOnSpinEdit) then
          with (TOnSpinEdit(Com)) do
          begin
            isim := 'SPINEDIT';
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];
            cropRead(ONTOP, fil, Skinname);
            cropRead(ONBOTTOM, fil, Skinname);
            cropRead(ONLEFT, fil, Skinname);
            cropRead(ONRIGHT, fil, Skinname);
            cropRead(ONTOPLEFT, fil, Skinname);
            cropRead(ONTOPRIGHT, fil, Skinname);
            cropRead(ONCENTER, fil, Skinname);
            cropRead(ONBOTTOMLEFT, fil, Skinname);
            cropRead(ONBOTTOMRIGHT, fil, Skinname);
            cropRead(ONUPBUTONNORMAL, fil, Skinname);
            cropRead(ONUPBUTONHOVER, fil, Skinname);
            cropRead(ONUPBUTONPRESS, fil, Skinname);
            cropRead(ONUPBUTONDISABLE, fil, Skinname);
            cropRead(ONDOWNBUTONNORMAL, fil, Skinname);
            cropRead(ONDOWNBUTONHOVER, fil, Skinname);
            cropRead(ONDOWNBUTONPRESS, fil, Skinname);
            cropRead(ONDOWNBUTONDISABLE, fil, Skinname);


          end;

        if (com is TONCOMBOBOX) then
            with (TONCOMBOBOX(com)) do
            begin
              isim := 'COMBOBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);

              cropRead(ONBUTONNORMAL,fil,Skinname);
              cropRead(ONBUTONHOVER,fil,Skinname);
              cropRead(ONBUTONPRESS,fil,Skinname);
              cropRead(ONBUTONDISABLE,fil,Skinname);

          //    cropRead(ONBUTTON,fil,Skinname);
            end;

          if (com is TONMEMO) then
            with TONMEMO(com) do
            begin
              isim := 'MEMO';
            if Skindata=nil then
              Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];
              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);
            end;

          if (com is TOnlistBox) then
            with (TOnlistBox(com)) do
            begin
              isim := 'LISTBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);
              cropRead(ONACTIVEITEM,fil,Skinname);
            end;


          if (com is TONScrollBar) then
            with (TONScrollBar(com)) do
             begin
              //if Kind=oHorizontal then
              //  isim := 'SCROLLBAR_H'
              // else
              //  isim := 'SCROLLBAR_V';
               if Skindata=nil then
                 Skindata := Self;

               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];


               cropRead(ONNORMAL,fil,Skinname);
               cropRead(ONLEFT,fil,Skinname);
               cropRead(ONRIGHT,fil,Skinname);
               cropRead(ONTOP,fil,Skinname);
               cropRead(ONBOTTOM,fil,Skinname);
               cropRead(ONBAR,fil,Skinname);
               cropRead(FbuttonNL,fil,Skinname);
               cropRead(FbuttonUL,fil,Skinname);
               cropRead(FbuttonBL,fil,Skinname);
               cropRead(FbuttonDL,fil,Skinname);
               cropRead(FbuttonNR,fil,Skinname);
               cropRead(FbuttonUR,fil,Skinname);
               cropRead(FbuttonBR,fil,Skinname);
               cropRead(FbuttonDR,fil,Skinname);
               cropRead(FbuttonCN,fil,Skinname);
               cropRead(FbuttonCU,fil,Skinname);
               cropRead(FbuttonCB,fil,Skinname);
               cropRead(FbuttonCD,fil,Skinname);

            end;

          if (com is TOnSwich) then
            with (TOnSwich(com)) do
            begin
              isim := 'SWICH';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONOPEN,fil,Skinname);
              cropRead(ONOPENHOVER,fil,Skinname);
              cropRead(ONCLOSE,fil,Skinname);
              cropRead(ONCLOSEHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;

          if (com is TOnCheckBox) then
            with (TOnCheckBox(com)) do
            begin
              isim := 'CHECKBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,Skinname);
              cropRead(ONNORMALHOVER,fil,Skinname);
              cropRead(ONNORMALDOWN,fil,Skinname);
              cropRead(ONCHECKED,fil,Skinname);
              cropRead(ONCHECKEDHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;

          if (com is TOnRadioButton) then
           with (TOnRadioButton(com)) do
           begin
              isim := 'RADIOBUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,Skinname);
              cropRead(ONNORMALHOVER,fil,Skinname);
              cropRead(ONNORMALDOWN,fil,Skinname);
              cropRead(ONCHECKED,fil,Skinname);
              cropRead(ONCHECKEDHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;


          if (com is TONProgressBar) then
            with (TONProgressBar(com)) do
             begin
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONLEFT_TOP,fil,Skinname);
               cropRead(ONRIGHT_BOTTOM,fil,Skinname);
               cropRead(ONCENTER,fil,Skinname);
               cropRead(ONBAR,fil,Skinname);
            end;

           if (com is TONTrackBar) then
            with (TONTrackBar(com)) do
             begin
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONLEFT,fil,Skinname);
               cropRead(ONRIGHT,fil,Skinname);
               cropRead(ONCENTER,fil,Skinname);
               cropRead(ONBUTONNORMAL,fil,Skinname);
               cropRead(ONBUTONHOVER,fil,Skinname);
               cropRead(ONBUTONPRESS,fil,Skinname);
               cropRead(ONBUTONDISABLE,fil,Skinname);
            end;

           if (com is TONCollapExpandPanel) then
            with (TONCollapExpandPanel(com)) do
             begin
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONTOP, fil, Skinname);
               cropRead(ONBOTTOM, fil, Skinname);
               cropRead(ONLEFT, fil, Skinname);
               cropRead(ONRIGHT, fil, Skinname);
               cropRead(ONTOPLEFT, fil, Skinname);
               cropRead(ONTOPRIGHT, fil, Skinname);
               cropRead(ONCENTER, fil, Skinname);
               cropRead(ONBOTTOMLEFT, fil, Skinname);
               cropRead(ONBOTTOMRIGHT, fil, Skinname);
               cropRead(ONNORMAL,fil,Skinname);
               cropRead(ONHOVER,fil,Skinname);
               cropRead(ONPRESSED,fil,Skinname);
               cropRead(ONDISABLE,fil,Skinname);
            end;



       {





          if (com is TOnGroupBox) then
            with (TOnGroupBox(com)) do
            begin
              isim := 'GROUPBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
            end;

          }

    end;
    // end;
  finally
    FreeAndNil(fil);
  end;

end;

procedure TONImg.Readskins;
begin
  Readskins(fparent);
end;

procedure TONImg.Readskins(formm: TForm); // new load ini files
var
  fil: TIniFile;
  memm: TMemoryStream;
  i: integer;
  isim: string;
begin
  try
    memm := TMemoryStream.Create;
    try
      memm.Clear;
      List.SaveToStream(memm);
      memm.Position := 0;
      fil := TIniFile.Create(memm);
    finally
      FreeAndNil(memm);
    end;

    if Fimage.Empty = True then
    begin
      Fimage.LoadFromResource('PANEL');
    end;


    with fil do
    begin

      for i := 0 to formm.ComponentCount - 1 do
      begin

        if (formm.Components[i] is TONPANEL) and (TONPANEL(formm.Components[i]).Skindata=self) then
          with (TONPANEL(formm.Components[i])) do
          begin
            case TAG of
              0: isim := 'PANEL_FREE';
              1: isim := 'PANEL_MAIN';
              2: isim := 'PANEL_HEADER';
            end;
            //isim:=s;
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];

            cropRead(ONTOP, fil, Skinname);
            cropRead(ONBOTTOM, fil, Skinname);
            cropRead(ONLEFT, fil, Skinname);
            cropRead(ONRIGHT, fil, Skinname);
            cropRead(ONTOPLEFT, fil, Skinname);
            cropRead(ONTOPRIGHT, fil, Skinname);
            cropRead(ONCENTER, fil, Skinname);
            cropRead(ONBOTTOMLEFT, fil, Skinname);
            cropRead(ONBOTTOMRIGHT, fil, Skinname);
          end;

        if (formm.Components[i] is TONGraphicPanel) and (TONGraphicPanel(formm.Components[i]).Skindata=self) then
          with (TONGraphicPanel(formm.Components[i])) do
          begin
            case TAG of
              0: isim := 'PANEL_FREE';     //Normal panel not border
              1: isim := 'PANEL_MAIN';     // Normal Panel with border
              2: isim := 'PANEL_HEADER';   // Header Panel
            end;
            if Skindata = nil then
              Skindata := Self;

            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];

            cropRead(ONTOP, fil, Skinname);
            cropRead(ONBOTTOM, fil, Skinname);
            cropRead(ONLEFT, fil, Skinname);
            cropRead(ONRIGHT, fil, Skinname);
            cropRead(ONTOPLEFT, fil, Skinname);
            cropRead(ONTOPRIGHT, fil, Skinname);
            cropRead(ONCENTER, fil, Skinname);
            cropRead(ONBOTTOMLEFT, fil, Skinname);
            cropRead(ONBOTTOMRIGHT, fil, Skinname);
          end;



        if (formm.Components[i] is TONCropButton) and (TONCropButton(formm.Components[i]).Skindata=self) then
          with (TONCropButton(formm.Components[i])) do
          begin
            isim := 'BUTTON';
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];

            cropRead(ONNORMAL, fil, Skinname);
            cropRead(ONHOVER, fil, Skinname);
            cropRead(ONPRESSED, fil, Skinname);
            cropRead(ONDISABLE, fil, Skinname);
          end;

        if (formm.Components[i] is TONGraphicsButton) and (TONGraphicsButton(formm.Components[i]).Skindata=self) then
          with (TONGraphicsButton(formm.Components[i])) do
          begin
            isim := 'BUTTON';
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];

            cropRead(ONNORMAL, fil, Skinname);
            cropRead(ONHOVER, fil, Skinname);
            cropRead(ONPRESSED, fil, Skinname);
            cropRead(ONDISABLE, fil, Skinname);

          end;


        if (formm.Components[i] is TONEDIT) and (TonEdit(formm.Components[i]).Skindata=self) then
          with (TONEDIT(formm.Components[i])) do
          begin
            isim := 'EDIT';
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];
            cropRead(ONTOP, fil, Skinname);
            cropRead(ONBOTTOM, fil, Skinname);
            cropRead(ONLEFT, fil, Skinname);
            cropRead(ONRIGHT, fil, Skinname);
            cropRead(ONTOPLEFT, fil, Skinname);
            cropRead(ONTOPRIGHT, fil, Skinname);
            cropRead(ONCENTER, fil, Skinname);
            cropRead(ONBOTTOMLEFT, fil, Skinname);
            cropRead(ONBOTTOMRIGHT, fil, Skinname);
          end;

        if (formm.Components[i] is TOnSpinEdit) and (TOnSpinEdit(formm.Components[i]).Skindata=self)then
          with (TOnSpinEdit(formm.Components[i])) do
          begin
            isim := 'SPINEDIT';
            if Skindata = nil then
              Skindata := Self;
            Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
            Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
            Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
            Font.Style := [fsBold];
            cropRead(ONTOP, fil, Skinname);
            cropRead(ONBOTTOM, fil, Skinname);
            cropRead(ONLEFT, fil, Skinname);
            cropRead(ONRIGHT, fil, Skinname);
            cropRead(ONTOPLEFT, fil, Skinname);
            cropRead(ONTOPRIGHT, fil, Skinname);
            cropRead(ONCENTER, fil, Skinname);
            cropRead(ONBOTTOMLEFT, fil, Skinname);
            cropRead(ONBOTTOMRIGHT, fil, Skinname);
            cropRead(ONUPBUTONNORMAL, fil, Skinname);
            cropRead(ONUPBUTONHOVER, fil, Skinname);
            cropRead(ONUPBUTONPRESS, fil, Skinname);
            cropRead(ONUPBUTONDISABLE, fil, Skinname);
            cropRead(ONDOWNBUTONNORMAL, fil, Skinname);
            cropRead(ONDOWNBUTONHOVER, fil, Skinname);
            cropRead(ONDOWNBUTONPRESS, fil, Skinname);
            cropRead(ONDOWNBUTONDISABLE, fil, Skinname);


          end;

         if (formm.Components[i] is TONMEMO) and (TONMemo(formm.Components[i]).Skindata=self)then
            with TONMEMO(formm.Components[i]) do
            begin
              isim := 'MEMO';
            if Skindata=nil then
              Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);
            end;


         if (formm.Components[i] is TONCOMBOBOX) and (TONcombobox(formm.Components[i]).Skindata=self) then
            with (TONCOMBOBOX(formm.Components[i])) do
            begin
              isim := 'COMBOBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);
           //   cropRead(ONBUTTON,fil,isim);
            end;





          if (formm.Components[i] is TOnlistBox) and (ToNListBox(formm.Components[i]).Skindata=self)then
            with (TOnlistBox(formm.Components[i])) do
            begin
              isim := 'LISTBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,Skinname);
              cropRead(ONBOTTOM,fil,Skinname);
              cropRead(ONLEFT,fil,Skinname);
              cropRead(ONRIGHT,fil,Skinname);
              cropRead(ONTOPLEFT,fil,Skinname);
              cropRead(ONTOPRIGHT,fil,Skinname);
              cropRead(ONCENTER,fil,Skinname);
              cropRead(ONBOTTOMLEFT,fil,Skinname);
              cropRead(ONBOTTOMRIGHT,fil,Skinname);
              cropRead(ONACTIVEITEM,fil,Skinname);
            end;




           if (formm.Components[i] is TOnSwich) and (TOnSwich(formm.Components[i]).Skindata=self) then
            with (TOnSwich(formm.Components[i])) do
            begin
              isim := 'SWICH';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONOPEN,fil,Skinname);
              cropRead(ONOPENHOVER,fil,Skinname);
              cropRead(ONCLOSE,fil,Skinname);
              cropRead(ONCLOSEHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;

          if (formm.Components[i] is TOnCheckBox) and (TOnCheckbox(formm.Components[i]).Skindata=self) then
            with (TOnCheckBox(formm.Components[i])) do
            begin
              isim := 'CHECKBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,Skinname);
              cropRead(ONNORMALHOVER,fil,Skinname);
              cropRead(ONNORMALDOWN,fil,Skinname);
              cropRead(ONCHECKED,fil,Skinname);
              cropRead(ONCHECKEDHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;

          if (formm.Components[i] is TOnRadioButton) and (TOnRadioButton(formm.Components[i]).Skindata=self) then
            with (TOnRadioButton(formm.Components[i])) do
            begin
              isim := 'RADIOBUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,Skinname);
              cropRead(ONNORMALHOVER,fil,Skinname);
              cropRead(ONNORMALDOWN,fil,Skinname);
              cropRead(ONCHECKED,fil,Skinname);
              cropRead(ONCHECKEDHOVER,fil,Skinname);
              cropRead(ONDISABLE,fil,Skinname);
            end;





           if (formm.Components[i] is TONScrollBar) and (ToNScrollBar(formm.Components[i]).Skindata=self)then
            with (TONScrollBar(formm.Components[i])) do
             begin
               if Skindata=nil then
                 Skindata := Self;

               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];


                 cropRead(ONNORMAL,fil,Skinname);
                 cropRead(ONLEFT,fil,Skinname);
                 cropRead(ONRIGHT,fil,Skinname);
                 cropRead(ONTOP,fil,Skinname);
                 cropRead(ONBOTTOM,fil,Skinname);
                 cropRead(ONBAR,fil,Skinname);
                 cropRead(FbuttonNL,fil,Skinname);
                 cropRead(FbuttonUL,fil,Skinname);
                 cropRead(FbuttonBL,fil,Skinname);
                 cropRead(FbuttonDL,fil,Skinname);
                 cropRead(FbuttonNR,fil,Skinname);
                 cropRead(FbuttonUR,fil,Skinname);
                 cropRead(FbuttonBR,fil,Skinname);
                 cropRead(FbuttonDR,fil,Skinname);
                 cropRead(FbuttonCN,fil,Skinname);
                 cropRead(FbuttonCU,fil,Skinname);
                 cropRead(FbuttonCB,fil,Skinname);
                 cropRead(FbuttonCD,fil,Skinname);
            end;



           if (formm.Components[i] is TONProgressBar) and (TONProgressBar(formm.Components[i]).Skindata=self) then
            with (TONProgressBar(formm.Components[i])) do
             begin

               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONLEFT_TOP,fil,Skinname);
               cropRead(ONRIGHT_BOTTOM,fil,Skinname);
               cropRead(ONCENTER,fil,Skinname);
               cropRead(ONBAR,fil,Skinname);
            end;


           if (formm.Components[i] is TONTrackBar) and (TONTrackBar(formm.Components[i]).Skindata=self)then
            with (TONTrackBar(formm.Components[i])) do
             begin
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONLEFT,fil,Skinname);
               cropRead(ONRIGHT,fil,Skinname);
               cropRead(ONCENTER,fil,Skinname);
               cropRead(ONBUTONNORMAL,fil,Skinname);
               cropRead(ONBUTONHOVER,fil,Skinname);
               cropRead(ONBUTONPRESS,fil,Skinname);
               cropRead(ONBUTONDISABLE,fil,Skinname);
            end;

           if (formm.Components[i] is TONCollapExpandPanel) and (TONCollapExpandPanel(formm.Components[i]).Skindata=self) then
            with (TONCollapExpandPanel(formm.Components[i])) do
             begin
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(Skinname, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(Skinname, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(Skinname, 'Fontsize', '10'));
               Font.Style := [fsBold];

               cropRead(ONTOP, fil, Skinname);
               cropRead(ONBOTTOM, fil, Skinname);
               cropRead(ONLEFT, fil, Skinname);
               cropRead(ONRIGHT, fil, Skinname);
               cropRead(ONTOPLEFT, fil, Skinname);
               cropRead(ONTOPRIGHT, fil, Skinname);
               cropRead(ONCENTER, fil, Skinname);
               cropRead(ONBOTTOMLEFT, fil, Skinname);
               cropRead(ONBOTTOMRIGHT, fil, Skinname);
               cropRead(ONNORMAL,fil,Skinname);
               cropRead(ONHOVER,fil,Skinname);
               cropRead(ONPRESSED,fil,Skinname);
               cropRead(ONDISABLE,fil,Skinname);
            end;



      {


          if (formm.Components[i] is TOnGroupBox) then
            with (TOnGroupBox(formm.Components[i])) do
            begin
              isim := 'GROUPBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
            end;


          }
      end;
    end;
  finally
    FreeAndNil(fil);
  end;

end;




// -----------------------------------------------------------------------------
{ TOnGraphicControl }
// -----------------------------------------------------------------------------


constructor TONGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks, csParentBackground];
  Width := 100;
  Height := 30;
  Fkind := oHorizontal;
  Transparent := True;
  Backgroundbitmaped := True;
  ParentColor := True;
  FAlignment := taCenter;
  Fresim := TBGRABitmap.Create;//(Width, Height,BGRABlack);
  Captionvisible :=true;
end;

destructor TONGraphicControl.Destroy;
begin
  if Assigned(Fresim) then  FreeAndNil(Fresim);
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure TONGraphicControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONGraphicControl.CreateParams(var Params: TCreateParams);
begin
  // inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONGraphicControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONGraphicControl.GetTransparent: boolean;
begin
  Result := Color = clNone;
end;

procedure TONGraphicControl.SetTransparent(NewTransparent: boolean);
begin
  if Transparent = NewTransparent then
    exit;
  if NewTransparent = True then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

function TONGraphicControl.Getkind: Tonkindstate;
begin
  Result := Fkind;
end;

procedure TONGraphicControl.SetKind(AValue: Tonkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure TONGraphicControl.SetSkindata(Aimg: TONImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
    Paint;
  end
  else
  begin
    FSkindata := nil;
  end;
end;

procedure TONGraphicControl.Setskinname(avalue: string);
begin
  if Fskinname<>avalue then
  Fskinname:=avalue;
end;


// -----------------------------------------------------------------------------
procedure TONGraphicControl.Paint;
var
  re: Trect;
begin
  inherited Paint;
  if (Fresim <> nil) then
  begin
 {   if (self is TOnCheckBox) or (self is TOnRadioButton) then
    begin
      case self.Alignment of
        taLeftJustify, taCenter:
        begin
          Fresim.Draw(self.canvas, 0, 0, False);
          re := Rect(Fresim.Width + 5, 0, Self.Width, Self.Height);
        end;

        taRightJustify:
        begin
          Fresim.Draw(self.Canvas, self.Width - Fresim.Width, 0, False);
          re := Rect(0, 0, (Self.Width - Fresim.Width) - 5, Self.Height);
        end;
      end;
      Transparent := True;
    end
    else
    begin  }
    Fresim.Draw(self.canvas, 0, 0, False);
    re := self.ClientRect;
    //   end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
    Fresim.Draw(self.canvas, 0, 0, False);
  end;

  if Captionvisible then
    yaziyaz(self.Canvas, self.Font, re, Caption, Alignment);

end;
// -----------------------------------------------------------------------------




// -----------------------------------------------------------------------------
{ TONControl }
// -----------------------------------------------------------------------------


constructor TONCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csAcceptsControls,
    csClickEvents, csCaptureMouse, csDoubleClicks];
  FAlignment := taCenter;
  DoubleBuffered := True;
  ParentBackground := True;
  Fkind := oHorizontal;
  Backgroundbitmaped := True;
  Width := 100;
  Height := 30;
  Fresim := TBGRABitmap.Create;//(Width, Height,BGRABlack);
  WindowRgn := CreateRectRgn(0, 0, self.Width, self.Height);
  Captionvisible :=true;
end;

destructor TONCustomControl.Destroy;
begin
  if Assigned(Fresim) then  FreeAndNil(Fresim);
  DeleteObject(WindowRgn);
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure TONCustomControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONCustomControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONCustomControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;

procedure TONCustomControl.SetSkindata(Aimg: TONImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
    //    Paint;
  end
  else
  begin
    FSkindata := nil;
  end;
end;

// -----------------------------------------------------------------------------
procedure TONCustomControl.SetCrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;

function TONCustomControl.Getkind: Tonkindstate;
begin
  Result := Fkind;
end;

procedure TONCustomControl.SetKind(AValue: Tonkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure TONCustomControl.Setskinname(avalue: string);
begin
  if Fskinname<>avalue then
  Fskinname:=avalue;
end;

// -----------------------------------------------------------------------------

procedure TONCustomControl.CropToimg(Buffer: TBGRABitmap);
var
  x, y: integer;
  hdc, SpanRgn: integer;
begin
  hdc := GetDC(self.Handle);
  WindowRgn := CreateRectRgn(0, 0, buffer.Width, buffer.Height);
  Premultiply(buffer);
  for x := 1 to buffer.Bitmap.Width do
  begin
    for y := 1 to buffer.Bitmap.Height do
    begin
      if (buffer.GetPixel(x - 1, y - 1) = BGRAPixelTransparent) then
      begin
        SpanRgn := CreateRectRgn(x - 1, y - 1, x, y);
        CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
        DeleteObject(SpanRgn);
      end;
    end;
  end;
  buffer.InvalidateBitmap;
  SetWindowRgn(self.Handle, WindowRgn, True);
  ReleaseDC(self.Handle, hdc);
  DeleteObject(WindowRgn);
  DeleteObject(hdc);
end;
// -----------------------------------------------------------------------------
procedure TONCustomControl.Paint;
var
  re: Trect;
begin
  inherited;
  if (Fresim <> nil) then
  begin
   {  if (self is TOnCheckBox) or (self is TOnRadioButton) then
     begin
        case self.Alignment of
         taLeftJustify:
           begin
             Fresim.Draw(self.canvas, 0, 0, false);
             re:=Rect(Fresim.Width,0,Self.Width,Self.Height);
           end;
         taCenter:
           begin
             Fresim.Draw(self.canvas, 0, 0, false);
             re:=Rect(Fresim.Width,0,Self.Width,Self.Height);
           end;
         taRightJustify:
           begin
             Fresim.Draw(self.Canvas,self.Width-Fresim.Width,0,false );
             re:=Rect(0,0,(Self.Width-Fresim.Width),Self.Height);
           end;
       end;
     end else}
    Fresim.Draw(self.canvas, 0, 0, False);
    re := self.ClientRect;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
    Fresim.Draw(self.canvas, 0, 0, False);
  end;
  //if not (self is TOnGroupBox) and not (self is Toncustomedit) then
  if Captionvisible then
    yaziyaz(self.Canvas, self.Font, re, Caption, Alignment);

end;
// -----------------------------------------------------------------------------




constructor TONFrom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //    ControlStyle := ControlStyle + [csAcceptsControls, csParentBackground,
  //      csClickEvents, csCaptureMouse, csDoubleClicks];
 { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
 csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
 csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
 }
  FUst := TONCUSTOMCROP.Create;
  FUST.cropname := 'TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname := 'BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname := 'CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname := 'RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname := 'TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname := 'BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname := 'LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname := 'TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname := 'BOTTOMLEFT';
  //     Self.Height := 190;
  //     Self.Width := 190;
  //     Fresim.SetSize(Width, Height);
end;

destructor TONFrom.Destroy;
begin
  inherited Destroy;
end;

procedure TONFrom.SetSkindata(Aimg: TONImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
    //    Paint;
  end
  else
  begin
    FSkindata := nil;
  end;
end;

procedure TONFrom.Readskins(formm: TForm);
begin
end;

{ TONPanel }

// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------

constructor TONPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //  ControlStyle    := ControlStyle + [csAcceptsControls, csParentBackground,
  //    csClickEvents, csCaptureMouse, csDoubleClicks];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  fskinname      := 'panel';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Self.Height := 190;
  Self.Width := 190;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------
destructor TONPanel.Destroy;
begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------
{
procedure TONPANEL.SetSkindata(Aimg: TONImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
    Paint;
  end else
  begin
  FSkindata:=nil;
  end;
end;
}
procedure TONPanel.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try



      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft),
        0, Width, (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0,
        self.Width - (FTopRight.FSRight - FTopRight.FSLeft),
        (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop,
        FBottomleft.FSRight, FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //CENTERLEFT // SOLORTA
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTERRIGHT // SAĞORTA
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - (FRight.FSRight - FRight.FSLeft), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      if Crop then
        CropToimg(Fresim);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;
//-----------------------------------------------------------------------------


{ TONGraphicPanel }

constructor tongraphicpanel.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  fskinname      := 'graphicpanel';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Self.Height := 190;
  Self.Width := 190;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------
destructor tongraphicpanel.Destroy;
begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft);
  inherited Destroy;
end;

procedure tongraphicpanel.paint;
var
  TrgtRect, SrcRect: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //TOPLEFT   //SOLÜST
      SrcRect := Rect(FTopleft.FSLeft, FTopleft.FSTop, FTopleft.FSRight,
        FTopleft.FSBottom);
      TrgtRect := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft,
        FTopleft.FSBottom - FTopleft.FSTop);
      DrawPartnormal(SrcRect, self, TrgtRect, False);


      //TOPRIGHT //SAĞÜST
      SrcRect := Rect(FTopRight.FSLeft, FTopRight.FSTop, FTopRight.FSRight,
        FTopRight.FSBottom);
      TrgtRect := Rect(Width - (FTopRight.FSRight - FTopRight.FSLeft),
        0, Width, (FTopRight.FSBottom - FTopRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //TOP  //ÜST
      SrcRect := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      TrgtRect := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0,
        self.Width - (FTopRight.FSRight - FTopRight.FSLeft),
        (FTop.FSBottom - FTop.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //BOTTOMLEFT // SOLALT
      SrcRect := Rect(FBottomleft.FSLeft, FBottomleft.FSTop,
        FBottomleft.FSRight, FBottomleft.FSBottom);
      TrgtRect := Rect(0, Height - (FBottomleft.FSBottom - FBottomleft.FSTop),
        (FBottomleft.FSRight - FBottomleft.FSLeft), Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOMRIGHT  //SAĞALT
      SrcRect := Rect(FBottomRight.FSLeft, FBottomRight.FSTop,
        FBottomRight.FSRight, FBottomRight.FSBottom);
      TrgtRect := Rect(Width - (FBottomRight.FSRight - FBottomRight.FSLeft),
        Height - (FBottomRight.FSBottom - FBottomRight.FSTop), self.Width, self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //BOTTOM  //ALT
      SrcRect := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      TrgtRect := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),
        self.Height - (FBottom.FSBottom - FBottom.FSTop), Width -
        (FBottomRight.FSRight - FBottomRight.FSLeft), self.Height);
      DrawPartnormal(SrcRect, self, TrgtRect, False);




      //CENTERLEFT // SOLORTA
      SrcRect := Rect(Fleft.FSLeft, Fleft.FSTop, Fleft.FSRight, Fleft.FSBottom);
      TrgtRect := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,
        (Fleft.FSRight - Fleft.FSLeft), Height -
        (FBottomleft.FSBottom - FBottomleft.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTERRIGHT // SAĞORTA
      SrcRect := Rect(FRight.FSLeft, FRight.FSTop, FRight.FSRight, FRight.FSBottom);
      TrgtRect := Rect(Width - (FRight.FSRight - FRight.FSLeft),
        (FTopRight.FSBottom - FTopRight.FSTop), Width, Height -
        (FBottomRight.FSBottom - FBottomRight.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

      //CENTER //ORTA
      SrcRect := Rect(FCenter.FSLeft, FCenter.FSTop, FCenter.FSRight, FCenter.FSBottom);
      TrgtRect := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop),
        Width - (FRight.FSRight - FRight.FSLeft), Height -
        (FBottom.FSBottom - FBottom.FSTop));
      DrawPartnormal(SrcRect, self, TrgtRect, False);

    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;


{ TONCropButton }

// -----------------------------------------------------------------------------
constructor TONCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fskinname      := 'cropbutton';
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'CLICK';
  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate := obsNormal;
  Width := 100;
  Height := 30;
  Fcrop := True;
  FAutoWidth := True;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------

destructor TONCropButton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONCropButton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(Fresim) then
  begin
    Width := Fresim.Width;
    Height := Fresim.Height;
  end;

end;

procedure TONCropButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONCropButton.Paint;
var
  DR: TRect;
begin
  Fresim.SetSize(self.Width, Self.Height);
  if (FSkindata <> nil) then
  begin
    try
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
            Self.Font.Color:=FNormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := Rect(FPress.FSLeft, FPress.FSTop,
              FPress.FSRight, FPress.FSBottom);
            Self.Font.Color:=FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := Rect(FEnter.FSLeft, FEnter.FSTop,
              FEnter.FSRight, FEnter.FSBottom);
            Self.Font.Color:=FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
        Self.Font.Color:=Fdisable.Fontcolor;
      end;

      DrawPartstrech(DR, self, Width, Height);
      if Crop = True then
        CropToimg(Fresim);
    finally

    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;



procedure TONCropButton.MouseLeave;
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obsnormal) then
    Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;

end;
// -----------------------------------------------------------------------------
procedure TONCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obspressed) then
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
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obshover) then
    Exit;


  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obshover;//bsnormal;
  Invalidate;

end;


procedure TONCropButton.MouseEnter;
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obshover) then
    Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;

end;


procedure TONCropButton.CMHittest(var msg: TCMHIttest);
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


procedure tongraphicsbutton.mouseenter;
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obshover) then
    Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;


procedure tongraphicsbutton.mouseup(button: tmousebutton; shift: tshiftstate;
  x: integer; y: integer);
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obshover) then
    Exit;


  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obshover;
  Invalidate;
end;


constructor tongraphicsbutton.Create(aowner: TComponent);
begin
  inherited Create(AOwner);
  fskinname      := 'button';
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'CLICK';
  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';
  Fstate := obsNormal;
  Width := 100;
  Height := 30;
  Transparent := True;
  //  ControlStyle := ControlStyle + [csClickEvents, csDoubleClicks, csCaptureMouse];
  FAutoWidth := True;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------

destructor tongraphicsbutton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure tongraphicsbutton.CheckAutoWidth;
begin
  if FAutoWidth and Assigned(Fresim) then
  begin
    Width := Fresim.Width;
    Height := Fresim.Height;
  end;

end;

procedure tongraphicsbutton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure tongraphicsbutton.Paint;
var
  //  HEDEF,
  DR: TRect;
begin

  Fresim.SetSize(self.Width, Self.Height);
  if (FSkindata <> nil) then
    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin
    try
      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
            Self.Font.Color:=FNormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := Rect(FPress.FSLeft, FPress.FSTop,
              FPress.FSRight, FPress.FSBottom);
            Self.Font.Color:=FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := Rect(FEnter.FSLeft, FEnter.FSTop,
              FEnter.FSRight, FEnter.FSBottom);
            Self.Font.Color:=FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
        Self.Font.Color:=Fdisable.Fontcolor;
      end;

      DrawPartstrech(DR, self, Width, Height);

    finally

    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;


procedure tongraphicsbutton.MouseLeave;
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obsnormal) then
    Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;

end;
// -----------------------------------------------------------------------------
procedure tongraphicsbutton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if (csDesigning in ComponentState) or (not Enabled) or (Fstate = obspressed) then
    Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    Fstate := obspressed;
    Invalidate;
  end;

end;



end.

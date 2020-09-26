unit onurbutton;



{$mode objfpc}{$H+}

{$R onres.res}

interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, Classes, StdCtrls, LazMethodList,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes, Calendar,Dialogs;



type
  TONButtonState      = (bshover, bspressed, bsnormal);
  //  TONCheckState       = (bsChecked, bspasif);
  //  TONSwichState       = (Fon, Foff);
  TONProgressState    = (Fhorizontal, Fvertical);
  TONScroll           = (FDown,FUp);
  TONMouseEvent       = procedure(Msg: TWMMouse) of object;
  TONMouseOverEvent   = procedure(Sender: TObject) of object;
  TONMouseOutEvent    = procedure(Sender: TObject) of object;
  TONPaintEvent       = procedure(Sender: TObject; var continue: boolean) of object;
  TONCheckDateEvent   = function(Sender: TObject; Date: TDateTime): boolean of object;


{  TonPersistent = class(TPersistent)
    owner: TPersistent;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
  end;

 }

  TONCustomCrop = class(TPersistent)//(TonPersistent)
  private
    FSleft, FSTop, FSright, FSBottom: integer;
    cropname:string;
  published
    property OLEFT   : integer read FSleft   write FSleft;
    property OTOP    : integer read FSTop    write FSTop;
    property ORIGHT  : integer read FSright  write FSright;
    property OBOTTOM : integer read FSBottom write FSBottom;
  end;


  TONImg = class(TComponent)
    Fimage : TBGRABitmap;
    FRes   : TPicture;
    List   : TStringList;
    procedure ImageSet(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Readskins(formm: TForm);
    procedure   ReadskinsComp(Com:TComponent);
    property    Images  : TBGRABitmap read Fimage write Fimage;
  published
    property    Picture : TPicture    read FRes   write FRes;
  end;

  TONFrom = class(Tcomponent)
    fromm     : TForm;
    FSkindata : TONImg;
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Readskins(formm: TForm);
//    procedure paint; override;
  published
    property Skindata: TONImg  read FSkindata write SetSkindata;
   end;

  TONGraphicControl = class(TGraphicControl)
  private
    FCaption      : string;
    FFont         : TFont;
    Fcrop         : boolean;
    FAlignment    : TAlignment;
    Fresim        : TBGRABitmap;
    FSkindata     : TONImg;
    WindowRgn     : HRGN;
    FOnMouseEnter : TNotifyEvent;
    FOnMouseLeave : TNotifyEvent;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetCaption(Value: string);
    procedure SetFont(const Value: TFont);
    procedure SetCrop(Value: boolean);
    procedure SetAlignment(const Value: TAlignment);
    function GetTransparent: boolean;
    procedure SetTransparent(NewTransparent: boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CropToimg(Buffer: TBGRABitmap);//TBitmap32);
//    property Skindata: TONImg  read FSkindata write SetSkindata;
    procedure Paint; override;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property Transparent: boolean
      read GetTransparent write SetTransparent default True;
  published
    property Align;
    property Alignment: TAlignment
      read FAlignment write SetAlignment default taCenter;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption: string read FCaption write SetCaption;
    property ClientHeight;
    property ClientWidth;
    property Crop: boolean
      read Fcrop write SetCrop default False;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font: TFont
      read FFont write SetFont stored True;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  TONControl = class(TCustomControl)
  private
    FCaption   : string;
    FFont      : TFont;
    Fcrop      : boolean;
    FAlignment : TAlignment;
    Fresim     : TBGRABitmap;
    FSkindata  : TONImg;
    WindowRgn  : HRGN;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetCaption(Value: string);
    procedure SetFont(Value: TFont);
    procedure SetCrop(Value: boolean);
    procedure SetAlignment(const Value: TAlignment);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CropToimg(Buffer: TBGRABitmap);//TBitmap32);

    procedure Paint; override;
    //virtual; abstract; //dynamic;//overload;//virtual; //override;
  published
    property Align;
    property Alignment: TAlignment
      read FAlignment write SetAlignment default taCenter;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption: string read FCaption write SetCaption;
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
    property Font: TFont read FFont write SetFont stored True;
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

  TONPANEL = class(TONControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint override;

  published
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
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
    property ONLEFT        : TONCUSTOMCROP read FSol     write FSol;
    property ONRIGHT       : TONCUSTOMCROP read FSag     write FSag;
    property ONCENTER      : TONCUSTOMCROP read FOrta    write FOrta;
    property ONBOTTOM      : TONCUSTOMCROP read FAlt     write FAlt;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FSolalt  write FSolalt;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FSagalt  write FSagalt;
    property ONTOP         : TONCUSTOMCROP read FUst     write FUst;
    property ONTOPLEFT     : TONCUSTOMCROP read FSolust  write FSolust;
    property ONTOPRIGHT    : TONCUSTOMCROP read FSagust  write FSagust;
//    property Skindata;
  end;

type
  TOnCurrencyEdit = class(TCustomMemo)
  private
    DispFormat     : string;
    FieldValue     : extended;
    FDecimalPlaces : word;
    FPosColor      : TColor;
    FNegColor      : TColor;
    procedure SetFormat(A: string);
    procedure SetFieldValue(A: extended);
    procedure SetDecimalPlaces(A: word);
    procedure SetPosColor(A: TColor);
    procedure SetNegColor(A: TColor);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure FormatText;
    procedure UnFormatText;
  protected
    procedure KeyPress(var Key: char); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Alignment default taRightJustify;
    property AutoSize default True;
    property Color;
    property DecimalPlaces: word read FDecimalPlaces write SetDecimalPlaces default 2;
    property DisplayFormat: string read DispFormat write SetFormat;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property NegColor: TColor read FNegColor write SetNegColor default clRed;
    property ParentColor;

    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PosColor: TColor read FPosColor write SetPosColor default clBlack;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property Value: extended read FieldValue write SetFieldValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;



  TONCustomComboBoxe = class(TCustomComboBox)
  private
    Fbuttonimage       : TPicture;
    FForceDrawFocused  : boolean;
    FMouseInControl    : boolean;
    FOnPaint           : TOnPaintEvent;
    FCustomProperty    : string;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure PaintCombo;
    procedure ReplaceInvalidateInQueueByRefresh;
    procedure Setbuttonimage(Value: TPicture);
//    procedure SetSkindata(Aimg: TONImg);
  protected
    procedure WndProc(var Message: TMessage); override;
    property OnPaint: TOnPaintEvent read FOnPaint write FOnPaint;
    property CustomProperty: string read FcustomProperty write FcustomProperty;
    property Butonimage: TPicture read FButtonimage write SetButtonimage;
  public
    property ForceDrawFocused: boolean read FForceDrawFocused;
    property MouseInControl: boolean read FMouseInControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  {------------------------------------}
  TOnComboBoxe = class(TONCustomComboBoxe)
  published
    property OnPaint;
    property CustomProperty;
    //property AutoCloseUp default False;
    //property BevelEdges;
    //property BevelInner;
    //property BevelKind default bkNone;
    //property BevelOuter;
    //property BiDiMode;
    //property Constraints;
    //property Ctl3D;
    //property ImeMode;
    //property ImeName;
    //property ParentBiDiMode;
    //property ParentCtl3D;
    property AutoComplete default True;
    property AutoDropDown default False;
    property Style;
    property Anchors;
    property CharCase;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property ItemHeight;
    property ItemIndex default -1;
    property MaxLength;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
    property Items;
    property Font;
    property Color;
    property ParentFont;
    property ParentColor;
  end;

  TONCOMBOBOX = class(TONControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt,
    FOrta, Fbuton: TONCUSTOMCROP;
    Fcombo: TONComboBoxe;
    procedure SetSkindata(Aimg: TONImg);
    //    fbuTtonimage    : TBGRABitmap;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint override;
  published
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property Combobox: TONComboBoxe read Fcombo write Fcombo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
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
    property ONLEFT        : TONCUSTOMCROP read FSol    write FSol;
    property ONRIGHT       : TONCUSTOMCROP read FSag    write FSag;
    property ONCENTER      : TONCUSTOMCROP read FOrta   write FOrta;
    property ONBOTTOM      : TONCUSTOMCROP read FAlt    write FAlt;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FSolalt write FSolalt;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FSagalt write FSagalt;
    property ONTOP         : TONCUSTOMCROP read FUst    write FUst;
    property ONTOPLEFT     : TONCUSTOMCROP read FSolust write FSolust;
    property ONTOPRIGHT    : TONCUSTOMCROP read FSagust write FSagust;
    property ONBUTTON      : TONCUSTOMCROP read Fbuton  write Fbuton;

  end;

  TONEDIT = class(TONControl)

  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    fedit: TEdit;
    FAutoSelect, FAutoSelected, Freadonly: boolean;
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property AutoSelect   : boolean read FAutoSelect   write FAutoSelect default True;
    property AutoSelected : boolean read FAutoSelected write FAutoSelected;
    property ParentColor default False;
    procedure SetReadonly(Value: boolean);
    procedure SelectAll;
    procedure Paint override;
  published
    property Skindata      : TONImg        read FSkindata write SetSkindata;
    property Editi         : TEdit         read fedit     write fEdit;
    property ReadOnly      : boolean       read Freadonly write SetReadOnly default False;
    property ONLEFT        : TONCUSTOMCROP read FSol      write FSol;
    property ONRIGHT       : TONCUSTOMCROP read FSag      write FSag;
    property ONCENTER      : TONCUSTOMCROP read FOrta     write FOrta;
    property ONBOTTOM      : TONCUSTOMCROP read FAlt      write FAlt;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FSolalt   write FSolalt;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FSagalt   write FSagalt;
    property ONTOP         : TONCUSTOMCROP read FUst      write FUst;
    property ONTOPLEFT     : TONCUSTOMCROP read FSolust   write FSolust;
    property ONTOPRIGHT    : TONCUSTOMCROP read FSagust   write FSagust;
    property TabOrder;
    property TabStop default True;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize default True;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
    property BorderStyle default bsSingle;
    property Caption;// : string read fedit.Text write fedit.Text;
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
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
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

  TONCURREDIT = class(TONControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    fedit: TOnCurrencyEdit;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint override;
  published
    property Skindata      : TONImg        read FSkindata write SetSkindata;
    property Editi         : TOnCurrencyEdit read fedit write fEdit;
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
    property BidiMode;
    property BorderWidth;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
//    property Skindata;
  end;




  TONMEMO = class(TONControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta: TONCUSTOMCROP;
    fmemo: Tmemo;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint override;
    //    property Editi:Toeditt read Edit1;
  published
    property memoo         : Tmemo         read Fmemo     write Fmemo;
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

    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
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
  protected

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

  TONCropButton = class(TOnControl)
  private
    FNormal, FBasili, FUzerinde, FPasif: TONCUSTOMCROP;
    FDurum: TONButtonState;       //     DR                : TRect;
    FAutoWidth: boolean;
    procedure SetSkindata(Aimg: TONImg);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property AutoWidth: boolean
      read FAutoWidth write SetAutoWidth default True;
    property ONNORMAL  : TONCUSTOMCROP read FNormal   write FNormal;
    property ONPRESSED : TONCUSTOMCROP read FBasili   write FBasili;
    property ONHOVER   : TONCUSTOMCROP read FUzerinde write FUzerinde;
    property ONPASIF   : TONCUSTOMCROP read FPasif    write FPasif;

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

  TONButton = class(TOnGraphicControl)
  private
    FNormal, FBasili, FUzerinde, FPasif: TONCUSTOMCROP;
    FDurum: TONButtonState;
    // DR                : TRect;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: integer;
      Y: integer); override;
    //    procedure WMMouseLeave(var Msg: TWMMouse); message CM_MOUSELEAVE;
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
    //    property OnClick       : TNotifyEvent read FOnClick      write FOnClick;

  published
    { Published declarations }
    property ONNORMAL  : TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED : TONCUSTOMCROP read FBasili write FBasili;
    property ONHOVER   : TONCUSTOMCROP read FUzerinde write FUzerinde;
    property ONPASIF   : TONCUSTOMCROP read FPasif write FPasif;
    property OnMouseDown;
    property OnMouseEnter;//  : TOnMouseEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave;//  : TOnMouseEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp;//     : TOnMouseEvent read FOnMouseUp    write FOnMouseUp;
//    property Skindata;
    property Skindata: TONImg  read FSkindata write SetSkindata;
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

  TOnCheckBox = class(TOnGraphicControl)
  private
    FNormal, FBasili, FPasifnormal, FPasifcheck: TONCUSTOMCROP;
    //    FDurum                    : TONCheckState;
    DR: TRect;
    FChecked: boolean;
    //    FFreeEvent                : THandle;
    Fresimuzunlugu, Fresimyuksligi: integer;
{    FOnMouseDown              : TOnMouseEvent;
    FOnMouseEnter             : TOnMouseEvent;
    FOnMouseLeave             : TOnMouseEvent;
    FOnMouseUp                : TOnMouseEvent; }
    procedure SetChecked(Value: boolean);
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // procedure Ciz;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  {
    procedure Click; override;
    procedure WMMouseEnter(var Msg: TWMMouse); message CM_MOUSEENTER;
    procedure WMMouseLeave(var Msg: TWMMouse); message CM_MOUSELEAVE;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Msg: TWMLButtonUp); message WM_LBUTTONDOWN;   }
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
  published
    { Published declarations }
    property ONNORMAL      : TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED     : TONCUSTOMCROP read FBasili write FBasili;
    property ONPASIFNORMAL : TONCUSTOMCROP read FPasifnormal write FPasifnormal;
    property ONPASIFCHECK  : TONCUSTOMCROP read FPasifcheck write FPasifcheck;
    property OnMouseDown;//     : TOnMouseEvent read FOnMouseDown   write FOnMouseDown;
    property OnMouseEnter;//    : TOnMouseEvent read FOnMouseEnter  write FOnMouseEnter;
    property OnMouseLeave;//    : TOnMouseEvent read FOnMouseLeave  write FOnMouseLeave;
    property OnMouseUp;//       : TOnMouseEvent read FOnMouseUp     write FOnMouseUp;
    property Checked: boolean     read FChecked write SetChecked default False;
    //    property OnChange;
    property OnMouseMove;
    property OnClick;
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    //    property BorderSpacing;
    property BidiMode;
    //    property BorderWidth;
    //    property BorderStyle;
    //    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    //    property DockSite;
    //    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBidiMode;
    //    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent;
    //    property TabOrder;
    //    property TabStop;
    //    property UseDockManager default True;
    property Visible;
    property OnContextPopup;
    //    property OnDockDrop;
    //    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    //    property OnEnter;
    //    property OnExit;
    //    property OnGetSiteInfo;
    //    property OnGetDockCaption;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    //    property OnStartDock;
    //    property OnStartDrag;
    //    property OnUnDock;
  end;

  TOnRadioButton = class(TOnGraphicControl)
  private
    FNormal, FBasili, FPasifnormal, FPasifcheck: TONCUSTOMCROP;
    //    FDurum                    : TONCheckState;
    //    DR                        : TRect;
    FChecked: boolean;
    Fresimuzunlugu, Fresimyuksligi, FGroupIndex: integer;
    procedure SetChecked(Value: boolean);
    procedure deaktifdigerleri;
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  protected
    procedure Paint; override;

    //    procedure Click; override;
   { procedure WMMouseEnter(var Msg: TWMMouse); message CM_MOUSEENTER;
    procedure WMMouseLeave(var Msg: TWMMouse); message CM_MOUSELEAVE;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Msg: TWMLButtonUp); message WM_LBUTTONDOWN;
    }
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
  published
    { Published declarations }
    property ONNORMAL      : TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED     : TONCUSTOMCROP read FBasili write FBasili;
    property ONPASIFNORMAL : TONCUSTOMCROP read FPasifnormal write FPasifnormal;
    property ONPASIFCHECK  : TONCUSTOMCROP read FPasifcheck write FPasifcheck;
    property OnMouseDown;//     : TOnMouseEvent read FOnMouseDown   write FOnMouseDown;
    property OnMouseEnter;//    : TOnMouseEvent read FOnMouseEnter  write FOnMouseEnter;
    property OnMouseLeave;//    : TOnMouseEvent read FOnMouseLeave  write FOnMouseLeave;
    property OnMouseUp;//       : TOnMouseEvent read FOnMouseUp     write FOnMouseUp;
    property Checked: boolean
      read FChecked write SetChecked default False;
    property GroupIndex: integer
      read FGroupIndex write FGroupIndex default 0;
    property OnMouseMove;
    property OnClick;
    property Skindata: TONImg  read FSkindata write SetSkindata;
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
    property Transparent;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;



  TOnSwich = class(TOnControl)
  private
    FNormal, FBasili, FPasifnormal, FPasifbasili: TONCUSTOMCROP;
    ///    FDurum            : TONSwichstate;
    DR: TRect;
    FChecked: boolean;
    Fresimuzunlugu, Fresimyuksligi: integer;
    FOnMouseDown: TOnMouseEvent;
    FOnMouseEnter: TOnMouseEvent;
    FOnMouseLeave: TOnMouseEvent;
    FOnMouseUp: TOnMouseEvent;
    procedure SetChecked(Value: boolean);
    procedure SetSkindata(Aimg: TONImg);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //    procedure Ciz;
  protected
    procedure Paint; override;
    procedure WMMouseEnter(var Msg: TWMMouse); message CM_MOUSEENTER;
    procedure WMMouseLeave(var Msg: TWMMouse); message CM_MOUSELEAVE;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Msg: TWMLButtonUp); message WM_LBUTTONDOWN;
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
  published
    { Published declarations }
    property ONNORMAL        : TONCUSTOMCROP read FNormal write FNormal;
    property ONPRESSED       : TONCUSTOMCROP read FBasili write FBasili;
    property ONPASIFNORMAL   : TONCUSTOMCROP read FPasifnormal write FPasifnormal;
    property ONPASIFPRESSED  : TONCUSTOMCROP read FPasifbasili write FPasifbasili;
    property OnMouseDown: TOnMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseEnter: TOnMouseEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TOnMouseEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp: TOnMouseEvent read FOnMouseUp write FOnMouseUp;
    property Checked: boolean
      read FChecked write SetChecked default False;
    property OnMouseMove;
    property OnClick;
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property BorderWidth;
    property BorderStyle;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBidiMode;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
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
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;



  TONProgressBar = class(TOnGraphicControl)
  private
    Fsol, Fsag: TONCUSTOMCROP;
    Fust, Falt: TONCUSTOMCROP;
    FNormal, Fbar: TONCUSTOMCROP;
    FDurum: TONProgressState;
    fcaptionbol: boolean;
    Fmin, Fmax, Fposition: integer;
    Freh: integer;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure Paint; override;
    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
    procedure Setaz(val: integer);
    procedure Setcok(val: integer);
    procedure Setdeger(val: integer);
    procedure SetState(val: TONProgressState);
  published
    { Published declarations }
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Captionview: boolean read fcaptionbol write fcaptionbol;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property Min      : integer       read Fmin    write Setaz;
    property Max      : integer       read Fmax    write Setcok;
    property ONLEFT   : TONCUSTOMCROP read Fsol    write Fsol;
    property ONRIGHT  : TONCUSTOMCROP read Fsag    write Fsag;
    property ONTOP    : TONCUSTOMCROP read Fust    write Fust;
    property ONBOTTOM : TONCUSTOMCROP read Falt    write Falt;
    property ONNORMAL : TONCUSTOMCROP read FNormal write FNormal;
    property ONBAR    : TONCUSTOMCROP read Fbar    write Fbar;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnPaint;
    property OnResize;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position: integer read Fposition write Setdeger;
    property ShowHint;
    property Skindata: TONImg  read FSkindata write SetSkindata;
    property State: TONProgressState read FDurum write SetState;
    property Visible;

  end;

{   TONScrollButton = class(TOnGraphicControl)
  private
    FNormal                : TONCUSTOMCROP;
    FHover                 : TONCUSTOMCROP;
    FPressed               : TONCUSTOMCROP;
    FDisabled              : TONCUSTOMCROP;
    FYo, FXo, FTOP,FBOTTOM : integer;
    Fdurum                 : TONButtonState;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
  published
    property ONBUTTONNORMAL  : TONCUSTOMCROP read FNormal   write FNormal;
    property ONBUTTONHOVER   : TONCUSTOMCROP read FHover    write FHover;
    property ONBUTTONPRESS   : TONCUSTOMCROP read FPressed  write FPressed;
    property ONBUTTONDISABLE : TONCUSTOMCROP read FDisabled write FDisabled;
  end;
}



  TONScrollBar = class(TOnControl)
  private
    Fsol, Fsag           : TONCustomCrop;
    Fust, Falt           : TONCustomCrop;
    FNormali, Fbar       : TONCustomCrop;
    FbuttonNL,FbuttonUL,
    FbuttonBL,FbuttonDL,
    FbuttonNR,FbuttonUR,
    FbuttonBR,FbuttonDR,
    FbuttonCN,FbuttonCU,
    FbuttonCB,FbuttonCD  : TONCustomCrop;
    FDurump              : TONProgressState;
    Fdurum               : TONButtonState;
    FdurumLR             : TONButtonState;
    FdurumRB             : TONButtonState;
    FdurumCNTR           : TONButtonState;
    Fmin, Fmax,
    Fposition,
    Fthumbsize,
    Fpagesize            : integer;
    FbuttonLT,FbuttonRB,
    trackarea,
    FButtonCNTR          : Trect;// TONScrollButton;
    Cursorpos            : Tpoint;
    procedure SetSkindata(Aimg: TONImg);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
//    property Resize          :TNotifyEvent   read onresz   write OnResz;
  protected

    procedure CMHittest(var msg: TCMHittest); message CM_HITTEST;
    procedure Setaz(val: integer);
    procedure Setcok(val: integer);
    procedure Setdeger(val: integer);
    procedure SetState(val: TONProgressState);
    procedure SetFpagesize(val: integer);
    procedure Butonclick(Sender:Tobject);
    procedure Buttonsizeset;
    procedure Resize(sender:TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property Min               : integer       read Fmin      write Setaz;
    property Max               : integer       read Fmax      write Setcok;
    property ONLEFT            : TONCUSTOMCROP read Fsol      write Fsol;
    property ONRIGHT           : TONCUSTOMCROP read Fsag      write Fsag;
    property ONTOP             : TONCUSTOMCROP read Fust      write Fust;
    property ONBOTTOM          : TONCUSTOMCROP read Falt      write Falt;
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
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnPaint;
    property OnResize;
    property Pagesize        : integer          read Fpagesize write SetFpagesize;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position        : integer          read Fposition write Setdeger;
    property ShowHint;
    property Skindata        : TONImg           read FSkindata write SetSkindata;
    property State           : TONProgressState read FDurump   write SetState;
    property Visible;

  end;
{  
  TOnListBox = class(TOnControl)
  private
    cWheelMessage: Cardinal;
    scrollType: TScrollType;
    firstItem: Integer;
    maxItems: Integer;
    FSorted: Boolean;
    FItems: TStringList;
    FItemsRect: TList;
    FItemsHeight: Integer;
    FItemIndex: Integer;
    FSelected: set of Byte;
    FMultiSelect: Boolean;
    FScrollBars: Boolean;
    FUseAdvColors: Boolean;
    FAdvColorBorder: TAdvColors;
    FArrowColor: TColor;
    FBorderColor: TColor;
    FItemsRectColor: TColor;
    FItemsSelectColor: TColor;
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure SetSorted (Value: Boolean);
    procedure SetItems (Value: TStringList);
    procedure SetItemsRect;
    procedure SetItemsHeight (Value: Integer);
    function  GetSelected (Index: Integer): Boolean;
    procedure SetSelected (Index: Integer; Value: Boolean);
    function  GetSelCount: Integer;
    procedure SetScrollBars (Value: Boolean);
    function  GetItemIndex: Integer;
    procedure SetItemIndex (Value: Integer);
    procedure SetMultiSelect (Value: Boolean);
    procedure CMEnabledChanged(var Message: TLMessage); message CM_ENABLEDCHANGED;
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged(var Message: TLMessage); message CM_PARENTCOLORCHANGED;
    procedure CNKeyDown(var Message: TLMKeyDown); message CN_KEYDOWN;
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
    procedure WMMove(var Message: TLMMove); message LM_MOVE;
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;
    procedure WMMouseWheel(var Message: TLMMouseEvent); message LM_MOUSEWHEEL;
    procedure ScrollTimerHandler (Sender: TObject);
    procedure ItemsChanged (Sender: TObject);
    procedure SetTransparent (const Value: TplTransparentMode);
  protected
    procedure CalcAdvColors;
    procedure DrawScrollBar (aCanvas: TCanvas);
    procedure Paint; override;
    procedure Loaded; override;
    procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WndProc (var Message: TMessage); override;
    procedure SetBiDiMode(Value: TBiDiMode); override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    property Selected [Index: Integer]: Boolean read GetSelected write SetSelected;
    property SelCount: Integer read GetSelCount;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;


    property ColorArrow: TColor index 0 read FArrowColor write SetColors ;
    property ColorBorder: TColor index 1 read FBorderColor write SetColors ;

    property ColorItemsRect: TColor index 2 read FItemsRectColor write SetColors ;
    property ColorItemsSelect: TColor index 3 read FItemsSelectColor write SetColors ;

    property AdvColorBorder: TAdvColors index 0 read FAdvColorBorder write SetAdvColors ;
    property UseAdvColors: Boole    property ONLEFT            : TONCUSTOMCROP read Fsol      write Fsol;
    property ONRIGHT           : TONCUSTOMCROP read Fsag      write Fsag;
    property ONTOP             : TONCUSTOMCROP read Fust      write Fust;
    property ONBOTTOM          : TONCUSTOMCROP read Falt      write Falt;
    property ONNORMAL          : TONCUSTOMCROP read FNormali  write FNormali;
    property ONBAR             : TONCUSTOMCROP read Fbar      write Fbar;
    property ONLEFTBUTNORMAL   : TONCUSTOMCROP read FbuttonNL write FbuttonNL;
    property ONLEFTBUTONHOVER  : TONCUSTOMCROP read FbuttonUL write FbuttonUL;
    property ONLEFTBUTPRESS    : TONCUSTOMCROP read FbuttonBL write FbuttonBL;
    property ONLEFTBUTDISABLE  : TONCUSTOMCROP read FbuttonDL write FbuttonDL;
    property ONRIGHTBUTNORMAL  : TONCUSTOMCROP read FbuttonNR write FbuttonNR;
    property ONRIGHTBUTONHOVER : TONCUSTOMCROP read FbuttonUR write FbuttonUR;
    property ONRIGHTBUTPRESS   : TONCUSTOMCROP read FbuttonBR write FbuttonBR;
    property ONRIGHTBUTDISABLE : TONCUSTOMCROP read FbuttonDR write FbuttonDR;  an read FUseAdvColors write SetUseAdvColors ;

  published
    property TransparentMode: TplTransparentMode read FTransparent write SetTransparent default tmNone;
    property Align;
    property Items: TStringList read FItems write SetItems;
    property ItemHeight: Integer read FItemsHeight write SetItemsHeight default 14;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default false;
    property ScrollBars: Boolean read FScrollBars write SetScrollBars default true;
    property Color default $00D6BBA3;

    property Sorted: Boolean read FSorted write SetSorted default false;
    property Font;
    property ParentFont;
    property ParentColor;
    property ParentShowHint;
    property Enabled;
    property Visible;
    property PopupMenu;
    property ShowHint;

    property OnClick;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;

    property Anchors;
    property BiDiMode write SetBidiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
  end;

}


  TAcceptDateEvent = procedure(Sender: TObject; var ADate: TDateTime;
    var AcceptDate: boolean) of object;
  TCustomDateEvent = procedure(Sender: TObject; var ADate: string) of object;
  TDateOrder = (doNone, doMDY, doDMY, doYMd);

  TONDATEEDIT = class(TOnControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst,
    FAlt, FOrta, Fbutton: TONCUSTOMCROP;
    Fedit: TMaskEdit;
    FDateOrder: TDateOrder;
    FDefaultToday: boolean;
    FDisplaySettings: TDisplaySettings;
    FDroppedDown: boolean;
    FOnAcceptDate: TAcceptDateEvent;
    FOnCustomDate: TCustomDateEvent;
    //    FOnEditEditingDone: TNotifyEvent;
    FFixedDateFormat: string; //used when DateOrder <> doNone
    FFreeDateFormat: string;  //used when DateOrder = doNone
    FDate: TDateTime;
    FUpdatingDate: boolean;
    Fautoselect: boolean;
    Fautoselected: boolean;
    FDirectInput: boolean;
    Fbuttonu: TOnGraphicControl;
    Freadonly: boolean;
    procedure SetFreeDateFormat(AValue: string);
    function TextToDate(AText: string; ADefault: TDateTime): TDateTime;
    function GetDate: TDateTime;
    function GetEditMask: string;
    procedure SetDate(Value: TDateTime);
    procedure CalendarPopupReturnDate(Sender: TObject; const ADate: TDateTime);
    procedure CalendarPopupShowHide(Sender: TObject);
    procedure SetDateOrder(const AValue: TDateOrder);
    function DateToText(Value: TDateTime): string;
    procedure SetEditMask(AValue: string);
    procedure SetSkindata(Aimg: TONImg);
    //    function GetEdit: TMaskEdit;
  protected
    //    function GetDefaultGlyphName: string; override;
    procedure ButtonClick(Sender: TObject);
    procedure EditDblClick(Sender: TObject);
    procedure EditEditingDone(Sender: TObject);
    //(sender:Tobject;var Key: Word; Shift: TShiftState);
    procedure SetDirectInput(AValue: boolean);
    procedure RealSetText(const AValue: TCaption); override;
    procedure SetDateMask; virtual;
    procedure Loaded; override;
    procedure SetReadonly(const Value: boolean);
    procedure Setautoselect(const Value: boolean);
    procedure Setautoselected(const Value: boolean);
    procedure Changefont(Sender: TObject);
    property EditMask: string read GetEditMask write SetEditMask;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;
    function GetDateFormat: string;

    property Date: TDateTime read GetDate write SetDate;
    property DroppedDown: boolean read FDroppedDown;
    procedure Paint override;

  published
    property CalendarDisplaySettings: TDisplaySettings
      read FDisplaySettings write FDisplaySettings;
    property OnAcceptDate: TAcceptDateEvent
      read FOnAcceptDAte write FOnAcceptDate;
    property OnCustomDate: TCustomDateEvent
      read FOnCustomDate write FOnCustomDate;
    property ReadOnly: boolean
      read Freadonly write Setreadonly;
    property AutoSelect: boolean
      read Fautoselect write Setautoselect;
    property AutoSelected: boolean
      read Fautoselected write Setautoselected;
    property DefaultToday: boolean
      read FDefaultToday write FDefaultToday default False;
    property DateOrder: TDateOrder
      read FDateOrder write SetDateOrder;
    property DateFormat: string
      read FFreeDateFormat write SetFreeDateFormat;
    property DirectInput: boolean
      read FDirectInput write SetDirectInput;
    property Edit: TMaskEdit
      read Fedit write Fedit;

    //    property OnEditingDone : TNotifyEvent read FOnEditEditingDone write FOnEditEditingDone;
    property ONLEFT        : TONCUSTOMCROP read FSol      write FSol;
    property ONRIGHT       : TONCUSTOMCROP read FSag      write FSag;
    property ONCENTER      : TONCUSTOMCROP read FOrta     write FOrta;
    property ONBOTTOM      : TONCUSTOMCROP read FAlt      write FAlt;
    property ONBOTTOMLEFT  : TONCUSTOMCROP read FSolalt   write FSolalt;
    property ONBOTTOMRIGHT : TONCUSTOMCROP read FSagalt   write FSagalt;
    property ONTOP         : TONCUSTOMCROP read FUst      write FUst;
    property ONTOPLEFT     : TONCUSTOMCROP read FSolust   write FSolust;
    property ONTOPRIGHT    : TONCUSTOMCROP read FSagust   write FSagust;
    property ONBUTTON      : TONCUSTOMCROP read Fbutton   write Fbutton;
    property Skindata      : TONImg        read FSkindata write SetSkindata;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Constraints;
    property DragMode;

    property Enabled;
    //    property FocusOnButtonClick;
    property Font;
    //    property Layout;
    //    property MaxLength;
    //    property OnButtonClick;
    //    property OnChange; override;
    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    //    property OnEditingDone;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property TabOrder;
    //    property Spacing;
    property Visible;
    property Text;
    //    property TextHint;
  end;


 TONListbox = class(TONControl)
  private
    FSol, FSolust, FSolalt, FSag, FSagust, FSagalt, FUst, FAlt, FOrta,Factiveitems: TONCUSTOMCROP;
//    FCaptionRect    : TRect;
    FItems          : TStringList;
    FItemsRect      : TList;
    FItemSpacing    : Byte;
    FActiveItem     : integer;
    FMouseInControl : Boolean;
    Fscrollvsbl     : Boolean;
    FOnItemChanged  : TNotifyEvent;
    FHScrollbar     : TONScrollBar;
    FVScrollbar     : TONScrollBar;
    procedure SetItems(Value: TStringList);
    procedure SetItemSpacing(Val: Byte);
    procedure SetActiveItem(Val: integer);
    procedure SetItemRect;
    procedure SetSkindata(Aimg: TONImg);
//    procedure CheckOthersPanels;
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ItemsChanged(Sender: TObject);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  published
    { Published declarations }
    property Items            : TStringList      read FItems         write SetItems;
    property ItemSpacing      : Byte             read FItemSpacing   write SetItemSpacing;
    property ActiveItem       : Integer          read FActiveItem    write SetActiveItem;
    property OnItemChanged    : TNotifyEvent     read FOnItemChanged write FOnItemChanged;
    property ONLEFT           : TONCUSTOMCROP    read FSol           write FSol;
    property ONRIGHT          : TONCUSTOMCROP    read FSag           write FSag;
    property ONCENTER         : TONCUSTOMCROP    read FOrta          write FOrta;
    property ONBOTTOM         : TONCUSTOMCROP    read FAlt           write FAlt;
    property ONBOTTOMLEFT     : TONCUSTOMCROP    read FSolalt        write FSolalt;
    property ONBOTTOMRIGHT    : TONCUSTOMCROP    read FSagalt        write FSagalt;
    property ONTOP            : TONCUSTOMCROP    read FUst           write FUst;
    property ONTOPLEFT        : TONCUSTOMCROP    read FSolust        write FSolust;
    property ONTOPRIGHT       : TONCUSTOMCROP    read FSagust        write FSagust;
    property ONACTIVEITEM     : TONCUSTOMCROP    read Factiveitems   write Factiveitems;
    property Skindata         : TONImg           read FSkindata      write SetSkindata;
//    property OnExpanded    : TONPanelExpanded read FOnExpanded    write FOnExpanded;
     property Align;
    property Alignment        : TAlignment       read FAlignment     write SetAlignment default taCenter;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Crop             : boolean         read Fcrop          write SetCrop      default False;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font             : TFont           read FFont          write SetFont      stored True;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;



  TOnPanelExpanded = procedure(Sender: TObject; Expanded: Boolean) of object;

  TOnPanelControl = class(TONGraphicControl)
  private
    { Private declarations }
    FCaptionRect    : TRect;
    FItems          : TStringList;
    FItemsRect      : TList;
    FItemSpacing    : Byte;
    FActiveItem     : SmallInt;
    FExpanded       : Boolean;
    FMouseInControl : Boolean;
    FOnItemChanged  : TNotifyEvent;
    FOnExpanded     : TOnPanelExpanded;
    procedure SetItems(Value: TStringList);
    procedure SetItemSpacing(Value: Byte);
    procedure SetActiveItem(Value: SmallInt);
    procedure SetCaption(Value: String);
    procedure SetItemRect;
    procedure SetPanelSize;
    procedure SetExpanded(Value: Boolean);
    procedure CheckOthersPanels;
    procedure SetSkindata(Aimg: TONImg);
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ItemsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  published
    { Published declarations }
    property Caption       : String           read FCaption       write SetCaption;
    property Items         : TStringList      read FItems         write SetItems;
    property ItemSpacing   : Byte             read FItemSpacing   write SetItemSpacing;
    property ActiveItem    : SmallInt         read FActiveItem    write SetActiveItem;
    property Expanded      : Boolean          read FExpanded      write SetExpanded;
    property OnItemChanged : TNotifyEvent     read FOnItemChanged write FOnItemChanged;
    property OnExpanded    : TONPanelExpanded read FOnExpanded    write FOnExpanded;
    property Skindata      : TONImg           read FSkindata      write SetSkindata;
  end;


const
   s_invalid_date = 'Invalid Date: ';
   s_invalid_integer = 'Invalid Integer';

//  s_invalid_date = 'Geçersiz Tarih: ';
//  s_invalid_integer = 'Geçersiz Sayı';
  NullDate: TDateTime = 0;

procedure Register;



implementation

uses CalendarPopup, BGRAPath, IniFiles;

procedure Register;
begin
  RegisterComponents('ONUR', [TONImg]);
  RegisterComponents('ONUR', [TONButton]);
  RegisterComponents('ONUR', [TONCropButton]);
  RegisterComponents('ONUR', [TONPANEL]);
  RegisterComponents('ONUR', [TOnCheckBox]);
  RegisterComponents('ONUR', [TOnRadioButton]);
  RegisterComponents('ONUR', [TONProgressBar]);
  RegisterComponents('ONUR', [TOnSwich]);
  RegisterComponents('ONUR', [TOnGroupBox]);
  RegisterComponents('ONUR', [TOnEdit]);
  RegisterComponents('ONUR', [TONCURREDIT]);
  RegisterComponents('ONUR', [TONDATEEDIT]);
  RegisterComponents('ONUR', [TOnMemo]);
  RegisterComponents('ONUR', [TONCOMBOBOX]);
  RegisterComponents('ONUR', [TONScrollBar]);
  RegisterComponents('ONUR', [TONListbox]);
  RegisterComponents('ONUR', [TOnPanelControl]);
end;

{
constructor TonPersistent.Create(AOwner: TPersistent);
begin
  inherited Create;
  owner := AOwner;
end;

destructor TonPersistent.Destroy;
begin
  inherited;
end;
}

procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);
var
  stl: TTextStyle;
begin
  //  PatBlt(TT.Handle, 0, 0, tt.ClipRect.Width, tt.ClipRect.Bottom,PATCOPY);
  //  tt.Clear;
  TT.Font.Quality := fqCleartype;
  TT.Font.Name := TF.Name;//'CALIBRI';
  TT.Font.Size := TF.size;
  TT.Font.Color := TF.Color;//$00FFC884;
  TT.Font.style := TF.style;//$00FFC884;
  TT.Brush.Style := bsClear;
  stl.Alignment := asd;
  stl.Wordbreak := True;
  stl.Layout := tlCenter;
  stl.SingleLine := False;
  //  tt.TextRect(RE,0,0,'',stl);
  TT.TextRect(RE, 0, 0, Fcap, stl);
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


procedure DrawPartstrech(ARect: TRect; hedef: TOnControl; w, h: integer);
var
  img: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    hedef.FSkindata.Fimage.Draw(hedef.Fresim.Canvas, 0, 0, False)
  else
  begin

    img := hedef.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      hedef.Fresim.ResampleFilter := rfBestQuality;
      //     hedef.Fresim:=img.Resample(w, h) as TBGRABitmap;
      img.ResampleFilter := rfBestQuality;
      BGRAReplace(hedef.Fresim, img.Resample(w, h, rmSimpleStretch));

      FreeAndNil(img);
    end;
  end;
end;


procedure DrawPartnormal(ARect: TRect; hedef: TOnControl; ATargetRect: TRect;
  Opaque: boolean);
var
  partial: TBGRACustomBitmap;
begin
  //  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Width) and (ARect.Bottom = Height) then
  //   hedef.FSkindata.Fimage.Draw(hedef.Canvas, ATargetRect, Opaque)
  //  else
{  begin
}    partial := hedef.FSkindata.Images.GetPart(ARect);
  if partial <> nil then
  begin
    partial.Draw(hedef.Fresim.Canvas, ATargetRect, Opaque);
    //      partial.Free;
    FreeAndNil(partial);
  end;
  //  end;
end;


procedure DrawPartstrech(ARect: TRect; hedef: TOnGraphicControl; w, h: integer);
var
  img: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    hedef.FSkindata.Fimage.Draw(hedef.Fresim.Canvas, 0, 0, False)
  else
  begin
    img := hedef.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      hedef.Fresim.ResampleFilter := rfBestQuality;
      //     hedef.Fresim:=img.Resample(w, h) as TBGRABitmap;
      img.ResampleFilter := rfBestQuality;
      BGRAReplace(hedef.Fresim, img.Resample(w, h, rmSimpleStretch));
      FreeAndNil(img);
    end;
  end;
end;


procedure DrawPartstrechRegion(ARect: TRect; hedef: TOnGraphicControl; w, h: integer;ATargetRect: TRect;Opaque: boolean);
var
  img: TBGRACustomBitmap;
  partial:TBGRACustomBitmap;//TBGRABitmap;
begin
  begin
    img := hedef.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      partial:=TBGRABitmap.Create(w,h);
//      partial.ResampleFilter := rfBestQuality;
//      BGRAReplace(partial, img.Resample(w, h, rmSimpleStretch));
      partial:=img.Resample(w, h) as TBGRABitmap;
      if partial <> nil then
      begin
        partial.Draw(hedef.Fresim.Canvas, ATargetRect, Opaque);
        FreeAndNil(partial);
      end;
      FreeAndNil(img);
    end;
  end;
end;


procedure DrawPartstrechRegion(ARect: TRect; hedef: TOnControl; w, h: integer;ATargetRect: TRect;Opaque: boolean);
var
  img: TBGRACustomBitmap;
  partial:TBGRACustomBitmap;//TBGRABitmap;
begin
  begin
    img := hedef.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      partial:=TBGRABitmap.Create(w,h);
//      partial.ResampleFilter := rfBestQuality;
//      BGRAReplace(partial, img.Resample(w, h, rmSimpleStretch));
      partial:=img.Resample(w, h) as TBGRABitmap;
      if partial <> nil then
      begin
        partial.Draw(hedef.Fresim.Canvas, ATargetRect, Opaque);
        FreeAndNil(partial);
      end;
      FreeAndNil(img);
    end;
  end;
end;


procedure DrawPartnormal(ARect: TRect; hedef: TOnGraphicControl;
  ATargetRect: TRect; Opaque: boolean);
var
  partial: TBGRACustomBitmap;
begin
  //  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Width) and (ARect.Bottom = Height) then
  //   hedef.FSkindata.Fimage.Draw(hedef.Canvas, ATargetRect, Opaque)
  //  else
{  begin
}    partial := hedef.FSkindata.Images.GetPart(ARect);
  if partial <> nil then
  begin
    partial.Draw(hedef.Fresim.Canvas, ATargetRect, Opaque);
    //      partial.Free;
    FreeAndNil(partial);
  end;
  //  end;
end;

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
  Fimage := TBGRABitmap.Create();
  FRes := TPicture.Create;
  Fres.OnChange := @ImageSet;
  Fimage.LoadFromResource('PANEL');
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

//85917
 
destructor TONImg.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FRes);
  FreeAndNil(List);
  inherited;
end;

procedure TONImg.ImageSet(Sender: TObject);
begin
  begin
    FreeAndNil(FImage);
    Fimage := TBGRABitmap.Create(Fres.Width, Fres.Height);
    Fimage.Assign(Fres.Bitmap);

  end;
end;
procedure cropRead(Crp:TONCUSTOMCROP;ini:TIniFile;isim:string);
begin
 Crp.OLEFT := StrToInt(trim(ini.ReadString(isim, crp.cropname+'.LEFT', '')));
 Crp.OTOP := StrToInt(trim(ini.ReadString(isim, crp.cropname+'.TOP', '')));
 Crp.OBOTTOM := StrToInt(trim(ini.ReadString(isim, crp.cropname+'.BOTTOM', '')));
 Crp.ORIGHT := StrToInt(trim(ini.ReadString(isim, crp.cropname+'.RIGHT', '')));
end;
procedure TONImg.ReadskinsComp(Com:TComponent);
var
  fil: TIniFile;
  memm: TMemoryStream;
  i: integer;
  isim: string;
begin
   try
      memm := TMemoryStream.Create;
      Try
        memm.Clear;
        List.SaveToStream(memm);
        memm.Position := 0;
        fil := TIniFile.Create(memm);
      finally
      FreeAndNil(memm);
      end;

      if Fimage.Empty=true then
       begin
       Fimage.LoadFromResource('PANEL');
//       Fimage.SaveToFile('C:\Users\onur.ercelen\Desktop\FIREBIRD2020\ress\test.png');
       end;
    //   fil.SetStrings(List);
    //formm:=(AOwner.GetParentComponent as TForm);

      with fil do
      begin

     //   for i := 0 to formm.ComponentCount - 1 do
     //   begin

          if (Com is TONPANEL) then
            with (TONPANEL(Com)) do
            begin
              CASE TAG OF
               0:isim := 'PANEL_FREE';
               1:isim := 'PANEL_MAIN';
               2:isim := 'PANEL_HEADER';
              end;
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

          if (Com is TONEDIT) then
            with (TONEDIT(com)) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Editi do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

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

          if (com is TONCURREDIT) then
            with (TONCURREDIT(com)) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Editi do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

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


          if (com is TONDATEEDIT) then
            with (TONDATEEDIT(com)) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Edit do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
              cropRead(ONBUTTON,fil,isim);

            end;

          if (com is TONCOMBOBOX) then
            with (TONCOMBOBOX(com)) do
            begin
              isim := 'COMBOBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Combobox do
              begin
               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];
              end;

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
              cropRead(ONBUTTON,fil,isim);
            end;

          if (com is TONMEMO) then
            with TONMEMO(com) do
            begin
              isim := 'MEMO';
            if Skindata=nil then
              Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
            with memoo do
            begin
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
            end;

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



          if (com is TONListbox) then
            with (TONListbox(com)) do
            begin
              isim := 'LISTBOX';
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
              cropRead(ONACTIVEITEM,fil,isim);
            end;




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

          if (com is TOnSwich) then
            with (TOnSwich(com)) do
            begin
              isim := 'SWICH';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFPRESSED,fil,isim);
            end;

          if (com is TOnCheckBox) then
            with (TOnCheckBox(com)) do
            begin
              isim := 'CHECKBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFCHECK,fil,isim);
            end;

          if (com is TOnRadioButton) then
            with (TOnRadioButton(com)) do
            begin
              isim := 'RADIOBUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFCHECK,fil,isim);
            end;





           if (com is TONScrollBar) then
            with (TONScrollBar(com)) do
             begin
              if State=Fhorizontal then
                isim := 'SCROLLBAR_H'
               else
                isim := 'SCROLLBAR_V';
               if Skindata=nil then
                 Skindata := Self;

               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];

               if State=Fhorizontal then
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONLEFT,fil,isim);
                 cropRead(ONRIGHT,fil,isim);
                 cropRead(ONBAR,fil,isim);
                 cropRead(FbuttonNL,fil,isim);
                 cropRead(FbuttonUL,fil,isim);
                 cropRead(FbuttonBL,fil,isim);
                 cropRead(FbuttonDL,fil,isim);
                 cropRead(FbuttonNR,fil,isim);
                 cropRead(FbuttonUR,fil,isim);
                 cropRead(FbuttonBR,fil,isim);
                 cropRead(FbuttonDR,fil,isim);

                 cropRead(FbuttonCN,fil,isim);
                 cropRead(FbuttonCU,fil,isim);
                 cropRead(FbuttonCB,fil,isim);
                 cropRead(FbuttonCD,fil,isim);
               end else
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONTOP,fil,isim);
                 cropRead(ONBOTTOM,fil,isim);
                 cropRead(ONBAR,fil,isim);
                 cropRead(FbuttonNL,fil,isim);
                 cropRead(FbuttonUL,fil,isim);
                 cropRead(FbuttonBL,fil,isim);
                 cropRead(FbuttonDL,fil,isim);
                 cropRead(FbuttonNR,fil,isim);
                 cropRead(FbuttonUR,fil,isim);
                 cropRead(FbuttonBR,fil,isim);
                 cropRead(FbuttonDR,fil,isim);
                 cropRead(FbuttonCN,fil,isim);
                 cropRead(FbuttonCU,fil,isim);
                 cropRead(FbuttonCB,fil,isim);
                 cropRead(FbuttonCD,fil,isim);
               end;
            end;


          if (com is TONProgressBar) then
            with (TONProgressBar(com)) do
             begin
              if State=Fhorizontal then
                isim := 'PROGRESSBAR_H'
               else
                isim := 'PROGRESSBAR_V';
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];

               if State=Fhorizontal then
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONLEFT,fil,isim);
                 cropRead(ONRIGHT,fil,isim);
                 cropRead(ONBAR,fil,isim);
               end else
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONTOP,fil,isim);
                 cropRead(ONBOTTOM,fil,isim);
                 cropRead(ONBAR,fil,isim);
               end;
            end;

          if (com is TOnButton) then
            with (TOnButton(com)) do
            begin
              isim := 'BUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONHOVER,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIF,fil,isim);

            end;


          if (com is TONCropButton) then
            with (TONCropButton(com)) do
            begin
              isim := 'BUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONHOVER,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIF,fil,isim);
            end;
        end;
     // end;
    finally
    FreeAndNil(fil);
  end;

end;



procedure TONImg.Readskins(formm: TForm);
var
  fil: TIniFile;
  memm: TMemoryStream;
  i: integer;
  isim: string;
begin
    try
      memm := TMemoryStream.Create;
      Try
        memm.Clear;
        List.SaveToStream(memm);
        memm.Position := 0;
        fil := TIniFile.Create(memm);
      finally
      FreeAndNil(memm);
      end;

      if Fimage.Empty=true then
       begin
       Fimage.LoadFromResource('PANEL');
//       Fimage.SaveToFile('C:\Users\onur.ercelen\Desktop\FIREBIRD2020\ress\test.png');
       end;
    //   fil.SetStrings(List);
    //formm:=(AOwner.GetParentComponent as TForm);

      with fil do
      begin

        for i := 0 to formm.ComponentCount - 1 do
        begin

          if (formm.Components[i] is TONPANEL) then
            with (TONPANEL(formm.Components[i])) do
            begin
              CASE TAG OF
               0:isim := 'PANEL_FREE';
               1:isim := 'PANEL_MAIN';
               2:isim := 'PANEL_HEADER';
              end;
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

          if (formm.Components[i] is TONEDIT) then
            with (TONEDIT(formm.Components[i])) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Editi do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

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

          if (formm.Components[i] is TONCURREDIT) then
            with (TONCURREDIT(formm.Components[i])) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Editi do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

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


          if (formm.Components[i] is TONDATEEDIT) then
            with (TONDATEEDIT(formm.Components[i])) do
            begin
              isim := 'EDIT';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Edit do
              begin
                Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
                Font.Name := ReadString(isim, 'Fontname', 'Calibri');
                Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
                Font.Style := [fsBold];
              end;

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
              cropRead(ONBUTTON,fil,isim);

            end;

          if (formm.Components[i] is TONCOMBOBOX) then
            with (TONCOMBOBOX(formm.Components[i])) do
            begin
              isim := 'COMBOBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
              with Combobox do
              begin
               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];
              end;

              cropRead(ONTOP,fil,isim);
              cropRead(ONBOTTOM,fil,isim);
              cropRead(ONLEFT,fil,isim);
              cropRead(ONRIGHT,fil,isim);
              cropRead(ONTOPLEFT,fil,isim);
              cropRead(ONTOPRIGHT,fil,isim);
              cropRead(ONCENTER,fil,isim);
              cropRead(ONBOTTOMLEFT,fil,isim);
              cropRead(ONBOTTOMRIGHT,fil,isim);
              cropRead(ONBUTTON,fil,isim);
            end;

          if (formm.Components[i] is TONMEMO) then
            with TONMEMO(formm.Components[i]) do
            begin
              isim := 'MEMO';
            if Skindata=nil then
              Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
            with memoo do
            begin
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];
            end;

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



          if (formm.Components[i] is TONListbox) then
            with (TONListbox(formm.Components[i])) do
            begin
              isim := 'LISTBOX';
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
              cropRead(ONACTIVEITEM,fil,isim);
            end;




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

          if (formm.Components[i] is TOnSwich) then
            with (TOnSwich(formm.Components[i])) do
            begin
              isim := 'SWICH';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFPRESSED,fil,isim);
            end;

          if (formm.Components[i] is TOnCheckBox) then
            with (TOnCheckBox(formm.Components[i])) do
            begin
              isim := 'CHECKBOX';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFCHECK,fil,isim);
            end;

          if (formm.Components[i] is TOnRadioButton) then
            with (TOnRadioButton(formm.Components[i])) do
            begin
              isim := 'RADIOBUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIFNORMAL,fil,isim);
              cropRead(ONPASIFCHECK,fil,isim);
            end;





           if (formm.Components[i] is TONScrollBar) then
            with (TONScrollBar(formm.Components[i])) do
             begin
              if State=Fhorizontal then
                isim := 'SCROLLBAR_H'
               else
                isim := 'SCROLLBAR_V';
               if Skindata=nil then
                 Skindata := Self;

               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];

               if State=Fhorizontal then
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONLEFT,fil,isim);
                 cropRead(ONRIGHT,fil,isim);
                 cropRead(ONBAR,fil,isim);
                 cropRead(FbuttonNL,fil,isim);
                 cropRead(FbuttonUL,fil,isim);
                 cropRead(FbuttonBL,fil,isim);
                 cropRead(FbuttonDL,fil,isim);
                 cropRead(FbuttonNR,fil,isim);
                 cropRead(FbuttonUR,fil,isim);
                 cropRead(FbuttonBR,fil,isim);
                 cropRead(FbuttonDR,fil,isim);

                 cropRead(FbuttonCN,fil,isim);
                 cropRead(FbuttonCU,fil,isim);
                 cropRead(FbuttonCB,fil,isim);
                 cropRead(FbuttonCD,fil,isim);
               end else
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONTOP,fil,isim);
                 cropRead(ONBOTTOM,fil,isim);
                 cropRead(ONBAR,fil,isim);
                 cropRead(FbuttonNL,fil,isim);
                 cropRead(FbuttonUL,fil,isim);
                 cropRead(FbuttonBL,fil,isim);
                 cropRead(FbuttonDL,fil,isim);
                 cropRead(FbuttonNR,fil,isim);
                 cropRead(FbuttonUR,fil,isim);
                 cropRead(FbuttonBR,fil,isim);
                 cropRead(FbuttonDR,fil,isim);
                 cropRead(FbuttonCN,fil,isim);
                 cropRead(FbuttonCU,fil,isim);
                 cropRead(FbuttonCB,fil,isim);
                 cropRead(FbuttonCD,fil,isim);
               end;
            end;


          if (formm.Components[i] is TONProgressBar) then
            with (TONProgressBar(formm.Components[i])) do
             begin
              if State=Fhorizontal then
                isim := 'PROGRESSBAR_H'
               else
                isim := 'PROGRESSBAR_V';
               if Skindata=nil then
                 Skindata := Self;
               Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
               Font.Name := ReadString(isim, 'Fontname', 'Calibri');
               Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
               Font.Style := [fsBold];

               if State=Fhorizontal then
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONLEFT,fil,isim);
                 cropRead(ONRIGHT,fil,isim);
                 cropRead(ONBAR,fil,isim);
               end else
               begin
                 cropRead(ONNORMAL,fil,isim);
                 cropRead(ONTOP,fil,isim);
                 cropRead(ONBOTTOM,fil,isim);
                 cropRead(ONBAR,fil,isim);
               end;
            end;

          if (formm.Components[i] is TOnButton) then
            with (TOnButton(formm.Components[i])) do
            begin
              isim := 'BUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONHOVER,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIF,fil,isim);

            end;


          if (formm.Components[i] is TONCropButton) then
            with (TONCropButton(formm.Components[i])) do
            begin
              isim := 'BUTTON';
              if Skindata=nil then
                Skindata := Self;
              Font.Color := StringToColor(ReadString(isim, 'Fontcolor', 'clBlack'));
              Font.Name := ReadString(isim, 'Fontname', 'Calibri');
              Font.Size := StrToInt(ReadString(isim, 'Fontsize', '10'));
              Font.Style := [fsBold];

              cropRead(ONNORMAL,fil,isim);
              cropRead(ONHOVER,fil,isim);
              cropRead(ONPRESSED,fil,isim);
              cropRead(ONPASIF,fil,isim);
            end;
        end;
      end;
    finally
    FreeAndNil(fil);
  end;

end;





// -----------------------------------------------------------------------------
{ TOnGraphicControl }
// -----------------------------------------------------------------------------


constructor TOnGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground];
  Width := 100;
  Height := 30;
  Fresim := TBGRABitmap.Create;//(Width, Height,BGRABlack);
  FAlignment := taCenter;
  WindowRgn := CreateRectRgn(0, 0, self.Width, self.Height);
  Transparent := True;
  FFont := TFont.Create;
  with FFont do
  begin
    Name := 'calibri';
    size := 10;
    color := clBlack;
    style := [fsBold];
  end;
end;

destructor TOnGraphicControl.Destroy;
begin
//  Skindata:=nil;
  FreeAndNil(FFont);
  FreeAndNil(Fresim);
  DeleteObject(WindowRgn);
  inherited;
end;


// -----------------------------------------------------------------------------
procedure TOnGraphicControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

procedure TOnGraphicControl.MouseEnter;
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

// -----------------------------------------------------------------------------

procedure TOnGraphicControl.MouseLeave;
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

// -----------------------------------------------------------------------------

procedure TOnGraphicControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  MouseEnter;
end;

// -----------------------------------------------------------------------------

procedure TOnGraphicControl.CMMouseLeave(var Message: TMessage);
begin
  MouseLeave;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure TOnGraphicControl.SetCaption(Value: string);
begin
  if Value <> FCaption then
  begin
    FCaption := Value;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TOnGraphicControl.CreateParams(var Params: TCreateParams);
begin
  inherited;// CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TOnGraphicControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------
procedure TOnGraphicControl.SetCrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;
// -----------------------------------------------------------------------------
procedure TOnGraphicControl.Setfont(const Value: TFont);
begin
  if FFont <> Value then
  begin
    FFont.Assign(Value);
  end;
end;
// -----------------------------------------------------------------------------
function TOnGraphicControl.GetTransparent: boolean;
begin
  Result := Color = clNone;
end;

procedure TOnGraphicControl.SetTransparent(NewTransparent: boolean);
begin
  if Transparent = NewTransparent then
    exit;
  if NewTransparent = True then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

procedure TOnGraphicControl.CropToimg(buffer: TBGRABitmap);
var
  x, y: integer;
  hdc, SpanRgn: integer;
  AControl: TControl;
begin
  //    Transparent:=true;//(Self, True);

  //    hdc:=GetDC(self.Canvas.Handle);// self.Handle);
{    if (AControl is TWinControl) or (AControl is TGraphicControl) then
    with AControl do
    begin
    WindowRgn := CreateRectRgn(0,0,buffer.Width,buffer.Height);
    Premultiply(buffer);
      for x := 1 to buffer.Bitmap.Width do
      begin
         for y := 1 to buffer.Bitmap.Height do
         begin
           if (buffer.GetPixel(x-1, y-1)=BGRAPixelTransparent) then
           begin
              SpanRgn :=CreateRectRgn(x-1,y-1,x,y);
              CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
              DeleteObject(SpanRgn);
           end;
         end;
      end;
    buffer.InvalidateBitmap;

    }
  //    Color:=clNone;
  //    Transparent:=True;
  //    SetWindowRgn(self.Canvas.Handle,RegionFromBGRABitmap(buffer),true);// WindowRgn, True);


  //    ReleaseDC(self.Canvas.Handle,hdc);
  //    DeleteObject(WindowRgn);
  //    DeleteObject(hdc);

end;

//  end;

// -----------------------------------------------------------------------------
procedure TOnGraphicControl.Paint;
var
  re: Trect;
begin
  inherited Paint;
  if (Fresim <> nil) then
  begin
    if (self is TOnCheckBox) or (self is TOnRadioButton) then
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
    begin
      Fresim.Draw(self.canvas, 0, 0, False);
      re := self.ClientRect;
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
    Fresim.Draw(self.canvas, 0, 0, False);
  end;

  yaziyaz(self.Canvas, self.Font, re, FCaption, Alignment);

end;
// -----------------------------------------------------------------------------




// -----------------------------------------------------------------------------
{ TONControl }
// -----------------------------------------------------------------------------


constructor TONControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground];
  Width := 100;
  Height := 30;
  Fresim := TBGRABitmap.Create;//(Width, Height,BGRABlack);
  FAlignment := taCenter;
  ParentBackground := True;
  WindowRgn := CreateRectRgn(0, 0, self.Width, self.Height);

  FFont := TFont.Create;
  with FFont do
  begin
    Name := 'calibri';
    size := 10;
    color := clBlack;
    style := [fsBold];
  end;
end;

destructor TONControl.Destroy;
begin
 // Skindata:=nil;
  FreeAndNil(FFont);
  FreeAndNil(Fresim);
  DeleteObject(WindowRgn);
  inherited;
end;


// -----------------------------------------------------------------------------
procedure TONControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------
procedure TONControl.SetCaption(Value: string);
begin
  if Value <> FCaption then
  begin
    FCaption := Value;
  end;
end;
// -----------------------------------------------------------------------------
{
procedure TONControl.SetSkindata(Aimg: TONImg);
begin
//  if Aimg <> nil then
//  begin
    FSkindata := Aimg;
    Paint;
 // end;
end;
}
// -----------------------------------------------------------------------------
procedure TONControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------
procedure TONControl.SetCrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;
// -----------------------------------------------------------------------------
procedure TONControl.Setfont(Value: TFont);
begin
  if FFont <> Value then
  begin
    FFont.Assign(Value);
  end;
end;
// -----------------------------------------------------------------------------
procedure TONControl.CropToimg(buffer: TBGRABitmap);
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

  //       SetWindowRgn(self.Handle,RegionFromBGRABitmap(buffer),true);
end;
// -----------------------------------------------------------------------------
procedure TONControl.Paint;
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
  if not (self is TOnGroupBox) then
  yaziyaz(self.Canvas, self.Font, re, FCaption, Alignment);

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
 FUST.cropname:='TOP';
 FAlt := TONCUSTOMCROP.Create;
 FAlt.cropname:='BOTTOM';
 FOrta := TONCUSTOMCROP.Create;
 FOrta.cropname:='CENTER';
 FSag := TONCUSTOMCROP.Create;
 FSag.cropname:='RIGHT';
 FSagust := TONCUSTOMCROP.Create;
 FSagust.cropname:='TOPRIGHT';
 FSagalt := TONCUSTOMCROP.Create;
 FSagalt.cropname:='BOTTOMRIGHT';
 FSol := TONCUSTOMCROP.Create;
 FSol.cropname:='LEFT';
 FSolust := TONCUSTOMCROP.Create;
 FSolust.cropname:='TOPLEFT';
 FSolalt := TONCUSTOMCROP.Create;
 FSolalt.cropname:='BOTTOMLEFT';
//     Self.Height := 190;
//     Self.Width := 190;
//     Fresim.SetSize(Width, Height);
end;

destructor TONFrom.Destroy;
begin
inherited;
end;

procedure TONFrom.SetSkindata(Aimg: TONImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
//    Paint;
  end else
  begin
  FSkindata:=nil;
  end;
end;
procedure TONFrom.Readskins(formm: TForm);
begin
end;
//procedure TONFrom.paint;
//begin
//end;
// -----------------------------------------------------------------------------

{ TONPanel }

// -----------------------------------------------------------------------------

constructor TONPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle    := ControlStyle + [csAcceptsControls, csParentBackground,
    csClickEvents, csCaptureMouse, csDoubleClicks];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  FUst             := TONCUSTOMCROP.Create;
  FUST.cropname    := 'TOP';
  FAlt             := TONCUSTOMCROP.Create;
  FAlt.cropname    := 'BOTTOM';
  FOrta            := TONCUSTOMCROP.Create;
  FOrta.cropname   := 'CENTER';
  FSag             := TONCUSTOMCROP.Create;
  FSag.cropname    := 'RIGHT';
  FSagust          := TONCUSTOMCROP.Create;
  FSagust.cropname := 'TOPRIGHT';
  FSagalt          := TONCUSTOMCROP.Create;
  FSagalt.cropname := 'BOTTOMRIGHT';
  FSol             := TONCUSTOMCROP.Create;
  FSol.cropname    := 'LEFT';
  FSolust          := TONCUSTOMCROP.Create;
  FSolust.cropname := 'TOPLEFT';
  FSolalt          := TONCUSTOMCROP.Create;
  FSolalt.cropname := 'BOTTOMLEFT';
  Self.Height      := 190;
  Self.Width       := 190;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------
destructor TONPanel.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  inherited;
end;
// -----------------------------------------------------------------------------
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
procedure TONPanel.paint;
var
  HEDEF, KAYNAK: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

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
  inherited;
end;


//-----------------------------------------------------------------------------

{TONMEMO}

//-----------------------------------------------------------------------------


constructor TONMEMO.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csCaptureMouse, csDoubleClicks];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }

  FUst := TONCUSTOMCROP.Create;
  FUST.cropname:='TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname:='BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname:='CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname:='RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname:='TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname:='BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname:='LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname:='TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname:='BOTTOMLEFT';

  Self.Height := 40;
  Self.Width := 100;
  Fresim.SetSize(Width, Height);
  fmemo := Tmemo.Create(self);
  fmemo.parent := Self;
  fmemo.Align:=alClient;
  // fmemo.AutoSize:=true;
  fmemo.Left := 5;
  fmemo.Top := 5;
  fmemo.Width := Width - 5;
  fmemo.Height := Height - 5;
  fmemo.Color := Fresim.GetPixel(0, 0).ToColor;
  fmemo.Font.Name := Self.Font.Name;
  fmemo.Font.Size := Self.Font.Size;
  fmemo.Font.Color := Self.Font.Color;
  fmemo.Font.Style := Self.Font.Style;
  fmemo.BorderStyle := bsNone;
  fmemo.SetSubComponent(True);
  fmemo.Name := self.Name + 'SubMEMO';
  fmemo.Text := '';
end;


// -----------------------------------------------------------------------------
destructor TONMEMO.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(fmemo);
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONMEMO.SetSkindata(Aimg: TONImg);
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

procedure TONMEMO.paint;
var
  HEDEF, KAYNAK: TRect;

begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SOL ÜST TOPLEFT
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);
      fmemo.Color := FSkindata.Images.GetPixel(FOrta.FSLeft, FOrta.FSTop).ToColor;


      if Crop then
        CropToimg(Fresim);

      fmemo.BorderStyle := bsnone;
      fmemo.Width := self.Width - ((FSag.FSRight - FSag.FSLeft) + (FSol.FSRight - FSol.FSLeft));
      fmemo.Height := self.Height - ((FUst.FSBottom - FUst.FSTop) + (FAlt.FSBottom - FAlt.FSTop));
      fmemo.Left := FSol.FSRight - FSol.FSLeft;
      fmemo.Top := Round(((self.Height div 2) - (fmemo.Height div 2)));// div 2);
    finally

    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;




// -----------------------------------------------------------------------------

{ TONCOMBOBOX }

// -----------------------------------------------------------------------------

constructor TONCOMBOBOX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  FUst := TONCUSTOMCROP.Create;
  FUST.cropname:='TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname:='BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname:='CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname:='RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname:='TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname:='BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname:='LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname:='TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname:='BOTTOMLEFT';
  Fbuton := TONCUSTOMCROP.Create;
  Fbuton.cropname:='BUTTON';

  Self.Height := 40;
  Self.Width := 100;
  Fresim.SetSize(Width, Height);
  Fcombo := TOnComboBoxe.Create(self);
  Fcombo.parent := Self;
  Fcombo.SetSubComponent(True);
  Fcombo.Name := self.Name + 'Subcombo';
  Fcombo.BorderStyle := bsNone;
  Fcombo.BorderWidth := 0;
  Fcombo.Align := alClient;
  ChildSizing.VerticalSpacing := 5;
  ChildSizing.HorizontalSpacing := 8;
end;


// -----------------------------------------------------------------------------
destructor TONCOMBOBOX.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(Fbuton);

  FreeAndNil(Fcombo);
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONCOMBOBOX.SetSkindata(Aimg: TONImg);
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
procedure TONCOMBOBOX.paint;
var
  HEDEF, KAYNAK: TRect;
  img: TBGRABitmap;
  C: TControlCanvas;
  R: TRect;
  X: integer;

begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));

      DrawPartnormal(KAYNAK, self, HEDEF, False);
      fcombo.Color := FSkindata.Images.GetPixel(FOrta.FSLeft, FOrta.FSTop).ToColor;




      //buton image
      KAYNAK := Rect(Fbuton.FSLeft, Fbuton.FSTop, Fbuton.FSRight, Fbuton.FSBottom);
      img := TBGRABitmap.Create;
      img := FSkindata.Images.GetPart(KAYNAK);
      Fcombo.Butonimage.Assign(img);
//      img.SaveToFile('C:\Users\onur.ercelen\Desktop\FIREBIRD2020\ress\but.png');
       FreeAndNil(img);






      if Crop then
        CropToimg(Fresim);

      Fcombo.Width := self.Width - ((FSag.FSRight - FSag.FSLeft) + (FSol.FSRight - FSol.FSLeft));
      Fcombo.Height := self.Height - ((FUst.FSBottom - FUst.FSTop) + (FAlt.FSBottom - FAlt.FSTop));
      Fcombo.Left := FSol.FSRight - FSol.FSLeft;
      Fcombo.Top := Round((self.Height div 2) - (fcombo.Height div 2));

      ChildSizing.LeftRightSpacing := (FSag.FSRight - FSag.FSLeft);
      ChildSizing.TopBottomSpacing := (FUst.FSBottom - FUst.FSTop);

    finally
      if img <> nil then
        FreeAndNil(img);
    end;
  end
  else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;




// -----------------------------------------------------------------------------

{ TONEDIT }

// -----------------------------------------------------------------------------


constructor TONEDIT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents,
    csRequiresKeyboardInput];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  FUst := TONCUSTOMCROP.Create;
  FUST.cropname:='TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname:='BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname:='CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname:='RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname:='TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname:='BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname:='LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname:='TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname:='BOTTOMLEFT';
  TabStop := True;
  BorderStyle := bsNone;
  FAutoSelect := True;
  FAutoSelected := False;
  Freadonly := False;
  Self.Height := 40;
  Self.Width := 100;
  Fresim.SetSize(Width, Height);
  fedit := TEdit.Create(self);
  fedit.parent := Self;
  fedit.SetSubComponent(True);
  fedit.Name := self.Name + 'Subedit';
  fedit.AutoSize := True;
  fedit.BorderStyle := bsNone;
  fedit.BorderWidth := 0;
  fedit.Align := alClient;
  fedit.Text := '';
  ChildSizing.VerticalSpacing := 5;
  ChildSizing.HorizontalSpacing := 4;

end;


// -----------------------------------------------------------------------------
destructor TONEDIT.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(fedit);
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONEDIT.SetSkindata(Aimg: TONImg);
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

procedure TONEDIT.Clear;
begin
  Fedit.Text := '';
end;


procedure TONEDIT.SelectAll;
begin
  if Fedit.Text <> '' then
  begin
    Fedit.SelectAll;
  end;
end;

procedure TONEDIT.SetReadOnly(Value: boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    Fedit.ReadOnly := Value;
  end;
end;



procedure TONEDIT.paint;
var
  HEDEF, KAYNAK: TRect;
  //  img:TBGRABitmap;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      FSkindata.Images.DrawPart(KAYNAK, Fresim.Canvas, HEDEF, False);



      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));

      DrawPartnormal(KAYNAK, self, HEDEF, False);
      fedit.Color := FSkindata.Images.GetPixel(FOrta.FSLeft, FOrta.FSTop).ToColor;

      if Crop then
        CropToimg(Fresim);

      {
      fedit.BorderStyle:=bsNone;
      fedit.Width:=self.Width-((FSag.FSRight-FSag.FSLeft)+(FSol.FSRight-FSol.FSLeft));
      fedit.Height:=self.Height-((FUst.FSBottom-FUst.FSTop)+(FAlt.FSBottom-FAlt.FSTop));
      fedit.Left:= FSol.FSRight-FSol.FSLeft;
      fedit.Top:=Round((self.Height div 2)-(fedit.Height div 2));
      }
      ChildSizing.LeftRightSpacing := (FSag.FSRight - FSag.FSLeft);
      ChildSizing.TopBottomSpacing := (FUst.FSBottom - FUst.FSTop);
    finally
      //  if img<>nil then
      //  FreeAndNil(img);
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;




// -----------------------------------------------------------------------------

{ TONCURREDIT }

// -----------------------------------------------------------------------------

constructor TONCURREDIT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  FUst               := TONCUSTOMCROP.Create;
  FUST.cropname      := 'TOP';
  FAlt               := TONCUSTOMCROP.Create;
  FAlt.cropname      := 'BOTTOM';
  FOrta              := TONCUSTOMCROP.Create;
  FOrta.cropname     := 'CENTER';
  FSag               := TONCUSTOMCROP.Create;
  FSag.cropname      := 'RIGHT';
  FSagust            := TONCUSTOMCROP.Create;
  FSagust.cropname   := 'TOPRIGHT';
  FSagalt            := TONCUSTOMCROP.Create;
  FSagalt.cropname   := 'BOTTOMRIGHT';
  FSol               := TONCUSTOMCROP.Create;
  FSol.cropname      := 'LEFT';
  FSolust            := TONCUSTOMCROP.Create;
  FSolust.cropname   := 'TOPLEFT';
  FSolalt            := TONCUSTOMCROP.Create;
  FSolalt.cropname   := 'BOTTOMLEFT';
  Self.Height        := 40;
  Self.Width         := 100;
  Fresim.SetSize(Width, Height);
  fedit              := TOnCurrencyEdit.Create(self);
  fedit.parent       := Self;
  fedit.AutoSize     := True;
  fedit.BorderStyle  := bsnone;
  fedit.BorderWidth  := 0;
  fedit.SetSubComponent(True);
  fedit.Name         := self.Name + 'Subcurredit';
  fedit.Align        := alClient;
  ChildSizing.VerticalSpacing := 5;
  ChildSizing.HorizontalSpacing := 4;
end;

// -----------------------------------------------------------------------------
destructor TONCURREDIT.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(fedit);
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONCURREDIT.SetSkindata(Aimg: TONImg);
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

procedure TONCURREDIT.paint;
var
  HEDEF, KAYNAK: TRect;
  //  img:TBGRABitmap;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(kaynak, self, hedef, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(kaynak, self, hedef, False);

      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(kaynak, self, hedef, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      DrawPartnormal(kaynak, self, hedef, False);


      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(kaynak, self, hedef, False);

      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(kaynak, self, hedef, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(kaynak, self, hedef, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(kaynak, self, hedef, False);


      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));
      DrawPartnormal(kaynak, self, hedef, False);
      fedit.Color := FSkindata.Images.GetPixel(FOrta.FSLeft, FOrta.FSTop);

      if Crop then
        CropToimg(Fresim);


     { fedit.BorderStyle:=bsNone;
      fedit.Width:=self.Width-((FSag.FSRight-FSag.FSLeft)+(FSol.FSRight-FSol.FSLeft));
      fedit.Height:=self.Height-((FUst.FSBottom-FUst.FSTop)+(FAlt.FSBottom-FAlt.FSTop));
      fedit.Left:= FSol.FSRight-FSol.FSLeft;
      fedit.Top:=Round((self.Height div 2)-(fedit.Height div 2));}
      ChildSizing.LeftRightSpacing := (FSag.FSRight - FSag.FSLeft);
      ChildSizing.TopBottomSpacing := (FUst.FSBottom - FUst.FSTop);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

{ TONGroupbox }

// -----------------------------------------------------------------------------

constructor TOnGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  FUst := TONCUSTOMCROP.Create;
  FUST.cropname:='TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname:='BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname:='CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname:='RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname:='TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname:='BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname:='LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname:='TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname:='BOTTOMLEFT';


  Self.Height := 190;
  Self.Width := 190;
  Fresim.SetSize(Width, Height);
  fbordercolor := clScrollBar;//clBlack;
  FborderWidth := 2;
  ChildSizing.VerticalSpacing := 5;
  ChildSizing.HorizontalSpacing := 4;
end;

destructor TOnGroupBox.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  inherited;
end;

procedure TOnGroupBox.SetSkindata(Aimg: TONImg);
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

procedure TOnGroupBox.paint;
var
  HEDEF, KAYNAK: TRect;
  //  img:TBGRABitmap;
  path: TBGRAPath;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(KAYNAK, self, HEDEF, False);


      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);

      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));
      DrawPartnormal(KAYNAK, self, HEDEF, False);
    {  if Crop then
        CropToimg(Fresim); }
      //  Fresim.TextStyle.Clipping:=true;
      with Fresim do
      begin
        FontStyle := Self.Font.Style;
        FontName := self.Font.Name;
        FontHeight := self.Font.Height;//.Canvas.te Font.Height;
        FontAntialias := True;
        FontQuality := fqFineAntialiasing;
        TextOut((FSol.FSRight - FSol.FSLeft) + 2, FUst.FSBottom - FUst.FSTop, FCaption, self.Font.Color);
      end;

      path := TBGRAPath.Create;

      // captionleft
      path.moveTo(0, (FUst.FSBottom - FUst.FSTop) + ((FUst.FSBottom - FUst.FSTop) div 2));
      path.lineto(FSol.FSRight - FSol.FSLeft, (FUst.FSBottom - FUst.FSTop) +
        ((FUst.FSBottom - FUst.FSTop) div 2));

      // captionright
      path.moveTo(canvas.TextWidth(FCaption) - (FborderWidth + FSol.FSRight - FSol.FSLeft),
        (FUst.FSBottom - FUst.FSTop) + ((FUst.FSBottom - FUst.FSTop) div 2));
      //canvas.TextWidth(FCaption)+2,5);
      path.lineTo(self.Width - FborderWidth, (FUst.FSBottom - FUst.FSTop) +
        ((FUst.FSBottom - FUst.FSTop) div 2));

      //left
      path.moveTo(self.Width - FborderWidth, (FUst.FSBottom - FUst.FSTop) +
        ((FUst.FSBottom - FUst.FSTop) div 2));
      path.lineTo(self.Width - FborderWidth, self.Height - FborderWidth);
      //right
      path.moveTo(0, (FUst.FSBottom - FUst.FSTop) + ((FUst.FSBottom - FUst.FSTop) div 2));
      path.lineTo(0, self.Height - FborderWidth);

      // bottom
      path.moveTo(0, self.Height - FborderWidth);
      path.lineTo(self.Width - FborderWidth, self.Height - FborderWidth);

      path.closePath;
      path.stroke(fresim, fbordercolor, FborderWidth);
//      path.Free;

      ChildSizing.LeftRightSpacing := (FSag.FSRight - FSag.FSLeft);
      ChildSizing.TopBottomSpacing := (FUst.FSBottom - FUst.FSTop);

    finally
        FreeAndNil(path);
    end;
  end else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;

  inherited;
end;


// -----------------------------------------------------------------------------

{ TONCropButton }

// -----------------------------------------------------------------------------
constructor TONCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  FBasili := TONCUSTOMCROP.Create;
  FBasili.cropname:='CLICK';
  FUzerinde := TONCUSTOMCROP.Create;
  FUzerinde.cropname:='HOVER';
  FPasif := TONCUSTOMCROP.Create;
  FPasif.cropname:='PASSIVE';
  FCaption := 'OnGraphicButton';
  FDurum := bsNormal;
  Parent := AOwner as TWinControl;
  Width := 100;
  Height := 30;
  Fcrop := True;
  ControlStyle := ControlStyle + [csClickEvents, csDoubleClicks, csCaptureMouse];
  FAutoWidth := True;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------

destructor TONCropButton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FBasili);
  FreeAndNil(FUzerinde);
  FreeAndNil(FPasif);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONCropButton.SetSkindata(Aimg: TONImg);
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
        case FDurum of
          bsNormal: DR := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
          bspressed: DR := Rect(FBasili.FSLeft, FBasili.FSTop,
              FBasili.FSRight, FBasili.FSBottom);
          bshover: DR := Rect(FUzerinde.FSLeft, FUzerinde.FSTop,
              FUzerinde.FSRight, FUzerinde.FSBottom);
        end;
      end
      else
      begin
        DR := Rect(FPasif.FSLeft, FPasif.FSTop, FPasif.FSRight, FPasif.FSBottom);
      end;
//      HEDEF := Rect(0, 0, self.Width, self.Height);
//      DrawPartstrechRegion(DR,Self,Width,Height,HEDEF,false);
      DrawPartstrech(DR, self, Width, Height);

      if Crop = True then
        CropToimg(Fresim);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;


// -----------------------------------------------------------------------------
procedure TONCropButton.MouseMove(Shift: TShiftState; X: integer; Y: integer);
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bshover then
    Exit;

  FDurum := bshover;
  Paint;
  inherited  MouseMove(Shift, X, Y);
end;
// -----------------------------------------------------------------------------

procedure TONCropButton.MouseLeave;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bsnormal then
    Exit;
  FDurum := bsnormal;
  paint;
  inherited;
end;
// -----------------------------------------------------------------------------
procedure TONCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bspressed then
    Exit;

  FDurum := bspressed;
  paint;
  inherited MouseDown(Button, Shift, X, Y);
end;

// -----------------------------------------------------------------------------
procedure TONCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bsnormal then
    Exit;
  FDurum := bsnormal;
  paint;
  inherited MouseUp(Button, Shift, X, Y);
end;


procedure TONCropButton.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bshover then
    Exit;
  if Enabled then
  begin
    FDurum := bshover;
    Paint;
    inherited;
  end;
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


// -----------------------------------------------------------------------------

{ TONButton }

// -----------------------------------------------------------------------------
constructor TONButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csClickEvents, csParentBackground,
    csDoubleClicks, csCaptureMouse];
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  FBasili := TONCUSTOMCROP.Create;
  FBasili.cropname:='CLICK';
  FUzerinde := TONCUSTOMCROP.Create;
  FUzerinde.cropname:='HOVER';
  FPasif := TONCUSTOMCROP.Create;
  FPasif.cropname:='PASSIVE';

  FCaption := 'OnButton';
  FDurum := bsNormal;
  Parent := AOwner as TWinControl;
  Width := 100;
  Height := 30;
  Fcrop := True;
  Transparent := True;
  Fresim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------

destructor TONButton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FBasili);
  FreeAndNil(FUzerinde);
  FreeAndNil(FPasif);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------
procedure TONButton.SetSkindata(Aimg: TONImg);
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
// -----------------------------------------------------------------------------
procedure TONButton.Paint;
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
        case FDurum of
          bsNormal: DR := Rect(FNormal.FSLeft, FNormal.FSTop,
              FNormal.FSRight, FNormal.FSBottom);
          bspressed: DR := Rect(FBasili.FSLeft, FBasili.FSTop,
              FBasili.FSRight, FBasili.FSBottom);
          bshover: DR := Rect(FUzerinde.FSLeft, FUzerinde.FSTop,
              FUzerinde.FSRight, FUzerinde.FSBottom);
        end;
      end
      else
      begin
        DR := Rect(FPasif.FSLeft, FPasif.FSTop, FPasif.FSRight, FPasif.FSBottom);
      end;
//      HEDEF := Rect(0, 0, self.Width, self.Height);
//      DrawPartstrechRegion(DR,Self,Width,Height,HEDEF,false);
      DrawPartstrech(DR, self, Width, Height);
      Transparent:=true;
      if Crop = True then
        CropToimg(Fresim);
    finally
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;


// -----------------------------------------------------------------------------

procedure TONButton.CMHittest(var msg: TCMHIttest);
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
procedure TONButton.MouseMove(Shift: TShiftState; X: integer; Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bshover then
    Exit;

  FDurum := bshover;
  Paint;
  inherited  MouseMove(Shift, X, Y);
end;
// -----------------------------------------------------------------------------

procedure TONButton.MouseLeave;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bsnormal then
    Exit;
  FDurum := bsnormal;
  paint;
  inherited;
end;
// -----------------------------------------------------------------------------
procedure TONButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bspressed then
    Exit;
  FDurum := bspressed;
  paint;
  inherited MouseDown(Button, Shift, X, Y);
end;

// -----------------------------------------------------------------------------
procedure TONButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bsnormal then
    Exit;
  FDurum := bsnormal;
  paint;
  inherited MouseUp(Button, Shift, X, Y);
end;


procedure TONButton.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  if FDurum = bshover then
    Exit;
  if not Enabled then
    Exit;
  if Enabled then
  begin
    FDurum := bshover;
    Paint;
    inherited;
  end;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//////////////////////OnButton End////////////////////////////////////////////




// -----------------------------------------------------------------------------

{ TOnCheckBox }

// -----------------------------------------------------------------------------

procedure TOnCheckBox.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------
constructor TOnCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  FBasili := TONCUSTOMCROP.Create;
  FBasili.cropname:='CLICK';
  FPasifnormal := TONCUSTOMCROP.Create;
  FPasifnormal.cropname:='PASSIVENORMAL';
  FPasifcheck := TONCUSTOMCROP.Create;
  FPasifcheck.cropname:='PASSIVECLICK';
  ControlStyle := ControlStyle + [csClickEvents, csParentBackground, csCaptureMouse];
  Width := 100;
  Height := 30;
  Fresim.SetSize(30, 30);
  FCaption := 'OnCheckBox';
//  SetBounds(0, 0, 100, 30);
  FChecked := False;
  Enabled := True;
  Fresimuzunlugu := 0;
  Fresimyuksligi := 0;
  Transparent := True;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TOnCheckBox.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FBasili);
  FreeAndNil(FPasifnormal);
  FreeAndNil(FPasifcheck);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------

procedure TOnCheckBox.SetSkindata(Aimg: TONImg);
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

// -----------------------------------------------------------------------------
procedure TOnCheckBox.CMHittest(var msg: TCMHIttest);
begin
  inherited;
 { if csDesigning in ComponentState then
    Exit;
  if PtInRegion(WindowRgn, msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
  }
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TOnCheckBox.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //  Paint;
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TOnCheckBox.MouseLeave;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //  paint;
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TOnCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  // SetFocus;
  if FChecked = False then
    FChecked := True
  else
    FChecked := False;

  paint;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure TOnCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //  if Assigned(FOnMouseUp) then
  //    FOnMouseUp(Msg);
  //paint;
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONCheckBox.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
{  if (not FDurum=bspressed) then
  begin
    if PtInRect(Bounds(0, 0, Width, Height), Point(X, Y)) then
    begin
      if not (FDurum in  [bshover]) then
        Perform(CM_MOUSEENTER, 0, 0);
    end
    else
      if FDurum <> bsNormal then
        Perform(CM_MOUSELEAVE, 0, 0);
  end;
}
  inherited MouseMove(Shift, X, Y);
end;

// -----------------------------------------------------------------------------
procedure TONCheckBox.paint;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil) then
  begin
    try
      DR := Rect(0, 0, 0, 0);
      if Enabled = True then
      begin
        if FChecked then
          DR := Rect(FBasili.FSLeft, FBasili.FSTop, FBasili.FSRight, FBasili.FSBottom)
        else
          DR := Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
      end
      else
      begin
        if FChecked then
          DR := Rect(FPasifcheck.FSLeft, FPasifcheck.FSTop,
            FPasifcheck.FSRight, FPasifcheck.FSBottom)
        else
          DR := Rect(FPasifnormal.FSLeft, FPasifnormal.FSTop,
            FPasifnormal.FSRight, FPasifnormal.FSBottom);
      end;


//      DrawPartstrechRegion(DR,Self,Width,Height,Rect(0,0,Height,Height),false);
      DrawPartstrech(DR, Self, Height, Height);

     { if self.Width <> Fresim.Width + Canvas.TextWidth(FCaption) + 5 then
        self.Width := fresim.Width + Canvas.TextWidth(FCaption) + 5;
      }

    finally

    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;
// -----------------------------------------------------------------------------

//////////////////////OnCheckBox Finish////////////////////////////////////////////




// -----------------------------------------------------------------------------

{ TOnRadioButton }

// -----------------------------------------------------------------------------

procedure TOnRadioButton.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if FChecked then
      deaktifdigerleri;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------
constructor TOnRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  FBasili := TONCUSTOMCROP.Create;
  FBasili.cropname:='CLICK';
  FPasifnormal := TONCUSTOMCROP.Create;
  FPasifnormal.cropname:='PASSIVENORMAL';
  FPasifcheck := TONCUSTOMCROP.Create;
  FPasifcheck.cropname:='PASSIVECLICK';
  ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse];
  Width := 120;
  Height := 20;
  Fresim.SetSize(20, 20);
  FCaption := 'OnRadioButton';
//  SetBounds(0, 0, 100, 30);
  FChecked := False;
  Enabled := True;
  Fresimuzunlugu := 0;
  Fresimyuksligi := 0;
  Transparent := True;

end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
destructor TOnRadioButton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FBasili);
  FreeAndNil(FPasifnormal);
  FreeAndNil(FPasifcheck);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------

procedure TOnRadioButton.SetSkindata(Aimg: TONImg);
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

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TOnRadioButton.CMHittest(var msg: TCMHIttest);
begin
  inherited;
//  if csDesigning in ComponentState then
//    Exit;
{  if PtInRegion(WindowRgn, msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;
  }
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------


procedure TOnRadioButton.MouseEnter;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //  Paint;
  inherited;
end;




procedure TOnRadioButton.MouseLeave;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //   Paint;
  inherited;
end;
// -----------------------------------------------------------------------------

procedure TOnRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //SetFocus;
  if FChecked = False then
    Checked := True;

  paint;
  inherited MouseDown(Button, Shift, X, Y);
end;

// -----------------------------------------------------------------------------
procedure TOnRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  //  paint;
  inherited MouseUp(Button, Shift, X, Y);
end;
// -----------------------------------------------------------------------------

procedure TOnRadioButton.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseMove(Shift, X, Y);
end;
// -----------------------------------------------------------------------------
procedure TOnRadioButton.paint;
var
  DR: Trect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil) then
    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin
    try
      DR := Rect(0, 0, 0, 0);
      if Enabled = True then
      begin
        if FChecked then
          DR := Rect(FBasili.FSLeft, FBasili.FSTop, FBasili.FSRight, FBasili.FSBottom)
        else
          DR := Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
      end
      else
      begin
        if FChecked then
          DR := Rect(FPasifcheck.FSLeft, FPasifcheck.FSTop,
            FPasifcheck.FSRight, FPasifcheck.FSBottom)
        else
          DR := Rect(FPasifnormal.FSLeft, FPasifnormal.FSTop,
            FPasifnormal.FSRight, FPasifnormal.FSBottom);
      end;

//      DrawPartstrechRegion(DR,Self,Width,Height,Rect(0,0,Height,Height),false);
      DrawPartstrech(DR, Self, Height, Height);

        {if Crop=true then
         CropToimg(Fresim);
        }

     { if self.Width <> Fresim.Width + Canvas.TextWidth(FCaption) + 5 then
        self.Width := fresim.Width + Canvas.TextWidth(FCaption) + 5;
      }
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
  Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;


procedure TOnRadioButton.deaktifdigerleri;
var
  i: integer;
begin
  if Parent <> nil then
    with Parent do
    begin
      for i := 0 to ControlCount - 1 do
        if (Controls[i] <> Self) and (Controls[i] is TOnRadioButton) and
          ((Controls[i] as TOnRadioButton).FGroupIndex =
          (Self as TOnRadioButton).FGroupIndex) then
          TOnRadioButton(Controls[i]).SetChecked(False);
    end;
end;

// -----------------------------------------------------------------------------

//////////////////////OnRadioButton Finish////////////////////////////////////////////




// -----------------------------------------------------------------------------

{ TONProgressBar }

// -----------------------------------------------------------------------------
constructor TONProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  Fsol := TONCUSTOMCROP.Create;
  Fsol.cropname:='LEFT';
  Fsag := TONCUSTOMCROP.Create;
  Fsag.cropname:='RIGHT';
  Fust := TONCUSTOMCROP.Create;
  Fust.cropname:='TOP';
  Falt := TONCUSTOMCROP.Create;
  Falt.cropname:='BOTTOM';
  Fbar := TONCUSTOMCROP.Create;
  Fbar.cropname:='BAR';
  ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse];
  FDurum := Fhorizontal;
  Width := 100;
  Height := 30;
  Fresim.SetSize(Width, Height);
  Fmin := 0;
  Fmax := 100;
  Fposition := 0;
  fcaptionbol := False;
  Transparent := True;
  Fcrop:=true;
end;

// -----------------------------------------------------------------------------

destructor TONProgressBar.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(Fsag);
  FreeAndNil(Fsol);
  FreeAndNil(Fbar);
  FreeAndNil(Falt);
  FreeAndNil(Fust);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------
procedure TONProgressBar.SetState(val: TONProgressState);
begin
  if FDurum <> val then
   begin
    FDurum := val;
    Paint;
  end;
end;
// -----------------------------------------------------------------------------

procedure TONProgressBar.SetSkindata(Aimg: TONImg);
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

procedure TONProgressBar.paint;
var
  FbarResim: TBGRABitmap;
  asd: integer;
  DR, FbarRect: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil) then
  begin
    try
      if FDurum = Fhorizontal then   //left image if state horizontal
      begin
        DR := Rect(Fsol.FSLeft, Fsol.FSTop, Fsol.FSRight, Fsol.FSBottom);
        DrawPartstrechRegion(DR,self,Fsol.FSRight-Fsol.FSLeft,Height,rect(0, 0, Fsol.FSRight - Fsol.FSLeft, Height), False);
//        DrawPartnormal(DR, self, rect(0, 0, Fsol.FSRight - Fsol.FSLeft, Height), False);
      end
      else         //top image if state vertical
      begin
        DR := Rect(Fust.FSLeft, Fust.FSTop, Fust.FSRight, Fust.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,Fust.FSBottom - Fust.FSTop,rect(0, 0, Width, Fust.FSBottom - Fust.FSTop), False);
//        DrawPartnormal(DR, self, rect(0, 0, Width, Fust.FSBottom - Fust.FSTop), False);
      end;


      if FDurum = Fhorizontal then  //right image if state horizontal
      begin
        DR := Rect(Fsag.FSLeft, Fsag.FSTop, Fsag.FSRight, Fsag.FSBottom);
        DrawPartstrechRegion(DR,self,(fsag.FSRight - Fsag.FSLeft),self.Height,Rect(self.Width -(fsag.FSRight - Fsag.FSLeft), 0, self.Width, self.Height),false);
//        DrawPartnormal(DR, self, Rect(Width - (fsag.FSRight - Fsag.FSLeft), 0, Width, Height), False);
      end
      else       //bottom image if state vertical
      begin
        DR := Rect(Falt.FSLeft, Falt.FSTop, Falt.FSRight, Falt.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,(Falt.FSBottom - Falt.FSTop),Rect(0, self.Height-(Falt.FSBottom - Falt.FSTop), self.Width, self.Height),false);
 //       DrawPartnormal(DR, self, Rect(0, Height - (Falt.FSBottom - Falt.FSTop), Width, Height), False);
      end;

      DR := Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
      if FDurum = Fhorizontal then  //center image if state horizontal
      begin
        DrawPartstrechRegion(DR,self,self.Width-((Fsol.FSRight - Fsol.FSLeft)+(fsag.FSRight - Fsag.FSLeft)),self.Height,Rect((Fsol.FSRight - Fsol.FSLeft), 0, (Width - (fsag.FSRight - Fsag.FSLeft)), Height),false);
//        DrawPartnormal(DR, self, Rect((Fsol.FSRight - Fsol.FSLeft), 0,
//          (Width - (fsag.FSRight - Fsag.FSLeft)), Height), False);
      end
      else         //center image if state vertical
      begin
        DrawPartstrechRegion(DR,self,Width,Height-((Fust.FSBottom - Fust.FSTop)+(Falt.FSBottom - Falt.FSTop)),Rect(0, (Fust.FSBottom - Fust.FSTop), Width, Height-(Falt.FSBottom - Falt.FSTop)),false);
//        DrawPartnormal(DR, Self, Rect(0, (Fust.FSBottom - Fust.FSTop), Width, Height -
//          (Falt.FSBottom - Falt.FSTop)), False);
        // self.Width,Height-((Fust.FSBottom-Falt.FSTop)+(Fust.FSBottom-Falt.FSTop)) );
      end;


      if fMin > fMax then
        fMin := fMax;
      if position < fMin then
        position := fMin;
      if position > fMax then
        position := fMax;

      Freh := 0;
      if position > 0 then
      begin
        if fMin <> fMax then
          if FDurum = Fhorizontal then
            Freh := Round(Abs((position - fMin) / (fMax - fMin)) * self.Width)
          else
            Freh := Round(Abs((position - FMin) / (FMax - FMin)) * self.Height)
        else
          Freh := 0;
      end;

      //position:=Round(Abs((position - FMin) / (Fmax - FMin)) * 100);

      if (freh > 0) and (fcaptionbol = True) then
        FCaption := '%' + floattostr(Round(Abs((position - fMin) / (fmax - fMin)) * 100));


      if FDurum = Fhorizontal then
      begin
        //  if Freh-abs((fsol.FSRight-Fsol.FSLeft)+(fsag.FSRight-Fsag.FSLeft))>=Width then
        if (Fbar.FSRight + Fbar.FSLeft) - abs((fsol.FSRight - Fsol.FSLeft) +
          (fsag.FSRight - Fsag.FSLeft)) >= Width then
          asd := Freh - abs((fsol.FSRight - Fsol.FSLeft) + (fsag.FSRight - Fsag.FSLeft))
        else
          asd := Freh;
      end
      else
      begin
        //  if Freh-abs((Falt.FSBottom-Falt.FSTop)+(Fust.FSBottom-Fust.FSTop))>position then
        if (Fbar.FSBottom + Fbar.FSTop) - abs((Falt.FSBottom - Falt.FSTop) +
          (Fust.FSBottom - Fust.FSTop)) >= Height then

          asd := Freh - abs((Falt.FSBottom - Falt.FSTop) + (Fust.FSBottom - Fust.FSTop))
        else
          asd := Freh;
      end;


      if FDurum = Fhorizontal then
      begin
        if (Height < (Fbar.FSBottom - Fbar.FSTop)) then
          FbarResim := TBGRABitmap.Create(asd, abs(((Fbar.FSBottom - Fbar.FSTop) div 2) - Height))
        else
          FbarResim := TBGRABitmap.Create(asd, (Fbar.FSBottom - Fbar.FSTop));
      end
      else
      begin
        if (Width < (Fbar.FSRight - Fbar.FSLeft)) then
          FbarResim := TBGRABitmap.Create(abs(((Fbar.FSRight - Fbar.FSLeft) div 2) - Width), asd)
        else
          FbarResim := TBGRABitmap.Create((Fbar.FSRight - Fbar.FSLeft), asd);
      end;

      FbarRect := Rect(Fbar.FSLeft, Fbar.FSTop, Fbar.FSRight, Fbar.FSBottom);
      FSkindata.Images.DrawPart(FbarRect, FbarResim.Canvas, Rect(
        0, 0, FbarResim.Width, FbarResim.Height), False);



      if FDurum = Fhorizontal then
        Fresim.BlendImage((fsol.FSRight - fsol.FSLeft), abs(
          (Fresim.Height div 2) - (FbarResim.Height div 2)), FbarResim, boTransparent)
      else
        Fresim.BlendImage(abs((Fresim.Width div 2) - (FbarResim.Width div 2)),
          (Fust.FSBottom - Fust.FSTop), FbarResim, boTransparent);

    finally
      FreeAndNil(FbarResim);
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;


// -----------------------------------------------------------------------------
procedure TONProgressBar.CMHittest(var msg: TCMHIttest);
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

{
// -----------------------------------------------------------------------------
procedure TONProgressBar.WMMouseEnter(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Msg);
end;
// -----------------------------------------------------------------------------

procedure TONProgressBar.WMMouseLeave(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Msg);
end;
// -----------------------------------------------------------------------------

procedure TONProgressBar.WMLButtonDown(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Msg);
//  Paint;
end;

// -----------------------------------------------------------------------------
procedure TONProgressBar.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Msg);
end;
// -----------------------------------------------------------------------------
  }
procedure TONProgressBar.Setaz(Val: integer);
begin
  if Fmin <> Val then
  begin
    Fmin := Val;
  end;
end;

procedure TONProgressBar.Setcok(Val: integer);
begin
  if Fmax <> Val then
  begin
    Fmax := Val;
  end;
end;

procedure TONProgressBar.Setdeger(Val: integer);
begin
  if Fposition <> Val then
  begin
    Fposition := Val;
    Paint;
  end;
end;

//////////////////////TONProgressBar End////////////////////////////////////////////




// -----------------------------------------------------------------------------

{ TOnSwich }

// -----------------------------------------------------------------------------

procedure TOnSwich.SetChecked(Value: boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------
constructor TOnSwich.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csClickEvents, csParentBackground, csCaptureMouse];
  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname:='NORMAL';
  FBasili := TONCUSTOMCROP.Create;
  FBasili.cropname:='CLICK';
  FPasifnormal := TONCUSTOMCROP.Create;
  FPasifnormal.cropname:='PASSIVENORMAL';
  FPasifbasili := TONCUSTOMCROP.Create;
  FPasifbasili.cropname:='PASSIVECLICK';



  Width := 140;
  Height := 30;
  FChecked := False;
  TabStop := True;
  Enabled := True;
  Fresimuzunlugu := 0;
  Fresimyuksligi := 0;
  ParentBackground := True;
end;
// -----------------------------------------------------------------------------
 procedure TOnSwich.SetSkindata(Aimg: TONImg);
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
// -----------------------------------------------------------------------------
destructor TOnSwich.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FBasili);
  FreeAndNil(FPasifnormal);
  FreeAndNil(FPasifbasili);
  inherited Destroy;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TOnSwich.CMHittest(var msg: TCMHIttest);
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

// -----------------------------------------------------------------------------
procedure TOnSwich.WMMouseEnter(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Msg);
end;
// -----------------------------------------------------------------------------

procedure TOnSwich.WMMouseLeave(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Msg);

end;
// -----------------------------------------------------------------------------

procedure TOnSwich.WMLButtonDown(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  SetFocus;
  if FChecked = False then
    Checked := True
  else
    Checked := False;

  if Assigned(FOnMouseDown) then
    FOnMouseDown(Msg);
  // ayarla;
  paint;
end;

// -----------------------------------------------------------------------------
procedure TOnSwich.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Msg);
end;
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
procedure TOnSwich.paint;
begin

  if (FSkindata <> nil) then
  begin
    try
      if Enabled = True then
      begin
        if FChecked = True then
          DR := Rect(FBasili.FSLeft, FBasili.FSTop, FBasili.FSRight, FBasili.FSBottom)
        else
          DR := Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
      end
      else
      begin
        if FChecked = True then
          DR := Rect(FPasifbasili.FSLeft, FPasifbasili.FSTop,
            FPasifbasili.FSRight, FPasifbasili.FSBottom)
        else
          DR := Rect(FPasifnormal.FSLeft, FPasifnormal.FSTop,
            FPasifnormal.FSRight, FPasifnormal.FSBottom);
      end;

      Fresim.SetSize(self.Width, Self.Height);
      DrawPartstrech(DR, self, self.Width, self.Height);
//      DrawPartstrechRegion(DR,Self,Width,Height,Rect(0,0,Width,Height),false);

      if Crop = True then
        CropToimg(Fresim);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
   Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;
// -----------------------------------------------------------------------------

//////////////////////OnSwich End////////////////////////////////////////////




constructor TOnCurrencyEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  Alignment := taRightJustify;
  Width := 121;
  Height := 25;
  DispFormat := '0.00₺;(0.00₺)';
  FieldValue := 0.0;
  FDecimalPlaces := 2;
  FPosColor := Font.Color;
  FNegColor := clRed;
  AutoSelect := False;

  {WantReturns := False;}
  WordWrap := False;
  FormatText;
end;

procedure TOnCurrencyEdit.SetFormat(A: string);
begin
  if DispFormat <> A then
  begin
    DispFormat := A;
    FormatText;
  end;
end;

procedure TOnCurrencyEdit.SetFieldValue(A: extended);
begin
  if FieldValue <> A then
  begin
    FieldValue := A;
    FormatText;
  end;
end;

procedure TOnCurrencyEdit.SetDecimalPlaces(A: word);
begin
  if DecimalPlaces <> A then

  begin
    DecimalPlaces := A;
    FormatText;
  end;
end;

procedure TOnCurrencyEdit.SetPosColor(A: TColor);
begin
  if FPosColor <> A then
  begin
    FPosColor := A;
    FormatText;
  end;
end;

procedure TOnCurrencyEdit.SetNegColor(A: TColor);
begin
  if FNegColor <> A then
  begin
    FNegColor := A;
    FormatText;
  end;
end;

procedure TOnCurrencyEdit.UnFormatText;
var
  TmpText: string;
  Tmp: byte;

  IsNeg: boolean;
begin
  IsNeg := (Pos('-', Text) > 0) or (Pos('(', Text) > 0);
  TmpText := '';
  for Tmp := 1 to Length(Text) do
    if Text[Tmp] in ['0'..'9', DecimalSeparator] then
      TmpText := TmpText + Text[Tmp];
  try
    if TmpText = '' then
      TmpText := '0.00';
    FieldValue := StrToFloat(TmpText);
    if IsNeg then
      FieldValue := -FieldValue;
  except
    MessageBeep(mb_IconAsterisk);
  end;
end;

procedure TOnCurrencyEdit.FormatText;

begin
  Text := FormatFloat(DispFormat, FieldValue);
  if FieldValue < 0 then
    Font.Color := NegColor
  else
    Font.Color := PosColor;
end;

procedure TOnCurrencyEdit.CMEnter(var Message: TCMEnter);
begin
  self.SelectAll;
  inherited;
end;

procedure TOnCurrencyEdit.CMExit(var Message: TCMExit);
begin
  UnformatText;
  FormatText;
  inherited;
end;

procedure TOnCurrencyEdit.KeyPress(var Key: char);
var
  S: string;
//  frmParent: TONEDIT;
  //  btnDefault : TButton;
  i: integer;

//  wID: word;
//  LParam: LongRec;
begin
  {#8 is for Del and Backspace keys.}
  if not (Key in ['0'..'9', '.', '-', #8, #13]) then
    Key := #0;
  case Key of
    #13:
    begin
      //   frmParent := GetParentForm(Self);
      UnformatText;
      {find default button on the parent form if any}
           { btnDefault := nil;
            for i := 0 to frmParent.ControlCount -1 do
              if frmParent.Controls[i] is TButton then
                if (frmParent.Controls[i] as TButton).Default then

                  btnDefault := (frmParent.Controls[i] as TButton);
            }
      {if there's a default button, then make the parent form think it was pressed}
           { if btnDefault <> nil then
              begin
                wID := GetWindowWord(btnDefault.Handle, GWW_ID);
                LParam.Lo := btnDefault.Handle;
                LParam.Hi := BN_CLICKED;
                SendMessage(frmParent.Handle, WM_COMMAND, wID, longint(LParam) );
              end;
            }
      Key := #0;
    end;
    { allow only one dot in the number }

    '.': if (Pos('.', Text) > 0) then
        Key := #0;
    { allow only one '-' in the number and only in the first position: }
    '-': if (Pos('-', Text) > 0) or (SelStart > 0) then
        Key := #0;
    else
      { make sure no other character appears before the '-' }
      if (Pos('-', Text) > 0) and (SelStart = 0) and (SelLength = 0) then
        Key := #0;
  end;

  if Key <> char(vk_Back) then
  begin
     {S is a model of Text if we accept the keystroke.  Use SelStart and

     SelLength to find the cursor (insert) position.}
    S := Copy(Text, 1, SelStart) + Key + Copy(Text, SelStart + SelLength + 1, Length(Text));
    if ((Pos(DecimalSeparator, S) > 0) and (Length(S) -
      Pos(DecimalSeparator, S) > FDecimalPlaces))  {too many decimal places} or
      ((Key = '-') and (Pos('-', Text) <> 0))     {only one minus...} or
      (Pos('-', S) > 1)                           {... and only at beginning} then
      Key := #0;

  end;
  // UnFormatText;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TOnCurrencyEdit.CreateParams(var Params: TCreateParams);
var
  lStyle: longint;
begin
  inherited CreateParams(Params);
  case Alignment of
    taLeftJustify: lStyle := ES_LEFT;
    taRightJustify: lStyle := ES_RIGHT;
    taCenter: lStyle := ES_CENTER;
  end;
  Params.Style := Params.Style or lStyle;
end;
// -----------------------------------------------------------------------------


{*******************************************************}
constructor TOnCustomComboBoxe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouseInControl := False;
  FForceDrawFocused := False;
  Fbuttonimage := TPicture.Create;
  BiDiMode := bdLeftToRight;
  ParentBiDiMode := False;
  BorderStyle := bsNone;
  BorderWidth := 0;
  ControlStyle := ControlStyle - [csSetCaption, csParentBackground];
end;

{***********************************}
destructor TOnCustomComboBoxe.Destroy;
begin
  FreeAndNil(Fbuttonimage);
  inherited Destroy;

end;

{************************************************************}
procedure TOnCustomComboBoxe.Setbuttonimage(Value: TPicture);
begin
  if Fbuttonimage <> Value then
    Fbuttonimage.Assign(Value);
  Fbuttonimage.Bitmap.Transparent := False;
end;

{************************************************************}
procedure TOnCustomComboBoxe.ReplaceInvalidateInQueueByRefresh;
begin
  ValidateRect(handle, nil);
  Refresh;
end;

{*************************************}
procedure TOnCustomComboBoxe.PaintCombo;
var
  continue: boolean;
  C: TControlCanvas;
  R: TRect;
  X: integer;
begin
  continue := True;
  if assigned(FonPaint) then
    FOnPaint(Self, continue);

  if not continue then
  begin
    ReplaceInvalidateInQueueByRefresh;
    exit;
  end;


  C := TControlCanvas.Create;
  try
    C.Control := Self;
    with SELF do
    begin

      C.Brush.Color := Color;
      R := ClientRect;
      x := R.Right;
      c.FrameRect(R);
      InflateRect(R, -1, -1);
      c.FrameRect(R);
      InflateRect(R, -1, -1);
      c.FrameRect(R);

      R := ClientRect;
      R.Left := X - GetSystemMetrics(SM_CXHTHUMB) - 2;
      R.Right := x;

      InflateRect(R, 0, -1);

      Fbuttonimage.Bitmap.Transparent := False;
      c.StretchDraw(r, Fbuttonimage.Bitmap);

    end;

  finally
    C.Free;
  end;
end;

{*********************************************************}
procedure TOnCustomComboBoxe.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    {------------------}
    WM_LButtonUp:
    begin
      inherited;
      paintcombo;
    end;
    {------------------}
    CM_MouseEnter:
    begin
      inherited;
      FmouseinControl := True;
      PaintCombo;
    end;
    {------------------}
    CM_MouseLeave:
    begin
      inherited;
      FmouseinControl := False;
      PaintCombo;
    end;
    {------------}
    CM_Exit:
    begin
      inherited;
      FForceDrawFocused := False;
      PaintCombo;
    end;
    {-------------}
    WM_Paint:
    begin
      inherited;
      PaintCombo;
    end;
    {----------------}
    WM_setfocus:
    begin
      inherited;
      FForceDrawFocused := True;
      PaintCombo;
    end;
      {--------------}
    else
      inherited;
  end;
end;

{*************************************************************}
procedure TOnCustomComboBoxe.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    {----------------}
    CBN_CLOSEUP:
    begin
      //  inherited;
      PaintCombo;
    end;
    {--------------}
    // else inherited;
  end;
end;




function StrToDateDef(cDate: string; dDefault: TDateTime): TDateTime;
begin
  try
    Result := StrToDate(cDate)
  except
    Result := dDefault;
  end;
end;

constructor TONDATEEDIT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDate := NullDate;
  FUpdatingDate := False;
  FDefaultToday := False;
  FDisplaySettings := [dsShowHeadings, dsShowDayNames];
  ControlStyle := ControlStyle + [csParentBackground, csClickEvents];
  { ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse,
  csClickEvents, csSetCaption, csDoubleClicks, csReplicatable,
  csNoFocus, csAutoSize0x0, csParentBackground, csOpaque];
  }
  FUst := TONCUSTOMCROP.Create;
  FUST.cropname:='TOP';
  FAlt := TONCUSTOMCROP.Create;
  FAlt.cropname:='BOTTOM';
  FOrta := TONCUSTOMCROP.Create;
  FOrta.cropname:='CENTER';
  FSag := TONCUSTOMCROP.Create;
  FSag.cropname:='RIGHT';
  FSagust := TONCUSTOMCROP.Create;
  FSagust.cropname:='TOPRIGHT';
  FSagalt := TONCUSTOMCROP.Create;
  FSagalt.cropname:='BOTTOMRIGHT';
  FSol := TONCUSTOMCROP.Create;
  FSol.cropname:='LEFT';
  FSolust := TONCUSTOMCROP.Create;
  FSolust.cropname:='TOPLEFT';
  FSolalt := TONCUSTOMCROP.Create;
  FSolalt.cropname:='BOTTOMLEFT';
  Fbutton := TONCUSTOMCROP.Create;
  Fbutton.cropname:='BUTTON';




  Self.Height := 40;
  Self.Width := 100;
  Fresim.SetSize(Width, Height);
  Fbuttonu := TOnGraphicControl.Create(self);
  Fbuttonu.Parent := Self;// as TWinControl;
  Fbuttonu.SetSubComponent(True);
  Fbuttonu.Name := self.Name + 'Subdateeditbutton';
  Fbuttonu.Width := 20;
  Fbuttonu.Height := Height - 5;
  //  Fbuttonu.Left:=self.Width-Fbuttonu.Width;//+(fsag.FSRight-FSag.FSLeft));
  //  Fbuttonu.Top:=5;
  //  Fbuttonu.Align:=alRight;
  Fbuttonu.OnClick := @ButtonClick;
  Fbuttonu.Caption := '30';
  if self.Skindata <> nil then
    Fbuttonu.FSkindata := self.Skindata;
{  Fbuttonu.ONNORMAL:=Fbutton;
  Fbuttonu.ONBASILI:=Fbutton;
  Fbuttonu.ONPASIF:=Fbutton;
  Fbuttonu.ONUZERINDE:=Fbutton;
  Fbuttonu.Paint; }

  Fedit := TMaskEdit.Create(self);
  Fedit.Parent := self;
  Fedit.SetSubComponent(True);
  Fedit.Name := self.Name + 'Subdateedit';
  //  Fcombo.AutoSize:=true;
  //  Fedit.Width:=self.Width-(Fbuttonu.Width);
  //  Fedit.Height:=self.Height;//-10;
  //  Fedit.Left:=5;
  //  Fedit.Top:=5;
  Fedit.AutoSize := True;
  Fedit.Color := Fresim.GetPixel(0, 0).ToColor;
  fedit.Align := alClient;
{  Fedit.Font.Name:=Self.Font.Name;
  Fedit.Font.Size:=Self.Font.Size;
  Fedit.Font.Color:=Self.Font.Color;
  Fedit.Font.Style:=Self.Font.Style; }
  Fedit.BorderWidth := 0;
  Fedit.BorderStyle := bsNone;
  ReadOnly := Fedit.ReadOnly;
  AutoSelect := Fedit.AutoSelect;
  fedit.EditMask := '99.99.9999';
  //  AutoSelected:=fedit.AutoSelected;
  //  Fedit.Text:='01.01.2020';
  SetDate(now);

  Fedit.OnDblClick := @EditDblClick;
  Fedit.OnEditingDone := @EditEditingDone;
  Fbuttonu.Align := alRight;
  Fedit.Align := alClient;

  ChildSizing.VerticalSpacing := 5;
  ChildSizing.HorizontalSpacing := 4;

  //  DirectInput:=true;
  //  OnClick:=TNotifyEvent(ButtonClick);
end;

destructor TONDATEEDIT.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(fedit);
  FreeAndNil(Fbutton);
  FreeAndNil(Fbuttonu);

  inherited;
end;
// -----------------------------------------------------------------------------

procedure TONDATEEDIT.SetSkindata(Aimg: TONImg);
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

procedure TONDATEEDIT.Changefont(Sender: TObject);
begin

end;

procedure TONDATEEDIT.paint;
var
  HEDEF, KAYNAK: TRect;
  //  img:TBGRABitmap;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil){ or (FSkindata.Fimage <> nil)} then
  begin
    try

      //UST TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, self.Width -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);

      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);

      DrawPartnormal(kaynak, self, hedef, False);

      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(Width - (FSagust.FSRight - FSagust.FSLeft), 0, Width,
        (FSagust.FSBottom - FSagust.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, Height - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), Height);

      DrawPartnormal(kaynak, self, hedef, False);


      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(Width - (FSagalt.FSRight - FSagalt.FSLeft), Height -
        (FSagalt.FSBottom - FSagalt.FSTop), self.Width, self.Height);

      DrawPartnormal(kaynak, self, hedef, False);

      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), self.Height -
        (FAlt.FSBottom - FAlt.FSTop), Width - (FSagalt.FSRight - FSagalt.FSLeft), self.Height);

      DrawPartnormal(kaynak, self, hedef, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(Width - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        Width, Height - (FSagalt.FSBottom - FSagalt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);


      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        Width - (FSag.FSRight - FSag.FSLeft), Height - (FAlt.FSBottom - FAlt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);
      fedit.Color := FSkindata.Images.GetPixel(FOrta.FSLeft, FOrta.FSTop);



      if self.Skindata <> nil then
        Fbuttonu.FSkindata := self.Skindata;

      KAYNAK := Rect(Fbutton.FSLeft, Fbutton.FSTop, Fbutton.FSRight, Fbutton.FSBottom);
      DrawPartstrech(KAYNAK, Fbuttonu, Fbuttonu.Width, Fbuttonu.Height);

      if Crop then
        CropToimg(Fresim);




      fedit.Width := 5 + self.Width - (Fbuttonu.Width + (FSag.FSRight - FSag.FSLeft) +
        (FSol.FSRight - FSol.FSLeft));
      fedit.Height := 5 + self.Height - ((FUst.FSBottom - FUst.FSTop) + (FAlt.FSBottom - FAlt.FSTop));
      fedit.Left := FSol.FSRight - FSol.FSLeft;
      fedit.Top := Round((self.Height div 2) - (fedit.Height div 2));



      ChildSizing.LeftRightSpacing := (FSag.FSRight - FSag.FSLeft);
      //-ChildSizing.VerticalSpacing;//+(FSol.FSRight-FSol.FSLeft);
      ChildSizing.TopBottomSpacing := (FUst.FSBottom - FUst.FSTop);
      //-ChildSizing.HorizontalSpacing;//+(FAlt.FSBottom-FAlt.FSTop);

      //Fedit.Text:=Fedit.Text;
    finally
      //  FreeAndNil(img);
    end;
  end else
  begin
    Fresim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited;
end;

function TONDATEEDIT.GetDateFormat: string;
begin
  Result := FFixedDateFormat;
end;

function TONDATEEDIT.GetEditMask: string;
begin
  Result := self.Fedit.EditMask;
end;

procedure TONDATEEDIT.SetEditMask(AValue: string);
begin
  self.Fedit.EditMask := avalue;
end;

procedure TONDATEEDIT.ButtonClick(Sender: TObject); //or onClick
var
  PopupOrigin: TPoint;
  ADate: TDateTime;
begin

  PopupOrigin := ControlToScreen(Point(0, Height));
  ADate := GetDate;
  if ADate = NullDate then
    ADate := SysUtils.Date;
  ShowCalendarPopup(PopupOrigin, ADate, CalendarDisplaySettings,
    @CalendarPopupReturnDate, @CalendarPopupShowHide, self);
  //Do this after the dialog, otherwise it just looks silly

  //  if FocusOnButtonClick then FocusAndMaybeSelectAll;
end;

procedure TONDATEEDIT.SetReadonly(const Value: boolean);
begin
  if Freadonly <> Value then
  begin
    Freadonly := Value;
    Fedit.ReadOnly := Value;
  end;
end;

procedure TONDATEEDIT.Setautoselect(const Value: boolean);
begin
  if Fautoselect <> Value then
  begin
    Fautoselect := Value;
    Fedit.AutoSelect := Value;
  end;
end;

procedure TONDATEEDIT.Setautoselected(const Value: boolean);
begin
{  if Fautoselected<>value then
  begin
     Fautoselected:=value;
     Fedit.AutoSelected:=value;
  end;
  }
end;

procedure TONDATEEDIT.EditDblClick(Sender: TObject);
begin
  //  inherited EditDblClick;
  if not ReadOnly then
    ButtonClick(Fbuttonu);
end;

procedure TONDATEEDIT.EditEditingDone(Sender: TObject);//(sender:Tobject;var Key: char);
var
  AText: string;

begin
  //  inherited EditEditingDone;

  if DirectInput then
  begin
    AText := DateToText(GetDate);
    if AText <> Fedit.Text then //avoid unneccesary recalculation FDate
      Fedit.Text := AText;
  end;
end;

procedure TONDATEEDIT.SetDirectInput(AValue: boolean);
var
  Def: TDateTime;
begin
  //  inherited SetDirectInput(AValue);
  //Synchronize FDate
  FDate := TextToDate(Fedit.Text, NullDate);
  //Force a valid date in the control, but not if Text was empty in designmode
  if not ((csDesigning in ComponentState) and FDefaultToday and (FDate = NullDate)) then
    SetDate(FDate);
end;

procedure TONDATEEDIT.RealSetText(const AValue: TCaption);
begin
  if (not DirectInput) and not FUpdatingDate then
  begin
    //force a valid date and set FDate
    //debugln('TDateEdit.SetText: DirectInput = False');
    if FDefaultToday then
      FDate := TextToDate(AValue, SysUtils.Date)
    else
      FDate := TextToDate(AValue, NullDate);
    //Allow to clear Text in Designer (Issue #0030425)
    if (csDesigning in ComponentState) and (AValue = '') then
      inherited RealSetText('')
    else
      inherited RealSetText(DateToText(FDate));
  end
  else
    inherited RealSetText(AValue);
end;

procedure TONDATEEDIT.SetDateMask;

var
  S: string;
  D: TDateTime;
begin
  case DateOrder of
    doNone:
    begin
      S := ''; // no mask
      FFixedDateFormat := '';
    end;
    doDMY,
    doMDY:
    begin
      S := '99/99/9999;1;_';
      if DateOrder = doMDY then
        FFixedDateFormat := 'mm/dd/yyyy'
      else
        FFixedDateFormat := 'dd/mm/yyyy';
    end;
    doYMD:
    begin
      S := '9999/99/99;1;_';
      FFixedDateFormat := 'yyyy/mm/dd';
    end;
  end;
  D := GetDate;
  EditMask := S;
  SetDate(D);
end;

procedure TONDATEEDIT.Loaded;
begin
  inherited Loaded;
  //Forces a valid Text in the control
  if not (csDesigning in ComponentState) then
    SetDate(FDate);
end;

function ParseDate(S: string; Order: TDateOrder; Def: TDateTime): TDateTime;

var
  P, N1, N2, N3: integer;
  B: boolean;

begin
  Result := Def;
  P := Pos(DefaultFormatSettings.DateSeparator, S);
  if (P = 0) then
    Exit;
  N1 := StrToIntDef(Copy(S, 1, P - 1), -1);
  if (N1 = -1) then
    Exit;
  Delete(S, 1, P);
  P := Pos(DefaultFormatSettings.DateSeparator, S);
  if (P = 0) then
    Exit;
  N2 := StrToIntDef(Copy(S, 1, P - 1), -1);
  if (N1 = 0) then
    Exit;
  Delete(S, 1, P);
  N3 := StrToIntDef(S, -1);
  if (N3 = -1) then
    exit;
  case Order of
    doYMD: B := TryEncodeDate(N1, N2, N3, Result);
    doMDY: B := TryEncodeDate(N3, N1, N2, Result);
    doDMY: B := TryEncodeDate(N3, N2, N1, Result);
    else
      B := False;
  end;
  if not B then // Not sure if TryEncodeDate touches Result.
    Result := Def;
end;

// Tries to parse string when DateOrder = doNone when string maybe contains
// literal day or monthnames. For example when ShortDateFormat = 'dd-mmm-yyy'
// Returns NullDate upon failure.
function ParseDateNoPredefinedOrder(SDate: string; FS: TFormatSettings): TDateTime;
var
  Fmt: string;
  DPos, MPos, YPos: SizeInt;
  DStr, MStr, YStr: string;
  LD, LM, LY: longint;
  DD, MM, YY: word;
const
  Digits = ['0'..'9'];

  procedure GetPositions(out DPos, MPos, YPos: SizeInt);
  begin
    DStr := '';
    MStr := '';
    YStr := '';
    DPos := Pos('D', Fmt);
    MPos := Pos('M', Fmt);
    YPos := Pos('Y', Fmt);
    if (YPos = 0) or (MPos = 0) or (DPos = 0) then
      Exit;
    if (YPos > DPos) then
      YPos := 3
    else
      YPos := 1;
    if (DPos < MPos) then
    begin
      if (YPos = 3) then
      begin
        DPos := 1;
        MPos := 2;
      end
      else
      begin
        DPos := 2;
        MPos := 3;
      end;
    end
    else
    begin
      if (YPos = 3) then
      begin
        DPos := 2;
        MPos := 1;
      end
      else
      begin
        DPos := 3;
        MPos := 2;
      end;
    end;
  end;

  procedure ReplaceLiterals;
  var
    i, P: integer;
    Sub: string;
  begin
    if (Pos('MMMM', Fmt) > 0) then
    begin //long monthnames
      //writeln('Literal monthnames');
      for i := 1 to 12 do
      begin
        Sub := FS.LongMonthNames[i];
        P := Pos(Sub, SDate);
        if (P > 0) then
        begin
          Delete(SDate, P, Length(Sub));
          Insert(IntToStr(i), SDate, P);
          Break;
        end;
      end;
    end
    else
    begin
      if (Pos('MMM', Fmt) > 0) then
      begin //short monthnames
        for i := 1 to 12 do
        begin
          Sub := FS.ShortMonthNames[i];
          P := Pos(Sub, SDate);
          if (P > 0) then
          begin
            Delete(SDate, P, Length(Sub));
            Insert(IntToStr(i), SDate, P);
            Break;
          end;
        end;
      end;
    end;

    if (Pos('DDDD', Fmt) > 0) then
    begin  //long daynames
      //writeln('Literal daynames');
      for i := 1 to 7 do
      begin
        Sub := FS.LongDayNames[i];
        P := Pos(Sub, SDate);
        if (P > 0) then
        begin
          Delete(SDate, P, Length(Sub));
          Break;
        end;
      end;
    end
    else
    begin
      if (Pos('DDD', Fmt) > 0) then
      begin //short daynames
        for i := 1 to 7 do
        begin
          Sub := FS.ShortDayNames[i];
          P := Pos(Sub, SDate);
          if (P > 0) then
          begin
            Delete(SDate, P, Length(Sub));
            Break;
          end;
        end;
      end;
    end;
    SDate := Trim(SDate);
    //writeln('ReplaceLiterals -> ',SDate);
  end;

  procedure Split(out DStr, MStr, YStr: string);
  var
    i, P: integer;
    Sep: set of char;
    Sub: string;
  begin
    DStr := '';
    MStr := '';
    YStr := '';
    Sep := [];
    for i := 1 to Length(Fmt) do
      if not (Fmt[i] in Digits) then
        Sep := Sep + [Fmt[i]];
    //get fist part
    P := 1;
    while (P <= Length(SDate)) and (SDate[P] in Digits) do
      Inc(P);
    Sub := Copy(SDate, 1, P - 1);
    Delete(SDate, 1, P);
    if (DPos = 1) then
      DStr := Sub
    else if (MPos = 1) then
      MStr := Sub
    else
      YStr := Sub;
    //get second part
    if (SDate = '') then
      Exit;
    while (Length(SDate) > 0) and (SDate[1] in Sep) do
      Delete(SDate, 1, 1);
    if (SDate = '') then
      Exit;
    P := 1;
    while (P <= Length(SDate)) and (SDate[P] in Digits) do
      Inc(P);
    Sub := Copy(SDate, 1, P - 1);
    Delete(SDate, 1, P);
    if (DPos = 2) then
      DStr := Sub
    else if (MPos = 2) then
      MStr := Sub
    else
      YStr := Sub;
    //get thirdpart
    if (SDate = '') then
      Exit;
    while (Length(SDate) > 0) and (SDate[1] in Sep) do
      Delete(SDate, 1, 1);
    if (SDate = '') then
      Exit;
    Sub := SDate;
    if (DPos = 3) then
      DStr := Sub
    else if (MPos = 3) then
      MStr := Sub
    else
      YStr := Sub;
  end;

  procedure AdjustYear(var YY: word);
  var
    CY, CM, CD: word;
  begin
    DecodeDate(Date, CY, CM, CD);
    LY := CY mod 100;
    CY := CY - LY;
    if ((YY - LY) <= 50) then
      YY := CY + YY
    else
      YY := CY + YY - 100;
  end;

begin
  Result := NullDate;  //assume failure
  if (Length(SDate) < 5) then
    Exit; //y-m-d is minimum we support
  Fmt := UpperCase(FS.ShortDateFormat); //only care about y,m,d so this will do
  GetPositions(DPos, MPos, YPos);
  ReplaceLiterals;
  if (not (SDate[1] in Digits)) or (not (SDate[Length(SDate)] in Digits)) then
    Exit;
  Split(Dstr, MStr, YStr);
  if not TryStrToInt(DStr, LD) or not TryStrToInt(Mstr, LM) or
    not TryStrToInt(YStr, LY) then
    Exit;
  DD := LD;
  MM := LM;
  YY := LY;
  if (YY < 100) and (Pos('YYYY', UpperCase(Fmt)) = 0) then
  begin
    AdjustYear(YY);
  end;
  if not TryEncodeDate(YY, MM, DD, Result) then
    Result := NullDate;
end;

function TONDATEEDIT.TextToDate(AText: string; ADefault: TDateTime): TDateTime;
var
  FS: TFormatSettings;
begin
  if Assigned(FOnCustomDate) then
    FOnCustomDate(Self.Fedit, AText);
  if (DateOrder = doNone) then
  begin
    FS := DefaultFormatSettings;
    if (FFreeDateFormat <> '') then
      FS.ShortDateFormat := FFreeDateFormat;
    if not TryStrToDate(AText, Result, FS) then
    begin
      Result := ParseDateNoPredefinedOrder(AText, FS);
      if (Result = NullDate) then
        Result := ADefault;
    end;
  end
  else
    Result := ParseDate(AText, DateOrder, ADefault);
end;

procedure TONDATEEDIT.SetFreeDateFormat(AValue: string);
var
  D: TDateTime;
begin
  if FFreeDateFormat = AValue then
    Exit;
  if (Fedit.Text <> '') and (FDateOrder = doNone) and
    (not (csDesigning in ComponentState)) then
  begin
    D := GetDate;
    FFreeDateFormat := AValue;
    SetDate(D); //will update the text
  end
  else
    FFreeDateFormat := AValue;
end;

function TONDATEEDIT.GetDate: TDateTime;
var
  ADate: string;
  Def: TDateTime;
begin
  if (FDate = NullDate) and FDefaultToday then
    Def := SysUtils.Date
  else
    Def := FDate;
  ADate := Trim(Fedit.Text);
  //if not DirectInput then FDate matches the Text, so no need to parse it
  if {(ADate <> '') and} DirectInput then
  begin
    if (ADate = '') then
    begin
      if FDefaultToday then
        Result := SysUtils.Date
      else
        Result := NullDate;
    end
    else
    begin
      Result := TextToDate(ADate, Def);
      FDate := Result;
    end;
  end
  else
    Result := Def;
end;

procedure TONDATEEDIT.SetDate(Value: TDateTime);
begin
  FUpdatingDate := True;
  try
    if {not IsValidDate(Value) or }(Value = NullDate) then
    begin
      if DefaultToday then
        Value := SysUtils.Date
      else
        Value := NullDate;
    end;
    FDate := Value;
    Fedit.Text := DateToText(FDate);
  finally
    FUpdatingDate := False;
  end;
end;

procedure TONDATEEDIT.CalendarPopupReturnDate(Sender: TObject; const ADate: TDateTime);
var
  B: boolean;
  D: TDateTime;
begin
  try
    B := True;
    D := ADate;
    if Assigned(FOnAcceptDate) then
      FOnAcceptDate(Self.Fedit, D, B);
    if B then
      Self.Fedit.Text := DateToText(D);// D;
  except
    //    on E:Exception do
    //      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TONDATEEDIT.CalendarPopupShowHide(Sender: TObject);
begin
  FDroppedDown := (Sender as TForm).Visible;
end;

procedure TONDATEEDIT.SetDateOrder(const AValue: TDateOrder);
begin
  if FDateOrder = AValue then
    exit;
  FDateOrder := AValue;
  SetDateMask;
end;

function TONDATEEDIT.DateToText(Value: TDateTime): string;
var
  FS: TFormatSettings;
begin
  if Value = NullDate then
    Result := ''
  else
  begin
    if (FDateOrder = doNone) or (FFixedDateFormat = '') then
    begin
      FS := DefaultFormatSettings;
      if (FFreeDateFormat <> '') then
        FS.ShortDateFormat := FFreeDateFormat;
      Result := DateToStr(Value, FS);
    end
    else
      Result := FormatDateTime(FFixedDateFormat, Value);
  end;
end;

//------------------------------------------------------------------------------







 {

constructor TONScrollButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width:=30;
  Height:=30;
  Transparent := True;
  Fresim.SetSize(Width, Height);
  FNormal:=TONCustomCrop.Create;
  FHover:=TONCustomCrop.Create;
  FDisabled:=TONCustomCrop.Create;
  FPressed:=TONCustomCrop.Create;
end;

destructor TONScrollButton.Destroy;
begin
  Skindata:=nil;
  FreeAndNil(FNormal);
  FreeAndNil(FHover);
  FreeAndNil(FDisabled);
  FreeAndNil(FPressed);
  inherited Destroy;
end;
procedure TONScrollButton.MouseLeave;
begin
    if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
   if (Fdurum=bspressed) or (Fdurum=bshover)  then
   begin
    FDurum := bsnormal;
    paint;
   end;
   Inherited MouseLeave;
end;



procedure TONScrollButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  iTop: Integer;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;


  if self=TONScrollBar(Parent).FButtonCNTR then
    with TONScrollBar(Parent).FButtonCNTR do
    begin

      if Fdurum=bspressed then
      begin
          if TONScrollBar(Parent).State = Fdikey then
          begin
            FTOP := TONScrollBar(Parent).FbuttonLT.Height;
            FBOTTOM := TONScrollBar(Parent).Height-TONScrollBar(Parent).FbuttonRB.Height;

            iTop := Top + Y - FYo;
            if iTop < FTOP then
            begin
             iTop := FTOP;
            end;
            if (iTop > FBOTTOM) or ((iTop + Height) > FBOTTOM) then
            begin
             iTop := FBOTTOM - Height;
            end;
            Top := iTop;
            TONScrollBar(Parent).Position:=iTop-TONScrollBar(Parent).FbuttonLT.Height;
            TONScrollBar(Parent).Position:= Round(Abs((iTop - TONScrollBar(Parent).Min) / (TONScrollBar(Parent).Max - TONScrollBar(Parent).Min)) * TONScrollBar(Parent).Height);
          end
          else
          begin
            FTOP := TONScrollBar(Parent).FbuttonLT.Width;
            FBOTTOM := TONScrollBar(Parent).Width-(TONScrollBar(Parent).FbuttonRB.Width);

            iTop := Left + X - FXo;
            if iTop < FTOP then
            begin
             iTop := FTOP;
            end;
            if (iTop > FBOTTOM) or ((iTop + Width) > FBOTTOM) then
            begin
             iTop := FBOTTOM - Width;
            end;
            Left := iTop;


            TONScrollBar(Parent).Position:= Round(Abs((iTop - TONScrollBar(Parent).Min) / (TONScrollBar(Parent).Max - TONScrollBar(Parent).Min)) * (TONScrollBar(Parent).Width-self.Width));


          end;

    //    TONScrollBar(Parent).FPosition := TONScrollBar(Parent).PositionFromThumb;
    //    TONScrollBar(Parent).DoPositionChange;
    //    Paint;
       Width:=round(abs((TONScrollBar(Parent).Max-TONScrollBar(Parent).Min)/TONScrollBar(Parent).Width));
      end else
      begin
       Fdurum:=bsnormal;
      end;
      Paint;

    end;


  inherited MouseMove(Shift,X,Y);
end;

procedure TONScrollButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bsnormal then
    Exit;
  FDurum := bsnormal;
  paint;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TONScrollButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
//  if FDurum = bspressed then
//    Exit;

  if (Button = mbleft) and (FDurum<>bspressed) then FDurum := bspressed;
  FXo := X;
  FYo := Y;
//  FDurum := bspressed;
  paint;

  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TONScrollButton.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FDurum = bshover then
    Exit;

  FDurum := bshover;
  Paint;
  inherited;
end;

// -----------------------------------------------------------------------------
procedure TONScrollButton.paint;
var
  DR: Trect;
begin

   if (FSkindata <> nil) or not (csDestroying in ComponentState) then
  begin
    try

      if Enabled = True then
      begin

          case FDurum of
            bsNormal: DR := Rect(FNormal.FSLeft, FNormal.FSTop,
                FNormal.FSRight, FNormal.FSBottom);
            bspressed: DR := Rect(FPressed.FSLeft, FPressed.FSTop,
                FPressed.FSRight, FPressed.FSBottom);
            bshover: DR := Rect(FHover.FSLeft, FHover.FSTop,
                FHover.FSRight, FHover.FSBottom);
          end;

      end else
      begin

           DR := Rect(FDisabled.FSLeft, FDisabled.FSTop, FDisabled.FSRight, FDisabled.FSBottom);

      end;
//      HEDEF := Rect(0, 0, self.Width, self.Height);
//      DrawPartstrechRegion(DR,Self,Width,Height,HEDEF,false);
      DrawPartstrech(DR, self, Width, Height);
      Transparent:=true;
    finally
    end;

//  end
//  else
//  begin
//   Fresim.Fill(BGRA(207, 220, 207), dmSet);
//  end;
   inherited;
   end;
end;

}




















constructor TONPanelControl.Create(AOwner: TComponent);
begin
  inherited;
  SetBounds(Left, Top, 145, 185);
  Fresim.SetSize(Width,Height);
  FItems          := TStringList.Create;
  FItemsRect      := TList.Create;
  FItems.OnChange := @ItemsChanged;
  FItemSpacing    := 0;
  FActiveItem     := -1;
  FMouseInControl := False;
  SetExpanded(True);

end;

// -----------------------------------------------------------------------------

destructor TONPanelControl.Destroy;
begin
  FItems.Free;
  FItemsRect.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetActiveItem(Value: SmallInt);
begin
  if FItems <> NIL then
  begin
    if Value > (FItems.Count - 1) then
      Value := FItems.Count - 1
    else if Value < -1 then
      Value := -1;

    FActiveItem := Value;
    if Assigned(FOnItemChanged) then FOnItemChanged(Self);
    Paint;
  end
  else
    FActiveItem := -1;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetItems(Value: TStringList);
var
  i: Integer;
begin
  FItems.Assign(Value);
  if FItems.Count = 0 then
    FActiveItem := 0
  else
  begin
    if (FItems.Count - 1) < FActiveItem then FActiveItem := FItems.Count - 1;
    for i := 0 to FItems.Count - 1 do
      FItems[i] := Trim(FItems[i]);
  end;

  SetItemRect;
  SetPanelSize;
  Paint;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetItemSpacing(Value: Byte);
begin
  if Value < 1 then Value := 1;
  FItemSpacing := Value;
  SetItemRect;
  Paint;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetCaption(Value: String);
begin
  if Value = FCaption then Exit;
  FCaption     := Value;
  FCaptionRect := Rect(0, 6, Width, Canvas.TextHeight(Value) + 17);
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetItemRect;
var
  TabCount : Integer;
  TabRect  : PRect;
  Position : TPoint;
  CaptionTextHeight : Integer;
begin
  Canvas.Font := Font;
  FItemsRect.Clear;

  Position := Point(FItemSpacing, FCaptionRect.Bottom - FCaptionRect.Top + FItemSpacing);

  for TabCount := 0 to (FItems.Count - 1) do
  begin
    New(TabRect);
    CaptionTextHeight := Canvas.TextHeight(FItems[TabCount]);

    TabRect^ := Bounds(Position.X, Position.y, FCaptionRect.Right, CaptionTextHeight);
    Position := Point(Position.X, Position.y + FItemSpacing);

    FItemsRect.Add(TabRect);
  end;

  FItemsRect.Capacity := FItemsRect.Count;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetPanelSize;
begin
  if FExpanded then
    Height := FCaptionRect.Bottom - FCaptionRect.Top + (FItemSpacing * (FItems.Count + 1)) + (FItemSpacing div 2)
  else
    Height := FCaptionRect.Bottom;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.SetExpanded(Value: Boolean);
begin
  FExpanded := Value;
  SetPanelSize;

  if Assigned(FOnExpanded) then FOnExpanded(Self, FExpanded);
end;

// -----------------------------------------------------------------------------
{
procedure TONPanelControl.SetArrow(Value: TUSBitmap32);
begin
  FArrow.Assign(Value);
  Paint;
end;
}
// -----------------------------------------------------------------------------

procedure TONPanelControl.Paint;
var
//  Buffer    : TBGRABitmap;
  TabCount  : Integer;
  TempRect  : TRect;
  CursorPos : TPoint;
  aa:TTextStyle;
  procedure DrawGradient(const ARect: TRect; const FromColor, ToColor: Integer;
    ASteps: Byte = 128);
  var
    Deltas : array[0..2] of Real; // R,G,B
    i, Len : Integer;
    j      : Real;
    r      : TRect;
  begin
    Len := (ARect.Right-ARect.Left);
    if ASteps > Len then ASteps := Len;

    Deltas[0] := (GetRValue(ToColor) - GetRValue(FromColor)) / ASteps;
    Deltas[1] := (GetGValue(ToColor) - GetGValue(FromColor)) / ASteps;
    Deltas[2] := (GetBValue(ToColor) - GetBValue(FromColor)) / ASteps;

    j := Len / ASteps;

    for i := 0 to ASteps - 1 do
    begin
      r := Rect(Round(i * j), ARect.Top, Round((i + 1) * j), ARect.Bottom);

      Fresim.FillRect(r,BGRA(Round(GetRValue(FromColor) + i * Deltas[0]),
        Round(GetGValue(FromColor) + i * Deltas[1]),
        Round(GetBValue(FromColor) + i * Deltas[2])));
    end;
  end;

begin

  try
    if Skindata<> nil then
     begin
    Fresim.SetSize(Width, Height);
 //   Buffer.Font := Font;

    TempRect := Rect(ClientRect.Left, ClientRect.Top, ClientRect.Right, ClientRect.Bottom);
    Fresim.FillRect(TempRect, BGRA(153,59,78),dmSet);

//    if FExpanded then
//    begin
//      TempRect := Rect(ClientRect.Left, FCaptionRect.Bottom, ClientRect.Right, ClientRect.Bottom);
//      Fresim.FillRect(TempRect, BGRABlack,dmSet);
//    end;

{    DrawGradient(FCaptionRect, RGB(11, 37, 107), RGB(166, 202, 240));

    Fresim.FillRect(0, 6, 1, 8, BGRABlack,dmSet);
    Fresim.FillRect(0, 6, 2, 7, BGRABlack,dmSet);
    Fresim.FillRect(ClientRect.Right-1, 6, ClientRect.Right, 8, BGRABlack,dmSet);
    Fresim.FillRect(ClientRect.Right-2, 6, ClientRect.Right, 7, BGRABlack,dmSet);
}



    fresim.GradientFill(0,0,FCaptionRect.Right,FCaptionRect.Bottom,BGRA(11, 37, 107), BGRA(166, 202, 240), gtLinear, PointF(0, 0), PointF(0, FCaptionRect.Bottom), dmSet);


    {  if not Fresim.Empty then
    begin
      Fresim.Draw(Buffer.Canvas, 4, 0,false);
      TempRect := Rect(FCaptionRect.Left + Fresim.Width + 8, FCaptionRect.Top, FCaptionRect.Right, FCaptionRect.Bottom);
    end
    else
    }
  //  TempRect := Rect(FCaptionRect.Left + Fresim.Width + 8, FCaptionRect.Top, FCaptionRect.Right, FCaptionRect.Bottom);

    TempRect := Rect(FCaptionRect.Left + 8, FCaptionRect.Top, FCaptionRect.Right, FCaptionRect.Bottom);

    {

    if not FArrow.Empty then
    begin
      if FExpanded then
        FArrow.DrawTo(Buffer, FCaptionRect.Right - FArrow.Width - 2, FCaptionRect.Top + 2, Bounds(0, FArrow.Height div 2, FArrow.Width, FArrow.Height div 2))
      else
        FArrow.DrawTo(Buffer, FCaptionRect.Right - FArrow.Width - 2, FCaptionRect.Top + 2, Bounds(0, 0, FArrow.Width, FArrow.Height div 2));
    end;

    }

    GetCursorPos(CursorPos);
    CursorPos := ScreenToClient(CursorPos);
     Fresim.FontStyle := [fsBold];

    if FMouseInControl and PtInRect(FCaptionRect, CursorPos) then
       fresim.TextRect(TempRect,10,Length(FCaption),FCaption,aa,BGRA(133, 146, 181))
    else
       fresim.TextRect(TempRect,10,Length(FCaption),FCaption,aa,BGRAWhite);

    if FExpanded then
      for TabCount := 0 to FItems.Count - 1 do
      begin
        TempRect := PRect(FItemsRect.Items[TabCount])^;
        Fresim.canvas.Font.Color := clblack;// Font.Color;

        if TabCount = FActiveItem then
       //   Fresim.FillRect(TempRect,BGRA(216,55,99))
           DrawGradient(TempRect,RGB(11, 37, 107), RGB(166, 202, 240))
        else
         Fresim.FillRect(TempRect,BGRA(16,155,159));


        if TabCount = FActiveItem then
          Fresim.FontStyle := [fsBold]
        else
          Fresim.FontStyle := [];

      //  fresim.FontHeight:=-8;
        fresim.FontName:='calibri';

        if FMouseInControl and PtInRect(TempRect, CursorPos) then
          Fresim.FontStyle := Fresim.FontStyle + [fsUnderline];

  //      Buffer.UpdateFont;
       // fresim.TextOut(5,11);

        fresim.TextRect(TempRect,TempRect.Left, ((11*TabCount)+fresim.Canvas.TextHeight(FItems[TabCount])),FItems[TabCount],aa,BGRABlack);
   //     (11*TabCount)+fresim.Canvas.TextHeight(FItems[TabCount])
      //  DrawText(Fresim.canvas.Handle, PChar(FItems[TabCount]), Length(FItems[TabCount]), TempRect, DT_VCENTER or DT_SINGLELINE);
     // Fresim.TextOut(5,(11*TabCount)+fresim.Canvas.TextHeight(FItems[TabCount]),FItems[TabCount],BGRABlack);
      end;

     end;
Inherited;
  //  buffer.Draw(fresim.canvas,0,0,false);
  //  MyBitBlt(Canvas.Handle, 0, 0, Buffer.Width, Buffer.Height, Buffer.bitmap.Handle, 0, 0);
  finally
//    Buffer.free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.CheckOthersPanels;
var
  i: Integer;
begin
  if Parent.ControlCount > 0 then
    for i := 0 to Parent.ControlCount - 1 do
      if (Parent.Controls[i] is TONPanelControl) then
        with (Parent.Controls[i] as TONPanelControl) do
          if Self.Name <> Name then
            ActiveItem := -1;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CursorPos   : TPoint;
  CurrentTab  : Integer;
  CurrentRect : PRect;
begin
  GetCursorPos(CursorPos);
  CursorPos := ScreenToClient(CursorPos);

  if PtInRect(FCaptionRect, CursorPos) then
    SetExpanded(not FExpanded)
  else if FItems.Count > 0 then
  begin
    for CurrentTab := 0 to FItems.Count - 1 do
    begin
      CurrentRect := FItemsRect.Items[CurrentTab];
      if PtInRect(CurrentRect^, CursorPos) then
        if (FActiveItem <> CurrentTab) then
        begin
          CheckOthersPanels;
          SetActiveItem(CurrentTab);
          Break;
        end;
    end;
  end;

  inherited;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  Paint;
  inherited MouseMove(Shift, X, Y);
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.MouseEnter;
begin
  FMouseInControl := True;
  Paint;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.MouseLeave;
begin
  FMouseInControl := False;
  Paint;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TONPanelControl.ItemsChanged(Sender: TObject);
begin
  SetItemRect;
  Paint;
end;

procedure TONPanelControl.SetSkindata(Aimg: TONImg);
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











// -----------------------------------------------------------------------------

{ TONScrollBar }

// -----------------------------------------------------------------------------
constructor TONScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle       := ControlStyle + [csClickEvents, csCaptureMouse];
  FNormali           := TONCUSTOMCROP.Create;
  FNormali.cropname  := 'NORMAL';
  Fsol               := TONCUSTOMCROP.Create;
  Fsol.cropname      := 'LEFT';
  Fsag               := TONCUSTOMCROP.Create;
  Fsag.cropname      := 'RIGHT';
  Fust               := TONCUSTOMCROP.Create;
  Fust.cropname      := 'TOP';
  Falt               := TONCUSTOMCROP.Create;
  Falt.cropname      := 'BOTTOM';
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

  FDurump           := Fhorizontal;
  Fdurum            := bsnormal;
  FdurumCNTR        := bsnormal;
  FdurumLR          := bsnormal;
  FdurumRB          := bsnormal;
  Width             := 100;
  Height            := 30;
  Fresim.SetSize(Width, Height);
  Fmin              := 0;
  Fmax              := 100;
  Fposition         := 0;
  Fcrop             := true;
  FCaption          := '';
  Fpagesize         := 20;
{  FbuttonLT         := Rect(0,0,FbuttonLT.Width,self.Height);
  FbuttonRB         := Rect(self.Width-(Fsol.FSRight - Fsol.FSLeft),0,self.Width,self.Height);
  trackarea         := Rect(FbuttonLT.Right-FbuttonLT.Left,0,self.Width-(FbuttonRB.Right-FbuttonRB.Left),Height);
//  Fthumbsize        := abs(100 * round((trackarea.Width - Fmax) / Fmax));
  Fthumbsize        := FbuttonCN.ORIGHT-FbuttonCN.OLEFT;
  FButtonCNTR       := rect(trackarea.Left,0, Fthumbsize,self.Height);
  }
  OnResize          := @Resize;
  OnClick           := @Butonclick;
  trackarea         := Rect(0,0,0,0);
  Parent            := AOwner as TWinControl;
  Buttonsizeset;

end;

// -----------------------------------------------------------------------------

destructor TONScrollBar.Destroy;
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
  FreeAndNil(Fsag);
  FreeAndNil(Fsol);
  FreeAndNil(Fbar);
  FreeAndNil(Falt);
  FreeAndNil(Fust);
  inherited;
end;

procedure TONScrollBar.SetSkindata(Aimg: TONImg);
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

// -----------------------------------------------------------------------------
procedure TONScrollBar.SetState(val: TONProgressState);
begin
  if FDurump <> val then
   begin
    FDurump   := val;
    Buttonsizeset;
    Paint;
  end;
end;
// -----------------------------------------------------------------------------

procedure TONScrollBar.MouseLeave;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;

  FdurumCNTR := bsnormal;
  FdurumRB   := bsnormal;
  FdurumLR   := bsnormal;
  FDurum     := bsnormal;
  paint;
  Inherited MouseLeave;
end;



procedure TONScrollBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  iTop_left,Ftop_left,Fbottom_right: Integer;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);

  if (FdurumCNTR=bspressed) then
   begin
//    if PtInRect(FButtonCNTR, Cursorpos) then
//    begin
       if FDurump = Fvertical then
       begin

         Ftop_left     := FbuttonLT.Bottom-FbuttonLT.Top;
         Fbottom_right := Height-(FbuttonRB.Bottom-FbuttonRB.Top);
         trackarea     := Rect(0,Ftop_left,Width,Fbottom_right);
         iTop_left     := Y-Ftop_left;


         if iTop_left < Trackarea.Top then
         begin
           iTop_left := Ftop_left;
         end;

          if (iTop_left+Fthumbsize > Trackarea.bottom) then
          begin
            iTop_left:=Trackarea.bottom-Fthumbsize;
          end;

        FButtonCNTR.Top     := iTop_left;
        FButtonCNTR.Bottom  := iTop_left+Fthumbsize;
        FButtonCNTR.left    := 0;
        FButtonCNTR.Right   := self.Width;

          //thumsize min değeri yapalım ondan küçük olmasın

     //     if PtInRect(Trackarea, Cursorpos) then
     //     begin
         if FButtonCNTR.top=trackarea.top then
          Fposition:=0
         else
         if FButtonCNTR.bottom=trackarea.Height then
          Fposition:=100
         else
          FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.top)/trackarea.Height);



       // iTop_left     := FButtonCNTR.Top + Y - FYo;

       { if iTop_left  < Ftop_left then
        begin
         iTop_left    := Ftop_left;
        end;
        if (iTop_left > Fbottom_right) or ((iTop_left + FButtonCNTR.Height) > Fbottom_right) then
        begin
         iTop_left    := Fbottom_right - FButtonCNTR.Height;
        end;
        FButtonCNTR.Top := iTop_left;
        FPosition:=Round(100 * abs(FButtonCNTR.top-trackarea.top)/trackarea.Height);
        }
       end else
       begin

          Ftop_left     := FbuttonLT.Right-FbuttonLT.Left;
          Fbottom_right := Width-(FbuttonRB.Right-FbuttonRB.Left);
          trackarea     := Rect(Ftop_left,0,Fbottom_right,Height);
          iTop_left     := x-Ftop_left;

          if iTop_left < Trackarea.Left then
          begin
           iTop_left := Ftop_left;
          end;

          if (iTop_left+Fthumbsize > Trackarea.Right) then
          begin
            iTop_left:=Trackarea.Right-Fthumbsize;
          end;

          FButtonCNTR.Left   := iTop_left;
          FButtonCNTR.Right  := iTop_left+Fthumbsize;
          FButtonCNTR.Top    := 0;
          FButtonCNTR.bottom := self.Height;

          //thumsize min değeri yapalım ondan küçük olmasın

     //     if PtInRect(Trackarea, Cursorpos) then
     //     begin
         if FButtonCNTR.left=trackarea.Left then
          Fposition:=0
         else
         if FButtonCNTR.Right=trackarea.Width then
          Fposition:=100
         else
          FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.left)/trackarea.Width);


      //    end;
       end;
   paint;
 end;
  inherited MouseMove(Shift,X,Y);
end;






procedure TONScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
//  if(not Enabled) or (FDurum = bshover) and (FdurumRB=bshover) and (FdurumLR=bshover) and (FdurumCNTR=bshover) then
//    Exit;

    GetCursorPos(Cursorpos);
    Cursorpos := ScreenToClient(Cursorpos);
    if  (PtInRect(FbuttonLT, Cursorpos)) then
    begin
        FdurumLR   := bshover;
        FdurumRB   := bsnormal;
        FdurumCNTR := bsnormal;
    end else

    if  (PtInRect(FbuttonRB, Cursorpos)) then
    begin
        FdurumRB   := bshover;
        FdurumLR   := bsnormal;
        FdurumCNTR := bsnormal;
    end else

    if (PtInRect(FButtonCNTR, Cursorpos)) then
    begin
        FdurumCNTR := bshover;
        FdurumRB   := bsnormal;
        FdurumLR   := bsnormal;
    end else
    FDurum := bshover;

    Paint;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TONScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  iTop_left: Integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
//  if (FDurum = bspressed) and (FdurumRB=bspressed) and (FdurumLR=bspressed) and (FdurumCNTR=bspressed) then
//    Exit;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);
  if (Button = mbleft) and (PtInRect(FbuttonLT, Cursorpos)) then// or  PtInRect(FbuttonRB, Cursorp) then
  begin
      FdurumLR   := bspressed;
      FdurumRB   := bsnormal;
      FdurumCNTR := bsnormal;

      if FDurump=Fhorizontal then
      begin
          trackarea     := Rect(FbuttonLT.Right-FbuttonLT.Left,0,Width-(FbuttonRB.Right-FbuttonRB.Left),Height);

          iTop_left     := FButtonCNTR.Left-Pagesize;// -Ftop_left;

          if iTop_left < Trackarea.Left then
          begin
           iTop_left := FbuttonLT.Right-FbuttonLT.Left;//Ftop_left;
          end;

          if (iTop_left+Fthumbsize > Trackarea.Right) then
          begin
            iTop_left:=Trackarea.Right-Fthumbsize;
          end;


          FButtonCNTR.Left   := iTop_left;
          FButtonCNTR.Right  := iTop_left+Fthumbsize;
          FButtonCNTR.Top    := 0;
          FButtonCNTR.bottom := self.Height;

         if FButtonCNTR.left=trackarea.Left then
          Fposition:=0
         else
         if FButtonCNTR.Right=trackarea.Width then
          Fposition:=100
         else
          FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.left)/trackarea.Width);

      end else
      begin
          trackarea     := Rect(0,FbuttonLT.Bottom-FbuttonLT.top,Width,Height-(FbuttonRB.Bottom-FbuttonRB.Top));

          iTop_left     := FButtonCNTR.Top-Pagesize;// -Ftop_left;

          if iTop_left < Trackarea.Top then
          begin
           iTop_left := FbuttonLT.Bottom-FbuttonLT.Top;//Ftop_left;
          end;

          if (iTop_left+Fthumbsize > Trackarea.Bottom) then
          begin
            iTop_left:=Trackarea.Bottom-Fthumbsize;
          end;


          FButtonCNTR.Top     := iTop_left;
          FButtonCNTR.Bottom  := iTop_left+Fthumbsize;
          FButtonCNTR.Left    := 0;
          FButtonCNTR.Right   := self.Width;

         if FButtonCNTR.Top=trackarea.Top then
          Fposition:=0
         else
         if FButtonCNTR.Bottom=trackarea.Height then
          Fposition:=100
         else
          FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.Top)/trackarea.Height);

      end;

  end else

  if  (Button = mbleft) and (PtInRect(FbuttonRB, Cursorpos)) then
  begin
      FdurumRB   := bspressed;
      FdurumLR   := bsnormal;
      FdurumCNTR := bsnormal;

      if FDurump=Fhorizontal then
      begin
        trackarea     := Rect(FbuttonLT.Right-FbuttonLT.Left,0,Width-(FbuttonRB.Right-FbuttonRB.Left),Height);

        iTop_left     := FButtonCNTR.Left+Pagesize;// -Ftop_left;

        if iTop_left < Trackarea.Left then
        begin
         iTop_left := FbuttonLT.Right-FbuttonLT.Left;//Ftop_left;
        end;

        if (iTop_left+Fthumbsize > Trackarea.Right) then
        begin
          iTop_left:=Trackarea.Right-Fthumbsize;
        end;

        FButtonCNTR.Left   := iTop_left;
        FButtonCNTR.Right  := iTop_left+Fthumbsize;
        FButtonCNTR.Top    := 0;
        FButtonCNTR.bottom := self.Height;

       if FButtonCNTR.left=trackarea.Left then
        Fposition:=0
       else
       if FButtonCNTR.Right=trackarea.Width then
        Fposition:=100
       else
        FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.left)/trackarea.Width);
      end else
      begin

        trackarea     := Rect(0,FbuttonLT.Bottom-FbuttonLT.top,Width,Height-(FbuttonRB.Bottom-FbuttonRB.Top));

        iTop_left     := FButtonCNTR.Top+Pagesize;// -Ftop_left;

        if iTop_left < Trackarea.Top then
        begin
         iTop_left := FbuttonLT.Bottom-FbuttonLT.Top;//Ftop_left;
        end;

        if (iTop_left+Fthumbsize > Trackarea.Bottom) then
        begin
          iTop_left:=Trackarea.bottom-Fthumbsize;
        end;

        FButtonCNTR.top     := iTop_left;
        FButtonCNTR.bottom  := iTop_left+Fthumbsize;
        FButtonCNTR.left    := 0;
        FButtonCNTR.Right   := self.Width;

       if FButtonCNTR.Top=trackarea.Top then
        Fposition:=0
       else
       if FButtonCNTR.Bottom=trackarea.Height then
        Fposition:=100
       else
        FPosition:=Round(100 * abs((iTop_left+Fthumbsize)-trackarea.Top)/trackarea.Height);
      end;


  end else

  if (Button = mbleft) and (PtInRect(FButtonCNTR, Cursorpos)) then
  begin
      FdurumCNTR := bspressed;
      FdurumRB   := bsnormal;
      FdurumLR   := bsnormal;
  end else
  FDurum := bspressed;

  paint;

  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TONScrollBar.MouseEnter;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if (FDurum = bshover) and (FdurumRB=bshover) and (FdurumLR=bshover) and (FdurumCNTR=bshover) then
    Exit;

   GetCursorPos(Cursorpos);
    Cursorpos := ScreenToClient(Cursorpos);
    if  (PtInRect(FbuttonLT, Cursorpos)) then
    begin
        FdurumLR   := bshover;
        FdurumRB   := bsnormal;
        FdurumCNTR := bsnormal;
    end else

    if  (PtInRect(FbuttonRB, Cursorpos)) then
    begin
        FdurumRB   := bshover;
        FdurumLR   := bsnormal;
        FdurumCNTR := bsnormal;
    end else

    if (PtInRect(FButtonCNTR, Cursorpos)) then
    begin
        FdurumCNTR := bshover;
        FdurumRB   := bsnormal;
        FdurumLR   := bsnormal;
    end else
    FDurum := bshover;

    Paint;
  inherited;
end;

procedure TONScrollBar.paint;
var
DR: TRect;
begin
  Fresim.SetSize(self.Width, self.Height);
  if (FSkindata <> nil) then
  begin
    try

     if (trackarea=EmptyRect) or (trackarea=Rect(0,0,0,0)) or (position=0) then
     buttonsizeset;

      if FDurump=Fhorizontal then
      begin
       FbuttonLT   := Rect(0,0,(Fsol.FSRight - Fsol.FSLeft),self.Height);
       FbuttonRB   := Rect(self.Width-(Fsol.FSRight - Fsol.FSLeft),0,self.Width,self.Height);
      end else
      begin
       FbuttonLT := Rect(0,0,self.Width,(Fust.FSBottom - Fust.FSTop));
       FbuttonRB := Rect(0,self.Height-(Fust.FSBottom - Fust.FSTop),self.Width,self.Height);
      end;



      if FDurump = Fhorizontal then   //left image if state horizontal
      begin
        DR := Rect(Fsol.FSLeft, Fsol.FSTop, Fsol.FSRight, Fsol.FSBottom);
        DrawPartstrechRegion(DR,self,Fsol.FSRight-Fsol.FSLeft,Height,rect(0, 0, Fsol.FSRight - Fsol.FSLeft, Height), False);
      end
      else         //top image if state vertical
      begin
        DR := Rect(Fust.FSLeft, Fust.FSTop, Fust.FSRight, Fust.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,Fust.FSBottom - Fust.FSTop,rect(0, 0, Width, Fust.FSBottom - Fust.FSTop), False);
      end;


      if FDurump = Fhorizontal then  //right image if state horizontal
      begin
        DR := Rect(Fsag.FSLeft, Fsag.FSTop, Fsag.FSRight, Fsag.FSBottom);
        DrawPartstrechRegion(DR,self,(fsag.FSRight - Fsag.FSLeft),self.Height,Rect(self.Width -(fsag.FSRight - Fsag.FSLeft), 0, self.Width, self.Height),false);
      end
      else       //bottom image if state vertical
      begin
        DR := Rect(Falt.FSLeft, Falt.FSTop, Falt.FSRight, Falt.FSBottom);
        DrawPartstrechRegion(DR,self,self.Width,(Falt.FSBottom - Falt.FSTop),Rect(0, self.Height-(Falt.FSBottom - Falt.FSTop), self.Width, self.Height),false);
      end;

      DR := Rect(FNormali.FSLeft, FNormali.FSTop, FNormali.FSRight, FNormali.FSBottom);
      if FDurump = Fhorizontal then  //center image if state horizontal
      begin
        DrawPartstrechRegion(DR,self,self.Width-((Fsol.FSRight - Fsol.FSLeft)+(fsag.FSRight - Fsag.FSLeft)),self.Height,Rect((Fsol.FSRight - Fsol.FSLeft), 0, (Width - (fsag.FSRight - Fsag.FSLeft)), Height),false);
      end
      else         //center image if state vertical
      begin
        DrawPartstrechRegion(DR,self,Width,Height-((Fust.FSBottom - Fust.FSTop)+(Falt.FSBottom - Falt.FSTop)),Rect(0, (Fust.FSBottom - Fust.FSTop), Width, Height-(Falt.FSBottom - Falt.FSTop)),false);
      end;


      if Crop=true then
        CropToimg(Fresim);


      /////LEFT-RIGHT or TOP-BOTTOM BUTTON DRAW
      if Enabled=true then
      begin
        case FdurumLR of
           bsnormal   : DR := Rect(FbuttonNL.FSLeft, FbuttonNL.FSTop, FbuttonNL.FSRight, FbuttonNL.FSBottom);
           bshover : DR := Rect(FbuttonUL.FSLeft, FbuttonUL.FSTop, FbuttonUL.FSRight, FbuttonUL.FSBottom);
           bspressed   : DR := Rect(FbuttonBL.FSLeft, FbuttonBL.FSTop, FbuttonBL.FSRight, FbuttonBL.FSBottom);
        end;
      end else
      begin
       DR := Rect(FbuttonDL.FSLeft, FbuttonDL.FSTop, FbuttonDL.FSRight, FbuttonDL.FSBottom);
      end;

       //{top}
       DrawPartnormal(DR,self,FbuttonLT,false);

       if Enabled=true then
      begin
        case FdurumRB of
           bsnormal   : DR := Rect(FbuttonNR.FSLeft, FbuttonNR.FSTop, FbuttonNR.FSRight, FbuttonNR.FSBottom);
           bshover : DR := Rect(FbuttonUR.FSLeft, FbuttonUR.FSTop, FbuttonUR.FSRight, FbuttonUR.FSBottom);
           bspressed   : DR := Rect(FbuttonBR.FSLeft, FbuttonBR.FSTop, FbuttonBR.FSRight, FbuttonBR.FSBottom);
        end;
      end else
      begin
       DR := Rect(FbuttonDR.FSLeft, FbuttonDR.FSTop, FbuttonDR.FSRight, FbuttonDR.FSBottom);
      end;

       {bottom} DrawPartnormal(DR,self,FbuttonRB,false);

      /////LEFT-RIGHT or TOP-BOTTOM BUTTON DRAW END



      /////CENTER BUTTON DRAW
      if Enabled=true then
      begin
      case FdurumCNTR of
         bsnormal   : DR := Rect(FbuttonCN.FSLeft, FbuttonCN.FSTop, FbuttonCN.FSRight, FbuttonCN.FSBottom);
         bshover : DR := Rect(FbuttonCU.FSLeft, FbuttonCU.FSTop, FbuttonCU.FSRight, FbuttonCU.FSBottom);
         bspressed   : DR := Rect(FbuttonCB.FSLeft, FbuttonCB.FSTop, FbuttonCB.FSRight, FbuttonCB.FSBottom);
       end;
      end else
      begin
       DR := Rect(FbuttonCD.FSLeft, FbuttonCD.FSTop, FbuttonCD.FSRight, FbuttonCD.FSBottom);
      end;

       DrawPartnormal(DR,self,FButtonCNTR,false);

      //// CENTER BUTTON DRAW END


   //  FCaption := '%' + floattostr(Position);


    finally
    end;
  end;
 inherited;
end;

// -----------------------------------------------------------------------------
procedure TONScrollBar.CMHittest(var msg: TCMHIttest);
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  if PtInRegion(WindowRgn, msg.XPos, msg.YPos) then
    msg.Result := HTCLIENT
  else
    msg.Result := HTNOWHERE;

end;

procedure TONScrollBar.Setaz(Val: integer);
begin
  if Fmin <> Val then
  begin
    Fmin := Val;
    Buttonsizeset;
  end;
end;

procedure TONScrollBar.Setcok(Val: integer);
begin
  if Fmax <> Val then
  begin
    Fmax := Val;
    Buttonsizeset;
  end;
end;

procedure TONScrollBar.Setdeger(Val: integer);
begin
  if Fposition <> Val then
  begin
    Fposition := Val;
    Paint;
  end;
end;


procedure TONScrollBar.Butonclick(sender:Tobject);
begin
end;




procedure TONScrollBar.Buttonsizeset;
begin
  if FDurump=Fhorizontal then
    begin
     FbuttonLT          := Rect(0,0,(Fsol.FSRight - Fsol.FSLeft),self.Height);
     FbuttonRB          := Rect(self.Width-(Fsol.FSRight - Fsol.FSLeft),0,self.Width,self.Height);
     trackarea          := Rect(FbuttonLT.Right-FbuttonLT.Left,0,self.Width-(FbuttonRB.Right-FbuttonRB.Left),Height);
     Fthumbsize         := FbuttonCN.ORIGHT-FbuttonCN.OLEFT;


     if Position=0 then
      FButtonCNTR.Left  := FbuttonLT.Right+2
     else
      FButtonCNTR.Left  := Position;

     FButtonCNTR.Right  := FButtonCNTR.Left+Fthumbsize;

     FButtonCNTR.Top    := 0;
     FButtonCNTR.bottom := self.Height;


    end else
    begin
     FbuttonLT          := Rect(0,0,self.Width,(Fust.FSBottom - Fust.FSTop));
     FbuttonRB          := Rect(0,self.Height-(Fust.FSBottom - Fust.FSTop),self.Width,self.Height);
     trackarea          := Rect(FbuttonLT.Bottom-FbuttonLT.Top,0,self.Height-(FbuttonRB.Bottom-FbuttonRB.Top),Width);
     Fthumbsize         := FbuttonCN.OBOTTOM-FbuttonCN.OTOP;

     if Position=0 then
      FButtonCNTR.top   := FbuttonLT.Bottom+2
     else
      FButtonCNTR.top   := Position;

     FButtonCNTR.Bottom := FButtonCNTR.top +Fthumbsize;
     FButtonCNTR.Left   := 0;
     FButtonCNTR.Right  := self.Width;
    end;
end;


procedure TONScrollBar.Resize(sender:TObject);
begin
 if (csDesigning in ComponentState)  then
  begin
   if FDurump = Fhorizontal then
   begin
    Buttonsizeset;
   end;
 end;
end;

procedure TONScrollBar.SetFpagesize(val: integer);
begin
 if Fpagesize<>val then
   Fpagesize:=val;
end;




//////////////////////TONScrollBar End////////////////////////////////////////////




/////////////////// TONListbox ///////////////////////////////////////////////////

constructor TONListbox.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   parent               := TWinControl(AOwner);
   ControlStyle         := ControlStyle + [csClickEvents, csCaptureMouse, csAcceptsControls];
   FUst                 := TONCUSTOMCROP.Create;
   FUST.cropname        := 'TOP';
   FAlt                 := TONCUSTOMCROP.Create;
   FAlt.cropname        := 'BOTTOM';
   FOrta                := TONCUSTOMCROP.Create;
   FOrta.cropname       := 'CENTER';
   FSag                 := TONCUSTOMCROP.Create;
   FSag.cropname        := 'RIGHT';
   FSagust              := TONCUSTOMCROP.Create;
   FSagust.cropname     := 'TOPRIGHT';
   FSagalt              := TONCUSTOMCROP.Create;
   FSagalt.cropname     := 'BOTTOMRIGHT';
   FSol                 := TONCUSTOMCROP.Create;
   FSol.cropname        := 'LEFT';
   FSolust              := TONCUSTOMCROP.Create;
   FSolust.cropname     := 'TOPLEFT';
   FSolalt              := TONCUSTOMCROP.Create;
   FSolalt.cropname     := 'BOTTOMLEFT';

   Factiveitems         := TONCUSTOMCROP.Create;
   Factiveitems.cropname:= 'ACTIVEITEM';


   Self.Height        := 190;
   Self.Width         := 190;
   FCrop              := True;
   Fresim.SetSize(Width,Height);
   
     FVScrollbar        := TONScrollBar.Create(self);

     with FVScrollbar do
     begin
      Parent      := self;
      name        := 'right_scroll';
      State       := Fvertical;
      Height      := self.Height;
      Width       := 20;
      Top         := 0;
      left        := self.Width-Width;
  //    Skindata    := self.Skindata;
      SetSubComponent(true);
      Position    := 0;
      Visible     := true;
     end;

     FHScrollbar     := TONScrollBar.Create(self);
     with FHScrollbar do
     begin
      Parent      := self;
      name        := 'bottom_scroll';
      State       := Fhorizontal;
      Height      := 20;
      Width       := Self.Width;
      Top         := self.Height-Height;
      left        := 0;
  //    Skindata    := self.Skindata;
      SetSubComponent(true);
      Position    := 0;
      Visible     := true;
     end;



   FItems             := TStringList.Create;
   FItemsRect         := TList.Create;
   FItems.OnChange    := @ItemsChanged;
   FItemSpacing       := 15;
   FActiveItem        := -1;
   FMouseInControl    := False;
   Fscrollvsbl        := True;



end;


destructor TONListbox.Destroy;
begin
  FreeAndNil(FAlt);
  FreeAndNil(FUst);
  FreeAndNil(FOrta);
  FreeAndNil(FSag);
  FreeAndNil(FSagalt);
  FreeAndNil(FSagust);
  FreeAndNil(FSol);
  FreeAndNil(FSolalt);
  FreeAndNil(FSolust);
  FreeAndNil(FVScrollbar);
  FreeAndNil(FHScrollbar);
  FreeAndNil(Factiveitems);
  FreeAndNil(FItems);
  FreeAndNil(FItemsRect);
  inherited;
end;

procedure TONListbox.SetSkindata(Aimg: TONImg);
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
procedure TONListbox.SetActiveItem(Val: Integer);
begin
  if FItems <> NIL then
  begin
    if Val > (FItems.Count - 1) then
      Val := FItems.Count - 1
    else if Val < -1 then
      Val:= -1;

    FActiveItem := Val;
    if Assigned(FOnItemChanged) then FOnItemChanged(Self);
    Paint;
  end
  else
    FActiveItem := -1;
end;

procedure TONListbox.SetItems(Value: TStringList);
var
  i: Integer;
begin
  FItems.Assign(Value);
  if FItems.Count = 0 then
    FActiveItem := 0
  else
  begin
    if (FItems.Count - 1) < FActiveItem then FActiveItem := FItems.Count - 1;
    for i := 0 to FItems.Count - 1 do
      FItems[i] := Trim(FItems[i]);
  end;

  SetItemRect;
  Paint;
end;

procedure TONListbox.SetItemSpacing(Val: Byte);
begin
  if Val < 1 then Val := 1;
  FItemSpacing := Val;
  SetItemRect;
  Paint;
 end;


procedure TONListbox.SetItemRect;
var
  TabCount : Integer;
  TabRect  : PRect;
  Positiong : TPoint;
  CTextHeight : Integer;
begin
  Canvas.Font := Font;
  FItemsRect.Clear;

//  Position := Point(FItemSpacing, FCaptionRect.Bottom - FCaptionRect.Top + FItemSpacing);
  if FItems.Count>0 then
  for TabCount := 0 to (FItems.Count - 1) do
  begin
    New(TabRect);
    CTextHeight := Canvas.TextHeight(FItems[TabCount]);
//    ItemSpacing:=;
    TabRect^ := Bounds(Positiong.X, Positiong.y, Width, CTextHeight);
    Positiong := Point(Positiong.X, Positiong.y + FItemSpacing);
    FItemsRect.Add(TabRect);
  end;

  FItemsRect.Capacity := FItemsRect.Count;
end;

//    procedure CheckOthersPanels;


procedure TONListbox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CursorPos   : TPoint;
  CurrentTab  : Integer;
  CurrentRect : PRect;
begin
  GetCursorPos(CursorPos);
  CursorPos := ScreenToClient(CursorPos);

  if FItems.Count > 0 then
  begin
    for CurrentTab := 0 to FItems.Count - 1 do
    begin
      CurrentRect := FItemsRect.Items[CurrentTab];
      if PtInRect(CurrentRect^, CursorPos) then
        if (FActiveItem <> CurrentTab) then
        begin
          SetActiveItem(CurrentTab);
          Break;
        end;
    end;
  end;
  inherited;
end;

  // -----------------------------------------------------------------------------

procedure TONListbox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  Paint;
  inherited MouseMove(Shift, X, Y);
end;

  // -----------------------------------------------------------------------------

procedure TONListbox.MouseEnter;
begin
  FMouseInControl := True;
  Paint;
  inherited;
end;

  // -----------------------------------------------------------------------------

procedure TONListbox.MouseLeave;
begin
  FMouseInControl := False;
 Paint;
  inherited;
end;

  // -----------------------------------------------------------------------------

procedure TONListbox.ItemsChanged(Sender: TObject);
begin
  SetItemRect;
  Paint;
end;

procedure TONListbox.Paint;
  var
    TabCount  : Integer;
    aa:TTextStyle;
    Kaynak,HEDEF : TRect;
    w,h:integer;
  begin

    try
     if Skindata<> nil then
     begin
     if FHScrollbar.Skindata<>nil then
      FHScrollbar.Skindata := Skindata;

     if FVScrollbar.Skindata<> nil then
      FVScrollbar.Skindata := Skindata;

      w:=Width;
      h:=Height;

      if FHScrollbar.Visible=true then
      FHScrollbar.Top:=h-FHScrollbar.Height+5;

      if FvScrollbar.Visible=true then
      begin
       FVScrollbar.Left:=w-FVScrollbar.Width+5;
      end;

     if FHScrollbar.Visible=true then
       w:=self.Width-FHScrollbar.Height;
     // else
     if FVScrollbar.Visible=true then
       h:=self.Height-FVScrollbar.Width;

  //    FHScrollbar.Caption:='yatay';
 //     FVScrollbar.Caption:='dikey';
     if FHScrollbar.Visible=true then
       FhScrollbar.Paint;

     if FVScrollbar.Visible=true then
      FVScrollbar.Paint;




      Fresim.SetSize(w, H);


      // UST   TOP
      KAYNAK := Rect(FUst.FSLeft, FUst.FSTop, FUst.FSRight, FUst.FSBottom);
      HEDEF := Rect((FSolust.FSRight - FSolust.FSLeft), 0, w -
        (FSagust.FSRight - FSagust.FSLeft), (FUst.FSBottom - FUst.FSTop));




      DrawPartnormal(kaynak, self, hedef, False);


      //SOL ÜST TOPLEFT     5-1=5                        63-59
      KAYNAK := Rect(FSolust.FSLeft, FSolust.FSTop, FSolust.FSRight, FSolust.FSBottom);
      HEDEF := Rect(0, 0, FSolust.FSRight - FSolust.FSLeft, FSolust.FSBottom - FSolust.FSTop);
      DrawPartnormal(kaynak, self, hedef, False);



      //SAĞ ÜST TOPRIGHT
      KAYNAK := Rect(FSagust.FSLeft, FSagust.FSTop, FSagust.FSRight, FSagust.FSBottom);
      HEDEF := Rect(w - (FSagust.FSRight - FSagust.FSLeft), 0, w,
        (FSagust.FSBottom - FSagust.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);


      // SOL ALT BOTTOMLEFT
      KAYNAK := Rect(FSolalt.FSLeft, FSolalt.FSTop, FSolalt.FSRight, FSolalt.FSBottom);
      HEDEF := Rect(0, h - (FSolalt.FSBottom - FSolalt.FSTop),
        (FSolalt.FSRight - FSolalt.FSLeft), h);

      DrawPartnormal(kaynak, self, hedef, False);


      //SAĞ ALT BOTTOMRIGHT
      KAYNAK := Rect(FSagalt.FSLeft, FSagalt.FSTop, FSagalt.FSRight, FSagalt.FSBottom);
      HEDEF := Rect(w - (FSagalt.FSRight - FSagalt.FSLeft), h -
        (FSagalt.FSBottom - FSagalt.FSTop), w, h);

      DrawPartnormal(kaynak, self, hedef, False);

      //ALT BOTTOM
      KAYNAK := Rect(FAlt.FSLeft, FAlt.FSTop, FAlt.FSRight, FAlt.FSBottom);
      HEDEF := Rect((FSolalt.FSRight - FSolalt.FSLeft), h -
        (FAlt.FSBottom - FAlt.FSTop), w - (FSagalt.FSRight - FSagalt.FSLeft), h);

      DrawPartnormal(kaynak, self, hedef, False);

      // SOL ORTA CENTERLEFT
      KAYNAK := Rect(FSol.FSLeft, FSol.FSTop, FSol.FSRight, FSol.FSBottom);
      HEDEF := Rect(0, FSolust.FSBottom - FSolust.FSTop, (FSol.FSRight - FSol.FSLeft),
        Height - (FSolalt.FSBottom - FSolalt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);

      // SAĞ ORTA CENTERRIGHT
      KAYNAK := Rect(FSag.FSLeft, FSag.FSTop, FSag.FSRight, FSag.FSBottom);
      HEDEF := Rect(w - (FSag.FSRight - FSag.FSLeft), (FSagust.FSBottom - FSagust.FSTop),
        w, h - (FSagalt.FSBottom - FSagalt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);



      //ORTA CENTER
      KAYNAK := Rect(FOrta.FSLeft, FOrta.FSTop, FOrta.FSRight, FOrta.FSBottom);
      HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        w - (FSag.FSRight - FSag.FSLeft), h - (FAlt.FSBottom - FAlt.FSTop));

      DrawPartnormal(kaynak, self, hedef, False);



      for TabCount := 0 to FItems.Count - 1 do
      begin
        if TabCount = FActiveItem then
        begin
          KAYNAK := Rect(Factiveitems.FSLeft, Factiveitems.FSTop, Factiveitems.FSRight, Factiveitems.FSBottom);
          HEDEF := PRect(FItemsRect.Items[TabCount])^;
          DrawPartnormal(kaynak, self, hedef, False);
          Fresim.TextRect(HEDEF,HEDEF.Left+10,FItemSpacing*TabCount,FItems[TabCount],aa,BGRABlack);
        end else
        begin
        HEDEF := Rect((FSol.FSRight - FSol.FSLeft), (FUst.FSBottom - FUst.FSTop),
        w - (FSag.FSRight - FSag.FSLeft), h - (FAlt.FSBottom - FAlt.FSTop));
        Fresim.TextRect(HEDEF,HEDEF.Left+10,FItemSpacing*TabCount,FItems[TabCount],aa,BGRABlack);
        end;
      end;

     { //FVScrollbar.Position:=FActiveItem;
       with FVScrollbar do
       begin
        Height      := self.Height;
        Width       := 20;
        Top         := 0;
        left        := self.Width-FVScrollbar.Width;
        Visible     := true;
        Skindata    :=self.Skindata;
       end;

     with FHScrollbar do
     begin
      parent      := Self;
      Height      := 20;
      Width       := Self.Width;
      Top         := self.Height-FHScrollbar.Height;
      left        := 0;
      Visible     := true;
      Skindata    :=self.Skindata;
     end;
      }

     if Crop then
        CropToimg(Fresim);

     end;


    finally
  //    Buffer.free;
    end;
    Inherited;
  end;



end.

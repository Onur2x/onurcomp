unit onurlist;

{$mode objfpc}{$H+}


interface

uses
  Windows, SysUtils, LMessages, Forms,  Classes, Types,
  Controls, Graphics, ExtCtrls,  BGRABitmap, BGRABitmapTypes,
  Dialogs, onurctrl,onurbar,onuredit,StdCtrls,grids;

type

  { TOnurStringGridD }

  TOnurStringGridD = class(TStringGrid)
  private
    Fcrop: boolean;
    FSkindata: TONURImg;
    FAlignment: TAlignment;

    Fkind: TonURkindstate;
    Fskinname: string;
    falpha: byte;
    resim: TBGRABitmap;
    WindowRgn: HRGN;
    Customcroplist: TFPList;//TList;

    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fitems: TONURCUSTOMCROP;
    procedure Resize;
    procedure Resizing;
    procedure SetSkindata(Aimg: TONURImg);
  protected
    procedure DrawCellText(aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState;
      aText: String); override;
    procedure DrawCell(aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
      override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Skindata : TONURImg read Fskindata write SetSkindata;
  end;

  { TOnurColunmsItem }

  TOnurColunmsItem = class(TCollectionItem)
  private
    Flist      : TStrings;
    Fwidth     : integer;
    Fcaption   : string;
    Ftextalign : TAlignment;
    fvisible   : Boolean;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure delete(i: integer);
  protected
    procedure SetString(AValue: TStrings); virtual;
    procedure listchange(Sender: TObject);
  published
    property Caption   : String      read FCaption   write FCaption;
    property Visible   : Boolean     read fvisible   write fvisible default true;
    property Items     : TStrings    read Flist      write SetString;
    property Width     : integer     read fwidth     write fwidth;
  end;

  { TONURColunmsItems }

  TONURColunmsItems = class(TOwnedCollection)
  private
    function GetItem(i: Integer): TOnurColunmsItem;
    procedure SetItem(i: Integer; const Value: TOnurColunmsItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClassi: TCollectionItemClass);
    function Add: TOnurColunmsItem;
    procedure Clear;
    procedure Delete(Indexi: Integer);
    function Insert(Indexi: Integer): TOnurColunmsItem;
    function IndexOf(Value: TOnurColunmsItem): Integer;
    property Items[Indexi: Integer]: TOnurColunmsItem read GetItem write SetItem; default;
  end;

 { TONURCustomGrid }

  TONURCustomGrid = class(TONURCustomControl)
  private
    FUpdateCount,
    FColHeight,FColWidth,
    FItemVShown,FItemHShown,
    FItemVOffset,FItemHOffset,
    FItemIndex,FColumIndex : Integer;
    FreadOnly,FHeaderVisible,
    FMouseWhell,Fupdate: boolean;
    FColumns : TONURColunmsItems;
    function GetCell(X, Y: Integer): string;
    function GetColCount: Integer;
    function GetColWidths(aCol: Integer): Integer;
    function GetRowCount: Integer;
    function GetItemIndex: integer;
    function GetItemAt(Pos: TPoint): integer;
    procedure SetColCount(AValue: Integer);
    procedure SetColumns(AValue: TONURColunmsItems);
    procedure SetColWidths(aCol: Integer; AValue: Integer);
    procedure SetHeaderVisible(AValue: boolean);
    procedure SetRowCount(AValue: Integer);
    procedure SetColWidth(Const Avalue: Integer);
    procedure SetColHeight(Const Avalue: Integer);
    procedure SetItemIndex(Avalue: integer);
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
    procedure BeginUpdate; virtual;
    procedure EndUpdate;   virtual;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property Cells[Col, Row: integer] : string            read GetCell        write SetCell;
    property ColWidths[aCol: Integer] : Integer           read GetColWidths   write SetColWidths;
  published
    property ColCount                 : integer           read GetColCount    write SetColCount;
    property RowCount                 : integer           read GetRowCount    write SetRowCount;
    property Columns                  : TONURColunmsItems read FColumns       write SetColumns;
    property DefaultColWidth          : integer           read FColWidth      write SetColWidth;
    property DefaultColHeight         : integer           read FColHeight     write SetColHeight;
    property HeaderVisible            : boolean           read FHeaderVisible write SetHeaderVisible;
  end;

  { TONURStringGrid1 }

  TONURStringGrid1= class(TONURCustomGrid)
  private
     Fcellposition          : TPoint;     // For editing cell
     Fcelleditwidth         : integer;    // editing cell width
     Fcellvalue             : string;     // Cell value
     frowselect             : Boolean;
     FeditorEdit            : TEdit;     // Edit cell
   //  FeditorCom             : TComboBox; // Edit cell
   //  FeditorChe             : TCheckbox; // Edit cell

     fscroll                : TONURScrollBar;
     yscroll                : TONURScrollBar;
//     FOnCellclick           : TOnCellClickSG;
     FFocusedItem           : Integer;
     FheaderHeight          : integer;
     Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
     FTop, FBottom, FCenter, factiveitems, fitems: TONURCUSTOMCROP;

     procedure editchange(sender: TObject);
     procedure VscrollBarChange(Sender: Tobject);
     procedure HScrollBarChange(Sender: TObject);
  public
     constructor Create(Aowner: TComponent); override;
     destructor Destroy; override;
     procedure paint; override;
     procedure SaveToFile(s: string);
     procedure LoadFromFile(s: string);


     function Searchstring(col: integer; Search: string): integer;
     procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
     procedure MouseUp(Button   : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
     procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  protected
     procedure SetSkindata(Aimg: TONURImg);override;
     procedure BeginUpdate; override;
     procedure EndUpdate;   override;
     procedure SetCell(X, Y: integer; AValue: string); override;
     procedure Resize; override;
     procedure Resizing;
     function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
     function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
     procedure DblClick; override;
  published
     Property VScrollbar            : TONURScrollBar  read fscroll         write fscroll;
     Property HScrollbar            : TONURScrollBar  read yscroll         write yscroll;
//     property OnCellClick           : TOnCellClickSG  read FOnCellclick    write FOnCellclick;
//     property ReadOnly              : Boolean         read freadonly       write freadonly;
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



  { TONURListBox }

  TONURListBox = class(TONURCustomControl)
  private
    fautohide:Boolean;
    Flist: TStrings;
    fstate:TONURButtonState;
    findex: integer;
    fmodusewhelll:boolean;
    fback,FHBack:Tbgrabitmap;
    vScrollBar, hScrollBar: TONURScrollBar;
    FItemsShown, FitemHeight, FItemVOffset,FItemHOffset: integer;
    fchangelist:boolean;
    //Fselectedcolor: Tcolor;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter,
    Fhleft, FhTopleft, FhBottomleft, FhRight, FhTopRight, FhBottomRight,
    FhTop, FhBottom, FhCenter, factiveitems, fitems: TONURCUSTOMCROP;
    function GetItemAt(Pos: TPoint): integer;
    function getitemheight: integer;
    function GetItemIndex: integer;
    function ItemRect(Item: integer): TRect;
    procedure LinesChanged(Sender: TObject);
    procedure Scrollscreen;
    procedure setitemheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure VScrollchange(Sender: TObject);
    procedure HScrollchange(Sender: TObject);
  protected
    procedure dblclick; override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseEnter;override;
    procedure MouseLeave;override;
    procedure KeyDown(var Key: word; Shift: TShiftState); virtual;
    procedure SetString(AValue: TStrings); virtual;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Clear;
    procedure MoveDown;
    procedure MoveEnd;
    procedure MoveHome;
    procedure MoveUp;
  published
    property Alpha;
    property AutoHideScrollbar : Boolean        read fautohide      write fautohide;
    property Items             : TStrings       read Flist          write SetString;
    property ItemIndex         : integer        read GetItemIndex   write SetItemIndex;
    property ItemHeight        : integer        read GetItemHeight  write SetItemHeight;
    property HorizontalScroll  : TONURScrollBar read hScrollBar     write hScrollBar;
    property VertialScroll     : TONURScrollBar read vScrollBar     write vScrollBar;
//    property Selectedcolor     : Tcolor         read Fselectedcolor write Fselectedcolor;
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
    property TabStop default True;
  end;

  TOnurCheckListBox = class(TONURCustomControl)
  private
    Flist: TStrings;
    FChecked: array of boolean;
    FItemHeight: Integer;
    FOnItemClick: TNotifyEvent;
    findex: integer;
    fmodusewhelll:boolean;
    vScrollBar, hScrollBar: TONURScrollBar;
    FItemsShown, FItemVOffset,FItemHOffset: integer;
    fchangelist:boolean;
    Fselectedcolor: Tcolor;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fitems,funcheckedc,fcheckedc: TONURCUSTOMCROP;
    function GetItemAt(Pos: TPoint): integer;
    function getitemheight: integer;
    function GetItemIndex: integer;
    function ItemRect(Item: integer): TRect;
    procedure LinesChanged(Sender: TObject);
    procedure Scrollscreen;
    procedure setitemheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure VScrollchange(Sender: TObject);
    procedure HScrollchange(Sender: TObject);
    procedure SetChecked(const Index:Integer;const Value:boolean);
    function GetChecked(Index:Integer):boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure dblclick; override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    procedure KeyDown(var Key: word; Shift: TShiftState); virtual;
    procedure SetString(AValue: TStrings); virtual;


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure MoveDown;
    procedure MoveEnd;
    procedure MoveHome;
    procedure MoveUp;
    property Checked[Index: Integer]: boolean read GetChecked write SetChecked;
  published
    property Items: TStrings read Flist write SetString;

   // property ItemHeight: Integer read FItemHeight write FItemHeight;
    property OnItemClick: TNotifyEvent read FOnItemClick write FOnItemClick;
    property ItemIndex        : integer        read GetItemIndex   write SetItemIndex;
    property ItemHeight       : integer        read GetItemHeight  write SetItemHeight;
    property HorizontalScroll : TONURScrollBar read hScrollBar     write hScrollBar;
    property VertialScroll    : TONURScrollBar read vScrollBar     write vScrollBar;

  end;


  { TONURComboBox }

  TONURComboBox = class(TONURCustomEdit)
  private
    Fliste: TStrings;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FOnGetItems: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    Fitemindex: integer;
    fpopupopen: boolean;
    FitemHeight: integer;
    Fitemoffset: integer;
    Fselectedcolor: Tcolor;
    fdropdown: boolean;
    FNormal, FPress, FEnter, Fdisable: TONURCUSTOMCROP;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    procedure Change;
    procedure kclick(Sender: TObject);
    function Gettext: string;
    function GetItemIndex: integer;
    procedure LinesChanged(Sender: TObject);

    procedure setitemheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure LstPopupReturndata(Sender: TObject; const Str: string; const indx: integer);
    procedure LstPopupShowHide(Sender: TObject);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure Select; virtual;
    procedure DropDown; virtual;
    procedure GetItems; virtual;
    procedure CloseUp; virtual;
    procedure SetStrings(AValue: TStrings); virtual;
    property OnCloseUp  : TNotifyEvent read FOnCloseUp  write FOnCloseUp;
    property OnDropDown : TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnGetItems : TNotifyEvent read FOnGetItems write FOnGetItems;
    property OnSelect   : TNotifyEvent read FOnSelect   write FOnSelect;
  public
    fbutonarea: Trect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
  published
    property Alpha;
    property Text;
    property Items: TStrings read Fliste write SetStrings;
    property OnChange;
    property ReadOnly;
    property ItemIndex     : integer read Getitemindex   write Setitemindex;
    property Selectedcolor : Tcolor  read Fselectedcolor write Fselectedcolor;
    property ItemHeight    : integer read FitemHeight    write SetItemHeight;
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
  TReturnStintEvent = procedure(Sender: TObject; const ftext: string;
    const itemind: integer) of object;

  Tpopupformcombobox = class(TcustomForm)
    procedure listboxDblClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    FCaller: TONURComboBox;
    FClosed: boolean;
    oblist: TONURListBox;
    FOnReturnDate: TReturnStintEvent;
    procedure CMDeactivate(var Message: TLMessage); message CM_DEACTIVATE;
    procedure KeepInView(const PopupOrigin: TPoint);
    procedure ReturnstringAnditemindex;
  protected
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure DoShow; override;
  public
     constructor Create(TheOwner: TComponent); override;
  end;

  TONURColumList = class;

  { TONURlistItem }

  TONURlistItem = class(TCollectionItem)
  private
    FCells: array of string;
    FSize: integer;
    Ftextalign : TAlignment;
    ffont      : TFont;
    function GetCell(X: integer): string;
    function GetColCount: integer;
    procedure SetCell(X: integer; AValue: string);virtual;
    procedure SetColCount(AValue: integer);
    function Insert(Indexi: integer; avalue: string): TONURlistItem;
  public
    constructor Create(Collectioni: TCollection); override;
    procedure Add(s: string);
    procedure Clear;
    procedure Delete;//(Indexi: integer);
    function Arrayofstring(aranan: string): integer;
    property Cells[Col: integer]: string read GetCell write SetCell;
    property ColCount : integer read GetColCount write SetColCount;
  published
    property Font      : TFont       read ffont write ffont;
    property Textalign : TAlignment  read Ftextalign write Ftextalign;
    property ID;
  end;

  { TONURlistItems }

  TONURlistItems = class(TOwnedCollection)
  private
    FUpdateCount:integer;
    function GetItem(Indexi: integer): TONURlistItem;
    procedure SetItem(Indexi: integer; const Value: TONURlistItem);
    procedure Setcells(Acol, Arow: integer; Avalue: string);
    function Getcells(Acol, Arow: integer): string;
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClassi: TCollectionItemClass);
    function Add: TONURlistItem;
    property Count;// override;
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Delete(Indexi: integer);
    function Insert(Indexi: Integer; col: array of integer; avalue: array of string
      ): TONURlistItem;
    function IndexOf(Value: TONURlistItem): integer;
    property Items[Indexi: integer]: TONURlistItem read GetItem write SetItem; default;
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;
  end;


  { TONURColumn }

  TONURColumn = class(TCollectionItem)
  private
    FCaption: string;
    fvisible: boolean;
    FCurrent: boolean;
    FSelected: boolean;
    fwidth: integer;
    ffont: TFont;
    Ftextalign:TAlignment;
  public
    constructor Create(Collectioni: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Selected: boolean read FSelected write FSelected;
    property Current: boolean read FCurrent write FCurrent;
    property Index;
    procedure Delete(Indexi: integer);
  published
    property Caption: string read FCaption write FCaption;
    property Visible: boolean read fvisible write fvisible default True;
    property Width: integer read fwidth write fwidth;
    property Font: TFont read ffont write ffont;
    property Textalign :TAlignment read Ftextalign write Ftextalign;
  end;



  { TONURListColums }

  TONURListColums = class(TOwnedCollection)
  private

    function GetItem(Indexi: integer): TONURColumn;
    procedure SetItem(Indexi: integer; const Value: TONURColumn);
    procedure Setcells(Acol, Arow: integer; Avalue: string);
    function Getcells(Acol, Arow: integer): string;
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClassi: TCollectionItemClass);
    function Add: TONURColumn;
    procedure Clear;
    procedure Delete(Indexi: integer);
    function Insert(Indexi: integer): TONURColumn;
    Function Indexof(Value: TONURColumn): Integer;
    //procedure BeginUpdate; override;
    //procedure EndUpdate; override;
    property Items[Indexi: integer]: TONURColumn read GetItem write SetItem; default;
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;
  end;

  TOnDeleteItem = procedure(Sender: TObject) of object;
  TOnCellClick = procedure(Sender: TObject; Column: TONURlistItem) of object;

  { TONURColumList }

  TONURColumList = class(TONURCustomControl)
  private
  fupdatelist:Boolean;
    fback:Tbgrabitmap;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fheader, fitems: TONURCUSTOMCROP;
    fheaderfont: Tfont;
    FListItems: TONURlistItems;
    fItemscount  : integer;
    Fcolumns: TONURListColums;
    Counter:integer;
    FItemvOffset: integer;
    FItemHOffset: integer;
    FItemsShown: smallint;
    FItemsvShown:SmallInt;
    FItemshShown: SmallInt;
    FFocusedItem: integer;
    FItemHeight: integer;
    FheaderHeight: integer;
    FAutoHideScrollBar: boolean;
    fheadervisible: boolean;
    fmodusewhelll: boolean;
    fcolumindex: integer;
    fselectcolor: TColor;
    fbackgroundvisible: boolean;
    VScrollBar: TONURScrollBar;
    HScrollBar: TONURScrollBar;
    FItemDblClick: TNotifyEvent;
    FItemEnterKey: TNotifyEvent;
    FOnDeleteItem: TOnDeleteItem;
    FOnCellclick: TOnCellClick;
    function Getcells(Acol, Arow: integer): string;
    function Itemrectcel(Item, Col: integer): Trect;
    procedure Scrollscreen;
    procedure Setcells(Acol, Arow: integer; Avalue: string);
    procedure SetHeadervisible(AValue: boolean);
    procedure SetItems(Value: TONURlistItems);
    procedure Setcolums(Value: TONURListColums);

    function ItemRect(Item: integer): TRect;
    function GetItemAt(Pos: TPoint): integer;
    procedure VScrollBarChange(Sender: TObject);
    procedure HScrollBarChange(Sender: TObject);
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;

  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure resizing;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Clear;
    procedure MoveUp;
    procedure MoveDown;
    procedure MoveHome;
    procedure MoveEnd;
    procedure Delete(indexi: integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;
  published
    property Alpha;
    property OnCellClick       : TOnCellClick    read FOnCellclick       write FOnCellclick;
    property Columns           : TONURListColums read Fcolumns           write Setcolums;
   // property Columns           : TONURlistItems  read FListItems         write SetItems;
    property Items             : TONURlistItems  read FListItems         write SetItems;
    property ItemIndex         : integer         read FFocusedItem       write FFocusedItem;
    property Itemscount        : Integer         read FItemscount;
    property Columindex        : integer         read fcolumindex        write fcolumindex;
    property ItemHeight        : integer         read FItemHeight        write FItemHeight;
    property HeaderHeight      : integer         read FheaderHeight      write FheaderHeight;
    property Selectedcolor     : Tcolor          read fselectcolor       write fselectcolor;
    property Headervisible     : boolean         read fheadervisible     write SetHeadervisible;
    property Headerfont        : TFont           read fheaderfont        write fheaderfont;
    property AutoHideScrollBar : boolean         read FAutoHideScrollBar write FAutoHideScrollBar;
    property OnItemDblClick    : TNotifyEvent    read FItemDblClick      write FItemDblClick;
    property OnItemEnterKey    : TNotifyEvent    read FItemEnterKey      write FItemEnterKey;
    property OnDeleteItem      : TOnDeleteItem   read FOnDeleteItem      write FOnDeleteItem;
    property VertialScroll     : TONURScrollBar  read VScrollBar         write VScrollBar;
    property HorizontalScroll  : TONURScrollBar  read hScrollBar         write HScrollBar;
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
    FUpdateCount:integer;
    function GetCell(X, Y: integer): string;
    function GetColCount: integer;
    function GetRowCount: integer;
    procedure SetCell(X, Y: integer; AValue: string);
    procedure SetColCount(AValue: integer);
    procedure SetRowCount(AValue: integer);
    procedure SetSize(AValue: TPoint);
    procedure Savetofile(s: string);
    procedure Loadfromfile(s: string);
    procedure BeginUpdate;
    procedure EndUpdate;
  public
    procedure Clear;
    function arrayofstring(col: integer; aranan: string): integer;
    property Cells[Col, Row: integer]: string read GetCell write SetCell;
    property ColCount: integer read GetColCount write SetColCount;
    property RowCount: integer read GetRowCount write SetRowCount;
    property Size: TPoint read FSize write SetSize;
  end;



  { Tonurstringgrid }
  TOnCellClickSG = procedure(Sender: TObject;Col,Row:integer;Celvalue:string) of object;

  TONURStringGrid= class(TONURCustomControl)
  private
    FItemHeight            : integer;
    FItemhOffset           : Integer;
    FItemvOffset           : Integer;
    FUpdateCount           : integer;
    Fcellposition          : TPoint;     // For editing cell
    Fcelleditwidth         : integer;    // editing cell width
    Fcellvalue             : string;     // Cell value
    FItemsvShown           : integer;
    FItemsHShown           : integer;
    freadonly              : Boolean;
    frowselect             : Boolean;
    FCells                 : array of array of string;
    FcolwitdhA             : array of integer;
    FSize                  : TPoint;
    fcolwidth              : integer;
    //fchanged               : Boolean;
  //  fcolvisible            : integer;
    FeditorEdit            : TEdit;     // Edit cell
  //  FeditorCom             : TComboBox; // Edit cell
  //  FeditorChe             : TCheckbox; // Edit cell

    fscroll                : TONURScrollBar;
    yscroll                : TONURScrollBar;
    FOnCellclick           : TOnCellClickSG;
    //fItemscount            : integer;
    FFocusedItem           : Integer;
    FheaderHeight          : integer;
    fmodusewhelll          : Boolean;
    fcolumindex            : integer;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fitems: TONURCUSTOMCROP;
    procedure editchange(sender: TObject);
    function GetCellval: string;
    function GetColWidths(aCol: Integer): Integer;
    function GetItemAt(Pos: TPoint): Integer;
 //   procedure Scrollscreen;
    procedure SetColWidths(aCol: Integer; AValue: Integer);
    procedure VscrollBarChange(Sender: Tobject);
    procedure HScrollBarChange(Sender: TObject);
    function GetCell(X, Y: integer): string;
    function GetColCount: integer;
    function GetRowCount: integer;
    procedure SetCell(X, Y: integer; AValue: string);
    procedure SetColCount(AValue: integer);
    procedure SetRowCount(AValue: integer);
    procedure SetSize(AValue: TPoint);
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure SaveToFile(s: string);
    procedure LoadFromFile(s: string);
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    function Searchstring(col: integer; Search: string): integer;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseUp(Button   : TMouseButton; Shift : TShiftState; X,Y : Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property Cells[Col, Row: integer]: string read GetCell write SetCell;
    property ColCount         : integer read GetColCount write SetColCount;
    property RowCount         : integer read GetRowCount write SetRowCount;
    property Size             : TPoint read FSize write SetSize;
    property Itemindex        : integer         read FFocusedItem    write FFocusedItem;
    property ColWidths[aCol: Integer]: Integer       read GetColWidths    write SetColWidths;
    Property SelectedCelltext : string read GetCellval;

  protected
    procedure SetSkindata(Aimg: TONURImg);override;
    procedure Resize; override;
    procedure Resizing;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    procedure DblClick; override;
  published

    property RowSelect             : Boolean         read frowselect      write frowselect;
    property ItemHeight            : integer         read FItemHeight     write FItemHeight;
    Property VScrollbar            : TONURScrollBar  read fscroll         write fscroll;
    Property HScrollbar            : TONURScrollBar  read yscroll         write yscroll;
    property OnCellClick           : TOnCellClickSG  read FOnCellclick    write FOnCellclick;
    property ReadOnly              : Boolean         read freadonly       write freadonly;
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




procedure Register;



implementation


procedure Register;
begin
  RegisterComponents('ONUR', [TONURListBox,TOnurCheckListBox,TONURColumList]);
  RegisterComponents('ONUR', [TONURComboBox]);
  RegisterComponents('ONUR', [TONURStringGrid]);
end;

{ TOnurStringGridD }

procedure TOnurStringGridD.SetSkindata(Aimg: TONURImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
  end
  else
  begin
    FSkindata := nil;
  end;

  Resizing;
end;



procedure TOnurStringGridD.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TOnurStringGridD.Resizing;
begin
  FTopleft.Targetrect     := Rect(0, 0,FTopleft.Croprect.Width,FTopleft.Croprect.Height);
  FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Croprect.Width,0, self.ClientWidth, FTopRight.Croprect.Height);
  FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0,self.ClientWidth - FTopRight.Croprect.Width,FTop.Croprect.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Croprect.Width,self.ClientHeight - FBottomRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width,self.ClientHeight - FBottom.Croprect.Height, self.ClientWidth - FBottomRight.Croprect.Width, self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.ClientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect       := Rect(self.ClientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Croprect.Height);

  FCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight -(FBottom.Croprect.Height));

  resim.FontQuality       := fqSystemClearType;
  resim.FontName          := self.Font.Name;
  resim.FontStyle         := self.Font.Style;
  resim.FontHeight        := self.Font.Height;
end;



constructor TOnurStringGridD.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  DoubleBuffered := True;
  resim := TBGRABitmap.Create;
  falpha := 255;
  Customcroplist := TFPList.Create;// TList.Create;
  WindowRgn := CreateRectRgn(0, 0, self.Width, self.Height);
  Fskinname                := 'stringrid';
  FTop                  := TONURCUSTOMCROP.Create('TOP');
//  FTop.cropname         := 'TOP';
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
//  FBottom.cropname      := 'BOTTOM';
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
//  FCenter.cropname      := 'CENTER';
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
//  FRight.cropname       := 'RIGHT';
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
//  FTopRight.cropname    := 'TOPRIGHT';
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
//  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
//  Fleft.cropname        := 'LEFT';
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
//  FTopleft.cropname     := 'TOPLEFT';
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
//  FBottomleft.cropname  := 'BOTTOMLEFT';



  factiveitems            := TONURCUSTOMCROP.Create('ACTIVEITEM');
//  factiveitems.cropname   := 'ACTIVEITEM';
  fitems                  := TONURCUSTOMCROP.Create('ITEM');
//  fitems.cropname         := 'ITEM';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(fitems);
  Customcroplist.Add(factiveitems);


end;

destructor TOnurStringGridD.Destroy;
var
  i:byte;
begin
{  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;
}
  Customcroplist.Clear;
   FreeAndNil(Customcroplist);


  if Assigned(resim) then  FreeAndNil(resim);
  DeleteObject(WindowRgn);


  inherited Destroy;
end;

procedure TOnurStringGridD.DrawCellText(aCol, aRow: Integer; aRect: TRect;
  aState: TGridDrawState; aText: String);
begin
  inherited DrawCellText(aCol, aRow, aRect, aState, aText);
end;

procedure TOnurStringGridD.DrawCell(aCol, aRow: Integer; aRect: TRect;
  aState: TGridDrawState);
var
  partial: TBGRACustomBitmap;
begin

//   inherited DrawCell(aCol, aRow, aRect, aState);

   if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Width) and
    (ARect.Bottom = Height) then
    resim.StretchPutImage(aRect, FSkindata.Fimage, dmSet, falpha)
  else
  begin
    partial := FSkindata.Fimage.GetPart(fitems.Croprect);

    if partial <> nil then
    begin
      resim.StretchPutImage(aRect, partial, dmDrawWithTransparency, falpha);
      aRect.left := aRect.left + 1;
      aRect.right := aRect.right - 1;
      aRect.top := aRect.top + 1;
      aRect.bottom := aRect.bottom - 1;
      resim.TextRect(aRect, Cells[acol,arow], taLeftJustify, tlCenter, ColorToBGRA(Font.Color, falpha));
    end;
    FreeAndNil(partial);
  end;

   Invalidate;
  writeln('dfd');
end;

procedure TOnurStringGridD.paint;
 var
   a: TBGRABitmap;
begin

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    //CENTER
    DrawPartnormalBGRABitmap(Fcenter.Croprect,resim,FSkindata,FCenter.Targetrect, falpha);

    //SOL ÜST TOPLEFT
    DrawPartnormalBGRABitmap(FTopleft.Croprect,resim,FSkindata,FTopleft.Targetrect, falpha);
    //SAĞ ÜST TOPRIGHT
    DrawPartnormalBGRABitmap(FTopRight.Croprect,resim,FSkindata,FTopRight.Targetrect, falpha);
    //UST TOP
    DrawPartnormalBGRABitmap(ftop.Croprect,resim,FSkindata,ftop.Targetrect, falpha);
    // SOL ALT BOTTOMLEFT
    DrawPartnormalBGRABitmap(FBottomleft.Croprect,resim,FSkindata,FBottomleft.Targetrect, falpha);
    //SAĞ ALT BOTTOMRIGHT
    DrawPartnormalBGRABitmap(FBottomRight.Croprect,resim,FSkindata,FBottomRight.Targetrect, falpha);
    //ALT BOTTOM
    DrawPartnormalBGRABitmap(FBottom.Croprect,resim,FSkindata,FBottom.Targetrect, falpha);
    // SOL ORTA CENTERLEFT
    DrawPartnormalBGRABitmap(Fleft.Croprect,resim,FSkindata,Fleft.Targetrect, falpha);
    // SAĞ ORTA CENTERRIGHT
    DrawPartnormalBGRABitmap(FRight.Croprect,resim,FSkindata,FRight.Targetrect, falpha);


 //   if Crop then
 //    CropToimg(resim);
  end else
  begin
 //   resim.Fill(BGRA(190, 208, 190,falpha), dmSet);
    FCenter.Targetrect.Height := self.Height;
  end;

  //  inherited paint;

  if (resim <> nil) then
  begin

    if (Assigned(Skindata)) and (self.Skindata.mcolor <> 'clnone') and
      (self.Skindata.mcolor <> '') then
    begin
      //a := Tbgrabitmap.Create;
      try
       // a.SetSize(resim.Width, resim.Height);
        replacepixel(a, ColorToBGRA(StringToColor(self.Skindata.mcolor),
          self.Skindata.opacity));
      //  a.InvalidateBitmap;
       // resim.BlendImage(0, 0, a, boTransparent);
      finally
      //  FreeAndNil(a);
      end;
    end;

    resim.Draw(self.canvas, 0, 0, False);

  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, falpha), dmSet);
    resim.Draw(self.canvas, 0, 0, False);
  end;


//exit;


end;




{ TOnurColunmsItem }

constructor TOnurColunmsItem.Create(ACollection: TCollection);
begin
  FCaption       := '';
  fwidth         := 80;
  fvisible       := true;
  Ftextalign     := taLeftJustify;
  flist          := TStringList.Create;
  TStringList(Flist).OnChange := @listchange;
  inherited Create(ACollection);
end;

destructor TOnurColunmsItem.Destroy;
begin

   if Assigned(flist) then
        FreeAndNil(flist);
  inherited Destroy;
end;

procedure TOnurColunmsItem.Assign(Source: TPersistent);
begin
  if (Source is TOnurColunmsItem) then
    with (Source as TOnurColunmsItem) do
    begin
      Self.FCaption  := FCaption;
      self.flist.Assign(flist);
    end
  else
  inherited Assign(Source);
end;

procedure TOnurColunmsItem.delete(i: integer);
begin
  if (flist.Count>0) and (flist.Count>i) then
  flist.Delete(i);
end;

procedure TOnurColunmsItem.SetString(AValue: TStrings);
begin
  if Flist=AValue then Exit;
  flist.BeginUpdate;
  Flist.Assign(AValue);
  flist.EndUpdate;
end;

procedure TOnurColunmsItem.listchange(Sender: TObject);
begin
   Tcontrol(TOwnedCollection(GetOwner).Owner).Invalidate;
end;

{ TONURColunmsItems }

function TONURColunmsItems.GetItem(i: Integer): TOnurColunmsItem;
begin
   if i <> -1 then
 Result := TOnurColunmsItem(inherited GetItem(i));
end;

procedure TONURColunmsItems.SetItem(i: Integer;
  const Value: TOnurColunmsItem);
begin
 inherited SetItem(i, Value);
  Changed;
end;

procedure TONURColunmsItems.Update(Item: TCollectionItem);
begin
  TControl(GetOwner).Invalidate;
//  BeginUpdate;
//  inherited Update(Item);
end;

constructor TONURColunmsItems.Create(AOwner: TPersistent;
  ItemClassi: TCollectionItemClass);
begin
   inherited Create(AOwner, ItemClassi);
end;

function TONURColunmsItems.Add: TOnurColunmsItem;
begin
 Result := TOnurColunmsItem(inherited Add);
end;

procedure TONURColunmsItems.Clear;
begin
// with Tcontrol(GetOwner) do
// begin
//   FItemOffset  := 0;
//   FFocusedItem := -1;
// end;
end;

procedure TONURColunmsItems.Delete(Indexi: Integer);
var
  i:integer;
begin
 for i:=0 to Count-1 do
  Items[i].delete(Indexi);

  Changed;
end;

function TONURColunmsItems.Insert(Indexi: Integer): TOnurColunmsItem;
begin
   Result := TOnurColunmsItem(inherited Insert(Indexi));
end;

function TONURColunmsItems.IndexOf(Value: TOnurColunmsItem): Integer;
var
  i : Integer;
begin
  Result := -1;
  i      := 0;

  while (i < Count) and (Result = -1) do
    if Items[i] = Value then
      Result := i;

end;


{ TONURCustomGrid }


function TONURCustomGrid.GetCell(X, Y: Integer): string;
begin
  Result:='';
  if (FColumns.Count>-1) and (FColumns.Count<=X) then
   Result:=''
  else
  begin
   if (FColumns[X].Items.Count>-1) and (FColumns[X].Items.Count<=Y) then
    Result:=''
   else
    Result:=FColumns[X].Items[Y];
  end;
end;

function TONURCustomGrid.GetColCount: Integer;
begin
  Result:=-1;
  if (FColumns.Count>-1) Then
   Result:=FColumns.Count
  Else
   Result:=-1;
end;

function TONURCustomGrid.GetColWidths(aCol: Integer): Integer;
begin
  Result:=-1;
  if (FColumns.Count=-1) and (FColumns.Count<=Acol) then
   Result:=-1
  else
    Result:=FColumns[Acol].Fwidth;
end;

function TONURCustomGrid.GetRowCount: Integer;
begin
  Result:=-1;
  if (FColumns.Count>-1) Then
  if (FColumns[0].items.Count>-1) Then
    Result:=FColumns[0].Items.Count
  else
    Result:=-1;
end;

function TONURCustomGrid.GetItemIndex: integer;
begin
  Result:=FItemIndex;
end;

function TONURCustomGrid.GetItemAt(Pos: TPoint): integer;
begin

end;

procedure TONURCustomGrid.SetColCount(AValue: Integer);
var
  i,x:integer;
begin
  if AValue>-1 then
  begin
   if FColumns.Count< AValue then
   begin
    i:=FColumns.Count;
    FColumns.BeginUpdate;
    for x:=i to AValue do
     begin
      FColumns.Add;
      FColumns[x].Width   := FColWidth;
     end;
    FColumns.EndUpdate;
   end else
   if FColumns.Count> AValue then
   begin
    i:=FColumns.Count;
    FColumns.BeginUpdate;
    for x:=AValue downto i do
      FColumns.Delete(x);
    FColumns.EndUpdate;
   end;
  end;
end;

procedure TONURCustomGrid.SetRowCount(AValue: Integer);
var
  i, x:integer;
begin
 if (AValue>-1) and (FColumns.Count> -1) then
 begin
    for i:=0 to FColumns.Count-1 do
    begin
      for x:=0 to AValue do
       FColumns[i].Items.Add('');
    end;
 end;

end;

procedure TONURCustomGrid.SetColumns(AValue: TONURColunmsItems);
begin
  if FColumns=AValue then Exit;
  FColumns.Assign(AValue);
  Invalidate;
end;


procedure TONURCustomGrid.SetColWidths(aCol: Integer; AValue: Integer);
begin
  if (FColumns.count>-1) and (FColumns.count>=acol) and (AValue>-1) then
  begin
    FColumns[acol].Width:=AValue;
    Invalidate;
  end;
end;

procedure TONURCustomGrid.SetHeaderVisible(AValue: boolean);
begin
  if FHeaderVisible=AValue then Exit;
  FHeaderVisible:=AValue;
  Invalidate;
end;


procedure TONURCustomGrid.SetColWidth(const Avalue: Integer);
begin
  if (FColWidth=Avalue) and (Avalue=-1) then Exit;
  FColWidth:=Avalue;
  Invalidate;
end;

procedure TONURCustomGrid.SetColHeight(const Avalue: Integer);
begin
  if (FColHeight=Avalue) and (Avalue=-1) then Exit;
  FColHeight:=Avalue;
  Invalidate;
end;

procedure TONURCustomGrid.SetItemIndex(Avalue: integer);
begin
  if (FItemIndex=Avalue) and (Avalue=-1) then Exit;
  FItemIndex:=Avalue;
  Invalidate;
end;

procedure TONURCustomGrid.SetCell(X, Y: integer; AValue: string);
var
  i: Integer;
begin
  if (x=-1) and (y=-1) then Exit;
 // begin
  // FColumns[x].Items[y]:=AValue;
//   Invalidate;
//  end;
   if (FColumns.Count>-1) and (FColumns.Count<=X) then
   begin
     FColumns.Add;
   end;
   if (FColumns[X].Items.Count>-1) and (FColumns[X].Items.Count<=Y) then
   begin
  //  FColumns.BeginUpdate;
    FColumns[X].Items.BeginUpdate;

    for i:=FColumns[X].Items.Count+1 to Y do
    FColumns[X].Items.Add('');
  //  FColumns[X].Items[Y]:=Avalue;
    FColumns[X].Items.Insert(Y,Avalue);
    FColumns[X].Items.EndUpdate;
  //  FColumns.EndUpdate;
   end else
   begin
     FColumns[X].Items[Y]:=Avalue;
   end;

//   fItemscount :=Columns[acol].flist.Count;
if Fupdate=false then
Invalidate;
end;

function TONURCustomGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
end;

function TONURCustomGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
end;

constructor TONURCustomGrid.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  Width          := 200;
  Height         := 200;
  FColumns       := TONURColunmsItems.Create(Self, TOnurColunmsItem);
  FUpdateCount   := 0;
  FItemHOffset   := 0;
  FItemVOffset   := 0;
  FColHeight     := 20;
  FColWidth      := 80;
  FItemIndex     := -1;
  FColumIndex    := 0;
  FItemVShown    := 0;
  FItemHShown    := 0;
  TabStop        := True;
  Cursor         := crIBeam;
  FMouseWhell    := false;
  FreadOnly      := true;
  FHeaderVisible := true;
  Fupdate        := true;
end;

destructor TONURCustomGrid.Destroy;
begin
  if Assigned(FColumns) then
  FreeAndNil(FColumns);
  inherited Destroy;
end;

procedure TONURCustomGrid.paint;
var
  t,i,x,y:integer;
  TRG,SRC:Trect;
  initialtime, elapsedtime: DWord;
begin
 if Fupdate=false then exit;
 if Visible=false then exit;
 if FColumns.Count > 0 then
 begin
   initialtime := Windows.GetTickCount;
   x:=0;
   y:=0;
   for i:=0 to fColumns.Count-1 do
   begin
     inc(x);
     y:=y+FColumns[i].Width;
     if y>= self.ClientWidth then
     begin
      FItemHShown := x;
      break;
     end;
   end;
   FItemVShown := self.ClientHeight div FColHeight;

   i:=0;
   SRC:=TONURStringGrid1(self).fitems.Croprect;// self).fTOP.Height{fsBottom - TONURSpinEdit(self).OTOP.fsTop};

   for x:=FItemhOffset to FColumns.Count-1 do  // columns
   begin
     if x>FItemhOffset+FItemHShown then break;
     t:=0;
     if FColumns[x].Items.Count>0 then
     for y:=FItemVOffset to FColumns[x].Items.Count -1 do
     begin
       if y>FItemvOffset+FItemvShown then break;
       TRG:=Rect(i,t,i+FColumns[x].Width,t+FColHeight);
       //DrawPartnormal(SRC,self,TRG,alpha);
       DrawPartnormaltext(src, self,TRG, alpha,FColumns[x].items[y],taLeftJustify,ColorToBGRA(Font.Color, alpha));

       t:=t+FColHeight;
     end;
    i:=i+FColumns[x].Width;
   end;

 elapsedtime := Windows.GetTickCount - initialtime;
 //WriteLn( 'Time elapsed: ' + IntToStr(elapsedtime) + ' miliseconds');

 end;
 inherited paint;
end;

procedure TONURCustomGrid.SaveToFile(s: string);
begin

end;

procedure TONURCustomGrid.LoadFromFile(s: string);
begin

end;

procedure TONURCustomGrid.Clear;
begin

end;

procedure TONURCustomGrid.BeginUpdate;
begin
  FUpdateCount := FUpdateCount +1;
  Fupdate:=false;
end;

procedure TONURCustomGrid.EndUpdate;
begin
 Fupdate:=true;
 //Invalidate;
 if FUpdateCount > 0 then
    begin
      FUpdateCount := FUpdateCount -1;
      if FUpdateCount=0 then
       Invalidate;
       // Update;
    end;
end;



procedure TONURCustomGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TONURCustomGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TONURCustomGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
end;

{ TONURStringGrid1 }

procedure TONURStringGrid1.editchange(sender: TObject);
begin
 if Assigned(FeditorEdit) then
  begin
   SetCell(fcolumindex,FFocusedItem,FeditorEdit.Text);
//   fchanged:=true;
   Invalidate;
  end;
end;

procedure TONURStringGrid1.VscrollBarChange(Sender: Tobject);
begin
 if FMouseWhell=false then
   begin
     FItemVOffset := vScrollBar.Position;
//     fchanged:=true;
     Invalidate;
   end;
end;

procedure TONURStringGrid1.HScrollBarChange(Sender: TObject);
begin
 if FMouseWhell=false then
 begin
   FItemhOffset := hScrollBar.Position;
//   fchanged:=true;
   Invalidate;
 end;
end;

constructor TONURStringGrid1.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  skinname                := 'stringrid';
   FTop                  := TONURCUSTOMCROP.Create('TOP');
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  factiveitems            := TONURCUSTOMCROP.Create('ACTIVEITEM');
  fitems                  := TONURCUSTOMCROP.Create('ITEM');

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(fitems);
  Customcroplist.Add(factiveitems);


  vScrollBar := TONURScrollBar.Create(nil);
  with vScrollBar do
  begin
    AutoSize  := false;
    Parent    := self;
    Enabled   := False;
    Skinname  := 'scrollbarv';
    Skindata  := nil;//Self.Skindata;
    Width     := 20;
    left      := Self.ClientWidth -Width;// + Background.Border);
    Top       := 0;//Self.Top;//Background.Border;
    Height    := Self.Height;// - (Background.Border * 2);
    Max       := 1;//Flist.Count;
    Min       := 0;
    OnChange  := @vScrollbarchange;
    Position  := 0;
   // Align     := alRight;
  //  Visible   := false;
    Kind      := oVertical;
    SetSubComponent(true);
  end;

  HScrollBar := TONURScrollBar.Create(nil);
  with HScrollBar do
  begin
    AutoSize   := false;
    parent     := self;
    Enabled    := False;
    Skinname   := 'scrollbarh';
    Skindata   := nil;
    Height     := 20;
    left       := 0;//self.Left;
    Top        := self.ClientHeight-Height;
    Width      := self.Width;
    Max        := 1;
    Min        := 0;
    OnChange   := @hScrollBarChange;
    Position   := 0;
//    Align      := alBottom;
//    Visible    := false;
    Kind       := oHorizontal;
    SetSubComponent(true);
  end;
end;

destructor TONURStringGrid1.Destroy;
var
   i:byte;
 begin
 {  for i:=0 to Customcroplist.Count-1 do
   TONURCUSTOMCROP(Customcroplist.Items[i]).free;
 }
   Customcroplist.Clear;

  if Assigned(VScrollbar) then VScrollbar.Free;// FreeAndNil(VScrollbar);
  if Assigned(HScrollbar) then HScrollbar.Free;// FreeAndNil(HScrollbar);

  inherited Destroy;
end;

procedure TONURStringGrid1.paint;
begin
   if (not Visible) then Exit;
//  if fchanged=false then exit; // for loop paint
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    //CENTER
     DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);

   //  vScrollbar.Max := (FColumns[0].items.Count-1 - FItemVShown);
  //   hScrollBar.Max := (FColumns.Count-1 - FItemHShown);

  //   if FAutoHideScrollBar then
  //   begin
  {     if hScrollBar.Max>0 then
        hScrollBar.Enabled := True
       else
        hScrollBar.Enabled := False;

       // if (FSize.y * FItemHeight)>self.ClientHeight then
       if vScrollBar.Max>0 then
        vScrollbar.Enabled := True
       else
        vScrollbar.Enabled := False;
       }
  //SOL ÜST TOPLEFT
    DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
    //SAĞ ÜST TOPRIGHT
    DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
    //UST TOP
    DrawPartnormal(ftop.Croprect, self, ftop.Targetrect, alpha);
    // SOL ALT BOTTOMLEFT
    DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
    //SAĞ ALT BOTTOMRIGHT
    DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
    //ALT BOTTOM
    DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
    // SOL ORTA CENTERLEFT
    DrawPartnormal(Fleft.Croprect, self, fleft.Targetrect, alpha);
    // SAĞ ORTA CENTERRIGHT
    DrawPartnormal(FRight.Croprect, self,FRight.Targetrect, alpha);

    if Crop then
     CropToimg(resim);
  end else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    FCenter.Targetrect.Height := self.Height;
  end;

  inherited paint;
end;

procedure TONURStringGrid1.SaveToFile(s: string);
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

procedure TONURStringGrid1.LoadFromFile(s: string);
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
  // Scrollscreen;
//  fchanged:=true;
   Invalidate;
end;


function TONURStringGrid1.Searchstring(col: integer; Search: string): integer;
begin

end;

procedure TONURStringGrid1.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TONURStringGrid1.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TONURStringGrid1.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
end;

procedure TONURStringGrid1.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURStringGrid1.SetCell(X, Y: integer; AValue: string);
begin
  inherited SetCell(X, Y, AValue);
  if Fupdate then
  begin
    if FColumns.Count>0 then
    begin
     HScrollbar.Max:=FColumns.Count;
     if FColumns[0].items.Count>0 then
      vScrollbar.Max:=FColumns[0].items.Count;
    end;
   Invalidate;
  end;
end;


procedure TONURStringGrid1.BeginUpdate;
begin
  Inherited BeginUpdate;
end;

procedure TONURStringGrid1.EndUpdate;
begin
  Inherited EndUpdate;
    if Fupdate then
  begin
    if FColumns.Count>0 then
    begin
     HScrollbar.Max:=FColumns.Count;
     if FColumns[0].items.Count>0 then
      vScrollbar.Max:=FColumns[0].items.Count;
    end;
   Invalidate;
  end;
end;

procedure TONURStringGrid1.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURStringGrid1.Resizing;
begin
if Assigned(Skindata) then
  begin
   vScrollBar.Skindata:=Skindata;
   hScrollBar.Skindata:=Skindata;
  end else
  begin
   Skindata:=nil;
   vScrollBar.Skindata:=nil;
   hScrollBar.Skindata:=nil;
  end;
   FTopleft.Targetrect     := Rect(0, 0,FTopleft.Croprect.Width,FTopleft.Croprect.Height);
   FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Croprect.Width,0, self.ClientWidth, FTopRight.Croprect.Height);
   FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0,self.ClientWidth - FTopRight.Croprect.Width,FTop.Croprect.Height);
   FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
   FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Croprect.Width,self.ClientHeight - FBottomRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
   FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width,self.ClientHeight - FBottom.Croprect.Height, self.ClientWidth - FBottomRight.Croprect.Width, self.ClientHeight);
   Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.ClientHeight - FBottomleft.Croprect.Height);
   FRight.Targetrect       := Rect(self.ClientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Croprect.Height);

   FCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight -(FBottom.Croprect.Height));

   resim.FontQuality       := fqSystemClearType;
   resim.FontName          := self.Font.Name;
   resim.FontStyle         := self.Font.Style;
   resim.FontHeight        := self.Font.Height;
//   fchanged                := true;
  // Scrollscreen;

  if Assigned(VScrollbar) then
  with vScrollBar do
  begin
   //Parent    := self.Parent;
    Width     := 20;
    left      := Self.ClientWidth -Width;// + Background.Border);
   // Top       := Self.Top;//Background.Border;
    Height    := Self.Height;// - (Background.Border * 2);
  end;

  if Assigned(hScrollbar) then
  with HScrollBar do
  begin
   // parent    := self.Parent;
    Height     := 20;
   // left       := self.Left;
    Top        := self.ClientHeight-Height;
    Width      := self.Width;
  end;

end;

function TONURStringGrid1.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
end;

function TONURStringGrid1.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
end;

procedure TONURStringGrid1.DblClick;
begin
  inherited DblClick;
end;
























constructor TONURColumn.Create(Collectioni: TCollection);
begin
  FCaption    := '';
  fwidth      := 80;
  fvisible    := True;
  ffont       := TFont.Create;
  fFont.Name  := 'Calibri';
  fFont.Size  := 9;
  fFont.Style := [];
  Ftextalign  := taLeftJustify;

  inherited Create(Collectioni);
end;

destructor TONURColumn.Destroy;
begin
  with TONURColumlist(TOwnedCollection(GetOwner).Owner) do
    if not (csDestroying in ComponentState) then
      if Assigned(FOnDeleteItem) then
      begin
        FOnDeleteItem(Self);
      end;
 if Assigned(ffont) then
    FreeAndNil(ffont);
  Inherited Destroy;
end;

procedure TONURColumn.Assign(Source: TPersistent);
begin
 if (Source is TONURListColums) then
 with (Source as TONURListColums) do
 begin
   Self.FCaption := FCaption;
 end
else
 inherited Assign(Source);
end;

procedure TONURColumn.Delete(Indexi: integer);
begin

end;

{ TONURListColums }

function TONURListColums.GetItem(Indexi: integer): TONURColumn;
Begin
   if Indexi <> -1 then
 Result := TONURColumn(inherited GetItem(Indexi));
End;

procedure TONURListColums.SetItem(Indexi: integer; const Value: TONURColumn);
Begin
   inherited SetItem(Indexi, Value);
  Changed;
End;

procedure TONURListColums.Setcells(Acol, Arow: integer; Avalue: string);
Begin

End;

function TONURListColums.Getcells(Acol, Arow: integer): string;
Begin

End;

procedure TONURListColums.Update(Item: TCollectionItem);
Begin
 TONURColumList(GetOwner).Scrollscreen;
 // inherited Update(Item);
End;

constructor TONURListColums.Create(AOwner: TPersistent;
  ItemClassi: TCollectionItemClass);
Begin
  inherited Create(AOwner, ItemClassi);
End;

function TONURListColums.Add: TONURColumn;
Begin
  Result := TONURColumn(inherited Add);
End;

procedure TONURListColums.Clear;
Begin
  with TONURColumList(GetOwner) do
  begin
    FItemvOffset  := 0;  FFocusedItem := -1;
  end;
End;

procedure TONURListColums.Delete(Indexi: integer);
var
  i:integer;
begin


 for i:=0 to Count-1 do
  Items[i].delete(Indexi);

  Changed;
End;

function TONURListColums.Insert(Indexi: integer): TONURColumn;
Begin
   Result := TONURColumn(inherited Insert(Indexi));
End;

function TONURListColums.Indexof(Value: TONURColumn): Integer;
  var
    i : Integer;
  begin
    Result := -1;
    i      := 0;

    while (i < Count) and (Result = -1) do
      if items[i] = Value then
        Result := i;
End;





{ TONURColumList }



function TONURColumList.Getcells(Acol, Arow: integer): string;
begin
  if (Columns.Count > -1) and (Columns.Count <= Acol) then
     Result := ''
   else
   begin
     if (Items.Count>-1) and (items.Count<=Arow) then
    // if (Columns[Acol].Items.Count > -1) and (Columns[Acol].Items.Count <= Arow) then
       Result := ''
     else
       Result :=Items[Arow].Cells[Acol];//acol].Cells[Arow];// Columns[Acol];//.Items[Arow];
   end;
end;



procedure TONURColumList.Setcells(Acol, Arow: integer; Avalue: string);
begin
  FListItems.Cells[acol,arow]:=avalue;

 { if  FListItems.Count>0 then
  begin
    hScrollbar.Max := FListItems[0].FSize-1;
    vScrollBar.Max := (FListItems.Count - FItemshShown);

    if hScrollBar.Max>0 then
     hScrollBar.Enabled := True
    else
     hScrollBar.Enabled := False;


    if vScrollBar.Max>0 then
     vScrollbar.Enabled := True
    else
     vScrollbar.Enabled := False;
 end;  }
 if fupdatelist=false then
 Invalidate;

 // Scrollscreen;

       //    hScrollBar.Enabled := True;
       //    vScrollBar.Enabled := True;


//  FItemVOffset:=FListItems.Count - FItemsShown;
end;

procedure TONURColumList.SetHeadervisible(AValue: boolean);
begin
  if fheadervisible=AValue then Exit;
  fheadervisible:=AValue;
  Invalidate;
end;


procedure TONURColumList.SetItems(Value: TONURlistItems);
begin
  FListItems.BeginUpdate;
  FListItems.Assign(Value);
  FListItems.EndUpdate;
//  FItemVOffset:=FListItems.Count - FItemsShown;
//  Scrollscreen;
 // Invalidate;
end;

procedure TONURColumList.Setcolums(Value: TONURListColums);
begin
  Fcolumns.BeginUpdate;
  Fcolumns.Assign(Value);
  Fcolumns.EndUpdate;
end;





procedure TONURColumList.VScrollBarChange(Sender: TObject);
begin

  if fmodusewhelll = False then
  begin
    FItemvOffset := VScrollBar.Position;
    Invalidate;
  end;
end;

procedure TONURColumList.HScrollBarChange(Sender: TObject);
begin
  if fmodusewhelll = False then
  begin
    FItemhOffset := HScrollBar.Position;
   // Paint;
    Invalidate;
  end;
end;



function TONURColumList.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
   inherited;
  if not VScrollBar.Visible then exit;
  if FItemVOffset >= VScrollBar.max then exit;
  fmodusewhelll := True;
  VScrollBar.Position := VScrollBar.Position + Mouse.WheelScrollLines;
  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;

function TONURColumList.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
   inherited;
  if not VScrollBar.Visible then exit;

  if FItemVOffset <= 0 then exit;

  fmodusewhelll := True;
  VScrollBar.Position := VScrollBar.Position - Mouse.WheelScrollLines;

  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;



procedure TONURColumList.CNKeyDown(var Message: TWMKeyDown);
var
  x: integer;
begin
  case Message.CharCode of
    VK_RETURN: if (FListItems.Count > 0) and (FFocusedItem > -1) then
      begin
        Invalidate;
        if Assigned(FItemEnterKey) then FItemEnterKey(Self);
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
    VK_PRIOR: if FListItems.Count > 0 then
      begin
        x := FItemVOffset - FItemsShown;
        if x < 0 then x := 0;
        FItemVOffset := x;
        FFocusedItem := x;
        Invalidate;

      end;
    VK_NEXT: if FListItems.Count > 0 then
      begin
        x := FItemVOffset + FItemsShown;
        if x >= FListItems.Count then x := FListItems.Count - 1;
        if FListItems.Count <= FItemsShown then
          FItemVOffset := 0
        else if x > (FListItems.Count - FItemsShown) then
          FItemVOffset := FListItems.Count - FItemsShown
        else
          FItemVOffset := x;
        FFocusedItem := x;
        Invalidate;
      end;
    else
      inherited;
  end;
end;




constructor TONURColumList.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  Width := 380;
  Height := 200;
  TabStop := True;
  skinname := 'columlist';
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];


  FListItems         := TONURlistItems.Create(Self, TONURlistItem);
  Fcolumns           := TONURListColums.Create(Self, TONURColumn);
  fselectcolor       := Clblue;
  FItemVOffset       := 0;
  FItemHOffset       := 0;
  FItemHeight        := 24;
  FheaderHeight      := 24;
  FFocusedItem       := -1;
  FAutoHideScrollBar := True;
  Font.Name          := 'Calibri';
  Font.Size          := 9;
  Font.Style         := [];
  TabStop            := True;
  fbackgroundvisible := True;
  fheadervisible     := True;
  FItemsShown        := 0;
  fcolumindex        := 0;
  Fheaderfont        := Tfont.Create;
  Fheaderfont.Name   := 'Calibri';
  Fheaderfont.Size   := 10;
  Fheaderfont.Style  := [];
  fmodusewhelll      := False;
  fback              := TBGRABitmap.Create(Self.ClientWidth,Self.ClientHeight);
  FTop               := TONURCUSTOMCROP.Create('TOP');
  FBottom            := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter            := TONURCUSTOMCROP.Create('CENTER');
  FRight             := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight          := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight       := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft              := TONURCUSTOMCROP.Create('LEFT');
  FTopleft           := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft        := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  fitems             := TONURCUSTOMCROP.Create('ITEM');
  factiveitems       := TONURCUSTOMCROP.Create('ACTIVEITEM');
  fheader            := TONURCUSTOMCROP.Create('HEADER');

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);


  Customcroplist.Add(fitems);
  Customcroplist.Add(factiveitems);
  Customcroplist.Add(fheader);



  Captionvisible := False;

//  Counter:=0;

  VScrollBar := TONURScrollBar.Create(self);
  with VScrollBar do
  begin
    Parent    := self;
    Skinname  := 'scrollbarv';
    Width     := 25;
    left      := Self.ClientWidth - (25);
    Top       := 0;
    Height    := Self.ClientHeight;
    Max       := 1;
    Min       := 0;
    OnChange  := @VScrollbarchange;
    Position  := 0;
    Skindata  := nil;
   // Enabled  := false;
    Visible   := false;
    AutoHide  := true;
  end;

  HScrollBar := TonURScrollBar.Create(self);
  with HScrollBar do
  begin
    Parent    := self;
    Skinname  := 'scrollbarh';
    Width     := self.ClientWidth;
    left      :=0;
    Top       := self.ClientHeight-25;
    Height    := 25;
    Max       := 1;
    Min       := 0;
    OnChange  := @HScrollbarchange;
    Position  := 0;
    Skindata  := nil;
    Kind      := oHorizontal;
  //  Enabled  := false;
    Visible   := false;
    AutoHide  := true;
  end;

end;

destructor TONURColumList.Destroy;
begin
  Customcroplist.Clear;
  if Assigned(fback) then
    FreeAndNil(fback);
  if Assigned(VScrollBar) then
    FreeAndNil(VScrollBar);
  if Assigned(HScrollBar) then
    FreeAndNil(HScrollBar);

  FreeAndNil(FListItems);
  FreeAndNil(Fcolumns);

  inherited Destroy;
end;

procedure TONURColumList.Scrollscreen;
var
    fark,z: Integer;
begin

  if FListItems.Count > 0 then
  begin
    FItemsShown := (FCenter.Targetrect.Height-FheaderHeight) div FitemHeight;


    if FListItems.Count - FItemsShown > 0 then
    begin
      with vScrollBar do   // vertical  Dikey
      begin

         if (Skindata = nil) then
         Skindata := Self.Skindata;

         if (Skindata <> nil) then
         begin
           Width  := 20;
           left   := Self.ClientWidth - ClientWidth;
           Top    := self.fTOP.Croprect.Height;
           Height := FCenter.Targetrect.Height;
           Max    := (FListItems.Count - FItemsShown);
           Alpha  := self.Alpha;

           if kind<>oVertical then Kind := oVertical;
           if Max>0 then Visible := true;
         End;
      end;
    end;

    fark:=0;

    for z := 0 to Columns.Count - 1 do
    begin
      if Columns[z].Visible=true then
      fark+=Columns[z].Width;

      if fark<=self.ClientWidth then
       FItemshShown:=z;
    end;



    if fark>0 then
    with hScrollBar do
    begin
      if (Skindata = nil) then
        Skindata := Self.Skindata;

      if (Skindata <> nil) then
      begin
        left   := self.Fleft.Croprect.Width;
        Width  := self.ClientWidth-(self.Fleft.Croprect.Width+self.FRight.Croprect.Width);
        Height := 20;
        Top    := self.ClientHeight-clientHeight;

       if (fark>0) and (fark>FCenter.Targetrect.Width) then
        Max  := Columns.Count-FItemshShown
        else
        max  := 0;

       Alpha := self.Alpha;
       if Max>0 then Visible := true;
      end;
    end;
  end else
  begin

    with vScrollBar do
    begin
     Width  := 20;
     Top    := 5;
     Height := Self.ClientHeight - 15;
     left := Self.ClientWidth - (ClientWidth+5);
     if (Skindata= nil) then
     Skindata:=self.Skindata;
    end;
    with HScrollBar do
    begin
     left   := 5;
     Height := 20;
     Width  := self.ClientWidth-(vScrollBar.Width+5);
     Top    := self.ClientHeight-(clientHeight+5);
     if (Skindata= nil) then
     Skindata:=self.Skindata;
    end;

  end;
end;



procedure TONURColumList.SetSkindata(Aimg: TONURImg);
Begin
  Inherited Setskindata(Aimg);
  if Assigned(Skindata) then
  begin
   resizing;
  end;
 End;

procedure TONURColumList.Resize;
begin
 if ([csLoading,csDestroying]*ComponentState<>[]) then exit;
 //if AutoSizeDelayed then exit;
  inherited Resize;
  if Assigned(Skindata) then
   resizing
end;



procedure TONURColumList.resizing;
begin
  if Assigned(Skindata) then
  begin
   //vScrollBar.Skindata:=Skindata;
   //hScrollBar.Skindata:=Skindata;


   FTopleft.Targetrect     := Rect(0, 0,FTopleft.Croprect.Width,FTopleft.Croprect.Height);
   FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Croprect.Width,0, self.ClientWidth, FTopRight.Croprect.Height);
   FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0,self.ClientWidth - FTopRight.Croprect.Width,FTop.Croprect.Height);
   FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
   FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Croprect.Width,self.ClientHeight - FBottomRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
   FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width,self.ClientHeight - FBottom.Croprect.Height, self.ClientWidth - FBottomRight.Croprect.Width, self.ClientHeight);
   Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.ClientHeight - FBottomleft.Croprect.Height);
   FRight.Targetrect       := Rect(self.ClientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Croprect.Height);
   FCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.ClientWidth - (FRight.Croprect.Width), self.ClientHeight -(FBottom.Croprect.Height));



   fback.SetSize(0, 0);
   fback.SetSize(self.ClientWidth, self.ClientHeight);


   //ORTA CENTER
   DrawPartnormal(FCenter.Croprect,fback,Skindata.Fimage, FCenter.Targetrect, alpha);
   //SOL ÜST TOPLEFT
   DrawPartnormal(FTopleft.Croprect, fback,Skindata.Fimage, FTopleft.Targetrect, alpha);
    //SAĞ ÜST TOPRIGHT
   DrawPartnormal(FTopRight.Croprect, fback,Skindata.Fimage, FTopRight.Targetrect, alpha);
    //UST TOP
   DrawPartnormal(ftop.Croprect, fback,Skindata.Fimage, ftop.Targetrect, alpha);
    // SOL ALT BOTTOMLEFT
   DrawPartnormal(FBottomleft.Croprect, fback,Skindata.Fimage, FBottomleft.Targetrect, alpha);
   //SAĞ ALT BOTTOMRIGHT
   DrawPartnormal(FBottomRight.Croprect, fback,Skindata.Fimage, FBottomRight.Targetrect, alpha);
   //ALT BOTTOM
   DrawPartnormal(FBottom.Croprect, fback,Skindata.Fimage, FBottom.Targetrect, alpha);
   // SOL ORTA CENTERLEFT
   DrawPartnormal(Fleft.Croprect, fback,Skindata.Fimage, fleft.Targetrect, alpha);
   // SAĞ ORTA CENTERRIGHT
   DrawPartnormal(FRight.Croprect, fback,Skindata.Fimage,FRight.Targetrect, alpha);

   Scrollscreen;

 // end else
//  begin

  end;
end;






procedure TONURColumList.Paint;
var
 // a, b, z, i,gt: integer;
  x1, x2, x3, x4{,fheaderh, fark,fark2}: integer;

   a, b, k, z, i, gt: integer;
 // x1, x2, x3, x4: integer;
 tmp:TBGRABitmap;
begin

   if (not Visible) then Exit;



   if (Skindata <> nil) and not (csDesigning in ComponentState) then
   begin
    tmp := TBGRABitmap.Create(FCenter.Targetrect.Width,FCenter.Targetrect.Height);//self.ClientWidth-Fleft.Croprect.Width , self.ClientHeight-FTop.Croprect.Height);
     if Fcolumns.Count > 0 then
     begin

      a  := Fleft.Croprect.Width;
      x1 := 0;
      x2 := 0;
      x3 := 0;
      x4 := 0;
    //  fark2:=0;
      FItemsvShown := FCenter.Targetrect.Height div FitemHeight;
      FItemshShown := 0;


      tmp.FontQuality :=fqSystemClearType;
      tmp.FontName   := Fheaderfont.Name;
      tmp.FontHeight := Fheaderfont.Height;
      tmp.FontStyle  := Fheaderfont.Style;

        if (fheadervisible = True)  then    // if header visible?
        begin
          for z := 0+abs(FItemhOffset) to (Fcolumns.Count - 1) do  // columns
          begin
            if Fcolumns[z].Visible = True then
            begin
            //  fark2+=Fcolumns[z].Width;

              //if fheadervisible = True then
                b := a + FItemHeight;
           //   else
            //    b := a;

              if z > 0 then
                x1 := x3
              else
                x1 := a;

              x2 := a;
              //x3 := x1 + (Fcolumns[z].Width);
              x4 := a + FheaderHeight;

              if vScrollBar.Visible then
               x3:=x1 + (Fcolumns[z].Width)+vScrollBar.Width
              else
               x3:=x1 + (Fcolumns[z].Width);



             // if (fheadervisible = True)  then
              //begin
                if Fcolumns[z].Caption<>'' then
                  DrawPartnormali(self,fheader.Croprect, tmp, x1,x2,x3,x4, alpha,Fcolumns[z].Caption,Fcolumns[z].Textalign,ColorToBGRA(fheader.Fontcolor{Fheaderfont.Color}, alpha))
                else
                  DrawPartnormali(self,fheader.Croprect, tmp, x1,x2,x3,x4, alpha);
            //  end;

             if x3>FCenter.Targetrect.Width{(self.ClientWidth) }then break;
            end;
          end;

      //   b:=FTop.Croprect.Height+fHeaderHeight;
         // fheaderh:=FheaderHeight;
       // end
       // else
       // begin
       //  fheaderh:=0;
       //  b:=FTop.Croprect.Height;
        end;


        a  := Fleft.Croprect.Width;
        x1:=0;
        x2:=0;
        x3:=0;
        x4:=0;

       for z := 0+abs(FItemhOffset) to (Fcolumns.Count - 1) do  // columns
       begin
         if fheadervisible = True then
          b := a + fHeaderHeight //FItemHeight
         else
          b := a;

         if z > 0 then
          x1 := x3
         else
          x1 := a;

          x2 := a;
         // x3 := x1 + (Fcolumns[z].Width);
        //  x4 := a + FheaderHeight;


          if vScrollBar.Visible then
           x3:=x1 + (Fcolumns[z].Width)+vScrollBar.Width
          else
           x3:=x1 + (Fcolumns[z].Width);


         if hScrollbar.Visible then
          gt:=(FItemvOffset + ((self.ClientHeight-hScrollbar.Height) div FItemHeight))
         else
          gt:=FItemvOffset + (self.ClientHeight div FItemHeight);


          tmp.FontName   := Fcolumns[z].font.Name;
          tmp.FontHeight := Fcolumns[z].Font.Height;
          tmp.FontStyle  := Fcolumns[z].Font.Style;


          for i := FItemvOffset to gt  do
          begin
            if Cells[z,i]<>'' then
            begin


               if i = FFocusedItem then
              // begin
                 DrawPartnormali(self,factiveitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(factiveitems.fontColor, alpha))

             //    if vScrollBar.Visible then
             //      DrawPartnormali(self,factiveitems.Croprect, tmp, x1,b,x3+vScrollBar.Width,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(Font.Color, alpha))
             //    else
             //      DrawPartnormali(self,factiveitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(Font.Color, alpha));
             //  end else
            //   begin
               else
                DrawPartnormali(self,fitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(fitems.fontColor, alpha))

               //  if vScrollBar.Visible then
              //     DrawPartnormali(self,fitems.Croprect, tmp, x1,b,x3+vScrollBar.Width,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(Font.Color, alpha))
               //  else
              //     DrawPartnormali(self,fitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha,Cells[z,i],FListItems[z].Ftextalign,ColorToBGRA(Font.Color, alpha));
             //  end;
            end else
            begin
                if i = FFocusedItem then
               // begin
                //   if vScrollBar.Visible then
                //     DrawPartnormali(self,factiveitems.Croprect, tmp, x1,b,x3+vScrollBar.Width,b+FItemHeight, alpha)
                 //  else
                    DrawPartnormali(self,factiveitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha)
               // end else
              //  begin
                //   if vScrollBar.Visible then
                //    DrawPartnormali(self,fitems.Croprect, tmp, x1,b,x3+vScrollBar.Width,b+FItemHeight, alpha)
                  else
                    DrawPartnormali(self,fitems.Croprect, tmp, x1,b,x3,b+FItemHeight, alpha);
               // end;
            end;

            b +=FItemHeight;
            if b >= (FCenter.Targetrect.Height-HScrollBar.Height) then Break;
          end; // items end


         FItemshShown +=1;
         if x3>=(FCenter.Targetrect.Width-vScrollBar.Width) then Break;
       end;  // columns end
     end;

     resim.SetSize(0, 0);
     resim.SetSize(self.ClientWidth, self.ClientHeight);
     resim.PutImage(0,0,fback,dmDrawWithTransparency);
     resim.PutImage(0,0,tmp,dmDrawWithTransparency);
//     resim.BlendImage(0, 0, tmp, boTransparent);
     tmp.Free;


  end
  else
  begin
    resim.SetSize(0, 0);
    resim.SetSize(self.ClientWidth, self.ClientHeight);
    resim.Fill(BGRA(80, 80, 80,alpha), dmSet);
    FCenter.Targetrect.Height := self.Height;
  end;

  inherited Paint;
end;




function TONURColumList.Itemrectcel(Item, Col: integer): Trect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  if fheadervisible then
    r.Top := FheaderHeight + FTop.Croprect.Height;//(FTop.FSBottom - FTop.FSTop);

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top := r.top + ((Item - FItemvOffset) * FItemHeight); // + 2; // 2 = TOP MARGIN!!
    r.Bottom := r.Top + FItemHeight;
    r.Left := Fleft.Croprect.Width;//Fleft.FSright - Fleft.FSLeft;

    if vScrollBar.Visible then
      r.Right := vScrollBar.Left
    else
      r.Right := columns[col].Width -Fleft.Croprect.Width; //(Fleft.FSright - Fleft.FSLeft);
  end;

  Result := r;

end;

function TONURColumList.ItemRect(Item: integer): TRect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  if fheadervisible then
    r.Top := FheaderHeight + FTop.Croprect.Height;//(FTop.FSBottom - FTop.FSTop);

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top := r.top + ((Item - FItemvOffset) * FItemHeight); // + 2; // 2 = TOP MARGIN!!
    r.Bottom := r.Top + FItemHeight;
    r.Left := Fleft.Croprect.Width;//Fleft.FSright - Fleft.FSLeft;

    if vScrollBar.Visible then
      r.Right := vScrollBar.Left
    else
      r.Right := Width - Fleft.Croprect.Width;//(Fleft.FSright - Fleft.FSLeft);
  end;

  Result := r;

end;

function TONURColumList.GetItemAt(Pos: TPoint): integer;
var
  i, m, w: integer;
begin
  Result := -1;

  if fheadervisible = True then
    w := FheaderHeight
  else
    w := 0;

  w:=w+FTop.Croprect.Height;

  if Pos.Y >= w then
    Result := FItemvOffset + ((Pos.Y - w) div FItemHeight);

  m := 0;
  fcolumindex := -1;
  w := 0;
  if (pos.X >= 0) then
    for i := 0 to Columns.Count - 1 do
    begin
      w := w + columns[i].Width;
      if (m <= Pos.x) and (w >= pos.x) then
      begin
        fcolumindex := i;
        break;
      end;
      m := w;
    end;
end;



procedure TONURColumList.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
var
  Clickeditem: integer;
begin
  FFocusedItem := -1;
  Clickeditem := -1;
  if (FListItems.Count > 0) then
  begin

    if button = mbLeft then
    begin

      ClickedItem := GetItemAt(Point(X, Y));

      if (ClickedItem > -1) and (fcolumindex > -1) then
      begin
        if (Clickeditem <=FListItems.Count-1) then
          FFocusedItem := ClickedItem;

        if Assigned(FOnCellclick) then  FOnCellclick(self, FListItems[Clickeditem]);
        Invalidate;

      end;
      SetFocus;
    end;
  end;

  inherited Mousedown(Button, Shift, X, Y);
end;

procedure TONURColumList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  if (Button = mbLeft) then
    inherited MouseUp(Button, Shift, X, Y)
  else if (Button = mbRight) and Assigned(PopupMenu) and (not PopupMenu.AutoPopup) then
    PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

end;

procedure TONURColumList.MouseEnter;
begin
  inherited MouseEnter;
 // Scrollscreen;
end;

procedure TONURColumList.MouseLeave;
begin
  inherited MouseLeave;
 { if HScrollBar.Visible=true then
  HScrollBar.Visible:=false;
   if vScrollBar.Visible=true then
  vScrollBar.Visible:=false; }
end;

procedure TONURColumList.Delete(indexi: integer);
begin
    FListItems.Delete(Indexi);
end;

procedure TONURColumList.BeginUpdate;
begin
  FListItems.BeginUpdate;
  fupdatelist:=true;
end;

procedure TONURColumList.EndUpdate;
begin
  fupdatelist:=false;
  FListItems.EndUpdate;
end;

procedure TONURColumList.Clear;
begin
  FListItems.Clear;
end;

procedure TONURColumList.MoveUp;
begin
  if FListItems.Count > 0 then
  begin

    if (FFocusedItem > (FItemvOffset + FItemsShown)) or (FFocusedItem < (FItemvOffset)) then
    begin
      FFocusedItem := FItemvOffset;
    end
    else if (FFocusedItem > 0) and (FFocusedItem < FListItems.Count) then
    begin
      Dec(FFocusedItem);

      if ((FFocusedItem - FItemvOffset) = 0) and (FItemvOffset > 0) then
        Dec(FItemvOffset);

    end;
  end;
end;





procedure TONURColumList.MoveDown;
begin
  if FListItems.Count > 0 then
  begin
    if (FFocusedItem > (FItemvOffset + FItemsShown)) or
      (FFocusedItem < (FItemvOffset)) then
    begin
      FFocusedItem := FItemvOffset;
    end
    else if (FFocusedItem >= 0) and (FFocusedItem < FListItems.Count - 1) then
    begin
      Inc(FFocusedItem);       // eğer scrollbar kaydırılması gerekiyorssa
      if (FFocusedItem - FItemvOffset) > FItemsShown - 1 then
      begin
        Inc(FItemvOffset);
      end;
    end;
  end;
end;

procedure TONURColumList.MoveHome;
begin
  if FListItems.Count > 0 then
  begin
    FFocusedItem := 0;
    FItemvOffset := 0;
  end;
end;

procedure TONURColumList.MoveEnd;
begin
  if FListItems.Count > 0 then
  begin
    FFocusedItem := FListItems.Count - 1;

    if (FListItems.Count - FItemsShown) >= 0 then
      FItemvOffset := FListItems.Count - FItemsShown
    else
      FItemvOffset := 0;
  end;

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

procedure TOnurCellStrings.BeginUpdate;
begin
  FUpdateCount := FUpdateCount +1;
end;

procedure TOnurCellStrings.EndUpdate;
begin
    if FUpdateCount > 0 then
    begin
      FUpdateCount := FUpdateCount -1;
      if FUpdateCount=0 then
   //    Invalidate;
       // Update;
    end;
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

{ TONURStringGrid }

procedure TONURStringGrid.editchange(sender: TObject);
begin
   if Assigned(FeditorEdit) then
  begin
   SetCell(fcolumindex,FFocusedItem,FeditorEdit.Text);
//   fchanged:=true;
   Invalidate;
  end;
end;



function TONURStringGrid.GetCellval: string;
begin
 if (FFocusedItem>-1) and (fcolumindex>-1)  then
  Result:= FCells[FFocusedItem,FItemhOffset+fcolumindex];//GetCell(FFocusedItem,fcolumindex);
end;

function TONURStringGrid.GetColWidths(aCol: Integer): Integer;
begin
  result:=FcolwitdhA[acol];
end;

function TONURStringGrid.GetItemAt(Pos: TPoint): Integer;
var
  i,m,w,p,o: Integer;
begin
  Result := -1;
  if Pos.Y >= 0 then
    Result := FItemvOffset + (Pos.Y div FItemHeight);

  // FOR EDITING
  if result>0 then
  begin

    Fcellposition  := Point(0,0);
    Fcellvalue     := '';
    Fcelleditwidth := 0;

    m:=0;
    fcolumindex:=-1;
    w:=0;
    if (pos.X>=0) then
    for i:=0 to fsize.x-1 do
    begin
       w:=w+FcolwitdhA[i];
      if (m<=Pos.x) and (w>=pos.x)then
      begin
       fcolumindex:=i;
       break;
      end;
      m:=w;
    end;

    p:=0;

    o:=0;
    if (pos.y>=0) then
    for i:=0 to fsize.y-1 do
    begin
      o:=o+FItemHeight;
      if (p<=Pos.y) and (o>=pos.y)then
       break;
      p:=o;
    end;




   Fcellposition  := Point(m,p);

   if fcolumindex<0 then exit;
   Fcellvalue     := FCells[Result,FItemhOffset+fcolumindex];
   Fcelleditwidth := FcolwitdhA[fcolumindex];

  end;
end;

procedure TONURStringGrid.SetColWidths(aCol: Integer; AValue: Integer);
begin
  if Length(FcolwitdhA)>0 then
 begin
  FcolwitdhA[acol]:=AValue;
  Invalidate;

 end;
end;

procedure TONURStringGrid.VscrollBarChange(Sender: Tobject);
begin
 if fmodusewhelll=false then
   begin
     FItemvOffset := vScrollBar.Position;
     Invalidate;
   end;
end;

procedure TONURStringGrid.HScrollBarChange(Sender: TObject);
begin
    if fmodusewhelll=false then
 begin
   FItemhOffset := hScrollBar.Position;
//   fchanged:=true;
   Invalidate;
 end;
end;

function TONURStringGrid.GetCell(X, Y: integer): string;
begin
  Result := FCells[Y, X];
end;

function TONURStringGrid.GetColCount: integer;
begin
 Result := fSize.x;
end;

function TONURStringGrid.GetRowCount: integer;
begin
 Result := fSize.Y;
end;

procedure TONURStringGrid.SetCell(X, Y: integer; AValue: string);
 var
  i, p: integer;
begin
  fmodusewhelll:=true;
  i := FSize.X;
  p := FSize.y;
  if x >= i then
    Inc(i);
  if y >= p then
   Inc(p);


  SetSize(point(i, p));
  FCells[Y, X] := AValue;

  if Length(FcolwitdhA)-1<X then
  begin
    SetLength(FcolwitdhA,fsize.x); // For colwidth
    FcolwitdhA[x]:=fcolwidth;  // default colwidth
  end;

 fmodusewhelll:=false;
end;

procedure TONURStringGrid.SetColCount(AValue: integer);
begin

  SetSize(Point(AValue, FSize.Y));
 // SetLength(FcolwitdhA,AValue);
 // FcolwitdhA[AValue]:=fcolwidth;

end;

procedure TONURStringGrid.SetRowCount(AValue: integer);
begin
  SetSize(Point(FSize.X, AValue));
end;

procedure TONURStringGrid.SetSize(AValue: TPoint);
begin
 if (FSize.X = AValue.X) and (FSize.Y = AValue.Y) then Exit;
   FSize := AValue;
   SetLength(FCells, FSize.Y, FSize.X);
end;

constructor TONURStringGrid.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);


 // ControlStyle            := ControlStyle - [csOpaque];
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  Width                   := 150;
  Height                  := 150;
  Parent                  := TWinControl(AOwner); // Remover!?
  FItemvOffset            := 0;
  FItemhOffset            := 0;
//  fItemscount             := 0;
  FItemHeight             := 24;
  FheaderHeight           := 24;
  FFocusedItem            := -1;
  Font.Name               := 'Calibri';
  Font.Size               := 9;
  Font.Style              := [];
  fcolwidth               := 80;
  TabStop                 := True;
  frowselect              := False;
  FItemsvShown            := 10;
  FItemshShown            := 5;
  freadonly               := true;
  fcolumindex             := 0;
  Fcellposition           := Point(0,0);
  Fcellvalue              := '';
  Fcelleditwidth          := 0;
  Captionvisible          := False;
  FUpdateCount            := 0;

  skinname                := 'stringrid';
    FTop                  := TONURCUSTOMCROP.Create('TOP');
//  FTop.cropname         := 'TOP';
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
//  FBottom.cropname      := 'BOTTOM';
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
//  FCenter.cropname      := 'CENTER';
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
//  FRight.cropname       := 'RIGHT';
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
//  FTopRight.cropname    := 'TOPRIGHT';
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
//  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
//  Fleft.cropname        := 'LEFT';
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
//  FTopleft.cropname     := 'TOPLEFT';
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
//  FBottomleft.cropname  := 'BOTTOMLEFT';


  factiveitems            := TONURCUSTOMCROP.Create('ACTIVEITEM');
//  factiveitems.cropname   := 'ACTIVEITEM';
  fitems                  := TONURCUSTOMCROP.Create('ITEM');
//  fitems.cropname         := 'ITEM';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(fitems);
  Customcroplist.Add(factiveitems);




  vScrollBar := TONURScrollBar.Create(nil);
  with vScrollBar do
  begin
    AutoSize  := false;
    Parent    := self;
    Enabled   := False;
    Skinname  := 'scrollbarv';
    Skindata  := nil;//Self.Skindata;
    Width     := 20;
    left      := Self.ClientWidth -Width;// + Background.Border);
    Top       := 0;//Self.Top;//Background.Border;
    Height    := Self.Height;// - (Background.Border * 2);
    Max       := 1;//Flist.Count;
    Min       := 0;
    OnChange  := @vScrollbarchange;
    Position  := 0;
   // Align     := alRight;
  //  Visible   := false;
    Kind      := oVertical;
  //  SetSubComponent(true);
  end;

  HScrollBar := TONURScrollBar.Create(nil);
  with HScrollBar do
  begin
    AutoSize   := false;
    parent     := self;
    Enabled    := False;
    Skinname   := 'scrollbarh';
    Skindata   := nil;
    Height     := 20;
    left       := 0;//self.Left;
    Top        := self.ClientHeight-Height;
    Width      := self.Width;
    Max        := 1;
    Min        := 0;
    OnChange   := @hScrollBarChange;
    Position   := 0;
//    Align      := alBottom;
//    Visible    := false;
    Kind       := oHorizontal;
 //   SetSubComponent(true);
  end;
end;

destructor TONURStringGrid.Destroy;
 var
   i:byte;
 begin
{   for i:=0 to Customcroplist.Count-1 do
   TONURCUSTOMCROP(Customcroplist.Items[i]).free;
}
   Customcroplist.Clear;

  if Assigned(VScrollbar) then VScrollbar.Free;// FreeAndNil(VScrollbar);
  if Assigned(HScrollbar) then HScrollbar.Free;// FreeAndNil(HScrollbar);

  inherited Destroy;
end;

procedure TONURStringGrid.SaveToFile(s: string);
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

procedure TONURStringGrid.LoadFromFile(s: string);
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
  // Scrollscreen;
//  fchanged:=true;
   Invalidate;
end;

procedure TONURStringGrid.Clear;
begin
  FSize.x := 0;
  FSize.y := 0;

 SetLength(FCells, 0);
 Finalize(fsize);
// fchanged:=true;
 Invalidate;
end;

procedure TONURStringGrid.BeginUpdate;
begin
  FUpdateCount := FUpdateCount +1;
end;

procedure TONURStringGrid.EndUpdate;
begin
  if FUpdateCount > 0 then
    begin
      FUpdateCount := FUpdateCount -1;
      if FUpdateCount=0 then
       //TONURColumList(GetOwner).
       Invalidate;
       // Update;
    end;
end;

function TONURStringGrid.Searchstring(col: integer; Search: string): integer;
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

procedure TONURStringGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
 Var
  Clickeditem: Integer;
begin
  if Assigned(FeditorEdit) then FreeAndNil(FeditorEdit);



  if fsize.x>0 then
  begin

    if button = mbLeft then
    begin
     FFocusedItem:= -1;
     Clickeditem := -1;

      ClickedItem := GetItemAt(Point(X, Y));


      if (ClickedItem>-1) and (fcolumindex>-1) then
      begin
       if (Clickeditem<=RowCount-1) then FFocusedItem:=ClickedItem;

       if Assigned(FOnCellclick) then  FOnCellclick(self,fcolumindex,Clickeditem,Fcellvalue);
//       fchanged:=true;
       Invalidate;
      end;
      SetFocus;
    End;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TONURStringGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TONURStringGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
end;


procedure TONURStringGrid.SetSkindata(Aimg: TONURImg);
Begin
  Inherited Setskindata(Aimg);
  if Assigned(Skindata) then
  Resizing;
 End;

procedure TONURStringGrid.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURStringGrid.Resizing;
begin
  if Assigned(Skindata) then
  begin
   vScrollBar.Skindata:=Skindata;
   hScrollBar.Skindata:=Skindata;
  end else
  begin
   Skindata:=nil;
   vScrollBar.Skindata:=nil;
   hScrollBar.Skindata:=nil;
   exit;
  end;

   FTopleft.Targetrect     := Rect(0, 0,FTopleft.Croprect.Width,FTopleft.Croprect.Height);
   FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Croprect.Width,0, self.ClientWidth, FTopRight.Croprect.Height);
   FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0,self.ClientWidth - FTopRight.Croprect.Width,FTop.Croprect.Height);
   FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width, self.ClientHeight);
   FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Croprect.Width,self.ClientHeight - FBottomRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
   FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width,self.ClientHeight - FBottom.Croprect.Height, self.ClientWidth - FBottomRight.Croprect.Width, self.ClientHeight);
   Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.ClientHeight - FBottomleft.Croprect.Height);
   FRight.Targetrect       := Rect(self.ClientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Croprect.Height);

   FCenter.Targetrect      := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight -(FBottom.Croprect.Height));

   resim.FontQuality       := fqSystemClearType;
   resim.FontName          := self.Font.Name;
   resim.FontStyle         := self.Font.Style;
   resim.FontHeight        := self.Font.Height;
//   fchanged                := true;
  // Scrollscreen;

  if Assigned(VScrollbar) then
  with vScrollBar do
  begin
   //Parent    := self.Parent;
    Width     := 20;
    left      := Self.ClientWidth -Width;// + Background.Border);
   // Top       := Self.Top;//Background.Border;
    Height    := Self.Height;// - (Background.Border * 2);
  end;

  if Assigned(hScrollbar) then
  with HScrollBar do
  begin
   // parent    := self.Parent;
    Height     := 20;
   // left       := self.Left;
    Top        := self.ClientHeight-Height;
    Width      := self.Width;
  end;


end;



procedure TONURStringGrid.paint;
 var
  i, z ,a, b,b1,b2 : Integer;
  x1, x2, x3 : SmallInt;
  clr:TBGRAPixel;
  txt:string;
begin
  if (not Visible) then Exit;
//  if fchanged=false then exit; // for loop paint
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    //CENTER
     DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);

    if FSize.X>0 then
    begin
      clr:=ColorToBGRA(FCenter.FontColor, alpha);
      FItemsvShown := (FCenter.Targetrect.Height-HScrollBar.Height) div FitemHeight;
      b2:= FCenter.Targetrect.Height mod FitemHeight;
      x3 := (Fcenter.Targetrect.Width-vScrollbar.Width);
      x2 := 0;
      x1 := 0;

      for i:=FItemhOffset to Fsize.x do
      begin
        Inc(x2);
        x1 := x1+FcolwitdhA[i];
        if x1>=x3 then
        begin
         FItemshShown := x2;
         break;
        end;
      end;

    //  writeln(FItemhOffset,'   ',Fsize.x,'   ',Fsize.y,'  ',FItemshShown);

      a  := Fleft.Croprect.Width;
      x3 := a;
   //   b2:= FCenter.Targetrect.Height mod FitemHeight;
    //  x3 := 0;//(Fcenter.Targetrect.Width-vScrollbar.Width);
      x2 := 0;
      x1 := 0;



      for z:=FItemhOffset to FItemhOffset+FItemshShown do//  columns
      begin

      //     WriteLn(z,' ',FcolwitdhA[z],'    ',x3);
        if z>FSize.x-1 then break;


        b  := a;
        x1 := x3;
        x3 := x1+FcolwitdhA[z];


        if z=FItemhOffset+FItemshShown then  //if x3>=(FCenter.Targetrect.Width{-vScrollBar.Width}) then
         x3+=FRight.Croprect.Width;

        for i :=FItemvOffset to FItemvOffset+FItemsvShown do
        begin

       //   WriteLn(i,' ',FCells[i,z],'    ',z);

          if i>FSize.y-1 then break;

          if i=FItemvOffset+FItemsvShown then
            b1:=b2
           else
            b1:=0;

          if FCells[i,z]<>'' then
          begin
            txt:= FCells[i,z];
         //   if resim.TextSize(txt).cx>x1+x3 then
         //   txt:=maxlengthstring(txt,x1+x3);


             if i = FFocusedItem then
             begin
              // if vScrollBar.Visible then
                 DrawPartnormali(factiveitems.Croprect, self, x1,b,x3+vScrollBar.Width,b+FItemHeight+b1, alpha,txt,taLeftJustify,ColorToBGRA(factiveitems.FontColor, alpha));
              // else
               // DrawPartnormali(factiveitems.Croprect, self, x1,b,x3,b+FItemHeight+b1, alpha,FCells[i,z],taLeftJustify,clr);
             end else
             begin
             //  if vScrollBar.Visible then
                 DrawPartnormali(fitems.Croprect, self, x1,b,x3+vScrollBar.Width,b+FItemHeight+b1, alpha,txt,taLeftJustify,ColorToBGRA(fitems.FontColor, alpha));
             //  else
              //  DrawPartnormali(fitems.Croprect, self, x1,b,x3,b+FItemHeight+b1, alpha,FCells[i,z],taLeftJustify,clr);

             end;
          end else
          begin
             if i = FFocusedItem then
             begin
             // DrawPartnormali(factiveitems.Croprect, self, x1,b,x3,b+FItemHeight, alpha)

              //if vScrollBar.Visible then
                 DrawPartnormali(factiveitems.Croprect, self, x1,b,x3+vScrollBar.Width,b+FItemHeight+b1, alpha);
              // else
               // DrawPartnormali(factiveitems.Croprect, self, x1,b,x3,b+FItemHeight+b1, alpha);
             end else
             begin
                // if vScrollBar.Visible then
                 DrawPartnormali(fitems.Croprect, self, x1,b,x3+vScrollBar.Width,b+FItemHeight+b1, alpha);
               // else
               //  DrawPartnormali(fitems.Croprect, self, x1,b,x3,b+FItemHeight+b1, alpha);

             end;
          end;

          b +=FItemHeight;
          if b >= (FCenter.Targetrect.Height-HScrollBar.Height) then Break;
        end;

        // FItemshShown +=1;
         if x3>=(FCenter.Targetrect.Width-vScrollBar.Width) then Break;
      end;

       vScrollbar.Max := (fsize.y-1) - FItemsvShown;
       hScrollBar.Max := (fsize.x-1) - FItemshShown;

  //   if FAutoHideScrollBar then
  //   begin
       if hScrollBar.Max>0 then
        hScrollBar.Enabled := True
       else
        hScrollBar.Enabled := False;

       // if (FSize.y * FItemHeight)>self.ClientHeight then
       if vScrollBar.Max>0 then
        vScrollbar.Enabled := True
       else
        vScrollbar.Enabled := False;
  // end;


    end;

  //SOL ÜST TOPLEFT
    DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
    //SAĞ ÜST TOPRIGHT
    DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
    //UST TOP
    DrawPartnormal(ftop.Croprect, self, ftop.Targetrect, alpha);
    // SOL ALT BOTTOMLEFT
    DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
    //SAĞ ALT BOTTOMRIGHT
    DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
    //ALT BOTTOM
    DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
    // SOL ORTA CENTERLEFT
    DrawPartnormal(Fleft.Croprect, self, fleft.Targetrect, alpha);
    // SAĞ ORTA CENTERRIGHT
    DrawPartnormal(FRight.Croprect, self,FRight.Targetrect, alpha);

  //  if Crop then
  //   CropToimg(resim);

  end else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    FCenter.Targetrect.Height := self.Height;
  end;
 // writeln('asdasdasd');
//  fchanged:=false;
  inherited paint;
end;

function TONURStringGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  fmodusewhelll:=True;
  if not vscrollBar.visible then exit;
  vscrollBar.Position := vscrollBar.Position+Mouse.WheelScrollLines;
  FItemvOffset := vscrollBar.Position;
  Result := True;
//  fchanged:=true;
  Invalidate;
  fmodusewhelll:=false;
end;

function TONURStringGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
   Result:=inherited DoMouseWheelUp(Shift, MousePos);

   fmodusewhelll:=True;
   if not vscrollBar.visible then exit;
   vscrollBar.Position :=vscrollBar.Position-Mouse.WheelScrollLines;
   FItemvOffset := vscrollBar.Position;
   Result := True;
//   fchanged:=true;
   Invalidate;
   fmodusewhelll:=false;
end;

procedure TONURStringGrid.DblClick;
  begin
  Inherited DblClick;

 if Assigned(FeditorEdit) then FreeAndNil(FeditorEdit);
 if RowCount<1 then exit;
 if freadonly then exit;

  FeditorEdit:=TEdit.Create(nil);
  with FeditorEdit do
  begin
     //Parent     := nil;
     name       := 'XYZeditOnurstringGridZYX';
     Visible    := false;
     AutoSize   := false;
     Width      := Fcelleditwidth;
     Height     := FItemHeight;
     Left       := Fcellposition.x-Width; //fcolumindex*FcolwitdhA[fcolumindex];
     top        := Fcellposition.y-Height;//FItemHeight*FFocusedItem;
     Color      := self.resim.Colors[1,1].ToColor;// self.Background.Startcolor;
     Font.Color := self.Font.color;
     BorderStyle:= bsNone;
     text       := Fcellvalue;
     OnChange   := @editchange;
     Parent     := self;
     Visible    := True;
     SetFocus;
  end;
end;








{ TONURColumn }
{
Constructor TONURColumn.Create(Collectioni: Tcollection);
Begin
  FCaption := '';
  fwidth := 80;
  fvisible := True;
  ffont := TFont.Create;
  fFont.Name := 'Calibri';
  fFont.Size := 9;
  fFont.Style := [];
  Ftextalign:=taLeftJustify;

  inherited Create(Collectioni);
End;

Destructor TONURColumn.Destroy;
Begin
  with TONURColumList(TOwnedCollection(GetOwner).Owner) do
    if not (csDestroying in ComponentState) then
      if Assigned(FOnDeleteItem) then
      begin
        FOnDeleteItem(Self);

      end;
 if Assigned(ffont) then
    FreeAndNil(ffont);
  Inherited Destroy;
End;

Procedure TONURColumn.Assign(Source: Tpersistent);
Begin
    if (Source is TONURListColums) then
    with (Source as TONURListColums) do
    begin
      Self.FCaption := FCaption;
    end
  else
    inherited Assign(Source);
End;

Procedure TONURColumn.Delete(Indexi: Integer);
Begin

End;

}
function TONURlistItem.GetCell(X: integer): string;
begin
  if x<=Length(FCells) then
 Result:=FCells[x];
end;

function TONURlistItem.GetColCount: integer;
begin
  Result:=fsize;
end;

procedure TONURlistItem.SetCell(X: integer; AValue: string);
var
  a:integer;
begin
  a:=TONURColumList(TOwnedCollection(GetOwner).Owner).Columns.Count;
  if x>a then
   SetColCount(x)
  else
   SetColCount(a);

  FCells[x]:=AValue;
end;

procedure TONURlistItem.SetColCount(AValue: integer);
begin
   if (Length(FCells)>=AValue) then Exit;
   SetLength(FCells, AValue);
   FSize:=AValue;
end;

function TONURlistItem.Insert(Indexi: integer; avalue: string
  ): TONURlistItem;
begin
  if Length(FCells)>= Indexi then
  SetCell(Indexi,avalue);
end;

constructor TONURlistItem.Create(Collectioni: TCollection);
var
  a:integer;
begin

   ffont          := TFont.Create;
   fFont.Name     := 'Calibri';
   fFont.Size     := 9;
   fFont.Style    := [];


 // a:= TONURColumList(TOwnedCollection(GetOwner).Owner).Columns.Count;
 // SetLength(FCells,a);
  FSize:=0;//a;
 // ffont:=Tfont.Create;
 // ffont.Assign(TONURColumList(TOwnedCollection(GetOwner).Owner).Font);
  inherited Create(Collectioni);

end;


procedure TONURlistItem.Add(s: string);
begin
//  FSize+=1;
//  SetCell(FSize,s);
end;

procedure TONURlistItem.Clear;
begin
  FSize:=0;
  SetLength(FCells,0);
end;

procedure TONURlistItem.Delete;
begin
 Finalize(FCells);
end;

function TONURlistItem.Arrayofstring(aranan: string): integer;
 var
 i:integer;
begin
  result:=-1;
  for i:=0 to Length(FCells)-1 do
  begin
    if FCells[i]=aranan then
    begin
    Result:=i;
    break;
    end;
  end;
end;





{ TONURlistItems }
{
procedure TBCGraphicControl.BeginUpdate;
begin
  FUpdateCount := FUpdateCount +1;
end;

procedure TBCGraphicControl.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    FUpdateCount := FUpdateCount -1;
    if FUpdateCount=0 then
      UpdateControl;
  end;
end;

procedure TBCGraphicControl.UpdateControl;
begin
  Invalidate;
end;
}
procedure TONURlistItems.BeginUpdate;
begin
 FUpdateCount := FUpdateCount +1;
end;

procedure TONURlistItems.EndUpdate;
begin
  if FUpdateCount > 0 then
    begin
      FUpdateCount := FUpdateCount -1;
      if FUpdateCount=0 then
       TONURColumList(GetOwner).Invalidate; // Update;
    end;
end;

procedure TONURlistItems.Update(Item: TCollectionItem);
begin
  Inherited Update(Item);

 //  TONURColumList(GetOwner).resizing;

 //  TONURColumList(GetOwner).Invalidate;
end;

function TONURlistItems.GetItem(Indexi: integer): TONURlistItem;
begin
  if Indexi <> -1 then
    Result := TOnURlistItem(inherited GetItem(Indexi));
end;

procedure TONURlistItems.SetItem(Indexi: integer; const Value: TONURlistItem);
begin
//  WriteLn(Indexi, '  ',Count);
  if indexi>Count-1 then Add;
  inherited SetItem(Indexi, Value);
  Changed;
end;

procedure TONURlistItems.Setcells(Acol, Arow: integer; Avalue: string);
var
  a:TONURlistItem;
begin
  if Acol>=TONURColumList(GetOwner).Columns.Count then
  TONURColumList(GetOwner).Columns.Add;

  if (Count > 0) and (Count > Arow) then
  begin
   a:=GetItem(Arow);
   a.SetCell(Acol,Avalue);
  end else
  begin
    a:=Add;
    a.SetCell(acol,Avalue);
  end;
end;

function TONURlistItems.Getcells(Acol, Arow: integer): string;
begin
  if Acol <> -1 then
   Result := GetItem(Arow).Cells[acol];
end;



constructor TONURlistItems.Create(AOwner: TPersistent;
  ItemClassi: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClassi);
  FUpdateCount:=0;
end;

function TONURlistItems.Add: TONURlistItem;
begin
  Result := TOnURlistItem(inherited Add);
  //SetLength(Result.flist,TONURColumList(GetOwner).Columns.Count);
end;

procedure TONURlistItems.Clear;
var
  i:integer;
begin

  for i:=self.Count-1 downto 0 do
    Delete(i);

  with TONURColumList(GetOwner) do
  begin
    FItemvOffset := 0;
    FFocusedItem := -1;
    Scrollscreen;
  end;
end;



procedure TONURlistItems.Delete(Indexi: integer);
Var
  Item : TCollectionItem;
begin
  Item:=TCollectionItem(Items[Indexi]);
  FPONotifyObservers(self,ooDeleteItem,Pointer(Item));
  Finalize(Items[Indexi].FCells);
  Item.Free;
  Changed;
end;

function TONURlistItems.Insert(Indexi: Integer; col: array of integer;
  avalue: array of string): TONURlistItem;
var
  i : integer;
begin
 Result:=Add;
 Result.Index:=Indexi;

 for i:=0 to Length(col)-1 do
  if avalue[i]<>'' then
  Result.Insert(i,avalue[i]);

 Changed;
end;

function TONURlistItems.IndexOf(Value: TONURlistItem): integer;
var
  i: integer;
begin
  Result := -1;
  i := 0;

  while (i < Count) and (Result = -1) do
    if Items[i] = Value then
      Result := i;
end;





{ TONURListBox }


constructor TONURListBox.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent                := TWinControl(Aowner);
  Width                 := 180;
  Height                := 200;
  TabStop               := True;
  //Fselectedcolor        := clblue;
  skinname              := 'listbox';
  findex                := -1;
  Flist                 := TStringList.Create;
  TStringList(Flist).OnChange := @LinesChanged;
  FItemsShown           := 0;
  FItemHOffset          := 0;
  Fitemvoffset          := 0;
  fmodusewhelll         := False;
  FitemHeight           := 24;
  fstate                := obsnormal;
  FBack                 := TBGRABitmap.Create(Self.ClientWidth,self.ClientHeight);
  FHBack                := TBGRABitmap.Create(Self.ClientWidth,self.ClientHeight);
  Captionvisible        := False;
  fchangelist           := False;
  fautohide             := false;
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

  factiveitems          := TONURCUSTOMCROP.Create('ACTIVEITEM');
  fitems                := TONURCUSTOMCROP.Create('ITEM');



  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FHTopleft);
  Customcroplist.Add(FHTop);
  Customcroplist.Add(FHTopRight);
  Customcroplist.Add(FHBottomleft);
  Customcroplist.Add(FHBottom);
  Customcroplist.Add(FHBottomRight);
  Customcroplist.Add(FHleft);
  Customcroplist.Add(FHRight);
  Customcroplist.Add(FHCenter);

  Customcroplist.Add(factiveitems);
  Customcroplist.Add(fitems);

  vScrollBar := TONURScrollBar.Create(self);
  with vScrollBar do
  begin
    Parent    := self;
    Visible   := False;
    Skinname  := 'scrollbarv';
    Skindata  := nil;//Self.Skindata;
    Width     := 25;
    left      := Self.ClientWidth - (25);// + Background.Border);
    Top       := 0;//Background.Border;
    Height    := Self.ClientHeight;// - (Background.Border * 2);
    Max       := 1;//Flist.Count;
    Min       := 0;
    OnChange  := @VScrollchange;
    Position  := 0;
  end;

  HScrollBar := TONURScrollBar.Create(self);
  with HScrollBar do
  begin
    Parent     := self;
    Visible    := False;
    Skinname   := 'scrollbarh';
    Skindata   := nil;
    Kind       := oHorizontal;
    Height     := 25;
    left       := 0;
    Top        := self.ClientHeight-25;
    Width      := self.ClientWidth;
    Max        := 1;
    Min        := 0;
    OnChange   := @HScrollchange;
    Position   := 0;
  end;

end;

destructor TONURListBox.Destroy;
begin
  Customcroplist.Clear;

  if Assigned(fback) then
    FreeAndNil(fback);

  if Assigned(vScrollBar) then
    FreeAndNil(vScrollBar);
  if Assigned(hScrollBar) then
    FreeAndNil(hScrollBar);
  FreeAndNil(Flist);

  inherited Destroy;
end;


procedure TONURListBox.LinesChanged(Sender: TObject);
begin
 //fchangelist:=false;
 //Scrollscreen;
 Invalidate;
end;

procedure TONURListBox.Scrollscreen;
var
  fark,z,p: Integer;
  FItemshShown,l:Integer;
begin
  if (csDesigning in ComponentState) then exit;
  fchangelist := true;
  if Flist.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;

    if Flist.Count - FItemsShown + 1 > 0 then
    begin
      with vScrollBar do
      begin
        if (Skindata = nil) then
          Skindata := Self.Skindata;

        Width       := 20;
        left        := self.FCenter.Targetrect.Width-self.FRight.Targetrect.Width;//Self.ClientWidth - (ClientWidth+self.FRight.Croprect.Width);
        Top         := self.ftop.Targetrect.Height;
        Height      := self.FCenter.Targetrect.Height;//Self.ClientHeight - (self.fTOP.Croprect.Height+self.fBOTTOM.Croprect.Height);
        Max         := Flist.Count - FItemsShown;
        Alpha       := self.Alpha;
        if Kind = oHorizontal then  Kind := oVertical;
      end;
    end;

    fark:=0;

    for z := 0 to Flist.Count - 1 do
    begin
      p := resim.TextSize(Flist[z]).cx;

      if p>=FCenter.Targetrect.Width-20{self.ClientWidth} then
      if fark<p then
      fark := p;
    end;

    self.resim.FontName   := self.Font.Name;
    self.resim.FontHeight := self.Font.Height;
    self.resim.FontStyle  := self.Font.Style;
    l                     := fark div self.resim.TextSize('A').cx;
    FItemshShown          := (self.FCenter.Targetrect.Width) div self.resim.TextSize('R').cx;


    with hScrollBar do
    begin
      if (Skindata = nil) then
        Skindata := Self.Skindata;

      if (Skindata <> nil) then
      begin
        if Kind <> oHorizontal then  Kind := oHorizontal;
        left                 := self.Fleft.Targetrect.Width;
        Width                := self.FCenter.Targetrect.Width;//self.ClientWidth-(self.Fleft.Croprect.Width+self.FRight.Croprect.Width);
        Height               := 20;
        Top                  := self.FCenter.Targetrect.Height;// self.ClientHeight-self.Ftop.Croprect.Height;
        Max                  := 0;
        if fark>0 then
        max:=(FItemshShown-l);
        Alpha := self.Alpha;
        if Max>0 then Visible := true else Visible := false;
      end;
    end;


  {   if FList.Count * FItemHeight > (FCenter.Targetrect.Height-HScrollBar.Height) then
        vScrollBar.Visible := True
       else
        vScrollBar.Visible := False;
        }

  end else
  begin
    vScrollBar.Visible := False;
    hScrollBar.Visible := False;
  end;
 hScrollBar.AutoHide:=fautohide;
 vScrollBar.AutoHide:=fautohide;

 // Invalidate;

end;


procedure TONURListBox.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  resizing;
end;

procedure TONURListBox.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) and (skindata<>nil) then
  resizing;
end;

procedure TONURListBox.resizing;
begin
  if (Skindata = nil) and (csDesigning in ComponentState) then exit;

 // WriteLn('Resizing Listbox');
  if Assigned(Skindata) then
  begin
   vScrollBar.Skindata:=Skindata;
   hScrollBar.Skindata:=Skindata;
  end;

  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Croprect.Width, 0, self.ClientWidth, FTopRight.Croprect.Height);
  FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0, self.ClientWidth - FTopRight.Croprect.Width,FTop.Croprect.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height, FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Croprect.Width, self.ClientHeight - FBottomRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width, self.ClientHeight - FBottom.Croprect.Height, self.ClientWidth -FBottomRight.Croprect.Width, self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,Fleft.Croprect.Width, self.ClientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect       := Rect(self.ClientWidth - FRight.Croprect.Width,FTopRight.Croprect.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect      := Rect(Fleft.Croprect.Width,FTop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight - FBottom.Croprect.Height);

  FBack.SetSize(0, 0);
  FBack.SetSize(self.ClientWidth, self.ClientHeight);

  //ORTA CENTER
   DrawPartnormal(FCenter.Croprect,FBack,Skindata.fimage, fcenter.Targetrect, alpha);

  //SOL ÜST TOPLEFT
  DrawPartnormal(FTopleft.Croprect, FBack,Skindata.fimage, FTopleft.Targetrect, alpha);
  //SAĞ ÜST TOPRIGHT
  DrawPartnormal(FTopRight.Croprect, FBack,Skindata.fimage, FTopRight.Targetrect, alpha);
  //UST TOP
  DrawPartnormal(FTop.Croprect, FBack,Skindata.fimage,FTop.Targetrect, alpha);
  // SOL ALT BOTTOMLEFT
  DrawPartnormal(FBottomleft.Croprect, FBack,Skindata.fimage,FBottomleft.Targetrect, alpha);
  //SAĞ ALT BOTTOMRIGHT
  DrawPartnormal(FBottomRight.Croprect, FBack,Skindata.fimage, FBottomRight.Targetrect, alpha);
  //ALT BOTTOM
  DrawPartnormal(FBottom.Croprect, FBack,Skindata.fimage, FBottom.Targetrect, alpha);
  // SOL ORTA CENTERLEFT
  DrawPartnormal(Fleft.Croprect, FBack,Skindata.fimage, Fleft.Targetrect, alpha);
  // SAĞ ORTA CENTERRIGHT
  DrawPartnormal(FRight.Croprect, FBack,Skindata.fimage, FRight.Targetrect, alpha);




  FHTopleft.Targetrect     := Rect(0, 0, FHTopleft.Croprect.Width, FHTopleft.Croprect.Height);
  FHTopRight.Targetrect    := Rect(self.ClientWidth - (FHTopRight.Croprect.Width), 0, self.ClientWidth, (FHTopRight.Croprect.Height));
  FHTop.Targetrect         := Rect((FHTopleft.Croprect.Width), 0, self.ClientWidth - (FHTopRight.Croprect.Width),(FHTop.Croprect.Height));
  FHBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FHBottomleft.Croprect.Height), (FHBottomleft.Croprect.Width), self.ClientHeight);
  FHBottomRight.Targetrect := Rect(self.ClientWidth - (FHBottomRight.Croprect.Width), self.ClientHeight - (FHBottomRight.Croprect.Height), self.ClientWidth, self.ClientHeight);
  FHBottom.Targetrect      := Rect((FHBottomleft.Croprect.Width), self.ClientHeight - (FHBottom.Croprect.Height), self.ClientWidth -(FHBottomRight.Croprect.Width), self.ClientHeight);
  FHleft.Targetrect        := Rect(0, FHTopleft.Croprect.Height,(FHleft.Croprect.Width), self.ClientHeight - (FHBottomleft.Croprect.Height));
  FHRight.Targetrect       := Rect(self.ClientWidth - (FHRight.Croprect.Width),(FHTopRight.Croprect.Height), self.ClientWidth, self.ClientHeight - (FHBottomRight.Croprect.Height));
  FHCenter.Targetrect      := Rect(FHleft.Croprect.Width,FHTop.Croprect.Height, self.ClientWidth - FHRight.Croprect.Width, self.ClientHeight - FHBottom.Croprect.Height);



  FHBack.SetSize(0, 0);
  FHBack.SetSize(self.ClientWidth, self.ClientHeight);
  FHBack.Fill(BGRAPixelTransparent);

  //ORTA CENTER
   DrawPartnormal(FHCenter.Croprect,FHBack,Skindata.fimage, fHcenter.Targetrect, alpha);
  //SOL ÜST TOPLEFT
  DrawPartnormal(FHTopleft.Croprect, FHBack,Skindata.fimage, FHTopleft.Targetrect, alpha);
  //SAĞ ÜST TOPRIGHT
  DrawPartnormal(FHTopRight.Croprect, FHBack,Skindata.fimage, FHTopRight.Targetrect, alpha);
  //UST TOP
  DrawPartnormal(FHTop.Croprect, FHBack,Skindata.fimage,FHTop.Targetrect, alpha);
  // SOL ALT BOTTOMLEFT
  DrawPartnormal(FHBottomleft.Croprect, FHBack,Skindata.fimage,FHBottomleft.Targetrect, alpha);
  //SAĞ ALT BOTTOMRIGHT
  DrawPartnormal(FHBottomRight.Croprect, FHBack,Skindata.fimage, FHBottomRight.Targetrect, alpha);
  //ALT BOTTOM
  DrawPartnormal(FHBottom.Croprect, FHBack,Skindata.fimage, FHBottom.Targetrect, alpha);
  // SOL ORTA CENTERLEFT
  DrawPartnormal(FHleft.Croprect, FHBack,Skindata.fimage, FHleft.Targetrect, alpha);
  // SAĞ ORTA CENTERRIGHT
  DrawPartnormal(FHRight.Croprect, FHBack,Skindata.fimage, FHRight.Targetrect, alpha);



  if Flist.Count>0 then
  Scrollscreen;
end;

procedure TONURListBox.paint;
var
  a, b, i,maxlenghtt,l: integer;
   Target: Trect;
   tmp:TBGRABitmap;
   Txt:string;
begin
  if not Visible then Exit;


  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  tmp:=TBGRABitmap.Create(self.ClientWidth, self.ClientHeight);


  Scrollscreen;
  if vScrollBar.Max>0 then vScrollBar.Visible:=true;
  if hScrollBar.Max>0 then hScrollBar.Visible:=true;

  if Flist.Count > 0 then
  begin
    tmp.FontName   := self.font.Name;
    tmp.FontHeight := self.Font.Height;
    tmp.FontStyle  := self.Font.Style;
    maxlenghtt     := (FCenter.Targetrect.Width+20) div tmp.TextSize('A').cx;

    a := Fleft.Croprect.Width;
    b := FTop.Croprect.Height;





    if hScrollBar.Visible then
      l:=HScrollBar.Height
    else
     l:=0;

    for i := FItemvOffset to  (FItemvOffset + FCenter.Targetrect.Height-l div FItemHeight) - 1 do
    begin
      if i>FList.Count then break;

      if (i < Flist.Count) and (i > -1)  then
      begin
       Target := Rect(a, b, FCenter.Targetrect.Width{self.ClientWidth - FRight.Croprect.Width}, b + FitemHeight);

        if (vScrollBar.Visible) then
          Target.Right := Target.Right-vScrollBar.ClientWidth; //self.ClientWidth - (vScrollBar.ClientWidth{+FRight.Croprect.Width});

        txt:=Copy(Flist[i],hScrollBar.Position,maxlenghtt);


        if i = findex then
          DrawPartnormaltext(self,factiveitems.Croprect, tmp, Target, alpha,txt,taLeftJustify,ColorToBGRA(factiveitems.Fontcolor, alpha))
        else
          DrawPartnormaltext(self,fitems.Croprect, tmp, Target, alpha,txt,taLeftJustify,ColorToBGRA(fitems.Fontcolor, alpha));

      end;
      b := b + FitemHeight;
      if (b >= FCenter.Targetrect.Height) then Break;

    end;

  end;


  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    if fstate=obshover then
     resim.PutImage(0,0,fhback,dmset)
    else
     resim.PutImage(0,0,fback,dmset);

    resim.PutImage(0,0,tmp,dmDrawWithTransparency);

  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    FCenter.Targetrect.Height := self.ClientHeight;
  end;
  tmp.Free;
  inherited paint;
end;

function TONURListBox.ItemRect(Item: integer): TRect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  r.Top :=Ftop.Croprect.Height;

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top    := r.top + (Item - FItemvOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left   := fleft.Croprect.Width;

    if Assigned(vScrollBar) and (vScrollBar.Visible) then
      r.Right := vScrollBar.Left
    else
      r.Right := FCenter.Targetrect.Width - (Fleft.Croprect.Width);

    if Assigned(hScrollBar) and (hScrollBar.Visible) then
      r.Bottom := hScrollBar.Top
    else
      r.Bottom := FCenter.Targetrect.Height - FBottom.Croprect.Height;
  end;

  Result := r;
end;



function TONURListBox.GetItemAt(Pos: TPoint): integer;
var
  w: Integer;
begin
  Result := -1;
  w := FTop.Croprect.Height;
  if Pos.Y >= 0 then
  begin
    Result := FItemvOffset + ((Pos.Y - w) div FItemHeight);
    if (Result > Items.Count - 1) or (Result > (FItemvOffset + FItemsShown) - 1) then
      Result := -1;
  end;
end;

function TONURListBox.getitemheight: integer;
begin
  Result := FitemHeight;
end;

procedure TONURListBox.setitemheight(avalue: integer);
begin
  if avalue <> FitemHeight then FitemHeight := avalue;
end;





procedure TONURListBox.MoveDown;
begin
  if flist.Count > 0 then
  begin
    if (findex > (FItemvOffset + FItemsShown)) or (findex < (FItemvOffset)) then
    begin
      findex := FItemvOffset;
    end
    else if (findex >= 0) and (findex < Flist.Count - 1) then
    begin
      Inc(findex);
      if (findex - FItemvOffset) > FItemsShown - 1 then
        Inc(FItemvOffset);
    end;

  end;
end;

procedure TONURListBox.MoveEnd;
begin
  if flist.Count > 0 then
  begin
    findex := Flist.Count - 1;
    if (Flist.Count - FItemsShown) >= 0 then
      FItemvOffset := Flist.Count - FItemsShown
    else
      FItemvOffset := 0;
  end;

end;

procedure TONURListBox.MoveHome;
begin
  if flist.Count > 0 then
  begin
    findex := 0;
    FItemvOffset := 0;
  end;

end;

procedure TONURListBox.MoveUp;

begin
  if flist.Count > 0 then
  begin
    //      Shift := GetKeyState(VK_SHIFT) < 0;

    if (findex > (FItemvOffset + FItemsShown)) or (findex < (FItemvOffset)) then
    begin
      findex := FItemvOffset;
    end
    else if (findex > 0) and (findex < Flist.Count) then
    begin
      // SCROLL?????
      if ((findex - FItemvOffset) = 0) and (FItemvOffset > 0) then
        Dec(FItemvOffset);

      Dec(findex);

    end;

  end;

end;



function TONURListBox.GetItemIndex: integer;
begin
  Result := findex;
end;

procedure TONURListBox.SetItemIndex(Avalue: integer);
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

    if (aValue < FItemvOffset) then
      FItemvOffset := aValue
    else if aValue > (FItemvOffset + (Shown - 1)) then
      FItemvOffset := ValueRange(aValue - (Shown - 1), 0, Flist.Count - Shown);
  end
  else
  begin
    findex := -1;
  end;
  Invalidate;
end;

procedure TONURListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
var
  ClickedItem: integer;
begin
  if button = mbLeft then
  begin
    ClickedItem := GetItemAt(Point(X, Y));

    if ClickedItem > -1 then
    begin
     findex := ClickedItem;
     Invalidate;
    end;
  end;
  SetFocus;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TONURListBox.MouseEnter;
begin
  inherited MouseEnter;
  if fstate=obshover then exit;
  fstate:=obshover;
  Invalidate;
end;

procedure TONURListBox.MouseLeave;
begin
  inherited MouseLeave;
  if fstate<>obsnormal then
  begin
    fstate:=obsnormal;
    Invalidate;
  end;
end;


function TONURListBox.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  fmodusewhelll := True;
  inherited;
  if not VScrollBar.Visible then exit;
  if FItemVOffset =VScrollBar.max then exit;

  VScrollBar.Position := VScrollBar.Position + Mouse.WheelScrollLines;
  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;

function TONURListBox.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): boolean;
begin
  inherited;
  fmodusewhelll := True;
  if not VScrollBar.Visible then exit;
  if FItemVOffset =0 then exit;
  VScrollBar.Position := VScrollBar.Position - Mouse.WheelScrollLines;
  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;


procedure TONURListBox.VScrollchange(Sender: TObject);
begin
  if fmodusewhelll = False then
  begin
     FItemvOffset := VScrollBar.Position;

     Invalidate;
  end;
end;

procedure TONURListBox.HScrollchange(Sender: TObject);
begin
  if fmodusewhelll = False then
  begin
  //  FItemhOffset := -HScrollBar.Position;

    Invalidate;
  end;
end;



procedure TONURListBox.dblclick;
var
  pt: TPoint;
  i: integer;
begin

  if Items.Count > 0 then
  begin
    GetCursorPos(pt);
    i := GetItemAt(ScreenToClient(pt));
    if i > -1 then
    begin
      findex := i;
      Invalidate;
      //        if Assigned(FItemDblClick) then FItemDblClick(Self);
    end;
  end;
  inherited dblclick;
end;



procedure TONURListBox.KeyDown(var Key: word; Shift: TShiftState);
var
  x: integer;
begin

  case key of
    VK_RETURN: if (Flist.Count > 0) and (findex > -1) then
      begin

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
        x := FItemvOffset - FItemsShown;
        if x < 0 then x := 0;
        FItemvOffset := x;
        findex := x;
        Invalidate;
      end;
    VK_NEXT: if Flist.Count > 0 then
      begin
        x := FItemvOffset + FItemsShown;
        if x >= flist.Count then x := Flist.Count - 1;
        if Flist.Count <= FItemsShown then
          FItemvOffset := 0
        else if x > (Flist.Count - FItemsShown) then
          FItemvOffset := Flist.Count - FItemsShown
        else
          FItemvOffset := x;

        findex := x;
        Invalidate;
      end;
    else
  end;
  inherited;
end;

procedure TONURListBox.SetString(AValue: TStrings);
begin
  if Flist = AValue then Exit;
  Flist.Assign(AValue);
end;


procedure TONURListBox.BeginUpdate;
begin
  flist.BeginUpdate;
  fchangelist:=true;
end;

procedure TONURListBox.EndUpdate;
begin
  fchangelist:=false;
  Flist.EndUpdate;
end;

procedure TONURListBox.Clear;
begin
  Flist.Clear;
end;



{ Tpopupformcombobox }

procedure ShowCombolistPopup(const APosition: TPoint;
  const OnReturnDate: TReturnStintEvent; const OnShowHide: TNotifyEvent;
  ACaller: TONURComboBox);
var
  PopupForm: Tpopupformcombobox;
  b: integer;
begin
  b := ACaller.Height;
  b := b + (ACaller.Height *5);// ACaller.Items.Count);
  PopupForm := Tpopupformcombobox.Create(Application);//Create(Application);
  PopupForm.SetBounds(APosition.x, APosition.y, ACaller.Width, b);
  PopupForm.BorderStyle := bsNone;
  PopupForm.FCaller := ACaller;
  PopupForm.FOnReturnDate := OnReturnDate;
  PopupForm.OnShow := OnShowHide;
  PopupForm.OnHide := OnShowHide;
  PopupForm.Show;
  PopupForm.KeepInView(APosition);
  // must be after Show for PopupForm.AutoSize to be in effect.

  PopupForm.oblist.Font := ACaller.Font;

  PopupForm.oblist.items.Assign(ACaller.items);// := ACaller.items;
  PopupForm.oblist.Alpha := ACaller.Alpha;
  PopupForm.oblist.Skindata := ACaller.Skindata;

end;

procedure tpopupformcombobox.listboxdblclick(Sender: TObject);
begin
  if TONURListBox(Sender).items.Count > 0 then
    ReturnstringAnditemindex;
end;

procedure tpopupformcombobox.formdeactivate(Sender: TObject);
begin
  Hide;
  if (not FClosed) then
    Close;
end;

constructor tpopupformcombobox.Create(theowner: TComponent);
begin
  inherited CreateNew(theowner);

  BorderStyle    := bsNone;
  FClosed        := False;
  Application.AddOnDeactivateHandler(@FormDeactivate);
  oblist         := TONURListBox.Create(nil);
  oblist.Parent  := self;
  oblist.Align   := alClient;
  oblist.OnClick := @listboxDblClick;

end;

procedure tpopupformcombobox.cmdeactivate(var message: tlmessage);
begin
  FormDeactivate(self);
end;

procedure tpopupformcombobox.doclose(var closeaction: tcloseaction);
begin

  FClosed := True;
  Application.RemoveOnDeactivateHandler(@FormDeactivate);
  CloseAction := caFree;

  inherited DoClose(CloseAction);
end;

procedure tpopupformcombobox.doshow;
begin
  inherited doshow;
end;

procedure tpopupformcombobox.keepinview(const popuporigin: tpoint);
var
  ABounds: TRect;
begin
  ABounds := Screen.MonitorFromPoint(PopupOrigin).WorkAreaRect; // take care of taskbar
  if PopupOrigin.X + clientWidth > ABounds.Right then
    Left := ABounds.Right - clientWidth
  else if PopupOrigin.X < ABounds.Left then
    Left := ABounds.Left
  else
    Left := PopupOrigin.X;
  if PopupOrigin.Y + clientHeight > ABounds.Bottom then
  begin
    if Assigned(FCaller) then
      Top := PopupOrigin.Y - FCaller.clientHeight - clientHeight
    else
      Top := ABounds.Bottom - clientHeight;
  end
  else if PopupOrigin.Y < ABounds.Top then
    Top := ABounds.Top
  else
    Top := PopupOrigin.Y;
  if Left < ABounds.Left then Left := 0;
  if Top < ABounds.Top then Top := 0;

end;

procedure tpopupformcombobox.returnstringanditemindex;
begin
  if oblist.ItemIndex = -1 then exit;
  if Assigned(FOnReturnDate) then
    FOnReturnDate(Self, oblist.items[oblist.ItemIndex], oblist.ItemIndex);
  if not FClosed then
    Close;

end;



{ TONURComboBox }




function TONURComboBox.Gettext: string;
begin
  if Fitemindex > -1 then
    Result := Fliste[Fitemindex]
  else
    Result := '';
end;

function TONURComboBox.GetItemIndex: integer;
begin
  Result := Fitemindex;
end;

procedure TONURComboBox.LinesChanged(Sender: TObject);
begin

end;

procedure TONURComboBox.setitemheight(avalue: integer);
begin
if FitemHeight=avalue then exit;
FitemHeight:=avalue;
Invalidate;
end;

procedure TONURComboBox.SetItemIndex(Avalue: integer);
var
  Shown: integer;
begin
  if Fliste.Count = 0  then exit;
  if Fitemindex = aValue then Exit;
  if Fitemindex = -1 then Exit;

  Shown := clientHeight div FItemHeight;

  if (Fliste.Count > 0) and (aValue >= -1) and (aValue <= Fliste.Count) then
  begin
    Fitemindex := aValue;

    if (aValue < FItemOffset) then
      FItemOffset := aValue
    else if aValue > (FItemOffset + (Shown - 1)) then
      FItemOffset := ValueRange(aValue - (Shown - 1), 0, Fliste.Count - Shown);
    Text:=Fliste[Fitemindex];
  end
  else
  begin
    Fitemindex := -1;
  end;
  Invalidate;
end;




procedure TONURComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if (PtInRect(fbutonarea, point(x, y))) then
    begin
      Fstate := obspressed;
      kclick(self);
    end
    else
    begin
      Fstate := obsnormal;
      kclick(self);
    end;
  end;

  Invalidate;
end;

procedure TONURComboBox.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited mousemove(shift, x, y);
  if csDesigning in ComponentState then  Exit;
  if (PtInRect(fbutonarea, point(X, Y))) then
  begin
    Cursor := crDefault;
    Fstate := obshover;
  end
  else
  begin
    Cursor := crIBeam;
    Fstate := obsnormal;
  end;

  Invalidate;
end;

procedure TONURComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited mouseup(button, shift, x, y);
  if Button = mbLeft then
  begin
    Fstate := obsnormal;
    Invalidate;
  end;
end;

procedure TONURComboBox.CMonmouseenter(var Messages: Tmessage);
var
  aPnt: TPoint;
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
    Cursor := crDefault;
    Fstate := obshover;
  end
  else
  begin
    Cursor := criBeam;
    Fstate := obsnormal;

  end;
  Invalidate;
end;

procedure TONURComboBox.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;






procedure TONURComboBox.LstPopupReturndata(Sender: TObject; const Str: string;
  const indx: integer);
var
  i: integer;
begin
  try
    self.Text := maxlengthstring(str, (self.clientWidth div self.canvas.TextWidth('Ç')));
    i := Fitemindex;
    Fitemindex := indx;
    if (indx <> i) and (indx<>-1) then
      Change;

    Invalidate;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TONURComboBox.LstPopupShowHide(Sender: TObject);
begin
  fdropdown := (Sender as Tpopupformcombobox).Visible;
  Invalidate;
end;

procedure TONURComboBox.BeginUpdate;
begin
  Fliste.BeginUpdate;
end;

procedure TONURComboBox.Clear;
begin
  Fliste.Clear;
end;

procedure TONURComboBox.EndUpdate;
begin
  Fliste.EndUpdate;
end;

procedure TONURComboBox.Change;
begin
  inherited Changed;
  if Assigned(OnChange) then OnChange(Self);
end;

procedure TONURComboBox.kclick(Sender: TObject);
var
  aa: Tpoint;
begin
  if Fliste.Count =0 then  exit;

  if fpopupopen = False then
  begin
    aa := ControlToScreen(Point(0, self.ClientHeight));
    ShowCombolistPopup(aa, @LstPopupReturndata, @LstPopupShowHide, self);

    //   if Assigned(FOnChange) then FOnChange(self);
    fpopupopen := True;
  end
  else
  begin
    fpopupopen := False;
  end;

end;


procedure TONURComboBox.Select;
begin
  if Assigned(FOnSelect) and (ItemIndex >= 0) then FOnSelect(Self);
  if Assigned(OnChange) and (ItemIndex >= 0) then OnChange(self);
end;

procedure TONURComboBox.DropDown;
begin
  if Assigned(FOnDropDown) then FOnDropDown(Self);
end;

procedure TONURComboBox.GetItems;
begin
  if Assigned(FOnGetItems) then FOnGetItems(Self);
end;

procedure TONURComboBox.CloseUp;
begin
  if [csLoading, csDestroying, csDesigning] * ComponentState <> [] then exit;
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TONURComboBox.SetStrings(AValue: TStrings);
begin
  if Fliste = AValue then Exit;
  Fliste.Assign(AValue);
end;



constructor TONURComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  Width := 150;
  Height := 30;
  Fselectedcolor := clblue;
  Fitemindex := -1;
  Fliste := TStringList.Create;
  TStringList(Fliste).OnChange := @LinesChanged;
  skinname := 'combobox';
  fpopupopen := False;




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




  Fstate := obsnormal;
  fbutonarea := Rect(Self.Width - self.Height, 0, self.Width, self.Height);

end;

destructor TONURComboBox.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

  if Assigned(Fliste) then FreeAndNil(Fliste);

  inherited Destroy;

end;


procedure TONURComboBox.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  resizing;
end;

procedure TONURComboBox.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;
procedure TONURComboBox.Resizing;
begin
  fbutonarea              := Rect(Self.ClientWidth - self.ClientHeight, 0, self.ClientWidth, self.ClientHeight);
  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect    := Rect(Self.ClientWidth - (FTopRight.Croprect.Width + fbutonarea.Width), 0, Self.ClientWidth - (fbutonarea.Width), FTopRight.Croprect.Height);//(FTopRight.FSBottom - FTopRight.FSTop));
  FTop.Targetrect         := Rect(FTopleft.Croprect.Width, 0, self.ClientWidth - (FTopRight.Croprect.Width+ fbutonarea.Width),Ftop.Croprect.Height);//(FTop.FSBottom - FTop.FSTop));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,FBottomleft.Croprect.Width {(FBottomleft.FSRight - FBottomleft.FSLeft)}, self.ClientHeight);
  FBottomRight.Targetrect := Rect(Self.ClientWidth - (FBottomRight.Croprect.Width+ fbutonarea.Width), self.ClientHeight - FBottomRight.Croprect.Height{(FBottomRight.FSBottom - FBottomRight.FSTop)}, Self.ClientWidth - (fbutonarea.Width), self.ClientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Croprect.Width{(FBottomleft.FSRight - FBottomleft.FSLeft)}, self.ClientHeight -FBottom.Croprect.Height {(FBottom.FSBottom - FBottom.FSTop)}, Self.ClientWidth -(FBottomRight.Croprect.Width{(FBottomRight.FSRight - FBottomRight.FSLeft)} + fbutonarea.Width), self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height{FTopleft.FSBottom - FTopleft.FSTop},Fleft.Croprect.Width{(Fleft.FSRight - Fleft.FSLeft)}, self.ClientHeight - FBottomleft.Croprect.Height{(FBottomleft.FSBottom - FBottomleft.FSTop)});
  FRight.Targetrect       := Rect(Self.ClientWidth - (FRight.Croprect.Width{(FRight.FSRight - FRight.FSLeft)} + fbutonarea.Width),FTopRight.Croprect.Height{(FTopRight.FSBottom - FTopRight.FSTop)}, Self.ClientWidth - fbutonarea.Width, self.ClientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect      := Rect(Fleft.Croprect.Width,FTop.Croprect.Height, Self.ClientWidth - (FRight.Croprect.Width + fbutonarea.Width), self.ClientHeight - FBottom.Croprect.Height);

end;

procedure TONURComboBox.Paint;
var
  TrgtRect: TRect;
begin

  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    //TOPLEFT   //SOLÜST
    DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
    //TOP  //ÜST
    DrawPartnormal(FTop.Croprect, self, FTop.Targetrect, alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
    //BOTTOM  //ALT
    DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
    //LEFT // SOL
    DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
    // RIGHT // SAĞ
    DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
    //CENTER //ORTA
    DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);


    if Enabled = False then
    begin
      TrgtRect := Fdisable.Croprect;
    end
    else
    begin
      case Fstate of
        obsnormal : TrgtRect := FNormal.Croprect;
        obshover  : TrgtRect := FEnter.Croprect;
        obspressed: TrgtRect := FPress.Croprect;
      end;

      DrawPartnormal(TrgtRect, self, fbutonarea, alpha);

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited paint;
end;


{ TCustomCheckListBox }

constructor TOnurCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent          := TWinControl(Aowner);
  Width           := 180;
  Height          := 250;
  TabStop         := True;
  Fselectedcolor  := clblue;
  skinname       := 'listbox';
  findex          := -1;
  Flist           := TStringList.Create;
  TStringList(Flist).OnChange := @LinesChanged;
  FItemsShown     := 0;
  FItemHOffset    := 0;
  Fitemvoffset    := 0;
  fmodusewhelll   := False;
  FitemHeight     := 24;
  SetLength(FChecked, 0);


  vScrollBar := TonURScrollBar.Create(self);
  with vScrollBar do
  begin
    Parent    := self;
    Visible   := False;
    Skinname  := 'scrollbarv';
    Skindata  := nil;
    Width     := 25;
    left      := Self.ClientWidth - (25);
    Top       := 0;
    Height    := Self.ClientHeight;
    Max       := 1;
    Min       := 0;
    OnChange  := @VScrollchange;
    Position  := 0;

  end;

  HScrollBar := TonURScrollBar.Create(self);
  with HScrollBar do
  begin
    Parent     := self;
    Visible    := False;
    Skinname   := 'scrollbarh';
    Skindata   := nil;
    Kind       := oHorizontal;
    Height     := 25;
    left       := 0;
    Top        := self.ClientHeight-25;
    Width      := self.ClientWidth;
    Max        := 1;
    Min        := 0;
    OnChange   := @HScrollchange;
    Position   := 0;
  end;
  FTop                  := TONURCUSTOMCROP.Create('TOP');
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  factiveitems          := TONURCUSTOMCROP.Create('ACTIVEITEM');
  fitems                := TONURCUSTOMCROP.Create('ITEM');
  fcheckedc             := TONURCUSTOMCROP.Create('CHECKED');
  funcheckedc           := TONURCUSTOMCROP.Create('UNCHECKED');

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(factiveitems);
  Customcroplist.Add(fitems);

  Customcroplist.Add(fcheckedc);
  Customcroplist.Add(funcheckedc);


  Captionvisible := False;
  fchangelist := true;
end;

destructor TOnurCheckListBox.Destroy;
var
  i:byte;
begin
  Customcroplist.Clear;

  if Assigned(vScrollBar) then
    FreeAndNil(vScrollBar);
  if Assigned(hScrollBar) then
    FreeAndNil(hScrollBar);

  FreeAndNil(Flist);

  inherited Destroy;
end;



procedure TOnurCheckListBox.SetChecked(const Index:Integer;const Value:boolean);
begin
  if (Index >= 0) and (Index <  Length(FChecked)) then
  begin
    FChecked[Index] := Value;
    Invalidate;
  end;
end;

function TOnurCheckListBox.GetChecked(Index:Integer):boolean;
begin
 if (Index >= 0) and (Index < Length(FChecked)) then
    Result := FChecked[Index]
  else
    Result := False;
end;



procedure TOnurCheckListBox.Paint;
var
  a, b, i: integer;
  Target,RE: TRect;
  partial: TBGRACustomBitmap;
begin

if not Visible then Exit;

  if fchangelist=true then   // if items add or delete then calc to scrollbar
   Scrollscreen;

   fchangelist:=false;    // scrolbar refrsh false


  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then

   //ORTA CENTER
   DrawPartnormal(FCenter.Croprect, self, fcenter.Targetrect, alpha);


  // Her öğe için çizim işlemleri
 { for i := 0 to FList.Count - 1 do
  begin
    Re := Rect(0, i * FItemHeight, Width, (i + 1) * FItemHeight);
    //Rect := Rect(0, i * FItemHeight, Width, (i + 1) * FItemHeight);
    DrawItem(i, Re);
  end; }

  if Flist.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;

    a := Fleft.Croprect.Width;
    b := FTop.Croprect.Height;
    resim.FontName   := self.font.Name;
    resim.FontHeight := self.Font.Height;
    resim.FontStyle  := self.Font.Style;

   if hScrollBar.Visible then
      for i := FItemvOffset to  (FItemvOffset + (FCenter.Targetrect.Height-HScrollBar.Height) div FItemHeight) - 1 do
   else
      for i := FItemvOffset to  (FItemvOffset + (FCenter.Targetrect.Height) div FItemHeight) - 1 do

      begin
        if i>FList.Count then break;

        if (i < Flist.Count) and (i > -1)  then
        begin
         Target := Rect(a+25, b, self.ClientWidth - a, b + FitemHeight);

          if (vScrollBar.Visible) then
            Target.Right := self.ClientWidth - (vScrollBar.ClientWidth);// + FRight.Width);

         // Target.Left:=Target.Left+20;
          if i = findex then
            DrawPartnormaltext(factiveitems.Croprect, self, Target, alpha,FList[i],taLeftJustify,ColorToBGRA(factiveitems.Fontcolor{ColorToBGRA(Fselectedcolor}, alpha))
          else
             DrawPartnormaltext(fitems.Croprect, self, Target, alpha,FList[i],taLeftJustify,ColorToBGRA(fitems.Fontcolor{self.Font.Color}, alpha));

          RE:=Rect(a+5,b+5,a+15,b + FitemHeight-5);

          if Checked[i] then
           partial := Skindata.Fimage.GetPart(fcheckedc.Croprect)
          else
           partial := Skindata.Fimage.GetPart(funcheckedc.Croprect);

          resim.StretchPutImage(RE, partial, dmDrawWithTransparency, alpha);

          FreeAndNil(partial);

        end;
        b := b + FitemHeight;
        if (b >= FCenter.Targetrect.Height) then Break;

      end;

  end;
//  if (Skindata <> nil) then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    //SOL ÜST TOPLEFT
    DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
    //SAĞ ÜST TOPRIGHT
    DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
    //UST TOP
    DrawPartnormal(FTop.Croprect, self, FTop.Targetrect, alpha);
    // SOL ALT BOTTOMLEFT
    DrawPartnormal(FBottomleft.Croprect, self,FBottomleft.Targetrect, alpha);
    //SAĞ ALT BOTTOMRIGHT
    DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
    //ALT BOTTOM
    DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
    // SOL ORTA CENTERLEFT
    DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
    // SAĞ ORTA CENTERRIGHT
    DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);

  //  if Crop then
  //    CropToimg(resim);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    FCenter.Targetrect.Height := self.ClientHeight;
  end;
  inherited paint;
end;

procedure TOnurCheckListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickedItem: integer;
begin
  if button = mbLeft then
  begin
    ClickedItem := GetItemAt(Point(X, Y));
    if ClickedItem > -1 then
    begin
     findex := ClickedItem;
     if X<25 then
     begin
   //  SetChecked(findex,not GetChecked(findex));
      Checked[findex] := not Checked[findex];
    //  ShowMessage(BoolToStr(Checked[findex]));
     end;
     if Assigned(FOnItemClick) then
     FOnItemClick(Self);
    end;
  end;

  SetFocus;
  Invalidate;

  inherited MouseDown(Button, Shift, X, Y);

end;

procedure TOnurCheckListBox.Clear;
begin
  FList.Clear;
  SetLength(FChecked, 0);
  Invalidate;
end;


function TOnurCheckListBox.GetItemAt(Pos:TPoint):integer;
var
  w: Integer;
begin
  Result := -1;
  w := FTop.Croprect.Height;
  if Pos.Y >= 0 then
  begin
    Result := FItemvOffset + ((Pos.Y - w) div FItemHeight);
    if (Result > Items.Count - 1) or (Result > (FItemvOffset + FItemsShown) - 1) then
      Result := -1;
  end;
end;

function TOnurCheckListBox.getitemheight:integer;
begin
 Result := FitemHeight;
end;

function TOnurCheckListBox.GetItemIndex:integer;
begin
  Result := findex;
end;

function TOnurCheckListBox.ItemRect(Item:integer):TRect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  r.Top :=Ftop.Croprect.Height;

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top    := r.top + (Item - FItemvOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left   := fleft.Croprect.Width;

    if Assigned(vScrollBar) and (vScrollBar.Visible) then
      r.Right := vScrollBar.Left
    else
      r.Right := FCenter.Targetrect.Width - (Fleft.Croprect.Width);

    if Assigned(hScrollBar) and (hScrollBar.Visible) then
      r.Bottom := hScrollBar.Top
    else
      r.Bottom := FCenter.Targetrect.Height - FBottom.Croprect.Height;//(FBottom.FSBottom - FBottom.FSTop);
  end;

  Result := r;
end;

procedure TOnurCheckListBox.LinesChanged(Sender:TObject);
begin
 fchangelist:=true;
 SetLength(FChecked, FList.Count);
 Invalidate;
end;

procedure TOnurCheckListBox.Scrollscreen;
var
  fark,z,p: Integer;
begin
  if (csDesigning in ComponentState) then exit;

  if Flist.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;

    if Flist.Count - FItemsShown + 1 > 0 then
    begin
      with vScrollBar do
      begin
        if (Skindata = nil) then
          Skindata := Self.Skindata;

        Width   := 20;//TONURCustomCrop(Customcroplist[0]).Width;//ONORMAL.Width;
        left    := Self.ClientWidth - ClientWidth;
        Top     := self.ftop.Croprect.Height;
        Height  := Self.ClientHeight - (self.fTOP.Croprect.Height+self.fBOTTOM.Croprect.Height);
        Max     := Flist.Count - FItemsShown;
        Alpha   := self.Alpha;
        if Kind = oHorizontal then  Kind := oVertical;
      end;


      fark:=0;



      for z := 0 to Flist.Count - 1 do
      begin
        p := resim.TextSize(Flist[z]).cx;
        if fark>p then
        fark := p; //:= fark+Fcolumns[z].Width;
      end;



      if fark>0 then
      with hScrollBar do
      begin
        if (Skindata = nil) then
          Skindata := Self.Skindata;

        if (Skindata <> nil) then
        begin
          if Kind <> oHorizontal then  Kind := oHorizontal;
          left   := self.Fleft.Croprect.Width;//(self.ONleft.Right - self.ONleft.Left);
          Width  := self.ClientWidth-(Left+self.FRight.Croprect.Width);//(self.ONRIGHT.Right - self.ONRIGHT.Left));

          Height := self.FTop.Croprect.Height+20;//(TONURCustomCrop(Customcroplist[0]).Height);//ONORMAL.Height;//self.FTop.Height+self.FBottom.Height;// (self.ONTOP.Bottom - self.ONTOP.Top);
          Top    := self.ClientHeight-Height;//(self.ONTOP.Bottom - self.ONTOP.Top);

          if fark>0 then
          Max :=(fark div ClientWidth)+1;//((fark-self.ClientWidth) div Fcolumns.Count);
          Alpha := self.Alpha;

        end;

         if fark> self.ClientWidth then
          Visible := True
         else
          Visible := False;
      end;
    end;

     if FList.Count * FItemHeight > (FCenter.Targetrect.Height-HScrollBar.Height) then
        vScrollBar.Visible := True
       else
        vScrollBar.Visible := False;

  end else
  begin
    vScrollBar.Visible := False;
    hScrollBar.Visible := False;
  end;


end;

procedure TOnurCheckListBox.setitemheight(avalue:integer);
begin
  if avalue <> FitemHeight then FitemHeight := avalue;
end;

procedure TOnurCheckListBox.SetItemIndex(Avalue:integer);
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

    if (aValue < FItemvOffset) then
      FItemvOffset := aValue
    else if aValue > (FItemvOffset + (Shown - 1)) then
      FItemvOffset := ValueRange(aValue - (Shown - 1), 0, Flist.Count - Shown);
  end
  else
  begin
    findex := -1;
  end;
  Invalidate;
end;

procedure TOnurCheckListBox.VScrollchange(Sender:TObject);
begin
  if fmodusewhelll = False then
  begin
     FItemvOffset := VScrollBar.Position;
     Invalidate;
  end;
end;

procedure TOnurCheckListBox.HScrollchange(Sender:TObject);
begin
  if fmodusewhelll = False then
  begin
    FItemhOffset := -HScrollBar.Position;
    Invalidate;
  end;
end;

procedure TOnurCheckListBox.SetString(AValue:TStrings);
begin
  if Flist = AValue then Exit;
  FList.Assign(aValue);
  SetLength(FChecked, FList.Count);
 // FillChar(FChecked[0], Length(FChecked) * SizeOf(Boolean), 0);
  Invalidate; // Yeniden çizme talebi

end;

procedure TOnurCheckListBox.MoveDown;
begin
   if flist.Count > 0 then
  begin
    if (findex > (FItemvOffset + FItemsShown)) or (findex < (FItemvOffset)) then
    begin
      findex := FItemvOffset;
    end
    else if (findex >= 0) and (findex < Flist.Count - 1) then
    begin
      Inc(findex);
      if (findex - FItemvOffset) > FItemsShown - 1 then
        Inc(FItemvOffset);
    end;

  end;
end;

procedure TOnurCheckListBox.MoveEnd;
begin
  if flist.Count > 0 then
  begin
    findex := Flist.Count - 1;
    if (Flist.Count - FItemsShown) >= 0 then
      FItemvOffset := Flist.Count - FItemsShown
    else
      FItemvOffset := 0;
  end;
end;

procedure TOnurCheckListBox.MoveHome;
begin
    if flist.Count > 0 then
  begin
    findex := 0;
    FItemvOffset := 0;
  end;
end;

procedure TOnurCheckListBox.MoveUp;
begin
   if flist.Count > 0 then
  begin
    //      Shift := GetKeyState(VK_SHIFT) < 0;

    if (findex > (FItemvOffset + FItemsShown)) or (findex < (FItemvOffset)) then
    begin
      findex := FItemvOffset;
    end
    else if (findex > 0) and (findex < Flist.Count) then
    begin
      // SCROLL?????
      if ((findex - FItemvOffset) = 0) and (FItemvOffset > 0) then
        Dec(FItemvOffset);

      Dec(findex);

    end;

  end;
end;

procedure TOnurCheckListBox.dblclick;
var
  pt: TPoint;
  i: integer;
begin

  if Items.Count > 0 then
  begin
    GetCursorPos(pt);
    i := GetItemAt(ScreenToClient(pt));
    if i > -1 then
    begin
      findex := i;
      Invalidate;
      //        if Assigned(FItemDblClick) then FItemDblClick(Self);
    end;
  end;
  inherited dblclick;
end;

procedure TOnurCheckListBox.SetSkindata(Aimg:TONURImg);
begin
  inherited SetSkindata(Aimg);
    resizing;
end;

procedure TOnurCheckListBox.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TOnurCheckListBox.resizing;
begin
 if (Skindata = nil) and (csDesigning in ComponentState) then exit;

  if Assigned(Skindata) then
  begin
   vScrollBar.Skindata:=Skindata;
   hScrollBar.Skindata:=Skindata;
  end;

  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect    := Rect(self.ClientWidth - (FTopRight.Croprect.Width), 0, self.ClientWidth, (FTopRight.Croprect.Height));
  FTop.Targetrect         := Rect((FTopleft.Croprect.Width), 0, self.ClientWidth - (FTopRight.Croprect.Width),(FTop.Croprect.Height));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.Croprect.Height), (FBottomleft.Croprect.Width), self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - (FBottomRight.Croprect.Width), self.ClientHeight - (FBottomRight.Croprect.Height), self.ClientWidth, self.ClientHeight);
  FBottom.Targetrect      := Rect((FBottomleft.Croprect.Width), self.ClientHeight - (FBottom.Croprect.Height), self.ClientWidth -(FBottomRight.Croprect.Width), self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Croprect.Height,(Fleft.Croprect.Width), self.ClientHeight - (FBottomleft.Croprect.Height));
  FRight.Targetrect       := Rect(self.ClientWidth - (FRight.Croprect.Width),(FTopRight.Croprect.Height), self.ClientWidth, self.ClientHeight - (FBottomRight.Croprect.Height));
  FCenter.Targetrect      := Rect(Fleft.Croprect.Width,FTop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight - FBottom.Croprect.Height);
  if Flist.Count>0 then
  Scrollscreen;
end;

function TOnurCheckListBox.DoMouseWheelDown(Shift:TShiftState;MousePos:TPoint):
  boolean;
begin
  fmodusewhelll := True;
  Result:=inherited DoMouseWheelDown(Shift,MousePos);
  if not VScrollBar.Visible then exit;
  if FItemVOffset =VScrollBar.max then exit;

  VScrollBar.Position := VScrollBar.Position + Mouse.WheelScrollLines;
  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;

function TOnurCheckListBox.DoMouseWheelUp(Shift:TShiftState;MousePos:TPoint):
  boolean;
begin
  fmodusewhelll := True;
  Result:=inherited DoMouseWheelUp(Shift,MousePos);
  if not VScrollBar.Visible then exit;
  if FItemVOffset =0 then exit;
  VScrollBar.Position := VScrollBar.Position - Mouse.WheelScrollLines;
  FItemVOffset := VScrollBar.Position;
  Result := True;
  Invalidate;
  fmodusewhelll := False;
end;

procedure TOnurCheckListBox.KeyDown(var Key:word;Shift:TShiftState);
var
  x: integer;
begin

  case key of
    VK_RETURN: if (Flist.Count > 0) and (findex > -1) then
      begin

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
        x := FItemvOffset - FItemsShown;
        if x < 0 then x := 0;
        FItemvOffset := x;
        findex := x;
        Invalidate;
      end;
    VK_NEXT: if Flist.Count > 0 then
      begin
        x := FItemvOffset + FItemsShown;
        if x >= flist.Count then x := Flist.Count - 1;
        if Flist.Count <= FItemsShown then
          FItemvOffset := 0
        else if x > (Flist.Count - FItemsShown) then
          FItemvOffset := Flist.Count - FItemsShown
        else
          FItemvOffset := x;

        findex := x;
        Invalidate;
      end;
    else
  end;
  inherited;
end;


procedure TOnurCheckListBox.BeginUpdate;
begin
   flist.BeginUpdate;
end;

procedure TOnurCheckListBox.EndUpdate;
begin
   flist.EndUpdate;
end;



end.

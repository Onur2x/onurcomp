unit onurlist;

{$mode objfpc}{$H+}


interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Dialogs, types, LazUTF8, Zipper,onurctrl,onurbar,onuredit;

type

   { TONURListBox }

  TONURListBox = class(TONURCustomControl)
  private
    Flist: TStrings;//List;
    findex: integer;
    fmodusewhelll:boolean;
    vScrollBar, hScrollBar: TONURScrollBar;
    FItemsShown, FitemHeight, FItemVOffset,FItemHOffset: integer;
  //  itempaintHeight: Trect;
    fchangelist:boolean;
    Fselectedcolor: Tcolor;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fitems: TONURCUSTOMCROP;

    //FFocusedItem: integer;


    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;

    function GetItemAt(Pos: TPoint): integer;
    function getitemheight: integer;
    function GetItemIndex: integer;
    function ItemRect(Item: integer): TRect;
    procedure LinesChanged(Sender: TObject);
    procedure MoveDown;
    procedure MoveEnd;
    procedure MoveHome;
    procedure MoveUp;
    procedure Scrollscreen;
    procedure setitemheight(avalue: integer);
    procedure SetItemIndex(Avalue: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure VScrollchange(Sender: TObject);
    procedure HScrollchange(Sender: TObject);

    procedure dblclick; override;
    procedure SetSkindata(Aimg: TONURImg); override;
  protected
    procedure KeyDown(var Key: word; Shift: TShiftState); virtual;
    procedure SetString(AValue: TStrings); virtual;
    // procedure KeyDown(var Key: word; Shift: TShiftState); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Clear;
    property OITEM           : TONURCUSTOMCROP read Fitems         write fitems;
    property OLEFT           : TONURCUSTOMCROP read Fleft          write Fleft;
    property ORIGHT          : TONURCUSTOMCROP read FRight         write FRight;
    property OCENTER         : TONURCUSTOMCROP read FCenter        write FCenter;
    property OBOTTOM         : TONURCUSTOMCROP read FBottom        write FBottom;
    property OBOTTOMLEFT     : TONURCUSTOMCROP read FBottomleft    write FBottomleft;
    property OBOTTOMRIGHT    : TONURCUSTOMCROP read FBottomRight   write FBottomRight;
    property OTOP            : TONURCUSTOMCROP read FTop           write FTop;
    property OTOPLEFT        : TONURCUSTOMCROP read FTopleft       write FTopleft;
    property OTOPRIGHT       : TONURCUSTOMCROP read FTopRight      write FTopRight;
    property OACTIVEITEM     : TONURCUSTOMCROP read factiveitems   write factiveitems;
  published
    property Alpha;
    property Items            : TStrings       read Flist          write SetString;
    property ItemIndex        : integer        read GetItemIndex   write SetItemIndex;
    property ItemHeight       : integer        read GetItemHeight  write SetItemHeight;
    property HorizontalScroll : TONURScrollBar read hScrollBar     write hScrollBar;
    property VertialScroll    : TONURScrollBar read vScrollBar     write vScrollBar;
    property Selectedcolor    : Tcolor         read Fselectedcolor write Fselectedcolor;
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


  { TONURComboBox }

  TONURComboBox = class(TONURCustomEdit)//(TonCustomcontrol)
  private
    Fliste: TStrings;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FOnGetItems: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    Fitemindex: integer;

    fpopupopen: boolean;
    //   FItemsShown    : integer;
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
    //   procedure SetText(AValue: string);


    procedure LstPopupReturndata(Sender: TObject; const Str: string; const indx: integer);
    procedure LstPopupShowHide(Sender: TObject);

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure SetSkindata(Aimg: TONURImg); override;

  protected

    //    procedure Change; virtual;
    procedure Select; virtual;
    procedure DropDown; virtual;
    procedure GetItems; virtual;
    procedure CloseUp; virtual;
    procedure SetStrings(AValue: TStrings); virtual;
    //    procedure KeyDown(var Key: word; Shift: TShiftState);  virtual;
    property OnCloseUp  : TNotifyEvent read FOnCloseUp  write FOnCloseUp;
    property OnDropDown : TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnGetItems : TNotifyEvent read FOnGetItems write FOnGetItems;
    property OnSelect   : TNotifyEvent read FOnSelect   write FOnSelect;
    public
      fbutonarea: Trect;
      property OLEFT         : TONURCUSTOMCROP read Fleft        write Fleft;
      property ORIGHT        : TONURCUSTOMCROP read FRight       write FRight;
      property OCENTER       : TONURCUSTOMCROP read FCenter      write FCenter;
      property OBOTTOM       : TONURCUSTOMCROP read FBottom      write FBottom;
      property OBOTTOMLEFT   : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
      property OBOTTOMRIGHT  : TONURCUSTOMCROP read FBottomRight write FBottomRight;
      property OTOP          : TONURCUSTOMCROP read FTop         write FTop;
      property OTOPLEFT      : TONURCUSTOMCROP read FTopleft     write FTopleft;
      property OTOPRIGHT     : TONURCUSTOMCROP read FTopRight    write FTopRight;
      property OBUTONNORMAL  : TONURCUSTOMCROP read FNormal      write FNormal;
      property OBUTONPRESS   : TONURCUSTOMCROP read FPress       write FPress;
      property OBUTONHOVER   : TONURCUSTOMCROP read FEnter       write FEnter;
      property OBUTONDISABLE : TONURCUSTOMCROP read Fdisable     write Fdisable;

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Paint; override;
      procedure BeginUpdate;
      procedure Clear;
      procedure EndUpdate;
  published
    property Alpha;
    property Text;//          : string        read Gettext        write SetText;
    property Items: TStrings read Fliste write SetStrings;
    property OnChange;//      : TNotifyEvent  read FOnChange      write FOnChange;
    property ReadOnly;//      : boolean       read freadonly      write freadonly;
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
    //    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    //    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    FCaller: TONURComboBox;
    FClosed: boolean;
    oblist: TONURListBox;
    FOnReturnDate: TReturnStintEvent;
    constructor Create(TheOwner: TComponent); override;
    procedure CMDeactivate(var Message: TLMessage); message CM_DEACTIVATE;
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure DoShow; override;
    procedure KeepInView(const PopupOrigin: TPoint);
    procedure ReturnstringAnditemindex;
    // protected
    // procedure Paint; override;
  end;

  TONURColumList = class;
  { TOlistItem }
{  TOnurStrings = class
  private
    FCells: array of string;
    FSize: integer;
    function GetCell(X: integer): string;
    function GetRowCount: integer;
    procedure SetCell(X: integer; AValue: string);
    procedure SetRowCount(AValue: integer);
  public
    constructor Create;
    procedure Add(s: string);
    procedure Clear;
    function Arrayofstring(aranan: string): integer;
    property Cells[Row: integer]: string read GetCell write SetCell;
    property Count: integer read GetRowCount write SetRowCount;
  end;
 }
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
    property Items[Indexi: integer]: TONURColumn read GetItem write SetItem; default;
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;
  end;

  TOnDeleteItem = procedure(Sender: TObject) of object;
  TOnCellClick = procedure(Sender: TObject; Column: TONURlistItem) of object;

  { TONURColumList }

  TONURColumList = class(TONURCustomControl)
  private

    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, factiveitems, fheader, fitems: TONURCUSTOMCROP;


    //itempaintHeight: Trect;
    fheaderfont: Tfont;
    FListItems: TONURlistItems;
    Fcolumns: TONURListColums;

    FItemvOffset: integer;
    FItemHOffset: integer;
    FItemsShown: smallint;
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
    procedure resizee;


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
    procedure SetSkindata(Aimg: TONURImg); override;

  public
    wait: boolean;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    property OHEADER      : TONURCUSTOMCROP  read fheader      write fheader;
    property OLEFT        : TONURCUSTOMCROP  read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP  read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP  read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP  read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP  read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP  read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP  read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP  read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP  read FTopRight    write FTopRight;
    property OACTIVEITEM  : TONURCUSTOMCROP  read factiveitems write factiveitems;
    property OITEM        : TONURCUSTOMCROP  read fitems       write fitems;

    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure Clear;
    procedure MoveUp;

    procedure MoveDown;
    procedure MoveHome;
    procedure MoveEnd;
    //    procedure FindItem(Texti: String);
    procedure Delete(indexi: integer);
    property Cells[ACol, ARow: integer]: string read GetCells write SetCells;

  published
    property Alpha;
    property OnCellClick       : TOnCellClick    read FOnCellclick       write FOnCellclick;
    property Columns           : TONURListColums read Fcolumns           write Setcolums;
    property Items             : TONURlistItems  read FListItems         write SetItems;
    property ItemIndex         : integer         read FFocusedItem       write FFocusedItem;
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



procedure Register;



implementation

uses BGRAPath, inifiles, clipbrd, strutils, LazUnicode,BGRAFreeType, LazFreeTypeFontCollection,BGRATransform;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURListBox]);
  RegisterComponents('ONUR', [TONURColumList]);
  RegisterComponents('ONUR', [TONURComboBox]);
end;


{ TONURListColums }

Function TONURListColums.Getitem(Indexi: Integer): TONURColumn;
Begin
   if Indexi <> -1 then
 Result := TONURColumn(inherited GetItem(Indexi));
End;

Procedure TONURListColums.Setitem(Indexi: Integer; Const Value: TONURColumn);
Begin
   inherited SetItem(Indexi, Value);
  Changed;
End;

Procedure TONURListColums.Setcells(Acol, Arow: Integer; Avalue: String);
Begin

End;

Function TONURListColums.Getcells(Acol, Arow: Integer): String;
Begin

End;

Procedure TONURListColums.Update(Item: Tcollectionitem);
Begin
 //   TONURColumList(GetOwner).Invalidate;//Paint;

 TONURColumList(GetOwner).Scrollscreen;
 // inherited Update(Item);
End;

Constructor TONURListColums.Create(Aowner: Tpersistent;
  Itemclassi: Tcollectionitemclass);
Begin
  inherited Create(AOwner, ItemClassi);
End;

Function TONURListColums.Add: TONURColumn;
Begin
  Result := TONURColumn(inherited Add);
End;

Procedure TONURListColums.Clear;
Begin
  with TONURColumList(GetOwner) do
  begin
    FItemvOffset  := 0;  FFocusedItem := -1;
  end;
End;

Procedure TONURListColums.Delete(Indexi: Integer);
var
  i:integer;
begin


 for i:=0 to Count-1 do
  Items[i].delete(Indexi);

  Changed;
End;

Function TONURListColums.Insert(Indexi: Integer): TONURColumn;
Begin
   Result := TONURColumn(inherited Insert(Indexi));
End;

Function TONURListColums.Indexof(Value: TONURColumn): Integer;
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

var
  i: integer;
begin
 { if (FListItems.Count > -1) and (FListItems.Count <= Acol) then
  begin
    FListItems.Add;
  end;
  if (FListItems[Acol].Items.Count > -1) and (FListItems[Acol].Items.Count <= Arow) then
  begin
    FListItems[Acol].Items.BeginUpdate;
    for i := FListItems[Acol].Items.Count + 1 to arow do
      FListItems[Acol].Items.Add('');

    FListItems[Acol].Items.Insert(Arow, Avalue);
    FListItems[Acol].Items.EndUpdate;
  end
  else
  begin
    FListItems[Acol].Items.BeginUpdate;
    FListItems[Acol].Items[Arow] := Avalue;
    FListItems[Acol].Items.EndUpdate;
  end;
 }
  FListItems.Cells[acol,arow]:=avalue;// [Acol].Items[Arow] := Avalue;
 // Scrollscreen;
 // Invalidate;

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
//  Scrollscreen;
//  Invalidate;
end;

procedure TONURColumList.Setcolums(Value: TONURListColums);
Begin
  Fcolumns.BeginUpdate;
  Fcolumns.Assign(Value);
  Fcolumns.EndUpdate;
  Scrollscreen;
  Invalidate;
End;



procedure TONURColumList.VScrollBarChange(Sender: TObject);
begin
  if fmodusewhelll = False then
  begin
    FItemvOffset := VScrollBar.Position;
  //  Paint;
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

constructor TONURColumList.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  parent := TWinControl(Aowner);
  Width := 180;
  Height := 200;
  TabStop := True;
  skinname := 'columlist';
  ControlStyle := ControlStyle - [csAcceptsControls] +
    [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];


  FListItems := TONURlistItems.Create(Self, TONURlistItem);
  Fcolumns   := TONURListColums.Create(Self, TONURColumn);
  fselectcolor := Clblue;
  FItemVOffset := 0;
  FItemHOffset := 0;
  FItemHeight := 24;
  FheaderHeight := 24;
  FFocusedItem := -1;
  FAutoHideScrollBar := True;
  Font.Name := 'Calibri';
  Font.Size := 9;
  Font.Style := [];
  TabStop := True;
  fbackgroundvisible := True;
  fheadervisible := True;
  FItemsShown := 0;
  fcolumindex := 0;
  Fheaderfont := Tfont.Create;
  Fheaderfont.Name := 'Calibri';
  Fheaderfont.Size := 10;
  Fheaderfont.Style := [];


  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  fitems := TONURCUSTOMCROP.Create;
  fitems.cropname := 'ITEM';

  factiveitems := TONURCUSTOMCROP.Create;
  factiveitems.cropname := 'ACTIVEITEM';
  fheader := TONURCUSTOMCROP.Create;
  fheader.cropname := 'HEADER';





  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Customcroplist.Add(fitems);
  Customcroplist.Add(factiveitems);
  Customcroplist.Add(fheader);



  Captionvisible := False;


  VScrollBar := TONURScrollBar.Create(self);
  with VScrollBar do
  begin
    Parent := self;
    Visible := False;
    Skinname := 'scrollbarv';
    Width := 25;
    left := Self.Width - (25);// + Background.Border);
    Top := 0;//Background.Border;
    Height := Self.Height;// - (Background.Border * 2);
    Max := 1;//Flist.Count;
    Min := 0;
    OnChange := @VScrollbarchange;
    Position := 0;
    Skindata := nil;

  end;

  HScrollBar := TonURScrollBar.Create(self);
  with HScrollBar do
  begin
    Parent := self;
    Visible := False;
    Skinname := 'scrollbarh';
    Width := self.Width;
    left :=0;//Self.Width - (25);// + Background.Border);
    Top := self.Height-25;//Background.Border;
    Height := 25;// - (Background.Border * 2);
    Max := 1;//Flist.Count;
    Min := 0;
    OnChange := @HScrollbarchange;
    Position := 0;
    Skindata := nil;
    Kind := oHorizontal;

  end;

end;

destructor TONURColumList.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

  if Assigned(VScrollBar) then
    FreeAndNil(VScrollBar);
  if Assigned(HScrollBar) then
    FreeAndNil(HScrollBar);

  FreeAndNil(FListItems);
  FreeAndNil(Fcolumns);

{  FreeAndNil(fheader);
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
  FreeAndNil(fitems); }

  inherited Destroy;
end;

procedure TONURColumList.Scrollscreen;
var
    fark,z: Integer;
begin
   hScrollBar.Height:=0;
   vScrollBar.Width:=0;
  if FListItems.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;


    if FListItems.Count - FItemsShown > 0 then
    begin
      with vScrollBar do
      begin

         if (Skindata = nil) then
         Skindata := Self.Skindata;

         if (Skindata <> nil) then
         begin
           Width :=(self.Oleft.Width)+ (ONORMAL.Width);
           left := Self.ClientWidth - ClientWidth;
           Top := self.OTOP.Height;

           Height := Self.ClientHeight - ((self.OBOTTOM.Height) + (self.OTOP.Height));
           Max := (FListItems.Count - FItemsShown) ;//+ 1;
           Alpha := self.Alpha;
           if kind<>oVertical then Kind:=oVertical;

         End;
      end;
    end;


    //hheig:=0;
    fark:=0;

    if Fcolumns.Count>0 then
    begin
      for z := 0 to Fcolumns.Count - 1 do
      begin
        if Fcolumns[z].Visible=true then
        begin
        fark+=Fcolumns[z].Width; //:= fark+Fcolumns[z].Width;
          if  fark>=self.ClientWidth then
          begin
            FItemshShown:=z;
            break
          end;
        end;
      end;

      for z := 0 to Fcolumns.Count - 1 do
      begin
        if Fcolumns[z].Visible=true then
        fark+=Fcolumns[z].Width; //:= fark+Fcolumns[z].Width;
      end;


      if fark>0 then
      with hScrollBar do
      begin
        if (Skindata = nil) then
          Skindata := Self.Skindata;

        if (Skindata <> nil) then
        begin
          left   := self.Fleft.Width;//(self.ONleft.Right - self.ONleft.Left);
          Width  := self.ClientWidth-(self.Fleft.Width+self.FRight.Width);//(self.ONRIGHT.Right - self.ONRIGHT.Left));

          Height := self.FTop.Height+ONORMAL.Height;//self.FTop.Height+self.FBottom.Height;// (self.ONTOP.Bottom - self.ONTOP.Top);
          Top    := self.ClientHeight-Height;//(self.ONTOP.Bottom - self.ONTOP.Top);

         if (fark>0) and (fark>ClientWidth) then
        //  Max :=((Fcolumns.Count) div (fark div ClientWidth))+1//((fark-self.ClientWidth) div Fcolumns.Count);
          Max :=(Columns.Count-FItemshShown)-1
          else
          max:=0;

         Alpha := self.Alpha;
        end;
      end;
    end;

   // WriteLn(fark,'  ',self.ClientWidth);


  end else
  begin
    vScrollBar.Visible := False;
    hScrollBar.Visible := False;
  end;

end;



procedure TONURColumList.SetSkindata(Aimg: TONURImg);
Begin
  Inherited Setskindata(Aimg);
  if (Aimg <> nil) then
  begin
   vScrollBar.Skindata:=Aimg;
   hScrollBar.Skindata:=Aimg;
  end;
  resizee;
 End;

procedure TONURColumList.resizee;
begin
   FTopleft.Targetrect     := Rect(0, 0,FTopleft.Width,FTopleft.Height);
   FTopRight.Targetrect    := Rect(self.ClientWidth - FTopRight.Width,0, self.ClientWidth, FTopRight.Height);
   FTop.Targetrect         := Rect(FTopleft.Width, 0,self.ClientWidth - FTopRight.Width,FTop.Height);
   FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Height,FBottomleft.Width, self.ClientHeight);
   FBottomRight.Targetrect := Rect(self.ClientWidth - FBottomRight.Width,self.ClientHeight - FBottomRight.Height, self.ClientWidth, self.ClientHeight);
   FBottom.Targetrect      := Rect(FBottomleft.Width,self.ClientHeight - FBottom.Height, self.ClientWidth - FBottomRight.Width, self.ClientHeight);
   Fleft.Targetrect        := Rect(0, FTopleft.Height,Fleft.Width, self.ClientHeight - FBottomleft.Height);
   FRight.Targetrect       := Rect(self.ClientWidth - FRight.Width, FTopRight.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Height);
   FCenter.Targetrect      := Rect(Fleft.Width, FTop.Height, self.ClientWidth - FRight.Width, self.ClientHeight -(FBottom.Height+FTop.Height));
   Scrollscreen;
end;






procedure TONURColumList.Paint;
var
  a, b, k, z, i: integer;
  x1, x2, x3, x4,fheaderh, fark,fark2: integer;
begin

   if (not Visible) then Exit;


   resim.SetSize(0, 0);
   resim.SetSize(self.ClientWidth, self.ClientHeight);

   resim.FontQuality :=fqSystemClearType;

   if (Skindata <> nil) and not (csDesigning in ComponentState) then
   begin

    //ORTA CENTER
     DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);

     if Fcolumns.Count > 0 then
     begin



      a := Fleft.Width;
      x1 := 0;
      x2 := 0;
      x3 := 0;
      x4 := 0;

        if (fheadervisible = True)  then
        for z := 0+abs(FItemhOffset) to (Fcolumns.Count - 1) do  // columns
        begin
          if Fcolumns[z].Visible = True then
          begin
           fark2+=Fcolumns[z].Width;
            if fheadervisible = True then
              b := a + FItemHeight
            else
              b := a;

            if z > 0 then
              x1 := x3
            else
              x1 := a;

            x2 := a;
            x3 := x1 + (Fcolumns[z].Width);
            x4 := a + FheaderHeight;

            if x3>self.ClientWidth then break;

            if (fheadervisible = True)  then
            begin
              if Fcolumns[z].Caption<>'' then
              begin
                resim.FontName   := Fheaderfont.Name;
                resim.FontHeight := Fheaderfont.Height;
                resim.FontStyle  := Fheaderfont.Style;
                DrawPartnormali(fheader.Croprect, self, x1,x2,x3,x4, alpha,Fcolumns[z].Caption,Fcolumns[z].Textalign,ColorToBGRA(Fheaderfont.Color, alpha));
              end else
              begin
                DrawPartnormali(fheader.Croprect, self, x1,x2,x3,x4, alpha);
              end;
            end;
          end;
        end;



      if fHeadervisible then
      begin
       b:=fHeaderHeight+FTop.Height;
       fheaderh:=FheaderHeight;
      end
      else
      begin
       fheaderh:=0;
       b:=FTop.Height;
      end;

      FItemsShown := FCenter.Targetrect.Height div FitemHeight;


       if FListItems.Count>0 then
         for i := FItemvOffset to  (FItemvOffset + (self.ClientHeight-(fheaderh+HScrollBar.Height)) div FItemHeight) - 1 do
         begin
           if i>FListItems.Count-1 then break;

           resim.FontName   := FListItems[i].font.Name;
           resim.FontHeight := FListItems[i].Font.Height;
           resim.FontStyle  := FListItems[i].Font.Style;


           if (i <= FListItems.Count-1) and (i > -1)  then
           begin

             x1:=0;
             x3:=a;
             for z := 0+abs(FItemhOffset) to (Fcolumns.Count - 1) do  // columns
             begin
                 x1:=x3;
                 x3 +=Fcolumns[z].Width;

                 if x3>self.ClientWidth then break;

                  if z = Fcolumns.Count - 1 then    // son item scrollbarı geçmesin
                  begin
                    if vScrollBar.Visible then
                    x3:= x3+FItemhOffset - vScrollBar.Width;
                  end;

                if FListItems[i].colCount>=z then
                begin
                  if FListItems[i].Cells[z]<>'' then
                  begin
                     if i = FFocusedItem then
                      DrawPartnormali(factiveitems.Croprect, self, x1,b,x3,b+FItemHeight, alpha,FListItems[i].Cells[z],Fcolumns[z].Textalign,ColorToBGRA(Fselectcolor, alpha))
                     else
                      DrawPartnormali(fitems.Croprect, self, x1,b,x3,b+FItemHeight, alpha,FListItems[i].Cells[z],Fcolumns[z].Textalign,ColorToBGRA(FListItems[i].Font.Color, alpha));
                  end else
                  begin
                      if i = FFocusedItem then
                      DrawPartnormali(factiveitems.Croprect, self, x1,b,x3,b+FItemHeight, alpha)
                     else
                      DrawPartnormali(fitems.Croprect, self, x1,b,x3,b+FItemHeight, alpha);
                  end;
                end;
             end;
           end;
          b +=FItemHeight;
          if (b >= FCenter.Targetrect.Height-(HScrollBar.Height)) then Break;
         End;
     end;


   {   with vScrollBar do
      begin
         if (Skindata = nil) then
         Skindata := Self.Skindata;

         if (Skindata <> nil) then
         begin
           Width :=(self.ONleft.Width)+ (ONNORMAL.Width);
           left := Self.ClientWidth - ClientWidth;
           Top := self.ONTOP.Height;

           Height := Self.ClientHeight - ((self.ONBOTTOM.Height) + (self.ONTOP.Height));
           Max := (FListItems.Count - FItemsShown) ;//+ 1;
           Alpha := self.Alpha;
           if kind<>oVertical then Kind:=oVertical;
         End;
      end;
     }


     for z := 0 to Fcolumns.Count - 1 do
     begin
       if Fcolumns[z].Visible=true then
       begin
         fark+=Fcolumns[z].Width; //:= fark+Fcolumns[z].Width;
         if  fark>=self.ClientWidth then
         begin
           FItemshShown:=z;
           break;
         end;
       end;
     end;


      //    Scrollscreen;
   //  if hScrollBar.Max>0 then
     if  fark2>=self.ClientWidth then
     begin
      hScrollBar.Visible := True;
      hScrollBar.Max :=(FColumns.Count-FItemshShown);
     end
     else
      hScrollBar.Visible := False;


     if FListItems.Count * FItemHeight > (FCenter.Targetrect.Height-HScrollBar.Height) then
      begin
       vScrollBar.Visible := True;
       vScrollBar.Max := (FListItems.Count - FItemsShown)+ 1;
     end
     else
       vScrollBar.Visible := False;



      if (Skindata <> nil) then
      begin

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
      end;



  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
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
    r.Top := FheaderHeight + (FTop.FSBottom - FTop.FSTop);

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top := r.top + ((Item - FItemvOffset) * FItemHeight); // + 2; // 2 = TOP MARGIN!!
    r.Bottom := r.Top + FItemHeight;
    r.Left := Fleft.FSright - Fleft.FSLeft;

    if vScrollBar.Visible then
      r.Right := vScrollBar.Left
    else
      r.Right := Fcolumns[col].Width - (Fleft.FSright - Fleft.FSLeft);
  end;

  Result := r;

end;

function TONURColumList.ItemRect(Item: integer): TRect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  if fheadervisible then
    r.Top := FheaderHeight + (FTop.FSBottom - FTop.FSTop);

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top := r.top + ((Item - FItemvOffset) * FItemHeight); // + 2; // 2 = TOP MARGIN!!
    r.Bottom := r.Top + FItemHeight;
    r.Left := Fleft.FSright - Fleft.FSLeft;

    if vScrollBar.Visible then
      r.Right := vScrollBar.Left
    else
      r.Right := Width - (Fleft.FSright - Fleft.FSLeft);
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

  w:=w+FTop.Height;

  if Pos.Y >= w then
    Result := FItemvOffset + ((Pos.Y - w) div FItemHeight);

  m := 0;
  fcolumindex := -1;
  w := 0;
  if (pos.X >= 0) then
    for i := 0 to Columns.Count - 1 do
    begin
      w := w + Fcolumns[i].Width;
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

procedure TONURColumList.Delete(indexi: integer);
begin
    FListItems.Delete(Indexi);
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
var
  i: integer;
begin
  if FListItems.Count > 0 then
  begin
    FFocusedItem := 0;
    FItemvOffset := 0;
  end;
end;

procedure TONURColumList.MoveEnd;
var
  i: integer;
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




{ TONURColumn }

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
  inherited Create(Collectioni);
  a:= TONURColumList(TOwnedCollection(GetOwner).Owner).Columns.Count;
  SetLength(FCells,a);
  FSize:=a;
  ffont:=Tfont.Create;
  ffont.Assign(TONURColumList(TOwnedCollection(GetOwner).Owner).Font);

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

function TONURlistItem.arrayofstring(aranan: string): integer;
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
  i: integer;
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

procedure TONURlistItems.Update(Item: TCollectionItem);
begin
  Inherited Update(Item);

   TONURColumList(GetOwner).resizee;
   TONURColumList(GetOwner).Invalidate;
end;

constructor TONURlistItems.Create(AOwner: TPersistent;
  ItemClassi: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClassi);

end;

function TONURlistItems.Add: TOnURlistItem;
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

function TONURlistItems.Insert(Indexi: Integer; col: array of integer; avalue: array of string
  ): TonURlistitem;
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
  parent          := TWinControl(Aowner);
  Width           := 180;
  Height          := 200;
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



  vScrollBar := TonURScrollBar.Create(self);
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

  HScrollBar := TonURScrollBar.Create(self);
  with HScrollBar do
  begin
    Parent     := self;
    Visible    := False;
    Skinname   := 'scrollbarh';
    Skindata   := nil;
    Kind      := oHorizontal;
    Height     := 25;
    left       := 0;
    Top        := self.ClientHeight-25;
    Width      := self.ClientWidth;
    Max        := 1;
    Min        := 0;
    OnChange   := @HScrollchange;
    Position   := 0;
  end;

  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  factiveitems := TONURCUSTOMCROP.Create;
  factiveitems.cropname := 'ACTIVEITEM';
  fitems := TONURCUSTOMCROP.Create;
  fitems.cropname := 'ITEM';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Customcroplist.Add(factiveitems);
  Customcroplist.Add(fitems);


  Captionvisible := False;
  fchangelist := true;
end;

destructor TONURListBox.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;


  if Assigned(vScrollBar) then
    FreeAndNil(vScrollBar);
  if Assigned(hScrollBar) then
    FreeAndNil(hScrollBar);
  FreeAndNil(Flist);
{  FreeAndNil(FTop);
  FreeAndNil(FBottom);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(factiveitems);
  FreeAndNil(fitems);}

  inherited Destroy;
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
procedure TONURListBox.LinesChanged(Sender: TObject);
begin
 fchangelist:=true;
 Invalidate;
end;

procedure TONURListBox.Scrollscreen;
var
  fark,z,p: Integer;
begin

  if Flist.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;

    if Flist.Count - FItemsShown + 1 > 0 then
    begin
      with vScrollBar do
      begin
        if (Skindata = nil) then
          Skindata := Self.Skindata;
        Width   := ONORMAL.Width;
        left    := Self.ClientWidth - ClientWidth;
        Top     := self.ftop.Height;
        Height  := Self.ClientHeight - (self.OTOP.Height+self.OBOTTOM.Height);
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
          left   := self.Fleft.Width;//(self.ONleft.Right - self.ONleft.Left);
          Width  := self.ClientWidth-(Left+self.FRight.Width);//(self.ONRIGHT.Right - self.ONRIGHT.Left));

          Height := self.FTop.Height+ONORMAL.Height;//self.FTop.Height+self.FBottom.Height;// (self.ONTOP.Bottom - self.ONTOP.Top);
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


procedure TONURListBox.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  if (Aimg <> nil) then
  begin
   vScrollBar.Skindata:=Aimg;
   hScrollBar.Skindata:=Aimg;
  end;

  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Width, FTopleft.Height);
  FTopRight.Targetrect    := Rect(self.ClientWidth - (FTopRight.Width), 0, self.ClientWidth, (FTopRight.Height));
  FTop.Targetrect         := Rect((FTopleft.Width), 0, self.ClientWidth - (FTopRight.Width),(FTop.Height));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.Height), (FBottomleft.Width), self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - (FBottomRight.Width), self.ClientHeight - (FBottomRight.Height), self.ClientWidth, self.ClientHeight);
  FBottom.Targetrect      := Rect((FBottomleft.Width), self.ClientHeight - (FBottom.Height), self.ClientWidth -(FBottomRight.Width), self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Height,(Fleft.Width), self.ClientHeight - (FBottomleft.Height));
  FRight.Targetrect       := Rect(self.ClientWidth - (FRight.Width),(FTopRight.Height), self.ClientWidth, self.ClientHeight - (FBottomRight.Height));
  FCenter.Targetrect      := Rect(Fleft.Width,FTop.Height, self.ClientWidth - FRight.Width, self.ClientHeight - FBottom.Height);
  if Flist.Count>0 then
  Scrollscreen;

end;

procedure TONURListBox.paint;
var
  a, b, k, i: integer;
   Target: Trect;
begin
//  if csDesigning in ComponentState then
//    Exit;
  if not Visible then Exit;

  if fchangelist=true then   // if items add or delete then calc to scrollbar
   Scrollscreen;

   fchangelist:=false;    // scrolbar refrsh false


  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

//  if (Skindata <> nil) then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
   //ORTA CENTER
   DrawPartnormal(FCenter.Croprect, self, fcenter.Targetrect, alpha);



  if Flist.Count > 0 then
  begin
    FItemsShown := FCenter.Targetrect.Height div FitemHeight;



    a := Fleft.Width;
    b := FTop.Height;
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
       Target := Rect(a, b, self.ClientWidth - a, b + FitemHeight);

        if (vScrollBar.Visible) then
          Target.Right := self.ClientWidth - (vScrollBar.ClientWidth);// + FRight.Width);

        if i = findex then
          DrawPartnormaltext(factiveitems.Croprect, self, Target, alpha,FList[i],taLeftJustify,ColorToBGRA(Fselectedcolor, alpha))
        else
         DrawPartnormaltext(fitems.Croprect, self, Target, alpha,FList[i],taLeftJustify,ColorToBGRA(self.Font.Color, alpha));

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

    if Crop then
      CropToimg(resim);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    FCenter.Targetrect.Height := self.ClientHeight;
  end;
  inherited paint;
end;

function TONURListBox.ItemRect(Item: integer): TRect;
var
  r: TRect;
begin
  r := Rect(0, 0, 0, 0);
  r.Top :=Ftop.Height;

  if (Item >= FItemvOffset - 1) and ((Item - FItemvOffset) * FItemHeight <
    FCenter.Targetrect.Height) then
  begin
    r.Top    := r.top + (Item - FItemvOffset) * FItemHeight;
    r.Bottom := r.Top + FItemHeight;
    r.Left   := fleft.Width;

    if Assigned(vScrollBar) and (vScrollBar.Visible) then
      r.Right := vScrollBar.Left
    else
      r.Right := FCenter.Targetrect.Width - (Fleft.Width);

    if Assigned(hScrollBar) and (hScrollBar.Visible) then
      r.Bottom := hScrollBar.Top
    else
      r.Bottom := FCenter.Targetrect.Height - (FBottom.FSBottom - FBottom.FSTop);
  end;

  Result := r;
end;



function TONURListBox.GetItemAt(Pos: TPoint): integer;
var
  w: Integer;
begin
  Result := -1;

  w := FTop.Height;

  //if (Pos.Y >= 0) and (PtInRect(itempaintHeight,pos)) then
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
//  var
//    Shift: boolean;
begin
  if flist.Count > 0 then
  begin
    //     Shift := GetKeyState(VK_SHIFT) < 0;

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
var
  i: integer;
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
var
  i: integer;
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
    if ClickedItem > -1 then findex := ClickedItem;
  end;

  SetFocus;
  Invalidate;
  inherited MouseDown(Button, Shift, X, Y);
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
    FItemhOffset := -HScrollBar.Position;
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
end;

procedure TONURListBox.EndUpdate;
begin
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
var
  i: Integer;
begin
  inherited doshow;
  // if oblist.Skindata=nil then
  // oblist.Skindata:=FCaller.Skindata;
  //writeln('OK');
//  oblist.Font := fCaller.Font;
//  oblist.Skindata := fCaller.Skindata;
 // oblist.items := fCaller.items;
 // oblist.Alpha := fCaller.Alpha;


//  oblist.items.Clear;

 // oblist.items.Assign(FCaller.Items);// :
 //writeln(FCaller.items.Count);
// for i:=0 to fcaller.items.count-1 do
// oblist.items.Add(FCaller.items[i]);
 //writeln(FCaller.items[i]);
// oblist.items:= FCaller.items;
//  writeln('OK2');
end;

procedure tpopupformcombobox.keepinview(const popuporigin: tpoint);
var
  ABounds: TRect;
  P: TPoint;
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
  //   Text:=inttostr(fvalue);
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
  //  if fdropdown=true then
  //   Fbutton.Caption :='▲'      //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17
  //  else
  //   Fbutton.Caption :='▼';     //▲ ▼ ► ◄  // ALT+30 ALT+31 ALT+16 ALT+17

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

  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  FNormal := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'PRESS';
  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';



  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Customcroplist.Add(FNormal);
  Customcroplist.Add(FPress);
  Customcroplist.Add(FEnter);
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
{  FreeAndNil(FNormal);
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
  FreeAndNil(FTopRight);}
  inherited Destroy;

end;


procedure TONURComboBox.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  fbutonarea              := Rect(Self.ClientWidth - self.ClientHeight, 0, self.ClientWidth, self.ClientHeight);
  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Croprect.Width{FTopleft.FSRight - FTopleft.FSLeft}, FTopleft.Croprect.Height{FTopleft.FSBottom - FTopleft.FSTop});
  FTopRight.Targetrect    := Rect(Self.ClientWidth - ((FTopRight.FSRight - FTopRight.FSLeft) + fbutonarea.Width), 0, Self.ClientWidth - (fbutonarea.Width), (FTopRight.FSBottom - FTopRight.FSTop));
  FTop.Targetrect         := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.ClientWidth - ((FTopRight.FSRight - FTopRight.FSLeft) + fbutonarea.Width),(FTop.FSBottom - FTop.FSTop));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop), (FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight);
  FBottomRight.Targetrect := Rect(Self.ClientWidth - ((FBottomRight.FSRight - FBottomRight.FSLeft) + fbutonarea.Width), self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop), Self.ClientWidth - (fbutonarea.Width), self.ClientHeight);
  FBottom.Targetrect      := Rect((FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop), Self.ClientWidth -((FBottomRight.FSRight - FBottomRight.FSLeft) + fbutonarea.Width), self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,(Fleft.FSRight - Fleft.FSLeft), self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop));
  FRight.Targetrect       := Rect(Self.ClientWidth - ((FRight.FSRight - FRight.FSLeft) + fbutonarea.Width),(FTopRight.FSBottom - FTopRight.FSTop), Self.ClientWidth - fbutonarea.Width, self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop));
  FCenter.Targetrect      := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop), Self.ClientWidth - ((FRight.FSRight - FRight.FSLeft) + fbutonarea.Width), self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop));
end;

procedure TONURComboBox.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
//   if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
//  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
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
      TrgtRect := Fdisable.Croprect;//Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
    end
    else
    begin
      case Fstate of
        obsnormal : TrgtRect := FNormal.Croprect;// Rect(FNormal.FSLeft, FNormal.FSTop, FNormal.FSRight, FNormal.FSBottom);
        obshover  : TrgtRect := FEnter.Croprect;// Rect(FEnter.FSLeft, FEnter.FSTop, FEnter.FSRight, FEnter.FSBottom);
        obspressed: TrgtRect := FPress.Croprect;// Rect(FPress.FSLeft, FPress.FSTop, FPress.FSRight, FPress.FSBottom);
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

end.

unit onuredit;

{$mode objfpc}{$H+}


interface

uses
  LCLType, Windows, SysUtils, LMessages, Forms, Classes,
  Controls, Graphics, ExtCtrls, BGRABitmap, BGRABitmapTypes, onurctrl, Types;

type
  TONURCustomEdit = class;

  { Toncaret }

  { TOnurCaret }

  TOnurCaret = class(TONURPersistent)
  private
    parent: TONURCustomEdit;
    FHeight, FWidth: integer;
    fvisibled: boolean;
    fblinkcolor: Tcolor;
    fblinktime: integer;
    factived: boolean;
    blinktimer: Ttimer;
    function GetActive: boolean;
    function Getblinktime: integer;
    procedure SetActive(AValue: boolean);
    procedure Setblinktime(const Value: integer);
    function Getvisible: boolean;
    procedure Setvisible(const Value: boolean);
    procedure ontimerblink(Sender: TObject);
    function Paint: boolean;
  public
    CaretPos: TPoint;
    constructor Create(aowner: TPersistent);
    destructor Destroy; override;
  published
    property Visible: boolean read Getvisible write Setvisible;
    property Active : boolean read GetActive write SetActive;
    property Blinktime: integer read Getblinktime write Setblinktime;
    property Height: integer read FHeight write FHeight;
    property Width: integer read FWidth write FWidth;
    property Color: Tcolor read fblinkcolor write fblinkcolor;
  end;

  ToCharCase = (ecNormal, ecUppercase, ecLowerCase);
  TOEchoMode = (emNormal, emNone, emPassword);


  { TONURCustomEdit }
  TONURCustomEdit= class(TONURCustomControl)
  private
    FPasswordChar      : char;
    FNumbersOnly       : boolean;
    Fcharcase          : ToCharCase;
    FEchoMode          : TOEchoMode;
    FLines             : TStrings;
    FOnChange          : TNotifyEvent;
    FReadOnly          : boolean;
    FCarets            : TOnurCaret;
    FDrawOffsetX       : Integer;
    fMultiLine         : boolean;
    FSelecting         : Boolean;
    FSelectingStartX   : Point;
    FSelectingEndX     : Point;

    lTextLeftSpacing   : integer;
    lTextRightSpacing  : integer;
    lTextBottomSpacing : integer;
    lTextTopSpacing    : integer;
    lTextCenterWidth   : integer;
    lTextCenterSp      : integer;
    FHintText          : String;
    FHintTextColor     : TColor;
    FHintTextStyle     : TFontStyles;

    procedure DrawText(a:TBGRABitmap);
    function GetCaretPos: TPoint;
    function getcharcase: ToCharCase;
    function getcurrentline: string;
    function getechomode: toechomode;
    function GetMultiLine: boolean;
    function getnumberonly: boolean;
    function GetPasswordChar: char;
    function GetReadOnly: boolean;
    function Getcaretcolor:Tcolor;
  //  function GetSelStartX: integer;
    function GetText: string;
    procedure LinesChanged(Sender: TObject);
    procedure SetCaretPost(AValue: TPoint);
    procedure setcharcase(const Value: tocharcase);
    procedure setcurrentline(astr: string);
    procedure setechomode(const Value: TOEchoMode);
    procedure SetLines(AValue: TStrings);
    procedure SetMultiLine(AValue: boolean);
    procedure setnumberonly(const Value: boolean);
    procedure SetPasswordChar(AValue: char);
    procedure SetReadOnly(AValue: boolean);
//    procedure SetSelStartX(AValue: integer);
    procedure SetSkindata(Aimg:TONURImg);override;
    procedure SetCaretcolor(AValue:Tcolor);
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

    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;
    procedure ClearCache;

    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer; WithThemeSpace: Boolean); override;
    function GetTextWidthCache(const Cache: EPaintCache; const Str: String): Integer;

    procedure SelectAll;
    procedure ClearSelection;
    function GetSelectionLen: Integer;
    function HasSelection: Boolean;
    function CharIndexAtXY(X, Y: Integer): Integer;
    function CalculateHeight: Integer;

  //  function GetAvailableWidth: Integer;
    function GetSelectedText: String;

    procedure AddCharAtCursor(C: TUtf8Char);
    procedure AddStringAtCursor(Str: String; ADeleteSelection: Boolean = False);
    procedure DeleteCharAtCursor;
    procedure DeleteSelection;
    procedure DelCharAtCursor;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ParentFontChanged; override;

    procedure FontChanged(Sender: TObject); override;
    procedure TextChanged; override;
    procedure Paint; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;

    procedure SetCaretPos(Pos: Integer);


  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoChange; virtual;
    procedure SetText(AValue: string);virtual;
    property CaretPos: TPoint read GetCaretPos write SetCaretPost;
//    property Lines: TStrings read FLines write SetLines;
    property MultiLine: boolean read GetMultiLine write SetMultiLine default False;
  property Lines: TStrings read FLines write SetLines;
  // property Selstart: integer read GetSelStartX write SetSelStartX;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
   published
    property Alpha;
    property CaretColor   : Tcolor       read Getcaretcolor   write Setcaretcolor default clred;
    property Text         : string       read GetText         write SetText stored False;
    property PasswordChar : char         read GetPasswordChar write SetPasswordChar default #0;
    property ReadOnly     : boolean      read GetReadOnly     write SetReadOnly default False;
    property NumberOnly   : boolean      read getnumberonly   write setnumberonly;
    property CharCase     : ToCharCase   read GetCharCase     write SetCharCase;
    property EchoMode     : TOEchoMode   read getechomode     write setechomode;
    property OnChange     : TNotifyEvent read FOnChange       write FOnChange;
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
{
  TONURCustomEdit8 = class(TONURCustomControl)
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
    FCarets: TOnurCaret;

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
    procedure lineschanged(Sender: TObject);
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
    procedure setreadonly(avalue: boolean); virtual;
  protected
    function GetText: string; virtual;
    function GetNumberOnly: boolean; virtual;
    function GetReadOnly: boolean; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure RealSetText(const Value: TCaption); override;
    procedure DoChange; virtual;
    // keyboard
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
    procedure paint; override;
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
    property Alpha;
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

}
  { TONUREdit }

  TONUREdit = class(TONURCustomEdit)
  private
    fback,fhback:TBGRABitmap;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    Fhleft, FhTopleft, FhBottomleft, FhRight, FhTopRight, FhBottomRight,
    FhTop, FhBottom, FhCenter: TONURCUSTOMCROP;
    fState: TONURButtonState;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Alpha;
    property Text;
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
    property OnKeyPress;
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


  { TONURMemo }

  TONURMemo = class(TONURCustomEdit)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    Fhleft, FhTopleft, FhBottomleft, FhRight, FhTopRight, FhBottomRight,
    FhTop, FhBottom, FhCenter: TONURCUSTOMCROP;
    fState: TONURButtonState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
  published
    property Alpha;
    property Lines;
    property Text;
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



  { TONURSpinEdit }

  TONURSpinEdit = class(TONURCustomEdit)
  private
    fvalue: integer;
    fmin, Fmax: integer;
    Fbuttonwidth: integer;
    Fbuttonheight: integer;
    Fubuttonarea: Trect;
    Fdbuttonarea: Trect;
    FuNormal, FuPress: TONURCUSTOMCROP;
    FuEnter, Fudisable: TONURCUSTOMCROP;   // up button picture
    FdNormal, FdPress: TONURCUSTOMCROP;
    FdEnter, Fddisable: TONURCUSTOMCROP;   // down button state
    Fustate, Fdstate: TONURButtonState; // up buttonstate, down buttonstate

    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    Fhleft, FhTopleft, FhBottomleft, FhRight, FhTopRight, FhBottomRight,
    FhTop, FhBottom, FhCenter: TONURCUSTOMCROP;
    fState: TONURButtonState;

    //   procedure feditchange(sender: tobject);   protected
    function getbuttonheight: integer;
    function getbuttonwidth: integer;
    function Getmax: integer;
    function Getmin: integer;
    //   function Gettext: integer;
    procedure setbuttonheight(avalue: integer);
    procedure setbuttonwidth(avalue: integer);
    procedure Setmax(AValue: integer);
    procedure Setmin(AValue: integer);
    procedure KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
 //   procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
 //   procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure SetText(AValue: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure MouseLeave; override;
    procedure MouseEnter; override;
  published
    property Alpha;
    property Value: integer read fvalue write fvalue;
    property MaxValue: integer read fmin write Setmin;
    property MinValue: integer read Fmax write Setmax;
    property Buttonwidth: integer read Fbuttonwidth write setbuttonwidth;
    property Buttonheight: integer read Fbuttonheight write setbuttonheight;
    property Text;
//    property PasswordChar;
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



procedure Register;



implementation

uses  BGRAPath, LazUTF8,Clipbrd;//, onurlist,  StrUtils;

procedure Register;
begin
  RegisterComponents('ONUR', [TONUREdit, TONURMemo, TONURSpinEdit]);
end;

{ Toncaret }

function TOnurCaret.Getblinktime: integer;
begin
  Result := fblinktime;
end;

function TOnurCaret.GetActive: boolean;
begin
 result:=factived;
end;

procedure TOnurCaret.SetActive(AValue: boolean);
begin
   if AValue <> factived then
    factived := AValue;

   blinktimer.Enabled := AValue;

  if AValue = False then
  begin
    fvisibled := False;
    paint;
  end;
end;

procedure TOnurCaret.Setblinktime(const Value: integer);
begin
  if (Value <> fblinktime) and (Value > 10) then
  begin
    fblinktime := Value;
    blinktimer.Interval := fBlinktime;
  end;
end;

function TOnurCaret.Getvisible: boolean;
begin
  Result := fvisibled;
end;

procedure TOnurCaret.Setvisible(const Value: boolean);
begin
  if Value <> fvisibled then
    fvisibled := Value;

end;

procedure TOnurCaret.ontimerblink(Sender: TObject);
begin
  fvisibled := not fvisibled;
  paint;
end;

function TOnurCaret.Paint: boolean;
begin
  if parent is TONURCustomEdit then
    TONURCustomEdit(parent).Invalidate;
  Result := True;
end;

constructor TOnurCaret.Create(aowner: TPersistent);
begin
  inherited Create;
  parent              := TONURCustomEdit(aowner);
  FHeight             := 20;
  FWidth              := 2;
  fblinkcolor         := clBlack;
  fblinktime          := 600;
  blinktimer          := TTimer.Create(nil);
  blinktimer.Interval := blinktime;
  blinktimer.OnTimer  := @ontimerblink;
  blinktimer.Enabled  := False;
  CaretPos.X          := 0;
  CaretPos.Y          := 0;
  factived            := False;
end;

destructor TOnurCaret.Destroy;
begin
  FreeAndNil(blinktimer);
  inherited Destroy;
end;




// -----------------------------------------------------------------------------




{ TONURCustomEdit }

function GetFontSize(Control: TWinControl; IncAmount: Integer): Integer;
begin
  Result := Round(Abs(GetFontData(Control.Font.Handle).Height) * 72 / Control.Font.PixelsPerInch) + IncAmount;
end;

function VisibleText(const aVisibleText: string; const APasswordChar: char): string;
begin
  if aPasswordChar = #0 then
    Result := aVisibleText
  else
    Result := StringOfChar(aPasswordChar, Length(aVisibleText));

end;

procedure TONURCustomEdit.LinesChanged(Sender: TObject);
begin
  Invalidate;
end;

constructor TONURCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop        := True;
  Cursor         := crIBeam;
  ControlStyle   := ControlStyle - [csAcceptsControls] +
    [ csClickEvents, csCaptureMouse, csDoubleClicks,csRequiresKeyboardInput];

  FLines         := TStringList.Create;
  FPasswordChar  := #0;
  FCarets        := TOnurCaret.Create(self);
  FCarets.Color  := clred;
  Self.Height    := 30;
  Self.Width     := 80;
  resim.SetSize(Width, Height);
  Captionvisible := False;
  FSelecting     := False;

  lTextTopSpacing    := 3;
  lTextBottomSpacing := 3;
  lTextLeftSpacing   := 3;
  lTextRightSpacing  := 3;
  lTextCenterWidth   := Self.ClientWidth-6;

  if self is TONURMemo then
  begin
    MultiLine := True;
    TStringList(FLines).OnChange := @LinesChanged;
  end;
  doexit;
end;

procedure TONURCustomEdit.Clear;
begin
 FLines.Clear;
 FCarets.CaretPos := Point(0,0);
end;

destructor TONURCustomEdit.Destroy;
begin
  FreeAndNil(FLines);
  FreeAndNil(FCarets);
  inherited Destroy;
end;

procedure TONURCustomEdit.DrawText(a:TBGRABitmap);
var

  caretrect: Trect;
 // lTextLeftSpacing,lTextRightSpacing,
 // lTextBottomSpacing, lTextTopSpacing,
// lTextCenter:integer;
//  lTextCenterSp: integer;

  TextWidth: Integer;
  X1, X2: Integer;
  DrawCaretX: Integer;
  NewText:string;
  stl: TTextStyle;
  re:TRect;
begin

    NewText:=Text;

    if Fcharcase=ecUppercase then
     NewText := UTF8UpperString(NewText)
    else if Fcharcase=ecLowerCase then
     NewText := UTF8LowerCase(NewText);

    NewText   := VisibleText(NewText,FPasswordChar);
    TextWidth := GetTextWidthCache(EPaintCache.TEXT, UTF8Copy(NewText, 1, FCarets.CaretPos.x))+lTextRightSpacing;
 //  TextWidth := self.resim.TextSize(NewText).cx;//




    if (TextWidth > lTextCenterWidth{ClientWidth-(lTextLeftSpacing+lTextRightSpacing)}) then //-(lTextRightSpacing)) then
     FDrawOffsetX := -(TextWidth - lTextCenterWidth)
    else
     FDrawOffsetX := lTextLeftSpacing;



    // Selection
    if HasSelection() then
    begin
      X1 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_START, UTF8Copy(NewText, 1, FSelectingStartX.x));
      X2 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_END,   UTF8Copy(NewText, 1, FSelectingEndX.x));
      a.FillRect(Rect(X1, lTextTopSpacing, X2, ClientHeight-lTextBottomSpacing),colortobgra(fcarets.color));
    end;


  //  yaziyazBGRA(a.CanvasBGRA,self.font,Rect(lTextLeftSpacing,lTextTopSpacing, ClientWidth-(lTextRightSpacing), ClientHeight-lTextBottomSpacing),NewText,Alignment);
    //stl.Alignment           := self.Alignment;
   // stl.Wordbreak           := false;
    stl.Layout              := tlCenter;
    re:=Rect(lTextLeftSpacing,lTextTopSpacing,{lTextCenter-lTextCenterSp,} {lTextLeftSpacing+lTextCenterWidth+lTextRightSpacing}ClientWidth-(lTextRightSpacing), ClientHeight-lTextBottomSpacing);
    a.FontName:=self.font.name;
    a.FontHeight:=Self.font.size;
    a.TextRect(RE,FDrawOffsetX,0,newtext,stl,colortobgra(self.font.color));

    if Fcarets.visible then
    begin
      if (Text = '') then
       DrawCaretX := lTextLeftSpacing  //TONURCustomCrop(self.Customcroplist[6]).Width
      else
       DrawCaretX := FDrawOffsetX + (TextWidth-1)-lTextLeftSpacing;


      caretrect:=Rect(DrawCaretX, re.Top {lTextTopSpacing}, DrawCaretX+FCarets.Width,re.bottom {ClientHeight-lTextBottomSpacing} );
      a.FillRect(caretrect,ColorToBGRA(FCarets.Color),dmDrawWithTransparency);
    end;

end;

procedure TONURCustomEdit.Paint;
//var

  //caretrect: Trect;
  //lTextLeftSpacing,lTextRightSpacing,
//  lTextBottomSpacing, lTextTopSpacing,lTextCenter:integer;
 // lTextCenterSp: integer;

//  TextWidth: Integer;
//  X1, X2: Integer;
//  DrawCaretX: Integer;
//  NewText:string;
begin

  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;

  DrawText(self.resim);
   inherited Paint;

  //inherited Paint;
 {
  lTextTopSpacing    := TONURCustomCrop(self.Customcroplist[1]).Croprect.Height;
  lTextBottomSpacing := TONURCustomCrop(self.Customcroplist[4]).Croprect.Height;
  lTextLeftSpacing   := TONURCustomCrop(self.Customcroplist[6]).Croprect.Width;
  lTextRightSpacing  := TONURCustomCrop(self.Customcroplist[7]).Croprect.Width;



 if (Text <> '') then
  begin
    NewText:=Text;

    if Fcharcase=ecUppercase then
     NewText:=UTF8UpperString(NewText)
    else
     NewText:=UTF8LowerCase(NewText);

    NewText:=VisibleText(NewText,FPasswordChar);



    TextWidth := GetTextWidthCache(EPaintCache.TEXT, Copy(NewText, 1, FCarets.CaretPos.x))+lTextRightSpacing;

  //  if (not Fcarets.Visible) then
  //  begin
      if (TextWidth >ClientWidth-(lTextLeftSpacing+lTextRightSpacing)) then //-(lTextRightSpacing)) then
        FDrawOffsetX := -((TextWidth) - GetAvailableWidth())
      else
        FDrawOffsetX := lTextLeftSpacing;
 //   end;



    // Selection
    if HasSelection() then
    begin
      if (FSelectingStartX.x > FSelectingEndX.x) then
      begin
        X1 := FSelectingEndX.x;
        X2 := FSelectingStartX.x;
      end else
      if (FSelectingStartX.x < FSelectingEndX.x) then
      begin
        X1 := FSelectingStartX.x;
        X2 := FSelectingEndX.x;
      end else
      begin
        X1 := FSelectingStartX.x;
        X2 := FSelectingStartX.x + 1;
      end;

      X1 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_START, Copy(NewText, 1, FSelectingStartX.x));
      X2 := FDrawOffsetX + GetTextWidthCache(EPaintCache.SEL_END,   Copy(NewText, 1, FSelectingEndX.x));

      self.Skindata.Fimage.Canvas.Brush.Color := clblue;//FColorSelection;
      self.Skindata.Fimage.Canvas.FillRect(X1, lTextTopSpacing, X2, ClientHeight-lTextBottomSpacing);
    end;
   }
//    self.Skindata.Fimage.

//    yaziyazBGRA(self.Skindata.Fimage.CanvasBGRA,self.font,Rect(lTextLeftSpacing,lTextTopSpacing, ClientWidth-(lTextRightSpacing), ClientHeight-lTextBottomSpacing),NewText,self.Alignment);

   // Canvas.TextRect(Rect(lTextLeftSpacing,lTextTopSpacing, ClientWidth-(lTextRightSpacing), ClientHeight-lTextBottomSpacing), FDrawOffsetX, lTextTopSpacing, newText);
  //Canvas.TextRect(Rect(lTextLeftSpacing,lTextCenter-lTextCenterSp, ClientWidth-(lTextRightSpacing), ClientHeight-lTextBottomSpacing), FDrawOffsetX, 1, newText);

//  canvas.TextRect(ClientRect, FDrawOffsetX, lTextTopSpacing, newText);
 // end;



  //DrawText;
{  caretrect := Rect(lCaretPixelPos, lLineTop, lCaretPixelPos +
    FCarets.Width, lLineTop + lCaptionHeight);
 }


 {

  if Fcarets.visible then
  begin
    if (Text = '') then
     DrawCaretX := lTextLeftSpacing  //TONURCustomCrop(self.Customcroplist[6]).Width
    else
     DrawCaretX := (FDrawOffsetX + (TextWidth-lTextLeftSpacing));// - 1;



    caretrect:=Rect( DrawCaretX, lTextTopSpacing, DrawCaretX+FCarets.Width, ClientHeight-lTextBottomSpacing );

    self.Skindata.Fimage.canvas.Brush.Color := FCarets.Color;     //color or image
    self.Skindata.Fimage.canvas.FillRect(caretrect);
  end;

   }

end;



function TONURCustomEdit.getcharcase: ToCharCase;
begin
  Result := FCharCase;
end;

function TONURCustomEdit.getechomode: TOEchoMode;
begin
  Result := fEchoMode;
end;

procedure TONURCustomEdit.setechomode(const Value: TOEchoMode);
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

procedure TONURCustomEdit.setcharcase(const Value: TOCharCase);
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    Invalidate;
  end;
end;



procedure TONURCustomEdit.SetLines(AValue: TStrings);
begin
  if FLines = AValue then Exit;
  FLines.Assign(AValue);
  DoChange();
  Invalidate;
end;

procedure TONURCustomEdit.SetMultiLine(AValue: boolean);
begin
  if FMultiLine = AValue then Exit;
  FMultiLine := AValue;
  Invalidate;
end;

procedure TONURCustomEdit.setnumberonly(const Value: boolean);
begin
  if FNumbersOnly <> Value then FNumbersOnly := Value;
end;

procedure TONURCustomEdit.SetReadOnly(AValue: boolean);
begin
  if FReadOnly <> avalue then FReadOnly := avalue;
end;

procedure TONURCustomEdit.SetSkindata(Aimg:TONURImg);
begin
  inherited SetSkindata(Aimg);
  lTextTopSpacing    := TONURCustomCrop(self.Customcroplist[1]).Croprect.Height;
  lTextBottomSpacing := TONURCustomCrop(self.Customcroplist[4]).Croprect.Height;
  lTextLeftSpacing   := TONURCustomCrop(self.Customcroplist[6]).Croprect.Width;
  lTextRightSpacing  := TONURCustomCrop(self.Customcroplist[7]).Croprect.Width;
  lTextCenterWidth   := TONURCustomCrop(self.Customcroplist[8]).Croprect.Width;
end;

procedure TONURCustomEdit.SetCaretcolor(AValue:Tcolor);
begin
if FCarets.Color=AValue then exit;
FCarets.Color:=AValue;
end;



procedure TONURCustomEdit.SetText(AValue: string);
begin
  Lines.Text := aValue;
  Invalidate;
end;

procedure TONURCustomEdit.SetPasswordChar(AValue: char);
begin
  if AValue = FPasswordChar then Exit;
  FPasswordChar := AValue;
  Invalidate;
end;



procedure TONURCustomEdit.dochange;
begin
  Changed;
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;


function TONURCustomEdit.GetCaretPos: TPoint;
begin
  Result := FCarets.CaretPos;
end;

function TONURCustomEdit.GetMultiLine: boolean;
begin
  Result := FMultiLine;
end;

function TONURCustomEdit.GetReadOnly: boolean;
begin
  Result := FReadOnly;
end;

function TONURCustomEdit.Getcaretcolor:Tcolor;
begin
result:=FCarets.Color;
end;

function TONURCustomEdit.getnumberonly: boolean;
begin
  Result := FNumbersOnly;
end;


function TONURCustomEdit.GetText: string;
begin
  if Multiline then
    Result := Lines.Text
  else if Lines.Count = 0 then
    Result := ''
  else
    Result := Lines[0];
end;

function TONURCustomEdit.GetPasswordChar: char;
begin
  Result := FPasswordChar;
end;

procedure TONURCustomEdit.SetCaretPost(AValue: TPoint);
begin
  FCarets.CaretPos.X := AValue.X;
  FCarets.CaretPos.Y := AValue.Y;
  Invalidate;
end;


procedure tonURcustomedit.doenter;
begin
  FCarets.Active := True;
  inherited DoEnter;
end;

procedure tonURcustomedit.doexit;
begin
  FCarets.Active := False;
  ClearSelection();
  inherited DoExit;
end;

procedure TONURCustomEdit.KeyDown(var Key: Word; Shift: TShiftState);
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
         SetCaretPos(FCarets.CaretPos.x-1);
         Key := 0;
       end;

     VK_RIGHT:
       begin
         SetCaretPos(FCarets.CaretPos.x+1);

         Key := 0;
       end;
     VK_HOME:
       begin
         ClearSelection;
         if [ssShift] = Shift then
         begin
            FSelectingStartX.X := 0;
            FSelectingEndX.X := FCarets.CaretPos.X;
         end;
         FCarets.CaretPos.X := 0;

         Invalidate;
       end;

      VK_END:
       begin
        //if FCarets.CaretPos.X < lOldTextLength then
         begin
           ClearSelection;
          // caretoldpos := GetAvailableWidth;

           if [ssShift] = Shift then
           begin
             FSelectingStartX.X := FCarets.CaretPos.X;
             FSelectingEndX.X   := lTextCenterWidth;//caretoldpos;
           end;

          FCarets.CaretPos.X :=  lTextCenterWidth;//caretoldpos;
          Invalidate;
        {end
        // if we are not moving, at least deselect
        else if (FSelLength <> 0) and ([ssShift] <> Shift) then
        begin
          FSelLength := 0;
          Invalidate;}
        end;
      end;
   {  VK_UP:
    begin
      if not MultiLine then Exit;
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
     }
      VK_DOWN:
      begin
         if not MultiLine then Exit;
        if FCarets.CaretPos.Y < FLines.Count - 1 then
        begin
        {// Selecting to the right
        if [ssShift] = Shift then
        begin
          if FSelLength = 0 then FSelStart.X := FCaretPos.X;
          Inc(FSelLength);
        end
        // Normal move to the right
        else}

          //FSelLength := 0;

          Inc(FCarets.CaretPos.Y{FCaretPos.Y});

          FCarets.Active := True;
          Invalidate;
        end
        // if we are not moving, at least deselect
        else if ([ssShift] <> Shift) then
        begin
        //  FSelLength := 0;
          Invalidate;
        end;
      end;

      VK_DELETE:
      begin

        if HasSelection then
         DeleteSelection()
        else
         DelCharAtCursor;

        Key := 0;
      end;
  end;


  //ToDo: Change this when proper multi-line selection is implemented


    // Backspace

    //yapıalcak if FCarets.CaretPos.Y < FLines.Count - 1 then
    // DEL




 // if lKeyWasProcessed then
//  begin
    //    FEventArrived := True;
//    Key := 0;
//  end;
end;



{procedure TONURCustomEdit.keyup(var key: word; shift: tshiftstate);
var
  lOldText, lLeftText, lRightText: string;
begin
  inherited KeyUp(Key, Shift);

  // copy, paste, cut, etc
  if Shift = [ssCtrl] then
  begin
    lOldText := GetCurrentLine();
    case Key of
      VK_C:
      begin
        clipboard.astext := midstr(lOldText, fselstart.x + 1, fSelLength);
      end;
      VK_X:
      begin
        clipboard.astext := midstr(lOldText, fselstart.x + 1, fSelLength);
        lLeftText := UTF8Copy(lOldText, 1, fselstart.x);
        //+' - '+inttostr(fselstart.x)+' - '
        lRightText := UTF8Copy(lOldText, fselstart.x + 1 + fSelLength,
          UTF8Length(lOldText));
        SetCurrentLine(lLeftText + '' + lRightText);

        //   FCarets.CaretPos.X:=0;
        //   DoManageVisibleTextStart();
        FCarets.Visible := True;
        FCarets.CaretPos.X := UTF8Length(lOldText);
        fSelstart.x := 0;
        fSelLength := 0;
        Invalidate;
      end;
      VK_V:
      begin
        lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X {FCaretPos.X});
        lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X {FCaretPos.X} +
          1, UTF8Length(lOldText));
        SetCurrentLine(lLeftText + Clipboard.AsText + lRightText);
        FCarets.CaretPos.x := FCarets.CaretPos.x + UTF8Length(Clipboard.AsText);

        DoManageVisibleTextStart();
        FCarets.Visible := True;
        Invalidate;
      end;

      VK_A:
      begin
        fSelstart.x := 0;
        fSelLength := UTF8Length(lOldText);
        DoManageVisibleTextStart();
        Invalidate;
      end;
    end;
  end;
end;
}
procedure TONURCustomEdit.UTF8KeyPress(var UTF8Key: TUTF8Char);
var
//  lLeftText, lRightText, lOldText,
NewTexti: string;
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

 // ClearSelection;

 { DoDeleteSelection;
  //▲ ▼ ► ◄ ‡ // ALT+30 ALT+31 ALT+16 ALT+17 ALT+0135

  // Normal characters
  lOldText := GetCurrentLine();
  lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X {FCaretPos.X});
  lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X {FCaretPos.X} +
    1, UTF8Length(lOldText));
  SetCurrentLine(lLeftText + UTF8Key + lRightText);
  Inc(FCarets.CaretPos.X{FCaretPos.X});
  DoManageVisibleTextStart();

  }



  if HasSelection then
    DeleteSelection();


  Inc(FCarets.CaretPos.X);
  NewTexti := Text;
  UTF8Insert(UTF8Key, NewTexti, FCarets.CaretPos.X);

  Text := NewTexti;



  UTF8Key := '';

  FCarets.Active := True;
  Invalidate;
end;

procedure TONURCustomEdit.SetCaretPos(Pos: Integer);
begin
  if (Pos < 0) then
    FCarets.CaretPos.x := 0
  else
  if (Pos > UTF8Length(Text)) then
    FCarets.CaretPos.X := UTF8Length(Text)
  else
    FCarets.CaretPos.X := Pos;

  Invalidate();
end;




procedure TONURCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  SetFocus;

  I := CharIndexAtXY(X, Y);


  SetCaretPos(I);
  FCarets.Active := True;

  FSelecting := True;
  FSelectingStartX.X := I;
  FSelectingEndX.X := I;
  Invalidate;
end;

procedure TONURCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  // Mouse dragging selection

  if FSelecting then
  begin
    SetCaretPos(CharIndexAtXY(X, Y));

    FSelectingEndX.x := CharIndexAtXY(X, Y);

    Invalidate();
  end;

end;

procedure TONURCustomEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FSelecting := False;
  FSelectingEndX.X := CharIndexAtXY(X, Y);

end;

procedure TONURCustomEdit.ParentFontChanged;
begin
  inherited ParentFontChanged;
end;

procedure TONURCustomEdit.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
end;

procedure TONURCustomEdit.TextChanged;
begin
  inherited TextChanged;
end;


procedure TONURCustomEdit.WMSetFocus(var Message: TLMSetFocus);
begin
  DoEnter;
end;

procedure TONURCustomEdit.WMKillFocus(var Message: TLMKillFocus);
begin
  DoExit;
end;

procedure TONURCustomEdit.ClearCache;

 var
  Cache: EPaintCache;
begin
  for Cache in EPaintCache do
  begin
    FTextWidthCache[Cache].Str   := '';
    FTextWidthCache[Cache].Width := 0;
  end;
end;

procedure TONURCustomEdit.CalculatePreferredSize(var PreferredWidth,
  PreferredHeight: integer; WithThemeSpace: Boolean);
begin
  inherited CalculatePreferredSize(PreferredWidth, PreferredHeight,
    WithThemeSpace);
  PreferredHeight := CalculateHeight();
end;

function TONURCustomEdit.GetTextWidthCache(const Cache: EPaintCache;
  const Str: String): Integer;
begin
  if (Str <> FTextWidthCache[Cache].Str) then
  begin
    FTextWidthCache[Cache].Str := Str;
    FTextWidthCache[Cache].Width := self.resim.TextSize(str).cx;//Canvas.TextWidth(Str);
  end;


  //EPaintCache.TEXT, Copy(NewText, 1, FCarets.CaretPos.x))


  Result := FTextWidthCache[Cache].Width;
end;

procedure TONURCustomEdit.SelectAll;
begin
  FSelectingStartX.x := 0;
  FSelectingEndx.X   := UTF8Length(Text);

  Invalidate();
end;

procedure TONURCustomEdit.ClearSelection;
begin
  FSelectingStartx.X := 0;
  FSelectingEndx.X := 0;
end;

function TONURCustomEdit.GetSelectionLen: Integer;
begin
  Result := Abs(FSelectingStartX.x - FSelectingEndX.x);
end;

function TONURCustomEdit.HasSelection: Boolean;
begin
  Result := GetSelectionLen > 0;
end;


function TONURCustomEdit.CharIndexAtXY(X, Y: Integer): Integer;
var
  I, Test: Integer;
  W: Integer;
begin
  Result := UTF8Length(Text);

  Test := FDrawOffsetX;

  for I := 1 to UTF8Length(Text) do
  begin
    W :=resim.TextSize(Text[I]).cx;//Canvas.TextWidth(Text[I]);      // writeln(w,'   ',resim.TextSize(Text[I]).cx);
    Test += W;
    if ((Test-(W div 2)) >= X) then
    begin
      Result := I-1;
      Exit;
    end;
  end;

end;

function TONURCustomEdit.CalculateHeight: Integer;
begin
  with TBitmap.Create() do
  try
    self.resim.FontName   := Self.Font.name;
    self.resim.FontHeight := GetFontSize(Self, 1);

    Result :=resim.TextSize('Çİ').cy;//; Canvas.TextHeight('Çİ');
  finally
    Free();
  end;
end;



function TONURCustomEdit.GetSelectedText: String;
begin
   if (FSelectingStartx.X > FSelectingEndx.X) then
    Result := UTF8Copy(Text, FSelectingEndX.X + 1, FSelectingStartX.X - FSelectingEndX.X)
  else
    Result := UTF8Copy(Text, FSelectingStartX.X + 1, FSelectingEndX.X - FSelectingStartX.X);
end;


procedure TONURCustomEdit.AddCharAtCursor(C: TUtf8Char);
var
  NewTexti: String;
begin
  if HasSelection then
    DeleteSelection();

  Inc(FCarets.CaretPos.X);
  NewTexti := Text;
  UTF8Insert(C, NewTexti, FCarets.CaretPos.X);
  Text := NewTexti;
end;

procedure TONURCustomEdit.AddStringAtCursor(Str: String;
  ADeleteSelection: Boolean);
var
  NewTexti: String;
begin
  if ADeleteSelection then
    DeleteSelection();

  NewTexti := Text;

  UTF8Insert(Str, NewTexti, FCarets.CaretPos.X + 1);
  Inc(FCarets.CaretPos.X, Length(Str));

  Text := NewTexti;

end;

procedure TONURCustomEdit.DeleteCharAtCursor;
var
  NewTexti: String;
begin
  if (FCarets.CaretPos.X >= 1) and (FCarets.CaretPos.X <= Length(Text)) then
  begin
    NewTexti := Text;

    UTF8Delete(NewTexti, FCarets.CaretPos.X, 1);
    Dec(FCarets.CaretPos.X);

    Text := NewTexti;
  end;
end;

procedure TONURCustomEdit.DeleteSelection;
var
  NewTexti: String;
begin
  if HasSelection() then
  begin
    NewTexti := Text;

    if (FSelectingStartX.x > FSelectingEndX.x) then
      UTF8Delete(NewTexti, FSelectingEndX.x + 1, GetSelectionLen())
    else
      UTF8Delete(NewTexti, FSelectingStartX.x + 1, GetSelectionLen());

    if (FSelectingEndX.x > FSelectingStartX.x) then
      SetCaretPos(FCarets.CaretPos.X - GetSelectionLen());
    Text := NewTexti;
    ClearSelection();
  end;

end;


procedure TONURCustomEdit.DelCharAtCursor;
var
  NewTexti: String;
begin
  if (FCarets.CaretPos.X < Length(Text)) then
  begin
    NewTexti := Text;

    UTF8Delete(NewTexti, FCarets.CaretPos.X, 1);

    if (FCarets.CaretPos.X > Length(Text)) then
    Dec(FCarets.CaretPos.X);

    Text := NewTexti;
  end;
end;


function TONURCustomEdit.getcurrentline: string;
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y >= FLines.Count) then
    Result := ''
  else
    Result := FLines.Strings[FCarets.CaretPos.Y];
end;

procedure TONURCustomEdit.setcurrentline(astr: string);
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y >= FLines.Count) then
  begin
    FLines.Text := AStr;
   { FVisibleTextStart.X := 1;
    FVisibleTextStart.Y := 0;}
    FCarets.CaretPos.X := 0;
    FCarets.CaretPos.Y := 0;
  end
  else
    FLines.Strings[FCarets.CaretPos.Y] := AStr;

  DoChange();
end;







{ TonUREdit }



constructor TONUREdit.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 skinname              := 'edit';

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
  resim.SetSize(Width, Height);
  fback              := TBGRABitmap.Create(Width,Height);
  fhback             := TBGRABitmap.create(Width,Height);
  Captionvisible     := False;
  fState             := obsnormal;
end;

destructor TONUREdit.Destroy;
var
  i: byte;
begin

  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;

  Customcroplist.Clear;
  FreeAndNil(fback);
  FreeAndNil(fhback);
  inherited Destroy;
end;

procedure TONUREdit.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONUREdit.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONUREdit.Resizing;
begin
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
  DrawPartnormal(FhCenter.Croprect,FhBack,Skindata.fimage, fhcenter.Targetrect, alpha);
  //SOL ÜST TOPLEFT
  DrawPartnormal(FhTopleft.Croprect, FhBack,Skindata.fimage, FhTopleft.Targetrect, alpha);
  //SAĞ ÜST TOPRIGHT
  DrawPartnormal(FhTopRight.Croprect, FhBack,Skindata.fimage, FhTopRight.Targetrect, alpha);
  //UST TOP
  DrawPartnormal(FhTop.Croprect, FhBack,Skindata.fimage,FhTop.Targetrect, alpha);
  // SOL ALT BOTTOMLEFT
  DrawPartnormal(FhBottomleft.Croprect, FhBack,Skindata.fimage,FhBottomleft.Targetrect, alpha);
  //SAĞ ALT BOTTOMRIGHT
  DrawPartnormal(FhBottomRight.Croprect, FhBack,Skindata.fimage, FhBottomRight.Targetrect, alpha);
  //ALT BOTTOM
  DrawPartnormal(FhBottom.Croprect, FhBack,Skindata.fimage, FhBottom.Targetrect, alpha);
  // SOL ORTA CENTERLEFT
  DrawPartnormal(Fhleft.Croprect, FhBack,Skindata.fimage, Fhleft.Targetrect, alpha);
  // SAĞ ORTA CENTERRIGHT
  DrawPartnormal(FhRight.Croprect, FhBack,Skindata.fimage, FhRight.Targetrect, alpha);



end;

procedure TONUREdit.paint;
//var
//  tl,tc,tr,bl,bc,br,l,r,c:Trect;
begin

  if not Visible then Exit;
  resim.SetSize(0, 0);

  resim.SetSize(self.ClientWidth, self.ClientHeight);
  resim.Fill(BGRAPixelTransparent,dmset);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

     if (fState = obshover) and (FhCenter.croprect.width>0) and (Enabled) then
     resim.PutImage(0,0,fhback,dmDrawWithTransparency)
     else
     resim.PutImage(0,0,fback,dmDrawWithTransparency)
    { begin
        tl := FhTopleft.Croprect;
        tr := FhTopRight.Croprect;
        tc := fhtop.Croprect;
        bl := FhBottomleft.Croprect;
        br := FhBottomRight.Croprect;
        bc := FhBottom.Croprect;
        l  := Fhleft.Croprect;
        r  := FhRight.Croprect;
        c  := FhCenter.Croprect;
     end else
     begin
        tl := FTopleft.Croprect;
        tr := FTopRight.Croprect;
        tc := ftop.Croprect;
        bl := FBottomleft.Croprect;
        br := FBottomRight.Croprect;
        bc := FBottom.Croprect;
        l  := Fleft.Croprect;
        r  := FRight.Croprect;
        c  := FCenter.Croprect;
     end;
    }

  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);
  end;

  inherited paint;
end;

procedure TONUREdit.MouseLeave;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if FhCenter.croprect.width<1 then exit;
  inherited MouseLeave;
  fState := obsnormal;
  Invalidate;
end;

procedure TONUREdit.MouseEnter;
begin
  if csDesigning in ComponentState then  Exit;
  if not Enabled then                    Exit;
    if FhCenter.croprect.width<1 then    Exit;
  inherited MouseEnter;
  fState:=obshover;
  Invalidate;
end;



{ TONURMemo }

procedure TONURMemo.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURMemo.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURMemo.Resizing;
begin

   FTopleft.Targetrect := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
   FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Croprect.Width,
     0, self.clientWidth, FTopRight.Croprect.Height);
   ftop.Targetrect := Rect(FTopleft.Croprect.Width, 0, self.clientWidth -
     FTopRight.Croprect.Width, FTop.Croprect.Height);
   FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,
     FBottomleft.Croprect.Width, self.ClientHeight);
   FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Croprect.Width,
     self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
   FBottom.Targetrect := Rect(FBottomleft.Croprect.Width, self.clientHeight -
     FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
   Fleft.Targetrect := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width,
     self.clientHeight - FBottomleft.Croprect.Height);
   FRight.Targetrect := Rect(self.clientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height,
     self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
   FCenter.Targetrect := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth -
     FRight.Croprect.Width, self.clientHeight - FBottom.Croprect.Height);

end;

procedure TONURMemo.MouseLeave;
begin
  if csDesigning in ComponentState then Exit;
  if not Enabled then                   Exit;
  if FhCenter.croprect.width<1 then     Exit;
  inherited MouseLeave;
  fState := obsnormal;
  Invalidate;
  end;

procedure TONURMemo.MouseEnter;
begin
  if csDesigning in ComponentState then Exit;
  if not Enabled then                   Exit;
  if FhCenter.croprect.width<1 then     Exit;
  inherited MouseEnter;
  fState:=obshover;
  Invalidate;
end;

constructor TONURMemo.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  MultiLine := True;
  Width := 150;
  Height := 150;
  skinname := 'memo';
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


  FhTop                 := TONURCUSTOMCROP.Create('HOVERTOP');
//  FhTop.cropname        := 'HOVERTOP';
  FhBottom              := TONURCUSTOMCROP.Create('HOVERBOTTOM');
//  FhBottom.cropname     := 'HOVERBOTTOM';
  FhCenter              := TONURCUSTOMCROP.Create('HOVERCENTER');
//  FhCenter.cropname     := 'HOVERCENTER';
  FhRight               := TONURCUSTOMCROP.Create('HOVERRIGHT');
//  FhRight.cropname      := 'HOVERRIGHT';
  FhTopRight            := TONURCUSTOMCROP.Create('HOVERTOPRIGHT');
//  FhTopRight.cropname   := 'HOVERTOPRIGHT';
  FhBottomRight         := TONURCUSTOMCROP.Create('HOVERBOTTOMRIGHT');
//  FhBottomRight.cropname:= 'HOVERBOTTOMRIGHT';
  Fhleft                := TONURCUSTOMCROP.Create('HOVERLEFT');
//  Fhleft.cropname       := 'HOVERLEFT';
  FhTopleft             := TONURCUSTOMCROP.Create('HOVERTOPLEFT');
//  FhTopleft.cropname    := 'HOVERTOPLEFT';
  FhBottomleft          := TONURCUSTOMCROP.Create('HOVERBOTTOMLEFT');
//  FhBottomleft.cropname := 'HOVERBOTTOMLEFT';

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


  resim.SetSize(Width, Height);
  Captionvisible := False;
  fState         := obsnormal;
end;

destructor TONURMemo.Destroy;
var
  i: byte;
begin
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;

  Customcroplist.Clear;
  inherited Destroy;
end;



procedure TONURMemo.paint;
var
  tl,tc,tr,bl,bc,br,l,r,c:Trect;
begin

  if not Visible then Exit;
  resim.SetSize(0, 0);

  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

     if (fState = obshover) and (FhCenter.croprect.width>0) and (Enabled) then
     begin
        tl := FhTopleft.Croprect;
        tr := FhTopRight.Croprect;
        tc := fhtop.Croprect;
        bl := FhBottomleft.Croprect;
        br := FhBottomRight.Croprect;
        bc := FhBottom.Croprect;
        l  := Fhleft.Croprect;
        r  := FhRight.Croprect;
        c  := FhCenter.Croprect;
     end else
     begin
        tl := FTopleft.Croprect;
        tr := FTopRight.Croprect;
        tc := ftop.Croprect;
        bl := FBottomleft.Croprect;
        br := FBottomRight.Croprect;
        bc := FBottom.Croprect;
        l  := Fleft.Croprect;
        r  := FRight.Croprect;
        c  := FCenter.Croprect;
     end;

    //TOPLEFT   //SOLÜST
    DrawPartnormal(tl, self, FTopleft.Targetrect, alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(tr, self, FTopRight.Targetrect, alpha);
    //TOP  //ÜST
    DrawPartnormal(tc, self, ftop.Targetrect, alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(Bl, self, FBottomleft.Targetrect, alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(br, self, FBottomRight.Targetrect, alpha);
    //BOTTOM  //ALT
    DrawPartnormal(bc, self, FBottom.Targetrect, alpha);
    //CENTERLEFT // SOLORTA
    DrawPartnormal(l, self, Fleft.Targetrect, alpha);
    //CENTERRIGHT // SAĞORTA
    DrawPartnormal(r, self, FRight.Targetrect, alpha);
    //CENTER //ORTA
    DrawPartnormal(c, self, fcenter.Targetrect, alpha);


  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);
  end;
  inherited paint;
end;



{ TOnURSpinEdit }


function TONURSpinEdit.getbuttonheight: integer;
begin
  Result := Fbuttonheight;
end;

function TONURSpinEdit.getbuttonwidth: integer;
begin
  Result := Fbuttonwidth;
end;

function TONURSpinEdit.Getmax: integer;
begin
  Result := Fmax;
end;

function TONURSpinEdit.Getmin: integer;
begin
  Result := Fmin;
end;


procedure TONURSpinEdit.setbuttonheight(avalue: integer);
begin
  if Fbuttonheight <> AValue then Fbuttonheight := AValue;
end;

procedure TONURSpinEdit.setbuttonwidth(avalue: integer);
begin
  if Fbuttonwidth <> AValue then Fbuttonwidth := AValue;
end;

procedure TONURSpinEdit.Setmax(AValue: integer);
begin
  if Fmax <> AValue then Fmax := AValue;
end;

procedure TONURSpinEdit.Setmin(AValue: integer);
begin
  if Fmin <> AValue then Fmin := AValue;
end;

procedure TONURSpinEdit.SetText(AValue: string);
begin
  inherited SetText(Avalue);
  fvalue := StrToIntDef(Avalue, 0);
end;



procedure TONURSpinEdit.KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  fvalue := StrToInt(Text);
  if Key = VK_UP then
    Inc(fvalue)
  else
  if Key = VK_DOWN then
    Dec(fvalue);
  if (key = VK_UP) or (key = VK_DOWN) then
    Text := IntToStr(fvalue);
end;


procedure TONURSpinEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  fvalue := StrToIntDef(Text, 0);
  if Button = mbLeft then
  begin
    if (PtInRect(Fubuttonarea, point(x, y))) then
    begin
      Inc(fvalue);
      Fustate := obspressed;
      Fdstate := obsnormal;
    end
    else
    begin
      if (PtInRect(Fdbuttonarea, point(x, y))) then
      begin
        Dec(fvalue);
        Fustate := obsnormal;
        Fdstate := obspressed;
      end
      else
      begin
        Fustate := obsnormal;
        Fdstate := obsnormal;
      end;
    end;
    Text := IntToStr(fvalue);
    Invalidate;
  end;
end;

procedure TONURSpinEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fustate := obsnormal;
  Fdstate := obsnormal;
  Invalidate;
end;

procedure TONURSpinEdit.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then  Exit;
  if (PtInRect(Fubuttonarea, point(X, Y))) then
  begin
    Cursor := crDefault;
    Fustate := obshover;
    Fdstate := obsnormal;
  end
  else
  begin
    if (PtInRect(Fdbuttonarea, point(X, Y))) then
    begin
      Cursor := crDefault;
      Fustate := obsnormal;
      Fdstate := obshover;
    end
    else
    begin
      Cursor := crIBeam;
      Fustate := obsnormal;
      Fdstate := obsnormal;
    end;
  end;
  Invalidate;
end;

procedure TONURSpinEdit.MouseEnter;
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
  if PtInRect(Fubuttonarea, aPnt) then
  begin
    Cursor := crDefault;
    Fustate := obshover;
    Fdstate := obsnormal;
  end
  else
  begin
    if PtInRect(Fdbuttonarea, aPnt) then
    begin
      Cursor := crDefault;
      Fustate := obsnormal;
      Fdstate := obshover;
    end
    else
    begin
      Cursor := criBeam;
      Fustate := obsnormal;
      Fdstate := obsnormal;
    end;

  end;
  if FhCenter.croprect.width<1 then     Exit;
  fState:=obshover;

  Invalidate;
end;

procedure TONURSpinEdit.MouseLeave;
begin
  if csDesigning in ComponentState then Exit;
  if not Enabled then                   Exit;
  inherited MouseLeave;
  Fustate := obsnormal;
  Fdstate := obsnormal;
  if FhCenter.croprect.width<1 then     Exit;
  fState  := obsnormal;
  Invalidate;
end;




constructor TONURSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'spinedit';
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


  FhTop                 := TONURCUSTOMCROP.Create('HOVERTOP');
//  FhTop.cropname        := 'HOVERTOP';
  FhBottom              := TONURCUSTOMCROP.Create('HOVERBOTTOM');
//  FhBottom.cropname     := 'HOVERBOTTOM';
  FhCenter              := TONURCUSTOMCROP.Create('HOVERCENTER');
//  FhCenter.cropname     := 'HOVERCENTER';
  FhRight               := TONURCUSTOMCROP.Create('HOVERRIGHT');
//  FhRight.cropname      := 'HOVERRIGHT';
  FhTopRight            := TONURCUSTOMCROP.Create('HOVERTOPRIGHT');
//  FhTopRight.cropname   := 'HOVERTOPRIGHT';
  FhBottomRight         := TONURCUSTOMCROP.Create('HOVERBOTTOMRIGHT');
//  FhBottomRight.cropname:= 'HOVERBOTTOMRIGHT';
  Fhleft                := TONURCUSTOMCROP.Create('HOVERLEFT');
//  Fhleft.cropname       := 'HOVERLEFT';
  FhTopleft             := TONURCUSTOMCROP.Create('HOVERTOPLEFT');
//  FhTopleft.cropname    := 'HOVERTOPLEFT';
  FhBottomleft          := TONURCUSTOMCROP.Create('HOVERBOTTOMLEFT');
//  FhBottomleft.cropname := 'HOVERBOTTOMLEFT';

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


  Self.Height     := 25;
  Self.Width      := 100;
  Captionvisible  := False;
  fState          := obsnormal;
//  Text            := '';
  Text            := '0';
//  Caption         := '0';
  NumberOnly      := True;
  Fbuttonwidth    := 11;
  Fbuttonheight   := 11;
  fmin            := 0;
  fmax            := 0;
  fvalue          := 0;
  resim.SetSize(Width, Height);


  // up button
  FuNormal            := TONURCUSTOMCROP.Create('UPBUTONNORMAL');
//  FuNormal.cropname   := 'UPBUTONNORMAL';
  FuPress             := TONURCUSTOMCROP.Create('UPBUTONPRESS');
//  FuPress.cropname    := 'UPBUTONPRESS';
  FuEnter             := TONURCUSTOMCROP.Create('UPBUTONHOVER');
//  FuEnter.cropname    := 'UPBUTONHOVER';
  Fudisable           := TONURCUSTOMCROP.Create('UPBUTONDISABLE');
//  Fudisable.cropname  := 'UPBUTONDISABLE';
  Fustate             := obsNormal;

  // Down button
  FdNormal            := TONURCUSTOMCROP.Create('DOWNBUTONNORMAL');
//  FdNormal.cropname   := 'DOWNBUTONNORMAL';
  FdPress             := TONURCUSTOMCROP.Create('DOWNBUTONPRESS');
//  FdPress.cropname    := 'DOWNBUTONPRESS';
  FdEnter             := TONURCUSTOMCROP.Create('DOWNBUTONHOVER');
//  FdEnter.cropname    := 'DOWNBUTONHOVER';
  Fddisable           := TONURCUSTOMCROP.Create('DOWNBUTONDISABLE');
//  Fddisable.cropname  := 'DOWNBUTONDISABLE';
  Fdstate             := obsNormal;

  Customcroplist.Add(FuNormal);
  Customcroplist.Add(FuEnter);
  Customcroplist.Add(FuPress);
  Customcroplist.Add(Fudisable);
  Customcroplist.Add(FdNormal);
  Customcroplist.Add(FdEnter);
  Customcroplist.Add(FdPress);
  Customcroplist.Add(Fddisable);


  Fubuttonarea := Rect(Self.ClientWidth - self.ClientHeight div 2, 0, self.ClientWidth, self.ClientHeight div 2);
  Fdbuttonarea := Rect(Self.ClientWidth - self.ClientHeight div 2, self.ClientHeight div
    2, self.ClientWidth, self.ClientHeight);


end;

destructor TONURSpinEdit.Destroy;
var
  i: byte;
begin
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;

  Customcroplist.Clear;

  inherited Destroy;
end;

procedure TONURSpinEdit.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURSpinEdit.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURSpinEdit.Resizing;
begin
    Fubuttonarea := Rect(Self.ClientWidth - self.ClientHeight div 2,
    0, self.ClientWidth, self.ClientHeight div 2);
  Fdbuttonarea := Rect(Self.ClientWidth - self.ClientHeight div 2,
    self.ClientHeight div 2, self.ClientWidth, self.ClientHeight);
  FTopleft.Targetrect := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Croprect.Width + Fubuttonarea.Width,
    0, self.clientWidth - Fubuttonarea.Width, FTopRight.Croprect.Height);
  ftop.Targetrect := Rect(FTopleft.Croprect.Width, 0, self.clientWidth -
    FTopRight.Croprect.Width + Fubuttonarea.Width, FTop.Croprect.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height,
    FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth -
    FBottomRight.Croprect.Width + Fubuttonarea.Width, self.clientHeight -
    FBottomRight.Croprect.Height, self.clientWidth - Fubuttonarea.Width, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.Croprect.Width, self.clientHeight -
    FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width + Fubuttonarea.Width,
    self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width,
    self.clientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect := Rect(self.clientWidth -
    FRight.Croprect.Width + Fubuttonarea.Width, FTopRight.Croprect.Height, self.clientWidth - Fubuttonarea.Width,
    self.clientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth -
    FRight.Croprect.Width + Fubuttonarea.Width, self.clientHeight - FBottom.Croprect.Height);

end;



procedure TONURSpinEdit.Paint;
var
  TrgtRect, SrcRect: TRect;
  tl,tc,tr,bl,bc,br,l,r,c:Trect;
begin

  if not Visible then Exit;
  resim.SetSize(0, 0);

  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Value = 0 then
    begin
      Text := '0';
     // Caption := '0';
    end;


     if (fState = obshover) and (FhCenter.croprect.width>0) and (Enabled) then
     begin
        tl := FhTopleft.Croprect;
        tr := FhTopRight.Croprect;
        tc := fhtop.Croprect;
        bl := FhBottomleft.Croprect;
        br := FhBottomRight.Croprect;
        bc := FhBottom.Croprect;
        l  := Fhleft.Croprect;
        r  := FhRight.Croprect;
        c  := FhCenter.Croprect;
     end else
     begin
        tl := FTopleft.Croprect;
        tr := FTopRight.Croprect;
        tc := ftop.Croprect;
        bl := FBottomleft.Croprect;
        br := FBottomRight.Croprect;
        bc := FBottom.Croprect;
        l  := Fleft.Croprect;
        r  := FRight.Croprect;
        c  := FCenter.Croprect;
     end;

    //TOPLEFT   //SOLÜST
    DrawPartnormal(tl, self, FTopleft.Targetrect, alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(tr, self, FTopRight.Targetrect, alpha);
    //TOP  //ÜST
    DrawPartnormal(tc, self, ftop.Targetrect, alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(Bl, self, FBottomleft.Targetrect, alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(br, self, FBottomRight.Targetrect, alpha);
    //BOTTOM  //ALT
    DrawPartnormal(bc, self, FBottom.Targetrect, alpha);
    //CENTERLEFT // SOLORTA
    DrawPartnormal(l, self, Fleft.Targetrect, alpha);
    //CENTERRIGHT // SAĞORTA
    DrawPartnormal(r, self, FRight.Targetrect, alpha);
    //CENTER //ORTA
    DrawPartnormal(c, self, fcenter.Targetrect, alpha);


    if Enabled = False then
    begin
      SrcRect  := Fudisable.Croprect;
      TrgtRect := Fddisable.Croprect;
    end
    else
    begin
      case Fustate of
        obsnormal  : SrcRect  := FuNormal.Croprect;
        obshover   : SrcRect  := FuEnter.Croprect;
        obspressed : SrcRect  := FuPress.Croprect;
      end;
      case Fdstate of
        obsnormal  : TrgtRect := FdNormal.Croprect;
        obshover   : TrgtRect := FdEnter.Croprect;
        obspressed : TrgtRect := FdPress.Croprect;
      end;
      DrawPartnormal(SrcRect, self, Fubuttonarea, alpha);
      DrawPartnormal(TrgtRect, self, Fdbuttonarea, alpha);

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);
  end;

  inherited paint;
end;

end.

unit onuredit;

{$mode objfpc}{$H+}


interface

uses
  LCLType,{$IFDEF UNIX} linux {$ELSE} Windows{$ENDIF}, SysUtils, LMessages, Forms ,Classes, StdCtrls,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes, Dialogs,onurctrl,Types;

 type
  TONURCustomEdit = class;

  { Toncaret }

  Toncaret = class(TONURPersistent)
  private
    parent: TONURCustomEdit;
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
    property Visible    : boolean read Getvisible   write Setvisible;
    property Blinktime  : integer read Getblinktime write Setblinktime;
    property Height     : integer read FHeight      write FHeight;
    property Width      : integer read FWidth       write FWidth;
    property Color      : Tcolor  read fblinkcolor  write fblinkcolor;
  end;

  ToCharCase = (ecNormal, ecUppercase, ecLowerCase);
  TOEchoMode = (emNormal, emNone, emPassword);


  { TONURCustomEdit }

  TONURCustomEdit = class(TONURCustomControl)
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


  { TONUREdit }

  TONUREdit = class(TONURCustomEdit)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;

    property OLEFT        : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP read FTopRight    write FTopRight;
  protected
  published
    property Alpha;
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

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;

    property OLEFT        : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP read FTopRight    write FTopRight;
  protected
     procedure SetSkindata(Aimg: TONURImg); override;
  published
    property Alpha;
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



  { TONURSpinEdit }

  TONURSpinEdit = class(TONURCustomEdit)
  private
    //   Fedit          : TONUREdit;
    //Fonchange      : TNotifyEvent;
    // fReadOnly      : Boolean;
    fvalue                  : integer;
    fmin, Fmax              : integer;
    Fbuttonwidth            : integer;
    Fbuttonheight           : integer;
    Fubuttonarea            : Trect;
    Fdbuttonarea            : Trect;
    FuNormal, FuPress       : TONURCUSTOMCROP;
    FuEnter, Fudisable      : TONURCUSTOMCROP;   // up button picture
    FdNormal, FdPress       : TONURCUSTOMCROP;
    FdEnter, Fddisable      : TONURCUSTOMCROP;   // down button state
    Fustate, Fdstate        : TONURButtonState; // up buttonstate, down buttonstate
    Fleft, FTopleft         : TONURCUSTOMCROP;
    FBottomleft, FRight     : TONURCUSTOMCROP;
    FTopRight, FBottomRight : TONURCUSTOMCROP;
    FTop, FBottom, FCenter  : TONURCUSTOMCROP;
    //   procedure feditchange(sender: tobject);   protected
    function getbuttonheight: integer;
    function getbuttonwidth: integer;
    function Getmax: integer;
    function Getmin: integer;
    //   function Gettext: integer;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure setbuttonheight(avalue: integer);
    procedure setbuttonwidth(avalue: integer);
    procedure Setmax(AValue: integer);
    procedure Setmin(AValue: integer);

    procedure KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    //   procedure Resize;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure CMonmouseenter(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF}); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF}); message CM_MOUSELEAVE;
    procedure SetText(AValue: string); override;
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    property OLEFT             : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT            : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER           : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM           : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT       : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT      : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP              : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT          : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT         : TONURCUSTOMCROP read FTopRight    write FTopRight;
    property OUPBUTONNORMAL    : TONURCUSTOMCROP read FuNormal     write FuNormal;
    property OUPBUTONPRESS     : TONURCUSTOMCROP read FuPress      write FuPress;
    property OUPBUTONHOVER     : TONURCUSTOMCROP read FuEnter      write FuEnter;
    property OUPBUTONDISABLE   : TONURCUSTOMCROP read Fudisable    write Fudisable;
    property ODOWNBUTONNORMAL  : TONURCUSTOMCROP read FdNormal     write FdNormal;
    property ODOWNBUTONPRESS   : TONURCUSTOMCROP read FdPress      write FdPress;
    property ODOWNBUTONHOVER   : TONURCUSTOMCROP read FdEnter      write FdEnter;
    property ODOWNBUTONDISABLE : TONURCUSTOMCROP read Fddisable    write Fddisable;
  protected
  published
    property Alpha;
    property Value              : integer       read fvalue        write fvalue;
    property MaxValue           : integer       read fmin          write Setmin;
    property MinValue           : integer       read Fmax          write Setmax;
    property Buttonwidth        : integer       read Fbuttonwidth  write setbuttonwidth;
    property Buttonheight       : integer       read Fbuttonheight write setbuttonheight;
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



procedure Register;



implementation

uses  BGRAPath,LazUTF8,onurlist,Clipbrd,StrUtils {$IFDEF UNIX}, Math{$ENDIF};

procedure Register;
begin
  RegisterComponents('ONUR', [TONUREdit,TONURMemo,TONURSpinEdit]);
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
  if parent is TONURCustomEdit then
    TONURCustomEdit(parent).Invalidate;
  Result := True;
end;

constructor toncaret.Create(aowner: TPersistent);
begin
  inherited Create;
  parent := TONURCustomEdit(aowner);
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




{ TONURCustomEdit }

function VisibleText(const aVisibleText: TCaption; const APasswordChar: char): TCaption;
begin
  if aPasswordChar = #0 then
    Result := aVisibleText
  else
    Result := StringOfChar(aPasswordChar, UTF8Length(aVisibleText));

end;

procedure TONURCustomEdit.LinesChanged(Sender: TObject);
begin
  Invalidate;
end;

constructor TONURCustomEdit.Create(aowner: TComponent);
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
  resim.SetSize(Width, Height);
  Captionvisible := False;
  if self is TONURMemo then
  begin
    MultiLine := True;
    TStringList(FLines).OnChange := @LinesChanged;
  end;

end;

destructor TONURCustomEdit.Destroy;
begin
  FreeAndNil(FLines);
  FreeAndNil(FCarets);
  inherited Destroy;
end;


procedure TONURCustomEdit.paint;
var
  //  gradienrect1, gradienrect2, Selrect,
  caretrect: Trect;
  //  textx, Texty, i, a: integer;
  lControlText, lTmpText: string;
  lCaretPixelPos: integer;
  lTextBottomSpacing, lTextTopSpacing, lCaptionHeight, lLineHeight, lLineTop: integer;
  lSize: TSize;
begin

  if csDesigning in ComponentState then
   Exit;
  if not Visible then Exit;

  if self is TONURSpinEdit then
  begin
    lTextTopSpacing := TONURSpinEdit(self).OTOP.Height{fsBottom - TONURSpinEdit(self).OTOP.fsTop};
    lTextBottomSpacing := TONURSpinEdit(self).OBOTTOM.Height; //fsBottom - TONURSpinEdit(self).OBOTTOM.fsTop; // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);

  end
  else
  if self is TONUREdit then
  begin
    lTextTopSpacing := TONUREdit(self).OTOP.Height;//fsBottom - TONUREdit(self).OTOP.fsTop;
    //3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);
    lTextBottomSpacing := TONUREdit(self).OBOTTOM.Height;//fsBottom - TONUREdit(self).OBOTTOM.fsTop;
    // 3;//GetMeasures(TCDEDIT_BOTTOM_TEXT_SPACING);
  end
  else
  if self is TONURMemo then
  begin
    lTextTopSpacing := TONURMemo(self).OTOP.Height;//fsBottom - TONURMemo(self).OTOP.fsTop;
    lTextBottomSpacing := TONURMemo(self).OBOTTOM.Height;//fsBottom - TONURMemo(self).OBOTTOM.fsTop;
  end
  else
  if self is TONURComboBox then
  begin
    lTextTopSpacing := TONURComboBox(self).OTOP.Height;//fsBottom - TONURComboBox(self).OTOP.fsTop;
    lTextBottomSpacing := TONURComboBox(self).OBOTTOM.Height;//fsBottom -  TONURComboBox(self).OBOTTOM.fsTop;
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

  if Text = '' then
  begin
    if self is TONURSpinEdit then
      lCaretPixelPos := TONURSpinEdit(self).OLEFT.Width{ fsRight -
        TONURSpinEdit(self).OLEFT.fsLeft) }+ fLeftTextMargin
    else
    if self is TONUREdit then
      lCaretPixelPos := TONUREdit(self).OLEFT.Width{fsRight - TONUREdit(self).OLEFT.fsLeft)} +
        fLeftTextMargin
    else
    if self is TONURMemo then
      lCaretPixelPos := TONURMemo(self).OLEFT.Width{fsRight - TONURMemo(self).OLEFT.fsLeft)} +
        fLeftTextMargin
    else
    if self is TONURComboBox then
      lCaretPixelPos := TONURComboBox(self).OLEFT.Width{ fsRight -
        TONURComboBox(self).OLEFT.fsLeft) }+ fLeftTextMargin;


    //  lCaretPixelPos := (Fleft.FSright - Fleft.FSLeft) + fLeftTextMargin;
    lCaptionHeight := lLineHeight;// self.canvas.TextHeight('ŹÇ');
  end
  else
  begin
    lCaptionHeight := self.canvas.TextHeight(self.Text);

    if self is TONURSpinEdit then
      lCaretPixelPos := TONURSpinEdit(self).OLEFT.Width{fsRight -
        TONURSpinEdit(self).OLEFT.fsLeft)} + (self.canvas.TextWidth(lTmpText) + fLeftTextMargin)
    else
    if self is TONUREdit then
      lCaretPixelPos := TONUREdit(self).OLEFT.Width{fsRight - TONUREdit(self).OLEFT.fsLeft)} +
        (self.canvas.TextWidth(lTmpText) + fLeftTextMargin)
    else
    if self is TONURMemo then
      lCaretPixelPos := TONURMemo(self).OLEFT.Width{fsRight - TONURMemo(self).OLEFT.fsLeft)} +
        (self.canvas.TextWidth(lTmpText) + fLeftTextMargin)
    else
    if self is TONURComboBox then
      lCaretPixelPos := TONURComboBox(self).OLEFT.Width{fsRight -
        TONURComboBox(self).OLEFT.fsLeft)} + (self.canvas.TextWidth(lTmpText) + fLeftTextMargin);

    // lCaretPixelPos := self.canvas.TextWidth(lTmpText) + (Fleft.FSright - Fleft.FSLeft) + fLeftTextMargin;
  end;


  inherited Paint;
  DrawText;
  caretrect := Rect(lCaretPixelPos, lLineTop, lCaretPixelPos +
    FCarets.Width, lLineTop + lCaptionHeight);

  if Fcarets.Caretvisible then
  begin
    canvas.Brush.Color := FCarets.Color;     //color or image
    canvas.FillRect(caretrect);
  end;

end;



procedure tonURcustomedit.drawtext;
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

  if self is TONURSpinEdit then
  begin
    lTextLeftSpacing   := TONURSpinEdit(self).OLEFT.Width;//OLEFT.fsRight -  TONURSpinEdit(self).OLEFT.fsLeft;
    lTextRightSpacing  := TONURSpinEdit(self).ORIGHT.Width;//ORIGHT.fsRight - TONURSpinEdit(self).ORIGHT.fsLeft);
    lTextTopSpacing    := TONURSpinEdit(self).OTOP.Height;//OTOP.fsBottom - TONURSpinEdit(self).OTOP.fsTop;
    lTextBottomSpacing := TONURSpinEdit(self).OBOTTOM.Height; //OBOTTOM.fsBottom - TONURSpinEdit(self).OBOTTOM.fsTop;
  end
  else
  if self is TONUREdit then
  begin
    lTextLeftSpacing   := TONUREdit(self).OLEFT.Width;//OLEFT.fsRight - TONUREdit(self).OLEFT.fsLeft;
    lTextRightSpacing  := TONUREdit(self).ORIGHT.Width;//ORIGHT.fsRight - TONUREdit(self).ORIGHT.fsLeft;
    lTextTopSpacing    := TONUREdit(self).OTOP.Height;//OTOP.fsBottom - TONUREdit(self).OTOP.fsTop;
    lTextBottomSpacing := TONUREdit(self).OBOTTOM.Height;//OBOTTOM.fsBottom - TONUREdit(self).ONBOTTOM.fsTop;

  end
  else
  if self is TONURMemo then
  begin
    lTextLeftSpacing   := TONURMemo(self).OLEFT.Width;//OLEFT.fsRight - TONURMemo(self).ONLEFT.fsLeft;
    lTextRightSpacing  := TONURMemo(self).ORIGHT.Width;//ORIGHT.fsRight - TONURMemo(self).ONRIGHT.fsLeft;
    lTextTopSpacing    := TONURMemo(self).OTOP.Height;//OTOP.fsBottom - TONURMemo(self).ONTOP.fsTop;
    lTextBottomSpacing := TONURMemo(self).OBOTTOM.Height; //OBOTTOM.fsBottom - TONURMemo(self).ONBOTTOM.fsTop;
  end
  else
  if self is TONURcombobox then
  begin
    lTextLeftSpacing   := TONURComboBox(self).OLEFT.Width;//OLEFT.fsRight - TONcombobox(self).ONLEFT.fsLeft;
    lTextRightSpacing  := TONURcombobox(self).ORIGHT.Width;//ONRIGHT.fsRight - TONcombobox(self).ONRIGHT.fsLeft;
    lTextTopSpacing    := TONURcombobox(self).OTOP.Height; //ONTOP.fsBottom - TONcombobox(self).ONTOP.fsTop;
    lTextBottomSpacing := TONURcombobox(self).OBOTTOM.Height; //ONBOTTOM.fsBottom -  TONcombobox(self).ONBOTTOM.fsTop;
  end;




  lLineHeight := self.Canvas.TextHeight('ŹÇ');
  //if self is TONURMemo  then

  lLineHeight := Min(ASize.cy - lTextBottomSpacing, lLineHeight);
  //else
  //lLineHeight := Height-(lTextBottomSpacing+lTextTopSpacing);

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


function tonURcustomedit.getcharcase: tocharcase;
begin
  Result := FCharCase;
end;

function tonURcustomedit.getechomode: toechomode;
begin
  Result := fEchoMode;
end;

procedure tonURcustomedit.setechomode(const Value: toechomode);
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

procedure tonURcustomedit.setcharcase(const Value: tocharcase);
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    Invalidate;
  end;
end;

procedure tonURcustomedit.setlefttextmargin(avalue: integer);
begin
  if FLeftTextMargin = AValue then Exit;
  FLeftTextMargin := AValue;
  Invalidate;
end;

procedure tonURcustomedit.setlines(avalue: TStrings);
begin
  if FLines = AValue then Exit;
  FLines.Assign(AValue);
  DoChange();
  //  paint;
  Invalidate;
end;

procedure tonURcustomedit.setmultiline(avalue: boolean);
begin
  if FMultiLine = AValue then Exit;
  FMultiLine := AValue;
  Invalidate;
end;

procedure tonURcustomedit.setnumberonly(const Value: boolean);
begin
  if FNumbersOnly <> Value then FNumbersOnly := Value;
end;

procedure tonURcustomedit.setreadonly(avalue: boolean);
begin
  if FReadOnly <> avalue then FReadOnly := avalue;
end;

procedure tonURcustomedit.setrighttextmargin(avalue: integer);
begin
  if FRightTextMargin = AValue then Exit;
  FRightTextMargin := AValue;
  Invalidate;
end;

procedure tonURcustomedit.settext(avalue: string);
begin
  Lines.Text := aValue;
end;

procedure tonURcustomedit.setpasswordchar(avalue: char);
begin
  if AValue = FPasswordChar then Exit;
  FPasswordChar := AValue;
  Invalidate;
end;


procedure tonURcustomedit.realsettext(const Value: tcaption);
begin
  inherited RealSetText(Value);
  Lines.Text := Value;
  Invalidate;
end;

procedure tonURcustomedit.dochange;
begin
  Changed;
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;



function tonURcustomedit.getlefttextmargin: integer;
begin
  Result := FLeftTextMargin;
end;

function tonURcustomedit.getcaretpos: tpoint;
begin
  Result := FCarets.CaretPos;//FEditState.CaretPos;
end;

function tonURcustomedit.getmultiline: boolean;
begin
  Result := FMultiLine;
end;

function tonURcustomedit.getreadonly: boolean;
begin
  Result := FReadOnly;
end;

function tonURcustomedit.getnumberonly: boolean;
begin
  Result := FNumbersOnly;
end;

function tonURcustomedit.getrighttextmargin: integer;
begin
  Result := FRightTextMargin;
end;

function tonURcustomedit.gettext: string;
begin
  if Multiline then
    Result := Lines.Text
  else if Lines.Count = 0 then
    Result := ''
  else
    Result := Lines[0];
end;

function tonURcustomedit.getpasswordchar: char;
begin
  Result := FPasswordChar;
end;

procedure tonURcustomedit.dodeleteselection;
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

procedure tonURcustomedit.doclearselection;
begin
  FSelStart.X := 1;
  FSelStart.Y := 0;
  FSelLength := 0;
end;

// Imposes sanity limits to the visible text start
// and also imposes sanity limits on the caret
procedure tonURcustomedit.domanagevisibletextstart;
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
  if self is TOnURSpinEdit then
    lAvailableWidth := self.Width -
      ((TOnURSpinEdit(self).OLEFT.Width)+//fsRight - TOnURSpinEdit(self).OLEFT.fsLeft)
       (TOnURSpinEdit(self).ORIGHT.Width)+// fsRight - TOnURSpinEdit(self).ORIGHT.fsLeft) +
      (TOnURSpinEdit(self).Fdbuttonarea.Width))
  else
  if self is TonUREdit then
    lAvailableWidth := self.Width -
      ((TonUREdit(self).OLEFT.Width)+// fsRight - TONUREdit(self).OLEFT.fsLeft) +
      (TonUREdit(self).ORIGHT.Width))//fsRight - TONUREdit(self).ORIGHT.fsLeft))
  else
  if self is TONURMemo then
    lAvailableWidth := self.Width -
      ((TONURMemo(self).OLEFT.Width)+//fsRight - TONURMemo(self).OLEFT.fsLeft) +
      (TONURMemo(self).ORIGHT.Width))//fsRight - TONURMemo(self).ORIGHT.fsLeft))
  else
  if self is TONURcombobox then
    lAvailableWidth := self.Width -
      ((TONURcombobox(self).OLEFT.Width)+//fsRight - TONURcombobox(self).OLEFT.fsLeft) +
      (TONURcombobox(self).ORIGHT.Width)+//fsRight - TONURcombobox(self).ORIGHT.fsLeft) +
      (TONURcombobox(self).fbutonarea.Width));



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

procedure tonURcustomedit.setcaretpost(avalue: tpoint);
begin
  // FCaretPos.X
  FCarets.CaretPos.X := AValue.X;
  // FCaretPos.Y
  FCarets.CaretPos.Y := AValue.Y;
  Invalidate;
end;


// Result.X -> returns a zero-based position of the caret
function tonURcustomedit.mousepostocaretpos(x, y: integer): tpoint;
var
  lStrLen, i: PtrInt;
  lVisibleStr, lCurChar: string;
  lPos, lCurCharLen: integer;
  lBestDiff: cardinal = $FFFFFFFF;
  lLastDiff: cardinal = $FFFFFFFF;
  lCurDiff, lBestMatch: integer;
begin
  // Find the best Y position
  // lPos := Y - 3;//GetMeasures(TCDEDIT_TOP_TEXT_SPACING);

  if self is TOnURSpinEdit then
    lPos := Y - TOnURSpinEdit(self).OLEFT.Width//fsRight - TOnURSpinEdit(self).OLEFT.fsLeft)
  else
  if self is TonUREdit then
    lPos := Y - TonUREdit(self).OLEFT.Width//fsRight - TonUREdit(self).OLEFT.fsLeft)
  else
  if self is TONURMemo then
    lPos := Y - TONURMemo(self).OLEFT.Width//fsRight - TONURMemo(self).OLEFT.fsLeft)
  else
  if self is TONURcombobox then
    lPos := Y - TONURcombobox(self).OLEFT.Width;//fsRight - TONURcombobox(self).OLEFT.fsLeft);




  if FLineHeight < 1 then FLineHeight := 1;

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
  if self is TOnURSpinEdit then
    lPos := TOnURSpinEdit(self).OLEFT.Width//fsRight - TOnURSpinEdit(self).OLEFT.fsLeft)
  else
  if self is TonUREdit then
    lPos := TonUREdit(self).OLEFT.Width//fsRight - TonUREdit(self).OLEFT.fsLeft)
  else
  if self is TONURMemo then
    lPos := TONURMemo(self).OLEFT.Width//fsRight - TONURMemo(self).OLEFT.fsLeft)
  else
  if self is TONURcombobox then
    lPos := TONURcombobox(self).OLEFT.Width;//fsRight - TONURcombobox(self).OLEFT.fsLeft);



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

function tonURcustomedit.issomethingselected: boolean;
begin
  Result := FSelLength <> 0;
end;



procedure tonURcustomedit.doenter;
begin
  //  FCaretTimer.Enabled := True;
  FCarets.Visible := True;
  //FCaretIsVisible := True;
  inherited DoEnter;
end;

procedure tonURcustomedit.doexit;
begin
  //  FCaretTimer.Enabled := False;
  FCarets.Visible := False;
  // FCaretIsVisible := False;
  DoClearSelection();
  inherited DoExit;
end;

procedure tonURcustomedit.keydown(var key: word; shift: tshiftstate);
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
      end
      else
      if FCarets.CaretPos.y > 0 then
      begin
        Lines.Delete(FCarets.CaretPos.Y);
        Dec(FCarets.CaretPos.Y);
        lOldText := GetCurrentLine();
        lOldTextLength := UTF8Length(lOldText);

        //  lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X - 1);
        //  lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X + 1,  lOldTextLength);
        //  SetCurrentLine(lLeftText + lRightText);
        //  FCarets.CaretPos.X := lOldTextLength;

        FCarets.CaretPos.X := lOldTextLength;
        DoManageVisibleTextStart();

        Invalidate;
      end;
    end;
    //yapıalcak if FCarets.CaretPos.Y < FLines.Count - 1 then
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
      end;// else
      if FCarets.CaretPos.y > 0 then
      begin
        if FCarets.CaretPos.X = 0 then
          Lines.Delete(FCarets.CaretPos.Y);
        // Dec(FCarets.CaretPos.Y);
        lOldText := GetCurrentLine();
        lOldTextLength := UTF8Length(lOldText);

        if FCarets.CaretPos.X <= lOldTextLength then
        begin
          lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X);
          lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X + 2, lOldTextLength);
          SetCurrentLine(lLeftText + lRightText);

        end;
        // ShowMessage(inttostr(FCarets.CaretPos.X)+' '+inttostr(lOldTextLength));
        //  lLeftText := UTF8Copy(lOldText, 1, FCarets.CaretPos.X - 1);
        //  lRightText := UTF8Copy(lOldText, FCarets.CaretPos.X + 1,  lOldTextLength);
        //  SetCurrentLine(lLeftText + lRightText);
        //  FCarets.CaretPos.X := lOldTextLength;

        //  FCarets.CaretPos.X:=lOldTextLength;
        //  DoManageVisibleTextStart();

        //  Invalidate;
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

procedure tonURcustomedit.keyup(var key: word; shift: tshiftstate);
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
        lRightText := UTF8Copy(lOldText, fselstart.x + 1 + fSelLength, UTF8Length(lOldText));
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

procedure tonURcustomedit.utf8keypress(var utf8key: tutf8char);
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

procedure tonURcustomedit.mousedown(button: tmousebutton; shift: tshiftstate;
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

procedure tonURcustomedit.mousemove(shift: tshiftstate; x, y: integer);
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

procedure tonURcustomedit.mouseup(button: tmousebutton; shift: tshiftstate;
  x, y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  DragDropStarted := False;
end;

procedure tonURcustomedit.mouseenter;
begin
  inherited MouseEnter;
end;

procedure tonURcustomedit.mouseleave;
begin
  inherited MouseLeave;
end;

procedure tonURcustomedit.wmsetfocus(var message: tlmsetfocus);
begin
  DoEnter;
end;

procedure tonURcustomedit.wmkillfocus(var message: tlmkillfocus);
begin
  DoExit;
end;


function tonURcustomedit.getcurrentline: string;
begin
  if (FLines.Count = 0) or (FCarets.CaretPos.Y{FCaretPos.Y} >= FLines.Count) then
    Result := ''
  else
    Result := FLines.Strings[FCarets.CaretPos.Y{FCaretPos.Y}];
end;

procedure tonURcustomedit.setcurrentline(astr: string);
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

function tonURcustomedit.getselstartx: integer;
begin
  Result := FSelStart.X;
end;

function tonURcustomedit.getsellength: integer;
begin
  Result := FSelLength;
  if Result < 0 then Result := Result * -1;
end;

procedure tonURcustomedit.setselstartx(anewx: integer);
begin
  FSelStart.X := ANewX;
end;

procedure tonURcustomedit.setsellength(anewlength: integer);
begin
  FSelLength := ANewLength;
end;

function tonURcustomedit.caretttopos(leftch: integer): integer;
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



{ TonUREdit }



constructor TonUREdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'edit';
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

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Self.Height := 30;
  Self.Width := 80;
  resim.SetSize(Width, Height);
  Captionvisible := False;

end;

destructor TonUREdit.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft); }
  inherited Destroy;
end;

procedure TonUREdit.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
{  FTopleft.Targetrect     := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft, FTopleft.FSBottom - FTopleft.FSTop);
  FTopRight.Targetrect    := Rect(self.ClientWidth - (FTopRight.FSRight - FTopRight.FSLeft), 0, self.ClientWidth, (FTopRight.FSBottom - FTopRight.FSTop));
  FTop.Targetrect         := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0,self.ClientWidth - (FTopRight.FSRight - FTopRight.FSLeft),(FTop.FSBottom - FTop.FSTop));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop),(FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - (FBottomRight.FSRight - FBottomRight.FSLeft), self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop), self.ClientWidth, self.ClientHeight);
  Fbottom.Targetrect      := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop), self.ClientWidth - (FBottomRight.FSRight - FBottomRight.FSLeft), self.ClientHeight);  ;
  Fleft.Targetrect        := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,(Fleft.FSRight - Fleft.FSLeft), self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop));
  FRight.Targetrect       := Rect(self.ClientWidth - (FRight.FSRight - FRight.FSLeft),(FTopRight.FSBottom - FTopRight.FSTop), self.ClientWidth, self.ClientHeight -(FBottomRight.FSBottom - FBottomRight.FSTop)); ;
  FCenter.Targetrect      := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop), self.ClientWidth - (FRight.FSRight - FRight.FSLeft), self.ClientHeight -(FBottom.FSBottom - FBottom.FSTop));;
 }
  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect    := Rect(self.clientWidth - FTopRight.Width, 0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect         := Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Height, FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);
  FRight.Targetrect       := Rect(self.clientWidth - FRight.Width,FTopRight.Height, self.clientWidth, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect      := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width, self.clientHeight -FBottom.Height);

end;

procedure TonUREdit.paint;
//var
//  TrgtRect, SrcRect: TRect;
begin
//  if csDesigning in ComponentState then
//    Exit;
  if not Visible then Exit;
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
      DrawPartnormal(ftop.Croprect, self, ftop.Targetrect, alpha);
      //BOTTOMLEFT // SOLALT
      DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
      //BOTTOMRIGHT  //SAĞALT
      DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
      //BOTTOM  //ALT
      DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
      //CENTERLEFT // SOLORTA
      DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
      //CENTERRIGHT // SAĞORTA
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER //ORTA
      DrawPartnormal(FCenter.Croprect, self, fcenter.Targetrect, alpha);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited paint;
end;



{ TONURMemo }

procedure TONURMemo.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
{  FTopleft.Targetrect     := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft, FTopleft.FSBottom - FTopleft.FSTop);
  FTopRight.Targetrect    := Rect(self.ClientWidth - (FTopRight.FSRight - FTopRight.FSLeft), 0, self.ClientWidth, (FTopRight.FSBottom - FTopRight.FSTop));
  FTop.Targetrect         := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0,self.ClientWidth - (FTopRight.FSRight - FTopRight.FSLeft),(FTop.FSBottom - FTop.FSTop));
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop),(FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - (FBottomRight.FSRight - FBottomRight.FSLeft), self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop), self.ClientWidth, self.ClientHeight);
  Fbottom.Targetrect      := Rect((FBottomleft.FSRight - FBottomleft.FSLeft),self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop), self.ClientWidth - (FBottomRight.FSRight - FBottomRight.FSLeft), self.ClientHeight);  ;
  Fleft.Targetrect        := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,(Fleft.FSRight - Fleft.FSLeft), self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop));
  FRight.Targetrect       := Rect(self.ClientWidth - (FRight.FSRight - FRight.FSLeft),(FTopRight.FSBottom - FTopRight.FSTop), self.ClientWidth, self.ClientHeight -(FBottomRight.FSBottom - FBottomRight.FSTop)); ;
  FCenter.Targetrect      := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop), self.ClientWidth - (FRight.FSRight - FRight.FSLeft), self.ClientHeight -(FBottom.FSBottom - FBottom.FSTop));;
}
  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect    := Rect(self.clientWidth - FTopRight.Width, 0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect         := Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Height, FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);
  FRight.Targetrect       := Rect(self.clientWidth - FRight.Width,FTopRight.Height, self.clientWidth, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect      := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width, self.clientHeight -FBottom.Height);

end;

constructor TONURMemo.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  MultiLine := True;
  Width := 150;
  Height := 150;
  skinname := 'memo';
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

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);


  resim.SetSize(Width, Height);
  Captionvisible := False;
end;

destructor TONURMemo.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft); }
  inherited Destroy;
end;



procedure TONURMemo.paint;
//var
//  TrgtRect, SrcRect: TRect;
begin
//  if csDesigning in ComponentState then
//   Exit;
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
//  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
      DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
      //TOPRIGHT //SAĞÜST
      DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
      //TOP  //ÜST
      DrawPartnormal(ftop.Croprect, self, ftop.Targetrect, alpha);
      //BOTTOMLEFT // SOLALT
      DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
      //BOTTOMRIGHT  //SAĞALT
      DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
      //BOTTOM  //ALT
      DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
      //CENTERLEFT // SOLORTA
      DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
      //CENTERRIGHT // SAĞORTA
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER //ORTA
      DrawPartnormal(FCenter.Croprect, self, fcenter.Targetrect, alpha);



  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited paint;
end;





{ TOnURSpinEdit }


function TOnURSpinEdit.getbuttonheight: integer;
begin
  Result := Fbuttonheight;
end;

function TOnURSpinEdit.getbuttonwidth: integer;
begin
  Result := Fbuttonwidth;
end;

function TOnURSpinEdit.Getmax: integer;
begin
  Result := Fmax;
end;

function TOnURSpinEdit.Getmin: integer;
begin
  Result := Fmin;
end;




procedure TOnURSpinEdit.setbuttonheight(avalue: integer);
begin
  if Fbuttonheight <> AValue then Fbuttonheight := AValue;
end;

procedure TOnURSpinEdit.setbuttonwidth(avalue: integer);
begin
  if Fbuttonwidth <> AValue then Fbuttonwidth := AValue;
end;

procedure TOnURSpinEdit.Setmax(AValue: integer);
begin
  if Fmax <> AValue then Fmax := AValue;
end;

procedure TOnURSpinEdit.Setmin(AValue: integer);
begin
  if Fmin <> AValue then Fmin := AValue;
end;

procedure TOnURSpinEdit.SetText(AValue: string);
begin
  inherited SetText(Avalue);
  fvalue := StrToIntDef(Avalue, 0);//ValueRange(fvalue,fmin,fmax);
  //  Text:=avalue;
end;



procedure TOnURSpinEdit.KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
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


procedure TOnURSpinEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
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
    //Fedit.
    Text := IntToStr(fvalue);
    Invalidate;
  end;
end;

procedure TOnURSpinEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
//  if Button = mbLeft then
//  begin
    Fustate := obsnormal;
    Fdstate := obsnormal;
    Invalidate;
//  end;
end;

procedure TOnURSpinEdit.MouseMove(Shift: TShiftState; X, Y: integer);
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

procedure TOnURSpinEdit.CMonmouseenter(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} );
var
  aPnt: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseEnter;

  {$IFDEF UNIX} aPnt:=Mouse.CursorPos; {$ELSE}

  GetCursorPos(aPnt);
  {$ENDIF}
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
  Invalidate;
end;

procedure TOnURSpinEdit.CMonmouseleave(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} );
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

constructor TOnURSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'spinedit';
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

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);  
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);





  Self.Height := 25;
  Self.Width := 100;
  resim.SetSize(Width, Height);
  Captionvisible := False;
  Text := '';
  Text := '0';
  Caption := '0';
  NumberOnly := True;

  Fbuttonwidth := 11;
  Fbuttonheight := 11;

  fmin := 0;
  fmax := 0;
  fvalue := 0;



  // up button
  FuNormal := TONURCUSTOMCROP.Create;
  FuNormal.cropname := 'UPBUTONNORMAL';
  FuPress := TONURCUSTOMCROP.Create;
  FuPress.cropname := 'UPBUTONPRESS';
  FuEnter := TONURCUSTOMCROP.Create;
  FuEnter.cropname := 'UPBUTONHOVER';
  Fudisable := TONURCUSTOMCROP.Create;
  Fudisable.cropname := 'UPBUTONDISABLE';
  Fustate := obsNormal;

  // Down button
  FdNormal := TONURCUSTOMCROP.Create;
  FdNormal.cropname := 'DOWNBUTONNORMAL';
  FdPress := TONURCUSTOMCROP.Create;
  FdPress.cropname := 'DOWNBUTONPRESS';
  FdEnter := TONURCUSTOMCROP.Create;
  FdEnter.cropname := 'DOWNBUTONHOVER';
  Fddisable := TONURCUSTOMCROP.Create;
  Fddisable.cropname := 'DOWNBUTONDISABLE';
  Fdstate := obsNormal;

  Customcroplist.Add(FuNormal); 
  Customcroplist.Add(FuEnter);
  Customcroplist.Add(FuPress);
  Customcroplist.Add(Fudisable);
  Customcroplist.Add(FdNormal); 
  Customcroplist.Add(FdEnter);
  Customcroplist.Add(FdPress);
  Customcroplist.Add(Fddisable);


  Fubuttonarea := Rect(Self.Width - self.Height div 2, 0, self.Width, self.Height div 2);
  Fdbuttonarea := Rect(Self.Width - self.Height div 2, self.Height div
    2, self.Width, self.Height);
  Caption := '0';
  Text := '0';
  Value := 0;

end;

destructor TOnURSpinEdit.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  //  if Assigned(Fedit) then FreeAndNil(Fedit);
 { FreeAndNil(FuNormal);
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
  FreeAndNil(FTopRight); }
  inherited Destroy;
end;

procedure TOnURSpinEdit.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Fubuttonarea            := Rect(Self.ClientWidth - self.ClientHeight div 2, 0, self.ClientWidth, self.ClientHeight div 2);
  Fdbuttonarea            := Rect(Self.ClientWidth - self.ClientHeight div 2, self.ClientHeight div 2, self.ClientWidth, self.ClientHeight);
//  FTopleft.Targetrect     := Rect(0, 0, FTopleft.FSRight - FTopleft.FSLeft, FTopleft.FSBottom - FTopleft.FSTop);
//  FTopRight.Targetrect    := Rect(Self.ClientWidth - ((FTopRight.FSRight - FTopRight.FSLeft) + Fubuttonarea.Width), 0, Self.ClientWidth - (Fubuttonarea.Width), (FTopRight.FSBottom - FTopRight.FSTop));
//  FTop.Targetrect         := Rect((FTopleft.FSRight - FTopleft.FSLeft), 0, self.ClientWidth - ((FTopRight.FSRight - FTopRight.FSLeft) + Fubuttonarea.Width), (FTop.FSBottom - FTop.FSTop));
//  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.FSBottom - FBottomleft.FSTop),(FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight);
//  FBottomRight.Targetrect := Rect(self.ClientWidth -((FBottomRight.FSRight - FBottomRight.FSLeft) + Fubuttonarea.Width), self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop), self.ClientWidth - (Fubuttonarea.Width), self.Height);
//  FBottom.Targetrect      := Rect((FBottomleft.FSRight - FBottomleft.FSLeft), self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop), self.ClientWidth - ((FBottomRight.FSRight - FBottomRight.FSLeft) + Fubuttonarea.Width), self.ClientHeight);
//  Fleft.Targetrect        := Rect(0, FTopleft.FSBottom - FTopleft.FSTop,(Fleft.FSRight - Fleft.FSLeft), self.ClientHeight -(FBottomleft.FSBottom - FBottomleft.FSTop));
//  FRight.Targetrect       := Rect(Self.ClientWidth - ((FRight.FSRight - FRight.FSLeft) + Fubuttonarea.Width),(FTopRight.FSBottom - FTopRight.FSTop), Self.ClientWidth - Fubuttonarea.Width, self.ClientHeight - (FBottomRight.FSBottom - FBottomRight.FSTop));
//  FCenter.Targetrect      := Rect((Fleft.FSRight - Fleft.FSLeft), (FTop.FSBottom - FTop.FSTop), Self.ClientWidth - ((FRight.FSRight - FRight.FSLeft) + Fubuttonarea.Width), self.ClientHeight - (FBottom.FSBottom - FBottom.FSTop)); ;

  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect    := Rect(self.clientWidth - FTopRight.Width+Fubuttonarea.Width, 0, self.clientWidth-Fubuttonarea.Width, FTopRight.Height);
  ftop.Targetrect         := Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width+Fubuttonarea.Width, FTop.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - FBottomleft.Height, FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width+Fubuttonarea.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth-Fubuttonarea.Width, self.clientHeight);
  FBottom.Targetrect      := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width+Fubuttonarea.Width, self.clientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);
  FRight.Targetrect       := Rect(self.clientWidth - FRight.Width+Fubuttonarea.Width,FTopRight.Height, self.clientWidth-Fubuttonarea.Width, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect      := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width+Fubuttonarea.Width, self.clientHeight -FBottom.Height);

end;

procedure TOnURSpinEdit.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
 // if csDesigning in ComponentState then
 //  Exit;
  if not Visible then Exit;
  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if Value = 0 then
  begin
    Text := '0';
    Caption := '0';
  end;

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
      SrcRect                 := Fudisable.Croprect;// UP button// Rect(Fudisable.FSLeft, Fudisable.FSTop, Fudisable.FSRight,  Fudisable.FSBottom);
      TrgtRect                := Fddisable.Croprect; // Down button//Rect(Fddisable.FSLeft, Fddisable.FSTop, Fddisable.FSRight, Fddisable.FSBottom);
    end
    else
    begin
      case Fustate of
        obsnormal  : SrcRect  := FuNormal.Croprect;//Rect(FuNormal.FSLeft, FuNormal.FSTop, FuNormal.FSRight, FuNormal.FSBottom);
        obshover   : SrcRect  := FuEnter.Croprect;// Rect(FuEnter.FSLeft, FuEnter.FSTop, FuEnter.FSRight, FuEnter.FSBottom);
        obspressed : SrcRect  := FuPress.Croprect;// Rect(FuPress.FSLeft, FuPress.FSTop, FuPress.FSRight, FuPress.FSBottom);
      end;
      case Fdstate of
        obsnormal  : TrgtRect := FdNormal.Croprect;//Rect(FdNormal.FSLeft, FdNormal.FSTop, FdNormal.FSRight, FdNormal.FSBottom);
        obshover   : TrgtRect :=  FdEnter.Croprect;//Rect(FdEnter.FSLeft, FdEnter.FSTop, FdEnter.FSRight, FdEnter.FSBottom);
        obspressed : TrgtRect := FdPress.Croprect;// Rect(FdPress.FSLeft, FdPress.FSTop, FdPress.FSRight, FdPress.FSBottom);
      end;
      DrawPartnormal(SrcRect, self, Fubuttonarea, alpha);
      DrawPartnormal(TrgtRect, self, Fdbuttonarea, alpha);

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited paint;
end;

end.

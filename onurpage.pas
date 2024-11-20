unit onurpage;

{$mode objfpc}{$H+}


interface

uses
  SysUtils, Classes,
  Controls, Graphics, extctrls, BGRABitmap, BGRABitmapTypes,onurbutton,
  onurctrl, ComponentEditors, PropEdits;

type
  TFade =(fadein, fadeout);
  TONURPageControl = class;

  { TONURPageButton }

  TONURPageButton = class(TONURGraphicControl)
  private
    Fstate       : TONURButtonState;
    FAutoWidth   : boolean;
  protected
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
  public
    FPageControl : TONURPageControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

  published
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
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;


  { TONURPage}

  TONURPage = class(TONURCustomControl)
  private
    Fcaption: TCaption;
    FPageControl: TONURPageControl;
    function GetAutoWidth: boolean;
    function getbutonw: integer;
    function GetPageOrderIndex: integer;
    procedure Getposition;
    procedure SetAutoWidth(AValue: boolean);
    procedure SetButtonwidth(AValue: integer);
    procedure SetCaption(AValue: TCaption);
    procedure SetPageControl(ANotebookControl: TONURPageControl);
    procedure SetPageOrderIndex(Value: integer);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure ReadState(Reader: TReader); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property PageControl  : TONURPageControl read FPageControl write SetPageControl;
  published
    Fbutton: TONURPageButton;
    property AutoCaptionWidth: boolean read GetAutoWidth write SetAutoWidth default True;
    property Buttonwidth: integer read getbutonw write SetButtonwidth;
    property Skindata;
    property Caption: TCaption read Fcaption write SetCaption;
    property Font;
    property Hint;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ParentFont;
    property ParentColor;
    property PageOrderIndex: integer read GetPageOrderIndex
      write SetPageOrderIndex stored False;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseUp;
    property OnMouseMove;
    property OnClick;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ClientHeight;
    property ClientWidth;
    property Constraints;
    property Enabled;
    property ParentBidiMode;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
  end;

  { TonbuttonareaCntrl }

  TONURButtonAreaCntrl = class(TONURCustomControl)
  private

  public
    FPageControl:TONURPageControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  end;

  TPageChangingEvent = procedure(Sender: TObject; NewPageIndex: integer;
    var AllowChange: boolean) of object;

  { TONURPageControlu }

  TONURPageControl = class(TONURCustomControl)
  private
    FPages: TList;
    FActivePage: TONURPage;
    FPageChanged: TNotifyEvent;
    FPageChanging: TPageChangingEvent;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, Fbuttonarea: TONURCUSTOMCROP;

    // for button
    Fnormal    : TONURCUSTOMCROP;
    FPress     : TONURCUSTOMCROP;
    FEnter     : TONURCUSTOMCROP;
    Fdisable   : TONURCUSTOMCROP;

    // for page
    FPageleft, FPageTopleft, FPageBottomleft, FPageRight, FPageTopRight, FPageBottomRight,
    FPageTop, FPageBottom, FPageCenter: TONURCUSTOMCROP;

    fbuttondirection: TONURButtonDirection;
    FbuttonbarHeight: integer;
    procedure buttonclicke(Sender: TObject);
    function GetPage(Index: integer): TONURPage;
    function GetPageCount: integer;
    function GetActivePageIndex: integer;
    procedure SetButtonDirection(val: TONURButtonDirection);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: integer); override;
    procedure ShowControl(AControl: TControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetActivePage(Page: TONURPage); virtual;
    procedure SetActivePageIndex(PageIndex: integer); virtual;
    procedure DoPageChanged; virtual;
    function DoPageChanging(NewPageIndex: integer): boolean; virtual;
    property ActivePageIndex: integer read GetActivePageIndex
      write SetActivePageIndex stored False;
    property OnPageChanging: TPageChangingEvent read FPageChanging write FPageChanging;
    property OnPageChanged: TNotifyEvent read FPageChanged write FPageChanged;
  public
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function NewPage: TONURPage;
    procedure InsertPage(Page: TONURPage); virtual;
    procedure RemovePage(Page: TONURPage); virtual;
    function FindNextPage(CurPage: TONURPage; GoForward: boolean): TONURPage;
    procedure SelectNextPage(GoForward: boolean);
    property PageCount: integer read GetPageCount;
    property Pages[Index: integer]: TONURPage read GetPage;
  published
    btnarea: TONURButtonAreaCntrl;
    property ActivePage: TONURPage read FActivePage write SetActivePage;
    property ButtonDirection: TONURButtonDirection
      read fbuttondirection write SetButtonDirection;
    property Alpha;
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

  TONURPageControlEditor = class(TComponentEditor)
  private
    procedure Addpage;
  public
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
    procedure ExecuteVerb(Index: integer); override;
  end;



  { TONURPageActivePageProperty }

  TONURPageActivePageProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


  { TOnStringProperty }

  TOnStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetOnComponent: TPersistent; virtual;
  end;


  { TonimgPropertyEditor }

  TonimgPropertyEditor = class(TOnStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  { TONURcontentsliderbutton }
  TONURContentSlider = class;
  TONURcontentsliderbutton = class(TONURGraphicControl)
  private
    FNormal,FPress, FEnter,Fdisable: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    Ftimer : TTimer;
    fd     : TFade;
    alp    : integer;
    procedure Onurtimer(sender:TObject);
  protected
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
  public
   prnt   : TONURContentSlider;
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Fade(duration: integer; f: TFade);
   procedure Paint; override;
  end;

  TONURContentSlider = class(TONURCustomControl)
  private
   Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
   FTop, FBottom, FCenter, FleftbuttonN,Fleftbuttonh,Fleftbuttonp,
   FrightbuttonN,Frightbuttonh,Frightbuttonp: TONURCUSTOMCROP;
   Fbuttonleft,Fbuttonright:TONURcontentsliderbutton;
   Fcontent:TStrings;
   indx:integer;
   // to do --> animaiton
   procedure leftbuttonclick(sender:TObject);
   procedure rightbuttonclick(sender:TObject);
   procedure SetString(AValue: TStrings); virtual;

  protected
   procedure SetSkindata(Aimg: TONURImg); override;
   procedure Resize; override;
   procedure Resizing;
   procedure MouseLeave; override;
   procedure MouseEnter; override;
  public
   { Public declarations }
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Paint; override;
  published
   property Items :TStrings read Fcontent write SetString;
  end;

procedure Register;



implementation

uses Dialogs;

const
  StringAddPage = 'New Page';
  StringNextPage = 'Next Page';
  StringPrevPage = 'Previous Page';

procedure Register;
begin
  RegisterComponents('ONUR', [TONURPageControl]);
  RegisterComponents('ONUR', [TONURContentSlider]);
  RegisterClasses([TONURPageControl, TONURPage]);
  RegisterNoIcon([TONURPage]);
  RegisterPropertyEditor(TypeInfo(TONURPage), TONURPageControl, 'ActivePage',
    TONURPageActivePageProperty);
  RegisterComponentEditor(TONURPage, TONURPageControlEditor);
  RegisterComponentEditor(TONURPageControl, TONURPageControlEditor);

  RegisterPropertyEditor(TypeInfo(string), TONURImg, 'Loadskins', TonimgPropertyEditor);

end;

{ TOnStringProperty }

function TOnStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paReadOnly];
end;

procedure TOnStringProperty.GetValues(Proc: TGetStrProc);
var
  i: integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for i := 0 to Pred(Values.Count) do
      Proc(Values[i]);
  finally
    Values.Free;
  end;
end;

function TOnStringProperty.GetOnComponent: TPersistent;
begin
  Result := GetComponent(0);
end;

{ TonimgPropertyEditor }


procedure TonimgPropertyEditor.Edit;
var
  dlg: TOpenDialog;
begin
  if (GetOnComponent is TONURImg) then
  begin
    dlg := TOpenDialog.Create(nil);
    try
      if dlg.Execute then
      begin
        (GetOnComponent as TONURImg).Loadskin(dlg.FileName);
        SetStrValue(dlg.FileName);
      end;
    finally
      dlg.Free;
    end;
  end
  else
    inherited;
end;

function TonimgPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TonimgPropertyEditor.GetValue: string;
begin
  Result := inherited GetStrValue;
end;

procedure TonimgPropertyEditor.SetValue(const Value: string);
begin
  //inherited
  SetValue(Value);
end;

{ TONURcontentsliderbutton }

procedure TONURcontentsliderbutton.Onurtimer(sender: TObject);
begin
  if fd=fadein then
    alp-=20
  else
    alp+=20;


  if (alp<=0) then begin  alp:=0;   ftimer.Enabled := false; end;
  if (alp>=255)then begin alp:=255; ftimer.Enabled := false; end;

  Alpha:=alp;

  //WriteLn(alp);
end;

procedure TONURcontentsliderbutton.MouseEnter;
begin
  inherited MouseEnter;

  fstate := obshover;
  prnt.MouseEnter;
  Invalidate;
end;

procedure TONURcontentsliderbutton.MouseLeave;
begin
  inherited MouseLeave;
  fstate := obsnormal;
  prnt.MouseLeave;
  Invalidate;
end;

procedure TONURcontentsliderbutton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X: integer; Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    fState := obspressed;
    Invalidate;
  end;
end;

procedure TONURcontentsliderbutton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  fstate := obshover;
  Invalidate;
end;

procedure TONURcontentsliderbutton.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURcontentsliderbutton.Resize;
begin
  inherited Resize;
//  if Assigned(Skindata) then
//  Resizing;
end;

procedure TONURcontentsliderbutton.Resizing;
begin
//  FNormal.Targetrect      := Rect(0, 0, self.ClientWidth, self.ClientWidth);
end;

procedure TONURcontentsliderbutton.Paint;
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
          obshover:
          begin
            DR := FEnter.Croprect;
            Self.Font.Color := FEnter.Fontcolor;
          end;
          obspressed:
          begin
            DR := FPress.Croprect;
            Self.Font.Color := FPress.Fontcolor;
          end;
        end;
    end
    else
    begin
      DR := Fdisable.Croprect;
      Self.Font.Color := Fdisable.Fontcolor;
    end;

   DrawPartnormal(DR, Self, self.ClientRect, Alpha);

  end
  else
  begin
   resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited Paint;

end;

constructor TONURcontentsliderbutton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Skinname          := 'contentSliderbutton';
  FNormal           := TONURCUSTOMCROP.Create('NORMAL');
//  FNormal.cropname  := 'NORMAL';
  FPress            := TONURCUSTOMCROP.Create('PRESSED');
//  FPress.cropname   := 'PRESSED';
  FEnter            := TONURCUSTOMCROP.Create('ENTER');
//  FEnter.cropname   := 'ENTER';
  Fdisable          := TONURCUSTOMCROP.Create('DISABLE');
//  Fdisable.cropname := 'DISABLE';
  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);

  Fstate            := obsnormal;
  Width             := 30;
  Height            := 30;
  Resim.SetSize(Width, Height);
  Captionvisible    := False;
  alp               := 255;
 // alpha             := 255;
  Ftimer            := TTimer.create(nil);
  Ftimer.Enabled    := False;
  Ftimer.Ontimer    := @Onurtimer;
end;

destructor TONURcontentsliderbutton.Destroy;
var
  i: Integer;
begin
  if Assigned(Ftimer) then FreeAndNil(Ftimer);
{
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;
  }
  Customcroplist.Clear;

  inherited Destroy;
end;

procedure TONURcontentsliderbutton.Fade(duration: integer;f:TFade);
begin
  if duration>0 then
  begin
   fd := f;
   Ftimer.Interval := duration;
   Ftimer.Enabled  := true;
  end;
end;



procedure TONURContentSlider.leftbuttonclick(sender: TObject);
begin
  if indx<=0 then
  begin
    indx:=0;
    exit;
  end;
  indx-=1;
  Invalidate;
end;

procedure TONURContentSlider.rightbuttonclick(sender: TObject);
begin
  if indx>=Fcontent.Count-1 then
  begin
    indx:=Fcontent.Count-1;
    exit;
  end;
  indx+=1;
  Invalidate;
end;

procedure TONURContentSlider.SetString(AValue: TStrings);
begin
    if Fcontent = AValue then Exit;
  Fcontent.Assign(AValue);
end;

procedure TONURContentSlider.resizing;
begin
 FTopleft.Targetrect := Rect(0, 0, FTopleft.croprect.Width, FTopleft.croprect.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.croprect.Width,
    0, self.clientWidth, FTopRight.croprect.Height);
  ftop.Targetrect := Rect(FTopleft.croprect.Width, 0, self.clientWidth -
    FTopRight.croprect.Width, FTop.croprect.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.croprect.Height,
    FBottomleft.croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.croprect.Width,
    self.clientHeight - FBottomRight.croprect.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.croprect.Width, self.clientHeight -
    FBottom.croprect.Height, self.clientWidth - FBottomRight.croprect.Width, self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.croprect.Height, Fleft.croprect.Width, self.clientHeight -
    FBottomleft.croprect.Height);

  FRight.Targetrect := Rect(self.clientWidth - FRight.croprect.Width, FTopRight.croprect.Height,
    self.clientWidth, self.clientHeight - FBottomRight.croprect.Height);
  FCenter.Targetrect := Rect(Fleft.croprect.Width, FTop.croprect.Height, self.clientWidth -
    FRight.croprect.Width, self.clientHeight - FBottom.croprect.Height);


  if Assigned(Fbuttonleft) and (Fbuttonleft.Skindata=nil) then Fbuttonleft.Skindata  := self.Skindata;
  if Assigned(Fbuttonright) and (Fbuttonright.Skindata=nil) then Fbuttonright.Skindata := self.Skindata;

  resim.FontAntialias := true;
  resim.FontName      := self.Font.Name;
  resim.FontHeight    := self.Font.Size;
  resim.FontStyle     := self.font.Style;
end;

procedure TONURContentSlider.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  resizing;
end;

procedure TONURContentSlider.Resize;
begin
  inherited Resize;
  if not Assigned(Fbuttonleft) then exit;
  Fbuttonleft.Left := 10;
  Fbuttonleft.top  := (self.ClientHeight div 2)- (Fbuttonleft.Height div 2);

  if not Assigned(Fbuttonright) then exit;
  Fbuttonright.Left :=  Self.ClientWidth-(Fbuttonright.Width+10);
  Fbuttonright.top  := (self.ClientHeight div 2)- (Fbuttonright.Height div 2);

  resizing;
//  WriteLn('RESIZE');
end;



procedure TONURContentSlider.MouseLeave;
begin
  inherited MouseLeave;
  if Assigned(Fbuttonleft) then Fbuttonleft.Fade(40,fadein);
  if Assigned(Fbuttonright) then Fbuttonright.Fade(40,fadein);
end;

procedure TONURContentSlider.MouseEnter;
begin
  inherited MouseEnter;
  if Assigned(Fbuttonleft) then Fbuttonleft.Fade(40,fadeout);
  if Assigned(Fbuttonright) then Fbuttonright.Fade(40,fadeout);
end;

constructor TONURContentSlider.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname              := 'contentslider';
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

  FleftbuttonN          := TONURCUSTOMCROP.Create('LEFTBUTTONNORMAL');
//  Fleftbuttonn.cropname := 'LEFTBUTTONNORMAL';
  Fleftbuttonh          := TONURCUSTOMCROP.Create('LEFTBUTTONHOVER');
//  Fleftbuttonh.cropname := 'LEFTBUTTONHOVER';
  Fleftbuttonp          := TONURCUSTOMCROP.Create('LEFTBUTTONPRESS');
//  Fleftbuttonp.cropname := 'LEFTBUTTONPRESS';

  Frightbuttonn         := TONURCUSTOMCROP.Create('RIGHTBUTTONNORMAL');
//  Frightbuttonn.cropname:= 'RIGHTBUTTONNORMAL';
  Frightbuttonh         := TONURCUSTOMCROP.Create('RIGHTBUTTONHOVER');
//  Frightbuttonh.cropname:= 'RIGHTBUTTONHOVER';
  Frightbuttonp         := TONURCUSTOMCROP.Create('RIGHTBUTTONPRESS');
//  Frightbuttonp.cropname:= 'RIGHTBUTTONPRESS';

  indx                  := 0;
  Fcontent              := TStringList.Create;
  Captionvisible        := false;
  Caption               := '';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);

  Customcroplist.Add(Fleftbuttonn);
  Customcroplist.Add(Fleftbuttonh);
  Customcroplist.Add(Fleftbuttonp);

  Customcroplist.Add(Frightbuttonn);
  Customcroplist.Add(Frightbuttonh);
  Customcroplist.Add(Frightbuttonp);


  Self.Height           := 190;
  Self.Width            := 190;
  resim.SetSize(Width, Height);

  Fbuttonleft       := TONURcontentsliderbutton.Create(self);
  with Fbuttonleft do
  begin
    parent          := self;
    prnt            := Self;
    left            := 20;
    top             := 85;
    Width           := 30;
    Height          := 30;
    Caption         := '';
    Captionvisible  := false;
    Skinname        := 'contentslider';
    Fnormal.cropname := 'LEFTBUTTONNORMAL';
    FEnter.cropname := 'LEFTBUTTONHOVER';
    FPress.cropname := 'LEFTBUTTONPRESS';
    Fdisable.cropname := 'LEFTBUTTONPRESS';
    OnClick         := @leftbuttonclick;
  end;
  
  Fbuttonright      := TONURcontentsliderbutton.Create(self);

  with Fbuttonright do
  begin
    parent         := self;
    prnt           := Self;
    left           := 120;
    top            := 85;
    Width          := 30;
    Height         := 30;
    Caption        := '';
    Captionvisible := false;
    Skinname       := 'contentslider';
    Fnormal.cropname := 'RIGHTBUTTONNORMAL';
    FEnter.cropname := 'RIGHTBUTTONHOVER';
    FPress.cropname := 'RIGHTBUTTONPRESS';
    Fdisable.cropname := 'RIGHTBUTTONPRESS';

    OnClick        := @rightbuttonclick;
  end;

end;

destructor TONURContentSlider.Destroy;
var
  i: byte;
begin
  if Assigned(Fbuttonleft) then FreeAndNil(Fbuttonleft);
  if Assigned(Fbuttonright) then FreeAndNil(Fbuttonright);
  if Assigned(Fcontent) then FreeAndNil(Fcontent);

{  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;
}
  Customcroplist.Clear;

  inherited Destroy;
end;

procedure TONURContentSlider.Paint;
var
  DR:TRect;
  stl: TTextStyle;
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
      //CENTER //ORTA
      DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);

      if Crop then
        CropToimg(resim);


      DR.Left    := FCenter.Targetrect.left+Fleft.Croprect.Width;
      DR.Right   := FCenter.Targetrect.Right-FRight.Croprect.Width;
      DR.top     := FCenter.Targetrect.top+Ftop.Croprect.Height;
      DR.bottom  := FCenter.Targetrect.bottom-FBottom.Croprect.Height;

  // WriteLn('PAIMT');

   if Fcontent.count>0 then
   begin
    stl.Alignment := taCenter;
    stl.Wordbreak := True;
    stl.Layout := tlCenter;
    stl.SingleLine := False;



    resim.TextRect(DR, 0, 0, Fcontent[indx], stl,ColorToBGRA(self.font.color));

   end;
  //  yaziyaz(resim.Canvas, self.Font,  DR, Fcontent[indx], taCenter);
  end
  else
  begin
   resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited Paint;
end;




function TONURPageActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TONURPageActivePageProperty.GetValues(Proc: TGetStrProc);
var
  I: integer;
  Component: TComponent;
begin
  if (GlobalDesignHook <> nil) and (GlobalDesignHook.LookupRoot <> nil) and
    (GlobalDesignHook.LookupRoot is TComponent) then
    for I := 0 to TComponent(GlobalDesignHook.LookupRoot).ComponentCount - 1 do
    begin
      Component := TComponent(GlobalDesignHook.LookupRoot).Components[I];
      if (Component.Name <> '') and (Component is TONURPage) and
        (TONURPage(Component).PageControl = GetComponent(0)) then
        Proc(Component.Name);
    end;
end;

{ TONURPageControlEditor }

procedure TONURPageControlEditor.Addpage;
var
  P: TONURPage;
  C: TONURPageControl;
  Hook: TPropertyEditorHook = nil;
begin
  if not GetHook(Hook) then
    Exit;

  if Component is TONURPage then
    c := TONURPage(Component).PageControl
  else
    c := TONURPageControl(Component);


  P := TONURPage.Create(C.Owner);
  try
    P.Parent := C;
    P.Name := GetDesigner.CreateUniqueComponentName(p.ClassName);
    p.Caption := p.Name;
    P.PageControl := C;
    C.ActivePage := P;
    Hook.PersistentAdded(P, True);
    GlobalDesignHook.SelectOnlyThis(P);
    Modified;
  except
    P.Free;
    raise;
  end;
end;

function TONURPageControlEditor.GetVerb(Index: integer): string;
var
  PageControl: TONURPageControl;
begin
  case Index of
    0: Result := StringAddPage;
    1: Result := StringNextPage;
    2: Result := StringPrevPage;
    else
    begin
      Result := '';
      if Component is TONURPage then
        PageControl := TONURPage(Component).PageControl
      else
        PageControl := TONURPageControl(Component);

      if PageControl <> nil then
      begin
        Dec(Index, 3);
        if Index < PageControl.PageCount then
          Result := 'Open ' + PageControl.Pages[Index].Name;
      end;
    end;
  end;
end;

function TONURPageControlEditor.GetVerbCount: integer;
var
  PageControl: TONURPageControl;
  PageCount: integer;
begin
  PageCount := 0;
  if Component is TONURPage then
    PageControl := TONURPage(Component).PageControl
  else
    PageControl := TONURPageControl(Component);

  if PageControl <> nil then
    PageCount := PageControl.PageCount;


  Result := 3 + PageCount;
end;

procedure TONURPageControlEditor.ExecuteVerb(Index: integer);
var
  PageControl: TONURPageControl;
  Page: TONURPage;
  //Hook: TPropertyEditorHook;
begin
  if Component is TONURPage then
    PageControl := TONURPage(Component).PageControl
  else
    PageControl := TONURPageControl(Component);
  if PageControl <> nil then
  begin
    if Index = 0 then
    begin
      Addpage;
    end
    else
    if Index < 3 then
    begin
      Page := PageControl.FindNextPage(PageControl.ActivePage, Index = 1);
      if (Page <> nil) and (Page <> PageControl.ActivePage) then
      begin
        PageControl.ActivePage := Page;
        if Component is TONURPage then
          GetDesigner.SelectOnlyThisComponent(Page);
        GetDesigner.Modified;
      end;
    end
    else
    begin
      Dec(Index, 3);
      if Index < PageControl.PageCount then
      begin
        Page := PageControl.Pages[Index];
        if (Page <> nil) and (Page <> PageControl.ActivePage) then
        begin
          PageControl.ActivePage := Page;
          if Component is TONURPage then
            GetDesigner.SelectOnlyThisComponent(Page);
          GetDesigner.Modified;
        end;
      end;
    end;
  end;
end;




{ TONURPageControl }


constructor TONURPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  //  ControlStyle := ControlStyle - [csAcceptsControls] + [csParentBackground, csClickEvents, csCaptureMouse, csDoubleClicks];
  Width := 300;
  Height := 300;
  TabStop := True;
  FPages := TList.Create;
  fbuttondirection := obup;
  FbuttonbarHeight := 24;
  Font.Name := 'Calibri';
  Font.Size := 9;
  TabStop := True;




  skinname                  := 'pagecontrol';
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

  // for button area
  Fbuttonarea               := TONURCUSTOMCROP.Create('BUTTONAREA');
//  Fbuttonarea.cropname      := 'BUTTONAREA';

  // for page(s)
  FPageTop                  := TONURCUSTOMCROP.Create('PAGETOP');
//  FPageTop.cropname         := 'PAGETOP';
  FPageBottom               := TONURCUSTOMCROP.Create('PAGEBOTTOM');
//  FPageBottom.cropname      := 'PAGEBOTTOM';
  FPageCenter               := TONURCUSTOMCROP.Create('PAGECENTER');
//  FPageCenter.cropname      := 'PAGECENTER';
  FPageRight                := TONURCUSTOMCROP.Create('PAGERIGHT');
//  FPageRight.cropname       := 'PAGERIGHT';
  FPageTopRight             := TONURCUSTOMCROP.Create('PAGETOPRIGHT');
//  FPageTopRight.cropname    := 'PAGETOPRIGHT';
  FPageBottomRight          := TONURCUSTOMCROP.Create('PAGEBOTTOMRIGHT');
//  FPageBottomRight.cropname := 'PAGEBOTTOMRIGHT';
  FPageleft                 := TONURCUSTOMCROP.Create('PAGELEFT');
//  FPageleft.cropname        := 'PAGELEFT';
  FPageTopleft              := TONURCUSTOMCROP.Create('PAGETOPLEFT');
//  FPageTopleft.cropname     := 'PAGETOPLEFT';
  FPageBottomleft           := TONURCUSTOMCROP.Create('PAGEBOTTOMLEFT');
//  FPageBottomleft.cropname  := 'PAGEBOTTOMLEFT';

  // for button
  FNormal               := TONURCUSTOMCROP.Create('BUTTONNORMAL');
//  FNormal.cropname      := 'BUTTONNORMAL';
  FPress                := TONURCUSTOMCROP.Create('BUTTONDOWN');
//  FPress.cropname       := 'BUTTONDOWN';
  FEnter                := TONURCUSTOMCROP.Create('BUTTONHOVER');
//  FEnter.cropname       := 'BUTTONHOVER';
  Fdisable              := TONURCUSTOMCROP.Create('BUTTONDISABLE');
//  Fdisable.cropname     := 'BUTTONDISABLE';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);

  Customcroplist.Add(Fbuttonarea);

  Customcroplist.Add(FPageTopleft);
  Customcroplist.Add(FPageTop);
  Customcroplist.Add(FPageTopRight);
  Customcroplist.Add(FPageBottomleft);
  Customcroplist.Add(FPageBottom);
  Customcroplist.Add(FPageBottomRight);
  Customcroplist.Add(FPageleft);
  Customcroplist.Add(FPageRight);
  Customcroplist.Add(FPageCenter);

  Customcroplist.Add(Fnormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);


  btnarea := TONURButtonAreaCntrl.Create(self);
  btnarea.FPageControl:=self;
  btnarea.Parent := self;


  //  btnarea.Skindata:=nil;//self.Skindata;
  btnarea.Height := 30;
  btnarea.Align := alTop;
  Captionvisible := False;
  // ChildSizing.VerticalSpacing:=3;
end;

destructor TONURPageControl.Destroy;
var
  A: integer;
begin
  for A := FPages.Count - 1 downto 0 do
    Pages[A].Free;
 {
   for A:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[A]).free;
 }
  Customcroplist.Clear;
  FPages.Free;
  btnarea.Free;

  inherited Destroy;
end;


procedure TONURPageControl.Paint;
begin

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

    if Crop then
      CropToimg(resim);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);
  end;

  inherited Paint;
end;

procedure TONURPageControl.SetSkindata(Aimg: TONURImg);
begin
 inherited SetSkindata(Aimg);
 resizing;
end;



procedure TONURPageControl.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURPageControl.Resizing;
var
  i: integer;
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






  btnarea.Skindata := self.Skindata;

  if FPages.Count > 0 then
    for i := 0 to PageCount - 1 do
    begin
      // Pages[i].Fbutton.Skindata:=Aimg;
      if self.Skindata <> nil then
        Pages[i].Skindata := self.Skindata;// Paint;
    end;

end;


function TONURPageControl.NewPage: TONURPage;
begin
  Result := TONURPage.Create(nil);
  Result.PageControl := Self;
  ActivePage := Result;
end;

procedure TONURPageControl.InsertPage(Page: TONURPage);
begin
  FPages.Add(Page);
  Page.FPageControl := Self;
  Page.FreeNotification(Self);
end;

procedure TONURPageControl.RemovePage(Page: TONURPage);
var
  APage: TONURPage;
begin
  if FActivePage = Page then
  begin
    APage := FindNextPage(FActivePage, True);
    if APage = Page then FActivePage := nil
    else
      FActivePage := APage;
  end;
  FPages.Remove(Page);
  Page.FPageControl := nil;
  if not (csDestroying in ComponentState) then
    Invalidate;

end;



function TONURPageControl.GetPage(Index: integer): TONURPage;
begin
  Result := TONURPage(FPages[Index]);
end;

function TONURPageControl.GetPageCount: integer;
begin
  Result := FPages.Count;
end;

function TONURPageControl.GetActivePageIndex: integer;
begin
  if Assigned(FActivePage) then
    Result := FPages.IndexOf(FActivePage)
  else
    Result := -1;
end;


procedure TONURPageControl.SetButtonDirection(val: TONURButtonDirection);
var
  c: integer;
begin
  if fbuttondirection = val then exit;
  fbuttondirection := val;

  case fbuttondirection of
    obup:
    begin
      btnarea.Align := alTop;
      btnarea.Height := 30;
    end;
    obdown:
    begin
      btnarea.Align := alBottom;
      btnarea.Height := 30;
    end;
    obleft:
    begin
      btnarea.Align := alLeft;
      btnarea.Width := 30;
    end;
    obright:
    begin
      btnarea.Align := alRight;
      btnarea.Width := 30;
    end;
  end;

  if FPages.Count > 0 then
    for c := 0 to FPages.Count - 1 do
      Pages[c].Getposition;

  Invalidate;
end;




procedure TONURPageControl.buttonclicke(Sender: TObject);
var
  i: integer;
begin
  i := TONURPageButton(Sender).Tag;
  if GetActivePageIndex = i then exit;
  SetActivePageIndex(i);
end;

procedure TONURPageControl.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  inherited GetChildren(Proc, Root);
end;

procedure TONURPageControl.SetChildOrder(Child: TComponent; Order: integer);
begin
  inherited SetChildOrder(Child, Order);
  TONURPage(Child).PageOrderIndex := Order;
end;

procedure TONURPageControl.ShowControl(AControl: TControl);
begin
  if (AControl is TONURPage) and (TONURPage(AControl).PageControl = Self) then
    SetActivePage(TONURPage(AControl));
  inherited ShowControl(AControl);
end;

procedure TONURPageControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (AComponent is TONURPage) and (TONURPage(AComponent).PageControl = Self) then
      RemovePage(TONURPage(AComponent));
  end;
end;


procedure TONURPageControl.SetActivePage(Page: TONURPage);
var
  AOldPage: TONURPage;
  APageChanged: boolean;
begin
  APageChanged := False;
  if not (csDestroying in ComponentState) then
  begin
    if (Assigned(Page) and (Page.PageControl = Self)) or (Page = nil) then
    begin
      if Assigned(FActivePage) then
      begin
        if FActivePage <> Page then
        begin
          AOldPage := FActivePage;
          FActivePage := Page;
          AOldPage.Visible := False;
          AOldPage.Fbutton.Enabled := True;
          FActivePage.Fbutton.Enabled := False;
          FActivePage.Visible := True;
          if csDesigning in ComponentState then
          begin
            FActivePage.BringToFront;
            AOldPage.SendToBack;
            Invalidate;
          end;


          APageChanged := True;
        end;
      end
      else
      begin
        FActivePage := Page;
        FActivePage.Visible := True;
        FActivePage.Fbutton.Enabled := False;
        APageChanged := True;
      end;
    end;
  end;
  if APageChanged then DoPageChanged;

end;

procedure TONURPageControl.SetActivePageIndex(PageIndex: integer);
begin
  if not (csLoading in ComponentState) then
    SetActivePage(Pages[PageIndex]);
end;

procedure TONURPageControl.DoPageChanged;
begin
  if not (csDestroying in ComponentState) and Assigned(FPageChanged) then
    FPageChanged(Self);
end;

function TONURPageControl.DoPageChanging(NewPageIndex: integer): boolean;
begin
  Result := True;
  if Assigned(FPageChanging) then
    FPageChanging(Self, NewPageIndex, Result);
end;



function TONURPageControl.FindNextPage(CurPage: TONURPage; GoForward: boolean): TONURPage;
var
  StartIndex: integer;
begin
  Result := nil;
  if FPages.Count <> 0 then
  begin
    StartIndex := FPages.IndexOf(CurPage);
    if StartIndex = -1 then
    begin
      if GoForward then
        StartIndex := FPages.Count - 1
      else
        StartIndex := 0;
    end;
    if GoForward then
    begin
      Inc(StartIndex);
      if StartIndex = FPages.Count then
        StartIndex := 0;
    end
    else
    begin
      if StartIndex = 0 then
        StartIndex := FPages.Count;
      Dec(StartIndex);
    end;
    Result := Pages[StartIndex];
  end;
end;

procedure TONURPageControl.SelectNextPage(GoForward: boolean);
begin
  SetActivePage(FindNextPage(ActivePage, GoForward));
end;


{ TONURPages }

constructor TONURPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csAcceptsControls,
    csClickEvents, csCaptureMouse, csDoubleClicks];

  DoubleBuffered := True;
  ParentBackground := True;
  Self.Height := 190;
  Self.Width := 190;
  Visible := False;
  Align := alClient;
  resim.SetSize(190, 190);


end;

destructor TONURPage.Destroy;
begin
  inherited Destroy;
end;


function TONURPage.GetPageOrderIndex: integer;
begin
  if FPageControl <> nil then
    Result := FPageControl.FPages.IndexOf(Self)
  else
    Result := -1;

end;

function TONURPage.getbutonw: integer;
begin
  if Assigned(Fbutton) then
    Result := Fbutton.Width;
end;

function TONURPage.GetAutoWidth: boolean;
begin
  if Assigned(Fbutton) then
    Result := Fbutton.AutoWidth;
end;

procedure TONURPage.SetAutoWidth(AValue: boolean);
begin
  if Assigned(Fbutton) then
    Fbutton.AutoWidth := AValue;
end;

procedure TONURPage.SetButtonwidth(AValue: integer);
begin
  if Assigned(Fbutton) then
  begin
    if Fbutton.Width = AValue then exit;
    Fbutton.Width := AValue;
  end;
end;


procedure TONURPage.Getposition;
begin

  if (FPageControl = nil) then exit;
  if (FPageControl.Skindata = nil) then exit;

  case FPageControl.ButtonDirection of
    obup:
    begin
      Fbutton.Align := alLeft;
      Fbutton.Width := 100;
      Fbutton.Font.Orientation := 0;
      left := FPageControl.Fleft.Croprect.Width;
      top := FPageControl.FTop.Croprect.Height + FPageControl.btnarea.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Croprect.Width +
        FPageControl.FRight.Croprect.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Croprect.Height +
        FPageControl.FBottom.Croprect.Height + FPageControl.btnarea.Height);
    end;
    obdown:
    begin
      Fbutton.Align := alLeft;
      Fbutton.Width := 100;
      Fbutton.Font.Orientation := 0;
      left := FPageControl.Fleft.Croprect.Width;
      top := FPageControl.FTop.Croprect.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Croprect.Width +
        FPageControl.FRight.Croprect.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Croprect.Height +
        FPageControl.FBottom.Croprect.Height + FPageControl.btnarea.Height);
    end;
    obleft:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;              //  Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Croprect.Width + FPageControl.btnarea.Width;
      top := FPageControl.FTop.Croprect.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Croprect.Width +
        FPageControl.FRight.Croprect.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Croprect.Height +
        FPageControl.FBottom.Croprect.Height);
    end;
    obright:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;   // Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Croprect.Width;
      top := FPageControl.FTop.Croprect.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Croprect.Width +
        FPageControl.FRight.Croprect.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Croprect.Height +
        FPageControl.FBottom.Croprect.Height);
    end;
  end;
end;




procedure TONURPage.SetCaption(AValue: TCaption);
begin
  if Fcaption = AValue then Exit;
  Fcaption := AValue;
  if Assigned(Fbutton) then
    fbutton.Caption := AValue;

end;



procedure TONURPage.SetPageControl(ANotebookControl: TONURPageControl);
begin
  if FPageControl <> ANotebookControl then
  begin

    if FPageControl <> nil then
      FPageControl.RemovePage(Self);

    FPageControl := ANotebookControl;

    Parent := FPageControl;

    if FPageControl <> nil then
    begin
      FPageControl.InsertPage(Self);

      Fbutton := TONURPageButton.Create(self);

      with fbutton do
      begin
        parent := FPageControl.btnarea;
        FPageControl:= ANotebookControl;
        align := alleft;
        tag := self.GetPageOrderIndex;
        OnClick := @self.FPageControl.buttonclicke;
        Caption := self.Caption;
        AutoWidth := self.AutoCaptionWidth;
        // BorderSpacing.Bottom:=5;
      end;
      Skindata := FPageControl.Skindata;
      Getposition;
      Invalidate;
    end;
  end;
end;

procedure TONURPage.SetPageOrderIndex(Value: integer);
var
  MaxPageIndex: integer;
begin
  if FPageControl <> nil then
  begin
    MaxPageIndex := FPageControl.FPages.Count - 1;
    if Value > MaxPageIndex then
      raise EListError.CreateFmt('Sheet Index Error', [Value, MaxPageIndex]);
    FPageControl.FPages.Move(PageOrderIndex, Value);
  end;
end;

procedure TONURPage.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURPage.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURPage.Resizing;
begin

  FPageControl.FpageTopleft.Targetrect :=
    Rect(0, 0, FPageControl.FpageTopleft.Croprect.Width, FPageControl.FpageTopleft.Croprect.Height);

  FPageControl.FpageTopRight.Targetrect :=
    Rect((self.clientWidth) -FPageControl.FPageTopRight.Croprect.Width, 0, self.clientWidth,
     FPageControl.FPageTopRight.Croprect.Height);

  FPageControl.FpageTop.Targetrect :=
    Rect(FPageControl.FPageTopleft.Croprect.Width, 0, self.clientWidth - FPageControl.FPageTopRight.Croprect.Width,FPageControl.fpagetop.Croprect.Height);


  FPageControl.FpageBottomleft.Targetrect :=
    Rect(0, self.ClientHeight - FPageControl.FPageBottomleft.Croprect.Height, FPageControl.FPageBottomleft.Croprect.Width, self.ClientHeight);
  FPageControl.FpageBottomRight.Targetrect :=
    Rect(self.clientWidth - FPageControl.FPageBottomRight.Croprect.Width,
    self.clientHeight - FPageControl.FPageBottomRight.Croprect.Height, self.clientWidth,
    self.clientHeight);

  FPageControl.FpageBottom.Targetrect :=
    Rect(FPageControl.Fpagebottomleft.Croprect.Width, self.clientHeight -
  FPageControl.FPageBottom.Croprect.Height, self.clientWidth - FPageControl.FPageBottomRight.Croprect.Width,
    self.clientHeight);

  FPageControl.Fpageleft.Targetrect :=
    Rect(0, FPageControl.FPageTopleft.Croprect.Height, FPageControl.FPageleft.Croprect.Width,
    self.clientHeight - FPageControl.FPageBottomleft.Croprect.Height);
  FPageControl.FpageRight.Targetrect :=
    Rect(self.clientWidth - FPageControl.FPageRight.Croprect.Width, FPageControl.FPageTopRight.Croprect.Height,
    self.clientWidth, self.clientHeight - FPageControl.FPageBottomRight.Croprect.Height);
  FPageControl.FpageCenter.Targetrect :=
    Rect(FPageControl.FPageleft.Croprect.Width, FPageControl.fpagetop.Croprect.Height,
    self.clientWidth - (FPageControl.FPageRight.Croprect.Width), self.clientHeight -
     FPageControl.FPageBottom.Croprect.Height);

  Fbutton.Skindata := Skindata;
end;




procedure TONURPage.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TONURPageControl then
    PageControl := TONURPageControl(Reader.Parent);

end;

procedure TONURPage.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) and not Visible then
    SendToBack;
end;



procedure TONURPage.Paint;
begin
  if FPageControl = nil then exit;
  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);


  if (FPageControl.Skindata <> nil) and not (csDesigning in ComponentState) and (Assigned(FPageControl)) then
  begin
    if Fbutton.Skindata = nil then
      Fbutton.Skindata := self.Skindata;


    //TOPLEFT   //SOLÜST
    DrawPartnormal(FPageControl.FPageTopleft.Croprect, self, FPageControl.FPageTopleft.Targetrect, Alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(FPageControl.FPageTopRight.Croprect, self, FPageControl.FPageTopRight.Targetrect, Alpha);
    //TOP  //ÜST
    DrawPartnormal(FPageControl.FPageTop.Croprect, self, FPageControl.FPageTop.Targetrect, Alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(FPageControl.FPageBottomleft.Croprect, self, FPageControl.FPageBottomleft.Targetrect, Alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(FPageControl.FPageBottomRight.Croprect, self, FPageControl.FPageBottomRight.Targetrect, Alpha);
    //BOTTOM  //ALT
    DrawPartnormal(FPageControl.FPageBottom.Croprect, self, FPageControl.FPageBottom.Targetrect, Alpha);
    //LEFT CENTERLEFT // SOLORTA
    DrawPartnormal(FPageControl.FPageleft.Croprect, self, FPageControl.FPageleft.Targetrect, Alpha);
    //CENTERRIGHT // SAĞORTA
    DrawPartnormal(FPageControl.FPageRight.Croprect, self, FPageControl.FPageRight.Targetrect, Alpha);
    //CENTER //ORTA
    DrawPartnormal(FPageControl.FPageCenter.Croprect, self, FPageControl.FPageCenter.Targetrect, Alpha);
  end
  else
  begin
    resim.Fill(BGRA(140, 170, 140, alpha), dmSet);
  end;
  inherited Paint;
end;




procedure TONURPageButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (Fstate = obshover) then
    Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;


procedure TONURPageButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURPageButton.MouseLeave;
begin
  if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (Fstate = obsnormal) then
    Exit;

  inherited MouseLeave;
  Fstate := obsnormal;
  Invalidate;
end;
// -----------------------------------------------------------------------------
procedure TONURPageButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

constructor TONURPageButton.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  Width := 100;
  Height := 30;
  FAutoWidth := True;
  Fstate := obsNormal;
  FPageControl:= TONURPage(self.Parent).FPageControl;
  //Skinname := 'pagecontrol';

end;

// -----------------------------------------------------------------------------

destructor TONURPageButton.Destroy;
begin
  inherited Destroy;
end;

procedure TONURPageButton.CheckAutoWidth;
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



procedure TONURPageButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONURPageButton.Paint;
var
  DR: TRect;
begin

  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) and Assigned(FPageControl) then
  begin
    try


      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR := FPageControl.Fnormal.Croprect;
            Self.Font.Color := FPageControl.Fnormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := FPageControl.FPress.Croprect;
            Self.Font.Color := FPageControl.FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := FPageControl.FEnter.Croprect;
            Self.Font.Color := FPageControl.FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := FPageControl.Fdisable.Croprect;
        Self.Font.Color := FPageControl.Fdisable.Fontcolor;
      end;
      DrawPartnormal(DR, self, Rect(0, 0, self.Width, self.Height), Alpha);
    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(100, 150, 100, alpha), dmSet);
  end;

  inherited Paint;
end;


{ TonbuttonareaCntrl }



constructor TONURButtonAreaCntrl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  Width := 50;
  Height := 50;
  //Skinname := 'pagecontrol';

end;

destructor TONURButtonAreaCntrl.Destroy;
begin
  inherited Destroy;
end;

procedure TONURButtonAreaCntrl.Paint;
begin
  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) and (Assigned(FPageControl)) then
    DrawPartnormal(FPageControl.Fbuttonarea.Croprect, self, rect(0, 0, self.clientWidth,
      self.clientHeight), Alpha)
  else
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);

  inherited Paint;
end;

end.

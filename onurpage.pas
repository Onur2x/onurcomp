unit onurpage;

{$mode objfpc}{$H+}


interface

uses
  SysUtils, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, BGRABitmap, BGRABitmapTypes,
  Dialogs, onurctrl, ComponentEditors, PropEdits, TypInfo;

type
  TONURPageControl = class;

  { TONURPageButton }

  TONURPageButton = class(TONURGraphicControl)
  private
    Fnormal: TONURCUSTOMCROP;
    FPress: TONURCUSTOMCROP;
    FEnter: TONURCUSTOMCROP;
    Fdisable: TONURCUSTOMCROP;
    Fstate: TONURButtonState;
    FAutoWidth: boolean;
  protected
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
  public
    // fPgCntrl     : TONURPageControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    property OENTER   : TONURCUSTOMCROP read FEnter   write FEnter;
    property ONORMAL  : TONURCUSTOMCROP read Fnormal  write Fnormal;
    property OPRESS   : TONURCUSTOMCROP read FPress   write FPress;
    property ODISABLE : TONURCUSTOMCROP read Fdisable write Fdisable;

    //   property PageCntrl : TONURPageControl read fPgCntrl write setPgCntrl;
  protected
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
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
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
    procedure ReadState(Reader: TReader); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property PageControl  : TONURPageControl read FPageControl write SetPageControl;
    property OLEFT        : TONURCUSTOMCROP  read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP  read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP  read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP  read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP  read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP  read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP  read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP  read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP  read FTopRight    write FTopRight;
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
    Fbttnarea: TONURCUSTOMCROP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property OCLIENT: TONURCUSTOMCROP read Fbttnarea write Fbttnarea;
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
    fbuttondirection: TONURButtonDirection;
    FbuttonbarHeight: integer;
    procedure buttonclicke(Sender: TObject);
    function GetPage(Index: integer): TONURPage;
    function GetPageCount: integer;
    function GetActivePageIndex: integer;
    procedure SetButtonDirection(val: TONURButtonDirection);
  protected

    procedure SetSkindata(Aimg: TONURImg); override;
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
    property OLEFT        : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP read FTopRight    write FTopRight;
    property OBUTTONAREA  : TONURCUSTOMCROP read Fbuttonarea  write Fbuttonarea;
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



procedure Register;



implementation

uses  BGRAPath;

const
  StringAddPage = 'New Page';
  StringNextPage = 'Next Page';
  StringPrevPage = 'Previous Page';

procedure Register;
begin
  RegisterComponents('ONUR', [TONURPageControl]);
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
        //(GetOnComponent as TONImg).LoadSkins:=dlg.FileName;
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
    //     GetDesigner.SelectOnlyThisComponent(P);
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




  skinname := 'pagecontrol';
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
  Fbuttonarea := TONURCUSTOMCROP.Create;
  Fbuttonarea.cropname := 'BUTTONAREA';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(Fbuttonarea);

  btnarea := TONURButtonAreaCntrl.Create(self);
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

   for A:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[A]).free;

  Customcroplist.Clear;
  FPages.Free;

 { FreeAndNil(FTop);
  FreeAndNil(FBottom);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(Fbuttonarea);
  }
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
var
  i: integer;
begin
  inherited SetSkindata(Aimg);

  FTopleft.Targetrect := Rect(0, 0, FTopleft.Width, FTopleft.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Width,
    0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect := Rect(FTopleft.Width, 0, self.clientWidth -
    FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Height,
    FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width,
    self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.Width, self.clientHeight -
    FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.Height, Fleft.Width,
    self.clientHeight - FBottomleft.Height);
  FRight.Targetrect := Rect(self.clientWidth - FRight.Width, FTopRight.Height,
    self.clientWidth, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect := Rect(Fleft.Width, FTop.Height, self.clientWidth -
    FRight.Width, self.clientHeight - FBottom.Height);


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
  //  Fresim :=TBGRABitmap.Create;
  Self.Height := 190;
  Self.Width := 190;
  Visible := False;

  //Align := alClient;


  skinname := 'pagecontrol';
  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'PAGETOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'PAGEBOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'PAGECENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'PAGERIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'PAGETOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'PAGEBOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'PAGELEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'PAGETOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'PAGEBOTTOMLEFT';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
   Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);





  resim.SetSize(190, 190);
end;

destructor TONURPage.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{begin
  FreeAndNil(FTop);
  FreeAndNil(FBottom);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(Fleft);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(Fbutton); }
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

  //  if (FPageControl<>nil) or (FPageControl.Skindata<> nil) then
  //     fbutton.skindata:=FPageControl.Skindata;
  //    else
  //    exit;



  if (FPageControl = nil) then exit;
  if (FPageControl.Skindata = nil) then exit;

  case FPageControl.ButtonDirection of
    obup:
    begin
      Fbutton.Align := alLeft;
      Fbutton.Width := 100;
      Fbutton.Font.Orientation := 0;
      left := FPageControl.Fleft.Width;
      top := FPageControl.FTop.Height + FPageControl.btnarea.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Width +
        FPageControl.FRight.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Height +
        FPageControl.FBottom.Height + FPageControl.btnarea.Height);
    end;
    obdown:
    begin
      Fbutton.Align := alLeft;
      Fbutton.Width := 100;
      Fbutton.Font.Orientation := 0;
      left := FPageControl.Fleft.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Width +
        FPageControl.FRight.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Height +
        FPageControl.FBottom.Height + FPageControl.btnarea.Height);
    end;
    obleft:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;              //  Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Width + FPageControl.btnarea.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Width +
        FPageControl.FRight.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Height +
        FPageControl.FBottom.Height);
    end;
    obright:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;   // Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Width +
        FPageControl.FRight.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height - (FPageControl.FTop.Height +
        FPageControl.FBottom.Height);
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
  FTopleft.Targetrect :=
    Rect(0, 0, FPageControl.FTopleft.Width, FPageControl.FTopleft.Height);
  FTopRight.Targetrect :=
    Rect(self.clientWidth - (FTopRight.Width), 0, self.clientWidth,
    FPageControl.FTopRight.Height);
  FTop.Targetrect :=
    Rect(FPageControl.FTopleft.Width, 0, self.clientWidth -
    (FPageControl.FTopRight.Width), FPageControl.FTop.Height);

  FBottomleft.Targetrect :=
    Rect(0, self.ClientHeight - FPageControl.FBottomleft.Height,
    FPageControl.FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect :=
    Rect(self.clientWidth - (FPageControl.FBottomRight.Width),
    self.clientHeight - FPageControl.FBottomRight.Height, self.clientWidth,
    self.clientHeight);
  FBottom.Targetrect :=
    Rect(FPageControl.FBottomleft.Width, self.clientHeight -
    FPageControl.FBottom.Height, self.clientWidth - FPageControl.FBottomRight.Width,
    self.clientHeight);

  Fleft.Targetrect :=
    Rect(0, FPageControl.FTopleft.Height, FPageControl.Fleft.Width,
    self.clientHeight - FPageControl.FBottomleft.Height);
  FRight.Targetrect :=
    Rect(self.clientWidth - FPageControl.FRight.Width, FPageControl.FTopRight.Height,
    self.clientWidth, self.clientHeight - FPageControl.FBottomRight.Height);
  FCenter.Targetrect :=
    Rect(FPageControl.Fleft.Width, FPageControl.FTop.Height,
    self.clientWidth - FPageControl.FRight.Width, self.clientHeight -
    FPageControl.FBottom.Height);

  Fbutton.Skindata := Aimg;
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


  if (FPageControl.Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Fbutton.Skindata = nil then
      Fbutton.Skindata := self.Skindata;


    //TOPLEFT   //SOLÜST
    DrawPartnormal(FTopleft.Croprect, self, fTopleft.Targetrect, Alpha);
    //TOPRIGHT //SAĞÜST
    DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, Alpha);
    //TOP  //ÜST
    DrawPartnormal(FTop.Croprect, self, FTop.Targetrect, Alpha);
    //BOTTOMLEFT // SOLALT
    DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, Alpha);
    //BOTTOMRIGHT  //SAĞALT
    DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, Alpha);
    //BOTTOM  //ALT
    DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, Alpha);
    //LEFT CENTERLEFT // SOLORTA
    DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, Alpha);
    //CENTERRIGHT // SAĞORTA
    DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, Alpha);
    //CENTER //ORTA
    DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, Alpha);
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
  Skinname := 'pagecontrol';
  FNormal := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'BUTTONNORMAL';
  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'BUTTONDOWN';
  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'BUTTONHOVER';
  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'BUTTONDISABLE';


  Customcroplist.Add(Fnormal); 
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);

end;

// -----------------------------------------------------------------------------

destructor TONURPageButton.Destroy;
var
  i: byte;
begin
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;

  Customcroplist.Clear;
{begin
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable); }
  inherited Destroy;
end;

procedure TONURPageButton.CheckAutoWidth;
var
  a: Tsize;
begin
  if FAutoWidth and Assigned(resim) then
  begin
    //    resim.FontName:=self.parent.font.Name;
    //    resim.FontHeight:=self.parent.Font.Height;

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

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try


      if Enabled = True then
      begin
        case Fstate of
          obsNormal:
          begin
            DR := Fnormal.Croprect;
            Self.Font.Color := Fnormal.Fontcolor;
          end;
          obspressed:
          begin
            DR := FPress.Croprect;
            Self.Font.Color := FPress.Fontcolor;
          end;
          obshover:
          begin
            DR := FEnter.Croprect;
            Self.Font.Color := FEnter.Fontcolor;
          end;
        end;
      end
      else
      begin
        DR := Fdisable.Croprect;
        Self.Font.Color := Fdisable.Fontcolor;
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
  Skinname := 'pagecontrol';
  Fbttnarea := TONURCUSTOMCROP.Create;

  Fbttnarea.cropname := 'BUTTONAREA';

  Customcroplist.Add(Fbttnarea);
end;

destructor TONURButtonAreaCntrl.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;
  Customcroplist.Clear;
  inherited Destroy;
end;

procedure TONURButtonAreaCntrl.Paint;
begin
  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
    DrawPartnormal(Fbttnarea.Croprect, self, rect(0, 0, self.clientWidth,
      self.clientHeight), Alpha)
  else
    resim.Fill(BGRA(190, 208, 190, alpha), dmSet);

  inherited Paint;
end;

end.

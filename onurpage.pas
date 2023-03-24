unit onurpage;

{$mode objfpc}{$H+}


interface

uses
  SysUtils,  Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, BGRABitmap, BGRABitmapTypes,
  Dialogs, onurctrl, ComponentEditors, PropEdits, TypInfo;

type
  TONPageControl = class;

  { TONPageButton }

  TONPageButton = class(TOnGraphicControl)
  private
    Fnormal     : TONCUSTOMCROP;
    FPress      : TONCUSTOMCROP;
    FEnter      : TONCUSTOMCROP;
    Fdisable    : TONCUSTOMCROP;
    Fstate      : TONButtonState;
    FAutoWidth  : boolean;
  protected
    procedure SetAutoWidth(const Value: boolean);
    procedure CheckAutoWidth;
  public
    // fPgCntrl     : TONPageControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    property ONENTER: TONCUSTOMCROP read FEnter write FEnter;
    property ONNORMAL: TONCUSTOMCROP read Fnormal write Fnormal;
    property ONPRESS: TONCUSTOMCROP read FPress write FPress;
    property ONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;

    //   property PageCntrl : TOnPageControl read fPgCntrl write setPgCntrl;
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


  { TONPage}

  TONPage = class(TOnCustomControl)
  private

    Fcaption: TCaption;
    FPageControl: TONPageControl;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONCUSTOMCROP;
    function GetAutoWidth: boolean;
    function getbutonw: integer;
    function GetPageOrderIndex: integer;
    procedure Getposition;
    procedure SetAutoWidth(AValue: boolean);
    procedure SetButtonwidth(AValue: integer);
    procedure SetCaption(AValue: TCaption);
    procedure SetPageControl(ANotebookControl: TONPageControl);
    procedure SetPageOrderIndex(Value: integer);
  protected
    procedure SetSkindata(Aimg: TONImg); override;
    procedure ReadState(Reader: TReader); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property PageControl: TONPageControl read FPageControl write SetPageControl;
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
  published
    Fbutton: TONPageButton;
    property AutoCaptionWidth: boolean read GetAutoWidth write SetAutoWidth default True;
    property Buttonwidth :integer read getbutonw write SetButtonwidth;
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

  TonbuttonareaCntrl = class(TOnCustomControl)
  private
    Fbttnarea: TONCustomCrop;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property ONCLIENT: TONCUSTOMCROP read Fbttnarea write Fbttnarea;
  end;

  TPageChangingEvent = procedure(Sender: TObject; NewPageIndex: integer;
    var AllowChange: boolean) of object;

  { TONPageControlu }

  TONPageControl = class(TONCustomControl)
  private

    FPages: TList;
    FActivePage: TOnPage;
    FPageChanged: TNotifyEvent;
    FPageChanging: TPageChangingEvent;
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter, Fbuttonarea: TONCUSTOMCROP;
    fbuttondirection: TONButtonDirection;
    FbuttonbarHeight: integer;
    procedure buttonclicke(Sender: TObject);
    function GetPage(Index: integer): TOnPage;
    function GetPageCount: integer;
    function GetActivePageIndex: integer;
    procedure SetButtonDirection(val: TONButtonDirection);
  protected

    procedure SetSkindata(Aimg: TONImg); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: integer); override;
    procedure ShowControl(AControl: TControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetActivePage(Page: TOnPage); virtual;
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
    function NewPage: TOnPage;
    procedure InsertPage(Page: TOnPage); virtual;
    procedure RemovePage(Page: TOnPage); virtual;
    function FindNextPage(CurPage: TOnPage; GoForward: boolean): TOnPage;
    procedure SelectNextPage(GoForward: boolean);
    property PageCount: integer read GetPageCount;
    property Pages[Index: integer]: TOnPage read GetPage;
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
    property ONBOTTOMLEFT: TONCUSTOMCROP read FBottomleft write FBottomleft;
    property ONBOTTOMRIGHT: TONCUSTOMCROP read FBottomRight write FBottomRight;
    property ONTOP: TONCUSTOMCROP read FTop write FTop;
    property ONTOPLEFT: TONCUSTOMCROP read FTopleft write FTopleft;
    property ONTOPRIGHT: TONCUSTOMCROP read FTopRight write FTopRight;
    property ONBUTTONAREA: TONCUSTOMCROP read Fbuttonarea write Fbuttonarea;
  published
     btnarea: TonbuttonareaCntrl;
    property ActivePage: TOnPage read FActivePage write SetActivePage;
    property ButtonDirection: TONButtonDirection
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

  TOnpagecontrolEditor = class(TComponentEditor)
  private
    procedure Addpage;
  public
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
    procedure ExecuteVerb(Index: integer); override;
  end;



  { TONPageActivePageProperty }

  TONPageActivePageProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


  { TOnStringProperty }

  TOnStringProperty = class(TStringProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
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

uses  BGRAPath,imgfrm;

const
  StringAddPage = 'New Page';
  StringNextPage = 'Next Page';
  StringPrevPage = 'Previous Page';

procedure Register;
begin
  RegisterComponents('ONUR', [TONPageControl]);
  RegisterClasses([TONPageControl, TOnPage]);
  RegisterNoIcon([TOnPage]);
  RegisterPropertyEditor(TypeInfo(TOnPage), TONPageControl, 'ActivePage',
    TONPageActivePageProperty);
  RegisterComponentEditor(TOnPage, TOnpagecontrolEditor);
  RegisterComponentEditor(TONPageControl, TOnpagecontrolEditor);

  RegisterPropertyEditor(TypeInfo(String),TONImg,'Loadskins', TonimgPropertyEditor);
end;

{ TOnStringProperty }

function TOnStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paReadOnly];
end;

procedure TOnStringProperty.GetValues(Proc: TGetStrProc);
var
    i: Integer;
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
  Result:=GetComponent(0);
end;

{ TonimgPropertyEditor }


procedure TonimgPropertyEditor.Edit;
var
  dlg: TOpenDialog;
begin
  if (GetOnComponent is TONImg) then
  begin
    dlg:=TOpenDialog.Create(nil);
    try
      if dlg.Execute then
      begin
        //(GetOnComponent as TONImg).LoadSkins:=dlg.FileName;
        (GetOnComponent as TONImg).Loadskin(dlg.FileName);

        SetStrValue(dlg.FileName);
      end;
    finally
      dlg.Free;
    end;
 end else
 inherited;
end;

function TonimgPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TonimgPropertyEditor.GetValue: string;
begin
  Result:=inherited GetStrValue;
end;

procedure TonimgPropertyEditor.SetValue(const Value: string);
begin
  //inherited
  SetValue(Value);
end;







function TONPageActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TONPageActivePageProperty.GetValues(Proc: TGetStrProc);
var
  I: integer;
  Component: TComponent;
begin
  if (GlobalDesignHook <> nil) and (GlobalDesignHook.LookupRoot <> nil) and
    (GlobalDesignHook.LookupRoot is TComponent) then
    for I := 0 to TComponent(GlobalDesignHook.LookupRoot).ComponentCount - 1 do
    begin
      Component := TComponent(GlobalDesignHook.LookupRoot).Components[I];
      if (Component.Name <> '') and (Component is TOnPage) and
        (TOnPage(Component).PageControl = GetComponent(0)) then
        Proc(Component.Name);
    end;
end;

{ TOnpagecontrolEditor }

procedure TOnpagecontrolEditor.Addpage;
var
  P: TOnPage;
  C: TOnPagecontrol;
  Hook: TPropertyEditorHook = nil;
begin
  if not GetHook(Hook) then
    Exit;

  if Component is TOnPage then
    c := TOnPage(Component).PageControl
  else
    c := TonPageControl(Component);


  P := TOnPage.Create(C.Owner);
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

function TOnpagecontrolEditor.GetVerb(Index: integer): string;
var
  PageControl: TOnPagecontrol;
begin
  case Index of
    0: Result := StringAddPage;
    1: Result := StringNextPage;
    2: Result := StringPrevPage;
    else
    begin
      Result := '';
      if Component is TOnPage then
        PageControl := TOnPage(Component).PageControl
      else
        PageControl := TOnPageControl(Component);

      if PageControl <> nil then
      begin
        Dec(Index, 3);
        if Index < PageControl.PageCount then
          Result := 'Open ' + PageControl.Pages[Index].Name;
      end;
    end;
  end;
end;

function TOnpagecontrolEditor.GetVerbCount: integer;
var
  PageControl: TOnPageControl;
  PageCount: integer;
begin
  PageCount := 0;
  if Component is TOnPage then
    PageControl := TOnPage(Component).PageControl
  else
    PageControl := TOnPageControl(Component);

  if PageControl <> nil then
    PageCount := PageControl.PageCount;


  Result := 3 + PageCount;
end;

procedure TOnpagecontrolEditor.ExecuteVerb(Index: integer);
var
  PageControl: TONPageControl;
  Page: TOnPage;
  //Hook: TPropertyEditorHook;
begin
  if Component is TOnPage then
    PageControl := TOnPage(Component).PageControl
  else
    PageControl := TonPageControl(Component);
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
        if Component is TOnPage then
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
          if Component is TOnPage then
            GetDesigner.SelectOnlyThisComponent(Page);
          GetDesigner.Modified;
        end;
      end;
    end;
  end;
end;




{ TONPageControl }


constructor TONPageControl.Create(AOwner: TComponent);
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
  Fbuttonarea := TONCUSTOMCROP.Create;
  Fbuttonarea.cropname := 'BUTTONAREA';



  btnarea := TonbuttonareaCntrl.Create(self);
  btnarea.Parent := self;
  //  btnarea.Skindata:=nil;//self.Skindata;
  btnarea.Height := 30;
  btnarea.Align := alTop;
  Captionvisible := False;
 // ChildSizing.VerticalSpacing:=3;
end;

destructor TONPageControl.Destroy;
var
  A: integer;
begin
  for A := FPages.Count - 1 downto 0 do
    Pages[A].Free;

  FPages.Free;
  FreeAndNil(FTop);
  FreeAndNil(FBottom);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(Fbuttonarea);
  btnarea.Free;

  inherited Destroy;
end;


procedure TONPageControl.Paint;
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
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited Paint;
end;

procedure TONPageControl.SetSkindata(Aimg: TONImg);
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


function TONPageControl.NewPage: TOnPage;
begin
  Result := TOnPage.Create(nil);
  Result.PageControl := Self;
  ActivePage := Result;
end;

procedure TONPageControl.InsertPage(Page: TOnPage);
begin
  FPages.Add(Page);
  Page.FPageControl := Self;
  Page.FreeNotification(Self);
end;

procedure TONPageControl.RemovePage(Page: TOnPage);
var
  APage: TONPage;
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



function TONPageControl.GetPage(Index: integer): TOnPage;
begin
  Result := TONPage(FPages[Index]);
end;

function TONPageControl.GetPageCount: integer;
begin
  Result := FPages.Count;
end;

function TONPageControl.GetActivePageIndex: integer;
begin
  if Assigned(FActivePage) then
    Result := FPages.IndexOf(FActivePage)
  else
    Result := -1;
end;


procedure TONPageControl.SetButtonDirection(val: TONButtonDirection);
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

  if FPages.Count>0 then
  for c := 0 to FPages.Count - 1 do
    Pages[c].Getposition;

  Invalidate;
end;


procedure TONPageControl.buttonclicke(Sender: TObject);
var
  i: integer;
begin
  i := TONPageButton(Sender).Tag;
  if GetActivePageIndex = i then exit;
  SetActivePageIndex(i);
end;

procedure TONPageControl.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
   inherited GetChildren(Proc, Root);
end;

procedure TONPageControl.SetChildOrder(Child: TComponent; Order: integer);
begin
  inherited SetChildOrder(Child, Order);
  TOnPage(Child).PageOrderIndex := Order;
end;

procedure TONPageControl.ShowControl(AControl: TControl);
begin
  if (AControl is TOnPage) and (TOnPage(AControl).PageControl = Self) then
    SetActivePage(TOnPage(AControl));
  inherited ShowControl(AControl);
end;

procedure TONPageControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (AComponent is TOnPage) and (TOnPage(AComponent).PageControl = Self) then
      RemovePage(TOnPage(AComponent));
  end;
end;


procedure TONPageControl.SetActivePage(Page: TOnPage);
var
  AOldPage: TOnPage;
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
          AOldPage.Fbutton.Enabled:=True;
          FActivePage.Fbutton.Enabled:=false;
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
        FActivePage.Fbutton.Enabled:=false;
        APageChanged := True;
      end;
    end;
  end;
  if APageChanged then DoPageChanged;

end;

procedure TONPageControl.SetActivePageIndex(PageIndex: integer);
begin
  if not (csLoading in ComponentState) then
    SetActivePage(Pages[PageIndex]);
end;

procedure TONPageControl.DoPageChanged;
begin
  if not (csDestroying in ComponentState) and Assigned(FPageChanged) then
    FPageChanged(Self);
end;

function TONPageControl.DoPageChanging(NewPageIndex: integer): boolean;
begin
  Result := True;
  if Assigned(FPageChanging) then
    FPageChanging(Self, NewPageIndex, Result);
end;



function TONPageControl.FindNextPage(CurPage: TOnPage; GoForward: boolean): TOnPage;
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

procedure TONPageControl.SelectNextPage(GoForward: boolean);
begin
  SetActivePage(FindNextPage(ActivePage, GoForward));
end;


{ TONPages }

constructor TONPage.Create(AOwner: TComponent);
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
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'PAGETOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'PAGEBOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'PAGECENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'PAGERIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'PAGETOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'PAGEBOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'PAGELEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'PAGETOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'PAGEBOTTOMLEFT';
  resim.SetSize(190, 190);
end;

destructor TONPage.Destroy;
begin
  FreeAndNil(FTop);
  FreeAndNil(FBottom);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(Fleft);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(Fbutton);
  inherited Destroy;
end;


function TONPage.GetPageOrderIndex: integer;
begin
  if FPageControl <> nil then
    Result := FPageControl.FPages.IndexOf(Self)
  else
    Result := -1;

end;

function TONPage.getbutonw: integer;
begin
  if Assigned(Fbutton) then
  Result:=Fbutton.Width;
end;

function TONPage.GetAutoWidth: boolean;
begin
  if Assigned(Fbutton) then
  result:=Fbutton.AutoWidth;
end;

procedure TONPage.SetAutoWidth(AValue: boolean);
begin
  if Assigned(Fbutton) then
Fbutton.AutoWidth:=AValue;
end;

procedure TONPage.SetButtonwidth(AValue: integer);
begin
 if Assigned(Fbutton) then
 begin
   if Fbutton.Width=AValue then exit;
   Fbutton.Width:=AValue;
 end;
end;


procedure TONPage.Getposition;
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
      Width := FPageControl.Width - (FPageControl.Fleft.Width + FPageControl.FRight.Width);
      Height := FPageControl.Height -
        (FPageControl.FTop.Height + FPageControl.FBottom.Height + FPageControl.btnarea.Height);
    end;
    obdown:
    begin
      Fbutton.Align := alLeft;
      Fbutton.Width := 100;
      Fbutton.Font.Orientation := 0;
      left := FPageControl.Fleft.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width - (FPageControl.Fleft.Width + FPageControl.FRight.Width);
      Height := FPageControl.Height -
        (FPageControl.FTop.Height + FPageControl.FBottom.Height + FPageControl.btnarea.Height);
    end;
    obleft:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;              //  Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Width + FPageControl.btnarea.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width -
        (FPageControl.Fleft.Width + FPageControl.FRight.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height -
        (FPageControl.FTop.Height + FPageControl.FBottom.Height);
    end;
    obright:
    begin
      Fbutton.Font.Orientation := 900;
      Fbutton.Height := 100;   // Fbutton.Width:=FPageControl.btnarea.Width;

      Fbutton.Align := altop;
      left := FPageControl.Fleft.Width;
      top := FPageControl.FTop.Height;
      Width := FPageControl.Width -
        (FPageControl.Fleft.Width + FPageControl.FRight.Width + FPageControl.btnarea.Width);
      Height := FPageControl.Height -
        (FPageControl.FTop.Height + FPageControl.FBottom.Height);
    end;
  end;
end;




procedure TONPage.SetCaption(AValue: TCaption);
begin
  if Fcaption = AValue then Exit;
  Fcaption := AValue;
  if Assigned(Fbutton) then
    fbutton.Caption := AValue;

end;



procedure TONPage.SetPageControl(ANotebookControl: TONPageControl);
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

      Fbutton := TONPageButton.Create(self);

      with fbutton do
      begin
        parent := FPageControl.btnarea;
        align := alleft;
        tag := self.GetPageOrderIndex;
        OnClick := @self.FPageControl.buttonclicke;
        Caption := self.Caption;
        AutoWidth:=self.AutoCaptionWidth;
       // BorderSpacing.Bottom:=5;
      end;
      Skindata := FPageControl.Skindata;
      Getposition;
      Invalidate;

    end;
  end;

end;

procedure TONPage.SetPageOrderIndex(Value: integer);
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

procedure TONPage.SetSkindata(Aimg: TONImg);
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
    Rect(self.clientWidth - (FPageControl.FBottomRight.Width), self.clientHeight -
    FPageControl.FBottomRight.Height, self.clientWidth, self.clientHeight);
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
    Rect(FPageControl.Fleft.Width, FPageControl.FTop.Height, self.clientWidth -
    FPageControl.FRight.Width, self.clientHeight - FPageControl.FBottom.Height);

  Fbutton.Skindata := Aimg;
end;




procedure TONPage.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TONPageControl then
    PageControl := TONPageControl(Reader.Parent);

end;

procedure TONPage.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) and not Visible then
    SendToBack;
end;



procedure TONPage.Paint;
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
    resim.Fill(BGRA(140, 170, 140,alpha), dmSet);
  end;
  inherited Paint;
end;




procedure TONPageButton.MouseEnter;
begin
  if (csDesigning in ComponentState) then
    exit;
  if (Enabled = False) or (Fstate = obshover) then
    Exit;

  inherited MouseEnter;
  Fstate := obshover;
  Invalidate;
end;


procedure TONPageButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONPageButton.MouseLeave;
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
procedure TONPageButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

constructor TONPageButton.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  Width := 100;
  Height := 30;
  FAutoWidth := True;
  Fstate := obsNormal;
  Skinname := 'pagecontrol';
  FNormal := TONCustomCrop.Create;
  FNormal.cropname := 'BUTTONNORMAL';
  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'BUTTONDOWN';
  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'BUTTONHOVER';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'BUTTONDISABLE';
end;

// -----------------------------------------------------------------------------

destructor TONPageButton.Destroy;
begin
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited Destroy;
end;

procedure TONPageButton.CheckAutoWidth;
var
  a:Tsize;
begin
  if FAutoWidth and Assigned(resim) then
  begin
//    resim.FontName:=self.parent.font.Name;
//    resim.FontHeight:=self.parent.Font.Height;

   a:= resim.TextSize(Caption);
   resim.SetSize(a.cX,self.Height);
   Width := a.cx;// resim.Width;
  // Height :=a.cy;// resim.Height;
{  end else
  begin
   Width :=  resim.Width;
   Height := resim.Height;   }
  end;
end;



procedure TONPageButton.SetAutoWidth(const Value: boolean);
begin
  FAutoWidth := Value;
  CheckAutoWidth;
end;

procedure TONPageButton.Paint;
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
    resim.Fill(BGRA(100, 150, 100,alpha), dmSet);
  end;

  inherited Paint;
end;


{ TonbuttonareaCntrl }



constructor TonbuttonareaCntrl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  Width := 50;
  Height := 50;
  Skinname := 'pagecontrol';
  Fbttnarea := TONCustomCrop.Create;
  Fbttnarea.cropname := 'BUTTONAREA';
end;

destructor TonbuttonareaCntrl.Destroy;
begin
  FreeAndNil(Fbttnarea);
  inherited Destroy;
end;

procedure TonbuttonareaCntrl.Paint;
begin
  if not Visible then exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
    DrawPartnormal(Fbttnarea.Croprect, self, rect(0, 0, self.clientWidth,
      self.clientHeight), Alpha)
  else
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);

  inherited Paint;
end;

end.

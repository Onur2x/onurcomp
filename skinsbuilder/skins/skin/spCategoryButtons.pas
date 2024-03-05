{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spCategoryButtons;

{$IFDEF VER230}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER220}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200}
{$ENDIF}

interface

uses
  Windows, SysUtils, Classes, Controls, ImgList, Forms, Messages,
  Graphics, StdCtrls, ActnList, SkinData, SkinCtrls,  ExtCtrls,
  spUtils;

const
  crDragCopy = TCursor(-23); { New cursor, with a plus for copying }

type
  TspBaseButtonItem = class;
  TspBaseButtonItemClass = class of TspBaseButtonItem;
  TspButtonItem = class;
  TspButtonItemClass = class of TspButtonItem;
  TspButtonCategory = class;
  TspButtonCategoryClass = class of TspButtonCategory;
  TspButtonCategories = class;
  TspButtonCategoriesClass = class of TspButtonCategories;
  TspButtonItemActionLink = class;
  TspButtonItemActionLinkClass = class of TspButtonItemActionLink;

  { TButtonDrawState }
  {
    bsbdsSelected:    Item is selected and in the "down" state
    bsbdsHot:         Item has the mouse over it
    bsbdsFocused:     Item should show focus
    bsbdsDown:        Item is being pressed by the user
    bsbdsDragged:     The drag image for that button is being drawn
    bsbdsInsertLeft:  Show that an item can be inserted to the left of this item
    bdsInsertTop:   Show that an item can be inserted above this item
    bsbdsInsertRight: Show that an item can be inserted to the right of this item
    bsbdsInsertBottom: Show that an item can be inserted below this item
  }
  
  TspButtonDrawState = set of (spbdsSelected, spbdsHot, spbdsFocused, spbdsDown,
    spbdsDragged, spbdsInsertLeft, spbdsInsertTop, spbdsInsertRight, spbdsInsertBottom);

  TspCatButtonOptions = set of (spboAllowReorder, spboAllowCopyingButtons,
    spboFullSize, spboShowCaptions, spboVerticalCategoryCaptions, spboBoldCaptions,
    spboUsePlusMinus);

  TspCatButtonEvent = procedure(Sender: TObject; const Button: TspButtonItem) of object;
  TspCatButtonGetHint = procedure(Sender: TObject; const Button: TspButtonItem;
    const Category: TspButtonCategory; var HintStr: string; var Handled: Boolean) of object;

  TspCatButtonDrawEvent = procedure(Sender: TObject;
    const Button: TspButtonItem; Canvas: TCanvas; Rect: TRect;
    State: TspButtonDrawState) of object;
  TspCatButtonDrawIconEvent = procedure(Sender: TObject;
    const Button: TspButtonItem; Canvas: TCanvas; Rect: TRect;
    State: TspButtonDrawState; var TextOffset: Integer) of object;
  TspCatButtonReorderEvent = procedure(Sender: TObject; const Button: TspButtonItem;
    const SourceCategory, TargetCategory: TspButtonCategory) of object;
  TspCatButtonCopyEvent = procedure(Sender: TObject;
    const SourceButton, CopiedButton: TspButtonItem) of object;
  TspCategoryReorderEvent = procedure(Sender: TObject; const SourceCategory,
    TargetCategory: TspButtonCategory) of object;
  TspCategoryCollapseEvent = procedure(Sender: TObject;
    const Category: TspButtonCategory) of object;

  TspCatButtonFlow = (bscbfVertical, bscbfHorizontal);

  TspSkinCategoryButtons = class(TspSkinControl)
  private
    FIs9XOS: Boolean;
    FMouseTimer: TTimer;
    FButtonsSkinDataName: String;
    FCategorySkinDataName: String;
    FShowBorder: Boolean;
    FSkinScrollBar: TspSkinScrollBar;
    FButtonFlow: TspCatButtonFlow;
    FCollapsedHeight: Integer;
    FDownButton: TspButtonItem;
    FDragButton: TspButtonItem;
    FDragCategory: TspButtonCategory;
    FDragStartPos: TPoint;
    FDragStarted: Boolean;
    FDragImageList: TDragImageList;
    FGutterSize: Integer; { Also, used as the scroll size }
    FSideBufferSize: Integer;
    FHotButton: TspButtonItem;
    FImageChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FInsertLeft, FInsertTop, FInsertRight, FInsertBottom: TspButtonItem;
    FIgnoreUpdate: Boolean;
    FScrollBarMax: Integer;
    FSCROLLBARPOS: Integer;
    FPageAmount: Integer;
    FButtonCategories: TspButtonCategories;
    FButtonOptions: TspCatButtonOptions;
    FButtonWidth, FButtonHeight: Integer;
    FSelectedItem: TspButtonItem;
    FFocusedItem: TspButtonItem;
    FMouseInControl: Boolean;
    FOnButtonClicked: TspCatButtonEvent;
    FOnCopyButton: TspCatButtonCopyEvent;
    FOnSelectedItemChange: TspCatButtonEvent;
    FOnHotButton: TspCatButtonEvent;
    FOnGetHint: TspCatButtonGetHint;
    FOnDrawButton: TspCatButtonDrawEvent;
    FOnBeforeDrawButton: TspCatButtonDrawEvent;
    FOnAfterDrawButton: TspCatButtonDrawEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnReorderButton: TspCatButtonReorderEvent;
    FOnReorderCategory: TspCategoryReorderEvent;
    FOnCategoryCollapase: TspCategoryCollapseEvent;
    FOnClick: TNotifyEvent;
    FHotButtonColor, FSelectedButtonColor, FRegularButtonColor: TColor;
    FUseSkinFont: Boolean;
    //
    procedure OnMouseTimerEvent(Sender: TObject);
    procedure AdjustScrollBar;
    function GetScrollSize: Integer;
    procedure SBChange(Sender: TObject);
    procedure SBUpClick(Sender: TObject);
    procedure SBDownClick(Sender: TObject);
    procedure SBPageUp(Sender: TObject);
    procedure SBPageDown(Sender: TObject);
    //
    procedure AutoScroll(ScrollCode: TScrollCode);
    procedure ImageListChange(Sender: TObject);
    function CalcButtonsPerRow: Integer;
    function CalcButtonsPerCol: Integer;
    procedure CalcBufferSizes;
    function CalcCategoryHeight(const Category: TspButtonCategory;
      const ButtonsPerRow: Integer): Integer;
    function CalcCategoryWidth(const Category: TspButtonCategory;
      const ButtonsPerCol: Integer): Integer;

    procedure DrawCategory(const Category: TspButtonCategory;
      const Canvas: TCanvas; StartingPos: Integer);

    procedure DrawSkinCategory(const Category: TspButtonCategory;
      const Canvas: TCanvas; StartingPos: Integer);

    procedure GetCategoryBounds(const Category: TspButtonCategory;
      const StartingPos: Integer; var CategoryBounds,
      ButtonBounds: TRect);
    function GetChevronBounds(const CategoryBounds: TRect): TRect;
    function GetIndexOfFirstCategory: Integer;
    function GetNextButtonInGroup(const StartingButton: TspButtonItem;
      GoForward: Boolean): TspButtonItem;
    function GetNextButton(const StartingButton: TspButtonItem;
      GoForward: Boolean): TspButtonItem;
    function GetScrollOffset: Integer;
    function GetScrollBuffer: Integer;
    procedure ScrollPosChanged(ScrollCode: TScrollCode;
      ScrollPos: Integer);
    procedure SetOnDrawButton(const Value: TspCatButtonDrawEvent);
    procedure SetButtonCategories(const Value: TspButtonCategories);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetCatButtonOptions(const Value: TspCatButtonOptions);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetFocusedItem(const Value: TspButtonItem);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetSelectedItem(const Value: TspButtonItem);
    procedure ShowSkinScrollBar(const Visible: Boolean);
    procedure SetHotButtonColor(const Value: TColor);
    procedure SetRegularButtonColor(const Value: TColor);
    procedure SetSelectedButtonColor(const Value: TColor);
    procedure SetButtonFlow(const Value: TspCatButtonFlow);
    function ShouldScrollDown(out Delay: Integer): Boolean;
    function ShouldScrollUp(out Delay: Integer): Boolean;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CNKeydown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure SetDragButton(const Value: TspButtonItem);
    procedure SetShowBorder(Value: Boolean);
  protected
    procedure PaintBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintSkinBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintDefaultBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure BeginAutoDrag; override;
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoBeginDrag(Immediate: Boolean; Threshold: Integer); virtual;
    procedure DoCopyButton(const Button: TspButtonItem;
      const TargetCategory: TspButtonCategory; const TargetButton: TspButtonItem); dynamic;
    procedure DoEndDrag(Target: TObject; X: Integer; Y: Integer); override;
    procedure DoHotButton; dynamic;
    procedure DoMouseLeave; dynamic;
    procedure DoReorderButton(const Button: TspButtonItem;
      const TargetCategory: TspButtonCategory; const TargetButton: TspButtonItem); dynamic;
    procedure DoReorderCategory(const SourceCategory,
      TargetCategory: TspButtonCategory); dynamic;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X: Integer; Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DrawButton(const Button: TspButtonItem; Canvas: TCanvas;
      Rect: TRect; State: TspButtonDrawState); virtual;
    procedure DrawSkinButton(const Button: TspButtonItem; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState);
     procedure DrawStretchSkinButton(const Button: TspButtonItem; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState);
    procedure DoItemClicked(const Button: TspButtonItem); dynamic;
    procedure DoSelectedItemChanged(const Button: TspButtonItem); dynamic;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetAllowReorder: Boolean; dynamic;
    function GetDragImages: TDragImageList; override;
    function GetButtonCategoriesClass: TspButtonCategoriesClass; virtual;
    function GetButtonCategoryClass: TspButtonCategoryClass; virtual;
    function GetButtonItemClass: TspButtonItemClass; virtual;
    function GetScrollPos: Integer;
    procedure SetScrollPos(const Value: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Resize; override;
    procedure ScrollRectIntoView(const Rect: TRect);
    procedure CMFontchanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMBENCPaint(var Message: TMessage); message CM_BENCPAINT;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Assign(Source: TPersistent); override;
    procedure ChangeSkinData; override;
    { DragButton: If a drag operation is coming from this control, it is
      becuase they are dragging this item, or the category. One can
      write to it if they want to control what button is being dragged. }
    property DragButton: TspButtonItem read FDragButton write SetDragButton;
    property DragCategory: TspButtonCategory read FDragCategory write FDragCategory;
    property DragImageList: TDragImageList read FDragImageList;
    procedure DragDrop(Source: TObject; X: Integer; Y: Integer); override;
    function GetButtonRect(const Button: TspButtonItem): TRect;
    function GetCategoryRect(const Category: TspButtonCategory): TRect;
    function GetButtonAt(X, Y: Integer;
      Category: TspButtonCategory = nil): TspButtonItem;
    function GetCategoryAt(X, Y: Integer): TspButtonCategory;
    procedure RemoveInsertionPoints;
    procedure ScrollIntoView(const Button: TspButtonItem); overload;
    procedure ScrollIntoView(const Category: TspButtonCategory); overload;
    { SetInsertionButton: Call this to set the current insertion "marks".
      Call RemoveInsertionPoints to remove the "marks". }
    procedure SetInsertionButton(InsertionButton: TspButtonItem;
      InsertionCategory: TspButtonCategory);
    { GetTargetAt: Gives you the target insertion point in the given group.
      TargetButton may be nil, while the TargetCategory is not (or, both may be nil)}
    procedure GetTargetAt(X, Y: Integer; var TargetButton: TspButtonItem;
      var TargetCategory: TspButtonCategory);
    procedure UpdateButton(const Button: TspButtonItem);
    procedure UpdateAllButtons;
    property SelectedItem: TspButtonItem read FSelectedItem write SetSelectedItem;
    property FocusedItem: TspButtonItem read FFocusedItem write SetFocusedItem;
  published
    property UsesSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property Align;
    property Anchors;
    property ShowBoder: Boolean read FShowBorder write SetShowBorder;
    property ButtonsSkinDataName: String read FButtonsSkinDataName write FButtonsSkinDataName;
    property CategorySkinDataName: String read FCategorySkinDataName write FCategorySkinDataName;
    property ButtonFlow: TspCatButtonFlow read FButtonFlow write SetButtonFlow;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight default 24;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 24;
    property ButtonOptions: TspCatButtonOptions read FButtonOptions
      write SetCatButtonOptions default [spboShowCaptions, spboVerticalCategoryCaptions];
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height default 100;
    property Images: TCustomImageList read FImages write SetImages;
    property Categories: TspButtonCategories read FButtonCategories write SetButtonCategories;
    property Color default clWindow;
    property Cursor;
    property HotButtonColor: TColor read FHotButtonColor write SetHotButtonColor default $00EFD3C6;
    property PopupMenu;
    property RegularButtonColor: TColor read FRegularButtonColor write SetRegularButtonColor nodefault;
    property SelectedButtonColor: TColor read FSelectedButtonColor write SetSelectedButtonColor nodefault;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Width default 100;
    property Visible;
    property OnAfterDrawButton: TspCatButtonDrawEvent read FOnAfterDrawButton write FOnAfterDrawButton;
    property OnBeforeDrawButton: TspCatButtonDrawEvent read FOnBeforeDrawButton write FOnBeforeDrawButton;
    property OnButtonClicked: TspCatButtonEvent read FOnButtonClicked write FOnButtonClicked;
    property OnCategoryCollapase: TspCategoryCollapseEvent read FOnCategoryCollapase write FOnCategoryCollapase;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnContextPopup;
    property OnCopyButton: TspCatButtonCopyEvent read FOnCopyButton write FOnCopyButton;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawButton: TspCatButtonDrawEvent read FOnDrawButton write SetOnDrawButton;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetHint: TspCatButtonGetHint read FOnGetHint write FOnGetHint;
    property OnHotButton: TspCatButtonEvent read FOnHotButton write FOnHotButton;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnReorderButton: TspCatButtonReorderEvent read FOnReorderButton write FOnReorderButton;
    property OnReorderCategory: TspCategoryReorderEvent read FOnReorderCategory write FOnReorderCategory;
    property OnMouseDown;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnSelectedItemChange: TspCatButtonEvent read FOnSelectedItemChange write FOnSelectedItemChange;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspBaseButtonItem = class(TCollectionItem)
  private
    FActionLink: TspButtonItemActionLink;
    FImageIndex: TImageIndex;
    FCaption: string;
    FData: Pointer;
    FHint: string;
    {$IFDEF VER200}
    FInterfaceData: IInterface;
    {$ENDIF}
    FOnClick: TNotifyEvent;
    procedure SetAction(const Value: TBasicAction);
    procedure SetCaption(const Value: string);
    procedure SetImageIndex(const Value: TImageIndex);
    function GetAction: TBasicAction;
    procedure DoActionChange(Sender: TObject);
    function IsCaptionStored: Boolean;
    function IsHintStored: Boolean;
    function IsImageIndexStored: Boolean;
    function IsOnClickStored: Boolean;
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); virtual;
    function GetNotifyTarget: TComponent; virtual; abstract;
    function GetDisplayName: string; override;
    function GetActionLinkClass: TspButtonItemActionLinkClass; virtual;
    property ActionLink: TspButtonItemActionLink read FActionLink write FActionLink;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure ScrollIntoView; virtual; abstract;
    property Data: Pointer read FData write FData;
    {$IFDEF VER200}
    property InterfaceData: IInterface read FInterfaceData write FInterfaceData;
    {$ENDIF}
  published
    property Action: TBasicAction read GetAction write SetAction;
    property Caption: string read FCaption write SetCaption stored IsCaptionStored;
    property Hint: string read FHint write FHint stored IsHintStored;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
  end;

  TspButtonItem = class(TspBaseButtonItem)
  private
    function GetButtonGroup: TspSkinCategoryButtons;
    function GetCategory: TspButtonCategory;
  protected
    function GetNotifyTarget: TComponent; override;
  public
    procedure Assign(Source: TPersistent); override;
    procedure ScrollIntoView; override;
    property Category: TspButtonCategory read GetCategory;
  published
    property ButtonGroup: TspSkinCategoryButtons read GetButtonGroup;
  end;

  TspButtonCollection = class(TCollection)
  private
    FCategory: TspButtonCategory;
    function GetItem(Index: Integer): TspButtonItem;
    procedure SetItem(Index: Integer; const Value: TspButtonItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
{    procedure Notify(Item: TCollectionItem;
      Action: TCollectionNotification); override;}
  public
    constructor Create(const ACategory: TspButtonCategory);
    function Add: TspButtonItem;
    function AddItem(Item: TspButtonItem; Index: Integer): TspButtonItem;
    function Insert(Index: Integer): TspButtonItem;
    property Items[Index: Integer]: TspButtonItem read GetItem write SetItem; default;
    property Category: TspButtonCategory read FCategory;
  end;

  TspButtonCategory = class(TCollectionItem)
  private
    FCaption: string;
    FCollapsed: Boolean;
    FItems: TspButtonCollection;
    FStart: Integer;
    FEnd: Integer;
    FData: Pointer;
    {$IFDEF VER200}
    FInterfaceData: IInterface;
    {$ENDIF}
    function GetCategories: TspButtonCategories;
    procedure SetItems(const Value: TspButtonCollection);
    procedure SetCollapsed(const Value: Boolean);
    procedure SetCaption(const Value: string);
  protected
    procedure SetIndex(Value: Integer); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure ScrollIntoView;
    function IndexOf(const Caption: string): Integer;
    property Categories: TspButtonCategories read GetCategories;
    property Data: Pointer read FData write FData;
    {$IFDEF VER200}
    property InterfaceData: IInterface read FInterfaceData write FInterfaceData;
    {$ENDIF}
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write SetCaption;
    property Collapsed: Boolean read FCollapsed write SetCollapsed;
    property Items: TspButtonCollection read FItems write SetItems;
  end;

  TspButtonCategories = class(TCollection)
  private
    FButtonGroup: TspSkinCategoryButtons;
    FOriginalID: Integer;
    function GetItem(Index: Integer): TspButtonCategory;
    procedure SetItem(Index: Integer; const Value: TspButtonCategory);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(const ButtonGroup: TspSkinCategoryButtons);
    function Add: TspButtonCategory;
    function AddItem(Item: TspButtonCategory; Index: Integer): TspButtonCategory;
    procedure BeginUpdate; override;
    function Insert(Index: Integer): TspButtonCategory;
    function IndexOf(const Caption: string): Integer;
    property Items[Index: Integer]: TspButtonCategory read GetItem write SetItem; default;
    property ButtonGroup: TspSkinCategoryButtons read FButtonGroup;
  end;

{ TspButtonItemActionLink }

  TspButtonItemActionLink = class(TActionLink)
  protected
    FClient: TspBaseButtonItem;
    procedure AssignClient(AClient: TObject); override;
    function IsCaptionLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  public
    function DoShowHint(var HintStr: string): Boolean; virtual;
  end;

implementation

{$R spCategoryButtons.res} { Contains the Copy DragCursor }

{ TspSkinCategoryButtons }

constructor TspSkinCategoryButtons.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIs9XOS := Is9XOs;
  if FIs9XOS
  then
    begin
      FMouseTimer := TTimer.Create(Self);
      FMouseTimer.Enabled := False;
      FMouseTimer.Interval := 100;
      FMouseTimer.OnTimer := OnMouseTimerEvent;
    end;
  FButtonsSkinDataName := 'resizetoolbutton';
  FCategorySkinDataName := 'resizetoolpanel';
  FUseSkinFont := True;
  Font.Name := 'Tahoma';
  FShowBorder := False;
  FScrollBarPos := 0;
  Width := 100;
  Height := 100;
  ControlStyle := [csDoubleClicks, csCaptureMouse, csDisplayDragImage, csAcceptsControls];
  FSkinScrollBar := nil;
  FButtonCategories := GetButtonCategoriesClass.Create(Self);
  FButtonWidth := 24;
  FButtonHeight := 24;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FDoubleBuffered := True;
  FDragImageList := TDragImageList.Create(nil);
  FButtonOptions := [spboShowCaptions, spboVerticalCategoryCaptions];
  FHotButtonColor := SP_XP_BTNACTIVECOLOR;
  TabStop := True;
end;

procedure TspSkinCategoryButtons.OnMouseTimerEvent(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  if WindowFromPoint(P) <> Self.Handle
  then
    begin
      FMouseTimer.Enabled := False;
      SendMessage(Handle, WM_MOUSELEAVE, 0, 0);
    end;
end;

procedure TspSkinCategoryButtons.WMNCPAINT(var Message: TMessage);
begin
  if FShowBorder
  then
    PaintBorder(0, False)
  else
    inherited;
end;

procedure TspSkinCategoryButtons.PaintBorder;
begin
  if (SkinData <> nil) and (not SkinData.Empty) and
     (SkinData.GetControlIndex('panel') <> -1)
  then
    PaintSkinBorder(ADC, AUseExternalDC)
  else
    PaintDefaultBorder(ADC, AUseExternalDC);
end;

procedure TspSkinCategoryButtons.PaintDefaultBorder;
var
  DC: HDC;
  Cnvs: TControlCanvas;
  R: TRect;
begin

  if not AUseExternalDC
  then
    DC := GetWindowDC(Handle)
  else
    DC := ADC;

  Cnvs := TControlCanvas.Create;
  Cnvs.Handle := DC;
  R := Rect(0, 0, Width, Height);
  InflateRect(R, -2, -2);

  if R.Bottom > R.Top
  then
    ExcludeClipRect(Cnvs.Handle,R.Left, R.Top, R.Right, R.Bottom);

  with Cnvs do
  begin
    Pen.Color := clBtnShadow;
    Brush.Style := bsClear;
    Rectangle(0, 0, Width, Height);
    Pen.Color := clBtnFace;
    Rectangle(1, 1, Width - 1, Height - 1);
  end;

  Cnvs.Handle := 0;

  if not AUseExternalDC
  then
   ReleaseDC(Handle, DC);

  Cnvs.Free;
end;


procedure TspSkinCategoryButtons.PaintSkinBorder;
var
  LeftBitMap, TopBitMap, RightBitMap, BottomBitMap: TBitMap;
  DC: HDC;
  Cnvs: TControlCanvas;
  OX, OY: Integer;
  PanelData: TspDataSkinPanelControl;
  CIndex: Integer;
  FSkinPicture: TBitMap;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewClRect: TRect;
begin
  CIndex := SkinData.GetControlIndex('panel');
  PanelData := TspDataSkinPanelControl(SkinData.CtrlList[CIndex]);

  if not AUseExternalDC
  then
    DC := GetWindowDC(Handle)
  else
    DC := ADC;

  Cnvs := TControlCanvas.Create;
  Cnvs.Handle := DC;
  LeftBitMap := TBitMap.Create;
  TopBitMap := TBitMap.Create;
  RightBitMap := TBitMap.Create;
  BottomBitMap := TBitMap.Create;
  //
  with PanelData do
  begin
  OX := Width - RectWidth(SkinRect);
  OY := Height - RectHeight(SkinRect);
  NewLTPoint := LTPoint;
  NewRTPoint := Point(RTPoint.X + OX, RTPoint.Y);
  NewLBPoint := Point(LBPoint.X, LBPoint.Y + OY);
  NewRBPoint := Point(RBPoint.X + OX, RBPoint.Y + OY);
  NewClRect := Rect(ClRect.Left, ClRect.Top,
    ClRect.Right + OX, ClRect.Bottom + OY);
  //
  FSkinPicture := TBitMap(FSD.FActivePictures.Items[panelData.PictureIndex]);
  CreateSkinBorderImages(LTPoint, RTPoint, LBPoint, RBPoint, ClRect,
      NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftBitMap, TopBitMap, RightBitMap, BottomBitMap,
      FSkinPicture, SkinRect, Width, Height,
      LeftStretch, TopStretch, RightStretch, BottomStretch);
  end;
  if NewClRect.Bottom > NewClRect.Top
  then
    ExcludeClipRect(Cnvs.Handle,
      NewClRect.Left, NewClRect.Top, NewClRect.Right, NewClRect.Bottom);

  Cnvs.Draw(0, 0, TopBitMap);
  Cnvs.Draw(0, TopBitMap.Height, LeftBitMap);
  Cnvs.Draw(Width - RightBitMap.Width, TopBitMap.Height, RightBitMap);
  Cnvs.Draw(0, Height - BottomBitMap.Height, BottomBitMap);
  //
  TopBitMap.Free;
  LeftBitMap.Free;
  RightBitMap.Free;
  BottomBitMap.Free;
  Cnvs.Handle := 0;
  if not AUseExternalDC
  then
    ReleaseDC(Handle, DC);
  Cnvs.Free;
end;


procedure TspSkinCategoryButtons.WMSIZE;
begin
  inherited;
  if FShowBorder then PaintBorder(0, False);
end;

procedure TspSkinCategoryButtons.WMNCCALCSIZE;
var
  PanelData: TspDataSkinPanelControl;
  CIndex: Integer;
begin
  if FShowBorder
  then
    begin
      if (SkinData <> nil) and (not SkinData.Empty) and
         (SkinData.GetControlIndex('panel') <> -1)
      then
        begin
          CIndex := SkinData.GetControlIndex('panel');
          PanelData := TspDataSkinPanelControl(SkinData.CtrlList[CIndex]);
          with PanelData, TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
          begin
            Inc(Left, ClRect.Left);
            Inc(Top,  ClRect.Top);
            Dec(Right, RectWidth(SkinRect) - ClRect.Right);
            Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
            if Right < Left then Right := Left;
            if Bottom < Top then Bottom := Top;
          end;
        end
      else
        begin
          with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
          begin
            Inc(Left, 2);
            Inc(Top,  2);
            Dec(Right, 2);
            Dec(Bottom, 2);
            if Right < Left then Right := Left;
            if Bottom < Top then Bottom := Top;
          end;
        end;
    end
  else
    inherited;
end;

procedure TspSkinCategoryButtons.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Message.DC);
end;

procedure TspSkinCategoryButtons.SetShowBorder;
begin
  if FShowBorder <> Value
  then
    begin
      FShowBorder := Value;
      RecreateWnd;
      AdjustScrollBar;
      Resize;
    end;
end;

procedure TspSkinCategoryButtons.ChangeSkinData;
begin
  FSkinDataName := '';
  inherited;

  if FSkinScrollBar <> nil
  then
    begin
      FSkinScrollBar.SkinData := Self.Skindata;
    end;

  if FShowBorder then ReCreateWnd;

  Resize;

  if FSkinScrollBar <> nil
  then
    begin
      AdjustScrollBar;
    end;
end;


function TspSkinCategoryButtons.GetScrollSize: Integer;
begin
  if FSkinScrollBar = nil then Result := 0
  else
    if FButtonFlow = bscbfVertical
    then
      Result := FSkinScrollBar.Width
    else
      Result := FSkinScrollBar.Height;
end;

procedure TspSkinCategoryButtons.SetBounds;
begin
  inherited;
  if HandleAllocated then 
  if ((FButtonWidth > 0) or (spboFullSize in FButtonOptions)) and (FButtonHeight > 0)
  then
    begin
      Resize;
      AdjustScrollBar;
    end;
end;

procedure TspSkinCategoryButtons.CMSENCPaint(var Message: TMessage);
begin
  if (Message.wParam <> 0) and Self.FShowBorder
  then
    begin
      Self.PaintBorder(Message.wParam, True);
      Message.Result := SE_RESULT;
    end
  else
    Message.Result := 0;
end;

procedure TspSkinCategoryButtons.CMBENCPAINT;
begin
  if (Message.LParam = BE_ID)
  then
    begin
      if (Message.wParam <> 0) and Self.FShowBorder
      then
        Self.PaintBorder(Message.wParam, True);
      Message.Result := BE_ID;
    end
  else
    inherited;
end;

procedure TspSkinCategoryButtons.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

destructor TspSkinCategoryButtons.Destroy;
begin
  if FSkinScrollBar <> nil then FSkinScrollBar.Free;
  if FIs9XOS then FMouseTimer.Free;
  FSkinScrollBar := nil;
  FDragImageList.Free;
  FButtonCategories.Free;
  FImageChangeLink.Free;
  inherited;
end;

procedure TspSkinCategoryButtons.AdjustScrollBar;
begin
  if FSkinScrollBar = nil then Exit;
  with  FSkinScrollBar do
  begin
  if (FButtonFlow = bscbfVertical) and (Kind <> sbVertical)
    then
      begin
        Kind := sbVertical;
        SkinDataName := 'vscrollbar';
      end
    else
    if (FButtonFlow =  bscbfHorizontal) and (Kind <> sbHorizontal)
    then
      begin
        Kind := sbHorizontal;
        SkinDataName := 'hscrollbar';
      end;
    if (FButtonFlow = bscbfVertical)
    then
      begin
        DefaultHeight := 0;
        DefaultWidth := 19;
      end
    else
      begin
        DefaultHeight := 19;
        DefaultWidth := 0;
      end;
  end;
  if (FButtonFlow = bscbfVertical)
  then
   begin
      FSkinScrollBar.SetBounds(ClientWidth - FSkinScrollBar.Width, 0,
         FSkinScrollBar.Width, ClientHeight);
    end
  else
    begin
      FSkinScrollBar.SetBounds(0, ClientHeight - FSkinScrollBar.Height,
        ClientWidth, FSkinScrollBar.Height);
    end;
  if not FSkinScrollBar.Visible then FSkinScrollBar.Visible := True;
end;


function TspSkinCategoryButtons.GetScrollOffset: Integer;
begin
  Result := FScrollBarPos * FGutterSize;
end;

function TspSkinCategoryButtons.GetButtonRect(const Button: TspButtonItem): TRect;
var
  ButtonsPerRow: Integer;
  Row, Col: Integer;
  StartingPos: Integer;
  CategoryBounds, ButtonBounds: TRect;
begin
  { Translate the current virtual position to the actual position }
  StartingPos := Button.Category.FStart - GetScrollOffset;
  GetCategoryBounds(Button.Category, StartingPos, CategoryBounds, ButtonBounds);

  if FButtonFlow = bscbfVertical then
    ButtonsPerRow := CalcButtonsPerRow
  else
    ButtonsPerRow := (ButtonBounds.Right - ButtonBounds.Left) div FButtonWidth;
  Row := Button.Index div ButtonsPerRow;
  Result.Top := ButtonBounds.Top + Row * FButtonHeight;
  if (FButtonFlow = bscbfVertical) and (spboFullSize in FButtonOptions) then
  begin
    Result.Left := ButtonBounds.Left;
    Result.Right := ButtonBounds.Right - 5;
  end
  else
  begin
    Col := Button.Index mod ButtonsPerRow;
    Result.Left := ButtonBounds.Left + Col*FButtonWidth;
    Result.Right := Result.Left + FButtonWidth;
  end;
  Result.Bottom := Result.Top + FButtonHeight;
end;

procedure TspSkinCategoryButtons.ImageListChange(Sender: TObject);
begin
  UpdateAllButtons;
end;

procedure TspSkinCategoryButtons.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I, J: Integer;
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if AComponent = Images then
      Images := nil
    else
      if AComponent is TBasicAction then
        for I := 0 to FButtonCategories.Count - 1 do
          for J := 0 to FButtonCategories[I].Items.Count - 1 do
            if AComponent = FButtonCategories[I].Items[J].Action then
              FButtonCategories[I].Items[J].Action := nil;
  end;
end;

const
  cBorderBuffer = 15;

function TspSkinCategoryButtons.CalcCategoryHeight(const Category: TspButtonCategory;
  const ButtonsPerRow: Integer): Integer;
var
  RowCount: Integer;
begin
  if Category.Collapsed or (Category.Items = nil) or (Category.Items.Count = 0) then
    Result := FCollapsedHeight + cBorderBuffer
  else
  begin
    RowCount := Category.Items.Count div ButtonsPerRow;
    if Category.Items.Count mod ButtonsPerRow <> 0 then
      Inc(RowCount);

    Result := RowCount * FButtonHeight + cBorderBuffer;
    if not (spboVerticalCategoryCaptions in ButtonOptions) then
      Result := Result + FGutterSize;
  end;
end;

function TspSkinCategoryButtons.CalcCategoryWidth(
  const Category: TspButtonCategory; const ButtonsPerCol: Integer): Integer;
var
  ColCount: Integer;
begin
  if Category.Collapsed or (Category.Items = nil) or
      (Category.Items.Count = 0) then
    Result := FCollapsedHeight + cBorderBuffer
  else
  begin
    ColCount := Category.Items.Count div ButtonsPerCol;
    if Category.Items.Count mod ButtonsPerCol <> 0 then
      Inc(ColCount);

    Result := ColCount * FButtonWidth + cBorderBuffer;
    if spboVerticalCategoryCaptions in ButtonOptions then
      Result := Result + FGutterSize;
  end;
end;

procedure TspSkinCategoryButtons.GetCategoryBounds(const Category: TspButtonCategory;
  const StartingPos: Integer; var CategoryBounds, ButtonBounds: TRect);
var
  CatHeight, CatWidth: Integer;
  ButtonsPerRow, ButtonsPerCol: Integer;
  XStart, YStart: Integer;
  XEnd, YEnd: Integer;
begin
  if FButtonFlow = bscbfVertical then
  begin
    XStart := 0;
    XEnd := ClientWidth - GetScrollSize;

    ButtonsPerRow := CalcButtonsPerRow;
    CatHeight := CalcCategoryHeight(Category, ButtonsPerRow);

    with CategoryBounds do
    begin
      Left := XStart;
      Top := StartingPos;
      Right := XEnd;
      Bottom := StartingPos + CatHeight;
    end;

    if not Category.Collapsed then
    begin
      with ButtonBounds do
      begin
        Top := StartingPos + 8;
        if spboVerticalCategoryCaptions in ButtonOptions then
          Left := XStart + FGutterSize
        else
        begin
          Left := XStart + 8;
          Top := Top + FGutterSize;
        end;
        Right := XEnd - 1;
        Bottom := Top + (Category.Items.Count div ButtonsPerRow) * FButtonHeight;
        if Category.Items.Count mod ButtonsPerRow <> 0 then
          Inc(Bottom, FButtonHeight);
      end;
    end;
  end
  else
  begin
    YStart := 0;
    YEnd := ClientHeight - GetScrollSize;

    ButtonsPerCol := CalcButtonsPerCol;
    CatWidth := CalcCategoryWidth(Category, ButtonsPerCol);

    with CategoryBounds do
    begin
      Left := StartingPos;
      Top := YStart;
      Right := StartingPos + CatWidth;
      Bottom := YEnd;
    end;

    if not Category.Collapsed then
      with ButtonBounds do
      begin
        Left := StartingPos + 8;
        if not (spboVerticalCategoryCaptions in ButtonOptions) then
          Top := YStart + FGutterSize
        else
        begin
          Top := YStart + 8;
          Left := Left + FGutterSize;
        end;
        Bottom := YEnd - 1;
        Right := Left + (Category.Items.Count div ButtonsPerCol) * FButtonWidth;
        if Category.Items.Count mod ButtonsPerCol <> 0 then
          Inc(Right, FButtonWidth);
      end;
  end;
end;


const
  cDropDownSize = 13;

function TspSkinCategoryButtons.GetChevronBounds(const CategoryBounds: TRect): TRect;
begin
  Result.Left := CategoryBounds.Left + 2;
  Result.Top :=  CategoryBounds.Top + 2;
  Result.Right := Result.Left + cDropDownSize;
  Result.Bottom := Result.Top + cDropDownSize;
end;


procedure TspSkinCategoryButtons.DrawCategory(
  const Category: TspButtonCategory; const Canvas: TCanvas; StartingPos: Integer);

  procedure DrawDropDownButton(X, Y: Integer; Collapsed: Boolean);
  var
    Middle: Integer;
    EdgeColor: TColor;

    procedure SmallCheveron(const X, Y: Integer);
    begin
      { Shared portions }
      if Collapsed then
      begin
        { Top line }
        Canvas.Pixels[X-1, Y] := EdgeColor;
        Canvas.Pixels[X+0, Y] := EdgeColor;
        Canvas.Pixels[X+4, Y] := EdgeColor;
        Canvas.Pixels[X+5, Y] := EdgeColor;
        { Middle line }
        Canvas.Pixels[X+0, Y+1] := EdgeColor;
        Canvas.Pixels[X+1, Y+1] := EdgeColor;
        Canvas.Pixels[X+3, Y+1] := EdgeColor;
        Canvas.Pixels[X+4, Y+1] := EdgeColor;
        { Bottom line  }
        Canvas.Pixels[X + 1, Y + 2] := EdgeColor;
        Canvas.Pixels[X + 2, Y + 2] := EdgeColor;
        Canvas.Pixels[X + 3, Y + 2] := EdgeColor;
        { Bottom tip of the chevron }
        Canvas.Pixels[X+2, Y+3] := EdgeColor;
      end
      else
      begin
        { Top tip of the chevron }
        Canvas.Pixels[X+2, Y] := EdgeColor;
        { Top line  }
        Canvas.Pixels[X + 1, Y + 1] := EdgeColor;
        Canvas.Pixels[X + 2, Y + 1] := EdgeColor;
        Canvas.Pixels[X + 3, Y + 1] := EdgeColor;
        { Middle line }
        Canvas.Pixels[X, Y+2] := EdgeColor;
        Canvas.Pixels[X+1, Y+2] := EdgeColor;
        Canvas.Pixels[X+3, Y+2] := EdgeColor;
        Canvas.Pixels[X+4, Y+2] := EdgeColor;
        { Bottom line }
        Canvas.Pixels[X-1, Y+3] := EdgeColor;
        Canvas.Pixels[X+0, Y+3] := EdgeColor;
        Canvas.Pixels[X+4, Y+3] := EdgeColor;
        Canvas.Pixels[X+5, Y+3] := EdgeColor;
      end;
    end;

    procedure DrawPlusMinus;
    var
      Width, Height: Integer;
    begin
      Width := 9;
      Height := Width;
      Inc(X, 2);
      Inc(Y, 2);
      begin
        Canvas.Pen.Color := clBtnShadow;
        Canvas.Brush.Color := clWindow;
        Canvas.Rectangle(X, Y, X + Width, Y + Height);
        Canvas.Pen.Color := clWindowText;

        Canvas.MoveTo(X + 2, Y + Width div 2);
        Canvas.LineTo(X + Width - 2, Y + Width div 2);

        if Collapsed then
        begin
          Canvas.MoveTo(X + Width div 2, Y + 2);
          Canvas.LineTo(X + Width div 2, Y + Width - 2);
        end;
      end;
    end;

  begin
    if spboUsePlusMinus in ButtonOptions then
    begin
      DrawPlusMinus;
    end
    else
    begin
      EdgeColor := clBtnShadow;
      Middle := cDropDownSize div 2;
      SmallCheveron(X + Middle - 2, Y + Middle - 4);
      SmallCheveron(X + Middle - 2, Y + Middle + 1);
    end;
  end;

var
  I: Integer;
  ButtonTop, ButtonLeft, ButtonRight: Integer;
  ButtonRect: TRect;
  ActualWidth: Integer;
  ButtonStart: Integer;
  ButtonBottom: Integer;
  VerticalCaption: Boolean;
  DrawState: TspButtonDrawState;
  Button: TspButtonItem;
  CategoryBounds, ButtonBounds, ChevronBounds: TRect;
  Caption: string;
  CaptionRect: TRect;
  CategoryRealBounds: TRect;
  //
  F: TLogFont;
  TY: Integer;
  CIndex: Integer;
begin
  if (SkinData <> nil) and not SkinData.Empty
  then
    begin
      CIndex := SkinData.GetControlIndex('panel');
      if CIndex <> -1
      then
        begin
          DrawSkinCategory(Category, Canvas, StartingPos);
          Exit;
        end;
    end;

  GetCategoryBounds(Category, StartingPos, CategoryBounds, ButtonBounds);
  CategoryRealBounds := CategoryBounds;

  Canvas.Font := Self.Font;
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(CategoryRealBounds);

  with CategoryRealBounds do
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Rectangle(Left, Top, Right, Bottom);
  end;

  ChevronBounds := GetChevronBounds(CategoryRealBounds);

  if Category.Items.Count > 0 then
    DrawDropDownButton(ChevronBounds.Left + 2, ChevronBounds.Top + 2,
      Category.Collapsed);

  VerticalCaption := True;
  if FButtonFlow = bscbfVertical then
  begin
    if not (spboVerticalCategoryCaptions in ButtonOptions) or
        Category.Collapsed or
        (Category.Items = nil) or
        (Category.Items.Count = 0) then
      VerticalCaption := False
  end
  else if not (spboVerticalCategoryCaptions in ButtonOptions) and
      not (Category.Collapsed or (Category.Items = nil) or (Category.Items.Count = 0)) then
    VerticalCaption := False;

  { Draw the category caption. Truncating and vertical as needed. }
  Caption := Category.Caption;

  if (spboBoldCaptions in ButtonOptions) then
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := clBlack;

  if not VerticalCaption then
  begin
    CaptionRect.Left := CategoryBounds.Left + 5 + cDropDownSize;
    CaptionRect.Right := CategoryBounds.Right - 5;
    CaptionRect.Top := CategoryBounds.Top + 3;
    CaptionRect.Bottom := CaptionRect.Top + Canvas.TextHeight(Caption);
    Canvas.TextRect(CaptionRect, CaptionRect.Left, CaptionRect.Top, Caption);
  end
  else
    begin
      CaptionRect.Left := CategoryBounds.Left + 3;
      CaptionRect.Top := CategoryBounds.Top + cDropDownSize + 5;
      CaptionRect.Right := CaptionRect.Left + (FCollapsedHeight + cBorderBuffer);
      CaptionRect.Bottom := CategoryBounds.Bottom - 5;
      TY := CaptionRect.Bottom - RectHeight(CaptionRect) div 2 +
       Canvas.TextWidth(Caption) div 2;
      if TY > CaptionRect.Bottom then TY := CaptionRect.Bottom;

      GetObject(Canvas.Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(900);
      Canvas.Font.Handle := CreateFontIndirect(F);

      Canvas.TextRect(CaptionRect, CaptionRect.Left, TY, Caption);

      GetObject(Canvas.Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(0);
      Canvas.Font.Handle := CreateFontIndirect(F);
    end;

  if (spboBoldCaptions in ButtonOptions) then
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];

  if not Category.Collapsed then
  begin
    { Draw the buttons }
    if (FButtonFlow = bscbfVertical) and (spboFullSize in ButtonOptions) then
      ActualWidth := ClientWidth - FSideBufferSize - GetScrollSize - 5
    else
      ActualWidth := FButtonWidth;

    ButtonStart := ButtonBounds.Left;
    ButtonTop := ButtonBounds.Top;
    ButtonLeft := ButtonStart;
    for I := 0 to Category.Items.Count - 1 do
    begin
      { Don't waste time painting clipped things }
      if (FButtonFlow = bscbfVertical) and (ButtonTop > ClientHeight) then
        Break; { Done drawing }

      { Don't waste time drawing what is offscreen }
      ButtonBottom := ButtonTop + FButtonHeight;
      ButtonRight := ButtonLeft + ActualWidth;
      if (ButtonBottom >= 0) and (ButtonRight >= 0) then
      begin
        ButtonRect := Rect(ButtonLeft, ButtonTop, ButtonRight, ButtonBottom);

        Button := Category.Items[I];
        DrawState := [];
        if Button = FHotButton then
        begin
          Include(DrawState, spbdsHot);
          if Button = FDownButton then
            Include(DrawState, spbdsDown);
        end;
        if Button = FSelectedItem then
          Include(DrawState, spbdsSelected)
        else if (Button = FFocusedItem) and Focused and (FDownButton = nil) then
          Include(DrawState, spbdsFocused);

        if Button = FInsertTop then
          Include(DrawState, spbdsInsertTop)
        else if Button = FInsertBottom then
          Include(DrawState, spbdsInsertBottom)
        else if Button = FInsertRight then
          Include(DrawState, spbdsInsertRight)
        else if Button = FInsertLeft then
          Include(DrawState, spbdsInsertLeft);

        DrawButton(Button, Canvas, ButtonRect, DrawState);
      end;
      Inc(ButtonLeft, ActualWidth);

      if (ButtonLeft + ActualWidth) > ButtonBounds.Right then
      begin
        ButtonLeft := ButtonStart;
        Inc(ButtonTop, FButtonHeight);
      end;
    end;
  end;
end;

procedure TspSkinCategoryButtons.DrawSkinCategory(
  const Category: TspButtonCategory; const Canvas: TCanvas; StartingPos: Integer);

  procedure DrawDropDownButton(Cnv: TCanvas; X, Y: Integer; Collapsed: Boolean);
  var
    Middle: Integer;
    EdgeColor: TColor;

    procedure SmallCheveron(const X, Y: Integer);
    begin
      { Shared portions }
      if Collapsed then
      begin
        { Top line }
        Cnv.Pixels[X-1, Y] := EdgeColor;
        Cnv.Pixels[X+0, Y] := EdgeColor;
        Cnv.Pixels[X+4, Y] := EdgeColor;
        Cnv.Pixels[X+5, Y] := EdgeColor;
        { Middle line }
        Cnv.Pixels[X+0, Y+1] := EdgeColor;
        Cnv.Pixels[X+1, Y+1] := EdgeColor;
        Cnv.Pixels[X+3, Y+1] := EdgeColor;
        Cnv.Pixels[X+4, Y+1] := EdgeColor;
        { Bottom line  }
        Cnv.Pixels[X + 1, Y + 2] := EdgeColor;
        Cnv.Pixels[X + 2, Y + 2] := EdgeColor;
        Cnv.Pixels[X + 3, Y + 2] := EdgeColor;
        { Bottom tip of the chevron }
        Cnv.Pixels[X+2, Y+3] := EdgeColor;
      end
      else
      begin
        { Top tip of the chevron }
        Cnv.Pixels[X+2, Y] := EdgeColor;
        { Top line  }
        Cnv.Pixels[X + 1, Y + 1] := EdgeColor;
        Cnv.Pixels[X + 2, Y + 1] := EdgeColor;
        Cnv.Pixels[X + 3, Y + 1] := EdgeColor;
        { Middle line }
        Cnv.Pixels[X, Y+2] := EdgeColor;
        Cnv.Pixels[X+1, Y+2] := EdgeColor;
        Cnv.Pixels[X+3, Y+2] := EdgeColor;
        Cnv.Pixels[X+4, Y+2] := EdgeColor;
        { Bottom line }
        Cnv.Pixels[X-1, Y+3] := EdgeColor;
        Cnv.Pixels[X+0, Y+3] := EdgeColor;
        Cnv.Pixels[X+4, Y+3] := EdgeColor;
        Cnv.Pixels[X+5, Y+3] := EdgeColor;
      end;
    end;

    procedure DrawPlusMinus;
    var
      Width, Height: Integer;
    begin
      Width := 9;
      Height := Width;
      Inc(X, 2);
      Inc(Y, 2);
      begin
        Cnv.Pen.Color := Cnv.Font.Color;
        Cnv.Brush.Color := clWindow;
        Cnv.Rectangle(X, Y, X + Width, Y + Height);
        Cnv.Pen.Color := clWindowText;

        Cnv.MoveTo(X + 2, Y + Width div 2);
        Cnv.LineTo(X + Width - 2, Y + Width div 2);

        if Collapsed then
        begin
          Cnv.MoveTo(X + Width div 2, Y + 2);
          Cnv.LineTo(X + Width div 2, Y + Width - 2);
        end;
      end;
    end;

  begin
    if spboUsePlusMinus in ButtonOptions then
    begin
      DrawPlusMinus;
    end
    else
    begin
      EdgeColor := Cnv.Font.Color;
      Middle := cDropDownSize div 2;
      SmallCheveron(X + Middle - 2, Y + Middle - 4);
      SmallCheveron(X + Middle - 2, Y + Middle + 1);
    end;
  end;

var
  I: Integer;
  ButtonTop, ButtonLeft, ButtonRight: Integer;
  ButtonRect: TRect;
  ActualWidth: Integer;
  ButtonStart: Integer;
  ButtonBottom: Integer;
  VerticalCaption: Boolean;
  DrawState: TspButtonDrawState;
  Button: TspButtonItem;
  CategoryBounds, ButtonBounds, ChevronBounds: TRect;
  Caption: string;
  CaptionRect: TRect;
  CategoryRealBounds: TRect;
  //
  F: TLogFont;
  TY: Integer;
  Buffer: TBitMap;
  BR, CR, CB: TREct;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewClRect: TRect;
  XO, YO, CIndex: Integer;
  FSkinPicture: TBitMap;
  PanelData: TspDataSkinPanelControl;
  LabelData: TspDataSkinStdLabelControl;
begin
  GetCategoryBounds(Category, StartingPos, CategoryBounds, ButtonBounds);
  CategoryRealBounds := CategoryBounds;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(CategoryRealBounds);
  Buffer.Height := RectHeight(CategoryRealBounds);
  // draw panel
  CIndex := SkinData.GetControlIndex(FCategorySkinDataName);
  PanelData := TspDataSkinPanelControl(SkinData.CtrlList[CIndex]);
  with PanelData do
  begin
    XO := RectWidth(CategoryRealBounds) - RectWidth(SkinRect);
    YO := RectHeight(CategoryRealBounds) - RectHeight(SkinRect);
    NewLTPoint := LTPoint;
    NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    NewClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);

    FSkinPicture := TBitMap(FSD.FActivePictures.Items[panelData.PictureIndex]);

    CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
         NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
         Buffer, FSkinPicture, SkinRect, Buffer.Width, Buffer.Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
           StretchEffect, StretchType);

  end;
  // get font parameters
  CIndex := SkinData.GetControlIndex('stdlabel');
  if CIndex <> -1
  then
    begin
      LabelData := TspDataSkinStdLabelControl(SkinData.CtrlList[CIndex]);
      with LabelData do
      begin
        if FUseSkinFont
        then
          begin
            Buffer.Canvas.Font.Name := FontName;
            Buffer.Canvas.Font.Style := FontStyle;
            Buffer.Canvas.Font.Height := FontHeight;
            if SkinData.ResourceStrData <>  nil
            then
              Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
            else
              Buffer.Canvas.Font.Charset := Font.CharSet;
          end
        else
          Buffer.Canvas.Font.Assign(Self.Font);
        Buffer.Canvas.Font.Color := FontColor;  
      end;
    end
  else
    Buffer.Canvas.Font := Self.Font;
  //
  ChevronBounds := GetChevronBounds(CategoryRealBounds);
  CB := ChevronBounds;
  OffsetRect(CB, -CategoryRealBounds.Left, -CategoryRealBounds.Top);
  if Category.Items.Count > 0 then
    DrawDropDownButton(Buffer.Canvas, CB.Left + 2, CB.Top + 2,
      Category.Collapsed);

  VerticalCaption := True;
  if FButtonFlow = bscbfVertical then
  begin
    if not (spboVerticalCategoryCaptions in ButtonOptions) or
        Category.Collapsed or
        (Category.Items = nil) or
        (Category.Items.Count = 0) then
      VerticalCaption := False
  end
  else if not (spboVerticalCategoryCaptions in ButtonOptions) and
      not (Category.Collapsed or (Category.Items = nil) or (Category.Items.Count = 0)) then
    VerticalCaption := False;

  { Draw the category caption. Truncating and vertical as needed. }
  Caption := Category.Caption;

  if (spboBoldCaptions in ButtonOptions) then
    Buffer.Canvas.Font.Style := Canvas.Font.Style + [fsBold];

  if not VerticalCaption then
  begin
    CaptionRect.Left := CategoryBounds.Left + 5 + cDropDownSize;
    CaptionRect.Right := CategoryBounds.Right - 5;
    CaptionRect.Top := CategoryBounds.Top + 3;
    CaptionRect.Bottom := CaptionRect.Top + Canvas.TextHeight(Caption);
    CR := CaptionRect;
    OffsetRect(CR, -CategoryRealBounds.Left, -CategoryRealBounds.Top);
    Buffer.Canvas.Brush.Style := bsClear;
    Buffer.Canvas.TextRect(CR, CR.Left, CR.Top, Caption);
  end
  else
    begin
      CaptionRect.Left := CategoryBounds.Left + 3;
      CaptionRect.Top := CategoryBounds.Top + cDropDownSize + 5;
      CaptionRect.Right := CaptionRect.Left + (FCollapsedHeight + cBorderBuffer);
      CaptionRect.Bottom := CategoryBounds.Bottom - 3;

      CR := CaptionRect;
      OffsetRect(CR, -CategoryRealBounds.Left, -CategoryRealBounds.Top);

      TY := CR.Bottom - RectHeight(CR) div 2 +
      Buffer.Canvas.TextWidth(Caption) div 2;
      if TY > CR.Bottom then TY := CR.Bottom;

      GetObject(Buffer.Canvas.Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(900);
      Buffer.Canvas.Font.Handle := CreateFontIndirect(F);
      Buffer.Canvas.Brush.Style := bsClear;
      Buffer.Canvas.TextRect(CR, CR.Left, TY, Caption);
      GetObject(Canvas.Font.Handle, SizeOf(F), @F);
      F.lfEscapement := round(0);
      Buffer.Canvas.Font.Handle := CreateFontIndirect(F);
    end;

  if (spboBoldCaptions in ButtonOptions) then
    Buffer.Canvas.Font.Style := Canvas.Font.Style - [fsBold];

  if not Category.Collapsed then
  begin
    { Draw the buttons }
    if (FButtonFlow = bscbfVertical) and (spboFullSize in ButtonOptions) then
      ActualWidth := ClientWidth - FSideBufferSize - GetScrollSize - 5
    else
      ActualWidth := FButtonWidth;

    ButtonStart := ButtonBounds.Left;
    ButtonTop := ButtonBounds.Top;
    ButtonLeft := ButtonStart;
    for I := 0 to Category.Items.Count - 1 do
    begin
      { Don't waste time painting clipped things }
      if (FButtonFlow = bscbfVertical) and (ButtonTop > ClientHeight) then
        Break; { Done drawing }

      { Don't waste time drawing what is offscreen }
      ButtonBottom := ButtonTop + FButtonHeight;
      ButtonRight := ButtonLeft + ActualWidth;
      if (ButtonBottom >= 0) and (ButtonRight >= 0) then
      begin
        ButtonRect := Rect(ButtonLeft, ButtonTop, ButtonRight, ButtonBottom);

        Button := Category.Items[I];
        DrawState := [];
        if Button = FHotButton then
        begin
          Include(DrawState, spbdsHot);
          if Button = FDownButton then
            Include(DrawState, spbdsDown);
        end;
        if Button = FSelectedItem then
          Include(DrawState, spbdsSelected)
        else if (Button = FFocusedItem) and Focused and (FDownButton = nil) then
          Include(DrawState, spbdsFocused);

        if Button = FInsertTop then
          Include(DrawState, spbdsInsertTop)
        else if Button = FInsertBottom then
          Include(DrawState, spbdsInsertBottom)
        else if Button = FInsertRight then
          Include(DrawState, spbdsInsertRight)
        else if Button = FInsertLeft then
          Include(DrawState, spbdsInsertLeft);

        BR := ButtonRect;
        OffsetRect(BR, -CategoryRealBounds.Left, -CategoryRealBounds.Top);
        DrawButton(Button, Buffer.Canvas, BR, DrawState);
      end;
      Inc(ButtonLeft, ActualWidth);

      if (ButtonLeft + ActualWidth) > ButtonBounds.Right then
      begin
        ButtonLeft := ButtonStart;
        Inc(ButtonTop, FButtonHeight);
      end;
    end;
  end;

  Canvas.Draw(CategoryRealBounds.Left, CategoryRealBounds.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCategoryButtons.Paint;

procedure DrawSkinBGRect(R: TRect);
var
  PanelData: TspDataSkinPanelControl;
  w, h, X, Y, XCnt, YCnt: Integer;
  Buffer, Buffer2: TBitMap;
  FSkinPicture: TBitMap;
begin
  if (RectWidth(R) <= 0) or (RectHeight(R) <= 0) then Exit;
  PanelData := TspDataSkinPanelControl(SkinData.CtrlList[SkinData.GetControlIndex('panel')]);
  Buffer := TBitMap.Create;
  with PanelData do
  begin
    FSkinPicture := TBitMap(SkinData.FActivePictures.Items[PictureIndex]);
    Buffer.Width := RectWidth(ClRect);
    Buffer.Height := RectHeight(ClRect);
    Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
        FSkinPicture.Canvas,
          Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
               SkinRect.Left + ClRect.Right,
               SkinRect.Top + ClRect.Bottom));
    w := RectWidth(ClRect);
    h := RectHeight(ClRect);
    XCnt := RectWidth(R) div w;
    YCnt := RectHeight(R) div h;
    if StretchEffect
      then
        begin
          case StretchType of
            spstFull:
              Canvas.StretchDraw(R, Buffer);
            spstHorz:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := Buffer.Width;
                Buffer2.Height := RectHeight(R);
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
                XCnt := Width div Buffer2.Width;
                 for X := 0 to XCnt do
                   Canvas.Draw(R.Left + X * Buffer2.Width, R.Top, Buffer2);
                 Buffer2.Free;
              end;
            spstVert:
              begin
                Buffer2 := TBitMap.Create;
                Buffer2.Width := RectWidth(R);
                Buffer2.Height := Buffer.Height;
                Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
                YCnt := RectHeight(R) div Buffer2.Height;
                for Y := 0 to YCnt do
                  Canvas.Draw(R.Left, R.Top + Y * Buffer2.Height, Buffer2);
                Buffer2.Free;
              end;
          end;
        end
     else
    for X := 0 to XCnt do
    for Y := 0 to YCnt do
      Canvas.Draw(X * w + R.Left, Y * h + R.Top, Buffer);
  end;
  Buffer.Free;
end;

var
  TopCategory: Integer;
  CatIndex: Integer;
  StartingPos: Integer;
  EndingPos: Integer;
  Category: TspButtonCategory;
  DrawRect: TRect;
begin
  StartingPos := 0;
  TopCategory := GetIndexOfFirstCategory;
  if (TopCategory > -1) and (TopCategory < FButtonCategories.Count) then
  begin
    { Calculate the virtual position and ending position }
    StartingPos := FButtonCategories[TopCategory].FStart - GetScrollOffset;
    if FButtonFlow = bscbfVertical then
      EndingPos := ClientHeight
    else
      EndingPos := ClientWidth;
    for CatIndex := TopCategory to FButtonCategories.Count - 1 do
    begin
      Category := FButtonCategories[CatIndex];
      DrawCategory(Category, Canvas, StartingPos);
      StartingPos := StartingPos + Category.FEnd - Category.FStart;
      { Stop drawing early, if we can }
      if StartingPos > EndingPos then
        Break;
    end;
  end;
  //
  Canvas.Brush.Color := clBtnFace;
  //
  if (FButtonFlow = bscbfVertical) and
     (StartingPos < ClientHeight)
  then
    begin
      DrawRect := Rect(0, StartingPos, ClientWidth,
        ClientHeight);
      if (SkinData <> nil) and (not Skindata.Empty) and
            (SkinData.GetControlIndex('panel') <> -1)
      then
        DrawSkinBGRect(DrawRect)
      else
        Canvas.FillRect(DrawRect);
    end
  else
  if (FButtonFlow = bscbfHorizontal) and
     (StartingPos < ClientWidth)
  then
    begin
      DrawRect := Rect(StartingPos, 0, ClientWidth,
        ClientHeight);
      if (SkinData <> nil) and (not Skindata.Empty) and
            (SkinData.GetControlIndex('panel') <> -1)
      then
        DrawSkinBGRect(DrawRect)
      else
        Canvas.FillRect(DrawRect);
    end
end;


function TspSkinCategoryButtons.CalcButtonsPerRow: Integer;
begin
  if spboFullSize in ButtonOptions
  then
    Result := 1
  else
  begin
    Result := (ClientWidth - GetScrollSize - FSideBufferSize - 1) div FButtonWidth;
    if Result * FButtonWidth > ClientWidth - GetScrollSize - FSideBufferSize - 1
    then
      Dec(Result)
    else
    if (Result + 1) * FButtonWidth < ClientWidth - GetScrollSize - FSideBufferSize - 1
    then
      Inc(Result);
    if Result <= 0 then Result := 1;
  end;
end;

function TspSkinCategoryButtons.CalcButtonsPerCol: Integer;
begin
  Result := (ClientHeight - FSideBufferSize - GetScrollSize - 1) div FButtonHeight;
  if Result * FButtonHeight > ClientHeight - FSideBufferSize - GetScrollSize
  then
    Dec(Result)
  else
  if (Result + 1) * FButtonHeight < ClientHeight - FSideBufferSize - GetScrollSize
  then
    Inc(Result);
  if Result = 0 then
    Result := 1;
end;

const
  cScrollBarKind: array[TspCatButtonFlow] of Integer = (SB_VERT, SB_HORZ);

procedure TspSkinCategoryButtons.Resize;

  function CalcCategoryHeights: Integer;
  var
    I: Integer;
    Category: TspButtonCategory;
    Y: Integer;
    ButtonsPerRow: Integer;
  begin
    ButtonsPerRow := CalcButtonsPerRow;
    Y := 0;
    for I := 0 to FButtonCategories.Count - 1 do
    begin
      Category := FButtonCategories[I];
      Category.FStart := Y;
      Category.FEnd := Y + CalcCategoryHeight(Category, ButtonsPerRow);
      Y := Category.FEnd;
    end;
    Result := Y;
  end;

  function CalcCategoryWidths: Integer;
  var
    I: Integer;
    Category: TspButtonCategory;
    X: Integer;
    ButtonsPerCol: Integer;
  begin
    ButtonsPerCol := CalcButtonsPerCol;
    X := 0;
    for I := 0 to FButtonCategories.Count - 1 do
    begin
      Category := FButtonCategories[I];
      Category.FStart := X;
      Category.FEnd := X + CalcCategoryWidth(Category, ButtonsPerCol);
      X := Category.FEnd;
    end;
    Result := X;
  end;

var
  ScrollInfo: TScrollInfo;
  TotalAmount: Integer;
  AmountSeen: Integer;
begin
  inherited;
  if (not HandleAllocated) or (FGutterSize = 0) then
    Exit;

  if FButtonFlow = bscbfVertical then
  begin
    TotalAmount := CalcCategoryHeights;
    AmountSeen := ClientHeight;
  end
  else
  begin
    TotalAmount := CalcCategoryWidths;
    AmountSeen := ClientWidth;
  end;

  { Do we have to take the scrollbar into consideration? }
  if (TotalAmount > AmountSeen) then
  begin
    { The max size is the number of "rows of buttons" that are hidden }
    FScrollBarMax := TotalAmount div FGutterSize;
    ScrollInfo.nMax := FScrollBarMax;

    AmountSeen := AmountSeen div FGutterSize;
    if FScrollBarMax > AmountSeen then
      FPageAmount := AmountSeen
    else
      FPageAmount := FScrollBarMax;

    { Adjust the max to NOT contain the page amount }
    FScrollBarMax := FScrollBarMax - FPageAmount + 1;

    if FScrollBarPos > FScrollBarMax then
      FScrollBarPos := FScrollBarMax;

    ScrollInfo.cbSize := SizeOf(TScrollInfo);
    ScrollInfo.fMask := SIF_RANGE or SIF_POS or SIF_PAGE;
    ScrollInfo.nMin := 0;
    ScrollInfo.nPos := FScrollBarPos;
    ScrollInfo.nPage := FPageAmount;
    if FSkinScrollBar = nil
    then
      begin
        ShowSkinScrollBar(True);
      end;
    FSkinScrollBar.SetRange(ScrollInfo.nMin, ScrollInfo.nMax,
        FScrollBarPos, ScrollInfo.nPage);
  end
  else
  begin
    FScrollBarPos := 0;
    FScrollBarMax := 0;
    if FSkinScrollBar <> nil
    then
      begin
        ShowSkinScrollBar(False);
      end;
  end;
end;

procedure TspSkinCategoryButtons.SetButtonHeight(const Value: Integer);
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    Resize;
    UpdateAllButtons;
  end;
end;

procedure TspSkinCategoryButtons.SetButtonCategories(const Value: TspButtonCategories);
begin
  FButtonCategories.Assign(Value);
end;

procedure TspSkinCategoryButtons.SetCatButtonOptions(const Value: TspCatButtonOptions);
begin
  if FButtonOptions <> Value then
  begin
    FButtonOptions := Value;
    CalcBufferSizes;
    Resize;
    UpdateAllButtons;
  end;
end;

procedure TspSkinCategoryButtons.SetButtonWidth(const Value: Integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Resize;
    UpdateAllButtons;
  end;
end;

procedure TspSkinCategoryButtons.SBChange(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPosition;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinCategoryButtons.SBUpClick(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scLineDown;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinCategoryButtons.SBDownClick(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scLineUp;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinCategoryButtons.SBPageUp(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPageUp;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinCategoryButtons.SBPageDown(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPageDown;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinCategoryButtons.ShowSkinScrollBar(const Visible: Boolean);
begin
  if Visible
  then
    begin
     FSkinScrollBar := TspSkinScrollBar.Create(Self);
     FSkinScrollBar.Visible := False;
     FSkinScrollBar.Parent := Self;
     //
     FSkinScrollBar.OnChange := SBChange;
     FSkinScrollBar.OnUpButtonClick := SBUpClick;
     FSkinScrollBar.OnDownButtonClick := SBDownClick;
     FSkinScrollBar.OnPageUp := SBPageUp;
     FSkinScrollBar.OnPageDown := SBPageDown;
     //
     if FButtonFlow = bscbfVertical
     then
       begin
         FSkinScrollBar.SkinDataName := 'vscrollbar';
         FSkinScrollBar.Kind := sbVertical;
       end
     else
       begin
         FSkinScrollBar.SkinDataName := 'hscrollbar';
         FSkinScrollBar.Kind := sbHorizontal;
       end;
      FSkinScrollBar.SkinData := Self.SkinData;
      FSkinScrollBar.Visible := True;
      AdjustScrollBar;
      //
    end
  else
    begin
      FSkinScrollBar.Visible := False;
      FSkinScrollBar.Free;
      FSkinScrollBar := nil;
    end;
  Resize;
  Invalidate;
end;


procedure TspSkinCategoryButtons.UpdateAllButtons;
begin
  Invalidate;
end;

procedure TspSkinCategoryButtons.UpdateButton(const Button: TspButtonItem);
var
  R: TRect;
begin
  { Just invalidate one button's rect }
  if (Button <> nil) and (HandleAllocated) then
  begin
    R := GetButtonRect(Button);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TspSkinCategoryButtons.ScrollPosChanged(ScrollCode: TScrollCode;
  ScrollPos: Integer);
var
  OldPos: Integer;
begin
  OldPos := FScrollBarPos;
  if (ScrollCode = scLineUp) and (FScrollBarPos > 0) then
    Dec(FScrollBarPos)
  else if (ScrollCode = scLineDown) and (FScrollBarPos < FScrollBarMax) then
    Inc(FScrollBarPos)
  else if (ScrollCode = scPageUp) then
  begin
    Dec(FScrollBarPos, FPageAmount);
    if FScrollBarPos < 0 then
      FScrollBarPos := 0;
  end
  else if ScrollCode = scPageDown then
  begin
    Inc(FScrollBarPos, FPageAmount);
    if FScrollBarPos > FScrollBarMax then
      FScrollBarPos := FScrollBarMax;
  end
  else if ScrollCode in [scPosition, scTrack] then
    FScrollBarPos := ScrollPos
  else if ScrollCode = scTop then
    FScrollBarPos := 0
  else if ScrollCode = scBottom then
    FScrollBarPos := FScrollBarMax;
  if OldPos <> FScrollBarPos then
  begin
    if FSkinScrollBar <> nil
    then
      FSkinScrollBar.SetRange(FSkinScrollBar.Min,
      FSkinScrollBar.Max,  FScrollBarPos, FSkinScrollBar.PageSize);
    Invalidate;
  end;
  Resize;
end;

procedure TspSkinCategoryButtons.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then
  begin
    if Images <> nil then
      Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if Images <> nil then
    begin
      Images.RegisterChanges(FImageChangeLink);
      Images.FreeNotification(Self);
   end;
   UpdateAllButtons;
  end;
end;

procedure TspSkinCategoryButtons.DrawStretchSkinButton(const Button: TspButtonItem; Canvas: TCanvas;
    Rct: TRect; State: TspButtonDrawState);
var
  SR: TRect;
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  NewClRect: TRect;
  XO, YO: Integer;
  C: TColor;
  FSkinPicture: TBitMap;
begin
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(Rct);
  Buffer.Height := RectHeight(Rct);
  //
  CIndex := SkinData.GetControlIndex(FButtonsSkinDataName);

  ButtonData := SkinData.CtrlList[CIndex];

  with ButtonData do
  begin
    if spbdsSelected in State
    then
      begin
        SR := DownSkinRect;
        C := DownFontColor;
      end
    else
    if spbdsHot in State
    then
      begin
        SR := ActiveSkinRect;
        C := ActiveFontColor;
      end
   else
    begin
      SR := SkinRect;
      C := FontColor;
    end;

    if IsNullRect(SR) then SR := SkinRect;
    XO := RectWidth(Rct) - RectWidth(SR);
    YO := RectHeight(Rct) - RectHeight(SR);
    NewClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);

    FSkinPicture := TBitMap(FSD.FActivePictures.Items[ButtonData.PictureIndex]);

    CreateStretchImage(Buffer, FSkinPicture, SR, ClRect, True);

    // draw glyph and text
    if FUseSkinFont
    then
      begin
        Buffer.Canvas.Font.Name := FontName;
        Buffer.Canvas.Font.Style := FontStyle;
        Buffer.Canvas.Font.Height := FontHeight;
      end
    else
      begin
        Buffer.Canvas.Font.Assign(Font);
      end;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.Charset;

    Buffer.Canvas.Font.Color := C;

    if SkinData.ResourceStrData <>  nil
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.CharSet;

    if spboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Buffer.Canvas, NewClRect, 5, 2, blGlyphLeft,
         Button.Caption, Button.ImageIndex, FImages, False, True,
         False, 0)
    else
      DrawImageAndText(Buffer.Canvas, NewClRect, -1, 0, blGlyphLeft,
         '', Button.ImageIndex, FImages, False, True, False, 0);
  end;
  //
  Canvas.Draw(Rct.Left, Rct.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCategoryButtons.DrawSkinButton(const Button: TspButtonItem; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState);

var
  SR: TRect;
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewClRect: TRect;
  XO, YO: Integer;
  C: TColor;
  FSkinPicture: TBitMap;
begin
  if (FButtonsSkinDataName <> 'resizebutton') and
     (SkinData.GetControlIndex(FButtonsSkinDataName) <> -1)
  then
    begin
      DrawStretchSkinButton(Button, Canvas, Rct, State);
      Exit;
    end;
    
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(Rct);
  Buffer.Height := RectHeight(Rct);

  CIndex := SkinData.GetControlIndex('resizebutton');
  ButtonData := SkinData.CtrlList[CIndex];
  with ButtonData do
  begin
    if spbdsSelected in State
    then
      begin
        SR := DownSkinRect;
        C := DownFontColor;
      end
    else
    if spbdsHot in State
    then
      begin
        SR := ActiveSkinRect;
        C := ActiveFontColor;
      end
   else
    begin
      SR := SkinRect;
      C := FontColor;
    end;
    if IsNullRect(SR) then SR := SkinRect;
    XO := RectWidth(Rct) - RectWidth(SR);
    YO := RectHeight(Rct) - RectHeight(SR);
    NewLTPoint := LTPoint;
    NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    NewClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);

    FSkinPicture := TBitMap(FSD.FActivePictures.Items[ButtonData.PictureIndex]);

    CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
         NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
         Buffer, FSkinPicture, SR, Buffer.Width, Buffer.Height, True,
           LeftStretch, TopStretch, RightStretch, BottomStretch,
           StretchEffect, StretchType);
    // draw glpyh and text
    if FUseSkinFont
    then
      begin
        Buffer.Canvas.Font.Name := FontName;
        Buffer.Canvas.Font.Style := FontStyle;
        Buffer.Canvas.Font.Height := FontHeight;
      end
    else
      begin
        Buffer.Canvas.Font.Assign(Font);
      end;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.Charset;
    Buffer.Canvas.Font.Color := C;
    if SkinData.ResourceStrData <>  nil
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.CharSet;

    
    if spboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Buffer.Canvas, NewClRect, 5, 2, blGlyphLeft,
         Button.Caption, Button.ImageIndex, FImages, False, True, False, 0)
    else
      DrawImageAndText(Buffer.Canvas, NewClRect, -1, 0, blGlyphLeft,
         '', Button.ImageIndex, FImages, False, True, False, 0);
  end;
  Canvas.Draw(Rct.Left, Rct.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCategoryButtons.DrawButton(const Button: TspButtonItem; Canvas: TCanvas;
  Rect: TRect; State: TspButtonDrawState);
var
  FillColor: TColor;
  EdgeColor: TColor;
  TextRect: TRect;
  OrgRect: TRect;
  CIndex: Integer;
begin
  if Assigned(FOnDrawButton) and (not (csDesigning in ComponentState)) then
    FOnDrawButton(Self, Button, Canvas, Rect, State)
  else
  begin
    OrgRect := Rect;
    if Assigned(FOnBeforeDrawButton) then
      FOnBeforeDrawButton(Self, Button, Canvas, Rect, State);
    InflateRect(Rect, -1, -1);

    if (SkinData <> nil) and not (SkinData.Empty)
    then
      begin
        CIndex := SkinData.GetControlIndex('resizebutton');
        if CIndex <> -1
        then
          begin
            DrawSkinButton(Button, Canvas, Rect, State);
            Exit;
          end;
      end;

    Canvas.Font.Color := clBtnText;

    if spbdsHot in State then
    begin
      FillColor := SP_XP_BTNACTIVECOLOR;
      if spbdsSelected in State then
        FillColor := SP_XP_BTNACTIVECOLOR;
      EdgeColor := SP_XP_BTNFRAMECOLOR;
    end
    else if spbdsSelected in State then
    begin
      FillColor := SP_XP_BTNDOWNCOLOR;
      EdgeColor := clBtnShadow;
    end
    else
    begin
      FillColor := clBtnFace;
      if (spbdsFocused in State) then
        EdgeColor := SP_XP_BTNFRAMECOLOR
      else
        EdgeColor := clBtnShadow;
    end;

    Canvas.Brush.Color := FillColor;
    if FillColor <> clNone then
    begin
      Canvas.FillRect(Rect);
      { Draw the edge outline }
      Canvas.Brush.Color := EdgeColor;
      Canvas.FrameRect(Rect);
    end;

    if spbdsFocused in State then
    begin
      InflateRect(Rect, -1, -1);
      Canvas.FrameRect(Rect);
    end;

    Canvas.Brush.Color := FillColor;

    TextRect := Rect;
    InflateRect(TextRect, -2, -2);

    if spboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Canvas, TextRect, 5, 2, blGlyphLeft,
         Button.Caption, Button.ImageIndex, FImages, False, True, False, 0)
    else
      DrawImageAndText(Canvas, TextRect, -1, 0, blGlyphLeft,
         '', Button.ImageIndex, FImages, False, True, False, 0);

    if Assigned(FOnAfterDrawButton) then
      FOnAfterDrawButton(Self, Button, Canvas, OrgRect, State);
  end;

  Canvas.Brush.Color := clBtnFace;

end;

procedure TspSkinCategoryButtons.SetOnDrawButton(const Value: TspCatButtonDrawEvent);
begin
  FOnDrawButton := Value;
  Invalidate;
end;

procedure TspSkinCategoryButtons.CalcBufferSizes;
var
  VertInOpt: Boolean;
  CIndex: Integer;
  LabelData: TspDataSkinStdLabelControl;
begin
  if HandleAllocated then
  begin
    //
    if (SkinData <> nil) and (not SkinData.Empty)
    then
      begin
        CIndex := SkinData.GetControlIndex('stdlabel');
        if CIndex <> -1
        then
          begin
            LabelData := TspDataSkinStdLabelControl(SkinData.CtrlList[CIndex]);
            with LabelData do
            begin
              if FUseSkinFont
              then
                begin
                  Canvas.Font.Name := FontName;
                  Canvas.Font.Style := FontStyle;
                  Canvas.Font.Height := FontHeight;
                  Canvas.Font.Color := FontColor;
                  if SkinData.ResourceStrData <>  nil
                  then
                    Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
                  else
                    Canvas.Font.Charset := Font.CharSet;
                 end
              else
                Canvas.Font := Self.Font;
            end;
         end
       else
         Canvas.Font := Self.Font;
      end
    else
      begin
        Canvas.Font := Self.Font;
      end;
    //
    FCollapsedHeight := Canvas.TextHeight('Wg');  { Do not localize }
    FGutterSize := FCollapsedHeight + 5 { Border around the text };

    VertInOpt := spboVerticalCategoryCaptions in ButtonOptions;
    if ((FButtonFlow = bscbfVertical) and VertInOpt) or
       ((FButtonFlow = bscbfHorizontal) and not VertInOpt) then
      FSideBufferSize := FGutterSize
    else
      FSideBufferSize := 8;
  end;
end;

procedure TspSkinCategoryButtons.CreateHandle;
begin
  inherited CreateHandle;
  CalcBufferSizes;
  Resize;
end;

procedure TspSkinCategoryButtons.WMMouseLeave(var Message: TMessage);
begin
  FMouseInControl := False;
  if FHotButton <> nil then
  begin
    UpdateButton(FHotButton);
    FHotButton := nil;
    DoHotButton;
  end;
  if FDragImageList.Dragging then
  begin
    FDragImageList.HideDragImage;
    RemoveInsertionPoints;
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end;
  DoMouseLeave;
end;

procedure TspSkinCategoryButtons.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DownCategory: TspButtonCategory;
begin
  inherited;
  if Button = mbLeft then
  begin
    FDragStarted := False;
    DownCategory := GetCategoryAt(X, Y);
    FDownButton := GetButtonAt(X, Y, DownCategory);

    { Focus ourselves, when clicked, like a button would, but
      after setting the FDownButton }
    if (not Focused) and CanFocus then
      Windows.SetFocus(Handle);

    if FDownButton <> nil then
    begin
      FDragButton := FDownButton;
      FDragStartPos := Point(X, Y);
      UpdateButton(FDownButton);
    end
    else if DownCategory <> nil then
    begin
      if GetAllowReorder then
      begin
        FDragCategory := DownCategory;
        FDragStartPos := Point(X, Y);
      end;
    end;
  end;
end;

procedure TspSkinCategoryButtons.BeginAutoDrag;
begin
  FDragStartPos := ScreenToClient(Mouse.CursorPos);
  with FDragStartPos do
    FDragButton := GetButtonAt(X, Y);
  if FDragButton <> nil then
  begin
    FDragStarted := True;
    DoBeginDrag(Mouse.DragImmediate, Mouse.DragThreshold);
  end;
  { Don't call inherited; the above takes care of calling BeginDrag } 
end;

procedure TspSkinCategoryButtons.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewHotButton, OldHotButton: TspButtonItem;
  EventTrack: TTrackMouseEvent;
  DragThreshold: Integer;
begin
  inherited;
  { Was the drag threshold met? }
  if (GetAllowReorder) and
    ((FDragButton <> nil) or (FDragCategory <> nil)) then
  begin
    DragThreshold := Mouse.DragThreshold;
    if (Abs(FDragStartPos.X - X) >= DragThreshold) or
        (Abs(FDragStartPos.Y - Y) >= DragThreshold) then
    begin
      FDragStartPos.X := X; { Used in the start of the drag }
      FDragStartPos.Y := Y;
      FDownButton := nil; { Stops repaints and clicks }
      if FHotButton <> nil then
      begin
        OldHotButton := FHotButton;
        FHotButton := nil;
        UpdateButton(OldHotButton);
        { We must have the window process the paint message before
          the drag operation starts }
        UpdateWindow(Handle);
        DoHotButton;
      end;
      FDragStarted := True;
      DoBeginDrag(True, -1);
      Exit;
    end;
  end;

  NewHotButton := GetButtonAt(X, Y);
  if NewHotButton <> FHotButton then
  begin
    OldHotButton := FHotButton;
    FHotButton := NewHotButton;
    UpdateButton(OldHotButton);
    UpdateButton(FHotButton);
    DoHotButton;
  end;
  if not FMouseInControl then
  begin
    FMouseInControl := True;
    if FIs9XOS
    then
      FMouseTimer.Enabled := True
    else
      begin
        EventTrack.cbSize := SizeOf(TTrackMouseEvent);
        EventTrack.dwFlags := TME_LEAVE;
        EventTrack.hwndTrack := Handle;
        EventTrack.dwHoverTime := 0;
        TrackMouseEvent(EventTrack);
      end;  
  end;
end;

procedure TspSkinCategoryButtons.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LastDown: TspButtonItem;
  DownCategory: TspButtonCategory;
begin
  inherited;
  if (Button = mbLeft) and (not FDragStarted) then
  begin
    LastDown := FDownButton;
    FDownButton := nil;
    FDragButton := nil;
    FDragCategory := nil;
    if LastDown <> nil then
      UpdateButton(LastDown);
    if (LastDown <> nil) and (GetButtonAt(X, Y) = LastDown) then
    begin
      SelectedItem := LastDown;
      DoItemClicked(FSelectedItem);
    end
    else
    begin
      DownCategory := GetCategoryAt(X, Y);
      if (DownCategory <> nil) and (DownCategory.Items.Count > 0) then
      begin
        DownCategory.Collapsed := not DownCategory.Collapsed;
        Resize;
      end;
    end;
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
  FDragStarted := False;
end;

function TspSkinCategoryButtons.GetButtonAt(X, Y: Integer;
  Category: TspButtonCategory = nil): TspButtonItem;
var
  Row, Col: Integer;
  CategoryBounds, ButtonBounds: TRect;
  ResIndex: Integer;
  ButtonsPerRow: Integer;
begin
  Result := nil;
  if Category = nil then
    Category := GetCategoryAt(X, Y);
  if Category <> nil then
  begin
    { Translate the X or Y position to our virtual system }
    if FButtonFlow = bscbfVertical then
      Y := Y + GetScrollOffset { Amount hidden }
    else
      X := X + GetScrollOffset;
    GetCategoryBounds(Category, Category.FStart, CategoryBounds, ButtonBounds);
    if (X >= ButtonBounds.Left) and (X <= ButtonBounds.Right) and
       (Y >= ButtonBounds.Top) and (Y <= ButtonBounds.Bottom) then
    begin
      { Find out which button it is. }
      Row := (Y - ButtonBounds.Top) div FButtonHeight;
      if (FButtonFlow = bscbfVertical) and (spboFullSize in FButtonOptions) then
        Col := 0
      else
      begin
        Col := (X - ButtonBounds.Left) div FButtonWidth;
        if ButtonBounds.Left + (Col+1)*FButtonWidth > ButtonBounds.Right then
          Exit; { Not within the bounds }
      end;

      if FButtonFlow = bscbfVertical then
        ButtonsPerRow := CalcButtonsPerRow
      else
        ButtonsPerRow := (ButtonBounds.Right - ButtonBounds.Left) div FButtonWidth;
      ResIndex := Row * ButtonsPerRow + Col;
      if ResIndex < Category.Items.Count then
        Result := Category.Items[ResIndex];
    end;
  end;
end;

procedure TspSkinCategoryButtons.DoItemClicked(const Button: TspButtonItem);
begin
  if (Button <> nil) and Assigned(Button.OnClick) then
    Button.OnClick(Self)
  else if Assigned(FOnButtonClicked) then
    FOnButtonClicked(Self, Button);
end;

procedure TspSkinCategoryButtons.DragDrop(Source: TObject; X, Y: Integer);
var
  TargetButton: TspButtonItem;
  TargetCategory: TspButtonCategory;
begin
  if ((spboAllowReorder in ButtonOptions) and
    ((Source = Self) or
        ((Source is TBaseDragControlObject) and (TBaseDragControlObject(Source).Control = Self)))) then
  begin
    RemoveInsertionPoints;
    GetTargetAt(X, Y, TargetButton, TargetCategory);
    if (TargetCategory <> nil) and (FDragButton <> nil) then
    begin
      { Reordering, or copying? }
      if (spboAllowCopyingButtons in ButtonOptions) and
         (GetKeyState(VK_CONTROL) < 0) then
        DoCopyButton(FDragButton, TargetCategory, TargetButton)
      else
        DoReorderButton(FDragButton, TargetCategory, TargetButton);
    end
    else if (FDragCategory <> nil) then
      DoReorderCategory(FDragCategory, TargetCategory);
    FDragButton := nil;
    FDragCategory := nil;
  end
  else
    inherited;
end;

procedure TspSkinCategoryButtons.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  OverButton: TspButtonItem;
  OverCategory: TspButtonCategory;
  Temp: Integer;
begin
  if (spboAllowReorder in ButtonOptions) and
    ((Source = Self) or ((Source is TBaseDragControlObject) and
        (TBaseDragControlObject(Source).Control = Self))) then
  begin
    if ShouldScrollDown(Temp) then
      AutoScroll(scLineDown)
    else if ShouldScrollUp(Temp) then
      AutoScroll(scLineUp);

    GetTargetAt(X, Y, OverButton, OverCategory);

    if (spboAllowCopyingButtons in ButtonOptions) and
       (GetKeyState(VK_CONTROL) < 0) then
    begin
      Accept := FDragButton <> nil; { Copy from somewhere to anywhere }
      DragCursor := crDragCopy;
    end
    else
    begin
      { Don't accept when it is the same as the start or right after us }
      Accept := (FDragButton <> nil) and (OverButton <> FDragButton)
        and (OverButton <> nil) and (OverButton.Index <> FDragButton.Index + 1);
      DragCursor := crDrag;
    end;

    if not Accept then
    begin
      { Accept if it is into another category, or it isn't the last index
        in the current category }
      Accept := (FDragButton <> nil) and (OverCategory <> nil) and
        ((OverCategory <> FDragButton.Category) or
         ((FDragButton <> OverButton) and (OverButton <> nil) and
           (OverButton.Index <> FDragButton.Index + 1)));
      { If we are dragging the category, use similar logic }
      if (not Accept) and (FDragCategory <> nil) then
      begin
        OverButton := nil;
        Accept := OverCategory <> FDragCategory;
        if Accept then
          if OverCategory = nil then
            Accept := FDragCategory.Index <> Categories.Count - 1;
      end;
    end;

    if FDragButton <> nil then
    begin
      if Accept and (State <> dsDragLeave) then
      begin
        SetInsertionButton(OverButton, OverCategory)
      end
      else
      begin
        if FDragImageList.Dragging then
          FDragImageList.HideDragImage;
        RemoveInsertionPoints;
        if FDragImageList.Dragging then
        begin
          UpdateWindow(Handle);
          FDragImageList.ShowDragImage;
        end;
      end;
    end;
  end
  else
    inherited DragOver(Source, X, Y, State, Accept);
end;

procedure TspSkinCategoryButtons.DoHotButton;
begin
  if Assigned(FOnHotButton) then
    FOnHotButton(Self, FHotButton);
end;

procedure TspSkinCategoryButtons.DoStartDrag(var DragObject: TDragObject);
var
  ButtonRect: TRect;
  State: TspButtonDrawState;
  DragImage: TBitmap;
  Y: Integer;
begin
  inherited DoStartDrag(DragObject);
  DragImage := TBitmap.Create;
  try
    if FDragButton <> nil then
    begin
      ButtonRect := GetButtonRect(FDragButton);
      DragImage.Width := ButtonRect.Right - ButtonRect.Left;
      DragImage.Height := ButtonRect.Bottom - ButtonRect.Top;
      State := [spbdsDragged];
      if FSelectedItem = FDragButton then
        State := State + [spbdsSelected];

      DragImage.Canvas.Brush.Color := clBtnFace;
      DragImage.Canvas.FillRect(Rect(0, 0, DragImage.Width, DragImage.Height));
      DrawButton(FDragButton, DragImage.Canvas,
        Rect(0, 0, DragImage.Width, DragImage.Height), State);
    end
    else
    begin
      Assert(FDragCategory <> nil);
      if (FDragCategory <> nil) then
      begin
        ButtonRect := GetCategoryRect(FDragCategory);
        DragImage.Width := ButtonRect.Right - ButtonRect.Left + 3;
        DragImage.Height := ButtonRect.Bottom - ButtonRect.Top + 2;
        DragImage.Canvas.Brush.Color := clBtnFace;
        DragImage.Canvas.FillRect(Rect(0, 0, DragImage.Width, DragImage.Height));
        Y := 0;
        DrawCategory(FDragCategory, DragImage.Canvas, Y);
      end;
    end;

    if (FDragButton <> nil) or (FDragCategory <> nil) then
    begin
      FDragImageList.Clear;
      FDragImageList.Width := DragImage.Width;
      FDragImageList.Height := DragImage.Height;
      FDragImageList.Add(DragImage, nil);
    end;
  finally
    DragImage.Free;
  end;
end;

function TspSkinCategoryButtons.GetDragImages: TDragImageList;
begin
  Result := FDragImageList;
end;

procedure TspSkinCategoryButtons.RemoveInsertionPoints;

  procedure ClearSelection(var Item: TspButtonItem);
  var
    OldItem: TspButtonItem;
  begin
    if Item <> nil then
    begin
      OldItem := Item;
      Item := nil;
      UpdateButton(OldItem);
    end;
  end;
begin
  ClearSelection(FInsertTop);
  ClearSelection(FInsertLeft);
  ClearSelection(FInsertRight);
  ClearSelection(FInsertBottom);
end;

procedure TspSkinCategoryButtons.DoReorderButton(const Button: TspButtonItem;
  const TargetCategory: TspButtonCategory; const TargetButton: TspButtonItem);
var
  TargetIndex: Integer;
  OldCategory: TspButtonCategory;
begin
  FIgnoreUpdate := True;
  try
    { Are we moving in the same cateogry to over a button? }
    OldCategory := Button.Category;
    if (TargetButton <> nil) and (Button.Category = TargetButton.Category) then
    begin
      TargetIndex := TargetButton.Index;
      if TargetIndex > Button.Index then
        Dec(TargetIndex); { Account for moving ourselves }
      Button.Index := TargetIndex;
    end
    else if TargetCategory <> nil then
    begin
      if TargetCategory = Button.Category then
      begin
        { Moving to the end of the category }
        Button.Index := TargetCategory.Items.Count - 1;
      end
      else
      begin
        Button.Collection := TargetCategory.Items;
        if (TargetButton <> nil) then
          Button.Index := TargetButton.Index;
        Resize; { We have to recalculate the group's size }
      end;
    end;
  finally
    FIgnoreUpdate := False;
  end;
  Invalidate;
  if Assigned(FOnReorderButton) then
    FOnReorderButton(Self, Button, OldCategory, TargetCategory);
end;

const
  cMinScrollDelay = 20;
  cMaxScrollDelay = 400;

function TspSkinCategoryButtons.ShouldScrollDown(out Delay: Integer): Boolean;
var
  ScrollBuffer: Integer;
  AWidth, AHeight: Integer;
  P: TPoint;
begin
  Result := FScrollBarPos < FScrollBarMax;
  if Result then
  begin
    ScrollBuffer := GetScrollBuffer;
    { Is the mouse still in position? }
     P := ScreenToClient(Mouse.CursorPos);
    with P do
    begin
      if FButtonFlow = bscbfHorizontal then
      begin
        { Switch X and Y and Width and Height }
        AWidth := X; { temp }
        X := Y;
        Y := AWidth;        
        AWidth := Height;
        AHeight := Width;
      end
      else
      begin
        AWidth := Width;
        AHeight := Height;
      end;

      if (X < 0) or (X > AWidth) or (Y > AHeight) or (Y < AHeight - ScrollBuffer) then
        Result := False
      else
        Delay := Trunc(cMaxScrollDelay * ((AHeight - Y) / ScrollBuffer)) + cMinScrollDelay;
    end
  end;
end;

function TspSkinCategoryButtons.ShouldScrollUp(out Delay: Integer): Boolean;
var
  ScrollBuffer: Integer;
  AWidth: Integer;
  P: TPoint;
begin
  Result := FScrollBarPos > 0;
  if Result then
  begin
    ScrollBuffer := GetScrollBuffer;
    P := ScreenToClient(Mouse.CursorPos); 
    with P do
    begin
      if FButtonFlow = bscbfHorizontal then
      begin
        AWidth := X;
        X := Y;
        Y := AWidth;
        AWidth := Height;
      end
      else
        AWidth := Width;

      if (X < 0) or (X > AWidth) or (Y < 0) or (Y > ScrollBuffer) then
        Result := False
      else
        Delay := Trunc(cMaxScrollDelay * (Y / ScrollBuffer)) + cMinScrollDelay;
    end;
  end;
end;


procedure TspSkinCategoryButtons.AutoScroll(ScrollCode: TScrollCode);

  function ShouldContinue(out Delay: Integer): Boolean;
  begin
    { Are we autoscrolling up or down? }
    if ScrollCode = scLineDown then
      Result := ShouldScrollDown(Delay)
    else
      Result := ShouldScrollUp(Delay)
  end;
  
var
  CurrentTime, StartTime, ElapsedTime: Longint;
  Delay: Integer;
begin
  FDragImageList.HideDragImage;
  RemoveInsertionPoints;
  FDragImageList.ShowDragImage;

  CurrentTime := 0;
  while (ShouldContinue(Delay)) do
  begin
    StartTime := GetCurrentTime;
    ElapsedTime := StartTime - CurrentTime;
    if ElapsedTime < Delay then
      Sleep(Delay - ElapsedTime);
    CurrentTime := StartTime;

    FDragImageList.HideDragImage;
    ScrollPosChanged(ScrollCode, 0{ Ignored});
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end;
end;

function TspSkinCategoryButtons.GetNextButtonInGroup(const StartingButton: TspButtonItem;
  GoForward: Boolean): TspButtonItem;
var
  Category: TspButtonCategory;
  NextIndex: Integer;
begin
  Result := nil;
  if StartingButton <> nil then
  begin
    Category := StartingButton.Category;
    if GoForward then
      NextIndex := StartingButton.Index + 1
    else
      NextIndex := StartingButton.Index - 1;

    if (NextIndex > -1) and (NextIndex < Category.Items.Count) then
      Result := Category.Items[NextIndex];  { Same category, next button in it. }
  end;
end;

procedure TspSkinCategoryButtons.GetTargetAt(X, Y: Integer;
  var TargetButton: TspButtonItem; var TargetCategory: TspButtonCategory);
var
  ButtonRect: TRect;
begin
  TargetCategory := GetCategoryAt(X, Y);
  TargetButton := GetButtonAt(X, Y, TargetCategory);
  if (TargetButton <> nil) then
  begin
    { Before the index, or after it?  }
    ButtonRect := GetButtonRect(TargetButton);

    if (FButtonFlow = bscbfVertical) and (CalcButtonsPerRow = 1) then
    begin
      if Y > (ButtonRect.Top + (ButtonRect.Bottom - ButtonRect.Top) div 2) then
        TargetButton := GetNextButtonInGroup(TargetButton, True);
    end
    else
      if X > (ButtonRect.Left + (ButtonRect.Right - ButtonRect.Left) div 2) then
        TargetButton := GetNextButtonInGroup(TargetButton, True);
  end
  else if (TargetCategory <> nil) and (TargetCategory.Items.Count > 0) then
  begin
    { Insert before or after all the items? }
    if FButtonFlow = bscbfVertical then
      Y := Y + GetScrollOffset { Amount hidden }
    else
      X := X + GetScrollOffset;
    if (FButtonFlow = bscbfVertical) and (CalcButtonsPerRow = 1) then
    begin
      if Y < (TargetCategory.FStart + (TargetCategory.FEnd - TargetCategory.FStart) div 2) then
        if (not TargetCategory.Collapsed) then
          TargetButton := TargetCategory.Items[0]
    end
    else
      if X < ((ClientWidth - GetScrollSize) div 2) then
        if (not TargetCategory.Collapsed) then
          TargetButton := TargetCategory.Items[0]
  end;
end;

procedure TspSkinCategoryButtons.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TspSkinCategoryButtons.CNKeydown(var Message: TWMKeyDown);
var
  IncAmount: Integer;
  CurrentItem: TspButtonItem;

  procedure FixIncAmount(const StartValue: Integer);
  begin
    { Keep it within the bounds }
    if StartValue + IncAmount >= FButtonCategories.Count then
      IncAmount := FButtonCategories.Count - StartValue - 1
    else if StartValue + IncAmount < 0 then
      IncAmount := 0 - StartValue; 
  end;

  function CalcRowsSeen: Integer;
  begin
    Result := ClientHeight div FButtonHeight;
  end;

  function GetNextItem(const StartIndex: Integer; SuggestedIndex: Integer): TspButtonItem;
  var
    CatCount: Integer;
    I: Integer;
  begin
    Result := nil;
    for I := StartIndex to FButtonCategories.Count - 1 do
    begin
      CatCount := FButtonCategories[I].Items.Count;
      if CatCount > 0 then
      begin
        if SuggestedIndex >= CatCount then
          SuggestedIndex := CatCount - 1;
        Result := FButtonCategories[I].Items[SuggestedIndex];
        Break;
      end;
    end;
  end;

  function GetPriorItem(const StartIndex: Integer; Col: Integer): TspButtonItem;
  var
    I: Integer;
    CatCount: Integer;
    Category: TspButtonCategory;
    LastRow: Integer;
    ButtonsPerRow: Integer;
  begin
    Result := nil;
    ButtonsPerRow := CalcButtonsPerRow;
    for I := StartIndex downto 0 do
    begin
      Category := FButtonCategories[I];
      CatCount := Category.Items.Count;
      if CatCount > 0 then
      begin
        LastRow := CatCount div ButtonsPerRow - 1;
        if CatCount mod ButtonsPerRow <> 0 then
          Inc(LastRow);

        Col := Col + LastRow*ButtonsPerRow;

        if Col >= CatCount then
          Col := CatCount - 1;
        Result := Category.Items[Col];
        Break;
      end;
    end;
  end;

  function CalcActualButtonsPerRow: Integer;
  var
    CatBounds, Temp: TRect;
  begin
    if FButtonFlow = bscbfVertical then
      Result := CalcButtonsPerRow
    else
    begin
      GetCategoryBounds(CurrentItem.Category, 0, CatBounds, Temp);
      Result := (CatBounds.Right - CatBounds.Left) div FButtonWidth;
      if Result = 0 then
        Result := 1;
    end;
  end;

  function GetNext(GoForward: Boolean): TspButtonItem;
  var
    Row, Col: Integer;
    ButtonsPerRow: Integer;
    CatCount: Integer;
    I: Integer;
  begin
    Result := nil;
    if CurrentItem <> nil then
    begin
      ButtonsPerRow := CalcActualButtonsPerRow;

      CatCount := CurrentItem.Category.Items.Count;
      Row := CurrentItem.Index div ButtonsPerRow;
      Col := CurrentItem.Index mod ButtonsPerRow;
      if GoForward then
        Inc(Row)
      else
        Dec(Row);

      if (Row > -1) and (Row*ButtonsPerRow < CatCount) and
         (not CurrentItem.Category.Collapsed) then
      begin
        I := Col + Row*ButtonsPerRow;
        if I >= CatCount then
          I := CatCount - 1;
        Result := CurrentItem.Category.Items[I];
      end
      else if FButtonFlow = bscbfVertical then
      begin
        I := CurrentItem.Category.Index;
        if GoForward then
        begin
          Inc(I);
          Result := GetNextItem(I, Col);
        end
        else
        begin
          Dec(I);
          Result := GetPriorItem(I, Col);
        end;
      end;
    end
    else if (FButtonFlow = bscbfVertical) and GoForward then
      Result := GetNextItem(0, 0);
  end;

  function MoveSideways(IsLeft: Boolean): TspButtonItem;
  var
    ButtonsPerRow: Integer;
    Col: Integer;
    Row: Integer;
    NewIndex: Integer;
  begin
    Result := nil;

    ButtonsPerRow := CalcActualButtonsPerRow;
    Col := CurrentItem.Index mod ButtonsPerRow;
    if IsLeft and (Col > 0) then
      NewIndex := CurrentItem.Index - 1 { Can move to the left }
    else if (not IsLeft) and (Col < ButtonsPerRow - 1) then
      NewIndex := CurrentItem.Index + 1
    else
      NewIndex := -1;
    if (NewIndex >= 0) and (NewIndex < CurrentItem.Category.Items.Count) then
      Result := CurrentItem.Category.Items[NewIndex]
    else if (FButtonFlow = bscbfHorizontal) then
    begin
      { Try the next category }
      if IsLeft then
      begin
        if CurrentItem.Category.Index <> 0 then
          Result := GetPriorItem(CurrentItem.Category.Index - 1, 0)
      end
      else
        Result := GetNextItem(CurrentItem.Category.Index + 1, 0);
      { Try and maintain the same row that we were on }
      if Result <> nil then
      begin
        Row := CurrentItem.Index div ButtonsPerRow;
        CurrentItem := Result;
        ButtonsPerRow := CalcActualButtonsPerRow;
        if IsLeft then
          Col := ButtonsPerRow - 1
        else
          Col := 0;
        NewIndex := Col + Row*ButtonsPerRow;
        if NewIndex >= Result.Category.Items.Count then
          NewIndex := Result.Category.Items.Count - 1;
        Result := Result.Category.Items[NewIndex];
      end;
    end
  end;

  function CtrlIsDown: Boolean;
  begin
    Result := (GetKeyState(VK_CONTROL) and not $7FFF) <> 0;
  end;

  function ChangePage(GoForward: Boolean): TspButtonItem;
  var
    NewTop: Integer;
    NewCat: TspButtonCategory;
    I: Integer;
    TempBounds, ButtonBounds: TRect;
    YInCat: Integer;
  begin
    NewTop := ClientHeight;
    if not GoForward then
      NewTop := NewTop * -1;

    if CurrentItem <> nil then
      NewTop := GetButtonRect(CurrentItem).Top + FGutterSize * FScrollBarPos
        + NewTop;

    if NewTop < 0 then
      NewTop := 0
    else if NewTop > FButtonCategories[FButtonCategories.Count-1].FEnd then
      NewTop := FButtonCategories[FButtonCategories.Count-1].FEnd - 1;

    { Find where this is at }
    NewCat := nil;
    for I := 0 to FButtonCategories.Count - 1 do
    begin
      if (FButtonCategories[I].Items.Count > 0) and
         (NewTop < FButtonCategories[I].FEnd) then
      begin
        NewCat := FButtonCategories[I];
        Break;
      end;
    end;

    if NewCat <> nil then
    begin
      if NewCat.Collapsed then
        Result := NewCat.Items[0]
      else
      begin
        { Find which button we would be on }
        GetCategoryBounds(NewCat, NewCat.FStart, TempBounds, ButtonBounds);
        YInCat := NewTop - ButtonBounds.Top;
        if YInCat < 0 then
          YInCat := 0;
        I := YInCat div FButtonHeight;
        if YInCat mod FButtonHeight <> 0 then
          Inc(I);
        if I < 0 then
          I := 0
        else if I >= NewCat.Items.Count then
          I := NewCat.Items.Count - 1;
        Result := NewCat.Items[I];
      end;
    end
    else
      Result := nil;
  end;

var
  NewItem: TspButtonItem;
  I: Integer;
begin
  CurrentItem := FSelectedItem;
  if CurrentItem = nil then
    CurrentItem := FFocusedItem;

  NewItem := nil;
  if Message.CharCode = VK_DOWN then
    NewItem := GetNext(True)
  else if Message.CharCode = VK_UP then
    NewItem := GetNext(False)
  else if Message.CharCode = VK_LEFT then
  begin
    if CurrentItem <> nil then
    begin
      if CtrlIsDown and not CurrentItem.Category.Collapsed then
        CurrentItem.Category.Collapsed := True
      else
        NewItem := MoveSideways(True)
    end;
  end
  else if Message.CharCode = VK_RIGHT then
  begin
    if CurrentItem <> nil then
    begin
      if CtrlIsDown and CurrentItem.Category.Collapsed
      then
        begin
          CurrentItem.Category.Collapsed := False;
          Resize;
        end
      else
        NewItem := MoveSideways(False)
    end;
  end
  else if Message.CharCode = VK_NEXT then
  begin
    NewItem := ChangePage(True);
  end
  else if Message.CharCode = VK_PRIOR then
  begin
    NewItem := ChangePage(False);
  end
  else if (Message.CharCode = VK_RETURN) and (CurrentItem <> nil) then
  begin
    if CurrentItem.Category.Collapsed
    then
      begin
        CurrentItem.Category.Collapsed := False;
        Resize;
      end;
    SelectedItem := CurrentItem;
    DoItemClicked(CurrentItem)
  end
  else if Message.CharCode = VK_HOME then
    for I := 0 to Categories.Count - 1 do
    begin
      if Categories[I].Items.Count > 0 then
      begin
        NewItem := Categories[I].Items[0];
        Break;
      end
    end
  else if Message.CharCode = VK_END then
    for I := Categories.Count - 1 downto 0 do
    begin
      if Categories[I].Items.Count > 0 then
      begin
        NewItem := Categories[I].Items[Categories[I].Items.Count - 1];
        Break;
      end
    end
  else if (Message.CharCode = VK_RETURN) and (CurrentItem <> nil) then
  begin
    SelectedItem := CurrentItem;
    DoItemClicked(CurrentItem)
  end
  else
    inherited;

  if NewItem <> nil then
  begin
    UpdateButton(FHotButton);
    FHotButton := nil;
    SelectedItem := NewItem;
  end;
end;

procedure TspSkinCategoryButtons.ScrollIntoView(const Button: TspButtonItem);
begin
  if Button.Category.Collapsed then
    ScrollIntoView(Button.Category)
  else
    ScrollRectIntoView(GetButtonRect(Button));
end;

procedure TspSkinCategoryButtons.CMHintShow(var Message: TCMHintShow);
var
  CurrentItem: TspButtonItem;
  CurrentCat: TspButtonCategory;
  CatRect: TRect;
  Handled: Boolean;
  HintStr: string;
begin
  Message.Result := 1; { Don't show the hint }
  if Message.HintInfo.HintControl = Self then
  begin
    with Message.HintInfo.CursorPos do
    begin
      CurrentCat := GetCategoryAt(X, Y);
      CurrentItem := GetButtonAt(X, Y, CurrentCat);
    end;

    Handled := False;
    HintStr := '';
    if Assigned(FOnGetHint) then
      FOnGetHint(Self, CurrentItem, CurrentCat, HintStr, Handled);
    if (CurrentItem <> nil) then
    begin
      if not Handled then
      begin
        if CurrentItem.Hint <> '' then
          HintStr := CurrentItem.Hint
        else
          HintStr := CurrentItem.Caption;
        if (CurrentItem.ActionLink <> nil) then
          CurrentItem.ActionLink.DoShowHint(HintStr);
      end;
      Message.HintInfo.CursorRect := GetButtonRect(CurrentItem);
      Handled := True;
    end
    else if (CurrentCat <> nil) then
    begin
      if not Handled then
        HintStr := CurrentCat.Caption;

      CatRect := GetCategoryRect(CurrentCat);
      if not CurrentCat.Collapsed then { exclude the button area on the right }
        CatRect.Right := CatRect.Left + FGutterSize;
      Message.HintInfo.CursorRect := CatRect;

      Handled := True;
    end;
    if Handled then
    begin
      Message.HintInfo.HintStr := HintStr;
      Message.Result := 0; { Show the hint }
    end;
  end;
end;

procedure TspSkinCategoryButtons.Assign(Source: TPersistent);
begin
  if Source is TspSkinCategoryButtons then
  begin
    Categories := TspSkinCategoryButtons(Source).Categories;
    ButtonHeight := TspSkinCategoryButtons(Source).ButtonHeight;
    ButtonWidth := TspSkinCategoryButtons(Source).ButtonWidth;
    ButtonOptions := TspSkinCategoryButtons(Source).ButtonOptions;
  end
  else
    inherited;
end;

procedure TspSkinCategoryButtons.SetInsertionButton(InsertionButton: TspButtonItem;
  InsertionCategory: TspButtonCategory);

  procedure UpdateAll;
  begin
    UpdateButton(FInsertTop);
    UpdateButton(FInsertLeft);
    UpdateButton(FInsertBottom);
    UpdateButton(FInsertRight);
    UpdateWindow(Handle);
  end;

  function CalcActualButtonsPerRow: Integer;
  var
    CatBounds, Temp: TRect;
  begin
    if FButtonFlow = bscbfVertical then
      Result := CalcButtonsPerRow
    else
    begin
      GetCategoryBounds(InsertionCategory, 0, CatBounds, Temp);
      Result := (CatBounds.Right - CatBounds.Left) div FButtonWidth;
    end;
  end;

var
  ButtonsPerRow: Integer;

begin
  if (FDragCategory = nil) then
  begin
    ButtonsPerRow := CalcActualButtonsPerRow;
    if (InsertionButton = nil) and (InsertionCategory <> nil) and
       (InsertionCategory.Items.Count > 0) then
    begin
      { Appending a button to the current category }
      if FDragImageList.Dragging then
        FDragImageList.HideDragImage;
      RemoveInsertionPoints;
      InsertionButton := InsertionCategory.Items[InsertionCategory.Items.Count - 1];
      if ButtonsPerRow = 1 then
        FInsertBottom := InsertionButton
      else
        FInsertRight := InsertionButton;
      UpdateAll;
      if FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end
    else if ((ButtonsPerRow = 1) and (FInsertTop <> InsertionButton)) or
        ((ButtonsPerRow > 1) and (FInsertLeft <> InsertionButton)) then
    begin
      if FDragImageList.Dragging then
        FDragImageList.HideDragImage;
      RemoveInsertionPoints;
      if ButtonsPerRow = 1 then
      begin
        FInsertTop := InsertionButton;
        FInsertBottom := GetNextButtonInGroup(InsertionButton, False);
      end
      else
      begin
        { More than one button per row, so use Left/Right separators }
        FInsertLeft := InsertionButton;
        FInsertRight := GetNextButtonInGroup(InsertionButton, False);
      end;
      UpdateAll;
      if FDragImageList.Dragging then
        FDragImageList.ShowDragImage;
    end;
  end;
end;

procedure TspSkinCategoryButtons.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
  FDragImageList.EndDrag;
  FDragButton := nil;
  FDragCategory := nil;
  RemoveInsertionPoints;
end;

procedure TspSkinCategoryButtons.SetSelectedItem(const Value: TspButtonItem);

  procedure UpdateCategory(const Category: TspButtonCategory);
  var
    R: TRect;
  begin
    if HandleAllocated then
    begin
      R := GetCategoryRect(Category);
      InvalidateRect(Handle, @R, False);
    end;
  end;
  
begin
  if FSelectedItem <> Value then
  begin
    if FFocusedItem <> Value then
      UpdateButton(FFocusedItem);

    if FSelectedItem <> nil then
    begin
      UpdateButton(FSelectedItem);
      if FSelectedItem.Category.Collapsed then
        UpdateCategory(FSelectedItem.Category)
    end;
    if Value <> nil then
      ScrollIntoView(Value);
    FSelectedItem := Value;
    if Value <> nil then
      FFocusedItem := Value;
    if FSelectedItem <> nil then
    begin
      UpdateButton(FSelectedItem);
      if FSelectedItem.Category.Collapsed then
        UpdateCategory(FSelectedItem.Category);
    end;
    DoSelectedItemChanged(FSelectedItem);
  end;
end;

function TspSkinCategoryButtons.GetIndexOfFirstCategory: Integer;
var
  TopPos: Integer;
  CatIndex: Integer;
begin
  Result := -1;
  TopPos := GetScrollOffset;
  { Avoid drawing hidden categories }
  for CatIndex := 0 to FButtonCategories.Count - 1 do
  begin
    if FButtonCategories[CatIndex].FEnd >= TopPos then
    begin
      Result := CatIndex;
      Exit;
    end;
  end;
end;

function TspSkinCategoryButtons.GetCategoryAt(X, Y: Integer): TspButtonCategory;
var
  I: Integer;
  CurrentPos: Integer;
begin
  Result := nil;
  { Is it within our X and Y bounds first? }
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
  begin
    { It is, so translate the X or Y position to our virtual system }
    if FButtonFlow = bscbfVertical then
      CurrentPos := Y + GetScrollOffset
    else
      CurrentPos := X + GetScrollOffset;
    { Find out which category this X or Y position would lie in }
    for I := 0 to FButtonCategories.Count - 1 do
    begin
      if CurrentPos <= FButtonCategories[I].FEnd - 1 then
      begin
        Result := FButtonCategories[I];
        Break;
      end;
    end;
  end;
end;

procedure TspSkinCategoryButtons.ScrollIntoView(const Category: TspButtonCategory);
begin
  ScrollRectIntoView(GetCategoryRect(Category));
end;

procedure TspSkinCategoryButtons.ScrollRectIntoView(const Rect: TRect);
var
  Amount: Integer;

  procedure CalcAmount(const ScrollPixels: Integer);
  begin
    Amount := ScrollPixels div FGutterSize;
    if ScrollPixels mod FGutterSize <> 0 then
      Inc(Amount);
  end;

var
  RectStart, RectEnd, MaxSize: Integer;
begin
  if FButtonFlow = bscbfVertical then
  begin
    RectStart := Rect.Top;
    RectEnd := Rect.Bottom;
    MaxSize := ClientHeight;
  end
  else
  begin
    RectStart := Rect.Left;
    RectEnd := Rect.Right;
    MaxSize := ClientWidth;
  end;

  if RectStart < 0 then
  begin
    CalcAmount(-1*RectStart);
    if FScrollBarPos - Amount < 0 then
      Amount := FScrollBarPos;
    ScrollPosChanged(scPosition, FScrollBarPos - Amount);
  end
  else if RectStart > MaxSize then
  begin
    if (RectEnd - RectStart > MaxSize) then
      CalcAmount(RectStart) { Put the start into view at the top}
    else
      CalcAmount(RectEnd - MaxSize); { Put the whole thing into view at the bottom }

    if FScrollBarPos + Amount > FScrollBarMax then
      ScrollPosChanged(scPosition, FScrollBarMax)
    else
      ScrollPosChanged(scPosition, FScrollBarPos + Amount);
  end
  else if RectEnd > MaxSize then
  begin
    CalcAmount(RectEnd - MaxSize);          
    
    if FScrollBarPos + Amount > FScrollBarMax then
      ScrollPosChanged(scPosition, FScrollBarMax)
    else
      ScrollPosChanged(scPosition, FScrollBarPos + Amount);
  end;
end;

function TspSkinCategoryButtons.GetCategoryRect(const Category: TspButtonCategory): TRect;
var
  YPos: Integer;
  ButtonBounds: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  YPos := Category.FStart - GetScrollOffset;
  GetCategoryBounds(Category, YPos, Result, ButtonBounds);
end;

function TspSkinCategoryButtons.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  NextButton: TspButtonItem;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotButton);
    FHotButton := nil;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineUp, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageUp, 0)
    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, False);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
  end;
end;

function TspSkinCategoryButtons.GetNextButton(const StartingButton: TspButtonItem;
  GoForward: Boolean): TspButtonItem;

  function ProcessCategory(const Category: TspButtonCategory): TspButtonItem;
  begin
    if (not Category.Collapsed) and (Category.Items.Count > 0) then
      if GoForward then
        Result := Category.Items[0]
      else
        Result := Category.Items[Category.Items.Count - 1]
    else
      Result := nil;
  end;

var
  I: Integer;
begin
  if StartingButton <> nil then
  begin
    Result := GetNextButtonInGroup(StartingButton, GoForward);
    if Result = nil then
    begin
      if GoForward then
      begin
        for I := StartingButton.Category.Index + 1 to FButtonCategories.Count -1 do
        begin
          Result := ProcessCategory(FButtonCategories[I]);
          if Result <> nil then
            Break;
        end
      end
      else
      begin
        for I := StartingButton.Category.Index - 1 downto 0 do
        begin
          Result := ProcessCategory(FButtonCategories[I]);
          if Result <> nil then
            Break;
        end
      end;
    end;
  end
  else
    Result := nil;
end;

function TspSkinCategoryButtons.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  NextButton: TspButtonItem;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotButton);
    FHotButton := nil;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineDown, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageDown, 0)
    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, True);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
  end;
end;

procedure TspSkinCategoryButtons.DoReorderCategory(const SourceCategory,
  TargetCategory: TspButtonCategory);
begin
  if TargetCategory = nil then
    SourceCategory.Index := FButtonCategories.Count - 1
  else
    SourceCategory.Index := TargetCategory.Index;
//  SourceCategory.ScrollIntoView;
//  if Assigned(FOnReorderCategory) then
  //  FOnReorderCategory(Self, SourceCategory, TargetCategory);
end;

function TspSkinCategoryButtons.GetScrollBuffer: Integer;
begin
  Result := FGutterSize * 2;
  if Result < 6 then
    Result := 6;
end;

procedure TspSkinCategoryButtons.SetFocusedItem(const Value: TspButtonItem);
begin
  if FFocusedItem <> Value then
  begin
    FFocusedItem := Value;
    Invalidate;
  end;
end;

procedure TspSkinCategoryButtons.DoSelectedItemChanged(
  const Button: TspButtonItem);
begin
  if Assigned(FOnSelectedItemChange) then
    FOnSelectedItemChange(Self, Button);
end;

procedure TspSkinCategoryButtons.DoCopyButton(const Button: TspButtonItem;
  const TargetCategory: TspButtonCategory; const TargetButton: TspButtonItem);
var
  CopiedButton: TspButtonItem;
begin
  CopiedButton := TargetCategory.Items.Add;
  if TargetButton <> nil then
    CopiedButton.Index := TargetButton.Index;
  CopiedButton.Assign(Button);
 if Assigned(FOnCopyButton) then
    FOnCopyButton(Self, Button, CopiedButton);
end;

procedure TspSkinCategoryButtons.SetHotButtonColor(const Value: TColor);
begin
  if FHotButtonColor <> Value then
  begin
    FHotButtonColor := Value;
    Invalidate;
  end;
end;

procedure TspSkinCategoryButtons.SetRegularButtonColor(const Value: TColor);
begin
  if FRegularButtonColor <> Value then
  begin
    FRegularButtonColor := Value;
    Invalidate;
  end;
end;

procedure TspSkinCategoryButtons.SetSelectedButtonColor(const Value: TColor);
begin
  if FSelectedButtonColor <> Value then
  begin
    FSelectedButtonColor := Value;
    Invalidate;
  end;
end;

procedure TspSkinCategoryButtons.SetButtonFlow(const Value: TspCatButtonFlow);
begin
  if FButtonFlow <> Value then
  begin
    FButtonFlow := Value; { Set the flow }
    CalcBufferSizes;
    FScrollBarPos := 0; { Nothing scrolled }
    { Hide the previous scroll bar, if shown, which will cause a resize }
    if FSkinScrollBar <> nil
    then
      ShowSkinScrollBar(False)
    else
    begin
      { We have to resize }
      Resize;
      Invalidate;
    end;
  end;
end;

procedure TspSkinCategoryButtons.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  UpdateButton(FFocusedItem);
end;

procedure TspSkinCategoryButtons.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  UpdateButton(FFocusedItem);
end;

procedure TspSkinCategoryButtons.CMFontchanged(var Message: TMessage);
begin
  inherited;
  CalcBufferSizes;
  Invalidate;
end;

function TspSkinCategoryButtons.GetButtonCategoriesClass: TspButtonCategoriesClass;
begin
  Result := TspButtonCategories;
end;

function TspSkinCategoryButtons.GetButtonCategoryClass: TspButtonCategoryClass;
begin
  Result := TspButtonCategory;
end;

function TspSkinCategoryButtons.GetButtonItemClass: TspButtonItemClass;
begin
  Result := TspButtonItem;
end;

procedure TspSkinCategoryButtons.SetDragButton(const Value: TspButtonItem);
begin
  FDragButton := Value;
  FDragStarted := True;
  FDragStartPos := ScreenToClient(Mouse.CursorPos);
end;

procedure TspSkinCategoryButtons.DoBeginDrag(Immediate: Boolean; Threshold: Integer);
begin
  BeginDrag(Immediate, Threshold);
end;

function TspSkinCategoryButtons.GetAllowReorder: Boolean;
begin
  Result := spboAllowReorder in ButtonOptions;
end;

function TspSkinCategoryButtons.GetScrollPos: Integer;
begin
  Result := FScrollBarPos;
end;

procedure TspSkinCategoryButtons.SetScrollPos(const Value: Integer);
begin
  if FScrollBarPos <> Value then
  begin
    FScrollBarPos := Value;
    if Categories.UpdateCount = 0 then
      Resize;
  end;
end;

{ TspBaseButtonItem }

procedure TspBaseButtonItem.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') then
        Self.Caption := Caption;
      if not CheckDefaults or (Self.Hint = '') then
        Self.Hint := Hint;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TspBaseButtonItem.Assign(Source: TPersistent);
begin
  if Source is TspBaseButtonItem then
  begin
    Caption := TspBaseButtonItem(Source).Caption;
    ImageIndex := TspBaseButtonItem(Source).ImageIndex;
    Hint := TspBaseButtonItem(Source).Hint;
    Data := TspBaseButtonItem(Source).Data;
   {$IFDEF VER200}
    InterfaceData := TspBaseButtonItem(Source).InterfaceData;
    {$ENDIF}
  end
  else
    inherited Assign(Source);
end;

constructor TspBaseButtonItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
end;

procedure TspBaseButtonItem.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

function TspBaseButtonItem.GetAction: TBasicAction;
begin
  if ActionLink <> nil then
    Result := ActionLink.Action
  else
    Result := nil;
end;

function TspBaseButtonItem.GetActionLinkClass: TspButtonItemActionLinkClass;
begin
  Result := TspButtonItemActionLink;
end;

function TspBaseButtonItem.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

function TspBaseButtonItem.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsCaptionLinked;
end;

function TspBaseButtonItem.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsHintLinked;
end;

function TspBaseButtonItem.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsImageIndexLinked;
end;

function TspBaseButtonItem.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsOnExecuteLinked;
end;

procedure TspBaseButtonItem.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    ActionLink.Free;
    ActionLink := nil;
  end
  else
  begin
    if ActionLink = nil then
      ActionLink := GetActionLinkClass.Create(Self);
    ActionLink.Action := Value;
    ActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
    Value.FreeNotification(GetNotifyTarget);
  end;
end;

procedure TspBaseButtonItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TspBaseButtonItem.SetImageIndex(const Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

{ TspButtonItem }

procedure TspButtonItem.Assign(Source: TPersistent);
begin
  if Source is TspButtonItem then
  begin
    inherited Assign(Source);
  end
  else
    inherited Assign(Source);
end;

function TspButtonItem.GetButtonGroup: TspSkinCategoryButtons;
begin
  Result := Category.Categories.ButtonGroup;
end;

function TspButtonItem.GetCategory: TspButtonCategory;
begin
  Result := TspButtonCollection(Collection).Category;
end;

function TspButtonItem.GetNotifyTarget: TComponent;
begin
  Result := TComponent(ButtonGroup);
end;

procedure TspButtonItem.ScrollIntoView;
begin
  TspSkinCategoryButtons(ButtonGroup).ScrollIntoView(Self);
end;

{ TspButtonCollection }

function TspButtonCollection.Add: TspButtonItem;
begin
  Result := TspButtonItem(inherited Add);
end;

function TspButtonCollection.AddItem(Item: TspButtonItem;
  Index: Integer): TspButtonItem;
begin
  if Item = nil then
    Result := FCategory.Categories.ButtonGroup.GetButtonItemClass.Create(Self)
  else
    Result := Item;
  if Assigned(Result) then
  begin
    Result.Collection := Self;
    if Index < 0 then
      Index := Count - 1;
    Result.Index := Index;
  end;
end;

constructor TspButtonCollection.Create(const ACategory: TspButtonCategory);
begin
  inherited Create(ACategory.Categories.ButtonGroup.GetButtonItemClass);
  FCategory := ACategory;
end;

function TspButtonCollection.GetItem(Index: Integer): TspButtonItem;
begin
  Result := TspButtonItem(inherited GetItem(Index));
end;

function TspButtonCollection.GetOwner: TPersistent;
begin
  Result := FCategory;
end;

function TspButtonCollection.Insert(Index: Integer): TspButtonItem;
begin
  Result := AddItem(nil, Index);
end;

{procedure TspButtonCollection.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
var
  ButtonGroup: TspSkinCategoryButtons;
begin
  if (Action <> cnAdded) and (FCategory <> nil) then
  begin
    ButtonGroup := FCategory.Categories.ButtonGroup;
    if not (csDestroying in ButtonGroup.ComponentState) then
    begin
      if Item = ButtonGroup.FDownButton then
        ButtonGroup.FDownButton := nil;
      if Item = ButtonGroup.FDragButton then
        ButtonGroup.FDragButton := nil;
      if Item = ButtonGroup.FHotButton then
        Buttongroup.FHotButton := nil;
      if Item = ButtonGroup.FSelectedItem then
        ButtonGroup.SelectedItem := nil;
      if Item = ButtonGroup.FFocusedItem then
        ButtonGroup.FFocusedItem := nil;
    end;
  end;
  inherited;
end;}

procedure TspButtonCollection.SetItem(Index: Integer; const Value: TspButtonItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TspButtonCollection.Update(Item: TCollectionItem);
var
  ButtonGroup: TspSkinCategoryButtons;
begin
  inherited;
  if (UpdateCount = 0) and (FCategory.Categories.UpdateCount = 0) then
  begin                          
    ButtonGroup := FCategory.Categories.ButtonGroup;
    if not ButtonGroup.FIgnoreUpdate then
    begin
      if Item <> nil then
        ButtonGroup.UpdateButton(Item as TspButtonItem)
      else
      begin
        ButtonGroup.Resize;
        ButtonGroup.UpdateAllButtons;
      end;
    end;
  end;
end;

{ TspButtonCategories }

function TspButtonCategories.Add: TspButtonCategory;
begin
  Result := TspButtonCategory(inherited Add);
end;

function TspButtonCategories.AddItem(Item: TspButtonCategory;
  Index: Integer): TspButtonCategory;
begin
  if Item = nil then
    Result := FButtonGroup.GetButtonCategoryClass.Create(Self)
  else
    Result := Item;
  if Assigned(Result) then
  begin
    Result.Collection := Self;
    if Index < 0 then
      Index := Count - 1;
    Result.Index := Index;
  end;
end;

procedure TspButtonCategories.BeginUpdate;
begin
  if UpdateCount = 0 then
    if FButtonGroup.SelectedItem <> nil then
      FOriginalID := FButtonGroup.SelectedItem.ID
    else
      FOriginalID := -1;
  inherited;
end;

constructor TspButtonCategories.Create(const ButtonGroup: TspSkinCategoryButtons);
begin
  inherited Create(ButtonGroup.GetButtonCategoryClass);
  FButtonGroup := ButtonGroup;
  FOriginalID := -1;
end;

function TspButtonCategories.GetItem(Index: Integer): TspButtonCategory;
begin
  Result := TspButtonCategory(inherited GetItem(Index));
end;

function TspButtonCategories.GetOwner: TPersistent;
begin
  Result := FButtonGroup;
end;

function TspButtonCategories.IndexOf(const Caption: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if SameText(Items[I].Caption, Caption) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TspButtonCategories.Insert(Index: Integer): TspButtonCategory;
begin
  Result := AddItem(nil, Index);
end;

procedure TspButtonCategories.SetItem(Index: Integer;
  const Value: TspButtonCategory);
begin
  inherited SetItem(Index, Value);
end;

procedure TspButtonCategories.Update(Item: TCollectionItem);
begin
  inherited;
  if (UpdateCount = 0) and (not FButtonGroup.FIgnoreUpdate) then
  begin
    FButtonGroup.Resize;
    FButtonGroup.UpdateAllButtons;
  end;
end;

{ TspButtonCategory }
var
  GLastPreset: Integer = 0;

procedure TspButtonCategory.Assign(Source: TPersistent);
begin
  if Source is TspButtonCategory then
  begin
    Caption := TspButtonCategory(Source).Caption;
    Collapsed := TspButtonCategory(Source).Collapsed;
    Data := TspButtonCategory(Source).Data;
    {$IFDEF VER200}
    InterfaceData := TspButtonCategory(Source).InterfaceData;
    {$ENDIF}
  end
  else
    inherited Assign(Source);
end;

constructor TspButtonCategory.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FItems := TspButtonCollection.Create(Self);
end;

destructor TspButtonCategory.Destroy;
begin
  if (Categories <> nil) and (Categories.ButtonGroup <> nil) and
     (Categories.ButtonGroup.SelectedItem <> nil) then
  begin
    if Categories.ButtonGroup.SelectedItem.Category = Self then
      Categories.ButtonGroup.SelectedItem := nil;
  end;
  FItems.Free;
  inherited;
end;

function TspButtonCategory.GetCategories: TspButtonCategories;
begin
  Result := TspButtonCategories(Collection);
end;

function TspButtonCategory.IndexOf(const Caption: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Items.Count - 1 do
  begin
    if SameText(Items[I].Caption, Caption) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TspButtonCategory.ScrollIntoView;
begin
  Categories.ButtonGroup.ScrollIntoView(Self);
end;

procedure TspButtonCategory.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TspButtonCategory.SetCollapsed(const Value: Boolean);
begin
  if FCollapsed <> Value then
  begin
    FCollapsed := Value;
    Changed(True);
    if Assigned(Categories.ButtonGroup.OnCategoryCollapase) then
      Categories.ButtonGroup.OnCategoryCollapase(Categories.ButtonGroup, Self);
  end;
end;

procedure TspButtonCategory.SetIndex(Value: Integer);
var
  TargetCategory: TspButtonCategory;
begin
  if Value <> Index then
  begin
    if Index < Categories.Count then
      TargetCategory := Categories[Value]
    else
      TargetCategory := nil;
    inherited;
    ScrollIntoView;
    if Assigned(Categories.ButtonGroup.FOnReorderCategory) then
      Categories.ButtonGroup.FOnReorderCategory(Categories.ButtonGroup,
        Self, TargetCategory);
  end;
end;

procedure TspButtonCategory.SetItems(const Value: TspButtonCollection);
begin
  FItems.Assign(Value);
end;

{ TspButtonItemActionLink }

procedure TspButtonItemActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TspBaseButtonItem;
end;

function TspButtonItemActionLink.DoShowHint(var HintStr: string): Boolean;
begin
  Result := True;
  if Action is TCustomAction then
    TCustomAction(Action).DoHint(HintStr);
end;

function TspButtonItemActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    (FClient.Caption = (Action as TCustomAction).Caption);
end;

function TspButtonItemActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TspButtonItemActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TspButtonItemActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    (((not Assigned(FClient.OnClick)) and (not Assigned(Action.OnExecute))) or
     (Assigned(FClient.OnClick) and (@FClient.OnClick = @Action.OnExecute)));
end;

procedure TspButtonItemActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TspButtonItemActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TspButtonItemActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TspButtonItemActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;

initialization
  { Add our drag/copy cursor image }
  Screen.Cursors[crDragCopy] := LoadCursor(HInstance, PChar('SP_CAT_DRAG_COPY')); { Do not localize }

end.


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

unit spButtonGroup;

interface

uses
  Windows, SysUtils, Classes, Controls, ImgList, Forms, Messages,
  Graphics, StdCtrls, spCategoryButtons, SkinCtrls, SkinData, ExtCtrls,
  spUtils;

type
  TspGrpButtonItem = class;
  TspGrpButtonItemClass = class of TspGrpButtonItem;
  TspGrpButtonItems = class;
  TspGrpButtonItemsClass = class of TspGrpButtonItems;

  TspGrpButtonOptions = set of (spgboAllowReorder, spgboFullSize, spgboGroupStyle,
    gboShowCaptions);

  TspGrpButtonEvent = procedure(Sender: TObject; Index: Integer) of object;
  TspGrpButtonDrawEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TspButtonDrawState) of object;
  TspGrpButtonDrawIconEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TspButtonDrawState; var TextOffset: Integer) of object;
  TspGrpButtonReorderEvent = procedure(Sender: TObject; OldIndex, NewIndex: Integer) of object;

  TspSkinButtonGroup = class(TspSkinControl)
  private
    FIs9XOS: Boolean;
    FMouseTimer: TTimer;
    FButtonsSkinDataName: String;
    FUseSkinFont: Boolean;
    FShowFocus: Boolean;
    FSkinScrollBar: TspSkinScrollBar;
    FShowBorder: Boolean;
    FDownIndex: Integer;
    FDragIndex: Integer;
    FDragStartPos: TPoint;
    FDragStarted: Boolean;
    FDragImageList: TDragImageList;
    FHiddenItems: Integer; { Hidden rows or Hidden columns, depending on the flow }
    FHotIndex: Integer;
    FInsertLeft, FInsertTop, FInsertRight, FInsertBottom: Integer;
    FIgnoreUpdate: Boolean;
    FScrollBarMax: Integer;
    FPageAmount: Integer;
    FButtonItems: TspGrpButtonItems;
    FButtonOptions: TspGrpButtonOptions;
    FButtonWidth, FButtonHeight: Integer;
    FFocusIndex: Integer;
    FItemIndex: Integer;
    FImageChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FMouseInControl: Boolean;
    FOnButtonClicked: TspGrpButtonEvent;
    FOnClick: TNotifyEvent;
    FOnHotButton: TspGrpButtonEvent;
    FOnDrawIcon: TspGrpButtonDrawIconEvent;
    FOnDrawButton: TspGrpButtonDrawEvent;
    FOnBeforeDrawButton: TspGrpButtonDrawEvent;
    FOnAfterDrawButton: TspGrpButtonDrawEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnReorderButton: TspGrpButtonReorderEvent;
    //
    procedure ShowSkinScrollBar(const Visible: Boolean);
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
    function CalcRowsSeen: Integer;
    procedure DoFillRect(const Rect: TRect);
    procedure ScrollPosChanged(ScrollCode: TScrollCode;
      ScrollPos: Integer);
    procedure SetOnDrawButton(const Value: TspGrpButtonDrawEvent);
    procedure SetOnDrawIcon(const Value: TspGrpButtonDrawIconEvent);
    procedure SeTspGrpButtonItems(const Value: TspGrpButtonItems);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetGrpButtonOptions(const Value: TspGrpButtonOptions);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetItemIndex(const Value: Integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CNKeydown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure SetDragIndex(const Value: Integer);
    procedure SetShowBorder(Value: Boolean);
    procedure OnMouseTimerEvent(Sender: TObject);
  protected
    procedure PaintBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintSkinBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintDefaultBorder(ADC: HDC; AUseExternalDC: Boolean);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;    
    
    function CreateButton: TspGrpButtonItem; virtual;
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEndDrag(Target: TObject; X: Integer; Y: Integer); override;
    procedure DoHotButton; dynamic;
    procedure DoMouseLeave; dynamic;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoReorderButton(const OldIndex, NewIndex: Integer);
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X: Integer; Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DrawButton(Index: Integer; Canvas: TCanvas;
      Rect: TRect; State: TspButtonDrawState); virtual;
    procedure DrawSkinButton(Index: Integer; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState); virtual;
    procedure DrawStretchSkinButton(Index: Integer; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState); virtual;
    procedure DoItemClicked(const Index: Integer); virtual;
    function GetButtonClass: TspGrpButtonItemClass; virtual;
    function GetButtonsClass: TspGrpButtonItemsClass; virtual;
    function GetDragImages: TDragImageList; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Resize; override;
    procedure UpdateButton(const Index: Integer);
    procedure UpdateAllButtons;
    procedure CMBENCPaint(var Message: TMessage); message CM_BENCPAINT;
    procedure CMSENCPaint(var Message: TMessage); message CM_SENCPAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Assign(Source: TPersistent); override;
    procedure ChangeSkinData; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    { DragIndex: If a drag operation is coming from this control, it is
      because they are dragging the item at DragIndex. Set DragIndex to
      control which item is being dragged before manually calling
      BeginDrag. }
    property DragIndex: Integer read FDragIndex write SetDragIndex;
    property DragImageList: TDragImageList read FDragImageList;
    procedure DragDrop(Source: TObject; X: Integer; Y: Integer); override;
    function GetButtonRect(const Index: Integer): TRect;
    function IndexOfButtonAt(const X, Y: Integer): Integer;
    { RemoveInsertionPoints: Removes the insertion points added by
      SetInsertionPoints }
    procedure RemoveInsertionPoints;
    procedure ScrollIntoView(const Index: Integer);
    { SetInsertionPoints: Draws an insert line for inserting at
      InsertionIndex. Shows/Hides  }
    procedure SetInsertionPoints(const InsertionIndex: Integer);
    { TargetIndexAt: Gives you the target insertion index given a
      coordinate. If it is above half of a current button, it inserts
      above it. If it is below the half, it inserts after it. }
    function TargetIndexAt(const X, Y: Integer): Integer;
    property Canvas;
  published
    property ButtonsSkinDataName: String read FButtonsSkinDataName write FButtonsSkinDataName;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property Align;
    property Anchors;
    property ShowBoder: Boolean read FShowBorder write SetShowBorder;
    property ShowFocus: Boolean read FShowFocus write FShowFocus;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight default 24;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 24;
    property ButtonOptions: TspGrpButtonOptions read FButtonOptions write SetGrpButtonOptions default [gboShowCaptions];
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height default 100;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TspGrpButtonItems read FButtonItems write SeTspGrpButtonItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Width default 100;
    property Visible;
//    property OnAlignInsertBefore;
//    property OnAlignPosition;
    property OnButtonClicked: TspGrpButtonEvent read FOnButtonClicked write FOnButtonClicked;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHotButton: TspGrpButtonEvent read FOnHotButton write FOnHotButton;
    property OnAfterDrawButton: TspGrpButtonDrawEvent read FOnAfterDrawButton write FOnAfterDrawButton;
    property OnBeforeDrawButton: TspGrpButtonDrawEvent read FOnBeforeDrawButton write FOnBeforeDrawButton;
    property OnDrawButton: TspGrpButtonDrawEvent read FOnDrawButton write SetOnDrawButton;
    property OnDrawIcon: TspGrpButtonDrawIconEvent read FOnDrawIcon write SetOnDrawIcon;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnReorderButton: TspGrpButtonReorderEvent read FOnReorderButton write FOnReorderButton;
//    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspGrpButtonItem = class(TspBaseButtonItem)
  private
    function GetButtonGroup: TspSkinButtonGroup;
    function GetCollection: TspGrpButtonItems;
    procedure SetCollection(const Value: TspGrpButtonItems); reintroduce;
  protected
    function GetNotifyTarget: TComponent; override;
  public
    procedure ScrollIntoView; override;
    property Collection: TspGrpButtonItems read GetCollection write SetCollection;
  published
    property ButtonGroup: TspSkinButtonGroup read GetButtonGroup;
  end;

  TspGrpButtonItems = class(TCollection)
  private
    FButtonGroup: TspSkinButtonGroup;
    FOriginalID: Integer;
    function GetItem(Index: Integer): TspGrpButtonItem;
    procedure SetItem(Index: Integer; const Value: TspGrpButtonItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(const ButtonGroup: TspSkinButtonGroup);
    function Add: TspGrpButtonItem;
    function AddItem(Item: TspGrpButtonItem; Index: Integer): TspGrpButtonItem;
    procedure BeginUpdate; override;
    function Insert(Index: Integer): TspGrpButtonItem;
    property Items[Index: Integer]: TspGrpButtonItem read GetItem write SetItem; default;
    property ButtonGroup: TspSkinButtonGroup read FButtonGroup;
  end;

implementation

{ TspSkinButtonGroup }

constructor TspSkinButtonGroup.Create(AOwner: TComponent);
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
  FButtonsSkinDataName := 'resizebutton';
  FUseSkinFont := True;
  FShowFocus := False;
  FSkinScrollBar := nil;
  FShowBorder := False;
  Width := 100;
  Height := 100;
  ControlStyle := [csDoubleClicks, csCaptureMouse, csDisplayDragImage, csAcceptsControls];
  FButtonItems := GetButtonsClass.Create(Self);
  FButtonOptions := [gboShowCaptions];
  FButtonWidth := 24;
  FButtonHeight := 24;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FDoubleBuffered := True;
  FHotIndex := -1;
  FDownIndex := -1;
  FItemIndex := -1;
  FDragIndex := -1;
  FInsertBottom := -1;
  FInsertTop := -1;
  FInsertLeft := -1;
  FInsertRight := -1;
  FDragImageList := TDragImageList.Create(nil);
  FFocusIndex := -1;
  TabStop := True;
end;

procedure TspSkinButtonGroup.OnMouseTimerEvent(Sender: TObject);
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

procedure TspSkinButtonGroup.ChangeSkinData;
begin
  FSkinDataName := '';

  inherited;

  if FSkinScrollBar <> nil
  then
    begin
      FSkinScrollBar.SkinData := Self.Skindata;
    end;

  if FShowBorder then RecreateWnd;

  Resize;
  AdjustScrollBar;
  Invalidate;
end;

procedure TspSkinButtonGroup.SetBounds;
begin
  inherited;
  if HandleAllocated then 
  if ((FButtonWidth > 0) or (spgboFullSize in FButtonOptions)) and (FButtonHeight > 0)
  then
    begin
      Resize;
      AdjustScrollBar;
    end;
end;

procedure TspSkinButtonGroup.SBChange(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPosition;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinButtonGroup.SBUpClick(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scLineDown;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinButtonGroup.SBDownClick(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scLineUp;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinButtonGroup.SBPageUp(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPageUp;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

procedure TspSkinButtonGroup.SBPageDown(Sender: TObject);
var
  ScrollCode: TScrollCode;
begin
  ScrollCode := scPageDown;
  ScrollPosChanged(TScrollCode(ScrollCode), FSkinScrollBar.Position);
end;

function TspSkinButtonGroup.GetScrollSize: Integer;
begin
  if FSkinScrollBar = nil
  then
    Result := 0
  else
    Result := FSkinScrollBar.Width;
end;

procedure TspSkinButtonGroup.AdjustScrollBar;
begin
  if FSkinScrollBar = nil then Exit;
  FSkinScrollBar.SetBounds(ClientWidth - FSkinScrollBar.Width, 0,
  FSkinScrollBar.Width, ClientHeight);
  if not FSkinScrollBar.Visible then FSkinScrollBar.Visible := True;
end;

procedure TspSkinButtonGroup.ShowSkinScrollBar(const Visible: Boolean);
begin
  if Visible
  then
    begin
     FSkinScrollBar := TspSkinScrollBar.Create(Self);
     FSkinScrollBar.Visible := False;
     FSkinScrollBar.Parent := Self;
     FSkinScrollBar.DefaultHeight := 0;
     FSkinScrollBar.DefaultWidth := 19;
     //
     FSkinScrollBar.OnChange := SBChange;
     FSkinScrollBar.OnUpButtonClick := SBUpClick;
     FSkinScrollBar.OnDownButtonClick := SBDownClick;
     FSkinScrollBar.OnPageUp := SBPageUp;
     FSkinScrollBar.OnPageDown := SBPageDown;
     //
     FSkinScrollBar.SkinDataName := 'vscrollbar';
     FSkinScrollBar.Kind := sbVertical;
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

procedure TspSkinButtonGroup.WMNCPAINT(var Message: TMessage);
begin
  if FShowBorder
  then
    PaintBorder(0, False)
  else
    inherited;
end;

procedure TspSkinButtonGroup.PaintBorder;
begin
  if (SkinData <> nil) and (not SkinData.Empty) and
     (SkinData.GetControlIndex('panel') <> -1)
  then
    PaintSkinBorder(ADC, AUseExternalDC)
  else
    PaintDefaultBorder(ADC, AUseExternalDC);  
end;

procedure TspSkinButtonGroup.PaintDefaultBorder;
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


procedure TspSkinButtonGroup.PaintSkinBorder;
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

procedure TspSkinButtonGroup.WMSIZE;
begin
  inherited;
  if FShowBorder then PaintBorder(0, False);
end;

procedure TspSkinButtonGroup.WMNCCALCSIZE;
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

procedure TspSkinButtonGroup.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    PaintWindow(Message.DC);
end;

procedure TspSkinButtonGroup.SetShowBorder;
begin
  if FShowBorder <> Value
  then
    begin
      FShowBorder := Value;
      RecreateWnd;
   end;
end;

function TspSkinButtonGroup.CreateButton: TspGrpButtonItem;
begin
  Result := GetButtonClass.Create(FButtonItems);
end;

procedure TspSkinButtonGroup.CMSENCPaint(var Message: TMessage);
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

procedure TspSkinButtonGroup.CMBENCPAINT;
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

procedure TspSkinButtonGroup.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

destructor TspSkinButtonGroup.Destroy;
begin
  if FSkinScrollBar <> nil then FSkinScrollBar.Free;
  if FIs9XOS then FMouseTimer.Free;
  FSkinScrollBar := nil;
  FDragImageList.Free;
  FButtonItems.Free;
  FImageChangeLink.Free;
  inherited;
end;

function TspSkinButtonGroup.GetButtonClass: TspGrpButtonItemClass;
begin
  Result := TspGrpButtonItem;
end;

function TspSkinButtonGroup.GetButtonRect(const Index: Integer): TRect;
var
  ButtonsPerRow: Integer;
  HiddenCount: Integer;
  Item: Integer;
  Row, Col: Integer;
begin
  ButtonsPerRow := CalcButtonsPerRow;
  HiddenCount := FHiddenItems*ButtonsPerRow;
  { Subtract out what we can't see }
  Item := Index - HiddenCount;

  Row := Item div ButtonsPerRow;
  Result.Top := Row*FButtonHeight;
  if spgboFullSize in FButtonOptions then
  begin
    Result.Left := 0;
    Result.Right := ClientWidth - GetScrollSize;
  end
  else
  begin
    Col := Item mod ButtonsPerRow;
    Result.Left := Col*FButtonWidth;
    Result.Right := Result.Left + FButtonWidth;
  end;
  Result.Bottom := Result.Top + FButtonHeight;
end;

function TspSkinButtonGroup.GetButtonsClass: TspGrpButtonItemsClass;
begin
  Result := TspGrpButtonItems;
end;

procedure TspSkinButtonGroup.ImageListChange(Sender: TObject);
begin
  UpdateAllButtons;
end;

procedure TspSkinButtonGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if AComponent = Images then
      Images := nil
    else
      if AComponent is TBasicAction then
        for I := 0 to FButtonItems.Count - 1 do
          if AComponent = FButtonItems[I].Action then
            FButtonItems[I].Action := nil;
  end;
end;

procedure TspSkinButtonGroup.Paint;
var
  PanelData: TspDataSkinPanelControl;

procedure DrawSkinBGRect(R: TRect);
var
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
  ButtonCount: Integer;
  RowsSeen, ButtonsPerRow: Integer;
  HiddenCount, VisibleCount: Integer;
  CurOffset: TPoint;
  RowPos: Integer;
  X: Integer;
  ItemRect: TRect;
  ActualWidth, ActualHeight: Integer;
  DrawState: TspButtonDrawState;
  SaveIndex: Integer;
begin
  //
  Canvas.Brush.Color := clBtnFace;
  //
  ButtonCount := FButtonItems.Count;
  if ButtonCount > 0 then
  begin
    RowsSeen := CalcRowsSeen;
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems * ButtonsPerRow;
    VisibleCount := RowsSeen*ButtonsPerRow;

    if (HiddenCount + VisibleCount) > ButtonCount then
      VisibleCount := ButtonCount - HiddenCount; { We can see more items than we have }

    CurOffset.X := 0; { Start at the very top left }
    CurOffset.Y := 0;
    RowPos := 0;
    if spgboFullSize in ButtonOptions then
      ActualWidth := ClientWidth - GetScrollSize
    else
      ActualWidth := FButtonWidth;
    ActualHeight := FButtonHeight;

    for X := HiddenCount to HiddenCount + VisibleCount - 1 do
    begin
      ItemRect := Bounds(CurOffset.X, CurOffset.Y, ActualWidth, ActualHeight);
      DrawState := [];
      if X = FHotIndex then
      begin
        Include(DrawState, spbdsHot);
        if X = FDownIndex then
          Include(DrawState, spbdsDown);
      end;
      if X = FItemIndex then
        Include(DrawState, spbdsSelected);

      if X = FInsertTop then
        Include(DrawState, spbdsInsertTop)
      else if X = FInsertBottom then
        Include(DrawState, spbdsInsertBottom)
      else if X = FInsertRight then
        Include(DrawState, spbdsInsertRight)
      else if X = FInsertLeft then
        Include(DrawState, spbdsInsertLeft);
      if (X = FFocusIndex) and Focused then
        Include(DrawState, spbdsFocused);

      DrawButton(X, Canvas, ItemRect, DrawState);
      Inc(RowPos);
      { Should we go to the next line? }
      if RowPos >= ButtonsPerRow then
      begin
        { Erase to the end }
        Inc(CurOffset.X, ActualWidth);
         if (SkinData <> nil) and (not Skindata.Empty) and
            (SkinData.GetControlIndex('panel') <> -1)
        then
          begin
            if PanelData.StretchEffect
            then
              begin
                SaveIndex := SaveDC(Canvas.Handle);
                IntersectClipRect(Canvas.Handle,
                  CurOffset.X, CurOffset.Y, ClientWidth - GetScrollSize,
                  CurOffset.Y + ActualHeight);
                DrawSkinBGRect(ClientRect);
                RestoreDC(Canvas.Handle, SaveIndex);
              end
            else
              DrawSkinBGRect(Rect(CurOffset.X, CurOffset.Y, ClientWidth - GetScrollSize,
                CurOffset.Y + ActualHeight));
          end
        else
          DoFillRect(Rect(CurOffset.X, CurOffset.Y, ClientWidth - GetScrollSize,
          CurOffset.Y + ActualHeight));
        RowPos := 0;
        CurOffset.X := 0;
        Inc(CurOffset.Y, ActualHeight);
      end
      else
        Inc(CurOffset.X, ActualWidth);
    end;
    { Erase to the end }
    if (SkinData <> nil) and (not Skindata.Empty) and
       (SkinData.GetControlIndex('panel') <> -1)
    then
      begin
        if PanelData.StretchEffect
        then
          begin
            SaveIndex := SaveDC(Canvas.Handle);
            IntersectClipRect(Canvas.Handle,
             CurOffset.X, CurOffset.Y,
             ClientWidth - GetScrollSize, CurOffset.Y + ActualHeight);
            DrawSkinBGRect(ClientRect);
            RestoreDC(Canvas.Handle, SaveIndex);
          end
        else
         DrawSkinBGRect(Rect(CurOffset.X, CurOffset.Y,
           ClientWidth - GetScrollSize, CurOffset.Y + ActualHeight));
      end
    else
      DoFillRect(Rect(CurOffset.X, CurOffset.Y,
        ClientWidth - GetScrollSize, CurOffset.Y + ActualHeight));
    { Erase to the bottom }
    if (SkinData <> nil) and (not Skindata.Empty) and
       (SkinData.GetControlIndex('panel') <> -1)
    then
      begin
        if PanelData.StretchEffect
        then
          begin
            SaveIndex := SaveDC(Canvas.Handle);
            IntersectClipRect(Canvas.Handle,
            0, CurOffset.Y + ActualHeight, ClientWidth - GetScrollSize, ClientHeight);
            DrawSkinBGRect(ClientRect);
            RestoreDC(Canvas.Handle, SaveIndex);
          end
        else
        DrawSkinBGRect(Rect(0, CurOffset.Y + ActualHeight, ClientWidth - GetScrollSize, ClientHeight));
      end
    else
      DoFillRect(Rect(0, CurOffset.Y + ActualHeight, ClientWidth - GetScrollSize, ClientHeight));
  end
  else
    begin
      if (SkinData <> nil) and (not Skindata.Empty) and
         (SkinData.GetControlIndex('panel') <> -1)
      then
        begin
          if PanelData.StretchEffect
          then
            begin
              SaveIndex := SaveDC(Canvas.Handle);
              IntersectClipRect(Canvas.Handle,
              0, 0, ClientWidth - GetScrollSize, ClientHeight);
              DrawSkinBGRect(ClientRect);
              RestoreDC(Canvas.Handle, SaveIndex);
            end
        else
          DrawSkinBGRect(Rect(0, 0, ClientWidth - GetScrollSize, ClientHeight));
        end
      else
        DoFillRect(ClientRect);
    end;  
end;


function TspSkinButtonGroup.CalcButtonsPerRow: Integer;
begin
  if spgboFullSize in ButtonOptions then
    Result := 1
  else
  begin
    Result := (ClientWidth - GetScrollSize) div FButtonWidth;
    if Result = 0 then
      Result := 1;
  end;
end;

function TspSkinButtonGroup.CalcRowsSeen: Integer;
begin
  Result := ClientHeight div FButtonHeight
end;

procedure TspSkinButtonGroup.Resize;
var
  RowsSeen: Integer;
  ButtonsPerRow: Integer;
  TotalRowsNeeded: Integer;
  ScrollInfo: TScrollInfo;
begin
  inherited;
  { Reset the original position }
  FHiddenItems := 0;

  { How many rows can we show? }
  RowsSeen := CalcRowsSeen;
  ButtonsPerRow := CalcButtonsPerRow;

  { Do we have to take the scrollbar into consideration? }
  if (ButtonsPerRow*RowsSeen < FButtonItems.Count) then
  begin
    TotalRowsNeeded := FButtonItems.Count div ButtonsPerRow;
    if FButtonItems.Count mod ButtonsPerRow <> 0 then
      Inc(TotalRowsNeeded);

    if TotalRowsNeeded > RowsSeen then
      FPageAmount := RowsSeen
    else
      FPageAmount := TotalRowsNeeded;

    { Adjust the max to NOT contain the page amount }
    FScrollBarMax := TotalRowsNeeded - FPageAmount;

    ScrollInfo.cbSize := SizeOf(TScrollInfo);
    ScrollInfo.fMask := SIF_RANGE or SIF_POS or SIF_PAGE;
    ScrollInfo.nMin := 0;
    ScrollInfo.nMax := TotalRowsNeeded - 1;
    ScrollInfo.nPos := 0;
    ScrollInfo.nPage := FPageAmount;
    if FSkinScrollBar = nil
    then
      begin
        ShowSkinScrollBar(True);
      end;
    FSkinScrollBar.SetRange(ScrollInfo.nMin, ScrollInfo.nMax,
       ScrollInfo.nPos, ScrollInfo.nPage);
  end
  else
    begin
      if FSkinScrollBar <> nil
      then
        ShowSkinScrollBar(False);
    end;
end;

procedure TspSkinButtonGroup.SetButtonHeight(const Value: Integer);
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    UpdateAllButtons;
  end;
end;

procedure TspSkinButtonGroup.SeTspGrpButtonItems(const Value: TspGrpButtonItems);
begin
  FButtonItems.Assign(Value);
end;

procedure TspSkinButtonGroup.SetGrpButtonOptions(const Value: TspGrpButtonOptions);
begin
  if FButtonOptions <> Value then
  begin
    FButtonOptions := Value;
    if not (spgboGroupStyle in FButtonOptions) then
      FItemIndex := -1;
    if HandleAllocated then
    begin
      Resize;
      UpdateAllButtons;
    end;
  end;
end;

procedure TspSkinButtonGroup.SetButtonWidth(const Value: Integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    UpdateAllButtons;
  end;
end;

procedure TspSkinButtonGroup.SetImages(const Value: TCustomImageList);
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

procedure TspSkinButtonGroup.SetItemIndex(const Value: Integer);
var
  OldIndex: Integer;
begin
  if (FItemIndex <> Value) and (spgboGroupStyle in ButtonOptions) then
  begin
    OldIndex := FItemIndex;
    { Assign the index before painting }
    FItemIndex := Value;
    FFocusIndex := Value; { Assign it to the focusl item too }
    UpdateButton(OldIndex);

    UpdateButton(FItemIndex);
  end;
end;

const
  cScrollBarKind = SB_VERT;

procedure TspSkinButtonGroup.UpdateAllButtons;
begin
  Invalidate;
end;

procedure TspSkinButtonGroup.UpdateButton(const Index: Integer);
var
  R: TRect;
begin
  { Just invalidate one button's rect }
  if Index >= 0 then
  begin
    R := GetButtonRect(Index);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TspSkinButtonGroup.ScrollPosChanged(ScrollCode: TScrollCode;
  ScrollPos: Integer);
var
  OldPos: Integer;
begin
  OldPos := FHiddenItems;
  if (ScrollCode = scLineUp) and (FHiddenItems > 0) then
    Dec(FHiddenItems)
  else if (ScrollCode = scLineDown) and (FHiddenItems < FScrollBarMax) then
    Inc(FHiddenItems)
  else if (ScrollCode = scPageUp) then
  begin
    Dec(FHiddenItems, FPageAmount);
    if FHiddenItems < 0 then
      FHiddenItems := 0;
  end
  else if ScrollCode = scPageDown then
  begin
    Inc(FHiddenItems, FPageAmount);
    if FHiddenItems > FScrollBarMax then
      FHiddenItems := FScrollBarMax;
  end
  else if ScrollCode in [scPosition, scTrack] then
    FHiddenItems := ScrollPos
  else if ScrollCode = scTop then
    FHiddenItems := 0
  else if ScrollCode = scBottom then
    FHiddenItems := FScrollBarMax;
  if OldPos <> FHiddenItems then
  begin
    if FSkinScrollBar <> nil
    then
      FSkinScrollBar.SetRange(FSkinScrollBar.Min,
        FSkinScrollBar.Max,  FHiddenItems, FSkinScrollBar.PageSize);
    Invalidate;
  end;
end;

procedure TspSkinButtonGroup.DoFillRect(const Rect: TRect);
begin
  Canvas.FillRect(Rect);
end;

procedure TspSkinButtonGroup.DrawStretchSkinButton(Index: Integer; Canvas: TCanvas;
   Rct: TRect; State: TspButtonDrawState);
var
  R, SR: TRect;
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  NewClRect: TRect;
  XO, YO: Integer;
  C: TColor;
  FSkinPicture: TBitMap;
  ButtonItem: TspGrpButtonItem;
begin

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(Rct);
  Buffer.Height := RectHeight(Rct);

  CIndex := SkinData.GetControlIndex(FButtonsSkinDataName);

  ButtonData := SkinData.CtrlList[CIndex];

  with ButtonData do
  begin
    if spbdsDown in State then
    begin
      SR := DownSkinRect;
      C := DownFontColor;
    end
    else
    if spbdsSelected in State
    then
      begin
        SR := ActiveSkinRect;
        C := ActiveFontColor;
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
    //

    //
    if (spbdsFocused in State) and FShowFocus
    then
      begin
        R := NewClRect;
        InflateRect(R, 1, 1);
        Buffer.Canvas.DrawFocusRect(R);
      end;
    // draw glpyh and text
    if FUseSkinFont
    then
      begin
        Buffer.Canvas.Font.Name := FontName;
        Buffer.Canvas.Font.Style := FontStyle;
        Buffer.Canvas.Font.Height := FontHeight;
      end
    else
      Buffer.Canvas.Font.Assign(Self.Font);
    Buffer.Canvas.Font.Color := C;
    if SkinData.ResourceStrData <>  nil
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.CharSet;
    //
    ButtonItem := FButtonItems[Index];

    if gboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Buffer.Canvas, NewClRect, 5, 2, blGlyphLeft,
         ButtonItem.Caption, ButtonItem.ImageIndex, FImages, False, True,
         False, 0)
    else
      DrawImageAndText(Buffer.Canvas, NewClRect, -1, 0, blGlyphLeft,
         '', ButtonItem.ImageIndex, FImages, False, True, False, 0);
  end;
  Canvas.Draw(Rct.Left, Rct.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinButtonGroup.DrawSkinButton(Index: Integer; Canvas: TCanvas;
      Rct: TRect; State: TspButtonDrawState); 
var
  R, SR: TRect;
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewClRect: TRect;
  XO, YO: Integer;
  C: TColor;
  FSkinPicture: TBitMap;
  ButtonItem: TspGrpButtonItem;
begin

  if (FButtonsSkinDataName <> 'resizebutton') and
     (SkinData.GetControlIndex(FButtonsSkinDataName) <> -1)
  then
    begin
      DrawStretchSkinButton(Index, Canvas, Rct, State);
      Exit;
    end;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(Rct);
  Buffer.Height := RectHeight(Rct);

  CIndex := SkinData.GetControlIndex('resizebutton');
  ButtonData := SkinData.CtrlList[CIndex];
  with ButtonData do
  begin
    if spbdsDown in State then
    begin
      SR := DownSkinRect;
      C := DownFontColor;
    end
    else
    if spbdsSelected in State
    then
      begin
        SR := ActiveSkinRect;
        C := ActiveFontColor;
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

    //
    if (spbdsFocused in State) and FShowFocus
    then
      begin
        R := NewClRect;
        InflateRect(R, 1, 1);
        Buffer.Canvas.DrawFocusRect(R);
      end;
    // draw glpyh and text
    if FUseSkinFont
    then
      begin
        Buffer.Canvas.Font.Name := FontName;
        Buffer.Canvas.Font.Style := FontStyle;
        Buffer.Canvas.Font.Height := FontHeight;
      end
    else
      Buffer.Canvas.Font.Assign(Self.Font);
    Buffer.Canvas.Font.Color := C;
    if SkinData.ResourceStrData <>  nil
    then
      Buffer.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Buffer.Canvas.Font.Charset := Font.CharSet;
    //
    ButtonItem := FButtonItems[Index];

    if gboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Buffer.Canvas, NewClRect, 5, 2, blGlyphLeft,
         ButtonItem.Caption, ButtonItem.ImageIndex, FImages, False, True, False, 0)
    else
      DrawImageAndText(Buffer.Canvas, NewClRect, -1, 0, blGlyphLeft,
         '', ButtonItem.ImageIndex, FImages, False, True, False, 0);
  end;
  Canvas.Draw(Rct.Left, Rct.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinButtonGroup.DrawButton(Index: Integer; Canvas: TCanvas;
  Rect: TRect; State: TspButtonDrawState);
var
  ButtonItem: TspGrpButtonItem;
  FillColor: TColor;
  EdgeColor: TColor;
  TextRect: TRect;
  R, OrgRect: TRect;
  CIndex: Integer;
begin
  if Assigned(FOnDrawButton) and (not (csDesigning in ComponentState)) then
    FOnDrawButton(Self, Index, Canvas, Rect, State)
  else
  begin
    if (SkinData <> nil) and not (SkinData.Empty)
    then
      begin
        CIndex := SkinData.GetControlIndex('resizebutton');
        if CIndex <> -1
        then
          begin
            DrawSkinButton(Index, Canvas, Rect, State);
            Exit;
          end;
      end;

    OrgRect := Rect;
    Canvas.Font := Font;

    if spbdsDown in State then
    begin
      EdgeColor := SP_XP_BTNFRAMECOLOR;
      Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
      Canvas.Font.Color := clBtnText;
    end
    else
    if spbdsHot in State then
    begin
       EdgeColor := SP_XP_BTNFRAMECOLOR;
      Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
      Canvas.Font.Color := clBtnText;
    end
    else
    if spbdsSelected in State then
    begin
      EdgeColor := SP_XP_BTNFRAMECOLOR;
      Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
      Canvas.Font.Color := clBtnText;
    end

    else
    begin
      EdgeColor := clBtnShadow;
      Canvas.Brush.Color := clBtnFace;
      Canvas.Font.Color := clBtnText;
    end;

    if Assigned(FOnBeforeDrawButton) then
      FOnBeforeDrawButton(Self, Index, Canvas, Rect, State);

    FillColor := Canvas.Brush.Color;
    Canvas.FillRect(Rect);

    InflateRect(Rect, -2, -1);

    { Draw the edge outline }
    Canvas.Brush.Color := EdgeColor;
    Canvas.FrameRect(Rect);
    Canvas.Brush.Color := FillColor;

    TextRect := Rect;
    InflateRect(TextRect, -4, -4);

    if (spbdsFocused in State) and FShowFocus
    then
      begin
        R := Rect;
        InflateRect(R, -2, -2);
        Canvas.DrawFocusRect(R);
      end;

    ButtonItem := FButtonItems[Index];

    if gboShowCaptions in FButtonOptions
    then
      DrawImageAndText(Canvas, TextRect, 5, 2, blGlyphLeft,
         ButtonItem.Caption, ButtonItem.ImageIndex, FImages, False, True, False, 0)
    else
      DrawImageAndText(Canvas, TextRect, -1, 0, blGlyphLeft,
         '', ButtonItem.ImageIndex, FImages, False, True, False, 0);


    if Assigned(FOnAfterDrawButton) then
      FOnAfterDrawButton(Self, Index, Canvas, OrgRect, State);
  end;
  Canvas.Brush.Color := Color; { Restore the original color }
end;

procedure TspSkinButtonGroup.SetOnDrawButton(const Value: TspGrpButtonDrawEvent);
begin
  FOnDrawButton := Value;
  Invalidate;
end;

procedure TspSkinButtonGroup.SetOnDrawIcon(const Value: TspGrpButtonDrawIconEvent);
begin
  FOnDrawIcon := Value;
  Invalidate;
end;

procedure TspSkinButtonGroup.CreateHandle;
begin
  inherited CreateHandle;
  { Make sure that we are showing the scroll bars, if needed }
  Resize;
end;

procedure TspSkinButtonGroup.WMMouseLeave(var Message: TMessage);
begin
  FMouseInControl := False;
  if FHotIndex <> -1 then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
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

procedure TspSkinButtonGroup.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    { Focus ourselves, when clicked, like a button would }
    if not Focused then
      Windows.SetFocus(Handle);

    FDragStarted := False;
    FDownIndex := IndexOfButtonAt(X, Y);
    if FDownIndex <> -1 then
    begin
      if spgboAllowReorder in ButtonOptions then
        FDragIndex := FDownIndex;
      FDragStartPos := Point(X, Y);
      { If it is the same as the selected, don't do anything }
      if FDownIndex <> FItemIndex then
        UpdateButton(FDownIndex)
      else
        FDownIndex := -1;
    end;
  end;
end;

procedure TspSkinButtonGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewHotIndex, OldHotIndex: Integer;
  EventTrack: TTrackMouseEvent;
  DragThreshold: Integer;
begin
  inherited;
  { Was the drag threshold met? }
  if (spgboAllowReorder in ButtonOptions) and (FDragIndex <> -1) then
  begin
    DragThreshold := Mouse.DragThreshold;
    if (Abs(FDragStartPos.X - X) >= DragThreshold) or
        (Abs(FDragStartPos.Y - Y) >= DragThreshold) then
    begin
      FDragStartPos.X := X; { Used in the start of the drag }
      FDragStartPos.Y := Y;
      FDownIndex := -1; { Stops repaints and clicks }
      if FHotIndex <> -1 then
      begin
        OldHotIndex := FHotIndex;
        FHotIndex := -1;
        UpdateButton(OldHotIndex);
        { We must have the window process the paint message before
          the drag operation starts }
        UpdateWindow(Handle);
        DoHotButton;
      end;
      FDragStarted := True;
      BeginDrag(True, -1);
      Exit;
    end;
  end;

  NewHotIndex := IndexOfButtonAt(X, Y);
  if NewHotIndex <> FHotIndex then
  begin
    OldHotIndex := FHotIndex;
    FHotIndex := NewHotIndex;
    UpdateButton(OldHotIndex);
    if FHotIndex <> -1 then
      UpdateButton(FHotIndex);
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

procedure TspSkinButtonGroup.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LastDown: Integer;
begin
  inherited;
  if (Button = mbLeft) and (not FDragStarted) then
  begin
    LastDown := FDownIndex;
    FDownIndex := -1;
    FDragIndex := -1;
    if (LastDown <> -1) and (IndexOfButtonAt(X, Y) = LastDown)
      and (FDragIndex = -1) then
    begin
      UpdateButton(LastDown);
      DoItemClicked(LastDown);
      if spgboGroupStyle in ButtonOptions then
        ItemIndex := LastDown;
    end
    else if LastDown <> -1 then
      UpdateButton(LastDown);
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
  FDragStarted := False;
end;

function TspSkinButtonGroup.IndexOfButtonAt(const X, Y: Integer): Integer;
var
  ButtonsPerRow: Integer;
  HiddenCount: Integer;
  Row, Col: Integer;
begin
  Result := -1;
  { Is it within our X and Y bounds first? }
  if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y < Height) then
  begin
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems*ButtonsPerRow;
    Row := Y div FButtonHeight;
    if spgboFullSize in FButtonOptions then
      Col := 0
    else
      Col := X div FButtonWidth;

    Result := HiddenCount + Row*ButtonsPerRow + Col;

    if Result >= FButtonItems.Count then
      Result := -1
    else if (Row+1)*FButtonHeight > Height then
      Result := -1 { Item is clipped }
    else if not (spgboFullSize in FButtonOptions)
    then
      begin
        if (Col + 1) * FButtonWidth > ClientWidth - GetScrollSize
        then
          Result := -1;
      end;
  end;
end;

procedure TspSkinButtonGroup.DoItemClicked(const Index: Integer);
begin
  if Assigned(FButtonItems[Index].OnClick) then
    FButtonItems[Index].OnClick(Self)
  else if Assigned(FOnButtonClicked) then
    FOnButtonClicked(Self, Index);
end;

procedure TspSkinButtonGroup.DragDrop(Source: TObject; X, Y: Integer);
var
  TargetIndex: Integer;
begin
  if (Source = Self) and (spgboAllowReorder in ButtonOptions) then
  begin
    RemoveInsertionPoints;
    TargetIndex := TargetIndexAt(X, Y);
    if TargetIndex > FDragIndex then
      Dec(TargetIndex); { Account for moving ourselves }
    if TargetIndex <> -1 then
      DoReorderButton(FDragIndex, TargetIndex);
    FDragIndex := -1;
  end
  else
    inherited;
end;

const
  cScrollBuffer = 6;

procedure TspSkinButtonGroup.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  OverIndex: Integer;
begin
  if (Source = Self) and (spgboAllowReorder in ButtonOptions) then
  begin
    { If the mouse is within the bottom cScrollBuffer pixels,
      then "auto-scroll" }
    if (FHiddenItems < FScrollBarMax) and (Y <= Height) and
         (Y >= Height - cScrollBuffer) and (X >= 0) and (X <= Width) then
      AutoScroll(scLineDown)
    else if (FHiddenItems > 0) and (Y >= 0) and
         (Y <= cScrollBuffer) and (X >= 0) and (X <= Width) then
      AutoScroll(scLineUp);

    OverIndex := TargetIndexAt(X, Y);
    { Don't accept when it is the same as the start or right after us }
    Accept := (OverIndex <> -1) and (OverIndex <> FDragIndex) and
      (OverIndex <> FDragIndex + 1) and (Items.Count > 1);
    FDragImageList.HideDragImage;
    if Accept and (State <> dsDragLeave) then
      SetInsertionPoints(OverIndex)
    else
      RemoveInsertionPoints;
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end
  else
    inherited DragOver(Source, X, Y, State, Accept);
end;

procedure TspSkinButtonGroup.DoHotButton;
begin
  if Assigned(FOnHotButton) then
    FOnHotButton(Self, FHotIndex);
end;

procedure TspSkinButtonGroup.DoStartDrag(var DragObject: TDragObject);
var
  ButtonRect: TRect;
  State: TspButtonDrawState;
  DragImage: TBitmap;
begin
  inherited DoStartDrag(DragObject);
  if FDragIndex <> -1 then
  begin
    DragImage := TBitmap.Create;
    try
      ButtonRect := GetButtonRect(FDragIndex);
      DragImage.Width := ButtonRect.Right - ButtonRect.Left;
      DragImage.Height := ButtonRect.Bottom - ButtonRect.Top;
      State := [spbdsDragged];
      if FItemIndex = FDragIndex then
        State := State + [spbdsSelected];
      DrawButton(FDragIndex, DragImage.Canvas,
        Rect(0, 0, DragImage.Width, DragImage.Height), State);
      FDragImageList.Clear;
      FDragImageList.Width := DragImage.Width;
      FDragImageList.Height := DragImage.Height;
      FDragImageList.Add(DragImage, nil);
{      with FDragImageList.DragHotspot do
      begin
        X := FDragStartPos.X - ButtonRect.Left - Mouse.DragThreshold;
        Y := FDragStartPos.Y - ButtonRect.Top - Mouse.DragThreshold;
      end;}
    finally
      DragImage.Free;
    end;
  end
  else
    FDragImageList.Clear; { No drag image } 
end;

function TspSkinButtonGroup.GetDragImages: TDragImageList;
begin
  Result := FDragImageList;
end;

procedure TspSkinButtonGroup.RemoveInsertionPoints;
  procedure ClearSelection(var Index: Integer);
  var
    OldIndex: Integer;
  begin
    if Index <> -1 then
    begin
      OldIndex := Index;
      Index := -1;
      UpdateButton(OldIndex);
    end;
  end;

begin
  ClearSelection(FInsertTop);
  ClearSelection(FInsertLeft);
  ClearSelection(FInsertRight);
  ClearSelection(FInsertBottom);
end;

procedure TspSkinButtonGroup.DoReorderButton(const OldIndex, NewIndex: Integer);
var
  OldIndexID: Integer;
begin
  FIgnoreUpdate := True;
  try
    if FItemIndex <> -1 then
      OldIndexID := Items[FItemIndex].ID
    else
      OldIndexID := -1;
    FButtonItems.Items[OldIndex].Index := NewIndex;
    if OldIndexID <> -1 then
      FItemIndex := Items.FindItemID(OldIndexID).Index;
  finally
    FIgnoreUpdate := False;
  end;
  Invalidate;
  if Assigned(FOnReorderButton) then
    FOnReorderButton(Self, OldIndex, NewIndex);
end;

procedure TspSkinButtonGroup.AutoScroll(ScrollCode: TScrollCode);

  function ShouldContinue(out Delay: Integer): Boolean;
  const
    cMaxDelay = 500;
  var  
    P: TPoint;
  begin
    { Are we autoscrolling up or down? }
    if ScrollCode = scLineDown then
    begin
      Result := FHiddenItems < FScrollBarMax;
      if Result then
      begin
        { Is the mouse still in position? }
        P := ScreenToClient(Mouse.CursorPos);
        with P do
        begin
          if (X < 0) or (X > Width) or
             (Y > Height) or (Y < Height - cScrollBuffer) then
            Result := False
          else if Y < (Height - cScrollBuffer div 2) then
            Delay := cMaxDelay
          else
            Delay := cMaxDelay div 2; { A little faster }
        end
      end;
    end
    else
    begin
      Result := FHiddenItems > 0;
      if Result then
      begin
        P := ScreenToClient(Mouse.CursorPos);
        with P do
          if (X < 0) or (X > Width) or
             (Y < 0) or (Y > cScrollBuffer) then
            Result := False
        else if Y > (cScrollBuffer div 2) then
          Delay := cMaxDelay
        else
          Delay := cMaxDelay div 2;
      end;
    end;
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

function TspSkinButtonGroup.TargetIndexAt(const X, Y: Integer): Integer;
var
  ButtonRect: TRect;
  LastRect: TRect;
begin
  Result := IndexOfButtonAt(X, Y);
  if Result = -1 then
  begin
    LastRect := GetButtonRect(Items.Count);
    if (Y >= LastRect.Bottom) then
      Result := Items.Count
    else if (Y >= LastRect.Top) then
      if (spgboFullSize in FButtonOptions) or (X >= LastRect.Left) then
        Result := Items.Count; { After the last item }
  end;
  if (Result > -1) and (Result < Items.Count) then
  begin
    { Before the index, or after it? }
    ButtonRect := GetButtonRect(Result);
    if CalcButtonsPerRow = 1 then
    begin
      if Y > (ButtonRect.Top + (ButtonRect.Bottom - ButtonRect.Top) div 2) then
        Inc(Result); { Insert above the item below it (after the index) }
    end
    else
      if X > (ButtonRect.Left + (ButtonRect.Right - ButtonRect.Left) div 2) then
        Inc(Result)
  end;
end;

procedure TspSkinButtonGroup.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TspSkinButtonGroup.CNKeydown(var Message: TWMKeyDown);
var
  IncAmount: Integer;

  procedure FixIncAmount(const StartValue: Integer);
  begin
    { Keep it within the bounds }
    if StartValue + IncAmount >= FButtonItems.Count then
      IncAmount := FButtonItems.Count - StartValue - 1
    else if StartValue + IncAmount < 0 then
      IncAmount := 0 - StartValue; 
  end;

var
  NewIndex: Integer;

begin
  IncAmount := 0;
  if Message.CharCode = VK_DOWN then
    IncAmount := CalcButtonsPerRow
  else if Message.CharCode = VK_UP then
    IncAmount := -1*CalcButtonsPerRow
  else if Message.CharCode = VK_LEFT then
    IncAmount := -1
  else if Message.CharCode = VK_RIGHT then
    IncAmount := 1
  else if Message.CharCode = VK_NEXT then
    IncAmount := CalcRowsSeen
  else if Message.CharCode = VK_PRIOR then
    IncAmount := -1*CalcRowsSeen
  else if Message.CharCode = VK_HOME then
  begin
    if spgboGroupStyle in ButtonOptions then
      IncAmount := -1*FItemIndex
    else
      IncAmount := -1*FFocusIndex;
  end
  else if Message.CharCode = VK_END then
  begin
    if spgboGroupStyle in ButtonOptions then
      IncAmount := FButtonItems.Count - FItemIndex
    else
      IncAmount := FButtonItems.Count - FFocusIndex;
  end
  else if (Message.CharCode = VK_RETURN) or (Message.CharCode = VK_SPACE) then
  begin
    if (spgboGroupStyle in ButtonOptions) and (FItemIndex <> -1) then
      DoItemClicked(FItemIndex) { Click the current item index }
    else if (spgboGroupStyle in ButtonOptions) and
        (FFocusIndex >= 0) and (FFocusIndex < FButtonItems.Count) then
      DoItemClicked(FFocusIndex) { Click the focused index }
    else
      inherited;
  end
  else
    inherited;

  if IncAmount <> 0 then
  begin
    if spgboGroupStyle in ButtonOptions then
      FixIncAmount(FItemIndex)
    else
      FixIncAmount(FFocusIndex);
    if IncAmount <> 0 then
    begin
      { Do the actual scrolling work }
      if spgboGroupStyle in ButtonOptions then
      begin
        NewIndex := ItemIndex + IncAmount;
        ScrollIntoView(NewIndex);
        ItemIndex := NewIndex;
      end
      else
      begin
        NewIndex := FFocusIndex+ IncAmount;
        ScrollIntoView(NewIndex);
        UpdateButton(FFocusIndex);
        FFocusIndex := NewIndex;
        UpdateButton(FFocusIndex);
      end;
    end;
  end;
end;

procedure TspSkinButtonGroup.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  UpdateButton(FFocusIndex)
end;

procedure TspSkinButtonGroup.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if (FFocusIndex = -1) and (FButtonItems.Count > 0)  then
    FFocusIndex := 0; { Focus the first item }
  UpdateButton(FFocusIndex)
end;

procedure TspSkinButtonGroup.ScrollIntoView(const Index: Integer);
var
  RowsSeen, ButtonsPerRow, HiddenCount, VisibleCount: Integer;
begin
  if (Index >= 0) and (Index < FButtonItems.Count) then
  begin
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems*ButtonsPerRow;
    if Index < HiddenCount then
    begin
      { We have to scroll above to get the item insight }
      while (Index <= HiddenCount) and (FHiddenItems > 0) do
      begin
        ScrollPosChanged(scLineUp, 0);
        HiddenCount := FHiddenItems*ButtonsPerRow;
      end;
    end
    else
    begin
      RowsSeen := CalcRowsSeen;
      VisibleCount := RowsSeen*ButtonsPerRow;
      { Do we have to scroll down to see the item? }
      while Index >= (HiddenCount + VisibleCount) do
      begin
        ScrollPosChanged(scLineDown, 0);
        HiddenCount := FHiddenItems*ButtonsPerRow;
      end;
    end;
  end;
end;

procedure TspSkinButtonGroup.CMHintShow(var Message: TCMHintShow);
var
  ItemIndex: Integer;
begin
  Message.Result := 1; { Don't show the hint }
  if Message.HintInfo.HintControl = Self then
  begin
    ItemIndex := IndexOfButtonAt(Message.HintInfo.CursorPos.X, Message.HintInfo.CursorPos.Y);
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    begin
      { Only show the hint if the item's text is truncated }
      if Items[ItemIndex].Hint <> '' then
        Message.HintInfo.HintStr := Items[ItemIndex].Hint
      else
      begin
        // corbin - finish..
      //  Canvas.TextRect(TextRect, Items[ItemIndex].Caption, [tfEndEllipsis]);
        Message.HintInfo.HintStr := Items[ItemIndex].Caption;
      end;
      if (Items[ItemIndex].ActionLink <> nil) then
        Items[ItemIndex].ActionLink.DoShowHint(Message.HintInfo.HintStr);
      Message.HintInfo.CursorRect := GetButtonRect(ItemIndex);
      Message.Result := 0; { Show the hint }
    end;
  end;
end;

procedure TspSkinButtonGroup.Assign(Source: TPersistent);
begin
  if Source is TspSkinButtonGroup then
  begin
    Items := TspSkinButtonGroup(Source).Items;
    ButtonHeight := TspSkinButtonGroup(Source).ButtonHeight;
    ButtonWidth := TspSkinButtonGroup(Source).ButtonWidth;
    ButtonOptions := TspSkinButtonGroup(Source).ButtonOptions;
  end
  else
    inherited;
end;

procedure TspSkinButtonGroup.SetInsertionPoints(const InsertionIndex: Integer);
begin
  if FInsertTop <> InsertionIndex then 
  begin
    RemoveInsertionPoints;

    if CalcButtonsPerRow = 1 then
    begin
      FInsertTop := InsertionIndex;
      FInsertBottom := InsertionIndex - 1;
    end
    else
    begin
      { More than one button per row, so use Left/Right separators }
      FInsertLeft := InsertionIndex;
      FInsertRight := InsertionIndex - 1;
    end;

    UpdateButton(FInsertTop);
    UpdateButton(FInsertLeft);
    UpdateButton(FInsertBottom);
    UpdateButton(FInsertRight);

    UpdateWindow(Handle);
  end;
end;

procedure TspSkinButtonGroup.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
  FDragIndex := -1;
  RemoveInsertionPoints;
end;

procedure TspSkinButtonGroup.SetDragIndex(const Value: Integer);
begin
  FDragIndex := Value;
  FDragStarted := True;
end;

function TspSkinButtonGroup.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineDown, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageDown, 0)
{    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, True);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
    }
  end;
end;

function TspSkinButtonGroup.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineUp, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageUp, 0)
{    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, False);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
    }
  end;
end;

{ TspGrpButtonItem }

function TspGrpButtonItem.GetButtonGroup: TspSkinButtonGroup;
begin
  Result := Collection.ButtonGroup;
end;

function TspGrpButtonItem.GetCollection: TspGrpButtonItems;
begin
  Result := TspGrpButtonItems(inherited Collection);
end;

function TspGrpButtonItem.GetNotifyTarget: TComponent;
begin
  Result := TComponent(ButtonGroup);
end;

procedure TspGrpButtonItem.ScrollIntoView;
begin
  TspGrpButtonItems(Collection).FButtonGroup.ScrollIntoView(Index);
end;

procedure TspGrpButtonItem.SetCollection(const Value: TspGrpButtonItems);
begin
  inherited Collection := Value;
end;

{ TspGrpButtonItems }

function TspGrpButtonItems.Add: TspGrpButtonItem;
begin
  Result := TspGrpButtonItem(inherited Add);
end;

function TspGrpButtonItems.AddItem(Item: TspGrpButtonItem;
  Index: Integer): TspGrpButtonItem;
begin
  if (Item = nil) and (FButtonGroup <> nil) then
    Result := FButtonGroup.CreateButton
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

procedure TspGrpButtonItems.BeginUpdate;
begin
  if UpdateCount = 0 then
    if FButtonGroup.ItemIndex <> -1 then
      FOriginalID := Items[FButtonGroup.ItemIndex].ID
    else
      FOriginalID := -1;
  inherited;
end;

constructor TspGrpButtonItems.Create(const ButtonGroup: TspSkinButtonGroup);
begin
  if ButtonGroup <> nil then
    inherited Create(ButtonGroup.GetButtonClass)
  else
    inherited Create(TspGrpButtonItem);
  FButtonGroup := ButtonGroup;
  FOriginalID := -1;
end;

function TspGrpButtonItems.GetItem(Index: Integer): TspGrpButtonItem;
begin
  Result := TspGrpButtonItem(inherited GetItem(Index));
end;

function TspGrpButtonItems.GetOwner: TPersistent;
begin
  Result := FButtonGroup;
end;

function TspGrpButtonItems.Insert(Index: Integer): TspGrpButtonItem;
begin
  Result := AddItem(nil, Index);
end;

procedure TspGrpButtonItems.SetItem(Index: Integer; const Value: TspGrpButtonItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TspGrpButtonItems.Update(Item: TCollectionItem);
var
  AItem: TCollectionItem;
begin
  if (UpdateCount = 0) and (not FButtonGroup.FIgnoreUpdate) then
  begin
    if Item <> nil then
      FButtonGroup.UpdateButton(Item.Index)
    else
    begin
      if (FOriginalID <> -1) then
        AItem := FindItemID(FOriginalID)
      else
        AItem := nil;
      if AItem = nil then
      begin
        FButtonGroup.FItemIndex := -1;
        FButtonGroup.FFocusIndex := -1;
      end
      else if spgboGroupStyle in FButtonGroup.ButtonOptions then
        FButtonGroup.FItemIndex := AItem.Index;
      FButtonGroup.Resize;
      FButtonGroup.UpdateAllButtons;
    end;
  end;
end;

end.

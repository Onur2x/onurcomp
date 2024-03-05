{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 5.86                                                }
{                                                                   }
{       Copyright (c) 2000-2004 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit SkinTabs;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls,
     CommCtrl, ComCtrls, ExtCtrls, SkinData, SkinCtrlss, SkinBoxCtrls;
type

  TspSkinCustomTabSheet = class(TTabSheet)
  protected
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    procedure PaintBG(DC: HDC);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TspSkinTabSheet = class(TspSkinCustomTabSheet)
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  end;

  TspSkinPageControl = class(TPageControl)
  private
    FActiveTab, FOldActiveTab: Integer;
    FActiveTabIndex, FOldActiveTabIndex: Integer;
    FUseSkinFont: Boolean;
    function GetPosition: Integer;
    function  GetInVisibleItemCount: Integer;
    procedure OnUpDownChange(Sender: TObject);
    procedure DrawTabs(Cnvs: TCanvas);
    procedure DrawTab(TI: Integer; const Rct: TRect; Active, MouseIn: Boolean; Cnvs: TCanvas);
    function GetItemRect(index: integer): TRect;
    procedure SetItemSize(AWidth, AHeight: integer);
    procedure CheckScroll;
    procedure ShowSkinUpDown;
    procedure HideSkinUpDown;
    procedure TestActive(X, Y: Integer);
  protected
    //
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FSkinUpDown: TspSkinUpDown;
    FDefaultFont: TFont;
    FDefaultItemHeight: Integer;
    procedure SetDefaultItemHeight(Value: Integer);
    procedure SetDefaultFont(Value: TFont);
    procedure Change; override;
    procedure GetSkinData;
    //
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMHSCROLL(var Msg: TWMEraseBkGnd); message WM_HSCROLL;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure PaintDefaultWindow(Cnvs: TCanvas);
    procedure PaintSkinWindow(Cnvs: TCanvas);
    procedure PaintWindow(DC: HDC); override;
    procedure WndProc(var Message:TMessage); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    //
    Picture: TBitMap;
    SkinRect, ClRect, TabRect,
    ActiveTabRect, FocusTabRect, MouseInTabRect: TRect;
    TabsBGRect: TRect;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    TabLeftOffset, TabRightOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FocusFontColor, MouseInFontColor: TColor;
    UpDown: String;
    BGPictureIndex: Integer;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure Loaded; override;
    procedure UpDateTabs;
  published
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property DefaultItemHeight: Integer read FDefaultItemHeight write SetDefaultItemHeight;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Color;
    property ActivePage;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotTrack;
    property Images;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RaggedRight;
    property ScrollOpposite;
    property ShowHint;
    property TabHeight;
    property TabOrder;
    property TabPosition;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TspSkinTabControl = class(TTabControl)
  private
    FOldTop, FOldBottom: Integer;
    FActiveTab, FOldActiveTab: Integer;
    FUseSkinFont: Boolean;
    function GetPosition: Integer;
    function  GetInVisibleItemCount: Integer;
    procedure OnUpDownChange(Sender: TObject);
    procedure DrawTabs(Cnvs: TCanvas);
    procedure DrawTab(TI: Integer; const Rct: TRect; Active, MouseIn: Boolean; Cnvs: TCanvas);
    function GetItemRect(index: integer): TRect;
    procedure SetItemSize(AWidth, AHeight: integer);
    procedure CheckScroll;
    procedure ShowSkinUpDown;
    procedure HideSkinUpDown;
    procedure TestActive(X, Y: Integer);
  protected
    //
    FSD: TspSkinData;
    FSkinDataName: String;
    FIndex: Integer;
    FSkinUpDown: TspSkinUpDown;
    FDefaultFont: TFont;
    FDefaultItemHeight: Integer;
    procedure SetDefaultItemHeight(Value: Integer);
    procedure SetDefaultFont(Value: TFont);
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure GetSkinData;
    //
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMHSCROLL(var Msg: TWMEraseBkGnd); message WM_HSCROLL;
    procedure PaintDefaultWindow(Cnvs: TCanvas);
    procedure PaintSkinWindow(Cnvs: TCanvas);
    procedure PaintWindow(DC: HDC); override;
    procedure WndProc(var Message:TMessage); override;
    procedure Change; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    //
    Picture: TBitMap;
    SkinRect, ClRect, TabRect,
    ActiveTabRect, FocusTabRect, MouseInTabRect: TRect;
    TabsBGRect: TRect;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    TabLeftOffset, TabRightOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FocusFontColor, MouseInFontColor: TColor;
    UpDown: String;
    BGPictureIndex: Integer;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure Loaded; override;
    procedure UpDateTabs;
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultItemHeight: Integer read FDefaultItemHeight write SetDefaultItemHeight;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Color;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotTrack;
    property Images;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RaggedRight;
    property ScrollOpposite;
    property ShowHint;
    property TabHeight;
    property TabOrder;
    property TabPosition;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

uses Consts, ComStrs, spUtils, ImgList, DynamicSkinForm, spEffBmp;

procedure DrawFlipVert(B: TBitMap);
var
  B1, B2: TspEffectBmp;
begin
  B1 := TspEffectBmp.CreateFromhWnd(B.Handle);
  B2 := TspEffectBmp.Create(B1.Width, B1.Height);
  B1.FlipVert(B2);
  B2.Draw(B.Canvas.Handle, 0, 0);
  B1.Free;
  B2.Free;
end;

procedure DrawRotate90_1(Cnvs: TCanvas; B: TBitMap; X, Y: Integer);
var
  B1, B2: TspEffectBmp;
begin
  B1 := TspEffectBmp.CreateFromhWnd(B.Handle);
  B2 := TspEffectBmp.Create(B1.Height, B1.Width);
  B1.Rotate90_1(B2);
  B2.Draw(Cnvs.Handle, X, Y);
  B1.Free;
  B2.Free;
end;

procedure DrawRotate90_2(Cnvs: TCanvas; B: TBitMap; X, Y: Integer);
var
  B1, B2: TspEffectBmp;
begin
  B1 := TspEffectBmp.CreateFromhWnd(B.Handle);
  B2 := TspEffectBmp.Create(B1.Height, B1.Width);
  B1.Rotate90_2(B2);
  B2.Draw(Cnvs.Handle, X, Y);
  B1.Free;
  B2.Free;
end;

procedure DrawTabGlyphAndText(Cnvs: TCanvas; W, H: Integer; S: String;
                              IM: TCustomImageList; IMIndex: Integer;
                              AEnabled: Boolean);

var
  R, TR: TRect;
  GX, GY, GW, GH, TW, TH: Integer;
begin
  R := Rect(0, 0, 0, 0);
  DrawText(Cnvs.Handle, PChar(S), Length(S), R, DT_CALCRECT);
  TW := RectWidth(R) + 2;
  TH := RectHeight(R);
  GW := IM.Width;
  GH := IM.Height;
  GX := W div 2 - (GW + TW + 2) div 2;
  GY := H div 2 - GH div 2;
  TR.Left := GX + GW + 2;
  TR.Top := H div 2 - TH div 2;
  TR.Right := TR.Left + TW;
  TR.Bottom := TR.Top + TH;
  DrawText(Cnvs.Handle, PChar(S), Length(S), TR, DT_CENTER);
  IM.Draw(Cnvs, GX, GY, IMIndex, AEnabled);
end;

constructor TspSkinCustomTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
  ControlStyle := ControlStyle + [csAcceptsControls, csNoDesignVisible];
  Visible := False;
end;

destructor TspSkinCustomTabSheet.Destroy;
begin
  inherited Destroy;
end;

procedure TspSkinCustomTabSheet.WMEraseBkGnd;
begin
  PaintBG(Msg.DC);
end;

procedure TspSkinCustomTabSheet.WMSize;
begin
  inherited;
  RePaint;
end;

procedure TspSkinCustomTabSheet.PaintBG;
var
  C: TCanvas;
  TabSheetBG: TBitMap;
  PC: TspSkinPageControl;
  X, Y, XCnt, YCnt, w, h, w1, h1: Integer;
begin
  if (Width <= 0) or (Height <=0) then Exit;
  PC := TspSkinPageControl(Parent);
  if PC = nil then Exit;
  PC.GetSkinData;
  C := TCanvas.Create;
  C.Handle := DC;

  if (PC.FSD <> nil) and (not PC.FSD.Empty) and
     (PC.FIndex <> -1) and (PC.BGPictureIndex <> -1)
  then
    begin
      TabSheetBG := TBitMap(PC.FSD.FActivePictures.Items[PC.BGPictureIndex]);
      if (Width > 0) and (Height > 0)
      then
        begin
          XCnt := Width div TabSheetBG.Width;
          YCnt := Height div TabSheetBG.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
          C.Draw(X * TabSheetBG.Width, Y * TabSheetBG.Height, TabSheetBG);
        end;
      C.Free;
      Exit;
    end;


  w1 := Width;
  h1 := Height;

  if PC.FIndex <> -1
  then
    with PC do
    begin
      TabSheetBG := TBitMap.Create;
      TabSheetBG.Width := RectWidth(ClRect);
      TabSheetBG.Height := RectHeight(ClRect);
      TabSheetBG.Canvas.CopyRect(Rect(0, 0, TabSheetBG.Width, TabSheetBG.Height),
        PC.Picture.Canvas,
          Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
               SkinRect.Left + ClRect.Right,
               SkinRect.Top + ClRect.Bottom));
      w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      XCnt := w1 div w;
      YCnt := h1 div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        C.Draw(X * w, Y * h, TabSheetBG);
      TabSheetBG.Free;
    end
  else
  with C do
  begin
    Brush.Color := clbtnface;
    FillRect(Rect(0, 0, w1, h1));
  end;
  C.Free;
end;        

{TTabSheetes}
constructor TspSkinTabSheet.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
end;

destructor TspSkinTabSheet.Destroy;
begin
  inherited Destroy;
end;

procedure TspSkinTabSheet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

{ TspSkinPageControl }

constructor TspSkinPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Ctl3D := False;
  FIndex := -1;
  Picture := nil;
  FUseSkinFont := True;
  Font.Name := 'Arial';
  Font.Style := [];
  Font.Color := clBtnText;
  Font.Height := 14;
  FSkinUpDown := nil;
  FSkinDataName := 'tab';
  FDefaultFont := TFont.Create;
  FDefaultFont.Name := 'Arial';
  FDefaultFont.Style := [];
  FDefaultFont.Color := clBtnText;
  FDefaultFont.Height := 14;
  FDefaultItemHeight := 20;
  FActiveTab := -1;
  FOldActiveTab := -1;
  FActiveTabIndex := -1;
  FOldActiveTabIndex := -1;
end;

destructor TspSkinPageControl.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinPageControl.UpDateTabs;
begin
  if FIndex <> -1
  then
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, RectHeight(TabRect))
      else
        SetItemSize(TabWidth, TabHeight);
    end
  else
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
    end;
  if MultiLine and (FSkinUpDown <> nil)
  then
    HideSkinUpDown;
  ReAlign;
end;

procedure TspSkinPageControl.CMMouseLeave;
var
  R: TRect;
begin
  if (FOldActiveTabIndex <> - 1) and (FOldActiveTabIndex <> TabIndex) and
     (FOldActiveTabIndex < PageCount)
  then
    begin
      R := GetItemRect(FOldActiveTabIndex);
      DrawTab(FOldActiveTab, R, False, False, Canvas);
      FOldActiveTabIndex := -1;
      FOldActiveTab := -1;
    end;

  if (FActiveTabIndex <> - 1) and (FActiveTabIndex <> TabIndex) and
     (FActiveTabIndex < PageCount)
  then
    begin
      R := GetItemRect(FActiveTabIndex);
      DrawTab(FActiveTab, R, False, False, Canvas);
      FActiveTabIndex := -1;
      FActiveTab := -1;
    end;
end;


procedure TspSkinPageControl.MouseDown;
begin
  inherited;
  if (Button = mbLeft) and not (csDesigning in ComponentState)
  then
    TestActive(X, Y);
end;

procedure TspSkinPageControl.MouseMove;
begin
 inherited;
 if  not (csDesigning in ComponentState)
 then
   TestActive(X, Y);
end;

procedure TspSkinPageControl.SetDefaultItemHeight;
begin
  FDefaultItemHeight := Value;
  if FIndex = -1
  then
    begin
      SetItemSize(TabWidth, FDefaultItemHeight);
      Change;
      ReAlign;
    end;
end;


procedure TspSkinPageControl.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinPageControl.OnUpDownChange(Sender: TObject);
begin
  FSkinUpDown.Max := GetInVisibleItemCount;
  SendMessage(Handle, WM_HSCROLL,
    MakeWParam(SB_THUMBPOSITION, FSkinUpDown.Position), 0);
end;

function TspSkinPageControl.GetPosition: Integer;
var
  i, j: Integer;
  R: TRect;
begin
  j := 0;
  for i := 0 to PageCount - 1 do
  begin
    R := GetItemRect(i);
    if R.Right <= 0 then inc(j);
  end;
  Result := j;
end;

function TspSkinPageControl.GetInVisibleItemCount;
var
  i, j, k: Integer;
  R: TRect;
  Limit: Integer;
begin
  if FSkinUpDown = nil
  then
    Limit := Width - 3
  else
    Limit := Width - FSkinUpDown.Width - 3;
  j := 0;
  k := -1;
  for i := 0 to PageCount - 1 do
  if Pages[i].TabVisible
  then
  begin
    inc(k);
    R := GetItemRect(k);
    if (R.Right > Limit) or (R.Right <= 0)
    then inc(j);
  end;
  Result := j;
end;

procedure TspSkinPageControl.CheckScroll;
var
  Wnd: HWND;
  InVCount: Integer;
begin
  Wnd := FindWindowEx(Handle, 0, 'msctls_updown32', nil);
  if Wnd <> 0 then DestroyWindow(Wnd);
  InVCount := GetInVisibleItemCount;
  if (InVCount = 0) and (FSkinUpDown <> nil)
  then
    HideSkinUpDown
  else
  if (InVCount > 0) and (FSkinUpDown = nil)
  then
    ShowSkinUpDown;
  if FSkinUpDown <> nil
  then
    begin
      FSkinUpDown.Max := InVCount;
      FSkinUpDown.Left := Width - FSkinUpDown.Width;
      if TabPosition = tpTop
      then
        FSkinUpDown.Top := 0
      else
       FSkinUpDown.Top := Height - FSkinUpDown.Height;
    end;
end;

procedure TspSkinPageControl.ShowSkinUpDown;
begin
  FSkinUpDown := TspSkinUpDown.Create(Self);
  FSkinUpDown.Parent := Self;
  FSkinUpDown.Width := FDefaultItemHeight * 2;
  FSkinUpDown.Height := FDefaultItemHeight;
  FSkinUpDown.Min := 0;
  FSkinUpDown.Max := GetInVisibleItemCount;
  FSkinUpDown.Position := GetPosition;
  FSkinUpDown.Increment := 1;
  FSkinUpDown.OnChange := OnUpDownChange;
  FSkinUpDown.Left := Width - FSkinUpDown.Width;
  if TabPosition = tpTop
  then
    FSkinUpDown.Top := 0
  else
    FSkinUpDown.Top := Height - FSkinUpDown.Height;
  FSkinUpDown.SkinDataName := UpDown;
  FSkinUpDown.SkinData := SkinData;
  FSkinUpDown.Visible := True;
end;

procedure TspSkinPageControl.HideSkinUpDown;
begin
  FSkinUpDown.Free;
  FSkinUpDown := nil;
end;

procedure TspSkinPageControl.WMHSCROLL;
begin
  inherited;
  RePaint;
end;

procedure TspSkinPageControl.WMSize;
begin
  GetSkinData;
  inherited;
end;

procedure TspSkinPageControl.Change;
begin
  if FSkinUpDown <> nil
  then FSkinUpDown.Position := GetPosition;
  inherited;
  Invalidate;
end;

procedure TspSkinPageControl.GetSkinData;
begin
  BGPictureIndex := -1;
  if FSD = nil
  then
    begin
      FIndex := -1;
      Exit;
    end;
  if FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  //
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinTabControl
    then
      with TspDataSkinTabControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        Self.TabRect := TabRect;
        if IsNullRect(ActiveTabRect)
        then
          Self.ActiveTabRect := TabRect
        else
          Self.ActiveTabRect := ActiveTabRect;
        if IsNullRect(FocusTabRect)
        then
          Self.FocusTabRect := ActiveTabRect
        else
          Self.FocusTabRect := FocusTabRect;
        //
        Self.TabsBGRect := TabsBGRect;
        Self.LTPoint := LTPoint;
        Self.RTPoint := RTPoint;
        Self.LBPoint := LBPoint;
        Self.RBPoint := RBPoint;
        Self.TabLeftOffset := TabLeftOffset;
        Self.TabRightOffset := TabRightOffset;
        //
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.FocusFontColor := FocusFontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.UpDown := UpDown;
        Self.BGPictureIndex := BGPictureIndex;
        Self.MouseInTabRect := MouseInTabRect;
        Self.MouseInFontColor := MouseInFontColor;
      end;
end;

procedure TspSkinPageControl.ChangeSkinData;
begin
  GetSkinData;
  //
  if FIndex <> -1
  then
    begin
      if FUseSkinFont
      then
        begin
          Font.Name := FontName;
          Font.Height := FontHeight;
          Font.Style := FontStyle;
        end
      else
        Font.Assign(FDefaultFont);

      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := DefaultFont.CharSet;


      Font.Color := FontColor;
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, RectHeight(TabRect))
      else
        SetItemSize(TabWidth, TabHeight);
    end
  else
    begin
      Font.Assign(FDefaultFont);
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
    end;
  //
  Change;
  ReAlign;
  if FSkinUpDown <> nil
  then
    begin
      HideSkinUpDown;
      CheckScroll;
    end;
  if ActivePage <> nil then ActivePage.RePaint;  
end;

procedure TspSkinPageControl.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinPageControl.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinPageControl.PaintDefaultWindow;
var
  R: TRect;
begin
  with Cnvs do
  begin
    Brush.Color := clBtnFace;
    FillRect(ClientRect);
    R := Self.DisplayRect;
    InflateRect(R, 1, 1);
    Frame3D(Cnvs, R, clBtnShadow, clBtnShadow, 1);
  end;
end;

procedure TspSkinPageControl.PaintSkinWindow;
var
  TOff, LOff, Roff, BOff: Integer;
  DR, R: TRect;
  TBGOffX, TBGOffY, X, Y, XCnt, YCnt, w, h, rw, rh, XO, YO: Integer;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
begin
  TOff := ClRect.Top;
  LOff := ClRect.Left;
  ROff := RectWidth(SkinRect) - ClRect.Right;
  BOff := RectHeight(SkinRect) - ClRect.Bottom;
  DR := DisplayRect;
  R := Rect(DR.Left - LOff, DR.Top - TOff, DR.Right + ROff, DR.Bottom + BOff);
  XO := RectWidth(R) - RectWidth(SkinRect);
  YO := RectHeight(R) - RectHeight(SkinRect);
  NewLTPoint := LTPoint;
  NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
  NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
  NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
  // Draw tabs BG
  if not IsNullRect(TabsBGRect)
  then
    begin
      if TabPosition = tpLeft
      then
        begin
          TBGOffY := 0;
          TBGOffX := 0;
          rw := R.Left;
          rh := Height;
        end
      else
      if TabPosition = tpRight
      then
        begin
          TBGOffY := 0;
          TBGOffX := R.Right;
          rw := Width - R.Right;
          rh := Height;
        end
      else
      if TabPosition = tpTop
      then
        begin
          TBGOffX := 0;
          TBGOffY := 0;
          rh := R.Top;
          rw := Width;
        end
      else
        begin
          TBGOffX := 0;
          TBGOffY := R.Bottom;
          rh := Height - R.Bottom;
          rw := Width;
        end;
      w := RectWidth(TabsBGRect);
      h := RectHeight(TabsBGRect);
      XCnt := rw div w;
      YCnt := rh div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
      begin
        if X * w + w > rw then XO := X * w + w - rw else XO := 0;
        if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
        Cnvs.CopyRect(Rect(TBGOffX + X * w, TBGOffY + Y * h,
                           TBGOffX + X * w + w - XO, TBGOffY + Y * h + h - YO),
                      Picture.Canvas,
                      Rect(TabsBGRect.Left, TabsBGRect.Top,
                           TabsBGRect.Right - XO, TabsBGRect.Bottom - YO));
      end;
    end;  
  // Draw frame around displayrect
    // draw lines
  w := RTPoint.X - LTPoint.X;
  XCnt := (NewRTPoint.X - NewLTPoint.X) div w;
  for X := 0 to XCnt do
  begin
    if NewLTPoint.X + X * w + w > NewRTPoint.X
    then XO := NewLTPoint.X + X * w + w - NewRTPoint.X else XO := 0;
    Cnvs.CopyRect(Rect(R.Left + NewLTPoint.X + X * w, R.Top,
                  R.Left + NewLTPoint.X + X * w + w - XO, R.Top + TOff),
             Picture.Canvas,
             Rect(SkinRect.Left + LTPoint.X, SkinRect.Top,
                  SkinRect.Left + RTPoint.X - XO, SkinRect.Top + TOff));
  end;

  w := RBPoint.X - LBPoint.X;
  XCnt := (NewRBPoint.X - NewLBPoint.X) div w;
  for X := 0 to XCnt do
  begin
    if NewLBPoint.X + X * w + w > NewRBPoint.X
    then XO := NewLBPoint.X + X * w + w - NewRBPoint.X else XO := 0;
    Cnvs.CopyRect(Rect(R.Left + NewLBPoint.X + X * w, R.Bottom - BOff,
                  R.Left + NewLBPoint.X + X * w + w - XO, R.Bottom),
             Picture.Canvas,
             Rect(SkinRect.Left + LBPoint.X, SkinRect.Bottom - BOff,
                  SkinRect.Left + RBPoint.X - XO, SkinRect.Bottom));
  end;

  w := LOff;
  h := LBPoint.Y - LTPoint.Y;
  YCnt := (NewLBPoint.Y - NewLTPoint.Y) div h;
  for Y := 0 to YCnt do
  begin
    if NewLTPoint.Y + Y * h + h > NewLBPoint.Y
    then YO := NewLTPoint.Y + Y * h + h - NewLBPoint.Y else YO := 0;
    Cnvs.CopyRect(Rect(R.Left, R.Top + NewLTPoint.Y + Y * h,
                       R.Left + w, R.Top + NewLTPoint.Y + Y * h + h - YO),
                  Picture.Canvas,
                  Rect(SkinRect.Left, SkinRect.Top + LTPoint.Y,
                       SkinRect.Left + w, SkinRect.Top + LBPoint.Y - YO));
  end;
  w := ROff;
  h := RBPoint.Y - RTPoint.Y;
  YCnt := (NewRBPoint.Y - NewRTPoint.Y) div h;
  for Y := 0 to YCnt do
  begin
    if NewRTPoint.Y + Y * h + h > NewRBPoint.Y
    then YO := NewRTPoint.Y + Y * h + h - NewRBPoint.Y else YO := 0;
    Cnvs.CopyRect(Rect(R.Right - w, R.Top + NewRTPoint.Y + Y * h,
                       R.Right, R.Top + NewRTPoint.Y + Y * h + h - YO),
                  Picture.Canvas,
                  Rect(SkinRect.Right - w, SkinRect.Top + RTPoint.Y,
                       SkinRect.Right, SkinRect.Top + RBPoint.Y - YO));
  end;
    // draw corners
  Cnvs.CopyRect(Rect(R.Left, R.Top, R.Left + LTPoint.X, R.Top + LTPoint.Y),
                Picture.Canvas,
                Rect(SkinRect.Left, SkinRect.Top,
                     SkinRect.Left + NewLTPoint.X, SkinRect.Top + NewLTPoint.Y));
  Cnvs.CopyRect(Rect(R.Left + NewRTPoint.X, R.Top,
                     R.Right, R.Top + NewRTPoint.Y),
                Picture.Canvas,
                Rect(SkinRect.Left + RTPoint.X, SkinRect.Top,
                     SkinRect.Right, SkinRect.Top + RTPoint.Y));
  Cnvs.CopyRect(Rect(R.Left, R.Top + NewLBPoint.Y,
                     R.Left + NewLBPoint.X, R.Bottom),
                Picture.Canvas,
                Rect(SkinRect.Left, SkinRect.Top + LBPoint.Y,
                     SkinRect.Left + LBPoint.X, SkinRect.Bottom));
  Cnvs.CopyRect(Rect(R.Left + NewRBPoint.X, R.Top + NewRBPoint.Y,
                     R.Right, R.Bottom),
                Picture.Canvas,
                Rect(SkinRect.Left + RBPoint.X, SkinRect.Top + RBPoint.Y,
                     SkinRect.Right, SkinRect.Bottom));
end;

procedure TspSkinPageControl.Loaded;
begin
  inherited Loaded;
  if FIndex = -1
  then
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
      Change;
      ReAlign;
    end;
end;

procedure TspSkinPageControl.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  if Self.PageCount = 0
  then
    inherited
  else
    Msg.Result := 1;
end;

procedure TspSkinPageControl.WndProc(var Message:TMessage);
var
  TOff, LOff, Roff, BOff: Integer;
begin
  if Message.Msg = TCM_ADJUSTRECT
  then
    begin
      inherited WndProc(Message);
      if FIndex <> -1
      then
        begin
          TOff := ClRect.Top;
          LOff := ClRect.Left;
          ROff := RectWidth(SkinRect) - ClRect.Right;
          BOff := RectHeight(SkinRect) - ClRect.Bottom;
        end;
      case TabPosition of
        tpLeft:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left + LOff - 4;
               PRect(Message.LParam)^.Right := ClientWidth - ROff;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 3;
               PRect(Message.LParam)^.Right := ClientWidth - 1;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpRight:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := LOff;
               PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - ROff + 4;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 3;
               PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right + 3;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpTop:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := LOff;
               PRect(Message.LParam)^.Right := ClientWidth - ROff;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := 1;
               PRect(Message.LParam)^.Right := ClientWidth - 1;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpBottom:
          if FIndex <> -1
          then
            begin
              PRect(Message.LParam)^.Left := LOff;
              PRect(Message.LParam)^.Right := ClientWidth - ROff;
              PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
              PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 4 - BOff;
            end
          else
            begin
              PRect(Message.LParam)^.Left := 1;
              PRect(Message.LParam)^.Right := ClientWidth - 1;
              PRect(Message.LParam)^.Top := 1;
              PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 3;
            end;

      end;
    end
  else
    if Message.Msg = TCM_GETITEMRECT
    then
      begin
        inherited WndProc(Message);
        if Style = tsTabs
        then
          case TabPosition of
            tpLeft:
                begin
                  PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                  PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                end;
            tpRight:
                begin
                  PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left + 2;
                  PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right + 2;
                end;

            tpTop:
                begin
                  if not MultiLine
                  then
                    begin
                      PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                      PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                    end;
                  PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 2;
                  PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom - 2;
                end;
            tpBottom:
                begin
                  if not MultiLine
                  then
                    begin
                      PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                      PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                    end;
                  PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top + 2;
                  PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 2;
                end;
          end;
      end
  else
  inherited WndProc(Message);
  if (Message.Msg = WM_SIZE) and (not MultiLine) and
     not (csDesigning in ComponentState)
  then
    begin
      CheckScroll;
    end;
end;

function TspSkinPageControl.GetItemRect(index: integer): TRect;
var
  R: TRect;
begin
  SendMessage(Handle, TCM_GETITEMRECT, index, Integer(@R));
  Result := R;
end;

procedure TspSkinPageControl.SetItemSize;
begin
  SendMessage(Handle, TCM_SETITEMSIZE, 0, MakeLParam(AWidth, AHeight));
end;

procedure TspSkinPageControl.PaintWindow(DC: HDC);
var
  SaveIndex: Integer;
  B: TBitMap;
begin
  if (Width <= 0) or (Height <=0) then Exit;
  GetSkinData;
  SaveIndex := SaveDC(DC);
  try
    Canvas.Handle := DC;
    B := TBitMap.Create;
    B.Width := Width;
    B.Height := Height;
    if FIndex = -1
    then
      PaintDefaultWindow(B.Canvas)
    else
      PaintSkinWindow(B.Canvas);
    DrawTabs(B.Canvas);
    Canvas.Draw(0, 0, B);
    B.Free;
    Canvas.Handle := 0;
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TspSkinPageControl.TestActive(X, Y: Integer);
var
  i, j, k: Integer;
  R: TRect;
begin
  FOldActiveTab := FActiveTab;
  FOldActiveTabIndex := FActiveTabIndex;
  k := -1;
  j := -1;
  for i := 0 to PageCount - 1 do
  if Pages[i].TabVisible then
  begin
    Inc(k);
    R := GetItemRect(k);
    if PtInRect(R, Point(X, Y))
    then
      begin
        j := k;
        Break;
      end;
  end;

  FActiveTab := i;
  FActiveTabIndex := j;

  if (FOldActiveTabIndex <> FActiveTabIndex)
  then
    begin
      if (FOldActiveTabIndex <> - 1) and (FOldActiveTabIndex <> TabIndex) and
         (FOldActiveTabIndex < PageCount)
      then
        begin
          R := GetItemRect(FOldActiveTabIndex);
          DrawTab(FOldActiveTab, R, False, False, Canvas);
        end;
      if (FActiveTabIndex <> -1) and (FActiveTabIndex <> TabIndex) and
         (FActiveTabIndex < PageCount)
      then
        begin
          R := GetItemRect(FActiveTabIndex);
          DrawTab(FActiveTab, R, False, True, Canvas );
        end;
    end;
end;

procedure TspSkinPageControl.DrawTabs;
var
  i, j: integer;
  R: TRect;
begin
  j := -1;
  for i := 0 to PageCount-1 do
  if Pages[i].TabVisible then
  begin
    inc(j);
    R := GetItemRect(j);
    DrawTab(i, R, (j = TabIndex), j = FActiveTabIndex, Cnvs);
  end;
end;

procedure TspSkinPageControl.DrawTab;
var
  R: TRect;
  S: String;
  TB, BufferTB: TBitMap;
  DrawGlyph: Boolean;
  W, H: Integer;
begin
  DrawGlyph := (Images <> nil) and (TI < Images.Count);
  S := Pages[TI].Caption;
  TB := TBitMap.Create;
  if (TabPosition = tpTop) or (TabPosition = tpBottom)
  then
    begin
      W := RectWidth(Rct);
      H := RectHeight(Rct);
    end
  else
    begin
      H := RectWidth(Rct);
      W := RectHeight(Rct);
    end;
  R := Rect(0, 0, W, H);  
  if FIndex <> -1
  then
    begin
      if TabHeight <= 0
      then
        begin
          if MouseIn and not Active and not IsNullRect(MouseInTabRect)
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             TB, Picture, MouseInTabRect, W, H)
          else
            if Active and Focused
          then
           CreateHSkinImage(TabLeftOffset, TabRightOffset,
            TB, Picture, FocusTabRect, W, H)
          else
          if Active
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
              TB, Picture, ActiveTabRect, W, H)
          else
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             TB, Picture, TabRect, W, H);
       end
     else
       begin
         BufferTB := TBitMap.Create;
         BufferTB.Width := W;
         BufferTB.Height := RectHeight(TabRect);
         if MouseIn and not Active and not IsNullRect(MouseInTabRect)
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             BufferTB, Picture, MouseInTabRect, W, H)
          else
            if Active and Focused
          then
           CreateHSkinImage(TabLeftOffset, TabRightOffset,
            BufferTB, Picture, FocusTabRect, W, H)
          else
          if Active
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
              BufferTB, Picture, ActiveTabRect, W, H)
          else
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             BufferTB, Picture, TabRect, W, H);
         TB.Width := W;
         TB.Height := H;
         TB.Canvas.StretchDraw(R, BufferTB);
         BufferTB.Free;
       end;
      if TabPosition = tpBottom then DrawFlipVert(TB);
      with TB.Canvas do
      begin
        Brush.Style := bsClear;
        if FUseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Style := FontStyle;
            Font.Height := FontHeight;
          end
        else
           Font.Assign(Self.Font);

        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet
        else
          Font.CharSet := Self.Font.CharSet;
          
        if MouseIn and not Active
        then
          Font.Color := MouseInFontColor
        else
        if Active and Focused
        then
          Font.Color := FocusFontColor
        else
          if Active
          then Font.Color := ActiveFontColor
          else Font.Color := FontColor;
      end;
    end
  else
    begin
      TB.Width := W;
      TB.Height := H;
      if MouseIn and not Active
      then
        begin
          TB.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          TB.Canvas.FillRect(R);
        end
      else
      if Active and Focused
      then
        begin
          Frame3D(TB.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          TB.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          TB.Canvas.FillRect(R);
        end
      else
      if Active
      then
        begin
          Frame3D(TB.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          TB.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          TB.Canvas.FillRect(R);
        end
      else
        begin
          TB.Canvas.Brush.Color := clBtnFace;
          TB.Canvas.FillRect(R);
        end;
      with TB.Canvas do
      begin
        Brush.Style := bsClear;
        Font.Assign(Self.Font);
        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet;
      end;
    end;
  //
  if DrawGlyph
  then
    DrawTabGlyphAndText(TB.Canvas, TB.Width, TB.Height, S,
                        Images, Pages[TI].ImageIndex, Pages[TI].Enabled)
  else
    DrawText(TB.Canvas.Handle, PChar(S), Length(S), R, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  if TabPosition = tpLeft
  then
    DrawRotate90_1(Cnvs, TB, Rct.Left, Rct.Top)
  else
  if TabPosition = tpRight
  then
    DrawRotate90_2(Cnvs, TB, Rct.Left, Rct.Top)
  else
    Cnvs.Draw(Rct.Left, Rct.Top, TB);
  TB.Free;
end;


{ TspSkinTabControl }

constructor TspSkinTabControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseSkinFont := True;
  Ctl3D := False;
  FIndex := -1;
  Picture := nil;
  Font.Name := 'Arial';
  Font.Style := [];
  Font.Color := clBtnText;
  Font.Height := 14;
  FOldTop := 0;
  FOldBottom := 0;
  FSkinUpDown := nil;
  FSkinDataName := 'tab';
  FDefaultFont := TFont.Create;
  FDefaultFont.Name := 'Arial';
  FDefaultFont.Style := [];
  FDefaultFont.Color := clBtnText;
  FDefaultFont.Height := 14;
  FDefaultItemHeight := 20;
end;

procedure TspSkinTabControl.MouseMove;
begin
 inherited;
 if not (csDesigning in ComponentState)
 then
   TestActive(X, Y);
end;

procedure TspSkinTabControl.MouseDown;
begin
  inherited;
  if (Button = mbLeft) and not (csDesigning in ComponentState)
  then
    TestActive(X, Y);
end;

procedure TspSkinTabControl.CMMouseLeave;
var
  R: TRect;
begin
  if (FOldActiveTab <> - 1) and (FOldActiveTab <> TabIndex)
  then
    begin
      R := GetItemRect(FOldActiveTab);
      DrawTab(FOldActiveTab, R, False, False, Canvas);
      FOldActiveTab := -1;
    end;

  if (FActiveTab <> - 1) and (FActiveTab <> TabIndex)
  then
    begin
      R := GetItemRect(FActiveTab);
      DrawTab(FActiveTab, R, False, False, Canvas);
      FActiveTab := -1;
    end;
end;

procedure TspSkinTabControl.TestActive(X, Y: Integer);
var
  i, j: Integer;
  R: TRect;
begin
  FOldActiveTab := FActiveTab;
  j := -1;
  for i := 0 to Tabs.Count-1 do
  begin
    R := GetItemRect(i);
    if PtInRect(R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  FActiveTab := j;

  if (FOldActiveTab <> FActiveTab)
  then
    begin
      if (FOldActiveTab <> - 1) and (FOldActiveTab <> TabIndex)
      then
        begin
          R := GetItemRect(FOldActiveTab);
          DrawTab(FOldActiveTab, R, False, False, Canvas);
        end;
      if (FActiveTab <> -1) and (FActiveTab <> TabIndex)
      then
        begin
          R := GetItemRect(FActiveTab);
          DrawTab(FActiveTab, R, False, True, Canvas );
        end;
    end;
end;

procedure TspSkinTabControl.SetDefaultItemHeight;
begin
  FDefaultItemHeight := Value;
  if FIndex = -1
  then
    begin
      SetitemSize(TabWidth, FDefaultItemHeight);
      Change;
      ReAlign;
    end;
end;


procedure TspSkinTabControl.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinTabControl.OnUpDownChange(Sender: TObject);
begin
  FSkinUpDown.Max := GetInVisibleItemCount;
  SendMessage(Handle, WM_HSCROLL,
    MakeWParam(SB_THUMBPOSITION, FSkinUpDown.Position), 0);
end;

function TspSkinTabControl.GetPosition: Integer;
var
  i, j: Integer;
  R: TRect;
begin
  j := 0;
  for i := 0 to Tabs.Count - 1 do
  begin
    R := GetItemRect(i);
    if R.Right <= 0 then inc(j);
  end;
  Result := j;
end;

function TspSkinTabControl.GetInVisibleItemCount;
var
  i, j: Integer;
  R: TRect;
  Limit: Integer;
begin
  if FSkinUpDown = nil
  then
    Limit := Width - 3
  else
    Limit := Width - FSkinUpDown.Width - 3;
  j := 0;
  for i := 0 to Tabs.Count - 1 do
  begin
    R := GetItemRect(i);
    if (R.Right > Limit) or (R.Right <= 0)
    then inc(j);
  end;
  Result := j;
end;

procedure TspSkinTabControl.CheckScroll;
var
  Wnd: HWND;
  InVCount: Integer;
begin
  Wnd := FindWindowEx(Handle, 0, 'msctls_updown32', nil);
  if Wnd <> 0 then DestroyWindow(Wnd);
  InVCount := GetInVisibleItemCount;
  if (InVCount = 0) and (FSkinUpDown <> nil)
  then
    HideSkinUpDown
  else
  if (InVCount > 0) and (FSkinUpDown = nil)
  then
    ShowSkinUpDown;
  if FSkinUpDown <> nil
  then
    begin
      FSkinUpDown.Max := InVCount;
      FSkinUpDown.Left := Width - FSkinUpDown.Width;
      if TabPosition = tpTop
      then
        FSkinUpDown.Top := 0
      else
       FSkinUpDown.Top := Height - FSkinUpDown.Height;
    end;
end;

procedure TspSkinTabControl.ShowSkinUpDown;
begin
  FSkinUpDown := TspSkinUpDown.Create(Self);
  FSkinUpDown.Parent := Self;
  FSkinUpDown.Width := 36;
  FSkinUpDown.Height := 18;
  FSkinUpDown.Min := 0;
  FSkinUpDown.Max := GetInVisibleItemCount;
  FSkinUpDown.Position := GetPosition;
  FSkinUpDown.Increment := 1;
  FSkinUpDown.OnChange := OnUpDownChange;
  FSkinUpDown.Left := Width - FSkinUpDown.Width;
  if TabPosition = tpTop
  then
    FSkinUpDown.Top := 0
  else
    FSkinUpDown.Top := Height - FSkinUpDown.Height;
  FSkinUpDown.SkinDataName := UpDown;
  FSkinUpDown.SkinData := SkinData;
  FSkinUpDown.Visible := True;
end;

procedure TspSkinTabControl.HideSkinUpDown;
begin
  FSkinUpDown.Free;
  FSkinUpDown := nil;
end;

procedure TspSkinTabControl.WMPaint;
begin
  if ControlCount = 0
  then
    PaintHandler(Msg)
  else
    inherited;
end;

procedure TspSkinTabControl.WMHSCROLL;
begin
  inherited;
  RePaint;
end;

procedure TspSkinTabControl.WMSize;
begin
  inherited;
end;

destructor TspSkinTabControl.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinTabControl.Change;
begin
  if FSkinUpDown <> nil
  then FSkinUpDown.Position := GetPosition;
  inherited;
  Invalidate;
end;

procedure TspSkinTabControl.GetSkinData;
begin
  BGPictureIndex := -1;
  if FSD = nil
  then
    begin
      FIndex := -1;
      Exit;
    end;
  if FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);
  //
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinTabControl
    then
      with TspDataSkinTabControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.SkinRect := SkinRect;
        Self.ClRect := ClRect;
        Self.TabRect := TabRect;
        if IsNullRect(ActiveTabRect)
        then
          Self.ActiveTabRect := TabRect
        else
          Self.ActiveTabRect := ActiveTabRect;
        if IsNullRect(FocusTabRect)
        then
          Self.FocusTabRect := ActiveTabRect
        else
          Self.FocusTabRect := FocusTabRect;
        //
        Self.TabsBGRect := TabsBGRect; 
        Self.LTPoint := LTPoint;
        Self.RTPoint := RTPoint;
        Self.LBPoint := LBPoint;
        Self.RBPoint := RBPoint;
        Self.TabLeftOffset := TabLeftOffset;
        Self.TabRightOffset := TabRightOffset;
        //
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.FocusFontColor := FocusFontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.UpDown := UpDown;
        Self.BGPictureIndex := BGPictureIndex;
        Self.MouseInFontColor := MouseInFontColor;
        Self.MouseInTabRect := MouseInTabRect;
      end;
end;

procedure TspSkinTabControl.ChangeSkinData;
begin
  GetSkinData;
  //
  if FIndex <> -1
  then
    begin
      Font.Color := FontColor;
      if FUseSkinFont
      then
        begin
          Font.Name := FontName;
          Font.Height := FontHeight;
          Font.Style := FontStyle;
        end
      else
        Font.Assign(FDefaultFont);

      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := DefaultFont.CharSet;
 
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, RectHeight(TabRect))
      else
        SetItemSize(TabWidth, TabHeight);
    end
  else
    begin
      Font.Assign(FDefaultFont);
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
    end;
  //
  Change;
  ReAlign;
  RePaint;
  if FSkinUpDown <> nil
  then
    begin
      HideSkinUpDown;
      CheckScroll;
    end;
end;

procedure TspSkinTabControl.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinTabControl.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinTabControl.PaintDefaultWindow;
var
  R: TRect;
begin
  with Cnvs do
  begin
    Brush.Color := clBtnFace;
    FillRect(ClientRect);
    R := Self.DisplayRect;
    InflateRect(R, 1, 1);
    Frame3D(Cnvs, R, clBtnShadow, clBtnShadow, 1);
  end;
end;

procedure TspSkinTabControl.PaintSkinWindow;
var
  TOff, LOff, Roff, BOff: Integer;
  DR, R: TRect;
  TBGOffX, TBGOffY, X, Y, XCnt, YCnt, w, h, w1, h1, rw, rh, XO, YO: Integer;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  B: TBitMap;
begin
  TOff := ClRect.Top;
  LOff := ClRect.Left;
  ROff := RectWidth(SkinRect) - ClRect.Right;
  BOff := RectHeight(SkinRect) - ClRect.Bottom;
  DR := DisplayRect;
  R := Rect(DR.Left - LOff, DR.Top - TOff, DR.Right + ROff, DR.Bottom + BOff);
  XO := RectWidth(R) - RectWidth(SkinRect);
  YO := RectHeight(R) - RectHeight(SkinRect);
  NewLTPoint := LTPoint;
  NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
  NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
  NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
  // DrawBG

  if BGPictureIndex <> -1
  then
    begin
      B := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
      if (Width > 0) and (Height > 0)
      then
        begin
          XCnt := Width div B.Width;
          YCnt := Height div B.Height;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
          Cnvs.Draw(X * B.Width, Y * B.Height, B);
        end;
      Exit;
    end;

  w := RectWidth(ClRect);
  h := RectHeight(ClRect);
  w1 := RectWidth(R);
  h1 := RectHeight(R);
  XCnt := w1 div w;
  YCnt := h1 div h;
  for X := 0 to XCnt do
  for Y := 0 to YCnt do
  begin
    if X * w + w > w1 then XO := X * w + w - w1 else XO := 0;
    if Y * h + h > h1 then YO := Y * h + h - h1 else YO := 0;
     Cnvs.CopyRect(Rect(R.Left + X * w, R.Top + Y * h,
                        R.Left + X * w + w - XO, R.Top + Y * h + h - YO),
              Picture.Canvas,
              Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                   SkinRect.Left + ClRect.Right - XO,
                   SkinRect.Top + ClRect.Bottom - YO));
  end;            
  // Draw tabs BG
  if not IsNullRect(TabsBGRect)
  then
    begin
      if TabPosition = tpLeft
      then
        begin
          TBGOffY := 0;
          TBGOffX := 0;
          rw := R.Left;
          rh := Height;
        end
      else
      if TabPosition = tpRight
      then
        begin
          TBGOffY := 0;
          TBGOffX := R.Right;
          rw := Width - R.Right;
          rh := Height;
        end
      else
      if TabPosition = tpTop
      then
        begin
          TBGOffX := 0;
          TBGOffY := 0;
          rh := R.Top;
          rw := Width;
        end
      else
        begin
          TBGOffX := 0;
          TBGOffY := R.Bottom;
          rh := Height - R.Bottom;
          rw := Width;
        end;
      w := RectWidth(TabsBGRect);
      h := RectHeight(TabsBGRect);
      XCnt := rw div w;
      YCnt := rh div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
      begin
        if X * w + w > rw then XO := X * w + w - rw else XO := 0;
        if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
        Cnvs.CopyRect(Rect(TBGOffX + X * w, TBGOffY + Y * h,
                           TBGOffX + X * w + w - XO, TBGOffY + Y * h + h - YO),
                      Picture.Canvas,
                      Rect(TabsBGRect.Left, TabsBGRect.Top,
                           TabsBGRect.Right - XO, TabsBGRect.Bottom - YO));
      end;
    end;
  // Draw frame around displayrect
    // draw lines
  w := RTPoint.X - LTPoint.X;
  XCnt := (NewRTPoint.X - NewLTPoint.X) div w;
  for X := 0 to XCnt do
  begin
    if NewLTPoint.X + X * w + w > NewRTPoint.X
    then XO := NewLTPoint.X + X * w + w - NewRTPoint.X else XO := 0;
    Cnvs.CopyRect(Rect(R.Left + NewLTPoint.X + X * w, R.Top,
                  R.Left + NewLTPoint.X + X * w + w - XO, R.Top + TOff),
             Picture.Canvas,
             Rect(SkinRect.Left + LTPoint.X, SkinRect.Top,
                  SkinRect.Left + RTPoint.X - XO, SkinRect.Top + TOff));
  end;

  w := RBPoint.X - LBPoint.X;
  XCnt := (NewRBPoint.X - NewLBPoint.X) div w;
  for X := 0 to XCnt do
  begin
    if NewLBPoint.X + X * w + w > NewRBPoint.X
    then XO := NewLBPoint.X + X * w + w - NewRBPoint.X else XO := 0;
    Cnvs.CopyRect(Rect(R.Left + NewLBPoint.X + X * w, R.Bottom - BOff,
                  R.Left + NewLBPoint.X + X * w + w - XO, R.Bottom),
             Picture.Canvas,
             Rect(SkinRect.Left + LBPoint.X, SkinRect.Bottom - BOff,
                  SkinRect.Left + RBPoint.X - XO, SkinRect.Bottom));
  end;

  w := LOff;
  h := LBPoint.Y - LTPoint.Y;
  YCnt := (NewLBPoint.Y - NewLTPoint.Y) div h;
  for Y := 0 to YCnt do
  begin
    if NewLTPoint.Y + Y * h + h > NewLBPoint.Y
    then YO := NewLTPoint.Y + Y * h + h - NewLBPoint.Y else YO := 0;
    Cnvs.CopyRect(Rect(R.Left, R.Top + NewLTPoint.Y + Y * h,
                       R.Left + w, R.Top + NewLTPoint.Y + Y * h + h - YO),
                  Picture.Canvas,
                  Rect(SkinRect.Left, SkinRect.Top + LTPoint.Y,
                       SkinRect.Left + w, SkinRect.Top + LBPoint.Y - YO));
  end;
  w := ROff;
  h := RBPoint.Y - RTPoint.Y;
  YCnt := (NewRBPoint.Y - NewRTPoint.Y) div h;
  for Y := 0 to YCnt do
  begin
    if NewRTPoint.Y + Y * h + h > NewRBPoint.Y
    then YO := NewRTPoint.Y + Y * h + h - NewRBPoint.Y else YO := 0;
    Cnvs.CopyRect(Rect(R.Right - w, R.Top + NewRTPoint.Y + Y * h,
                       R.Right, R.Top + NewRTPoint.Y + Y * h + h - YO),
                  Picture.Canvas,
                  Rect(SkinRect.Right - w, SkinRect.Top + RTPoint.Y,
                       SkinRect.Right, SkinRect.Top + RBPoint.Y - YO));
  end;
    // draw corners
  Cnvs.CopyRect(Rect(R.Left, R.Top, R.Left + LTPoint.X, R.Top + LTPoint.Y),
                Picture.Canvas,
                Rect(SkinRect.Left, SkinRect.Top,
                     SkinRect.Left + NewLTPoint.X, SkinRect.Top + NewLTPoint.Y));
  Cnvs.CopyRect(Rect(R.Left + NewRTPoint.X, R.Top,
                     R.Right, R.Top + NewRTPoint.Y),
                Picture.Canvas,
                Rect(SkinRect.Left + RTPoint.X, SkinRect.Top,
                     SkinRect.Right, SkinRect.Top + RTPoint.Y));
  Cnvs.CopyRect(Rect(R.Left, R.Top + NewLBPoint.Y,
                     R.Left + NewLBPoint.X, R.Bottom),
                Picture.Canvas,
                Rect(SkinRect.Left, SkinRect.Top + LBPoint.Y,
                     SkinRect.Left + LBPoint.X, SkinRect.Bottom));
  Cnvs.CopyRect(Rect(R.Left + NewRBPoint.X, R.Top + NewRBPoint.Y,
                     R.Right, R.Bottom),
                Picture.Canvas,
                Rect(SkinRect.Left + RBPoint.X, SkinRect.Top + RBPoint.Y,
                     SkinRect.Right, SkinRect.Bottom));
end;


procedure TspSkinTabControl.Loaded;
begin
  inherited Loaded;
  if FIndex = -1
  then
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
      Change;
      ReAlign;
    end;
end;

procedure TspSkinTabControl.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

procedure TspSkinTabControl.WndProc(var Message:TMessage);
var
  TOff, LOff, Roff, BOff: Integer;
begin
  if Message.Msg = TCM_ADJUSTRECT
  then
    begin
      inherited WndProc(Message);
      TOff := 0;
      LOff := 0;
      ROff := 0;
      BOff := 0;
      if (FIndex <> -1) and (BGPictureIndex = -1)
      then
        begin
          TOff := ClRect.Top;
          LOff := ClRect.Left;
          ROff := RectWidth(SkinRect) - ClRect.Right;
          BOff := RectHeight(SkinRect) - ClRect.Bottom;
        end;
      case TabPosition of
        tpLeft:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left + LOff - 4;
               PRect(Message.LParam)^.Right := ClientWidth - ROff;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 3;
               PRect(Message.LParam)^.Right := ClientWidth - 1;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpRight:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := LOff;
               PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - ROff + 4;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 3;
               PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right + 3;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpTop:
           if FIndex <> -1
           then
             begin
               PRect(Message.LParam)^.Left := LOff;
               PRect(Message.LParam)^.Right := ClientWidth - ROff;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
               PRect(Message.LParam)^.Bottom := ClientHeight - BOff;
             end
           else
             begin
               PRect(Message.LParam)^.Left := 1;
               PRect(Message.LParam)^.Right := ClientWidth - 1;
               PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 5;
               PRect(Message.LParam)^.Bottom := ClientHeight - 1;
             end;
        tpBottom:
          if FIndex <> -1
          then
            begin
              PRect(Message.LParam)^.Left := LOff;
              PRect(Message.LParam)^.Right := ClientWidth - ROff;
              PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 6 + TOff;
              PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 4 - BOff;
            end
          else
            begin
              PRect(Message.LParam)^.Left := 1;
              PRect(Message.LParam)^.Right := ClientWidth - 1;
              PRect(Message.LParam)^.Top := 1;
              PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 3;
            end;

      end;
    end
  else
    if Message.Msg = TCM_GETITEMRECT
    then
      begin
        inherited WndProc(Message);
        if Style = tsTabs
        then
          case TabPosition of
            tpLeft:
                begin
                  PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                  PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                end;
            tpRight:
                begin
                  PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left + 2;
                  PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right + 2;
                end;

            tpTop:
                begin
                  if not MultiLine
                  then
                    begin
                      PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                      PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                    end;
                  PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top - 2;
                  PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom - 2;
                end;
            tpBottom:
                begin
                  if not MultiLine
                  then
                    begin
                      PRect(Message.LParam)^.Left := PRect(Message.LParam)^.Left - 2;
                      PRect(Message.LParam)^.Right := PRect(Message.LParam)^.Right - 2;
                    end;
                  PRect(Message.LParam)^.Top := PRect(Message.LParam)^.Top + 2;
                  PRect(Message.LParam)^.Bottom := PRect(Message.LParam)^.Bottom + 2;
                end;
          end;
      end
  else
  inherited WndProc(Message);
  if (Message.Msg = WM_SIZE) and (not MultiLine)
  then
    begin
      CheckScroll;
    end;
end;

function TspSkinTabControl.GetItemRect(index: integer): TRect;
var
  R: TRect;
begin
  SendMessage(Handle, TCM_GETITEMRECT, index, Integer(@R));
  Result := R;
end;

procedure TspSkinTabControl.SetItemSize;
begin
  SendMessage(Handle, TCM_SETITEMSIZE, 0, MakeLParam(AWidth, AHeight));
end;

procedure TspSkinTabControl.PaintWindow(DC: HDC);
var
  SaveIndex: Integer;
  RealPicture: TBitMap;
begin
  GetSkinData;
  SaveIndex := SaveDC(DC);
  try
    RealPicture := TBitMap.Create;
    Canvas.Handle := DC;
    RealPicture.Width := Width;
    RealPicture.Height := Height;
    if FIndex = -1
    then
      PaintDefaultWindow(RealPicture.Canvas)
    else
      PaintSkinWindow(RealPicture.Canvas);
    DrawTabs(RealPicture.Canvas);
    Canvas.Draw(0, 0, RealPicture);
    Canvas.Handle := 0;
    RealPicture.Free;
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TspSkinTabControl.DrawTabs;
var
  i: integer;
  R: TRect;
begin
  for i := 0 to Tabs.Count-1 do
  begin
    R := GetItemRect(i);
    DrawTab(i, R, i = TabIndex, i = FActiveTab, Cnvs);
  end;
end;

procedure TspSkinTabControl.DrawTab;
var
  R: TRect;
  S: String;
  TB, BufferTB: TBitMap;
  DrawGlyph: Boolean;
  W, H: Integer;
begin
  DrawGlyph := (Images <> nil) and (TI < Images.Count);
  S := Tabs[TI];
  TB := TBitMap.Create;
  if (TabPosition = tpTop) or (TabPosition = tpBottom)
  then
    begin
      W := RectWidth(Rct);
      H := RectHeight(Rct);
    end
  else
    begin
      H := RectWidth(Rct);
      W := RectHeight(Rct);
    end;
  R := Rect(0, 0, W, H);  
  if FIndex <> -1
  then
    begin
      if TabHeight <= 0
      then
        begin
          if MouseIn and not Active and not IsNullRect(MouseInTabRect)
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             TB, Picture, MouseInTabRect, W, H)
          else
            if Active and Focused
          then
           CreateHSkinImage(TabLeftOffset, TabRightOffset,
            TB, Picture, FocusTabRect, W, H)
          else
          if Active
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
              TB, Picture, ActiveTabRect, W, H)
          else
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             TB, Picture, TabRect, W, H);
       end
     else
       begin
         BufferTB := TBitMap.Create;
         BufferTB.Width := W;
         BufferTB.Height := RectHeight(TabRect);
         if MouseIn and not Active and not IsNullRect(MouseInTabRect)
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             BufferTB, Picture, MouseInTabRect, W, H)
          else
            if Active and Focused
          then
           CreateHSkinImage(TabLeftOffset, TabRightOffset,
            BufferTB, Picture, FocusTabRect, W, H)
          else
          if Active
          then
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
              BufferTB, Picture, ActiveTabRect, W, H)
          else
            CreateHSkinImage(TabLeftOffset, TabRightOffset,
             BufferTB, Picture, TabRect, W, H);
         TB.Width := W;
         TB.Height := H;
         TB.Canvas.StretchDraw(R, BufferTB);
         BufferTB.Free;
       end;
      if TabPosition = tpBottom then DrawFlipVert(TB);
      with TB.Canvas do
      begin
        Brush.Style := bsClear;
        if FUseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Style := FontStyle;
            Font.Height := FontHeight;
            Font.CharSet := Self.Font.CharSet;
          end
        else
           Font.Assign(Self.Font);

        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet
        else
          Font.CharSet := Self.Font.CharSet;

        if MouseIn and not Active
        then
          Font.Color := MouseInFontColor
        else
        if Active and Focused
        then
          Font.Color := FocusFontColor
        else
          if Active
          then Font.Color := ActiveFontColor
          else Font.Color := FontColor;
      end;
    end
  else
    begin
      TB.Width := W;
      TB.Height := H;
      if MouseIn and not Active
      then
        begin
          TB.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          TB.Canvas.FillRect(R);
        end
      else
      if Active and Focused
      then
        begin
          Frame3D(TB.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          TB.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
          TB.Canvas.FillRect(R);
        end
      else
      if Active
      then
        begin
          Frame3D(TB.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          TB.Canvas.Brush.Color := SP_XP_BTNACTIVECOLOR;
          TB.Canvas.FillRect(R);
        end
      else
        begin
          TB.Canvas.Brush.Color := clBtnFace;
          TB.Canvas.FillRect(R);
        end;
      with TB.Canvas do
      begin
        Brush.Style := bsClear;
        Font.Assign(Self.Font);
        if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinData.ResourceStrData.CharSet
      end;
    end;
  //
  if DrawGlyph
  then
    DrawTabGlyphAndText(TB.Canvas, TB.Width, TB.Height, S,
                        Images, TI, True)
  else
    DrawText(TB.Canvas.Handle, PChar(S), Length(S), R, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  if TabPosition = tpLeft
  then
    DrawRotate90_1(Cnvs, TB, Rct.Left, Rct.Top)
  else
  if TabPosition = tpRight
  then
    DrawRotate90_2(Cnvs, TB, Rct.Left, Rct.Top)
  else
    Cnvs.Draw(Rct.Left, Rct.Top, TB);
  TB.Free;
end;

procedure TspSkinTabControl.UpDateTabs;
begin
  if FIndex <> -1
  then
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, RectHeight(TabRect))
      else
        SetItemSize(TabWidth, TabHeight);
    end
  else
    begin
      if TabHeight <= 0
      then
        SetItemSize(TabWidth, FDefaultItemHeight)
      else
        SetItemSize(TabWidth, TabHeight);
    end;
  if MultiLine and (FSkinUpDown <> nil)
  then
    HideSkinUpDown;
  ReAlign;
end;


end.

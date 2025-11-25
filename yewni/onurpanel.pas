unit onurpanel;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Controls, Graphics, Types, ExtCtrls,
  BGRABitmap, BGRABitmapTypes, onurskin;
type
  TRippleInfo = record
      X, Y: Integer;
      Radius: Single;
      MaxRadius: Single;
      Alpha: Byte;
      Active: Boolean;
    end;
  { TONURPanel }
  TONURPanel = class(TONURSkinCustomControl)
  private
    FCaption: string;
    FShowCaption: Boolean;
    FCaptionHeight: Integer;
    FCaptionAlignment: TAlignment;
    FFontColor: TColor;
    FBorderWidth: Integer;
    FBorderColor: TColor;
    FBackgroundColor: TColor;

    procedure SetCaption(AValue: string);
    procedure SetShowCaption(AValue: Boolean);
    procedure SetCaptionHeight(AValue: Integer);
    procedure SetCaptionAlignment(AValue: TAlignment);
    procedure SetFontColor(AValue: TColor);
    procedure SetBorderWidth(AValue: Integer);
    procedure SetBorderColor(AValue: TColor);
    procedure SetBackgroundColor(AValue: TColor);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption: string read FCaption write SetCaption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property SkinManager;
    property SkinElement;

    property ShowCaption: Boolean read FShowCaption write SetShowCaption default False;
    property CaptionHeight: Integer read FCaptionHeight write SetCaptionHeight default 30;
    property CaptionAlignment: TAlignment read FCaptionAlignment write SetCaptionAlignment default taCenter;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 1;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clGray;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clWhite;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TONURCollapsiblePanel }
  TONURCollapsiblePanel = class(TONURSkinCustomControl)
  private
    FCaption: string;
    FCollapsed: Boolean;
    FAnimationDuration: Integer;
    FAutoCollapse: Boolean;
    FHeaderHeight: Integer;
    FExpandedHeight: Integer;
    FAnimatedHeight: Integer;
    FAnimating: Boolean;
    FAnimationTimer: TTimer;
    FAnimationStartTime: QWord;
    FOnExpand: TNotifyEvent;
    FOnCollapse: TNotifyEvent;
    FHeaderRect: TRect;

    procedure AnimationTick(Sender: TObject);
    procedure SetCollapsed(AValue: Boolean);
    procedure SetCaption(AValue: string);
    procedure SetHeaderHeight(AValue: Integer);
    procedure DoExpand;
    procedure DoCollapse;
    procedure CollapseOthers;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Caption: string read FCaption write SetCaption;
    property ChildSizing;
    property Enabled;
    property Font;
    property ParentFont;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Collapsed: Boolean read FCollapsed write SetCollapsed default False;
    property AnimationDuration: Integer read FAnimationDuration write FAnimationDuration default 300;
    property AutoCollapse: Boolean read FAutoCollapse write FAutoCollapse default False;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default 40;

    property OnExpand: TNotifyEvent read FOnExpand write FOnExpand;
    property OnCollapse: TNotifyEvent read FOnCollapse write FOnCollapse;
    property OnClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TONURGroupBox }
  TONURGroupBox = class(TONURSkinCustomControl)
  private
    FCaption: string;
    FCheckable: Boolean;
    FChecked: Boolean;
    FFontColor: TColor;
    FBorderColor: TColor;
    FOnCheckChanged: TNotifyEvent;
    FCheckBoxRect: TRect;

    procedure SetCaption(AValue: string);
    procedure SetCheckable(AValue: Boolean);
    procedure SetChecked(AValue: Boolean);
    procedure SetFontColor(AValue: TColor);
    procedure DoCheckChanged;
    procedure UpdateChildrenEnabled;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption: string read FCaption write SetCaption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Checkable: Boolean read FCheckable write SetCheckable default False;
    property Checked: Boolean read FChecked write SetChecked default True;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property BorderColor: TColor read FBorderColor write FBorderColor default clGray;

    property OnCheckChanged: TNotifyEvent read FOnCheckChanged write FOnCheckChanged;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;
  { TONURCard }
  TONURCard = class(TONURSkinCustomControl)
  private
    FElevation: Integer;
    FHoverElevation: Integer;
    FCornerRadius: Integer;
    FRippleOnClick: Boolean;
    FIsMouseOver: Boolean;
    FAnimatedElevation: Single;
    FRipples: array of TRippleInfo;
    FRippleTimer: TTimer;

    procedure AnimationTick(Sender: TObject);
    procedure SetElevation(AValue: Integer);
    procedure SetHoverElevation(AValue: Integer);
    procedure SetCornerRadius(AValue: Integer);
    procedure StartRipple(X, Y: Integer);
    procedure UpdateRipples;
    procedure OnRippleTimer(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Caption;
    property ChildSizing;
    property Enabled;
    property Font;
    property ParentFont;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Elevation: Integer read FElevation write SetElevation default 2;
    property HoverElevation: Integer read FHoverElevation write SetHoverElevation default 8;
    property CornerRadius: Integer read FCornerRadius write SetCornerRadius default 8;
    property RippleOnClick: Boolean read FRippleOnClick write FRippleOnClick default True;

    property OnClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
  end;
procedure Register;
implementation
uses Math;
procedure Register;
begin
  RegisterComponents('ONUR Panel', [
    TONURPanel,
    TONURGroupBox,
    TONURCollapsiblePanel,
    TONURCard
  ]);
end;
{ TONURPanel }
constructor TONURPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 150;

  FCaption := 'Panel';
  FShowCaption := False;
  FCaptionHeight := 30;
  FCaptionAlignment := taCenter;
  FFontColor := clBlack;
  FBorderWidth := 1;
  FBorderColor := clGray;
  FBackgroundColor := clWhite;

  SkinElement := 'Panel';
end;
destructor TONURPanel.Destroy;
begin
  inherited Destroy;
end;
procedure TONURPanel.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURPanel.SetShowCaption(AValue: Boolean);
begin
  if FShowCaption = AValue then Exit;
  FShowCaption := AValue;
  Invalidate;
end;
procedure TONURPanel.SetCaptionHeight(AValue: Integer);
begin
  if FCaptionHeight = AValue then Exit;
  FCaptionHeight := AValue;
  Invalidate;
end;
procedure TONURPanel.SetCaptionAlignment(AValue: TAlignment);
begin
  if FCaptionAlignment = AValue then Exit;
  FCaptionAlignment := AValue;
  Invalidate;
end;
procedure TONURPanel.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURPanel.SetBorderWidth(AValue: Integer);
begin
  if FBorderWidth = AValue then Exit;
  FBorderWidth := AValue;
  Invalidate;
end;
procedure TONURPanel.SetBorderColor(AValue: TColor);
begin
  if FBorderColor = AValue then Exit;
  FBorderColor := AValue;
  Invalidate;
end;
procedure TONURPanel.SetBackgroundColor(AValue: TColor);
begin
  if FBackgroundColor = AValue then Exit;
  FBackgroundColor := AValue;
  Invalidate;
end;
procedure TONURPanel.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: Boolean;
  CaptionRect, BodyRect: TRect;
  TextSize: TSize;
  TextX, TextY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Arka plan çiz
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Fallback: Düz renk arka plan
      Bmp.Fill(ColorToBGRA(FBackgroundColor));

      // Kenarlık
      if FBorderWidth > 0 then
      begin
        Bmp.Rectangle(ClientRect, ColorToBGRA(FBorderColor), dmSet);
        if FBorderWidth > 1 then
        begin
          Bmp.Rectangle(Rect(1, 1, ClientWidth - 1, ClientHeight - 1),
                       ColorToBGRA(FBorderColor), dmSet);
        end;
      end;
    end;

    // Caption çiz
    if FShowCaption and (FCaption <> '') then
    begin
      CaptionRect := Rect(0, 0, ClientWidth, FCaptionHeight);

      // Caption arka planı
      DrawSuccess := DrawPart('Caption', Bmp, CaptionRect, 255);
      if not DrawSuccess then
      begin
        Bmp.FillRect(CaptionRect, BGRA(240, 240, 240, 255), dmSet);
        Bmp.DrawLineAntialias(0, FCaptionHeight, ClientWidth, FCaptionHeight,
                             ColorToBGRA(FBorderColor), 1);
      end;

      // Caption yazısı
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontStyle := Font.Style;
      Bmp.FontAntialias := True;

      TextSize := Bmp.TextSize(FCaption);
      TextY := (FCaptionHeight - TextSize.cy) div 2;

      case FCaptionAlignment of
        taLeftJustify: TextX := 10;
        taCenter: TextX := (ClientWidth - TextSize.cx) div 2;
        taRightJustify: TextX := ClientWidth - TextSize.cx - 10;
      end;

      Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
{ TONURGroupBox }
constructor TONURGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 150;

  FCaption := 'GroupBox';
  FCheckable := False;
  FChecked := True;
  FFontColor := clBlack;
  FBorderColor := clGray;

  SkinElement := 'GroupBox';
end;
destructor TONURGroupBox.Destroy;
begin
  inherited Destroy;
end;
procedure TONURGroupBox.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURGroupBox.SetCheckable(AValue: Boolean);
begin
  if FCheckable = AValue then Exit;
  FCheckable := AValue;
  Invalidate;
end;
procedure TONURGroupBox.SetChecked(AValue: Boolean);
begin
  if FChecked = AValue then Exit;
  FChecked := AValue;
  UpdateChildrenEnabled;
  DoCheckChanged;
  Invalidate;
end;
procedure TONURGroupBox.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURGroupBox.DoCheckChanged;
begin
  if Assigned(FOnCheckChanged) then
    FOnCheckChanged(Self);
end;
procedure TONURGroupBox.UpdateChildrenEnabled;
var
  I: Integer;
begin
  if not FCheckable then Exit;

  for I := 0 to ControlCount - 1 do
    Controls[I].Enabled := FChecked;
end;
procedure TONURGroupBox.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: Boolean;
  TextSize: TSize;
  TextX, TextY, TextWidth: Integer;
  CheckSize: Integer;
  CenterX, CenterY, Radius: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);
    CheckSize := 16;

    // Checkbox varsa yer hesapla
    if FCheckable then
    begin
      FCheckBoxRect := Rect(10, 2, 10 + CheckSize, 2 + CheckSize);
      TextX := 10 + CheckSize + 6;
    end
    else
    begin
      TextX := 10;
      FCheckBoxRect := Rect(0, 0, 0, 0);
    end;

    TextY := 2;
    TextWidth := TextSize.cx;

    // Kenarlık çiz (caption kısmı kesik)
    DrawSuccess := DrawPart('Border', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Üst kenarlık (caption'dan önce)
      Bmp.DrawLineAntialias(0, 10, TextX - 4, 10, ColorToBGRA(FBorderColor), 1);

      // Üst kenarlık (caption'dan sonra)
      Bmp.DrawLineAntialias(TextX + TextWidth + 4, 10, ClientWidth, 10,
                           ColorToBGRA(FBorderColor), 1);

      // Diğer kenarlıklar
      Bmp.DrawLineAntialias(0, 10, 0, ClientHeight, ColorToBGRA(FBorderColor), 1);
      Bmp.DrawLineAntialias(ClientWidth - 1, 10, ClientWidth - 1, ClientHeight,
                           ColorToBGRA(FBorderColor), 1);
      Bmp.DrawLineAntialias(0, ClientHeight - 1, ClientWidth, ClientHeight - 1,
                           ColorToBGRA(FBorderColor), 1);
    end;

    // Checkbox çiz
    if FCheckable then
    begin
      if FChecked then
        DrawSuccess := DrawPart('CheckBox_Checked', Bmp, FCheckBoxRect, 255)
      else
        DrawSuccess := DrawPart('CheckBox_Unchecked', Bmp, FCheckBoxRect, 255);

      if not DrawSuccess then
      begin
        // Fallback checkbox
        CenterX := (FCheckBoxRect.Left + FCheckBoxRect.Right) div 2;
        CenterY := (FCheckBoxRect.Top + FCheckBoxRect.Bottom) div 2;
        Radius := CheckSize div 2;

        Bmp.EllipseAntialias(CenterX, CenterY, Radius, Radius,
                            ColorToBGRA(FBorderColor), 1);

        if FChecked then
          Bmp.FillEllipseAntialias(CenterX, CenterY, Radius - 3, Radius - 3,
                                   BGRA(76, 175, 80, 255));
      end;
    end;

    // Caption yazısı
    Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURGroupBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if FCheckable and (Button = mbLeft) then
  begin
    // Checkbox tıklandı mı?
    if (X >= FCheckBoxRect.Left) and (X < FCheckBoxRect.Right) and
       (Y >= FCheckBoxRect.Top) and (Y < FCheckBoxRect.Bottom) then
    begin
      Checked := not Checked;
    end;
  end;
end;

{ TONURCollapsiblePanel }
constructor TONURCollapsiblePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 300;
  Height := 200;

  FCaption := 'Collapsible Panel';
  FCollapsed := False;
  FAnimationDuration := 300;
  FAutoCollapse := False;
  FHeaderHeight := 40;
  FExpandedHeight := Height;
  FAnimatedHeight := Height;
  FAnimating := False;

  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Interval := 16; // ~60 FPS
  FAnimationTimer.Enabled := False;
  FAnimationTimer.OnTimer := @AnimationTick;

  SkinElement := 'CollapsiblePanel';
end;
destructor TONURCollapsiblePanel.Destroy;
begin
  FAnimationTimer.Free;
  inherited Destroy;
end;
procedure TONURCollapsiblePanel.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURCollapsiblePanel.SetHeaderHeight(AValue: Integer);
begin
  if FHeaderHeight = AValue then Exit;
  FHeaderHeight := AValue;
  Invalidate;
end;
procedure TONURCollapsiblePanel.SetCollapsed(AValue: Boolean);
begin
  if FCollapsed = AValue then Exit;
  FCollapsed := AValue;

  if not (csLoading in ComponentState) then
  begin
    if FAutoCollapse and not FCollapsed then
      CollapseOthers;

    // Animasyon başlat
    FAnimationStartTime := GetTickCount64;
    FAnimating := True;
    FAnimationTimer.Enabled := True;

    if FCollapsed then
      DoCollapse
    else
      DoExpand;
  end;

  Invalidate;
end;
procedure TONURCollapsiblePanel.DoExpand;
begin
  if Assigned(FOnExpand) then
    FOnExpand(Self);
end;
procedure TONURCollapsiblePanel.DoCollapse;
begin
  if Assigned(FOnCollapse) then
    FOnCollapse(Self);
end;
procedure TONURCollapsiblePanel.CollapseOthers;
var
  I: Integer;
  Sibling: TControl;
begin
  if Parent = nil then Exit;

  for I := 0 to Parent.ControlCount - 1 do
  begin
    Sibling := Parent.Controls[I];
    if (Sibling <> Self) and (Sibling is TONURCollapsiblePanel) then
      TONURCollapsiblePanel(Sibling).Collapsed := True;
  end;
end;
procedure TONURCollapsiblePanel.AnimationTick(Sender: TObject);
var
  Elapsed: QWord;
  Progress: Single;
  TargetHeight: Integer;
begin
  Elapsed := GetTickCount64 - FAnimationStartTime;
  Progress := Elapsed / FAnimationDuration;

  if Progress >= 1.0 then
  begin
    Progress := 1.0;
    FAnimating := False;
    FAnimationTimer.Enabled := False;
  end;

  // Easing: EaseInOut
  if Progress < 0.5 then
    Progress := 2 * Progress * Progress
  else
    Progress := 1 - Power(-2 * Progress + 2, 2) / 2;

  if FCollapsed then
    TargetHeight := FHeaderHeight
  else
    TargetHeight := FExpandedHeight;

  FAnimatedHeight := Round(FHeaderHeight + (TargetHeight - FHeaderHeight) * Progress);
  Height := FAnimatedHeight;

  Invalidate;
end;
procedure TONURCollapsiblePanel.Resize;
begin
  inherited Resize;
  if not FAnimating and not FCollapsed then
    FExpandedHeight := Height;
end;
procedure TONURCollapsiblePanel.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: Boolean;
  HeaderPartName: string;
  TextSize: TSize;
  TextX, TextY: Integer;
  IconX, IconY, IconSize: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    FHeaderRect := Rect(0, 0, ClientWidth, FHeaderHeight);

    // Header çiz
    if FCollapsed then
      HeaderPartName := 'Header_Collapsed'
    else
      HeaderPartName := 'Header_Expanded';

    DrawSuccess := DrawPart(HeaderPartName, Bmp, FHeaderRect, 255);

    if not DrawSuccess then
    begin
      // Fallback header
      if FCollapsed then
        Bmp.FillRect(FHeaderRect, BGRA(240, 240, 240, 255), dmSet)
      else
        Bmp.FillRect(FHeaderRect, BGRA(230, 230, 230, 255), dmSet);

      Bmp.DrawLineAntialias(0, FHeaderHeight, ClientWidth, FHeaderHeight,
                           BGRA(200, 200, 200, 255), 1);
    end;

    // İkon çiz (▼ veya ▶)
    IconSize := 12;
    IconX := 10;
    IconY := (FHeaderHeight - IconSize) div 2;

    DrawSuccess := False;
    if FCollapsed then
      DrawSuccess := DrawPart('Icon_Collapsed', Bmp, Rect(IconX, IconY, IconX + IconSize, IconY + IconSize), 255)
    else
      DrawSuccess := DrawPart('Icon_Expanded', Bmp, Rect(IconX, IconY, IconX + IconSize, IconY + IconSize), 255);

    if not DrawSuccess then
    begin
      // Fallback ikon
      if FCollapsed then
      begin
        // ▶ (sağ ok)
        Bmp.DrawLineAntialias(IconX, IconY, IconX + IconSize, IconY + IconSize div 2,
                             BGRA(64, 64, 64, 255), 2);
        Bmp.DrawLineAntialias(IconX + IconSize, IconY + IconSize div 2, IconX, IconY + IconSize,
                             BGRA(64, 64, 64, 255), 2);
      end
      else
      begin
        // ▼ (aşağı ok)
        Bmp.DrawLineAntialias(IconX, IconY, IconX + IconSize, IconY,
                             BGRA(64, 64, 64, 255), 2);
        Bmp.DrawLineAntialias(IconX + IconSize div 2, IconY + IconSize, IconX, IconY,
                             BGRA(64, 64, 64, 255), 2);
        Bmp.DrawLineAntialias(IconX + IconSize div 2, IconY + IconSize, IconX + IconSize, IconY,
                             BGRA(64, 64, 64, 255), 2);
      end;
    end;

    // Caption
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);
    TextX := IconX + IconSize + 8;
    TextY := (FHeaderHeight - TextSize.cy) div 2;

    Bmp.TextOut(TextX, TextY, FCaption, BGRA(64, 64, 64, 255));

    // Body (expanded ise)
    if not FCollapsed then
    begin
      DrawSuccess := DrawPart('Body', Bmp, Rect(0, FHeaderHeight, ClientWidth, ClientHeight), 255);

      if not DrawSuccess then
      begin
        Bmp.FillRect(Rect(0, FHeaderHeight, ClientWidth, ClientHeight),
                    BGRA(255, 255, 255, 255), dmSet);
        Bmp.Rectangle(ClientRect, BGRA(200, 200, 200, 255), dmSet);
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURCollapsiblePanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    // Header tıklandı mı?
    if (Y >= FHeaderRect.Top) and (Y < FHeaderRect.Bottom) then
      Collapsed := not Collapsed;
  end;
end;

{ TONURCard }
constructor TONURCard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 250;
  Height := 150;

  FElevation := 2;
  FHoverElevation := 8;
  FCornerRadius := 8;
  FRippleOnClick := True;
  FIsMouseOver := False;
  FAnimatedElevation := FElevation;

  SetLength(FRipples, 0);

  FRippleTimer := TTimer.Create(Self);
  FRippleTimer.Interval := 16; // ~60 FPS
  FRippleTimer.Enabled := False;
  FRippleTimer.OnTimer := @OnRippleTimer;

  SkinElement := 'Card';
end;
destructor TONURCard.Destroy;
begin
  FRippleTimer.Free;
  inherited Destroy;
end;
procedure TONURCard.SetElevation(AValue: Integer);
begin
  if FElevation = AValue then Exit;
  FElevation := AValue;
  if not FIsMouseOver then
    FAnimatedElevation := FElevation;
  Invalidate;
end;
procedure TONURCard.SetHoverElevation(AValue: Integer);
begin
  if FHoverElevation = AValue then Exit;
  FHoverElevation := AValue;
end;
procedure TONURCard.SetCornerRadius(AValue: Integer);
begin
  if FCornerRadius = AValue then Exit;
  FCornerRadius := AValue;
  Invalidate;
end;
procedure TONURCard.StartRipple(X, Y: Integer);
var
  Idx: Integer;
  MaxDist: Single;
begin
  Idx := Length(FRipples);
  SetLength(FRipples, Idx + 1);

  FRipples[Idx].X := X;
  FRipples[Idx].Y := Y;
  FRipples[Idx].Radius := 0;

  MaxDist := Sqrt(Sqr(Max(X, ClientWidth - X)) + Sqr(Max(Y, ClientHeight - Y)));
  FRipples[Idx].MaxRadius := MaxDist;
  FRipples[Idx].Alpha := 64;
  FRipples[Idx].Active := True;

  FRippleTimer.Enabled := True;
end;
procedure TONURCard.UpdateRipples;
var
  I: Integer;
  Speed: Single;
  HasActive: Boolean;
begin
  HasActive := False;

  for I := 0 to High(FRipples) do
  begin
    if FRipples[I].Active then
    begin
      Speed := FRipples[I].MaxRadius / (600 / 16);
      FRipples[I].Radius := FRipples[I].Radius + Speed;
      FRipples[I].Alpha := Round(64 * (1.0 - (FRipples[I].Radius / FRipples[I].MaxRadius)));

      if FRipples[I].Radius >= FRipples[I].MaxRadius then
        FRipples[I].Active := False
      else
        HasActive := True;
    end;
  end;

  if not HasActive then
  begin
    FRippleTimer.Enabled := False;
    SetLength(FRipples, 0);
  end;

  Invalidate;
end;
procedure TONURCard.OnRippleTimer(Sender: TObject);
begin
  UpdateRipples;
end;
procedure TONURCard.AnimationTick(Sender: TObject);
var
  Progress: Single;
  TargetElevation: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;

    if FIsMouseOver then
      TargetElevation := FHoverElevation
    else
      TargetElevation := FElevation;

    FAnimatedElevation := FAnimatedElevation + (TargetElevation - FAnimatedElevation) * Progress;
    Invalidate;
  end;
end;
procedure TONURCard.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: Boolean;
  ShadowOffset, ShadowBlur: Integer;
  I: Integer;
  RipplColor: TBGRAPixel;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Gölge hesapla
    ShadowOffset := Round(FAnimatedElevation / 2);
    ShadowBlur := Round(FAnimatedElevation * 2);

    if FIsMouseOver then
      DrawSuccess := DrawPart('Hover', Bmp, ClientRect, 255)
    else
      DrawSuccess := DrawPart('Normal', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Gölge çiz
      Bmp.FillRoundRectAntialias(ShadowOffset, ShadowOffset,
                                  ClientWidth - ShadowOffset, ClientHeight - ShadowOffset,
                                  FCornerRadius, FCornerRadius,
                                  BGRA(0, 0, 0, 32));

      // Kart arka planı
      Bmp.FillRoundRectAntialias(0, 0, ClientWidth - ShadowOffset * 2, ClientHeight - ShadowOffset * 2,
                                  FCornerRadius, FCornerRadius,
                                  BGRA(255, 255, 255, 255));

      // Kenarlık
      Bmp.RoundRectAntialias(0, 0, ClientWidth - ShadowOffset * 2, ClientHeight - ShadowOffset * 2,
                            FCornerRadius, FCornerRadius,
                            BGRA(224, 224, 224, 255), 1);
    end;

    // Ripple efektleri
    if FRippleOnClick then
    begin
      for I := 0 to High(FRipples) do
      begin
        if FRipples[I].Active then
        begin
          RipplColor := BGRA(128, 128, 128, FRipples[I].Alpha);
          Bmp.FillEllipseAntialias(FRipples[I].X, FRipples[I].Y,
                                   FRipples[I].Radius, FRipples[I].Radius,
                                   RipplColor);
        end;
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURCard.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  StartAnimation(oatScale, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURCard.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  StartAnimation(oatScale, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURCard.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if FRippleOnClick and (Button = mbLeft) then
    StartRipple(X, Y);
end;
end.

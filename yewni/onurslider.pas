unit onurslider;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Controls, Graphics, Types, ExtCtrls, Math,
  BGRABitmap, BGRABitmapTypes, onurskin;

type
  TONUROrientation = (orHorizontal, orVertical);
  TONURProgressStyle = (psNormal, psMarquee);
  TONURAutoHide = (oahNever, oahOnMouseLeave, oahAlways);
  TONURTickStyle = (tsNone, tsBoth, tsTopLeft, tsBottomRight);


  { TONURProgressBar }
  TONURProgressBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FPosition: integer;
    FOrientation: TONUROrientation;
    FStyle: TONURProgressStyle;
    FShowText: boolean;
    FTextFormat: string;
    FSmooth: boolean;
    FAnimatedPosition: single;
    FMarqueePosition: single;
    FMarqueeTimer: TTimer;
    FBarWidth: integer;
    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetPosition(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure SetStyle(AValue: TONURProgressStyle);
    procedure SetShowText(AValue: boolean);
    procedure AnimationTick(Sender: TObject);
    procedure OnMarqueeTimer(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property BarWidth: integer read FBarWidth write FBarWidth default 50;
    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Position: integer read FPosition write SetPosition default 0;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orHorizontal;
    property Style: TONURProgressStyle read FStyle write SetStyle default psNormal;
    property ShowText: boolean read FShowText write SetShowText default True;
    property TextFormat: string read FTextFormat write FTextFormat;
    property Smooth: boolean read FSmooth write FSmooth default True;
  end;
  { TONURLoadingBar }
  TONURLoadingBar = class(TONURSkinGraphicControl)
  private
    FActive: boolean;
    FSpeed: integer;
    FBarWidth: integer;
    FOrientation: TONUROrientation;
    FPosition: single;
    FTimer: TTimer;

    procedure SetActive(AValue: boolean);
    procedure SetSpeed(AValue: integer);
    procedure OnTimer(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Active: boolean read FActive write SetActive default False;
    property Speed: integer read FSpeed write SetSpeed default 100;
    property BarWidth: integer read FBarWidth write FBarWidth default 50;
    property Orientation: TONUROrientation read FOrientation
      write FOrientation default orHorizontal;
  end;
  { TONURScrollBar }
  TONURScrollBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FPosition: integer;
    FPageSize: integer;
    FSmallChange: integer;
    FLargeChange: integer;
    FOrientation: TONUROrientation;
    FAutoHide: TONURAutoHide;
    FShowButtons: boolean;
    FMinThumbSize: integer;

    // Animasyon
    FAnimatedAlpha: byte;
    FAnimatedPosition: single;
    FFadeTimer: TTimer;
    FScrollTimer: TTimer;
    FTargetPosition: integer;
    FTargetAlpha: byte;

    // Mouse tracking
    FIsDragging: boolean;
    FDragStartPos: integer;
    FDragStartValue: integer;
    OldPart, FMouseOverPart: (mpNone, mpLeftBtn, mpRightBtn, mpThumb, mpTrack);
    FPressedPart: (ppNone, ppLeftBtn, ppRightBtn, ppThumb, ppTrack);
    FIsMouseOver: boolean;

    // Rects
    FLeftBtnRect, FRightBtnRect, FThumbRect, FTrackRect: TRect;

    FOnChange: TNotifyEvent;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetPosition(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure UpdateRects;
    function GetThumbSize: integer;
    function PosFromValue(AValue: integer): integer;
    function ValueFromPos(APos: integer): integer;
    procedure OnFadeTimer(Sender: TObject);
    procedure OnScrollTimer(Sender: TObject);
    procedure SmoothScrollTo(ATarget: integer);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: integer;
      MousePos: TPoint): boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Position: integer read FPosition write SetPosition default 0;
    property PageSize: integer read FPageSize write FPageSize default 10;
    property SmallChange: integer read FSmallChange write FSmallChange default 1;
    property LargeChange: integer read FLargeChange write FLargeChange default 10;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orHorizontal;
    property AutoHide: TONURAutoHide read FAutoHide write FAutoHide default oahNever;
    property ShowButtons: boolean read FShowButtons write FShowButtons default True;
    property MinThumbSize: integer read FMinThumbSize write FMinThumbSize default 20;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseWheel;
  end;

  { TONURSliderBar }
  TONURSliderBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FOrientation: TONUROrientation;
    FThumbSize: integer;
    FAnimatedValue: single;
    FIsDragging: boolean;
    FThumbRect: TRect;
    FTrackRect: TRect;
    FOnChange: TNotifyEvent;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetValue(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure UpdateRects;
    function ValueFromPos(X, Y: integer): integer;
    procedure AnimationTick(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orHorizontal;
    property ThumbSize: integer read FThumbSize write FThumbSize default 20;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TONURTrackBar }
  TONURTrackBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FPosition: integer;
    FOrientation: TONUROrientation;
    FTickFrequency: integer;
    FTickStyle: TONURTickStyle;
    FShowValueHint: boolean;
    FSnapToTick: boolean;
    FThumbSize: integer;
    FAnimatedPosition: single;
    FIsDragging: boolean;
    FThumbRect: TRect;
    FTrackRect: TRect;
    FOnChange: TNotifyEvent;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetPosition(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure UpdateRects;
    function ValueFromPos(X, Y: integer): integer;
    function SnapValue(AValue: integer): integer;
    procedure AnimationTick(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Position: integer read FPosition write SetPosition default 0;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orHorizontal;
    property TickFrequency: integer read FTickFrequency write FTickFrequency default 10;
    property TickStyle: TONURTickStyle read FTickStyle write FTickStyle default tsBoth;
    property ShowValueHint: boolean
      read FShowValueHint write FShowValueHint default True;
    property SnapToTick: boolean read FSnapToTick write FSnapToTick default False;
    property ThumbSize: integer read FThumbSize write FThumbSize default 20;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TONURRangeBar }
  TONURRangeBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FLowValue, FHighValue: integer;
    FOrientation: TONUROrientation;
    FShowValues: boolean;
    FThumbSize: integer;
    FDraggingThumb: (dtNone, dtLow, dtHigh);
    FLowThumbRect, FHighThumbRect: TRect;
    FTrackRect, FRangeRect: TRect;
    FOnChange: TNotifyEvent;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetLowValue(AValue: integer);
    procedure SetHighValue(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure UpdateRects;
    function ValueFromPos(X, Y: integer): integer;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property LowValue: integer read FLowValue write SetLowValue default 25;
    property HighValue: integer read FHighValue write SetHighValue default 75;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orHorizontal;
    property ShowValues: boolean read FShowValues write FShowValues default True;
    property ThumbSize: integer read FThumbSize write FThumbSize default 20;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TONURSwitchBar }
  TONURSwitchBar = class(TONURSkinGraphicControl)
  private
    FValue: boolean;
    FOnText, FOffText: string;
    FAnimationDuration: integer;
    FAnimatedPosition: single;
    FThumbRect, FTrackRect: TRect;
    FOnChange: TNotifyEvent;

    procedure SetValue(AValue: boolean);
    procedure SetOnText(AValue: string);
    procedure SetOffText(AValue: string);
    procedure UpdateRects;
    procedure AnimationTick(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Value: boolean read FValue write SetValue default False;
    property OnText: string read FOnText write SetOnText;
    property OffText: string read FOffText write SetOffText;
    property AnimationDuration: integer read FAnimationDuration
      write FAnimationDuration default 200;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
  end;

  { TONURMeterBar }
  TONURMeterBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FPeakValue: integer;
    FPeakHoldTime: integer;
    FSegments: integer;
    FOrientation: TONUROrientation;
    FPeakTimer: TTimer;
    FPeakStartTime: QWord;
    FAnimatedValue: single;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetValue(AValue: integer);
    procedure SetOrientation(AValue: TONUROrientation);
    procedure OnPeakTimer(Sender: TObject);
    procedure AnimationTick(Sender: TObject);
    function GetSegmentColor(Index: integer): TBGRAPixel;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property PeakValue: integer read FPeakValue write FPeakValue default 0;
    property PeakHoldTime: integer read FPeakHoldTime write FPeakHoldTime default 1000;
    property Segments: integer read FSegments write FSegments default 20;
    property Orientation: TONUROrientation read FOrientation
      write SetOrientation default orVertical;
  end;

  { TONURTimeBar }
  TONURTimeBar = class(TONURSkinGraphicControl)
  private
    FDuration: integer;  // Saniye
    FPosition: integer;  // Saniye
    FBufferPosition: integer;  // Saniye
    FShowTime: boolean;
    FAllowSeek: boolean;
    FIsSeeking: boolean;
    FOnSeek: TNotifyEvent;

    procedure SetDuration(AValue: integer);
    procedure SetPosition(AValue: integer);
    procedure SetBufferPosition(AValue: integer);
    function FormatTime(Seconds: integer): string;
    function ValueFromPos(X: integer): integer;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Duration: integer read FDuration write SetDuration default 0;
    property Position: integer read FPosition write SetPosition default 0;
    property BufferPosition: integer
      read FBufferPosition write SetBufferPosition default 0;
    property ShowTime: boolean read FShowTime write FShowTime default True;
    property AllowSeek: boolean read FAllowSeek write FAllowSeek default True;

    property OnSeek: TNotifyEvent read FOnSeek write FOnSeek;
    property OnClick;
  end;

  { TONURGaugeBar }
  TONURGaugeBar = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FStartAngle: integer;  // Derece (0-360)
    FEndAngle: integer;
    FShowNeedle: boolean;
    FShowTicks: boolean;
    FTickCount: integer;
    FAnimatedValue: single;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetValue(AValue: integer);
    procedure AnimationTick(Sender: TObject);
    function ValueToAngle(AValue: single): single;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 0;
    property StartAngle: integer read FStartAngle write FStartAngle default 135;
    property EndAngle: integer read FEndAngle write FEndAngle default 45;
    property ShowNeedle: boolean read FShowNeedle write FShowNeedle default True;
    property ShowTicks: boolean read FShowTicks write FShowTicks default True;
    property TickCount: integer read FTickCount write FTickCount default 10;
  end;

  { TONURKnob }
  TONURKnob = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FValue: integer;
    FSensitivity: single;
    FShowValue: boolean;
    FDiameter: integer;
    FIsDragging: boolean;
    FDragStartY: integer;
    FDragStartValue: integer;
    FAnimatedAngle: single;
    FOnChange: TNotifyEvent;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetValue(AValue: integer);
    procedure SetDiameter(AValue: integer);
    procedure AnimationTick(Sender: TObject);
    function ValueToAngle(AValue: single): single;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Value: integer read FValue write SetValue default 50;
    property Sensitivity: single read FSensitivity write FSensitivity;
    property ShowValue: boolean read FShowValue write FShowValue default True;
    property Diameter: integer read FDiameter write SetDiameter default 60;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;


  { TONURProgressRing }
  TONURProgressRing = class(TONURSkinGraphicControl)
  private
    FMin, FMax: integer;
    FPosition: integer;
    FDiameter: integer;
    FLineWidth: integer;
    FShowText: boolean;
    FStartAngle: integer;
    FAnimatedPosition: single;

    procedure SetMin(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetPosition(AValue: integer);
    procedure SetDiameter(AValue: integer);
    procedure AnimationTick(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Min: integer read FMin write SetMin default 0;
    property Max: integer read FMax write SetMax default 100;
    property Position: integer read FPosition write SetPosition default 0;
    property Diameter: integer read FDiameter write SetDiameter default 100;
    property LineWidth: integer read FLineWidth write FLineWidth default 10;
    property ShowText: boolean read FShowText write FShowText default True;
    property StartAngle: integer read FStartAngle write FStartAngle default -90;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ONUR Sliders', [TONURProgressBar, TONURScrollBar,
    TONURTrackBar, TONURRangeBar, TONURGaugeBar, TONURKnob,
    TONURSliderBar, TONURSwitchBar, TONURTimeBar, TONURLoadingBar,
    TONURProgressRing, TONURMeterBar]);
end;



{ TONURProgressBar }
constructor TONURProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 20;

  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FOrientation := orHorizontal;
  FStyle := psNormal;
  FShowText := True;
  FTextFormat := '%d%%';
  FSmooth := True;
  FAnimatedPosition := 0;
  FMarqueePosition := 0;

  FMarqueeTimer := TTimer.Create(Self);
  FMarqueeTimer.Interval := 16; // ~60 FPS
  FMarqueeTimer.Enabled := False;
  FMarqueeTimer.OnTimer := @OnMarqueeTimer;


  // Animasyon timer'ı
  with TTimer.Create(Self) do
  begin
    Interval := 16; // ~60 FPS
    OnTimer := @AnimationTick;
    Enabled := True;
  end;

  SkinElement := 'ProgressBar';
end;

destructor TONURProgressBar.Destroy;
begin
  FMarqueeTimer.Free;
  inherited Destroy;
end;

procedure TONURProgressBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetPosition(FPosition);
  Invalidate;
end;

procedure TONURProgressBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetPosition(FPosition);
  Invalidate;
end;

procedure TONURProgressBar.SetPosition(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FPosition = AValue then Exit;
  FPosition := AValue;

  if FSmooth then
    StartAnimation(oatFade, 200, oaeEaseOut);

  Invalidate;
end;

procedure TONURProgressBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  Invalidate;
end;

procedure TONURProgressBar.SetStyle(AValue: TONURProgressStyle);
begin
  if FStyle = AValue then Exit;
  FStyle := AValue;

  if FStyle = psMarquee then
    FMarqueeTimer.Enabled := True
  else
    FMarqueeTimer.Enabled := False;

  Invalidate;
end;

procedure TONURProgressBar.SetShowText(AValue: boolean);
begin
  if FShowText = AValue then Exit;
  FShowText := AValue;
  Invalidate;
end;

procedure TONURProgressBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetPos: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetPos := (FPosition - FMin) / (FMax - FMin);
    FAnimatedPosition := FAnimatedPosition + (TargetPos - FAnimatedPosition) * Progress;
    Invalidate;
  end;
end;

procedure TONURProgressBar.OnMarqueeTimer(Sender: TObject);
begin
  FMarqueePosition := FMarqueePosition + 0.02;
  if FMarqueePosition > 1.0 then
    FMarqueePosition := -0.2;
  Invalidate;
end;

procedure TONURProgressBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  FillRect: TRect;
  FillWidth, FillHeight: integer;
  Percent: integer;
  //  Text: string;
  TextSize: TSize;
  TextX, TextY: integer;
  MarqueeX, MarqueeY, MarqueeW, MarqueeH: integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Arka plan
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      Bmp.Fill(BGRA(240, 240, 240, 255));
      Bmp.Rectangle(ClientRect, BGRA(200, 200, 200, 255), dmSet);
    end;

    // Fill
    if FStyle = psNormal then
    begin
      if FOrientation = orHorizontal then
      begin
        FillWidth := Round(ClientWidth * FAnimatedPosition);
        FillRect := Rect(0, 0, FillWidth, ClientHeight);
      end
      else
      begin
        FillHeight := Round(ClientHeight * FAnimatedPosition);
        FillRect := Rect(0, ClientHeight - FillHeight, ClientWidth, ClientHeight);
      end;

      DrawSuccess := DrawPart('Fill', Bmp, FillRect, 255);

      if not DrawSuccess then
        Bmp.FillRect(FillRect, BGRA(76, 175, 80, 255), dmSet);
    end
    else // psMarquee
    begin
      if FOrientation = orHorizontal then
      begin
        MarqueeW := FBarWidth;
        MarqueeX := Round((ClientWidth + MarqueeW) * FMarqueePosition) - MarqueeW;
        FillRect := Rect(MarqueeX, 0, MarqueeX + MarqueeW, ClientHeight);
      end
      else
      begin
        MarqueeH := FBarWidth;
        MarqueeY := Round((ClientHeight + MarqueeH) * FMarqueePosition) - MarqueeH;
        FillRect := Rect(0, MarqueeY, ClientWidth, MarqueeY + MarqueeH);
      end;

      DrawSuccess := DrawPart('Marquee', Bmp, FillRect, 255);

      if not DrawSuccess then
        Bmp.FillRect(FillRect, BGRA(33, 150, 243, 255), dmSet);
    end;

    // Text
    if FShowText and (FStyle = psNormal) then
    begin
      Percent := Round((FPosition - FMin) / (FMax - FMin) * 100);
      Text := Format(FTextFormat, [Percent]);

      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontStyle := Font.Style;
      Bmp.FontAntialias := True;

      TextSize := Bmp.TextSize(Text);
      TextX := (ClientWidth - TextSize.cx) div 2;
      TextY := (ClientHeight - TextSize.cy) div 2;

      Bmp.TextOut(TextX, TextY, Text, BGRA(64, 64, 64, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
{ TONURLoadingBar }
constructor TONURLoadingBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 4;

  FActive := False;
  FSpeed := 100;
  FBarWidth := 50;
  FOrientation := orHorizontal;
  FPosition := 0;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 16; // ~60 FPS
  FTimer.Enabled := False;
  FTimer.OnTimer := @OnTimer;

  SkinElement := 'LoadingBar';
end;

destructor TONURLoadingBar.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

procedure TONURLoadingBar.SetActive(AValue: boolean);
begin
  if FActive = AValue then Exit;
  FActive := AValue;
  FTimer.Enabled := FActive;
  Invalidate;
end;

procedure TONURLoadingBar.SetSpeed(AValue: integer);
begin
  if FSpeed = AValue then Exit;
  FSpeed := AValue;
end;

procedure TONURLoadingBar.OnTimer(Sender: TObject);
begin
  FPosition := FPosition + (FSpeed / 1000);
  if FPosition > 1.2 then
    FPosition := -0.2;
  Invalidate;
end;

procedure TONURLoadingBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  BarRect: TRect;
  BarX, BarY: integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Arka plan
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);

    if not DrawSuccess then
      Bmp.Fill(BGRA(240, 240, 240, 255));

    // Loading bar
    if FActive then
    begin
      if FOrientation = orHorizontal then
      begin
        BarX := Round((ClientWidth + FBarWidth) * FPosition) - FBarWidth;
        BarRect := Rect(BarX, 0, BarX + FBarWidth, ClientHeight);
      end
      else
      begin
        BarY := Round((ClientHeight + FBarWidth) * FPosition) - FBarWidth;
        BarRect := Rect(0, BarY, ClientWidth, BarY + FBarWidth);
      end;

      DrawSuccess := DrawPart('Bar', Bmp, BarRect, 255);

      if not DrawSuccess then
        Bmp.FillRect(BarRect, BGRA(33, 150, 243, 255), dmSet);
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
{ TONURScrollBar }
constructor TONURScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 20;

  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FPageSize := 10;
  FSmallChange := 1;
  FLargeChange := 10;
  FOrientation := orHorizontal;
  FAutoHide := oahNever;
  FShowButtons := True;
  FMinThumbSize := 20;

  FAnimatedAlpha := 255;
  FAnimatedPosition := 0;
  FTargetPosition := 0;
  FTargetAlpha := 255;
  FIsDragging := False;
  FMouseOverPart := mpNone;
  FPressedPart := ppNone;
  FIsMouseOver := False;

  FFadeTimer := TTimer.Create(Self);
  FFadeTimer.Interval := 16; // ~60 FPS
  FFadeTimer.Enabled := False;
  FFadeTimer.OnTimer := @OnFadeTimer;

  FScrollTimer := TTimer.Create(Self);
  FScrollTimer.Interval := 16;
  FScrollTimer.Enabled := False;
  FScrollTimer.OnTimer := @OnScrollTimer;

  SkinElement := 'ScrollBar';
  UpdateRects;
end;

destructor TONURScrollBar.Destroy;
begin
  FFadeTimer.Free;
  FScrollTimer.Free;
  inherited Destroy;
end;

procedure TONURScrollBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetPosition(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FPosition = AValue then Exit;
  FPosition := AValue;
  UpdateRects;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURScrollBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.UpdateRects;
var
  BtnSize, TrackStart, TrackLen, ThumbPos, ThumbLen: integer;
begin
  if FOrientation = orHorizontal then
  begin
    BtnSize := Height;

    if FShowButtons then
    begin
      FLeftBtnRect := Rect(0, 0, BtnSize, Height);
      FRightBtnRect := Rect(Width - BtnSize, 0, Width, Height);
      TrackStart := BtnSize;
      TrackLen := Width - BtnSize * 2;
    end
    else
    begin
      FLeftBtnRect := Rect(0, 0, 0, 0);
      FRightBtnRect := Rect(0, 0, 0, 0);
      TrackStart := 0;
      TrackLen := Width;
    end;

    FTrackRect := Rect(TrackStart, 0, TrackStart + TrackLen, Height);

    ThumbLen := GetThumbSize;
    ThumbPos := PosFromValue(FPosition);
    FThumbRect := Rect(TrackStart + ThumbPos, 0, TrackStart + ThumbPos +
      ThumbLen, Height);
  end
  else // Vertical
  begin
    BtnSize := Width;

    if FShowButtons then
    begin
      FLeftBtnRect := Rect(0, 0, Width, BtnSize); // Top button
      FRightBtnRect := Rect(0, Height - BtnSize, Width, Height); // Bottom button
      TrackStart := BtnSize;
      TrackLen := Height - BtnSize * 2;
    end
    else
    begin
      FLeftBtnRect := Rect(0, 0, 0, 0);
      FRightBtnRect := Rect(0, 0, 0, 0);
      TrackStart := 0;
      TrackLen := Height;
    end;

    FTrackRect := Rect(0, TrackStart, Width, TrackStart + TrackLen);

    ThumbLen := GetThumbSize;
    ThumbPos := PosFromValue(FPosition);
    FThumbRect := Rect(0, TrackStart + ThumbPos, Width, TrackStart +
      ThumbPos + ThumbLen);
  end;
end;

function TONURScrollBar.GetThumbSize: integer;
var
  Range, TrackSize: integer;
begin
  Range := FMax - FMin + 1;
  if Range <= 0 then Range := 1;

  if FOrientation = orHorizontal then
    TrackSize := FTrackRect.Right - FTrackRect.Left
  else
    TrackSize := FTrackRect.Bottom - FTrackRect.Top;

  if Range <= FPageSize then
    Result := TrackSize
  else
    Result := Round(TrackSize * FPageSize / Range);

  if Result < FMinThumbSize then
    Result := FMinThumbSize;
  if Result > TrackSize then
    Result := TrackSize;
end;

function TONURScrollBar.PosFromValue(AValue: integer): integer;
var
  Range, TrackSize, ThumbSize: integer;
begin
  Range := FMax - FMin;
  if Range <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  if FOrientation = orHorizontal then
    TrackSize := FTrackRect.Right - FTrackRect.Left
  else
    TrackSize := FTrackRect.Bottom - FTrackRect.Top;

  ThumbSize := GetThumbSize;

  Result := Round((AValue - FMin) / Range * (TrackSize - ThumbSize));
end;

function TONURScrollBar.ValueFromPos(APos: integer): integer;
var
  Range, TrackSize, ThumbSize: integer;
begin
  Range := FMax - FMin;
  if Range <= 0 then
  begin
    Result := FMin;
    Exit;
  end;

  if FOrientation = orHorizontal then
    TrackSize := FTrackRect.Right - FTrackRect.Left
  else
    TrackSize := FTrackRect.Bottom - FTrackRect.Top;

  ThumbSize := GetThumbSize;

  if TrackSize <= ThumbSize then
    Result := FMin
  else
    Result := FMin + Round(APos / (TrackSize - ThumbSize) * Range);
end;

procedure TONURScrollBar.SmoothScrollTo(ATarget: integer);
begin
  if ATarget < FMin then ATarget := FMin;
  if ATarget > FMax then ATarget := FMax;

  FTargetPosition := ATarget;
  FScrollTimer.Enabled := True;
end;

procedure TONURScrollBar.OnFadeTimer(Sender: TObject);
begin
  if FAnimatedAlpha < FTargetAlpha then
  begin
    FAnimatedAlpha := FAnimatedAlpha + 15;
    if FAnimatedAlpha > FTargetAlpha then
      FAnimatedAlpha := FTargetAlpha;
  end
  else if FAnimatedAlpha > FTargetAlpha then
  begin
    FAnimatedAlpha := FAnimatedAlpha - 15;
    if FAnimatedAlpha < FTargetAlpha then
      FAnimatedAlpha := FTargetAlpha;
  end;

  if FAnimatedAlpha = FTargetAlpha then
    FFadeTimer.Enabled := False;

  Invalidate;
end;

procedure TONURScrollBar.OnScrollTimer(Sender: TObject);
var
  Diff: integer;
begin
  Diff := FTargetPosition - FPosition;

  if Abs(Diff) <= 1 then
  begin
    SetPosition(FTargetPosition);
    FScrollTimer.Enabled := False;
  end
  else
  begin
    SetPosition(FPosition + Sign(Diff) * Math.Max(1, Abs(Diff) div 5));
  end;
end;

procedure TONURScrollBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURScrollBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  PartName: string;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track
    if FMouseOverPart = mpTrack then
      PartName := 'Track_Hover'
    else
      PartName := 'Track_Normal';

    DrawSuccess := DrawPart(PartName, Bmp, FTrackRect, FAnimatedAlpha);

    if not DrawSuccess then
      Bmp.FillRect(FTrackRect, BGRA(240, 240, 240, FAnimatedAlpha), dmSet);

    // Left/Top Button
    if FShowButtons then
    begin
      if FPressedPart = ppLeftBtn then
        PartName := 'LeftBtn_Pressed'
      else if FMouseOverPart = mpLeftBtn then
        PartName := 'LeftBtn_Hover'
      else
        PartName := 'LeftBtn_Normal';

      DrawSuccess := DrawPart(PartName, Bmp, FLeftBtnRect, FAnimatedAlpha);

      if not DrawSuccess then
      begin
        Bmp.FillRect(FLeftBtnRect, BGRA(220, 220, 220, FAnimatedAlpha), dmSet);
        Bmp.Rectangle(FLeftBtnRect, BGRA(180, 180, 180, FAnimatedAlpha), dmSet);
      end;
    end;

    // Right/Bottom Button
    if FShowButtons then
    begin
      if FPressedPart = ppRightBtn then
        PartName := 'RightBtn_Pressed'
      else if FMouseOverPart = mpRightBtn then
        PartName := 'RightBtn_Hover'
      else
        PartName := 'RightBtn_Normal';

      DrawSuccess := DrawPart(PartName, Bmp, FRightBtnRect, FAnimatedAlpha);

      if not DrawSuccess then
      begin
        Bmp.FillRect(FRightBtnRect, BGRA(220, 220, 220, FAnimatedAlpha), dmSet);
        Bmp.Rectangle(FRightBtnRect, BGRA(180, 180, 180, FAnimatedAlpha), dmSet);
      end;
    end;

    // Thumb
    if FPressedPart = ppThumb then
      PartName := 'Thumb_Pressed'
    else if FMouseOverPart = mpThumb then
      PartName := 'Thumb_Hover'
    else
      PartName := 'Thumb_Normal';

    DrawSuccess := DrawPart(PartName, Bmp, FThumbRect, FAnimatedAlpha);

    if not DrawSuccess then
    begin
      Bmp.FillRect(FThumbRect, BGRA(180, 180, 180, FAnimatedAlpha), dmSet);
      Bmp.Rectangle(FThumbRect, BGRA(128, 128, 128, FAnimatedAlpha), dmSet);
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button <> mbLeft then Exit;

  // Thumb
  if PtInRect(FThumbRect, Point(X, Y)) then
  begin
    FIsDragging := True;
    FPressedPart := ppThumb;
    if FOrientation = orHorizontal then
      FDragStartPos := X
    else
      FDragStartPos := Y;
    FDragStartValue := FPosition;
    Invalidate;
  end
  // Left/Top Button
  else if FShowButtons and PtInRect(FLeftBtnRect, Point(X, Y)) then
  begin
    FPressedPart := ppLeftBtn;
    SmoothScrollTo(FPosition - FSmallChange);
    Invalidate;
  end
  // Right/Bottom Button
  else if FShowButtons and PtInRect(FRightBtnRect, Point(X, Y)) then
  begin
    FPressedPart := ppRightBtn;
    SmoothScrollTo(FPosition + FSmallChange);
    Invalidate;
  end
  // Track
  else if PtInRect(FTrackRect, Point(X, Y)) then
  begin
    FPressedPart := ppTrack;
    // Page up/down
    if FOrientation = orHorizontal then
    begin
      if X < FThumbRect.Left then
        SmoothScrollTo(FPosition - FLargeChange)
      else
        SmoothScrollTo(FPosition + FLargeChange);
    end
    else
    begin
      if Y < FThumbRect.Top then
        SmoothScrollTo(FPosition - FLargeChange)
      else
        SmoothScrollTo(FPosition + FLargeChange);
    end;
  end;
end;

procedure TONURScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FIsDragging := False;
    FPressedPart := ppNone;
    Invalidate;
  end;
end;

procedure TONURScrollBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  Delta, NewValue: integer;
  // OldPart:  (mpNone, mpLeftBtn, mpRightBtn, mpThumb, mpTrack);
begin
  inherited MouseMove(Shift, X, Y);

  OldPart := FMouseOverPart;

  // Dragging
  if FIsDragging then
  begin
    if FOrientation = orHorizontal then
      Delta := X - FDragStartPos
    else
      Delta := Y - FDragStartPos;

    NewValue := ValueFromPos(PosFromValue(FDragStartValue) + Delta);
    SetPosition(NewValue);
  end
  else
  begin
    // Update hover state
    if PtInRect(FThumbRect, Point(X, Y)) then
      FMouseOverPart := mpThumb
    else if FShowButtons and PtInRect(FLeftBtnRect, Point(X, Y)) then
      FMouseOverPart := mpLeftBtn
    else if FShowButtons and PtInRect(FRightBtnRect, Point(X, Y)) then
      FMouseOverPart := mpRightBtn
    else if PtInRect(FTrackRect, Point(X, Y)) then
      FMouseOverPart := mpTrack
    else
      FMouseOverPart := mpNone;

    if OldPart <> FMouseOverPart then
      Invalidate;
  end;
end;

procedure TONURScrollBar.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;

  case FAutoHide of
    oahOnMouseLeave, oahAlways:
    begin
      FTargetAlpha := 255;
      FFadeTimer.Enabled := True;
    end;
  end;

  Invalidate;
end;

procedure TONURScrollBar.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FMouseOverPart := mpNone;

  case FAutoHide of
    oahOnMouseLeave:
    begin
      FTargetAlpha := 128;
      FFadeTimer.Enabled := True;
    end;
    oahAlways:
    begin
      FTargetAlpha := 0;
      FFadeTimer.Enabled := True;
    end;
  end;

  Invalidate;
end;

function TONURScrollBar.DoMouseWheel(Shift: TShiftState; WheelDelta: integer;
  MousePos: TPoint): boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);

  if WheelDelta > 0 then
    SmoothScrollTo(FPosition - FSmallChange)
  else
    SmoothScrollTo(FPosition + FSmallChange);

  Result := True;
end;

{ TONURSliderBar }
constructor TONURSliderBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 30;

  FMin := 0;
  FMax := 100;
  FValue := 0;
  FOrientation := orHorizontal;
  FThumbSize := 20;
  FAnimatedValue := 0;
  FIsDragging := False;

  SkinElement := 'SliderBar';
  UpdateRects;
end;

procedure TONURSliderBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetValue(FValue);
  UpdateRects;
  Invalidate;
end;

procedure TONURSliderBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetValue(FValue);
  UpdateRects;
  Invalidate;
end;

procedure TONURSliderBar.SetValue(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FValue = AValue then Exit;
  FValue := AValue;

  StartAnimation(oatSlide, 150, oaeEaseOut);
  UpdateRects;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURSliderBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURSliderBar.UpdateRects;
var
  ThumbPos: integer;
  Range: integer;
begin
  Range := FMax - FMin;
  if Range <= 0 then Range := 1;

  if FOrientation = orHorizontal then
  begin
    FTrackRect := Rect(FThumbSize div 2, (Height - 4) div 2,
      Width - FThumbSize div 2, (Height + 4) div 2);

    ThumbPos := Round((FValue - FMin) / Range * (Width - FThumbSize));
    FThumbRect := Rect(ThumbPos, (Height - FThumbSize) div 2,
      ThumbPos + FThumbSize, (Height + FThumbSize) div 2);
  end
  else
  begin
    FTrackRect := Rect((Width - 4) div 2, FThumbSize div 2,
      (Width + 4) div 2, Height - FThumbSize div 2);

    ThumbPos := Round((FValue - FMin) / Range * (Height - FThumbSize));
    FThumbRect := Rect((Width - FThumbSize) div 2, Height - ThumbPos -
      FThumbSize, (Width + FThumbSize) div 2, Height - ThumbPos);
  end;
end;

function TONURSliderBar.ValueFromPos(X, Y: integer): integer;
var
  Range, Pos, MaxPos: integer;
begin
  Range := FMax - FMin;

  if FOrientation = orHorizontal then
  begin
    Pos := X - FThumbSize div 2;
    MaxPos := Width - FThumbSize;
  end
  else
  begin
    Pos := Height - Y - FThumbSize div 2;
    MaxPos := Height - FThumbSize;
  end;

  if MaxPos <= 0 then MaxPos := 1;

  Result := FMin + Round(Pos / MaxPos * Range);

  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TONURSliderBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetValue: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetValue := (FValue - FMin) / (FMax - FMin);
    FAnimatedValue := FAnimatedValue + (TargetValue - FAnimatedValue) * Progress;
    UpdateRects;
    Invalidate;
  end;
end;

procedure TONURSliderBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURSliderBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track
    DrawSuccess := DrawPart('Track', Bmp, FTrackRect, 255);

    if not DrawSuccess then
    begin
      Bmp.FillRoundRectAntialias(FTrackRect.Left, FTrackRect.Top,
        FTrackRect.Right, FTrackRect.Bottom,
        2, 2, BGRA(200, 200, 200, 255));
    end;

    // Thumb
    DrawSuccess := DrawPart('Thumb', Bmp, FThumbRect, 255);

    if not DrawSuccess then
    begin
      Bmp.FillEllipseAntialias((FThumbRect.Left + FThumbRect.Right) / 2,
        (FThumbRect.Top + FThumbRect.Bottom) / 2,
        FThumbSize / 2, FThumbSize / 2,
        BGRA(33, 150, 243, 255));

      Bmp.EllipseAntialias((FThumbRect.Left + FThumbRect.Right) / 2,
        (FThumbRect.Top + FThumbRect.Bottom) / 2,
        FThumbSize / 2, FThumbSize / 2,
        BGRA(25, 118, 210, 255), 1);
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURSliderBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FIsDragging := True;
    SetValue(ValueFromPos(X, Y));
  end;
end;

procedure TONURSliderBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
    FIsDragging := False;
end;

procedure TONURSliderBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);

  if FIsDragging then
    SetValue(ValueFromPos(X, Y));
end;


{ TONURTrackBar }
constructor TONURTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 40;

  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FOrientation := orHorizontal;
  FTickFrequency := 10;
  FTickStyle := tsBoth;
  FShowValueHint := True;
  FSnapToTick := False;
  FThumbSize := 20;
  FAnimatedPosition := 0;
  FIsDragging := False;

  SkinElement := 'TrackBar';
  UpdateRects;
end;

procedure TONURTrackBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURTrackBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURTrackBar.SetPosition(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FSnapToTick then
    AValue := SnapValue(AValue);

  if FPosition = AValue then Exit;
  FPosition := AValue;

  StartAnimation(oatSlide, 150, oaeEaseOut);
  UpdateRects;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURTrackBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  UpdateRects;
  Invalidate;
end;

function TONURTrackBar.SnapValue(AValue: integer): integer;
var
  Remainder: integer;
begin
  if FTickFrequency <= 0 then
  begin
    Result := AValue;
    Exit;
  end;

  Remainder := (AValue - FMin) mod FTickFrequency;

  if Remainder < FTickFrequency div 2 then
    Result := AValue - Remainder
  else
    Result := AValue + (FTickFrequency - Remainder);
end;

procedure TONURTrackBar.UpdateRects;
var
  ThumbPos: integer;
  Range: integer;
begin
  Range := FMax - FMin;
  if Range <= 0 then Range := 1;

  if FOrientation = orHorizontal then
  begin
    FTrackRect := Rect(FThumbSize div 2, Height div 2 - 2,
      Width - FThumbSize div 2, Height div 2 + 2);

    ThumbPos := Round((FPosition - FMin) / Range * (Width - FThumbSize));
    FThumbRect := Rect(ThumbPos, Height div 2 - FThumbSize div 2,
      ThumbPos + FThumbSize, Height div 2 + FThumbSize div 2);
  end
  else
  begin
    FTrackRect := Rect(Width div 2 - 2, FThumbSize div 2,
      Width div 2 + 2, Height - FThumbSize div 2);

    ThumbPos := Round((FPosition - FMin) / Range * (Height - FThumbSize));
    FThumbRect := Rect(Width div 2 - FThumbSize div 2, Height -
      ThumbPos - FThumbSize, Width div 2 + FThumbSize div
      2, Height - ThumbPos);
  end;
end;

function TONURTrackBar.ValueFromPos(X, Y: integer): integer;
var
  Range, Pos, MaxPos: integer;
begin
  Range := FMax - FMin;

  if FOrientation = orHorizontal then
  begin
    Pos := X - FThumbSize div 2;
    MaxPos := Width - FThumbSize;
  end
  else
  begin
    Pos := Height - Y - FThumbSize div 2;
    MaxPos := Height - FThumbSize;
  end;

  if MaxPos <= 0 then MaxPos := 1;

  Result := FMin + Round(Pos / MaxPos * Range);

  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TONURTrackBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetPos: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetPos := (FPosition - FMin) / (FMax - FMin);
    FAnimatedPosition := FAnimatedPosition + (TargetPos - FAnimatedPosition) * Progress;
    UpdateRects;
    Invalidate;
  end;
end;

procedure TONURTrackBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURTrackBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  I, TickValue, TickPos: integer;
  Range: integer;
  TickX, TickY: integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track
    DrawSuccess := DrawPart('Track', Bmp, FTrackRect, 255);

    if not DrawSuccess then
      Bmp.FillRect(FTrackRect, BGRA(200, 200, 200, 255), dmSet);

    // Ticks
    if (FTickStyle <> tsNone) and (FTickFrequency > 0) then
    begin
      Range := FMax - FMin;

      for I := 0 to (Range div FTickFrequency) do
      begin
        TickValue := FMin + I * FTickFrequency;

        if FOrientation = orHorizontal then
        begin
          TickPos := Round((TickValue - FMin) / Range * (Width - FThumbSize)) +
            FThumbSize div 2;

          if (FTickStyle = tsBoth) or (FTickStyle = tsTopLeft) then
            Bmp.DrawLineAntialias(TickPos, Height div 2 - 8, TickPos, Height div 2 - 3,
              BGRA(128, 128, 128, 255), 1);

          if (FTickStyle = tsBoth) or (FTickStyle = tsBottomRight) then
            Bmp.DrawLineAntialias(TickPos, Height div 2 + 3, TickPos, Height div 2 + 8,
              BGRA(128, 128, 128, 255), 1);
        end
        else
        begin
          TickPos := Height - (Round((TickValue - FMin) / Range *
            (Height - FThumbSize)) + FThumbSize div 2);

          if (FTickStyle = tsBoth) or (FTickStyle = tsTopLeft) then
            Bmp.DrawLineAntialias(Width div 2 - 8, TickPos, Width div 2 - 3, TickPos,
              BGRA(128, 128, 128, 255), 1);

          if (FTickStyle = tsBoth) or (FTickStyle = tsBottomRight) then
            Bmp.DrawLineAntialias(Width div 2 + 3, TickPos, Width div 2 + 8, TickPos,
              BGRA(128, 128, 128, 255), 1);
        end;
      end;
    end;

    // Thumb
    DrawSuccess := DrawPart('Thumb', Bmp, FThumbRect, 255);

    if not DrawSuccess then
    begin
      Bmp.FillEllipseAntialias((FThumbRect.Left + FThumbRect.Right) / 2,
        (FThumbRect.Top + FThumbRect.Bottom) / 2,
        FThumbSize / 2, FThumbSize / 2,
        BGRA(33, 150, 243, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FIsDragging := True;
    SetPosition(ValueFromPos(X, Y));
  end;
end;

procedure TONURTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
    FIsDragging := False;
end;

procedure TONURTrackBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);

  if FIsDragging then
    SetPosition(ValueFromPos(X, Y));
end;

{ TONURRangeBar }
constructor TONURRangeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 40;

  FMin := 0;
  FMax := 100;
  FLowValue := 25;
  FHighValue := 75;
  FOrientation := orHorizontal;
  FShowValues := True;
  FThumbSize := 20;
  FDraggingThumb := dtNone;

  SkinElement := 'RangeBar';
  UpdateRects;
end;

procedure TONURRangeBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetLowValue(FLowValue);
  SetHighValue(FHighValue);
  UpdateRects;
  Invalidate;
end;

procedure TONURRangeBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetLowValue(FLowValue);
  SetHighValue(FHighValue);
  UpdateRects;
  Invalidate;
end;

procedure TONURRangeBar.SetLowValue(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FHighValue then AValue := FHighValue;

  if FLowValue = AValue then Exit;
  FLowValue := AValue;
  UpdateRects;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURRangeBar.SetHighValue(AValue: integer);
begin
  if AValue > FMax then AValue := FMax;
  if AValue < FLowValue then AValue := FLowValue;

  if FHighValue = AValue then Exit;
  FHighValue := AValue;
  UpdateRects;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURRangeBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURRangeBar.UpdateRects;
var
  Range: integer;
  LowPos, HighPos: integer;
begin
  Range := FMax - FMin;
  if Range <= 0 then Range := 1;

  if FOrientation = orHorizontal then
  begin
    FTrackRect := Rect(FThumbSize div 2, Height div 2 - 2,
      Width - FThumbSize div 2, Height div 2 + 2);

    LowPos := Round((FLowValue - FMin) / Range * (Width - FThumbSize));
    HighPos := Round((FHighValue - FMin) / Range * (Width - FThumbSize));

    FLowThumbRect := Rect(LowPos, Height div 2 - FThumbSize div 2,
      LowPos + FThumbSize, Height div 2 + FThumbSize div 2);

    FHighThumbRect := Rect(HighPos, Height div 2 - FThumbSize div 2,
      HighPos + FThumbSize, Height div 2 + FThumbSize div 2);

    FRangeRect := Rect(LowPos + FThumbSize div 2, Height div 2 - 2,
      HighPos + FThumbSize div 2, Height div 2 + 2);
  end
  else
  begin
    FTrackRect := Rect(Width div 2 - 2, FThumbSize div 2,
      Width div 2 + 2, Height - FThumbSize div 2);

    LowPos := Round((FLowValue - FMin) / Range * (Height - FThumbSize));
    HighPos := Round((FHighValue - FMin) / Range * (Height - FThumbSize));

    FLowThumbRect := Rect(Width div 2 - FThumbSize div 2, Height -
      LowPos - FThumbSize, Width div 2 + FThumbSize div 2,
      Height - LowPos);

    FHighThumbRect := Rect(Width div 2 - FThumbSize div 2, Height -
      HighPos - FThumbSize, Width div 2 +
      FThumbSize div 2, Height - HighPos);

    FRangeRect := Rect(Width div 2 - 2, Height - HighPos - FThumbSize div
      2, Width div 2 + 2, Height - LowPos - FThumbSize div 2);
  end;
end;

function TONURRangeBar.ValueFromPos(X, Y: integer): integer;
var
  Range, Pos, MaxPos: integer;
begin
  Range := FMax - FMin;

  if FOrientation = orHorizontal then
  begin
    Pos := X - FThumbSize div 2;
    MaxPos := Width - FThumbSize;
  end
  else
  begin
    Pos := Height - Y - FThumbSize div 2;
    MaxPos := Height - FThumbSize;
  end;

  if MaxPos <= 0 then MaxPos := 1;

  Result := FMin + Round(Pos / MaxPos * Range);

  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TONURRangeBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURRangeBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  //Text: string;
  TextSize: TSize;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track
    DrawSuccess := DrawPart('Track', Bmp, FTrackRect, 255);

    if not DrawSuccess then
      Bmp.FillRect(FTrackRect, BGRA(220, 220, 220, 255), dmSet);

    // Range (selected area)
    DrawSuccess := DrawPart('Range', Bmp, FRangeRect, 255);

    if not DrawSuccess then
      Bmp.FillRect(FRangeRect, BGRA(33, 150, 243, 255), dmSet);

    // Low Thumb
    DrawSuccess := DrawPart('ThumbLow', Bmp, FLowThumbRect, 255);

    if not DrawSuccess then
    begin
      Bmp.FillEllipseAntialias((FLowThumbRect.Left + FLowThumbRect.Right) / 2,
        (FLowThumbRect.Top + FLowThumbRect.Bottom) / 2,
        FThumbSize / 2, FThumbSize / 2,
        BGRA(25, 118, 210, 255));
    end;

    // High Thumb
    DrawSuccess := DrawPart('ThumbHigh', Bmp, FHighThumbRect, 255);

    if not DrawSuccess then
    begin
      Bmp.FillEllipseAntialias((FHighThumbRect.Left + FHighThumbRect.Right) / 2,
        (FHighThumbRect.Top + FHighThumbRect.Bottom) / 2,
        FThumbSize / 2, FThumbSize / 2,
        BGRA(25, 118, 210, 255));
    end;

    // Values
    if FShowValues then
    begin
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontAntialias := True;

      Text := IntToStr(FLowValue) + ' - ' + IntToStr(FHighValue);
      TextSize := Bmp.TextSize(Text);

      if FOrientation = orHorizontal then
        Bmp.TextOut((Width - TextSize.cx) div 2, 2, Text, BGRA(64, 64, 64, 255))
      else
        Bmp.TextOut(2, (Height - TextSize.cy) div 2, Text, BGRA(64, 64, 64, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURRangeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    // High thumb önce (üstte olabilir)
    if PtInRect(FHighThumbRect, Point(X, Y)) then
      FDraggingThumb := dtHigh
    else if PtInRect(FLowThumbRect, Point(X, Y)) then
      FDraggingThumb := dtLow;
  end;
end;

procedure TONURRangeBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
    FDraggingThumb := dtNone;
end;

procedure TONURRangeBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewValue: integer;
begin
  inherited MouseMove(Shift, X, Y);

  if FDraggingThumb <> dtNone then
  begin
    NewValue := ValueFromPos(X, Y);

    if FDraggingThumb = dtLow then
      SetLowValue(NewValue)
    else
      SetHighValue(NewValue);
  end;
end;

{ TONURSwitchBar }
constructor TONURSwitchBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 60;
  Height := 30;

  FValue := False;
  FOnText := 'ON';
  FOffText := 'OFF';
  FAnimationDuration := 200;
  FAnimatedPosition := 0.0;

  SkinElement := 'SwitchBar';
  UpdateRects;
end;

procedure TONURSwitchBar.SetValue(AValue: boolean);
begin
  if FValue = AValue then Exit;
  FValue := AValue;

  StartAnimation(oatSlide, FAnimationDuration, oaeEaseInOut);

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURSwitchBar.SetOnText(AValue: string);
begin
  if FOnText = AValue then Exit;
  FOnText := AValue;
  Invalidate;
end;

procedure TONURSwitchBar.SetOffText(AValue: string);
begin
  if FOffText = AValue then Exit;
  FOffText := AValue;
  Invalidate;
end;

procedure TONURSwitchBar.UpdateRects;
var
  ThumbSize, ThumbX: integer;
begin
  FTrackRect := Rect(0, Height div 4, Width, Height - Height div 4);

  ThumbSize := Height - 4;
  ThumbX := Round(2 + (Width - ThumbSize - 4) * FAnimatedPosition);
  FThumbRect := Rect(ThumbX, 2, ThumbX + ThumbSize, Height - 2);
end;

procedure TONURSwitchBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetPos: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;

    if FValue then
      TargetPos := 1.0
    else
      TargetPos := 0.0;

    FAnimatedPosition := FAnimatedPosition + (TargetPos - FAnimatedPosition) * Progress;
    UpdateRects;
    Invalidate;
  end;
end;

procedure TONURSwitchBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURSwitchBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  TrackColor, ThumbColor: TBGRAPixel;
  //  Text: string;
  TextSize: TSize;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track
    if FValue then
      DrawSuccess := DrawPart('Track_On', Bmp, FTrackRect, 255)
    else
      DrawSuccess := DrawPart('Track_Off', Bmp, FTrackRect, 255);

    if not DrawSuccess then
    begin
      if FValue then
        TrackColor := BGRA(76, 175, 80, 255) // Green
      else
        TrackColor := BGRA(189, 189, 189, 255); // Gray

      Bmp.FillRoundRectAntialias(FTrackRect.Left, FTrackRect.Top,
        FTrackRect.Right, FTrackRect.Bottom,
        (FTrackRect.Bottom - FTrackRect.Top) div 2,
        (FTrackRect.Bottom - FTrackRect.Top) div 2,
        TrackColor);
    end;

    // Thumb
    DrawSuccess := DrawPart('Thumb', Bmp, FThumbRect, 255);

    if not DrawSuccess then
    begin
      ThumbColor := BGRA(255, 255, 255, 255);
      Bmp.FillEllipseAntialias((FThumbRect.Left + FThumbRect.Right) / 2,
        (FThumbRect.Top + FThumbRect.Bottom) / 2,
        (FThumbRect.Right - FThumbRect.Left) / 2,
        (FThumbRect.Bottom - FThumbRect.Top) / 2,
        ThumbColor);

      Bmp.EllipseAntialias((FThumbRect.Left + FThumbRect.Right) / 2,
        (FThumbRect.Top + FThumbRect.Bottom) / 2,
        (FThumbRect.Right - FThumbRect.Left) / 2,
        (FThumbRect.Bottom - FThumbRect.Top) / 2,
        BGRA(0, 0, 0, 64), 1);
    end;

    // Text (optional)
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontAntialias := True;

    if FValue then
      Text := FOnText
    else
      Text := FOffText;

    if Text <> '' then
    begin
      TextSize := Bmp.TextSize(Text);
      Bmp.TextOut((Width - TextSize.cx) div 2, (Height - TextSize.cy) div 2,
        Text, BGRA(255, 255, 255, 200));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURSwitchBar.Click;
begin
  inherited Click;
  Value := not Value;
end;

{ TONURMeterBar }
constructor TONURMeterBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 30;
  Height := 200;

  FMin := 0;
  FMax := 100;
  FValue := 0;
  FPeakValue := 0;
  FPeakHoldTime := 1000;
  FSegments := 20;
  FOrientation := orVertical;
  FAnimatedValue := 0;

  FPeakTimer := TTimer.Create(Self);
  FPeakTimer.Interval := 50;
  FPeakTimer.Enabled := False;
  FPeakTimer.OnTimer := @OnPeakTimer;

  SkinElement := 'MeterBar';
end;

destructor TONURMeterBar.Destroy;
begin
  FPeakTimer.Free;
  inherited Destroy;
end;

procedure TONURMeterBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURMeterBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURMeterBar.SetValue(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FValue = AValue then Exit;
  FValue := AValue;

  // Peak güncelle
  if FValue > FPeakValue then
  begin
    FPeakValue := FValue;
    FPeakStartTime := GetTickCount64;
    FPeakTimer.Enabled := True;
  end;

  StartAnimation(oatFade, 100, oaeLinear);
  Invalidate;
end;

procedure TONURMeterBar.SetOrientation(AValue: TONUROrientation);
begin
  if FOrientation = AValue then Exit;
  FOrientation := AValue;
  Invalidate;
end;

procedure TONURMeterBar.OnPeakTimer(Sender: TObject);
begin
  if GetTickCount64 - FPeakStartTime > FPeakHoldTime then
  begin
    FPeakValue := FValue;
    FPeakTimer.Enabled := False;
  end;
  Invalidate;
end;

procedure TONURMeterBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetValue: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetValue := (FValue - FMin) / (FMax - FMin);
    FAnimatedValue := FAnimatedValue + (TargetValue - FAnimatedValue) * Progress;
    Invalidate;
  end;
end;

function TONURMeterBar.GetSegmentColor(Index: integer): TBGRAPixel;
var
  Percent: single;
begin
  Percent := Index / FSegments;

  if Percent < 0.6 then
    Result := BGRA(76, 175, 80, 255)   // Green
  else if Percent < 0.85 then
    Result := BGRA(255, 193, 7, 255)   // Yellow
  else
    Result := BGRA(244, 67, 54, 255);  // Red
end;

procedure TONURMeterBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  I, ActiveSegments, PeakSegment: integer;
  SegmentRect: TRect;
  SegmentSize, SegmentSpacing, SegmentWidth, SegmentHeight: integer;
  Range: integer;
  SegColor: TBGRAPixel;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    Range := FMax - FMin;
    if Range <= 0 then Range := 1;

    ActiveSegments := Round(FAnimatedValue * FSegments);
    PeakSegment := Round((FPeakValue - FMin) / Range * FSegments);

    SegmentSpacing := 2;

    if FOrientation = orVertical then
    begin
      SegmentHeight := (ClientHeight - (FSegments - 1) * SegmentSpacing) div FSegments;
      SegmentWidth := ClientWidth - 4;

      for I := 0 to FSegments - 1 do
      begin
        SegmentRect := Rect(2, ClientHeight -
          (I + 1) * (SegmentHeight + SegmentSpacing) + SegmentSpacing,
          2 + SegmentWidth, ClientHeight -
          I * (SegmentHeight + SegmentSpacing));

        // Segment aktif mi?
        if I < ActiveSegments then
        begin
          SegColor := GetSegmentColor(I);
          Bmp.FillRect(SegmentRect, SegColor, dmSet);
        end
        else
        begin
          // Inactive segment
          Bmp.FillRect(SegmentRect, BGRA(64, 64, 64, 255), dmSet);
        end;

        // Peak indicator
        if I = PeakSegment - 1 then
        begin
          Bmp.Rectangle(SegmentRect, BGRA(255, 255, 255, 255), dmSet);
        end;
      end;
    end
    else // Horizontal
    begin
      SegmentWidth := (ClientWidth - (FSegments - 1) * SegmentSpacing) div FSegments;
      SegmentHeight := ClientHeight - 4;

      for I := 0 to FSegments - 1 do
      begin
        SegmentRect := Rect(I * (SegmentWidth + SegmentSpacing),
          2, I *
          (SegmentWidth + SegmentSpacing) + SegmentWidth, 2 +
          SegmentHeight);

        if I < ActiveSegments then
        begin
          SegColor := GetSegmentColor(I);
          Bmp.FillRect(SegmentRect, SegColor, dmSet);
        end
        else
        begin
          Bmp.FillRect(SegmentRect, BGRA(64, 64, 64, 255), dmSet);
        end;

        if I = PeakSegment - 1 then
        begin
          Bmp.Rectangle(SegmentRect, BGRA(255, 255, 255, 255), dmSet);
        end;
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

{ TONURTimeBar }
constructor TONURTimeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 400;
  Height := 30;

  FDuration := 0;
  FPosition := 0;
  FBufferPosition := 0;
  FShowTime := True;
  FAllowSeek := True;
  FIsSeeking := False;

  SkinElement := 'TimeBar';
end;

procedure TONURTimeBar.SetDuration(AValue: integer);
begin
  if AValue < 0 then AValue := 0;
  if FDuration = AValue then Exit;
  FDuration := AValue;
  if FPosition > FDuration then FPosition := FDuration;
  if FBufferPosition > FDuration then FBufferPosition := FDuration;
  Invalidate;
end;

procedure TONURTimeBar.SetPosition(AValue: integer);
begin
  if AValue < 0 then AValue := 0;
  if AValue > FDuration then AValue := FDuration;

  if FPosition = AValue then Exit;
  FPosition := AValue;
  Invalidate;
end;

procedure TONURTimeBar.SetBufferPosition(AValue: integer);
begin
  if AValue < 0 then AValue := 0;
  if AValue > FDuration then AValue := FDuration;

  if FBufferPosition = AValue then Exit;
  FBufferPosition := AValue;
  Invalidate;
end;

function TONURTimeBar.FormatTime(Seconds: integer): string;
var
  Hours, Minutes, Secs: integer;
begin
  Hours := Seconds div 3600;
  Minutes := (Seconds mod 3600) div 60;
  Secs := Seconds mod 60;

  if Hours > 0 then
    Result := Format('%d:%2.2d:%2.2d', [Hours, Minutes, Secs])
  else
    Result := Format('%d:%2.2d', [Minutes, Secs]);
end;

function TONURTimeBar.ValueFromPos(X: integer): integer;
begin
  if FDuration <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  Result := Round(X / ClientWidth * FDuration);

  if Result < 0 then Result := 0;
  if Result > FDuration then Result := FDuration;
end;

procedure TONURTimeBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  TrackRect, BufferRect, ProgressRect: TRect;
  ThumbX, ThumbY: integer;
  TimeText: string;
  TextSize: TSize;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Track (background)
    TrackRect := Rect(0, Height div 2 - 2, ClientWidth, Height div 2 + 2);

    DrawSuccess := DrawPart('Track', Bmp, TrackRect, 255);

    if not DrawSuccess then
      Bmp.FillRect(TrackRect, BGRA(200, 200, 200, 255), dmSet);

    // Buffer (loaded portion)
    if (FDuration > 0) and (FBufferPosition > 0) then
    begin
      BufferRect := Rect(0, Height div 2 - 2,
        Round(ClientWidth * FBufferPosition / FDuration),
        Height div 2 + 2);

      DrawSuccess := DrawPart('Buffer', Bmp, BufferRect, 255);

      if not DrawSuccess then
        Bmp.FillRect(BufferRect, BGRA(220, 220, 220, 255), dmSet);
    end;

    // Progress (played portion)
    if (FDuration > 0) and (FPosition > 0) then
    begin
      ProgressRect := Rect(0, Height div 2 - 2,
        Round(ClientWidth * FPosition / FDuration),
        Height div 2 + 2);

      DrawSuccess := DrawPart('Progress', Bmp, ProgressRect, 255);

      if not DrawSuccess then
        Bmp.FillRect(ProgressRect, BGRA(33, 150, 243, 255), dmSet);
    end;

    // Thumb (current position indicator)
    if FDuration > 0 then
    begin
      ThumbX := Round(ClientWidth * FPosition / FDuration);
      ThumbY := Height div 2;

      DrawSuccess := DrawPart('Thumb', Bmp, Rect(ThumbX - 6, ThumbY -
        6, ThumbX + 6, ThumbY + 6), 255);

      if not DrawSuccess then
      begin
        Bmp.FillEllipseAntialias(ThumbX, ThumbY, 6, 6, BGRA(33, 150, 243, 255));
        Bmp.EllipseAntialias(ThumbX, ThumbY, 6, 6, BGRA(255, 255, 255, 255), 2);
      end;
    end;

    // Time text
    if FShowTime then
    begin
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontAntialias := True;

      TimeText := FormatTime(FPosition) + ' / ' + FormatTime(FDuration);
      TextSize := Bmp.TextSize(TimeText);

      Bmp.TextOut((ClientWidth - TextSize.cx) div 2, 2, TimeText, BGRA(64, 64, 64, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURTimeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if FAllowSeek and (Button = mbLeft) then
  begin
    FIsSeeking := True;
    SetPosition(ValueFromPos(X));

    if Assigned(FOnSeek) then
      FOnSeek(Self);
  end;
end;

procedure TONURTimeBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
    FIsSeeking := False;
end;

procedure TONURTimeBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);

  if FIsSeeking then
  begin
    SetPosition(ValueFromPos(X));

    if Assigned(FOnSeek) then
      FOnSeek(Self);
  end;
end;
{ TONURGaugeBar }
constructor TONURGaugeBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 200;

  FMin := 0;
  FMax := 100;
  FValue := 0;
  FStartAngle := 135;  // Sol alt
  FEndAngle := 45;     // Sağ alt
  FShowNeedle := True;
  FShowTicks := True;
  FTickCount := 10;
  FAnimatedValue := 0;

  SkinElement := 'GaugeBar';
end;

procedure TONURGaugeBar.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURGaugeBar.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURGaugeBar.SetValue(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FValue = AValue then Exit;
  FValue := AValue;

  StartAnimation(oatSlide, 300, oaeEaseOut);
  Invalidate;
end;

procedure TONURGaugeBar.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetValue: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetValue := (FValue - FMin) / (FMax - FMin);
    FAnimatedValue := FAnimatedValue + (TargetValue - FAnimatedValue) * Progress;
    Invalidate;
  end;
end;

function TONURGaugeBar.ValueToAngle(AValue: single): single;
var
  AngleRange: single;
begin
  // StartAngle'dan EndAngle'a doğru açı hesapla
  AngleRange := FEndAngle - FStartAngle;
  if AngleRange < 0 then
    AngleRange := AngleRange + 360;

  Result := FStartAngle + (AngleRange * AValue);
end;

procedure TONURGaugeBar.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  CenterX, CenterY: single;
  Radius, InnerRadius: single;
  I: integer;
  TickAngle, TickValue: single;
  TickX1, TickY1, TickX2, TickY2: single;
  NeedleAngle: single;
  NeedleX, NeedleY: single;
  ValueText: string;
  TextSize: TSize;
  Range: integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    CenterX := ClientWidth / 2;
    CenterY := ClientHeight / 2;
    Radius := Math.Min(ClientWidth, ClientHeight) / 2 - 10;
    InnerRadius := Radius * 0.7;

    Range := FMax - FMin;
    if Range <= 0 then Range := 1;

    // Background arc
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Dış çember
      Bmp.EllipseAntialias(CenterX, CenterY, Radius, Radius,
        BGRA(200, 200, 200, 255), 2);
    end;

    // Ticks
    if FShowTicks and (FTickCount > 0) then
    begin
      for I := 0 to FTickCount do
      begin
        TickValue := I / FTickCount;
        TickAngle := ValueToAngle(TickValue) * Pi / 180;

        // Dış tick noktası
        TickX1 := CenterX + Cos(TickAngle) * Radius;
        TickY1 := CenterY + Sin(TickAngle) * Radius;

        // İç tick noktası
        TickX2 := CenterX + Cos(TickAngle) * (Radius - 10);
        TickY2 := CenterY + Sin(TickAngle) * (Radius - 10);

        Bmp.DrawLineAntialias(TickX1, TickY1, TickX2, TickY2,
          BGRA(128, 128, 128, 255), 2);
      end;
    end;

    // Value arc (colored portion)
    DrawSuccess := DrawPart('ValueArc', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Değer yayı çiz (basitleştirilmiş)
      NeedleAngle := ValueToAngle(FAnimatedValue);
      Bmp.EllipseAntialias(CenterX, CenterY, InnerRadius, InnerRadius,
        BGRA(33, 150, 243, 128), 8);
    end;

    // Needle (ibre)
    if FShowNeedle then
    begin
      NeedleAngle := ValueToAngle(FAnimatedValue) * Pi / 180;
      NeedleX := CenterX + Cos(NeedleAngle) * (Radius - 20);
      NeedleY := CenterY + Sin(NeedleAngle) * (Radius - 20);

      DrawSuccess := DrawPart('Needle', Bmp, ClientRect, 255);

      if not DrawSuccess then
      begin
        // İbre çiz
        Bmp.DrawLineAntialias(CenterX, CenterY, NeedleX, NeedleY,
          BGRA(244, 67, 54, 255), 3);

        // Merkez daire
        Bmp.FillEllipseAntialias(CenterX, CenterY, 8, 8,
          BGRA(244, 67, 54, 255));
        Bmp.EllipseAntialias(CenterX, CenterY, 8, 8,
          BGRA(200, 0, 0, 255), 2);
      end;
    end;

    // Value text
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := [fsBold];
    Bmp.FontAntialias := True;

    ValueText := IntToStr(FValue);
    TextSize := Bmp.TextSize(ValueText);

    Bmp.TextOut(CenterX - TextSize.cx / 2, CenterY + Radius / 2,
      ValueText, BGRA(64, 64, 64, 255));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

{ TONURKnob }
constructor TONURKnob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 80;
  Height := 80;

  FMin := 0;
  FMax := 100;
  FValue := 50;
  FSensitivity := 1.0;
  FShowValue := True;
  FDiameter := 60;
  FIsDragging := False;
  FAnimatedAngle := 0;

  SkinElement := 'Knob';
end;

procedure TONURKnob.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURKnob.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetValue(FValue);
  Invalidate;
end;

procedure TONURKnob.SetValue(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FValue = AValue then Exit;
  FValue := AValue;

  StartAnimation(oatSlide, 150, oaeEaseOut);

  if Assigned(FOnChange) then
    FOnChange(Self);

  Invalidate;
end;

procedure TONURKnob.SetDiameter(AValue: integer);
begin
  if FDiameter = AValue then Exit;
  FDiameter := AValue;
  Invalidate;
end;

function TONURKnob.ValueToAngle(AValue: single): single;
begin
  // -135° (sol alt) to +135° (sağ alt) = 270° toplam
  Result := -135 + (270 * AValue);
end;

procedure TONURKnob.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetAngle: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetAngle := ValueToAngle((FValue - FMin) / (FMax - FMin));
    FAnimatedAngle := FAnimatedAngle + (TargetAngle - FAnimatedAngle) * Progress;
    Invalidate;
  end;
end;

procedure TONURKnob.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  CenterX, CenterY: single;
  Radius: single;
  AngleRad: single;
  IndicatorX, IndicatorY: single;
  ValueText: string;
  TextSize: TSize;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    CenterX := ClientWidth / 2;
    CenterY := ClientHeight / 2;
    Radius := FDiameter / 2;

    // Base (knob body)
    DrawSuccess := DrawPart('Base', Bmp, Rect(
      Round(CenterX - Radius), Round(CenterY - Radius),
      Round(CenterX + Radius), Round(CenterY + Radius)), 255);

    if not DrawSuccess then
    begin
      // Gradient knob
      Bmp.FillEllipseAntialias(CenterX, CenterY, Radius, Radius,
        BGRA(100, 100, 100, 255));

      Bmp.EllipseAntialias(CenterX, CenterY, Radius, Radius,
        BGRA(80, 80, 80, 255), 2);

      // Highlight
      Bmp.FillEllipseAntialias(CenterX - Radius / 4, CenterY - Radius / 4,
        Radius / 3, Radius / 3,
        BGRA(150, 150, 150, 128));
    end;

    // Indicator (gösterge çizgisi)
    AngleRad := FAnimatedAngle * Pi / 180;
    IndicatorX := CenterX + Cos(AngleRad) * (Radius - 8);
    IndicatorY := CenterY + Sin(AngleRad) * (Radius - 8);

    DrawSuccess := DrawPart('Indicator', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      Bmp.DrawLineAntialias(CenterX, CenterY, IndicatorX, IndicatorY,
        BGRA(255, 255, 255, 255), 3);

      // Indicator dot
      Bmp.FillEllipseAntialias(IndicatorX, IndicatorY, 4, 4,
        BGRA(33, 150, 243, 255));
    end;

    // Value text
    if FShowValue then
    begin
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontStyle := [fsBold];
      Bmp.FontAntialias := True;

      ValueText := IntToStr(FValue);
      TextSize := Bmp.TextSize(ValueText);

      Bmp.TextOut(CenterX - TextSize.cx / 2, CenterY + Radius + 5,
        ValueText, BGRA(64, 64, 64, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

procedure TONURKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FIsDragging := True;
    FDragStartY := Y;
    FDragStartValue := FValue;
  end;
end;

procedure TONURKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
    FIsDragging := False;
end;

procedure TONURKnob.MouseMove(Shift: TShiftState; X, Y: integer);
var
  Delta, NewValue: integer;
  Range: integer;
begin
  inherited MouseMove(Shift, X, Y);

  if FIsDragging then
  begin
    Delta := FDragStartY - Y; // Yukarı = artır
    Range := FMax - FMin;

    NewValue := FDragStartValue + Round(Delta * FSensitivity * Range / 100);
    SetValue(NewValue);
  end;
end;

{ TONURProgressRing }
constructor TONURProgressRing.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 120;

  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FDiameter := 100;
  FLineWidth := 10;
  FShowText := True;
  FStartAngle := -90; // Üstten başla
  FAnimatedPosition := 0;

  SkinElement := 'ProgressRing';
end;

procedure TONURProgressRing.SetMin(AValue: integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetPosition(FPosition);
  Invalidate;
end;

procedure TONURProgressRing.SetMax(AValue: integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetPosition(FPosition);
  Invalidate;
end;

procedure TONURProgressRing.SetPosition(AValue: integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;

  if FPosition = AValue then Exit;
  FPosition := AValue;

  StartAnimation(oatSlide, 300, oaeEaseOut);
  Invalidate;
end;

procedure TONURProgressRing.SetDiameter(AValue: integer);
begin
  if FDiameter = AValue then Exit;
  FDiameter := AValue;
  Invalidate;
end;

procedure TONURProgressRing.AnimationTick(Sender: TObject);
var
  Progress: single;
  TargetPos: single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetPos := (FPosition - FMin) / (FMax - FMin);
    FAnimatedPosition := FAnimatedPosition + (TargetPos - FAnimatedPosition) * Progress;
    Invalidate;
  end;
end;

procedure TONURProgressRing.Paint;
var
  Bmp: TBGRABitmap;
  DrawSuccess: boolean;
  CenterX, CenterY: single;
  Radius: single;
  StartAngleRad, EndAngleRad: single;
  SweepAngle: single;
  Percent: integer;
  PercentText: string;
  TextSize: TSize;
  I: integer;
  StepAngle, CurrentAngle: single;
  X1, Y1, X2, Y2: single;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    CenterX := ClientWidth / 2;
    CenterY := ClientHeight / 2;
    Radius := FDiameter / 2 - FLineWidth / 2;

    // Background ring
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      Bmp.EllipseAntialias(CenterX, CenterY, Radius, Radius,
        BGRA(220, 220, 220, 255), FLineWidth);
    end;

    // Progress arc
    SweepAngle := 360 * FAnimatedPosition;

    DrawSuccess := DrawPart('Fill', Bmp, ClientRect, 255);

    if not DrawSuccess then
    begin
      // Arc çizmek için line segments kullan
      StartAngleRad := FStartAngle * Pi / 180;

      for I := 0 to Round(SweepAngle) do
      begin
        CurrentAngle := StartAngleRad + (I * Pi / 180);

        X1 := CenterX + Cos(CurrentAngle) * Radius;
        Y1 := CenterY + Sin(CurrentAngle) * Radius;

        if I > 0 then
          Bmp.DrawLineAntialias(X2, Y2, X1, Y1, BGRA(33, 150, 243, 255), FLineWidth);

        X2 := X1;
        Y2 := Y1;
      end;
    end;

    // Percent text
    if FShowText then
    begin
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height) * 2
      else
        Bmp.FontHeight := Font.Height * 2;
      Bmp.FontStyle := [fsBold];
      Bmp.FontAntialias := True;

      Percent := Round(FAnimatedPosition * 100);
      PercentText := IntToStr(Percent) + '%';
      TextSize := Bmp.TextSize(PercentText);

      Bmp.TextOut(CenterX - TextSize.cx / 2, CenterY - TextSize.cy / 2,
        PercentText, BGRA(64, 64, 64, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;

end.

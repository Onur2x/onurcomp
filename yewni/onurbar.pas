unit onurbar;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,{$ELSE}unix,LCLIntf, {$ENDIF}
  Classes, SysUtils, Controls, Graphics, LMessages, Math, ExtCtrls,
  BGRABitmap, BGRABitmapTypes, onurctrl;

type
  TONURAutoHide = (oahNever, oahOnMouseLeave, oahAlways);

  { TONURScrollBar }

  TONURScrollBar = class(TONURGraphicControl)
  private
    // Skin Nesneleri
    FBackNormal, FBackHover: TONURCUSTOMCROP;
    FLeftNormal, FLeftHover, FLeftPressed: TONURCUSTOMCROP;
    FRightNormal, FRightHover, FRightPressed: TONURCUSTOMCROP;
    FThumbNormal, FThumbHover, FThumbPressed: TONURCUSTOMCROP;

    // Özellikler
    FMin, FMax: Integer;
    FPosition: Integer;
    FPageSize: Integer;
    FSmallChange: Integer;
    FLargeChange: Integer;
    FAutoHide: TONURAutoHide;
    FShowButtons: Boolean;
    FMinThumbSize: Integer; // Yeni özellik: Minimum Thumb Boyutu
    FOnChange: TNotifyEvent;

    // Durum Değişkenleri
    FIsDragging: Boolean;
    FDragStartPos: Integer;
    FDragStartValue: Integer;
    FMouseOverPart: (mpNone, mpLeftBtn, mpRightBtn, mpThumb, mpTrack);
    FPressedPart: (ppNone, ppLeftBtn, ppRightBtn, ppThumb, ppTrack);
    FIsMouseOver: Boolean;

    // Animasyon (Fade)
    FFadeTimer: TTimer;
    FCurrentAlpha: Byte;
    FTargetAlpha: Byte;

    // Animasyon (Smooth Scroll)
    FScrollTimer: TTimer;
    FTargetPosition: Integer;
    FScrollSpeed: Integer;

    // Hesaplanan Alanlar (Rects)
    FLeftRect: TRect;
    FRightRect: TRect;
    FTrackRect: TRect;
    FThumbRect: TRect;

    // Setter Metodları
    procedure SetMin(AValue: Integer);
    procedure SetMax(AValue: Integer);
    procedure SetPosition(AValue: Integer);
    procedure SetPageSize(AValue: Integer);
    procedure SetAutoHide(AValue: TONURAutoHide);
    procedure SetShowButtons(AValue: Boolean);
    procedure SetMinThumbSize(AValue: Integer); // Yeni setter

    // Yardımcı Metodlar
    procedure UpdateRects;
    function GetTrackSize: Integer;
    function GetThumbSize: Integer;
    function ValueFromPos(APos: Integer): Integer;
    function PosFromValue(AValue: Integer): Integer;
    
    // Animasyon Metodları
    procedure DoFadeTimer(Sender: TObject);
    procedure DoScrollTimer(Sender: TObject); // Yeni timer olayı
    procedure UpdateVisibilityState;
    procedure SmoothScrollTo(ATarget: Integer); // Yeni metod

  protected
    // TONURGraphicControl Override
    procedure Paint; override;
    procedure Resize; override;
    procedure SetKind(AValue: TONURkindstate); override;
    procedure SetSkindata(Aimg: TONURImg); override;

    // Mouse Olayları
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override; // Yeni override

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Align;
    property Anchors;
    property Color;
    property Enabled;
    property Visible;
    property Kind;
    property Skindata;
    property Alpha;

    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 100;
    property Position: Integer read FPosition write SetPosition default 0;
    property PageSize: Integer read FPageSize write SetPageSize default 10;
    property SmallChange: Integer read FSmallChange write FSmallChange default 1;
    property LargeChange: Integer read FLargeChange write FLargeChange default 10;
    property AutoHide: TONURAutoHide read FAutoHide write SetAutoHide default oahNever;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property MinThumbSize: Integer read FMinThumbSize write SetMinThumbSize default 10; // Yeni property

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnResize;
    property OnMouseWheel; // Published yapıldı
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ONUR', [TONURScrollBar]);
end;

{ TONURScrollBar }

constructor TONURScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  // Varsayılan Değerler
  Width := 200;
  Height := 20;
  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FPageSize := 10;
  FSmallChange := 1;
  FLargeChange := 10;
  Kind := oHorizontal;
  SkinName := 'scrollbarh';
  FAutoHide := oahNever;
  FShowButtons := True;
  FMinThumbSize := 10;
  FIsMouseOver := False;
  
  // Animasyon Başlangıç Değerleri
  FCurrentAlpha := 255;
  FTargetAlpha := 255;
  
  FFadeTimer := TTimer.Create(Self);
  FFadeTimer.Enabled := False;
  FFadeTimer.Interval := 16; // ~60 FPS
  FFadeTimer.OnTimer := @DoFadeTimer;

  FScrollTimer := TTimer.Create(Self);
  FScrollTimer.Enabled := False;
  FScrollTimer.Interval := 16;
  FScrollTimer.OnTimer := @DoScrollTimer;

  // Skin Nesneleri Oluşturma (Kullanıcının belirlediği isimler)
  FBackNormal := TONURCUSTOMCROP.Create('NORMAL');
  FBackHover := TONURCUSTOMCROP.Create('HOVER');
  
  FLeftNormal := TONURCUSTOMCROP.Create('LEFTBUTTONNORMAL');
  FLeftHover := TONURCUSTOMCROP.Create('LEFTBUTTONHOVER');
  FLeftPressed := TONURCUSTOMCROP.Create('LEFTBUTTONPRESSED');
  
  FRightNormal := TONURCUSTOMCROP.Create('RIGHTBUTTONNORMAL');
  FRightHover := TONURCUSTOMCROP.Create('RIGHTBUTTONHOVER');
  FRightPressed := TONURCUSTOMCROP.Create('RIGHTBUTTONPRESSED');
  
  FThumbNormal := TONURCUSTOMCROP.Create('CENTERBUTTONNORMAL');
  FThumbHover := TONURCUSTOMCROP.Create('CENTERBUTTONHOVER');
  FThumbPressed := TONURCUSTOMCROP.Create('CENTERBUTTONPRESSED');

  // CustomCropList'e Ekleme
  Customcroplist.Add(FBackNormal);
  Customcroplist.Add(FBackHover);
  Customcroplist.Add(FLeftNormal);
  Customcroplist.Add(FLeftHover);
  Customcroplist.Add(FLeftPressed);
  Customcroplist.Add(FRightNormal);
  Customcroplist.Add(FRightHover);
  Customcroplist.Add(FRightPressed);
  Customcroplist.Add(FThumbNormal);
  Customcroplist.Add(FThumbHover);
  Customcroplist.Add(FThumbPressed);
end;

destructor TONURScrollBar.Destroy;
var
  i: Integer;
begin
  FreeAndNil(FFadeTimer);
  FreeAndNil(FScrollTimer);
  
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;
  Customcroplist.Clear;
  
  inherited Destroy;
end;

procedure TONURScrollBar.SetKind(AValue: TONURkindstate);
var
  Temp: Integer;
begin
  if Kind = AValue then Exit;
  inherited SetKind(AValue);
  
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
  begin
    Temp := Width;
    Width := Height;
    Height := Temp;
    
    if Kind = oHorizontal then
      SkinName := 'scrollbarh'
    else
      SkinName := 'scrollbarv';
  end;
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetMin(AValue: Integer);
begin
  if FMin = AValue then Exit;
  FMin := AValue;
  if FMax < FMin then FMax := FMin;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetMax(AValue: Integer);
begin
  if FMax = AValue then Exit;
  FMax := AValue;
  if FMin > FMax then FMin := FMax;
  SetPosition(FPosition);
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetPosition(AValue: Integer);
begin
  if AValue < FMin then AValue := FMin;
  if AValue > FMax then AValue := FMax;
  
  if FPosition = AValue then Exit;
  FPosition := AValue;
  UpdateRects;
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure TONURScrollBar.SetPageSize(AValue: Integer);
begin
  if FPageSize = AValue then Exit;
  if AValue < 1 then AValue := 1;
  FPageSize := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetAutoHide(AValue: TONURAutoHide);
begin
  if FAutoHide = AValue then Exit;
  FAutoHide := AValue;
  UpdateVisibilityState;
end;

procedure TONURScrollBar.SetShowButtons(AValue: Boolean);
begin
  if FShowButtons = AValue then Exit;
  FShowButtons := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.SetMinThumbSize(AValue: Integer);
begin
  if FMinThumbSize = AValue then Exit;
  if AValue < 5 then AValue := 5; // Güvenlik sınırı
  FMinThumbSize := AValue;
  UpdateRects;
  Invalidate;
end;

procedure TONURScrollBar.UpdateVisibilityState;
begin
  if csDesigning in ComponentState then
  begin
    FTargetAlpha := 255;
  end
  else
  begin
    case FAutoHide of
      oahNever: FTargetAlpha := 255;
      oahOnMouseLeave:
        if FIsMouseOver or FIsDragging then FTargetAlpha := 255 else FTargetAlpha := 0;
      oahAlways: FTargetAlpha := 0;
    end;
    
    if (FAutoHide = oahAlways) and (FIsMouseOver or FIsDragging) then
       FTargetAlpha := 255;
  end;

  if FCurrentAlpha <> FTargetAlpha then
    FFadeTimer.Enabled := True;
end;

procedure TONURScrollBar.DoFadeTimer(Sender: TObject);
var
  Step: Integer;
begin
  Step := 15; // Hız
  
  if FCurrentAlpha < FTargetAlpha then
  begin
    if FTargetAlpha - FCurrentAlpha < Step then
      FCurrentAlpha := FTargetAlpha
    else
      Inc(FCurrentAlpha, Step);
  end
  else if FCurrentAlpha > FTargetAlpha then
  begin
    if FCurrentAlpha - FTargetAlpha < Step then
      FCurrentAlpha := FTargetAlpha
    else
      Dec(FCurrentAlpha, Step);
  end;
  
  Invalidate;
  
  if FCurrentAlpha = FTargetAlpha then
    FFadeTimer.Enabled := False;
end;

procedure TONURScrollBar.SmoothScrollTo(ATarget: Integer);
begin
  FTargetPosition := EnsureRange(ATarget, FMin, FMax);
  if FTargetPosition = FPosition then Exit;
  
  FScrollSpeed := math.Max(1, Abs(FTargetPosition - FPosition) div 10); // Mesafeye göre hız
  FScrollTimer.Enabled := True;
end;

procedure TONURScrollBar.DoScrollTimer(Sender: TObject);
begin
  if FPosition = FTargetPosition then
  begin
    FScrollTimer.Enabled := False;
    Exit;
  end;
  
  if Abs(FTargetPosition - FPosition) <= FScrollSpeed then
    SetPosition(FTargetPosition)
  else if FPosition < FTargetPosition then
    SetPosition(FPosition + FScrollSpeed)
  else
    SetPosition(FPosition - FScrollSpeed);
end;

function TONURScrollBar.GetTrackSize: Integer;
begin
  if Kind = oHorizontal then
    Result := FTrackRect.Right - FTrackRect.Left
  else
    Result := FTrackRect.Bottom - FTrackRect.Top;
end;

function TONURScrollBar.GetThumbSize: Integer;
var
  TrackSize, Range: Integer;
begin
  TrackSize := GetTrackSize;
  Range := (FMax - FMin) + FPageSize;
  
  if Range <= 0 then
    Result := FMinThumbSize
  else
    Result := Round(TrackSize * (FPageSize / Range));
    
  if Result < FMinThumbSize then Result := FMinThumbSize;
  if Result > TrackSize then Result := TrackSize;
end;

function TONURScrollBar.PosFromValue(AValue: Integer): Integer;
var
  TrackStart, TrackLen, ThumbLen: Integer;
  Range: Integer;
begin
  ThumbLen := GetThumbSize;
  Range := FMax - FMin;
  
  if Kind = oHorizontal then
  begin
    TrackStart := FTrackRect.Left;
    TrackLen := (FTrackRect.Right - FTrackRect.Left) - ThumbLen;
  end
  else
  begin
    TrackStart := FTrackRect.Top;
    TrackLen := (FTrackRect.Bottom - FTrackRect.Top) - ThumbLen;
  end;

  if (Range <= 0) or (TrackLen <= 0) then
  begin
    Result := TrackStart;
    Exit;
  end;

  Result := TrackStart + Round(((AValue - FMin) / Range) * TrackLen);
end;

function TONURScrollBar.ValueFromPos(APos: Integer): Integer;
var
  TrackStart, TrackLen, ThumbLen, PixelOffset: Integer;
  Range: Integer;
begin
  ThumbLen := GetThumbSize;
  
  if Kind = oHorizontal then
  begin
    TrackStart := FTrackRect.Left;
    TrackLen := (FTrackRect.Right - FTrackRect.Left) - ThumbLen;
    PixelOffset := APos - TrackStart - (ThumbLen div 2);
  end
  else
  begin
    TrackStart := FTrackRect.Top;
    TrackLen := (FTrackRect.Bottom - FTrackRect.Top) - ThumbLen;
    PixelOffset := APos - TrackStart - (ThumbLen div 2);
  end;

  if TrackLen <= 0 then
  begin
    Result := FMin;
    Exit;
  end;

  Range := FMax - FMin;
  Result := FMin + Round((PixelOffset / TrackLen) * Range);
  
  if Result < FMin then Result := FMin;
  if Result > FMax then Result := FMax;
end;

procedure TONURScrollBar.UpdateRects;
var
  BtnSize: Integer;
  ThumbLen, ThumbPos: Integer;
begin
  if Kind = oHorizontal then
  begin
    if FShowButtons then
      BtnSize := Height
    else
      BtnSize := 0;
      
    FLeftRect := Rect(0, 0, BtnSize, Height);
    FRightRect := Rect(Width - BtnSize, 0, Width, Height);
    FTrackRect := Rect(BtnSize, 0, Width - BtnSize, Height);
    
    ThumbLen := GetThumbSize;
    ThumbPos := PosFromValue(FPosition);
    FThumbRect := Rect(ThumbPos, 0, ThumbPos + ThumbLen, Height);
  end
  else
  begin
    if FShowButtons then
      BtnSize := Width
    else
      BtnSize := 0;
      
    FLeftRect := Rect(0, 0, Width, BtnSize);
    FRightRect := Rect(0, Height - BtnSize, Width, Height);
    FTrackRect := Rect(0, BtnSize, Width, Height - BtnSize);
    
    ThumbLen := GetThumbSize;
    ThumbPos := PosFromValue(FPosition);
    FThumbRect := Rect(0, ThumbPos, Width, ThumbPos + ThumbLen);
  end;
end;

procedure TONURScrollBar.Paint;
var
  CurrentBack, CurrentLeft, CurrentRight, CurrentThumb: TONURCUSTOMCROP;
  FinalAlpha: Byte;
begin
  if not Visible then Exit;
  
  // Eğer tamamen görünmezse ve tasarım modunda değilsek çizme
  if (FCurrentAlpha = 0) and not (csDesigning in ComponentState) then Exit;

  resim.SetSize(ClientWidth, ClientHeight);
  resim.Fill(BGRAPixelTransparent);

  // Alpha hesaplama: Bileşenin kendi Alpha'sı ile animasyon Alpha'sını birleştir
  FinalAlpha := Round((Alpha / 255) * FCurrentAlpha);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // 1. Arka Plan
    if FMouseOverPart <> mpNone then CurrentBack := FBackHover else CurrentBack := FBackNormal;
    if (CurrentBack <> nil) and (CurrentBack.CropRect.Width > 0) then
      DrawPartnormal(CurrentBack.CropRect, Self, ClientRect, FinalAlpha);

    // 2. Sol/Yukarı Buton (Sadece ShowButtons True ise)
    if FShowButtons then
    begin
      if FPressedPart = ppLeftBtn then CurrentLeft := FLeftPressed
      else if FMouseOverPart = mpLeftBtn then CurrentLeft := FLeftHover
      else CurrentLeft := FLeftNormal;
      
      if (CurrentLeft <> nil) and (CurrentLeft.CropRect.Width > 0) then
        DrawPartnormal(CurrentLeft.CropRect, Self, FLeftRect, FinalAlpha);
    end;

    // 3. Sağ/Aşağı Buton (Sadece ShowButtons True ise)
    if FShowButtons then
    begin
      if FPressedPart = ppRightBtn then CurrentRight := FRightPressed
      else if FMouseOverPart = mpRightBtn then CurrentRight := FRightHover
      else CurrentRight := FRightNormal;
      
      if (CurrentRight <> nil) and (CurrentRight.CropRect.Width > 0) then
        DrawPartnormal(CurrentRight.CropRect, Self, FRightRect, FinalAlpha);
    end;

    // 4. Thumb
    if FPressedPart = ppThumb then CurrentThumb := FThumbPressed
    else if FMouseOverPart = mpThumb then CurrentThumb := FThumbHover
    else CurrentThumb := FThumbNormal;
    
    if (CurrentThumb <> nil) and (CurrentThumb.CropRect.Width > 0) then
      DrawPartnormal(CurrentThumb.CropRect, Self, FThumbRect, FinalAlpha);
  end
  else
  begin
    // Fallback Çizim
    resim.FillRect(ClientRect, BGRA(240, 240, 240, FinalAlpha), dmSet);
    if FShowButtons then
    begin
      resim.FillRect(FLeftRect, BGRA(200, 200, 200, FinalAlpha), dmSet);
      resim.FillRect(FRightRect, BGRA(200, 200, 200, FinalAlpha), dmSet);
    end;
    resim.FillRect(FThumbRect, BGRA(160, 160, 160, FinalAlpha), dmSet);
    resim.Rectangle(ClientRect, BGRA(100, 100, 100, FinalAlpha), dmSet);
  end;
  
  inherited Paint;
end;

procedure TONURScrollBar.Resize;
begin
  inherited Resize;
  UpdateRects;
end;

procedure TONURScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickPos: Integer;
begin
  if not Enabled then Exit;
  // Görünürlük kontrolü (tamamen görünmezse tıklama alma)
  if (FCurrentAlpha = 0) and not (csDesigning in ComponentState) then Exit;
  
  inherited MouseDown(Button, Shift, X, Y);
  
  if Button = mbLeft then
  begin
    // Animasyonu durdur (kullanıcı müdahalesi)
    FScrollTimer.Enabled := False;
    
    if PtInRect(FThumbRect, Point(X, Y)) then
    begin
      FPressedPart := ppThumb;
      FIsDragging := True;
      if Kind = oHorizontal then FDragStartPos := X else FDragStartPos := Y;
      FDragStartValue := FPosition;
    end
    else if FShowButtons and PtInRect(FLeftRect, Point(X, Y)) then
    begin
      FPressedPart := ppLeftBtn;
      SetPosition(FPosition - FSmallChange);
    end
    else if FShowButtons and PtInRect(FRightRect, Point(X, Y)) then
    begin
      FPressedPart := ppRightBtn;
      SetPosition(FPosition + FSmallChange);
    end
    else if PtInRect(FTrackRect, Point(X, Y)) then
    begin
      FPressedPart := ppTrack;
      if Kind = oHorizontal then ClickPos := X else ClickPos := Y;
      // Smooth Scroll ile git
      SmoothScrollTo(ValueFromPos(ClickPos));
    end;
    
    Invalidate;
  end;
end;

procedure TONURScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Enabled then Exit;
  inherited MouseUp(Button, Shift, X, Y);
  
  if Button = mbLeft then
  begin
    FIsDragging := False;
    FPressedPart := ppNone;
    Invalidate;
  end;
end;

procedure TONURScrollBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Delta, NewPos, MousePos: Integer;
  TrackLen, Range: Integer;
begin
  if not Enabled then Exit;
  inherited MouseMove(Shift, X, Y);
  
  // Hover Durumu
  if PtInRect(FThumbRect, Point(X, Y)) then FMouseOverPart := mpThumb
  else if FShowButtons and PtInRect(FLeftRect, Point(X, Y)) then FMouseOverPart := mpLeftBtn
  else if FShowButtons and PtInRect(FRightRect, Point(X, Y)) then FMouseOverPart := mpRightBtn
  else if PtInRect(FTrackRect, Point(X, Y)) then FMouseOverPart := mpTrack
  else FMouseOverPart := mpNone;
  
  // Sürükleme
  if FIsDragging then
  begin
    if Kind = oHorizontal then MousePos := X else MousePos := Y;
    Delta := MousePos - FDragStartPos;
    
    if Kind = oHorizontal then
      TrackLen := (FTrackRect.Right - FTrackRect.Left) - GetThumbSize
    else
      TrackLen := (FTrackRect.Bottom - FTrackRect.Top) - GetThumbSize;
      
    if TrackLen > 0 then
    begin
      Range := FMax - FMin;
      NewPos := FDragStartValue + Round((Delta / TrackLen) * Range);
      SetPosition(NewPos);
    end;
  end;
  
  Invalidate;
end;

procedure TONURScrollBar.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  UpdateVisibilityState;
  Invalidate;
end;

procedure TONURScrollBar.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FMouseOverPart := mpNone;
  FIsDragging := False;
  FPressedPart := ppNone;
  UpdateVisibilityState;
  Invalidate;
end;

function TONURScrollBar.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if not Result then
  begin
    if WheelDelta < 0 then
      SetPosition(FPosition + FSmallChange)
    else
      SetPosition(FPosition - FSmallChange);
    Result := True;
  end;
end;

end.

unit onur9slice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls,
  BGRABitmap, BGRABitmapTypes, BGRACanvas,
  onurctrl,Windows, Types;

type
  { TONUR9SliceScaling - 9 Slice Scaling için optimize edilmiş class }
  TONUR9SliceScaling = class(TONURPersistent)
  private
    FCropLeft, FCropTop, FCropRight, FCropBottom: Integer;
    FLeft, FTopleft, FBottomleft, FRight, FTopRight,
    FBottomRight, FTop, FBottom, FCenter: TONURCustomCrop;
    
    procedure SetCropLeft(AValue: Integer);
    procedure SetCropTop(AValue: Integer);
    procedure SetCropRight(AValue: Integer);
    procedure SetCropBottom(AValue: Integer);
    
    function GetCropRects: TRect;
    procedure CalculateTargetRects(const AWidth, AHeight: Integer);
    
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    
    procedure SetCropMargins(ALeft, ATop, ARight, ABottom: Integer);
    procedure Draw9Slice(Target: TBGRABitmap; const SourceRect: TRect; 
                        const TargetRect: TRect; Opacity: Byte = 255);
    procedure Draw9SliceControl(Control: TONURCustomControl; const SourceRect: TRect;
                               const TargetRect: TRect; Opacity: Byte = 255);
    procedure Draw9SliceGraphic(Control: TONURGraphicControl; const SourceRect: TRect;
                                const TargetRect: TRect; Opacity: Byte = 255);
    
    property CropRects: TRect read GetCropRects;
  published
    property CropLeft: Integer read FCropLeft write SetCropLeft default 10;
    property CropTop: Integer read FCropTop write SetCropTop default 10;
    property CropRight: Integer read FCropRight write SetCropRight default 10;
    property CropBottom: Integer read FCropBottom write SetCropBottom default 10;
  end;

  { TONURSkin9Slice - TCustomControl'den türeyen 9 slice bileşeni }
  TONURSkin9Slice = class(TONURCustomControl)
  private
    F9Slice: TONUR9SliceScaling;
    FSourceRect: TRect;
    
    procedure Set9Slice(AValue: TONUR9SliceScaling);
    procedure SetSourceRect(AValue: TRect);
    procedure SetSourceLeft(AValue: Integer);
    procedure SetSourceTop(AValue: Integer);
    procedure SetSourceRight(AValue: Integer);
    procedure SetSourceBottom(AValue: Integer);
    
  protected
    procedure Paint; override;
    procedure Resize; override;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
  published
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property Skindata;
    property Skinname;
    property Alpha;
    
    property NineSlice: TONUR9SliceScaling read F9Slice write Set9Slice;
    property SourceLeft: Integer read FSourceRect.Left write SetSourceLeft;
    property SourceTop: Integer read FSourceRect.Top write SetSourceTop;
    property SourceRight: Integer read FSourceRect.Right write SetSourceRight;
    property SourceBottom: Integer read FSourceRect.Bottom write SetSourceBottom;
    
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

  { TONURSkin9SliceGraphic - TGraphicsControl'den türeyen 9 slice bileşeni }
  TONURSkin9SliceGraphic = class(TONURGraphicControl)
  private
    F9Slice: TONUR9SliceScaling;
    FSourceRect: TRect;
    
    procedure Set9Slice(AValue: TONUR9SliceScaling);
    procedure SetSourceRect(AValue: TRect);
    procedure SetSourceLeft(AValue: Integer);
    procedure SetSourceTop(AValue: Integer);
    procedure SetSourceRight(AValue: Integer);
    procedure SetSourceBottom(AValue: Integer);
    
  protected
    procedure Paint; override;
    procedure Resize; override;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
  published
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property Skindata;
    property Skinname;
    property Alpha;
    
    property NineSlice: TONUR9SliceScaling read F9Slice write Set9Slice;
    property SourceLeft: Integer read FSourceRect.Left write SetSourceLeft;
    property SourceTop: Integer read FSourceRect.Top write SetSourceTop;
    property SourceRight: Integer read FSourceRect.Right write SetSourceRight;
    property SourceBottom: Integer read FSourceRect.Bottom write SetSourceBottom;
    
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ONUR', [TONURSkin9Slice, TONURSkin9SliceGraphic]);
end;

{ TONUR9SliceScaling }

constructor TONUR9SliceScaling.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FCropLeft := 10;
  FCropTop := 10;
  FCropRight := 10;
  FCropBottom := 10;
  
  // 9 slice crop alanlari olustur
  FTopleft := TONURCustomCrop.Create('TOPLEFT');
  FTop := TONURCustomCrop.Create('TOP');
  FTopRight := TONURCustomCrop.Create('TOPRIGHT');
  FLeft := TONURCustomCrop.Create('LEFT');
  FCenter := TONURCustomCrop.Create('CENTER');
  FRight := TONURCustomCrop.Create('RIGHT');
  FBottomleft := TONURCustomCrop.Create('BOTTOMLEFT');
  FBottom := TONURCustomCrop.Create('BOTTOM');
  FBottomRight := TONURCustomCrop.Create('BOTTOMRIGHT');
end;

destructor TONUR9SliceScaling.Destroy;
begin
  FTopleft.Free;
  FTop.Free;
  FTopRight.Free;
  FLeft.Free;
  FCenter.Free;
  FRight.Free;
  FBottomleft.Free;
  FBottom.Free;
  FBottomRight.Free;
  inherited Destroy;
end;

procedure TONUR9SliceScaling.SetCropLeft(AValue: Integer);
begin
  if FCropLeft <> AValue then
  begin
    FCropLeft := AValue;
    CalculateTargetRects(0, 0); // Width ve Height daha sonra set edilir
  end;
end;

procedure TONUR9SliceScaling.SetCropTop(AValue: Integer);
begin
  if FCropTop <> AValue then
  begin
    FCropTop := AValue;
    CalculateTargetRects(0, 0);
  end;
end;

procedure TONUR9SliceScaling.SetCropRight(AValue: Integer);
begin
  if FCropRight <> AValue then
  begin
    FCropRight := AValue;
    CalculateTargetRects(0, 0);
  end;
end;

procedure TONUR9SliceScaling.SetCropBottom(AValue: Integer);
begin
  if FCropBottom <> AValue then
  begin
    FCropBottom := AValue;
    CalculateTargetRects(0, 0);
  end;
end;

function TONUR9SliceScaling.GetCropRects: TRect;
begin
  Result.Left := FCropLeft;
  Result.Top := FCropTop;
  Result.Right := FCropRight;
  Result.Bottom := FCropBottom;
end;

procedure TONUR9SliceScaling.SetCropMargins(ALeft, ATop, ARight, ABottom: Integer);
begin
  FCropLeft := ALeft;
  FCropTop := ATop;
  FCropRight := ARight;
  FCropBottom := ABottom;
  CalculateTargetRects(0, 0);
end;

procedure TONUR9SliceScaling.CalculateTargetRects(const AWidth, AHeight: Integer);
var
  MiddleWidth, MiddleHeight: Integer;
begin
  if (AWidth = 0) or (AHeight = 0) then Exit;
  
  MiddleWidth := AWidth - FCropLeft - FCropRight;
  MiddleHeight := AHeight - FCropTop - FCropBottom;
  
  // Corners - fixed size
  FTopleft.Targetrect := types.Rect(0, 0, FCropLeft, FCropTop);
  FTopRight.Targetrect := types.Rect(AWidth - FCropRight, 0, AWidth, FCropTop);
  FBottomleft.Targetrect := types.Rect(0, AHeight - FCropBottom, FCropLeft, AHeight);
  FBottomRight.Targetrect := types.Rect(AWidth - FCropRight, AHeight - FCropBottom, AWidth, AHeight);
  
  // Edges - flexible size
  FTop.Targetrect := Rect(FCropLeft, 0, AWidth - FCropRight, FCropTop);
  FBottom.Targetrect := Rect(FCropLeft, AHeight - FCropBottom, AWidth - FCropRight, AHeight);
  FLeft.Targetrect := Rect(0, FCropTop, FCropLeft, AHeight - FCropBottom);
  FRight.Targetrect := Rect(AWidth - FCropRight, FCropTop, AWidth, AHeight - FCropBottom);
  
  // Center - flexible size
  if (MiddleWidth > 0) and (MiddleHeight > 0) then
    FCenter.Targetrect := Rect(FCropLeft, FCropTop, AWidth - FCropRight, AHeight - FCropBottom)
  else
    FCenter.Targetrect := Rect(0, 0, 0, 0);
end;

procedure TONUR9SliceScaling.Draw9Slice(Target: TBGRABitmap; const SourceRect: TRect; 
                                       const TargetRect: TRect; Opacity: Byte);
var
  SourceWidth, SourceHeight: Integer;
  TargetWidth, TargetHeight: Integer;
  MiddleWidth, MiddleHeight: Integer;
begin
  SourceWidth := SourceRect.Right - SourceRect.Left;
  SourceHeight := SourceRect.Bottom - SourceRect.Top;
  TargetWidth := TargetRect.Right - TargetRect.Left;
  TargetHeight := TargetRect.Bottom - TargetRect.Top;
  
  // Crop alanlarini source resme gore ayarla
  FTopleft.Croprect := Rect(SourceRect.Left, SourceRect.Top, 
                          SourceRect.Left + FCropLeft, SourceRect.Top + FCropTop);
  FTop.Croprect := Rect(SourceRect.Left + FCropLeft, SourceRect.Top,
                       SourceRect.Right - FCropRight, SourceRect.Top + FCropTop);
  FTopRight.Croprect := Rect(SourceRect.Right - FCropRight, SourceRect.Top,
                            SourceRect.Right, SourceRect.Top + FCropTop);
  FLeft.Croprect := Rect(SourceRect.Left, SourceRect.Top + FCropTop,
                        SourceRect.Left + FCropLeft, SourceRect.Bottom - FCropBottom);
  FCenter.Croprect := Rect(SourceRect.Left + FCropLeft, SourceRect.Top + FCropTop,
                          SourceRect.Right - FCropRight, SourceRect.Bottom - FCropBottom);
  FRight.Croprect := Rect(SourceRect.Right - FCropRight, SourceRect.Top + FCropTop,
                         SourceRect.Right, SourceRect.Bottom - FCropBottom);
  FBottomleft.Croprect := Rect(SourceRect.Left, SourceRect.Bottom - FCropBottom,
                             SourceRect.Left + FCropLeft, SourceRect.Bottom);
  FBottom.Croprect := Rect(SourceRect.Left + FCropLeft, SourceRect.Bottom - FCropBottom,
                          SourceRect.Right - FCropRight, SourceRect.Bottom);
  FBottomRight.Croprect := Rect(SourceRect.Right - FCropRight, SourceRect.Bottom - FCropBottom,
                               SourceRect.Right, SourceRect.Bottom);
  
  // Target alanlarini hesapla
  CalculateTargetRects(TargetWidth, TargetHeight);
  
  // 9 parcayi ciz - mevcut DrawPartnormali fonksiyonlarini kullanarak
  if Assigned(owner) and (owner is TONURImg) then
  begin
    // Koseler
    DrawPartnormali(TONURCustomControl(owner), FTopleft.Croprect, Target, TargetRect.Left, TargetRect.Top, 
                    FTopleft.Targetrect.Width, FTopleft.Targetrect.Height, Opacity);
    DrawPartnormali(TONURCustomControl(owner), FTopRight.Croprect, Target, 
                    TargetRect.Right - FTopRight.Targetrect.Width, TargetRect.Top,
                    FTopRight.Targetrect.Width, FTopRight.Targetrect.Height, Opacity);
    DrawPartnormali(TONURCustomControl(owner), FBottomleft.Croprect, Target,
                    TargetRect.Left, TargetRect.Bottom - FBottomleft.Targetrect.Height,
                    FBottomleft.Targetrect.Width, FBottomleft.Targetrect.Height, Opacity);
    DrawPartnormali(TONURCustomControl(owner), FBottomRight.Croprect, Target,
                    TargetRect.Right - FBottomRight.Targetrect.Width, 
                    TargetRect.Bottom - FBottomRight.Targetrect.Height,
                    FBottomRight.Targetrect.Width, FBottomRight.Targetrect.Height, Opacity);
    
    // Kenarlar
    if FTop.Targetrect.Width > 0 then
      DrawPartnormali(TONURCustomControl(owner), FTop.Croprect, Target, TargetRect.Left + FCropLeft, TargetRect.Top,
                      FTop.Targetrect.Width, FTop.Targetrect.Height, Opacity);
    
    if FBottom.Targetrect.Width > 0 then
      DrawPartnormali(TONURCustomControl(owner), FBottom.Croprect, Target, TargetRect.Left + FCropLeft, 
                      TargetRect.Bottom - FCropBottom,
                      FBottom.Targetrect.Width, FBottom.Targetrect.Height, Opacity);
    
    if FLeft.Targetrect.Height > 0 then
      DrawPartnormali(TONURCustomControl(owner), FLeft.Croprect, Target, TargetRect.Left, TargetRect.Top + FCropTop,
                      FLeft.Targetrect.Width, FLeft.Targetrect.Height, Opacity);
    
    if FRight.Targetrect.Height > 0 then
      DrawPartnormali(TONURCustomControl(owner), FRight.Croprect, Target, TargetRect.Right - FCropRight, 
                      TargetRect.Top + FCropTop,
                      FRight.Targetrect.Width, FRight.Targetrect.Height, Opacity);
    
    // Merkez
    if (FCenter.Targetrect.Width > 0) and (FCenter.Targetrect.Height > 0) then
      DrawPartnormali(TONURCustomControl(owner), FCenter.Croprect, Target, TargetRect.Left + FCropLeft, 
                      TargetRect.Top + FCropTop,
                      FCenter.Targetrect.Width, FCenter.Targetrect.Height, Opacity);
  end;
end;

procedure TONUR9SliceScaling.Draw9SliceControl(Control: TONURCustomControl; 
                                              const SourceRect: TRect;
                                              const TargetRect: TRect; Opacity: Byte);
begin
  if Assigned(Control.Skindata) and Assigned(Control.Skindata.Fimage) then
  begin
    owner := Control.Skindata;
    Draw9Slice(Control.resim, SourceRect, TargetRect, Opacity);
  end;
end;

procedure TONUR9SliceScaling.Draw9SliceGraphic(Control: TONURGraphicControl; 
                                               const SourceRect: TRect;
                                               const TargetRect: TRect; Opacity: Byte);
begin
  if Assigned(Control.Skindata) and Assigned(Control.Skindata.Fimage) then
  begin
    owner := Control.Skindata;
    Draw9Slice(Control.resim, SourceRect, TargetRect, Opacity);
  end;
end;

{ TONURSkin9Slice }

constructor TONURSkin9Slice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  F9Slice := TONUR9SliceScaling.Create(Self);
  FSourceRect := Rect(0, 0, 100, 100);
  Skinname := 'skin9slice';
end;

destructor TONURSkin9Slice.Destroy;
begin
  F9Slice.Free;
  inherited Destroy;
end;

procedure TONURSkin9Slice.Set9Slice(AValue: TONUR9SliceScaling);
begin
  if F9Slice <> AValue then
  begin
    F9Slice := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.SetSourceRect(AValue: TRect);
begin
  if FSourceRect <> AValue then
  begin
    FSourceRect := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.SetSourceLeft(AValue: Integer);
begin
  if FSourceRect.Left <> AValue then
  begin
    FSourceRect.Left := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.SetSourceTop(AValue: Integer);
begin
  if FSourceRect.Top <> AValue then
  begin
    FSourceRect.Top := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.SetSourceRight(AValue: Integer);
begin
  if FSourceRect.Right <> AValue then
  begin
    FSourceRect.Right := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.SetSourceBottom(AValue: Integer);
begin
  if FSourceRect.Bottom <> AValue then
  begin
    FSourceRect.Bottom := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9Slice.Paint;
begin
  inherited Paint;
  if Assigned(Skindata) and Assigned(Skindata.Fimage) and Assigned(F9Slice) then
  begin
    F9Slice.Draw9SliceControl(Self, FSourceRect, ClientRect, Alpha);
  end;
end;

procedure TONURSkin9Slice.Resize;
begin
  inherited Resize;
  Invalidate;
end;

{ TONURSkin9SliceGraphic }

constructor TONURSkin9SliceGraphic.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  F9Slice := TONUR9SliceScaling.Create(Self);
  FSourceRect := Rect(0, 0, 100, 100);
  Skinname := 'skin9slicegraphic';
end;

destructor TONURSkin9SliceGraphic.Destroy;
begin
  F9Slice.Free;
  inherited Destroy;
end;

procedure TONURSkin9SliceGraphic.Set9Slice(AValue: TONUR9SliceScaling);
begin
  if F9Slice <> AValue then
  begin
    F9Slice := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.SetSourceRect(AValue: TRect);
begin
  if FSourceRect <> AValue then
  begin
    FSourceRect := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.SetSourceLeft(AValue: Integer);
begin
  if FSourceRect.Left <> AValue then
  begin
    FSourceRect.Left := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.SetSourceTop(AValue: Integer);
begin
  if FSourceRect.Top <> AValue then
  begin
    FSourceRect.Top := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.SetSourceRight(AValue: Integer);
begin
  if FSourceRect.Right <> AValue then
  begin
    FSourceRect.Right := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.SetSourceBottom(AValue: Integer);
begin
  if FSourceRect.Bottom <> AValue then
  begin
    FSourceRect.Bottom := AValue;
    Invalidate;
  end;
end;

procedure TONURSkin9SliceGraphic.Paint;
begin
  inherited Paint;
  if Assigned(Skindata) and Assigned(Skindata.Fimage) and Assigned(F9Slice) then
  begin
    F9Slice.Draw9SliceGraphic(Self, FSourceRect, ClientRect, Alpha);
  end;
end;

procedure TONURSkin9SliceGraphic.Resize;
begin
  inherited Resize;
  Invalidate;
end;

end.

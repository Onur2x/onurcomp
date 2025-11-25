unit onurbutton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls,ExtCtrls ,Graphics, LMessages, Math,
  BGRABitmap, BGRABitmapTypes, onurskin,menus
  {$IFDEF WINDOWS}, Windows{$ELSE},unix{$ENDIF},Types; // Region için

type
  TONURButtonState = (obsNormal, obsHover, obsPressed, obsDisabled);
  TONURSystemButtonType = (osbtClose, osbtMinimize, osbtMaximize, osbtHelp, osbtCustom);
  TONURIconPosition = (ipLeft, ipRight, ipTop, ipBottom);
  TCheckBoxState = (cbUnchecked, cbChecked, cbGrayed);
  TONURCaptionPosition = (cpLeft, cpRight);
  TONURBadgePosition = (bpTopRight, bpTopLeft, bpBottomRight, bpBottomLeft);

  { TONURSystemButton }
  TONURSystemButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FButtonType: TONURSystemButtonType;
    FAnimatedAlpha: Byte;
    FAutoAction: Boolean; // Otomatik form işlemi yapsın mı?

    procedure AnimationTick(Sender: TObject);
    procedure SetButtonType(AValue: TONURSystemButtonType);
    procedure SetAutoAction(AValue: Boolean);
    procedure ExecuteAction;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property ButtonType: TONURSystemButtonType read FButtonType write SetButtonType default osbtClose;
    property AutoAction: Boolean read FAutoAction write SetAutoAction default True;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TONURCropButton }
  // Resmin şekline göre tıklanabilir alan oluşturan buton
  TONURCropButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FColor: TColor;
    FHoverColor: TColor;
    FPressedColor: TColor;
    FAnimatedAlpha: Byte;
    FUseRegion: Boolean; // Pencere şeklini değiştir
    FCurrentRegion: HRGN;

    procedure AnimationTick(Sender: TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetColor(AValue: TColor);
    procedure SetHoverColor(AValue: TColor);
    procedure SetPressedColor(AValue: TColor);
    procedure SetUseRegion(AValue: Boolean);
    procedure UpdateRegion;
    function IsPixelTransparent(X, Y: Integer): Boolean;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;

    property Color: TColor read FColor write SetColor default $00F0F0F0;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00E0E0E0;
    property PressedColor: TColor read FPressedColor write SetPressedColor default $00C0C0C0;

    property UseRegion: Boolean read FUseRegion write SetUseRegion default False;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;


  { TONURButton }

  TONURButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FColor: TColor;
    FHoverColor: TColor;
    FPressedColor: TColor;
    FAnimatedAlpha: Byte; // Animasyonlu alpha değeri
    procedure AnimationTick(Sender:TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetColor(AValue: TColor);
    procedure SetHoverColor(AValue: TColor);
    procedure SetPressedColor(AValue: TColor);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure TextChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;
    
    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    
    // Fallback Renkleri (Skin yoksa kullanılacak)
    property Color: TColor read FColor write SetColor default $00F0F0F0; // Açık Gri
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00E0E0E0;
    property PressedColor: TColor read FPressedColor write SetPressedColor default $00C0C0C0;
    
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TONURToggleButton }
  TONURToggleButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FChecked: Boolean;
    FAnimatedAlpha: Byte;
    FAnimatedPosition: Single; // 0.0 (OFF) - 1.0 (ON) arası kayma animasyonu
    FOnCaption: string;
    FOffCaption: string;
    FShowCaption: Boolean;
    FOnChange: TNotifyEvent;

    procedure AnimationTick(Sender: TObject);
    procedure SetChecked(AValue: Boolean);
    procedure SetOnCaption(AValue: string);
    procedure SetOffCaption(AValue: string);
    procedure SetShowCaption(AValue: Boolean);
    procedure DoOnChange;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Checked: Boolean read FChecked write SetChecked default False;
    property OnCaption: string read FOnCaption write SetOnCaption;
    property OffCaption: string read FOffCaption write SetOffCaption;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TONURIconButton }
  TONURIconButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FIcon: TBGRABitmap;
    FIconPosition: TONURIconPosition;
    FIconSize: Integer;
    FIconSpacing: Integer;
    FAnimatedAlpha: Byte;

    procedure AnimationTick(Sender: TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetIcon(AValue: TBGRABitmap);
    procedure SetIconPosition(AValue: TONURIconPosition);
    procedure SetIconSize(AValue: Integer);
    procedure SetIconSpacing(AValue: Integer);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property Icon: TBGRABitmap read FIcon write SetIcon;
    property IconPosition: TONURIconPosition read FIconPosition write SetIconPosition default ipLeft;
    property IconSize: Integer read FIconSize write SetIconSize default 24;
    property IconSpacing: Integer read FIconSpacing write SetIconSpacing default 8;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TONURFloatingButton }
  TONURFloatingButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FIcon: TBGRABitmap;
    FIconSize: Integer;
    FShadowSize: Integer;
    FHoverScale: Single;
    FAnimatedAlpha: Byte;
    FAnimatedScale: Single;

    procedure AnimationTick(Sender: TObject);
    procedure SetIcon(AValue: TBGRABitmap);
    procedure SetIconSize(AValue: Integer);
    procedure SetShadowSize(AValue: Integer);
    procedure SetHoverScale(AValue: Single);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Icon: TBGRABitmap read FIcon write SetIcon;
    property IconSize: Integer read FIconSize write SetIconSize default 24;
    property ShadowSize: Integer read FShadowSize write SetShadowSize default 4;
    property HoverScale: Single read FHoverScale write SetHoverScale; // 1.0 - 1.2

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

   { TONURCheckBox }
  TONURCheckBox = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FCheckState: TCheckBoxState;
    FAllowGrayed: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FCaptionPosition: TONURCaptionPosition;
    FCheckSize: Integer;
    FCheckSpacing: Integer;
    FAnimatedAlpha: Byte;
    FOnChange: TNotifyEvent;

    procedure AnimationTick(Sender: TObject);
    procedure SetCheckState(AValue: TCheckBoxState);
    procedure SetCaption(AValue: string);
    procedure SetCaptionPosition(AValue: TONURCaptionPosition);
    procedure SetCheckSize(AValue: Integer);
    function GetChecked: Boolean;
    procedure SetChecked(AValue: Boolean);
    procedure DoOnChange;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Checked: Boolean read GetChecked write SetChecked default False;
    property State: TCheckBoxState read FCheckState write SetCheckState default cbUnchecked;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write FFontColor default clBlack;
    property CaptionPosition: TONURCaptionPosition read FCaptionPosition write SetCaptionPosition default cpRight;
    property CheckSize: Integer read FCheckSize write SetCheckSize default 20;
    property CheckSpacing: Integer read FCheckSpacing write FCheckSpacing default 8;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
  end;

   { TONURRadioButton }
  TONURRadioButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FChecked: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FCaptionPosition: TONURCaptionPosition;
    FCheckSize: Integer;
    FCheckSpacing: Integer;
    FAnimatedAlpha: Byte;
    FOnChange: TNotifyEvent;

    procedure AnimationTick(Sender: TObject);
    procedure SetChecked(AValue: Boolean);
    procedure SetCaption(AValue: string);
    procedure SetCaptionPosition(AValue: TONURCaptionPosition);
    procedure SetCheckSize(AValue: Integer);
    procedure DoOnChange;
    procedure UncheckOthers; // Aynı parent'taki diğer radio butonları kapat
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Checked: Boolean read FChecked write SetChecked default False;
    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write FFontColor default clBlack;
    property CaptionPosition: TONURCaptionPosition read FCaptionPosition write SetCaptionPosition default cpRight;
    property CheckSize: Integer read FCheckSize write SetCheckSize default 20;
    property CheckSpacing: Integer read FCheckSpacing write FCheckSpacing default 8;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
  end;

  { TONURSplitButton }
  TONURSplitButton = class(TONURSkinCustomControl)
  private
    FMainState: TONURButtonState;
    FDropdownState: TONURButtonState;
    FIsMainMouseOver: Boolean;
    FIsDropdownMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FDropdownMenu: TPopupMenu;
    FDropdownWidth: Integer;
    FAnimatedAlpha: Byte;

    procedure AnimationTick(Sender: TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetDropdownMenu(AValue: TPopupMenu);
    procedure SetDropdownWidth(AValue: Integer);
    function GetMainRect: TRect;
    function GetDropdownRect: TRect;
    function IsPointInMain(X, Y: Integer): Boolean;
    function IsPointInDropdown(X, Y: Integer): Boolean;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property DropdownWidth: Integer read FDropdownWidth write SetDropdownWidth default 30;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;
 { TONURBadgeButton }
  TONURBadgeButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FBadgeCount: Integer;
    FBadgeVisible: Boolean;
    FBadgeColor: TColor;
    FBadgePosition: TONURBadgePosition;
    FAnimatedAlpha: Byte;
    FBadgePulse: Single; // Pulse animasyonu için

    procedure AnimationTick(Sender: TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetBadgeCount(AValue: Integer);
    procedure SetBadgeVisible(AValue: Boolean);
    procedure SetBadgeColor(AValue: TColor);
    procedure SetBadgePosition(AValue: TONURBadgePosition);
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property BadgeCount: Integer read FBadgeCount write SetBadgeCount default 0;
    property BadgeVisible: Boolean read FBadgeVisible write SetBadgeVisible default True;
    property BadgeColor: TColor read FBadgeColor write SetBadgeColor default clRed;
    property BadgePosition: TONURBadgePosition read FBadgePosition write SetBadgePosition default bpTopRight;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;
  { TONURSegmentedButton }
  TONURSegmentedButton = class(TONURSkinCustomControl)
  private
    FSegments: TStringList;
    FSelectedIndex: Integer;
    FEqualWidth: Boolean;
    FSegmentSpacing: Integer;
    FAnimatedPosition: Single; // Seçili segmentin animasyonlu pozisyonu
    FOnSegmentChange: TNotifyEvent;

    procedure AnimationTick(Sender: TObject);
    procedure SetSegments(AValue: TStringList);
    procedure SetSelectedIndex(AValue: Integer);
    procedure SetEqualWidth(AValue: Boolean);
    procedure SegmentsChanged(Sender: TObject);
    function GetSegmentRect(Index: Integer): TRect;
    function GetSegmentAtPoint(X, Y: Integer): Integer;
    procedure DoSegmentChange;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Segments: TStringList read FSegments write SetSegments;
    property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default 0;
    property EqualWidth: Boolean read FEqualWidth write SetEqualWidth default True;
    property SegmentSpacing: Integer read FSegmentSpacing write FSegmentSpacing default 2;

    property OnSegmentChange: TNotifyEvent read FOnSegmentChange write FOnSegmentChange;
  end;

  TRippleInfo = record
    X, Y: Integer;
    Radius: Single;
    MaxRadius: Single;
    Alpha: Byte;
    Active: Boolean;
  end;
  { TONURRippleButton }
  TONURRippleButton = class(TONURSkinCustomControl)
  private
    FState: TONURButtonState;
    FIsMouseOver: Boolean;
    FCaption: string;
    FFontColor: TColor;
    FRippleColor: TColor;
    FRippleDuration: Integer;
    FRippleOpacity: Byte;
    FAnimatedAlpha: Byte;
    FRipples: array of TRippleInfo;
    FRippleTimer: TTimer;

    procedure AnimationTick(Sender: TObject);
    procedure SetCaption(AValue: string);
    procedure SetFontColor(AValue: TColor);
    procedure SetRippleColor(AValue: TColor);
    procedure SetRippleDuration(AValue: Integer);
    procedure SetRippleOpacity(AValue: Byte);
    procedure OnRippleTimer(Sender: TObject);
    procedure StartRipple(X, Y: Integer);
    procedure UpdateRipples;
  protected
    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Visible;
    property SkinManager;
    property SkinElement;

    property Caption: string read FCaption write SetCaption;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property RippleColor: TColor read FRippleColor write SetRippleColor default clWhite;
    property RippleDuration: Integer read FRippleDuration write SetRippleDuration default 600;
    property RippleOpacity: Byte read FRippleOpacity write SetRippleOpacity default 128;

    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

procedure Register;

implementation

uses Forms;

procedure Register;
begin
  RegisterComponents('ONUR Button', [
    TONURButton,
    TONURCropButton,
    TONURSystemButton,
    TONURToggleButton,
    TONURIconButton,
    TONURCheckBox,
    TONURRadioButton,
    TONURFloatingButton,
    TONURSplitButton,
    TONURSegmentedButton,
    TONURBadgeButton,
    TONURRippleButton
  ]);
end;


 { TONURCropButton }
constructor TONURCropButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 100;
  SkinElement := 'CropButton';

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FIsMouseOver := False;
  FCaption := 'CropButton';
  FFontColor := clBlack;

  FColor := $00F0F0F0;
  FHoverColor := $00E0E0E0;
  FPressedColor := $00C0C0C0;

  FUseRegion := False;
  FCurrentRegion := 0;
end;
destructor TONURCropButton.Destroy;
begin
  {$IFDEF WINDOWS}
  if FCurrentRegion <> 0 then
    DeleteObject(FCurrentRegion);
  {$ENDIF}
  inherited Destroy;
end;
procedure TONURCropButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURCropButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURCropButton.SetColor(AValue: TColor);
begin
  if FColor = AValue then Exit;
  FColor := AValue;
  Invalidate;
end;
procedure TONURCropButton.SetHoverColor(AValue: TColor);
begin
  if FHoverColor = AValue then Exit;
  FHoverColor := AValue;
  Invalidate;
end;
procedure TONURCropButton.SetPressedColor(AValue: TColor);
begin
  if FPressedColor = AValue then Exit;
  FPressedColor := AValue;
  Invalidate;
end;
procedure TONURCropButton.SetUseRegion(AValue: Boolean);
begin
  if FUseRegion = AValue then Exit;
  FUseRegion := AValue;
  UpdateRegion;
end;
function TONURCropButton.IsPixelTransparent(X, Y: Integer): Boolean;
var
  Bmp: TBGRABitmap;
  Part: TONURSkinPart;
  PartName: string;
  Pixel: TBGRAPixel;
  ScaleX, ScaleY: Single;
  SrcX, SrcY: Integer;
begin
  Result := True; // Varsayılan: Transparan (tıklanamaz)

  if (SkinManager = nil) or (SkinElement = '') then Exit;

  // Duruma göre parça adı
  case FState of
    obsNormal: PartName := 'Normal';
    obsHover: PartName := 'Hover';
    obsPressed: PartName := 'Pressed';
    obsDisabled: PartName := 'Disabled';
  end;

  Part := SkinManager.GetPart(SkinElement, PartName);
  if Part = nil then Exit;

  Bmp := Part.CachedBitmap;
  if Bmp = nil then
  begin
    Bmp := SkinManager.GetBitmap(SkinElement, PartName);
    if Bmp = nil then Exit;
  end;

  // Koordinatları skin resmine göre ölçekle
  ScaleX := Bmp.Width / ClientWidth;
  ScaleY := Bmp.Height / ClientHeight;
  SrcX := Round(X * ScaleX);
  SrcY := Round(Y * ScaleY);

  // Sınır kontrolü
  if (SrcX < 0) or (SrcX >= Bmp.Width) or (SrcY < 0) or (SrcY >= Bmp.Height) then
    Exit;

  // Pixel alpha kontrolü
  Pixel := Bmp.GetPixel(SrcX, SrcY);
  Result := Pixel.alpha < 128; // 128'den düşük alpha = transparan
end;
procedure TONURCropButton.UpdateRegion;
{$IFDEF WINDOWS}
var
  Bmp: TBGRABitmap;
  Part: TONURSkinPart;
  NewRegion: HRGN;
  ScaledBmp:TBGRABitmap;
begin
  if not FUseRegion then
  begin
    if FCurrentRegion <> 0 then
    begin
      DeleteObject(FCurrentRegion);
      FCurrentRegion := 0;
      SetWindowRgn(Handle, 0, True);
    end;
    Exit;
  end;

  if (SkinManager = nil) or (SkinElement = '') then Exit;

  Part := SkinManager.GetPart(SkinElement, 'Normal');
  if Part = nil then Exit;

  Bmp := Part.CachedBitmap;
  if Bmp = nil then
  begin
    Bmp := SkinManager.GetBitmap(SkinElement, 'Normal');
    if Bmp = nil then Exit;
  end;

  // Eski region'ı temizle
  if FCurrentRegion <> 0 then
    DeleteObject(FCurrentRegion);

  // BGRABitmap'in kendi region fonksiyonunu kullan!
  // Çok daha hızlı ve optimize
  if (Bmp.Width = ClientWidth) and (Bmp.Height = ClientHeight) then
  begin
    // Aynı boyutta, direkt region oluştur
    NewRegion :=RegionFromBGRABitmap(Bmp);//.CreateRegion;
  end
  else
  begin
    // Farklı boyutta, önce ölçekle
    ScaledBmp := Bmp.Resample(ClientWidth, ClientHeight) as TBGRABitmap;
    try
      NewRegion := RegionFromBGRABitmap(ScaledBmp);//.CreateRegion;
    finally
      ScaledBmp.Free;
    end;
  end;

  FCurrentRegion := NewRegion;
  SetWindowRgn(Handle, FCurrentRegion, True);
end;
{$ELSE}
begin
  // Linux/Mac için region desteği yok (şimdilik)
end;
{$ENDIF}

procedure TONURCropButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURCropButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  CurrentColor: TColor;
  TextSize: TSize;
  TextX, TextY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    case FState of
      obsNormal:
      begin
        PartName := 'Normal';
        CurrentColor := FColor;
      end;
      obsHover:
      begin
        PartName := 'Hover';
        CurrentColor := FHoverColor;
      end;
      obsPressed:
      begin
        PartName := 'Pressed';
        CurrentColor := FPressedColor;
      end;
      obsDisabled:
      begin
        PartName := 'Disabled';
        CurrentColor := FColor;
      end;
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      Bmp.FillRect(ClientRect, ColorToBGRA(CurrentColor), dmSet);
      Bmp.Rectangle(ClientRect, ColorToBGRA(clGray), dmSet);
    end;
    // Yazı
    if FCaption <> '' then
    begin
      Bmp.FontName := Font.Name;
      if Font.Height < 0 then
        Bmp.FontHeight := Abs(Font.Height)
      else
        Bmp.FontHeight := Font.Height;
      Bmp.FontStyle := Font.Style;
      Bmp.FontAntialias := True;

      TextSize := Bmp.TextSize(FCaption);
      TextX := (ClientWidth - TextSize.cx) div 2;
      TextY := (ClientHeight - TextSize.cy) div 2;

      Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURCropButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatFade, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURCropButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURCropButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Transparan pixele tıklanmışsa işlem yapma
  if IsPixelTransparent(X, Y) then Exit;

  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURCropButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsPixelTransparent(X, Y) then Exit;

  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;
procedure TONURCropButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  // Mouse transparan alanda mı kontrol et
  if IsPixelTransparent(X, Y) then
  begin
    if FIsMouseOver then
      MouseLeave;
  end
  else
  begin
    if not FIsMouseOver then
      MouseEnter;
  end;
end;

{ TONURButton }

constructor TONURButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 30;
  SkinElement := 'Button'; // Varsayılan element adı
  FAnimatedAlpha := 255;
  FState := obsNormal;
  FIsMouseOver := False;
  FCaption := 'ONURButton';
  FFontColor := clBlack;
  
  // Varsayılan Renkler
  FColor := $00F0F0F0;
  FHoverColor := $00E0E0E0;
  FPressedColor := $00C0C0C0;
end;

destructor TONURButton.Destroy;
begin
  inherited Destroy;
end;

procedure TONURButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TONURButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;

procedure TONURButton.SetColor(AValue: TColor);
begin
  if FColor = AValue then Exit;
  FColor := AValue;
  Invalidate;
end;

procedure TONURButton.SetHoverColor(AValue: TColor);
begin
  if FHoverColor = AValue then Exit;
  FHoverColor := AValue;
  Invalidate;
end;

procedure TONURButton.SetPressedColor(AValue: TColor);
begin
  if FPressedColor = AValue then Exit;
  FPressedColor := AValue;
  Invalidate;
end;

procedure TONURButton.TextChanged;
begin
  inherited TextChanged;
  FCaption := Text;
  Invalidate;
end;

procedure TONURButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  CurrentColor: TColor;
  TextSize: TSize;
  TextX, TextY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // 1. Duruma göre parça adını ve rengi belirle
    case FState of
      obsNormal:
      begin
        PartName := 'Normal';
        CurrentColor := FColor;
      end;
      obsHover:
      begin
        PartName := 'Hover';
        CurrentColor := FHoverColor;
      end;
      obsPressed:
      begin
        PartName := 'Pressed';
        CurrentColor := FPressedColor;
      end;
      obsDisabled:
      begin
        PartName := 'Disabled';
        CurrentColor := FColor; // Disabled rengi eklenebilir
      end;
    end;

    // 2. Skin çizimi dene
    //    DrawSuccess := DrawPart(PartName, Bmp, ClientRect);
        DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);

    // 3. Skin yoksa Fallback çizimi yap
    if not DrawSuccess then
    begin
      Bmp.FillRect(ClientRect, ColorToBGRA(CurrentColor), dmSet);
      // Kenarlık ekle
     // Bmp.DrawRectangle(ClientRect, ColorToBGRA(clGray), dmSet);
      Bmp.Rectangle(ClientRect, ColorToBGRA(clGray), dmSet);
    end;

    // 4. Yazıyı çiz
    Bmp.FontName := Font.Name;
    Bmp.FontHeight := Font.Height; // Font.Size yerine Height kullanmak daha güvenli olabilir
    // BGRABitmap font boyutu pozitif olmalı, LCL negatif olabilir
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
      
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;
    
    TextSize := Bmp.TextSize(FCaption);
    TextX := (ClientWidth - TextSize.cx) div 2;
    TextY := (ClientHeight - TextSize.cy) div 2;
    
    Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));

    // 5. Ekrana bas
    Bmp.Draw(Canvas, 0, 0, True);
    
  finally
    Bmp.Free;
  end;
end;



procedure TONURButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatFade, 200, oaeEaseOut); // 200ms fade
  Invalidate;
end;

procedure TONURButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;

procedure TONURButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;

procedure TONURButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;

procedure TONURButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    // Fade animasyonu: 200 -> 255 alpha
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;


{ TONURSystemButton }
constructor TONURSystemButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 32;
  Height := 32;

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FIsMouseOver := False;
  FButtonType := osbtClose;
  FAutoAction := True;

  // Varsayılan SkinElement
  SkinElement := 'SystemButton';
end;
destructor TONURSystemButton.Destroy;
begin
  inherited Destroy;
end;
procedure TONURSystemButton.SetButtonType(AValue: TONURSystemButtonType);
begin
  if FButtonType = AValue then Exit;
  FButtonType := AValue;
  Invalidate;
end;
procedure TONURSystemButton.SetAutoAction(AValue: Boolean);
begin
  if FAutoAction = AValue then Exit;
  FAutoAction := AValue;
end;
procedure TONURSystemButton.ExecuteAction;
var
  ParentForm: TCustomForm;
begin
  if not FAutoAction then Exit;

  ParentForm := GetParentForm(Self);
  if ParentForm = nil then Exit;

  case FButtonType of
    osbtClose:
      ParentForm.Close;
    osbtMinimize:
      {$IFDEF WINDOWS}
      ShowWindow(ParentForm.Handle, SW_MINIMIZE);
      {$ELSE}
      ParentForm.WindowState := wsMinimized;
      {$ENDIF}
    osbtMaximize:
      begin
        if ParentForm.WindowState = wsMaximized then
          ParentForm.WindowState := wsNormal
        else
          ParentForm.WindowState := wsMaximized;
      end;
    osbtHelp:
      begin
        // Help butonu için özel işlem
        // Kullanıcı OnClick event'inde kendi help sistemini çağırabilir
      end;
  end;
end;
procedure TONURSystemButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURSystemButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  IconColor: TBGRAPixel;
  CenterX, CenterY, IconSize: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Duruma göre parça adı
    case FState of
      obsNormal: PartName := 'Normal';
      obsHover: PartName := 'Hover';
      obsPressed: PartName := 'Pressed';
      obsDisabled: PartName := 'Disabled';
    end;

    // Buton tipine göre element adı
    case FButtonType of
      osbtClose: PartName := 'Close_' + PartName;
      osbtMinimize: PartName := 'Minimize_' + PartName;
      osbtMaximize: PartName := 'Maximize_' + PartName;
      osbtHelp: PartName := 'Help_' + PartName;
      osbtCustom: PartName := 'Custom_' + PartName;
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    // Skin yoksa fallback çizimi
    if not DrawSuccess then
    begin
      // Arka plan
      case FState of
        obsNormal: Bmp.Fill(BGRA(240, 240, 240, 255));
        obsHover: Bmp.Fill(BGRA(220, 220, 220, 255));
        obsPressed: Bmp.Fill(BGRA(200, 200, 200, 255));
        obsDisabled: Bmp.Fill(BGRA(240, 240, 240, 128));
      end;

      // İkon çiz
      CenterX := ClientWidth div 2;
      CenterY := ClientHeight div 2;
      IconSize := Min(ClientWidth, ClientHeight) div 3;

      if FState = obsDisabled then
        IconColor := BGRA(128, 128, 128, 255)
      else
        IconColor := BGRA(64, 64, 64, 255);

      case FButtonType of
        osbtClose:
        begin
          // X işareti
          Bmp.DrawLineAntialias(CenterX - IconSize, CenterY - IconSize,
                                CenterX + IconSize, CenterY + IconSize, IconColor, 2);
          Bmp.DrawLineAntialias(CenterX + IconSize, CenterY - IconSize,
                                CenterX - IconSize, CenterY + IconSize, IconColor, 2);
        end;
        osbtMinimize:
        begin
          // Çizgi (minimize)
          Bmp.DrawLineAntialias(CenterX - IconSize, CenterY,
                                CenterX + IconSize, CenterY, IconColor, 2);
        end;
        osbtMaximize:
        begin
          // Kare (maximize)
          Bmp.Rectangle(CenterX - IconSize, CenterY - IconSize,
                        CenterX + IconSize, CenterY + IconSize, IconColor, dmSet);
        end;
        osbtHelp:
        begin
          // ? işareti
          Bmp.FontName := 'Arial';
          Bmp.FontHeight := IconSize * 2;
          Bmp.FontStyle := [fsBold];
          Bmp.TextOut(CenterX - IconSize div 2, CenterY - IconSize, '?', IconColor);
        end;
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURSystemButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatFade, 150, oaeEaseOut);
  Invalidate;
end;
procedure TONURSystemButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURSystemButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURSystemButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;
procedure TONURSystemButton.Click;
begin
  inherited Click;
  ExecuteAction; // Otomatik işlem
end;


{ TONURToggleButton }
constructor TONURToggleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 60;
  Height := 30;

  FAnimatedAlpha := 255;
  FAnimatedPosition := 0.0; // Başlangıçta OFF
  FState := obsNormal;
  FIsMouseOver := False;
  FChecked := False;
  FOnCaption := 'ON';
  FOffCaption := 'OFF';
  FShowCaption := True;

  SkinElement := 'ToggleButton';
end;
destructor TONURToggleButton.Destroy;
begin
  inherited Destroy;
end;
procedure TONURToggleButton.SetChecked(AValue: Boolean);
begin
  if FChecked = AValue then Exit;
  FChecked := AValue;

  // Kayma animasyonu başlat
  StartAnimation(oatSlide, 200, oaeEaseInOut);

  DoOnChange;
  Invalidate;
end;
procedure TONURToggleButton.SetOnCaption(AValue: string);
begin
  if FOnCaption = AValue then Exit;
  FOnCaption := AValue;
  Invalidate;
end;
procedure TONURToggleButton.SetOffCaption(AValue: string);
begin
  if FOffCaption = AValue then Exit;
  FOffCaption := AValue;
  Invalidate;
end;
procedure TONURToggleButton.SetShowCaption(AValue: Boolean);
begin
  if FShowCaption = AValue then Exit;
  FShowCaption := AValue;
  Invalidate;
end;
procedure TONURToggleButton.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;
procedure TONURToggleButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
  TargetPos: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;

    // Hedef pozisyon
    if FChecked then
      TargetPos := 1.0
    else
      TargetPos := 0.0;

    // Mevcut pozisyondan hedefe doğru hareket
    if FChecked then
      FAnimatedPosition := Progress
    else
      FAnimatedPosition := 1.0 - Progress;

    Invalidate;
  end;
end;
procedure TONURToggleButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  TrackRect, ThumbRect: TRect;
  ThumbX, ThumbSize: Integer;
  TrackColor, ThumbColor, TextColor: TBGRAPixel;
//  Caption: string;
  TextSize: TSize;
  TextX, TextY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Duruma göre parça adı
    if FChecked then
    begin
      case FState of
        obsNormal: PartName := 'On_Normal';
        obsHover: PartName := 'On_Hover';
        obsPressed: PartName := 'On_Pressed';
        obsDisabled: PartName := 'On_Disabled';
      end;
    end
    else
    begin
      case FState of
        obsNormal: PartName := 'Off_Normal';
        obsHover: PartName := 'Off_Hover';
        obsPressed: PartName := 'Off_Pressed';
        obsDisabled: PartName := 'Off_Disabled';
      end;
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    // Skin yoksa fallback çizimi
    if not DrawSuccess then
    begin
      // Track (arka plan ray)
      TrackRect := Rect(0, ClientHeight div 4, ClientWidth, ClientHeight - ClientHeight div 4);

      if FChecked then
        TrackColor := BGRA(76, 175, 80, 255) // Yeşil (ON)
      else
        TrackColor := BGRA(189, 189, 189, 255); // Gri (OFF)

      Bmp.FillRoundRectAntialias(TrackRect.Left, TrackRect.Top, TrackRect.Right, TrackRect.Bottom,
                                  (TrackRect.Bottom - TrackRect.Top) div 2,
                                  (TrackRect.Bottom - TrackRect.Top) div 2, TrackColor);

      // Thumb (kayar düğme)
      ThumbSize := ClientHeight - 4;
      ThumbX := Round(2 + (ClientWidth - ThumbSize - 4) * FAnimatedPosition);
      ThumbRect := Rect(ThumbX, 2, ThumbX + ThumbSize, ClientHeight - 2);

      ThumbColor := BGRA(255, 255, 255, 255); // Beyaz
      Bmp.FillEllipseAntialias((ThumbRect.Left + ThumbRect.Right) / 2,
                               (ThumbRect.Top + ThumbRect.Bottom) / 2,
                               ThumbSize / 2, ThumbSize / 2, ThumbColor);

      // Gölge efekti
      Bmp.EllipseAntialias((ThumbRect.Left + ThumbRect.Right) / 2,
                           (ThumbRect.Top + ThumbRect.Bottom) / 2,
                           ThumbSize / 2, ThumbSize / 2,
                           BGRA(0, 0, 0, 64), 1);

      // Yazı
      if FShowCaption then
      begin
        Bmp.FontName := Font.Name;
        if Font.Height < 0 then
          Bmp.FontHeight := Abs(Font.Height)
        else
          Bmp.FontHeight := Font.Height;
        Bmp.FontStyle := Font.Style;
        Bmp.FontAntialias := True;

        if FChecked then
        begin
          Caption := FOnCaption;
          TextColor := BGRA(255, 255, 255, 255); // Beyaz
        end
        else
        begin
          Caption := FOffCaption;
          TextColor := BGRA(128, 128, 128, 255); // Gri
        end;

        TextSize := Bmp.TextSize(Caption);
        TextX := (ClientWidth - TextSize.cx) div 2;
        TextY := (ClientHeight - TextSize.cy) div 2;

        Bmp.TextOut(TextX, TextY, Caption, TextColor);
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURToggleButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  Invalidate;
end;
procedure TONURToggleButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURToggleButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURToggleButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;
procedure TONURToggleButton.Click;
begin
  inherited Click;
  Checked := not Checked; // Toggle!
end;


{ TONURFloatingButton }
constructor TONURFloatingButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 56;
  Height := 56;

  FAnimatedAlpha := 255;
  FAnimatedScale := 1.0;
  FState := obsNormal;
  FIsMouseOver := False;
  FIcon := nil;
  FIconSize := 24;
  FShadowSize := 4;
  FHoverScale := 1.15;

  SkinElement := 'FloatingButton';
end;
destructor TONURFloatingButton.Destroy;
begin
  if FIcon <> nil then
    FIcon.Free;
  inherited Destroy;
end;
procedure TONURFloatingButton.SetIcon(AValue: TBGRABitmap);
begin
  if FIcon <> nil then
    FIcon.Free;
  FIcon := AValue;
  Invalidate;
end;
procedure TONURFloatingButton.SetIconSize(AValue: Integer);
begin
  if FIconSize = AValue then Exit;
  FIconSize := AValue;
  Invalidate;
end;
procedure TONURFloatingButton.SetShadowSize(AValue: Integer);
begin
  if FShadowSize = AValue then Exit;
  FShadowSize := AValue;
  Invalidate;
end;
procedure TONURFloatingButton.SetHoverScale(AValue: Single);
begin
  if FHoverScale = AValue then Exit;
  FHoverScale := AValue;
end;
procedure TONURFloatingButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;

    // Scale animasyonu
    if FIsMouseOver then
      FAnimatedScale := 1.0 + ((FHoverScale - 1.0) * Progress)
    else
      FAnimatedScale := FHoverScale - ((FHoverScale - 1.0) * Progress);

    Invalidate;
  end;
end;
procedure TONURFloatingButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  CenterX, CenterY, Radius: Integer;
  ScaledRadius: Integer;
  ButtonColor, ShadowColor: TBGRAPixel;
  ScaledIcon: TBGRABitmap;
  IconX, IconY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Durum
    case FState of
      obsNormal: PartName := 'Normal';
      obsHover: PartName := 'Hover';
      obsPressed: PartName := 'Pressed';
      obsDisabled: PartName := 'Disabled';
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      CenterX := ClientWidth div 2;
      CenterY := ClientHeight div 2;
      Radius := Min(ClientWidth, ClientHeight) div 2 - FShadowSize;
      ScaledRadius := Round(Radius * FAnimatedScale);

      // Gölge
      ShadowColor := BGRA(0, 0, 0, 64);
      Bmp.FillEllipseAntialias(CenterX, CenterY + FShadowSize div 2,
                               ScaledRadius + FShadowSize, ScaledRadius + FShadowSize,
                               ShadowColor);

      // Ana buton
      case FState of
        obsNormal: ButtonColor := BGRA(33, 150, 243, 255); // Mavi
        obsHover: ButtonColor := BGRA(25, 118, 210, 255);
        obsPressed: ButtonColor := BGRA(13, 71, 161, 255);
        obsDisabled: ButtonColor := BGRA(189, 189, 189, 255);
      end;

      Bmp.FillEllipseAntialias(CenterX, CenterY, ScaledRadius, ScaledRadius, ButtonColor);

      // İkon
      if FIcon <> nil then
      begin
        ScaledIcon := FIcon.Resample(FIconSize, FIconSize) as TBGRABitmap;
        try
          IconX := CenterX - FIconSize div 2;
          IconY := CenterY - FIconSize div 2;
          Bmp.PutImage(IconX, IconY, ScaledIcon, dmDrawWithTransparency);
        finally
          ScaledIcon.Free;
        end;
      end;
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURFloatingButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatScale, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURFloatingButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  StartAnimation(oatScale, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURFloatingButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURFloatingButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;

{ TONURIconButton }
constructor TONURIconButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 40;

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FIsMouseOver := False;
  FCaption := 'IconButton';
  FFontColor := clBlack;
  FIcon := nil;
  FIconPosition := ipLeft;
  FIconSize := 24;
  FIconSpacing := 8;

  SkinElement := 'IconButton';
end;
destructor TONURIconButton.Destroy;
begin
  if FIcon <> nil then
    FIcon.Free;
  inherited Destroy;
end;
procedure TONURIconButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURIconButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURIconButton.SetIcon(AValue: TBGRABitmap);
begin
  if FIcon <> nil then
    FIcon.Free;
  FIcon := AValue;
  Invalidate;
end;
procedure TONURIconButton.SetIconPosition(AValue: TONURIconPosition);
begin
  if FIconPosition = AValue then Exit;
  FIconPosition := AValue;
  Invalidate;
end;
procedure TONURIconButton.SetIconSize(AValue: Integer);
begin
  if FIconSize = AValue then Exit;
  FIconSize := AValue;
  Invalidate;
end;
procedure TONURIconButton.SetIconSpacing(AValue: Integer);
begin
  if FIconSpacing = AValue then Exit;
  FIconSpacing := AValue;
  Invalidate;
end;
procedure TONURIconButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURIconButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  IconRect, TextRect: TRect;
  TextSize: TSize;
  TotalWidth, TotalHeight: Integer;
  StartX, StartY: Integer;
  ScaledIcon: TBGRABitmap;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Durum
    case FState of
      obsNormal: PartName := 'Normal';
      obsHover: PartName := 'Hover';
      obsPressed: PartName := 'Pressed';
      obsDisabled: PartName := 'Disabled';
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      // Fallback arka plan
      case FState of
        obsNormal: Bmp.Fill(BGRA(240, 240, 240, 255));
        obsHover: Bmp.Fill(BGRA(220, 220, 220, 255));
        obsPressed: Bmp.Fill(BGRA(200, 200, 200, 255));
        obsDisabled: Bmp.Fill(BGRA(240, 240, 240, 128));
      end;
      Bmp.Rectangle(ClientRect, BGRA(180, 180, 180, 255), dmSet);
    end;
    // İkon ve yazı çizimi
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);

    // İkon ve yazının toplam boyutunu hesapla
    case FIconPosition of
      ipLeft, ipRight:
      begin
        if FIcon <> nil then
          TotalWidth := FIconSize + FIconSpacing + TextSize.cx
        else
          TotalWidth := TextSize.cx;
        TotalHeight := Max(FIconSize, TextSize.cy);

        StartX := (ClientWidth - TotalWidth) div 2;
        StartY := (ClientHeight - TotalHeight) div 2;

        if FIconPosition = ipLeft then
        begin
          IconRect := Rect(StartX, StartY, StartX + FIconSize, StartY + FIconSize);
          TextRect := Rect(StartX + FIconSize + FIconSpacing, StartY,
                          StartX + TotalWidth, StartY + TextSize.cy);
        end
        else
        begin
          TextRect := Rect(StartX, StartY, StartX + TextSize.cx, StartY + TextSize.cy);
          IconRect := Rect(StartX + TextSize.cx + FIconSpacing, StartY,
                          StartX + TotalWidth, StartY + FIconSize);
        end;
      end;
      ipTop, ipBottom:
      begin
        TotalWidth := Max(FIconSize, TextSize.cx);
        if FIcon <> nil then
          TotalHeight := FIconSize + FIconSpacing + TextSize.cy
        else
          TotalHeight := TextSize.cy;

        StartX := (ClientWidth - TotalWidth) div 2;
        StartY := (ClientHeight - TotalHeight) div 2;

        if FIconPosition = ipTop then
        begin
          IconRect := Rect(StartX, StartY, StartX + FIconSize, StartY + FIconSize);
          TextRect := Rect(StartX, StartY + FIconSize + FIconSpacing,
                          StartX + TextSize.cx, StartY + TotalHeight);
        end
        else
        begin
          TextRect := Rect(StartX, StartY, StartX + TextSize.cx, StartY + TextSize.cy);
          IconRect := Rect(StartX, StartY + TextSize.cy + FIconSpacing,
                          StartX + FIconSize, StartY + TotalHeight);
        end;
      end;
    end;

    // İkon çiz
    if FIcon <> nil then
    begin
      ScaledIcon := FIcon.Resample(FIconSize, FIconSize) as TBGRABitmap;
      try
        Bmp.PutImage(IconRect.Left, IconRect.Top, ScaledIcon, dmDrawWithTransparency);
      finally
        ScaledIcon.Free;
      end;
    end;

    // Yazı çiz
    Bmp.TextOut(TextRect.Left, TextRect.Top, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURIconButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatFade, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURIconButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURIconButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURIconButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;

{ TONURCheckBox }
constructor TONURCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 24;

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FCheckState := cbUnchecked;
  FAllowGrayed := False;
  FCaption := 'CheckBox';
  FFontColor := clBlack;
  FCaptionPosition := cpRight;
  FCheckSize := 20;
  FCheckSpacing := 8;

  SkinElement := 'CheckBox';
end;
destructor TONURCheckBox.Destroy;
begin
  inherited Destroy;
end;
function TONURCheckBox.GetChecked: Boolean;
begin
  Result := FCheckState = cbChecked;
end;
procedure TONURCheckBox.SetChecked(AValue: Boolean);
begin
  if AValue then
    SetCheckState(cbChecked)
  else
    SetCheckState(cbUnchecked);
end;
procedure TONURCheckBox.SetCheckState(AValue: TCheckBoxState);
begin
  if FCheckState = AValue then Exit;
  FCheckState := AValue;
  DoOnChange;
  Invalidate;
end;
procedure TONURCheckBox.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURCheckBox.SetCaptionPosition(AValue: TONURCaptionPosition);
begin
  if FCaptionPosition = AValue then Exit;
  FCaptionPosition := AValue;
  Invalidate;
end;
procedure TONURCheckBox.SetCheckSize(AValue: Integer);
begin
  if FCheckSize = AValue then Exit;
  FCheckSize := AValue;
  Invalidate;
end;
procedure TONURCheckBox.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;
procedure TONURCheckBox.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURCheckBox.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  CheckRect, TextRect: TRect;
  TextSize: TSize;
  CheckColor, BgColor: TBGRAPixel;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Parça adı
    case FCheckState of
      cbUnchecked:
        case FState of
          obsNormal: PartName := 'Unchecked_Normal';
          obsHover: PartName := 'Unchecked_Hover';
          obsPressed: PartName := 'Unchecked_Pressed';
          obsDisabled: PartName := 'Unchecked_Disabled';
        end;
      cbChecked:
        case FState of
          obsNormal: PartName := 'Checked_Normal';
          obsHover: PartName := 'Checked_Hover';
          obsPressed: PartName := 'Checked_Pressed';
          obsDisabled: PartName := 'Checked_Disabled';
        end;
      cbGrayed:
        case FState of
          obsNormal: PartName := 'Grayed_Normal';
          obsHover: PartName := 'Grayed_Hover';
          obsPressed: PartName := 'Grayed_Pressed';
          obsDisabled: PartName := 'Grayed_Disabled';
        end;
    end;
    DrawSuccess := DrawPart(PartName, Bmp, Rect(0, 0, FCheckSize, FCheckSize), FAnimatedAlpha);
    if not DrawSuccess then
    begin
      // Fallback checkbox çizimi
      CheckRect := Rect(0, (ClientHeight - FCheckSize) div 2,
                       FCheckSize, (ClientHeight - FCheckSize) div 2 + FCheckSize);

      // Arka plan
      if FState = obsHover then
        BgColor := BGRA(230, 230, 230, 255)
      else
        BgColor := BGRA(255, 255, 255, 255);

      Bmp.FillRect(CheckRect, BgColor, dmSet);
      Bmp.Rectangle(CheckRect, BGRA(128, 128, 128, 255), dmSet);

      // Checkmark
      if FCheckState = cbChecked then
      begin
        CheckColor := BGRA(76, 175, 80, 255); // Yeşil
        // ✓ işareti
        Bmp.DrawLineAntialias(CheckRect.Left + 4, CheckRect.Top + FCheckSize div 2,
                              CheckRect.Left + FCheckSize div 3, CheckRect.Bottom - 4, CheckColor, 2);
        Bmp.DrawLineAntialias(CheckRect.Left + FCheckSize div 3, CheckRect.Bottom - 4,
                              CheckRect.Right - 4, CheckRect.Top + 4, CheckColor, 2);
      end
      else if FCheckState = cbGrayed then
      begin
        CheckColor := BGRA(158, 158, 158, 255); // Gri
        // - işareti
        Bmp.DrawLineAntialias(CheckRect.Left + 4, CheckRect.Top + FCheckSize div 2,
                              CheckRect.Right - 4, CheckRect.Top + FCheckSize div 2, CheckColor, 2);
      end;
    end;

    // Yazı
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);

    if FCaptionPosition = cpRight then
      TextRect := Rect(FCheckSize + FCheckSpacing, (ClientHeight - TextSize.cy) div 2,
                      ClientWidth, (ClientHeight + TextSize.cy) div 2)
    else
      TextRect := Rect(0, (ClientHeight - TextSize.cy) div 2,
                      ClientWidth - FCheckSize - FCheckSpacing, (ClientHeight + TextSize.cy) div 2);

    Bmp.TextOut(TextRect.Left, TextRect.Top, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURCheckBox.MouseEnter;
begin
  inherited MouseEnter;
  if FState <> obsPressed then
    FState := obsHover;
  Invalidate;
end;
procedure TONURCheckBox.MouseLeave;
begin
  inherited MouseLeave;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;
procedure TONURCheckBox.Click;
begin
  inherited Click;

  // Cycle through states
  case FCheckState of
    cbUnchecked: SetCheckState(cbChecked);
    cbChecked:
      if FAllowGrayed then
        SetCheckState(cbGrayed)
      else
        SetCheckState(cbUnchecked);
    cbGrayed: SetCheckState(cbUnchecked);
  end;
end;

{ TONURRadioButton }
constructor TONURRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 24;

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FChecked := False;
  FCaption := 'RadioButton';
  FFontColor := clBlack;
  FCaptionPosition := cpRight;
  FCheckSize := 20;
  FCheckSpacing := 8;

  SkinElement := 'RadioButton';
end;
destructor TONURRadioButton.Destroy;
begin
  inherited Destroy;
end;
procedure TONURRadioButton.SetChecked(AValue: Boolean);
begin
  if FChecked = AValue then Exit;
  FChecked := AValue;

  if FChecked then
    UncheckOthers;

  DoOnChange;
  Invalidate;
end;
procedure TONURRadioButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURRadioButton.SetCaptionPosition(AValue: TONURCaptionPosition);
begin
  if FCaptionPosition = AValue then Exit;
  FCaptionPosition := AValue;
  Invalidate;
end;
procedure TONURRadioButton.SetCheckSize(AValue: Integer);
begin
  if FCheckSize = AValue then Exit;
  FCheckSize := AValue;
  Invalidate;
end;
procedure TONURRadioButton.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;
procedure TONURRadioButton.UncheckOthers;
var
  I: Integer;
  Sibling: TControl;
begin
  if Parent = nil then Exit;

  for I := 0 to Parent.ControlCount - 1 do
  begin
    Sibling := Parent.Controls[I];
    if (Sibling <> Self) and (Sibling is TONURRadioButton) then
      TONURRadioButton(Sibling).Checked := False;
  end;
end;
procedure TONURRadioButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURRadioButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  CheckRect, TextRect: TRect;
  TextSize: TSize;
  CenterX, CenterY, Radius: Integer;
  CheckColor, BgColor: TBGRAPixel;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Parça adı
    if FChecked then
      case FState of
        obsNormal: PartName := 'Checked_Normal';
        obsHover: PartName := 'Checked_Hover';
        obsPressed: PartName := 'Checked_Pressed';
        obsDisabled: PartName := 'Checked_Disabled';
      end
    else
      case FState of
        obsNormal: PartName := 'Unchecked_Normal';
        obsHover: PartName := 'Unchecked_Hover';
        obsPressed: PartName := 'Unchecked_Pressed';
        obsDisabled: PartName := 'Unchecked_Disabled';
      end;
    DrawSuccess := DrawPart(PartName, Bmp, Rect(0, 0, FCheckSize, FCheckSize), FAnimatedAlpha);
    if not DrawSuccess then
    begin
      // Fallback radio button çizimi
      CheckRect := Rect(0, (ClientHeight - FCheckSize) div 2,
                       FCheckSize, (ClientHeight - FCheckSize) div 2 + FCheckSize);

      CenterX := (CheckRect.Left + CheckRect.Right) div 2;
      CenterY := (CheckRect.Top + CheckRect.Bottom) div 2;
      Radius := FCheckSize div 2;

      // Dış daire
      if FState = obsHover then
        BgColor := BGRA(230, 230, 230, 255)
      else
        BgColor := BGRA(255, 255, 255, 255);

      Bmp.FillEllipseAntialias(CenterX, CenterY, Radius, Radius, BgColor);
      Bmp.EllipseAntialias(CenterX, CenterY, Radius, Radius, BGRA(128, 128, 128, 255), 1);

      // İç daire (checked ise)
      if FChecked then
      begin
        CheckColor := BGRA(76, 175, 80, 255); // Yeşil
        Bmp.FillEllipseAntialias(CenterX, CenterY, Radius - 4, Radius - 4, CheckColor);
      end;
    end;

    // Yazı
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);

    if FCaptionPosition = cpRight then
      TextRect := Rect(FCheckSize + FCheckSpacing, (ClientHeight - TextSize.cy) div 2,
                      ClientWidth, (ClientHeight + TextSize.cy) div 2)
    else
      TextRect := Rect(0, (ClientHeight - TextSize.cy) div 2,
                      ClientWidth - FCheckSize - FCheckSpacing, (ClientHeight + TextSize.cy) div 2);

    Bmp.TextOut(TextRect.Left, TextRect.Top, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURRadioButton.MouseEnter;
begin
  inherited MouseEnter;
  if FState <> obsPressed then
    FState := obsHover;
  Invalidate;
end;
procedure TONURRadioButton.MouseLeave;
begin
  inherited MouseLeave;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsHover;
    Invalidate;
  end;
end;
procedure TONURRadioButton.Click;
begin
  inherited Click;
  Checked := True; // Radio button her zaman True olur
end;

{ TONURBadgeButton }
constructor TONURBadgeButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 40;

  FAnimatedAlpha := 255;
  FBadgePulse := 1.0;
  FState := obsNormal;
  FIsMouseOver := False;
  FCaption := 'BadgeButton';
  FFontColor := clBlack;
  FBadgeCount := 0;
  FBadgeVisible := True;
  FBadgeColor := clRed;
  FBadgePosition := bpTopRight;

  SkinElement := 'BadgeButton';
end;
destructor TONURBadgeButton.Destroy;
begin
  inherited Destroy;
end;
procedure TONURBadgeButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURBadgeButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURBadgeButton.SetBadgeCount(AValue: Integer);
begin
  if FBadgeCount = AValue then Exit;
  FBadgeCount := AValue;

  // Badge değiştiğinde pulse animasyonu başlat
  if FBadgeCount > 0 then
    StartAnimation(oatPulse, 400, oaeEaseOut);

  Invalidate;
end;
procedure TONURBadgeButton.SetBadgeVisible(AValue: Boolean);
begin
  if FBadgeVisible = AValue then Exit;
  FBadgeVisible := AValue;
  Invalidate;
end;
procedure TONURBadgeButton.SetBadgeColor(AValue: TColor);
begin
  if FBadgeColor = AValue then Exit;
  FBadgeColor := AValue;
  Invalidate;
end;
procedure TONURBadgeButton.SetBadgePosition(AValue: TONURBadgePosition);
begin
  if FBadgePosition = AValue then Exit;
  FBadgePosition := AValue;
  Invalidate;
end;
procedure TONURBadgeButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;

    case Animation.AnimationType of
      oatFade:
        FAnimatedAlpha := Round(200 + (55 * Progress));
      oatPulse:
        FBadgePulse := 1.0 + (0.2 * (1.0 - Progress)); // 1.0 -> 1.2 -> 1.0
    end;

    Invalidate;
  end;
end;
procedure TONURBadgeButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  TextSize: TSize;
  TextX, TextY: Integer;
  BadgeX, BadgeY, BadgeSize: Integer;
  BadgeText: string;
  BadgeTextSize: TSize;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Ana buton
    case FState of
      obsNormal: PartName := 'Button_Normal';
      obsHover: PartName := 'Button_Hover';
      obsPressed: PartName := 'Button_Pressed';
      obsDisabled: PartName := 'Button_Disabled';
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      case FState of
        obsNormal: Bmp.Fill(BGRA(240, 240, 240, 255));
        obsHover: Bmp.Fill(BGRA(220, 220, 220, 255));
        obsPressed: Bmp.Fill(BGRA(200, 200, 200, 255));
        obsDisabled: Bmp.Fill(BGRA(240, 240, 240, 128));
      end;
      Bmp.Rectangle(ClientRect, BGRA(180, 180, 180, 255), dmSet);
    end;
    // Buton yazısı
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);
    TextX := (ClientWidth - TextSize.cx) div 2;
    TextY := (ClientHeight - TextSize.cy) div 2;

    Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));

    // Badge
    if FBadgeVisible and (FBadgeCount > 0) then
    begin
      if FBadgeCount > 99 then
        BadgeText := '99+'
      else
        BadgeText := IntToStr(FBadgeCount);

      Bmp.FontHeight := 10;
      Bmp.FontStyle := [fsBold];
      BadgeTextSize := Bmp.TextSize(BadgeText);

      BadgeSize := Round(Max(BadgeTextSize.cx + 8, 20) * FBadgePulse);

      // Badge pozisyonu
      case FBadgePosition of
        bpTopRight:
        begin
          BadgeX := ClientWidth - BadgeSize div 2 - 4;
          BadgeY := BadgeSize div 2 + 4;
        end;
        bpTopLeft:
        begin
          BadgeX := BadgeSize div 2 + 4;
          BadgeY := BadgeSize div 2 + 4;
        end;
        bpBottomRight:
        begin
          BadgeX := ClientWidth - BadgeSize div 2 - 4;
          BadgeY := ClientHeight - BadgeSize div 2 - 4;
        end;
        bpBottomLeft:
        begin
          BadgeX := BadgeSize div 2 + 4;
          BadgeY := ClientHeight - BadgeSize div 2 - 4;
        end;
      end;

      // Badge daire
      Bmp.FillEllipseAntialias(BadgeX, BadgeY, BadgeSize / 2, BadgeSize / 2,
                               ColorToBGRA(FBadgeColor));

      // Badge yazısı
      Bmp.TextOut(BadgeX - BadgeTextSize.cx div 2, BadgeY - BadgeTextSize.cy div 2,
                  BadgeText, BGRA(255, 255, 255, 255));
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURBadgeButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  StartAnimation(oatFade, 200, oaeEaseOut);
  Invalidate;
end;
procedure TONURBadgeButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURBadgeButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    Invalidate;
  end;
end;
procedure TONURBadgeButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;
{ TONURSplitButton }
constructor TONURSplitButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 32;

  FAnimatedAlpha := 255;
  FMainState := obsNormal;
  FDropdownState := obsNormal;
  FIsMainMouseOver := False;
  FIsDropdownMouseOver := False;
  FCaption := 'SplitButton';
  FFontColor := clBlack;
  FDropdownMenu := nil;
  FDropdownWidth := 30;

  SkinElement := 'SplitButton';
end;
destructor TONURSplitButton.Destroy;
begin
  inherited Destroy;
end;
procedure TONURSplitButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURSplitButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURSplitButton.SetDropdownMenu(AValue: TPopupMenu);
begin
  if FDropdownMenu = AValue then Exit;
  FDropdownMenu := AValue;
  if FDropdownMenu <> nil then
    FDropdownMenu.FreeNotification(Self);
end;
procedure TONURSplitButton.SetDropdownWidth(AValue: Integer);
begin
  if FDropdownWidth = AValue then Exit;
  FDropdownWidth := AValue;
  Invalidate;
end;
procedure TONURSplitButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDropdownMenu) then
    FDropdownMenu := nil;
end;
function TONURSplitButton.GetMainRect: TRect;
begin
  Result := Rect(0, 0, ClientWidth - FDropdownWidth, ClientHeight);
end;
function TONURSplitButton.GetDropdownRect: TRect;
begin
  Result := Rect(ClientWidth - FDropdownWidth, 0, ClientWidth, ClientHeight);
end;
function TONURSplitButton.IsPointInMain(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  R := GetMainRect;
  Result := (X >= R.Left) and (X < R.Right) and (Y >= R.Top) and (Y < R.Bottom);
end;
function TONURSplitButton.IsPointInDropdown(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  R := GetDropdownRect;
  Result := (X >= R.Left) and (X < R.Right) and (Y >= R.Top) and (Y < R.Bottom);
end;
procedure TONURSplitButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURSplitButton.Paint;
var
  Bmp: TBGRABitmap;
  MainPartName, DropPartName: string;
  DrawSuccess: Boolean;
  MainRect, DropRect: TRect;
  TextSize: TSize;
  TextX, TextY: Integer;
  ArrowPoints: array[0..2] of TPoint;
  ArrowCenterX, ArrowCenterY: Integer;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    MainRect := GetMainRect;
    DropRect := GetDropdownRect;

    // Ana buton parça adı
    case FMainState of
      obsNormal: MainPartName := 'Main_Normal';
      obsHover: MainPartName := 'Main_Hover';
      obsPressed: MainPartName := 'Main_Pressed';
      obsDisabled: MainPartName := 'Main_Disabled';
    end;

    // Dropdown parça adı
    case FDropdownState of
      obsNormal: DropPartName := 'Dropdown_Normal';
      obsHover: DropPartName := 'Dropdown_Hover';
      obsPressed: DropPartName := 'Dropdown_Pressed';
      obsDisabled: DropPartName := 'Dropdown_Disabled';
    end;
    // Ana buton çiz
    DrawSuccess := DrawPart(MainPartName, Bmp, MainRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      case FMainState of
        obsNormal: Bmp.FillRect(MainRect, BGRA(240, 240, 240, 255), dmSet);
        obsHover: Bmp.FillRect(MainRect, BGRA(220, 220, 220, 255), dmSet);
        obsPressed: Bmp.FillRect(MainRect, BGRA(200, 200, 200, 255), dmSet);
        obsDisabled: Bmp.FillRect(MainRect, BGRA(240, 240, 240, 128), dmSet);
      end;
      Bmp.Rectangle(MainRect, BGRA(180, 180, 180, 255), dmSet);
    end;

    // Dropdown çiz
    DrawSuccess := DrawPart(DropPartName, Bmp, DropRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      case FDropdownState of
        obsNormal: Bmp.FillRect(DropRect, BGRA(220, 220, 220, 255), dmSet);
        obsHover: Bmp.FillRect(DropRect, BGRA(200, 200, 200, 255), dmSet);
        obsPressed: Bmp.FillRect(DropRect, BGRA(180, 180, 180, 255), dmSet);
        obsDisabled: Bmp.FillRect(DropRect, BGRA(220, 220, 220, 128), dmSet);
      end;
      Bmp.Rectangle(DropRect, BGRA(180, 180, 180, 255), dmSet);

      // Dropdown ok çiz (▼)
      ArrowCenterX := (DropRect.Left + DropRect.Right) div 2;
      ArrowCenterY := (DropRect.Top + DropRect.Bottom) div 2;



// Basit çizgilerle ok çiz
Bmp.DrawLineAntialias(ArrowCenterX - 4, ArrowCenterY - 2,
                      ArrowCenterX, ArrowCenterY + 3,
                      BGRA(64, 64, 64, 255), 2);
Bmp.DrawLineAntialias(ArrowCenterX + 4, ArrowCenterY - 2,
                      ArrowCenterX, ArrowCenterY + 3,
                      BGRA(64, 64, 64, 255), 2);




    end;

    // Ana buton yazısı
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);
    TextX := MainRect.Left + (MainRect.Width - TextSize.cx) div 2;
    TextY := (ClientHeight - TextSize.cy) div 2;

    Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURSplitButton.MouseEnter;
begin
  inherited MouseEnter;
  Invalidate;
end;
procedure TONURSplitButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMainMouseOver := False;
  FIsDropdownMouseOver := False;
  FMainState := obsNormal;
  FDropdownState := obsNormal;
  Invalidate;
end;
procedure TONURSplitButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  InMain, InDropdown: Boolean;
begin
  inherited MouseMove(Shift, X, Y);

  InMain := IsPointInMain(X, Y);
  InDropdown := IsPointInDropdown(X, Y);

  if InMain <> FIsMainMouseOver then
  begin
    FIsMainMouseOver := InMain;
    if InMain and (FMainState <> obsPressed) then
      FMainState := obsHover
    else if not InMain then
      FMainState := obsNormal;
    Invalidate;
  end;

  if InDropdown <> FIsDropdownMouseOver then
  begin
    FIsDropdownMouseOver := InDropdown;
    if InDropdown and (FDropdownState <> obsPressed) then
      FDropdownState := obsHover
    else if not InDropdown then
      FDropdownState := obsNormal;
    Invalidate;
  end;
end;
procedure TONURSplitButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if IsPointInMain(X, Y) then
    begin
      FMainState := obsPressed;
      Invalidate;
    end
    else if IsPointInDropdown(X, Y) then
    begin
      FDropdownState := obsPressed;
      Invalidate;
    end;
  end;
end;
procedure TONURSplitButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if IsPointInMain(X, Y) then
    begin
      FMainState := obsHover;
      // Ana buton tıklandı - OnClick event'i tetiklenir
    end
    else if IsPointInDropdown(X, Y) then
    begin
      FDropdownState := obsHover;
      // Dropdown tıklandı - Menüyü aç
      if FDropdownMenu <> nil then
      begin
        P := ClientToScreen(Point(0, ClientHeight));
        FDropdownMenu.PopUp(P.X, P.Y);
      end;
    end;
    Invalidate;
  end;
end;


{ TONURSegmentedButton }
constructor TONURSegmentedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 300;
  Height := 40;

  FSegments := TStringList.Create;
  FSegments.OnChange := @SegmentsChanged;
  FSelectedIndex := 0;
  FEqualWidth := True;
  FSegmentSpacing := 2;
  FAnimatedPosition := 0.0;

  SkinElement := 'SegmentedButton';
end;
destructor TONURSegmentedButton.Destroy;
begin
  FSegments.Free;
  inherited Destroy;
end;
procedure TONURSegmentedButton.SetSegments(AValue: TStringList);
begin
  FSegments.Assign(AValue);
end;
procedure TONURSegmentedButton.SetSelectedIndex(AValue: Integer);
begin
  if (AValue < 0) or (AValue >= FSegments.Count) then Exit;
  if FSelectedIndex = AValue then Exit;

  FSelectedIndex := AValue;
  StartAnimation(oatSlide, 200, oaeEaseInOut);
  DoSegmentChange;
  Invalidate;
end;
procedure TONURSegmentedButton.SetEqualWidth(AValue: Boolean);
begin
  if FEqualWidth = AValue then Exit;
  FEqualWidth := AValue;
  Invalidate;
end;
procedure TONURSegmentedButton.SegmentsChanged(Sender: TObject);
begin
  if FSelectedIndex >= FSegments.Count then
    FSelectedIndex := FSegments.Count - 1;
  if FSelectedIndex < 0 then
    FSelectedIndex := 0;
  Invalidate;
end;
procedure TONURSegmentedButton.DoSegmentChange;
begin
  if Assigned(FOnSegmentChange) then
    FOnSegmentChange(Self);
end;
function TONURSegmentedButton.GetSegmentRect(Index: Integer): TRect;
var
  SegmentWidth, X: Integer;
  I: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index < 0) or (Index >= FSegments.Count) or (FSegments.Count = 0) then Exit;

  if FEqualWidth then
  begin
    SegmentWidth := (ClientWidth - (FSegments.Count - 1) * FSegmentSpacing) div FSegments.Count;
    X := Index * (SegmentWidth + FSegmentSpacing);
    Result := Rect(X, 0, X + SegmentWidth, ClientHeight);
  end
  else
  begin
    // Değişken genişlik (şimdilik eşit genişlik kullan)
    SegmentWidth := (ClientWidth - (FSegments.Count - 1) * FSegmentSpacing) div FSegments.Count;
    X := Index * (SegmentWidth + FSegmentSpacing);
    Result := Rect(X, 0, X + SegmentWidth, ClientHeight);
  end;
end;
function TONURSegmentedButton.GetSegmentAtPoint(X, Y: Integer): Integer;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;
  for I := 0 to FSegments.Count - 1 do
  begin
    R := GetSegmentRect(I);
    if (X >= R.Left) and (X < R.Right) and (Y >= R.Top) and (Y < R.Bottom) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;
procedure TONURSegmentedButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
  TargetPos: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    TargetPos := FSelectedIndex;
    FAnimatedPosition := FAnimatedPosition + (TargetPos - FAnimatedPosition) * Progress;
    Invalidate;
  end;
end;
procedure TONURSegmentedButton.Paint;
var
  Bmp: TBGRABitmap;
  I: Integer;
  SegRect, SelectedRect: TRect;
  TextSize: TSize;
  TextX, TextY: Integer;
  BgColor, SelectedColor, TextColor: TBGRAPixel;
  DrawSuccess: Boolean;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Arka plan
    DrawSuccess := DrawPart('Background', Bmp, ClientRect, 255);
    if not DrawSuccess then
    begin
      Bmp.FillRoundRectAntialias(0, 0, ClientWidth, ClientHeight, 8, 8, BGRA(230, 230, 230, 255));
    end;

    // Seçili segment arka planı (animasyonlu)
    if (FSelectedIndex >= 0) and (FSelectedIndex < FSegments.Count) then
    begin
      SelectedRect := GetSegmentRect(FSelectedIndex);
      DrawSuccess := DrawPart('Selected', Bmp, SelectedRect, 255);
      if not DrawSuccess then
      begin
        SelectedColor := BGRA(255, 255, 255, 255);
        Bmp.FillRoundRectAntialias(SelectedRect.Left + 2, SelectedRect.Top + 2,
                                    SelectedRect.Right - 2, SelectedRect.Bottom - 2,
                                    6, 6, SelectedColor);
      end;
    end;

    // Segment yazıları
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    for I := 0 to FSegments.Count - 1 do
    begin
      SegRect := GetSegmentRect(I);
      TextSize := Bmp.TextSize(FSegments[I]);
      TextX := SegRect.Left + (SegRect.Width - TextSize.cx) div 2;
      TextY := (ClientHeight - TextSize.cy) div 2;

      if I = FSelectedIndex then
        TextColor := BGRA(33, 150, 243, 255) // Mavi (seçili)
      else
        TextColor := BGRA(128, 128, 128, 255); // Gri

      Bmp.TextOut(TextX, TextY, FSegments[I], TextColor);
    end;
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURSegmentedButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickedIndex: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    ClickedIndex := GetSegmentAtPoint(X, Y);
    if ClickedIndex >= 0 then
      SelectedIndex := ClickedIndex;
  end;
end;
{ TONURRippleButton }
constructor TONURRippleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 120;
  Height := 40;

  FAnimatedAlpha := 255;
  FState := obsNormal;
  FIsMouseOver := False;
  FCaption := 'RippleButton';
  FFontColor := clBlack;
  FRippleColor := clWhite;
  FRippleDuration := 600;
  FRippleOpacity := 128;

  SetLength(FRipples, 0);

  FRippleTimer := TTimer.Create(Self);
  FRippleTimer.Interval := 16; // ~60 FPS
  FRippleTimer.Enabled := False;
  FRippleTimer.OnTimer := @OnRippleTimer;

  SkinElement := 'RippleButton';
end;
destructor TONURRippleButton.Destroy;
begin
  FRippleTimer.Free;
  inherited Destroy;
end;
procedure TONURRippleButton.SetCaption(AValue: string);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Invalidate;
end;
procedure TONURRippleButton.SetFontColor(AValue: TColor);
begin
  if FFontColor = AValue then Exit;
  FFontColor := AValue;
  Invalidate;
end;
procedure TONURRippleButton.SetRippleColor(AValue: TColor);
begin
  if FRippleColor = AValue then Exit;
  FRippleColor := AValue;
end;
procedure TONURRippleButton.SetRippleDuration(AValue: Integer);
begin
  if FRippleDuration = AValue then Exit;
  FRippleDuration := AValue;
end;
procedure TONURRippleButton.SetRippleOpacity(AValue: Byte);
begin
  if FRippleOpacity = AValue then Exit;
  FRippleOpacity := AValue;
end;
procedure TONURRippleButton.StartRipple(X, Y: Integer);
var
  Idx: Integer;
  MaxDist: Single;
begin
  // Yeni ripple ekle
  Idx := Length(FRipples);
  SetLength(FRipples, Idx + 1);

  FRipples[Idx].X := X;
  FRipples[Idx].Y := Y;
  FRipples[Idx].Radius := 0;

  // Max radius: Tıklama noktasından en uzak köşeye olan mesafe
  MaxDist := Sqrt(Sqr(Max(X, ClientWidth - X)) + Sqr(Max(Y, ClientHeight - Y)));
  FRipples[Idx].MaxRadius := MaxDist;
  FRipples[Idx].Alpha := FRippleOpacity;
  FRipples[Idx].Active := True;

  FRippleTimer.Enabled := True;
end;
procedure TONURRippleButton.UpdateRipples;
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
      // Ripple büyüme hızı
      Speed := FRipples[I].MaxRadius / (FRippleDuration / 16);
      FRipples[I].Radius := FRipples[I].Radius + Speed;

      // Alpha azalma
      FRipples[I].Alpha := Round(FRippleOpacity * (1.0 - (FRipples[I].Radius / FRipples[I].MaxRadius)));

      // Bitmiş mi?
      if FRipples[I].Radius >= FRipples[I].MaxRadius then
        FRipples[I].Active := False
      else
        HasActive := True;
    end;
  end;

  // Aktif ripple yoksa timer'ı durdur
  if not HasActive then
  begin
    FRippleTimer.Enabled := False;
    SetLength(FRipples, 0);
  end;

  Invalidate;
end;
procedure TONURRippleButton.OnRippleTimer(Sender: TObject);
begin
  UpdateRipples;
end;
procedure TONURRippleButton.AnimationTick(Sender: TObject);
var
  Progress: Single;
begin
  if Animation <> nil then
  begin
    Progress := Animation.GetEasedProgress;
    FAnimatedAlpha := Round(200 + (55 * Progress));
    Invalidate;
  end;
end;
procedure TONURRippleButton.Paint;
var
  Bmp: TBGRABitmap;
  PartName: string;
  DrawSuccess: Boolean;
  TextSize: TSize;
  TextX, TextY: Integer;
  I: Integer;
  RipplColor: TBGRAPixel;
begin
  Bmp := TBGRABitmap.Create(ClientWidth, ClientHeight);
  try
    // Ana buton
    case FState of
      obsNormal: PartName := 'Normal';
      obsHover: PartName := 'Hover';
      obsPressed: PartName := 'Pressed';
      obsDisabled: PartName := 'Disabled';
    end;
    DrawSuccess := DrawPart(PartName, Bmp, ClientRect, FAnimatedAlpha);
    if not DrawSuccess then
    begin
      case FState of
        obsNormal: Bmp.Fill(BGRA(33, 150, 243, 255)); // Mavi
        obsHover: Bmp.Fill(BGRA(25, 118, 210, 255));
        obsPressed: Bmp.Fill(BGRA(13, 71, 161, 255));
        obsDisabled: Bmp.Fill(BGRA(189, 189, 189, 255));
      end;
    end;
    // Ripple efektleri
    for I := 0 to High(FRipples) do
    begin
      if FRipples[I].Active then
      begin
        RipplColor := ColorToBGRA(FRippleColor);
        RipplColor.alpha := FRipples[I].Alpha;
        Bmp.FillEllipseAntialias(FRipples[I].X, FRipples[I].Y,
                                 FRipples[I].Radius, FRipples[I].Radius,
                                 RipplColor);
      end;
    end;
    // Buton yazısı
    Bmp.FontName := Font.Name;
    if Font.Height < 0 then
      Bmp.FontHeight := Abs(Font.Height)
    else
      Bmp.FontHeight := Font.Height;
    Bmp.FontStyle := Font.Style;
    Bmp.FontAntialias := True;

    TextSize := Bmp.TextSize(FCaption);
    TextX := (ClientWidth - TextSize.cx) div 2;
    TextY := (ClientHeight - TextSize.cy) div 2;

    Bmp.TextOut(TextX, TextY, FCaption, ColorToBGRA(FFontColor));
    Bmp.Draw(Canvas, 0, 0, True);
  finally
    Bmp.Free;
  end;
end;
procedure TONURRippleButton.MouseEnter;
begin
  inherited MouseEnter;
  FIsMouseOver := True;
  if FState <> obsPressed then
    FState := obsHover;
  Invalidate;
end;
procedure TONURRippleButton.MouseLeave;
begin
  inherited MouseLeave;
  FIsMouseOver := False;
  FState := obsNormal;
  Invalidate;
end;
procedure TONURRippleButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FState := obsPressed;
    StartRipple(X, Y); // Ripple başlat!
    Invalidate;
  end;
end;
procedure TONURRippleButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    if FIsMouseOver then
      FState := obsHover
    else
      FState := obsNormal;
    Invalidate;
  end;
end;
end.

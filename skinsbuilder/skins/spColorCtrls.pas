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

unit spColorCtrls;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     DynamicSkinForm, SkinData, SkinCtrlss, SkinBoxCtrls, Dialogs,
     StdCtrls, ExtCtrls, spEffBmp;

type

  TspCustomColorValues = array[1..12] of TColor;

  TspSkinCustomColorGrid = class(TspSkinPanel)
  private
    FColorValue: TColor;
    FOnChange: TNotifyEvent;
    FColCount, FRowCount: Integer;
    FColorIndex: Integer;
    procedure SetColCount(Value: Integer);
    procedure SetRowCount(Value: Integer);
  protected
    procedure DrawCursor(Cnvs: TCanvas; R: TRect; pmNotMode: Boolean);
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure PaintGrid(Cnvs: TCanvas);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    CustomColorValues: TspCustomColorValues;
    FColorsCount: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddColor(AColor: TColor);
  published
    property RowCount: Integer read FRowCount write SetRowCount;
    property ColCount: Integer read FColCount write SetColCount;
    property ColorValue: TColor read FColorValue;
    property OnChange: TNotifyEvent  read FOnChange write FOnChange;
  end;

  TspEmptyControl = class(TCustomControl)
  protected
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    procedure Paint; override;
  end;


  TspSkinColorGrid = class(TspSkinPanel)
  private
    FColorValue: TColor;
    FOnChange: TNotifyEvent;
    FColCount, FRowCount: Integer;
    procedure SetColCount(Value: Integer);
    procedure SetRowCount(Value: Integer);
    procedure SetColorValue(Value: TColor);
  protected
    procedure DrawCursor(Cnvs: TCanvas; R: TRect; pmNotMode: Boolean);
    function CheckColor(Value: TColor): boolean;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure PaintGrid(Cnvs: TCanvas);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RowCount: Integer read FRowCount write SetRowCount;
    property ColCount: Integer read FColCount write SetColCount;
    property ColorValue: TColor read FColorValue write SetColorValue;
    property OnChange: TNotifyEvent  read FOnChange write FOnChange;
  end;

  TspColorViewer = class(TGraphicControl)
  private
    FColorValue: TColor;
    procedure SetColorValue(Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property ColorValue: TColor read FColorValue write SetColorValue;
  end;

  const
    CalcEpsilon: Double = 1E-8;
    CalcRadian: Double = 3.1415926536 / 180;
    RectPSP: TRect = (Left:44; Top:44; Right:150; Bottom:150);
    RectActCol: TRect = (Left:21; Top:20; Right:69; Bottom:70);
    RectPreCol: TRect = (Left:21; Top:95; Right:69; Bottom:145);
    PalettePSPCoord: TRect = (Left:0; Top:0; Right:195; Bottom:195);
    MaxPixelCount = 32768;

  type

    THSL = record
      H, S, L: Double;
    end;

    TRGB = record
      R, G, B : byte;
    end;

    THSLPSP = record
      H, S, L: Byte;
    end;

    TPSPColor = class
    private
      FRGB : TRGB;
      FHSL : THSL;
      FHSLPSP : THSLPSP;
      function HSLToRGB (Value: THSL): TRGB;
      function RGBToHSL (Value: TRGB): THSL;
      function HSLToHSLPSP:THSLPSP;
      function HSLPSPToHSL:THSL;
      procedure SetRGB(const Value: TRGB);
      procedure SeTHSL(const Value: THSL);
      procedure SeTHSLPSP(const Value: THSLPSP);
    public
      constructor Create;
      destructor Destroy;override;
      procedure Assign(const Value : TPSPColor);
      property RGB : TRGB read FRGB write SetRGB;
      property HSL : THSL read FHSL write SeTHSL;
      property HSLPSP : THSLPSP read FHSLPSP write SeTHSLPSP;
    end;

  TClickZonePSP = (czpspPnone, czpspPCircle, czpspPCar);
  TLineB = array of Byte;
  TLineI = array of Integer;
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..MaxPixelCount - 1] of TRGBTriple;

  TspSkinColorDialog = class(TComponent)
  private
    RGBStopCheck: Boolean;
    HSLStopCheck: Boolean;
    FromPSP: Boolean;
  protected
    FColor: TColor;
    FCaption: String;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FEditSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultEditFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    FUseSkinFont: Boolean;
    //
    ColorGrid: TspSkinColorGrid;
    CustomColorGrid: TspSkinCustomColorGrid;
    OkButton, CancelButton, AddCustomColorButton: TspSkinButton;
    ColorViewer: TspColorViewer;
    REdit, GEdit, BEdit: TspSkinTrackEdit;
    RLabel, GLabel, BLabel, EQLabel: TspSkinStdLabel;
    HEdit, LEdit, SEdit: TspSkinTrackEdit;
    HLabel, LLabel, SLabel: TspSkinStdLabel;
    //
    PalettePSPPanel: TspEmptyControl;
    PalettePSP: TImage;
    PosCircle, PosCar: Integer;
    ClickImg: TClickZonePSP;
    PSPColor : TPSPColor;
    CustomColorValues: TspCustomColorValues;
    CustomColorValuesCount: Integer;
    function CalcAngle3Points(X1, Y1, Xc, Yc, X2, Y2: Double): Double;
    function CalcAnglePoints(X1, Y1, X2, Y2: Double): Double;
    procedure CalcAngle360(var Angle: Double);
    function CalcDistancePoints(X1, Y1, X2, Y2: Double): Double;
    function CalcArcCosRadians(CosAngle: Double): Double;
    function CalcArcSinRadians(SinAngle: Double): Double;
    procedure CalcRotationPoint(Xc, Yc: Double; Angle: Double; X1, Y1: Double; var X2, Y2: Double);
    procedure CalcPointSurEllipse(Xc, Yc: Double; RayonX, RayonY: Double; Angle: Double; var X, Y: Double);
    function CalcArcTan(TanAngle: Double): Double;
    procedure InitPSPPalette;
    procedure DrawPSPPalette;
    procedure DrawCursor;
    procedure PalettePSPMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); 
    procedure PalettePSPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PalettePSPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure ColorGridChange(Sender: TObject);
    procedure CustomColorGridChange(Sender: TObject);
    procedure RGBEditChange(Sender: TObject);
    procedure HSLEditChange(Sender: TObject);
    procedure AddCustomColorButtonClick(Sender: TObject);
    procedure ChangeEdits;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property Color: TColor read FColor write FColor;
    property Caption: String read FCaption write FCaption;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String
      read FLabelSkinDataName write FLabelSkinDataName;
    property EditSkinDataName: String
     read FEditSkinDataName write FEditSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

implementation

Uses spUtils, Math, spConst;

const
  ColorValues: array[1..48] of TColor =

  (0, 64, 128, 4210816, 255, 8421631, 32896, 16512, 33023, 4227327, 65535, 8454143,
   4227200, 16384, 32768, 65280, 65408, 8454016, 8421504, 4210688, 4227072, 8421376, 4259584, 8453888,
   8421440, 8388608, 16711680, 8404992, 16776960, 16777088, 12632256, 4194304, 10485760, 16744576, 12615680, 16744448,
   4194368, 5194368, 8388736, 4194432, 12615808, 12615935, 16777215, 8388672, 16711808, 8388863, 16711935, 16744703);


procedure ColorToR_G_B(C: TColor; var R, G, B: Byte);
begin
  R := C and $FF;
  G := (C shr 8) and $FF;
  B := (C shr 16) and $FF;
end;

function R_G_BToColor(R, G, B: Byte): TColor;
begin
  Result := RGB(R, G, B);
end;

procedure RGBToHSL1(AR, AV, AB: Byte; var H, S, L: Double);
var
  R,
  G,
  B,
  D,
  Cmax,
  Cmin: double;
begin
  R := AR / 255;
  G := AV / 255;
  B := AB / 255;
  Cmax := Max (R, Max (G, B));
  Cmin := Min (R, Min (G, B));
  L := (Cmax + Cmin) / 2;
  if Cmax = Cmin
  then
    begin
      H := 0;
      S := 0
    end
  else
    begin
      D := Cmax - Cmin;
      if L < 0.5 then S := D / (Cmax + Cmin) else S := D / (2 - Cmax - Cmin);
      if R = Cmax
      then
        H := (G - B) / D
      else
        if G = Cmax then H  := 2 + (B - R) /D else H := 4 + (R - G) / D;
      H := H / 6;
      if H < 0 then  H := H + 1;
    end;
end;

procedure RGBToHSL2(AR, AG, AB: Byte; var H, S, L: Integer);
var
  RGB: array[0..2] of Double;
  MinIndex, MaxIndex: Integer;
  Range: Double;
  H1 : Double;
begin
  RGB[0]:= AR;
  RGB[1]:= AG;
  RGB[2]:= AB;

  MinIndex:= 0;
  if AG < AR then MinIndex:= 1;
  if AB < RGB[MinIndex] then MinIndex:= 2;

  MaxIndex:= 0;
  if AG > AR then MaxIndex:= 1;
  if AB > RGB[MaxIndex] then MaxIndex:= 2;
  Range:= RGB[MaxIndex] - RGB[MinIndex];

  if Range = 0
  then
    begin
      S := 0;
      L := Round(100 * AR / 255); 
    end
  else
    begin
      H1 := MaxIndex * 2 + (AR - AG) / Range;
      S := Round(Range / RGB[MaxIndex] * 100);
      L :=  Round(100 * (RGB[MaxIndex] / 255));
      H1 := H1 / 6;
      if H1 < 0 then H1 := H1 + 1;
      H := Round(H1 * 359);
    end;
end;

procedure RGBToHSL(AR, AG, AB: Byte; var RH, RS, RL: Integer);
var
  H, S, L: Double;
begin
  RGBToHSL1(AR, AG, AB, H, S, L);
  RGBToHSL2(AR, AG, AB, RH, RS, RL);
  if RS <> 0 then RH := Round(H * 359);
end;

procedure HSLToRGB(var R, G, B: Byte; RH, RS, RL: Integer);
const 
  SectionSize = 60/360;
var 
  Section: Double; 
  SectionIndex: Integer; 
  f, p, q, t, H, S, L: Double;
begin
  H := RH / 360;
  S := RS / 100;
  L := (255 * RL / 100);
  if S = 0
  then
    begin
      R := Round(L);
      G := R;
      B := R;
    end
  else
   begin
     Section := H / SectionSize;
     SectionIndex := Floor(Section);
     f := Section - SectionIndex;
     p := L * ( 1 - S );
     q := L * ( 1 - S * f );
     t := L * ( 1 - S * ( 1 - f ) );
     case SectionIndex of
      0:
        begin
          R := Round(L);
          G := Round(t);
          B := Round(p);
        end;
      1:
        begin
          R := Round(q);
          G := Round(L);
          B := Round(p);
        end;
      2:
        begin
          R := Round(p);
          G := Round(L);
          B := Round(t);
        end;
      3:
        begin
          R := Round(p);
          G := Round(q);
          B := Round(L);
        end;
      4:
        begin
          R := Round(t);
          G := Round(p);
          B := Round(L);
        end;
    else
      R := Round(L);
      G := Round(p);
      B := Round(q);
    end;
  end;
end;

procedure TspEmptyControl.WMEraseBkgnd;
begin
  Msg.Result := 1;
end;

procedure TspEmptyControl.Paint;
begin
end;

constructor TspSkinColorGrid.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csAcceptsControls];
  CaptionMode := True;
  Caption := SP_COLORGRID_CAP;
  BorderStyle := bvFrame;
  Width := 280;
  Height := 115;
  FColorValue := 0;
  FColCount := 12;
  FRowCount := 4;
end;

destructor TspSkinColorGrid.Destroy;
begin
  inherited;
end;

procedure TspSkinColorGrid.SetColCount(Value: Integer);
begin
  if Value < 1 then Exit;
  FColCount := Value;
  RePaint;
end;

procedure TspSkinColorGrid.SetRowCount(Value: Integer);
begin
  FRowCount := Value;
  RePaint;
end;

procedure TspSkinColorGrid.DrawCursor;
var
  CX, CY, Rd: Integer;
begin
  CX := R.Left + RectWidth(R) div 2;
  CY := R.Top + RectHeight(R) div 2;
  if RectWidth(R) > RectHeight(R)
  then
    Rd := RectHeight(R) div 2 - 2
  else
    Rd := RectWidth(R) div 2 - 2;
  with Cnvs do
  begin
    if pmNotMode then Pen.Mode := pmNot else Pen.Color := 0;
    MoveTo(CX - rd, CY); LineTo(CX - 2, CY);
    MoveTo(CX + 3, CY); LineTo(CX + rd + 1, CY);
    MoveTo(CX, CY - rd); LineTo(CX, CY - 2);
    MoveTo(CX, CY + 3); LineTo(CX, CY + rd);
  end;
end;

procedure TspSkinColorGrid.PaintGrid(Cnvs: TCanvas);
var
  X, Y, CW, CH, i, j, k: Integer;
  R, Rct: TRect;
begin
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  CW := (RectWidth(R) - ColCount * 2) div ColCount;
  CH := (RectHeight(R) - RowCount * 2) div RowCount;
  Y := R.Top + 1;
  k := 0;
  for i := 1 to RowCount do
  begin
    X := R.Left + 1;
    for j := 1 to ColCount do
    begin
      Inc(k);
      with Cnvs do
      begin
        Brush.Color := ColorValues[k];
        Rct := Rect(X, Y, X + CW, Y + CH);
        InflateRect(Rct, -1, -1);
        FillRect(Rct);
        InflateRect(Rct, 1, 1);
        if FColorValue = ColorValues[k]
        then
          begin
            if ColorValues[k] <> clGray
            then
              DrawCursor(Cnvs, Rct, True)
            else
              DrawCursor(Cnvs, Rct, False);
          end
      end;
      Inc(X, CW + 2);
    end;
    Inc(Y, CH + 2);
  end;
end;

procedure TspSkinColorGrid.CreateControlDefaultImage;
begin
  inherited;
  PaintGrid(B.Canvas);
end;

procedure TspSkinColorGrid.CreateControlSkinImage;
begin
  inherited;
  PaintGrid(B.Canvas);
end;

function TspSkinColorGrid.CheckColor(Value: TColor): boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to 48 do
    if ColorValues[I] = Value
    then
      begin
        Result := True;
        Break;
      end;
end;

procedure TspSkinColorGrid.SetColorValue(Value: TColor);
begin
  FColorValue := Value;
  if CheckColor(FColorValue)
  then
    begin
      if Assigned(FOnChange) then FOnChange(Self);
      RePaint;
    end;
end;

procedure TspSkinColorGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                     X, Y: Integer);
var
  X1, Y1, CW, CH, i, j, k: Integer;
  R, Rct: TRect;
begin
  inherited;
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  CW := (RectWidth(R) - ColCount * 2) div ColCount;
  CH := (RectHeight(R) - RowCount * 2) div RowCount;
  Y1 := R.Top + 1;
  k := 0;
  for i := 1 to RowCount do
  begin
    X1 := R.Left + 1;
    for j := 1 to ColCount do
    begin
      Inc(k);
      Rct := Rect(X1, Y1, X1 + CW, Y1 + CH);
      if PtInRect(Rct, Point(X, Y))
      then
        begin
          ColorValue := ColorValues[k];
          Break;
        end;
      Inc(X1, CW + 2);
    end;
    Inc(Y1, CH + 2);
  end;  
end;


constructor TspColorViewer.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque];
  FColorValue := 0;
end;

procedure TspColorViewer.Paint;
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Width := Width;
  B.Height := Height;
  with B.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := FColorValue;
    Rectangle(0, 0, Width, Height);
  end;
  Canvas.Draw(0, 0, B);
  B.Free;
end;

procedure TspColorViewer.SetColorValue;
begin
  if FColorValue = Value then Exit;
  FColorValue := Value;
  RePaint;
end;

function TPSPColor.RGBToHSL(Value: TRGB): THSL;
var
  R,
  G,
  B,
  D,
  Cmax,
  Cmin: double;

begin
  R := Value.R / 255;
  G := Value.G / 255;
  B := Value.B / 255;
  Cmax := Max (R, Max (G, B));
  Cmin := Min (R, Min (G, B));

// calculate luminosity
  Result.L := (Cmax + Cmin) / 2;

  if Cmax = Cmin then
  begin
    Result.H := 0; 
    Result.S := 0
  end else begin
    D := Cmax - Cmin;

// calculate Saturation
    if Result.L < 0.5 then
      Result.S := D / (Cmax + Cmin)
    else
      Result.S := D / (2 - Cmax - Cmin);

// calculate Hue
    if R = Cmax then
      Result.H := (G - B) / D
    else
      if G = Cmax then
        Result.H  := 2 + (B - R) /D
      else
        Result.H := 4 + (R - G) / D;

    Result.H := Result.H / 6;
    if Result.H < 0 then
      Result.H := Result.H + 1
  end
end;

function TPSPColor.HSLToRGB(Value: THSL): TRGB;
var
  M1,
  M2: double;

  function HueToColourValue (Hue: double) : byte;
  var
    V : double;
  begin
    if Hue < 0 then
      Hue := Hue + 1
    else
      if Hue > 1 then
        Hue := Hue - 1;

    if 6 * Hue < 1 then
      V := M1 + (M2 - M1) * Hue * 6
    else
    if 2 * Hue < 1 then
      V := M2
    else
    if 3 * Hue < 2 then
      V := M1 + (M2 - M1) * (2/3 - Hue) * 6
    else
      V := M1;
    Result := round (255 * V)
  end;

begin
  if Value.S = 0 then
  begin
    Result.R := round (255 * Value.L);
    Result.G := Result.R;
    Result.B := Result.R
  end else begin
    if Value.L <= 0.5 then
      M2 := Value.L * (1 + Value.S)
    else
      M2 := Value.L + Value.S - Value.L * Value.S;
    M1 := 2 * Value.L - M2;
    Result.R := HueToColourValue (Value.H + 1/3);
    Result.G := HueToColourValue (Value.H);
    Result.B := HueToColourValue (Value.H - 1/3)
  end;
end;

function TPSPColor.HSLToHSLPSP: THSLPSP;
begin
  Result.H := round(FHSL.H*255);
  Result.S := round(FHSL.S*255);
  Result.L := round(FHSL.L*255);
end;

function TPSPColor.HSLPSPToHSL: THSL;
begin
  Result.H := FHSLPSP.H/255;
  Result.S := FHSLPSP.S/255;
  Result.L := FHSLPSP.L/255;
end;

constructor TPSPColor.Create;
begin
  inherited;
end;

destructor TPSPColor.Destroy;
begin

  inherited;
end;

procedure TPSPColor.SetRGB(const Value: TRGB);
begin
  FRGB := Value;
  FHSL := RGBToHSL(FRGB);
  FHSLPSP := HSLToHSLPSP();
end;

procedure TPSPColor.SeTHSL(const Value: THSL);
begin
  FHSL := Value;
  FRGB := HSLToRGB(FHSL);
  FHSLPSP := HSLToHSLPSP;
end;

procedure TPSPColor.SeTHSLPSP(const Value: THSLPSP);
begin
  FHSLPSP := Value;
  FHSL := HSLPSPToHSL;
  FRGB := HSLToRGB(FHSL);
end;

procedure TPSPColor.Assign(const Value: TPSPColor);
begin
  FRGB := Value.FRGB;
  FHSL := Value.FHSL;
  FHSLPSP := Value.FHSLPSP;
end;

constructor TspSkinColorDialog.Create;
var
  I: Integer;
begin
  inherited Create(AOwner);

  RGBStopCheck := False;
  HSLStopCheck := False;
  FromPSP := False;

  FColor := 0;
  PSPColor := TPSPColor.Create;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FCaption := 'Set color';

  FButtonSkinDataName := 'button';
  FLabelSkinDataName := 'stdlabel';
  FEditSkinDataName := 'edit';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;

  with FDefaultEditFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;

  for I := 1 to 12 do CustomColorValues[I] := clWhite;
  CustomColorValuesCount := 0;
end;

destructor TspSkinColorDialog.Destroy;
begin
  PSPColor.Free;
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited;
end;

procedure TspSkinColorDialog.ChangeEdits;
var
  R, G, B: Byte;
begin
  FromPSP := True;
  R := PSPColor.FRGB.R;
  G := PSPColor.FRGB.G;
  B := PSPColor.FRGB.B;
  REdit.Value := R;
  GEdit.Value := G;
  BEdit.Value := B;
  FromPSP := False;
end;

procedure TspSkinColorDialog.HSLEditChange(Sender: TObject);
var
  R, G, B: Byte;
  RGB: TRGB;
begin
  if HSLStopCheck then Exit;
  HSLTORGB(R, G, B, HEdit.Value, SEdit.Value, LEdit.Value);
  ColorViewer.ColorValue := R_G_BToColor(R, G, B);
  RGBStopCheck := True;
  //
  REdit.Value := R;
  GEdit.Value := G;
  BEdit.Value := B;
  //
  if not FromPSP
  then
    begin
      DrawCursor;
      RGB.R := R;
      RGB.G := G;
      RGB.B := B;
      PSPColor.SetRGB(RGB);
      DrawPSPPalette;
    end;  
  //
  RGBStopCheck := False;
end;

procedure TspSkinColorDialog.AddCustomColorButtonClick(Sender: TObject);
begin
  CustomColorGrid.AddColor(ColorViewer.ColorValue);
end;

procedure TspSkinColorDialog.RGBEditChange(Sender: TObject);
var
  R, G, B: Byte;
  H, S, L: Integer;
  RGB: TRGB;
begin
  if RGBStopCheck then Exit;
  ColorViewer.ColorValue := R_G_BToColor(REdit.Value, GEdit.Value, BEdit.Value);
  ColorToR_G_B(ColorViewer.ColorValue, R, G, B);
  HSLStopCheck := True;
  RGBToHSL(R, G, B, H, S, L);
  HEdit.Value := H;
  SEdit.Value := S;
  LEdit.Value := L;
  //
  if not FromPSP
  then
    begin
      DrawCursor;
      RGB.R := R;
      RGB.G := G;
      RGB.B := B;
      PSPColor.SetRGB(RGB);
      DrawPSPPalette;
    end;  
  //
  HSLStopCheck := False;
end;

procedure TspSkinColorDialog.CustomColorGridChange(Sender: TObject);
var
  R, G, B: Byte;
  H, S, L: Integer;
  RGB: TRGB;
begin
  ColorToR_G_B(CustomColorGrid.ColorValue, R, G, B);
  RGBStopCheck := True;
  REdit.Value := R;
  GEdit.Value := G;
  BEdit.Value := B;
  RGBStopCheck := False;
  ColorViewer.ColorValue := CustomColorGrid.ColorValue;
  RGBToHSL(R, G, B, H, S, L);
  HSLStopCheck := True;
  HEdit.Value := H;
  SEdit.Value := S;
  LEdit.Value := L;
  if not FromPSP
  then
    begin
      DrawCursor;
      RGB.R := R;
      RGB.G := G;
      RGB.B := B;
      PSPColor.SetRGB(RGB);
      DrawPSPPalette;
    end;  
  HSLStopCheck := False;
end;

procedure TspSkinColorDialog.ColorGridChange(Sender: TObject);
var
  R, G, B: Byte;
  H, S, L: Integer;
  RGB: TRGB;
begin
  ColorToR_G_B(ColorGrid.ColorValue, R, G, B);
  RGBStopCheck := True;
  REdit.Value := R;
  GEdit.Value := G;
  BEdit.Value := B;
  RGBStopCheck := False;
  ColorViewer.ColorValue := ColorGrid.ColorValue;
  RGBToHSL(R, G, B, H, S, L);
  HSLStopCheck := True;
  HEdit.Value := H;
  SEdit.Value := S;
  LEdit.Value := L;
  if not FromPSP
  then
    begin
      DrawCursor;
      RGB.R := R;
      RGB.G := G;
      RGB.B := B;
      PSPColor.SetRGB(RGB);
      DrawPSPPalette;
    end;  
  HSLStopCheck := False;
end;

procedure TspSkinColorDialog.SetDefaultLabelFont;
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinColorDialog.SetDefaultEditFont;
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinColorDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinColorDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinColorDialog.Execute: Boolean;
var
  Form: TForm;
  DSF: TspDynamicSkinForm;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  R, G, B: Byte;
  Temp : TRGB;
  I: Integer;
  PSPBGColor: TColor;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := FCaption;
  Form.Position := poScreenCenter;

  DSF := TspDynamicSkinForm.Create(Form);
  DSF.SizeAble := False;
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  try

  Form.ClientWidth := 378;

  ColorGrid := TspSkinColorGrid.Create(Form);
  with ColorGrid do
  begin
    BorderStyle := bvNone;
    Parent := Form;
    CaptionMode := True;
    RowCount := 8;
    ColCount := 6;
    Left := 5;
    Top := 5;
    Width := 167;
    Height := 195;
    SkinDataName := 'groupbox';
    SkinData := CtrlSkinData;
    OnChange := ColorGridChange;
  end;

  CustomColorGrid := TspSkinCustomColorGrid.Create(Form);
  with CustomColorGrid  do
  begin
    Parent := Form;
    CaptionMode := True;
    Left := 5;
    Top := ColorGrid.Top + ColorGrid.Height + 10;
    Width := 167;
    Height := 68;
    SkinDataName := 'groupbox';
    SkinData := CtrlSkinData;
    OnChange := CustomColorGridChange;
  end;

  for I := 1 to 12 do
    CustomColorGrid.CustomColorValues[I] := Self.CustomColorValues[I];
  CustomColorGrid.FColorsCount := CustomColorValuesCount;

  //
  PalettePSPPanel:= TspEmptyControl.Create(Form);
  with PalettePSPPanel do
  begin
    Parent := Form;
    Top := 5;
    Left := ColorGrid.Left + ColorGrid.Width + 5;
    Width := 195;
    Height := 195;
  end;

  PalettePSP := TImage.Create(Form);
  with PalettePSP do
  begin
    Parent := PalettePSPPanel;
    Top := 0;
    Left := 0;
    Width := 195;
    Height := 195;
    OnMouseMove := PalettePSPMouseMove;
    OnMouseUp := PalettePSPMouseUp;
    OnMouseDown := PalettePSPMouseDown;
    Picture.Bitmap.PixelFormat := pf32bit;
    Picture.Bitmap.width := PalettePSP.width;
    Picture.Bitmap.height := PalettePSP.Height;
  end;


  ClickImg := czpspPnone;

  Temp.R := 0;
  Temp.G := 0;
  Temp.B := 0;
  PSPColor.RGB := Temp;
  PosCircle := (PalettePSP.Width-PalettePSPCoord.Right)div 2;
  PosCar := PosCircle;
  InitPSPPalette;
  //

  RLabel := TspSkinStdLabel.Create(Form);
  with RLabel do
  begin
    Parent := Form;
    Left := PalettePSPPanel.Left;
    Top := ColorGrid.Top + ColorGrid.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'R:';
  end;

   REdit := TspSkinTrackEdit.Create(Self);
   with REdit do
   begin
     Parent := Form;
     PopupKind := tbpLeft;
     SetBounds(RLabel.Left + RLabel.Width + 5, ColorGrid.Top + ColorGrid.Height + 10, 50, 21);
     TrackBarWidth := 200;
     MinValue := 0;
     MaxValue := 255;
     Value := 0;
     SkinData := CtrlSkinData;
     JumpWhenClick := True;
     OnChange := RGBEditChange;
   end;

  GLabel := TspSkinStdLabel.Create(Form);
  with GLabel do
  begin
    Parent := Form;
    Left := PalettePSPPanel.Left;
    Top := REdit.Top + REdit.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'G:';
  end;

   GEdit := TspSkinTrackEdit.Create(Self);
   with GEdit do
   begin
     Parent := Form;
     PopupKind := tbpLeft;
     SetBounds(REdit.Left, REdit.Top + REdit.Height + 10, 50, 21);
     TrackBarWidth := 200;
     MinValue := 0;
     MaxValue := 255;
     Value := 0;
     SkinData := CtrlSkinData;
     JumpWhenClick := True;
     OnChange := RGBEditChange;
   end;

  BLabel := TspSkinStdLabel.Create(Form);
  with BLabel do
  begin
    Parent := Form;
    Left := PalettePSPPanel.Left;
    Top := GEdit.Top + GEdit.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'B:';
  end;

   BEdit := TspSkinTrackEdit.Create(Self);
   with BEdit do
   begin
     Parent := Form;
     PopupKind := tbpLeft;
     SetBounds(REdit.Left, GEdit.Top + GEdit.Height + 10, 50, 21);
     TrackBarWidth := 200;
     MinValue := 0;
     MaxValue := 255;
     Value := 0;
     SkinData := CtrlSkinData;
     JumpWhenClick := True;
     OnChange := RGBEditChange;
   end;

  HLabel := TspSkinStdLabel.Create(Form);
  with HLabel do
  begin
    Parent := Form;
    Left := REdit.Left + REdit.Width + 5;
    Top := ColorGrid.Top + ColorGrid.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'H:';
  end;

  HEdit := TspSkinTrackEdit.Create(Self);
  with HEdit do
  begin
    Parent := Form;
    PopupKind := tbpLeft;
    SetBounds(HLabel.Left + HLabel.Width + 5, ColorGrid.Top + ColorGrid.Height + 10, 50, 21);
    TrackBarWidth := 250;
    MinValue := 0;
    MaxValue := 359;
    Value := 0;
    SkinData := CtrlSkinData;
    JumpWhenClick := True;
    OnChange := HSLEditChange;
  end;

  SLabel := TspSkinStdLabel.Create(Form);
  with SLabel do
  begin
    Parent := Form;
    Left := REdit.Left + REdit.Width + 5;
    Top := HEdit.Top + HEdit.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'S:';
  end;

  SEdit := TspSkinTrackEdit.Create(Self);
  with SEdit do
  begin
    Parent := Form;
    PopupKind := tbpLeft;
    SetBounds(HEdit.Left, HEdit.Top + HEdit.Height + 10, 50, 21);
    TrackBarWidth := 120;
    MinValue := 0;
    MaxValue := 100;
    Value := 0;
    SkinData := CtrlSkinData;
    JumpWhenClick := True;
    OnChange := HSLEditChange;
  end;

  LLabel := TspSkinStdLabel.Create(Form);
  with LLabel do
  begin
    Parent := Form;
    Left := REdit.Left + REdit.Width + 5;
    Top := SEdit.Top + SEdit.Height + 12;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := 'L:';
  end;

  LEdit := TspSkinTrackEdit.Create(Self);
  with LEdit do
  begin
    Parent := Form;
    PopupKind := tbpLeft;
    SetBounds(HEdit.Left, SEdit.Top + SEdit.Height + 10, 50, 21);
    TrackBarWidth := 120;
    MinValue := 0;
    MaxValue := 100;
    Value := 0;
    SkinData := CtrlSkinData;
    JumpWhenClick := True;
    OnChange := HSLEditChange;
  end;

  ColorViewer := TspColorViewer.Create(Form);
  with ColorViewer do
  begin
    Parent := Form;
    SetBounds(HEdit.Left + HEdit.Width + 5,
              PalettePSPPanel.Top + PalettePSPPanel.Height + 10,
              PalettePSPPanel.Left + PalettePSPPanel.Width - (HEdit.Left + HEdit.Width + 5),
              PalettePSPPanel.Left + PalettePSPPanel.Width - (HEdit.Left + HEdit.Width + 5));
  end;

  ButtonTop := LEdit.Top + LEdit.Height + 15;
  ButtonWidth := 70;
  ButtonHeight := 25;


  OkButton := TspSkinButton.Create(Form);
  with OkButton do
   begin
     Parent := Form;
     DefaultFont := DefaultButtonFont;
     UseSkinFont := Self.UseSkinFont;
     if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
     then
       Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
     else
       Caption := SP_MSG_BTN_OK;
     ModalResult := mrOk;
     Default := True;
     SetBounds(5, ButtonTop, ButtonWidth, ButtonHeight);
     DefaultHeight := ButtonHeight;
     SkinDataName := FButtonSkinDataName;
     SkinData := CtrlSkinData;
   end;

  CancelButton := TspSkinButton.Create(Form);
  with CancelButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(90, ButtonTop, ButtonWidth,
              ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
  end;

  AddCustomColorButton := TspSkinButton.Create(Form);
  with AddCustomColorButton do
   begin
     Parent := Form;
     DefaultFont := DefaultButtonFont;
     UseSkinFont := Self.UseSkinFont;
     if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
     then
       Caption := CtrlSkinData.ResourceStrData.GetResStr('ADDCUSTOMCOLORBUTTON_CAP')
     else
       Caption := SP_ADDCUSTOMCOLORBUTTON_CAP;
     SetBounds(PalettePSPPanel.Left, ButtonTop, PalettePSPPanel.Width, ButtonHeight);
     DefaultHeight := ButtonHeight;
     SkinDataName := FButtonSkinDataName;
     SkinData := CtrlSkinData;
     OnClick := AddCustomColorButtonClick;
   end;

  Form.ClientHeight := AddCustomColorButton.Top + AddCustomColorButton.Height + 10;

  ColorViewer.ColorValue := Color;
  ColorGrid.ColorValue := Color;
  ColorToR_G_B(Color, R, G, B);


  REdit.Value := R;
  GEdit.Value := G;
  BEdit.Value := B;

    if Form.ShowModal = mrOk
    then
      begin
        Color := ColorViewer.ColorValue;
        for I := 1 to 12 do
          Self.CustomColorValues[I] := CustomColorGrid.CustomColorValues[I];
        CustomColorValuesCount := CustomColorGrid.FColorsCount;  
        Result := True;
      end
    else
      Result := False;

  finally
    Form.Free;
  end;
end;

procedure TspSkinColorDialog.CalcAngle360(var Angle: Double);
begin
  while (Angle < 0) do Angle := Angle + 360;
  while (Angle >= 360) do Angle:=Angle - 360;
end;

function TspSkinColorDialog.CalcAngle3Points(X1, Y1, Xc, Yc, X2, Y2: Double): Double;
var
  Angle1, Angle2, Angle: Double;
begin
  Angle1 := CalcAnglePoints(Xc, Yc, X1, Y1);
  Angle2 := CalcAnglePoints(Xc, Yc, X2, Y2);
  Angle := Angle2-Angle1;
  CalcAngle360(Angle);
  CalcAngle3Points := Angle;
end;

procedure TspSkinColorDialog.CalcRotationPoint(Xc, Yc, Angle, X1, Y1: Double; var X2,Y2: Double);
var
  Angle0: Double;
  Distance: Double;
begin
  Angle0 := CalcAnglePoints(Xc, Yc, X1, Y1);
  Distance := CalcDistancePoints(Xc, Yc, X1, Y1);
  CalcPointSurEllipse(Xc, Yc, Distance, Distance, Angle0 + Angle, X2, Y2);
end;

procedure TspSkinColorDialog.CalcPointSurEllipse(Xc, Yc, RayonX, RayonY, Angle: Double;
  var X, Y: Double);
var
  Angle1, AngleA: Double;
  A, B: Double;
begin
  CalcAngle360(Angle);
  Angle1 := 90 - Angle;
  A := Cos(Angle1 * CalcRadian) * RayonX;
  B := Sin(Angle1 * CalcRadian) * RayonY;
  if (Abs(B) < CalcEpsilon)
  then
    if (Abs(Angle - 90) < 1E-7)
    then
      AngleA := 90
    else
      AngleA := 270
  else
  begin
    AngleA := CalcArcTan(A/B);
    if (Angle < 90)
    then
    else
      if (Angle < 270)
      then
        AngleA := AngleA + 180
      else
        AngleA := AngleA + 0;
  end;
  Y := Yc + Sin(AngleA * CalcRadian) * RayonY;
  X := Xc + Cos(AngleA * CalcRadian) * RayonX;
end;

function TspSkinColorDialog.CalcArcTan(TanAngle: Double): Double;
begin
  CalcArcTan := Arctan(TanAngle) / CalcRadian;
end;

function TspSkinColorDialog.CalcAnglePoints(X1, Y1, X2, Y2: Double): Double;
var
  Distance, CosAngle, Angle: Double;
begin
  Distance := CalcDistancePoints(X1, Y1, X2, Y2);
  if (Abs(Distance) < CalcEpsilon)
  then
    Angle := 0
  else
  begin
    CosAngle := Abs(X1 - X2) / Distance;
    Angle := CalcArcCosRadians(CosAngle);
    if (Abs(Y1 - Y2) >= CalcEpsilon) and (Y2 < Y1) then Angle := -Angle;
    if (Abs(X1-X2) >= CalcEpsilon) and (X2 < X1) then Angle := Pi-Angle;
    if (Abs(Angle) < CalcEpsilon) then Angle:=0;
    if (Angle < 0) then Angle := Angle + 2 * Pi;
    Angle := Angle / CalcRadian;
  end;
  CalcAnglePoints := Angle;
end;

function TspSkinColorDialog.CalcArcCosRadians(CosAngle: Double): Double;
var
  Angle: Double;
begin
  Angle := Pi/2 - CalcArcSinRadians(CosAngle);
  CalcArcCosRadians := Angle;
end;

function TspSkinColorDialog.CalcArcSinRadians(SinAngle: Double): Double;
var
  Diviseur, Angle: Double;
begin
  Diviseur := Sqrt(1 - Sqr(SinAngle));
  if (Abs(Diviseur) < CalcEpsilon)
  then
    if (SinAngle > 0)
    then
      Angle := Pi/2
    else
      Angle := -Pi/2
  else
    Angle := ArcTan(SinAngle / Diviseur);
  CalcArcSinRadians := Angle;
end;

function TspSkinColorDialog.CalcDistancePoints(X1, Y1, X2, Y2: Double): Double;
begin
  CalcDistancePoints := Sqrt(Sqr(Y2 - Y1) + Sqr(X2 - X1));
end;

procedure TspSkinColorDialog.InitPSPPalette;
var
  GCircle, PCircle, Disque: HRGN;
  PLigneCircle: pointer;
  I, J : Integer;
  C_X, C_Y: Integer;
  Col: TPSPColor;
  Col2: THSL;
  Val: THSL;
  TabCol: array[0..359]of TRGB;
  Angle: Integer;
  PanelData: TspDataSkinPanelControl;
  PanelDataIndex: Integer;
  NewClRect: TRect;
  w, h, rw, rh, X, Y, XCnt, YCnt, XO, YO: Integer;
  SB: TBitMap;
begin

  Col := TPSPColor.Create;

  GCircle := CreateEllipticRgn(PalettePSPCoord.Left, PalettePSPCoord.Top,
    PalettePSPCoord.Right, PalettePSPCoord.Bottom);
  PCircle := CreateEllipticRgn((PalettePSPCoord.Left + 20),
    (PalettePSPCoord.Top + 20), (PalettePSPCoord.Right - 20), (PalettePSPCoord.Bottom - 20));

  Disque := CreateRectRgn(0, 0, 2, 2);
  CombineRgn(Disque, GCircle, PCircle, RGN_DIFF);

  Val.S := 1;
  Val.L := 0.47;
  for I := 0 to 359 do
  begin
    Val.H := I/359;
    Col.HSL := Val;
    TabCol[I] := Col.RGB;
  end;

  C_X := PalettePSPCoord.Left + 98;
  C_Y := PalettePSPCoord.Left + 98;

  Val.S := 0.93;
  Val.L := 0.47;

  // Draw background
  if (FCtrlFSD <> nil) and not FCtrlFSD.Empty and
     (FCtrlFSD.GetControlIndex('panel') <> -1)
  then
    begin
      PanelDataIndex := FCtrlFSD.GetControlIndex('panel');
      PanelData := TspDataSkinPanelControl(FCtrlFSD.CtrlList.Items[PanelDataIndex]);
      SB := TBitMap(FCtrlFSD.FActivePictures.Items[PanelData.PictureIndex]);
      NewClRect := Rect(0, 0, PalettePSP.Width, PalettePSP.Height);
      w := RectWidth(PanelData.ClRect);
      h := RectHeight(PanelData.ClRect);
      rw := RectWidth(NewClRect);
      rh := RectHeight(NewClRect);
      XCnt := rw div w;
      YCnt := rh div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        begin
          if X * w + w > rw then XO := X * W + W - rw else XO := 0;
          if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
          PalettePSP.Canvas.CopyRect(
             Rect(NewClRect.Left + X * w, NewClRect.Top + Y * h,
                  NewClRect.Left + X * w + w - XO, NewClRect.Top + Y * h + h - YO),
             SB.Canvas,
             Rect(PanelData.SkinRect.Left + PanelData.ClRect.Left,
                  PanelData.SkinRect.Top + PanelData.ClRect.Top,
             PanelData.SkinRect.Left + PanelData.ClRect.Right - XO,
             PanelData.SkinRect.Top + PanelData.ClRect.Bottom - YO));
         end;
     end
  else
    begin
      PalettePSP.Canvas.Pen.Color := ColorToRGB(clBtnFace);
      PalettePSP.Canvas.Brush.Color := ColorToRGB(clBtnFace);
      Rectangle(PalettePSP.Canvas.Handle, 0, 0, PalettePSP.Width, PalettePSP.Height);
    end;
  //

  for J := 0 to PalettePSPCoord.Bottom - 1 do
  begin
    PLigneCircle := PalettePSP.Picture.Bitmap.ScanLine[PalettePSPCoord.Top+J];
    for I := 0 to PalettePSPCoord.Bottom do
      if PtInRegion(Disque,PalettePSPCoord.Left+I,PalettePSPCoord.Top+J) then
      begin
        Angle := Round(CalcAngle3Points(C_X, 0, C_X, C_Y, I, J));
        if Angle = 360 then Angle := 0;
        Angle := 359 - Angle;
        TLineB(PLigneCircle)[(PosCircle+I)*4 + 0] := TabCol[Angle].B;
        TLineB(PLigneCircle)[(PosCircle+I)*4 + 1] := TabCol[Angle].G;
        TLineB(PLigneCircle)[(PosCircle+I)*4 + 2] := TabCol[Angle].R;

      end;
  end;

  Col.Assign(PSPColor);
  Col2 := Col.HSL;

  for J :=RectPSP.Top to RectPSP.Bottom do
  begin
    PLigneCircle := PalettePSP.Picture.Bitmap.ScanLine[J];
    Col2.L := (J-RectPSP.Top)/(RectPSP.Bottom-RectPSP.Top);
    for I := RectPSP.Left to (RectPSP.Right) do
      begin
        Col2.S := (I-RectPSP.Left)/(RectPSP.Right-RectPSP.Left);
        Col.HSL := Col2;
        TLineB(PLigneCircle)[(I+PosCar)*4    ] := Col.RGB.B;
        TLineB(PLigneCircle)[(I+PosCar)*4 + 1] := Col.RGB.G;
        TLineB(PLigneCircle)[(I+PosCar)*4 + 2] := Col.RGB.R;
      end;
  end;
  PalettePSP.Canvas.Pen.Color := $FFFFFF;
  PalettePSP.Canvas.Pen.Mode := pmXor;
  PalettePSP.Canvas.Brush.Style := bsClear;
  DrawCursor;
  PalettePSP.Picture.Bitmap.modified := true;
  Col.Free;
end;

procedure TspSkinColorDialog.DrawPSPPalette;
  procedure DrawRect;
  var
    PLigneCircle : pointer;
    I, J : Integer;
    Col : TPSPColor;
    Col2 : THSL;
  begin
    Col := TPSPColor.Create;
    Col.Assign(PSPColor);
    Col2 := Col.HSL;
    for J :=RectPSP.Top to RectPSP.Bottom do
    begin
      PLigneCircle := PalettePSP.Picture.Bitmap.ScanLine[J];
      Col2.L := (J-RectPSP.Top)/(RectPSP.Bottom-RectPSP.Top);
      for I := RectPSP.Left to (RectPSP.Right) do
        begin
          Col2.S := (I-RectPSP.Left)/(RectPSP.Right-RectPSP.Left);
          Col.HSL := Col2;
          TLineB(PLigneCircle)[(I+PosCar)*4    ] := Col.RGB.B;
          TLineB(PLigneCircle)[(I+PosCar)*4 + 1] := Col.RGB.G;
          TLineB(PLigneCircle)[(I+PosCar)*4 + 2] := Col.RGB.R;
        end;
    end;
    Col.free;
  end;
begin
  DrawRect;
  DrawCursor;
  PalettePSP.Picture.Bitmap.Modified := true;
end;


procedure TspSkinColorDialog.DrawCursor;
  procedure DrawCircle(X,Y,R:Integer);
  begin
    Ellipse(PalettePSP.Canvas.Handle,X - R, Y - R,X + R, Y + R);
  end;
var
  Angle: Integer;
  X,Y: Double;
  C_X,C_Y:  Integer;
begin
  X := round((PSPColor.HSL.S * (RectPSP.Right-RectPSP.Left)) + (PosCar + RectPSP.Left));
  Y := round((PSPColor.HSL.L * (RectPSP.Bottom-RectPSP.Top)) + RectPSP.Top);
  DrawCircle(Round(X), Round(Y),5);
  C_X := PosCar + RectPSP.Left + (RectPSP.Right-RectPSP.Left)div 2;
  C_Y := RectPSP.Top + (RectPSP.Bottom - RectPSP.Top)div 2;
  Angle := Round(PSPColor.HSL.H * 360);
  CalcRotationPoint(C_X, C_Y, -Angle, C_X, C_Y-((PalettePSPCoord.Bottom-20) div 2), X,Y);
  DrawCircle(Round(X),Round(Y),5);
end;

procedure TspSkinColorDialog.PalettePSPMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  GCircle, PCircle, Disque, Car: HRGN;
  HSLPSP: THSLPSP;
  C_X,C_Y: Integer;
  Angle: Integer;
begin
  GCircle := CreateEllipticRgn(PosCircle+PalettePSPCoord.Left,PalettePSPCoord.Top,PosCircle+PalettePSPCoord.Right,PalettePSPCoord.Bottom);
  PCircle := CreateEllipticRgn(PosCircle+PalettePSPCoord.Left+20,PalettePSPCoord.Top+20,PosCircle+PalettePSPCoord.Right-21,PalettePSPCoord.Bottom-21);
  Disque := CreateRectRgn(0,0,2,2);
  CombineRgn(Disque,GCircle,PCircle,RGN_DIFF);

  Car := CreateRectRgn(PosCar+RectPSP.Left,RectPSP.Top,PosCar+RectPSP.Right,RectPSP.Bottom);
  if PtInRegion(Car,X,Y)
  then
    ClickImg := czpspPCar
  else
  if PtInRegion(Disque,X,Y)
  then
    ClickImg := czpspPCircle
  else
    ClickImg := czpspPnone;
  if mbLeft = Button then
  case ClickImg of
    czpspPCircle :
    begin
      C_X := PosCar+RectPSP.Left+(RectPSP.Right-RectPSP.Left)div 2;
      C_Y := RectPSP.Top+(RectPSP.Bottom-RectPSP.Top)div 2;;
      Angle := Round(CalcAngle3Points(C_X, 0, C_X, C_Y, X, Y));
      if Angle = 360 then Angle := 0;
      Angle := 359 - Angle;
      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.H := Round(255 * (Angle / 359));
      if HSLPSP.H <> PSPColor.HSLPSP.H
      then
        begin
          DrawCursor;
          PSPColor.HSLPSP := HSLPSP;
          ChangeEdits;
          DrawPSPPalette;
        end;
    end;
    czpspPCar :
    begin
      C_X := X;
      C_Y := Y;
      if C_X<PosCar+RectPSP.Left
      then
        C_X:= PosCar+RectPSP.Left
      else
      if C_X>PosCar+RectPSP.Right
      then
        C_X:= PosCar+RectPSP.Right;

      if C_Y<RectPSP.Top
      then
        C_Y:= RectPSP.Top
      else
      if C_Y>RectPSP.Bottom
      then
        C_Y:= RectPSP.Bottom;

      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.S := Round(255 * ((C_X - (PosCar+RectPSP.Left)) / (RectPSP.Right-RectPSP.Left)));
      HSLPSP.L := Round(255 * ((C_Y - RectPSP.Top)/(RectPSP.Bottom - RectPSP.Top)));
      DrawCursor;
      PSPColor.HSLPSP := HSLPSP;
      ChangeEdits;
      DrawCursor;
      PalettePSP.Repaint;
    end;
  end;
   
end;

procedure TspSkinColorDialog.PalettePSPMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  HSLPSP : THSLPSP;
  C_X,C_Y : Integer;
  Angle : Integer;
begin
  if ssLeft in Shift then
  case ClickImg of
    czpspPCircle:
    begin
      C_X := PosCar + RectPSP.Left + (RectPSP.Right - RectPSP.Left)div 2;
      C_Y := RectPSP.Top + (RectPSP.Bottom - RectPSP.Top) div 2;
      Angle := Round(CalcAngle3Points(C_X, 0, C_X, C_Y, X, Y));
      if Angle = 360 then Angle := 0;
      Angle := 359 - Angle;
      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.H := Round(255*(Angle/359));
      if HSLPSP.H <> PSPColor.HSLPSP.H
      then
        begin
          DrawCursor;
          PSPColor.HSLPSP := HSLPSP;
          ChangeEdits;
          DrawPSPPalette;
        end;
    end;
    czpspPCar :
    begin
      C_X := X;
      C_Y := Y;
      if C_X < PosCar+RectPSP.Left
      then
        C_X := PosCar+RectPSP.Left
      else
      if C_X > PosCar+RectPSP.Right
      then
        C_X := PosCar+RectPSP.Right;

      if C_Y < RectPSP.Top
      then
        C_Y := RectPSP.Top
      else
      if C_Y > RectPSP.Bottom
      then
        C_Y := RectPSP.Bottom;

      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.S := Round(255 * ((C_X-(PosCar+RectPSP.Left)) / (RectPSP.Right-RectPSP.Left)));
      HSLPSP.L := Round(255 * ((C_Y-RectPSP.Top) / (RectPSP.Bottom-RectPSP.Top)));
      DrawCursor;
      PSPColor.HSLPSP := HSLPSP;
      ChangeEdits;
      DrawCursor;
      PalettePSP.Repaint;
    end;
  end;
end;

procedure TspSkinColorDialog.PalettePSPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  HSLPSP : THSLPSP;
  C_X,C_Y : Integer;
  Angle : Integer;
begin
  if mbLeft=Button then
  case ClickImg of
    czpspPCircle :
    begin
      C_X := PosCar+RectPSP.Left+(RectPSP.Right-RectPSP.Left)div 2;
      C_Y := RectPSP.Top+(RectPSP.Bottom-RectPSP.Top)div 2;;
      Angle := Round(CalcAngle3Points(C_X, 0, C_X, C_Y, X,Y));
      if Angle = 360 then Angle := 0;
      Angle := 359 - Angle;
      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.H := Round(255 * (Angle / 359));
      if HSLPSP.H <> PSPColor.HSLPSP.H
      then
        begin
          DrawCursor;
          PSPColor.HSLPSP := HSLPSP;
          ChangeEdits;
          DrawPSPPalette;
        end;
    end;

    czpspPCar :
    begin
      C_X := X;
      C_Y := Y;
      if C_X<PosCar+RectPSP.Left
      then
        C_X:= PosCar+RectPSP.Left
      else
      if C_X>PosCar+RectPSP.Right
      then
        C_X:= PosCar+RectPSP.Right;

      if C_Y<RectPSP.Top
      then
        C_Y:= RectPSP.Top
      else
      if C_Y>RectPSP.Bottom
      then
        C_Y:= RectPSP.Bottom;

      HSLPSP := PSPColor.HSLPSP;
      HSLPSP.S := Round(255 * ((C_X - (PosCar + RectPSP.Left)) / (RectPSP.Right - RectPSP.Left)));
      HSLPSP.L := Round(255 * ((C_Y - RectPSP.Top) / (RectPSP.Bottom-RectPSP.Top)));
      DrawCursor;
      PSPColor.HSLPSP := HSLPSP;
      ChangeEdits;
      DrawCursor;
      PalettePSP.Repaint;
    end;
  end;
  ClickImg := czpspPnone;
end;

constructor TspSkinCustomColorGrid.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited;
  ControlStyle := ControlStyle - [csAcceptsControls];
  CaptionMode := True;
  Caption := SP_CUSTOMCOLORGRID_CAP;
  BorderStyle := bvFrame;
  Width := 280;
  Height := 115;
  FColorValue := 0;
  FColCount := 6;
  FRowCount := 2;
  for i := 1 to 12 do CustomColorValues[I] := clWhite;
  FColorsCount := 0;
  FColorIndex := 0;
end;

destructor TspSkinCustomColorGrid.Destroy;
begin
  inherited;
end;

procedure TspSkinCustomColorGrid.AddColor(AColor: TColor);
begin
  if FColorsCount = 12 then FColorsCount := 0;
  Inc(FColorsCount);
  CustomColorValues[FColorsCount] := AColor;
  RePaint;
end;

procedure TspSkinCustomColorGrid.SetColCount(Value: Integer);
begin
  if Value < 1 then Exit;
  FColCount := Value;
  RePaint;
end;

procedure TspSkinCustomColorGrid.SetRowCount(Value: Integer);
begin
  FRowCount := Value;
  RePaint;
end;

procedure TspSkinCustomColorGrid.DrawCursor;
var
  CX, CY, Rd: Integer;
begin
  CX := R.Left + RectWidth(R) div 2;
  CY := R.Top + RectHeight(R) div 2;
  if RectWidth(R) > RectHeight(R)
  then
    Rd := RectHeight(R) div 2 - 2
  else
    Rd := RectWidth(R) div 2 - 2;
  with Cnvs do
  begin
    if pmNotMode then Pen.Mode := pmNot else Pen.Color := 0;
    MoveTo(CX - rd, CY); LineTo(CX - 2, CY);
    MoveTo(CX + 3, CY); LineTo(CX + rd + 1, CY);
    MoveTo(CX, CY - rd); LineTo(CX, CY - 2);
    MoveTo(CX, CY + 3); LineTo(CX, CY + rd);
  end;
end;

procedure TspSkinCustomColorGrid.PaintGrid(Cnvs: TCanvas);
var
  X, Y, CW, CH, i, j, k: Integer;
  R, Rct: TRect;
begin
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  CW := (RectWidth(R) - ColCount * 2) div ColCount;
  CH := (RectHeight(R) - RowCount * 2) div RowCount;
  Y := R.Top + 1;
  k := 0;
  for i := 1 to RowCount do
  begin
    X := R.Left + 1;
    for j := 1 to ColCount do
    begin
      Inc(k);
      with Cnvs do
      begin
        Brush.Color := CustomColorValues[k];
        Rct := Rect(X, Y, X + CW, Y + CH);
        InflateRect(Rct, -1, -1);
        FillRect(Rct);
        InflateRect(Rct, 1, 1);
        if k = FColorIndex  
        then
          begin
            if CustomColorValues[k] <> clGray
            then
              DrawCursor(Cnvs, Rct, True)
            else
              DrawCursor(Cnvs, Rct, False);
          end
      end;
      Inc(X, CW + 2);
    end;
    Inc(Y, CH + 2);
  end;
end;

procedure TspSkinCustomColorGrid.CreateControlDefaultImage;
begin
  inherited;
  PaintGrid(B.Canvas);
end;

procedure TspSkinCustomColorGrid.CreateControlSkinImage;
begin
  inherited;
  PaintGrid(B.Canvas);
end;

procedure TspSkinCustomColorGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                     X, Y: Integer);
var
  X1, Y1, CW, CH, i, j, k: Integer;
  R, Rct: TRect;
begin
  inherited;
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  CW := (RectWidth(R) - ColCount * 2) div ColCount;
  CH := (RectHeight(R) - RowCount * 2) div RowCount;
  Y1 := R.Top + 1;
  k := 0;
  for i := 1 to RowCount do
  begin
    X1 := R.Left + 1;
    for j := 1 to ColCount do
    begin
      Inc(k);
      Rct := Rect(X1, Y1, X1 + CW, Y1 + CH);
      if PtInRect(Rct, Point(X, Y))
      then
        begin
          FColorValue := CustomColorValues[k];
          FColorIndex := k;
          RePaint;
          if Assigned(FOnChange) then FOnChange(Self);
          Break;
        end;
      Inc(X1, CW + 2);
    end;
    Inc(Y1, CH + 2);
  end;  
end;



end.

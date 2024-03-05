unit TFlatGaugeUnit;

{***************************************************************}
{  TFlatGauge                                                   }
{  Copyright ©1999 Lloyd Kinsella.                              }
{                                                               }
{  FlatStyle is Copyright ©1998-99 Maik Porkert.                }
{***************************************************************}

interface

{$DEFINE D4CB4}

uses
  WinProcs, WinTypes, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, ExtCtrls, Consts, FlatUtilitys;

type
  TFlatGauge = class(TGraphicControl)
  private
    FUseAdvColors: Boolean;
    FAdvColorBorder: TAdvColors;
    FBarColor, FBorderColor: TColor;
    FMinValue, FMaxValue, FProgress: LongInt;
    FShowText: Boolean;
    procedure SetShowText(Value: Boolean);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetProgress(Value: Longint);
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged (var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
  protected
    procedure CalcAdvColors;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AdvColorBorder: TAdvColors index 0 read FAdvColorBorder write SetAdvColors default 50;
    property UseAdvColors: Boolean read FUseAdvColors write SetUseAdvColors default False;
    property Color default $00E0E9EF;
    property BorderColor: TColor index 0 read FBorderColor write SetColors default $00555E66;
    property BarColor: TColor index 1 read FBarColor write SetColors default $00996633;
    property MinValue: Longint read FMinValue write SetMinValue default 0;
    property MaxValue: Longint read FMaxValue write SetMaxValue default 100;
    property Progress: Longint read FProgress write SetProgress;
    property ShowText: Boolean read FShowText write SetShowText default True;
    property Align;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
   {$IFDEF D4CB4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
   {$ENDIF}
  end;

implementation

constructor TFlatGauge.Create(AOwner: TComponent);
begin
  inherited Create (AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  Width := 145;
  Height := 25;
  MinValue := 0;
  MaxValue := 100;
  Progress := 25;
  ShowText := True;
  BarColor := $00996633;
  BorderColor := $00555E66;
  Color := $00E0E9EF;
end;

procedure TFlatGauge.Paint;
var
  R, R2, RC: TRect;
  LeftBitmap, RightBitmap: TBitmap;
  PercentText: String;
  TextPosX: Integer;
  XProgress: Integer;
begin
  with Canvas do
  begin
    R := ClientRect;
    Brush.Color := Color;
    FillRect(R);
    Frame3D(Canvas, R, FBorderColor, FBorderColor, 1);
    InflateRect (R, -2, -2);
    LeftBitmap := TBitmap.Create;
    try
      LeftBitmap.Height := ClientHeight - 4;
      LeftBitmap.Width := ClientWidth - 4;
      RightBitmap := TBitmap.Create;
      try
        RightBitmap.Height := ClientHeight - 4;
        RightBitmap.Width := ClientWidth - 4;
        try
          PercentText := IntToStr(Trunc(((FProgress-FMinValue)/(FMaxValue-FMinValue)) * 100)) + ' %';
        except
          PercentText := 'error';
        end;
        TextPosX := (ClientWidth div 2) - (TextWidth(PercentText) div 2);
        with LeftBitmap.Canvas do
        begin
          Pen.Color := FBarColor;
          Brush.Color := FBarColor;
          Brush.Style := bsSolid;
          Rectangle (0, 0, LeftBitmap.Width, LeftBitmap.Height);
          if FShowText then
          begin
            Font.Assign (Self.Font);
            Font.Color := Color;
            TextOut (TextPosX, (LeftBitmap.Height div 2) - (TextHeight(PercentText) div 2), PercentText);
          end;
        end;
        with RightBitmap.Canvas do
        begin
          Pen.Color := Color;
          Brush.Color := Color;
          Brush.Style := bsSolid; 
          Rectangle (0, 0, RightBitmap.Width, RightBitmap.Height);
          if FShowText then
          begin
            Font.Assign (Self.Font);
            Font.Color := FBarColor;
            TextOut (TextPosX, (LeftBitmap.Height div 2) - (TextHeight(PercentText) div 2), PercentText);
          end;
        end;
        R2 := ClientRect; Dec (R2.Right, 4); Dec (R2.Bottom, 4);
        try
          XProgress := Trunc(((FProgress-FMinValue)/(FMaxValue-FMinValue)) * LeftBitmap.Width);
        except
          XProgress := 0;
        end;
        Dec (R2.Right, LeftBitmap.Width-XProgress);
        RC := R;  Dec (RC.Right, LeftBitmap.Width-XProgress);
        CopyRect (RC, LeftBitmap.Canvas, R2);
        R2 := ClientRect; Dec (R2.Right, 4); Dec (R2.Bottom, 4);
        Inc (R2.Left, XProgress);
        RC := R;  Inc (RC.Left, XProgress);
        CopyRect (RC, RightBitmap.Canvas, R2);
      finally
        RightBitmap.Free;
      end;
    finally
      LeftBitmap.Free;
    end;                    
  end;
end;

procedure TFlatGauge.SetShowText(Value: Boolean);
begin
  if FShowText <> Value then
  begin
    FShowText := Value;
    Repaint;
  end;
end;

procedure TFlatGauge.SetMinValue(Value: Longint);
begin
  if Value <> FMinValue then
  begin
    if Value > FMaxValue then
      FMinValue := FMaxValue
    else
      FMinValue := Value;
    if FProgress < Value then FProgress := Value;
      Repaint;
  end;
end;

procedure TFlatGauge.SetMaxValue(Value: Longint);
begin
  if Value <> FMaxValue then
  begin
    if Value < FMinValue then
      FMaxValue := FMinValue
    else
      FMaxValue := Value;
    if FProgress > Value then FProgress := Value;
      Repaint;
  end;
end;

procedure TFlatGauge.SetProgress(Value: Longint);
begin
  if Value < FMinValue then
    Value := FMinValue
  else
    if Value > FMaxValue then
      Value := FMaxValue;
  if FProgress <> Value then
  begin
    FProgress := Value;
    Repaint;
  end;
end;

procedure TFlatGauge.SetColors (Index: Integer; Value: TColor);
begin
  case Index of
    0: FBorderColor := Value;
    1: FBarColor := Value;
  end;
  Invalidate;
end;

procedure TFlatGauge.CalcAdvColors;
begin
  if FUseAdvColors then
  begin
    FBorderColor := CalcAdvancedColor(Color, FBorderColor, FAdvColorBorder, darken);
  end;
end;

procedure TFlatGauge.SetAdvColors (Index: Integer; Value: TAdvColors);
begin
  case Index of
    0: FAdvColorBorder := Value;
  end;
  CalcAdvColors;
  Invalidate;
end;

procedure TFlatGauge.SetUseAdvColors (Value: Boolean);
begin
  if Value <> FUseAdvColors then
  begin
    FUseAdvColors := Value;
    ParentColor := Value;
    CalcAdvColors;
    Invalidate;
  end;
end;

procedure TFlatGauge.CMSysColorChange (var Message: TMessage);
begin
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

procedure TFlatGauge.CMParentColorChanged (var Message: TWMNoParams);
begin
  inherited;
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

end.

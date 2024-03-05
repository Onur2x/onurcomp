
{*******************************************************************}
{                                                                   }
{       SkinEngine                                                  }
{       Version 1                                                   }
{                                                                   }
{       Copyright (c) 1998-2003 Evgeny Kryukov                      }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT KS DEVELOPMENT WRITTEN   }
{   CONSENT AND PERMISSION FROM KS DEVELOPMENT.                     }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{   DISTRIBUTION OF THIS FILE IS NOT ALLOWED!                       }
{                                                                   }
{       Home:  http://www.ksdev.com                                 }
{       Support: support@ksdev.com                                  }
{       Questions: faq@ksdev.com                                    }
{                                                                   }
{*******************************************************************}
{
 $Id: SkinProgBar.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinProgBar;

{$I KSSKIN.INC}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
     Forms, StdCtrls, KSHook, SkinConst, SkinSource, SkinTypes,
     SkinObjects, SkinEngine;

type

{ TscProgressBar }

  TscProgressBarOrientation = (pbHorizontal, pbVertical);

  TscProgressBar = class(TCustomControl)
  private
    FShowText: Boolean;
    FBorderStyle: TBorderStyle;
    FMin: Longint;
    FMax: Longint;
    FOrientation: TscProgressBarOrientation;
    FSkinEngine: TscSkinEngine;
    FPosition: Integer;

    FSkinProgressBar: TscSkinObject;
    procedure PaintBackground(AnImage: TBitmap);
    procedure PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsText(AnImage: TBitmap; PaintRect: TRect);
    function GetPercentDone: Longint;
    procedure SetShowText(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetOrientation(const Value: TscProgressBarOrientation);
    procedure SetMin(const Value: Longint);
    procedure SetMax(const Value: Longint);
    procedure SetPosition(Value: Longint);
    procedure SetSkinEngine(const Value: TscSkinEngine);
    procedure WMSkinChange(var Msg: TMessage); message WM_SKINCHANGE;
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure AddProgress(Value: Longint);
    property PercentDone: Longint read GetPercentDone;
  published
    property Align;
    property Anchors;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property Min: Longint read FMin write SetMin default 0;
    property Max: Longint read FMax write SetMax default 100;
    property Orientation: TscProgressBarOrientation read FOrientation
      write SetOrientation default pbHorizontal;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position: Integer read FPosition write SetPosition default 0;
    property ShowHint;
    property ShowText: Boolean read FShowText write SetShowText default False;
    property SkinEngine: TscSkinEngine read FSkinEngine write SetSkinEngine;
    property Visible;
  end;

implementation {===============================================================}

uses Consts, ComStrs, CommCtrl, ComCtrls;

type
  TBltBitmap = class(TBitmap)
    procedure MakeLike(ATemplate: TBitmap);
  end;

{ TscProgressBar }

{ TBltBitmap }

procedure TBltBitmap.MakeLike(ATemplate: TBitmap);
begin
  Width := ATemplate.Width;
  Height := ATemplate.Height;
  Canvas.Brush.Color := clWindowFrame;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: Longint): Longint;
begin
  Result := Longint(Trunc( Z * (Y * 0.01) ));
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: Longint): Longint;
begin
  if Z = 0 then Result := 0
  else Result := Longint(Trunc( (X * 100.0) / Z ));
end;

{ TscProgressBar }

constructor TscProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  { default values }
  FMin := 0;
  FMax := 100;
  FPosition := 0;
  FShowText := false;
  FOrientation := pbHorizontal;
  FBorderStyle := bsNone;
  Width := 150;
  Height := 16;

  if (csDesigning in ComponentState) and (Owner is TForm) then
    FSkinEngine := GetSkinEngine(AOwner);

  FSkinProgressBar := TscSkinObject.Create;
end;

procedure TscProgressBar.Loaded;
begin
  inherited;
end;

destructor TscProgressBar.Destroy;
begin
  FSkinProgressBar.Free;
  inherited;
end;

function TscProgressBar.GetPercentDone: Longint;
begin
  Result := SolveForY(FPosition - FMin, FMax - FMin);
end;

procedure TscProgressBar.Paint;
var
  TheImage: TBitmap;
  OverlayImage: TBltBitmap;
  PaintRect: TRect;
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.ProgressBar <> nil) and
     not (csDesigning in ComponentState)
  then
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      PaintBackground(TheImage);
      PaintRect := ClientRect;
      if FBorderStyle = bsSingle then
        InflateRect(PaintRect, -1, -1);

      PaintAsBar(TheImage, PaintRect);
      if ShowText then
        PaintAsText(TheImage, PaintRect);
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;
  end
  else
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      PaintBackground(TheImage);
      PaintRect := ClientRect;
      if FBorderStyle = bsSingle then InflateRect(PaintRect, -1, -1);
      OverlayImage := TBltBitmap.Create;
      try
        OverlayImage.MakeLike(TheImage);
        PaintBackground(OverlayImage);
        PaintAsBar(OverlayImage, PaintRect);
        TheImage.Canvas.CopyMode := cmSrcInvert;
        TheImage.Canvas.Draw(0, 0, OverlayImage);
        TheImage.Canvas.CopyMode := cmSrcCopy;
        if ShowText then PaintAsText(TheImage, PaintRect);
      finally
        OverlayImage.Free;
      end;
      Canvas.CopyMode := cmSrcCopy;
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;
  end;
end;

procedure TscProgressBar.PaintBackground(AnImage: TBitmap);
var
  ARect: TRect;
  SkinObject: TscSkinObject;
begin
  with AnImage.Canvas do
  begin
    if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
       (FSkinEngine.SkinSource.ProgressBar <> nil) and
       not (csDesigning in ComponentState) then
    begin
      { Fore make none align }
      SkinObject := FSkinProgressBar.FindObjectByKind(skProgressBarFore);
      if SkinObject <> nil then
        SkinObject.Align := saNone;
      { Draw back }
      SkinObject := FSkinProgressBar.FindObjectByKind(skProgressBarBack);
      if SkinObject <> nil then
      begin
        SkinObject.Align := saClient;
        FSkinProgressBar.BoundsRect := Rect(0, 0, Width, Height);
        SkinObject.Draw(AnImage.Canvas);
        SkinObject.Align := saNone;
      end;
    end
    else
    begin
      CopyMode := cmBlackness;
      ARect := Rect(0, 0, Width, Height);
      CopyRect(ARect, Animage.Canvas, ARect);
      CopyMode := cmSrcCopy;
    end;
  end;
end;

procedure TscProgressBar.PaintAsText(AnImage: TBitmap; PaintRect: TRect);
var
  S: string;
  X, Y: Integer;
  OverRect: TBltBitmap;
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.ProgressBar <> nil) and
     not (csDesigning in ComponentState)
  then
  with AnImage.Canvas do
  begin
    S := Format('%d%%', [PercentDone]);
    Brush.Style := bsClear;
    Font := Self.Font;
    Font.Color := clWhite;
    with PaintRect do
    begin
      X := (Right - Left + 1 - TextWidth(S)) div 2;
      Y := (Bottom - Top + 1 - TextHeight(S)) div 2;
    end;
    TextRect(PaintRect, X, Y, S);
  end
  else
  begin
    OverRect := TBltBitmap.Create;
    try
      OverRect.MakeLike(AnImage);
      PaintBackground(OverRect);
      S := Format('%d%%', [PercentDone]);
      with OverRect.Canvas do
      begin
        Brush.Style := bsClear;
        Font := Self.Font;
        Font.Color := clWhite;
        with PaintRect do
        begin
          X := (Right - Left + 1 - TextWidth(S)) div 2;
          Y := (Bottom - Top + 1 - TextHeight(S)) div 2;
        end;
        TextRect(PaintRect, X, Y, S);
      end;
      AnImage.Canvas.CopyMode := cmSrcInvert;
      AnImage.Canvas.Draw(0, 0, OverRect);
      AnImage.Canvas.CopyMode := cmSrcCopy;
    finally
      OverRect.Free;
    end;
  end;
end;

procedure TscProgressBar.PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
var
  FillSize: Longint;
  W, H: Integer;
  SkinObject: TscSkinObject;
begin
  W := PaintRect.Right - PaintRect.Left + 1;
  H := PaintRect.Bottom - PaintRect.Top + 1;
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.ProgressBar <> nil) and
     not (csDesigning in ComponentState)
  then
  with AnImage.Canvas do
  begin
    case FOrientation of
      pbHorizontal:
        begin
          FillSize := SolveForX(PercentDone, W);
          if FillSize >= W then FillSize := W - 1;
          FSkinProgressBar.BoundsRect := Rect(0, 0, Width, Height);
          SkinObject := FSkinProgressBar.FindObjectByKind(skProgressBarFore);
          if SkinObject <> nil then
          begin
            SkinObject.Align := saLeft;
            SkinObject.Width := FillSize;
            FSkinProgressBar.BoundsRect := Rect(0, 0, Width, Height);
            FSkinProgressBar.Draw(AnImage.Canvas);
            SkinObject.Align := saNone;
          end;
        end;
      pbVertical:
        begin
          FillSize := SolveForX(PercentDone, H);
          if FillSize >= H then FillSize := H - 1;
          SkinObject := FSkinProgressBar.FindObjectByKind(skProgressBarFore);
          if SkinObject <> nil then
          begin
            SkinObject.Align := saBottom;
            SkinObject.Height := FillSize;
            FSkinProgressBar.BoundsRect := Rect(0, 0, Width, Height);
            SkinObject.Draw(AnImage.Canvas);
            SkinObject.Align := saNone;
          end;
        end;
    end;
  end
  else
  with AnImage.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(PaintRect);
    Pen.Style := psClear;
    Brush.Color := clHighlight;
    case FOrientation of
      pbHorizontal:
        begin
          FillSize := SolveForX(PercentDone, W);
          if FillSize > W then FillSize := W;
          if FillSize > 0 then FillRect(Rect(PaintRect.Left, PaintRect.Top,
            FillSize, H));
        end;
      pbVertical:
        begin
          FillSize := SolveForX(PercentDone, H);
          if FillSize >= H then FillSize := H - 1;
          FillRect(Rect(PaintRect.Left, H - FillSize, W, H));
        end;
    end;
  end;
end;

procedure TscProgressBar.SetShowText(Value: Boolean);
begin
  if Value <> FShowText then
  begin
    FShowText := Value;
    Refresh;
  end;
end;

procedure TscProgressBar.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    Refresh;
  end;
end;

procedure TscProgressBar.SetPosition(Value: Longint);
var
  TempPercent: Longint;
begin
  TempPercent := GetPercentDone;  { remember where we were }
  if Value < FMin then
    Value := FMin
  else if Value > FMax then
    Value := FMax;
  if FPosition <> Value then
  begin
    FPosition := Value;
    if TempPercent <> GetPercentDone then { only refresh if percentage changed }
      Invalidate;
  end;
end;

procedure TscProgressBar.AddProgress(Value: Longint);
begin
  Position := FPosition + Value;
  Invalidate;
end;

procedure TscProgressBar.SetMax(const Value: Longint);
begin
  if Value <> FMax then
  begin
    if Value < FMin then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [FMin + 1, MaxInt]);
    FMax := Value;
    if FPosition > Value then FPosition := Value;
    Invalidate;
  end;
end;

procedure TscProgressBar.SetMin(const Value: Longint);
begin
  if Value <> FMin then
  begin
    if Value > FMax then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [-MaxInt, FMax - 1]);
    FMin := Value;
    if FPosition < Value then FPosition := Value;
    Invalidate;
  end;
end;

procedure TscProgressBar.SetOrientation(const Value: TscProgressBarOrientation);
begin
  FOrientation := Value;
  Invalidate;
end;

procedure TscProgressBar.SetSkinEngine(const Value: TscSkinEngine);
begin
  FSkinEngine := Value;
  if FSkinEngine <> nil then
    SendMessage(Handle, WM_SKINCHANGE, 0, 0); 
end;

procedure TscProgressBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FSkinEngine) then
    FSkinEngine := nil;
end;

procedure TscProgressBar.WMSkinChange(var Msg: TMessage);
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.ProgressBar <> nil)
  then
    FSkinProgressBar.Assign(FSkinEngine.SkinSource.ProgressBar)
  else
  begin
    FSkinProgressBar.Free;
    FSkinProgressBar := TscSkinObject.Create;
  end;
  Invalidate;
end;

end.

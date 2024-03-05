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

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

unit SkinHint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SkinData, ExtCtrls;

type

  TspSkinHint = class;

  TspSkinHintWindow = class(THintWindow)
  private
    NewClRect: TRect;
    NewLTPoint, NewRTPoint,
    NewLBPoint, NewRBPoint: TPoint;
    FspHint: TspSkinHint;
    DrawBuffer: TBitMap;
    FSD:  TspSkinData;
    SI: TBitMap;
    FRgn: HRGN;
    OldAlphaBlend: Boolean;
    OldAlphaBlendValue: Integer;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkgnd); message WM_EraseBkgnd;
    function FindHintComponent: TspSkinHint;
    procedure CalcHintSize(Cnvs: TCanvas; S: String; var W, H: Integer);
  protected
    procedure SetHintWindowRegion;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  end;

  TspSkinHint = class(TComponent)
  private
    FOnShowHint: TShowHintEvent;
    FActive: Boolean;
    FSD: TspSkinData;
    HW: TspSkinHintWindow;
    FAlphaBlendSupport: Boolean;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    HintTimer: TTimer;
    HintText: String;
    procedure SetDefaultFont(Value: TFont);
    procedure SetActive(Value: Boolean);
    procedure SetAlphaBlendSupport(Value: Boolean);
    procedure HintTime1(Sender: TObject);
    procedure HintTime2(Sender: TObject);
  protected
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetSkinData(Value: TspSkinData);
    procedure SelfOnShowHint(var HintStr: string;
                             var CanShow: Boolean; var HintInfo: THintInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCursorHeightMargin: Integer;
    procedure ActivateHint(P: TPoint; const AHint: string);
    procedure ActivateHint2(const AHint: string);
    procedure HideHint;
    function IsVisible: Boolean; 
  published
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property AlphaBlendSupport: Boolean read FAlphaBlendSupport
                                        write SetAlphaBlendSupport;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte
      read FAlphaBlendValue write FAlphaBlendValue;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property Active: Boolean read FActive write SetActive;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
  end;

implementation

 Uses spUtils, spEffBmp;

const
  CS_DROPSHADOW_ = $20000;

constructor TspSkinHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SI := TBitMap.Create;
  FRgn := 0;
  OldAlphaBlend := False;
  OldAlphaBlendValue := 0;
end;

destructor TspSkinHintWindow.Destroy;
begin
  SI.Free;
  inherited Destroy;
  if FRgn <> 0 then DeleteObject(FRgn);
end;

procedure TspSkinHintWindow.WMNCPaint(var Message: TMessage);
begin
end;

procedure TspSkinHintWindow.SetHintWindowRegion;
var
  TempRgn: HRgn;
  MaskPicture: TBitMap;
begin
  if (FSD <> nil) and (FSD.HintWindow.MaskPictureIndex <> -1)
  then
    begin
      TempRgn := FRgn;
      with FSD.HintWindow do
      begin
        MaskPicture := TBitMap(FSD.FActivePictures[MaskPictureIndex]);
        CreateSkinRegion
          (FRgn, LTPoint, RTPoint, LBPoint, RBPoint, ClRect,
           NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewClRect,
           MaskPicture, Width, Height);
      end;
      SetWindowRgn(Handle, FRgn, False);
      if TempRgn <> 0 then DeleteObject(TempRgn);
    end
  else
    if FRgn <> 0 then
    begin
      SetWindowRgn(Handle, 0, False);
      DeleteObject(FRgn);
      FRgn := 0;
    end;
end;

procedure TspSkinHintWindow.CalcHintSize(Cnvs: TCanvas; S: String; var W, H: Integer);
var
  R: TRect;
  PW, PH, OX, OY: Integer;
begin
  R := Rect(0, 0, 0, 0);
  DrawText(Cnvs.Handle, PChar(S), -1, R, DT_CALCRECT or DT_LEFT);
  W := RectWidth(R);
  H := RectHeight(R);
  if FSD <> nil
  then
    begin
      with FSD.HintWindow do
      begin
        PW := TBitMap(FSD.FActivePictures[WindowPictureIndex]).Width;
        PH := TBitMap(FSD.FActivePictures[WindowPictureIndex]).Height;
        W := W + ClRect.Left + (PW - ClRect.Right);
        H := H + ClRect.Top + (PH - ClRect.Bottom);
        if W < PW then W := PW;
        if H < PH then H := PH;
        OX := W - PW;
        OY := H - PH;
        NewClRect := ClRect;
        Inc(NewClRect.Right, OX);
        Inc(NewClRect.Bottom, OY);
        NewLTPoint := LTPoint;
        NewRTPoint := Point(RTPoint.X + OX, RTPoint.Y);
        NewLBPoint := Point(LBPoint.X, LBPoint.Y + OY);
        NewRBPoint := Point(RBPoint.X + OX, RBPoint.Y + OY);
      end;
    end
  else
    begin
      Inc(W, 4);
      Inc(H, 4);
    end;
end;

function TspSkinHintWindow.FindHintComponent;
var
  i: Integer;
begin
  Result := nil;
  if (Application.MainForm <> nil) and
     (Application.MainForm.ComponentCount > 0)
  then
    with Application.MainForm do
      for i := 0 to ComponentCount - 1 do
       if (Components[i] is TspSkinHint) and
          (TspSkinHint(Components[i]).Active)
       then
         begin
           Result := TspSkinHint(Components[i]);
           Break;
         end;
end;

procedure TspSkinHintWindow.ActivateHint(Rect: TRect; const AHint: string);
const
  WS_EX_LAYERED = $80000;
var
  HintWidth, HintHeight: Integer;
  CanSkin: Boolean;
begin
  FspHint := FindHintComponent;
  if FspHint = nil then Exit;
  if not FspHint.Active then Exit;

  CanSkin := (FspHint.FSD <> nil) and (not FspHInt.FSD.Empty) and
             (FspHint.FSD.HintWindow.WindowPictureIndex <> -1);
  //
  if CanSkin then FSD := FspHint.FSD else FSD := nil; 

  if FSD <> nil
  then
    begin
      with Canvas, FSD.HintWindow do
      begin
        if FspHint.UseSkinFont
        then
          begin
            Font.Height := FontHeight;
            Font.Name := FontName;
            Font.Style := FontStyle;
          end
        else
          Font.Assign(FspHint.FDefaultFont);
      end;
    end
  else
    with Canvas do
    begin
      Font.Assign(FspHint.FDefaultFont);
    end;

  if (FspHint.SkinData <> nil) and (FspHint.SkinData.ResourceStrData <> nil)
  then
    Canvas.Font.CharSet := FspHint.SkinData.ResourceStrData.CharSet
  else
    Canvas.Font.CharSet := FspHint.DefaultFont.CharSet;

  Caption := AHint;
  CalcHintSize(Canvas, Caption, HintWidth, HintHeight);
  Rect.Right := Rect.Left + HintWidth;
  Rect.Bottom := Rect.Top + HIntHeight;
  //
  if (Rect.Right > Screen.Width) then OffsetRect(Rect, -HintWidth-2, 0);
  if (Rect.Bottom > Screen.Height) then OffsetRect(Rect, 0, -HintHeight-2);
  //
  BoundsRect := Rect;
  if (OldAlphaBlend <> FspHint.AlphaBlend) and FSpHint.AlphaBlendSupport
  then
    begin
      if OldAlphaBlend
      then
       SetWindowLong(Handle, GWL_EXSTYLE,
            GetWindowLong(Handle, GWL_EXSTYLE) and (not WS_EX_LAYERED))
      else
        begin
          SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE)
                        or WS_EX_LAYERED);
          SetAlphaBlendTransparent(Handle, FspHint.AlphaBlendValue);
        end;
      OldAlphaBlend := FspHint.AlphaBlend;
    end;
  if (OldAlphaBlendValue <> FspHint.AlphaBlendValue) and FSpHint.AlphaBlendSupport and
     FspHint.AlphaBlend
  then
    begin
      SetAlphaBlendTransparent(Handle, FspHint.AlphaBlendValue);
      OldAlphaBlendValue := FspHint.AlphaBlendValue;
    end;
  //
  if FspHint.AlphaBlend and not FspHint.AlphaBlendSupport
  then
    begin
      SI.Width := Width;
      SI.Height := Height;
      GetScreenImage(Rect.Left, Rect.Top, SI);
    end;
  //
  SetHintWindowRegion;
  //
  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, 0,
    0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
  Visible := True;
end;

procedure TspSkinHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;
  if CheckWXP
  then
    Params.WindowClass.Style := Params.WindowClass.style or CS_DROPSHADOW_;
end;

procedure TspSkinHintWindow.Paint;
var
  R: TRect;
  kf: Double;
  EB1, EB2: TspEffectBmp;
  B: TBitMap;
  W, H, X, Y: Integer;
begin
  //
  if (Width <= 0) or (Height <= 0) then Exit;
  DrawBuffer := TBitMap.Create;
  DrawBuffer.Width := Width;
  DrawBuffer.Height := Height;
  //
  if FSD <> nil
  then
    with DrawBuffer.Canvas, FSD.HintWindow do
    begin
      B := TBitMap(FSD.FActivePictures[WindowPictureIndex]);
      CreateSkinImageBS(LTPoint, RTPoint, LBPoint, RBPoint,
      CLRect, NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint,
      NewClRect, DrawBuffer, B,
      Rect(0, 0, B.Width, B.Height), Width, Height, True,
      FSD.HintWindow.LeftStretch, FSD.HintWindow.TopStretch,
      FSD.HintWindow.RightStretch, FSD.HintWindow.BottomStretch);
    end
  else
    with DrawBuffer.Canvas do
    begin
      Brush.Color := clInfoBk;
      FillRect(ClientRect);
      R := ClientRect;
      Frame3D(DrawBuffer.Canvas, R, clBtnShadow, clBtnShadow, 1);
    end;
  //
  if FSD <> nil
  then
    with DrawBuffer.Canvas, FSD.HintWindow do
    begin
      Brush.Style := bsClear;
      if FspHint.UseSkinFont
      then
        begin
          Font.Height := FontHeight;
          Font.Style := FontStyle;
          Font.Name := FontName;
        end
      else
        Font.Assign(FspHint.FDefaultFont);

      if (FspHint.SkinData <> nil) and (FspHint.SkinData.ResourceStrData <> nil)
      then
        Font.CharSet := FspHint.SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := FspHint.DefaultFont.CharSet;

      Font.Color := FontColor;
      R := Rect(0, 0, 0, 0);
      DrawText(Handle, PChar(Caption), -1, R, DT_CALCRECT or DT_LEFT);
      W := RectWidth(R);
      H := RectHeight(R);
      X := NewClRect.Left + RectWidth(NewClRect) div 2 - W div 2;
      Y := NewClRect.Top + RectHeight(NewClRect) div 2 - H div 2;
      R := Rect(X, Y, X + W, Y + H);
      DrawText(Handle, PChar(Caption), -1, R, DT_LEFT);
    end
  else
    with DrawBuffer.Canvas do
    begin
      Font.Assign(FspHint.FDefaultFont);
      if (FspHint.SkinData <> nil) and (FspHint.SkinData.ResourceStrData <> nil)
      then
        Font.CharSet := FspHint.SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := FspHint.DefaultFont.CharSet;

      Font.Color := clInfoText;
      Brush.Style := bsClear;
      R := Rect(2, 2, Width - 2, Height - 2);
      DrawText(Handle, PChar(Caption), -1, R, DT_LEFT);
    end;
  //
  if FspHint.AlphaBlend and not FspHint.AlphaBlendSupport
  then
    begin
      EB1 := TspEffectBmp.CreateFromhWnd(DrawBuffer.Handle);
      SI.Width := DrawBuffer.Width;
      EB2 := TspEffectBmp.CreateFromhWnd(SI.Handle);
      kf := 1 - FspHint.AlphaBlendValue / 255;
      EB1.Morph(EB2, kf);
      EB1.Draw(DrawBuffer.Canvas.Handle, 0, 0);
      EB1.Free;
      EB2.Free;
    end;
  //
  Canvas.Draw(0, 0, DrawBuffer);
  DrawBuffer.Free;
end;

procedure TspSkinHintWindow.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1;
end;

constructor TspSkinHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HintTimer := nil;
  FDefaultFont := TFont.Create;
  FUseSkinFont := True;
  FAlphaBlend := False;
  FAlphaBlendValue := 200;
  FAlphaBlendSupport := True;
  FSD := nil;
  FActive := True;
  HW := TspSkinHintWindow.Create(Self);
  HW.Visible := False;
  if not (csDesigning in ComponentState)
  then
    begin
      HintWindowClass := TspSkinHintWindow;
      with Application do begin
        ShowHint := not ShowHint;
        ShowHint := not ShowHint;
        OnShowHint := SelfOnShowHint;
        Application.HintShortPause := 100;
      end;
    end;
end;

destructor TspSkinHint.Destroy;
begin
  HW.Free;
  FDefaultFont.Free;
  if HintTimer <> nil then HintTimer.Free;
  inherited Destroy;
end;

function TspSkinHint.IsVisible: Boolean;
begin
  Result := (HW <> nil) and HW.Visible;
end;

function TspSkinHint.GetCursorHeightMargin: Integer;
  var
    IconInfo: TIconInfo;
    BitmapInfoSize, BitmapBitsSize, ImageSize: DWORD;
    Bitmap: PBitmapInfoHeader;
    Bits: Pointer;
    BytesPerScanline: Integer;

      function FindScanline(Source: Pointer; MaxLen: Cardinal;
        Value: Cardinal): Cardinal; assembler;
      asm
              PUSH    ECX
              MOV     ECX,EDX
              MOV     EDX,EDI
              MOV     EDI,EAX
              POP     EAX
              REPE    SCASB
              MOV     EAX,ECX
              MOV     EDI,EDX
      end;

  begin
    { Default value is entire icon height }
    Result := GetSystemMetrics(SM_CYCURSOR);
    if GetIconInfo(GetCursor, IconInfo) then
    try
      GetDIBSizes(IconInfo.hbmMask, BitmapInfoSize, BitmapBitsSize);
      Bitmap := AllocMem(DWORD(BitmapInfoSize) + BitmapBitsSize);
      try
      Bits := Pointer(DWORD(Bitmap) + BitmapInfoSize);
      if GetDIB(IconInfo.hbmMask, 0, Bitmap^, Bits^) and
        (Bitmap^.biBitCount = 1) then
      begin
        { Point Bits to the end of this bottom-up bitmap }
        with Bitmap^ do
        begin
          BytesPerScanline := ((biWidth * biBitCount + 31) and not 31) div 8;
          ImageSize := biWidth * BytesPerScanline;
          Bits := Pointer(DWORD(Bits) + BitmapBitsSize - ImageSize);
          { Use the width to determine the height since another mask bitmap
            may immediately follow }
          Result := FindScanline(Bits, ImageSize, $FF);
          { In case the and mask is blank, look for an empty scanline in the
            xor mask. }
          if (Result = 0) and (biHeight >= 2 * biWidth) then
            Result := FindScanline(Pointer(DWORD(Bits) - ImageSize),
            ImageSize, $00);
          Result := Result div BytesPerScanline;
        end;
        Dec(Result, IconInfo.yHotSpot);
      end;
      finally
        FreeMem(Bitmap, BitmapInfoSize + BitmapBitsSize);
      end;
    finally
      if IconInfo.hbmColor <> 0 then DeleteObject(IconInfo.hbmColor);
      if IconInfo.hbmMask <> 0 then DeleteObject(IconInfo.hbmMask);
    end;
end;

procedure TspSkinHint.SetDefaultFont(Value: TFont);
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinHint.SetAlphaBlendSupport(Value: Boolean);
begin
  if Value
  then
    begin
      if not CheckW2KWXP and not (csDesigning in ComponentState)
      then
        Value := False;
    end;
  FAlphaBlendSupport := Value;
end;

procedure TspSkinHint.SetSkinData;
begin
  FSD := Value;
end;

procedure TspSkinHint.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinHint.SetActive(Value: Boolean);
var
  i: Integer;
begin
  FActive := Value;
  if FActive and (Application.MainForm <> nil)
  then
    with Application.MainForm do
      for i := 0 to ComponentCount-1 do
        if (Components[i] is TspSkinHint) and (Components[i] <> Self)
        then
          if TspSkinHint(Components[i]).Active
          then TspSkinHint(Components[i]).Active := False;

  if not (csDesigning in ComponentState) and FActive
  then Application.OnShowHint := SelfOnShowHint;
end;

procedure TspSkinHint.SelfOnShowHint(var HintStr: string;
                                 var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(FOnShowHint) then FOnShowHint(HintStr, CanShow, HintInfo);
end;

procedure TspSkinHint.HintTime1(Sender: TObject);
var
  R: TRect;
  P: TPoint;
begin
  if HintTimer = nil then Exit;
  GetCursorPos(P);
  P.Y := P.Y + GetCursorHeightMargin;
  R := Rect(P.X, P.Y, P.X, P.Y);
  HW.ActivateHint(R, HintText);
  HW.Visible := True;
  HintTimer.Enabled := False;
  HintTimer.Interval := Application.HintHidePause;
  HintTimer.OnTimer := HintTime2;
  HintTimer.Enabled := True;
end;

procedure TspSkinHint.HintTime2(Sender: TObject);
begin
  HideHint;
end;

procedure TspSkinHint.ActivateHint2(const AHint: string);
begin
  if HintTimer <> nil
  then
    begin
      HintTimer.Enabled := False;
      HintTimer.Free;
      HintTimer := nil;
    end;
  HintText := AHint;
  HintTimer := TTimer.Create(Self);
  HintTimer.Enabled := False;
  HintTimer.Interval := Application.HintPause;
  HintTimer.OnTimer := HintTime1;
  HintTimer.Enabled := True;
end;

procedure TspSkinHint.ActivateHint(P: TPoint; const AHint: string);
var
  R: TRect;
begin
  R := Rect(P.X, P.Y, P.X, P.Y);
  HW.ActivateHint(R, AHint);
  HW.Visible := True;
end;

procedure TspSkinHint.HideHint;
begin
  if HintTimer <> nil
  then
    begin
      HintTimer.Enabled := False;
      HintTimer.Free;
      HintTimer := nil;
    end;
  if HW.Visible
  then
    begin
      HW.Visible := False;
      SetWindowPos(HW.Handle, HWND_TOPMOST, 0, 0, 0,
        0, SWP_HideWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
    end;    
end;

end.



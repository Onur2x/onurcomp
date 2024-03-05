{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spcalendar;

{$IFDEF VER230}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER220}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200}
{$ENDIF}

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     Buttons, SkinCtrls, SkinData, ExtCtrls;

type
  TspDaysOfWeek = (Sun, Mon, Tue, Wed, Thu, Fri, Sat);

  TspSkinMonthCalendar = class(TspSkinPanel)
  protected
    FIsChina: Boolean;
    FWeekNumbers: Boolean;
    FShowToday: Boolean;
    FTodayDefault: Boolean;
    BevelTop, CellW, CellH, BottomOffset: Integer;
    FBtns: array[0..3] of TspSkinSpeedButton;
    FDate: TDate;
    FFirstDayOfWeek: TspDaysOfWeek;
    CalFontColor: TColor;
    CalActiveFontColor: TColor;
    FOnNumberClick: TNotifyEvent;
    FBoldDays: Boolean;
    procedure Loaded; override;
    procedure SetTodayDefault(Value: Boolean);
    procedure OffsetMonth(AOffset: Integer);
    procedure OffsetYear(AOffset: Integer);
    procedure SetFirstDayOfWeek(Value: TspDaysOfWeek);
    procedure UpdateCalendar;
    procedure ArangeControls;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure SetSkinData(Value: TspSkinData); override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure SetDate(Value: TDate);
    procedure DrawCalendar(Cnvs: TCanvas);
    function DaysThisMonth: Integer;
    function GetMonthOffset: Integer;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DayNumFromPoint(X, Y: Integer): Word;
    procedure NextMButtonClick(Sender: TObject);
    procedure PriorMButtonClick(Sender: TObject);
    procedure NextYButtonClick(Sender: TObject);
    procedure PriorYButtonClick(Sender: TObject);
    procedure SetCaptionMode(Value: Boolean); override;
    procedure SetDefaultCaptionHeight(Value: Integer); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure SetBoldDays(Value: Boolean);
    procedure DrawFrame(R: TRect; C: TCanvas);
    procedure SetWeekNumbers(Value: Boolean);
    procedure SetShowToday(Value: Boolean);
    procedure DrawLineH(X, Y, AW: Integer; C: TColor; Cnvs: TCanvas);
    procedure DrawLineV(X, Y, AH: Integer; C: TColor; Cnvs: TCanvas);
    procedure PaintTransparent(C: TCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeSkinData; override;
  published
    property Date: TDate read FDate write SetDate;
    property WeekNumbers: Boolean read FWeekNumbers write SetWeekNumbers;
    property ShowToday: Boolean read FShowToday write SetShowToday;
    property TodayDefault: Boolean read FTodayDefault write SetTodayDefault;
    property FirstDayOfWeek: TspDaysOfWeek read FFirstDayOfWeek write SetFirstDayOfWeek;
    property OnNumberClick: TNotifyEvent
      read FOnNumberClick write FOnNumberClick;
    property BoldDays: Boolean read FBoldDays write SetBoldDays;
  end;

var
  SPTodayStr: String;


implementation
      Uses spUtils, spEffBmp;
{$R *.res}

const
  BSize = 23;
  RepeatInt = 250;

constructor TspSkinMonthCalendar.Create;
begin
  inherited;
  FIsChina := (GetSystemDefaultLangID and $3FF) = $04;
  FWeekNumbers := False;
  FShowToday := False;
  FForcebackground := False;
  BorderStyle := bvFrame;
  BottomOffset := 0;
  FBtns[0] := TspSkinSpeedButton.Create(Self);
  with FBtns[0] do
  begin
    RepeatMode := True;
    RepeatInterval := RepeatInt;
    SkinDataName := 'resizebutton';
    Width := BSize;
    Height := BSize;
    NumGlyphs := 1;
    Glyph.Handle := LoadBitmap(hInstance, 'SP_PRIORMONTH');
    OnClick := PriorMButtonClick;
    Parent := Self;
  end;

  FBtns[1] := TspSkinSpeedButton.Create(Self);
  with FBtns[1] do
  begin
    RepeatMode := True;
    RepeatInterval := RepeatInt;
    SkinDataName := 'resizebutton';
    Width := BSize;
    Height := BSize;
    NumGlyphs := 1;
    Glyph.Handle := LoadBitmap(hInstance, 'SP_NEXTMONTH');
    OnClick := NextMButtonClick;
    Parent := Self;
  end;

  FBtns[2] := TspSkinSpeedButton.Create(Self);
  with FBtns[2] do
  begin
    RepeatMode := True;
    RepeatInterval := RepeatInt - 150;
    SkinDataName := 'resizebutton';
    Width := BSize;
    Height := BSize;
    NumGlyphs := 1;
    Glyph.Handle := LoadBitmap(hInstance, 'SP_PRIORYEAR');
    OnClick := PriorYButtonClick;
    Parent := Self;
  end;

  FBtns[3] := TspSkinSpeedButton.Create(Self);
  with FBtns[3] do
  begin
    RepeatMode := True;
    RepeatInterval := RepeatInt - 150;
    SkinDataName := 'resizebutton';
    Width := BSize;
    Height := BSize;
    NumGlyphs := 1;
    Glyph.Handle := LoadBitmap(hInstance, 'SP_NEXTYEAR');
    OnClick := NextYButtonClick;
    Parent := Self;
  end;

  Width := 200;
  Height := 150;

  Date := Now;
  FTodayDefault := False;
  FBoldDays := False;
end;

procedure TspSkinMonthCalendar.PaintTransparent(C: TCanvas);
begin
  inherited;
  DrawCalendar(C);
end;

procedure TspSkinMonthCalendar.DrawLineH;
var
  B: TspBitMap;
  i, h, Step, A: Integer;
  DstP: PspColor;
begin
  if AW <= 0 then Exit;
  B := TspBitMap.Create;
  B.SetSize(AW, 1);
  with B.Canvas do
  begin
    Pen.Color := C;
    MoveTo(0, 0);
    LineTo(B.Width, 0);
  end;
  //
  B.CheckingAlphaBlend;
  for i := 0 to B.Width - 1 do
  begin
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := 255;
  end;
  h := B.Width div 4;
  Step := Round (255 / h);
  A := 0;
  for i := 0 to h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  A := 0;
  for i := B.Width - 1 downto B.Width - 1 - h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[i, 0];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  //
  B.AlphaBlend := True;
  B.Draw(Cnvs, X, Y);
  B.Free;
end;

procedure TspSkinMonthCalendar.DrawLineV;
var
  B: TspBitMap;
  i, h, Step, A: Integer;
  DstP: PspColor;
begin
  if AH <= 0 then Exit;
  B := TspBitMap.Create;
  B.SetSize(1, AH);
  with B.Canvas do
  begin
    Pen.Color := C;
    MoveTo(0, 0);
    LineTo(0, B.Height);
  end;
  //
  B.CheckingAlphaBlend;
  for i := 0 to B.Height - 1 do
  begin
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := 255;
  end;
  h := B.Height div 4;
  Step := Round (255 / h);
  A := 0;
  for i := 0 to h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  A := 0;
  for i := B.Height - 1 downto B.Height - 1 - h do
  begin
    if A > 255 then A := 255;
    DstP := B.PixelPtr[0, i];
    TspColorRec(DstP^).A := A;
    Inc(A, Step);
  end;
  //
  B.AlphaBlend := True;
  B.Draw(Cnvs, X, Y);
  B.Free;
end;


procedure TspSkinMonthCalendar.SetWeekNumbers(Value: Boolean);
begin
  if FWeekNumbers <> Value
  then
    begin
      FWeekNumbers := Value;
      RePaint;
    end;
end;

procedure TspSkinMonthCalendar.SetShowToday(Value: Boolean);
begin
  if FShowToday <> Value
  then
    begin
      FShowToday := Value;
      RePaint;
    end;
end;

procedure TspSkinMonthCalendar.SetBoldDays(Value: Boolean);
begin
  FBoldDays := Value;
  RePaint;
end;

procedure TspSkinMonthCalendar.SetTodayDefault;
begin
  FTodayDefault := Value;
  if FTodayDefault then Date := Now;
end;

procedure TspSkinMonthCalendar.WMEraseBkgnd;
begin
  if not FromWMPaint
  then
    begin
      PaintWindow(Msg.DC);
    end;  
end;

procedure TspSkinMonthCalendar.SetCaptionMode;
begin
  inherited;
  ArangeControls;
  UpdateCalendar;
end;

procedure TspSkinMonthCalendar.SetDefaultCaptionHeight;
begin
  inherited;
  ArangeControls;
  UpdateCalendar;
end;

procedure TspSkinMonthCalendar.ChangeSkinData;
var
  I: Integer;
begin
  I := -1;
  if (FSD <> nil) and not FSD.Empty
  then
    I := FSD.GetControlIndex('stdlabel');
  if I <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[I]) is TspDataSkinStdLabelControl
    then
      with TspDataSkinStdLabelControl(FSD.CtrlList.Items[I]) do
      begin
        CalFontColor := FontColor;
        CalActiveFontColor := ActiveFontColor;
      end
    else
      begin
        CalFontColor := Font.Color;
        CalActiveFontColor := Font.Color;
      end;
  inherited;
  ArangeControls;
end;

procedure TspSkinMonthCalendar.NextMButtonClick(Sender: TObject);
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  if AMonth = 12 then OffsetYear(1);
  OffsetMonth(1);
  Click;
end;

procedure TspSkinMonthCalendar.PriorMButtonClick(Sender: TObject);
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  if AMonth = 1 then OffsetYear(-1);
  OffsetMonth(-1);
  Click;
end;

procedure TspSkinMonthCalendar.NextYButtonClick(Sender: TObject);
begin
  OffsetYear(1);
  Click;
end;

procedure TspSkinMonthCalendar.PriorYButtonClick(Sender: TObject);
begin
  OffsetYear(-1);
  Click;
end;


procedure TspSkinMonthCalendar.OffsetMonth(AOffset: Integer);
var
  AYear, AMonth, ADay: Word;
  TempDate: TDate;
begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  AMonth := AMonth + AOffset;
  if AMonth > 12 then AMonth := 1 else
  if AMonth <= 0 then AMonth := 12;
  if ADay > DaysPerMonth(AYear, AMonth)
  then ADay := DaysPerMonth(AYear, AMonth);
  TempDate := EncodeDate(AYear, AMonth, ADay);
  Date := TempDate;
end;

procedure TspSkinMonthCalendar.OffsetYear(AOffset: Integer);
var
  AYear, AMonth, ADay: Word;
  TempDate: TDate;
begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  AYear := AYear + AOffset;
  if AYear <= 1760 then Exit else
    if AYear > 9999 then Exit;
  if ADay > DaysPerMonth(AYear, AMonth)
  then ADay := DaysPerMonth(AYear, AMonth);
  TempDate := EncodeDate(AYear, AMonth, ADay);
  Date := TempDate;
end;

procedure TspSkinMonthCalendar.SetFirstDayOfWeek(Value: TspDaysOfWeek);
begin
  FFirstDayOfWeek := Value;
  UpdateCalendar;
end;

procedure TspSkinMonthCalendar.SetSkinData;
var
  i: Integer;
begin
  inherited;
  for i := 0 to 3 do
   if FBtns[i] <> nil then FBtns[i].SkinData := Value;
end;

procedure TspSkinMonthCalendar.ArangeControls;
var
  R: TRect;
begin
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  if FBtns[0] = nil then Exit;
  with FBtns[2] do SetBounds(R.Left + 1, R.Top + 1, Width, Height);
  with FBtns[0] do SetBounds(FBtns[2].Left + BSize + 1, R.Top + 1, Width, Height);
  with FBtns[3] do SetBounds(R.Right - BSize - 1, R.Top + 1, Width, Height);
  with FBtns[1] do SetBounds(FBtns[3].Left - BSize - 1 , R.Top + 1, Width, Height);
end;

procedure TspSkinMonthCalendar.WMSIZE;
begin
  inherited;
  ArangeControls;
end;

procedure TspSkinMonthCalendar.CreateControlDefaultImage(B: TBitMap);
begin
  inherited;
  DrawCalendar(B.Canvas);
end;

procedure TspSkinMonthCalendar.CreateControlSkinImage(B: TBitMap);
begin
  inherited;
  DrawCalendar(B.Canvas);
end;

procedure TspSkinMonthCalendar.SetDate(Value: TDate);
begin
  FDate := Value;
  UpdateCalendar;
  RePaint;
end;

procedure TspSkinMonthCalendar.UpdateCalendar;
begin
  RePaint;
end;

function TspSkinMonthCalendar.GetMonthOffset: Integer;
var
  AYear, AMonth, ADay: Word;
  FirstDate: TDate;
begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  FirstDate := EncodeDate(AYear, AMonth, 1);
  Result := 2 - ((DayOfWeek(FirstDate) - Ord(FirstDayOfWeek) + 7) mod 7);
  if Result = 2 then Result := -5;
end;

procedure TspSkinMonthCalendar.DrawFrame;
var
  ButtonData: TspDataSkinButtonControl;
  Buffer: TBitMap;
  CIndex: Integer;
  XO, YO: Integer;
  FSkinPicture: TBitMap;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewCLRect: TRect;
  SknR: TRect;
begin
 ButtonData := nil;
  if FIndex <> -1
  then
    begin
      CIndex := SkinData.GetControlIndex('resizebutton');
      if CIndex <> -1
      then
        ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);
    end;
  if ButtonData <> nil
  then
    with ButtonData do
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(R);
      Buffer.Height := RectHeight(R);
      XO := RectWidth(R) - RectWidth(SkinRect);
      YO := RectHeight(R) - RectHeight(SkinRect);
      NewLTPoint := LTPoint;
      NewRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
      NewLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
      NewRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
      NewClRect := Rect(CLRect.Left, ClRect.Top,
        CLRect.Right + XO, ClRect.Bottom + YO);
      FSkinPicture := TBitMap(SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
      SknR := DownSkinRect;
      if IsNullRect(SknR) then SknR := SkinRect;
      CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
          Buffer, FSkinPicture, SknR, Buffer.Width, Buffer.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
      C.Draw(R.Left, R.Top, Buffer);
      Buffer.Free;
      C.Font.Color := DownFontColor;
    end
  else
    begin
      if FIndex <> -1
      then
        C.Pen.Color := CalActiveFontColor
      else
        C.Pen.Color := Font.Color;
      C.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end;
end;

procedure TspSkinMonthCalendar.DrawCalendar(Cnvs: TCanvas);

function WeekOfTheYear(Dat: TDateTime): Word;
var
  Day, Month, Year: Word;
  FirstDate: TDateTime;
  DateDiff: Integer;
begin
  Day := DayOfWeek(Dat) - 1;
  Dat := Dat + 3 -((6 + day) mod 7);
  DecodeDate(Dat, Year, Month, Day);
  FirstDate := EncodeDate(Year,1,1);
  DateDiff := Trunc(Dat - FirstDate);
  Result := 1 + (DateDiff div 7);
end;


var
  R: TRect;
  I, J: Integer;
  FMonthOffset, X, Y, X2, Y2: Integer;
  S: String;
  ADay, DayNum: Integer;
  CDate: TDateTime;
  AYear, AMonth, ADay_: Word;
  Week, OldWeek: Integer;
begin
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  if FWeekNumbers
  then
    begin
      Inc(R.Left, Width div 8);
    end;
  with Cnvs do
  begin
    Font := Self.DefaultFont;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.Charset;
    if FShowToday
    then
      begin
        BottomOffset := TextHeight('Wq') + 5;
        Dec(R.Bottom, BottomOffset);
      end
    else
      BottomOffset := 0;
    Brush.Style := bsClear;
    // draw caption
    S := FormatDateTime('MMMM, YYYY', FDate);
    Y := R.Top + 2;
    X := Width div 2 - TextWidth(S) div 2;
    if FIndex <> -1
    then
      Font.Color := CalFontColor;
    Font.Style := [fsBold];
    TextOut(X, Y, S);
    CellW := (RectWidth(R) - 2) div 7;
    if FIndex <> -1
    then
      Font.Color := CalActiveFontColor;
    // draw week days
    X := R.Left + 1;
    Y := R.Top + BSize + 10;
    for I := 0 to 6 do
    begin
      S := ShortDayNames[(Ord(FirstDayOfWeek) + I) mod 7 + 1];
      //
      if FIsChina
      then
        begin
          {$IFDEF UNICODE}
          if Length(S) > 2 then S := Copy(S, 3, 1)
          {$ELSE}
          if Length(S) > 4 then S := Copy(S, 5, 2)
          {$ENDIF}
        end
      else
        if Length(S) > 4 then S := Copy(S, 1, 4);
      //
      X2 := X + CellW div 2 - TextWidth(S) div 2;
      TextOut(X2, Y, S);
      X := X + CellW;
    end;
    // draw bevel
    BevelTop := Y + TextHeight('Wq') + 1;
    Pen.Color := Font.Color;
    DrawLineH(R.Left, BevelTop, RectWidth(R), Font.Color, Cnvs);
    if FWeekNumbers
    then
      begin
        DrawLineV(R.Left, BevelTop, R.Bottom - BevelTop, Font.Color, Cnvs);
      end;
    if FBoldDays then Font.Style := [fsBold] else Font.Style := [];
    // draw today
    if FShowToday
    then
      begin
        X := R.Left;
        Y := R.Bottom + 2;
        S := SPTodayStr + ' ' + DateToStr(Now);
        Font.Color := CalFontColor;
        TextOut(X, Y, S);
      end;
    // draw month numbers
    CellH := (R.Bottom - BevelTop - 4) div 6;
    if FIndex <> -1
    then
      Font.Color := CalFontColor;
    FMonthOffset := GetMonthOffset;
    ADay := ExtractDay(FDate);
    Y := BevelTop + 3;
    OldWeek := -2;
    for J := 0 to 6 do
    begin
      X := R.Left + 1;
      if FWeekNumbers
      then
        begin
          Week := -1;
          for I := 0 to 6 do
          begin
            DayNum := FMonthOffset + I + (J - 1) * 7;
            if (DayNum > 0) and (DayNum <= DaysThisMonth)
            then
              begin
                DecodeDate(FDate, AYear, AMonth, ADay_);
                CDate := EncodeDate(AYear, AMonth, DayNum);
                Week := WeekOfTheYear(CDate);
                if FirstDayOfWeek <> Sun
                then
                  Break;
              end;
          end;
          if Week <> -1
          then
            begin
              if (OldWeek = Week)
              then
                begin
                  Week := OldWeek + 1;
                  if Week > 52 then Week := 52;
                end;
              OldWeek := Week;
              S := IntToStr(Week);
              X2 := X + CellW div 2 - TextWidth(S) div 2 - CellW - 2;
              Y2 := Y - CellH div 2 - TextHeight(S) div 2;
              Font.Color := CalActiveFontColor;
              TextOut(X2, Y2, S);
              Font.Color := CalFontColor;
            end;
         end;
      //
      for I := 0 to 6 do
      begin
        DayNum := FMonthOffset + I + (J - 1) * 7;
        if (DayNum < 1) or (DayNum > DaysThisMonth) then S := ''
        else S := IntToStr(DayNum);
        if DayNum = ADay
        then
          Font.Style := Font.Style + [fsBold]
        else
          Font.Style := Font.Style - [fsBold];
        X2 := X + CellW div 2 - TextWidth(S) div 2;
        Y2 := Y - CellH div 2 - TextHeight(S) div 2;
        if DayNum = ADay
        then
          DrawFrame(Rect(X, Y - CellH, X + CellW, Y), Cnvs);
        if S <> '' then TextOut(X2, Y2, S);
        if FIndex <> -1
        then
          Font.Color := CalFontColor;
        X := X + CellW;
      end;
      Y := Y + CellH;
    end;
  end;
end;

function TspSkinMonthCalendar.DaysThisMonth: Integer;
begin
  Result := DaysPerMonth(ExtractYear(FDate), ExtractMonth(FDate));
end;

function TspSkinMonthCalendar.DayNumFromPoint;
var
  R, R1: TRect;
  FMonthOffset, X1, Y1, I, J: Integer;
begin
  Result := 0;
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  if FWeekNumbers
  then
    begin
      Inc(R.Left, Width div 8);
    end;
  if FShowToday
  then
    begin
      Dec(R.Bottom, BottomOffset);
    end;
  if not PtInRect(R, Point(X, Y)) then Exit;
  FMonthOffset := GetMonthOffset;
  Y1 := BevelTop + 3;
  for J := 0 to 6 do
  begin
    X1 := R.Left + 1;
    for I := 0 to 6 do
    begin
      R1 := Rect(X1, Y1 - CellH, X1 + CellW, Y1);
      if PtInRect(R1, Point(X, Y))
      then
        begin
          Result := FMonthOffset + I + (J - 1) * 7;
          if (Result < 1) or (Result > DaysThisMonth) then Result := 0;
          Break;
        end;
      X1 := X1 + CellW;
    end;
    Y1 := Y1 + CellH;
  end;
end;

procedure TspSkinMonthCalendar.MouseUp;
var
  DayNum, AYear, AMonth, ADay: Word;
  TempDate: TDate;
  R: TRect;
begin
  inherited;
  if Button <> mbLeft then Exit;
  DayNum := DayNumFromPoint(X, Y);
  if DayNum <> 0
  then
    begin
      DecodeDate(FDate, AYear, AMonth, ADay);
      ADay := DayNum;
      TempDate := EncodeDate(AYear, AMonth, ADay);
      Date := TempDate;
      if Assigned(FOnNumberClick) then FOnNumberClick(Self);
    end;
  if FShowToday
  then
    begin
      R := Rect(0, 0, Width, Height);
      AdjustClientRect(R);
      if Y > R.Bottom - BottomOffset
      then
        begin
          Date := Now;
          if Assigned(FOnNumberClick) then FOnNumberClick(Self);
        end;
    end;
end;


procedure TspSkinMonthCalendar.Loaded;
begin
  inherited;
  if FTodayDefault then Date := Now;
end;

var
  Comctl32Lib: Cardinal;
  ResStringRec: TResStringRec;

initialization

  Comctl32Lib := LoadLibrary('Comctl32');
  if Comctl32Lib <> 0
  then
    begin
      ResStringRec.Module := @Comctl32Lib;
      ResStringRec.Identifier := 4163;
      SPTodayStr := LoadResString(@ResStringRec);
    end
  else
    SPTodayStr := '';

finalization

  if Comctl32Lib <> 0 then FreeLibrary(Comctl32Lib);

end.

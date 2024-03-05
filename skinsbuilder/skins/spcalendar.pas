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

unit spcalendar;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     Buttons, SkinCtrlss, SkinData, ExtCtrls;

type
  TspDaysOfWeek = (Sun, Mon, Tue, Wed, Thu, Fri, Sat);

  TspSkinMonthCalendar = class(TspSkinPanel)
  protected
    FTodayDefault: Boolean;
    BevelTop, CellW, CellH: Integer;
    FBtns: array[0..3] of TspSkinSpeedButton;
    FDate: TDate;
    FFirstDayOfWeek: TspDaysOfWeek;
    CalFontColor: TColor;
    CalActiveFontColor: TColor;
    FOnNumberClick: TNotifyEvent;
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
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeSkinData; override;
  published
    property Date: TDate read FDate write SetDate;
    property TodayDefault: Boolean read FTodayDefault write SetTodayDefault; 
    property FirstDayOfWeek: TspDaysOfWeek read FFirstDayOfWeek write SetFirstDayOfWeek;
    property OnNumberClick: TNotifyEvent
      read FOnNumberClick write FOnNumberClick;
  end;


implementation
      Uses spUtils;
{$R *.res}

const
  BSize = 23;
  RepeatInt = 250;

constructor TspSkinMonthCalendar.Create;
begin
  inherited;

  BorderStyle := bvFrame;

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
end;

procedure TspSkinMonthCalendar.SetTodayDefault;
begin
  FTodayDefault := Value;
  if FTodayDefault then Date := Now;
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

procedure TspSkinMonthCalendar.DrawCalendar(Cnvs: TCanvas);
var
  R: TRect;
  I, J: Integer;
  FMonthOffset, X, Y, X2, Y2: Integer;
  S: String;
  ADay, DayNum: Integer;
begin
  R := Rect(0, 0, Width, Height);
  AdjustClientRect(R);
  with Cnvs do
  begin
    Font := Self.DefaultFont;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.Charset;
    Brush.Style := bsClear;
    // draw caption
    S := FormatDateTime('MMMM, YYYY', FDate);
    Y := R.Top + 3;
    X := Width div 2 - TextWidth(S) div 2 - 2;
    if FIndex <> -1
    then
      Font.Color := CalActiveFontColor;
    Font.Style := [fsBold];
    TextOut(X, Y, S);
    CellW := (RectWidth(R) - 2) div 7;
    // draw week days
    X := R.Left + 1;
    Y := R.Top + BSize + 10;
    for I := 0 to 6 do
    begin
      S := ShortDayNames[(Ord(FirstDayOfWeek) + I) mod 7 + 1];
      X2 := X + CellW div 2 - TextWidth(S) div 2;
      TextOut(X2, Y, S);
      X := X + CellW;
    end;
    // draw bevel
    BevelTop := Y + TextHeight('Wq') + 1;
    Pen.Color := Font.Color;
    MoveTo(R.Left + 1, BevelTop);
    LineTo(R.Right - 1, BevelTop);
    Font.Style := [];
    // draw month numbers
    CellH := (R.Bottom - BevelTop - 4) div 6;
    if FIndex <> -1
    then
      Font.Color := CalFontColor;
    FMonthOffset := GetMonthOffset;
    ADay := ExtractDay(FDate);
    Y := BevelTop + 3;
    for J := 0 to 6 do
    begin
      X := R.Left + 1;
      for I := 0 to 6 do
      begin
        DayNum := FMonthOffset + I + (J - 1) * 7;
        if (DayNum < 1) or (DayNum > DaysThisMonth) then S := ''
        else S := IntToStr(DayNum);
        X2 := X + CellW div 2 - TextWidth(S) div 2;
        Y2 := Y - CellH div 2 - TextHeight(S) div 2;
        if S <> '' then TextOut(X2, Y2, S);
        if DayNum = ADay
        then
          begin
            if FIndex <> -1
            then
              Pen.Color := CalActiveFontColor
            else
             Pen.Color := Font.Color;
           Rectangle(X, Y - CellH, X + CellW, Y);
         end;
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
end;


procedure TspSkinMonthCalendar.Loaded;
begin
  inherited;
  if FTodayDefault then Date := Now;
end;


end.

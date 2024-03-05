
{*******************************************************}
{                                                       }
{                 Delphi TKnob Component                }
{       Copyright © 1999, Gary Bradley Hardman.         }
{                 Written 29th May 1997                 }
{                     Version 1.0                       }
{              Released November 29th 1999              }
{   No warranties whatsoever are implied or offered     }
{                    for this unit                      }
{                                                       }
{*******************************************************}

unit Knob;

interface

uses

  WinTypes, WinProcs, Classes, Graphics, Controls, Messages,
  Menus, Stdctrls, SysUtils;

type

  TKnob = class(TCustomControl)
  private

    fLineColor: TColor;        { Colour of the Indicator line}
    fMin: Integer;             { Minimum value }
    fMax: Integer;             { Maximum value }
    fPosition: Integer;        { From fMin to fMax inclusive }
    fPositionLabel: TLabel;    { A label control to which position info is sent}
    fSpringLoaded: Boolean;    { True - knob returns to zero when released}
    fPageSize: Word;           { The increment/decrement of pgup, pgdown}
    fDiameter: Integer;        { Current knob width/height}
    fRadius: Integer;          { Half knob-width/height}
    fSteps: Integer;           { Number of steps from Min to Max }
    fAngleInterval: Single;    { The angle each step represents }
    fAngle: Integer;           { The current angle of the indicator }
    fMouseAngle: Integer;      { The current mouse 'angle' over the knob }
    fDragging: Boolean;        { Knob position is being 'changed' }

    fIndicatorInnerPosition: TPoint;
    fIndicatorOuterPosition: TPoint;
    fLastIndicatorInnerPosition: TPoint;
    fLastIndicatorOuterPosition: TPoint;

    fOnChange: TNotifyEvent;

    procedure SetMin(const NewMinValue: Integer);
    procedure SetMax(const NewMaxValue: Integer);
    procedure SetPosition(const NewPosition: Integer);
    procedure SetParams(APosition, AMin, AMax: Integer);

    procedure SetSteps;
    procedure CalcAngle;
    function  CalcPosition(const TheAngle: Integer): Integer;

    procedure SetPositionLabel(const NewLabel: TLabel);
    procedure ShowPosition(const ThePosition: Integer);
    procedure SetSpringLoaded(const Sprung: Boolean);

    procedure SetLineColor(NewColor : TColor);

    {Windows Messages}
    procedure WMCreate(var Message: TWMCreate);
              message WM_CREATE;
    procedure WMSize(var Message: TWMSize);
              message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSETFOCUS);
              message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKILLFOCUS);
              message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode);
              message WM_GETDLGCODE;

    {Delphi Component Messages}
    procedure CMMouseLeave(var Message: TMessage);
              message cm_MouseLeave;
    procedure CMEnabledChanged(var Message: TMessage);
              message cm_EnabledChanged;
    procedure CMVisibleChanged(var Message: TMessage);
              message cm_VisibleChanged;
    procedure CM_ParentColorChanged(var Msg: TMessage);
              message cm_ParentColorChanged;
    procedure CM_TextChanged(var Msg: TMessage);
              message cm_TextChanged;

  protected

    procedure Paint; override;
    procedure PaintKnob;
    procedure PaintState;
    procedure PaintIndicator;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public

    constructor Create(AOwner: TComponent); override;

  published

  { property Anchors; } {Commented out for compatibility with Delphi 1,2 & 3}
    property ParentShowHint;
    property ShowHint;

    property Max: Integer
      read fMax
      write SetMax
      default 127;

    property Min: Integer
      read fMin
      write SetMin
      default 0;

    property Caption;

    property LineColor: TColor
      read fLineColor
      write SetLineColor
      default clActiveCaption;

    property Position: Integer
      read fPosition
      write SetPosition
      default 0;

    property PageSize: Word
      read fPageSize
      write fPageSize
      default 10;

    property PositionLabel: TLabel
      read fPositionLabel
      write SetPositionLabel;

    property SpringLoaded: Boolean
      read fSpringLoaded
      write SetSpringLoaded
      default False;

    property TabStop
      default True;
    property TabOrder;

    property PopupMenu;
    property Visible;
    property Enabled;

    property OnChange: TNotifyEvent
      read fOnChange
      write fOnChange;

    property OnClick;      
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

  end;

  procedure Register;

{ TKnob }
implementation

{Returns the largest of the two parameters, or the first parameter if equal}
function MaxInt(Value1, Value2: Integer) : Integer;
begin
  if Value2 > Value1 then Result := Value2 else Result := Value1;
end;

{Returns the smallest of the two parameters, or the first parameter if equal}
function MinInt(Value1, Value2: Integer) : Integer;
begin
  if Value1 > Value2 then Result := Value2 else Result := Value1;
end;

constructor TKnob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 40;
  Height := 40;
  fRadius := 20;
  fMin := 0;
  fMax:= 127;
  fPosition := 0;
  fPageSize:= 10;
  fSpringLoaded := False;
  fLineColor := clActiveCaption;
  TabStop := True;
  ControlStyle := ControlStyle + [csOpaque];
end;

procedure TKnob.SetPositionLabel(const NewLabel: TLabel);
begin
  if fPositionLabel <> NewLabel then fPositionLabel:= NewLabel;
  if fPositionLabel <> nil then ShowPosition(Position);
end;

{If the Position-Label is removed then point PositionLabel to nil }
procedure TKnob.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = fPositionLabel) and (Operation = opRemove) then
    PositionLabel:= nil;
end;

{If the caption changes then re-draw on Position Label as suffix}
procedure TKnob.CM_TextChanged(var MSG: TMessage);
begin
  ShowPosition(Position);
end;

{Display the Position value in an associated PositionLabel control}
procedure TKnob.ShowPosition(const ThePosition: Integer);
begin
  if fPositionLabel <> nil then
  fPositionLabel.Caption := Format('%d ' + Caption, [ThePosition]);
end;

procedure TKnob.WMCreate(var Message: TWMCreate);
begin
  inherited;
  SetSteps;
  CalcAngle;
end;

procedure TKnob.WMSize(var Message: TWMSize);
var
  H: Integer;
begin
  if (Height > fDiameter) or (Width > fDiameter) {growing}
    then H := MaxInt(Height, Width) else
  if (Height < fDiameter) or (Width < fDiameter) {shrinking}
    then H := MinInt(Height, Width)
  else H := fDiameter;
  Setbounds(Left,Top,H,H);
  fDiameter := H;
  fRadius := H div 2;
  inherited;
end;

procedure TKnob.WMSetFocus(var Message: TWMSETFOCUS);
begin
  PaintState;
  inherited;
end;

procedure TKnob.WMKillFocus(var Message: TWMKILLFOCUS);
begin
  fDragging := False; {Release dragging flag}
  if SpringLoaded then Position := 0;
  PaintState; {Paint as non-focused}
  inherited;
end;

procedure TKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewPosition: Integer;
begin
  if fDragging then
  begin
    if SpringLoaded then Position := 0 else
    begin
      NewPosition := CalcPosition(fMouseAngle);
      if Position <> NewPosition then Position := NewPosition;
    end;
    fDragging := False;
  end; {if dragging}
  inherited MouseUp(Button,Shift,X,Y);
 end;

procedure TKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  RegionHandle: HRgn;
begin
  if Button = mbLeft then
  begin
    RegionHandle:= CreateEllipticRgnIndirect(ClientRect);
    if RegionHandle > 0 then
      if PtInRegion(RegionHandle, X,Y) then
      try
        SetFocus;
        fDragging := True;
        Position:= CalcPosition(fMouseAngle);
        PaintIndicator;
        {Ensure the created region is deleted}
      finally
        DeleteObject(RegionHandle);
      end; {try/finally}
  end; {if mbLeft}
  inherited MouseDown(Button,Shift,X,Y);
end;

{This is where the MouseAngle value is changed,
 (the 'Position' value is calculated from fMouseAngle) }
procedure TKnob.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewPosition: Integer;
begin
  if X = Width div 2 then
  begin
    if Y > Height div 2
    then fMouseAngle := 240 {Correctly 270, but 240 reflects real world knob }
    else fMouseAngle := 90; {rotation behaviour}
  end
  else
  begin
    fMouseAngle := Round(ArcTan(((Height div 2)-Y)/(X-(Width div 2)))*180/pi);
    if X < Width div 2 then fMouseAngle := (fMouseAngle + 540) MOD 360;
  end;

  {Limit movement to between 240 clockwise through zero to 300 degrees}
  if (fMouseAngle <= 270) and (fMouseAngle > 240) then fMouseAngle := 240;
  if (fMouseAngle < -60) then fMouseAngle := -60;

  {Where would this set Position to, if clicked?}
  NewPosition := CalcPosition(fMouseAngle);

  {if the knob is being dragged and the position has changed then update
   Position to this new position}
  if fDragging and (fPosition <> NewPosition) then Position:= NewPosition;

 {Show the Angle on a label (if associated)}
  ShowPosition(NewPosition);

 {Enable default OnMouseMove processing}
  inherited MouseMove(Shift,X,Y);
end;

{Reset the PositionLabel caption on mouse-exit}
procedure TKnob.CMMouseLeave(var Message: TMessage);
begin
  ShowPosition(Position);
  inherited;
end;

procedure TKnob.CMEnabledChanged(var Message: TMessage);
begin
  {Force the knob to re-paint its new state}
  PaintState;
  inherited;
end;

procedure TKnob.CMVisibleChanged(var Message: TMessage);
begin
  {Show or hide the position Label in sync with the Knob}
  if PositionLabel <> nil then PositionLabel.Visible := Self.Visible;
  inherited;
end;

procedure TKnob.CM_ParentColorChanged(var Msg: TMessage);
begin
  Canvas.Brush.Color:= TWinControl(Parent).Brush.Color;
  Canvas.FillRect(ClientRect);
  Paint;
  inherited;
end;

procedure TKnob.SetSpringLoaded(const Sprung: Boolean);
begin
  if fSpringLoaded <> Sprung then fSpringLoaded := Sprung;
  if Sprung then Position := 0;
end;

procedure TKnob.SetPosition(const NewPosition: Integer);
begin
  SetParams(NewPosition, fMin, fMax);
end;

procedure TKnob.SetMin(const NewMinValue: Integer);
begin
  SetParams(fPosition, NewMinValue, fMax);
end;

procedure TKnob.SetMax(const NewMaxValue: Integer);
begin
  SetParams(fPosition, fMin, NewMaxValue);
end;
{Calculate characteristics of knob when Position, Max or Min are changed}
procedure TKnob.SetParams(APosition, AMin, AMax: Integer);
begin
  if (fMin <> AMin) then {Min has Changed}
  begin
    fMin := AMin;
    SetSteps;     {updates fSteps and fAngleInterval}
  end;

  if (fMax <> AMax) then
  begin
    fMax := AMax;
    SetSteps;     {updates fSteps and fAngleInterval}
  end;

  if fAngleInterval >= 0 then {Max is greater than Min}
  begin
    if APosition < AMin then APosition := AMin;
    if APosition > AMax then APosition := AMax;
  end else
  begin                      {Min is Greater than Max}
    if APosition > AMin then APosition := AMax;
    if APosition < AMax then APosition := AMin;
  end;

  if fPosition <> APosition then fPosition := APosition;

  CalcAngle;                {Set fAngle}
  PaintIndicator;           {And paint the new indicator position}
  ShowPosition(Position);   {Update the PositionLabel caption}

  {Fire the OnChange event if not in Designing state}
  if (Assigned(fOnChange)) and not (csDesigning in ComponentState)
  then fOnChange(Self);
end;

{Called whenever Min or Max is changed}
procedure TKnob.SetSteps;
begin
  fSteps := fMax - fMin;
  if fSteps = 0 then fAngleInterval:= 0 else
  begin
    fAngleInterval := 300 / fSteps;
    fSteps := Abs(fSteps);
  end;
end;

{Calculate fAngle based on fMin, fPosition and fAngleInterval}
procedure TKnob.CalcAngle;
begin
  fAngle := 240 - Round((fPosition - fMin) * fAngleInterval);
end;

{Calculate fPosition based on fMin, fMax, Angle parameter and fAngleInterval}
function TKnob.CalcPosition(const TheAngle: Integer): Integer;
begin
  if fAngleInterval = 0 then Result := fMin else
    Result := fMin + Round((240 - TheAngle) / fAngleInterval);
end;

{Set the colour of the indicator line}
procedure TKnob.SetLineColor(NewColor : TColor);
begin
  if (fLineColor <> NewColor) and (NewColor <> clBtnFace) then
  begin
    fLineColor := NewColor;
    Invalidate;
  end;
end;

procedure TKnob.PaintKnob;
begin
  with Canvas, ClientRect do
  begin
    {Draws a circular clBtnFace coloured knob-face}
    {regardless of the Parents Canvas.Brush color}
    Pen.Color := clBtnFace;
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;

    {Draw the circular patch - 2 pixels is the width of the highlight
     & shadow arcs, as drawn below. Test showed that drawing it this small
     reduced flicker by not obliterating the arcs before they're re-drawn}
    Ellipse(2, 2, Width-2, Height-2);

    {Draw the upper highlighted arc}
    Pen.Width := 2;
    Pen.Color := clBtnHighlight;
    Arc(Left+2,Top+2,Right,Bottom,Right,Top,Left,Bottom);

    {Draw the lower shadowed arc}
    Pen.Color := clBtnShadow;
    Arc(Left+1,Top+1,Right-1,Bottom-1,Left,Bottom,Right,Top);

  end; {with Canvas, ClientRect}
end;

{Called when Enabled is changed or the knob loses/gains focus}
procedure TKnob.PaintState;
begin
  with Canvas, ClientRect do
  begin
    Pen.Width:= 1;
    Brush.Style:= bsClear;
    if Enabled then Pen.Color := clBlack else Pen.Color := clBtnShadow;
    Ellipse(0, 0, Width, Height);
    if focused then Pen.Color := clBlack else Pen.Color := clBtnShadow;
    Arc(Left,Top,Right,Bottom,Right,Top,Left,Bottom);
    if PositionLabel <> nil then PositionLabel.Enabled := Self.Enabled;
  end;
end;

procedure TKnob.PaintIndicator;
var
  AngleInRadians, CosAngle, SinAngle: Single;
begin
  AngleInRadians := fAngle*pi/180;
  CosAngle := Cos(AngleInRadians);
  SinAngle := Sin(AngleInRadians);

  with Canvas do
  begin
   {Erase Indicator}
    Pen.Color := clBtnFace;
    with fIndicatorInnerPosition do MoveTo(X+1,Y+1);
    with fIndicatorOuterPosition do LineTo(X+1,Y+1);
    PolyLine([fIndicatorInnerPosition, fIndicatorOuterPosition]);

    {Store the current Indicator positions as the 'last' ones before...}
    fLastIndicatorInnerPosition := fIndicatorInnerPosition;
    fLastIndicatorOuterPosition := fIndicatorOuterPosition;

    {Calculating the new Indicator positions}
    fIndicatorInnerPosition.X := fRadius + Round(((fRadius)-11)*CosAngle);
    fIndicatorInnerPosition.Y := fRadius - Round(((fRadius)-11)*SinAngle);

    fIndicatorOuterPosition.X := fRadius + Round(((fRadius)-5)*CosAngle);
    fIndicatorOuterPosition.Y := fRadius - Round(((fRadius)-5)*SinAngle);

    Pen.Color := clBtnHighlight;
    with fIndicatorInnerPosition do MoveTo(X+1,Y+1);
    with fIndicatorOuterPosition do LineTo(X+1,Y+1);

    Pen.Color := fLineColor;
    PolyLine([fIndicatorInnerPosition, fIndicatorOuterPosition]);
  end; {with Canvas}
end;

{Full-bodied paint procedure}
procedure TKnob.Paint;
begin
  PaintKnob;
  PaintState;
  PaintIndicator;
end;

{Knob control to process Arrow, Page and Home/End keys}
procedure TKnob.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := DLGC_WANTARROWS;
end;

procedure TKnob.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_PRIOR : Position:= fPosition + fPageSize;
    VK_NEXT  : Position:= fPosition - fPageSize;
    VK_END   : Position:= fMax;
    VK_HOME  : Position:= fMin;
    VK_LEFT  : Position:= fPosition -1;
    VK_UP    : Position:= fPosition +1;
    VK_RIGHT : Position:= fPosition +1;
    VK_DOWN  : Position:= fPosition -1;
  end;
end;

procedure Register;
begin
  RegisterComponents('Custom', [TKnob]);
end;

end.


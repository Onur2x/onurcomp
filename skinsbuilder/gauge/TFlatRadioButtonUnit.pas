unit TFlatRadioButtonUnit;

interface

{$DEFINE D4CB4}

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, ExtCtrls, FlatUtilitys;

type
  TFlatRadioButton = class(TCustomControl)
  private
    FUseAdvColors: Boolean;
    FAdvColorFocused: TAdvColors;
    FAdvColorDown: TAdvColors;
    FAdvColorBorder: TAdvColors;
    FMouseInControl: Boolean;
    MouseIsDown: Boolean;
    Focused: Boolean;
    FGroupIndex: Integer;
    FLayout: TRadioButtonLayout;
    FChecked: Boolean;
    FFocusedColor: TColor;
    FDownColor: TColor;
    FDotColor: TColor;
    FBorderColor: TColor;
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure SetLayout (Value: TRadioButtonLayout);
    procedure SetChecked (Value: Boolean);
    procedure CMEnabledChanged (var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTextChanged (var Message: TWmNoParams); message CM_TEXTCHANGED;
    procedure CMDialogChar (var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CNCommand (var Message: TWMCommand); message CN_COMMAND;
    procedure WMSetFocus (var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged (var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure RemoveMouseTimer;
    procedure MouseTimerHandler (Sender: TObject);
  protected
    procedure CalcAdvColors;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove (Shift: TShiftState; X, Y: Integer); override;
    procedure CreateWnd; override;
    procedure DrawRadio;
    procedure DrawRadioText;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseEnter;
    procedure MouseLeave;
  published
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default false;
    property Color default $00E1EAEB;
    property ColorFocused: TColor index 0 read FFocusedColor write SetColors default clWhite;
    property ColorDown: TColor index 1 read FDownColor write SetColors default $00C5D6D9;
    property ColorDot: TColor index 2 read FDotColor write SetColors default clBlack;
    property ColorBorder: TColor index 3 read FBorderColor write SetColors default $008396A0;
    property AdvColorFocused: TAdvColors index 0 read FAdvColorFocused write SetAdvColors default 10;
    property AdvColorDown: TAdvColors index 1 read FAdvColorDown write SetAdvColors default 10;
    property AdvColorBorder: TAdvColors index 2 read FAdvColorBorder write SetAdvColors default 50;
    property UseAdvColors: Boolean read FUseAdvColors write SetUseAdvColors default false;
    property Enabled;
    property Font;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex default 0;
    property Layout: TRadioButtonLayout read FLayout write SetLayout default radioLeft;
    property ParentColor;
    property ParentFont;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
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

var
  MouseInControl: TFlatRadioButton = nil;

implementation

var
  MouseTimer: TTimer = nil;
  ControlCounter: Integer = 0;

procedure TFlatRadioButton.CMDesignHitTest(var Message: TCMDesignHitTest);
begin
  case FLayout of
    radioLeft:
      if PtInRect(Rect(ClientRect.Left + 1, ClientRect.Top + 3, ClientRect.Left + 11, ClientRect.Top + 13), Point(message.XPos, message.YPos)) then
        Message.Result := 1
      else
        Message.Result := 0;
    radioRight:
      if PtInRect(Rect(ClientRect.Right - 11, ClientRect.Top + 3, ClientRect.Right - 1, ClientRect.Top + 13), Point(message.XPos, message.YPos)) then
        Message.Result := 1
      else
        Message.Result := 0;
  end;
end;

constructor TFlatRadioButton.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  if MouseTimer = nil then
  begin
    MouseTimer := TTimer.Create(nil);
    MouseTimer.Enabled := False;
    MouseTimer.Interval := 100; // 8 times a second
  end;
  ParentColor := True;
  ParentFont := True;
  FFocusedColor := clWhite;
  FDownColor := $00C5D6D9;
  FDotColor := clBlack;
  FBorderColor := $008396A0;
  FLayout := radioLeft;
  FChecked := false;
  FGroupIndex := 0;
  Enabled := true;
  Visible := true;
  SetBounds(0, 0, 121, 17);
  FUseAdvColors := false;
  FAdvColorFocused := 10;
  FAdvColorDown := 10;
  FAdvColorBorder := 50;
  Inc(ControlCounter);
end;

destructor TFlatRadioButton.Destroy;
begin
  RemoveMouseTimer;
  Dec(ControlCounter);
  if ControlCounter = 0 then
  begin
    MouseTimer.Free;
    MouseTimer := nil;
  end;
  inherited;
end;

procedure TFlatRadioButton.SetColors (Index: Integer; Value: TColor);
begin
  case Index of
    0: FFocusedColor := Value;
    1: FDownColor := Value;
    2: FDotColor := Value;
    3: FBorderColor := Value;
  end;
  Invalidate;
end;

procedure TFlatRadioButton.CalcAdvColors;
begin
  if FUseAdvColors then
  begin
    FFocusedColor := CalcAdvancedColor(Color, FFocusedColor, FAdvColorFocused, lighten);
    FDownColor := CalcAdvancedColor(Color, FDownColor, FAdvColorDown, darken);
    FBorderColor := CalcAdvancedColor(Color, FBorderColor, FAdvColorBorder, darken);
  end;
end;

procedure TFlatRadioButton.SetAdvColors (Index: Integer; Value: TAdvColors);
begin
  case Index of
    0: FAdvColorFocused := Value;
    1: FAdvColorDown := Value;
    2: FAdvColorBorder := Value;
  end;
  CalcAdvColors;
  Invalidate;
end;

procedure TFlatRadioButton.SetUseAdvColors (Value: Boolean);
begin
  if Value <> FUseAdvColors then
  begin
    FUseAdvColors := Value;
    ParentColor := Value;
    CalcAdvColors;
    Invalidate;
  end;
end;

procedure TFlatRadioButton.SetLayout (Value: TRadioButtonLayout);
begin
  FLayout := Value;
  Invalidate;
end;

procedure TFlatRadioButton.SetChecked (Value: Boolean);
var
  I: Integer;
  Sibling: TFlatRadioButton;
begin
  if FChecked <> Value then
  begin
    TabStop := Value;
    FChecked := Value;
    if Value then
    begin
      if Parent <> nil then
        for i := 0 to Parent.ControlCount-1 do
          if Parent.Controls[i] is TFlatRadioButton then
          begin
            Sibling := TFlatRadioButton(Parent.Controls[i]);
            if (Sibling <> Self) and (Sibling.GroupIndex = GroupIndex) then
              Sibling.SetChecked(False);
          end;
      Click;
      if csDesigning in ComponentState then
        if (GetParentForm(self) <> nil) and (GetParentForm(self).Designer <> nil) then
          GetParentForm(self).Designer.Modified;
    end;
    DrawRadio;
  end;
end;

procedure TFlatRadioButton.CMEnabledChanged (var Message: TMessage);
begin
  inherited;
  if not Enabled then
  begin
    FMouseInControl := False;
    MouseIsDown := False;
    RemoveMouseTimer;
  end;
  Invalidate;
end;

procedure TFlatRadioButton.CMTextChanged (var Message: TWmNoParams);
begin
  inherited;
  Invalidate;
end;

procedure TFlatRadioButton.MouseEnter;
begin
  if Enabled and not FMouseInControl then
  begin
    FMouseInControl := True;
    DrawRadio;
  end;
end;

procedure TFlatRadioButton.MouseLeave;
begin
  if Enabled and FMouseInControl and not MouseIsDown then
  begin
    FMouseInControl := False;
    RemoveMouseTimer;
    DrawRadio;
  end;
end;

procedure TFlatRadioButton.CMDialogChar (var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(Message.CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      Result := 1;
    end
    else
      inherited;
end;

procedure TFlatRadioButton.CNCommand (var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Click;
end;

procedure TFlatRadioButton.WMSetFocus (var Message: TWMSetFocus);
begin
  inherited;
  if Enabled then
  begin
    Focused := True;
    DrawRadio;
  end;
end;

procedure TFlatRadioButton.WMKillFocus (var Message: TWMKillFocus);
begin
  inherited;
  if Enabled then
  begin
    FMouseInControl := False;
    Focused := False;
    DrawRadio;
  end;
end;


procedure TFlatRadioButton.CMSysColorChange (var Message: TMessage);
begin
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

procedure TFlatRadioButton.CMParentColorChanged (var Message: TWMNoParams);
begin
  inherited;
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

procedure TFlatRadioButton.DoEnter;
begin
  inherited DoEnter;
  if MouseIsDown and FMouseInControl then
    Checked := True;
  Focused := True;
  DrawRadio;
end;

procedure TFlatRadioButton.DoExit;
begin
  inherited DoExit;
  Focused := False;
  DrawRadio;
end;

procedure TFlatRadioButton.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Enabled then
  begin
    SetFocus;
    MouseIsDown := true;
    DrawRadio;
    inherited MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TFlatRadioButton.MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Enabled then
  begin
    MouseIsDown := false;
    if (X>=0) and (X<=Width) and (Y>=0) and (Y<=Height) and not Checked then
      Checked := True;
    DrawRadio;
    inherited MouseUp(Button, Shift, X, Y);
  end;
end;

procedure TFlatRadioButton.MouseMove (Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  inherited;
  // mouse is in control ?
  P := ClientToScreen(Point(X, Y));
  if (MouseInControl <> Self) and (FindDragTarget(P, True) = Self) then
  begin
    if Assigned(MouseInControl) then
      MouseInControl.MouseLeave;
    // the application is active ?
    if (GetActiveWindow <> 0) then
    begin
      if MouseTimer.Enabled then
        MouseTimer.Enabled := False;
      MouseInControl := Self;
      MouseTimer.OnTimer := MouseTimerHandler;
      MouseTimer.Enabled := True;
      MouseEnter;
    end;
  end;
end;

procedure TFlatRadioButton.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, BM_SETCHECK, Cardinal(FChecked), 0);
end;

procedure TFlatRadioButton.DrawRadio;
var
  RadioRect: TRect;
begin
  case FLayout of
    radioLeft:
      RadioRect := Rect(ClientRect.Left + 1, ClientRect.Top + 3, ClientRect.Left + 11, ClientRect.Top + 13);
    radioRight:
      RadioRect := Rect(ClientRect.Right - 11, ClientRect.Top + 3, ClientRect.Right - 1, ClientRect.Top + 13);
  end;

  // Radio
  canvas.pen.style := psSolid;
  canvas.pen.width := 1;
  // Background + Border
  if Focused or FMouseInControl then
    if not MouseIsDown then
    begin
      canvas.brush.color := FFocusedColor;
      canvas.pen.color := FBorderColor;
    end
    else
    begin
      canvas.brush.color := FDownColor;
      canvas.pen.color := FBorderColor;
    end
  else
  begin
    canvas.brush.color := Color;
    canvas.pen.color := FBorderColor;
  end;
  Ellipse(canvas.handle, radioRect.left, radioRect.top, radioRect.Right, radioRect.bottom);

  // Dot
  if Checked then
  begin
    if Enabled then
    begin
      canvas.brush.color := FDotColor;
      canvas.pen.color := FDotColor;
    end
    else
    begin
      canvas.brush.color := clBtnShadow;
      canvas.pen.color := clBtnShadow;
    end;
    Ellipse(canvas.handle, radioRect.left+3, radioRect.top+3, radioRect.left+7, radioRect.top+7);
  end;
end;

procedure TFlatRadioButton.DrawRadioText;
var
  TextBounds: TRect;
  Format: UINT;
begin
  Format := DT_WORDBREAK;
  case FLayout of
    radioLeft:
    begin
      TextBounds := Rect(ClientRect.Left + 16, ClientRect.Top + 1, ClientRect.Right - 1, ClientRect.Bottom - 1);
      Format := Format or DT_LEFT;
    end;
    radioRight:
    begin
      TextBounds := Rect(ClientRect.Left + 1, ClientRect.Top + 1, ClientRect.Right - 16, ClientRect.Bottom - 1);
      Format := Format or DT_RIGHT;
    end;
  end;

  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;
    if not Enabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Format);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Format);
    end
    else
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Format);
  end;
end;

procedure TFlatRadioButton.Paint;
begin
  DrawRadio;
  DrawRadioText;
end;

procedure TFlatRadioButton.MouseTimerHandler (Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos (P);
  if FindDragTarget(P, True) <> Self then
    MouseLeave;
end;

procedure TFlatRadioButton.RemoveMouseTimer;
begin
  if MouseInControl = Self then
  begin
    MouseTimer.Enabled := False;
    MouseInControl := nil;
  end;
end;

end.

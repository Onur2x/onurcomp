unit TFlatTabControlUnit;

interface

{$DEFINE D4CB4}

uses
  Windows, Messages, Classes, Controls, Forms, Graphics, StdCtrls, SysUtils, FlatUtilitys;

type
  TFlatTabControl = class(TCustomControl)
  private
    FUseAdvColors: Boolean;
    FAdvColorBorder: TAdvColors;
    FTabPosition: TFlatTabPosition;
    FTabs: TStrings;
    FTabsRect: TList;
    FTabHeight: Integer;
    FTabSpacing: Integer;
    FActiveTab: Integer;
    FUnselectedColor: TColor;
    FBorderColor: TColor;
    FOnTabChanged: TNotifyEvent;
    procedure SetTabs (Value: TStrings);
    procedure SetTabPosition (Value: TFlatTabPosition);
    procedure SetTabHeight (Value: Integer);
    procedure SetTabSpacing (Value: Integer);
    procedure SetActiveTab (Value: Integer);
    procedure SetColors (Index: Integer; Value: TColor);
    procedure SetAdvColors (Index: Integer; Value: TAdvColors);
    procedure SetUseAdvColors (Value: Boolean);
    procedure SetTabRect;
    procedure CMDialogChar (var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged (var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMSize (var Message: TWMSize); message WM_SIZE;
    procedure CMSysColorChange (var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMParentColorChanged (var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
  protected
    procedure CalcAdvColors;
    procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property ColorBorder: TColor index 0 read FBorderColor write SetColors default $008396A0;
    property ColorUnselectedTab: TColor index 1 read FUnselectedColor write SetColors default $00996633;
    property AdvColorBorder: TAdvColors index 0 read FAdvColorBorder write SetAdvColors default 50;
    property UseAdvColors: Boolean read FUseAdvColors write SetUseAdvColors default false;
    property Tabs: TStrings read FTabs write SetTabs;
    property TabHeight: Integer read FTabHeight write SetTabHeight default 16;
    property TabSpacing: Integer read FTabSpacing write SetTabSpacing default 4;
    property TabPosition: TFlatTabPosition read FTabPosition write SetTabPosition default tpTop;
    property ActiveTab: Integer read FActiveTab write SetActiveTab default 0;
    property Font;
    property Color;
    property ParentColor;
    property Enabled;
    property Visible;
    property Cursor;
    property ParentShowHint;
    property ParentFont;
    property ShowHint;

    property OnEnter;
    property OnExit;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnTabChanged: TNotifyEvent read FOnTabChanged write FOnTabChanged;
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

procedure TFlatTabControl.CMDesignHitTest(var Message: TCMDesignHitTest);
begin
  case FTabPosition of
    tpTop:
      if PtInRect(Rect(ClientRect.Left, ClientRect.Top, ClientRect.Right, ClientRect.Top + FTabHeight + 1), Point(message.XPos, message.YPos)) then
        Message.Result := 1
      else
        Message.Result := 0;
    tpBottom:
      if PtInRect(Rect(ClientRect.Left, ClientRect.Bottom - FTabHeight, ClientRect.Right, ClientRect.Bottom), Point(message.XPos, message.YPos)) then
        Message.Result := 1
      else
        Message.Result := 0;
  end;
end;

constructor TFlatTabControl.Create (AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];
  SetBounds(Left, Top, 289, 193);
  FTabs := TStringList.Create;
  FTabsRect := TList.Create;
  FTabHeight := 16;
  FTabSpacing := 4;
  FTabPosition := tpTop;
  FActiveTab := 0;
  Color := $00E1EAEB;
  FBorderColor := $008396A0;
  FUnselectedColor := $00996633;
  ParentColor := true;
  ParentFont := true;
  FUseAdvColors := false;
  FAdvColorBorder := 50;
end;

destructor TFlatTabControl.Destroy;
begin
  FTabs.Free;
  FTabsRect.Free;
  inherited;
end;

procedure TFlatTabControl.CalcAdvColors;
begin
  if FUseAdvColors then
  begin
    FBorderColor := CalcAdvancedColor(Color, FBorderColor, FAdvColorBorder, darken);
  end;
end;

procedure TFlatTabControl.SetAdvColors (Index: Integer; Value: TAdvColors);
begin
  case Index of
    0: FAdvColorBorder := Value;
  end;
  CalcAdvColors;
  Invalidate;
end;

procedure TFlatTabControl.SetUseAdvColors (Value: Boolean);
begin
  if Value <> FUseAdvColors then
  begin
    FUseAdvColors := Value;
    ParentColor := Value;
    CalcAdvColors;
    Invalidate;
  end;
end;

procedure TFlatTabControl.CMSysColorChange (var Message: TMessage);
begin
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

procedure TFlatTabControl.CMParentColorChanged (var Message: TWMNoParams);
begin
  inherited;
  if FUseAdvColors then
  begin
    ParentColor := True;
    CalcAdvColors;
  end;
  Invalidate;
end;

procedure TFlatTabControl.Loaded;
begin
  inherited;
  SetTabRect;
  Invalidate;
end;

procedure TFlatTabControl.WMSize (var Message: TWMSize);
begin
  inherited;
  SetTabRect;
  Invalidate;
end;

procedure TFlatTabControl.CMEnabledChanged (var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TFlatTabControl.SetTabPosition (Value: TFlatTabPosition);
var
  I: Integer;
begin
  if Value <> FTabPosition then
  begin
    for I := 0 to ControlCount - 1 do // reposition client-controls
    begin
      if Value = tpTop then
        Controls[I].Top := Controls[I].Top + TabHeight
      else
        Controls[I].Top := Controls[I].Top - TabHeight;
    end;
    FTabPosition := Value;
    SetTabRect;
    Invalidate;
  end;
end;

procedure TFlatTabControl.SetActiveTab (Value: Integer);
begin
  if FTabs <> nil then
  begin
    if Value > (FTabs.Count - 1) then
      Value := FTabs.Count - 1
    else
      if Value < 0 then
        Value := 0;

    FActiveTab := Value;
    if Assigned(FOnTabChanged) then
      FOnTabChanged(Self);
    Invalidate;
  end
  else
    FActiveTab := 0;
  if csDesigning in ComponentState then
    if (GetParentForm(self) <> nil) and (GetParentForm(self).Designer <> nil) then
      GetParentForm(self).Designer.Modified;
end;

procedure TFlatTabControl.SetColors (Index: Integer; Value: TColor);
begin
  case Index of
    0: FBorderColor := Value;
    1: FUnselectedColor := Value;
  end;
  Invalidate;
end;

procedure TFlatTabControl.SetTabs (Value: TStrings);
var
  counter: Integer;
begin
  FTabs.Assign(Value);
  if FTabs.Count = 0 then // no tabs? then active tab = 0
    FActiveTab := 0
  else
    begin
      if (FTabs.Count - 1) < FActiveTab then // if activeTab > last-tab the activeTab = last-tab
        FActiveTab := FTabs.Count - 1;
      for counter := 0 to FTabs.Count - 1 do
        FTabs[counter] := Trim(FTabs[counter]); // delete all spaces at left and right
    end;
  SetTabRect;
  Invalidate;
end;

procedure TFlatTabControl.SetTabHeight (Value: Integer);
begin
  if Value < 0 then Value := 0; // TabHeigh can't negative
  FTabHeight := Value;
  SetTabRect;
  Invalidate;
end;

procedure TFlatTabControl.SetTabSpacing (Value: Integer);
begin
  if Value < 1 then Value := 1; // minimal tabspacing = 1 dot
  FTabSpacing := Value;
  SetTabRect;
  Invalidate;
end;

procedure TFlatTabControl.SetTabRect;
var
  TabCount: Integer;
  TabRect: ^TRect;
  position: TPoint;
  CaptionTextWidth: Integer;
  CaptionTextString: string;
begin
  // set the font and clear the tab-rect-list
  canvas.font := self.font;
  FTabsRect.Clear;

  // set left/top position for the the first tab
  case FTabPosition of
    tpTop:
      position := Point(ClientRect.left, ClientRect.top);
    tpBottom:
      position := Point(ClientRect.left, ClientRect.bottom - FTabHeight);
  end;

  for TabCount := 0 to (FTabs.Count - 1) do
  begin
    New(TabRect); // create a new Tab-Rect
    if Pos('&', FTabs[TabCount]) <> 0 then // if & in an caption
    begin
      CaptionTextString := FTabs[TabCount]; // read the caption text
      Delete(CaptionTextString, Pos('&', FTabs[TabCount]), 1); // delete the &
      CaptionTextWidth := canvas.TextWidth(CaptionTextString); // calc the caption-width withou the &
    end
    else // else calc the caption-width
      CaptionTextWidth := canvas.TextWidth(FTabs[TabCount]);
    case FTabPosition of // set the rect
      tpTop:
        TabRect^ := Rect(position.x, position.y, position.x + CaptionTextWidth + 20, FTabHeight);
      tpBottom:
        TabRect^ := Rect(position.x, position.y, position.x + CaptionTextWidth + 20, position.y + FTabHeight);
    end;
    position := Point(position.x + CaptionTextWidth + 20 + FTabSpacing, position.y); // set left/top position for next rect
    FTabsRect.Add(TabRect); // add the tab-rect to the tab-rect-list
  end;
end;

procedure TFlatTabControl.CMDialogChar (var Message: TCMDialogChar);
var
  currentTab: Integer;
begin
  with Message do
  begin
    if FTabs.Count > 0 then
    begin
      for currentTab := 0 to FTabs.Count - 1 do
      begin
        if IsAccel(CharCode, FTabs[currentTab]) then
        begin
          if (FActiveTab <> currentTab) then
          begin
            SetActiveTab(currentTab);
            SetFocus;
          end;
          Result := 1; 
          break;
        end;
      end;
    end
    else
      inherited;
  end;
end;

procedure TFlatTabControl.Paint;
var
  abc: TBitmap;
  TabCount: Integer;
  TempRect: ^TRect;
begin
  abc := TBitmap.Create; // create memory-bitmap to draw flicker-free
  try
    abc.Height := ClientRect.Bottom;
    abc.Width := ClientRect.Right;
    abc.Canvas.Font := Self.Font;

    // Clear Background
    abc.canvas.Brush.Color := TForm(Parent).Color;
    abc.canvas.FillRect(ClientRect);

    // Draw Border
    if FTabs.Count = 0 then
    begin
      abc.canvas.Brush.Color := FBorderColor;
      abc.canvas.FrameRect(ClientRect)
    end
    else
    begin
      abc.canvas.Pen.Color := FBorderColor;
      TempRect := FTabsRect.Items[FActiveTab];
      if ClientRect.left <> TempRect^.left then // if Active Tab not first tab then __|Tab|___
      begin
        case FTabPosition of
          tpTop:
          begin
            abc.Canvas.Polyline([Point(ClientRect.left, ClientRect.top + FTabHeight), Point(TempRect^.Left, ClientRect.top + FTabHeight)]);
            abc.Canvas.Polyline([Point(TempRect^.Right-1, ClientRect.top + FTabHeight), Point(ClientRect.right, ClientRect.top + FTabHeight)]);
          end;
          tpBottom:
          begin
            abc.Canvas.Polyline([Point(ClientRect.left, ClientRect.bottom - FTabHeight - 1), Point(TempRect^.Left, ClientRect.bottom - FTabHeight - 1)]);
            abc.Canvas.Polyline([Point(TempRect^.Right-1, ClientRect.bottom - FTabHeight - 1), Point(ClientRect.right, ClientRect.bottom - FTabHeight - 1)]);
          end;
        end;
      end
      else // else |Tab|___
        case FTabPosition of
          tpTop:
            abc.Canvas.Polyline([Point(TempRect^.Right-1, ClientRect.top + FTabHeight), Point(ClientRect.right, ClientRect.top + FTabHeight)]);
          tpBottom:
            abc.Canvas.Polyline([Point(TempRect^.Right-1, ClientRect.bottom - FTabHeight - 1), Point(ClientRect.right, ClientRect.bottom - FTabHeight - 1)]);
        end;
      // border of the control
      case FTabPosition of
        tpTop:
          abc.Canvas.Polyline([Point(ClientRect.left, ClientRect.top + FTabHeight), Point(ClientRect.left, ClientRect.bottom - 1), Point(ClientRect.right - 1, ClientRect.bottom - 1), Point(ClientRect.right - 1, ClientRect.top + FTabHeight)]);
        tpBottom:
          abc.Canvas.Polyline([Point(ClientRect.left, ClientRect.bottom - FTabHeight - 1), Point(ClientRect.left, ClientRect.top), Point(ClientRect.right - 1, ClientRect.top), Point(ClientRect.right - 1, ClientRect.bottom - FTabHeight - 1)]);
      end;
    end;

    case FTabPosition of
      tpTop:
        begin
          abc.canvas.brush.color := Color;
          abc.Canvas.FillRect(Rect(ClientRect.left + 1, ClientRect.top + FTabHeight + 1, ClientRect.right - 1, ClientRect.bottom - 1));
        end;
      tpBottom:
        begin
          abc.canvas.brush.color := Color;
          abc.Canvas.FillRect(Rect(ClientRect.left + 1, ClientRect.top + 1, ClientRect.right - 1, ClientRect.bottom - FTabHeight - 1));
        end;
    end;

    // Draw Tabs
    for TabCount := 0 to FTabs.Count - 1 do
    begin
      TempRect := FTabsRect.Items[TabCount];
      abc.canvas.brush.style := bsclear;
      abc.canvas.pen.color := clBlack;
      if TabCount = FActiveTab then // if Active Tab not first tab then draw border |^^^|
      begin
        abc.canvas.font.color := self.font.color;
        abc.canvas.brush.color := Color;
        abc.canvas.pen.color := FBorderColor;
        case FTabPosition of
          tpTop:
            begin
              abc.Canvas.FillRect(Rect(TempRect^.left, TempRect^.top, TempRect^.right - 1, TempRect^.bottom + 1));
              abc.Canvas.Polyline([Point(TempRect^.Left, TempRect^.Bottom), Point(TempRect^.Left, TempRect^.Top), Point(TempRect^.Right-1, TempRect^.Top), Point(TempRect^.Right-1, TempRect^.Bottom)]);
            end;
          tpBottom:
            begin
              abc.Canvas.FillRect(Rect(TempRect^.left, TempRect^.top - 1, TempRect^.right - 1, TempRect^.bottom));
              abc.Canvas.Polyline([Point(TempRect^.Left, TempRect^.top - 1), Point(TempRect^.Left, TempRect^.bottom - 1), Point(TempRect^.Right-1, TempRect^.bottom - 1), Point(TempRect^.Right-1, TempRect^.top - 1)]);
            end;
        end;
      end
      else // else only fill the tab
      begin
        abc.canvas.font.color := color;
        abc.canvas.brush.color := FUnselectedColor;
        abc.Canvas.FillRect(TempRect^);
      end;
      if (TabCount = FActiveTab) and not Enabled then
       begin
        abc.Canvas.Font.Color := FUnselectedColor;
        DrawText(abc.canvas.Handle, PChar(FTabs[TabCount]), Length(FTabs[TabCount]), TempRect^, DT_CENTER or DT_VCENTER or DT_SINGLELINE)
       end
      else
        DrawText(abc.canvas.Handle, PChar(FTabs[TabCount]), Length(FTabs[TabCount]), TempRect^, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    canvas.CopyRect(ClientRect, abc.canvas, ClientRect); // Copy bitmap to screen
  finally
    abc.free; // delete the bitmap
  end;
end;

procedure TFlatTabControl.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cursorPos: TPoint;
  currentTab: Integer;
  currentRect: ^TRect;
begin
  GetCursorPos(cursorPos);
  cursorPos := ScreenToClient(cursorPos);

  if FTabs.Count > 0 then
  begin
    for currentTab := 0 to FTabs.Count - 1 do
    begin
      currentRect := FTabsRect.Items[currentTab];
      if PtInRect(currentRect^, cursorPos) then
        if (FActiveTab <> currentTab) then // only change when new tab selected
        begin
          SetActiveTab(currentTab);
          SetFocus;
        end;
    end;
  end;
  inherited;
end;

end.

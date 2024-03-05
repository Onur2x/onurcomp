unit bilesenim;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
  Menus, Dialogs, resim,bilesenutil;

type

  TscSkinObject = class;

  TscObjectProc = procedure (SkinObject: TscSkinObject);

  TScriptKind = (
    ssNone,

    ssImage,
    ssColor,
    ssTextColor,

    ssSlideImage,
    ssSlideColor,
    ssSlideTextColor,

    ssFadeImage,
    ssFadeColor,
    ssFadeTextColor
  );

{ SkinObject }

  TscSkinObject = class(TPersistent)
  private
    FParent: TscSkinObject;
    FSource: TPersistent;
    FEngine: TComponent;

    FAlign: TscAlign;
    FVisible: TscVisibleSet;
    FVisibleNow: boolean;
    FTransparency: integer;
   FKind: TscKind;
    FTileStyle: TscTileStyle;
    FChild: TList;
    FImage: TksBmp;
    FColor: TColor;
    FText: string;
    FTextAlign: TscTextAlign;
    FTextColor: TColor;
    FTag: integer;
    FFontSize: integer;
    FFontName: string;
    FFontStyle: TFontStyles;
    FTextRect: TRect;
    FExtText: string;
    FMaskColor: TColor;
    FMaskType: TscMaskType;
    FMaskImage: TksBmp;
    FEnabled: boolean;
    FDisabledTextColor: TColor;
    FGlyph: TBitmap;
    FMakeTextAlign: boolean;

    FLeaveEvent: TStrings;
    FHoverEvent: TStrings;
    FClickEvent: TStrings;
    FUnClickEvent: TStrings;
    FKillFocusEvent: TStrings;
    FSetFocusEvent: TStrings;
    FRightClickEvent: TStrings;
    FDoubleClickEvent: TStrings;

    FWnd: HWnd;
    FName: string;
    FFirstHeight: integer;
    FFirstLeft: integer;
    FFirstWidth: integer;
    FFirstTop: integer;
    { Scripts }
    FScript: TStrings;
    FScriptKind: TScriptKind;
    FScriptTranslating: boolean;
    FScriptRunning: boolean;
    FScriptData: Pointer;
    FScriptData1: Pointer;
    FCurrentTime: integer;
    FOldTime: integer;
    FTime: integer;
    { }
    FDestroy: boolean;
    function GetChild(index: integer): TscSkinObject;
    function GetChildCount: integer;
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetBoundsRect: TRect;
    procedure SetBoundsRect(const Value: TRect);
    procedure SetVisibleNow(const Value: boolean);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetSource(const Value: TPersistent);
    procedure SetEngine(const Value: TComponent);
    procedure SetWnd(const Value: HWnd);
    { Scripts }
    procedure TranslateScript(ScriptLine: string);
    { Script kinds }
    procedure InternalScriptDraw;
    procedure InternalWaitForFinish;
    procedure SetMaskColor(const Value: TColor);
    procedure SetMaskImage(const Value: TksBmp);
    procedure SetText(const Value: string);
  protected
  public
    FTop: integer;
    FLeft: integer;
    FHeight: integer;
    FWidth: integer;
    FAlignTop: integer;
    FAlignLeft: integer;
    constructor Create; virtual;
    destructor Destroy; override;
    {}
    procedure Assign(Source: TPersistent); override;
    {}
    procedure Aligning; virtual;
    procedure Draw(Canvas: TCanvas); virtual;
    procedure DrawPart(Canvas: TCanvas; R: TRect);
    { mask }
    function GetMask: HRgn;
    { children }
    procedure AddChild(Value: TscSkinObject);
    procedure DeleteChild(index: integer);
    procedure DeleteChildObject(SkinObject: TscSkinObject);
    function FindObjectByKind(AKind: TscKind): TscSkinObject;
    function FindObjectByName(AName: string): TscSkinObject;
    function FindVisibleObjectByKind(AKind: TscKind): TscSkinObject;
    function FindObjectByPoint(Point: TPoint): TscSkinObject;
    procedure CallObject(Proc: TscObjectProc);
    { Action }
    function ObjectVisible(FormActive: boolean;
      BorderIcons: TscBorderIcons; States: TscWindowStates;
      SkinEngine: TComponent): boolean;
    { scripts }
    procedure RunScript(const Script: string);
    procedure WaitForFinish;
    procedure FadeColor(NewColor: TColor; Time: integer);
    procedure FadeTextColor(NewColor: TColor; Time: integer);
    procedure FadeImage(NewImage: TksBmp; Time: integer);
    procedure SlideImage(NewImage: TksBmp; Time: integer; Direction: TSlideDirection);
    procedure SlideColor(NewColor: TColor; Time: integer;
      Direction: TSlideDirection);
    procedure SlideTextColor(NewColor: TColor; Time: integer;
      Direction: TSlideDirection);
    procedure ProcessScript;
    { events }
    procedure OnClick(AChild: boolean);
    procedure OnUnClick(AChild: boolean);
    procedure OnRightClick(AChild: boolean);
    procedure OnDoubleClick(AChild: boolean);
    procedure OnHover(AChild: boolean);
    procedure OnLeave(AChild: boolean);
    procedure OnSetFocus(AChild: boolean);
    procedure OnKillFocus(AChild: boolean);
    { visualizations }
    property ChildCount: integer read GetChildCount;
    property Child[index: integer]: TscSkinObject read GetChild;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
    { properties }
    property Align: TscAlign read FAlign write FAlign;
    property Color: TColor read FColor write FColor;
    property Image: TksBmp read FImage write FImage;
    property Kind: TscKind read FKind write FKind;
    property Parent: TscSkinObject read FParent write FParent;
    { Font and text}
    property FontName: string read FFontName write FFontName;
    property FontSize: integer read FFontSize write FFontSize;
    property FontStyle: TFontStyles read FFontStyle write FFontStyle;
    property Text: string read FText write SetText;
    property ExtText: string read FExtText write FExtText;
    property TextAlign: TscTextAlign read FTextAlign write FTextAlign;
    property TextColor: TColor read FTextColor write FTextColor;
    property DisabledTextColor: TColor read FDisabledTextColor
      write FDisabledTextColor;
    property TextRect: TRect read FTextRect write FTextRect;
    { Glyph and layout }
    property Glyph: TBitmap read FGlyph write SetGlyph;
    { Visible and draw }
    property TileStyle: TscTileStyle read FTileStyle write FTileStyle;
    property Transparency: integer read FTransparency write FTransparency;
    property Visible: TscVisibleSet read FVisible write FVisible;
    property VisibleNow: boolean read FVisibleNow write SetVisibleNow;
    property Enabled: boolean read FEnabled write FEnabled;
    { Mask }
    property MaskType: TscMaskType read FMaskType write FMaskType;
    property MaskColor: TColor read FMaskColor write SetMaskColor;
    property MaskImage: TksBmp read FMaskImage write SetMaskImage;
    { Origin and size }
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property AlignLeft: integer read FAlignLeft write FAlignLeft;
    property AlignTop: integer read FAlignTop write FAlignTop;
    property Width: integer read FWidth write SetWidth;
    property Height: integer read FHeight write SetHeight;
    { Others }
    property Tag: integer read FTag write FTag;
    property Name: string read FName write FName;
    property Wnd: HWnd read FWnd write SetWnd;
    property Source: TPersistent read FSource write SetSource;
    property Engine: TComponent read FEngine write SetEngine;
    { Events }
    property HoverEvent: TStrings read FHoverEvent;
    property LeaveEvent: TStrings read FLeaveEvent;
    property ClickEvent: TStrings read FClickEvent;
    property UnClickEvent: TStrings read FUnClickEvent;
    property RightClickEvent: TStrings read FRightClickEvent;
    property DoubleClickEvent: TStrings read FDoubleClickEvent;
    property SetFocusEvent: TStrings read FSetFocusEvent;
    property KillFocusEvent: TStrings read FKillFocusEvent;
  end;

{ TscSkinPopupMenu }

  TscSkinPopupMenu = class(TscSkinObject)
  private
    function GetMenuItem: TscSkinObject;
  public
    property MenuItem: TscSkinObject read GetMenuItem;
  end;


var
  Objects: TList;

implementation {===============================================================}

uses skinana, sikinkaydi,sikinkodu,kontur;

const
  TimerInterval = 20;

function FormatStr(Canvas: TCanvas; S: string; Width: integer): string;
var
  i: integer;
begin
  Result := S;
  if Canvas.TextWidth(S) <= Width then Exit;
  Result := '';
  for i := 1 to Length(S) do
  begin
    if Canvas.TextWidth(Result+S[i]+'...') > Width then Break;
    Result := Result + S[i];
  end;
  Result := Result + '...'
end;

{ TscSkinObject ===============================================================}

constructor TscSkinObject.Create;
begin
  inherited Create;
  FChild := TList.Create;
  FVisible := [svAlways];
  FVisibleNow := true;
  FEnabled := true;
  FTextAlign := taCenter;
  FMaskType := smNone;
  FTransparency := 100;
  FColor:=clBlack;
  
  FFontName := 'Arial';
  FFontSize := 8;
  FFontStyle := [];

  FLeaveEvent := TStringList.Create;
  FHoverEvent := TStringList.Create;
  FClickEvent := TStringList.Create;
  FUnClickEvent := TStringList.Create;
  FKillFocusEvent := TStringList.Create;
  FSetFocusEvent := TStringList.Create;
  FRightClickEvent := TStringList.Create;
  FDoubleClickEvent := TStringList.Create;

  FScript := TStringList.Create;

  Objects.Add(Self);
end;

destructor TscSkinObject.Destroy;
var
  i: integer;
begin
  FDestroy := true;
  
  if Objects.IndexOf(Self) >= 0 then
    Objects.Delete(Objects.IndexOf(Self));

  FScript.Free;

  FLeaveEvent.Free;
  FHoverEvent.Free;
  FClickEvent.Free;
  FUnClickEvent.Free;
  FKillFocusEvent.Free;
  FSetFocusEvent.Free;
  FRightClickEvent.Free;
  FDoubleClickEvent.Free;

  if FGlyph <> nil then FGlyph.Free;
  for i := 0 to ChildCount-1 do
    Child[i].Free;
  FChild.Free;
  if FImage <> nil then FImage.FreeBmp;
  if FMaskImage <> nil then FMaskImage.FreeBmp;
  inherited Destroy;
end;

procedure TscSkinObject.Assign(Source: TPersistent);
var
  i: integer;
  SkinObject: TscSkinObject;
begin
  if Source is TscSkinObject then
  begin
    FParent := (Source as TscSkinObject).FParent;
    FSource := (Source as TscSkinObject).FSource;

    FName := (Source as TscSkinObject).FName;

    FAlign := (Source as TscSkinObject).FAlign;

    FVisible := (Source as TscSkinObject).FVisible;
    FEnabled := (Source as TscSkinObject).FEnabled;
    FVisibleNow := (Source as TscSkinObject).FVisibleNow;

    FTransparency := (Source as TscSkinObject).FTransparency;

    FKind := (Source as TscSkinObject).FKind;
    FTileStyle := (Source as TscSkinObject).FTileStyle;
    if (Source as TscSkinObject).FImage <> nil then
    begin
      if FImage <> nil then FImage.FreeBmp;
      FImage := (Source as TscSkinObject).FImage.GetCopy;
    end;
    FColor := (Source as TscSkinObject).FColor;

    FText := (Source as TscSkinObject).FText;
    FTextAlign := (Source as TscSkinObject).FTextAlign;
    FTextColor := (Source as TscSkinObject).FTextColor;
    FDisabledTextColor := (Source as TscSkinObject).FDisabledTextColor;

    FFontName := (Source as TscSkinObject).FFontName;
    FFontSize := (Source as TscSkinObject).FFontSize;
    FFontStyle := (Source as TscSkinObject).FFontStyle;

    if (Source as TscSkinObject).FMaskImage <> nil then
    begin
      if FMaskImage <> nil then
        FMaskImage.FreeBmp;
      FMaskImage := (Source as TscSkinObject).FMaskImage.GetCopy;
    end;
    FMaskColor := (Source as TscSkinObject).FMaskColor;
    FMaskType := (Source as TscSkinObject).FMaskType;

    FAlignLeft := (Source as TscSkinObject).FAlignLeft;
    FAlignTop := (Source as TscSkinObject).FAlignTop;
    BoundsRect := (Source as TscSkinObject).BoundsRect;

    FLeaveEvent.Assign((Source as TscSkinObject).FLeaveEvent);
    FHoverEvent.Assign((Source as TscSkinObject).FHoverEvent);
    FClickEvent.Assign((Source as TscSkinObject).FClickEvent);
    FRightClickEvent.Assign((Source as TscSkinObject).FRightClickEvent);
    FDoubleClickEvent.Assign((Source as TscSkinObject).FDoubleClickEvent);
    FUnClickEvent.Assign((Source as TscSkinObject).FUnClickEvent);
    FSetFocusEvent.Assign((Source as TscSkinObject).FSetFocusEvent);
    FKillFocusEvent.Assign((Source as TscSkinObject).FKillFocusEvent);

    { Delete self children }
    if ChildCount > 0 then
    begin
      for i := 0 to FChild.Count-1 do
        TscSkinObject(Child[i]).Free;
      FChild.Clear;
    end;
    { Copy chilren }
    if (Source as TscSkinObject).FChild.Count > 0 then
      for i := 0 to (Source as TscSkinObject).FChild.Count-1 do
      begin
        SkinObject := TscSkinObject.Create;
        SkinObject.Assign((Source as TscSkinObject).Child[i]);
        AddChild(SkinObject);
      end;
  end
  else
    inherited;
end;

procedure TscSkinObject.Aligning;
var
  i: integer;
  R: TRect;
begin
  R := BoundsRect;
  // most top align
  for i := 0 to FChild.Count-1 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saMostTop) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Top, R.Right, R.Top+Height);
      Inc(R.Top, Height);
    end;
  // most bottom align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saMostBottom) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Bottom-Height, R.Right, R.Bottom);
      Dec(R.Bottom, Height);
    end;
  // most left align
  for i := 0 to FChild.Count-1 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saMostLeft) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Top, R.Left+Width, R.Bottom);
      Inc(R.Left, Width);
    end;
  // most right align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saMostRight) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Right-Width, R.Top, R.Right, R.Bottom);
      Dec(R.Right, Width);
    end;
  // top align
  for i := 0 to FChild.Count-1 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saTop) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Top, R.Right, R.Top+Height);
      Inc(R.Top, Height);
    end;
  // bottom align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saBottom) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Bottom-Height, R.Right, R.Bottom);
      Dec(R.Bottom, Height);
    end;
  // left align
  for i := 0 to FChild.Count-1 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saLeft) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left, R.Top, R.Left+Width, R.Bottom);
      Inc(R.Left, Width);
    end;
  // right align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saRight) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Right-Width, R.Top, R.Right, R.Bottom);
      Dec(R.Right, Width);
    end;
  // text align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saText) then
    with Child[i] do
    begin
      if not FMakeTextAlign then
      begin
        FMakeTextAlign := true;
        try
          Self.Width := R.left + (Self.FWidth - R.Right) + Width;
        finally
          FMakeTextAlign := false;
        end;
      end
      else
      begin
        BoundsRect := Rect(R.Left, R.Top, R.Right, R.Bottom);
      end;
    end;
  // center align
  for i := FChild.Count-1 Downto 0 do
    if (Child[i].FVisibleNow) and (Child[i].Align = saCenter) then
    with Child[i] do
    begin
      BoundsRect := Rect(R.Left + (R.Right-R.left-Width) div 2, Self.FTop,
        R.Left + (R.Right-R.left-Width) div 2 + FWidth, Self.FTop + Self.FHeight);
    end;
  // client align
  for i := 0 to FChild.Count-1 do
    if Child[i].FVisibleNow then
    if Child[i].Align = saClient then
      Child[i].BoundsRect := Rect(R.Left, R.Top, R.Right, R.Bottom);
  // other align
  for i := 0 to FChild.Count-1 do
    if Child[i].FVisibleNow then
    begin
      if Child[i].Align = saTopRight then
        Child[i].FLeft := FWidth - Child[i].FAlignLeft; 
      if Child[i].Align = saBottomLeft then
        Child[i].FTop := FHeight - Child[i].FAlignTop;
      if Child[i].Align = saBottomRight then
      begin
        Child[i].FLeft := FWidth - Child[i].FAlignLeft;
        Child[i].FTop := FHeight - Child[i].FAlignTop;
      end;
    end;
end;

procedure TscSkinObject.Draw(Canvas: TCanvas);
var
  i: integer;
  Flags: integer;
  R: TRect;
  S: string;
begin
  if not VisibleNow then Exit;

  if (FImage <> nil) and (FImage.Width > 0) then
  begin
    if (FMaskColor = 0) or (FKind in [skLeft, skTop, skRight, skBottom, skTopLeft, skTopRight, skBottomLeft, skBottomRight]) then
      case FTileStyle of
        tsTile: FImage.TileDraw(Canvas.Handle, FLeft, FTop, FWidth, FHeight);
        tsStretch: FImage.Stretch(Canvas.Handle, FLeft, FTop, FWidth, FHeight);
        tsCenter: FImage.Draw(Canvas.Handle, FLeft + (FWidth - FImage.Width) div 2,
          FTop + (FHeight - FImage.Height) div 2);
      end
    else
      case FTileStyle of
        tsTile: FImage.TileDrawTransparent(Canvas, FLeft, FTop, FWidth, FHeight, FMaskColor);
        tsStretch: FImage.StretchTransparent(Canvas, FLeft, FTop, FWidth, FHeight, FMaskColor);
        tsCenter: FImage.DrawTransparent(Canvas, FLeft + (FWidth - FImage.Width) div 2,
          FTop + (FHeight - FImage.Height) div 2, FMaskColor);
      end
  end
  else
  if (FTransparency = 100) then
  begin
    Canvas.Brush.Color := FColor;
    Canvas.Pen.Style := psClear;
    Canvas.Rectangle(FLeft, FTop, FLeft+FWidth+1, FTop+FHeight+1)
  end;
  { Draw children }
  if FChild.Count > 0 then
    for i := 0 to FChild.Count-1 do
      Child[i].Draw(Canvas);
  { Draw text }
  if FText <> '' then
   with Canvas do
   begin
     Brush.Style := bsClear;
     case FTextAlign of
       taTopLeft: Flags := DT_SINGLELINE or DT_TOP or DT_LEFT;
       taTopCenter: Flags := DT_SINGLELINE or DT_TOP or DT_CENTER;
       taTopRight: Flags := DT_SINGLELINE or DT_TOP or DT_RIGHT;
       taLeft: Flags := DT_SINGLELINE or DT_VCENTER or DT_LEFT;
       taCenter: Flags := DT_SINGLELINE or DT_VCENTER or DT_CENTER;
       taRight: Flags := DT_SINGLELINE or DT_VCENTER or DT_RIGHT;
       taBottomLeft: Flags := DT_SINGLELINE or DT_BOTTOM or DT_LEFT;
       taBottomCenter: Flags := DT_SINGLELINE or DT_BOTTOM or DT_CENTER;
       taBottomRight: Flags := DT_SINGLELINE or DT_BOTTOM or DT_RIGHT;
     else
       Flags := DT_SINGLELINE or DT_CENTER or DT_VCENTER;
     end;
     R := BoundsRect;
     R.left := R.left + FTextRect.left;
     R.top := R.top + FTextRect.top;
     R.right := R.right - FTextRect.right;
     R.bottom := R.bottom - FTextRect.bottom;
     if FKind = skTitle then
       S := FormatStr(Canvas, FText, (R.right-FTextRect.right)-(R.left+FTextRect.left))
     else
       S := FText;
     if FText <> '-' then
     begin
       if FEnabled then
         Font.Color := FTextColor
       else
         Font.Color := FDisabledTextColor;
       Font.Name := FFontName;
       Font.Size := FFontSize;
       Font.Style := FFontStyle;
       DrawText(Canvas.Handle, PChar(S), Length(S), R, Flags);
       if FExtText <> '' then
       begin
         // Draw FExtText
         case FTextAlign of
           taTopLeft: Flags := DT_SINGLELINE or DT_TOP or DT_RIGHT;
           taTopCenter: Flags := DT_SINGLELINE or DT_TOP or DT_CENTER;
           taTopRight: Flags := DT_SINGLELINE or DT_TOP or DT_LEFT;
           taLeft: Flags := DT_SINGLELINE or DT_VCENTER or DT_RIGHT;
           taCenter: Flags := DT_SINGLELINE or DT_VCENTER or DT_CENTER;
           taRight: Flags := DT_SINGLELINE or DT_VCENTER or DT_LEFT;
           taBottomLeft: Flags := DT_SINGLELINE or DT_BOTTOM or DT_RIGHT;
           taBottomCenter: Flags := DT_SINGLELINE or DT_BOTTOM or DT_CENTER;
           taBottomRight: Flags := DT_SINGLELINE or DT_BOTTOM or DT_LEFT;
         else
           Flags := DT_SINGLELINE or DT_CENTER or DT_VCENTER;
         end;
         DrawText(Canvas.Handle, PChar(FExtText), Length(FExtText), R, Flags)
       end;
     end
     else
     begin
       Pen.Color := FTextColor;
       Pen.Style := psSolid;
       Rectangle(4, FTop + FHeight div 2-1, FWidth-5,
         FTop + FHeight div 2);
     end;
  end;
  if FGlyph <> nil then
  begin
    FGlyph.Transparent := true;
    Canvas.Draw(FLeft + (FWidth - FGlyph.Width) div 2,
      FTop + (FHeight - FGlyph.Height) div 2, FGlyph);
  end;
end;

procedure TscSkinObject.DrawPart(Canvas: TCanvas; R: TRect);
// R - part of image in local origin
var
  SaveIndex: integer;
begin
  SaveIndex := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, R.left, R.top, R.right, R.bottom);
    Draw(Canvas);
  finally
    RestoreDC(Canvas.Handle, SaveIndex);
  end;
end;

function TscSkinObject.GetChild(index: integer): TscSkinObject;
begin
  Result := TscSkinObject(FChild[index]);
end;

function TscSkinObject.GetChildCount: integer;
begin
  Result := FChild.Count;
end;

procedure TscSkinObject.SetText(const Value: string);
var
  Canvas: TBitmap;
begin
  FText := Value;
  if (FAlign = saText) and (FParent <> nil) then
  begin
    Canvas := TBitmap.Create;
    try
      with Canvas.Canvas do
      begin
        Font.Name := FFontName;
        Font.Size := FFontSize;
        Font.Style := FFontStyle;
        FWidth := TextWidth(FText);
        if (FAlign = saText) and (FParent <> nil) then
          FParent.Aligning;
      end;
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TscSkinObject.SetHeight(const Value: integer);
begin
  FHeight := Value;
  Aligning;
end;

procedure TscSkinObject.SetWidth(const Value: integer);
begin
  FWidth := Value;
  Aligning;
end;

function TscSkinObject.GetBoundsRect: TRect;
begin
  Result := Rect(FLeft, FTop, FLeft+FWidth, FTop+FHeight);
end;

procedure TscSkinObject.SetBoundsRect(const Value: TRect);
begin
  FLeft := Value.Left;
  FTop := Value.Top;
  FWidth := Value.Right - Value.Left;
  FHeight := Value.Bottom - Value.Top;
  if FWidth < 0 then FWidth := 0;
  if FHeight < 0 then FHeight := 0;
  Aligning;
end;

procedure TscSkinObject.AddChild(Value: TscSkinObject);
begin
  Value.FParent := Self;
  FChild.Add(Value);
end;

procedure TscSkinObject.DeleteChild(index: integer);
begin
  FChild.Delete(index);
end;

procedure TscSkinObject.DeleteChildObject(SkinObject: TscSkinObject);
var
  i: integer;
begin
  i := FChild.IndexOf(SkinObject);
  if i >= 0 then
    FChild.Delete(i);
end;

function TscSkinObject.FindObjectByName(AName: string): TscSkinObject;
var
  i: integer;
begin
  Result := nil;
  if LowerCase(FName) = LowerCase(AName) then
  begin
    Result := Self;
    Exit;
  end;
  if ChildCount = 0 then Exit;
  for i := 0 to ChildCount-1 do
  begin
    Result := Child[i].FindObjectByName(AName);
    if Result <> nil then
      Break;
  end;
end;

function TscSkinObject.FindObjectByKind(AKind: TscKind): TscSkinObject;
var
  i: integer;
begin
  Result := nil;
  if FKind = AKind then
  begin
    Result := Self;
    Exit;
  end;
  if ChildCount = 0 then Exit;
  for i := 0 to ChildCount-1 do
  begin
    Result := Child[i].FindObjectByKind(AKind);
    if Result <> nil then
      Break;
  end;
end;

function TscSkinObject.FindVisibleObjectByKind(AKind: TscKind): TscSkinObject;
var
  i: integer;
begin
  Result := nil;
  if (FKind = AKind) and (FVisibleNow) then
  begin
    Result := Self;
    Exit;
  end;
  if ChildCount = 0 then Exit;
  for i := 0 to ChildCount-1 do
  begin
    Result := Child[i].FindVisibleObjectByKind(AKind);
    if Result <> nil then
      Break;
  end;
end;

function TscSkinObject.FindObjectByPoint(Point: TPoint): TscSkinObject;
var
  i: integer;
  SkinObject: TscSkinObject;
begin
  Result := nil;
  if not FVisibleNow then
    Exit;
  if not PtInRect(BoundsRect, Point) then
    Exit;
  if ChildCount = 0 then
  begin
    if PtInRect(BoundsRect, Point) then
      Result := Self;
  end
  else
  begin
    for i := 0 to ChildCount-1 do
    begin
      SkinObject := Child[i].FindObjectByPoint(Point);
      if SkinObject <> nil then
      begin
        Result := SkinObject;
      end;
    end;
    if Result = nil then
      Result := Self;
  end;
end;

procedure TscSkinObject.CallObject(Proc: TscObjectProc);
var
  i: integer;
begin
  Proc(Self);
  if ChildCount > 0 then
  for i := 0 to ChildCount-1 do
    Child[i].CallObject(Proc);
end;

{ Mask and region }

function TscSkinObject.GetMask: HRgn;
var
  i: integer;
  ChildMask: HRgn;
  AllChildMask: HRgn;
  TransImage, TempImage: TksBmp;
  TransColor: TColor;
begin
  // Add child mask
  if ChildCount > 0 then
  begin
    Result := CreateRectRgn(FLeft, FTop, FLeft+FWidth, FTop+FHeight);
    AllChildMask := 0;
    try
      AllChildMask := CreateRectRgn(0, 0, 0, 0);
      for i := 0 to ChildCount-1 do
      begin
        if not Child[i].VisibleNow then Continue;
        ChildMask := Child[i].GetMask;
        try
          CombineRgn(AllChildMask, AllChildMask, ChildMask, RGN_OR);
        finally
          DeleteObject(ChildMask);
        end;
      end;
      CombineRgn(Result, Result, AllChildMask, RGN_AND);
    finally
      DeleteObject(AllChildMask);
    end;
  end
  else
  if FMaskType <> smNone then
  begin
    case FMaskType of
      smColor:
      begin
        TransImage := FImage;
        TransColor := FMaskColor;
      end;
      smImage:
      begin
        TransImage := FMaskImage;
        TransColor := clWhite;
      end;
    else
      TransImage := FImage;
      TransColor := FMaskColor;
    end;
    // Make mask
    TempImage := TksBmp.Create(Width, Height);
    try
      case FTileStyle of
        tsTile: TransImage.TileDraw(TempImage.hDC, 0, 0, FWidth, FHeight);
        tsStretch: TransImage.Stretch(TempImage.hDC, 0, 0, FWidth, FHeight);
      end;
      Result := CreateOffsetRgnFromBitmap(TempImage, FLeft, FTop, TransColor);
    finally
      TempImage.FreeBmp;
    end;
  end
  else
    Result := CreateRectRgn(FLeft, FTop, FLeft+FWidth, FTop+FHeight);
end;

procedure TscSkinObject.SetVisibleNow(const Value: boolean);
var
  i: integer;
begin
  FVisibleNow := Value;
  if ChildCount > 0 then
    for i := 0 to ChildCount-1 do
      Child[i].VisibleNow := Value;
end;

procedure TscSkinObject.SetMaskColor(const Value: TColor);
begin
  FMaskColor := Value;
  if FMaskColor <> 0 then
    FMaskType := smColor
  else
    FMaskType := smNone;
end;

procedure TscSkinObject.SetMaskImage(const Value: TksBmp);
begin
  FMaskImage := Value;
  if FMaskImage <> nil then
    FMaskType := smImage
  else
    FMaskType := smNone;
end;

procedure TscSkinObject.SetGlyph(const Value: TBitmap);
begin
  if FGlyph <> nil then
    FGlyph.Free;
  FGlyph := Value;
end;

procedure TscSkinObject.SetEngine(const Value: TComponent);
var
  i: integer;
begin
  FEngine := Value;
  if ChildCount > 0 then
    for i := 0 to ChildCount-1 do
      Child[i].Engine := Value;
end;

procedure TscSkinObject.SetSource(const Value: TPersistent);
var
  i: integer;
begin
  FSource := Value;
  if ChildCount > 0 then
    for i := 0 to ChildCount-1 do
      Child[i].Source := Value;
end;

procedure TscSkinObject.SetWnd(const Value: HWnd);
var
  i: integer;
begin
  FWnd := Value;
  if ChildCount > 0 then
    for i := 0 to ChildCount-1 do
      Child[i].Wnd := Value;
end;

{ Get Visible }

function TscSkinObject.ObjectVisible(FormActive: boolean; BorderIcons: TscBorderIcons;
  States: TscWindowStates; SkinEngine: TComponent): boolean;
var
  Results: array [0..30] of boolean;
  Pos: integer;
  i: integer;
 procedure AddTrue;
 begin
   Results[Pos] := true;
   Inc(Pos);
 end;
 procedure AddFalse;
 begin
   Results[Pos] := false;
   Inc(Pos)
 end;
begin
  Pos := 0;
  FillChar(Results, SizeOf(Results), 1);

  if svNever in Visible then
    AddFalse;
  if svAlways in Visible then
    AddTrue;

   { Window states ====================================}

  if svActive in Visible then
    if FormActive then
      AddTrue
    else
      AddFalse;

  if svInactive in Visible then
    if not FormActive then
      AddTrue
    else
      AddFalse;

  if (svMaximized in Visible) then
    if wsMaximized in States then
      AddTrue
    else
      AddFalse;

  if (svNoMaximized in Visible) then
    if not (wsMaximized in States) then
      AddTrue
    else
      AddFalse;

  if (svRollup in Visible) then
    if wsRollup in States then
      AddTrue
    else
      AddFalse;

  if (svNoRollup in Visible) then
    if not (wsRollup in States) then
      AddTrue
    else
      AddFalse;

  if (svStayOnTop in Visible) then
    if (wsStayOnTop in States) then
      AddTrue
    else
      AddFalse;

  if (svNoStayOnTop in Visible) then
    if not (wsStayOnTop in States) then
      AddTrue
    else
      AddFalse;

  { Window states ====================================}

  if (svHelp in Visible) then
    if sbHelp in BorderIcons then
      AddTrue
    else
      AddFalse;

  if (svNoHelp in Visible) then
    if not (sbHelp in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svMax in Visible) then
    if (sbMaximize in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svNoMax in Visible) then
    if not (sbMaximize in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svMin in Visible) then
    if (sbMinimize in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svNoMin in Visible) then
    if not (sbMinimize in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svMinMax in Visible) and
     ((sbMinimize in BorderIcons) or (sbMaximize in BorderIcons)) then
    AddTrue;
    
  if (svNoMinMax in Visible) and
     ((sbMinimize in BorderIcons) or (sbMaximize in BorderIcons)) then
    AddFalse;

  if (svSizeable in Visible) then
    if (wsSizeable in States) then
      AddTrue
    else
      AddFalse;

  if (svNoSizeable in Visible) then
    if not (wsSizeable in States) then
      AddTrue
    else
      AddFalse;

  if (svSysMenu in Visible) then
    if (sbSystemMenu in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svNoSysMenu in Visible) then
    if not (sbSystemMenu in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svClose in Visible) then
    if (sbClose in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svNoClose in Visible) then
    if not (sbClose in BorderIcons) then
      AddTrue
    else
      AddFalse;

  if (svMenuBar in Visible) then
    if ((SkinEngine as TscSkinEngine).MainMenuShow) and ((SkinEngine as TscSkinEngine).MainMenu <> nil) then
      AddTrue
    else
      AddFalse;

  if (svNoMenuBar in Visible) then
    if not ((SkinEngine as TscSkinEngine).MainMenuShow) or ((SkinEngine as TscSkinEngine).MainMenu = nil) then
      AddTrue
    else
      AddFalse;

  Result := false;
  for i := 0 to Pos do
    if not Results[i] then Exit;
  Result := true;
end;

{ Run event script }

procedure TscSkinObject.RunScript(const Script: string);
begin
  if not FVisibleNow then Exit; 
  if Script = '' then Exit;
  if FDestroy then Exit;
  { Finish old }
  if FScriptRunning then
  begin
    FScriptTranslating := true;
    FScriptRunning := false;
    ProcessScript;
  end;
  if FScriptTranslating then
  begin
    FScriptRunning := false;
    ProcessScript;
  end;
  if FDestroy then Exit;
  { Prepare to start new script }
  FScript.Text := Script;
  { Translate script }
  FScriptKind := ssNone;
  FScriptTranslating := true;
  { Start script }
  TranslateScript(FScript[0]);
end;

procedure TscSkinObject.TranslateScript(ScriptLine: string);
var
  Word, S, Operator: string;
  NewColor: TColor;
  Source, NewImage: TksBmp;
  Direction: TSlideDirection;
  Time: integer;
begin
  FScriptData := nil;
  FScriptData1 := nil;
  FScriptKind := ssNone;
  FScriptRunning := true;
  FTime := 0;
  FCurrentTime := 0;
  { Translate scripts }
  S := ScriptLine;
  Operator := LowerCase(GetToken(S));
  try
    if (Operator = 'changeimage') and (FSource <> nil) then
    begin
      Source := GetImage(TscSkinSource(FSource).Images, GetToken(S));
      FTime := 1;
      FScriptData := ExtractImage(Source, S);
      FScriptKind := ssImage;
    end;

    if (Operator = 'changecolor') and (FSource <> nil) then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      FTime := 1;
      FScriptData := Pointer(NewColor);
      FScriptKind := ssColor;
    end;

    if (Operator = 'changetextcolor') and (FSource <> nil) then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      FTime := 1;
      FScriptData := Pointer(NewColor);
      FScriptKind := ssTextColor;
    end;

    if (Operator = 'fadeimage') and (FSource <> nil) then
    begin
      Source := GetImage(TscSkinSource(FSource).Images, GetToken(S));
      NewImage := ExtractImage(Source, S);
      GetToken(S); GetToken(S); GetToken(S); GetToken(S);
      FadeImage(NewImage, StrToInt(GetToken(S)));
    end;

    if Operator = 'fadecolor' then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      FadeColor(NewColor, StrToInt(GetToken(S)));
    end;

    if Operator = 'fadetextcolor' then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      FadeTextColor(NewColor, StrToInt(GetToken(S)));
    end;

    if (Operator = 'slideimage') and (FSource <> nil) then
    begin
      Source := GetImage(TscSkinSource(FSource).Images, GetToken(S));
      NewImage := ExtractImage(Source, S);
      GetToken(S); GetToken(S); GetToken(S); GetToken(S);
      Time := StrToInt(GetToken(S));
      Direction := sdLeftToRight;
      Word := GetToken(S);
      if LowerCase(Word) = 'leftotright' then
        Direction := sdLeftToRight;
      if LowerCase(Word) = 'righttoleft' then
        Direction := sdRightToLeft;
      if LowerCase(Word) = 'toptobottom' then
        Direction := sdTopToBottom;
      if LowerCase(Word) = 'bottomtotop' then
        Direction := sdBottomToTop;
      SlideImage(NewImage, Time, Direction);
    end;

    if Operator = 'slidecolor' then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      Time := StrToInt(GetToken(S));
      Direction := sdLeftToRight;
      Word := GetToken(S);
      if LowerCase(Word) = 'leftotright' then
        Direction := sdLeftToRight;
      if LowerCase(Word) = 'righttoleft' then
        Direction := sdRightToLeft;
      if LowerCase(Word) = 'toptobottom' then
        Direction := sdTopToBottom;
      if LowerCase(Word) = 'bottomtotop' then
        Direction := sdBottomToTop;
      SlideColor(NewColor, Time, Direction);
    end;

    if Operator = 'slidetextcolor' then
    begin
      TAColor(NewColor).R := StrToInt(GetToken(S));
      TAColor(NewColor).G := StrToInt(GetToken(S));
      TAColor(NewColor).B := StrToInt(GetToken(S));
      Time := StrToInt(GetToken(S));
      Direction := sdLeftToRight;
      Word := GetToken(S);
      if LowerCase(Word) = 'leftotright' then
        Direction := sdLeftToRight;
      if LowerCase(Word) = 'righttoleft' then
        Direction := sdRightToLeft;
      if LowerCase(Word) = 'toptobottom' then
        Direction := sdTopToBottom;
      if LowerCase(Word) = 'bottomtotop' then
        Direction := sdBottomToTop;
      SlideTextColor(NewColor, Time, Direction);
    end;

    if Operator = 'close' then
      PostMessage(FWnd, WM_SYSCOMMAND, SC_CLOSE, 0);

    if Operator = 'min' then
      if FEngine <> nil then
        with (FEngine as TscSkinEngine) do
        begin
          if sbMinimize in BorderIcons then
            PostMessage(FWnd, WM_SYSCOMMAND, SC_MINIMIZE, 0);
        end;

    if Operator = 'max' then
    begin
      if FEngine <> nil then
      with (FEngine as TscSkinEngine) do
      begin
        if not (wsRollup in WindowStates) then
          if sbMaximize in BorderIcons then
            if not isZoomed(FWnd) then
              PostMessage(FWnd, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
            else
              PostMessage(FWnd, WM_SYSCOMMAND, SC_RESTORE, 0);
      end;
    end;

    if Operator = 'help' then
      PostMessage(FWnd, WM_SYSCOMMAND, SC_CONTEXTHELP, 0);

    if Operator = 'rollup' then
      PostMessage(FWnd, WM_ROLLUP, 0, 0);

    if Operator = 'stayontop' then
      PostMessage(FWnd, WM_STAYONTOP, 0, 0);

    if Operator = 'sysmenu' then
      PostMessage(FWnd, WM_TRACKSYSTEMMENU, 0, 0);

    if Operator = 'move' then
      PostMessage(FWnd, WM_SYSCOMMAND, SC_MOVE, 0);

    if Operator = 'size' then
      PostMessage(FWnd, WM_SYSCOMMAND, SC_SIZE, 0);

    if (Operator = 'action') and (FEngine <> nil) then
    with (FEngine as TscSkinEngine) do
    begin
      if Assigned(FOnCustomAction) then
        FOnCustomAction(FEngine, StrToInt(GetToken(S)));
    end;
  except
    MessageDlg('Object '+Name+': error in line "'+ScriptLine+'"', mtError, [mbOk], 0);
  end;
end;

procedure TscSkinObject.ProcessScript;
var
  Counter: TksCounter;
begin
  { if not Active then exit }
  if (not FScriptTranslating) and (not FScriptRunning) then Exit;

  if FScriptRunning then
  begin
    { start counter }
    StartCount(Counter);
    try
      { do script }
      InternalScriptDraw;
      { }
      if FCurrentTime >= FTime then
        FScriptRunning := false;
    finally
      FOldTime := FCurrentTime;
      FCurrentTime := FCurrentTime + Round(StopCount(Counter)*1000) + TimerInterval;
      if FCurrentTime > FTime Then
        FCurrentTime := FTime;
    end;
  end;

  { else process }
  if not FScriptRunning then
  begin
    { Change property }
    case FScriptKind of
      ssImage, ssFadeImage, ssSlideImage:
      begin
        if FImage <> nil then FImage.FreeBmp;
        FImage := FScriptData;
      end;
      ssColor, ssFadeColor, ssSlideColor:
        FColor := TColor(FScriptData);
      ssTextColor, ssFadeTextColor, ssSlideTextColor:
        FTextColor := TColor(FScriptData);
    end;
    InternalScriptDraw;
    FScriptKind := ssNone;
    if FScript.Count > 1 then
    begin
      { Process next line }
      FTime := 0;
      FOldTime := 0;
      FScript.Delete(0);
      TranslateScript(FScript[0]);
    end
    else
    begin
      FScriptTranslating := false;
    end;
    Exit;
  end;
end;

{ Do scripts }

procedure TscSkinObject.WaitForFinish;
begin
  while FScriptRunning do
  begin
    ProcessScript;
    Sleep(10);
  end;
end;

procedure TscSkinObject.InternalWaitForFinish;
begin
  while FScriptRunning do
  begin
    ProcessScript;
    Sleep(10);
  end;
end;

procedure TscSkinObject.InternalScriptDraw;
var
  FDC: HDC;
  Canvas: TCanvas;
  Cash: TBitmap;
  Result, Source, Dest: TksBmp;
  { Saving data }
  FOldTop, FOldLeft: integer;
  OldImage: TksBmp;
  OldColor: TColor;
  OldTextColor: TColor;
begin
  if FWnd = 0 then Exit;
  if FTime-FOldTime = 0 then Exit;
  if (FWidth = 0) or (FHeight = 0) then Exit;
  { Get DC }
  FDC := GetWindowDC(FWnd);
  if FDC = 0 then
  begin
    FScriptRunning := false;
    Exit;
  end;

  try
    { prepare device context }
    IntersectClipRect(FDC, left, top, left + Width, top + Height);
    { draw }
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := FDC;
      Cash := TBitmap.Create;
      try
        Cash.Width := Width;
        Cash.Height := Height;
        if FMaskColor <> 0 then
        begin
          Cash.Canvas.Brush.Color := FMaskColor;
          Cash.Canvas.Pen.Style := psClear;
          Cash.Canvas.Rectangle(0, 0, Width+1, Height+1);
        end;
        { Save properties }
        OldImage := FImage;
        OldColor := FColor;
        OldTextColor := FTextColor;
        FOldTop := FTop;
        FOldLeft := FLeft;
        { Receive source image }
        FTop := 0;
        FLeft := 0;
        Draw(Cash.Canvas);
        FTop := FOldTop;
        FLeft := FOldLeft;

        Source := TksBmp.CreateFromHandle(Cash.Handle);
        try
          { Change properties }
          case FScriptKind of
            ssImage, ssFadeImage, ssSlideImage: FImage := TksBmp(FScriptData);
            ssColor, ssFadeColor, ssSlideColor: FColor := TColor(FScriptData);
            ssTextColor, ssFadeTextColor, ssSlideTextColor: FTextColor := TColor(FScriptData);
          end;
          { Receive destination }
          FTop := 0;
          FLeft := 0;
          Draw(Cash.Canvas);
          FTop := FOldTop;
          FLeft := FOldLeft;

          Dest := TksBmp.CreateFromHandle(Cash.Handle);
          Result := TksBmp.CreateCopy(Dest);
          try
            { Receive result image }
            case FScriptKind of
              ssSlideImage, ssSlideColor, ssSlideTextColor: // Slide
                Slide(Result, Source, Dest, FCurrentTime/FTime);
//                  TSlideDirection(FScriptData1));
              ssFadeImage, ssFadeColor, ssFadeTextColor: // Fade
                Fade(Result, Source, Dest, FCurrentTime/FTime);
            end;
            { Draw Result to canvas }
            if MaskColor = 0 then
              Result.Draw(FDC, Left, Top)
            else
              Result.DrawTransparent(Canvas, Left, Top, MaskColor);
          finally
            Result.Free;
            Dest.Free;
          end;
        finally
          Source.Free;
        end;
      finally
        Cash.Free;
        { Restore properties }
        FImage := OldImage;
        FColor := OldColor;
        FTextColor := OldTextColor;
      end;
    finally
      Canvas.Handle := 0;
      Canvas.Free;
    end;
  finally
    { Release device context }
    ReleaseDC(FWnd, FDC);
  end;
end;

{ FadeImage }

procedure TscSkinObject.FadeImage(NewImage: TksBmp; Time: integer);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssFadeImage;
  FScriptData := NewImage;
end;

{ FadeColor }

procedure TscSkinObject.FadeColor(NewColor: TColor; Time: integer);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssFadeColor;
  FScriptData := Pointer(ColorToRGB(NewColor));
end;

{ FadeTextColor }

procedure TscSkinObject.FadeTextColor(NewColor: TColor; Time: integer);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssFadeTextColor;
  FScriptData := Pointer(ColorToRGB(NewColor));
end;

{ Slideimage }

procedure TscSkinObject.SlideImage(NewImage: TksBmp; Time: integer; Direction: TSlideDirection);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssSlideImage;
  FScriptData := NewImage;
  FScriptData1 := Pointer(Direction);
end;

{ SlideColor }

procedure TscSkinObject.SlideColor(NewColor: TColor; Time: integer; Direction: TSlideDirection);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssSlideColor;
  FScriptData := Pointer(ColorToRGB(NewColor));
  FScriptData1 := Pointer(Direction);
end;

{ SlideTextColor }

procedure TscSkinObject.SlideTextColor(NewColor: TColor; Time: integer; Direction: TSlideDirection);
begin
  if not VisibleNow then Exit;
  { Wait, if another script running}
  InternalWaitForFinish;

  FTime := Time;
  FCurrentTime := 0;
  FOldTime := 0;

  FScriptRunning := true;
  FScriptKind := ssSlideTextColor;
  FScriptData := Pointer(ColorToRGB(NewColor));
  FScriptData1 := Pointer(Direction);
end;

{ Events }

procedure TscSkinObject.OnClick(AChild: boolean);
var
  i: integer;
begin
  RunScript(FClickEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnClick(AChild);
end;

procedure TscSkinObject.OnDoubleClick(AChild: boolean);
var
  i: integer;
begin
  RunScript(FDoubleClickEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnDoubleClick(AChild);
end;

procedure TscSkinObject.OnHover(AChild: boolean);
var
  i: integer;
begin
  RunScript(FHoverEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnHover(AChild);
end;

procedure TscSkinObject.OnKillFocus(AChild: boolean);
var
  i: integer;
begin
  RunScript(FKillFocusEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnKillFocus(AChild);
end;

procedure TscSkinObject.OnLeave(AChild: boolean);
var
  i: integer;
begin
  RunScript(FLeaveEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnLeave(AChild);
end;

procedure TscSkinObject.OnRightClick(AChild: boolean);
var
  i: integer;
begin
  RunScript(FRightClickEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnRightClick(AChild);
end;

procedure TscSkinObject.OnSetFocus(AChild: boolean);
var
  i: integer;
begin
  RunScript(FSetFocusEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnSetFocus(AChild);
end;

procedure TscSkinObject.OnUnClick(AChild: boolean);
var
  i: integer;
begin
  RunScript(FUnClickEvent.Text);
  if AChild then
    for i := 0 to ChildCount-1 do
      Child[i].OnUnClick(AChild);
end;

{ TscSkinPopupMenu ============================================================}

function TscSkinPopupMenu.GetMenuItem: TscSkinObject;
begin
  Result := FindObjectByKind(skPopupMenuItem);
end;

initialization
  Objects := TList.Create;
finalization
  Objects.Free;
end.

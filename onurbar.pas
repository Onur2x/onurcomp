unit onurbar;

{$mode objfpc}{$H+}


interface

uses
  Windows, Classes,Controls, Graphics,BGRABitmap, BGRABitmapTypes, onurctrl;

type
  { TONURScrollBar }

    TONURScrollBar = class(TONURGraphicControl)
    private
      FTop, FBottom: TONURCUSTOMCROP;
      FNormali, Fbar: TONURCUSTOMCROP;
      FbuttonNL, FbuttonUL, FbuttonBL, FbuttonDL, FbuttonNR, FbuttonUR,
      FbuttonBR, FbuttonDR, FbuttonCN, FbuttonCU, FbuttonCB, FbuttonCD: TONURCUSTOMCROP;
      fstep:integer;
      fcbutons, flbutons, frbutons: TONURButtonState;
      flbuttonrect, frbuttonrect, Ftrackarea, fcenterbuttonarea: TRect;
      FPosition, FPosValue: int64;
      FMin, FMax: int64;
      FIsPressed: boolean;
      FOnChange: TNotifyEvent;
      procedure centerbuttonareaset;
      procedure SetPosition(Value: int64);
      procedure SetMax(Val: int64);
      procedure Setmin(Val: int64);
      function Getposition: int64;
      function Getmin: int64;
      function Getmax: int64;
      function CheckRange(const Value: int64): int64;
      function MaxMin: int64;
      function CalculatePosition(const Value: integer): int64;
      function SliderFromPosition(const Value: integer): int64;
      function PositionFromSlider(const Value: integer): int64;
      procedure SetPercentage(Value: int64);
    protected
      procedure SetSkindata(Aimg: TONURImg); override;
      procedure setkind(avalue: TONURKindState); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
        X: integer; Y: integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
        X: integer; Y: integer); override;
      procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
      procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
      procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    public
      constructor Create(Aowner: TComponent); override;
      destructor Destroy; override;
      procedure paint; override;
      function GetPercentage: int64;
    published
      procedure calcsize;
      property Alpha;
      property Step      : integer      read Fstep       write Fstep;
      property Min       : int64        read Getmin      write setmin;
      property Max       : int64        read Getmax      write setmax;
      property Position  : int64        read Getposition write setposition;
      property OnChange  : TNotifyEvent read FOnChange   write FOnChange;
      property Kind;
      property Action;
      property Align;
      property Anchors;
      property AutoSize;
      property BidiMode;
      property Constraints;
      property Enabled;
      property Font;
      property ParentBidiMode;
      property OnChangeBounds;
      property OnClick;
      property OnContextPopup;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnMouseWheel;
      property OnMouseWheelDown;
      property OnMouseWheelUp;
      property OnResize;
      property OnStartDrag;
      property ParentFont;
      property ParentShowHint;
      property ParentColor;
      property PopupMenu;
      property ShowHint;
      property Visible;
      property Transparent;
    end;

     { TONURProgressBar }

  TONURProgressBar = class(TONURGraphicControl)
  private
    Fleft, FCenter, FRight,Ftop,fbottom, Fbar: TONURCUSTOMCROP;
    FOnChange: TNotifyEvent;
    fposition, fmax, fmin: int64;
    FCaptonvisible: boolean;
    procedure setposition(const Val: int64);
    procedure setmax(const Val: int64);
    procedure setmin(const Val: int64);
    function Getposition: int64;
    function Getmin: int64;
    function Getmax: int64;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure setkind(avalue: TONURKindState); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    procedure calcsize;
    property Alpha;
    property Textvisible : boolean read FCaptonvisible write FCaptonvisible;
    property Skindata;
    property Min         : int64 read Getmin write setmin;
    property Max         : int64 read Getmax write setmax;
    property Position    : int64 read Getposition write setposition;
    property Onchange    : TNotifyEvent read FOnChange write FOnChange;
    property Kind;
    property Transparent;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;



  { TONURTrackBar }

  TONURTrackBar = class(TONURGraphicControl)
  private
    Fleft, FRight, FCenter, FNormal, FPress, FEnter, Fdisable: TONURCUSTOMCROP;
    FState: TONURButtonState;
    fcenterbuttonarea: TRect;
    FW, FH: integer;
    FPosition, FXY, FPosValue: integer;
    FMin, FMax: integer;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;

    procedure centerbuttonareaset;
    function CheckRange(const Value: integer): integer;
    function MaxMin: integer;
    function CalculatePosition(const Value: integer): integer;
    function GetPosition: integer;
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    function SliderFromPosition(const Value: integer): integer;
    function PositionFromSlider(const Value: integer): integer;
    procedure SetPosition(Value: integer); virtual;
    procedure SetPercentage(Value: integer);
    procedure Changed;

  protected
    procedure setkind(avalue: TONURKindState); override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    function GetPercentage: integer;
  published
    { Published declarations }
    procedure calcsize;
    property Alpha;
    property Position: integer read GetPosition write SetPosition;
    property Percentage: integer read GetPercentage write SetPercentage;
    property Kind;//         : Tokindstate    read Getkind          write Setkind;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Skindata;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property ParentColor;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
  end;

  { TONURKnob }

  TONURKnob = class(TONURGraphicControl)
  private
    FClick: Boolean;
    FPos: Integer;
    FValue: Integer;
    FInit: Integer;
    FMaxValue: Integer;
    FMinValue: Integer;
    FStep: Integer;
    FScroolStep: Integer;
    fstate: TONURButtonState;
    FOnChange: TNotifyEvent;

    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter,Fbuttonnormal,Fbuttonhover,Fbuttondown,Fbuttondisable: TONURCUSTOMCROP;

    procedure SetMaxValue(const aValue: Integer);
    procedure SetMinValue(const aValue: Integer);
    procedure SetValue(const aValue: Integer);
  protected
    procedure SetSkindata(Aimg: TONURImg);override;
    procedure cmonmouseleave(var messages: tmessage);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure DoOnChange; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Paint;override;
  published
    procedure calcsize;
    property Alpha;
    property Skindata;
    property MaxValue     : Integer read FMaxValue write SetMaxValue;
    property MinValue     : Integer read FMinValue write SetMinValue;
    property Step         : Integer read FStep write FStep;
    property ScroolStep   : Integer read FScroolStep write FScroolStep;
    property CurrentValue : Integer read FValue write SetValue;
    property OnChange     : TNotifyEvent read FOnChange write FOnChange;
    property Transparent;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

procedure Register;



implementation

uses SysUtils,BGRATransform;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURKnob]);
  RegisterComponents('ONUR', [TONURTrackBar]);
  RegisterComponents('ONUR', [TONURProgressBar]);
  RegisterComponents('ONUR', [TONURScrollBar]);
end;




{ TONURScrollBar }


function TONURScrollBar.Getposition: int64;
begin
  Result := FPosValue; //CalculatePosition(SliderFromPosition(FPosition));
end;

procedure TONURScrollBar.SetPosition(Value: int64);
begin
  if FPosition=PositionFromSlider(Value) then exit;
  if FIsPressed then Exit;

  Value := ValueRange(Value, FMin, FMax);

  if Kind = oHorizontal then
  begin
    FPosition := PositionFromSlider(Value);
    FPosValue := Value;
  end
  else
  begin
    FPosition := PositionFromSlider(Value);
    FPosValue := Value;
  end;
  Changed;
  Invalidate;
end;



function TONURScrollBar.Getmin: int64;
begin
  Result := FMin;
end;

procedure TONURScrollBar.Setmin(Val: int64);
begin
  if Val <> FMin then FMin := Val;
end;


function TONURScrollBar.Getmax: int64;
begin
  Result := FMax;
end;

procedure TONURScrollBar.SetMax(Val: int64);
begin
  if Val <> FMax then FMax := Val;
end;

function TONURScrollBar.MaxMin: int64;
begin
  Result := FMax - FMin;
end;


function TONURScrollBar.CheckRange(const Value: int64): int64;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function TONURScrollBar.CalculatePosition(const Value: integer): int64;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;//FMax-Value; //for revers
end;

function TONURScrollBar.SliderFromPosition(const Value: integer): int64;
var
  iHW: integer;
begin
  iHW := 0;
  case Kind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;
  Result := Round(Value / iHW * MaxMin);
end;



function TONURScrollBar.PositionFromSlider(const Value: integer): int64;
var
  iHW: integer;
begin
  iHW := 0;
  case Kind of
    oVertical   : iHW := Ftrackarea.Height - fcenterbuttonarea.Height;
    oHorizontal : iHW := Ftrackarea.Width - fcenterbuttonarea.Width;
  end;
  Result := Round((iHW / MaxMin) * Value);
end;

function TONURScrollBar.GetPercentage: int64;
var
  Maxi, Pos, Z: integer;
begin
  Maxi := FMax + Abs(FMin);
  Pos := FPosValue + Abs(FMin);

  if Kind = oHorizontal then
    Z := 0
  else
    Z := 100;

  Result := Abs(Round(Z - (Pos / Maxi) * 100));
end;



procedure TONURScrollBar.SetPercentage(Value: int64);
begin
  Value := ValueRange(Value, 0, 100);

  if Kind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;



procedure TONURScrollBar.setkind(avalue: tonURkindstate);
var
  a: integer;
begin
  inherited setkind(avalue);
  if (csDesigning in ComponentState) and not ( csLoading in ComponentState) and not (csReading in ComponentState) then
  begin
    a := self.Width;
    if Kind = oHorizontal then
    begin
      skinname := 'scrollbarh';
      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'scrollbarv';
      self.Width := self.Height;
      self.Height := a;
    end;
  end;
end;

procedure TONURScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin

  if csDesigning in ComponentState then
    Exit;

  if not Enabled then   Exit;

  inherited MouseDown(Button, Shift, X, Y);

 // FIsPressed := true;

  if (Button = mbleft) and (PtInRect(flbuttonrect, point(X, Y))) then
    // left or up   button
  begin
    position := position - 1;
    flbutons := obspressed;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    if Assigned(FOnChange) then FOnChange(Self);
  //   Invalidate;
  end
  else
  begin
    if (Button = mbleft) and (PtInRect(frbuttonrect, point(X, Y))) then
      // right  or down   button
    begin
      flbutons := obsnormal;
      frbutons := obspressed;
      fcbutons := obsnormal;
      Position := Position+1;
      if Assigned(FOnChange) then FOnChange(Self);
   //   Invalidate;

    end
    else
    begin
      if (Button = mbleft) and (PtInRect(fcenterbuttonarea, point(X, Y))) then
        // center  button
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obspressed;
        fispressed := True;
        Invalidate;
      end
      else
      begin
        if (Button = mbleft) and (PtInRect(Ftrackarea, point(X, Y))) then
          // center area click
        begin
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;

          if kind = oHorizontal then
            FPosition :=
              CheckRange(x - (fcenterbuttonarea.Width + (fcenterbuttonarea.Width div 2)))
          else
            FPosition :=
              CheckRange(y - (fcenterbuttonarea.Height +
              (fcenterbuttonarea.Height div 2)));
          if Assigned(FOnChange) then FOnChange(Self);
          Invalidate;
        end
        else
        begin
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;
          FIsPressed := False;
        //  Invalidate;
        end;
      end;
    end;
  end;
  // paint;
end;

procedure TONURScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  if not Enabled then   Exit;

  inherited MouseUp(Button, Shift, X, Y);
  FIsPressed := False;
  flbutons := obsnormal;
  frbutons := obsnormal;
  fcbutons := obsnormal;
  Invalidate;
end;

procedure TONURScrollBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin

  if not Enabled then   Exit;

  inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;

//  if FIsPressed = False then exit;

  if (PtInRect(flbuttonrect, point(X, Y))) and (fcbutons<>obshover) then
  begin
    fcbutons := obsnormal;
    flbutons := obshover;
    frbutons := obsnormal;
    Invalidate;
  end
  else
  begin
    if (PtInRect(frbuttonrect, point(X, Y))) and (fcbutons<>obshover) then
    begin
      fcbutons := obsnormal;
      flbutons := obsnormal;
      frbutons := obshover;
       Invalidate;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, point(X, Y))) and (flbutons<>obshover) and (frbutons<>obshover) then
      begin

        if fispressed then
        begin
          if kind = oHorizontal then
            FPosition :=
              CheckRange(x - ({fcenterbuttonarea.Width +} (fcenterbuttonarea.Width div 2)))
          else
            FPosition := CheckRange(y-({fcenterbuttonarea.Height +}(fcenterbuttonarea.Height div 2)));

          if Assigned(FOnChange) then FOnChange(Self);
        end;

        fcbutons := obshover;
        flbutons := obsnormal;
        frbutons := obsnormal;
         Invalidate;
      end
      else
      begin



        if fispressed then
        begin
          if kind = oHorizontal then
            FPosition :=
              CheckRange(x - ({fcenterbuttonarea.Width +} (fcenterbuttonarea.Width div 2)))
          else
            FPosition :=
              CheckRange(y - ({fcenterbuttonarea.Height +}
              (fcenterbuttonarea.Height div 2)));
          if Assigned(FOnChange) then FOnChange(Self);

          Invalidate;
        end;
     //   fcbutons := obsnormal;
     //   flbutons := obsnormal;
     //   frbutons := obsnormal;

      end;
    end;
  end;

end;

procedure TONURScrollBar.CMonmouseenter(var Messages: Tmessage);
var
  Cursorpos: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  if (fcbutons = obshover) or (flbutons = obshover) or (frbutons = obshover) then
    Exit;

  inherited MouseEnter;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);


  if (PtInRect(flbuttonrect, Cursorpos)) then
  begin
    flbutons := obshover;
    frbutons := obsnormal;
    fcbutons := obsnormal;
     Invalidate;
  end
  else
  begin
    if (PtInRect(frbuttonrect, Cursorpos)) then
    begin
      flbutons := obsnormal;
      frbutons := obshover;
      fcbutons := obsnormal;
       Invalidate;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, Cursorpos)) then
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obshover;
         Invalidate;
      end
      else
      begin
        if (flbutons<>obsnormal) and (frbutons = obsnormal) and (fcbutons = obsnormal) then
        begin
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;
          Invalidate;
        end;
      end;
    end;
  end;

end;

procedure TONURScrollBar.CMonmouseleave(var Messages: Tmessage);
begin
  if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;
  if (fcbutons <> obsnormal) or (flbutons <> obsnormal) or (frbutons <> obsnormal) then
  begin
    flbutons := obsnormal;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    Invalidate;
  end;
end;


constructor TONURScrollBar.Create(Aowner: TComponent);
begin
  inherited Create(aowner);
  Parent := AOwner as TWinControl;
  Flbuttonrect := Rect(1, 1, 20, 21);
  Frbuttonrect := Rect(179, 1, 199, 21);
  Ftrackarea := Rect(21, 1, 178, 21);
  kind := oHorizontal;
  Width := 200;
  Height := 22;
  fmax := 100;
  fmin := 0;
  fposition := 0;
  skinname := 'scrollbarh';
  flbutons := obsNormal;
  frbutons := obsNormal;
  fcbutons := obsNormal;

  Fstep := 1;
  FNormali := TONURCUSTOMCROP.Create;
  FNormali.cropname := 'NORMAL';
  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  Fbar := TONURCUSTOMCROP.Create;
  Fbar.cropname := 'BAR';

  FbuttonNL := TONURCUSTOMCROP.Create;
  FbuttonNL.cropname := 'LEFTBUTTONNORMAL';
  FbuttonUL := TONURCUSTOMCROP.Create;
  FbuttonUL.cropname := 'LEFTBUTTONHOVER';
  FbuttonBL := TONURCUSTOMCROP.Create;
  FbuttonBL.cropname := 'LEFTBUTTONPRESSED';
  FbuttonDL := TONURCUSTOMCROP.Create;
  FbuttonDL.cropname := 'LEFTBUTTONDISABLE';

  FbuttonNR := TONURCUSTOMCROP.Create;
  FbuttonNR.cropname := 'RIGHTBUTTONNORMAL';
  FbuttonUR := TONURCUSTOMCROP.Create;
  FbuttonUR.cropname := 'RIGHTBUTTONHOVER';
  FbuttonBR := TONURCUSTOMCROP.Create;
  FbuttonBR.cropname := 'RIGHTBUTTONPRESSED';
  FbuttonDR := TONURCUSTOMCROP.Create;
  FbuttonDR.cropname := 'RIGHTBUTTONDISABLE';


  FbuttonCN := TONURCUSTOMCROP.Create;
  FbuttonCN.cropname := 'CENTERBUTTONNORMAL';
  FbuttonCU := TONURCUSTOMCROP.Create;
  FbuttonCU.cropname := 'CENTERBUTTONHOVER';
  FbuttonCB := TONURCUSTOMCROP.Create;
  FbuttonCB.cropname := 'CENTERBUTTONPRESSED';
  FbuttonCD := TONURCUSTOMCROP.Create;
  FbuttonCD.cropname := 'CENTERBUTTONDISABLE';


  Customcroplist.Add(FNormali);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(Fbar);
  Customcroplist.Add(FbuttonNL);
  Customcroplist.Add(FbuttonUL);
  Customcroplist.Add(FbuttonBL);
  Customcroplist.Add(FbuttonDL);
  Customcroplist.Add(FbuttonNR);
  Customcroplist.Add(FbuttonUR);
  Customcroplist.Add(FbuttonBR);
  Customcroplist.Add(FbuttonDR);
  Customcroplist.Add(FbuttonCN);
  Customcroplist.Add(FbuttonCU);
  Customcroplist.Add(FbuttonCB);
  Customcroplist.Add(FbuttonCD);

  Captionvisible := False;

  if Parent is TONURCustomControl then
  Skindata:= TONURCustomControl(parent).Skindata
  else
  Skindata:=nil;
end;

destructor TONURScrollBar.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

  Skindata := nil;
  inherited Destroy;
end;

procedure TONURScrollBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure TONURScrollBar.calcsize;
begin

end;

procedure TONURScrollBar.paint;
var
  DR: TRect;
begin

  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  centerbuttonareaset;


  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    // DRAW TO BACKGROUND
    if self.Kind = oHorizontal then
    begin
     DrawPartstrechRegion(FTop.Croprect, self,FTop.Croprect.Width, self.ClientHeight, flbuttonrect, alpha);
     DrawPartstrechRegion(FBottom.Croprect, self,FBottom.Croprect.Width, self.ClientHeight, frbuttonrect, alpha);
     DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth -(FTop.Croprect.Width+FBottom.Croprect.Width),self.ClientHeight, Ftrackarea, alpha);
    end
    else
    begin
     DrawPartstrechRegion(FTop.Croprect, self, self.ClientWidth,FTop.Croprect.Height, flbuttonrect, alpha);
     DrawPartstrechRegion(FBottom.Croprect, self, self.ClientWidth, FTop.Croprect.Height, frbuttonrect, alpha);
     DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth, self.ClientHeight -(ftop.Croprect.Height+FBottom.Croprect.Height), Ftrackarea, alpha);
    end;


    /////////// DRAW TO BUTTON ///////////



    if Enabled = True then  // LEFT OR TOP BUTTON
    begin
      case flbutons of
        obsnormal: DR  := FbuttonNL.Croprect;
        obshover: DR   := FbuttonUL.Croprect;
        obspressed: DR := FbuttonBL.Croprect;
      end;
    end
    else
    begin
      DR := FbuttonDL.Croprect;
    end;
    DrawPartnormal(DR, self, flbuttonrect, alpha);  {left} {top}

    if Enabled = True then   // RIGHT OR BOTTOM BUTTON
    begin
      case frbutons of
        obsnormal  : DR := FbuttonNR.Croprect;
        obshover   : DR := FbuttonUR.Croprect;
        obspressed : DR := FbuttonBR.Croprect;
      end;
    end
    else
    begin
      DR := FbuttonDR.Croprect;
    end;
    DrawPartnormal(DR, self, frbuttonrect, alpha);


    if Enabled = True then   // CENTER BUTTON
    begin
      case fcbutons of
        obsnormal  : DR := FbuttonCN.Croprect;
        obshover   : DR := FbuttonCU.Croprect;
        obspressed : DR := FbuttonCB.Croprect;
      end;
    end
    else
    begin
      DR := FbuttonCD.Croprect;
    end;

    DrawPartnormal(DR, self, fcenterbuttonarea, alpha);  {center}
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;

end;



procedure TONURScrollBar.centerbuttonareaset;
var
  buttonh, borderwh: integer;
  dr:Trect;
begin
   if Enabled = True then   // CENTER BUTTON
    begin
      case fcbutons of
        obsnormal: DR :=
            Rect(FbuttonCN.FSLeft, FbuttonCN.FSTop, FbuttonCN.FSRight, FbuttonCN.FSBottom);
        obshover: DR :=
            Rect(FbuttonCU.FSLeft, FbuttonCU.FSTop, FbuttonCU.FSRight, FbuttonCU.FSBottom);
        obspressed: DR :=
            Rect(FbuttonCB.FSLeft, FbuttonCB.FSTop, FbuttonCB.FSRight, FbuttonCB.FSBottom);
      end;
    end
    else
    begin
      DR := Rect(FbuttonCD.FSLeft, FbuttonCD.FSTop, FbuttonCD.FSRight,
        FbuttonCD.FSBottom);
    end;


  borderwh := 2;
  if self.Kind = oHorizontal then
  begin
    buttonh := self.ClientHeight - (borderwh);  // button Width and Height;
    flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// left button    ;
    Frbuttonrect := Rect(self.ClientWidth - (buttonh + borderwh), borderwh,
      self.ClientWidth - borderwh, buttonh); // right button
    Ftrackarea := Rect(flbuttonrect.Right, flbuttonrect.top, frbuttonrect.Left,
      frbuttonrect.Bottom);

    buttonh :=DR.Width;
    fcenterbuttonarea := Rect(FPosition+Flbuttonrect.Width {+ buttonh}, borderwh,
        FPosition +Frbuttonrect.Width{+ buttonh} + buttonh, self.clientHeight - borderwh);
  end
  else
  begin
    buttonh :=self.ClientWidth - (borderwh);  // button Width and Height;

    Flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// top button
    Frbuttonrect := Rect(borderwh, self.ClientHeight - (buttonh + borderwh),
      self.ClientWidth - borderwh, self.ClientHeight - borderwh); // bottom button
    Ftrackarea := Rect(flbuttonrect.left, flbuttonrect.bottom,
      frbuttonrect.Right, frbuttonrect.top);

    buttonh :=DR.Height;
    fcenterbuttonarea := Rect(borderwh, FPosition+Flbuttonrect.Height {+ buttonh}, self.ClientWidth -
        borderwh, FPosition +Frbuttonrect.Height+ {buttonh +} buttonh);
  end;
end;


{ TONURTrackBar }


function TONURTrackBar.CheckRange(const Value: integer): integer;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function TONURTrackBar.MaxMin: integer;
begin
  Result := FMax - FMin;
end;

function TONURTrackBar.CalculatePosition(const Value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;// FMax-Value; //for revers
end;

function TONURTrackBar.GetPosition: integer;
begin
  Result := CalculatePosition(SliderFromPosition(FPosition));
end;

procedure TONURTrackBar.CMonmouseenter(var Messages: Tmessage);
begin
  if (not FIsPressed) and (Enabled) and (FState<>obshover) then
  begin
    FState := obshover;
    Invalidate;
  end;
end;

procedure TONURTrackBar.CMonmouseleave(var Messages: Tmessage);
begin
  if Enabled then
  begin
    if not FIsPressed then
    begin
      FState := obsnormal;
      Invalidate;
    end;
    inherited;
  end;
end;

procedure TONURTrackBar.SetMax(const Value: integer);
begin
  if Value <> FMax then FMax := Value;
end;

procedure TONURTrackBar.SetMin(const Value: integer);
begin
  if Value <> FMin then FMin := Value;
end;

function TONURTrackBar.SliderFromPosition(const Value: integer): integer;
begin
  if Kind = oVertical then
    Result := Round(Value / (self.Height - fcenterbuttonarea.Height) * MaxMin)
  else
    Result := Round(Value / (self.Width - fcenterbuttonarea.Width) * MaxMin);

end;

function TONURTrackBar.PositionFromSlider(const Value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Round(((self.Width - fcenterbuttonarea.Width) / MaxMin) * Value)
  else
    Result := Round(((self.Height - fcenterbuttonarea.Height) / MaxMin) * Value);
end;

procedure TONURTrackBar.SetPosition(Value: integer);
begin
  if FIsPressed then Exit;
  Value := ValueRange(Value, FMin, FMax);


  if Kind = oHorizontal then
  begin
    FPosition := PositionFromSlider(Value);
    FPosValue := Value - FMin;
  end
  else
  begin
    FPosition := PositionFromSlider(FMax - Value);
    FPosValue := Value; //FMax - Value;
  end;

  //  centerbuttonareaset;
  Changed;
  Invalidate;
end;

procedure TONURTrackBar.SetPercentage(Value: integer);
begin
  Value := ValueRange(Value, 0, 100);

  if Kind = oVertical then Value := Abs(FMax - Value);

  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;

function TONURTrackBar.GetPercentage: integer;
var
  Maxi, Pos, Z: integer;
begin
  Maxi := FMax + Abs(FMin);
  Pos := FPosValue + Abs(FMin);

  if Kind = oHorizontal then
    Z := 0
  else
    Z := 100;

  Result := Abs(Round(Z - (Pos / Maxi) * 100));
end;

procedure TONURTrackBar.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TONURTrackBar.setkind(avalue: TONURKindState);
var
  a: integer;
begin
  inherited setkind(avalue);
  if (csDesigning in ComponentState) and not ( csLoading in ComponentState) and not (csReading in ComponentState) then
  begin
    a := self.Width;
    if Kind = oHorizontal then
    begin
      skinname := 'trackbarh';
      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'trackbarv';
      self.Width := self.Height;
      self.Height := a;
    end;
  end;
  if skindata<>nil then
  Skindata := self.Skindata;
  Invalidate;
end;

constructor TONURTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(aowner);


  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';

  FNormal := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';

  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);

  FState := obsnormal;
  skinname := 'trackbarh';
  fcenterbuttonarea := Rect(1, 1, 19, 19);
  FIsPressed := False;
  FW := 0;
  FH := 0;
  FPosition := 0;
  FXY := 0;
  FPosValue := 0;
  FMin := 0;
  FMax := 100;
  FPosValue := 0;
  Self.Height := 30;
  Self.Width := 180;
  resim.SetSize(Width, Height);
  Caption := '';
  Captionvisible := False;
end;

destructor TONURTrackBar.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  inherited Destroy;
end;





procedure TONURTrackBar.centerbuttonareaset;
begin
  if Kind = oHorizontal then
  begin
     fcenterbuttonarea := Rect(FPosition {+ buttonh}, 0,
        FPosition +FNormal.Croprect.Width{+ buttonh} , self.clientHeight);
  end
  else
  begin
     fcenterbuttonarea := Rect(0,FPosition {+ buttonh}, self.ClientWidth,
        FPosition +FNormal.Croprect.Height{+ buttonh} );
  end;
end;

procedure TONURTrackBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  calcsize;
end;


procedure TONURTrackBar.calcsize;
begin
  if Kind = oHorizontal then
  begin
     FLeft.Targetrect   := Rect(0, 0, FLeft.FSRight - Fleft.FSLeft, self.ClientHeight);
     FRight.Targetrect  := Rect(self.ClientWidth - (FRight.FSRight - FRight.FSLeft), 0, self.ClientWidth, self.ClientHeight);
     FCenter.Targetrect := Rect((Fleft.FSRight - Fleft.FSLeft), 0, self.ClientWidth - (FRight.FSRight - FRight.FSLeft), self.ClientHeight);
  end
  else
  begin
     FLeft.Targetrect   :=  Rect(0, 0, self.ClientWidth, FLeft.FSBottom - Fleft.FSTop);
     FRight.Targetrect  :=  Rect(0, self.ClientHeight - (FRight.FSBottom - FRight.FSTop), self.ClientWidth, self.ClientHeight);
     FCenter.Targetrect :=  Rect(0, (Fleft.FSBottom - Fleft.FSTop), self.ClientWidth, self.ClientHeight - (FRight.FSBottom - FRight.FSTop));

  end;
end;
procedure TONURTrackBar.Paint;
var
  SrcRect: TRect;
begin
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if Kind = oHorizontal then
    begin
      //LEFT   //SOL
      DrawPartnormal(Fleft.Croprect, self, FLeft.Targetrect, alpha);
      //RIGHT //SAĞ
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER  //ORTA
      DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);

    end
    else
    begin
      //LEFT   //SOL
      DrawPartnormal(Fleft.Croprect, self, FLeft.Targetrect, alpha);
      //RIGHT //SAĞ
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER  //ORTA
      DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);
    end;


    // BUTTTON DRAW
    if Enabled = True then
    begin
      case Fstate of
        obsNormal:
        begin
          SrcRect := FNormal.Croprect;
        end;
        obspressed:
        begin
          SrcRect := FPress.Croprect;
        end;
        obshover:
        begin
          SrcRect := FEnter.Croprect;
        end;
      end;
    end
    else
    begin
      SrcRect := Fdisable.Croprect;
    end;
    centerbuttonareaset;
    DrawPartnormal(SrcRect, self, fcenterbuttonarea, alpha);

  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;
end;

procedure TONURTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FIsPressed := True;
    FState := obspressed;
    if Kind = oHorizontal then
      FPosition := CheckRange(X - ((FPress.FSright - FPress.FSLeft) div 2))
    else
      FPosition := CheckRange(Y - ((FPress.FSBottom - FPress.FSTop) div 2));

    Changed;
    invalidate;

  end;
end;

procedure TONURTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FIsPressed then
  begin
    FState := obshover;
    FIsPressed := False;
    Invalidate;
  end
  else
  begin
    if (Button = mbRight) and Assigned(PopupMenu) and not PopupMenu.AutoPopup then
    begin
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
    FState := obsnormal;
    Invalidate;
  end;
end;

procedure TONURTrackBar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  MAXi: smallint;
begin
  inherited MouseMove(Shift, X, Y);
  if FIsPressed then
  begin
    if Kind = oHorizontal then
      MAXi := X - ((FPress.FSright - FPress.FSLeft) div 2)
    else
      MAXi := Y - ((FPress.FSBottom - FPress.FSTop) div 2);

    FPosition := CheckRange(MAXi);
    FState := obspressed;
    Changed;
    Invalidate;
  end;
end;


{ TONURProgressBar }

procedure TONURProgressBar.setposition(const Val: int64);
begin
  fposition := ValueRange(Val, fmin, fmax);
  Caption := IntToStr(fposition);
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure TONURProgressBar.setmax(const Val: int64);
begin
  if fmax <> val then
  begin
    fmax := Val;
  end;
end;

procedure TONURProgressBar.setmin(const Val: int64);
begin
  if fmin <> val then
  begin
    fmin := Val;
  end;
end;

function TONURProgressBar.Getposition: int64;
begin
  Result := fposition;
end;

function TONURProgressBar.Getmin: int64;
begin
  Result := fmin;
end;

function TONURProgressBar.Getmax: int64;
begin
  Result := fmax;
end;



procedure TONURProgressBar.setkind(avalue: TONURKindState);
var
  a: integer;
begin
  inherited setkind(avalue);

  if (csDesigning in ComponentState) and not ( csLoading in ComponentState) and not (csReading in ComponentState) then
  begin
    a := self.Width;
    if Kind = oHorizontal then
    begin
      skinname := 'progressbarh';
      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'progressbarv';
      self.Width := self.Height;
      self.Height := a;
    end;
  end;

  if skindata<>nil then
  Skindata := self.Skindata;

  Invalidate;
end;

constructor TONURProgressBar.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);

  skinname := 'progressbarh';
  self.Width := 150;
  self.Height := 10;
  fmin := 0;
  fmax := 100;
  fposition := 10;
  kind := oHorizontal;

  Fleft   := TONURCUSTOMCROP.Create;
  Fleft.cropname   := 'LEFT';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight  := TONURCUSTOMCROP.Create;
  FRight.cropname  := 'RIGHT';
  Ftop    := TONURCUSTOMCROP.Create;
  Ftop.cropname    := 'TOP';
  fbottom := TONURCUSTOMCROP.Create;
  fbottom.cropname := 'BOTTOM';

  fbar := TONURCUSTOMCROP.Create;
  fbar.cropname := 'BAR';

  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(Ftop);
  Customcroplist.Add(fbottom);
  Customcroplist.Add(fbar);


  FCaptonvisible := True;
end;

destructor TONURProgressBar.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

  inherited Destroy;
end;

procedure TONURProgressBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
   calcsize;
end;

procedure TONURProgressBar.calcsize;
begin
  if self.Kind = oHorizontal then   //yatay
  begin
   Fleft.Targetrect   := Rect(0, 0, Fleft.Width,self.ClientHeight);
   FRight.Targetrect  := Rect(self.ClientWidth - FRight.Width, 0, self.ClientWidth, self.ClientHeight);
   ftop.Targetrect    := Rect(Fleft.Width,0,self.ClientWidth- FRight.Width ,ftop.Height);
   fbottom.Targetrect := Rect(Fleft.Width,self.ClientHeight- FRight.Height,self.ClientWidth - FRight.Width,self.ClientHeight);
   FCenter.Targetrect := Rect(Fleft.Width, ftop.Height, self.ClientWidth - FRight.Width, self.ClientHeight-fbottom.Height);
  end else
  begin                              //dikey
   Ftop.Targetrect    := Rect(0,0,self.ClientWidth, Ftop.Height);
   fbottom.Targetrect := Rect(0,self.ClientHeight-fbottom.Height,self.ClientWidth,self.ClientHeight);
   Fleft.Targetrect   := Rect(0, Ftop.Height, Fleft.Width, self.ClientHeight-fbottom.Height);
   FRight.Targetrect  := Rect(self.ClientWidth-FRight.Width,Ftop.Height,self.ClientWidth,self.ClientHeight-fbottom.Height);
   FCenter.Targetrect := Rect(Fleft.Width,ftop.Height,self.ClientWidth-FRight.Width,self.ClientHeight-fbottom.Height);
  end;
end;

procedure TONURProgressBar.paint;
var

  DBAR: TRect;
begin

  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if self.Kind = oHorizontal then
     DBAR := Rect(0,0 , (fposition * self.ClientWidth) div fmax, self.ClientHeight)
    else
     DBAR := Rect(0, 0 ,self.ClientWidth, (fposition * self.ClientHeight) div fmax);

     // DRAW CENTER
    // if self.Kind = oHorizontal then
    // DrawPartstrechRegion(FCenter.Croprect, Self, self.ClientWidth-(Fleft.Width+FRight.Width), self.ClientHeight -(Ftop.Height + Fbottom.Height), FCenter.Targetrect, alpha)
    // else
     DrawPartstrechRegion(FCenter.Croprect, Self,FCenter.Targetrect.Width,FCenter.Targetrect.Height, FCenter.Targetrect, alpha);

      DrawPartnormal(Fbar.Croprect, self, DBAR, alpha); //bar
      DrawPartnormal(Ftop.Croprect,self,ftop.Targetrect,alpha);
      DrawPartnormal(fbottom.Croprect,self,fbottom.Targetrect,alpha);
      DrawPartnormal(Fleft.Croprect, Self,Fleft.Targetrect, alpha);
      DrawPartnormal(FRight.Croprect, Self,FRight.Targetrect, alpha);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  Captionvisible := FCaptonvisible;
  inherited paint;
end;




procedure TONURKnob.SetMaxValue(const aValue: Integer);
begin
  FMaxValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONURKnob.SetMinValue(const aValue: Integer);
begin
 FMinValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONURKnob.SetValue(const aValue: Integer);
begin
 fvalue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONURKnob.cmonmouseleave(var messages: tmessage);
begin
//  fstate := obsnormal;
//  FClick:= False;
//  Invalidate;
end;

procedure TONURKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FPos   := Y;
  FClick := True;
  FInit  := FValue;
  fState := obspressed;
end;

procedure TONURKnob.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if FClick then
  begin
  SetValue(FInit - (Y - FPos) * FStep);
  DoOnChange;
  end;
end;

procedure TONURKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
   FClick:= False;
   fstate := obsnormal;

end;

function TONURKnob.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if WheelDelta > 0 then
    SetValue (FValue + FScroolStep)
  else if WheelDelta < 0 then
    SetValue (FValue - FScroolStep);
  Result:=inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TONURKnob.DoOnChange;
begin
 if Assigned(FOnChange) then FOnChange(Self);
end;

constructor TONURKnob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname      := 'knob';

  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Fbuttonnormal:=TONURCUSTOMCROP.Create;
  Fbuttonnormal.cropname := 'NORMAL';
  Fbuttondown:=TONURCUSTOMCROP.Create;
  Fbuttondown.cropname := 'PRESSED';
  Fbuttonhover:=TONURCUSTOMCROP.Create;
  Fbuttonhover.cropname := 'HOVER';
  Fbuttondisable:=TONURCUSTOMCROP.Create;
  Fbuttondisable.cropname := 'DISABLE';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(Fbuttonnormal);
  Customcroplist.Add(Fbuttondown);
  Customcroplist.Add(Fbuttonhover);
  Customcroplist.Add(Fbuttondisable);


  Fstate:=obsnormal;


 // AutoSize:= False;
  Width:= 100;
  Height:= 100;
  FValue :=0;
  FMaxValue:= +100;
  FMinValue:= -100;
  FStep:= 2;
  FInit := 0;
  FScroolStep:= 5;
  Captionvisible:=false;
  Caption:= IntToStr (FValue);
end;

destructor TONURKnob.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  inherited Destroy;
end;


procedure TONURKnob.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  calcsize;
end;

procedure TONURKnob.calcsize;
begin
  FCenter.Targetrect      := Rect(0,0, self.ClientWidth, self.ClientHeight);
end;

procedure TONURKnob.Paint;
var
  DR: TRect;
  affine: TBGRAAffineBitmapTransform;
  zValue: Integer;
  Temp : TBGRABitmap;
  tWidth,tHeight:integer;
begin

  if not Visible then Exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
      //CENTER //ORTA
      DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);


   if Enabled = False then
    begin
      DR := Fbuttondisable.Croprect;
    end
    else
    begin
      case Fstate of
        obsnormal : DR := Fbuttonnormal.Croprect;
        obshover  : DR := Fbuttonhover.Croprect;
        obspressed: DR := Fbuttondown.Croprect;
      end;
    end;




   zValue  := Round (360 / (fMaxValue - fMinValue) * (FValue - fMinValue));// + 45;

   tHeight := FCenter.Targetrect.Height div 2;
   tWidth  := FCenter.Targetrect.Width div 2;

   temp    := Skindata.Fimage.GetPart(dr);

   affine  := TBGRAAffineBitmapTransform.Create(Temp.Resample(tWidth,tHeight) as TBGRABitmap);
   Affine.Translate(-tWidth div 2, -tHeight div 2);

   affine.RotateDeg(zValue);
   Affine.Translate(tWidth div 2, tHeight div 2);

   temp.SetSize(0,0);
   temp.SetSize(tWidth, tHeight);

   Temp.Fill(affine,dmDrawWithTransparency);

   resim.BlendImage(self.Width div 2-(tWidth div 2) ,self.Height div 2- tHeight div 2,temp,boLinearBlend);// Fill(affine);

   affine.free;
   temp.Free;


  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  inherited Paint;
end;




end.

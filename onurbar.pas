unit onurbar;

{$mode objfpc}{$H+}


interface

uses
  Windows, Classes, Controls, Graphics,BGRABitmap, BGRABitmapTypes, onurctrl;

type

  { TONURScrollBar }

    TONURScrollBar = class(TONURGraphicControl)
    private
      fback,fhback:TBGRABitmap;
      FTop, FBottom: TONURCUSTOMCROP;
      FNormali, Fhover: TONURCUSTOMCROP;
      FbuttonNL, FbuttonUL, FbuttonBL, FbuttonDL, FbuttonNR, FbuttonUR,
      FbuttonBR, FbuttonDR, FbuttonCN, FbuttonCU, FbuttonCB, FbuttonCD: TONURCUSTOMCROP;
      fstep,buttonh:integer;
      fcbutons, flbutons, frbutons,fCenterstate: TONURButtonState;
      flbuttonrect, frbuttonrect, Ftrackarea, fcenterbuttonarea: TRect;
      FPosition, FPosValue: integer;
      FMin, FMax: integer;
      FIsPressed: boolean;
      FAutoHideScrollBar:boolean;
      FOnChange: TNotifyEvent;
      procedure centerbuttonareaset;
      procedure SetPosition(Value: integer);
      procedure SetMax(Val: integer);
      procedure Setmin(Val: integer);
      function Getposition: integer;
      function Getmin: integer;
      function Getmax: integer;
      function CheckRange(const Value: integer): integer;
      function MaxMin: integer;
      function CalculatePosition(const Value: integer): integer;
      function SliderFromPosition(const Value: integer): integer;
      function PositionFromSlider(const Value: integer): integer;
      procedure SetPercentage(Value: integer);
    protected
      procedure SetSkindata(Aimg: TONURImg); override;
      procedure Resize; override;
      procedure Resizing;
      procedure setkind(avalue: TONURKindState); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
        X: integer; Y: integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
        X: integer; Y: integer); override;
      procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
      procedure MouseLeave; override;
      procedure MouseEnter; override;
    public
      constructor Create(Aowner: TComponent); override;
      destructor Destroy; override;
      procedure paint; override;
      function GetPercentage: integer;
    published
      property Alpha;
      property Step      : integer      read Fstep       write Fstep;
      property Min       : integer      read Getmin      write setmin;
      property Max       : integer      read Getmax      write setmax;
      property Position  : integer      read Getposition write setposition;
      property OnChange  : TNotifyEvent read FOnChange   write FOnChange;
      property AutoHide  : boolean      read FAutoHideScrollBar write FAutoHideScrollBar;
      property Caption;
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
    fposition, fmax, fmin: integer;//64;
    FCaptonvisible: boolean;
    procedure setposition(const Val: integer);
    procedure setmax(const Val: integer);
    procedure setmin(const Val: integer);
    function Getposition: integer;
    function Getmin: integer;
    function Getmax: integer;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
    procedure setkind(avalue: TONURKindState); override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Alpha;
    property Textvisible : boolean read FCaptonvisible write FCaptonvisible;
    property Skindata;
    property Min         : integer read Getmin write setmin;
    property Max         : integer read Getmax write setmax;
    property Position    : integer read Getposition write setposition;
    property Onchange    : TNotifyEvent read FOnChange write FOnChange;
	property Caption;
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
    fhback,fback:TBGRABitmap;
    FHleft, FHRight, FHCenter,Fleft, FRight, FCenter, FNormal, FPress, FEnter, Fdisable: TONURCUSTOMCROP;

    FState: TONURButtonState;
    fcenterbuttonarea: TRect;
    FW, FH: integer;
    FPosition, FXY, FPosValue: integer;
    FMin, FMax: integer;
    FIsPressed: boolean;
    FOnChange: TNotifyEvent;

   // procedure centerbuttonareaset;
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
    procedure Resize; override;
    procedure resizing;
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
    property Alpha;
    property Position: integer read GetPosition write SetPosition;
    property Percentage: integer read GetPercentage write SetPercentage;
    property Kind;//         : Tokindstate    read Getkind          write Setkind;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
	property Caption;
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

    FCenter,Fbuttonnormal,Fbuttonhover,Fbuttondown,Fbuttondisable: TONURCUSTOMCROP;

    procedure SetMaxValue(const aValue: Integer);
    procedure SetMinValue(const aValue: Integer);
    procedure SetValue(const aValue: Integer);
  protected
    procedure SetSkindata(Aimg: TONURImg);override;
    procedure Resize; override;
    procedure Resizing;
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
    property Alpha;
    property Skindata;
    property MaxValue     : Integer read FMaxValue write SetMaxValue;
    property MinValue     : Integer read FMinValue write SetMinValue;
    property Step         : Integer read FStep write FStep;
    property ScroolStep   : Integer read FScroolStep write FScroolStep;
    property Value        : Integer read FValue write SetValue;
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

uses SysUtils,BGRATransform,math,lcltype;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURKnob]);
  RegisterComponents('ONUR', [TONURTrackBar]);
  RegisterComponents('ONUR', [TONURProgressBar]);
  RegisterComponents('ONUR', [TONURScrollBar]);
end;

const
IntfBarKind: array[TONURKindState] of Integer =
  (
    SB_HORZ,
    SB_VERT
  );



{ TONURScrollBar }


function TONURScrollBar.Getposition: integer;
begin
  Result := FPosValue; //CalculatePosition(SliderFromPosition(FPosition));
end;


procedure TONURScrollBar.SetPosition(Value: integer);
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




function TONURScrollBar.Getmin: integer;
begin
  Result := FMin;
end;

procedure TONURScrollBar.Setmin(Val: integer);
begin
  if Val <> FMin then FMin := Val;

end;


function TONURScrollBar.Getmax: integer;
begin
  Result := FMax;
end;

procedure TONURScrollBar.SetMax(Val: integer);
begin
  if Val <> FMax then FMax := Val;
end;

function TONURScrollBar.MaxMin: integer;
begin
  Result := FMax - FMin;
end;


function TONURScrollBar.CheckRange(const Value: integer): integer;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function TONURScrollBar.CalculatePosition(const Value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;//FMax-Value; //for revers
end;

function TONURScrollBar.SliderFromPosition(const Value: integer): integer;
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



function TONURScrollBar.PositionFromSlider(const Value: integer): integer;
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

function TONURScrollBar.GetPercentage: integer;
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



procedure TONURScrollBar.SetPercentage(Value: integer);
begin
  Value := ValueRange(Value, 0, 100);

  if Kind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;



procedure TONURScrollBar.setkind(avalue: TONURKindState);
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
 //     FTop.cropname      := 'LEFT';
 //     FBottom.cropname   := 'RIGHT';
      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'scrollbarv';
 //     FTop.cropname      := 'TOP';
 //     FBottom.cropname   := 'BOTTOM';
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


  fCenterstate := obshover;
  if (Button = mbleft) and (PtInRect(flbuttonrect, point(X, Y))) then
    // left or up   button
  begin
    position := position - 1;
    flbutons := obspressed;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    if Assigned(FOnChange) then FOnChange(Self);
    Invalidate;
  end
  else
  begin
    if (Button = mbleft) and (PtInRect(frbuttonrect, point(X, Y))) then // right  or down   button
    begin
      flbutons := obsnormal;
      frbutons := obspressed;
      fcbutons := obsnormal;
      Position := Position+1;
      if Assigned(FOnChange) then FOnChange(Self);
      Invalidate;
    end
    else
    begin
      if (Button = mbleft) and (PtInRect(fcenterbuttonarea, point(X, Y))) then  // center  button
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
          Invalidate;
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
  FIsPressed := False;

  inherited MouseUp(Button, Shift, X, Y);
{
  fCenterstate := obsnormal;
  flbutons := obsnormal;
  frbutons := obsnormal;
  fcbutons := obsnormal;  }
  Invalidate;
end;

procedure TONURScrollBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin

  if not Enabled then   Exit;
  if csDesigning in ComponentState then
    Exit;

  inherited MouseMove(Shift, X, Y);

//  if FIsPressed = False then exit;
  fCenterstate:=obshover;
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
              CheckRange(x -  (fcenterbuttonarea.Width div 2))
          else
            FPosition := CheckRange(y-(fcenterbuttonarea.Height div 2));

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

procedure TONURScrollBar.MouseLeave;
begin

   if csDesigning in ComponentState then
    Exit;
  if not Enabled then
    Exit;
  inherited MouseLeave;

  if (fcbutons <> obsnormal) or (flbutons <> obsnormal) or (frbutons <> obsnormal) or (fCenterstate <> obsnormal) then
  begin
    flbutons := obsnormal;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    fCenterstate := obsnormal;
    Invalidate;
  end;

end;

procedure TONURScrollBar.MouseEnter;
  var
  Cursorpos: TPoint;
begin

  if csDesigning in ComponentState then Exit;
  if not Enabled then Exit;
  if Max<=0 then exit;
  if (fcbutons = obshover) or (flbutons = obshover) or (frbutons = obshover) or (
    fCenterstate = obshover) then
    Exit;

  inherited MouseEnter;

  GetCursorPos(Cursorpos);
  Cursorpos := ScreenToClient(Cursorpos);



  if (PtInRect(flbuttonrect, Cursorpos)) then
  begin
    flbutons := obshover;
    frbutons := obsnormal;
    fcbutons := obsnormal;
    fCenterstate:=obshover;
    Invalidate;
  end
  else
  begin
    if (PtInRect(frbuttonrect, Cursorpos)) then
    begin
      flbutons := obsnormal;
      frbutons := obshover;
      fcbutons := obsnormal;
      fCenterstate:=obshover;
       Invalidate;
    end
    else
    begin
      if (PtInRect(fcenterbuttonarea, Cursorpos)) then
      begin
        flbutons := obsnormal;
        frbutons := obsnormal;
        fcbutons := obshover;
        fCenterstate:=obshover;
        Invalidate;
      end
      else
      begin
        if (flbutons<>obsnormal) and (frbutons = obsnormal) and (fcbutons = obsnormal) then
        begin
          flbutons := obsnormal;
          frbutons := obsnormal;
          fcbutons := obsnormal;
          fCenterstate:=obshover;
          Invalidate;
        end;
        if fCenterstate<>obshover then
        begin
         fCenterstate:=obshover;
          Invalidate;
        end;
      end;
    end;
  end;
end;






constructor TONURScrollBar.Create(Aowner: TComponent);
begin
  inherited Create(aowner);
//  Parent             := AOwner as TWinControl;
  fback              := TBGRABitmap.Create;
  fhback             := TBGRABitmap.Create;
  Flbuttonrect       := Rect(1, 1, 20, 21);
  Frbuttonrect       := Rect(179, 1, 199, 21);
  Ftrackarea         := Rect(21, 1, 178, 21);
  kind               := oHorizontal;
  Width              := 200;
  Height             := 22;
  fmax               := 100;
  fmin               := 0;
  fposition          := 0;
  skinname           := 'scrollbarh';
  flbutons           := obsNormal;
  frbutons           := obsNormal;
  fcbutons           := obsNormal;
  fCenterstate       := obsnormal;
  Fstep              := 1;
  Captionvisible     := False;
  FAutoHideScrollBar := false;

  FNormali           := TONURCUSTOMCROP.Create('NORMAL');
  FTop               := TONURCUSTOMCROP.Create('TOP');
  FBottom            := TONURCUSTOMCROP.Create('BOTTOM');
  Fhover             := TONURCUSTOMCROP.Create('HOVER');

  FbuttonNL          := TONURCUSTOMCROP.Create('LEFTBUTTONNORMAL');
  FbuttonUL          := TONURCUSTOMCROP.Create('LEFTBUTTONHOVER');
  FbuttonBL          := TONURCUSTOMCROP.Create('LEFTBUTTONPRESSED');
  FbuttonDL          := TONURCUSTOMCROP.Create('LEFTBUTTONDISABLE');

  FbuttonNR          := TONURCUSTOMCROP.Create('RIGHTBUTTONNORMAL');
  FbuttonUR          := TONURCUSTOMCROP.Create('RIGHTBUTTONHOVER');
  FbuttonBR          := TONURCUSTOMCROP.Create('RIGHTBUTTONPRESSED');
  FbuttonDR          := TONURCUSTOMCROP.Create('RIGHTBUTTONDISABLE');


  FbuttonCN          := TONURCUSTOMCROP.Create('CENTERBUTTONNORMAL');
  FbuttonCU          := TONURCUSTOMCROP.Create('CENTERBUTTONHOVER');
  FbuttonCB          := TONURCUSTOMCROP.Create('CENTERBUTTONPRESSED');
  FbuttonCD          := TONURCUSTOMCROP.Create('CENTERBUTTONDISABLE');


  Customcroplist.Add(FNormali);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(Fhover);
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




  if Parent is TONURCustomControl then
  Skindata := TONURCustomControl(parent).Skindata;
//  else
//  Skindata := nil;
end;

destructor TONURScrollBar.Destroy;
begin
  FreeAndNil(Fback);
  FreeAndNil(FHback);
  Customcroplist.Clear;

  Skindata := nil;
  inherited Destroy;
end;

procedure TONURScrollBar.SetSkindata(Aimg: TONURImg);
begin
  if not Assigned(Aimg) then exit;
  inherited SetSkindata(Aimg);

  centerbuttonareaset;

  {if self.Kind = oHorizontal then
    begin
     DrawPartstrechRegion(FNormali.Croprect,fback,skindata.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);
     DrawPartstrechRegion(Fhover.Croprect,fhback,skindata.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);

   //  DrawPartstrechRegion(FTop.Croprect, self,FTop.Croprect.Width, self.ClientHeight, flbuttonrect, alpha);
   //  DrawPartstrechRegion(FBottom.Croprect, self,FBottom.Croprect.Width, self.ClientHeight, frbuttonrect, alpha);
     if (fCenterstate = obshover) and (fhover.croprect.width>0) then
      DrawPartstrechRegion(Fhover.Croprect, self, self.ClientWidth -(FTop.Croprect.Width+FBottom.Croprect.Width),self.ClientHeight, Ftrackarea, alpha)
     else
      DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth -(FTop.Croprect.Width+FBottom.Croprect.Width),self.ClientHeight, Ftrackarea, alpha);

    end
    else
    begin
     DrawPartstrechRegion(FTop.Croprect, self, self.ClientWidth,FTop.Croprect.Height, flbuttonrect, alpha);
     DrawPartstrechRegion(FBottom.Croprect, self, self.ClientWidth, FTop.Croprect.Height, frbuttonrect, alpha);
     if (fCenterstate = obshover) and (fhover.croprect.width>0) then
      DrawPartstrechRegion(Fhover.Croprect, self, self.ClientWidth, self.ClientHeight -(ftop.Croprect.Height+FBottom.Croprect.Height), Ftrackarea, alpha)
     else
      DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth, self.ClientHeight -(ftop.Croprect.Height+FBottom.Croprect.Height), Ftrackarea, alpha);
    end;


   }

 //   fback.SetSize(0,0);
    fback.SetSize(ClientWidth,ClientHeight);
 //   fhback.SetSize(0,0);
    fhback.SetSize(ClientWidth,ClientHeight);
 //   DrawPartstrechRegion(FNormali.Croprect,fback,Aimg.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);
 //   DrawPartstrechRegion(Fhover.Croprect,fhback,Aimg.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);
end;

procedure TONURScrollBar.Resize;
begin
  inherited Resize;
  Resizing;
end;

procedure TONURScrollBar.Resizing;
var
  DR:TRect;
begin
  if Skindata=nil then exit;
   fback.SetSize(0,0);
   fback.SetSize(ClientWidth,ClientHeight);
   fhback.SetSize(0,0);
   fhback.SetSize(ClientWidth,ClientHeight);
   DrawPartstrechRegion(FNormali.Croprect,fback,Skindata.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);
   DrawPartstrechRegion(Fhover.Croprect,fhback,Skindata.fimage,Ftrackarea.Width,Ftrackarea.Height,ftrackarea,alpha);



   DR := FbuttonCN.Croprect;
  if self.Kind = oHorizontal then
  begin
    buttonh      := self.ClientHeight - 2;  // button Width and Height;
    flbuttonrect := Rect(2, 2, buttonh, buttonh);// left button;

    Frbuttonrect := Rect(self.ClientWidth-(2 + buttonh) , 2,
      self.ClientWidth-2, buttonh); // right button
    Ftrackarea   := Rect(flbuttonrect.Right, flbuttonrect.top, frbuttonrect.Left,
      frbuttonrect.Bottom);

    buttonh :=DR.Width;
    fcenterbuttonarea := Rect(FPosition+Flbuttonrect.Width, 2,
        FPosition +{Frbuttonrect.Width+} buttonh, self.clientHeight - 2);
  end
  else
  begin
    buttonh :=self.ClientWidth - 2;  // button Width and Height;

    Flbuttonrect := Rect(2, 2, buttonh, buttonh);// top button
    Frbuttonrect := Rect(2, self.ClientHeight - buttonh,
      self.ClientWidth, self.ClientHeight); // bottom button
    Ftrackarea :=Rect(flbuttonrect.left, flbuttonrect.bottom,frbuttonrect.Right, frbuttonrect.top);
    buttonh:=DR.Height;
    fcenterbuttonarea := Rect(2, FPosition+Flbuttonrect.Height, self.ClientWidth -
        2, FPosition +Frbuttonrect.Height+buttonh);

  end;
end;


procedure TONURScrollBar.paint;
var
  DR,DL,DC: TRect;
begin

  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);


  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if (fCenterstate = obshover) then
    centerbuttonareaset;

    // DRAW TO BACKGROUND
    if (fCenterstate = obshover) and (fhover.croprect.width>0) then
     resim.PutImage(0,0,fhback,dmDrawWithTransparency)
    else
     resim.PutImage(0,0,fback,dmDrawWithTransparency);

    /////////// DRAW TO BUTTON ///////////
     FAutoHideScrollBar:=true;



      if Enabled = True then  // LEFT OR TOP BUTTON
      begin
        case flbutons of
          obsnormal  : DL := FbuttonNL.Croprect;
          obshover   : DL := FbuttonUL.Croprect;
          obspressed : DL := FbuttonBL.Croprect;
        end;

        case frbutons of    // RIGHT OR DOWN BUTTON
          obsnormal  : DR := FbuttonNR.Croprect;
          obshover   : DR := FbuttonUR.Croprect;
          obspressed : DR := FbuttonBR.Croprect;
        end;

        case fcbutons of   // CENTER BUTTON
          obsnormal  : DC := FbuttonCN.Croprect;
          obshover   : DC := FbuttonCU.Croprect;
          obspressed : DC := FbuttonCB.Croprect;
         end;

      end
      else
      begin
        DL := FbuttonDL.Croprect;
        DR := FbuttonDR.Croprect;
        DC := FbuttonCD.Croprect;
      end;

    if (fCenterstate = obshover) {and (FAutoHideScrollBar=true)} then
    begin
      DrawPartnormal(DL, self, flbuttonrect, alpha);  {left} {top}
      DrawPartnormal(DR, self, frbuttonrect, alpha);  {right} {bottom}
      DrawPartnormal(DC, self, fcenterbuttonarea, alpha);  {center}
    end else
    begin
      if FAutoHideScrollBar=false then
      begin
       DrawPartnormal(DL, self, flbuttonrect, alpha);  {left} {top}
       DrawPartnormal(DR, self, frbuttonrect, alpha);  {right} {bottom}
       DrawPartnormal(DC, self, fcenterbuttonarea, alpha);  {center}
      end;

    end;
  end
  else
  begin

     centerbuttonareaset;

     resim.Fill(BGRABlack,dmSet);
     resim.FillRect(2,2,Width-2,Height-2,BGRA(90, 90, 90,alpha),dmset);

     resim.FillRect(flbuttonrect,BGRA(40, 40, 40),dmset);
     resim.FillRect(Frbuttonrect,BGRA(40, 40, 40),dmset);
     resim.FillRect(fcenterbuttonarea,BGRA(40, 40, 40),dmset);

     if Kind = oHorizontal then
     begin
      yaziyazBGRA(resim.CanvasBGRA,self.font,flbuttonrect,'<',tacenter);
      yaziyazBGRA(resim.CanvasBGRA,self.font,frbuttonrect,'>',tacenter);
      yaziyazBGRA(resim.CanvasBGRA,self.font,fcenterbuttonarea,'||',tacenter);

     end
     else
     begin
      yaziyazBGRA(resim.CanvasBGRA,self.font,flbuttonrect,'^',tacenter);
      yaziyazBGRA(resim.CanvasBGRA,self.font,frbuttonrect,'v',tacenter);
      yaziyazBGRA(resim.CanvasBGRA,self.font,fcenterbuttonarea,'=',tacenter);
     end;
  end;
  inherited Paint;
end;



procedure TONURScrollBar.centerbuttonareaset;
//var
//  buttonh, borderwh: integer;
//  dr:Trect;
begin
  if self.Kind = oHorizontal then
   fcenterbuttonarea := Rect(FPosition+Flbuttonrect.Width+2, 2, (FPosition+buttonh)-(Frbuttonrect.Width+2), self.clientHeight - 2)
  else
   fcenterbuttonarea := Rect(2, FPosition+Flbuttonrect.Height, self.ClientWidth - 2, FPosition +Frbuttonrect.Height+buttonh);

{   if Enabled = True then   // CENTER BUTTON
    begin
      case fcbutons of
        obsnormal  : DR := FbuttonCN.Croprect;
        obshover   : DR := FbuttonCu.Croprect;
        obspressed : DR := FbuttonCb.Croprect;
      end;
    end
    else
    begin
      DR := FbuttonCd.Croprect
    end;


  borderwh := 2;

  if self.Kind = oHorizontal then
  begin
    buttonh      := self.ClientHeight - borderwh;  // button Width and Height;
    flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// left button;

    Frbuttonrect := Rect(self.ClientWidth-(borderwh + buttonh) , borderwh,
      self.ClientWidth-borderwh, buttonh); // right button
    Ftrackarea   := Rect(flbuttonrect.Right, flbuttonrect.top, frbuttonrect.Left,
      frbuttonrect.Bottom);

    buttonh :=DR.Width;
    fcenterbuttonarea := Rect(FPosition+Flbuttonrect.Width, borderwh,
        FPosition +{Frbuttonrect.Width+} buttonh, self.clientHeight - borderwh);
  end
  else
  begin
    buttonh :=self.ClientWidth - borderwh;  // button Width and Height;

    Flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// top button
    Frbuttonrect := Rect(borderwh, self.ClientHeight - buttonh,
      self.ClientWidth, self.ClientHeight); // bottom button
    Ftrackarea :=Rect(flbuttonrect.left, flbuttonrect.bottom,frbuttonrect.Right, frbuttonrect.top);
    buttonh:=DR.Height;
    fcenterbuttonarea := Rect(borderwh, FPosition+Flbuttonrect.Height, self.ClientWidth -
        borderwh, FPosition +Frbuttonrect.Height+buttonh);

  end;  }
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
   //   Fleft.cropname      := 'LEFT';
  //    FRight.cropname   := 'RIGHT';
      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'trackbarv';
   //   Fleft.cropname      := 'TOP';
   //   FRight.cropname   := 'BOTTOM';
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
  FState            := obsnormal;
  skinname          := 'trackbarh';
  FIsPressed        := False;
  fcenterbuttonarea := Rect(1, 1, 19, 19);
  FW                := 0;
  FH                := 0;
  FPosition         := 0;
  FXY               := 0;
  FPosValue         := 0;
  FMin              := 0;
  FMax              := 100;
  FPosValue         := 0;
  Self.Height       := 30;
  Self.Width        := 180;
  Caption           := '';
  Captionvisible    := False;
  fback             := TBGRABitmap.Create;
  fhback            := TBGRABitmap.Create;

  FCenter           := TONURCUSTOMCROP.Create('CENTER');
  FRight            := TONURCUSTOMCROP.Create('RIGHT');
  Fleft             := TONURCUSTOMCROP.Create('LEFT');
  FHCenter          := TONURCUSTOMCROP.Create('HOVERCENTER');
  FHRight           := TONURCUSTOMCROP.Create('HOVERRIGHT');
  FHleft            := TONURCUSTOMCROP.Create('HOVERLEFT');
  FNormal           := TONURCUSTOMCROP.Create('NORMAL');
  FEnter            := TONURCUSTOMCROP.Create('HOVER');
  FPress            := TONURCUSTOMCROP.Create('PRESSED');
  Fdisable          := TONURCUSTOMCROP.Create('DISABLE');




  resim.SetSize(Width, Height);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FHCenter);
  Customcroplist.Add(FHRight);
  Customcroplist.Add(FHleft);
  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);
end;

destructor TONURTrackBar.Destroy;
begin
  FreeAndNil(fback);
  FreeAndNil(fHback);

  Customcroplist.Clear;
  inherited Destroy;
end;

{
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
}
procedure TONURTrackBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  resizing;
end;

procedure TONURTrackBar.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  resizing;
end;

procedure TONURTrackBar.resizing;
begin
  fback.setsize(0,0);
  fback.setsize(ClientWidth,ClientHeight);
  fhback.setsize(0,0);
  fhback.setsize(ClientWidth,ClientHeight);
  if Kind = oHorizontal then
  begin
     FLeft.Targetrect   := Rect(0, 0, Fleft.Croprect.Width, self.ClientHeight);
     FRight.Targetrect  := Rect(self.ClientWidth - FRight.Croprect.Width, 0, self.ClientWidth, self.ClientHeight);
     FCenter.Targetrect := Rect(Fleft.Croprect.Width, 0, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight);
  end
  else
  begin
     FLeft.Targetrect   :=  Rect(0, 0, self.ClientWidth,Fleft.Croprect.Height);
     FRight.Targetrect  :=  Rect(0, self.ClientHeight - FRight.Croprect.Height, self.ClientWidth, self.ClientHeight);
     FCenter.Targetrect :=  Rect(0, Fleft.Croprect.Height, self.ClientWidth, self.ClientHeight - FRight.Croprect.Height);
  end;

  //if normal picture
    //LEFT   //SOL
    DrawPartnormal(fleft.Croprect,fback,skindata.Fimage,fleft.Targetrect,alpha);
    //RIGHT //SAĞ
    DrawPartnormal(FRight.Croprect,fback,skindata.Fimage,FRight.Targetrect,alpha);
    //CENTER  //ORTA
    DrawPartnormal(FCenter.Croprect,fback,skindata.Fimage,FCenter.Targetrect,alpha);

  //if hover picture
   //LEFT   //SOL
    DrawPartnormal(fHleft.Croprect,fHback,skindata.Fimage,fleft.Targetrect,alpha);
    //RIGHT //SAĞ
    DrawPartnormal(FHRight.Croprect,fHback,skindata.Fimage,FRight.Targetrect,alpha);
    //CENTER  //ORTA
    DrawPartnormal(FHCenter.Croprect,fHback,skindata.Fimage,FCenter.Targetrect,alpha);


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

    {if Kind = oHorizontal then
    begin

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
    }

    // BUTTTON DRAW
    if Enabled = True then
    begin
      case Fstate of
        obsNormal  : SrcRect := FNormal.Croprect;
        obspressed : SrcRect := FPress.Croprect;
        obshover   : SrcRect := FEnter.Croprect;
      end;
    end
    else
    begin
      SrcRect := Fdisable.Croprect;
    end;

    //centerbuttonareaset;


      if Kind = oHorizontal then
      begin
         fcenterbuttonarea := Rect(FPosition, 0,
            FPosition +SrcRect.Width, self.clientHeight);
      end
      else
      begin
         fcenterbuttonarea := Rect(0,FPosition, self.ClientWidth,
            FPosition +SrcRect.Height);
      end;
    if Fstate=obsnormal then
    resim.PutImage(0,0,fback,dmDrawWithTransparency)
    else
    resim.PutImage(0,0,fHback,dmDrawWithTransparency);

    DrawPartnormal(SrcRect, self, fcenterbuttonarea, alpha);

  end
  else
  begin

   if Kind = oHorizontal then
     fcenterbuttonarea := Rect(FPosition {+ buttonh}, 2,
        FPosition +20{+ buttonh} , self.clientHeight-2)
   else
     fcenterbuttonarea := Rect(2,FPosition {+ buttonh}, self.ClientWidth-2,
        FPosition +20{+ buttonh} );




     resim.Fill(BGRABlack,dmSet);
     resim.FillRect(2,2,Width-2,Height-2,BGRA(90, 90, 90,alpha),dmset);

     resim.FillRect(fcenterbuttonarea,BGRA(40, 40, 40),dmset);

     Captionvisible:=false;
     yaziyazBGRA(resim.CanvasBGRA,self.font,ClientRect,inttostr(position),taCenter);


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
      FPosition := CheckRange(X - (FPress.Croprect.Width div 2))
    else
      FPosition := CheckRange(Y - (FPress.Croprect.Height div 2));

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
      MAXi := X - (FPress.Croprect.Width{(FPress.FSright - FPress.FSLeft)} div 2)
    else
      MAXi := Y - (FPress.Croprect.Height{(FPress.FSBottom - FPress.FSTop)} div 2);

    FPosition := CheckRange(MAXi);
    FState := obspressed;
    Changed;
    Invalidate;
  end;
end;


{ TONURProgressBar }

procedure TONURProgressBar.setposition(const Val: Integer);
begin
  fposition := ValueRange(Val, fmin, fmax);
  Caption := IntToStr(fposition);
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure TONURProgressBar.setmax(const Val: Integer);
begin
  if fmax <> val then
  begin
    fmax := Val;
  end;
end;

procedure TONURProgressBar.setmin(const Val: Integer);
begin
  if fmin <> val then
  begin
    fmin := Val;
  end;
end;

function TONURProgressBar.Getposition: Integer;
begin
  Result := fposition;
end;

function TONURProgressBar.Getmin: Integer;
begin
  Result := fmin;
end;

function TONURProgressBar.Getmax: Integer;
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
    //  FTop.cropname      := 'LEFT';
    //  FBottom.cropname   := 'RIGHT';

      self.Width := self.Height;
      self.Height := a;
    end
    else
    begin
      skinname := 'progressbarv';
    //  FTop.cropname      := 'TOP';
    //  FBottom.cropname   := 'BOTTOM';
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
  self.Height := 16;
  fmin := 0;
  fmax := 100;
  fposition := 10;
  //kind := oHorizontal;

  Fleft   := TONURCUSTOMCROP.Create('LEFT');
  FCenter := TONURCUSTOMCROP.Create('CENTER');
  FRight  := TONURCUSTOMCROP.Create('RIGHT');
  Ftop    := TONURCUSTOMCROP.Create('TOP');
  fbottom := TONURCUSTOMCROP.Create('BOTTOM');
  fbar    := TONURCUSTOMCROP.Create('BAR');

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
{  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;
}
  Customcroplist.Clear;

  inherited Destroy;
end;

procedure TONURProgressBar.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
   Resizing;
end;

procedure TONURProgressBar.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURProgressBar.Resizing;
begin
  if self.Kind = oHorizontal then   //yatay
  begin
   Fleft.Targetrect   := Rect(0, 0, Fleft.Croprect.Width,self.ClientHeight);
   FRight.Targetrect  := Rect(self.ClientWidth - FRight.Croprect.Width, 0, self.ClientWidth, self.ClientHeight);

   ftop.Targetrect    := Rect(Fleft.Croprect.Width,0,self.ClientWidth- FRight.Croprect.Width ,ftop.Croprect.Height);

   fbottom.Targetrect := Rect(Fleft.Croprect.Width,self.ClientHeight- fbottom.Croprect.Height,self.ClientWidth - FRight.Croprect.Width,self.ClientHeight);

  // FCenter.Targetrect := Rect(Fleft.Croprect.Width, ftop.Croprect.Height, self.ClientWidth - FRight.Croprect.Width, self.ClientHeight-fbottom.Croprect.Height);
   FCenter.Targetrect := Rect(0, ftop.Croprect.Height, self.ClientWidth , self.ClientHeight-fbottom.Croprect.Height);

  end else
  begin                              //dikey
   Ftop.Targetrect    := Rect(0,0,self.ClientWidth, Ftop.Croprect.Height);
   fbottom.Targetrect := Rect(0,self.ClientHeight-fbottom.Croprect.Height,self.ClientWidth,self.ClientHeight);

   Fleft.Targetrect   := Rect(0, Ftop.Croprect.Height, Fleft.Croprect.Width, self.ClientHeight-fbottom.Croprect.Height);

   FRight.Targetrect  := Rect(self.ClientWidth-FRight.Croprect.Width,Ftop.Croprect.Height,self.ClientWidth,self.ClientHeight-fbottom.Croprect.Height);
   FCenter.Targetrect := Rect(Fleft.Croprect.Width,ftop.Croprect.Height,self.ClientWidth-FRight.Croprect.Width,self.ClientHeight-fbottom.Croprect.Height);
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
     DBAR := Rect(0, self.ClientHeight-FCenter.Croprect.Height ,((fposition * self.ClientWidth) div fmax), FCenter.Croprect.Height)//self.ClientHeight)
    else
     DBAR := Rect(self.ClientWidth-FCenter.Croprect.Width, 0 ,FCenter.Croprect.Width, (fposition * self.ClientHeight) div fmax);

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

      Captionvisible := FCaptonvisible;
  end
  else
  begin

    if self.Kind = oHorizontal then
     DBAR := Rect(0, 0 ,((fposition * self.ClientWidth) div fmax), self.ClientHeight)//self.ClientHeight)
    else
     DBAR := Rect(0, 0 ,self.ClientWidth, (fposition * self.ClientHeight) div fmax);


     resim.Fill(BGRA(80, 80, 80,alpha), dmSet);
     resim.FillRect(DBAR,BGRA(40, 40, 40),dmset);
      Captionvisible:=false;
     yaziyazBGRA(resim.CanvasBGRA,self.font,ClientRect,Caption,taCenter);
  end;


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

  FCenter := TONURCUSTOMCROP.Create('CENTER');
//  FCenter.cropname := 'CENTER';
  Fbuttonnormal:=TONURCUSTOMCROP.Create('NORMAL');
//  Fbuttonnormal.cropname := 'NORMAL';
  Fbuttondown:=TONURCUSTOMCROP.Create('PRESSED');
//  Fbuttondown.cropname := 'PRESSED';
  Fbuttonhover:=TONURCUSTOMCROP.Create('HOVER');
//  Fbuttonhover.cropname := 'HOVER';
  Fbuttondisable:=TONURCUSTOMCROP.Create('DISABLE');
//  Fbuttondisable.cropname := 'DISABLE';

  Customcroplist.Add(FCenter);
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
//var
//  i:byte;
begin
{  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;
}
  Customcroplist.Clear;
  inherited Destroy;
end;


procedure TONURKnob.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  Resizing;
end;

procedure TONURKnob.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
  Resizing;
end;

procedure TONURKnob.Resizing;
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
//  Center: TPointF;
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

   resim.BlendImage(self.clientWidth div 2-(tWidth div 2) ,self.clientHeight div 2- tHeight div 2,temp,boLinearBlend);// Fill(affine);

   affine.free;
   temp.Free;


  end
  else
  begin
    zValue  := Round (360 / (fMaxValue - fMinValue) * (FValue - fMinValue));// + 45;

    tHeight := clientHeight div 2;
    tWidth  := clientWidth div 2;
    temp    :=TBGRABitmap.Create(ClientWidth,clientHeight);

    temp.EllipseAntialias(tWidth, tHeight,tWidth-5,tHeight-5,cssBlack,2,cssGray);
    temp.EllipseAntialias(tWidth, tHeight,tWidth-10,tHeight-10,cssBlack,2,BGRA(80, 80, 80,alpha));
    temp.RectangleAntialias(tWidth, tHeight-20,tWidth,tHeight+10,cssWhite,3);
    affine  := TBGRAAffineBitmapTransform.Create(Temp.Resample(tWidth,tHeight) as TBGRABitmap);
    Affine.Translate(-tWidth div 2, -tHeight div 2);

    affine.RotateDeg(zValue);
    Affine.Translate(tWidth div 2, tHeight div 2);

    temp.SetSize(0,0);
    temp.SetSize(tWidth, tHeight);

    Temp.Fill(affine,dmDrawWithTransparency);
    resim.BlendImage(self.clientWidth div 2-(tWidth div 2) ,self.clientHeight div 2- tHeight div 2,temp,boLinearBlend);// Fill(affine);

    yaziyazBGRA(resim.CanvasBGRA,self.font,Rect(0,tHeight-30,ClientWidth,ClientHeight),inttostr(Value),tacenter);
    affine.free;
    temp.Free;
  end;

  inherited Paint;
end;




end.

unit onurbar;

{$mode objfpc}{$H+}


interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Dialogs, types, LazUTF8, Zipper,onurctrl;

type
  { ToNScrollBar }

    ToNScrollBar = class(ToNGraphicControl)
    private
      //   Fleft, FRight           : TONCustomCrop;
      FTop, FBottom: TONCustomCrop;
      FNormali, Fbar: TONCustomCrop;
      FbuttonNL, FbuttonUL, FbuttonBL, FbuttonDL, FbuttonNR, FbuttonUR,
      FbuttonBR, FbuttonDR, FbuttonCN, FbuttonCU, FbuttonCB, FbuttonCD: TONCustomCrop;
      fstep:integer;
      fcbutons, flbutons, frbutons: TONButtonState;

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
      procedure SetSkindata(Aimg: TONImg); override;
    protected
      procedure setkind(avalue: tonkindstate); override;
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

      property ONTOP: TONCUSTOMCROP read FTop write FTop;
      property ONBOTTOM: TONCUSTOMCROP read FBottom write FBottom;
      property ONNORMAL: TONCUSTOMCROP read FNormali write FNormali;
      property ONBAR: TONCUSTOMCROP read Fbar write Fbar;
      property ONLEFTBUTNORMAL: TONCUSTOMCROP read FbuttonNL write FbuttonNL;
      property ONLEFTBUTONHOVER: TONCUSTOMCROP read FbuttonUL write FbuttonUL;
      property ONLEFTBUTPRESS: TONCUSTOMCROP read FbuttonBL write FbuttonBL;
      property ONLEFTBUTDISABLE: TONCUSTOMCROP read FbuttonDL write FbuttonDL;
      property ONRIGHTBUTNORMAL: TONCUSTOMCROP read FbuttonNR write FbuttonNR;
      property ONRIGHTBUTONHOVER: TONCUSTOMCROP read FbuttonUR write FbuttonUR;
      property ONRIGHTBUTPRESS: TONCUSTOMCROP read FbuttonBR write FbuttonBR;
      property ONRIGHTBUTDISABLE: TONCUSTOMCROP read FbuttonDR write FbuttonDR;
      property ONCENTERBUTNORMAL: TONCUSTOMCROP read FbuttonCN write FbuttonCN;
      property ONCENTERBUTONHOVER: TONCUSTOMCROP read FbuttonCU write FbuttonCU;
      property ONCENTERBUTPRESS: TONCUSTOMCROP read FbuttonCB write FbuttonCB;
      property ONCENTERBUTDISABLE: TONCUSTOMCROP read FbuttonCD write FbuttonCD;
    published
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

     { TONProgressBar }

  TONProgressBar = class(TONGraphicControl)
  private
    Fleft, FCenter, FRight,Ftop,fbottom, Fbar: TONCUSTOMCROP;
    FOnChange: TNotifyEvent;
    fposition, fmax, fmin: int64;
    FCaptonvisible: boolean;
    procedure setposition(const Val: int64);
    procedure setmax(const Val: int64);
    procedure setmin(const Val: int64);
    function Getposition: int64;
    function Getmin: int64;
    function Getmax: int64;
    procedure SetSkindata(Aimg: TONImg); override;
  protected
    procedure setkind(avalue: tonkindstate); override;
  public
    property ONLEFT_TOP     : TONCUSTOMCROP read Fleft   write Fleft;
    property ONRIGHT_BOTTOM : TONCUSTOMCROP read FRight  write FRight;
    property ONCENTER       : TONCUSTOMCROP read FCenter write FCenter;
    property ONTOP          : TONCUSTOMCROP read Ftop    write Ftop;
    property ONBOTTOM       : TONCUSTOMCROP read fbottom write fbottom;
    property ONBAR          : TONCUSTOMCROP read Fbar    write Fbar;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Alpha;
    property Textvisible: boolean read FCaptonvisible write FCaptonvisible;
    property Skindata;
    property Min: int64 read Getmin write setmin;
    property Max: int64 read Getmax write setmax;
    property Position: int64 read Getposition write setposition;
    property Onchange: TNotifyEvent read FOnChange write FOnChange;
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



  { TONTrackBar }

  TONTrackBar = class(ToNGraphicControl)
  private
    Fleft, FRight, FCenter, FNormal, FPress, FEnter, Fdisable: TONCustomCrop;
    FState: TONButtonState;
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
    procedure SetSkindata(Aimg: TONImg); override;
  protected
    procedure setkind(avalue: tonkindstate); override;
    public
    { Public declarations }
    property ONLEFT: TONCUSTOMCROP read Fleft write Fleft;
    property ONRIGHT: TONCUSTOMCROP read FRight write FRight;
    property ONCENTER: TONCUSTOMCROP read FCenter write FCenter;
    property ONBUTONNORMAL: TONCUSTOMCROP read FNormal write FNormal;
    property ONBUTONPRESS: TONCUSTOMCROP read FPress write FPress;
    property ONBUTONHOVER: TONCUSTOMCROP read FEnter write FEnter;
    property ONBUTONDISABLE: TONCUSTOMCROP read Fdisable write Fdisable;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    function GetPercentage: integer;
    //    property Positioning : Boolean read FIsPressed;
  published
    { Published declarations }
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

  { TONKnob }

  TONKnob = class(TOnGraphicControl)
  private
    FClick: Boolean;
    FPos: Integer;
    FValue: Integer;
    FInit: Integer;
    FMaxValue: Integer;
    FMinValue: Integer;
    FStep: Integer;
    FScroolStep: Integer;
    fstate: TONButtonState;
    FOnChange: TNotifyEvent;

    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter,Fbuttonnormal,Fbuttonhover,Fbuttondown,Fbuttondisable: TONCUSTOMCROP;

    procedure SetMaxValue(const aValue: Integer);
    procedure SetMinValue(const aValue: Integer);
    procedure SetSkindata(Aimg: TONImg);override;
    procedure SetValue(const aValue: Integer);
  protected
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
    property ONLEFT            : TONCUSTOMCROP read Fleft             write Fleft;
    property ONRIGHT           : TONCUSTOMCROP read FRight            write FRight;
    property ONCENTER          : TONCUSTOMCROP read FCenter           write FCenter;
    property ONBOTTOM          : TONCUSTOMCROP read FBottom           write FBottom;
    property ONBOTTOMLEFT      : TONCUSTOMCROP read FBottomleft       write FBottomleft;
    property ONBOTTOMRIGHT     : TONCUSTOMCROP read FBottomRight      write FBottomRight;
    property ONTOP             : TONCUSTOMCROP read FTop              write FTop;
    property ONTOPLEFT         : TONCUSTOMCROP read FTopleft          write FTopleft;
    property ONTOPRIGHT        : TONCUSTOMCROP read FTopRight         write FTopRight;

    property ONBUTTONNRML      : TONCUSTOMCROP read Fbuttonnormal     write Fbuttonnormal;
    property ONBUTTONHOVR      : TONCUSTOMCROP read Fbuttonhover      write Fbuttonhover;
    property ONBUTTONDOWN      : TONCUSTOMCROP read Fbuttondown       write Fbuttondown;
    property ONBUTTONDSBL      : TONCUSTOMCROP read Fbuttondisable    write Fbuttondisable;
  published
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

uses BGRAPath, inifiles, clipbrd, strutils, LazUnicode,BGRAFreeType, LazFreeTypeFontCollection,BGRATransform;

procedure Register;
begin
  RegisterComponents('ONUR', [TONKnob]);
  RegisterComponents('ONUR', [TONTrackBar]);
  RegisterComponents('ONUR', [TONProgressBar]);
  RegisterComponents('ONUR', [TONScrollBar]);
end;




{ ToNScrollBar }


function ToNScrollBar.Getposition: int64;
begin
  Result := FPosValue; //CalculatePosition(SliderFromPosition(FPosition));
end;

procedure ToNScrollBar.SetPosition(Value: int64);
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



function ToNScrollBar.Getmin: int64;
begin
  Result := FMin;
end;

procedure ToNScrollBar.Setmin(Val: int64);
begin
  if Val <> FMin then FMin := Val;
end;


function ToNScrollBar.Getmax: int64;
begin
  Result := FMax;
end;

procedure ToNScrollBar.SetMax(Val: int64);
begin
  if Val <> FMax then FMax := Val;
end;

function ToNScrollBar.MaxMin: int64;
begin
  Result := FMax - FMin;
end;


function ToNScrollBar.CheckRange(const Value: int64): int64;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (Ftrackarea.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function ToNScrollBar.CalculatePosition(const Value: integer): int64;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;//FMax-Value; //for revers
end;

function ToNScrollBar.SliderFromPosition(const Value: integer): int64;
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



function ToNScrollBar.PositionFromSlider(const Value: integer): int64;
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

function ToNScrollBar.GetPercentage: int64;
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

procedure ToNScrollBar.SetPercentage(Value: int64);
begin
  Value := ValueRange(Value, 0, 100);

  if Kind = oVertical then Value := Abs(FMax - Value);
  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;



procedure ToNScrollBar.setkind(avalue: tonkindstate);
var
  a: integer;
begin
  inherited setkind(avalue);
  if (csDesigning in ComponentState) then
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
//  Skindata := self.Skindata;
//  Invalidate;
end;

procedure ToNScrollBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
var
  a: int64;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;

  if not Enabled then
    Exit;

 // FIsPressed := true;

  if (Button = mbleft) and (PtInRect(flbuttonrect, point(X, Y))) then
    // left button down
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
      // right button down
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
        // right button down
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
          // right button down
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

procedure ToNScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FIsPressed := False;
 // if (fcbutons = obsnormal) or (flbutons = obsnormal) or (frbutons = obsnormal) then
 //   Exit;

  flbutons := obsnormal;
  frbutons := obsnormal;
  fcbutons := obsnormal;
  Invalidate;
end;

procedure ToNScrollBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
  if csDesigning in ComponentState then
    Exit;

//  if FIsPressed = False then exit;

{  if Fkind = oHorizontal then
  begin
   if (x<self.left+frbuttonrect.Width) and (Position=0) then exit;
   if (x>(self.ClientWidth-frbuttonrect.Width)) and (Position=fmax) then exit;

  end
  else
  begin
    if (y<self.top+flbuttonrect.Height) and (Position=0) then exit;
    if (y>(self.ClientHeight-flbuttonrect.Height)) and (Position=fmax) then exit;
 end;

}


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

procedure ToNScrollBar.CMonmouseenter(var Messages: Tmessage);
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

procedure ToNScrollBar.CMonmouseleave(var Messages: Tmessage);
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


constructor ToNScrollBar.Create(Aowner: TComponent);
begin
  inherited Create(aowner);
  //  Parent := AOwner as TWinControl;
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
  FNormali := TONCUSTOMCROP.Create;
  FNormali.cropname := 'NORMAL';
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  Fbar := TONCUSTOMCROP.Create;
  Fbar.cropname := 'BAR';

  FbuttonNL := TONCUSTOMCROP.Create;
  FbuttonNL.cropname := 'LEFTBUTTONNORMAL';
  FbuttonUL := TONCUSTOMCROP.Create;
  FbuttonUL.cropname := 'LEFTBUTTONHOVER';
  FbuttonBL := TONCUSTOMCROP.Create;
  FbuttonBL.cropname := 'LEFTBUTTONPRESSED';
  FbuttonDL := TONCUSTOMCROP.Create;
  FbuttonDL.cropname := 'LEFTBUTTONDISABLE';

  FbuttonNR := TONCUSTOMCROP.Create;
  FbuttonNR.cropname := 'RIGHTBUTTONNORMAL';
  FbuttonUR := TONCUSTOMCROP.Create;
  FbuttonUR.cropname := 'RIGHTBUTTONHOVER';
  FbuttonBR := TONCUSTOMCROP.Create;
  FbuttonBR.cropname := 'RIGHTBUTTONPRESSED';
  FbuttonDR := TONCUSTOMCROP.Create;
  FbuttonDR.cropname := 'RIGHTBUTTONDISABLE';


  FbuttonCN := TONCUSTOMCROP.Create;
  FbuttonCN.cropname := 'CENTERBUTTONNORMAL';
  FbuttonCU := TONCUSTOMCROP.Create;
  FbuttonCU.cropname := 'CENTERBUTTONHOVER';
  FbuttonCB := TONCUSTOMCROP.Create;
  FbuttonCB.cropname := 'CENTERBUTTONPRESSED';
  FbuttonCD := TONCUSTOMCROP.Create;
  FbuttonCD.cropname := 'CENTERBUTTONDISABLE';

  //  Backgroundbitmaped:=false;
  Captionvisible := False;
end;

destructor ToNScrollBar.Destroy;
begin

  Skindata := nil;
  FreeAndNil(FbuttonNL);
  FreeAndNil(FbuttonUL);
  FreeAndNil(FbuttonBL);
  FreeAndNil(FbuttonDL);
  FreeAndNil(FbuttonNR);
  FreeAndNil(FbuttonUR);
  FreeAndNil(FbuttonBR);
  FreeAndNil(FbuttonDR);

  FreeAndNil(FbuttonCN);
  FreeAndNil(FbuttonCU);
  FreeAndNil(FButtonCB);
  FreeAndNil(FButtonCD);
  FreeAndNil(FNormali);
  FreeAndNil(Fbar);
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  inherited Destroy;
end;

procedure ToNScrollBar.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
end;

procedure ToNScrollBar.paint;
var
  DR: TRect;
begin
  if csDesigning in ComponentState then
   Exit;
  if not Visible then Exit;
  resim.SetSize(0, 0);
  centerbuttonareaset;
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) then
  begin

    if self.Kind = oHorizontal then
    begin

  //    DR := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);  // LEFT TOP
      DrawPartstrechRegion(FTop.Croprect, self,FTop.Croprect.Width {FTop.FSRight - FTop.FSLeft}, self.ClientHeight, flbuttonrect, alpha);

      //   rect(0, 0, Fleft.FSRight - Fleft.FSLeft, Height), False);
 //     DR := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      DrawPartstrechRegion(FBottom.Croprect, self,FBottom.Croprect.Width {(FBottom.FSRight - FBottom.FSLeft)}, self.ClientHeight, frbuttonrect, alpha);

      //Rect(self.Width -(FRight.FSRight - FRight.FSLeft), 0, self.Width, self.Height),false);
  //    DR := Rect(FNormali.FSLeft, FNormali.FSTop, FNormali.FSRight, FNormali.FSBottom);
      DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth -(FTop.Croprect.Width+FBottom.Croprect.Width{(FTop.FSRight - FTop.FSLeft) + (FBottom.FSRight - FBottom.FSLeft)}),
        self.ClientHeight, Ftrackarea, alpha);
      //    self.Width-((Fleft.FSRight - Fleft.FSLeft)+(FRight.FSRight - FRight.FSLeft)),self.Height,Rect((Fleft.FSRight - Fleft.FSLeft), 0, (Width - (FRight.FSRight - FRight.FSLeft)), Height),false);
    end
    else
    begin
     // DR := Rect(FTop.FSLeft, FTop.FSTop, FTop.FSRight, FTop.FSBottom);
      DrawPartstrechRegion(FTop.Croprect, self, self.ClientWidth,FTop.Croprect.Height {FTop.FSBottom - FTop.FSTop}, flbuttonrect, alpha);
   //   DR := Rect(FBottom.FSLeft, FBottom.FSTop, FBottom.FSRight, FBottom.FSBottom);
      DrawPartstrechRegion(FBottom.Croprect, self, self.ClientWidth, FTop.Croprect.Height{(FBottom.FSBottom - FBottom.FSTop)}, frbuttonrect, alpha);
    //  DR := Rect(FNormali.FSLeft, FNormali.FSTop, FNormali.FSRight, FNormali.FSBottom);
      DrawPartstrechRegion(FNormali.Croprect, self, self.ClientWidth, self.ClientHeight -
        (ftop.Croprect.Height+FBottom.Croprect.Height{(FTop.FSBottom - FTop.FSTop) + (FBottom.FSBottom - FBottom.FSTop)}), Ftrackarea, alpha);
    end;



    /////////// DRAW TO BUTTON ///////////



    if Enabled = True then  // LEFT OR TOP BUTTON
    begin
      case flbutons of
        obsnormal: DR  := FbuttonNL.Croprect;
          //  Rect(FbuttonNL.FSLeft, FbuttonNL.FSTop, FbuttonNL.FSRight, FbuttonNL.FSBottom);
        obshover: DR   := FbuttonUL.Croprect;
        //    Rect(FbuttonUL.FSLeft, FbuttonUL.FSTop, FbuttonUL.FSRight, FbuttonUL.FSBottom);
        obspressed: DR := FbuttonBL.Croprect;
         //   Rect(FbuttonBL.FSLeft, FbuttonBL.FSTop, FbuttonBL.FSRight, FbuttonBL.FSBottom);
      end;
    end
    else
    begin
      DR := FbuttonDL.Croprect;//Rect(FbuttonDL.FSLeft, FbuttonDL.FSTop, FbuttonDL.FSRight,FbuttonDL.FSBottom);
    end;
    DrawPartnormal(DR, self, flbuttonrect, alpha);  {left} {top}

    if Enabled = True then   // RIGHT OR BOTTOM BUTTON
    begin
      case frbutons of
        obsnormal  : DR := FbuttonNR.Croprect;// Rect(FbuttonNR.FSLeft, FbuttonNR.FSTop, FbuttonNR.FSRight, FbuttonNR.FSBottom);
        obshover   : DR := FbuttonUR.Croprect;// Rect(FbuttonUR.FSLeft, FbuttonUR.FSTop, FbuttonUR.FSRight, FbuttonUR.FSBottom);
        obspressed : DR := FbuttonBR.Croprect;// Rect(FbuttonBR.FSLeft, FbuttonBR.FSTop, FbuttonBR.FSRight, FbuttonBR.FSBottom);
      end;
    end
    else
    begin
      DR := FbuttonDR.Croprect;//Rect(FbuttonDR.FSLeft, FbuttonDR.FSTop, FbuttonDR.FSRight, FbuttonDR.FSBottom);
    end;
    DrawPartnormal(DR, self, frbuttonrect, alpha);  {right}  {bottom}


    if Enabled = True then   // CENTER BUTTON
    begin
      case fcbutons of
        obsnormal  : DR := FbuttonCN.Croprect;//Rect(FbuttonCN.FSLeft, FbuttonCN.FSTop, FbuttonCN.FSRight, FbuttonCN.FSBottom);
        obshover   : DR := FbuttonCU.Croprect;//Rect(FbuttonCU.FSLeft, FbuttonCU.FSTop, FbuttonCU.FSRight, FbuttonCU.FSBottom);
        obspressed : DR := FbuttonCB.Croprect;//Rect(FbuttonCB.FSLeft, FbuttonCB.FSTop, FbuttonCB.FSRight, FbuttonCB.FSBottom);
      end;
    end
    else
    begin
      DR := FbuttonCD.Croprect;//Rect(FbuttonCD.FSLeft, FbuttonCD.FSTop, FbuttonCD.FSRight, FbuttonCD.FSBottom);
    end;

    DrawPartnormal(DR, self, fcenterbuttonarea, alpha);  {center}

  end;
  inherited Paint;

end;



procedure ToNScrollBar.centerbuttonareaset;
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
  // borderwh := Background.Border * 2; // border top, border bottom
  if self.Kind = oHorizontal then
  begin
    buttonh := self.ClientHeight - (borderwh);  // button Width and Height;
    flbuttonrect := Rect(borderwh, borderwh, buttonh, buttonh);// left button    ;
    Frbuttonrect := Rect(self.ClientWidth - (buttonh + borderwh), borderwh,
      self.ClientWidth - borderwh, buttonh); // right button
    Ftrackarea := Rect(flbuttonrect.Right, flbuttonrect.top, frbuttonrect.Left,
      frbuttonrect.Bottom);

      buttonh :=DR.Width;
   { if fPosition <= 0 then
      fcenterbuttonarea := Rect(Flbuttonrect.Right, borderwh,
        Flbuttonrect.Right + buttonh + borderwh, self.Height - (borderwh))
    else if fPosition >= (Ftrackarea.Width) then //or position 100
      fcenterbuttonarea := Rect(Ftrackarea.Width - (buttonh + borderwh),
        borderwh, Ftrackarea.Width - borderwh, self.Height - borderwh)
    else  }
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

   { if fPosition <= 0 then
      fcenterbuttonarea := Rect(borderwh, flbuttonrect.bottom + borderwh,
        self.Width - borderwh, flbuttonrect.bottom + buttonh + borderwh)
    else if fPosition >= (Ftrackarea.Height) then
      fcenterbuttonarea := Rect(borderwh, frbuttonrect.Top -
        (buttonh + borderwh), Width - borderwh, frbuttonrect.Top + borderwh)
    else   }
      fcenterbuttonarea := Rect(borderwh, FPosition+Flbuttonrect.Height {+ buttonh}, self.ClientWidth -
        borderwh, FPosition +Frbuttonrect.Height+ {buttonh +} buttonh);
  end;
end;


{ TONTrackBar }


function TONTrackBar.CheckRange(const Value: integer): integer;
begin
  if Kind = oVertical then
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Height - fcenterbuttonarea.Height))))
  else
    Result := PositionFromSlider(SliderFromPosition(
      ValueRange(Value, 0, (self.Width - fcenterbuttonarea.Width))));

  FPosValue := SliderFromPosition(Result);
end;



function TONTrackBar.MaxMin: integer;
begin
  Result := FMax - FMin;
end;

function TONTrackBar.CalculatePosition(const Value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Value - Abs(FMin)
  else
    Result := Value;// FMax-Value; //for revers
end;

function TONTrackBar.GetPosition: integer;
begin
  Result := CalculatePosition(SliderFromPosition(FPosition));
end;

procedure TONTrackBar.CMonmouseenter(var Messages: Tmessage);
begin
  if (not FIsPressed) and (Enabled) and (FState<>obshover) then
  begin
    FState := obshover;
    Invalidate;
  end;
end;

procedure TONTrackBar.CMonmouseleave(var Messages: Tmessage);
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

procedure TONTrackBar.SetMax(const Value: integer);
begin
  if Value <> FMax then FMax := Value;
end;

procedure TONTrackBar.SetMin(const Value: integer);
begin
  if Value <> FMin then FMin := Value;
end;

function TONTrackBar.SliderFromPosition(const Value: integer): integer;
begin
  if Kind = oVertical then
    Result := Round(Value / (self.Height - fcenterbuttonarea.Height) * MaxMin)
  else
    Result := Round(Value / (self.Width - fcenterbuttonarea.Width) * MaxMin);

end;

function TONTrackBar.PositionFromSlider(const Value: integer): integer;
begin
  if Kind = oHorizontal then
    Result := Round(((self.Width - fcenterbuttonarea.Width) / MaxMin) * Value)
  else
    Result := Round(((self.Height - fcenterbuttonarea.Height) / MaxMin) * Value);
end;

procedure TONTrackBar.SetPosition(Value: integer);
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

procedure TONTrackBar.SetPercentage(Value: integer);
begin
  Value := ValueRange(Value, 0, 100);

  if Kind = oVertical then Value := Abs(FMax - Value);

  FPosValue := Round((Value * (FMax + Abs(FMin))) / 100);


  FPosition := PositionFromSlider(FPosValue);
  Changed;
end;

function TONTrackBar.GetPercentage: integer;
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

procedure TONTrackBar.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TONTrackBar.setkind(avalue: tonkindstate);
var
  a: integer;
begin
  inherited setkind(avalue);
  if (csDesigning in ComponentState) then
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

constructor TONTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(aowner);

  FState := obsnormal;
  skinname := 'trackbarh';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';

  FNormal := TONCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FEnter := TONCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  FPress := TONCUSTOMCROP.Create;
  FPress.cropname := 'PRESSED';
  Fdisable := TONCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';

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

destructor TONTrackBar.Destroy;
begin
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  inherited Destroy;
end;





procedure TONTrackBar.centerbuttonareaset;
//var
// buttonh:integer;
begin
  if Kind = oHorizontal then
  begin
    //    a:=((Fleft.FSright-Fleft.FSLeft)+(FRight.FSright-FRight.FSLeft));
   // fcenterbuttonarea.Width := self.Height;
   // fcenterbuttonarea.Height := self.Height; //self.Width-a;
  //  fcenterbuttonarea.Width := self.ClientHeight;
  //  fcenterbuttonarea.Height := self.ClientHeight; //self.Width-a;

  {  if fPosition <= 0 then
      fcenterbuttonarea := Rect(0, 0, self.ClientHeight, self.ClientHeight)
    else if fPosition >= (self.ClientWidth - fcenterbuttonarea.Width) then
      fcenterbuttonarea := Rect(self.ClientWidth - fcenterbuttonarea.Width, 0, self.ClientWidth, self.ClientHeight)
    else
      fcenterbuttonarea := Rect(FPosition, 0, FPosition +
        fcenterbuttonarea.Width, self.ClientHeight);
   }
     fcenterbuttonarea := Rect(FPosition {+ buttonh}, 0,
        FPosition +FNormal.Croprect.Width{+ buttonh} , self.clientHeight);
  end
  else
  begin
    //    a:=((Fleft.FSBottom-Fleft.FSTop)+(FRight.FSBottom-FRight.FSTop));

   // fcenterbuttonarea.Height := self.ClientWidth;
  //  fcenterbuttonarea.Width := self.ClientWidth;//self.Height;

  {
    if fPosition <= 0 then
      fcenterbuttonarea := Rect(0, 0, self.ClientWidth, self.ClientWidth)
    else if fPosition >= (self.ClientHeight - self.ClientWidth) then
      fcenterbuttonarea := Rect(0, self.ClientHeight - self.ClientWidth, self.ClientWidth, self.ClientHeight)
    else
      fcenterbuttonarea := Rect(0, FPosition, self.ClientWidth, FPosition + self.ClientWidth);
   }

     fcenterbuttonarea := Rect(0,FPosition {+ buttonh}, self.ClientWidth,
        FPosition +FNormal.Croprect.Height{+ buttonh} );


  end;
end;

procedure TONTrackBar.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
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
procedure TONTrackBar.Paint;
var
  TrgtRect, SrcRect: TRect;
begin
   if csDesigning in ComponentState then
    exit;
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
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
          SrcRect := FNormal.Croprect;// Rect(FNormal.FSLeft, FNormal.FSTop,  FNormal.FSRight, FNormal.FSBottom);
        end;
        obspressed:
        begin
          SrcRect := FPress.Croprect;//Rect(FPress.FSLeft, FPress.FSTop, FPress.FSRight, FPress.FSBottom);
        end;
        obshover:
        begin
          SrcRect := FEnter.Croprect;//Rect(FEnter.FSLeft, FEnter.FSTop,FEnter.FSRight, FEnter.FSBottom);
        end;
      end;
    end
    else
    begin
      SrcRect := Fdisable.Croprect;//Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
    end;
    centerbuttonareaset;
    DrawPartnormal(SrcRect, self, fcenterbuttonarea, alpha);

  end
  else
  begin
    resim.Fill(BGRA(207, 220, 207), dmSet);
  end;
  inherited Paint;
end;

procedure TONTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
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

procedure TONTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
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

procedure TONTrackBar.MouseMove(Shift: TShiftState; X, Y: integer);
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


{ TONProgressBar }

procedure TONProgressBar.setposition(const Val: int64);
begin
  fposition := ValueRange(Val, fmin, fmax);
  Caption := IntToStr(fposition);
  if Assigned(FOnChange) then FOnChange(Self);
  Invalidate;
end;

procedure TONProgressBar.setmax(const Val: int64);
begin
  if fmax <> val then
  begin
    fmax := Val;
  end;
end;

procedure TONProgressBar.setmin(const Val: int64);
begin
  if fmin <> val then
  begin
    fmin := Val;
  end;
end;

function TONProgressBar.Getposition: int64;
begin
  Result := fposition;
end;

function TONProgressBar.Getmin: int64;
begin
  Result := fmin;
end;

function TONProgressBar.Getmax: int64;
begin
  Result := fmax;
end;



procedure TONProgressBar.setkind(avalue: tonkindstate);
var
  a: integer;
begin
  inherited setkind(avalue);
  if (csDesigning in ComponentState) then
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

constructor TONProgressBar.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);

  skinname := 'progressbarh';
  self.Width := 150;
  self.Height := 10;
  fmin := 0;
  fmax := 100;
  fposition := 10;
  kind := oHorizontal;

  Fleft   := TONCustomCrop.Create;
  Fleft.cropname   := 'LEFT';
  FCenter := TONCustomCrop.Create;
  FCenter.cropname := 'CENTER';
  FRight  := TONCustomCrop.Create;
  FRight.cropname  := 'RIGHT';
  Ftop    := TONCustomCrop.Create;
  Ftop.cropname    := 'TOP';
  fbottom := TONCustomCrop.Create;
  fbottom.cropname := 'BOTTOM';

  fbar := TONCustomCrop.Create;
  fbar.cropname := 'BAR';
  FCaptonvisible := True;
end;

destructor TONProgressBar.Destroy;
begin
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);
  FreeAndNil(Ftop);
  FreeAndNil(fbottom);
  FreeAndNil(Fbar);

  inherited Destroy;
end;

procedure TONProgressBar.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
  if self.Kind = oHorizontal then   //yatay
  begin
   Fleft.Targetrect   := Rect(0, 0, Fleft.Width,self.ClientHeight);
   FRight.Targetrect  := Rect(self.ClientWidth - FRight.Width, 0, self.ClientWidth, self.ClientHeight);
   ftop.Targetrect    := Rect(Fleft.Width,0,self.ClientWidth- FRight.Width ,ftop.Height);
   fbottom.Targetrect := Rect(Fleft.Width,self.ClientHeight- FRight.Height,self.ClientWidth - FRight.Width,self.ClientHeight);
   FCenter.Targetrect := Rect(Fleft.Width, ftop.Height, self.ClientWidth - FRight.Width, self.ClientHeight-fbottom.Height);
  end else
  begin                              //dikey
   Fleft.Targetrect   := Rect(0, 0, self.ClientWidth, Fleft.Height);
   FRight.Targetrect  := Rect(0, self.ClientHeight - FRight.Height,self.ClientWidth, self.ClientHeight);
   ftop.Targetrect    := Rect(0,Fleft.Height,Ftop.Width,self.ClientHeight- FRight.Height);
   fbottom.Targetrect := Rect(self.ClientWidth- fbottom.Width,Fleft.Height,self.ClientWidth,self.ClientHeight- FRight.Height);
   FCenter.Targetrect := Rect(ftop.Width, Fleft.Height, self.ClientWidth-fbottom.Width, self.ClientHeight - FRight.Height);
  end;


end;

procedure TONProgressBar.paint;
var
  DR, DBAR: TRect;
  img: TBGRACustomBitmap;
begin
   if csDesigning in ComponentState then
     Exit;
  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  if (Skindata <> nil) then
  begin

    if self.Kind = oHorizontal then
     DBAR := Rect(0,0 , (fposition * self.ClientWidth) div fmax, self.ClientHeight)
    else
     DBAR := Rect(0, 0 ,self.ClientWidth, (fposition * self.ClientHeight) div fmax);


      DrawPartstrechRegion(FCenter.Croprect, Self, self.ClientWidth, self.ClientHeight -(FRight.Height + Fleft.Height), FCenter.Targetrect, alpha);
      DrawPartnormal(Fbar.Croprect, self, DBAR, alpha); //bar
      DrawPartnormal(Ftop.Croprect,self,ftop.Targetrect,alpha);
      DrawPartnormal(fbottom.Croprect,self,fbottom.Targetrect,alpha);
      DrawPartnormal(Fleft.Croprect, Self,Fleft.Targetrect, alpha);
      DrawPartnormal(FRight.Croprect, Self,FRight.Targetrect, alpha);
  end
  else
  begin
    resim.Fill(BGRA(207, 220, 207), dmSet);
  end;

  Captionvisible := FCaptonvisible;
  inherited paint;
end;




procedure TONKnob.SetMaxValue(const aValue: Integer);
begin
  FMaxValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONKnob.SetMinValue(const aValue: Integer);
begin
 FMinValue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONKnob.SetValue(const aValue: Integer);
begin
 fvalue:=ValueRange(aValue,FMinValue,FMaxValue);
  Invalidate;
end;

procedure TONKnob.cmonmouseleave(var messages: tmessage);
begin
//  fstate := obsnormal;
//  FClick:= False;
//  Invalidate;
end;

procedure TONKnob.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FPos   := Y;
  FClick := True;
  FInit  := FValue;
  fState := obspressed;
end;

procedure TONKnob.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if FClick then
  begin
  SetValue(FInit - (Y - FPos) * FStep);
  DoOnChange;
  end;
end;

procedure TONKnob.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
   FClick:= False;
   fstate := obsnormal;

end;

function TONKnob.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if WheelDelta > 0 then
    SetValue (FValue + FScroolStep)
  else if WheelDelta < 0 then
    SetValue (FValue - FScroolStep);
  Result:=inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TONKnob.DoOnChange;
begin
 if Assigned(FOnChange) then FOnChange(Self);
end;

constructor TONKnob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname      := 'knob';

  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Fbuttonnormal:=TONCUSTOMCROP.Create;
  Fbuttonnormal.cropname := 'NORMAL';
  Fbuttondown:=TONCUSTOMCROP.Create;
  Fbuttondown.cropname := 'PRESSED';
  Fbuttonhover:=TONCUSTOMCROP.Create;
  Fbuttonhover.cropname := 'HOVER';
  Fbuttondisable:=TONCUSTOMCROP.Create;
  Fbuttondisable.cropname := 'DISABLE';
  Fstate:=obsnormal;


  AutoSize:= False;
  Width:= 100;
  Height:= 100;
  Caption:= IntToStr (FValue);
  FMaxValue:= +100;
  FMinValue:= -100;
  FStep:= 2;
  FInit := 0;
  FScroolStep:= 5;
  Captionvisible:=false;
end;

destructor TONKnob.Destroy;
begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopleft);
  FreeAndNil(FTopRight);
  FreeAndNil(Fbuttonhover);
  FreeAndNil(Fbuttonnormal);
  FreeAndNil(Fbuttondown);
  FreeAndNil(Fbuttondisable);
  inherited Destroy;
end;


procedure TONKnob.SetSkindata(Aimg: TONImg);
begin
  inherited SetSkindata(Aimg);
  FTopleft.Targetrect     := Rect(0, 0, FTopleft.Width, FTopleft.Height);
  FTopRight.Targetrect    := Rect(self.ClientWidth - (FTopRight.Width), 0, self.ClientWidth, (FTopRight.Height));
  FTop.Targetrect         := Rect(FTopleft.Width, 0, self.ClientWidth - (FTopRight.Width{+FTopleft.Width}),FTop.Height);
  FBottomleft.Targetrect  := Rect(0, self.ClientHeight - (FBottomleft.Height), (FBottomleft.Width), self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.ClientWidth - (FBottomRight.Width), self.ClientHeight - (FBottomRight.Height), self.ClientWidth, self.ClientHeight);
  FBottom.Targetrect      := Rect((FBottomleft.Width), self.ClientHeight - (FBottom.Height), self.ClientWidth -(FBottomRight.Width), self.ClientHeight);
  Fleft.Targetrect        := Rect(0, FTopleft.Height,(Fleft.Width), self.ClientHeight - (FBottomleft.Height));
  FRight.Targetrect       := Rect(self.ClientWidth - (FRight.Width),(FTopRight.Height), self.ClientWidth, self.ClientHeight - (FBottomRight.Height));
  FCenter.Targetrect      := Rect(Fleft.Croprect.Width,FTop.Croprect.Height , self.ClientWidth - FRight.Croprect.Width, self.ClientHeight - FBottom.Croprect.Height);
end;

procedure TONKnob.Paint;
var
  //  HEDEF,
  DR: TRect;
  affine: TBGRAAffineBitmapTransform;
  zValue: Integer;
  Temp : TBGRABitmap;
  tWidth,tHeight:integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if not Visible then Exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);
  if (Skindata <> nil) then    // or (FSkindata.Fimage <> nil) or (csDesigning in ComponentState) then
  begin

      DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
      //TOPRIGHT //SAĞÜST
      DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
      //TOP  //ÜST
      DrawPartnormal(FTop.Croprect, self, FTop.Targetrect, alpha);
      //BOTTOMLEFT // SOLALT
      DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
      //BOTTOMRIGHT  //SAĞALT
      DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
      //BOTTOM  //ALT
      DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
      //LEFT // SOL
      DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
      // RIGHT // SAĞ
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER //ORTA
      DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);


   if Enabled = False then
    begin
      DR := Fbuttondisable.Croprect;//Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight, Fdisable.FSBottom);
    end
    else
    begin
      case Fstate of
        obsnormal : DR := Fbuttonnormal.Croprect;
        obshover  : DR := Fbuttonhover.Croprect;// Rect(FEnter.FSLeft, FEnter.FSTop, FEnter.FSRight, FEnter.FSBottom);
        obspressed: DR := Fbuttondown.Croprect;// Rect(FPress.FSLeft, FPress.FSTop, FPress.FSRight, FPress.FSBottom);
      end;

    end;

   zValue  := Round (360 / (fMaxValue - fMinValue) * (FValue - fMinValue));// + 45;

   tWidth  := self.ClientWidth-(Fleft.Width+FRight.Width);
   tHeight := self.ClientHeight-(FTop.Height+FBottom.Height);
   temp    := Skindata.Fimage.GetPart(dr);
   affine  := TBGRAAffineBitmapTransform.Create(Temp.Resample(tWidth,tHeight) as TBGRABitmap);
   Affine.Translate(-tWidth div 2, -tHeight div 2);
   affine.RotateDeg(zValue);
   Affine.Translate(tWidth div 2, tHeight div 2);



   temp.SetSize(0,0);
   temp.SetSize(tWidth, tHeight);

   Temp.Fill(affine,dmDrawWithTransparency);

   resim.BlendImage(Fleft.Width ,Ftop.Height,temp,boLinearBlend);// Fill(affine);

   affine.free;
   temp.Free;

 //  Caption:={inttostr(zvalue)+'  '+}inttostr(CurrentValue);

  end
  else
  begin
    resim.Fill(BGRA(207, 220, 207), dmSet);
  end;

  inherited Paint;
end;


end.

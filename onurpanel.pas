unit onurpanel;

{$mode objfpc}{$H+}


interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, BGRABitmap, BGRABitmapTypes, onurctrl;

type
  { TONPanel }
  TONURPanel = class(TONURCustomControl)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Alpha;
    property Skindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
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
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  { TONCollapExpandPanel }

  TONURCollapExpandPanel = class(TONURCustomcontrol)
  private
    FStatus          : TONURExpandStatus;
    FOnCollapse      : TNotifyEvent;
    FOnExpand        : TNotifyEvent;
    fbutonarea       : TRect;
    FAutoCollapse    : boolean;
    fminheight       : integer;
    fnormalheight    : integer;
    Fstate           : TONURButtonState;
    Fheaderstate     : TONURCapDirection;
    fbutondirection  : TONURButtonDirection;
    Fleft, FTopleft  : TONURCUSTOMCROP;
    FBottomleft      : TONURCUSTOMCROP;
    FRight           : TONURCUSTOMCROP;
    FTopRight        : TONURCUSTOMCROP;
    FBottomRight     : TONURCUSTOMCROP;
    FTop, FBottom    : TONURCUSTOMCROP;
    FCenter, FNormal : TONURCUSTOMCROP;
    FPress, FEnter   : TONURCUSTOMCROP;
    Fdisable         : TONURCUSTOMCROP;
    Fcaptionarea     : TONURCUSTOMCROP;
   { FexNormal        : TONURCUSTOMCROP;
    FexPress         : TONURCUSTOMCROP;
    FexEnter         : TONURCUSTOMCROP;
    Fexdisable       : TONURCUSTOMCROP;}
    procedure Setheaderstate(AValue: TONURCapDirection);
    procedure SetStatus(const AValue: TONURExpandStatus);
    procedure SetAutoCollapse(const AValue: boolean);
    procedure SetOnCollapse(const AValue: TNotifyEvent);
    procedure SetOnExpand(const AValue: TNotifyEvent);
//    function GetMinheight: integer;
//    function GetNormalheight: integer;
    procedure Setminheight(const Avalue: integer);
    procedure Setnormalheight(const Avalue: integer);
    procedure ResizePanel();
    procedure CMonmouseenter(var Messages: Tmessage); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: Tmessage); message CM_MOUSELEAVE;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure DblClick; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure paint; override;
  published
    property Alpha;
    property Caption;
    property OnExpand       : TNotifyEvent         read FOnExpand       write SetOnExpand;
    property OnCollapse     : TNotifyEvent         read FOnCollapse     write SetOnCollapse;
    property AutoCollapse   : boolean              read FAutoCollapse   write SetAutoCollapse;
    property Status         : TONURExpandStatus    read FStatus         write SetStatus;
    property Minheight      : integer              read fminheight      write Setminheight;
    property Normalheight   : integer              read fnormalheight   write Setnormalheight;
    property HeaderState    : TONURCapDirection    read Fheaderstate    write Setheaderstate;
    property ButtonPosition : TONURButtonDirection read fbutondirection write fbutondirection;
    property Skindata;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property ChildSizing;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
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
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;



  { TONURGraphicPanel }

  TONURGraphicPanel = class(TONURGraphicControl)
  private
    Fleft, FTopleft         : TONURCUSTOMCROP;
    FBottomleft, FRight     : TONURCUSTOMCROP;
    FTopRight, FBottomRight : TONURCUSTOMCROP;
    FTop, FBottom, FCenter  : TONURCUSTOMCROP;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
  published
    property Alpha;
    property Skindata;
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
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Transparent;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
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
    property OnStartDock;
    property OnStartDrag;
    //    property OnUnDock;
  end;

  { TONURHeaderPanel }

  TONURHeaderPanel = class(TONURPanel)
  private
    FMousePoint : TPoint;
    FFormPoint  : TPoint;
    fmoveable   : Boolean;
    function GetMovable: Boolean;
    procedure SetMovable(AValue: Boolean);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Movable : Boolean read GetMovable write SetMovable;
    property Alpha;
    property Skindata;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Crop;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
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
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


procedure Register;

implementation
uses forms;
procedure Register;
begin
  RegisterComponents('ONUR', [TONURPANEL]);
  RegisterComponents('ONUR', [TONURHeaderPanel]);
  RegisterComponents('ONUR', [TONURGraphicPanel]);
  RegisterComponents('ONUR', [TONURCollapExpandPanel]);
end;

{ TONURCollapExpandPanel }

procedure TONURCollapExpandPanel.Setheaderstate(AValue: TONURcapdirection);
begin
  if Fheaderstate = AValue then Exit;
  Fheaderstate := AValue;
  Invalidate;
end;

procedure TONURCollapExpandPanel.SetStatus(const AValue: TONURExpandStatus);
begin
  if FStatus = AValue then Exit;
  FStatus := AValue;
  if (FAutoCollapse) then ResizePanel();
end;

procedure TONURCollapExpandPanel.SetAutoCollapse(const AValue: boolean);
begin
  if FAutoCollapse = AValue then Exit;
  FAutoCollapse := AValue;
  ResizePanel();
end;

procedure TONURCollapExpandPanel.SetOnCollapse(const AValue: TNotifyEvent);
begin
  if FOnCollapse = AValue then Exit;
  FOnCollapse := AValue;
end;

procedure TONURCollapExpandPanel.SetOnExpand(const AValue: TNotifyEvent);
begin
  if FOnExpand = AValue then Exit;
  FOnExpand := AValue;
end;
{
function TONURCollapExpandPanel.GetMinheight: integer;
begin
  Result := fminheight;
end;


function TONURCollapExpandPanel.GetNormalheight: integer;
begin
  Result := fnormalheight;
end;
}
procedure TONURCollapExpandPanel.Setminheight(const Avalue: integer);
begin
  if fminheight = AValue then Exit;
  fminheight := AValue;
  Self.Constraints.MinHeight := fminheight;
end;

procedure TONURCollapExpandPanel.Setnormalheight(const Avalue: integer);
begin
  if fnormalheight = AValue then Exit;
  fnormalheight := AValue;
  Self.Constraints.MaxHeight := fnormalheight;
end;

procedure TONURCollapExpandPanel.ResizePanel;
begin
  if (FStatus = oExpanded) then
  begin
    Self.Height := Normalheight;
  end
  else
  begin
    Self.Height := Minheight;
  end;
end;

procedure TONURCollapExpandPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Enabled=false then exit;
  inherited mousedown(button, shift, x, y);
  if PtInRect(fbutonarea, Point(X, Y)) then
  begin
    if (FStatus = oExpanded) then
    begin
      if Assigned(FOnCollapse) then FOnCollapse(Self);
      FStatus := oCollapsed;
      Fstate := obspressed;
    end
    else
    begin
      if Assigned(FOnExpand) then FOnExpand(Self);
      FStatus := oExpanded;
      Fstate := obspressed;
    end;
    ResizePanel();
  end;

end;

procedure TONURCollapExpandPanel.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X: integer; Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURCollapExpandPanel.CMonmouseenter(var Messages: Tmessage);
var
  aPnt: TPoint;
begin
  if Enabled=false then exit;
  if Fstate=obshover then exit;
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(fbutonarea, aPnt) then
  begin
    Fstate := obshover;
    Invalidate;
  end;
end;

procedure TONURCollapExpandPanel.CMonmouseleave(var Messages: Tmessage);
begin
  if Fstate=obsnormal then exit;
  if Enabled=false then exit;
  Fstate := obsnormal;
  Invalidate;
end;

procedure TONURCollapExpandPanel.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited mousemove(shift, x, y);
  if enabled=false then exit;
  if fstate=obsnormal then exit;

  if PtInRect(fbutonarea, Point(X, Y)) then
  begin
    Fstate := obshover;
    Invalidate;
  end;
end;


procedure TONURCollapExpandPanel.DblClick;
var
  aPnt: TPoint;
begin
  inherited dblclick;
  GetCursorPos(aPnt);
  aPnt := ScreenToClient(aPnt);
  if PtInRect(Rect(Fleft.fsLeft, FTop.fsTop, FRight.fsLeft, FTop.fsBottom), aPnt) then
  begin
    if (FStatus = oExpanded) then
    begin
      if Assigned(FOnCollapse) then FOnCollapse(Self);
      FStatus := oCollapsed;
      //        Fstate  := obspressed;
    end
    else
    begin
      if Assigned(FOnExpand) then FOnExpand(Self);
      FStatus := oExpanded;
      //         Fstate  := obspressed;
    end;
    ResizePanel();

  end;
end;

constructor TONURCollapExpandPanel.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 250;
  Height := 150;
  FStatus := oExpanded;
  FAutoCollapse := False;
  fminheight := 30;
  fnormalheight := Height;
  //  Self.Constraints.MinHeight := fminheight;
  ParentBackground := True;
  fbutondirection := obright;
  Alpha := 255;
  Skinname := 'expandpanel';
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
  FNormal := TONURCUSTOMCROP.Create;
  FNormal.cropname := 'NORMAL';
  FPress := TONURCUSTOMCROP.Create;
  FPress.cropname := 'PRESS';
  FEnter := TONURCUSTOMCROP.Create;
  FEnter.cropname := 'HOVER';
  Fdisable := TONURCUSTOMCROP.Create;
  Fdisable.cropname := 'DISABLE';

  Fcaptionarea:= TONURCUSTOMCROP.Create;
  Fcaptionarea.cropname := 'CAPTION';

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FNormal);
  Customcroplist.Add(FEnter);
  Customcroplist.Add(FPress);
  Customcroplist.Add(Fdisable);
  Customcroplist.Add(Fcaptionarea);


  Fstate := obsnormal;
  fbutonarea := Rect(Self.Width - self.Height, 0, self.Width, self.Height);
  Resim.SetSize(Width, Height);
  Captionvisible := False;
  Fheaderstate := ocup;
end;

destructor TONURCollapExpandPanel.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  inherited Destroy;
end;

procedure TONURCollapExpandPanel.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  FTopleft.Targetrect       := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect      := Rect(self.clientWidth - FTopRight.Width, 0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect           := Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect    := Rect(0, self.clientHeight - FBottomleft.Height, FBottomleft.Width, self.clientHeight);
  FBottomRight.Targetrect   := Rect(self.clientWidth - FBottomRight.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect        := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect          := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);
  FRight.Targetrect         := Rect(self.clientWidth - FRight.Width,FTopRight.Height, self.ClientWidth, self.ClientHeight - FBottomRight.Height);
  FCenter.Targetrect        := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width, self.clientHeight -FBottom.Height);
  Fcaptionarea.Targetrect   := Rect(FTopleft.Width, FTop.Height,self.ClientWidth - FRight.Width,fminheight);

  self.ChildSizing.LeftRightSpacing:=Fleft.Width;
  self.ChildSizing.TopBottomSpacing:=FTop.Height;

end;

procedure TONURCollapExpandPanel.paint;
var
SrcRect: TRect;

begin
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try

      //TOPLEFT   //SOLÜST
      DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
      //TOPRIGHT //SAĞÜST
      DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
      //TOP  //ÜST
      DrawPartnormal(FTop.Croprect, self, FTop.Targetrect, alpha);
      //CAPTION AREA
      DrawPartnormal(Fcaptionarea.Croprect, self, Fcaptionarea.Targetrect, alpha);
      //BOTTOMLEFT // SOLALT
      DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
      //BOTTOMRIGHT  //SAĞALT
      DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
      //BOTTOM  //ALT
      DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
      //CENTERLEFT // SOLORTA
      DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
      //CENTERRIGHT // SAĞORTA
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      //CENTER //ORTA
      DrawPartnormal(FCenter.Croprect, self, FCenter.Targetrect, alpha);



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



      if fbutondirection = obright then
        fbutonarea := Rect(Self.ClientWidth - (FRight.Width+SrcRect.Width), FTop.Height,
          Self.ClientWidth -FRight.Width, FTop.Height+SrcRect.Height{FTop.Height})
      else
      fbutonarea := Rect(Fleft.Width, FTop.Height,SrcRect.Width, FTop.Height+SrcRect.Height);//FTop.Height);


      DrawPartnormal(SrcRect, self, fbutonarea, alpha);

      if Length(Caption) > 0 then
      begin
        if fbutondirection=obleft then
        Fcaptionarea.Targetrect.left +=fbutonarea.Width;

        resim.TextRect(Fcaptionarea.Targetrect{captionrect},Caption,taCenter,tlCenter,ColorToBGRA(self.font.color,alpha));
      end;



      if Crop then
        CropToimg(resim);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;

end;






{ TONPanel }

constructor TONURPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'panel';
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

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Self.Height := 190;
  Self.Width := 190;
  resim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------
destructor TONURPanel.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;

  inherited Destroy;
end;
// -----------------------------------------------------------------------------

procedure TONURPanel.Paint;
begin
  if not Visible then exit;
//  if csDesigning in ComponentState then
//    exit;
  resim.SetSize(0,0);
  resim.SetSize(self.ClientWidth, self.ClientHeight);
//  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
       //TOPLEFT   //SOLÜST
       DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
      //TOPRIGHT //SAĞÜST
       DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
       //TOP  //ÜST
       DrawPartnormal(ftop.Croprect, self, FTop.Targetrect, alpha);
       //BOTTOMLEFT // SOLALT
       DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
       //BOTTOMRIGHT  //SAĞALT
       DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
       //BOTTOM  //ALT
       DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
       //LEFT CENTERLEFT // SOLORTA
       DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
       //CENTERRIGHT // SAĞORTA
       DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
       //CENTER //ORTA
        DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);

      if Crop then
        CropToimg(resim);
    finally

    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;
end;

procedure TONURPanel.SetSkindata(Aimg: TONURImg);
Begin
  inherited SetSkindata(Aimg);
  FTopleft.Targetrect  := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Width, 0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect:= Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Height, FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);

  FRight.Targetrect := Rect(self.clientWidth - FRight.Width,FTopRight.Height, self.clientWidth, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width, self.clientHeight -FBottom.Height);
  self.ChildSizing.LeftRightSpacing:=Fleft.Width;
  self.ChildSizing.TopBottomSpacing:=FTop.Height;
End;

//-----------------------------------------------------------------------------


{ TONGraphicPanel }

procedure TONURGraphicPanel.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  FTopleft.Targetrect  := Rect(0, 0, FTopleft.Width,FTopleft.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Width, 0, self.clientWidth, FTopRight.Height);
  ftop.Targetrect:= Rect(FTopleft.Width, 0, self.clientWidth - FTopRight.Width, FTop.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Height, FBottomleft.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Width,  self.clientHeight - FBottomRight.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.Width,self.clientHeight - FBottom.Height, self.clientWidth - FBottomRight.Width, self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.Height,Fleft.Width, self.clientHeight - FBottomleft.Height);
  FRight.Targetrect := Rect(self.clientWidth - FRight.Width,FTopRight.Height, self.clientWidth, self.clientHeight - FBottomRight.Height);
  FCenter.Targetrect := Rect(Fleft.Width, FTop.Height, self.clientWidth - FRight.Width, self.clientHeight -FBottom.Height);


end;

constructor TONURGraphicPanel.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  skinname := 'graphicpanel';
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

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
   Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Self.Height := 190;
  Self.Width := 190;
  resim.SetSize(Width, Height);
end;

// -----------------------------------------------------------------------------
destructor TONURGraphicPanel.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
{begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft); }
  inherited Destroy;
end;

procedure TONURGraphicPanel.Paint;
begin
//  if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;
  resim.SetSize(0,0);
  resim.SetSize(self.Width, self.Height);
//  if (Skindata <> nil){ or (FSkindata.Fimage <> nil)} then
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
     //TOPLEFT   //SOLÜST
     DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
     //TOPRIGHT //SAĞÜST
     DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
     //TOP  //ÜST
     DrawPartnormal(ftop.Croprect, self, FTop.Targetrect,alpha);
     //BOTTOMLEFT // SOLALT
     DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
     //BOTTOMRIGHT  //SAĞALT
     DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
     //BOTTOM  //ALT
     DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
     //LEFT CENTERLEFT // SOLORTA
     DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
     //CENTERRIGHT // SAĞORTA
     DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
     //CENTER //ORTA
     DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);
    finally
      //  FreeAndNil(img);
    end;
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;
  inherited Paint;
end;




{ TONURHeaderPanel }

function TONURHeaderPanel.getMovable: Boolean;
begin
  Result:=fmoveable;
end;

procedure TONURHeaderPanel.SetMovable(AValue: Boolean);
begin
  if AValue<> fmoveable then
  fmoveable := AValue;
end;

procedure TONURHeaderPanel.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);

  if (GetKeyState(VK_LBUTTON) < 0) and (fmoveable = true) then
  begin
    //self.Parent.left
    GetParentForm(self).left:= Mouse.CursorPos.X - (FMousePoint.X - FFormPoint.X);
    //self.Parent.top
    GetParentForm(self).top:= Mouse.CursorPos.Y - (FMousePoint.Y - FFormPoint.Y);
  end;
end;

procedure TONURHeaderPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (GetKeyState(VK_LBUTTON) < 0) and (fmoveable = true) then
  begin
    FMousePoint := Mouse.CursorPos;
    FFormPoint  := Point(GetParentForm(self).Left, GetParentForm(self).Top);
    //Point(self.Parent.Left, self.Parent.Top);
  end;
end;

constructor TONURHeaderPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname  := 'headerpanel';
  fmoveable := true;
  Height := 32;
  Align := alTop;
  ChildSizing.HorizontalSpacing := 3;
  ChildSizing.LeftRightSpacing := 4;
  ChildSizing.TopBottomSpacing := 4;

end;
end.

unit onurpanel;

{$mode objfpc}{$H+}


interface

uses
 {$IFDEF UNIX} UNIX,LMessages {$ELSE} Windows{$ENDIF}, SysUtils,  Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes,
  Dialogs, types, LazUTF8, Zipper,onurctrl;

type

  { TONPanel }

  TONURPanel = class(TONURCustomControl)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    procedure SetSkindata(Aimg: TONURImg); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;


    //Procedure Resizepanel;
    property OLEFT        : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP read FTopRight    write FTopRight;
    protected
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


  { TONHeaderPanel }

  TONURHeaderPanel = class(TONURPanel)
  private
  public
    constructor Create(AOwner: TComponent); override;
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

  TONURCollapExpandPanel = class(TonURCustomcontrol)
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
    FexNormal        : TONURCUSTOMCROP;
    FexPress         : TONURCUSTOMCROP;
    FexEnter         : TONURCUSTOMCROP;
    Fexdisable       : TONURCUSTOMCROP;
    //Procedure Resizecollapsedpanel;
    procedure Setheaderstate(AValue: TONURCapDirection);
    procedure SetStatus(const AValue: TONURExpandStatus);
    procedure SetAutoCollapse(const AValue: boolean);
    procedure SetOnCollapse(const AValue: TNotifyEvent);
    procedure SetOnExpand(const AValue: TNotifyEvent);
    function GetMinheight: integer;
    function GetNormalheight: integer;
    procedure Setminheight(const Avalue: integer);
    procedure Setnormalheight(const Avalue: integer);
    procedure ResizePanel();
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X: integer; Y: integer); override;
    procedure CMonmouseenter(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} ); message CM_MOUSEENTER;
    procedure CMonmouseleave(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} ); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure SetSkindata(Aimg: TONURImg); override;
  protected
    procedure DblClick; override;
   public
    property OLEFT         : TONURCUSTOMCROP      read Fleft           write Fleft;
    property ORIGHT        : TONURCUSTOMCROP      read FRight          write FRight;
    property OCENTER       : TONURCUSTOMCROP      read FCenter         write FCenter;
    property OBOTTOM       : TONURCUSTOMCROP      read FBottom         write FBottom;
    property OBOTTOMLEFT   : TONURCUSTOMCROP      read FBottomleft     write FBottomleft;
    property OBOTTOMRIGHT  : TONURCUSTOMCROP      read FBottomRight    write FBottomRight;
    property OTOP          : TONURCUSTOMCROP      read FTop            write FTop;
    property OTOPLEFT      : TONURCUSTOMCROP      read FTopleft        write FTopleft;
    property OTOPRIGHT     : TONURCUSTOMCROP      read FTopRight       write FTopRight;
    property ONORMAL       : TONURCUSTOMCROP      read FNormal         write FNormal;
    property OPRESSED      : TONURCUSTOMCROP      read FPress          write FPress;
    property OHOVER        : TONURCUSTOMCROP      read FEnter          write FEnter;
    property ODISABLE      : TONURCUSTOMCROP      read Fdisable        write Fdisable;
    property OEXNORMAL     : TONURCUSTOMCROP      read FexNormal       write FexNormal;
    property OEXPRESSED    : TONURCUSTOMCROP      read FexPress        write FexPress;
    property OEXHOVER      : TONURCUSTOMCROP      read FexEnter        write FexEnter;
    property OEXDISABLE    : TONURCUSTOMCROP      read Fexdisable      write Fexdisable;
    property OCAPTION      : TONURCUSTOMCROP      read Fcaptionarea    write Fcaptionarea;

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
    property Minheight      : integer              read GetMinheight    write Setminheight;
    property Normalheight   : integer              read GetNormalheight write Setnormalheight;
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
    property OLEFT        : TONURCUSTOMCROP read Fleft        write Fleft;
    property ORIGHT       : TONURCUSTOMCROP read FRight       write FRight;
    property OCENTER      : TONURCUSTOMCROP read FCenter      write FCenter;
    property OBOTTOM      : TONURCUSTOMCROP read FBottom      write FBottom;
    property OBOTTOMLEFT  : TONURCUSTOMCROP read FBottomleft  write FBottomleft;
    property OBOTTOMRIGHT : TONURCUSTOMCROP read FBottomRight write FBottomRight;
    property OTOP         : TONURCUSTOMCROP read FTop         write FTop;
    property OTOPLEFT     : TONURCUSTOMCROP read FTopleft     write FTopleft;
    property OTOPRIGHT    : TONURCUSTOMCROP read FTopRight    write FTopRight;
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



procedure Register;



implementation

uses BGRAPath, inifiles, clipbrd, strutils, LazUnicode,BGRAFreeType, LazFreeTypeFontCollection,BGRATransform;

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

function TONURCollapExpandPanel.GetMinheight: integer;
begin
  Result := fminheight;
end;

function TONURCollapExpandPanel.GetNormalheight: integer;
begin
  Result := fnormalheight;
end;

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

procedure TONURCollapExpandPanel.CMonmouseenter(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} );
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
 { end
  else
  begin
    if Fstate=obshover then
    begin
      Fstate := obsnormal;
      Invalidate;
    end;  }
  end;
end;

procedure TONURCollapExpandPanel.CMonmouseleave(var Messages: {$IFDEF UNIX} TLmessage {$ELSE} Tmessage{$ENDIF} );
// var
//   aPnt: TPoint;
begin
  //   GetCursorPos(aPnt);
  //   aPnt := ScreenToClient(aPnt);
  //  if PtInRect(fbutonarea, aPnt) then
  //   begin
  if Fstate=obsnormal then exit;
  if Enabled=false then exit;
  Fstate := obsnormal;
  Invalidate;
  //   end;
end;

procedure TONURCollapExpandPanel.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited mousemove(shift, x, y);
  if enabled=false then exit;
  if fstate=obsnormal then exit;

 { if not PtInRect(fbutonarea, Point(X, Y)) then
  begin
    Fstate := obsnormal;
    Invalidate;
  end else
  begin    }
   if PtInRect(fbutonarea, Point(X, Y)) then
   begin
    Fstate := obshover;
    Invalidate;
   end;
//  end;
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
{begin
  FreeAndNil(Fleft);
  FreeAndNil(FTop);
  FreeAndNil(FRight);
  FreeAndNil(FBottom);
  FreeAndNil(FTopleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FCenter);
  FreeAndNil(FNormal);
  FreeAndNil(FPress);
  FreeAndNil(FEnter);
  FreeAndNil(Fdisable);
  FreeAndNil(Fcaptionarea);  }
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
SrcRect,captionrect: TRect;

begin
//   if csDesigning in ComponentState then
//    exit;
  if not Visible then exit;
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
            SrcRect := FNormal.Croprect;// Rect(FNormal.FSLeft, FNormal.FSTop,FNormal.FSRight, FNormal.FSBottom);
          end;
          obspressed:
          begin
            SrcRect := FPress.Croprect;//Rect(FPress.FSLeft, FPress.FSTop,FPress.FSRight, FPress.FSBottom);
          end;
          obshover:
          begin
            SrcRect := FEnter.Croprect;//Rect(FEnter.FSLeft, FEnter.FSTop,FEnter.FSRight, FEnter.FSBottom);
          end;
        end;
      end
      else
      begin
        SrcRect := Fdisable.Croprect;//Rect(Fdisable.FSLeft, Fdisable.FSTop, Fdisable.FSRight,Fdisable.FSBottom);
      end;



      if fbutondirection = obright then
        fbutonarea := Rect(Self.ClientWidth - (FRight.Width+SrcRect.Width), FTop.Height,
          Self.ClientWidth -FRight.Width, FTop.Height+SrcRect.Height{FTop.Height})
      else
      fbutonarea := Rect(Fleft.Width, FTop.Height,SrcRect.Width, FTop.Height+SrcRect.Height);//FTop.Height);




      DrawPartnormal(SrcRect, self, fbutonarea, alpha);

      if Length(Caption) > 0 then
      begin
        //          canvas.Font.Color := self.Fontcolor;
      //  textx := (self.Width div 2) - (self.canvas.TextWidth(Caption) div 2);
      //  Texty := ((FTop.FSBottom - FTop.FSTop) div 2) -
      //    (self.canvas.TextHeight(Caption) div 2);

     //   WriteLn(captionrect.Width,'  ');

       // captionrect.Width:=captionrect.Width-fbutonarea.Width;

      //  if fbutondirection=obleft then
     //   captionrect.Left:=captionrect.Left+fbutonarea.Width;

     //   captionrect.Height:=fbutonarea.Height;

      //  captionrect:=rect((Fleft.FSright - Fleft.FSLeft),(FTop.FSBottom - FTop.FSTop),Self.Width-(FRight.FSright - FRight.FSLeft),fbutonarea.Height);
        if fbutondirection=obleft then      // captionrect.Left:=captionrect.Left+fbutonarea.Width;
        Fcaptionarea.Targetrect.left +=fbutonarea.Width;

        resim.TextRect(captionrect,Caption,taCenter,tlCenter,ColorToBGRA(self.font.color,alpha));

        //Fresim.CanvasBGRA.Brush.Style := bsClear;
        //Fresim.TextOut(textx,texty,Caption,ColorToBGRA(self.font.color));// CanvasBGRA.TextOut(Textx, Texty, (Caption));
      end;
       //WriteLn(captionrect.Left,'  ',captionrect.Width,'  ',self.Width);

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



{ TONURHeaderPanel }

constructor TONURHeaderPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  skinname := 'headerpanel';
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
{begin
  FreeAndNil(FBottom);
  FreeAndNil(FTop);
  FreeAndNil(FCenter);
  FreeAndNil(FRight);
  FreeAndNil(FBottomRight);
  FreeAndNil(FTopRight);
  FreeAndNil(Fleft);
  FreeAndNil(FBottomleft);
  FreeAndNil(FTopleft);}
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
end.

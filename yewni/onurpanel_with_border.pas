unit onurpanel_with_border;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,LMessages,{$ELSE}unix, LCLIntf,LCLType,{$ENDIF} SysUtils, Classes, Controls, Graphics, 
  BGRABitmap, BGRABitmapTypes, onurctrl;

type
  TONURBorderedPanel = class(TONURCustomControl)
  private
    Fleft, FTopleft, FBottomleft, FRight, FTopRight, FBottomRight,
    FTop, FBottom, FCenter: TONURCUSTOMCROP;
    FBorderColor: TColor;
    FBorderWidth: Integer;
    FBorderStyle: TPenStyle;
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderWidth(Value: Integer);
    procedure SetBorderStyle(Value: TPenStyle);
  protected
    procedure SetSkindata(Aimg: TONURImg); override;
    procedure Resize; override;
    procedure Resizing;
  public
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
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlue;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 2;
    property BorderStyle: TPenStyle read FBorderStyle write SetBorderStyle default psSolid;
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

procedure Register;
begin
  RegisterComponents('ONUR', [TONURBorderedPanel]);
end;

{ TONURBorderedPanel }

constructor TONURBorderedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  // Border properties
  FBorderColor := clBlue;
  FBorderWidth := 2;
  FBorderStyle := psSolid;
  
  // Skin parts
  FTop := TONURCUSTOMCROP.Create('TOP');
  FBottom := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter := TONURCUSTOMCROP.Create('CENTER');
  FRight := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft := TONURCUSTOMCROP.Create('LEFT');
  FTopleft := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  
  // Add to custom crop list
  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);
  
  // Set default size
  Height := 200;
  Width := 300;
  Skinname := 'borderedpanel';
  
  Resizing;
end;

destructor TONURBorderedPanel.Destroy;
var
  i: byte;
begin
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;
  
  Customcroplist.Clear;
  inherited Destroy;
end;

procedure TONURBorderedPanel.SetBorderColor(Value: TColor);
begin
  if FBorderColor = Value then Exit;
  FBorderColor := Value;
  Invalidate;
end;

procedure TONURBorderedPanel.SetBorderWidth(Value: Integer);
begin
  if FBorderWidth = Value then Exit;
  FBorderWidth := Value;
  Invalidate;
end;

procedure TONURBorderedPanel.SetBorderStyle(Value: TPenStyle);
begin
  if FBorderStyle = Value then Exit;
  FBorderStyle := Value;
  Invalidate;
end;

procedure TONURBorderedPanel.SetSkindata(Aimg: TONURImg);
begin
  inherited SetSkindata(Aimg);
  if Assigned(Skindata) then
    Resizing;
end;

procedure TONURBorderedPanel.Resize;
begin
  inherited Resize;
  if Assigned(Skindata) then
    Resizing;
end;

procedure TONURBorderedPanel.Resizing;
begin
  if not Assigned(Skindata) then Exit;
  
  FTopleft.Targetrect := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  FTopRight.Targetrect := Rect(self.clientWidth - FTopRight.Croprect.Width, 0, self.clientWidth, FTopRight.Croprect.Height);
  FTop.Targetrect := Rect(FTopleft.Croprect.Width, 0, self.clientWidth - FTopRight.Croprect.Width, FTop.Croprect.Height);
  FBottomleft.Targetrect := Rect(0, self.ClientHeight - FBottomleft.Croprect.Height, FBottomleft.Croprect.Width, self.ClientHeight);
  FBottomRight.Targetrect := Rect(self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight - FBottomRight.Croprect.Height, self.clientWidth, self.clientHeight);
  FBottom.Targetrect := Rect(FBottomleft.Croprect.Width, self.clientHeight - FBottom.Croprect.Height, self.clientWidth - FBottomRight.Croprect.Width, self.clientHeight);
  Fleft.Targetrect := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width, self.clientHeight - FBottomleft.Croprect.Height);
  FRight.Targetrect := Rect(self.clientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height, self.clientWidth, self.clientHeight - FBottomRight.Croprect.Height);
  FCenter.Targetrect := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, self.clientWidth - FRight.Croprect.Width, self.clientHeight - FBottom.Croprect.Height);
end;

procedure TONURBorderedPanel.Paint;
begin
  if not Visible then Exit;
  
  resim.SetSize(0, 0);
  resim.SetSize(self.Width, self.Height);
  
  // Draw skin parts if available
  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    try
      // Draw 9-part skin
      DrawPartnormal(FTopleft.Croprect, self, FTopleft.Targetrect, alpha);
      DrawPartnormal(FTopRight.Croprect, self, FTopRight.Targetrect, alpha);
      DrawPartnormal(ftop.Croprect, self, FTop.Targetrect, alpha);
      DrawPartnormal(FBottomleft.Croprect, self, FBottomleft.Targetrect, alpha);
      DrawPartnormal(FBottomRight.Croprect, self, FBottomRight.Targetrect, alpha);
      DrawPartnormal(FBottom.Croprect, self, FBottom.Targetrect, alpha);
      DrawPartnormal(Fleft.Croprect, self, Fleft.Targetrect, alpha);
      DrawPartnormal(FRight.Croprect, self, FRight.Targetrect, alpha);
      DrawPartnormal(Fcenter.Croprect, self, FCenter.Targetrect, alpha);
    finally
    end;
  end
  else
  begin
    // Fill background
    resim.Fill(BGRA(ColorToRGB(Color), alpha), dmSet);
    
    // Draw border
    if FBorderWidth > 0 then
    begin
      resim.Pen.Color := FBorderColor;
      resim.Pen.Width := FBorderWidth;
      resim.Pen.Style := FBorderStyle;
      
      // Draw border rectangle
      resim.Rectangle(FBorderWidth div 2, FBorderWidth div 2, 
                      Width - FBorderWidth div 2, Height - FBorderWidth div 2);
    end;
  end;
  
  // Draw caption
  if Caption <> '' then
  begin
    resim.Font.Color := Font.Color;
    resim.Font.Name := Font.Name;
    resim.Font.Size := Font.Size;
    resim.Font.Style := [];
    
    var TextRect := Rect(10, 10, Width - 10, Height - 10);
    resim.TextRect(TextRect, Caption, taLeftJustify, taTop);
  end;
  
  inherited Paint;
end;

end.

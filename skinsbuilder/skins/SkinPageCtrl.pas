
{*******************************************************************}
{                                                                   }
{       SkinEngine                                                  }
{       Version 1                                                   }
{                                                                   }
{       Copyright (c) 1998-2003 Evgeny Kryukov                      }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT KS DEVELOPMENT WRITTEN   }
{   CONSENT AND PERMISSION FROM KS DEVELOPMENT.                     }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{   DISTRIBUTION OF THIS FILE IS NOT ALLOWED!                       }
{                                                                   }
{       Home:  http://www.ksdev.com                                 }
{       Support: support@ksdev.com                                  }
{       Questions: faq@ksdev.com                                    }
{                                                                   }
{*******************************************************************}
{
 $Id: SkinPageCtrl.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinPageCtrl;

{$I KSSKIN.INC}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls,
     CommCtrl, ComCtrls, SkinConst, SkinSource, SkinTypes, SkinObjects,
     SkinEngine, SkinUtils;

type

{ TscPageControl }

  TscPageControl = class(TPageControl)
  private
    FSkinEngine: TscSkinEngine;
    FSkinPageControl: TscSkinObject;
    { Messages }
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    { Drawing }
    procedure DrawTabs;
    procedure DrawBorder;
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
    function GetItemRect(index: integer): TRect;
    { Skin support }
    procedure SetSkinEngine(const Value: TscSkinEngine);
    procedure WMSkinChange(var Msg: TMessage); message WM_SKINCHANGE;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PaintWindow(DC: HDC); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActivePage;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotTrack;
    property Images;
    property MultiLine;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RaggedRight;
    property SkinEngine: TscSkinEngine read FSkinEngine write SetSkinEngine;
    property ScrollOpposite;
    property ShowHint;
    property TabHeight;
    property TabOrder;
//    property TabPosition;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

{ TscTabControl }

  TscTabControl = class(TCustomTabControl)
  private
    FSkinEngine: TscSkinEngine;
    FSkinTabControl: TscSkinObject;
    { Messages }
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    { Drawing }
    procedure DrawTabs;
    procedure DrawBorder;
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
    function GetItemRect(index: integer): TRect;
    { Skin support }
    procedure SetSkinEngine(const Value: TscSkinEngine);
    procedure WMSkinChange(var Msg: TMessage); message WM_SKINCHANGE;

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PaintWindow(DC: HDC); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotTrack;
    property Images;
    property MultiLine;
    property MultiSelect;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RaggedRight;
    property SkinEngine: TscSkinEngine read FSkinEngine write SetSkinEngine;
    property ScrollOpposite;
    property ShowHint;
    property TabHeight;
    property TabOrder;
//    property TabPosition;
    property Tabs;
    property TabIndex;  // must be after Tabs
    property TabStop;
    property TabWidth;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation {===============================================================}

uses Consts, ComStrs;

{ TscPageControl }

constructor TscPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if (csDesigning in ComponentState) and (Owner is TForm) then
    FSkinEngine := GetSkinEngine(AOwner);

  FSkinPageControl := TscSkinObject.Create;
end;

destructor TscPageControl.Destroy;
begin
  if FSkinPageControl <> nil then FSkinPageControl.Free;
  inherited Destroy;
end;

procedure TscPageControl.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.PageControl <> nil) and
     (FSkinEngine.SkinSource.PageControl.ChildCount > 0) and
     not (csDesigning in ComponentState)
  then
  begin
    if Msg.DC <> 0 then
      PaintBackgroundEx(Self, Msg.DC)
    else
      PaintBackground(Self, Canvas);
    Msg.Result := 0;
  end
  else
    inherited ;
end;

{ Utils }

function TscPageControl.GetItemRect(index: integer): TRect;
var
  R: TRect;
begin
  SendMessage(Handle, TCM_GETITEMRECT, index, Integer(@R));
  Result := R;
end;

{ Drawing }

procedure TscPageControl.PaintWindow(DC: HDC);
var
  SaveIndex: Integer;
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.PageControl <> nil) and
     (FSkinEngine.SkinSource.PageControl.ChildCount > 0) and
     not (csDesigning in ComponentState)
  then
  begin
    SaveIndex := SaveDC(DC);
    try
      Canvas.Handle := DC;
      Canvas.Font := Font;
      Canvas.Brush := Brush;
      DrawBorder;
      DrawTabs;
      Canvas.Handle := 0;
    finally
      RestoreDC(DC, SaveIndex);
    end;
  end
  else
    inherited ;
end;

procedure TscPageControl.DrawBorder;
var
  R: TRect;
  SkinObject: TscSkinObject;
begin
  with Canvas do
  begin
    R := DisplayRect;
    InflateRect(R, 4, 4);
    Dec(R.Top);
    { Draw border }
    SkinObject := FSkinPageControl.FindObjectByKind(skPageControlClient);
    if SkinObject <> nil then
    begin
      SkinObject.BoundsRect := R;
      SkinObject.Draw(Canvas);
    end;
  end;
end;

procedure TscPageControl.DrawTabs;
var
  i: integer;
  R: TRect;
begin
  for i := 0 to PageCount-1 do
  begin
    if not CanShowTab(i) then Continue;
    R := GetItemRect(i);
    Inc(R.Bottom);
    DrawTab(i, R, i = TabIndex);
  end;
end;

var
  PCEnabled: boolean;
  PCVisible: TscVisibleSet;

procedure TscPageControl.DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
 procedure SetVisible(SkinObject: TscSkinObject);
 begin
   SkinObject.Enabled := PCEnabled;
   if svAlways in SkinObject.Visible then
   begin
     SkinObject.VisibleNow := true;
     Exit;
   end;
   // State is set
   if PCVisible - SkinObject.Visible = [] then
     SkinObject.VisibleNow := true
   else
     SkinObject.VisibleNow := false;
 end;
var
  SkinObject: TscSkinObject;
begin
  with Canvas do
  begin
    { Draw tab }
    SkinObject := FSkinPageControl.FindObjectByKind(skPageControlTab);
    { Set Visible }
    if Active then
      PCVisible := [svTabActive]
    else
      PCVisible := [svTabNoActive];
    PCEnabled := Enabled;
    FSkinPageControl.CallObject(@SetVisible);
    { Draw }
    if SkinObject <> nil then
    begin
      SkinObject.FontName := Font.Name;
      SkinObject.FontSize := Font.Size;
      SkinObject.FontStyle := Font.Style;
      SkinObject.Text := Pages[TabIndex].Caption;
      SkinObject.BoundsRect := Rect;
      SkinObject.Draw(Canvas);
    end;
  end;
end;

{ Skin support }

procedure TscPageControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FSkinEngine) then
    FSkinEngine := nil;
end;

procedure TscPageControl.SetSkinEngine(const Value: TscSkinEngine);
begin
  FSkinEngine := Value;
  if FSkinEngine <> nil then
    SendMessage(Handle, WM_SKINCHANGE, 0, 0);
end;

procedure TscPageControl.WMSkinChange(var Msg: TMessage);
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.PageControl <> nil) and
     (FSkinEngine.SkinSource.PageControl.ChildCount > 0)
  then
  begin
    FSkinPageControl.Assign(FSkinEngine.SkinSource.PageControl);
    if FSkinPageControl.FindObjectByKind(skPageControlClient) <> nil then
      Color := FSkinPageControl.FindObjectByKind(skPageControlClient).Color;
  end
  else
  begin
    FSkinPageControl.Free;
    FSkinPageControl := TscSkinObject.Create;
  end;
  Invalidate;
end;

{ TscTabControl ==============================================================}

constructor TscTabControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if (csDesigning in ComponentState) and (Owner is TForm) then
    FSkinEngine := GetSkinEngine(AOwner);

  FSkinTabControl := TscSkinObject.Create;
end;

destructor TscTabControl.Destroy;
begin
  if FSkinTabControl <> nil then FSkinTabControl.Free;
  inherited Destroy;
end;

procedure TscTabControl.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 0;
end;

{ Utils }

function TscTabControl.GetItemRect(index: integer): TRect;
var
  R: TRect;
begin
  SendMessage(Handle, TCM_GETITEMRECT, index, Integer(@R));
  Result := R;
end;

{ Drawing }

procedure TscTabControl.WMPaint(var Msg: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
begin
  DC := GetDC(0);
  MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
  ReleaseDC(0, DC);
  MemDC := CreateCompatibleDC(0);
  OldBitmap := SelectObject(MemDC, MemBitmap);
  try
    DC := BeginPaint(Handle, PS);

    Msg.DC := MemDC;

    PaintBackgroundEx(Self, Msg.DC);
    PaintWindow(Msg.DC);
    PaintHandler(Msg);

    Msg.DC := 0;
    BitBlt(DC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0, 0, SRCCOPY);
    EndPaint(Handle, PS);
  finally
    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    DeleteObject(MemBitmap);
  end;
end;

procedure TscTabControl.PaintWindow(DC: HDC);
var
  SaveIndex: Integer;
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.PageControl <> nil) and
     (FSkinEngine.SkinSource.PageControl.ChildCount > 0) and
     not (csDesigning in ComponentState)
  then
  begin
    SaveIndex := SaveDC(DC);
    try
      Canvas.Handle := DC;
      Canvas.Font := Font;
      Canvas.Brush := Brush;
      DrawBorder;
      DrawTabs;
      Canvas.Handle := 0;
    finally
      RestoreDC(DC, SaveIndex);
    end;
  end
  else
    inherited ;
end;

procedure TscTabControl.DrawBorder;
var
  R: TRect;
  SkinObject: TscSkinObject;
begin
  with Canvas do
  begin
    R := DisplayRect;
    InflateRect(R, 4, 4);
    Dec(R.Top);
    { Draw border }
    SkinObject := FSkinTabControl.FindObjectByKind(skPageControlClient);
    if SkinObject <> nil then
    begin
      SkinObject.BoundsRect := R;
      SkinObject.Draw(Canvas);
    end;
  end;
end;

procedure TscTabControl.DrawTabs;
var
  i: integer;
  R: TRect;
begin
  for i := 0 to Tabs.Count-1 do
  begin
    if not CanShowTab(i) then Continue;
    R := GetItemRect(i);
    Inc(R.Bottom);
    DrawTab(i, R, i = TabIndex);
  end;
end;

var
  TCEnabled: boolean;
  TCVisible: TscVisibleSet;

procedure TscTabControl.DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
 procedure SetVisible(SkinObject: TscSkinObject);
 begin
   SkinObject.Enabled := TCEnabled;
   if svAlways in SkinObject.Visible then
   begin
     SkinObject.VisibleNow := true;
     Exit;
   end;
   // State is set
   if TCVisible - SkinObject.Visible = [] then
     SkinObject.VisibleNow := true
   else
     SkinObject.VisibleNow := false;
 end;
var
  SkinObject: TscSkinObject;
begin
  with Canvas do
  begin
    { Draw tab }
    SkinObject := FSkinTabControl.FindObjectByKind(skPageControlTab);
    { Set Visible }
    if Active then
      TCVisible := [svTabActive]
    else
      TCVisible := [svTabNoActive];
    TCEnabled := Enabled;
    FSkinTabControl.CallObject(@SetVisible);
    { Draw }
    if SkinObject <> nil then
    begin
      SkinObject.FontName := Font.Name;
      SkinObject.FontSize := Font.Size;
      SkinObject.FontStyle := Font.Style;
      SkinObject.Text := Tabs[TabIndex];
      SkinObject.BoundsRect := Rect;
      SkinObject.Draw(Canvas);
    end;
  end;
end;

{ Skin support }

procedure TscTabControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FSkinEngine) then
    FSkinEngine := nil;
end;

procedure TscTabControl.SetSkinEngine(const Value: TscSkinEngine);
begin
  FSkinEngine := Value;
  if FSkinEngine <> nil then
    SendMessage(Handle, WM_SKINCHANGE, 0, 0);
end;

procedure TscTabControl.WMSkinChange(var Msg: TMessage);
begin
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.SkinSource.PageControl <> nil) and
     (FSkinEngine.SkinSource.PageControl.ChildCount > 0)
  then
  begin
    FSkinTabControl.Assign(FSkinEngine.SkinSource.PageControl);
    if FSkinTabControl.FindObjectByKind(skPageControlClient) <> nil then
      Color := FSkinTabControl.FindObjectByKind(skPageControlClient).Color;
  end
  else
  begin
    FSkinTabControl.Free;
    FSkinTabControl := TscSkinObject.Create;
  end;
  Invalidate;
end;

end.

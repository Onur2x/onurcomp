
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
 $Id: SkinMenuWnd.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinMenuWnd;

//{$I KSSKIN.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, StdCtrls, ExtCtrls, bilesenutil, bilesenim, sikinkodu;

const

  GlyphWidth            = 22;
  CheckWidth            = 16;
  ShortCutWidth         = 32;

type

{ TscMenuItemObject }

  TscMenuItemObject = class(TscSkinObject)
  private
    FChecked: boolean;
    FRadioChecked: boolean;
    FSubMenu: boolean;
    FImageIndex: integer;
    FBitmap: TBitmap;
    FImages: TCustomImageList;
  public
    procedure Draw(Canvas: TCanvas); override;
    { glyph }
    property Images: TCustomImageList read FImages write FImages;
    property ImageIndex: integer read FImageIndex write FImageIndex;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    { markers }
    property Checked: boolean read FChecked write FChecked;
    property RadioChecked: boolean read FRadioChecked write FRadioChecked;
    property SubMenu: boolean read FSubMenu write FSubMenu; 
  end;

{ TscMenuWnd }

  TscMenuWnd = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FItems: TMenuItem;
    FMenu: TPopupMenu;

    FMenuWnd: TscMenuWnd;
    FParentMenuWnd: TscMenuWnd;

    FTimer: TTimer;
    FSkinSource: TscSkinSource;
    FSkinEngine: TComponent;
    FPopupMenu: TscSkinPopupMenu;
    FMouseObject: TscSkinObject;
    FBusy, FActiveBusy: boolean;
    FItemRect: TRect;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMKeyDown(var Msg: TWMKeyDown); message WM_KEYDOWN;
    { Idle processes }
    procedure DoTimer(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { paint menu window }
    procedure Paint; override;
    { SkinMenuItem }
    procedure CreateSkinItems;
    { Cacl menu size }
    procedure CalcSize;
    { popup }
    procedure Popup(X, Y: integer);
    property ItemRect: TRect read FItemRect write FItemRect;
    { properies }
    property Items: TMenuItem read FItems write FItems;
    property Menu: TPopupMenu read FMenu write FMenu;
    property SkinEngine: TComponent read FSkinEngine write FSkinEngine;
    property SkinSource: TscSkinSource read FSkinSource write FSkinSource;
  end;

var
  scMenuWnd: TscMenuWnd;

implementation {===============================================================}

uses sikinkaydi,skinana, resim;

var
  GSkinEngine: TscSkinEngine;

{$R *.DFM}
{$R *.res}

var
  CheckBmp: TksBmp;
  RadioBmp: TksBmp;
  SubBmp: TksBmp;

{ TscMenuItemObject ===========================================================}

procedure TscMenuItemObject.Draw(Canvas: TCanvas);
var
  i, j: integer;
  X, Y: integer;
begin
  inherited Draw(Canvas);
  if FChecked then
  begin
    X := Left + 2;
    Y := Top + (Height - CheckBmp.Height) div 2;
    for i := 0 to CheckBmp.Width-1 do
      for j := 0 to CheckBmp.Height-1 do
        if CheckBmp.Pixels[j, i].R = 0 then
          Canvas.Pixels[X+i, Y+j] := TextColor;
    Exit;
  end;
  if FRadioChecked then
  begin
    X := Left + 2;
    Y := Top + (Height - RadioBmp.Height) div 2;
    for i := 0 to RadioBmp.Width-1 do
      for j := 0 to RadioBmp.Height-1 do
        if RadioBmp.Pixels[j, i].R = 0 then
          Canvas.Pixels[X+i, Y+j] := TextColor;
    Exit;
  end;
  if FSubMenu then
  begin
    X := Left + Width - SubBmp.Height - 2;
    Y := Top + (Height - SubBmp.Height) div 2;
    for i := 0 to SubBmp.Width-1 do
      for j := 0 to SubBmp.Height-1 do
        if SubBmp.Pixels[j, i].R = 0 then
          Canvas.Pixels[X+i, Y+j] := TextColor;
  end;
  { Draw glyph from FBitmap }
  if (FBitmap <> nil) and not FBitmap.Empty then
  begin
    X := Left + 1;
    Y := Top + (Height - FBitmap.Height) div 2;
    FBitmap.Transparent := true;
    Canvas.Draw(X, Y, FBitmap);
  end;
  { Draw glyph from FImages }
  if (FImages <> nil) and (FImageIndex > -1) and (FImageIndex < FImages.Count) then
  begin
    X := Left + 1;
    Y := Top + (Height - FImages.Height) div 2;
    FImages.Draw(Canvas, X, Y, FImageIndex, Enabled)
  end;
end;

function GetHotkey(const Text: string): string;
var
  I, L: Integer;
begin
  Result := '';
  I := 1;
  L := Length(Text);
  while I <= L do
  begin
    if Text[I] in LeadBytes then
      Inc(I)
    else if (Text[I] = '&') and
            (L - I >= 1) then
    begin
      Inc(I);
      if Text[I] <> '&' then
        Result := Text[I]; // keep going there may be another one
    end;
    Inc(I);
  end;
end;

{ TscMenuWnd ==================================================================}

constructor TscMenuWnd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPopupMenu := TscSkinPopupMenu.Create;

  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := DoTimer;
  FTimer.Interval := 20;
  FTimer.Enabled := true;
end;

destructor TscMenuWnd.Destroy;
begin
  FTimer.Enabled := false;
  FTimer.Free;
  if FParentMenuWnd <> nil then
    FParentMenuWnd.FMenuWnd := nil;
  if FMenuWnd <> nil then
  begin
    FMenuWnd.Free;
    FMenuWnd := nil;
  end;
  FPopupMenu.Free;
  inherited Destroy;
end;

{ Create skin items ===========================================================}

procedure TscMenuWnd.CreateSkinItems;
var
  i: integer;
  SkinItem: TscMenuItemObject;
  W, H: integer; // Non client width and height
begin
  if FItems = nil then Exit;

  FPopupMenu.MenuItem.VisibleNow := false;

  for i := 0 to FItems.Count-1 do
  begin
    SkinItem := TscMenuItemObject.Create;
    SkinItem.Assign(FPopupMenu.MenuItem);
    SkinItem.Tag := 999;
    if FItems[i].Caption = '-' then
      SkinItem.Text := '-'
    else
      SkinItem.Text := FItems[i].Caption;
    if FItems[i].ShortCut <> 0 then
      SkinItem.ExtText := ShortCutToText(FItems[i].ShortCut);

    SkinItem.VisibleNow := FItems[i].Visible;
    SkinItem.Enabled := FItems[i].Enabled;
    if FItems[i].RadioItem then
      SkinItem.RadioChecked := FItems[i].Checked
    else
      SkinItem.Checked := FItems[i].Checked;
    if FItems[i].Count > 0 then
      SkinItem.SubMenu := true;
    { glyph}
    SkinItem.Bitmap := FItems[i].Bitmap;
    SkinItem.Images := FMenu.Images;
    SkinItem.ImageIndex := FItems[i].ImageIndex;

    SkinItem.Tag := i;
    SkinItem.TextRect := Rect(GlyphWidth, 0, CheckWidth, 0);
    FPopupMenu.AddChild(SkinItem);
  end;
  { Calc border width and height }
  W := 0;
  H := 0;
  for i := 0 to FPopupMenu.ChildCount-1 do
  with FPopupMenu do
  begin
    if Child[i].Kind = skPopupMenuItem then Continue;
    if Child[i].Align in [saTop, saBottom, saMostTop, saMostBottom] then
      H := H + Child[i].Height;  
    if Child[i].Align in [saLeft, saRight, saMostLeft, saMostRight] then
      W := W + Child[i].Width;
  end;
  ClientWidth := ClientWidth + W;
  ClientHeight := ClientHeight + H;
  FPopupMenu.BoundsRect := Rect(0, 0, ClientWidth, ClientHeight);
end;

procedure TscMenuWnd.CalcSize;
var
  i: integer;
  W, H: integer;
  CalcBmp: TBitmap;
begin
  if FItems = nil then Exit;

  FPopupMenu.Assign(FSkinSource.PopupMenu);
  FPopupMenu.Aligning;
  // Calc width
  W := 0; H := 0;
  CalcBmp := TBitmap.Create;
  try
    FPopupMenu.MenuItem.Text := 'test';
    FPopupMenu.MenuItem.Draw(CalcBmp.Canvas);
    for i := 0 to FItems.Count-1 do
    begin
      if CalcBmp.Canvas.TextWidth(FItems[i].Caption) > W then
        W := CalcBmp.Canvas.TextWidth(FItems[i].Caption);
      if FItems[i].Visible then
        H := H + FPopupMenu.MenuItem.Height;
    end;
  finally
    CalcBmp.Free;
  end;
  // Set size
  Width := W + GlyphWidth + CheckWidth + ShortCutWidth;
  Height := H;
end;

{ Windows messages ============================================================}

procedure TscMenuWnd.Paint;
var
  FCash: TBitmap;
begin
  if FItems = nil then Exit;
  FCash := TBitmap.Create;
  try
    FCash.Width := ClientWidth;
    FCash.Height := ClientHeight;
    FPopupMenu.Wnd := Handle;
    FPopupMenu.Draw(FCash.Canvas);
    Canvas.Draw(0, 0, FCash);
  finally
    FCash.Free;
  end;
end;

{ Popup menu ==================================================================}

procedure TscMenuWnd.Popup(X, Y: integer);
begin
  (FSkinEngine as TscSkinEngine).FAllowDraw := false;
  try
    CalcSize;
    CreateSkinItems;
    if FItemRect.Left <> FItemRect.Right then
    begin
      // normal menus
      if FParentMenuWnd = nil then
      begin
        if FItemRect.Bottom + Height > Screen.Height then
          Top := FItemRect.Top - Height
        else
          Top := FItemRect.Bottom;
        if FItemRect.Left + Width > Screen.Width then
          Left := FItemRect.Right - Width
        else
          Left := FItemRect.Left;
      end
      else
      begin
        if FItemRect.Top + Height > Screen.Height then
          Top := FItemRect.Bottom - Height
        else
          Top := FItemRect.Top;
        if FItemRect.Right + Width > Screen.Width then
          Left := FItemRect.Left - Width
        else
          Left := FItemRect.Right;
      end;
    end
    else
    begin
      if X + Width > Screen.Width then X := X - Width;
      if Y + Height > Screen.Height then Y := Y - Height;
      Left := X;
      Top := Y;
    end;
    Show;
  finally
    (FSkinEngine as TscSkinEngine).FAllowDraw := true;
  end;
end;

{ Windows messages ============================================================}

procedure TscMenuWnd.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  // Draw border
  Msg.Result := 0;
end;

procedure TscMenuWnd.WMActivate(var Msg: TWMActivate);
begin
  { No border deactivate }
  if (Msg.Active = WA_ACTIVE) and (Owner is TWinControl) and
     ((Owner as TWinControl).Visible)
  then
    SendMessage((Owner as TWinControl).Handle, WM_NCACTIVATE, 1, 1);
  { close at inactivate }
  if (Msg.Active = WA_INACTIVE) then
  begin
    if (Owner <> nil) and (Owner is TWinControl) then
      if (FParentMenuWnd = nil) then
      begin
        if (FMenuWnd <> nil) and (Msg.ActiveWindow = FMenuWnd.Handle) then
        else
          SendMessage((Owner as TWinControl).Handle, WM_EXITMENULOOP, 0, 0);
      end;
    if (FParentMenuWnd <> nil) and (FTimer.Enabled) then
    begin
      Close;
      FParentMenuWnd.Close;
      if (Owner <> nil) and (Owner is TWinControl) then
        SendMessage((Owner as TWinControl).Handle, WM_EXITMENULOOP, 0, 0);
    end;
    if (FParentMenuWnd <> nil) and (not FTimer.Enabled) then
    begin
      Close;
      try
        if not FActiveBusy then
        begin
          FActiveBusy := true;
          SetForegroundWindow(FParentMenuWnd.Handle);
        end;
      finally
        FActiveBusy := false;
      end;
    end;
    if (FParentMenuWnd = nil) and (FMenuWnd = nil) then
      Close;
  end;
  Msg.Result := 0;
end;

procedure TscMenuWnd.DoTimer(Sender: TObject);
var
  MouseObject: TscSkinObject;
  MousePoint: TPoint;
  R: TRect;
  i: integer;
begin
  if FBusy then Exit;
  if FSkinSource = nil Then Exit;
  if FPopupMenu = nil then Exit;
  if csDestroying in ComponentState then Exit; 
  i := 0;
  while i < Objects.Count do
  begin
    if TscSkinObject(Objects[i]).Wnd = Handle then { MenuWnd }
      TscSkinObject(Objects[i]).ProcessScript;
    Inc(i);
  end; 

  FBusy := true;
  try
    GetCursorPos(MousePoint);
    MousePoint := Point(MousePoint.X - Left, MousePoint.Y - Top);
    // Hover and Leave events
    MouseObject := FPopupMenu.FindObjectByPoint(MousePoint);
    if (MouseObject <> nil) and (
       (MouseObject.Text = '') or
       (MouseObject.Text = '-') or
       (not MouseObject.Enabled) or
       (not MouseObject.VisibleNow))
    then
      MouseObject := nil;

    { Hide or Show SubMenu }
    if (MouseObject <> nil) and (MouseObject.Kind = skPopupMenuItem) then
    begin
      if (Assigned(FMenuWnd)) and (FMenuWnd.FItems = FItems[MouseObject.Tag]) then
      else
      begin
        { hide }
        if (FItems[MouseObject.Tag].Count = 0) and (Assigned(FMenuWnd)) then
        begin
          FMenuWnd.FTimer.Enabled := false;
          FMenuWnd.Close;
          FMenuWnd := nil;
          Application.ProcessMessages;
        end;
        { show }
        if (FItems[MouseObject.Tag].Count > 0) then
        begin
          if Assigned(FMenuWnd) then
          begin
            FMenuWnd.FTimer.Enabled := false;
            FMenuWnd.Close;
            FMenuWnd := nil;
            Application.ProcessMessages;
          end;
          FMenuWnd := TscMenuWnd.Create(Owner);
          FMenuWnd.Menu := FMenu;
          FMenuWnd.Items := FItems[MouseObject.Tag];
          FMenuWnd.FParentMenuWnd := Self;
          FMenuWnd.SkinEngine := FSkinEngine;
          FMenuWnd.SkinSource := FSkinSource;
          { Calc ItemRect}
          R.TopLeft := ClientToScreen(MouseObject.BoundsRect.TopLeft);
          R.BottomRight := ClientToScreen(MouseObject.BoundsRect.BottomRight);
          FMenuWnd.ItemRect := R;
          { Popup }
          FMenuWnd.Popup(Left + Width, Top + MouseObject.Top);
        end;
      end;
    end;
    { Hover and leave }
    if (MouseObject = nil) then
    begin
      if (FMouseObject <> nil) then
      begin
        FMouseObject.RunScript(FMouseObject.LeaveEvent.Text);
        FMouseObject := nil;
      end
    end
    else
      if (MouseObject <> FMouseObject) then
      begin
        if FMouseObject <> nil then
          FMouseObject.RunScript(FMouseObject.LeaveEvent.Text);
        FMouseObject := MouseObject;
        if FMouseObject.HoverEvent <> nil then
          FMouseObject.RunScript(FMouseObject.HoverEvent.Text);
      end;
  finally
    FBusy := false;
  end;
end;

procedure TscMenuWnd.WMLButtonUp(var Msg: TWMLButtonUp);
var
  SkinObject: TscSkinObject;
begin
  inherited ;
  // ClickEvent
  SkinObject := FPopupMenu.FindObjectByPoint(Point(Msg.XPos, Msg.YPos));
  if (SkinObject <> nil) and (SkinObject.Kind = skPopupMenuItem) and
     (SkinObject.Text <> '') and (SkinObject.Text <> '-') and
     (SkinObject.Enabled) 
  then
  begin
    if (FItems[SkinObject.Tag].Count = 0) then
    begin
      GSkinEngine := FSkinEngine as TscSkinEngine;
      if (Owner <> nil) and (Owner is TWinControl) then
        PostMessage((Owner as TWinControl).Handle, WM_EXITMENULOOP, 0, 0);
      Close;
      if FParentMenuWnd <> nil then
        FParentMenuWnd.Close;
      FItems[SkinObject.Tag].Click;
      { Recreate mainmenu }
      if GSkinEngine <> nil then
        (GSkinEngine as TscSkinEngine).RecreateMainMenu;
    end;
  end;
end;

procedure TscMenuWnd.WMKeyDown(var Msg: TWMKeyDown);
var
  i: integer;
  S: string;
begin
  if FMenu = nil then Exit;
  for i := 0 to FItems.Count-1 do
  begin
    S := UpperCase(GetHotkey(FItems[i].Caption));
    if (S <> '') and (S <> '-') and (Integer(S[1]) = Msg.CharCode) and
       (FItems[i].Enabled)
    then
    begin
      GSkinEngine := FSkinEngine as TscSkinEngine;
      FItems[i].Click;
      if (Owner <> nil) and (Owner is TWinControl) then
        PostMessage((Owner as TWinControl).Handle, WM_EXITMENULOOP, 0, 0);
      if FParentMenuWnd <> nil then
        FParentMenuWnd.Close;
      { Recreate mainmenu }
      if GSkinEngine <> nil then
        (GSkinEngine as TscSkinEngine).RecreateMainMenu;
      { Close }
      Close;
    end;
  end;
  if Msg.CharCode = VK_ESCAPE then
  begin
    if (Owner <> nil) and (Owner is TWinControl) then
      PostMessage((Owner as TWinControl).Handle, WM_EXITMENULOOP, 0, 0);
    if FParentMenuWnd <> nil then
      FParentMenuWnd.Close;
    Close;
  end;
end;

procedure TscMenuWnd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMouseObject := nil;
  FTimer.Enabled := false;
  Action := caFree;
end;

  initialization
  CheckBmp := TksBmp.CreateFromHandle(LoadBitmap(HInstance, 'KS_CHECKITEM'));
 RadioBmp := TksBmp.CreateFromHandle(LoadBitmap(HInstance, 'KS_RADIOITEM'));
  SubBmp := TksBmp.CreateFromHandle(LoadBitmap(HInstance, 'KS_SUBITEM'));

finalization
  CheckBmp.Free;
  RadioBmp.Free;
  SubBmp.Free;
end.

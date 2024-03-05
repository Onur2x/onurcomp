{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 5.86                                                }
{                                                                   }
{       Copyright (c) 2000-2004 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spTrayIcon;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ShellApi, ExtCtrls, SkinMenus;

const
  WM_TRAYNOTIFY = WM_USER + 1024;
  IconID = 1;

var
  WM_TASKBARCREATED: Cardinal;

type
  TNotifyIconDataEx = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;   
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    uTimeout: UINT; 
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end;

  TCycleEvent = procedure(Sender: TObject; NextIndex: Integer) of object;
  TspBalloonHintIcon = (bitNone, bitInfo, bitWarning, bitError);

  TspTrayIcon = class(TComponent)
  private
    FEnabled: Boolean;
    FIcon: TIcon;
    FIconVisible: Boolean;
    FHint: String;
    FShowHint: Boolean;
    FPopupMenu: TspSkinPopupMenu;
    FPopupByLeftButton: Boolean;
    FOnClick,
    FOnDblClick: TNotifyEvent;
    FOnCycle: TCycleEvent;
    FOnMouseDown,
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FMinimizedOnStart: Boolean;
    FMinimizeToTray: Boolean;
    FClickStart: Boolean;
    FClickReady: Boolean;
    AnimateTimer: TTimer;
    ClickTimer: TTimer;
    IsDblClick: Boolean;
    FIconIndex: Integer;
    FDesignPreview: Boolean;
    SettingPreview: Boolean;
    SettingMDIForm: Boolean;           
    FIconList: TImageList;
    FCycleIcons: Boolean;
    FAnimateTimerInterval: Cardinal;
    OldAppProc, NewAppProc: Pointer;
    OldWndProc, NewWndProc: Pointer;
    FWindowHandle: HWND;               
    procedure SetDesignPreview(Value: Boolean);
    procedure SetCycleIcons(Value: Boolean);
    procedure SetAnimateTimerInterval(Value: Cardinal);
    procedure TimerCycle(Sender: TObject);
    procedure TimerClick(Sender: TObject);
    procedure HandleIconMessage(var Msg: TMessage);
    function InitIcon: Boolean;
    procedure SetIcon(Value: TIcon);
    procedure SetIconVisible(Value: Boolean);
    procedure SetIconList(Value: TImageList);
    procedure SetIconIndex(Value: Integer);
    procedure SetHint(Value: String);
    procedure SetShowHint(Value: Boolean);
    procedure PopupAtCursor;
    // Hook methods
    procedure HookApp;
    procedure UnhookApp;
    procedure HookAppProc(var Msg: TMessage);
    procedure HookForm;
    procedure UnhookForm;
    procedure HookFormProc(var Msg: TMessage);
  protected
    IconData: TNotifyIconDataEx;       
    procedure Loaded; override;
    function LoadDefaultIcon: Boolean; virtual;
    function ShowIcon: Boolean; virtual;
    function HideIcon: Boolean; virtual;
    function ModifyIcon: Boolean; virtual;
    procedure Click; dynamic;
    procedure DblClick; dynamic;
    procedure CycleIcon; dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure DoMinimizeToTray; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    property Handle: HWND read IconData.Wnd;
    property WindowHandle: HWND read FWindowHandle;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Refresh: Boolean;
    function BitmapToIcon(const Bitmap: TBitmap; const Icon: TIcon;
      MaskColor: TColor): Boolean;
    procedure ShowMainForm;
    procedure HideMainForm;
    function ShowBalloonHint(Title: String; Text: String;
                             IconType: TspBalloonHintIcon): Boolean;
    function HideBalloonHint: Boolean;
  published
    property DesignPreview: Boolean read FDesignPreview
      write SetDesignPreview default False;
    property IconList: TImageList read FIconList write SetIconList;
    property CycleIcons: Boolean read FCycleIcons write SetCycleIcons
      default False;
    property AnimateTimerInterval: Cardinal read FAnimateTimerInterval
      write SetAnimateTimerInterval;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Hint: String read FHint write SetHint;
    property ShowHint: Boolean read FShowHint write SetShowHint
      default True;
    property Icon: TIcon read FIcon write SetIcon stored True;
    property IconVisible: Boolean read FIconVisible write SetIconVisible
      default True;
    property IconIndex: Integer read FIconIndex write SetIconIndex;
    property PopupMenu: TspSkinPopupMenu read FPopupMenu write FPopupMenu;
    property PopupByLeftButton: Boolean read FPopupByLeftButton write FPopupByLeftButton
      default False;
    property MinimizedOnStart: Boolean read FMinimizedOnStart write FMinimizedOnStart
      default False;
    property MinimizeToTray: Boolean read FMinimizeToTray write FMinimizeToTray
      default False;         
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnCycle: TCycleEvent read FOnCycle write FOnCycle;
  end;

implementation

const
  NIIF_NONE            = $00000000;
  NIIF_INFO            = $00000001;
  NIIF_WARNING         = $00000002;
  NIIF_ERROR           = $00000003;
  NIF_INFO             = $00000010;
  

constructor TspTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SettingMDIForm := True;
  FIconVisible := True;
  FEnabled := True;
  FShowHint := True;         
  SettingPreview := False;
  WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');
  FIcon := TIcon.Create;
  IconData.cbSize := SizeOf(TNotifyIconDataEx);
  IconData.wnd := AllocateHWnd(HandleIconMessage);
  IconData.uId := IconID;
  IconData.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
  IconData.uCallbackMessage := WM_TRAYNOTIFY;
  FWindowHandle := GetWindowLong(IconData.wnd, GWL_HWNDPARENT);

  AnimateTimer := TTimer.Create(Self);
  AnimateTimer.Enabled := False;
  AnimateTimer.Interval := FAnimateTimerInterval;
  AnimateTimer.OnTimer := TimerCycle;

  ClickTimer := TTimer.Create(Self);
  ClickTimer.Enabled := False;
  ClickTimer.Interval := GetDoubleClickTime;
  ClickTimer.OnTimer := TimerClick;

  if not (csDesigning in ComponentState)
  then
    begin
      if FIcon.Handle = 0
      then
        if LoadDefaultIcon
        then
          FIcon.Handle := Application.Icon.Handle;
      HookApp;
      if Owner is TWinControl then HookForm;
    end;
end;


destructor TspTrayIcon.Destroy;
begin
  SetIconVisible(False);
  SetDesignPreview(False);
  FIcon.Free;
  DeallocateHWnd(IconData.Wnd);
  AnimateTimer.Free;
  ClickTimer.Free;
  if not (csDesigning in ComponentState)
  then
    begin
      UnhookApp;
      if Owner is TWinControl then UnhookForm;
    end;
  inherited Destroy;
end;


procedure TspTrayIcon.Loaded;
begin
  inherited Loaded;
  if Owner is TWinControl
  then
    if (FMinimizedOnStart) and not (csDesigning in ComponentState)
    then
      begin
        FIconVisible := True;
        MinimizeToTray := True;
        Application.ShowMainForm := False;
        ShowWindow(Application.Handle, SW_HIDE);
      end;
  ModifyIcon;
  SetIconVisible(FIconVisible);
end;

function TspTrayIcon.LoadDefaultIcon: Boolean;
begin
  Result := True;
end;

procedure TspTrayIcon.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FIconList) and (Operation = opRemove)
  then
    begin
      FIconList := nil;
    end;
  if (AComponent = FPopupMenu) and (Operation = opRemove)
  then
    begin
      FPopupMenu := nil;
    end;
end;

procedure TspTrayIcon.HookApp;
begin
  OldAppProc := Pointer(GetWindowLong(Application.Handle, GWL_WNDPROC));
  NewAppProc := MakeObjectInstance(HookAppProc);
  SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(NewAppProc));
end;

procedure TspTrayIcon.UnhookApp;
begin
  if Assigned(OldAppProc)
  then
    SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(OldAppProc));
  if Assigned(NewAppProc)
  then
    FreeObjectInstance(NewAppProc);
  NewAppProc := nil;
  OldAppProc := nil;
end;

procedure TspTrayIcon.HookAppProc(var Msg: TMessage);
begin
  case Msg.Msg of

    WM_SIZE:
      if Msg.wParam = SIZE_MINIMIZED
      then
        begin
          if FMinimizeToTray then DoMinimizeToTray;
        end;

    WM_WINDOWPOSCHANGED:
      begin
        if SettingMDIForm
        then
          if Application.MainForm <> nil
          then
            begin
              if (Application.MainForm.FormStyle = fsMDIForm) then
              if FMinimizedOnStart then
              ShowWindow(Application.Handle, SW_HIDE);
              SettingMDIForm := False;
            end;
      end;
  end;

  if (Msg.Msg = WM_TASKBARCREATED) and FIconVisible then ShowIcon;

  Msg.Result := CallWindowProc(OldAppProc, Application.Handle,
                               Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TspTrayIcon.HookForm;
begin
  if (Owner as TWinControl) <> nil
  then
    begin
      OldWndProc := Pointer(GetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC));
      NewWndProc := MakeObjectInstance(HookFormProc);
      SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(NewWndProc));
    end;
end;

procedure TspTrayIcon.UnhookForm;
begin
  if ((Owner as TWinControl) <> nil) and (Assigned(OldWndProc))
  then
    SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(OldWndProc));
  if Assigned(NewWndProc)
  then
    FreeObjectInstance(NewWndProc);
  NewWndProc := nil;
  OldWndProc := nil;
end;

procedure TspTrayIcon.HookFormProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_SHOWWINDOW:
     begin
       if (Msg.lParam = 0) and (Msg.wParam = 1)
       then
         begin
           ShowWindow(Application.Handle, SW_RESTORE);
           SetForegroundWindow(Application.Handle);
           SetForegroundWindow((Owner as TWinControl).Handle);
         end;
     end;
    WM_ACTIVATE: begin
       if Assigned(Screen.ActiveControl)
       then
        if (Msg.WParamLo = WA_ACTIVE) or (Msg.WParamLo = WA_CLICKACTIVE)
        then
          if Assigned(Screen.ActiveControl.Parent)
          then
            begin
              if HWND(Msg.lParam) <> Screen.ActiveControl.Parent.Handle
              then SetFocus(Screen.ActiveControl.Handle);
            end
        else
          begin
            if HWND(Msg.lParam) <> Screen.ActiveControl.Handle
            then SetFocus(Screen.ActiveControl.Handle);
          end;
    end;
  end;
  Msg.Result := CallWindowProc(OldWndProc, (Owner as TWinControl).Handle,
                Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TspTrayIcon.HandleIconMessage(var Msg: TMessage);

  function ShiftState: TShiftState;
  begin
    Result := [];
    if GetAsyncKeyState(VK_SHIFT) < 0
    then Include(Result, ssShift);
    if GetAsyncKeyState(VK_CONTROL) < 0
    then Include(Result, ssCtrl);
    if GetAsyncKeyState(VK_MENU) < 0
    then Include(Result, ssAlt);
  end;

var
  Pt: TPoint;
  Shift: TShiftState;
  I: Integer;
  M: TMenuItem;
begin
  if Msg.Msg = WM_TRAYNOTIFY
  then
    begin
      if FEnabled then
        case Msg.lParam of
           WM_MOUSEMOVE:
             begin
               Shift := ShiftState;
               GetCursorPos(Pt);
               MouseMove(Shift, Pt.X, Pt.Y);
             end;

           WM_LBUTTONDOWN:
             begin
               ClickTimer.Enabled := True;
               Shift := ShiftState + [ssLeft];
               GetCursorPos(Pt);
               MouseDown(mbLeft, Shift, Pt.X, Pt.Y);
               FClickStart := True;
              if FPopupByLeftButton then PopupAtCursor;
            end;

           WM_RBUTTONDOWN:
             begin
               Shift := ShiftState + [ssRight];
               GetCursorPos(Pt);
               MouseDown(mbRight, Shift, Pt.X, Pt.Y);
               PopupAtCursor;
             end;

           WM_MBUTTONDOWN:
             begin
               Shift := ShiftState + [ssMiddle];
               GetCursorPos(Pt);
               MouseDown(mbMiddle, Shift, Pt.X, Pt.Y);
             end;

           WM_LBUTTONUP:
             begin
               Shift := ShiftState + [ssLeft];
               GetCursorPos(Pt);
               if FClickStart then FClickReady := True;
               if FClickStart and (not ClickTimer.Enabled)
               then
                 begin
                   FClickStart := False;
                   FClickReady := False;
                    Click;
                 end;
               FClickStart := False;
               MouseUp(mbLeft, Shift, Pt.X, Pt.Y);
             end;

           WM_RBUTTONUP:
             begin
               Shift := ShiftState + [ssRight];
               GetCursorPos(Pt);
               MouseUp(mbRight, Shift, Pt.X, Pt.Y);
             end;

           WM_MBUTTONUP:
             begin
               Shift := ShiftState + [ssMiddle];
               GetCursorPos(Pt);
               MouseUp(mbMiddle, Shift, Pt.X, Pt.Y);
             end;
           WM_LBUTTONDBLCLK:
             begin
               FClickReady := False;
               IsDblClick := True;
               DblClick;
               M := nil;
               if Assigned(FPopupMenu)
               then
                 if (FPopupMenu.AutoPopup) and (not FPopupByLeftButton)
                 then
                   for I := PopupMenu.Items.Count -1 downto 0 do
                     if PopupMenu.Items[I].Default then M := PopupMenu.Items[I];
               if M <> nil then M.Click;
             end;
        end;
    end
  else
    case Msg.Msg of
      WM_QUERYENDSESSION, WM_CLOSE, WM_QUIT,
      WM_DESTROY, WM_NCDESTROY, WM_USERCHANGED:  Msg.Result := 1;
    else
      Msg.Result := DefWindowProc(IconData.Wnd, Msg.Msg, Msg.wParam, Msg.lParam);
    end;
end;

procedure TspTrayIcon.SetIcon(Value: TIcon);
begin
  FIcon.Assign(Value);
  ModifyIcon;
end;

procedure TspTrayIcon.SetIconVisible(Value: Boolean);
begin
  if Value then ShowIcon else HideIcon;
end;


procedure TspTrayIcon.SetDesignPreview(Value: Boolean);
begin
  FDesignPreview := Value;
  SettingPreview := True;
  SetIconVisible(Value);
  SettingPreview := False;
end;


procedure TspTrayIcon.SetCycleIcons(Value: Boolean);
begin
  FCycleIcons := Value;
  if Value then SetIconIndex(0);
  AnimateTimer.Enabled := Value;
end;


procedure TspTrayIcon.SetAnimateTimerInterval(Value: Cardinal);
begin
  FAnimateTimerInterval := Value;
  AnimateTimer.Interval := FAnimateTimerInterval;
end;


procedure TspTrayIcon.SetIconList(Value: TImageList);
begin
  FIconList := Value;
  SetIconIndex(0);
end;


procedure TspTrayIcon.SetIconIndex(Value: Integer);
begin
  if FIconList <> nil
  then
    begin
      FIconIndex := Value;
      if Value >= FIconList.Count then FIconIndex := FIconList.Count - 1;
      FIconList.GetIcon(FIconIndex, FIcon);
    end
  else
    FIconIndex := 0;
  ModifyIcon;
end;

procedure TspTrayIcon.SetHint(Value: String);
begin
  FHint := Value;
  ModifyIcon;
end;

procedure TspTrayIcon.SetShowHint(Value: Boolean);
begin
  FShowHint := Value;
  ModifyIcon;
end;

function TspTrayIcon.InitIcon: Boolean;
var
  B: Boolean;
begin
  Result := False;
  B := True;
  if (csDesigning in ComponentState)
  then
    begin
      if SettingPreview then B := True else B := FDesignPreview
    end;
  if B
  then
    begin
      IconData.hIcon := FIcon.Handle;
      if (FHint <> '') and (FShowHint)
      then
        StrLCopy(IconData.szTip, PChar(FHint), SizeOf(IconData.szTip) - 1)
      else
        IconData.szTip := '';
      Result := True;
    end;
end;

function TspTrayIcon.ShowIcon: Boolean;
begin
  Result := False;
  if not SettingPreview then FIconVisible := True;
  if (csDesigning in ComponentState)
  then
    begin
      if SettingPreview and InitIcon
      then Result := Shell_NotifyIcon(NIM_ADD, @IconData);
    end
  else
    if InitIcon then Result := Shell_NotifyIcon(NIM_ADD, @IconData);
end;


function TspTrayIcon.HideIcon: Boolean;
begin
  Result := False;
  if not SettingPreview then FIconVisible := False;
  if (csDesigning in ComponentState)
  then
    begin
      if SettingPreview and InitIcon
      then Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
    end
  else
    if InitIcon then Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
end;

function TspTrayIcon.ModifyIcon: Boolean;
begin
  Result := False;
  if InitIcon then Result := Shell_NotifyIcon(NIM_MODIFY, @IconData);
end;

procedure TspTrayIcon.TimerCycle(Sender: TObject);
begin
  if Assigned(FIconList)
  then
    begin
      FIconList.GetIcon(FIconIndex, FIcon);
      CycleIcon;
      ModifyIcon;
      if FIconIndex < FIconList.Count-1
      then
        SetIconIndex(FIconIndex+1)
      else
        SetIconIndex(0);
    end;
end;

function TspTrayIcon.BitmapToIcon(const Bitmap: TBitmap;
  const Icon: TIcon; MaskColor: TColor): Boolean;
var
  BitmapImageList: TImageList;
begin
  BitmapImageList := TImageList.CreateSize(16, 16);
  try
    Result := False;
    BitmapImageList.AddMasked(Bitmap, MaskColor);
    BitmapImageList.GetIcon(0, Icon);
    Result := True;
  finally
    BitmapImageList.Free;
  end;
end;


function TspTrayIcon.Refresh: Boolean;
begin
  Result := ModifyIcon;
end;


procedure TspTrayIcon.PopupAtCursor;
var
  CursorPos: TPoint;
begin
  if Assigned(PopupMenu)
  then
    if PopupMenu.AutoPopup
    then
      if GetCursorPos(CursorPos)
      then
        begin
          Application.ProcessMessages;
          SetForegroundWindow(Handle);
          if Owner is TWinControl then
           SetForegroundWindow((Owner as TWinControl).Handle);
          PopupMenu.PopupComponent := Self;
          PopupMenu.Popup(CursorPos.X, CursorPos.Y);
          if Owner is TWinControl then
          PostMessage((Owner as TWinControl).Handle, WM_NULL, 0, 0);
        end;
end;


procedure TspTrayIcon.Click;
begin
  if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TspTrayIcon.DblClick;
begin
  if Assigned(FOnDblClick) then FOnDblClick(Self);
end;

procedure TspTrayIcon.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then FOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure TspTrayIcon.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then FOnMouseUp(Self, Button, Shift, X, Y);
end;


procedure TspTrayIcon.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then FOnMouseMove(Self, Shift, X, Y);
end;


procedure TspTrayIcon.CycleIcon;
var
  NextIconIndex: Integer;
begin
  NextIconIndex := 0;
  if FIconList <> nil then
    if FIconIndex < FIconList.Count then
      NextIconIndex := FIconIndex +1;
  if Assigned(FOnCycle) then
    FOnCycle(Self, NextIconIndex);
end;


procedure TspTrayIcon.DoMinimizeToTray;
begin
  HideMainForm;
  IconVisible := True;
end;


procedure TspTrayIcon.TimerClick(Sender: TObject);
begin
  ClickTimer.Enabled := False;
  if (not IsDblClick)
  then
    if FClickReady
    then
      begin
        FClickReady := False;
        Click;
      end;
  IsDblClick := False;
end;


procedure TspTrayIcon.ShowMainForm;
begin
  if Owner is TWinControl then
    if Application.MainForm <> nil
    then
      begin
        ShowWindow(Application.Handle, SW_RESTORE);
        Application.MainForm.Visible := True;
        if Application.MainForm.WindowState = wsMinimized
        then Application.MainForm.WindowState := wsNormal;
      end;
end;

procedure TspTrayIcon.HideMainForm;
begin
  if Owner is TWinControl
  then
    if Application.MainForm <> nil
    then
      begin
        Application.MainForm.Visible := False;
        ShowWindow(Application.Handle, SW_HIDE);
      end;
end;

function TspTrayIcon.ShowBalloonHint;
const
  aBalloonIconTypes: array[TspBalloonHintIcon] of Byte =
    (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR);
begin
  HideBalloonHint;
  with IconData do
  begin
    uFlags := uFlags or NIF_INFO;
    StrLCopy(szInfo, PChar(Text), SizeOf(szInfo)-1);
    StrLCopy(szInfoTitle, PChar(Title), SizeOf(szInfoTitle)-1);
    dwInfoFlags := aBalloonIconTypes[IconType];
  end;
  Result := ModifyIcon;
  with IconData do
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
end;


function TspTrayIcon.HideBalloonHint: Boolean;
begin
  with IconData do
  begin
    uFlags := uFlags or NIF_INFO;
    StrPCopy(szInfo, '');
  end;
  Result := ModifyIcon;
end;

end.

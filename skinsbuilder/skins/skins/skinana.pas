unit skinana;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ImgList, StdCtrls, resim, KsHook, bilesenutil,
  bilesenim, Sikinkodu, SkinMenuWnd;

const

  SysGlyphWidth   = 16; // system menu glyph width

type

  TSystemCommand = (sscRestore, sscMove, sscSize, sscMinimize,
    sscMaximize, sscClose, sscRollup, sscAboutSkin, sscChangeSkin);

  TscPopupMenu = class;
  TscSkinStore = class;

  TOnCustomAction = procedure (Sender: TObject; Action: integer) of object;

  TscSkinEngine = class(TComponent)
  private
    { Private declarations }
    FActive: boolean;
    FHook: TscHook;
    FForm: TWinControl;
    FSkinSource: TscSkinSource;
    FWidth, FHeight: integer;
    lStyle: Integer;
    { main menu }
    FMainMenuShow: boolean;
    FMainMenu: TMainMenu; // link to main menus
    FMainMenuTrack: boolean;
    FMainMenuItems: TList; // TscSkinObject
    FSkinMainMenu: TList;
    { popup menus }
    FSkinPopupMenus: TList;
    FTrackMenu: TscPopupMenu;
    { system menu }
    FSystemMenu: TscPopupMenu;
    { window }
    FWindowStates: TscWindowStates;
    FBeforeRollupSize: integer;
    { properies }
    FBorderIcons: TscBorderIcons;
    FSizeable: boolean;
    FSkinFile: string;
    FSkinStore: TscSkinStore;
    FSkinFolder: string;
    { Only for inside use }
    FHandle: HWnd;
    OldTextLen: integer;
    FCash: TBitmap;
    FMouseObject: TscSkinObject;
    { Idle }
    FTimer: TTimer;
    { Accelerators }
    FAccelWnd: TWinControl;
    { inside routing }
    procedure DoHook(Sender: TObject; var Msg: TMessage;
      var Handled: Boolean);
    procedure DoHookAfterForm(Sender: TObject; var Msg: TMessage;
      var Handled: Boolean);
    { Windows messages }
    procedure WMSkinSysCommand(var Msg: TMessage);
    procedure WMCommand(var Msg: TMessage);
    procedure WMNCActivate(var Msg: TWMNCActivate);
    procedure WMNCCalcSize(var Msg: TWMNCCalcSize);
    procedure WMPaint(var Msg: TWMPaint);
    procedure WMNCPaint(var Msg: TWMNCPaint);
    procedure WMNCHitTest(var Msg: TWMNCHitTest);
    procedure WMNCLButtonDown(var Msg: TWMNCLButtonDown);
    procedure WMNCLButtonDblClk(var Msg: TWMMouse);
    procedure WMNCRButtonDown(var Msg: TWMMouse);
    procedure WMNCLButtonUp(var Msg: TWMNCLButtonUp);
    procedure WMNCRButtonUp(var Msg: TWMNCRButtonUp);
    procedure WMNCMouseMove(var Msg: TWMNCMouseMove);
    procedure WMKeyDown(var Msg: TWMKey);
    procedure WMActivate(var Msg: TMessage);
    procedure WMSize(var Msg: TMessage);
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
    procedure WMSetCursorBefore(var Msg: TMessage);
    procedure WMSetCursorAfter(var Msg: TMessage);
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd);
    { drawing functions }
    procedure DrawSkin;
    function GetHitTest(P: TPoint): integer;
    function NormalizePoint(P: TPoint): TPoint;
    function GetMinHeight: integer;
    { region function }
    procedure MakeRegion;
    { menus functions }
    procedure CreateMainMenu;
    function CreatePopupMenu(Items: TMenuItem): TscPopupMenu;
    procedure TrackPopupMenu(X, Y: integer; Item: integer);
    procedure EndMenuLoop;
    procedure DoMainMenuChanged(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure DoPopupMenuChanged(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    { Idle processes }
    procedure DoTimer(Sender: TObject);
    { system menu }
    procedure CreateSystemMenu;
    procedure DoSystemCommand(Sender: TObject);
    procedure TrackSystemMenu;
    { properties }
    procedure SetSkinSource(const Value: TscSkinSource);
    procedure SetBorderIcons(const Value: TscBorderIcons);
    procedure SetMainMenu(const Value: TMainMenu);
    procedure SetMainMenuShow(const Value: boolean);
    procedure SetWindowStates(const Value: TscWindowStates);
    procedure SetSkinFolder(const Value: string);
    procedure SetSkinFile(const Value: string);
    procedure SetSkinStore(const Value: TscSkinStore);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    FAllowDraw: boolean;
    FOnCustomAction: TOnCustomAction;
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure LoadFromFile(FileName: string);
    procedure LoadFromFolder(Path: string);
    procedure UpdateSkinSource;
    procedure RecreateMainMenu;
    procedure RedrawSkin;
    procedure ChangeMainMenuItem(Item: TMenuItem);
    { for inside use only }
    function GetActive: boolean;
    function GetHandle: HWnd;
    function GetParentLeft: integer;
    function GetParentTop: integer;
    function GetText: string;
    { properties }
    property Active: boolean read GetActive;
    property WindowStates: TscWindowStates read FWindowStates write SetWindowStates;
    property SkinSource: TscSkinSource read FSkinSource write SetSkinSource;
  published
    { Published declarations }
    property MainMenu: TMainMenu read FMainMenu write SetMainMenu;
    property MainMenuShow: boolean read FMainMenuShow write SetMainMenuShow;
    property BorderIcons: TscBorderIcons read FBorderIcons write SetBorderIcons;
    property SkinFolder: string read FSkinFolder write SetSkinFolder;
    property SkinFile: string read FSkinFile write SetSkinFile;
    property SkinStore: TscSkinStore read FSkinStore write SetSkinStore;
    property Sizeable: boolean read FSizeable write FSizeable;
    { Events }
    property OnCustomAction: TOnCustomAction read FOnCustomAction
      write FOnCustomAction;  
  end;

{ TscPoppupMenu }

  TscPopupMenu = class(TPopupMenu)
  private
    FMenuWnd: TscMenuWnd;
    FSkinEngine: TscSkinEngine;
    FOnPopup: TNotifyEvent;
    FRect: TRect;
    procedure SetSkinEngine(const Value: TscSkinEngine);
    { Private declarations }
    procedure EndPopup;
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Popup(X, Y: integer); override;
    property ItemRect: TRect read FRect write FRect;
  published
    { Published declarations }
    property SkinEngine: TscSkinEngine read FSkinEngine write SetSkinEngine;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  end;

{ TscSkinStore }

  TscSkinStore = class(TComponent)
  private
    FSkinSource: TscSkinSource;
    FSkinData: integer;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
    procedure SetSkinSource(const Value: TscSkinSource);
  protected
    { Protected declarations }
    procedure DefineProperties(Filer: TFiler); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SkinSource: TscSkinSource read FSkinSource write SetSkinSource;
  published
    { Published declarations }
    property SkinData: integer read FSkinData write FSkinData;
  end;

function GetSkinEngine(Owner: TComponent): TscSkinEngine;

implementation {===============================================================}

uses

  ComCtrls, FileCtrl;

//{$R *.res}

const
  cHotkeyPrefix = '&';
  cLineCaption = '-';

type

{ TAccelWnd - for accel message handle }

  TAccelWnd = class(TCustomControl)
  private
    FSkinEngine: TscSkinEngine;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  public
  end;

{ TAccelWnd }

procedure TAccelWnd.CMDialogChar(var Message: TCMDialogChar);
begin
  SendMessage(FSkinEngine.GetHandle, WM_SKINSYSCOMMAND, SC_KEYMENU, Message.CharCode);
end;

{ TscSkinEngine }

constructor TscSkinEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBorderIcons := [sbSystemMenu, sbMinimize, sbMaximize, sbRollup, sbHelp, sbClose];
  FWindowStates := [wsSizeable];
  FMainMenuShow := true;
  FAllowDraw := true;
  FSizeable := true;
  if not (csDesigning in ComponentState) and (Owner is TCustomForm) then
  begin
    FHook := TscHook.Create(Self);
    FForm := (AOwner as TWinControl);
    FHook.WinControl := FForm;
    FHook.BeforeMessage := DoHook;
    FHook.AfterMessage := DoHookAfterForm;
    FHook.Active := false;

    CreateSystemMenu;

    (FForm as TForm).AutoScroll := false;
    (FForm as TForm).BorderIcons := [];

    FSkinMainMenu := TList.Create;
    FMainMenuItems := TList.Create;
    FSkinPopupMenus := TList.Create;

    FMainMenuTrack := false;

    FAccelWnd := TAccelWnd.Create(Owner);
    (FAccelWnd as TAccelWnd).FSkinEngine := Self;
    FAccelWnd.Parent := (Owner as TWinControl);
    FAccelWnd.Width := 0;
    FAccelWnd.Height := 0;
    FAccelWnd.Visible := true;;

    FCash := TBitmap.Create;
    FCash.Width := Screen.Width;
    FCash.Height := Screen.Height;

    FTimer := TTimer.Create(Self);
    FTimer.OnTimer := DoTimer;
    FTimer.Interval := 10;
    FTimer.Enabled := false;
  end;
end;

destructor TscSkinEngine.Destroy;
begin
  if FHook <> nil then FHook.Free;
  if FTimer <> nil then FTimer.Free;
  if FCash <> nil then FCash.Free;
  if FSkinSource <> nil then FSkinSource.Free;

  if FMainMenuItems <> nil then FMainMenuItems.Free;

  if FSkinMainMenu <> nil then FSkinMainMenu.Free;
  if FSkinPopupMenus <> nil then FSkinPopupMenus.Free;
  inherited Destroy;
end;

procedure TscSkinEngine.Loaded;
var
  i: integer;
begin
  inherited;
  if csDesigning in ComponentState then Exit;
  SetSkinSource(FSkinSource);
  if FMainMenu = nil then Exit;
  FMainMenu.OnChange := DoMainMenuChanged;
  for i := 0 to FSkinMainMenu.Count-1 do
    if FSkinMainMenu[i] <> nil then
      TPopupMenu(FSkinMainMenu[I]).Images := FMainMenu.Images;
end;

{ Inside methods =============================================================}

function TscSkinEngine.GetHandle: HWnd;
begin
  if FHandle = 0 then
    if FForm <> nil then
      Result := FForm.Handle
    else
      Result := 0
  else
    Result := FHandle;
end;

function TscSkinEngine.GetParentLeft: integer;
var
  R: TRect;
begin
  if FHandle = 0 then
    Result := FForm.Left
  else
  begin
    GetWindowRect(FHandle, R);
    Result := R.left;
  end;
end;

function TscSkinEngine.GetParentTop: integer;
var
  R: TRect;
begin
  if FHandle = 0 then
    Result := FForm.Top
  else
  begin
    GetWindowRect(FHandle, R);
    Result := R.top;
  end;
end;

function TscSkinEngine.GetText: string;
begin
  Result := '';
  if FForm <> nil then
    Result := (FForm as TForm).Caption;
end;

function TscSkinEngine.GetActive: boolean;
begin
//  GetForegroundWindow = GetHandle
  Result := FActive;
end;

procedure TscSkinEngine.DoHook(Sender: TObject; var Msg: TMessage;
  var Handled: Boolean);
begin
  case Msg.Msg of
    { SkinEngine }
    WM_DRAWSKIN:
      DrawSkin;
    WM_ROLLUP:
    begin
      if wsRollup in WindowStates then
        WindowStates := WindowStates - [wsRollup]
      else
        WindowStates := WindowStates + [wsRollup];
      DrawSkin;
    end;
    WM_STAYONTOP:
    begin
      if wsStayOnTop in WindowStates then
        WindowStates := WindowStates - [wsStayOnTop]
      else
        WindowStates := WindowStates + [wsStayOnTop];
      DrawSkin;
    end;
    WM_TRACKSYSTEMMENU:
      if sbSystemMenu in FBorderIcons then
        TrackSystemMenu;
    WM_SKINMAINMENUCHANGED:
      SetMenu(GetHandle, 0);
    WM_SKINSYSCOMMAND: WMSkinSysCommand(Msg);
    { Windows menus }
    WM_EXITMENULOOP:
      if FMainMenuTrack then
        EndMenuLoop;
    WM_COMMAND: WMCommand(Msg);
    { Window NC }
    WM_NCACTIVATE:
    begin
      WMNCActivate(TWMNCActivate(Msg));
      Handled := true;
    end;
    WM_NCCALCSIZE:
    begin
      WMNCCalcSize(TWMNCCalcSize(Msg));
      Handled := true;
    end;
    WM_NCPAINT:
    begin
      WMNCPaint(TWMNCPaint(Msg));
      Handled := true;
    end;
    WM_NCHITTEST:
    begin
      WMNCHitTest(TWMNCHitTest(Msg));
      if TWMNCHitTest(Msg).Result <> HTCLIENT then
        Handled := true;
    end;
    WM_NCLButtonDown: WMNCLButtonDown(TWMNCLButtonDown(Msg));
    WM_NCRButtonDown: WMNCRButtonDown(TWMMouse(Msg));
    WM_NCLButtonUp: WMNCLButtonUp(TWMNCLButtonUp(Msg));
    WM_NCRButtonUp: WMNCRButtonUp(TWMNCRButtonUp(Msg));
    WM_NCMOUSEMOVE: WMNCMouseMove(TWMNCMouseMove(Msg));
    { Others }
    WM_SETCURSOR: WMSetCursorBefore(Msg);
    WM_SIZE: WMSize(Msg);
    WM_ACTIVATE: WMActivate(Msg);
    WM_PAINT: WMPaint(TWMPaint(Msg));
    WM_KEYDOWN: WMKeyDown(TWMKey(Msg));
    WM_ERASEBKGND: begin
      WMEraseBkGnd(TWMEraseBkGnd(Msg));
      Handled := true;
    end;
  end;
end;

procedure TscSkinEngine.DoHookAfterForm(Sender: TObject; var Msg: TMessage;
  var Handled: Boolean);
begin
  case Msg.Msg of
    WM_SYSCOMMAND:
    begin
      case Msg.wParam of
        SC_MAXIMIZE: FWindowStates := FWindowStates + [wsMaximized];
        SC_RESTORE: FWindowStates := FWindowStates - [wsMaximized];
        SC_MINIMIZE: FWindowStates := FWindowStates + [wsMinimized];
      end;
      PostMessage(GetHandle, WM_DRAWSKIN, 0, 0);
    end;
    WM_GETTEXT:
    if Msg.Result <> OldTextLen then
    begin
      PostMessage(GetHandle, WM_DRAWSKIN, 0, 0);
      OldTextLen := Msg.Result;
      Msg.Result := 0;
    end;
    WM_SETCURSOR: WMSetCursorAfter(Msg);
    WM_GETMINMAXINFO: WMGetMinMaxInfo(TWMGetMinMaxInfo(Msg));
    WM_NCLBUTTONDBLCLK: WMNCLButtonDblClk(TWMLButtonDblClk(Msg));
  end;
  Handled := Msg.Result <> 0;
end;

{ Windows handlers ============================================================}

procedure TscSkinEngine.WMCommand(var Msg: TMessage);
var
  i: integer;
begin
  if FMainMenu <> nil then
  begin
    for i := 0 to FSkinMainMenu.Count - 1 do
      if FSkinMainMenu[i] <> nil then
        if TPopupMenu(FSkinMainMenu[i]).DispatchCommand(Msg.wParam) then
          Msg.Result := 0;
  end;
  // Other popup menus
  for i := 0 to FSkinPopupMenus.Count - 1 do
    if TPopupMenu(FSkinPopupMenus[i]).DispatchCommand(Msg.wParam) then
      Msg.Result := 0;
end;

{ SkinEngine messages =========================================================}

procedure TscSkinEngine.WMSkinSysCommand(var Msg: TMessage);
var
  i: integer;
  R: TRect;
begin
  if Msg.wParam = SC_KEYMENU then
  begin
    // menus accelerators
    if FMainMenu = nil then exit;
    for i := 0 to FMainMenu.Items.Count-1 do
    begin
      if IsAccel(Msg.lParam, FMainMenu.Items[i].Caption) then
      begin
        // Hover and leave
        if FMouseObject <> nil then
        begin
          FMouseObject.OnLeave(false);
          FMouseObject := nil;
        end;
        FMouseObject := TscSkinObject(FMainMenuItems[i]);
        FMouseObject.OnHover(false);
        // Track popup menu
        R := TscSkinObject(FMainMenuItems[i]).BoundsRect;
        TrackPopupMenu(GetParentLeft + R.left, GetParentTop + R.bottom, i);
        Msg.Result := 1;
        Break;
      end;
    end;
  end;
end;

{ Size, move, cacl size ======================================================}

procedure TscSkinEngine.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
var
  R: TRect;
begin
  if (FSkinSource = nil) or (not FSkinSource.isLoad) or
     (FSkinSource.Form = nil) 
  then
    Exit;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  Msg.MinMaxInfo.ptMaxSize := Point(R.right-R.left, R.bottom-R.top);
  Msg.MinMaxInfo.ptMaxPosition := Point(R.left, R.top);
  Msg.MinMaxInfo.ptMaxTrackSize := Point(R.right-R.left, R.bottom-R.top);
  with FSkinSource do
    Msg.MinMaxInfo.ptMinTrackSize := Point(100, GetMinHeight);
  Msg.Result := 0;
end;

{ Key =========================================================================}

procedure TscSkinEngine.WMKeyDown(var Msg: TWMKey);
begin
  if Msg.CharCode = VK_MENU then
    Msg.Result := 0;
end;

procedure TscSkinEngine.WMSize(var Msg: TMessage);
begin
  MakeRegion;
//  Msg.Result := 0;
end;

procedure TscSkinEngine.WMNCCalcSize(var Msg: TWMNCCalcSize);
var
  rgrc: PNCCalcSizeParams;
  WP: PWindowPos;
  m_lLeft, m_lRight, m_lTop, m_lBottom: integer;
  Client: TscSkinObject;
  R: TRect;
begin
  if (Msg.CalcValidRects) and (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    rgrc := Msg.CalcSize_Params;
    // Client area
    with rgrc^.rgrc[1] do
    begin
      FWidth := Right-Left;
      FHeight := Bottom-top;
    end;
    Client := FSkinSource.Form.FindObjectByKind(skClient);
    if Client <> nil then
    begin
      if (FMainMenuShow) and (FSkinSource.MenuBar <> nil) then
      begin
        FSkinSource.MenuBar.VisibleNow := FMainMenuShow;
        if wsRollup in WindowStates then
          FSkinSource.MenuBar.VisibleNow := false;
      end;
      FSkinSource.Form.BoundsRect := Rect(0, 0, FWidth, FHeight);
      R := Client.BoundsRect;
      m_lLeft := R.left;
      m_lRight := FWidth-R.right;
      m_lTop := R.top;
      m_lBottom := FHeight-R.bottom;
    end
    else
    begin
      m_lLeft := 0;
      m_lRight := 0;
      m_lTop := 0;
      m_lBottom := 0;
    end;
    WP := rgrc.lppos;
    with rgrc^.rgrc[0] do
    begin
      left := WP^.x;
      top := WP^.y;
      right := WP^.x + WP^.cx;
      bottom := WP^.y + WP^.cy;
      left := left + m_lLeft;
      top := top + m_lTop;
      right := right - m_lRight;
      bottom := bottom - m_lBottom;
    end;
    rgrc^.rgrc[1] := rgrc^.rgrc[0];
    Msg.CalcSize_Params := rgrc;
    Msg.Result := WVR_VALIDRECTS;
  end;
end;

{ Focus =======================================================================}

procedure TscSkinEngine.WMActivate(var Msg: TMessage);
begin
  Msg.Result := 0;
end;

{ Non client ==================================================================}

procedure TscSkinEngine.WMNCActivate(var Msg: TWMNCActivate);
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    FActive := Msg.Active;
    if Msg.Unused = 0 then
      DrawSkin;
    Msg.Result := 1;
  end
  else
    Msg.Result := 0;
end;

function TscSkinEngine.NormalizePoint(P: TPoint): TPoint;
var
  WindowPos, ClientPos: TPoint;
  HandleParent: HWnd;
begin
  HandleParent := GetParent(GetHandle);
  { Calc windowpos - screen }
  WindowPos := Point(GetParentLeft, GetParentTop);
  if HandleParent <> 0 then
    ClientToScreen(HandleParent, WindowPos);
  { Calc clientpos - screen }
  ClientPos := Point(0, 0);
  ClientToScreen(GetHandle, ClientPos);
  { Calc local pos }
  Result := P;
  ScreenToClient(GetHandle, Result);
  { Offset to client offset }
  Inc(Result.X, ClientPos.X-WindowPos.X);
  Inc(Result.Y, ClientPos.Y-WindowPos.Y);
end;

var
  HitTestPoint: TPoint;
  HitTestResult: integer;

function TscSkinEngine.GetHitTest(P: TPoint): integer;
 procedure CheckCaption(SkinObject: TscSkinObject);
 var
   R: TRect;
 begin
   if not SkinObject.VisibleNow then Exit;
   R := SkinObject.BoundsRect;
   if PtInRect(R, HitTestPoint) then
     case SkinObject.Kind of
       skCaption:
         HitTestResult := HTCAPTION;
     end;
 end;
 procedure CheckHitTest(SkinObject: TscSkinObject);
 var
   R: TRect;
 begin
   if not SkinObject.VisibleNow then Exit;
   R := SkinObject.BoundsRect;
   if PtInRect(R, HitTestPoint) then
     case SkinObject.Kind of
       skTop: HitTestResult := HTTOP;
       skBottom: HitTestResult := HTBOTTOM;
       skLeft: HitTestResult := HTLEFT;
       skRight: HitTestResult := HTRIGHT;
       skTopLeft: HitTestResult := HTTOPLEFT;
       skTopRight: HitTestResult := HTTOPRIGHT;
       skBottomLeft: HitTestResult := HTBOTTOMLEFT;
       skBottomRight: HitTestResult := HTBOTTOMRIGHT;
       skCaption, skTitle: HitTestResult := HTCAPTION;
       skSysButton: HitTestResult := HTREDUCE;
       skMenuBar: HitTestResult := HTREDUCE;
     end;
 end;
begin
  // Get HitTest
  Result := HTCLIENT;
  if FSkinSource = nil then Exit;
  if isIconic(GetHandle) then Exit;
  if isZoomed(GetHandle) then Exit;
  with FSkinSource do
  begin
    HitTestPoint := P;
    HitTestResult := HTCLIENT;
    Form.CallObject(@CheckCaption);

    Form.CallObject(@CheckHitTest);
    if (wsRollup in WindowStates) or not (FSizeable) then
    begin
      case HitTestResult of
        HTTOP, HTBOTTOM, HTLEFT, HTRIGHT,
        HTTOPLEFT, HTTOPRIGHT, HTBOTTOMLEFT, HTBOTTOMRIGHT: HitTestResult := HTREDUCE;
      end;
    end;
    Result := HitTestResult;
  end;
end;

procedure TscSkinEngine.WMNCHitTest(var Msg: TWMNCHitTest);
var
  P: TPoint;
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    P := NormalizePoint(Point(Msg.XPos, Msg.YPos));
    Msg.Result := GetHitTest(P);
  end
  else
    Msg.Result := 0;
end;

procedure TscSkinEngine.WMNCPaint(var Msg: TWMNCPaint);
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    DrawSkin;
    if isZoomed(GetHandle) then
      Msg.Result := 0
    else
      Msg.Result := 1;
  end;
end;

procedure TscSkinEngine.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
var
  R: TRect;
  Canvas: TCanvas;
  Client: TscSkinObject;
begin
  if FSkinSource = nil Then Exit;
  Canvas := TCanvas.Create;
  try
    if (Msg.DC <> 0) then
      Canvas.Handle := Msg.DC
    else
      Canvas.Handle := GetDC(GetHandle);
    Client := FSkinSource.Form.FindObjectByKind(skClient);
    if Client <> nil then
    begin
      R := Client.BoundsRect;
      Client.BoundsRect := Rect(0, 0, FWidth, FHeight);
      Client.Draw(Canvas);
      Client.BoundsRect := R;
    end;
  finally
    Canvas.Free;
    Msg.Result := 0;
  end;
end;

{ Non client mouse ============================================================}

procedure TscSkinEngine.DoTimer(Sender: TObject);
var
  MouseObject: TscSkinObject;
  MousePoint: TPoint;
  i: integer;
begin
  if not Assigned(FSkinSource) Then Exit;
  if FSkinSource.Form = nil Then Exit;
  if (not Active) and (not isIconic(GetHandle)) then Exit;

  i := 0;
  while i < Objects.Count do
  begin
    if TscSkinObject(Objects[i]).Kind <> skPopupMenuItem then { MenuWnd }
      TscSkinObject(Objects[i]).ProcessScript;
    Inc(i);
  end;

  GetCursorPos(MousePoint);
  MousePoint := NormalizePoint(Point(MousePoint.X, MousePoint.Y));
  MouseObject := FSkinSource.Form.FindObjectByPoint(MousePoint);

  { Hover and Leave events }
  if (MouseObject = nil) then
  begin
    if (FMouseObject <> nil) then
    begin
      FMouseObject.OnLeave(false);
      FMouseObject := nil;
    end;
  end
  else
    if (MouseObject <> nil) and (MouseObject.VisibleNow) and (MouseObject <> FMouseObject) then
    begin
      if (FMouseObject <> nil) then
        FMouseObject.OnLeave(false);
      FMouseObject := MouseObject;
      FMouseObject.OnHover(false);
      { Track menu }
      if (MouseObject.Kind = skMenuBarItem) and (FMainMenuTrack) then
      begin
        TrackPopupMenu(MouseObject.Left + GetParentLeft, GetParentTop +
          MouseObject.Top + MouseObject.Height, MouseObject.Tag);
      end;
    end;
end;

procedure TscSkinEngine.WMNCLButtonDblClk(var Msg: TWMMouse);
var
  P: TPoint;
  SkinObject: TscSkinObject;
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    P := NormalizePoint(Point(Msg.XPos, Msg.YPos));
    // ClickEvent
    SkinObject := FSkinSource.Form.FindObjectByPoint(P);
    if (SkinObject <> nil) and (SkinObject.VisibleNow) then
      SkinObject.OnDoubleClick(false);
  end;
end;

procedure TscSkinEngine.WMNCRButtonDown(var Msg: TWMMouse);
var
  P: TPoint;
  SkinObject: TscSkinObject;
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    P := NormalizePoint(Point(Msg.XPos, Msg.YPos));
    // ClickEvent
    SkinObject := FSkinSource.Form.FindObjectByPoint(P);
    if (SkinObject <> nil) and (SkinObject.VisibleNow) then
      SkinObject.OnRightClick(false);
    Msg.Result := 0;
  end;
end;

procedure TscSkinEngine.WMNCRButtonUp(var Msg: TWMNCRButtonUp);
begin
  Msg.Result := 0;
end;

procedure TscSkinEngine.WMNCLButtonDown(var Msg: TWMNCLButtonDown);
var
  P: TPoint;
  SkinObject: TscSkinObject;
  M: TMenuItem;
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    P := NormalizePoint(Point(Msg.XCursor, Msg.YCursor));
    // ClickEvent
    SkinObject := FSkinSource.Form.FindObjectByPoint(P);
    if (SkinObject <> nil) and (SkinObject.VisibleNow) then
    begin
      { OnClick event }
      SkinObject.OnClick(false);
      SkinObject.WaitForFinish;
      if Pos('max', LowerCase(SkinObject.ClickEvent.Text)) > 0 then
      begin
        SkinObject.OnLeave(false);
        SkinObject.WaitForFinish;
      end
      else
      begin
        SkinObject.OnHover(false);
        SkinObject.WaitForFinish;
      end;
      { Track menu }
      if SkinObject.Kind = skMenuBarItem then
      begin
        FMainMenuTrack := true;
        if FSkinMainMenu[SkinObject.Tag] = nil then
        begin
          M := FMainMenu.Items[SkinObject.Tag];
          if M <> nil then M.Click;
          FMainMenuTrack := false;
          RecreateMainMenu;
        end
        else
          TrackPopupMenu(SkinObject.Left + GetParentLeft, GetParentTop +
            SkinObject.Top + SkinObject.Height, SkinObject.Tag);
      end;
    end;
    { }
    if isZoomed(GetHandle) then
    begin
      Msg.Result := 1;
      Exit;
    end;
    Msg.Result := 0;
  end;
end;

procedure TscSkinEngine.WMNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
    Msg.Result := 0;
end;

procedure TscSkinEngine.WMNCMouseMove(var Msg: TWMNCMouseMove);
begin
  if (FSkinSource = nil) or (not FSkinSource.isLoad) then
  begin
    Msg.Result := 0;
    Exit;
  end;
  Msg.Result := 1;
end;

{ Other messages =============================================================}

procedure TscSkinEngine.WMSetCursorBefore(var Msg: TMessage);
begin
  lStyle := GetWindowLong(GetHandle, GWL_STYLE);
  SetWindowLong(GetHandle, GWL_STYLE, lStyle And Not WS_VISIBLE);
end;

procedure TscSkinEngine.WMSetCursorAfter(var Msg: TMessage);
begin
  SetWindowLong(GetHandle, GWL_STYLE, lStyle);
end;

procedure TscSkinEngine.WMPaint(var Msg: TWMPaint);
begin
  Msg.Result := 0;
end;

{ Popup and main menus ========================================================}

function TscSkinEngine.CreatePopupMenu(Items: TMenuItem): TscPopupMenu;
const
  IBreaks: array[TMenuBreak] of Longint = (MFT_STRING, MFT_MENUBREAK, MFT_MENUBARBREAK);

 procedure AddMenuItem(Items: TMenuItem; AddItems: TMenuItem);
 var
   Item: TMenuItem;
   i: integer;
 begin
   for i := 0 to AddItems.Count-1 do
   begin
     with AddItems[i] do
       Item := NewItem(Caption, ShortCut, Checked, Enabled, OnClick,
         HelpContext, 'sm'+Name);
     Item.Bitmap := AddItems[i].Bitmap;
     Item.ImageIndex := AddItems[i].ImageIndex;
     Item.Visible := AddItems[i].Visible;
     // Create sub menu
     if AddItems[i].Count > 0 then
       AddMenuItem(Item, AddItems[i]);
     Items.Add(Item);
   end;
 end;
 procedure ChangeItem(Items: TMenuItem);
 var
   Item: TMenuItem;
   i: integer;
 begin
   for i := 0 to Items.Count-1 do
   begin
     Item := Items[i];
     ModifyMenu(Item.Parent.Handle, Item.Command,
       MF_BYCOMMAND or MF_OWNERDRAW or IBreaks[Item.Break],
       Item.Command, PChar(i));
     // Sub menu
     if Items[i].Count > 0 then
       ChangeItem(Item);
   end;
 end;
begin
  Result := TscPopupMenu.Create(Self);
  Result.SkinEngine := Self;
  Result.Images := FMainMenu.Images;
  Result.OwnerDraw := true;
  AddMenuItem(Result.Items, Items);
  ChangeItem(Result.Items);
end;

procedure TscSkinEngine.CreateSystemMenu;
var
  M: TMenuItem;
  i, Command, Count: integer;
  SysMenu: HMenu;
  B: TBitmap;
  Bmp: HBitmap;
  Text: PChar;
  ShortCut: TShortCut;
begin
  FSystemMenu := TscPopupMenu.Create(Self);
  FSystemMenu.SkinEngine := Self;
  SysMenu := GetSystemMenu(GetHandle, false);
  Count := GetMenuItemCount(SysMenu);
  if Count < 0 then Exit;
  GetMem(Text, 100);
  try
    Command := 0;
    for i := 0 to Count-1 do
    begin
      GetMenuString(SysMenu, i, Text, 100, MF_BYPOSITION);
      if StrLen(Text) = 0 then
        M := NewLine
      else
      begin
        ShortCut := 0;
        if Pos(#9, Text) > 0 then
        begin
          ShortCut := TextToShortCut(Copy(Text, Pos(#9, Text)+1, Length(Text)));
          Text[Pos(#9, Text)-1] := #0;
        end;
        M := NewItem(Text, ShortCut, false, true, DoSystemCommand, 0,
          'miSys'+IntToStr(i));
        Bmp := 0;
        case TSystemCommand(Command) of
          sscRestore: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMRESTORE');
          sscMinimize: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMMINIMIZE');
          sscMove: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMMOVE');
          sscSize: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMSIZE');
          sscMaximize: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMMAXIMIZE');
          sscClose: Bmp := LoadBitmap(HInstance, 'KSSKIN_SYSTEMCLOSE');
        end;
        if Bmp <> 0 then
        begin
          B := TBitmap.Create;
          try
            B.Handle := Bmp;
            M.Bitmap.Assign(B);
          finally
            B.Free;
          end;
        end;
        M.Tag := Command; // scSyatemCommand
        Inc(Command);
      end;
      FSystemMenu.Items.Add(M);
    end;
    M := NewLine;
    FSystemMenu.Items.Add(M);
    // Add RollUp Command
    M := NewItem(SRollup, 0, false, true, DoSystemCommand, 0,
      'miSysRoll');
    M.Tag := Integer(sscRollup);
    FSystemMenu.Items.Add(M);
  finally
    FreeMem(Text, 100);
  end;
end;

procedure TscSkinEngine.TrackSystemMenu;
var
  i: integer;
  M: TMenuItem;
  P: TPoint;
begin
  // Enable/Disable commands
  for i := 0 to FSystemMenu.Items.Count-1 do
  begin
    M := TMenuItem(FSystemMenu.Items[i]);
    M.Enabled := false;
    case TSystemCommand(M.Tag) of
      sscRestore: if (sbMaximize in FBorderIcons) and (isZoomed(GetHandle))
        then M.Enabled := true;
      sscMove: M.Enabled := true;
      sscSize: if wsSizeable in WindowStates then M.Enabled := true;
      sscMinimize: if sbMinimize in FBorderIcons then M.Enabled := true;
      sscMaximize: if (sbMaximize in FBorderIcons) and not (isZoomed(GetHandle))
        then M.Enabled := true;
      sscClose: M.Enabled := true;
      sscRollup: if (sbRollup in FBorderIcons) then M.Enabled := true;
      sscAboutSkin: ;
      sscChangeSkin: ;
    end;
  end;
  // Track system menu
  if FSkinSource <> nil then
  with FSkinSource do
  begin
    { Calc position }
    if (MenuBar <> nil) and (Client <> nil) then
      P := Point(MenuBar.Left-Client.Left, MenuBar.Top-Client.Top)
    else
      P := Point(0, 0);
    { Offset }
    ClientToScreen(GetHandle, P);
    { Track }
    FSystemMenu.Popup(P.X, P.Y)
  end;
end;

procedure TscSkinEngine.DoSystemCommand(Sender: TObject);
begin
  // process system menu command
  if FSkinSource = nil then Exit;
  if FSkinSource.Form = nil then Exit;

  case TSystemCommand(TMenuItem(Sender).Tag) of
    sscRestore: FSkinSource.Form.RunScript('max');
    sscMove: FSkinSource.Form.RunScript('move');
    sscSize: FSkinSource.Form.RunScript('size');
    sscMinimize: FSkinSource.Form.RunScript('min');
    sscMaximize: FSkinSource.Form.RunScript('max');
    sscClose: FSkinSource.Form.RunScript('close');
    sscRollup: FSkinSource.Form.RunScript('rollup');
    sscAboutSkin:
    begin
    end;
    sscChangeSkin:
    begin
    end;
  end;
  DrawSkin;
end;

procedure TscSkinEngine.DoMainMenuChanged(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  RecreateMainMenu;
end;

procedure TscSkinEngine.DoPopupMenuChanged(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
 function FindItem(Item, Items: TMenuItem): TMenuItem;
 var
   i: integer;
 begin
   for i := 0 to Items.Count-1 do
   begin
     if (Items[i].Caption = Item.Caption) and
        (@Items[i].OnClick = @Item.OnClick)
     then
     begin
       Result := Items[i];
       Break;
     end;
     if Items[i].Count > 0 then
       Result := FindItem(Item, Items[i]);
   end;
 end;
var
  Item: TMenuItem;
begin
  if Source = nil then Exit;
  { Find source in mainmenu and change it state }
  Item := FindItem(Source, FMainMenu.Items);
  if Item <> nil then
  begin
    Item.Checked := Source.Checked;
    Item.Enabled := Item.Enabled;
    Item.Caption := Item.Caption;
    Item.Visible := Item.Visible;
  end;
  RecreateMainMenu;
end;

procedure TscSkinEngine.ChangeMainMenuItem(Item: TMenuItem);
begin
  DoPopupMenuChanged(nil, Item, false);
end;

procedure TscSkinEngine.RecreateMainMenu;
begin
  { Destroy old menu }
  if FMainMenu = nil then Exit;
  if FSkinSource = nil then Exit;
  CreateMainMenu;
  FMainMenuTrack := false;
  PostMessage(GetHandle, WM_SKINMAINMENUCHANGED, 0, 0);
end;

procedure TscSkinEngine.CreateMainMenu;
var
  MenuItemCount, i: integer;
  PM: TPopupMenu;
  MI: TscSkinObject;
  B: TBitmap;
begin
  if csDesigning in ComponentState then Exit;
  if FMainMenu = nil then Exit;
  if FSkinSource = nil then Exit;
  if FSkinSource.MenuBarItem = nil then Exit;
  if FSkinSource.MenuBarItem.Parent = nil then Exit;
  FMouseObject := nil;
  FTrackMenu := nil;
  { Destroy old menu }
  for i := 0 to FSkinMainMenu.Count - 1 do
    if FSkinMainMenu[i] <> nil then
      TPopupMenu(FSkinMainMenu[i]).Free;
  FSkinMainMenu.Clear;

  FSkinSource.MenuBarItem.Visible := [svNever];
  for i := 0 to FMainMenuItems.Count - 1 do
  if Assigned(FMainMenuItems[i]) then
  begin
    FSkinSource.MenuBarItem.Parent.DeleteChildObject(TscSkinObject(FMainMenuItems[i]));
    TscSkinObject(FMainMenuItems[i]).Free;
  end;
  FMainMenuItems.Clear;
  { Create new popups menu}
  B := TBitmap.Create;
  try
    MenuItemCount := 0;
    for i := 0 to FMainMenu.Items.Count - 1 do
    begin
      { Create popup menu }
      if FMainMenu.Items[i].Count > 0 then
      begin
        PM := CreatePopupMenu(FMainMenu.Items[i]);
        PM.OnChange := DoPopupMenuChanged;
        FSkinMainMenu.Add(PM);
      end
      else
        FSkinMainMenu.Add(nil);
      { Add SkinMenuitem }
      MI := TscSkinObject.Create;
      MI.Assign(FSkinSource.MenuBarItem);
      MI.Text := FMainMenu.Items[i].Caption;
      MI.Visible := [svAlways];
      MI.Tag := MenuItemCount; // set MenuItem
      Inc(MenuItemCount);
      // calc width
      with B.Canvas do
      begin
        Font.Name := MI.FontName;
        Font.Size := MI.FontSize;
        Font.Style := MI.FontStyle;
        MI.Width := TextWidth(MI.Text)+8;
      end;
      FMainMenuItems.Add(MI);
      FSkinSource.MenuBarItem.Parent.AddChild(MI);
    end;
  finally
    B.Free;
  end;
end;

procedure TscSkinEngine.TrackPopupMenu(X, Y: integer; Item: integer);
var
  R: TRect;
begin
  if not FMainMenuShow then Exit;
  if wsRollup in WindowStates then Exit;
  if Item < 0 then Exit;
  if FTrackMenu = FSkinMainMenu[Item] then Exit;
  { Track popup menu }
  FMainMenuTrack := false;
  if FTrackMenu <> nil then
  begin
    FTrackMenu.EndPopup;
    Application.ProcessMessages;
  end;
  FMainMenuTrack := true;
  FTrackMenu := TscPopupMenu(FSkinMainMenu[Item]);
  if FSkinMainMenu[Item] = nil then Exit;
  if FForm <> nil then
  begin
    R.TopLeft := FForm.ClientToScreen(TscSkinObject(FMainMenuItems[Item]).BoundsRect.TopLeft);
    R.BottomRight := FForm.ClientToScreen(TscSkinObject(FMainMenuItems[Item]).BoundsRect.BottomRight);
    if (FSkinSource <> nil) and (FSkinSource.Client <> nil) then
      OffsetRect(R, -FSkinSource.Client.Left, -FSkinSource.Client.Top);
    FTrackMenu.ItemRect := R;
  end
  else
    FTrackMenu.ItemRect := Rect(0, 0, 0, 0);
  FTrackMenu.Popup(X, Y);
end;

procedure TscSkinEngine.EndMenuLoop;
begin
  // end menu loop
  FMainMenuTrack := false;
  FTrackMenu := nil;
end;

{ Drawing =====================================================================}

var
  GShowMenuBar: boolean;
  GBorderIcons: TscBorderIcons;
  GStates: TscWindowStates;
  GActive: boolean;
  GCaption: string;
  GSkinEngine: TscSkinEngine;
  GMainMenu: TMainMenu;

procedure TscSkinEngine.DrawSkin;
 procedure CheckVisibleNow(SkinObject: TscSkinObject);
 begin
   if svNever in SkinObject.Visible then
   begin
     SkinObject.VisibleNow := false;
     Exit;
   end;
   SkinObject.VisibleNow := SkinObject.ObjectVisible(GActive, GBorderIcons,
     GStates, GSkinEngine);
   if GMainMenu <> nil then
     if (SkinObject.Kind = skMenuBarItem) and (SkinObject.Tag >= 0) then
       if GMainMenu.Items[SkinObject.Tag] <> nil then
         SkinObject.VisibleNow := GMainMenu.Items[SkinObject.Tag].Visible;
   if SkinObject.Kind = skTitle then
   begin
     SkinObject.Text := GCaption;
   end;
   if (SkinObject.Kind = skMenuBar) then
   begin
     SkinObject.VisibleNow := GShowMenuBar;
     if (wsRollup in GStates) then
       SkinObject.VisibleNow := false;
   end;
 end;
var
  Canvas: TCanvas;
  R: TRect;
begin
  if (FSkinSource <> nil) and (FSkinSource.isLoad) then
  begin
    GetWindowRect(GetHandle, R);
    FWidth := R.right - R.left;
    FHeight := R.bottom - R.top;
    // set VisibleNow property
    GMainMenu := FMainMenu;
    GBorderIcons := FBorderIcons;
    GStates := FWindowStates;
    GActive := Active;
    GShowMenuBar := FMainMenuShow;
    GSkinEngine := Self;
    if (FMainMenu = nil) then
      GShowMenuBar := false;
    // Set caption
    if (Owner is TForm) then
      GCaption := (Owner as TForm).Caption;
    FSkinSource.Form.CallObject(@CheckVisibleNow);
    FSkinSource.Form.Wnd := GetHandle;
    // align form
    FSkinSource.Form.BoundsRect := Rect(0, 0, FWidth, FHeight);
    // draw skin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := GetWindowDC(GetHandle);
      // Draw skin to cash
      with FSkinSource do
      begin
        if Form.FindObjectByKind(skClient) <> nil then
        begin
          R := Form.FindObjectByKind(skClient).BoundsRect;
          if (FSkinSource.MenuBar <> nil) and (not (wsRollup in WindowStates)) and
             (FMainMenuShow)
          then
            SubtractRect(R, R, FSkinSource.MenuBar.BoundsRect);
          ExcludeClipRect(Canvas.Handle, R.left, R.top, R.right, R.bottom);
          if not FAllowDraw then
          begin
            R := FSkinSource.MenuBar.BoundsRect;
            ExcludeClipRect(Canvas.Handle, R.left, R.top, R.right, R.bottom);
          end;
        end;
      end;
      FSkinSource.Form.Draw(FCash.Canvas);
      // Draw cash
      Canvas.Draw(0, 0, FCash);
    finally
      ReleaseDC(GetHandle, Canvas.Handle);
      Canvas.Handle := 0;
      Canvas.Free;
    end;
  end;
end;

{ Region functions ============================================================}


procedure TscSkinEngine.MakeRegion;
var
  WndRgn: HRgn;
begin
  // Change cash size
  if (FSkinSource = nil) or (not FSkinSource.isLoad) or (FSkinSource.Form = nil) then
  begin
    SetWindowRgn(GetHandle, 0, true);
    Exit;
  end;
  with FSkinSource do
  begin
  try
    // Set window region
    Form.BoundsRect := Rect(0, 0, FWidth, FHeight);
    WndRgn := FSkinSource.Form.GetMask;
    SetWindowRgn(GetHandle, WndRgn, true);
  except
  end;
  end;
end;

{ SkinEngine methods ==========================================================}

procedure TscSkinEngine.LoadFromFolder(Path: string);
var
  SS: TscSkinSource;
  SR: TSearchRec;
begin
  if Path = '' then
  begin
    SkinSource := nil;
    Exit;
  end;
  if Path[Length(Path)] <> '\' then
    Path := Path + '\';

  if not DirectoryExists(Path) then Exit;
  if FindFirst(Path+'*.ksp', $FF, SR) = 0 then
  begin
  try
    try
      FTimer.Enabled := false;
      FHook.Active := false;
      FMouseObject := nil;
      FTrackMenu := nil;

      Application.ProcessMessages;
      try
        if FSkinSource <> nil then
          FSkinSource.Free;
        FSkinSource := nil;
        FMainMenuItems.Clear;

        SS := TscSkinSource.Create(Self);
        SS.LoadFromFolder(Path);
        SkinSource := SS;
        FSkinSource.SkinEngine := Self;
      finally
        DrawSkin;
        UpdateSkinSource;
        FHook.Active := true;
        FTimer.Enabled := true;
        Application.ProcessMessages;
        DrawSkin;
      end;
    except
    end;
  finally
    FindClose(SR);
  end;
  end;
end;

procedure TscSkinEngine.LoadFromFile(FileName: string);
var
  SS: TscSkinSource;
  SR: TSearchRec;
begin
  if FileName = '' then
  begin
    SkinSource := nil;
    Exit;
  end;

  if LowerCase(ExtractFileExt(FileName)) <> '.ksp' then Exit;
  if not FileExists(FileName) then Exit;

  try
    FTimer.Enabled := false;
    FHook.Active := false;
    FMouseObject := nil;
    FTrackMenu := nil;

    Application.ProcessMessages;
    try
      if FSkinSource <> nil then
        FSkinSource.Free;
      FSkinSource := nil;
      FMainMenuItems.Clear;

      SS := TscSkinSource.Create(Self);
      SS.LoadFromFile(FileName);
      SkinSource := SS;
      FSkinSource.SkinEngine := Self;
    finally
      DrawSkin;
      UpdateSkinSource;
      FHook.Active := true;
      FTimer.Enabled := true;
      Application.ProcessMessages;
      DrawSkin;
    end;
  except
  end;
end;

procedure TscSkinEngine.UpdateSkinSource;
var
  i: integer;
begin
  { Update skin images }
  if FForm <> nil then
  begin
    MakeRegion;
    RecreateMainMenu;
    with (FForm as TForm) do
      for i := 0 to ComponentCount-1 do
      begin
        if (Components[i] is TControl) then
          (Components[i] as TControl).Perform(WM_SKINCHANGE, 0, 0);
        if (Components[i] is TGraphicControl) then
          (Components[i] as TGraphicControl).Invalidate;
      end;
    (FForm as TForm).Invalidate;
  end;
end;

{ Property Handler ============================================================}

procedure TscSkinEngine.SetSkinSource(const Value: TscSkinSource);
begin
  if (FSkinSource <> Value) and Assigned(FSkinSource) then
    FSkinSource.Free;
  FSkinSource := Value;
  if FSkinSource <> nil then
  begin
    if FForm <> nil then
      (FForm as TForm).BorderIcons := [];
    FSkinSource.SkinEngine := Self;
    if not FSkinSource.Sizeable then
    begin
      FSizeable := false;
      if (FForm <> nil) and (FSkinSource.Form <> nil) then
      begin
        FForm.Width := FSkinSource.Form.Width;
        FForm.Height := FSkinSource.Form.Height;
      end;
    end;
    { Remove menu from window }
    SetMenu(GetHandle, 0);
    Application.ProcessMessages;
    FHook.Active := true;
    FTimer.Enabled := true;
  end
  else
    if FForm <> nil then
    with (FForm as TForm) do
    begin
      BorderIcons := [];
      if sbSystemMenu in FBorderIcons then
        BorderIcons := BorderIcons + [biSystemMenu];
      if sbMinimize in FBorderIcons then
        BorderIcons := BorderIcons + [biMinimize];
      if sbMaximize in FBorderIcons then
        BorderIcons := BorderIcons + [biMaximize];
      if sbHelp in FBorderIcons then
        BorderIcons := BorderIcons + [biHelp];
      { Add menu to window }
      if FMainMenu <> nil then
        SetMenu(GetHandle, FMainMenu.Handle);
      FHook.Active := false;
      FTimer.Enabled := false;
    end;
  UpdateSkinSource;
end;

procedure TscSkinEngine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinStore) then
    FSkinStore := nil;
  if (Operation = opRemove) and (AComponent = FSkinSource) then
    FSkinSource := nil;
  if (Operation = opRemove) and (AComponent = FSystemMenu) then
    FSystemMenu := nil;
  if (Operation = opRemove) and (AComponent = FMainMenu) then
    FMainMenu := nil;
end;

procedure TscSkinEngine.SetBorderIcons(const Value: TscBorderIcons);
begin
  FBorderIcons := Value;
  if FForm <> nil then
    FForm.Invalidate;
end;

procedure TscSkinEngine.SetMainMenu(const Value: TMainMenu);
begin
  FMainMenuTrack := false;
  FMainMenu := Value;
  CreateMainMenu;
end;

procedure TscSkinEngine.SetMainMenuShow(const Value: boolean);
begin
  FMainMenuShow := Value;
end;

function TscSkinEngine.GetMinHeight: integer;
var
  OldRect: TRect;
  MinHeight: integer;
begin
  Result := 0;
  if (FSkinSource <> nil) and (FSkinSource.Form <> nil) and
     (FSkinSource.Client <> nil)
  then
  begin
    OldRect := FSkinSource.Form.BoundsRect;
    try
      for MinHeight := 100 Downto 0 do
      begin
        FSkinSource.Form.BoundsRect := Rect(0, 0, FWidth, MinHeight);
        if (FSkinSource.Client.Height = 0) or (FSkinSource.Client = nil) then
        begin
          Result := MinHeight;
          Break;
        end
      end;
    finally
      FSkinSource.Form.BoundsRect := OldRect;
    end;
  end;
  if (wsRollup in FWindowStates) and (FMainMenuShow) and (FSkinSource.MenuBar <> nil) then
    Result := Result - FSkinSource.MenuBar.Height;
end;

procedure TscSkinEngine.SetWindowStates(const Value: TscWindowStates);
begin
  // change state
  if not (wsRollup in FWindowStates) and (wsRollup in Value) then
  begin
    // Rollup
    FBeforeRollupSize := FHeight;
    FWindowStates := Value;
    SetWindowPos(GetHandle, 0, GetParentLeft, GetParentTop, FWidth,
      GetMinHeight, SWP_NOMOVE);
    PostMessage(GetHandle, WM_DRAWSKIN, 0, 0);
  end;
  if (wsRollup in FWindowStates) and not (wsRollup in Value) then
  begin
    // UnRollup
    FWindowStates := Value;
    SetWindowPos(GetHandle, 0, GetParentLeft, GetParentTop, FWidth,
      FBeforeRollupSize, SWP_NOMOVE);
    PostMessage(GetHandle, WM_DRAWSKIN, 0, 0);
  end;
  // stay on top
  if not (wsStayOnTop in FWindowStates) and (wsStayOnTop in Value) then
  begin
    // make top
    SetWindowPos(GetHandle, HWND_TOPMOST, GetParentLeft, GetParentTop, FWidth,
      FHeight, SWP_SHOWWINDOW);
  end;
  if (wsStayOnTop in FWindowStates) and not (wsStayOnTop in Value) then
  begin
    // unmake top
    SetWindowPos(GetHandle, HWND_NOTOPMOST, GetParentLeft, GetParentTop, FWidth,
      FHeight, SWP_SHOWWINDOW);
  end;
  // maximize
  if not (wsMaximized in FWindowStates) and (wsMaximized in Value) then
    PostMessage(GetHandle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  if (wsMaximized in FWindowStates) and not (wsMaximized in Value) then
    PostMessage(GetHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
  if not (wsMinimized in FWindowStates) and (wsMinimized in Value) then
    PostMessage(GetHandle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  FWindowStates := Value;
end;

procedure TscSkinEngine.SetSkinStore(const Value: TscSkinStore);
var
  SS: TscSkinSource;
begin
  FSkinStore := Value;
  if not (csDesigning in ComponentState) then
  begin
    if Value = nil then
    begin
       SkinSource := nil;
       Exit;
    end;
    if FSkinStore.FSkinSource.IsLoad then
    begin
      try
        FTimer.Enabled := false;
        FHook.Active := false;
        FMouseObject := nil;
        FTrackMenu := nil;

        Application.ProcessMessages;
        try
          if FSkinSource <> nil then
             FSkinSource.Free;
          FSkinSource := nil;
          FMainMenuItems.Clear;

          SS := FSkinStore.FSkinSource.CreateCopy;
          SkinSource := SS;
          FSkinSource.SkinEngine := Self;
        finally
          DrawSkin;
          UpdateSkinSource;
          FHook.Active := true;
          FTimer.Enabled := true;
          Application.ProcessMessages;
          DrawSkin;
        end;
      except
      end;
    end;
  end;
end;

procedure TscSkinEngine.SetSkinFile(const Value: string);
begin
  FSkinFile := Value;
  if Value = '' then
  begin
    SkinSource := nil;
    Exit;
  end;
  if FSkinFile[1] = '\' then Delete(FSkinFile, 1, 1);
  if (FSkinFile = '') then exit;
  if LowerCase(ExtractFileExt(FSkinFile)) = '.ksp' then
  begin
    { Load from folder }
    FSkinFolder := ExtractFilePath(FSkinFile);
    try
      if FSkinFolder[2] = ':' then
        LoadFromFolder(FSkinFolder)
      else
        LoadFromFolder(ExtractFilePath(ParamStr(0))+FSkinFolder);
    except
    end;
  end
  else
  begin
    { Load from file }
    try
      if FSkinFile[2] = ':' then
        LoadFromFile(FSkinFile)
      else
        LoadFromFile(ExtractFilePath(ParamStr(0))+FSkinFile);
    except
    end;
  end;
end;

procedure TscSkinEngine.SetSkinFolder(const Value: string);
begin
  FSkinFolder := Value;
  if Value = '' then
  begin
    SkinSource := nil;
    Exit;
  end;
  if FSkinFolder[1] = '\' then Delete(FSkinFolder, 1, 1);
  if FSkinFolder[Length(FSkinFolder)] <> '\' then
    FSkinFolder := FSkinFolder + '\';
  if FSkinFolder <> '' then
  begin
    try
      if FSkinFolder[2] = ':' then
        LoadFromFolder(FSkinFolder)
      else
        LoadFromFolder(ExtractFilePath(ParamStr(0))+FSkinFolder);
    except
    end;
  end;
end;

procedure TscSkinEngine.RedrawSkin;
begin
  DrawSkin;
end;

{ TscPopupMenu ================================================================}

constructor TscPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OwnerDraw := true;
end;

destructor TscPopupMenu.Destroy;
begin
  inherited;
end;

procedure TscPopupMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinEngine) then
    FSkinEngine := nil;
end;

procedure TscPopupMenu.Popup(X, Y: integer);
begin
  if Assigned(FOnPopup) then
    FOnPopup(Self);
  if (FSkinEngine <> nil) and (FSkinEngine.SkinSource <> nil) and
     (FSkinEngine.Owner is TWinControl)
  then
  begin
    // Skin popup menu
    FMenuWnd := TscMenuWnd.Create(FSkinEngine.Owner);
    FMenuWnd.Menu := Self;
    FMenuWnd.Items := Items;
    FMenuWnd.SkinEngine := FSkinEngine;
//    FMenuWnd.SkinSource :=FSkinEngine.FSkinSource;
    FMenuWnd.ItemRect := FRect;
    FMenuWnd.Popup(X, Y);
    FRect := Rect(0, 0, 0, 0);
  end
  else // Standard popup menu
    inherited Popup(X, Y);
end;

procedure TscPopupMenu.EndPopup;
begin
  if FSkinEngine = nil then Exit;
  FSkinEngine.FAllowDraw := false;
  try
    FMenuWnd.Close;
    Application.ProcessMessages;
  finally
    FSkinEngine.FAllowDraw := true;
  end;
end;

procedure TscPopupMenu.SetSkinEngine(const Value: TscSkinEngine);
begin
  FSkinEngine := Value;
end;

{ TscSkinStore }

constructor TscSkinStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinSource := TscSkinSource.Create(nil);
end;

destructor TscSkinStore.Destroy;
begin
  FSkinSource.Free;
  inherited Destroy;
end;

procedure TscSkinStore.DefineProperties(Filer: TFiler);
begin
  inherited ;
  Filer.DefineBinaryProperty('SkinStream', ReadData, WriteData, FSkinSource.IsLoad);
end;

procedure TscSkinStore.SetSkinSource(const Value: TscSkinSource);
begin
  FSkinSource.Assign(Value);
end;

procedure TscSkinStore.ReadData(Stream: TStream);
begin
  try
    FSkinSource.Free;
    FSkinSource := TscSkinSource.Create(nil);
    FSkinSource.LoadFromStream(Stream);
  except
  end;
end;

procedure TscSkinStore.WriteData(Stream: TStream);
begin
  FSkinSource.SaveToStream(Stream);
end;

{ procedures }

function GetSkinEngine(Owner: TComponent): TscSkinEngine;
var
  i: integer;
begin
  Result := nil;
  if Owner is TCustomForm then
  with Owner as TCustomForm do
    for i := 0 to ComponentCount-1 do
      if Components[i].ClassType = TscSkinEngine then
      begin
        Result := TscSkinEngine(Components[i]);
        Exit;
      end;
end;

end.
 
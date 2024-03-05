{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }         
{                                                                   }
{*******************************************************************}

Unit DynamicSkinForm;


{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

{$IFDEF VER230}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER220}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200}
{$ENDIF}

//{$DEFINE TNTUNICODE}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SkinData, Menus, SkinMenus, SkinCtrls, spUtils, spEffBmp, SkinTabs,
  SkinBoxCtrls, spTrayIcon, SkinHint, SkinExCtrls, ImgList;

type
  TspBorderIcon = (biSystemMenu, biMinimize, biMaximize, biRollUp, biMinimizeToTray);
  TspBorderIcons = set of TspBorderIcon;
  TTrackBarChangeValueEvent = procedure(IDName: String; Value: Integer)
                              of object;
  TFrameRegulatorChangeValueEvent = procedure(IDName: String; Value: Integer)
                                    of object;
  TSwitchState = (swsOn, swsOff);
  TSwitchChangeStateEvent = procedure(IDName: String;
                                      State: TSwitchState) of object;

  TPaintEvent = procedure (IDName: String; Canvas: TCanvas;
                           ObjectRect: TRect) of object;

  TspCaptionPaintEvent = procedure (Cnvs: TCanvas; R: TRect; AActive: Boolean) of object;

  TMouseEnterEvent = procedure (IDName: String) of object;
  TMouseLeaveEvent = procedure (IDName: String) of object;

  TMainMenuItemClick = procedure (IDName: String) of object;

  TspMouseUpEvent = procedure (IDName: String;
                             X, Y: Integer; ObjectRect: TRect;
                             Button: TMouseButton) of object;
  TMouseDownEvent = procedure (IDName: String;
                               X, Y: Integer; ObjectRect: TRect;
                               Button: TMouseButton) of object;
  TMouseMoveEvent = procedure (IDName: String; X, Y: Integer;
                               ObjectRect: TRect) of object;

  TChangeClientRectEvent = procedure(NewClientRect: TRect) of object;

  TspActivateCustomObjectEvent = procedure (IDName: String; var ObjectVisible: Boolean) of object;

  TspOnAcceptToMDITabsBar = procedure (var Accept: Boolean) of object;

  TspDynamicSkinForm = class;

  TspSkinComponent = class (TComponent)
  protected
    FSkinData: TspSkinData;
    procedure SetSkinData(Value: TspSkinData); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeChangeSkinData; virtual;
    procedure ChangeSkinData; virtual;
  published
    property SkinData: TspSkinData read FSkinData write SetSkinData;
  end;

  TspActiveSkinObject = class(TObject)
  protected
    Parent: TspDynamicSkinForm;
    FMorphKf: Double;
    FMouseIn: Boolean;
    Picture, ActivePicture, ActiveMaskPicture: TBitMap;
    function InActiveMask(X, Y: Integer): Boolean; virtual;
    procedure SetMorphKf(Value: Double);
    procedure Redraw; virtual;
    procedure ShowLayer; virtual;
    procedure HideLayer; virtual;
  public
    SD: TspSkinData;
    IDName: String;
    Hint: String;
    SkinRect: TRect;
    ActiveSkinRect: TRect;
    InActiveSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    ObjectRect: TRect;
    Active: Boolean;
    Enabled: Boolean;
    CursorIndex: Integer;
    RollUp: Boolean;
    Visible: Boolean;
    SkinRectInAPicture: Boolean;
    //
    GlowLayerPictureIndex: Integer;
    GlowLayerMaskPictureIndex: Integer;
    GlowLayerOffsetX: Integer;
    GlowLayerOffsetY: Integer;
    GlowLayerAlphaBlendValue: Integer;
    //
    function MustParentUpdate: Boolean; virtual;
    function EnableMorphing: Boolean;
    constructor Create(AParent: TspDynamicSkinForm; AData: TspDataSkinObject);
    procedure DrawAlpha(Cnvs: TCanvas; ABitMap: TspBitmap); virtual;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); virtual;
    procedure DblClick; virtual;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); virtual;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); virtual;
    procedure MouseMove(X, Y: Integer); virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    function CanMorphing: Boolean; virtual;
    procedure DoMorphing;
    property MorphKf: Double read FMorphKf write SetMorphKf;
  end;

  TspUserObject = class(TspActiveSkinObject)
  public
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
  end;

  TspSkinFrameObject = class(TspActiveSkinObject)
  protected
    FFrame: Integer;
    FrameW, FrameH: Integer;
    procedure SetFrame(Value: Integer);
  public
    CountFrames: Integer;
    FramesPlacement: TFramesPlacement;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    property Frame: Integer read FFrame write SetFrame;
  end;

  TspSkinFrameGaugeObject = class(TspSkinFrameObject)
  protected
    FValue: Integer;
    function CalcFrame: Integer;
    procedure SetValue(AValue: Integer);
  public
    MinValue: Integer;
    MaxValue: Integer;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure SimplySetValue(AValue: Integer);
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    property Value: Integer read FValue write SetValue;
  end;

  TspSkinFrameRegulatorObject = class(TspSkinFrameObject)
  protected
    FPixInc, FValInc: Integer;
    FDown: Boolean;
    StartV, CurV, TempValue, OldCurV: Integer;
    FValue: Integer;
    function CalcFrame: Integer;
    procedure SetValue(AValue: Integer);
    procedure CalcValue;
    procedure CalcRoundValue;
    function GetRoundValue(X, Y: Integer): Integer;
  public
    MinValue: Integer;
    MaxValue: Integer;
    Kind: TRegulatorKind;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure SimplySetValue(AValue: Integer);
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseMove(X, Y: Integer); override;

    property Value: Integer read FValue write SetValue;
  end;

  TspSkinAnimateObject = class(TspActiveSkinObject)
  protected
    FMenuTracking: Boolean;
    FFrame: Integer;
    FInc: Integer;
    TimerInterval: Integer;
    MenuItem: TMenuItem;
    FDown: Boolean;
    FPopupUp: Boolean;
    procedure SetFrame(Value: Integer);
    procedure DoMax;
    procedure DoMin;
    procedure DoRollUp;
    procedure DoClose;
    procedure DoCommand;
    procedure DoMinToTray;
    procedure TrackMenu;
    procedure ShowLayer; override;
    procedure HideLayer; override;
  public
    CountFrames: Integer;
    Cycle: Boolean;
    ButtonStyle: Boolean;
    Increment: Boolean;
    Command: TStdCommand;
    DownSkinRect: TRect;
    RestoreRect, RestoreActiveRect, RestoreInActiveRect,
    RestoreDownRect: TRect;
    RestoreHint: String;
    FTempHint: String;
    procedure ChangeFrame;
    procedure Start;
    procedure Stop;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure DblCLick; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    property Frame: Integer read FFrame write SetFrame;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  end;

  TspSkinGaugeObject = class(TspActiveSkinObject)
  protected
    FProgressPos, FOldProgressPos: TPoint;
    procedure SetValue(AValue: Integer);
    function CalcProgressPos: TPoint;
  public
    FValue: Integer;
    MinValue, MaxValue: Integer;
    Kind: TGaugeKind;
    procedure SimplySetValue(AValue: Integer);
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    property Value: Integer read FValue write SetValue;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  end;

  TspSkinBitLabelObject = class(TspActiveSkinObject)
  public
    FTextValue: String;
    SymbolWidth: Integer;
    SymbolHeight: Integer;
    Symbols: TStrings;
    Transparent: Boolean;
    TransparentColor: TColor;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure SetTextValue(AValue: String; AUpDate: Boolean);
  end;

  TspSkinLabelObject = class(TspActiveSkinObject)
  public
    FTextValue: String;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ActiveFontColor: TColor;
    Alignment: TAlignment;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure SetTextValue(AValue: String; AUpDate: Boolean);
  end;

  TspSkinSwitchObject = class(TspActiveSkinObject)
  protected
    FState: TSwitchState;
    procedure SetState(Value: TSwitchState);
  public
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    property State: TSwitchState read FState write SetState;
    procedure SimpleSetState(Value: TSwitchState);
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  end;

  TspSkinTrackBarObject = class(TspActiveSkinObject)
  private
    FButtonPos, FOldButtonPos: TPoint;
    FValue: Integer;
    MoveActive: Boolean;
    FOldMPoint: TPoint;
    TrackKind: TTrackKind;
    procedure SetButtonPos(AValue: TPoint);
    procedure SetValue(AValue: Integer);
    function CalcValue(APos: TPoint): Integer;
    function CalcButtonPos(AValue: Integer): TPoint;
    property ButtonPos: TPoint read FButtonPos write SetButtonPos;
    function CalcButtonRect(P: TPoint): TRect;
  public
    ButtonRect: TRect;
    ActiveButtonRect: TRect;
    BeginPoint: TPoint;
    EndPoint: TPoint;
    MinValue: Integer;
    MaxValue: Integer;
    MouseDownChangeValue: Boolean;
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    property Value: Integer read FValue write SetValue;
    procedure SimplySetValue(AValue: Integer);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseMove(X, Y: Integer); override;
  end;

  TspSkinButtonObject = class(TspActiveSkinObject)
  protected
    FDown: Boolean;
    FPopupUp: Boolean;
    //
    FAlphaNormalImage,
    FAlphaActiveImage,
    FAlphaDownImage,
    FAlphaInActiveImage: TspBitMap;
    //
    procedure SetDown(Value: Boolean);
    procedure TrackMenu;
  public
    DownRect: TRect;
    DisableSkinRect: TRect;
    GroupIndex: Integer;
    MenuItem: TMenuItem;
    AlphaMaskPictureIndex: Integer;
    AlphaMaskActivePictureIndex: Integer;
    AlphaMaskInActivePictureIndex: Integer;
    
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    property Down: Boolean read FDown write SetDown;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    function CanMorphing: Boolean; override;
    procedure ShowLayer; override;
    procedure HideLayer; override;
  end;

  TspSkinMainMenuItem = class(TspActiveSkinObject)
  protected
    TempObjectRect: TRect;
    FDown: Boolean;
    OldEnabled: Boolean;
    Visible: Boolean;
    function SearchDown: Boolean;
    procedure SearchActive;
    procedure SetDown(Value: Boolean);
    procedure TrackMenu;
  public
    MenuItem: TMenuItem;
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    UnEnabledFontColor, FontColor,
    ActiveFontColor, DownFontColor: TColor;
    TextRct: TRect;
    DownRect: TRect;
    LO, RO: Integer;
    constructor Create(AParent: TspDynamicSkinForm; AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseEnter; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseLeave; override;
  end;

  TspSkinCaptionMenuButton = class(TspSkinButtonObject)
  protected
    function InActiveMask(X, Y: Integer): Boolean; override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, InActiveFontColor: TColor;
    LeftOffset, RightOffset: Integer;
    TopPosition: Integer;
    ClRect: TRect;
    FActiveMaskBuffer: TBitmap;
    constructor Create(AParent: TspDynamicSkinForm; AData: TspDataSkinObject);
    destructor Destroy; override;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure MouseEnter; override;
    function MustParentUpdate: Boolean; override;
    procedure DrawAlpha(Cnvs: TCanvas; ABitMap: TspBitmap); override;
    procedure Redraw; override;
    procedure CreateMaskBuffer; 
  end;


  TspSkinStdButtonObject = class(TspSkinButtonObject)
  protected
    //
    FAlphaRestoreNormalImage,
    FAlphaRestoreActiveImage,
    FAlphaRestoreDownImage,
    FAlphaInActiveRestoreImage: TspBitMap;
    //
    procedure DoMax;
    procedure DoMin;
    procedure DoClose;
    procedure DoRollUp;
    procedure DoCommand;
    procedure DoMinimizeToTray;
    procedure ShowLayer; override;
    procedure HideLayer; override;
    function InActiveMask(X, Y: Integer): Boolean; override;
  public
    FSkinSupport: Boolean;
    Command: TStdCommand;
    RestoreRect, RestoreActiveRect, RestoreDownRect,
    RestoreInActiveRect: TRect;
    RestoreHint, FTempHint: String;

    procedure DrawAlpha(Cnvs: TCanvas; ABitMap: TspBitmap); override;
    procedure DblClick; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure DefaultDraw(Cnvs: TCanvas);
    function CanMorphing: Boolean; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  end;

  TspSkinCaptionObject = class(TspActiveSkinObject)
  protected
    ActiveTab, OldActiveTab: Integer;
    ActiveQuickButton, OldActiveQuickButton, MouseCaptureQuickButton,
    PopupMenuQuickButton: Integer;
    FTextValue: String;
    procedure SetTextValue(Value: String);
    //
    procedure DrawTab(Cnvs: TCanvas; Index: Integer; Data: TspDataSkinCaptionTab);
    procedure DrawTabs(Cnvs: TCanvas; var X: Integer; TopY, BottomY: Integer);
    //
    procedure DrawQuickButton(Cnvs: TCanvas; Index: Integer);
    procedure DrawQuickButtons(Cnvs: TCanvas);
    procedure DrawQuickButtonAlpha(Cnvs: TCanvas; Index: Integer);
    procedure DrawQuickButtonsAlpha(Cnvs: TCanvas);
    procedure UpdateNCForm;
    procedure TestActive(X, Y: Integer);
    procedure TrackMenu(APopupRect: TRect; APopupMenu: TspSkinPopupMenu);
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ActiveFontColor: TColor;
    ShadowColor: TColor;
    ActiveShadowColor: TColor;
    Shadow: Boolean;
    Alignment: TAlignment;
    TextRct: TRect;
    DefaultCaption: Boolean;
    FrameRect, ActiveFrameRect: TRect;
    FrameLeftOffset, FrameRightOffset: Integer;
    FrameTextRect: TRect;
    LightColor: TColor;
    ActiveLightColor: TColor;
    Light: Boolean;
    StretchEffect: Boolean;
    // animation
    FIncTime: Integer;
    //
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    CurrentFrame: Integer;
    InActiveAnimation: Boolean;
    FullFrame: Boolean;
    //
    VistaGlowEffect: Boolean;
    VistaGlowInActiveEffect: Boolean;
    GlowEffect: Boolean;
    GlowInActiveEffect: Boolean;
    GlowSize: Integer;
    GlowColor: TColor;
    GlowActiveColor: TColor;
    GlowOffset: Integer;
    //
    ReflectionEffect: Boolean;
    ReflectionColor: TColor;
    ReflectionActiveColor: TColor;
    ReflectionOffset: Integer;
    //
    DividerRect: TRect;
    InActiveDividerRect: TRect;
    DividerTransparent: Boolean;
    DividerTransparentColor: TColor;
    //
    QuickButtonAlphaMaskPictureIndex: Integer;
    //
    function EnableAnimation: Boolean;
    procedure SimpleSetTextValue(Value: String);
    constructor Create(AParent: TspDynamicSkinForm;
      AData: TspDataSkinObject);
    property TextValue: String read FTextValue write SetTextValue;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseMove(X, Y: Integer); override;
    procedure Draw(Cnvs: TCanvas; UpDate: Boolean); override;
    procedure DrawAlpha(Cnvs: TCanvas; ABitMap: TspBitmap); override;
  end;

  TspSkinMainMenu = class(TMainMenu)
  protected
    DSF: TSpDynamicSkinForm;
    FSD: TspSkinData;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property SkinData: TspSkinData read FSD write FSD;
  end;

  // Menu Bar //
  TspSkinMainMenuBar = class;

  TspMenuBarObject = class(TObject)
  protected
    Parent: TspSkinMainMenuBar;
    FMorphKf: Double;
    FMouseIn: Boolean;
    Picture: TBitMap;
    FDown: Boolean;
    procedure SetMorphKf(Value: Double);
    procedure Redraw; virtual;
    function EnableMorphing: Boolean;
  public
    IDName: String;
    SkinRect: TRect;
    ActiveSkinRect: TRect;
    DownRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    ObjectRect: TRect;
    Active: Boolean;
    Enabled: Boolean;
    Visible: Boolean;
    constructor Create(AParent: TspSkinMainMenuBar; AData: TspDataSkinObject);
    procedure Draw(Cnvs: TCanvas); virtual;
    procedure DblClick; virtual;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); virtual;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    function CanMorphing: Boolean; virtual;
    procedure DoMorphing;
    property MorphKf: Double read FMorphKf write SetMorphKf;
  end;

  TspSkinMainMenuBarButton = class(TspMenuBarObject)
  protected
    FSkinSupport: Boolean;
    procedure DoCommand;
  public
    Command: TStdCommand;
    constructor Create(AParent: TspSkinMainMenuBar; AData: TspDataSkinObject);
    procedure DefaultDraw(Cnvs: TCanvas);
    procedure Draw(Cnvs: TCanvas); override;
    procedure DblClick; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseUp(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  end;


  TspSkinMainMenuBarItem = class(TspMenuBarObject)
  protected
    FSkinSupport: Boolean;
    TempObjectRect: TRect;
    OldEnabled: Boolean;
    Visible: Boolean;
    function SearchDown: Boolean;
    procedure SearchActive;
    procedure SetDown(Value: Boolean);
    procedure TrackMenu;
    procedure Redraw; override;
  public
    MenuItem: TMenuItem;
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    UnEnabledFontColor, FontColor,
    ActiveFontColor, DownFontColor: TColor;
    TextRct: TRect;
    DownRect: TRect;
    LO, RO: Integer;
    StretchEffect: Boolean;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    CurrentFrame: Integer;
    InActiveAnimation: Boolean;
    function EnableAnimation: Boolean;
    constructor Create(AParent: TspSkinMainMenuBar; AData: TspDataSkinObject);
    procedure DefaultDraw(Cnvs: TCanvas);
    procedure Draw(Cnvs: TCanvas); override;
    procedure MouseEnter; override;
    procedure MouseDown(X, Y: Integer; Button: TMouseButton); override;
    procedure MouseLeave; override;
  end;

  TspItemEnterEvent = procedure (MenuItem: TMenuItem) of object;
  TspItemLeaveEvent = procedure (MenuItem: TMenuItem) of object;

  TspSkinMainMenuBar = class(TspSkinControl)
  protected
    FToolBarMode: Boolean;
    FToolBarModeItemTransparent: Boolean;
    FUseSkinFont: Boolean;
    FUseSkinSize: Boolean;
    FOnItemMouseEnter: TspItemEnterEvent;
    FOnItemMouseLeave: TspItemLeaveEvent;
    FScrollMenu: Boolean;
    FDefItemFont: TFont;
    FSkinSupport: Boolean;
    ButtonsCount: Integer;
    FMDIChildMax: Boolean;
    FOnMainMenuItemClick: TMainMenuItemClick;
    FPopupToUp: Boolean;
    MenuActive: Boolean;
    Scroll: Boolean;
    MarkerActive: Boolean;
    DSF: TspDynamicSkinForm;
    FMainMenu: TMainMenu;
    MorphTimer: TTimer;
    MouseTimer: TTimer;
    AnimateTimer: TTimer;
    ActiveObject, OldActiveObject, MouseCaptureObject: Integer;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    NewItemsRect: TRect;
    FDefaultWidth: Integer;
    FDefaultHeight: Integer;
    FMergeMenu: TMainMenu;
    procedure TestAnimate(Sender: TObject);
    procedure SetDefaultWidth(Value: Integer);
    procedure SetDefaultHeight(Value: Integer);
    procedure SetDefItemFont(Value: TFont);
    procedure CloseSysMenu;
    procedure AddButtons;
    procedure DeleteButtons;
    procedure CheckButtons(BI: TspBorderIcons);

    procedure TrackScrollMenu;
    procedure CalcRects;
    procedure SetMainMenu(Value: TMainMenu);
    procedure TestMouse(Sender: TObject);
    procedure TestMorph(Sender: TObject);
    procedure PaintMenuBar(Cnvs: TCanvas);
    procedure PaintMenuToolBar(B: Tbitmap);
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMCloseSkinMenu(var Message: TMessage); message WM_CLOSESKINMENU; 
    procedure WMSize(var Message: TWMSIZE); message WM_SIZE;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure TestActive(X, Y: Integer);

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ClearObjects;
    procedure DrawSkinObject(AObject: TspMenuBarObject);
    procedure MenuEnter;
    procedure MenuExit;
    procedure MenuClose;
    function CheckReturnKey: Boolean;
    procedure NextMainMenuItem;
    procedure PriorMainMenuItem;
    function FindHotKeyItem(CharCode: Integer): Boolean;
    function GetMarkerRect: TRect;
    procedure DrawMarker(Cnvs: TCanvas);

    procedure MDIChildMaximize;
    procedure MDIChildRestore;
  public
    //
    SkinRect, ItemsRect: TRect;
    MenuBarItem: String;
    MaxButton, MinButton, SysMenuButton, CloseButton: String;
    TrackMarkColor, TrackMarkActiveColor: Integer;
    Picture: TBitMap;
    StretchEffect: Boolean;
    ItemTransparent: Boolean;
    //
    ObjectList: TList;
    //
    ChildMenuIn: Boolean;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetChildMainMenu: TMainMenu;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
    procedure CreateMenu;
    procedure ChangeSkinData; override;
    procedure BeforeChangeSkinData; override;
    procedure GetSkinData; override;
    procedure UpDateItems;
    procedure UpDateEnabledItems;
    procedure Merge(Menu: TMainMenu);
    procedure UnMerge;
  published
    property ToolBarMode: Boolean read FToolBarMode write FToolBarMode;
    property ToolBarModeItemTransparent: Boolean
      read FToolBarModeItemTransparent write FToolBarModeItemTransparent;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property ScrollMenu: Boolean read FScrollMenu write FScrollMenu;
    property DefItemFont: TFont read FDefItemFont write SetDefItemFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
    property PopupToUp: Boolean read FPopupToUp write FPopupToUp;
    property DynamicSkinForm: TspDynamicSkinForm read DSF write DSF;
    property MainMenu: TMainMenu read FMainMenu write SetMainMenu;
    property Anchors;
    property BiDiMode;
    property Visible;
    property Enabled;
    property OnMainMenuItemClick: TMainMenuItemClick
      read FOnMainMenuItemClick write FOnMainMenuItemClick; 
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnItemMouseEnter: TspItemEnterEvent read FOnItemMouseEnter write FOnItemMouseEnter;
    property OnItemMouseLeave: TspItemLeaveEvent read FOnItemMouseLeave write FOnItemMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
  end;

  TspSkinMDITabsBar = class;

  TspClientInActiveEffect = (spieSemiTransparent, spieBlur);

  TspClientInActivePanel = class(TspSkinPaintPanel)
  private
    Buffer: TspBitmap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure ShowPanel(AForm: TForm; AEffect: TspClientInActiveEffect);
    procedure HidePanel;
  end;


  TspFormLayerBorderType = (spflLeft, spflTop, spflRight, spflBottom);
  TspFormLayerBorderHit = (spflhNone, spflhLeft, spflhTop, spflhRight, spflhBottom,
                           spflhTopLeft, spflhTopRight, spflhBottomLeft,
                           spflhBottomRight, spflCaption, spflObject);

  TspFormLayerBorder = class;

  TspFormLayerWindow = class(TForm)
  protected
    FDown: Boolean;
    FForm: TForm;
    FLayerBorder: TspFormLayerBorder;
    MousePos1, MousePos2: TPoint;
    FHitMode: TspFormLayerBorderHit;
    FInProcessMessages: Boolean;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMLBUTTONDBLCLK(var Message: TMessage); message WM_LBUTTONDBLCLK;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function GetHitMode(HX, HY: Integer): TspFormLayerBorderHit;
    function CanChangeSize: Boolean;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
    BorderType: TspFormLayerBorderType;
    constructor CreateEx(AOwner: TComponent; AForm: TForm);
  end;

  TspFormLayerBorder = class(TComponent)
  protected
    DSF: TspDynamicSkinForm;
    FIsAeroEnabled: Boolean;
    MouseTimer: TTimer;
    FForm: TForm;
    FVisible: Boolean;
    FSD: TspSkinData;
    FData: TspDataSkinLayerFrame;
    LeftImage, TopImage, RightImage, BottomImage: TspBitMap;
    LeftBorder, TopBorder, RightBorder, BottomBorder: TspFormLayerWindow;
    FWidth, FHeight: Integer;
    //
    LeftSize, TopSize, RightSize, BottomSize: Integer;
    //
    HitTopLeftX, HitTopLeftY, HitTopRightX, HitTopRightY,
    HitBottomLeftX, HitBottomLeftY, HitBottomRightX, HitBottomRightY: Integer;
    //
    OldActiveObject, ActiveObject, MouseCaptureObject: Integer;
    //
    DataRgn1, DataRgn2, DataRgn3, DataRgn4: HRgn;
    TopRgn, BottomRgn, RightRgn, LeftRgn: HRgn;
    //
    procedure InitFrameImages(AWidth, AHeight: Integer);
    //
    procedure CreateFrameRgns;
    procedure InitRgns;
    //
    procedure InitObjects;
    procedure CalcObjectRects;
    procedure TestActive(X, Y: Integer);
    procedure CheckButtonUp;
    procedure CheckMouse(Sender: TObject);
  public
    FActive: Boolean;          
    FCurrentAlphaBlendValue: Integer;
    FCurrentInActiveAlphaBlendValue: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitFrame(ASkinData: TspSkinData; AForm: TForm);
    procedure Show(X, Y, AWidth, AHeight: Integer);
    procedure SetBounds(X, Y, AWidth, AHeight: Integer);
    procedure Update(X, Y, AWidth, AHeight: Integer);
    procedure Draw(C: TCanvas; X, Y, AWidth, AHeight: Integer);
    procedure ShowWithForm;
    procedure SetBoundsWithForm;
    procedure SetBoundsWithForm2(AW, AH: Integer);
    procedure SetBoundsWithForm3(ALeft, ATop, AW, AH: Integer);
    procedure UpdateBorder;
    procedure MoveWithForm;
    procedure MoveWithForm2(ALeft, ATop: Integer);
    procedure SetAlphaBlend;
    procedure SetAlphaBlend2;
    procedure Hide;
    procedure CheckFormAlpha(AFormAlpha: Integer; AUpdate: Boolean);
    procedure SetActive(AValue, AUpdate: Boolean);
    procedure ShowWithFormAnimation;
  end;


  TspQuickButtonItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FHint: String;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;
    FPopupMenu: TspSkinPopupMenu;
    FOnMouseDown: TMouseEvent;
  protected
    procedure SetImageIndex(const Value: Integer); virtual;
    procedure SetEnabled(Value: Boolean); virtual;
    procedure SetVisible(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    Active: Boolean;
    Down: Boolean;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
     property PopupMenu: TspSkinPopupMenu
      read FPopupMenu write FPopupMenu;
  published
    property ImageIndex: Integer read FImageIndex
      write SetImageIndex default -1;
    property Hint: String read FHint write FHint;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Visible: Boolean read FVisible write SetVisible;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
  end;

  TspQuickButtonItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TspQuickButtonItem;
    procedure SetItem(Index: Integer; Value:  TspQuickButtonItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    DSF: TspDynamicSkinForm;
    constructor Create(ADSF: TspDynamicSkinForm);
    property Items[Index: Integer]: TspQuickButtonItem read GetItem write SetItem; default;
    function Add: TspQuickButtonItem;
    function Insert(Index: Integer): TspQuickButtonItem;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspCaptionTab = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FVisible: Boolean;
    FCaption: String;
  protected
    procedure SetImageIndex(const Value: Integer); virtual;
    procedure SetCaption(Value: String); virtual;
    procedure SetVisible(Value: Boolean); virtual;
  public
    ItemRect: TRect;
    Active: Boolean;
    Down: Boolean;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Caption: String read FCaption write SetCaption;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TspCaptionTabs = class(TCollection)
  private
    function GetItem(Index: Integer):  TspCaptionTab;
    procedure SetItem(Index: Integer; Value:  TspCaptionTab);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    DSF: TspDynamicSkinForm;
    constructor Create(ADSF: TspDynamicSkinForm);
    property Items[Index: Integer]: TspCaptionTab read GetItem write SetItem; default;
    function Add: TspCaptionTab;
    function Insert(Index: Integer): TspCaptionTab;
    procedure Delete(Index: Integer);
    procedure Clear;
  end;

  TspCaptionTabPos = (sptpLeft, sptpCenter, sptpRight);

  TspPositionInMonitor = (sppDefault, sppScreenCenter, sppDesktopCenter);

  TspDynamicSkinForm = class(TComponent)
  private
    FMenuTrackObject: TspActiveSkinObject;
    FMenuButtonVisible: Boolean;
    FMenuButtonWidth: Integer;
    FMenuButtonCaption: String;
    FMenuButtonImageList: TCustomImageList;
    FMenuButtonImageIndex: Integer;
    FMenuButtonSpacing: Integer;
    FMenuButtonMargin: Integer;
    FMenuButtonPopupMenu: TspSkinPopupMenu;
    //
    FMDIHScrollBar, FMDIVScrollBar: TspSkinScrollBar;
    ChangeVisibleChildHanle: HWND;
    FStopCheckChildMove: Boolean;
    FOldHSrollBarPosition: Integer;
    FOldVSrollBarPosition: Integer;
    FShowMDIScrollBars: Boolean;
    FInMaximizeAll: Boolean;
    FInRestoreAll: Boolean;
    //
    DisableDWMAnimation: Boolean;
    //
    FTileMode: TTileMode;
    FWindowStateInit: TWindowState;
    FOldFullBorder: Integer;
    FOldFormBounds: TRect;
    {$IFDEF VER200}
    FUseRibbon: Boolean;
    {$ENDIF}
    FLayerManager: TspLayerManager;
    FMenuLayerManager: TspLayerManager;
    FBorderLayer: TspFormLayerBorder;
    //
    FCaptionTabs: TspCaptionTabs;
    FCaptionTabsImageList: TCustomImageList;
    FCaptionTabIndex: Integer;
    FCaptionTabPos: TspCaptionTabPos;
    FCaptionTabsVisible: Boolean;
    FOnCaptionTabChange: TNotifyEvent;
    //
    FQuickButtons: TspQuickButtonItems;
    FQuickImageList: TCustomImageList;
    FQuickButtonsShowHint: Boolean;
    //
    FInActivePanel: TspClientInActivePanel;
    FClientInActiveDraw: Boolean;
    FClientInActiveEffect: Boolean;
    FClientInActiveEffectType: TspClientInActiveEffect;
    FSmartEffectsShow: Boolean;
    //
    FDisableSystemMenu: Boolean;
    FInAppHook: Boolean;
    FSkinnableForm: Boolean;
    FIsW7: Boolean;
    FIsVistaOS: Boolean;
    FIsLayerEnabled: Boolean;
    FHaveShadow: Boolean;
    FOnCaptionPaint: TspCaptionPaintEvent;
    FRollUpBeforeMaximize: Boolean;
    FOnShortCut: TShortCutEvent;
    FStopPainting: Boolean;
    FStartShow: Boolean;
    FPositionInMonitor:  TspPositionInMonitor;
    HMagnetized: Boolean;
    VMagnetized: Boolean;
    HMagnetized2: Boolean;
    VMagnetized2: Boolean;
    FOnMouseDownCoord: TPoint;
    FMinimizeDefault: Boolean;
    FStatusBar: TspSkinStatusBar;
    FUseFormCursorInNCArea: Boolean;
    FMaxMenuItemsInWindow: Integer;
    FClientWidth, FClientHeight: Integer;
    FHideCaptionButtons: Boolean;
    FAlwaysShowInTray: Boolean;
    FLogoBitMapTransparent: Boolean;
    FLogoBitMap: TBitMap;
    FAlwaysMinimizeToTray: Boolean;
    FIcon: TIcon;
    FShowIcon: Boolean;
    ButtonsInLeft: boolean;
    FMaximizeOnFullScreen: Boolean;
    FSkinHint: TspSkinHint;
    FShowObjectHint: Boolean;
    FUseDefaultObjectHint: Boolean;
    FUseSkinCursors: Boolean;
    FSkinSupport: Boolean;
    FDefCaptionFont: TFont;
    FDefInActiveCaptionFont: TFont;
    FMDIChildMaximized: Boolean;
    FFormActive: Boolean;
    FOnMinimizeToTray: TNotifyEvent;
    FOnRestoreFromTray: TNotifyEvent;
    FTrayIcon: TspTrayIcon;
    FUseDefaultSysMenu: Boolean;
    FUseSkinFontInCaption: Boolean;
    FSysMenu: TPopupMenu;
    FSysTrayMenu: TspSkinPopupMenu;
    FInShortCut: Boolean;
    FMainMenuBar: TspSkinMainMenuBar;
    FMDITabsBar: TspSkinMDITabsBar;
    FFullDrag: Boolean;
    FFormWidth, FFormHeight,
    FFormLeft, FFormTop, FOldFormLeft, FOldFormTop: Integer;
    FSizeMove, FSizing: Boolean;
    FSupportNCArea: Boolean;
    FRollUpState, MaxRollUpState: Boolean;
    FBorderIcons: TspBorderIcons;
    RMTop, RMBottom, RMLeft, RMRight: TBitMap;
    BlackColor: TColor;
    MouseIn: Boolean;
    OldBoundsRect: TRect;
    OldHeight: Integer;
    NewLTPoint, NewRBPoint, NewRTPoint, NewLBPoint: TPoint;
    NewClRect: TRect;
    NewCaptionRect, NewButtonsRect: TRect;
    NewButtonsOffset: Integer;
    NewButtonsInLeft: Boolean;
    NewMaskRectArea: TRect;
    NewHitTestLTPoint,
    NewHitTestRTPoint,
    NewHitTestLBPoint,
    NewHitTestRBPoint: TPoint;
    NewDefCaptionRect: TRect;

    FSizeable: Boolean;
    FMinHeight, FMinWidth: Integer;
    FMaxHeight, FMaxWidth: Integer;

    OldWindowProc: TWndMethod;
    FClientInstance: Pointer;
    FPrevClientProc: Pointer;

    FSD: TspSkinData;
    FMSD: TspSkinData;
    FMainMenu: TMainMenu;
    FSystemMenu: TPopupMenu;

    FDraggAble: Boolean;
    FNCDraggAble: Boolean;
    FIsDragging: Boolean;

    FOldX, FOldY: Integer;
    FOnChangeSkinData: TNotifyEvent;
    FOnActivate: TNotifyEvent;
    FOnDeActivate: TNotifyEvent;
    FOnChangeRollUpState: TNotifyEvent;

    FInChangeSkinData: Boolean;

    FWindowState: TWindowState;
    FMagneticSize: Byte;

    FMenusAlphaBlend: Boolean;
    FMenusAlphaBlendValue: Byte;
    FMenusAlphaBlendAnimation: Boolean;

    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;

    VisibleControls: TList;
    OldAppMessage: TMessageEvent;
    OldActive: Boolean;
    FOnActivateCustomObject: TspActivateCustomObjectEvent;
    FOnMinimize, FOnRestore, FOnMaximize: TNotifyEvent;
    //
    procedure SetMenuButtonVisible(Value: Boolean);
    procedure SetMenuButtonWidth(Value: Integer);
    procedure SetMenuButtonCaption(Value: String);
    procedure SetMenuButtonImageList(Value: TCustomImageList);
    procedure SetMenuButtonImageIndex(Value: Integer);
    //
    procedure InitMDIScrollBars;
    procedure AdjustMDIScrollBars;
    procedure GetMDIScrollInfo(ASetRange: Boolean);
    procedure OnVScrollBarLastChange(Sender: TObject);
    procedure OnVScrollBarUpButtonClick(Sender: TObject);
    procedure OnVScrollBarDownButtonClick(Sender: TObject);
    procedure OnHScrollBarLastChange(Sender: TObject);
    procedure OnHScrollBarUpButtonClick(Sender: TObject);
    procedure OnHScrollBarDownButtonClick(Sender: TObject);
    procedure MDIHScroll(AOffset: Integer);
    procedure MDIVScroll(AOffset: Integer);
    //
    function CanShowBorderLayer: Boolean;
    function CheckVista: Boolean;
    procedure CheckStayOnTopWindows;

    procedure CancelMessageToControls;
    procedure SetMaxMenuItemsInWindow(Value: Integer);
    procedure CheckMDIMainMenu;
    procedure CheckMDIBar;

    procedure SetLogoBitMap(Value: TBitMap);

    function GetUseSkinFontInMenu: Boolean;
    procedure SetUseSkinFontInMenu(Value: Boolean);

    function GetUseSkinSizeInMenu: Boolean;
    procedure SetUseSkinSizeInMenu(Value: Boolean);

    procedure SetShowIcon(Value: Boolean);
    procedure GetIconSize(var X, Y: Integer);
    procedure GetIcon;
    procedure DrawFormIcon(Cnvs: TCanvas; X, Y: Integer);

    procedure SetMenusAlphaBlend(Value: Boolean);
    procedure SetMenusAlphaBlendAnimation(Value: Boolean);
    procedure SetMenusAlphaBlendValue(Value: Byte);

    function GetDefCaptionRect: TRect;
    function GetDefCaptionHeight: Integer;
    function GetDefButtonSize: Integer;


    procedure SetDefaultMenuItemHeight(Value: Integer);
    function GetDefaultMenuItemHeight: Integer;
    procedure SetDefaultMenuItemFont(Value: TFont);
    function GetDefaultMenuItemFont: TFont;

    procedure SetDefCaptionFont(Value: TFont);
    procedure SetDefInActiveCaptionFont(Value: TFont);

    procedure SetBorderIcons(Value: TspBorderIcons);
    procedure NewAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure HookApp;
    procedure UnHookApp;

    function GetMaximizeMDIChild: TForm;
    function IsMDIChildMaximized: Boolean;
    procedure ResizeMDIChilds;
    function GetMDIWorkArea: TRect;
    procedure UpDateForm;
    procedure FormClientWindowProcHook(var Message: TMessage);

    procedure TSM_Restore(Sender: TObject);
    procedure TSM_Close(Sender: TObject);

    procedure SM_Restore(Sender: TObject);
    procedure SM_Max(Sender: TObject);
    procedure SM_Min(Sender: TObject);
    procedure SM_RollUp(Sender: TObject);
    procedure SM_Close(Sender: TObject);
    procedure SM_MinToTray(Sender: TObject);

    procedure TrayIconDBLCLK(Sender: TObject);
    procedure TrackSystemMenu(X, Y: Integer);
    procedure TrackSystemMenu2(R: TRect);

    procedure UpDateActiveObjects;
    procedure CreateSysMenu;
    procedure CreateUserSysMenu;
    procedure CreateSysTrayMenu;
    function GetSystemMenu: TMenuItem;
    procedure CalcRects;
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure ChangeSkinData;
    procedure SetRollUpFormRegion;
    procedure CreateRollUpForm;
    procedure CreateRollUpForm2;
    procedure RestoreRollUpForm;
    procedure RestoreRollUpForm2;
    procedure SetRollUpState(Value: Boolean);
    procedure SetTrayIcon(Value: TspTrayIcon);

    function IsNullHeight: Boolean;

    procedure BeforeUpDateSkinControls(AFSD: Integer; WC: TWinControl);
    procedure UpDateSkinControls(AFSD: Integer; WC: TWinControl);

    procedure BeforeUpDateSkinComponents(AFSD: Integer);
    procedure UpDateSkinComponents(AFSD: Integer);

    procedure CheckObjects;
    procedure CheckObjectsHint;
    procedure SetWindowState(Value: TWindowState);
    procedure SetWindowStateTemp(Value: TWindowState);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetMenusSkinData(Value: TspSkinData);
    procedure CheckSize;
    procedure NewWndProc(var Message: TMessage);
    function NewHitTest(P: TPoint): Integer;
    function NewNCHitTest(P: TPoint): Integer;
    function NewDefNCHitTest(P: TPoint): Integer;
    procedure CreateNewRegion(FCanScale: Boolean);

    procedure CreateNewForm(FCanScale: Boolean);
    procedure FormChangeActive(AUpDate: Boolean);

    procedure DoMaximize;

    procedure CorrectFormBounds;

    procedure DoNormalize;
    procedure DoMinimize;

    function InForm(P: TPoint): Boolean;
    function PtInMask(P: TPoint): Boolean;
    function CanScale: Boolean;
    procedure CreateMainMenu;
    procedure CheckWindowState;
    function GetRealHeight: Integer;
    procedure CheckControlsBackground;
    {$IFDEF VER200}
    procedure SetUseRibbon(Value: Boolean);
    {$ENDIF}
    procedure SetQuickButtons(Value: TspQuickButtonItems);
    procedure SetCaptionTabs(Value: TspCaptionTabs);
    procedure SetCaptionTabIndex(Value: Integer);
    procedure SetCaptionTabPos(Value: TspCaptionTabPos);
  protected
    InMenu: Boolean;
    InMainMenu: Boolean;

    FRgn: HRGN;
    NewMainMenuRect: TRect;
    NewIconRect: TRect;
    MorphTimer: TTimer;
    AnimateTimer: TTimer;
    MouseTimer: TTimer;
    FMagnetic: Boolean;
    FSizeGripArea: TRect;

    FOnSkinMenuOpen: TNotifyEvent;
    FOnSkinMenuClose: TNotifyEvent;
    FOnChangeClientRect: TChangeClientRectEvent;
    FOnMainMenuEnter: TNotifyEvent;
    FOnMainMenuExit: TNotifyEvent;

    FOnMouseEnterEvent: TMouseEnterEvent;
    FOnMouseLeaveEvent: TMouseLeaveEvent;
    FOnMouseUpEvent : TspMouseUpEvent;
    FOnMouseDownEvent : TMouseDownEvent;
    FOnMouseMoveEvent: TMouseMoveEvent;
    FOnPaintEvent: TPaintEvent;
    FOnSwitchChangeStateEvent: TSwitchChangeStateEvent;
    FOnTrackBarChangeValueEvent: TTrackBarChangeValueEvent;
    FOnFrameRegulatorChangeValueEvent: TFrameRegulatorChangeValueEvent;
    FOnAcceptToMDITabsBar: TspOnAcceptToMDITabsBar;

    ActiveObject, OldActiveObject, MouseCaptureObject: Integer;
    OldWindowState: TWindowState;

    IsAlphaIcon: Boolean; 

    procedure LoadBorderIcons;
    procedure PopupSystemMenu;
    procedure DrawLogoBitMap(C: TCanvas);
    procedure CorrectCaptionText(C: TCanvas; var S: WideString; W: Integer);
    procedure CheckMenuVisible(var Msg: Cardinal);
    procedure FormKeyDown(Message: TMessage);
    function CanNCSupport: Boolean;
    function GetFullDragg: Boolean;
    function GetMinimizeCoord: TPoint;
    function CanObjectTest(ARollUp: Boolean): Boolean;
    procedure PointToNCPoint(var P: TPoint);
    function ActivateMenu: boolean;
    function CheckReturnKey: Boolean;
    procedure NextMainMenuItem;
    procedure PriorMainMenuItem;
    function CanNextMainMenuItem: Boolean;
    function CanPriorMainMenuItem: Boolean;
    function FindHotKeyItem(CharCode: Integer): Boolean;

    procedure SetMainMenu(Value: TMainMenu);

    procedure StartDragg(X, Y: Integer);
    procedure EndDragg;

    procedure DoMagnetic(var L, T: Integer; W, H: Integer);
    
    procedure TestCursors;
    procedure TestMouse(Sender: TObject);
    procedure TestMorph(Sender: TObject);
    procedure TestAnimate(Sender: TObject);

    procedure TestActive(X, Y: Integer; InFrm: Boolean);


    procedure MouseDBlClick;
    procedure MouseDown(Button: TMouseButton;  X, Y: Integer);
    procedure MouseMove(X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; X, Y: Integer);

    procedure CreateRealBitMap(DestB, SourceB: TBitMap);
    function CalcRealObjectRect(R: TRect): TRect;
    function CalcRealObjectRect2(R: TRect; AUseAnchors, AAnchorLeft, AAnchorTop,
    AAnchorRight, AAnchorBottom: Boolean): TRect;
    procedure CalcAllRealObjectRect;
    procedure ControlsToAreas;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure LoadObjects;
    procedure LoadDefObjects;

    procedure OnAppRestore(Sender: TObject);

    procedure SwitchChangeStateEvent(IDName: String; State: TSwitchState);
    procedure TrackBarChangeValueEvent(IDName: String; Value: Integer);
    procedure FrameRegulatorChangeValueEvent(IDName: String; Value: Integer);
    procedure MouseEnterEvent(IDName: String);
    procedure MouseLeaveEvent(IDName: String);
    procedure MouseUpEvent(IDName: String;
                           X, Y: Integer; ObjectRect: TRect;
                           Button: TMouseButton);

    procedure MouseDownEvent(IDName: String;
                             X, Y: Integer; ObjectRect: TRect;
                             Button: TMouseButton);

    procedure MouseMoveEvent(IDName: String; X, Y: Integer;
                             ObjectRect: TRect);

    procedure PaintEvent(IDName: String; Canvas: TCanvas; ObjectRect: TRect);

    procedure LinkControlsToAreas;
    procedure SetDefaultCaptionText(AValue: String);

    procedure SkinMainMenuClose;
    procedure SkinMenuClose2;

    procedure ArangeMinimizedChilds;

    function GetAutoRenderingInActiveImage: Boolean;

    procedure SetAlphaBlendValue(Value: Byte);
    procedure SetAlphaBlend(Value: Boolean);
    function CheckIconAlpha: Boolean;
    procedure Loaded; override;
    property WindowState_Temp: TWindowState read FWindowState write SetWindowStateTemp;
    procedure TileH;
    procedure TileV;
    function GetCaptionMenuButton: TspSkinCaptionMenuButton;
  public
    SkinMenu: TspSkinMenu;
    FForm: TForm;
    ObjectList, AreaList: TList;
    PreviewMode: Boolean;
    FBorderLayerChangeSize: Boolean;
    AlwaysDisableLayeredFrames: Boolean;

    procedure MenuButtonTrackMenu;

    procedure CheckAppLayeredBorders;

    procedure UpDateFormNC;

    function IsSizeAble: Boolean;

    procedure ShowClientInActiveEffect;
    procedure HideClientInActiveEffect;

    procedure SetSkinnableForm(Value: Boolean);
    function GetSkinnableForm: Boolean;

    procedure EnableShadow(AShowShadow: Boolean; AHideFormBefore: Boolean);

    procedure ApplyPositionInMonitor;
    function GetPositionInMonitor(AX, AY, AW, AH: Integer): TPoint;

    function GetAreaRect(AIDName: String): TRect;
    function GetProductVersion: String;
    procedure DoPopupMenu(Menu: TPopupMenu; X, Y: Integer);
    procedure AddChildToMenu(Child: TCustomForm);
    procedure AddChildToBar(Child: TCustomForm);
    procedure DeleteChildFromMenu(Child: TCustomForm);
    procedure DeleteChildFromBar(Child: TCustomForm);
    procedure RefreshMDIBarTab(Child: TCustomForm);
    procedure MDIItemClick(Sender: TObject);
    procedure UpDateChildCaptionInMenu(Child: TCustomForm);
    procedure UpDateChildActiveInMenu;

    function GetMinWidth: Integer;
    function GetMinHeight: Integer;
    function GetMaxWidth: Integer;
    function GetMaxHeight: Integer;

    procedure MinimizeAll;
    procedure MaximizeAll;
    procedure RestoreAll;
    procedure RestoreAllExcept(AFormHandle: HWnd);
    procedure Tile;

    procedure Cascade;
    procedure CloseAll;

    function GetFormActive: Boolean;
    procedure MinimizeToTray;
    procedure RestoreFromTray;
    procedure SkinMenuOpen;
    procedure SkinMenuClose;

    procedure DrawSkinObject(AObject: TspActiveSkinObject);

    procedure SetFormStyle(FS: TFormStyle);
    procedure SetFormBorderStyle(BS: TFormBorderStyle);
    procedure LinkControlToArea(AreaName: String; Control: TControl);
    procedure UnLinkControlFromArea(Control: TControl);
    procedure UpdateMainMenu(ARedraw: Boolean);
    procedure PopupSkinMenu(Menu: TMenu; P: TPoint);
    procedure PopupSkinMenu1(Menu: TMenu; R: TRect; PopupUp: Boolean);
    procedure ClearObjects;
    function GetIndex(AIDName: String): Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Paint(DC: HDC);
    procedure PaintNCSkin(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintBG(DC: HDC);
    procedure PaintBG2(DC: HDC);
    procedure PaintBG3(DC: HDC);
    //
    procedure PaintNCDefault(ADC: HDC; AUseExternalDC: Boolean);
    procedure PaintBGDefault(DC: HDC);
    procedure PaintMDIBGDefault(DC: HDC);
    procedure CalcDefRects;
    //
    procedure SetSupportNCArea(Value: Boolean);

    procedure SetEnabled(AIDName: String; Value: Boolean);
    procedure CaptionSetText(AIDName, AText: String);
    procedure AnimateStart(AIDName: String);
    procedure AnimateStop(AIDName: String);
    procedure BitLabelSetText(AIDName: String; AValue: String);
    procedure GaugeSetValue(AIDName: String; AValue: Integer);
    procedure FrameGaugeSetValue(AIDName: String; AValue: Integer);
    procedure ButtonSetDown(AIDName: String; ADown: Boolean);
    function ButtonGetDown(AIDName: String): Boolean;
    procedure SwitchSetState(AIDName: String; AState: TSwitchState);
    function SwitchGetState(AIDName: String): TSwitchState;
    function TrackBarGetValue(AIDName: String): Integer;
    procedure TrackBarSetValue(AIDName: String; AValue: Integer);
    function FrameRegulatorGetValue(AIDName: String): Integer;
    procedure FrameRegulatorSetValue(AIDName: String; AValue: Integer);
    procedure LabelSetText(AIDName, ATextValue: String);
    procedure UserObjectDraw(AIDName: String);
    procedure LinkMenu(AIDName: String; AMenu: TMenu; APopupUp: Boolean);
    //
    procedure Move(AX, AY: Integer);
    procedure SetBounds(AX, AY, AWidth, AHeight: Integer);
    //
    property RollUpState: Boolean read FRollUpState write SetRollUpState;
    property RealHeight: Integer read GetRealHeight write OldHeight;
    property MinimizeDefault: Boolean read FMinimizeDefault write FMinimizeDefault;
    property SkinnableForm: Boolean read GetSkinnableForm;
    property TileMode: TTileMode read FTileMode write FTileMode;
  published
    {$IFDEF VER200}
    property UseRibbon: Boolean read FUseRibbon write SetUseRibbon;
    {$ENDIF}
    //
    property MenuButtonVisible: Boolean
      read FMenuButtonVisible write SetMenuButtonVisible;
    property MenuButtonWidth: Integer
      read FMenuButtonWidth write SetMenuButtonWidth;
    property MenuButtonCaption: String
      read FMenuButtonCaption write SetMenuButtonCaption;
    property MenuButtonImageList: TCustomImageList
      read FMenuButtonImageList write SetMenuButtonImageList;
    property MenuButtonImageIndex: Integer
      read FMenuButtonImageIndex write SetMenuButtonImageIndex;
    property MenuButtonSpacing: Integer
      read FMenuButtonSpacing write FMenuButtonSpacing;
    property MenuButtonMargin: Integer
      read FMenuButtonMargin write FMenuButtonMargin;
    property MenuButtonPopupMenu: TspSkinPopupMenu
      read FMenuButtonPopupMenu write FMenuButtonPopupMenu;  
    //
    property WindowState: TWindowState read FWindowStateInit
     write SetWindowState;
     property ShowMDIScrollBars: Boolean
      read FShowMDIScrollBars write FShowMDIScrollBars;
    property QuickButtons: TspQuickButtonItems read FQuickButtons write SetQuickButtons;
    property QuickImageList: TCustomImageList read
      FQuickImageList write FQuickImageList;
    //
    property CaptionTabs: TspCaptionTabs read FCaptionTabs write SetCaptionTabs;
    property CaptionTabsImageList: TCustomImageList read
      FCaptionTabsImageList write FCaptionTabsImageList;
    property CaptionTabIndex: Integer
      read FCaptionTabIndex write SetCaptionTabIndex;
    property CaptionTabPos: TspCaptionTabPos
      read FCaptionTabPos write SetCaptionTabPos;
    //
    property QuickButtonsShowHint: Boolean
      read FQuickButtonsShowHint write FQuickButtonsShowHint;

    property ClientInActiveEffect: Boolean
      read FClientInActiveEffect write FClientInActiveEffect;
    property ClientInActiveEffectType: TspClientInActiveEffect
      read FClientInActiveEffectType write FClientInActiveEffectType;
    property DisableSystemMenu: Boolean
      read FDisableSystemMenu write FDisableSystemMenu;
    property PositionInMonitor:  TspPositionInMonitor read
      FPositionInMonitor write FPositionInMonitor;
    property StatusBar: TspSkinStatusBar read FStatusBar write FStatusBar;
    property UseFormCursorInNCArea: Boolean read
      FUseFormCursorInNCArea write FUseFormCursorInNCArea;
    property MaxMenuItemsInWindow: Integer read
      FMaxMenuItemsInWindow write SetMaxMenuItemsInWindow;
    property ClientWidth: Integer read FClientWidth write FClientWidth;
    property ClientHeight: Integer read FClientHeight write FClientHeight;
    property HideCaptionButtons: Boolean read
      FHideCaptionButtons write FHideCaptionButtons;
    property AlwaysShowInTray: Boolean read FAlwaysShowInTray write FAlwaysShowInTray;
    property LogoBitMap: TBitMap read FLogoBitMap write SetLogoBitMap;
    property LogoBitMapTransparent: Boolean
      read FLogoBitMapTransparent
      write FLogoBitMapTransparent;
    property AlwaysMinimizeToTray: Boolean
      read FAlwaysMinimizeToTray write FAlwaysMinimizeToTray;
    property UseSkinFontInMenu: boolean
      read GetUseSkinFontInMenu write SetUseSkinFontInMenu;
     property UseSkinFontInCaption: Boolean
      read FUseSkinFontInCaption write FUseSkinFontInCaption;
    property UseSkinSizeInMenu: boolean
      read GetUseSkinSizeInMenu write SetUseSkinSizeInMenu;
    property ShowIcon: Boolean read FShowIcon write SetShowIcon;
    property MaximizeOnFullScreen: Boolean
      read FMaximizeOnFullScreen write FMaximizeOnFullScreen;
    property SkinHint: TspSkinHint read FSkinHint write FSkinHint;
    property ShowObjectHint: Boolean read FShowObjectHint write FShowObjectHint;
    property UseDefaultObjectHint: Boolean read FUseDefaultObjectHint write FUseDefaultObjectHint;
    property UseSkinCursors: Boolean read FUseSkinCursors write FUseSkinCursors;
    property DefCaptionFont: TFont read FDefCaptionFont write SetDefCaptionFont;
    property DefInActiveCaptionFont: TFont read FDefInActiveCaptionFont write SetDefInActiveCaptionFont;
    property DefMenuItemHeight: Integer
      read GetDefaultMenuItemHeight write SetDefaultMenuItemHeight;
    property DefMenuItemFont: TFont
      read GetDefaultMenuItemFont write SetDefaultMenuItemFont;
    property TrayIcon: TspTrayIcon read FTrayIcon write SetTrayIcon;
    property UseDefaultSysMenu: Boolean
      read FUseDefaultSysMenu write FUseDefaultSysMenu;
    property MainMenuBar: TspSkinMainMenuBar read FMainMenuBar write FMainMenuBar;
    property MDITabsBar: TspSkinMDITabsBar read FMDITabsBar write FMDITabsBar;
    property SupportNCArea: Boolean read FSupportNCArea
                                    write SetSupportNCArea;

    property AlphaBlendAnimation: Boolean read
      FAlphaBlendAnimation write FAlphaBlendAnimation;                                  
    property AlphaBlendValue: Byte read FAlphaBlendValue
                                   write SetAlphaBlendValue;
    property AlphaBlend: Boolean read FAlphaBlend
                                       write SetAlphaBlend;

    property MenusAlphaBlend: Boolean
      read FMenusAlphaBlend write SetMenusAlphaBlend;

    property MenusAlphaBlendAnimation: Boolean
      read FMenusAlphaBlendAnimation write SetMenusAlphaBlendAnimation;

    property MenusAlphaBlendValue: Byte
      read FMenusAlphaBlendValue write SetMenusAlphaBlendValue;
      
    property MainMenu: TMainMenu read FMainMenu write SetMainMenu;
    property SystemMenu: TPopupMenu read FSystemMenu write FSystemMenu;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property MenusSkinData: TspSkinData read FMSD write SetMenusSkinData;
    property MinHeight: Integer read FMinHeight write  FMinHeight;
    property MinWidth: Integer read FMinWidth write  FMinWidth;
    property MaxHeight: Integer read FMaxHeight write  FMaxHeight;
    property MaxWidth: Integer read FMaxWidth write  FMaxWidth;
    property Sizeable: Boolean read FSizeable write FSizeable;
    property DraggAble: Boolean read FDraggAble write FDraggAble;
    property NCDraggAble: Boolean read FNCDraggAble write FNCDraggAble;
    property Magnetic: Boolean read  FMagnetic write FMagnetic;
    property MagneticSize: Byte read  FMagneticSize write FMagneticSize;
    property BorderIcons: TspBorderIcons read FBorderIcons write SetBorderIcons;

    property OnCaptionPaint: TspCaptionPaintEvent
      read FOnCaptionPaint write FOnCaptionPaint;

    property OnChangeClientRect: TChangeClientRectEvent
      read FOnChangeClientRect write FOnChangeClientRect;

    property OnChangeSkinData: TNotifyEvent read FOnChangeSkinData
                                            write FOnChangeSkinData;

    property OnMouseUpEvent: TspMouseUpEvent read FOnMouseUpEvent
                                           write FOnMouseUpEvent;
    property OnMouseDownEvent: TMouseDownEvent read FOnMouseDownEvent
                                               write FOnMouseDownEvent;
    property OnMouseMoveEvent: TMouseMoveEvent read FOnMouseMoveEvent
                                               write FOnMouseMoveEvent;
    property OnMouseEnterEvent: TMouseEnterEvent read FOnMouseEnterEvent
                                                 write FOnMouseEnterEvent;
    property OnMouseLeaveEvent: TMouseLeaveEvent read FOnMouseLeaveEvent
                                                 write FOnMouseLeaveEvent;
    property OnPaintEvent: TPaintEvent read FOnPaintEvent
                                       write FOnPaintEvent;
    property OnSwitchChangeStateEvent: TSwitchChangeStateEvent
                                       read FOnSwitchChangeStateEvent
                                       write FOnSwitchChangeStateEvent;
    property OnTrackBarChangeValueEvent: TTrackBarChangeValueEvent
                                       read FOnTrackBarChangeValueEvent
                                       write FOnTrackBarChangeValueEvent;
    property OnFrameRegulatorChangeValueEvent: TFrameRegulatorChangeValueEvent
                                       read FOnFrameRegulatorChangeValueEvent
                                       write FOnFrameRegulatorChangeValueEvent;
    property OnActivate: TNotifyEvent read FOnActivate write  FOnActivate;
    property OnDeActivate: TNotifyEvent read FOnDeActivate write  FOnDeActivate;
    property OnSkinMenuOpen: TNotifyEvent read FOnSkinMenuOpen
                                          write FOnSkinMenuOpen;
    property OnSkinMenuClose: TNotifyEvent read FOnSkinMenuClose
                                          write FOnSkinMenuClose;
    property OnChangeRollUpState: TNotifyEvent read FOnChangeRollUpState
                                               write FOnChangeRollUpState;
    property OnMainMenuEnter: TNotifyEvent read FOnMainMenuEnter
                                           write FOnMainMenuEnter;
    property OnMainMenuExit: TNotifyEvent read FOnMainMenuExit
                                           write FOnMainMenuExit;
    property OnMinimizeToTray: TNotifyEvent
      read FOnMinimizeToTray write FOnMinimizeToTray;
    property OnRestoreFromTray: TNotifyEvent
      read FOnRestoreFromTray write FOnRestoreFromTray;

    property OnActivateCustomObject: TspActivateCustomObjectEvent
      read FOnActivateCustomObject write FOnActivateCustomObject;

    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property OnMaximize: TNotifyEvent read FOnMaximize write FOnMaximize;

    property OnShortCut: TShortCutEvent read FOnShortCut write FOnShortCut;

    property OnAcceptToMDITabsBar: TspOnAcceptToMDITabsBar
      read FOnAcceptToMDITabsBar write FOnAcceptToMDITabsBar;

    property OnCaptionTabChange: TNotifyEvent
      read FOnCaptionTabChange write FOnCaptionTabChange;
  end;

  TspMDITab = class(TObject)
  protected
    TabsBar: TspSkinMDITabsBar;
  public
    Active, MouseIn: Boolean;
    ObjectRect: TRect;
    Child: TCustomForm;
    Visible: Boolean;
    ButtonRect: TRect;
    ButtonMouseIn, ButtonMouseDown:Boolean;
    procedure DrawCloseButton(Cnvs: TCanvas; R: TRect);
    constructor Create(AParentBar: TspSkinMDITabsBar; AChild: TCustomForm);
    procedure Draw(Cnvs: TCanvas);
    procedure ResizeDraw(Cnvs: TCanvas);
    procedure ButtonDraw(Cnvs: TCanvas);
  end;
  
  TspMDITabMouseEnterEvent = procedure (MDITab: TspMDITab) of object;
  TspMDITabMouseLeaveEvent = procedure (MDITab: TspMDITab) of object;
  TspMDITabMouseDownEvent = procedure (Button: TMouseButton; Shift: TShiftState; MDITab: TspMDITab) of object;
  TspMDITabMouseUpEvent = procedure (Button: TMouseButton; Shift: TShiftState; MDITab: TspMDITab) of object;
  TspMDITabGetDrawParamsEvent = procedure (MDITab: TspMDITab; Cnvs: TCanvas) of object;

  TspSkinMDITabKind = (sptkTab, sptkButton);

  TspSkinMDITabsBar = class(TspSkinControl)
  private
    FShowAddButton, FAddButtonActive, FAddButtonDown: Boolean;
    FDblClickChildMove: Boolean;
    FBottomOffset: Integer;
    FShowCloseButtons: Boolean;
    FMinTabWidth: Integer;
    FTabKind: TspSkinMDITabKind;
    FSupportChildMenus: Boolean;
    IsDrag: Boolean;
    DX, TabDX: Integer;
    FDown: Boolean;
    DragIndex: Integer;
    FOnAddButtonClick: TNotifyEvent;
    FOnTabMouseEnter: TspMDITabMouseEnterEvent;
    FOnTabMouseLeave: TspMDITabMouseLeaveEvent;
    FOnTabMouseUp: TspMDITabMouseUpEvent;
    FOnTabMouseDown: TspMDITabMouseDownEvent;
    FDefaultTabWidth: Integer;
    FDefaultHeight: Integer;
    FDefaultFont: TFont;
    ActiveTabIndex, OldTabIndex: Integer;
    FMoveTabs: Boolean;
    FUseSkinSize: Boolean;
    FUseSkinFont: Boolean;
    DSF: TspDynamicSkinForm;
    FListButton: TspSkinMenuSpeedButton;
    FHideListButton: TspSkinMenuSpeedButton;
    FListMenu: TspSkinPopupMenu;
    FHideListMenu: TspSkinPopupMenu;
    FInVisibleCount: Integer;
    FOnTabGetDrawParamsEvent: TspMDITabGetDrawParamsEvent;
    FAddButtonRect: TRect;

    procedure DrawAddButton(Cnvs: TCanvas);
        
    procedure ShowListButton;
    procedure HideListButton;
    procedure UpdateListMenu;
    procedure OnShowListMenu(Sender: TObject);

    procedure ShowHideListButton;
    procedure HideHideListButton;
    procedure UpdateHideListMenu;
    procedure OnShowHideListMenu(Sender: TObject);

    procedure SetDefaultHeight(Value: Integer);
    procedure SetDefaultFont(Value: TFont);
    procedure CalcObjectRects;
    procedure TestActive(X, Y: Integer);
    procedure CheckActive;
    procedure SetTabKind(Value: TspSkinMDITabKind);
    procedure MDIItemClick(Sender: TObject);
    procedure HideMDIItemClick(Sender: TObject);
    procedure SetShowAddButton(Value: Boolean); 
  protected
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure ClearObjects;
    procedure GetSkinData; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function GetMoveIndex: Integer;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMCHECKPARENTBG(var Msg: TWMEraseBkgnd); message WM_CHECKPARENTBG;
    procedure WMMOVE(var Msg: TWMMOVE); message WM_MOVE;
    procedure DoClose(Tab: TspMDITab);
    procedure AdjustClientRect(var Rect: TRect); override;
  public
    FCloseSize: Integer;
    ObjectList: TList;
    Picture: TBitMap;
    TabRect, ActiveTabRect, MouseInTabRect: TRect;
    TabsBGRect: TRect;
    TabLeftOffset, TabRightOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, MouseInFontColor: TColor;
    UpDown: String;
    TabStretchEffect: Boolean;
    CloseButtonRect, ClosebuttonActiveRect, CloseButtonDownRect: TRect;
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    //
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    SkinRect: TRect;
    ClRect: TRect;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchEffect: Boolean;
    StretchType: TspStretchType;
    FActiveTabOffset: Integer;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTab(X, Y: Integer): TspMDITab;
    function GetTabIndex(X, Y: Integer): Integer;
     procedure AddTab(Child: TCustomForm);
    procedure DeleteTab(Child: TCustomForm);
    procedure ChangeSkinData; override;
    procedure Paint; override;
    function GetCloseSize: Integer;
  published
    property ShowAddButton: Boolean
      read FShowAddButton write SetShowAddButton;
    property DblClickChildMove: Boolean
      read FDblClickChildMove write FDblClickChildMove;
    property ShowCloseButtons: Boolean
      read FShowCloseButtons write FShowCloseButtons;
    property TabKind: TspSkinMDITabKind read FTabKind write SetTabKind;
    property DynamicSkinForm: TspDynamicSkinForm read DSF write DSF;
    property SupportChildMenus: Boolean
      read FSupportChildMenus write FSupportChildMenus;
    property UseSkinSize: Boolean read FUseSkinSize write FUseSkinSize;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property MoveTabs: Boolean read FMoveTabs write FMoveTabs;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property DefaultTabWidth: Integer read FDefaultTabWidth write FDefaultTabWidth;
    property MinTabWidth: Integer read FMinTabWidth write FMinTabWidth;
    property Align;
    property PopupMenu;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property BiDiMode;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnAddButtonClick: TNotifyEvent
      read FOnAddButtonClick write FOnAddButtonClick;
    property OnTabMouseEnter: TspMDITabMouseEnterEvent
      read FOnTabMouseEnter write FOnTabMouseEnter;
    property OnTabMouseLeave: TspMDITabMouseLeaveEvent
      read FOnTabMouseLeave write FOnTabMouseLeave;
    property OnTabMouseUp: TspMDITabMouseUpEvent
      read FOnTabMouseUp write FOnTabMouseUp;
    property OnTabMouseDown: TspMDITabMouseDownEvent
      read FOnTabMouseDown write FOnTabMouseDown;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property OnContextPopup;
    property OnTabGetDrawParamsEvent: TspMDITabGetDrawParamsEvent
      read FOnTabGetDrawParamsEvent write FOnTabGetDrawParamsEvent;
  end;
  
  TspSkinFrame = class(TspSkinComponent)
  private
    FFrame: TFrame;
    OldWindowProc: TWndMethod;
    FDrawBackground: Boolean;
    FCtrlsSkinData: TspSkinData;
    procedure SetCtrlsSkinData(Value: TspSkinData);
    procedure PaintBG(DC: HDC);
    procedure NewWndProc(var Message: TMessage);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CheckControlsBackground;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure UpdateSkinCtrls(WC: TWinControl);
  published
    property DrawBackground: Boolean read FDrawBackground write FDrawBackground;
    property CtrlsSkinData: TspSkinData read FCtrlsSkinData write SetCtrlsSkinData;
  end;


  function GetDynamicSkinFormComponent(AForm: TCustomForm): TspDynamicSkinForm;
  function GetMDIChildDynamicSkinFormComponent: TspDynamicSkinForm;
  function GetMDIChildDynamicSkinFormComponent2: TspDynamicSkinForm;

implementation

  Uses spPngImageList, spPngImage, spConst{$IFDEF TNTUNICODE}, TntForms, TntMenus{$ENDIF};

type
  PAreaInfo = ^TAreaInfo;
  TAreaInfo = record
    Control: TControl;
    AreaRect: TRect;
    UseAnchors: Boolean;
    AnchorLeft, AnchorTop, AnchorRight, AnchorBottom: Boolean;
  end;

const
   DSF_PRODUCT_VERSION = '12.55';
   AC_SRC_ALPHA = $1;
   WS_EX_LAYERED = $80000;
   InActiveBrightnessKf = 0.5;
   InActiveDarknessKf = 0.3;
   InActiveNoiseAmount = 50;

   MorphInc = 0.2;
   MouseTimerInterval = 50;
   MorphTimerInterval = 25;
   AnimateTimerInterval = 25;
   HTNCACTIVE = HTOBJECT;
   TRACKMARKEROFFSET = 5;

   DEFCAPTIONHEIGHT = 19;
   DEFBUTTONSIZE = 17;
   DEFTOOLCAPTIONHEIGHT = 15;
   DEFTOOLBUTTONSIZE = 13;
   DEFFORMMINWIDTH = 130;

   TMI_RESTORENAME = 'TRAY_DSF_RESTORE';
   TMI_CLOSENAME = 'TRAY_DSF_CLOSE';

   MI_MINNAME = 'DSF_MINITEM';
   MI_MAXNAME = 'DSF_MAXITEM';
   MI_CLOSENAME = 'DSF_CLOSE';
   MI_RESTORENAME = 'DSF_RESTORE';
   MI_MINTOTRAYNAME = 'DSF_MINTOTRAY';
   MI_ROLLUPNAME = 'DSF_ROLLUP';

   MI_CHILDITEM = '_DSFCHILDITEM';

   MI_CHILDITEMBAR = '_DSFCHILDITEMBAR';
   MI_CHILDITEMBARHIDE = '_DSFCHILDITEMBARHIDE';

   MDITABSBARLISTBUTTONW = 15;
   MDITABSBARADDBUTTONW = 14;

   WM_MDICHANGESIZE = WM_USER + 206;
   WM_MDICHILDMAX = WM_USER + 207;
   WM_MDICHILDRESTORE = WM_USER + 208;
   WM_MDICHILDMOVE = WM_USER + 209;
   WM_MDICHILDNORMALIZE = WM_USER + 210;
   WM_MDICHILDMIN = WM_USER + 211;
   WM_MDICHILDGETMAXSTATE = WM_USER + 212;



   // Billenium Effects messages
   BE_ID           = $41A2;
   BE_BASE         = CM_BASE + $0C4A;
   CM_BEPAINT      = BE_BASE + 0; // Paint client area to Billenium Effects' DC
   CM_BENCPAINT    = BE_BASE + 1; // Paint non client area to Billenium Effects' DC
   CM_BEFULLRENDER = BE_BASE + 2; // Paint whole control to Billenium Effects' DC
   CM_BEWAIT       = BE_BASE + 3; // Don't execute effect yet
   CM_BERUN        = BE_BASE + 4; // Execute effect now!

   CLOSE_SIZE = 14;

function GetDynamicSkinFormComponent;
var
  i: Integer;
begin
  Result := nil;
  if AForm <> nil then  
   for i := 0 to AForm.ComponentCount - 1 do
    if AForm.Components[i] is TspDynamicSkinForm
    then
      begin
        Result := (AForm.Components[i] as TspDynamicSkinForm);
        Break;
      end;
end;

//============== TspClientInActivePanel ====================//
constructor TspClientInActivePanel.Create(AOwner: TComponent);
begin
  inherited;
  Buffer := nil;
  Visible := False;
end;

destructor TspClientInActivePanel.Destroy;
begin
  if Buffer <> nil then Buffer.Free;
  Buffer := nil;
  inherited;
end;

procedure TspClientInActivePanel.Paint;
begin
  if Buffer <> nil then Buffer.Draw(Canvas, 0, 0);
end;

procedure TspClientInActivePanel.ShowPanel(AForm: TForm; AEffect: TspClientInActiveEffect);
var
  C: TCanvas;
  PS: TPaintStruct;
  Buffer2: TspBitMap;
begin
  if (AForm = nil) or not AForm.Visible then Exit;
  if (AForm.ClientWidth = 0) or (AForm.ClientHeight = 0) then Exit;
  Visible := False;
  Parent := AForm;
  SetBounds(0, 0, AForm.ClientWidth, AForm.ClientHeight);
  Buffer := TspBitmap.Create;
  Buffer.SetSize(AForm.ClientWidth, AForm.ClientHeight);
  C := TCanvas.Create;
  C.Handle := BeginPaint(AForm.Handle, PS);
  Buffer.Canvas.CopyRect(Rect(0, 0, Width, height), C, BoundsRect);
  EndPaint(AForm.Handle, PS);
  C.Handle := 0;
  C.Free;
  if AEffect = spieBlur
  then
    begin
      Blur(Buffer, 3);
    end
  else
    begin
      Buffer2 := TspBitMap.Create;
      Buffer2.SetSize(AForm.ClientWidth, AForm.ClientHeight);
      SendMessage(AForm.Handle, WM_ERASEBKGND, Buffer2.Canvas.Handle, 0);
      Buffer2.AlphaBlend := True;
      Buffer2.SetAlpha(170);
      Buffer2.Draw(Buffer, 0, 0);
      Buffer2.Free;
    end;
  Visible := True;
end;

procedure TspClientInActivePanel.HidePanel;
begin
  Visible := False;
  Buffer.Free;
  Buffer := nil;
end;

function GetMDIChildDynamicSkinFormComponent;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Application.MainForm.MDIChildCount - 1 do
  begin
    Result := GetDynamicSkinFormComponent(Application.MainForm.MDIChildren[i]);
    if (Result <> nil) and (Result.WindowState = wsMaximized)
    then
      Break
    else
      Result := nil;
  end;
end;

function GetMDIChildDynamicSkinFormComponent2;
begin
  if (Application.MainForm <> nil) and (Application.MainForm.ActiveMDIChild <> nil)
  then
    Result := GetDynamicSkinFormComponent(Application.MainForm.ActiveMDIChild)
  else
   Result := nil;
end;

//============= TspSkinComponent  ============= //

constructor TspSkinComponent.Create(AOwner: TComponent);
begin
  inherited;
  FSkinData := nil;
end;


procedure TspSkinComponent.SetSkinData(Value: TspSkinData);
begin
  FSkinData := Value;
end;

procedure TspSkinComponent.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinData) then FSkinData := nil;
end;

procedure TspSkinComponent.BeforeChangeSkinData;
begin
end;

procedure TspSkinComponent.ChangeSkinData;
begin
end;

//============= TspActiveSkinObject  =============//

constructor TspActiveSkinObject.Create;
begin
  Parent := AParent;
  SD := Parent.SkinData;
  Enabled := True;
  Visible := True;
  FMorphKf := 0;
  if AData <> nil
  then
    begin
      with AData do
      begin
        Self.IDName := IDName;
        Self.Hint := Hint;
        Self.SkinRectInAPicture := SkinRectInAPicture;
        Self.SkinRect := SkinRect;
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.InActiveSkinRect:= InActiveSkinRect;
        Self.Morphing := Morphing;
        Self.MorphKind := MorphKind;
        Self.CursorIndex := CursorIndex;
        Self.RollUp := RollUp;
        if (ActivePictureIndex <> - 1) and
           (ActivePictureIndex < SD.FActivePictures.Count)
        then
          ActivePicture := TBitMap(SD.FActivePictures.Items[ActivePictureIndex])
        else
          begin
            ActivePicture := nil;
            ActiveSkinRect := NullRect;
          end;

        if (ActiveMaskPictureIndex <> - 1) and
           (ActiveMaskPictureIndex < SD.FActivePictures.Count)
        then
          ActiveMaskPicture := TBitMap(SD.FActivePictures.Items[ActiveMaskPictureIndex])
        else
          ActiveMaskPicture := nil;

        Self.GlowLayerPictureIndex := GlowLayerPictureIndex;
        Self.GlowLayerMaskPictureIndex := GlowLayerMaskPictureIndex;
        Self.GlowLayerOffsetX := GlowLayerOffsetX;
        Self.GlowLayerOffsetY := GlowLayerOffsetY;
        Self.GlowLayerAlphaBlendValue := GlowLayerAlphaBlendValue;
      end;
      ObjectRect := SkinRect;
      if RollUp then Picture := SD.FRollUpPicture else Picture := SD.FPicture;
    end;
end;

function TspActiveSkinObject.MustParentUpdate: Boolean;
begin
  Result := False;
end;

procedure TspActiveSkinObject.DrawAlpha;
begin
end;

function TspActiveSkinObject.InActiveMask;
var
  C: TColor;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty)
  then
    begin
      Result := True;
      Exit;
    end;
  if ActiveMaskPicture = nil
  then
    Result := True
  else
    begin
      if (X >= 0) and (Y >= 0) and (X <= ActiveMaskPicture.Width) and
         (Y <= ActiveMaskPicture.Height)
      then
        C := ColorToRGB(ActiveMaskPicture.Canvas.Pixels[X, Y])
      else
        C := clWhite;

      if C = RGB(0, 0, 0)
      then
        Result := True
      else
        Result := False;
    end;
end;

procedure TspActiveSkinObject.HideLayer;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and
    Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    Parent.FLayerManager.Hide;
end;

procedure TspActiveSkinObject.ShowLayer;
var
  B, BM: TBitmap;
  X1, Y1: Integer;
  R: TRect;
  P: TPoint;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    begin
      B := TBitMap(SD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(SD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      R := ObjectRect;
      if Parent.FForm.FormStyle = fsMDIChild
      then
        begin
          if Parent.FSkinSupport
          then
            P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
          else
            P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
           P := Parent.FForm.ClientToScreen(P);
           OffsetRect(R, P.X, P.Y);
         end
       else
         begin
           if Parent.CanShowBorderLayer and Parent.FBorderLayer.FVisible and
              Parent.FBorderLayer.FData.FullBorder and
              (Parent.FBorderLayer.TopBorder <> nil)
           then
             begin
               OffsetRect(R,
                 Parent.FBorderLayer.TopBorder.Left,
                 Parent.FBorderLayer.TopBorder.Top);
             end
           else
           OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
         end;
      X1 := R.Left - GlowLayerOffsetX;
      Y1 := R.Top - GlowLayerOffsetY;
      Parent.FLayerManager.Show(X1, Y1, B, BM, GlowLayerAlphaBlendValue);
    end;
end;

function TspActiveSkinObject.EnableMorphing: Boolean;
begin
  Result := Morphing and (Parent.SkinData <> nil) and not IsNullRect(ActiveSkinRect) and
            Parent.SkinData.EnableSkinEffects and not
            (Parent.CanShowBorderLayer and (Parent.FBorderLayer.FData <> nil)
            and Parent.FBorderLayer.FData.FullBorder);
end;

procedure TspActiveSkinObject.ReDraw;
begin
  if EnableMorphing
  then Parent.MorphTimer.Enabled := True
  else Parent.DrawSkinObject(Self);
end;

procedure TspActiveSkinObject.DblClick;
begin

end;

procedure TspActiveSkinObject.MouseDown(X, Y: Integer; Button: TMouseButton);
begin
  Parent.MouseDownEvent(IDName, X, Y, ObjectRect, Button);
end;

procedure TspActiveSkinObject.MouseUp(X, Y: Integer; Button: TMouseButton);
begin
  if FMouseIn then Parent.MouseUpEvent(IDName, X, Y, ObjectRect, Button);
end;

procedure TspActiveSkinObject.MouseMove(X, Y: Integer);
begin
  Parent.MouseMoveEvent(IDName, X, Y, ObjectRect);
end;

procedure TspActiveSkinObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  if not IsNullRect(ActiveSkinRect) then ReDraw;
  Parent.MouseEnterEvent(IDName);
  ShowLayer;
end;

procedure TspActiveSkinObject.MouseLeave;
begin
  FMouseIn := False;
  Active := False;
  if not IsNullRect(ActiveSkinRect) then ReDraw;
  Parent.MouseLeaveEvent(IDName);
  HideLayer;
end;

function TspActiveSkinObject.CanMorphing;
begin
  Result := (Active and (MorphKf < 1)) or
            (not Active and (MorphKf > 0));
end;

procedure TspActiveSkinObject.DoMorphing;
begin
  if Active
  then MorphKf := MorphKf + MorphInc
  else MorphKf := MorphKf - MorphInc;
  Parent.DrawSkinObject(Self);
end;

procedure TspActiveSkinObject.Draw;

procedure CreateObjectImage(B: TBitMap; AActive: Boolean);
begin
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  with B.Canvas do
  begin
    if AActive
    then
      CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, ActiveSkinRect)
    else
      if SkinRectInApicture
      then
        CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, SkinRect)
      else
        CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, SkinRect);
  end;
end;

var
  PBuffer, APBuffer: TspEffectBmp;
  Buffer, ABuffer: TBitMap;
  ASR, SR: TRect;
begin
  ASR := ActiveSkinRect;
  SR := SkinRect;

  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  if Enabled and (not Parent.GetFormActive) and (not IsNullRect(InActiveSkinRect)) 
  then
    begin
      Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, InActiveSkinRect)
    end
  else
  if not EnableMorphing or
     ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
  then
    begin
      if Active and not IsNullRect(ASR)
      then
        Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, ASR)
      else
        if UpDate or SkinRectInApicture
        then
          begin
            if SkinRectInApicture
            then
              Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, SR)
            else
              Cnvs.CopyRect(ObjectRect, Picture.Canvas, SR);
          end;
    end
  else
    begin
      Buffer := TBitMap.Create;
      ABuffer := TBitMap.Create;
      CreateObjectImage(Buffer, False);
      CreateObjectImage(ABuffer, True);
      PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
      APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
      case MorphKind of
        mkDefault: PBuffer.Morph(APBuffer, MorphKf);
        mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
        mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
        mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
        mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
        mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
        mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
      end;
      PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
      PBuffer.Free;
      APBuffer.Free;
      Buffer.Free;
      ABuffer.Free;
    end;
end;

procedure TspActiveSkinObject.SetMorphKf(Value: Double);
begin
  FMorphKf := Value;
  if FMorphKf < 0 then FMorphKf := 0 else
  if FMorphKf > 1 then FMorphKf := 1;
end;

procedure TspUserObject.Draw;
begin
  Parent.PaintEvent(IDName, Cnvs, ObjectRect);
end;

//============= TspSkinTrackBarObject ============//
constructor TspSkinTrackBarObject.Create;
begin
  inherited Create(AParent, AData);
  with TspDataSkinTrackBar(AData) do
  begin
    Self.ButtonRect := ButtonRect;
    Self.ActiveButtonRect := ActiveButtonRect;
    Self.BeginPoint := BeginPoint;
    Self.EndPoint := EndPoint;
    Self.MinValue := MinValue;
    Self.MaxValue := MaxValue;
    Self.MouseDownChangeValue := MouseDownChangeValue;
    Self.ButtonTransparent := ButtonTransparent;
    Self.ButtonTransparentColor := ButtonTransparentColor;
  end;
  if abs(BeginPoint.Y - EndPoint.Y) < abs(EndPoint.X - BeginPoint.X)
  then
    TrackKind := tkHorizontal
  else
    TrackKind := tkVertical;
  FValue := MinValue;
  FButtonPos := CalcButtonPos(FValue);
end;

function TspSkinTrackBarObject.CalcButtonRect;
var
  L, T: Integer;
begin
  L := P.X - RectWidth(ButtonRect) div 2;
  T := P.Y - RectHeight(ButtonRect) div 2;
  Result := Rect(L, T,
                 L + RectWidth(ButtonRect), T + RectHeight(ButtonRect));
end;

function TspSkinTrackBarObject.CalcValue;
var
  kf: Double;
begin
  kf := 0;
  case TrackKind of
    tkHorizontal:
      kf := (FButtonPos.X - BeginPoint.X) / (EndPoint.X - BeginPoint.X);
    tkVertical:
      kf := 1 - (FButtonPos.Y - EndPoint.Y) / (BeginPoint.Y - EndPoint.Y);
  end;
  Result := MinValue + Round((MaxValue - MinValue) * kf);
end;

function TspSkinTrackBarObject.CalcButtonPos;
var
  kf: Double;
begin
  kf := (Value - MinValue) / (MaxValue - MinValue);
  case TrackKind of
    tkHorizontal:
      Result := Point(BeginPoint.X + Round((EndPoint.X - BeginPoint.X) * kf),
                      BeginPoint.Y);
    tkVertical:
      Result := Point(BeginPoint.X,
                      EndPoint.Y + Round((BeginPoint.Y - EndPoint.Y) *
                      (1 - kf)));
  end;
end;

procedure TspSkinTrackBarObject.SimplySetValue;
begin
  FValue := AValue;
  if FValue < MinValue then FValue := MinValue;
  if FValue > MaxValue then FValue := MaxValue;
  FOldButtonPos := FbuttonPos;
  FButtonPos := CalcButtonPos(Value);
  Parent.TrackBarChangeValueEvent(IDName, FValue);
end;

procedure TspSkinTrackBarObject.SetValue;
begin
  if FValue <> AValue
  then
    begin
      FValue := AValue;
      if FValue < MinValue then FValue := MinValue;
      if FValue > MaxValue then FValue := MaxValue;
      FOldButtonPos := FbuttonPos;
      FButtonPos := CalcButtonPos(Value);
      Parent.DrawSkinObject(Self);
      Parent.TrackBarChangeValueEvent(IDName, FValue);
    end;
end;

procedure TspSkinTrackBarObject.SetButtonPos;
begin
  if (FButtonPos.X <> AValue.X) or (FButtonPos.Y <> AValue.Y)
  then
    begin
      FOldButtonPos := FbuttonPos;
      FButtonPos := AValue;
      FValue := CalcValue(FButtonPos);
      Parent.DrawSkinObject(Self);
      Parent.TrackBarChangeValueEvent(IDName, FValue);
    end;
end;

procedure TspSkinTrackBarObject.Draw;
var
  BRect: TRect;
  Buffer: TBitMap;
  BR: TRect;
  B: TBitMap;
begin

  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  if MoveActive and not IsNullRect(ActiveButtonRect)
  then BRect := ActiveButtonRect
  else BRect := ButtonRect;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SkinRect);
  Buffer.Height := RectHeight(SkinRect);
  BR := CalcButtonRect(FButtonPos);
  //
  with Buffer.Canvas do
  begin
    case TrackKind of
      tkHorizontal:
        begin
          if IsNullRect(ActiveSkinRect)
          then
            CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
                     Picture.Canvas, SkinRect)
          else
            begin
              CopyRect(Rect(0, 0, FButtonPos.X, Buffer.Height),
                       ActivePicture.Canvas,
                       Rect(ActiveSkinRect.Left, ActiveSkinRect.Top,
                            ActiveSkinRect.Left + FButtonPos.X, ActiveSkinRect.Bottom));
              CopyRect(Rect(FButtonPos.X, 0, Buffer.Width, Buffer.Height),
                       Picture.Canvas,
                       Rect(SkinRect.Left + FButtonPos.X, SkinRect.Top,
                            SkinRect.Right, SkinRect.Bottom));
            end;
        end;
      tkVertical:
        begin
          if IsNullRect(ActiveSkinRect)
          then
            CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
                     Picture.Canvas, SkinRect)
          else
            begin
              CopyRect(Rect(0, 0, Buffer.Width, FButtonPos.Y),
                       Picture.Canvas,
                       Rect(SkinRect.Left, SkinRect.Top,
                            SkinRect.Right, SkinRect.Top + FButtonPos.Y));
              CopyRect(Rect(0, FButtonPos.Y, Buffer.Width, Buffer.Height),
                       ActivePicture.Canvas,
                       Rect(ActiveSkinRect.Left, ActiveSkinRect.Top + FButtonPos.Y,
                            ActiveSkinRect.Right, ActiveSkinRect.Bottom));
            end;
        end;
    end;
    //
    if ButtonTransparent
    then
      begin
        B := TBitMap.Create;
        B.Width := RectWidth(BRect);
        B.Height := RectHeight(BRect);
        B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
          ActivePicture.Canvas, BRect);
        B.Transparent := True;
        B.TransparentMode := tmFixed;
        B.TransparentColor := ButtonTransparentColor;
        Draw(BR.Left, BR.Top, B);
        B.Free;
      end
    else
      CopyRect(BR, ActivePicture.Canvas, BRect);
    //
  end;
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinTrackBarObject.MouseDown(X, Y: Integer; Button: TMouseButton);
var
  X1, Y1: Integer;
begin
  X1 := X - ObjectRect.Left;
  Y1 := Y - ObjectRect.Top;
  if PtInRect(CalcButtonRect(FButtonPos), Point(X1, Y1)) and (Button = mbLeft)
  then
    begin
      MoveActive := True;
      FOldMPoint.X := X1;
      FOldMPoint.Y := Y1;
      if not IsNullRect(ActiveButtonRect)
      then Parent.DrawSkinObject(Self);
    end
  else
    if MouseDownChangeValue and (Button = mbLeft)
    then
      case TrackKind of
        tkHorizontal:
          begin
            if X1 < BeginPoint.X then X1 := BeginPoint.X;
            if X1 > EndPoint.X then X1 := EndPoint.X;
            ButtonPos := Point(X1, BeginPoint.Y);
          end;
        tkVertical:
          begin
            if Y1 < EndPoint.Y then Y1 := EndPoint.Y;
            if Y1 > BeginPoint.Y then Y1 := BeginPoint.Y;
            ButtonPos := Point(BeginPoint.X, Y1);
          end;
     end;
  inherited MouseDown(X, Y, Button);
end;

procedure TspSkinTrackBarObject.MouseUp(X, Y: Integer; Button: TMouseButton);
begin
  if MoveActive and (Button = mbLeft)
  then
    begin
      MoveActive := False;
      if not IsNullRect(ActiveButtonRect)
      then
        Parent.DrawSkinObject(Self);
    end;
  inherited MouseUp(X, Y, Button);
end;

procedure TspSkinTrackBarObject.MouseMove(X, Y: Integer);
var
  X1, Y1: Integer;
  TestPos: Integer;
begin
  X1 := X - ObjectRect.Left;
  Y1 := Y - ObjectRect.Top;
  if MoveActive
  then
    case TrackKind of
      tkHorizontal:
        begin
          TestPos := FButtonPos.X + X1 - FOldMPoint.X;
          if (TestPos >= BeginPoint.X) and (TestPos <= EndPoint.X)
          then
            ButtonPos := Point(TestPos, FButtonPos.Y);
        end;

        tkVertical:
          begin
            TestPos := FButtonPos.Y + Y1 - FOldMPoint.Y;
            if (TestPos >= EndPoint.Y) and (TestPos <= BeginPoint.Y)
            then ButtonPos := Point(FButtonPos.X, TestPos);
          end;
    end;
  FOldMPoint := Point(X1, Y1);
  inherited MouseMove(X, Y);
end;

//============= TspSkinSwitchObject ==============//
constructor TspSkinSwitchObject.Create;
begin
  inherited Create(AParent, AData);
  FState := swsOff;
end;

procedure TspSkinSwitchObject.SetState;
begin
  FState := Value;
  if FState = swsOn then Active := True else Active := False;
  ReDraw;
  Parent.SwitchChangeStateEvent(IDName, FState);
end;

procedure TspSkinSwitchObject.SimpleSetState(Value: TSwitchState);
begin
  FState := Value;
  Active := FState = swsOn;
  if Active then FMorphKf := 1;
end;

procedure TspSkinSwitchObject.MouseDown;
begin
  if Button = mbLeft
  then
    if State = swsOff then State := swsOn else State := swsOff;
  inherited MouseDown(X, Y, Button);
end;

procedure TspSkinSwitchObject.MouseEnter;
begin
  FMouseIn := True;
  Parent.MouseEnterEvent(IDName);
end;

procedure TspSkinSwitchObject.MouseLeave;
begin
  FMouseIn := False;
  Parent.MouseLeaveEvent(IDName);
end;

//============= TspSkinButtonObject ============= //
constructor TspSkinButtonObject.Create;
begin
  inherited Create(AParent, AData);
  GroupIndex := -1;
  if AData <> nil
  then
  with TspDataSkinButton(AData) do
  begin
    Self.DownRect := DownRect;
    Self.DisableSkinRect := DisableSkinRect;
    Self.GroupIndex := GroupIndex;
    Self.AlphaMaskPictureIndex := AlphaMaskPictureIndex;
    Self.AlphaMaskActivePictureIndex := AlphaMaskActivePictureIndex;
    Self.AlphaMaskInActivePictureIndex := AlphaMaskInActivePictureIndex;
    Self.FAlphaNormalImage := FAlphaNormalImage;
    Self.FAlphaActiveImage := FAlphaActiveImage;
    Self.FAlphaDownImage := FAlphaDownImage;
    Self.FAlphaInActiveImage := FAlphaInActiveImage;
  end;
  MenuItem := nil;
  FPopupUp := False;
  FDown := False;
  Active := False;
  FMouseIn := False;
  FMorphKf := 0;
end;

procedure TspSkinButtonObject.HideLayer;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and
    Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    if MenuItem = nil
    then
      Parent.FLayerManager.Hide
    else
      Parent.FMenuLayerManager.Hide;
end;

procedure TspSkinButtonObject.ShowLayer;
var
  B, BM: TBitmap;
  X1, Y1: Integer;
  R: TRect;
  P: TPoint;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    begin
      B := TBitMap(SD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(SD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      R := ObjectRect;
      if Parent.FForm.FormStyle = fsMDIChild
      then
        begin
          if Parent.FSkinSupport
          then
            P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
          else
            P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
           P := Parent.FForm.ClientToScreen(P);
           OffsetRect(R, P.X, P.Y);
         end
       else
         begin
           if Parent.CanShowBorderLayer and Parent.FBorderLayer.FVisible and
              Parent.FBorderLayer.FData.FullBorder and
              (Parent.FBorderLayer.TopBorder <> nil)
           then
             begin
               OffsetRect(R,
                 Parent.FBorderLayer.TopBorder.Left,
                 Parent.FBorderLayer.TopBorder.Top);
             end
           else
             OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
         end;
      X1 := R.Left - GlowLayerOffsetX;
      Y1 := R.Top - GlowLayerOffsetY;
      if MenuItem = nil
      then
        Parent.FLayerManager.Show(X1, Y1, B, BM, GlowLayerAlphaBlendValue)
      else
        Parent.FMenuLayerManager.Show(X1, Y1, B, BM, GlowLayerAlphaBlendValue);
    end;
end;

procedure TspSkinButtonObject.Draw;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  if not Enabled and not IsNullRect(DisableSkinRect)
  then
    Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, DisableSkinRect)
  else
  if (FDown and not IsNullRect(DownRect)) and
     ((GroupIndex <> -1) or FMouseIn)
  then
    Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, DownRect)
  else
    inherited Draw(Cnvs, UpDate);
end;


function TspSkinButtonObject.CanMorphing: Boolean;
begin
  Result := inherited CanMorphing;
  Result := Result and not ((MenuItem <> nil) and FDown);
end;

procedure TspSkinButtonObject.SetDown;

procedure DoAllUp;
var
  i, j: Integer;
begin
  j := GroupIndex;
  if j <> -1 then
  for i := 0 to Parent.ObjectList.Count - 1 do
    if (TspActiveSkinObject(Parent.ObjectList.Items[i]) is TspSkinButtonObject) and
       (TspActiveSkinObject(Parent.ObjectList.Items[i]).IDName <> IDName)
    then
      with TspSkinButtonObject(Parent.ObjectList.Items[i]) do
        if (j = GroupIndex) and FDown
        then
          begin
            SetDown(False);
            Break;
          end;
end;

begin
  FDown := Value;

  if (MenuItem <> nil) and FDown and IsNullRect(DownRect)
  then
    begin
      FMouseIn := True;
      Active := True;
      if EnableMorphing then MorphKf := 1;
      Parent.DrawSkinObject(Self);
    end;

  if (MenuItem <> nil) and not FDown and IsNullRect(DownRect)
  then
    begin
      Parent.DrawSkinObject(Self);
      if EnableMorphing then ReDraw;
    end;

  if IsNullRect(DownRect) and not FDown then Exit;

  if IsNullRect(DownRect) and FDown
  then
    begin
      DoAllUp;
      Exit;
    end
  else
    if FDown
    then
      begin
        if EnableMorphing then MorphKf := 1;
        Parent.DrawSkinObject(Self);
        DoAllUp;
      end
    else
      begin
        if (GroupIndex <> -1) or (MenuItem <> nil) then Active := False;
        if EnableMorphing and not IsNullRect(DownRect)
        then
          Parent.DrawSkinObject(Self);
        ReDraw;
      end;
end;

procedure TspSkinButtonObject.TrackMenu;
var
  R: TRect;
  Menu: TMenu;
  P: TPoint;
begin
  if MenuItem = nil then Exit;
  if MenuItem.Count = 0 then Exit;
  if Parent.FLayerManager.IsVisible then Parent.FLayerManager.Hide;
  if Parent.FMenuLayerManager.IsVisible then Parent.FMenuLayerManager.Hide;
  if FMouseIn then ShowLayer;
  Parent.FMenuTrackObject := Self;
  R := ObjectRect;
  if Parent.FForm.FormStyle = fsMDIChild
  then
    begin
      if Parent.FSkinSupport
      then
        P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
      else
        P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
      P := Parent.FForm.ClientToScreen(P);
      OffsetRect(R, P.X, P.Y);
    end
  else
    begin
      if Parent.CanShowBorderLayer and Parent.FBorderLayer.FVisible and
              Parent.FBorderLayer.FData.FullBorder and
              (Parent.FBorderLayer.TopBorder <> nil)
      then
        begin
          OffsetRect(R,
           Parent.FBorderLayer.TopBorder.Left,
           Parent.FBorderLayer.TopBorder.Top);
        end
     else
      OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
    end;  
  Menu := MenuItem.GetParentMenu;
  if Menu is TspSkinPopupMenu
  then
    TspSkinPopupMenu(Menu).PopupFromRect(R, FPopupUp)
  else
    begin
      Parent.SkinMenuOpen;
      if Menu is TspSkinMainMenu
      then
        Parent.SkinMenu.Popup(nil, TspSkinMainMenu(Menu).SkinData, 0, R, MenuItem, FPopupUp)
      else
        if Parent.MenusSkinData = nil
        then
          Parent.SkinMenu.Popup(nil, Parent.SkinData, 0, R, MenuItem, FPopupUp)
        else
          Parent.SkinMenu.Popup(nil, Parent.MenusSkinData, 0, R, MenuItem, FPopupUp);
    end;
  Parent.FMenuTrackObject := nil;  
end;

procedure TspSkinButtonObject.MouseDown;
begin
  if not Enabled then Exit;
  if (Button = mbLeft) and not FDown
  then
    begin
      SetDown(True);
      TrackMenu;
    end;
  inherited MouseDown(X, Y, Button);
end;

procedure TspSkinButtonObject.MouseUp;
begin
  if not Enabled then Exit;
  if (Button <> mbLeft)
  then
    begin
      inherited MouseUp(X, Y, Button);
      Exit;
    end;
  if (MenuItem = nil) and FDown and (GroupIndex = -1)
  then
    SetDown(False);
  inherited MouseUp(X, Y, Button);
end;

procedure TspSkinButtonObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  if IsNullRect(DownRect) or not FDown
  then
    begin
      if not IsNullRect(ActiveSkinRect) then ReDraw;
      if Self.MenuItem <> nil then ShowLayer;
    end
  else
    if not (FDown and (GroupIndex <> -1))
    then
      begin
        if FDown
        then
          Parent.DrawSkinObject(Self)
        else
          if not IsNullRect(ActiveSkinRect) and (GroupIndex = -1) then ReDraw;
    end;
  Parent.MouseEnterEvent(IDName);
   if MenuItem = nil then ShowLayer;
end;

procedure TspSkinButtonObject.MouseLeave;
begin
  FMouseIn := False;
  if (MenuItem <> nil) and FDown and IsNullRect(DownRect)
  then
    begin
      Active := False;
    end
  else
  if not (FDown and not IsNullRect(DownRect) and
         ((MenuItem <> nil) or (GroupIndex <> -1)))
  then
    begin
      Active := False;
      if EnableMorphing and FDown then Morphkf := 1;
      if (not IsNullRect(ActiveSkinRect)) or
         (not IsNullRect(DownRect) and (GroupIndex = -1)) then Redraw;
      if MenuItem <> nil then HideLayer;  
    end;
  Parent.MouseLeaveEvent(IDName);
  if MenuItem = nil then HideLayer;
end;

// TspSkinCaptionMenuButton

constructor TspSkinCaptionMenuButton.Create(AParent: TspDynamicSkinForm; AData: TspDataSkinObject);
begin
  inherited Create(AParent, AData);
  Visible := False;
  FActiveMaskBuffer := TBitmap.Create;
  if AData <> nil
  then
    with TspDataSkinCaptionMenuButton(AData) do
    begin
      Self.Morphing := False;
      Self.FontName := FontName;
      Self.FontStyle := FontStyle;
      Self.FontHeight := FontHeight;
      Self.FontColor := FontColor;
      Self.ActiveFontColor := ActiveFontColor;
      Self.DownFontColor := DownFontColor;
      Self.InActiveFontColor := InActiveFontColor;
      Self.LeftOffset := LeftOffset;
      Self.RightOffset := RightOffset;
      Self.TopPosition := TopPosition;
      Self.ClRect := ClRect; 
    end;
end;

destructor TspSkinCaptionMenuButton.Destroy; 
begin
  FActiveMaskBuffer.Free;
  inherited;
end;

function TspSkinCaptionMenuButton.MustParentUpdate: Boolean;
begin
  Result := True;
end;

procedure TspSkinCaptionMenuButton.Redraw; 
begin
  Parent.UpDateFormNC;
end;

procedure TspSkinCaptionMenuButton.CreateMaskBuffer;
begin
  if ActiveMaskPicture = nil then Exit;
  if FActiveMaskBuffer.Width <> Parent.FMenuButtonWidth
  then
    begin
      FActiveMaskBuffer.Width := Parent.FMenuButtonWidth;
      FActiveMaskBuffer.Height := ActiveMaskPicture.Height;
      CreateHSkinImage(LeftOffset, RightOffset,
        FActiveMaskBuffer, ActiveMaskPicture,
        Rect(0, 0, ActiveMaskPicture.Width, ActiveMaskPicture.Height),
        FActiveMaskBuffer.Width, FActiveMaskBuffer.Height, False);
    end;
end;

function TspSkinCaptionMenuButton.InActiveMask(X, Y: Integer): Boolean;
var
  C: TColor;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty)
  then
    begin
      Result := True;
      Exit;
    end;
  if ActiveMaskPicture = nil
  then
    Result := True
  else
    begin
      if (X >= 0) and (Y >= 0) and (X <= FActiveMaskBuffer.Width) and
         (Y <= FActiveMaskBuffer.Height)
      then
        C := ColorToRGB(FActiveMaskBuffer.Canvas.Pixels[X, Y])
      else
        C := clWhite;

      if C = RGB(0, 0, 0)
      then
        Result := True
      else
        Result := False;
    end;
end;

procedure TspSkinCaptionMenuButton.MouseEnter;
begin
  if Parent.FMenuButtonPopupMenu <> nil
  then
    MenuItem := Parent.FMenuButtonPopupMenu.Items
  else
    MenuItem := nil;
  inherited;
end;

procedure TspSkinCaptionMenuButton.DrawAlpha(Cnvs: TCanvas; ABitMap: TspBitmap);
var
  Buffer, SB: TspBitmap;
  R, R1, R11, R2, R22, R3, R33: TRect;
  bf: TspBlendFunction;
  C: TColor;
begin
  if RectWidth(ObjectRect) = 0 then Exit;

  CreateMaskBuffer;

  Buffer := TspBitmap.Create;
  Buffer.SetSize(RectWidth(ObjectRect), RectHeight(SkinRect));
  //
  if FDown
  then
    begin
      SB := FAlphaDownImage;
      C := DownFontColor;
    end
  else
  if FMouseIn
  then
    begin
      SB := FAlphaActiveImage;
      C := ActiveFontColor;
    end
  else
    begin
      if Parent.FFormActive
      then
        begin
          SB := FAlphaNormalImage;
          C := FontColor;
        end
      else
        begin
          SB := FAlphaInActiveImage;
          C := InActiveFontColor;
        end;
    end;
  //
  R1 := Rect(0, 0, LeftOffset, SB.Height);
  R11 := Rect(0, 0, LeftOffset, Buffer.Height);
  R2 := Rect(SB.Width - RightOffset, 0, SB.Width, SB.Height);
  R22 := Rect(Buffer.Width - RightOffset, 0, Buffer.Width, Buffer.Height);
  R3 := Rect(LeftOffset, 0, SB.Width - RightOffset, SB.Height);
  R33 := Rect(LeftOffset, 0, Buffer.Width - RightOffset, Buffer.Height);
  with Buffer.Canvas do
  begin
    CopyRect(R11, SB.Canvas, R1);
    CopyRect(R22, SB.Canvas, R2);
    CopyRect(R33, SB.Canvas, R3);
  end;
  // draw image and text
  with Buffer.Canvas do
  begin
    Font.Name := Self.FontName;
    Font.Height := Self.FontHeight;
    Font.Color := C;
    Font.Style := Self.FontStyle;
  end;
  //
  R := ClRect;
  R.Right := R.Right + RectWidth(ObjectRect) - RectWidth(SkinRect);
  DrawImageAndTextWithAlpha(Buffer.Canvas, R, Parent.FMenuButtonMargin, Parent.FMenuButtonSpacing,
   blGlyphLeft, Parent.FMenuButtonCaption, Parent.FMenuButtonImageIndex, Parent.FMenuButtonImageList,
      False, Parent.FFormActive, False, 0);
  //
  bf.BlendOp := AC_SRC_OVER;
  bf.BlendFlags := 0;
  bf.SourceConstantAlpha := 255;
  bf.AlphaFormat := AC_SRC_ALPHA;
  if spEffBmp.IsMsImg
  then
    AlphaBlendFunc(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top,
      RectWidth(ObjectRect), RectHeight(ObjectRect), Buffer.DC,
      0, 0, Buffer.Width, Buffer.Height, bf);
  //
  Buffer.Free;
end;

procedure TspSkinCaptionMenuButton.Draw(Cnvs: TCanvas; UpDate: Boolean);
begin
  DrawAlpha(Cnvs, nil);
end;


//============= TspSkinStdButtonObject =================//

constructor TspSkinStdButtonObject.Create;
begin
  inherited Create(AParent, AData);
  if AData <> nil
  then
    with TspDataSkinStdButton(AData) do
    begin
      Self.Command := Command;
      Self.RestoreRect := RestoreRect;
      Self.RestoreActiveRect := RestoreActiveRect;
      Self.RestoreDownRect := RestoreDownRect;
      Self.RestoreInActiveRect := RestoreInActiveRect;
      Self.RestoreHint := RestoreHint;
      Self.FTempHint := Hint;
      //
      Self.FAlphaRestoreNormalImage := FAlphaRestoreNormalImage;
      Self.FAlphaRestoreActiveImage := FAlphaRestoreActiveImage;
      Self.FAlphaRestoreDownImage := FAlphaRestoreDownImage;
      Self.FAlphaInActiveRestoreImage := FAlphaInActiveRestoreImage;
      //
      FSkinSupport := True;
    end
  else
    FSkinSupport := False;
end;

function TspSkinStdButtonObject.InActiveMask(X, Y: Integer): Boolean;
begin
  if (Command = cmSysMenu) and Parent.ShowIcon and FSkinSupport and
     SkinRectInAPicture
  then
    Result := True
  else
    Result := inherited InActiveMask(X, Y);
end;

procedure TspSkinStdButtonObject.DrawAlpha;

procedure DrawImage(AImage: TspBitmap; AObjectRect: TRect);
var
  bf : TspBlendFunction;
begin
  bf.BlendOp := AC_SRC_OVER;
  bf.BlendFlags := 0;
  bf.SourceConstantAlpha := 255;
  bf.AlphaFormat := AC_SRC_ALPHA;
  if spEffBmp.IsMsImg
  then
    AlphaBlendFunc(Cnvs.Handle, AObjectRect.Left, AObjectRect.Top,
      RectWidth(AObjectRect), RectHeight(AObjectRect), AImage.DC,
      0, 0, AImage.Width, AImage.Height, bf);
end;


var
  FRestoreMode: Boolean;
  B: TspBitMap;
  IX, IY: Integer;
begin
  FRestoreMode := False;

  case Command of
    cmMaximize:
      if Parent.WindowState = wsMaximized
      then FRestoreMode := True;
    cmMinimize:
      if (Parent.WindowState = wsMinimized) and (Parent.FForm <> Application.MainForm)
      then FRestoreMode := True;
    cmRollUp:
      if Parent.RollUpState
      then FRestoreMode := True;
  end;

  if (Command = cmSysMenu) and Parent.FShowIcon
  then
    begin
      if not Parent.IsAlphaIcon
      then
        begin
          Parent.GetIconSize(IX, IY);
          B := TspBitMap.Create;
          B.SetSize(IX, IY);
          B.FillRect(Rect(0, 0, B.Width, B.Height), spTransparent);
          Parent.DrawFormIcon(B.Canvas, 0, 0);
          B.Transparent := True;
          B.Draw(Cnvs, ObjectRect.Left, ObjectRect.Top);
          B.Free;
        end
      else
        Parent.DrawFormIcon(Cnvs, ObjectRect.Left, ObjectRect.Top);
    end
  else
  if not Parent.FFormActive and not IsNullRect(InActiveSkinRect)
  then
    begin
      if FRestoreMode and (FAlphaInActiveRestoreImage <> nil)
      then
        DrawImage(FAlphaInActiveRestoreImage, ObjectRect)
      else
        if FAlphaInActiveImage <> nil
        then
          DrawImage(FAlphaInActiveImage, ObjectRect);
    end
  else
  if FDown and not IsNullRect(DownRect) and ((Command = cmSysMenu) or FMouseIn)
  then
    begin
      if FRestoreMode and (FAlphaRestoreDownImage <> nil)
      then
        DrawImage(FAlphaRestoreDownImage, ObjectRect)
      else
        if FAlphaDownImage <> nil
        then
          DrawImage(FAlphaDownImage, ObjectRect);
    end
  else
  if FMouseIn and not IsNullRect(ActiveSkinRect)
  then
    begin
      if FRestoreMode and (FAlphaRestoreActiveImage <> nil)
      then
        DrawImage(FAlphaRestoreActiveImage, ObjectRect)
      else
        if FAlphaActiveImage <> nil
        then
          DrawImage(FAlphaActiveImage, ObjectRect);
    end
  else
    begin
      if FRestoreMode and (FAlphaRestoreNormalImage <> nil)
      then
        DrawImage(FAlphaRestoreNormalImage, ObjectRect)
      else
        if FAlphaNormalImage <> nil
        then
          DrawImage(FAlphaNormalImage, ObjectRect);
   end;
   
end;

procedure TspSkinStdButtonObject.ShowLayer;
begin
  if ((Command = cmSysMenu) and Parent.ShowIcon and FSkinSupport and
     SkinRectInAPicture) or
     (FSkinSupport and not Parent.FFormActive and not IsNullRect(InActiveSkinRect))
  then
    Exit;
  inherited;
end;

procedure TspSkinStdButtonObject.HideLayer; 
begin
  if ((Command = cmSysMenu) and Parent.ShowIcon and FSkinSupport and
     SkinRectInAPicture) or
     (FSkinSupport and not Parent.FFormActive and not IsNullRect(InActiveSkinRect))
  then
    Exit;
  inherited;
end;

procedure TspSkinStdButtonObject.DefaultDraw(Cnvs: TCanvas);
var
  Buffer: TBitMap;
  R: TRect;
  IX, IY: Integer;
  IC: TColor;
begin
  if (Command = cmSysMenu) and Parent.FShowIcon
  then
    begin
      Parent.DrawFormIcon(Cnvs, ObjectRect.Left, ObjectRect.Top);
      Exit;
    end;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(ObjectRect);
  Buffer.Height := RectHeight(ObjectRect);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    if FDown and FMouseIn
    then
      begin
        Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNDOWNCOLOR;
        FillRect(R);
      end
    else
      if FMouseIn
      then
        begin
          Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Brush.Color := SP_XP_BTNACTIVECOLOR;
          FillRect(R);
        end
      else

        begin
          Brush.Color := clBtnFace;
          FillRect(R);
        end;
  end;
  IX := Buffer.Width div 2 - 5;
  IY := Buffer.Height div 2 - 4;
  if FDown and FMouseIn
  then
    begin
      Inc(IX);
      Inc(IY);
    end;
  if Enabled
  then
    IC := clBtnText
  else
    IC := clBtnShadow;
  case Command of
    cmMinimizeToTRay: DrawMTImage(Buffer.Canvas, IX, IY, IC);
    cmClose:
      DrawCloseImage(Buffer.Canvas, IX, IY, IC);
    cmMaximize:
      if Parent.WindowState = wsMaximized
      then DrawRestoreImage(Buffer.Canvas, IX, IY, IC)
      else DrawMaximizeImage(Buffer.Canvas, IX, IY, IC);
    cmMinimize:
      if Parent.WindowState = wsMinimized
      then DrawRestoreImage(Buffer.Canvas, IX, IY, IC)
      else DrawMinimizeImage(Buffer.Canvas, IX, IY, IC);
    cmRollUp:
      if Parent.RollUpState
      then
        DrawRestoreRollUpImage(Buffer.Canvas, IX, IY, IC)
      else
        DrawRollUpImage(Buffer.Canvas, IX, IY, IC);
    cmSysMenu:
      DrawSysMenuImage(Buffer.Canvas, IX, IY, IC);
  end;
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

function TspSkinStdButtonObject.CanMorphing: Boolean;
begin
  if (Command = cmSysMenu) and Parent.ShowIcon and
     (SkinRectInAPicture)
  then
    Result := False
  else
    Result := inherited CanMorphing;
end;

procedure TspSkinStdButtonObject.Draw;

procedure CreateRestoreObjectImage(B: TBitMap; AActive: Boolean);
begin
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  with B.Canvas do
  begin
    if AActive
    then
      CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, RestoreActiveRect)
    else
      CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, RestoreRect);
  end;
end;

var
  PBuffer, APBuffer: TspEffectBmp;
  Buffer, ABuffer: TBitMap;
  ASR, SR: TRect;
  FRestoreMode: Boolean;
begin
  if not FSkinSupport
  then
    begin
      DefaultDraw(Cnvs);
      Exit;
    end;

  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  FRestoreMode := False;
  case Command of
    cmMaximize:
      if Parent.WindowState = wsMaximized
      then FRestoreMode := True;
    cmMinimize:
      if (Parent.WindowState = wsMinimized) and (Parent.FForm <> Application.MainForm)
      then FRestoreMode := True;
    cmRollUp:
      if Parent.RollUpState
      then FRestoreMode := True;
  end;

  if (Command = cmSysMenu) and Parent.FShowIcon and SkinRectInAPicture
  then
    begin
      Parent.DrawFormIcon(Cnvs, ObjectRect.Left, ObjectRect.Top);
      FMorphKf := 0;
      Exit;
    end;

  if (not Enabled) or
     (Enabled and (not Parent.GetFormActive) and (not IsNullRect(InActiveSkinRect)) and not FRestoreMode)
  then
    begin
      inherited;
      Exit;
    end;

  if IsNullRect(RestoreRect) or not FRestoreMode
  then
    begin
      if FDown and not IsNullRect(DownRect) and (Command = cmSysMenu)
      then
        Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, DownRect)
      else
        inherited;
    end
  else
    begin
      if not Parent.FFormActive and not IsNullRect(RestoreInActiveRect)
      then
        Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, RestoreInActiveRect)
      else  
      if FDown and not IsNullRect(RestoreDownRect) and FMouseIn
      then
        Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, RestoreDownRect)
      else
        begin
          ASR := RestoreActiveRect;
          SR := RestoreRect;
          if not EnableMorphing or
          ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
          then
            begin
              if Active and not IsNullRect(ASR)
              then
                Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, ASR)
              else
                Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, SR);
            end
          else
            begin
              Buffer := TBitMap.Create;
              ABuffer := TBitMap.Create;
              CreateRestoreObjectImage(Buffer, False);
              CreateRestoreObjectImage(ABuffer, True);
              PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
              APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
              case MorphKind of
                mkDefault: PBuffer.Morph(APBuffer, MorphKf);
                mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
                mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
                mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
                mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
                mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
                mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
              end;
              PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
              PBuffer.Free;
              APBuffer.Free;
              Buffer.Free;
              ABuffer.Free;
            end;
        end;
    end;
end;

procedure TspSkinStdButtonObject.DoMax;
begin
  if Parent.SupportNCArea
  then
    begin
     HideLayer;
     if Parent.WindowState = wsMaximized
     then Parent.WindowState := wsNormal
     else Parent.WindowState := wsMaximized;
    end
  else
    if Parent.WindowState <> wsMaximized
    then Parent.WindowState := wsMaximized
    else Parent.WindowState := wsNormal;
end;

procedure TspSkinStdButtonObject.DoMin;
begin
  if Parent.SupportNCArea
  then
    begin
      HideLayer;
      if Parent.WindowState = wsMinimized
      then Parent.WindowState := wsNormal
      else Parent.WindowState := wsMinimized;
    end
  else
    Parent.WindowState := wsMinimized;
end;

procedure TspSkinStdButtonObject.DoClose;
begin
  Parent.FForm.Close;
end;

procedure TspSkinStdButtonObject.DoRollUp;
begin
  Parent.RollUpState := not Parent.RollUpState;
end;

procedure TspSkinStdButtonObject.DoMinimizeToTray;
begin
  Parent.MinimizeToTray;
end;

procedure TspSkinStdButtonObject.DoCommand;
begin
  case Command of
    cmMinimizeToTray:
      begin
        Parent.TestActive(-1,-1, False);
        DoMinimizeToTray;
      end;  
    cmClose:
     begin
       Parent.TestActive(-1,-1, False);
       DoClose;
     end;  
    cmMinimize:
     begin
       Parent.TestActive(-1,-1, False);
       if Parent.AlwaysMinimizeToTray
       then
         Parent.MinimizeToTray
       else
         DoMin;
     end;    
    cmMaximize:
      begin
        Parent.TestActive(-1, -1, False);
        DoMax;
      end;
    cmRollUp: DoRollUp;
  end;
end;

procedure TspSkinStdButtonObject.DblClick;
begin
  if Command = cmSysMenu then DoClose;
end;

procedure TspSkinStdButtonObject.MouseEnter;
begin
  //
  if (Command <> cmDefault)
  then
  if Parent.RollUpState and (RestoreHint <> '') and (Command = cmRollUp)
  then
    Hint := RestoreHint
  else
  if (Parent.WindowState = wsMinimized) and (RestoreHint <> '') and (Command = cmMinimize)
  then
    Hint := RestoreHint
  else
  if (Parent.WindowState = wsMaximized) and (RestoreHint <> '') and (Command = cmMaximize)
  then
    Hint := RestoreHint
  else
    Hint := FTempHint;
  //
  if not (Parent.ShowIcon and (Command = cmSysMenu) and SkinRectInAPicture)
  then
    inherited;
end;

procedure TspSkinStdButtonObject.MouseLeave;
begin
  if not (Parent.ShowIcon and (Command = cmSysMenu) and SkinRectInAPicture)
  then
    inherited;
end;

procedure TspSkinStdButtonObject.MouseDown;
begin
  if not Enabled then Exit;
  if (Button = mbLeft) and not FDown
  then
    begin
      if (Command = cmSysMenu) then Self.MenuItem := Parent.GetSystemMenu;
      if not (Parent.ShowIcon and (Command = cmSysMenu) and SkinRectInAPicture)
      then
        SetDown(True);
      if (Command = cmSysMenu) then TrackMenu;
    end;
end;

procedure TspSkinStdButtonObject.MouseUp;
begin
  if (Command = cmClose)
  then
    begin
      inherited;
      if Active and (Button = mbLeft) then DoCommand;
    end
  else
    begin
      if Active and (Button = mbLeft) then DoCommand;
      if not (Parent.ShowIcon and (Command = cmSysMenu) and SkinRectInAPicture)
      then
        inherited;
    end;
end;

//==============TspSkinMainMenuItem=============//
constructor TspSkinMainMenuItem.Create;
begin
  inherited Create(AParent, AData);
  with TspDataSkinMainMenuItem(AData) do
  begin
    Self.FontName := FontName;
    Self.FontHeight := FontHeight;
    Self.FontStyle := FontStyle;
    Self.FontColor := FontColor;
    Self.ActiveFontColor := ActiveFontColor;
    Self.DownFontColor := DownFontColor;
    Self.TextRct := TextRct;
    Self.DownRect := DownRect;
    Self.LO := ItemLO;
    Self.RO := ItemRO;
  end;
  if IsNullRect(DownRect) then
    if IsNullRect(ActiveSkinRect)
    then DownRect := SkinRect else DownRect := ActiveSkinRect;
  if IsNullRect(ActiveSkinRect) then Morphing := False;
  OldEnabled := Enabled;
  Visible := True;
end;

procedure TspSkinMainMenuItem.SetDown;
begin
  FDown := Value;
  if FDown
  then
    begin
      Parent.DrawSkinObject(Self);
      TrackMenu;
      if not Parent.InMainMenu
      then
        begin
          Parent.InMainMenu := True;
          if Assigned(Parent.FOnMainMenuEnter) then Parent.FOnMainMenuEnter(Parent);
        end;
    end
  else
    begin
      Active := False;
      if EnableMorphing then MorphKf := 1;
      ReDraw;
    end;
end;

procedure TspSkinMainMenuItem.SearchActive;
var
  i: Integer;
begin
  for i := 0 to Parent.ObjectList.Count - 1 do
   if (TspActiveSkinObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuItem)
      and (TspSkinMainMenuItem(Parent.ObjectList.Items[i]).IDName <> IDName)
      and (TspSkinMainMenuItem(Parent.ObjectList.Items[i]).Active)
   then
     begin
       TspSkinMainMenuItem(Parent.ObjectList.Items[i]).MouseLeave;
       Break;
     end;
end;

function TspSkinMainMenuItem.SearchDown;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Parent.ObjectList.Count - 1 do
   if (TspActiveSkinObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuItem)
      and (TspSkinMainMenuItem(Parent.ObjectList.Items[i]).IDName <> IDName)
      and (TspSkinMainMenuItem(Parent.ObjectList.Items[i]).FDown)
   then
     begin
       TspSkinMainMenuItem(Parent.ObjectList.Items[i]).SetDown(False);
       Result := True;
       Break;
     end;
end;

procedure TspSkinMainMenuItem.Draw;

function CalcObjectRect(Cnvs: TCanvas): TRect;
var
  w, i, j: Integer;
  R, TR: TRect;
begin
  w := TextRct.Left + RectWidth(SkinRect) - TextRct.Right;
  with Cnvs do
  begin
    Font.Name := FontName;
    Font.Style := FontStyle;
    Font.Height := FontHeight;
  end;
  TR := Rect(0, 0, 0, 0);
  SPDrawSkinText(Cnvs, MenuItem.Caption, TR,
    Parent.FForm.DrawTextBiDiModeFlags(DT_CALCRECT or DT_CENTER));
  w := w + RectWidth(TR) + 2;
  R := Rect(0, 0, 0, 0);
  j := Parent.ObjectList.IndexOf(Self);
  for i := j - 1  downto 0 do
    if TspActiveSkinObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      begin
        R.Left := TspActiveSkinObject(Parent.ObjectList.Items[i]).ObjectRect.Right;
        Break;
      end;
  if R.Left = 0 then R.Left := Parent.NewMainMenuRect.Left;
  R.Top := Parent.NewMainMenuRect.Top;
  R.Right := R.Left + w;
  R.Bottom := R.Top + RectHeight(SkinRect);
  TempObjectRect := NullRect;
  with Parent do
  begin
    if SupportNCArea and not UpDate and (R.Top > NewClRect.Bottom)
    then
      begin
        TempObjectRect := R;
        OffsetRect(R, 0, -NewClRect.Bottom);
      end;  
  end;
  Result := R;
end;

procedure CreateItemImage(B: TBitMap; Rct: TRect; AActive: Boolean);
var
  XO, w, XCnt: Integer;
  TR: TRect;
  X: Integer;
begin
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  with B.Canvas do
  begin
    if LO <> 0 then
       CopyRect(Rect(0, 0, LO, B.Height), ActivePicture.Canvas,
                Rect(Rct.Left, Rct.Top, Rct.Left + LO, Rct.Bottom));
    if RO <> 0 then
       CopyRect(Rect(B.Width - RO, 0, B.Width, B.Height),
                ActivePicture.Canvas,
                Rect(Rct.Right - RO, Rct.Top, Rct.Right, Rct.Bottom));
    Inc(Rct.Left, LO);
    Dec(Rct.Right, RO);
    w := RectWidth(Rct);
    XCnt := (B.Width - LO - RO) div w;
    for X := 0 to XCnt do
    begin
      if LO + X * w + w > B.Width - RO
      then XO := LO + X * w + w - (B.Width - RO)
      else XO := 0;
      B.Canvas.CopyRect(Rect(LO + X * w, 0, LO + X * w + w - XO,
                        B.Height),
                        ActivePicture.Canvas,
                        Rect(Rct.Left, Rct.Top, Rct.Right - XO, Rct.Bottom));
    end;
    Brush.Style := bsClear;
    if FDown
    then
      Font.Color := DownFontColor
    else
      if AActive
      then Font.Color := ActiveFontColor
      else
        if MenuItem.Enabled
        then Font.Color := FontColor
        else Font.Color := UnEnabledFontColor;
    Font.Name := FontName;
    Font.Style := FontStyle;
    Font.Height := FontHeight;
    TR := TextRct;
    SPDrawSkinText(B.Canvas, MenuItem.Caption, TR, DT_CALCRECT);
    Inc(TR.Right, 2);
    SPDrawSkinText(B.Canvas,  MenuItem.Caption, TR,
     Parent.FForm.DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER));
  end;
end;

var
  Buffer, ABuffer: TBitMap;
  PBuffer, APBuffer: TspEffectBmp;
begin
  if IsNullRect(SkinRect) or IsNullRect(TextRct) then Exit;
  Buffer := TBitMap.Create;
  ObjectRect := CalcObjectRect(Buffer.Canvas);
  if ObjectRect.Right > Parent.NewMainMenuRect.Right
  then
    begin
      if Visible
      then
        begin
          OldEnabled := Enabled;
          Enabled := False;
          Visible := False;
        end;
      Buffer.Free;
      Exit;
    end
  else
    if not Visible
    then
      begin
        Visible := True;
        Enabled := OldEnabled;
      end;
  if FDown
  then
    begin
      CreateItemImage(Buffer, DownRect, True);
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
    end
  else
    if not EnableMorphing or
       ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
    then
      begin
        if Active
        then
          begin
            if isNullRect(ActiveSkinRect)
            then
              CreateItemImage(Buffer, SkinRect, True)
            else
              CreateItemImage(Buffer, ActiveSkinRect, True);
          end
        else CreateItemImage(Buffer, SkinRect, False);
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
      end
    else
      begin
        CreateItemImage(Buffer, SkinRect, False);
        ABuffer := TBitMap.Create;
        CreateItemImage(ABuffer, ActiveSkinRect, True);
        PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
        APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
        case MorphKind of
          mkDefault: PBuffer.Morph(APBuffer, MorphKf);
          mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
          mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
          mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
          mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
          mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
          mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
        end;
        PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
        PBuffer.Free;
        APBuffer.Free;
        ABuffer.Free;
      end;
  Buffer.Free;
  with Parent do
  begin
    if SupportNCArea and not UpDate and not IsNullRect(TempObjectRect)
    then
      ObjectRect := TempObjectRect;
  end;
end;

procedure TspSkinMainMenuItem.MouseEnter;
begin
  if SearchDown
  then
    begin
      Active := True;
      FMouseIn := True;
      if EnableMorphing then MorphKf := 1;
      SetDown(True);
    end
  else
    begin
      SearchActive;
      FMouseIn := True;
      Active := True;
      ReDraw;
    end;
end;

procedure TspSkinMainMenuItem.MouseLeave;
begin
  Active := False;
  FMouseIn := False;
  if EnableMorphing and FDown then MorphKf := 0;
  Redraw;
  Parent.MouseLeaveEvent(IDName);
end;

procedure TspSkinMainMenuItem.TrackMenu;
var
  R: TRect;
  Menu: TMenu;
  P: TPoint;
begin
  Parent.SkinMenuOpen;
  R := ObjectRect;
  if Parent.FForm.FormStyle = fsMDIChild
  then
    begin
      if Parent.FSkinSupport
      then
        P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
      else
        P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
      P := Parent.FForm.ClientToScreen(P);
      OffsetRect(R, P.X, P.Y);
    end
  else
    OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
  Menu := MenuItem.GetParentMenu;
  if (Menu is TspSkinMainMenu) and (TspSkinMainMenu(Menu).SkinData <> nil)
  then
    Parent.SkinMenu.Popup(nil, TspSkinMainMenu(Menu).SkinData, 0, R, MenuItem,
      TspSkinMainMenu(Menu).SkinData.MainMenuPopupUp)
  else
    if Parent.MenusSkinData = nil
    then
      Parent.SkinMenu.Popup(nil, Parent.SkinData, 0, R, MenuItem, Parent.FSD.MainMenuPopupUp)
    else
      Parent.SkinMenu.Popup(nil, Parent.MenusSkinData, 0, R, MenuItem, Parent.FSD.MainMenuPopupUp);
end;

procedure TspSkinMainMenuItem.MouseDown;
var
  Menu: TMenu;
begin
  if not Enabled then Exit;
  if Button = mbLeft
  then
    begin
      if MenuItem.Count <> 0 then SetDown(True)
      else
        begin
          SetDown(False);
          Parent.InMenu := False;
          Menu := MenuItem.GetParentMenu;
          Menu.DispatchCommand(MenuItem.Command);
        end;
     end;
  inherited MouseDown(X, Y, Button);
end;

//==============TspSkinFrameObject===============//
constructor TspSkinFrameObject.Create;
begin
  inherited;
  FFrame := 1;
end;

procedure TspSkinFrameObject.SetFrame(Value: Integer);
begin
  if Value < CountFrames then FFrame := Value;
  Parent.DrawSkinObject(Self);
end;

procedure TspSkinFrameObject.Draw;
var
  R: TRect;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  case FramesPlacement of
    fpHorizontal:
      R := Rect(ActiveSkinRect.Left + (FFrame - 1) * FrameW, ActiveSkinRect.Top,
                ActiveSkinRect.Left + FFrame * FrameW,
                ActiveSkinRect.Top + FrameH);
    fpVertical:
      R := Rect(ActiveSkinRect.Left, ActiveSkinRect.Top + (FFrame - 1) * FrameH,
                ActiveSkinRect.Left + FrameW,
                ActiveSkinRect.Top + FFrame * FrameH);
  end;
  Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, R);
end;

//=================TspSkinFrameGaugeObject=================//
constructor TspSkinFrameGaugeObject.Create;
begin
  inherited;
  FValue := 0;
  with TspDataSkinFrameGaugeObject(AData) do
  begin
    Self.MinValue := MinValue;
    Self.MaxValue := MaxValue;
    Self.CountFrames := CountFrames;
    Self.FramesPlacement := FramesPlacement;
  end;
  if CountFrames > 0 then
  case FramesPlacement of
    fpHorizontal:
      begin
        FrameW := RectWidth(ActiveSkinRect) div CountFrames;
        FrameH := RectHeight(ActiveSkinRect);
      end;
    fpVertical:
      begin
        FrameH := RectHeight(ActiveSkinRect) div CountFrames;
        FrameW := RectWidth(ActiveSkinRect);
      end;
  end;
end;

procedure TspSkinFrameGaugeObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  Parent.MouseEnterEvent(IDName);
end;

procedure TspSkinFrameGaugeObject.MouseLeave;
begin
  FMouseIn := False;
  Active := False;
  Parent.MouseLeaveEvent(IDName);
end;

procedure TspSkinFrameGaugeObject.SimplySetValue;
begin
  if (FValue = AValue) or (AValue > MaxValue) or
     (AValue < MinValue) then Exit;
  FValue := AValue;
end;

procedure TspSkinFrameGaugeObject.SetValue;
begin
  if (FValue = AValue) or (AValue > MaxValue) or
     (AValue < MinValue) then Exit;
  FValue := AValue;
  Parent.DrawSkinObject(Self);
end;

function TspSkinFrameGaugeObject.CalcFrame;
var
  FValInc: Integer;
begin
  FValInc := (MaxValue - MinValue) div (CountFrames - 1);
  if FValInc = 0
  then
    Result := 1
  else
    Result := Abs(FValue - MinValue) div FValInc + 1;
end;

procedure TspSkinFrameGaugeObject.Draw;
begin
  if CountFrames > 1 then FFrame := CalcFrame else FFrame := 1;
  inherited;
end;

//==============TspSkinFrameRegulatorObject================//
constructor TspSkinFrameRegulatorObject.Create;
begin
  inherited;
  FValue := 0;
  with TspDataSkinFrameregulatorObject(AData) do
  begin
    Self.MinValue := MinValue;
    Self.MaxValue := MaxValue;
    Self.CountFrames := CountFrames;
    Self.FramesPlacement := FramesPlacement;
    Self.Kind := Kind;
  end;
  if CountFrames > 0 then
  case FramesPlacement of
    fpHorizontal:
      begin
        FrameW := RectWidth(ActiveSkinRect) div CountFrames;
        FrameH := RectHeight(ActiveSkinRect);
      end;
    fpVertical:
      begin
        FrameH := RectHeight(ActiveSkinRect) div CountFrames;
        FrameW := RectWidth(ActiveSkinRect);
      end;
  end;
  if FValue < MinValue then FValue := MinValue;
  if FValue > MaxValue then FValue := MaxValue;
end;

function TspSkinFrameRegulatorObject.GetRoundValue(X, Y: Integer): Integer;
var
  CX, CY: Integer;
  X1, Y1: Integer;
  midAngle: Integer;
  sinMidAngle, MidAngle1: Double;
begin

  if X < 0 then X := 0;
  if X > RectWidth(ObjectRect) then X := RectWidth(ObjectRect);
  if Y < 0 then Y := 0;
  if Y > RectHeight(ObjectRect) then Y := RectHeight(ObjectRect);

  CX := RectWidth(ObjectRect) div 2;
  CY := RectHeight(ObjectRect) div 2;
  X1 := CX - X;
  Y1 := CY - Y;

  if (X <= CX) and (Y < CY) then midAngle := 90;
  if (X < CX) and (Y >= CY) then midAngle := 180;
  If (X >= CX) and (Y > CY) then midAngle := 270;
  If (X > CX) and (Y <= CY) Then midAngle := 0;

  if (midAngle = 0) or (midAngle = 180)
  then sinMidAngle := Abs(Trunc(Y1))/(Sqrt(Sqr(X1)+Sqr(Y1)));
  if (midAngle = 90) or (midAngle = 270)
  then sinMidAngle:= Abs(Trunc(X1))/(Sqrt(Sqr(X1)+Sqr(Y1)));
  midAngle1 := ArcTan(sinMidAngle/Sqrt(1-sqr(sinMidAngle)));
  midAngle1 := (midAngle1/Pi) * 180;
  midAngle := Trunc(midAngle + midAngle1);
  Result := 270 - MidAngle;
  if Result < 0 then Result := Result + 360;
end;

procedure TspSkinFrameRegulatorObject.CalcRoundValue;
var
  Offset: Integer;
  Plus: Boolean;
  FW: Integer;
  FC: Integer;
  OffsetCount: Integer;
begin
  FC := CountFrames;
  if FC = 0 then FC := 1;

  FPixInc := 360 div FC;
  FValInc := (MaxValue - MinValue) div FC;

  if FPixInc = 0 then FPixInc := 1;
  if FValInc = 0 then FValInc := 1;

  if Abs(CurV - OldCurV) > 300
  then
    begin
      StartV := CurV;
      Offset := FPixInc;
      Plus := CurV < OldCurV
    end
  else
    begin
      Plus := CurV >= StartV;
      if Plus
      then Offset := CurV - StartV
      else Offset := StartV - CurV;
    end;

  if Offset >= FPixInc
  then
    begin
      StartV := CurV;
      if Plus
      then TempValue := TempValue + FValInc
      else TempValue := TempValue - FValInc;
      if TempValue < MinValue then TempValue := MinValue;
      if TempValue > MaxValue then TempValue := MaxValue;
      Value := TempValue;
    end;

end;

procedure TspSkinFrameRegulatorObject.CalcValue;
var
  Offset: Integer;
  Plus: Boolean;
  FW: Integer;
begin
  FW := 0;
  case Kind of
    rkRound: if FrameW > FrameH then FW := FrameH else FW := FrameW;
    rkVertical: FW := FrameH;
    rkHorizontal: FW := FrameW;
  end;

  FPixInc := FW div (CountFrames - 1);
  FValInc := (MaxValue - MinValue) div (CountFrames - 1);

  if FPixInc = 0 then FPixInc := 1;
  if FValInc = 0 then FValInc := 1;

  Plus := CurV >= StartV;

  if Plus
  then Offset := CurV - StartV
  else Offset := StartV - CurV;

  if Offset >= FPixInc
  then
    begin
      StartV := CurV;
      if Plus
      then TempValue := TempValue + FValInc
      else TempValue := TempValue - FValInc;

      if TempValue < MinValue then TempValue := MinValue;
      if TempValue > MaxValue then TempValue := MaxValue;

      Value := TempValue;
    end;
end;

procedure TspSkinFrameRegulatorObject.SetValue;
begin
  if (FValue = AValue) or (AValue > MaxValue) or
     (AValue < MinValue) then Exit;
  FValue := AValue;
  Parent.DrawSkinObject(Self);
  Parent.FrameRegulatorChangeValueEvent(IDName, FValue);
end;

procedure TspSkinFrameRegulatorObject.SimplySetValue;
begin
  if (FValue = AValue) or (AValue > MaxValue) or
     (AValue < MinValue) then Exit;
  FValue := AValue;
  Parent.FrameRegulatorChangeValueEvent(IDName, FValue);
end;

function TspSkinFrameRegulatorObject.CalcFrame;
var
  FValInc: Integer;
begin
  FValInc := (MaxValue - MinValue) div (CountFrames - 1);
  if FValInc = 0
  then
    Result := 1
  else
    Result := Abs(FValue - MinValue) div FValInc + 1;
end;

procedure TspSkinFrameRegulatorObject.Draw;
begin
  if CountFrames > 1 then FFrame := CalcFrame else FFrame := 1;
  inherited;
end;

procedure TspSkinFrameRegulatorObject.MouseDown(X, Y: Integer; Button: TMouseButton);
var
  X1, Y1: Integer;
begin
  X1 := X - ObjectRect.Left;
  Y1 := Y - ObjectRect.Top;
  FDown := True;
  TempValue := FValue;
  case Kind of
    rkRound:
      begin
        StartV := GetRoundValue(X1, Y1);
        OldCurV := StartV;
      end;
    rkVertical: StartV := -Y1;
    rkHorizontal: StartV := X1;
  end;
  inherited MouseDown(X, Y, Button);
end;

procedure TspSkinFrameRegulatorObject.MouseUp(X, Y: Integer; Button: TMouseButton);
begin
  FDown := False;
  inherited MouseUp(X, Y, Button);
end;

procedure TspSkinFrameRegulatorObject.MouseMove(X, Y: Integer);
var
  X1, Y1: Integer;
begin
  X1 := X - ObjectRect.Left;
  Y1 := Y - ObjectRect.Top;
  if FDown
  then
    begin
      case Kind of
        rkRound: CurV := GetRoundValue(X1, Y1);
        rkVertical: CurV := -Y1;
        rkHorizontal: CurV := X1;
      end;
      if Kind = rkRound then CalcRoundValue else CalcValue;
      OldCurV := CurV;
    end;
  inherited MouseMove(X, Y);
end;

//==============TspSkinAnimateObject==================//
constructor TspSkinAnimateObject.Create;
begin
  inherited Create(AParent, AData);
  FDown := False;
  FMenuTracking := False;
  Increment := True;
  FFrame := 1;
  FInc := AnimateTimerInterval;
  TimerInterval := TspDataSkinAnimate(AData).TimerInterval;
  if TimerInterval < FInc then TimerInterval := FInc;
  with  TspDataSkinAnimate(AData) do
  begin
    Self.CountFrames := CountFrames;
    Self.Cycle := Cycle;
    Self.ButtonStyle := ButtonStyle;
    Self.Command := Command;
    Self.DownSkinRect := DownSkinRect;
    Self.RestoreRect := RestoreRect;
    Self.RestoreActiveRect := RestoreActiveRect;
    Self.RestoreInActiveRect := RestoreInActiveRect;
    Self.RestoreDownRect := RestoreDownRect;
    Self.RestoreHint := RestoreHint;
    Self.FTempHint := Hint;
  end;
  FPopupUp := False;
  MenuItem := nil;
end;

procedure TspSkinAnimateObject.HideLayer;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and
    Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    if MenuItem = nil
    then
      Parent.FLayerManager.Hide
    else
      Parent.FMenuLayerManager.Hide;
end;

procedure TspSkinAnimateObject.ShowLayer;
var
  B, BM: TBitmap;
  X1, Y1: Integer;
  R: TRect;
  P: TPoint;
begin
  if (Parent.SkinData = nil) or (Parent.SkinData.Empty) then Exit;
  if (GlowLayerPictureIndex <> -1) and CheckW2KWXP and Parent.SkinData.ShowCaptionButtonGlowFrames
  then
    begin
      B := TBitMap(SD.FActivePictures.Items[GlowLayerPictureIndex]);
      BM := TBitMap(SD.FActivePictures.Items[GlowLayerMaskPictureIndex]);
      R := ObjectRect;
      if Parent.FForm.FormStyle = fsMDIChild
      then
        begin
          if Parent.FSkinSupport
          then
            P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
          else
            P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
           P := Parent.FForm.ClientToScreen(P);
           OffsetRect(R, P.X, P.Y);
         end
       else
         OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
      X1 := R.Left - GlowLayerOffsetX;
      Y1 := R.Top - GlowLayerOffsetY;
      if MenuItem = nil
      then
        Parent.FLayerManager.Show(X1, Y1, B, BM, GlowLayerAlphaBlendValue)
      else
        Parent.FMenuLayerManager.Show(X1, Y1, B, BM, GlowLayerAlphaBlendValue);
    end;
end;


procedure TspSkinAnimateObject.DoMinToTray;
begin
  Parent.MinimizeToTray;
end;

procedure TspSkinAnimateObject.DoMax;
begin
  if Parent.SupportNCArea
  then
    begin
     if Parent.WindowState = wsMaximized
     then Parent.WindowState := wsNormal
     else Parent.WindowState := wsMaximized;
    end
  else
    if Parent.WindowState <> wsMaximized
    then Parent.WindowState := wsMaximized
    else Parent.WindowState := wsNormal;
end;

procedure TspSkinAnimateObject.DoMin;
begin
  if Parent.SupportNCArea
  then
    begin
      if Parent.WindowState = wsMinimized
      then Parent.WindowState := wsNormal
      else Parent.WindowState := wsMinimized;
    end
  else
    Parent.WindowState := wsMinimized;
end;

procedure TspSkinAnimateObject.DoClose;
begin
  Parent.FForm.Close;
end;

procedure TspSkinAnimateObject.DoRollUp;
begin
  Parent.RollUpState := not Parent.RollUpState;
end;

procedure TspSkinAnimateObject.DoCommand;
begin
  case Command of
    cmMinimizeToTray:
      begin
        Parent.TestActive(-1, -1, False);
        DoMinToTray;
      end;
    cmClose:
     begin
       Parent.TestActive(-1,-1, False);
       DoClose;
     end;
    cmMinimize:
      begin
        Parent.TestActive(-1, -1, False);
        if not Parent.AlwaysMinimizeToTray
        then
          DoMin
        else
          Parent.MinimizeToTray;  
      end;
    cmMaximize:
      begin
        Parent.TestActive(-1, -1, False);
        DoMax;
      end;
    cmSysMenu:
      begin
        MenuItem := Parent.GetSystemMenu;
        TrackMenu;
      end;
    cmDefault:
      if MenuItem <> nil then TrackMenu;
    cmRollUp: DoRollUp;  
  end;
end;

procedure TspSkinAnimateObject.TrackMenu;
var
  R: TRect;
  Menu: TMenu;
  P: TPoint;
begin
  if MenuItem = nil then Exit;
  if MenuItem.Count = 0 then Exit;
  Parent.FMenuTrackObject := Self;
  R := ObjectRect;
  if Parent.FForm.FormStyle = fsMDIChild
  then
    begin
      if Parent.FSkinSupport
      then
        P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
      else
        P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
      P := Parent.FForm.ClientToScreen(P);
      OffsetRect(R, P.X, P.Y);
    end
  else
    OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
  FMenuTracking := True;
  Menu := MenuItem.GetParentMenu;
  if Parent.FLayerManager.IsVisible then Parent.FLayerManager.Hide;
  if Parent.FMenuLayerManager.IsVisible then Parent.FMenuLayerManager.Hide;
  if FMouseIn then ShowLayer;
  if Menu is TspSkinPopupMenu
  then
    TspSkinPopupMenu(Menu).PopupFromRect(R, FPopupUp)
  else
    begin
      Parent.SkinMenuOpen;
      if Parent.MenusSkinData = nil
      then
        Parent.SkinMenu.Popup(nil, Parent.SkinData, 0, R, MenuItem, FPopupUp)
      else
        Parent.SkinMenu.Popup(nil, Parent.MenusSkinData, 0, R, MenuItem, FPopupUp);
    end;
  Parent.FMenuTrackObject := nil;  
end;

procedure TspSkinAnimateObject.DblCLick;
begin
  if Command = cmSysMenu then DoClose;
end;

procedure TspSkinAnimateObject.MouseDown(X, Y: Integer; Button: TMouseButton);
begin
  inherited;
  if not IsNullRect(DownSkinRect) and (Button = mbLeft)
  then
    begin
      FFrame := CountFrames;
      FDown := True;
      Parent.DrawSkinObject(Self);
    end;
  if (Command = cmsysmenu) and FMouseIn and ButtonStyle and (Button = mbLeft)
  then DoCommand;
end;

procedure TspSkinAnimateObject.MouseUp;
begin
  inherited;
  if FMenuTracking then Exit;
  if not IsNullRect(DownSkinRect) and (Button = mbLeft)
  then
    begin
      FDown := False;
      Parent.DrawSkinObject(Self);
      if not Parent.AnimateTimer.Enabled
      then
        Parent.AnimateTimer.Enabled := True;
    end;
  if (Command <> cmsysmenu) and FMouseIn and ButtonStyle and (Button = mbLeft)
  then DoCommand;
end;

procedure TspSkinAnimateObject.SetFrame;
begin
  if Increment
  then
    begin
      if Value > CountFrames then FFrame := 1 else FFrame := Value;
    end
  else
    begin
      if Value < 1 then FFrame := CountFrames else FFrame := Value;
    end;
  Parent.DrawSkinObject(Self);
end;

procedure TspSkinAnimateObject.Start;
begin
  FInc := AnimateTimerInterval;
  FFrame := 1;
  Active := True;
  if not Parent.AnimateTimer.Enabled
  then
    Parent.AnimateTimer.Enabled := True;
end;

procedure TspSkinAnimateObject.Stop;
begin
  Frame := 1;
  Active := False;
  FInc := AnimateTimerInterval;
end;

procedure TspSkinAnimateObject.ChangeFrame;
begin
  if FInc >= TimerInterval
  then
    begin
      if Increment
      then
        begin
          Frame := Frame + 1;
          if not Cycle and (FFrame = CountFrames) then Active := False;
        end
      else
        begin
          Frame := Frame - 1;
          if FFrame = 1 then Active := False;
        end;
      FInc := AnimateTimerInterval;
    end
  else
    Inc(FInc, AnimateTimerInterval);
end;

procedure TspSkinAnimateObject.MouseEnter;
begin
  //
  if (Command <> cmDefault)
  then
  if Parent.RollUpState and (RestoreHint <> '') and (Command = cmRollUp)
  then
    Hint := RestoreHint
  else
  if (Parent.WindowState = wsMinimized) and (RestoreHint <> '') and (Command = cmMinimize)
  then
    Hint := RestoreHint
  else
  if (Parent.WindowState = wsMaximized) and (RestoreHint <> '') and (Command = cmMaximize)
  then
    Hint := RestoreHint
  else
    Hint := FTempHint;
  //
  FMouseIn := True;
  if FMenuTracking then Exit;
  if ButtonStyle
  then
    begin
      Active := True;
      Increment := True;
      if (FDown and FMouseIn) and not IsNullRect(DownSkinRect)
      then
        begin
          Parent.DrawSkinObject(Self);
        end
      else
      if not Parent.AnimateTimer.Enabled
      then
        Parent.AnimateTimer.Enabled := True;
    end;
  Parent.MouseEnterEvent(IDName);
  ShowLayer;
end;

procedure TspSkinAnimateObject.MouseLeave;
begin
  if not FMouseIn then Exit;
  FMouseIn := False;
  if FMenuTracking then Exit;
  if ButtonStyle
  then
    begin
      Active := True;
      Increment := False;
      if FDown and not IsNullRect(DownSkinRect)
      then
        begin
          Parent.DrawSkinObject(Self);
        end
      else
      if not Parent.AnimateTimer.Enabled
      then
        Parent.AnimateTimer.Enabled := True;
    end;
  Parent.MouseLeaveEvent(IDName);
  HideLayer;
end;

procedure TspSkinAnimateObject.Draw;
var
  FW, FH: Integer;
  FRestoreMode: Boolean;
  SRect, ARect, DRect, IARect: TRect;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  FRestoreMode := False;

  SRect := SkinRect;
  ARect := ActiveSkinRect;
  DRect := DownSkinRect;
  IARect := InActiveSkinRect;

  if not IsNullRect(RestoreRect)
  then
    begin
      case Command of
        cmMaximize:
          if Parent.WindowState = wsMaximized
          then FRestoreMode := True;
        cmMinimize:
          if Parent.WindowState = wsMinimized
         then FRestoreMode := True;
        cmRollUp:
          if Parent.RollUpState
          then FRestoreMode := True;
      end;
      if FRestoreMode
      then
        begin
          SRect := RestoreRect;
          ARect := RestoreActiveRect;
          DRect := RestoreDownRect;
          IARect := RestoreInActiveRect;
        end;
    end;


  FW := RectWidth(SRect);
  FH := RectHeight(SRect);

  if FMenuTracking
  then
    begin
      if not IsNullRect(DRect)
      then
        Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, DRect)
      else
        begin
          FFrame := Self.CountFrames;
          Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas,
           Rect(ARect.Left + (FFrame - 1) * FW, ARect.Top,
                ARect.Left + FFrame * FW,
                ARect.Top + FH));
        end;
    end
  else
  if not Parent.GetFormActive and not IsNullRect(IARect)
  then
    begin
      Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, IARect);
    end
  else
  if (FDown and FMouseIn) and not IsNullRect(DRect)
  then
    begin
      Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas, DRect);
    end
  else
  Cnvs.CopyRect(ObjectRect, ActivePicture.Canvas,
           Rect(ARect.Left + (FFrame - 1) * FW, ARect.Top,
                ARect.Left + FFrame * FW,
                ARect.Top + FH));
end;

//==============TspSkinGaugeObject====================//

constructor TspSkinGaugeObject.Create;
begin
  inherited Create(AParent, AData);
  with TspDataSkinGauge(AData) do
  begin
    Self.MinValue := MinValue;
    Self.MaxValue := MaxValue;
    Self.Kind := Kind;
  end;
  FValue := MinValue;
  FProgressPos := CalcProgressPos;
  FOldProgressPos := FProgressPos;
end;

function TspSkinGaugeObject.CalcProgressPos;
var
  kf: Double;
begin
  kf := (FValue - MinValue) / (MaxValue - MinValue);
  case Kind of
    gkHorizontal:
      Result := Point(Round(RectWidth(SkinRect) * kf), 0);
    gkVertical:
      Result := Point(0, Round(RectHeight(SkinRect) * (1 - kf)));
  end;
end;

procedure TspSkinGaugeObject.SimplySetValue;
begin
  if FValue <> AValue
  then
    begin
      FValue := AValue;
      if FValue < MinValue then FValue := MinValue;
      if FValue > MaxValue then FValue := MaxValue;
      FOldProgressPos := FProgressPos;
      FProgressPos := CalcProgressPos;
    end;
end;

procedure TspSkinGaugeObject.SetValue;
begin
  SimplySetValue(AValue);
  Parent.DrawSkinObject(Self);
end;

procedure TspSkinGaugeObject.Draw;
var
  Buffer: TbitMap;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  if (FValue = MinValue) and not UpDate
  then
    Exit
  else
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(ObjectRect);
      Buffer.Height := RectHeight(ObjectRect);
      case Kind of
        gkHorizontal:
          with Buffer do
          begin
            Canvas.CopyRect(Rect(FProgressPos.X, 0, Width, Height),
                            Picture.Canvas,
                            Rect(SkinRect.Left + FProgressPos.X,
                                 SkinRect.Top,
                                 SkinRect.Right, SkinRect.Bottom));

            Canvas.CopyRect(Rect(0, 0, FProgressPos.X, Height),
                            ActivePicture.Canvas,
                            Rect(ActiveSkinRect.Left, ActiveSkinRect.Top,
                                 ActiveSkinRect.Left + FProgressPos.X,
                                 ActiveSkinRect.Bottom));
          end;
        gkVertical:
          with Buffer do
          begin
            Canvas.CopyRect(Rect(0, 0, Width, FProgressPos.Y),
                            Picture.Canvas,
                            Rect(SkinRect.Left, SkinRect.Top,
                            SkinRect.Right,
                            SkinRect.Top + FProgressPos.Y));

            Canvas.CopyRect(Rect(0, FProgressPos.Y, Width, Height),
                            ActivePicture.Canvas,
                            Rect(ActiveSkinRect.Left,
                                 ActiveSkinRect.Top + FProgressPos.Y,
                                 ActiveSkinRect.Right, ActiveSkinRect.Bottom));
          end;
        end;
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
      Buffer.Free;
    end;
end;

procedure TspSkinGaugeObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  Parent.MouseEnterEvent(IDName);
end;

procedure TspSkinGaugeObject.MouseLeave;
begin
  FMouseIn := False;
  Active := False;
  Parent.MouseLeaveEvent(IDName);
end;

//==============TspSkinBitLabelObject=================//
constructor TspSkinBitLabelObject.Create;
begin
  inherited Create(AParent, AData);
  with TspDataSkinBitLabel(AData) do
  begin
    FTextValue := TextValue;
    Self.SymbolWidth := SymbolWidth;
    Self.SymbolHeight := SymbolHeight;
    Self.Symbols := Symbols;
    Self.Transparent := Transparent;
    Self.TransparentColor := TransparentColor;
  end;
end;

procedure TspSkinBitLabelObject.Draw;
var
  Buffer, Buffer2: TBitMap;
  SymbolX, SymbolY: Integer;

procedure GetSymbolPos(Ch: Char);
var
  i, j: Integer;
begin
  SymbolX := -1;
  SymbolY := -1;
  for i := 0 to Symbols.Count - 1 do
  begin
    j := Pos(Ch, Symbols[i]);
    if j <> 0
    then
      begin
        SymbolX := j - 1;
        SymbolY := i;
        Exit;
      end;
  end;
end;

var
  i: Integer;
  XO: Integer;
  R: TRect;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(SkinRect);
  Buffer.Height := RectHeight(SkinRect);
  with Buffer.Canvas do
  begin
    CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
             Picture.Canvas, SkinRect);

    for i := 1 to Length(FTextValue) do
    begin
      if (i * SymbolWidth) > Buffer.Width
      then XO := i * SymbolWidth - Buffer.Width
      else XO := 0;
      GetSymbolPos(FTextValue[i]);
      if SymbolX <> -1
      then
        begin
          Buffer.Canvas.CopyRect(
            Rect((i - 1) * SymbolWidth, 0, i * SymbolWidth - XO, SymbolHeight),
            ActivePicture.Canvas,
            Rect(ActiveSkinRect.Left + SymbolX * SymbolWidth,
                 ActiveSkinRect.Top + SymbolY * SymbolHeight,
                 ActiveSkinRect.Left + (SymbolX + 1) * SymbolWidth - XO,
                 ActiveSkinRect.Top + (SymbolY + 1) * SymbolHeight));
          if XO > 0 then Break;       
        end;       
    end;
  end;
  if Transparent
  then
    begin
      Buffer.Transparent := True;
      Buffer.TransparentMode := tmFixed;
      Buffer.TransparentColor := TransparentColor;
      //
      Buffer2 := TBitMap.Create;
      Buffer2.Width := RectWidth(SkinRect);
      Buffer2.Height := RectHeight(SkinRect);
      Buffer2.Canvas.CopyRect(Rect(0, 0, Buffer2.Width, Buffer2.Height),
        Parent.SkinData.FPicture.Canvas, SkinRect);
      //
      Buffer2.Canvas.Draw(0, 0, Buffer);
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer2);
      Buffer2.Free;
    end
  else
    Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinBitLabelObject.SetTextValue;
begin
  FTextValue := AValue;
  if AUpDate then Parent.DrawSkinObject(Self);
end;

//==============TspSkinLabelObject ===================//
constructor TspSkinLabelObject.Create;
begin
  inherited Create(AParent, AData);
  with TspDataSkinLabel(AData) do
  begin
    Self.FTextValue := TextValue;
    Self.FontName := FontName;
    Self.FontStyle := FontStyle;
    Self.FontHeight := FontHeight;
    Self.FontColor := FontColor;
    Self.ActiveFontColor := ActiveFontColor;
    Self.Alignment := Alignment;
  end;
end;

procedure TspSkinLabelObject.SetTextValue;
begin
  FTextValue := AValue;
  if AUpDate then Parent.DrawSkinObject(Self);
end;

procedure TspSkinLabelObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  if (not IsNullRect(ActiveSkinRect)) or (ActiveFontColor <> FontColor)
  then
    ReDraw;
  Parent.MouseEnterEvent(IDName);
end;

procedure TspSkinLabelObject.MouseLeave;
begin
  FMouseIn := False;
  Active := False;
  if not IsNullRect(ActiveSkinRect) or (ActiveFontColor <> FontColor)
  then
    ReDraw;
  Parent.MouseLeaveEvent(IDName);
end;

procedure TspSkinLabelObject.Draw;
var
  PBuffer, APBuffer: TspEffectBmp;
  Buffer, ABuffer: TBitMap;
  ASR, SR: TRect;

procedure DrawLabelText(R: TRect; Cnvs: TCanvas; AActive: Boolean);
var
  X, Y: Integer;
begin
  X := R.Left;
  case Alignment of
    taRightJustify: X := R.Right - Cnvs.TextWidth(FTextValue);
    taCenter: X := R.Left + (R.Right - R.Left) div 2 - Cnvs.TextWidth(FTextValue) div 2;
  end;
  with Cnvs do
  begin
    Y := R.Top + (R.Bottom - R.Top) div 2 - TextHeight(FTextValue) div 2;
    Brush.Style := bsClear;
    Font.Name := FontName;
    Font.Style := FontStyle;
    Font.Height := FontHeight;
    if AActive
    then
      Font.Color := ActiveFontColor
    else
      Font.Color := FontColor;
    TextRect(R, X, Y, FTextValue);
  end;
end;

procedure CreateLabelImage(B: TBitMap; AActive: Boolean; ATextActive: Boolean);
begin
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  with B.Canvas do
  begin
    if AActive
    then
      CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, ActiveSkinRect)
    else
      CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, SkinRect);
  end;
  DrawLabelText(Rect(0, 0, B.Width, B.Height), B.Canvas, ATextActive);
end;

begin
  ASR := ActiveSkinRect;
  SR := SkinRect;

  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  if not EnableMorphing or
     ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
  then
    begin
      if Active// and not IsNullRect(ASR)
      then
        begin
          if not IsNullRect(ASR)
          then
            begin
              Buffer := TBitMap.Create;
              CreateLabelImage(Buffer, True, True);
              Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
              Buffer.Free;
            end
          else
            if (ActiveFontColor <> FontColor)
            then
              begin
                Buffer := TBitMap.Create;
                CreateLabelImage(Buffer, False, True);
                Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
                Buffer.Free;
              end
         end
      else
        begin
          Buffer := TBitMap.Create;
          CreateLabelImage(Buffer, False, False);
          Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
          Buffer.Free;
        end;
    end
  else
    begin
      Buffer := TBitMap.Create;
      ABuffer := TBitMap.Create;
      CreateLabelImage(Buffer, False, False);
      if isNullRect(ActiveSkinRect)
      then
        CreateLabelImage(ABuffer, False, True)
      else
        CreateLabelImage(ABuffer, True, True);
      PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
      APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
      case MorphKind of
        mkDefault: PBuffer.Morph(APBuffer, MorphKf);
        mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
        mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
        mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
        mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
        mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
        mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
      end;
      PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
      PBuffer.Free;
      APBuffer.Free;
      Buffer.Free;
      ABuffer.Free;
    end;
end;

//============= TspSkinCaptionObject ==================//

constructor TspSkinCaptionObject.Create;
begin
  inherited Create(AParent, AData);
  FTextValue := '';
  with TspDataSkinCaption(AData) do
  begin
    Self.FontName := FontName;
    Self.FontStyle := FontStyle;
    Self.FontHeight := FontHeight;
    Self.FontColor := FontColor;
    Self.ActiveFontColor := ActiveFontColor;
    Self.Alignment := Alignment;
    Self.TextRct := TextRct;
    Self.DefaultCaption := DefaultCaption;
    Self.Shadow := Shadow;
    Self.ShadowColor := ShadowColor;
    Self.ActiveShadowColor := ActiveShadowColor;
    Self.FrameRect := FrameRect;
    Self.ActiveFrameRect := ActiveFrameRect;
    Self.FrameLeftOffset := FrameLeftOffset; 
    Self.FrameRightOffset := FrameRightOffset;
    Self.FrameTextRect := FrameTextRect;
    Self.Light := Light;
    Self.LightColor := LightColor;
    Self.ActiveLightColor := ActiveLightColor;
    Self.StretchEffect := StretchEffect;
    Self.AnimateSkinRect := AnimateSkinRect;
    Self.FrameCount := FrameCount;
    Self.AnimateInterval := AnimateInterval;
    Self.InActiveAnimation := InActiveAnimation;
    Self.FullFrame := FullFrame;
    //
    Self.VistaGlowEffect := VistaGlowEffect;
    Self.VistaGlowInActiveEffect := VistaGlowInActiveEffect;
    Self.GlowEffect := GlowEffect;
    Self.GlowInActiveEffect := GlowInActiveEffect;
    Self.GlowSize := GlowSize;
    Self.GlowColor := GlowColor;
    Self.GlowActiveColor := GlowActiveColor;
    Self.GlowOffset := GlowOffset;
    //
    Self.ReflectionEffect := ReflectionEffect;
    Self.ReflectionColor := ReflectionColor;
    Self.ReflectionActiveColor := ReflectionActiveColor;
    Self.ReflectionOffset := ReflectionOffset;
    //
    Self.DividerRect := DividerRect;
    Self.InActiveDividerRect := InActiveDividerRect;
    Self.DividerTransparent := DividerTransparent;
    Self.DividerTransparentColor := DividerTransparentColor;
    //
    Self.QuickButtonAlphaMaskPictureIndex := QuickButtonAlphaMaskPictureIndex;
  end;
  ActiveQuickButton := -1;
  OldActiveQuickButton := -1;
  MouseCaptureQuickButton := -1;
  PopupMenuQuickButton := -1;
  ActiveTab := -1;
  OldActiveTab := -1;
end;

procedure TspSkinCaptionObject.TrackMenu(APopupRect: TRect; APopupMenu: TspSkinPopupMenu);
var
  R: TRect;
  P: TPoint;
begin
  if Parent.FLayerManager.IsVisible then Parent.FLayerManager.Hide;
  if Parent.FMenuLayerManager.IsVisible then Parent.FMenuLayerManager.Hide;
  R := APopupRect;
  if Parent.FForm.FormStyle = fsMDIChild
  then
    begin
      if Parent.FSkinSupport
      then
        P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
      else
        P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
      P := Parent.FForm.ClientToScreen(P);
      OffsetRect(R, P.X, P.Y);
    end
  else
    begin
      if Parent.CanShowBorderLayer and Parent.FBorderLayer.FVisible and
              Parent.FBorderLayer.FData.FullBorder and
              (Parent.FBorderLayer.TopBorder <> nil)
      then
        begin
          OffsetRect(R,
           Parent.FBorderLayer.TopBorder.Left,
           Parent.FBorderLayer.TopBorder.Top);
        end
     else
      OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
    end;

  APopupMenu.PopupFromRect(R, False);

end;

procedure TspSkinCaptionObject.TestActive;
var
  i: Integer;
  B: Boolean;
  CanDraw: Boolean;
begin
  if Parent.CaptionTabs.Count <> 0
  then
    begin
      OldActiveTab := ActiveTab;
      i := -1;
      B := False;
      repeat
        Inc(i);
        with Parent.CaptionTabs[i] do
        begin
          if Visible then B := PtInRect(ItemRect, Point(X, Y));
        end;
      until B or (i = Parent.CaptionTabs.Count - 1);
      if B then ActiveTab := i else ActiveTab := -1;
      CanDraw := False;
      for i := 0 to Parent.CaptionTabs.Count - 1 do
      begin
       if i = ActiveTab
       then
         begin
          if not Parent.CaptionTabs[i].Active then CanDraw := True;
          Parent.CaptionTabs[i].Active := True;
         end
       else
        begin
          if Parent.CaptionTabs[i].Active
          then  CanDraw := True;
          Parent.CaptionTabs[i].Active := False;
        end;
      end;
     if (OldActiveTab <> ActiveTab) or CanDraw
     then
       begin
         UpdateNCForm;
       end;
    end;
  //
  if Parent.QuickButtons.Count = 0 then Exit;
  OldActiveQuickButton := ActiveQuickButton;
  i := -1;
  B := False;
  repeat
    Inc(i);
    with Parent.QuickButtons[i] do
    begin
      if Enabled and Visible then B := PtInRect(ItemRect, Point(X, Y));
    end;
  until B or (i = Parent.QuickButtons.Count - 1);
  if B then ActiveQuickButton := i else ActiveQuickButton := -1;
  CanDraw := False;
  for i := 0 to Parent.QuickButtons.Count - 1 do
  if i <> PopupMenuQuickButton then
  begin
    if i = ActiveQuickButton
    then
      begin
        if not Parent.QuickButtons[i].Active then CanDraw := True;
        Parent.QuickButtons[i].Active := True;
      end
    else
      begin
        if Parent.QuickButtons[i].Active
        then  CanDraw := True;
        Parent.QuickButtons[i].Active := False;
      end;  
  end;
  if (OldActiveQuickButton <> ActiveQuickButton) or CanDraw
  then
    begin
      UpdateNCForm;
    end;
  if (Parent.FSkinHint <> nil) and
     (OldActiveQuickButton <> ActiveQuickButton) and (ActiveQuickButton <> -1)
     and (Parent.FSkinHint <> nil) and Parent.QuickButtonsShowHint and
     (Parent.QuickButtons[ActiveQuickButton].Hint <> '')
  then
    Parent.FSkinHint.ActivateHint2( Parent.QuickButtons[ActiveQuickButton].Hint);
  if (Parent.FSkinHint <> nil) and CanDraw and Parent.QuickButtonsShowHint and (ActiveQuickButton = -1)
  then
    Parent.FSkinHint.HideHint;
end;

procedure TspSkinCaptionObject.UpdateNCForm;
begin
  if Parent.CanShowBorderLayer and Parent.FBorderLayer.FData.FullBorder
  then
    Redraw
  else
    SendMessage(Parent.FForm.Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinCaptionObject.DrawTab(Cnvs: TCanvas; Index: Integer; Data: TspDataSkinCaptionTab);
var
  ItemRect: TRect;
  Buffer, SB: TspBitmap;
  R, R1, R11, R2, R22, R3, R33: TRect;
  bf: TspBlendFunction;
  C: TColor;
begin
  if not Parent.FCaptionTabs[Index].Visible then Exit;
  ItemRect := Parent.FCaptionTabs[Index].ItemRect;
  if IsNullRect(ItemRect) then Exit;
  Buffer := TspBitmap.Create;
  Buffer.SetSize(RectWidth(ItemRect), RectHeight(Data.SkinRect));
  if Index = Parent.FCaptionTabIndex
  then
    begin
      SB := Data.FAlphaDownImage;
      C := Data.DownFontColor;
    end
  else
  if Parent.FCaptionTabs[Index].Active
  then
    begin
      SB := Data.FAlphaActiveImage;
      C := Data.ActiveFontColor;
    end
  else
    begin
      SB := Data.FAlphaNormalImage;
      C := Data.FontColor;
    end;
  //
  R1 := Rect(0, 0, Data.LeftOffset, SB.Height);
  R11 := Rect(0, 0, Data.LeftOffset, Buffer.Height);
  R2 := Rect(SB.Width - Data.RightOffset, 0, SB.Width, SB.Height);
  R22 := Rect(Buffer.Width - Data.RightOffset, 0, Buffer.Width, Buffer.Height);
  R3 := Rect(Data.LeftOffset, 0, SB.Width - Data.RightOffset, SB.Height);
  R33 := Rect(Data.LeftOffset, 0, Buffer.Width - Data.RightOffset, Buffer.Height);
  with Buffer.Canvas do
  begin
    CopyRect(R11, SB.Canvas, R1);
    CopyRect(R22, SB.Canvas, R2);
    CopyRect(R33, SB.Canvas, R3);
  end;
  // draw image and text
  with Buffer.Canvas do
  begin
    Font.Name := Data.FontName;
    Font.Height := Data.FontHeight;
    Font.Color := C;
    Font.Style := Data.FontStyle;
  end;
  //
  R := Data.ClRect;
  R.Right := R.Right + RectWidth(ItemRect) - RectWidth(Data.SkinRect);
  DrawImageAndTextWithAlpha(Buffer.Canvas, R, -1, 5,
   blGlyphLeft, Parent.FCaptionTabs[Index].Caption,
     Parent.FCaptionTabs[Index].ImageIndex, Parent.CaptionTabsImageList, False, True, False, 0);
  //
  bf.BlendOp := AC_SRC_OVER;
  bf.BlendFlags := 0;
  bf.SourceConstantAlpha := 255;
  bf.AlphaFormat := AC_SRC_ALPHA;
  if spEffBmp.IsMsImg
  then
    AlphaBlendFunc(Cnvs.Handle, ItemRect.Left, ItemRect.Top,
      RectWidth(ItemRect), RectHeight(ItemRect), Buffer.DC,
      0, 0, Buffer.Width, Buffer.Height, bf);
  //
  Buffer.Free;
end;

procedure TspSkinCaptionObject.DrawTabs;
var
  Buffer: TBitmap;
  Data: TspDataSkinCaptionTab;
  FIndex: Integer;
  i, h, w, AllTabsWidth: Integer;
  R: TRect;
  Y: Integer;
  StartX, OffsetX: Integer;
begin
  if Parent.FCaptionTabs.Count = 0 then Exit;
  FIndex := Parent.FSD.GetIndex('captiontab');
  if FIndex = -1 then Exit;
  Buffer := TBitmap.Create;
  StartX := X;
  Data := TspDataSkinCaptionTab(Parent.FSD.ObjectList[FIndex]);
  if Data.TopPosition = -1
  then
    Y := BottomY - RectHeight(Data.SkinRect)
  else
    Y := TopY + Data.TopPosition;

  h := RectHeight(Data.SkinRect);
  with Buffer.Canvas do
  begin
    Font.Name := Data.FontName;
    Font.Height := Data.FontHeight;
    Font.Style := Data.FontStyle;
  end;
  // calc position of tabs
  AllTabsWidth := 0;
  for i := 0 to Parent.FCaptionTabs.Count - 1 do
    if Parent.FCaptionTabs[i].Visible then
    begin
      with Parent.FCaptionTabs[i] do
      begin
        R := Rect(0, 0, 10, 10);
        SPDrawSkinText(Buffer.Canvas, Caption, R, DT_CALCRECT);
        if Parent.CaptionTabsImageList <> nil
        then
          w := Parent.CaptionTabsImageList.Width + 5
        else
          w := 0;
        w := w + 20 + RectWidth(R);
        ItemRect := Rect(X, Y, X + w, Y + h);
        if ItemRect.Right > ObjectRect.Right
        then
          begin
            ItemRect := NullRect;
            w := 0;
          end;
        x := x + w;
        AllTabsWidth := AllTabsWidth + RectWidth(ItemRect);
      end;
   end
   else
     Parent.FCaptionTabs[i].ItemRect := NullRect;
  // correct tabs positions
  case Parent.CaptionTabPos of
    sptpRight:
      begin
        OffsetX := (ObjectRect.Right - AllTabsWidth - 5) - StartX;
        if OffsetX < 0 then OffsetX := 0;
        if OffsetX > 0 then
        for i := 0 to Parent.FCaptionTabs.Count - 1 do
          if Parent.FCaptionTabs[i].Visible then
            OffsetRect(Parent.FCaptionTabs[i].ItemRect, OffsetX, 0);
        x := RectWidth(ObjectRect) - AllTabsWidth - 5;
      end;
    sptpCenter:
      begin
        OffsetX := (ObjectRect.Right - StartX) div 2 - AllTabsWidth div 2;
        if OffsetX < 0 then OffsetX := 0;
        if OffsetX > 0 then
        for i := 0 to Parent.FCaptionTabs.Count - 1 do
          if Parent.FCaptionTabs[i].Visible then
            OffsetRect(Parent.FCaptionTabs[i].ItemRect, OffsetX, 0);
      end;
  end;
  // draw tabs
  for i := 0 to Parent.FCaptionTabs.Count - 1 do
    if Parent.FCaptionTabs[i].Visible then DrawTab(Cnvs, i, Data);
  //
  Buffer.Free;
end;

procedure TspSkinCaptionObject.DrawQuickButtonAlpha(Cnvs: TCanvas; Index: Integer);

procedure DrawQuickButtonImage(R: TRect; ADown: Boolean);
var
  CIndex: Integer;
  Picture: TBitmap;
  Buffer, Buffer2: TBitMap;
  ButtonData: TspDataSkinButtonControl;
  B, B2: TspBitmap;
  bf: TspBlendFunction;
  X1, Y1, X2, Y2: Integer;
begin
  CIndex := Parent.FSD.GetControlIndex('officequickbutton');
  if CIndex = -1 then CIndex := Parent.FSD.GetControlIndex('resizetoolbutton');
  if CIndex = -1 then Exit;
  ButtonData := TspDataSkinButtonControl(Parent.FSD.CtrlList[CIndex]);
  Picture := TBitMap(Parent.FSD.FActivePictures.Items[ButtonData.PictureIndex]);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectWidth(R);
  with ButtonData do
  begin
    if ADown
    then
      CreateStretchImage(Buffer, Picture, DownSkinRect, ClRect, True)
    else
      CreateStretchImage(Buffer, Picture, ActiveSkinRect, ClRect, True);
    if QuickButtonAlphaMaskPictureIndex <> -1
    then
      begin
        Picture := TBitMap(Parent.FSD.FActivePictures.Items[QuickButtonAlphaMaskPictureIndex]);
        Buffer2 := TBitMap.Create;
        Buffer2.Width := RectWidth(R);
        Buffer2.Height := RectWidth(R);
        X1 := ClRect.Left;
        Y1 := ClRect.Top;
        X2 := Picture.Width - (RectWidth(SkinRect) - ClRect.Right);
        Y2 := Picture.Height - (RectHeight(SkinRect) - ClRect.Bottom); 
        CreateStretchImage(Buffer2, Picture, Rect(0, 0, Picture.Width, Picture.Height),
          Rect(X1, Y1, X2, Y2), True);
        B2 := TspBitMap.Create;
        B2.SetSize(Buffer2.Width, Buffer2.Height);
        B2.Canvas.Draw(0, 0, Buffer2);
        Buffer2.Free;
      end;
  end;
  B := TspBitMap.Create;
  B.SetSize(Buffer.Width, Buffer.Height);
  B.Canvas.Draw(0, 0, Buffer);
  B.AlphaBlend := True;
  B.SetAlpha(255);
  if QuickButtonAlphaMaskPictureIndex = -1
  then
    begin
      B.Draw(Cnvs, R.Left, R.Top);
    end
  else
    begin
      CreateAlphaByMask2(B, B2);
      bf.BlendOp := AC_SRC_OVER;
      bf.BlendFlags := 0;
      bf.SourceConstantAlpha := 255;
      bf.AlphaFormat := AC_SRC_ALPHA;
      if spEffBmp.IsMsImg
      then
        AlphaBlendFunc(Cnvs.Handle, R.Left, R.Top,
          RectWidth(R), RectHeight(R), B.DC,
          0, 0, B.Width, B.Height, bf);
      B2.Free;  
    end;
  Buffer.Free;
  B.Free;
end;

var
  X, Y: Integer;
begin
  with Parent.FQuickButtons[Index] do
  if Visible and (ItemRect.Right <= ObjectRect.Right)
  then
    begin
      //
      if ImageIndex < 0 then Exit;
      //
      if Active and Down
      then DrawQuickButtonImage(ItemRect, True)
      else if Active then DrawQuickButtonImage(ItemRect, False);
      X := ItemRect.Left + RectWidth(ItemRect) div 2 - Parent.QuickImageList.Width div 2;
      Y := ItemRect.Top+ RectHeight(ItemRect) div 2 - Parent.QuickImageList.Height div 2;
      if (ImageIndex >= 0) and (ImageIndex < Parent.QuickImageList.Count)
      then
        DrawImageWithAlpha(Parent.QuickImageList, ImageIndex, Cnvs,
         X, Y, Enabled);
    end;
end;

procedure TspSkinCaptionObject.DrawQuickButtonsAlpha(Cnvs: TCanvas);
var
  i: Integer;
  X, Y: Integer;
begin
  if Parent.QuickButtons.Count = 0 then Exit;
  if Parent.QuickImageList = nil then Exit;

  // calc buttons rects

  if not IsNullRect(DividerRect) and Parent.FShowIcon and not Parent.MenuButtonVisible
  then
    X := ObjectRect.Left + 6 + RectWidth(DividerRect)
  else
    X := ObjectRect.Left + 5;
  Y := ObjectRect.Top + RectHeight(ObjectRect) div 2 - Parent.QuickImageList.Height div 2 - 2;
  for i := 0 to Parent.QuickButtons.Count -1 do
  with Parent.FQuickButtons[i] do
   if Visible
   then
     begin
       ItemRect := Rect(X, Y,
         X + Parent.QuickImageList.Width + 4,
         Y +  Parent.QuickImageList.Height + 4);
       DrawQuickButtonAlpha(Cnvs, i);
       Inc(X, Parent.QuickImageList.Width + 8);
     end;
end;


procedure TspSkinCaptionObject.DrawQuickButton;

procedure DrawQuickButtonImage(R: TRect; ADown: Boolean);
var
  CIndex: Integer;
  Picture: TBitmap;
  Buffer: TBitMap;
  ButtonData: TspDataSkinButtonControl;
begin
  CIndex := Parent.FSD.GetControlIndex('officequickbutton');
  if CIndex = -1 then CIndex := Parent.FSD.GetControlIndex('resizetoolbutton');
  if CIndex = -1 then Exit;
  ButtonData := TspDataSkinButtonControl(Parent.FSD.CtrlList[CIndex]);
  Picture := TBitMap(Parent.FSD.FActivePictures.Items[ButtonData.PictureIndex]);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(R);
  Buffer.Height := RectWidth(R);
  with ButtonData do
  if ADown
  then
    CreateStretchImage(Buffer, Picture, DownSkinRect, ClRect, True)
  else
    CreateStretchImage(Buffer, Picture, ActiveSkinRect, ClRect, True);
  Cnvs.Draw(R.Left, R.Top, Buffer);
  Buffer.Free;
end;

var
  X, Y: Integer;
begin
  with Parent.FQuickButtons[Index] do
  if Visible
  then
    begin
      //
      if ImageIndex < 0 then Exit;
      //
      if Active and Down
      then DrawQuickButtonImage(ItemRect, True)
      else if Active then DrawQuickButtonImage(ItemRect, False);
      X := ItemRect.Left + RectWidth(ItemRect) div 2 - Parent.QuickImageList.Width div 2;
      Y := ItemRect.Top+ RectHeight(ItemRect) div 2 - Parent.QuickImageList.Height div 2;
      Parent.QuickImageList.Draw(Cnvs, X, Y, ImageIndex, Enabled);
    end;
end;


procedure TspSkinCaptionObject.DrawQuickButtons;
var
  i: Integer;
  X, Y: Integer;
begin
  if Parent.QuickButtons.Count = 0 then Exit;
  if Parent.QuickImageList = nil then Exit;
  // calc buttons rects
  if not IsNullRect(DividerRect) and Parent.FShowIcon and not Parent.MenuButtonVisible
  then
    X := ObjectRect.Left + 6 + RectWidth(DividerRect)
  else
    X := ObjectRect.Left + 5;
  Y := ObjectRect.Top + RectHeight(ObjectRect) div 2 - Parent.QuickImageList.Height div 2 - 2;
  for i := 0 to Parent.QuickButtons.Count -1 do
  with Parent.FQuickButtons[i] do
   if Visible
   then
     begin
       ItemRect := Rect(X, Y,
         X + Parent.QuickImageList.Width + 4,
         Y +  Parent.QuickImageList.Height + 4);
       DrawQuickButton(Cnvs, i);
       Inc(X, Parent.QuickImageList.Width + 8);
     end;
end;

function TspSkinCaptionObject.EnableAnimation: Boolean;
begin
  Result := (Parent.SkinData <> nil) and
   (Parent.SkinData.EnableSkinEffects) and
    not (Parent.SkinData.Empty) and
    not IsNullRect(AnimateSkinRect); 
end;

procedure TspSkinCaptionObject.MouseMove(X, Y: Integer);
begin
  inherited;
  if Parent.SupportNCArea and
    (((Parent.QuickButtons.Count <> 0) and (Parent.QuickImageList <> nil))
     or (Parent.CaptionTabs.Count <> 0))
  then
    TestActive(X, Y);
end;

procedure TspSkinCaptionObject.MouseDown;
var
  i: Integer;
  QuickButtonItem: TspQuickButtonItem;
begin
  with Parent do
  begin
    if not SupportNCArea and Parent.NCDraggAble and (Button = mbLeft) and
    (WindowState <> wsMaximized) then StartDragg(X, Y);
    MouseDownEvent(IDName, X, Y, ObjectRect, Button);
  end;

  if not Parent.SupportNCArea then Exit;

  if Parent.CaptionTabs.Count <> 0
  then
    begin
      TestActive(X, Y);
      if (ActiveTab <> -1) and (Button = mbLeft)
      then
        begin
          Parent.CaptionTabIndex := ActiveTab;
          Exit;
        end;
    end;
  
  if Parent.QuickButtons.Count = 0 then Exit;
  if Parent.QuickImageList = nil then Exit;

  TestActive(X, Y);

  if (ActiveQuickButton <> -1) and (Button = mbLeft)
  then
    begin
      for i := 0 to Parent.QuickButtons.Count - 1 do
      begin
        if i = ActiveQuickButton
        then
          begin
            Parent.QuickButtons[i].Down := True;
            if (Parent.QuickButtons[i].PopupMenu <> nil) and
               (PopupMenuQuickButton <> i)
            then
              begin
                UpdateNCForm;
                PopupMenuQuickButton := i;
                MouseCaptureQuickButton := -1;
                TrackMenu(Parent.QuickButtons[i].ItemRect, Parent.QuickButtons[i].PopupMenu);
              end
            else
              MouseCaptureQuickButton := i;
          end
        else
          begin
            Parent.QuickButtons[i].Down := False;
            Parent.QuickButtons[i].Active := False;
          end;
      end;
      UpdateNCForm;
    end;

  if (ActiveQuickButton <> -1)
  then
    begin
      QuickButtonItem := Parent.QuickButtons[ActiveQuickButton];
      if Assigned(QuickButtonItem.OnMouseDown) then
      QuickButtonItem.OnMouseDown(QuickButtonItem, Button, [], X, Y); 
    end;

  if (Parent.FSkinHint <> nil) and Parent.QuickButtonsShowHint
  then
    Parent.FSkinHint.HideHint;

end;

procedure TspSkinCaptionObject.MouseUp;
var
  i: Integer;
  P: TPoint;
  WasDown: Boolean;
begin
  with Parent do
  begin
    if not SupportNCArea then EndDragg;
    MouseUpEvent(IDName, X, Y, ObjectRect, Button);
  end;

  if not Parent.SupportNCArea then Exit;

  if (Parent.QuickButtons.Count = 0) or (Parent.QuickImageList = nil)
  then
    ActiveQuickButton := -1
  else
   TestActive(X, Y);

  if (ActiveQuickButton = -1) and (MouseCaptureQuickButton <> -1) and
     (MouseCaptureQuickButton >= 0) and (MouseCaptureQuickButton < Parent.QuickButtons.Count)
  then
    begin
      Parent.QuickButtons[MouseCaptureQuickButton].Down := False;
      Parent.QuickButtons[MouseCaptureQuickButton].Active := False;
    end;

  MouseCaptureQuickButton := -1;

  if (ActiveQuickButton <> -1) and (Button = mbLeft)
  then
    begin
      WasDown := Parent.QuickButtons[ActiveQuickButton].Down;
      for i := 0 to Parent.QuickButtons.Count - 1 do
      begin
        if (i = ActiveQuickButton) and (i = PopupMenuQuickButton)
        then
          begin
          end
        else
          Parent.QuickButtons[i].Down := False;
      end;
      UpdateNCForm;
      if Assigned(Parent.QuickButtons[ActiveQuickButton].OnClick) and WasDown
      then
        Parent.QuickButtons[ActiveQuickButton].OnClick(Self);
    end
  else
  if Parent.CanShowBorderLayer and Parent.FBorderLayer.FVisible and
     Parent.FBorderLayer.FData.FullBorder and (Button = mbRight)
  then
    begin
      GetCursorPos(P);
      Parent.FBorderLayer.MouseCaptureObject := -1;
      if not Parent.FDisableSystemMenu then
      if ActiveQuickButton = -1
      then
        Parent.FBorderLayer.DSF.TrackSystemMenu(P.X, P.Y);
    end;
end;

procedure TspSkinCaptionObject.SetTextValue(Value: String);
begin
  FTextValue := Value;
  Parent.DrawSkinObject(Self);
end;

procedure TspSkinCaptionObject.SimpleSetTextValue(Value: String);
begin
  FTextValue := Value;
end;

procedure TspSkinCaptionObject.MouseEnter;
begin
  FMouseIn := True;
  Parent.MouseEnterEvent(IDName);
end;

procedure TspSkinCaptionObject.MouseLeave;
begin
  FMouseIn := False;
  Parent.MouseLeaveEvent(IDName);

  if not Parent.SupportNCArea then Exit;

  if (Parent.QuickButtons.Count = 0) and (Parent.CaptionTabs.Count = 0) then Exit;

  ActiveTab := -1;
  OldActiveTab := -1;
  ActiveQuickButton := -1;
  OldActiveQuickButton := -1;
  TestActive(-1, -1);
end;

procedure TspSkinCaptionObject.DrawAlpha;
var
  tx, ty, TextOffset, OldTextOffset: Integer;
  RealTextRect: TRect;

function CorrectText(Cnv: TCanvas; var S1: WideString): WideString;
var
  w: Integer;
  S: WideString;
begin
  S := S1;
  w := RectWidth(RealTextRect);
  CorrectTextbyWidthW(Cnv, S, w);
  Result := S;
end;

procedure CnvSetFont(Cnv: TCanvas; FColor: TColor);
begin
  with Cnv do
  begin
    if Parent.FUseSkinFontInCaption
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
      end
    else
      Font.Assign(Parent.FDefCaptionFont);
    Font.Color := FColor;
    if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
    then
      Font.CharSet := Parent.SkinData.ResourceStrData.Charset
    else
      Font.CharSet := Parent.DefCaptionFont.Charset;
  end;
end;

procedure CalcTextCoord(tw, th: Integer);
var
  w, h: Integer;
begin
  w := RectWidth(RealTextRect);
  h := RectHeight(RealTextRect);
  ty := h div 2 - th div 2 + RealTextRect.Top;
  if (Parent.QuickButtons.Count <> 0) and Parent.SupportNCArea
  then
    tx := w div 2 - tw div 2 + RealTextRect.Left
  else
  case Alignment of
    taLeftJustify: tx := RealTextRect.Left;
    taRightJustify: tx := RealTextRect.Right - tw;
    taCenter: tx := w div 2 - tw div 2 + RealTextRect.Left;
  end;
end;

procedure DrawDivider(C: TCanvas; X, Y: Integer);
var
  B, B2: TspBitmap;
  Buffer: TBitmap;
  i, j: Integer;
  C1, C2: PspColor;
  DividRect: TRect;
begin
   //
  if not Active and not IsNullRect(InActiveDividerRect)
  then
    DividRect := InActiveDividerRect
  else
    DividRect := DividerRect;
  //
  B := TspBitmap.Create;
  B.SetSize(RectWidth(DividRect), RectHeight(DividRect));
  B.AlphaBlend := True;
  B2 := TspBitmap.Create;
  B2.SetSize(RectWidth(DividRect), RectHeight(DividRect));
  B2.AlphaBlend := True;
  B2.Canvas.CopyRect(Rect(0, 0, B2.Width, B2.Height), ABitmap.Canvas,
    Rect(X, Y, X + B2.Width, Y + B2.Height));
  if DividerTransparent
  then
    begin
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), ABitmap.Canvas,
        Rect(X, Y, X + B2.Width, Y + B2.Height));
      Buffer := TBitMap.Create;
      Buffer.Width := B.Width;
      Buffer.Height := B.Height;
      Buffer.Canvas.CopyRect
        (Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, DividRect);
      Buffer.Transparent := True;
      Buffer.TransparentMode := tmFixed;
      Buffer.TransparentColor := DividerTransparentColor;
      B.Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end
  else
    begin
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), ActivePicture.Canvas, DividRect);
    end;
  //
  for i := 0 to B.Width - 1 do
  for j := 0 to B.Height - 1 do
  begin
    C1 := B.PixelPtr[i, j];
    C2 := B2.PixelPtr[i, j];
    TspColorRec(C1^).A := TspColorRec(C2^).A;
  end;
  //
  B.Draw(C, X, Y);
  //
  B2.Free;
  B.Free;
end;

procedure DrawTextWithAlpha(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal);
var
  B, B2: TspBitmap;
  R: TRect;
  i, j: Integer;
  C1, C2: PspColor;
begin
  B := TspBitMap.Create;
  B.AlphaBlend := True;
  B.SetSize(RectWidth(Bounds), RectHeight(Bounds));
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
    ACanvas, Bounds);
  B.Canvas.Font.Assign(ACanvas.Font);
  R := Rect(0, 0, B.Width, B.Height);
  B.Canvas.Brush.Style := bsClear;
  //
  B2 := TspBitMap.Create;
  B2.SetSize(RectWidth(Bounds), RectHeight(Bounds));
  B2.AlphaBlend := True;
  B2.Canvas.Font.Assign(ACanvas.Font);
  B2.Canvas.Font.Color := clWhite;
  for i := 0 to B2.Width - 1 do
  for j := 0 to B2.Height - 1 do
  begin
    C1 := B2.PixelPtr[i, j];
    C2 := B.PixelPtr[i, j];
    TspColorRec(C1^).R := TspColorRec(C2^).A;
    TspColorRec(C1^).G := TspColorRec(C2^).A;
    TspColorRec(C1^).B := TspColorRec(C2^).A;
    TspColorRec(C1^).A := 255;
  end;
  B2.Canvas.Brush.Style := bsClear;
  SPDrawSkinText(B2.Canvas, AText, R, Flag);
  //
  B.SetAlpha(255);
  SPDrawSkinText(B.Canvas, AText, R, Flag);
  //
  CreateAlphaByMask(B, B2);
  //
  B.Draw(ABitmap.DC, Bounds.Left, Bounds.Top);
  B.Free;
  B2.Free;
end;

procedure DrawVistaTextWithAlphaGlow(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal; AGlowColor: TColor);
var
  B, B2: TspBitmap;
  R, R2: TRect;
  i, j: Integer;
  C1, C2: PspColor;
  Akf: Integer;
begin
  B := TspBitMap.Create;
  B.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  B2 := TspBitMap.Create;
  B2.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  R := Rect(6, 6, B.Width - 6, B.Height - 6);
  B.AlphaBlend := True;
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
    ACanvas, Rect(Bounds.Left - 6, Bounds.Top - 6,
      Bounds.Right + 6, Bounds.Bottom + 6));
  //
  B2.AlphaBlend := True;
  B2.Canvas.Font.Assign(ACanvas.Font);
  B2.Canvas.Font.Color := clWhite;
  for i := 0 to B2.Width - 1 do
  for j := 0 to B2.Height - 1 do
  begin
    C1 := B2.PixelPtr[i, j];
    C2 := B.PixelPtr[i, j];
    TspColorRec(C1^).R := TspColorRec(C2^).A;
    TspColorRec(C1^).G := TspColorRec(C2^).A;
    TspColorRec(C1^).B := TspColorRec(C2^).A;
    TspColorRec(C1^).A := 255;
  end;
  DrawVistaEffectTextW2(B2.Canvas, R, AText, Flag, clWhite);
  //
  B.Canvas.Font.Assign(ACanvas.Font);
  B.SetAlpha(255);
  DrawVistaEffectTextW2(B.Canvas, R, AText, Flag, AGlowColor);
  //
  CreateAlphaByMask(B, B2);
  //
  B.Draw(ACanvas, Bounds.Left - 6, Bounds.Top - 6);
  B.Free;
  B2.Free;
end;


procedure DrawReflectionTextWithAlpha(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal; AReflectionOffset: TColor; AReflectionColor: TColor);
var
  B, B2: TspBitmap;
  R, R2: TRect;
  i, j: Integer;
  C1, C2: PspColor;
begin
  B := TspBitMap.Create;
  B.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  B2 := TspBitMap.Create;
  B2.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  R := Rect(6, 6, B.Width - 6, B.Height - 6);
  B.AlphaBlend := True;
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
    ACanvas, Rect(Bounds.Left - 6, Bounds.Top - 6,
      Bounds.Right + 6, Bounds.Bottom + 6));
  //
  B2.AlphaBlend := True;
  B2.Canvas.Font.Assign(ACanvas.Font);
  B2.Canvas.Font.Color := clWhite;
  for i := 0 to B2.Width - 1 do
  for j := 0 to B2.Height - 1 do
  begin
    C1 := B2.PixelPtr[i, j];
    C2 := B.PixelPtr[i, j];
    TspColorRec(C1^).R := TspColorRec(C2^).A;
    TspColorRec(C1^).G := TspColorRec(C2^).A;
    TspColorRec(C1^).B := TspColorRec(C2^).A;
    TspColorRec(C1^).A := 255;
  end;
  DrawReflectionTextW(B2.Canvas, R, AText,
     Flag, AReflectionOffset, clWhite);
  //
  B.Canvas.Font.Assign(ACanvas.Font);
  B.SetAlpha(255);
  DrawReflectionTextW(B.Canvas, R, AText,
          Flag, AReflectionOffset, AReflectionColor);
  //
  CreateAlphaByMask(B, B2);
  //
  B.Draw(ACanvas, Bounds.Left - 6, Bounds.Top - 6);
  B.Free;
  B2.Free;
end;

procedure DrawTextWithAlphaGlow(ACanvas: TCanvas; AText: WideString;
var Bounds: TRect; Flag: cardinal; AGlowColor: TColor;
AGlowSize: Integer; AGlowOffset: Integer);

var
  B, B2: TspBitmap;
  R, R2: TRect;
  i, j: Integer;
  C1, C2: PspColor;
begin
  B := TspBitMap.Create;
  B.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  B2 := TspBitMap.Create;
  B2.SetSize(RectWidth(Bounds) + 12, RectHeight(Bounds) + 12);
  R := Rect(6, 6, B.Width - 6, B.Height - 6);
  B.AlphaBlend := True;
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height),
    ACanvas, Rect(Bounds.Left - 6, Bounds.Top - 6,
      Bounds.Right + 6, Bounds.Bottom + 6));
  //
  B2.AlphaBlend := True;
  B2.Canvas.Font.Assign(ACanvas.Font);
  B2.Canvas.Font.Color := clWhite;
  for i := 0 to B2.Width - 1 do
  for j := 0 to B2.Height - 1 do
  begin
    C1 := B2.PixelPtr[i, j];
    C2 := B.PixelPtr[i, j];
    TspColorRec(C1^).R := TspColorRec(C2^).A;
    TspColorRec(C1^).G := TspColorRec(C2^).A;
    TspColorRec(C1^).B := TspColorRec(C2^).A;
    TspColorRec(C1^).A := 255;
  end;
  DrawEffectTextW(B2.Canvas, R, AText, Flag, AGlowOffset, clWhite, AGlowSize);
  //
  B.Canvas.Font.Assign(ACanvas.Font);
  B.SetAlpha(255);
  DrawEffectTextW(B.Canvas, R, AText, Flag, AGlowOffset, AGlowColor, AGlowSize);
  //
  CreateAlphaByMask(B, B2);
  //
  B.Draw(ACanvas, Bounds.Left - 6, Bounds.Top - 6);
  B.Free;
  B2.Free;
end;

procedure DrawCaptionText(Cnv: TCanvas; OX, OY: Integer; AActive: Boolean);
var
  S1: WideString;
  C: TColor;
  F: TForm;
  B: TBitMap;
  FR: TRect;
  CR: TRect;
begin
  if (Parent.FCaptionTabs.Count > 0) and (Parent.FCaptionTabPos = sptpCenter)
  then
    Exit;

  S1 := Parent.FForm.Caption;

  {$IFDEF TNTUNICODE}
  if Parent.FForm is TTNTForm then S1 := TTNTForm(Parent.FForm).Caption;
  {$ENDIF}

   if Assigned(Parent.OnCaptionPaint)
  then
    begin
      Parent.OnCaptionPaint(Cnvs, ObjectRect, AActive);
      Exit;
    end;

  if (Parent.FForm.FormStyle = fsMDIForm) and Parent.IsMDIChildMaximized
  then
    begin
      F := Parent.GetMaximizeMDIChild;
      if F <> nil
      then
        begin
          {$IFDEF TNTUNICODE}
          if F is TTNTForm
          then
            S1 := S1 + ' - [' +  TTNTForm(F).Caption + ']'
          else
            S1 := S1 + ' - [' +  F.Caption + ']';
          {$ELSE}
          S1 := S1 + ' - [' +  F.Caption + ']';
          {$ENDIF}
        end;
    end;

  if (S1 = '') then Exit;

  S1 := CorrectText(Cnv, S1);
  
  with Cnv do
  begin
    CalcTextCoord(CalcTextWidthW(Cnv, S1), CalcTextHeightW(Cnv, S1));
    tx := tx + OX;
    ty := ty + OY;

    if (Cnv.Font.Height div 2) <> (Cnv.Font.Height / 2) then Dec(ty, 1);
    
    Brush.Style := bsClear;

    if Light
    then
      begin
        if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
        then
          Font.CharSet := Parent.SkinData.ResourceStrData.Charset
        else
          Font.Charset := Parent.FDefCaptionFont.Charset;
        C := Font.Color;
        if AActive
        then Font.Color := ActiveLightColor
        else Font.Color := LightColor;
        CR := Rect(tx - 1, ty - 1, tx - 1, ty - 1);
        SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);
        DrawTextWithAlpha(Cnv, S1, CR,
          Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
        Font.Color := C;
      end;

    if Shadow
    then
      begin
        if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
        then
          Font.CharSet := Parent.SkinData.ResourceStrData.Charset
        else
          Font.Charset := Parent.FDefCaptionFont.Charset;
        C := Font.Color;
        if AActive
        then Font.Color := ActiveShadowColor
        else Font.Color := ShadowColor;
        CR := Rect(tx + 1, ty + 1, tx + 1, ty + 1);
        SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);
        DrawTextWithAlpha(Cnv, S1, CR,
          Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
        Font.Color := C;
      end;

    CR := Rect(tx, ty, tx, ty);

    SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);

    if ReflectionEffect
    then
      begin
        if AActive then C := ReflectionActiveColor else C := ReflectionColor;
        DrawReflectionTextWithAlpha(Cnv, S1, CR, Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER),
         ReflectionOffset, C);
      end
    else
    if VistaGlowEffect
    then
      begin
        if AActive then C := GlowActiveColor else C := GlowColor;
        DrawVistaTextWithAlphaGlow(Cnv, S1, CR,
            Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER), C);
      end
    else
    if GlowEffect
    then
      begin
        if AActive then C := GlowActiveColor else C := GlowColor;
          DrawTextWithAlphaGlow(Cnv, S1, CR,
             Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER), C, GlowSize, GlowOffset);
      end
     else
       DrawTextWithAlpha(Cnv, S1, CR,
      Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
  end;
end;

begin
  RealTextRect := ObjectRect;
  OffsetRect(RealTextRect, -ObjectRect.Left, -ObjectRect.Top);

  if (Parent.QuickButtons.Count <> 0) and (Parent.QuickImageList <> nil) and
      Parent.SupportNCArea
  then
    begin
      if not IsNullRect(DividerRect) and Parent.FShowIcon and not Parent.MenuButtonVisible
      then
        begin
          DrawDivider(Cnvs,
            ObjectRect.Left + 3,
            ObjectRect.Top + RectHeight(RealTextRect) div 2 - RectHeight(DividerRect) div 2);
          Inc(RealTextRect.Left, Parent.QuickButtons.Count * (Parent.QuickImageList.Width + 8) + 2
            + RectWidth(DividerRect));
        end
      else
        Inc(RealTextRect.Left, Parent.QuickButtons.Count * (Parent.QuickImageList.Width + 8) + 2);
      DrawQuickButtonsAlpha(Cnvs);
    end;

  if Parent.FCaptionTabs.Count > 0
  then
    begin
      if Parent.FCaptionTabPos = sptpLeft
      then
        TextOffset := ObjectRect.Left + RealTextRect.Left + 5
      else
        TextOffset := ObjectRect.Left + RealTextRect.Left;
      OldTextOffset := TextOffset;
      DrawTabs(Cnvs, TextOffset,
      Parent.FBorderLayer.FData.BorderRect.Top,
      Parent.FBorderLayer.FData.BorderRect.Top + Parent.FBorderLayer.TopSize);
      case Parent.FCaptionTabPos of
       sptpLeft:
         begin
           if OldTextOffset <> TextOffset
           then
             Inc(RealTextRect.Left, TextOffset - OldTextOffset + 5);
         end;
       sptpRight:
         begin
           RealTextRect.Right := TextOffset;
           TextOffset := OldTextOffset;
         end;
      end;   
    end;

  if VistaGlowEffect
  then
    begin
      Inc(RealTextRect.Left, 6);
      Dec(RealTextRect.Right, 6);
    end
  else
  if GlowEffect
  then
    begin
      Inc(RealTextRect.Left, 3);
      Dec(RealTextRect.Right, 3);
    end;
  Active := Parent.FFormActive;
  if Active
  then CnvSetFont(Cnvs, ActiveFontColor)
  else CnvSetFont(Cnvs, FontColor);
  DrawCaptionText(Cnvs, ObjectRect.Left, ObjectRect.Top, Active);
end;

procedure TspSkinCaptionObject.Draw;
var
  Image, ActiveImage: TBitMap;
  tx, ty, TextOffset, OldTextOffset: Integer;
  EB1, EB2: TspEffectBmp;
  RealTextRect: TRect;
  SR, ASR: TRect;
  CaptionKind: Integer;

procedure DrawDivider(C: TCanvas; X, Y: Integer);
var
  Buffer: TBitmap;
  DividRect: TRect;
begin
  if not Active and not IsNullRect(InActiveDividerRect)
  then
    DividRect := InActiveDividerRect
  else
    DividRect := DividerRect;
  if DividerTransparent
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(DividRect);
      Buffer.Height := RectHeight(DividRect);
      Buffer.Canvas.CopyRect
        (Rect(0, 0, Buffer.Width, Buffer.Height), ActivePicture.Canvas, DividRect);
      Buffer.Transparent := True;
      Buffer.TransparentMode := tmFixed;
      Buffer.TransparentColor := DividerTransparentColor;
      C.Draw(X, Y, Buffer);
      Buffer.Free;
    end
  else
    begin
      C.CopyRect(Rect(X, Y, X + RectWidth(DividRect), Y + RectHeight(DividRect)),
        ActivePicture.Canvas, DividRect);
    end;
end;

function GetCaptionKind: Integer;
begin
  if (RectWidth(SR) = RectWidth(ObjectRect)) and
     (RectHeight(SR) = RectHeight(ObjectRect))
  then Result := 0 else
  if (SR.Top <= SD.LTPoint.Y) and (SR.Bottom < SD.RTPoint.Y)
  then Result := 1 else
  if  (SR.Top >= SD.LBPoint.Y) and (SR.Bottom > SD.RBPoint.Y)
  then Result := 2 else
  if (SR.Top <= SD.LTPoint.Y) and (SR.Bottom > SD.LBPoint.Y)
  then Result := 3 else Result := 4;
end;

procedure CnvSetFont(Cnv: TCanvas; FColor: TColor);
begin
  with Cnv do
  begin
    if Parent.FUseSkinFontInCaption
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
      end
    else
      Font.Assign(Parent.FDefCaptionFont);
    Font.Color := FColor;
    if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
    then
      Font.CharSet := Parent.SkinData.ResourceStrData.Charset
    else
      Font.CharSet := Parent.DefCaptionFont.Charset;
  end;
end;

function CorrectText(Cnv: TCanvas; var S1: WideString): WideString;
var
  w: Integer;
  S: WideString;
begin
  S := S1;
  w := RectWidth(RealTextRect);
  CorrectTextbyWidthW(Cnv, S, w);
  Result := S;
end;

procedure CreateCaptionHBitMap(DestB: TBitMap; SourceRect: TRect; SourceB: TBitMap);
var
  LO, RO, w, h: Integer;
begin
  //
  if (RectWidth(ObjectRect) < 0) or (RectHeight(ObjectRect) < 0) then Exit;
  //
  LO := 0;
  RO := 0;
  case CaptionKind of
    1: begin
         LO := SD.LTPoint.X - SR.Left;
         RO := SR.Right - SD.RTPoint.X;
       end;
    2: begin
         LO := SD.LBPoint.X - SR.Left;
         RO := SR.Right - SD.RBPoint.X;
       end;
  end;
  if LO < 0 then LO := 0;
  if RO < 0 then RO := 0;
  DestB.Width := RectWidth(ObjectRect);
  DestB.Height := RectHeight(ObjectRect);
  if (LO = 0) and (RO = 0)
  then
    DestB.Canvas.CopyRect(Rect(0, 0, DestB.Width, DestB.Height),
                          SourceB.Canvas, SourceRect)
  else
    CreateHSkinImage(LO, RO, DestB, SourceB, SourceRect, RectWidth(ObjectRect),
       RectHeight(ObjectRect), StretchEffect);

end;

procedure CreateCaptionVBitMap(DestB: TBitMap; SourceRect: TRect; SourceB: TBitMap);
var
  Y, YCnt: Integer;
  h: Integer;
  R: TRect;
  YO, TpO, BtO: Integer;
begin
  //
  if (RectWidth(ObjectRect) < 0) or (RectHeight(ObjectRect) < 0) then Exit;
  //
  TpO := 0;
  BtO := 0;
  case CaptionKind of
    3: begin
         TpO := SD.LTPoint.Y - SR.Top;
         BtO := SR.Bottom - SD.LBPoint.Y;
       end;
    4: begin
         TpO := SD.RTPoint.Y - SR.Top;
         BtO := SR.Bottom - SD.RBPoint.Y;
       end;
  end;
  if TpO < 0 then TpO := 0;
  if BtO < 0 then BtO := 0;
  DestB.Width := RectWidth(ObjectRect);
  DestB.Height := RectHeight(ObjectRect);
  if (TpO = 0) and (BtO = 0)
  then
    DestB.Canvas.CopyRect(Rect(0, 0, DestB.Width, DestB.Height),
                          SourceB.Canvas, SourceRect)
  else
    CreateVSkinImage(TpO, BtO, DestB, SourceB, SourceRect, RectWidth(ObjectRect),
        RectHeight(ObjectRect), StretchEffect);

end;

procedure CalcTextCoord(tw, th: Integer);
var
  w, h: Integer;
begin
  w := RectWidth(RealTextRect);
  h := RectHeight(RealTextRect);
  ty := h div 2 - th div 2 + RealTextRect.Top;
  if (Parent.QuickButtons.Count <> 0) and Parent.SupportNCArea
  then
    tx := w div 2 - tw div 2 + RealTextRect.Left
  else
  case Alignment of
    taLeftJustify: tx := RealTextRect.Left;
    taRightJustify: tx := RealTextRect.Right - tw;
    taCenter: tx := w div 2 - tw div 2 + RealTextRect.Left;
  end;
end;

procedure DrawCaptionText(Cnv: TCanvas; OX, OY: Integer; AActive: Boolean);
var
  S1: WideString;
  C: TColor;
  F: TForm;
  B: TBitMap;
  FR: TRect;
  CR: TRect;
begin
  if (Parent.FCaptionTabs.Count > 0) and (Parent.FCaptionTabPos = sptpCenter)
  then
    Exit;

  S1 := Parent.FForm.Caption;

  {$IFDEF TNTUNICODE}
  if Parent.FForm is TTNTForm then S1 := TTNTForm(Parent.FForm).Caption;
  {$ENDIF}

  if not Self.DefaultCaption and not Parent.SupportNCArea then S1 := FTextValue;

  if Assigned(Parent.OnCaptionPaint)
  then
    begin
      Parent.OnCaptionPaint(Cnvs, ObjectRect, AActive);
      Exit;
    end;

  if (Parent.FForm.FormStyle = fsMDIForm) and Parent.IsMDIChildMaximized
  then
    begin
      F := Parent.GetMaximizeMDIChild;
      if F <> nil
      then
        begin
          {$IFDEF TNTUNICODE}
          if F is TTNTForm
          then
            S1 := S1 + ' - [' +  TTNTForm(F).Caption + ']'
          else
            S1 := S1 + ' - [' +  F.Caption + ']';
          {$ELSE}
          S1 := S1 + ' - [' +  F.Caption + ']';
          {$ENDIF}
        end;
    end;

  if (S1 = '') or IsNullRect(TextRct) then Exit;
  S1 := CorrectText(Cnv, S1);
  with Cnv do
  begin
    CalcTextCoord(CalcTextWidthW(Cnv, S1), CalcTextHeightW(Cnv, S1));
    tx := tx + OX;
    ty := ty + OY;

    if (Cnv.Font.Height div 2) <> (Cnv.Font.Height / 2) then Dec(ty, 1);
    
    Brush.Style := bsClear;

    if not IsNullRect(Self.FrameRect)
    then
      begin
        B := TBitMap.Create;
        if (AActive) and not IsNullRect(ActiveFrameRect)
        then FR := ActiveFrameRect
        else FR := Self.FrameRect;
        if not FullFrame
        then
          begin
            if  CalcTextWidthW(Cnv, S1) + RectWidth(Self.FrameRect) - RectWidth(FrameTextRect) > 0
            then
              begin
                CreateHSkinImage(FrameLeftOffset, FrameRightOffset, B, ActivePicture, FR,
                  CalcTextWidthW(Cnv, S1) + RectWidth(Self.FrameRect) - RectWidth(FrameTextRect),
                  RectHeight(Self.FrameRect), False);
                Draw(TX - FrameTextRect.Left, TY - FrameTextRect.Top, B);
              end;
          end
        else
          begin
            if RectWidth(ObjectRect) - Parent.FSD.ButtonsOffset * 2 > 0
            then
              begin
                CreateHSkinImage(FrameLeftOffset, FrameRightOffset, B, ActivePicture, FR,
                  RectWidth(ObjectRect) - Parent.FSD.ButtonsOffset * 2, RectHeight(Self.FrameRect), False);
                Draw(ObjectRect.Left + Parent.FSD.ButtonsOffset, TY - FrameTextRect.Top, B);
              end;
          end;
        B.Free;
      end;
      
    if Light
    then
      begin
        if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
        then
          Font.CharSet := Parent.SkinData.ResourceStrData.Charset
        else
          Font.Charset := Parent.FDefCaptionFont.Charset;
        C := Font.Color;
        if AActive
        then Font.Color := ActiveLightColor
        else Font.Color := LightColor;
        CR := Rect(tx - 1, ty - 1, tx - 1, ty - 1);
        SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);
        SPDrawSkinText(Cnv, S1, CR,
          Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
        Font.Color := C;
      end;

    if Shadow
    then
      begin
        if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
        then
          Font.CharSet := Parent.SkinData.ResourceStrData.Charset
        else
          Font.Charset := Parent.FDefCaptionFont.Charset;
        C := Font.Color;
        if AActive
        then Font.Color := ActiveShadowColor
        else Font.Color := ShadowColor;
        CR := Rect(tx + 1, ty + 1, tx + 1, ty + 1);
        SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);
        SPDrawSkinText(Cnv, S1, CR,
          Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
        Font.Color := C;
      end;

    CR := Rect(tx, ty, tx, ty);
    SPDrawSkinText(Cnv, S1, CR, DT_CALCRECT);
    if ReflectionEffect
    then
      begin
        if AActive then C := ReflectionActiveColor else C := ReflectionColor;
        DrawReflectionTextW(Cnv, CR, S1,
          Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER),
            ReflectionOffset, C)
      end
    else
    if VistaGlowEffect
    then
      begin
        if AActive then C := GlowActiveColor else C := GlowColor;
        if not AActive and not VistaGlowInActiveEffect
        then
          SPDrawSkinText(Cnv, S1, CR,
            Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER))
        else
          DrawVistaEffectTextW(Cnv, CR, S1,
            Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER),  C);
      end
    else
    if GlowEffect
    then
      begin
        if AActive then C := GlowActiveColor else C := GlowColor;
        if not AActive and not GlowInActiveEffect
        then
          SPDrawSkinText(Cnv, S1, CR,
            Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER))
        else
          DrawEffectTextW(Cnv, CR, S1,
            Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER),
             GlowOffset, C, GlowSize)
      end
     else
       SPDrawSkinText(Cnv, S1, CR,
      Parent.FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
  end;
end;

function GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectHeight(AnimateSkinRect) > RectHeight(SkinRect)
  then
    begin
      fs := RectHeight(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left,
                     AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     AnimateSkinRect.Right,
                     AnimateSkinRect.Top + CurrentFrame * fs);
    end
  else
    begin
      fs := RectWidth(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 AnimateSkinRect.Top,
                 AnimateSkinRect.Left + CurrentFrame * fs,
                 AnimateSkinRect.Bottom);
    end;
end;

var
  TextO, LeftO: Integer;
begin
  if (Parent.SkinData = nil) or ((Parent.SkinData <> nil) and (Parent.SkinData.Empty))
  then
    Exit;

  SR := SkinRect;
  ASR := ActiveSkinRect;
  CaptionKind := GetCaptionKind;
  RealTextRect := TextRct;
  //
  Active := Parent.GetFormActive;
  //
  if not Active and not InActiveAnimation and EnableAnimation then CurrentFrame := 0;
  if Active and EnableAnimation and (CurrentFrame = 0) then CurrentFrame := 1;
  //
  if not IsNullRect(TextRct)
  then
    begin
      TextO := RectWidth(SkinRect) - TextRct.Right;
      if (Parent.QuickButtons.Count <> 0) and (Parent.QuickImageList <> nil)
         and Parent.SupportNCArea
      then
        begin
          if not IsNullRect(DividerRect) and Parent.FShowIcon and not Parent.MenuButtonVisible
          then
            begin
              DrawDivider(Cnvs,
               ObjectRect.Left + 3,
               ObjectRect.Top + RectHeight(RealTextRect) div 2 - RectHeight(DividerRect) div 2);
              LeftO := Parent.QuickButtons.Count * (Parent.QuickImageList.Width + 8) +
              2 + RectWidth(DividerRect);
            end
          else
            LeftO := Parent.QuickButtons.Count * (Parent.QuickImageList.Width + 8) + 2;
          Inc(RealTextRect.Left, LeftO);
        end;
      RealTextRect.Right := RectWidth(ObjectRect) - TextO;
    end;

  if (Parent.QuickButtons.Count <> 0) and (Parent.QuickImageList <> nil) and
      Parent.SupportNCArea
  then
    if Self.QuickButtonAlphaMaskPictureIndex <> -1
    then
      DrawQuickButtonsAlpha(Cnvs)
    else
      DrawQuickButtons(Cnvs);

  if Parent.FCaptionTabs.Count > 0
  then
    begin
      if Parent.FCaptionTabPos = sptpLeft
      then
        TextOffset := ObjectRect.Left + RealTextRect.Left + 5
      else
        TextOffset := ObjectRect.Left + RealTextRect.Left;
      OldTextOffset := TextOffset;
      DrawTabs(Cnvs, TextOffset, 0, Parent.FSD.ClRect.Top);
      case Parent.FCaptionTabPos of
       sptpLeft:
         begin
           if OldTextOffset <> TextOffset
           then
             Inc(RealTextRect.Left, TextOffset - OldTextOffset + 5);
         end;
       sptpRight:
         begin
           RealTextRect.Right := TextOffset;
           TextOffset := OldTextOffset;
         end;
      end;   
    end;

  if not IsNullRect(FrameRect)
  then
    begin
      Inc(RealTextRect.Top, FrameTextRect.Top);
      Inc(RealTextRect.Left, FrameTextRect.Left);
      Dec(RealTextRect.Right, RectWidth(FrameRect) - FrameTextRect.Right);
    end;

  //
  if EnableAnimation and Parent.FSupportNCArea and
     (CurrentFrame >= 1) and (CurrentFrame <= FrameCount)
  then
    begin
      ASR := GetAnimationFrameRect;
      Image := TBitMap.Create;
      CreateCaptionHBitMap(Image, ASR, ActivePicture);
      if not Active
      then CnvSetFont(Image.Canvas, ActiveFontColor)
      else CnvSetFont(Image.Canvas, FontColor);
      DrawCaptionText(Image.Canvas, 0, 0, not Active);
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Image);
      Image.Free;
      Exit;
    end
  else
  if EnableAnimation and not Parent.FSupportNCArea and
     (CurrentFrame >= 1) and (CurrentFrame <= FrameCount)
  then
    begin
      ASR := GetAnimationFrameRect;
      Image := TBitMap.Create;
      //
      if not Parent.CanScale
      then
        begin
          Image.Width := RectWidth(ObjectRect);
          Image.Height := RectHeight(ObjectRect);
          Image.Canvas.CopyRect(Rect(0, 0, Image.Width, Image.Height),
                                ActivePicture.Canvas, ASR);
         end
       else
         begin
           if CaptionKind < 3
           then
             CreateCaptionHBitMap(Image, ASR, ActivePicture)
           else
             CreateCaptionVBitMap(Image, ASR, ActivePicture);
         end;
       //
      if not Active
      then CnvSetFont(Image.Canvas, ActiveFontColor)
      else CnvSetFont(Image.Canvas, FontColor);
      DrawCaptionText(Image.Canvas, 0, 0, not Active);
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Image);
      Image.Free;
      Exit;
    end;
  //

  if Parent.SupportNCArea and IsNullRect(ASR)
  then
    begin
      if Active
      then CnvSetFont(Cnvs, ActiveFontColor)
      else CnvSetFont(Cnvs, FontColor);
      DrawCaptionText(Cnvs, ObjectRect.Left, ObjectRect.Top, Active);
    end
  else
  if IsNullRect(ASR) or (not Active and ((MorphKf = 0) or not EnableMorphing))
  then
    begin
      if not UpDate
      then
        begin
          if Active
          then CnvSetFont(Cnvs, ActiveFontColor)
          else CnvSetFont(Cnvs, FontColor);
          DrawCaptionText(Cnvs, ObjectRect.Left, ObjectRect.Top, Active);
        end
       else
         begin
           Image := TBitMap.Create;
           if not Parent.CanScale
           then
             begin
               Image.Width := RectWidth(ObjectRect);
               Image.Height := RectHeight(ObjectRect);
               Image.Canvas.CopyRect(Rect(0, 0, Image.Width, Image.Height),
                                     Picture.Canvas, SkinRect);
             end
           else
             if CaptionKind < 3
             then
               CreateCaptionHBitMap(Image, SR, Picture)
             else
               CreateCaptionVBitMap(Image, SR, Picture);

           if Active
           then CnvSetFont(Image.Canvas, ActiveFontColor)
           else CnvSetFont(Image.Canvas, FontColor);
           DrawCaptionText(Image.Canvas, 0, 0, Active);
           if Parent.GetAutoRenderingInActiveImage and not Active
           then
             begin
               EB1 := TspEffectBmp.CreateFromhWnd(Image.Handle);
               case Parent.FSD.InActiveEffect of
                 ieBrightness:
                   EB1.ChangeBrightness(InActiveBrightnessKf);
                 ieDarkness:
                   EB1.ChangeDarkness(InActiveDarknessKf);
                 ieGrayScale:
                   EB1.GrayScale;
                 ieNoise:
                   EB1.AddMonoNoise(InActiveNoiseAmount);
                 ieSplitBlur:
                   EB1.SplitBlur(1);
                 ieInvert:
                   EB1.Invert;
                end;
                EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
                EB1.Free;
              end
            else
              Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Image);
           Image.Free;
         end;
    end
  else
    begin
      ActiveImage := TBitMap.Create;
      if not Parent.CanScale
      then
        begin
          ActiveImage.Width := RectWidth(ObjectRect);
          ActiveImage.Height := RectHeight(ObjectRect);
          ActiveImage.Canvas.CopyRect(Rect(0, 0, ActiveImage.Width, ActiveImage.Height),
                                      ActivePicture.Canvas, ActiveSkinRect);
        end
      else
        if CaptionKind < 3
        then
          CreateCaptionHBitMap(ActiveImage, ASR, ActivePicture)
        else
          CreateCaptionVBitMap(ActiveImage, ASR, ActivePicture);
      CnvSetFont(ActiveImage.Canvas, ActiveFontColor);
      DrawCaptionText(ActiveImage.Canvas, 0, 0, True);
      if ((MorphKf = 0) and Active and not EnableMorphing) or
         (Active and (MorphKf = 1))
      then
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, ActiveImage)
      else
        begin
          Image := TBitMap.Create;
          if not Parent.CanScale
           then
             begin
               Image.Width := RectWidth(ObjectRect);
               Image.Height := RectHeight(ObjectRect);
               Image.Canvas.CopyRect(Rect(0, 0, Image.Width, Image.Height),
                                     Picture.Canvas, SkinRect);
             end
           else
            if CaptionKind < 3
            then
              CreateCaptionHBitMap(Image, SR, Picture)
            else
              CreateCaptionVBitMap(Image, SR, Picture);

          CnvSetFont(Image.Canvas, FontColor);
          DrawCaptionText(Image.Canvas, 0, 0, False);
          // Morphing
          EB1 := TspEffectBmp.CreateFromhWnd(Image.Handle);
          EB2 := TspEffectBmp.CreateFromhWnd(ActiveImage.Handle);
          case MorphKind of
            mkDefault: EB1.Morph(EB2, MorphKf);
            mkGradient: EB1.MorphGrad(EB2, MorphKf);
            mkLeftGradient: EB1.MorphLeftGrad(EB2, MorphKf);
            mkRightGradient: EB1.MorphRightGrad(EB2, MorphKf);
            mkLeftSlide: EB1.MorphLeftSlide(EB2, MorphKf);
            mkRightSlide: EB1.MorphRightSlide(EB2, MorphKf);
            mkPush: EB1.MorphPush(EB2, MorphKf)
          end;
          if Parent.GetAutoRenderingInActiveImage and not Active
          then
            case Parent.FSD.InActiveEffect of
              ieBrightness:
                EB1.ChangeBrightness(InActiveBrightnessKf);
              ieDarkness:
                EB1.ChangeDarkness(InActiveDarknessKf);
              ieGrayScale:
                EB1.GrayScale;
              ieNoise:
                EB1.AddMonoNoise(InActiveNoiseAmount);
              ieSplitBlur:
                EB1.SplitBlur(1);
              ieInvert:
                EB1.Invert;
            end;
          EB1.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
          EB1.Free;
          EB2.Free;
          //
          Image.Free;
        end;
      ActiveImage.Free;
    end;
end;

//============= TspSkinMainMenu =============//
constructor TspSkinMainMenu.Create;
begin
  inherited Create(AOwner);
  DSF := nil;
  FSD := nil;
end;

procedure TspSkinMainMenu.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

// ============= TspSkinMainMenuBar ================//

constructor TspMenuBarObject.Create;
begin
  Parent := AParent;
  Enabled := True;
  Visible := True;
  FMorphKf := 0;
  FDown := False;
  Morphing := False;
  Picture := nil;
  if AData <> nil then 
  with AData do
  begin
    Self.IDName := IDName;
    Self.SkinRect := SkinRect;
    Self.ActiveSkinRect := ActiveSkinRect;
    Self.DownRect := ActiveSkinRect;
    Self.Morphing := Morphing;
    Self.MorphKind := MorphKind;
    ObjectRect := SkinRect;
    if (ActivePictureIndex <> - 1) and
       (ActivePictureIndex < Parent.SkinData.FActivePictures.Count)
    then
      Picture := TBitMap(Parent.SkinData.FActivePictures.Items[ActivePictureIndex]);
  end;
end;

function TspMenuBarObject.EnableMorphing: Boolean;
begin
  Result := Morphing and (Parent.SkinData <> nil) and
            not (Parent.SkinData.Empty) and not (Parent.ToolBarMode and Parent.ToolBarModeItemTransparent)
            and Parent.SkinData.EnableSkinEffects;
end;

procedure TspMenuBarObject.ReDraw;
begin
  if EnableMorphing
  then Parent.MorphTimer.Enabled := True
  else Parent.DrawSkinObject(Self);
end;

procedure TspMenuBarObject.DblClick;
begin

end;

procedure TspMenuBarObject.MouseDown(X, Y: Integer; Button: TMouseButton);
begin
end;

procedure TspMenuBarObject.MouseUp(X, Y: Integer; Button: TMouseButton);
begin
end;

procedure TspMenuBarObject.MouseEnter;
begin
  FMouseIn := True;
  Active := True;
  ReDraw;
end;

procedure TspMenuBarObject.MouseLeave;
begin
  FMouseIn := False;
  Active := False;
  ReDraw;
end;

function TspMenuBarObject.CanMorphing;
begin
  Result := not (FDown and not IsNullRect(DownRect)) and
                ((Active and (MorphKf < 1)) or
                (not Active and (MorphKf > 0)));
end;

procedure TspMenuBarObject.DoMorphing;
begin
  if Active
  then MorphKf := MorphKf + MorphInc
  else MorphKf := MorphKf - MorphInc;
  Draw(Parent.Canvas);
end;

procedure TspMenuBarObject.Draw;
begin

end;

procedure TspMenuBarObject.SetMorphKf(Value: Double);
begin
  FMorphKf := Value;
  if FMorphKf < 0 then FMorphKf := 0 else
  if FMorphKf > 1 then FMorphKf := 1;
end;

// ============== TspSkinMainMenuBarButton ================ //
constructor TspSkinMainMenuBarButton.Create;
begin                   
  inherited Create(AParent, AData);
  if AData <> nil
  then
    with TspDataSkinMainMenuBarButton(AData) do
    begin
      Self.Command := Command;
      Self.DownRect := DownRect;
      FSkinSupport := True;
    end
  else
    FSkinSupport := False;
end;

procedure TspSkinMainMenuBarButton.DefaultDraw(Cnvs: TCanvas);
var
  Buffer: TBitMap;
  R: TRect;
  IX, IY: Integer;
  IC: TColor;
begin
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(ObjectRect);
  Buffer.Height := RectHeight(ObjectRect);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);

  with Buffer.Canvas do
  begin
    if FDown and FMouseIn
    then
      begin
        Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNDOWNCOLOR;
        FillRect(R);
      end
    else
      if FMouseIn
      then
        begin
          Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Brush.Color := SP_XP_BTNACTIVECOLOR;
          FillRect(R);
        end
      else
        begin
          Brush.Color := clBtnFace;
          FillRect(R);
        end;
  end;

  IX := Buffer.Width div 2 - 5;
  IY := Buffer.Height div 2 - 4;
  if FDown and FMouseIn
  then
    begin
      Inc(IX);
      Inc(IY);
    end;
  if Enabled then IC := clBtnText else IC := clBtnShadow;
  case Command of
    cmClose: DrawCloseImage(Buffer.Canvas, IX, IY, IC);
    cmMaximize: DrawRestoreImage(Buffer.Canvas, IX, IY, IC);
    cmMinimize: DrawMinimizeImage(Buffer.Canvas, IX, IY, IC);
    cmSysMenu: DrawSysMenuImage(Buffer.Canvas, IX, IY, IC);
  end;
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinMainMenuBarButton.MouseEnter;
begin
  if (Command = cmSysMenu) and FDown
  then
    begin
      FMouseIn := True;
      Active := True;
    end
  else
    begin
      if FDown and EnableMorphing
      then
        begin
          FMouseIn := True;
          Active := True;
          Parent.DrawSkinObject(Self);
        end
      else
        inherited;
    end;
end;

procedure TspSkinMainMenuBarButton.MouseLeave;
begin
 if (Command = cmSysMenu) and FDown
  then
    begin
      if EnableMorphing then FMorphKf := 1;
      Active := False;
      FMouseIn := False;
    end
  else
    begin
      if FDown and EnableMorphing
      then
        begin
          FMouseIn := False;
          Active := False;
          Parent.DrawSkinObject(Self);
        end
      else
        inherited;
    end;
end;

procedure TspSkinMainMenuBarButton.Draw;

procedure CreateObjectImage(B: TBitMap; AActive: Boolean);
begin
  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  with B.Canvas do
  begin
    if AActive
    then
      CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, ActiveSkinRect)
    else
      CopyRect(Rect(0, 0, B.Width, B.Height), Picture.Canvas, SkinRect);
  end;
end;

var
  PBuffer, APBuffer: TspEffectBmp;
  Buffer, ABuffer: TBitMap;
  ASR, SR: TRect;
begin
  if not FSkinSupport or (Picture = nil)
  then
    begin
      DefaultDraw(Cnvs);
      Exit;
    end;  
  if (FDown and not IsNullRect(DownRect)) and FMouseIn
  then
    Cnvs.CopyRect(ObjectRect, Picture.Canvas, DownRect)
  else
    begin
      ASR := ActiveSkinRect;
      SR := SkinRect;
      if not EnableMorphing or
        ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
      then
        begin
          if Active and not IsNullRect(ASR)
          then
            Cnvs.CopyRect(ObjectRect, Picture.Canvas, ASR)
          else
            Cnvs.CopyRect(ObjectRect, Picture.Canvas, SR);
        end
      else
        begin
          Buffer := TBitMap.Create;
          ABuffer := TBitMap.Create;
          CreateObjectImage(Buffer, False);
          CreateObjectImage(ABuffer, True);
          PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
          APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
          case MorphKind of
            mkDefault: PBuffer.Morph(APBuffer, MorphKf);
            mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
            mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
            mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
            mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
            mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
            mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
          end;
          PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
          PBuffer.Free;
          APBuffer.Free;
          Buffer.Free;
          ABuffer.Free;
        end;
    end;
end;

procedure TspSkinMainMenuBarButton.DblClick;
var
  DS: TspDynamicSkinForm;
begin
  DS := GetMDIChildDynamicSkinFormComponent;
  if (DS <> nil) and (Command = cmSysMenu)
  then
    begin
      Parent.DSF.SkinMenu.Hide;
      Parent.DSF.SkinMenuClose;
      DS.FForm.Close;
    end;
end;

procedure TspSkinMainMenuBarButton.DoCommand;
var
  DS: TspDynamicSkinForm;
  MI: TMenuItem;
  R: TRect;
  P: TPoint;
begin
  DS := GetMDIChildDynamicSkinFormComponent;
  if DS <> nil
  then
    case Command of
      cmClose: DS.FForm.Close;
      cmMinimize: DS.WindowState := wsMinimized;
      cmMaximize: DS.WindowState := wsNormal;
      cmSysMenu:
        begin
          Parent.RePaint;
          P := Point(ObjectRect.Left, ObjectRect.Top);
          P := Parent.ClientToScreen(P);
          R := Rect(P.X, P.Y, P.X + RectWidth(ObjectRect), P.Y + RectHeight(ObjectRect));
          MI := DS.GetSystemMenu;
          Parent.DSF.SkinMenuOpen;
          if Parent.DSF.MenusSkinData = nil
          then
            Parent.DSF.SkinMenu.Popup(Parent, Parent.DSF.SkinData, 0, R, MI, Parent.PopupToUp)
          else
            Parent.DSF.SkinMenu.Popup(Parent, Parent.DSF.MenusSkinData, 0, R, MI, Parent.PopupToUp);
        end;
   end;
end;

procedure TspSkinMainMenuBarButton.MouseDown;
begin
  if not Enabled then Exit;
  if (Button <> mbLeft)
  then
    begin
      inherited MouseDown(X, Y, Button);
      Exit;
    end;
  if not FDown
  then
    begin
      FDown := True;
      if EnableMorphing and not IsNullRect(DownRect) then MorphKf := 1;
      Parent.DrawSkinObject(Self);
      if Command = cmSysMenu then DoCommand;
    end;
end;

procedure TspSkinMainMenuBarButton.MouseUp;
begin
  if not Enabled then Exit;
  if (Button <> mbLeft)
  then
    begin
      inherited MouseUp(X, Y, Button);
      Exit;
    end;
  inherited MouseUp(X, Y, Button);
  if (Command <> cmSysMenu)
  then
    begin
      FDown := False;
      Parent.DrawSkinObject(Self);
      if EnableMorphing then ReDraw;
    end;
  if Active and (Command <> cmSysMenu) then DoCommand;
end;

// ==============TspSkinMainMenuBar =============//
constructor TspSkinMainMenuBarItem.Create;
begin
  inherited Create(AParent, AData);
  if AData <> nil
  then
    begin
      FSkinSupport := True;
      with TspDataSkinMainMenuBarItem(AData) do
      begin
        Self.FontName := FontName;
        Self.FontHeight := FontHeight;
        Self.FontStyle := FontStyle;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.DownFontColor := DownFontColor;
        Self.TextRct := TextRct;
        Self.DownRect := DownRect;
        Self.LO := ItemLO;
        Self.RO := ItemRO;
        Self.UnEnabledFontColor := UnEnabledFontColor;
        Self.StretchEffect := StretchEffect;
        Self.AnimateSkinRect := AnimateSkinRect; 
        Self.FrameCount := FrameCount;
        Self.AnimateInterval := AnimateInterval;
        Self.InActiveAnimation := InActiveAnimation; 
      end;
      if IsNullRect(DownRect) then
      if IsNullRect(ActiveSkinRect)
      then DownRect := SkinRect else DownRect := ActiveSkinRect;
      if IsNullRect(ActiveSkinRect) then Morphing := False;
    end
  else
    FSkinSupport := False;
  OldEnabled := Enabled;
  Visible := True;
  CurrentFrame := 0;
end;

procedure TspSkinMainMenuBarItem.ReDraw;
begin
  if EnableAnimation
  then
    begin
      if  Parent.AnimateTimer.Interval <> AnimateInterval
      then
        Parent.AnimateTimer.Interval := AnimateInterval;
      Parent.AnimateTimer.Enabled := True;
    end
  else inherited;
end;

function TspSkinMainMenuBarItem.EnableAnimation: Boolean;
begin
  Result := not IsNullRect(AnimateSkinRect) and (Parent.SkinData <> nil) and
            not (Parent.SkinData.Empty) and not Parent.ToolBarMode and
            Parent.SkinData.EnableSkinEffects;
end;

procedure TspSkinMainMenuBarItem.SearchActive;
var
  i: Integer;
begin
  for i := 0 to Parent.ObjectList.Count - 1 do
   if (TspMenuBarObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuBarItem)
      and (TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).IDName <> IDName)
      and (TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).Active)
   then
     begin
       TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).MouseLeave;
       Break;
     end;
end;

function TspSkinMainMenuBarItem.SearchDown;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Parent.ObjectList.Count - 1 do
   if (TspMenuBarObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuBarItem)
      and (TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).IDName <> IDName)
      and (TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).FDown)
   then
     begin
       TspSkinMainMenuBarItem(Parent.ObjectList.Items[i]).SetDown(False);
       Result := True;
       Break;
     end;
end;


procedure TspSkinMainMenuBarItem.DefaultDraw;

function CalcObjectRect(Cnvs: TCanvas): TRect;
var
  w, i, j, IX, IY: Integer;
  R, TR: TRect;
  S: WideString;
  IL: TCustomImageList;
begin
  w := 2;
  Cnvs.Font.Assign(Parent.DefItemFont);
  if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
  then
    Cnvs.Font.CharSet := Parent.SkinData.ResourceStrData.CharSet;
  TR := Rect(0, 0, 0, 0);

  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    S := TTNTMenuItem(MenuItem).Caption
  else
    S := MenuItem.Caption;
  {$ELSE}
  S := MenuItem.Caption;
  {$ENDIF}

  SPDrawSkinText(Cnvs, S, TR, DT_CALCRECT or DT_CENTER);

  w := w + RectWidth(TR) + 10;
  R := Rect(0, 0, 0, 0);
  j := Parent.ObjectList.IndexOf(Self);
  for i := j - 1  downto 0 do
    if TspMenuBarObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      begin
        R.Left := TspMenuBarObject(Parent.ObjectList.Items[i]).ObjectRect.Right;
        Break;
      end;
  if R.Left = 0 then R.Left := Parent.NewItemsRect.Left;

  R.Top := Parent.NewItemsRect.Top;

  if (MenuItem.GetImageList <> nil) and (MenuItem.ImageIndex >= 0) and
     (MenuItem.ImageIndex < MenuItem.GetImageList.Count)
  then
    R.Right := R.Left + MenuItem.GetImageList.Width + 5 + w
  else
  if not MenuItem.Bitmap.Empty
  then
    R.Right := R.Left + MenuItem.Bitmap.Width + 5 + w
  else
    R.Right := R.Left + w;

  R.Bottom := Parent.NewItemsRect.Bottom;
  Result := R;
end;


var
  Buffer: TBitMap;
  R, R1: TRect;
  TMO, IX, IY: Integer;
  S: WideString;
  IL: TCustomImageList;
begin
  Buffer := TBitMap.Create;
  ObjectRect := CalcObjectRect(Buffer.Canvas);
  if Parent.ScrollMenu
  then
    TMO := TRACKMARKEROFFSET
  else
    TMO := 0;
  if ObjectRect.Right > Parent.NewItemsRect.Right - TMO
  then
    begin
      Parent.Scroll := True;
      if Visible
      then
        begin
          OldEnabled := Enabled;
          Enabled := False;
          Visible := False;
        end;
      Buffer.Free;
      Exit;
    end
  else
    if not Visible
    then
      begin
        Visible := True;
        Enabled := OldEnabled;
      end;
  Buffer.Width := RectWidth(ObjectRect);
  Buffer.Height := RectHeight(ObjectRect);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    if FDown
    then
      begin
        Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
        Brush.Color := SP_XP_BTNDOWNCOLOR;
        FillRect(R);
      end
    else
      if FMouseIn
      then
        begin
          Frame3D(Buffer.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Brush.Color := SP_XP_BTNACTIVECOLOR;
          FillRect(R);
        end
      else
        begin
          Brush.Color := clBtnFace;
          FillRect(R);
        end;
  end;
  //
  R1 := Rect(0, 0, 0, 0);
  Buffer.Canvas.Font.Assign(Parent.DefItemFont);
  if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
  then
    Buffer.Canvas.Font.CharSet := Parent.SkinData.ResourceStrData.CharSet;

  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    S := TTNTMenuItem(MenuItem).Caption
  else
    S := MenuItem.Caption;
  {$ELSE}
  S := MenuItem.Caption;
  {$ENDIF}

  SPDrawSkinText(Buffer.Canvas, S, R1, DT_CALCRECT);

  R.Top := R.Top + RectHeight(R) div 2 - R1.Bottom div 2;
  R.Bottom := R.Top + R1.Bottom;

   if (MenuItem.GetImageList <> nil) and (MenuItem.ImageIndex >= 0) and
      (MenuItem.ImageIndex < MenuItem.GetImageList.Count)
   then
     begin
       IL := MenuItem.GetImageList;
       IX := R.Left + 2;
       if Parent.FUseSkinSize
       then
         IY := R.Top + RectHeight(R) div 2 - IL.Height div 2
       else
         IY := Buffer.Height div 2 - IL.Height div 2;
       IL.Draw(Buffer.Canvas, IX, IY, MenuItem.ImageIndex, MenuItem.Enabled);
       Inc(R.Left, IL.Width + 5);
     end
   else
    if not MenuItem.Bitmap.Empty
    then
      begin
        IX := R.Left + 2;
        IY := R.Top + RectHeight(R) div 2 - MenuItem.Bitmap.Height div 2;
        Buffer.Canvas.Draw(IX, IY,  MenuItem.Bitmap);
        Inc(R.Left, MenuItem.Bitmap.Width + 5);
      end;

  if Assigned(MenuItem.OnDrawItem)
  then
    MenuItem.OnDrawItem(Self, Buffer.Canvas, R, Active)
  else
  if TspSkinMainMenuBar(Parent).MenuActive
  then
    SPDrawSkinText(Buffer.Canvas, S, R,
      TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER))
  else
    SPDrawSkinText(Buffer.Canvas, S, R,
      TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER or DT_HIDEPREFIX));

      
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinMainMenuBarItem.Draw;

function CalcObjectRect(Cnvs: TCanvas): TRect;
var
  w, i, j: Integer;
  R, TR: TRect;
  S: WideString;
begin
  w := TextRct.Left + RectWidth(SkinRect) - TextRct.Right;
  if Parent.FUseSkinFont
  then
    with Cnvs do
    begin
      Font.Name := FontName;
      Font.Style := FontStyle;
      Font.Height := FontHeight;
    end
  else
    Cnvs.Font.Assign(Parent.DefItemFont);
  if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
  then
    Cnvs.Font.CharSet := Parent.SkinData.ResourceStrData.Charset
  else
    Cnvs.Font.CharSet := Parent.DefItemFont.Charset;
  TR := Rect(0, 0, 0, 0);

  {$IFDEF TNTUNICODE}
  if MenuItem is TTNTMenuItem
  then
    S := TTNTMenuItem(MenuItem).Caption
  else
    S := MenuItem.Caption;
  {$ELSE}
  S := MenuItem.Caption;
  {$ENDIF}

  SPDrawSkinText(Cnvs, S, TR, DT_CALCRECT or DT_CENTER);

  w := w + RectWidth(TR) + 2;
  R := Rect(0, 0, 0, 0);
  j := Parent.ObjectList.IndexOf(Self);
  for i := j - 1  downto 0 do
    if TspMenuBarObject(Parent.ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      begin
        R.Left := TspMenuBarObject(Parent.ObjectList.Items[i]).ObjectRect.Right;
        Break;
      end;
  if R.Left = 0 then R.Left := Parent.NewItemsRect.Left;
  R.Top := Parent.NewItemsRect.Top;

  if (MenuItem.GetImageList <> nil) and (MenuItem.ImageIndex >= 0) and
     (MenuItem.ImageIndex < MenuItem.GetImageList.Count)
  then
    R.Right := R.Left + MenuItem.GetImageList.Width + 5 + w
  else
  if not MenuItem.Bitmap.Empty
  then
    R.Right := R.Left + MenuItem.Bitmap.Width + 5 + w
  else
    R.Right := R.Left + w;

  if Parent.UseSkinSize
  then
    R.Bottom := R.Top + RectHeight(SkinRect)
  else
    R.Bottom := Parent.NewItemsRect.Bottom;
  Result := R;
end;

procedure CreateToolBarItemImage(Buffer: TBitMap; AActive, ADown: Boolean);
var
  CIndex, h: Integer;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  TR, TR1, BtnCLRect: TRect;
  BSR, ABSR, DBSR, R1: TRect;
  XO, YO, IX, IY: Integer;
  ButtonData: TspDataSkinButtonControl;
  S: String;
  IL: TCustomImageList;
begin

  Buffer.Width := RectWidth(ObjectRect);
  Buffer.Height := RectHeight(ObjectRect);

  CIndex := Parent.FSD.GetControlIndex('resizetoolbutton');
  if CIndex = -1 then Exit;
  ButtonData := TspDataSkinButtonControl(Parent.FSD.CtrlList[CIndex]);
  with ButtonData do
  begin
    XO := Buffer.Width - RectWidth(SkinRect);
    YO := Buffer.Height - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(Parent.FSD.FActivePictures.Items[ButtonData.PictureIndex]);

    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if ADown
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
          Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
      end
    else
    if AActive
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
          BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
          Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
          LeftStretch, TopStretch, RightStretch, BottomStretch,
          StretchEffect, StretchType);
      end
    else
      begin
        if Parent.ToolBarModeItemTransparent
        then
          begin
            Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height), Cnvs,
              ObjectRect);
          end
        else
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
            BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
            Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
            LeftStretch, TopStretch, RightStretch, BottomStretch,
            StretchEffect, StretchType);
      end;
     //
     with Buffer.Canvas do
     begin
       Brush.Style := bsClear;
       if Parent.UseSkinFont
       then
         begin
           Font.Name := FontName;
           Font.Style := FontStyle;
           Font.Height := FontHeight;
         end
       else
         Font.Assign(Parent.DefItemFont);
      if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
      then
        Font.CharSet := Parent.SkinData.ResourceStrData.Charset
      else
        Font.CharSet := Parent.DefItemFont.Charset;

       if ADown
       then
         Font.Color := DownFontColor
       else
       if AActive
       then
         Font.Color := ActiveFontColor
       else
         if Self.MenuItem.Enabled
         then Font.Color := FontColor
         else Font.Color := UnEnabledFontColor;

       {$IFDEF TNTUNICODE}
       if MenuItem is TTNTMenuItem
       then
         S := TTNTMenuItem(MenuItem).Caption
       else
         S := MenuItem.Caption;
       {$ELSE}
       S := MenuItem.Caption;
       {$ENDIF}

      TR1 := BtnClRect;
      
      if (MenuItem.GetImageList <> nil) and (MenuItem.ImageIndex >= 0) and
         (MenuItem.ImageIndex < MenuItem.GetImageList.Count)
      then
        begin
          IL := MenuItem.GetImageList;
          IX := TR1.Left + 2;
          IY := TR1.Top + RectHeight(TR1) div 2 - IL.Height div 2;
          IL.Draw(Buffer.Canvas, IX, IY, MenuItem.ImageIndex, MenuItem.Enabled);
          Inc(TR1.Left, IL.Width + 5);
        end
      else
      if not MenuItem.Bitmap.Empty
      then
        begin
          IX := TR1.Left + 2;
          IY := TR1.Top + RectHeight(TR1) div 2 - MenuItem.Bitmap.Height div 2;
          Buffer.Canvas.Draw(IX, IY,  MenuItem.Bitmap);
          Inc(TR1.Left, MenuItem.Bitmap.Width + 5);
        end;

       SPDrawSkinText(Buffer.Canvas, S, TR, DT_CALCRECT);

       if not Parent.UseSkinSize
       then
         begin
           h := RectHeight(TR);
           TR.Top := Buffer.Height div 2 - h div 2;
           TR.Bottom := TR.Top + h;
         end;

       TR.Left := TR1.Left;
       TR.Right := TR1.Right;

       if Assigned(MenuItem.OnDrawItem)
       then
         MenuItem.OnDrawItem(Self, Buffer.Canvas, TR, AActive)
       else
       if TspSkinMainMenuBar(Parent).MenuActive
       then
         SPDrawSkinText(Buffer.Canvas, S, TR,
           TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER))
       else
         SPDrawSkinText(Buffer.Canvas, S, TR,
           TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER or DT_HIDEPREFIX));
     end;     
   end;
end;

procedure CreateItemImage(B: TBitMap; Rct: TRect; AActive: Boolean);
var
  TR: TRect;
  SE: Boolean;
  S: WideString;
  h, IX, IY: Integer;
  IL: TCustomImageList;
begin
  if Picture = nil then Exit;

  B.Width := RectWidth(ObjectRect);
  B.Height := RectHeight(ObjectRect);
  SE := False;
  if AActive then SE := Self.StretchEffect;

  if Parent.ItemTransparent and (EqRects(Rct, SkinRect) or (not Parent.UseSkinSize and not AActive))
  then
    begin
      B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs,
       ObjectRect);
    end
  else
    begin
      if Parent.UseSkinSize
      then
        CreateHSkinIMage(LO, RO, B, Picture, Rct, B.Width, B.Height, SE)
      else
        begin
          TR := Rect(LO, RectHeight(Rct) div 4,
                RectWidth(Rct) - RO, RectHeight(Rct) - RectHeight(Rct) div 4);
          CreateStretchImage(B, Picture, Rct, TR, True);
        end;
    end;
  with B.Canvas do
  begin
    Brush.Style := bsClear;

    if Parent.UseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
      end
    else
      Font.Assign(Parent.DefItemFont);

    if (Parent.SkinData <> nil) and (Parent.SkinData.ResourceStrData <> nil)
    then
      Font.CharSet := Parent.SkinData.ResourceStrData.Charset
    else
      Font.CharSet := Parent.DefItemFont.Charset;

    if FDown
    then
      Font.Color := DownFontColor
    else
      if AActive
      then
        Font.Color := ActiveFontColor
      else
        if Self.MenuItem.Enabled
        then Font.Color := FontColor
        else Font.Color := UnEnabledFontColor;

     TR := TextRct;

     if (MenuItem.GetImageList <> nil) and (MenuItem.ImageIndex >= 0) and
         (MenuItem.ImageIndex < MenuItem.GetImageList.Count)
      then
        begin
          IL := MenuItem.GetImageList;
          IX := TR.Left + 2;
          IY := B.Height div 2 - IL.Height div 2;
          IL.Draw(B.Canvas, IX, IY, MenuItem.ImageIndex, MenuItem.Enabled);
          Inc(TR.Left, IL.Width + 5);
        end
      else
      if not MenuItem.Bitmap.Empty
      then
        begin
          IX := TR.Left + 2;
          IY := B.Height div 2 - MenuItem.Bitmap.Height div 2;
          B.Canvas.Draw(IX, IY,  MenuItem.Bitmap);
          Inc(TR.Left, MenuItem.Bitmap.Width + 5);
        end;

    {$IFDEF TNTUNICODE}
    if MenuItem is TTNTMenuItem
    then
      S := TTNTMenuItem(MenuItem).Caption
    else
      S := MenuItem.Caption;
    {$ELSE}
    S := MenuItem.Caption;
    {$ENDIF}
    SPDrawSkinText(B.Canvas, S, TR, DT_CALCRECT);
    Inc(TR.Right, 2);
    if not Parent.UseSkinSize
    then
      begin
        h := RectHeight(TR);
        TR.Top := B.Height div 2 - h div 2;
        TR.Bottom := TR.Top + h;
      end;
    if Assigned(MenuItem.OnDrawItem)
    then
      MenuItem.OnDrawItem(Self, B.Canvas, TR, AActive)
    else
    if TspSkinMainMenuBar(Parent).MenuActive
    then
      SPDrawSkinText(B.Canvas, S, TR,
       TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER))
    else
      SPDrawSkinText(B.Canvas, S, TR,
       TspSkinMainMenuBar(Parent).DrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER or DT_HIDEPREFIX));
  end;
end;

function GetAnimationFrameRect: TRect;
var
  fs: Integer;
begin
  if RectHeight(AnimateSkinRect) > RectHeight(SkinRect)
  then
    begin
      fs := RectHeight(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left,
                     AnimateSkinRect.Top + (CurrentFrame - 1) * fs,
                     AnimateSkinRect.Right,
                     AnimateSkinRect.Top + CurrentFrame * fs);
    end
  else
    begin
      fs := RectWidth(AnimateSkinRect) div FrameCount;
      Result := Rect(AnimateSkinRect.Left + (CurrentFrame - 1) * fs,
                 AnimateSkinRect.Top,
                 AnimateSkinRect.Left + CurrentFrame * fs,
                 AnimateSkinRect.Bottom);
    end;
end;

var
  Buffer, ABuffer: TBitMap;
  PBuffer, APBuffer: TspEffectBmp;
  TMO: Integer;
  R: TRect;
begin
  if not FSkinSupport
  then
    begin
      DefaultDraw(Cnvs);
      Exit;
    end;
  if IsNullRect(SkinRect) or IsNullRect(TextRct) then Exit;
  if Parent.ScrollMenu
  then
    TMO := TRACKMARKEROFFSET
  else
    TMO := 0;
  Buffer := TBitMap.Create;
  ObjectRect := CalcObjectRect(Buffer.Canvas);
  if ObjectRect.Right > Parent.NewItemsRect.Right - TMO
  then
    begin
      Parent.Scroll := True;
      if Visible
      then
        begin
          OldEnabled := Enabled;
          Enabled := False;
          Visible := False;
        end;
      Buffer.Free;
      Exit;
    end
  else
    if not Visible
    then
      begin
        Visible := True;
        Enabled := OldEnabled;
      end;
  if FDown
  then
    begin
      if not Parent.FToolBarMode
      then
        CreateItemImage(Buffer, DownRect, True)
      else
        CreateToolBarItemImage(Buffer, True, True);
      Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
    end
  else
    if EnableAnimation and
       (CurrentFrame >= 1) and (CurrentFrame <= FrameCount)
    then
     begin
        R := GetAnimationFrameRect;
        CreateItemImage(Buffer, R, True);
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
      end
    else
    if not EnableMorphing or
       ((Active and (MorphKf = 1)) or (not Active and (MorphKf  = 0)))
    then
      begin
        if Active
        then
          begin
            if isNullRect(ActiveSkinRect)
            then
              begin
                if not Parent.FToolBarMode
                then
                  CreateItemImage(Buffer, SkinRect, True)
                else
                  CreateToolBarItemImage(Buffer, True, False);
              end
            else
              begin
                if not Parent.FToolBarMode
                then
                  CreateItemImage(Buffer, ActiveSkinRect, True)
                else
                  CreateToolBarItemImage(Buffer, True, False);
              end;
          end
        else
          begin
            if not Parent.FToolBarMode
            then
              CreateItemImage(Buffer, SkinRect, False)
            else
              CreateToolBarItemImage(Buffer, False, False);
          end;  
        Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
      end
    else
      begin

        if not Parent.FToolBarMode
        then
          CreateItemImage(Buffer, SkinRect, False)
        else
          CreateToolBarItemImage(Buffer, False, False);
          
        ABuffer := TBitMap.Create;

        if not Parent.FToolBarMode
        then
          CreateItemImage(ABuffer, ActiveSkinRect, True)
        else
          CreateToolBarItemImage(ABuffer, True, False);

        PBuffer := TspEffectBmp.CreateFromhWnd(Buffer.Handle);
        APBuffer := TspEffectBmp.CreateFromhWnd(ABuffer.Handle);
        case MorphKind of
          mkDefault: PBuffer.Morph(APBuffer, MorphKf);
          mkGradient: PBuffer.MorphGrad(APBuffer, MorphKf);
          mkLeftGradient: PBuffer.MorphLeftGrad(APBuffer, MorphKf);
          mkRightGradient: PBuffer.MorphRightGrad(APBuffer, MorphKf);
          mkLeftSlide: PBuffer.MorphLeftSlide(APBuffer, MorphKf);
          mkRightSlide: PBuffer.MorphRightSlide(APBuffer, MorphKf);
          mkPush: PBuffer.MorphPush(APBuffer, MorphKf);
        end;
        PBuffer.Draw(Cnvs.Handle, ObjectRect.Left, ObjectRect.Top);
        PBuffer.Free;
        APBuffer.Free;
        ABuffer.Free;
      end;
  Buffer.Free;
end;

procedure TspSkinMainMenuBarItem.MouseEnter;
begin
  if SearchDown
  then
    begin
      Active := True;
      FMouseIn := True;
      if EnableMorphing then MorphKf := 1;
      if Assigned(MenuItem.OnClick) then MenuItem.OnClick(Parent);
      SetDown(True);
    end
  else
    begin
      SearchActive;
      FMouseIn := True;
      Active := True;
      ReDraw;
      if Assigned(Parent.OnItemMouseEnter)
      then
        Parent.OnItemMouseEnter(Self.MenuItem);
      if Parent.Hint <> MenuItem.Hint then Parent.Hint := MenuItem.Hint;  
    end;
end;

procedure TspSkinMainMenuBarItem.MouseLeave;
begin
  Active := False;
  FMouseIn := False;
  if EnableAnimation and not InActiveAnimation
  then
    begin
      CurrentFrame := 0;
      Draw(Parent.Canvas);
    end;
  if EnableMorphing and FDown then MorphKf := 0;
  Redraw;
  if Assigned(Parent.OnItemMouseLeave)
  then
    Parent.OnItemMouseLeave(Self.MenuItem);
end;

procedure TspSkinMainMenuBarItem.SetDown;
begin
  FDown := Value;
  if FDown
  then
    begin
      Parent.DrawSkinObject(Self);
      if Parent.DSF <> nil
      then
        with Parent.DSF do
        begin
          if not InMainMenu
          then
            begin
              if Assigned(OnMainMenuEnter) then OnMainMenuEnter(Parent);
            end;
        end;
      TrackMenu;
    end
  else
    begin
      Active := False;
      if EnableAnimation
      then
        begin
          if InActiveAnimation
          then
            begin
              CurrentFrame := FrameCount + 1;
              ReDraw;
            end
          else
            begin
              CurrentFrame := 0;
              Parent.DrawSkinObject(Self);
            end;
        end
      else
      if EnableMorphing
      then
        begin
          FMorphKf := 1;
          ReDraw;
        end
      else
        Parent.DrawSkinObject(Self);
    end;
end;

procedure TspSkinMainMenuBarItem.TrackMenu;
var
  R: TRect;
  P: TPoint;
begin
  P := Point(ObjectRect.Left, ObjectRect.Top);
  P := Parent.ClientToScreen(P);
  R := Rect(P.X, P.Y, P.X + RectWidth(ObjectRect), P.Y + RectHeight(ObjectRect));
  if Parent.DSF <> nil
  then
    with Parent.DSF do
    begin
      SkinMenuOpen;
      if not InMainMenu then InMainMenu := True;
      SkinMenu.Popup(nil, Parent.SkinData, 0, R, MenuItem, Parent.PopupToUp);
    end;
end;

procedure TspSkinMainMenuBarItem.MouseDown;
var
  Menu: TMenu;
begin
  if not Enabled then Exit;
  if Parent.DSF = nil then Exit;
  if Button = mbLeft
  then
    begin
      if Assigned(Parent.OnMainMenuItemClick)
      then
        Parent.OnMainMenuItemClick(IDName);
      if MenuItem.Count <> 0
      then
        begin
          Parent.MenuActive := True;
          Parent.Repaint;
          if Assigned(MenuItem.OnClick) then MenuItem.OnClick(Parent);
          SetDown(True);
        end
      else
        begin
          if Parent.DSF.InMainMenu
          then
            Parent.DSF.SkinMainMenuClose;
          Parent.DSF.InMenu := False;
          if EnableMorphing then ReDraw else Parent.DrawSkinObject(Self);
          Menu := MenuItem.GetParentMenu;
          Menu.DispatchCommand(MenuItem.Command);
        end;
     end;
end;

constructor TspSkinMainMenuBar.Create(AOwner: TComponent);
begin
  inherited;

  FToolBarMode := False;
  FToolBarModeItemTransparent := False;

  FMergeMenu := nil;
  FScrollMenu := True;
  FUseSkinFont := True;
  FUseSkinSize := True;
  FSkinDataName := 'mainmenubar';
  FSkinSupport := False;
  Align := alTop;
  FDefaultHeight := 22;
  Height := 22;

  MouseTimer := TTimer.Create(Self);
  MouseTimer.Enabled := False;
  MouseTimer.OnTimer := TestMouse;
  MouseTimer.Interval := MouseTimerInterval;

  MorphTimer := TTimer.Create(Self);
  MorphTimer.Enabled := False;
  MorphTimer.OnTimer := TestMorph;
  MorphTimer.Interval := MorphTimerInterval;

  AnimateTimer := TTimer.Create(Self);
  AnimateTimer.Enabled := False;
  AnimateTimer.OnTimer := TestAnimate;
  AnimateTimer.Interval := AnimateTimerInterval;

  ObjectList := TList.Create;
  OldActiveObject := -1;
  ActiveObject := -1;
  MouseCaptureObject := -1;

  DSF := nil;
  MarkerActive := False;
  MenuActive := False;
  FPopupToUp := False;

  FMDIChildMax := False;
  ButtonsCount := 0;

  FDefItemFont := TFont.Create;
  with FDefItemFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
    Color := clBtnText;
  end;
end;

destructor TspSkinMainMenuBar.Destroy;
begin
  FDefItemFont.Free;
  ClearObjects;
  ObjectList.Free;
  MouseTimer.Free;
  MorphTimer.Free;
  AnimateTimer.Free;
  inherited;
end;

procedure TspSkinMainMenuBar.WMCHECKPARENTBG(var Msg: TWMEraseBkgnd);
begin
  if (FIndex <> -1) and (FSD.MainMenuBarTransparent)
  then
    RePaint;
end;

procedure TspSkinMainMenuBar.WMMOVE(var Msg: TWMMOVE); 
begin
  inherited;
  if (FIndex <> -1) and (FSD.MainMenuBarTransparent) and
     (Align = alNone)
  then
    RePaint;   
end;
procedure TspSkinMainMenuBar.Merge(Menu: TMainMenu);
begin
  FMergeMenu := Menu;
  UpdateItems;
end;

procedure TspSkinMainMenuBar.UnMerge;
begin
  FMergeMenu := nil;
  UpdateItems;
end;

procedure TspSkinMainMenuBar.TestAnimate(Sender: TObject);
var
  i: Integer;
  StopAnimate: Boolean;
begin
  StopAnimate := True;
  if ObjectList <> nil then 
  for i := 0 to ObjectList.Count  - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if EnableAnimation
          then
            begin
              if Active and (CurrentFrame <= FrameCount)
              then
                begin
                  Inc(CurrentFrame);
                  Draw(Canvas);
                  StopAnimate := False;
                end
              else
              if not Active and (CurrentFrame > 0)
              then
                begin
                  Dec(CurrentFrame);
                  Draw(Canvas);
                  StopAnimate := False;
                end;
            end;
      end;
  if StopAnimate
  then  AnimateTimer.Enabled := False;
end;

function TspSkinMainMenuBar.GetChildMainMenu: TMainMenu;
var
  i: Integer;
begin
  Result := nil;
  if FMergeMenu <> nil
  then
    Result := FMergeMenu
  else
  if (Application.MainForm <> nil) and (Application.MainForm.ActiveMDIChild <> nil)
  then
    with Application.MainForm.ActiveMDIChild do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i] is TMainMenu
        then
          begin
            Result := TMainMenu(Components[i]);
            Break;
          end;
      end;
    end;
end;

procedure TspSkinMainMenuBar.SetDefaultWidth;
begin
  FDefaultWidth := Value;
  if (FIndex = -1) and (FDefaultWidth > 0) then Width := FDefaultWidth;
end;

procedure TspSkinMainMenuBar.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;


procedure TspSkinMainMenuBar.SetDefItemFont;
begin
  FDefItemFont.Assign(Value);
  if FIndex = -1 then RePaint; 
end;

procedure TspSkinMainMenuBar.WMCloseSkinMenu;
begin
  CloseSysMenu;
end;

procedure TspSkinMainMenuBar.CloseSysMenu;
var
  i: Integer;
begin
  for i := 0 to ObjectList.Count - 1 do
  if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarButton then
  with TspSkinMainMenuBarButton(ObjectList.Items[i]) do
    if (Command = cmSysMenu) and FDown
    then
      begin
        if ActiveObject <> i
        then
          begin
            Active := False;
            FMouseIn := False;
          end;
        FDown := False;
        ReDraw;
      end;
end;

procedure TspSkinMainMenuBar.CheckButtons;
var
  i: Integer;
begin
  for i := 0 to ButtonsCount - 1 do
  with TspSkinMainMenuBarButton(ObjectList.Items[i]) do
  begin
    Enabled := True;
    case Command of
      cmMinimize: if not (biMinimize in BI) then Enabled := False;
      cmSysMenu: if not (biSystemMenu in BI) then Enabled := False;
    end;
  end;
end;

procedure TspSkinMainMenuBar.AddButtons;

procedure AddButton(ButtonName: String);
var
  ButtonData: TspDataSkinMainMenuBarButton;
  Index: Integer;
begin
  if (FSD = nil) or (FSD.Empty)
  then
    Index := -1
  else
    Index := FSD.GetIndex(ButtonName);
  if Index <> -1
  then
    ButtonData := TspDataSkinMainMenuBarButton(FSD.ObjectList.Items[Index])
  else
    ButtonData := nil;
  ObjectList.Insert(0, TspSkinMainMenuBarButton.Create(Self, ButtonData));
  with TspSkinMainMenuBarButton(ObjectList.Items[0]) do
  begin
    IDName := ButtonName;
  end;
  Inc(ButtonsCount);
end;

begin
  ButtonsCount := 0;
  if FIndex <> -1
  then
    begin
      AddButton(MinButton);
      AddButton(MaxButton);
      AddButton(CloseButton);
      AddButton(SysMenuButton);
    end
  else
    begin
      AddButton('MinButton');
      TspSkinMainMenuBarButton(ObjectList.Items[0]).Command := cmMinimize;
      AddButton('MaxButton');
      TspSkinMainMenuBarButton(ObjectList.Items[0]).Command := cmMaximize;
      AddButton('CloseButton');
      TspSkinMainMenuBarButton(ObjectList.Items[0]).Command := cmClose;
      AddButton('SysMenuButton');
      TspSkinMainMenuBarButton(ObjectList.Items[0]).Command := cmSysMenu;
    end;
end;

procedure TspSkinMainMenuBar.DeleteButtons;
var
  i: Integer;
begin
  for i := 0 to ButtonsCount - 1 do
  begin
    ActiveObject := -1;
    MouseCaptureObject := -1;
    TspMenuBarObject(ObjectList.Items[0]).Free;
    ObjectList.Delete(0);
  end;
  ButtonsCount := 0;
end;

procedure TspSkinMainMenuBar.MDIChildMaximize;
var
  DS: TspDynamicSkinForm;
begin
  if not FMDIChildMax
  then
    begin
      FMDIChildMax := True;
      OldActiveObject := -1;
      ActiveObject := -1;
      MouseCaptureObject := -1;
      AddButtons;
      DS := GetMDIChildDynamicSkinFormComponent;
      if DS <> nil then CheckButtons(DS.BorderIcons); 
      RePaint;
    end;
end;

procedure TspSkinMainMenuBar.MDIChildRestore;
var
  DS: TspDynamicSkinForm;
begin
  DS := GetMDIChildDynamicSkinFormComponent;
  if (DS = nil) and FMDIChildMax
  then
    begin
      FMDIChildMax := False;
      DeleteButtons;
      RePaint;
    end
  else
    if DS <> nil
    then CheckButtons(DS.BorderIcons);
end;

function TspSkinMainMenuBar.GetMarkerRect;
begin
  Result :=  Rect(NewItemsRect.Right - TRACKMARKEROFFSET, NewItemsRect.Top,
                  NewItemsRect.Right, NewItemsRect.Bottom);
end;

procedure TspSkinMainMenuBar.DrawMarker;
var
  C: TColor;
begin
  if FIndex <> -1
  then
    begin
      if MarkerActive
      then C := TrackMarkActiveColor
      else C := TrackMarkColor;
    end
  else
    begin
      if MarkerActive
      then C := clBtnText
      else C := clBtnShadow;
    end;
  DrawArrowImage(Cnvs, GetMarkerRect, C, 2);
end;

procedure TspSkinMainMenuBar.TrackScrollMenu;
var
  i, VisibleCount: Integer;
  R: TRect;
  P: TPoint;
  ChildMainMenu: TMainMenu;
begin
  if DSF = nil then Exit;
  VisibleCount := 0;
  for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Visible then Inc(VisibleCount);
      end;

  P := Point(NewItemsRect.Right, NewItemsRect.Top);
  P := ClientToScreen(P);
  R := Rect(P.X - TRACKMARKEROFFSET, P.Y,
            P.X, P.Y + RectHeight(NewItemsRect));

  if (DSF.FForm.FormStyle = fsMDIForm) or (FMergeMenu <> nil)
  then
    ChildMainMenu := GetChildMainMenu
  else
    ChildMainMenu := nil;

  DSF.SkinMenuOpen;

  if ChildMainMenu = nil
  then
    DSF.SkinMenu.Popup(nil, FSD, VisibleCount, R, FMainMenu.Items, False)
  else
    DSF.SkinMenu.Popup2(nil, FSD, VisibleCount, R, FMainMenu.Items, ChildMainMenu.Items, False);
end;

function TspSkinMainMenuBar.FindHotKeyItem;
var
  i: Integer;
begin
  Result := False;
  if (DSF <> nil) and (ObjectList <> nil) then 
  begin
    if not DSF.FForm.Visible then Exit;
    for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible and
           IsAccel(CharCode, MenuItem.Caption)
        then
          begin
            MouseEnter;
            if (not DSF.InMenu) or (MenuItem.Count = 0) then MouseDown(0, 0, mbLeft);
            Result := True;
            Break;
          end;
      end;
  end;
end;

procedure TspSkinMainMenuBar.NextMainMenuItem;

function IsEndItem(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if Index + 1 > ObjectList.Count - 1
  then
    Result := True
  else
  for i := Index + 1 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible then Result := False;
      end
end;

var
  i, j: Integer;
  EndI: Boolean;
  FirstItem: Integer;
begin
  EndI := False;
  FirstItem := -1;
  j := -1;

  for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible
        then
          begin
            if FirstItem = -1 then FirstItem := i;
            if (Active or FDown)
            then
              begin
                j := i;
                MouseLeave;
                EndI := IsEndItem(j);
                Break;
              end;
          end;
       end;   

  if j = -1
  then
    begin
      j := FirstItem;
      if j <> -1 then
        TspSkinMainMenuBarItem(ObjectList.Items[j]).MouseEnter;
    end
  else
    begin
      if EndI then j := 0 else j := j + 1;
      if j < ObjectList.Count then
      for i := j to ObjectList.Count - 1 do
      if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
      then
        with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
        begin
          if Enabled and Visible
          then
            begin
              MouseEnter;
              Break;
            end;
        end;    
    end;
end;

procedure TspSkinMainMenuBar.PriorMainMenuItem;

function IsEndItem(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if Index - 1 < 0
  then
    Result := True
  else
  for i := Index - 1 downto 0 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible then Result := False;
      end
end;

var
  i, j: Integer;
  EndI: Boolean;
  LastItem: Integer;
begin
  EndI := False;
  j := -1;
  LastItem := -1;

  for i := ObjectList.Count - 1 downto 0 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible
        then
          begin
            if LastItem = -1 then LastItem := i;
            if Active or FDown then
            begin
              j := i;
              MouseLeave;
              EndI := IsEndItem(j);
              Break;
            end;
          end;
      end;

  if j = -1
  then
    begin
      j := LastItem;
      if j <> -1 then
        TspSkinMainMenuBarItem(ObjectList.Items[j]).MouseEnter;
    end
  else
    begin
      if EndI then j := ObjectList.Count - 1 else j := j - 1;
      if j > -1 then
      for i := j downto 0 do
      if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
      then
       with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
       begin
         if Enabled and Visible
         then
           begin
             MouseEnter;
             Break;
           end;
       end;
    end;
end;

function TspSkinMainMenuBar.CheckReturnKey;
var
  i: Integer;
begin
  Result := False;
  if DSF <> nil then 
  for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if (FDown and (MenuItem.Count = 0)) or
           (Active and not DSF.InMenu)
        then
          begin
            Active := False;
            MouseDown(0, 0, mbLeft);
            Result := True;
            Break;
         end;
      end;
end;

procedure TspSkinMainMenuBar.MenuEnter;
var
  i: Integer;
  FirstItem: Integer;
begin
  FirstItem := -1;
  MenuActive := True;
  RePaint;
  for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
    then
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        if FirstItem = -1 then FirstItem := i;
        if Active
        then
          begin
            FirstItem := i;
            Break;
          end;
      end;
  if FirstItem <> -1
  then
    begin
      TspSkinMainMenuBarItem(ObjectList.Items[FirstItem]).MouseEnter;
      if DSF <> nil then
      with DSF do
      begin
        HookApp;
        InMainMenu := True;
        if Assigned(OnMainMenuEnter) then OnMainMenuEnter(Self);
      end;
    end;
end;

procedure TspSkinMainMenuBar.MenuClose;
var
  i: Integer;
begin
  for i := 0 to ObjectList.Count - 1 do
  if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem then
  begin
    with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
      if FDown then
       begin
         FDown := False;
         Active := True;
         if EnableMorphing then MorphKf := 1;
         DrawSkinObject(TspSkinMainMenuBarItem(ObjectList.Items[i]));
         Break;
       end;
  end;
end;

procedure TspSkinMainMenuBar.MenuExit;
var
  i: Integer;
begin
  MenuActive := False;
  RePaint;
  for i := 0 to ObjectList.Count - 1 do
    if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem then
    begin
      with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
        if FDown or Active then
        begin
          Active := False;
          FMouseIn := False;
          FDown := False;
          if EnableMorphing then MorphKf := 1;
          if EnableAnimation and not InActiveAnimation
          then
            begin
              CurrentFrame := 0;
              DrawSkinObject(TspSkinMainMenuBarItem(ObjectList.Items[i]));
            end
          else
            ReDraw;
          Break;
        end;
    end;
  ActiveObject := -1;
  OldActiveObject := -1;
end;

procedure TspSkinMainMenuBar.CalcRects;
var
  Off, OffY: Integer;
  i: Integer;
begin
  if FSkinSupport
  then
    begin
      Off := RectWidth(SkinRect) - ItemsRect.Right;
      NewItemsRect := Rect(ItemsRect.Left, ItemsRect.Top, Width - Off, ItemsRect.Bottom);
      if not FUseSkinSize
      then
        begin
          OffY := RectHeight(SkinRect) - ItemsRect.Bottom;
          NewItemsRect.Bottom := Height - OffY;
        end;
    end
  else
    NewItemsRect := Rect(2, 2, Width - 2, Height - 2);

  if FMDIChildMax and (ButtonsCount = 4)
  then
    begin
      if TspMenuBarObject(ObjectList.Items[0]) is TspSkinMainMenuBarButton
      then
        with TspSkinMainMenuBarButton((ObjectList.Items[0])) do
        begin
          if FSkinSupport
          then
            begin
              ObjectRect := Rect(NewItemsRect.Left,
                NewItemsRect.Top +
                RectHeight(NewItemsRect) div 2 - RectHeight(SkinRect) div 2,
                NewItemsRect.Left + RectWidth(SkinRect),
                NewItemsRect.Top +
                RectHeight(NewItemsRect) div 2 - RectHeight(SkinRect) div 2 +
                RectHeight(SkinRect));
              Inc(NewItemsRect.Left, RectWidth(SkinRect) + 2);
            end
          else
            begin
              ObjectRect := Rect(NewItemsRect.Left,
                                 NewItemsRect.Top,
                                 NewItemsRect.Left + RectHeight(NewItemsRect),
                                 NewItemsRect.Bottom);
              Inc(NewItemsRect.Left, RectHeight(NewItemsRect) + 2);
            end;
        end;
      for i := 1 to 3 do
      if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarButton
      then
        with TspSkinMainMenuBarButton((ObjectList.Items[i])) do
        begin
          if FSkinSupport
          then
            begin
              ObjectRect := Rect(NewItemsRect.Right - RectWidth(SkinRect),
                NewItemsRect.Top +
                RectHeight(NewItemsRect) div 2 - RectHeight(SkinRect) div 2,
                NewItemsRect.Right,
                NewItemsRect.Top +
                RectHeight(NewItemsRect) div 2 - RectHeight(SkinRect) div 2 +
                RectHeight(SkinRect));
              Dec(NewItemsRect.Right, RectWidth(SkinRect) + 2);
            end
          else
            begin
              ObjectRect := Rect(NewItemsRect.Right - RectHeight(NewItemsRect),
                                 NewItemsRect.Top,
                                 NewItemsRect.Right,
                                 NewItemsRect.Bottom);
              Dec(NewItemsRect.Right, RectHeight(NewItemsRect) + 2);
            end;
        end;
    end;
end;

procedure TspSkinMainMenuBar.DrawSkinObject;
begin
  if AObject is TspSkinMainMenuBarItem
  and (FIndex <> -1) and (ItemTransparent or (ToolBarMode and ToolBarModeItemTransparent))
  then
    begin
      RePaint;
    end
  else
  if AObject.Visible then AObject.Draw(Canvas);
end;

procedure TspSkinMainMenuBar.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinMainMenuBar
    then
      with TspDataSkinMainMenuBar(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.SkinRect := SkinRect;
        Self.ItemsRect := ItemsRect;
        Self.MenuBarItem := MenuBarItem;
        Self.CloseButton := CloseButton;
        Self.MaxButton := MaxButton;
        Self.MinButton := MinButton;
        Self.SysMenuButton := SysMenuButton;
        Self.TrackMarkColor := TrackMarkColor;
        Self.TrackMarkActiveColor := TrackMarkActiveColor;
        Self.StretchEffect := StretchEffect;
        Self.ItemTransparent := ItemTransparent;
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
      end;
end;

procedure TspSkinMainMenuBar.WMSize;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinMainMenuBar.CreateMenu;

function CompareValues(Item1, Item2: Pointer): Integer;
begin
  if TMenuItem(Item1).GroupIndex > TMenuItem(Item2).GroupIndex then Result := 1
  else if TMenuItem(Item1).GroupIndex < TMenuItem(Item2).GroupIndex then Result := -1
  else Result := 0; 
end;

var
  i, j: Integer;
  MMIData: TspDataSkinMainMenuBarItem;
  DS: TspDynamicSkinForm;
  ChildMainMenu: TMainMenu;
  miL: TList;
  HasExist: Boolean;
begin
  ClearObjects;

  if (DSF <> nil) and ((DSF.FForm.FormStyle = fsMDIForm) or (FMergeMenu <> nil))
  then
    ChildMainMenu := GetChildMainMenu
  else
    ChildMainMenu := nil;

  if (FMainMenu = nil) then Exit;

  if (FSD = nil) or (FSD.Empty)
  then
    MMIData := nil
  else
    begin
      j := FSD.GetIndex(MenuBarItem);
      if j <> -1
      then MMIData := TspDataSkinMainMenuBarItem(FSD.ObjectList.Items[j])
      else MMIData := nil;
    end;

   ChildMenuIn := ChildMainMenu <> nil;
  if ChildMenuIn and ScrollMenu then ScrollMenu := False;

  if ChildMainMenu = nil
  then
    begin
      for i := 0 to FMainMenu.Items.Count - 1 do
      if FMainMenu.Items[i].Visible
      then
        begin
          ObjectList.Add(TspSkinMainMenuBarItem.Create(Self, MMIData));
          with TspSkinMainMenuBarItem(ObjectList.Items[ObjectList.Count - 1]) do
          begin
            IDName := FMainMenu.Items[i].Name;
            Enabled := FMainMenu.Items[i].Enabled;
            MenuItem := FMainMenu.Items[i];
          end;
        end;
     end
   else
     begin
       miL := TList.Create;
       for i := 0 to FMainMenu.Items.Count - 1 do
       begin
         HasExist := False;
         for j := 0 to ChildMainMenu.Items.Count - 1 do
         begin
           if ChildMainMenu.Items[j].GroupIndex = FMainMenu.Items[i].GroupIndex
           then
             begin
               HasExist := True;
               Break;
             end;
         end;
         if not HasExist then miL.Add(FMainMenu.Items[i]);
       end;
       for i := 0 to ChildMainMenu.Items.Count - 1 do
         miL.Add(ChildMainMenu.Items[I]);
       miL.Sort(@CompareValues);
       for i := 0 to miL.Count - 1 do
         if TMenuItem(miL.Items[i]).Visible
         then
           begin
             ObjectList.Add(TspSkinMainMenuBarItem.Create(Self, MMIData));
             with TspSkinMainMenuBarItem(ObjectList.Items[ObjectList.Count - 1]) do
             begin
               IDName := TMenuItem(miL.Items[i]).Name;
               Enabled := TMenuItem(miL.Items[i]).Enabled;
               MenuItem := TMenuItem(miL.Items[i]);
             end;
           end;
        miL.Free;
     end;

  if Self.FMDIChildMax
  then
    begin
      AddButtons;
      DS := GetMDIChildDynamicSkinFormComponent;
      if DS <> nil then CheckButtons(DS.BorderIcons);
    end;
end;

procedure TspSkinMainMenuBar.SetMainMenu;
begin
  FMainMenu := Value;
  CreateMenu;
  RePaint;
end;

procedure TspSkinMainMenuBar.UpDateEnabledItems;
var
  i: Integer;
begin
  for i := 0 to ObjectList.Count - 1 do
  if TspMenuBarObject(ObjectList.Items[i]) is TspSkinMainMenuBarItem
  then
     with TspSkinMainMenuBarItem(ObjectList.Items[i]) do
       Enabled := MenuItem.Enabled;
  RePaint;
end;

procedure TspSkinMainMenuBar.UpDateItems;
begin
  CreateMenu;
  RePaint;
  ActiveObject := -1;
  OldActiveObject := -1;
  MouseTimer.Enabled := True;
end;


procedure  TspSkinMainMenuBar.ClearObjects;
var
  i: Integer;
begin
  for i := 0 to ObjectList.Count - 1 do
    TspMenuBarObject(ObjectList.Items[i]).Free;
  ObjectList.Clear;
  ButtonsCount := 0;
end;

procedure TspSkinMainMenuBar.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
  MouseTimer.Enabled := True;
end;

procedure TspSkinMainMenuBar.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
  MouseTimer.Enabled := False;
  TestActive(-1, -1);
end;

procedure TspSkinMainMenuBar.MouseDown;
begin
  inherited;
  TestActive(X, Y);
  if (ActiveObject <> - 1)
  then
    with TspMenuBarObject(ObjectList.Items[ActiveObject]) do
    begin
      MouseCaptureObject := ActiveObject;
      MouseDown(X, Y, Button);
      if ssDouble in Shift then DblCLick;
    end
  else
    if Scroll and FScrollMenu
    then
      begin
        if PtInRect(GetMarkerRect, Point(X, Y)) then TrackScrollMenu;
      end;
end;

procedure TspSkinMainMenuBar.MouseUp;
begin
  if (MouseCaptureObject <> -1)
  then
    begin
      TspMenuBarObject(ObjectList.Items[MouseCaptureObject]).MouseUp(X, Y, Button);
      MouseCaptureObject := -1;
    end;
  inherited;
end;

procedure TspSkinMainMenuBar.MouseMove;
begin
  if not MouseTimer.Enabled
  then MouseTimer.Enabled := True;
  inherited;
end;

procedure TspSkinMainMenuBar.BeforeChangeSkinData;
begin
  FSkinSupport := False;
  inherited;
  ClearObjects;
end;

procedure TspSkinMainMenuBar.ChangeSkinData;
begin
  GetSkinData;
  FSkinSupport := FIndex <> -1;
  CreateMenu;
  if FSkinSupport and FUseSkinSize
  then
    Height := RectHeight(SkinRect)
  else
    if FDefaultHeight > 0 then Height := FDefaultHeight;
  RePaint;
end;

procedure TspSkinMainMenuBar.TestActive;
var
  i: Integer;
  B: Boolean;
begin
  if ObjectList.Count = 0 then Exit;

  OldActiveObject := ActiveObject;
  i := -1;
  B := False;
  repeat
    Inc(i);
    with TspMenuBarObject(ObjectList.Items[i]) do
    begin
      if Enabled then B := PtInRect(ObjectRect, Point(X, Y));
    end;
  until B or (i = ObjectList.Count - 1);

  if not B and (OldActiveObject <> -1) and MenuActive and
     (TspMenuBarObject(ObjectList.Items[OldActiveObject]) is
      TspSkinMainMenuBarItem)
  then
    ActiveObject := OldActiveObject
  else
    if B then ActiveObject := i else ActiveObject := -1;

  if (MouseCaptureObject <> -1) and
     (ActiveObject <> MouseCaptureObject) and (ActiveObject <> -1)
  then
    ActiveObject := -1;

  if OldActiveObject >= ObjectList.Count then OldActiveObject := -1;
  if ActiveObject >= ObjectList.Count then ActiveObject := -1;

  if (OldActiveObject <> ActiveObject)
  then
    begin
      if OldActiveObject <> - 1
      then
        if TspMenuBarObject(ObjectList.Items[OldActiveObject]).Enabled
        then TspMenuBarObject(ObjectList.Items[OldActiveObject]).MouseLeave;
      if ActiveObject <> -1
      then
        if TspMenuBarObject(ObjectList.Items[ActiveObject]).Enabled
        then TspMenuBarObject(ObjectList.Items[ActiveObject]).MouseEnter;
    end;

  if Scroll and FScrollMenu
  then
    begin
      if PtInRect(GetMarkerRect, Point(X, Y)) and not MarkerActive
      then
        begin
          MarkerActive := True;
          DrawMarker(Canvas);
        end
      else
        if MarkerActive and not PtInRect(GetMarkerRect, Point(X, Y))
        then
          begin
            MarkerActive := False;
            DrawMarker(Canvas);
          end;  
    end;
end;

procedure TspSkinMainMenuBar.TestMouse;
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  if (P.X >= 0) and (P.Y >= 0) and (P.X <= Width) and (P.Y <= Height)
  then
    TestActive(P.X, P.Y)
  else
    if MouseTimer.Enabled
    then
      begin
        MouseTimer.Enabled := False;
        TestActive(-1, -1);
      end;
end;

procedure TspSkinMainMenuBar.TestMorph;
var
  i: Integer;
  StopMorph: Boolean;
begin
  StopMorph := True;
  for i := 0 to ObjectList.Count  - 1 do
    with TspMenuBarObject(ObjectList.Items[i]) do
    begin
      if EnableMorphing and CanMorphing
        then
          begin
            DoMorphing;
            StopMorph := False;
          end;
    end;
  if StopMorph
  then
  MorphTimer.Enabled := False;
end;

procedure TspSkinMainMenuBar.SetBounds;
begin
  GetSkinData;
  if (FIndex <> -1) and FUseSkinSize then AHeight := RectHeight(SkinRect);
  inherited;
  RePaint;
end;

procedure TspSkinMainMenuBar.PaintMenuToolBar;
var
  CIndex: Integer;
  PanelData: TspDataSkinPanelControl;
  PanelSkinPicture: TBitMap;
  PanelLtPoint, PanelRTPoint, PanelLBPoint, PanelRBPoint: TPoint;
  PanelCLRect: TRect;
  XO, YO: Integer;
begin
  CIndex := FSD.GetControlIndex('resizetoolpanel');
  if CIndex = -1 then CIndex := FSD.GetControlIndex('panel');
  if CIndex = -1 then Exit;
  PanelData := TspDataSkinPanelControl(FSD.CtrlList[CIndex]);
  with PanelData do
  begin
    PanelSkinPicture := TBitMap(SkinData.FActivePictures.Items[PanelData.PictureIndex]);
    XO := Width - RectWidth(SkinRect);
    YO := Height - RectHeight(SkinRect);
    PanelLTPoint := LTPoint;
    PanelRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    PanelLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    PanelRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    PanelClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
     PanelLtPoint, PanelRTPoint, PanelLBPoint, PanelRBPoint, PanelCLRect,
     B, PanelSkinPicture, SkinRect, B.Width, B.Height, True,
     LeftStretch, TopStretch, RightStretch, BottomStretch,
     StretchEffect, StretchType);
  end;
end;


procedure TspSkinMainMenuBar.PaintMenuBar(Cnvs: TCanvas);
var
  Buffer: TBitMap;
  R, CR: TRect;
  i: Integer;
begin
  GetSkinData;
  Buffer := TBitMap.Create;
  R := Rect(0, 0, Width, Height);
  if FIndex <> -1
  then
    begin
      if SkinData.MainMenuBarTransparent
      then
        begin
          Buffer.Width := Width;
          Buffer.Height := Height;
          GetParentImage(Self, Buffer.Canvas);
        end
      else
        begin
          if FUseSkinSize
          then
            CreateHSkinImage(ItemsRect.Left, RectWidth(SkinRect) - ItemsRect.Right,
             Buffer, Picture, SkinRect, Width, Height, StretchEffect)
          else
            begin
              Buffer.Width := Width;
              Buffer.Height := Height;
              CR := Rect(ItemsRect.Left, RectHeight(SkinRect) div 4, ItemsRect.Right,
              RectHeight(SkinRect) - RectHeight(SkinRect) div 4);
               if not FToolBarMode
              then
                CreateStretchImage(Buffer, Picture, SkinRect, CR, True)
              else
                PaintMenuToolBar(Buffer);
            end;
        end;   
    end
  else
    begin
      Buffer.Width := Width;
      Buffer.Height := Height;
      with Buffer.Canvas do
      begin
        Brush.Color := clBtnFace;
        FillRect(R);
      end;
    end;
  CalcRects;
  Scroll := False;
  for i := 0 to ObjectList.Count - 1 do
  with TspMenuBarObject(ObjectList.Items[i]) do
    begin
      if Visible then Draw(Buffer.Canvas);
    end;
  if Scroll and FScrollMenu then DrawMarker(Buffer.Canvas);
  Cnvs.Draw(0, 0, Buffer);
  Buffer.Free;
end;

procedure TspSkinMainMenuBar.Paint;
begin
end;

procedure TspSkinMainMenuBar.WMEraseBkgnd;
var
  Cnvs: TCanvas;
begin
  Cnvs := TCanvas.Create;
  Cnvs.Handle := TWMEraseBkgnd(Message).DC;
  PaintMenuBar(Cnvs);
  Cnvs.Free;
  Message.Result := 1;
end;

procedure TspSkinMainMenuBar.Notification(AComponent: TComponent;
                                          Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FMainMenu)
  then FMainMenu := nil;
    if (Operation = opRemove) and (AComponent = DSF)
  then DSF := nil;
end;

//============= TspDynamicSkinForm  =============//
type
  TParentForm = class(TForm);

constructor TspDynamicSkinForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF VER200}
  FUseRibbon := False;
  {$ENDIF}
  //
  FMenuTrackObject := nil;
  FUseSkinFontInCaption := True;
  FInMaximizeAll := False;
  FInRestoreAll := False;
  FShowMDIScrollBars := True;
  FMDIHScrollBar := nil;
  FMDIVScrollBar := nil;
  ChangeVisibleChildHanle := 0;
  FStopCheckChildMove := False;
  FOldHSrollBarPosition := 0;
  FOldVSrollBarPosition := 0;
  //
  FTileMode := tbHorizontal;
  FWindowStateInit := wsNormal;
  FWindowState := wsNormal;
  FNCDraggAble := True;
  DisableDWMAnimation := False;
  OldActive := False;
  FOldFullBorder := -1;
  FClientInActiveDraw := False;
  FInActivePanel := nil;
  FClientInActiveEffect := False;
  FClientInActiveEffectType := spieSemiTransparent;
  //
  FQuickButtons := TspQuickButtonItems.Create(Self);
  FQuickImageList := nil;
  FQuickButtonsShowHint := False;
  //
  FCaptionTabs := TspCaptionTabs.Create(Self);
  FCaptionTabsImageList := nil;
  FCaptionTabIndex := 0;
  FCaptionTabsVisible := False;
  FCaptionTabPos := sptpLeft;
  //
  FIsLayerEnabled :=  CheckW2KWXP;
  AlwaysDisableLayeredFrames := False;
  FSmartEffectsShow := False;
  FBorderLayerChangeSize := False;
  FBorderLayer := TspFormLayerBorder.Create(Self);
  FLayerManager := TspLayerManager.Create(Self);
  FMenuLayerManager := TspLayerManager.Create(Self);
  FDisableSystemMenu := False;
  FInAppHook := False;
  FSkinnableForm := True;
  FIsW7 := IsW7;
  FIsVistaOS := IsVistaOS;
  FHaveShadow := False;
  FRollUpBeforeMaximize := False;
  FStopPainting := False;
  FStartShow := True;
  FPositionInMonitor := sppDefault;
  HMagnetized := False;
  VMagnetized := False;
  HMagnetized2 := False;
  VMagnetized2 := False;
  FOnMouseDownCoord.X := -1;
  FOnMouseDownCoord.Y := -1;
  FMinimizeDefault := False;
  UseFormCursorInNCArea := False;
  FClientWidth := 0;
  FClientHeight := 0;
  PreviewMode := False;
  FHideCaptionButtons := False;
  FAlwaysShowInTray := False;
  FLogoBitMap := TBitMap.Create;
  FLogoBitMapTransparent := False;
  FAlwaysMinimizeToTray := False;
  FIcon := nil;
  FShowIcon := False;
  FSkinHint := nil;
  FMaximizeOnFullScreen := False;
  FSkinSupport := False;
  FShowObjectHint := False;
  FUseDefaultObjectHint := True;
  FUseSkinCursors := False;
  FDefCaptionFont := TFont.Create;
  FDefInActiveCaptionFont := TFont.Create;
  with FDefCaptionFont do
  begin
    Name := 'Tahoma';
    Style := [fsBold];
    Height := 13;
    Color := clBtnText;
  end;
  with FDefInActiveCaptionFont do
  begin
    Name := 'Tahoma';
    Style := [fsBold];
    Height := 13;
    Color := clBtnShadow;
  end;
  InMenu := False;
  InMainMenu := False;
  RMTop := TBitMap.Create;
  RMLeft := TBitMap.Create;
  RMBottom := TBitMap.Create;
  RMRight := TBitMap.Create;
  BlackColor := RGB(0, 0, 0);
  ObjectList := TList.Create;
  AreaList := TList.Create;
  VisibleControls := TList.Create;
  FSD := nil;
  FStatusBar := nil;
  FMSD := nil;
  FMainMenu := nil;
  FSystemMenu := nil;

  FInChangeSkinData := False;

  MorphTimer := TTimer.Create(Self);
  MorphTimer.Enabled := False;
  MorphTimer.OnTimer := TestMorph;
  MorphTimer.Interval := MorphTimerInterval;

  MouseTimer := TTimer.Create(Self);
  MouseTimer.Enabled := False;
  MouseTimer.OnTimer := TestMouse;
  MouseTimer.Interval := MouseTimerInterval;

  AnimateTimer := TTimer.Create(Self);
  AnimateTimer.Enabled := False;
  AnimateTimer.OnTimer := TestAnimate;
  AnimateTimer.Interval := AnimateTimerInterval;

  OldBoundsRect := NulLRect;

  OldActiveObject := -1;
  ActiveObject := -1;
  MouseCaptureObject := -1;
  MouseIn := False;
  FMinWidth := 0;
  FMinHeight := 0;
  FMaxWidth := 0;
  FMaxHeight := 0;
  FRGN := 0;

  FClientInstance := nil;
  FPrevClientProc := nil;

  try
   FForm := (Owner as TForm);
  except
   if Owner is TCustomForm then FForm := TForm(Owner) else raise;
  end;
  
  FForm.BorderIcons := [];
  FForm.OnShortCut := FormShortCut;
  FForm.AutoSize := False;
  FForm.AutoScroll := False;

  FSysMenu := TPopupMenu.Create(Self);
  FUseDefaultSysMenu := True;

  FSysTrayMenu := TspSkinPopupMenu.Create(Self);
  FSysTrayMenu.ComponentForm := FForm;
  CreateSysTrayMenu;

  SkinMenu := TspSkinMenu.CreateEx(Self, FForm);

  FMagneticSize := 10;

  FBorderIcons := [biSystemMenu, biMinimize, biMaximize, biRollUp];

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FMenusAlphaBlend := False;
  FMenusAlphaBlendValue := 200;
  FMenusAlphaBlendAnimation := False;

  FSupportNCArea := True;
  FSizeAble := True;

  FFullDrag := False;
  FSizeMove := False;
  FSizing := False;

  FFormWidth := 0;
  FFormHeight := 0;
  FFormLeft := 0;
  FFormTop := 0;
  FOldFormLeft := 0;
  FOldFormTop := 0;
  //
  FMenuButtonVisible := False;
  FMenuButtonCaption := '';
  FMenuButtonImageIndex := -1;
  FMenuButtonSpacing := 0;
  FMenuButtonMargin := -1;
  FMenuButtonWidth := 50;
  FMenuButtonPopupMenu := nil;
  FMenuButtonImageList := nil;
  //
  if FForm.FormStyle = fsMDIForm then InitMDIScrollBars;
  //

  FMainMenuBar := nil;
  FMDITabsBar := nil;

  FInShortCut := False;

  if not (csDesigning in ComponentState)
  then
   begin
     OldWindowProc := FForm.WindowProc;
     FForm.WindowProc := NewWndProc;
     TParentForm(FForm).ReCreateWnd;
     if not FIsVistaOs and ((FForm.FormStyle = fsMDIForm) or
                            (FForm.FormStyle = fsMDIChild))
     then
       SetWindowLong(FForm.Handle, GWL_STYLE,
         GETWINDOWLONG(FForm.Handle, GWL_STYLE) and not WS_CAPTION);
    end;
end;

destructor TspDynamicSkinForm.Destroy;
var
  i: Integer;
begin
  UnHookApp;
  //
  ClearObjects;
  //
  FCaptionTabs.Free;
  //
  FQuickButtons.Free;
  //
  if not (csDesigning in ComponentState) and (FForm <> nil)
  then
    FForm.WindowProc := OldWindowProc;

  FLogoBitMap.Free;

  FDefCaptionFont.Free;
  FDefInActiveCaptionFont.Free;

  FSysMenu.Free;
  FSysTrayMenu.Free;

  
  MorphTimer.Free;
  AnimateTimer.Free;
  MouseTimer.Free;
  ObjectList.Free;
  AreaList.Free;
  VisibleControls.Free;
  FBorderLayer.Free;
  FLayerManager.Free;
  FMenuLayerManager.Free;
  SkinMenu.Free;
  RMTop.Free;
  RMLeft.Free;
  RMBottom.Free;
  RMRight.Free;
  {
  if (FRgn <> 0) and Assigned(FForm) and (FForm.HandleAllocated)
  then
    SetWindowRgn(FForm.Handle, 0, True);
  }
  if FRgn <> 0 then DeleteObject(FRgn);
  if FIcon <> nil then FIcon.Free;
  inherited Destroy;
end;

procedure TspDynamicSkinForm.MenuButtonTrackMenu;
var
  MenuButton: TspSkinCaptionMenuButton;
begin
  MenuButton := GetCaptionMenuButton;
  if (MenuButton <> nil) and FMenuButtonVisible and (FMenuButtonPopupMenu <> nil) and
     not MenuButton.Down
  then
    begin
      MenuButton.MenuItem := MenuButtonPopupMenu.Items;
      if MainMenuBar <> nil then SkinMenuClose; 
      MenuButton.Down := True;
      MenuButton.TrackMenu;
    end;
end;

procedure TspDynamicSkinForm.SetMenuButtonVisible(Value: Boolean);
begin
  if Value <> FMenuButtonVisible
  then
    begin
      FMenuButtonVisible := Value;
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.SetMenuButtonWidth(Value: Integer);
begin
  if Value <> FMenuButtonWidth
  then
    begin
      FMenuButtonWidth := Value;
      if FMenuButtonVisible
         and not (csDesigning in ComponentState) 
         and not (csLoading in ComponentState)
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.SetMenuButtonCaption(Value: String);
begin
  if Value <> FMenuButtonCaption
  then
    begin
      FMenuButtonCaption := Value;
      if FMenuButtonVisible
         and not (csDesigning in ComponentState)
         and not (csLoading in ComponentState)
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.SetMenuButtonImageList(Value: TCustomImageList);
begin
  if Value <> FMenuButtonImageList
  then
    begin
      FMenuButtonImageList := Value;
      if FMenuButtonVisible and (FMenuButtonImageIndex <> -1) 
         and not (csDesigning in ComponentState)
         and not (csLoading in ComponentState)
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.SetMenuButtonImageIndex(Value: Integer);
begin
  if Value <> FMenuButtonImageIndex
  then
    begin
      FMenuButtonImageIndex := Value;
      if FMenuButtonVisible
         and not (csDesigning in ComponentState)
         and not (csLoading in ComponentState)
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.Move(AX, AY: Integer);
begin
  if CanShowBorderLayer and FBorderLayer.FVisible and (not IsNullRect(FBorderLayer.FData.BorderRect) or
    (FBorderLayer.FData.FullBorder))
  then
   begin
     AX := AX + FBorderLayer.LeftSize;
     AY := AY + FBorderLayer.TopSize;
   end;
  FForm.SetBounds(AX, AY, FForm.Width, FForm.Height); 
end;

procedure TspDynamicSkinForm.SetBounds(AX, AY, AWidth, AHeight: Integer);
begin
  if CanShowBorderLayer and FBorderLayer.FVisible and (not IsNullRect(FBorderLayer.FData.BorderRect) or
    (FBorderLayer.FData.FullBorder))
  then
    begin
      AX := AX + FBorderLayer.LeftSize;
      AY := AY + FBorderLayer.TopSize;
      AWidth := AWidth - FBorderLayer.LeftSize - FBorderLayer.RightSize;
      AHeight := Aheight - FBorderLayer.TopSize - FBorderLayer.BottomSize;
    end;
  FForm.SetBounds(AX, AY, AWidth, AHeight);
end;


procedure TspDynamicSkinForm.OnVScrollBarLastChange;
var
  Offset: Integer;
begin
  Offset := FMDIVScrollBar.Position - FOldVSrollBarPosition;
  if Offset <> 0 then MDIVScroll(-Offset);
  FOldVSrollBarPosition := FMDIVScrollBar.Position;
end;

procedure TspDynamicSkinForm.OnHScrollBarUpButtonClick(Sender: TObject);
begin
  FMDIHScrollBar.Position := FMDIHScrollBar.Position + 10;
  OnHScrollBarLastChange(Sender);
end;

procedure TspDynamicSkinForm.OnHScrollBarDownButtonClick(Sender: TObject);
begin
  FMDIHScrollBar.Position := FMDIHScrollBar.Position - 10;
  OnHScrollBarLastChange(Sender);
end;

procedure TspDynamicSkinForm.OnVScrollBarUpButtonClick(Sender: TObject);
begin
  FMDIVScrollBar.Position := FMDIVScrollBar.Position + 10;
  OnVScrollBarLastChange(Sender);
end;

procedure TspDynamicSkinForm.OnVScrollBarDownButtonClick(Sender: TObject);
begin
  FMDIVScrollBar.Position := FMDIVScrollBar.Position - 10;
  OnVScrollBarLastChange(Sender);
end;


procedure TspDynamicSkinForm.OnHScrollBarLastChange;
var
  Offset, Pos: Integer;
begin
  Offset := FMDIHScrollBar.Position - FOldHSrollBarPosition;
  if Offset <> 0 then MDIHScroll(-Offset);
  FOldHSrollBarPosition := FMDIHScrollBar.Position;
end;

procedure TspDynamicSkinForm.MDIHScroll(AOffset: Integer);
var
  i: Integer;
begin
  FStopCheckChildMove := True;
  for i := 0 to FForm.MDIChildCount -1 do
  begin
    if FForm.MDIChildren[i].Visible
    then
      FForm.MDIChildren[i].Left := FForm.MDIChildren[i].Left + AOffset;
  end;
  FStopCheckChildMove := False;
  GetMDIScrollInfo(False);
end;

procedure TspDynamicSkinForm.MDIVScroll(AOffset: Integer);
var
  i: Integer;
begin
  FStopCheckChildMove := True;
  for i := 0 to FForm.MDIChildCount -1 do
  begin
    if FForm.MDIChildren[i].Visible
    then
      FForm.MDIChildren[i].Top := FForm.MDIChildren[i].Top + AOffset;
  end;
  FStopCheckChildMove := False;
  GetMDIScrollInfo(False);
end;

procedure TspDynamicSkinForm.GetMDIScrollInfo;
var
  i, MinX, MinY, MaxX, MaxY, HPage, VPage, SPos, SPage: Integer;
  R: TRect;
  ReCalcInfo: Boolean;
  FCanHScrollVisible, FCanVScrollVisible: Boolean;
begin
  if (FMDIHScrollBar = nil) or (FMDIVScrollBar = nil) then Exit;
  if FMDIChildMaximized or not FShowMDIScrollBars
  then
    begin
      if FMDIHScrollBar.Visible then FMDIHScrollBar.Visible := False;
      if FMDIVScrollBar.Visible then FMDIVScrollBar.Visible := False;
      Exit;
    end;
  ReCalcInfo := False;
  R := GetMDIWorkArea;
  //
  MinX := 100000;
  MinY := 100000;
  MaxX := -100000;
  MaxY := -100000;
  for i := 0 to FForm.MDIChildCount -1 do
   if (FForm.MDIChildren[i].Visible) and (FForm.MDIChildren[i].Handle <> ChangeVisibleChildHanle)
   then
     begin
       if MinX > FForm.MDIChildren[i].Left then MinX := FForm.MDIChildren[i].Left;
       if MinY > FForm.MDIChildren[i].Top then MinY := FForm.MDIChildren[i].Top;
       if MaxX < FForm.MDIChildren[i].Left + FForm.MDIChildren[i].Width
       then MaxX := FForm.MDIChildren[i].Left + FForm.MDIChildren[i].Width;
       if MaxY < FForm.MDIChildren[i].Top + FForm.MDIChildren[i].Height
       then MaxY := FForm.MDIChildren[i].Top + FForm.MDIChildren[i].Height;
     end;
  //
  FCanHScrollVisible := (MinX < 0) or (MaxX > RectWidth(R));
  FCanVScrollVisible := (MinY < 0) or (MaxY > RectHeight(R));
  //
  if FCanVScrollVisible and not FCanHScrollVisible
  then
    begin
      FCanHScrollVisible := (MinX < 0) or (MaxX > RectWidth(R) - FMDIVScrollBar.Width);
    end;
  if FCanHScrollVisible and not FCanVScrollVisible
  then
    begin
      FCanVScrollVisible := (MinY < 0) or (MaxY > RectHeight(R) - FMDIHScrollBar.Height);
    end;
  //
  if FCanHScrollVisible and not FMDIHScrollBar.Visible
  then
    begin
      FMDIHScrollBar.SetBounds(R.Left, R.Bottom - FMDIHScrollBar.Height,
        RectWidth(R), FMDIHScrollBar.Height);
      FMDIHScrollBar.Visible := True;
      ReCalcInfo := True;
    end
  else
  if not FCanHScrollVisible and FMDIHScrollBar.Visible
  then
    begin
      FMDIHScrollBar.Visible := False;
      ReCalcInfo := True;
    end;
  //
  if FCanVScrollVisible and not FMDIVScrollBar.Visible
  then
    begin
      //
      if FCanHScrollVisible
      then
        FMDIVScrollBar.SetBounds(R.Right - FMDIVScrollBar.Width,
          R.Top, FMDIVScrollBar.Width, RectHeight(R) - FMDIHScrollBar.Height)
      else
        FMDIVScrollBar.SetBounds(R.Right - FMDIVScrollBar.Width,
          R.Top, FMDIVScrollBar.Width, RectHeight(R));
      FMDIVScrollBar.Visible := True;
      ReCalcInfo := True;
    end
  else
  if not FCanVScrollVisible and FMDIVScrollBar.Visible
  then
    begin
      FMDIVScrollBar.Visible := False;
      ReCalcInfo := True;
    end;

  HPage := RectWidth(R);
  VPage := RectHeight(R);

  AdjustMDIScrollBars;

  if FMDIHScrollBar.Visible
  then
    begin
       if MinX > 0 then MinX := 0;
       if MaxX < RectWidth(R) then MaxX := RectWidth(R);

       if ASetRange
       then
         begin
           if FMDIVScrollBar.Visible
           then
             FMDIHScrollBar.SetRange(0, MaxX - MinX - 1, -MinX, HPage - FMDIVScrollBar.Width)
           else
             FMDIHScrollBar.SetRange(0, MaxX - MinX - 1, -MinX, HPage);
           FOldHSrollBarPosition := FMDIHScrollBar.Position;
         end;
        FMDIHScrollBar.LargeChange := FMDIHScrollBar.PageSize;
      end;

  if FMDIVScrollBar.Visible
  then
    begin
      if MinY > 0 then MinY := 0;
      if MaxY < RectHeight(R) then MaxY := RectHeight(R);
      if ASetRange
       then
         begin
           if FMDIHScrollBar.Visible
           then
             FMDIVScrollBar.SetRange(0, MaxY - MinY - 1, -MinY, VPage - FMDIHScrollBar.Height)
           else
             FMDIVScrollBar.SetRange(0, MaxY - MinY - 1, -MinY, VPage);
           FOldVSrollBarPosition := FMDIVScrollBar.Position;
         end;
      FMDIVScrollBar.LargeChange := FMDIVScrollBar.PageSize;   
    end;

  if (not FMDIVScrollBar.Visible) and (not FMDIHScrollBar.Visible) then ReCalcInfo := False;

  if ReCalcInfo then GetMDIScrollInfo(ASetRange);
end;

procedure TspDynamicSkinForm.InitMDIScrollBars;
begin
  if csDesigning in ComponentState then Exit;
  //
  if FMDIHScrollBar = nil
  then
    begin
      FMDIHScrollBar := TspSkinScrollBar.Create(Self);
      with FMDIHScrollBar do
      begin
        Kind := sbHorizontal;
        Height := 17;
        SkinDataName := 'hscrollbar';
        SkinData := Self.SkinData;
        FOldHSrollBarPosition := 0;
        OnUpButtonClick := OnHScrollBarUpButtonClick;
        OnDownButtonClick := OnHScrollBarDownButtonClick;
        OnPageUp := OnHScrollBarLastChange;
        OnPageDown := OnHScrollBarLastChange;
        OnLastChange := OnHScrollBarLastChange;
        Visible := False;
        Parent := Self.FForm;
      end;
    end;
  if FMDIVScrollBar = nil
  then
    begin
      FMDIVScrollBar := TspSkinScrollBar.Create(Self);
      with FMDIVScrollBar do
      begin
        Kind := sbVertical;
        Width := 17;
        SkinDataName := 'vscrollbar';
        SkinData := Self.SkinData;
        OnUpButtonClick := OnVScrollBarUpButtonClick;
        OnDownButtonClick := OnVScrollBarDownButtonClick;
        OnPageUp := OnVScrollBarLastChange;
        OnPageDown := OnVScrollBarLastChange;
        OnLastChange := OnVScrollBarLastChange;
        FOldVSrollBarPosition := 0;
        Visible := False;
        Parent := Self.FForm;
      end;
    end;
end;

procedure TspDynamicSkinForm.AdjustMDIScrollBars;
var
  R: TRect;
begin
  if not (((FMDIHScrollBar <> nil) and (FMDIHScrollBar.Visible)) or
         ((FMDIVScrollBar <> nil) and (FMDIVScrollBar.Visible)))
  then
    Exit;
    
  if FForm.FormStyle <> fsMDIForm then Exit;

  R := GetMDIWorkArea;

  if (FMDIHScrollBar <> nil) and (FMDIHScrollBar.Visible)
  then
    begin
      if (FMDIVScrollBar <> nil) and (FMDIVScrollBar.Visible) and
         not FMDIHScrollBar.Both
      then
        FMDIHScrollBar.Both := True
      else
      if (FMDIVScrollBar <> nil) and (not FMDIVScrollBar.Visible) and
         FMDIHScrollBar.Both
      then
        FMDIHScrollBar.Both := False;
      FMDIHScrollBar.SetBounds(R.Left, R.Bottom - FMDIHScrollBar.Height,
        RectWidth(R), FMDIHScrollBar.Height)
    end;

  if (FMDIVScrollBar <> nil) and (FMDIVScrollBar.Visible)
  then
    begin
      if (FMDIHScrollBar <> nil) and (FMDIHScrollBar.Visible)
      then
        FMDIVScrollBar.SetBounds(R.Right - FMDIVScrollBar.Width,
          R.Top, FMDIVScrollBar.Width, RectHeight(R) - FMDIHScrollBar.Height)
      else
        FMDIVScrollBar.SetBounds(R.Right - FMDIVScrollBar.Width,
          R.Top, FMDIVScrollBar.Width, RectHeight(R));
    end;

end;

procedure TspDynamicSkinForm.Loaded;
begin
  inherited;
  if (FWindowStateInit <> FWindowState) and not (csDesigning in ComponentState) and
     FSupportNCArea
  then
    WindowState := FWindowStateInit;
end;

procedure TspDynamicSkinForm.OnAppRestore(Sender: TObject);
begin
  CheckAppLayeredBorders;
end;

procedure TspDynamicSkinForm.CheckAppLayeredBorders;

function IsAnotherWindowShowing: Boolean;
var
  j: Integer;
begin
  Result := False;
  for j := 0 to Screen.FormCount - 1 do
   if (not (Screen.Forms[j] is TspFormLayerWindow)) and
           (Screen.Forms[j] <> Application.MainForm) and
           (Screen.Forms[j].Visible) and (Screen.Forms[j].FormStyle <> fsStayOnTop) and
           (Screen.Forms[j].FormStyle <> fsMDIChild)
   then
     begin
       Result := True;
       Break;
     end;
end;

var
 i: Integer;
begin
  if (FForm = Application.MainForm) and (FSD <> nil) and (FSD.ShowLayeredBorders) and
     CanShowBorderLayer and IsAnotherWindowShowing
  then
    begin
      for i := 0 to Screen.FormCount - 1 do
        if (not (Screen.Forms[i] is TspFormLayerWindow)) and
           (Screen.Forms[i] <> Application.MainForm) and Screen.Forms[i].Visible and
           (Screen.Forms[i].FormStyle <> fsStayOnTop) and
           (Screen.Forms[i].FormStyle <> fsMDIChild)
        then
          Screen.Forms[i].Show;
      if FForm.Visible then FForm.Show;
    end;
end;

procedure TspDynamicSkinForm.SetWindowState(Value: TWindowState);
begin
  FWindowStateInit := Value;
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState)
  then
    begin
      WindowState_Temp := FWindowStateInit;
      FWindowStateInit := FWindowState;
    end;
end;


function TspDynamicSkinForm.CheckIconAlpha: Boolean;
var
  i, j: Integer;
  w, h: Integer;
  Bmp: TspBitMap;
  C: PspColor;
begin
  GetIconSize(w, h);
  Result := False;
  if (w = 0) or (h = 0) then  Exit;
  Bmp := TspBitMap.Create;
  Bmp.SetSize(w, h);
  Bmp.AlphaBlend := True;
  Bmp.SetAlpha(0);
  DrawFormIcon(Bmp.Canvas, 0, 0);
  for i := 0 to Bmp.Width - 1 do
  for j := 0 to Bmp.Height - 1 do
  begin
    C := Bmp.PixelPtr[i, j];
    if TspColorRec(C^).A <> 0
    then
      begin
        Result := True;
        Bmp.Free;
        Exit;
      end;
  end;
  Bmp.Free;
end;


procedure TspDynamicSkinForm.SetQuickButtons(Value: TspQuickButtonItems);
begin
  FQuickButtons.Assign(Value);
end;

procedure TspDynamicSkinForm.SetCaptionTabs(Value: TspCaptionTabs);
begin
  FCaptionTabs.Assign(Value);
end;

procedure TspDynamicSkinForm.SetCaptionTabPos(Value: TspCaptionTabPos);
begin
  if FCaptionTabPos <> Value
  then
    begin
      FCaptionTabPos := Value;
      if (CaptionTabs.Count > 0) and
         not (csDesigning in ComponentState) and not (csLoading in ComponentState) 
      then
        UpDateFormNC;
    end;
end;

procedure TspDynamicSkinForm.SetCaptionTabIndex(Value: Integer);
begin
  if (FCaptionTabIndex <> Value) and (Value >= 0)
  then
    begin
      FCaptionTabIndex := Value;
      if FCaptionTabIndex > FCaptionTabs.Count - 1 then FCaptionTabIndex := FCaptionTabs.Count - 1;
      if FCaptionTabIndex < 0 then FCaptionTabIndex := 0;
      if not (csDesigning in ComponentState) and not (csLoading in ComponentState)
      then
        begin
          UpdateFormNC;
          if Assigned(FOnCaptionTabChange) then FOnCaptionTabChange(Self);
        end;
    end;
end;

function TspDynamicSkinForm.IsSizeAble: Boolean;
begin
  Result := FSizeAble or
            (FForm.BorderStyle = bsSizeAble) or
            (FForm.BorderStyle = bsSizeToolWin);
end;

procedure TspDynamicSkinForm.CheckStayOnTopWindows;
var
  i: Integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  begin
    if (Screen.Forms[i].FormStyle = fsStayOnTop) and (Screen.Forms[i].Visible)
        and not (Screen.Forms[i] is TspFormLayerWindow)
    then
      begin
        SetForegroundWindow(Screen.Forms[i].Handle);
      end;
  end;
end;

function TspDynamicSkinForm.CheckVista: Boolean;
begin
  Result := FIsVistaOS and CanShowBorderLayer and not FAlphaBlend and
  not (FAlphaBlendAnimation or ((FSD <> nil) and FSD.AnimationForAllWindows));
end;

function TspDynamicSkinForm.CanShowBorderLayer: Boolean;
begin
  Result := (FSD <> nil) and not (FSD.Empty) and FSD.ShowLayeredBorders and
            (FSD.LayerFrame.PictureIndex <> -1) and FIsLayerEnabled and FSkinnableForm and
            not AlwaysDisableLayeredFrames;
  if Result and (Self.PreviewMode) then Result := False;
  if Result and (FForm.BorderStyle = bsNone) and SupportNCArea then Result := False;
  if Result and (FForm.FormStyle = fsMDIChild) then Result := False;
  if Result and FSmartEffectsShow then Result := False;
end;

{$IFDEF VER200}
procedure TspDynamicSkinForm.SetUseRibbon;
begin
  FUseRibbon := Value;
  if not (csDesigning in ComponentState)
  then
    begin
      if FUseRibbon then
      Self.SetSkinnableForm(False);
    end;
end;
{$ENDIF}


function TspDynamicSkinForm.GetSkinnableForm: Boolean;
begin
  Result := FSkinnableForm;
end;

procedure TspDynamicSkinForm.SetSkinnableForm(Value: Boolean);
var
  WasMax: Boolean;
begin
  {$IFDEF VER200}
  if FUseRibbon then Value := False;
  {$ENDIF}
  WasMax := False;
  FFormActive := Self.GetFormActive;
{  if Value <> FSkinnableForm
  then}
    begin
      if (FForm.FormStyle = fsMDIForm)
      then
        begin
          if FForm.MDIChildCount <> 0 then Exit;
        end;
      if not (csDesigning in ComponentState)
      then
        begin
          if (WindowState = wsMaximized) and FSkinnableForm
          then
            begin
              if FForm.FormStyle <> fsMDIForm then FForm.Visible := False;
              WindowState := wsNormal;
              WasMax := True;
            end
          else
          if (FForm.WindowState = wsMaximized) and not FSkinnableForm
          then
            begin
              FForm.WindowState := wsNormal;
              if FForm.FormStyle <> fsMDIForm then FForm.Visible := False;
              WasMax := True;
            end;

          FSkinnableForm := Value;
          ChangeSkinData;
          UpDateSkinControls(0, FForm);

          if (FForm.FormStyle = fsMDIForm)
          then
            begin
              if FPrevClientProc = nil
              then
                FPrevClientProc := Pointer(GetWindowLong(FForm.ClientHandle, GWL_WNDPROC))
              else
                begin
                  FForm.WindowProc := NewWndProc;
                  TParentForm(FForm).ReCreateWnd;
                end;  
              FClientInstance := MakeObjectInstance(FormClientWindowProcHook);
              SetWindowLong(FForm.ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
              UpDateForm;
            end
          else
            begin
              FForm.WindowProc := NewWndProc;
              {$IFDEF VER185}
              if not FSkinnableForm and FIsVistaOs
              then
                TParentForm(FForm).ReCreateWnd
              else
                TParentForm(FForm).Refresh;
              {$ELSE}
              {$IFDEF VER200}
              if not FSkinnableForm and FIsVistaOs
              then
                TParentForm(FForm).ReCreateWnd;
              {$ENDIF}
              {$IFNDEF VER200}
              TParentForm(FForm).Refresh;
              {$ENDIF}
              {$ENDIF}
            end;  

           if WasMax and not FSkinnableForm
           then
            begin
              FForm.WindowState := wsMaximized;
              if FForm.FormStyle <> fsMDIForm then FForm.Visible := True;
            end
          else
          if WasMax and FSkinnableForm
          then
            begin
              Self.WindowState := wsMaximized;
              if FForm.FormStyle <> fsMDIForm then FForm.Visible := True;
            end; 
             
        end;
    end;
end;

procedure TspDynamicSkinForm.LoadBorderIcons;
var
  FFormBorderIcons: TBorderIcons;
begin
  if Self.FHideCaptionButtons or FSkinnableForm
  then
    FFormBorderIcons  :=  FFormBorderIcons   - [TBorderIcon(biSystemMenu)]
  else
     FFormBorderIcons  :=  FFormBorderIcons  + [TBorderIcon(biSystemMenu)];
 
  if  TspBorderIcon(biMaximize) in Self.BorderIcons
  then
    FFormBordericons :=  FFormBordericons  + [TBorderIcon(biMaximize)]
  else
    FFormBordericons :=  FFormBordericons  - [TBorderIcon(biMaximize)];

  if  TspBorderIcon(biMinimize) in Self.BorderIcons
  then
    FFormBordericons :=  FFormBordericons  + [TBorderIcon(biMinimize)]
  else
    FFormBordericons :=  FFormBordericons  - [TBorderIcon(biMinimize)];
  FFormBorderIcons := FFormBorderIcons - [TBorderIcon(biHelp)];
  FForm.BorderIcons := FFormBorderIcons;
end;

procedure TspDynamicSkinForm.CheckControlsBackground;
var
  i: Integer;
begin
  for i := 0 to FForm.ControlCount - 1 do
  begin
    if FForm.Controls[i] is TWinControl
    then
      SendMessage(TWinControl(FForm.Controls[i]).Handle, WM_CHECKPARENTBG, 0, 0);
  end;
end;

function TspDynamicSkinForm.GetAreaRect(AIDName: String): TRect;
var
  i: integer;
begin
  Result := Rect(0, 0, 0, 0);
  if (FSD <> nil) and not FSD.Empty
  then
    begin
      for i := 0 to FSD.AreaList.Count - 1 do
      with TspDataSkinArea(FSD.AreaList[i]) do
        if IDName = AIDName  then  Result := AreaRect;
    end;
end;

procedure TspDynamicSkinForm.CancelMessageToControls;
var
  i: Integer;
begin
  if (ComponentState = []) and (FForm.FormStyle = fsMDIForm)
     and (FForm.Visible)
  then
    begin
      for i := 0 to FForm.ComponentCount - 1 do
      begin
        if (
           (FForm.Components[i] is TspSkinControl) or
           (FForm.Components[i] is TspSkinCustomEdit) or
           (FForm.Components[i] is TFrame)
            ) and
           (TControl(FForm.Components[i]).Visible) and
           (TControl(FForm.Components[i]).Enabled)
         then
           SendMessage(TWinControl(FForm.Components[i]).Handle, CM_CANCELMODE, 0, 0);
      end;
    end;
end;

procedure TspDynamicSkinForm.ApplyPositionInMonitor;
var
  R: TRect;
  X, Y: Integer;
begin
  if FPositionInMonitor = sppDefault then Exit;
  if FPositionInMonitor = sppDesktopCenter
  then
    R := GetMonitorWorkArea(FForm.Handle, True)
  else
    R := GetMonitorWorkArea(FForm.Handle, False);
  X := R.Left + RectWidth(R) div 2 - FForm.Width div 2;
  Y := R.Top + RectHeight(R) div 2 - FForm.Height div 2;
  FForm.SetBounds(X, Y, FForm.Width, FForm.Height);
end;

function TspDynamicSkinForm.GetPositionInMonitor;
var
  R: TRect;
begin
  if FPositionInMonitor = sppDefault
  then
    begin
      Result.X := AX;
      Result.Y := AY;
      Exit;
    end;
  if FPositionInMonitor = sppDesktopCenter
  then
    R := GetMonitorWorkArea(FForm.Handle, True)
  else
    R := GetMonitorWorkArea(FForm.Handle, False);
  Result.X := R.Left + RectWidth(R) div 2 - AW div 2;
  Result.Y := R.Top + RectHeight(R) div 2 - AH div 2;
end;

function TspDynamicSkinForm.GetProductVersion: String;
begin
  Result := DSF_PRODUCT_VERSION;
end;

procedure  TspDynamicSkinForm.CheckMDIBar;
var
  DS: TspDynamicSkinForm;
begin
  DS := GetDynamicSkinFormComponent(Application.MainForm);
  if (DS <> nil) and (DS.MDITabsBar <> nil)
  then
    DS.MDITabsBar.CheckActive;
end;

procedure TspDynamicSkinForm.PopupSystemMenu;
var
  i: Integer;
  P: TPoint;
  R: TRect;
begin
  if ObjectList.Count = 0 then Exit;
  
  for i := 0 to ObjectList.Count  - 1 do
  begin
    if (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject) and
       (TspSkinAnimateObject(ObjectList.Items[i]).Command = cmSysMenu) and
       (TspSkinAnimateObject(ObjectList.Items[i]).Enabled)
    then
      begin
        with TspSkinAnimateObject(ObjectList.Items[i]) do
        begin
          R := ObjectRect;
           if Parent.FForm.FormStyle = fsMDIChild
           then
             begin
               if FSkinSupport
               then
                 P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
               else
                 P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
               P := Parent.FForm.ClientToScreen(P);
               OffsetRect(R, P.X, P.Y);
             end
           else
             OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
          if not FDisableSystemMenu then
            TrackSystemMenu2(R);
        end;
      end
    else
    if (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinStdButtonObject) and
       (TspSkinStdButtonObject(ObjectList.Items[i]).Command = cmSysMenu) and
       (TspSkinStdButtonObject(ObjectList.Items[i]).Enabled)
    then
      begin
        with TspSkinStdButtonObject(ObjectList.Items[i]) do
        begin
           R := ObjectRect;
           if Parent.FForm.FormStyle = fsMDIChild
           then
             begin
               if FSkinSupport
               then
                 P := Point(-Parent.NewClRect.Left, -Parent.NewClRect.Top)
               else
                 P := Point(- 3, -Parent.GetDefCaptionHeight - 3);
               P := Parent.FForm.ClientToScreen(P);
               OffsetRect(R, P.X, P.Y);
             end
           else
             OffsetRect(R, Parent.FForm.Left, Parent.FForm.Top);
          if not FDisableSystemMenu then
            TrackSystemMenu2(R);
        end;
      end;
  end;
end;

procedure TspDynamicSkinForm.DoPopupMenu;
var
  R: TRect;
begin
  if Assigned(Menu.OnPopup) then Menu.OnPopup(Self);
  if SkinMenu.Visible then SkinMenuClose;
  SkinMenuOpen;
  R := Rect(X, Y, X, Y);
  SkinMenu.Popup(nil, FSD, 0, R, Menu.Items, False);
end;

function TspDynamicSkinForm.GetRealHeight;
begin
  if Self.RollUpState
  then
    Result := OldHeight
  else
    Result := FFormHeight;
end;

procedure  TspDynamicSkinForm.CheckMDIMainMenu;
var
  DS: TspDynamicSkinForm;
begin
  DS := GetDynamicSkinFormComponent(Application.MainForm);
  if (DS <> nil) and (DS.MainMenuBar <> nil) and
     ((DS.MainMenuBar.GetChildMainMenu <> nil) or DS.MainMenuBar.ChildMenuIn)
  then
    DS.MainMenuBar.UpDateItems;
end;

procedure TspDynamicSkinForm.SetLogoBitMap;
begin
  FLogoBitMap.Assign(Value);
end;

procedure TspDynamicSkinForm.DrawLogoBitMap(C: TCanvas);
var
  X, Y: Integer;
begin
  X := FForm.ClientWidth div 2 - FLogoBitMap.Width div 2;
  Y := FForm.ClientHeight div 2 - FLogoBitMap.Height div 2;
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;
  if FLogoBitMap.Transparent <> FLogoBitmapTransparent
  then
    FLogoBitmap.Transparent := FLogoBitmapTransparent;
  C.Draw(X, Y, FLogoBitMap);
end;

function TspDynamicSkinForm.GetUseSkinSizeInMenu: Boolean;
begin
  Result := SkinMenu.UseSkinSize;
end;

procedure TspDynamicSkinForm.SetUseSkinSizeInMenu(Value: Boolean);
begin
  SkinMenu.UseSkinSize := Value;
end;

function TspDynamicSkinForm.GetUseSkinFontInMenu: Boolean;
begin
  Result := SkinMenu.UseSkinFont;
end;

procedure TspDynamicSkinForm.SetUseSkinFontInMenu(Value: Boolean);
begin
  SkinMenu.UseSkinFont := Value;
end;

procedure TspDynamicSkinForm.UpDateFormNC;
begin
  if CanShowBorderLayer and (FBorderLayer.FVisible) and
    (FBorderLayer.FData.FullBorder)
  then
    FBorderLayer.UpdateBorder
  else
    SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
end;

procedure TspDynamicSkinForm.SetShowIcon(Value: Boolean);
begin
  FShowIcon := Value;
  if not (csDesigning in ComponentState) and
     not (csLoading in ComponentState)
  then
    UpDateFormNC;
end;

procedure TspDynamicSkinForm.GetIcon;
var
  IH: HICON;
  IX, IY: Integer;
  B: Boolean;
begin
  if FIcon = nil
  then
    begin
      FIcon := TIcon.Create;
      B := False;
      IH := 0;
      if FForm.Icon.Handle <> 0
      then
        IH := FForm.Icon.Handle
      else
      if Application.Icon.Handle <> 0
      then
        IH := Application.Icon.Handle
      else
        begin
          IH := LoadIcon(0, IDI_APPLICATION);
          B := True;
        end;
      GetIconSize(IX, IY);
      FIcon.Handle := CopyImage(IH, IMAGE_ICON, IX, IY, LR_COPYFROMRESOURCE);
      if B then DestroyIcon(IH);
    end;
end;

procedure TspDynamicSkinForm.DrawFormIcon(Cnvs: TCanvas; X, Y: Integer);
begin
  GetIcon;
  if FIcon <> nil then
    DrawIconEx(Cnvs.Handle, X, Y, FIcon.Handle, 0, 0, 0, 0, DI_NORMAL);
end;

procedure TspDynamicSkinForm.GetIconSize(var X, Y: Integer);
begin
  X := GetSystemMetrics(SM_CXSMICON);
  if X = 0 then X := GetSystemMetrics(SM_CXSIZE);
  Y := GetSystemMetrics(SM_CYSMICON);
  if Y = 0 then Y := GetSystemMetrics(SM_CYSIZE);
end;

procedure TspDynamicSkinForm.MDIItemClick(Sender: TObject);
var
  I: Integer;
  S1, S2: String;
  MainDSF, ChildDSF: TspDynamicSkinForm;
begin
  MainDSF := GetDynamicSkinFormComponent(Application.MainForm);
  if MainDSF = nil then Exit;
  S1 := TMenuItem(Sender).Name;
  S2 := MI_CHILDITEM;
  Delete(S1, Pos(S2, S1), Length(S2));
  for I := 0 to MainDSF.FForm.MDIChildCount - 1 do
    if MainDSF.FForm.MDIChildren[I].Name = S1
    then
      begin
        ChildDSF := GetDynamicSkinFormComponent(MainDSF.FForm.MDIChildren[I]);
        if (ChildDSF <> nil) and (ChildDSF.WindowState = wsMinimized)
        then
          ChildDSF.WindowState := wsNormal;
        MainDSF.FForm.MDIChildren[I].Show;
      end;
end;

procedure TspDynamicSkinForm.UpDateChildCaptionInMenu(Child: TCustomForm);
var
  WM: TMenuItem;
  MainDSF: TspDynamicSkinForm;
  I: Integer;
  S1, S2: String;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if MainDSF = nil then Exit;
  WM := MainDSF.FForm.WindowMenu;
  if WM = nil then Exit;
  for I := 0 to WM.Count - 1 do
  if (Pos(MI_CHILDITEM, WM.Items[I].Name) <> 0)
  then
    begin
      S1 := WM.Items[I].Name;
      S2 := MI_CHILDITEM;
      Delete(S1, Pos(S2, S1), Length(S2));
      if Child.Name = S1
      then
        begin
          WM.Items[I].Caption := Child.Caption;
          Break;
        end;
    end;
end;

procedure TspDynamicSkinForm.UpDateChildActiveInMenu;
var
  WM: TMenuItem;
  MainDSF: TspDynamicSkinForm;
  I: Integer;
  S1, S2: String;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if MainDSF = nil then Exit;
  WM := MainDSF.FForm.WindowMenu;
  if WM = nil then Exit;
  for I := 0 to WM.Count - 1 do
  if (Pos(MI_CHILDITEM, WM.Items[I].Name) <> 0)
  then
    begin
      S1 := WM.Items[I].Name;
      S2 := MI_CHILDITEM;
      Delete(S1, Pos(S2, S1), Length(S2));
      if MainDSF.FForm.ActiveMDIChild.Name = S1
      then
        WM.Items[I].Checked := True
      else
        WM.Items[I].Checked := False;
    end;
end;

procedure TspDynamicSkinForm.AddChildToBar;
var
  MainDSF: TspDynamicSkinForm;
  Accept: Boolean;
begin
  Accept := True;
  if Assigned(FOnAcceptToMDITabsBar) then FOnAcceptToMDITabsBar(Accept);
  if not Accept then Exit;
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if (MainDSF = nil) or (MainDSF.MDITabsBar = nil) then Exit;
  MainDSF.MDITabsBar.AddTab(Child);
end;

procedure TspDynamicSkinForm.RefreshMDIBarTab(Child: TCustomForm);
var
  MainDSF: TspDynamicSkinForm;
  I: Integer;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if (MainDSF = nil) or (MainDSF.MDITabsBar = nil) then Exit;
  with MainDSF.MDITabsBar do
   for I := 0 to ObjectList.Count - 1 do
    if TspMDITab(ObjectList.Items[I]).Child = Child
    then
      TspMDITab(ObjectList.Items[I]).Draw(MainDSF.MDITabsBar.Canvas);
end;

procedure TspDynamicSkinForm.AddChildToMenu;
var
  WM: TMenuItem;
  NewItem: TMenuItem;
  MainDSF: TspDynamicSkinForm;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if MainDSF = nil then Exit;
  WM := MainDSF.FForm.WindowMenu;
  if WM = nil then Exit;
  NewItem := TMenuItem.Create(Self);
  NewItem.Name := Child.Name + MI_CHILDITEM;
  NewItem.Caption := Child.Caption;
  NewItem.OnClick := MDIItemClick;
  WM.Add(NewItem);
end;


procedure TspDynamicSkinForm.DeleteChildFromBar;
var
  MainDSF: TspDynamicSkinForm;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if (MainDSF = nil) or (MainDSF.MDITabsBar = nil) then Exit;
  MainDSF.MDITabsBar.DeleteTab(Child);
end;

procedure TspDynamicSkinForm.DeleteChildFromMenu;
var
  WM, MI: TMenuItem;
  MainDSF: TspDynamicSkinForm;
  I: Integer;
  S1, S2: String;
begin
  MainDSF := DynamicSkinForm.GetDynamicSkinFormComponent(Application.MainForm);
  if MainDSF = nil then Exit;
  WM := MainDSF.FForm.WindowMenu;
  if WM = nil then Exit;
  for I := 0 to WM.Count - 1 do
  if (Pos(MI_CHILDITEM, WM.Items[I].Name) <> 0)
  then
    begin
      S1 := WM.Items[I].Name;
      S2 := MI_CHILDITEM;
      Delete(S1, Pos(S2, S1), Length(S2));
      if Child.Name = S1
      then
        begin
          MI := WM.Items[I];
          WM.Delete(I);
          MI.Free;
          Break;
        end;
    end;

  if MainDSF.FForm.MDIChildCount = 0
  then
    for I := 0 to WM.Count - 1 do
    if (Pos(MI_CHILDITEM, WM.Items[I].Name) <> 0)
    then
      begin
        MI := WM.Items[I];
        WM.Delete(I);
        MI.Free;
        Break;
      end;
end;

procedure TspDynamicSkinForm.SetMaxMenuItemsInWindow(Value: Integer);
begin
  if (Value >= 0)
  then
    begin
      FMaxMenuItemsInWindow := Value;
      if SkinMenu <> nil then SkinMenu.MaxMenuItemsInWindow := Value;
    end;
end;

procedure TspDynamicSkinForm.SetAlphaBlend(Value: Boolean);
begin
  if FAlphaBlend <> Value
  then
    begin
      FAlphaBlend := Value;
      if ComponentState = []
      then
        begin
          if FAlphaBlend
          then
            begin
              if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED = 0
              then
                SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                              GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
              SetAlphaBlendTransparent(FForm.Handle, FAlphaBlendValue);
            end
           else
             begin
               if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED <> 0
               then
                 begin
                  SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                                 GetWindowLong(FForm.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
                 end;
             end;                
        end;
    end;
end;

procedure TspDynamicSkinForm.SetAlphaBlendValue(Value: Byte);
begin
  if FAlphaBlendValue <> Value
  then
    begin
      FAlphaBlendValue := Value;
      if FAlphaBlend and (ComponentState = [])
      then
        SetAlphaBlendTransparent(FForm.Handle, FAlphaBlendValue);
    end;
end;

procedure TspDynamicSkinForm.SetMenusAlphaBlend(Value: Boolean);
begin
  FMenusAlphaBlend := Value;
  if SkinMenu <> nil then SkinMenu.AlphaBlend := Value;
end;

procedure TspDynamicSkinForm.SetMenusAlphaBlendAnimation(Value: Boolean);
begin
  FMenusAlphaBlendAnimation := Value;
  if SkinMenu <> nil then SkinMenu.AlphaBlendAnimation := Value;
end;

procedure TspDynamicSkinForm.SetMenusAlphaBlendValue(Value: Byte);
begin
  FMenusAlphaBlendValue := Value;
  if SkinMenu <> nil then SkinMenu.AlphaBlendValue := Value;
end;

procedure TspDynamicSkinForm.TrackSystemMenu(X, Y: Integer);
var
  MenuItem: TMenuItem;
  DSF: TspDynamicSkinForm;
begin
  MenuItem := GetSystemMenu;
  SkinMenuOpen;
  if FForm.FormStyle = fsMDIChild
  then
    begin
      DSF := GetDynamicSkinFormComponent(Application.MainForm);
      if DSF <> nil
      then
        with DSF do
        begin
          if MenusSkinData = nil
          then
            SkinMenu.Popup(nil, SkinData, 0, Rect(X, Y, X, Y), MenuItem, False)
          else
            SkinMenu.Popup(nil, MenusSkinData, 0, Rect(X, Y, X, Y), MenuItem, False);
        end;
    end
  else
    begin
      if MenusSkinData = nil
      then
        SkinMenu.Popup(nil, SkinData, 0, Rect(X, Y, X, Y), MenuItem, False)
      else
        SkinMenu.Popup(nil, MenusSkinData, 0, Rect(X, Y, X, Y), MenuItem, False);
    end;    
end;

procedure TspDynamicSkinForm.TrackSystemMenu2;
var
  MenuItem: TMenuItem;
  DSF: TspDynamicSkinForm;
begin
  MenuItem := GetSystemMenu;
  SkinMenuOpen;
  if FForm.FormStyle = fsMDIChild
  then
    begin
      DSF := GetDynamicSkinFormComponent(Application.MainForm);
      if DSF <> nil
      then
        with DSF do
        begin
          if MenusSkinData = nil
          then
            SkinMenu.Popup(nil, SkinData, 0, R, MenuItem, False)
          else
            SkinMenu.Popup(nil, MenusSkinData, 0, R, MenuItem, False);
        end;
    end
  else
    begin
      if MenusSkinData = nil
      then
        SkinMenu.Popup(nil, SkinData, 0, R, MenuItem, False)
      else
        SkinMenu.Popup(nil, MenusSkinData, 0, R, MenuItem, False);
    end;    
end;

function TspDynamicSkinForm.GetAutoRenderingInActiveImage: Boolean;
begin
  if (FSD <> nil) and not (FSD.Empty)
  then Result := FSD.AutoRenderingInActiveImage
  else Result := False;
end;

procedure TspDynamicSkinForm.UpDateActiveObjects;
var
  i: Integer;
begin
  if ObjectList <> nil
  then
  for i := 0 to ObjectList.Count  - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
    then
      begin
        with TspSkinAnimateObject(ObjectList.Items[i]) do
        begin
          FMouseIn := False;
          Active := False;
          FFrame := 1;
        end;
      end
    else  
    if not (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject)
    then
      with TspActiveSkinObject(ObjectList.Items[i]) do
      begin
        Active := False;
        FMouseIn := False;
        FMorphkf := 0;
      end;
end;

function TspDynamicSkinForm.GetDefCaptionHeight: Integer;
begin
  if (FForm.BorderStyle = bsToolWindow) or
     (FForm.BorderStyle = bsSizeToolWin)
  then
    Result := DEFTOOLCAPTIONHEIGHT
  else
    Result := DEFCAPTIONHEIGHT;
end;

function TspDynamicSkinForm.GetDefButtonSize: Integer;
begin
  if (FForm.BorderStyle = bsToolWindow) or
     (FForm.BorderStyle = bsSizeToolWin)
  then
    Result := DEFTOOLBUTTONSIZE
  else
    Result := DEFBUTTONSIZE;
end;

function TspDynamicSkinForm.GetDefCaptionRect: TRect;
begin
  CalcDefRects;
  Result :=  NewDefCaptionRect;
end;

procedure TspDynamicSkinForm.ArangeMinimizedChilds;
var
  I: Integer;
  DS: TspDynamicSkinForm;
  P: TPoint;
begin
  for i := 0 to FForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(FForm.MDIChildren[i]);
    if DS <> nil
    then
      begin
        if DS.WindowState = wsMinimized
        then
          begin
            P := DS.GetMinimizeCoord;
            FForm.MDIChildren[i].Left := P.X;
            FForm.MDIChildren[i].Top := P.Y;
          end;
      end;
  end;
end;

procedure TspDynamicSkinForm.SetDefaultMenuItemHeight(Value: Integer);
begin
  if Value > 0 then
    SkinMenu.DefaultMenuItemHeight := Value;
end;

function TspDynamicSkinForm.GetDefaultMenuItemHeight: Integer;
begin
  Result := SkinMenu.DefaultMenuItemHeight;
end;

procedure TspDynamicSkinForm.SetDefaultMenuItemFont(Value: TFont);
begin
  SkinMenu.DefaultMenuItemFont.Assign(Value);
end;

function TspDynamicSkinForm.GetDefaultMenuItemFont: TFont;
begin
  Result := SkinMenu.DefaultMenuItemFont;
end;

procedure TspDynamicSkinForm.SetBorderIcons;
begin
  FBorderIcons := Value;
  if FSupportNCArea or FSkinSupport
  then
    begin
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        begin
          CheckObjects;
          SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
        end;
    end
  else
  if not FSupportNCArea and FHideCaptionButtons
  then
    CheckObjects;
end;

procedure TspDynamicSkinForm.SetDefCaptionFont;
begin
  FDefCaptionFont.Assign(Value);
  if not (csDesigning in ComponentState) and
     not (csLoading in ComponentState) and not FSkinSupport
  then SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
end;

procedure TspDynamicSkinForm.SetDefInActiveCaptionFont;
begin
  FDefInActiveCaptionFont.Assign(Value);
  if not (csDesigning in ComponentState) and
     not (csLoading in ComponentState) and not FSkinSupport
  then SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
end;

procedure TspDynamicSkinForm.CorrectCaptionText;
begin
  CorrectTextbyWidthW(C, S, W);
end;

procedure TspDynamicSkinForm.CalcDefRects;
var
  i: Integer;
  BSize: Integer;
  OffsetX, OffsetY: Integer;
  Button: TspSkinStdButtonObject;

procedure SetStdButtonRect(B: TspSkinStdButtonObject);
begin
  if B <> nil
  then
    with B do
    begin
      ObjectRect := Rect(OffsetX - BSize, OffsetY, OffsetX, OffsetY + BSize);
      OffsetX := OffsetX - BSize;
    end;
end;

procedure SetStdButtonRect2(B: TspSkinStdButtonObject);
var
  IX, IY: Integer;
begin
  if B <> nil
  then
    with B do
    begin
      if (Command = cmSysMenu) and Parent.ShowIcon
      then
        begin
          GetIconSize(IX, IY);
          ObjectRect := Rect(OffsetX, OffsetY, OffsetX + IX, OffsetY + IY);
          OffsetX := OffsetX + IX;
        end
      else
        begin
          ObjectRect := Rect(OffsetX, OffsetY, OffsetX + BSize, OffsetY + BSize);
          OffsetX := OffsetX + BSize;
        end;
    end;
end;

function GetStdButton(C: TStdCommand): TspSkinStdButtonObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinStdButtonObject
    then
      with TspSkinStdButtonObject(ObjectList.Items[I]) do
        if Visible and SkinRectInAPicture and (Command = C)
        then
          begin
            Result := TspSkinStdButtonObject(ObjectList.Items[I]);
            Break;
          end;
end;

begin
  if (ObjectList = nil) or (ObjectList.Count = 0) then Exit;
  i := 0;
  OffsetX := FFormWidth - 3;
  OffsetY := 4;
  NewDefCaptionRect := Rect(3, 3, OffsetX, GetDefCaptionHeight);
  BSize := GetDefButtonSize;
  Button := GetStdButton(cmClose);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMaximize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmRollUp);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimizeToTray);
  SetStdButtonRect(Button);
  NewDefCaptionRect.Right := OffsetX;
  OffsetX := NewDefCaptionRect.Left;
  Button := GetStdButton(cmSysMenu);
  if Button <> nil
  then
    begin
      SetStdButtonRect2(Button);
      NewDefCaptionRect.Left := OffsetX;
    end;
end;

procedure TspDynamicSkinForm.PaintNCDefault;
var
  PaintRect, R: TRect;
  CB: TBitMap;
  i: Integer;
  TX, TY: Integer;
  C: TColor;
  LeftOffset, RightOffset: Integer;
  S: WideString;
  DC: HDC;
  Cnvs: TControlCanvas;
  F: TForm;
  FA: Boolean;
begin

  if (FSD <> nil) and (FSD.ChangeSkinDataProcess) then Exit;

  if FFormWidth = 0 then FFormWidth := FForm.Width;
  if FFormHeight = 0 then FFormHeight := FForm.Height;

  if (ObjectList.Count = 0) and not FSkinSupport then LoadDefObjects;
  CalcDefRects;

  if not AUseExternalDC then DC := GetWindowDC(FForm.Handle) else DC := ADC;

  Cnvs := TControlCanvas.Create;
  Cnvs.Handle := DC;

  CB := TBitMap.Create;
  CB.Width := FFormWidth - 6;
  CB.Height := GetDefCaptionHeight;

  LeftOffset := NewDefCaptionRect.Left - 3;
  RightOffset := CB.Width - NewDefCaptionRect.Right;

  // create caption
  with CB.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, CB.Width, CB.Height));
    C := clBtnShadow;
    for i := 2 to GetDefCaptionHeight - 4 do
    begin
      if C = clBtnShadow then C := clBtnHighLight else C := clBtnShadow;
      Pen.Color := C;
      MoveTo(LeftOffset + 2, i); LineTo(CB.Width - RightOffset - 6, i);
    end;

    FA := GetFormActive;

    if FA
    then
      begin
        CB.Canvas.Font.Assign(FDefCaptionFont);
        Font := DefCaptionFont;
      end
    else
      begin
        CB.Canvas.Font.Assign(FDefInActiveCaptionFont);
        Font := DefInActiveCaptionFont;
      end;

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      begin
        CB.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet;
        Font.Charset := SkinData.ResourceStrData.CharSet;
      end;
        
    // paint caption text
    S := FForm.Caption;
    {$IFDEF TNTUNICODE}
    if FForm is TTNTForm then S := TTNTForm(FForm).Caption;
    {$ENDIF}

    if (FForm.FormStyle = fsMDIForm) and FMDIChildMaximized
    then
      begin
        F := GetMaximizeMDIChild;
        if F <> nil
        then
          begin
            {$IFDEF TNTUNICODE}
            if F is TTNTForm
            then
              S := S + ' - [' +  TTNTForm(F).Caption + ']'
            else
              S := S + ' - [' +  F.Caption + ']';
            {$ELSE}
            S := S + ' - [' +  F.Caption + ']';
            {$ENDIF}
          end;
      end;

    if Assigned(OnCaptionPaint)
    then
      begin
        OnCaptionPaint(CB.Canvas, Rect(LeftOffset, 0, CB.Width - RightOffset - 3, CB.Height), FA);
      end
    else
    if S <> ''
    then
      begin
        CorrectCaptionText(CB.Canvas, S, CB.Width - LeftOffset - RightOffset);
        TX := LeftOffset + (CB.Width - LeftOffset - RightOffset) div 2 -
                          (CalcTextWidthW(CB.Canvas, S) + 5) div 2;
        TY := GetDefCaptionHeight div 2 - CalcTextHeightW(CB.Canvas, S) div 2;
        R := Rect(TX, TY, TX, TY);
        SPDrawSkinText(CB.Canvas, S, R, DT_CALCRECT);
        CB.Canvas.FillRect(Rect(R.Left - 2, R.Top - 2, R.Right + 2, R.Bottom + 2));
        SPDrawSkinText(CB.Canvas, S, R, FForm.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER));
     end;
  end;


  if (ObjectList <> nil) and (ObjectList.Count > 0)
  then
    begin
      for i := 0 to ObjectList.Count - 1 do
      with TspActiveSkinObject(ObjectList.Items[i]) do
      if Visible then
      begin
        OffsetRect(ObjectRect, -3, -3);
        Draw(CB.Canvas, True);
        OffsetRect(ObjectRect, 3, 3);
      end;
    end;
  //paint border + caption
  with Cnvs do
  begin
    ExcludeClipRect(Cnvs.Handle, 3, GetDefCaptionHeight + 3, FFormWidth - 3, FFormHeight - 3);
    PaintRect := Rect(0, 0, FFormWidth, FFormHeight);
    Draw(3, 3, CB);
    Frame3D(Cnvs, PaintRect, cl3DLight, cl3DDKShadow, 1);
    Frame3D(Cnvs, PaintRect, clBtnHighLight, clBtnShadow, 1);
    Frame3D(Cnvs, PaintRect, clBtnFace, clBtnFace, 1);
    CB.Free;
  end;
  Cnvs.Free;
  if not AUseExternalDC then ReleaseDC(FForm.Handle, DC);
end;

procedure TspDynamicSkinForm.PaintBGDefault;
var
  C: TCanvas;
begin
  if DC = 0 then Exit;
  C := TCanvas.Create;
  C.Handle := DC;
  with C do
  begin
    Brush.Color := clBtnFace;
    FillRect(FForm.ClientRect);
    if not FLogoBitMap.Empty then DrawLogoBitMap(C);
  end;
  C.Free;
end;

procedure TspDynamicSkinForm.PaintMDIBGDefault(DC: HDC);
var
  C: TCanvas;
begin
  if DC = 0 then Exit;
  C := TCanvas.Create;
  C.Handle := DC;
  with C do
  begin
    Brush.Color := clAppWorkSpace;
    FillRect(FForm.ClientRect);
    if not FLogoBitMap.Empty then DrawLogoBitMap(C);
  end;
  C.Free;
end;


procedure TspDynamicSkinForm.HookApp;
begin
  if not FInAppHook
  then
    begin
      OldAppMessage := Application.OnMessage;
      Application.OnMessage := NewAppMessage;
      FInAppHook := True;
    end;
end;

procedure TspDynamicSkinForm.UnHookApp;
begin
  if FInAppHook
  then
    begin
      FInAppHook := False;
      Application.OnMessage := OldAppMessage;
    end;
end;

function TspDynamicSkinForm.GetMaximizeMDIChild: TForm;
var
  i: Integer;
  DS: TspDynamicSkinForm;
begin
  Result := nil;
  DS := nil;
  if Application.MainForm.ActiveMDIChild <> nil
  then
    DS := GetDynamicSkinFormComponent(Application.MainForm.ActiveMDIChild);
  if (DS <> nil) and (DS.WindowState = wsMaximized)
  then
    Result := Application.MainForm.ActiveMDIChild
  else
  for i := 0 to Application.MainForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(Application.MainForm.MDIChildren[i]);
    if (DS <> nil) and (DS.WindowState = wsMaximized)
    then
      begin
        Result := Application.MainForm.MDIChildren[i];
        Break;
      end;
  end;
end;

function TspDynamicSkinForm.IsMDIChildMaximized;
begin
  Result := FMDIChildMaximized;
end;

procedure TspDynamicSkinForm.TileH;
var
  ColumnCount: Integer;
  FInColumnCount: Integer;
  R: TRect;
  W, H: Integer;
  i, j, X, Y, FW, FH, L, T: Integer;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  if FForm.MDIChildCount = 0 then Exit;
  RestoreAll;
  ColumnCount := Trunc(Sqrt(FForm.MDIChildCount));
  if ColumnCount <= 0 then Exit;
  FInColumnCount := FForm.MDIChildCount div ColumnCount;
  if FInColumnCount * ColumnCount < FForm.MDIChildCount
  then Inc(FInColumnCount, 1);
  R := GetMDIWorkArea;

  W := RectWidth(R);
  H := RectHeight(R);

  FW := W div ColumnCount;
  FH := H div FInColumnCount;
  
  X := W;
  Y := H;
  j := ColumnCount;
  for i := FForm.MDIChildCount downto 1 do
  begin
    L := X - FW;
    T := Y - FH;
    if L < 0 then L := 0;
    if T < 0 then T := 0;
    FForm.MDIChildren[i - 1].SetBounds(L, T, FW, FH);
    Y := Y - FH;
    if (Y - FH < 0) and (i <> 0)
    then
      begin
        Y := H;
        X := X - FW;
        Dec(j);
        if j = 0 then j := 1;
        FInColumnCount := (i - 1) div j;
        if FInColumnCount * j < (i - 1)
        then Inc(FInColumnCount, 1);
        if FInColumnCount = 0
        then FInColumnCount := 1;
        FH := H div FInColumnCount;
      end;
  end;
end;

procedure TspDynamicSkinForm.TileV;
var
  ColumnCount: Integer;
  FInColumnCount: Integer;
  R: TRect;
  W, H: Integer;
  i, j, X, Y, FW, FH, L, T: Integer;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  if FForm.MDIChildCount = 0 then Exit;
  RestoreAll;
  FInColumnCount := Trunc(Sqrt(FForm.MDIChildCount));
  if ColumnCount <= 0 then Exit;
  ColumnCount := FForm.MDIChildCount div FInColumnCount;
  R := GetMDIWorkArea;
  W := RectWidth(R);
  H := RectHeight(R);
  FW := W div ColumnCount;
  FH := H div FInColumnCount;
  X := W;
  Y := H;
  j := ColumnCount;
  X := 0;
  Y := 0;
  for i := 1 to FForm.MDIChildCount do
  begin
    L := X;
    T := Y;
    FForm.MDIChildren[i - 1].SetBounds(L, T, FW, FH);
    Y := Y + FH;
    if (Y + FH > H)
    then
      begin
        Y := 0;
        X := X + FW;
        Dec(j);
        if j = 0 then j := 1;
        FInColumnCount := (FForm.MDIChildCount - i) div j;
        if FInColumnCount = 0 then FInColumnCount := 1;
        FH := H div FInColumnCount;
      end;
  end;
end;

procedure TspDynamicSkinForm.Tile;
begin
  if FTileMode = tbHorizontal then TileH else TileV;
end;


procedure TspDynamicSkinForm.Cascade;
var
  i, j, k, FW, FH, FW1, FH1, W, H, Offset1, Offset2: Integer;
  R: TRect;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  if FForm.MDIChildCount = 0 then Exit;
  RestoreAll;
  R := GetMDIWorkArea;
  W := RectWidth(R);
  H := RectHeight(R);

  if FSkinSupport
  then
    Offset1 := NewClRect.Top
  else
    Offset1 := GetDefCaptionHeight + 3;

  Offset2 := W - Round(W * 0.8);
  j := Offset2 div Offset1;
  if FForm.MDIChildCount < j
  then
    begin
      FW := W - (FForm.MDIChildCount - 1) * Offset1;
      FH := H - (FForm.MDIChildCount - 1) * Offset1;
    end
  else
   begin
     FW := W - j * Offset1;
     FH := H - j * Offset1;
   end;
  if FW < GetMinWidth then  FW := GetMinWidth;
  if FH < GetMinHeight then FH := GetMinHeight;
  k := 0;
  for i := FForm.MDIChildCount - 1 downto 0 do
  begin
    FW1 := FW;
    FH1 := FH;
    if (FForm.MDIChildren[i].BorderStyle = bsSingle)
    then
      begin
        FW1 := FForm.MDIChildren[i].Width;
        FH1 := FForm.MDIChildren[i].Height;
      end;
    if (k + FW1 > W) or (k + FH1 > H) then k := 0;
    FForm.MDIChildren[i].SetBounds(k, k, FW1, FH1);
    k := k + Offset1;
  end;
end;

procedure TspDynamicSkinForm.MinimizeAll;
var
  i: Integer;
  DS: TspDynamicSkinForm;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  for i := 0 to FForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(FForm.MDIChildren[i]);
    if DS <> nil then DS.WindowState := wsMinimized;
  end;
end;

procedure TspDynamicSkinForm.MaximizeAll;
var
  i: Integer;
  DS: TspDynamicSkinForm;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  for i := 0 to FForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(FForm.MDIChildren[i]);
    if (DS <> nil) and (biMaximize in DS.BorderIcons)  then DS.WindowState := wsMaximized;
  end;
end;

procedure TspDynamicSkinForm.CloseAll;
var
  i: Integer;
begin
  if FForm.FormStyle = fsMDIForm
  then
    for i := FForm.MDIChildCount - 1 downto 0 do
      FForm.MDIChildren[i].Close;
end;

procedure TspDynamicSkinForm.RestoreAllExcept(AFormHandle: HWnd);
var
  i: Integer;
  DS: TspDynamicSkinForm;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  for i := 0 to FForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(FForm.MDIChildren[i]);
    if (DS <> nil) and (DS.FForm.Handle <> AFormHandle)
    then
      begin
        if DS.WindowState <> wsNormal then DS.WindowState := wsNormal;
        if DS.RollUpState and (DS.WindowState = wsNormal) then DS.RollUpState := False;
      end;
  end;
end;

procedure TspDynamicSkinForm.RestoreAll;
var
  i: Integer;
  DS: TspDynamicSkinForm;
begin
  if FForm.FormStyle <> fsMDIForm then Exit;
  for i := 0 to FForm.MDIChildCount - 1 do
  begin
    DS := GetDynamicSkinFormComponent(FForm.MDIChildren[i]);
    if (DS <> nil) and (DS.WindowState <> wsNormal) then DS.WindowState := wsNormal;
    if (DS <> nil) and DS.RollUpState and (DS.WindowState = wsNormal) then DS.RollUpState := False;
  end;
end;

procedure TspDynamicSkinForm.ResizeMDIChilds;
var
  i: Integer;
begin
  for i := 0 to FForm.MDIChildCount - 1 do
    SendMessage(FForm.MDIChildren[i].Handle, WM_MDICHANGESIZE, 0, 0);
  if not FShowMDIScrollBars then ArangeMinimizedChilds; 
end;


function TspDynamicSkinForm.GetMDIWorkArea;

function GetTop: Integer;
var
  i, j: Integer;
begin
  with Application.MainForm do
  begin
    j := 0;
    for i := 0 to ControlCount - 1 do
      if Controls[i].Visible and (Controls[i].Align = alTop) and
         (Controls[i].Top + Controls[i].Height > j)
      then
        j := Controls[i].Top + Controls[i].Height;
  end;
  Result := j;
end;

function GetBottom: Integer;
var
  i, j: Integer;
begin
  with Application.MainForm do
  begin
    j := ClientHeight;
    for i := 0 to ControlCount - 1 do
      if Controls[i].Visible and (Controls[i].Align = alBottom) and
         (Controls[i].Top < j)
      then
        j := Controls[i].Top;
  end;
  Result := j;
end;

function GetLeft: Integer;
var
  i, j: Integer;
begin
  with Application.MainForm do
  begin
    j := 0;
    for i := 0 to ControlCount - 1 do
      if Controls[i].Visible and (Controls[i].Align = alLeft) and
         (Controls[i].Left + Controls[i].Width > j)
      then
        j := Controls[i].Left + Controls[i].Width;
  end;
  Result := j;
end;

function GetRight: Integer;
var
  i, j: Integer;
begin
  with Application.MainForm do
  begin
    j := ClientWidth;
    for i := 0 to ControlCount - 1 do
      if Controls[i].Visible and (Controls[i].Align = alRight) and
         (Controls[i].Left < j)
      then
        j := Controls[i].Left;
  end;
  Result := j;
end;

begin
  if Application.MainForm <> nil then
  Result := Rect(GetLeft, GetTop, GetRight, GetBottom);
end;


procedure TspDynamicSkinForm.TrayIconDBLCLK;
begin
  RestoreFromTray;
end;

procedure TspDynamicSkinForm.MinimizeToTray;
begin
  if FTrayIcon <> nil
  then
    with FTrayIcon do
    begin
      FTrayIcon.MinimizeToTray := True;
      Application.Minimize;
      if Assigned(FOnMinimizeToTray) then FOnMinimizeToTray(Self);
    end;
end;

procedure TspDynamicSkinForm.RestoreFromTray;
begin
  if FTrayIcon <> nil
  then
    with FTrayIcon do
    begin
      FTrayIcon.MinimizeToTray := False;
      FTrayIcon.ShowMainForm;
      Application.Restore;
      if not FAlwaysShowInTray then FTrayIcon.IconVisible := False;
      if Assigned(FOnRestoreFromTray) then FOnRestoreFromTray(Self);
      CheckAppLayeredBorders;
    end;
end;

procedure TspDynamicSkinForm.SetTrayIcon;
begin
  FTrayIcon := Value;
  if TrayIcon <> nil
  then
    with TrayIcon do
    begin
      if not FAlwaysShowInTray then IconVisible := False;
      if (csDesigning in ComponentState) and not
         (csLoading in ComponentState)
      then
        Self.BorderIcons := Self.BorderIcons + [biMinimizeToTray];
      if not (csDesigning in ComponentState)
      then
        begin
          if PopupMenu = nil
          then
            begin
              PopupMenu := FSysTrayMenu;
              if not Assigned(OnDblClick)
              then
                OnDblClick := TrayIconDBLCLK;
            end;
        end;
    end
  else
    if (csDesigning in ComponentState) and not
         (csLoading in ComponentState)
    then
      Self.BorderIcons := Self.BorderIcons - [biMinimizeToTray];
end;

procedure TspDynamicSkinForm.TSM_Restore(Sender: TObject);
begin
  RestoreFromTray;
end;

procedure TspDynamicSkinForm.TSM_Close(Sender: TObject);
begin
  FForm.Close;
end;

procedure TspDynamicSkinForm.SM_Restore(Sender: TObject);
begin
  if MaxRollUpState or (FRollUpState and (WindowState = wsNormal))
  then
    RollUpState := False
  else
    WindowState := wsNormal;
end;

procedure TspDynamicSkinForm.SM_Max(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TspDynamicSkinForm.SM_Min(Sender: TObject);
begin
  if FAlwaysMinimizeToTray
  then
    MinimizeToTray
  else
    WindowState := wsMinimized;
end;

procedure TspDynamicSkinForm.SM_RollUp(Sender: TObject);
begin
  RollUpState := True;
end;

procedure TspDynamicSkinForm.SM_Close(Sender: TObject);
begin
  FForm.Close;
end;

procedure TspDynamicSkinForm.SM_MinToTray(Sender: TObject);
begin
  MinimizeToTray;
end;


procedure TspDynamicSkinForm.ShowClientInActiveEffect;
begin
  if FInActivePanel <> nil then HideClientInActiveEffect;
  FInActivePanel := TspClientInActivePanel.Create(Self);
  FClientInActiveDraw := True;
  FInActivePanel.Showpanel(FForm, FClientInActiveEffectType);
  FClientInActiveDraw := False;
end;

procedure TspDynamicSkinForm.HideClientInActiveEffect;
begin
  if FInActivePanel <> nil
  then
    begin
      FInActivePanel.HidePanel;
      FInActivePanel.Free;
      FInActivePanel := nil;
    end;  
end;

procedure TspDynamicSkinForm.CreateUserSysMenu;

procedure AddMaxItem;
var
  MI: TMenuItem;
begin
  if not (biMaximize in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MAXName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MAXCAPTION')
    else
      Caption := SP_MI_MAXCAPTION;
    OnClick := SM_Max;
  end;
  FSystemMenu.Items.Insert(0, MI);
end;

procedure AddMinItem;
var
  MI: TMenuItem;
begin
  if not (biMinimize in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MINName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MINCAPTION')
    else
      Caption := SP_MI_MINCAPTION;
    OnClick := SM_Min;
  end;
  FSystemMenu.Items.Insert(0, MI);
end;

procedure AddRestoreItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_RESTOREName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_RESTORECAPTION')
    else
      Caption := SP_MI_RESTORECAPTION;
    OnClick := SM_Restore;
  end;
  FSystemMenu.Items.Insert(0, MI);
end;

procedure AddRollUpItem;
var
  MI: TMenuItem;
begin
  if not (biRollUp in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_ROLLUPName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_ROLLUPCAPTION')
    else
      Caption := SP_MI_ROLLUPCAPTION;
    OnClick := SM_RollUp;
  end;
  FSystemMenu.Items.Insert(0, MI);
end;

procedure AddCloseItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_CLOSEName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_CLOSECAPTION')
    else
      Caption := SP_MI_CLOSECAPTION;
    OnClick := SM_Close;
    if FForm.FormStyle = fsMDIChild
    then
      ShortCut := TextToShortCut('Ctrl+F4')
    else
      ShortCut := TextToShortCut('Alt+F4');
  end;
  FSystemMenu.Items.Add(MI);
end;

procedure AddMinToTrayItem;
var
  MI: TMenuItem;
begin
  if not (biMinimizeToTray in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MINTOTRAYName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MINTOTRAYCAPTION')
    else
      Caption := SP_MI_MINTOTRAYCAPTION;
    OnClick := SM_MinToTray;
  end;
  FSystemMenu.Items.Insert(0, MI);
end;

var
  B: Boolean;
  i: Integer;
begin
  if not FUseDefaultSysMenu then Exit;
  // delete old items
  repeat
    B := True;
    for i := 0 to FSystemMenu.Items.Count - 1 do
      if (FSystemMenu.Items[i].Name = MI_MINName) or
         (FSystemMenu.Items[i].Name = MI_MAXName) or
         (FSystemMenu.Items[i].Name = MI_CLOSEName) or
         (FSystemMenu.Items[i].Name = MI_MINTOTRAYName) or
         (FSystemMenu.Items[i].Name = MI_ROLLUPName) or
         (FSystemMenu.Items[i].Name = MI_RESTOREName)
      then
        begin
          FSystemMenu.Items[i].Free;
          B := False;
          Break;
        end;
  until B;
  //
  AddMinToTrayItem;

  if not ((FForm.FormStyle = fsMDIChild) and (FWindowState = wsMaximized))
  then
    if not FRollUpState and (FWindowState <> wsMinimized)
    then AddRollUpItem;


  if FWindowState <> wsMaximized then AddMaxItem;
  if (FWindowState <> wsNormal) or FRollUpState then AddRestoreItem;
  if FWindowState <> wsMinimized then AddMinItem;
  AddCloseItem;
end;

function TspDynamicSkinForm.GetSystemMenu;
begin
  if FSystemMenu <> nil
  then
    begin
      CreateUserSysMenu;
      Result := FSystemMenu.Items;
    end
  else
    begin
      CreateSysMenu;
      Result := FSysMenu.Items;
    end;
end;

procedure TspDynamicSkinForm.CreateSysTrayMenu;

procedure AddRestoreItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := TMI_RESTOREName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_RESTORECAPTION')
    else
      Caption := SP_MI_RESTORECAPTION;
    OnClick := TSM_Restore;
  end;
  FSysTrayMenu.Items.Add(MI);
end;


procedure AddCloseItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := TMI_CLOSEName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_CLOSECAPTION')
    else
      Caption := SP_MI_CLOSECAPTION;
    OnClick := TSM_Close;
    if FForm.FormStyle = fsMDIChild
    then
      ShortCut := TextToShortCut('Ctrl+F4')
    else
      ShortCut := TextToShortCut('Alt+F4');
  end;
  FSysTrayMenu.Items.Add(MI);
end;

procedure AddDevItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  MI.Caption := '-';
  FSysTrayMenu.Items.Add(MI);
end;

begin
  AddRestoreItem;
  AddDevItem;
  AddCloseItem;
end;

procedure TspDynamicSkinForm.CreateSysMenu;

procedure AddMaxItem;
var
  MI: TMenuItem;
begin
  if not (biMaximize in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MAXName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MAXCAPTION')
    else
      Caption := SP_MI_MAXCAPTION;
    OnClick := SM_Max;
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddMinItem;
var
  MI: TMenuItem;
begin
  if not (biMinimize in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MINName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MINCAPTION')
    else
      Caption := SP_MI_MINCAPTION;
    OnClick := SM_Min;
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddRestoreItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_RESTOREName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_RESTORECAPTION')
    else
      Caption := SP_MI_RESTORECAPTION;
    OnClick := SM_Restore;
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddRollUpItem;
var
  MI: TMenuItem;
begin
  if not (biRollUp in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_ROLLUPName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_ROLLUPCAPTION')
    else
      Caption := SP_MI_ROLLUPCAPTION;
    OnClick := SM_RollUp;
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddCloseItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_CLOSEName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_CLOSECAPTION')
    else
      Caption := SP_MI_CLOSECAPTION;
    OnClick := SM_Close;
    if FForm.FormStyle = fsMDIChild
    then
      ShortCut := TextToShortCut('Ctrl+F4')
    else
      ShortCut := TextToShortCut('Alt+F4');
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddMinToTrayItem;
var
  MI: TMenuItem;
begin
  if not (biMinimizeToTray in FBorderIcons) then Exit;
  MI := TMenuItem.Create(Self);
  with MI do
  begin
    Name := MI_MINTOTRAYName;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('MI_MINTOTRAYCAPTION')
    else
      Caption := SP_MI_MINTOTRAYCAPTION;
    OnClick := SM_MinToTray;
  end;
  FSysMenu.Items.Add(MI);
end;

procedure AddDevItem;
var
  MI: TMenuItem;
begin
  MI := TMenuItem.Create(Self);
  MI.Caption := '-';
  FSysMenu.Items.Add(MI);
end;

var
  i: Integer;
begin
  for i := FSysMenu.Items.Count - 1 downto 0 do
    TMenuItem(FSysMenu.Items[i]).Free;
  if FWindowState <> wsMinimized then AddMinItem;
  if FWindowState <> wsMaximized then AddMaxItem;
  if (FWindowState <> wsNormal) or FRollUpState then AddRestoreItem;

  if not ((FForm.FormStyle = fsMDIChild) and (FWindowState = wsMaximized))
  then
    if not FRollUpState and (FWindowState <> wsMinimized)
    then AddRollUpItem;

  AddMinToTrayItem;
  if FSysMenu.Items.Count > 0 then AddDevItem;
  AddCloseItem;
end;

function TspDynamicSkinForm.CanNCSupport: Boolean;
begin
  Result := FSupportNCArea and (FSD <> nil) and not FSD.Empty and
            not IsNullRect(FSD.ClRect);
end;

function TspDynamicSkinForm.GetFullDragg: Boolean;
var
  B: Boolean;
begin
  SystemParametersInfo(SPI_GETDRAGFULLWINDOWS, 0, @B, 0);
  Result := B;
end;

function TspDynamicSkinForm.GetMinimizeCoord;

function GetMDIEqualCoord(P: TPoint): Boolean;
var
  DS: TspDynamicSkinForm;
  MF: TForm;
  i: Integer;
begin
  Result := True;
  MF := Application.MainForm;
  for i := 0 to MF.MDIChildCount - 1 do
  if (MF.MDIChildren[i] <> FForm) and MF.MDIChildren[i].Visible 
  then
    begin
      DS := GetDynamicSkinFormComponent(MF.MDIChildren[i]);
      if (DS <> nil) and (DS.WindowState = wsMinimized) and
         (MF.MDIChildren[i].Left = P.X) and (MF.MDIChildren[i].Top = P.Y)
      then
        begin
          Result := False;
          Break;
        end;
    end;
end;

function GetSDIEqualCoord(P: TPoint): Boolean;
var
  DS: TspDynamicSkinForm;
  i: Integer;
begin
  Result := True;
  for i := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[i] <> FForm) and (Screen.Forms[i] <> Application.MainForm) and
     (Screen.Forms[i].Visible)
  then
    begin
      DS := GetDynamicSkinFormComponent(Screen.Forms[i]);
      if (DS <> nil) and (DS.WindowState = wsMinimized) and
         (Screen.Forms[i].Left = P.X) and (Screen.Forms[i].Top = P.Y)
      then
        begin
          Result := False;
          Break;
        end;
    end;
end;

var
  R: TRect;
  P: TPoint;
  MW, MH, W, H: Integer;
  B: Boolean;
begin
  P := Point(0, 0);
  MW := GetMinWidth;
  MH := GetMinHeight;
  if FForm.FormStyle = fsMDIChild
  then
    begin
      R := GetMDIWorkArea;
      W := RectWidth(R);
      H := RectHeight(R);
      P.Y := H - MH;
      P.X := 0;
      repeat
        B := GetMDIEqualCoord(P);
        if not B
        then
          begin
            P.X := P.X + MW;
            if P.X + MW > W
            then
              begin
                P.X := 0;
                P.Y := P.Y - MH;
                if P.Y < 0
                then
                  begin
                    P.Y := H - MH;
                    B := True;
                  end;
              end;
          end;
      until B;
    end
  else
    begin
      R := GetMonitorWorkArea(FForm.Handle, True);
      P.Y := R.Bottom - MH;
      P.X := R.Left;
      repeat
        B := GetSDIEqualCoord(P);
        if not B
        then
          begin
            P.X := P.X + MW;
            if P.X + MW > R.Bottom
            then
              begin
                P.X := R.Left;
                P.Y  := P.Y - MH;
                if P.Y < R.Top
                then
                   begin
                     P.Y := R.Bottom - MH;
                     B := True;
                   end;
              end;
          end;
      until B;
    end;   
  Result := P;
end;

function TspDynamicSkinForm.CanObjectTest;
begin
   if FSupportNCArea
   then
     Result := not ARollUp
   else
     Result := (FRollUpState and ARollUp) or (not FRollUpState and not ARollUp);
end;

procedure TspDynamicSkinForm.SetSupportNCArea;
begin
  FSupportNCArea := Value;
  if FForm <> nil then 
  if not FSupportNCArea and (csDesigning in ComponentState)
  then FForm.BorderStyle := bsNone;
end;

function TspDynamicSkinForm.GetMinWidth: Integer;
begin
 if FSupportNCArea
 then
    begin
      if FSkinSupport
      then
        begin
          if (FMinWidth > FSD.FPicture.Width) and
          not (FWindowState = wsMinimized)
          then Result := FMinWidth
          else
            begin
              if FSD.FormMinWidth > 0
              then
                begin
                  if (FMinWidth > FSD.FormMinWidth) and
                   not (FWindowState = wsMinimized)
                  then
                    Result := FMinWidth
                  else
                    Result := FSD.FormMinWidth
                end
              else
                Result := FSD.FPicture.Width;
            end;  
        end
      else
        begin
          if FMinWidth > 0
          then Result := FMinWidth
          else Result := DEFFORMMINWIDTH;
        end;
    end
  else
    begin
      if FSkinSupport
      then
        begin
          if FMinWidth = 0
          then
             Result := FSD.FPicture.Width
          else
            if FSkinSupport and (FMinWidth > FSD.FPicture.Width)
            then Result := FSD.FPicture.Width
            else Result := FMinWidth;
        end
      else
        Result := 0;
    end;
end;

function TspDynamicSkinForm.GetMinHeight: Integer;
begin
  if FSupportNCArea
  then
    begin
      if FSkinSupport
      then
        begin
          if CanShowBorderLayer and (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder
          then
            begin
              if (FMinHeight > FSD.FPicture.Height - RectHeight(FSD.ClRect))
              and not FRollUpState
              and not (FWindowState = wsMinimized)
              then Result := FMinHeight
              else Result := 10;
            end
          else
            begin
              if FSD.FormMinHeight = 0
              then
                begin
                  if (FMinHeight > FSD.FPicture.Height - RectHeight(FSD.ClRect))
                  and not FRollUpState
                  and not (FWindowState = wsMinimized)
                  then Result := FMinHeight
                  else Result := FSD.FPicture.Height - RectHeight(FSD.ClRect);
                end
              else
                begin
                  if (FMinHeight > FSD.FormMinHeight)
                  and not FRollUpState
                  and not (FWindowState = wsMinimized)
                  then Result := FMinHeight
                  else Result := FSD.FormMinHeight;
                end; 
            end;
        end
      else
        begin
          if (FMinHeight > GetDefCaptionHeight + 6)
          and not FRollUpState
          and not (FWindowState = wsMinimized)
          then Result := FMinHeight
          else Result := GetDefCaptionHeight + 6;
        end;
    end
  else
    begin
      if FSkinSupport
      then
        begin
          if (FMinHeight = 0)
          then
            Result := FSD.FPicture.Height
          else
          if (FMinHeight > FSD.FPicture.Height)
          then Result := FSD.FPicture.Height
          else Result := FMinHeight;
        end
      else
        Result := 0;
    end;
end;

function TspDynamicSkinForm.GetMaxWidth: Integer;
var
  R: TRect;
begin
  R := GetMonitorWorkArea(FForm.Handle, not FMaximizeOnFullScreen);
  Result := RectWidth(R);
  if (FMaxWidth <> 0)
  then
    Result := FMaxWidth;
end;

function TspDynamicSkinForm.GetMaxHeight: Integer;
var
  R: TRect;
begin
  R := GetMonitorWorkArea(FForm.Handle, not FMaximizeOnFullScreen);
  Result := RectHeight(R);
  if (FMaxHeight <> 0) 
  then
    Result := FMaxHeight;
end;

procedure TspDynamicSkinForm.DrawSkinObject;
var
  DC: HDC;
  Cnvs: TControlCanvas;
begin
  if CanObjectTest(AObject.RollUp) then
  if SupportNCArea
  then
    begin
      if CanShowBorderLayer and FBorderLayer.FVisible and
         FBorderLayer.FData.FullBorder
      then
        begin
          FBorderLayer.UpdateBorder;
        end
      else
      if AObject.MustParentUpdate
      then
        begin
          UpdateFormNC;
        end
      else
      if not(((WindowState = wsMaximized) and (FForm.FormStyle = fsMDIChild))
            or (FForm.BorderStyle = bsNone))
      then
        begin
          DC := GetWindowDC(FForm.Handle);
          Cnvs := TControlCanvas.Create;
          Cnvs.Handle := DC;
          //
          AObject.Draw(Cnvs, True);
          //
          Cnvs.Handle := 0;
          ReleaseDC(FForm.Handle, DC);
          Cnvs.Free;
        end;
    end
  else
    AObject.Draw(FForm.Canvas, True);
end;

procedure TspDynamicSkinForm.PointToNCPoint(var P: TPoint);
begin
  if FForm.FormStyle = fsMDIChild
  then
    begin
      P := FForm.ScreenToClient(P);
      if FSkinSupport
      then
        begin
          P.X := P.X + NewClRect.Left;
          P.Y := P.Y + NewClRect.Top;
        end
      else
        begin
          P.X := P.X + 3;
          P.Y := P.Y + GetDefCaptionHeight + 3;
        end;
    end
  else
    begin
      P.X := P.X - FForm.Left;
      P.Y := P.Y - FForm.Top;
    end;
end;


procedure TspDynamicSkinForm.PaintNCSkin;
var
  CaptionBitMap, LeftBitMap, RightBitMap, BottomBitMap: TBitMap;
  DC: HDC;
  Cnvs: TCanvas;
  TempRect: TRect;
  i: Integer;
  P: TBitMap;
  CEB, LEB, REB, BEB: TspEffectBmp;
begin
  if not CanNCSupport then Exit;

  if FFormWidth = 0 then FFormWidth := FForm.Width;
  if FFormheight = 0 then FFormHeight := FForm.Height;

  if (FFormWidth < GetMinWidth) or (FFormHeight < GetMinHeight) then Exit;

  CalcRects;
  CalcAllRealObjectRect;

  if not AUseExternalDC then DC := GetWindowDC(FForm.Handle) else DC := ADC;

  Cnvs := TCanvas.Create;
  Cnvs.Handle := DC;

  CaptionBitMap := TBitMap.Create;
  LeftBitMap := TBitMap.Create;
  RightBitMap := TBitMap.Create;
  BottomBitMap := TBitMap.Create;

  if not GetFormActive and not FSD.FInActivePicture.Empty
  then
    P := FSD.FInActivePicture
  else
    P := FSD.FPicture;

  // crate borderbitmap
  with FSD do
    CreateSkinBorderImages(LTPoint, RTPoint, LBPoint, RBPoint, ClRect,
      NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftBitMap, CaptionBitMap, RightBitMap, BottomBitMap,
      P, Rect(0, 0, P.Width, P.Height),
      FFormWidth, FFormHeight,
      LeftStretch, TopStretch, RightStretch, BottomStretch);

  // draw mainmenuitems
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if NewMainMenuRect.Top <= NewClRect.Top
        then
          Draw(CaptionBitMap.Canvas, False)
        else
          Draw(BottomBitMap.Canvas, False);
      end;

  // draw skin objects

  for i := 0 to ObjectList.Count - 1 do
     with TspActiveSkinObject(ObjectList.Items[i]) do
     if CanObjectTest(RollUp) and
        not (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem)
     then
       if Visible then 
       begin
         if (ObjectRect.Bottom <= NewClRect.Top)
         then
           Draw(CaptionBitMap.Canvas, False)
         else
           begin
             TempRect := ObjectRect;
             OffsetRect(ObjectRect, 0, -NewClRect.Bottom);
             Draw(BottomBitMap.Canvas, False);
             ObjectRect := TempRect;
           end;
       end;
  //
  if NewClRect.Bottom > NewClRect.Top
  then
    ExcludeClipRect(Cnvs.Handle,
      NewClRect.Left, NewClRect.Top, NewClRect.Right, NewClRect.Bottom);
  // paint nc
  if GetFormActive or not GetAutoRenderingInActiveImage
  then
    begin
      Cnvs.Draw(0, 0, CaptionBitMap);
      Cnvs.Draw(0, CaptionBitMap.Height, LeftBitMap);
      Cnvs.Draw(FFormWidth - RightBitMap.Width, CaptionBitMap.Height, RightBitMap);
      Cnvs.Draw(0, FFormHeight - BottomBitMap.Height, BottomBitMap);
    end
  else
    begin
      CEB := TspEffectBmp.CreateFromhWnd(CaptionBitMap.Handle);
      LEB := TspEffectBmp.CreateFromhWnd(LeftBitMap.Handle);
      REB := TspEffectBmp.CreateFromhWnd(RightBitMap.Handle);
      BEB := TspEffectBmp.CreateFromhWnd(BottomBitMap.Handle);

      case FSD.InActiveEffect of
        ieBrightness:
          begin
            CEB.ChangeBrightness(InActiveBrightnessKf);
            LEB.ChangeBrightness(InActiveBrightnessKf);
            REB.ChangeBrightness(InActiveBrightnessKf);
            BEB.ChangeBrightness(InActiveBrightnessKf);
          end;
        ieDarkness:
          begin
            CEB.ChangeDarkness(InActiveDarknessKf);
            LEB.ChangeDarkness(InActiveDarknessKf);
            REB.ChangeDarkness(InActiveDarknessKf);
            BEB.ChangeDarkness(InActiveDarknessKf);
          end;
        ieGrayScale:
          begin
            CEB.GrayScale;
            LEB.GrayScale;
            REB.GrayScale;
            BEB.GrayScale;
          end;
        ieNoise:
          begin
            CEB.AddMonoNoise(InActiveNoiseAmount);
            LEB.AddMonoNoise(InActiveNoiseAmount);
            REB.AddMonoNoise(InActiveNoiseAmount);
            BEB.AddMonoNoise(InActiveNoiseAmount);
          end;
        ieSplitBlur:
          begin
            CEB.SplitBlur(1);
            LEB.SplitBlur(1);
            REB.SplitBlur(1);
            BEB.SplitBlur(1);
          end;
        ieInvert:
          begin
            CEB.Invert;
            LEB.Invert;
            REB.Invert;
            BEB.Invert;
          end;
      end;

      CEB.Draw(Cnvs.Handle, 0, 0);
      LEB.Draw(Cnvs.Handle, 0, CaptionBitMap.Height);
      REB.Draw(Cnvs.Handle, FFormWidth - RightBitMap.Width, CaptionBitMap.Height);
      BEB.Draw(Cnvs.Handle, 0, FFormHeight - BottomBitMap.Height);

      CEB.Free;
      LEB.Free;
      REB.Free;
      BEB.Free;
    end;
  //
  BottomBitMap.Free;
  RightBitMap.Free;
  LeftBitMap.Free;
  CaptionBitMap.Free;

  if not AUseExternalDC then ReleaseDC(FForm.Handle, DC);
  
  Cnvs.Handle := 0;
  Cnvs.Free;
end;

procedure TspDynamicSkinForm.FormShortCut;
var
  MM: TMainMenu;
  I: Integer;
begin

  if Assigned(FOnShortCut) 
  then 
   begin
     FOnShortCut(Msg, Handled);
     if Handled then Exit; 
   end;


  if ((KeyDataToShiftState(Msg.KeyData) = [ssAlt]) and (Msg.CharCode = VK_SPACE))
  then
    begin
      PopupSystemMenu;
      FInShortCut := False;
      Handled := True;
      Exit;
    end;


  if FInShortCut
  then
    begin
      FInShortCut := False;
      Handled := False;
    end;


  if (FMainMenuBar <> nil) and (FMainMenuBar.MainMenu <> nil)
  then
    MM := FMainMenuBar.MainMenu
  else
    MM := FMainMenu;

  if MM <> nil
  then
  if (KeyDataToShiftState(Msg.KeyData) = [ssAlt]) and (Msg.CharCode <> VK_F4)
     and FindHotKeyItem(Msg.CharCode)
  then
    Handled := True
  else
    begin
      FInShortCut := MM.IsShortCut(Msg);
      if FInShortCut then Handled := True else Handled := False;
    end;

  if not FInShortCut and (FMainMenuBar <> nil) and
     (FMainMenuBar.GetChildMainMenu <> nil)
  then
    begin
      MM := FMainMenuBar.GetChildMainMenu;
      if (KeyDataToShiftState(Msg.KeyData) = [ssAlt]) and FindHotKeyItem(Msg.CharCode)
      then
        Handled := True
      else
        begin
          FInShortCut := MM.IsShortCut(Msg);
          if FInShortCut then Handled := True else Handled := False;
        end;
    end;

  if (FMenuButtonPopupMenu <> nil) and FMenuButtonVisible and not FInShortCut
  then
    begin
      FInShortCut := FMenuButtonPopupMenu.IsShortCut(Msg);
      if not FInShortCut and IsAccel(Msg.CharCode, FMenuButtonCaption) and (GetKeyState(VK_MENU) < 0)
       then
         begin
           FInShortCut := True;
           if MainMenuBar <> nil then MainMenuBar.MenuClose;
           MenuButtonTrackMenu;
         end;
      if FInShortCut then Handled := True;
    end;

  if (FCaptionTabs.Count <> 0) and not FInShortCut then
  begin
    for I := 0 to FCaptionTabs.Count - 1 do
     if FCaptionTabs[I].Visible and
        IsAccel(Msg.CharCode, FCaptionTabs[I].Caption) and
        (GetKeyState(VK_MENU) < 0)
     then
       begin
         CaptionTabIndex := I;
         Break;
       end;
  end;

  if (FSystemMenu <> nil) and not FInShortCut and (Msg.CharCode <> 0)
  then
    begin
      FInShortCut := FSystemMenu.IsShortCut(Msg);
      if FInShortCut then Handled := True;
    end;

end;

procedure TspDynamicSkinForm.SetDefaultCaptionText(AValue: String);
var
  i: Integer;
begin
  if (FSD <> nil) and (not FSD.Empty)
  then
    for i := 0 to ObjectList.Count - 1 do
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
      then
        with TspSkinCaptionObject(ObjectList.Items[i]) do
        begin
          if DefaultCaption
          then TextValue := FForm.Caption;
        end
end;

procedure TspDynamicSkinForm.SetFormBorderStyle;
begin
  FForm.BorderStyle := BS;
  UpDateSkinControls(0, FForm);
end;

procedure TspDynamicSkinForm.SetFormStyle;
begin
  if (FS = fsNormal) or (FS = fsStayOnTop)
  then
    begin
      FForm.FormStyle := FS;
      if FAlphaBlend then UpDateSkinControls(0, FForm);
    end;
end;

procedure TspDynamicSkinForm.SetRollUpFormRegion;
var
  RMask: TBitMap;
  Size: Integer;
  RgnData: PRgnData;
  TempRgn: HRGN;
begin
  if (FSD.FRollUpMask.Empty) and (FRgn = 0) then Exit;
  if (FSD.FRollUpMask.Empty) and (FRgn <> 0)
  then
    begin
      SetWindowRgn(FForm.Handle, 0, True);
      DeleteObject(FRgn);
      FRgn := 0;
    end
  else
    if (not FSD.FRollUpMask.Empty)
    then
      begin
        if FSD.RollUpRightPoint.X > FSD.RollUpLeftPoint.X
        then
          begin
            RMask := TBitMap.Create;
            with FSD do
              CreateHSkinImage(
                 RollUpLeftPoint.X, FRollUpMask.Width - RollUpRightPoint.X,
                 RMask, FRollUpMask,
                 Rect(0, 0, FRollUpMask.Width, FRollUpMask.Height),
                 FForm.Width, FRollUpMask.Height, False);
            Size := CreateRgnFromBmp(RMask, 0, 0, RgnData);
            RMask.Free;
          end
        else
          Size := CreateRgnFromBmp(FSD.FRollUpMask, 0, 0, RgnData);

        if Size <> 0
        then
          begin
            TempRgn := FRgn;
            FRgn := ExtCreateRegion(nil, Size, RgnData^);
            SetWindowRgn(FForm.Handle, FRgn, True);
            if TempRgn <> 0 then DeleteObject(TempRgn);
            FreeMem(RgnData, Size);
          end;
      end;
end;

procedure TspDynamicSkinForm.CreateRollUpForm2;
begin
  if CanShowBorderLayer and FBorderLayer.FVisible and FBorderLayer.FData.FullBorder
  then
    begin
      if FForm.Height <> GetMinHeight
      then
        FForm.Height := GetMinHeight
      else
        begin
          FForm.Height := GetMinHeight + 1;
          OldHeight := FForm.Height;
          FForm.Height := GetMinHeight;
        end;
    end
  else
    FForm.Height := GetMinHeight;
end;

procedure TspDynamicSkinForm.CreateRollUpForm;
var
  W, H, dx: Integer;

procedure CalcRollUpObjectsRects;

function CalcRollUpObjectRect(R: TRect): TRect;
begin
  if R.Left >= FSD.RollUpRightPoint.X
  then
    OffsetRect(R, dx, 0)
  else
  if (R.Left <= FSD.RollUpLeftPoint.X) and
     (R.Right >= FSD.RollUpRightPoint.X)
  then
    Inc(R.Right, dx);
  Result := R;  
end;

var
  i: Integer;
begin
  if (FSD.RollUpRightPoint.X > FSD.RollUpLeftPoint.X)
  then
    for i := 0 to ObjectList.Count - 1 do
      with TspActiveSkinObject(ObjectList.Items[i]) do
      begin
        if RollUp
        then
          ObjectRect := CalcRollUpObjectRect(SkinRect);
      end;
end;

procedure HideControls;
var
  i: Integer;
begin
  VisibleControls.Clear;
  for i := 0 to FForm.ControlCount - 1 do
  begin
    if FForm.Controls[i].Visible
    then
      begin
        VisibleControls.Add(FForm.Controls[i]);
        FForm.Controls[i].Visible := False;
      end;
  end;
end;

begin
  H := FSD.FRollUpPicture.Height;
  if FSD.RollUpLeftPoint.X >= FSD.RollUpRightPoint.X
  then
    begin
      W := FSD.FRollUpPicture.Width;
      dx := 0;
    end
  else
    begin
      W := FForm.Width;
      dx := W - FSD.FRollUpPicture.Width;
    end;
  CalcRollUpObjectsRects;
  TestActive(-1, -1, True);
  MouseTimer.Enabled := False;
  MorphTimer.Enabled := False;
  //
  if VisibleControls.Count = 0 then HideControls;

  if FSD.RollUpLeftPoint.X >= FSD.RollUpRightPoint.X
  then
    FForm.SetBounds(FForm.Left, FForm.Top, W, H)
  else
    FForm.Height := H;

  SetRollUpFormRegion;

  if FSupportNCArea
  then SendMessage(FForm.Handle, WM_NCPAINT, 0, 0)
  else FForm.RePaint;

  MouseTimer.Enabled := True;
  MorphTimer.Enabled := True;
end;

procedure TspDynamicSkinForm.RestoreRollUpForm2;
begin
  FForm.Height := OldHeight;
end;

procedure TspDynamicSkinForm.RestoreRollUpForm;

procedure ShowControls;
var
  i: Integer;
begin
  for i := 0 to VisibleControls.Count - 1 do
    TControl(VisibleControls.Items[i]).Visible := True;
  VisibleControls.Clear;
end;

begin
  TestActive(-1, -1, True);
  MouseTimer.Enabled := False;
  MorphTimer.Enabled := False;
  //
  ShowControls;
  if CanScale
  then
    FForm.Height := OldHeight;
  CheckSize;
  //
  MouseTimer.Enabled := True;
  MorphTimer.Enabled := True;
end;


procedure TspDynamicSkinForm.SetRollUpState;
begin
  if (not FSkinSupport and not FSupportNCArea) or not (biRollUp in FBorderIcons) or
     (FRollUpState and (FWindowState = wsMaximized) and not MaxRollUpState) or
     (FWindowState = wsMinimized)
  then Exit;

  if WindowState = wsMaximized then MaxRollUpState := Value;

  FRollUpState := Value;
  
  if FSupportNCArea
  then
    begin
      if FRollUpState
      then
        begin
          OldHeight := FForm.Height;
          CreateRollUpForm2;
        end
      else
       begin
         if FClientHeight = 0
         then
           RestoreRollUpForm2
         else
           FForm.ClientHeight := FClientHeight;
       end;
    end
 else
   if not FSD.FRollUpPicture.Empty
   then
     begin
       if FRollUpState
       then
         begin
           OldHeight := FForm.Height;
           CreateRollUpForm;
         end
       else
         RestoreRollUpForm;
     end
   else
     FRollUpState := False;
  if Assigned(FOnChangeRollUpState) then FOnChangeRollUpState(Self);
end;

procedure TspDynamicSkinForm.BeforeUpDateSkinComponents(AFSD: Integer);
var
  i: Integer;
begin
  for i := 0 to FForm.ComponentCount - 1 do
    if FForm.Components[i] is TspSkinComponent
    then
      TspSkinComponent(FForm.Components[i]).BeforeChangeSkinData;
end;

procedure TspDynamicSkinForm.BeforeUpDateSkinControls;

procedure CheckControl(C: TControl);
begin
  if C is TspSkinControl
  then
    begin
      with TspSkinControl(C) do
        if (Integer(SkinData) = AFSD) or (AFSD = 0)
        then BeforeChangeSkinData;
    end
  else
  if C is TspGraphicSkinControl
  then
    begin
      with TspGraphicSkinControl(C) do
        if (Integer(SkinData) = AFSD) or (AFSD = 0)
        then BeforeChangeSkinData;
    end;
end;

var
  i: Integer;
begin
  CheckControl(WC);
  for i := 0 to WC.ControlCount - 1 do
  begin
    if WC.Controls[i] is TWinControl
    then
      BeforeUpDateSkinControls(AFSD, TWinControl(WC.Controls[i]))
    else
      CheckControl(WC.Controls[i]);
  end;
end;

procedure TspDynamicSkinForm.UpDateSkinComponents(AFSD: Integer);
var
  i: Integer;
begin
  for i := 0 to FForm.ComponentCount - 1 do
    if FForm.Components[i] is TspSkinComponent
    then
      TspSkinComponent(FForm.Components[i]).ChangeSkinData;
end;

procedure TspDynamicSkinForm.UpDateSkinControls;

procedure CheckControl(C: TControl);
var
  i: Integer;
begin
  if C is TFrame
  then
    with TFrame(C) do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i] is TspSkinFrame
        then
          begin
            TspSkinFrame(Components[i]).ChangeSkindata;
            Break;
          end;
      end;
    end
  else
  if C is TspGraphicSkinControl
  then
    begin
      with TspGraphicSkinControl(C) do
        if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData
    end
  else
  if C is TspSkinControl
  then
    begin
      with TspSkinControl(C) do
        if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData
    end
  else
    if C is TspSkinPageControl
    then
      begin
        with TspSkinPageControl(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData
      end
    else
    if C is TspSkinTabControl
    then
      begin
        with TspSkinTabControl(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData
      end    
    else
    if C is TspSkinCustomEdit
    then
      begin
        with TspSkinCustomEdit(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinMemo
    then
      begin
        with TspSkinMemo(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinMemo2
    then
      begin
        with TspSkinMemo2(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinLinkLabel
    then
      begin
        with TspSkinLinkLabel(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinButtonLabel
    then
      begin
        with TspSkinButtonLabel(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinStdLabel
    then
      begin
        with TspSkinStdLabel(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinTextLabel
    then
      begin
        with TspSkinTextLabel(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinCustomTreeView
    then
      begin
        with TspSkinTreeView(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinCustomListView
    then
      begin
        with TspSkinListView(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinHeaderControl
    then
      begin
        with TspSkinHeaderControl(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinControlBar
    then
      begin
        with TspSkinControlBar(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinSplitter
    then
      begin
        with TspSkinSplitter(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end
    else
    if C is TspSkinBevel
    then
      begin
        with TspSkinBevel(C) do
          if (Integer(SkinData) = AFSD) or (AFSD = 0) then ChangeSkinData;
      end;
end;

var
  i: Integer;
begin
  CheckControl(WC);
  for i := 0 to WC.ControlCount - 1 do
  begin
    if WC.Controls[i] is TWinControl
    then
      UpDateSkinControls(AFSD, TWinControl(WC.Controls[i]))
    else
      CheckControl(WC.Controls[i]);
  end;
end;

procedure TspDynamicSkinForm.UnLinkControlFromArea(Control: TControl);
var
  i, j: Integer;
begin
  j := -1;
  for i := 0 to AreaList.Count - 1 do
  begin
    if PAreaInfo(AreaList.Items[i])^.Control = Control
    then
      begin
        j := i;
        Break;
      end;
  end;
  if j <> -1
  then
    begin
      FreeMem(PAreaInfo(AreaList.Items[i]), Sizeof(TAreaInfo));
      AreaList.Delete(j);
    end;
end;

procedure TspDynamicSkinForm.LinkControlToArea;

procedure GetAreaData(var AAreaRect: TRect; var AUseAnchors,
  AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom: Boolean);
var
  i: Integer;
begin
  i := FSD.GetAreaIndex(AreaName);
  if i <> - 1
  then
    begin
      AAreaRect := TspDataSkinArea(FSD.AreaList.Items[i]).AreaRect;
      AUseAnchors := TspDataSkinArea(FSD.AreaList.Items[i]).UseAnchors;
      AAnchorLeft := TspDataSkinArea(FSD.AreaList.Items[i]).AnchorLeft;
      AAnchorTop := TspDataSkinArea(FSD.AreaList.Items[i]).AnchorTop;
      AAnchorRight := TspDataSkinArea(FSD.AreaList.Items[i]).AnchorRight;
      AAnchorBottom := TspDataSkinArea(FSD.AreaList.Items[i]).AnchorBottom;
    end
  else
    begin
      AAreaRect := NullRect;
      AUseAnchors := False;
      AAnchorLeft := False;
      AAnchorTop := False;
      AAnchorRight := False;
      AAnchorBottom := False;
    end;  
end;

var
  PAI: PAreaInfo;
  R: TRect;
  FUseAnchors, FAnchorLeft, FAnchorTop, FAnchorRight, FAnchorBottom: Boolean;
begin
  GetAreaData(R, FUseAnchors, FAnchorLeft, FAnchorTop, FAnchorRight, FAnchorBottom);
  if IsNullRect(R) then Exit;
  GetMem(PAI, Sizeof(TAreaInfo));
  Control.Align := alNone;
  PAI^.Control := Control;
  PAI^.AreaRect := R;
  PAI^.UseAnchors := FUseAnchors;
  PAI^.AnchorLeft := FAnchorLeft;
  PAI^.AnchorTop := FAnchorTop;
  PAI^.AnchorRight := FAnchorRight;
  PAI^.AnchorBottom := FAnchorBottom;
  AreaList.Add(PAI);
end;

type
  TParentControl = class(TWinControl);

procedure TspDynamicSkinForm.ControlsToAreas;
var
  i: Integer;
  R: TRect;
  FCanScale: Boolean;
begin
  if AreaList.Count = 0 then Exit;
  FCanScale := CanScale;
  for i := 0 to AreaList.Count - 1 do
  with PAreaInfo(AreaList.Items[i])^ do
  begin
    if FCanScale
    then
      R := CalcRealObjectRect2(AreaRect, UseAnchors, AnchorLeft, AnchorTop,
       AnchorRight, AnchorBottom)
    else
      R := AreaRect;
    Control.SetBounds(R.Left, R.Top, RectWidth(R), RectHeight(R));
    //
    if Control is TWinControl
    then
      begin
        R := Control.ClientRect;
        TParentControl(Control).AlignControls(nil, R);
      end;
    //
  end;
end;

procedure TspDynamicSkinForm.PopupSkinMenu;
var
  R: TRect;
begin
  SkinMenuOpen;
  R := Rect(P.X, P.Y, P.X, P.Y);
  if MenusSkinData = nil
  then
    SkinMenu.Popup(nil, SkinData, 0, R, Menu.Items, False)
  else
    SkinMenu.Popup(nil, MenusSkinData, 0, R, Menu.Items, False);
end;

procedure TspDynamicSkinForm.PopupSkinMenu1;
begin
  SkinMenuOpen;
  if MenusSkinData = nil
  then
    SkinMenu.Popup(nil, SkinData, 0, R, Menu.Items, PopupUp)
  else
    SkinMenu.Popup(nil, MenusSkinData, 0, R, Menu.Items, PopupUp);
end;

procedure TspDynamicSkinForm.SetMainMenu;
begin
  FMainMenu := Value;
  if (FSD <> nil) and not FSD.Empty and
     not (csDesigning in ComponentState)
  then UpDateMainMenu(True);
end;

procedure TspDynamicSkinForm.SkinMenuOpen;
begin
  if not InMainMenu
  then
    begin
      HookApp;
    end;
  if not InMenu
  then
    begin
      InMenu := True;
      if Assigned(FOnSkinMenuOpen) then FOnSkinMenuOpen(Self);
    end;
end;

procedure TspDynamicSkinForm.SkinMainMenuClose;
var
  i: Integer;
begin
  InMainMenu := False;
  if SkinMenu.Visible then SkinMenu.Hide;
  if FMainMenuBar <> nil
  then
    FMainMenuBar.MenuExit
  else  
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem then
    begin
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
        if Active then
        begin
          MouseLeave;
          Break;
        end;
    end;
  UnHookApp;
  if Assigned(FOnMainMenuExit) then FOnMainMenuExit(Self);  
end;

procedure TspDynamicSkinForm.SkinMenuClose2;
var
  i: Integer;
begin
  InMenu := False;
  if FMainMenuBar <> nil
  then
    FMainMenuBar.MenuClose
  else
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem then
    begin
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
        if FDown then
        begin
          SetDown(False);
          MouseEnter;
          Break;
        end;
    end;
  if Assigned(FOnSkinMenuClose) then FOnSkinMenuClose(Self);
end;

procedure TspDynamicSkinForm.SkinMenuClose;
var
  i: Integer;
begin
  if FMenuLayerManager.IsVisible then FMenuLayerManager.Hide;
  InMenu := False;

  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject then
    begin
      with TspSkinCaptionObject(ObjectList.Items[i]) do
        if PopupMenuQuickButton <> -1 then
        begin
          QuickButtons[PopupMenuQuickButton].Down := False;
          QuickButtons[PopupMenuQuickButton].Active := False;
          PopupMenuQuickButton := -1;
          UpdateNCForm;
        end;
    end
    else
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem then
    begin
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
        if FDown then
        begin
          Active := False;
          SetDown(False);
          Break;
        end;
    end
    else
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinButtonObject then
    begin
      with TspSkinButtonObject (ObjectList.Items[i]) do
        if (MenuItem <> nil) and FDown and
           (FMenuTrackObject <> TspActiveSkinObject(ObjectList.Items[i])) then
        begin
          if SkinMenu.Visible then SkinMenu.Hide;
          SetDown(False);
          Break;
        end;
    end
    else
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject then
    begin
      with TspSkinAnimateObject(ObjectList.Items[i]) do
        if (MenuItem <> nil) and FMenuTracking and
           (FMenuTrackObject <> TspActiveSkinObject(ObjectList.Items[i]))  then
        begin
          Active := True;
          FFrame := CountFrames;
          FDown := False;
          FMenuTracking := False;
          Increment := False;
          if SkinMenu.Visible then SkinMenu.Hide;
          if not AnimateTimer.Enabled
          then
            AnimateTimer.Enabled := True;
          Break;
        end;
    end;

  UnHookApp;

  if Assigned(FOnSkinMenuClose) then FOnSkinMenuClose(Self);

  if InMainMenu
  then
    begin
      InMainMenu := False;
      if FMainMenuBar <> nil then FMainMenuBar.MenuExit;
      if Assigned(FOnMainMenuExit) then FOnMainMenuExit(Self);
    end;

end;

procedure TspDynamicSkinForm.CheckWindowState;
begin
  if (ActiveObject <> -1)
  then
    if (TspActiveSkinObject(ObjectList.Items[ActiveObject]) is TspSkinCaptionObject) and
       FNCDraggAble
    then
      begin
        if FRollUpState
        then
          RollUpState := False
        else
          if not FSizeAble
          then
            RollUpState := True
          else
            if WindowState = wsNormal
            then WindowState := wsMaximized
            else WindowState := wsNormal;
      end;
end;

procedure TspDynamicSkinForm.CheckObjectsHint;
var
  i: Integer;
begin
  if (not FUseDefaultObjectHint) or (FSD = nil) or (ObjectList.Count = 0) then Exit;
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
    then
      with TspSkinAnimateObject(ObjectList.Items[i]) do
      begin
        if FSD.ResourceStrData = nil
        then
          case Command of
            cmClose: Hint := SP_CLOSEBUTTON_HINT;
            cmMaximize: Hint := SP_MAXBUTTON_HINT;
            cmMinimize: Hint := SP_MINBUTTON_HINT;
            cmRollUp: Hint := SP_ROLLUPBUTTON_HINT;
            cmMinimizeToTray: Hint := SP_TRAYBUTTON_HINT;
            cmSysMenu: Hint := SP_MENUBUTTON_HINT;
          end
        else
          case Command of
            cmClose: Hint := FSD.ResourceStrData.GetResStr('CLOSEBUTTON_HINT');
            cmMaximize: Hint := FSD.ResourceStrData.GetResStr('MAXBUTTON_HINT');
            cmMinimize: Hint := FSD.ResourceStrData.GetResStr('MINBUTTON_HINT');
            cmRollUp: Hint := FSD.ResourceStrData.GetResStr('ROLLUPBUTTON_HINT');
            cmMinimizeToTray: Hint := FSD.ResourceStrData.GetResStr('TRAYBUTTON_HINT');
            cmSysMenu: Hint := FSD.ResourceStrData.GetResStr('MENUBUTTON_HINT');
          end;
         FTempHint := Hint;
         if FSD.ResourceStrData = nil
         then
           RestoreHint :=  SP_RESTORE_HINT
         else
           RestoreHint :=  FSD.ResourceStrData.GetResStr('RESTORE_HINT');
       end
     else
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinStdButtonObject
      then
        with TspSkinStdButtonObject(ObjectList.Items[i]) do
        begin
          if FSD.ResourceStrData = nil
          then
            case Command of
              cmClose: Hint := SP_CLOSEBUTTON_HINT;
              cmMaximize: Hint := SP_MAXBUTTON_HINT;
              cmMinimize: Hint := SP_MINBUTTON_HINT;
              cmRollUp: Hint := SP_ROLLUPBUTTON_HINT;
              cmMinimizeToTray: Hint := SP_TRAYBUTTON_HINT;
              cmSysMenu: Hint := SP_MENUBUTTON_HINT;
            end
          else
            case Command of
              cmClose: Hint := FSD.ResourceStrData.GetResStr('CLOSEBUTTON_HINT');
              cmMaximize: Hint := FSD.ResourceStrData.GetResStr('MAXBUTTON_HINT');
              cmMinimize: Hint := FSD.ResourceStrData.GetResStr('MINBUTTON_HINT');
              cmRollUp: Hint := FSD.ResourceStrData.GetResStr('ROLLUPBUTTON_HINT');
              cmMinimizeToTray: Hint := FSD.ResourceStrData.GetResStr('TRAYBUTTON_HINT');
              cmSysMenu: Hint := FSD.ResourceStrData.GetResStr('MENUBUTTON_HINT');
            end;
           FTempHint := Hint;
          if FSD.ResourceStrData = nil
          then
            RestoreHint :=  SP_RESTORE_HINT
          else
            RestoreHint :=  FSD.ResourceStrData.GetResStr('RESTORE_HINT');
        end;
end;

procedure TspDynamicSkinForm.CheckObjects;

function IsDialogCloseButtonAvailable: Boolean;
var
  j: Integer;
begin
  Result := False;
  for j := 0 to ObjectList.Count - 1 do
  begin
    if TspActiveSkinObject(ObjectList.Items[j]).IDName = 'dialogclosebutton'
    then
      begin
        Result := True;
        Break;
      end;
  end;
end;

var
  i, j: Integer;
  B, ObjectVisible: Boolean;
begin
  if ObjectList.Count > 0 then
  if FHideCaptionButtons
  then
    begin
      for i := 0 to ObjectList.Count - 1 do
        if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
        then
          with TspSkinAnimateObject(ObjectList.Items[i]) do
          begin
            Enabled := False;
            Visible := not SkinRectInAPicture;
          end
        else
        if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinStdButtonObject
        then
          with TspSkinStdButtonObject(ObjectList.Items[i]) do
          begin
            Enabled := False;
            Visible := not SkinRectInAPicture;
          end;
    end
  else
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
    then
      with TspSkinAnimateObject(ObjectList.Items[i]) do
      begin
        if ButtonStyle and (Command <> cmDefault)
        then
          begin
            if (Command = cmDefault)
            then
              begin
                ObjectVisible := False;
                if Assigned(FOnActivateCustomObject)
                then
                  FOnActivateCustomObject(IDName, ObjectVisible);
                Visible := ObjectVisible;
              end
            else
            if Command = cmMinimizeToTray
            then
              begin
                Enabled := biMinimizeToTray in FBorderIcons;
                if SkinRectInAPicture then Visible := Enabled else  Visible := True;
              end
            else
            if Command = cmRollUp
            then
              begin
                Enabled := biRollUp in FBorderIcons;
                if SkinRectInAPicture then Visible := Enabled else  Visible := True;
              end
            else
            if Command = cmMaximize
            then
               begin
                 Enabled := biMaximize in FBorderIcons;
                 if SkinRectInAPicture then Visible := Enabled else  Visible := True;
               end
            else
            if Command = cmMinimize
            then
              begin
                Enabled := biMinimize in FBorderIcons;
                if SkinRectInAPicture then Visible := Enabled else  Visible := True;
              end
            else
            if Command = cmSysMenu
            then
              begin
                Enabled := biSystemMenu in FBorderIcons;
                if FDisableSystemMenu then Enabled := False;
                if SkinRectInAPicture then Visible := Enabled else  Visible := True;
              end;
         end;
      end
    else
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinStdButtonObject
    then
      with TspSkinStdButtonObject(ObjectList.Items[i]) do
      begin
        if (Command = cmClose)
        then
          begin
            if ((BorderIcons = []) or (BorderIcons = [biSystemMenu])) and
               IsDialogCloseButtonAvailable
            then
              begin
                if IDName = 'dialogclosebutton'
                then
                  begin
                    Enabled := True;
                    Visible := True;
                  end
                else
                  begin
                    Enabled := False;
                    Visible := False;
                  end;
              end
            else
              begin
                if IDName = 'dialogclosebutton'
                then
                  begin
                    Enabled := False;
                    Visible := False;
                  end;
              end;
          end
        else
        if (Command = cmDefault)
            then
              begin
                ObjectVisible := False;
                if Assigned(FOnActivateCustomObject)
                then
                  FOnActivateCustomObject(IDName, ObjectVisible);
                Visible := ObjectVisible;
              end
            else
         if Command = cmMinimizeToTray
            then
              begin
                Enabled := biMinimizeToTray in FBorderIcons;
                if SkinRectInAPicture then Visible := Enabled else  Visible := True;
              end
            else
        if Command = cmRollUp
           then
             begin
               Enabled := biRollUp in FBorderIcons;
               if SkinRectInAPicture then Visible := Enabled else  Visible := True;
             end
           else
        if Command = cmMaximize
           then
             begin
               Enabled := biMaximize in FBorderIcons;
               if SkinRectInAPicture then Visible := Enabled else  Visible := True;
             end
           else
        if Command = cmMinimize
           then
             begin
               Enabled := biMinimize in FBorderIcons;
               if SkinRectInAPicture then Visible := Enabled else  Visible := True;
             end
           else
        if Command = cmSysMenu
        then
          begin
            Enabled := biSystemMenu in FBorderIcons;
            if FDisableSystemMenu then Enabled := False;
            if SkinRectInAPicture then Visible := Enabled else  Visible := True;
          end;
      end
    else
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
      then
        with TspSkinCaptionObject(ObjectList.Items[i]) do
        begin
          if DefaultCaption
          then FTextValue := FForm.Caption;
        end;

  B := False;
  j := -1;

  if ObjectList.Count > 0
  then
    for i := 0 to ObjectList.Count - 1 do
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
      then
        with TspSkinCaptionObject(ObjectList.Items[i]) do
        if DefaultCaption
        then
          begin
            B := True;
            Break;
          end
        else
          if j = -1 then j := i;

  if (j <> -1) and not B and
     (TspActiveSkinObject(ObjectList.Items[j]) is TspSkinCaptionObject)
  then
    with TspSkinCaptionObject(ObjectList.Items[j]) do
    begin
      DefaultCaption := True;
      FTextValue := FForm.Caption;
    end;
  CheckObjectsHint;
end;

function TspDynamicSkinForm.CanScale;
begin
  if (FSD.RBPoint.X - FSD.LTPoint.X = 0) or
     (FSD.RBPoint.Y - FSD.LTPoint.Y = 0)
  then
    Result := False
  else
    Result := True;
end;

function TspDynamicSkinForm.GetIndex;
var
  i, j: Integer;
begin
  j := -1;
  for i := 0 to ObjectList.Count - 1 do
  begin
    if AIDName = TspActiveSkinObject(ObjectList.Items[i]).IDName
    then
      begin
        j := i;
        Break;
      end;
  end;
  Result := j;
end;

procedure TspDynamicSkinForm.UserObjectDraw;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> -1
  then
    if TspActiveSkinObject(ObjectList.Items[i]) is TspUserObject
    then
      TspUserObject(ObjectList.Items[i]).Draw(FForm.Canvas, True);
end;

procedure TspDynamicSkinForm.SwitchChangeStateEvent;
begin
 if Assigned(FOnSwitchChangeStateEvent)
 then FOnSwitchChangeStateEvent(IDName, State);
end;

procedure TspDynamicSkinForm.AnimateStart;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
  then
    TspSkinAnimateObject(ObjectList.Items[i]).Start;
end;

procedure TspDynamicSkinForm.AnimateStop;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
  then
    TspSkinAnimateObject(ObjectList.Items[i]).Stop;
end;

procedure TspDynamicSkinForm.TrackBarChangeValueEvent;
begin
 if Assigned(FOnTrackBarChangeValueEvent)
 then FOnTrackBarChangeValueEvent(IDName, Value);
end;

procedure TspDynamicSkinForm.FrameRegulatorChangeValueEvent;
begin
 if Assigned(FOnFrameRegulatorChangeValueEvent)
 then FOnFrameRegulatorChangeValueEvent(IDName, Value);
end;

function TspDynamicSkinForm.TrackBarGetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> -1
  then
    begin
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinTrackBarObject
      then
        with TspSkinTrackBarObject(ObjectList.Items[i]) do Result := Value
      else
        Result := 0;
    end
  else
    Result := 0;
end;

procedure TspDynamicSkinForm.BitLabelSetText;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinBitLabelObject
  then
    with TspSkinBitLabelObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SetTextValue(AValue, False)
      else SetTextValue(AValue, True);
end;

procedure TspDynamicSkinForm.GaugeSetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinGaugeObject
  then
    with TspSkinGaugeObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimplySetValue(AValue)
      else Value := AValue;
end;

procedure TspDynamicSkinForm.FrameGaugeSetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinFrameGaugeObject
  then
    with TspSkinFrameGaugeObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimplySetValue(AValue)
      else Value := AValue;
end;

procedure TspDynamicSkinForm.LabelSetText;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinLabelObject
  then
    with TspSkinLabelObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SetTextValue(ATextValue, False)
      else SetTextValue(ATextValue, True);
end;

function TspDynamicSkinForm.FrameRegulatorGetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> -1
  then
    begin
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinFrameRegulatorObject
      then
        with TspSkinFrameRegulatorObject(ObjectList.Items[i]) do Result := Value
      else
        Result := 0;
    end
  else
    Result := 0;
end;

procedure TspDynamicSkinForm.FrameRegulatorSetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinFrameRegulatorObject
  then
    with TspSkinFrameRegulatorObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimplySetValue(AValue)
      else Value := AValue;
end;


procedure TspDynamicSkinForm.TrackBarSetValue;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinTrackBarObject
  then
    with TspSkinTrackBarObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimplySetValue(AValue)
      else Value := AValue;
end;

procedure TspDynamicSkinForm.DoMagnetic;
var
  R: TRect;
  LW, TR: Integer;
  P: TPoint;
  NewHMagnetized,
  NewVMagnetized,
  NewHMagnetized2,
  NewVMagnetized2: Boolean;
begin
  if FForm.FormStyle <> fsMDIChild
  then
    R := GetMonitorWorkArea(FForm.Handle, True)
  else
    begin
      R := GetMDIWorkArea;
      P := Application.MainForm.ClientToScreen(Point(0, 0));
      OffsetRect(R, P.X, P.Y);
    end;

  if CanShowBorderLayer and FBorderLayer.FVisible
    and not IsNullRect(FBorderLayer.FData.BorderRect)
  then
   begin
     L := L - FBorderLayer.LeftSize;
     T := T - FBorderLayer.TopSize;
     W := W + FBorderLayer.RightSize + FBorderLayer.LeftSize;
     H := H + FBorderLayer.BottomSize + FBorderLayer.TopSize;
   end;


  NewHMagnetized := (L < R.Left + FMagneticSize) and (L > R.Left - FMagneticSize);
  NewVMagnetized := (T < R.Top + FMagneticSize) and (T > R.Top - FMagneticSize);

  if NewHMagnetized and not HMagnetized
  then
    begin
      L := R.Left;
      FOnMouseDownCoord.X := Mouse.CursorPos.X;
    end
  else
    if HMagnetized and (Abs(Mouse.CursorPos.X - FOnMouseDownCoord.X) > FMagneticSize)
    then
      L := R.Left + Mouse.CursorPos.X - FOnMouseDownCoord.X
    else
    if HMagnetized
    then
      L := R.Left;

   HMagnetized := NewHMagnetized;


  if NewVMagnetized and not VMagnetized
  then
    begin
      T := R.Top;
      FOnMouseDownCoord.Y := Mouse.CursorPos.Y;
    end
  else
    if VMagnetized and (Abs(Mouse.CursorPos.Y - FOnMouseDownCoord.Y) > FMagneticSize)
    then
      T := R.Top + Mouse.CursorPos.Y - FOnMouseDownCoord.Y
    else
    if VMagnetized
    then
      T := R.Top;

  VMagnetized := NewVMagnetized;

  LW := L + W;
  TR := T + H;

  NewHMagnetized2 := (LW > R.Right - FMagneticSize) and (LW < R.Right + FMagneticSize);
  NewVMagnetized2 := (TR > R.Bottom - FMagneticSize) and (TR < R.Bottom + FMagneticSize);


  if CanShowBorderLayer and FBorderLayer.FVisible
    and not IsNullRect(FBorderLayer.FData.BorderRect)
  then
   begin
     if NewVMagnetized2 then H := H - FBorderLayer.TopSize;
     if NewHMagnetized2 then W := W - FBorderLayer.LeftSize;
   end;

  if NewHMagnetized2 and not HMagnetized2
  then
    begin
      L := R.Right - W;
      FOnMouseDownCoord.X := Mouse.CursorPos.X;
    end
  else
    if HMagnetized2 and (Abs(Mouse.CursorPos.X - FOnMouseDownCoord.X) > FMagneticSize)
    then
      L := R.Right - W + Mouse.CursorPos.X - FOnMouseDownCoord.X
    else
    if HMagnetized2
    then
      L := R.Right - W;

   HMagnetized2 := NewHMagnetized2;


  if NewVMagnetized2 and not VMagnetized2
  then
    begin
      T := R.Bottom - H;
      FOnMouseDownCoord.Y := Mouse.CursorPos.Y;
    end
  else
    if VMagnetized2 and (Abs(Mouse.CursorPos.Y - FOnMouseDownCoord.Y) > FMagneticSize)
    then
      T := R.Bottom - H + Mouse.CursorPos.Y - FOnMouseDownCoord.Y
    else
    if VMagnetized2
    then
      T := R.Bottom - H;

   VMagnetized2 := NewVMagnetized2;

   if CanShowBorderLayer and FBorderLayer.FVisible
    and not IsNullRect(FBorderLayer.FData.BorderRect)
 then
   begin
     if not NewHMagnetized2 then L := L + FBorderLayer.LeftSize;
     if not NewVMagnetized2 then T := T + FBorderLayer.TopSize;
   end;
end;

function TspDynamicSkinForm.InForm;
var
  H: HWND;
begin
  H := WindowFromPoint(P);
  Result := H = FForm.Handle;
end;


function TspDynamicSkinForm.PtInMask;
var
  B: Boolean;
begin
  if PtInRect(NewMaskRectArea, P)
  then
    B := True
  else
    if P.Y <= NewMaskRectArea.Top
    then
      B := RMTop.Canvas.Pixels[P.X, P.Y] = BlackColor
    else
      if P.Y >= NewMaskRectArea.Bottom
      then
        B := RMBottom.Canvas.Pixels[P.X, P.Y - NewMaskRectArea.Bottom] = BlackColor
      else
        if P.X <= NewMaskRectArea.Left
        then
          B := RMLeft.Canvas.Pixels[P.X, P.Y - NewMaskRectArea.Top] = BlackColor
        else
          B := RMRight.Canvas.Pixels[P.X - NewMaskRectArea.Right, P.Y - NewMaskRectArea.Top] = BlackColor;
  Result := B;
end;

procedure TspDynamicSkinForm.SetWindowStateTemp;
var
  OldWindowState: TWindowState;
begin
  if FWindowState <> Value
  then
    begin
      OldWindowState := FWindowState;
      if not ((Value = wsMinimized) and (FForm = Application.MainForm)) and
         not (FMinimizeDefault and (Value = wsMinimized))
      then
        FWindowState := Value;
        case Value of
          wsNormal:
           begin
              if (OldWindowState = wsMaximized) and RollUpState and
                  not FRollUpBeforeMaximize
              then
                SetRollUpState(False);
              FRollUpBeforeMaximize := False;
              DoNormalize;
            end;
          wsMaximized:
            begin
              FRollUpBeforeMaximize := FRollUpState;
              DoMaximize;
            end;
          wsMinimized: DoMinimize;
        end;
    end;
end;

procedure TspDynamicSkinForm.DoMinimize;
var
  P: TPoint;
begin
  if (Application.MainForm = FForm) or not FSupportNCArea
  then
    begin
      if FSupportNCArea
      then
        begin
          {$IFDEF VER200}
          if Application.MainFormOnTaskBar
          then
            if FBorderLayer.FVisible then FBorderLayer.Hide;
          {$ENDIF}
          {$IFDEF VER185}
          if Application.MainFormOnTaskBar
          then
            if FBorderLayer.FVisible then FBorderLayer.Hide;
          {$ENDIF}
        end;
      Application.Minimize;
    end
  else
  if FMinimizeDefault
  then
    begin
      FForm.WindowState := wsMinimized;
    end
  else
    begin
      if IsNullRect(OldBoundsRect)
      then OldBoundsRect := FForm.BoundsRect;
      P := GetMinimizeCoord;
      if FBorderLayer.FVisible and (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder
      then
        FForm.SetBounds(P.X + FBorderLayer.LeftSize,
          P.Y - FBorderLayer.BottomSize + 10 - FBorderLayer.FData.RollUpFormHeight,
          GetMinWidth, GetMinHeight)
      else
        FForm.SetBounds(P.X, P.Y, GetMinWidth, GetMinHeight);
      if (FForm.FormStyle = fsMDIChild) and (FWindowState <> wsMaximized)
      then
        begin
          SendMessage(Application.MainForm.Handle, WM_MDICHILDRESTORE, 0, 0);
          SendMessage(Application.MainForm.Handle, WM_MDICHILDMIN, FForm.Handle, 0);
        end;
    end;
  if Assigned(FOnMinimize) then FOnMinimize(Self);  
end;

procedure TspDynamicSkinForm.CorrectFormBounds;
var
  L, T, W, H: Integer;
begin
  if CanShowBorderLayer and (FBorderLayer.FData <> nil) and
    (FBorderLayer.FData.FullBorder) and FBorderLayer.FVisible and (FOldFullBorder <> -1)
  then
    begin
      L := FOLdFormBounds.Left + FBorderLayer.LeftSize;
      T := FOLdFormBounds.Top + FBorderLayer.TopSize;
      W := FOLdFormBounds.Right - FBorderLayer.LeftSize - FBorderLayer.RightSize;
      H := FOLdFormBounds.Bottom - FBorderLayer.TopSize - FBorderLayer.BottomSize;
      FForm.SetBounds(L, T, W, H);
    end
  else
    begin
      if FOldFullBorder = 1
      then
        begin
          L := FOLdFormBounds.Left;
          T := FOLdFormBounds.Top;
          W := FOLdFormBounds.Right;
          H := FOLdFormBounds.Bottom;
          if FRollUpState then H := GetMinHeight;
          FForm.SetBounds(L, T, W, H);
        end;
    end;
end;

procedure TspDynamicSkinForm.DoMaximize;
var
  R, R1, R2: TRect;
  OW, OH: Integer;
begin
  if not FSupportNCArea and FIsDragging then EndDragg;
  if IsNullRect(OldBoundsRect) then OldBoundsRect := FForm.BoundsRect;
  if FForm.FormStyle = fsMDIChild
  then
    begin
      MouseTimer.Enabled := False;
      TestActive(-1, -1, False);
      R := GetMDIWorkArea;
      OW := FForm.Width;
      OH := FForm.Height;
      FForm.SetBounds(0, 0, RectWidth(R),  RectHeight(R));
      if (OW = RectWidth(R)) and (OH = RectHeight(R)) then UpDateForm;
      SendMessage(Application.MainForm.Handle, WM_MDICHILDMAX, 0, 0);
    end
  else
    begin
      if not FMaximizeOnFullScreen
      then
        begin
          R := GetMonitorWorkArea(FForm.Handle, True);
          R1 := GetMonitorWorkArea(FForm.Handle, False);
          R2 := GetPrimaryMonitorWorkArea(False);
          if (RectWidth(R) = RectWidth(R1)) and
             (RectHeight(R) = RectHeight(R1)) and EqRects(R1, R2)
          then
            InflateRect(R, -1, -1);
        end
      else
        R := GetMonitorWorkArea(FForm.Handle, False);
      if CanShowBorderLayer and (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder
      then
        FForm.SetBounds(R.Left + FBorderLayer.LeftSize, R.Top + FBorderLayer.TopSize,
        RectWidth(R) - FBorderLayer.LeftSize - FBorderLayer.RightSize,
        RectHeight(R) - FBorderLayer.TopSize - FBorderLayer.BottomSize)
      else
        FForm.SetBounds(R.Left, R.Top, RectWidth(R), RectHeight(R));
    end;
  if (FStatusBar <> nil) and (FStatusBar.SizeGrip)
  then
    begin
      FStatusBar.ShowGrip := False;
    end;

  if FBorderLayer.FVisible and (FBorderLayer.FData <> nil)  and not FBorderLayer.FData.FullBorder
  then
    FBorderLayer.Hide;

  if Assigned(FOnMaximize) then FOnMaximize(Self); 
end;

procedure TspDynamicSkinForm.DoNormalize;
var
  OW, OH: Integer;
  P: TPoint;
begin
  MaxRollUpState := False;
  if FSupportNCArea
  then
    begin
      OW := FForm.Width;
      OH := FForm.Height;

      if CanShowBorderLayer and not FBorderLayer.FVisible then  FBorderLayer.ShowWithForm;
      
      if FStartShow
      then
        begin
          FStartShow := False;
          P := GetPositionInMonitor(OldBoundsRect.Left, OldBoundsRect.Top,
          RectWidth(OldBoundsRect), RectHeight(OldBoundsRect));
          FForm.SetBounds(P.X, P.Y,
          RectWidth(OldBoundsRect),
          RectHeight(OldBoundsRect));
        end
     else
       begin
         if FBorderLayer.FVisible
         then
            FBorderLayer.SetBoundsWithForm3(OldBoundsRect.Left, OldBoundsRect.Top,
                    RectWidth(OldBoundsRect),
                    RectHeight(OldBoundsRect));

         FForm.SetBounds(OldBoundsRect.Left, OldBoundsRect.Top,
                         RectWidth(OldBoundsRect),
                         RectHeight(OldBoundsRect));
      end;

      MouseTimer.Enabled := True;

      if (OW = RectWidth(OldBoundsRect)) and
         (OH = RectHeight(OldBoundsRect))
      then
        UpDateForm;
      FForm.RePaint;
      if (FForm.FormStyle = fsMDIChild) and (FWindowState <> wsMaximized)
      then
        begin
          SendMessage(Application.MainForm.Handle, WM_MDICHILDRESTORE, 0, 0);
          SendMessage(Application.MainForm.Handle, WM_MDICHILDNORMALIZE, 0, 0);
        end;
      OldBoundsRect := NullRect;
    end
  else
    begin
      //
      if CanShowBorderLayer and not FBorderLayer.FVisible then  FBorderLayer.ShowWithForm;
      //
      FForm.SetBounds(OldBoundsRect.Left,OldBoundsRect.Top,
                      RectWidth(OldBoundsRect),
                      RectHeight(OldBoundsRect));
      OldBoundsRect := NullRect;
      MouseTimer.Enabled := True;
    end;
  if (FStatusBar <> nil) and (FStatusBar.SizeGrip)
  then
    begin
      FStatusBar.ShowGrip := True;
    end;
  if Assigned(FOnRestore) then FOnRestore(Self);   
end;

procedure TspDynamicSkinForm.LinkMenu;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinButtonObject)
  then
    with TspSkinButtonObject(ObjectList.Items[i]) do
    begin
      MenuItem := AMenu.Items;
      FPopupUp := APopupUp;
    end
  else
  if (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject)
  then
    with TspSkinAnimateObject(ObjectList.Items[i]) do
      if ButtonStyle
      then
        begin
          MenuItem := AMenu.Items;
          FPopupUp := APopupUp;
        end;  
end;

procedure TspDynamicSkinForm.CheckSize;
var
  CS: Boolean;
begin
  CS := CanScale;
  if not CS
  then
    begin
      if FForm.ClientWidth <> FSD.FPicture.Width
      then FForm.ClientWidth := FSD.FPicture.Width;
      if FForm.ClientHeight <> FSD.FPicture.Height
      then FForm.ClientHeight := FSD.FPicture.Height;
      FSizeAble := False;
    end
  else
    if (FMinWidth = 0) or (FMinHeight = 0)
    then
      begin
        if FForm.ClientWidth < FSD.FPicture.Width
        then
          FForm.ClientWidth := FSD.FPicture.Width;
          if FForm.ClientHeight < FSD.FPicture.Height
          then
            FForm.ClientHeight := FSD.FPicture.Height;
      end;
end;

procedure TspDynamicSkinForm.UpDateForm;
begin
  with FForm do
  begin
    if Width - 1 >= GetMinWidth
    then
      begin
        Width := Width - 1;
        Width := Width + 1;
      end
    else
      begin
        Width := Width + 1;
        Width := Width - 1;
      end;
  end;
end;

procedure TspDynamicSkinForm.ChangeSkinData;
var
  CS: Boolean;
  NotRollUp: Boolean;
  w, h, t: Integer;
begin
  {$IFDEF VER200}
  if FUseRibbon then FSkinnableForm := False;
  {$ENDIF}
  OldActiveObject := -1;
  ActiveObject := -1;
  MouseCaptureObject := -1;
  OldActive := False;
  if (FSD = nil) or (FSD.Empty)
  then
    FSkinSupport := False
  else
    FSkinSupport := True;

  //
  if FLayerManager.IsVisible then FLayerManager.Hide;
  if FMenuLayerManager.IsVisible then FMenuLayerManager.Hide;
  if FBorderLayer.FVisible then FBorderLayer.Hide;

  if FSupportNCArea
  then
    begin
      if FSkinSupport and FSkinnableForm
      then
        begin
          LoadObjects;
          CheckObjects;
          //
          if not PreviewMode
          then
            FBorderLayer.InitFrame(FSD, FForm);
          //
        end
      else
        begin
          ClearObjects;
          FFormWidth := FForm.Width;
          FFormHeight := FForm.Height;
          CreateNewRegion(True);
        end;

     if not FSkinnableForm then LoadBorderIcons else
       if FForm.BorderIcons <> [] then FForm.BorderIcons := [];
     FInChangeSkinData := True;


     if (FForm.Width < GetMinWidth) and (FForm.Height < GetMinHeight)
      then
        begin
          FForm.SetBounds(FForm.Left, FForm.Top,
                          GetMinWidth, GetMinHeight);
        end
      else
      if FForm.Height < GetMinHeight then FForm.Height := GetMinHeight else
      if FForm.Width < GetMinWidth then FForm.Width := GetMinWidth else
      UpDateForm;

      if (FRollUpState or (FWindowState = wsMinimized)) and
         (FForm.Height <> GetMinHeight)
      then
        FForm.Height := GetMinHeight;

      if (FWindowState = wsMinimized) and (FForm.Width <> GetMinWidth)
      then
        FForm.Width := GetMinWidth;

      FFormWidth := FForm.Width;
      FFormHeight := FForm.Height;

      //
      if (FForm.FormStyle = fsMDIForm)
      then
        begin
          if FMDIVScrollBar <> nil then FMDIVScrollBar.SkinData := Self.SkinData;
          if FMDIHScrollBar <> nil then FMDIHScrollBar.SkinData := Self.SkinData;
        end;  
      //

      if FSkinSupport then CreateNewForm(True);

      if (FForm.FormStyle = fsMDIForm)
      then
        begin
          ReDrawWindow(FForm.ClientHandle, nil, 0, RDW_ERASE or RDW_INVALIDATE);
          ResizeMDIChilds;
        end
      else
        FForm.RePaint;

      if (FForm.FormStyle = fsMDIChild) and (WindowState = wsMaximized)
      then FormChangeActive(False)
      else FormChangeActive(True);

      MouseTimer.Enabled := True;
      if Assigned(FOnChangeSkinData) then FOnChangeSkinData(Self);
      FInChangeSkinData := False;
    end
  else
    if FSkinSupport
    then 
    begin
      CS := CanScale;
      NotRollUp := FRollUpState and FSD.FRollUpPicture.Empty;
      if NotRollUp
      then
        begin
          FRollUpState := False;
          RestoreRollUpForm;
        end;
      if not FRollUpState then CheckSize;
      LoadObjects;
      CheckObjects;
      //
      FBorderLayer.InitFrame(FSD, FForm);
      //
      if not NotRollUp and FRollUpState then CreateRollUpForm;
      FInChangeSkinData := True;
      if Assigned(FOnChangeSkinData) then FOnChangeSkinData(Self);
      if not FRollUpState then
      if CS or (not CS and (FForm.ClientWidth = FSD.FPicture.Width) and
        (FForm.ClientHeight = FSD.FPicture.Height))
      then CreateNewForm(CS);
      CalcAllRealObjectRect;
      LinkControlsToAreas;
      ControlsToAreas;
      FormChangeActive(True);
      FInChangeSkinData := False;
      MouseTimer.Enabled := True;
    end;

  if CanShowBorderLayer and FForm.Visible
  then
    begin
      FBorderLayer.ShowWithForm;
      FForm.Show;
      FBorderLayer.SetBoundsWithForm;
    end;

  CorrectFormBounds;

  if not (RollUpState) and FSupportNCArea
  then
    begin
      if (FClientWidth > 0)
      then FForm.ClientWidth := FClientWidth;
      if FClientHeight > 0
      then FForm.ClientHeight := FClientHeight;
    end;
end;


procedure TspDynamicSkinForm.SetSkinData(Value: TspSkinData);
begin
  FSD := Value;
  if (FSD <> nil) and not (FForm.FormStyle = fsMDIChild)
  then
    FSkinnableForm := FSD.SkinnableForm;
  if not (csDesigning in ComponentState) then ChangeSkinData;
  FSysTrayMenu.SkinData := Value;
end;

procedure TspDynamicSkinForm.SetMenusSkinData(Value: TspSkinData);
begin
  FMSD := Value;
end;

procedure TspDynamicSkinForm.LinkControlsToAreas;
var
  i: Integer;
  R: TRect;
begin
  with FForm do
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TspSkinControl
    then
      begin
        if TspSkinControl(Controls[i]).AreaName <> ''
        then
          begin
            LinkControlToArea(TspSkinControl(Controls[i]).AreaName, Controls[i]);
          end;
      end
    else
    if Controls[i] is TspGraphicSkinControl
    then
      begin
        if TspGraphicSkinControl(Controls[i]).AreaName <> ''
        then
          LinkControlToArea(TspGraphicSkinControl(Controls[i]).AreaName, Controls[i]);
      end;
end;

procedure TspDynamicSkinForm.Notification(AComponent: TComponent;
                                          Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD)
  then FSD := nil else
  if (Operation = opRemove) and (AComponent = FMSD)
  then FMSD := nil else
  if (Operation = opRemove) and (AComponent = FMainMenu)
  then FMainMenu := nil else
  if (Operation = opRemove) and (AComponent = FSystemMenu)
  then FSystemMenu := nil else
  if (Operation = opRemove) and (AComponent = FMainMenuBar)
  then FMainMenuBar := nil else
  if (Operation = opRemove) and (AComponent = FMDITabsBar)
  then FMDITabsBar := nil else
  if (Operation = opRemove) and (AComponent = FTrayIcon)
  then FTrayIcon := nil;
  if (Operation = opRemove) and (AComponent = FSkinHint)
  then FSkinHint := nil else
  if (Operation = opRemove) and (AComponent = FStatusBar)
  then FStatusBar := nil;
  if (Operation = opRemove) and (AComponent = FQuickImageList)
  then FQuickImageList := nil;
  if (Operation = opRemove) and (AComponent = FMenuButtonPopupMenu)
  then FMenuButtonPopupMenu := nil;
  if (Operation = opRemove) and (AComponent = FMenuButtonImageList)
  then FMenuButtonImageList := nil;
  if (Operation = opRemove) and (AComponent = FCaptionTabsImageList)
  then FCaptionTabsImageList := nil;
end;

procedure TspDynamicSkinForm.UpdateMainMenu;

function DeleteMainMenuItem: Boolean;
var
  i, j: Integer;
begin
  j := -1;
  for i := ObjectList.Count - 1 downto 0 do
   if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
   then
     begin
       j := i;
       Break;
     end;
  if j <> - 1
  then
    begin
      TspSkinMainMenuItem(ObjectList.Items[j]).Free;
      ObjectList.Delete(j);
      Result := True;
    end
  else
    Result := False;
end;

var
  R: TRect;
begin
  //delete old items
  repeat
  until not DeleteMainMenuItem;
  //create new menu
  CreateMainMenu;
  R := NewMainMenuRect;
  if ARedraw
  then
    if SupportNCArea
    then
      SendMessage(FForm.Handle, WM_NCPaint, 0, 0)
    else
      InvalidateRect(FForm.Handle, @R, True);
end;

procedure TspDynamicSkinForm.CreateMainMenu;
var
  i, j: Integer;
  MMIData: TspDataSkinMainMenuItem;
begin
  if FMainMenu = nil then Exit;
  j := FSD.GetIndex('MAINMENUITEM');
  if j <> -1
  then
    begin
      MMIData := TspDataSkinMainMenuItem(FSD.ObjectList.Items[j]);
      for i := 0 to FMainMenu.Items.Count - 1 do
        if FMainMenu.Items[i].Visible
        then
          begin
            ObjectList.Add(TspSkinMainMenuItem.Create(Self, MMIData));
            with TspSkinMainMenuItem(ObjectList.Items[ObjectList.Count - 1]) do
            begin
              IDName := FMainMenu.Items[i].Name;
              Enabled := FMainMenu.Items[i].Enabled;
              MenuItem := FMainMenu.Items[i];
            end;
         end;
    end;
end;

procedure TspDynamicSkinForm.LoadDefObjects;
var
  NotNullRect: TRect;
begin
  ClearObjects;
  NotNullRect := Rect(0, 0, 1, 1);

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmClose;
    IDName := 'closebutton';
  end;

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmMaximize;
    IDName := 'maxbutton';
  end;

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmMinimize;
    IDName := 'minbutton';
  end;

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmRollUp;
    IDName := 'rollupbutton';
  end;

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmSysMenu;
    IDName := 'sysmenubutton';
  end;

  ObjectList.Add(TspSkinStdButtonObject.Create(Self, nil));
  with TspSkinStdButtonObject(ObjectList.Items[ObjectList.Count - 1]) do
  begin
    SkinRectInAPicture := True;
    SkinRect := NotNullRect;
    ActiveSkinRect := NotNullRect;
    DownRect := NotNullRect;
    Command := cmMinimizeToTray;
    IDName := 'traybutton';
  end;

  CheckObjects;
end;
                                           
procedure TspDynamicSkinForm.LoadObjects;
var
  i: Integer;
  OL: TList;
begin
  ClearObjects;
  OL := FSD.ObjectList;
  for i := 0 to OL.Count - 1 do
  begin
    if (TspDataSkinObject(OL.Items[i]) is TspDataSkinMainMenuItem) or
       (TspDataSkinObject(OL.Items[i]) is TspDataSkinMenuItem) or
       (TspDataSkinObject(OL.Items[i]) is TspDataSkinMainMenuBarButton) or
       (TspDataSkinObject(OL.Items[i]) is TspDataSkinCaptionTab)
    then
      begin
      end
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinCaptionMenuButton
    then
      ObjectList.Add(TspSkinCaptionMenuButton.Create(Self, TspDataSkinCaptionMenuButton(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinGauge
    then
      ObjectList.Add(TspSkinGaugeObject.Create(Self, TspDataSkinGauge(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinStdButton
    then
      ObjectList.Add(TspSkinStdButtonObject.Create(Self, TspDataSkinStdButton(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinButton
    then ObjectList.Add(TspSkinButtonObject.Create(Self, TspDataSkinButton(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinCaption
    then ObjectList.Add(TspSkinCaptionObject.Create(Self, TspDataSkinCaption(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataUserObject
    then ObjectList.Add(TspUserObject.Create(Self, TspDataUserObject(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinSwitch
    then ObjectList.Add(TspSkinSwitchObject.Create(Self, TspDataSkinSwitch(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinTrackBar
    then ObjectList.Add(TspSkinTrackBarObject.Create(Self, TspDataSkinTrackBar(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinLabel
    then ObjectList.Add(TspSkinLabelObject.Create(Self, TspDataSkinLabel(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinAnimate
    then ObjectList.Add(TspSkinAnimateObject.Create(Self, TspDataSkinAnimate(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinBitLabel
    then ObjectList.Add(TspSkinBitLabelObject.Create(Self, TspDataSkinBitLabel(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinFrameRegulatorObject
    then ObjectList.Add(TspSkinFrameRegulatorObject.Create(Self,
      TspDataSkinFrameRegulatorObject(OL.Items[i])))
    else
    if TspDataSkinObject(OL.Items[i]) is TspDataSkinFrameGaugeObject
    then ObjectList.Add(TspSkinFrameGaugeObject.Create(Self,
      TspDataSkinFrameGaugeObject(OL.Items[i])));
  end;
  CreateMainMenu;
end;

procedure TspDynamicSkinForm.ClearObjects;
var
  i: Integer;
begin
  for i := 0 to ObjectList.Count - 1 do
    TspActiveSkinObject(ObjectList.Items[i]).Free;
  ObjectList.Clear;
  for i := 0 to AreaList.Count - 1 do
    FreeMem(PAreaInfo(AreaList.Items[i]), Sizeof(TAreaInfo));
  AreaList.Clear;
end;


procedure TspDynamicSkinForm.TestActive;
var
  i: Integer;
  B: Boolean;
  ObjHint: String;
  X1, Y1: Integer;
begin
  if (ObjectList.Count = 0) or (not GetFormActive and FSupportNCArea) or FSizeMove or FBorderLayerChangeSize
  then
    Exit;

  if FBorderLayer.FVisible and FBorderLayer.FData.FullBorder then Exit;

  if PreviewMode or ((FForm.FormStyle = fsMDIChild) and (WindowState = wsMaximized))
     or ((FForm.BorderStyle = bsNone) and SupportNCArea)
  then
    Exit;

  OldActiveObject := ActiveObject;
  i := -1;
  B := False;
  repeat
    Inc(i);
    with TspActiveSkinObject(ObjectList.Items[i]) do
    begin
      if CanObjectTest(RollUp) and Enabled and Visible
      then
        B := PtInRect(ObjectRect, Point(X, Y));
      if B
      then
        begin
          X1 := X - ObjectRect.Left;
          Y1 := Y - ObjectRect.Top;
          B := InActiveMask(X1, Y1);
        end;
    end;
  until B or (i = ObjectList.Count - 1);

  if B and InFrm
  then ActiveObject := i
  else ActiveObject := -1;

  if (MouseCaptureObject <> -1) and
     (ActiveObject <> MouseCaptureObject) and (ActiveObject <> -1)
  then
    ActiveObject := -1;

  if OldActiveObject >= ObjectList.Count then OldActiveObject := -1;
  if ActiveObject >= ObjectList.Count then ActiveObject := -1;

  if (OldActiveObject <> ActiveObject)
  then
    begin
      if OldActiveObject <> - 1
      then
        begin
          if TspActiveSkinObject(ObjectList.Items[OldActiveObject]).Enabled and
             TspActiveSkinObject(ObjectList.Items[OldActiveObject]).Visible
          then TspActiveSkinObject(ObjectList.Items[OldActiveObject]).MouseLeave;
          if FShowObjectHint and (FSkinHint <> nil) and
             TspActiveSkinObject(ObjectList.Items[OldActiveObject]).Enabled and
             (TspActiveSkinObject(ObjectList.Items[OldActiveObject]).Hint <> '') and
             TspActiveSkinObject(ObjectList.Items[OldActiveObject]).Visible
          then FSkinHint.HideHint;
        end;
      if ActiveObject <> -1
      then
        begin
          if TspActiveSkinObject(ObjectList.Items[ActiveObject]).Enabled and
             TspActiveSkinObject(ObjectList.Items[ActiveObject]).Visible
          then TspActiveSkinObject(ObjectList.Items[ActiveObject]).MouseEnter;
          // show object hint
          if GetFormActive and 
             FShowObjectHint and (FSkinHint <> nil) and
             TspActiveSkinObject(ObjectList.Items[ActiveObject]).Enabled and
             TspActiveSkinObject(ObjectList.Items[ActiveObject]).Visible
          then
            begin
              ObjHint := TspActiveSkinObject(ObjectList.Items[ActiveObject]).Hint;
              if ObjHint <> '' then FSkinHint.ActivateHint2(ObjHint);
            end;
          //
        end;
    end;

end;

procedure TspDynamicSkinForm.TestCursors;
var
  CurIndex: Integer;
begin
  CurIndex := 0;
  if ActiveObject = -1
  then
    begin
      if FSD.CursorIndex <> -1
      then
        CurIndex := FSD.StartCursorIndex + FSD.CursorIndex
    end
  else
    with TspActiveSkinObject(ObjectList.Items[ActiveObject]) do
    begin
      if CursorIndex <> -1
      then
        CurIndex := FSD.StartCursorIndex + CursorIndex
      else
        if FSD.CursorIndex <> -1
        then
          CurIndex := FSD.CursorIndex + FSD.StartCursorIndex;
    end;
  if FForm.Cursor <> CurIndex
  then
    FForm.Cursor := CurIndex;
end;

procedure TspDynamicSkinForm.TestMouse;
var
  P, P1: TPoint;
  B: Boolean;
  L, T: Integer;
begin
  if not FSkinSupport and not FSupportNCArea then Exit;
  if FSupportNCArea
  then
    begin
      GetCursorPos(P);
      if WindowFromPoint(P) <> FForm.Handle
      then
        begin
          MouseTimer.Enabled := False;
          TestActive(-1, -1, False);
          Exit;
        end;
      if not FSizeMove and not FBorderLayerChangeSize then
      begin
        PointToNCPoint(P);
        if not PtInRect(NewClRect, P)
        then
          TestActive(P.X, P.Y, True)
        else
          if ActiveObject <> -1 then TestActive(-1, -1, True);
      end
      else
        MouseTimer.Enabled := False;
    end
  else
    begin
      GetCursorPos(P1);
      P := FForm.ScreenToClient(P1);
      if not FIsDragging
      then
        begin
          B := InForm(P1);
          if not B
          then
            begin
              TestActive(-1, -1, False);
              MouseIn := False;
              MouseTimer.Enabled := False;
            end
          else
            TestActive(P.X, P.Y, B);
         end;
      if FUseSkinCursors then TestCursors;   
    end;
end;

procedure TspDynamicSkinForm.TestAnimate;
var
  i: Integer;
  StopAnimate: Boolean;
begin
  StopAnimate := True;
  for i := 0 to ObjectList.Count  - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinAnimateObject
    then
      begin
        with TspSkinAnimateObject(ObjectList.Items[i]) do
          if Active and not (FDown and not IsNullRect(DownSkinRect))
          then
            begin
              ChangeFrame;
              StopAnimate := False;
            end;
      end
   else
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
    then
      with TspSkinCaptionObject(ObjectList.Items[i]) do
      begin
        if EnableAnimation
        then
          if FIncTime >= AnimateInterval
          then
            begin
              if Active and (CurrentFrame <= FrameCount)
              then
                begin
                  Inc(CurrentFrame);
                  DrawSkinObject(TspActiveSkinObject(ObjectList.Items[i]));
                  StopAnimate := False;
                  FIncTime := AnimateTimerInterval;
               end
             else
               if not Active and (CurrentFrame > 0)
               then
                begin
                  Dec(CurrentFrame);
                   DrawSkinObject(TspActiveSkinObject(ObjectList.Items[i]));
                  StopAnimate := False;
                  FIncTime := AnimateTimerInterval;
                end;
            end
          else
            begin
              StopAnimate := False;
              Inc(FIncTime, AnimateTimerInterval);
            end;
      end;
  if StopAnimate
  then AnimateTimer.Enabled := False;
end;


procedure TspDynamicSkinForm.TestMorph;
var
  i: Integer;
  StopMorph: Boolean;
begin
  StopMorph := True;
  for i := 0 to ObjectList.Count  - 1 do
    with TspActiveSkinObject(ObjectList.Items[i]) do
    begin
      if EnableMorphing and CanMorphing
        then
          begin
            DoMorphing;
            StopMorph := False;
          end;
    end;
  if StopMorph then MorphTimer.Enabled := False;
end;

procedure TspDynamicSkinForm.PaintEvent;
begin
  if Assigned(FOnPaintEvent) then FOnPaintEvent(IDName, Canvas, ObjectRect);
end;

procedure TspDynamicSkinForm.MouseUpEvent;
begin
  if Assigned(FOnMouseUpEvent)
  then FOnMouseUpEvent(IDName, X, Y, ObjectRect, Button);
end;

procedure TspDynamicSkinForm.MouseDownEvent;
begin
  if Assigned(FOnMouseDownEvent)
  then FOnMouseDownEvent(IDName, X, Y, ObjectRect, Button);
end;

procedure TspDynamicSkinForm.MouseMoveEvent;
begin
  if Assigned(FOnMouseMoveEvent)
  then FOnMouseMoveEvent(IDName, X, Y, ObjectRect);
end;

procedure TspDynamicSkinForm.MouseEnterEvent;
begin
  if Assigned(FOnMouseEnterEvent) then FOnMouseEnterEvent(IDName);
end;

procedure TspDynamicSkinForm.MouseLeaveEvent;
begin
  if Assigned(FOnMouseLeaveEvent) then FOnMouseLeaveEvent(IDName);
end;

procedure TspDynamicSkinForm.StartDragg;
var
  P: TPoint;
begin
  FIsDragging := True;
  P := FForm.ClientToScreen(Point(X, Y));
  FOldX := P.X;
  FOldy := P.Y;
end;

procedure TspDynamicSkinForm.EndDragg;
begin
  FIsDragging := False;
end;

procedure TspDynamicSkinForm.MouseMove;
begin
  if FSupportNCArea
  then
    begin
      if MouseCaptureObject <> -1
      then TspActiveSkinObject(ObjectList.Items[MouseCaptureObject]).MouseMove(X, Y)
      else
      if ActiveObject <> -1
      then TspActiveSkinObject(ObjectList.Items[ActiveObject]).MouseMove(X, Y);
    end
  else
    begin
      if not FIsDragging
      then
        if MouseCaptureObject <> -1
        then TspActiveSkinObject(ObjectList.Items[MouseCaptureObject]).MouseMove(X, Y)
        else
        if ActiveObject <> -1
        then TspActiveSkinObject(ObjectList.Items[ActiveObject]).MouseMove(X, Y);
    end;
end;

procedure TspDynamicSkinForm.MouseDblClick;
begin
  if (ActiveObject <> - 1) then
  with TspActiveSkinObject(ObjectList.Items[ActiveObject]) do
  begin
    DblClick;
  end;
end;

procedure TspDynamicSkinForm.MouseDown;
begin
  if FSupportNCArea
  then
    begin
      TestActive(X, Y, True);
      if (ActiveObject <> - 1) then
      with TspActiveSkinObject(ObjectList.Items[ActiveObject]) do
      begin
        if not (TspActiveSkinObject(ObjectList.Items[ActiveObject]) is
          TspSkinCaptionObject)
        then SetCapture(FForm.Handle);
         MouseCaptureObject := ActiveObject;
         MouseDown(X, Y, Button);
       end
    end
  else
    begin
      FIsDragging := False;
      TestActive(X, Y, True);
      if (ActiveObject <> - 1)
      then
        with TspActiveSkinObject(ObjectList.Items[ActiveObject]) do
        begin
          MouseCaptureObject := ActiveObject;
          MouseDown(X, Y, Button);
        end
      else
       if (Button = mbLeft) and (FWindowState <> wsMaximized) and FDraggable
       then
        StartDragg(X, Y);
    end;
end;

procedure TspDynamicSkinForm.MouseUp;
begin
  if FSupportNCArea
  then
    begin
      if (MouseCaptureObject <> -1)
      then
        begin
          if not (TspActiveSkinObject(ObjectList.Items[MouseCaptureObject]) is
          TspSkinCaptionObject)
          then ReleaseCapture;
          TspActiveSkinObject(ObjectList.Items[MouseCaptureObject]).MouseUp(X, Y, Button);
          MouseCaptureObject := -1;
        end;
    end
  else
    begin
      EndDragg;
      if (MouseCaptureObject <> -1)
      then
        begin
          TspActiveSkinObject(ObjectList.Items[MouseCaptureObject]).MouseUp(X, Y, Button);
          MouseCaptureObject := -1;
        end;
    end;
end;

procedure TspDynamicSkinForm.CreateRealBitMap;
begin
  CreateSkinImage(FSD.LTPoint, FSD.RTPoint, FSD.LBPoint, FSD.RBPoint,
    FSD.ClRect, NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewClRect,
    DestB, SourceB, Rect(0, 0, SourceB.Width, SourceB.Height), FFormWidth,
    FFormHeight, True, FSD.LeftStretch,
    FSD.TopStretch, FSD.RightStretch,
    FSD.BottomStretch, FSD.StretchEffect, FSD.StretchType);
end;

function TspDynamicSkinForm.CalcRealObjectRect2(R: TRect; AUseAnchors, AAnchorLeft, AAnchorTop,
    AAnchorRight, AAnchorBottom: Boolean): TRect;
var
  LeftTop, LeftBottom, RightTop, RightBottom: TRect;
  OffsetX, OffsetY: Integer;
  R1: TRect;
begin
  if not AUseAnchors
  then
    begin
      Result := CalcRealObjectRect(R);
      Exit;
    end;
  //
  LeftTop := Rect(0, 0, FSD.LTPoint.X, FSD.LTPoint.Y);
  LeftBottom := Rect(0, FSD.LBPoint.Y, FSD.LBPoint.X, FSD.FPicture.Height);
  RightTop := Rect(FSD.RTPoint.X, 0, FSD.FPicture.Width, FSD.RTPoint.Y);
  RightBottom := Rect(FSD.RBPoint.X, FSD.RBPoint.Y, FSD.FPicture.Width, FSD.FPicture.Height);
  OffsetX := NewRBPoint.X - FSD.RBPoint.X;
  OffsetY := NewRBPoint.Y - FSD.RBPoint.Y;
  //
  R1 := R;
  //
  if AAnchorBottom
  then
    begin
      if AAnchorTop then Inc(R1.Bottom, OffsetY) else OffsetRect(R1, 0, OffsetY);
    end;
  if AAnchorRight
  then
    begin
      if AAnchorLeft then Inc(R1.Right, OffsetX) else OffsetRect(R1, OffsetX, 0);
    end;
  Result := R1;  
end;

function TspDynamicSkinForm.CalcRealObjectRect;
var
  NewR: TRect;
  LeftTop, LeftBottom, RightTop, RightBottom: TRect;
  OffsetX, OffsetY: Integer;

function CorrectResizeRect: TRect;
var
  NR: TRect;
begin
  NR := R;
  if PtInRect(LeftTop, R.TopLeft) and
     PtInRect(RightBottom, R.BottomRight)
  then
    begin
      Inc(NR.Right, OffsetX);
      Inc(NR.Bottom, OffsetY);
    end
  else
  if PtInRect(LeftTop, R.TopLeft) and
     PtInRect(RightTop, R.BottomRight)
  then
    Inc(NR.Right, OffsetX)
  else
    if PtInRect(LeftBottom, R.TopLeft) and
       PtInRect(RightBottom, R.BottomRight)
    then
      begin
        Inc(NR.Right, OffsetX);
        OffsetRect(NR, 0, OffsetY);
      end
    else
      if PtInRect(LeftTop, R.TopLeft) and
         PtInRect(LeftBottom, R.BottomRight)
      then
        Inc(NR.Bottom, OffsetY)
      else
        if PtInRect(RightTop, R.TopLeft) and
           PtInRect(RightBottom, R.BottomRight)
        then
          begin
            OffsetRect(NR, OffsetX, 0);
            Inc(NR.Bottom, OffsetY);
          end;
  Result := NR;
end;

begin
  LeftTop := Rect(0, 0, FSD.LTPoint.X, FSD.LTPoint.Y);
  LeftBottom := Rect(0, FSD.LBPoint.Y, FSD.LBPoint.X, FSD.FPicture.Height);
  RightTop := Rect(FSD.RTPoint.X, 0, FSD.FPicture.Width, FSD.RTPoint.Y);
  RightBottom := Rect(FSD.RBPoint.X, FSD.RBPoint.Y, FSD.FPicture.Width, FSD.FPicture.Height);
  OffsetX := NewRBPoint.X - FSD.RBPoint.X;
  OffsetY := NewRBPoint.Y - FSD.RBPoint.Y;
  NewR := R;
  if IsNullRect(LeftTop) and IsNullRect(LeftBottom) and
     IsNullRect(RightTop) and IsNullRect(RightBottom)
  then
    begin
      Result := NewR;
      Exit;
    end;  
  if RectInRect(R, LeftTop)
  then NewR := R
  else
    if RectInRect(R, RightTop)
    then OffsetRect(NewR, OffsetX, 0)
    else
      if RectInRect(R, LeftBottom)
      then OffsetRect(NewR, 0, OffsetY)
      else
        if RectInRect(R, RightBottom)
        then
          OffsetRect(NewR,  OffsetX, OffsetY)
        else
          NewR := CorrectResizeRect;
  Result := NewR;
end;

function TspDynamicSkinForm.GetCaptionMenuButton: TspSkinCaptionMenuButton;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinCaptionMenuButton
    then
      begin
        Result := TspSkinCaptionMenuButton(ObjectList.Items[I]);
        Break;
      end;
end;

procedure TspDynamicSkinForm.CalcAllRealObjectRect;
var
  i: Integer;
  OffsetX, OffsetY, BW, BH: Integer;
  Button: TspActiveSkinObject;
  MenuButton: TspSkinCaptionMenuButton;
  C: TspSkinCaptionObject;

function GetCaption: TspSkinCaptionObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinCaptionObject
    then
      begin
        Result := TspSkinCaptionObject(ObjectList.Items[I]);
        Break;
      end;
end;

function GetStdButton(C: TStdCommand): TspActiveSkinObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinStdButtonObject
    then
      begin
        with TspSkinStdButtonObject(ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = C)
          then
            begin
              Result := TspActiveSkinObject(ObjectList.Items[I]);
              Break;
            end;
      end
    else
      if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinAnimateObject
      then
        begin
          with TspSkinAnimateObject(ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = C)
          then
            begin
              Result := TspActiveSkinObject(ObjectList.Items[I]);
              Break;
            end;
        end;
end;

procedure SetStdButtonRect(B: TspActiveSkinObject);
begin
  if (B <> nil) and (B is TspSkinStdButtonObject)
  then
    begin
      with TspSkinStdButtonObject(B) do
      begin
        if (Command = cmSysMenu) and Parent.ShowIcon and SkinRectInAPicture
        then
          GetIconSize(BW, BH)
        else
          begin
            BW := RectWidth(SkinRect);
            BH := RectHeight(SkinRect);
          end;
        ObjectRect := Rect(OffsetX - BW, OffsetY, OffsetX, OffsetY + BH);
        OffsetX := OffsetX - NewButtonsOffset - BW;
      end;
    end
  else
  if (B <> nil) and (B is TspSkinAnimateObject)
  then
    begin
      with TspSkinAnimateObject(B) do
      begin
        BW := RectWidth(SkinRect);
        BH := RectHeight(SkinRect);
        ObjectRect := Rect(OffsetX - BW, OffsetY, OffsetX, OffsetY + BH);
        OffsetX := OffsetX - NewButtonsOffset - BW;
      end;
    end
end;

procedure SetStdButtonRect2(B: TspActiveSkinObject);
begin
  if (B <> nil) and (B is TspSkinStdButtonObject)
  then
    begin
      with TspSkinStdButtonObject(B) do
      begin
        if (Command = cmSysMenu) and Parent.ShowIcon and SkinRectInAPicture
        then
          GetIconSize(BW, BH)
        else
          begin
            BW := RectWidth(SkinRect);
            BH := RectHeight(SkinRect);
          end;
        ObjectRect := Rect(OffsetX, OffsetY, OffsetX + BW, OffsetY + BH);
        OffsetX := OffsetX + NewButtonsOffset + BW;
      end;
    end
  else
  if (B <> nil) and (B is TspSkinAnimateObject)
  then
    begin
      with TspSkinAnimateObject(B) do
      begin
        BW := RectWidth(SkinRect);
        BH := RectHeight(SkinRect);
        ObjectRect := Rect(OffsetX, OffsetY, OffsetX + BW, OffsetY + BH);
        OffsetX := OffsetX + NewButtonsOffset + BW;
      end;
    end
end;

procedure SetStdObjectsRect;
var
  I: Integer;
begin
  Button := GetStdButton(cmClose);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMaximize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmRollUp);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimizeToTray);
  SetStdButtonRect(Button);
  // custom buttons
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinStdButtonObject
    then
      begin
        with TspSkinStdButtonObject(ObjectList.Items[I]) do
        if Visible and SkinRectInAPicture and (Command = cmDefault)
        then
          begin
            Button := TspActiveSkinObject(ObjectList.Items[I]);
            SetStdButtonRect(Button);
          end;
      end
   else
     if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinAnimateObject
     then
       begin
          with TspSkinAnimateObject(ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = cmDefault)
          then
            begin
              Button := TspActiveSkinObject(ObjectList.Items[I]);
              SetStdButtonRect(Button);
            end;
        end;
  //
  C := GetCaption;
  if IsNullRect(NewButtonsRect) and (C <> nil)
  then
    C.ObjectRect.Right := OffsetX + NewButtonsOffset;
  OffsetX := NewCaptionRect.Left;
  Button := GetStdButton(cmSysMenu);
  if Button <> nil
  then
    begin
      OffsetY := NewCaptionRect.Top;
      SetStdButtonRect2(Button);
      Button.ObjectRect.Top := OffsetY + RectHeight(NewCaptionRect) div 2  -
      BH div 2;
      Button.ObjectRect.Bottom := Button.ObjectRect.Top + BH;
      if C <> nil
      then
        C.ObjectRect.Left := OffsetX - NewButtonsOffset;
    end;
  MenuButton := GetCaptionMenuButton;
  if (MenuButton <> nil) and (C <> nil)
  then
    with MenuButton do
    begin
      Visible := Parent.FMenuButtonVisible;
      ObjectRect := Rect(C.ObjectRect.Left + 5, TopPosition,
        C.ObjectRect.Left + Parent.MenuButtonWidth + 5, TopPosition + RectHeight(SkinRect));
      if Visible and (C <> nil)
      then
        C.ObjectRect.Left := ObjectRect.Right + 5;
    end;
end;

procedure SetStdObjectsRect2;
var
  I: Integer;
begin
  Button := GetStdButton(cmClose);
  SetStdButtonRect2(Button);
  Button := GetStdButton(cmMaximize);
  SetStdButtonRect2(Button);
  Button := GetStdButton(cmMinimize);
  SetStdButtonRect2(Button);
  Button := GetStdButton(cmRollUp);
  SetStdButtonRect2(Button);
  Button := GetStdButton(cmMinimizeToTray);
  SetStdButtonRect2(Button);
  // custom buttons
  for I := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinStdButtonObject
    then
      begin
        with TspSkinStdButtonObject(ObjectList.Items[I]) do
        if Visible and SkinRectInAPicture and (Command = cmDefault)
        then
          begin
            Button := TspActiveSkinObject(ObjectList.Items[I]);
            SetStdButtonRect2(Button);
          end;
      end
   else
     if TspActiveSkinObject(ObjectList.Items[I]) is TspSkinAnimateObject
     then
       begin
          with TspSkinAnimateObject(ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = cmDefault)
          then
            begin
              Button := TspActiveSkinObject(ObjectList.Items[I]);
              SetStdButtonRect2(Button);
            end;
        end;
  //
  if IsNullRect(NewButtonsRect) and NewButtonsInLeft
  then
    begin
      Button := GetStdButton(cmSysmenu);
      SetStdButtonRect2(Button);
    end;
  C := GetCaption;
  if IsNullRect(NewButtonsRect) and (C <> nil)
  then C.ObjectRect.Left := OffsetX + NewButtonsOffset;

  if not NewButtonsInLeft and not IsNullRect(NewCaptionRect)
  then
    begin
      OffsetY := NewCaptionRect.Top;
      OffsetX := NewCaptionRect.Left;
      Button := GetStdButton(cmSysMenu);
      if Button <> nil
      then
        begin
          SetStdButtonRect2(Button);
          Button.ObjectRect.Top := OffsetY + RectHeight(NewCaptionRect) div 2  -
            BH div 2;
          Button.ObjectRect.Bottom := Button.ObjectRect.Top + BH;
          if C <> nil
          then
            C.ObjectRect.Left := OffsetX - NewButtonsOffset;
        end;
    end;
  MenuButton := GetCaptionMenuButton;
  if (MenuButton <> nil) and (C <> nil)
  then
    with MenuButton do
    begin
      Visible := Parent.FMenuButtonVisible;
      ObjectRect := Rect(C.ObjectRect.Left + 5, TopPosition,
        C.ObjectRect.Left + Parent.MenuButtonWidth + 5, TopPosition + RectHeight(SkinRect));
      if Visible and (C <> nil)
      then
        C.ObjectRect.Left := ObjectRect.Right + 5;
    end;
end;

begin
  if CanShowBorderLayer and (FBorderLayer.FData <> nil) and
     FBorderLayer.FData.FullBorder
  then
    Exit;

  for i := 0 to ObjectList.Count - 1 do
    with TspActiveSkinObject(ObjectList.Items[i]) do
      ObjectRect := CalcRealObjectRect(SkinRect);
  //
  if (FSD <> nil) and not FSD.Empty and not IsNullRect(FSD.SizeGripArea)
  then
    FSizeGripArea := CalcRealObjectRect(FSD.SizeGripArea)
  else
    FSizeGripArea := NullRect;
  // caption buttons rects
  if FSupportNCArea then
  if IsNullRect(NewButtonsRect) and not IsNullRect(NewCaptionRect)
  then
    begin
      OffsetY := NewCaptionRect.Top;
      if not NewButtonsInLeft
      then
        begin
          OffsetX := NewCaptionRect.Right;
          SetStdObjectsRect;
        end
      else
        begin
          OffsetX := NewCaptionRect.Left;
          SetStdObjectsRect2;
        end;
    end
  else
  if not IsNullRect(NewButtonsRect)
  then
    begin
      OffsetY := NewButtonsRect.Top;
      if not NewButtonsInLeft
      then
        begin
          OffsetX := NewButtonsRect.Right;
          SetStdObjectsRect;
        end
      else
        begin
          OffsetX := NewButtonsRect.Left;
          SetStdObjectsRect2;
        end;
    end;
  //
end;

procedure TspDynamicSkinForm.PaintBG2(DC: HDC);
var
  C: TCanvas;
  X, Y, XCnt, YCnt: Integer;
  B, Buffer2: TBitMap;
begin
  if DC = 0 then Exit;
  if (FSD = nil) or FSD.Empty then Exit;
  C := TCanvas.Create;
  C.Handle := DC;
  B := TBitMap(FSD.FActivePictures.Items[FSD.BGPictureIndex]);
  if FSD.StretchEffect and (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      case FSD.StretchType of
        spstFull:
          begin
            C.StretchDraw(Rect(0, 0, FForm.ClientWidth, FForm.ClientHeight), B);
          end;
        spstVert:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := FFormWidth;
            Buffer2.Height := B.Height;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), B);
            YCnt := FFormHeight div Buffer2.Height;
            for Y := 0 to YCnt do
              C.Draw(0, Y * Buffer2.Height, Buffer2);
            Buffer2.Free;
          end;
        spstHorz:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := B.Width;
            Buffer2.Height := FFormHeight;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), B);
            XCnt := FFormWidth div Buffer2.Width;
            for X := 0 to XCnt do
              C.Draw(X * Buffer2.Width, 0, Buffer2);
            Buffer2.Free;
          end;
      end;
    end
  else
  if (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      XCnt := FForm.ClientWidth div B.Width;
      YCnt := FForm.ClientHeight div B.Height;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        C.Draw(X * B.Width, Y * B.Height, B);
    end;
  if not FLogoBitMap.Empty then DrawLogoBitMap(C);
  C.Free;
end;


procedure TspDynamicSkinForm.PaintBG3(DC: HDC);
var
  C: TCanvas;
  X, Y, XCnt, YCnt: Integer;
  B, Buffer2: TBitMap;
begin
  if DC = 0 then Exit;
  if (FSD = nil) or FSD.Empty then Exit;
  C := TCanvas.Create;
  C.Handle := DC;
  B := TBitMap(FSD.FActivePictures.Items[FSD.MDIBGPictureIndex]);

  if FSD.MDIBGStretchEffect and
    (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      case FSD.MDIBGStretchType of
        spstFull:
          begin
            C.StretchDraw(Rect(0, 0, FForm.ClientWidth, FForm.ClientHeight), B);
          end;
        spstVert:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := FFormWidth;
            Buffer2.Height := B.Height;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), B);
            YCnt := FFormHeight div Buffer2.Height;
            for Y := 0 to YCnt do
              C.Draw(0, Y * Buffer2.Height, Buffer2);
            Buffer2.Free;
          end;
        spstHorz:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := B.Width;
            Buffer2.Height := FFormHeight;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), B);
            XCnt := FFormWidth div Buffer2.Width;
            for X := 0 to XCnt do
              C.Draw(X * Buffer2.Width, 0, Buffer2);
            Buffer2.Free;
          end;
      end;
    end
  else
  if (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      XCnt := FForm.ClientWidth div B.Width;
      YCnt := FForm.ClientHeight div B.Height;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        C.Draw(X * B.Width, Y * B.Height, B);
    end;
  if not FLogoBitMap.Empty then DrawLogoBitMap(C);
  C.Free;
end;

procedure TspDynamicSkinForm.PaintBG(DC: HDC);
var
  C: TCanvas;
  X, Y, XCnt, YCnt, w, h, rw, rh: Integer;
  R: TRect;
  BGImage, Buffer2: TBitMap;
begin
  if DC = 0 then Exit;
  if (FSD = nil) or FSD.Empty then Exit;
  C := TCanvas.Create;
  C.Handle := DC;
  if IsNullRect(FSD.ClRect)
  then
    begin
      with C do
      begin
        Brush.Color := clBtnFace;
        R := FForm.ClientRect;
        FillRect(R);
      end;
      C.Free;
      Exit;
    end;

  BGImage := TBitMap.Create;
  BGImage.Width := RectWidth(FSD.ClRect);
  BGImage.Height := RectHeight(FSD.ClRect);
  BGImage.Canvas.CopyRect(Rect(0, 0, BGImage.Width, BGImage.Height),
    FSD.FPicture.Canvas, Rect(FSD.ClRect.Left, FSD.ClRect.Top,
                              FSD.ClRect.Right, FSD.ClRect.Bottom));

  if FSD.StretchEffect and (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      case FSD.StretchType of
        spstFull:
          begin
            C.StretchDraw(Rect(0, 0, FForm.ClientWidth, FForm.ClientHeight), BGImage);
          end;
        spstVert:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := FFormWidth;
            Buffer2.Height := BGImage.Height;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
            YCnt := FFormHeight div Buffer2.Height;
            for Y := 0 to YCnt do
              C.Draw(0, Y * Buffer2.Height, Buffer2);
            Buffer2.Free;
          end;
        spstHorz:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := BGImage.Width;
            Buffer2.Height := FFormHeight;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
            XCnt := FFormWidth div Buffer2.Width;
            for X := 0 to XCnt do
              C.Draw(X * Buffer2.Width, 0, Buffer2);
            Buffer2.Free;
          end;
      end;
    end
  else  
  if (FForm.ClientWidth > 0) and (FForm.ClientHeight > 0)
  then
    begin
      w := RectWidth(FSD.ClRect);
      h := RectHeight(FSD.ClRect);
      rw := FForm.ClientWidth;
      rh := FForm.ClientHeight;
      XCnt := rw div w;
      YCnt := rh div h;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        C.Draw(X * w, Y * h, BGImage);
    end;


  BGImage.Free;
  if not FLogoBitMap.Empty then DrawLogoBitMap(C);
  C.Free;
end;


procedure TspDynamicSkinForm.Paint;

procedure PaintSizeGrip(Cnvs: TCanvas);
var
  CIndex: Integer;
  Picture: TBitMap;
  GripperBuffer: TBitMap;
begin
  if FSD.StatusBarName = '' then Exit;
  CIndex := FSD.GetControlIndex(FSD.StatusBarName);
  if CIndex = -1 then Exit;
  with TspDataSkinPanelControl(FSD.CtrlList[CIndex]) do
  begin
    if IsNullRect(GripperRect)
    then
      Exit
    else
    if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
    then
      Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
    else
      Exit;
    GripperBuffer := TBitMap.Create;
    GripperBuffer.Width := RectWidth(GripperRect);
    GripperBuffer.Height := RectHeight(GripperRect);
    GripperBuffer.Canvas.CopyRect(
      Rect(0, 0, GripperBuffer.Width, GripperBuffer.Height),
      Picture.Canvas, GripperRect);
    if GripperTransparent
    then
      begin
        GripperBuffer.Transparent := True;
        GripperBuffer.TransparentMode := tmFixed;
        GripperBuffer.TransparentColor := GripperTransparentColor;
      end;
    Cnvs.Draw(FSizeGripArea.Left, FSizeGripArea.Top, GripperBuffer);
    GripperBuffer.Free;
  end;
end;

var
  i: Integer;
  Canvas: TCanvas;
  R: TRect;
  PW, PH: Integer;
  RealPicture: TBitMap;
begin
  if FFormWidth = 0 then FFormWidth := FForm.Width;
  if FFormheight = 0 then FFormHeight := FForm.Height;
  Canvas := TCanvas.Create;
  Canvas.Handle := DC;
  RealPicture := TBitMap.Create;
  if (FSD = nil) or (FSD.Empty)
  then
    begin
      R := FForm.ClientRect;
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        Pen.Color := clBlack;
        Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      end;
      RealPicture.Free;
      Canvas.Free;
      Exit;
    end;

    with Canvas do
    begin
      if FRollUpState and not FSD.FRollUpPicture.Empty
      then
        begin
          with FSD do
          begin
            PW := FRollUpPicture.Width;
            PH := FRollUpPicture.Height;
            if RollUpRightPoint.X > RollUpLeftPoint.X
            then
              begin
                CreateHSkinImage(
                  RollUpLeftPoint.X, PW - RollUpRightPoint.X,
                  RealPicture, FRollUpPicture,
                  Rect(0, 0, PW, PH), FForm.Width, PH, False);
               end
            else
              begin
                RealPicture.Width := PW;
                RealPicture.Height := PH;
                RealPicture.Canvas.Draw(0, 0, FSD.FRollUpPicture);
              end;
          end;
        end
      else
      if (FSD.LTPoint.X = 0) and (FSD.LTPoint.Y = 0)
           and
         (FSD.RBPoint.X = 0) and (FSD.RBPoint.Y = 0)
      then
        begin
          RealPicture.Width := FSD.FPicture.Width;
          RealPicture.Height := FSD.FPicture.Height;
          RealPicture.Canvas.Draw(0, 0, FSD.FPicture);
        end
      else
        begin
          CreateRealBitMap(RealPicture, FSD.FPicture);
        end;

      for i := 0 to ObjectList.Count - 1 do
      with TspActiveSkinObject(ObjectList.Items[i]) do
      begin
        if ((not RollUp and not FRollUpState) or (RollUp and FRollUpState))  and
           Visible
        then
          Draw(RealPicture.Canvas, False);
      end;
      // size grip
      if WindowState = wsNormal
      then
        PaintSizeGrip(RealPicture.Canvas);
      //
      Draw(0, 0, RealPicture);
    end;

  RealPicture.Free;
  Canvas.Handle := 0;
  Canvas.Free;
end;

function TspDynamicSkinForm.NewDefNCHitTest;
const
  Offset = 2;
var
  CR: TRect;
begin
  if (FWindowState = wsMaximized) or FRollUpState or not FSizeAble or
     (FWindowState = wsMinimized)
  then
    with FForm do
    begin
      CR := GetDefCaptionRect;
      if PtInRect(CR, P)
      then
        Result := HTCAPTION
      else
      if PtInRect(Rect(3, GetDefCaptionHeight + 3, Width - 3, Height - 3), P)
      then
        Result := HTCLIENT
      else
        Result := HTNCACTIVE;
    end
  else
  if (ActiveObject <> -1)
  then
    begin
      Result := HTNCACTIVE;
    end
  else
  with FForm do
  if (P.X <= Offset) and (P.Y <= Offset)
  then
    Result := HTTOPLEFT
  else
  if (P.X >= Width - Offset) and (P.Y <= Offset)
  then
     Result := HTTOPRIGHT
  else
  if (P.X <= Offset) and (P.Y >= Height - Offset)
  then
    Result := HTBOTTOMLEFT
  else
  if (P.X >= Width - Offset) and (P.Y >= Height - Offset)
  then
    Result := HTBOTTOMRIGHT
  else
  if (P.X <= Offset)
  then
    Result := HTLEFT
  else
  if (P.Y <= Offset)
  then
    Result := HTTOP
  else
  if (P.X >= Width - Offset)
  then
    Result := HTRIGHT
  else
  if (P.Y >= Height - Offset)
  then
    Result := HTBOTTOM
  else
    begin
      CR := GetDefCaptionRect;
      if PtInRect(CR, P)
      then
        Result := HTCAPTION
      else
      if PtInRect(Rect(3, GetDefCaptionHeight + 3, Width - 3, Height - 3), P)
      then
        Result := HTCLIENT
      else
        Result := HTNCACTIVE;
    end
end;

function TspDynamicSkinForm.NewNCHitTest(P: TPoint): Integer;
var
  LP, TP, RP, BP: TPoint;
  CR: TRect;
  BW: Integer;

function InCaption: Boolean;
var
  i, j: Integer;
  FActiveTab, FActiveQuickButton: Integer;
begin
  Result := False;
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
    then
      with TspSkinCaptionObject(ObjectList.Items[i]) do
       if CanObjectTest(RollUp) and PtInRect(ObjectRect, P)
       then
         begin
           if ((QuickButtons.Count <> 0) and (QuickImageList <> nil)) or
              (CaptionTabs.Count <> 0)
           then
             begin
               FActiveTab := -1;
               FActiveQuickButton := -1;

               if CaptionTabs.Count <> 0
               then
                 for j := 0 to CaptionTabs.Count - 1 do
                 begin
                   if CaptionTabs[j].Visible and PtInRect(CaptionTabs[j].ItemRect, P)
                   then
                     begin
                       FActiveTab := j;
                       Break;
                     end;
                 end;

               if (QuickButtons.Count <> 0) and (FActiveTab = -1)
               then
                 for j := 0 to QuickButtons.Count - 1 do
                 begin
                   if QuickButtons[j].Visible and PtInRect(QuickButtons[j].ItemRect, P)
                   then
                     begin
                       FActiveQuickButton := i;
                       Break;
                     end;
                 end;

               Result := not ((FActiveTab <> -1) or (FActiveQuickButton <> -1));
             end
           else
             Result := True;
           Break;
         end;
  if not FNCDraggable then Result := False;       
end;

function CanHit: Boolean;
begin
  if FSD.FMask.Empty
  then
    begin
      Result := not (PtInRect(CR, LP) and PtInRect(CR, TP) and
                     PtInRect(CR, RP) and PtInRect(CR, BP));
    end
  else
    Result := not PtInRect(NewMaskRectArea, P) and
              not (PtInMask(LP) and PtInMask(TP) and
                   PtInMask(RP) and PtInMask(BP));
end;

begin
  if FRollUpState or (WindowState = wsMinimized)
  then
    begin
      if InCaption
      then Result := HTCAPTION
      else Result := HTNCACTIVE;
    end
  else  
  if (ActiveObject <> -1) and not InCaption and not PtInRect(NewClRect, P) and
     not FSizeMove
  then
    begin
      Result := HTNCACTIVE;
    end
  else 
  if (WindowState = wsMaximized) or not FSizeAble
  then
    begin
      if PtInRect(NewClRect, P)
      then
        Result := HTCLIENT
      else
      if InCaption
      then Result := HTCAPTION
      else Result := HTNCACTIVE;
    end
  else
    begin
      BW := FSD.BorderW;
      LP := Point(P.X - BW, P.Y);
      TP := Point(P.X, P.Y - BW);
      RP := Point(P.X + BW, P.Y);
      BP := Point(P.X, P.Y + BW);
      CR := Rect(0, 0, FForm.Width, FForm.Height);
      if CanHit
      then
        begin
          if (P.X <= NewHitTestLtPoint.X) and (P.Y <= NewHitTestLtPoint.Y)
          then
            Result := HTTOPLEFT
          else
          if (P.X >= NewHitTestRTPoint.X) and (P.Y <= NewHitTestRTPoint.Y)
          then
            Result := HTTOPRIGHT
          else
          if (P.X <= NewHitTestLBPoint.X) and (P.Y >= NewHitTestLBPoint.Y)
          then
            Result := HTBOTTOMLEFT
          else
          if (P.X >= NewHitTestRBPoint.X) and (P.Y >= NewHitTestRBPoint.Y)
          then
            Result := HTBOTTOMRIGHT
          else
          if PtInRect(Rect(NewHitTestLTPoint.X, 0,
               NewHitTestRTPoint.X, NewClRect.Top), P)
          then
            Result := HTTOP
          else
          if PtInRect(Rect(NewHitTestLBPoint.X, NewClRect.Bottom,
               NewHitTestRBPoint.X, CR.Bottom), P)
          then
            Result := HTBOTTOM
          else
          if PtInRect(Rect(0, NewHitTestLTPoint.Y,
               NewCLRect.Left, NewHitTestLBPoint.Y), P)
          then
            Result := HTLEFT
          else
          if PtInRect(Rect(NewClRect.Right, NewHitTestRTPoint.Y,
               CR.Right, NewHitTestRBPoint.Y), P)
          then
            Result := HTRIGHT
          else
          if PtInRect(NewClRect, P)
          then
            Result := HTCLIENT
          else
            if InCaption
            then Result := HTCAPTION
            else Result := HTNCACTIVE;
        end
      else
        if PtInRect(NewClRect, P)
        then
          begin
            Result := HTCLIENT
          end  
        else
          if InCaption
          then Result := HTCAPTION
          else Result := HTNCACTIVE;
    end;
end;

function TspDynamicSkinForm.NewHitTest;
var
  LP, TP, RP, BP: TPoint;
  CR: TRect;
  BW: Integer;

function CanHit: Boolean;
begin
  if FSD.FMask.Empty
  then
    begin
      Result := not (PtInRect(CR, LP) and PtInRect(CR, TP) and
                     PtInRect(CR, RP) and PtInRect(CR, BP));
    end
  else
    Result := not PtInRect(NewMaskRectArea, P) and
              not (PtInMask(LP) and PtInMask(TP) and
                   PtInMask(RP) and PtInMask(BP));
end;

begin
  if (not FSizeable or ((WindowState = wsMaximized) or FRollUpState)) or (ActiveObject <> -1)
  then
    begin
      Result := HTCLIENT;
      Exit;
    end
  else
    if (FSD <> nil) and not FSD.Empty
    then 
    begin
      BW := FSD.BorderW;
      LP := Point(P.X - BW, P.Y);
      TP := Point(P.X, P.Y - BW);
      RP := Point(P.X + BW, P.Y);
      BP := Point(P.X, P.Y + BW);
      CR := Rect(0, 0, FForm.Width, FForm.Height);
      if not IsNullRect(FSizeGripArea) and PtInRect(FSizeGripArea, P)
      then
        begin
          Result := HTBOTTOMRIGHT
        end
      else
      if CanHit
      then
        begin
          if (P.X <= NewHitTestLtPoint.X) and (P.Y <= NewHitTestLtPoint.Y)
          then
            Result := HTTOPLEFT
          else
          if (P.X >= NewHitTestRTPoint.X) and (P.Y <= NewHitTestRTPoint.Y)
          then
            Result := HTTOPRIGHT
          else
          if (P.X <= NewHitTestLBPoint.X) and (P.Y >= NewHitTestLBPoint.Y)
          then
            Result := HTBOTTOMLEFT
          else
          if (P.X >= NewHitTestRBPoint.X) and (P.Y >= NewHitTestRBPoint.Y)
          then
            Result := HTBOTTOMRIGHT
          else
          if PtInRect(Rect(NewHitTestLTPoint.X, 0,
               NewHitTestRTPoint.X, NewClRect.Top), P)
          then
            Result := HTTOP
          else
          if PtInRect(Rect(NewHitTestLBPoint.X, NewClRect.Bottom,
               NewHitTestRBPoint.X, CR.Bottom), P)
          then
            Result := HTBOTTOM
          else
          if PtInRect(Rect(0, NewHitTestLTPoint.Y,
               NewCLRect.Left, NewHitTestLBPoint.Y), P)
          then
            Result := HTLEFT
          else
          if PtInRect(Rect(NewClRect.Right, NewHitTestRTPoint.Y,
               CR.Right, NewHitTestRBPoint.Y), P)
          then
            Result := HTRIGHT
          else
            Result := HTCLIENT;
        end
      else
        Result := HTCLIENT;
    end
  else
    Result := HTCLIENT;
end;

function TspDynamicSkinForm.FindHotKeyItem;
var
  i: Integer;
begin
  Result := False;
  if FMainMenuBar <> nil
  then
    Result := FMainMenuBar.FindHotKeyItem(CharCode)
  else  
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible and
           IsAccel(CharCode, MenuItem.Caption)
        then
          begin
            MouseEnter;
            if (not InMenu) or (MenuItem.Count = 0) then MouseDown(0, 0, mbLeft);
            Result := True;
            Break;
          end;
      end
end;

function TspDynamicSkinForm.CanNextMainMenuItem;
var
  PW: TspSkinPopupWindow;
begin
  if SkinMenu.FPopupList.Count = 0
  then
    Result := True
  else
    with SkinMenu do
    begin
      PW := TspSkinPopupWindow(FPopupList.Items[FPopupList.Count - 1]);
      if PW.ActiveItem <> -1
      then
        begin
          if TspSkinMenuItem(PW.ItemList[PW.ActiveItem]).MenuItem.Count = 0
          then
            Result := True
          else
            Result := False;   
        end
      else
        Result := True
    end;
end;

function TspDynamicSkinForm.CanPriorMainMenuItem;
begin
  if SkinMenu.FPopupList.Count < 2 then Result := True else Result := False;
end;

procedure TspDynamicSkinForm.NextMainMenuItem;

function IsEndItem(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if Index + 1 > ObjectList.Count - 1
  then
    Result := True
  else
  for i := Index + 1 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible then Result := False;
      end
end;

var
  i, j: Integer;
  EndI: Boolean;
  FirstItem: Integer;
begin
  EndI := False;
  FirstItem := -1;
  j := -1;

  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible
        then
          begin
            if FirstItem = -1 then FirstItem := i;
            if (Active or FDown)
            then
              begin
                j := i;
                MouseLeave;
                EndI := IsEndItem(j);
                Break;
              end;
          end;
       end;   

  if j = -1
  then
    begin
      j := FirstItem;
      if j <> -1 then
        TspSkinMainMenuItem(ObjectList.Items[j]).MouseEnter;
    end
  else
    begin
      if EndI then j := 0 else j := j + 1;
      if j < ObjectList.Count then
      for i := j to ObjectList.Count - 1 do
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
      then
        with TspSkinMainMenuItem(ObjectList.Items[i]) do
        begin
          if Enabled and Visible
          then
            begin
              MouseEnter;
              Break;
            end;
        end;    
    end;
end;

procedure TspDynamicSkinForm.PriorMainMenuItem;

function IsEndItem(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if Index - 1 < 0
  then
    Result := True
  else
  for i := Index - 1 downto 0 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible then Result := False;
      end
end;

var
  i, j: Integer;
  EndI: Boolean;
  LastItem: Integer;
begin
  EndI := False;
  j := -1;
  LastItem := -1;

  for i := ObjectList.Count - 1 downto 0 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if Enabled and Visible
        then
          begin
            if LastItem = -1 then LastItem := i;
            if Active or FDown then
            begin
              j := i;
              MouseLeave;
              EndI := IsEndItem(j);
              Break;
            end;
          end;  
      end;  

  if j = -1
  then
    begin
      j := LastItem;
      if j <> -1 then
        TspSkinMainMenuItem(ObjectList.Items[j]).MouseEnter;
    end
  else
    begin
      if EndI then j := ObjectList.Count - 1 else j := j - 1;
      if j > -1 then
      for i := j downto 0 do
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
      then
       with TspSkinMainMenuItem(ObjectList.Items[i]) do
       begin
         if Enabled and Visible 
         then
           begin
             MouseEnter;
             Break;
           end;
       end;  
    end;
end;

function TspDynamicSkinForm.ActivateMenu: boolean;
var
  i: Integer;
  FirstItem: Integer;
begin
  FirstItem := -1;
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if FirstItem = -1 then FirstItem := i;
        if Active
        then
          begin
            FirstItem := i;
            Break;
          end;
      end;
  if FirstItem <> -1
  then
    begin
      TspSkinMainMenuItem(ObjectList.Items[FirstItem]).MouseEnter;
      InMainMenu := True;
      HookApp;
    end;
  Result := FirstItem <> -1;  
  if Assigned(FOnMainMenuEnter) then FOnMainMenuEnter(Self);      
end;

function TspDynamicSkinForm.CheckReturnKey;
var
  i: Integer;
begin
  Result := False;
  if FMainMenuBar <> nil
  then
    Result := FMainMenuBar.CheckReturnKey
  else  
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinMainMenuItem
    then
      with TspSkinMainMenuItem(ObjectList.Items[i]) do
      begin
        if (FDown and (MenuItem.Count = 0)) or
           (Active and not InMenu)
        then
          begin
            Active := False;
            MouseDown(0, 0, mbLeft);
            Result := True;
            Break;
         end;
      end;
end;

procedure TspDynamicSkinForm.FormClientWindowProcHook(var Message: TMessage);
var
  FOld, Canredraw: Boolean;
  R: TRect;
begin

  FOld := True;

  case Message.Msg of

    WM_NCACTIVATE:
      begin
        FOld := False;
        Message.Result := 1;
      end;

    WM_NCCALCSIZE:
      begin
        FOLd := False;
      end;

    WM_SIZE:
      begin
        Message.Result := CallWindowProc(FPrevClientProc, FForm.ClientHandle, Message.Msg,
                                 Message.wParam, Message.lParam);
        ResizeMDIChilds;
        R := Rect(0, 0, FForm.ClientWidth, FForm.ClientHeight);
        CanRedraw := not FLogoBitMap.Empty;

        if not CanRedraw and FSkinSupport and (FSD <> nil)
          and FSD.StretchEffect and (FSD.MDIBGPictureIndex = -1)
        then
          CanRedraw := True;

        if not CanRedraw and FSkinSupport and (FSD <> nil)
          and FSD.MDIBGStretchEffect and (FSD.MDIBGPictureIndex <> -1)
        then
          CanRedraw := True; 

        if CanRedraw
        then
          ReDrawWindow(FForm.ClientHandle, @R, 0, RDW_ERASE or RDW_INVALIDATE);

        FOld := False;

        GetMDIScrollInfo(True);
      end;

    WM_NCPAINT:
      begin
        FOld := False;
      end;

    WM_ERASEBKGND:
      begin
        FOld := False;
        if (FSD <> nil) and not FSD.Empty
        then
          begin
            if FSD.MDIBGPictureIndex <> -1
            then
              PaintBG3(TWMERASEBKGND(Message).DC)
            else  
            if FSD.BGPictureIndex = -1
            then
              PaintBG(TWMERASEBKGND(Message).DC)
            else
              PaintBG2(TWMERASEBKGND(Message).DC);
          end
        else
          PaintMDIBGDefault(TWMERASEBKGND(Message).DC);
      end;
  end;

  if FOld
  then
    with Message do
      Result := CallWindowProc(FPrevClientProc, FForm.ClientHandle, Msg,
                               wParam, lParam);

end;

procedure TspDynamicSkinForm.FormKeyDown(Message: TMessage);
var
  DSF: TspDynamicSkinForm;
begin
  if not Assigned(FForm) then Exit;
  
  if (FForm.FormStyle = fsMDIChild)
  then
    begin
      DSF := GetDynamicSkinFormComponent(Application.MainForm);
      if DSF <> nil
      then
        begin
          if DSF.InMenu or DSF.InMainMenu or DSF.SkinMenu.Visible
          then
            begin
              DSF.FormKeyDown(Message);
              Exit;
            end;
        end;
    end;
  if InMainMenu and FindHotKeyItem(TWMKeyDown(Message).CharCode)
  then
    begin
    end
  else
  if (TWMKeyDown(Message).CharCode = VK_ESCAPE) and
     (InMainMenu and not InMenu)
  then
    SkinMainMenuClose
  else
    if (TWMKeyDown(Message).CharCode = VK_LEFT) and InMainMenu and
       CanPriorMainMenuItem
    then
      begin
        if FMainMenuBar <> nil
        then FMainMenuBar.PriorMainMenuItem
        else PriorMainMenuItem;
      end
    else
      if (TWMKeyDown(Message).CharCode = VK_RIGHT) and InMainMenu and
           CanNextMainMenuItem
      then
        begin
          if FMainMenuBar <> nil
          then FMainMenuBar.NextMainMenuItem
          else NextMainMenuItem;
        end
      else
       if Assigned(SkinMenu.FPopupList) then
       if TWMKeyDown(Message).CharCode in [VK_RETURN, VK_DOWN]
       then
         begin
           if  not CheckReturnKey
           then
             with TWMKeyDown(Message), SkinMenu do
             begin
               if Visible and (FPopupList.Count > 0)
               then
                 TspSkinPopupWindow(FPopupList.Items[FPopupList.Count - 1]).PopupKeyDown(CharCode);
             end;
          end
        else
          with TWMKeyDown(Message), SkinMenu do
          begin
            if Visible and (FPopupList.Count > 0)
            then
              TspSkinPopupWindow(FPopupList.Items[FPopupList.Count - 1]).PopupKeyDown(CharCode);
            if (CharCode = VK_ESCAPE) and (FPopupList.Count = 0)
            then
              if InMainMenu
              then
                SkinMenuClose2
              else
                SkinMenuClose;
          end;
end;

procedure TspDynamicSkinForm.NewAppMessage;
var
  MsgNew: TMessage;
begin
  MsgNew.WParam := Msg.WParam;
  MsgNew.LParam := Msg.LParam;
  MsgNew.Msg := Msg.message;
  case Msg.message of
    WM_MOUSEWHEEL:
      begin
        Msg.message := 0;
        Handled := True;
      end;
    WM_KEYDOWN:
      begin
        FormKeyDown(MsgNew);
        Msg.message := 0;
        Handled := True;
      end;
  end;
end;

procedure TspDynamicSkinForm.CheckMenuVisible;
var
  DS: TspDynamicSkinForm;
begin
  if CanMenuClose(Msg)
  then
    begin
      // hide object hint
      if FShowObjectHint and (FSkinHint <> nil)
      then FSkinHint.HideHint;
      //
      if InMainMenu and not InMenu
      then
        SkinMainMenuClose
      else
      if (SkinMenu <> nil) and (SkinMenu.Visible or (InMenu))
      then
        begin
          if SkinMenu.Visible
          then SkinMenu.Hide
          else SkinMenuClose;
        end
      else
      if (FForm.FormStyle = fsMDIForm) and FForm.Visible
      then
        begin
          DS := GetMDIChildDynamicSkinFormComponent2;
          if DS <> nil then DS.CheckMenuVisible(Msg);
        end;
      CancelMessageToControls;
    end;
end;

procedure TspDynamicSkinForm.EnableShadow;
begin
  if not CheckW2KWXP then Exit;
  if FHaveShadow = AShowShadow then Exit;
  FHaveShadow := AShowShadow;
  if AHideFormBefore then FForm.Hide;
  if FHaveShadow
  then
    SetClassLong(FForm.Handle, GCL_STYLE,
                 GetClassLong(FForm.Handle, GCL_STYLE) or $20000)
  else
    SetClassLong(FForm.Handle, GCL_STYLE,
                 GetClassLong(FForm.Handle, GCL_STYLE) and not $20000);
  if AHideFormBefore then FForm.Show;
end;

procedure TspDynamicSkinForm.NewWndProc(var Message: TMessage);
const
  WM_SYNCPAINT = $0088;
var
  MM: PMINMAXINFO;
  Old: boolean;
  P: TPoint;
  CS: Boolean;
  Step, L, T, i, j: Integer;
  B: Boolean;
  R: PRect;
  R1: TRect;
  HT: Word;
  TickCount: DWord;
  IsChildMustMax: Integer;
  DSF: TspDynamicSkinForm;
begin

  CheckMenuVisible(Message.Msg);

  Old := True;
  with Message do
  begin
    case Msg of

      CM_STARTFORMANIMATION:
        begin
          FSmartEffectsShow := True;
        end;

      CM_STOPFORMANIMATION:
      if FSmartEffectsShow
      then
        begin
          FSmartEffectsShow := False;
          if ((FForm.Visible) or (FForm.Tag = -10000)) and CanShowBorderLayer
          then
            begin
              Application.ProcessMessages;
              FBorderLayer.FActive := True;
              FBorderLayer.ShowWithFormAnimation;
            end;
         end;


     CM_CANSTARTFORMANIMATION:
        begin
          if not FSkinnableForm and FIsVistaOS
          then
            Message.Result := SE_STOPANIMATION
          else
            Message.Result := SE_CANANIMATION;
          Old := False;
        end;
        

     CM_SENCPAINT:
      if FSkinnableForm then
          begin
            if (Message.WParam <> 0) and FSupportNCArea and
               (FForm.BorderStyle <> bsNone) and
                not ((FForm.FormStyle = fsMDICHILD) and (WindowState = wsMaximized))
             then
               if FSkinSupport
               then
                 PaintNCSkin(Message.WParam, True)
                else
                  if not FStopPainting
                  then
                    PaintNCDefault(Message.WParam, True);
                Message.Result := SE_RESULT;
              Old := False;
             end;


      CM_BENCPAINT:
      if FSkinnableForm then
          begin
            if Message.LParam = BE_ID
            then
              begin
                if (Message.WParam <> 0) and FSupportNCArea and
                   (FForm.BorderStyle <> bsNone) and
                   not ((FForm.FormStyle = fsMDICHILD) and (WindowState = wsMaximized))
                then
                  if FSkinSupport
                  then
                    PaintNCSkin(Message.WParam, True)
                  else
                    if not FStopPainting
                    then
                      PaintNCDefault(Message.WParam, True);
                  Message.Result := BE_ID;
                  Old := False;
               end;
          end;


      WM_SETCURSOR:
        if FSupportNCArea and UseFormCursorInNCArea
        then
        if FSkinnableForm then
        begin
          HT := TWMSetCursor(Message).HitTest;
          if TWMSetCursor(Message).HitTest <> HTCLIENT
          then
            if (TWMSetCursor(Message).HitTest = HTCAPTION) or
               ((TWMSetCursor(Message).HitTest <> HTTOP) and
                (TWMSetCursor(Message).HitTest <> HTBOTTOM) and
                (TWMSetCursor(Message).HitTest <> HTLEFT) and
                (TWMSetCursor(Message).HitTest <> HTRIGHT) and
                (TWMSetCursor(Message).HitTest <> HTTOPLEFT) and
                (TWMSetCursor(Message).HitTest <> HTTOPRIGHT) and
                (TWMSetCursor(Message).HitTest <> HTBOTTOMRIGHT) and
                (TWMSetCursor(Message).HitTest <> HTBOTTOMLEFT))
            then
              HT := HTCLIENT;
          TWMSetCursor(Message).HitTest := HT;
        end;

      WM_MOUSEACTIVATE:
      if FSkinnableForm then
        if (FForm.FormStyle = fsMDIChild)
        then
        begin
          if (Application.MainForm.ActiveMDIChild = FForm) and not FFormActive
           then
             begin
               FFormActive := True;
               if FWindowState = wsMaximized
               then FormChangeActive(False)
               else FormChangeActive(True);
             end;
        end;

      WM_SETTEXT:
      if FSkinnableForm then
        begin
          OldWindowProc(Message);
          if (FForm.BorderStyle <> bsNone) and
             not ((FForm.FormStyle = fsMDICHILD) and (WindowState = wsMaximized))
          then
            if FSkinSupport
            then
              begin
                if FSupportNCArea
                then
                  begin
                    UpDateFormNC;
                  end
                else
                  begin
                    SetDefaultCaptionText(FForm.Caption);
                  end;
              end
            else
              SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
            if FForm.FormStyle = fsMDIChild
            then
              begin
                UpDateChildCaptionInMenu(FForm);
                RefreshMDIBarTab(FForm);
                if WindowState = wsMaximized
                then
                begin
                  DSF := GetDynamicSkinFormComponent(Application.MainForm);
                  if DSF <> nil then DSF.UpDateFormNC;
                end;
              end;
          Old := False;
        end;

   WM_MDICHILDGETMAXSTATE:
      begin
        if (FForm.FormStyle = fsMDIForm) and FMDIChildMaximized
        then
          Message.Result := 1
        else
          Message.Result := 0;
        Old := False;  
      end;

    WM_MDICHILDMOVE:
     if (FForm.FormStyle = fsMDIForm) and not FStopCheckChildMove
      then
        begin
          ChangeVisibleChildHanle := Message.WParam;
          GetMDIScrollInfo(True);
          ChangeVisibleChildHanle := 0;
          Old := False;
        end;

    WM_MDICHILDMAX:
      if (FForm.FormStyle = fsMDIForm) and not FInMaximizeAll
      then
        begin
          FMDIChildMaximized := True;
          UpDateFormNC;
          if FMainMenuBar <> nil then FMainMenuBar.MDIChildMaximize;
          //
          FInMaximizeAll := True;
          MaximizeAll;
          FInMaximizeAll := False;
          Old := False;
        end;

    WM_MDICHILDMIN:
    if (FForm.FormStyle = fsMDIForm) and not FInRestoreAll and FMDIChildMaximized
    then
      begin
        FInRestoreAll := True;
        RestoreAllExcept(Message.WParam);
        FInRestoreAll := False;
        FMDIChildMaximized := False;
        FForm.Next;
        //
        UpDateFormNC;
        if FMainMenuBar <> nil then FMainMenuBar.MDIChildRestore;
        GetMDIScrollInfo(True);
        Old := False;
      end;

    WM_MDICHILDNORMALIZE:
      if (FForm.FormStyle = fsMDIForm) and not FInRestoreAll and FMDIChildMaximized
      then
        begin
          //
          FInRestoreAll := True;
          RestoreAll;
          FInRestoreAll := False;
          FMDIChildMaximized := False;
          //
          UpDateFormNC;
          if FMainMenuBar <> nil then FMainMenuBar.MDIChildRestore;
          GetMDIScrollInfo(True);
          Old := False;
        end;

    WM_MDICHILDRESTORE:
      if (FForm.FormStyle = fsMDIForm) and not FInRestoreAll
      then
        begin
          if GetMaximizeMDIChild = nil then FMDIChildMaximized := False;
          //
          UpDateFormNC;
          if FMainMenuBar <> nil then FMainMenuBar.MDIChildRestore;
          GetMDIScrollInfo(True);
          Old := False;
        end;

     WM_MDICHANGESIZE:
      if (FForm.FormStyle = fsMDICHILD) and (FWindowState = wsMaximized)
      then
        begin
          R1 := GetMDIWorkArea;
          FForm.SetBounds(0, 0, RectWidth(R1), RectHeight(R1));
        end;

      WM_SYSCOMMAND:
        begin
          if Message.WParam = SC_RESTORE
          then
            begin
              if Assigned(FOnRestore) then FOnRestore(Self);
              if FSupportNCArea
              then
                begin
                  {$IFDEF VER185}
                  if CanShowBorderLayer and Application.MainFormOnTaskBar
                  and (Application.MainForm = FForm)
                  then
                    begin
                      OldWindowProc(Message);
                      FBorderLayer.ShowWithForm;
                      Old := False;
                   end;
                 {$ENDIF}
                 {$IFDEF VER200}
                 if CanShowBorderLayer and Application.MainFormOnTaskBar
                   and (Application.MainForm = FForm)
                 then
                   begin
                     OldWindowProc(Message);
                     FBorderLayer.ShowWithForm;
                     Old := False;
                   end;
                 {$ENDIF}
                end;
            end
          else
          if Message.WParam = SC_KEYMENU
          then
            begin
              Old := False;
              if not InMainMenu then
              begin
                if SkinMenu.Visible
                then
                  begin
                    SkinMenuClose;
                  end;  
                if FMainMenuBar <> nil
                then FMainMenuBar.MenuEnter
                else
                  if not ActivateMenu
                  then Old := True;
              end
              else
              if InMainMenu
              then
                SkinMainMenuClose;
            end;
        end;

     WM_CLOSESKINMENU:
        begin
          SkinMenuClose;
        end;

     WM_TIMER:
     if (Message.WParam = 1) and CheckVista
     then
       begin
         KillTimer(FForm.Handle, 1);
         if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED <> 0
         then
           SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                         GetWindowLong(FForm.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
         if CanShowBorderLayer and (FForm.Visible or (FForm.Tag = -10000))
         then
           begin
             FBorderLayer.FActive := FForm.Active;
             FBorderLayer.CheckFormAlpha(255, True);
           end;
       end
     else
     if (Message.WParam = 1) and CheckW2KWXP and (FAlphaBlend or FAlphaBlendAnimation or
        ((FSD <> nil) and FSD.AnimationForAllWindows))
     then
       begin
         KillTimer(FForm.Handle, 1);
         
         if CanShowBorderLayer
         then
           begin
             FBorderLayer.FActive := FForm.Active;
           end;

         //
         if (FForm.ActiveControl <> nil) and (FForm.ActiveControl is TspSkinButton)
         then
           TspSkinButton(FForm.ActiveControl).FStopAnimate := True;
         //


         if (FAlphaBlendAnimation or ((FSD <> nil) and FSD.AnimationForAllWindows))
            and not FAlphaBlend
           then J := 255 else J := FAlphaBlendValue;
         if (FAlphaBlendAnimation or ((FSD <> nil) and FSD.AnimationForAllWindows))
         then
           begin
             TickCount := 0;
             I := 0;
             Step := J div 15;
             if Step = 0 then Step := 1;
             Application.ProcessMessages;
             repeat
               if (GetTickCount - TickCount > 5)
               then
                 begin
                   TickCount := GetTickCount;
                   Inc(i, Step);
                   if I > J then I := J;
                   SetAlphaBlendTransparent(FForm.Handle, i);
                   if CanShowBorderLayer
                   then
                     FBorderLayer.CheckFormAlpha(i, True);
                 end;
             until i >= J;
             if CanShowBorderLayer and not FBorderLayer.FData.FullBorder
             then
               FBorderLayer.SetBoundsWithForm;
           end
         else
           if J <> 255
           then
             begin
               SetAlphaBlendTransparent(FForm.Handle, FAlphaBlendValue);
               if CanShowBorderLayer
               then
                  begin
                    FBorderLayer.CheckFormAlpha(FAlphaBlendValue, True);
                    if not FBorderLayer.FData.FullBorder
                    then
                      FBorderLayer.SetBoundsWithForm;
                  end;    
             end;
         if J = 255
         then
           begin
             if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED <> 0
             then
               SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                            GetWindowLong(FForm.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
             if CanShowBorderLayer
             then
               FBorderLayer.CheckFormAlpha(255, True);
           end;
       end;
       

      WM_SHOWWINDOW:
       if FSkinnableForm then
       begin
         if Message.wParam > 0
         then
           begin
             //
             if (FForm = Application.MainForm) and (not Assigned(Application.OnRestore))
             then
               begin
                 Application.OnRestore := OnAppRestore;
               end;
             //
             if FStartShow and (FPositionInMonitor = sppDefault)
             then
               FStartShow := False
             else
             if FStartShow and (FWindowState = wsNormal)
             then
               begin
                 FStartShow := False;
                 ApplyPositionInMonitor;
               end;

             if ((FSD <> nil) and FSD.AnimationForAllWindows) and (FAlphaBlendValue = 0)
             then
               FAlphaBlendValue := 255;
             //
             if (CheckW2KWXP and (FAlphaBlend or FAlphaBlendAnimation or ((FSD <> nil) and FSD.AnimationForAllWindows))) or CheckVista
             then
               begin

                if FIsVistaOS and not DisableDWMAnimation
                then
                  begin
                    SetDWMAnimation(FForm.Handle, False);
                    DisableDWMAnimation := True;
                  end;

                 if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED = 0
                 then
                   SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                                 GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
                 SetAlphaBlendTransparent(FForm.Handle, 0);
                 if CanShowBorderLayer and (FForm.Visible or (FForm.Tag = -10000))
                 then
                   begin
                     FBorderLayer.CheckFormAlpha(0, False);
                     FBorderLayer.ShowWithForm;
                   end;
                 SetTimer(FForm.Handle, 1, 1, nil);
               end;
             //
             if (FForm.FormStyle <> fsMDIForm) and FSupportNCArea
             then
               UpdateForm
             else
             if (FForm.FormStyle = fsMDIForm) and (FForm.ClientHandle <> 0) and
                (FClientInstance = nil)
             then
               begin
                 FPrevClientProc := Pointer(GetWindowLong(FForm.ClientHandle, GWL_WNDPROC));
                 FClientInstance := MakeObjectInstance(FormClientWindowProcHook);
                 SetWindowLong(FForm.ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
                 UpDateForm;
               end;
             if FForm.FormStyle = fsMDIChild
             then
               begin
                 AddChildToMenu(FForm);
                 AddChildToBar(FForm);
                 IsChildMustMax := SendMessage(Application.MainForm.Handle, WM_MDICHILDGETMAXSTATE, 0, 0);
                 if (IsChildMustMax = 1) and (biMaximize in Self.BorderIcons) then WindowState := wsMaximized;
               end;
             if not FSupportNCArea then ControlsToAreas;
             if FForm.Menu <> nil then FForm.Menu := nil;

             if (FWindowStateInit <> FWindowState) and not (csDesigning in ComponentState) and
              not FSupportNCArea and (Message.WParam > 0)
             then
                WindowState := FWindowStateInit;
           end
         else
           begin
              if FLayerManager.IsVisible then FLayerManager.Hide;
              if FMenuLayerManager.IsVisible then FMenuLayerManager.Hide;
              if FForm.FormStyle = fsMDIChild
              then
                begin
                  DeleteChildFromMenu(FForm);
                  DeleteChildFromBar(FForm);
                end;

              if (FBorderLayer.FVisible) and FIsVistaOS and SupportNCArea and
                 (GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED = 0)
              then
                SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                          GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
           end;
       end
     else
      if Message.wParam > 0 then
        begin
           if FStartShow and (FPositionInMonitor = sppDefault)
             then
               FStartShow := False
             else
             if FStartShow and (Self.WindowState = wsNormal)
             then
               begin
                 FStartShow := False;
                 ApplyPositionInMonitor;
               end;

          if (FForm.FormStyle = fsMDIForm) and (FForm.ClientHandle <> 0) and
             (FClientInstance = nil)
             then
               begin
                 FPrevClientProc := Pointer(GetWindowLong(FForm.ClientHandle, GWL_WNDPROC));
                 FClientInstance := MakeObjectInstance(FormClientWindowProcHook);
                 SetWindowLong(FForm.ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
                 UpDateForm;
               end;

           if CheckW2KWXP and (FAlphaBlend or FAlphaBlendAnimation or ((FSD <> nil) and FSD.AnimationForAllWindows))
             then
               begin
                 if GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED = 0
                 then
                   SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                                 GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
                 SetAlphaBlendTransparent(FForm.Handle, 0);
                 SetTimer(FForm.Handle, 1, 1, nil);
               end;
        end
      else
        begin
          if FLayerManager.IsVisible then FLayerManager.Hide;
          if FMenuLayerManager.IsVisible then FMenuLayerManager.Hide;
        end;

      WM_NCHITTEST:
        if FSupportNCArea
        then
          begin
            if FBorderLayer.FVisible and (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder
            then
              begin
                Result := HTCLIENT;
                Old := False;
              end
            else
            if FSkinnableForm then
            begin
            P.X := TWMNCHitTest(Message).Pos.X;
            P.Y := TWMNCHitTest(Message).Pos.Y;
            PointToNCPoint(P);
            if FSkinSupport
            then
              Result := NewNCHitTest(P)
            else
              Result := NewDefNCHitTest(P);
            if not MouseTimer.Enabled and (Message.Result = HTNCACTIVE)
            then
              begin
                TestActive(P.X, P.Y, True);
                MouseTimer.Enabled := True;
              end;
              Old := False;
            end;

          end
        else
          if FSkinSupport
          then 
            begin
              P.X := TWMNCHitTest(Message).Pos.X;
              P.Y := TWMNCHitTest(Message).Pos.Y;
              P := FForm.ScreenToClient(P);
              if not MouseIn
              then
                begin
                  MouseIn := True;
                  TestActive(P.X, P.Y, True);
                  MouseTimer.Enabled := True;
                end;
              Result := NewHitTest(P);
              Old := False;
            end
          else
            Result := HTCLIENT;

      WM_BEFORECHANGESKINDATA:
        if WParam = Integer(FSD)
        then
          begin
            if (FBorderLayer.FData <> nil) and FBorderLayer.FVisible and
               (FBorderLayer.FData.FullBorder)
            then
              begin
                FOldFormBounds.Left := FForm.Left - FBorderLayer.LeftSize;
                FOldFormBounds.Top := FForm.Top - FBorderLayer.TopSize;
                FOldFormBounds.Right := FForm.Width +
                  FBorderLayer.RightSize + FBorderLayer.LeftSize;
                FOldFormBounds.Bottom := FForm.Height +
                 FBorderLayer.BottomSize + FBorderLayer.TopSize;
                FOldFullBorder := 1;
              end
            else
              begin
                FOldFormBounds.Left := FForm.Left;
                FOldFormBounds.Top := FForm.Top;
                FOldFormBounds.Right := FForm.Width;
                FOldFormBounds.Bottom := FForm.Height;
                FOldFullBorder := 0;
              end;
            FStopPainting := True;
            FSkinSupport := False;
            MouseTimer.Enabled := False;
            MorphTimer.Enabled := False;
            AnimateTimer.Enabled := False;
            ClearObjects;
            BeforeUpDateSkinControls(WParam, FForm);
            BeforeUpDateSkinComponents(WParam);
           end;

      WM_AFTERCHANGESKINDATA:
        begin
          if (WParam = Integer(FSD)) and (FForm.FormStyle = fsMDIForm)
          then
            begin
              ResizeMDIChilds;
            end;
        end;

      WM_CHANGEFORMSKINNABLE:
       {$IFDEF VER200}
       if not FUseRibbon then
       {$ENDIF}
       if (FSD <> nil) and (WParam = Integer(FSD)) and not (FForm.FormStyle = fsMDIChild)
       then
         begin
           SetSkinnableForm(FSD.SkinnableForm);
         end;

      WM_CHANGESKINDATA:
        begin
          FStopPainting := False;
          if WParam = Integer(FSD)
          then
            ChangeSkinData;
          UpDateSkinControls(WParam, FForm);
          UpDateSkinComponents(WParam);
        end;

      WM_CHANGERESSTRDATA:
        begin
          CheckObjectsHint;
        end;

      WM_MOVING:
      if FSkinnableForm then
        if (WindowState = wsMaximized) and (FForm.FormStyle <> fsMDIChild)
        then
          begin
            L := FForm.Left;
            T := FForm.Top;
            PRect(Message.LParam)^.Left := L;
            PRect(Message.LParam)^.Top := T;
            PRect(Message.LParam)^.Right := L + FForm.Width;
            PRect(Message.LParam)^.Bottom := T + FForm.Height;
          end
        else
        if FMagnetic
        then
          begin
            L := PRect(Message.LParam)^.Left;
            T := PRect(Message.LParam)^.Top;
            DoMagnetic(L, T, FForm.Width, FForm.Height);
            PRect(Message.LParam)^.Left := L;
            PRect(Message.LParam)^.Top := T;
            PRect(Message.LParam)^.Right := L + FForm.Width;
            PRect(Message.LParam)^.Bottom := T + FForm.Height;
          end;

      WM_ENTERSIZEMOVE:
      begin
        FOnMouseDownCoord.X := Mouse.CursorPos.X;
        FOnMouseDownCoord.Y := Mouse.CursorPos.Y;
        if FSupportNCArea and FSkinnableForm 
        then
          begin
            UpDateActiveObjects;
            MouseTimer.Enabled := False;
            ActiveObject := -1;
            MouseCaptureObject := -1;
            FSizeMove := True;
            FFullDrag := GetFullDragg;
          end;
        end;

      WM_EXITSIZEMOVE:
        if FSupportNCArea and FSkinnableForm 
        then
          begin
           if FSizing and ((FFormWidth <> FForm.Width) or (FFormHeight <> FForm.Height))
           then
             begin
               FFormLeft := FForm.Left;
               FFormTop := FForm.Top;
               FFormWidth := FForm.Width;
               FFormHeight := FForm.Height;
               CreateNewForm(True);
             end;
            MouseTimer.Enabled := False;
            ActiveObject := -1;
            OldActiveObject := -1;
            MouseCaptureObject := -1;
            FSizeMove := False;
            FSizing := False;
            if FSupportNCArea and (FSD <> nil) and not FSD.Empty
            then
              SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
           if CanShowBorderLayer
           then
             FBorderLayer.SetBoundsWithForm;
         end;

     WM_SIZING:
      if FSizeMove and FFullDrag
      then
        begin
          FSizing := True;
          FBorderLayerChangeSize := False;
          HMagnetized := False;
          HMagnetized2 := False;
          VMagnetized := False;
          VMagnetized2 := False;
          OldWindowProc(Message);
          Old := False;
          R := PRect(LParam);
          FFormWidth := RectWidth(R^);
          FFormHeight := RectHeight(R^);
          //
          if FFormWidth < GetMinWidth
          then FFormWidth := GetMinWidth;
          if FFormHeight < GetMinHeight
          then FFormHeight := GetMinHeight;
          //
          if (FSD = nil) or (FSD.Empty) and FSkinnableForm and FSupportNCArea
          then
            begin
              CreateNewRegion(True);
            end
          else
          if FSupportNCArea and FSkinnableForm
          then
            begin
              if (FSD <> nil) and
                 (FForm.Width >= GetMinWidth) and
                 (FForm.Height >= GetMinHeight) and
                 ((FForm.Width <> FFormWidth) or
                 (FForm.Height <> FFormHeight))
              then
               begin
                  CreateNewForm(True);
                  if CanShowBorderLayer
                  then
                  if (FFormTop = FOldFormTop) and (FOldFormLeft = FFormLeft)
                   then
                      FBorderLayer.SetBoundsWithForm3(FFormLeft, FFormTop, FFormWidth, FFormHeight);
                  FOldFormTop := FFormTop;
                  FOldFormLeft := FFormLeft;
               end;
            end;
        end;

      WM_SIZE:
      if not FSizeMove or not FFullDrag
      then
        begin
          if not FBorderLayerChangeSize
          then 
            begin
              OldWindowProc(Message);
              FFormWidth := FForm.Width;
              FFormHeight := FForm.Height;
            end;

          HMagnetized := False;
          HMagnetized2 := False;
          VMagnetized := False;
          VMagnetized2 := False;
          //
          Old := False;
          //
          if not FSkinSupport
          then
            begin
              if FSupportNCArea
              then
                begin
                  SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
                  CreateNewRegion(True);
                end;
            end  
          else  
          if FSupportNCArea
          then
            begin
              if (FSD <> nil) and FSkinnableForm and
                 (FFormWidth >= GetMinWidth) and
                 (FFormHeight >= GetMinHeight)
              then
                begin
                  if CanShowBorderLayer
                  then
                     begin
                        if not FBorderLayerChangeSize
                        then
                          FBorderLayer.SetBoundsWithForm
                        else
                          FBorderLayer.SetBoundsWithForm3(FFormLeft, FFormTop, FFormWidth, FFormHeight);
                     end;   
                  CreateNewForm(True);
                end;
            end
          else
            begin
              if (FSD <> nil) and not FRollUpState
              then
                begin
                  CS := CanScale;
                  if CS or (not CS and (FForm.ClientWidth = FSD.FPicture.Width)
                     and (FForm.ClientHeight = FSD.FPicture.Height))
                  then
                    begin
                      if CanShowBorderLayer
                      then
                        FBorderLayer.SetBoundsWithForm;
                      CreateNewForm(CS);
                    end;
                end;
            end;

          if FBorderLayerChangeSize then OldWindowProc(Message);
            
          if FAlphaBlend and (FAlphaBlendValue <> 255) and CheckW2KWXP and
             FSupportNCArea
          then
            begin
              SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
              FForm.RePaint;
            end;

          if FSupportNCArea and not FLogoBitMap.Empty and (FForm.FormStyle <> fsMDIForm)
          then
            FForm.RePaint;
        end
      else
        if FSupportNCArea and not FLogoBitMap.Empty and (FForm.FormStyle <> fsMDIForm)
        then
          FForm.RePaint;

      WM_DESTROY:
      begin
        MouseTimer.Enabled := False;
        MorphTimer.Enabled := False;
        AnimateTimer.Enabled := False;
        if (FForm.FormStyle = fsMDIChild)
        then
          begin
            FWindowState := wsNormal;
            FWindowStateInit := wsNormal;
            SendMessage(Application.MainForm.Handle, WM_MDICHILDRESTORE, 0, 0);
            CheckMDIMainMenu;
            CheckMDIBar;
            SendMessage(Application.MainForm.Handle, WM_MDICHILDMOVE, FForm.Handle, 0);
          end;  
      end;

     WM_ACTIVATE:
     if FSkinnableForm then
       begin
         FIsDragging := False;
         OldWindowProc(Message);
         if (FForm.FormStyle = fsMDIChild) and (WindowState = wsMaximized)
         then
           FormChangeActive(False)
         else
           begin
             if FSupportNCArea
             then
               begin
                 TestActive(-1, -1, False);
                 UpDateActiveObjects;
                 SendMessage(FForm.Handle, WM_NCPaint, 0, 0);
               end;  
             FormChangeActive(True);
             if not FSupportNCArea then FForm.RePaint;
           end;
         Old := False;
         if FForm.FormStyle = fsMDIForm then Self.CheckMDIMainMenu;
       end;

     WM_DISPLAYCHANGE:
     if FSupportNCArea
     then 
       begin
         if FForm.BorderStyle <> bsNone
         then
           begin
             if (FForm.Width > GetMaxWidth) or (FForm.Height > GetMaxHeight)
             then
               UpDateForm;
           end;
       end;


     WM_GetMinMaxInfo:
     if FSkinnableForm then
     with TWMGetMinMaxInfo(Message) do
      begin
        MM := PMinMaxInfo(lParam);
        MM^.ptMinTrackSize.x := GetMinWidth;
        MM^.ptMinTrackSize.y := GetMinHeight;
        MM^.ptMaxTrackSize.x := GetMaxWidth;
        MM^.ptMaxTrackSize.y := GetMaxHeight;
        Message.Result := 0;
      end;

     WM_NCCALCSIZE:
     if FSkinnableForm then
       begin
         Old := False;
         if FSupportNCArea and
            not ((FForm.FormStyle = fsMDIChild) and
            (WindowState = wsMaximized)) and (FForm.BorderStyle <> bsNone)
         then
           if CanNCSupport
           then
             begin
               CalcRects;
               if CanShowBorderLayer and (FBorderLayer.FData <> nil)  and FBorderLayer.FData.FullBorder
               then
                 begin
                   Message.Result := 1;
                 end
               else
               with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0], FSD do
               begin
                 Inc(Left, ClRect.Left);
                 Inc(Top,  ClRect.Top);
                 Dec(Right, FPicture.Width - ClRect.Right);
                 Dec(Bottom, FPicture.Height - ClRect.Bottom);
                 if Right < Left
                 then Right := Left;
                 if Bottom < Top
                 then Bottom := Top;
               end;
             end
           else
             with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
             begin
               Inc(Left, 3);
               Inc(Top, GetDefCaptionHeight + 3);
               Dec(Right, 3);
               Dec(Bottom, 3);
               if Right < Left then Right := Left;
               if Bottom < Top
               then Bottom := Top;
             end;
       end;

    WM_SYNCPAINT:
    if FSkinnableForm then
      if FRollUpState and FSupportNCArea
      then
        begin
          SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
           Message.Result := 0;
          Old := False;
        end;

     WM_NCPAINT:
     if FSkinnableForm then
      begin
        if (FForm.BorderStyle <> bsNone) and
            not ((FForm.FormStyle = fsMDICHILD) and (WindowState = wsMaximized))
        then
          if FSupportNCArea and FSkinSupport
          then
            begin
               if CanShowBorderLayer and (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder
               then
                 begin
                   Message.Result := 1;
                 end
               else
                PaintNCSkin(0, False);
            end
          else
          if FSupportNCArea
          then
            PaintNCDefault(0, False);
        Old := False;
      end;

    WM_NCACTIVATE:
    if FSkinnableForm
    then
      begin
        FBorderLayerChangeSize := False;
        //
        if SkinMenu.Visible then SkinMenu.Hide;
        if FLayerManager.IsVisible then FLayerManager.Hide;
        if FMenuLayerManager.IsVisible then FMenuLayerManager.Hide;
        //
        FFormActive := TWMNCACTIVATE(Message).Active;
        if not FFormActive then TestActive(-1, -1, False);
        if ((FForm.FormStyle = fsMDIForm) and not FIsVistaOS) or
           ((FForm.FormStyle = fsMDIChild) and FForm.Visible)
        then
          begin
            if (FForm.FormStyle = fsMDIChild) and FIsVistaOS
            then
              SendMessage(FForm.Handle, WM_SETREDRAW, 0, 0);

            OldWindowProc(Message);

            if (FForm.FormStyle = fsMDIChild) and FIsVistaOS
            then
              SendMessage(FForm.Handle, WM_SETREDRAW, 1, 0);

            if (FForm.FormStyle = fsMDIChild) and FIsVistaOS
            then
               begin
                 RedrawWindow(FForm.Handle, nil, 0,
                   RDW_INVALIDATE + RDW_ALLCHILDREN + RDW_UPDATENOW);
               end
            else
              if FForm.FormStyle = fsMDIChild then FForm.Repaint;
          end
        else
          Message.Result := 1;

        if not ((FForm.FormStyle = fsMDICHILD) and (WindowState = wsMaximized))
           and (FForm.BorderStyle <> bsNone)
        then
          begin
            SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
            FormChangeActive(True);
          end
        else
          FormChangeActive(False);

        if (FForm.FormStyle = fsMDIChild) and (WindowState = wsMaximized)
        then
          begin
            DSF := GetDynamicSkinFormComponent(Application.MainForm);
            if DSF <> nil then DSF.UpDateFormNC;
          end;

        //
        if FForm.Visible and FClientInActiveEffect
        then
          begin
            if not FFormActive
            then
              ShowClientInActiveEffect else HideClientInActiveEffect;
          end;
        //

        Old := False;

        if (FForm.FormStyle = fsMDIChild)
        then
          begin
            CheckMDIMainMenu;
            CheckMDIBar;
            UpDateChildActiveInMenu;
          end;
        if FForm.Visible
        then
          begin
            if CanShowBorderLayer
            then
              FBorderLayer.SetActive(FFormActive, True)
          end
        else
        if FForm.Tag <> -10000
        then
          begin
            if CanShowBorderLayer
            then
              FBorderLayer.Hide;
          end;
      end;

     WM_SHOWLAYEREDBORDER:
     begin
       if (FBorderLayer.FData <> nil) and FBorderLayer.FVisible and
          (FBorderLayer.FData.FullBorder)
        then
          begin
            FOldFormBounds.Left := FForm.Left - FBorderLayer.LeftSize;
            FOldFormBounds.Top := FForm.Top - FBorderLayer.TopSize;
            FOldFormBounds.Right := FForm.Width +
            FBorderLayer.RightSize + FBorderLayer.LeftSize;
            FOldFormBounds.Bottom := FForm.Height +
            FBorderLayer.BottomSize + FBorderLayer.TopSize;
            FOldFullBorder := 1;
          end
        else
          begin
            FOldFormBounds.Left := FForm.Left;
            FOldFormBounds.Top := FForm.Top;
            FOldFormBounds.Right := FForm.Width;
            FOldFormBounds.Bottom := FForm.Height;
            FOldFullBorder := 0;
          end;

        if CanShowBorderLayer
        then
          begin
            if FForm.Visible and not FBorderLayer.FVisible
            then
               begin
                 if FIsVistaOS and not DisableDWMAnimation
                 then
                  begin
                    SetDWMAnimation(FForm.Handle, False);
                    DisableDWMAnimation := True;
                  end;
                 FBorderLayer.FActive := FFormActive;
                 FBorderLayer.ShowWithForm;
                 CorrectFormBounds;
                 FForm.Show;
               end;
           end
       else
         begin
           if FBorderLayer.FVisible
           then
             begin
               FBorderLayer.Hide;
               CorrectFormBounds;
               if FIsVistaOS and DisableDWMAnimation
               then
                 begin
                   SetDWMAnimation(FForm.Handle, True);
                   DisableDWMAnimation := False;
                 end;
             end;
         end;
       //
       if (FBorderLayer.FData <> nil) and (FBorderLayer.FData.FullBorder)
       then
         ChangeSkinData;
       //
    end;

     WM_UPDATELAYEREDBORDER:
       begin
         if CanShowBorderLayer and FBorderLayer.FVisible
         then
           begin
             FBorderLayer.Hide;
             FBorderLayer.ShowWithForm;
           end;
       end;

     WM_CHECKLAYEREDBORDER:
     if FForm.Tag = -10000
     then
       begin
         if CanShowBorderLayer
         then
           begin
             SetForegroundWindow(Application.MainForm.Handle);
             CheckStayOnTopWindows;
           end;
         FForm.Tag := 0;
       end;

     WM_ERASEBKGND:
       begin
         if (FForm.FormStyle <> fsMDIForm) or FClientInActiveDraw then
         if FSupportNCArea
         then
           begin
             if FSkinSupport
             then
               begin
                {$IFDEF VER200}
                if FUseRibbon and (FSD.MDIBGPictureIndex <> -1)
                then
                  PaintBG3(wParam)
                else
                {$ENDIF}
                 if FSD.BGPictureIndex = -1
                 then
                   PaintBG(wParam)
                 else
                   PaintBG2(wParam);
               end
             else
               PaintBGDefault(wParam);
           end
         else
           Paint(wParam);
         Old := False;
       end;


       WM_WINDOWPOSCHANGED:

         with TWMWINDOWPOSCHANGED(Message) do
         begin

           if ((WindowPos.flags and SWP_HIDEWINDOW) <> 0) and
               (FBorderLayer.FVisible) and FIsVistaOS and SupportNCArea and
              (GetWindowLong(FForm.Handle, GWL_EXSTYLE) and WS_EX_LAYERED = 0)
           then
             SetWindowLong(FForm.Handle, GWL_EXSTYLE,
                          GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);

           FFormLeft := WindowPos.x;
           FFormTop := WindowPos.y;

           if not FSizing and FBorderLayerChangeSize
           then
             begin
               FFormWidth := WindowPos.cx;
               FFormHeight := WindowPos.cy;
             end;

           if FSizing and ((FForm.Top <> FFormTop) or (FFormLeft <> FForm.Left))
              and CanShowBorderLayer
           then
             FBorderLayer.SetBoundsWithForm3(FFormLeft, FFormTop, FFormWidth, FFormHeight);
             
           if not FSizing and not FBorderLayerChangeSize
           then
             begin
               if CanShowBorderLayer
               then
                 FBorderLayer.MoveWithForm2(FFormLeft, FFormTop);
               FOldFormLeft := FFormLeft;
               FOldFormTop := FFormTop;
             end;  
         end;

    end;
    
    if Old then OldWindowProc(Message);

    case Msg of

       WM_MOVE, WM_SIZE:
       if FForm.FormStyle = fsMDIChild
       then
         begin
           SendMessage(Application.MainForm.Handle, WM_MDICHILDMOVE, 0, 0);
         end;


      WM_SHOWWINDOW:
       begin
         if Message.wParam > 0
         then
           begin
             if CheckW2KWXP and not FAlphaBlendAnimation and not FAlphaBlend and not Checkvista and not
                ((FSD <> nil) and FSD.AnimationForAllWindows)
             then
               begin
                 if (FForm.Visible) or (FForm.Tag = -10000)
                 then
                   begin
                     if CanShowBorderLayer
                     then
                       begin
                         Application.ProcessMessages;
                         FBorderLayer.FActive := True;
                         FBorderLayer.ShowWithForm;
                       end;
                   end;
               end;
           end
         else
           begin
             if CanShowBorderLayer
             then
               FBorderLayer.Hide;
           end;
         //
         if (FForm.FormStyle = fsMDIChild) and (Message.wParam > 0)
         then
         begin
           SendMessage(Application.MainForm.Handle, WM_MDICHILDMOVE, 0, 0);
         end;
       end;


      WM_LBUTTONDBLCLK:
        begin
          MouseDown(mbLeft, LoWord(LParam), HiWord(LParam));
          MouseDblClick;
          CheckWindowState;
        end;
      WM_RBUTTONDBLCLK: MouseDown(mbRight, LoWord(LParam), HiWord(LParam));
      WM_MOUSEMOVE:
        begin
          if not FSupportNCArea
          then
            begin
              P.X := LoWord(LParam);
              P.Y := HiWord(LParam);
              MouseMove(P.X, P.Y);
              if FIsDragging
              then
                begin
                  GetCursorPos(P);
                  if (P.X <> FOLDX) or (P.Y <> FOLDY)
                  then
                    begin
                      L := FForm.Left + P.X - FOldX;
                      T := FForm.Top + P.Y - FOldY;
                      if FMagnetic
                      then
                        begin
                          DoMagnetic(L, T, FForm.Width, FForm.Height);
                        end;
                      FForm.SetBounds(L, T, FForm.Width, FForm.Height);
                      FForm.Repaint;
                      FOLDX := P.X;
                      FOLDY := P.Y;
                    end;
                end;
            end;
        end;
      WM_LBUTTONDOWN:
        begin
          if not FSupportNCArea
          then
            begin
              FOnMouseDownCoord.X := Mouse.CursorPos.X;
              FOnMouseDownCoord.Y := Mouse.CursorPos.Y;
              MouseDown(mbLeft, LoWord(LParam), HiWord(LParam));
            end;
        end;
      WM_RBUTTONDOWN:
        begin
          if not FSupportNCArea
          then MouseDown(mbRight, LoWord(LParam), HiWord(LParam));
        end;  
      WM_LBUTTONUP:
        begin
          if not FSupportNCArea
          then MouseUp(mbLeft, LoWord(LParam), HiWord(LParam))
          else MouseUp(mbLeft, -1, -1);
        end;
      WM_RBUTTONUP:
        begin
          if not FSupportNCArea
          then MouseUp(mbRight, LoWord(LParam), HiWord(LParam))
          else MouseUp(mbRight, -1, -1);
        end;
      WM_NCMOUSEMOVE:
      if FSupportNCArea and FSkinnableForm then
        begin
          P.X := TWMNCMOUSEMOVE(Message).XCursor;
          P.Y := TWMNCMOUSEMOVE(Message).YCursor;
          PointToNCPoint(P);
          MouseMove(P.X, P.Y);
        end;

      WM_NCLBUTTONDBLCLK:
      if FSupportNCArea and FSkinnableForm then
      begin
        P.X := TWMNCLBUTTONDBLCLK(Message).XCursor;
        P.Y := TWMNCLBUTTONDBLCLK(Message).YCursor;
        PointToNCPoint(P);
        TestActive(P.X, P.Y, True);
        MouseDown(mbLeft, P.X, P.Y);
        MouseDblClick;
        if Message.wParam = HTCAPTION
        then
          if FSizeAble and (WindowState = wsMinimized)
          then
            begin
              WindowState := wsNormal;
              MouseCaptureObject := -1;
            end
          else
          if FSizeAble and (WindowState <> wsMaximized) and not FRollUpState and
             (biMaximize in BorderIcons)
          then
            begin
              WindowState := wsMaximized;
              MouseCaptureObject := -1;
            end
          else
          if FSizeAble and (WindowState = wsMaximized) and not MaxRollUpState
          then
            begin
              WindowState := wsNormal;
              MouseCaptureObject := -1;
            end
          else
            begin
              if FRollUpState
              then
                RollUpState := False
              else
                RollUpState := True;
              MouseCaptureObject := -1;
            end;
      end;

      WM_NCRBUTTONDBLCLK:
      if FSupportNCArea and FSkinnableForm then
        begin
          P.X := TWMNCRBUTTONDBLCLK(Message).XCursor;
          P.Y :=TWMNCRBUTTONDBLCLK(Message).YCursor;
          PointToNCPoint(P);
          TestActive(P.X, P.Y, True);
          MouseDown(mbRight, P.X, P.Y);
          if wParam = HTCAPTION then MouseCaptureObject := -1;
        end;

      WM_NCLBUTTONDOWN:
      if FSupportNCArea and FSkinnableForm then
        begin
          if not FSizeMove
          then
            begin
              P.X := TWMNCLBUTTONDOWN(Message).XCursor;
              P.Y := TWMNCLBUTTONDOWN(Message).YCursor;
              PointToNCPoint(P);
              TestActive(P.X, P.Y, True);
              MouseDown(mbLeft, P.X, P.Y);
              if wParam = HTCAPTION then MouseCaptureObject := -1;
            end
          else
            FSizeMove := False;
        end;

      WM_NCLBUTTONUP:
      if FSupportNCArea and FSkinnableForm
      then
        begin
          try
            P.X := TWMNCLBUTTONUP(Message).XCursor;
            P.Y := TWMNCLBUTTONUP(Message).YCursor;
            PointToNCPoint(P);
            MouseUp(mbLeft, P.X, P.Y);
          except
            Exit;
          end;
        end;

      WM_NCRBUTTONDOWN:
      if FSupportNCArea and FSkinnableForm then
        begin
          P.X := TWMNCRBUTTONDOWN(Message).XCursor;
          P.Y := TWMNCRBUTTONDOWN(Message).YCursor;
          PointToNCPoint(P);
          TestActive(P.X, P.Y, True);
          MouseDown(mbRight, P.X, P.Y);
          if wParam = HTCAPTION
          then
            begin
              GetCursorPos(P);
              MouseCaptureObject := -1;
              if not FDisableSystemMenu then
              TrackSystemMenu(P.X, P.Y);
            end;
        end;
      WM_NCRBUTTONUP:
      if FSupportNCArea and FSkinnableForm then
        begin
          P.X := TWMNCRBUTTONUP(Message).XCursor;
          P.Y := TWMNCRBUTTONUP(Message).YCursor;
          PointToNCPoint(P);
          MouseUp(mbRight, P.X, P.Y);
        end;
    end;
  end;
end;

procedure TspDynamicSkinForm.CalcRects;
var
  OX, OY: Integer;
begin
  if FFormWidth = 0 then FFormWidth := FForm.Width;
  if FFormHeight = 0 then FFormHeight := FForm.Height;
  if (FSD <> nil) and not FSD.Empty then
  with FSD do
  begin
    OX := FFormWidth - FPicture.Width;
    OY := FFormHeight - FPicture.Height;
    NewLTPoint := LTPoint;
    NewRTPoint := Point(RTPoint.X + OX, RTPoint.Y);
    NewLBPoint := Point(LBPoint.X, LBPoint.Y + OY);
    NewRBPoint := Point(RBPoint.X + OX, RBPoint.Y + OY);
    NewClRect := Rect(ClRect.Left, ClRect.Top,
    ClRect.Right + OX, ClRect.Bottom + OY);
    NewCaptionRect := CaptionRect;
    if not IsNullRect(CaptionRect)
    then Inc(NewCaptionRect.Right, OX);
    NewButtonsRect := ButtonsRect;
    NewButtonsInLeft := CapButtonsInLeft;
    if not IsNullRect(ButtonsRect) and (ButtonsRect.Left > FPicture.Width div 2)
    then
      OffsetRect(NewButtonsRect, OX, 0)
    else
    if not IsNullRect(ButtonsRect) and (ButtonsRect.Left < FPicture.Width div 2)
    then
      ButtonsInLeft := True;
    NewButtonsOffset := ButtonsOffset;

    NewHitTestLTPoint := HitTestLTPoint;
    NewHitTestRTPoint := Point(HitTestRTPoint.X + OX, HitTestRTPoint.Y);
    NewHitTestLBPoint := Point(HitTestLBPoint.X, LBPoint.Y + OY);
    NewHitTestRBPoint := Point(HitTestRBPoint.X + OX, HitTestRBPoint.Y + OY);
    NewMaskRectArea := Rect(MaskRectArea.Left, MaskRectArea.Top,
    MaskRectArea.Right + OX, MaskRectArea.Bottom + OY);
    NewIconRect := Self.CalcRealObjectRect(IconRect);
    NewMainMenuRect := MainMenuRect;
    if CanScale
    then
      begin
        NewMainMenuRect.Right := MainMenuRect.Right + OX;
        if PtInRect(Rect(0, LBPoint.Y, LBPoint.X,
           FPicture.Height), MainMenuRect.TopLeft)
        then
          OffsetRect(NewMainMenuRect, 0, OY);
      end;
  end;
end;

procedure TspDynamicSkinForm.CreateNewForm;
begin
  if csDesigning in ComponentState then Exit;
  if FSD = nil then Exit;
  if FSD.Empty then Exit;
  if FSkinnableForm then CalcRects;
  if FSkinnableForm then if FCanScale then CalcAllRealObjectRect;
  CreateNewRegion(FCanScale);
  if Assigned(FOnChangeClientRect) then FOnChangeClientRect(NewClRect);
  if FSupportNCArea
  then
    begin
      if (FRgn = 0)  and FSkinnableForm
      then SendMessage(FForm.Handle, WM_NCPAINT, 0, 0);
      if FSkinSupport and (FSD <> nil) and (FSD.StretchEffect)
      then
        begin
          FForm.RePaint;
          CheckControlsBackground;
        end;
    end
  else
    begin
      FForm.RePaint;
      ControlsToAreas;
    end;
end;

function TspDynamicSkinForm.IsNullHeight: Boolean;
begin
  Result := (FBorderLayer.FData <> nil) and FBorderLayer.FData.FullBorder and
  (RollUpState or
  ((WindowState = wsMinimized) and not FMinimizeDefault and (FForm <> Application.MainForm)));
end;

procedure TspDynamicSkinForm.CreateNewRegion;
var
  Size: Integer;
  RgnData: PRgnData;
  R1, R2, R3, R4, TempRgn: HRGN;
begin

  if not FSkinnableForm
  then
    begin
      if FRgn <> 0
      then
        begin
          SetWindowRgn(FForm.Handle, 0, True);
          DeleteObject(FRgn);
          FRgn := 0;
        end;
      Exit;
    end;

  if (FSD <> nil) and not FSD.Empty and
     (FForm.BorderStyle <> bsNone) and FSupportNCArea and CanShowBorderLayer and
     (FBorderLayer.FData <> nil) and  FBorderLayer.FData.FullBorder
  then
    begin
      TempRgn := FRgn;
      if IsNullHeight
      then
        begin
          if FBorderLayer.FData.RollUpFormHeight <> 0
          then
            begin
              FRgn := CreateRectRgn(0, 0, FFormWidth, FBorderLayer.FData.RollUpFormHeight)
            end
          else
          if not FIsW7
          then
            FRgn := CreateRectRgn(0, 0, FFormWidth, 0)
          else
            FRgn := CreateRectRgn(0, 0, FFormWidth, 1);
        end
      else
        FRgn := CreateRectRgn(0, 0, FFormWidth, FFormHeight);
      SetWindowRgn(FForm.Handle, Frgn, True);
      if TempRgn <> 0 then DeleteObject(TempRgn);
    end
  else
  if (FForm.BorderStyle = bsNone) and FSupportNCArea
  then
    begin
      if FRgn <> 0
      then
        begin
          SetWindowRgn(FForm.Handle, 0, True);
          DeleteObject(FRgn);
          FRgn := 0;
        end;
    end
  else
  if ((FSD <> nil) and not FSD.Empty and FSD.FMask.Empty) or
     ((FForm.FormStyle = fsMDIChild) and (WindowState = wsMaximized))
  then
    begin
      TempRgn := FRgn;
      FRgn := CreateRectRgn(0, 0, FFormWidth, FFormHeight);
      SetWindowRgn(FForm.Handle, Frgn, True);
      if TempRgn <> 0 then DeleteObject(TempRgn);
    end
  else
  if (FSD = nil) or ((FSD <> nil) and FSD.Empty)
  then
    begin
      TempRgn := FRgn;
      FRgn := CreateRectRgn(0, 0, FFormWidth, FFormHeight);
      SetWindowRgn(FForm.Handle, Frgn, True);
      if TempRgn <> 0 then DeleteObject(TempRgn);
      RMLeft.Assign(nil);
      RMTop.Assign(nil);
      RMRight.Assign(nil);
      RMBottom.Assign(nil);
    end
  else
    if (FSD <> nil) and not FSD.FMask.Empty
    then
      begin
        if FCanScale
        then
          begin
            CreateSkinMask(
               FSD.LTPoint, FSD.RTPoint, FSD.LBPoint, FSD.RBPoint, FSD.MaskRectArea,
               NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewMaskRectArea,
               FSD.FMask, RMTop, RMLeft, RMRight, RMBottom,
               FFormWidth, FFormHeight);

            if RMTop.Height > 0
            then
              begin
                Size := CreateRgnFromBmp(RMTop, 0, 0, RgnData);
                R1 := ExtCreateRegion(nil, Size, RgnData^);
                FreeMem(RgnData, Size);
              end
            else
              R1 := 0;    

            if RMBottom.Height > 0
            then
              begin
                Size := CreateRgnFromBmp(RMBottom, 0, NewMaskRectArea.Bottom, RgnData);
                R2 := ExtCreateRegion(nil, Size, RgnData^);
                FreeMem(RgnData, Size);
              end
            else
              R2 := 0;  

            if RMLeft.Width > 0
            then
              begin
                Size := CreateRgnFromBmp(RMLeft, 0, NewMaskRectArea.Top, RgnData);
                R3 := ExtCreateRegion(nil, Size, RgnData^);
                FreeMem(RgnData, Size);
              end
            else
              R3 := 0;

            if RMRight.Width > 0
            then
              begin
                Size := CreateRgnFromBmp(RMRight, NewMaskRectArea.Right, NewMaskRectArea.Top, RgnData);
                R4 := ExtCreateRegion(nil, Size, RgnData^);
                FreeMem(RgnData, Size);
              end
            else
              R4 := 0;    

            TempRgn := FRgn;
            FRgn := CreateRectRgn(NewMaskRectArea.Left, NewMaskRectArea.Top,
                                  NewMaskRectArea.Right, NewMaskRectArea.Bottom);

            CombineRgn(R1, R1, R2, RGN_OR);
            CombineRgn(R3, R3, R4, RGN_OR);
            CombineRgn(R3, R3, R1, RGN_OR);
            CombineRgn(FRgn, FRgn, R3, RGN_OR);
            SetWindowRgn(FForm.Handle, FRgn, True);
            if TempRgn <> 0 then DeleteObject(TempRgn);
            DeleteObject(R1);
            DeleteObject(R2);
            DeleteObject(R3);
            DeleteObject(R4);
          end
        else
          begin
            Size := CreateRgnFromBmp(FSD.FMask, 0, 0, RgnData);
            if Size <> 0
            then
              begin
                TempRgn := FRgn;
                FRgn := ExtCreateRegion(nil, Size, RgnData^);
                SetWindowRgn(FForm.Handle, FRgn, True);
                if TempRgn <> 0 then DeleteObject(TempRgn);
                FreeMem(RgnData, Size);
              end;
          end;
      end;
end;

function TspDynamicSkinForm.GetFormActive;
begin
  if PreviewMode
  then
    Result := True
  else  
  if (FForm.FormStyle = fsMDIChild) or (FForm.FormStyle = fsMDIForm)
  then
    Result := FFormActive
  else
    Result := FForm.Active and (Screen.ActiveCustomForm = FForm);
end;

procedure TspDynamicSkinForm.FormChangeActive;
var
  i: Integer;
  FA: Boolean;
begin
  FA := GetFormActive;
  //
  if (QuickButtons.Count > 0) and not FA
  then
    for i := 0 to FQuickButtons.Count - 1 do
    begin
      FQuickButtons[i].Down := False;
      FQuickButtons[i].Active := False;
    end;
  //
  for i := 0 to ObjectList.Count - 1 do
    if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
    then
      with TspSkinCaptionObject(ObjectList.Items[i]) do
      begin
        if AUpDate and CanObjectTest(RollUp)
        then
          begin
            Active := FA;
            if EnableAnimation and (OldActive <> Active)
            then
              begin
                FIncTime := AnimateTimerInterval;
                if Active
                then
                  CurrentFrame := 1
                 else
                  if InActiveAnimation
                  then
                    CurrentFrame := FrameCount
                   else
                    CurrentFrame := 0;
                if CurrentFrame <> 0 then AnimateTimer.Enabled := True;
              end;
            if not (FSupportNCArea and IsNullRect(ActiveSkinRect))
            then
              ReDraw;
          end
        else
          if Morphing then
          if FA then MorphKf := 1 else MorphKf := 0;
       end;
  if FA
  then
    begin
      if Assigned(FOnActivate) then FOnActivate(Self);
    end
  else
    begin
      if Assigned(FOnDeActivate) then FOnDeActivate(Self);
    end;
  OldActive := FA;  
end;

procedure TspDynamicSkinForm.SetEnabled;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> -1
  then
    TspActiveSkinObject(ObjectList.Items[i]).Enabled := Value;
end;

procedure TspDynamicSkinForm.SwitchSetState;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinSwitchObject
  then
    with TspSkinSwitchObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimpleSetState(AState)
      else State := AState;
end;

function TspDynamicSkinForm.SwitchGetState;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1
  then
    begin
      if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinSwitchObject
      then
        with TspSkinSwitchObject(ObjectList.Items[i]) do Result := State
      else
        Result := swsOff;
    end
  else
    Result := swsOff;
end;

procedure TspDynamicSkinForm.CaptionSetText;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if i <> - 1 then
  if TspActiveSkinObject(ObjectList.Items[i]) is TspSkinCaptionObject
  then
    with TspSkinCaptionObject(ObjectList.Items[i]) do
      if FInChangeSkinData
      then SimpleSetTextValue(AText)
      else TextValue := AText;
end;


function TspDynamicSkinForm.ButtonGetDown;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if (i <> -1) and (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinButtonObject)
  then
    Result := TspSkinButtonObject(ObjectList.Items[i]).Down
  else
    Result := False;
end;

procedure TspDynamicSkinForm.ButtonSetDown;
var
  i: Integer;
begin
  i := GetIndex(AIDName);
  if (i <> -1) and (TspActiveSkinObject(ObjectList.Items[i]) is TspSkinButtonObject)
  then TspSkinButtonObject(ObjectList.Items[i]).Down := ADown;
end;

//  TspMDITabsBar

constructor TspMDITab.Create;
begin
  TabsBar := AParentBar;
  Child := AChild;
  ObjectRect := NullRect;
  Active := False;
  MouseIn := False;
  Visible := False;
end;

procedure TspMDITab.DrawCloseButton(Cnvs: TCanvas; R: TRect);
var
  Buffer: TBitMap;
  CIndex: Integer;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  BSR, ABSR, DBSR, R1: TRect;
  CIX, CIY, X, Y, XO, YO: Integer;
  ButtonData: TspDataSkinButtonControl;
  R2: TRect;
begin
  with TabsBar do
  if FIndex = -1
  then
    begin
      X := R.Left;
      Y := R.Top + RectHeight(R) div 2 - CLOSE_SIZE div 2;
      ButtonRect := Rect(X, Y, X + CLOSE_SIZE, Y + CLOSE_SIZE);
      CIX := ButtonRect.Left + 2;
      CIY := ButtonRect.Top + 2;
      if ButtonMouseDown and
         ButtonMouseIn
      then
        DrawCloseImage(Cnvs, CIX, CIY, clWhite)
      else
      if ButtonMouseIn
      then
        begin
          DrawCloseImage(Cnvs, CIX, CIY, clWhite)
        end
      else
        begin
          DrawCloseImage(Cnvs, CIX, CIY, clBlack);
        end;
      Exit;
    end;

  with TabsBar do
  if not IsNullRect(CloseButtonRect)
  then
    begin
      if ButtonMouseDown and
         ButtonMouseIn
      then
        R1 := CloseButtonDownRect
      else
      if ButtonMouseIn
      then
        R1 := CloseButtonActiveRect
      else
        R1 := CloseButtonRect;
      X := R.Left;
      Y := R.Top + RectHeight(R) div 2 - RectHeight(R1) div 2;
      ButtonRect := Rect(X, Y, X + RectWidth(R1), Y + RectHeight(R1));
      if ButtonTransparent
      then
        begin
          Buffer := TBitMap.Create;
          Buffer.Width := RectWidth(R1);
          Buffer.Height := RectHeight(R1);
          Buffer.Transparent := True;
          Buffer.TransparentMode := tmFixed;
          Buffer.TransparentColor := ButtonTransparentColor;
          Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
            Picture.Canvas, R1);
          Cnvs.Draw(ButtonRect.Left, ButtonRect.Top, Buffer);
          Buffer.Free;
        end
      else
        Cnvs.CopyRect(ButtonRect, Picture.Canvas, R1);
      Exit;
    end;

  ButtonData := nil;
  CIndex := TabsBar.FSD.GetControlIndex('resizetoolbutton');
  if CIndex <> -1
  then
    ButtonData := TspDataSkinButtonControl(TabsBar.FSD.CtrlList[CIndex]);
  if ButtonData = nil then Exit;
  //
  ButtonRect := Rect(0, 0, TabsBar.FCloseSize, TabsBar.FCloseSize);
  //
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(ButtonRect);
  Buffer.Height := RectHeight(ButtonRect);
  //
  with ButtonData do
  begin
    XO := RectWidth(ButtonRect) - RectWidth(SkinRect);
    YO := RectHeight(ButtonRect) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(TabsBar.SkinData.FActivePictures.Items[ButtonData.PictureIndex]);

    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if ButtonMouseDown and
       ButtonMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        Buffer.Canvas.Font.Color := DownFontColor;
      end
    else
    if ButtonMouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        Buffer.Canvas.Font.Color := ActiveFontColor;
      end
    else
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        Buffer.Canvas.Font.Color := FontColor;
      end;
   end;

  CIX := Buffer.Width div 2 - 5;
  CIY := Buffer.Height div 2 - 5;

  DrawCloseImage(Buffer.Canvas, CIX, CIY, Buffer.Canvas.Font.Color);

  X := R.Left;
  Y := R.Top + RectHeight(R) div 2 - Buffer.Height div 2;

  ButtonRect := Rect(X, Y, X + Buffer.Width, Y + Buffer.Height);

  Cnvs.Draw(X, Y, Buffer);
  Buffer.Free;
end;

procedure TspMDITab.ButtonDraw(Cnvs: TCanvas);
var
  Buffer: TBitMap;
  CIndex: Integer;
  ButtonData: TspDataSkinButtonControl;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  BSR, ABSR, DBSR, R: TRect;
  XO, YO, H: Integer;
  TextColor: TColor;
  S: WideString;
begin
  if (RectWidth(ObjectRect) = 0) or (RectHeight(ObjectRect) = 0) then Exit;
  if TabsBar.SkinData = nil then Exit;
  CIndex := TabsBar.SkinData.GetControlIndex('resizebutton');
  if CIndex = -1 then Exit;
  ButtonData := TspDataSkinButtonControl(TabsBar.SkinData.CtrlList[CIndex]);

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(ObjectRect);
  Buffer.Height := RectHeight(ObjectRect);
  with ButtonData do
  begin
    XO := RectWidth(ObjectRect) - RectWidth(SkinRect);
    YO := RectHeight(ObjectRect) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(TabsBar.SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if Active
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        TextColor := DownFontColor;
      end
    else
    if MouseIn
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        TextColor := ActiveFontColor;
      end
    else
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        TextColor := FontColor;
      end;
   end;
  //
  with Buffer.Canvas.Font do
  begin
    if TabsBar.UseSkinFont
    then
      begin
        Name := TabsBar.FontName;
        Style := TabsBar.FontStyle;
        Height := TabsBar.FontHeight;
      end
    else
      Buffer.Canvas.Font.Assign(TabsBar.DefaultFont);
    if (TabsBar.SkinData <> nil) and (TabsBar.SkinData.ResourceStrData <> nil)
    then
      CharSet := TabsBar.SkinData.ResourceStrData.Charset
    else
      CharSet := TabsBar.DefaultFont.CharSet;
     Color := TextColor;
  end;
  S := Child.Caption;

  if TabsBar.ShowCloseButtons
  then
    begin
      R := BtnClRect;
      Dec(R.Right, TabsBar.FCloseSize + 3);
      DrawCloseButton(Buffer.Canvas,
        Rect(R.Right, 0, R.Right + TabsBar.FCloseSize + 3, Buffer.Height));
    end
  else
    R := BtnClRect;
  CorrectTextbyWidthW(Buffer.Canvas, S, RectWidth(R));
  Buffer.Canvas.Brush.Style := bsClear;
  if RectHeight(R) < Buffer.Canvas.TextHeight(S)
  then
    begin
      Inc(R.Bottom, Buffer.Canvas.TextHeight(S) - RectHeight(R));
      H := RectHeight(R);
      YO := RectHeight(ObjectRect) div 2 - H div 2;
      R := Rect(R.Left, YO, R.Right, YO + H);
    end;
  //
  if Assigned(TabsBar.OnTabGetDrawParamsEvent)
  then
   TabsBar.OnTabGetDrawParamsEvent(Self, Buffer.Canvas);
  //
  SPDrawSkinText(Buffer.Canvas, S, R,
   TabsBar.DrawTextBiDiModeFlags(DT_CENTER or DT_SINGLELINE or DT_VCENTER));
  //
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, Buffer);
  Buffer.Free;
end;

procedure TspMDITab.ResizeDraw(Cnvs: TCanvas);
var
  TB: TBitMap;
  DR, R, DRClRect: TRect;
  S: WideString;
  FC: TColor;
  W, H, fx: Integer;
begin
  if RectWidth(ObjectRect) < 1 then Exit;
  TB := TBitMap.Create;
  TB.Width := RectWidth(ObjectRect);
  TB.Height := RectHeight(ObjectRect);
  if Active then TB.Height := TB.Height + TabsBar.FActiveTabOffset;
  W := TB.Width;
  H := TB.Height;
   with TabsBar do
   begin
     if MouseIn and not Active and not IsNullRect(MouseInTabRect)
     then
       begin
         DR := MouseInTabRect;
         FC := MouseInFontColor;
       end
     else
     if Active
     then
       begin
         DR := ActiveTabRect;
         FC := ActiveFontColor;
       end
     else
       begin
         DR := TabRect;
         FC := FontColor;
       end;

      fx := RectHeight(TabRect) div 4;

      DRClRect := Rect(TabLeftOffset, fx,
        RectWidth(DR) - TabRightOffset,  RectHeight(DR) - fx);

      CreateStretchImage(TB, Picture, DR, DRClRect, True);
   end;

   with TB.Canvas.Font do
   begin
     if TabsBar.UseSkinFont
     then
       begin
         Name := TabsBar.FontName;
         Style := TabsBar.FontStyle;
         Height := TabsBar.FontHeight;
       end
      else
        TB.Canvas.Font.Assign(TabsBar.DefaultFont);
     if (TabsBar.SkinData <> nil) and (TabsBar.SkinData.ResourceStrData <> nil)
     then
       CharSet := TabsBar.SkinData.ResourceStrData.Charset
     else
       CharSet := TabsBar.DefaultFont.CharSet;
      Color := FC;
   end;

   if TabsBar.ShowCloseButtons
   then
     begin
       R := Rect(2, 1, TB.Width - TabsBar.FCloseSize - 5, RectHeight(ObjectRect));
       DrawCloseButton(TB.Canvas, Rect(R.Right, R.Top, TB.Width, RectHeight(ObjectRect)));
     end
   else
     R := Rect(2, 1, TB.Width - 2, RectHeight(ObjectRect));

   S := Child.Caption;
   CorrectTextbyWidthW(TB.Canvas, S, RectWidth(R));
   TB.Canvas.Brush.Style := bsClear;
   //
  if Assigned(TabsBar.OnTabGetDrawParamsEvent)
  then
   TabsBar.OnTabGetDrawParamsEvent(Self, TB.Canvas);
  //
   SPDrawSkinText(TB.Canvas, S, R,
    TabsBar.DrawTextBiDiModeFlags(DT_CENTER or DT_SINGLELINE or DT_VCENTER));
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, TB);
  TB.Free;
end;


procedure TspMDITab.Draw(Cnvs: TCanvas);
var
  TB: TBitMap;
  R: TRect;
  S: WideString;
  FC: TColor;
  W, H: Integer;
begin
  if RectWidth(ObjectRect) < 1 then Exit;
  if (TabsBar.TabKind = sptkButton) and (not (TabsBar.FIndex = -1))
  then
    begin
      ButtonDraw(Cnvs);
      Exit;
    end;
  if (not TabsBar.UseSkinSize) and (not (TabsBar.FIndex = -1))
  then
    begin
      ResizeDraw(Cnvs);
      Exit;
    end;
  TB := TBitMap.Create;
  TB.Width := RectWidth(ObjectRect);
  TB.Height := RectHeight(ObjectRect);
  W := TB.Width;
  H := TB.Height;
  if TabsBar.FIndex <> -1
  then
    begin
      if MouseIn and not Active
      then
        begin
          CreateHSkinImage(TabsBar.TabLeftOffset, TabsBar.TabRightOffset,
            TB, TabsBar.Picture, TabsBar.MouseInTabRect, W, H, TabsBar.TabStretchEffect);
          FC := TabsBar.MouseInFontColor;
        end
      else
      if Active
      then
        begin
          CreateHSkinImage(TabsBar.TabLeftOffset, TabsBar.TabRightOffset,
            TB, TabsBar.Picture, TabsBar.ActiveTabRect, W, H, TabsBar.TabStretchEffect);
          FC := TabsBar.ActiveFontColor;
        end
      else
        begin
          CreateHSkinImage(TabsBar.TabLeftOffset, TabsBar.TabRightOffset,
            TB, TabsBar.Picture, TabsBar.TabRect, W, H, TabsBar.TabStretchEffect);
          FC := TabsBar.FontColor;
        end;

      with TB.Canvas.Font do
      begin
        if TabsBar.UseSkinFont
        then
          begin
            Name := TabsBar.FontName;
            Style := TabsBar.FontStyle;
            Height := TabsBar.FontHeight;
          end
        else
          TB.Canvas.Font.Assign(TabsBar.DefaultFont);

        if (TabsBar.SkinData <> nil) and (TabsBar.SkinData.ResourceStrData <> nil)
        then
          CharSet := TabsBar.SkinData.ResourceStrData.Charset
        else
          CharSet := TabsBar.DefaultFont.CharSet;
        Color := FC;
      end;

      if TabsBar.ShowCloseButtons
      then
        begin
          R := Rect(2, 1, TB.Width - TabsBar.FCloseSize - 5,  RectHeight(ObjectRect));
          DrawCloseButton(TB.Canvas, Rect(R.Right, R.Top, TB.Width, RectHeight(ObjectRect)));
        end
      else
         R := Rect(TabsBar.TabLeftOffset, 1, TB.Width - TabsBar.TabRightOffset, RectHeight(ObjectRect));

      S := Child.Caption;
      CorrectTextbyWidthW(TB.Canvas, S, RectWidth(R));
      TB.Canvas.Brush.Style := bsClear;
      SPDrawSkinText(TB.Canvas, S, R,
        TabsBar.DrawTextBiDiModeFlags(DT_CENTER or DT_SINGLELINE or DT_VCENTER));
    end
  else
    with TB.Canvas do
    begin
      if MouseIn and not Active
      then
        Brush.Color := SP_XP_BTNACTIVECOLOR
      else
      if Active
      then
        Brush.Color := SP_XP_BTNDOWNCOLOR
      else
        Brush.Color := clBtnFace;
      FillRect(Rect(0, 0, TB.Width, TB.Height));
      Brush.Style := bsClear;
      Font.Assign(TabsBar.DefaultFont);
      if (TabsBar.SkinData <> nil) and (TabsBar.SkinData.ResourceStrData <> nil)
      then
        Font.CharSet := TabsBar.SkinData.ResourceStrData.Charset;
      //
      if TabsBar.ShowCloseButtons
      then
        begin
          R := Rect(2, 0, TB.Width - TabsBar.FCloseSize - 5,  TB.Height);
          DrawCloseButton(TB.Canvas, Rect(R.Right, R.Top, TB.Width, TB.Height));
        end
      else
        R := Rect(2, 0, TB.Width - 2, TB.Height);
      //
      S := Child.Caption;
      CorrectTextbyWidthW(TB.Canvas,S, RectWidth(R));
      //
      if Assigned(TabsBar.OnTabGetDrawParamsEvent)
      then
       TabsBar.OnTabGetDrawParamsEvent(Self, TB.Canvas);
      //
      SPDrawSkinText(TB.Canvas, S, R,
        TabsBar.DrawTextBiDiModeFlags(DT_CENTER or DT_SINGLELINE or DT_VCENTER));
    end;
  Cnvs.Draw(ObjectRect.Left, ObjectRect.Top, TB);
  TB.Free;
end;

constructor TspSkinMDITabsBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowAddButton := False;
  FAddButtonActive := False;
  FAddButtonDown := False;
  FAddButtonRect := NullRect;
  FDblClickChildMove := False;
  FBottomOffset := 0;
  FCloseSize := CLOSE_SIZE;
  FShowCloseButtons := False;
  FInVisibleCount := 0;
  FMinTabWidth := 0;
  FTabKind := sptkTab;
  FListButton := nil;
  FHideListButton := nil;
  FListMenu := TspSkinPopupMenu.Create(Self);
  FHideListMenu := TspSkinPopupMenu.Create(Self);
  DSF := nil;
  FSupportChildMenus := True;
  FUseSkinSize := True;
  UseSkinFont := True;
  FMoveTabs := True;
  FDefaultHeight := 21;
  Height := 21;
  Width := 150;
  SkinDataName := 'tab';
  FDefaultFont := TFont.Create;
  FDefaultTabWidth := 100;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  ObjectList := TList.Create;
  ActiveTabIndex := -1;
  OldTabIndex := -1;
  DragIndex := -1;
  IsDrag := False;
  FDown := False;
end;

destructor TspSkinMDITabsBar.Destroy;
begin
  ClearObjects;
  ObjectList.Free;
  FDefaultFont.Free;
  FListMenu.Free;
  FHideListMenu.Free;
  if FListButton <> nil then HideListButton;
  if FHideListButton <> nil then HideHideListButton;
  inherited;
end;

procedure TspSkinMDITabsBar.SetShowAddButton;
begin
  if FShowAddButton <> Value
  then
    begin
      FShowAddButton := Value;
      RePaint;
    end;
end;

procedure TspSkinMDITabsBar.DrawAddButton;
var
  Buffer: TBitMap;
  CIndex: Integer;
  ButtonData: TspDataSkinButtonControl;
  BtnSkinPicture: TBitMap;
  BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint: TPoint;
  BtnCLRect: TRect;
  BSR, ABSR, DBSR, R: TRect;
  XO, YO, H: Integer;
  AddColor: TColor;
  S: WideString;
begin
  if not FShowAddButton or IsNullRect(FAddButtonRect) then Exit;

  if FIndex = -1
  then
    begin
      if FAddButtonActive
      then
        Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR
      else
        Cnvs.Brush.Color := clBtnFace;
      Cnvs.FillRect(FAddButtonRect);
      DrawArrowImage(Cnvs, FAddButtonRect, clBtnText, 5);
      Exit;
    end;
  CIndex := SkinData.GetControlIndex('resizetoolbutton');
  if CIndex = -1 then Exit;
  ButtonData := TspDataSkinButtonControl(SkinData.CtrlList[CIndex]);

  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(FAddButtonRect);
  Buffer.Height := RectHeight(FAddButtonRect);
  with ButtonData do
  begin
    XO := RectWidth(FAddButtonRect) - RectWidth(SkinRect);
    YO := RectHeight(FAddButtonRect) - RectHeight(SkinRect);
    BtnLTPoint := LTPoint;
    BtnRTPoint := Point(RTPoint.X + XO, RTPoint.Y);
    BtnLBPoint := Point(LBPoint.X, LBPoint.Y + YO);
    BtnRBPoint := Point(RBPoint.X + XO, RBPoint.Y + YO);
    BtnClRect := Rect(CLRect.Left, ClRect.Top,
      CLRect.Right + XO, ClRect.Bottom + YO);
    BtnSkinPicture := TBitMap(SkinData.FActivePictures.Items[ButtonData.PictureIndex]);
    BSR := SkinRect;
    ABSR := ActiveSkinRect;
    DBSR := DownSkinRect;
    if IsNullRect(ABSR) then ABSR := BSR;
    if IsNullRect(DBSR) then DBSR := ABSR;
    //
    if FAddButtonDown and FAddButtonActive
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, DBSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        AddColor := DownFontColor;
      end
    else
    if FAddButtonActive
    then
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, ABSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        AddColor := DownFontColor;
      end
    else
      begin
        CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
        BtnLtPoint, BtnRTPoint, BtnLBPoint, BtnRBPoint, BtnCLRect,
        Buffer, BtnSkinPicture, BSR, Buffer.Width, Buffer.Height, True,
        LeftStretch, TopStretch, RightStretch, BottomStretch,
        StretchEffect, StretchType);
        AddColor := FontColor;
      end;
   end;

  DrawArrowImage(Buffer.Canvas, Rect(0, 0, Buffer.Width, Buffer.Height), AddColor, 5);
  Cnvs.Draw(FAddButtonRect.Left, FAddButtonRect.Top, Buffer);
  
  Buffer.Free;
end;

procedure TspSkinMDITabsBar.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if (TabKind  = sptkTab) and (FIndex <> -1)
  then
    Dec(Rect.Bottom, FBottomOffset);
end;

procedure TspSkinMDITabsBar.DoClose(Tab: TspMDITab);
begin
  Tab.Child.Close;
end;

function TspSkinMDITabsBar.GetCloseSize;
begin
  if (FIndex <> -1) and not IsNullRect(CloseButtonRect)
  then
    Result := RectWidth(CloseButtonRect)
  else
    Result := CLOSE_SIZE;
end;

procedure TspSkinMDITabsBar.Paint;
begin
  inherited;
  if (FInVisibleCount > 0) and (FHideListButton = nil)
  then
    ShowHideListButton
  else
  if (FInVisibleCount = 0) and (FHideListButton <> nil)
  then
    HideHideListButton;
end;

procedure TspSkinMDITabsBar.ShowHideListButton;
begin
  if FHideListButton <> nil then Exit;
  FHideListButton := TspSkinMenuSpeedButton.Create(Self);
  with FHideListButton do
  begin
    Align := alRight;
    SkinDataName := 'resizetoolbutton';
    SkinData := Self.SkinData;
    Width := MDITABSBARLISTBUTTONW;
    Parent := Self;
    SkinPopupMenu := FHideListMenu;
    FDrawStandardArrow := True;
    FArrowType := 2;
    OnShowTrackMenu := OnShowHideListMenu;
    RePaint;
  end;
end;

procedure TspSkinMDITabsBar.HideHideListButton;
begin
  if FHideListButton = nil then Exit;
  FHideListButton.Visible := False;
  FHideListButton.Free;
  FHideListButton := nil;
end;

procedure TspSkinMDITabsBar.HideMDIItemClick(Sender: TObject);
var
  I: Integer;
  S1, S2: String;
  MainDSF, ChildDSF: TspDynamicSkinForm;
begin
  MainDSF := Self.DynamicSkinForm;
  if MainDSF = nil then Exit;
  S1 := TMenuItem(Sender).Name;
  S2 := MI_CHILDITEMBARHIDE;
  Delete(S1, Pos(S2, S1), Length(S2));
  for I := 0 to MainDSF.FForm.MDIChildCount - 1 do
    if MainDSF.FForm.MDIChildren[I].Name = S1
    then
      begin
        ChildDSF := GetDynamicSkinFormComponent(MainDSF.FForm.MDIChildren[I]);
        if (ChildDSF <> nil) and (ChildDSF.WindowState = wsMinimized)
        then
          ChildDSF.WindowState := wsNormal;
        MainDSF.FForm.MDIChildren[I].Show;
      end;
end;

procedure TspSkinMDITabsBar.UpdateHideListMenu;
var
  Item: TMenuItem;
  i: Integer;
begin
  FHideListMenu.Items.Clear;
  for i := 0 to ObjectList.Count - 1 do
  with TspMDITab(ObjectList.Items[I]) do
  if not Visible then
  begin
    Item := TMenuItem.Create(Self);
    Item.Name := Child.Name + MI_CHILDITEMBARHIDE;
    Item.Caption := Child.Caption;
    Item.OnClick := HideMDIItemClick;
    Item.RadioItem := True;
    Item.GroupIndex := 0;
    Item.Checked := Active;
    FHideListMenu.Items.Add(Item);
  end;
end;

procedure TspSkinMDITabsBar.OnShowHideListMenu(Sender: TObject);
begin
  UpdateHideListMenu;
end;


procedure TspSkinMDITabsBar.MDIItemClick(Sender: TObject);
var
  I: Integer;
  S1, S2: String;
  MainBSF, ChildBSF: TspDynamicSkinForm;
begin
  MainBSF := Self.DynamicSkinForm;
  if MainBSF = nil then Exit;
  S1 := TMenuItem(Sender).Name;
  S2 := MI_CHILDITEMBAR;
  Delete(S1, Pos(S2, S1), Length(S2));
  for I := 0 to MainBSF.FForm.MDIChildCount - 1 do
    if MainBSF.FForm.MDIChildren[I].Name = S1
    then
      begin
        ChildBSF := GetDynamicSkinFormComponent(MainBSF.FForm.MDIChildren[I]);
        if (ChildBSF <> nil) and (ChildBSF.WindowState = wsMinimized)
        then
          ChildBSF.WindowState := wsNormal;
        MainBSF.FForm.MDIChildren[I].Show;
      end;
end;

procedure TspSkinMDITabsBar.UpdateListMenu;
var
  Item: TMenuItem;
  i: Integer;
begin
  FListMenu.Items.Clear;
  for i := 0 to ObjectList.Count - 1 do
  with TspMDITab(ObjectList.Items[I]) do
  begin
    Item := TMenuItem.Create(Self);
    Item.Name := Child.Name + MI_CHILDITEMBAR;
    Item.Caption := Child.Caption;
    Item.OnClick := MDIItemClick;
    Item.RadioItem := True;
    Item.GroupIndex := 0;
    Item.Checked := Active;
    FListMenu.Items.Add(Item);
  end;
end;

procedure TspSkinMDITabsBar.OnShowListMenu(Sender: TObject);
begin
  UpdateListMenu;
end;

procedure TspSkinMDITabsBar.ShowListButton;
begin
  if FListButton <> nil then Exit;
  FListButton := TspSkinMenuSpeedButton.Create(Self);
  with FListButton do
  begin
    Align := alLeft;
    SkinDataName := 'resizetoolbutton';
    SkinData := Self.SkinData;
    Width := MDITABSBARLISTBUTTONW;
    Parent := Self;
    SkinPopupMenu := FListMenu;
    FDrawStandardArrow := True;
    FArrowType := 4;
    OnShowTrackMenu := OnShowListMenu;
  end;
end;

procedure TspSkinMDITabsBar.HideListButton;
begin
  if FListButton = nil then Exit;
  FListButton.Visible := False;
  FListButton.Free;
  FListButton := nil;
end;

procedure TspSkinMDITabsBar.WMCHECKPARENTBG(var Msg: TWMEraseBkgnd);
begin
  if (FIndex <> -1) and (FSD.MDITabsTransparent)
  then
    RePaint;
end;

procedure TspSkinMDITabsBar.WMMOVE(var Msg: TWMMOVE);
begin
  inherited;
  if (FIndex <> -1) and (FSD.MDITabsTransparent) and
     (Align = alNone)
  then
    RePaint;   
end;

procedure TspSkinMDITabsBar.SetTabKind(Value: TspSkinMDITabKind);
begin
  FTabKind := Value;
  if FIndex <> -1
  then
    begin
      RePaint;
    end;
end;

procedure TspSkinMDITabsBar.Notification(AComponent: TComponent;
                                          Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DSF)
  then DSF := nil;
end;


procedure TspSkinMDITabsBar.CheckActive;
var
  I: Integer;
  F: TCustomForm;
begin
  F := Application.MainForm.ActiveMDIChild;
  if F = nil then Exit;
  for I := 0 to ObjectList.Count - 1 do
  with TspMDITab(ObjectList.Items[I]) do
  begin
    Active := (Child = F);
  end;
  RePaint;
end;

procedure TspSkinMDITabsBar.MouseUp;
var
  I: Integer;
  Tab: TspMDITab;
  R, BR: TRect;
begin
  inherited;

  FDown := False;

  if IsDrag
  then
    begin
      IsDrag := False;
      FDown := False;
      //
      I := GetMoveIndex;
      If (I <> -1) and (I <> DragIndex)
      then
        ObjectList.Move(DragIndex, I);
      //
      DragIndex := -1;
      DX := 0;
      TabDX := 0;
      RePaint;
    end
  else
    if Assigned(FOnTabMouseUp)
    then
      begin
        Tab := GetTab(X, Y);
        if Tab <> nil then FOnTabMouseUp(Button, Shift, Tab);
      end;

  if FShowAddButton
  then
    begin
      if FAddButtonDown and PtInRect(FAddButtonRect, Point(X, Y))
      then
        begin
          FAddButtonDown := False;
          RePaint;
          if Assigned(FOnAddButtonClick) then FOnAddButtonClick(Self);
        end;
     FAddButtonDown := False;
   end;

  if FShowCloseButtons and (Button = mbLeft)
  then
    begin
      Tab := GetTab(X, Y);
      if Tab = nil then Exit;
       with Tab do
       begin
         R := ObjectRect;
         BR := ButtonRect;
         OffsetRect(BR, R.Left, R.Top);
         if PtInRect(BR, Point(X, Y))
         then
           begin
             ButtonMouseIn := True;
             ButtonMouseDown := False;
             Draw(Canvas);
             DoClose(Tab);
           end
         else
         if not PtInRect(BR, Point(X, Y))
         then
           begin
             ButtonMouseIn := False;
             ButtonMouseDown := False;
           end;
     end;
   end;

end;

function TspSkinMDITabsBar.GetMoveIndex;
var
  I: Integer;
  R: TRect;
  X: Integer;
begin
  Result := -1;
  if ObjectList.Count = 0 then Exit;
  if TabDX > 0
  then
    begin
      X := TspMDITab(ObjectList.Items[DragIndex]).ObjectRect.Right;
      if DragIndex + 1 <= ObjectList.Count - 1 then
        for I := DragIndex + 1 to ObjectList.Count - 1 do
        if TspMDITab(ObjectList.Items[I]).Visible then
        begin
          R := TspMDITab(ObjectList.Items[I]).ObjectRect;
          if X > R.Left + RectWidth(R) div 2
          then Result := I;
        end;
    end
  else
  if TabDX < 0
  then
    begin
      X := TspMDITab(ObjectList.Items[DragIndex]).ObjectRect.Left;
      if DragIndex - 1 >= 0 then
      begin
        for i := DragIndex - 1 downto 0 do
        if TspMDITab(ObjectList.Items[I]).Visible then
        begin
          R := TspMDITab(ObjectList.Items[I]).ObjectRect;
          if X < R.Left + RectWidth(R) div 2
          then Result := I;
        end;
      end;
    end;
end;

procedure TspSkinMDITabsBar.MouseMove;
begin
  inherited;
  if FDown and (DragIndex <> -1) and not IsDrag and (X - DX <> 0)
  then
    IsDrag := True;

  if IsDrag
  then
    begin
      TabDX := X - DX;
      RePaint;
    end
  else
    TestActive(X, Y);
end;

procedure TspSkinMDITabsBar.MouseDown;
var
  Tab: TspMDITab;
  ChildBSF: TspDynamicSkinForm;
  BS: TspDynamicSkinForm;
  MI: TMenuItem;
  R, BR: TRect;
  P: TPoint;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      Tab := GetTab(X, Y);
      if Tab <> nil
      then
        begin
          Tab.Child.Show;
          ChildBSF := GetDynamicSkinFormComponent(Tab.Child);
          if (ChildBSF <> nil) and (ChildBSF.WindowState = wsMinimized)
          then
            ChildBSF.WindowState := wsNormal;
          FDown := True;
          if FMoveTabs then DragIndex := GetTabIndex(X, Y);
          DX := X;
          TabDX := 0;
          if (ssDouble in Shift) and FDblClickChildMove
          then
            begin
              if ChildBSF.WindowState = wsNormal
              then
                ChildBSF.FForm.SetBounds(0, 0,
                  ChildBSF.FForm.Width, ChildBSF.FForm.Height);
            end;
          if Assigned(FOnTabMouseDown) then FOnTabMouseDown(Button, Shift, Tab);
        end;
      //
     if (Tab <> nil) and FShowCloseButtons
     then
     with Tab do
     begin
       R := ObjectRect;
       BR := ButtonRect;
       OffsetRect(BR, R.Left, R.Top);
       if PtInRect(BR, Point(X, Y))
       then
         begin
           FDown := False;
           ButtonMouseIn := True;
           ButtonMouseDown := True;
           Draw(Canvas);
         end
       else
       if not PtInRect(BR, Point(X, Y))
       then
         begin
           ButtonMouseIn := False;
           ButtonMouseDown := False;
         end;
     end;
     //
     if FShowAddButton
     then
       begin
         if FAddButtonActive and PtInRect(FAddButtonRect, Point(X, Y))
         then
           begin
             FAddButtonDown := True;
             RePaint;
           end;
       end;
    end
  else
  if Button = mbRight
  then
    begin
      Tab := GetTab(X, Y);
      if Tab <> nil
      then
        begin
          if FSupportChildMenus
          then
            begin
              BS := GetDynamicSkinFormComponent(Tab.Child);
              if (BS <> nil) and (DSF <> nil)
              then
                begin
                  MI := BS.GetSystemMenu;
                  DSF.SkinMenuOpen;
                  P := Point(X, Y);
                  P := ClientToScreen(P);
                  R := Rect(P.X, P.Y, P.X, P.Y);
                  if DSF.MenusSkinData = nil
                  then
                    DSF.SkinMenu.Popup(Parent, DSF.SkinData, 0, R, MI, False)
                  else
                    DSF.SkinMenu.Popup(Parent, DSF.MenusSkinData, 0, R, MI, False);
                end;
            end;
          if Assigned(FOnTabMouseDown) then FOnTabMouseDown(Button, Shift, Tab);
        end;
    end;
end;

procedure TspSkinMDITabsBar.CMMouseLeave;
begin
  inherited;
  TestActive(-1, -1);
end;

function TspSkinMDITabsBar.GetTabIndex;
var
  I: Integer;
  R: TRect;
begin
  Result := -1;
  if ObjectList.Count > 0
  then
    for I := 0 to ObjectList.Count - 1 do
      begin
        R := TspMDITab(ObjectList.Items[I]).ObjectRect;
        if (X >= R.Left) and (X <= R.Right) and
           (Y >= R.Top) and (Y <= R.Bottom) and
           TspMDITab(ObjectList.Items[I]).Visible
        then
          begin
            Result := I;
            Break;
          end;
    end;
end;

function TspSkinMDITabsBar.GetTab;
var
  I: Integer;
begin
  I := GetTabIndex(X, Y);
  if I <> -1
  then
    Result := TspMDITab(ObjectList.Items[I])
  else
    Result := nil;
end;

procedure TspSkinMDITabsBar.TestActive;
var
  Tab: TspMDITab;
  R, BR: TRect;
  I: Integer;
  Update: Boolean;
  CanRePaint: Boolean;
begin
  ActiveTabIndex := GetTabIndex(X, Y);
  Update := False;

  if (ActiveTabIndex <> OldTabIndex)
  then
    begin
      if OldTabIndex <> -1
      then
        with TspMDITab(ObjectList.Items[OldTabIndex]) do
        if Visible then
        begin
          MouseIn := False;
          Draw(Canvas);
          if Assigned(FOnTabMouseLeave)
          then
            FOnTabMouseLeave(TspMDITab(ObjectList.Items[OldTabIndex]));
        end;
      if ActiveTabIndex <> -1
      then
        with TspMDITab(ObjectList.Items[ActiveTabIndex]) do
        if Visible then
        begin
          MouseIn := True;
          Draw(Canvas);
          if Assigned(FOnTabMouseEnter)
          then
            FOnTabMouseEnter(TspMDITab(ObjectList.Items[ActiveTabIndex]));
        end;
      OldTabIndex := ActiveTabIndex;
      Update := True;
    end;

  if (ActiveTabIndex <> -1) and FShowCloseButtons
  then
    with TspMDITab(ObjectList.Items[ActiveTabIndex]) do
    begin
      R := ObjectRect;
      BR := ButtonRect;
      OffsetRect(BR, R.Left, R.Top);
      if PtInRect(BR, Point(X, Y)) and not ButtonMouseIn
      then
        begin
          ButtonMouseIn := True;
          Draw(Canvas);
        end
      else
      if not PtInRect(BR, Point(X, Y)) and ButtonMouseIn
      then
        begin
         ButtonMouseIn := False;
         ButtonMouseDown := False;
         Draw(Canvas);
       end;
   end;

  if FShowCloseButtons and Update
  then
    begin
      CanRePaint := False;
      for I := 0 to ObjectList.Count - 1 do
        if I <> ActiveTabIndex then
        with TspMDITab(ObjectList.Items[I]) do
        if ButtonMouseIn then
        begin
          CanRePaint := True;
          ButtonMouseIn := False;
          ButtonMouseDown := False;
        end;
      if CanRePaint then  RePaint;
    end;

  if FShowAddButton
  then
    begin
      if PtInRect(FAddButtonRect, Point(X, Y)) and not FAddButtonActive
      then
        begin
          FAddButtonActive := True;
          RePaint;
        end
      else
      if not PtInRect(FAddButtonRect, Point(X, Y)) and FAddButtonActive
      then
        begin
          FAddButtonActive := False;
          RePaint;
        end;
    end;
end;

procedure TspSkinMDITabsBar.CalcObjectRects;
var
  I, J, TabW, X: Integer;
  W: Integer;
  FHeight: Integer;
  FTabsWidth: Integer;
begin
  if ObjectList.Count = 0
  then
    begin
      FAddButtonRect.Left := 2;
      FAddButtonRect.Top := Height div 2 - MDITABSBARADDBUTTONW div 2 - 1;
      FAddButtonRect.Right := FAddButtonRect.Left + MDITABSBARADDBUTTONW;
      FAddButtonRect.Bottom := FAddButtonRect.Top + MDITABSBARADDBUTTONW;
      Exit;
    end;
    
  FInVisibleCount := 0;
  FAddButtonRect.Left := 2;
  FTabsWidth := Width;

  if FShowAddButton then Dec(FTabsWidth, MDITABSBARADDBUTTONW + 5);
  W := FTabsWidth - MDITABSBARLISTBUTTONW;

  if TabKind  = sptkTab
  then
    FHeight := Height - FBottomOffset
  else
    FHeight := Height;
  TabW := W div ObjectList.Count;
  if TabW > FDefaultTabWidth
  then
    TabW := FDefaultTabWidth;

  if (TabW < FMinTabWidth) and (FMinTabWidth <> 0)
  then
    begin
      TabW := FMinTabWidth;
      X := MDITABSBARLISTBUTTONW;
      W := FTabsWidth - MDITABSBARLISTBUTTONW * 2;
      J := W div TabW;
      for I := 0 to ObjectList.Count - 1 do
      begin
        if I < J
        then
          begin
            TspMDITab(ObjectList.Items[I]).ObjectRect := Rect(X, 0, X + TabW, FHeight);
            TspMDITab(ObjectList.Items[I]).Visible := True;
            FAddButtonRect.Left := TspMDITab(ObjectList.Items[I]).ObjectRect.Right + 2;
          end
        else
          begin
            Inc(FInVisibleCount);
            TspMDITab(ObjectList.Items[I]).ObjectRect := NullRect;
            TspMDITab(ObjectList.Items[I]).Visible := False;
          end;
        Inc(X, TabW);
      end;
      W := FTabsWidth - MDITABSBARLISTBUTTONW;
    end
  else                                                                                      
    begin
      X := MDITABSBARLISTBUTTONW;
      W := FTabsWidth;
      for I := 0 to ObjectList.Count - 1 do
      begin
        TspMDITab(ObjectList.Items[I]).Visible := True;
        TspMDITab(ObjectList.Items[I]).ObjectRect := Rect(X, 0, X + TabW, FHeight);
        if (I = ObjectList.Count - 1) and (TabW < FDefaultTabWidth) and
        (TspMDITab(ObjectList.Items[I]).ObjectRect.Right <> W)
        then
         TspMDITab(ObjectList.Items[I]).ObjectRect.Right := W;
        Inc(X, TabW);
        FAddButtonRect.Left := TspMDITab(ObjectList.Items[I]).ObjectRect.Right + 2;
      end;
     W := FTabsWidth;
   end;
  //
  FAddButtonRect.Top := Height div 2 - MDITABSBARADDBUTTONW div 2 - 1;
  FAddButtonRect.Right := FAddButtonRect.Left + MDITABSBARADDBUTTONW;
  FAddButtonRect.Bottom := FAddButtonRect.Top + MDITABSBARADDBUTTONW;
  //
  if (DragIndex <> -1) and IsDrag
  then
    with TspMDITab(ObjectList.Items[DragIndex]) do
    begin
      OffsetRect(ObjectRect, TabDX, 0);
      if ObjectRect.Right > W
      then
        OffsetRect(ObjectRect, W - ObjectRect.Right, 0);
      if ObjectRect.Left < 0
      then
        begin
          OffsetRect(ObjectRect, -ObjectRect.Left, 0);
        end;
    end;
end;


procedure TspSkinMDITabsBar.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;

procedure TspSkinMDITabsBar.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinMDITabsBar.GetSkinData;
begin
  inherited;
  //
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinTabControl
    then
      with TspDataSkinTabControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.TabRect := TabRect;
        if IsNullRect(ActiveTabRect)
        then
          Self.ActiveTabRect := TabRect
        else
          Self.ActiveTabRect := ActiveTabRect;
        if IsNullRect(MouseInTabRect)
        then
          Self.MouseInTabRect := TabRect
        else
          Self.MouseInTabRect := MouseInTabRect;
        //
        Self.TabsBGRect := TabsBGRect;
        Self.TabLeftOffset := TabLeftOffset;
        Self.TabRightOffset := TabRightOffset;
        //
        Self.FontName := FontName;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := FocusFontColor;
        Self.MouseInFontColor := MouseInFontColor;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.UpDown := UpDown;
        Self.TabStretchEffect := TabStretchEffect;
        //
        Self.CloseButtonRect := CloseButtonRect;
        Self.ClosebuttonActiveRect := ClosebuttonActiveRect;
        Self.CloseButtonDownRect := CloseButtonDownRect;
        if IsNullRect(ClosebuttonActiveRect)
          then ClosebuttonActiveRect:= CloseButtonRect;
        if IsNullRect(CloseButtonDownRect)
          then ClosebuttonDownRect:= CloseButtonActiveRect;
        //
       Self.ButtonTransparent := ButtonTransparent;
       Self.ButtonTransparentColor := ButtonTransparentColor;
       //
       Self.LTPoint := LTPoint;
       Self.RTPoint := RTPoint;  
       Self.LBPoint := LBPoint;
       Self.RBPoint := RBPoint;
       Self.ClRect := ClRect;
       Self.SkinRect := SkinRect;
       Self.LeftStretch := LeftStretch;
       Self.TopStretch := TopStretch;
       Self.RightStretch := RightStretch;
       Self.BottomStretch := BottomStretch;
       Self.StretchEffect := StretchEffect;
       Self.StretchType := StretchType;
       FBottomOffset := Self.ClRect.Top;
       FActiveTabOffset := RectHeight(Self.ActiveTabRect)- RectHeight(Self.TabRect);
     end;
end;

procedure TspSkinMDITabsBar.ChangeSkinData;
begin
  inherited;
  FCloseSize := GetCloseSize;
  if (FIndex <> -1) and UseSkinSize
  then
    begin
      if TabKind  = sptkTab
      then
        Height := RectHeight(TabRect) + FBottomOffset
      else
        Height := RectHeight(TabRect);
    end
  else
    if FDefaultHeight > 0
    then
      Height := FDefaultHeight;
  if FListButton <> nil then FListButton.SkinData := Self.SkinData;
  if FShowCloseButtons then RePaint;
  ReAlign;
end;

procedure TspSkinMDITabsBar.ClearObjects;
var
  I: Integer;
begin
  if ObjectList.Count > 0
  then
    for I := 0 to ObjectList.Count - 1 do
     TspMDITab(ObjectList.Items[I]).Free;
  ObjectList.Clear;
end;

procedure TspSkinMDITabsBar.AddTab(Child: TCustomForm);
begin
  ObjectList.Add(TspMDITab.Create(Self, Child));
  if FListButton = nil then ShowListButton;
  RePaint;
end;

procedure TspSkinMDITabsBar.DeleteTab(Child: TCustomForm);
var
  I: Integer;
begin
  if (ActiveTabIndex <> -1) and
     (TspMDITab(ObjectList.Items[ActiveTabIndex]).Child = Child)
  then
    begin
      if Assigned(FOnTabMouseLeave)
      then
        FOnTabMouseLeave(TspMDITab(ObjectList.Items[ActiveTabIndex]));
      ActiveTabIndex := -1;
      OldTabIndex := -1;
    end;
  for I := 0 to ObjectList.Count - 1 do
    if TspMDITab(ObjectList.Items[I]).Child = Child
    then
      begin
        TspMDITab(ObjectList.Items[I]).Free;
        ObjectList.Delete(I);
        Break;
      end;
  if (FListButton <> nil) and (ObjectList.Count = 0)  then HideListButton;
  RePaint;
end;

procedure TspSkinMDITabsBar.CreateControlDefaultImage;
var
  I, X: Integer;
  R: TRect;
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, B.Width, B.Height));
  end;
  //
  CalcObjectRects;
  //
  if FShowAddButton then DrawAddButton(B.Canvas);
  //
  if ObjectList.Count > 0
  then
    begin
      for I := 0 to ObjectList.Count - 1 do
        if (I <> DragIndex) or not FDown
        then
          begin
            if TspMDITab(ObjectList.Items[I]).Visible
            then
              TspMDITab(ObjectList.Items[I]).Draw(B.Canvas);
          end;
      if (DragIndex <> -1) and IsDrag
      then
        begin
          TspMDITab(ObjectList.Items[DragIndex]).Draw(B.Canvas);
          I := Self.GetMoveIndex;
          if I <> -1
          then
            begin
              R := TspMDITab(ObjectList.Items[I]).ObjectRect;
              with B.Canvas do
              begin
                Pen.Mode := pmNot;
                Brush.Style := bsClear;
                if TabDX > 0
                then
                  X := R.Right
                else
                  X := R.Left;
                MoveTo(X, 0); LineTo(X, Height);
                MoveTo(X + 1, 0); LineTo(X + 1, Height);
                MoveTo(X - 1, 0); LineTo(X - 1, Height);
                MoveTo(X + 2, Height div 2);
                LineTo(X + 5, Height div 2 - 3);
                LineTo(X + 5, Height div 2 + 3);
                LineTo(X + 2, Height div 2);
                MoveTo(X - 2, Height div 2);
                LineTo(X - 5, Height div 2 - 3);
                LineTo(X - 5, Height div 2 + 3);
                LineTo(X - 2, Height div 2);
              end;
            end;
        end;
    end;
end;

procedure TspSkinMDITabsBar.CreateControlSkinImage;
var
  I: Integer;
  rw, rh, w, h, XCnt, X, Y, XO, YO: Integer;
  R, R1, R2: TRect;
  Buffer: TBitMap;
  LO, RO: Integer;
begin
  w := RectWidth(TabsBGRect);
  h := RectHeight(TabsBGRect);
  rw := B.Width;
  rh := B.Height;
  XCnt := rw div w;
  if SkinData.MDITabsTransparent
  then
    begin
       GetParentImage(Self, B.Canvas);
     end
  else
  begin
    Buffer := TBitmap.Create;
    Buffer.Width := RectWidth(TabRect);
    Buffer.Height := RectHeight(TabRect);
    Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
       Picture.Canvas, TabsBGRect);
    for X := 0 to XCnt do
    begin
      if TabKind = sptkTab
      then
        R1 := Rect(X * w, 0, X * w + w, B.Height - FBottomOffset)
      else
        R1 := Rect(X * w, 0, X * w + w, B.Height);
       B.Canvas.StretchDraw(R1, Buffer);
     end;
    Buffer.Free;
  end;

  if (TabKind = sptkTab) and not IsNullRect(SkinRect)
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := B.Width;
      Buffer.Height := FBottomOffset;
      LO := LTPoint.X;
      RO := RectWidth(SkinRect) - RTPoint.X;
      R1 := Classes.Rect(SkinRect.Left + LO, SkinRect.Top,
      SkinRect.Right - RO, SkinRect.Top + ClRect.Top);
      CreateHSkinImage(LO, RO, Buffer, Picture, R1, Buffer.Width, Buffer.Height, TopStretch);
      B.Canvas.Draw(0, B.Height - FBottomOffset, Buffer);
      Buffer.Free;
    end;
  //
  CalcObjectRects;
  //
  if FShowAddButton then DrawAddButton(B.Canvas);
  //
  if ObjectList.Count > 0
  then
    begin
      for I := 0 to ObjectList.Count - 1 do
        if (I <> DragIndex) or not FDown
        then
          begin
            if TspMDITab(ObjectList.Items[I]).Visible
            then
              TspMDITab(ObjectList.Items[I]).Draw(B.Canvas);
          end;
      if (DragIndex <> -1) and IsDrag
      then
        begin
          TspMDITab(ObjectList.Items[DragIndex]).Draw(B.Canvas);
          I := Self.GetMoveIndex;
          if I <> -1
          then
            begin
              R := TspMDITab(ObjectList.Items[I]).ObjectRect;
              with B.Canvas do
              begin
                Pen.Mode := pmNot;
                Brush.Style := bsClear;
                if TabDX > 0
                then
                  X := R.Right
                else
                  X := R.Left;
                MoveTo(X, 0); LineTo(X, Height);
                MoveTo(X + 1, 0); LineTo(X + 1, Height);
                MoveTo(X - 1, 0); LineTo(X - 1, Height);
                MoveTo(X + 2, Height div 2);
                LineTo(X + 5, Height div 2 - 3);
                LineTo(X + 5, Height div 2 + 3);
                LineTo(X + 2, Height div 2);
                MoveTo(X - 2, Height div 2);
                LineTo(X - 5, Height div 2 - 3);
                LineTo(X - 5, Height div 2 + 3);
                LineTo(X - 2, Height div 2);
              end;
            end;
        end;
    end;
end;



type
  TspFrame = class(TFrame);

constructor TspSkinFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawBackground := True;
  FCtrlsSkinData := nil;
  if AOwner is TFrame
  then
    begin
      FFrame := TFrame(AOwner);
      FFrame.AutoScroll := False;
      FFrame.AutoSize := False;
    end
  else
    FFrame := nil;
  if (FFrame <> nil) and not (csDesigning in ComponentState)
  then
    begin
      OldWindowProc := FFrame.WindowProc;
      FFrame.WindowProc := NewWndProc;
    end;
end;

destructor TspSkinFrame.Destroy;
begin
  if not (csDesigning in ComponentState) and (FFrame <> nil)
  then
    FFrame.WindowProc := OldWindowProc;
  inherited;
end;

procedure TspSkinFrame.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FCtrlsSkinData)
  then
    FCtrlsSkinData := nil;
end;

procedure TspSkinFrame.SetCtrlsSkinData(Value: TspSkinData);
begin
  FCtrlsSkinData := Value;
  if not (csDesigning in ComponentState) and (FFrame <> nil)
   then
    UpdateSkinCtrls(TWinControl(FFrame));
end;

procedure TspSkinFrame.UpdateSkinCtrls;

procedure CheckControl(C: TControl);
var
  i: Integer;
begin
  if C is TspSkinControl
  then
    begin
      with TspSkinControl(C) do
        SkinData := Self.CtrlsSkinData;
    end
  else
  if C is TspGraphicSkinControl
  then
    begin
      with TspGraphicSkinControl(C) do
        SkinData := Self.CtrlsSkinData;
    end
  else
  if C is TspSkinPageControl
    then
      begin
        with TspSkinPageControl(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinTabControl
    then
      begin
        with TspSkinTabControl(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinCustomEdit
    then
      begin
        with TspSkinEdit(C) do
         SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinMemo
    then
      begin
        with TspSkinMemo(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinMemo2
    then
      begin
        with TspSkinMemo2(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinStdLabel
    then
      begin
        with TspSkinStdLabel(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinLinkLabel
    then
      begin
        with TspSkinLinkLabel(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinButtonLabel
    then
      begin
        with TspSkinButtonLabel(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinTextLabel
    then
      begin
        with TspSkinTextLabel(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinCustomTreeView
    then
      begin
        with TspSkinTreeView(C) do
         SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinBevel
    then
      begin
        with TspSkinBevel(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinCustomListView
    then
      begin
        with TspSkinListView(C) do
          SkinData := Self.CtrlsSkinData;
      end
     else
    if C is TspSkinHeaderControl
    then
      begin
        with TspSkinHeaderControl(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinRichEdit
    then
      begin
        with TspSkinRichEdit(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinControlBar
    then
      begin
        with TspSkinControlBar(C) do
         SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinCoolBar
    then
      begin
        with TspSkinCoolBar(C) do
          SkinData := Self.CtrlsSkinData;
      end
    else
    if C is TspSkinSplitter
    then
      begin
        with TspSkinSplitter(C) do
          SkinData := Self.CtrlsSkinData;
      end;
end;

var
  i: Integer;
begin
  for i := 0 to WC.ComponentCount - 1 do
  begin
    if WC.Components[i] is TControl
    then
      CheckControl(TControl(WC.Components[i]));
  end;
end;

procedure TspSkinFrame.NewWndProc(var Message: TMessage);
var
  FOld: Boolean;
  PS: TPaintStruct;
  DC: HDC;
  i: Integer;
begin
  FOld := True;
  //
  if FFrame <> nil then
  case Message.Msg of
     CM_CANCELMODE:
     begin
       for i := 0 to FFrame.ControlCount - 1 do
       begin
         FFrame.Controls[i].Perform(CM_CANCELMODE, 0, Longint(nil));
       end;
    end;

    WM_ERASEBKGND:
      begin
        if FDrawBackground
        then
          PaintBG(TWMERASEBKGND(Message).DC);
        FOld := False;
      end;
  end;
  //
  if FOld then OldWindowProc(Message);
  //
  case Message.Msg of
    WM_SIZE:
      if (FSkinData <> nil) and FSkinData.StretchEffect
      then
        begin
          FFrame.RePaint;
          CheckControlsBackground;
        end;
  end;
end;

procedure TspSkinFrame.PaintBG(DC: HDC);

procedure PaintBGDefault;
var
  C: TCanvas;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  with C do
  begin
    Brush.Color := clBtnFace;
    FillRect(FFrame.ClientRect);
  end;
  C.Free;
end;

procedure PaintSkinBG;
var
  C: TCanvas;
  X, Y, XCnt, YCnt, w, h, rw, rh: Integer;
  R: TRect;
  BGImage, Buffer2: TBitMap;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  if IsNullRect(FSkinData.ClRect)
  then
    begin
      with C do
      begin
        Brush.Color := clBtnFace;
        R := FFrame.ClientRect;
        FillRect(R);
      end;
      C.Free;
      Exit;
    end;

  BGImage := TBitMap.Create;
  BGImage.Width := RectWidth(FSkinData.ClRect);
  BGImage.Height := RectHeight(FSkinData.ClRect);
  BGImage.Canvas.CopyRect(Rect(0, 0, BGImage.Width, BGImage.Height),
    FSkinData.FPicture.Canvas, Rect(FSkinData.ClRect.Left, FSkinData.ClRect.Top,
                              FSkinData.ClRect.Right, FSkinData.ClRect.Bottom));
   if FSkinData.StretchEffect and (FFrame.ClientWidth > 0) and (FFrame.ClientHeight > 0)
   then
     begin
       case FSkinData.StretchType of
         spstFull:
           begin
             C.StretchDraw(Rect(0, 0, FFrame.ClientWidth, FFrame.ClientHeight), BGImage);
           end;
         spstVert:
           begin
             Buffer2 := TBitMap.Create;
             Buffer2.Width := FFrame.ClientWidth;
             Buffer2.Height := BGImage.Height;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
             YCnt := FFrame.ClientHeight div Buffer2.Height;
             for Y := 0 to YCnt do
               C.Draw(0, Y * Buffer2.Height, Buffer2);
             Buffer2.Free;
           end;
         spstHorz:
           begin
             Buffer2 := TBitMap.Create;
             Buffer2.Width := BGImage.Width;
             Buffer2.Height := FFrame.ClientHeight;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
             XCnt := FFrame.ClientWidth div Buffer2.Width;
             for X := 0 to XCnt do
               C.Draw(X * Buffer2.Width, 0, Buffer2);
             Buffer2.Free;
           end;
        end;
      end
    else
      if (FFrame.ClientWidth > 0) and (FFrame.ClientHeight > 0)
      then
        begin
          w := RectWidth(FSkinData.ClRect);
          h := RectHeight(FSkinData.ClRect);
          rw := FFrame.ClientWidth;
          rh := FFrame.ClientHeight;
          XCnt := rw div w;
          YCnt := rh div h;
          for X := 0 to XCnt do
          for Y := 0 to YCnt do
           C.Draw(X * w, Y * h, BGImage);
        end;
  BGImage.Free;
  C.Free;
end;


procedure PaintSkinBG2;
var
  C: TCanvas;
  X, Y, XCnt, YCnt: Integer;
  BGImage, Buffer2: TBitMap;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  BGImage := TBitMap(FSkinData.FActivePictures.Items[FSkinData.BGPictureIndex]);
  if FSkinData.StretchEffect and (FFrame.ClientWidth > 0) and (FFrame.ClientHeight > 0)
  then
    begin
      case FSkinData.StretchType of
        spstFull:
          begin
            C.StretchDraw(Rect(0, 0, FFrame.ClientWidth, FFrame.ClientHeight), BGImage);
          end;
        spstVert:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := FFrame.ClientWidth;
            Buffer2.Height := BGImage.Height;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
            YCnt := FFrame.ClientHeight div Buffer2.Height;
            for Y := 0 to YCnt do
              C.Draw(0, Y * Buffer2.Height, Buffer2);
            Buffer2.Free;
          end;
        spstHorz:
          begin
            Buffer2 := TBitMap.Create;
            Buffer2.Width := BGImage.Width;
            Buffer2.Height := FFrame.ClientHeight;
            Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), BGImage);
            XCnt := FFrame.ClientWidth div Buffer2.Width;
            for X := 0 to XCnt do
              C.Draw(X * Buffer2.Width, 0, Buffer2);
            Buffer2.Free;
          end;
       end;
     end
  else
  if (FFrame.ClientWidth > 0) and (FFrame.ClientHeight > 0)
  then
    begin
      XCnt := FFrame.ClientWidth div BGImage.Width;
      YCnt := FFrame.ClientHeight div BGImage.Height;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        C.Draw(X * BGImage.Width, Y * BGImage.Height, BGImage);
    end;
  C.Free;
end;

begin
  if DC = 0 then Exit;
  if (FSkinData <> nil) and not (FSkinData.Empty)
  then
    begin
      if FSkinData.BGPictureIndex = -1
      then
        PaintSkinBG
      else
        PaintSkinBG2;
    end
  else
    PaintBGDefault;
end;

procedure TspSkinFrame.ChangeSkinData;
begin
  inherited;
  if not (csDesigning in ComponentState) and (FFrame <> nil)
  then
    FFrame.Invalidate;
end;

procedure TspSkinFrame.CheckControlsBackground;
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TWinControl
    then
      SendMessage(TWinControl(Components[i]).Handle, WM_CHECKPARENTBG, 0, 0);
  end;
end;

// TspFormLayer ================================================================

constructor TspFormLayerWindow.CreateEx;
begin
  inherited CreateNew(AOwner);
  FLayerBorder := TspFormLayerBorder(AOwner);
  FInProcessMessages := False;
  FForm := AForm;
  Parent := nil;
  Visible := False;
  BorderStyle := bsNone;
  if AForm.FormStyle = fsStayOnTop then FormStyle := fsStayOnTop else FormStyle := fsNormal;
  if IsNullRect(FLayerBorder.FData.BorderRect)
  then
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TRANSPARENT)
  else
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  FDown := False;
  MousePos1 := Point(0, 0);
  MousePos2 := Point(0, 0);
end;

procedure TspFormLayerWindow.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FLayerBorder.FData.FullBorder
  then
    begin
      FLayerBorder.MouseTimer.Enabled := False;
      FLayerBorder.TestActive(-1, -1);
    end;  
end;

procedure TspFormLayerWindow.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if FLayerBorder.FData.FullBorder then FLayerBorder.MouseTimer.Enabled := True;
end;

function TspFormLayerWindow.CanChangeSize: Boolean;
begin
  Result := FLayerBorder.DSF.IsSizeAble; 
  if FLayerBorder.DSF.RollUpState then Result := False;
  if FLayerBorder.DSF.WindowState <> wsNormal then Result := False;
end;

procedure TspFormLayerWindow.WMLBUTTONDBLCLK;
var
  HitMode: TspFormLayerBorderHit;
begin
  if FLayerBorder.FData.FullBorder then begin

  HitMode := GetHitMode(LoWord(Message.LParam), HiWord(Message.LParam));

  if (HitMode = spflCaption) and (FLayerBorder.ActiveObject <> -1) and
     (TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) is
      TspSkinCaptionObject)
  then
    with TspSkinCaptionObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) do
    begin
      if ActiveQuickButton <> -1 then HitMode := spflObject;
      if ActiveTab <> -1 then HitMode := spflObject;
    end;

  MousePos1 := MousePos2;

  if (HitMode = spflObject) and (FLayerBorder.ActiveObject <> -1) and
     (TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) is TspSkinStdButtonObject) and
     (TspSkinStdButtonObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]).Command = cmSysMenu)
  then
    with TspSkinStdButtonObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) do
    begin
      DoClose;
    end;

  if HitMode = spflCaption then
  begin
    with FLayerBorder.DSF do
    begin
      if FSizeAble and (WindowState = wsMinimized)
      then
         begin
           WindowState := wsNormal;
         end
       else
       if FSizeAble and (WindowState <> wsMaximized) and not FRollUpState and
         (biMaximize in BorderIcons)
       then
         begin
           WindowState := wsMaximized;
           FDown := False;
         end
       else
       if FSizeAble and (WindowState = wsMaximized) and not MaxRollUpState
       then
         begin
           WindowState := wsNormal;
           FDown := False;
         end
        else
          begin
            if FRollUpState
            then
              RollUpState := False
            else
              RollUpState := True;
         end;
    end;
    inherited;
  end
  else
    inherited;
  end
  else
    inherited;
  FLayerBorder.MouseCaptureObject := -1;
end;

function TspFormLayerWindow.GetHitMode;
var
  P: TPoint;
  Offset1, Offset2: Integer;
  R1, R2, R3, R4, R5: TRect;
  NewCapRect: TRect;
  OffsetX, i: Integer;
begin

  GetCursorPos(P);

  Result := spflhNone;

  NewCapRect := FLayerBorder.FData.CaptionRect;
  OffsetX := FLayerBorder.FForm.Width - RectWidth(FLayerBorder.FData.ClRect);

  NewCapRect.Right := NewCapRect.Right + OffsetX;
  NewCapRect.Top := FLayerBorder.FData.BorderRect.Top + FLayerBorder.FData.HitTestSize;

  OffsetRect(NewCapRect, Self.Left, Self.Top);

  if FLayerBorder.FData.FullBorder and (BorderType = spflTop)
  then
    FLayerBorder.TestActive(HX, HY)
  else
  if not FLayerBorder.FData.FullBorder then FLayerBorder.ActiveObject := -1;

  if FLayerBorder.ActiveObject <> -1
  then
    begin
      if TspActiveSkinObject(FLayerBorder.DSF.ObjectList[FLayerBorder.ActiveObject]) is TspSkinCaptionObject
      then
        begin
          if FLayerBorder.DSF.NCDraggAble
          then
            Result := spflCaption
          else
            Result := spflhNone;
        end
      else
        Result := spflObject;
     end
  else
  if not CanChangeSize 
  then
    begin
      Result := spflhNone;
    end
  else
  with FLayerBorder do
  case BorderType of
    spflTop:
      begin
        R1 := Rect(FForm.Left - LeftSize, FForm.Top - TopSize,
                   FForm.Left - LeftSize + HitTopLeftX, FForm.Top - TopSize +  + HitTopLeftY);

        R3 := Rect(FForm.Left + FForm.Width + RightSize - HitTopRightX,
                   FForm.Top - TopSize,
                   FForm.Left + FForm.Width + RightSize,
                   FForm.Top - TopSize + HitTopRightY);

        R2 := Rect(R1.Right, R1.Top, R3.Left, R1.Top + FData.HitTestSize);

        R4 := Rect(R1.Left, R1.Bottom, R1.Left + FData.HitTestSize, Self.Top + Self.Height);

        R5 := Rect(R3.Left, R3.Bottom, R3.Right, Self.Top + Self.Height);

        Result := spflhNone;

        if PtInRect(R1, P) and not PtInRect(NewCapRect, P) then Result := spflhTopLeft else
        if PtInRect(R2, P) then Result := spflhTop else
        if PtInRect(R3, P) and not PtInRect(NewCapRect, P) then Result := spflhTopRight else
        if PtInRect(R4, P) and not PtInRect(NewCapRect, P) then Result := spflhLeft else
        if PtInRect(R5, P) and not PtInRect(NewCapRect, P) then Result := spflhRight;

      end;
      
    spflBottom:
      begin
        R1 := Rect(FForm.Left - LeftSize, FForm.Top +  FForm.Height + BottomSize - HitBottomLeftY,
                   FForm.Left - LeftSize + HitBottomLeftX, FForm.Top +  FForm.Height + BottomSize);

        R3 := Rect(FForm.Left + FForm.Width + RightSize - HitBottomRightX,
                   FForm.Top +  FForm.Height + BottomSize - HitBottomRightY,
                   FForm.Left + FForm.Width + RightSize,
                   FForm.Top +  FForm.Height + BottomSize);


        R2 := Rect(R1.Right, R1.Top, R3.Left, FForm.Top +  FForm.Height + BottomSize);

        R4 := Rect(R1.Left, Self.Top, FForm.Left, R1.Top);

        R5 := Rect(FForm.Left + FForm.Width, Self.Top,
                   FForm.Left + FForm.Width + RightSize, R3.Top);


        if PtInRect(R1, P) then Result := spflhBottomLeft else
        if PtInRect(R2, P) then Result := spflhBottom else
        if PtInRect(R3, P) then Result := spflhBottomRight else
        if PtInRect(R4, P) then Result := spflhLeft else
        if PtInRect(R5, P) then Result := spflhRight;

      end;
     spflLeft:
      begin
        if P.X >= FForm.Left - LeftSize then Result := spflhLeft;
      end;
    spflRight:
      begin
        if P.X <= FForm.Left + FForm.Width + RightSize then Result := spflhRight;
      end;
  end;
end;

procedure TspFormLayerWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
     X, Y: Integer);
var
  P: TPoint;
  TempHitMode: TspFormLayerBorderHit;
begin
  inherited;
  //
  if FLayerBorder.DSF.SkinMenu.Visible then FLayerBorder.DSF.SkinMenu.Hide;
  if FLayerBorder.DSF.FForm.ActiveControl <> nil
  then
    begin
      SendMessage(FLayerBorder.DSF.FForm.ActiveControl.Handle, CM_CANCELMODE, 0, 0);
    end;
  //
  TempHitMode := GetHitMode(X, Y);
  //
  if not FLayerBorder.FData.HitTestEnable or
  (not CanChangeSize and (TempHitMode <> spflCaption) and (TempHitMode <> spflObject))
  then
    Exit;
  //
  FInProcessMessages := False;

  FDown := (GetHitMode(X, Y) <> spflObject) and (GetHitMode(X, Y) <> spflhNone) and
           not (FLayerBorder.DSF.WindowState = wsMaximized) and (Button = mbLeft);

  GetCursorPos(P);
  MousePos1 := P;
  MousePos2 := P;
  if FLayerBorder.FData.FullBorder and (FLayerBorder.ActiveObject <> -1)
  then
    with TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) do
    begin
      MouseDown(X, Y, Button);
      if (TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) is TspSkinCaptionObject) and
         ((TspSkinCaptionObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]).ActiveQuickButton <> -1) or
          (TspSkinCaptionObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]).ActiveTab <> -1))
      then
        FDown := False;
      FLayerBorder.MouseCaptureObject := FLayerBorder.ActiveObject;
      if (FLayerBorder.DSF.FLayerManager.IsVisible) and (FLayerBorder.DSF.FForm.FormStyle = fsStayOnTop)
      then
        FLayerBorder.DSF.FLayerManager.Update;
    end;
end;

procedure TspFormLayerWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
     X, Y: Integer);
begin
  inherited;
  FLayerBorder.DSF.FBorderLayerChangeSize := False;
  FDown := False;
  FInProcessMessages := False;

  MousePos1 := Point(0, 0);
  MousePos2 := Point(0, 0);

  if FLayerBorder.FData.FullBorder and (FLayerBorder.MouseCaptureObject <> -1) and
     (FLayerBorder.MouseCaptureObject <> FLayerBorder.ActiveObject)
  then
    with TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.MouseCaptureObject]) do
    begin
      MouseUp(X, Y, Button);
    end;

  FLayerBorder.MouseCaptureObject := -1;

  //
  if not FLayerBorder.FData.HitTestEnable or
  (not CanChangeSize and (FHitMode <> spflCaption) and (FHitMode <> spflObject))
  then
    begin
      Exit;
    end;
  //

  if FLayerBorder.FData.FullBorder and (FLayerBorder.ActiveObject <> -1)
  then
    with TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) do
    begin
      MouseUp(X, Y, Button);
    end;
end;

procedure TspFormLayerWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OffsetX, OffsetY: Integer;
  X1, Y1, W, H, L, T, FOldFormHeight: Integer;
  OL, OT: Integer;
  ChangeX, ChangeY: Boolean;
begin

  if FInProcessMessages
  then
    begin
      FInProcessMessages := False;
      MousePos1 := MousePos2;
      Exit;
    end;

  inherited;

  if not FLayerBorder.FData.HitTestEnable then Exit;

  GetCursorPos(MousePos2);

  OffsetX := MousePos2.X - MousePos1.X;
  OffsetY := MousePos2.Y - MousePos1.Y;

  if not FDown
  then
  begin
    if FLayerBorder.DSF.FBorderLayerChangeSize
    then
      FLayerBorder.DSF.FBorderLayerChangeSize := False;

    FHitMode := GetHitMode(X, Y);

    case FHitMode of
      spflhNone, spflCaption, spflObject: Cursor := crDefault;
      spflhLeft: Cursor := crSizeWE;
      spflhTop:  Cursor := crSizeNS;
      spflhRight: Cursor := crSizeWE;
      spflhBottom: Cursor := crSizeNS;
      spflhTopLeft: Cursor := crSizeNWSE;
      spflhTopRight: Cursor := crSizeNESW;
      spflhBottomLeft: Cursor := crSizeNESW;
      spflhBottomRight: Cursor := crSizeNWSE;
    end;

    if FLayerBorder.FData.FullBorder and (FLayerBorder.ActiveObject <> -1)
    then
      with TspActiveSkinObject(FLayerBorder.DSF.ObjectList.Items[FLayerBorder.ActiveObject]) do
      begin
        MouseMove(X, Y);
      end;
  end
  else
  begin
    FLayerBorder.DSF.FBorderLayerChangeSize := True;
    case FHitMode of
    spflCaption:
      begin

        L := FForm.Left + OffsetX;
        T := FForm.Top + OffsetY;
        OL := L;
        OT := T; 

        if FLayerBorder.DSF.Magnetic and ((OffsetX <> 0) or (OffsetY <> 0))
        then
          begin
            if not FLayerBorder.DSF.IsNullHeight
            then
              FLayerBorder.DSF.DoMagnetic(L, T, FForm.Width, FForm.Height)
            else
              FLayerBorder.DSF.DoMagnetic(L, T, FForm.Width, FLayerBorder.FData.RollUpFormHeight);
            MousePos1 := MousePos2;
          end;

        FInProcessMessages := True;

        if ((OL <> L) or (OT <> T)) and FLayerBorder.DSF.Magnetic
        then
          begin
           if ((OffsetX > 0) and (L > OL)) or
              ((OffsetX < 0) and (L < OL)) or
              ((OffsetY > 0) and (T > OT)) or
              ((OffsetY < 0) and (T < OT))
            then
              begin
                if OffsetY > 0 then FLayerBorder.MoveWithForm2(L, T);
                FForm.SetBounds(L, T, FForm.Width, FForm.Height);
              end;
          end
        else
          begin
            if OffsetY > 0 then FLayerBorder.MoveWithForm2(L, T);
            FForm.SetBounds(L, T, FForm.Width, FForm.Height);
          end; 

        FLayerBorder.MoveWithForm;

        Application.ProcessMessages;

        FInProcessMessages := False;

        MousePos1 := MousePos2;
      end;
    spflhLeft:
      begin
        W := FForm.Width - OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        if (FForm.Left + OffsetX + W = FForm.Left + FForm.Width) and (OffsetX <> 0) and
           (W <> FForm.Width) and
           (((OffsetX < 0) and (MousePos2.X <= FForm.Left - FLayerBorder.LeftSize + FLayerBorder.FData.HitTestSize))
           or (OffsetX >= 0))
        then
          begin
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left + OffsetX, FForm.Top, W, FForm.Height);
            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;
      end;

    spflhTop:
      begin
        H := FForm.Height - OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;
        if (FForm.Top + OffsetY + H = FForm.Top + FForm.Height) and (OffsetY <> 0)
            and (H <> FForm.Height) and
           (((OffsetY < 0) and (MousePos2.Y <= FForm.Top - FLayerBorder.TopSize + FLayerBorder.FData.HitTestSize))
           or (OffsetY >= 0))
        then
          begin
            FOldFormHeight := FForm.Height;

            if OffsetY > 0 then FLayerBorder.MoveWithForm2(FForm.Left, FForm.Top + OffsetY);
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left, FForm.Top + OffsetY, FForm.Width, H);

            if FOldFormHeight = FForm.Height then FLayerBorder.MoveWithForm;

            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
            FOldFormHeight := FForm.Height;
          end;
      end;

    spflhRight:
      begin
        W := FForm.Width + OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        if (OffsetX <> 0) and (FForm.Width <> W) and
           (((OffsetX > 0) and (MousePos2.X >= FForm.Left + FForm.Width + FLayerBorder.RightSize - FLayerBorder.FData.HitTestSize))
           or (OffsetX <= 0))
        then
          begin
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left, FForm.Top, W, FForm.Height);
            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;
      end;

    spflhBottom:
      begin
        H := FForm.Height + OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;
        if (OffsetY <> 0) and (H <> FForm.Height) and
           (((OffsetY > 0) and (MousePos2.Y >= FForm.Top + FForm.Height + FLayerBorder.BottomSize - FLayerBorder.FData.HitTestSize))
           or (OffsetY <= 0))
        then
          begin
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left, FForm.Top, FForm.Width, H);
            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;  
      end;

    spflhTopLeft:
      begin
        W := FForm.Width - OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        H := FForm.Height - OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;

        ChangeX := (((OffsetX < 0) and (MousePos2.X <= FForm.Left - FLayerBorder.LeftSize + FLayerBorder.FData.HitTestSize))
           or (OffsetX > 0));

        ChangeY := (((OffsetY < 0) and (MousePos2.Y <= FForm.Top - FLayerBorder.TopSize + FLayerBorder.FData.HitTestSize))
           or (OffsetY >= 0));

        if not ChangeX
        then
          begin
            W := FForm.Width;
            OffsetX := 0;
          end;

        if not ChangeY
        then
          begin
            H := FForm.Height;
            OffsetY := 0;
          end;

        if (FForm.Left + OffsetX + W = FForm.Left + FForm.Width) and
           (FForm.Top + OffsetY + H = FForm.Top + FForm.Height) and
           ((W <> FForm.Height) or (H <> FForm.Height)) and ((OffsetX <> 0) or (OffsetY <> 0))
        then
          begin
            FOldFormHeight := FForm.Height;

            if OffsetY > 0 then FLayerBorder.MoveWithForm2(FForm.Left + OffsetX, FForm.Top + OffsetY);
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left + OffsetX, FForm.Top + OffsetY, W, H);

            if FOldFormHeight = FForm.Height then FLayerBorder.MoveWithForm;

            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;
      end;

    spflhTopRight:
      begin
        W := FForm.Width + OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        H := FForm.Height - OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;

        ChangeX := (((OffsetX > 0) and (MousePos2.X >= FForm.Left + FForm.Width + FLayerBorder.RightSize - FLayerBorder.FData.HitTestSize))
           or (OffsetX <= 0));

        ChangeY := (((OffsetY < 0) and (MousePos2.Y <= FForm.Top - FLayerBorder.TopSize + FLayerBorder.FData.HitTestSize))
           or (OffsetY >= 0));

        if not ChangeX
        then
          begin
            W := FForm.Width;
            OffsetX := 0;
          end;

        if not ChangeY
        then
          begin
            H := FForm.Height;
            OffsetY := 0;
          end;
          
        if (FForm.Top + OffsetY + H = FForm.Top + FForm.Height) and
           ((W <> FForm.Height) or (H <> FForm.Height)) and ((OffsetX <> 0) or (OffsetY <> 0))
        then
          begin
            FOldFormHeight := FForm.Height;

            if OffsetY > 0 then FLayerBorder.MoveWithForm2(FForm.Left, FForm.Top + OffsetY);
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left, FForm.Top + OffsetY, W, H);

            if FOldFormHeight = FForm.Height then FLayerBorder.MoveWithForm;

            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;  
      end;
      
    spflhBottomLeft:
      begin
        W := FForm.Width - OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        H := FForm.Height + OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;

        ChangeX := (((OffsetX < 0) and (MousePos2.X <= FForm.Left - FLayerBorder.LeftSize + FLayerBorder.FData.HitTestSize))
           or (OffsetX > 0));

        ChangeY := (((OffsetY > 0) and (MousePos2.Y >= FForm.Top + FForm.Height + FLayerBorder.BottomSize - FLayerBorder.FData.HitTestSize))
           or (OffsetY <= 0));

        if not ChangeX
        then
          begin
            W := FForm.Width;
            OffsetX := 0;
          end;

        if not ChangeY
        then
          begin
            H := FForm.Height;
            OffsetY := 0;
          end;


        if (FForm.Left + OffsetX + W = FForm.Left + FForm.Width) and
           ((W <> FForm.Height) or (H <> FForm.Height)) and ((OffsetX <> 0) or (OffsetY <> 0))
        then
          begin
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left + OffsetX, FForm.Top, W, H);
            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;  
      end;
      
    spflhBottomRight:
      begin
        W := FForm.Width + OffsetX;
        if W < FLayerBorder.DSF.GetMinWidth then W := FLayerBorder.DSF.GetMinWidth;
        if W > FLayerBorder.DSF.GetMaxWidth then W :=  FLayerBorder.DSF.GetMaxWidth;
        H := FForm.Height + OffsetY;
        if H < FLayerBorder.DSF.GetMinHeight then H := FLayerBorder.DSF.GetMinHeight;
        if H > FLayerBorder.DSF.GetMaxHeight then H :=  FLayerBorder.DSF.GetMaxHeight;

        ChangeX := (((OffsetX > 0) and (MousePos2.X >= FForm.Left + FForm.Width + FLayerBorder.RightSize - FLayerBorder.FData.HitTestSize))
           or (OffsetX < 0));

        ChangeY := (((OffsetY > 0) and (MousePos2.Y >= FForm.Top + FForm.Height + FLayerBorder.BottomSize - FLayerBorder.FData.HitTestSize))
           or (OffsetY <= 0));

        if not ChangeX
        then
          begin
            W := FForm.Width;
            OffsetX := 0;
          end;  

        if not ChangeY
        then
          begin
            H := FForm.Height;
            OffsetY := 0;
          end;

        if ((W <> FForm.Height) or (H <> FForm.Height)) and ((OffsetX <> 0) or (OffsetY <> 0))
        then
          begin
            RedrawWindow(FForm.Handle, nil, 0, RDW_ALLCHILDREN + RDW_UPDATENOW);
            FForm.SetBounds(FForm.Left, FForm.Top, W, H);
            MousePos1 := MousePos2;
            FInProcessMessages := True;
            Application.ProcessMessages;
            FInProcessMessages := False;
          end;
      end;
  end;
  end;
  MousePos1 := MousePos2;
end;


procedure TspFormLayerWindow.WMSETFOCUS(var Message: TMessage); 
begin
  if not FForm.Active then FForm.Show;
  Message.Result := 1;
end;

procedure TspFormLayerWindow.WMMouseActivate(var Message: TMessage);
var
  P: TPoint;
begin
  Message.Result := MA_NOACTIVATE;
  if FLayerBorder.FData.HitTestEnable and not FForm.Active then FForm.Show;
  if FLayerBorder.FData.HitTestEnable
  then
    begin
      GetCursorPos(P);
      P := Self.ScreenToClient(P);
      FHitMode := GetHitMode(P.X, P.Y);
    end;
end;

constructor TspFormLayerBorder.Create(AOwner: TComponent);
begin
  inherited;
  DSF := TspDynamicSkinForm(AOwner);
  MouseTimer := TTimer.Create(Self);
  MouseTimer.Enabled := False;
  MouseTimer.Interval := 500;
  MouseTimer.OnTimer := CheckMouse;
  FWidth := 0;
  FHeight := 0;
  LeftSize := 0;
  TopSize := 0;
  RightSize := 0;
  BottomSize := 0;
  FCurrentAlphaBlendValue := -1;
  FVisible := False;
  FActive := True;
  LeftImage := nil;
  TopImage := nil;
  RightImage := nil;
  BottomImage := nil;
  LeftBorder := nil;
  TopBorder := nil;
  RightBorder := nil;
  BottomBorder := nil;
  HitTopLeftX := 0;
  HitTopLeftY := 0;
  HitTopRightX := 0;
  HitTopRightY := 0;
  HitBottomLeftX := 0;
  HitBottomLeftY := 0;
  HitBottomRightX := 0;
  HitBottomRightY := 0;
  OldActiveObject := -1;
  ActiveObject := -1;
  MouseCaptureObject := -1;
  //
  DataRgn1 := 0;
  DataRgn2 := 0;
  DataRgn3 := 0;
  DataRgn4 := 0;
  TopRgn := 0;
  BottomRgn := 0;
  RightRgn := 0;
  LeftRgn := 0;
end;

destructor TspFormLayerBorder.Destroy;
begin
  if LeftImage <> nil then LeftImage.Free;
  if TopImage <> nil then TopImage.Free;
  if RightImage <> nil then RightImage.Free;
  if BottomImage <> nil then BottomImage.Free;
  if LeftBorder <> nil then LeftBorder.Free;
  if TopBorder <> nil then TopBorder.Free;
  if RightBorder <> nil then RightBorder.Free;
  if BottomBorder <> nil then BottomBorder.Free;
  MouseTimer.Free;
  //
  if DataRgn1 <> 0 then DeleteObject(DataRgn1);
  if DataRgn2 <> 0 then DeleteObject(DataRgn2);
  if DataRgn3 <> 0 then DeleteObject(DataRgn3);
  if DataRgn4 <> 0 then DeleteObject(DataRgn4);
  if TopRgn <> 0 then DeleteObject(TopRgn);
  if LeftRgn <> 0 then DeleteObject(LeftRgn);
  if RightRgn <> 0 then DeleteObject(RightRgn);
  if BottomRgn <> 0 then DeleteObject(BottomRgn);
  //
  inherited;
end;

procedure TspFormLayerBorder.CreateFrameRgns;
var
  R1, R2: HRgn;
  OffsetX, L, R, T, B: Integer;
begin
  if (FData = nil) or (FData.BlurMaskPictureIndex = -1) then Exit;
  if TopRgn <> 0 then DeleteObject(TopRgn);
  if BottomRgn <> 0 then DeleteObject(BottomRgn);
  if LeftRgn <> 0 then DeleteObject(LeftRgn);
  if RightRgn <> 0 then DeleteObject(RightRgn);
  OffsetX := TopImage.Width - FData.FSourceBitmap.Width;
  if TopImage <> nil
  then
    begin
      L := FData.LTPoint.X;
      T := FData.IntersectBlurMaskRect.Top;
      R := FData.RTPoint.X + OffsetX;
      B := FData.ExcludeBlurMaskRect.Top;
      TopRgn := CreateRectRgn(L, T, R, B);
      R1 := CreateRectRgn(0, 0, 10, 10);
      R2 := CreateRectRgn(0, 0, 10, 10);
      CombineRgn(R1, Self.DataRgn1, 0, RGN_COPY);
      CombineRgn(TopRgn, TopRgn, R1, RGN_OR);
      CombineRgn(R2, Self.DataRgn2, 0, RGN_COPY);
      OffsetRgn(R2, OffsetX, 0);
      CombineRgn(TopRgn, TopRgn, R2, RGN_OR);
      DeleteObject(R1);
      DeleteObject(R2);
    end;
  if BottomImage <> nil
  then
    begin
      L := FData.LBPoint.X;
      T := FData.ExcludeBlurMaskRect.Bottom - FData.LBPoint.Y;
      R := FData.RBPoint.X + OffsetX;
      B := FData.IntersectBlurMaskRect.Bottom - FData.LBPoint.Y;
      BottomRgn := CreateRectRgn(L, T, R, B);
      R1 := CreateRectRgn(0, 0, 10, 10);
      R2 := CreateRectRgn(0, 0, 10, 10);
      CombineRgn(R1, Self.DataRgn3, 0, RGN_COPY);
      CombineRgn(BottomRgn, BottomRgn, R1, RGN_OR);
      CombineRgn(R2, Self.DataRgn4, 0, RGN_COPY);
      OffsetRgn(R2, OffsetX, 0);
      CombineRgn(BottomRgn, BottomRgn, R2, RGN_OR);
      DeleteObject(R1);
      DeleteObject(R2);
    end;
  if (LeftImage <> nil) and (LeftImage.Height > 0)
  then
    begin
      L := FData.IntersectBlurMaskRect.Left;
      R := FData.ExcludeBlurMaskRect.Left;
      T := 0;
      B := LeftImage.Height;
      LeftRgn := CreateRectRgn(L, T, R, B);
    end;
  if (RightImage <> nil) and (RightImage.Height > 0)
  then
    begin
      L := FData.ExcludeBlurMaskRect.Right - FData.ClRect.Right;
      R := FData.IntersectBlurMaskRect.Right - FData.ClRect.Right;
      T := 0;
      B := RightImage.Height;
      RightRgn := CreateRectRgn(L, T, R, B);
    end;
end;

procedure TspFormLayerBorder.InitRgns;
var
  SourceB, B1, B2, B3, B4: TBitMap;
  w, h, Size: Integer;
  R1, R2: TRect;
  RgnData: PRgnData;
  C: TCanvas;
begin
  if DataRgn1 <> 0 then DeleteObject(DataRgn1);
  if DataRgn2 <> 0 then DeleteObject(DataRgn2);
  if DataRgn3 <> 0 then DeleteObject(DataRgn3);
  if DataRgn4 <> 0 then DeleteObject(DataRgn4);
  if TopRgn <> 0 then DeleteObject(TopRgn);
  if BottomRgn <> 0 then DeleteObject(BottomRgn);
  if LeftRgn <> 0 then DeleteObject(LeftRgn);
  if RightRgn <> 0 then DeleteObject(RightRgn);
  DataRgn1 := 0;
  DataRgn2 := 0;
  DataRgn3 := 0;
  DataRgn4 := 0;
  TopRgn := 0;
  BottomRgn := 0;
  RightRgn := 0;
  LeftRgn := 0;
  //
  if (FData = nil) or (FData.BlurMaskPictureIndex = -1) then Exit;
  SourceB := TBitMap(FSD.FActivePictures.Items[FData.BlurMaskPictureIndex]);
  B1 := TBitMap.Create;
  B2 := TBitMap.Create;
  B3 := TBitMap.Create;
  B4 := TBitMap.Create;
  //
  w := FData.LTPoint.X;
  h := FData.LTPoint.Y;
  B1.Width := w;
  B1.Height := h;
  R1 := Rect(0, 0, B1.Width, B1.Height);
  R2 := R1;
  B1.Canvas.CopyRect(R1, SourceB.Canvas, R2);
  //
  w := SourceB.Width - FData.RTPoint.X;
  h := FData.RTPoint.Y;
  B2.Width := w;
  B2.Height := h;
  R1 := Rect(0, 0, B2.Width, B2.Height);
  R2 := Rect(SourceB.Width - w, 0, SourceB.Width, h);
  B2.Canvas.CopyRect(R1, SourceB.Canvas, R2);
  //
  w := FData.LBPoint.X;
  h := SourceB.Height - FData.LBPoint.Y;
  B3.Width := w;
  B3.Height := h;
  R1 := Rect(0, 0, B3.Width, B3.Height);
  R2 := Rect(0, SourceB.Height - h, w, SourceB.Height);
  B3.Canvas.CopyRect(R1, SourceB.Canvas, R2);
  //
  w := SourceB.Width - FData.RBPoint.X;
  h := SourceB.Height - FData.RBPoint.Y;
  B4.Width := w;
  B4.Height := h;
  R1 := Rect(0, 0, B4.Width, B4.Height);
  R2 := Rect(SourceB.Width - w, SourceB.Height - h, SourceB.Width, SourceB.Height);
  B4.Canvas.CopyRect(R1, SourceB.Canvas, R2);
  //
  Size := CreateRgnFromBmp(B1, 0, 0, RgnData);
  DataRgn1 := ExtCreateRegion(nil, Size, RgnData^);
  FreeMem(RgnData, Size);

  Size := CreateRgnFromBmp(B2, 0, 0, RgnData);
  DataRgn2 := ExtCreateRegion(nil, Size, RgnData^);
  FreeMem(RgnData, Size);
  OffsetRgn(DataRgn2, FData.RTPoint.X, 0);

  Size := CreateRgnFromBmp(B3, 0, 0, RgnData);
  DataRgn3 := ExtCreateRegion(nil, Size, RgnData^);
  FreeMem(RgnData, Size);

  Size := CreateRgnFromBmp(B4, 0, 0, RgnData);
  DataRgn4 := ExtCreateRegion(nil, Size, RgnData^);
  FreeMem(RgnData, Size);
  OffsetRgn(DataRgn4, FData.RBPoint.X, 0);
  //
  B1.Free;
  B2.Free;
  B3.Free;
  B4.Free;
end;

procedure TspFormLayerBorder.CheckMouse(Sender: TObject);
var
  P: TPoint;
begin
  if (FData <> nil) and not FData.FullBorder
  then
    begin
      MouseTimer.Enabled := False;
      Exit;
    end;
  GetCursorPos(P);
  if (TopBorder <> nil) and (WindowFromPoint(P) <> TopBorder.Handle)
  then
    begin
      MouseTimer.Enabled := False;
      MouseCaptureObject := -1;
      TestActive(-1, -1);
    end;
end;

procedure TspFormLayerBorder.CheckButtonUp;
var
  i: Integer;
begin
  for i := 0 to DSF.ObjectList.Count - 1 do
    if TspActiveSkinObject(DSF.ObjectList.Items[i]) is TspSkinStdButtonObject
    then
      with TspSkinStdButtonObject(DSF.ObjectList.Items[i]) do
      begin
        if FDown then FDown := False;
        if FMouseIn then FMouseIn := False;
      end;
end;

procedure TspFormLayerBorder.TestActive(X, Y: Integer);
var
  i: Integer;
  B: Boolean;
  ObjHint: String;
  X1, Y1: Integer;
begin

  if (DSF.ObjectList.Count = 0) or (not DSF.FFormActive and DSF.FSupportNCArea) or DSF.FSizeMove or DSF.FBorderLayerChangeSize
  then
    Exit;

  if DSF.PreviewMode or ((FForm.FormStyle = fsMDIChild) and (DSF.WindowState = wsMaximized))
     or ((FForm.BorderStyle = bsNone) and DSF.SupportNCArea)
  then
    Exit;

  if (FData <> nil) and not FData.FullBorder then Exit;

  OldActiveObject := ActiveObject;

  i := -1;

  B := False;
  repeat
    Inc(i);
    with TspActiveSkinObject(DSF.ObjectList.Items[i]) do
    begin
      if Enabled and Visible
      then
        B := PtInRect(ObjectRect, Point(X, Y));
      if B
      then
        begin
          X1 := X - ObjectRect.Left;
          Y1 := Y - ObjectRect.Top;
          B := InActiveMask(X1, Y1);
        end;
    end;
  until B or (i = DSF.ObjectList.Count - 1);

  if B then ActiveObject := i else ActiveObject := -1;

  if (MouseCaptureObject <> -1) and
     (ActiveObject <> MouseCaptureObject) and (ActiveObject <> -1)
  then
    ActiveObject := -1;

  if OldActiveObject >= DSF.ObjectList.Count then OldActiveObject := -1;
  if ActiveObject >= DSF.ObjectList.Count then ActiveObject := -1;

  if (OldActiveObject <> ActiveObject)
  then
    begin
      if OldActiveObject <> - 1
      then
        begin
          if TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).Enabled and
             TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).Visible
          then TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).MouseLeave;
          if DSF.FShowObjectHint and (DSF.FSkinHint <> nil) and
             TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).Enabled and
             (TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).Hint <> '') and
             TspActiveSkinObject(DSF.ObjectList.Items[OldActiveObject]).Visible
          then DSF.FSkinHint.HideHint;
        end;
      if ActiveObject <> -1
      then
        begin
          if TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).Enabled and
             TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).Visible
          then TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).MouseEnter;
          // show object hint
          if DSF.FFormActive and
             DSF.FShowObjectHint and (DSF.FSkinHint <> nil) and
             TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).Enabled and
             TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).Visible
          then
            begin
              ObjHint := TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]).Hint;
              if ObjHint <> '' then DSF.FSkinHint.ActivateHint2(ObjHint);
            end;
          //
        end;
    end;
end;

procedure TspFormLayerBorder.CalcObjectRects;
var
  MenuButton: TspSkinCaptionMenuButton;
  NewCaptionRect, NewButtonsRect: TRect;
  XO: Integer;
  OffsetX, OffsetY: Integer;
  BW, BH: Integer;
  Button: TspActiveSkinObject;
  C: TspSkinCaptionObject;

function GetCaption: TspSkinCaptionObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to DSF.ObjectList.Count - 1 do
    if TspActiveSkinObject(DSF.ObjectList.Items[I]) is TspSkinCaptionObject
    then
      begin
        Result := TspSkinCaptionObject(DSF.ObjectList.Items[I]);
        Break;
      end;
end;

function GetStdButton(C: TStdCommand): TspActiveSkinObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to DSF.ObjectList.Count - 1 do
    if TspActiveSkinObject(DSF.ObjectList.Items[I]) is TspSkinStdButtonObject
    then
      begin
        with TspSkinStdButtonObject(DSF.ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = C)
          then
            begin
              Result := TspActiveSkinObject(DSF.ObjectList.Items[I]);
              Break;
            end;
      end
    else
      if TspActiveSkinObject(DSF.ObjectList.Items[I]) is TspSkinAnimateObject
      then
        begin
          with TspSkinAnimateObject(DSF.ObjectList.Items[I]) do
          if Visible and SkinRectInAPicture and (Command = C)
          then
            begin
              Result := TspActiveSkinObject(DSF.ObjectList.Items[I]);
              Break;
            end;
        end;
end;

procedure SetStdButtonRect(B: TspActiveSkinObject);
begin
  if (B <> nil) and (B is TspSkinStdButtonObject)
  then
    begin
      with TspSkinStdButtonObject(B) do
      begin
        if (Command = cmSysMenu) and DSF.ShowIcon
        then
          DSF.GetIconSize(BW, BH)
        else
          begin
            BW := RectWidth(SkinRect);
            BH := RectHeight(SkinRect);
          end;
        if Command = cmSysMenu
        then
          begin
            ObjectRect := Rect(OffsetX, OffsetY, OffsetX + BW, OffsetY + BH);
            OffsetX := OffsetX + DSF.FSD.ButtonsOffset + BW;
          end
        else
          begin
            ObjectRect := Rect(OffsetX - BW, OffsetY, OffsetX, OffsetY + BH);
            OffsetX := OffsetX - DSF.FSD.ButtonsOffset - BW;
          end;
      end;
    end;
end;

function GetCaptionMenuButton: TspSkinCaptionMenuButton;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to DSF.ObjectList.Count - 1 do
    if TspActiveSkinObject(DSF.ObjectList.Items[I]) is TspSkinCaptionMenuButton
    then
      begin
        Result := TspSkinCaptionMenuButton(DSF.ObjectList.Items[I]);
        Break;
      end;
end;

begin
  NewCaptionRect := FData.CaptionRect;
  XO := TopImage.Width - FData.FSourceBitmap.Width;
  Inc(NewCaptionRect.Right, XO);
  NewButtonsRect := FData.ButtonsRect;
  //
  if not IsNullRect(NewButtonsRect)
  then
    begin
      OffsetRect(NewButtonsRect, XO, 0);
      OffsetX := NewButtonsRect.Right;
      OffsetY := NewButtonsRect.Top;
    end
  else
    begin
      OffsetX := NewCaptionRect.Right;
      if FData.ButtonsTopOffset <> 0
      then
        OffsetY := FData.ButtonsTopOffset
      else
        OffsetY := NewCaptionRect.Top;
    end;
  //
  Button := GetStdButton(cmClose);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMaximize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimize);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmRollUp);
  SetStdButtonRect(Button);
  Button := GetStdButton(cmMinimizeToTray);
  SetStdButtonRect(Button);
  //
  C := GetCaption;
  if C <> nil
  then
    begin
      C.ObjectRect.Left := NewCaptionRect.Left;
      C.ObjectRect.Top := NewCaptionRect.Top;
      C.ObjectRect.Bottom := NewCaptionRect.Bottom;
      C.ObjectRect.Right := OffsetX - DSF.FSD.ButtonsOffset;
    end;
  //
  if not IsNullRect(FData.SysMenuButtonRect)
  then
    begin
      OffsetX := FData.SysMenuButtonRect.Left;
      OffsetY := FData.SysMenuButtonRect.Top;
      Button := GetStdButton(cmSysMenu);
      if Button <> nil
      then
        begin
          SetStdButtonRect(Button);
          Button.ObjectRect.Top := OffsetY + RectHeight(FData.SysMenuButtonRect) div 2  -
            BH div 2;
          Button.ObjectRect.Bottom := Button.ObjectRect.Top + BH;
        end;
    end
  else
    begin
      OffsetX := NewCaptionRect.Left;
      Button := GetStdButton(cmSysMenu);
      if Button <> nil
      then
        begin
          SetStdButtonRect(Button);
          if DSF.ShowIcon
          then
            begin
              Button.ObjectRect.Top := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2  -
                BH div 2;
            end
          else
            begin
              if FData.SysButtonTopOffset <> 0
              then
                Button.ObjectRect.Top := FData.SysButtonTopOffset
              else
                Button.ObjectRect.Top := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2  -
                BH div 2;
             end;
          Button.ObjectRect.Bottom := Button.ObjectRect.Top + BH;
          if C <> nil then C.ObjectRect.Left := OffsetX;
        end;
    end;
  MenuButton := GetCaptionMenuButton;
  if (MenuButton <> nil) and (C <> nil)
  then
    with MenuButton do
    begin
      Visible := Parent.FMenuButtonVisible;
      ObjectRect := Rect(C.ObjectRect.Left + 5,
        FData.BorderRect.Top + TopPosition,
        C.ObjectRect.Left + Parent.MenuButtonWidth + 5,
        FData.BorderRect.Top + TopPosition + RectHeight(SkinRect));
      if Visible and (C <> nil)
      then
        C.ObjectRect.Left := ObjectRect.Right + 5;
    end;
end;

procedure TspFormLayerBorder.InitObjects;
begin

end;

procedure TspFormLayerBorder.InitFrame;
var
  i: Integer;
begin
  FForm := AForm;
  FSD := ASkinData;
  if (FSD <> nil) and not FSD.Empty
  then
    FData := ASkinData.LayerFrame
  else
    FData := nil;

  if (FData <> nil) and (FData.PictureIndex = -1)
  then
    begin
      FData := nil;
      Exit;
    end
  else
    if FData = nil then Exit;

  FIsAeroEnabled := IsVistaOs and IsWindowsAero;

  //
  FCurrentAlphaBlendValue := FData.AlphaBlendValue;
  FCurrentInActiveAlphaBlendValue := FData.InActiveAlphaBlendValue;
  //
  if not IsNullRect(FData.BorderRect)
  then
    begin
      LeftSize := FData.ClRect.Left - FData.BorderRect.Left;
      TopSize := FData.ClRect.Top - FData.BorderRect.Top;
      RightSize := FData.BorderRect.Right - FData.ClRect.Right;
      BottomSize := FData.BorderRect.Bottom - FData.ClRect.Bottom;
      //
      HitTopLeftX := FData.HitTestLTPoint.X - FData.BorderRect.Left;
      HitTopLeftY := FData.HitTestLTPoint.Y - FData.BorderRect.Top;
      HitTopRightX := FData.BorderRect.Right - FData.HitTestRTPoint.X;
      HitTopRightY := FData.HitTestRTPoint.Y - FData.BorderRect.Top;
      HitBottomLeftX := FData.HitTestLBPoint.X - FData.BorderRect.Left;
      HitBottomLeftY := FData.BorderRect.Bottom - FData.HitTestLBPoint.Y;
      HitBottomRightX := FData.BorderRect.Right - FData.HitTestRBPoint.X;;
      HitBottomRightY := FData.BorderRect.Bottom - FData.HitTestRBPoint.Y;
      //
    end
  else
    begin
      LeftSize := 0;
      TopSize := 0;
      RightSize := 0;
      BottomSize := 0;
    end;
  //
  if FData.FullBorder
  then
    begin
      DSF.IsAlphaIcon := DSF.CheckIconAlpha;
      ActiveObject := -1;
      OldActiveObject := -1;
      MouseCaptureObject := -1;
    end;    
  //
  InitRgns;
  //
end;

procedure TspFormLayerBorder.InitFrameImages(AWidth, AHeight: Integer);
var
  Offset1, Offset2, Y, YCnt, YO, h, hoffset, i: Integer;
  R1, R11, R2, R22, R3, R33: TRect;
  SB: TspBitmap;
  TempRect: TRect;
begin

  if FData = nil then Exit;
  if DSF = nil then Exit;

  if not FActive and (FData.FSourceInActiveBitMap <> nil)
  then
    SB := FData.FSourceInActiveBitMap
  else
    SB := FData.FSourceBitMap;

  if LeftImage <> nil then LeftImage.Free;
  if TopImage <> nil then TopImage.Free;
  if RightImage <> nil then RightImage.Free;
  if BottomImage <> nil then BottomImage.Free;

  if (FData.RBPoint.X = 0) and (FData.RBPoint.Y = 0)
  then
    begin
      TopImage := TspBitMap.Create;
      TopImage.Assign(SB);
      TopImage.CheckRGBA;
      LeftImage := nil;
      RightImage := nil;
      BottomImage := nil;
      Exit;
    end;
    
  // top
  TopImage := TspBitMap.Create;
  TopImage.SetSize(AWidth, Max(FData.LTPoint.Y, FData.RTPoint.Y));
  Offset1 := FData.LTPoint.X;
  Offset2 := SB.Width - FData.RTPoint.X;
  R1 := Rect(0, 0, Offset1, TopImage.Height);
  R11 := Rect(0, 0, Offset1, TopImage.Height);
  R2 := Rect(FData.RTPoint.X, 0, SB.Width, TopImage.Height);
  R22 := Rect(TopImage.Width - Offset2, 0, TopImage.Width, TopImage.Height);
  R3 := Rect(Offset1, 0, FData.RTPoint.X, TopImage.Height);
  R33 := Rect(Offset1, 0, TopImage.Width - Offset2, TopImage.Height);
  with TopImage.Canvas do
  begin
    CopyRect(R11, SB.Canvas, R1);
    CopyRect(R22, SB.Canvas, R2);
    CopyRect(R33, SB.Canvas, R3);
  end;
  TopImage.CheckingAlphaBlend;
  //
  if FData.FullBorder
  then
    begin
      CalcObjectRects;
      for i := 0 to DSF.ObjectList.Count - 1 do
      with TspActiveSkinObject(DSF.ObjectList.Items[i]) do
      if Visible then
          DrawAlpha(TopImage.Canvas, TopImage);
    end;
  // check height of bottom image
  h := SB.Height - Min(FData.LBPoint.Y, FData.RBPoint.Y);
  if TopImage.Height + h > AHeight
  then
    begin
      hoffset := h;
      h := AHeight - TopImage.Height;
      hoffset := hoffset - h;
    end
  else
    hoffset := 0;
  // bottom
  BottomImage := TspBitMap.Create;
  BottomImage.SetSize(AWidth, h);
  Offset1 := FData.LBPoint.X;
  Offset2 := SB.Width - FData.RBPoint.X;
  R1 := Rect(0, SB.Height - BottomImage.Height, Offset1, SB.Height);
  Inc(R1.Top, hoffset);
  R11 := Rect(0, 0, Offset1, BottomImage.Height);
  R2 := Rect(SB.Width - Offset2, SB.Height - BottomImage.Height, SB.Width, SB.Height);
  Inc(R2.Top, hoffset);
  R22 := Rect(BottomImage.Width - Offset2, 0, BottomImage.Width, BottomImage.Height);
  R3 := Rect(Offset1, SB.Height - BottomImage.Height, FData.RTPoint.X, SB.Height);
  Inc(R3.Top, hoffset);
  R33 := Rect(Offset1, 0, BottomImage.Width - Offset2, BottomImage.Height);
  with BottomImage.Canvas do
  begin
    CopyRect(R11, SB.Canvas, R1);
    CopyRect(R22, SB.Canvas, R2);
    CopyRect(R33, SB.Canvas, R3);
  end;
  BottomImage.CheckingAlphaBlend;
 // left
  LeftImage := TspBitMap.Create;
  if AHeight - TopImage.Height - BottomImage.Height > 0
  then
    begin
      LeftImage.SetSize(FData.ClRect.Left, AHeight - TopImage.Height - BottomImage.Height);
      R1 := Rect(0, TopImage.Height, LeftImage.Width, SB.Height - BottomImage.Height);
      R11 := Rect(0, 0, LeftImage.Width, LeftImage.Height);
      if not FData.FullStretch
      then
        begin
          YCnt := LeftImage.Height div RectHeight(R1);
          h := RectHeight(R1);
          with LeftImage.Canvas do
          begin
            for Y := 0 to YCnt do
            begin
              if Y * h + h > LeftImage.Height
              then YO := Y * h + h - LeftImage.Height else YO := 0;
              CopyRect(Rect(R11.Left, Y * h, R11.Right, Y * h + h - YO),
                   SB.Canvas,
                   Rect(R1.Left, R1.Top, R1.Right, R1.Bottom - YO));
            end;
          end;
        end
      else
        begin
          LeftImage.Canvas.CopyRect(R11, SB.Canvas, R1);
        end;

      LeftImage.CheckingAlphaBlend;
    end
  else
    begin
      LeftImage.SetSize(0, 0);
    end;
  // right
  RightImage := TspBitMap.Create;
  if AHeight - TopImage.Height - BottomImage.Height > 0
  then
    begin
      RightImage.SetSize(SB.Width - FData.ClRect.Right, AHeight - TopImage.Height - BottomImage.Height);
      R1 := Rect(SB.Width - RightImage.Width,
      TopImage.Height, SB.Width, SB.Height - BottomImage.Height);
      R11 := Rect(0, 0, RightImage.Width, RightImage.Height);
      if not FData.FullStretch
      then
        begin
          YCnt := RightImage.Height div RectHeight(R1);
          h := RectHeight(R1);
          with RightImage.Canvas do
          begin
            for Y := 0 to YCnt do
            begin
              if Y * h + h > RightImage.Height
              then YO := Y * h + h - RightImage.Height else YO := 0;
              CopyRect(Rect(R11.Left, Y * h, R11.Right, Y * h + h - YO),
                       SB.Canvas,
                        Rect(R1.Left, R1.Top, R1.Right, R1.Bottom - YO));
            end;
          end;
        end
      else
        begin
          RightImage.Canvas.CopyRect(R11, SB.Canvas, R1);
        end;
      RightImage.CheckingAlphaBlend;
    end
  else
    begin
      RightImage.SetSize(0, 0);
    end;
  //
  if TopImage <> nil then TopImage.CheckRGBA;
  if BottomImage <> nil then BottomImage.CheckRGBA;
  if LeftImage <> nil then LeftImage.CheckRGBA;
  if RightImage <> nil then RightImage.CheckRGBA;
  //
  if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) then CreateFrameRgns;
  //
end;

procedure TspFormLayerBorder.Draw(C: TCanvas; X, Y, AWidth, AHeight: Integer);
begin
  if FData = nil then Exit;
  InitFrameImages(AWidth, AHeight);
  if (TopImage <> nil) and (TopImage.Width > 0)
  then
    TopImage.Draw(C, X, Y);
  if (BottomImage <> nil) and (BottomImage.Width > 0)
  then
    BottomImage.Draw(C, X, Y + AHeight - BottomImage.Height);
  if (LeftImage <> nil) and (LeftImage.Height > 0)
  then
    LeftImage.Draw(C, X, Y + TopImage.Height);
  if (RightImage <> nil) and (RightImage.Height > 0)
  then
    RightImage.Draw(C, X + AWidth - RightImage.Width, Y + TopImage.Height);
end;

procedure TspFormLayerBorder.Show(X, Y, AWidth, AHeight: Integer);
var
  AlphaValue: Integer;
begin
  if FData = nil then Exit;

  FWidth := AWidth;
  FHeight := AHeight;

  FVisible := True;
  InitFrameImages(AWidth, AHeight);

  if LeftBorder <> nil then FreeAndNil(LeftBorder);
  if TopBorder <> nil then FreeAndNil(TopBorder);
  if RightBorder <> nil then FreeAndNil(RightBorder);
  if BottomBorder <> nil then FreeAndNil(BottomBorder);

  if (FData.RBPoint.X = 0) and (FData.RBPoint.Y = 0)
  then
    begin
      TopBorder := TspFormLayerWindow.CreateEx(Self, FForm);
      TopBorder.BorderType := spflTop;
      if FActive
      then
        AlphaValue := FCurrentAlphaBlendValue
      else
        AlphaValue := FCurrentInActiveAlphaBlendValue;
      CreateAlphaLayered2(TopImage, AlphaValue, TopBorder);
      SetWindowPos(TopBorder.Handle, HWND_TOP, X, Y, 0, 0,
               SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
      Exit;
    end;

  LeftBorder := TspFormLayerWindow.CreateEx(Self, FForm);
  LeftBorder.BorderType := spflLeft;

  RightBorder := TspFormLayerWindow.CreateEx(Self, FForm);
  RightBorder.BorderType := spflRight;

  TopBorder := TspFormLayerWindow.CreateEx(Self, FForm);
  TopBorder.BorderType := spflTop;

  BottomBorder := TspFormLayerWindow.CreateEx(Self, FForm);
  BottomBorder.BorderType := spflBottom;

  if FActive
  then
    AlphaValue := FCurrentAlphaBlendValue
  else
    AlphaValue := FCurrentInActiveAlphaBlendValue;

  CreateAlphaLayered2(TopImage, AlphaValue, TopBorder);
  if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (TopRgn <> 0)
  then
    SetBlurBehindWindow(TopBorder.Handle, True, TopRgn);

  CreateAlphaLayered2(BottomImage, AlphaValue, BottomBorder);
  if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (BottomRgn <> 0)
  then
    SetBlurBehindWindow(BottomBorder.Handle, True, BottomRgn);


  if LeftImage.Height > 0
  then
    begin
      CreateAlphaLayered2(LeftImage, AlphaValue, LeftBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (LeftRgn <> 0)
      then
        SetBlurBehindWindow(LeftBorder.Handle, True, LeftRgn);
    end;

  if RightImage.Height > 0
  then
    begin
      CreateAlphaLayered2(RightImage, AlphaValue, RightBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (RightRgn <> 0)
      then
        SetBlurBehindWindow(RightBorder.Handle, True, RightRgn);
    end;



  SetWindowPos(TopBorder.Handle, HWND_TOP, X, Y, 0, 0,
               SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  SetWindowPos(BottomBorder.Handle, HWND_TOP, X, Y + AHeight - BottomImage.Height, 0, 0,
               SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  if LeftImage.Height > 0
  then
    begin
      SetWindowPos(LeftBorder.Handle, HWND_TOP, X, Y + TopImage.Height, 0, 0,
                   SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
      LeftBorder.Visible := True;
    end
  else
    LeftBorder.Visible := False;

  if RightImage.Height > 0
  then
    begin
      SetWindowPos(RightBorder.Handle, HWND_TOP,
                   X + AWidth - RightImage.Width, Y + TopImage.Height, 0, 0,
                   SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
      RightBorder.Visible := True;
    end
  else
    RightBorder.Visible := False;
end;

procedure TspFormLayerBorder.Hide;
begin
  FVisible := False;
  if LeftImage <> nil then FreeAndNil(LeftImage);
  if TopImage <> nil then FreeAndNil(TopImage);
  if RightImage <> nil then FreeAndNil(RightImage);
  if BottomImage <> nil then FreeAndNil(BottomImage);
  if LeftBorder <> nil then FreeAndNil(LeftBorder);
  if TopBorder <> nil then FreeAndNil(TopBorder);
  if RightBorder <> nil then FreeAndNil(RightBorder);
  if BottomBorder <> nil then FreeAndNil(BottomBorder);
end;

procedure TspFormLayerBorder.UpdateBorder;
var
  X, Y, W, H: Integer;
begin
  if FData = nil then Exit;
  if not FVisible then Exit;

  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  Update(X, Y, W, H);
end;

procedure TspFormLayerBorder.Update(X, Y, AWidth, AHeight: Integer);
var
  AlphaValue: Integer;
begin
  if FData = nil then Exit;
  if not FVisible  then Exit;

  FWidth := AWidth;
  FHeight := AHeight;

  InitFrameImages(AWidth, AHeight);

  if FActive
  then
    AlphaValue := FCurrentAlphaBlendValue
  else
    AlphaValue := FCurrentInActiveAlphaBlendValue;

  if TopBorder <> nil
  then
    begin
      CreateAlphaLayered2(TopImage, AlphaValue, TopBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (TopRgn <> 0)
      then
        SetBlurBehindWindow(TopBorder.Handle, True, TopRgn);
    end;

  if BottomBorder <> nil
  then
    begin
      CreateAlphaLayered2(BottomImage, AlphaValue, BottomBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (BottomRgn <> 0)
      then
        SetBlurBehindWindow(BottomBorder.Handle, True, BottomRgn);
    end;  

  if (LeftBorder <> nil) and (LeftImage.Height > 0)
  then
    begin
      CreateAlphaLayered2(LeftImage, AlphaValue, LeftBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (LeftRgn <> 0)
      then
        SetBlurBehindWindow(LeftBorder.Handle, True, LeftRgn);
    end;  

  if (RightBorder <> nil) and (RightImage.Height > 0)
  then
    begin
      CreateAlphaLayered2(RightImage, AlphaValue, RightBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (RightRgn <> 0)
      then
        SetBlurBehindWindow(RightBorder.Handle, True, RightRgn);
    end;

  if TopBorder <> nil
  then
    UpdateWindow(TopBorder.Handle);

  if BottomBorder <> nil
  then
    UpdateWindow(BottomBorder.Handle);

  if (LeftBorder <> nil) and (LeftImage.Height > 0)
  then
    UpdateWindow(LeftBorder.Handle);

  if (RightBorder <> nil) and (RightImage.Height > 0)
  then
    UpdateWindow(RightBorder.Handle);
end;

procedure TspFormLayerBorder.SetBounds(X, Y, AWidth, AHeight: Integer);
var
  AlphaValue: Integer;
begin
  if FData = nil then Exit;
  if not FVisible  then Exit;

  FWidth := AWidth;
  FHeight := AHeight;

  InitFrameImages(AWidth, AHeight);

  if FActive
  then
    AlphaValue := FCurrentAlphaBlendValue
  else
    AlphaValue := FCurrentInActiveAlphaBlendValue;

  if TopBorder <> nil
  then
    begin
      CreateAlphaLayered2(TopImage, AlphaValue, TopBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (TopRgn <> 0)
      then
        SetBlurBehindWindow(TopBorder.Handle, True, TopRgn);
    end;  

  if BottomBorder <> nil
  then
    begin
      CreateAlphaLayered2(BottomImage, AlphaValue, BottomBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (BottomRgn <> 0)
      then
        SetBlurBehindWindow(BottomBorder.Handle, True, BottomRgn);
    end;  

  if (LeftBorder <> nil) and (LeftImage.Height > 0)
  then
    begin
      CreateAlphaLayered2(LeftImage, AlphaValue, LeftBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (LeftRgn <> 0)
      then
        SetBlurBehindWindow(LeftBorder.Handle, True, LeftRgn);
    end;  

  if (RightBorder <> nil) and (RightImage.Height > 0)
  then
    begin
      CreateAlphaLayered2(RightImage, AlphaValue, RightBorder);
      if FIsAeroEnabled and (FSD.AeroBlurEnabled and not Self.DSF.AlphaBlend) and (RightRgn <> 0)
      then
        SetBlurBehindWindow(RightBorder.Handle, True, RightRgn);
    end;  


  if TopBorder <> nil
  then
    SetWindowPos(TopBorder.Handle, HWND_TOP, X, Y, 0, 0,
                   SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);

  if BottomBorder <> nil
  then
    SetWindowPos(BottomBorder.Handle, HWND_TOP, X, Y + AHeight - BottomImage.Height, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);

  if (LeftBorder <> nil)
  then
    begin
      if (LeftImage.Height > 0)
      then
        begin
          SetWindowPos(LeftBorder.Handle, HWND_TOP, X, Y + TopImage.Height, 0, 0,
                       SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);
          LeftBorder.Visible := True;
        end
      else
        begin
          SetWindowPos(LeftBorder.Handle, HWND_TOP, X, Y + TopImage.Height, 0, 0,
                       SWP_NOACTIVATE or SWP_HIDEWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);
          LeftBorder.Visible := False;
        end;
    end;

  if RightBorder <> nil
  then
    begin
      if (RightImage.Height > 0)
      then
        begin
          SetWindowPos(RightBorder.Handle, HWND_TOP,
                       X + AWidth - RightImage.Width, Y + TopImage.Height, 0, 0,
                       SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);
           RightBorder.Visible := True;            
        end
      else
        begin
          SetWindowPos(RightBorder.Handle, HWND_TOP,
                       X + AWidth - RightImage.Width, Y + TopImage.Height, 0, 0,
                       SWP_NOACTIVATE or SWP_HIDEWINDOW or SWP_NOSIZE or SWP_NOOWNERZORDER);
          RightBorder.Visible := False;
        end;               
    end;
end;


procedure TspFormLayerBorder.ShowWithForm;
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;

  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  Show(X, Y, W, H);
end;

procedure TspFormLayerBorder.SetBoundsWithForm;
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;

  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  SetBounds(X, Y, W, H);
end;

procedure TspFormLayerBorder.SetBoundsWithForm3(ALeft, ATop, AW, AH: Integer);
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;

  X := ALeft;
  Y := ATop;
  W := AW;
  H := AH;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  SetBounds(X, Y, W, H);
end;

procedure TspFormLayerBorder.SetBoundsWithForm2(AW, AH: Integer);
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;
  
  X := FForm.Left;
  Y := FForm.Top;
  W := AW;
  H := AH;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

 SetBounds(X, Y, W, H);
end;

procedure TspFormLayerBorder.MoveWithForm;
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;

  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);
 
  if TopBorder <> nil
  then
    TopBorder.SetBounds(X, Y, TopBorder.Width, TopBorder.Height);
  if BottomBorder <> nil
  then
    BottomBorder.SetBounds(X, Y + H - BottomImage.Height, BottomBorder.Width, BottomBorder.Height);
  if (LeftBorder <> nil) and (LeftBorder.Visible)
  then
   LeftBorder.SetBounds(X, Y + TopImage.Height, LeftBorder.Width, LeftBorder.Height);
  if (RightBorder <> nil) and (RightBorder.Visible)
  then
    RightBorder.SetBounds(X + W - RightImage.Width, Y + TopImage.Height,
       RightBorder.Width, RightBorder.Height);
end;

procedure TspFormLayerBorder.MoveWithForm2;
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;

  X := ALeft;
  Y := ATop;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);
 
  if TopBorder <> nil
  then
    TopBorder.SetBounds(X, Y, TopBorder.Width, TopBorder.Height);
  if BottomBorder <> nil
  then
    BottomBorder.SetBounds(X, Y + H - BottomImage.Height, BottomBorder.Width, BottomBorder.Height);
  if (LeftBorder <> nil) and (LeftBorder.Visible)
  then
   LeftBorder.SetBounds(X, Y + TopImage.Height, LeftBorder.Width, LeftBorder.Height);
  if (RightBorder <> nil) and (RightBorder.Visible)
  then
    RightBorder.SetBounds(X + W - RightImage.Width, Y + TopImage.Height,
       RightBorder.Width, RightBorder.Height);
end;


procedure TspFormLayerBorder.SetAlphaBlend2;
var
  X, Y, W, H: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;
  
  if not FVisible then Exit;

  SetAlphaBlend;
  
  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  if DSF.IsNullHeight then H := FData.RollUpFormHeight;

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  if TopBorder <> nil
  then
    SetWindowPos(TopBorder.Handle, HWND_TOP, X, Y, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  if BottomBorder <> nil
  then
    SetWindowPos(BottomBorder.Handle, HWND_TOP, X, Y + H - BottomImage.Height, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  if (LeftBorder <> nil) and (LeftBorder.Visible)
  then
   SetWindowPos(LeftBorder.Handle, HWND_TOP, X, Y + TopImage.Height, 0, 0,
                SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  if (RightBorder <> nil) and (RightBorder.Visible)
  then
    SetWindowPos(RightBorder.Handle, HWND_TOP,
                 X + W - RightImage.Width, Y + TopImage.Height, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
end;

procedure TspFormLayerBorder.SetAlphaBlend;
var
  AlphaValue: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;

  if FActive
  then
    AlphaValue := FCurrentAlphaBlendValue
  else
    AlphaValue := FCurrentInActiveAlphaBlendValue;
   
  if not FVisible or (TopImage = nil) then Exit;

  if (TopImage <> nil) and (TopImage.Width > 0)
  then
    CreateAlphaLayered2(TopImage, AlphaValue, TopBorder);

  if (BottomImage <> nil) and (BottomImage.Width > 0)
  then
    CreateAlphaLayered2(BottomImage, AlphaValue, BottomBorder);

  if (LeftBorder <> nil) and (LeftBorder.Visible)
  then
    CreateAlphaLayered2(LeftImage, AlphaValue, LeftBorder);
    
  if (RightBorder <> nil) and (RightBorder.Visible)
  then
    CreateAlphaLayered2(RightImage, AlphaValue, RightBorder);

end;


procedure TspFormLayerBorder.CheckFormAlpha(AFormAlpha: Integer; AUpdate: Boolean);
var
  kf: Double;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;

  kf := AFormAlpha / 255;
  FCurrentAlphaBlendValue := Round(FData.AlphaBlendValue * kf);
  FCurrentInActiveAlphaBlendValue := Round(FData.InActiveAlphaBlendValue * kf);
  if AUpdate then SetAlphaBlend;
end;

procedure TspFormLayerBorder.SetActive(AValue, AUpdate: Boolean);
var
  i: Integer;
begin
  FActive := AValue;

  if not FActive
  then
    begin
      if (ActiveObject <> -1) and
        (TspActiveSkinObject(DSF.ObjectList.Items[ActiveObject]) is TspSkinCaptionObject)
      then
        with TspSkinCaptionObject(DSF.ObjectList.Items[ActiveObject]) do
        begin
          if (ActiveQuickButton <> -1) and (DSF.FQuickButtons.Count > 0)
          then
            with DSF.FQuickButtons[ActiveQuickButton] do
            begin
              Down := False;
              Active := False;
            end;
        end;
      CheckButtonUp;  
      MouseCaptureObject := -1;
      TestActive(-1, -1);
      ActiveObject := -1;
    end;

  if not FVisible then Exit;
  if (FData <> nil) and ((FData.FullBorder) or (FData.FSourceInActiveBitMap <> nil))
  then
    SetBoundsWithForm;
  if AUpdate then SetAlphaBlend2;
end;

procedure TspFormLayerBorder.ShowWithFormAnimation;
var
  A1, X, Y, W, H, I,  J, TickCount, Step: Integer;
begin
  if (FData = nil) or (FData.FSourceBitmap = nil) then Exit;

  X := FForm.Left;
  Y := FForm.Top;
  W := FForm.Width;
  H := FForm.Height;

  //
  X := X + FData.LeftOffset;
  Y := Y + FData.TopOffset;
  W := W + FData.WidthOffset;
  H := H + FData.HeightOffset;
  //

  X := X - FData.ClRect.Left;
  Y := Y - FData.ClRect.Top;
  W := W + FData.FSourceBitMap.Width - RectWidth(FData.ClRect);
  H := H + FData.FSourceBitMap.Height - RectHeight(FData.ClRect);

  A1 := FCurrentAlphaBlendValue;
  FCurrentAlphaBlendValue := 0;
  Show(X, Y, W, H);
  //
  J := A1;
  TickCount := 0;
  I := 0;
  Step := J div 15;
  if Step = 0 then Step := 1;
  Application.ProcessMessages;
  repeat
     if (GetTickCount - TickCount > 5)
     then
       begin
         TickCount := GetTickCount;
         Inc(i, Step);
         if I > J then I := J;
         FCurrentAlphaBlendValue := i;
         Self.SetAlphaBlend;
       end;
  until i >= J;
end;


// Quick buttons

constructor TspQuickButtonItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  ItemRect := NullRect;
  FImageIndex := -1;
  FHint := '';
  FEnabled := True;
  FVisible := True;
  Active := False;
  Down := False;
  FPopupMenu := nil;
end;

procedure TspQuickButtonItem.Assign(Source: TPersistent);
begin
  if Source is TspQuickButtonItem then
  begin
    FImageIndex := TspQuickButtonItem(Source).ImageIndex;
    FHint := TspQuickButtonItem(Source).Hint;
    FEnabled := TspQuickButtonItem(Source).Enabled;
    FVisible := TspQuickButtonItem(Source).Visible;
  end
  else
    inherited Assign(Source);
end;

procedure TspQuickButtonItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspQuickButtonItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  Changed(False);
end;

procedure TspQuickButtonItem.SetVisible(Value: Boolean);
begin
  FVisible := Value;
  Changed(False);
end;

constructor TspQuickButtonItems.Create;
begin
  inherited Create(TspQuickButtonItem);
  DSF:= ADSF;
end;

function TspQuickButtonItems.GetOwner: TPersistent;
begin
  Result := DSF;
end;

procedure TspQuickButtonItems.Update(Item: TCollectionItem);
begin
  if DSF = nil then Exit;
  if not (csDesigning in DSF.ComponentState) and
     not (csLoading in DSF.ComponentState)
  then
    begin
      DSF.UpdateFormNC;
    end;
end;

function TspQuickButtonItems.GetItem(Index: Integer):  TspQuickButtonItem;
begin
  Result := TspQuickButtonItem(inherited GetItem(Index));
end;

procedure TspQuickButtonItems.SetItem(Index: Integer; Value:  TspQuickButtonItem);
begin
  inherited SetItem(Index, Value);
end;

function TspQuickButtonItems.Add: TspQuickButtonItem;
begin
  Result := TspQuickButtonItem(inherited Add);
end;

function TspQuickButtonItems.Insert(Index: Integer): TspQuickButtonItem;
begin
  Result := TspQuickButtonItem(inherited Insert(Index));
end;

procedure TspQuickButtonItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

procedure TspQuickButtonItems.Clear;
begin
  inherited Clear;
end;

// Caption Tabs

constructor TspCaptionTab.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FCaption := '';
  FVisible := True;
  Active := False;
  Down := False;
  ItemRect := NullRect;
end;

procedure TspCaptionTab.Assign(Source: TPersistent);
begin
  if Source is TspCaptionTab then
  begin
    FImageIndex := TspCaptionTab(Source).ImageIndex;
    FCaption := TspCaptionTab(Source).Caption;
    FVisible := TspCaptionTab(Source).Visible;
  end
  else
    inherited Assign(Source);
end;

procedure TspCaptionTab.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  Changed(False);
end;

procedure TspCaptionTab.SetVisible(Value: Boolean);
begin
  FVisible := Value;
  Changed(False);
end;


procedure TspCaptionTab.SetCaption(Value: String); 
begin
  FCaption := Value;
  Changed(False);
end;


constructor TspCaptionTabs.Create;
begin
  inherited Create(TspCaptionTab);
  DSF:= ADSF;
end;

function TspCaptionTabs.GetOwner: TPersistent;
begin
  Result := DSF;
end;

procedure TspCaptionTabs.Update(Item: TCollectionItem);
begin
  if DSF = nil then Exit;
  if not (csDesigning in DSF.ComponentState) and
     not (csLoading in DSF.ComponentState)
  then
    begin
      DSF.UpdateFormNC;
    end;
end;

function TspCaptionTabs.GetItem(Index: Integer):  TspCaptionTab;
begin
  Result := TspCaptionTab(inherited GetItem(Index));
end;

procedure TspCaptionTabs.SetItem(Index: Integer; Value:  TspCaptionTab);
begin
  inherited SetItem(Index, Value);
end;

function TspCaptionTabs.Add: TspCaptionTab;
begin
  Result := TspCaptionTab(inherited Add);
end;

function TspCaptionTabs.Insert(Index: Integer): TspCaptionTab;
begin
  Result := TspCaptionTab(inherited Insert(Index));
end;

procedure TspCaptionTabs.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

procedure TspCaptionTabs.Clear;
begin
  inherited Clear;
end;

end.

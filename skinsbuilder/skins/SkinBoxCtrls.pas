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

unit SkinBoxCtrls;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, SkinData, spEffBmp, StdCtrls, SkinCtrlss, ComCtrls, Mask,
  ImgList, spCalendar, SkinMenus;

type
  TspDrawSkinItemEvent = procedure(Cnvs: TCanvas; Index: Integer;
    ItemWidth, ItemHeight: Integer; TxtRect: TRect; State: TOwnerDrawState) of object;

  TspCBButtonX = record
    R: TRect;
    MouseIn: Boolean;
    Down: Boolean;
  end;

  TspOnEditCancelMode = procedure(C: TControl) of object;

  TspCustomEdit = class(TCustomMaskEdit)
  protected
    FOnUp: TNotifyEvent;
    FOnDown: TNotifyEvent;
    FOnKillFocus: TNotifyEvent;
    FDown: Boolean;
    FReadOnly: Boolean;
    FEditTransparent: Boolean;
    FOnEditCancelMode: TspOnEditCancelMode;
    FSysPopupMenu: TspSkinPopupMenu;
    procedure DoUndo(Sender: TObject);
    procedure DoCut(Sender: TObject);
    procedure DoCopy(Sender: TObject);
    procedure DoPaste(Sender: TObject);
    procedure DoDelete(Sender: TObject);
    procedure DoSelectAll(Sender: TObject);
    procedure CreateSysPopupMenu;
    procedure WMAFTERDISPATCH(var Message: TMessage); message WM_AFTERDISPATCH;
    procedure WMCONTEXTMENU(var Message: TWMCONTEXTMENU); message WM_CONTEXTMENU;
    procedure SetEditTransparent(Value: Boolean);
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CNCtlColorEdit(var Message:TWMCTLCOLOREDIT); message  CN_CTLCOLOREDIT;
    procedure CNCtlColorStatic(var Message:TWMCTLCOLORSTATIC); message  CN_CTLCOLORSTATIC;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change; override;
    procedure WMCHAR(var Message:TWMCHAR); message WM_CHAR;
    procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
    procedure WMKeyDown(var Message: TWMSYSKeyDown); message WM_KEYDOWN;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
    procedure WMCut(var Message: TMessage); message WM_Cut;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMClear(var Message: TMessage); message WM_CLEAR;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
    procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMSetFont(var Message: TWMSetFont); message WM_SETFONT;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    property ReadOnly read FReadOnly write FReadOnly;
    property EditTransparent: Boolean read FEditTransparent write SetEditTransparent;
    property OnUp: TNotifyEvent read FOnUp write FOnUp;
    property OnDown: TNotifyEvent read FOnDown write FOnDown;
    property OnEditCancelMode: TspOnEditCancelMode
      read FOnEditCancelMode write FOnEditCancelMode;
  published
    property EditMask;
    property Text;
  end;

  TspSkinNumEdit = class(TspCustomEdit)
  protected
    FOnUpClick: TNotifyEvent;
    FOnDownClick: TNotifyEvent;
    FEditorEnabled: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    function IsValidChar(Key: Char): Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    Float: Boolean;
    constructor Create(AOwner: TComponent);
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property OnUpClick: TNotifyEvent read FOnUpClick write FOnUpClick;
    property OnDownClick: TNotifyEvent read FOnDownClick write FOnDownClick;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  TspSkinCustomEdit = class(TspCustomEdit)
  protected
    FOnButtonClick: TNotifyEvent;
    FButtonRect: TRect;
    FButtonMode: Boolean;
    FButtonDown: Boolean;
    FButtonActive: Boolean;
    FEditRect: TRect;
    ParentImage: TBitMap;
    FMouseIn: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    Picture: TBitMap;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FDefaultWidth: Integer;
    FDefaultHeight: Integer;
    FAlignment: TAlignment;
    procedure SetAlignment(Value: TAlignment);
    procedure SetDefaultWidth(Value: Integer);
    procedure SetDefaultHeight(Value: Integer);
    procedure OnDefaultFontChange(Sender: TObject);
    procedure SetDefaultFont(Value: TFont);
    procedure CalcRects;
    procedure SetButtonMode(Value: Boolean);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetAlphaBlend(AValue: Boolean);
    procedure SetAlphaBlendValue(AValue: Byte);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetSkinData;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure WMNCLBUTTONDOWN(var Message: TWMNCLBUTTONDOWN); message WM_NCLBUTTONDOWN;
    procedure WMNCLBUTTONDBCLK(var Message: TWMNCLBUTTONDOWN); message WM_NCLBUTTONDBLCLK;
    procedure WMNCLBUTTONUP(var Message: TWMNCLBUTTONUP); message WM_NCLBUTTONUP;
    procedure WMNCMOUSEMOVE(var Message: TWMNCMOUSEMOVE); message WM_NCMOUSEMOVE;
    procedure WMMOUSEMOVE(var Message: TWMNCMOUSEMOVE); message WM_MOUSEMOVE;
    procedure WMNCHITTEST(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TMessage); message WM_KILLFOCUS;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure Loaded; override;
  public
    //
    LOffset, ROffset: Integer;
    ClRect: TRect;
    SkinRect, ActiveSkinRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, DisabledFontColor: TColor;
    ActiveFontColor: TColor;
    ButtonRect: TRect;
    ActiveButtonRect: TRect;
    DownButtonRect: TRect;
    UnEnabledButtonRect: TRect;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParentImage;
    procedure Invalidate; override;
    property Text;
    //
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth;
    property DefaultHeight: Integer read FDefaultHeight write SetDefaultHeight;
    property ButtonMode: Boolean read FButtonMode write SetButtonMode;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property AlphaBlend: Boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte
      read FAlphaBlendValue write SetAlphaBlendValue;

    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property ReadOnly;
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Font;
    property Anchors;
    property AutoSelect;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick: TNotifyEvent read FOnButtonClick
                                         write FOnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinEdit = class(TspSkinCustomEdit)
  published
    property Text;
    property DefaultFont;
    property UseSkinFont;
    property DefaultWidth;
    property DefaultHeight;
    property ButtonMode;
    property SkinData;
    property SkinDataName;
    property AlphaBlend;
    property AlphaBlendValue;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property ReadOnly;
    property Align;
    property Alignment;
    property Font;
    property Anchors;
    property AutoSelect;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick: TNotifyEvent read FOnButtonClick
                                         write FOnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinMemo = class(TMemo)
  protected
    FBitMapBG: Boolean;
    FReadOnly: Boolean;
    FMouseIn: Boolean;
    FIndex: Integer;
    ParentImage: TBitMap;
    FSD: TspSkinData;
    FSkinDataName: String;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    Picture: TBitMap;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FVScrollBar: TSpSkinScrollBar;
    FDown: Boolean;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FSysPopupMenu: TspSkinPopupMenu;
    procedure DoUndo(Sender: TObject);
    procedure DoCut(Sender: TObject);
    procedure DoCopy(Sender: TObject);
    procedure DoPaste(Sender: TObject);
    procedure DoDelete(Sender: TObject);
    procedure DoSelectAll(Sender: TObject);
    procedure CreateSysPopupMenu;
    
    procedure OnDefaultFontChange(Sender: TObject);
    procedure SetDefaultFont(Value: TFont);
    procedure SkinNCPaint(C: TCanvas);
    procedure SkinFramePaint(C: TCanvas);

    procedure SetBitMapBG(Value: Boolean);
    procedure UpDateScrollRange;
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure OnVScrollBarChange(Sender: TObject);
    procedure SetSkinData(Value: TspSkinData);
    procedure SetAlphaBlend(AValue: Boolean);
    procedure SetAlphaBlendValue(AValue: Byte);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Change; override; 
    procedure GetSkinData;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CNCtlColorEdit(var Message:TWMCTLCOLOREDIT); message  CN_CTLCOLOREDIT;
    procedure CNCtlColorStatic(var Message:TWMCTLCOLORSTATIC); message  CN_CTLCOLORSTATIC;
    procedure WMCHAR(var Message:TMessage); message WM_CHAR;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMCONTEXTMENU(var Message: TWMCONTEXTMENU); message WM_CONTEXTMENU;
    procedure WMAFTERDISPATCH(var Message: TMessage); message WM_AFTERDISPATCH;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TMessage); message WM_KILLFOCUS;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Message: TMessage); message WM_LBUTTONUP;
    procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMCut(var Message: TMessage); message WM_Cut;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMClear(var Message: TMessage); message WM_CLEAR;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;
  public
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    ClRect: TRect;
    SkinRect, ActiveSkinRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ActiveFontColor: TColor;
    BGColor: TColor;
    ActiveBGColor: TColor;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure SetParentImage;
    procedure Invalidate; override;
  published
    //
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property BitMapBG: Boolean read FBitMapBG write SetBitMapBG;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    property Transparent: Boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte
      read FAlphaBlendValue write SetAlphaBlendValue;
    //
    property ReadOnly read FReadOnly write FReadOnly;
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  TspSkinMemo2 = class(TMemo)
  protected
    FMouseIn: Boolean;
    FIndex: Integer;
    FSD: TspSkinData;
    FSkinDataName: String;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;
    FDown: Boolean;
    FDefaultFont: TFont;
    FUseSkinFont: Boolean;
    FSysPopupMenu: TspSkinPopupMenu;
    procedure DoUndo(Sender: TObject);
    procedure DoCut(Sender: TObject);
    procedure DoCopy(Sender: TObject);
    procedure DoPaste(Sender: TObject);
    procedure DoDelete(Sender: TObject);
    procedure DoSelectAll(Sender: TObject);
    procedure CreateSysPopupMenu;
    procedure OnDefaultFontChange(Sender: TObject);
    procedure SetDefaultFont(Value: TFont);
    procedure UpDateScrollRange;
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarChange(Sender: TObject);
    procedure SetSkinData(Value: TspSkinData);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Change; override;
    procedure GetSkinData;
    procedure WMCONTEXTMENU(var Message: TWMCONTEXTMENU); message WM_CONTEXTMENU;
    procedure WMAFTERDISPATCH(var Message: TMessage); message WM_AFTERDISPATCH;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CNCtlColorEdit(var Message:TWMCTLCOLOREDIT); message  CN_CTLCOLOREDIT;
    procedure WMCHAR(var Message:TMessage); message WM_CHAR;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TMessage); message WM_KILLFOCUS;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Message: TMessage); message WM_LBUTTONUP;
    procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMCut(var Message: TMessage); message WM_Cut;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMClear(var Message: TMessage); message WM_CLEAR;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ActiveFontColor: TColor;
    BGColor: TColor;
    ActiveBGColor: TColor;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData;
    procedure Invalidate; override;
    property BorderStyle;
    property ScrollBars;
  published
    //
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property SkinData: TspSkinData read FSD write SetSkinData;
    property SkinDataName: String read FSkinDataName write FSkinDataName;
    //
    property ReadOnly;
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  TspSkinCustomListBox = class;
  TspListBox = class(TListBox)
  protected
    {$IFDEF VER130}
    FAutoComplete: Boolean;
    FLastTime: Cardinal;
    FFilter: String;
    {$ENDIF}
    FHorizontalExtentValue: Integer;
    function GetState(AItemID: Integer): TOwnerDrawState;
    procedure PaintBGWH(Cnvs: TCanvas; AW, AH, AX, AY: Integer);
    procedure PaintBG(DC: HDC);
    procedure PaintList(DC: HDC);
    procedure PaintColumnsList(DC: HDC);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WndProc(var Message: TMessage); override;
    procedure DrawDefaultItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                           State: TOwnerDrawState);
    procedure DrawSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                           State: TOwnerDrawState);
    procedure DrawStretchSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                           State: TOwnerDrawState);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure PaintWindow(DC: HDC); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Click; override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
    procedure CreateWnd; override;
  public
    SkinListBox: TspSkinCustomListBox;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property HorizontalExtentValue: Integer
      read FHorizontalExtentValue
      write FHorizontalExtentValue;
    {$IFDEF VER130}
    property AutoComplete: Boolean  read FAutoComplete write FAutoComplete; 
    {$ENDIF}  
  end;

  TspSkinCustomListBox = class(TspSkinCustomControl)
  protected
    FUseSkinItemHeight: Boolean;
    //
    FHorizontalExtent: Boolean;
    FStopUpDateHScrollBar: Boolean;
    //
    FRowCount: Integer;
    FGlyph: TBitMap;
    FNumGlyphs: TspSkinPanelNumGlyphs;
    FSpacing: Integer;

    FImages: TCustomImageList;
    FImageIndex: Integer;

    FOnUpButtonClick, FOnDownButtonClick, FOnCheckButtonClick: TNotifyEvent;

    FDefaultItemHeight: Integer;
    FDefaultCaptionHeight: Integer;
    FDefaultCaptionFont: TFont;
    FOnDrawItem: TspDrawSkinItemEvent;
    NewClRect: TRect;
    ListRect: TRect;

    FCaptionMode: Boolean;
    FAlignment: TAlignment;
    Buttons: array[0..2] of TspCBButtonX;
    OldActiveButton, ActiveButton, CaptureButton: Integer;
    NewCaptionRect: TRect;

    FOnListBoxClick: TNotifyEvent;
    FOnListBoxDblClick: TNotifyEvent;
    FOnListBoxMouseDown: TMouseEvent;
    FOnListBoxMouseMove: TMouseMoveEvent;
    FOnListBoxMouseUp: TMouseEvent;

    FOnListBoxKeyDown: TKeyEvent;
    FOnListBoxKeyPress: TKeyPressEvent;
    FOnListBoxKeyUp: TKeyEvent;

    TimerMode: Integer;
    WaitMode: Boolean;

    function GetOnListBoxDragDrop: TDragDropEvent;
    procedure SetOnListBoxDragDrop(Value: TDragDropEvent);
    function GetOnListBoxDragOver: TDragOverEvent;
    procedure SetOnListBoxDragOver(Value: TDragOverEvent);
    function GetOnListBoxStartDrag: TStartDragEvent;
    procedure SetOnListBoxStartDrag(Value: TStartDragEvent);
    function GetOnListBoxEndDrag: TEndDragEvent;
    procedure SetOnListBoxEndDrag(Value: TEndDragEvent);
    function GetListBoxDragMode: TDragMode;
    procedure SetListBoxDragMode(Value: TDragMode);
    function GetListBoxDragKind: TDragKind;
    procedure SetListBoxDragKind(Value: TDragKind);
    function GetListBoxDragCursor: TCursor;
    procedure SetListBoxDragCursor(Value: TCursor);

    function GetFullItemWidth(Index: Integer; ACnvs: TCanvas): Integer; virtual;

    procedure SetHorizontalExtent(Value: Boolean);
    function  GetColumns: Integer;
    procedure SetColumns(Value: Integer);

    procedure SetRowCount(Value: Integer);
    procedure SetImages(Value: TCustomImageList);
    procedure SetImageIndex(Value: Integer);
    procedure SetGlyph(Value: TBitMap);
    procedure SetNumGlyphs(Value: TspSkinPanelNumGlyphs);
    procedure SetSpacing(Value: Integer);

    procedure StartTimer;
    procedure StopTimer;

    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure DrawButton(Cnvs: TCanvas; i: Integer);
    procedure TestActive(X, Y: Integer);
    //
    procedure ListBoxMouseDown(Button: TMouseButton; Shift: TShiftState;
                               X, Y: Integer); virtual;
    procedure ListBoxMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure ListBoxMouseUp(Button: TMouseButton; Shift: TShiftState;
                             X, Y: Integer); virtual;
    procedure ListBoxClick; virtual;
    procedure ListBoxDblClick; virtual;
    procedure ListBoxKeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure ListBoxKeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure ListBoxKeyPress(var Key: Char); virtual;
    procedure ListBoxEnter; virtual;
    procedure ListBoxExit; virtual;
    //
    procedure ShowScrollBar;
    procedure HideScrollBar;

    procedure ShowHScrollBar;
    procedure HideHScrollBar;

    procedure GetSkinData; override;
    procedure CalcRects;
    procedure SBChange(Sender: TObject);
    procedure HSBChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    //
    procedure DefaultFontChange; override;
    procedure OnDefaultCaptionFontChange(Sender: TObject);
    procedure SetDefaultCaptionHeight(Value: Integer);
    procedure SetDefaultCaptionFont(Value: TFont);
    procedure SetDefaultItemHeight(Value: Integer);
    procedure SetCaptionMode(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(Value: Boolean);
    function GetListBoxFont: TFont;
    procedure SetListBoxFont(Value: TFont);
    function GetListBoxTabOrder: TTabOrder;
    procedure SetListBoxTabOrder(Value: TTabOrder);
    function GetListBoxTabStop: Boolean;
    procedure SetListBoxTabStop(Value: Boolean);
    //
    function GetCanvas: TCanvas;
    function GetExtandedSelect: Boolean;
    procedure SetExtandedSelect(Value: Boolean);
    function GetSelCount: Integer;
    function GetSelected(Index: Integer): Boolean;
    procedure SetSelected(Index: Integer; Value: Boolean);
    function GetSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    function GetTopIndex: Integer;
    procedure SetTopIndex(Value: Integer);
    function GetListBoxPopupMenu: TPopupMenu;
    procedure SetListBoxPopupMenu(Value: TPopupMenu);

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure ListBoxWProc(var Message: TMessage; var Handled: Boolean); virtual;
    procedure ListBoxCreateWnd; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetAutoComplete: Boolean;
    procedure SetAutoComplete(Value: Boolean);
  public
    ScrollBar: TspSkinScrollBar;
    HScrollBar: TspSkinScrollBar;
    ListBox: TspListBox;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, ActiveFontColor, FocusFontColor: TColor;

    CaptionRect: TRect;
    CaptionFontName: String;
    CaptionFontStyle: TFontStyles;
    CaptionFontHeight: Integer;
    CaptionFontColor: TColor;
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    CheckButtonRect, ActiveCheckButtonRect, DownCheckButtonRect: TRect;

    VScrollBarName, HScrollBarName, BothScrollBarName: String;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpDateScrollBar;
    function CalcHeight(AItemsCount: Integer): Integer;
    //
    procedure Clear;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
    function ItemRect(Item: Integer): TRect;
    //
    property Columns: Integer read GetColumns write SetColumns;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property ListBoxCanvas: TCanvas read GetCanvas;
    property SelCount: Integer read GetSelCount;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property UseSkinItemHeight: Boolean
     read FUseSkinItemHeight write FUseSkinItemHeight;
    //
    property DefaultCaptionHeight: Integer
      read FDefaultCaptionHeight  write SetDefaultCaptionHeight;
    property DefaultCaptionFont: TFont
     read FDefaultCaptionFont  write SetDefaultCaptionFont;

    property CaptionMode: Boolean read FCaptionMode
                                         write SetCaptionMode;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property DefaultItemHeight: Integer read FDefaultItemHeight
                                        write SetDefaultItemHeight;
    property Items: TStrings read GetItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property ListBoxFont: TFont read GetListBoxFont write SetListBoxFont;
    property ListBoxTabOrder: TTabOrder read GetListBoxTabOrder write SetListBoxTabOrder;
    property ListBoxTabStop: Boolean read GetListBoxTabStop write SetListBoxTabStop;
    property ExtandedSelect: Boolean read GetExtandedSelect write SetExtandedSelect;
    property Sorted: boolean read GetSorted write SetSorted;
    property ListBoxPopupMenu: TPopupMenu read GetListBoxPopupMenu write SetListBoxPopupMenu;
    property  HorizontalExtent: Boolean
      read FHorizontalExtent
      write SetHorizontalExtent;
    property ListBoxDragMode: TDragMode read GetListBoxDragMode write SetListBoxDragMode;
    property ListBoxDragKind: TDragKind read GetListBoxDragKind write SetListBoxDragKind;
    property ListBoxDragCursor: TCursor read GetListBoxDragCursor write SetListBoxDragCursor;
    property AutoComplete: Boolean read GetAutoComplete write SetAutoComplete;
    property Caption;
    property Font;
    property Align;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;

    property Visible;

    property RowCount: Integer read FRowCount write SetRowCount;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;

    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspSkinPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Spacing: Integer read FSpacing write SetSpacing;

    property OnClick;
    property OnUpButtonClick: TNotifyEvent read FOnUpButtonClick
                                           write FOnUpButtonClick;
    property OnDownButtonClick: TNotifyEvent read FOnDownButtonClick
                                           write FOnDownButtonClick;
    property OnCheckButtonClick: TNotifyEvent read FOnCheckButtonClick
                                           write FOnCheckButtonClick;
    property OnCanResize;
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
    property OnListBoxClick: TNotifyEvent read FOnListBoxClick write FOnListBoxClick;
    property OnListBoxDblClick: TNotifyEvent read FOnListBoxDblClick write FOnListBoxDblClick;
    property OnListBoxMouseDown: TMouseEvent read FOnListBoxMouseDown write
     FOnListBoxMouseDown;
    property OnListBoxMouseMove: TMouseMoveEvent read FOnListBoxMouseMove
      write FOnListBoxMouseMove;
    property OnListBoxMouseUp: TMouseEvent read FOnListBoxMouseUp
      write FOnListBoxMouseUp;
    property OnListBoxKeyDown: TKeyEvent read FOnListBoxKeyDown write FOnListBoxKeyDown;
    property OnListBoxKeyPress: TKeyPressEvent read FOnListBoxKeyPress write FOnListBoxKeyPress;
    property OnListBoxKeyUp: TKeyEvent read FOnListBoxKeyUp write FOnListBoxKeyUp;
    property OnDrawItem: TspDrawSkinItemEvent read FOnDrawItem write FOnDrawItem;
    property OnListBoxDragDrop: TDragDropEvent read GetOnListBoxDragDrop
      write SetOnListBoxDragDrop;
    property OnListBoxDragOver: TDragOverEvent read GetOnListBoxDragOver
      write SetOnListBoxDragOver;
    property OnListBoxStartDrag: TStartDragEvent read GetOnListBoxStartDrag
      write SetOnListBoxStartDrag;
    property OnListBoxEndDrag: TEndDragEvent read GetOnListBoxEndDrag
      write SetOnListBoxEndDrag;
  end;

  TspSkinListBox = class(TspSkinCustomListBox)
  published
    property UseSkinItemHeight;
    property HorizontalExtent;
    property Columns;
    property RowCount;
    property Images;
    property ImageIndex;
    property Glyph;
    property NumGlyphs;
    property Spacing;
    property CaptionMode;
    property DefaultCaptionHeight;
    property DefaultCaptionFont;
    property Alignment;
    property DefaultItemHeight;
    property Items;
    property ItemIndex;
    property MultiSelect;
    property ListBoxFont;
    property ListBoxTabOrder;
    property ListBoxTabStop;
    property ListBoxDragMode;
    property ListBoxDragKind;
    property ListBoxDragCursor;
    property ExtandedSelect;
    property Sorted;
    property ListBoxPopupMenu;
    //
    property Caption;
    property Font;
    property Align;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnClick;
    property Visible;
    property OnUpButtonClick;
    property OnDownButtonClick;
    property OnCheckButtonClick;
    property OnCanResize;
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
    property OnListBoxClick;
    property OnListBoxDblClick;
    property OnListBoxMouseDown;
    property OnListBoxMouseMove;
    property OnListBoxMouseUp;
    property OnListBoxKeyDown;
    property OnListBoxKeyPress;
    property OnListBoxKeyUp;
    property OnDrawItem;
    property OnListBoxDragDrop;
    property OnListBoxDragOver;
    property OnListBoxStartDrag;
    property OnListBoxEndDrag;
  end;

  TspSkinScrollBox = class(TspSkinCustomControl)
  protected
    FInCheckScrollBars: Boolean;
    FDown: Boolean;
    FVScrollBar: TspSkinScrollBar;
    FHScrollBar: TspSkinScrollBar;
    FOldVScrollBarPos: Integer;
    FOldHScrollBarPos: Integer;
    FVSizeOffset: Integer;
    FHSizeOffset: Integer;
    FBorderStyle: TspSkinBorderStyle;
    procedure SetBorderStyle(Value: TspSkinBorderStyle);
    procedure SetVScrollBar(Value: TspSkinScrollBar);
    procedure SetHScrollBar(Value: TspSkinScrollBar);
    procedure VScrollControls(AOffset: Integer);
    procedure HScrollControls(AOffset: Integer);

    procedure OnHScrollBarChange(Sender: TObject);
    procedure OnVScrollBarChange(Sender: TObject);
    procedure OnHScrollBarLastChange(Sender: TObject);
    procedure OnVScrollBarLastChange(Sender: TObject);

    procedure Notification(AComponent: TComponent;
     Operation: TOperation); override;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure PaintFrame(C: TCanvas);
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetSkinData; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure ChangeSkinData; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    BGPictureIndex: Integer;
    procedure HScroll(APosition: Integer);
    procedure VScroll(APosition: Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
    procedure GetHRange;
    procedure GetVRange;
    procedure UpdateScrollRange; 
  published
    property HScrollBar: TspSkinScrollBar read FHScrollBar
                                          write SetHScrollBar;
    property VScrollBar: TspSkinScrollBar read FVScrollBar
                                          write SetVScrollBar;
    property BorderStyle: TspSkinBorderStyle
      read FBorderStyle write SetBorderStyle;
    property Align;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
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
  end;

  TCloseUpEvent = procedure (Sender: TObject; Accept: Boolean) of object;
  TPopupAlign = (epaRight, epaLeft);


  TspPopupListBox = class(TspSkinListBox)
  private
    FOldAlphaBlend: Boolean;
    FOldAlphaBlendValue: Byte;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
    procedure Show(Origin: TPoint);
  end;


  TspCBItem = record
    R: TRect;
    State: TOwnerDrawState;
  end;

  TspSkinCustomComboBoxStyle = (spcbEditStyle, spcbFixedStyle);

  TspSkinCustomComboBox = class(TspSkinCustomControl)
  protected
    FHideSelection: Boolean;
    FLastTime: Cardinal;
    FFilter: String;
    FAutoComplete: Boolean;

    FListBoxAlphaBlend: Boolean;
    FListBoxAlphaBlendAnimation: Boolean;
    FListBoxAlphaBlendValue: Byte;

    FStyle: TspSkinCustomComboBoxStyle;

    FOnChange: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;

    FOnListBoxDrawItem: TspDrawSkinItemEvent;
    FOnComboBoxDrawItem: TspDrawSkinItemEvent;

    FMouseIn: Boolean;
    FOldItemIndex: Integer;
    FDropDownCount: Integer;
    FLBDown: Boolean;
    FListBoxWindowProc: TWndMethod;
    FEditWindowProc: TWndMethod;
    //
    FListBox: TspPopupListBox;
    //
    CBItem: TspCBItem;
    Button: TspCBButtonX;
    FEdit: TspCustomEdit;
    FromEdit: Boolean;

    procedure FindLBItem(S: String);
    procedure FindLBItemFromEdit;
    function GetSelStart: Integer;
    procedure SetSelStart(Value: Integer);
    function GetSelLength: Integer;
    procedure SetSelLength(Value: Integer);

    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    
    function GetImages: TCustomImageList;
    function GetImageIndex: Integer;
    procedure SetImages(Value: TCustomImageList);
    procedure SetImageIndex(Value: Integer);

    function GetHorizontalExtent: Boolean;
    procedure SetHorizontalExtent(Value: Boolean);

    function GetListBoxUseSkinItemHeight: Boolean;
    procedure SetListBoxUseSkinItemHeight(Value: Boolean);

    procedure EditCancelMode(C: TControl);
    function GetListBoxDefaultFont: TFont;
    procedure SetListBoxDefaultFont(Value: TFont);
    function GetListBoxDefaultCaptionFont: TFont;
    procedure SetListBoxDefaultCaptionFont(Value: TFont);
    function GetListBoxDefaultItemHeight: Integer;
    procedure SetListBoxDefaultItemHeight(Value: Integer);
    function GetListBoxCaptionAlignment: TAlignment;
    procedure SetListBoxCaptionAlignment(Value: TAlignment);


    procedure CheckButtonClick(Sender: TObject);

    procedure SetListBoxCaption(Value: String);
    function  GetListBoxCaption: String;
    procedure SetListBoxCaptionMode(Value: Boolean);
    function  GetListBoxCaptionMode: Boolean;

    procedure ListBoxDrawItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);

    function GetSorted: Boolean;
    procedure SetSorted(Value: Boolean);

    procedure SetStyle(Value: TspSkinCustomComboBoxStyle);
    procedure DrawDefaultItem(Cnvs: TCanvas);
    procedure DrawSkinItem(Cnvs: TCanvas);

    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);

    procedure ListBoxWindowProcHook(var Message: TMessage);
    procedure EditWindowProcHook(var Message: TMessage);
    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;

    procedure SetListBoxDrawItem(Value: TspDrawSkinItemEvent);
    procedure SetDropDownCount(Value: Integer);
    procedure EditChange(Sender: TObject);
    procedure EditUp(AChange: Boolean);
    procedure EditDown(AChange: Boolean);
    procedure EditUp1(AChange: Boolean);
    procedure EditDown1(AChange: Boolean);
    procedure EditPageUp1(AChange: Boolean);
    procedure EditPageDown1(AChange: Boolean);
    procedure ShowEditor;
    procedure HideEditor;
    procedure DrawButton(C: TCanvas);
    procedure CalcRects;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
              X, Y: Integer);
    procedure ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

    procedure GetSkinData; override;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    procedure DefaultFontChange; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Change; virtual;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, FocusFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect, UnEnabledButtonRect: TRect;
    ListBoxName: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure CloseUp(Value: Boolean);
    procedure DropDown;
    function IsPopupVisible: Boolean;
    function CanCancelDropDown: Boolean;
    procedure Invalidate; override;
  public
    property HideSelection: Boolean
      read FHideSelection write FHideSelection;
    property AutoComplete: Boolean read FAutoComplete write FAutoComplete;
    property ListBoxAlphaBlend: Boolean read FListBoxAlphaBlend write FListBoxAlphaBlend;
    property ListBoxAlphaBlendAnimation: Boolean
      read FListBoxAlphaBlendAnimation write FListBoxAlphaBlendAnimation;
    property ListBoxAlphaBlendValue: Byte read FListBoxAlphaBlendValue write FListBoxAlphaBlendValue;

    property ListBoxUseSkinItemHeight: Boolean
      read GetListBoxUseSkinItemHeight write SetListBoxUseSkinItemHeight;
      
    property Images: TCustomImageList read GetImages write SetImages;
    property ImageIndex: Integer read GetImageIndex write SetImageIndex;

    property ListBoxCaption: String read GetListBoxCaption
                                    write SetListBoxCaption;
    property ListBoxCaptionMode: Boolean read GetListBoxCaptionMode
                                    write SetListBoxCaptionMode;

    property ListBoxDefaultFont: TFont
      read GetListBoxDefaultFont write SetListBoxDefaultFont;
    property ListBoxDefaultCaptionFont: TFont
      read GetListBoxDefaultCaptionFont write SetListBoxDefaultCaptionFont;
    property ListBoxDefaultItemHeight: Integer
      read GetListBoxDefaultItemHeight write SetListBoxDefaultItemHeight;
    property ListBoxCaptionAlignment: TAlignment
      read GetListBoxCaptionAlignment write SetListBoxCaptionAlignment;

    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    //
    property Text;
    property Align;
    property Items: TStrings read GetItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount;
    property HorizontalExtent: Boolean
      read GetHorizontalExtent write SetHorizontalExtent;
    property Font;
    property Sorted: boolean read GetSorted write SetSorted;
    property Style: TspSkinCustomComboBoxStyle read FStyle write SetStyle;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property OnListBoxDrawItem: TspDrawSkinItemEvent
      read FOnListBoxDrawItem write SetListBoxDrawItem;
    property OnComboBoxDrawItem: TspDrawSkinItemEvent
      read FOnComboBoxDrawItem write FOnComboBoxDrawItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

  TspSkinComboBox = class(TspSkinCustomComboBox)
  published
    property HideSelection;
    property AutoComplete;
    property ListBoxUseSkinItemHeight;

    property ListBoxAlphaBlend;
    property ListBoxAlphaBlendAnimation;
    property ListBoxAlphaBlendValue;

    property TabStop;
    property HorizontalExtent;
    property Images;
    property ImageIndex;
    property ListBoxCaption;
    property ListBoxCaptionMode;
    property ListBoxDefaultFont;
    property ListBoxDefaultCaptionFont;
    property ListBoxDefaultItemHeight;
    property ListBoxCaptionAlignment;

    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    //
    property Text;
    property Align;
    property Items;
    property ItemIndex;
    property DropDownCount;
    property Font;
    property Sorted;
    property Style;
    property OnListBoxDrawItem;
    property OnComboBoxDrawItem;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
    property OnDropDown;
  end;

  TspColorBoxStyles = (spcbStandardColors, // first sixteen RGBI colors
                       spcbExtendedColors, // four additional reserved colors
                       spcbSystemColors,   // system managed/defined colors
                       spcbIncludeNone,    // include clNone color, must be used with cbSystemColors
                       spcbIncludeDefault, // include clDefault color, must be used with cbSystemColors
                       spcbCustomColor,    // first color is customizable
                       spcbPrettyNames);   // instead of 'clColorNames' you get 'Color Names'
  TspColorBoxStyle = set of TspColorBoxStyles;

  TspSkinColorComboBox = class(TspSkinCustomComboBox)
  private
    FShowNames: Boolean;
    FExStyle: TspColorBoxStyle;
    FNeedToPopulate: Boolean;
    FListSelected: Boolean;
    FDefaultColorColor: TColor;
    FNoneColorColor: TColor;
    FSelectedColor: TColor;
    procedure SetShowNames(Value: Boolean);
    function GetColor(Index: Integer): TColor;
    function GetColorName(Index: Integer): string;
    function GetSelected: TColor;
    procedure SetSelected(const AColor: TColor);
    procedure ColorCallBack(const AName: string);
    procedure SetDefaultColorColor(const Value: TColor);
    procedure SetNoneColorColor(const Value: TColor);
    procedure SetExStyle(AStyle: TspColorBoxStyle);
  protected
    procedure DrawColorItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
    procedure CreateWnd; override;
    function PickCustomColor: Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure OnLBCloseUp(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure PopulateList;
    property Colors[Index: Integer]: TColor read GetColor;
    property ColorNames[Index: Integer]: string read GetColorName;
  published
    property HideSelection;
    property AutoComplete;
    property ListBoxCaption;
    property ListBoxCaptionMode;
    property ListBoxAlphaBlend;
    property ListBoxAlphaBlendValue;
    property ListBoxAlphaBlendAnimation;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    //
    property Align;
    property ItemIndex;
    property DropDownCount;
    property Font;
    property Sorted;
    property OnChange;
    property OnClick;
    //
    property ExStyle: TspColorBoxStyle read FExStyle write SetExStyle
      default [spcbStandardColors, spcbExtendedColors, spcbSystemColors];
    property Selected: TColor read GetSelected write SetSelected default clBlack;
    property DefaultColorColor: TColor read FDefaultColorColor write SetDefaultColorColor default clBlack;
    property NoneColorColor: TColor read FNoneColorColor write SetNoneColorColor default clBlack;
    property ShowNames: Boolean read FShowNames write SetShowNames;
  end;

  TspFontDevice = (fdScreen, fdPrinter, fdBoth);
  TspFontListOption = (foAnsiOnly, foTrueTypeOnly, foFixedPitchOnly,
    foNoOEMFonts, foOEMFontsOnly, foScalableOnly, foNoSymbolFonts);
  TspFontListOptions = set of TspFontListOption;

  TspSkinFontSizeComboBox = class(TspSkinCustomComboBox)
  private
    PixelsPerInch: Integer;
    FFontName: TFontName;
    procedure SetFontName(const Value: TFontName);
    procedure Build;
    function GetSizeValue: Integer;
  public
    property FontName: TFontName read FFontName write SetFontName;
    property SizeValue: Integer read GetSizeValue;
  published
    property HideSelection;
    property AutoComplete;
    property AlphaBlend;
    property AlphaBlendValue;
    property ListBoxCaption;
    property ListBoxCaptionMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    //
    property Align;
    property ItemIndex;
    property DropDownCount;
    property Font;
    property Sorted;
    property Style;
    property OnChange;
    property OnClick;
  end;

  TspSkinFontComboBox = class(TspSkinCustomComboBox)
  protected
    FDevice: TspFontDevice;
    FUpdate: Boolean;
    FUseFonts: Boolean;
    FOptions: TspFontListOptions;
    procedure SetFontName(const NewFontName: TFontName);
    function GetFontName: TFontName;
    function GetTrueTypeOnly: Boolean;
    procedure SetDevice(Value: TspFontDevice);
    procedure SetOptions(Value: TspFontListOptions);
    procedure SetTrueTypeOnly(Value: Boolean);
    procedure SetUseFonts(Value: Boolean);
    procedure Reset;
    procedure WMFontChange(var Message: TMessage); message WM_FONTCHANGE;

    procedure DrawLBFontItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);

    procedure DrawCBFontItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
    procedure CreateWnd; override;

    procedure DrawTT(Cnvs: TCanvas; X, Y: Integer; C: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    procedure PopulateList;
  published
    property HideSelection;
    property AutoComplete;
    property ListBoxCaption;
    property ListBoxCaptionMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property Device: TspFontDevice read FDevice write SetDevice default fdScreen;
    property FontName: TFontName read GetFontName write SetFontName;
    property Options: TspFontListOptions read FOptions write SetOptions default [];
    property TrueTypeOnly: Boolean read GetTrueTypeOnly write SetTrueTypeOnly
      stored False;
    property UseFonts: Boolean read FUseFonts write SetUseFonts default False;
    property Align;
    property ItemIndex;
    property DropDownCount;
    property Font;
    property Sorted;
    property Style;
    property OnChange;
    property OnClick;
  end;

  TspValueType = (vtInteger, vtFloat);

  TspSkinSpinEdit = class(TspSkinCustomControl)
  private
    FMouseIn: Boolean;
    FEditFocused: Boolean;
    StopCheck: Boolean;
    FDecimal: Byte;
    FMinValue, FMaxValue, FIncrement: Double;
    FromEdit: Boolean;
    FValueType: TspValueType;
    FOnChange: TNotifyEvent;
    FValue: Double;
    OldActiveButton, ActiveButton, CaptureButton: Integer;
    TimerMode: Integer;
    WaitMode: Boolean;
    procedure StartTimer;
    procedure StopTimer;
    procedure SetValue(AValue: Double);
    procedure SetMinValue(AValue: Double);
    procedure SetMaxValue(AValue: Double);
    procedure SetEditorEnabled(AValue: Boolean);
    function  GetEditorEnabled: Boolean;
    procedure SetMaxLength(AValue: Integer);
    function  GetMaxLength: Integer;
    procedure SetValueType(NewType: TspValueType);
    procedure SetDecimal(NewValue: Byte);
   protected
    Buttons: array[0..1] of TspCBButtonX;
    FOnEditKeyDown: TKeyEvent;
    FOnEditKeyPress: TKeyPressEvent;
    FOnEditKeyUp: TKeyEvent;
    FOnEditEnter: TNotifyEvent;
    FOnEditExit: TNotifyEvent;

    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure EditKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure EditEnter(Sender: TObject); virtual;
    procedure EditExit(Sender: TObject); virtual;
    procedure EditMouseEnter(Sender: TObject);
    procedure EditMouseLeave(Sender: TObject); 

    procedure UpClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    function CheckValue (NewValue: Double): Double;
    procedure EditChange(Sender: TObject);
    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure TestActive(X, Y: Integer);
    procedure CalcRects;
    procedure DrawButton(Cnvs: TCanvas; i: Integer);
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure GetSkinData; override;
    procedure DefaultFontChange; override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure Change; virtual;

  public
    ActiveSkinRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, DisabledFontColor, ActiveFontColor: TColor;
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    LOffset, ROffset: Integer;
    //
    FEdit: TspSkinNumEdit;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    function IsNumText(AText: String): Boolean;
    procedure ChangeSkinData; override;
    property Text;
    procedure SimpleSetValue(AValue: Double);
  published
    property Enabled;
    property ValueType: TspValueType read FValueType write SetValueType;
    property Decimal: Byte read FDecimal write SetDecimal default 2;
    property Align;
    property MinValue: Double read FMinValue write SetMinValue;
    property MaxValue: Double read FMaxValue write SetMaxValue;
    property Value: Double read FValue write SetValue;
    property Increment: Double read FIncrement write FIncrement;
    property EditorEnabled: Boolean read GetEditorEnabled write SetEditorEnabled;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnEditKeyDown: TKeyEvent read FOnEditKeyDown write FOnEditKeyDown;
    property OnEditKeyPress: TKeyPressEvent read FOnEditKeyPress write FOnEditKeyPress;
    property OnEditKeyUp: TKeyEvent read FOnEditKeyUp write FOnEditKeyUp;
    property OnEditEnter: TNotifyEvent read FOnEditEnter write FOnEditEnter;
    property OnEditExit: TNotifyEvent read FOnEditExit write FOnEditExit;
  end;

  TspSkinNumericEdit = class(TspSkinCustomEdit)
  private
    StopCheck, FromEdit: Boolean;
    FMinValue, FMaxValue, FValue: Double;
    FDecimal: Byte;
    FValueType: TspValueType;
    procedure SetValue(AValue: Double);
    procedure SetMinValue(AValue: Double);
    procedure SetMaxValue(AValue: Double);
    procedure SetDecimal(NewValue: Byte);
    procedure SetValueType(NewType: TspValueType);
  protected
    function CheckValue(NewValue: Double): Double;
    procedure KeyPress(var Key: Char); override;
    function IsValidChar(Key: Char): Boolean;
    procedure Change; override;
    property Text;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsNumText(AText: String): Boolean;
  published
    property Decimal: Byte read FDecimal write SetDecimal default 2;
    property ValueType: TspValueType read FValueType write SetValueType;
    property MinValue: Double read FMinValue write SetMinValue;
    property MaxValue: Double read FMaxValue write SetMaxValue;
    property Value: Double read FValue write SetValue;
    property DefaultFont;
    property DefaultWidth;
    property DefaultHeight;
    property ButtonMode;
    property SkinData;
    property SkinDataName;
    property OnMouseEnter;
    property OnMouseLeave;
    property ReadOnly;
    property Align;
    property Font;
    property Anchors;
    property AutoSelect;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinCheckListBox = class;
  TspCheckListBox = class(TListBox)
  protected
    {$IFDEF VER130}
    FAutoComplete: Boolean;
    FLastTime: Cardinal;
    FFilter: String;
    {$ENDIF}
    FSaveStates: TList;
    FOnClickCheck: TNotifyEvent;

    procedure SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);

    procedure PaintBGWH(Cnvs: TCanvas; AW, AH, AX, AY: Integer);
    function CreateWrapper(Index: Integer): TObject;
    function GetWrapper(Index: Integer): TObject;
    function HaveWrapper(Index: Integer): Boolean;
    function ExtractWrapper(Index: Integer): TObject;

    procedure InvalidateCheck(Index: Integer);

    procedure SetChecked(Index: Integer; Checked: Boolean);
    function GetChecked(Index: Integer): Boolean;
    procedure SetState(Index: Integer; AState: TCheckBoxState);
    function GetState(Index: Integer): TCheckBoxState;

    function GetState1(AItemID: Integer): TOwnerDrawState;

    procedure ToggleClickCheck(Index: Integer);

    procedure DeleteString(Index: Integer); override;
    procedure ResetContent; override;

    procedure SetItemData(Index: Integer; AData: LongInt); override;
    function GetItemData(Index: Integer): LongInt; override;

    procedure PaintBG(DC: HDC);
    procedure PaintList(DC: HDC);
    procedure PaintColumnsList(DC: HDC);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WndProc(var Message: TMessage); override;
    procedure DrawDefaultItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                           State1: TOwnerDrawState);
    procedure DrawSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                           State1: TOwnerDrawState);
    procedure DrawStretchSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                                  State1: TOwnerDrawState);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure PaintWindow(DC: HDC); override;
    procedure WMDestroy(var Msg : TWMDestroy);message WM_DESTROY;
    procedure DestroyWnd; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Click; override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
    procedure CreateWnd; override;

  public
    SkinListBox: TspSkinCheckListBox;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property State[Index: Integer]: TCheckBoxState read GetState write SetState;
    {$IFDEF VER130}
    property AutoComplete: Boolean  read FAutoComplete write FAutoComplete; 
    {$ENDIF}
    property OnClickCheck: TNotifyEvent read FOnClickCheck write FOnClickCheck;
  end;

  TspSkinCheckListBox = class(TspSkinCustomControl)
  protected
    FUseSkinItemHeight: Boolean;
    
    FRowCount: Integer;
    FImages: TCustomImageList;
    FImageIndex: Integer;

    FGlyph: TBitMap;
    FNumGlyphs: TspSkinPanelNumGlyphs;
    FSpacing: Integer;

    FOnUpButtonClick, FOnDownButtonClick, FOnCheckButtonClick: TNotifyEvent;

    FOnClickCheck: TNotifyEvent;

    FDefaultItemHeight: Integer;

    FOnDrawItem: TspDrawSkinItemEvent;

    NewClRect: TRect;

    ListRect: TRect;

    FDefaultCaptionHeight: Integer;
    FDefaultCaptionFont: TFont;

    FOnListBoxClick: TNotifyEvent;
    FOnListBoxDblClick: TNotifyEvent;
    FOnListBoxMouseDown: TMouseEvent;
    FOnListBoxMouseMove: TMouseMoveEvent;
    FOnListBoxMouseUp: TMouseEvent;

    FOnListBoxKeyDown: TKeyEvent;
    FOnListBoxKeyPress: TKeyPressEvent;
    FOnListBoxKeyUp: TKeyEvent;

    FCaptionMode: Boolean;
    FAlignment: TAlignment;
    Buttons: array[0..2] of TspCBButtonX;
    OldActiveButton, ActiveButton, CaptureButton: Integer;
    NewCaptionRect: TRect;

    TimerMode: Integer;
    WaitMode: Boolean;

    function GetOnListBoxDragDrop: TDragDropEvent;
    procedure SetOnListBoxDragDrop(Value: TDragDropEvent);
    function GetOnListBoxDragOver: TDragOverEvent;
    procedure SetOnListBoxDragOver(Value: TDragOverEvent);
    function GetOnListBoxStartDrag: TStartDragEvent;
    procedure SetOnListBoxStartDrag(Value: TStartDragEvent);
    function GetOnListBoxEndDrag: TEndDragEvent;
    procedure SetOnListBoxEndDrag(Value: TEndDragEvent);
    function GetListBoxDragMode: TDragMode;
    procedure SetListBoxDragMode(Value: TDragMode);
    function GetListBoxDragKind: TDragKind;
    procedure SetListBoxDragKind(Value: TDragKind);
    function GetListBoxDragCursor: TCursor;
    procedure SetListBoxDragCursor(Value: TCursor);

    function  GetColumns: Integer;
    procedure SetColumns(Value: Integer);

    procedure SetRowCount(Value: Integer);
    procedure SetImages(Value: TCustomImageList);
    procedure SetImageIndex(Value: Integer);
    procedure SetGlyph(Value: TBitMap);
    procedure SetNumGlyphs(Value: TspSkinPanelNumGlyphs);
    procedure SetSpacing(Value: Integer);

    procedure StartTimer;
    procedure StopTimer;

    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure TestActive(X, Y: Integer);
    procedure DrawButton(Cnvs: TCanvas; i: Integer);

    procedure ListBoxOnClickCheck(Sender: TObject);

    procedure SetChecked(Index: Integer; Checked: Boolean);
    function GetChecked(Index: Integer): Boolean;
    procedure SetState(Index: Integer; AState: TCheckBoxState);
    function GetState(Index: Integer): TCheckBoxState;

    procedure ListBoxMouseDown(Button: TMouseButton; Shift: TShiftState;
                               X, Y: Integer); virtual;
    procedure ListBoxMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure ListBoxMouseUp(Button: TMouseButton; Shift: TShiftState;
                             X, Y: Integer); virtual;
    procedure ListBoxClick; virtual;
    procedure ListBoxDblClick; virtual;
    procedure ListBoxKeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure ListBoxKeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure ListBoxKeyPress(var Key: Char); virtual;
    procedure ListBoxEnter; virtual;
    procedure ListBoxExit; virtual;

    procedure ShowScrollBar;
    procedure HideScrollBar;
    procedure GetSkinData; override;
    procedure CalcRects;
    procedure SBChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    //
    procedure OnDefaultCaptionFontChange(Sender: TObject);
    procedure SetDefaultCaptionHeight(Value: Integer);
    procedure SetDefaultCaptionFont(Value: TFont);
    procedure SetDefaultItemHeight(Value: Integer);
    procedure SetCaptionMode(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(Value: Boolean);
    function GetListBoxFont: TFont;
    procedure SetListBoxFont(Value: TFont);
    function GetListBoxTabOrder: TTabOrder;
    procedure SetListBoxTabOrder(Value: TTabOrder);
    function GetListBoxTabStop: Boolean;
    procedure SetListBoxTabStop(Value: Boolean);
    //
    function GetCanvas: TCanvas;
    function GetExtandedSelect: Boolean;
    procedure SetExtandedSelect(Value: Boolean);
    function GetSelCount: Integer;
    function GetSelected(Index: Integer): Boolean;
    procedure SetSelected(Index: Integer; Value: Boolean);
    function GetSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    function GetTopIndex: Integer;
    procedure SetTopIndex(Value: Integer);
    function GetListBoxPopupMenu: TPopupMenu;
    procedure SetListBoxPopupMenu(Value: TPopupMenu);

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetAutoComplete: Boolean;
    procedure SetAutoComplete(Value: Boolean);
  public
    ScrollBar: TspSkinScrollBar;
    ListBox: TspCheckListBox;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, ActiveFontColor, FocusFontColor: TColor;
    UnCheckImageRect, CheckImageRect: TRect;
    ItemCheckRect: TRect;

    CaptionRect: TRect;
    CaptionFontName: String;
    CaptionFontStyle: TFontStyles;
    CaptionFontHeight: Integer;
    CaptionFontColor: TColor;
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    CheckButtonRect, ActiveCheckButtonRect, DownCheckButtonRect: TRect;

    VScrollBarName, HScrollBarName: String;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property State[Index: Integer]: TCheckBoxState read GetState write SetState;

    procedure ChangeSkinData; override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpDateScrollBar;
    function CalcHeight(AItemsCount: Integer): Integer;
    //
    procedure Clear;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
    function ItemRect(Item: Integer): TRect;
    //
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property ListBoxCanvas: TCanvas read GetCanvas;
    property SelCount: Integer read GetSelCount;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
  published
    property UseSkinItemHeight: Boolean
     read FUseSkinItemHeight write FUseSkinItemHeight;
     
    property Columns: Integer read GetColumns write SetColumns;
    property CaptionMode: Boolean read FCaptionMode
                                         write SetCaptionMode;
    property DefaultCaptionHeight: Integer
      read FDefaultCaptionHeight  write SetDefaultCaptionHeight;
    property DefaultCaptionFont: TFont
     read FDefaultCaptionFont  write SetDefaultCaptionFont;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taLeftJustify;
    property DefaultItemHeight: Integer read FDefaultItemHeight
                                        write SetDefaultItemHeight;
    property Items: TStrings read GetItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property ListBoxFont: TFont read GetListBoxFont write SetListBoxFont;
    property ListBoxTabOrder: TTabOrder read GetListBoxTabOrder write SetListBoxTabOrder;
    property ListBoxTabStop: Boolean read GetListBoxTabStop write SetListBoxTabStop;
    property ListBoxDragMode: TDragMode read GetListBoxDragMode write SetListBoxDragMode;
    property ListBoxDragKind: TDragKind read GetListBoxDragKind write SetListBoxDragKind;
    property ListBoxDragCursor: TCursor read GetListBoxDragCursor write SetListBoxDragCursor;
    property ExtandedSelect: Boolean read GetExtandedSelect write SetExtandedSelect;
    property Sorted: boolean read GetSorted write SetSorted;
    property ListBoxPopupMenu: TPopupMenu read GetListBoxPopupMenu write SetListBoxPopupMenu;
    //
    property AutoComplete: Boolean read GetAutoComplete write SetAutoComplete;
    property Caption;
    property Font;
    property Align;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;

    property Glyph: TBitMap read FGlyph write SetGlyph;
    property NumGlyphs: TspSkinPanelNumGlyphs read FNumGlyphs write SetNumGlyphs;
    property Spacing: Integer read FSpacing write SetSpacing;
    property RowCount: Integer read FRowCount write SetRowCount;

    property OnClick;
    property OnUpButtonClick: TNotifyEvent read FOnUpButtonClick
                                           write FOnUpButtonClick;
    property OnDownButtonClick: TNotifyEvent read FOnDownButtonClick
                                           write FOnDownButtonClick;
    property OnCheckButtonClick: TNotifyEvent read FOnCheckButtonClick
                                           write FOnCheckButtonClick;
    property OnCanResize;
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
    property OnClickCheck: TNotifyEvent read FOnClickCheck write FOnClickCheck;
    property OnListBoxClick: TNotifyEvent read FOnListBoxClick write FOnListBoxClick;
    property OnListBoxDblClick: TNotifyEvent read FOnListBoxDblClick write FOnListBoxDblClick;
    property OnListBoxMouseDown: TMouseEvent read FOnListBoxMouseDown write
     FOnListBoxMouseDown;
    property OnListBoxMouseMove: TMouseMoveEvent read FOnListBoxMouseMove
      write FOnListBoxMouseMove;
    property OnListBoxMouseUp: TMouseEvent read FOnListBoxMouseUp
      write FOnListBoxMouseUp;
    property OnListBoxKeyDown: TKeyEvent read FOnListBoxKeyDown write FOnListBoxKeyDown;
    property OnListBoxKeyPress: TKeyPressEvent read FOnListBoxKeyPress write FOnListBoxKeyPress;
    property OnListBoxKeyUp: TKeyEvent read FOnListBoxKeyUp write FOnListBoxKeyUp;
    property OnDrawItem: TspDrawSkinItemEvent read FOnDrawItem write FOnDrawItem;
    property OnListBoxDragDrop: TDragDropEvent read GetOnListBoxDragDrop
      write SetOnListBoxDragDrop;
    property OnListBoxDragOver: TDragOverEvent read GetOnListBoxDragOver
      write SetOnListBoxDragOver;
    property OnListBoxStartDrag: TStartDragEvent read GetOnListBoxStartDrag
      write SetOnListBoxStartDrag;
    property OnListBoxEndDrag: TEndDragEvent read GetOnListBoxEndDrag
      write SetOnListBoxEndDrag;
  end;

  TspSkinUpDown = class(TspSkinCustomControl)
  protected
    FOrientation: TUDOrientation;
    Buttons: array[0..1] of TspCBButtonX;
    OldActiveButton, ActiveButton, CaptureButton: Integer;
    TimerMode: Integer;
    WaitMode: Boolean;
    //
    FOnUpButtonClick: TNotifyEvent;
    FOnDownButtonClick: TNotifyEvent;
    FOnChange: TNotifyEvent;
    FIncrement: Integer;
    FPosition: Integer;
    FMin: Integer;
    FMax: Integer;
    procedure SetOrientation(Value: TUDOrientation);
    procedure StartTimer;
    procedure StopTimer;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure ButtonDown(I: Integer; X, Y: Integer);
    procedure ButtonUp(I: Integer; X, Y: Integer);
    procedure ButtonEnter(I: Integer);
    procedure ButtonLeave(I: Integer);
    procedure DrawButton(Cnvs: TCanvas; i: Integer);
    procedure TestActive(X, Y: Integer);
    procedure CalcRects;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SetIncrement(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure GetSkinData; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
  public
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Orientation: TUDOrientation read FOrientation
                                         write SetOrientation;
    property Increment: Integer read FIncrement write SetIncrement;
    property Position: Integer read FPosition write SetPosition;
    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnUpButtonClick: TNotifyEvent read FOnUpButtonClick
                                           write FOnUpButtonClick;
    property OnDownButtonClick: TNotifyEvent read FOnDownButtonClick
                                           write FOnDownButtonClick;
  end;


  TspSkinDateEdit = class;

  TspPopupCalendar = class(TspSkinMonthCalendar)
  protected
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TspSkinDateEdit = class(TspSkinCustomEdit)
  private
    FTodayDefault: Boolean;
    StopCheck: Boolean;
    FCalendarAlphaBlend: Boolean;
    FCalendarAlphaBlendValue: Byte;
    FCalendarAlphaBlendAnimation: Boolean;
  protected
    FMonthCalendar: TspPopupCalendar;
    FOnDateChange: TNotifyEvent;
    function GetDateMask: String;
    function GetDate: TDate;
    procedure SetDate(Value: TDate);
    procedure Loaded; override;
    function GetFirstDayOfWeek: TspDaysOfWeek;
    procedure SetFirstDayOfWeek(Value: TspDaysOfWeek);
    procedure SetTodayDefault(Value: Boolean);
    function GetCalendarFont: TFont;
    procedure SetCalendarFont(Value: TFont);
    function GetCalendarWidth: Integer;
    procedure SetCalendarWidth(Value: Integer);
    function GetCalendarHeight: Integer;
    procedure SetCalendarHeight(Value: Integer);
    procedure DropDown;
    procedure CloseUp(AcceptValue: Boolean);
    procedure ButtonClick(Sender: TObject);
    procedure CalendarClick(Sender: TObject);
    procedure WndProc(var Message: TMessage); override;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CheckValidDate;
    procedure Change; override;
    function IsValidText(S: String): Boolean;
    function IsOnlyNumbers(S: String): Boolean;
    function IsMonth(S: String): Boolean;
    function ExtactMonth(ADate: TDate): String;
    function DecodeMonth(S: String): Word;
    function MyStrToDate(S: String): TDate;
    //
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsDateInput: Boolean;
  published
    property Date: TDate read GetDate write SetDate;
    property CalendarAlphaBlend: Boolean read FCalendarAlphaBlend write FCalendarAlphaBlend;
    property TodayDefault: Boolean read FTodayDefault write SetTodayDefault; 

    property CalendarWidth: Integer read GetCalendarWidth write SetCalendarWidth;
    property CalendarHeight: Integer read GetCalendarHeight write SetCalendarHeight;
    property CalendarFont: TFont read GetCalendarFont write SetCalendarFont;

    property CalendarAlphaBlendAnimation: Boolean
      read FCalendarAlphaBlendAnimation write FCalendarAlphaBlendAnimation;
    property CalendarAlphaBlendValue: Byte read FCalendarAlphaBlendValue write FCalendarAlphaBlendValue;

    property DefaultFont;
    property DefaultWidth;
    property DefaultHeight;
    property ButtonMode;
    property SkinData;
    property SkinDataName;
    property AlphaBlend;
    property AlphaBlendValue;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property ReadOnly;
    property Align;
    property Alignment;
    property Font;
    property Anchors;
    property AutoSelect;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick: TNotifyEvent read FOnButtonClick
                                         write FOnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnDateChange: TNotifyEvent read FOnDateChange write FOnDateChange;
  end;

  TspSkinTrackEdit = class;

  TspSkinPopupTrackBar = class(TspSkinTrackBar)
  protected
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    TrackEdit: TspSkinTrackEdit;
    constructor Create(AOwner: TComponent); override;
  end;

  TspTrackBarPopupKind = (tbpRight, tbpLeft);

  TspSkinTrackEdit = class(TspSkinCustomEdit)
  private
    FPopupKind: TspTrackBarPopupKind;
    FTrackBarWidth: Integer;
    FTrackBarSkinDataName: String;
    StopCheck, FromEdit: Boolean;
    FMinValue, FMaxValue, FValue: Integer;
    FPopupTrackBar: TspSkinPopupTrackBar;
    FTrackBarAlphaBlend: Boolean;
    FTrackBarAlphaBlendValue: Byte;
    FTrackBarAlphaBlendAnimation: Boolean;
    function GetJumpWhenClick: Boolean;
    procedure SetJumpWhenClick(Value: Boolean);
    procedure SetValue(AValue: Integer);
    procedure SetMinValue(AValue: Integer);
    procedure SetMaxValue(AValue: Integer);
    procedure ButtonClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure DropDown;
    procedure CloseUp;
  protected
    function CheckValue(NewValue: Integer): Integer;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure KeyPress(var Key: Char); override;
    function IsValidChar(Key: Char): Boolean;
    procedure Change; override;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    property Text;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsNumText(AText: String): Boolean;
  published
    property PopupKind: TspTrackBarPopupKind read FPopupKind write FPopupKind;
    property JumpWhenClick: Boolean
     read GetJumpWhenClick write SetJumpWhenClick;
    property TrackBarWidth: Integer
      read FTrackBarWidth write FTrackBarWidth; 
    property TrackBarAlphaBlend: Boolean read FTrackBarAlphaBlend write FTrackBarAlphaBlend;
    property TrackBarAlphaBlendAnimation: Boolean
      read FTrackBarAlphaBlendAnimation write FTrackBarAlphaBlendAnimation;
    property TrackBarAlphaBlendValue: Byte read FTrackBarAlphaBlendValue write FTrackBarAlphaBlendValue;

    property TrackBarSkinDataName: String
      read FTrackBarSkinDataName write FTrackBarSkinDataName;
    property MinValue: Integer read FMinValue write SetMinValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property Value: Integer read FValue write SetValue;
        property DefaultFont;
    property DefaultWidth;
    property DefaultHeight;
    property ButtonMode;
    property SkinData;
    property SkinDataName;
    property OnMouseEnter;
    property OnMouseLeave;
    property ReadOnly;
    property Align;
    property Font;
    property Anchors;
    property AutoSelect;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinMaskEdit = class(TspSkinEdit)
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinTimeEdit = class(TspSkinMaskEdit)
  private
    fShowMSec: Boolean;
    procedure SetShowMilliseconds(const Value: Boolean);
    procedure SetMilliseconds(const Value: integer);
    function GetMilliseconds: integer;
    procedure SetTime(const Value: string);
    function GetTime: string;
    function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
    function IsValidChar(Key: Char): Boolean;
    procedure CheckSpace(var S: String);
  protected
    procedure HandleOnKeyPress(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DecodeTime(var Hour, Min, Sec, MSec: Word);
    procedure EncodeTime(Hour, Min, Sec, MSec: Word);
    property ShowMSec: Boolean read fShowMSec write SetShowMilliseconds;
    property Milliseconds: integer read GetMilliseconds write SetMilliseconds;
    property Time: string read GetTime write SetTime;
  end;

  TspPasswordKind = (pkRoundRect, pkRect, pkTriangle);

  TspSkinPasswordEdit = class(TspSkinCustomControl)
  private
    FMouseIn: Boolean;
    FText: String;
    FLMouseSelecting: boolean;
    FCaretPosition: integer;
    FSelStart: integer;
    FSelLength: integer;
    FFirstVisibleChar: integer;
    FAutoSelect: boolean;
    FCharCase: TEditCharCase;
    FHideSelection: Boolean;
    FMaxLength: Integer;
    FReadOnly: Boolean;
    FOnChange: TNotifyEvent;
    FPasswordKind: TspPasswordKind;
    FTextAlignment: TAlignment;
    procedure UpdateFirstVisibleChar;
    procedure UpdateCaretePosition;
    procedure UpdateCarete;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    function GetSelText: String;
    function GetVisibleSelText: String;
    function GetNextWordBeging(StartPosition: integer): integer;
    function GetPrivWordBeging(StartPosition: integer): integer;
    function GetSelStart: integer;
    function GetSelLength: integer;
    function GetText: String;
    procedure SetText(const Value: String);
    procedure SetCaretPosition(const Value: integer);
    procedure SetSelLength(const Value: integer);
    procedure SetSelStart(const Value: integer);
    procedure SetAutoSelect(const Value: boolean);
    procedure SetCharCase(const Value: TEditCharCase);
    procedure SetHideSelection(const Value: Boolean);
    procedure SetMaxLength(const Value: Integer);
    procedure SetCursor(const Value: TCursor);
    procedure SetTextAlignment(const Value: TAlignment);
    procedure SetPasswordKind(const Value: TspPasswordKind);
  protected
    function GetEditRect: TRect; virtual;
    function GetPasswordCharWidth: integer; virtual;
    function GetCharX(A: integer): integer;
    function GetCoordinatePosition(x: integer): integer;
    function GetSelRect: TRect; virtual;
    function GetAlignmentFlags: integer;
    procedure PaintText(Cnv: TCanvas);
    procedure PaintSelectedText(Cnv: TCanvas);
    procedure DrawPasswordChar(SymbolRect: TRect; Selected: boolean; Cnv: TCanvas); virtual;

    function ValidText(NewText: String): boolean; virtual;

    procedure HasFocus;
    procedure KillFocus;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; x, y: integer); override;
    procedure MouseMove(Shift: TShiftState; x, y: integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure SelectWord;
    procedure Change; dynamic;
    property CaretPosition: integer read FCaretPosition write SetCaretPosition;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure GetSkinData; override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    //
    LOffset, ROffset: Integer;
    ClRect: TRect;
    SkinRect, ActiveSkinRect: TRect;
    CharColor, CharActiveColor, CharDisabledColor: TColor;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure PasteFromClipboard;

    procedure ShowCaret; virtual;
    procedure HideCaret; virtual;

    procedure ClearSelection;
    procedure SelectAll;
    procedure Clear;

    procedure InsertChar(Ch: Char);
    procedure InsertText(AText: String);
    procedure InsertAfter(Position: integer; S: String; Selected: boolean);
    procedure DeleteFrom(Position, Length : integer; MoveCaret : boolean);

    property SelStart: integer read GetSelStart write SetSelStart;
    property SelLength: integer read GetSelLength write SetSelLength;
    property SelText: String read GetSelText;
  published
    property Anchors;
    property AutoSelect: boolean read FAutoSelect write SetAutoSelect default true;
    property CharCase: TEditCharCase read FCharCase write SetCharCase default ecNormal;
    property Constraints;
    property Color;
    property Cursor write SetCursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ImeMode;
    property ImeName;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property ParentFont;
    property ParentShowHint;
    property PasswordKind: TspPasswordKind read FPasswordKind write SetPasswordKind;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop default true;
    property Text: String read GetText write SetText;
    property TextAlignment : TAlignment read FTextAlignment write SetTextAlignment default taLeftJustify;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TspPopupCheckListBox = class(TspSkinCheckListBox)
  private
    FOldAlphaBlend: Boolean;
    FOldAlphaBlendValue: Byte;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
    procedure Show(Origin: TPoint);
  end;

  TspSkinCustomCheckComboBox = class(TspSkinCustomControl)
  protected
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;

    FOnChange: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;
    FOnDropDown: TNotifyEvent;

    FOnListBoxDrawItem: TspDrawSkinItemEvent;

    FMouseIn: Boolean;
    FDropDownCount: Integer;
    FLBDown: Boolean;
    FListBoxWindowProc: TWndMethod;
    FEditWindowProc: TWndMethod;
    //
    FListBox: TspPopupCheckListBox;
    //
    CBItem: TspCBItem;
    Button: TspCBButtonX;


    procedure CheckText;
    procedure SetChecked(Index: Integer; Checked: Boolean);
    function GetChecked(Index: Integer): Boolean;

    function GetListBoxUseSkinItemHeight: Boolean;
    procedure SetListBoxUseSkinItemHeight(Value: Boolean);

    function GetImages: TCustomImageList;
    function GetImageIndex: Integer;
    procedure SetImages(Value: TCustomImageList);
    procedure SetImageIndex(Value: Integer);

    function GetListBoxDefaultFont: TFont;
    procedure SetListBoxDefaultFont(Value: TFont);

    function GetListBoxUseSkinFont: Boolean;
    procedure SetListBoxUseSkinFont(Value: Boolean);

    function GetListBoxDefaultCaptionFont: TFont;
    procedure SetListBoxDefaultCaptionFont(Value: TFont);
    function GetListBoxDefaultItemHeight: Integer;
    procedure SetListBoxDefaultItemHeight(Value: Integer);
    function GetListBoxCaptionAlignment: TAlignment;
    procedure SetListBoxCaptionAlignment(Value: TAlignment);

    procedure SetListBoxCaption(Value: String);
    function  GetListBoxCaption: String;
    procedure SetListBoxCaptionMode(Value: Boolean);
    function  GetListBoxCaptionMode: Boolean;

    procedure ListBoxDrawItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);

    function GetSorted: Boolean;
    procedure SetSorted(Value: Boolean);

    procedure DrawDefaultItem(Cnvs: TCanvas);
    procedure DrawSkinItem(Cnvs: TCanvas);

    procedure ListBoxWindowProcHook(var Message: TMessage);

    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;

    procedure SetListBoxDrawItem(Value: TspDrawSkinItemEvent);
    procedure SetDropDownCount(Value: Integer);
    procedure DrawButton(C: TCanvas);
    procedure CalcRects;
    procedure WMSETFOCUS(var Message: TMessage); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
              X, Y: Integer);
    procedure GetSkinData; override;
    procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;

    procedure DefaultFontChange; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure Change; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure EditUp1(AChange: Boolean);
    procedure EditDown1(AChange: Boolean);
    procedure EditPageUp1(AChange: Boolean);
    procedure EditPageDown1(AChange: Boolean);

  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, FocusFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect, UnEnabledButtonRect: TRect;
    ListBoxName: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeSkinData; override;
    procedure CloseUp(Value: Boolean);
    procedure DropDown; virtual;
    function IsPopupVisible: Boolean;
    function CanCancelDropDown: Boolean;
    procedure Invalidate; override;
  public
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property Images: TCustomImageList read GetImages write SetImages;
    property ImageIndex: Integer read GetImageIndex write SetImageIndex;
    property ListBoxUseSkinItemHeight: Boolean
      read GetListBoxUseSkinItemHeight write SetListBoxUseSkinItemHeight;
    property ListBoxCaption: String read GetListBoxCaption
                                    write SetListBoxCaption;
    property ListBoxCaptionMode: Boolean read GetListBoxCaptionMode
                                    write SetListBoxCaptionMode;

    property ListBoxDefaultFont: TFont
      read GetListBoxDefaultFont write SetListBoxDefaultFont;

    property ListBoxUseSkinFont: Boolean
      read GetListBoxUseSkinFont write SetListBoxUseSkinFont;
    property ListBoxDefaultCaptionFont: TFont
      read GetListBoxDefaultCaptionFont write SetListBoxDefaultCaptionFont;
    property ListBoxDefaultItemHeight: Integer
      read GetListBoxDefaultItemHeight write SetListBoxDefaultItemHeight;
    property ListBoxCaptionAlignment: TAlignment
      read GetListBoxCaptionAlignment write SetListBoxCaptionAlignment;

    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;

    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    //
    property Text;
    property Align;
    property Items: TStrings read GetItems write SetItems;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount;
    property Font;
    property Sorted: Boolean read GetSorted write SetSorted;
    property OnListBoxDrawItem: TspDrawSkinItemEvent
      read FOnListBoxDrawItem write SetListBoxDrawItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

  TspSkinCheckComboBox = class(TspSkinCustomCheckComboBox)
  published
    property AlphaBlend;
    property AlphaBlendValue;
    property AlphaBlendAnimation;

    property ListBoxUseSkinFont;
    property ListBoxUseSkinItemHeight;
    property Images;
    property ImageIndex;
    property ListBoxCaption;
    property ListBoxCaptionMode;
    property ListBoxDefaultFont;
    property ListBoxDefaultCaptionFont;
    property ListBoxDefaultItemHeight;
    property ListBoxCaptionAlignment;

    property Enabled;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    //
    property Text;
    property Align;
    property Items;
    property DropDownCount;
    property Font;
    property Sorted;
    property OnListBoxDrawItem;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

implementation


Uses spUtils, Consts, Printers, spColorCtrls, Clipbrd, spConst, DynamicSkinForm;

const
  WS_EX_LAYERED = $80000;
  CS_DROPSHADOW_ = $20000;
  
//=========== TspSkinUpDown ===============

constructor TspSkinUpDown.Create;
begin
  inherited;
  SkinDataName := 'hupdown';
  FMin := 0;
  FMax := 100;
  FIncrement := 1;
  FPosition := 0;
  Width := 25;
  Height := 50;
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  TimerMode := 0;
  WaitMode := False;
end;

destructor TspSkinUpDown.Destroy;
begin
  inherited;
end;

procedure TspSkinUpDown.SetOrientation;
begin
  FOrientation := Value;
  RePaint;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FOrientation = udHorizontal
      then FSkinDataName := 'hupdown'
      else FSkinDataName := 'vupdown';
    end;
end;

procedure TspSkinUpDown.CreateControlSkinImage;
var
  i: Integer;
begin
  inherited;
  for i := 0 to 1 do DrawButton(B.Canvas, i);
end;

procedure TspSkinUpDown.WMSIZE;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinUpDown.CreateControlDefaultImage;
var
  i: Integer;
begin
  CalcRects;
  for i := 0 to 1 do DrawButton(B.Canvas, i);
end;

procedure TspSkinUpDown.CMMouseEnter;
begin
  ActiveButton := -1;
  OldActiveButton := -1;
  inherited;
end;

procedure TspSkinUpDown.CMMouseLeave;
var
  i: Integer;
begin
  inherited;
  for i := 0 to 1 do
    if Buttons[i].MouseIn
    then
       begin
         Buttons[i].MouseIn := False;
         RePaint;
       end;
end;

procedure TspSkinUpDown.DrawButton;
var
  C: TColor;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Buttons[i] do
    begin
      R1 := R;
      if Down and MouseIn
      then
        begin
          Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Cnvs.Brush.Color := SP_XP_BTNDOWNCOLOR;
          Cnvs.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR;
            Cnvs.FillRect(R1);
          end
        else
          begin
            Frame3D(Cnvs, R1, clBtnShadow, clBtnShadow, 1);
            Cnvs.Brush.Color := clBtnFace;
            Cnvs.FillRect(R1);
          end;
      C := clBlack;
      if FOrientation = udVertical
      then
        case i of
          0: DrawArrowImage(Cnvs, R, C, 3);
          1: DrawArrowImage(Cnvs, R, C, 4);
        end
      else
        case i of
          1: DrawArrowImage(Cnvs, R, C, 1);
          0: DrawArrowImage(Cnvs, R, C, 2);
        end
    end
  else
    with Buttons[i] do
    begin
      R1 := NullRect;
      case I of
        0:
          begin
            if Down and MouseIn
            then R1 := DownUpButtonRect
            else if MouseIn then R1 := ActiveUpButtonRect;
          end;
        1:
          begin
            if Down and MouseIn
            then R1 := DownDownButtonRect
            else if MouseIn then R1 := ActiveDownButtonRect;
          end
      end;
      if not IsNullRect(R1)
      then
        Cnvs.CopyRect(R, Picture.Canvas, R1);
    end;
end;

procedure TspSkinUpDown.MouseDown;
begin
  TestActive(X, Y);
  if ActiveButton = 0
  then
    OldActiveButton := 1
  else
    OldActiveButton := 0;
  Buttons[OldActiveButton].MouseIn := False;
  if ActiveButton <> -1
  then
    begin
      CaptureButton := ActiveButton;
      ButtonDown(ActiveButton, X, Y);
    end;
  inherited;
end;

procedure TspSkinUpDown.MouseUp;
begin
  if CaptureButton <> -1
  then ButtonUp(CaptureButton, X, Y);
  CaptureButton := -1;
  inherited;
end;

procedure TspSkinUpDown.MouseMove;
begin
  TestActive(X, Y);
  inherited;
end;

procedure TspSkinUpDown.TestActive(X, Y: Integer);
var
  i, j: Integer;
begin
  j := -1;
  OldActiveButton := ActiveButton;
  for i := 0 to 1 do
  begin
    if PointInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinUpDown.ButtonDown;
begin
  Buttons[i].MouseIn := True;
  Buttons[i].Down := True;
  RePaint;
  if FIncrement <> 0
  then
    begin
      case i of
        0: TimerMode := 2;
        1: TimerMode := 1;
      end;
      WaitMode := True;
      SetTimer(Handle, 1, 500, nil);
    end;  
end;

procedure TspSkinUpDown.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  RePaint;
  case i of
    0:
      begin
        if FIncrement <> 0 then Position := Position + FIncrement;
        if Assigned(FOnUpButtonClick) then FOnUpButtonClick(Self);
      end;
     1:
       begin
         if FIncrement <> 0 then Position := Position - FIncrement;
         if Assigned(FOnDownButtonClick) then FOnDownButtonClick(Self);
       end;
  end;

  if FIncrement <> 0 then StopTimer;
end;

procedure TspSkinUpDown.ButtonEnter(I: Integer);
begin
  if i = 0
  then
    OldActiveButton := 1
  else
    OldActiveButton := 0;
  Buttons[OldActiveButton].MouseIn := False;
  Buttons[i].MouseIn := True;
  RePaint;
  if (FIncrement <> 0) and Buttons[i].Down then SetTimer(Handle, 1, 50, nil);
end;

procedure TspSkinUpDown.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  RePaint;
  if (FIncrement <> 0) and Buttons[i].Down then KillTimer(Handle, 1);
end;

procedure TspSkinUpDown.CalcRects;
const
  BW = 15;
var
  OX: Integer;
  NewClRect: TRect;
begin
  if FIndex = -1
  then
    begin
      if FOrientation = udVertical
      then
        begin
          Buttons[0].R := Rect(0, 0, Width, Height div 2);
          Buttons[1].R := Rect(0, Height div 2, Width, Height);
        end
      else
        begin
          Buttons[1].R := Rect(0, 0, Width div 2, Height);
          Buttons[0].R := Rect(Width div 2, 0, Width, Height);
        end;
    end
  else
    begin
      Buttons[0].R := UpButtonRect;
      Buttons[1].R := DownButtonRect;
    end;
end;

procedure TspSkinUpDown.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 100, nil);
end;

procedure TspSkinUpDown.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinUpDown.WMTimer;
var
  CanScroll: Boolean;
begin
  inherited;
  if WaitMode
  then
    begin
      WaitMode := False;
      StartTimer;
      Exit;
    end;
  case TimerMode of
    1: Position := Position - FIncrement;
    2: Position := Position + FIncrement;
  end;
end;

procedure TspSkinUpDown.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinUpDownControl
    then
      with TspDataSkinUpDownControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.UpButtonRect := UpButtonRect;
        Self.ActiveUpButtonRect := ActiveUpButtonRect;
        Self.DownUpButtonRect := DownUpButtonRect;
        if IsNullRect(Self.DownUpButtonRect)
        then Self.DownUpButtonRect := Self.ActiveUpButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.ActiveDownButtonRect := ActiveDownButtonRect;
        Self.DownDownButtonRect := DownDownButtonRect;
        if IsNullRect(Self.DownDownButtonRect)
        then Self.DownDownButtonRect := Self.ActiveDownButtonRect;
        LTPt := Point(0, 0);
        RTPt := Point(0, 0);
        LBPt := Point(0, 0);
        RBPt := Point(0, 0);
        ClRect := NullRect;
      end;
  CalcRects;    
end;

procedure TspSkinUpDown.SetIncrement;
begin
  FIncrement := Value;
end;

procedure TspSkinUpDown.SetPosition;
begin
  if (Value <= FMax) and (Value >= FMin)
  then
    begin
      FPosition := Value;
      if not (csDesigning in ComponentState) and Assigned(FOnChange)
      then
        FOnChange(Self);
    end;

end;

procedure TspSkinUpDown.SetMin;
begin
  FMin := Value;
  if FPosition < FMin then FPosition := FMin;
end;

procedure TspSkinUpDown.SetMax;
begin
  FMax := Value;
  if FPosition > FMax then FPosition := FMax;
end;

constructor TspSkinSpinEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csCaptureMouse, csOpaque, csDoubleClicks, csAcceptsControls];
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  FValue := 0;
  FromEdit := False;
  FEdit := TspSkinNumEdit.Create(Self);
  FEdit.Font.Assign(FDefaultFont);
  FIncrement := 1;
  FDecimal := 2;
  TimerMode := 0;
  WaitMode := False;
  FEdit.Parent := Self;
  FEdit.AutoSize := False;
  FEdit.Visible := True;
  FEdit.EditTransparent := False;
  FEdit.OnChange := EditChange;
  FEdit.OnUpClick := UpClick;
  FEdit.OnDownClick := DownClick;
  FEdit.OnKeyUp := EditKeyUp;
  FEdit.OnKeyDown := EditKeyDown;
  FEdit.OnKeyPress := EditKeyPress;
  FEdit.OnEnter := EditEnter;
  FEdit.OnExit := EditExit;
  FEdit.OnMouseEnter := EditMouseEnter;
  FEdit.OnMouseLeave := EditMouseLeave;
  StopCheck := True;
  Text := '0';
  StopCheck := False;
  Width := 120;
  Height := 20;
  FSkinDataName := 'spinedit';
end;

destructor TspSkinSpinEdit.Destroy;
begin
  FEdit.Free;
  inherited;
end;

procedure TspSkinSpinEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if Focused and (FEdit <> nil) and FEdit.HandleAllocated
  then
    FEdit.SetFocus; 
end;

procedure TspSkinSpinEdit.CMEnabledChanged;
begin
  inherited;
  if not Enabled
  then
    begin
      if FIndex = -1
      then
        FEdit.Font.Color := clGrayText
      else
        FEdit.Font.Color := DisabledFontColor;
    end
  else
    if FIndex = -1
    then
      FEdit.Font.Color := FDefaultFont.Color
    else
      FEdit.Font.Color := FontColor;
end;

procedure TspSkinSpinEdit.SetValueType(NewType: TspValueType);
begin
  if FValueType <> NewType
  then
    begin
      FEdit.Float := ValueType = vtFloat;
      FValueType := NewType;
      if FValueType = vtInteger
      then
        begin
          FIncrement := Round(FIncrement);
          if FIncrement = 0 then FIncrement := 1;
        end;
  end;
  FEdit.Float := ValueType = vtFloat;
end;

procedure TspSkinSpinEdit.SetDecimal(NewValue: Byte);
begin
  if FDecimal <> NewValue then begin
    FDecimal := NewValue;
  end;
end;

procedure TspSkinSpinEdit.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinSpinEdit.DefaultFontChange;
begin
  if (FIndex = -1) and (FEdit <> nil) then FEdit.Font.Assign(FDefaultFont);
end;

procedure TspSkinSpinEdit.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinSpinEditControl
    then
      with TspDataSkinSpinEditControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.DisabledFontColor := DisabledFontColor;
        Self.UpButtonRect := UpButtonRect;
        Self.ActiveUpButtonRect := ActiveUpButtonRect;
        Self.DownUpButtonRect := DownUpButtonRect;
        if IsNullRect(Self.DownUpButtonRect)
        then Self.DownUpButtonRect := Self.ActiveUpButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.ActiveDownButtonRect := ActiveDownButtonRect;
        Self.DownDownButtonRect := DownDownButtonRect;
        if IsNullRect(Self.DownDownButtonRect)
        then Self.DownDownButtonRect := Self.ActiveDownButtonRect;
        LOffset := LTPoint.X;
        ROffset := RectWidth(SkinRect) - RTPoint.X;
      end;
end;

procedure TspSkinSpinEdit.ChangeSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    with FEdit.Font do
    begin
      if FUseSkinFont
      then
        begin
          Style := FontStyle;
          Color := FontColor;
          Height := FontHeight;
          Name := FontName;
        end
      else
        begin
          Assign(FDefaultFont);
          Color := FontColor;
        end;
    end
  else
    FEdit.Font.Assign(FDefaultFont);


  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    FEdit.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    FEdit.Font.CharSet :=TURKISH_CHARSET;// FDefaultFont.CharSet;

  if FIndex <> -1
  then
    begin
      FEdit.EditTransparent := True;
      Height := RectHeight(SkinRect);
    end
  else
    begin
      FEdit.EditTransparent := False;
    end;
  CalcRects;
  if not Enabled
  then
    begin
      if FIndex = -1
      then
        FEdit.Font.Color := clGrayText
      else
        FEdit.Font.Color := DisabledFontColor;
    end
  else
    if FIndex = -1
    then
      FEdit.Font.Color := FDefaultFont.Color
    else
      if FMouseIn or FEditFocused
      then
        FEdit.Font.Color := ActiveFontColor
      else
        FEdit.Font.Color := FontColor;
  RePaint;   
end;

procedure TspSkinSpinEdit.EditEnter;
begin
  if Assigned(FOnEditEnter) then FOnEditEnter(Self);
  FEditFocused := True;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect)
  then
    RePaint;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor)
  then
    FEdit.Font.Color := ActiveFontColor;
end;

procedure TspSkinSpinEdit.EditExit;
begin
  if Assigned(FOnEditExit) then FOnEditExit(Self);
  FEditFocused := False;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect)
  then
    RePaint;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor)
  then
    FEdit.Font.Color := FontColor;
end;

procedure TspSkinSpinEdit.EditMouseEnter(Sender: TObject);
begin
  FMouseIn := True;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect) and not FEditFocused
  then
    RePaint;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor) and not FEditFocused
  then
    FEdit.Font.Color := ActiveFontColor;
end;

procedure TspSkinSpinEdit.EditMouseLeave(Sender: TObject);
begin
  FMouseIn := False;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect) and not FEditFocused
  then
    RePaint;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor) and not FEditFocused
  then
    FEdit.Font.Color := FontColor;
end;


procedure TspSkinSpinEdit.EditKeyDown;
begin
  if Assigned(FOnEditKeyDown) then FOnEditKeyDown(Self, Key, Shift);
end;

procedure TspSkinSpinEdit.EditKeyUp;
begin
  if Assigned(FOnEditKeyUp) then FOnEditKeyUp(Self, Key, Shift);
end;

procedure TspSkinSpinEdit.EditKeyPress;
begin
  if Assigned(FOnEditKeyPress) then FOnEditKeyPress(Self, Key);
end;

procedure TspSkinSpinEdit.UpClick;
begin
  Value := Value + FIncrement;
end;

procedure TspSkinSpinEdit.DownClick;
begin
  Value := Value - FIncrement;
end;

procedure TspSkinSpinEdit.SetMaxLength;
begin
  FEdit.MaxLength := AValue;
end;

function  TspSkinSpinEdit.GetMaxLength;
begin
  Result := FEdit.MaxLength;
end;

procedure TspSkinSpinEdit.SetEditorEnabled;
begin
  FEdit.EditorEnabled := AValue;
end;

function  TspSkinSpinEdit.GetEditorEnabled;
begin
  Result := FEdit.EditorEnabled;
end;

procedure TspSkinSpinEdit.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 100, nil);
end;

procedure TspSkinSpinEdit.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

function TspSkinSpinEdit.CheckValue;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue)
  then
    begin
      if NewValue < FMinValue then
      Result := FMinValue
      else if NewValue > FMaxValue then
      Result := FMaxValue;
    end;
end;

procedure TspSkinSpinEdit.WMTimer;
var
  CanScroll: Boolean;
begin
  inherited;
  if WaitMode
  then
    begin
      WaitMode := False;
      StartTimer;
      Exit;
    end;
  case TimerMode of
    1: Value := Value - FIncrement;
    2: Value := Value + FIncrement;
  end;
end;


procedure TspSkinSpinEdit.SetMinValue;
begin
  FMinValue := AValue;
end;

procedure TspSkinSpinEdit.SetMaxValue;
begin
  FMaxValue := AValue;
end;

procedure TspSkinSpinEdit.CMMouseEnter;
begin
  inherited;
  TestActive(-1, -1);
  if not FEditFocused and (FIndex <> -1) and not IsNullRect(ActiveSkinRect)
  then
    begin
      FMouseIn := True;
      RePaint;
    end;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor) and not FEditFocused
  then
    FEdit.Font.Color := ActiveFontColor;    
end;

function TspSkinSpinEdit.IsNumText;

function GetMinus: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos('-', S);
  if i > 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos('-', S) = 0;
    end;
end;

function GetP: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos(DecimalSeparator, S);
  if i = 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos(DecimalSeparator, S) = 0;
    end;
end;

const
  EditChars = '01234567890-';
var
  i: Integer;
  S: String;
begin
  S := EditChars;
  Result := True;
  if ValueType = vtFloat
  then
    S := S + DecimalSeparator;
  if (Text = '') or (Text = '-')
  then
    begin
      Result := False;
      Exit;
    end;

  for i := 1 to Length(Text) do
  begin
    if Pos(Text[i], S) = 0
    then
      begin
        Result := False;
        Break;
      end;
  end;

  Result := Result and GetMinus;

  if ValueType = vtFloat
  then
    Result := Result and GetP;

end;

procedure TspSkinSpinEdit.CMTextChanged;
var
  NewValue, TmpValue: Double;
begin
  inherited;
  if (FEdit <> nil) and not FromEdit then FEdit.Text := Text;
  if not StopCheck and IsNumText(FEdit.Text)
  then
    begin
      if ValueType = vtFloat
      then TmpValue := StrToFloat(FEdit.Text)
      else TmpValue := StrToInt(FEdit.Text);
      NewValue := CheckValue(TmpValue);
      if NewValue <> FValue
      then
        begin
          FValue := NewValue;
          Change;
        end;
      if NewValue <> TmpValue
      then
        begin
          StopCheck := True;
          if ValueType = vtFloat
          then FEdit.Text := FloatToStrF(NewValue, ffFixed, 15, FDecimal)
          else FEdit.Text := IntToStr(Round(FValue));
          StopCheck := False;
        end;
    end;
end;

procedure TspSkinSpinEdit.CMMouseLeave;
var
  i: Integer;
  P: TPoint;
begin
  inherited;
  for i := 0 to 1 do
    if Buttons[i].MouseIn
    then
       begin
         Buttons[i].MouseIn := False;
         RePaint;
       end;
  GetCursorPos(P);
  if not (WindowFromPoint(P) = FEdit.Handle) and not FEditFocused and (FIndex <> -1)
     and not IsNullRect(ActiveSkinRect)
  then
    begin
      FMouseIn := False;
      RePaint;
    end;
  if (FIndex <> -1) and (ActiveFontColor <> FontColor) and not FEditFocused and
     not (WindowFromPoint(P) = FEdit.Handle)
  then
    FEdit.Font.Color := FontColor;
end;

procedure TspSkinSpinEdit.EditChange;
begin
  FromEdit := True;
  Text := FEdit.Text;
  FromEdit := False;
end;

procedure TspSkinSpinEdit.Invalidate;
begin
  inherited;
  if (FIndex <> -1) and (FEdit <> nil) then FEdit.Invalidate;
end;

procedure TspSkinSpinEdit.WMSIZE;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinSpinEdit.TestActive(X, Y: Integer);
var
  i, j: Integer;
begin
  j := -1;
  OldActiveButton := ActiveButton;
  for i := 0 to 1 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinSpinEdit.ButtonDown;
begin
  Buttons[i].MouseIn := True;
  Buttons[i].Down := True;
  RePaint;
  case i of
    0: TimerMode := 2;
    1: TimerMode := 1;
  end;
  WaitMode := True;
  SetTimer(Handle, 1, 500, nil);
end;

procedure TspSkinSpinEdit.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  RePaint;
  if Buttons[i].MouseIn
  then
  case i of
    0: Value := Value + FIncrement;
    1: Value := Value - FIncrement;
  end;
  StopTimer;
end;

procedure TspSkinSpinEdit.ButtonEnter(I: Integer);
begin
  Buttons[i].MouseIn := True;
  RePaint;
  if Buttons[i].Down then SetTimer(Handle, 1, 50, nil);
end;

procedure TspSkinSpinEdit.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  RePaint;
  if Buttons[i].Down then KillTimer(Handle, 1);
end;

procedure TspSkinSpinEdit.CalcRects;
const
  ButtonW = 15;
var
  OX: Integer;
  NewClRect: TRect;
begin
  if FIndex = -1
  then
    begin
      Buttons[0].R := Rect(Width - ButtonW - 2, 2, Width - 2, Height div 2);
      Buttons[1].R := Rect(Width - ButtonW - 2, Height div 2, Width - 2, Height - 2);
      FEdit.SetBounds(2, 2, Width - ButtonW - 4, Height - 4);
    end
  else
    begin
      OX := Width - RectWidth(SkinRect);
      Buttons[0].R := UpButtonRect;
      if Buttons[0].R.Left > RTPt.X
      then OffsetRect(Buttons[0].R, OX, 0);
      Buttons[1].R := DownButtonRect;
      if Buttons[1].R.Left > RTPt.X
      then OffsetRect(Buttons[1].R, OX, 0);
      NewClRect := Rect(ClRect.Left, ClRect.Top,
                        ClRect.Right + OX, ClRect.Bottom);
      FEdit.SetBounds(NewClRect.Left, NewClRect.Top,
                      RectWidth(NewClRect), RectHeight(NewClRect));
    end;
end;

procedure TspSkinSpinEdit.SimpleSetValue(AValue: Double);
begin
  FValue := CheckValue(AValue);
  StopCheck := True;
  if ValueType = vtFloat
  then
    Text := FloatToStrF(CheckValue(AValue), ffFixed, 15, FDecimal)
  else
    Text := IntToStr(Round(CheckValue(AValue)));
  StopCheck := False;
end;

procedure TspSkinSpinEdit.SetValue;
begin
  FValue := CheckValue(AValue);
  StopCheck := True;
  if ValueType = vtFloat
  then
    Text := FloatToStrF(CheckValue(AValue), ffFixed, 15, FDecimal)
  else
    Text := IntToStr(Round(CheckValue(AValue)));
  StopCheck := False;
  Change;
end;

procedure TspSkinSpinEdit.CreateControlSkinImage;
var
  i: Integer;
begin
  if (FEditFocused or FMouseIn) and not IsNullRect(ActiveSkinRect)
  then
    CreateHSkinImage(LOffset, ROffset, B, Picture, ActiveSkinRect, Width,
          RectHeight(ActiveSkinRect))
  else
    inherited;
  for i := 0 to 1 do DrawButton(B.Canvas, i);
end;

procedure TspSkinSpinEdit.DrawButton;
var
  C: TColor;
  kf: Double;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Buttons[i] do
    begin
      R1 := R;
      if Down and MouseIn
      then
        begin
          Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Cnvs.Brush.Color := SP_XP_BTNDOWNCOLOR;
          Cnvs.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR;
            Cnvs.FillRect(R1);
          end
        else
          begin
            Cnvs.Brush.Color := clBtnFace;
            Cnvs.FillRect(R1);
          end;
      C := clBlack;
      case i of
        0: DrawArrowImage(Cnvs, R1, C, 3);
        1: DrawArrowImage(Cnvs, R1, C, 4);
      end;
    end
  else
    with Buttons[i] do
    begin
      R1 := NullRect;
      case I of
        0:
          begin
            if Down and MouseIn
            then R1 := DownUpButtonRect
            else if MouseIn then R1 := ActiveUpButtonRect;
          end;
        1:
          begin
            if Down and MouseIn
            then R1 := DownDownButtonRect
            else if MouseIn then R1 := ActiveDownButtonRect;
          end
      end;
      if not IsNullRect(R1)
      then
        Cnvs.CopyRect(R, Picture.Canvas, R1);
    end;
end;

procedure TspSkinSpinEdit.CreateControlDefaultImage;
var
  R: TRect;
  i: Integer;
begin
  with B.Canvas do
  begin
    R := Rect(0, 0, Width, Height);
    Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
    Frame3D(B.Canvas, R, clBtnFace, clBtnFace, 1);
  end;
  for i := 0 to 1 do DrawButton(B.Canvas, i);
end;

procedure TspSkinSpinEdit.MouseDown;
begin
  TestActive(X, Y);
  if ActiveButton <> -1
  then
    begin
      CaptureButton := ActiveButton;
      ButtonDown(ActiveButton, X, Y);
    end;
  inherited;
end;

procedure TspSkinSpinEdit.MouseUp;
begin
  if CaptureButton <> -1
  then ButtonUp(CaptureButton, X, Y);
  CaptureButton := -1;
  inherited;
end;

procedure TspSkinSpinEdit.MouseMove;
begin
  inherited;
  TestActive(X, Y);
end;

constructor TspCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FEditTransparent := False;
  FSysPopupMenu := nil;
end;

destructor TspCustomEdit.Destroy;
begin
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;
  inherited;
end;

procedure TspCustomEdit.WMCONTEXTMENU;
var
  X, Y: Integer;
  P: TPoint;
begin
  if PopupMenu <> nil
  then
    inherited
  else
    begin
      CreateSysPopupMenu;
      X := Message.XPos;
      Y := Message.YPos;
      if (X < 0) or (Y < 0)
      then
        begin
          X := Width div 2;
          Y := Height div 2;
          P := Point(0, 0);
          P := ClientToScreen(P);
          X := X + P.X;
          Y := Y + P.Y;
        end;
      if FSysPopupMenu <> nil
      then
        FSysPopupMenu.Popup2(Self, X, Y)
    end;
end;

procedure TspCustomEdit.WMAFTERDISPATCH;
begin
  if FSysPopupMenu <> nil
  then
    begin
      FSysPopupMenu.Free;
      FSysPopupMenu := nil;
    end;
end;

procedure TspCustomEdit.DoUndo;
begin
  Undo;
end;

procedure TspCustomEdit.DoCut;
begin
  CutToClipboard;
end;

procedure TspCustomEdit.DoCopy;
begin
  CopyToClipboard;
end;

procedure TspCustomEdit.DoPaste;
begin
  PasteFromClipboard;
end;

procedure TspCustomEdit.DoDelete;
begin
  ClearSelection;
end;

procedure TspCustomEdit.DoSelectAll;
begin
  SelectAll;
end;

procedure TspCustomEdit.CreateSysPopupMenu;

function FindDSFComponent(AForm: TForm): TspDynamicSkinForm;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to AForm.ComponentCount - 1 do
   if AForm.Components[i] is TspDynamicSkinForm
   then
     begin
       Result := TspDynamicSkinForm(AForm.Components[i]);
       Break;
     end;
end;

function GetResourceStrData: TspResourceStrData;
var
  DSF: TspDynamicSkinForm;
begin
  DSF := FindDSFComponent(TForm(GetParentForm(Self)));
  if (DSF <> nil) and (DSF.SkinData <> nil) and (DSF.SkinData.ResourceStrData <> nil)
  then
    Result :=  DSF.SkinData.ResourceStrData
  else
    Result := nil;  
end;

function IsSelected: Boolean;
var
  i, j: Integer;
begin
  GetSel(i, j);
  Result := (i < j);
end;

function IsFullSelected: Boolean;
var
  i, j: Integer;
begin
  GetSel(i, j);
  Result := (i = 0) and (j = Length(Text));
end;

var
  Item: TMenuItem;
  ResStrData: TspResourceStrData;
begin
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;

  FSysPopupMenu := TspSkinPopupMenu.Create(Self);
  FSysPopupMenu.ComponentForm := TForm(GetParentForm(Self));

  ResStrData := GetResourceStrData;

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_UNDO')
    else
      Caption := SP_Edit_Undo;
    OnClick := DoUndo;
    Enabled := Self.CanUndo;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_CUT')
    else
      Caption := SP_Edit_Cut;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoCut;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_COPY')
    else
      Caption := SP_Edit_Copy;
    Enabled := IsSelected;
    OnClick := DoCopy;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_PASTE')
    else
      Caption := SP_Edit_Paste;
    Enabled := (ClipBoard.AsText <> '') and not ReadOnly;
    OnClick := DoPaste;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
   if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_DELETE')
    else
      Caption := SP_Edit_Delete;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoDelete;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('EDIT_SELECTALL')
    else
      Caption := SP_Edit_SelectAll;
    Enabled := not IsFullSelected;
    OnClick := DoSelectAll;
  end;
  FSysPopupMenu.Items.Add(Item);
end;


procedure TspCustomEdit.CMCancelMode;
begin
  inherited;
  if Assigned(FOnEditCancelMode)
  then FOnEditCancelMode(Message.Sender);
end;

procedure TspCustomEdit.SetEditTransparent(Value: Boolean);
begin
  FEditTransparent := Value;
  ReCreateWnd;
end;

procedure TspCustomEdit.WMSetFont;
begin
  inherited;
  SendMessage(Handle, EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, MakeLong(2, 0));
end;

procedure TspCustomEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    if FEditTransparent then ExStyle := ExStyle or WS_EX_TRANSPARENT;
    if PasswordChar <> #0
    then
      Style := Style or ES_PASSWORD and not ES_MULTILINE
    else
      Style := Style or ES_MULTILINE;
  end;
end;

procedure TspCustomEdit.WMCHAR;
var
  Key: Char;
  Key1: Word;
begin
  if Message.CharCode in [VK_ESCAPE]
  then
    begin
      Key1 := Message.CharCode;
      if Assigned(OnKeyDown) then OnKeyDown(Self, Key1, []);
      Key := #27;
      if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
    end;
  if Message.CharCode in [VK_RETURN]
  then
    begin
      Key := #13;
      if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
    end
  else
  if not ReadOnly then inherited;
end;

procedure TspCustomEdit.CNCtlColorStatic;
begin
 if FEditTransparent
 then
   begin
     with Message do
     begin
       SetBkMode(ChildDC, Windows.Transparent);
       SetTextColor(ChildDC, Font.Color);
       Result := GetStockObject(NULL_BRUSH);
     end
   end
 else
  inherited;
end;

procedure TspCustomEdit.CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT);
begin
 if FEditTransparent
 then
   begin
     with Message do
     begin
       SetBkMode(ChildDC, Windows.Transparent);
       SetTextColor(ChildDC, Font.Color);
       Result := GetStockObject(NULL_BRUSH);
     end
   end
 else
  inherited;
end;

procedure TspCustomEdit.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if FEditTransparent then Invalidate else inherited;
end;

procedure TspCustomEdit.Invalidate;
var
  R: TRect;
begin
  if FEditTransparent
  then
    begin
      if Parent = nil then Exit;
      R := ClientRect;
      R.TopLeft := Parent.ScreenToClient(ClientToScreen(R.TopLeft));
      R.BottomRight := Parent.ScreenToClient(ClientToScreen(R.BottomRight));
      InvalidateRect(Parent.Handle, @R, True);
      RedrawWindow(Handle, nil, 0, RDW_FRAME + RDW_INVALIDATE);
    end
  else
    inherited;
end;

procedure TspCustomEdit.Change;
begin
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMKeyDown(var Message: TWMKeyDown);
begin
  if FReadOnly and (Message.CharCode = VK_DELETE) then Exit;
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMSetText(var Message:TWMSetText);
begin
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMMove(var Message: TMessage);
begin
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMCut(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMPaste(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMClear(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMUndo(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMLButtonDown(var Message: TMessage);
begin
  inherited;
  FDown := True;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMSETFOCUS;
begin
  inherited;
  if FEditTransparent then Invalidate;
  if AutoSelect then SelectAll;
end;

procedure TspCustomEdit.WMKILLFOCUS;
begin
  inherited;
  if FEditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMMOUSEMOVE;
begin
  inherited;
  if FDown and EditTransparent then Invalidate;
end;

procedure TspCustomEdit.WMLButtonUp;
begin
  inherited;
  FDown := False;
end;

constructor TspSkinNumEdit.Create(AOwner: TComponent);
begin
  inherited;
  FEditorEnabled := True;
end;

procedure TspSkinNumEdit.CMMouseEnter;
begin
  inherited;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TspSkinNumEdit.CMMouseLeave;
begin
  inherited;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TspSkinNumEdit.WMMOUSEWHEEL;
begin
  if Message.WParam > 0
  then
    begin
      if Assigned(FOnDownClick) then FOnDownClick(Self);
    end
  else
    begin
      if Assigned(FOnUpClick) then FOnUpClick(Self);
    end;
end;

procedure TspSkinNumEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP
  then
    begin
      if Assigned(FOnUpClick) then FOnUpClick(Self);
    end
  else
  if Key = VK_DOWN
  then
    begin
      if Assigned(FOnDownClick) then FOnDownClick(Self);
    end
  else  
  inherited KeyDown(Key, Shift);
end;

procedure TspSkinNumEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TspSkinNumEdit.IsValidChar(Key: Char): Boolean;
begin
  if FLoat
  then
    Result := (Key in [DecimalSeparator, '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)))
  else
    Result := (Key in ['-', '0'..'9']) or
     ((Key < #32) and (Key <> Chr(VK_RETURN)));

  if not FEditorEnabled and Result and ((Key >= #32) or
     (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE)))
  then
    Result := False;

  if (Key = DecimalSeparator) and (Pos(DecimalSeparator, Text) <> 0)
  then
    Result := False
  else
  if (Key = '-') and (Pos('-', Text) <> 0)
  then
    Result := False;  
end;

const
  HTEDITBUTTON = HTSIZE + 2;
  HTEDITFRAME = HTSIZE + 3;

constructor TspSkinCustomEdit.Create;
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  AutoSize := False;
  FIndex := -1;
  Font.Name := 'Arial';
  Font.Color := clWindowText;
  Font.Style := [];
  Font.Height := 14;
  Height := 20;
  BorderStyle := bsNone;
  Picture := nil;
  EditTransparent := True;
  ParentImage := nil;
  FSkinDataName := 'edit';
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  FDefaultFont.Assign(Font);
  FDefaultWidth := 0;
  FDefaultHeight := 20;
  FUseSkinFont := True;
end;

destructor TspSkinCustomEdit.Destroy;
begin
  FDefaultFont.Free;
  inherited;
end;

procedure TspSkinCustomEdit.Loaded;
begin
  inherited;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet;
end;

procedure TspSkinCustomEdit.CMEnabledChanged;
begin
  inherited;
  if Enabled
  then
    begin
      if FIndex = -1
      then Font.Color := FDefaultFont.Color
      else Font.Color := FontColor;
    end
  else
    begin
      if FIndex = -1
      then Font.Color := clGrayText
      else Font.Color := DisabledFontColor;
    end;
  Invalidate;  
end;

procedure TspSkinCustomEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TspSkinCustomEdit.SetDefaultWidth;
begin
  FDefaultWidth := Value;
  if (FIndex = -1) and (FDefaultWidth > 0) then Width := FDefaultWidth;
end;

procedure TspSkinCustomEdit.SetDefaultHeight;
begin
  FDefaultHeight := Value;
  if (FIndex = -1) and (FDefaultHeight > 0) then Height := FDefaultHeight;
end;


procedure TspSkinCustomEdit.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex = -1 then Font.Assign(Value);
end;

procedure TspSkinCustomEdit.OnDefaultFontChange(Sender: TObject);
begin
  if FIndex = -1 then Font.Assign(FDefaultFont);
end;

procedure TspSkinCustomEdit.CalcRects;
var
  Off: Integer;
begin
   if FIndex = -1
  then
    begin
      FButtonRect := Rect(Width - Height, 0, Width, Height);
      FEditRect := Rect(2, 2, FButtonRect.Left - 2, Height - 2);
    end
  else
    begin
      Off := Width - RectWidth(SkinRect);
      FEditRect := ClRect;
      Inc(FEditRect.Right, Off);
      FButtonRect := ButtonRect;
      if ButtonRect.Left >= RectWidth(SkinRect) - ROffset
      then OffsetRect(FButtonRect, Off, 0);
    end;
end;


procedure TspSkinCustomEdit.WMMOUSEMOVE;
begin
  inherited;
  if FButtonMode and FButtonActive
  then
    begin
      FButtonActive := False;
      Invalidate;
    end;
end;

procedure TspSkinCustomEdit.WMNCHITTEST;
var
  P: TPoint;
  BR: TRect;
  ER: TRect;
begin
  if FButtonMode and not (csDesigning in ComponentState)
  then
    begin
      P.X := Message.XPos;
      P.Y := Message.YPos;
      P := ScreenToClient(P);
      if FIndex = -1
      then
        begin
          Inc(P.X, 2);
          Inc(P.Y, 2);
        end
      else
        begin
          Inc(P.X, ClRect.Left);
          Inc(P.Y, ClRect.Top);
        end;
      CalcRects;
      BR := FButtonRect;
      ER := FEditRect; 
      if PtInRect(BR, P)
      then
        Message.Result := HTEDITBUTTON
      else
        if not PtInRect(ER, P)
      then
        Message.Result := HTEDITFRAME
      else
        inherited;
    end
  else
    inherited;
end;

procedure TspSkinCustomEdit.WMNCLBUTTONDBCLK;
begin
  if FButtonMode and (Message.HitTest = HTEDITBUTTON) and
     not (csDesigning in ComponentState)
  then
    begin
      FButtonDown := True;
      Invalidate;
    end
  else
    inherited;
end;

procedure TspSkinCustomEdit.WMNCLBUTTONDOWN;
begin
  if FButtonMode and (Message.HitTest = HTEDITBUTTON) and
     not (csDesigning in ComponentState)
  then
    begin
      FButtonDown := True;
      Invalidate;
    end
  else
    inherited;
end;

procedure TspSkinCustomEdit.WMNCLBUTTONUP;
begin
  if FButtonMode and (Message.HitTest = HTEDITBUTTON) and
     not (csDesigning in ComponentState)
  then
    begin
      FButtonDown := False;
      Invalidate;
      if not Focused then SetFocus;
      if Assigned(FOnButtonClick) then FOnButtonClick(Self);
    end
  else
    inherited;
end;

procedure TspSkinCustomEdit.WMNCMOUSEMOVE;
begin
  if FButtonMode  and  not (csDesigning in ComponentState)
  then
    begin
      if Message.HitTest = HTEDITBUTTON
      then
        begin
          if not FButtonActive
          then
             begin
               FButtonActive := True;
               Invalidate;
             end
        end
      else
        begin
          if FButtonActive
          then
           begin
             FButtonActive := False;
             Invalidate;
           end;
           inherited;
         end
    end
  else
    inherited;
end;

procedure TspSkinCustomEdit.SetButtonMode;
begin
  FButtonMode := Value;
  ReCreateWnd;
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      if FButtonMode
      then FSkinDataName := 'buttonedit'
      else FSkinDataName := 'edit';
    end;
end;

procedure TspSkinCustomEdit.Invalidate;
begin
  if Parent = nil then Exit;
  RedrawWindow(Handle, nil, 0, RDW_FRAME + RDW_INVALIDATE);
end;

procedure TspSkinCustomEdit.SetParentImage;
begin
  if ParentImage <> nil
  then
    begin
      ParentImage.Width := Width;
      ParentImage.Height := Height;
      GetParentImage(Self, ParentImage.Canvas);
    end;
end;

procedure TspSkinCustomEdit.WMSETFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1) then Font.Color := ActiveFontColor;
end;

procedure TspSkinCustomEdit.WMKILLFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1) then Font.Color := FontColor;
end;

procedure TspSkinCustomEdit.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := ActiveFontColor;
      Invalidate;
    end;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TspSkinCustomEdit.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := FontColor;
      Invalidate;
    end;
  if FButtonDown or FButtonActive
  then
    begin
      FButtonActive := False;
      FButtonDown := False;
      Invalidate;
    end;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TspSkinCustomEdit.SetBounds;
var
  UpDate: Boolean;
begin
  GetSkinData;
  UpDate := ((Width <> AWidth) or (Height <> AHeight)) and (FIndex <> -1);
  if UpDate then AHeight := RectHeight(SkinRect);
  inherited;
  Invalidate;
end;

procedure TspSkinCustomEdit.WMNCCALCSIZE;
begin
  GetSkinData;
  if FIndex = -1
  then
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, 2);
      Inc(Top, 2);
      if FButtonMode
      then Dec(Right, 22)
      else Dec(Right, 2);
      Dec(Bottom, 2);
    end
  else
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, ClRect.Left);
      Inc(Top, ClRect.Top);
      Dec(Right, RectWidth(SkinRect) - ClRect.Right);
      Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
    end;
end;

procedure TspSkinCustomEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := Exstyle and not WS_EX_Transparent;
    Style := Style and not WS_BORDER or Alignments[FAlignment];
  end;
end;

procedure TspSkinCustomEdit.WMNCPAINT;
var
  DC: HDC;
  C: TCanvas;
  B: TBitMap;
  R: TRect;
  Kf: Double;
  EB1, EB2: TspEffectBmp;
  Offset: Integer;
  BR: TRect;
begin
  if FAlphaBlend
  then
    begin
      ParentImage := TBitMap.Create;
      SetParentImage;
    end;
  DC := GetWindowDC(Handle);
  C := TControlCanvas.Create;
  C.Handle := DC;
  B := TBitMap.Create;
  B.Width := Width;
  B.Height := Height;
  GetSkinData;
  CalcRects;
  if FButtonMode then Offset := Width - FButtonRect.Left else Offset := 0;
  try
    if FIndex = -1
    then
      with B.Canvas do
      begin
        Brush.Color := clWindow;
        // draw frame
        R := Rect(0, 0, Width - Offset, Height);
        Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
        Frame3D(B.Canvas, R, clBtnFace, clBtnFace, 1);
        // draw button
        if FButtonMode
        then
          begin
            CalcRects;
            R := FButtonRect;
            if FButtonDown and FButtonActive
            then
              begin
                Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
                Brush.Color :=  SP_XP_BTNDOWNCOLOR;
                FillRect(R);
              end
            else
            if FButtonActive
            then
              begin
                Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
                Brush.Color :=  SP_XP_BTNACTIVECOLOR;
                FillRect(R);
              end
            else
              begin
                Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
                Brush.Color := clBtnFace;
                FillRect(R);
              end;
          end;
      end
    else
      begin
        if FMouseIn or Focused
        then
          CreateHSkinImage(LOffset, ROffset, B, Picture, ActiveSkinRect, Width,
            RectHeight(ActiveSkinRect))
        else
          CreateHSkinImage(LOffset, ROffset, B, Picture, SkinRect, Width,
        RectHeight(SkinRect));
        // draw button
        if FButtonMode
        then
          begin
            BR := NullRect;
            if not Enabled and not IsNullRect(UnEnabledButtonRect)
            then
              BR := UnEnabledButtonRect
            else  
            if FButtonDown and FButtonActive
            then
              BR := DownButtonRect
            else if FButtonActive then BR := ActiveButtonRect;
            if not IsNullRect(BR) then
            B.Canvas.CopyRect(FButtonRect, Picture.Canvas, BR);
          end;
        //
      end;
    if FAlphaBlend
    then
      begin
        ParentImage.Width := B.Width;
        EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
        EB2 := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
        kf := 1 - FAlphaBlendValue / 255;
        EB1.Morph(EB2, Kf);
        EB1.Draw(C.Handle, 0, 0);
        EB1.Free;
        EB2.Free;
      end
    else
      C.Draw(0, 0, B);
  finally
    B.Free;
    C.Free;
    ReleaseDC(Handle, DC);
  end;
  if FAlphaBlend
  then
    begin
      ParentImage.Free;
      ParentImage := nil;
    end;
end;

procedure TspSkinCustomEdit.SetAlphaBlend;
begin
  if FAlphaBlend <> AValue
  then
    begin
      FAlphaBlend := AValue;
      Invalidate;
    end;
end;

procedure TspSkinCustomEdit.SetAlphaBlendValue;
begin
  FAlphaBlendValue := AValue;
  if FAlphaBlend then Invalidate;
end;

procedure TspSkinCustomEdit.GetSkinData;
begin
  if FSD = nil
  then
    begin
      FIndex := -1;
      Exit;
    end;
  if FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);

  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinEditControl
    then
      with TspDataSkinEditControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.SkinRect := SkinRect;
        Self.ActiveSkinRect := ActiveSkinRect;
        if isNullRect(ActiveSkinRect)
        then
          Self.ActiveSkinRect := SkinRect;
        LOffset := LTPoint.X;
        ROffset := RectWidth(SkinRect) - RTPoint.X;
        Self.ClRect := ClRect;
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.DisabledFontColor := DisabledFontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.ButtonRect := ButtonRect;
        Self.ActiveButtonRect := ActiveButtonRect;
        Self.DownButtonRect := DownButtonRect;
        if IsNullRect(Self.DownButtonRect)
        then Self.DownButtonRect := Self.ActiveButtonRect;
        Self.UnEnabledButtonRect := UnEnabledButtonRect;
      end;

end;

procedure TspSkinCustomEdit.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinCustomEdit.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
end;

procedure TspSkinCustomEdit.ChangeSkinData;
begin
   GetSkinData;
  //
  if (FIndex <> -1)
  then
    begin
      if FUseSkinFont
      then
        begin
          Font.Name := FontName;
          Font.Style := FontStyle;
          Height := RectHeight(SkinRect);
          Font.Height := FontHeight;
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end
      else
        begin
          Font.Assign(FDefaultFont);
          Height := RectHeight(SkinRect);
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end;
    end
  else
    begin
      Font.Assign(FDefaultFont);
      if FDefaultWidth > 0 then Width := FDefaultWidth;
      if FDefaultHeight > 0 then Height := FDefaultHeight;
    end;
  //
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Font.CharSet := TURKISH_CHARSET;// FDefaultFont.CharSet;
  //
  ReCreateWnd;
  if Enabled
  then
    begin
      if FIndex = -1
      then
        Font.Color := FDefaultFont.Color
      else
      if Focused
      then
        Font.Color := ActiveFontColor
      else
        Font.Color := FontColor;
    end
  else
    begin
      if FIndex = -1
      then Font.Color := clGrayText
      else Font.Color := DisabledFontColor;
    end;
end;

constructor TspSkinMemo.Create;
begin
  inherited Create(AOwner);
  AutoSize := False;
  FIndex := -1;
  Font.Name := 'Arial';
  Font.Height := 14;
  FVScrollBar := nil;
  ParentImage := nil;
  FDown := False;
  FSkinDataName := 'memo';
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  FDefaultFont.Assign(Font);
  FUseSkinFont := True;
  FSysPopupMenu := nil;
end;

procedure TspSkinMemo.WMCONTEXTMENU;
var
  X, Y: Integer;
  P: TPoint;
begin
  if PopupMenu <> nil
  then
    inherited
  else
    begin
      CreateSysPopupMenu;
      X := Message.XPos;
      Y := Message.YPos;
      if (X < 0) or (Y < 0)
      then
        begin
          X := Width div 2;
          Y := Height div 2;
          P := Point(0, 0);
          P := ClientToScreen(P);
          X := X + P.X;
          Y := Y + P.Y;
        end;
      if FSysPopupMenu <> nil
      then
        FSysPopupMenu.Popup2(Self, X, Y)
    end;
end;

procedure TspSkinMemo.WMAFTERDISPATCH;
begin
  if FSysPopupMenu <> nil
  then
    begin
      FSysPopupMenu.Free;
      FSysPopupMenu := nil;
    end;
end;

procedure TspSkinMemo.DoUndo;
begin
  Undo;
end;

procedure TspSkinMemo.DoCut;
begin
  CutToClipboard;
end;

procedure TspSkinMemo.DoCopy;
begin
  CopyToClipboard;
end;

procedure TspSkinMemo.DoPaste;
begin
  PasteFromClipboard;
end;

procedure TspSkinMemo.DoDelete;
begin
  ClearSelection;
end;

procedure TspSkinMemo.DoSelectAll;
begin
  SelectAll;
end;

procedure TspSkinMemo.CreateSysPopupMenu;

function IsSelected: Boolean;
begin
  Result := GetSelLength > 0;
end;

function IsFullSelected: Boolean;
begin
  Result := GetSelText = Text;
end;

var
  Item: TMenuItem;
begin
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;

  FSysPopupMenu := TspSkinPopupMenu.Create(Self);
  FSysPopupMenu.ComponentForm := TForm(GetParentForm(Self));

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_UNDO')
    else
      Caption := SP_Edit_Undo;
    OnClick := DoUndo;
    Enabled := Self.CanUndo;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
     if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_CUT')
    else
      Caption := SP_Edit_Cut;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoCut;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_COPY')
    else
      Caption := SP_Edit_Copy;
    Enabled := IsSelected;
    OnClick := DoCopy;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_PASTE')
    else
      Caption := SP_Edit_Paste;
    Enabled := (ClipBoard.AsText <> '') and not ReadOnly;
    OnClick := DoPaste;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_DELETE')
    else
      Caption := SP_Edit_Delete;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoDelete;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
     if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_SELECTALL')
    else
      Caption := SP_Edit_SelectAll;
    Enabled := not IsFullSelected;
    OnClick := DoSelectAll;
  end;
  FSysPopupMenu.Items.Add(Item);
end;


procedure TspSkinMemo.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex = -1 then Font.Assign(Value);
end;

procedure TspSkinMemo.CMEnabledChanged;
begin
  inherited;
  UpDateScrollRange;
  if Enabled
  then
    begin
      if FIndex = -1
      then Font.Color := FDefaultFont.Color
      else Font.Color := FontColor;
    end
  else
    begin
      if FIndex = -1
      then Font.Color := clGrayText
      else Font.Color := clGrayText;
    end;
end;

procedure TspSkinMemo.OnDefaultFontChange(Sender: TObject);
begin
  if FIndex = -1 then Font.Assign(FDefaultFont);
end;

procedure TspSkinMemo.SetBitMapBG;
begin
  FBitMapBG := Value;
  ReCreateWnd;
end;

procedure TspSkinMemo.WMSize;
begin
  inherited;
  UpDateScrollRange;
  if not FBitMapBG
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinMemo.Invalidate;
begin
  if FBitMapBG 
  then
    begin
      if Parent = nil then Exit;
      RedrawWindow(Handle, nil, 0, RDW_FRAME + RDW_INVALIDATE);
    end
  else
    begin
      inherited;
    end;
end;

procedure TspSkinMemo.Change;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMVSCROLL;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMHSCROLL;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMLBUTTONDOWN;
begin
  inherited;
  FDown := True;
end;

procedure TspSkinMemo.WMLBUTTONUP;
begin
  inherited;
  if FDown
  then
    begin
      UpDateScrollRange;
      FDown := False;
    end;  
end;

procedure TspSkinMemo.WMMOUSEMOVE;
begin
  inherited;
  if FDown then UpDateScrollRange;
end;

procedure TspSkinMemo.SetVScrollBar;
begin
  FVScrollBar := Value;
  FVScrollBar.Min := 0;
  FVScrollBar.Max := 0;
  FVScrollBar.Position := 0;
  if FVScrollBar <> nil then FVScrollBar.OnChange := OnVScrollBarChange;
end;

procedure TspSkinMemo.OnVScrollBarChange(Sender: TObject);
begin
  SendMessage(Handle, WM_VSCROLL,
    MakeWParam(SB_THUMBPOSITION, FVScrollBar.Position), 0);
  Invalidate;
end;

procedure TspSkinMemo.UpDateScrollRange;

function GetVisibleLines: Integer;
var
  R: TRect;
  C: TCanvas;
  DC: HDC;
  LineHeight: Integer;
begin
  C := TCanvas.Create;
  C.Font.Assign(Font);
  DC := GetDC(0);
  C.Handle := DC;
  R := GetClientRect;
  LineHeight := C.TextHeight('Wq');
  if LineHeight <> 0
  then
    Result := RectHeight(R) div LineHeight
  else
    Result := 1;
  ReleaseDC(0, DC);
  C.Free;
end;

var
  LinesCount: Integer;
  VisibleLines: Integer;
  Pos: Integer;
  P: PPoint;
  X: Integer;
begin
  if FVScrollBar <> nil
  then
  with FVScrollBar do
  begin
    VisibleLines := GetVisibleLines;
    LinesCount := SendMessage(Self.Handle, EM_GETLINECOUNT, 0, 0);
    Pos := SendMessage(Self.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    if LinesCount > VisibleLines
    then
      begin
        SetRange(0, LinesCount, Pos, VisibleLines + 1);
        if not Enabled then Enabled := True;
      end
    else
      begin
        SetRange(0, 0, 0, 0);
        if Enabled then Enabled := False;
      end;
  end;
end;

procedure TspSkinMEmo.WMMove;
begin
  inherited;
  if FAlphaBlend and (FIndex <> -1) then Invalidate;
end;

procedure TspSkinMemo.WMCut(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMPaste(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMClear(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMUndo(var Message: TMessage);
begin
  if FReadOnly then Exit;
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMSetText(var Message:TWMSetText);
begin
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMMOUSEWHEEL;
var
  LParam, WParam: Integer;
begin
  LParam := 0;
  if Message.WParam > 0
  then
    WParam := MakeWParam(SB_LINEUP, 0)
  else
    WParam := MakeWParam(SB_LINEDOWN, 0);
  SendMessage(Handle, WM_VSCROLL, WParam, LParam);
  if FBitMapBG then Invalidate;
end;

procedure TspSkinMemo.WMCHAR(var Message:TMessage);
begin
  if not FReadOnly or (FReadOnly and (TWMCHar(Message).CharCode = 3))
  then
    inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMKeyDown(var Message: TWMKeyDown);
begin
  if FReadOnly and (Message.CharCode = VK_DELETE) then Exit;
  inherited;
  if FBitMapBG then Invalidate;
  UpDateScrollRange;
end;

procedure TspSkinMemo.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if FBitMapBG then Invalidate else inherited;
end;

procedure TspSkinMemo.CNCtlColorStatic;
begin
 if FBitMapBG
 then
    with Message do
    begin
      SetBkMode(ChildDC, Windows.Transparent);
      SetTextColor(ChildDC, Font.Color);
      Result := GetStockObject(NULL_BRUSH);
    end
  else
    inherited;
end;

procedure TspSkinMemo.CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT);
begin
  if FBitMapBG
  then
    with Message do
    begin
      SetBkMode(ChildDC, Windows.Transparent);
      SetTextColor(ChildDC, Font.Color);
      Result := GetStockObject(NULL_BRUSH);
    end
  else
    inherited;
end;

procedure TspSkinMemo.SetParentImage;
begin
  if ParentImage <> nil
  then
    begin
      ParentImage.Width := Width;
      ParentImage.Height := Height;
      GetParentImage(Self, ParentImage.Canvas);
    end;
end;

procedure TspSkinMemo.WMNCCALCSIZE;
begin
  GetSkinData;
  if FIndex = -1
  then
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, 2);
      Inc(Top, 2);
      Dec(Right, 2);
      Dec(Bottom, 2);
    end
  else
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, ClRect.Left);
      Inc(Top, ClRect.Top);
      Dec(Right, RectWidth(SkinRect) - ClRect.Right);
      Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
    end;
end;

procedure TspSkinMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    ExStyle := Exstyle and not WS_EX_Transparent;
    Style := Style and not WS_BORDER or ES_MULTILINE;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TspSkinMemo.SkinNCPaint(C: TCanvas);
var
  B: TBitMap;
  R: TRect;
  EB1, EB2: TspEffectBMP;
  kf: Double;
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  NewClRect: TRect;
  OffX, OffY: Integer;
begin
  GetSkinData;
  B := TBitMap.Create;
  B.Width := Width;
  B.Height := Height;
  //
  if FIndex = -1
  then
    with B.Canvas do
    begin
      Brush.Color := clWindow;
      R := Rect(0, 0, Width, Height);
      Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
      Frame3D(B.Canvas, R, clBtnFace, clBtnFace, 1);
    end
    else
      begin
        OffX := Width - RectWidth(SkinRect);
        OffY := Height - RectHeight(SkinRect);
        NewLTPoint := LTPoint;
        NewRTPoint := Point(RTPoint.X + OffX, RTPoint.Y);
        NewLBPoint := Point(LBPoint.X, LBPoint.Y + OffY);
        NewRBPoint := Point(RBPoint.X + OffX, RBPoint.Y + OffY);
        NewClRect := Rect(ClRect.Left, ClRect.Top,
                          ClRect.Right + OffX, ClRect.Bottom + OffY);
        if FMouseIn or Focused
        then
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
            NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, ActiveSkinRect, Width, Height, True)
        else
          CreateSkinImage(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
            NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
            B, Picture, SkinRect, Width, Height, True);
      end;
  if FAlphaBlend
  then
    begin
      ParentImage.Width := B.Width;
      EB1 := TspEffectBmp.CreateFromhWnd(B.Handle);
      EB2 := TspEffectBmp.CreateFromhWnd(ParentImage.Handle);
      kf := 1 - FAlphaBlendValue / 255;
      EB1.Morph(EB2, Kf);
      EB1.Draw(C.Handle, 0, 0);
      EB1.Free;
      EB2.Free;
    end
  else
   C.Draw(0, 0, B);
  B.Free;
end;

procedure TspSkinMemo.SkinFramePaint(C: TCanvas);
var
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  R, NewClRect: TRect;
  LeftB, TopB, RightB, BottomB: TBitMap;
  OffX, OffY: Integer;
begin
  GetSkinData;
  if FIndex = -1
  then
    with C do
    begin
      Brush.Style := bsClear;
      R := Rect(0, 0, Width, Height);
      Frame3D(C, R, clBtnShadow, clBtnShadow, 1);
      Frame3D(C, R, clBtnFace, clBtnFace, 1);
      Exit;
    end;

  LeftB := TBitMap.Create;
  TopB := TBitMap.Create;
  RightB := TBitMap.Create;
  BottomB := TBitMap.Create;

  OffX := Width - RectWidth(SkinRect);
  OffY := Height - RectHeight(SkinRect);

  NewLTPoint := LTPoint;
  NewRTPoint := Point(RTPoint.X + OffX, RTPoint.Y);
  NewLBPoint := Point(LBPoint.X, LBPoint.Y + OffY);
  NewRBPoint := Point(RBPoint.X + OffX, RBPoint.Y + OffY);
  NewClRect := Rect(ClRect.Left, ClRect.Top,
                    ClRect.Right + OffX, ClRect.Bottom + OffY);

  if FMouseIn or Focused
  then
    CreateSkinBorderImages(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
      NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftB, TopB, RightB, BottomB, Picture, ActiveSkinRect, Width, Height,
      False, False, False, False)
  else
    CreateSkinBorderImages(LTPoint, RTPoint, LBPoint, RBPoint, CLRect,
      NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftB, TopB, RightB, BottomB, Picture, SkinRect, Width, Height,
      False, False, False, False);

  C.Draw(0, 0, TopB);
  C.Draw(0, TopB.Height, LeftB);
  C.Draw(Width - RightB.Width, TopB.Height, RightB);
  C.Draw(0, Height - BottomB.Height, BottomB);

  TopB.Free;
  LeftB.Free;
  RightB.Free;
  BottomB.Free;
end;

procedure TspSkinMemo.WMNCPAINT;
var
  DC: HDC;
  C: TCanvas;
  R: TRect;
  EB1, EB2: TspEffectBMP;
  kf: Double;
begin
  if FAlphaBlend and FBitMapBG
  then
    begin
      ParentImage := TBitMap.Create;
      SetParentImage;
    end;
  DC := GetWindowDC(Handle);
  C := TControlCanvas.Create;
  C.Handle := DC;
  try
    if FBitMapBG
    then
      SkinNCPaint(C)
    else
      SkinFramePaint(C);
  finally
    C.Free;
    ReleaseDC(Handle, DC);
  end;
  if FAlphaBlend and FBitMapBG
  then
    begin
      ParentImage.Free;
      ParentImage := nil;
    end;
end;

destructor TspSkinMemo.Destroy;
begin
  FDefaultFont.Free;
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;
  inherited;
end;

procedure TspSkinMemo.WMSETFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1)
  then
    begin
      Font.Color := ActiveFontColor;
      if not FBitMapBG then Color := ActiveBGColor;
    end;
  if not FMouseIn then Invalidate;
  if not FBitMapBG
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinMemo.WMKILLFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1)
  then
    begin
      Font.Color := FontColor;
      if not FBitMapBG then Color := BGColor;
    end;
  if not FMouseIn then Invalidate;
  if not FBitMapBG
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinMemo.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := ActiveFontColor;
      if not FBitMapBG then Color := ActiveBGColor;
    end;  
  if not Focused then Invalidate;
  if not FBitMapBG
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinMemo.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := FontColor;
      if not FBitMapBG then Color := BGColor;
    end;
  if not Focused then Invalidate;
  if not FBitMapBG
  then
    SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinMemo.SetAlphaBlend;
begin
  if FAlphaBlend <> AValue
  then
    begin
      FAlphaBlend := AValue;
      Invalidate;
    end;
end;

procedure TspSkinMemo.SetAlphaBlendValue;
begin
  if FAlphaBlendValue <> AValue
  then
    begin
      FAlphaBlendValue := AValue;
      if FAlphaBlend then Invalidate;
    end;
end;

procedure TspSkinMemo.GetSkinData;
begin
  if FSD = nil
  then
    begin
      FIndex := -1;
      Exit;
    end;

  if FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);

  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinMemoControl
    then
      with TspDataSkinMemoControl(FSD.CtrlList.Items[FIndex]) do
      begin
        if (PictureIndex <> -1) and (PictureIndex < FSD.FActivePictures.Count)
        then
          Picture := TBitMap(FSD.FActivePictures.Items[PictureIndex])
        else
          Picture := nil;
        Self.SkinRect := SkinRect;
        Self.ActiveSkinRect := ActiveSkinRect;
        if isNullRect(ActiveSkinRect)
        then
          Self.ActiveSkinRect := SkinRect;
        Self.LTPoint := LTPoint;
        Self.RTPoint := RTPoint;
        Self.LBPoint := LBPoint;
        Self.RBPoint := RBPoint;
        Self.ClRect := ClRect;
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.BGColor := BGColor;
        Self.ActiveBGColor := ActiveBGColor;
      end;
end;

procedure TspSkinMemo.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinMemo.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FVScrollBar)
  then FVScrollBar := nil;
end;

procedure TspSkinMemo.ChangeSkinData;
begin
  GetSkinData;
  //
  if FIndex <> -1
  then
    begin
      if FUseSkinFont
      then
        begin
          Font.Name := FontName;
          Font.Style := FontStyle;
          Font.Height := FontHeight;
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end
      else
        begin
          Font.Assign(FDefaultFont);
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end;
      Color := BGColor;
    end
  else
    Font.Assign(FDefaultFont);
  //
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Font.CharSet :=TURKISH_CHARSET; // FDefaultFont.CharSet;
  //
  UpDateScrollRange;
  ReCreateWnd;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
  if Enabled
  then
    begin
      if FIndex = -1
      then Font.Color := FDefaultFont.Color
      else Font.Color := FontColor;
    end
  else
    begin
      if FIndex = -1
      then Font.Color := clGrayText
      else Font.Color := clGrayText;
    end;
end;

constructor TspListBox.Create;
begin
  inherited;
  SkinListBox := nil;
  Ctl3D := False;
  BorderStyle := bsNone;
  ControlStyle := [csCaptureMouse, csOpaque, csDoubleClicks];
  FHorizontalExtentValue := 0;
  {$IFDEF VER130}
  FAutoComplete := True;
  {$ENDIF}
end;

destructor TspListBox.Destroy;
begin
  inherited;
end;

procedure TspListBox.SetBounds;
var
  OldWidth: Integer;
begin
  OldWidth := Width;
  inherited;
  if (OldWidth <> Width) and (FHorizontalExtentValue > 0)
  then
    begin
      FHorizontalExtentValue := FHorizontalExtentValue + (OldWidth - Width);
      if FHorizontalExtentValue < 0 then FHorizontalExtentValue := 0;
      RePaint;
    end;
end;

procedure TspListBox.CreateWnd;
begin
  inherited;
  if SkinListBox <> nil then SkinListBox.ListBoxCreateWnd;
end;

procedure TspListBox.WMNCCALCSIZE;
begin
end;

procedure TspListBox.CMEnter;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxEnter;
  inherited;
end;

procedure TspListBox.CMExit;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxExit;
  inherited;
end;

procedure TspListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxMouseDown(Button, Shift, X, Y);
  inherited;
end;

procedure TspListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxMouseUp(Button, Shift, X, Y);
  inherited;
end;

procedure TspListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxMouseMove(Shift, X, Y);
  inherited;
end;

procedure TspListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxKeyDown(Key, Shift);
  if (Key = VK_LEFT) and (SkinListBox.HScrollBar <> nil)
  then
    with SkinListBox.HScrollBar do
    begin
      Position := Position - SmallChange;
      Key := 0;
    end
  else
  if (Key = VK_RIGHT) and (SkinListBox.HScrollBar <> nil)
  then
    with SkinListBox.HScrollBar do
    begin
      Position := Position + SmallChange;
      Key := 0;
    end;
  inherited;
end;

procedure TspListBox.KeyPress(var Key: Char);
 {$IFDEF VER130}
  procedure FindString;
  var
    Idx: Integer;
  begin
    if Length(FFilter) = 1
    then
      Idx := SendMessage(Handle, LB_FINDSTRING, ItemIndex, LongInt(PChar(FFilter)))
    else
      Idx := SendMessage(Handle, LB_FINDSTRING, -1, LongInt(PChar(FFilter)));
    if Idx <> LB_ERR then
    begin
      if MultiSelect then
      begin
        SendMessage(Handle, LB_SELITEMRANGE, 1, MakeLParam(Idx, Idx))
      end;
      ItemIndex := Idx;
      Click;
    end;
    if not Ord(Key) in [VK_RETURN, VK_BACK, VK_ESCAPE] then
      Key := #0;  
  end;
  {$ENDIF}
begin
  if SkinListBox <> nil then SkinListBox.ListBoxKeyPress(Key);
  inherited;
  {$IFDEF VER130}
  if not FAutoComplete then Exit;
  if GetTickCount - FLastTime >= 500 then
    FFilter := '';
  FLastTime := GetTickCount;
  if Ord(Key) <> VK_BACK then
  begin
    FFilter := FFilter + Key;
    Key := #0;
  end
  else
    Delete(FFilter, Length(FFilter), 1);
  if Length(FFilter) > 0 then
    FindString
  else
  begin
    ItemIndex := 0;
    Click;
  end;
  {$ENDIF}
end;

procedure TspListBox.Click;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxClick;
  inherited;
end;

procedure TspListBox.PaintBGWH;
var
  X, Y, XCnt, YCnt, XO, YO, w, h, w1, h1: Integer;
  Buffer: TBitMap;
begin
  w1 := AW;
  h1 := AH;
  Buffer := TBitMap.Create;
  Buffer.Width := w1;
  Buffer.Height := h1;
  with Buffer.Canvas, SkinListBox do
  begin
    w := RectWidth(ClRect);
    h := RectHeight(ClRect);
    XCnt := w1 div w;
    YCnt := h1 div h;
    for X := 0 to XCnt do
    for Y := 0 to YCnt do
    begin
      if X * w + w > w1 then XO := X * w + w - w1 else XO := 0;
      if Y * h + h > h1 then YO := Y * h + h - h1 else YO := 0;
       CopyRect(Rect(X * w, Y * h, X * w + w - XO, Y * h + h - YO),
                Picture.Canvas,
                Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                SkinRect.Left + ClRect.Right - XO,
                SkinRect.Top + ClRect.Bottom - YO));
    end;
  end;
  Cnvs.Draw(AX, AY, Buffer);
  Buffer.Free;
end;

function TspListBox.GetState;
begin
  Result := [];
  if AItemID = ItemIndex
  then
    begin
      Result := Result + [odSelected];
      if Focused then Result := Result + [odFocused];
    end
  else
    if SelCount > 0
    then
      if Selected[AItemID] then Result := Result + [odSelected];
end;

procedure TspListBox.PaintBG(DC: HDC);
var
  C: TControlCanvas;
begin
  C := TControlCanvas.Create;
  C.Handle := DC;
  SkinListBox.GetSkinData;
  if SkinListBox.FIndex <> -1
  then
    PaintBGWH(C, Width, Height, 0, 0)
  else
    with C do
    begin
      Brush.Color := clWindow;
      FillRect(Rect(0, 0, Width, Height));
    end;
  C.Handle := 0;
  C.Free;
end;

procedure TspListBox.PaintColumnsList(DC: HDC);
var
  C: TCanvas;
  i, j, DrawCount: Integer;
  IR: TRect;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  DrawCount := (Height div ItemHeight) * Columns;
  i := TopIndex;
  j := i + DrawCount;
  if j > Items.Count - 1 then j := Items.Count - 1;
  if Items.Count > 0
  then
    for i := TopIndex to j do
    begin
      IR := ItemRect(i);
      if SkinListBox.FIndex <> -1
      then
        begin
          if SkinListBox.UseSkinItemHeight
          then
            DrawSkinItem(C, i, IR, GetState(i))
          else
            DrawStretchSkinItem(C, i, IR, GetState(i));
         end
      else
        DrawDefaultItem(C, i, IR, GetState(i));
    end;
  C.Free;
end;

procedure TspListBox.PaintList(DC: HDC);
var
  C: TCanvas;
  i, j, k, DrawCount: Integer;
  IR: TRect;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  DrawCount := Height div ItemHeight;
  i := TopIndex;
  j := i + DrawCount;
  if j > Items.Count - 1 then j := Items.Count - 1;
  k := 0;
  if Items.Count > 0
  then
    for i := TopIndex to j do
    begin
      IR := ItemRect(i);
      if SkinListBox.FIndex <> -1
      then
        begin
          if SkinListBox.UseSkinItemHeight
          then
            DrawSkinItem(C, i, IR, GetState(i))
          else
            DrawStretchSkinItem(C, i, IR, GetState(i));
        end
      else
        DrawDefaultItem(C, i, IR, GetState(i));
      k := IR.Bottom;
    end;
  if k < Height
  then
    begin
      SkinListBox.GetSkinData;
      if SkinListBox.FIndex <> -1
      then
        PaintBGWH(C, Width, Height - k, 0, k)
      else
        with C do
        begin
          C.Brush.Color := clWindow;
          FillRect(Rect(0, k, Width, Height));
        end;
    end;  
  C.Free;
end;

procedure TspListBox.PaintWindow;
var
  SaveIndex: Integer;
begin
  if (Width <= 0) or (Height <=0) then Exit;
  SaveIndex := SaveDC(DC);
  try
    if Columns > 0
    then
      PaintColumnsList(DC)
    else
      PaintList(DC);
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TspListBox.WMPaint;
begin
  PaintHandler(Msg);
end;

procedure TspListBox.WMEraseBkgnd;
begin
  if (Width > 0) and (Height > 0) then PaintBG(Message.DC);
  Message.Result := 1;
end;

procedure TspListBox.DrawDefaultItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                                     State: TOwnerDrawState);
var
  Buffer: TBitMap;
  R, R1: TRect;
  IIndex, IX, IY, Off: Integer;

begin
  if (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(rcItem);
  Buffer.Height := RectHeight(rcItem);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    Font.Name := SkinListBox.Font.Name;
    Font.Style := SkinListBox.Font.Style;
    Font.Height := SkinListBox.Font.Height;
    if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := TURKISH_CHARSET;// SkinListBox.DefaultFont.CharSet;
    if odSelected in State
    then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := clWindow;
        Font.Color := SkinListBox.Font.Color;
      end;
    FillRect(R);
  end;

  R1 := Rect(R.Left + 2, R.Top, R.Right - 2, R.Bottom);

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer.Canvas, ItemID, Buffer.Width, Buffer.Height,
    R1, State)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R1.Left;
              IY := R1.Top + RectHeight(R1) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer.Canvas, IX - FHorizontalExtentValue, IY, IIndex);
            end;
          Off := SkinListBox.Images.Width + 2
        end
      else
        Off := 0;
      Buffer.Canvas.Brush.Style := bsClear;
      SPDrawText3(Buffer.Canvas, Items[ItemID], R1, - FHorizontalExtentValue + Off);
    end;
  if odFocused in State then DrawFocusRect(Buffer.Canvas.Handle, R);
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer);
  Buffer.Free;
end;

procedure TspListBox.DrawStretchSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                                  State: TOwnerDrawState);
var
  Buffer, Buffer2: TBitMap;
  R: TRect;
  W, H: Integer;
  IX, IY, IIndex, Off: Integer;
begin
  if (SkinListBox.Picture = nil) or (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  Buffer := TBitMap.Create;
  with SkinListBox do
  begin
    W := RectWidth(rcItem);
    H := RectHeight(SItemRect);
    Buffer.Width := W;
    if UseSkinItemHeight
    then
      Buffer.Height := H
    else
      Buffer.Height := RectHeight(SItemRect);  
    if odFocused in State
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      FocusItemRect, W, H)
    else
    if odSelected in State
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      ActiveItemRect, W, H)
    else
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      SItemRect, W, H);

    R := ItemTextRect;
    Inc(R.Right, W - RectWidth(SItemRect));
    Inc(R.Bottom, RectHeight(rcItem) - RectHeight(SItemRect));
  end;

  W := RectWidth(rcItem);
  H := RectHeight(rcItem);
  Buffer2 := TBitMap.Create;
  Buffer2.Width := W;
  Buffer2.Height := H;
  Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
  Buffer.Free;

  with Buffer2.Canvas do
  begin
    if SkinListBox.UseSkinFont
    then
      begin
        Font.Name := SkinListBox.FontName;
        Font.Style := SkinListBox.FontStyle;
        Font.Height := SkinListBox.FontHeight;
      end
    else
      Font.Assign(SkinListBox.DefaultFont);

    if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
    else
      Font.CharSet :=TURKISH_CHARSET; //SkinListBox.DefaultFont.CharSet;

    if odFocused in State
    then
      Font.Color := SkinListBox.FocusFontColor
    else
    if odSelected in State
    then
      Font.Color := SkinListBox.ActiveFontColor
    else
      Font.Color := SkinListBox.FontColor;
    Brush.Style := bsClear;
  end;

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer2.Canvas, ItemID, W, H, R, State)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R.Left;
              IY := R.Top + RectHeight(R) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer2.Canvas,
                IX - FHorizontalExtentValue, IY, IIndex);
            end;
          Off := SkinListBox.Images.Width + 2;
        end
      else
        Off := 0;  
      SPDrawText3(Buffer2.Canvas, Items[ItemID], R, -FHorizontalExtentValue + Off);
    end;
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer2);
  Buffer2.Free;
end;

procedure TspListBox.DrawSkinItem(Cnvs: TCanvas; itemID: Integer; rcItem: TRect;
                                  State: TOwnerDrawState);
var
  Buffer: TBitMap;
  R: TRect;
  W, H: Integer;
  IX, IY, IIndex, Off: Integer;
begin
  if (SkinListBox.Picture = nil) or (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  Buffer := TBitMap.Create;
  with SkinListBox do
  begin
    W := RectWidth(rcItem);
    H := RectHeight(SItemRect);
    Buffer.Width := W;
    Buffer.Height := H; 
    if odFocused in State
    then
      begin
        if not (odSelected in State)
        then
          begin
            CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
              SItemRect, W, H);
            R := Rect(0, 0, Buffer.Width, Buffer.Height);
            DrawFocusRect(Buffer.Canvas.Handle, R);
          end
        else
          CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
            FocusItemRect, W, H)
      end
    else
    if odSelected in State
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      ActiveItemRect, W, H)
    else
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      SItemRect, W, H);
    R := ItemTextRect;
    Inc(R.Right, W - RectWidth(SItemRect));
  end;
  with Buffer.Canvas do
  begin
    if SkinListBox.UseSkinFont
    then
      begin
        Font.Name := SkinListBox.FontName;
        Font.Style := SkinListBox.FontStyle;
        Font.Height := SkinListBox.FontHeight;
        if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
        else
          Font.CharSet :=TURKISH_CHARSET;// SkinListBox.DefaultFont.CharSet;
      end
    else
      Font.Assign(SkinListBox.DefaultFont);
    if odFocused in State
    then
      begin
        if not (odSelected in State)
        then
          Font.Color := SkinListBox.FontColor
        else
          Font.Color := SkinListBox.FocusFontColor;
      end
    else
    if odSelected in State
    then
      Font.Color := SkinListBox.ActiveFontColor
    else
      Font.Color := SkinListBox.FontColor;
    Brush.Style := bsClear;
  end;

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer.Canvas, ItemID, Buffer.Width, Buffer.Height,
    R, State)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R.Left;
              IY := R.Top + RectHeight(R) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer.Canvas,
                IX - FHorizontalExtentValue, IY, IIndex);
            end;
          Off := SkinListBox.Images.Width + 2;
        end
      else
        Off := 0;  
      SPDrawText3(Buffer.Canvas, Items[ItemID], R, -FHorizontalExtentValue + Off);
    end;
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer);
  Buffer.Free;
end;

procedure TspListBox.CreateParams;
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    WindowClass.style := CS_DBLCLKS;
    Style := Style or WS_TABSTOP;
  end;
end;

procedure TspListBox.CNDrawItem;
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    {$IFDEF VER120}
      State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
    {$ELSE}
      {$IFDEF VER125}
        State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
      {$ELSE}
        State := TOwnerDrawState(LongRec(itemState).Lo);
      {$ENDIF}
    {$ENDIF}
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if SkinListBox.FIndex <> -1
    then
      begin
        if SkinListBox.UseSkinItemHeight
        then
          DrawSkinItem(Canvas, itemID, rcItem, State)
        else
          DrawStretchSkinItem(Canvas, itemID, rcItem, State);
      end
    else
      DrawDefaultItem(Canvas, itemID, rcItem, State);
    Canvas.Handle := 0;
  end;
end;

procedure TspListBox.WndProc;
var
  LParam, WParam: Integer;
  Handled: Boolean;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxWProc(Message, Handled);

  if not Handled then Exit;

  inherited;

  case Message.Msg of
    WM_LBUTTONDBLCLK:
      begin
        if SkinListBox <> nil then SkinListBox.ListBoxDblClick;
      end;
    WM_MOUSEWHEEL:
      if (SkinListBox <> nil) and (SkinListBox.ScrollBar <> nil)
      then
        begin
          LParam := 0;
          if Message.WParam > 0
          then
            WParam := MakeWParam(SB_LINEUP, 0)
          else
            WParam := MakeWParam(SB_LINEDOWN, 0);
          SendMessage(Handle, WM_VSCROLL, WParam, LParam);
          SkinListBox.UpDateScrollBar;
        end
      else
        if (SkinListBox <> nil) and (SkinListBox.HScrollBar <> nil)
        then
          begin
            with SkinListBox.HScrollBar do
            if Message.WParam > 0
            then
              Position := Position - SmallChange
            else
              Position := Position + SmallChange;
          end;
    WM_ERASEBKGND:
      SkinListBox.UpDateScrollBar;
    LB_ADDSTRING, LB_INSERTSTRING,
    LB_DELETESTRING:
      begin
        if SkinListBox <> nil
        then
          SkinListBox.UpDateScrollBar;
      end;
  end;
end;

constructor TspSkinCustomListBox.Create;
begin
  inherited;
  ControlStyle := [csCaptureMouse, csClickEvents,
    csReplicatable, csOpaque, csDoubleClicks, csAcceptsControls];
  FUseSkinItemHeight := True;
  FRowCount := 0;
  FImageIndex := -1;
  FGlyph := TBitMap.Create;
  FNumGlyphs := 1;
  FSpacing := 2;
  FDefaultCaptionFont := TFont.Create;
  FDefaultCaptionFont.OnChange := OnDefaultCaptionFontChange;
  FDefaultCaptionFont.Name := 'Arial';
  FDefaultCaptionFont.Height := 14;
  FDefaultCaptionHeight := 20;
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  FCaptionMode := False;
  FDefaultItemHeight := 20;
  TimerMode := 0;
  WaitMode := False;
  Font.Name := 'Arial';
  Font.Height := 14;
  Font.Color := clWindowText;
  Font.Style := [];
  ScrollBar := nil;
  HScrollBar := nil;
  ListBox := TspListBox.Create(Self);
  ListBox.SkinListBox := Self;
  ListBox.Style := lbOwnerDrawFixed;
  ListBox.ItemHeight := FDefaultItemHeight;
  ListBox.Parent := Self;
  ListBox.Visible := True;
  Height := 120;
  Width := 120;
  FSkinDataName := 'listbox';
  FHorizontalExtent := False;
  FStopUpDateHScrollBar := False;
end;

function TspSkinCustomListBox.GetAutoComplete: Boolean;
begin
  Result := ListBox.AutoComplete;
end;

procedure TspSkinCustomListBox.SetAutoComplete(Value: Boolean);
begin
  ListBox.AutoComplete := Value;
end;

procedure TspSkinCustomListBox.SetHorizontalExtent(Value: Boolean);
begin
  FHorizontalExtent := Value;
  UpdateScrollBar;
end;

function TspSkinCustomListBox.GetListBoxDragMode: TDragMode;
begin
  Result := ListBox.DragMode;
end;

procedure TspSkinCustomListBox.SetListBoxDragMode(Value: TDragMode);
begin
  ListBox.DragMode := Value;
end;

function TspSkinCustomListBox.GetListBoxDragKind: TDragKind;
begin
  Result := ListBox.DragKind;
end;

procedure TspSkinCustomListBox.SetListBoxDragKind(Value: TDragKind);
begin
  ListBox.DragKind := Value;
end;

function TspSkinCustomListBox.GetListBoxDragCursor: TCursor;
begin
  Result := ListBox.DragCursor;
end;

procedure TspSkinCustomListBox.SetListBoxDragCursor(Value: TCursor);
begin
  ListBox.DragCursor := Value;
end;

function TspSkinCustomListBox.GetOnListBoxEndDrag: TEndDragEvent;
begin
  Result := ListBox.OnEndDrag;
end;

procedure TspSkinCustomListBox.SetOnListBoxEndDrag(Value: TEndDragEvent);
begin
  ListBox.OnEndDrag := Value;
end;

function TspSkinCustomListBox.GetOnListBoxStartDrag: TStartDragEvent;
begin
  Result := ListBox.OnStartDrag;
end;

procedure TspSkinCustomListBox.SetOnListBoxStartDrag(Value: TStartDragEvent);
begin
  ListBox.OnStartDrag := Value;
end;

function TspSkinCustomListBox.GetOnListBoxDragOver: TDragOverEvent;
begin
  Result := ListBox.OnDragOver;
end;

procedure TspSkinCustomListBox.SetOnListBoxDragOver(Value: TDragOverEvent);
begin
  ListBox.OnDragOver := Value;
end;

function TspSkinCustomListBox.GetOnListBoxDragDrop: TDragDropEvent;
begin
  Result := ListBox.OnDragDrop;
end;

procedure TspSkinCustomListBox.SetOnListBoxDragDrop(Value: TDragDropEvent);
begin
  ListBox.OnDragDrop := Value;
end;

procedure TspSkinCustomListBox.ListBoxCreateWnd;
begin
end;

function  TspSkinCustomListBox.GetColumns;
begin
  Result := ListBox.Columns;
end;

procedure TspSkinCustomListBox.SetColumns;
begin
  ListBox.Columns := Value;
  UpDateScrollBar;
end;

procedure TspSkinCustomListBox.SetRowCount;
begin
  FRowCount := Value;
  if FRowCount <> 0
  then
    Height := Self.CalcHeight(FRowCount);
end;

procedure TspSkinCustomListBox.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinCustomListBox.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinCustomListBox.SetSpacing;
begin
  FSpacing := Value;
  RePaint;
end;

procedure TspSkinCustomListBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
  ListBox.RePaint;
end;

procedure TspSkinCustomListBox.SetImageIndex(Value: Integer);
begin
  FImageIndex := Value;
  ListBox.RePaint;
end;

procedure TspSkinCustomListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

procedure TspSkinCustomListBox.ListBoxWProc(var Message: TMessage; var Handled: Boolean);
begin
  Handled := True;
end;

procedure TspSkinCustomListBox.DefaultFontChange;
begin
  if FIndex = -1 then Font.Assign(FDefaultFont);
end;

procedure TspSkinCustomListBox.OnDefaultCaptionFontChange;
begin
  if (FIndex = -1) and FCaptionMode then RePaint;
end;

procedure TspSkinCustomListBox.SetDefaultCaptionHeight;
begin
  FDefaultCaptionHeight := Value;
  if (FIndex = -1) and FCaptionMode
  then
    begin
      CalcRects;
      RePaint;
    end;  
end;

procedure TspSkinCustomListBox.SetDefaultCaptionFont;
begin
  FDefaultCaptionFont.Assign(Value);
end;

procedure TspSkinCustomListBox.SetDefaultItemHeight;
begin
  FDefaultItemHeight := Value;
  if FIndex = -1
  then
    ListBox.ItemHeight := FDefaultItemHeight;
end;

procedure TspSkinCustomListBox.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 100, nil);
end;

procedure TspSkinCustomListBox.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinCustomListBox.WMTimer;
begin
  inherited;
  if WaitMode
  then
    begin
      WaitMode := False;
      StartTimer;
      Exit;
    end;
  case TimerMode of
    1: if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
    2: ItemIndex := ItemIndex + 1;
  end;
end;

procedure TspSkinCustomListBox.CMMouseEnter;
begin
  inherited;
  if FCaptionMode
  then
    TestActive(-1, -1);
end;

procedure TspSkinCustomListBox.CMMouseLeave;
var
  i: Integer;
begin
  inherited;
  if FCaptionMode
  then
  for i := 0 to 1 do
    if Buttons[i].MouseIn
    then
       begin
         Buttons[i].MouseIn := False;
         RePaint;
       end;
end;

procedure TspSkinCustomListBox.MouseDown;
begin
  if FCaptionMode
  then
    begin
      TestActive(X, Y);
      if ActiveButton <> -1
      then
        begin
          CaptureButton := ActiveButton;
          ButtonDown(ActiveButton, X, Y);
      end;
    end;
  inherited;
end;

procedure TspSkinCustomListBox.MouseUp;
begin
  if FCaptionMode
  then
    begin
      if CaptureButton <> -1
      then ButtonUp(CaptureButton, X, Y);
      CaptureButton := -1;
    end;  
  inherited;
end;

procedure TspSkinCustomListBox.MouseMove;
begin
  inherited;
  if FCaptionMode then TestActive(X, Y);
end;

procedure TspSkinCustomListBox.TestActive(X, Y: Integer);
var
  i, j: Integer;
begin
  if (FIndex <> -1) and IsNullRect(UpButtonRect) and IsNullRect(DownButtonRect)
  then Exit;

  j := -1;
  OldActiveButton := ActiveButton;
  for i := 0 to 2 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinCustomListBox.ButtonDown;
begin
  Buttons[i].MouseIn := True;
  Buttons[i].Down := True;
  DrawButton(Canvas, i);

  case i of
    0: if Assigned(FOnUpButtonClick) then Exit;
    1: if Assigned(FOnDownButtonClick) then Exit;
    2: if Assigned(FOnCheckButtonClick) then Exit;
  end;

  TimerMode := 0;
  case i of
    0: TimerMode := 1;
    1: TimerMode := 2;
  end;

  if TimerMode <> 0
  then
    begin
      WaitMode := True;
      SetTimer(Handle, 1, 500, nil);
    end;
end;

procedure TspSkinCustomListBox.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
  if Buttons[i].MouseIn
  then
  case i of
    0:
      if Assigned(FOnUpButtonClick)
      then
        begin
          FOnUpButtonClick(Self);
          Exit;
        end;
    1:
      if Assigned(FOnDownButtonClick)
      then
        begin
          FOnDownButtonClick(Self);
          Exit;
        end;
    2:
      if Assigned(FOnCheckButtonClick)
      then
        begin
          FOnCheckButtonClick(Self);
          Exit;
        end;
  end;
  case i of
    1: ItemIndex := ItemIndex + 1;
    0: if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
    2: ListBox.Click;
  end;
  if TimerMode <> 0 then StopTimer;
end;

procedure TspSkinCustomListBox.ButtonEnter(I: Integer);
begin
  Buttons[i].MouseIn := True;
  DrawButton(Canvas, i);
  if (TimerMode <> 0) and Buttons[i].Down
  then SetTimer(Handle, 1, 50, nil);
end;

procedure TspSkinCustomListBox.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
  if (TimerMode <> 0) and Buttons[i].Down
  then KillTimer(Handle, 1);
end;

procedure TspSkinCustomListBox.CMTextChanged;
begin
  inherited;
  if FCaptionMode then RePaint;
end;

procedure TspSkinCustomListBox.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value
  then
    begin
      FAlignment := Value;
      if FCaptionMode then RePaint;
    end;
end;

procedure TspSkinCustomListBox.DrawButton;
var
  C: TColor;
  kf: Double;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Buttons[i] do
    begin
      R1 := R;
      if Down and MouseIn
      then
        begin
          Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Cnvs.Brush.Color := SP_XP_BTNDOWNCOLOR;
          Cnvs.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR;
            Cnvs.FillRect(R1);
          end
        else
          begin
            Cnvs.Brush.Color := clBtnFace;
            Cnvs.FillRect(R1);
          end;

      C := clBlack;
      case i of
        0: DrawArrowImage(Cnvs, R, C, 3);
        1: DrawArrowImage(Cnvs, R, C, 4);
        2: DrawCheckImage(Cnvs, R.Left + 4, R.Top + 4, C);
      end;
    end
  else
    with Buttons[i] do
    if not IsNullRect(R) then
    begin
      R1 := NullRect;
      case I of
        0:
          begin
            if Down and MouseIn
            then R1 := DownUpButtonRect
            else if MouseIn then R1 := ActiveUpButtonRect;
          end;
        1:
          begin
            if Down and MouseIn
            then R1 := DownDownButtonRect
            else if MouseIn then R1 := ActiveDownButtonRect;
          end;
        2: begin
            if Down and MouseIn
            then R1 := DownCheckButtonRect
            else if MouseIn then R1 := ActiveCheckButtonRect;
           end;
      end;
      if not IsNullRect(R1)
      then
        Cnvs.CopyRect(R, Picture.Canvas, R1)
      else
        begin
          case I of
            0: R1 := UpButtonRect;
            1: R1 := DownButtonRect;
            2: R1 := CheckButtonRect;
          end;
          OffsetRect(R1, SkinRect.Left, SkinRect.Top);
          Cnvs.CopyRect(R, Picture.Canvas, R1);
        end;
    end;
end;

procedure TspSkinCustomListBox.CreateControlSkinImage;
var
  GX, GY, GlyphNum, TX, TY, i, OffX, OffY: Integer;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

function CalcBRect(BR: TRect): TRect;
var
  R: TRect;
begin
  R := BR;
  if BR.Top <= LTPt.Y
  then
    begin
      if BR.Left > RTPt.X then OffsetRect(R, OffX, 0);
    end
  else
    begin
      OffsetRect(R, 0, OffY);
      if BR.Left > RBPt.X then OffsetRect(R, OffX, 0);
    end;
  Result := R;
end;

begin
  inherited;
  // calc rects
  OffX := Width - RectWidth(SkinRect);
  OffY := Height - RectHeight(SkinRect);
  NewClRect := ClRect;
  Inc(NewClRect.Right, OffX);
  Inc(NewClRect.Bottom, OffY);
  if FCaptionMode
  then
    begin
      NewCaptionRect := CaptionRect;
      if CaptionRect.Right >= RTPt.X
      then
        Inc(NewCaptionRect.Right, OffX);
      Buttons[0].R := CalcBRect(UpButtonRect);
      Buttons[1].R := CalcBRect(DownButtonRect);
      Buttons[2].R := CalcBRect(CheckButtonRect);
    end;  
  // paint caption
  if not IsNullRect(CaptionRect)
  then
    with B.Canvas do
    begin
      Font.Name := CaptionFontName;
      Font.Height := CaptionFontHeight;
      Font.Color := CaptionFontColor;
      Font.Style := CaptionFontStyle;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := TURKISH_CHARSET;//DefaultCaptionFont.CharSet;
      TY := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2 -
            TextHeight(Caption) div 2;
      TX := NewCaptionRect.Left + 2;
      case Alignment of
        taCenter: TX := TX + RectWidth(NewCaptionRect) div 2 - GetGlyphTextWidth div 2;
        taRightJustify: TX := NewCaptionRect.Right - GetGlyphTextWidth - 2;
      end;
      Brush.Style := bsClear;

      if not FGlyph.Empty
      then
      begin
        GY := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2 - FGlyph.Height div 2;
        GX := TX;
        TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
        GlyphNum := 1;
        if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
       end;
      TextRect(NewCaptionRect, TX, TY, Caption);
      if not FGlyph.Empty
      then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
    end;
  // paint buttons
  for i := 0 to 2 do DrawButton(B.Canvas, i);
end;

procedure TspSkinCustomListBox.CreateControlDefaultImage;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

var
  BW, i, TX, TY: Integer;
  R: TRect;
  GX, GY: Integer;
  GlyphNum: Integer;
begin
  inherited;
  if FCaptionMode
  then
    begin
      BW := 17;
      if BW > FDefaultCaptionHeight - 3 then BW := FDefaultCaptionHeight - 3;
      Buttons[0].R := Rect(Width - BW - 2, 2, Width - 2, 1 + BW);
      Buttons[1].R := Rect(Buttons[0].R.Left - BW, 2, Buttons[0].R.Left, 1 + BW);
      Buttons[2].R := Rect(Buttons[1].R.Left - BW, 2, Buttons[1].R.Left, 1 + BW);
    end;  
  R := ClientRect;
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  if FCaptionMode
  then
    with B.Canvas do
    begin
      R := Rect(3, 2, Width - BW * 3 - 3, FDefaultCaptionHeight - 2);
      Font.Assign(FDefaultCaptionFont);
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet;
        
      case Alignment of
        taLeftJustify: TX := R.Left;
        taCenter: TX := R.Left + RectWidth(R) div 2 - GetGlyphTextWidth div 2;
        taRightJustify: TX := R.Right - GetGlyphTextWidth;
      end;

      TY := (FDefaultCaptionHeight - 2) div 2 - TextHeight(Caption) div 2;

      if not FGlyph.Empty
      then
        begin
          GY := R.Top + RectHeight(R) div 2 - FGlyph.Height div 2 - 1;
          GX := TX;
          if FNumGlyphs = 0 then FNumGlyphs := 1;
          TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
          GlyphNum := 1;
          if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
        end;
      TextRect(R, TX, TY, Caption);
      if not FGlyph.Empty
      then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
      Pen.Color := clBtnShadow;
      MoveTo(1, FDefaultCaptionHeight - 1); LineTo(Width - 1, FDefaultCaptionHeight - 1);
      for i := 0 to 2 do DrawButton(B.Canvas, i);
    end;
end;

procedure TspSkinCustomListBox.SetCaptionMode;
begin
  FCaptionMode := Value;
  if FIndex = -1
  then
    begin
      CalcRects;
      RePaint;
    end;
end;

function TspSkinCustomListBox.CalcHeight;
begin
  if FIndex = -1
  then
    begin
      Result := AitemsCount * ListBox.ItemHeight + 4;
      if CaptionMode then Result := Result + FDefaultCaptionHeight;
    end  
  else
    Result := ClRect.Top + AitemsCount * ListBox.ItemHeight +
              RectHeight(SkinRect) - ClRect.Bottom;
  if HScrollBar <> nil
  then
    Inc(Result, HScrollBar.Height);
end;

procedure TspSkinCustomListBox.Clear;
begin
  ListBox.Clear;
  UpDateScrollBar;
end;

function TspSkinCustomListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
begin
  Result := ListBox.ItemAtPos(Pos, Existing);
end;

function TspSkinCustomListBox.ItemRect(Item: Integer): TRect;
begin
  Result := ListBox.ItemRect(Item);
end;

function TspSkinCustomListBox.GetListBoxPopupMenu;
begin
  Result := ListBox.PopupMenu;
end;

procedure TspSkinCustomListBox.SetListBoxPopupMenu;
begin
  ListBox.PopupMenu := Value;
end;


function TspSkinCustomListBox.GetCanvas: TCanvas;
begin
  Result := ListBox.Canvas;
end;

function TspSkinCustomListBox.GetExtandedSelect: Boolean;
begin
  Result := ListBox.ExtendedSelect;
end;

procedure TspSkinCustomListBox.SetExtandedSelect(Value: Boolean);
begin
  ListBox.ExtendedSelect := Value;
end;

function TspSkinCustomListBox.GetSelCount: Integer;
begin
  Result := ListBox.SelCount;
end;

function TspSkinCustomListBox.GetSelected(Index: Integer): Boolean;
begin
  Result := ListBox.Selected[Index];
end;

procedure TspSkinCustomListBox.SetSelected(Index: Integer; Value: Boolean);
begin
  ListBox.Selected[Index] := Value;
end;

function TspSkinCustomListBox.GetSorted: Boolean;
begin
  Result := ListBox.Sorted;
end;

procedure TspSkinCustomListBox.SetSorted(Value: Boolean);
begin
  if ScrollBar <> nil then HideScrollBar;
  ListBox.Sorted := Value;
end;

function TspSkinCustomListBox.GetTopIndex: Integer;
begin
  Result := ListBox.TopIndex;
end;

procedure TspSkinCustomListBox.SetTopIndex(Value: Integer);
begin
  ListBox.TopIndex := Value;
end;

function TspSkinCustomListBox.GetMultiSelect: Boolean;
begin
  Result := ListBox.MultiSelect;
end;

procedure TspSkinCustomListBox.SetMultiSelect(Value: Boolean);
begin
  ListBox.MultiSelect := Value;
end;

function TspSkinCustomListBox.GetListBoxFont: TFont;
begin
  Result := ListBox.Font;
end;

procedure TspSkinCustomListBox.SetListBoxFont(Value: TFont);
begin
  ListBox.Font.Assign(Value);
end;

function TspSkinCustomListBox.GetListBoxTabOrder: TTabOrder;
begin
  Result := ListBox.TabOrder;
end;

procedure TspSkinCustomListBox.SetListBoxTabOrder(Value: TTabOrder);
begin
  ListBox.TabOrder := Value;
end;

function TspSkinCustomListBox.GetListBoxTabStop: Boolean;
begin
  Result := ListBox.TabStop;
end;

procedure TspSkinCustomListBox.SetListBoxTabStop(Value: Boolean);
begin
  ListBox.TabStop := Value;
end;

procedure TspSkinCustomListBox.ShowScrollBar;
begin
  ScrollBar := TspSkinScrollBar.Create(Self);
  with ScrollBar do
  begin
    if Columns > 0
    then
      Kind := sbHorizontal
    else
      Kind := sbVertical;
    Height := 100;
    Width := 20;
    PageSize := 0;
    Min := 0;
    Position := 0;
    OnChange := SBChange;
    if Self.FIndex = -1
    then
      SkinDataName := ''
    else
      if Columns > 0
      then
        SkinDataName := HScrollBarName
      else
        SkinDataName := VScrollBarName;
    SkinData := Self.SkinData;
    Parent := Self;
    //
    if HScrollBar <> nil
    then
    with HScrollBar do
    begin
      if Self.FIndex = -1
      then
        begin
          SkinDataName := '';
          FBoth := True;
          BothMarkerWidth := 19;
        end
      else
        begin
          BothSkinDataName := BothScrollBarName;
          SkinDataName := BothScrollBarName;
          FBoth := True;
        end;
      SkinData := Self.SkinData;
    end;
    //
    CalcRects;
    Visible := True;
  end;
  RePaint;
end;

procedure TspSkinCustomListBox.ShowHScrollBar;
begin
  HScrollBar := TspSkinScrollBar.Create(Self);
  with HScrollBar do
  begin
    Kind := sbHorizontal;
    Height := 100;
    Width := 20;
    PageSize := 0;
    Min := 0;
    Position := 0;
    OnChange := HSBChange;
    if Self.FIndex = -1
    then
      begin
        SkinDataName := '';
        if ScrollBar <> nil
        then
          begin
            FBoth := True;
            BothMarkerWidth := 19;
          end;
      end
    else
      if ScrollBar <> nil
      then
        begin
          BothSkinDataName := BothScrollBarName;
          SkinDataName := BothScrollBarName;
          FBoth := True;
        end
      else
        begin
          BothSkinDataName := HScrollBarName;
          SkinDataName := HScrollBarName;
          FBoth := False;
        end;
    SkinData := Self.SkinData;
    Parent := Self;
    Visible := True;
    CalcRects;
  end;
  RePaint;
end;


procedure TspSkinCustomListBox.ListBoxEnter;
begin
end;

procedure TspSkinCustomListBox.ListBoxExit;
begin
end;

procedure TspSkinCustomListBox.ListBoxKeyDown;
begin
  if Assigned(FOnListBoxKeyDown) then FOnListBoxKeyDown(Self, Key, Shift);
end;

procedure TspSkinCustomListBox.ListBoxKeyUp;
begin
  if Assigned(FOnListBoxKeyUp) then FOnListBoxKeyUp(Self, Key, Shift);
end;

procedure TspSkinCustomListBox.ListBoxKeyPress;
begin
  if Assigned(FOnListBoxKeyPress) then FOnListBoxKeyPress(Self, Key);
end;

procedure TspSkinCustomListBox.ListBoxDblClick;
begin
  if Assigned(FOnListBoxDblClick) then FOnListBoxDblClick(Self);
end;

procedure TspSkinCustomListBox.ListBoxClick;
begin
  if Assigned(FOnListBoxClick) then FOnListBoxClick(Self);
end;

procedure TspSkinCustomListBox.ListBoxMouseDown;
begin
  if Assigned(FOnListBoxMouseDown) then FOnListBoxMouseDown(Self, Button, Shift, X, Y);
end;

procedure TspSkinCustomListBox.ListBoxMouseMove;
begin
  if Assigned(FOnListBoxMouseMove) then FOnListBoxMouseMove(Self, Shift, X, Y);
end;

procedure TspSkinCustomListBox.ListBoxMouseUp;
begin
  if Assigned(FOnListBoxMouseUp) then FOnListBoxMouseUp(Self, Button, Shift, X, Y);
end;

procedure TspSkinCustomListBox.HideScrollBar;
begin
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  CalcRects;
end;

procedure TspSkinCustomListBox.HideHScrollBar;
begin
  ListBox.HorizontalExtentValue := 0;
  HScrollBar.Visible := False;
  HScrollBar.Free;
  HScrollBar := nil;
  CalcRects;
  ListBox.Repaint;
end;

procedure TspSkinCustomListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TspSkinCustomListBox.HSBChange(Sender: TObject);
begin
  ListBox.HorizontalExtentValue := HScrollBar.Position;
  ListBox.Repaint;
end;

procedure TspSkinCustomListBox.SBChange;
var
  LParam, WParam: Integer;
begin
  LParam := 0;
  WParam := MakeWParam(SB_THUMBPOSITION, ScrollBar.Position);
  if Columns > 0
  then
    SendMessage(ListBox.Handle, WM_HSCROLL, WParam, LParam)
  else
    begin
      SendMessage(ListBox.Handle, WM_VSCROLL, WParam, LParam);
    end;
end;


function TspSkinCustomListBox.GetItemIndex;
begin
  Result := ListBox.ItemIndex;
end;

procedure TspSkinCustomListBox.SetItemIndex;
begin
  ListBox.ItemIndex := Value;
end;

procedure TspSkinCustomListBox.SetItems;
begin
  ListBox.Items.Assign(Value);
  UpDateScrollBar;
end;

function TspSkinCustomListBox.GetItems;
begin
  Result := ListBox.Items;
end;

destructor TspSkinCustomListBox.Destroy;
begin
  if ScrollBar <> nil then ScrollBar.Free;
  if ListBox <> nil then ListBox.Free;
  FDefaultCaptionFont.Free;
  FGlyph.Free;
  inherited;
end;

procedure TspSkinCustomListBox.CalcRects;
var
  LTop: Integer;
  OffX, OffY: Integer;
  HSY: Integer;
begin
  if FIndex <> -1
  then
    begin
      OffX := Width - RectWidth(SkinRect);
      OffY := Height - RectHeight(SkinRect);
      NewClRect := ClRect;
      Inc(NewClRect.Right, OffX);
      Inc(NewClRect.Bottom, OffY);
    end
  else
    if FCaptionMode
    then
      LTop := FDefaultCaptionHeight
    else
      LTop := 1;

  if (Columns = 0) and (HScrollBar <> nil) and (HScrollBar.Visible)
  then
    begin
      if FIndex = -1
      then
        begin
          HScrollBar.SetBounds(1, Height - 20, Width - 2, 19);
          HSY := HScrollBar.Height - 1;
        end
      else
        begin
          HScrollBar.SetBounds(NewClRect.Left,
            NewClRect.Bottom - HScrollBar.Height,
            RectWidth(NewClRect), HScrollBar.Height);
          HSY := HScrollBar.Height;
        end;
    end
  else
    HSY := 0;
  if (ScrollBar <> nil) and ScrollBar.Visible
  then
    begin
      if FIndex = -1
      then
        begin
          if Columns > 0
          then
            begin
              ScrollBar.SetBounds(1, Height - 20, Width - 2, 19);
              ListRect := Rect(2, LTop + 1, Width - 2, ScrollBar.Top);
            end
          else
            begin
              ScrollBar.SetBounds(Width - 20, LTop, 19, Height - 1 - LTop - HSY);
              ListRect := Rect(2, LTop + 1, ScrollBar.Left, Height - 2 - HSY);
            end;
        end
      else
        begin
          if Columns > 0
          then
            begin
              ScrollBar.SetBounds(NewClRect.Left,
                NewClRect.Bottom - ScrollBar.Height,
                RectWidth(NewClRect), ScrollBar.Height);
              ListRect := NewClRect;
              Dec(ListRect.Bottom, ScrollBar.Height);
            end
          else
            begin
              ScrollBar.SetBounds(NewClRect.Right - ScrollBar.Width,
                NewClRect.Top, ScrollBar.Width, RectHeight(NewClRect) - HSY);
              ListRect := NewClRect;
              Dec(ListRect.Right, ScrollBar.Width);
              Dec(ListRect.Bottom, HSY);
            end;
        end;
    end
  else
    begin
      if FIndex = -1
      then
        ListRect := Rect(2, LTop + 1, Width - 2, Height - 2)
      else
        ListRect := NewClRect;
    end;
  if ListBox <> nil
  then
    ListBox.SetBounds(ListRect.Left, ListRect.Top,
      RectWidth(ListRect), RectHeight(ListRect));
end;

procedure TspSkinCustomListBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinListBox
    then
      with TspDataSkinListBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.SItemRect := SItemRect;
        Self.ActiveItemRect := ActiveItemRect;
        if isNullRect(ActiveItemRect)
        then
          Self.ActiveItemRect := SItemRect;
        Self.FocusItemRect := FocusItemRect;
        if isNullRect(FocusItemRect)
        then
          Self.FocusItemRect := SItemRect;

        Self.ItemLeftOffset := ItemLeftOffset;
        Self.ItemRightOffset := ItemRightOffset;
        Self.ItemTextRect := ItemTextRect;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.FocusFontColor := FocusFontColor;
        //
        Self.CaptionRect := CaptionRect;
        Self.CaptionFontName := CaptionFontName;
        Self.CaptionFontStyle := CaptionFontStyle;
        Self.CaptionFontHeight := CaptionFontHeight;
        Self.CaptionFontColor := CaptionFontColor;
        Self.UpButtonRect := UpButtonRect;
        Self.ActiveUpButtonRect := ActiveUpButtonRect;
        Self.DownUpButtonRect := DownUpButtonRect;
        if IsNullRect(Self.DownUpButtonRect)
        then Self.DownUpButtonRect := Self.ActiveUpButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.ActiveDownButtonRect := ActiveDownButtonRect;
        Self.DownDownButtonRect := DownDownButtonRect;
        if IsNullRect(Self.DownDownButtonRect)
        then Self.DownDownButtonRect := Self.ActiveDownButtonRect;
        Self.CheckButtonRect := CheckButtonRect;
        Self.ActiveCheckButtonRect := ActiveCheckButtonRect;
        Self.DownCheckButtonRect := DownCheckButtonRect;
        if IsNullRect(Self.DownCheckButtonRect)
        then Self.DownCheckButtonRect := Self.ActiveCheckButtonRect;
        //
        Self.VScrollBarName := VScrollBarName;
        Self.HScrollBarName := HScrollBarName;
        Self.BothScrollBarName := BothScrollBarName;
      end;
end;

procedure TspSkinCustomListBox.ChangeSkinData;
begin
  inherited;
  //
  FStopUpDateHScrollBar := True;
  if (FIndex <> -1)
  then
    begin
      if FUseSkinItemHeight
      then
        ListBox.ItemHeight := RectHeight(sItemRect);
    end
  else
    begin
      ListBox.ItemHeight := FDefaultItemHeight;
      Font.Assign(FDefaultFont);
    end;
    
  if ScrollBar <> nil
  then
    with ScrollBar do
    begin
      if Self.FIndex = -1
      then
        SkinDataName := ''
      else
        if Columns > 0
        then
          SkinDataName := HScrollBarName
        else
          SkinDataName := VScrollBarName;
      SkinData := Self.SkinData;
    end;

  if HScrollBar <> nil
  then
    with HScrollBar do
    begin
      if Self.FIndex = -1
      then
        begin
          SkinDataName := '';
          if ScrollBar <> nil then BothMarkerWidth := 19;
        end
      else
        if ScrollBar <> nil
        then
          SkinDataName := BothScrollBarName
        else
          SkinDataName := HScrollBarName;
      SkinData := Self.SkinData;
    end;

  if FRowCount <> 0
  then
    Height := Self.CalcHeight(FRowCount);
  CalcRects;
  FStopUpDateHScrollBar := False;
  UpDateScrollBar;
  ListBox.RePaint;
end;

procedure TspSkinCustomListBox.WMSIZE;
begin
  inherited;
  CalcRects;
  UpDateScrollBar;
  if ScrollBar <> nil then ScrollBar.RePaint;
end;

procedure TspSkinCustomListBox.SetBounds;
begin
  inherited;
  if FIndex = -1 then RePaint;
end;

function TspSkinCustomListBox.GetFullItemWidth(Index: Integer; ACnvs: TCanvas): Integer;
begin
  Result := ACnvs.TextWidth(Items[Index]);
end;

procedure TspSkinCustomListBox.UpDateScrollBar;
var
  I, FMaxWidth, Min, Max, Pos, Page: Integer;

function GetPageSize: Integer;
begin
  if FIndex = -1
  then Result := ListBox.Width - 4
  else
    begin
      Result := RectWidth(SItemRect) - RectWidth(ItemTextRect);
      Result := ListBox.Width - Result;
    end;
  if Images <> nil then Result := Result - Images.Width - 4;
end;

begin
  if (ListBox = nil) then Exit;
  if Columns > 0
  then
    begin
      GetScrollRange(ListBox.Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(ListBox.Handle, SB_HORZ);
      Page := ListBox.Columns;
      if (Max > Min) and (Pos <= Max) and (Page <= Max) and
         ((ListBox.Height div ListBox.ItemHeight) * Columns < ListBox.Items.Count)
      then
        begin
          if ScrollBar = nil
          then ShowScrollBar;
          ScrollBar.SetRange(Min, Max, Pos, Page);
        end
     else
       if (ScrollBar <> nil) and ScrollBar.Visible
       then HideScrollBar;
    end
  else
    begin
      if FHorizontalExtent and not FStopUpDateHScrollBar
      then
        begin
          FMaxWidth := 0;
          with ListBox.Canvas do
          begin
            if FIndex = -1
            then
              Font.Assign(ListBox.Font)
            else
              begin
                Font.Name := FontName;
                Font.Style := FontStyle;
                Font.Height := FontHeight;
              end;
          end;
          for I := 0 to Items.Count - 1 do
            FMaxWidth := spUtils.Max(FMaxWidth, GetFullItemWidth(I, ListBox.Canvas));
          Page := GetPageSize;
          if FMaxWidth > Page
          then
            begin
             if HScrollBar = nil then ShowHScrollBar;
             HScrollBar.SetRange(0, FMaxWidth, HScrollBar.Position, Page);
             HScrollBar.SmallChange := ListBox.Canvas.TextWidth('0');
             HScrollBar.LargeChange := ListBox.Canvas.TextWidth('0');
           end
         else
          if (HScrollBar <> nil) and HScrollBar.Visible then HideHScrollBar;
       end
      else
        if (HScrollBar <> nil) and HScrollBar.Visible then HideHScrollBar;

      if not ((FRowCount > 0) and (RowCount = Items.Count))
      then
        begin
          GetScrollRange(ListBox.Handle, SB_VERT, Min, Max);
          Pos := GetScrollPos(ListBox.Handle, SB_VERT);
          Page := ListBox.Height div ListBox.ItemHeight;
          if (Max > Min) and (Pos <= Max) and (Page < Items.Count)
          then
            begin
              if ScrollBar = nil then ShowScrollBar;
              ScrollBar.SetRange(Min, Max, Pos, Page);
              ScrollBar.LargeChange := Page;
            end
          else
            if (ScrollBar <> nil) and ScrollBar.Visible then HideScrollBar;
        end
      else
        if (ScrollBar <> nil) and ScrollBar.Visible then HideScrollBar;
    end;
end;

// combobox

constructor TspSkinCustomComboBox.Create;
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csOpaque, csDoubleClicks, csAcceptsControls];
  FHideSelection := True;
  FAutoComplete := True;
  FListBoxAlphaBlendAnimation := False;
  FListBoxAlphaBlend := False;
  FListBoxAlphaBlendValue := 200;

  TabStop := True;
  Font.Name := 'Arial';
  Font.Color := clWindowText;
  Font.Style := [];
  Font.Height := 14;
  Width := 120;
  Height := 20;
  FromEdit := False;
  FEdit := nil;
  //
  FStyle := spcbFixedStyle;
  FOnListBoxDrawItem := nil;
  FListBox := TspPopupListBox.Create(Self);
  FListBox.Visible := False;
  FlistBox.Parent := Self;
  FListBox.ListBox.TabStop := False;
  FlistBox.ListBox.OnMouseDown := ListBoxMouseDown;
  FlistBox.ListBox.OnMouseMove := ListBoxMouseMove;
  FlistBox.ListBox.OnMouseUp  := ListBoxMouseUp;
  FListBoxWindowProc := FlistBox.ListBox.WindowProc;
  FlistBox.ListBox.WindowProc := ListBoxWindowProcHook;
  FListBox.OnCheckButtonClick := CheckButtonClick;
  FLBDown := False;
  FDropDownCount := 8;
  //
  CalcRects;
  FSkinDataName := 'combobox';
end;

destructor TspSkinCustomComboBox.Destroy;
begin
  if FEdit <> nil then FEdit.Free;
  FlistBox.Free;
  FlistBox := nil;
  inherited;
end;

procedure TspSkinCustomComboBox.FindLBItem(S: String);
var
  I: Integer;
  S1: String;
begin
  if (FListBox = nil) or (FListBox.ListBox = nil) then Exit;
  if FAutoComplete
  then
    begin
      if GetTickCount - FLastTime >= 500 then FFilter := '';
      FLastTime := GetTickCount;
      FFilter := FFilter + S;
      S := FFilter;
    end;
  if Length(S) > 0
  then
    begin
      if Length(S) = 1
      then
        I := SendMessage(FListBox.ListBox.Handle, LB_FINDSTRING, ItemIndex, LongInt(PChar(S)))
      else
        I := SendMessage(FListBox.ListBox.Handle, LB_FINDSTRING, -1, LongInt(PChar(S)));
    end
  else
    I := -1;
  if I >= 0 then ItemIndex := I;
end;

procedure TspSkinCustomComboBox.FindLBItemFromEdit;
var
  I: Integer;
  S1, S2: String;
begin
  if (FListBox = nil) or (FListBox.ListBox = nil) then Exit;

  if GetTickCount - FLastTime <= 200
  then
    Exit
  else
    FLastTime := GetTickCount;
    
  if Length(Text) = 1
  then
    I := SendMessage(FListBox.ListBox.Handle, LB_FINDSTRING, ItemIndex, LongInt(PChar(Text)))
  else
    I := SendMessage(FListBox.ListBox.Handle, LB_FINDSTRING, -1, LongInt(PChar(Text)));
  if I >= 0
  then
    begin
      S1 := Text;
      ItemIndex := I;
      S2 := Text;
      SelStart := Length(S1);
      SelLength := Length(S2) - Length(S1);
    end;
end;

procedure TspSkinCustomComboBox.KeyPress;
begin
  inherited;
  FindLBItem(Key);
end;


function TspSkinCustomComboBox.GetSelStart: Integer;
begin
  if (FEdit <> nil) then Result := FEdit.SelStart else Result := 0;
end;

procedure TspSkinCustomComboBox.SetSelStart(Value: Integer);
begin
  if (FEdit <> nil) then FEdit.SelStart := Value;
end;

function TspSkinCustomComboBox.GetSelLength: Integer;
begin
  if (FEdit <> nil) then Result := FEdit.SelLength else Result := 0;
end;

procedure TspSkinCustomComboBox.SetSelLength(Value: Integer);
begin
  if (FEdit <> nil) then FEdit.SelLength := Value;
end;


function TspSkinCustomComboBox.GetListBoxUseSkinItemHeight: Boolean;
begin
  Result := FListBox.UseSkinItemHeight;
end;

procedure TspSkinCustomComboBox.SetListBoxUseSkinItemHeight(Value: Boolean);
begin
  FListBox.UseSkinItemHeight := Value;
end;

procedure TspSkinCustomComboBox.EditKeyDown;
begin
  if Assigned(OnKeyDown) then OnKeyDown(Self, Key, Shift);
end;

procedure TspSkinCustomComboBox.EditKeyUp;
begin
  if Assigned(OnKeyUp) then OnKeyUp(Self, Key, Shift);
end;

procedure TspSkinCustomComboBox.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
end;

procedure TspSkinCustomComboBox.CMEnabledChanged;
begin
  inherited;
  RePaint;
end;

function TspSkinCustomComboBox.GetHorizontalExtent: Boolean;
begin
  Result := FlistBox.HorizontalExtent;
end;

procedure TspSkinCustomComboBox.SetHorizontalExtent(Value: Boolean);
begin
  FlistBox.HorizontalExtent := Value;
end;

procedure TspSkinCustomComboBox.Change;
begin
end;

procedure TspSkinCustomComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

function TspSkinCustomComboBox.GetImages: TCustomImageList;
begin
  if FListBox <> nil
  then
    Result := FListBox.Images
  else
    Result := nil;
end;

function TspSkinCustomComboBox.GetImageIndex: Integer;
begin
  Result := FListBox.ImageIndex;
end;

procedure TspSkinCustomComboBox.SetImages(Value: TCustomImageList);
begin
  FListBox.Images := Value;
  RePaint;
end;

procedure TspSkinCustomComboBox.SetImageIndex(Value: Integer);
begin
  FListBox.ImageIndex := Value;
  RePaint;
end;

procedure TspSkinCustomComboBox.EditCancelMode(C: TControl);
begin
  if (C <> Self)and
     (C <> Self.FListBox) and
     (C <> Self.FListBox.ScrollBar) and
     (C <> Self.FListBox.HScrollBar) and
     (C <> Self.FListBox.ListBox)
  then
    CloseUp(False);
end;

procedure TspSkinCustomComboBox.CMCancelMode;
begin
  inherited;
  if (Message.Sender <> Self)and
     (Message.Sender <> Self.FListBox) and
     (Message.Sender <> Self.FListBox.ScrollBar) and
     (Message.Sender <> Self.FListBox.HScrollBar) and
     (Message.Sender <> Self.FListBox.ListBox)
  then
    CloseUp(False);
end;

function TspSkinCustomComboBox.GetListBoxDefaultFont;
begin
  Result := FListBox.DefaultFont;
end;

procedure TspSkinCustomComboBox.SetListBoxDefaultFont;
begin
  FListBox.DefaultFont.Assign(Value);
end;

function TspSkinCustomComboBox.GetListBoxDefaultCaptionFont;
begin
  Result := FListBox.DefaultCaptionFont;
end;

procedure TspSkinCustomComboBox.SetListBoxDefaultCaptionFont;
begin
  FListBox.DefaultCaptionFont.Assign(Value);
end;

function TspSkinCustomComboBox.GetListBoxDefaultItemHeight;
begin
  Result := FListBox.DefaultItemHeight;
end;

procedure TspSkinCustomComboBox.SetListBoxDefaultItemHeight;
begin
  FListBox.DefaultItemHeight := Value;
end;

function TspSkinCustomComboBox.GetListBoxCaptionAlignment;
begin
  Result := FListBox.Alignment;
end;

procedure TspSkinCustomComboBox.SetListBoxCaptionAlignment;
begin
  FListBox.Alignment := Value;
end;

procedure TspSkinCustomComboBox.DefaultFontChange;
begin
  Font.Assign(FDefaultFont);
end;

procedure TspSkinCustomComboBox.CheckButtonClick;
begin
  CloseUp(True);
end;

procedure TspSkinCustomComboBox.SetListBoxCaption;
begin
  FListBox.Caption := Value;
end;

function  TspSkinCustomComboBox.GetListBoxCaption;
begin
  Result := FListBox.Caption;
end;

procedure TspSkinCustomComboBox.SetListBoxCaptionMode;
begin
  FListBox.CaptionMode := Value;
end;

function  TspSkinCustomComboBox.GetListBoxCaptionMode;
begin
  Result := FListBox.CaptionMode;
end;

function TspSkinCustomComboBox.GetSorted: Boolean;
begin
  Result := FListBox.Sorted;
end;

procedure TspSkinCustomComboBox.SetSorted(Value: Boolean);
begin
  FListBox.Sorted := Value;
end;

procedure TspSkinCustomComboBox.SetListBoxDrawItem;
begin
  FOnListboxDrawItem := Value;
  FListBox.OnDrawItem := FOnListboxDrawItem;
end;

procedure TspSkinCustomComboBox.ListBoxDrawItem(Cnvs: TCanvas; Index: Integer;
            ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
begin
  if Assigned(FOnListBoxDrawItem)
  then FOnListBoxDrawItem(Cnvs, Index, ItemWidth, ItemHeight, TextRect, State);
end;

procedure TspSkinCustomComboBox.SetStyle;
begin
  if (FStyle = Value) and (csDesigning in ComponentState) then Exit;
  FStyle := Value;
  case FStyle of
    spcbFixedStyle:
      begin
        TabStop := True;
        if FEdit <> nil then HideEditor;
      end;
    spcbEditStyle:
      begin
        TabStop := False;
        ShowEditor;
        FEdit.Text := Text; 
        if Focused then FEdit.SetFocus;
      end;
  end;
  CalcRects;
  ReCreateWnd;
  RePaint;
end;

procedure TspSkinCustomComboBox.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:  Msg.Result := 1;
  end;
end;

procedure TspSkinCustomComboBox.KeyDown;
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_UP, VK_LEFT:
      if ssAlt in Shift
      then
        begin
          if FListBox.Visible then CloseUp(False);
        end
      else
        EditUp1(True);
    VK_DOWN, VK_RIGHT:
      if ssAlt in Shift
      then
        begin
          if not FListBox.Visible then DropDown;
        end
      else
        EditDown1(True);

    VK_NEXT: EditPageDown1(True);
    VK_PRIOR: EditPageUp1(True);
    VK_ESCAPE: if FListBox.Visible then CloseUp(False);
    VK_RETURN: if FListBox.Visible then CloseUp(True);
  end;
end;

procedure TspSkinCustomComboBox.WMMOUSEWHEEL;
begin
  if FEdit <> nil then Exit;
  if Message.WParam > 0
  then
    EditUp1(not FListBox.Visible)
  else
    EditDown1(not FListBox.Visible);
end;

procedure TspSkinCustomComboBox.WMSETFOCUS;
begin
  if FEdit <> nil
  then
    FEDit.SetFocus
  else
    begin
      inherited;
      RePaint;
    end;
end;

procedure TspSkinCustomComboBox.WMKILLFOCUS;
begin
  inherited;
  if FListBox.Visible and (FEdit = nil)
  then CloseUp(False);
  RePaint;
end;

procedure TspSkinCustomComboBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinComboBox
    then
      with TspDataSkinComboBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.SItemRect := SItemRect;
        Self.FocusItemRect := FocusItemRect;
        if isNullRect(FocusItemRect)
        then
          Self.FocusItemRect := SItemRect;
        Self.ItemLeftOffset := ItemLeftOffset;
        Self.ItemRightOffset := ItemRightOffset;
        Self.ItemTextRect := ItemTextRect;

        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.FocusFontColor := FocusFontColor;

        Self.ButtonRect := ButtonRect;
        Self.ActiveButtonRect := ActiveButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.UnEnabledButtonRect := UnEnabledButtonRect;
        Self.ListBoxName := ListBoxName;
      end;
end;

procedure TspSkinCustomComboBox.Invalidate;
begin
  inherited;
  if (FIndex <> -1) and (FEdit <> nil) then FEdit.Invalidate;
end;


function TspSkinCustomComboBox.GetItemIndex;
begin
  Result := FListBox.ItemIndex;
end;

procedure TspSkinCustomComboBox.SetItemIndex;
begin
  FListBox.ItemIndex := Value;
  if (FListBox.Items.Count > 0) and (FListBox.ItemIndex <> -1)
  then
    Text := FListBox.Items[FListBox.ItemIndex];
  FOldItemIndex := FListBox.ItemIndex;
  if FEdit = nil then RePaint;
  if not (csDesigning in ComponentState) and
     not (csLoading in ComponentState)
  then
    begin
      if Assigned(FOnClick) then FOnClick(Self);
      Change;
    end;
end;

function TspSkinCustomComboBox.IsPopupVisible: Boolean;
begin
  Result := FListBox.Visible;
end;

function TspSkinCustomComboBox.CanCancelDropDown;
begin
  Result := FListBox.Visible and not FMouseIn;
end;


procedure TspSkinCustomComboBox.EditWindowProcHook(var Message: TMessage);
function GetCharSet: TFontCharSet;
begin
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Result := SkinData.ResourceStrData.CharSet
  else
    Result := FDefaultFont.Charset;
end;

var
  FOld: Boolean;
  Index: Integer;
  CharSet: TFontCharSet;
begin
  FOld := True;
  case Message.Msg of
    WM_LBUTTONDOWN, WM_RBUTTONDOWN:
      begin
        if FListBox.Visible then CloseUp(False);
      end;
    WM_KILLFOCUS:
      begin
        if FListBox.Visible then CloseUp(False);
      end;
    WM_MOUSEWHEEL:
     begin
       if Message.WParam > 0
       then
         EditUp(not FListBox.Visible)
       else
         EditDown(not FListBox.Visible);
     end;

    WM_SYSKEYUP:
      begin
        CharSet := GetCharSet;
        if (CharSet = SHIFTJIS_CHARSET) or (CharSet = GB2312_CHARSET) or
           (CharSet = SHIFTJIS_CHARSET) or (CharSet = CHINESEBIG5_CHARSET)
        then
          begin
            if not ((TWMKEYUP(Message).CharCode = 46) or
                   (TWMKEYUP(Message).CharCode =8))
            then
              begin
                FEdit.ClearSelection;
                FEditWindowProc(Message);
                FOld := False;
                if FAutoComplete then FindLBItemFromEdit;
              end;
          end;
      end;

    WM_KEYUP:
      begin
        CharSet := GetCharSet;
        if (CharSet = SHIFTJIS_CHARSET) or (CharSet = GB2312_CHARSET) or
           (CharSet = SHIFTJIS_CHARSET) or (CharSet = CHINESEBIG5_CHARSET)
        then
          begin
            if not ((TWMKEYUP(Message).CharCode = 46) or
                    (TWMKEYUP(Message).CharCode = 8))
            then
              begin
                FEdit.ClearSelection;
                FEditWindowProc(Message);
                FOld := False;
                if FAutoComplete then FindLBItemFromEdit;
              end;
          end
        else
        if TWMKEYUP(Message).CharCode > 47
        then
          begin
            FEditWindowProc(Message);
            FOld := False;
            if FAutoComplete then FindLBItemFromEdit;
          end;
      end;

    WM_KEYDOWN:
      begin
        case TWMKEYDOWN(Message).CharCode of
          VK_PRIOR:
            if FListBox.Visible
            then
              begin
                Index := FListBox.ItemIndex - DropDownCount - 1;
                if Index < 0
                then
                  Index := 0;
                FListBox.ItemIndex := Index;
              end;
          VK_NEXT:
            if FListBox.Visible
            then
              begin
                Index := FListBox.ItemIndex + DropDownCount - 1;
                if Index > FListBox.Items.Count - 1
                then
                  Index := FListBox.Items.Count - 1;
                FListBox.ItemIndex := Index;
              end;
          VK_RETURN:
            begin
              if FListBox.Visible then CloseUp(True);
            end;
          VK_ESCAPE:
            begin
              if FListBox.Visible then CloseUp(False);
            end;
          VK_UP:
            begin
              EditUp(True);
              FOld := False;
            end;
          VK_DOWN:
            begin
              EditDown(True);
              FOld := False;
            end;
        end;
      end;
  end;
  if FOld then FEditWindowProc(Message);
end;

procedure TspSkinCustomComboBox.ListBoxWindowProcHook(var Message: TMessage);
var
  FOld: Boolean;
begin
  FOld := True;
  case Message.Msg of
     WM_LBUTTONUP:
       begin
         CloseUp(True);
         FOLD := False;
       end;
     WM_RBUTTONDOWN, WM_RBUTTONUP,
     WM_MBUTTONDOWN, WM_MBUTTONUP,
     WM_LBUTTONDOWN:
      begin
         FOLd := False;
       end;
     WM_MOUSEACTIVATE:
      begin
        Message.Result := MA_NOACTIVATE;
      end;
  end;
  if FOld then FListBoxWindowProc(Message);
end;

procedure TspSkinCustomComboBox.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
end;

procedure TspSkinCustomComboBox.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end;
end;

procedure TspSkinCustomComboBox.SetDropDownCount(Value: Integer);
begin
  if Value > 0
  then
    FDropDownCount := Value;
end;

procedure TspSkinCustomComboBox.ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
                           Shift: TShiftState; X, Y: Integer);
begin
  FLBDown := True;
end;

procedure TspSkinCustomComboBox.ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
                           X, Y: Integer);

var
  Index: Integer;
begin
  if not FLBDown
  then
    begin
      Index := FListBox.ItemAtPos(Point (X, Y), True);
      if (Index >= 0) and (Index < Items.Count)
      then
        FListBox.ItemIndex := Index;
    end;
end;

procedure TspSkinCustomComboBox.ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
                         Shift: TShiftState; X, Y: Integer);
begin
  FLBDown := False;
  CloseUp(True);
end;


procedure TspSkinCustomComboBox.SetItems;
begin
  FListBox.Items.Assign(Value);
end;

function TspSkinCustomComboBox.GetItems;
begin
  Result := FListBox.Items;
end;

procedure TspSkinCustomComboBox.MouseDown;
begin
  inherited;
  if not Focused and (FEdit = nil) then SetFocus;
  if Button <> mbLeft then Exit;
  if Self.Button.MouseIn or
     (PtInRect(CBItem.R, Point(X, Y)) and (FEdit = nil))
  then
    begin
      Self.Button.Down := True;
      RePaint;
      if FListBox.Visible then CloseUp(False) else DropDown;
    end
  else
    if FListBox.Visible then CloseUp(False);
end;

procedure TspSkinCustomComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  if Self.Button.Down
  then
    begin
      Self.Button.Down := False;
      RePaint;
    end;
end;

procedure TspSkinCustomComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(Button.R, Point(X, Y)) and not Button.MouseIn
  then
    begin
      Button.MouseIn := True;
      RePaint;
    end
  else
  if not PtInRect(Button.R, Point(X, Y)) and Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end;
end;

procedure TspSkinCustomComboBox.CloseUp;
begin
  if not FListBox.Visible then Exit;
  FListBox.Hide;
  if (FListBox.ItemIndex >= 0) and
     (FListBox.ItemIndex < FListBox.Items.Count) and Value
  then
    begin
      if FEdit <> nil
      then
        FEdit.Text := FListBox.Items[FListBox.ItemIndex]
      else
        begin
          Text := FListBox.Items[FListBox.ItemIndex];
          RePaint;
        end;
       if Assigned(FOnClick) then FOnClick(Self);
       Change;
     end
  else
    FListBox.ItemIndex := FOldItemIndex;
  if Value
  then
    if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TspSkinCustomComboBox.DropDown;
var
  P: TPoint;
  WorkArea: TRect;
begin
  if Items.Count = 0 then Exit;

  if Assigned(FOnDropDown) then FOnDropDown(Self);

  FListBox.Width := Width;

  if Items.Count < DropDownCount
  then
    FListBox.Height := FListBox.CalcHeight(Items.Count)
  else
    FListBox.Height := FListBox.CalcHeight(DropDownCount);

  P := Point(Left, Top + Height);
  P := Parent.ClientToScreen (P);

  WorkArea := GetMonitorWorkArea(Handle, True);

  if P.Y + FListBox.Height > WorkArea.Bottom
  then
    P.Y  := P.Y - Height - FListBox.Height;

  if FEdit <> nil then FEdit.SetFocus;

  FOldItemIndex := FListBox.ItemIndex;

  if (FListBox.ItemIndex = 0) and (FListBox.Items.Count > 1)
  then
    begin
      FListBox.ItemIndex := 1;
      FListBox.ItemIndex := 0;
    end;

  FListBox.TopIndex := FListBox.ItemIndex;

  FListBox.Show(P);
end;

procedure TspSkinCustomComboBox.EditPageUp1(AChange: Boolean);
var
  Index: Integer;
begin
  Index := FListBox.ItemIndex - DropDownCount - 1;
  if Index < 0 then Index := 0;
  if AChange
  then
    ItemIndex := Index
  else
    FListBox.ItemIndex := Index;
end;

procedure TspSkinCustomComboBox.EditPageDown1(AChange: Boolean);
var
  Index: Integer;
begin
  Index := FListBox.ItemIndex + DropDownCount - 1;
  if Index > FListBox.Items.Count - 1
  then
    Index := FListBox.Items.Count - 1;
  if AChange
  then
    ItemIndex := Index
  else
    FListBox.ItemIndex := Index;
end;

procedure TspSkinCustomComboBox.EditUp1;
begin
  if FListBox.ItemIndex > 0
  then
    begin
      if AChange
      then
        ItemIndex := ItemIndex - 1
      else
        FListBox.ItemIndex := FListBox.ItemIndex - 1;
    end;
end;

procedure TspSkinCustomComboBox.EditDown1;
begin
  if FListBox.ItemIndex < FListBox.Items.Count - 1
  then
    begin
      if AChange
      then
        ItemIndex := ItemIndex + 1
      else
        FListBox.ItemIndex := FListBox.ItemIndex + 1;
    end;    
end;


procedure TspSkinCustomComboBox.EditUp;
begin
  if FListBox.ItemIndex > 0
  then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex - 1;
      if AChange
      then
        begin
          Text := FListBox.Items[FListBox.ItemIndex];
          if Assigned(FOnClick) then FOnClick(Self); 
        end;
    end;
end;

procedure TspSkinCustomComboBox.EditDown;
begin
  if FListBox.ItemIndex < FListBox.Items.Count - 1
  then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex + 1;
      if AChange
      then
        begin
          Text := FListBox.Items[FListBox.ItemIndex];
          if Assigned(FOnClick) then FOnClick(Self);
        end;
    end;
end;

procedure TspSkinCustomComboBox.EditChange(Sender: TObject);
var
  I: Integer;
begin
  FromEdit := True;
  if (FListBox <> nil) and (FEdit.Text <> '')
  then
    begin
      I := SendMessage(FListBox.ListBox.Handle, LB_FINDSTRING, -1, LongInt(PChar(FEdit.Text)));
      if I >= 0
      then
        if FAutoComplete
        then
          SendMessage(FListBox.ListBox.Handle, LB_SETCURSEL, I, 0)
        else
          SendMessage(FListBox.ListBox.Handle, LB_SETTOPINDEX, I, 0);
    end;
  Text := FEdit.Text;
  FromEdit := False;  
end;

procedure TspSkinCustomComboBox.ShowEditor;
begin
  FEdit := TspCustomEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.AutoSize := False;
  FEdit.HideSelection := FHideSelection;
  FEdit.Visible := True;
  FEdit.EditTransparent := False;
  FEditWindowProc := FEdit.WindowProc;
  FEdit.WindowProc := EditWindowProcHook;
  FEdit.OnEditCancelMode := EditCancelMode;
  FEdit.OnChange := EditChange;
  FEdit.OnKeyDown := EditKeyDown;
  FEdit.OnKeyPress := EditKeyPress;
  FEdit.OnKeyUp := EditKeyUp;
  //
  if FIndex <> -1
  then
    with FEdit.Font do
    begin
      Style := FontStyle;
      Color := FontColor;
      Height := FontHeight;
      Name := FontName;
    end
  else
    with FEdit.Font do
    begin
      Name := Self.Font.Name;
      Style := Self.Font.Style;
      Color := Self.Font.Color;
      Height := Self.Font.Height;
    end;
    if FIndex <> -1
    then FEdit.EditTransparent := True
    else FEdit.EditTransparent := False;
  //
  CalcRects;
end;

procedure TspSkinCustomComboBox.HideEditor;
begin
  FEdit.Visible := False;
  FEdit.Free;
  FEdit := nil;
end;

procedure TspSkinCustomComboBox.CMTextChanged;
begin
  inherited;
  if (FEdit <> nil) and not FromEdit then FEdit.Text := Text;
  if Assigned(FOnChange) then FOnChange(Self);
  if FromEdit then Change;
end;

procedure TspSkinCustomComboBox.WMSIZE;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinCustomComboBox.DrawDefaultItem;
var
  Buffer: TBitMap;
  R, R1: TRect;
  Index, IIndex, IX, IY: Integer;
begin
  if RectWidth(CBItem.R) <=0 then Exit;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(CBItem.R);
  Buffer.Height := RectHeight(CBItem.R);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    Font.Name := Self.Font.Name;
    Font.Style := Self.Font.Style;
    Font.Height := Self.Font.Height;
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.Charset :=TURKISH_CHARSET;// FDefaultFont.Charset;
      
    if Focused
    then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := clWindow;
        Font.Color := clWindowText;
      end;
    FillRect(R);
  end;

  if FListBox.Visible
  then Index := FOldItemIndex
  else Index := FListBox.ItemIndex;

  CBItem.State := [];

  if Focused then CBItem.State := [odFocused];

  R1 := Rect(R.Left + 2, R.Top, R.Right - 2, R.Bottom);
  if (Index > -1) and (Index < FListBox.Items.Count)
  then
    if Assigned(FOnComboBoxDrawItem)
    then
      FOnComboBoxDrawItem(Buffer.Canvas, Index, Buffer.Width, Buffer.Height,
                          R1, CBItem.State)
    else
      begin
        if Images <> nil
        then
          begin
            if ImageIndex > -1
            then IIndex := ImageIndex
            else IIndex := Index;
            if IIndex < Images.Count
            then
              begin
                IX := R1.Left;
                IY := R1.Top + RectHeight(R1) div 2 - Images.Height div 2;
                Images.Draw(Buffer.Canvas, IX, IY, IIndex);
              end;
            Inc(R1.Left, Images.Width + 2);
          end;
        SPDrawText2(Buffer.Canvas, FListBox.Items[Index], R1);
      end;
  if Focused then DrawFocusRect(Buffer.Canvas.Handle, R);
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;


procedure TspSkinCustomComboBox.DrawSkinItem;
var
  Buffer: TBitMap;
  R, R2: TRect;
  W, H: Integer;
  Index, IIndex, IX, IY: Integer;
begin
  W := RectWidth(CBItem.R);
  if W <= 0 then Exit;
  H := RectHeight(SItemRect);
  if H = 0 then H := RectHeight(FocusItemRect);
  if H = 0 then H := RectWidth(CBItem.R);
  Buffer := TBitMap.Create;
  if Focused
  then
    begin
      if not IsNullRect(FocusItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          FocusItemRect, W, H)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end
  else
    begin
      if not IsNullRect(SItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          SItemRect, W, H)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end;

  R := ItemTextRect;
  if not IsNullRect(SItemRect)
  then
    Inc(R.Right, W - RectWidth(SItemRect))
  else
    Inc(R.Right, W - RectWidth(ClRect));

  with Buffer.Canvas do
  begin
    if FUseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
      end
    else
      Font.Assign(FDefaultFont);

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet :=TURKISH_CHARSET;// FDefaultFont.CharSet;

    if Focused
    then
      Font.Color := FocusFontColor
    else
      Font.Color := FontColor;
    Brush.Style := bsClear;
  end;

  if FListBox.Visible
  then Index := FOldItemIndex
  else Index := FListBox.ItemIndex;

  if (Index > -1) and (Index < FListBox.Items.Count)
  then
    if Assigned(FOnComboBoxDrawItem)
    then
      FOnComboBoxDrawItem(Buffer.Canvas, Index, Buffer.Width, Buffer.Height,
                          R, CBItem.State)
    else
      begin
        if Images <> nil
        then
          begin
            if ImageIndex > -1
            then IIndex := ImageIndex
            else IIndex := Index;
            if IIndex < Images.Count
            then
              begin
                IX := R.Left;
                IY := R.Top + RectHeight(R) div 2 - Images.Height div 2;
                Images.Draw(Buffer.Canvas, IX, IY, IIndex);
              end;
            Inc(R.Left, Images.Width + 2);
          end;
        SPDrawText2(Buffer.Canvas, FListBox.Items[Index], R);
      end;
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomComboBox.DrawButton;
var
  ArrowColor: TColor;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Button do
    begin
      R1 := R;  
      if Down and MouseIn
      then
        begin
          Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          C.Brush.Color := SP_XP_BTNDOWNCOLOR;
          C.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            C.Brush.Color := SP_XP_BTNACTIVECOLOR;
            C.FillRect(R1);
          end
        else
          begin
            Frame3D(C, R1, clBtnShadow, clBtnShadow, 1);
            C.Brush.Color := clBtnFace;
            C.FillRect(R1);
          end;
      if Enabled
      then
        ArrowColor := clBlack
      else
        ArrowColor := clBtnShadow;
      DrawArrowImage(C, R, ArrowColor, 4);
    end
  else
    with Button do
    begin
      R1 := NullRect;
      if not Enabled and not IsNullRect(UnEnabledButtonRect)
      then
        R1 := UnEnabledButtonRect
      else
      if Down and MouseIn
      then R1 := DownButtonRect
      else if MouseIn then R1 := ActiveButtonRect;
      if not IsNullRect(R1)
      then
        C.CopyRect(R, Picture.Canvas, R1);
    end;
end;

procedure TspSkinCustomComboBox.CalcRects;
const
  BW = 17;
var
  OX: Integer;
begin
  if FIndex = -1
  then
    begin
      Button.R := Rect(Width - BW - 2, 2, Width - 2, Height - 2);
      CBItem.R := Rect(2, 2, Button.R.Left - 1 , Height -  2);
    end
  else
    begin
      OX := Width - RectWidth(SkinRect);
      Button.R := ButtonRect;
      if ButtonRect.Left >= RectWidth(SkinRect) - RTPt.X
      then
        OffsetRect(Button.R, OX, 0);
      CBItem.R := ClRect;
      Inc(CBItem.R.Right, OX);
    end;
  if FEdit <> nil
  then
    begin
      FEdit.Left := CBItem.R.Left;
      FEdit.Top := CBItem.R.Top;
      FEdit.Width := RectWidth(CBItem.R);
      FEdit.Height := RectHeight(CBItem.R);
    end;
end;

procedure TspSkinCustomComboBox.ChangeSkinData;
begin
  inherited;
  CalcRects;
  if FEdit <> nil
  then
    begin
      if FIndex <> -1
      then
        with FEdit.Font do
        begin
          Style := FontStyle;
          Color := FontColor;
          Height := FontHeight;
          Name := FontName;
        end
      else
        FEdit.Font.Assign(FDefaultFont);

      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        FEdit.Font.Charset := SkinData.ResourceStrData.CharSet
      else
        FEdit.Font.CharSet := TURKISH_CHARSET;// FDefaultFont.CharSet;

      if FIndex <> -1
      then FEdit.EditTransparent := True
      else FEdit.EditTransparent := False;
    end;

  RePaint;
    
  if FIndex = -1
  then
    begin
      FListBox.SkinDataName := '';
    end  
  else
    FListBox.SkinDataName := ListBoxName;
  FListBox.SkinData := SkinData;
  //
end;

procedure TspSkinCustomComboBox.CreateControlDefaultImage;
var
  R: TRect;
begin
  CalcRects;
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  DrawButton(B.Canvas);
  if FEdit = nil then  DrawDefaultItem(B.Canvas);
end;

procedure TspSkinCustomComboBox.CreateControlSkinImage;
begin
  CalcRects;
  inherited;
  DrawButton(B.Canvas);
  if FEdit = nil then DrawSkinItem(B.Canvas);
end;

// ==================== TspSkinFontComboBox ======================= //

const
  WRITABLE_FONTTYPE = 256;

function IsValidFont(Box: TspSkinFontComboBox; LogFont: TLogFont;
  FontType: Integer): Boolean;
begin
  Result := True;
  if (foAnsiOnly in Box.Options) then
    Result := Result and (LogFont.lfCharSet = ANSI_CHARSET);
  if (foTrueTypeOnly in Box.Options) then
    Result := Result and (FontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE);
  if (foFixedPitchOnly in Box.Options) then
    Result := Result and (LogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH);
  if (foOEMFontsOnly in Box.Options) then
    Result := Result and (LogFont.lfCharSet = OEM_CHARSET);
  if (foNoOEMFonts in Box.Options) then
    Result := Result and (LogFont.lfCharSet <> OEM_CHARSET);
  if (foNoSymbolFonts in Box.Options) then
    Result := Result and (LogFont.lfCharSet <> SYMBOL_CHARSET);
  if (foScalableOnly in Box.Options) then
    Result := Result and (FontType and RASTER_FONTTYPE = 0);
end;

function EnumFontsProc(var EnumLogFont: TEnumLogFont;
  var TextMetric: TNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var
  FaceName: string;
begin
  FaceName := StrPas(EnumLogFont.elfLogFont.lfFaceName);
  with TspSkinFontComboBox(Data) do
    if (Items.IndexOf(FaceName) < 0) and
      IsValidFont(TspSkinFontComboBox(Data), EnumLogFont.elfLogFont, FontType) then
    begin
      if EnumLogFont.elfLogFont.lfCharSet <> SYMBOL_CHARSET then
        FontType := FontType or WRITABLE_FONTTYPE;
      Items.AddObject(FaceName, TObject(FontType));
    end;
  Result := 1;
end;

constructor TspSkinFontComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnListBoxDrawItem := DrawLBFontItem;
  OnComboBoxDrawItem := DrawCBFontItem;
  FDevice := fdScreen;
  Sorted := True;
end;

procedure TspSkinFontComboBox.DrawTT;
begin
  with Cnvs do
  begin
    Pen.Color := C;
    MoveTo(X, Y);
    LineTo(X + 7, Y);
    LineTo(X + 7, Y + 3);
    MoveTo(X, Y);
    LineTo(X, Y + 3);
    MoveTo(X + 1, Y);
    LineTo(X + 1, Y + 1);
    MoveTo(X + 6, Y);
    LineTo(X + 6, Y + 1);
    MoveTo(X + 3, Y);
    LineTo(X + 3, Y + 8);
    MoveTo(X + 4, Y);
    LineTo(X + 4, Y + 8);
    MoveTo(X + 2, Y + 8);
    LineTo(X + 6, Y + 8);
  end;
end;

procedure TspSkinFontComboBox.Reset;
var
  SaveName: TFontName;
begin
  if HandleAllocated then begin
    FUpdate := True;
    try
      SaveName := FontName;
      PopulateList;
      FontName := SaveName;
    finally
      FUpdate := False;
      if FontName <> SaveName
      then
        begin
          if not (csReading in ComponentState) then
          if not FUpdate and Assigned(FOnChange) then FOnChange(Self);
        end;
    end;
  end;
end;

procedure TspSkinFontComboBox.WMFontChange(var Message: TMessage);
begin
  inherited;
  Reset;
end;

procedure TspSkinFontComboBox.SetFontName(const NewFontName: TFontName);
var
  Item: Integer;
begin
  if FontName <> NewFontName then begin
    if not (csLoading in ComponentState) then begin
      HandleNeeded;
      { change selected item }
      for Item := 0 to Items.Count - 1 do
        if AnsiCompareText(Items[Item], NewFontName) = 0 then begin
          ItemIndex := Item;
          //
          if not (csReading in ComponentState) then
            if not FUpdate and Assigned(FOnChange) then FOnChange(Self);
          //
          Exit;
        end;
      if Style = spcbFixedStyle then ItemIndex := -1
      else Text := NewFontName;
    end
    else inherited Text := NewFontName;
    //
    if not (csReading in ComponentState) then
    if not FUpdate and Assigned(FOnChange) then FOnChange(Self);
    //
  end;
end;

function TspSkinFontComboBox.GetFontName: TFontName;
begin
  Result := inherited Text;
end;

function TspSkinFontComboBox.GetTrueTypeOnly: Boolean;
begin
  Result := foTrueTypeOnly in FOptions;
end;

procedure TspSkinFontComboBox.SetOptions;
begin
  if Value <> Options then begin
    FOptions := Value;
    Reset;
  end;
end;

procedure TspSkinFontComboBox.SetTrueTypeOnly(Value: Boolean);
begin
  if Value <> TrueTypeOnly then begin
    if Value then FOptions := FOptions + [foTrueTypeOnly]
    else FOptions := FOptions - [foTrueTypeOnly];
    Reset;
  end;
end;

procedure TspSkinFontComboBox.SetDevice;
begin
  if Value <> FDevice then begin
    FDevice := Value;
    Reset;
  end;
end;

procedure TspSkinFontComboBox.SetUseFonts(Value: Boolean);
begin
  if Value <> FUseFonts then begin
    FUseFonts := Value;
    Invalidate;
  end;
end;

procedure TspSkinFontComboBox.DrawCBFontItem;
var
  FName: array[0..255] of Char;
  R: TRect;
begin
  R := TextRect;
  R.Left := R.Left + 2;
  with Cnvs do
  begin
    StrPCopy(FName, Items[Index]);
    SPDrawText(Cnvs, FName, R);
  end;
end;

procedure TspSkinFontComboBox.DrawLBFontItem;
var
  FName: array[0..255] of Char;
  R: TRect;
  X, Y: Integer;
begin
  R := TextRect;
  if (Integer(Items.Objects[Index]) and TRUETYPE_FONTTYPE) <> 0
  then
    begin
      X := TextRect.Left;
      Y := TextRect.Top + RectHeight(TextRect) div 2 - 7;
      DrawTT(Cnvs, X, Y, clGray);
      DrawTT(Cnvs, X + 4, Y + 4, clBlack);
    end;

  Inc(R.Left, 15);
  with Cnvs do
  begin
    Font.Name := Items[Index];
    Font.Style := [];
    StrPCopy(FName, Items[Index]);
    SPDrawText(Cnvs, Items[Index], R);
  end;
end;

procedure TspSkinFontComboBox.PopulateList;
var
  DC: HDC;
  Proc: TFarProc;
  FOldItemIndex: Integer;
begin
  if not HandleAllocated then Exit;
  FOldItemIndex := ItemIndex;
  Items.BeginUpdate;
  try
    Items.Clear;
    DC := GetDC(0);
    try
      if (FDevice = fdScreen) or (FDevice = fdBoth) then
        EnumFontFamilies(DC, nil, @EnumFontsProc, Longint(Self));
      if (FDevice = fdPrinter) or (FDevice = fdBoth) then
      try
        EnumFontFamilies(Printer.Handle, nil, @EnumFontsProc, Longint(Self));
      except
        { skip any errors }
      end;
    finally
      ReleaseDC(0, DC);
    end;
  finally
    Items.EndUpdate;
  end;
  ItemIndex := FOldItemIndex;
end;

procedure TspSkinFontComboBox.CreateWnd;
var
  OldFont: TFontName;
begin
  OldFont := FontName;
  inherited CreateWnd;
  FUpdate := True;
  try
    PopulateList;
    inherited Text := '';
    SetFontName(OldFont);
  finally
    FUpdate := False;
  end;
//  if AnsiCompareText(FontName, OldFont) <> 0 then DoChange;
end;

// ==================== TspSkinColorComboBox ======================= //
const
  SColorBoxCustomCaption = 'Custom...';
  NoColorSelected = TColor($FF000000);
  StandardColorsCount = 16;
  ExtendedColorsCount = 4;

constructor TspSkinColorComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := spcbFixedStyle;
  FExStyle := [spcbStandardColors, spcbExtendedColors, spcbSystemColors];
  FSelectedColor := clBlack;
  FDefaultColorColor := clBlack;
  FNoneColorColor := clBlack;
  OnListBoxDrawItem := DrawColorItem;
  OnComboBoxDrawItem := DrawColorItem;
  OnCloseUp := OnLBCloseUp;
  FShowNames := True;
end;

procedure TspSkinColorComboBox.SetShowNames(Value: Boolean);
begin
  FShowNames := Value;
  RePaint;
end;

procedure TspSkinColorComboBox.DrawColorItem;
var
  R: TRect;
  MarkerRect: TRect;
begin
  if FShowNames
  then
    MarkerRect := Rect(TextRect.Left + 1, TextRect.Top + 1,
      TextRect.Left + RectHeight(TextRect) - 1, TextRect.Bottom - 1)
  else
    MarkerRect := Rect(TextRect.Left + 1, TextRect.Top + 1,
      TextRect.Right - 1, TextRect.Bottom - 1);

  with Cnvs do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Colors[Index];
    FillRect(MarkerRect);
    Brush.Style := bsClear;
  end;

  if FShowNames
  then
    begin
      R := TextRect;
      R := Rect(R.Left + 5 + RectWidth(MarkerRect), R.Top, R.Right - 2, R.Bottom);
      SPDrawText(Cnvs, FListBox.Items[Index], R);
    end;
end;

procedure TspSkinColorComboBox.OnLBCloseUp;
begin
  if (spcbCustomColor in ExStyle) and (ItemIndex = 0) then
   PickCustomColor;
end;

function TspSkinColorComboBox.PickCustomColor: Boolean;
var
  LColor: TColor;
begin
  with TspSkinColorDialog.Create(nil) do
    try
      SkinData := Self.SkinData;
      CtrlSkinData := Self.SkinData;
      LColor := ColorToRGB(TColor(Items.Objects[0]));
      Color := LColor;
      Result := Execute;
      if Result then
      begin
        Items.Objects[0] := TObject(Color);
        Self.Invalidate;
        if Assigned(FOnClick) then FOnClick(Self);
        if Assigned(FOnChange) then FOnChange(Self);
      end;
    finally
      Free;
    end;
end;

procedure TspSkinColorComboBox.KeyDown;
begin
  if (spcbCustomColor in ExStyle) and (Key = VK_RETURN) and (ItemIndex = 0)
  then
  begin
    PickCustomColor;
    Key := 0;
  end;
  inherited;
end;

procedure TspSkinColorComboBox.CreateWnd;
begin
  inherited;
  PopulateList;
end;

procedure TspSkinColorComboBox.SetDefaultColorColor(const Value: TColor);
begin
  if Value <> FDefaultColorColor then
  begin
    FDefaultColorColor := Value;
    Invalidate;
  end;
end;

procedure TspSkinColorComboBox.SetNoneColorColor(const Value: TColor);
begin
  if Value <> FNoneColorColor then
  begin
    FNoneColorColor := Value;
    Invalidate;
  end;
end;

procedure TspSkinColorComboBox.ColorCallBack(const AName: String);
var
  I, LStart: Integer;
  LColor: TColor;
  LName: string;
begin
  LColor := StringToColor(AName);
  if spcbPrettyNames in ExStyle then
  begin
    if Copy(AName, 1, 2) = 'cl' then
      LStart := 3
    else
      LStart := 1;
    LName := '';
    for I := LStart to Length(AName) do
    begin
      case AName[I] of
        'A'..'Z':
          if LName <> '' then
            LName := LName + ' ';
      end;
      LName := LName + AName[I];
    end;
  end
  else
    LName := AName;
  Items.AddObject(LName, TObject(LColor));
end;

procedure TspSkinColorComboBox.SetSelected(const AColor: TColor);
var
  I: Integer;
begin
  if HandleAllocated and (FListBox <> nil) then
  begin
    I := FListBox.Items.IndexOfObject(TObject(AColor));
    if (I = -1) and (spcbCustomColor in ExStyle) and (AColor <> NoColorSelected) then
    begin
      Items.Objects[0] := TObject(AColor);
      I := 0;
    end;
    ItemIndex := I;
  end;
  FSelectedColor := AColor;
end;

procedure TspSkinColorComboBox.PopulateList;
  procedure DeleteRange(const AMin, AMax: Integer);
  var
    I: Integer;
  begin
    for I := AMax downto AMin do
      Items.Delete(I);
  end;
  procedure DeleteColor(const AColor: TColor);
  var
    I: Integer;
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if I <> -1 then
      Items.Delete(I);
  end;
var
  LSelectedColor, LCustomColor: TColor;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
      LCustomColor := clBlack;
      if (spcbCustomColor in ExStyle) and (Items.Count > 0) then
        LCustomColor := TColor(Items.Objects[0]);
      LSelectedColor := FSelectedColor;
      Items.Clear;
      GetColorValues(ColorCallBack);
      if not (spcbIncludeNone in ExStyle) then
        DeleteColor(clNone);
      if not (spcbIncludeDefault in ExStyle) then
        DeleteColor(clDefault);
      if not (spcbSystemColors in ExStyle) then
        DeleteRange(StandardColorsCount + ExtendedColorsCount, Items.Count - 1);
      if not (spcbExtendedColors in ExStyle) then
        DeleteRange(StandardColorsCount, StandardColorsCount + ExtendedColorsCount - 1);
      if not (spcbStandardColors in ExStyle) then
        DeleteRange(0, StandardColorsCount - 1);
      if spcbCustomColor in ExStyle then
        Items.InsertObject(0, SColorBoxCustomCaption, TObject(LCustomColor));
      Self.Selected := LSelectedColor;
    finally
      Items.EndUpdate;
      FNeedToPopulate := False;
    end;
  end
  else
    FNeedToPopulate := True;
end;

procedure TspSkinColorComboBox.SetExStyle(AStyle: TspColorBoxStyle);
begin
  FExStyle := AStyle;
  Enabled := ([spcbStandardColors, spcbExtendedColors, spcbSystemColors, spcbCustomColor] * FExStyle) <> [];
  PopulateList;
  if (Items.Count > 0) and (ItemIndex = -1) then ItemIndex := 0;
end;

function TspSkinColorComboBox.GetColor(Index: Integer): TColor;
begin
  Result := TColor(Items.Objects[Index]);
end;

function TspSkinColorComboBox.GetColorName(Index: Integer): string;
begin
  Result := Items[Index];
end;

function TspSkinColorComboBox.GetSelected: TColor;
begin
  if HandleAllocated then
    if ItemIndex <> -1 then
      Result := Colors[ItemIndex]
    else
      Result := NoColorSelected
  else
    Result := FSelectedColor;
end;

///////////////////check listbox//////////////////////////
type

TspCheckListBoxDataWrapper = class
private
  FData: LongInt;
  FState: TCheckBoxState;
  procedure SetChecked(Check: Boolean);
  function GetChecked: Boolean;
public
  class function GetDefaultState: TCheckBoxState;
  property Checked: Boolean read GetChecked write SetChecked;
  property State: TCheckBoxState read FState write FState;
end;

procedure TspCheckListBoxDataWrapper.SetChecked(Check: Boolean);
begin
  if Check then FState := cbChecked else FState := cbUnchecked;
end;

function TspCheckListBoxDataWrapper.GetChecked: Boolean;
begin
  Result := FState = cbChecked;
end;

class function TspCheckListBoxDataWrapper.GetDefaultState: TCheckBoxState;
begin
  Result := cbUnchecked;
end;

constructor TspCheckListBox.Create;
begin
  inherited;
  SkinListBox := nil;
  Ctl3D := False;
  BorderStyle := bsNone;
  ControlStyle := [csCaptureMouse, csOpaque, csDoubleClicks];
  {$IFDEF VER130}
  FAutoComplete := True;
  {$ENDIF}
end;

destructor TspCheckListBox.Destroy;
begin
  inherited;
end;

procedure TspCheckListBox.SkinDrawCheckImage(X, Y: Integer; Cnvs: TCanvas; IR: TRect; DestCnvs: TCanvas);
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Width := RectWidth(IR);
  B.Height := RectHeight(IR);
  B.Canvas.CopyRect(Rect(0, 0, B.Width, B.Height), Cnvs, IR);
  B.Transparent := True;
  DestCnvs.Draw(X, Y, B);
  B.Free;
end;

procedure TspCheckListBox.WMNCCALCSIZE;
begin
end;

procedure TspCheckListBox.CMEnter;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxEnter;
  inherited;
end;

procedure TspCheckListBox.CMExit;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxExit;
  inherited;
end;

procedure TspCheckListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxMouseUp(Button, Shift, X, Y);
  inherited;
end;

procedure TspCheckListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxMouseMove(Shift, X, Y);
  inherited;
end;

procedure TspCheckListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if SkinListBox <> nil then SkinListBox.ListBoxKeyDown(Key, Shift);
  inherited;
end;

procedure TspCheckListBox.Click;
begin
  if SkinListBox <> nil then SkinListBox.ListBoxClick;
  inherited;
end;
procedure TspCheckListBox.PaintBGWH;
var
  X, Y, XCnt, YCnt, XO, YO, w, h, w1, h1: Integer;
  Buffer: TBitMap;
begin
  w1 := AW;
  h1 := AH;
  Buffer := TBitMap.Create;
  Buffer.Width := w1;
  Buffer.Height := h1;
  with Buffer.Canvas, SkinListBox do
  begin
    w := RectWidth(ClRect);
    h := RectHeight(ClRect);
    XCnt := w1 div w;
    YCnt := h1 div h;
    for X := 0 to XCnt do
    for Y := 0 to YCnt do
    begin
      if X * w + w > w1 then XO := X * w + w - w1 else XO := 0;
      if Y * h + h > h1 then YO := Y * h + h - h1 else YO := 0;
       CopyRect(Rect(X * w, Y * h, X * w + w - XO, Y * h + h - YO),
                Picture.Canvas,
                Rect(SkinRect.Left + ClRect.Left, SkinRect.Top + ClRect.Top,
                SkinRect.Left + ClRect.Right - XO,
                SkinRect.Top + ClRect.Bottom - YO));
    end;
  end;
  Cnvs.Draw(AX, AY, Buffer);
  Buffer.Free;
end;

function TspCheckListBox.GetItemData(Index: Integer): LongInt;
begin
  Result := 0;
  if HaveWrapper(Index) then
    Result := TspCheckListBoxDataWrapper(GetWrapper(Index)).FData;
end;

procedure TspCheckListBox.SetItemData(Index: Integer; AData: LongInt);
var
  Wrapper: TspCheckListBoxDataWrapper;
begin
  Wrapper := TspCheckListBoxDataWrapper(GetWrapper(Index));
  Wrapper.FData := AData;
  if FSaveStates <> nil then
    if FSaveStates.Count > 0 then
    begin
     Wrapper.FState := TCheckBoxState(FSaveStates[0]);
     FSaveStates.Delete(0);
    end;
end;


procedure TspCheckListBox.ResetContent;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    if HaveWrapper(I) then
      GetWrapper(I).Free;
  inherited;
end;

procedure TspCheckListBox.CreateWnd;
begin
  inherited CreateWnd;
  if FSaveStates <> nil then
  begin
    FSaveStates.Free;
    FSaveStates := nil;
  end;
end;

procedure TspCheckListBox.DestroyWnd;
var
  I: Integer;
begin
  if Items.Count > 0 then
  begin
    FSaveStates := TList.Create;
    for I := 0 to Items.Count -1 do
      FSaveStates.Add(TObject(State[I]));
  end;
  inherited DestroyWnd;
end;

procedure TspCheckListBox.WMDestroy(var Msg: TWMDestroy);
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
    ExtractWrapper(i).Free;
  inherited;
end;

procedure TspCheckListBox.DeleteString(Index: Integer);
begin
  if HaveWrapper(Index) then
    GetWrapper(Index).Free;
  inherited;
end;

procedure TspCheckListBox.KeyPress(var Key: Char);
{$IFDEF VER130}
  procedure FindString;
  var
    Idx: Integer;
  begin
    if Length(FFilter) = 1
    then
      Idx := SendMessage(Handle, LB_FINDSTRING, ItemIndex, LongInt(PChar(FFilter)))
    else
      Idx := SendMessage(Handle, LB_FINDSTRING, -1, LongInt(PChar(FFilter)));
    if Idx <> LB_ERR then
    begin
      if MultiSelect then
      begin
        SendMessage(Handle, LB_SELITEMRANGE, 1, MakeLParam(Idx, Idx))
      end;
      ItemIndex := Idx;
      Click;
    end;
    if not Ord(Key) in [VK_RETURN, VK_BACK, VK_ESCAPE] then
      Key := #0;
  end;
  {$ENDIF}
begin
  inherited;
  if (Key = ' ') then ToggleClickCheck(ItemIndex);
  if SkinListBox <> nil then SkinListBox.ListBoxKeyPress(Key);
  {$IFDEF VER130}
  if not FAutoComplete then Exit;
  if GetTickCount - FLastTime >= 500 then
    FFilter := '';
  FLastTime := GetTickCount;
  if Ord(Key) <> VK_BACK
  then
    begin
      FFilter := FFilter + Key;
      Key := #0;
    end
  else
    Delete(FFilter, Length(FFilter), 1);
  if Length(FFilter) > 0 then
    FindString
  else
  begin
    ItemIndex := 0;
    Click;
  end;
  {$ENDIF}
end;

procedure TspCheckListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);

function InCheckArea(IR: TRect): Boolean;
var
  R, R1: TRect;
  OX: Integer;
begin
  R := SkinListBox.ItemTextRect;
  OX :=  RectWidth(IR) - RectWidth(SkinListBox.SItemRect);
  Inc(R.Right, OX);
  R1 := SkinListBox.ItemCheckRect;
  if R1.Left >= SkinListBox.ItemTextRect.Right
  then OffsetRect(R1, OX, 0);
  OffsetRect(R1, IR.Left, IR.Top);
  Result := PtInRect(R1, Point(X, Y));
end;

var
  Index: Integer;
begin
  inherited;
  Index := ItemAtPos(Point(X,Y),True);
  if (Index <> -1)
  then 
    if (SkinListBox <> nil) and (SkinListBox.FIndex <> -1)
    then
      begin
        if InCheckArea(ItemRect(Index)) then ToggleClickCheck(Index);
      end
    else
      begin
        if X - ItemRect(Index).Left < 20 then ToggleClickCheck(Index);
      end;
  if SkinListBox <> nil then SkinListBox.ListBoxMouseDown(Button, Shift, X, Y);    
end;

procedure TspCheckListBox.ToggleClickCheck;
var
  State: TCheckBoxState;
begin
  if (Index >= 0) and (Index < Items.Count) then
  begin
    State := Self.State[Index];
    case State of
      cbUnchecked: State := cbChecked;
      cbChecked: State := cbUnchecked;
    end;
    Self.State[Index] := State;
    if Assigned(FOnClickCheck) then FOnClickCheck(Self);
  end;
end;

procedure TspCheckListBox.InvalidateCheck(Index: Integer);
var
  R: TRect;
begin
  R := ItemRect(Index);
  InvalidateRect(Handle, @R, not (csOpaque in ControlStyle));
  UpdateWindow(Handle);
end;

function TspCheckListBox.GetWrapper(Index: Integer): TObject;
begin
  Result := ExtractWrapper(Index);
  if Result = nil then
    Result := CreateWrapper(Index);
end;

function TspCheckListBox.ExtractWrapper(Index: Integer): TObject;
begin
  Result := TspCheckListBoxDataWrapper(inherited GetItemData(Index));
  if LB_ERR = Integer(Result) then
    raise EListError.CreateFmt('List index out of bounds (%d)', [Index]);
  if (Result <> nil) and (not (Result is TspCheckListBoxDataWrapper)) then
    Result := nil;
end;

function TspCheckListBox.CreateWrapper(Index: Integer): TObject;
begin
  Result := TspCheckListBoxDataWrapper.Create;
  inherited SetItemData(Index, LongInt(Result));
end;

function TspCheckListBox.HaveWrapper(Index: Integer): Boolean;
begin
  Result := ExtractWrapper(Index) <> nil;
end;

procedure TspCheckListBox.SetChecked(Index: Integer; Checked: Boolean);
begin
  if Checked <> GetChecked(Index) then
  begin
    TspCheckListBoxDataWrapper(GetWrapper(Index)).SetChecked(Checked);
    InvalidateCheck(Index);
  end;
end;

procedure TspCheckListBox.SetState(Index: Integer; AState: TCheckBoxState);
begin
  if AState <> GetState(Index) then
  begin
    TspCheckListBoxDataWrapper(GetWrapper(Index)).State := AState;
    InvalidateCheck(Index);
  end;
end;

function TspCheckListBox.GetChecked(Index: Integer): Boolean;
begin
  if HaveWrapper(Index) then
    Result := TspCheckListBoxDataWrapper(GetWrapper(Index)).GetChecked
  else
    Result := False;
end;

function TspCheckListBox.GetState(Index: Integer): TCheckBoxState;
begin
  if HaveWrapper(Index) then
    Result := TspCheckListBoxDataWrapper(GetWrapper(Index)).State
  else
    Result := TspCheckListBoxDataWrapper.GetDefaultState;
end;

function TspCheckListBox.GetState1;
begin
  Result := [];
  if AItemID = ItemIndex
  then
    begin
      Result := Result + [odSelected];
      if Focused then Result := Result + [odFocused];
    end
  else
    if SelCount > 0
    then
      if Selected[AItemID] then Result := Result + [odSelected];
end;

procedure TspCheckListBox.PaintBG(DC: HDC);
var
  C: TControlCanvas;
begin
  C := TControlCanvas.Create;
  C.Handle := DC;
  SkinListBox.GetSkinData;
  if SkinListBox.FIndex <> -1
  then
    PaintBGWH(C, Width, Height, 0, 0)
  else
    with C do
    begin
      C.Brush.Color := clWindow;
      FillRect(Rect(0, 0, Width, Height));
    end;
  C.Handle := 0;
  C.Free;
end;

procedure TspCheckListBox.PaintColumnsList(DC: HDC);
var
  C: TCanvas;
  i, j, DrawCount: Integer;
  IR: TRect;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  DrawCount := (Height div ItemHeight) * Columns;
  i := TopIndex;
  j := i + DrawCount;
  if j > Items.Count - 1 then j := Items.Count - 1;
  if Items.Count > 0
  then
    for i := TopIndex to j do
    begin
      IR := ItemRect(i);
      if SkinListBox.FIndex <> -1
      then
        begin
          if SkinListBox.UseSkinItemHeight
          then
            DrawSkinItem(C, i, IR, GetState1(i))
          else
            DrawStretchSkinItem(C, i, IR, GetState1(i));
        end
      else
        DrawDefaultItem(C, i, IR, GetState1(i));
    end;
  C.Free;
end;

procedure TspCheckListBox.PaintList(DC: HDC);
var
  C: TCanvas;
  i, j, k, DrawCount: Integer;
  IR: TRect;
begin
  C := TCanvas.Create;
  C.Handle := DC;
  DrawCount := Height div ItemHeight;
  i := TopIndex;
  j := i + DrawCount;
  if j > Items.Count - 1 then j := Items.Count - 1;
  k := 0;
  if Items.Count > 0
  then
    for i := TopIndex to j do
    begin
      IR := ItemRect(i);
      if SkinListBox.FIndex <> -1
      then
        begin
          if SkinListBox.UseSkinItemHeight
          then
            DrawSkinItem(C, i, IR, GetState1(i))
          else
            DrawStretchSkinItem(C, i, IR, GetState1(i));
        end
      else
        DrawDefaultItem(C, i, IR, GetState1(i));
      k := IR.Bottom;
    end;
  if k < Height
  then
    begin
      SkinListBox.GetSkinData;
      if SkinListBox.FIndex <> -1
      then
        PaintBGWH(C, Width, Height - k, 0, k)
      else
        with C do
        begin
          C.Brush.Color := clWindow;
          FillRect(Rect(0, k, Width, Height));
        end;
    end;
  C.Free;
end;

procedure TspCheckListBox.PaintWindow;
var
  SaveIndex: Integer;
begin
  if (Width <= 0) or (Height <=0) then Exit;
  SaveIndex := SaveDC(DC);
  try
    if Columns > 0
    then
      PaintColumnsList(DC)
    else
      PaintList(DC);
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TspCheckListBox.WMPaint;
begin
  PaintHandler(Msg);
end;

procedure TspCheckListBox.WMEraseBkgnd;
begin
  PaintBG(Message.DC);
  Message.Result := 1;
end;

procedure TspCheckListBox.DrawDefaultItem;
var
  Buffer: TBitMap;
  R, R1, CR: TRect;
  AState: TCheckBoxState;
  IIndex, IX, IY: Integer;
begin
  if (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  AState := GetState(itemID);
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(rcItem);
  Buffer.Height := RectHeight(rcItem);
  R := Rect(20, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    Font.Name := SkinListBox.Font.Name;
    Font.Style := SkinListBox.Font.Style;
    Font.Height := SkinListBox.Font.Height;
    if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
    else
      Font.Charset :=TURKISH_CHARSET;// SkinListBox.DefaultFont.Charset;
      
    if odSelected in State1
    then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := clWindow;
        Font.Color := SkinListBox.Font.Color;
      end;
    FillRect(R);
  end;

  R1 := Rect(R.Left + 2, R.Top, R.Right - 2, R.Bottom);

  CR := Rect(3, Buffer.Height div 2 - 6, 16, Buffer.Height div 2 + 7);
  Frame3D(Buffer.Canvas, CR, clBtnShadow, clBtnShadow, 1);
  
  if AState = cbChecked
  then
    DrawCheckImage(Buffer.Canvas, 6, Buffer.Height div 2 - 4, clWindowText);

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer.Canvas, ItemID, Buffer.Width, Buffer.Height,
    R1, State1)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R1.Left;
              IY := R1.Top + RectHeight(R1) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer.Canvas, IX, IY, IIndex);
            end;
          Inc(R1.Left, SkinListBox.Images.Width + 2);
        end;
      SPDrawText(Buffer.Canvas, Items[ItemID], R1);
    end;
  if odFocused in State1 then DrawFocusRect(Buffer.Canvas.Handle, R);
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer);
  Buffer.Free;
end;

procedure TspCheckListBox.DrawStretchSkinItem;
var
  Buffer, Buffer2: TBitMap;
  R, R1: TRect;
  W, H: Integer;
  OX, OY: Integer;
  AState: TCheckBoxState;
  cw, ch, cx, cy: Integer;
  IIndex, IX, IY: Integer;
begin
  if (SkinListBox.Picture = nil) or (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  AState := GetState(itemID);
  Buffer := TBitMap.Create;
  with SkinListBox do
  begin
    W := RectWidth(rcItem);
    H := RectHeight(SItemRect);
    Buffer.Width := W;
    Buffer.Height := H;
    if odFocused in State1
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      FocusItemRect, W, H)
    else
    if odSelected in State1
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      ActiveItemRect, W, H)
    else
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      SItemRect, W, H);
    R := ItemTextRect;
    OX :=  W - RectWidth(SItemRect);
    OY := RectHeight(rcItem) - RectHeight(SItemRect);
    Inc(R.Right, OX);
    Inc(R.Bottom, OY);
    R1 := ItemCheckRect;
    if R1.Left >= ItemTextRect.Right then OffsetRect(R1, OX, 0);
    Inc(R1.Bottom, OY);

    cw := RectWidth(CheckImageRect);
    ch := RectHeight(CheckImageRect);
    cx := R1.Left + RectWidth(R1) div 2;
    cy := R1.Top + RectHeight(R1) div 2;
    R1 := Rect(cx - cw div 2, cy - ch div 2,
               cx - cw div 2 + cw, cy - ch div 2 + ch);
  end;

  W := RectWidth(rcItem);
  H := RectHeight(rcItem);
  Buffer2 := TBitMap.Create;
  Buffer2.Width := W;
  Buffer2.Height := H;
  Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
  Buffer.Free;

  //
  if AState = cbChecked
  then
    SkinDrawCheckImage(R1.Left, R1.Top, SkinListBox.Picture.Canvas, SkinListBox.CheckImageRect, Buffer2.Canvas)
  else
    SkinDrawCheckImage(R1.Left, R1.Top, SkinListBox.Picture.Canvas, SkinListBox.UnCheckImageRect, Buffer2.Canvas);
  //

  with Buffer2.Canvas do
  begin
    if SkinListBox.UseSkinFont
    then
      begin
        Font.Name := SkinListBox.FontName;
        Font.Style := SkinListBox.FontStyle;
        Font.Height := SkinListBox.FontHeight;
        if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
        then
          Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
        else
          Font.CharSet := TURKISH_CHARSET;// SkinListBox.DefaultFont.CharSet;
      end
    else
      Font.Assign(SkinListBox.DefaultFont);
    if odFocused in State1
    then
      Font.Color := SkinListBox.FocusFontColor
    else
    if odSelected in State1
    then
      Font.Color := SkinListBox.ActiveFontColor
    else
      Font.Color := SkinListBox.FontColor;
    Brush.Style := bsClear;
  end;

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer2.Canvas, ItemID, Buffer2.Width, Buffer2.Height,
    R, State1)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R.Left;
              IY := R.Top + RectHeight(R) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer2.Canvas, IX, IY, IIndex);
            end;
          Inc(R.Left, SkinListBox.Images.Width + 2);
        end;
      SPDrawText2(Buffer2.Canvas, Items[ItemID], R);
    end;
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer2);
  Buffer2.Free;
end;

procedure TspCheckListBox.DrawSkinItem;
var
  Buffer: TBitMap;
  R, R1: TRect;
  W, H: Integer;
  OX: Integer;
  AState: TCheckBoxState;
  cw, ch, cx, cy: Integer;
  IIndex, IX, IY: Integer;
begin
  if (SkinListBox.Picture = nil) or (ItemID < 0) or (ItemID > Items.Count - 1) then Exit;
  AState := GetState(itemID);
  Buffer := TBitMap.Create;
  with SkinListBox do
  begin
    W := RectWidth(rcItem);
    H := RectHeight(SItemRect);
    Buffer.Width := W;
    Buffer.Height := H;
    if odFocused in State1
    then
      begin
        if not (odSelected in State1)
        then
          begin
            CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
              SItemRect, W, H);
            R := Rect(0, 0, Buffer.Width, Buffer.Height);
            DrawFocusRect(Buffer.Canvas.Handle, R);
          end
        else
          CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
            FocusItemRect, W, H)
      end
    else
    if odSelected in State1
    then
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      ActiveItemRect, W, H)
    else
      CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
      SItemRect, W, H);
    R := ItemTextRect;
    OX :=  W - RectWidth(SItemRect);
    Inc(R.Right, OX);
    R1 := ItemCheckRect;

    if R1.Left >= ItemTextRect.Right then OffsetRect(R1, OX, 0);
    cw := RectWidth(CheckImageRect);
    ch := RectHeight(CheckImageRect);
    cx := R1.Left + RectWidth(R1) div 2;
    cy := R1.Top + RectHeight(R1) div 2;
    R1 := Rect(cx - cw div 2, cy - ch div 2,
               cx - cw div 2 + cw, cy - ch div 2 + ch);

    if AState = cbChecked
    then
      SkinDrawCheckImage(R1.Left, R1.Top, Picture.Canvas, CheckImageRect, Buffer.Canvas)
    else
      SkinDrawCheckImage(R1.Left, R1.Top, Picture.Canvas, UnCheckImageRect, Buffer.Canvas);
  end;
  with Buffer.Canvas do
  begin
    if SkinListBox.UseSkinFont
    then
      begin
        Font.Name := SkinListBox.FontName;
        Font.Style := SkinListBox.FontStyle;
        Font.Height := SkinListBox.FontHeight;
      end
    else
      Font.Assign(SkinListBox.DefaultFont);

    if (SkinListBox.SkinData <> nil) and (SkinListBox.SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinListBox.SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := TURKISH_CHARSET;// SkinListBox.DefaultFont.CharSet;

    if odFocused in State1
    then
      begin
        if not (odSelected in State1)
        then
          Font.Color := SkinListBox.FontColor
        else
          Font.Color := SkinListBox.FocusFontColor;
      end
    else
    if odSelected in State1
    then
      Font.Color := SkinListBox.ActiveFontColor
    else
      Font.Color := SkinListBox.FontColor;
    Brush.Style := bsClear;
  end;

  if Assigned(SkinListBox.FOnDrawItem)
  then
    SkinListBox.FOnDrawItem(Buffer.Canvas, ItemID, Buffer.Width, Buffer.Height,
    R, State1)
  else
    begin
      if (SkinListBox.Images <> nil)
      then
        begin
          if SkinListBox.ImageIndex > -1
          then IIndex := SkinListBox.FImageIndex
          else IIndex := itemID;
          if IIndex < SkinListBox.Images.Count
          then
            begin
              IX := R.Left;
              IY := R.Top + RectHeight(R) div 2 - SkinListBox.Images.Height div 2;
              SkinListBox.Images.Draw(Buffer.Canvas, IX, IY, IIndex);
            end;
          Inc(R.Left, SkinListBox.Images.Width + 2);
        end;
      SPDrawText(Buffer.Canvas, Items[ItemID], R);
    end;
  Cnvs.Draw(rcItem.Left, rcItem.Top, Buffer);
  Buffer.Free;
end;

procedure TspCheckListBox.CreateParams;
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    WindowClass.style := CS_DBLCLKS;
    Style := Style or WS_TABSTOP;
  end;
end;

procedure TspCheckListBox.CNDrawItem;
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    {$IFDEF VER120}
      State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
    {$ELSE}
      {$IFDEF VER125}
        State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
      {$ELSE}
        State := TOwnerDrawState(LongRec(itemState).Lo);
      {$ENDIF}
    {$ENDIF}
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if SkinListBox.FIndex <> -1
    then
      begin
        if SkinListBox.UseSkinItemHeight
        then
          DrawSkinItem(Canvas, itemID, rcItem, State)
        else
          DrawStretchSkinItem(Canvas, itemID, rcItem, State);
      end
    else
      DrawDefaultItem(Canvas, itemID, rcItem, State);
    Canvas.Handle := 0;
  end;
end;

procedure TspCheckListBox.WndProc;
var
  LParam, WParam: Integer;
begin
  inherited;
  case Message.Msg of
    WM_LBUTTONDBLCLK:
      begin
        if SkinListBox <> nil then SkinListBox.ListBoxDblClick;
      end;
    WM_MOUSEWHEEL:
      if (SkinListBox <> nil) and (SkinListBox.ScrollBar <> nil)
      then
      begin
        LParam := 0;
        if Message.WParam > 0
        then
          WParam := MakeWParam(SB_LINEUP, 0)
        else
          WParam := MakeWParam(SB_LINEDOWN, 0);
        SendMessage(Handle, WM_VSCROLL, WParam, LParam);
        SkinListBox.UpDateScrollBar;
      end;
    WM_ERASEBKGND:
      SkinListBox.UpDateScrollBar;
    LB_ADDSTRING, LB_INSERTSTRING,
    LB_DELETESTRING:
      begin
        if SkinListBox <> nil
        then
          SkinListBox.UpDateScrollBar;
      end;
  end;
end;

constructor TspSkinCheckListBox.Create;
begin
  inherited;
  ControlStyle := [csCaptureMouse, csClickEvents,
    csOpaque, csDoubleClicks, csReplicatable, csAcceptsControls];
  FUseSkinItemHeight := True;
  FRowCount := 0;
  FGlyph := TBitMap.Create;
  FNumGlyphs := 1;
  FSpacing := 2;
  FImageIndex := -1;
  FDefaultCaptionFont := TFont.Create;
  FDefaultCaptionFont.OnChange := OnDefaultCaptionFontChange;
  FDefaultCaptionFont.Name := 'Arial';
  FDefaultCaptionFont.Height := 14;
  FDefaultCaptionHeight := 20;
  ActiveButton := -1;
  OldActiveButton := -1;
  CaptureButton := -1;
  FCaptionMode := False;
  FDefaultItemHeight := 20;
  TimerMode := 0;
  WaitMode := False;
  Font.Name := 'Arial';
  Font.Height := 14;
  Font.Color := clWindowText;
  Font.Style := [];
  ScrollBar := nil;
  ListBox := TspCheckListBox.Create(Self);
  ListBox.SkinListBox := Self;
  ListBox.Style := lbOwnerDrawFixed;
  ListBox.ItemHeight := FDefaultItemHeight;
  ListBox.Parent := Self;
  ListBox.Visible := True;
  Height := 120;
  Width := 120;
  FSkinDataName := 'checklistbox';
end;

function TspSkinCheckListBox.GetAutoComplete: Boolean;
begin
  Result := ListBox.AutoComplete;
end;

procedure TspSkinCheckListBox.SetAutoComplete(Value: Boolean);
begin
  ListBox.AutoComplete := Value;
end;

function TspSkinCheckListBox.GetOnListBoxEndDrag: TEndDragEvent;
begin
  Result := ListBox.OnEndDrag;
end;

procedure TspSkinCheckListBox.SetOnListBoxEndDrag(Value: TEndDragEvent);
begin
  ListBox.OnEndDrag := Value;
end;

function TspSkinCheckListBox.GetOnListBoxStartDrag: TStartDragEvent;
begin
  Result := ListBox.OnStartDrag;
end;

procedure TspSkinCheckListBox.SetOnListBoxStartDrag(Value: TStartDragEvent);
begin
  ListBox.OnStartDrag := Value;
end;

function TspSkinCheckListBox.GetOnListBoxDragOver: TDragOverEvent;
begin
  Result := ListBox.OnDragOver;
end;

procedure TspSkinCheckListBox.SetOnListBoxDragOver(Value: TDragOverEvent);
begin
  ListBox.OnDragOver := Value;
end;

function TspSkinCheckListBox.GetOnListBoxDragDrop: TDragDropEvent;
begin
  Result := ListBox.OnDragDrop;
end;

procedure TspSkinCheckListBox.SetOnListBoxDragDrop(Value: TDragDropEvent);
begin
  ListBox.OnDragDrop := Value;
end;

function TspSkinCheckListBox.GetColumns;
begin
  Result := ListBox.Columns;
end;

function TspSkinCheckListBox.GetListBoxDragMode: TDragMode;
begin
  Result := ListBox.DragMode;
end;

procedure TspSkinCheckListBox.SetListBoxDragMode(Value: TDragMode);
begin
  ListBox.DragMode := Value;
end;

function TspSkinCheckListBox.GetListBoxDragKind: TDragKind;
begin
  Result := ListBox.DragKind;
end;

procedure TspSkinCheckListBox.SetListBoxDragKind(Value: TDragKind);
begin
  ListBox.DragKind := Value;
end;

function TspSkinCheckListBox.GetListBoxDragCursor: TCursor;
begin
  Result := ListBox.DragCursor;
end;

procedure TspSkinCheckListBox.SetListBoxDragCursor(Value: TCursor);
begin
  ListBox.DragCursor := Value;
end;

procedure TspSkinCheckListBox.SetColumns;
begin
  ListBox.Columns := Value;
  UpDateScrollBar;
end;

procedure TspSkinCheckListBox.SetRowCount;
begin
  FRowCount := Value;
  if FRowCount <> 0
  then
    Height := Self.CalcHeight(FRowCount);
end;

procedure TspSkinCheckListBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
  ListBox.RePaint;
end;

procedure TspSkinCheckListBox.SetImageIndex(Value: Integer);
begin
  FImageIndex := Value;
  ListBox.RePaint;
end;

procedure TspSkinCheckListBox.SetNumGlyphs;
begin
  FNumGlyphs := Value;
  RePaint;
end;

procedure TspSkinCheckListBox.SetGlyph;
begin
  FGlyph.Assign(Value);
  RePaint;
end;

procedure TspSkinCheckListBox.SetSpacing;
begin
  FSpacing := Value;
  RePaint;
end;


procedure TspSkinCheckListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

procedure TspSkinCheckListBox.OnDefaultCaptionFontChange;
begin
  if (FIndex = -1) and FCaptionMode then RePaint;
end;

procedure TspSkinCheckListBox.SetDefaultCaptionHeight;
begin
  FDefaultCaptionHeight := Value;
  if (FIndex = -1) and FCaptionMode
  then
    begin
      CalcRects;
      RePaint;
    end;
end;

procedure TspSkinCheckListBox.SetDefaultCaptionFont;
begin
  FDefaultCaptionFont.Assign(Value);
end;

procedure TspSkinCheckListBox.StartTimer;
begin
  KillTimer(Handle, 1);
  SetTimer(Handle, 1, 100, nil);
end;

procedure TspSkinCheckListBox.SetDefaultItemHeight;
begin
  FDefaultItemHeight := Value;
  if FIndex = -1
  then
    ListBox.ItemHeight := FDefaultItemHeight;
end;

procedure TspSkinCheckListBox.StopTimer;
begin
  KillTimer(Handle, 1);
  TimerMode := 0;
end;

procedure TspSkinCheckListBox.WMTimer;
begin
  inherited;
  if WaitMode
  then
    begin
      WaitMode := False;
      StartTimer;
      Exit;
    end;
  case TimerMode of
    1: if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
    2: ItemIndex := ItemIndex + 1;
  end;
end;

procedure TspSkinCheckListBox.CreateControlSkinImage;
var
  GX, GY, GlyphNum, TX, TY, i, OffX, OffY: Integer;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

function CalcBRect(BR: TRect): TRect;
var
  R: TRect;
begin
  R := BR;
  if BR.Top <= LTPt.Y
  then
    begin
      if BR.Left > RTPt.X then OffsetRect(R, OffX, 0);
    end
  else
    begin
      OffsetRect(R, 0, OffY);
      if BR.Left > RBPt.X then OffsetRect(R, OffX, 0);
    end;
  Result := R;
end;

begin
  inherited;
  // calc rects
  OffX := Width - RectWidth(SkinRect);
  OffY := Height - RectHeight(SkinRect);
  NewClRect := ClRect;
  Inc(NewClRect.Right, OffX);
  Inc(NewClRect.Bottom, OffY);
  if FCaptionMode
  then
    begin
      NewCaptionRect := CaptionRect;
      if CaptionRect.Right >= RTPt.X
      then
        Inc(NewCaptionRect.Right, OffX);
      Buttons[0].R := CalcBRect(UpButtonRect);
      Buttons[1].R := CalcBRect(DownButtonRect);
      Buttons[2].R := CalcBRect(CheckButtonRect);
    end;  
  // paint caption
  if not IsNullRect(CaptionRect)
  then
    with B.Canvas do
    begin
      Font.Name := CaptionFontName;
      Font.Height := CaptionFontHeight;
      Font.Color := CaptionFontColor;
      Font.Style := CaptionFontStyle;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        Font.Charset := SkinData.ResourceStrData.CharSet
      else
        Font.CharSet := TURKISH_CHARSET;// DefaultCaptionFont.CharSet;
      TY := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2 -
            TextHeight(Caption) div 2;
      TX := NewCaptionRect.Left + 2;
      case Alignment of
        taCenter: TX := TX + RectWidth(NewCaptionRect) div 2 - GetGlyphTextWidth div 2;
        taRightJustify: TX := NewCaptionRect.Right - GetGlyphTextWidth - 2;
      end;
      Brush.Style := bsClear;

      if not FGlyph.Empty
      then
      begin
        GY := NewCaptionRect.Top + RectHeight(NewCaptionRect) div 2 - FGlyph.Height div 2;
        GX := TX;
        TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
        GlyphNum := 1;
        if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
       end;
      TextRect(NewCaptionRect, TX, TY, Caption);
      if not FGlyph.Empty
      then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
    end;
  // paint buttons
  for i := 0 to 2 do DrawButton(B.Canvas, i);
end;

procedure TspSkinCheckListBox.CreateControlDefaultImage;

function GetGlyphTextWidth: Integer;
begin
  Result := B.Canvas.TextWidth(Caption);
  if not FGlyph.Empty then Result := Result + FGlyph.Width div FNumGlyphs + FSpacing;
end;

var
  BW, i, TX, TY: Integer;
  R: TRect;
  GX, GY: Integer;
  GlyphNum: Integer;
begin
  inherited;
  if FCaptionMode
  then
    begin
      BW := 17;
      if BW > FDefaultCaptionHeight - 3 then BW := FDefaultCaptionHeight - 3;
      Buttons[0].R := Rect(Width - BW - 2, 2, Width - 2, 1 + BW);
      Buttons[1].R := Rect(Buttons[0].R.Left - BW, 2, Buttons[0].R.Left, 1 + BW);
      Buttons[2].R := Rect(Buttons[1].R.Left - BW, 2, Buttons[1].R.Left, 1 + BW);
    end;  
  R := ClientRect;
  Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
  if FCaptionMode
  then
    with B.Canvas do
    begin
      R := Rect(3, 2, Width - BW * 3 - 3, FDefaultCaptionHeight - 2);
      Font.Assign(FDefaultCaptionFont);
      case Alignment of
        taLeftJustify: TX := R.Left;
        taCenter: TX := R.Left + RectWidth(R) div 2 - GetGlyphTextWidth div 2;
        taRightJustify: TX := R.Right - GetGlyphTextWidth;
      end;

      TY := (FDefaultCaptionHeight - 2) div 2 - TextHeight(Caption) div 2;

      if not FGlyph.Empty
      then
        begin
          GY := R.Top + RectHeight(R) div 2 - FGlyph.Height div 2 - 1;
          GX := TX;
          if FNumGlyphs = 0 then FNumGlyphs := 1; 
          TX := GX + FGlyph.Width div FNumGlyphs + FSpacing;
          GlyphNum := 1;
          if not Enabled and (NumGlyphs = 2) then GlyphNum := 2;
        end;
      TextRect(R, TX, TY, Caption);
      if not FGlyph.Empty
      then DrawGlyph(B.Canvas, GX, GY, FGlyph, NumGlyphs, GlyphNum);
      Pen.Color := clBtnShadow;
      MoveTo(1, FDefaultCaptionHeight - 1); LineTo(Width - 1, FDefaultCaptionHeight - 1);
      for i := 0 to 2 do DrawButton(B.Canvas, i);
    end;
end;

procedure TspSkinCheckListBox.CMMouseEnter;
begin
  inherited;
  if FCaptionMode
  then
    TestActive(-1, -1);
end;

procedure TspSkinCheckListBox.CMMouseLeave;
var
  i: Integer;
begin
  inherited;
  if FCaptionMode
  then
  for i := 0 to 1 do
    if Buttons[i].MouseIn
    then
       begin
         Buttons[i].MouseIn := False;
         RePaint;
       end;
end;

procedure TspSkinCheckListBox.MouseDown;
begin
  if FCaptionMode
  then
    begin
      TestActive(X, Y);
      if ActiveButton <> -1
      then
        begin
          CaptureButton := ActiveButton;
          ButtonDown(ActiveButton, X, Y);
      end;
    end;
  inherited;
end;

procedure TspSkinCheckListBox.MouseUp;
begin
  if FCaptionMode
  then
    begin
      if CaptureButton <> -1
      then ButtonUp(CaptureButton, X, Y);
      CaptureButton := -1;
    end;  
  inherited;
end;

procedure TspSkinCheckListBox.MouseMove;
begin
  inherited;
  if FCaptionMode then TestActive(X, Y);
end;

procedure TspSkinCheckListBox.TestActive(X, Y: Integer);
var
  i, j: Integer;
begin
  if (FIndex <> -1) and IsNullRect(UpButtonRect) and IsNullRect(DownButtonRect)
  then Exit; 

  j := -1;
  OldActiveButton := ActiveButton;
  for i := 0 to 2 do
  begin
    if PtInRect(Buttons[i].R, Point(X, Y))
    then
      begin
        j := i;
        Break;
      end;
  end;

  ActiveButton := j;

  if (CaptureButton <> -1) and
     (ActiveButton <> CaptureButton) and (ActiveButton <> -1)
  then
    ActiveButton := -1;

  if (OldActiveButton <> ActiveButton)
  then
    begin
      if OldActiveButton <> - 1
      then
        ButtonLeave(OldActiveButton);

      if ActiveButton <> -1
      then
        ButtonEnter(ActiveButton);
    end;
end;

procedure TspSkinCheckListBox.ButtonDown;
begin
  Buttons[i].MouseIn := True;
  Buttons[i].Down := True;
  DrawButton(Canvas, i);

  case i of
    0: if Assigned(FOnUpButtonClick) then Exit;
    1: if Assigned(FOnDownButtonClick) then Exit;
    2: if Assigned(FOnCheckButtonClick) then Exit;
  end;

  TimerMode := 0;
  case i of
    0: TimerMode := 1;
    1: TimerMode := 2;
  end;

  if TimerMode <> 0
  then
    begin
      WaitMode := True;
      SetTimer(Handle, 1, 500, nil);
    end;
end;

procedure TspSkinCheckListBox.ButtonUp;
begin
  Buttons[i].Down := False;
  if ActiveButton <> i then Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
  case i of
    0:
      if Assigned(FOnUpButtonClick)
      then
        begin
          FOnUpButtonClick(Self);
          Exit;
        end;
    1:
      if Assigned(FOnDownButtonClick)
      then
        begin
          FOnDownButtonClick(Self);
          Exit;
        end;
    2:
      if Assigned(FOnCheckButtonClick)
      then
        begin
          FOnCheckButtonClick(Self);
          Exit;
        end;
  end;
  case i of
    1: ItemIndex := ItemIndex + 1;
    0: if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
    2: if ItemIndex > -1
       then
         begin
           Checked[ItemIndex] := not Checked[ListBox.ItemIndex];
           ListBoxOnClickCheck(Self);
        end;
  end;
  if TimerMode <> 0 then StopTimer;
end;

procedure TspSkinCheckListBox.ButtonEnter(I: Integer);
begin
  Buttons[i].MouseIn := True;
  DrawButton(Canvas, i);
  if (TimerMode <> 0) and Buttons[i].Down
  then SetTimer(Handle, 1, 50, nil);
end;

procedure TspSkinCheckListBox.ButtonLeave(I: Integer);
begin
  Buttons[i].MouseIn := False;
  DrawButton(Canvas, i);
  if (TimerMode <> 0) and Buttons[i].Down
  then KillTimer(Handle, 1);
end;

procedure TspSkinCheckListBox.CMTextChanged;
begin
  inherited;
  if FCaptionMode then RePaint;
end;

procedure TspSkinCheckListBox.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value
  then
    begin
      FAlignment := Value;
      if FCaptionMode then RePaint;
    end;
end;

procedure TspSkinCheckListBox.DrawButton;
var
  C: TColor;
  kf: Double;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Buttons[i] do
    begin
      R1 := R;
      if Down and MouseIn
      then
        begin
          Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          Cnvs.Brush.Color := SP_XP_BTNDOWNCOLOR;
          Cnvs.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(Cnvs, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            Cnvs.Brush.Color := SP_XP_BTNACTIVECOLOR;
            Cnvs.FillRect(R1);
          end
        else
          begin
            Cnvs.Brush.Color := clBtnFace;
            Cnvs.FillRect(R1);
          end;
      C := clBlack;
      case i of
        0: DrawArrowImage(Cnvs, R, C, 3);
        1: DrawArrowImage(Cnvs, R, C, 4);
        2: DrawCheckImage(Cnvs, R.Left + 4, R.Top + 4, C);
      end;
    end
  else
    with Buttons[i] do
    if not IsNullRect(R) then
    begin
      R1 := NullRect;
      case I of
        0:
          begin
            if Down and MouseIn
            then R1 := DownUpButtonRect
            else if MouseIn then R1 := ActiveUpButtonRect;
          end;
        1:
          begin
            if Down and MouseIn
            then R1 := DownDownButtonRect
            else if MouseIn then R1 := ActiveDownButtonRect;
          end;
        2: begin
            if Down and MouseIn
            then R1 := DownCheckButtonRect
            else if MouseIn then R1 := ActiveCheckButtonRect;
           end;
      end;
      if not IsNullRect(R1)
      then
        Cnvs.CopyRect(R, Picture.Canvas, R1)
      else
        begin
          case I of
            0: R1 := UpButtonRect;
            1: R1 := DownButtonRect;
            2: R1 := CheckButtonRect;
          end;
          OffsetRect(R1, SkinRect.Left, SkinRect.Top);
          Cnvs.CopyRect(R, Picture.Canvas, R1);
        end;
    end;
end;

procedure TspSkinCheckListBox.SetCaptionMode;
begin
  FCaptionMode := Value;
  if FIndex = -1
  then
    begin
      CalcRects;
      RePaint;
    end;
end;

procedure TspSkinCheckListBox.ListBoxOnClickCheck(Sender: TObject);
begin
  if Assigned(FOnClickCheck) then FOnClickCheck(Self);
end;

procedure TspSkinCheckListBox.SetChecked;
begin
  ListBox.Checked[Index] := Checked;
end;

function TspSkinCheckListBox.GetChecked;
begin
  Result := ListBox.Checked[Index];
end;

procedure TspSkinCheckListBox.SetState;
begin
  ListBox.State[Index] := AState;
end;

function TspSkinCheckListBox.GetState;
begin
  Result := ListBox.State[Index];
end;

function TspSkinCheckListBox.CalcHeight;
begin
  if FIndex = -1
  then
    Result := AitemsCount * ListBox.ItemHeight + 4
  else
    Result := ClRect.Top + AitemsCount * ListBox.ItemHeight +
              RectHeight(SkinRect) - ClRect.Bottom;
end;

procedure TspSkinCheckListBox.Clear;
begin
  ListBox.Clear;
end;


function TspSkinCheckListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
begin
  Result := ListBox.ItemAtPos(Pos, Existing);
end;

function TspSkinCheckListBox.ItemRect(Item: Integer): TRect;
begin
  Result := ListBox.ItemRect(Item);
end;

function TspSkinCheckListBox.GetListBoxPopupMenu;
begin
  Result := ListBox.PopupMenu;
end;

procedure TspSkinCheckListBox.SetListBoxPopupMenu;
begin
  ListBox.PopupMenu := Value;
end;


function TspSkinCheckListBox.GetCanvas: TCanvas;
begin
  Result := ListBox.Canvas;
end;

function TspSkinCheckListBox.GetExtandedSelect: Boolean;
begin
  Result := ListBox.ExtendedSelect;
end;

procedure TspSkinCheckListBox.SetExtandedSelect(Value: Boolean);
begin
  ListBox.ExtendedSelect := Value;
end;

function TspSkinCheckListBox.GetSelCount: Integer;
begin
  Result := ListBox.SelCount;
end;

function TspSkinCheckListBox.GetSelected(Index: Integer): Boolean;
begin
  Result := ListBox.Selected[Index];
end;

procedure TspSkinCheckListBox.SetSelected(Index: Integer; Value: Boolean);
begin
  ListBox.Selected[Index] := Value;
end;

function TspSkinCheckListBox.GetSorted: Boolean;
begin
  Result := ListBox.Sorted;
end;

procedure TspSkinCheckListBox.SetSorted(Value: Boolean);
begin
  if ScrollBar <> nil then HideScrollBar;
  ListBox.Sorted := Value;
end;

function TspSkinCheckListBox.GetTopIndex: Integer;
begin
  Result := ListBox.TopIndex;
end;

procedure TspSkinCheckListBox.SetTopIndex(Value: Integer);
begin
  ListBox.TopIndex := Value;
end;

function TspSkinCheckListBox.GetMultiSelect: Boolean;
begin
  Result := ListBox.MultiSelect;
end;

procedure TspSkinCheckListBox.SetMultiSelect(Value: Boolean);
begin
  ListBox.MultiSelect := Value;
end;

function TspSkinCheckListBox.GetListBoxFont: TFont;
begin
  Result := ListBox.Font;
end;

procedure TspSkinCheckListBox.SetListBoxFont(Value: TFont);
begin
  ListBox.Font.Assign(Value);
end;

function TspSkinCheckListBox.GetListBoxTabOrder: TTabOrder;
begin
  Result := ListBox.TabOrder;
end;

procedure TspSkinCheckListBox.SetListBoxTabOrder(Value: TTabOrder);
begin
  ListBox.TabOrder := Value;
end;

function TspSkinCheckListBox.GetListBoxTabStop: Boolean;
begin
  Result := ListBox.TabStop;
end;

procedure TspSkinCheckListBox.SetListBoxTabStop(Value: Boolean);
begin
  ListBox.TabStop := Value;
end;

procedure TspSkinCheckListBox.ShowScrollBar;
begin
  ScrollBar := TspSkinScrollBar.Create(Self);
  with ScrollBar do
  begin
    Parent := Self;
    if Columns > 0
    then
      Kind := sbHorizontal
    else
      Kind := sbVertical;
    Height := 100;
    Width := 20;
    Parent := Self;
    PageSize := 0;
    Min := 0;
    Position := 0;
    OnChange := SBChange;
    if Self.FIndex = -1
    then
      SkinDataName := ''
    else
      if Columns > 0
      then
        SkinDataName := HScrollBarName
      else
        SkinDataName := VScrollBarName;
    SkinData := Self.SkinData;
    CalcRects;
    Visible := True;
  end;
  RePaint;
end;

procedure TspSkinCheckListBox.ListBoxEnter;
begin
end;

procedure TspSkinCheckListBox.ListBoxExit;
begin
end;

procedure TspSkinCheckListBox.ListBoxKeyDown;
begin
  if Assigned(FOnListBoxKeyDown) then FOnListBoxKeyDown(Self, Key, Shift);
end;

procedure TspSkinCheckListBox.ListBoxKeyUp;
begin
  if Assigned(FOnListBoxKeyUp) then FOnListBoxKeyUp(Self, Key, Shift);
end;

procedure TspSkinCheckListBox.ListBoxKeyPress;
begin
  if Assigned(FOnListBoxKeyPress) then FOnListBoxKeyPress(Self, Key);
end;

procedure TspSkinCheckListBox.ListBoxDblClick;
begin
  if Assigned(FOnListBoxDblClick) then FOnListBoxDblClick(Self);
end;

procedure TspSkinCheckListBox.ListBoxClick;
begin
  if Assigned(FOnListBoxClick) then FOnListBoxClick(Self);
end;

procedure TspSkinCheckListBox.ListBoxMouseDown;
begin
  if Assigned(FOnListBoxMouseDown) then FOnListBoxMouseDown(Self, Button, Shift, X, Y);
end;

procedure TspSkinCheckListBox.ListBoxMouseMove;
begin
  if Assigned(FOnListBoxMouseMove) then FOnListBoxMouseMove(Self, Shift, X, Y);
end;

procedure TspSkinCheckListBox.ListBoxMouseUp;
begin
  if Assigned(FOnListBoxMouseUp) then FOnListBoxMouseUp(Self, Button, Shift, X, Y);
end;

procedure TspSkinCheckListBox.HideScrollBar;
begin
  ScrollBar.Visible := False;
  ScrollBar.Free;
  ScrollBar := nil;
  CalcRects;
end;

procedure TspSkinCheckListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TspSkinCheckListBox.SBChange;
var
  LParam, WParam: Integer;
begin
  LParam := 0;
  WParam := MakeWParam(SB_THUMBPOSITION, ScrollBar.Position);
  if Columns > 0
  then
    SendMessage(ListBox.Handle, WM_HSCROLL, WParam, LParam)
  else
    SendMessage(ListBox.Handle, WM_VSCROLL, WParam, LParam);
end;

function TspSkinCheckListBox.GetItemIndex;
begin
  Result := ListBox.ItemIndex;
end;

procedure TspSkinCheckListBox.SetItemIndex;
begin
  ListBox.ItemIndex := Value;
end;


procedure TspSkinCheckListBox.SetItems;
begin
  ListBox.Items.Assign(Value);
  UpDateScrollBar;
end;

function TspSkinCheckListBox.GetItems;
begin
  Result := ListBox.Items;
end;

destructor TspSkinCheckListBox.Destroy;
begin
  if ScrollBar <> nil then ScrollBar.Free;
  if ListBox <> nil then ListBox.Free;
  FDefaultCaptionFont.Free;
  FGlyph.Free;
  inherited;
end;

procedure TspSkinCheckListBox.CalcRects;
var
  LTop: Integer;
  OffX, OffY: Integer;
begin
  if FIndex <> -1
  then
    begin
      OffX := Width - RectWidth(SkinRect);
      OffY := Height - RectHeight(SkinRect);
      NewClRect := ClRect;
      Inc(NewClRect.Right, OffX);
      Inc(NewClRect.Bottom, OffY);
    end
  else
    if FCaptionMode
    then
      LTop := FDefaultCaptionHeight
    else
      LTop := 1;

  if (ScrollBar <> nil) and ScrollBar.Visible
  then
    begin
      if FIndex = -1
      then
        begin
          if Columns > 0
          then
            begin
              ScrollBar.SetBounds(1, Height - 20, Width - 2, 19);
              ListRect := Rect(2, LTop + 1, Width - 2, ScrollBar.Top);
            end
          else
            begin
              ScrollBar.SetBounds(Width - 20, LTop, 19, Height - 1 - LTop);
              ListRect := Rect(2, LTop + 1, ScrollBar.Left, Height - 2);
            end;
        end
      else
        begin
          if Columns > 0
          then
            begin
              ScrollBar.SetBounds(NewClRect.Left,
                NewClRect.Bottom - ScrollBar.Height,
                RectWidth(NewClRect), ScrollBar.Height);
              ListRect := NewClRect;
              Dec(ListRect.Bottom, ScrollBar.Height);
            end
          else
            begin
              ScrollBar.SetBounds(NewClRect.Right - ScrollBar.Width,
                NewClRect.Top, ScrollBar.Width, RectHeight(NewClRect));
              ListRect := NewClRect;
              Dec(ListRect.Right, ScrollBar.Width);
            end;
        end;
    end
  else
    begin
      if FIndex = -1
      then
        ListRect := Rect(2, LTop + 1, Width - 2, Height - 2)
      else
        ListRect := NewClRect;
    end;
  if ListBox <> nil
  then
    ListBox.SetBounds(ListRect.Left, ListRect.Top,
      RectWidth(ListRect), RectHeight(ListRect));
end;

procedure TspSkinCheckListBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinListBox
    then
      with TspDataSkinCheckListBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.SItemRect := SItemRect;
        Self.ActiveItemRect := ActiveItemRect;
        if isNullRect(ActiveItemRect)
        then
          Self.ActiveItemRect := SItemRect;
        Self.FocusItemRect := FocusItemRect;
        if isNullRect(FocusItemRect)
        then
          Self.FocusItemRect := SItemRect;

        Self.UnCheckImageRect := UnCheckImageRect;
        Self.CheckImageRect := CheckImageRect;

        Self.ItemLeftOffset := ItemLeftOffset;
        Self.ItemRightOffset := ItemRightOffset;
        Self.ItemTextRect := ItemTextRect;
        Self.ItemCheckRect := ItemCheckRect;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.FocusFontColor := FocusFontColor;
        Self.VScrollBarName := VScrollBarName;
        Self.HScrollBarName := HScrollBarName;

        Self.CaptionRect := CaptionRect;
        Self.CaptionFontName := CaptionFontName;
        Self.CaptionFontStyle := CaptionFontStyle;
        Self.CaptionFontHeight := CaptionFontHeight;
        Self.CaptionFontColor := CaptionFontColor;
        Self.UpButtonRect := UpButtonRect;
        Self.ActiveUpButtonRect := ActiveUpButtonRect;
        Self.DownUpButtonRect := DownUpButtonRect;
        if IsNullRect(Self.DownUpButtonRect)
        then Self.DownUpButtonRect := Self.ActiveUpButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.ActiveDownButtonRect := ActiveDownButtonRect;
        Self.DownDownButtonRect := DownDownButtonRect;
        if IsNullRect(Self.DownDownButtonRect)
        then Self.DownDownButtonRect := Self.ActiveDownButtonRect;
        Self.CheckButtonRect := CheckButtonRect;
        Self.ActiveCheckButtonRect := ActiveCheckButtonRect;
        Self.DownCheckButtonRect := DownCheckButtonRect;
        if IsNullRect(Self.DownCheckButtonRect)
        then Self.DownCheckButtonRect := Self.ActiveCheckButtonRect;
      end;
end;

procedure TspSkinCheckListBox.ChangeSkinData;
begin
  inherited;
  //
  if FIndex <> -1
  then
    begin
      if FUseSkinItemHeight
      then
        ListBox.ItemHeight := RectHeight(sItemRect);
    end
  else
    begin
      ListBox.ItemHeight := FDefaultItemHeight;
      Font.Assign(FDefaultFont);
    end;

  if ScrollBar <> nil
  then
    with ScrollBar do
    begin
      if Self.FIndex = -1
      then
        SkinDataName := ''
      else
        if Columns > 0
        then
          SkinDataName := HScrollBarName
        else
          SkinDataName := VScrollBarName;
      SkinData := Self.SkinData;
    end;

  if FRowCount <> 0
  then
    Height := Self.CalcHeight(FRowCount);
  CalcRects;
  UpDateScrollBar;
  ListBox.RePaint;
end;

procedure TspSkinCheckListBox.WMSIZE;
begin
  inherited;
  CalcRects;
  UpDateScrollBar;
  if ScrollBar <> nil then ScrollBar.Repaint;
end;

procedure TspSkinCheckListBox.SetBounds;
begin
  inherited;
  if FIndex = -1 then RePaint;
end;

procedure TspSkinCheckListBox.UpDateScrollBar;
var
  Min, Max, Pos, Page: Integer;
begin
  if (ListBox = nil) or ((FRowCount > 0) and (RowCount = Items.Count))
  then Exit;
  if Columns > 0
  then
    begin
      GetScrollRange(ListBox.Handle, SB_HORZ, Min, Max);
      Pos := GetScrollPos(ListBox.Handle, SB_HORZ);
      Page := ListBox.Columns;
      if (Max > Min) and (Pos <= Max) and (Page <= Max)
      then
        begin
          if ScrollBar = nil
          then ShowScrollBar;
          ScrollBar.SetRange(Min, Max, Pos, Page);
        end
     else
       if (ScrollBar <> nil) and (ScrollBar.Visible) then HideScrollBar;
    end
  else
    begin
      if not ((FRowCount > 0) and (RowCount = Items.Count))
      then
        begin
          GetScrollRange(ListBox.Handle, SB_VERT, Min, Max);
          Pos := GetScrollPos(ListBox.Handle, SB_VERT);
          Page := ListBox.Height div ListBox.ItemHeight;
          if (Max > Min) and (Pos <= Max) and (Page < Items.Count)
          then
            begin
              if ScrollBar = nil then ShowScrollBar;
              ScrollBar.SetRange(Min, Max, Pos, Page);
              ScrollBar.LargeChange := Page;
            end
          else
            if (ScrollBar <> nil) and ScrollBar.Visible then HideScrollBar;
        end
      else
        if (ScrollBar <> nil) and ScrollBar.Visible then HideScrollBar;
    end;
end;

constructor TspSkinScrollBox.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FInCheckScrollBars := False;
  FVSizeOffset := 0;
  FHSizeOffset := 0;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FOldVScrollBarPos := 0;
  FOldHScrollBarPos := 0;
  FDown := False;
  FSkinDataName := 'scrollbox';
  BGPictureIndex := -1;
  Width := 150;
  Height := 150;
end;

destructor TspSkinScrollBox.Destroy;
begin
  inherited;
end;

procedure TspSkinScrollBox.UpdateScrollRange;
begin
  GetHRange;
  GetVRange;
end;

procedure TspSkinScrollBox.CMVisibleChanged;
begin
  inherited;
  if FVScrollBar <> nil then FVScrollBar.Visible := Self.Visible;
  if FHScrollBar <> nil then FHScrollBar.Visible := Self.Visible;
end;

procedure TspSkinScrollBox.OnHScrollBarChange(Sender: TObject);
begin
  HScrollControls(FHScrollBar.Position - FOldHScrollBarPos);
  FOldHScrollBarPos := HScrollBar.Position;
end;

procedure TspSkinScrollBox.OnVScrollBarChange(Sender: TObject);
begin
  VScrollControls(FVScrollBar.Position - FOldVScrollBarPos);
  FOldVScrollBarPos := VScrollBar.Position;
end;

procedure TspSkinScrollBox.OnHScrollBarLastChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TspSkinScrollBox.OnVScrollBarLastChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TspSkinScrollBox.ChangeSkinData;
begin
  inherited;
  ReCreateWnd;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
  if FHScrollBar <> nil then FHScrollBar.Align := FHScrollBar.Align;
end;

procedure TspSkinScrollBox.HScroll;
begin
  if (FHScrollBar <> nil) and (FHScrollBar.PageSize <> 0)
  then
    with FHScrollBar do
    begin
      HScrollControls(APosition - Position);
      Position := APosition;
    end;
end;

procedure TspSkinScrollBox.VScroll;
begin
  if (FVScrollBar <> nil) and (FVScrollBar.PageSize <> 0)
  then
    with FVScrollBar do
    begin
      if APosition > Max - PageSize then APosition := Max - PageSize;
      VScrollControls(APosition - Position);
      Position := APosition;
    end;
end;


procedure TspSkinScrollBox.SetBorderStyle;
begin
  FBorderStyle := Value;
  ReCreateWnd;
end;

procedure TspSkinScrollBox.GetSkinData;
begin
  inherited;
  BGPictureIndex := -1;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinScrollBoxControl
    then
      with TspDataSkinScrollBoxControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.BGPictureIndex := BGPictureIndex;
      end;
end;

procedure TspSkinScrollBox.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FHScrollBar)
  then FHScrollBar := nil;
  if (Operation = opRemove) and (AComponent = FVScrollBar)
  then FVScrollBar := nil;
end;

procedure TspSkinScrollBox.SetVScrollBar;
begin
  FVScrollBar := Value;
  if FVScrollBar <> nil
  then
    with FVScrollBar do
    begin
      CanFocused := False;
      OnChange := OnVScrollBarChange;
      OnLastChange := OnVScrollBarLastChange;
      Enabled := True;
      Visible := False;
    end;
  GetVRange;
end;

procedure TspSkinScrollBox.SetHScrollBar;
begin
  FHScrollBar := Value;
  if FHScrollBar <> nil
  then
    with FHScrollBar do
    begin
      CanFocused := False;
      Enabled := True;
      Visible := False;
      OnChange := OnHScrollBarChange;
      OnLastChange := OnHScrollBarLastChange;
    end;
  GetHRange;
end;

procedure TspSkinScrollBox.CreateControlDefaultImage;
var
  R: TRect;
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
end;

type
  TParentControl = class(TWinControl);

procedure TspSkinScrollBox.GetVRange;
var
  i, MaxBottom, H, Offset: Integer;
  FMax: Integer;
  VisibleChanged, IsVisible: Boolean;
  R: TRect;
begin
  if (FVScrollBar = nil) or FInCheckScrollBars or (Parent = nil) then Exit;
  VisibleChanged := False;
  H := ClientHeight;
  MaxBottom := 0;
  for i := 0 to ControlCount - 1 do
  with Controls[i] do
  begin
   if Visible
   then
     if Top + Height > MaxBottom then MaxBottom := Top + Height;
  end;
  with FVScrollBar do
  begin
    FMax := MaxBottom + Position;
    if FMax > H
    then
      begin
        if not Visible
        then
          begin
            IsVisible := True;
            VisibleChanged := True;
          end;
        if (Position > 0) and (MaxBottom < H) and (FVSizeOffset > 0)
        then
          begin
            if FVSizeOffset > Position then FVSizeOffset := Position;
            SetRange(0, FMax - 1, Position - FVSizeOffset, H);
            VScrollControls(- FVSizeOffset);
            FVSizeOffset := 0;
            FOldVScrollBarPos := Position;
          end
        else
          begin
            if (FVSizeOffset = 0) and ((FMax - 1) < Max) and (Position > 0) and
               (MaxBottom < H)
            then
              begin
                Offset := Max - (FMax - 1);
                Offset := Offset + (Max - PageSize + 1) + Position;
                if Offset > Position then  Offset := Position;
                VScrollControls(-Offset);
                SetRange(0, FMax - 1, Position - OffSet, H);
              end
            else
              SetRange(0, FMax - 1, Position, H);
            FVSizeOffset := 0;
            FOldVScrollBarPos := Position;
          end;
      end
    else
      begin
        if Position > 0
        then VScrollControls(-Position);
        FVSizeOffset := 0;
        FOldVScrollBarPos := 0;
        SetRange(0, 0, 0, 0);
        if Visible
        then
          begin
            IsVisible := False;
            VisibleChanged := True;
          end;
      end;
   end;

   if (FVScrollBar <> nil) and (FHScrollBar <> nil)
   then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if VisibleChanged
  then
    begin
      FInCheckScrollBars := True;
      FVScrollBar.Visible := IsVisible;
      if (Align <> alNone)
      then
        begin
          R := Parent.ClientRect;
          TParentControl(Parent).AlignControls(nil, R);
        end;
       FInCheckScrollBars := False;  
    end;
end;

procedure TspSkinScrollBox.VScrollControls;
begin
  ScrollBy(0,  -AOffset);
end;

procedure TspSkinScrollBox.AdjustClientRect(var Rect: TRect);
var
  RLeft, RTop, VMax, HMax: Integer;
begin
  if (VScrollbar <> nil) and VScrollbar.Visible
  then
    begin
      RTop := -VScrollbar.Position;
      VMax := Max(VScrollBar.Max, ClientHeight);
    end
  else
    begin
      RTop := 0;
      VMax := ClientHeight;
    end;
  if (HScrollbar <> nil) and HScrollbar.Visible
  then
    begin
      RLeft := -HScrollbar.Position;
      HMax := Max(HScrollBar.Max, ClientWidth);
    end
  else
    begin
      RLeft := 0;
      HMax := ClientWidth;
    end;
  Rect := Bounds(RLeft, RTop,  HMax, VMax);
  inherited AdjustClientRect(Rect);
end;

procedure TspSkinScrollBox.GetHRange;
var
  i, MaxRight, W, Offset: Integer;
  FMax: Integer;
  VisibleChanged, IsVisible: Boolean;
  R: TRect;
begin
  if (FHScrollBar = nil) or FInCheckScrollBars or (Parent = nil)  then Exit;
  VisibleChanged := False;
  W := ClientWidth;
  MaxRight := 0;
  for i := 0 to ControlCount - 1 do
  with Controls[i] do
  begin
   if Visible
   then
     if Left + Width > MaxRight then MaxRight := left + Width;
  end;
  with FHScrollBar do
  begin
    FMax := MaxRight + Position;
    if FMax > W
    then
      begin
        if not Visible
        then
          begin
            IsVisible := True;
            VisibleChanged := True;
          end;
        if (Position > 0) and (MaxRight < W) and (FHSizeOffset > 0)
        then
          begin
            if FHSizeOffset > Position
            then FHSizeOffset := Position;
            SetRange(0, FMax - 1, Position - FHSizeOffset , W);
            HScrollControls(-FHSizeOffset);
            FOldHScrollBarPos := Position;
          end
        else
          begin
            if (FHSizeOffset = 0) and ((FMax - 1) < Max) and (Position > 0) and
               (MaxRight < W)
            then
              begin
                Offset := Max - (FMax - 1);
                Offset := Offset + (Max - PageSize + 1) + Position;
                if Offset > Position then  Offset := Position;
                HScrollControls(-Offset);
                SetRange(0, FMax - 1, Position - Offset, W);
              end
            else
              SetRange(0, FMax - 1, Position, W);
            FHSizeOffset := 0;
            FOldHScrollBarPos := Position;
          end;
      end
    else
      begin
        if Position > 0
        then HScrollControls(-Position);
        FHSizeOffset := 0;
        FOldHScrollBarPos := 0;
        SetRange(0, 0, 0, 0);
        if Visible
        then
          begin
            IsVisible := False;
            VisibleChanged := True;
          end;
      end;
   end;

  if (FVScrollBar <> nil) and (FHScrollBar <> nil)
  then
    begin
      if not FVScrollBar.Visible and FHScrollBar.Both
      then
        FHScrollBar.Both := False
      else
      if FVScrollBar.Visible and not FHScrollBar.Both
      then
        FHScrollBar.Both := True;
    end;

  if VisibleChanged
  then
    begin
      FInCheckScrollBars := True;
      FHScrollBar.Visible := IsVisible;
      FInCheckScrollBars := False;
      if (Align <> alNone)
      then
        begin
          R := Parent.ClientRect;
          TParentControl(Parent).AlignControls(nil, R);
        end;
    end;
end;

procedure TspSkinScrollBox.HScrollControls;
begin
  ScrollBy(-AOffset, 0);
end;

procedure TspSkinScrollBox.WMWindowPosChanging;
begin
  inherited;
  if HandleAllocated and (Align = alNone)
  then
    begin
      GetVRange;
      GetHRange;
    end;
end;

procedure TspSkinScrollBox.SetBounds;
var
  OldHeight, OldWidth: Integer;
  R: TRect;
begin
  OldWidth := Width;
  OldHeight := Height;
  inherited;
  if (OldWidth <> Width)
  then
    begin
      if (OldWidth < Width) and (OldWidth <> 0)
      then FHSizeOffset := Width - OldWidth
      else FHSizeOffset := 0;
    end
  else
    FHSizeOffset := 0;
  if (OldHeight <> Height)
  then
    begin
      if (OldHeight < Height) and (OldHeight <> 0)
      then FVSizeOffset := Height - OldHeight
      else FVSizeOffset := 0;
    end
  else
    FVSizeOffset := 0;
  if Align <> alNone
  then
    begin
      GetVRange;
      GetHRange;
    end;  
end;

procedure TspSkinScrollBox.WMNCCALCSIZE;
begin
  GetSkinData;
  if FIndex = -1
  then
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      if FBorderStyle <> bvNone
      then
        begin
          Inc(Left, 1);
          Inc(Top, 1);
          Dec(Right, 1);
          Dec(Bottom, 1);
        end;
    end
  else
    if (BGPictureIndex = -1) and (FBorderStyle <> bvNone) then
    with Message.CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, ClRect.Left);
      Inc(Top, ClRect.Top);
      Dec(Right, RectWidth(SkinRect) - ClRect.Right);
      Dec(Bottom, RectHeight(SkinRect) - ClRect.Bottom);
    end;
end;

procedure TspSkinScrollBox.WMNCPAINT;
var
  DC: HDC;
  C: TCanvas;
  R: TRect;
begin
  if (BGPictureIndex <> -1) or (FBorderStyle = bvNone) then Exit;
  DC := GetWindowDC(Handle);
  C := TControlCanvas.Create;
  C.Handle := DC;
  try
    PaintFrame(C);
  finally
    C.Free;
    ReleaseDC(Handle, DC);
  end;
end;

procedure TspSkinScrollBox.PaintFrame;
var
  NewLTPoint, NewRTPoint, NewLBPoint, NewRBPoint: TPoint;
  R, NewClRect: TRect;
  LeftB, TopB, RightB, BottomB: TBitMap;
  OffX, OffY: Integer;
  AW, AH: Integer;
begin
  GetSkinData;

  if (FIndex = -1)
  then
    with C do
    begin
      if FBorderStyle <> bvNone
      then
        begin
          Brush.Style := bsClear;
          R := Rect(0, 0, Width, Height);
          case FBorderStyle of
            bvLowered: Frame3D(C, R, clBtnHighLight, clBtnShadow, 1);
            bvRaised: Frame3D(C, R, clBtnShadow, clBtnHighLight, 1);
            bvFrame: Frame3D(C, R, clBtnShadow, clBtnShadow, 1);
          end;
        end;
      Exit;
    end;

  LeftB := TBitMap.Create;
  TopB := TBitMap.Create;
  RightB := TBitMap.Create;
  BottomB := TBitMap.Create;

  OffX := Width - RectWidth(SkinRect);
  OffY := Height - RectHeight(SkinRect);
  AW := Width;
  AH := Height;

  NewLTPoint := LTPt;
  NewRTPoint := Point(RTPt.X + OffX, RTPt.Y);
  NewLBPoint := Point(LBPt.X, LBPt.Y + OffY);
  NewRBPoint := Point(RBPt.X + OffX, RBPt.Y + OffY);
  NewClRect := Rect(ClRect.Left, ClRect.Top,
                    ClRect.Right + OffX, ClRect.Bottom + OffY);


  CreateSkinBorderImages(LTPt, RTPt, LBPt, RBPt, CLRect,
      NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
      LeftB, TopB, RightB, BottomB, Picture, SkinRect, Width, Height,
      False, False, False, False);

  C.Draw(0, 0, TopB);
  C.Draw(0, TopB.Height, LeftB);
  C.Draw(Width - RightB.Width, TopB.Height, RightB);
  C.Draw(0, Height - BottomB.Height, BottomB);

  TopB.Free;
  LeftB.Free;
  RightB.Free;
  BottomB.Free;
end;

procedure TspSkinScrollBox.Paint;
var
  X, Y, XCnt, YCnt, w, h,
  rw, rh, XO, YO: Integer;
  Buffer: TBitMap;
  R: TRect;
begin
  GetSkinData;
  if FIndex = -1
  then
    begin
      inherited;
      Exit;
    end;
  if (ClientWidth > 0) and (ClientHeight > 0) then
  if BGPictureIndex <> -1
  then
    begin
      Buffer := TBitMap(FSD.FActivePictures.Items[BGPictureIndex]);
      XCnt := Width div Buffer.Width;
      YCnt := Height div Buffer.Height;
      for X := 0 to XCnt do
      for Y := 0 to YCnt do
        Canvas.Draw(X * Buffer.Width, Y * Buffer.Height, Buffer);
    end
  else
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := ClientWidth;
      Buffer.Height := ClientHeight;
      w := RectWidth(ClRect);
      h := RectHeight(ClRect);
      rw := Buffer.Width;
      rh := Buffer.Height;
      with Buffer.Canvas do
      begin
        XCnt := rw div w;
        YCnt := rh div h;
        for X := 0 to XCnt do
        for Y := 0 to YCnt do
        begin
          if X * w + w > rw then XO := X * W + W - rw else XO := 0;
          if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
            CopyRect(Rect(X * w, Y * h,X * w + w - XO, Y * h + h - YO),
                     Picture.Canvas,
                     Rect(SkinRect.Left + ClRect.Left,
                     SkinRect.Top + ClRect.Top,
                     SkinRect.Left + ClRect.Right - XO,
                     SkinRect.Top + ClRect.Bottom - YO));
        end;
        Canvas.Draw(0, 0, Buffer);
        Buffer.Free;
      end;
   end;
end;

procedure TspSkinScrollBox.WMSIZE;
begin
  inherited;
  SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TspSkinScrollBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

constructor TspPopupCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
end;

procedure TspPopupCalendar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_;
  end;
end;

procedure TspPopupCalendar.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

constructor TspSkinDateEdit.Create(AOwner: TComponent);
begin
  inherited;
  EditMask := GetDateMask;
  FTodayDefault := False;
  ButtonMode := True;
  FSkinDataName := 'buttonedit';
  FMonthCalendar := TspPopupCalendar.Create(Self);
  FMonthCalendar.Parent := Self;
  FMonthCalendar.Visible := False;
  FMonthCalendar.OnNumberClick := CalendarClick;
  OnButtonClick := ButtonClick;
  FCalendarAlphaBlend := False;
  FCalendarAlphaBlendValue := 0;
  FCalendarAlphaBlendAnimation := False;
end;

destructor TspSkinDateEdit.Destroy;
begin
  FMonthCalendar.Free;
  inherited;
end;

function TspSkinDateEdit.IsDateInput: Boolean;
begin
  Result := IsValidText(Text);
end;

function TspSkinDateEdit.MyStrToDate;
var
  S1: array[1..3] of String;
  i, j: Integer;
  M, Y, D: Word;
  MPos, YPos, DPos: Word;
  F: String;
begin
  F := DateToStr(EncodeDate(9999, 12, 31));
  YPos := 1;
  MPos := 1;
  Dpos := 1;
  j := 1;
  for i := 1 to 3 do s1[i] := '';
  for i := 1 to Length(F) do
   if F[i] = DateSeparator then inc(j) else s1[j] := s1[j] + F[i];
  for i := 1 to 3 do
  begin
    if not IsOnlyNumbers(s1[i])
    then
      MPos := i
    else
      begin
        j := StrToInt(s1[i]);
        case j of
          31: DPos := i;
          9999: YPos := i;
          99: YPos := i;
        end;
      end;
  end;
  j := 1;
  for i := 1 to 3 do s1[i] := '';
  for i := 1 to Length(S) do
   if S[i] = DateSeparator then inc(j) else s1[j] := s1[j] + S[i];
  M := DecodeMonth(s1[MPos]);
  D := StrToInt(s1[DPos]);
  Y := StrToInt(s1[YPos]);
  Result := EncodeDate(Y, M, D);
end;

function TspSkinDateEdit.ExtactMonth;
var
  F: String;
  S1: array[1..3] of String;
  i, j: Integer;
begin
  F := DateToStr(ADate);
  j := 1;
  for i := 1 to 3 do s1[i] := '';
  for i := 1 to Length(F) do
   if F[i] = DateSeparator then inc(j) else s1[j] := s1[j] + F[i];
  Result := '';
  for i := 1 to 3 do
  begin
    if not IsOnlyNumbers(s1[i])
    then
      begin
        Result := s1[i];
        Break;
      end;
  end;
end;

function TspSkinDateEdit.DecodeMonth(S: String): Word;
var
  S1: String;
  i: Integer;
begin
  Result := 1;
  for i := 1 to 12 do
  begin
    S1 := ExtactMonth(EncodeDate(9999, i, 1));
    if LowerCase(S1) = LowerCase(S)
    then
      begin
        Result := i;
        Break;
      end
  end;
end;

function TspSkinDateEdit.IsMonth(S: String): Boolean;
var
  S1: String;
  i: Integer;
begin
  Result := False;
  for i := 1 to 12 do
  begin
    S1 := ExtactMonth(EncodeDate(9999, i, 1));
    if LowerCase(S1) = LowerCase(S)
    then
      begin
        Result := True;
        Break;
      end
  end;
end;

function TspSkinDateEdit.IsOnlyNumbers;
const
  DateSymbols = '0123456789';
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(S) do
  begin
    if (Pos(S[i], DateSymbols) = 0) and (S[i] <> DateSeparator)
    then
      begin
        Result := False;
        Break;
      end;
  end;
end;

function TspSkinDateEdit.GetDateMask: String;
var
  S: String;
  S1: array[1..3] of String;
  i, j: Integer;
  MPos, DPos, YPos: Integer;
  FL: Boolean;
begin
  S := DateToStr(EncodeDate(9999, 12, 31));
  YPos := 1;
  MPos := 1;
  Dpos := 1;
  j := 1;
  for i := 1 to 3 do s1[i] := '';
  for i := 1 to Length(S) do
   if S[i] = DateSeparator then inc(j) else s1[j] := s1[j] + S[i];
  FL := False;
  for i := 1 to 3 do
  begin
    if not IsOnlyNumbers(s1[i])
    then
      begin
        MPos := i;
        FL := True;
      end
    else
      begin
        j := StrToInt(s1[i]);
        case j of
         12: MPos := i;
         31: DPos := i;
         9999: YPos := i;
         99: YPos := i;
        end;
      end;
  end;
  Result := '!';
  for i := 1 to Length(s1[DPos]) do S1[DPos][i] := '9';
  if FL
  then
    for i := 1 to Length(s1[MPos]) do S1[MPos][i] := 'L'
  else
    for i := 1 to Length(s1[MPos]) do S1[MPos][i] := '9';
  for i := 1 to Length(s1[YPos]) do S1[YPos][i] := '0';
  Result := Result + s1[1] + '/' + s1[2] + '/' + s1[3] + ';1; ';
end;

function TspSkinDateEdit.GetFirstDayOfWeek;
begin
  Result := FMonthCalendar.FirstDayOfWeek;
end;

procedure TspSkinDateEdit.SetFirstDayOfWeek;
begin
  FMonthCalendar.FirstDayOfWeek := Value;
end;

function TspSkinDateEdit.GetDate: TDate;
begin
  Result := FMonthCalendar.Date;
end;

procedure TspSkinDateEdit.SetDate(Value: TDate);
begin
  FMonthCalendar.Date := Value;
  StopCheck := True;
  if not (csLoading in ComponentState) or FTodayDefault
  then
    begin
      Text := DateToStr(Value);
    end;
  StopCheck := False;
  if Assigned(FOnDateChange) then FOnDateChange(Self);
end;

procedure TspSkinDateEdit.Loaded;
begin
  inherited;
  EditMask := GetDateMask;
  if FTodayDefault then Date := Now;
end;

procedure TspSkinDateEdit.SetTodayDefault;
begin
  FTodayDefault := Value;
  if FTodayDefault then Date := Now;
end;

function TspSkinDateEdit.GetCalendarFont;
begin
  Result := FMonthCalendar.DefaultFont;
end;

procedure TspSkinDateEdit.SetCalendarFont;
begin
  FMonthCalendar.DefaultFont.Assign(Value);
end;

function TspSkinDateEdit.GetCalendarWidth: Integer;
begin
  Result := FMonthCalendar.Width;
end;

procedure TspSkinDateEdit.SetCalendarWidth(Value: Integer);
begin
  FMonthCalendar.Width := Value;
end;

function TspSkinDateEdit.GetCalendarHeight: Integer;
begin
  Result := FMonthCalendar.Height;
end;

procedure TspSkinDateEdit.SetCalendarHeight(Value: Integer);
begin
  FMonthCalendar.Height := Value;
end;

procedure TspSkinDateEdit.Change;
begin
  inherited;
  if not StopCheck
  then
    if IsValidText(Text) then CheckValidDate;
end;

procedure TspSkinDateEdit.CheckValidDate;
var
  OldDate: TDate;
begin
  if FMonthCalendar = nil then Exit;
  OldDate := FMonthCalendar.Date;
  try
    if IsOnlyNumbers(Text)
    then
      FMonthCalendar.Date := StrToDate(Text)
    else
      FMonthCalendar.Date := MyStrToDate(Text);
  finally
   if OldDate <> FMonthCalendar.Date
   then
     if Assigned(FOnDateChange) then FOnDateChange(Self);
  end;
end;

function TspSkinDateEdit.IsValidText;
var
  F: String;
  s1, s2: array[1..3] of String;
  i, j: Integer;
  MPos, DPos, YPos: Integer;
  FL: Boolean;
begin
  Result := Pos(' ', S) = 0;
  if not Result then Exit;
  F := DateToStr(EncodeDate(9999, 12, 31));
  if (IsOnlyNumbers(F) and not IsOnlyNumbers(S)) or
     (IsOnlyNumbers(S) and not IsOnlyNumbers(F))
  then
    begin
      Result := False;
      Exit;
    end;
  for i := 1 to 3 do s1[i] := '';
  for i := 1 to 3 do s2[i] := '';
  j := 1;
  YPos := 1;
  MPos := 1;
  Dpos := 1;
  for i := 1 to Length(F) do
   if F[i] = DateSeparator then inc(j) else s1[j] := s1[j] + F[i];
  FL := False;
  for i := 1 to 3 do
  begin
    if not IsOnlyNumbers(s1[i])
    then
      begin
        MPos := i;
        FL := True;
      end
    else
      begin
        j := StrToInt(s1[i]);
        case j of
         12: MPos := i;
         31: DPos := i;
         9999: YPos := i;
         99: YPos := i;
        end;
      end;
  end;

  j := 1;
  for i := 1 to Length(S) do
    if S[i] = DateSeparator then inc(j) else s2[j] := s2[j] + S[i];

  if StrToInt(s2[Ypos]) = 0
  then
    Result := Length(s2[YPos]) < 2
  else
    Result := True;

  Result := Result and (Length(s2[1]) > 0) and (Length(s2[2]) > 0) and
            (Length(s2[3]) > 0);

  if not FL
  then
    Result := Result and
              (Length(s1) = Length(s2)) and
              (StrToInt(s2[Mpos]) > 0) and
              (StrToInt(s2[Dpos]) > 0) and
              (StrToInt(s2[1]) <= StrToInt(s1[1])) and
              (StrToInt(s2[2]) <= StrToInt(s1[2])) and
              (StrToInt(s2[3]) <= StrToInt(s1[3]))
  else
    Result := Result and
              (Length(s1) = Length(s2)) and
              (Length(s1[Mpos]) = Length(s2[Mpos])) and
              IsMonth(s2[Mpos]) and
              (StrToInt(s2[Dpos]) > 0) and
              (StrToInt(s2[DPos]) <= StrToInt(s1[DPos])) and
              (StrToInt(s2[YPos]) <= StrToInt(s1[YPos]))
end;

procedure TspSkinDateEdit.CMCancelMode;
begin
 if (Message.Sender <> FMonthCalendar) and
     not FMonthCalendar.ContainsControl(Message.Sender)
 then
   CloseUp(False);
end;

procedure TspSkinDateEdit.WndProc;
begin
  inherited;
  case Message.Msg of
   WM_KILLFOCUS:
     begin
       if not FMonthCalendar.Visible
       then
         begin
           StopCheck := True;
           Text := DateToStr(FMonthCalendar.Date);
           StopCheck := False;
         end
       else
       if Message.wParam <> FMonthCalendar.Handle
       then
         CloseUp(False);
     end;
   WM_KEYDOWN:
      CloseUp(False);
  end;
end;

procedure TspSkinDateEdit.DropDown;
var
  P: TPoint;
  Y, I: Integer;
begin
  P := Parent.ClientToScreen(Point(Left, Top));
  Y := P.Y + Height;
  if Y + FMonthCalendar.Height > Screen.Height then Y := P.Y - FMonthCalendar.Height;
  //
  if CheckW2KWXP and FCalendarAlphaBlend
  then
    begin
      SetWindowLong(FMonthCalendar.Handle, GWL_EXSTYLE,
                    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
      SetAlphaBlendTransparent(FMonthCalendar.Handle, 0)
    end;
  //
  FMonthCalendar.SkinData := Self.SkinData;
  SetWindowPos(FMonthCalendar.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
  FMonthCalendar.Visible := True;
  //
  if FCalendarAlphaBlend and not FCalendarAlphaBlendAnimation and CheckW2KWXP
  then
    begin
      Application.ProcessMessages;
      SetAlphaBlendTransparent(FMonthCalendar.Handle, FCalendarAlphaBlendValue)
    end
  else
  if FCalendarAlphaBlendAnimation and FCalendarAlphaBlend and CheckW2KWXP
  then
    begin
      Application.ProcessMessages;
      I := 0;
      repeat
        Inc(i, 2);
        if i > FCalendarAlphaBlendValue then i := FCalendarAlphaBlendValue;
        SetAlphaBlendTransparent(FMonthCalendar.Handle, i);
      until i >= FCalendarAlphaBlendValue;
    end;
end;

procedure TspSkinDateEdit.CloseUp(AcceptValue: Boolean);
begin
  if FMonthCalendar.Visible
  then
    begin
      SetWindowPos(FMonthCalendar.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
        SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      FMonthCalendar.Visible := False;
      if CheckW2KWXP and FCalendarAlphaBlend
      then
        SetWindowLong(FMonthCalendar.Handle, GWL_EXSTYLE,
                      GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
      if AcceptValue
      then
        begin
          StopCheck := True;
          Text := DateToStr(FMonthCalendar.Date);
          if Assigned(FOnDateChange) then FOnDateChange(Self);
          StopCheck := False;
        end;
      SetFocus;
   end;
end;

procedure TspSkinDateEdit.ButtonClick(Sender: TObject);
begin
  if FMonthCalendar.Visible
  then
    CloseUp(False)
  else
    DropDown;
end;

procedure TspSkinDateEdit.CalendarClick;
begin
  CloseUp(True);
end;

constructor TspPopupListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable,
    csAcceptsControls];
  Ctl3D := False;
  ParentCtl3D := False;
  Visible := False;
  FOldAlphaBlend := False;
  FOldAlphaBlendValue := 0;
end;

procedure TspPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP or WS_CLIPCHILDREN;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_;
  end;
end;

procedure TspPopupListBox.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspPopupListBox.Hide;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
end;

procedure TspPopupListBox.Show(Origin: TPoint);
var
  PLB: TspSkinCustomComboBox;
  I: Integer;
begin
  PLB := nil;
  //
  if CheckW2KWXP and (Owner is TspSkinCustomComboBox)
  then
    begin
      PLB := TspSkinCustomComboBox(Owner);
      if PLB.ListBoxAlphaBlend and not FOldAlphaBlend
      then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE,
                        GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
        end
      else
      if not PLB.ListBoxAlphaBlend and FOldAlphaBlend
      then
        begin
         SetWindowLong(Handle, GWL_EXSTYLE,
            GetWindowLong(Handle, GWL_EXSTYLE) and (not WS_EX_LAYERED));
        end;
      FOldAlphaBlend := PLB.ListBoxAlphaBlend;
      if (FOldAlphaBlendValue <> PLB.ListBoxAlphaBlendValue) and PLB.ListBoxAlphaBlend
      then
        begin
          if PLB.ListBoxAlphaBlendAnimation
          then
            begin
              SetAlphaBlendTransparent(Handle, 0);
              FOldAlphaBlendValue := 0;
            end
          else
            begin
              SetAlphaBlendTransparent(Handle, PLB.ListBoxAlphaBlendValue);
              FOldAlphaBlendValue := PLB.ListBoxAlphaBlendValue;
             end;
        end;
    end;
  //
  SetWindowPos(Handle, HWND_TOP, Origin.X, Origin.Y, 0, 0,
    SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
  Visible := True;
  if CheckW2KWXP and (PLB <> nil) and PLB.ListBoxAlphaBlendAnimation and PLB.ListBoxAlphaBlend
  then
    begin
      Application.ProcessMessages;
      I := 0;
      repeat
        Inc(i, 2);
        if i > PLB.ListBoxAlphaBlendValue then i := PLB.ListBoxAlphaBlendValue;
        SetAlphaBlendTransparent(Handle, i);
      until i >= PLB.ListBoxAlphaBlendValue;
    end;
end;

// ======================== TspSkinTrackEdit ========================== //
constructor TspSkinTrackEdit.Create(AOwner: TComponent);
begin
  inherited;
  FPopupKind := tbpRight;
  FTrackBarWidth := 0;
  FTrackBarSkinDataName := 'htrackbar';
  ButtonMode := True;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;
  StopCheck := True;
  Text := '0';
  StopCheck := False;
  Width := 120;
  Height := 20;
  FSkinDataName := 'buttonedit';
  OnButtonClick := ButtonClick;
  FPopupTrackBar := TspSkinPopupTrackBar.Create(Self);
  FPopupTrackBar.Visible := False;
  FPopupTrackBar.TrackEdit := Self;
  FPopupTrackBar.Parent := Self;
  FPopupTrackBar.OnChange := TrackBarChange;
  FTrackBarAlphaBlend := False;
  FTrackBarAlphaBlendAnimation := False;
  FTrackBarAlphaBlendValue := 0;
end;

destructor TspSkinTrackEdit.Destroy;
begin
  FPopupTrackBar.Free;
  inherited;
end;

function TspSkinTrackEdit.GetJumpWhenClick: Boolean;
begin
  Result := FPopupTrackBar.JumpWhenClick;
end;

procedure TspSkinTrackEdit.SetJumpWhenClick(Value: Boolean);
begin
  FPopupTrackBar.JumpWhenClick := Value;
end;

procedure TspSkinTrackEdit.WMMOUSEWHEEL;
begin
  if not FPopupTrackBar.Visible
  then
    begin
      if Message.WParam > 0
      then
        Value := Value - 1
      else
        Value := Value + 1;
    end
  else
    begin
      if Message.WParam > 0
      then
        FPopupTrackBar.Value := FPopupTrackBar.Value - 1
      else
        FPopupTrackBar.Value := FPopupTrackBar.Value + 1;
    end;
end;

procedure TspSkinTrackEdit.CMCancelMode(var Message: TCMCancelMode);
begin
 if (Message.Sender <> FPopupTrackBar)
 then
   CloseUp;
end;

procedure TspSkinTrackEdit.CloseUp;
begin
  if FPopupTrackbar.Visible
  then
    begin
      SetWindowPos(FPopupTrackBar.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
                   SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      FPopupTrackBar.Visible := False;
      if CheckW2KWXP and FTrackBarAlphaBlend
      then
        SetWindowLong(FPopupTrackBar.Handle, GWL_EXSTYLE,
                      GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
    end;  
end;

procedure TspSkinTrackEdit.DropDown;
var
  P: TPoint;
  X, Y, I: Integer;
begin
  with FPopupTrackBar do
  begin
    if FTrackBarWidth = 0
    then
      Width := Self.Width
    else
      Width := FTrackBarWidth;
    DefaultHeight := Self.Height;
    SkinDataName := FTrackBarSkinDataName;
    SkinData := Self.SkinData;
    MinValue := Self.MinValue;
    MaxValue := Self.MaxValue;
    Value := Self.Value;
  end;
  if (PopupKind = tbpRight) or (FPopupTrackBar.Width = Self.Width)
  then
    P := Parent.ClientToScreen(Point(Left, Top))
  else
    P := Parent.ClientToScreen(Point(Left + Width - FPopupTrackBar.Width, Top));

  Y := P.Y + Height;

  if P.X + FPopupTrackBar.Width > Screen.Width
  then
    P.X := P.X - ((P.X + FPopupTrackBar.Width) - Screen.Width)
  else
  if P.X < 0 then P.X := 0;

  if Y + FPopupTrackBar.Height > Screen.Height
  then
    Y := P.Y - FPopupTrackBar.Height;
  //
  SetWindowPos(FPopupTrackBar.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
  FPopupTrackBar.Visible := True;
  if FTrackBarAlphaBlendAnimation and FTrackBarAlphaBlend and CheckW2KWXP
  then
    begin
      Application.ProcessMessages;
      I := 0;
      repeat
        Inc(i, 1);
        if i > FTrackBarAlphaBlendValue then i := FTrackBarAlphaBlendValue;
        SetAlphaBlendTransparent(FPopupTrackBar.Handle, i);
      until i >= FTrackBarAlphaBlendValue;
    end;
end;

procedure TspSkinTrackEdit.ButtonClick(Sender: TObject);
begin
  SetFocus;
  if not FPopupTrackBar.Visible then DropDown else CloseUp;
end;

function TspSkinTrackEdit.CheckValue;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue)
  then
    begin
      if NewValue < FMinValue then
      Result := FMinValue
      else if NewValue > FMaxValue then
      Result := FMaxValue;
    end;
end;

procedure TspSkinTrackEdit.SetMinValue;
begin
  FMinValue := AValue;
end;

procedure TspSkinTrackEdit.SetMaxValue;
begin
  FMaxValue := AValue;
end;

function TspSkinTrackEdit.IsNumText;

function GetMinus: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos('-', S);
  if i > 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos('-', S) = 0;
    end;
end;

const
  EditChars = '01234567890-';
var
  i: Integer;
  S: String;
begin
  S := EditChars;
  Result := True;
  if (Text = '') or (Text = '-')
  then
    begin
      Result := False;
      Exit;
    end;

  for i := 1 to Length(Text) do
  begin
    if Pos(Text[i], S) = 0
    then
      begin
        Result := False;
        Break;
      end;
  end;

  Result := Result and GetMinus;
end;

procedure TspSkinTrackEdit.Change;
var
  NewValue, TmpValue: Integer;
begin
  if FromEdit then Exit;
  if not StopCheck and IsNumText(Text)
  then
    begin
      TmpValue := StrToInt(Text);
      NewValue := CheckValue(TmpValue);
      if NewValue <> FValue
      then
        begin
          FValue := NewValue;
         end;
      if NewValue <> TmpValue
      then
        begin
          FromEdit := True;
          Text := IntToStr(Round(NewValue));
          FromEdit := False;
        end;
    end;
  inherited;  
end;

procedure TspSkinTrackEdit.SetValue;
begin
  FValue := CheckValue(AValue);
  StopCheck := True;
  Text := IntToStr(Round(CheckValue(AValue)));
  StopCheck := False;
end;

procedure TspSkinTrackEdit.KeyPress(var Key: Char);
begin
  if Key = Char(VK_ESCAPE)
  then
    begin
      if FPopupTrackBar.Visible then CloseUp; 
    end
  else
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  inherited KeyPress(Key);
end;

function TspSkinTrackEdit.IsValidChar(Key: Char): Boolean;
begin
  Result := (Key in ['-', '0'..'9']) or
            ((Key < #32) and (Key <> Chr(VK_RETURN)));

  if (Key = '-') and (Pos('-', Text) <> 0)
  then
    Result := False;

  if ReadOnly and Result and ((Key >= #32) or
     (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE)))
  then
    Result := False;
end;

procedure TspSkinTrackEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp;
end;

procedure TspSkinTrackEdit.TrackBarChange(Sender: TObject);
begin
  if Value <> FPopupTrackBar.Value
  then
    Value := FPopupTrackBar.Value;
end;

constructor TspSkinPopupTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  SkinDataName := 'htrackbar'; 
end;

procedure TspSkinPopupTrackBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_;
  end;
end;

procedure TspSkinPopupTrackBar.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

constructor TspSkinTimeEdit.Create(AOwner: TComponent);
begin
   inherited;
   fShowMSec := false;
   EditMask := '!90:00:00;1; ';
   Text := '00:00:00';
   OnKeyPress := HandleOnKeyPress;
end;

procedure TspSkinTimeEdit.CheckSpace(var S: String);
var
  i: Integer;
begin
  for i := 0 to Length(S) do
  begin
    if S[i] = ' ' then S[i] := '0';
  end;
end;

procedure TspSkinTimeEdit.HandleOnKeyPress(Sender: TObject; var Key: Char);
var
  TimeStr: string;
  aHour, aMinute, aSecond, aMillisecond: Word;
  aHourSt, aMinuteSt, aSecondSt, aMillisecondSt: string;
begin
   if (Key <> #13) and (Key <> #8)
   then
   begin
   TimeStr := Text;
   if SelLength > 1 then SelLength := 1;
   if IsValidChar(Key)
   then
     begin
       Delete(TimeStr,SelStart + 1, 1);
       Insert(string(Key), TimeStr, SelStart + 1);
     end;
      try
         aHourSt := Copy(TimeStr, 1, 2);
         CheckSpace(aHourSt);
         aMinuteSt := Copy(TimeStr, 4, 2);
         CheckSpace(aMinuteSt);
         aSecondSt := Copy(TimeStr, 7, 2);
         CheckSpace(aSecondSt);
         if fShowMSec then begin
            aMillisecondSt := Copy(TimeStr, 10, 3);
         end else begin
            aMillisecondSt := '0';
         end;
         CheckSpace(aMillisecondSt);
         aHour := StrToInt(aHourSt);
         aMinute := StrToInt(aMinuteSt);
         aSecond := StrToInt(aSecondSt);
         aMillisecond := StrToInt(aMillisecondSt);
         if not IsValidTime(aHour, aMinute, aSecond, aMillisecond) then begin
            Key := #0;
         end;
      except
         Key := #0;
      end;
   end;
end;

procedure TspSkinTimeEdit.SetShowMilliseconds(const Value: Boolean);
begin
   if fShowMSec <> Value then begin
      fShowMSec := Value;
      if fShowMSec then begin
         EditMask := '!90:00:00.000;1; ';
         Text := '00:00:00.000';
      end else begin
         EditMask := '!90:00:00;1; ';
         Text := '00:00:00';
      end;
   end;
end;

procedure TspSkinTimeEdit.SetMilliseconds(const Value: integer);
var
   aHour, aMinute, aSecond, aMillisecond: integer;
   St: string;
begin
   aSecond := Value div 1000;
   aMillisecond := Value mod 1000;
   aMinute := aSecond div 60;
   aSecond := aSecond mod 60;
   aHour := aMinute div 60;
   aMinute := aMinute mod 60;

   St := Format('%2.2d:%2.2d:%2.2d.%3.3d', [aHour, aMinute, aSecond, aMillisecond]);
   try
      Text := St;
   except
      Text := '00:00:00.000';
   end;
end;

function TspSkinTimeEdit.GetMilliseconds: integer;
var
   TimeStr: string;
   aHour, aMinute, aSecond, aMillisecond: integer;
   aHourSt, aMinuteSt, aSecondSt, aMillisecondSt: string;
begin
   TimeStr := Text;
   try
      aHourSt := Copy(TimeStr, 1, 2);
      CheckSpace(aHourSt);
      aMinuteSt := Copy(TimeStr, 4, 2);
      CheckSpace(aMinuteSt);
      aSecondSt := Copy(TimeStr, 7, 2);
      CheckSpace(aSecondSt);
      aMillisecondSt := Copy(TimeStr, 10, 3);
      CheckSpace(aMillisecondSt);
      aHour := StrToInt(aHourSt);
      aMinute := StrToInt(aMinuteSt);
      aSecond := StrToInt(aSecondSt);
      aMillisecond := StrToInt(aMillisecondSt);
      Result := ((((aHour * 60) + aMinute) * 60) + aSecond) * 1000 + aMillisecond;
   except
      Result := 0;
   end;
end;

procedure TspSkinTimeEdit.SetTime(const Value: string);
var
   TimeStr: string;
   aHour, aMinute, aSecond, aMillisecond: integer;
   aHourSt, aMinuteSt, aSecondSt, aMillisecondSt: string;
begin

   TimeStr := Value;
   try
      aHourSt := Copy(TimeStr, 1, 2);
      CheckSpace(aHourSt);
      aMinuteSt := Copy(TimeStr, 4, 2);
      CheckSpace(aMinuteSt);
      aSecondSt := Copy(TimeStr, 7, 2);
      CheckSpace(aSecondSt);
      aHour := StrToInt(aHourSt);
      aMinute := StrToInt(aMinuteSt);
      aSecond := StrToInt(aSecondSt);

      if fShowMSec then begin
         aMillisecondSt := Copy(TimeStr, 10, 3);
         CheckSpace(aMillisecondSt);
         aMillisecond := StrToInt(aMillisecondSt);
         Text := Format('%2.2d:%2.2d:%2.2d.%3.3d', [aHour, aMinute, aSecond, aMillisecond]);
      end else begin
         Text := Format('%2.2d:%2.2d:%2.2d', [aHour, aMinute, aSecond]);
      end;
   except
      if fShowMSec then begin
         Text := '00:00:00.000';
      end else begin
         Text := '00:00:00';
      end;
   end;
end;

function TspSkinTimeEdit.GetTime: string;
begin
  Result := Text;
end;

function TspSkinTimeEdit.IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  Result := ((AHour < 24) and (AMinute < 60) and
             (ASecond < 60) and (AMilliSecond < 1000)) or
            ((AHour = 24) and (AMinute = 0) and
             (ASecond = 0) and (AMilliSecond = 0));
end;

function TspSkinTimeEdit.IsValidChar(Key: Char): Boolean;
begin
  Result := Key in ['0'..'9'];
end;

procedure TspSkinTimeEdit.DecodeTime(var Hour, Min, Sec, MSec: Word);
var
  TimeStr: string;
  aHourSt, aMinuteSt, aSecondSt, aMillisecondSt: string;
begin
  TimeStr := Text;
  aHourSt := Copy(TimeStr, 1, 2);
  CheckSpace(aHourSt);
  aMinuteSt := Copy(TimeStr, 4, 2);
  CheckSpace(aMinuteSt);
  aSecondSt := Copy(TimeStr, 7, 2);
  CheckSpace(aSecondSt);
  Hour := StrToInt(aHourSt);
  Min := StrToInt(aMinuteSt);
  Sec := StrToInt(aSecondSt);
  if fShowMSec
  then
    aMillisecondSt := Copy(TimeStr, 10, 3)
  else
    aMillisecondSt := '000';
  CheckSpace(aMillisecondSt);
  Msec := StrToInt(aMillisecondSt);
end;

procedure TspSkinTimeEdit.EncodeTime(Hour, Min, Sec, MSec: Word);
begin
  if not IsValidTime(Hour, Min, Sec, MSec) then Exit;
  try
    if fShowMSec
    then
      Text := Format('%2.2d:%2.2d:%2.2d.%3.3d', [Hour, Min, Sec, MSec])
    else
      Text := Format('%2.2d:%2.2d:%2.2d', [Hour, Min, Sec]);
  except
    if fShowMSec
    then
      Text := '00:00:00.000'
    else
      Text := '00:00:00';
  end;
end;


constructor TspSkinMemo2.Create;
begin
  inherited Create(AOwner);
  AutoSize := False;
  FIndex := -1;
  Font.Name := 'Arial';
  Font.Height := 14;
  FVScrollBar := nil;
  FHScrollBar := nil;
  FDown := False;
  FSkinDataName := 'memo';
  FDefaultFont := TFont.Create;
  FDefaultFont.OnChange := OnDefaultFontChange;
  FDefaultFont.Assign(Font);
  ScrollBars := ssBoth;
  FUseSkinFont := True;
  FSysPopupMenu := nil;
end;

procedure TspSkinMemo2.WMCONTEXTMENU;
var
  X, Y: Integer;
  P: TPoint;
begin
  if PopupMenu <> nil
  then
    inherited
  else
    begin
      CreateSysPopupMenu;
      X := Message.XPos;
      Y := Message.YPos;
      if (X < 0) or (Y < 0)
      then
        begin
          X := Width div 2;
          Y := Height div 2;
          P := Point(0, 0);
          P := ClientToScreen(P);
          X := X + P.X;
          Y := Y + P.Y;
        end;
      if FSysPopupMenu <> nil
      then
        FSysPopupMenu.Popup2(Self, X, Y)
    end;
end;

procedure TspSkinMemo2.WMAFTERDISPATCH;
begin
  if FSysPopupMenu <> nil
  then
    begin
      FSysPopupMenu.Free;
      FSysPopupMenu := nil;
    end;
end;

procedure TspSkinMemo2.DoUndo;
begin
  Undo;
end;

procedure TspSkinMemo2.DoCut;
begin
  CutToClipboard;
end;

procedure TspSkinMemo2.DoCopy;
begin
  CopyToClipboard;
end;

procedure TspSkinMemo2.DoPaste;
begin
  PasteFromClipboard;
end;

procedure TspSkinMemo2.DoDelete;
begin
  ClearSelection;
end;

procedure TspSkinMemo2.DoSelectAll;
begin
  SelectAll;
end;

procedure TspSkinMemo2.CreateSysPopupMenu;

function IsSelected: Boolean;
begin
  Result := GetSelLength > 0;
end;

function IsFullSelected: Boolean;
begin
  Result := GetSelText = Text;
end;

var
  Item: TMenuItem;
begin
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;

  FSysPopupMenu := TspSkinPopupMenu.Create(Self);
  FSysPopupMenu.ComponentForm := TForm(GetParentForm(Self));

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_UNDO')
    else
      Caption := SP_Edit_Undo;
    OnClick := DoUndo;
    Enabled := Self.CanUndo;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
   if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_CUT')
    else
      Caption := SP_Edit_Cut;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoCut;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
     if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_COPY')
    else
      Caption := SP_Edit_Copy;
    Enabled := IsSelected;
    OnClick := DoCopy;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_PASTE')
    else
      Caption := SP_Edit_Paste;
    Enabled := (ClipBoard.AsText <> '') and not ReadOnly;
    OnClick := DoPaste;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_DELETE')
    else
      Caption := SP_Edit_Delete;
    Enabled := IsSelected and not Self.ReadOnly;
    OnClick := DoDelete;
  end;
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  Item.Caption := '-';
  FSysPopupMenu.Items.Add(Item);

  Item := TMenuItem.Create(FSysPopupMenu);
  with Item do
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Caption := SkinData.ResourceStrData.GetResStr('EDIT_SELECTALL')
    else
      Caption := SP_Edit_SelectAll;
    Enabled := not IsFullSelected;
    OnClick := DoSelectAll;
  end;
  FSysPopupMenu.Items.Add(Item);
end;


procedure TspSkinMemo2.CMEnabledChanged;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
  if FIndex = -1 then Font.Assign(Value);
end;

procedure TspSkinMemo2.OnDefaultFontChange(Sender: TObject);
begin
  if FIndex = -1 then Font.Assign(FDefaultFont);
end;

procedure TspSkinMemo2.WMSize;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.Invalidate;
begin
  inherited;
end;

procedure TspSkinMemo2.Change;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMVSCROLL;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMHSCROLL;
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMLBUTTONDOWN;
begin
  inherited;
  FDown := True;
end;

procedure TspSkinMemo2.WMLBUTTONUP;
begin
  inherited;
  if FDown
  then
    begin
      UpDateScrollRange;
      FDown := False;
    end;  
end;

procedure TspSkinMemo2.WMMOUSEMOVE;
begin
  inherited;
  if FDown then UpDateScrollRange;
end;

procedure TspSkinMemo2.SetVScrollBar;
begin
  FVScrollBar := Value;
  FVScrollBar.Min := 0;
  FVScrollBar.Max := 0;
  FVScrollBar.Position := 0;
  if FVScrollBar <> nil then FVScrollBar.OnChange := OnVScrollBarChange;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.OnVScrollBarChange(Sender: TObject);
begin
  SendMessage(Handle, WM_VSCROLL,
    MakeWParam(SB_THUMBPOSITION, FVScrollBar.Position), 0);
  Invalidate;
end;

procedure TspSkinMemo2.SetHScrollBar;
begin
  FHScrollBar := Value;
  FHScrollBar.Min := 0;
  FHScrollBar.Max := 0;
  FHScrollBar.Position := 0;
  if FHScrollBar <> nil then FHScrollBar.OnChange := OnHScrollBarChange;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.OnHScrollBarChange(Sender: TObject);
begin
  SendMessage(Handle, WM_HSCROLL,
    MakeWParam(SB_THUMBPOSITION, FHScrollBar.Position), 0);
  Invalidate;
end;

procedure TspSkinMemo2.UpDateScrollRange;

function GetVisibleLines: Integer;
var
  R: TRect;
  C: TCanvas;
  DC: HDC;
  LineHeight: Integer;
begin
  C := TCanvas.Create;
  C.Font.Assign(Font);
  DC := GetDC(0);
  C.Handle := DC;
  R := GetClientRect;
  LineHeight := C.TextHeight('Wq');
  if LineHeight <> 0
  then
    Result := RectHeight(R) div LineHeight
  else
    Result := 1;
  ReleaseDC(0, DC);
  C.Free;
end;

var
  SMin, SMax, SPos, SPage: Integer;
begin
  if FVScrollBar <> nil
  then
  if not Enabled
  then
    FVScrollBar.Enabled := False
  else
  with FVScrollBar do
  begin
    SPage := GetVisibleLines;
    SPos := GetScrollPos(Self.Handle, SB_VERT);
    GetScrollRange(Self.Handle, SB_VERT, SMin, SMax);
    if SMax > SPage
    then
      begin
        SetRange(0, SMax, SPos, SPage + 1);
        if not Enabled then Enabled := True;
      end
    else
      begin
        SetRange(0, 0, 0, 0);
        if Enabled then Enabled := False;
      end;
  end;

  if FHScrollBar <> nil
  then
  if not Enabled
  then
    FHScrollBar.Enabled := False
  else
  with FHScrollBar do
  begin
    SPage := Width;
    SPos := GetScrollPos(Self.Handle, SB_HORZ);
    GetScrollRange(Self.Handle, SB_HORZ, SMin, SMax);
    if SMax > SPage
    then
      begin
        SetRange(0, SMax, SPos, SPage + 1);
        if not Enabled then Enabled := True;
      end
    else
      begin
        SetRange(0, 0, 0, 0);
        if Enabled then Enabled := False;
      end;
  end;
end;

procedure TspSkinMemo2.WMMove;
begin
  inherited;
end;

procedure TspSkinMemo2.WMCut(var Message: TMessage);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMPaste(var Message: TMessage);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMClear(var Message: TMessage);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMUndo(var Message: TMessage);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMSetText(var Message:TWMSetText);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMMOUSEWHEEL;
var
  LParam, WParam: Integer;
begin
  LParam := 0;
  if Message.WParam > 0
  then
    WParam := MakeWParam(SB_LINEUP, 0)
  else
    WParam := MakeWParam(SB_LINEDOWN, 0);
  SendMessage(Handle, WM_VSCROLL, WParam, LParam);
end;

procedure TspSkinMemo2.WMCHAR(var Message:TMessage);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMKeyDown(var Message: TWMKeyDown);
begin
  inherited;
  UpDateScrollRange;
end;

procedure TspSkinMemo2.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  inherited;
end;

procedure TspSkinMemo2.CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT);
begin
  inherited;
end;

procedure TspSkinMemo2.WMNCCALCSIZE;
begin
 
end;

procedure TspSkinMemo2.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    Style := Style and not WS_BORDER;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

destructor TspSkinMemo2.Destroy;
begin
  FDefaultFont.Free;
  if FSysPopupMenu <> nil then FSysPopupMenu.Free;
  inherited;
end;

procedure TspSkinMemo2.WMSETFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1)
  then
    begin
      Font.Color := ActiveFontColor;
      Color := ActiveBGColor;
    end;
end;

procedure TspSkinMemo2.WMKILLFOCUS;
begin
  inherited;
  if not FMouseIn and (FIndex <> -1)
  then
    begin
      Font.Color := FontColor;
      Color := BGColor;
    end;
end;

procedure TspSkinMemo2.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := ActiveFontColor;
      Color := ActiveBGColor;
    end;
end;

procedure TspSkinMemo2.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if not Focused and (FIndex <> -1)
  then
    begin
      Font.Color := FontColor;
      Color := BGColor;
    end;
end;

procedure TspSkinMemo2.GetSkinData;
begin
  if FSD = nil
  then
    begin
      FIndex := -1;
      Exit;
    end;

  if FSD.Empty
  then
    FIndex := -1
  else
    FIndex := FSD.GetControlIndex(FSkinDataName);

  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinMemoControl
    then
      with TspDataSkinMemoControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.ActiveFontColor := ActiveFontColor;
        Self.BGColor := BGColor;
        Self.ActiveBGColor := ActiveBGColor;
      end;
end;

procedure TspSkinMemo2.SetSkinData;
begin
  FSD := Value;
  if (FSD <> nil) then
  if not FSD.Empty and not (csDesigning in ComponentState)
  then
    ChangeSkinData;
end;

procedure TspSkinMemo2.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FVScrollBar)
  then FVScrollBar := nil;
  if (Operation = opRemove) and (AComponent = FHScrollBar)
  then FHScrollBar := nil;
end;

procedure TspSkinMemo2.ChangeSkinData;
begin
  GetSkinData;
  //
  if FIndex <> -1
  then
    begin
      if FUseSkinFont
      then
        begin
          Font.Name := FontName;
          Font.Style := FontStyle;
          Font.Height := FontHeight;
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end
      else
        begin
          Font.Assign(FDefaultFont);
          if Focused
          then
            Font.Color := ActiveFontColor
          else
            Font.Color := FontColor;
        end;
      Color := BGColor;
    end
  else
    Font.Assign(FDefaultFont);
  //
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    Font.Charset := SkinData.ResourceStrData.CharSet
  else
    Font.CharSet := TURKISH_CHARSET;// FDefaultFont.CharSet;
  //
  UpDateScrollRange;
  ReCreateWnd;
  if FVScrollBar <> nil then FVScrollBar.Align := FVScrollBar.Align;
end;

constructor TspSkinPasswordEdit.Create(AOwner: TComponent); 
begin
  inherited;
  Text := '';
  FMouseIn := False;
  SkinDataName := 'edit';
  Width := 121;
  DefaultHeight := 21;
  TabStop := True;
  Color := clWindow;
  FTextAlignment := taLeftJustify;
  FAutoSelect := True;
  FCharCase := ecNormal;
  FHideSelection := True;
  FMaxLength := 0;
  FReadOnly := False;
  FLMouseSelecting := False;
  FCaretPosition := 0;
  FSelStart := 0;
  FSelLength := 0;
  FFirstVisibleChar := 1;
  ControlStyle := ControlStyle + [csCaptureMouse] - [csSetCaption];
  Cursor := Cursor;
end;

destructor TspSkinPasswordEdit.Destroy;
begin
  inherited;
end;

procedure TspSkinPasswordEdit.PasteFromClipboard;
var
  Data: THandle;
  Insertion: WideString;
begin
  if ReadOnly then Exit;

  if Clipboard.HasFormat(CF_UNICODETEXT)
  then
    begin
      Data := Clipboard.GetAsHandle(CF_UNICODETEXT);
      try
        if Data <> 0
        then
          Insertion := PWideChar(GlobalLock(Data));
      finally
        if Data <> 0 then GlobalUnlock(Data);
      end;
    end
  else
    Insertion := Clipboard.AsText;

  InsertText(Insertion);
end;

procedure TspSkinPasswordEdit.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinEditControl
    then
      with TspDataSkinEditControl(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.SkinRect := SkinRect;
        Self.ActiveSkinRect := ActiveSkinRect;
        if IsNullRect(ActiveSkinRect)
        then
          Self.ActiveSkinRect := SkinRect;
        LOffset := LTPoint.X;
        ROffset := RectWidth(SkinRect) - RTPoint.X;
        CharColor := FontColor;
        CharDisabledColor := DisabledFontColor;
        CharActiveColor := ActiveFontColor;
      end;
end;

procedure TspSkinPasswordEdit.CreateControlSkinImage(B: TBitMap);
begin
  if FMouseIn or Focused
  then
    CreateHSkinImage(LOffset, ROffset, B, Picture, ActiveSkinRect, Width,
          RectHeight(ActiveSkinRect))
  else
    CreateHSkinImage(LOffset, ROffset, B, Picture, SkinRect, Width,
                           RectHeight(SkinRect));

                           
  if Focused or not HideSelection
  then
    with B.Canvas do
    begin
      Brush.Color := clHighlight;
      FillRect(GetSelRect);
    end;

  PaintText(B.Canvas);

  if Focused or not HideSelection
  then
    PaintSelectedText(B.Canvas);
end;

procedure TspSkinPasswordEdit.CreateControlDefaultImage(B: TBitMap);
var
  R: TRect;
begin
  R := Rect(0, 0, Width, Height);
  with B.Canvas do
  begin
    Brush.Color := clWindow;
    FillRect(R);
    Frame3D(B.Canvas, R, clBtnShadow, clBtnShadow, 1);
    Frame3D(B.Canvas, R, clBtnFace, clBtnFace, 1);
  end;

  if Focused or not HideSelection
  then
    with B.Canvas do
    begin
      Brush.Color := clHighlight;
      FillRect(GetSelRect);
    end;

  PaintText(B.Canvas);

  if Focused or not HideSelection
  then
    PaintSelectedText(B.Canvas);
end;

procedure TspSkinPasswordEdit.Loaded;
begin
  inherited;
end;

procedure TspSkinPasswordEdit.WMSETFOCUS(var Message: TWMSETFOCUS);
begin
  inherited;
  HAsFocus;
end;

procedure TspSkinPasswordEdit.WMKILLFOCUS(var Message: TWMKILLFOCUS);
begin
  inherited;
  KillFocus;
end;

procedure TspSkinPasswordEdit.HasFocus;
begin
  inherited;
  UpdateCarete;
  CaretPosition := 0;
  if AutoSelect then SelectAll;
end;

procedure TspSkinPasswordEdit.KillFocus;
begin
  inherited;
  DestroyCaret;
  Invalidate;
end;

function TspSkinPasswordEdit.GetCharX(a: integer): integer;
var
  WholeTextWidth : integer;
  EditRectWidth : integer;
begin
  Result := GetEditRect.Left;
  WholeTextWidth := Length(Text) * GetPasswordCharWidth;
  if a > 0 then
  begin
    if a <= Length(Text)
    then
      Result := Result + (a - FFirstVisibleChar + 1) * GetPasswordCharWidth
    else
      Result := Result + (Length(Text) - FFirstVisibleChar + 1) * GetPasswordCharWidth;
  end;
  EditRectWidth := GetEditRect.Right - GetEditRect.Left;
  if WholeTextWidth < EditRectWidth then
    case TextAlignment of
      taRightJustify : Result := Result + (EditRectWidth - WholeTextWidth);
      taCenter : Result := Result + ((EditRectWidth - WholeTextWidth) div 2);
    end;
end;

function TspSkinPasswordEdit.GetCoordinatePosition(x: integer): integer;
var
  TmpX,
  WholeTextWidth,
  EditRectWidth : integer;
begin
  Result := FFirstVisibleChar - 1;
  if Length(Text) = 0 then  Exit;
  WholeTextWidth := Length(Text) * GetPasswordCharWidth;

  EditRectWidth := GetEditRect.Right - GetEditRect.Left;
  TmpX := x;

  if WholeTextWidth < EditRectWidth
  then
    case TextAlignment of
      taRightJustify : TmpX := x - (EditRectWidth - WholeTextWidth);
      taCenter : TmpX := x - ((EditRectWidth - WholeTextWidth) div 2);
    end;

  Result := Result + (TmpX - GetEditRect.Left) div GetPasswordCharWidth;
  if Result < 0
  then
    Result := 0
  else
    if Result > Length(Text)
    then
      Result := Length(Text);
end;

function TspSkinPasswordEdit.GetEditRect: TRect;
begin
  with Result do
  begin
    if FIndex = -1
    then
      Result := Rect(2, 2, Width - 2, Height - 2)
    else
      Result := NewClRect;
  end;
end;

function TspSkinPasswordEdit.GetAlignmentFlags: integer;
begin
  case FTextAlignment of
    taCenter: Result := DT_CENTER;
    taRightJustify: Result := DT_RIGHT;
  else
    Result := DT_LEFT;
  end;
end;

procedure TspSkinPasswordEdit.KeyDown(var Key: word; Shift: TShiftState);
var
  TmpS: String;
  OldCaretPosition: integer;
begin
  inherited KeyDown(Key, Shift);
  OldCaretPosition := CaretPosition;
  case Key of

    Ord('v'), Ord('V'):
      if Shift = [ssCtrl] then PasteFromClipboard;

    VK_INSERT:
      if Shift = [ssShift] then PasteFromClipboard;

    VK_END: CaretPosition := Length(Text);

    VK_HOME: CaretPosition := 0;

    VK_LEFT:
      if ssCtrl in Shift then
        CaretPosition := GetPrivWordBeging(CaretPosition)
      else
        CaretPosition := CaretPosition - 1;

    VK_RIGHT:
      if ssCtrl in Shift then
        CaretPosition := GetNextWordBeging(CaretPosition)
      else
        CaretPosition := CaretPosition + 1;

    VK_DELETE, 8:
      if not ReadOnly then
      begin
        if SelLength <> 0 then
        begin
          ClearSelection;
        end
        else
        begin
          TmpS := Text;
          if TmpS <> '' then
            if Key = VK_DELETE then
            begin
              Delete(TmpS, CaretPosition + 1, 1);
            end
            else
            begin
              Delete(TmpS, CaretPosition, 1);
              CaretPosition := CaretPosition - 1;
            end;
          Text := TmpS;
        end;
      end;
  end;

  if Key in [VK_END, VK_HOME, VK_LEFT, VK_RIGHT] then
  begin
    if ssShift in Shift then
    begin
      if SelLength = 0 then
        FSelStart := OldCaretPosition;
      FSelStart := CaretPosition;
      FSelLength := FSelLength - (CaretPosition - OldCaretPosition);
    end
    else
      FSelLength := 0;
    Invalidate;
  end;
  UpdateCaretePosition;
  
end;

procedure TspSkinPasswordEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Ord(Key) >= 32) and not ReadOnly then InsertChar(Key);
end;

procedure TspSkinPasswordEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  x, y: integer);
begin
  inherited;
  if Button = mbLeft then FLMouseSelecting := true;
  SetFocus;
  if Button = mbLeft
  then
    begin
      CaretPosition := GetCoordinatePosition(x);
      SelLength := 0;
    end;
end;

procedure TspSkinPasswordEdit.PaintText;
var
  TmpRect: TRect;
  CurChar: integer;
  LPWCharWidth: integer;
begin
  TmpRect := GetEditRect;
  LPWCharWidth := GetPasswordCharWidth;
  for CurChar := 0 to Length(Text) - FFirstVisibleChar + 1 - 1 do
    DrawPasswordChar(Rect(CurChar * LPWCharWidth + GetCharX(0), TmpRect.Top,
      (CurChar + 1) * LPWCharWidth + GetCharX(0), TmpRect.Bottom), False, Cnv);
end;

procedure TspSkinPasswordEdit.UpdateFirstVisibleChar;
var
  LEditRect: TRect;
begin
  if FFirstVisibleChar >= (FCaretPosition + 1)
  then
    begin
      FFirstVisibleChar := FCaretPosition;
      if FFirstVisibleChar < 1 then FFirstVisibleChar := 1;
    end
  else
    begin
      LEditRect := GetEditRect;
      while ((FCaretPosition - FFirstVisibleChar + 1) * GetPasswordCharWidth >
        LEditRect.Right - LEditRect.Left) and (FFirstVisibleChar < Length(Text)) do
        Inc(FFirstVisibleChar)
      end;
  Invalidate;
end;

procedure TspSkinPasswordEdit.MouseMove(Shift: TShiftState; x, y: integer);
var
  OldCaretPosition: integer;
  TmpNewPosition : integer;
begin
  inherited;
  if FLMouseSelecting then
  begin
    TmpNewPosition := GetCoordinatePosition(x);
    OldCaretPosition := CaretPosition;
    if (x > GetEditRect.Right) then
      CaretPosition := TmpNewPosition +1
    else
      CaretPosition := TmpNewPosition;
    if SelLength = 0 then
      FSelStart := OldCaretPosition;
    FSelStart := CaretPosition;
    FSelLength := FSelLength - (CaretPosition - OldCaretPosition);
  end;
end;

procedure TspSkinPasswordEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  x, y: integer);
begin
  inherited;
  FLMouseSelecting := false;
end;

procedure TspSkinPasswordEdit.PaintSelectedText;
var
  TmpRect: TRect;
  CurChar: integer;
  LPWCharWidth: integer;
begin
  TmpRect := GetSelRect;

  LPWCharWidth := GetPasswordCharWidth;
  for CurChar := 0 to Length(GetVisibleSelText) - 1 do
      DrawPasswordChar(Rect(CurChar * LPWCharWidth + TmpRect.Left,
       TmpRect.Top,
       (CurChar + 1) * LPWCharWidth + TmpRect.Left,
       TmpRect.Bottom),
       true, Cnv);
end;

function TspSkinPasswordEdit.GetVisibleSelText: String;
begin
  if SelStart + 1 >= FFirstVisibleChar then
    Result := SelText
  else
    Result := Copy(SelText, FFirstVisibleChar - SelStart, Length(SelText) - (FFirstVisibleChar - SelStart) + 1);
end;

function TspSkinPasswordEdit.GetNextWordBeging(StartPosition: integer): integer;
var
  SpaceFound,
    WordFound: boolean;
begin
  Result := StartPosition;
  SpaceFound := false;
  WordFound := false;
  while (Result + 2 <= Length(Text)) and
    ((not ((Text[Result + 1] <> ' ') and SpaceFound))
    or not WordFound) do
  begin
    if Text[Result + 1] = ' ' then
      SpaceFound := true;
    if Text[Result + 1] <> ' ' then begin
      WordFound := true;
      SpaceFound := false;
    end;

    Result := Result + 1;
  end;
  if not SpaceFound then
    Result := Result + 1;
end;

function TspSkinPasswordEdit.GetPrivWordBeging(StartPosition: integer): integer;
var
  WordFound: boolean;
begin
  Result := StartPosition;
  WordFound := false;
  while (Result > 0) and
    ((Text[Result] <> ' ') or not WordFound) do
  begin
    if Text[Result] <> ' ' then
      WordFound := true;
    Result := Result - 1;
  end;
end;

procedure TspSkinPasswordEdit.ClearSelection;
var
  TmpS: String;
begin
  if ReadOnly then Exit;
  TmpS := Text;
  Delete(TmpS, SelStart + 1, SelLength);
  Text := TmpS;
  CaretPosition := SelStart;
  SelLength := 0;
end;

procedure TspSkinPasswordEdit.SelectAll;
begin
  SetCaretPosition(Length(Text));
  SelStart := 0;
  SelLength := Length(Text);
  Invalidate;
end;

procedure TspSkinPasswordEdit.DrawPasswordChar(SymbolRect: TRect; Selected: boolean; Cnv: TCanvas);
var
  R: TRect;
  C: TColor;
begin

  if not Enabled
  then
    begin
      if FIndex = -1
      then C := clGrayText
      else C := CharDisabledColor; 
    end
  else
  if Selected
  then
    C := clHighlightText
  else
    if FIndex = -1
    then
      C := clWindowText
    else
      begin
        if FMouseIn or Focused
        then
          C := CharActiveColor
        else
          C := CharColor;
      end;
  R := SymbolRect;

  InflateRect(R, -2, - (RectHeight(R) - RectWidth(R)) div 2 - 2);
  with Cnv do
  case FPasswordKind of
    pkRect:
      begin
        Brush.Color := C;
        FillRect(R);
      end;
    pkRoundRect:
      begin
        Brush.Color := C;
        Pen.Color := C;
        RoundRect(R.Left, R.Top, R.Right, R.Bottom, RectWidth(R) div 2, Font.Color);
      end;
    pkTriangle:
      begin
        R := Rect(0, 0, RectWidth(R), RectWidth(R));
        if not Odd(RectWidth(R)) then R.Right := R.Right + 1;
        RectToCenter(R, SymbolRect);
        Pen.Color := C;
        Brush.Color := C;
        Polygon([
          Point(R.Left + RectWidth(R) div 2 + 1, R.Top),
          Point(R.Right, R.Bottom),
          Point(R.Left, R.Bottom)]);
      end;
    end;
end;

procedure TspSkinPasswordEdit.SelectWord;
begin
  SelStart := GetPrivWordBeging(CaretPosition);
  SelLength := GetNextWordBeging(SelStart) - SelStart;
  CaretPosition := SelStart + SelLength;
end;

procedure TspSkinPasswordEdit.UpdateCarete;
begin
  GetSkinData;
  if FIndex = -1
  then
    CreateCaret(Handle, 0, 0, Height - 4)
  else
    CreateCaret(Handle, 0, 0, RectHeight(NewClRect));
  CaretPosition := FCaretPosition;
  ShowCaret;
end;

procedure TspSkinPasswordEdit.HideCaret;
begin
  Windows.HideCaret(Handle);
end;

procedure TspSkinPasswordEdit.ShowCaret;
begin
  Windows.ShowCaret(Handle);
end;

function TspSkinPasswordEdit.GetPasswordCharWidth: integer;
begin
  Result := RectHeight(GetEditRect) div 2 + 3;
end;

procedure TspSkinPasswordEdit.Change;
begin
  inherited Changed;
  if Enabled and HandleAllocated then SetCaretPosition(CaretPosition);
  if Assigned(FOnChange) then  FOnChange(Self);
end;

procedure TspSkinPasswordEdit.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TspSkinPasswordEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  inherited;
  FLMouseSelecting := false;
  SelectWord;
end;

procedure TspSkinPasswordEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Font.Assign(Font);
  UpdateCarete;
end;

function TspSkinPasswordEdit.GetText: String;
begin
  Result := FText;
end;

procedure TspSkinPasswordEdit.SetText(const Value: String);
var
  TmpS: String;
  LOldText: String;
begin
  if not ValidText(Value) then
    Exit;

  TmpS := Value;
  LOldText := Text;

  if (Value <> '') and (CharCase <> ecNormal) then
    case CharCase of
      ecUpperCase: FText := AnsiUpperCase(TmpS);
      ecLowerCase: FText := AnsiLowerCase(TmpS);
    end
  else
    FText := TmpS;

  Invalidate;

  if Text <> LOldText then
    Change;
end;

procedure TspSkinPasswordEdit.SetCaretPosition(const Value: integer);
begin
  if Value < 0 then
    FCaretPosition := 0
  else
    if Value > Length(Text) then
      FCaretPosition := Length(Text)
    else
      FCaretPosition := Value;

  UpdateFirstVisibleChar;

  if SelLength <= 0 then
    FSelStart := Value;

  if Focused then
    SetCaretPos(GetCharX(FCaretPosition), GetEditRect.Top);
end;

procedure TspSkinPasswordEdit.SetSelLength(const Value: integer);
begin
  if FSelLength <> Value then
  begin
    FSelLength := Value;
    Invalidate;
  end;
end;

procedure TspSkinPasswordEdit.SetSelStart(const Value: integer);
begin
  if FSelStart <> Value then
  begin
    SelLength := 0;
    FSelStart := Value;
    CaretPosition := FSelStart;
    Invalidate;
  end;
end;

procedure TspSkinPasswordEdit.SetAutoSelect(const Value: boolean);
begin
  if FAutoSelect <> Value then
    FAutoSelect := Value;
end;

function TspSkinPasswordEdit.GetSelStart: integer;
begin
  if FSelLength > 0 then
    Result := FSelStart
  else
    if FSelLength < 0 then
      Result := FSelStart + FSelLength
    else
      Result := CaretPosition;
end;

function TspSkinPasswordEdit.GetSelRect: TRect;
begin
  Result := GetEditRect;
  Result.Left := GetCharX(SelStart);
  Result.Right := GetCharX(SelStart + SelLength);
  IntersectRect(Result, Result, GetEditRect);
end;

function TspSkinPasswordEdit.GetSelLength: integer;
begin
  Result := Abs(FSelLength);
end;

function TspSkinPasswordEdit.GetSelText: String;
begin
  Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TspSkinPasswordEdit.SetCharCase(const Value: TEditCharCase);
var
  TmpS: String;
begin
  if FCharCase <> Value then
  begin
    FCharCase := Value;
    if Text <> '' then
    begin
      TmpS := Text;
      case Value of
        ecUpperCase: Text := AnsiUpperCase(TmpS);
        ecLowerCase: Text := AnsiLowerCase(TmpS);
      end;
    end;
  end;
end;

procedure TspSkinPasswordEdit.SetHideSelection(const Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    Invalidate;
  end;
end;

procedure TspSkinPasswordEdit.SetMaxLength(const Value: Integer);
begin
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
  end;
end;

procedure TspSkinPasswordEdit.SetCursor(const Value: TCursor);
begin
  if Value = crDefault then
    inherited Cursor := crIBeam
  else
    inherited Cursor := Value;
end;

function TspSkinPasswordEdit.ValidText(NewText: String): boolean;
begin
  Result := true;
end;

procedure TspSkinPasswordEdit.SetTextAlignment(const Value: TAlignment);
begin
  if FTextAlignment <> Value then begin
    FTextAlignment := Value;
    Invalidate;
  end;
end;

procedure TspSkinPasswordEdit.UpdateCaretePosition;
begin
  SetCaretPosition(CaretPosition);
end;

procedure TspSkinPasswordEdit.InsertText(AText: String);
var
  TmpS: String;
begin
  if ReadOnly then Exit;

  TmpS := Text;
  Delete(TmpS, SelStart + 1, SelLength);
  Insert(AText, TmpS, SelStart + 1);
  if (MaxLength <= 0) or (Length(TmpS) <= MaxLength) then
  begin
    Text := TmpS;
    CaretPosition := SelStart + Length(AText);
  end;
  SelLength := 0;
end;

procedure TspSkinPasswordEdit.InsertChar(Ch: Char);
begin
  if ReadOnly then Exit;
  InsertText(Ch);
end;

procedure TspSkinPasswordEdit.InsertAfter(Position: integer; S: String;
  Selected: boolean);
var
  TmpS : String;
  Insertion : String;
begin
  TmpS := Text;
  Insertion := S;
  if MaxLength > 0 then
    Insertion := Copy(Insertion, 1, MaxLength - Length(TmpS));
  Insert(Insertion, TmpS, Position+1);
  Text := TmpS;
  if Selected then begin
    SelStart := Position;
    SelLength := Length(Insertion);
    CaretPosition := SelStart + SelLength;
  end;
end;

procedure TspSkinPasswordEdit.DeleteFrom(Position, Length: integer; MoveCaret : boolean);
var
  TmpS: String;
begin
  TmpS := Text;
  Delete(TmpS,Position,Length);
  Text := TmpS;
  if MoveCaret
  then
    begin
      SelLength := 0;
      SelStart := Position-1;
    end;
end;

procedure TspSkinPasswordEdit.SetPasswordKind(const Value: TspPasswordKind);
begin
  if FPasswordKind <> Value
  then
    begin
      FPasswordKind := Value;
      Invalidate;
    end;
end;

procedure TspSkinPasswordEdit.CMTextChanged(var Msg: TMessage);
begin
  inherited;
  FText := inherited Text;
  SelLength := 0;
  Invalidate;
end;

procedure TspSkinPasswordEdit.Clear;
begin
  Text := '';
end;

procedure TspSkinPasswordEdit.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if HandleAllocated then Invalidate;
end;

procedure TspSkinPasswordEdit.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
  if (not Focused) then Invalidate;
end;

procedure TspSkinPasswordEdit.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if not Focused then Invalidate;
end;

// TspSkinNumericEdit

constructor TspSkinNumericEdit.Create(AOwner: TComponent);
begin
  inherited;
  FMinValue := 0;
  FMaxValue := 0;
  FValue := 0;
  StopCheck := True;
  FromEdit := False;
  Text := '0';
  StopCheck := False;
  Width := 120;
  Height := 20;
  FDecimal := 2;
  FSkinDataName := 'edit';
end;

destructor TspSkinNumericEdit.Destroy;
begin
  inherited;
end;

procedure TspSkinNumericEdit.SetValueType(NewType: TspValueType);
begin
  if FValueType <> NewType
  then
    begin
      FValueType := NewType;
    end;
end;

procedure TspSkinNumericEdit.SetDecimal(NewValue: Byte);
begin
  if FDecimal <> NewValue then begin
    FDecimal := NewValue;
  end;
end;

function TspSkinNumericEdit.CheckValue;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue)
  then
    begin
      if NewValue < FMinValue then
      Result := FMinValue
      else if NewValue > FMaxValue then
      Result := FMaxValue;
    end;
end;

procedure TspSkinNumericEdit.SetMinValue;
begin
  FMinValue := AValue;
end;

procedure TspSkinNumericEdit.SetMaxValue;
begin
  FMaxValue := AValue;
end;

function TspSkinNumericEdit.IsNumText;

function GetMinus: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos('-', S);
  if i > 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos('-', S) = 0;
    end;
end;

function GetP: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos(DecimalSeparator, S);
  if i = 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos(DecimalSeparator, S) = 0;
    end;
end;

const
  EditChars = '01234567890-';
var
  i: Integer;
  S: String;
begin
  S := EditChars;
  Result := True;
  if ValueType = vtFloat
  then
    S := S + DecimalSeparator;
  if (Text = '') or (Text = '-')
  then
    begin
      Result := False;
      Exit;
    end;

  for i := 1 to Length(Text) do
  begin
    if Pos(Text[i], S) = 0
    then
      begin
        Result := False;
        Break;
      end;
  end;

  Result := Result and GetMinus;

  if ValueType = vtFloat
  then
    Result := Result and GetP;

end;

procedure TspSkinNumericEdit.Change;
var
  NewValue, TmpValue: Double;
begin
  if FromEdit then Exit;
  if not StopCheck and IsNumText(Text)
  then
    begin
      if ValueType = vtFloat
      then TmpValue := StrToFloat(Text)
      else TmpValue := StrToInt(Text);
      NewValue := CheckValue(TmpValue);
      if NewValue <> FValue
      then
        begin
          FValue := NewValue;
        end;
      if NewValue <> TmpValue 
      then
        begin
          FromEdit := True;
          if ValueType = vtFloat
          then Text := FloatToStrF(NewValue, ffFixed, 15, FDecimal)
          else Text := IntToStr(Round(FValue));
          FromEdit := False;
        end;
    end;
  inherited;   
end;

procedure TspSkinNumericEdit.SetValue;
begin
  FValue := CheckValue(AValue);
  StopCheck := True;
  if ValueType = vtFloat
  then
    Text := FloatToStrF(CheckValue(AValue), ffFixed, 15, FDecimal)
  else
    Text := IntToStr(Round(CheckValue(AValue)));
  StopCheck := False;
end;

procedure TspSkinNumericEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key)
  then
    begin
      Key := #0;
      MessageBeep(0)
    end;
  inherited KeyPress(Key);
end;

function TspSkinNumericEdit.IsValidChar(Key: Char): Boolean;
begin
  if ValueType = vtFloat 
  then
    Result := (Key in [DecimalSeparator, '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)))
  else
    Result := (Key in ['-', '0'..'9']) or
     ((Key < #32) and (Key <> Chr(VK_RETURN)));

  
 if (Key = DecimalSeparator) and (Pos(DecimalSeparator, Text) <> 0)
  then
    Result := False
  else
  if (Key = '-') and (Pos('-', Text) <> 0)
  then
    Result := False;

  if ReadOnly and Result and ((Key >= #32) or
     (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE)))
  then
    Result := False;
end;

// TspSkinCheckComboBox

constructor TspPopupCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable,
    csAcceptsControls];
  Ctl3D := False;
  ParentCtl3D := False;
  Visible := False;
  FOldAlphaBlend := False;
  FOldAlphaBlendValue := 0;
end;

procedure TspPopupCheckListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP or WS_CLIPCHILDREN;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if CheckWXP then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW_;
  end;
end;

procedure TspPopupCheckListBox.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TspPopupCheckListBox.Hide;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  Visible := False;
end;

procedure TspPopupCheckListBox.Show(Origin: TPoint);
var
  PLB: TspSkinCustomComboBox;
  I: Integer;
begin
  PLB := nil;
  //
  if CheckW2KWXP and (Owner is TspSkinCustomComboBox)
  then
    begin
      PLB := TspSkinCustomComboBox(Owner);
      if PLB.ListBoxAlphaBlend and not FOldAlphaBlend
      then
        begin
          SetWindowLong(Handle, GWL_EXSTYLE,
                        GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
        end
      else
      if not PLB.AlphaBlend and FOldAlphaBlend
      then
        begin
         SetWindowLong(Handle, GWL_EXSTYLE,
            GetWindowLong(Handle, GWL_EXSTYLE) and (not WS_EX_LAYERED));
        end;
      FOldAlphaBlend := PLB.AlphaBlend;
      if (FOldAlphaBlendValue <> PLB.AlphaBlendValue) and PLB.AlphaBlend
      then
        begin
          if PLB.ListBoxAlphaBlendAnimation
          then
            begin
              SetAlphaBlendTransparent(Handle, 0);
              FOldAlphaBlendValue := 0;
            end
          else
            begin
              SetAlphaBlendTransparent(Handle, PLB.AlphaBlendValue);
              FOldAlphaBlendValue := PLB.AlphaBlendValue;
             end;
        end;
    end;
  //
  SetWindowPos(Handle, HWND_TOP, Origin.X, Origin.Y, 0, 0,
    SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
  Visible := True;
  if CheckW2KWXP and (PLB <> nil) and PLB.ListBoxAlphaBlendAnimation and PLB.ListBoxAlphaBlend
  then
    begin
      Application.ProcessMessages;
      I := 0;
      repeat
        Inc(i, 2);
        if i > PLB.AlphaBlendValue then i := PLB.AlphaBlendValue;
        SetAlphaBlendTransparent(Handle, i);
      until i >= PLB.FAlphaBlendValue;
    end;
end;

// checkcombobox

constructor TspSkinCustomCheckComboBox.Create;
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csReplicatable, csOpaque, csDoubleClicks, csAcceptsControls];
  FAlphaBlendAnimation := False;
  FAlphaBlend := False;
  TabStop := True;
  Font.Name := 'Arial';
  Font.Color := clWindowText;
  Font.Style := [];
  Font.Height := 14;
  Width := 120;
  Height := 20;
  FOnListBoxDrawItem := nil;
  FListBox := TspPopupCheckListBox.Create(Self);
  FListBox.Visible := False;
  FlistBox.Parent := Self;
  FListBox.ListBox.TabStop := False;
  FListBox.ListBox.OnMouseMove := ListBoxMouseMove;
  FListBoxWindowProc := FlistBox.ListBox.WindowProc;
  FlistBox.ListBox.WindowProc := ListBoxWindowProcHook;
  FLBDown := False;
  FDropDownCount := 8;
  CalcRects;
  FSkinDataName := 'combobox';
end;

destructor TspSkinCustomCheckComboBox.Destroy;
begin
  FlistBox.Free;
  FlistBox := nil;
  inherited;
end;

procedure TspSkinCustomCheckComboBox.CheckText;
var
  i: Integer;
  S: String;
begin
  if Items.Count = 0
  then
    Text := ''
  else
    begin
      S := '';
      for i := 0 to Items.Count - 1 do
      begin
        if Checked[I] then
          if S = '' then S := Items[I] else S := S + ',' + Items[I];
      end;
      Text := S;
    end;
end;


procedure TspSkinCustomCheckComboBox.SetChecked;
begin
  FListBox.Checked[Index] := Checked;
  CheckText;
  RePaint;
end;

function TspSkinCustomCheckComboBox.GetChecked;
begin
  Result := FListBox.Checked[Index];
end;

procedure TspSkinCustomCheckComboBox.CMEnabledChanged;
begin
  inherited;
  RePaint;
  Change;
end;

function TspSkinCustomCheckComboBox.GetListBoxUseSkinItemHeight: Boolean;
begin
  Result := FListBox.UseSkinItemHeight;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxUseSkinItemHeight(Value: Boolean);
begin
  FListBox.UseSkinItemHeight := Value;
end;

function TspSkinCustomCheckComboBox.GetListBoxUseSkinFont: Boolean;
begin
  Result := FListBox.UseSkinFont;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxUseSkinFont(Value: Boolean);
begin
  FListBox.UseSkinFont := Value;
end;

procedure TspSkinCustomCheckComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

function TspSkinCustomCheckComboBox.GetImages: TCustomImageList;
begin
  if FListBox <> nil
  then
    Result := FListBox.Images
  else
    Result := nil;
end;

function TspSkinCustomCheckComboBox.GetImageIndex: Integer;
begin
  Result := FListBox.ImageIndex;
end;

procedure TspSkinCustomCheckComboBox.SetImages(Value: TCustomImageList);
begin
  FListBox.Images := Value;
  RePaint;
end;

procedure TspSkinCustomCheckComboBox.SetImageIndex(Value: Integer);
begin
  FListBox.ImageIndex := Value;
  RePaint;
end;

procedure TspSkinCustomCheckComboBox.CMCancelMode;
begin
  inherited;
  if (Message.Sender <> Self) and
     (Message.Sender <> Self.FListBox) and
     (Message.Sender <> Self.FListBox.ScrollBar) and
     (Message.Sender <> Self.FListBox.ListBox)
  then
    CloseUp(False);
end;

procedure TspSkinCustomCheckComboBox.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinCustomCheckComboBox.GetListBoxDefaultFont;
begin
  Result := FListBox.DefaultFont;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxDefaultFont;
begin
  FListBox.DefaultFont.Assign(Value);
end;

function TspSkinCustomCheckComboBox.GetListBoxDefaultCaptionFont;
begin
  Result := FListBox.DefaultCaptionFont;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxDefaultCaptionFont;
begin
  FListBox.DefaultCaptionFont.Assign(Value);
end;

function TspSkinCustomCheckComboBox.GetListBoxDefaultItemHeight;
begin
  Result := FListBox.DefaultItemHeight;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxDefaultItemHeight;
begin
  FListBox.DefaultItemHeight := Value;
end;

function TspSkinCustomCheckComboBox.GetListBoxCaptionAlignment;
begin
  Result := FListBox.Alignment;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxCaptionAlignment;
begin
  FListBox.Alignment := Value;
end;

procedure TspSkinCustomCheckComboBox.DefaultFontChange;
begin
  Font.Assign(FDefaultFont);
end;

procedure TspSkinCustomCheckComboBox.SetListBoxCaption;
begin
  FListBox.Caption := Value;
end;

function  TspSkinCustomCheckComboBox.GetListBoxCaption;
begin
  Result := FListBox.Caption;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxCaptionMode;
begin
  FListBox.CaptionMode := Value;
end;

function  TspSkinCustomCheckComboBox.GetListBoxCaptionMode;
begin
  Result := FListBox.CaptionMode;
end;

function TspSkinCustomCheckComboBox.GetSorted: Boolean;
begin
  Result := FListBox.Sorted;
end;

procedure TspSkinCustomCheckComboBox.SetSorted(Value: Boolean);
begin
  FListBox.Sorted := Value;
end;

procedure TspSkinCustomCheckComboBox.SetListBoxDrawItem;
begin
  FOnListboxDrawItem := Value;
  FListBox.OnDrawItem := FOnListboxDrawItem;
end;

procedure TspSkinCustomCheckComboBox.ListBoxDrawItem(Cnvs: TCanvas; Index: Integer;
            ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
begin
  if Assigned(FOnListBoxDrawItem)
  then FOnListBoxDrawItem(Cnvs, Index, ItemWidth, ItemHeight, TextRect, State);
end;

procedure TspSkinCustomCheckComboBox.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  case Msg.CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:  Msg.Result := 1;
  end;
end;

procedure TspSkinCustomCheckComboBox.KeyDown;
var
  I: Integer;
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_SPACE:
      begin
        Checked[FListBox.ItemIndex] := not Checked[FListBox.ItemIndex];
        Change;
        if Assigned(OnClick) then OnClick(Self);
      end;
    VK_UP, VK_LEFT:
      if ssAlt in Shift
      then
        begin
          if FListBox.Visible then CloseUp(False);
        end
      else
        EditUp1(True);
    VK_DOWN, VK_RIGHT:
      if ssAlt in Shift
      then
        begin
          if not FListBox.Visible then DropDown;
        end
      else
        EditDown1(True);
    VK_NEXT: EditPageDown1(True);
    VK_PRIOR: EditPageUp1(True);
    VK_ESCAPE: if FListBox.Visible then CloseUp(False);
    VK_RETURN: if FListBox.Visible then CloseUp(True);
  end;
end;

procedure TspSkinCustomCheckComboBox.WMMOUSEWHEEL;
begin
  if Message.WParam > 0
  then
    EditUp1(not FListBox.Visible)
  else
    EditDown1(not FListBox.Visible);
end;

procedure TspSkinCustomCheckComboBox.WMSETFOCUS;
begin
  inherited;
  RePaint;
end;

procedure TspSkinCustomCheckComboBox.WMKILLFOCUS;
begin
  inherited;
  if FListBox.Visible then CloseUp(False);
  RePaint;
end;

procedure TspSkinCustomCheckComboBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinComboBox
    then
      with TspDataSkinComboBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.SItemRect := SItemRect;
        Self.FocusItemRect := FocusItemRect;
        if isNullRect(FocusItemRect)
        then
          Self.FocusItemRect := SItemRect;
        Self.ItemLeftOffset := ItemLeftOffset;
        Self.ItemRightOffset := ItemRightOffset;
        Self.ItemTextRect := ItemTextRect;

        Self.FontName := FontName;
        Self.FontStyle := FontStyle;
        Self.FontHeight := FontHeight;
        Self.FontColor := FontColor;
        Self.FocusFontColor := FocusFontColor;

        Self.ButtonRect := ButtonRect;
        Self.ActiveButtonRect := ActiveButtonRect;
        Self.DownButtonRect := DownButtonRect;
        Self.UnEnabledButtonRect := UnEnabledButtonRect;
        Self.ListBoxName := 'checklistbox';
      end;
end;

procedure TspSkinCustomCheckComboBox.Invalidate;
begin
  inherited;
end;

function TspSkinCustomCheckComboBox.IsPopupVisible: Boolean;
begin
  Result := FListBox.Visible;
end;

function TspSkinCustomCheckComboBox.CanCancelDropDown;
begin
  Result := FListBox.Visible and not FMouseIn;
end;

procedure TspSkinCustomCheckComboBox.ListBoxWindowProcHook(var Message: TMessage);
var
  FOld: Boolean;
begin
  FOld := True;
  case Message.Msg of
     WM_LBUTTONUP:
       begin
         Checked[FListBox.ItemIndex] := not Checked[FListBox.ItemIndex];
         FOld := False;
         Change;
         if Assigned(OnClick) then OnClick(Self);
       end;
     WM_RBUTTONDOWN, WM_RBUTTONUP,
     WM_MBUTTONDOWN, WM_MBUTTONUP,
     WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      begin
         FOLd := False;
       end;
  end;
  if FOld then FListBoxWindowProc(Message);
end;

procedure TspSkinCustomCheckComboBox.CMMouseEnter;
begin
  inherited;
  FMouseIn := True;
end;

procedure TspSkinCustomCheckComboBox.CMMouseLeave;
begin
  inherited;
  FMouseIn := False;
  if Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end;
end;

procedure TspSkinCustomCheckComboBox.SetDropDownCount(Value: Integer);
begin
  if Value > 0
  then
    FDropDownCount := Value;
end;

procedure TspSkinCustomCheckComboBox.ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
                           X, Y: Integer);

var
  Index: Integer;
begin
  if not FLBDown
  then
    begin
      Index := FListBox.ItemAtPos(Point (X, Y), True);
      if (Index >= 0) and (Index < Items.Count)
      then
        FListBox.ItemIndex := Index;
    end;
end;

procedure TspSkinCustomCheckComboBox.SetItems;
begin
  FListBox.Items.Assign(Value);
end;

function TspSkinCustomCheckComboBox.GetItems;
begin
  Result := FListBox.Items;
end;

procedure TspSkinCustomCheckComboBox.MouseDown;
begin
  inherited;
  if not Focused then SetFocus;
  if Button <> mbLeft then Exit;
  if Self.Button.MouseIn or PtInRect(CBItem.R, Point(X, Y))
  then
    begin
      Self.Button.Down := True;
      RePaint;
      if FListBox.Visible then CloseUp(False) else DropDown;
    end
  else
    if FListBox.Visible then CloseUp(False);
end;

procedure TspSkinCustomCheckComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  if Self.Button.Down
  then
    begin
      Self.Button.Down := False;
      RePaint;
    end;
end;

procedure TspSkinCustomCheckComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(Button.R, Point(X, Y)) and not Button.MouseIn
  then
    begin
      Button.MouseIn := True;
      RePaint;
    end
  else
  if not PtInRect(Button.R, Point(X, Y)) and Button.MouseIn
  then
    begin
      Button.MouseIn := False;
      RePaint;
    end;
end;

procedure TspSkinCustomCheckComboBox.CloseUp;
begin
  if not FListBox.Visible then Exit;
  FListBox.Hide;
  if Value
  then
    begin
      RePaint;
      if Assigned(FOnCloseUp) then FOnCloseUp(Self);
      if Assigned(FOnClick) then FOnClick(Self);
    end;
end;

procedure TspSkinCustomCheckComboBox.DropDown;
function GetForm(AControl : TControl) : TForm;
  var
    temp : TControl;
  begin
    result := nil;
    temp := AControl;
    repeat
      if assigned(temp) then
      begin
        if temp is TForm then
        break;
      end;
      temp := temp.Parent;
    until temp = nil;
  end;

var
  P: TPoint;
  WorkArea: TRect;
begin
  if Items.Count = 0 then Exit;

  if Assigned(FOnDropDown) then FOnDropDown(Self);

  FListBox.Width := Width;
  if Items.Count < DropDownCount
  then
    FListBox.RowCount := Items.Count
  else
    FListBox.RowCount := DropDownCount;
  P := Point(Left, Top + Height);
  P := Parent.ClientToScreen (P);

  WorkArea := GetMonitorWorkArea(Handle, True);

  if P.Y + FListBox.Height > WorkArea.Bottom
  then
    P.Y := P.Y - Height - FListBox.Height;

  if (FListBox.ItemIndex = 0) and (FListBox.Items.Count > 1)
  then
    begin
      FListBox.ItemIndex := 1;
      FListBox.ItemIndex := 0;
    end;

  FListBox.TopIndex := FListBox.ItemIndex;

  FListBox.Show(P);
end;

procedure TspSkinCustomCheckComboBox.EditPageUp1(AChange: Boolean);
var
  Index: Integer;
begin
  Index := FListBox.ItemIndex - DropDownCount - 1;
  if Index < 0 then Index := 0;
  FListBox.ItemIndex := Index;
end;

procedure TspSkinCustomCheckComboBox.EditPageDown1(AChange: Boolean);
var
  Index: Integer;
begin
  Index := FListBox.ItemIndex + DropDownCount - 1;
  if Index > FListBox.Items.Count - 1
  then
    Index := FListBox.Items.Count - 1;
  FListBox.ItemIndex := Index;
end;

procedure TspSkinCustomCheckComboBox.EditUp1;
begin
  if FListBox.ItemIndex > 0
  then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex - 1;
    end;
end;

procedure TspSkinCustomCheckComboBox.EditDown1;
begin
  if FListBox.ItemIndex < FListBox.Items.Count - 1
  then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex + 1;
    end;
end;

procedure TspSkinCustomCheckComboBox.WMSIZE;
begin
  inherited;
  CalcRects;
end;

procedure TspSkinCustomCheckComboBox.DrawButton;
var
  ArrowColor: TColor;
  R1: TRect;
begin
  if FIndex = -1
  then
    with Button do
    begin
      R1 := R;  
      if Down and MouseIn
      then
        begin
          Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
          C.Brush.Color := SP_XP_BTNDOWNCOLOR;
          C.FillRect(R1);
        end
      else
        if MouseIn
        then
          begin
            Frame3D(C, R1, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR, 1);
            C.Brush.Color := SP_XP_BTNACTIVECOLOR;
            C.FillRect(R1);
          end
        else
          begin
            Frame3D(C, R1, clBtnShadow, clBtnShadow, 1);
            C.Brush.Color := clBtnFace;
            C.FillRect(R1);
          end;
      if Enabled
      then
        ArrowColor := clBlack
      else
        ArrowColor := clBtnShadow;
      DrawArrowImage(C, R, ArrowColor, 4);
    end
  else
    with Button do
    begin
      R1 := NullRect;
      if not Enabled and not IsNullRect(UnEnabledButtonRect)
      then
        R1 := UnEnabledButtonRect
      else  
      if Down and MouseIn
      then R1 := DownButtonRect
      else if MouseIn then R1 := ActiveButtonRect;
      if not IsNullRect(R1)
      then
        C.CopyRect(R, Picture.Canvas, R1);
    end;
end;

procedure TspSkinCustomCheckComboBox.DrawDefaultItem;
var
  Buffer: TBitMap;
  R, R1: TRect;
  IX, IY: Integer;
begin
  if RectWidth(CBItem.R) <=0 then Exit;
  Buffer := TBitMap.Create;
  Buffer.Width := RectWidth(CBItem.R);
  Buffer.Height := RectHeight(CBItem.R);
  R := Rect(0, 0, Buffer.Width, Buffer.Height);
  with Buffer.Canvas do
  begin
    Font.Name := Self.Font.Name;
    Font.Style := Self.Font.Style;
    Font.Height := Self.Font.Height;
    if Focused
    then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := clWindow;
        Font.Color := clWindowText;
      end;
    FillRect(R);
  end;

  CBItem.State := [];

  if Focused then CBItem.State := [odFocused];

  R1 := Rect(R.Left + 2, R.Top, R.Right - 2, R.Bottom);


  SPDrawText2(Buffer.Canvas, Text, R1); 
  if Focused then DrawFocusRect(Buffer.Canvas.Handle, R);
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;


procedure TspSkinCustomCheckComboBox.DrawSkinItem;
var
  Buffer: TBitMap;
  R, R2: TRect;
  W, H: Integer;
  IX, IY: Integer;
begin
  W := RectWidth(CBItem.R);
  if W <= 0 then Exit;
  H := RectHeight(SItemRect);
  if H = 0 then H := RectHeight(FocusItemRect);
  if H = 0 then H := RectWidth(CBItem.R);
  Buffer := TBitMap.Create;
  if Focused
  then
    begin
      if not IsNullRect(FocusItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          FocusItemRect, W, H)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end
  else
    begin
      if not IsNullRect(SItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          SItemRect, W, H)
      else
        begin
          Buffer.Width := W;
          BUffer.Height := H;
          Buffer.Canvas.CopyRect(Rect(0, 0, W, H), Cnvs, CBItem.R);
        end;
    end;

  R := ItemTextRect;
  if not IsNullRect(SItemRect)
  then
    Inc(R.Right, W - RectWidth(SItemRect))
  else
    Inc(R.Right, W - RectWidth(ClRect));

  with Buffer.Canvas do
  begin
    if FUseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
       end
    else
      Font.Assign(FDefaultFont);

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet :=TURKISH_CHARSET;// FDefaultFont.CharSet;

    if Focused
    then
      Font.Color := FocusFontColor
    else
      Font.Color := FontColor;
    Brush.Style := bsClear;
  end;
  SPDrawText2(Buffer.Canvas, Text, R);
  Cnvs.Draw(CBItem.R.Left, CBItem.R.Top, Buffer);
  Buffer.Free;
end;

procedure TspSkinCustomCheckComboBox.CalcRects;
const
  ButtonW = 17;
var
  OX: Integer;
begin
  if FIndex = -1
  then
    begin
      Button.R := Rect(Width - ButtonW - 2, 2, Width - 2, Height - 2);
      CBItem.R := Rect(2, 2, Button.R.Left - 1 , Height -  2);
    end
  else
    begin
      OX := Width - RectWidth(SkinRect);
      Button.R := ButtonRect;
      if ButtonRect.Left >= RectWidth(SkinRect) - RTPt.X
      then
        OffsetRect(Button.R, OX, 0);
      CBItem.R := ClRect;
      Inc(CBItem.R.Right, OX);
    end;
end;

procedure TspSkinCustomCheckComboBox.ChangeSkinData;
begin
  inherited;
  CalcRects;
  RePaint;
  if FIndex = -1
  then
    begin
      FListBox.SkinDataName := '';
    end
  else
    if ListBoxCaptionMode
    then
      FListBox.SkinDataName := 'captionchecklistbox'
    else
      FListBox.SkinDataName := 'checklistbox';
  FListBox.SkinData := SkinData;
  FListBox.UpDateScrollBar;
end;

procedure TspSkinCustomCheckComboBox.CreateControlDefaultImage;
var
  R: TRect;
begin
  CalcRects;
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    R := ClientRect;
    FillRect(R);
  end;
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  DrawButton(B.Canvas);
  DrawDefaultItem(B.Canvas);
end;

procedure TspSkinCustomCheckComboBox.CreateControlSkinImage;
begin
  CalcRects;
  inherited;
  DrawButton(B.Canvas);
  DrawSkinItem(B.Canvas);
end;

// TspSkinFontSizeComboBox

function EnumFontSizes(var EnumLogFont: TEnumLogFont;
  PTextMetric: PNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var s: String;
    i,v,v2: Integer;
begin
  if (FontType and TRUETYPE_FONTTYPE) <> 0
  then
    begin
      TspSkinFontSizeComboBox(Data).Items.Add('8');
      TspSkinFontSizeComboBox(Data).Items.Add('9');
      TspSkinFontSizeComboBox(Data).Items.Add('10');
      TspSkinFontSizeComboBox(Data).Items.Add('11');
      TspSkinFontSizeComboBox(Data).Items.Add('12');
      TspSkinFontSizeComboBox(Data).Items.Add('14');
      TspSkinFontSizeComboBox(Data).Items.Add('16');
      TspSkinFontSizeComboBox(Data).Items.Add('18');
      TspSkinFontSizeComboBox(Data).Items.Add('20');
      TspSkinFontSizeComboBox(Data).Items.Add('22');
      TspSkinFontSizeComboBox(Data).Items.Add('24');
      TspSkinFontSizeComboBox(Data).Items.Add('26');
      TspSkinFontSizeComboBox(Data).Items.Add('28');
      TspSkinFontSizeComboBox(Data).Items.Add('36');
      TspSkinFontSizeComboBox(Data).Items.Add('48');
      TspSkinFontSizeComboBox(Data).Items.Add('72');
      Result := 0;
    end
  else
    begin
      v := Round((EnumLogFont.elfLogFont.lfHeight-PTextMetric.tmInternalLeading)*72 /
      TspSkinFontSizeComboBox(Data).PixelsPerInch);
      s := IntToStr(v);
      Result := 1;
      for i := 0 to TspSkinFontSizeComboBox(Data).Items.Count-1 do
      begin
        v2 := StrToInt(TspSkinFontSizeComboBox(Data).Items[i]);
        if v2 = v then Exit;
        if v2 > v
        then
          begin
            TspSkinFontSizeComboBox(Data).Items.Insert(i,s);
            Exit;
          end;
    end;
    TspSkinFontSizeComboBox(Data).Items.Add(S);
  end;
end;

procedure TspSkinFontSizeComboBox.Build;
var
  DC: HDC;
  OC: TNotifyEvent;
begin
  DC := GetDC(0);
  Items.BeginUpdate;
  try
    Items.Clear;
    if FontName<>'' then begin
      PixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
      EnumFontFamilies(DC, PChar(FontName), @EnumFontSizes, Longint(Self));
      OC := OnClick;
      OnClick := nil;
      ItemIndex := Items.IndexOf(Text);
      OnClick := OC;
      if Assigned(OnClick) then OnClick(Self);
    end;
  finally
    Items.EndUpdate;
    ReleaseDC(0, DC);
  end;
end;

procedure TspSkinFontSizeComboBox.SetFontName(const Value: TFontName);
begin
  FFontName := Value;
  Build;
end;

function TspSkinFontSizeComboBox.GetSizeValue: Integer;

function IsNumText(AText: String): Boolean;

function GetMinus: Boolean;
var
  i: Integer;
  S: String;
begin
  S := AText;
  i := Pos('-', S);
  if i > 1
  then
    Result := False
  else
    begin
      Delete(S, i, 1);
      Result := Pos('-', S) = 0;
    end;
end;

const
  EditChars = '01234567890-';
var
  i: Integer;
  S: String;
begin
  S := EditChars;
  Result := True;
  if (Text = '') or (Text = '-')
  then
    begin
      Result := False;
      Exit;
    end;

  for i := 1 to Length(Text) do
  begin
    if Pos(Text[i], S) = 0
    then
      begin
        Result := False;
        Break;
      end;
  end;

  Result := Result and GetMinus;
end;


begin
  if Style = spcbFixedStyle
  then
    begin
      if ItemIndex = -1
      then
        Result := 0
      else
        if Items[ItemIndex] <> ''
        then
          Result := StrToInt(Items[ItemIndex])
        else
          Result := 0;
    end
  else
    begin
      if (Text <> '') and (IsNumText(Text))
      then
        Result := StrToInt(Text)
      else
        Result := 0;
    end;
end;

end.




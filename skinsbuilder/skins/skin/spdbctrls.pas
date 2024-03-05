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

unit spdbctrls;

{$R-,H+,X+}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Windows, SysUtils, Messages, Classes, Controls, Forms,
     Graphics, Menus, StdCtrls, ExtCtrls, Mask, Buttons, ComCtrls, Db,
     ImgList,
     DBCtrls, SkinBoxCtrls, SkinCtrls, SkinData, spUtils, spMessages
     {$IFNDEF VER130}, Variants {$ENDIF};

type
  TspSkinDBText = class(TspSkinStdLabel)
  private
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetFieldText: string;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    function GetLabelText: string; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetAutoSize(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize default False;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Transparent;
    property ShowHint;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

 { TspSkinDbPasswordEdit }
  TspSkinDBPasswordEdit = class(TspSkinPasswordEdit)
  private
    FInDataChange: Boolean;
    FInChange: Boolean;
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    procedure EditingChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
  published
    published
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  { TspSkinDbEdit }

  TspSkinDBEdit = class(TspSkinEdit)
  private
    FDataLink: TFieldDataLink;
    FCanvas: TControlCanvas;
    FAlignment: TAlignment;
    FFocused: Boolean;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    function GetTextMargins: TPoint;
    procedure ResetMaxLength;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetFocused(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    function EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBSpinEdit = class(TspSkinSpinEdit)
  private
    FInDataChange: Boolean;
    FInChange: Boolean;
    FDataLink: TFieldDataLink;
    FCanvas: TControlCanvas;
    FAlignment: TAlignment;
    FFocused: Boolean;
    procedure EditingChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure EditEnter(Sender: TObject); override;
    procedure EditExit(Sender: TObject); override;
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
  published
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBDateEdit = class(TspSkinDateEdit)
  private
    FInDataChange: Boolean;
    FInChange: Boolean;
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    FAllowNullData: boolean;
    procedure EditingChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset; override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
  published
    published
    property AllowNullData: Boolean read FAllowNullData write FAllowNullData;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBTimeEdit = class(TspSkinTimeEdit)
  private
    FInDataChange: Boolean;
    FInChange: Boolean;
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    procedure EditingChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset; override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
  published
    published
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBNumericEdit = class(TspSkinNumericEdit)
  private
    FInDataChange: Boolean;
    FInChange: Boolean;
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    procedure EditingChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Reset; override;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMGotFocus); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
  published
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBMemo = class(TspSkinMemo)
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FPaintControl: TPaintControl;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
     procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadMemo; virtual;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBMemo2 = class(TspSkinMemo2)
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FPaintControl: TPaintControl;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadMemo; virtual;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBCheckRadioBox = class(TspSkinCheckRadioBox)
  private
    FDataLink: TFieldDataLink;
    FValueCheck: string;
    FValueUncheck: string;
    FInChange, FInDataChange: Boolean;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetFieldState: TCheckBoxState;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetValueCheck(const Value: string);
    procedure SetValueUncheck(const Value: string);
    procedure UpdateData(Sender: TObject);
    function ValueMatch(const ValueList, Value: string): Boolean;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
    procedure SetCheckState; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Checked;
    property Field: TField read GetField;
  published
    property Action;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ValueChecked: string read FValueCheck write SetValueCheck;
    property ValueUnchecked: string read FValueUncheck write SetValueUncheck;
    property Visible;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBListBox = class(TspSkinListBox)
  private
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetItems(Value: TStrings);
  protected
    procedure CheckButtonClick(Sender: TObject);
    procedure ListBoxExit; override;
    procedure ListBoxWProc(var Message: TMessage;
                           var Handled: Boolean); override;
    procedure ListBoxClick; override;
    procedure ListBoxKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ListBoxKeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property Items write SetItems;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
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

  { TspSkinDBComboBox }

  TspSkinDBComboBox = class(TspSkinComboBox)
  private
    FInDataChange: Boolean;
    FInDateSelfChange: Boolean;
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    function GetComboText: string;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetComboText(const Value: string);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetItems(Value: TStrings);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure EditWindowProcHook(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
    property Text;
  published
    property Style; {Must be published before Items}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property Items write SetItems;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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
    property OnStartDock;
    property OnStartDrag;
  end;

  TspSkinDBRadioGroup = class(TspSkinCustomRadioGroup)
  private
    FInClick: Boolean;
    FDataLink: TFieldDataLink;
    FValue: string;
    FValues: TStrings;
    FInSetValue: Boolean;
    FOnChange: TNotifyEvent;
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    function GetButtonValue(Index: Integer): string;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetValue(const Value: string);
    procedure SetItems(Value: TStrings);
    procedure SetValues(Value: TStrings);
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure Change; dynamic;
    procedure Click; override;
    procedure KeyPress(var Key: Char); override;
    function CanModify: Boolean; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property DataLink: TFieldDataLink read FDataLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
    property ItemIndex;
    property Value: string read FValue write SetValue;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Items write SetItems;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Values: TStrings read FValues write SetValues;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TspDBLookupControl }

  TspDBLookupControl = class;

  TspDataSourceLink = class(TDataLink)
  private
    FDBLookupControl: TspDBLookupControl;
  protected
    procedure FocusControl(Field: TFieldRef); override;
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create;
  end;

  TspListSourceLink = class(TDataLink)
  private
    FDBLookupControl: TspDBLookupControl;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure LayoutChanged; override;
  public
    constructor Create;
  end;

  TspDBLookupControl = class(TspSkinCustomControl)
  private
    FLookupSource: TDataSource;
    FDataLink: TspDataSourceLink;
    FListLink: TspListSourceLink;
    FDataFieldName: string;
    FKeyFieldName: string;
    FListFieldName: string;
    FListFieldIndex: Integer;
    FMasterField: TField;
    FDataField: TField;
    FKeyField: TField;
    FListField: TField;
    FListFields: TList;
    FKeyValue: Variant;
    FSearchText: string;
    FLookupMode: Boolean;
    FListActive: Boolean;
    FHasFocus: Boolean;
    FNullValueKey: TShortCut;
    procedure CheckNotCircular;
    procedure CheckNotLookup;
    procedure DataLinkRecordChanged(Field: TField);
    function GetDataSource: TDataSource;
    function GetKeyFieldName: string;
    function GetListSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataFieldName(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetKeyFieldName(const Value: string);
    procedure SetKeyValue(const Value: Variant);
    procedure SetListFieldName(const Value: string);
    procedure SetListSource(Value: TDataSource);
    procedure SetLookupMode(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;    
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    function CanModify: Boolean; virtual;
    procedure KeyValueChanged; virtual;
    procedure ListLinkDataChanged; virtual;
    function LocateKey: Boolean; virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure ProcessSearchKey(Key: Char); virtual;
    procedure SelectKeyValue(const Value: Variant); virtual;
    procedure UpdateDataFields; virtual;
    procedure UpdateListFields; virtual;
    property DataField: string read FDataFieldName write SetDataFieldName;
    property DataLink: TspDataSourceLink read FDataLink;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property HasFocus: Boolean read FHasFocus;
    property KeyField: string read GetKeyFieldName write SetKeyFieldName;
    property KeyValue: Variant read FKeyValue write SetKeyValue;
    property ListActive: Boolean read FListActive;
    property ListField: string read FListFieldName write SetListFieldName;
    property ListFieldIndex: Integer read FListFieldIndex write FListFieldIndex default 0;
    property ListFields: TList read FListFields;
    property ListLink: TspListSourceLink read FListLink;
    property ListSource: TDataSource read GetListSource write SetListSource;
    property NullValueKey: TShortCut read FNullValueKey write FNullValueKey default 0;
    property ParentColor default False;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property SearchText: string read FSearchText write FSearchText;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read FDataField;
  end;

{ TspSkinDBLookupListBox }

  TspSkinDBLookupListBox = class(TspDBLookupControl)
  private
    FStopThumbScroll: Boolean;
    FDefaultItemHeight: Integer;
    FUseSkinItemHeight: Boolean;
    FRecordIndex: Integer;
    FRecordCount: Integer;
    FRowCount: Integer;
    FBorderStyle: TBorderStyle;
    FPopup: Boolean;
    FKeySelected: Boolean;
    FTracking: Boolean;
    FTimerActive: Boolean;
    FLockPosition: Boolean;
    FMousePos: Integer;
    FSelectedItem: string;

    procedure ShowScrollBar;
    procedure HideScrollBar;
    procedure AlignScrollBar;

    procedure SetDefaultItemHeight(Value: Integer);
    function GetKeyIndex: Integer;
    procedure SelectCurrent;
    procedure SelectItemAt(X, Y: Integer);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetRowCount(Value: Integer);
    procedure StopTimer;
    procedure StopTracking;
    procedure TimerScroll;
    procedure UpdateScrollBar;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMTimer(var Message: TMessage); message WM_TIMER;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure OnScrollBarChange(Sender: TObject);
    procedure OnScrollBarUpButtonClick(Sender: TObject);
    procedure OnScrollBarDownButtonClick(Sender: TObject);
  protected
    procedure FramePaint(C: TCanvas);
    procedure WMNCCALCSIZE(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPAINT(var Message: TMessage); message WM_NCPAINT;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyValueChanged; override;
    procedure ListLinkDataChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure UpdateListFields; override;

    procedure GetSkinData; override;
    function GetItemHeight: Integer;
    function GetBorderHeight: Integer;
    function GetItemWidth: Integer;
  public
    FScrollBar: TspSkinScrollBar;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, ActiveFontColor, FocusFontColor: TColor;
    ScrollBarName: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property KeyValue;
    property SelectedItem: string read FSelectedItem;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ChangeSkinData; override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property KeyField;
    property ListField;
    property ListFieldIndex;
    property ListSource;
    property NullValueKey;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RowCount: Integer read FRowCount write SetRowCount;
    property DefaultItemHeight: Integer read FDefaultItemHeight
                                        write SetDefaultItemHeight;
    property UseSkinItemHeight: Boolean
      read FUseSkinItemHeight write FUseSkinItemHeight;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
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

  { TDBLookupComboBox }

  TspPopupDataList = class(TspSkinDBLookupListBox)
  private
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TDropDownAlign = (daLeft, daRight, daCenter);

  TspSkinDBLookupComboBox = class(TspDBLookupControl)
  private
    FDefaultColor: TColor;
    FMouseIn: Boolean;
    FButtonRect, FItemRect: TRect;
    FDataList: TspPopupDataList;
    FButtonWidth: Integer;
    FText: string;
    FDropDownRows: Integer;
    FDropDownWidth: Integer;
    FDropDownAlign: TDropDownAlign;
    FListVisible: Boolean;
    FPressed: Boolean;
    FTracking: Boolean;
    FAlignment: TAlignment;
    FLookupMode: Boolean;
    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TNotifyEvent;

    FOnChange: TNotifyEvent;

    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StopTracking;
    procedure TrackButton(X, Y: Integer);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

    function GetListBoxDefaultItemHeight: Integer;
    procedure SetListBoxDefaultItemHeight(Value: Integer);
    function GetListBoxUseSkinFont: Boolean;
    procedure SetListBoxUseSkinFont(Value: Boolean);
    function GetListBoxUseSkinItemHeight: Boolean;
    procedure SetListBoxUseSkinItemHeight(Value: Boolean);

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetDefaultColor(Value: TColor);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyValueChanged; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure UpdateListFields; override;
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;

    procedure GetSkinData; override;
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontColor, FocusFontColor, ActiveFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect: TRect;
    ListBoxName: String;
    ActiveSkinRect: TRect;
    StretchEffect, ItemStretchEffect, FocusItemStretchEffect: Boolean;
    UnEnabledButtonRect: TRect;
    constructor Create(AOwner: TComponent); override;
    procedure CloseUp(Accept: Boolean); virtual;
    procedure DropDown; virtual;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property KeyValue;
    property ListVisible: Boolean read FListVisible;
    property Text: string read FText;
  published
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownAlign: TDropDownAlign read FDropDownAlign write FDropDownAlign default daLeft;
    property DropDownRows: Integer read FDropDownRows write FDropDownRows default 7;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;

    property ListBoxDefaultItemHeight: Integer
      read GetListBoxDefaultItemHeight write SetListBoxDefaultItemHeight;

    property ListBoxUseSkinFont: Boolean
      read GetListBoxUseSkinFont write SetListBoxUseSkinFont;

    property ListBoxUseSkinItemHeight: Boolean
      read GetListBoxUseSkinItemHeight write SetListBoxUseSkinItemHeight;

    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property KeyField;
    property ListField;
    property ListFieldIndex;
    property ListSource;
    property NullValueKey;
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
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
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

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

type
  TspNavButton = class;
  TspNavDataLink = class;

  TspNavGlyph = (ngEnabled, ngDisabled);
  TspNavigateBtn = (nbFirst, nbPrior, nbNext, nbLast,
                  nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh);
  TspButtonSet = set of TspNavigateBtn;
  TspNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

  ENavClick = procedure (Sender: TObject; Button: TspNavigateBtn) of object;

{ TspSkinDBNavigator }
  TspSkinDBNavigator = class (TspSkinPanel)
  private
    FImageList: TCustomImageList;
    FShowButtonCaption, FShowButtonGraphic: Boolean;
    FSkinMessage: TspSkinMessage;
    FBtnSkinDataName: String;
    FDataLink: TspNavDataLink;
    FVisibleButtons: TspButtonSet;
    FHints: TStrings;
    FDefHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ENavClick;
    FBeforeAction: ENavClick;
    FConfirmDelete: Boolean;
    FAdditionalGlyphs: Boolean;
    procedure SetShowButtonCaption(Value: Boolean);
    procedure SetShowButtonGraphic(Value: Boolean);
    procedure SetAdditionalGlyphs(Value: Boolean);
    procedure SetBtnSkinDataName(Value: String);
    procedure ClickHandler(Sender: TObject);
    function GetDataSource: TDataSource;
    function GetHints: TStrings;
    procedure HintsChanged(Sender: TObject);
    procedure InitButtons;
    procedure InitHints;
    procedure SetDataSource(Value: TDataSource);
    procedure SetImageList(Value: TCustomImageList);
    procedure SetHints(Value: TStrings);
    procedure SetSize(var W: Integer; var H: Integer);
    procedure SetVisible(Value: TspButtonSet);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  protected
    Buttons: array[TspNavigateBtn] of TspNavButton;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure CalcMinSize(var W, H: Integer);
    procedure SetSkinData(Value: TspSkinData); override;
  public
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TspNavigateBtn); virtual;
    procedure ChangeSkinData; override;
  published
    property ImageList: TCustomImageList read FImageList write SetImageList; 
    property ShowButtonCaption: Boolean read FShowButtonCaption write SetShowButtonCaption default False;
    property ShowButtonGraphic: Boolean read FShowButtonGraphic write SetShowButtonGraphic default True;
    property AdditionalGlyphs: Boolean
      read FAdditionalGlyphs write SetAdditionalGlyphs;
    property SkinMessage: TspSkinMessage read FSkinMessage write FSkinMessage;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property VisibleButtons: TspButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
        nbEdit, nbPost, nbCancel, nbRefresh];
    property BtnSkinDataName: String read FBtnSkinDataName write SetBtnSkinDataName;
    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Hints: TStrings read GetHints write SetHints;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property BeforeAction: ENavClick read FBeforeAction write FBeforeAction;
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;


{ TspNavButton }

  TspNavButton = class(TspSkinButton)
  private
    FNavIndex: TspNavigateBtn;
    FNavStyle: TspNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    procedure GetSkinData; override;
    destructor Destroy; override;
    property NavStyle: TspNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TspNavigateBtn read FNavIndex write FNavIndex;
  end;

{ TspNavDataLink }

  TspNavDataLink = class(TDataLink)
  private
    FNavigator: TspSkinDBNavigator;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TspSkinDBNavigator);
    destructor Destroy; override;
  end;

  { TspSkinDBImage }

  TspSkinDBImage = class(TspSkinPanel)
  private
    FDataLink: TFieldDataLink;
    FPicture: TPicture;
    FBorderStyle: TspSkinBorderStyle;
    FAutoDisplay: Boolean;
    FStretch: Boolean;
    FCenter: Boolean;
    FPictureLoaded: Boolean;
    FQuickDraw: Boolean;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure PictureChanged(Sender: TObject);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetPicture(Value: TPicture);
    procedure SetReadOnly(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function GetPalette: HPALETTE; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure PaintImage(Cnvs: TCanvas);
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadPicture;
    procedure PasteFromClipboard;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
    property Picture: TPicture read FPicture write SetPicture;
  published
    property Align;
    property Anchors;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property QuickDraw: Boolean read FQuickDraw write FQuickDraw default True;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
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

  TspSkinDBRichEdit = class(TspSkinRichEdit)
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FDataSave: string;
    procedure BeginEditing;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadMemo; virtual;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
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
    property OnResizeRequest;
    property OnSelectionChange;
    property OnProtectChange;
    property OnSaveClipboard;
    property OnStartDock;
    property OnStartDrag;
  end;
 

implementation

uses Clipbrd, Dialogs, Math, spConst;

{$R SPDBCTRLS}

{ TspSkinDBText }

constructor TspSkinDBText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  AutoSize := False;
  ShowAccelChar := False;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
end;

destructor TspSkinDBText.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBText.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBText.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBText.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBText.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then
  begin
//    if Value and FDataLink.DataSourceFixed then DatabaseError(SDataSourceFixed);
    inherited SetAutoSize(Value);
  end;
end;

function TspSkinDBText.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBText.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBText.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBText.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBText.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TspSkinDBText.GetFieldText: string;
begin
  if FDataLink.Field <> nil then
    Result := FDataLink.Field.DisplayText
  else
    if csDesigning in ComponentState then Result := Name else Result := '';
end;

procedure TspSkinDBText.DataChange(Sender: TObject);
begin
  Caption := GetFieldText;
end;

function TspSkinDBText.GetLabelText: string;
begin
  if csPaintCopy in ControlState then
    Result := GetFieldText else
    Result := Caption;
end;

procedure TspSkinDBText.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBText.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBText.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TspSkinDbEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

constructor TspSkinDbEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

destructor TspSkinDbEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  inherited Destroy;
end;

procedure TspSkinDbEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDbEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDbEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDbEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TspSkinDbEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;
end;

function TspSkinDbEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

procedure TspSkinDbEdit.Reset;
begin
  FDataLink.Reset;
  SelectAll;
end;

procedure TspSkinDbEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if (FAlignment <> taLeftJustify) and not IsMasked then Invalidate;
    FDataLink.Reset;
  end;
end;

procedure TspSkinDbEdit.Change;
begin
  FDataLink.Modified;
  inherited Change;
end;

function TspSkinDbEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDbEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDbEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDbEdit.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then
    ResetMaxLength;
  FDataLink.FieldName := Value;
end;

function TspSkinDbEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDbEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDbEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDbEdit.ActiveChange(Sender: TObject);
begin
  ResetMaxLength;
end;

procedure TspSkinDbEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
  begin
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      EditText := '';  {forces update}
      FAlignment := FDataLink.Field.Alignment;
    end;
    EditMask := FDataLink.Field.EditMask;
    if not (csDesigning in ComponentState) then
    begin
      if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
        MaxLength := FDataLink.Field.Size;
    end;
    if FFocused and FDataLink.CanModify then
      Text := FDataLink.Field.Text
    else
    begin
      EditText := FDataLink.Field.DisplayText;
      if FDataLink.Editing and FDataLink.CanModify then
      Modified := True;
    end;
  end else
  begin
    FAlignment := taLeftJustify;
    EditMask := '';
    if csDesigning in ComponentState then
      EditText := Name else
      EditText := '';
  end;
end;

procedure TspSkinDbEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDbEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  FDataLink.Field.Text := Text;
end;

procedure TspSkinDbEdit.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDbEdit.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDbEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDbEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);

  inherited;

  if FDataLink.CanModify
  then
    inherited ReadOnly := False;

  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDbEdit.CMExit(var Message: TCMExit);
begin
  try
    if FDataLink.Editing then FDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  SetFocused(False);
  CheckCursor;
  DoExit;
end;

procedure TspSkinDbEdit.WMPaint(var Message: TWMPaint);
const
  AlignStyle : array[Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  Left: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  AAlignment: TAlignment;
  ExStyle: DWORD;
begin
  AAlignment := FAlignment;
  if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
  if ((AAlignment = taLeftJustify) or FFocused) and
    not (csPaintCopy in ControlState) then
  begin
    if SysLocale.MiddleEast and HandleAllocated and (IsRightToLeft) then
    begin { This keeps the right aligned text, right aligned }
      ExStyle := DWORD(GetWindowLong(Handle, GWL_EXSTYLE)) and (not WS_EX_RIGHT) and
        (not WS_EX_RTLREADING) and (not WS_EX_LEFTSCROLLBAR);
      if UseRightToLeftReading then ExStyle := ExStyle or WS_EX_RTLREADING;
      if UseRightToLeftScrollbar then ExStyle := ExStyle or WS_EX_LEFTSCROLLBAR;
      ExStyle := ExStyle or
        AlignStyle[UseRightToLeftAlignment, AAlignment];
      if DWORD(GetWindowLong(Handle, GWL_EXSTYLE)) <> ExStyle then
        SetWindowLong(Handle, GWL_EXSTYLE, ExStyle);
    end;
    inherited;
    Exit;
  end;
{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }
  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;
  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  //
  if FIndex <> -1 then DrawEditBackGround(FCanvas);
  //
  try
    FCanvas.Font := Font;
    with FCanvas do
    begin
      R := ClientRect;
      Brush.Style := bsClear;
      if (csPaintCopy in ControlState) and (FDataLink.Field <> nil) then
      begin
        S := FDataLink.Field.DisplayText;
        case CharCase of
          ecUpperCase: S := AnsiUpperCase(S);
          ecLowerCase: S := AnsiLowerCase(S);
        end;
      end else
        S := EditText;
      if PasswordChar <> #0 then FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case AAlignment of
        taLeftJustify: Left := Margins.X;
        taRightJustify: Left := ClientWidth - TextWidth(S) - Margins.X - 1;
      else
        Left := (ClientWidth - TextWidth(S)) div 2;
      end;
      if SysLocale.MiddleEast then UpdateTextFlags;
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

procedure TspSkinDbEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDbEdit.GetTextMargins: TPoint;
begin
  Result.X := 0;
  Result.Y := 0;
end;

function TspSkinDbEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDbEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

constructor TspSkinDBMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FPaintControl := TPaintControl.Create(Self, 'EDIT');
end;

destructor TspSkinDBMemo.Destroy;
begin
  FPaintControl.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBMemo.WMPaint(var Message: TWMPaint);
var
  S: string;
begin
  if not (csPaintCopy in ControlState) then inherited else
  begin
    if FDataLink.Field <> nil then
      if FDataLink.Field.IsBlob then
      begin
        if FAutoDisplay then
          S := AdjustLineBreaks(FDataLink.Field.AsString) else
          S := Format('(%s)', [FDataLink.Field.DisplayLabel]);
      end else
        S := FDataLink.Field.DisplayText;
    SendMessage(FPaintControl.Handle, WM_SETTEXT, 0, Integer(PChar(S)));
    SendMessage(FPaintControl.Handle, WM_ERASEBKGND, Message.DC, 0);
    SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
  end;
end;

procedure TspSkinDBMemo.Loaded;
begin
  inherited Loaded;
//  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBMemo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBMemo.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
      FDataLink.Edit;
  end;
end;

procedure TspSkinDBMemo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TspSkinDBMemo.Change;
begin
  if FMemoLoaded then FDataLink.Modified;
  FMemoLoaded := True;
  inherited Change;
end;

function TspSkinDBMemo.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBMemo.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBMemo.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBMemo.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBMemo.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBMemo.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBMemo.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBMemo.LoadMemo;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      Lines.Text := FDataLink.Field.AsString;
      FMemoLoaded := True;
    except
      { Memo too large }
      on E:EInvalidOperation do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
  end;
end;

procedure TspSkinDBMemo.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsBlob then
    begin
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
      begin
        FMemoLoaded := False;
        LoadMemo;
      end else
      begin
        Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
        FMemoLoaded := False;
      end;
    end else
    begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  else
  begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;
  if FBitMapBG then FStopDraw := True;
  if HandleAllocated then RePaint;
end;

procedure TspSkinDBMemo.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TspSkinDBMemo.UpdateData(Sender: TObject);
begin
  FDataLink.Field.AsString := Text;
end;

procedure TspSkinDBMemo.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob then
      FDataLink.Reset;
  end;
end;

procedure TspSkinDBMemo.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TspSkinDBMemo.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if FDataLink.CanModify then
    inherited ReadOnly := False;

  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBMemo.CMExit(var Message: TCMExit);
begin
  try
    if FDataLink.Editing then FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;

procedure TspSkinDBMemo.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TspSkinDBMemo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not FMemoLoaded then LoadMemo else inherited;
end;

procedure TspSkinDBMemo.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBMemo.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBMemo.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspSkinDBCheckRadioBox }

constructor TspSkinDBCheckRadioBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FInChange := False;
  FInDataChange := False;
  FValueCheck := 'True';
  FValueUncheck := 'False';
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TspSkinDBCheckRadioBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBCheckRadioBox.SetCheckState;
begin
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify
  then
    begin
      inherited;
      if FDataLink.Edit then FDataLink.Modified;
    end;
  FInChange := False;
end;

procedure TspSkinDBCheckRadioBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBCheckRadioBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

function TspSkinDBCheckRadioBox.GetFieldState: TCheckBoxState;
var
  Text: string;
begin
  if FDatalink.Field <> nil then
    if FDataLink.Field.IsNull then
      Result := cbGrayed
    else if FDataLink.Field.DataType = ftBoolean then
      if FDataLink.Field.AsBoolean then
        Result := cbChecked
      else
        Result := cbUnchecked
    else
    begin
      Result := cbGrayed;
      Text := FDataLink.Field.Text;
      if ValueMatch(FValueCheck, Text) then Result := cbChecked else
        if ValueMatch(FValueUncheck, Text) then Result := cbUnchecked;
    end
  else
    Result := cbUnchecked;
end;

procedure TspSkinDBCheckRadioBox.DataChange(Sender: TObject);
var
  State: TCheckBoxState;
begin
  FInDataChange := True;
  if not FInChange
  then
    begin
      State := GetFieldState;
      FChecked := State = cbChecked;
      RePaint;
    end;  
  FInDataChange := False;
end;

procedure TspSkinDBCheckRadioBox.UpdateData(Sender: TObject);
var
  Pos: Integer;
  S: string;
begin
  if FDataLink.Field.DataType = ftBoolean then
     FDataLink.Field.AsBoolean := Checked
  else
    begin
      if Checked then S := FValueCheck else S := FValueUncheck;
      Pos := 1;
      FDataLink.Field.Text := ExtractFieldName(S, Pos);
    end;
end;

function TspSkinDBCheckRadioBox.ValueMatch(const ValueList, Value: string): Boolean;
var
  Pos: Integer;
begin
  Result := False;
  Pos := 1;
  while Pos <= Length(ValueList) do
    if AnsiCompareText(ExtractFieldName(ValueList, Pos), Value) = 0 then
    begin
      Result := True;
      Break;
    end;
end;

function TspSkinDBCheckRadioBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBCheckRadioBox.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBCheckRadioBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBCheckRadioBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBCheckRadioBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBCheckRadioBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBCheckRadioBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBCheckRadioBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    #8, ' ':
      FDataLink.Edit;
    #27:
      FDataLink.Reset;
  end;
end;

procedure TspSkinDBCheckRadioBox.SetValueCheck(const Value: string);
begin
  FValueCheck := Value;
  DataChange(Self);
end;

procedure TspSkinDBCheckRadioBox.SetValueUncheck(const Value: string);
begin
  FValueUncheck := Value;
  DataChange(Self);
end;

procedure TspSkinDBCheckRadioBox.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TspSkinDBCheckRadioBox.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TspSkinDBCheckRadioBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBCheckRadioBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBCheckRadioBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspSkinDBListBox }

constructor TspSkinDBListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  OnCheckButtonClick := CheckButtonClick;
end;

destructor TspSkinDBListBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBListBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBListBox.CheckButtonClick;
begin
  if ReadOnly or not FDataLink.CanModify or not ListBox.Focused then Exit;
  if FDataLink.Edit
  then
    FDataLink.Modified;
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
end;

procedure TspSkinDBListBox.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil
  then
    ItemIndex := Items.IndexOf(FDataLink.Field.Text)
  else
    ItemIndex := -1;
end;

procedure TspSkinDBListBox.UpdateData(Sender: TObject);
begin
  if ItemIndex >= 0 then
    FDataLink.Field.Text := Items[ItemIndex] else
    FDataLink.Field.Text := '';
end;


procedure TspSkinDBListBox.ListBoxClick;
begin
  inherited;
  if FDataLink.Edit
  then
    FDataLink.Modified;
end;

function TspSkinDBListBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBListBox.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBListBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBListBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBListBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBListBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBListBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBListBox.ListBoxKeyDown;
begin
  inherited;
  if Key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT, VK_UP,
    VK_RIGHT, VK_DOWN] then
    if not FDataLink.Edit then Key := 0;
end;

procedure TspSkinDBListBox.ListBoxKeyPress;
begin
  inherited;
  case Key of
    #32..#255:
      if not FDataLink.Edit then Key := #0;
    #27:
      FDataLink.Reset;
  end;
end;

type
  TspListBoxX = class(TspListBox);

procedure TspSkinDBListBox.ListBoxWProc(var Message: TMessage;
                                          var Handled: Boolean);
begin
  inherited;
  case Message.Msg of
    WM_LButtonDown:
    if not (csDesigning in ComponentState)
    then
      with TWMLButtonDown(Message) do
      begin
        if not FDataLink.Edit
        then
          begin
            ListBox.SetFocus;
            TspListBoxX(ListBox).MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
            Handled := False;
          end;
      end;
  end;
end;

procedure TspSkinDBListBox.ListBoxExit;
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TspSkinDBListBox.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
  DataChange(Self);
end;

function TspSkinDBListBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBListBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspSkinDBComboBox }

constructor TspSkinDBComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FInDataChange := True;
  FInDateSelfChange := False;
end;

destructor TspSkinDBComboBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBComboBox.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBComboBox.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure TspSkinDBComboBox.DataChange(Sender: TObject);
begin
  FInDataChange := True;
  if not FInDateSelfChange
  then
    begin
      if FDataLink.Field <> nil
      then
         SetComboText(FDataLink.Field.Text)
      else
        if csDesigning in ComponentState
        then
          SetComboText(Name)
        else
         SetComboText('');
    end;     
  FInDataChange := False;
end;

procedure TspSkinDBComboBox.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := GetComboText;
end;

procedure TspSkinDBComboBox.SetComboText(const Value: string);
var
  I: Integer;
  Redraw: Boolean;
begin
  if Value <> GetComboText then
  begin
    if Style = spcbFixedStyle then
    begin
      Redraw := HandleAllocated;
      try
        if Value = '' then I := -1 else I := Items.IndexOf(Value);
        ItemIndex := I;
      finally
        if Redraw then Invalidate;
      end;
      if I >= 0 then Exit;
    end;
    if Style = spcbEditStyle then Text := Value;
  end;
end;

function TspSkinDBComboBox.GetComboText: string;
var
  I: Integer;
begin
  if Style = spcbEditStyle then Result := Text else
  begin
    I := ItemIndex;
    if I < 0 then Result := '' else Result := Items[I];
  end;
end;

procedure TspSkinDBComboBox.Change;
begin
  inherited;
  if not FInDataChange and not ReadOnly and FDataLink.CanModify
  then
    begin
      FInDateSelfChange := True;
      FDataLink.Edit;
      FDataLink.Modified;
      FInDateSelfChange := False;
    end;
end;

function TspSkinDBComboBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBComboBox.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBComboBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBComboBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBComboBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBComboBox.EditWindowProcHook;
begin
  inherited;
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if ReadOnly or not FDataLink.CanModify
        then FEdit.ReadOnly := True;
      end;
    WM_KILLFOCUS:
      begin
        try
          begin
            if FDataLink.Editing then FDataLink.UpdateRecord;
          end;
        except
          raise;
        end;
      end;
  end;
end; 

procedure TspSkinDBComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key in [VK_BACK, VK_DELETE, VK_UP, VK_DOWN, 32..255] then
  begin
    if not FDataLink.Edit and (Key in [VK_UP, VK_DOWN]) then
      Key := 0;
  end;
end;

procedure TspSkinDBComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
      end;
  end;
end;

procedure TspSkinDBComboBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
end;

procedure TspSkinDBComboBox.CMExit(var Message: TCMExit);
begin
  try
    if ReadOnly or not FDataLink.CanModify
    then
      DataChange(Self)
    else
      if FDataLink.Editing then  FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TspSkinDBComboBox.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
  DataChange(Self);
end;

function TspSkinDBComboBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBComboBox.CMGetDatalink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBComboBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBComboBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;


{ TspSkinDBNavigator }
var
  BtnTypeName: array[TspNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'INSERT', 'DELETE', 'EDIT', 'POST', 'CANCEL', 'REFRESH');

  BtnHints: array[TspNavigateBtn] of String = (SP_DBNAV_FIRST_HINT, SP_DBNAV_PRIOR_HINT,
    SP_DBNAV_NEXT_HINT, SP_DBNAV_LAST_HINT, SP_DBNAV_INSERT_HINT, SP_DBNAV_DELETE_HINT,
    SP_DBNAV_EDIT_HINT, SP_DBNAV_POST_HINT, SP_DBNAV_CANCEL_HINT, SP_DBNAV_REFRESH_HINT);
 
constructor TspSkinDBNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  FImageList := nil;
  FShowButtonGraphic := True;
  FShowButtonCaption:= False;
  FSkinMessage := nil;
  FAdditionalGlyphs := False;
  FDataLink := TspNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbInsert,
    nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;
  InitButtons;
  InitHints;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FConfirmDelete := True;
  BorderStyle := bvNone;
  FBtnSkinDataName := 'button';
end;

procedure TspSkinDBNavigator.SetImageList(Value: TCustomImageList);
begin
  FImageList := Value;
  ShowButtonGraphic := ShowButtonGraphic; 
end;

procedure TspSkinDBNavigator.SetShowButtonCaption;
var
  I: TspNavigateBtn;
begin
  FShowButtonCaption := Value;
  if FShowButtonCaption
  then
    begin
       for I := Low(Buttons) to High(Buttons) do
       begin
         if Buttons[I] <> nil
         then
           case Ord(i) of
             0:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_FIRST')
              else
                Buttons[I].Caption := SP_DBNAV_FIRST;

             1:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_PRIOR')
              else
                Buttons[I].Caption := SP_DBNAV_PRIOR;


             2:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_NEXT')
              else
                Buttons[I].Caption := SP_DBNAV_NEXT;

             3:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_LAST')
              else
                Buttons[I].Caption := SP_DBNAV_LAST;

             4:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_INSERT')
              else
                Buttons[I].Caption := SP_DBNAV_INSERT;

             5:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_DELETE')
              else
                Buttons[I].Caption := SP_DBNAV_DELETE;

             6:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_EDIT')
              else
                Buttons[I].Caption := SP_DBNAV_EDIT;

             7:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_POST')
              else
                Buttons[I].Caption := SP_DBNAV_POST;

             8:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_CANCEL')
              else
                Buttons[I].Caption := SP_DBNAV_CANCEL;

             9:
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Buttons[I].Caption := SkinData.ResourceStrData.GetResStr('DBNAV_REFRESH')
               else
               Buttons[I].Caption := SP_DBNAV_REFRESH;
           end;
       end;
    end
  else
    begin
      for I := Low(Buttons) to High(Buttons) do
      begin
        if Buttons[I] <> nil
        then
          case Ord(i) of
            0: Buttons[I].Caption := '';
            1: Buttons[I].Caption := '';
            2: Buttons[I].Caption := '';
            3: Buttons[I].Caption := '';
            4: Buttons[I].Caption := '';
            5: Buttons[I].Caption := '';
            6: Buttons[I].Caption := '';
            7: Buttons[I].Caption := '';
            8: Buttons[I].Caption := '';
            9: Buttons[I].Caption := '';
          end;
      end;
   end;
end;

procedure TspSkinDBNavigator.SetShowButtonGraphic;
var
  I: TspNavigateBtn;
  ResName: string;
begin
  FShowButtonGraphic := Value;
  if FShowButtonGraphic and (FImageList = nil)
  then
    begin
      if FAdditionalGlyphs
      then
         begin
           for I := Low(Buttons) to High(Buttons) do
           begin
             FmtStr(ResName, 'spdbn_%s', [BtnTypeName[I]]);
             if FAdditionalGlyphs
             then
               ResName := ResName + '1';
             Buttons[I].Glyph.LoadFromResourceName(HInstance, ResName);
             Buttons[I].NumGlyphs := 2;
             Buttons[I].ImageList := nil;
           end;
         end
      else
        begin
          for I := Low(Buttons) to High(Buttons) do
          begin
            FmtStr(ResName, 'spdbn_%s', [BtnTypeName[I]]);
            if FAdditionalGlyphs then
            ResName := ResName + '1';
            Buttons[I].Glyph.LoadFromResourceName(HInstance, ResName);
            Buttons[I].NumGlyphs := 2;
            Buttons[I].ImageList := nil;
            Buttons[I].RePaint;
          end;
       end
    end
  else
    for I := Low(Buttons) to High(Buttons) do
    begin
      if (FImageList <> nil) and FShowButtonGraphic
      then
        begin
          Buttons[I].ImageList := FImageList;
          Buttons[I].ImageIndex := Ord(Buttons[I].Index);
        end
      else
        Buttons[I].ImageList := nil;
      Buttons[I].Glyph := nil;
      Buttons[I].RePaint;
    end;
end;


procedure  TspSkinDBNavigator.SetAdditionalGlyphs;
var
  I: TspNavigateBtn;
  ResName: String;
begin
  if (Value <> FAdditionalGlyphs) and FShowButtonGraphic
  then
    begin
      FAdditionalGlyphs := Value;
      for I := Low(Buttons) to High(Buttons) do
      begin
        FmtStr(ResName, 'spdbn_%s', [BtnTypeName[I]]);
        if FAdditionalGlyphs then ResName := ResName + '1';
        Buttons[I].Glyph.LoadFromResourceName(HInstance, ResName);
        Buttons[I].RePaint;
      end;
    end;  
end;

destructor TspSkinDBNavigator.Destroy;
begin
  FDefHints.Free;
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBNavigator.ChangeSkinData;
var
  i: Integer;
begin
  inherited;
  if (FIndex <> -1) and (GetResizeMode = 1) and (FBtnSkinDataName <> '')
  then
    begin
      i := SkinData.GetControlIndex(FBtnSkinDataName);
      if i <> -1
      then
        with TspDataSkinButtonControl(FSD.CtrlList.Items[i]) do
        begin
          if (LBPoint.X = 0) and (LBPoint.Y = 0)
          then
            Height := SkinRect.Bottom - SkinRect.Top; 
        end;
    end;
end;

procedure TspSkinDBNavigator.SetSkinData;
var
  I: TspNavigateBtn;
begin
  inherited;
  for I := Low(Buttons) to High(Buttons) do
  with Buttons[I] do
  begin
    SkinData := Self.SkinData;
  end;
  InitHints;
end;

procedure TspSkinDBNavigator.SetBtnSkinDataName;
var
  I: TspNavigateBtn;
begin
  FBtnSkinDataName := Value;
  for I := Low(Buttons) to High(Buttons) do
  with Buttons[I] do
  begin
    SkinDataName := FBtnSkinDataName;
  end;
end;

procedure TspSkinDBNavigator.Paint;
begin
  if VisibleButtons = []
  then
    inherited;
end;

procedure TspSkinDBNavigator.InitButtons;
var
  I: TspNavigateBtn;
  Btn: TspNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TspNavButton.Create (Self);
    Btn.CanFocused := True;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    if FShowButtonGraphic
    then
      begin
        FmtStr(ResName, 'spdbn_%s', [BtnTypeName[I]]);
        if FAdditionalGlyphs then ResName := ResName + '1';
        Btn.Glyph.LoadFromResourceName(HInstance, ResName);
        Btn.NumGlyphs := 2;
      end;
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TspSkinDBNavigator.InitHints;
var
  I: Integer;
  J: TspNavigateBtn;
begin
  if not Assigned(FDefHints) then
  begin
    FDefHints := TStringList.Create;
    for J := Low(Buttons) to High(Buttons) do
      FDefHints.Add(BtnHints[J]);
  end;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := FDefHints[Ord(J)];
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TspSkinDBNavigator.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure TspSkinDBNavigator.SetHints(Value: TStrings);
begin
  if Value.Text = FDefHints.Text then
    FHints.Clear else
    FHints.Assign(Value);
end;

function TspSkinDBNavigator.GetHints: TStrings;
begin
  if (csDesigning in ComponentState) and not (csWriting in ComponentState) and
     not (csReading in ComponentState) and (FHints.Count = 0) then
    Result := FDefHints else
    Result := FHints;
end;

procedure TspSkinDBNavigator.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TspSkinDBNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
  if (Operation = opRemove) and (FSkinMessage <> nil) and
    (AComponent = FSkinMessage) then FSkinMessage := nil;
  if (Operation = opRemove) and (FImageList <> nil) and
    (AComponent = FImageList) then FImageList := nil;
end;

procedure TspSkinDBNavigator.SetVisible(Value: TspButtonSet);
var
  I: TspNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TspSkinDBNavigator.CalcMinSize(var W, H: Integer);
var
  Count: Integer;
  I: TspNavigateBtn;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  W := Max(W, Count * MinBtnSize.X);
  H := Max(H, MinBtnSize.Y);

  if Align = alNone then W := (W div Count) * Count;
end;

procedure TspSkinDBNavigator.SetSize(var W: Integer; var H: Integer);
var
  Count: Integer;
  I: TspNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  CalcMinSize(W, H);

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TspSkinDBNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then SetSize(W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TspSkinDBNavigator.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  W := Width;
  H := Height;
  SetSize(W, H);
end;

procedure TspSkinDBNavigator.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited;
  if (SWP_NOSIZE and Message.WindowPos.Flags) = 0 then
    CalcMinSize(Message.WindowPos.cx, Message.WindowPos.cy);
end;

procedure TspSkinDBNavigator.ClickHandler(Sender: TObject);
begin
  BtnClick (TspNavButton (Sender).Index);
end;

procedure TspSkinDBNavigator.BtnClick(Index: TspNavigateBtn);
var
  Msg: String;
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
    with DataSource.DataSet do
    begin
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert: Insert;
        nbEdit: Edit;
        nbCancel: Cancel;
        nbPost: Post;
        nbRefresh: Refresh;
        nbDelete:
          if (FSkinMessage <> nil)
          then
            begin
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Msg := SkinData.ResourceStrData.GetResStr('DB_DELETE_QUESTION')
              else
                Msg := SP_DB_DELETE_QUESTION;
              if not FConfirmDelete or
                (FSkinMessage.MessageDlg(Msg, mtConfirmation,
                   [mbOK, mbCancel], 0) <> idCancel) then Delete;
            end
          else
            begin
              if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
              then
                Msg := SkinData.ResourceStrData.GetResStr('DB_DELETE_QUESTION')
              else
                Msg := SP_DB_DELETE_QUESTION;
              if not FConfirmDelete or
                (MessageDlg(Msg, mtConfirmation,
                 mbOKCancel, 0) <> idCancel) then Delete;
            end;
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TspSkinDBNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TspSkinDBNavigator.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;
  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
end;

procedure TspSkinDBNavigator.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
  Buttons[nbInsert].Enabled := CanModify;
  Buttons[nbEdit].Enabled := CanModify and not FDataLink.Editing;
  Buttons[nbPost].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbRefresh].Enabled := CanModify;
end;

procedure TspSkinDBNavigator.ActiveChanged;
var
  I: TspNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TspSkinDBNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TspSkinDBNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBNavigator.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBNavigator.Loaded;
var
  W, H: Integer;
  i: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  ActiveChanged;
  GetSkinData;
  if (SkinData <> nil) and (FIndex <> -1) and (GetResizeMode = 1) and (FBtnSkinDataName <> '')
  then
    begin
      i := SkinData.GetControlIndex(FBtnSkinDataName);
      if i <> -1
      then
        with TspDataSkinButtonControl(FSD.CtrlList.Items[i]) do
        begin
          if (LBPoint.X = 0) and (LBPoint.Y = 0)
          then
            Height := SkinRect.Bottom - SkinRect.Top;
        end;
    end;
  SetShowButtonCaption(FShowButtonCaption);
end;


{TspNavButton}

destructor TspNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TspNavButton.GetSkinData;
begin
  inherited;
  MaskPicture := nil;
end;

procedure TspNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TspNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TspNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FMouseIn and FDown) and MouseCapture then
  begin
    try
      ButtonClick;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

{ TspNavDataLink }

constructor TspNavDataLink.Create(ANav: TspSkinDBNavigator);
begin
  inherited Create;
  FNavigator := ANav;
  VisualControl := True;
end;

destructor TspNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TspNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TspNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TspNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;

constructor TspSkinDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 105;
  Height := 105;
  TabStop := True;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FAutoDisplay := True;
  FCenter := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FQuickDraw := True;
  FForceBackground := False;
end;

destructor TspSkinDBImage.Destroy;
begin
  FPicture.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

function TspSkinDBImage.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBImage.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBImage.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBImage.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBImage.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBImage.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBImage.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TspSkinDBImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Palette;
end;

procedure TspSkinDBImage.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadPicture;
  end;
end;

procedure TspSkinDBImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TspSkinDBImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TspSkinDBImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TspSkinDBImage.CreateControlDefaultImage(B: TBitMap);
begin
  inherited;
  if not RollUpState then PaintImage(B.Canvas);
end;

procedure TspSkinDBImage.CreateControlSkinImage(B: TBitMap);
begin
  inherited;
  if not RollUpState then PaintImage(B.Canvas);
end;

procedure TspSkinDBImage.PaintImage;

procedure DrawFocus(Cnvs: TCanvas; R: TRect);
begin
  with Cnvs do
  begin
    Pen.Color := clWindowFrame;
    Pen.Mode := pmNot;
    Brush.Style := bsClear;
    Rectangle(R.Left, R.Top, R.Right, R.Bottom);
  end;
end;


var
  Size: TSize;
  DrawRect, R: TRect;
  S: string;
  DrawPict: TPicture;
  Form: TCustomForm;
  Pal: HPalette;
begin
  DrawRect := Rect(0, 0, Width, Height);
  AdjustClientRect(DrawRect);
  with Cnvs do
  begin
    Brush.Style := bsClear;
    if FPictureLoaded or (csPaintCopy in ControlState) then
    begin
      DrawPict := TPicture.Create;
      Pal := 0;
      try
        if (csPaintCopy in ControlState) and
          Assigned(FDataLink.Field) and FDataLink.Field.IsBlob
        then
          begin
            DrawPict.Assign(FDataLink.Field);
            if DrawPict.Graphic is TBitmap then
              DrawPict.Bitmap.IgnorePalette := QuickDraw;
          end
        else
          DrawPict.Assign(Picture);
      if Stretch
      then
        begin
         if (DrawPict.Graphic <> nil) and not DrawPict.Graphic.Empty
         then
            StretchDraw(DrawRect, DrawPict.Graphic);
        end
      else
        begin
          Windows.SetRect(R, DrawRect.Left, DrawRect.Top,
                     DrawRect.Left + DrawPict.Width,
                     DrawRect.Top + DrawPict.Height);
          if Center
          then
            OffsetRect(R, ((DrawRect.Right - DrawRect.Left) - DrawPict.Width) div 2,
            ((DrawRect.Bottom - DrawRect.Top) - DrawPict.Height) div 2);
          StretchDraw(R, DrawPict.Graphic);
        end;
      finally
        if Pal <> 0 then SelectPalette(Handle, Pal, True);
        DrawPict.Free;
      end;
    end;
    Form := GetParentForm(Self);
    if (Form <> nil) and (Form.ActiveControl = Self) and
      not (csDesigning in ComponentState) and
      not (csPaintCopy in ControlState)
    then
      DrawFocus(Cnvs, DrawRect);
  end;
end;

procedure TspSkinDBImage.PictureChanged(Sender: TObject);
begin
  if FPictureLoaded then FDataLink.Modified;
  FPictureLoaded := True;
  Invalidate;
end;

procedure TspSkinDBImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBImage.LoadPicture;
begin
  if not FPictureLoaded and (not Assigned(FDataLink.Field) or
    FDataLink.Field.IsBlob) then
    Picture.Assign(FDataLink.Field);
end;

procedure TspSkinDBImage.DataChange(Sender: TObject);
begin
  Picture.Graphic := nil;
  FPictureLoaded := False;
  if FAutoDisplay then LoadPicture;
end;

procedure TspSkinDBImage.UpdateData(Sender: TObject);
begin
  if Picture.Graphic is TBitmap then
     FDataLink.Field.Assign(Picture.Graphic) else
     FDataLink.Field.Clear;
end;

procedure TspSkinDBImage.CopyToClipboard;
begin
  if Picture.Graphic <> nil then Clipboard.Assign(Picture);
end;

procedure TspSkinDBImage.CutToClipboard;
begin
  if Picture.Graphic <> nil then
    if FDataLink.Edit then
    begin
      CopyToClipboard;
      Picture.Graphic := nil;
    end;
end;

procedure TspSkinDBImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_BITMAP) and FDataLink.Edit then
    Picture.Bitmap.Assign(Clipboard);
end;

procedure TspSkinDBImage.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TspSkinDBImage.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_INSERT:
      if ssShift in Shift then PasteFromClipBoard else
        if ssCtrl in Shift then CopyToClipBoard;
    VK_DELETE:
      if ssShift in Shift then CutToClipBoard;
  end;
end;

procedure TspSkinDBImage.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    ^X: CutToClipBoard;
    ^C: CopyToClipBoard;
    ^V: PasteFromClipBoard;
    #13: LoadPicture;
    #27: FDataLink.Reset;
  end;
end;

procedure TspSkinDBImage.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TspSkinDBImage.CMEnter(var Message: TCMEnter);
begin
  Invalidate; { Draw the focus marker }
  inherited;
end;

procedure TspSkinDBImage.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  Invalidate; { Erase the focus marker }
  inherited;
end;

procedure TspSkinDBImage.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if not FPictureLoaded then Invalidate;
end;

procedure TspSkinDBImage.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if TabStop and CanFocus then SetFocus;
  inherited;
end;

procedure TspSkinDBImage.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  LoadPicture;
  inherited;
end;

procedure TspSkinDBImage.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TspSkinDBImage.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TspSkinDBImage.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

procedure TspSkinDBImage.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

function TspSkinDBImage.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBImage.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspSkinDBRadioGroup }

constructor TspSkinDBRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FValues := TStringList.Create;
  FInClick := False;
end;

destructor TspSkinDBRadioGroup .Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FValues.Free;
  inherited Destroy;
end;

procedure TspSkinDBRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBRadioGroup .UseRightToLeftAlignment: Boolean;
begin
  Result := inherited UseRightToLeftAlignment;
end;

procedure TspSkinDBRadioGroup.DataChange(Sender: TObject);
begin
  if not FInClick then
  if FDataLink.Field <> nil then
    Value := FDataLink.Field.Text else
    Value := '';
end;

procedure TspSkinDBRadioGroup.UpdateData(Sender: TObject);
begin
  if FDataLink.Field <> nil then FDataLink.Field.Text := Value;
end;

function TspSkinDBRadioGroup.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBRadioGroup.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBRadioGroup.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBRadioGroup.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBRadioGroup.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBRadioGroup.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBRadioGroup.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TspSkinDBRadioGroup.GetButtonValue(Index: Integer): string;
begin
  if (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if Index < Items.Count then
    Result := Items[Index]
  else
    Result := '';
end;

procedure TspSkinDBRadioGroup.SetValue(const Value: string);
var
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
end;

procedure TspSkinDBRadioGroup.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    if ItemIndex >= 0 then
      TRadioButton(Controls[ItemIndex]).SetFocus else
      TRadioButton(Controls[0]).SetFocus;
    raise;
  end;
  inherited;
end;

procedure TspSkinDBRadioGroup.Click;
begin
  if not FInSetValue then
  begin
    inherited Click;
    FInClick := True;
    if ItemIndex >= 0
    then Value := GetButtonValue(ItemIndex);
    if not ReadOnly  and not FDataLink.Editing then FDataLink.Edit;
    if FDataLink.Editing
    then FDataLink.Modified;
    FInClick := False;
  end;
end;

procedure TspSkinDBRadioGroup.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
  DataChange(Self);
end;

procedure TspSkinDBRadioGroup.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  DataChange(Self);
end;

procedure TspSkinDBRadioGroup.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinDBRadioGroup.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    #8, ' ': FDataLink.Edit;
    #27: FDataLink.Reset;
  end;
end;

function TspSkinDBRadioGroup.CanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

function TspSkinDBRadioGroup.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (DataLink <> nil) and
    DataLink.ExecuteAction(Action);
end;

function TspSkinDBRadioGroup.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (DataLink <> nil) and
    DataLink.UpdateAction(Action);
end;

constructor TspSkinDBSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FInChange := False;
  FInDataChange := False;
end;

destructor TspSkinDBSpinEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  inherited Destroy;
end;

procedure TspSkinDBSpinEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBSpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBSpinEdit.Reset;
begin
  FDataLink.Reset;
  FEdit.SelectAll;
end;

procedure TspSkinDBSpinEdit.Change;
begin
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify
  then
    begin
      if not FDataLink.Editing then FDataLink.Edit; 
      FDataLink.Modified;
      inherited Change;
    end;
  FInChange := False;
end;

function TspSkinDBSpinEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBSpinEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBSpinEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBSpinEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBSpinEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBSpinEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBSpinEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBSpinEdit.DataChange(Sender: TObject);
begin
  FInDataChange := True; 
  if not FInChange then
  if FDataLink.Field <> nil
  then
    begin
      if (FDataLink.Field.Text <> '') and IsNumText(FDataLink.Field.Text)
      then
        Text := FDataLink.Field.Text
      else
        Value := MinValue;
    end
  else
    Value := MinValue;
  FInDataChange := False;
end;

procedure TspSkinDBSpinEdit.EditingChange(Sender: TObject);
begin
  FEdit.ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDBSpinEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := FEdit.Text;
end;

procedure TspSkinDBSpinEdit.EditEnter;
begin
  FEdit.ReadOnly := not FDataLink.CanModify;
  inherited;
end;

procedure TspSkinDBSpinEdit.EditExit;
begin
  if (FDataLink <> nil) and (FDataLink.Editing)
  then
    FDataLink.UpdateRecord;
  inherited;
end;

procedure TspSkinDBSpinEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBSpinEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBSpinEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspDataSourceLink }

constructor TspDataSourceLink.Create;
begin
  inherited Create;
  VisualControl := True;
end;

procedure TspDataSourceLink.ActiveChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.UpdateDataFields;
end;

procedure TspDataSourceLink.FocusControl(Field: TFieldRef);
begin
  if (Field^ <> nil) and (Field^ = FDBLookupControl.Field) and
    (FDBLookupControl <> nil) and FDBLookupControl.CanFocus then
  begin
    Field^ := nil;
    FDBLookupControl.SetFocus;
  end;
end;

procedure TspDataSourceLink.LayoutChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.UpdateDataFields;
end;

procedure TspDataSourceLink.RecordChanged(Field: TField);
begin
  if FDBLookupControl <> nil then FDBLookupControl.DataLinkRecordChanged(Field);
end;

{ TspListSourceLink }

constructor TspListSourceLink.Create;
begin
  inherited Create;
  VisualControl := True;
end;

procedure TspListSourceLink.ActiveChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.UpdateListFields;
end;

procedure TspListSourceLink.DataSetChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.ListLinkDataChanged;
end;

procedure TspListSourceLink.LayoutChanged;
begin
  if FDBLookupControl <> nil then FDBLookupControl.UpdateListFields;
end;

{ TspDBLookupControl }

function VarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;

var
  SearchTickCount: Integer = 0;



constructor TspDBLookupControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentColor := False;
  TabStop := True;
  FLookupSource := TDataSource.Create(Self);
  FDataLink := TspDataSourceLink.Create;
  FDataLink.FDBLookupControl := Self;
  FListLink := TspListSourceLink.Create;
  FListLink.FDBLookupControl := Self;
  FListFields := TList.Create;
  FKeyValue := Null;
end;

destructor TspDBLookupControl.Destroy;
begin
  inherited Destroy;
  FListFields.Free;
  FListFields := nil;
  if FListLink <> nil then
    FListLink.FDBLookupControl := nil;
  FListLink.Free;
  FListLink := nil;
  if FDataLink <> nil then
    FDataLink.FDBLookupControl := nil;
  FDataLink.Free;
  FDataLink := nil;
end;

function TspDBLookupControl.CanModify: Boolean;
begin
  Result := FListActive and not ReadOnly and ((FDataLink.DataSource = nil) or
    (FMasterField <> nil) and FMasterField.CanModify);
end;

procedure TspDBLookupControl.CheckNotCircular;
begin
  if FListLink.Active and FListLink.DataSet.IsLinkedTo(DataSource) then
    DatabaseError('Circular datalinks are not allowed');
end;

procedure TspDBLookupControl.CheckNotLookup;
begin
  if FLookupMode then DatabaseError('SPropDefByLookup');
  if FDataLink.DataSourceFixed then DatabaseError('SDataSourceFixed');
end;

procedure TspDBLookupControl.UpdateDataFields;
begin
  FDataField := nil;
  FMasterField := nil;
  if FDataLink.Active and (FDataFieldName <> '') then
  begin
    CheckNotCircular;
    FDataField := GetFieldProperty(FDataLink.DataSet, Self, FDataFieldName);
    if FDataField.FieldKind = fkLookup then
      FMasterField := GetFieldProperty(FDataLink.DataSet, Self, FDataField.KeyFields)
    else
      FMasterField := FDataField;
  end;
  SetLookupMode((FDataField <> nil) and (FDataField.FieldKind = fkLookup));
  DataLinkRecordChanged(nil);
end;

procedure TspDBLookupControl.DataLinkRecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FMasterField) then
    if FMasterField <> nil then
      SetKeyValue(FMasterField.Value) else
      SetKeyValue(Null);
end;

function TspDBLookupControl.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TspDBLookupControl.GetKeyFieldName: string;
begin
  if FLookupMode then Result := '' else Result := FKeyFieldName;
end;

function TspDBLookupControl.GetListSource: TDataSource;
begin
  if FLookupMode then Result := nil else Result := FListLink.DataSource;
end;

function TspDBLookupControl.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspDBLookupControl.KeyValueChanged;
begin
end;

procedure TspDBLookupControl.UpdateListFields;
var
  DataSet: TDataSet;
  ResultField: TField;
begin
  FListActive := False;
  FKeyField := nil;
  FListField := nil;
  FListFields.Clear;
  if FListLink.Active and (FKeyFieldName <> '') then
  begin
    CheckNotCircular;
    DataSet := FListLink.DataSet;
    FKeyField := GetFieldProperty(DataSet, Self, FKeyFieldName);
    try
      DataSet.GetFieldList(FListFields, FListFieldName);
    except
      DatabaseErrorFmt('Field ''%s'' not found', [Self.Name, FListFieldName]);
    end;
    if FLookupMode then
    begin
      ResultField := GetFieldProperty(DataSet, Self, FDataField.LookupResultField);
      if FListFields.IndexOf(ResultField) < 0 then
        FListFields.Insert(0, ResultField);
      FListField := ResultField;
    end else
    begin
      if FListFields.Count = 0 then FListFields.Add(FKeyField);
      if (FListFieldIndex >= 0) and (FListFieldIndex < FListFields.Count) then
        FListField := FListFields[FListFieldIndex] else
        FListField := FListFields[0];
    end;
    FListActive := True;
  end;
end;

procedure TspDBLookupControl.ListLinkDataChanged;
begin
end;

function TspDBLookupControl.LocateKey: Boolean;
var
  KeySave: Variant;
begin
  Result := False;
  try
    KeySave := FKeyValue;
    if not VarIsNull(FKeyValue) and FListLink.DataSet.Active and
      FListLink.DataSet.Locate(FKeyFieldName, FKeyValue, []) then
    begin
      Result := True;
      FKeyValue := KeySave;
    end;
  except
  end;
end;

procedure TspDBLookupControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then DataSource := nil;
    if (FListLink <> nil) and (AComponent = ListSource) then ListSource := nil;
  end;
end;

procedure TspDBLookupControl.ProcessSearchKey(Key: Char);
var
  TickCount: Integer;
  S: string;
  CharMsg: TMsg;
begin
  if (FListField <> nil) and (FListField.FieldKind in [fkData, fkInternalCalc]) and
    (FListField.DataType in [ftString, ftWideString]) then
    case Key of
      #8, #27: SearchText := '';
      #32..#255:
        if CanModify then
        begin
          TickCount := GetTickCount;
          if TickCount - SearchTickCount > 2000 then SearchText := '';
          SearchTickCount := TickCount;
          if SysLocale.FarEast and (Key in LeadBytes) then
            if PeekMessage(CharMsg, Handle, WM_CHAR, WM_CHAR, PM_REMOVE) then
            begin
              if CharMsg.Message = WM_Quit then
              begin
                PostQuitMessage(CharMsg.wparam);
                Exit;
              end;
              SearchText := SearchText + Key;
              Key := Char(CharMsg.wParam);
            end;
          if Length(SearchText) < 32 then
          begin
            S := SearchText + Key;
            try
              if FListLink.DataSet.Locate(FListField.FieldName, S,
                [loCaseInsensitive, loPartialKey]) then
              begin
                SelectKeyValue(FKeyField.Value);
                SearchText := S;
              end;
            except
              { If you attempt to search for a string larger than what the field
                can hold, and exception will be raised.  Just trap it and
                reset the SearchText back to the old value. }
              SearchText := S;
            end;
          end;
        end;
    end;
end;

procedure TspDBLookupControl.SelectKeyValue(const Value: Variant);
begin
  if FMasterField <> nil then
  begin
    if FDataLink.Edit then
      FMasterField.Value := Value;
  end else
    SetKeyValue(Value);
  Repaint;
  Click;
end;

procedure TspDBLookupControl.SetDataFieldName(const Value: string);
begin
  if FDataFieldName <> Value then
  begin
    FDataFieldName := Value;
    UpdateDataFields;
  end;
end;

procedure TspDBLookupControl.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TspDBLookupControl.SetKeyFieldName(const Value: string);
begin
  CheckNotLookup;
  if FKeyFieldName <> Value then
  begin
    FKeyFieldName := Value;
    UpdateListFields;
  end;
end;

procedure TspDBLookupControl.SetKeyValue(const Value: Variant);
begin
  if not VarEquals(FKeyValue, Value) then
  begin
    FKeyValue := Value;
    KeyValueChanged;
  end;
end;

procedure TspDBLookupControl.SetListFieldName(const Value: string);
begin
  if FListFieldName <> Value then
  begin
    FListFieldName := Value;
    UpdateListFields;
  end;
end;

procedure TspDBLookupControl.SetListSource(Value: TDataSource);
begin
  CheckNotLookup;
  FListLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TspDBLookupControl.SetLookupMode(Value: Boolean);
begin
  if FLookupMode <> Value then
    if Value then
    begin
      FMasterField := GetFieldProperty(FDataField.DataSet, Self, FDataField.KeyFields);
      FLookupSource.DataSet := FDataField.LookupDataSet;
      FKeyFieldName := FDataField.LookupKeyFields;
      FLookupMode := True;
      FListLink.DataSource := FLookupSource;
    end else
    begin
      FListLink.DataSource := nil;
      FLookupMode := False;
      FKeyFieldName := '';
      FLookupSource.DataSet := nil;
      FMasterField := FDataField;
    end;
end;

procedure TspDBLookupControl.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TspDBLookupControl.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TspDBLookupControl.WMKillFocus(var Message: TMessage);
begin
  FHasFocus := False;
  inherited;
  Invalidate;
end;

procedure TspDBLookupControl.WMSetFocus(var Message: TMessage);
begin
  SearchText := '';
  FHasFocus := True;
  inherited;
  Invalidate;
end;

procedure TspDBLookupControl.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TspDBLookupControl.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspDBLookupControl.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspDBLookupControl.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TspDBLookupControl.WMKeyDown(var Message: TWMKeyDown);
begin
  if (FNullValueKey <> 0) and CanModify and (FNullValueKey = ShortCut(Message.CharCode,
     KeyDataToShiftState(Message.KeyData))) then
  begin
    FDataLink.Edit;
    if Assigned(Field) then Field.Clear;
    FKeyValue := null;
    KeyValueChanged;
    Message.CharCode := 0;
  end;
  inherited;
end;

{ TspSkinDBLookupListBox }

constructor TspSkinDBLookupListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  FSkinDataName := 'listbox';
  FDefaultItemHeight := 20;
  FUseSkinItemHeight := True;
  FScrollBar := nil;
  FStopThumbScroll := False;
  Width := 100;
  FRowCount := 7;
end;

destructor TspSkinDBLookupListBox.Destroy;
begin
  inherited;
end;

procedure TspSkinDBLookupListBox.ShowScrollBar;
begin
  if FScrollBar = nil
  then
    begin
      FScrollBar := TspSkinScrollBar.Create(Self);
      FScrollBar.Kind := sbVertical;
      FScrollBar.Kind := sbVertical;
      if FIndex <> -1
      then
        FScrollBar.SkinDataName := ScrollBarName;
      FScrollBar.SkinData := SkinData;
      FScrollBar.Parent := Self;
      FScrollBar.DefaultWidth := 19;
      FScrollBar.OnChange := OnScrollBarChange;
      FScrollBar.OnUpButtonClick := OnScrollBarUpButtonClick;
      FScrollBar.OnDownButtonClick := OnScrollBarDownButtonClick;
      AlignScrollBar;
      RePaint;
    end;
end;

procedure TspSkinDBLookupListBox.HideScrollBar;
begin
  if FScrollBar <> nil
  then
    begin
      FScrollBar.Visible := False;
      FScrollBar.Free;
      FScrollBar := nil;
      RePaint;
    end;
end;

type
  TXScrollBar = class(TspSkinScrollBar);

procedure TspSkinDBLookupListBox.OnScrollBarUpButtonClick;
begin
  FStopThumbScroll := True;
  SendMessage(Handle, WM_VSCROLL,
    MakeWParam(SB_LINEDOWN, FScrollBar.Position), 0);
end;

procedure TspSkinDBLookupListBox.OnScrollBarDownButtonClick(Sender: TObject);
begin
  FStopThumbScroll := True;
  SendMessage(Handle, WM_VSCROLL,
    MakeWParam(SB_LINEUP, FScrollBar.Position), 0);
end;

procedure TspSkinDBLookupListBox.OnScrollBarChange;
begin
  if not FStopThumbScroll then
  SendMessage(Handle, WM_VSCROLL,
              MakeWParam(SB_THUMBPOSITION, FScrollBar.Position), 0);
  FStopThumbScroll := False;            
end;


procedure TspSkinDBLookupListBox.AlignScrollBar;
begin
  if FScrollBar <> nil
  then
    FScrollBar.SetBounds(ClientWidth - FScrollBar.Width, 0,
                         FScrollBar.Width, ClientHeight);
end;

procedure TspSkinDBLookupListBox.ChangeSkinData;
begin
  inherited;
  if FScrollBar <> nil
  then
    begin
      if FIndex <> -1
      then
        begin
          FScrollBar.SkinDataName := ScrollBarName;
          FScrollBar.SkinData := SkinData;
        end
      else
        begin
          FScrollBar.SkinDataName := '';
          FScrollBar.ChangeSkinData;
        end;
    end;
  SetBounds(Left, Top, Width, Height);
  SendMessage(Handle, WM_NCPAINT, 0, 0);  
end;

function TspSkinDBLookupListBox.GetItemHeight;
begin
  if (FIndex = -1) or not FUseSkinItemHeight
  then
    Result := FDefaultItemHeight
  else
    Result := RectHeight(SItemRect);
end;

function TspSkinDBLookupListBox.GetItemWidth;
begin
  Result := ClientWidth;
  if FScrollBar <> nil
  then
    Result := Result - FScrollBar.Width;
end;

function TspSkinDBLookupListBox.GetBorderHeight;
begin
  if FIndex = -1
  then
    Result := 4
  else
    Result := RectHeight(SkinRect) - RectHeight(ClRect);
end;

procedure TspSkinDBLookupListBox.GetSkinData;
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
        Self.ScrollBarName := VScrollBarName;
      end;
end;

procedure TspSkinDBLookupListBox.WMNCCALCSIZE;
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

procedure TspSkinDBLookupListBox.FramePaint(C: TCanvas);
var
  R: TRect;
  LeftB, TopB, RightB, BottomB: TBitMap;
  OffX, OffY: Integer;
begin
  GetSkinData;
  if FIndex = -1
  then
    with C do
    begin
      Brush.Style := bsClear;
      Pen.Color := clBtnFace;
      Rectangle(1, 1, Width-1, Height-1);
      R := Rect(0, 0, Width, Height);
      Frame3D(C, R, clBtnShadow, clBtnShadow, 1);
      Exit;
    end;

  LeftB := TBitMap.Create;
  TopB := TBitMap.Create;
  RightB := TBitMap.Create;
  BottomB := TBitMap.Create;

  OffX := Width - RectWidth(SkinRect);
  OffY := Height - RectHeight(SkinRect);

  CreateSkinBorderImages(LTPt, RTPt, LBPt, RBPt, CLRect,
     NewLtPoint, NewRTPoint, NewLBPoint, NewRBPoint, NewCLRect,
     LeftB, TopB, RightB, BottomB, Picture, SkinRect, Width, Height,
     LeftStretch, TopStretch, RightStretch, BottomStretch);

  C.Draw(0, 0, TopB);
  C.Draw(0, TopB.Height, LeftB);
  C.Draw(Width - RightB.Width, TopB.Height, RightB);
  C.Draw(0, Height - BottomB.Height, BottomB);

  TopB.Free;
  LeftB.Free;
  RightB.Free;
  BottomB.Free;
end;

procedure TspSkinDBLookupListBox.WMNCPAINT;
var
  DC: HDC;
  C: TCanvas;
begin
  DC := GetWindowDC(Handle);
  C := TControlCanvas.Create;
  C.Handle := DC;
  try
    FramePaint(C);
  finally
    C.Free;
    ReleaseDC(Handle, DC);
  end;
end;

procedure TspSkinDBLookupListBox.SetDefaultItemHeight;
begin
  if Value > 0
  then
    begin
      FDefaultItemHeight := Value;
      if (FIndex = -1) or not FUseSkinItemHeight
      then
        SetBounds(Left, Top, Width, Height);
    end;  
end;

procedure TspSkinDBLookupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TspSkinDBLookupListBox.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollBar;
end;

function TspSkinDBLookupListBox.GetKeyIndex: Integer;
var
  FieldValue: Variant;
begin
  if not VarIsNull(FKeyValue) then
    for Result := 0 to FRecordCount - 1 do
    begin
      ListLink.ActiveRecord := Result;
      FieldValue := FKeyField.Value;
      ListLink.ActiveRecord := FRecordIndex;
      if VarEquals(FieldValue, FKeyValue) then Exit;
    end;
  Result := -1;
end;

procedure TspSkinDBLookupListBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  Delta, KeyIndex: Integer;
begin
  inherited KeyDown(Key, Shift);
  if CanModify then
  begin
    Delta := 0;
    case Key of
      VK_UP, VK_LEFT: Delta := -1;
      VK_DOWN, VK_RIGHT: Delta := 1;
      VK_PRIOR: Delta := 1 - FRowCount;
      VK_NEXT: Delta := FRowCount - 1;
      VK_HOME: Delta := -Maxint;
      VK_END: Delta := Maxint;
    end;
    if Delta <> 0 then
    begin
      SearchText := '';
      if Delta = -Maxint then ListLink.DataSet.First else
        if Delta = Maxint then ListLink.DataSet.Last else
        begin
          KeyIndex := GetKeyIndex;
          if KeyIndex >= 0 then
            ListLink.DataSet.MoveBy(KeyIndex - FRecordIndex)
          else
          begin
            KeyValueChanged;
            Delta := 0;
          end;
          ListLink.DataSet.MoveBy(Delta);
        end;
      SelectCurrent;
    end;
  end;
end;

procedure TspSkinDBLookupListBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  ProcessSearchKey(Key);
end;

procedure TspSkinDBLookupListBox.KeyValueChanged;
begin
  if ListActive and not FLockPosition then
    if not LocateKey then ListLink.DataSet.First;
  if FListField <> nil then
    FSelectedItem := FListField.DisplayText else
    FSelectedItem := '';
end;

procedure TspSkinDBLookupListBox.UpdateListFields;
begin
  try
    inherited;
  finally
    if ListActive then KeyValueChanged else ListLinkDataChanged;
  end;
end;

procedure TspSkinDBLookupListBox.ListLinkDataChanged;
begin
  if ListActive then
  begin
    FRecordIndex := ListLink.ActiveRecord;
    FRecordCount := ListLink.RecordCount;
    FKeySelected := not VarIsNull(FKeyValue) or
      not ListLink.DataSet.BOF;
  end else
  begin
    FRecordIndex := 0;
    FRecordCount := 0;
    FKeySelected := False;
  end;
  if HandleAllocated then
  begin
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TspSkinDBLookupListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SearchText := '';
    if not FPopup then
    begin
      SetFocus;
      if not HasFocus then Exit;
    end;
    if CanModify then
      if ssDouble in Shift then
      begin
        if FRecordIndex = Y div GetItemHeight then DblClick;
      end else
      begin
        MouseCapture := True;
        FTracking := True;
        SelectItemAt(X, Y);
      end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TspSkinDBLookupListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FTracking then
  begin
    SelectItemAt(X, Y);
    FMousePos := Y;
    TimerScroll;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TspSkinDBLookupListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FTracking then
  begin
    StopTracking;
    SelectItemAt(X, Y);
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TspSkinDBLookupListBox.CreateControlDefaultImage(B: TBitMap);

procedure DrawDefaultItem(R: TRect; ASelected, AFocused: Boolean;
                          S: String);
begin
  if ASelected
  then
    with B.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clHighLight;
      FillRect(R);
      Brush.Style := bsClear;
      Font.Color := clHighLightText;
    end
  else
    B.Canvas.Font.Color := DefaultFont.Color;
  //
  InflateRect(R, -2, -2);
  SPDrawText2(B.Canvas, S, R);
  InflateRect(R, 2, 2);
  //
  if AFocused
  then
    B.Canvas.DrawFocusRect(R);
end;

var
  I, J, LastFieldIndex: Integer;
  R: TRect;
  Selected: Boolean;
  Field: TField;
  S: String;
  W, TextWidth: Integer;
begin
  inherited;

  B.Width := GetItemWidth;

  with B.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clWindow;
    FillRect(ClientRect);
    Font := FDefaultFont;
    Brush.Style := bsClear;
  end;

  TextWidth := B.Canvas.TextWidth('0');

  R.Left := 0;
  R.Right := B.Width;
  LastFieldIndex := ListFields.Count - 1;
  for I := 0 to FRowCount - 1 do
  begin
    Selected := not FKeySelected and (I = 0);
    R.Top := I * GetItemHeight;
    R.Bottom := R.Top + GetItemHeight;
    if I < FRecordCount then
    begin
      ListLink.ActiveRecord := I;
      if not VarIsNull(FKeyValue) and
        VarEquals(FKeyField.Value, FKeyValue)
      then
        Selected := True;
      if LastFieldIndex = 0
      then
        begin
          Field := ListFields[0];
          DrawDefaultItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText);
        end
      else
        begin
          R.Left := 0;
          R.Right := 0;
          for J := 0 to LastFieldIndex do
          begin
            Field := ListFields[J];
            W := Field.DisplayWidth * TextWidth + 4;
            R.Right := R.Left + W;
            if R.Right > B.Width then R.Right := B.Width;
            if (J = LastFieldIndex) and (R.Right < B.Width)
            then R.Right := B.Width; 
            if RectWidth(R) > 0
            then
              DrawDefaultItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText);
            R.Left := R.Right;
          end;
        end;
    end;
  end;
  if FRecordCount <> 0 then ListLink.ActiveRecord := FRecordIndex;
end;

procedure TspSkinDBLookupListBox.CreateControlSkinImage(B: TBitMap);

procedure DrawSkinItem(R: TRect; ASelected, AFocused: Boolean;
                       S: String);

var
  Buffer: TBitMap;
  TR: TRect;
begin
  if AFocused or ASelected
  then
    begin
      Buffer := TBitMap.Create;
      with Buffer.Canvas do
      begin
        if UseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Height := FontHeight;
            Font.Style := FontStyle;
          end
        else
          Font.Assign(DefaultFont);

       if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
       then
         Font.Charset := SkinData.ResourceStrData.CharSet
       else
         Font.CharSet := DefaultFont.CharSet;
          
        if AFocused
        then Font.Color := FocusFontColor
        else Font.Color := ActiveFontColor;
        Brush.Style := bsClear;
      end;
      if AFocused
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
        FocusItemRect, RectWidth(R), RectHeight(R), StretchEffect)
      else
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
        ActiveItemRect, RectWidth(R), RectHeight(R), StretchEffect);
      TR := ItemTextRect;
      Inc(TR.Right, Buffer.Width - RectWidth(SItemRect));
      SPDrawText2(Buffer.Canvas, S, TR);
      B.Canvas.Draw(R.Left, R.Top, Buffer);
      Buffer.Free;
    end
  else
    begin
      B.Canvas.Brush.Style := bsClear;
      InflateRect(R, -2, -2);
      SPDrawText2(B.Canvas, S, R);
    end;
end;

procedure DrawStretchSkinItem(R: TRect; ASelected, AFocused: Boolean;
                       S: String);

var
  Buffer, Buffer2: TBitMap;
  TR: TRect;
  OX, OY: Integer;
begin
  if AFocused or ASelected
  then
    begin
      Buffer := TBitMap.Create;
      if AFocused
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
        FocusItemRect, RectWidth(R), RectHeight(SItemRect), StretchEffect)
      else
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
        ActiveItemRect, RectWidth(R), RectHeight(SItemRect), StretchEffect);
      TR := ItemTextRect;
      OX :=  RectWidth(R) - RectWidth(SItemRect);
      OY :=  RectHeight(R) - RectHeight(SItemRect);
      Inc(TR.Right, OX);
      Inc(TR.Bottom, OY);

      Buffer2 := TBitMap.Create;
      Buffer2.Width := RectWidth(R);
      Buffer2.Height := RectHeight(R);
      Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
      Buffer.Free;
      with Buffer2.Canvas do
      begin
       if UseSkinFont
        then
          begin
            Font.Name := FontName;
            Font.Height := FontHeight;
            Font.Style := FontStyle;
          end
        else
          Font.Assign(DefaultFont);

       if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
       then
         Font.Charset := SkinData.ResourceStrData.CharSet
       else
         Font.CharSet := DefaultFont.CharSet;

        if AFocused
        then Font.Color := FocusFontColor
        else Font.Color := ActiveFontColor;
        Brush.Style := bsClear;
      end;
      SPDrawText2(Buffer2.Canvas, S, TR);
      B.Canvas.Draw(R.Left, R.Top, Buffer2);
      Buffer2.Free;
    end
  else
    begin
      InflateRect(R, -2, -2);
      B.Canvas.Brush.Style := bsClear;
      SPDrawText2(B.Canvas, S, R);
    end;
end;

procedure PaintBG;
var
  w, h, rw, rh, XCnt, YCnt, X, Y, XO, YO: Integer;
begin
  w := RectWidth(ClRect);
  h := RectHeight(ClRect);
  rw := B.Width;
  rh := B.Height;
  with B.Canvas do
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
  end;
end;

var
  I, J, LastFieldIndex: Integer;
  R: TRect;
  Selected: Boolean;
  Field: TField;
  W, TextWidth: Integer;
begin

  B.Width := GetItemWidth;

  if FUseSkinFont
  then
    begin
      with B.Canvas do
      begin
        Font.Name := FontName;
        Font.Height := FontHeight;
        Font.Style := FontStyle;
        Font.Color := FontColor;
        Brush.Style := bsClear;
      end;
    end
  else
    B.Canvas.Font.Assign(FDefaultFont);

  B.Canvas.Font.Color := FontColor;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    B.Canvas.Font.Charset := SkinData.ResourceStrData.CharSet
  else
    B.Canvas.Font.CharSet := DefaultFont.CharSet;

  TextWidth := B.Canvas.TextWidth('0');

  if not IsNullRect(ClRect) and (ClientWidth > 0) and (ClientHeight > 0)
  then
    PaintBG;
  R.Left := 0;
  R.Right := B.Width;
  LastFieldIndex := ListFields.Count - 1;
  for I := 0 to FRowCount - 1 do
  begin
    Selected := not FKeySelected and (I = 0);
    R.Top := I * GetItemHeight;
    R.Bottom := R.Top + GetItemHeight;
    if I < FRecordCount then
    begin
      ListLink.ActiveRecord := I;
      if not VarIsNull(FKeyValue) and
        VarEquals(FKeyField.Value, FKeyValue)
      then
        Selected := True;
      //
      if LastFieldIndex = 0
      then
        begin
          Field := ListFields[0];
          if FUseSkinItemHeight
          then
            DrawSkinItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText)
          else
            DrawStretchSkinItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText);
        end
      else
        begin
          R.Left := 0;
          R.Right := 0;
          for J := 0 to LastFieldIndex do
          begin
            Field := ListFields[J];
            W := Field.DisplayWidth * TextWidth + RectWidth(SItemRect) -
                 RectWidth(ItemTextRect);
            R.Right := R.Left + W;
            if R.Right > B.Width then R.Right := B.Width;
            if (J = LastFieldIndex) and (R.Right < B.Width)
            then R.Right := B.Width;
            if RectWidth(R) > 0
            then
              if FUseSkinItemHeight
              then
                DrawSkinItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText)
              else
                DrawStretchSkinItem(R, Selected, Selected and (HasFocus or FPopup), Field.DisplayText);
            R.Left := R.Right;
          end;
        end;
    end;
  end;
  if FRecordCount <> 0 then ListLink.ActiveRecord := FRecordIndex;
end;

procedure TspSkinDBLookupListBox.SelectCurrent;
begin
  FLockPosition := True;
  try
    SelectKeyValue(FKeyField.Value);
  finally
    FLockPosition := False;
  end;
end;

procedure TspSkinDBLookupListBox.SelectItemAt(X, Y: Integer);
var
  Delta: Integer;
begin
  if Y < 0 then Y := 0;
  if Y > ClientHeight then Y := ClientHeight;
  Delta := Y div GetItemHeight - FRecordIndex;
  ListLink.DataSet.MoveBy(Delta);
  SelectCurrent;
end;

procedure TspSkinDBLookupListBox.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
    RowCount := RowCount;
  end;
end;

procedure TspSkinDBLookupListBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  TextHeight, BorderHeight: Integer;
begin
  BorderHeight := GetBorderHeight;
  TextHeight := GetItemHeight;
  if Align = alNone
  then
    inherited SetBounds(ALeft, ATop, AWidth, FRowCount * TextHeight + BorderHeight)
  else
    begin
      FRowCount := (AHeight - BorderHeight) div TextHeight;
      inherited;
    end;
  if ListLink.BufferCount <> FRowCount then
  begin
    ListLink.BufferCount := FRowCount;
    ListLinkDataChanged;
  end;
  if HandleAllocated
  then
  SendMessage(Handle, WM_NCPAINT, 0, 0);
  AlignScrollBar;
end;

function TspSkinDBLookupListBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBLookupListBox.SetRowCount(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 100 then Value := 100;
  FRowCount := Value;
  Height := Value * GetItemHeight;
end;

procedure TspSkinDBLookupListBox.StopTimer;
begin
  if FTimerActive then
  begin
    KillTimer(Handle, 1);
    FTimerActive := False;
  end;
end;

procedure TspSkinDBLookupListBox.StopTracking;
begin
  if FTracking then
  begin
    StopTimer;
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TspSkinDBLookupListBox.TimerScroll;
var
  Delta, Distance, Interval: Integer;
begin
  Delta := 0;
  Distance := 0;
  if FMousePos < 0 then
  begin
    Delta := -1;
    Distance := -FMousePos;
  end;
  if FMousePos >= ClientHeight then
  begin
    Delta := 1;
    Distance := FMousePos - ClientHeight + 1;
  end;
  if Delta = 0 then StopTimer else
  begin
    if ListLink.DataSet.MoveBy(Delta) <> 0 then SelectCurrent;
    Interval := 200 - Distance * 15;
    if Interval < 0 then Interval := 0;
    SetTimer(Handle, 1, Interval, nil);
    FTimerActive := True;
  end;
end;

procedure TspSkinDBLookupListBox.UpdateScrollBar;
var
  Pos, Max: Integer;
  ScrollInfo: TScrollInfo;
begin
  Pos := 0;
  Max := 0;

  if (FRowCount <> FRecordCount) or (KeyField = '') or
     (ListLink.DataSet = nil)
  then HideScrollBar
  else ShowScrollBar;

  if (FScrollBar <> nil)
  then
    begin
      if FRecordCount = FRowCount then
      begin
        Max := 4;
        if not ListLink.DataSet.BOF then
        if not ListLink.DataSet.EOF then Pos := 2 else Pos := 4;
      end;
      FScrollBar.SetRange(0, Max, Pos, 0);
    end;
end;

procedure TspSkinDBLookupListBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Height := Height;
end;

procedure TspSkinDBLookupListBox.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TspSkinDBLookupListBox.WMTimer(var Message: TMessage);
begin
  TimerScroll;
end;

procedure TspSkinDBLookupListBox.WMVScroll(var Message: TWMVScroll);
begin
  SearchText := '';
  if ListLink.DataSet = nil then
    Exit;
  with Message, ListLink.DataSet do
    case ScrollCode of
      SB_LINEUP: MoveBy(-FRecordIndex - 1);
      SB_LINEDOWN: MoveBy(FRecordCount - FRecordIndex);
      SB_PAGEUP: MoveBy(-FRecordIndex - FRecordCount + 1);
      SB_PAGEDOWN: MoveBy(FRecordCount - FRecordIndex + FRecordCount - 2);
      SB_THUMBPOSITION:
        begin
          case Pos of
            0: First;
            1: MoveBy(-FRecordIndex - FRecordCount + 1);
            2: Exit;
            3: MoveBy(FRecordCount - FRecordIndex + FRecordCount - 2);
            4: Last;
          end;
        end;
      SB_BOTTOM: Last;
      SB_TOP: First;
    end;
end;

function TspSkinDBLookupListBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBLookupListBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspPopupDataList }

constructor TspPopupDataList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  FPopup := True;
end;

procedure TspPopupDataList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TspPopupDataList.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

{ TspSkinDBLookupComboBox }

constructor TspSkinDBLookupComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDefaultColor := clWindow;
  Width := 145;
  Height := 20;
  FDataList := TspPopupDataList.Create(Self);
  FDataList.Visible := False;
  FDataList.TabStop := False;
  FDataList.Parent := Self;
  FDataList.OnMouseUp := ListMouseUp;
  FButtonWidth := 17;
  FDropDownRows := 7;
  FDefaultHeight := 20;
  FSkinDataName := 'combobox';
  FMouseIn := False;
end;

procedure TspSkinDBLookupComboBox.SetDefaultColor(Value: TColor);
begin
  FDefaultColor := Value;
  if FIndex = -1 then Invalidate;
end;

procedure TspSkinDBLookupComboBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseIn := True;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect) then Invalidate;
end;

procedure TspSkinDBLookupComboBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseIn := False;
  if (FIndex <> -1) and not IsNullRect(ActiveSkinRect) then Invalidate;
end;


function TspSkinDBLookupComboBox.GetListBoxDefaultItemHeight: Integer;
begin
  Result := FDataList.DefaultItemHeight;
end;

procedure TspSkinDBLookupComboBox.SetListBoxDefaultItemHeight(Value: Integer);
begin
  FDataList.DefaultItemHeight := Value;
end;

function TspSkinDBLookupComboBox.GetListBoxUseSkinFont: Boolean;
begin
  Result := FDataList.UseSkinFont;
end;

procedure TspSkinDBLookupComboBox.SetListBoxUseSkinFont(Value: Boolean);
begin
  FDataList.UseSkinFont := Value;
end;

function TspSkinDBLookupComboBox.GetListBoxUseSkinItemHeight: Boolean;
begin
  Result := FDataList.UseSkinItemHeight;
end;

procedure TspSkinDBLookupComboBox.SetListBoxUseSkinItemHeight(Value: Boolean);
begin
  FDataList.UseSkinItemHeight := Value;
end;

procedure TspSkinDBLookupComboBox.GetSkinData;
begin
  inherited;
  if FIndex <> -1
  then
    if TspDataSkinControl(FSD.CtrlList.Items[FIndex]) is TspDataSkinComboBox
    then
      with TspDataSkinComboBox(FSD.CtrlList.Items[FIndex]) do
      begin
        Self.ActiveSkinRect := ActiveSkinRect;
        Self.SItemRect := SItemRect;
        Self.ActiveItemRect := ActiveItemRect;
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
        Self.ActiveFontColor := ActiveFontColor;

        Self.ButtonRect := ButtonRect;
        Self.ActiveButtonRect := ActiveButtonRect;
        Self.DownButtonRect := DownButtonRect;

        Self.StretchEffect := StretchEffect;
        Self.ItemStretchEffect := ItemStretchEffect;
        Self.FocusItemStretchEffect := FocusItemStretchEffect;
        Self.UnEnabledButtonRect := UnEnabledButtonRect;

        Self.ListBoxName := ListBoxName;
      end;
end;

procedure TspSkinDBLookupComboBox.CloseUp(Accept: Boolean);
var
  ListValue: Variant;
begin
  if FListVisible then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    SetFocus;
    ListValue := FDataList.KeyValue;
    SetWindowPos(FDataList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    FDataList.Visible := False;
    FDataList.ListSource := nil;
    Invalidate;
    SearchText := '';
    if Accept and CanModify then SelectKeyValue(ListValue);
    if Assigned(FOnCloseUp) then FOnCloseUp(Self);
  end;
end;

procedure TspSkinDBLookupComboBox.CMDialogKey(var Message: TCMDialogKey);
begin
  if (Message.CharCode in [VK_RETURN, VK_ESCAPE]) and FListVisible then
  begin
    CloseUp(Message.CharCode = VK_RETURN);
    Message.Result := 1;
  end else
    inherited;
end;

procedure TspSkinDBLookupComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TspSkinDBLookupComboBox.DropDown;
var
  P: TPoint;
  I, Y: Integer;
  S: string;
  ADropDownAlign: TDropDownAlign;
begin
  if not FListVisible and ListActive then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    if FDropDownWidth > 0 then
      FDataList.Width := FDropDownWidth else
      FDataList.Width := Width;
    FDataList.ReadOnly := not CanModify;
    if (ListLink.DataSet.RecordCount > 0) and
       (FDropDownRows > ListLink.DataSet.RecordCount) then
      FDataList.RowCount := ListLink.DataSet.RecordCount else
      FDataList.RowCount := FDropDownRows;
    FDataList.KeyField := FKeyFieldName;
    for I := 0 to ListFields.Count - 1 do
      S := S + TField(ListFields[I]).FieldName + ';';
    FDataList.ListField := S;
    FDataList.ListFieldIndex := ListFields.IndexOf(FListField);
    FDataList.ListSource := ListLink.DataSource;
    FDataList.KeyValue := KeyValue;
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FDataList.Height > Screen.Height then Y := P.Y - FDataList.Height;
    ADropDownAlign := FDropDownAlign;
    { This alignment is for the ListField, not the control }
    if DBUseRightToLeftAlignment(Self, FListField) then
    begin
      if ADropDownAlign = daLeft then
        ADropDownAlign := daRight
      else if ADropDownAlign = daRight then
        ADropDownAlign := daLeft;
    end;
    case ADropDownAlign of
      daRight: Dec(P.X, FDataList.Width - Width);
      daCenter: Dec(P.X, (FDataList.Width - Width) div 2);
    end;
    FDataList.DefaultFont := DefaultFont;
    if FIndex = -1
    then
      begin
        FDataList.SkinDataName := ''
      end
    else
      FDataList.SkinDataName := ListBoxName;
    FDataList.SkinData := SkinData;
    SetWindowPos(FDataList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FListVisible := True;
    FDataList.Visible := True;
    Repaint;
  end;
end;

procedure TspSkinDBLookupComboBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  Delta: Integer;
begin
  inherited KeyDown(Key, Shift);
  if ListActive and ((Key = VK_UP) or (Key = VK_DOWN)) then
    if ssAlt in Shift then
    begin
      if FListVisible then CloseUp(True) else DropDown;
      Key := 0;
    end else
      if not FListVisible then
      begin
        if not LocateKey then
          ListLink.DataSet.First
        else
        begin
          if Key = VK_UP then Delta := -1 else Delta := 1;
          ListLink.DataSet.MoveBy(Delta);
        end;
        SelectKeyValue(FKeyField.Value);
        Key := 0;
      end;
  if (Key <> 0) and FListVisible then FDataList.KeyDown(Key, Shift);
end;

procedure TspSkinDBLookupComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FListVisible then
    if Key in [#13, #27] then
      CloseUp(Key = #13)
    else
      FDataList.KeyPress(Key)
  else
    ProcessSearchKey(Key);
end;

procedure TspSkinDBLookupComboBox.KeyValueChanged;
begin
  if FLookupMode then
  begin
    FText := FDataField.DisplayText;
    FAlignment := FDataField.Alignment;
  end else
  if ListActive and LocateKey then
  begin
    FText := FListField.DisplayText;
    FAlignment := FListField.Alignment;
  end else
  begin
    FText := '';
    FAlignment := taLeftJustify;
  end;
  Invalidate;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TspSkinDBLookupComboBox.UpdateListFields;
begin
  inherited;
  KeyValueChanged;
end;

procedure TspSkinDBLookupComboBox.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FDataList.ClientRect, Point(X, Y)));
end;

procedure TspSkinDBLookupComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetFocus;
    if not HasFocus then Exit;
    if FListVisible then CloseUp(False) else
      if ListActive then
      begin
        MouseCapture := True;
        FTracking := True;
        TrackButton(X, Y);
        DropDown;
      end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TspSkinDBLookupComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ListPos := FDataList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(FDataList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(FDataList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        Exit;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TspSkinDBLookupComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  StopTracking;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TspSkinDBLookupComboBox.CreateControlSkinImage;

function GetDisabledFontColor: TColor;
var
  i: Integer;
begin
  i := -1;
  if FIndex <> -1 then i := SkinData.GetControlIndex('edit');
  if i = -1
  then
    Result := clGrayText
  else
    Result := TspDataSkinEditControl(SkinData.CtrlList[i]).DisabledFontColor;
end;


var
  OX: Integer;
  Text: string;
  Selected: Boolean;
  R, R1: TRect;
  TX, TY: Integer;
  Buffer: TBitMap;
begin
  if not IsNullRect(ActiveSkinRect) and (FMouseIn or Focused)
  then
    CreateHSkinImage(LTPt.X, RectWidth(ActiveSkinRect) - RTPt.X,
          B, Picture, ActiveSkinRect, Width, RectHeight(ActiveSkinRect), StretchEffect)
  else
    inherited;
  with B.Canvas do
  begin
    Brush.Style := bsClear;
    if FUseSkinFont
    then
      begin
        Font.Name := FontName;
        Font.Style := FontStyle;
        Font.Height := FontHeight;
      end
    else
      Font.Assign(FDefaultFont);
    if FMouseIn and not IsNullRect(ActiveSkinRect)
    then
      Font.Color := ActiveFontColor
    else
      Font.Color := FontColor;

    if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
    then
      Font.Charset := SkinData.ResourceStrData.CharSet
    else
      Font.CharSet := DefaultFont.CharSet;
  end;

  // calc rects
  OX := Width - RectWidth(SkinRect);
  FButtonRect := ButtonRect;
  if ButtonRect.Left >= RectWidth(SkinRect) - RTPt.X
  then
    OffsetRect(FButtonRect, OX, 0);
  FItemRect := ClRect;
  Inc(FItemRect.Right, OX);
  // draw button
  R1 := NullRect;
  if not Enabled and not IsNullRect(UnEnabledButtonRect)
  then
    R1 := UnEnabledButtonRect
  else
  if FPressed and not IsNullRect(DownButtonRect)
  then R1 := DownButtonRect
  else if FMouseIn then R1 := ActiveButtonRect;
  if not IsNullRect(R1)
  then
    B.Canvas.CopyRect(FButtonRect, Picture.Canvas, R1);
  // draw item
  if (csPaintCopy in ControlState) and (FDataField <> nil) and
    (FDataField.Lookup)
  then
    Text := FDataField.DisplayText
  else
    begin
      if (csDesigning in ComponentState) and (FDataField = nil) then
      Text := Name else
      Text := FText;
    end;
  Selected := HasFocus and not FListVisible and
    not (csPaintCopy in ControlState);
  if Selected and not IsNullRect(FocusItemRect)
  then
    begin
      Buffer := TBitMap.Create;
      if not IsNullRect(FocusItemRect)
      then
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
          FocusItemRect, RectWidth(FItemRect), RectHeight(FocusItemRect), FocusItemStretchEffect);
      B.Canvas.Draw(FItemRect.Left, FItemRect.Top, Buffer);
      Buffer.Free;
      R := ItemTextRect;
      Inc(R.Right, RectWidth(FItemRect) - RectWidth(FocusItemRect));
      OffsetRect(R, FItemRect.Left, FItemRect.Top);
      B.Canvas.Font.Color := FocusFontColor;
    end
  else
    if FMouseIn and not IsNullRect(ActiveSkinRect) and not IsNullrect(ActiveItemRect)
    then
      begin
        Buffer := TBitMap.Create;
        CreateHSkinImage(ItemLeftOffset, ItemRightOffset, Buffer, Picture,
           ActiveItemRect, RectWidth(FItemRect), RectHeight(ActiveItemRect), ItemStretchEffect);
        B.Canvas.Draw(FItemRect.Left, FItemRect.Top, Buffer);
        Buffer.Free;
        R := FItemRect;
      end
    else
      R := FItemRect;
  TX := R.Left + 2;
  TY := R.Top + RectHeight(R) div 2 - B.Canvas.TextHeight(Text) div 2;
  if not Enabled then B.Canvas.Font.Color := GetDisabledFontColor;
  B.Canvas.TextRect(R, TX, TY, Text);
end;

procedure TspSkinDBLookupComboBox.CreateControlDefaultImage;
var
  W, X, Flags: Integer;
  Text: string;
  Selected: Boolean;
  R: TRect;
  TX, TY: Integer;
begin
  with B.Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    R := ClientRect;
    FillRect(R);
    Font := DefaultFont;
  end;
  // frame
  Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  // button
  R := Rect(Width - 2 - FButtonWidth, 2, Width - 2, Height - 2);
  if FPressed
  then
    begin
      Frame3D(B.Canvas, R, SP_XP_BTNFRAMECOLOR, SP_XP_BTNFRAMECOLOR,  1);
      B.Canvas.Brush.Color := SP_XP_BTNDOWNCOLOR;
      B.Canvas.FillRect(R);
    end
  else
    Frame3D(B.Canvas, R, clbtnShadow, clbtnShadow, 1);
  if Enabled
  then
    DrawArrowImage(B.Canvas, R, clBtnText, 4)
  else
    DrawArrowImage(B.Canvas, R, clBtnShadow, 4);
  // item
  if (csPaintCopy in ControlState) and (FDataField <> nil) and
    (FDataField.Lookup)
  then
    Text := FDataField.DisplayText
  else
    begin
      if (csDesigning in ComponentState) and (FDataField = nil) then
      Text := Name else
      Text := FText;
    end;

  Selected := HasFocus and not FListVisible and
    not (csPaintCopy in ControlState);

  if Enabled then
    B.Canvas.Font.Color := Font.Color
  else
    B.Canvas.Font.Color := clGrayText;
  if Selected
  then
    begin
     B.Canvas.Font.Color := clHighlightText;
     B.Canvas.Brush.Color := clHighlight;
    end
  else
    B.Canvas.Brush.Color := FDefaultColor;
  TX := 4;
  TY := Height div 2 - B.Canvas.TextHeight(Text) div 2;
  R := Rect(2, 2, Width - 2 - FButtonWidth, Height - 2);
  B.Canvas.TextRect(R, TX, TY, Text);
  if Selected then B.Canvas.DrawFocusRect(R);
end;

procedure TspSkinDBLookupComboBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
end;

function TspSkinDBLookupComboBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBLookupComboBox.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TspSkinDBLookupComboBox.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
  BR: TRect;
begin
  if FIndex = -1
  then
    NewState := PtInRect(Rect(ClientWidth - FButtonWidth - 2, 2, ClientWidth - 2,
                         ClientHeight - 2), Point(X, Y))
  else
    begin
      BR := FButtonRect;
      Inc(BR.Right);
      Inc(BR.Bottom);
      NewState := PtInRect(BR, Point(X, Y));
    end;
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    Repaint;
  end;
end;

procedure TspSkinDBLookupComboBox.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FDataList) and
     (Message.Sender <> FDataList.FScrollBar)
  then
    CloseUp(False);
end;

procedure TspSkinDBLookupComboBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
end;

procedure TspSkinDBLookupComboBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TspSkinDBLookupComboBox.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TspSkinDBLookupComboBox.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp(False);
end;

function TspSkinDBLookupComboBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBLookupComboBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TspSkinDBRichEdit }

constructor TspSkinDBRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TspSkinDBRichEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBRichEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBRichEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBRichEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBRichEdit.BeginEditing;
begin
  if not FDataLink.Editing then
  try
    if FDataLink.Field.IsBlob then
      FDataSave := FDataLink.Field.AsString;
    FDataLink.Edit;
  finally
    FDataSave := '';
  end;
end;

procedure TspSkinDBRichEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or (Key = VK_BACK) or
      ((Key = VK_INSERT) and (ssShift in Shift)) or
      (((Key = Ord('V')) or (Key = Ord('X'))) and (ssCtrl in Shift)) then
      BeginEditing;
  end;
end;

procedure TspSkinDBRichEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        BeginEditing;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TspSkinDBRichEdit.Change;
begin
  if FMemoLoaded then FDataLink.Modified;
  FMemoLoaded := True;
  inherited Change;
end;

function TspSkinDBRichEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBRichEdit.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBRichEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBRichEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBRichEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBRichEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBRichEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBRichEdit.LoadMemo;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      Lines.Assign(FDataLink.Field);
      FMemoLoaded := True;
    except
      { Rich Edit Load failure }
      on E:EOutOfResources do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
  end;
end;

procedure TspSkinDBRichEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsBlob then
    begin
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
      begin
        { Check if the data has changed since we read it the first time }
        if (FDataSave <> '') and (FDataSave = FDataLink.Field.AsString) then Exit;
        FMemoLoaded := False;
        LoadMemo;
      end else
      begin
        Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
        FMemoLoaded := False;
      end;
    end else
    begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  else
  begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;
  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TspSkinDBRichEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TspSkinDBRichEdit.UpdateData(Sender: TObject);
begin
  if FDataLink.Field.IsBlob then
    FDataLink.Field.Assign(Lines) else
    FDataLink.Field.AsString := Text;
end;

procedure TspSkinDBRichEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob then
      FDataLink.Reset;
  end;
end;

procedure TspSkinDBRichEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;

  if FDataLink.CanModify then
    inherited ReadOnly := False;

  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBRichEdit.CMExit(var Message: TCMExit);
begin
  try
    if FDataLink.Editing then FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;

procedure TspSkinDBRichEdit.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TspSkinDBRichEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not FMemoLoaded then LoadMemo else inherited;
end;

procedure TspSkinDBRichEdit.WMCut(var Message: TMessage);
begin
  BeginEditing;
  inherited;
end;

procedure TspSkinDBRichEdit.WMPaste(var Message: TMessage);
begin
  BeginEditing;
  inherited;
end;

procedure TspSkinDBRichEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;


function TspSkinDBRichEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBRichEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

constructor TspSkinDBMemo2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FPaintControl := TPaintControl.Create(Self, 'EDIT');
end;

destructor TspSkinDBMemo2.Destroy;
begin
  FPaintControl.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBMemo2.WMPaint(var Message: TWMPaint);
var
  S: string;
begin
  if not (csPaintCopy in ControlState) then inherited else
  begin
    if FDataLink.Field <> nil then
      if FDataLink.Field.IsBlob then
      begin
        if FAutoDisplay then
          S := AdjustLineBreaks(FDataLink.Field.AsString) else
          S := Format('(%s)', [FDataLink.Field.DisplayLabel]);
      end else
        S := FDataLink.Field.DisplayText;
    SendMessage(FPaintControl.Handle, WM_SETTEXT, 0, Integer(PChar(S)));
    SendMessage(FPaintControl.Handle, WM_ERASEBKGND, Message.DC, 0);
    SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
  end;
end;

procedure TspSkinDBMemo2.Loaded;
begin
  inherited Loaded;
//  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBMemo2.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TspSkinDBMemo2.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TspSkinDBMemo2.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
      FDataLink.Edit;
  end;
end;

procedure TspSkinDBMemo2.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TspSkinDBMemo2.Change;
begin
  if FMemoLoaded then FDataLink.Modified;
  FMemoLoaded := True;
  inherited Change;
end;

function TspSkinDBMemo2.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBMemo2.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBMemo2.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBMemo2.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBMemo2.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBMemo2.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBMemo2.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBMemo2.LoadMemo;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      Lines.Text := FDataLink.Field.AsString;
      FMemoLoaded := True;
    except
      { Memo too large }
      on E:EInvalidOperation do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
  end;
end;

procedure TspSkinDBMemo2.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsBlob then
    begin
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
      begin
        FMemoLoaded := False;
        LoadMemo;
      end else
      begin
        Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
        FMemoLoaded := False;
      end;
    end else
    begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  else
  begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;
  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TspSkinDBMemo2.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TspSkinDBMemo2.UpdateData(Sender: TObject);
begin
  FDataLink.Field.AsString := Text;
end;

procedure TspSkinDBMemo2.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob then
      FDataLink.Reset;
  end;
end;

procedure TspSkinDBMemo2.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TspSkinDBMemo2.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if FDataLink.CanModify then
    inherited ReadOnly := False;
  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBMemo2.CMExit(var Message: TCMExit);
begin
  try
    if FDataLink.Editing then FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;

procedure TspSkinDBMemo2.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TspSkinDBMemo2.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not FMemoLoaded then LoadMemo else inherited;
end;

procedure TspSkinDBMemo2.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo2.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo2.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TspSkinDBMemo2.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBMemo2.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBMemo2.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

constructor TspSkinDBDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FInChange := False;
  FInDataChange := False;
  FAllowNullData := False;
end;

destructor TspSkinDBDateEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBDateEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBDateEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBDateEdit.Reset;
begin
  FDataLink.Reset;
  SelectAll;
end;

procedure TspSkinDBDateEdit.Change;
begin
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify and not (csDesigning in ComponentState)
  then
    begin
      if not FDataLink.Editing then FDataLink.Edit;
      FDataLink.Modified;
      inherited Change;
    end;
  FInChange := False;
end;

function TspSkinDBDateEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBDateEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBDateEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBDateEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBDateEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBDateEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBDateEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBDateEdit.DataChange(Sender: TObject);
begin
  FInDataChange := True;
  if not FInChange then
  if FDataLink.Field <> nil
  then
    begin
      if (FDataLink.Field.Text <> '') // and IsValidText(FDataLink.Field.Text)
      then
        Date := FDataLink.Field.AsDateTime //StrToDate(FDataLink.Field.Text)
      else
        begin
          if ToDayDefault then Date := Now;
          Text := '';
        end;
    end;
  FInDataChange := False;
end;

procedure TspSkinDBDateEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDBDateEdit.UpdateData(Sender: TObject);
begin
  if not (csDesigning in ComponentState)
  then
    FDataLink.Field.AsDateTime := Date;
end;

procedure TspSkinDBDateEdit.CMEnter;
begin
  inherited;
  if FDataLink.CanModify then
    inherited ReadOnly := False;
  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBDateEdit.CMExit;
begin
  inherited;
  if (FDataLink <> nil) and (FDataLink.Editing) and
     not Self.IsDateInput and FAllowNullData
  then
    FDataLink.Field.Value := Null;

  if (FDataLink <> nil) and (FDataLink.Editing)
  then
    FDataLink.UpdateRecord;
end;

procedure TspSkinDBDateEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBDateEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBDateEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

constructor TspSkinDBTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FInChange := False;
  FInDataChange := False;
end;

destructor TspSkinDBTimeEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBTimeEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBTimeEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBTimeEdit.Reset;
begin
  FDataLink.Reset;
  SelectAll;
end;

procedure TspSkinDBTimeEdit.Change;
begin
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify
  then
    begin
      if not FDataLink.Editing then FDataLink.Edit;
      FDataLink.Modified;
      inherited Change;
    end;
  FInChange := False;
end;

function TspSkinDBTimeEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBTimeEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBTimeEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBTimeEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBTimeEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBTimeEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBTimeEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBTimeEdit.DataChange(Sender: TObject);
begin
  FInDataChange := True;
  if not FInChange then
  if FDataLink.Field <> nil
  then
    Text := FDataLink.Field.Text;
  FInDataChange := False;
end;

procedure TspSkinDBTimeEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDBTimeEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := Text;
end;

procedure TspSkinDBTimeEdit.CMEnter;
begin
  inherited;
  if FDataLink.CanModify then
    inherited ReadOnly := False;
  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBTimeEdit.CMExit;
begin
  inherited;
  if (FDataLink <> nil) and (FDataLink.Editing)
  then
    FDataLink.UpdateRecord;
end;

procedure TspSkinDBTimeEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBTimeEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBTimeEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

constructor TspSkinDBPasswordEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FInChange := False;
  FInDataChange := False;
end;

destructor TspSkinDBPasswordEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBPasswordEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBPasswordEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBPasswordEdit.Change;
begin
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify
  then
    begin
      if not FDataLink.Editing then FDataLink.Edit;
      FDataLink.Modified;
      inherited Change;
    end;
  FInChange := False;
end;

function TspSkinDBPasswordEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBPasswordEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBPasswordEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBPasswordEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBPasswordEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBPasswordEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBPasswordEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBPasswordEdit.DataChange(Sender: TObject);
begin
  FInDataChange := True;
  if not FInChange then
  if FDataLink.Field <> nil
  then
    Text := FDataLink.Field.Text;
  FInDataChange := False;
end;

procedure TspSkinDBPasswordEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDBPasswordEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := Text;
end;

procedure TspSkinDBPasswordEdit.CMEnter;
begin
  inherited;
  if FDataLink.CanModify then
    inherited ReadOnly := False;
  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBPasswordEdit.CMExit;
begin
  inherited;
  if (FDataLink <> nil) and (FDataLink.Editing)
  then
    FDataLink.UpdateRecord;
end;

procedure TspSkinDBPasswordEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBPasswordEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBPasswordEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

//////

constructor TspSkinDBNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FInChange := False;
  FInDataChange := False;
end;

destructor TspSkinDBNumericEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TspSkinDBNumericEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TspSkinDBNumericEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TspSkinDBNumericEdit.Reset;
begin
  FDataLink.Reset;
  SelectAll;
end;

procedure TspSkinDBNumericEdit.Change;
begin
  inherited;  
  FInChange := True;
  if not FInDataChange and (FDataLink <> nil) and
     not ReadOnly and FDataLink.CanModify
  then
    begin
      if not FDataLink.Editing then FDataLink.Edit; 
      FDataLink.Modified;
    end;
  FInChange := False;
end;

function TspSkinDBNumericEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TspSkinDBNumericEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TspSkinDBNumericEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TspSkinDBNumericEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TspSkinDBNumericEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TspSkinDBNumericEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TspSkinDBNumericEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TspSkinDBNumericEdit.DataChange(Sender: TObject);
begin
  FInDataChange := True; 
  if not FInChange then
  if FDataLink.Field <> nil
  then
    begin
      if (FDataLink.Field.Text <> '') and IsNumText(FDataLink.Field.Text)
      then
        Text := FDataLink.Field.Text
      else
        Value := MinValue;
    end
  else
    Value := MinValue;
  FInDataChange := False;
end;

procedure TspSkinDBNumericEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TspSkinDBNumericEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := Text;
end;

procedure TspSkinDBNumericEdit.CMEnter;
begin
  inherited;
  inherited ReadOnly := not FDataLink.CanModify;
  if (FDataLink.DataSource <> nil) and not FDataLink.DataSource.AutoEdit and not FDataLink.Editing
  then
    inherited ReadOnly := True;
end;

procedure TspSkinDBNumericEdit.CMExit;
begin
  inherited;
  if (FDataLink <> nil) and (FDataLink.Editing)
  then
    FDataLink.UpdateRecord;
end;

procedure TspSkinDBNumericEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TspSkinDBNumericEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TspSkinDBNumericEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

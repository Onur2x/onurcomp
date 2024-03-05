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

unit spSkinShellCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, ShlObj, ActiveX, StdCtrls, ImgList, SkinCtrlss,
  DynamicSkinForm, SkinData, SkinBoxCtrls, spFileCtrl, ExtCtrls,
  Menus, SkinMenus;

type
  TRoot = type string;

  TspRootFolder = (rfDesktop, rfMyComputer, rfNetwork, rfRecycleBin, rfAppData,
    rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu, rfCommonStartup,
    rfControlPanel, rfDesktopDirectory, rfFavorites, rfFonts, rfInternet, rfPersonal,
    rfPrinters, rfPrintHood, rfPrograms, rfRecent, rfSendTo, rfStartMenu, rfStartup,
    rfTemplates);

  TspShellFolderCapability = (fcCanCopy, fcCanDelete, fcCanLink, fcCanMove, fcCanRename,
                   fcDropTarget, fcHasPropSheet);
  TspShellFolderCapabilities = set of TspShellFolderCapability;

  TspShellFolderProperty = (fpCut, fpIsLink, fpReadOnly, fpShared, fpFileSystem,
    fpFileSystemAncestor, fpRemovable, fpValidate);

  TspShellFolderProperties = set of TspShellFolderProperty;
                                                             
  TShellObjectType = (otFolders, otNonFolders, otHidden);
  TShellObjectTypes = set of TShellObjectType;

  EInvalidPath = class(Exception);

  IShellCommandVerb = interface
    ['{7D2A7245-2376-4D33-8008-A130935A2E8B}']
    procedure ExecuteCommand(Verb: string; var Handled: boolean);
    procedure CommandCompleted(Verb: string; Succeeded: boolean);
  end;

  {$IFDEF VER130}

  IInterface = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  {$HPPEMIT 'typedef System::DelphiInterface<IShellFolder2> _di_IShellFolder2;'}
  {$EXTERNALSYM IID_IShellFolder2}
   const
     SID_IShellDetails      = '{000214EC-0000-0000-C000-000000000046}';
     SID_IEnumExtraSearch   = '{0E700BE1-9DB6-11D1-A1CE-00C04FD75D13}';
     IID_IShellFolder2: TGUID = (
       D1:$B82C5AA8; D2:$A41B; D3:$11D2; D4:($BE,$32,$00,$C0,$4F,$B9,$36,$61));
     SID_IShellFolder2      = '{B82C5AA8-A41B-11D2-BE32-00C04FB93661}';
     SHCOLSTATE_TYPE_STR     = $00000001;
     SHCOLSTATE_TYPE_INT     = $00000002;
     SHCOLSTATE_TYPE_DATE    = $00000003;
     SHCOLSTATE_TYPEMASK     = $0000000F;
     SHCOLSTATE_ONBYDEFAULT  = $00000010;
     SHCOLSTATE_SLOW         = $00000020;
     SHCOLSTATE_EXTENDED     = $00000040;
     SHCOLSTATE_SECONDARYUI  = $00000080;   
     SHCOLSTATE_HIDDEN       = $00000100;
     {$EXTERNALSYM IID_IEnumExtraSearch}
     IID_IEnumExtraSearch: TGUID = (
       D1:$E700BE1; D2: $9DB6; D3:$11D1; D4:($A1,$CE,$00,$C0,$4F,$D7,$5D,$13));
      {$EXTERNALSYM IID_IShellDetails}
     IID_IShellDetails: TGUID = (
      D1:$000214EC; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
   type

   { IShellDetails is supported on Win9x and NT4; for >= NT5 use IShellFolder2 }
   PShellDetails = ^TShellDetails;
   {$EXTERNALSYM _SHELLDETAILS}
    _SHELLDETAILS = record
     fmt,
     cxChar: Integer;
     str: STRRET;
   end;

   TShellDetails = _SHELLDETAILS;
   SHELLDETAILS = _SHELLDETAILS;
   IShellDetails = interface(IUnknown)
     [SID_IShellDetails]
     function GetDetailsOf(pidl: PItemIDList; iColumn: UINT;
       var pDetails: TShellDetails): HResult; stdcall;
     function ColumnClick(iColumn: UINT): HResult; stdcall;
   end;

   {$EXTERNALSYM PShColumnID}
   PShColumnID = ^TShColumnID;
   {$EXTERNALSYM SHCOLUMNID}
   SHCOLUMNID = record
     fmtid: TGUID;
     pid: DWORD;
   end;
   {$EXTERNALSYM TShColumnID}
   TShColumnID = SHCOLUMNID;


   {$EXTERNALSYM PExtraSearch}
   PExtraSearch = ^TExtraSearch;
   {$EXTERNALSYM tagExtraSearch}
   tagExtraSearch = record
    guidSearch: TGUID;
    wszFriendlyName,
    wszMenuText: array[0..79] of WideChar;
    wszHelpText: array[0..MAX_PATH] of WideChar;
    wszUrl: array[0..2047] of WideChar;
    wszIcon,
    wszGreyIcon,
    wszClrIcon: array[0..MAX_PATH+10] of WideChar;
   end;
  {$EXTERNALSYM TExtraSearch}
  TExtraSearch = tagExtraSearch;

   {$EXTERNALSYM IEnumExtraSearch}
    IEnumExtraSearch = interface(IUnknown)
    [SID_IEnumExtraSearch]
    function Next(celt: ULONG; out rgelt: PExtraSearch;
      out pceltFetched: ULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumExtraSearch): HResult; stdcall;
  end;

    {$EXTERNALSYM IShellFolder2}
    IShellFolder2 = interface(IShellFolder)
    [SID_IShellFolder2]
    function GetDefaultSearchGUID(out pguid: TGUID): HResult; stdcall;
    function EnumSearches(out ppEnum: IEnumExtraSearch): HResult; stdcall;
    function GetDefaultColumn(dwRes: DWORD; var pSort: ULONG;
      var pDisplay: ULONG): HResult; stdcall;
    function GetDefaultColumnState(iColumn: UINT; var pcsFlags: DWORD): HResult; stdcall;
    function GetDetailsEx(pidl: PItemIDList; const pscid: SHCOLUMNID;
      pv: POleVariant): HResult; stdcall;
    function GetDetailsOf(pidl: PItemIDList; iColumn: UINT;
      var psd: TShellDetails): HResult; stdcall;
    function MapNameToSCID(pwszName: LPCWSTR; var pscid: TShColumnID): HResult; stdcall;
  end;
  {$ENDIF}
  
type
  TspShellFolder = class
  private
    FPIDL,
    FFullPIDL: PItemIDList;
    FParent: TspShellFolder;
    FIShellFolder: IShellFolder;
    FIShellFolder2: IShellFolder2;
    FIShellDetails: IShellDetails;
    FDetailInterface: IInterface;
    FLevel: Integer;
    FViewHandle: THandle;
    FDetails: TStrings;
    function GetDetailInterface: IInterface;
    function GetShellDetails: IShellDetails;
    function GetShellFolder2: IShellFolder2;
    function GetDetails(Index: integer): string;
    procedure SetDetails(Index: integer; const Value: string);
    procedure LoadColumnDetails(RootFolder: TspShellFolder; Handle: THandle; ColumnCount: integer);
  public
    constructor Create(AParent: TspShellFolder; ID: PItemIDList; SF: IShellFolder); virtual;
    destructor Destroy; override;
    function Capabilities: TspShellFolderCapabilities;
    function DisplayName: string;
    function ExecuteDefault: Integer;
    function ImageIndex(LargeIcon: Boolean): Integer;
    function IsFolder: Boolean;
    function ParentShellFolder: IShellFolder;
    function PathName: string;
    function Properties: TspShellFolderProperties;
    function Rename(const NewName: WideString): boolean;
    function SubFolders: Boolean;
    property AbsoluteID: PItemIDLIst read FFullPIDL;
    property Details[Index: integer] : string read GetDetails write SetDetails;
    property Level: Integer read FLevel;
    property Parent: TspShellFolder read FParent;
    property RelativeID: PItemIDList read FPIDL;
    property ShellFolder: IShellFolder read FIShellFolder;
    property ShellFolder2: IShellFolder2 read GetShellFolder2;
    property ShellDetails: IShellDetails read GetShellDetails;
    property ViewHandle: THandle read FViewHandle write FViewHandle;
  end;

  TNotifyFilter = (nfFileNameChange, nfDirNameChange, nfAttributeChange,
    nfSizeChange, nfWriteChange, nfSecurityChange);
  TNotifyFilters = set of TNotifyFilter;

  TspShellChangeThread = class(TThread)
  private
    FMutex,
    FWaitHandle: Integer;
    FChangeEvent: TThreadMethod;
    FDirectory: string;
    FWatchSubTree: Boolean;
    FWaitChanged : Boolean;
    FNotifyOptionFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(ChangeEvent: TThreadMethod); virtual;
    destructor Destroy; override;
    procedure SetDirectoryOptions( Directory : String; WatchSubTree : Boolean;
      NotifyOptionFlags : DWORD);
    property ChangeEvent : TThreadMethod read FChangeEvent write FChangeEvent;
  end;

  TspCustomShellChangeNotifier = class(TComponent)
  private
    FFilters: TNotifyFilters;
    FWatchSubTree: Boolean;
    FRoot : TRoot;
    FThread: TspShellChangeThread;
    FOnChange: TThreadMethod;
    procedure SetRoot(const Value: TRoot);
    procedure SetWatchSubTree(const Value: Boolean);
    procedure SetFilters(const Value: TNotifyFilters);
    procedure SetOnChange(const Value: TThreadMethod);
  protected
    procedure Change;
    procedure Start;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property NotifyFilters: TNotifyFilters read FFilters write SetFilters;
    property Root: TRoot read FRoot write SetRoot;
    property WatchSubTree: Boolean read FWatchSubTree write SetWatchSubTree;
    property OnChange: TThreadMethod read FOnChange write SetOnChange;
  end;

  TspShellChangeNotifier = class(TspCustomShellChangeNotifier)
  published
    property NotifyFilters;
    property Root;
    property WatchSubTree;
    property OnChange;
  end;

  TspCustomShellComboBox = class;
  TspCustomShellListView = class;

  TAddFolderEvent = procedure(Sender: TObject; AFolder: TspShellFolder;
    var CanAdd: Boolean) of object;
  TGetImageIndexEvent = procedure(Sender: TObject; Index: Integer;
     var ImageIndex: Integer) of object;

{ TspCustomShellTreeView }

  TspCustomShellTreeView = class(TspSkinCustomTreeView, IShellCommandVerb)
  private
    FRoot,
    FOldRoot : TRoot;
    FRootFolder: TspShellFolder;
    FObjectTypes: TShellObjectTypes;
    FLoadingRoot,
    FAutoContext,
    FUpdating: Boolean;
    FListView: TspCustomShellListView;
    FComboBox: TspCustomShellComboBox;
    FAutoRefresh,
    FImageListChanging,
    FUseShellImages: Boolean;
    FNotifier: TspShellChangeNotifier;
    FOnAddFolder: TAddFolderEvent;
    FSavePath: string;
    FNodeToMonitor: TTreeNode;
    function FolderExists(FindID: PItemIDList; InNode: TTreeNode): TTreeNode;
    function GetFolder(Index: Integer): TspShellFolder;
    function GetPath: string;
    procedure SetComboBox(Value: TspCustomShellComboBox);
    procedure SetListView(const Value: TspCustomShellListView);
    procedure SetPath(const Value: string);
    procedure SetPathFromID(ID: PItemIDList);
    procedure SetRoot(const Value: TRoot);
    procedure SetUseShellImages(const Value: Boolean);
    procedure SetAutoRefresh(const Value: boolean);
  protected
    function CanChange(Node: TTreeNode): Boolean; override;
    function CanExpand(Node: TTreeNode): Boolean; override;
    procedure CreateRoot;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure Edit(const Item: TTVItem); override;
    procedure GetImageIndex(Node: TTreeNode); override;
    procedure GetSelectedIndex(Node: TTreeNode); override;
    procedure InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode);
    procedure Loaded; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Delete(Node: TTreeNode); override;
    function NodeFromAbsoluteID(StartNode: TTreeNode; ID: PItemIDList): TTreeNode;
    function NodeFromRelativeID(ParentNode: TTreeNode; ID: PItemIDList): TTreeNode;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PopulateNode(Node: TTreeNode);
    procedure RootChanged;
    procedure SetObjectTypes(Value: TShellObjectTypes); virtual;
    procedure WMDestroy(var Message: TWMDestroy); virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure ClearItems;
    procedure RefreshEvent;
  public
    FImages: Integer;
    constructor Create(AOwner: TComponent); override;
    procedure Refresh(Node: TTreeNode);
    procedure ExpandMyComputer;
    function SelectedFolder: TspShellFolder;
    property AutoRefresh: boolean read FAutoRefresh write SetAutoRefresh;
    property Folders[Index: Integer]: TspShellFolder read GetFolder; default;
    property Items;
    property Path: string read GetPath write SetPath;
    property AutoContextMenus: Boolean read FAutoContext write FAutoContext default True;
    property ObjectTypes: TShellObjectTypes read FObjectTypes write SetObjectTypes;
    property Root: TRoot read FRoot write SetRoot;
    property ShellListView: TspCustomShellListView read FListView write SetListView;
    property ShellComboBox: TspCustomShellComboBox read FComboBox write SetComboBox;
    property UseShellImages: Boolean read FUseShellImages write SetUseShellImages;
    property OnAddFolder: TAddFolderEvent read FOnAddFolder write FOnAddFolder;
    procedure CommandCompleted(Verb: String; Succeeded: Boolean);
    procedure ExecuteCommand(Verb: String; var Handled: Boolean);
  end;

{ TShellTreeView }

  TspSkinDirTreeView = class(TspCustomShellTreeView)
  published
    property HScrollBar;
    property VScrollBar;
    property SkinData;
    property AutoContextMenus;
    property ObjectTypes;
    property Root;
    property ShellComboBox;
    property ShellListView;
    property UseShellImages;
    property OnAddFolder;
    property Align;
    property Anchors;
    property AutoRefresh;
    property BorderStyle;
    property ChangeDelay;
    property Color;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property Images;
    property Indent;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RightClickSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnChanging;
    property OnChange;
    property OnExpanding;
    property OnCollapsing;
    property OnCollapsed;
    property OnExpanded;
    property OnEditing;
    property OnEdited;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
  end;

{ TspCustomShellListView }

  TspCustomShellListView = class(TspSkinCustomListView, IShellCommandVerb)
  private
    FOldRoot: TRoot;
    FRoot: TRoot;
    FRootFolder: TspShellFolder;
    FAutoContext,
    FAutoRefresh,
    FAutoNavigate,
    FSorted,
    FUpdating: Boolean;
    FObjectTypes: TShellObjectTypes;
    FLargeImages,
    FSmallImages: Integer;
    FOnAddFolder: TAddFolderEvent;
    FFolders: TList;
    FTreeView: TspCustomShellTreeView;
    FComboBox: TspCustomShelLComboBox;
    FNotifier: TspShellChangeNotifier;
    FOnEditing: TLVEditingEvent;
    FSettingRoot: boolean;
    FSavePath: string;
    FMask: String;
    FOnPathChanged: TNotifyEvent;
    procedure SetMask(const Value: String);
    procedure EnumColumns;
    function GetFolder(Index: Integer): TspShellFolder;
    procedure SetAutoRefresh(const Value: Boolean);
    procedure SetSorted(const Value: Boolean);
    procedure SetTreeView(Value: TspCustomShellTreeView);
    procedure SetComboBox(Value: TspCustomShellComboBox);
    procedure TreeUpdate(NewRoot: PItemIDList);
    procedure SetPathFromID(ID: PItemIDList);
    procedure SynchPaths;
    function GetPath: string;
    procedure SetPath(const Value: string);
  protected
    procedure ClearItems;
    procedure CreateRoot;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DblClick; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure EditText;
    procedure Edit(const Item: TLVItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function OwnerDataFetch(Item: TListItem; Request: TItemRequest): Boolean; override;
    function OwnerDataFind(Find: TItemFind; const FindString: string;
      const FindPosition: TPoint; FindData: Pointer; StartIndex: Integer;
      Direction: TSearchDirection; Wrap: Boolean): Integer; override;
    procedure Populate; virtual;
    procedure RootChanged;
    procedure SetObjectTypes(Value: TShellObjectTypes);
    procedure SetRoot(const Value: TRoot);
    {$IFNDEF VER130}
    procedure SetViewStyle(Value: TViewStyle); override;
    {$ENDIF}
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Back;
    procedure Refresh;
    function GetSelectedFile: String;
    procedure GetSelectedFiles(AFiles: TStrings);
    function SelectedFolder: TspShellFolder;
    property Folders[Index: Integer]: TspShellFolder read GetFolder;
    property RootFolder: TspShellFolder read FRootFolder;
    property Path: string read GetPath write SetPath;
    property Items;
    property Columns;
    property Mask: String read FMask write SetMask;
    property AutoContextMenus: Boolean read FAutoContext write FAutoContext default True;
    property AutoRefresh: Boolean read FAutoRefresh write SetAutoRefresh default False;
    property AutoNavigate: Boolean read FAutoNavigate write FAutoNavigate default True;
    property ObjectTypes: TShellObjectTypes read FObjectTypes write SetObjectTypes;
    property Root: TRoot read FRoot write SetRoot;
    property ShellTreeView: TspCustomShellTreeView read FTreeView write SetTreeView;
    property ShellComboBox: TspCustomShellComboBox read FComboBox write SetComboBox;    
    property Sorted: Boolean read FSorted write SetSorted;
    property OnAddFolder: TAddFolderEvent read FOnAddFolder write FOnAddFolder;
    property OnEditing: TLVEditingEvent read FOnEditing write FOnEditing;
    procedure CommandCompleted(Verb: String; Succeeded: Boolean);
    procedure ExecuteCommand(Verb: String; var Handled: Boolean);
    property OnPathChanged: TNotifyEvent read FOnPathChanged write FOnPathChanged;
  end;

{ TShellListView }

  TspSkinFileListView = class(TspCustomShellListView)
  published
    property SkinData;
    property HScrollBar;
    property VScrollBar;
    property HeaderSkinDataName;
    property AutoContextMenus;
    property AutoRefresh;
    property AutoNavigate;
    property ObjectTypes;
    property Root;
    property ShellTreeView;
    property ShellComboBox;
    property Mask;
    property Sorted;
    property OnAddFolder;
    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property ColumnClick;
    property OnClick;
    property OnDblClick;
    property DragMode;
    property ReadOnly default True;
    property Enabled;
    property Font;
    property GridLines;
    property HideSelection;
    property HotTrack;
    property IconOptions;
    property AllocBy;
    property MultiSelect;
    property RowSelect;
    property OnChange;
    property OnChanging;
    property OnColumnClick;
    property OnContextPopup;
    property OnEnter;
    property OnExit;
    property OnInsert;
    property OnDragDrop;
    property OnDragOver;
    property DragCursor;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property ViewStyle;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEditing;
    property OnEdited;
  end;

  TDriveTypes = set of TDriveType;
  
  TspSkinShellDriveComboBox = class(TspSkinCustomComboBox)
  private
    FDrives: TStringList;
    FImages: TImageList;
    FDriveTypes: TDriveTypes;
    FDriveItemIndex: Integer;
    FDrive: Char;
    FOnChange: TNotifyEvent;
    procedure SetDriveTypes(const Value: TDriveTypes);
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
    procedure BuildList; virtual;
    procedure SetDrive(Value: Char);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateDrives;
    procedure Change; override;
    property Drive: Char read FDrive write SetDrive;
  published
    property DriveTypes: TDriveTypes read FDriveTypes write SetDriveTypes default [dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM];
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property AutoComplete;
    property ListBoxUseSkinItemHeight;
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
    property Align;
    property DropDownCount;
    property HorizontalExtent;
    property Font;
    property OnListBoxDrawItem;
    property OnComboBoxDrawItem;
    property OnClick;
    property OnCloseUp;
    property OnDropDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnEnter;
    property OnExit;
  end;

  TspItemEx = class(TCollectionItem)
  public
    Caption: String;
    Data: TspShellFolder;
    Indent: Integer;
    ImageIndex: Integer;
    SelectedImageIndex: Integer;
  end;

  TspItemsEx = class(TCollection)
  private
    function GetItem(Index: Integer): TspItemEx;
    procedure SetItem(Index: Integer; Value: TspItemEx);
  public
    constructor Create;
    function Add: TspItemEx;
    function Insert(Index: Integer): TspItemEx;
    procedure AddItem(ACaption: String; AImageIndex, ASelectedIndex: Integer;
              AIdent: Integer; AFolder: TspShellFolder);
    property Items[Index: Integer]: TspItemEx read GetItem write SetItem; default;
  end;

  TspCustomShellComboBox = class(TspSkinCustomComboBox)
  private
    FItemsEx: TspItemsEx;
    FImages,
    FImageHeight,
    FImageWidth: Integer;
    FImageList: TCustomImageList;
    FOldRoot : TRoot;
    FRoot: TRoot;
    FRootFolder: TspShellFolder;
    FTreeView: TspCustomShellTreeView;
    FListView: TspCustomShellListView;
    FObjectTypes: TShellObjectTypes;
    FUseShellImages,
    FUpdating: Boolean;
    procedure SetItemsEx(Value: TspItemsEx);
    procedure ClearItemsEx;
    function GetFolder(Index: Integer): TspShellFolder;
    function GetPath: string;
    procedure SetPath(const Value: string);
    procedure SetPathFromID(ID: PItemIDList);
    procedure SetRoot(const Value: TRoot);
    procedure SetTreeView(Value: TspCustomShellTreeView);
    procedure SetListView(Value: TspCustomShellListView);
    procedure SetUseShellImages(const Value: Boolean);
    function GetShellImageIndex(AFolder: TspShellFolder): integer;
    procedure CheckItems; 
  protected
    procedure DrawItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
    procedure ComboDrawItem(Cnvs: TCanvas; Index: Integer;
      ItemWidth, ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
    procedure AddItemsEx(Index: Integer; ParentFolder: TspShellFolder);
    procedure Change; override;
    procedure Click; override;
    procedure CreateRoot;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function IndexFromID(AbsoluteID: PItemIDList): Integer;
    procedure Init; virtual;
    function InitItem(ParentFolder: TspShellFolder; ID: PItemIDList): TspShellFolder;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RootChanged;
    procedure TreeUpdate(NewPath: PItemIDList);
    procedure SetObjectTypes(Value: TShellObjectTypes); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ItemsEx: TspItemsEx read FItemsEx write SetItemsEx;
    property Path: string read GetPath write SetPath;
    property Folders[Index: Integer]: TspShellFolder read GetFolder;
    property Root: TRoot read FRoot write SetRoot;
    property ObjectTypes: TShellObjectTypes read FObjectTypes write SetObjectTypes;
    property ShellTreeView: TspCustomShellTreeView read FTreeView write SetTreeView;
    property ShellListView: TspCustomShellListView read FListView write SetListView;
  end;

  TspSkinShellComboBox = class(TspCustomShellComboBox)
  published
    property Images;
    property Root;
    property ObjectTypes;
    property ShellTreeView;
    property ShellListView;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
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


  { Dialogs }

  TspSelDirDlgForm = class(TForm)
  public
    DSF: TspDynamicSkinForm;
    DirTreeViewPanel, BottomPanel: TspSkinPanel;
    DirTreeView: TspSkinDirTreeView;
    VScrollBar, HScrollBar: TspSkinScrollBar;
    OkButton, CancelButton: TspSkinButton;
    constructor CreateEx(AOwner: TComponent; ACtrlSkinData: TspSkinData); 
  end;

  TspSkinSelectDirectoryDialog = class(TComponent)
  private
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspSelDirDlgForm;
    FOnChange: TNotifyEvent;
    FDirectory: String;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure Change;
  public
    DialogWidth, DialogHeight: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
    property Directory: String read FDirectory write FDirectory;
  end;

  TspSkinDirectoryEdit = class(TspSkinEdit)
  protected
    FDlgSkinData: TspSkinData;
    FDlgCtrlSkinData: TspSkinData;
    SD: TspSkinSelectDirectoryDialog;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ButtonClick(Sender: TObject);
  published
    property DlgSkinData: TspSkinData read FDlgSkinData write FDlgSkinData;
    property DlgCtrlSkinData: TspSkinData read FDlgCtrlSkinData write FDlgCtrlSkinData;
  end;

  TspOpenDlgForm = class(TForm)
  private
    SaveMode: Boolean;
    FolderHistory: TList;
    StopAddToHistory: Boolean;
    CtrlSD: TspSkinData;
  public
    FileName: String;
    DSF: TspDynamicSkinForm;
    FileListViewPanel,
    BottomPanel: TspSkinPanel;
    FLVHScrollBar, FLVVScrollBar: TspSkinScrollBar;
    FileListView: TspSkinFileListView;
    FileNameEdit: TspSkinEdit;
    FilterComboBox: TspSkinFilterComboBox;
    ShellBox: TspSkinShellComboBox;
    OpenButton, CancelButton: TspSkinButton;
    Drivelabel, OpenFileLabel, FileTypeLabel: TspSkinStdLabel;
    ToolPanel: TspSkinToolBar;
    NewFolderToolButton, UpToolButton, BackToolButton: TspSkinSpeedButton;
    StyleToolButton: TspSkinMenuSpeedButton;
    StylePopupMenu: TspSkinPopupMenu;
    IconMenuItem, SmallIconMenuItem, ReportMenuItem, ListMenuItem: TMenuItem;
    constructor CreateEx(AOwner: TComponent; ASaveMode: Boolean;
                         ACtrlSkinData: TspSkinData);
    destructor Destroy; override;
    procedure FLVChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FLVPathChange(Sender: TObject);

    procedure FCBChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure FLVDBLClick(Sender: TObject);
    procedure FLVKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpToolButtonClick(Sender: TObject);
    procedure BackToolButtonClick(Sender: TObject);
    procedure NewFolderToolButtonClick(Sender: TObject);
    procedure ReportItemClick(Sender: TObject);
    procedure ListItemClick(Sender: TObject);
    procedure SmallIconItemClick(Sender: TObject);
    procedure IconItemClick(Sender: TObject);
  end;

  TspSkinOpenDialog = class(TComponent)
  private
    FMultiSelection: Boolean;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FLVHeaderSkinDataName: String;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspOpenDlgForm;
    FOnChange: TNotifyEvent;
    FInitialDir: String;
    FFilter: String;
    FFileName: String;
    FFilterIndex: Integer;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FCtrlAlphaBlend: Boolean;
    FCtrlAlphaBlendValue: Byte;
    FCtrlAlphaBlendAnimation: Boolean;
    FFiles: TStringList;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    FSaveMode: Boolean;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure Change;
  public
    ListViewStyle: TViewStyle;
    DialogWidth, DialogHeight: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Files: TStringList read FFiles;
  published
    property MultiSelection: Boolean read FMultiSelection write FMultiSelection;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property CtrlAlphaBlend: Boolean read FCtrlAlphaBlend write FCtrlAlphaBlend;
    property CtrlAlphaBlendValue: Byte read FCtrlAlphaBlendValue write FCtrlAlphaBlendValue;
    property CtrlAlphaBlendAnimation: Boolean
      read FCtrlAlphaBlendAnimation write FCtrlAlphaBlendAnimation;
    property LVHeaderSkinDataName: String
     read FLVHeaderSkinDataName write FLVHeaderSkinDataName;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
    property InitialDir: String read FInitialDir write FInitialDir;
    property Filter: String read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property FileName: String read FFileName write FFileName;
  end;

  TspSkinSaveDialog = class(TspSkinOpenDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TspSkinFileEdit = class(TspSkinEdit)
  protected
    FDlgSkinData: TspSkinData;
    FDlgCtrlSkinData: TspSkinData;
    OD: TspSkinOpenDialog;
    FLVHeaderSkinDataName: String;
    function GetFilter: String;
    procedure SetFilter(Value: String);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ButtonClick(Sender: TObject);
  published
    property Filter: String read GetFilter write SetFilter;
    property DlgSkinData: TspSkinData read FDlgSkinData write FDlgSkinData;
    property DlgCtrlSkinData: TspSkinData read FDlgCtrlSkinData write FDlgCtrlSkinData;
    property LVHeaderSkinDataName: String
      read FLVHeaderSkinDataName write FLVHeaderSkinDataName;
  end;

  TspSkinSaveFileEdit = class(TspSkinEdit)
  protected
    FDlgSkinData: TspSkinData;
    FDlgCtrlSkinData: TspSkinData;
    OD: TspSkinSaveDialog;
    FLVHeaderSkinDataName: String;
    function GetFilter: String;
    procedure SetFilter(Value: String);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ButtonClick(Sender: TObject);
  published
    property Filter: String read GetFilter write SetFilter;
    property DlgSkinData: TspSkinData read FDlgSkinData write FDlgSkinData;
    property DlgCtrlSkinData: TspSkinData read FDlgCtrlSkinData write FDlgCtrlSkinData;
    property LVHeaderSkinDataName: String
      read FLVHeaderSkinDataName write FLVHeaderSkinDataName;
  end;

  TspOpenPictureDlgForm = class(TForm)
  private
    SaveMode: boolean;
    FolderHistory: TList;
    StopAddToHistory: Boolean;
    CtrlSD: TspSkinData;
  public
    FileName: String;
    DSF: TspDynamicSkinForm;
    FileListViewPanel,
    BottomPanel: TspSkinPanel;
    FLVHScrollBar, FLVVScrollBar: TspSkinScrollBar;
    FileListView: TspSkinFileListView;
    FileNameEdit: TspSkinEdit;
    FilterComboBox: TspSkinFilterComboBox;
    ShellBox: TspSkinShellComboBox;
    OpenButton, CancelButton: TspSkinButton;
    Drivelabel, OpenFileLabel, FileTypeLabel: TspSkinStdLabel;
    ToolPanel: TspSkinToolBar;
    NewFolderToolButton, UpToolButton, BackToolButton: TspSkinSpeedButton;
    StyleToolButton: TspSkinMenuSpeedButton;
    StylePopupMenu: TspSkinPopupMenu;
    IconMenuItem, SmallIconMenuItem, ReportMenuItem, ListMenuItem: TMenuItem;
    //
    ImagePanel: TspSkinPanel;
    Image: TImage;
    ScrollBox: TspSkinScrollBox;
    SBVScrollBar, SBHScrollBar: TspSkinScrollBar;
    StretchButton: TspSkinSpeedButton;
    Splitter: TspSkinSplitter;
    procedure StretchButtonClick(Sender: TObject);
    //
    constructor CreateEx(AOwner: TComponent; ASaveMode: Boolean;
                         ACtrlSkinData: TspSkinData);
    destructor Destroy; override;
    procedure FLVChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FLVPathChange(Sender: TObject);

    procedure FCBChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure FLVDBLClick(Sender: TObject);
    procedure FLVKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpToolButtonClick(Sender: TObject);
    procedure BackToolButtonClick(Sender: TObject);
    procedure NewFolderToolButtonClick(Sender: TObject);
    procedure ReportItemClick(Sender: TObject);
    procedure ListItemClick(Sender: TObject);
    procedure SmallIconItemClick(Sender: TObject);
    procedure IconItemClick(Sender: TObject);
  end;

  TspSkinOpenPictureDialog = class(TComponent)
  private
    FStretchPicture: Boolean;
    FMultiSelection: Boolean;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FLVHeaderSkinDataName: String;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspOpenPictureDlgForm;
    FOnChange: TNotifyEvent;
    FInitialDir: String;
    FFilter: String;
    FFileName: String;
    FFilterIndex: Integer;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FCtrlAlphaBlend: Boolean;
    FCtrlAlphaBlendValue: Byte;
    FCtrlAlphaBlendAnimation: Boolean;
    FFiles: TStringList;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    FSaveMode: Boolean;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure Change;
  public
    ListViewStyle: TViewStyle;
    DialogWidth, DialogHeight: Integer;
    ImagePanelWidth: Integer;
    DialogStretch: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Files: TStringList read FFiles;
  published
    property StretchPicture: Boolean read FStretchPicture write FStretchPicture;  
    property MultiSelection: Boolean read FMultiSelection write FMultiSelection;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property CtrlAlphaBlend: Boolean read FCtrlAlphaBlend write FCtrlAlphaBlend;
    property CtrlAlphaBlendValue: Byte read FCtrlAlphaBlendValue write FCtrlAlphaBlendValue;
    property CtrlAlphaBlendAnimation: Boolean
      read FCtrlAlphaBlendAnimation write FCtrlAlphaBlendAnimation;
    property LVHeaderSkinDataName: String
     read FLVHeaderSkinDataName write FLVHeaderSkinDataName;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
    property InitialDir: String read FInitialDir write FInitialDir;
    property Filter: String read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property FileName: String read FFileName write FFileName;
  end;

  TspSkinSavePictureDialog = class(TspSkinOpenPictureDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TspOpenSkinDlgForm = class(TForm)
  private
    FolderHistory: TList;
    StopAddToHistory: Boolean;
    CtrlSD: TspSkinData;
  public
    FCompressedFilterIndex, FUnCompressedFilterIndex: Integer; 
    FileName: String;
    DSF: TspDynamicSkinForm;
    FileListViewPanel,
    BottomPanel: TspSkinPanel;
    FLVHScrollBar, FLVVScrollBar: TspSkinScrollBar;
    FileListView: TspSkinFileListView;
    FileNameEdit: TspSkinEdit;
    FilterComboBox: TspSkinFilterComboBox;
    ShellBox: TspSkinShellComboBox;
    OpenButton, CancelButton: TspSkinButton;
    Drivelabel, OpenFileLabel, FileTypeLabel: TspSkinStdLabel;
    ToolPanel: TspSkinToolBar;
    NewFolderToolButton, UpToolButton, BackToolButton: TspSkinSpeedButton;
    StyleToolButton: TspSkinMenuSpeedButton;
    StylePopupMenu: TspSkinPopupMenu;
    IconMenuItem, SmallIconMenuItem, ReportMenuItem, ListMenuItem: TMenuItem;
    //
    PreviewForm: TForm;
    PreviewDSF: TspDynamicSkinForm;
    PreviewSkinData: TspSkinData;
    PreviewButton: TspSkinButton;
    PreviewPanel: TspSkinPanel;
    //
    constructor CreateEx(AOwner: TComponent; ACtrlSkinData: TspSkinData);
    destructor Destroy; override;
    procedure FLVChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FLVPathChange(Sender: TObject);
    procedure FCBChange(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure FLVDBLClick(Sender: TObject);
    procedure FLVKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure UpToolButtonClick(Sender: TObject);
    procedure BackToolButtonClick(Sender: TObject);
    procedure NewFolderToolButtonClick(Sender: TObject);
    procedure ReportItemClick(Sender: TObject);
    procedure ListItemClick(Sender: TObject);
    procedure SmallIconItemClick(Sender: TObject);
    procedure IconItemClick(Sender: TObject);
  end;

  TspOpenSkinDialog = class(TComponent)
  private
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FLVHeaderSkinDataName: String;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspOpenSkinDlgForm;
    FOnChange: TNotifyEvent;
    FInitialDir: String;
    FFilter: String;
    FFileName: String;
    FFilterIndex: Integer;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FCtrlAlphaBlend: Boolean;
    FCtrlAlphaBlendValue: Byte;
    FCtrlAlphaBlendAnimation: Boolean;
    FFiles: TStringList;
    FCompressedFilterIndex: Integer;
    FUnCompressedFilterIndex: Integer;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure Change;
  public
    ListViewStyle: TViewStyle;
    DialogWidth, DialogHeight: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Files: TStringList read FFiles;
  published
    property CompressedFilterIndex: Integer
      read FCompressedFilterIndex write FCompressedFilterIndex;
    property UnCompressedFilterIndex: Integer
      read FUnCompressedFilterIndex write FUnCompressedFilterIndex;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property CtrlAlphaBlend: Boolean read FCtrlAlphaBlend write FCtrlAlphaBlend;
    property CtrlAlphaBlendValue: Byte read FCtrlAlphaBlendValue write FCtrlAlphaBlendValue;
    property CtrlAlphaBlendAnimation: Boolean
      read FCtrlAlphaBlendAnimation write FCtrlAlphaBlendAnimation;
    property LVHeaderSkinDataName: String
     read FLVHeaderSkinDataName write FLVHeaderSkinDataName;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
    property InitialDir: String read FInitialDir write FInitialDir;
    property Filter: String read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property FileName: String read FFileName write FFileName;
  end;


procedure InvokeContextMenu(Owner: TWinControl; AFolder: TspShellFolder; X, Y: Integer);


resourcestring
  SShellNoDetails = 'Unable to retrieve folder details for "%s". Error code $%x';
  SCallLoadDetails = '%s: Missing call to LoadColumnDetails';
  SPalletePage = 'Samples';
  SPropertyName = 'Root';
  SRenamedFailedError = 'Rename to %s failed';
  SErrorSettingPath = 'Error setting path: "%s"';

const
  SRFDesktop = 'rfDesktop';
  SCmdVerbOpen = 'open';
  SCmdVerbRename = 'rename';
  SCmdVerbDelete = 'delete';
  SCmdVerbPaste = 'paste';


implementation

{$R spSkinShellCtrls}

uses ShellAPI, ComObj, TypInfo, Consts, Math, spConst, Masks;

const
  nFolder: array[TspRootFolder] of Integer =
    (CSIDL_DESKTOP, CSIDL_DRIVES, CSIDL_NETWORK, CSIDL_BITBUCKET, CSIDL_APPDATA,
    CSIDL_COMMON_DESKTOPDIRECTORY, CSIDL_COMMON_PROGRAMS, CSIDL_COMMON_STARTMENU,
    CSIDL_COMMON_STARTUP, CSIDL_CONTROLS, CSIDL_DESKTOPDIRECTORY, CSIDL_FAVORITES,
    CSIDL_FONTS, CSIDL_INTERNET, CSIDL_PERSONAL, CSIDL_PRINTERS, CSIDL_PRINTHOOD,
    CSIDL_PROGRAMS, CSIDL_RECENT, CSIDL_SENDTO, CSIDL_STARTMENU, CSIDL_STARTUP,
    CSIDL_TEMPLATES);

  SHGFI = SHGFI_SYSICONINDEX or SHGFI_SMALLICON;   


var
  cmvProperties: PChar = 'properties';  { Do not localize }
  ICM: IContextMenu = nil;
  ICM2: IContextMenu2 = nil;
  DesktopFolder: TspShellFolder = nil;
  CS : TRTLCriticalSection;

{ PIDL manipulation }

procedure debug(Comp:TComponent; msg:string);
begin
  ShowMessage(Comp.Name + ':' + msg);
end;

function CreatePIDL(Size: Integer): PItemIDList;
var
  Malloc: IMalloc;
begin
  OleCheck(SHGetMalloc(Malloc));

  Result := Malloc.Alloc(Size);
  if Assigned(Result) then
    FillChar(Result^, Size, 0);
end;

function NextPIDL(IDList: PItemIDList): PItemIDList;
begin
  Result := IDList;
  Inc(PChar(Result), IDList^.mkid.cb);
end;

procedure StripLastID(IDList: PItemIDList);
var
  MarkerID: PItemIDList;
begin
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextPIDL(IDList);
    end;
    MarkerID.mkid.cb := 0;
  end;
end;

function GetItemCount(IDList: PItemIDList): Integer;
begin
  Result := 0;
  while IDList^.mkid.cb <> 0 do
  begin
    Inc(Result);
    IDList := NextPIDL(IDList);
  end;
end;

function GetPIDLSize(IDList: PItemIDList): Integer;
begin
  Result := 0;
  if Assigned(IDList) then
  begin
    Result := SizeOf(IDList^.mkid.cb);
    while IDList^.mkid.cb <> 0 do
    begin
      Result := Result + IDList^.mkid.cb;
      IDList := NextPIDL(IDList);
    end;
  end;
end;

function CopyPIDL(IDList: PItemIDList): PItemIDList;
var
  Size: Integer;
begin
  Size := GetPIDLSize(IDList);
  Result := CreatePIDL(Size);
  if Assigned(Result) then
    CopyMemory(Result, IDList, Size);
end;

function ConcatPIDLs(IDList1, IDList2: PItemIDList): PItemIDList;
var
  cb1, cb2: Integer;
begin
  if Assigned(IDList1) then
    cb1 := GetPIDLSize(IDList1) - SizeOf(IDList1^.mkid.cb)
  else
    cb1 := 0;

  cb2 := GetPIDLSize(IDList2);

  Result := CreatePIDL(cb1 + cb2);
  if Assigned(Result) then
  begin
    if Assigned(IDList1) then
      CopyMemory(Result, IDList1, cb1);
    CopyMemory(PChar(Result) + cb1, IDList2, cb2);
  end;
end;

procedure DisposePIDL(PIDL: PItemIDList);
var
  MAlloc: IMAlloc;
begin
  OLECheck(SHGetMAlloc(MAlloc));
  MAlloc.Free(PIDL);
end;

function RelativeFromAbsolute(AbsoluteID: PItemIDList): PItemIDList;
begin
  Result := AbsoluteID;
  while GetItemCount(Result) > 1 do
     Result := NextPIDL(Result);
  Result := CopyPIDL(Result);
end;

function CreatePIDLList(ID: PItemIDList): TList;
var
  TempID: PItemIDList;
begin
  Result := TList.Create;
  TempID := ID;
  while TempID.mkid.cb <> 0 do
  begin
    TempID := CopyPIDL(TempID);
    Result.Insert(0, TempID); 
    StripLastID(TempID);
  end;
end;

procedure DestroyPIDLList(List: TList);
var
  I: Integer;
begin
  If List = nil then Exit;
  for I := 0 to List.Count-1 do
    DisposePIDL(List[I]);
  List.Free;
end;

{ Miscellaneous }

procedure NoFolderDetails(AFolder: TspShellFolder; HR: HResult);
begin
  Raise EInvalidPath.CreateFmt(SShellNoDetails, [AFolder.DisplayName, HR]);
end;

function DesktopShellFolder: IShellFolder;
begin
  OleCheck(SHGetDesktopFolder(Result));
end;

procedure CreateDesktopFolder;
var
  DesktopPIDL: PItemIDList;
begin
  SHGetSpecialFolderLocation(0, nFolder[rfDesktop], DesktopPIDL);
  if DesktopPIDL <> nil then
    DesktopFolder := TspShellFolder.Create(nil, DesktopPIDL, DesktopShellFolder);
end;

function SamePIDL(ID1, ID2: PItemIDList): boolean;
begin
  Result := DesktopShellFolder.CompareIDs(0, ID1, ID2) = 0;
end;

function DesktopPIDL: PItemIDList;
begin
  OleCheck(SHGetSpecialFolderLocation(0, nFolder[rfDesktop], Result));
end;

function GetCSIDLType(const Value: string): TspRootFolder;
begin
{$R+}
  Result := TspRootFolder(GetEnumValue(TypeInfo(TspRootFolder), Value))
{$R-}
end;

function IsElement(Element, Flag: Integer): Boolean;
begin
  Result := Element and Flag <> 0;
end;

function GetShellImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then Flags := Flags or SHGFI_LARGEICON
  else Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(PIDL),
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags);
  Result := FileInfo.iIcon;
end;

function GetCaps(ParentFolder: IShellFolder; PIDL: PItemIDList): TspShellFolderCapabilities;
var
  Flags: LongWord;
begin
  Result := [];
  Flags := SFGAO_CAPABILITYMASK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_CANCOPY, Flags) then Include(Result, fcCanCopy);
  if IsElement(SFGAO_CANDELETE, Flags) then Include(Result, fcCanDelete);
  if IsElement(SFGAO_CANLINK, Flags) then Include(Result, fcCanLink);
  if IsElement(SFGAO_CANMOVE, Flags) then Include(Result, fcCanMove);
  if IsElement(SFGAO_CANRENAME, Flags) then Include(Result, fcCanRename);
  if IsElement(SFGAO_DROPTARGET, Flags) then Include(Result, fcDropTarget);
  if IsElement(SFGAO_HASPROPSHEET, Flags) then Include(Result, fcHasPropSheet);
end;

function GetProperties(ParentFolder: IShellFolder; PIDL: PItemIDList): TspShellFolderProperties;
var
  Flags: LongWord;
begin
  Result := [];
  if ParentFolder = nil then Exit;
  Flags := SFGAO_DISPLAYATTRMASK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_GHOSTED, Flags) then Include(Result, fpCut);
  if IsElement(SFGAO_LINK, Flags) then Include(Result, fpIsLink);
  if IsElement(SFGAO_READONLY, Flags) then Include(Result, fpReadOnly);
  if IsElement(SFGAO_SHARE, Flags) then Include(Result, fpShared);

  Flags := 0;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_FILESYSTEM, Flags) then Include(Result, fpFileSystem);
  if IsElement(SFGAO_FILESYSANCESTOR, Flags) then Include(Result, fpFileSystemAncestor);
  if IsElement(SFGAO_REMOVABLE, Flags) then Include(Result, fpRemovable);
  if IsElement(SFGAO_VALIDATE, Flags) then Include(Result, fpValidate);
end;

function GetIsFolder(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_FOLDER;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := SFGAO_FOLDER and Flags <> 0;
end;

function GetHasSubFolders(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_CONTENTSMASK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := SFGAO_HASSUBFOLDER and Flags <> 0;
end;

function GetHasSubItems(ShellFolder: IShellFolder; Flags: Integer): Boolean;
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NumIDs: LongWord;
  HR: HResult;
  ErrMode: Integer;
begin
  Result := False;
  if ShellFolder = nil then Exit;
  ErrMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    HR := ShellFolder.EnumObjects(0,
                                Flags,
                                EnumList);
    if HR <> S_OK then Exit;
    Result := EnumList.Next(1, ID, NumIDs) = S_OK;
  finally
    SetErrorMode(ErrMode);
  end;
end;

function StrRetToString(PIDL: PItemIDList; StrRet: TStrRet; Flag:string=''): string;
var
  P: PChar;
begin
  case StrRet.uType of
    STRRET_CSTR:
      SetString(Result, StrRet.cStr, lStrLen(StrRet.cStr));
    STRRET_OFFSET:
      begin
        P := @PIDL.mkid.abID[StrRet.uOffset - SizeOf(PIDL.mkid.cb)];
        SetString(Result, P, PIDL.mkid.cb - StrRet.uOffset);
      end;
    STRRET_WSTR:
      if Assigned(StrRet.pOleStr) then
        Result := StrRet.pOleStr
      else
        Result := '';  
  end;
  { This is a hack bug fix to get around Windows Shell Controls returning
    spurious "?"s in date/time detail fields } 
  if (Length(Result) > 1) and (Result[1] = '?') and (Result[2] in ['0'..'9']) then
    Result := StringReplace(Result,'?','',[rfReplaceAll]);
end;

function GetDisplayName(Parentfolder: IShellFolder; PIDL: PItemIDList;
                        Flags: DWORD): string;
var
  StrRet: TStrRet;
begin
  Result := '';
  if ParentFolder = nil then
  begin
    Result := 'parentfolder = nil';  { Do not localize }
    exit;
  end;
  FillChar(StrRet, SizeOf(StrRet), 0);
  ParentFolder.GetDisplayNameOf(PIDL, Flags, StrRet);
  Result := StrRetToString(PIDL, StrRet);
  { TODO 2 -oMGD -cShell Controls : Remove this hack (on Win2k, GUIDs are returned for the
PathName of standard folders)}
  if (Pos('::{', Result) = 1) then
    Result := GetDisplayName(ParentFolder, PIDL, SHGDN_NORMAL);
end;

function ObjectFlags(ObjectTypes: TShellObjectTypes): Integer;
begin
  Result := 0;
  if otFolders in ObjectTypes then Inc(Result, SHCONTF_FOLDERS);
  if otNonFolders in ObjectTypes then Inc(Result, SHCONTF_NONFOLDERS);
  if otHidden in ObjectTypes then Inc(Result, SHCONTF_INCLUDEHIDDEN);
end;

procedure InvokeContextMenu(Owner: TWinControl; AFolder: TspShellFolder; X, Y: Integer);
var
  PIDL: PItemIDList;
  CM: IContextMenu;
  Menu: HMenu;
  ICI: TCMInvokeCommandInfo;
  P: TPoint;
  Command: LongBool;
  ICmd: integer;
  ZVerb: array[0..255] of char;
  Verb: string;
  Handled: boolean;
  SCV: IShellCommandVerb;
  HR: HResult;
begin
  if AFolder = nil then Exit;
  PIDL := AFolder.RelativeID;
  AFolder.ParentShellFolder.GetUIObjectOf(Owner.Handle, 1, PIDL, IID_IContextMenu, nil, CM);
  if CM = nil then Exit;
  P.X := X;
  P.Y := Y;

  Windows.ClientToScreen(Owner.Handle, P);
  Menu := CreatePopupMenu;
  try
    CM.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_EXPLORE or CMF_CANRENAME);
    CM.QueryInterface(IID_IContextMenu2, ICM2); 
    try
      Command := TrackPopupMenu(Menu, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON or
        TPM_RETURNCMD, P.X, P.Y, 0, Owner.Handle, nil);
    finally
      ICM2 := nil;
    end;

    if Command then
    begin
      ICmd := LongInt(Command) - 1;
      HR := CM.GetCommandString(ICmd, GCS_VERBA, nil, ZVerb, SizeOf(ZVerb));
      Verb := StrPas(ZVerb);
      Handled := False;
      if Supports(Owner, IShellCommandVerb, SCV) then
      begin
        HR := 0;
        SCV.ExecuteCommand(Verb, Handled);
      end;

      if not Handled then
      begin
        FillChar(ICI, SizeOf(ICI), #0);
        with ICI do
        begin
          cbSize := SizeOf(ICI);
          hWND := Owner.Handle;
          lpVerb := MakeIntResource(ICmd);
          nShow := SW_SHOWNORMAL;
        end;
        HR := CM.InvokeCommand(ICI);
      end;

      if Assigned(SCV) then
        SCV.CommandCompleted(Verb, HR = S_OK);
    end;
  finally
    DestroyMenu(Menu);
  end;
end;

procedure DoContextMenuVerb(AFolder: TspShellFolder; Verb: PChar);
var
  ICI: TCMInvokeCommandInfo;
  CM: IContextMenu;
  PIDL: PItemIDList;
begin
  if AFolder = nil then Exit;
  FillChar(ICI, SizeOf(ICI), #0);
  with ICI do
  begin
    cbSize := SizeOf(ICI);
    fMask := CMIC_MASK_ASYNCOK;
    hWND := 0;
    lpVerb := Verb;
    nShow := SW_SHOWNORMAL;
  end;
  PIDL := AFolder.RelativeID;
  AFolder.ParentShellFolder.GetUIObjectOf(0, 1, PIDL, IID_IContextMenu, nil, CM);
  CM.InvokeCommand(ICI);
end;

function GetIShellFolder(IFolder: IShellFolder; PIDL: PItemIDList;
  Handle: THandle = 0): IShellFolder;
var
  HR : HResult;
begin
  if Assigned(IFolder) then
  begin
    HR := IFolder.BindToObject(PIDL, nil, IID_IShellFolder, Pointer(Result));
    if HR <> S_OK then
      IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellFolder, nil, Pointer(Result));
    if HR <> S_OK then
      IFolder.CreateViewObject(Handle, IID_IShellFolder, Pointer(Result));
  end;
  if not Assigned(Result) then
    DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellFolder, Pointer(Result));
end;

function GetIShellDetails(IFolder: IShellFolder; PIDL: PItemIDList;
  Handle: THandle = 0): IShellDetails;
var
  HR : HResult;
begin
  if Assigned(IFolder) then
  begin
    HR := IFolder.BindToObject(PIDL, nil, IID_IShellDetails, Pointer(Result));
    if HR <> S_OK then
      IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellDetails, nil, Pointer(Result));
    if HR <> S_OK then
      IFolder.CreateViewObject(Handle, IID_IShellDetails, Pointer(Result));
  end;
  if not Assigned(Result) then
    DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellDetails, Pointer(Result));
end;

function GetIShellFolder2(IFolder: IShellFolder; PIDL: PItemIDList;
  Handle: THandle = 0): IShellFolder2;
var
  HR : HResult;
begin
  if (Win32MajorVersion >= 5) then
  begin
    HR := DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellFolder2, Pointer(Result));
    if HR <> S_OK then
      IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellFolder2, nil, Pointer(Result));
    if (HR <> S_OK) and (IFolder <> nil) then
      IFolder.BindToObject(PIDL, nil, IID_IShellFolder2, Pointer(Result));
  end
  else
    Result := nil;
end;

function CreateRootFromPIDL(Value: PItemIDList): TspShellFolder;
var
  SF: IShellFolder;
begin
  SF := GetIShellFolder(DesktopShellFolder, Value);
  if SF = NIL then SF := DesktopShellFolder;
  Result := TspShellFolder.Create(DesktopFolder, Value, SF);
end;

function CreateRootFolder(RootFolder: TspShellFolder; OldRoot : TRoot;
  var NewRoot: TRoot): TspShellFolder;
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  NumChars,
  Flags,
  HR: LongWord;
  ErrorMsg : string;
begin
  HR := S_FALSE;
  if GetEnumValue(TypeInfo(TspRootFolder), NewRoot) >= 0 then
  begin
    HR := SHGetSpecialFolderLocation(
            0,
            nFolder[GetCSIDLType(NewRoot)],
            NewPIDL);
  end
  else if Length(NewRoot) > 0 then
  begin
    if NewRoot[Length(NewRoot)] = ':' then NewRoot := NewRoot + '\';
    NumChars := Length(NewRoot);
    Flags := 0;
    P := StringToOleStr(NewRoot);
    HR := DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags);
  end;

  if HR <> S_OK then
  begin
    ErrorMsg := Format( SErrorSettingPath, [ NewRoot ] );
    NewRoot := OldRoot;
    raise Exception.Create( ErrorMsg );
  end;

  Result := CreateRootFromPIDL(NewPIDL);
  if Assigned(RootFolder) then RootFolder.Free;
end;

{ TspShellFolder }

constructor TspShellFolder.Create(AParent: TspShellFolder; ID: PItemIDList; SF: IShellFolder);
var
  DesktopID: PItemIDList;
begin
  inherited Create;
  FLevel := 0;
  FDetails := TStringList.Create;
  FIShellFolder := SF;
  FIShellFolder2 := nil;
  FIShellDetails := nil;
  FParent := AParent;
  FPIDL := CopyPIDL(ID);
  if FParent <> nil then
    FFullPIDL := ConcatPIDLs(AParent.FFullPIDL, ID)
  else
  begin
    DesktopID := DesktopPIDL;
    try
      FFullPIDL := ConcatPIDLs(DesktopID, ID);
    finally
      DisposePIDL(DesktopID);
    end;
  end;
  if FParent = nil then
    FParent := DesktopFolder;
  while AParent <> nil do
  begin
    AParent := AParent.Parent;
    if AParent <> nil then Inc(FLevel);
  end;
end;

destructor TspShellFolder.Destroy;
begin
  if Assigned(FDetails) then
    FDetails.Free;
  FDetails := nil;  
  if Assigned(FPIDL) then
    DisposePIDL(FPIDL);
  if Assigned(FFullPIDL) then
    DisposePIDL(FFullPIDL);
  inherited Destroy;
end;

function TspShellFolder.GetDetailInterface: IInterface;
begin
  if (not Assigned(FDetailInterface)) and Assigned(FIShellFolder) then
  begin
    FIShellDetails := GetIShellDetails(FIShellFolder, FFullPIDL, FViewHandle);
    if (not Assigned(FIShellDetails)) and (Win32MajorVersion >= 5) then
    begin
      FIShellFolder2 := GetIShellFolder2(FIShellFolder, FFullPIDL, FViewHandle);
      if not Assigned(FIShellFolder2) then
          FIShellFolder2 := IShellFolder2(FIShellFolder);
    end;
    if Assigned(FIShellFolder2) then
      Result := IInterface(FIShellFolder2)
    else
      Result := IInterface(FIShellDetails);
    FDetailInterface := Result;
  end
  else
    Result := FDetailInterface;
end;

function TspShellFolder.GetShellDetails: IShellDetails;
begin
  if not Assigned(FDetailInterface) then
    GetDetailInterface;
  Result := FIShellDetails;
end;

function TspShellFolder.GetShellFolder2: IShellFolder2;
begin
  if not Assigned(FDetailInterface) then
    GetDetailInterface;
  Result := FIShellFolder2;
end;

procedure TspShellFolder.LoadColumnDetails(RootFolder: TspShellFolder;
  Handle: THandle; ColumnCount: integer);

  procedure GetDetailsOf(AFolder: TspShellFolder; var Details: TWin32FindData);
  var
    szPath: array[ 0 .. MAX_PATH] of char;
    Path: string;
    Handle: THandle;
  begin
    FillChar(Details, SizeOf(Details), 0);
    FillChar(szPath,MAX_PATH,0);
    Path := AFolder.PathName;
    Handle := Windows.FindFirstFile(PChar(Path), Details);
    try
      if Handle = INVALID_HANDLE_VALUE then
        NoFolderDetails(AFolder, Windows.GetLastError);
    finally
      Windows.FindClose(Handle);
    end;
  end;

  function CalcFileSize(FindData: TWin32FindData): int64;
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      Result := FindData.nFileSizeHigh * MAXDWORD + FindData.nFileSizeLow
    else
      Result := -1;
  end;

  function CalcModifiedDate(FindData: TWin32FindData): TDateTime;
  var
    LocalFileTime: TFileTime;
    Age : integer;
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Age).Hi,
        LongRec(Age).Lo) then
      begin
        Result := FileDateToDateTime(Age);
        Exit;
      end;
    end;
    Result := -1;
  end;

  function DefaultDetailColumn(FindData: TWin32FindData; Col: integer): string;
  begin
    case Col of
      1 : Result := IntToStr(CalcFileSize(FindData)); // Size
      2 : Result := ExtractFileExt(FindData.cFileName); // Type
      3 : Result := DateTimeToStr(CalcModifiedDate(FindData)); // Modified
      4 : Result := IntToStr(FindData.dwFileAttributes);
    end;
  end;

  procedure AddDetail(HR: HResult; PIDL: PItemIDList; SD: TShellDetails);
  begin
    if HR = S_OK then
      FDetails.Add(StrRetToString(PIDL, SD.str))
    else
      FDetails.Add('');
  end;
  
var
  SF2: IShellFolder2;
  ISD: IShellDetails;
  J: Integer;
  SD: TShellDetails;
  HR: HResult;
  FindData: TWin32FindData;

begin
  if not Assigned(FDetails) or (FDetails.Count >= ColumnCount) then Exit; 
  FDetails.Clear;
  FViewHandle := Handle;
  SF2 := RootFolder.ShellFolder2;
  if Assigned(SF2) then
  begin
    for J := 1 to ColumnCount do
    begin
      HR := SF2.GetDetailsOf(FPIDL, J, SD);
      AddDetail(HR, FPIDL, SD);
    end;
  end
  else
  begin
    ISD := RootFolder.ShellDetails;
    if Assigned(ISD) then
    begin
      for J := 1 to ColumnCount do
      begin
        HR := ISD.GetDetailsOf(FPIDL, J, SD);
        AddDetail(HR, FPIDL, SD);
      end;
    end
    else if (fpFileSystem in RootFolder.Properties) then
    begin
      GetDetailsOf(Self, FindData);
      for J := 1 to ColumnCount do
        FDetails.Add(DefaultDetailColumn(FindData, J));
    end;
  end;
end;

function TspShellFolder.GetDetails(Index: integer): string;
begin
  if FDetails.Count > 0 then
    Result := FDetails[Index-1] 
  else
    Raise Exception.CreateFmt(SCallLoadDetails, [ Self.DisplayName ] );
end;

procedure TspShellFolder.SetDetails(Index: integer; const Value: string);
begin
  if Index < FDetails.Count then
    FDetails[Index - 1] := Value 
  else
    FDetails.Insert(Index - 1, Value); 
end;

function TspShellFolder.ParentShellFolder: IShellFolder;
begin
  if FParent <> nil then
    Result := FParent.ShellFolder
  else
    OLECheck(SHGetDesktopFolder(Result));
end;

function TspShellFolder.Properties: TspShellFolderProperties;
begin
  Result := GetProperties(ParentShellFolder, FPIDL);
end;

function TspShellFolder.Capabilities: TspShellFolderCapabilities;
begin
  Result := GetCaps(ParentShellFolder, FPIDL);
end;

function TspShellFolder.SubFolders: Boolean;
begin
  Result := GetHasSubFolders(ParentShellFolder, FPIDL);
end;

function TspShellFolder.IsFolder: Boolean;
begin
  Result := GetIsFolder(ParentShellFolder, FPIDL);
  if Result
  then
    Result := UpperCase(ExtractFileExt(PathName)) <> '.ZIP';
end;

function TspShellFolder.PathName: string;
begin
  Result := GetDisplayName(DesktopShellFolder, FFullPIDL, SHGDN_FORPARSING);
end;

function TspShellFolder.DisplayName: string;
var
  ParentFolder: IShellFolder;
begin
  if Parent <> nil then
    ParentFolder := ParentShellFolder
  else
    ParentFolder := DesktopShellFolder;
  Result := GetDisplayName(ParentFolder, FPIDL, SHGDN_INFOLDER)
end;

function TspShellFolder.Rename(const NewName: Widestring): boolean;
var
  NewPIDL: PItemIDList;
begin
  Result := False;
  if not (fcCanRename in Capabilities) then Exit;

  Result := ParentShellFolder.SetNameOf(
       0,
       FPIDL,
       PWideChar(NewName),
       SHGDN_NORMAL,
       NewPIDL) = S_OK;
  if Result then
  begin
    DisposePIDL(FPIDL);
    DisposePIDL(FFullPIDL);
    FPIDL := NewPIDL;
    if (FParent <> nil) then
      FFullPIDL := ConcatPIDLs(FParent.FPIDL, NewPIDL)
    else
      FFullPIDL := CopyPIDL(NewPIDL);
  end
  else
    Raise Exception.Create(Format(SRenamedFailedError,[NewName]));
end;

function TspShellFolder.ImageIndex(LargeIcon: Boolean): Integer;
begin
  Result := GetShellImage(AbsoluteID, LargeIcon, False);
end;

function TspShellFolder.ExecuteDefault: Integer;
var
  SEI: TShellExecuteInfo;
begin
  FillChar(SEI, SizeOf(SEI), 0);
  with SEI do
  begin
    cbSize := SizeOf(SEI);
    wnd := Application.Handle;
    fMask := SEE_MASK_INVOKEIDLIST;
    lpIDList := AbsoluteID;
    nShow := SW_SHOW;
  end;
  Result := Integer(ShellExecuteEx(@SEI));
end;

{ TspCustomShellChangeNotifier }

procedure TspCustomShellChangeNotifier.Change;

  function NotifyOptionFlags: DWORD;
  begin
    Result := 0;
    if nfFileNameChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    if nfDirNameChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    if nfSizeChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    if nfAttributeChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    if nfWriteChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    if nfSecurityChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
  end;

begin
  if Assigned(FThread) then
  begin
    FThread.SetDirectoryOptions(Root, LongBool(FWatchSubTree),
      NotifyOptionFlags);
  end;
end;

constructor TspCustomShellChangeNotifier.Create(AOwner : TComponent);
begin
  inherited;
  FRoot := 'C:\';      
  FWatchSubTree := True;
  FFilters := [nfFilenameChange, nfDirNameChange];
  Start;
end;

destructor TspCustomShellChangeNotifier.Destroy;
var
  Temp : TspShellChangeThread;
begin
  if Assigned(FThread) then
  begin
    Temp := FThread;
    FThread := nil;
    Temp.Terminate;
    ReleaseMutex(Temp.FMutex);
  end;
  inherited;
end;

procedure TspCustomShellChangeNotifier.SetRoot(const Value: TRoot);
begin
  if not SameText(FRoot, Value) then
  begin
    FRoot := Value;
    Change;
  end;
end;

procedure TspCustomShellChangeNotifier.SetFilters(const Value: TNotifyFilters);
begin
  FFilters := Value;
  Change;
end;

procedure TspCustomShellChangeNotifier.SetOnChange(const Value: TThreadMethod);
begin
  FOnChange := Value;
  if Assigned(FThread) then
    FThread.ChangeEvent := FOnChange
  else
    Start;
end;

procedure TspCustomShellChangeNotifier.SetWatchSubTree(const Value: Boolean);
begin
  FWatchSubTree := Value;
  Change;
end;

procedure TspCustomShellChangeNotifier.Start;

  function NotifyOptionFlags: DWORD;
  begin
    Result := 0;
    if nfFileNameChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    if nfDirNameChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    if nfSizeChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    if nfAttributeChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    if nfWriteChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    if nfSecurityChange in FFilters then
      Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
  end;

begin
  if Assigned(FOnChange) then
  begin
    FThread := TspShellChangeThread.Create(FOnChange);
    FThread.SetDirectoryOptions(FRoot,
      LongBool(FWatchSubTree), NotifyOptionFlags);
    FThread.Resume;
  end;
end;

{ TspShellChangeThread }

constructor TspShellChangeThread.Create(ChangeEvent: TThreadMethod);
begin
  FreeOnTerminate := True;
  FChangeEvent := ChangeEvent;
  FMutex := CreateMutex(nil, True, nil);
  WaitForSingleObject(FMutex, INFINITE); 
  FWaitChanged := false;
  inherited Create(True);
end;

destructor TspShellChangeThread.Destroy;
begin
  if FWaitHandle <> ERROR_INVALID_HANDLE then
    FindCloseChangeNotification(FWaitHandle);
  CloseHandle(FMutex);
  inherited Destroy;
end;

procedure TspShellChangeThread.Execute;
var
  Obj: DWORD;
  Handles: array[0..1] of DWORD;
begin
  EnterCriticalSection(CS);
  FWaitHandle := FindFirstChangeNotification(PChar(FDirectory),
     LongBool(FWatchSubTree), FNotifyOptionFlags);
  LeaveCriticalSection(CS);
  if FWaitHandle = ERROR_INVALID_HANDLE then Exit;
  while not Terminated do
  begin
    Handles[0] := FWaitHandle;
    Handles[1] := FMutex;
    Obj := WaitForMultipleObjects(2, @Handles, False, INFINITE);
    case Obj of
      WAIT_OBJECT_0:
        begin
          Synchronize(FChangeEvent);
          FindNextChangeNotification(FWaitHandle);
        end;
      WAIT_OBJECT_0 + 1:
        ReleaseMutex(FMutex);
      WAIT_FAILED:
        Exit;
    end;
    EnterCriticalSection(CS);
    if FWaitChanged then
    begin
      FWaitHandle := FindFirstChangeNotification(PChar(FDirectory),
         LongBool(FWatchSubTree), FNotifyOptionFlags);
      FWaitChanged := false;
    end;
    LeaveCriticalSection(CS);
  end;
end;

procedure TspShellChangeThread.SetDirectoryOptions(Directory: String;
  WatchSubTree: Boolean; NotifyOptionFlags: DWORD);
begin
  EnterCriticalSection(CS);
  FDirectory := Directory;
  FWatchSubTree := WatchSubTree;
  FNotifyOptionFlags := NotifyOptionFlags;
  FindCloseChangeNotification(FWaitHandle);
  FWaitChanged := true;
  LeaveCriticalSection(CS);
end;

{ TspCustomShellTreeView }

constructor TspCustomShellTreeView.Create(AOwner: TComponent);
var
  FileInfo: TSHFileInfo;
begin
  inherited Create(AOwner);
  FRootFolder := nil;
  ShowRoot := False;
  FObjectTypes := [otFolders];
  RightClickSelect := True;
  FAutoContext := True;
  FUpdating := False;
  FListView := nil;
  FComboBox := nil;
  FImageListChanging := False;
  FUseShellImages := True;
  FImages := SHGetFileInfo('C:\',   
    0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  ImageList_SetBkColor(FImages, CLR_NONE);
  FNotifier := TspShellChangeNotifier.Create(Self);
  {$IFNDEF VER130}
  FNotifier.FComponentStyle := FNotifier.FComponentStyle + [ csSubComponent ];
  {$ENDIF}
  FRoot := SRFDesktop;
  FLoadingRoot := False;
end;

procedure TspCustomShellTreeView.ExpandMyComputer;
var
  ID: PItemIDList;
begin
  SHGetSpecialFolderLocation(0, nFolder[rfMyComputer], ID);
  SetPathFromID(ID);
  if Selected <> nil
  then
    begin
      Selected.Expand(False);
    end;
end;

procedure TspCustomShellTreeView.ClearItems;
var
  I: Integer;
begin
  Items.BeginUpdate;
  try
    for I := 0 to Items.Count-1 do
    begin
      if Assigned(Folders[i]) then
        Folders[I].Free;
      Items[I].Data := nil;
    end;
    Items.Clear;
  finally
    Items.EndUpdate;
  end;
end;

procedure TspCustomShellTreeView.CreateWnd;
begin
  inherited CreateWnd;
  if (Items.Count > 0) then ClearItems;
  if not Assigned(Images) then SetUseShellImages(FUseShellImages);
  if (not FLoadingRoot) then CreateRoot;
end;

procedure TspCustomShellTreeView.DestroyWnd;
begin
  ClearItems;
  inherited DestroyWnd;
end;

procedure TspCustomShellTreeView.CommandCompleted(Verb: String;
  Succeeded: Boolean);
var
  Fldr : TspShellFolder;
begin
  if not Succeeded then Exit;
  if Assigned(Selected) then
  begin
    if SameText(Verb, SCmdVerbDelete) then
    begin
      Fldr := TspShellFolder(Selected.Data);
      if not FileExists(Fldr.PathName) then
      begin
        Selected.Data := nil;
        Selected.Delete;
        FreeAndNil(Fldr);
      end;
    end
    else if SameText(Verb, SCmdVerbPaste) then
      Refresh(Selected)
    else if SameText(Verb, SCmdVerbOpen) then
      SetCurrentDirectory(PChar(FSavePath));
  end;
end;

procedure TspCustomShellTreeView.ExecuteCommand(Verb: String;
  var Handled: Boolean);
var
  szPath: array[0..MAX_PATH] of char;
begin
  if SameText(Verb, SCmdVerbRename) and Assigned(Selected) then
  begin
    Selected.EditText;
    Handled := True;
  end
  else if SameText(Verb, SCmdVerbOpen) then
  begin
    GetCurrentDirectory(MAX_PATH, szPath);
    FSavePath := StrPas(szPath);
    StrPCopy(szPath, ExtractFilePath(TspShellFolder(Selected.Data).PathName));
    SetCurrentDirectory(szPath);
  end;

end;

function TreeSortFunc(Node1, Node2: TTreeNode; lParam: Integer): Integer; stdcall;
begin
  Result := SmallInt(TspShellFolder(Node1.Data).ParentShellFolder.CompareIDs(
       0, TspShellFolder(Node1.Data).RelativeID, TspShellFolder(Node2.Data).RelativeID));
end;

procedure TspCustomShellTreeView.InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode);
var
  CanAdd: Boolean;
  NewFolder: IShellFolder;
  AFolder: TspShellFolder;
  S: String;
begin
  AFolder := TspShellFolder(ParentNode.Data);
  NewFolder := GetIShellFolder(AFolder.ShellFolder, ID);
  NewNode.Data := TspShellFolder.Create(AFolder, ID, NewFolder);
  with TspShellFolder(NewNode.Data) do
  begin
    S := PathName;
    NewNode.Text := DisplayName;
    if FUseShellImages and not Assigned(Images) then
    begin
      NewNode.ImageIndex := GetShellImage(AbsoluteID, False, False);
      NewNode.SelectedIndex := GetShellImage(AbsoluteID, False, True);
    end;
    if NewNode.SelectedIndex = 0 then NewNode.SelectedIndex := NewNode.ImageIndex;
    NewNode.HasChildren := SubFolders;
    if (otNonFolders in ObjectTypes) and (ShellFolder <> nil) then
      NewNode.HasChildren := GetHasSubItems(ShellFolder, ObjectFlags(FObjectTypes));
  end;

  CanAdd := True;
  if Assigned(FOnAddFolder) then FOnAddFolder(Self, TspShellFolder(NewNode.Data), CanAdd);
  if not CanAdd then
    NewNode.Delete;
end;

procedure TspCustomShellTreeView.PopulateNode(Node: TTreeNode);
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NewNode: TTreeNode;
  NumIDs: LongWord;
  SaveCursor: TCursor;
  HR: HResult;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  Items.BeginUpdate;
  try
    try
      HR := TspShellFolder(Node.Data).ShellFolder.EnumObjects(Application.Handle,
                     ObjectFlags(FObjectTypes),
                     EnumList);
      if HR <> 0 then Exit;
    except on E:Exception do end;

    while EnumList.Next(1, ID, NumIDs) = S_OK do
    begin
      NewNode := Items.AddChild(Node, '');
      InitNode(NewNode, ID, Node);
    end;

    Node.CustomSort(@TreeSortFunc, 0);
  finally
    Items.EndUpdate;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TspCustomShellTreeView.SetObjectTypes(Value: TShellObjectTypes);
begin
  FObjectTypes := Value;
  RootChanged;
end;

procedure TspCustomShellTreeView.CreateRoot;
var
  RootNode: TTreeNode;
  ErrorMsg: string;
begin
  if (csLoading in ComponentState) then Exit;
  try
    FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
    ErrorMsg := '';
  except
    on E : Exception do ErrorMsg := E.Message;
  end;

  if Assigned(FRootFolder) then
  begin
    FLoadingRoot := true;
    try
      if Items.Count > 0 then
        ClearItems;
      RootNode := Items.Add(nil, '');
      with RootNode do
      begin
        Data := TspShellFolder.Create(nil, FRootFolder.AbsoluteID, FRootFolder.ShellFolder);

        Text := GetDisplayName(DesktopShellFolder,
                               TspShellFolder(Data).AbsoluteID,
                               SHGDN_NORMAL);

        if FUseShellImages and not Assigned(Images) then
        begin
          RootNode.ImageIndex := GetShellImage(TspShellFolder(RootNode.Data).AbsoluteID, False, False);
          RootNode.SelectedIndex := GetShellImage(TspShellFolder(RootNode.Data).AbsoluteID, False, True);
        end;
        RootNode.HasChildren := TspShellFolder(RootNode.Data).SubFolders;
      end;
      RootNode.Expand(False);
      Selected := RootNode;
    finally
      FLoadingRoot := False;
    end;
  end;
  if ErrorMsg <> '' then
    Raise Exception.Create( ErrorMsg );
end;

function TspCustomShellTreeView.CanExpand(Node: TTreeNode): Boolean;
var
  Fldr: TspShellFolder;
begin
  Result := True;
  Fldr := TspShellFolder(Node.Data);
  if (csDesigning in ComponentState) and (Node.Level > 0) then Exit;
  if Assigned(OnExpanding) then OnExpanding(Self, Node, Result);
  if Result then
    if Fldr.IsFolder and (Node.HasChildren) and (Node.Count = 0) then
      PopulateNode(Node)
    else if not Fldr.IsFolder then
    begin
      ShellExecute(Handle, nil, PChar(Fldr.PathName), nil,
        PChar(ExtractFilePath(Fldr.PathName)), 0);
    end;
  Node.HasChildren := Node.Count > 0;
end;

procedure TspCustomShellTreeView.Edit(const Item: TTVItem);
var
  S: string;
  Node: TTreeNode;
begin
  with Item do
    if pszText <> nil then
    begin
      S := pszText;
      Node := Items.GetNode(Item.hItem);
      if Assigned(OnEdited) then OnEdited(Self, Node, S);
      if ( Node <> nil ) and TspShellFolder(Node.Data).Rename(S) then
        Node.Text := S;
    end;
end;

procedure TspCustomShellTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

function TspCustomShellTreeView.NodeFromRelativeID(ParentNode: TTreeNode; ID: PItemIDList): TTreeNode;
var
  HR: HResult;
begin
  Result := ParentNode.GetFirstChild;
  while (Result <> nil) do
  begin
    HR := TspShellFolder(ParentNode.Data).ShellFolder.CompareIDs(0, ID, TspShellFolder(Result.Data).RelativeID);
    if HR = 0 then Exit;
    Result := ParentNode.GetNextChild(Result);
  end;
end;

function TspCustomShellTreeView.NodeFromAbsoluteID(StartNode: TTreeNode; ID: PItemIDList): TTreeNode;
var
  HR: HResult;
begin
  Result := StartNode;
  while Result <> nil do
  begin
    HR := DesktopShellFolder.CompareIDs(0, ID, TspShellFolder(Result.Data).AbsoluteID);
    if HR = 0 then Exit;
    Result := Result.GetNext;
  end;
end;

procedure TspCustomShellTreeView.Delete(Node: TTreeNode);
begin
  if Assigned(Node.Data) then
  begin
    TspShellFolder(Node.Data).Free;
    Node.Data := nil;
  end;
  inherited Delete(Node);
end;

procedure TspCustomShellTreeView.RootChanged;
begin
  if FUpdating then Exit;
  FUpdating := True;
  try
    CreateRoot;
    if Assigned(FListView) then
      FListView.SetRoot(FRoot);
  finally
    FUpdating := False;
  end;
end;

function TspCustomShellTreeView.FolderExists(FindID: PItemIDList; InNode: TTreeNode): TTreeNode;
var
  ALevel: Integer;
begin
  Result := nil;
  ALevel := InNode.Level;
  repeat
    if DesktopShellFolder.CompareIDs(
      0,
      FindID,
      TspShellFolder(InNode.Data).AbsoluteID) = 0 then
    begin
      Result := InNode;
      Exit;
    end else
      InNode := InNode.GetNext;
  until (InNode = nil) or (InNode.Level <= ALevel);
end;

procedure TspCustomShellTreeView.RefreshEvent;
begin
  if Assigned(Selected) then
    Refresh(Selected);
end;

procedure TspCustomShellTreeView.Refresh(Node: TTreeNode);
var
  NewNode, OldNode, Temp: TTreeNode;
  OldFolder, NewFolder: TspShellFolder;
  ThisLevel: Integer;
  SaveCursor: TCursor;
  TopID, SelID: PItemIDList;
  ParentFolder: TspShellFolder;
begin
  if TspShellFolder(Node.Data).ShellFolder = nil then Exit;
  SaveCursor := Screen.Cursor;
  ParentFolder := nil;
  TopID := CopyPIDL(TspShellFolder(TopItem.Data).RelativeID);
  if TspShellFolder(TopItem.Data).Parent <> nil then
    TopID := ConcatPIDLs(TspShellFolder(TopItem.Data).Parent.AbsoluteID, TopID);
  SelID := nil;
  if (Selected <> nil) and (Selected.Data <> nil) then
  begin
    SelID := CopyPIDL(TspShellFolder(Selected.Data).RelativeID);
    if TspShellFolder(Selected.Data).Parent <> nil then
      SelID := ConcatPIDLs(TspShellFolder(Selected.Data).Parent.AbsoluteID, SelID);
  end;

  Items.BeginUpdate;
  try
    Screen.Cursor := crHourglass;
    OldFolder := Node.Data;
    NewNode := Items.Insert(Node, '');
    if Node.Parent <> nil then
      ParentFolder := TspShellFolder(Node.Parent.Data);
    NewNode.Data := TspShellFolder.Create(ParentFolder,
                                   OldFolder.RelativeID,
                                   OldFolder.ShellFolder);
    PopulateNode(NewNode);
    with NewNode do
    begin
      NewFolder := Data;
      ImageIndex := GetShellImage(NewFolder.AbsoluteID, False, False);
      SelectedIndex := GetShellImage(NewFolder.AbsoluteID, False, True);
      HasChildren := NewFolder.SubFolders;
      Text := NewFolder.DisplayName;
    end;

    ThisLevel := Node.Level;
    OldNode := Node;
    repeat
      Temp := FolderExists(TspShellFolder(OldNode.Data).AbsoluteID, NewNode);
      if (Temp <> nil) and OldNode.Expanded then
        Temp.Expand(False);
      OldNode := OldNode.GetNext;
    until (OldNode = nil) or (OldNode.Level = ThisLevel);

    if Assigned(Node.Data) then
    begin
      TspShellFolder(Node.Data).Free;
      Node.Data := nil;
    end;
    Node.Delete;
    if SelID <> nil then
    begin
      Temp := FolderExists(SelID, Items[0]);
      Selected := Temp;
    end;
    Temp := FolderExists(TopID, Items[0]);
    TopItem := Temp;
  finally
    Items.EndUpdate;
    DisposePIDL(TopID);
    if SelID <> nil then DisposePIDL(SelID);
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TspCustomShellTreeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FListView) then
      FListView := nil else
    if (AComponent = FComboBox) then
      FComboBox := nil
  end;
end;

function TspCustomShellTreeView.CanChange(Node: TTreeNode): Boolean;
var
  Fldr: TspShellFolder;
  StayFresh: boolean;
begin
  Result := inherited CanChange(Node);
  if Result and (not FUpdating) and Assigned(Node) then
  begin
    Fldr := TspShellFolder(Node.Data);
    StayFresh := FAutoRefresh;
    AutoRefresh := False;
    if not Fldr.IsFolder then
      Fldr := Fldr.Parent;
    FUpdating := True;
    try
     if Assigned(FComboBox) then
       FComboBox.TreeUpdate(Fldr.AbsoluteID);

     if Assigned(FListView) then
        FListView.TreeUpdate(Fldr.AbsoluteID);
    finally
      FUpdating := False;
    end;
    FNodeToMonitor := Node;
    try
      AutoRefresh := StayFresh;
    finally
      FNodeToMonitor := nil;
    end;
  end;
end;

function TspCustomShellTreeView.GetFolder(Index: Integer): TspShellFolder;
begin
  Result := TspShellFolder(Items[Index].Data);
end;

function TspCustomShellTreeView.SelectedFolder: TspShellFolder;
begin
  Result := nil;
  if Selected <> nil then Result := TspShellFolder(Selected.Data);
end;

function TspCustomShellTreeView.GetPath: String;
begin
  if SelectedFolder <> nil then
    Result := SelectedFolder.PathName
  else
    Result := '';
end;

procedure TspCustomShellTreeView.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
begin
  NumChars := Length(Value);
  Flags := 0;
  P := StringToOleStr(Value);
  try
    OLECheck(DesktopShellFolder.ParseDisplayName(
        0,
        nil,
        P,
        NumChars,
        NewPIDL,
        Flags)
     );
    SetPathFromID(NewPIDL);
    if Selected <> nil
    then
      begin
        Selected.Expand(False);
        CanChange(Selected);
      end;
  except on EOleSysError do
    raise EInvalidPath.CreateFmt(SErrorSettingPath, [Value]);
  end;
end;

procedure TspCustomShellTreeView.SetPathFromID(ID: PItemIDList);
var
  I: Integer;
  Pidls: TList;
  Temp, Node: TTreeNode;
begin
  if (csLoading in ComponentState) or
     ((SelectedFolder <> nil) and SamePIDL(SelectedFolder.AbsoluteID, ID)) then Exit;
  FUpdating := True;
  Items.BeginUpdate;
  try
    Pidls := CreatePIDLList(ID);
    try
      Node := Items[0];
      for I := 0 to Pidls.Count-1 do
      begin
        Temp := FolderExists(Pidls[I], Node);
        if Temp <> nil then
        begin
          Node := Temp;
          Node.Expand(False);
        end;
      end;
      Node := FolderExists(ID, Node);
      Selected := Node;
      if Assigned(Node) then
      begin
        if Assigned(FListView) then
          FListView.TreeUpdate(TspShellFolder(Node.Data).AbsoluteID);
        if Assigned(FComboBox) then
          FComboBox.TreeUpdate(TspShellFolder(Node.Data).AbsoluteID);
      end;
    finally
      DestroyPIDLList(Pidls);
    end;
  finally
    Items.EndUpdate;
    FUpdating := False;
  end;
end;

procedure TspCustomShellTreeView.SetRoot(const Value: TRoot);
begin
  if not SameText(FRoot, Value) then
  begin
    FOldRoot := FRoot;
    FRoot := Value;
    RootChanged;
  end;
end;

procedure TspCustomShellTreeView.GetImageIndex(Node: TTreeNode);
begin
  if Assigned(Images) then
    inherited GetImageIndex(Node);
end;

procedure TspCustomShellTreeView.GetSelectedIndex(Node: TTreeNode);
begin
  if Assigned(Images) then
    inherited GetSelectedIndex(Node);
end;

procedure TspCustomShellTreeView.WndProc(var Message: TMessage);
var
  ImageListHandle: THandle;
begin
  case Message.Msg of
    WM_INITMENUPOPUP,
    WM_DRAWITEM,
    WM_MENUCHAR,
    WM_MEASUREITEM:
      if Assigned(ICM2) then
      begin
        ICM2.HandleMenuMsg(Message.Msg, Message.wParam, Message.lParam);
        Message.Result := 0;
      end;

    TVM_SETIMAGELIST:
      if not FImageListChanging then
      begin
        FImageListChanging := True;
        try
         if not Assigned(Images) then
           if FUseShellImages then
             ImageListHandle := FImages
           else
             ImageListHandle := 0
         else
           ImageListHandle := Images.Handle;

           SendMessage(Self.Handle, TVM_SETIMAGELIST, TVSIL_NORMAL, ImageListHandle);
        finally
          FImageListChanging := False;
        end;
      end
      else inherited;
  else
    inherited WndProc(Message);
  end;
end;

procedure TspCustomShellTreeView.SetUseShellImages(const Value: Boolean);
var
  ImageListHandle: THandle;
begin
  FUseShellImages := Value;
  if not Assigned(Images) then
    if FUseShellImages then
      ImageListHandle := FImages
    else
      ImageListHandle := 0
  else
    ImageListHandle := Images.Handle;
  SendMessage(Handle, TVM_SETIMAGELIST, TVSIL_NORMAL, ImageListHandle);
end;

procedure TspCustomShellTreeView.WMDestroy(var Message: TWMDestroy);
begin
  ClearItems;
  inherited;
end;

procedure TspCustomShellTreeView.Loaded;
begin
  inherited Loaded;
  CreateRoot;
end;

procedure TspCustomShellTreeView.DoContextPopup(MousePos: TPoint;
  var Handled: Boolean);
begin
  if AutoContextMenus and not (Assigned(PopupMenu) and PopupMenu.AutoPopup) then
    InvokeContextMenu(Self, SelectedFolder, MousePos.X, MousePos.Y)
  else
    inherited;
end;

procedure TspCustomShellTreeView.SetComboBox(Value: TspCustomShellComboBox);
begin
  if Value = FComboBox then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FTreeView := Self;
  end else
    if FComboBox <> nil then
      FComboBox.FTreeView := nil;

  if FComboBox <> nil then
    FComboBox.FreeNotification(Self);
  FComboBox := Value;
end;

procedure TspCustomShellTreeView.SetListView(const Value: TspCustomShellListView);
begin
  if Value = FListView then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FTreeView := Self;
  end else
    if FListView <> nil then
      FListView.FTreeView := nil;

  if FListView <> nil then
    FListView.FreeNotification(Self);
  FListView := Value;
end;

procedure TspCustomShellTreeView.SetAutoRefresh(const Value: boolean);
begin
  FAutoRefresh := Value;
  if not (csLoading in ComponentState) then
  begin
    if FAutoRefresh then
    begin
      if Assigned(FNotifier) then
        FreeAndNil(FNotifier);
      FNotifier := TspShellChangeNotifier.Create(Self);
      {$IFNDEF VER130}
      FNotifier.FComponentStyle := FNotifier.FComponentStyle + [ csSubComponent ];
      {$ENDIF}
      FNotifier.WatchSubTree := False;
      if Assigned(FNodeToMonitor) then
        FNotifier.Root := TspShellFolder(FNodeToMonitor.Data).PathName
      else
        FNotifier.Root := FRootFolder.PathName;
      FNotifier.OnChange := Self.RefreshEvent;
    end
    else if Assigned(FNotifier) then
      FreeAndNil(FNotifier);
  end;
end;

{ TspCustomShellListView }

constructor TspCustomShellListView.Create(AOwner: TComponent);
var
  FileInfo: TSHFileInfo;
begin
  inherited Create(AOwner);
  FMask := '*.*|*.*';
  FRootFolder := nil;
  OwnerData := True;
  FSorted := True;
  FObjectTypes := [otFolders, otNonFolders];
  FAutoContext := True;
  FAutoNavigate := True;
  FAutoRefresh := False;
  FFolders := TList.Create;
  FTreeView := nil;
  FUpdating := False;
  FSettingRoot := False;
  FSmallImages := SHGetFileInfo('C:\', 
    0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  FLargeImages := SHGetFileInfo('C:\',
    0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  FRoot := SRFDesktop;
  HideSelection := False;
end;

destructor TspCustomShellListView.Destroy;
begin
  ClearItems;
  FFolders.Free;
  inherited;
end;

function TspCustomShellListView.GetPath: String;
begin
  if RootFolder <> nil then
    Result := RootFolder.PathName
  else
    Result := '';
end;

procedure TspCustomShellListView.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
begin
  NumChars := Length(Value);
  Flags := 0;
  P := StringToOleStr(Value);
  try
    OLECheck(DesktopShellFolder.ParseDisplayName(
        0,
        nil,
        P,
        NumChars,
        NewPIDL,
        Flags)
     );
    SetPathFromID(NewPIDL);
  except on EOleSysError do
    raise EInvalidPath.CreateFmt(SErrorSettingPath, [Value]);
  end;
end;

procedure TspCustomShellListView.GetSelectedFiles(AFiles: TStrings);
var
  I: Integer;
begin
  AFiles.Clear;
  for I := 0 to Items.Count - 1 do
  begin
    if Items[I].Selected and not Folders[I].IsFolder 
    then
      AFiles.Add(Folders[I].PathName);
  end;
end;

function TspCustomShellListView.GetSelectedFile: String;
begin
  Result := '';
  if (SelectedFolder <> nil) and not SelectedFolder.IsFolder
  then
    Result := SelectedFolder.PathName;
end;


procedure TspCustomShellListView.SetMask;
begin
  if FMask <> Value
  then
    begin
      FMask := Value;
      RootChanged;
    end;
end;

procedure TspCustomShellListView.ClearItems;
var
  I: Integer;
begin
  if not (csDestroying in ComponentState) then
    Items.Count := 0;
  for I := 0 to FFolders.Count-1 do
    if Assigned(Folders[i]) then
      Folders[I].Free;

  FFolders.Clear;
end;

procedure TspCustomShellListView.CommandCompleted(Verb: String;
  Succeeded: Boolean);
begin
  if not Succeeded then Exit;
  if SameText(Verb, SCmdVerbDelete) or SameText(Verb, SCmdVerbPaste) then
    Refresh
  else if SameText(Verb, SCmdVerbOpen) then
    SetCurrentDirectory(PChar(FSavePath));
end;

procedure TspCustomShellListView.ExecuteCommand(Verb: String;
  var Handled: Boolean);
var
  szPath: array[0..MAX_PATH] of char;
begin
  if SameText(Verb, SCmdVerbRename) then
  begin
    EditText;
    Handled := True;
  end
  else if SameText(Verb, SCmdVerbOpen) then
  begin
    GetCurrentDirectory(MAX_PATH, szPath);
    FSavePath := StrPas(szPath);
    StrPCopy(szPath, ExtractFilePath(Folders[Selected.Index].PathName));
    SetCurrentDirectory(szPath);
  end;
end;

var
  CompareFolder: TspShellFolder = nil;

function ListSortFunc(Item1, Item2: Pointer): Integer;
const
  R: array[Boolean] of Byte = (0, 1);
begin
  Result := 0;
  if (Item1 = nil) or (Item2 = nil) then Exit;

  Result := R[TspShellFolder(Item2).IsFolder] - R[TspShellFolder(Item1).IsFolder];
  if (Result = 0) and (TspShellFolder(Item1).ParentShellFolder <> nil) then
    Result := Smallint(
                  TspShellFolder(Item1).ParentShellFolder.CompareIDs(
                  0,
                  TspShellFolder(Item1).RelativeID,
                  TspShellFolder(Item2).RelativeID)
              );
end;

  
procedure TspCustomShellListView.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    if FSmallImages <> 0 then
      SendMessage(Handle, LVM_SETIMAGELIST, LVSIL_SMALL, FSmallImages);
    if FLargeImages <> 0 then
      SendMessage(Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, FLargeImages);
  end;
  CreateRoot;
  RootChanged;
end;

procedure TspCustomShellListView.DestroyWnd;
begin
  ClearItems;
  inherited DestroyWnd;
end;

procedure TspCustomShellListView.SetObjectTypes(Value: TShellObjectTypes);
begin
  FObjectTypes := Value;
  if not (csLoading in ComponentState) then
    RootChanged;
end;

procedure TspCustomShellListView.RootChanged;
var
  StayFresh: boolean;
begin
  if FUpdating then Exit;

  FUpdating := True;
  try
    StayFresh := FAutoRefresh;
    AutoRefresh := False;
    SynchPaths;
    Populate;
    if ViewStyle = vsReport then EnumColumns;
    AutoRefresh := StayFresh;
  finally
    FUpdating := False;
  end;
end;

procedure TspCustomShellListView.Populate;
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NumIDs: LongWord;
  SaveCursor: TCursor;
  HR: HResult;
  CanAdd: Boolean;
  NewFolder: IShellFolder;
  Count: Integer;
  AFolder: TspShellFolder;

procedure CheckFile;
var
  TempMask: String;
  I: Integer;
begin
  TempMask := '';
  CanAdd := False;
  for I := 1 to Length(FMask) do
  begin
    if (FMask[I] = ';') or (FMask[I] = '|') or (I = Length(FMask))
    then
      begin
        if (I = Length(FMask)) and (FMask[I] <> ';') and (FMask[I] <> '|')
        then
          TempMask := TempMask + FMask[I];
        CanAdd := (Pos('.', TempMask) <> 0) and MatchesMask(AFolder.PathName, TempMask);
        if CanAdd then Exit else TempMask := '';
      end
    else
      begin
        TempMask := TempMask + FMask[I]
      end;
  end;
end;

begin
  if (csLoading in ComponentState) and not HandleAllocated then Exit;
  Items.BeginUpdate;
  try
    ClearItems;
    Count := 0;
    SaveCursor := Screen.Cursor;
    try
      Screen.Cursor := crHourglass;
      HR := FRootFolder.ShellFolder.EnumObjects(Application.Handle,
         ObjectFlags(FObjectTypes), EnumList);

      if HR <> 0 then Exit;

      while EnumList.Next(1, ID, NumIDs) = S_OK do
      begin
        NewFolder := GetIShellFolder(FRootFolder.ShellFolder, ID);

        AFolder := TspShellFolder.Create(FRootFolder, ID, NewFolder);

        CanAdd := True;

        if not AFolder.IsFolder then CheckFile;

        if Assigned(FOnAddFolder) then FOnAddFolder(Self, AFolder, CanAdd);

        if CanAdd then
        begin
          Inc(Count);
          FFolders.Add(AFolder);
        end else
          AFolder.Free;
      end;
      Items.Count := Count;
      if FSorted then
      begin
        CompareFolder := FRootFolder;
        try
          FFolders.Sort(@ListSortFunc);
        finally
          CompareFolder := nil;
        end;
      end;
    finally
      Screen.Cursor := SaveCursor;
    end;
  finally
    Items.EndUpdate;
  end;
end;

procedure TspCustomShellListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FTreeView) then
      FTreeView := nil else
    if (AComponent = FComboBox) then
      FComboBox := nil;
  end;
end;

procedure TspCustomShellListView.DblClick;
begin
  if FAutoNavigate and (Selected <> nil) then
    with Folders[Selected.Index] do
      if IsFolder then
        SetPathFromID(AbsoluteID);
  inherited DblClick;
end;

procedure TspCustomShellListView.EditText;
begin
  if Selected <> nil then
    ListView_EditLabel(Handle, Selected.Index);
end;

procedure TspCustomShellListView.Edit(const Item: TLVItem);
var
  S: string;
begin
  with Item do
  begin
    if iItem >= FFolders.Count then Exit;
    if pszText <> nil then
    begin
      S := pszText;
      TspShellFolder(FFolders[iItem]).Rename(S);
      ListView_RedrawItems(Handle, iItem, iItem);
      if Assigned(FTreeView) and (FTreeView.Selected <> nil)
      then
        FTreeView.Refresh(FTreeView.Selected);
    end;
  end;
end;

procedure TspCustomShellListView.SetAutoRefresh(const Value: Boolean);
begin
  FAutoRefresh := Value;
  if not (csLoading in ComponentState) then
  begin
    if FAutoRefresh then
    begin
      if Assigned(FNotifier) then
        FreeAndNil(FNotifier);
      FNotifier := TspShellChangeNotifier.Create(Self);
      {$IFNDEF VER130}
      FNotifier.FComponentStyle := FNotifier.FComponentStyle + [ csSubComponent ];
      {$ENDIF}
      FNotifier.WatchSubTree := False;
      FNotifier.Root := FRootFolder.PathName;
      FNotifier.OnChange := Self.Refresh;
    end
    else if Assigned(FNotifier) then
      FreeAndNil(FNotifier);
  end;
end;

procedure TspCustomShellListView.SetRoot(const Value: TRoot);
begin
  if not SameText(Value, FRoot) then
  begin
    FOldRoot := FRoot;
    FRoot := Value;
    CreateRoot;
    FSettingRoot := True;
    RootChanged;
  end;
end;

function TspCustomShellListView.SelectedFolder: TspShellFolder;
begin
  Result := nil;
  if Selected <> nil then Result := Folders[Selected.Index];
end;

function TspCustomShellListView.OwnerDataFetch(Item: TListItem;
  Request: TItemRequest): Boolean;

var
  AFolder: TspShellFolder;
  J: integer;
begin
  Result := True;
  AFolder := Folders[Item.Index];
  if not Assigned(AFolder) then exit;

  if (Item.Index > FFolders.Count - 1) or (Item.Index < 0) then Exit;
  if irText in Request then
    Item.Caption := AFolder.DisplayName;
  if irImage in Request then
    Item.ImageIndex := AFolder.ImageIndex(ViewStyle = vsIcon);
    
  if ViewStyle <> vsReport then Exit;

  AFolder.LoadColumnDetails(FRootFolder, Self.Handle, Columns.Count);
  for J := 1 to Columns.Count - 1 do
    Item.SubItems.Add(AFolder.Details[J]);
end;

function TspCustomShellListView.GetFolder(Index: Integer): TspShellFolder;
begin
  Result := TspShellFolder(FFolders[Index]);
end;

function TspCustomShellListView.OwnerDataFind(Find: TItemFind;
  const FindString: string; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection;
  Wrap: Boolean): Integer;
var
  I: Integer;
  Found: Boolean;
begin
  Result := -1;
  I := StartIndex;
  if (Find = ifExactString) or (Find = ifPartialString) then
  begin
    repeat
      if (I = FFolders.Count-1) then
        if Wrap then I := 0 else Exit;
      Found := Pos(UpperCase(FindString), UpperCase(Folders[I].DisplayName)) = 1;
      Inc(I);
    until Found or (I = StartIndex);
    if Found then Result := I-1;
  end;
end;

procedure TspCustomShellListView.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    Populate;
  end;
end;

procedure TspCustomShellListView.Loaded;
begin
  inherited Loaded;
  Populate;
  if csLoading in ComponentState then
    inherited Loaded;
  SetAutoRefresh(FAutoRefresh);
end;

procedure TspCustomShellListView.DoContextPopup(MousePos: TPoint;
  var Handled: Boolean);
begin
  if FAutoContext and (SelectedFolder <> nil) then
  begin
    InvokeContextMenu(Self, SelectedFolder, MousePos.X, MousePos.Y);
    Handled := True;
  end else
    inherited;
end;

procedure TspCustomShellListView.Back;
var
  RootPIDL: PItemIDList;
begin
  RootPIDL := CopyPIDL(FRootFolder.AbsoluteID);
  try
    StripLastID(RootPIDL);
    SetPathFromID(RootPIDL);
  finally
    DisposePIDL(RootPIDL);
  end;
end;

procedure TspCustomShellListView.EnumColumns;

var
  ColNames: TStringList;

  function AddColumn(SD: TShellDetails) : boolean;
  var
    PIDL: PItemIDList;
    ColName: string;

    function ColumnIsUnique(const Name: string): boolean;
    var
      i : integer;
    begin
      for i := 0 to ColNames.Count - 1 do
        if SameText(ColNames[i], Name) then
        begin
          Result := False;
          exit;
        end;
      Result := True;
    end;

  begin
    PIDL := nil;
    ColName := StrRetToString(PIDL, SD.Str);
    if ColName <> '' then
    begin
      Result := ColumnIsUnique(ColName);
      if Result then
        with Columns.Add do
        begin
          Caption := ColName;
          case SD.fmt of
            LVCFMT_CENTER: Alignment := taCenter;
            LVCFMT_LEFT: Alignment := taLeftJustify;
            LVCFMT_RIGHT: Alignment := taRightJustify;
          end;
          Width := SD.cxChar * Canvas.TextWidth('X');
          ColNames.Add(ColName);
        end;
    end
    else
      Result := True;
  end;

  procedure AddDefaultColumn(const ACaption: string; const AAlignment: TAlignment;
    AWidth: integer);
  begin
    with Columns.Add do
    begin
      Caption := ACaption;
      Alignment := AAlignment;
      Width := AWidth * Canvas.TextWidth('X');
    end;
  end;

 procedure AddDefaultColumns(const ColCount: integer = 1);
  begin
    if (SkinData <> nil) and (SkinData.ResourceStrData  <> nil)
    then
      begin
        if ColCount > 0 then
          AddDefaultColumn(SkinData.ResourceStrData.GetResStr('FLV_NAME'),
                           taLeftJustify, 25);
        if ColCount > 1 then
          AddDefaultColumn(SkinData.ResourceStrData.GetResStr('FLV_SIZE'),
                           taRightJustify, 10);
        if ColCount > 2 then
          AddDefaultColumn(SkinData.ResourceStrData.GetResStr('FLV_TYPE'),
                           taLeftJustify, 10);
        if ColCount > 3 then
          AddDefaultColumn(SkinData.ResourceStrData.GetResStr('FLV_MODIFIED'),
                           taLeftJustify, 14);
      end
    else
      begin
        if ColCount > 0 then
          AddDefaultColumn(SP_FLV_NAME, taLeftJustify, 25);
        if ColCount > 1 then
          AddDefaultColumn(SP_FLV_SIZE, taRightJustify, 10);
        if ColCount > 2 then
          AddDefaultColumn(SP_FLV_TYPE, taLeftJustify, 10);
        if ColCount > 3 then
          AddDefaultColumn(SP_FLV_MODIFIED, taLeftJustify, 14);
      end;    
  end;


var
  Col: Integer;
  SD: TShellDetails;
  PIDL: PItemIDList;
  SF2: IShellFolder2;
  ISD: IShellDetails;
  ColFlags: LongWord;
  Default: Boolean;
begin
  if (not Assigned(FRootFolder)) or (not Assigned(FRootFolder.ShellFolder)) then Exit;
  ColNames := TStringList.Create;
  try
    Columns.BeginUpdate;
    try
      Columns.Clear;
      Col := 0;
      PIDL := nil;
      Default := False;
      FillChar(SD, SizeOf(SD), 0);

      FRootFolder.ViewHandle := Self.Handle;
      SF2 := FRootFolder.ShellFolder2;
      if Assigned(SF2) then 
      begin
        while SF2.GetDetailsOf(PIDL, Col, SD) = S_OK do
        begin
          SF2.GetDefaultColumnState(Col, ColFlags);
          Default := Default or Boolean(ColFlags and SHCOLSTATE_ONBYDEFAULT);
          if Default and not Boolean(ColFlags and SHCOLSTATE_ONBYDEFAULT) then Exit;
          AddColumn(SD);
          Inc(Col);
        end;
      end
      else
      begin
        ISD := FRootFolder.ShellDetails;
        if Assigned(ISD) then
        begin
          while (ISD.GetDetailsOf(nil, Col, SD) = S_OK) do
          begin
            if (AddColumn(SD)) then
              Inc(Col)
            else
              Break;
          end;
        end
        else
        begin
          if (fpFileSystem in FRootFolder.Properties) then
            AddDefaultColumns(4)
          else
            AddDefaultColumns(1);
        end;
      end;

    finally
      Columns.EndUpdate;
    end;
  finally
    ColNames.Free;
  end;
end;

procedure TspCustomShellListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FAutoNavigate then
    case Key of
      VK_RETURN:
        if ssAlt in Shift then
        begin
          DoContextMenuVerb(SelectedFolder, cmvProperties);
          Key := 0;
        end
        else if (SelectedFolder <> nil) then
          if SelectedFolder.IsFolder then
          begin
            SetPathFromID(SelectedFolder.AbsoluteID);
          end;
{         else
            SelectedFolder.ExecuteDefault;}
      VK_BACK: if not IsEditing then Back;
      VK_F5: Refresh;
    end;
end;

{$IFNDEF VER130}
procedure TspCustomShellListView.SetViewStyle(Value: TViewStyle);
begin
  inherited;
  if (Value = vsReport) and not (csLoading in ComponentState) then
    EnumColumns;
end;
{$ENDIF}

procedure TspCustomShellListView.SetComboBox(Value: TspCustomShellComboBox);
begin
  if Value = FComboBox then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FListView := Self;
  end else
    if FComboBox <> nil then
      FComboBox.FListView := nil;

  if FComboBox <> nil then
    FComboBox.FreeNotification(Self);
  FComboBox := Value;
end;

procedure TspCustomShellListView.SetTreeView(Value: TspCustomShellTreeView);
begin
  if Value = FTreeView then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FListView := Self;
  end else
    if FTreeView <> nil then
      FTreeView.FListView := nil;

  if FTreeView <> nil then
    FTreeView.FreeNotification(Self);
  FTreeView := Value;
end;

procedure TspCustomShellListView.TreeUpdate(NewRoot: PItemIDList);
begin
  if FUpdating or (Assigned(FRootFolder)
    and SamePIDL(FRootFolder.AbsoluteID, NewRoot)) then Exit;
  SetPathFromID(NewRoot);
end;

procedure TspCustomShellListView.WndProc(var Message: TMessage);
begin
  with Message do
    if ((Msg = WM_INITMENUPOPUP) or (Msg = WM_DRAWITEM) or (Msg = WM_MENUCHAR)
    or (Msg = WM_MEASUREITEM)) and Assigned(ICM2) then
    begin
      ICM2.HandleMenuMsg(Msg, wParam, lParam);
      Result := 0;
    end;
  inherited;
end;

procedure TspCustomShellListView.Refresh;
var
  SelectedIndex: Integer;
  RootPIDL: PItemIDList;
begin
  SelectedIndex := -1;
  if Selected <> nil then SelectedIndex := Selected.Index;
  Selected := nil;
  RootPIDL := CopyPIDL(FRootFolder.AbsoluteID);
  try
    FreeAndNil(FRootFolder);
    SetPathFromID(RootPIDL);
  finally
    DisposePIDL(RootPIDL);
  end;
  if (SelectedIndex > -1) and (SelectedIndex < Items.Count - 1) then
    Selected := Items[SelectedIndex];
end;

procedure TspCustomShellListView.SetPathFromID(ID: PItemIDList);
begin
  if FUpdating then Exit;

  if Assigned(FRootFolder) then
    if SamePIDL(FRootFolder.AbsoluteID, ID) then
      Exit 
    else
      FRootFolder.Free;

  FSettingRoot := False;
  FRootFolder := CreateRootFromPIDL(ID);
  RootChanged;
  //
  if Assigned(FOnPathChanged) then FOnPathChanged(Self);
  //
end;

procedure TspCustomShellListView.CreateRoot;
begin
  FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
end;

procedure TspCustomShellListView.SynchPaths;
begin
  try
    if FSettingRoot then
    begin
      if Assigned(FTreeView) then
        FTreeView.SetRoot(FRoot);
    end
    else
    if FRootFolder <> nil then
    begin
      if Assigned(FTreeView) then
        FTreeView.SetPathFromID(FRootFolder.AbsoluteID);
      if Assigned(FComboBox) then
        FComboBox.TreeUpdate(FRootFolder.AbsoluteID);
    end;
  finally
    FSettingRoot := False;
  end;
end;

{Dialogs}

constructor TspSelDirDlgForm.CreateEx;
var
  ResStrData: TspResourceStrData;
begin
  inherited CreateNew(AOwner);
  KeyPreview := True;

  Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Self);
  DirTreeViewPanel := TspSkinPanel.Create(Self);

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  with DirTreeViewPanel do
  begin
    Parent := Self;
    Align := alClient;
    BorderStyle := bvFrame;
    Height := 200;
  end;

  VScrollBar := TspSkinScrollBar.Create(Self);
  with VScrollBar do
  begin
    Kind := sbVertical;
    Parent := DirTreeViewPanel;
    Align := alRight;
    DefaultWidth := 19;
    Enabled := False;
    SkinDataName := 'vscrollbar';
  end;
  HScrollBar := TspSkinScrollBar.Create(Self);
  with HScrollBar do
  begin
    Parent := DirTreeViewPanel;
    Align := alBottom;
    DefaultHeight := 19;
    Enabled := False;
    BothMarkerWidth := 19;
    SkinDataName := 'hscrollbar';
  end;

  DirTreeView := TspSkinDirTreeView.Create(Self);
  with DirTreeView do
  begin
    Parent := DirTreeViewPanel;
    Align := alClient;
    HScrollBar := Self.HScrollBar;
    VScrollBar := Self.VScrollBar;
    HideSelection := False;
  end;

  BottomPanel := TspSkinPanel.Create(Self);
  with BottomPanel do
  begin
    Parent := Self;
    Align := alBottom;
    BorderStyle := bvNone;
    Height := 50;
  end;

  OkButton := TspSkinButton.Create(Self);
  with OkButton do
  begin
    Default := True;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    CanFocused := True;
    Left := 20;
    Top := 15;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    ModalResult := mrOk;
  end;

  CancelButton := TspSkinButton.Create(Self);
  with CancelButton do
  begin
     if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    CanFocused := True;
    Left := 100;
    Top := 15;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    ModalResult := mrCancel;
    Cancel := True;
  end;
end;

constructor TspSkinSelectDirectoryDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DialogWidth := 0;
  DialogHeight := 0;
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FTitle := 'Select folder';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FDirectory := ''; 
end;

destructor TspSkinSelectDirectoryDialog.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;


procedure TspSkinSelectDirectoryDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinSelectDirectoryDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinSelectDirectoryDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinSelectDirectoryDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinSelectDirectoryDialog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinSelectDirectoryDialog.Execute: Boolean;
var
  FW, FH: Integer;
begin
  FDlgFrm := TspSelDirDlgForm.CreateEx(Application, CtrlSkinData);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := AlphaBlendValue;
    //
    DirTreeViewPanel.SkinData := FCtrlFSD;
    DirTreeView.DefaultFont := DefaultFont;
    DirTreeView.SkinData := FCtrlFSD;
    if (FDirectory <> '') and DirectoryExists(FDirectory)
    then
      DirTreeView.Path := FDirectory
    else
      DirTreeView.ExpandMyComputer;
    //
    HScrollBar.SkinData := FCtrlFSD;
    VScrollBar.SkinData := FCtrlFSD;
    OkButton.SkinData := FCtrlFSD;
    CancelButton.SkinData := FCtrlFSD;
    BottomPanel.SkinData := FCtrlFSD;
    OkButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;

    if (DialogWidth <> 0)
    then
      begin
        FW := DialogWidth;
        FH := DialogHeight;
      end
    else
      begin
        FW := 280;
        FH := 280;
      end;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    Result := (ShowModal = mrOk);

    DialogWidth := ClientWidth;
    DialogHeight := ClientHeight;

    if Result
    then
      begin
        FDirectory := FDlgFrm.DirTreeView.Path;
        Change;
      end;
  finally
    Free;
    FDlgFrm := nil;
  end;
end;

constructor TspSkinDirectoryEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption];
  ButtonMode := True;
  OnButtonClick := ButtonClick;
  FSkinDataName := 'buttonedit';
  SD := TspSkinSelectDirectoryDialog.Create(Self);
end;

destructor TspSkinDirectoryEdit.Destroy;
begin
  SD.Free;
  inherited;
end;

procedure TspSkinDirectoryEdit.ButtonClick;
begin
  SD.Directory := Text;
  SD.SkinData := FDlgSkinData;
  SD.CtrlSkinData := FDlgCtrlSkinData;
  if SD.Execute then Text := SD.Directory;
end;

procedure TspSkinDirectoryEdit.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDlgSkinData) then FDlgSkinData := nil;
  if (Operation = opRemove) and (AComponent = FDlgCtrlSkinData) then FDlgCtrlSkinData := nil;
end;

constructor TspOpenDlgForm.CreateEx;
var
  ResStrData: TspResourceStrData;

begin
  inherited CreateNew(AOwner);
  FolderHistory := TList.Create;
  StopAddToHistory := False;

  SaveMode := ASaveMode;
  KeyPreview := True;
  Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Self);

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;
  CtrlSD := ACtrlSkinData;
    
  ToolPanel := TspSkinToolBar.Create(Self);
  with ToolPanel do
  begin
    BorderStyle := bvNone;
    Parent := Self;
    Align := alTop;
    DefaultHeight := 25;
    SkinDataName := 'toolpanel';
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alLeft;
    Width := 10;
    Shape := bsSpacer;
  end;

  Drivelabel := TspSkinStdLabel.Create(Self);
  with Drivelabel do
  begin
    Left := 0;
    AutoSize := True;
    Parent := ToolPanel;
    Align := alLeft;
    Layout := tlCenter;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FLV_LOOKIN')
    else
      Caption := SP_FLV_LOOKIN;
  end;

  BackToolButton := TspSkinSpeedButton.Create(Self);
  with BackToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := BackToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_BACK');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_BACK_HINT')
    else
      Hint := SP_MSG_BTN_BACK_HINT;
    ShowHint := True;
  end;

  UpToolButton := TspSkinSpeedButton.Create(Self);
  with UpToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := UpToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_UP');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_UP_HINT')
    else
      Hint := SP_MSG_BTN_UP_HINT;
    ShowHint := True;
  end;

  NewFolderToolButton := TspSkinSpeedButton.Create(Self);
  with NewFolderToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := NewFolderToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_NEWFOLDER');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_NEWFOLDER_HINT')
    else
      Hint := SP_MSG_BTN_NEWFOLDER_HINT;
    ShowHint := True;
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Width := 10;
    Align := alRight;
    Shape := bsSpacer;
  end;

  // popupmenu
  StylePopupMenu := TspSkinPopupMenu.Create(Self);

  IconMenuItem := TMenuItem.Create(Self);
  with IconMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_ICON')
    else
      Caption := SP_MSG_LV_ICON;
    RadioItem := True;
    OnClick := IconItemClick;
  end;
  StylePopupMenu.Items.Add(IconMenuItem);

  SmallIconMenuItem := TMenuItem.Create(Self);
  with SmallIconMenuItem  do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_SMALLICON')
    else
      Caption := SP_MSG_LV_SMALLICON;
    RadioItem := True;
    OnClick := SmallIconItemClick;
  end;
  StylePopupMenu.Items.Add(SmallIconMenuItem );

  ListMenuItem := TMenuItem.Create(Self);
  with ListMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_LIST')
    else
      Caption := SP_MSG_LV_LIST;
    RadioItem := True;
    OnClick := ListItemClick;
  end;
  StylePopupMenu.Items.Add(ListMenuItem);

  ReportMenuItem := TMenuItem.Create(Self);
  with ReportMenuItem do
  begin
     if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_DETAILS')
    else
      Caption := SP_MSG_LV_DETAILS;
    RadioItem := True;
    OnClick := ReportItemClick;
  end;
  StylePopupMenu.Items.Add(ReportMenuItem);

  StyleToolButton := TspSkinMenuSpeedButton.Create(Self);
  with StyleToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    DefaultWidth := 37;
    SkinDataName := 'toolmenubutton';
    Align := alRight;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_LVSTYLE');
    SkinPopupMenu := StylePopupMenu;
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_VIEWMENU_HINT')
    else
      Hint := SP_MSG_BTN_VIEWMENU_HINT;
    ShowHint := True;
  end;

  ShellBox := TspSkinShellComboBox.Create(Self);
  with ShellBox do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alClient;
    Width := 190;
    DropDownCount := 10;
   end;

  BottomPanel := TspSkinPanel.Create(Self);
  with BottomPanel do
  begin
    Parent := Self;
    Align := alBottom;
    BorderStyle := bvNone;
    Height := 80;
  end;

  FileListViewPanel := TspSkinPanel.Create(Self);
  with FileListViewPanel do
  begin
    Parent := Self;
    Align := alClient;
    BorderStyle := bvFrame;
  end;

  FLVHScrollBar := TspSkinScrollBar.Create(Self);
  with FLVHScrollBar do
  begin
    BothMarkerWidth := 19;
    Parent := FileListViewPanel;
    Align := alBottom;
    DefaultHeight := 19;
    Enabled := False;
    SkinDataName := 'hscrollbar';
  end;

  FLVVScrollBar := TspSkinScrollBar.Create(Self);
  with FLVVScrollBar do
  begin
    Kind := sbVertical;
    Parent := FileListViewPanel;
    Align := alRight;
    DefaultWidth := 19;
    Enabled := False;
    SkinDataName := 'vscrollbar';
  end;

  FileListView := TspSkinFileListView.Create(Self);

  with FileListView do
  begin
    Parent := FileListViewPanel;
    ViewStyle := vsList;
    ShowColumnHeaders := True;
    IconOptions.AutoArrange := True;
    Align := alClient;
    HScrollBar := FLVHScrollBar;
    VScrollBar := FLVVScrollBar;
    OnChange := FLVChange;
    OnPathChanged := FLVPathChange;
    OnDblClick := FLVDBLClick;
    HideSelection := False;
    AutoContextMenus := False;
    ShellComboBox := ShellBox;
    OnKeyPress := FLVKeyPress;
  end;

  ShellBox.ShellListView := FileListView;

  FileNameEdit := TspSkinEdit.Create(Self);
  with FileNameEdit do
  begin
    Parent := BottomPanel;
    Top := 10;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnKeyPress := EditKeyPress;
  end;

  FilterComboBox := TspSkinFilterComboBox.Create(Self);
  with FilterComboBox  do
  begin
    Parent := BottomPanel;
    Top := 45;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnChange := FCBChange;
  end;

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
   if SaveMode
    then
      begin
        if ResStrData <> nil
        then
          Caption := ResStrData.GetResStr('MSG_BTN_SAVE')
        else
          Caption := SP_MSG_BTN_SAVE
      end
    else
      begin
        if ResStrData <> nil
        then
          Caption := ResStrData.GetResStr('MSG_BTN_OPEN')
        else
          Caption := SP_MSG_BTN_OPEN;
      end;  
    CanFocused := True;
    Left := 370;
    Top := 10;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    OnClick := OpenButtonClick;
  end;

  CancelButton := TspSkinButton.Create(Self);
  with CancelButton do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    CanFocused := True;
    Left := 370;
    Top := 45;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  OpenFileLabel := TspSkinStdLabel.Create(Self);
  with OpenFileLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILENAME')
    else
      Caption := SP_MSG_FILENAME;
    Left := 10;
    Top := 10;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  FileTypeLabel := TspSkinStdLabel.Create(Self);
  with FileTypeLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILETYPE')
    else
      Caption := SP_MSG_FILETYPE;
    Left := 10;
    Top := 45;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  ActiveControl := FileNameEdit;
end;

destructor TspOpenDlgForm.Destroy;
begin
  FolderHistory.Clear;
  FolderHistory.Free;
  inherited;
end;

procedure TspOpenDlgForm.FLVKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (FileListView.GetSelectedFile <> '')
  then
    OpenButtonClick(Sender);
end;

procedure TspOpenDlgForm.ReportItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsReport;
  {$IFDEF VER130}
  FileListView.EnumColumns;
  {$ENDIF}
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := True;
  ListMenuItem.Checked := False;
end;

procedure TspOpenDlgForm.ListItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsList;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := True;
end;

procedure TspOpenDlgForm.SmallIconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsSmallIcon;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := True;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenDlgForm.IconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsIcon;
  IconMenuItem.Checked := True;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenDlgForm.NewFolderToolButtonClick(Sender: TObject);
var
  S: String;
begin
  if (CtrlSD <> nil) and (CtrlSD.ResourceStrData <> nil)
  then
    S := FileListView.Path + '\' +
         CtrlSD.ResourceStrData.GetResStr('MSG_NEWFOLDER')
  else
    S := FileListView.Path + '\' + SP_MSG_NEWFOLDER;
  if not DirectoryExists(S)
  then
    begin
      MkDir(S);
      FileListView.RootChanged;
    end;
end;

procedure TspOpenDlgForm.UpToolButtonClick(Sender: TObject);
begin
  FileListView.Back;
end;

procedure TspOpenDlgForm.FLVPathChange(Sender: TObject);
var
  ID: PItemIDList;
begin
  if not StopAddToHistory
  then
    begin
      ID := CopyPIDL(FileListView.RootFolder.AbsoluteID);
      if (FolderHistory.Count = 0) or
         (ID <> PItemIDList(FolderHistory.Items[FolderHistory.Count - 1]))
      then
        FolderHistory.Add(PItemIDList(ID));
    end;
  with FileListView do
  begin
    if Items.Count <> 0 then ItemFocused := Items[0];
  end;
end;

procedure TspOpenDlgForm.BackToolButtonClick(Sender: TObject);
var
  ID: PItemIDList;
begin
  if FolderHistory.Count > 1
  then
    begin
      StopAddToHistory := True;
      ID := PItemIDList(FolderHistory.Items[FolderHistory.Count - 2]);
      FileListView.TreeUpdate(ID);
      FolderHistory.Delete(FolderHistory.Count - 2);
      StopAddToHistory := False;
    end;
end;

procedure TspOpenDlgForm.EditKeyPress;
begin
  inherited;
  if Key = #27
  then
    Close
  else
  if Key = #13
  then
    begin
      if Pos('*', FileNameEdit.Text) <> 0
      then
        FileListView.Mask := FileNameEdit.Text
      else
        begin
          if Pos('\', FileNameEdit.Text) <> 0
          then
            begin
              if DirectoryExists(FileNameEdit.Text)
              then
                FileListView.Path := FileNameEdit.Text;
            end
          else
            begin
              OpenButtonClick(Sender);
            end;
        end;
    end;
end;

procedure TspOpenDlgForm.OpenButtonClick;
var
  S: String;
begin
  if (FileListView.GetSelectedFile = '') and not SaveMode then Exit;
  if SaveMode
  then
    begin
      if FileNameEdit.Text = '' then Exit;
      S := FileListView.Path + '\' +  FileNameEdit.Text;
      if (Pos('*', S) = 0)
      then
        begin
          FileName := FileListView.Path + '\' + FileNameEdit.Text;
          ModalResult := mrOk;
        end;
    end
  else
    begin
      FileName := FileListView.GetSelectedFile;
      if FileExists(FileName) then ModalResult := mrOk else FileName := '';
    end;
end;

procedure TspOpenDlgForm.FLVChange;
begin
  FileNameEdit.Text := ExtractFileName(FileListView.GetSelectedFile);

end;

procedure TspOpenDlgForm.FLVDBLClick(Sender: TObject);
begin
  if FileListView.GetSelectedFile <> ''
  then
    begin
      FileName := FileListView.GetSelectedFile;
      ModalResult := mrOk;
    end;
end;

procedure TspOpenDlgForm.FCBChange(Sender: TObject);
begin
  FileListView.Mask := FilterComboBox.Mask;
end;

constructor TspSkinOpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFiles := TStringList.Create;
  FMultiSelection := False; 
  DialogWidth := 0;
  DialogHeight := 0;
  FLVHeaderSkinDataName := 'resizebutton';
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 225;
  FCtrlAlphaBlend := False;
  FCtrlAlphaBlendAnimation := False;
  FCtrlAlphaBlendValue := 225;

  FSaveMode := False;
  FTitle := 'Open file';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FInitialDir := '';
  FFilter := 'All files|*.*';
  FFilterIndex := 1;
  FFileName := '';
  ListViewStyle := vsList;
end;

destructor TspSkinOpenDialog.Destroy;
begin
  FFiles.Free;
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinOpenDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinOpenDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinOpenDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinOpenDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinOpenDialog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinOpenDialog.Execute: Boolean;
var
  FW, FH, CIndex: Integer;
  Ext1, Ext2, Path: String;
begin
  FDlgFrm := TspOpenDlgForm.CreateEx(Application, FSaveMode, CtrlSkinData);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;

   // alphablend
    DSF.AlphaBlend := AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := AlphaBlendValue;

    ShellBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    ShellBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    ShellBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    FilterComboBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    FilterComboBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    FilterComboBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    DSF.MenusAlphaBlend := FCtrlAlphaBlend;
    DSF.MenusAlphaBlendValue := FCtrlAlphaBlendValue;
    DSF.MenusAlphaBlendAnimation := FCtrlAlphaBlendAnimation;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    ShellBox.DefaultFont := DefaultFont;
    FileListView.DefaultFont := DefaultFont;
    //
    case ListViewStyle of
      vsList: ListMenuItem.Checked := True;
      vsReport: ReportMenuItem.Checked := True;
      vsIcon: IconMenuItem.Checked := True;
      vsSmallIcon: SmallIconMenuItem.Checked := True;
    end;

    FileListView.ViewStyle := ListViewStyle;

    if (FFileName <> '') and (ExtractFilePath(FFileName) <> '')
    then
      begin
        Path := ExtractFilePath(FFileName);
        FileListView.Root := Path;
      end
    else
      begin
        if FInitialDir = ''
        then
          FileListView.Root := ExtractFilePath(Application.ExeName)
        else
          FileListView.Root  := FInitialDir;
      end;

    FileListView.Mask := FilterComboBox.Text;
    FileListView.MultiSelect := MultiSelection;
    FileListView.HeaderSkinDataName := FLVHeaderSkinDataName;
    FileListView.SkinData := FCtrlFSD;

    FilterComboBox.Filter := Self.Filter;
    FilterComboBox.ItemIndex := FFilterIndex - 1;
    //
    FileListViewPanel.SkinData := FCtrlFSD;
    BottomPanel.SkinData := FCtrlFSD;
    ToolPanel.SkinData := FCtrlFSD;
    //
    Drivelabel.SkinData := FCtrlFSD;
    UpToolButton.SkinData := FCtrlFSD;
    BackToolButton.SkinData := FCtrlFSD;
    StyleToolButton.SkinData := FCtrlFSD;
    NewFolderToolButton.SkinData := FCtrlFSD;
    //
    FLVHScrollBar.SkinData := FCtrlFSD;
    FLVVScrollBar.SkinData := FCtrlFSD;
    FileNameEdit.SkinData := FCtrlFSD;
    FilterComboBox.SkinData := FCtrlFSD;
    OpenButton.SkinData := FCtrlFSD;
    CancelButton.SkinData := FCtrlFSD;
    OpenFileLabel.SkinData := FCtrlFSD;
    FileTypeLabel.SkinData := FCtrlFSD;
    //
    ShellBox.SkinData := FCtrlFSD;
    if FCtrlFSD <> nil
    then
      CIndex := FCtrlFSD.GetControlIndex('toolcombobox')
    else
      CIndex := -1;
    if CIndex <> -1
    then
      ShellBox.SkinDataName := 'toolcombobox'
    else
      ShellBox.SkinDataName := 'combobox';
    //
    if (DialogWidth <> 0)
    then
      begin
        FW := DialogWidth;
        FH := DialogHeight;
      end
    else
      begin
        FW := 450;
        FH := 290;
      end;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    with FileListView do
    begin
      if Items.Count <> 0 then ItemFocused := Items[0];
    end;

    FileNameEdit.Text := ExtractFileName(FFileName);
    
    Result := (ShowModal = mrOk);

    FFilterIndex := FilterComboBox.ItemIndex + 1;

    DialogWidth := ClientWidth;
    DialogHeight := ClientHeight;

    ListViewStyle := FileListView.ViewStyle;
    if Result
    then
      begin
        Self.FFileName := FDlgFrm.FileName;
        FileListView.GetSelectedFiles(Self.Files);
        // check ext
        if FSaveMode and (Pos('.*', FilterComboBox.Mask) = 0)
        then
          begin
            Ext1 := ExtractFileExt(FilterComboBox.Mask);
            Ext2 := ExtractFileExt(FFileName);
            if LowerCase(Ext1) <> LowerCase(Ext2)
            then
              FFileName := FFileName + Ext1;
          end;
        //
        Change;
      end;
  finally
    Free;
    FDlgFrm := nil;
  end;
end;

constructor TspSkinSaveDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := 'Save file';
  FSaveMode := True;
end;

constructor TspSkinFileEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption];
  ButtonMode := True;
  OnButtonClick := ButtonClick;
  FSkinDataName := 'buttonedit';
  FLVHeaderSkinDataName := 'resizebutton';
  OD := TspSkinOpenDialog.Create(Self);
end;

destructor TspSkinFileEdit.Destroy;
begin
  OD.Free;
  inherited;
end;

function TspSkinFileEdit.GetFilter;
begin
  Result := OD.Filter;
end;

procedure TspSkinFileEdit.SetFilter;
begin
  OD.Filter := Value;
end;

procedure TspSkinFileEdit.ButtonClick;
begin
  OD.FileName := Text;
  OD.SkinData := FDlgSkinData;
  OD.CtrlSkinData := FDlgCtrlSkinData;
  OD.LVHeaderSkinDataName := FLVHeaderSkinDataName;
  if OD.Execute then Text := OD.FileName;
end;

procedure TspSkinFileEdit.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDlgSkinData) then FDlgSkinData := nil;
  if (Operation = opRemove) and (AComponent = FDlgCtrlSkinData) then FDlgCtrlSkinData := nil;
end;

constructor TspSkinSaveFileEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption];
  FLVHeaderSkinDataName := 'resizebutton';
  ButtonMode := True;
  OnButtonClick := ButtonClick;
  FSkinDataName := 'buttonedit';
  OD := TspSkinSaveDialog.Create(Self);
end;

destructor TspSkinSaveFileEdit.Destroy;
begin
  OD.Free;
  inherited;
end;

function TspSkinSaveFileEdit.GetFilter;
begin
  Result := OD.Filter;
end;

procedure TspSkinSaveFileEdit.SetFilter;
begin
  OD.Filter := Value;
end;

procedure TspSkinSaveFileEdit.ButtonClick;
begin
  OD.FileName := Text;
  OD.SkinData := FDlgSkinData;
  OD.CtrlSkinData := FDlgCtrlSkinData;
  OD.LVHeaderSkinDataName := FLVHeaderSkinDataName;
  if OD.Execute then Text := OD.FileName;
end;

procedure TspSkinSaveFileEdit.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDlgSkinData) then FDlgSkinData := nil;
  if (Operation = opRemove) and (AComponent = FDlgCtrlSkinData) then FDlgCtrlSkinData := nil;
end;


// ======= TspSkinOpenPictureDialog ====== //
constructor TspOpenPictureDlgForm.CreateEx;
var
  ResStrData: TspResourceStrData;
begin
  inherited CreateNew(AOwner);
  FolderHistory := TList.Create;
  StopAddToHistory := False;

  SaveMode := ASaveMode;
  KeyPreview := True;
  Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Self);

  //

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  CtrlSD := ACtrlSkinData;

  //

  ImagePanel := TspSkinPanel.Create(Self);
  with ImagePanel do
  begin
    BorderStyle := bvFrame;
    Parent := Self;
    Align := alRight;
    Width := 200;
  end;

  Splitter := TspSkinSplitter.Create(Self);
  with Splitter do
  begin
    Parent := Self;
    Align := alRight;
    Width := 10;
    DefaultSize := 10;
    Beveled := False;
  end;


  SBVScrollBar := TspSkinScrollBar.Create(Self);
  with SBVScrollBar do
  begin
    Kind := sbVertical;
    Parent := ImagePanel;
    Align := alRight;
    DefaultWidth := 19;
    Enabled := False;
    SkinDataName := 'vscrollbar';
  end;

  SBHScrollBar := TspSkinScrollBar.Create(Self);
  with SBHScrollBar do
  begin
    Parent := ImagePanel;
    Align := alBottom;
    DefaultHeight := 19;
    Enabled := False;
    BothMarkerWidth := 19;
    SkinDataName := 'hscrollbar';
  end;

  ScrollBox := TspSkinScrollBox.Create(Self);
  with ScrollBox do
  begin
    Align := alClient;
    BorderStyle := bvNone;
    Parent := ImagePanel;
    HScrollBar := SBHScrollBar;
    VScrollBar := SBVScrollBar;
  end;

  Image := TImage.Create(Self);
  with Image do
  begin
    Parent := ScrollBox;
    Left := 0;
    Top := 0;
  end;


  //

  ToolPanel := TspSkinToolBar.Create(Self);
  with ToolPanel do
  begin
    BorderStyle := bvNone;
    Parent := Self;
    Align := alTop;
    DefaultHeight := 25;
    SkinDataName := 'toolpanel';
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alLeft;
    Width := 10;
    Shape := bsSpacer;
  end;

  Drivelabel := TspSkinStdLabel.Create(Self);
  with Drivelabel do
  begin
    Left := 0;
    AutoSize := True;
    Parent := ToolPanel;
    Align := alLeft;
    Layout := tlCenter;
     if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('LV_LOOKIN')
    else
      Caption := SP_FLV_LOOKIN;
  end;

  BackToolButton := TspSkinSpeedButton.Create(Self);
  with BackToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := BackToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_BACK');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_BACK_HINT')
    else
      Hint := SP_MSG_BTN_BACK_HINT;
    ShowHint := True;
  end;

  UpToolButton := TspSkinSpeedButton.Create(Self);
  with UpToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := UpToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_UP');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_UP_HINT')
    else
      Hint := SP_MSG_BTN_UP_HINT;
    ShowHint := True;
  end;

  NewFolderToolButton := TspSkinSpeedButton.Create(Self);
  with NewFolderToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := NewFolderToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_NEWFOLDER');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_NEWFOLDER_HINT')
    else
      Hint := SP_MSG_BTN_NEWFOLDER_HINT;
    ShowHint := True;
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Width := 10;
    Align := alRight;
    Shape := bsSpacer;
  end;

  // popupmenu
  StylePopupMenu := TspSkinPopupMenu.Create(Self);

  IconMenuItem := TMenuItem.Create(Self);
  with IconMenuItem do
  begin
   if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_ICON')
    else
      Caption := SP_MSG_LV_ICON;
    RadioItem := True;
    OnClick := IconItemClick;
  end;
  StylePopupMenu.Items.Add(IconMenuItem);

  SmallIconMenuItem := TMenuItem.Create(Self);
  with SmallIconMenuItem  do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_SMALLICON')
    else
      Caption := SP_MSG_LV_SMALLICON;
    RadioItem := True;
    OnClick := SmallIconItemClick;
  end;
  StylePopupMenu.Items.Add(SmallIconMenuItem );

  ListMenuItem := TMenuItem.Create(Self);
  with ListMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_LIST')
    else
      Caption := SP_MSG_LV_LIST;
    RadioItem := True;
    OnClick := ListItemClick;
  end;
  StylePopupMenu.Items.Add(ListMenuItem);

  ReportMenuItem := TMenuItem.Create(Self);
  with ReportMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_DETAILS')
    else
      Caption := SP_MSG_LV_DETAILS;
    RadioItem := True;
    OnClick := ReportItemClick;
  end;
  StylePopupMenu.Items.Add(ReportMenuItem);

  StyleToolButton := TspSkinMenuSpeedButton.Create(Self);
  with StyleToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    DefaultWidth := 37;
    SkinDataName := 'toolmenubutton';
    Align := alRight;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_LVSTYLE');
    SkinPopupMenu := StylePopupMenu;
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_VIEWMENU_HINT')
    else
      Hint := SP_MSG_BTN_VIEWMENU_HINT;
    ShowHint := True;
  end;

  StretchButton := TspSkinSpeedButton.Create(Self);
  with StretchButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultWidth := 27;
    GroupIndex := 2;
    AllowAllUp := True;
    SkinDataName := 'toolbutton';
    OnClick := StretchButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_STRETCH');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_STRETCH_HINT')
    else
      Hint := SP_MSG_BTN_STRETCH_HINT;
    ShowHint := True;
  end;

  ShellBox := TspSkinShellComboBox.Create(Self);
  with ShellBox do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alClient;
    Width := 190;
    DropDownCount := 10;
   end;

  BottomPanel := TspSkinPanel.Create(Self);
  with BottomPanel do
  begin
    Parent := Self;
    Align := alBottom;
    BorderStyle := bvNone;
    Height := 80;
  end;

  FileListViewPanel := TspSkinPanel.Create(Self);
  with FileListViewPanel do
  begin
    Parent := Self;
    Align := alClient;
    BorderStyle := bvFrame;
  end;

  FLVHScrollBar := TspSkinScrollBar.Create(Self);
  with FLVHScrollBar do
  begin
    BothMarkerWidth := 19;
    Parent := FileListViewPanel;
    Align := alBottom;
    DefaultHeight := 19;
    Enabled := False;
    SkinDataName := 'hscrollbar';
  end;

  FLVVScrollBar := TspSkinScrollBar.Create(Self);
  with FLVVScrollBar do
  begin
    Kind := sbVertical;
    Parent := FileListViewPanel;
    Align := alRight;
    DefaultWidth := 19;
    Enabled := False;
    SkinDataName := 'vscrollbar';
  end;

  FileListView := TspSkinFileListView.Create(Self);

  with FileListView do
  begin
    Parent := FileListViewPanel;
    ViewStyle := vsList;
    ShowColumnHeaders := True;
    IconOptions.AutoArrange := True;
    Align := alClient;
    HScrollBar := FLVHScrollBar;
    VScrollBar := FLVVScrollBar;
    OnChange := FLVChange;
    OnPathChanged := FLVPathChange;
    OnDblClick := FLVDBLClick;
    HideSelection := False;
    AutoContextMenus := False;
    ShellComboBox := ShellBox;
    OnKeyPress := FLVKeyPress;
  end;

  ShellBox.ShellListView := FileListView;

  FileNameEdit := TspSkinEdit.Create(Self);
  with FileNameEdit do
  begin
    Parent := BottomPanel;
    Top := 10;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnKeyPress := EditKeyPress;
  end;

  FilterComboBox := TspSkinFilterComboBox.Create(Self);
  with FilterComboBox  do
  begin
    Parent := BottomPanel;
    Top := 45;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnChange := FCBChange;
  end;

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
    if SaveMode
    then
      begin
        if ResStrData <> nil
        then
          Caption := ResStrData.GetResStr('MSG_BTN_SAVE')
        else
          Caption := SP_MSG_BTN_SAVE
      end
    else
      begin
        if ResStrData <> nil
        then
          Caption := ResStrData.GetResStr('MSG_BTN_OPEN')
        else
          Caption := SP_MSG_BTN_OPEN;
      end;
    CanFocused := True;
    Left := 370;
    Top := 10;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    OnClick := OpenButtonClick;
  end;

  CancelButton := TspSkinButton.Create(Self);
  with CancelButton do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    CanFocused := True;
    Left := 370;
    Top := 45;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  OpenFileLabel := TspSkinStdLabel.Create(Self);
  with OpenFileLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILENAME')
    else
      Caption := SP_MSG_FILENAME;
    Left := 10;
    Top := 10;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  FileTypeLabel := TspSkinStdLabel.Create(Self);
  with FileTypeLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILETYPE')
    else
      Caption := SP_MSG_FILETYPE;
    Left := 10;
    Top := 45;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  ActiveControl := FileNameEdit;
end;

destructor TspOpenPictureDlgForm.Destroy;
begin
  FolderHistory.Clear;
  FolderHistory.Free;
  inherited;
end;

procedure TspOpenPictureDlgForm.StretchButtonClick(Sender: TObject);
begin
  if StretchButton.Down
  then
    begin
      Image.Visible := False;
      Image.Stretch := True;
      Image.Align := alClient;
      Image.Visible := True;
    end
  else
    begin
      Image.Visible := False;
      Image.Align := alNone;
      Image.Width := Image.Picture.Width;
      Image.Height := Image.Picture.Height;
      Image.Stretch := False;
      Image.Visible := True;
    end;
end;

procedure TspOpenPictureDlgForm.ReportItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsReport;
  {$IFDEF VER130}
  FileListView.EnumColumns;
  {$ENDIF}
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := True;
  ListMenuItem.Checked := False;
end;

procedure TspOpenPictureDlgForm.ListItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsList;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := True;
end;

procedure TspOpenPictureDlgForm.SmallIconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsSmallIcon;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := True;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenPictureDlgForm.IconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsIcon;
  IconMenuItem.Checked := True;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenPictureDlgForm.NewFolderToolButtonClick(Sender: TObject);
var
  S: String;
begin
 if (CtrlSD <> nil) and (CtrlSD.ResourceStrData <> nil)
  then
    S := FileListView.Path + '\' +
         CtrlSD.ResourceStrData.GetResStr('MSG_NEWFOLDER')
  else
    S := FileListView.Path + '\' + Sp_MSG_NEWFOLDER;
  if not DirectoryExists(S)
  then
    begin
      MkDir(S);
      FileListView.RootChanged;
    end;
end;

procedure TspOpenPictureDlgForm.UpToolButtonClick(Sender: TObject);
begin
  FileListView.Back;
end;

procedure TspOpenPictureDlgForm.FLVPathChange(Sender: TObject);
var
  ID: PItemIDList;
begin
  if not StopAddToHistory
  then
    begin
      ID := CopyPIDL(FileListView.RootFolder.AbsoluteID);
      if (FolderHistory.Count = 0) or
         (ID <> PItemIDList(FolderHistory.Items[FolderHistory.Count - 1]))
      then
        FolderHistory.Add(PItemIDList(ID));
    end;
  with FileListView do
  begin
    if Items.Count <> 0 then ItemFocused := Items[0];
  end;
end;

procedure TspOpenPictureDlgForm.BackToolButtonClick(Sender: TObject);
var
  ID: PItemIDList;
begin
  if FolderHistory.Count > 1
  then
    begin
      StopAddToHistory := True;
      ID := PItemIDList(FolderHistory.Items[FolderHistory.Count - 2]);
      FileListView.TreeUpdate(ID);
      FolderHistory.Delete(FolderHistory.Count - 2);
      StopAddToHistory := False;
    end;
end;

procedure TspOpenPictureDlgForm.FLVKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (FileListView.GetSelectedFile <> '')
  then
    OpenButtonClick(Sender);
end;

procedure TspOpenPictureDlgForm.EditKeyPress;
begin
  inherited;
  if Key = #27
  then
    Close
  else
  if Key = #13
  then
    begin
      if Pos('*', FileNameEdit.Text) <> 0
      then
        FileListView.Mask := FileNameEdit.Text
      else
        begin
          if Pos('\', FileNameEdit.Text) <> 0
          then
            begin
              if DirectoryExists(FileNameEdit.Text)
              then
                FileListView.Path := FileNameEdit.Text;
            end
          else
            begin
              OpenButtonClick(Sender);
            end;
        end;
    end;
end;

procedure TspOpenPictureDlgForm.OpenButtonClick;
var
  S: String;
begin
  if (FileListView.GetSelectedFile = '') and not SaveMode then Exit;
  if SaveMode
  then
    begin
      if FileNameEdit.Text = '' then Exit;
      S := FileListView.Path + '\' +  FileNameEdit.Text;
      if (Pos('*', S) = 0)
      then
        begin
          FileName := FileListView.Path + '\' + FileNameEdit.Text;
          ModalResult := mrOk;
        end;
    end
  else
    begin
      FileName := FileListView.GetSelectedFile;
      if FileExists(FileName) then ModalResult := mrOk else FileName := '';
    end;
end;

procedure TspOpenPictureDlgForm.FLVChange;
begin
  FileNameEdit.Text := ExtractFileName(FileListView.GetSelectedFile);
  if FileNameEdit.Text <> ''
  then
    begin
      try
        Image.Picture.LoadFromFile(FileListView.Path + '\' +  FileNameEdit.Text);
      finally
        if not Image.Stretch
        then
          begin
            Image.Width := Image.Picture.Width;
            Image.Height := Image.Picture.Height;
          end;
      end;
    end
  else
    begin
      Image.Width := 0;
      Image.Height := 0;
    end;
end;

procedure TspOpenPictureDlgForm.FLVDBLClick(Sender: TObject);
begin
  if FileListView.GetSelectedFile <> ''
  then
    begin
      FileName := FileListView.GetSelectedFile;
      ModalResult := mrOk;
    end;
end;

procedure TspOpenPictureDlgForm.FCBChange(Sender: TObject);
begin
  FileListView.Mask := FilterComboBox.Mask;
end;

constructor TspSkinOpenPictureDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStretchPicture := False;
  FFiles := TStringList.Create;
  FMultiSelection := False;
  DialogWidth := 0;
  DialogHeight := 0;
  FLVHeaderSkinDataName := 'resizebutton';
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 225;
  FCtrlAlphaBlend := False;
  FCtrlAlphaBlendAnimation := False;
  FCtrlAlphaBlendValue := 225;
  FSaveMode := False;
  FTitle := 'Open picture';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FInitialDir := '';
   FFilter := 'All (*.bmp;*.ico;*.emf;*.wmf)|*.bmp;*.ico;*.emf;*.wmf|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf';
  FFilterIndex := 1;
  FFileName := '';
  ImagePanelWidth := 190;
  ListViewStyle := vsList;
end;

destructor TspSkinOpenPictureDialog.Destroy;
begin
  FFiles.Free;
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSkinOpenPictureDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinOpenPictureDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinOpenPictureDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinOpenPictureDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinOpenPictureDialog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinOpenPictureDialog.Execute: Boolean;
var
  FW, FH, CIndex: Integer;
  Ext1, Ext2, Path: String;
begin
  FDlgFrm := TspOpenPictureDlgForm.CreateEx(Application, FSaveMode, CtrlSkindata);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    // alphablend
    DSF.AlphaBlend := AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := AlphaBlendValue;

    ShellBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    ShellBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    ShellBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    FilterComboBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    FilterComboBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    FilterComboBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    DSF.MenusAlphaBlend := FCtrlAlphaBlend;
    DSF.MenusAlphaBlendValue := FCtrlAlphaBlendValue;
    DSF.MenusAlphaBlendAnimation := FCtrlAlphaBlendAnimation;
     //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    ShellBox.DefaultFont := DefaultFont;
    FileListView.DefaultFont := DefaultFont;
    //
    case ListViewStyle of
      vsList: ListMenuItem.Checked := True;
      vsReport: ReportMenuItem.Checked := True;
      vsIcon: IconMenuItem.Checked := True;
      vsSmallIcon: SmallIconMenuItem.Checked := True;
    end;

    FileListView.ViewStyle := ListViewStyle;

    if (FFileName <> '') and (ExtractFilePath(FFileName) <> '')
    then
      begin
        Path := ExtractFilePath(FFileName);
        FileListView.Root := Path;
      end
    else
      begin
        if FInitialDir = ''
        then
          FileListView.Root := ExtractFilePath(Application.ExeName)
        else
          FileListView.Root  := FInitialDir;
      end;
      
    FileListView.Mask := FilterComboBox.Text;
    FileListView.HeaderSkinDataName := FLVHeaderSkinDataName;
    FileListView.MultiSelect := MultiSelection;
    FileListView.SkinData := FCtrlFSD;

    FilterComboBox.Filter := Self.Filter;
    FilterComboBox.ItemIndex := FFilterIndex - 1;
    //
    ImagePanel.Width := ImagePanelWidth;
    ImagePanel.SkinData := FCtrlFSD;
    ScrollBox.SkinData := FCtrlFSD;
    SBHScrollBar.SkinData := FCtrlFSD;
    SBVScrollBar.SkinData := FCtrlFSD;
    StretchButton.SkinData := FCtrlFSD;
    Splitter.SkinData := FCtrlFSD;
    //
    FilterComboBox.Filter := Self.Filter;
    FilterComboBox.ItemIndex := FFilterIndex - 1;
    //
    FileListViewPanel.SkinData := FCtrlFSD;
    BottomPanel.SkinData := FCtrlFSD;
    ToolPanel.SkinData := FCtrlFSD;
    //
    Drivelabel.SkinData := FCtrlFSD;
    UpToolButton.SkinData := FCtrlFSD;
    BackToolButton.SkinData := FCtrlFSD;
    StyleToolButton.SkinData := FCtrlFSD;
    NewFolderToolButton.SkinData := FCtrlFSD;
    //
    FLVHScrollBar.SkinData := FCtrlFSD;
    FLVVScrollBar.SkinData := FCtrlFSD;
    FileNameEdit.SkinData := FCtrlFSD;
    FilterComboBox.SkinData := FCtrlFSD;
    OpenButton.SkinData := FCtrlFSD;
    CancelButton.SkinData := FCtrlFSD;
    OpenFileLabel.SkinData := FCtrlFSD;
    FileTypeLabel.SkinData := FCtrlFSD;
    //
    ShellBox.SkinData := FCtrlFSD;
    if FCtrlFSD <> nil
    then
      CIndex := FCtrlFSD.GetControlIndex('toolcombobox')
    else
      CIndex := -1;
    if CIndex <> -1
    then
      ShellBox.SkinDataName := 'toolcombobox'
    else
      ShellBox.SkinDataName := 'combobox';
    //
    if (DialogWidth <> 0)
    then
      begin
        FW := DialogWidth;
        FH := DialogHeight;
      end
    else
      begin
        FW := 550;
        FH := 290;
      end;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;
    if FStretchPicture
    then
      StretchButton.Down := True
    else
    if DialogStretch then StretchButton.Down := DialogStretch;

    if StretchButton.Down
    then
      begin
        Image.Visible := False;
        ScrollBox.UpDateScrollRange;
        Image.Stretch := True;
        Image.Align := alClient;
        Image.Visible := True;
      end;


    with FileListView do
    begin
      if Items.Count <> 0 then ItemFocused := Items[0];
    end;


    if FileExists(FFileName)
    then
      begin
        try
          Image.Picture.LoadFromFile(FFileName);
        finally
          if not Image.Stretch
          then
            begin
              Image.Width := Image.Picture.Width;
              Image.Height := Image.Picture.Height;
              ScrollBox.UpDateScrollRange;
           end;
        end;
      end;

    FileNameEdit.Text := ExtractFileName(FFileName);

    Result := (ShowModal = mrOk);

    DialogStretch := StretchButton.Down;

    ImagePanelWidth := ImagePanel.Width;
    
    FFilterIndex := FilterComboBox.ItemIndex + 1;

    DialogWidth := ClientWidth;
    DialogHeight := ClientHeight;

    ListViewStyle := FileListView.ViewStyle;
    if Result
    then
      begin
        Self.FFileName := FDlgFrm.FileName;
        FileListView.GetSelectedFiles(Self.Files);
        // check ext
        if FSaveMode and (Pos('.*', FilterComboBox.Mask) = 0)
        then
          begin
            Ext1 := ExtractFileExt(FilterComboBox.Mask);
            Ext2 := ExtractFileExt(FFileName);
            if LowerCase(Ext1) <> LowerCase(Ext2)
            then
              FFileName := FFileName + Ext1;
          end;
        //
        Change;
      end;
  finally
    Free;
    FDlgFrm := nil;
  end;
end;

constructor TspSkinSavePictureDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := 'Save file';
  FSaveMode := True;
end;


// ======= TspSkinShellDriveComboBox ======= //

procedure TspSkinShellDriveComboBox.BuildList;
var
  Info      : TSHFileInfo;
  DriveChar : Char;
  CurrDrive : string;
  DriveType : TDriveType;
begin
  if Items.Count > 0 then begin
    if ItemIndex > -1 then FDriveItemIndex := ItemIndex;
    Items.Clear;
  end;
  FImages.Handle := SHGetFileInfo('', 0, Info, SizeOf(TShFileInfo), SHGFI);
  for DriveChar := 'A' to 'Z' do begin
    CurrDrive := DriveChar + ':\';
    DriveType := TDriveType(GetDriveType(PChar(CurrDrive)));
    if DriveType in FDriveTypes then begin
      SHGetFileInfo(PChar(CurrDrive), 0, Info, SizeOf(TShFileInfo), SHGFI_DISPLAYNAME or SHGFI);
      Items.AddObject(Info.szDisplayName, TObject(Info.iIcon));
      FDrives.Add(DriveChar);
    end;
  end;
  SetDrive(FDrives[FDriveItemIndex][1]);
  Update;
end;

procedure TspSkinShellDriveComboBox.Change;
begin
  if ItemIndex <> -1 then FDriveItemIndex := ItemIndex;
  SetDrive(FDrives[FDriveItemIndex][1]);
  if Assigned(FOnChange) then FOnChange(Self);
end;

constructor TspSkinShellDriveComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnListBoxDrawItem := DrawItem;
  OnComboBoxDrawItem := DrawItem;

  FDrives := TStringList.Create;
  FImages := TImageList.CreateSize(GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CXSMICON));
  with FImages do
  begin
    DrawingStyle := dsTransparent;
    ShareImages := True;
  end;

  FDriveTypes := [dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM];

  Style := spcbFixedStyle;
end;

procedure TspSkinShellDriveComboBox.CreateWnd;
begin
  inherited CreateWnd;
  BuildList;
end;

destructor TspSkinShellDriveComboBox.Destroy;
begin
  FDrives.Free;
  FImages.Free;
  inherited Destroy;
end;

procedure TspSkinShellDriveComboBox.DrawItem(Cnvs: TCanvas; Index, ItemWidth,
  ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
var
  ImageTop: Integer;
begin
  if FImages.Count > 0
  then
    begin
      ImageTop := TextRect.Top + ((TextRect.Bottom - TextRect.Top - FImages.Height) div 2);
      FImages.Draw(Cnvs, TextRect.Left, ImageTop, Integer(Items.Objects[Index]));
      TextRect.Left := TextRect.Left + FImages.Width + 4;
    end;
  Cnvs.TextOut(TextRect.Left,
  TextRect.Top + (TextRect.Bottom - TextRect.Top) div 2 - Cnvs.TextHeight('Wg') div 2,
  Items[Index]);
end;

procedure TspSkinShellDriveComboBox.SetDrive(Value: Char);
var
  i: Integer;
  j: Integer;
begin
  j := 0;
  if FDriveItemIndex <> -1 then j := FDriveItemIndex;
  Value := UpCase(Value);
  if FDrive <> Value
  then
    begin
      for i := 0 to Items.Count - 1 do
         if FDrives[i][1] = Value
         then
           begin
             FDrive := Value;
             FDriveItemIndex := i;
             ItemIndex := i;
             Exit;
           end;
    end
  else
    if ItemIndex <> j then ItemIndex := j;
end;

procedure TspSkinShellDriveComboBox.SetDriveTypes(const Value: TDriveTypes);
begin
  if FDriveTypes <> Value then begin
    FDriveTypes := Value;
    BuildList;
  end;  
end;

procedure TspSkinShellDriveComboBox.UpdateDrives;
var
  Info : TSHFileInfo;
begin
  if Assigned(FImages) then FImages.Free;
  FImages := TImagelist.CreateSize(GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON));
  with FImages do
  begin
    DrawingStyle := dsTransparent;
    ShareImages := True;
  end;
  FImages.Handle := SHGetFileInfo('', 0, Info, SizeOf(TShFileInfo), SHGFI);
  BuildList;
end;

// TspSkinShellComboBox

function TspItemsEx.Add: TspItemEx;
begin
  Result := TspItemEx(inherited Add);
end;

function TspItemsEx.Insert(Index: Integer): TspItemEx;
begin
  Result := TspItemEx(inherited Insert(Index));
end;

procedure TspItemsEx.AddItem(ACaption: String; AImageIndex, ASelectedIndex: Integer;
               AIdent: Integer; AFolder: TspShellFolder);

var
  IEx: TspItemEx;
begin
  IEx := Add;
  with IEx do
  begin
    Caption := ACaption;
    ImageIndex := AImageIndex;
    SelectedImageIndex := ASelectedIndex;
    Indent := AIdent;
    Data := AFolder;
  end;
end;


constructor TspItemsEx.Create;
begin
  inherited Create(TspItemEx);
end;

function TspItemsEx.GetItem(Index: Integer): TspItemEx;
begin
  Result := TspItemEx(inherited GetItem(Index));
end;

procedure TspItemsEx.SetItem(Index: Integer; Value: TspItemEx);
begin
  inherited SetItem(Index, Value);
end;


constructor TspCustomShellComboBox.Create(AOwner: TComponent);
var
  FileInfo: TSHFileInfo;
begin
  inherited Create(AOwner);
  FRootFolder := nil;
  FImages := SHGetFileInfo('C:\',
    0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  ImageList_GetIconSize(FImages, FImageWidth, FImageHeight);
  FUpdating := False;
  FObjectTypes := [otFolders];
  FRoot := SRFDesktop;
  FUseShellImages := True;
  FItemsEx := TspItemsEx.Create;
  OnListBoxDrawItem := DrawItem;
  OnComboBoxDrawItem := ComboDrawItem;
end;

procedure TspCustomShellComboBox.ComboDrawItem(Cnvs: TCanvas; Index, ItemWidth,
  ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
var
  ImageTop: Integer;
begin
  if FImages <> 0
  then
    begin
      ImageTop := TextRect.Top + ((TextRect.Bottom - TextRect.Top - FImageHeight) div 2);
      ImageList_DrawEx(FImages, ItemsEx[Index].ImageIndex, Cnvs.Handle,
      TextRect.Left,  ImageTop,
      FImageWidth, FImageHeight,
      CLR_NONE, CLR_NONE, ILD_NORMAL);
      TextRect.Left := TextRect.Left + FImageWidth + 4;
    end;
  Cnvs.TextOut(TextRect.Left,
  TextRect.Top + (TextRect.Bottom - TextRect.Top) div 2 - Cnvs.TextHeight('Wg') div 2,
  Items[Index]);
end;

procedure TspCustomShellComboBox.DrawItem(Cnvs: TCanvas; Index, ItemWidth,
  ItemHeight: Integer; TextRect: TRect; State: TOwnerDrawState);
var
  ImageTop: Integer;
  Offset: Integer;
begin
  Offset := ItemsEx[Index].Indent * FImageWidth div 2;
  if FImages <> 0
  then
    begin
      ImageTop := TextRect.Top + ((TextRect.Bottom - TextRect.Top - FImageHeight) div 2);
      ImageList_DrawEx(FImages, ItemsEx[Index].ImageIndex, Cnvs.Handle,
      TextRect.Left + Offset,  ImageTop,
      FImageWidth, FImageHeight,
      CLR_NONE, CLR_NONE, ILD_NORMAL);
      TextRect.Left := TextRect.Left + FImageWidth + 4 + Offset;
    end;
  Cnvs.TextOut(TextRect.Left,
  TextRect.Top + (TextRect.Bottom - TextRect.Top) div 2 - Cnvs.TextHeight('Wg') div 2,
  Items[Index]);
end;

procedure TspCustomShellComboBox.SetItemsEx(Value: TspItemsEx);
begin
  FItemsEx.Assign(Value);
end;

procedure TspCustomShellComboBox.CheckItems;
var
  I: Integer;
begin
  Items.BeginUpdate;
  try
    Items.Clear;
    for I := 0 to ItemsEx.Count - 1 do
      Items.Add(ItemsEx[I].Caption);
  finally
    Items.EndUpdate;
  end;
end;


procedure TspCustomShellComboBox.ClearItemsEx;
var
  I: Integer;
begin
  ItemsEx.BeginUpdate;
  try
    for I := 0 to ItemsEx.Count-1 do
    begin
      if Assigned(Folders[i]) then
        Folders[I].Free;
      ItemsEx[I].Data := nil;
    end;
    ItemsEx.Clear;
  finally
    ItemsEx.EndUpdate;
  end;
  CheckItems;
end;

procedure TspCustomShellComboBox.CreateRoot;
var
  AFolder: TspShellFolder;
  Text: string;
  ImageIndex: integer;
begin
  if (csLoading in ComponentState) then Exit;
  ItemsEx.BeginUpdate;
  try
    ClearItemsEx;
    FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
    AFolder := TspShellFolder.Create(nil,
                              FRootFolder.AbsoluteID,
                              FRootFolder.ShellFolder);
    Text := AFolder.DisplayName; //! PathName;

    ImageIndex := GetShellImageIndex(AFolder);
    ItemsEx.AddItem(Text, ImageIndex, ImageIndex, 0, AFolder);
    Init;
    CheckItems;
    ItemIndex := 0;
    if FUseShellImages then // Force image update
    begin
      SetUseShellImages(False);
      SetUseShellImages(True);
    end;
  finally
    ItemsEx.EndUpdate;
  end;
end;

procedure TspCustomShellComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if FImages <> 0 then
    SendMessage(Handle, CBEM_SETIMAGELIST, 0, FImages);
  SetUseShellImages(FUseShellImages);
  if ItemsEx.Count = 0 then
    CreateRoot;
  CheckItems;
end;

procedure TspCustomShellComboBox.DestroyWnd;
begin
  ClearItemsEx;
  inherited DestroyWnd;
end;

procedure TspCustomShellComboBox.SetObjectTypes(Value: TShellObjectTypes);
begin
  FObjectTypes := Value;
  RootChanged;
end;

procedure TspCustomShellComboBox.TreeUpdate(NewPath: PItemIDList);
begin
  if FUpdating or ((ItemIndex > -1)
    and SamePIDL(Folders[ItemIndex].AbsoluteID, NewPath)) then Exit;
  FUpdating := True;
  try
    SetPathFromID(NewPath);
  finally
    FUpdating := False;
  end;
end;

procedure TspCustomShellComboBox.SetTreeView(Value: TspCustomShellTreeView);
begin
  if Value = FTreeView then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FComboBox := Self;
  end else
    if FTreeView <> nil then
      FTreeView.FComboBox := nil;

  if FTreeView <> nil then
    FTreeView.FreeNotification(Self);

  FTreeView := Value;
end;

procedure TspCustomShellComboBox.SetListView(Value: TspCustomShellListView);
begin
  if Value = FListView then Exit;
  if Value <> nil then
  begin
    Value.Root := Root;
    Value.FComboBox := Self;
  end else
    if FListView <> nil then
      FListView.FComboBox := nil;

  if FListView <> nil then
    FListView.FreeNotification(Self);
  FListView := Value;
end;

procedure TspCustomShellComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FTreeView) then
      FTreeView := nil
    else if (AComponent = FListView) then
      FListView := nil
    else if (AComponent = FImageList) then
      FImageList := nil;
  end;    
end;

function TspCustomShellComboBox.GetFolder(Index: Integer): TspShellFolder;
begin
  if Index > ItemsEx.Count - 1 then
    Index := ItemsEx.Count - 1;
  Result := TspShellFolder(ItemsEx[Index].Data);
end;

function TspCustomShellComboBox.InitItem(ParentFolder: TspShellFolder; ID: PItemIDList): TspShellFolder;
var
  SF: IShellFolder;
begin
  SF := GetIShellFolder(ParentFolder.ShellFolder, ID);
  Result := TspShellFolder.Create(ParentFolder, ID, SF);
end;

function ComboSortFunc(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  if CompareFolder = nil then Exit;
  Result := SmallInt(CompareFolder.ShellFolder.CompareIDs(0,
    PItemIDList(Item1), PItemIDList(Item2)));
end;

procedure TspCustomShellComboBox.AddItemsEx(Index: Integer; ParentFolder: TspShellFolder);
var
  EnumList: IEnumIDList;
  ID: PItemIDList;
  Item: TspItemEx;
  NumIDs: integer;
  List: TList;
  ItemText: string;
  AFolder: TspShellFolder;
begin
  OLECheck(ParentFolder.ShellFolder.EnumObjects(0, ObjectFlags(FObjectTypes), EnumList));
  CompareFolder := ParentFolder;
  List := nil;
  ItemsEx.BeginUpdate;
  try
    List := TList.Create;
    while EnumList.Next(1, ID, LongWord(NumIDs)) = S_OK do
      List.Add(ID);
    List.Sort(ComboSortFunc);

    for NumIDs := 0 to List.Count-1 do
    begin
      AFolder := InitItem(ParentFolder, List[NumIDs]);
      ItemText := AFolder.DisplayName;
      Item := ItemsEx.Insert(Index + NumIDs + 1);
      Item.Caption := ItemText;
      Item.Data := AFolder;
      Item.Indent := AFolder.Level;
      Item.ImageIndex := GetShellImageIndex(AFolder);
      Item.SelectedImageIndex := Item.ImageIndex;
    end;

  finally
    CompareFolder := nil;
    List.Free;
    ItemsEx.EndUpdate;
  end;
end;

procedure TspCustomShellComboBox.Init;
var
  MyComputer: PItemIDList;
  Index: Integer;
begin
  //show desktop contents, expand My Computer if at desktop.
  //!!!otherwise expand the root.
  ItemsEx.BeginUpdate;
  try
    AddItemsEx(0, FRootFolder);
    if Root = SRFDesktop then
    begin
      SHGetSpecialFolderLocation(0, CSIDL_DRIVES, MyComputer);
      Index := IndexFromID(MyComputer);
      if Index <> -1 then
        AddItemsEx(Index, Folders[Index]);
    end;
  finally
    ItemsEx.EndUpdate;
  end;    
end;

function TspCustomShellComboBox.IndexFromID(AbsoluteID: PItemIDList): Integer;
begin
  Result := ItemsEx.Count-1;
  while Result >= 0 do
  begin
    if DesktopShellFolder.CompareIDs(
      0,
      AbsoluteID,
      Folders[Result].AbsoluteID) = 0 then Exit;
    Dec(Result);
  end;
end;

procedure TspCustomShellComboBox.SetRoot(const Value: TRoot);
begin
  if not SameText(FRoot, Value) then
  begin
    FOldRoot := FRoot;
    FRoot := Value;
    RootChanged;
  end;
end;

procedure TspCustomShellComboBox.RootChanged;
begin
  FUpdating := True;
  try
    ClearItemsEx;
    CreateRoot;
    if Assigned(FTreeView) then
      FTreeView.SetRoot(FRoot);
    if Assigned(FListView) then
      FListView.SetRoot(FRoot);
  finally
    FUpdating := False;
  end;
end;

function TspCustomShellComboBox.GetPath: string;
var
  Folder : TspShellFolder;
begin
  Result := '';
  if ItemIndex > -1 then
  begin
    Folder := Folders[ItemIndex];
    if Assigned(Folder) then
      Result := Folder.PathName
    else
      Result := '';  
  end;
end;

procedure TspCustomShellComboBox.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
begin
  NumChars := Length(Value);
  Flags := 0;
  P := StringToOleStr(Value);
  try
    OLECheck(DesktopShellFolder.ParseDisplayName(
        0,
        nil,
        P,
        NumChars,
        NewPIDL,
        Flags)
     );
    SetPathFromID(NewPIDL);
  except on EOleSysError do
    raise EInvalidPath.CreateFmt(SErrorSettingPath, [Value]);
  end;
end;

procedure TspCustomShellComboBox.SetPathFromID(ID: PItemIDList);
var
  Pidls: TList;
  I, Item, Temp: Integer;
  AFolder: TspShellFolder;
  RelID: PItemIDList;

  procedure InsertItemObject(Position: integer; Text: string; AFolder: TspShellFolder);

  var
    Item : TspItemEx;
  begin
    Item := ItemsEx.Insert(Position);
    Item.Caption := Text;
    Item.Indent := AFolder.Level;
    Item.Data := AFolder;
    if AFolder = nil then
      Item.Data := AFolder;
    Item.ImageIndex := GetShellImageIndex(AFolder);
  end;

begin
  Item := -1;
  ItemsEx.BeginUpdate;
  try
    CreateRoot;
    Pidls := CreatePIDLList(ID);
    try
      I := Pidls.Count-1;
      while I >= 0 do
      begin
        Item := IndexFromID(Pidls[I]);
        if Item <> -1 then Break;
        Dec(I);
      end;

      if I < 0 then Exit;

      while I < Pidls.Count-1 do
      begin
        Inc(I);
        RelID := RelativeFromAbsolute(Pidls[I]);
        AFolder := InitItem(Folders[Item], RelID);
        InsertItemObject(Item+1, AFolder.DisplayName, AFolder);
        Inc(Item);
      end;

      Temp := IndexFromID(ID);
      if Temp < 0 then
      begin
        RelID := RelativeFromAbsolute(ID);
        AFolder := InitItem(Folders[Item], RelID);
        Temp := Item + 1;
        InsertItemObject(Item+1, AFolder.DisplayName, AFolder);
      end;
      CheckItems;
      ItemIndex := Temp;
    finally
      DestroyPIDLList(Pidls);
    end;
  finally
    ItemsEx.EndUpdate;
  end;
end;

function TspCustomShellComboBox.GetShellImageIndex(
  AFolder: TspShellFolder): integer;
begin
  if FUseShellImages then
    Result := GetShellImage(AFolder.AbsoluteID, False, False)
  else
    Result := -1;
end;

procedure TspCustomShellComboBox.SetUseShellImages(const Value: Boolean);
var
  ImageListHandle: THandle;
begin
  FUseShellImages := Value;
  if not Assigned(Images) then
    if FUseShellImages then
      ImageListHandle := FImages
    else
      ImageListHandle := 0
  else
    ImageListHandle := Images.Handle;
  SendMessage(Handle, CBEM_SETIMAGELIST, 0, ImageListHandle);
  
  if FUseShellImages and not Assigned(FImageList) then
    ImageList_GetIconSize(FImages, FImageWidth, FImageHeight)
  else
    if not Assigned(FImageList) then
    begin
      FImageWidth := 16;
      FImageHeight := 16;
    end
    else
    begin
      FImageWidth := FImageList.Width;
      FImageHeight := FImageList.Height;
    end;
end;

destructor TspCustomShellComboBox.Destroy;
begin
  FItemsEx.Free;
  inherited Destroy;
  if Assigned(FImageList) then FImageList.Free;
end;

procedure TspCustomShellComboBox.Loaded;
begin
  inherited Loaded;
  CreateRoot;
end;

type
  TAccessItemUpdateCount = class(TspItemsEx);

procedure TspCustomShellComboBox.Change;
var
  Node : TspShellFolder;
begin
  if TAccessItemUpdateCount(ItemsEx).UpdateCount > 0 then Exit;

  inherited Change;
  if (ItemIndex > -1) and (not FUpdating) and (not Self.FListBox.Visible) then
  begin
    FUpdating := True;
    try
      Node := Folders[ItemIndex];
      if Assigned(Node) then
      begin
        if Assigned(FTreeView) then
          FTreeView.SetPathFromID(Node.AbsoluteID);
        if Assigned(FListView) then
          FListView.TreeUpdate(Node.AbsoluteID);
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TspCustomShellComboBox.Click;
var
  Temp: PItemIDList;
begin
  FUpdating := True;
  try
    Temp := CopyPIDL(Folders[ItemIndex].AbsoluteID);
    //Folder will be destroyed when removing the lower level ShellFolders.
    try
      SetPathFromID(Temp);
      inherited;
    finally
     DisposePIDL(Temp);
    end;
  finally
    FUpdating := False;
  end;
end;


// TspOpenSkinDialog

constructor TspOpenSkinDlgForm.CreateEx;
var
   ResStrData: TspResourceStrData;
begin
  inherited CreateNew(AOwner);
  FolderHistory := TList.Create;
  StopAddToHistory := False;

  KeyPreview := True;
  Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Self);

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  CtrlSD := ACtrlSkinData;

  ToolPanel := TspSkinToolBar.Create(Self);
  with ToolPanel do
  begin
    BorderStyle := bvNone;
    Parent := Self;
    Align := alTop;
    DefaultHeight := 25;
    SkinDataName := 'toolpanel';
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alLeft;
    Width := 10;
    Shape := bsSpacer;
  end;

  Drivelabel := TspSkinStdLabel.Create(Self);
  with Drivelabel do
  begin
    Left := 0;
    AutoSize := True;
    Parent := ToolPanel;
    Align := alLeft;
    Layout := tlCenter;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FLV_LOOKIN')
    else
      Caption := SP_FLV_LOOKIN;
  end;

  BackToolButton := TspSkinSpeedButton.Create(Self);
  with BackToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := BackToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_BACK');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_BACK_HINT')
    else
      Hint := SP_MSG_BTN_BACK_HINT;
    ShowHint := True;
  end;

  UpToolButton := TspSkinSpeedButton.Create(Self);
  with UpToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := UpToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_UP');
   if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_UP_HINT')
    else
      Hint := SP_MSG_BTN_UP_HINT;
    ShowHint := True;
  end;

  NewFolderToolButton := TspSkinSpeedButton.Create(Self);
  with NewFolderToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Align := alRight;
    DefaultHeight := 25;
    DefaultWidth := 27;
    SkinDataName := 'toolbutton';
    OnClick := NewFolderToolButtonClick;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_NEWFOLDER');
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_NEWFOLDER_HINT')
    else
      Hint := SP_MSG_BTN_NEWFOLDER_HINT;
    ShowHint := True;
  end;

  with TspSkinBevel.Create(Self) do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    Width := 10;
    Align := alRight;
    Shape := bsSpacer;
  end;

  // popupmenu
  StylePopupMenu := TspSkinPopupMenu.Create(Self);

  IconMenuItem := TMenuItem.Create(Self);
  with IconMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_ICON')
    else
      Caption := SP_MSG_LV_ICON;
    RadioItem := True;
    OnClick := IconItemClick;
  end;
  StylePopupMenu.Items.Add(IconMenuItem);

  SmallIconMenuItem := TMenuItem.Create(Self);
  with SmallIconMenuItem  do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_SMALLICON')
    else
      Caption := SP_MSG_LV_SMALLICON;
    RadioItem := True;
    OnClick := SmallIconItemClick;
  end;
  StylePopupMenu.Items.Add(SmallIconMenuItem );

  ListMenuItem := TMenuItem.Create(Self);
  with ListMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_LIST')
    else
       Caption := SP_MSG_LV_LIST;
    RadioItem := True;
    OnClick := ListItemClick;
  end;
  StylePopupMenu.Items.Add(ListMenuItem);

  ReportMenuItem := TMenuItem.Create(Self);
  with ReportMenuItem do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_LV_DETAILS')
    else
      Caption := SP_MSG_LV_DETAILS;
    RadioItem := True;
    OnClick := ReportItemClick;
  end;
  StylePopupMenu.Items.Add(ReportMenuItem);

  StyleToolButton := TspSkinMenuSpeedButton.Create(Self);
  with StyleToolButton do
  begin
    Left := Self.Width;
    Parent := ToolPanel;
    DefaultWidth := 37;
    SkinDataName := 'toolmenubutton';
    Align := alRight;
    NumGlyphs := 1;
    Glyph.LoadFromResourceName(HInstance, 'SP_LVSTYLE');
    SkinPopupMenu := StylePopupMenu;
    if ResStrData <> nil
    then
      Hint := ResStrData.GetResStr('MSG_BTN_VIEWMENU_HINT')
    else
      Hint := SP_MSG_BTN_VIEWMENU_HINT;
    ShowHint := True;
  end;

  ShellBox := TspSkinShellComboBox.Create(Self);
  with ShellBox do
  begin
    Left := 0;
    Parent := ToolPanel;
    Align := alClient;
    Width := 190;
    DropDownCount := 10;
   end;

  BottomPanel := TspSkinPanel.Create(Self);
  with BottomPanel do
  begin
    Parent := Self;
    Align := alBottom;
    BorderStyle := bvNone;
    Height := 80;
  end;

  // Preview

  PreviewPanel := TspSkinPanel.Create(Self);
  with PreviewPanel do
  begin
    Parent := Self;
    Align := alRight;
    Width := 230;
    BorderStyle := bvNone;
  end;

  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  begin
    Parent := PreviewPanel;
     if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_PREVIEWSKIN')
    else
      Caption := SP_MSG_PREVIEWSKIN;
    Enabled := False;
    Width :=  PreviewPanel.Width - 10;
    Height := 170;
    Left := 5;
    Top := 5;
    Visible := False;
  end;

  PreviewSkinData := TspSkinData.Create(Self);
  if ResStrData <> nil
  then
    PreviewSkinData.ResourceStrData := ResStrData;

  PreviewButton := TspSkinButton.Create(Self);
  with PreviewButton do
  begin
    Parent := PreviewForm;
    Width := 100;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_PREVIEWBUTTON')
    else
      Caption := SP_MSG_PREVIEWBUTTON;
    Left := 20;
    Top := 20;
    SkinData := PreviewSkinData;
  end;

  PreviewDSF := TspDynamicSkinForm.Create(PreviewForm);
  with PreviewDSF do
  begin
    SkinData := PreviewSkinData;
    PreviewMode := True;
  end;

  FileListViewPanel := TspSkinPanel.Create(Self);
  with FileListViewPanel do
  begin
    Parent := Self;
    Align := alClient;
    BorderStyle := bvFrame;
  end;

  FLVHScrollBar := TspSkinScrollBar.Create(Self);
  with FLVHScrollBar do
  begin
    BothMarkerWidth := 19;
    Parent := FileListViewPanel;
    Align := alBottom;
    DefaultHeight := 19;
    Enabled := False;
    SkinDataName := 'hscrollbar';
  end;

  FLVVScrollBar := TspSkinScrollBar.Create(Self);
  with FLVVScrollBar do
  begin
    Kind := sbVertical;
    Parent := FileListViewPanel;
    Align := alRight;
    DefaultWidth := 19;
    Enabled := False;
    SkinDataName := 'vscrollbar';
  end;

  FileListView := TspSkinFileListView.Create(Self);

  with FileListView do
  begin
    Parent := FileListViewPanel;
    ViewStyle := vsList;
    ShowColumnHeaders := True;
    IconOptions.AutoArrange := True;
    Align := alClient;
    HScrollBar := FLVHScrollBar;
    VScrollBar := FLVVScrollBar;
    OnChange := FLVChange;
    OnPathChanged := FLVPathChange;
    OnDblClick := FLVDBLClick;
    HideSelection := False;
    AutoContextMenus := False;
    ShellComboBox := ShellBox;
    OnKeyPress := FLVKeyPress;
  end;

  ShellBox.ShellListView := FileListView;

  FileNameEdit := TspSkinEdit.Create(Self);
  with FileNameEdit do
  begin
    Parent := BottomPanel;
    Top := 10;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnKeyPress := EditKeyPress;
  end;

  FilterComboBox := TspSkinFilterComboBox.Create(Self);
  with FilterComboBox  do
  begin
    Parent := BottomPanel;
    Top := 45;
    Left := 70;
    Width := 280;
    DefaultHeight := 21;
    OnChange := FCBChange;
  end;

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OPEN')
    else
      Caption := SP_MSG_BTN_OPEN;
    CanFocused := True;
    Left := 370;
    Top := 10;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    OnClick := OpenButtonClick;
  end;

  CancelButton := TspSkinButton.Create(Self);
  with CancelButton do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    CanFocused := True;
    Left := 370;
    Top := 45;
    Width := 70;
    DefaultHeight := 25;
    Parent := BottomPanel;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  OpenFileLabel := TspSkinStdLabel.Create(Self);
  with OpenFileLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILENAME')
    else
      Caption := SP_MSG_FILENAME;
    Left := 10;
    Top := 10;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  FileTypeLabel := TspSkinStdLabel.Create(Self);
  with FileTypeLabel do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_FILETYPE')
    else
      Caption := SP_MSG_FILETYPE;
    Left := 10;
    Top := 45;
    AutoSize := True;
    Parent := BottomPanel;
  end;

  ActiveControl := FileNameEdit;
end;

destructor TspOpenSkinDlgForm.Destroy;
begin
  FolderHistory.Clear;
  FolderHistory.Free;
  inherited;
end;

procedure TspOpenSkinDlgForm.ReportItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsReport;
  {$IFDEF VER130}
  FileListView.EnumColumns;
  {$ENDIF}
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := True;
  ListMenuItem.Checked := False;
end;

procedure TspOpenSkinDlgForm.ListItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsList;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := True;
end;

procedure TspOpenSkinDlgForm.SmallIconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsSmallIcon;
  IconMenuItem.Checked := False;
  SmallIconMenuItem.Checked := True;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenSkinDlgForm.IconItemClick(Sender: TObject);
begin
  FileListView.ViewStyle := vsIcon;
  IconMenuItem.Checked := True;
  SmallIconMenuItem.Checked := False;
  ReportMenuItem.Checked := False;
  ListMenuItem.Checked := False;
end;

procedure TspOpenSkinDlgForm.NewFolderToolButtonClick(Sender: TObject);
var
  S: String;
begin
  if (CtrlSD <> nil) and (CtrlSD.ResourceStrData <> nil)
  then
    S := FileListView.Path + '\' +
         CtrlSD.ResourceStrData.GetResStr('MSG_NEWFOLDER')
  else
    S := FileListView.Path + '\' + SP_MSG_NEWFOLDER;
  if not DirectoryExists(S)
  then
    begin
      MkDir(S);
      FileListView.RootChanged;
    end;
end;

procedure TspOpenSkinDlgForm.UpToolButtonClick(Sender: TObject);
begin
  FileListView.Back;
end;

procedure TspOpenSkinDlgForm.FLVPathChange(Sender: TObject);
var
  ID: PItemIDList;
begin
  if not StopAddToHistory
  then
    begin
      ID := CopyPIDL(FileListView.RootFolder.AbsoluteID);
      if (FolderHistory.Count = 0) or
         (ID <> PItemIDList(FolderHistory.Items[FolderHistory.Count - 1]))
      then
        FolderHistory.Add(PItemIDList(ID));
    end;
  with FileListView do
  begin
    if Items.Count <> 0 then ItemFocused := Items[0];
  end;
end;

procedure TspOpenSkinDlgForm.BackToolButtonClick(Sender: TObject);
var
  ID: PItemIDList;
begin
  if FolderHistory.Count > 1
  then
    begin
      StopAddToHistory := True;
      ID := PItemIDList(FolderHistory.Items[FolderHistory.Count - 2]);
      FileListView.TreeUpdate(ID);
      FolderHistory.Delete(FolderHistory.Count - 2);
      StopAddToHistory := False;
    end;
end;

procedure TspOpenSkinDlgForm.FLVKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (FileListView.GetSelectedFile <> '')
  then
    OpenButtonClick(Sender);
end;

procedure TspOpenSkinDlgForm.EditKeyPress;
begin
  inherited;
  if Key = #27
  then
    Close
  else
  if Key = #13
  then
    begin
      if Pos('*', FileNameEdit.Text) <> 0
      then
        FileListView.Mask := FileNameEdit.Text
      else
        begin
          if Pos('\', FileNameEdit.Text) <> 0
          then
            begin
              if DirectoryExists(FileNameEdit.Text)
              then
                FileListView.Path := FileNameEdit.Text;
            end
          else
            begin
              OpenButtonClick(Sender);
            end;
        end;
    end;
end;

procedure TspOpenSkinDlgForm.OpenButtonClick;
begin
  if (FileListView.GetSelectedFile = '') then Exit;
  FileName := FileListView.GetSelectedFile;
  if FileExists(FileName) then ModalResult := mrOk else FileName := '';
end;

procedure TspOpenSkinDlgForm.FLVChange;
begin
  FileNameEdit.Text := ExtractFileName(FileListView.GetSelectedFile);
  if (FileNameEdit.Text <> '')
  then
    begin
      if FilterComboBox.ItemIndex = FCompressedFilterIndex - 1
      then
        PreviewSkinData.LoadFromCompressedFile(FileListView.Path + '\' + FileNameEdit.Text)
      else
      if FilterComboBox.ItemIndex = FUnCompressedFilterIndex - 1
      then
        PreviewSkinData.LoadFromFile(FileListView.Path + '\' + FileNameEdit.Text);
      PreviewForm.Visible := not PreviewSkinData.Empty;
    end
  else
    PreviewForm.Visible := False;
end;

procedure TspOpenSkinDlgForm.FLVDBLClick(Sender: TObject);
begin
  if FileListView.GetSelectedFile <> ''
  then
    begin
      FileName := FileListView.GetSelectedFile;
      ModalResult := mrOk;
    end;
end;

procedure TspOpenSkinDlgForm.FCBChange(Sender: TObject);
begin
  FileListView.Mask := FilterComboBox.Mask;
end;

constructor TspOpenSkinDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFiles := TStringList.Create;
  DialogWidth := 0;
  DialogHeight := 0;
  FLVHeaderSkinDataName := 'resizebutton';
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FCtrlAlphaBlend := False;
  FCtrlAlphaBlendAnimation := False;
  FCtrlAlphaBlendValue := 225;
  FTitle := 'Open skin';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  FInitialDir := '';
  FCompressedFilterIndex := 1;
  FUnCompressedFilterIndex := 2;
  FFilter := 'Compressed skin (*.skn)|*.skn|UnCompressed skin (*.ini)|*.ini';
  FFilterIndex := 1;
  FFileName := '';
  ListViewStyle := vsList;
end;

destructor TspOpenSkinDialog.Destroy;
begin
  FFiles.Free;
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspOpenSkinDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspOpenSkinDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspOpenSkinDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspOpenSkinDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspOpenSkinDialog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspOpenSkinDialog.Execute: Boolean;
var
  FW, FH, CIndex: Integer;
  Path: String;
begin
  FDlgFrm := TspOpenSkinDlgForm.CreateEx(Application, CtrlSkinData);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;

    // alphablend
    DSF.AlphaBlend := AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := AlphaBlendValue;

    ShellBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    ShellBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    ShellBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    FilterComboBox.ListBoxAlphaBlend := FCtrlAlphaBlend;
    FilterComboBox.ListBoxAlphaBlendValue := FCtrlAlphaBlendValue;
    FilterComboBox.ListBoxAlphaBlendAnimation := FCtrlAlphaBlendAnimation;

    DSF.MenusAlphaBlend := FCtrlAlphaBlend;
    DSF.MenusAlphaBlendValue := FCtrlAlphaBlendValue;
    DSF.MenusAlphaBlendAnimation := FCtrlAlphaBlendAnimation;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    ShellBox.DefaultFont := DefaultFont;
    FileListView.DefaultFont := DefaultFont;
    //
    case ListViewStyle of
      vsList: ListMenuItem.Checked := True;
      vsReport: ReportMenuItem.Checked := True;
      vsIcon: IconMenuItem.Checked := True;
      vsSmallIcon: SmallIconMenuItem.Checked := True;
    end;

    FileListView.ViewStyle := ListViewStyle;

    if (FFileName <> '') and (ExtractFilePath(FFileName) <> '')
    then
      begin
        Path := ExtractFilePath(FFileName);
        FileListView.Root := Path;
      end
    else
      begin
        if FInitialDir = ''
        then
          FileListView.Root := ExtractFilePath(Application.ExeName)
        else
          FileListView.Root  := FInitialDir;
      end;
      
    FileListView.Mask := FilterComboBox.Text;
    FileListView.HeaderSkinDataName := FLVHeaderSkinDataName;
    FileListView.SkinData := FCtrlFSD;

    FilterComboBox.Filter := Self.Filter;
    FilterComboBox.ItemIndex := FFilterIndex - 1;
    //
    PreviewPanel.SkinData := FCtrlFSD;
    FileListViewPanel.SkinData := FCtrlFSD;
    BottomPanel.SkinData := FCtrlFSD;
    ToolPanel.SkinData := FCtrlFSD;
    //
    Drivelabel.SkinData := FCtrlFSD;
    UpToolButton.SkinData := FCtrlFSD;
    BackToolButton.SkinData := FCtrlFSD;
    StyleToolButton.SkinData := FCtrlFSD;
    NewFolderToolButton.SkinData := FCtrlFSD;
    //
    FLVHScrollBar.SkinData := FCtrlFSD;
    FLVVScrollBar.SkinData := FCtrlFSD;
    FileNameEdit.SkinData := FCtrlFSD;
    FilterComboBox.SkinData := FCtrlFSD;
    OpenButton.SkinData := FCtrlFSD;
    CancelButton.SkinData := FCtrlFSD;
    OpenFileLabel.SkinData := FCtrlFSD;
    FileTypeLabel.SkinData := FCtrlFSD;
    //
    ShellBox.SkinData := FCtrlFSD;
    if FCtrlFSD <> nil
    then
      CIndex := FCtrlFSD.GetControlIndex('toolcombobox')
    else
      CIndex := -1;
    if CIndex <> -1
    then
      ShellBox.SkinDataName := 'toolcombobox'
    else
      ShellBox.SkinDataName := 'combobox';
    //
    if (DialogWidth <> 0)
    then
      begin
        FW := DialogWidth;
        FH := DialogHeight;
      end
    else
      begin
        FW := 580;
        FH := 290;
      end;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    FCompressedFilterIndex := Self.CompressedFilterIndex;
    FUnCompressedFilterIndex := Self.UnCompressedFilterIndex;

    with FileListView do
    begin
      if Items.Count <> 0 then ItemFocused := Items[0];
    end;

    FileNameEdit.Text := ExtractFileName(FFileName);

    if FileExists(FFileName)
    then
      begin
        if FilterComboBox.ItemIndex = FCompressedFilterIndex - 1
        then
          PreviewSkinData.LoadFromCompressedFile(FFileName)
        else
         if FilterComboBox.ItemIndex = FUnCompressedFilterIndex - 1
         then
           PreviewSkinData.LoadFromFile(FFileName);
        PreviewForm.Visible := not PreviewSkinData.Empty;
      end;

    Result := (ShowModal = mrOk);

    FFilterIndex := FilterComboBox.ItemIndex + 1;

    DialogWidth := ClientWidth;
    DialogHeight := ClientHeight;

    ListViewStyle := FileListView.ViewStyle;
    if Result
    then
      begin
        Self.FFileName := FDlgFrm.FileName;
        FileListView.GetSelectedFiles(Self.Files);
        Change;
      end;
  finally
    Free;
    FDlgFrm := nil;
  end;
end;




initialization

  CreateDesktopFolder;
  InitializeCriticalSection(CS);
  OleInitialize(nil);
  
finalization

  if Assigned(DesktopFolder) then
    DesktopFolder.Free;
  DeleteCriticalSection(CS);
  OleUninitialize;

end.

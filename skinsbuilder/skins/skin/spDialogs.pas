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

unit spDialogs;

{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     DynamicSkinForm, SkinData, SkinCtrls, SkinBoxCtrls, Dialogs, StdCtrls, ExtCtrls,
     spSkinShellCtrls, spcolorctrls, ImgList, spPngImageList;

type
  TspPDShowType = (stStayOnTop, stModal);

  TspSkinProgressDialog = class(TComponent)
  protected
    FProgressAnimation: Boolean;
    FProgressAnimationPause: Integer;
    FShowType: TspPDShowType;
    FOnCancel: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FExecute: Boolean;
    Gauge: TspSkinGauge;
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FGaugeSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultGaugeFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    FMinValue, FMaxValue, FValue: Integer;
    FCaption: String;
    FLabelCaption: String;
    FShowPercent: Boolean;
    FShowCancelButton, FShowCloseButton: Boolean;

    procedure SetValue(AValue: Integer);
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultGaugeFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure CancelBtnClick(Sender: TObject);
    procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    procedure OnFormShow(Sender: TObject);
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ProgressAnimation: Boolean
      read FProgressAnimation write FProgressAnimation;
    property ProgressAnimationPause: Integer
     read FProgressAnimationPause write FProgressAnimationPause;
    property ShowCancelButton: Boolean
       read FShowCancelButton write FShowCancelButton;
    property ShowCloseButton: Boolean
      read FShowCloseButton write FShowCloseButton;
    property ShowType: TspPDShowType read FShowType write FShowType;
    property Caption: String read FCaption write FCaption;
    property LabelCaption: String read FLabelCaption write FLabelCaption;
    property ShowPercent: Boolean read FShowPercent write FShowPercent;
    property MinValue: Integer read FMinValue write FMinValue;
    property MaxValue: Integer read FMaxValue write FMaxValue;
    property Value: Integer read FValue write SetValue;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String
      read FLabelSkinDataName write FLabelSkinDataName;
    property GaugeSkinDataName: String
     read FGaugeSkinDataName write FGaugeSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultGaugeFont: TFont read FDefaultGaugeFont write SetDefaultGaugeFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
  end;

  TspSkinInputDialog = class(TComponent)
  protected
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FEditSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultEditFont: TFont;
    FDefaultButtonFont: TFont;
    FUseSkinFont: Boolean;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    function InputBox(const ACaption, APrompt, ADefault: string): string;
    function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String
      read FLabelSkinDataName write FLabelSkinDataName;
    property EditSkinDataName: String
     read FEditSkinDataName write FEditSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspFontDlgForm = class(TForm)
  public
    DSF: TspDynamicSkinForm;
    PngImgList: TspPngImageList;
    ScriptComboBox: TspSkinComboBox;
    FontNameBox: TspSkinFontComboBox;
    FontColorBox: TspSkinTextColorButton;
    FontSizeEdit: TspSkinFontSizeComboBox;
    FontHeightEdit: TspSkinSpinEdit;
    FontExamplePanel: TspSkinPanel;
    FontExampleLabel: TLabel;
    OkButton, CancelButton: TspSkinButton;
    ScriptLabel, FontNameLabel, FontColorLabel, FontSizeLabel,
    FontHeightLabel, FontStyleLabel, FontExLabel: TspSkinStdLabel;
    BoldButton, ItalicButton,
    UnderLineButton, StrikeOutButton: TspSkinSpeedButton;

    constructor CreateEx(AOwner: TComponent; ACtrlSkinData: TspSkinData; AShowScript: Boolean;
      AButtonsImageList: TCustomImageList);

    procedure FontSizeChange(Sender: TObject);
    procedure FontHeightChange(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure FontScriptChange(Sender: TObject);
    procedure FontColorChange(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure StrikeOutButtonClick(Sender: TObject);
    procedure UnderLineButtonClick(Sender: TObject); 
  end;

  TspSkinFontDialog = class(TComponent)
  private
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspFontDlgForm;
    FOnChange: TNotifyEvent;
    FFont: TFont;
    FShowSizeEdit, FShowHeightEdit: Boolean;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    FShowScript: Boolean;
    FButtonsImageList: TCustomImageList;
    procedure SetShowSizeEdit(Value: Boolean);
    procedure SetShowHeightEdit(Value: Boolean);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetFont(Value: TFont);
    procedure SetDefaultFont(Value: TFont);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure Change;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property ButtonsImageList: TCustomImageList
      read FButtonsImageList write FButtonsImageList;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Font: TFont read FFont write SetFont;
    property Title: string read GetTitle write SetTitle;
    property ShowSizeEdit: Boolean read FShowSizeEdit write SetShowSizeEdit;
    property ShowHeightEdit: Boolean read FShowHeightEdit write SetShowHeightEdit;
    property ShowScript: Boolean read FShowScript write FShowScript; 
    property OnChange: TnotifyEvent read FOnChange write FOnChange;
  end;

  TspSkinTextDialog = class(TComponent)
  protected
    FToolButtonsTransparent: Boolean;
    FToolBarImageList: TCustomImageList;
    Memo: TspSkinMemo2;
    FShowToolBar: Boolean;
    FCaption: String;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FMemoSkinDataName: String;
    FDefaultMemoFont: TFont;
    FDefaultButtonFont: TFont;
    FUseSkinFont: Boolean;
    FClientWidth: Integer;
    FClientHeight: Integer;
    FLines: TStrings;
    FSkinOpenDialog: TspSkinOpenDialog;
    FSkinSaveDialog: TspSkinSaveDialog;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    procedure SetLines(Value: TStrings);
    procedure SetClientWidth(Value: Integer);
    procedure SetClientHeight(Value: Integer);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultMemoFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    //
    procedure NewButtonClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure CutButtonClick(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    //
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property ToolBarImageList: TCustomImageList
      read FToolBarImageList write FToolBarImageList;
    property ToolButtonsTransparent: Boolean
     read FToolButtonsTransparent write FToolButtonsTransparent;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinOpenDialog: TspSkinOpenDialog
      read FSkinOpenDialog write FSkinOpenDialog;
    property SkinSaveDialog: TspSkinSaveDialog
      read FSkinSaveDialog write FSkinSaveDialog;
    property ShowToolBar: Boolean read FShowToolBar write FShowToolBar;
    property Lines: TStrings read FLines write SetLines;
    property ClientWidth: Integer read FClientWidth write SetClientWidth;
    property ClientHeight: Integer read FClientHeight write SetClientHeight;
    property Caption: String read FCaption write FCaption;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property MemoSkinDataName: String
     read FMemoSkinDataName write FMemoSkinDataName;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultMemoFont: TFont read FDefaultMemoFont write SetDefaultMemoFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinPasswordDialog = class(TComponent)
  protected
    FLoginMode: Boolean;
    FCaption: String;
    FLogin: String;
    FLoginCaption: String;
    FPasswordCaption: String;
    FPassword: String;
    FPasswordKind: TspPasswordKind;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FEditSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultEditFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    FUseSkinFont: Boolean;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property LoginMode: Boolean read FLoginMode write FLoginMode;
    property Login: String read FLogin write FLogin;
    property LoginCaption: String read FLoginCaption write FLoginCaption;
    property Password: String read FPassword write FPassword;
    property PasswordKind: TspPasswordKind read FPasswordKind write FPasswordKind;
    property Caption: String read FCaption write FCaption;
    property PasswordCaption: String read FPasswordCaption write FPasswordCaption;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String
      read FLabelSkinDataName write FLabelSkinDataName;
    property EditSkinDataName: String
     read FEditSkinDataName write FEditSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinConfirmDialog = class(TComponent)
  protected
    FCaption: String;
    FPassword1: String;
    FPassword1Caption: String;
    FPassword2: String;
    FPassword2Caption: String;
    FPasswordKind: TspPasswordKind;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FEditSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultEditFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    FUseSkinFont: Boolean;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  published
    property Password1: String read FPassword1 write FPassword1;
    property Password1Caption: String read FPassword1Caption write FPassword1Caption;
    property Password2: String read FPassword2 write FPassword2;
    property Password2Caption: String read FPassword2Caption write FPassword2Caption;
    property PasswordKind: TspPasswordKind read FPasswordKind write FPasswordKind;
    property Caption: String read FCaption write FCaption;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String
      read FLabelSkinDataName write FLabelSkinDataName;
    property EditSkinDataName: String
     read FEditSkinDataName write FEditSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSelectSkinDlgForm = class(TForm)
  public
    FCSkinList: TspCompressedSkinList;
    FCSkinIndex: Integer;
    DSF: TspDynamicSkinForm;
    OpenButton, CancelButton: TspSkinButton;
    PreviewForm: TForm;
    PreviewDSF: TspDynamicSkinForm;
    PreviewSkinData: TspSkinData;
    PreviewButton: TspSkinButton;
    SkinsListBox: TspSkinListBox;
    SkinList: TList;
    constructor CreateEx2(AOwner: TComponent;  ASkinList: TspCompressedSkinList;
                          ASkinIndex: Integer;
                          ACtrlSkinData: TspSkinData);

    constructor CreateEx(AOwner: TComponent;  AForm: TForm;  ADefaultSkin: TspCompressedStoredSkin;
                          ACtrlSkinData: TspSkinData);

    destructor Destroy; override;
    function GetSelectedSkin: TspCompressedStoredSkin;
    property SelectedSkin: TspCompressedStoredSkin read GetSelectedSkin;
    procedure SLBOnChange(Sender: TObject);
    procedure SLBOnDblClick(Sender: TObject);
  end;

  TspSelectSkinDialog = class(TComponent)
  private
    FSD: TspSkinData;
    FSkinList: TspCompressedSkinList;
    FCtrlFSD: TspSkinData;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspSelectSkinDlgForm;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FSelectedSkin: TspCompressedStoredSkin;
    FSelectedSkinIndex: Integer;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(DefaultCompressedSkin: TspCompressedStoredSkin): Boolean; overload;
    function Execute(SkinIndex: Integer): Boolean; overload;
    property SelectedSkin: TspCompressedStoredSkin read FSelectedSkin;
    property SelectedSkinIndex: Integer read FSelectedSkinIndex;
  published
    property SkinList: TspCompressedSkinList read FSkinList write FSkinList;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
  end;

  TspSkinSelectValueDialog = class(TComponent)
  private
    procedure SetSelectValues(const Value: TStrings);
  protected
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FSelectSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultSelectFont: TFont;
    FDefaultButtonFont: TFont;
    FDefaultValueIndex: Integer;
    FSelectValues: TStrings;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultSelectFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    function Execute(const ACaption, APrompt: string; var ValueIndex: Integer): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String read FLabelSkinDataName write FLabelSkinDataName;
    property ComboboxSkinDataName: String read FSelectSkinDataName write FSelectSkinDataName;
    property SelectValues: TStrings read FSelectValues Write SetSelectValues;
    property DefaultValue: Integer read FDefaultValueIndex Write FDefaultValueIndex;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultComboBoxFont: TFont read FDefaultSelectFont write SetDefaultSelectFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSelectSkinsFromFoldersDlgForm = class(TForm)
  public
    FCompressed: Boolean;
    FSkinsFolder: String;
    FIniFileName: String;
    DSF: TspDynamicSkinForm;
    OpenButton, CancelButton: TspSkinButton;
    PreviewForm: TForm;
    PreviewDSF: TspDynamicSkinForm;
    PreviewSkinData: TspSkinData;
    PreviewButton: TspSkinButton;
    SkinsListBox: TspSkinListBox;
    constructor CreateEx(AOwner: TComponent; ASkinsFolder, ADefaultSkinFolder, AIniFileName: String;
                         ACtrlSkinData: TspSkinData; ACompressed: Boolean);
    destructor Destroy; override;
    procedure SLBOnChange(Sender: TObject);
    procedure SLBOnDblClick(Sender: TObject);
  end;

  TspSelectSkinsFromFoldersDialog = class(TComponent)
  private
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FDefaultFont: TFont;
    FTitle: String;
    FDlgFrm: TspSelectSkinsFromFoldersDlgForm;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FFileName: String;
    FSkinName: String;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetDefaultFont(Value: TFont);
  protected
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute2(ASkinsFolder, ADefaultSkinFolder, AIniFileName: String): Boolean;
    function Execute(ASkinsFolder, ADefaultSkinFile, ASkinExt: String): Boolean;
    property FileName: String read FFileName;
    property SkinName: String read FSkinName;
  published
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property Title: string read GetTitle write SetTitle;
  end;

  TspFindOption = (spfrDown, spfrFindNext, spfrHideMatchCase, spfrHideWholeWord,
    spfrHideUpDown, spfrMatchCase, spfrDisableMatchCase, spfrDisableUpDown,
    spfrDisableWholeWord, spfrReplace, spfrReplaceAll, spfrWholeWord);
  TspFindOptions = set of TspFindOption;

  TspSkinFindDialog = class(TComponent)
  private
    FTitle: String;
    FOptions: TspFindOptions;
    FPosition: TPoint;
    FOnFind: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FFindText: String;
    FGroupBoxTransparentMode: Boolean;
    function GetFindText: string;
    function GetLeft: Integer;
    function GetPosition: TPoint;
    function GetTop: Integer;
    procedure SetFindText(const Value: string);
    procedure SetLeft(Value: Integer);
    procedure SetPosition(const Value: TPoint);
    procedure SetTop(Value: Integer);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure MatchCaseCheckBoxClick(Sender: TObject);
    procedure MatchWWOnlyCheckBoxClick(Sender: TObject);
    procedure DirecionUpClick(Sender: TObject);
    procedure DirecionDownClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditChange(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    //
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FEdit: TspSkinEdit;
    FDefaultLabelFont: TFont;
    FDefaultButtonFont: TFont;
    FDefaultEditFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    MatchWWOnlyCheckBox, MatchCaseCheckBox: TspSkinCheckRadioBox;
    FindButton: TspSkinButton;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    //
    procedure Find; dynamic;
    //
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Left: Integer read GetLeft write SetLeft;
    property Position: TPoint read GetPosition write SetPosition;
    property Top: Integer read GetTop write SetTop;
  published
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property FindText: string read GetFindText write SetFindText;
    property Options: TspFindOptions read FOptions write FOptions default [spfrDown];
    //
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    //
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

  TspSkinReplaceDialog = class(TComponent)
  private
    FTitle: String;
    FOptions: TspFindOptions;
    FPosition: TPoint;
    FOnFind: TNotifyEvent;
    FOnReplace: TNotifyEvent;
    FFindText: String;
    FReplaceText: String;
    FGroupBoxTransparentMode: Boolean;
    FOnClose: TNotifyEvent;
    function GetFindText: string;
    function GetReplaceText: string;
    function GetLeft: Integer;
    function GetPosition: TPoint;
    function GetTop: Integer;
    procedure SetFindText(const Value: string);
    procedure SetReplaceText(const Value: string);
    procedure SetLeft(Value: Integer);
    procedure SetPosition(const Value: TPoint);
    procedure SetTop(Value: Integer);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure MatchCaseCheckBoxClick(Sender: TObject);
    procedure MatchWWOnlyCheckBoxClick(Sender: TObject);
    procedure DirecionUpClick(Sender: TObject);
    procedure DirecionDownClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure ReplaceButtonClick(Sender: TObject);
    procedure ReplaceAllButtonClick(Sender: TObject);
    procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditChange(Sender: TObject);
    procedure ReplaceEditChange(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ReplaceEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    //
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FEdit: TspSkinEdit;
    FReplaceEdit: TspSkinEdit;
    FDefaultLabelFont: TFont;
    FDefaultButtonFont: TFont;
    FDefaultEditFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    MatchWWOnlyCheckBox, MatchCaseCheckBox: TspSkinCheckRadioBox;
    CloseButton, FindButton, ReplaceButton, ReplaceAllButton: TspSkinButton;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultEditFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    //
    procedure Find; dynamic;
    procedure Replace; dynamic;
    //
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Left: Integer read GetLeft write SetLeft;
    property Position: TPoint read GetPosition write SetPosition;
    property Top: Integer read GetTop write SetTop;
  published
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property FindText: string read GetFindText write SetFindText;
    property ReplaceText: string read GetReplaceText write SetReplaceText;
    property Options: TspFindOptions read FOptions write FOptions default [spfrDown];
    //
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultEditFont: TFont read FDefaultEditFont write SetDefaultEditFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    //
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
    property OnReplace: TNotifyEvent read FOnReplace write FOnReplace;   
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;


implementation
  Uses spConst, spUtils;
{$R *.res}

// script

const
  ScriptNames: array[0..18] of String =
   ('ANSI_CHARSET', 'DEFAULT_CHARSET', 'SYMBOL_CHARSET', 'SHIFTJIS_CHARSET',
    'HANGEUL_CHARSET', 'GB2312_CHARSET', 'CHINESEBIG5_CHARSET',
    'OEM_CHARSET', 'JOHAB_CHARSET', 'HEBREW_CHARSET', 'ARABIC_CHARSET',
    'GREEK_CHARSET', 'TURKISH_CHARSET', 'VIETNAMESE_CHARSET',
    'THAI_CHARSET', 'EASTEUROPE_CHARSET', 'RUSSIAN_CHARSET',
    'MAC_CHARSET', 'BALTIC_CHARSET');

  ScriptCodes: array[0..18] of TFontCharSet =
   (0, 1, 2, $80, 129, 134, 136, 255, 130, 177, 178, 161, 162, 163,
    222, 238, 204, 77, 186);

  BtnOff = 3;  


function GetIndexFromCharSet(CharSet: TFontCharSet): Integer;
var
  I: Integer;
begin
  Result := 1;
  for I := 0 to 18 do
    if CharSet =  ScriptCodes[I]
    then
      begin
        Result := I;
        Break;
      end;
end;

function GetCharSetFormIndex(Index: Integer): TFontCharSet;
begin
  if Index <> -1
  then
    Result := ScriptCodes[Index]
  else
    Result := 1;  
end;

//


constructor TspSkinInputDialog.Create;
begin
  inherited Create(AOwner);
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName := 'stdlabel';
  FEditSkinDataName := 'edit';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultEditFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinInputDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited;
end;

procedure TspSkinInputDialog.SetDefaultLabelFont;
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinInputDialog.SetDefaultEditFont;
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinInputDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinInputDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;


function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function TspSkinInputDialog.InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
const
  WS_EX_LAYERED = $80000;
  
var
  DSF: TspDynamicSkinForm;
  Prompt: TspSkinStdLabel;
  Edit: TspSkinEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := ACaption;
  Form.Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.SizeAble := False;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  //

  try

  with Form do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
  end;

  Prompt := TspSkinStdLabel.Create(Form);
  with Prompt do
  begin
    Parent := Form;
    Caption := APrompt;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FLabelSkinDataName;
    SkinData := CtrlSkinData;
    Left := MulDiv(8, DialogUnits.X, 4);
    Top := MulDiv(8, DialogUnits.Y, 8);
    Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
    WordWrap := True;
  end;

  Edit := TspSkinEdit.Create(Form);
  with Edit do
  begin
    Parent := Form;
    DefaultFont := DefaultEditFont;
    UseSkinFont := Self.UseSkinFont;
    Left := Prompt.Left;
    Top := Prompt.Top + Prompt.Height + 5;
    DefaultWidth := MulDiv(164, DialogUnits.X, 4);
    MaxLength := 255;
    Text := Value;
    SelectAll;
    SkinDataName := FEditSkinDataName;
    SkinData := CtrlSkinData;
  end;

  ButtonTop := Edit.Top + Edit.Height + 15;
  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(MulDiv(38, DialogUnits.X, 4) - BtnOff, ButtonTop, ButtonWidth,
              ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(MulDiv(92, DialogUnits.X, 4) + BtnOff, Edit.Top + Edit.Height + 15,
              ButtonWidth, ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 13;
  end;

  if Form.ShowModal = mrOk
  then
    begin
      Value := Edit.Text;
      Result := True;
    end
  else
    Result := False;

  finally
    Form.Free;
  end;
end;

function TspSkinInputDialog.InputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  InputQuery(ACaption, APrompt, Result);
end;

constructor TspSkinProgressDialog.Create;
begin
  inherited Create(AOwner);

  FProgressAnimationPause := 2000;
  FProgressAnimation := True;
  
  FShowType := stStayOnTop;
  FShowCancelButton := True;
  FShowCloseButton := True;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  Form := nil;
  Gauge := nil;
  FExecute := False;

  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;

  FCaption := 'Process';
  FLabelCaption := 'Name of process:';
  FShowPercent := True;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName := 'stdlabel';
  FGaugeSkinDataName := 'gauge';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultGaugeFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultGaugeFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinProgressDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultGaugeFont.Free;
  inherited;
end;

procedure TspSkinProgressDialog.SetValue(AValue: Integer);
begin
  FValue := AValue;
  if FExecute
  then
    begin
      Gauge.Value := FValue;
      if Gauge.Value = Gauge.MaxValue
      then
        if FShowType = stModal
        then
          Form.ModalResult := mrOk
        else
          Form.Close;  
    end;  
end;

procedure TspSkinProgressDialog.SetDefaultLabelFont;
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinProgressDialog.SetDefaultGaugeFont;
begin
  FDefaultGaugeFont.Assign(Value);
end;

procedure TspSkinProgressDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinProgressDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinProgressDialog.OnFormShow(Sender: TObject);
begin
  if Assigned(FOnShow) then FOnShow(Self);
end;

procedure TspSkinProgressDialog.CancelBtnClick(Sender: TObject);
begin
  Form.Close;
  if Assigned(FOnCancel) then FOnCancel(Self);
end;

procedure TspSkinProgressDialog.OnFormClose;
begin
  FExecute := False;
  Gauge := nil;
  Form := nil;
  if Value <> MaxValue
  then
    if Assigned(FOnCancel) then FOnCancel(Self);
  Action := caFree;
end;

function TspSkinProgressDialog.Execute;
var
  DSF: TspDynamicSkinForm;
  Prompt: TspSkinStdLabel;
  DialogUnits: TPoint;
  ButtonWidth, ButtonHeight: Integer;
begin
  if FExecute
  then
    begin
      Result := False;
      Exit;
    end;
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  if FShowType = stStayOnTop
  then
     begin
       Form.FormStyle := fsStayOnTop;
       Form.OnClose := OnFormClose;
     end;
  Form.Caption := FCaption;
  Form.Position := poScreenCenter;
  Form.OnShow := OnFormShow;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  if not FShowCloseButton then DSF.HideCaptionButtons := True;
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  try

  with Form do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
  end;

  Prompt := TspSkinStdLabel.Create(Form);
  with Prompt do
  begin
    Parent := Form;
    Left := MulDiv(8, DialogUnits.X, 4);
    Top := MulDiv(8, DialogUnits.Y, 8);
    Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FLabelSkinDataName;
    SkinData := CtrlSkinData;
    Caption := FLabelCaption;
  end;

  Gauge := TspSkinGauge.Create(Form);
  with Gauge do
  begin
    Parent := Form;
    MinValue := FMinValue;
    MaxValue := FMaxValue;
    ShowPercent := FShowPercent;
    Value := FValue;
    DefaultFont := DefaultGaugeFont;
    UseSkinFont := Self.UseSkinFont;
    Left := Prompt.Left;
    Top := Prompt.Top + Prompt.Height + 5;
    DefaultWidth := MulDiv(164, DialogUnits.X, 4);
    SkinDataName := FGaugeSkinDataName;
    SkinData := CtrlSkinData;
  end;

  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

  if FShowCancelButton
  then
    begin
    with TspSkinButton.Create(Form) do
    begin
      Parent := Form;
      DefaultFont := DefaultButtonFont;
      UseSkinFont := Self.UseSkinFont;
      if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
      then
        Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
      else
        Caption := SP_MSG_BTN_CANCEL;
       if FShowType = stStayOnTop then OnClick := CancelBtnClick;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(Gauge.Left + Gauge.Width - ButtonWidth, Gauge.Top + Gauge.Height + 15,
              ButtonWidth, ButtonHeight);
      DefaultHeight := ButtonHeight;
      SkinDataName := FButtonSkinDataName;
      SkinData := CtrlSkinData;
      Form.ClientHeight := Top + Height + 13;
    end;
  end
   else
      Form.ClientHeight := Gauge.Top + Gauge.Height + 15;


  FExecute := True;

  Gauge.ProgressAnimationPause := Self.ProgressAnimationPause;
  if Self.ProgressAnimation
  then
    Gauge.StartProgressAnimation;

  if FShowType = stModal
  then
    begin
      if Form.ShowModal = mrOk then Result := True else Result := False;
      FExecute := False;
    end
  else
    begin
      Result := True;
      Form.Show;
    end;

  finally
    if FShowType = stModal
    then
      begin
        Form.Free;
        Gauge := nil;
        Form := nil;
      end;  
  end;
end;

constructor TspFontDlgForm.CreateEx;
var
  I: Integer;
  ResStrData: TspResourceStrData;
  OffsetY: Integer;
begin
  inherited CreateNew(AOwner);

  if AShowScript then OffsetY := 45 else OffsetY := 0;

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;
  KeyPreview := True;
  BorderStyle := bsDialog;
  Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Self);
  DSF.SizeAble := False;

  PngImgList := TspPngImageList.Create(AOwner);
  with TspPngImageItem(PngImgList.PngImages.Add) do
    PngImage.LoadFromResourceName(HInstance, 'SP_BOLD_PNG');
  with TspPngImageItem(PngImgList.PngImages.Add) do
    PngImage.LoadFromResourceName(HInstance, 'SP_ITALIC_PNG');
  with TspPngImageItem(PngImgList.PngImages.Add) do
    PngImage.LoadFromResourceName(HInstance, 'SP_UNDERLINE_PNG');
  with TspPngImageItem(PngImgList.PngImages.Add) do
    PngImage.LoadFromResourceName(HInstance, 'SP_STRIKEOUT_PNG');
  
  FontColorLabel := TspSkinStdLabel.Create(Self);
  with FontColorLabel do
  begin
    Left := 10;
    Top := 50 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_COLOR')
    else
      Caption := SP_FONTDLG_COLOR;
    AutoSize := True;
    Parent := Self;
  end;

  FontColorBox := TspSkinTextColorButton.Create(Self);
  with FontColorBox do
  begin
    Left := 10;
    Top := 65;
    Width := 70;
    DefaultHeight := 21;
    Parent := Self;
    ShowAutoColor := False;
    InitColors;
    SkinDataName := 'resizetoolbutton';
    OnChangeColor := FontColorChange;
  end;

  FontNameLabel := TspSkinStdLabel.Create(Self);
  with FontNameLabel do
  begin
    Left := 10;
    Top := 5 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_NAME')
    else
      Caption := SP_FONTDLG_NAME;
    AutoSize := True;
    Parent := Self;
  end;

  FontSizeLabel := TspSkinStdLabel.Create(Self);
  with FontSizeLabel do
  begin
    Left := 100;
    Top := 50 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_SIZE')
    else
      Caption := SP_FONTDLG_SIZE;
    AutoSize := True;
    Parent := Self;
  end;

  FontSizeEdit := TspSkinFontSizeComboBox.Create(Self);
  with  FontSizeEdit do
  begin
    Left := 100;
    Top := 65;
    Parent := Self;
    Width := 60;
    Style := spcbEditStyle;
    OnChange := FontSizeChange;
  end;

  FontHeightLabel := TspSkinStdLabel.Create(Self);
  with FontHeightLabel do
  begin
    Left := 100;
    Top := 50 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_HEIGHT')
    else
      Caption := SP_FONTDLG_Height;
    AutoSize := True;
    Parent := Self;
  end;

  FontHeightEdit := TspSkinSpinEdit.Create(Self);
  with FontHeightEdit do
  begin
    MinValue := -500;
    MaxValue := 500;
    Left := 100;
    Top := 65;
    Width := 60;
    Parent := Self;
    OnChange := FontHeightChange;
  end;

  ScriptLabel := TspSkinStdLabel.Create(Self);
  with ScriptLabel do
  begin
    Left := 10;
    Top := 150 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_SCRIPT')
    else
      Caption := SP_FONTDLG_SCRIPT;
    AutoSize := True;
    Parent := Self;
  end;

  ScriptComboBox := TspSkinComboBox.Create(Self);
  with ScriptComboBox do
  begin
    Left := 10;
    Top := 165;
    Width := 240;
    DefaultHeight := 21;
    Parent := Self;
    TabOrder := 4;
    TabStop := True;
    for I := 0 to 18 do
      Items.Add(ScriptNames[I]);
    OnChange := FontScriptChange;
  end;

  FontExLabel := TspSkinStdLabel.Create(Self);
  with FontExLabel do
  begin
    Left := 10;
    Top := 150 + OffsetY - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_EXAMPLE')
    else
      Caption := SP_FONTDLG_EXAMPLE;
    AutoSize := True;
    Parent := Self;
  end;

  FontExamplePanel := TspSkinPanel.Create(Self);
  with FontExamplePanel do
  begin
    Parent := Self;
    BorderStyle := bvFrame;
    Left := 10;
    Top := 165 + OffsetY;
    Width := 240;
    Height := 60;
  end;

  FontExampleLabel := TLabel.Create(Self);
  with FontExampleLabel do
  begin
    Parent := FontExamplePanel;
    Transparent := True;
    Align := alClient;
    Caption := 'AaBbYyZz';
  end;

  OkButton := TspSkinButton.Create(Self);
  with OkButton do
  begin
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    CanFocused := True;
    Left := 90;
    Top := 235 + OffsetY;
    Width := 75;
    DefaultHeight := 25;
    Parent := Self;
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
    Left := 175;
    Top := 235 + OffsetY;
    Width := 75;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  FontStyleLabel := TspSkinStdLabel.Create(Self);
  with FontStyleLabel do
  begin
    Left := 10;
    Top := 100 - 2;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('FONTDLG_STYLE')
    else
      Caption := SP_FONTDLG_STYLE;
    AutoSize := True;
    Parent := Self;
  end;

  BoldButton := TspSkinSpeedButton.Create(Self);
  with BoldButton do
  begin
    Parent := Self;
    AllowAllUp := True;
    DefaultWidth := 25;
    DefaultHeight := 25;
    SkinDataName := 'toolbutton';
    GroupIndex := 1;
    NumGlyphs := 1;
    Left := 10;
    Top := 115;
    ImageIndex := 0;
    if AButtonsImageList <> nil
    then
      ImageList := AButtonsImageList
    else
      ImageList := PngImgList;
    OnClick := BoldButtonClick;
  end;

  ItalicButton := TspSkinSpeedButton.Create(Self);
  with ItalicButton do
  begin
    Parent := Self;
    AllowAllUp := True;
    DefaultWidth := 25;
    DefaultHeight := 25;
    SkinDataName := 'toolbutton';
    GroupIndex := 1;
    NumGlyphs := 1;
    Left := 40;
    Top := 115;
    ImageIndex := 1;
    if AButtonsImageList <> nil
    then
      ImageList := AButtonsImageList
    else
      ImageList := PngImgList;
    OnClick := ItalicButtonClick;
  end;

  UnderLineButton := TspSkinSpeedButton.Create(Self);
  with UnderLineButton do
  begin
    Parent := Self;
    AllowAllUp := True;
    DefaultWidth := 25;
    DefaultHeight := 25;
    SkinDataName := 'toolbutton';
    GroupIndex := 1;
    NumGlyphs := 1;
    Left := 70;
    Top := 115;
    ImageIndex := 2;
    if AButtonsImageList <> nil
    then
      ImageList := AButtonsImageList
    else
      ImageList := PngImgList;
    OnClick := UnderLineButtonClick;
  end;

  StrikeOutButton := TspSkinSpeedButton.Create(Self);
  with StrikeOutButton do
  begin
    Parent := Self;
    AllowAllUp := True;
    DefaultWidth := 25;
    DefaultHeight := 25;
    SkinDataName := 'toolbutton';
    GroupIndex := 1;
    NumGlyphs := 1;
    Left := 100;
    Top := 115;
    ImageIndex := 3;
    if AButtonsImageList <> nil
    then
      ImageList := AButtonsImageList
    else
      ImageList := PngImgList;
    OnClick := StrikeOutButtonClick;
  end;

end;

procedure TspFontDlgForm.FontSizeChange(Sender: TObject);
begin
  if FontSizeEdit.SizeValue <> 0
  then
    FontExampleLabel.Font.Size := Trunc(FontSizeEdit.SizeValue);
  FontHeightEdit.SimpleSetValue(FontExampleLabel.Font.Height);
end;

procedure TspFontDlgForm.FontHeightChange(Sender: TObject);
begin
  FontExampleLabel.Font.Height := Trunc(FontHeightEdit.Value);
  FontSizeEdit.Text := IntToStr(FontExampleLabel.Font.Size);
end;

procedure TspFontDlgForm.FontNameChange(Sender: TObject);
begin
  FontExampleLabel.Font.Name := FontNameBox.FontName;
  FontSizeEdit.FontName := FontNameBox.FontName;
  FontSizeEdit.Text := IntToStr(FontExampleLabel.Font.Size);
end;

procedure TspFontDlgForm.FontScriptChange(Sender: TObject);
begin
  FontExampleLabel.Font.Charset := GetCharSetFormIndex(ScriptComboBox.ItemIndex);
end;


procedure TspFontDlgForm.FontColorChange(Sender: TObject);
begin
  FontExampleLabel.Font.Color := FontColorBox.ColorValue;
end;

procedure TspFontDlgForm.BoldButtonClick(Sender: TObject);
begin
  if BoldButton.Down
  then
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style + [fsBold]
  else
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style - [fsBold];
end;

procedure TspFontDlgForm.ItalicButtonClick(Sender: TObject);
begin
  if ItalicButton.Down
  then
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style + [fsItalic]
  else
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style - [fsItalic];
end;

procedure TspFontDlgForm.StrikeOutButtonClick(Sender: TObject);
begin
  if StrikeOutButton.Down
  then
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style + [fsStrikeOut]
  else
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style - [fsStrikeOut];
end;

procedure TspFontDlgForm.UnderLineButtonClick(Sender: TObject);
begin
  if UnderLineButton.Down
  then
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style + [fsUnderLine]
  else
    FontExampleLabel.Font.Style := FontExampleLabel.Font.Style - [fsUnderLine];
end;

constructor TspSkinFontDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonsImageList := nil;
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FTitle := 'Font';
  FDefaultFont := TFont.Create;
  FFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
  FShowSizeEdit := True;
  FShowHeightEdit := False;
  FShowScript := False;
end;

destructor TspSkinFontDialog.Destroy;
begin
  FDefaultFont.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TspSkinFontDialog.SetShowSizeEdit(Value: Boolean);
begin
  FShowSizeEdit := Value;
  if FShowSizeEdit then FShowHeightEdit := False;
end;

procedure TspSkinFontDialog.SetShowHeightEdit(Value: Boolean);
begin
  FShowheightEdit := Value;
  if FShowHeightEdit then FShowSizeEdit := False;
end;

procedure TspSkinFontDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinFontDialog.SetFont;
begin
  FFont.Assign(Value);
end;

procedure TspSkinFontDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
  if (Operation = opRemove) and (AComponent = FButtonsImageList) then FButtonsImageList := nil;
end;

function TspSkinFontDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinFontDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinFontDialog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TspSkinFontDialog.Execute: Boolean;
var
  FW, FH: Integer;
begin
  FDlgFrm := TspFontDlgForm.CreateEx(Application, CtrlSkinData,  FShowScript, FButtonsImageList);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := Self.AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := Self.AlphaBlendValue;
    //
    FontNameBox := TspSkinFontComboBox.Create(Self);
    with FontNameBox do
    begin
      Left := 10;
      Top := 20;
      Width := 240;
      DefaultHeight := 21;
      Parent := FDlgFrm;
      PopulateList;
      TabOrder := 0;
      TabStop := True;
      OnChange := FontNameChange;
    end;
    FontNameBox.SkinData := FCtrlFSD;
    //
    ScriptComboBox.SkinData := FCtrlFSD;
    FontColorBox.SkinData := FCtrlFSD;
    FontColorBox.SkinImagesMenu.SkinData := FCtrlFSD;
    FontSizeEdit.SkinData := FCtrlFSD;
    FontHeightEdit.SkinData := FCtrlFSD;
    FontExamplePanel.SkinData := FCtrlFSD;
    OkButton.SkinData := FCtrlFSD;
    CancelButton.SkinData := FCtrlFSD;
    BoldButton.SkinData := FCtrlFSD;
    ItalicButton.SkinData := FCtrlFSD;
    UnderLineButton.SkinData := FCtrlFSD;
    StrikeOutButton.SkinData := FCtrlFSD;
    //
    FontHeightLabel.SkinData := FCtrlFSD;
    FontSizeLabel.SkinData := FCtrlFSD;
    FontStyleLabel.SkinData := FCtrlFSD;
    FontNameLabel.SkinData := FCtrlFSD;
    FontColorLabel.SkinData := FCtrlFSD;
    FontExLabel.SkinData := FCtrlFSD;
    ScriptLabel.SkinData := FCtrlFSD;
    ScriptLabel.Visible := FShowScript;
    //
    ScriptComboBox.ItemIndex := GetIndexFromCharSet(Self.Font.CharSet);
    ScriptComboBox.Visible :=  FShowScript;
    //
    FontExampleLabel.Font.Assign(Self.Font);
    FontNameBox.FontName := FontExampleLabel.Font.Name;
    FontColorBox.ColorValue := FontExampleLabel.Font.Color;
    FontSizeEdit.Text := IntToStr(FontExampleLabel.Font.Size);
    FontHeightEdit.SimpleSetValue(FontExampleLabel.Font.Height);
    FontSizeEdit.Visible := FShowSizeEdit;
    FontHeightEdit.Visible := FShowHeightEdit;
    FontHeightLabel.Visible := FShowHeightEdit;
    FontSizeLabel.Visible := FShowSizeEdit;

    if fsBold in FontExampleLabel.Font.Style
    then
      BoldButton.Down := True;
    if fsItalic in FontExampleLabel.Font.Style
    then
      ItalicButton.Down := True;
    if fsStrikeOut in FontExampleLabel.Font.Style
    then
      StrikeOutButton.Down := True;
    if fsUnderLine in FontExampleLabel.Font.Style
    then
      UnderLineButton.Down := True;
    //
    FW := 260;
    FH := 270;
    if FShowScript then FH := FH + 40;
    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;
    ClientWidth := FW;
    ClientHeight := FH;
    //
    Result := (ShowModal = mrOk);
    if Result
    then
      begin
        Self.Font.Assign(FontExampleLabel.Font);
        Change;
      end;
  finally
    Free;
    FDlgFrm := nil;
  end;
end;


constructor TspSkinTextDialog.Create;
begin
  inherited Create(AOwner);
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FToolButtonsTransparent := False;
  FToolBarImageList := nil;

  Memo := nil;

  FSkinOpenDialog := nil;
  FSkinSaveDialog := nil;

  FClientWidth := 350;
  FClientHeight := 200;

  FLines := TStringList.Create;

  FCaption := 'Input text';

  FButtonSkinDataName := 'button';
  FMemoSkinDataName := 'memo';

  FDefaultButtonFont := TFont.Create;
  FDefaultMemoFont := TFont.Create;

  FUseSkinFont := True;

  ShowToolBar := True;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultMemoFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinTextDialog.Destroy;
begin
  FDefaultMemoFont.Free;
  FDefaultButtonFont.Free;
  FLines.Free;
  inherited;
end;

procedure TspSkinTextDialog.NewButtonClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TspSkinTextDialog.OpenButtonClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  if FSkinOpenDialog <> nil
  then
    begin
      if FSkinOpenDialog.Execute
      then Memo.Lines.LoadFromFile(FSkinOpenDialog.FileName);
    end
  else
    begin
      OD := TOpenDialog.Create(Self);
      OD.Filter := '*.txt|*.txt|*.*|*.*';
      if OD.Execute then Memo.Lines.LoadFromFile(OD.FileName);
      OD.Free;
    end;
end;

procedure TspSkinTextDialog.SaveButtonClick(Sender: TObject);
var
  SD: TSaveDialog;
begin
  if FSkinSaveDialog <> nil
  then
    begin
      if FSkinSaveDialog.Execute
      then Memo.Lines.LoadFromFile(FSkinSaveDialog.FileName);
    end
  else
    begin
      SD := TSaveDialog.Create(Self);
      SD.Filter := '*.txt|*.txt|*.*|*.*';
      if SD.Execute then Memo.Lines.SaveToFile(SD.FileName);
      SD.Free;
    end;  
end;
procedure TspSkinTextDialog.CopyButtonClick(Sender: TObject);
begin
  Memo.CopyToClipboard;
end;

procedure TspSkinTextDialog.CutButtonClick(Sender: TObject);
begin
  Memo.CutToClipboard;
end;

procedure TspSkinTextDialog.PasteButtonClick(Sender: TObject);
begin
  Memo.PasteFromClipboard;
end;

procedure TspSkinTextDialog.DeleteButtonClick(Sender: TObject);
begin
  Memo.ClearSelection;
end;

procedure TspSkinTextDialog.SetLines(Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TspSkinTextDialog.SetClientWidth(Value: Integer);
begin
  if Value > 0 then FClientWidth := Value;
end;

procedure TspSkinTextDialog.SetClientHeight(Value: Integer);
begin
  if Value > 0 then FClientHeight := Value;
end;

procedure TspSkinTextDialog.SetDefaultMemoFont;
begin
  FDefaultMemoFont.Assign(Value);
end;

procedure TspSkinTextDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinTextDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
  if (Operation = opRemove) and (AComponent = FSkinOpenDialog) then FSkinOpenDialog := nil;
  if (Operation = opRemove) and (AComponent = FSkinSaveDialog) then FSkinSaveDialog := nil;
  if (Operation = opRemove) and (AComponent = FToolBarImageList) then FToolBarImageList := nil;
end;

function TspSkinTextDialog.Execute: Boolean;
var
  Form: TForm;
  DSF: TspDynamicSkinForm;
  ButtonWidth, ButtonHeight: Integer;
  Panel: TspSkinPanel;
  HMemoScrollBar, VMemoScrollBar: TspSkinScrollBar;
  ToolPanel: TspSkinPanel;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := FCaption;
  Form.Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.SizeAble := False;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  try

  with Form do
  begin
    ClientWidth := FClientWidth;
    ClientHeight := FClientHeight;
    ButtonWidth := 80;
    ButtonHeight := 25;

    with TspSkinButton.Create(Form) do
    begin
      Parent := Form;
      DefaultFont := DefaultButtonFont;
      UseSkinFont := Self.UseSkinFont;
      if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
      then
        Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
      else
        Caption := SP_MSG_BTN_OK;
      DefaultHeight := ButtonHeight;
      ModalResult := mrOk;
      Default := True;
      SkinDataName := FButtonSkinDataName;
      SkinData := CtrlSkinData;
      SetBounds(FClientWidth - ButtonWidth * 2 - 20, FClientHeight - Height - 10,
                ButtonWidth, Height);
    end;

    with TspSkinButton.Create(Form) do
    begin
      Parent := Form;
      DefaultFont := DefaultButtonFont;
      UseSkinFont := Self.UseSkinFont;
      if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
      then
        Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
      else
        Caption := SP_MSG_BTN_CANCEL;
      DefaultHeight := ButtonHeight;
      ModalResult := mrCancel;
      Cancel := True;
      SkinDataName := FButtonSkinDataName;
      SkinData := CtrlSkinData;
      SetBounds(FClientWidth - ButtonWidth - 10, FClientHeight - Height - 10,
                ButtonWidth, Height);
      ButtonHeight := Height;          
    end;

    Panel := TspSkinPanel.Create(Form);
    with Panel do
    begin
      Parent := Form;
      Align := alTop;
      SkinData := CtrlSkinData;
    end;

    if FShowToolBar
    then
      begin
        ToolPanel := TspSkinPanel.Create(Form);
        with ToolPanel do
        begin
          Parent := Form;
          Align := alTop;
          DefaultHeight := 25;
          SkinDataName := 'toolpanel';
          SkinData := CtrlSkinData;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := NewButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 0;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_NEW');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := OpenButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 1;
              ImageList := FToolBarImageList;
            end
           else
             Glyph.LoadFromResourceName(HInstance, 'SP_OPEN');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := SaveButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 2;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_SAVE');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinBevel.Create(Form) do
        begin
          Parent := ToolPanel;
          Width := 24;
          Align := alLeft;
          DividerMode := True;
          Shape := bsLeftLine;
          SkinData := CtrlSkinData;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := CopyButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 3;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_COPY');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := CutButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 4;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_CUT');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := PasteButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 5;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_PASTE');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

        with TspSkinSpeedButton.Create(Form) do
        begin
          Parent := ToolPanel;
          DefaultWidth := 27;
          SkinDataName := 'toolbutton';
          Align := alLeft;
          OnClick := DeleteButtonClick;
          NumGlyphs := 1;
          if FToolBarImageList <> nil
          then
            begin
              ImageIndex := 6;
              ImageList := FToolBarImageList;
            end
           else
            Glyph.LoadFromResourceName(HInstance, 'SP_DELETE');
          SkinData := CtrlSkinData;
          Flat := FToolButtonsTransparent;
        end;

      end;

    with Panel do
    begin
      if FShowToolBar
      then
        Height := FClientHeight -  ButtonHeight - 20 - ToolPanel.Height
      else
        Height := FClientHeight -  ButtonHeight - 20;
    end;

    VMemoScrollBar := TspSkinScrollBar.Create(Form);
    with VMemoScrollBar do
    begin
      Kind := sbVertical;
      Parent := Panel;
      Align := alRight;
      DefaultWidth := 19;
      Enabled := False;
      SkinDataName := 'vscrollbar';
      SkinData := CtrlSkinData;
    end;

    HMemoScrollBar := TspSkinScrollBar.Create(Form);
    with HMemoScrollBar do
    begin
      Parent := Panel;
      Align := alBottom;
      DefaultHeight := 19;
      Enabled := False;
      BothMarkerWidth := 19;
      Both := True;
      SkinDataName := 'bothhscrollbar';
      SkinData := CtrlSkinData;
    end;

    Memo := TspSkinMemo2.Create(Form);
    with Memo do
    begin
      Parent := Panel;
      Lines.Assign(Self.Lines);
      Align := alClient;
      HScrollBar := HMemoScrollBar;
      VScrollBar := VMemoScrollBar;
      SkinData := CtrlSkinData;
    end;

  end;  
  
  if Form.ShowModal = mrOk
  then
    begin
      Self.Lines.Assign(Memo.Lines);
      Result := True;
    end
  else
    Result := False;

  finally
    Form.Free;
  end;
end;

constructor TspSkinPasswordDialog.Create;
begin
  inherited Create(AOwner);

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  LoginMode := False;

  FCaption := 'Password';

  FPasswordCaption := 'Password:';
  FPassword := '';

  FLoginCaption := 'Login name:';
  FLogin := '';

  FButtonSkinDataName := 'button';
  FLabelSkinDataName := 'stdlabel';
  FEditSkinDataName := 'edit';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultEditFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinPasswordDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited;
end;

procedure TspSkinPasswordDialog.SetDefaultLabelFont;
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinPasswordDialog.SetDefaultEditFont;
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinPasswordDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinPasswordDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinPasswordDialog.Execute: Boolean;
var
  Form: TForm;
  DSF: TspDynamicSkinForm;
  Image: TImage;
  LoginLabel, PasswordLabel: TspSkinStdLabel;
  LoginEdit: TspSkinEdit;
  PasswordEdit: TspSkinPasswordEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  LeftOffset: Integer;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := FCaption;
  Form.Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  try

  with Form do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);

    Image := TImage.Create(Form);

    with Image do
    begin
      Parent := Form;
      Top := MulDiv(8, DialogUnits.Y, 8);
      Left := MulDiv(8, DialogUnits.X, 4);
      AutoSize := True;
      Transparent := True;
      Picture.Bitmap.Handle := LoadBitMap(HInstance, 'SP_KEY');
    end;

    LeftOffset := Image.Width + Image.Left;

    ClientWidth := LeftOffset + MulDiv(180, DialogUnits.X, 4);
  end;


  if FLoginMode
  then
    begin
      LoginLabel := TspSkinStdLabel.Create(Form);
      with LoginLabel do
      begin
        Parent := Form;
        Left := LeftOffset + MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        DefaultFont := DefaultLabelFont;
        UseSkinFont := Self.UseSkinFont;
        SkinDataName := FLabelSkinDataName;
        SkinData := CtrlSkinData;
        Caption := FLoginCaption;
      end;

      LoginEdit := TspSkinMaskEdit.Create(Form);
      with LoginEdit do
      begin
         Parent := Form;
         DefaultFont := DefaultEditFont;
         UseSkinFont := Self.UseSkinFont;
         Left := LoginLabel.Left;
         Top := LoginLabel.Top + LoginLabel.Height + 5;
         DefaultWidth := MulDiv(164, DialogUnits.X, 4);
         MaxLength := 255;
         Text := FLogin;
         SelectAll;
         SkinDataName := FEditSkinDataName;
         SkinData := CtrlSkinData;
       end;
    end;

  PasswordLabel := TspSkinStdLabel.Create(Form);
  with PasswordLabel do
  begin
    Parent := Form;
    Left := LeftOffset + MulDiv(8, DialogUnits.X, 4);
    if FLoginMode and (LoginEdit <> nil)
    then
      Top := LoginEdit.Top + LoginEdit.Height + 5
    else
      Top := MulDiv(8, DialogUnits.Y, 8);
    Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FLabelSkinDataName;
    SkinData := CtrlSkinData;
    Caption := FPasswordCaption;
  end;

  PasswordEdit := TspSkinPasswordEdit.Create(Form);
  with PasswordEdit do
  begin
    Parent := Form;
    PasswordKind := Self.PasswordKind;
    DefaultFont := DefaultEditFont;
    UseSkinFont := Self.UseSkinFont;
    Left := PasswordLabel.Left;
    Top := PasswordLabel.Top + PasswordLabel.Height + 5;
    DefaultWidth := MulDiv(164, DialogUnits.X, 4);
    MaxLength := 255;
    Text := FPassword;
    SelectAll;
    SkinDataName := FEditSkinDataName;
    SkinData := CtrlSkinData;
  end;

  ButtonTop := PasswordEdit.Top + PasswordEdit.Height + 15;
  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(LeftOffset + MulDiv(38, DialogUnits.X, 4) - BtnOff, ButtonTop, ButtonWidth,
              ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(LeftOffset + MulDiv(92, DialogUnits.X, 4) + BtnOff, PasswordEdit.Top + PasswordEdit.Height + 15,
              ButtonWidth, ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 13;
    Image.Top := Form.ClientHeight div 2 - Image.Height div 2; 
  end;

  if Form.ShowModal = mrOk
  then
    begin
      if FLoginMode then FLogin := LoginEdit.Text;
      FPassword := PasswordEdit.Text;
      Result := True;
    end
  else
    Result := False;

  finally
    Form.Free;
  end;
end;

// ===================== TspSkinConfirmDialog ==================== //

constructor TspSkinConfirmDialog.Create;
begin
  inherited Create(AOwner);

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FCaption := 'Confirm password';

  FPassword1Caption := 'Enter password:';
  FPassword1 := '';

  FPassword2Caption := 'Confirm password: ';
  FPassword2:= '';

  FButtonSkinDataName := 'button';
  FLabelSkinDataName := 'stdlabel';
  FEditSkinDataName := 'edit';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultEditFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinConfirmDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited;
end;

procedure TspSkinConfirmDialog.SetDefaultLabelFont;
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinConfirmDialog.SetDefaultEditFont;
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinConfirmDialog.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinConfirmDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSkinConfirmDialog.Execute: Boolean;
var
  Form: TForm;
  DSF: TspDynamicSkinForm;
  Image: TImage;
  Password1Label, Password2Label: TspSkinStdLabel;
  Password1Edit, Password2Edit: TspSkinPasswordEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  LeftOffset: Integer;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := FCaption;
  Form.Position := poScreenCenter;

  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  try

  with Form do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);

    Image := TImage.Create(Form);

    with Image do
    begin
      Parent := Form;
      Top := MulDiv(8, DialogUnits.Y, 8);
      Left := MulDiv(8, DialogUnits.X, 4);
      AutoSize := True;
      Transparent := True;
      Picture.Bitmap.Handle := LoadBitMap(HInstance, 'SP_KEY');
    end;

    LeftOffset := Image.Width + Image.Left;

    ClientWidth := LeftOffset + MulDiv(180, DialogUnits.X, 4);
  end;


  Password1Label := TspSkinStdLabel.Create(Form);
  with Password1Label do
  begin
     Parent := Form;
     Left := LeftOffset + MulDiv(8, DialogUnits.X, 4);
     Top := MulDiv(8, DialogUnits.Y, 8);
     Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
     DefaultFont := DefaultLabelFont;
     UseSkinFont := Self.UseSkinFont;
     SkinDataName := FLabelSkinDataName;
     SkinData := CtrlSkinData;
     Caption := FPassword1Caption;
   end;

   Password1Edit := TspSkinPasswordEdit.Create(Form);
   with Password1Edit do
   begin
     Parent := Form;
     PasswordKind := Self.PasswordKind;
     DefaultFont := DefaultEditFont;
     UseSkinFont := Self.UseSkinFont;
     Left := Password1Label.Left;
     Top := Password1Label.Top + Password1Label.Height + 5;
     DefaultWidth := MulDiv(164, DialogUnits.X, 4);
     MaxLength := 255;
     Text := FPassword1;
     SelectAll;
     SkinDataName := FEditSkinDataName;
     SkinData := CtrlSkinData;
    end;

  Password2Label := TspSkinStdLabel.Create(Form);
  with Password2Label do
  begin
    Parent := Form;
    Left := LeftOffset + MulDiv(8, DialogUnits.X, 4);
    Top := Password1Edit.Top + Password1Edit.Height + 5;
    Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FLabelSkinDataName;
    SkinData := CtrlSkinData;
    Caption := FPassword2Caption;
  end;

  Password2Edit := TspSkinPasswordEdit.Create(Form);
  with Password2Edit do
  begin
    Parent := Form;
    PasswordKind := Self.PasswordKind;
    DefaultFont := DefaultEditFont;
    UseSkinFont := Self.UseSkinFont;
    Left := Password2Label.Left;
    Top := Password2Label.Top + Password2Label.Height + 5;
    DefaultWidth := MulDiv(164, DialogUnits.X, 4);
    MaxLength := 255;
    Text := FPassword2;
    SelectAll;
    SkinDataName := FEditSkinDataName;
    SkinData := CtrlSkinData;
  end;

  ButtonTop := Password2Edit.Top + Password2Edit.Height + 15;
  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(LeftOffset + MulDiv(38, DialogUnits.X, 4) - BtnOff, ButtonTop, ButtonWidth,
              ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(LeftOffset + MulDiv(92, DialogUnits.X, 4) + BtnOff, Password2Edit.Top + Password2Edit.Height + 15,
              ButtonWidth, ButtonHeight);
    DefaultHeight := ButtonHeight;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 13;
    Image.Top := Form.ClientHeight div 2 - Image.Height div 2; 
  end;

  if Form.ShowModal = mrOk
  then
    begin
      FPassword1 := Password1Edit.Text;
      FPassword2 := Password2Edit.Text;
      Result := True;
    end
  else
    Result := False;

  finally
    Form.Free;
  end;
end;

// TspSelectSkinDialog

constructor TspSelectSkinDlgForm.CreateEx;
var
  I, Idx: Integer;
  S: String;
  ResStrData: TspResourceStrData;
begin
  inherited CreateNew(AOwner);

  FCSkinList := nil;
  FCSkinIndex := -1;

  Position := poScreenCenter;

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  BorderStyle := bsSingle;
  SkinList := TList.Create;

  DSF := TspDynamicSkinForm.Create(Self);
  DSF.Sizeable := False;

  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  begin
    Parent := Self;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_PREVIEWSKIN')
    else
      Caption := SP_MSG_PREVIEWSKIN;
    Enabled := False;
    Width :=  220;
    Height := 170;
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

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
    Default := True;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    CanFocused := True;
    Left := 260;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrOK;
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
    Left := 340;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  SkinsListBox := TspSkinListBox.Create(Self);
  with SkinsListBox do
  begin
    Parent := Self;
    SetBounds(10, 10, 170, 170);
    OnListboxClick := SLBOnChange;
    OnListboxDblClick := SLBOnDblClick;
  end;

  // load skins
  Idx := 0;
  for I := 0 to AForm.ComponentCount - 1 do
  if AForm.Components[I] is TspCompressedStoredSkin
  then
    begin
      SkinList.Add(TspCompressedStoredSkin(AForm.Components[I]));
      with TspCompressedStoredSkin(AForm.Components[I]) do
      begin
        if Description <> '' then S := Description else S := Name;
        SkinsListBox.Items.Add(S);
      end;
      if TspCompressedStoredSkin(AForm.Components[I]) = ADefaultSkin
      then
        Idx := SkinsListBox.Items.Count - 1;
    end;
  SkinsListBox.ItemIndex := Idx;
  PreviewSkinData.CompressedStoredSkin := SkinList[SkinsListBox.ItemIndex];
  //
  with PreviewForm do
  begin
    Left := 190;
    Top := 10;
    Visible := True;
   end;
  //
  ActiveControl := SkinsListBox.ListBox;
end;

constructor TspSelectSkinDlgForm.CreateEx2;
var
  I, Idx: Integer;
  S: String;
  ResStrData: TspResourceStrData;
begin
  inherited CreateNew(AOwner);

  FCSkinList := ASkinList;
  FCSkinIndex := ASkinIndex;

  Position := poScreenCenter;

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  BorderStyle := bsSingle;

  DSF := TspDynamicSkinForm.Create(Self);
  DSF.Sizeable := False;

  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  begin
    Parent := Self;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_PREVIEWSKIN')
    else
      Caption := SP_MSG_PREVIEWSKIN;
    Enabled := False;
    Width :=  220;
    Height := 170;
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

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
    Default := True;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    CanFocused := True;
    Left := 260;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrOK;
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
    Left := 340;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  SkinsListBox := TspSkinListBox.Create(Self);
  with SkinsListBox do
  begin
    Parent := Self;
    SetBounds(10, 10, 170, 170);
    OnListboxClick := SLBOnChange;
    OnListboxDblClick := SLBOnDblClick;
  end;

  // load skins
  for I := 0 to FCSkinList.Skins.Count - 1 do
  begin
    if FCSkinList.Skins[i].Description <> ''
    then
      SkinsListBox.Items.Add(FCSkinList.Skins[i].Description)
    else
      SkinsListBox.Items.Add(FCSkinList.Skins[i].Name);
  end;

  SkinsListBox.ItemIndex := FCSkinIndex;

  PreviewSkinData.SkinIndex := FCSkinIndex;
  PreviewSkinData.SkinList := FCSkinList;
  
  //
  with PreviewForm do
  begin
    Left := 190;
    Top := 10;
    Visible := True;
   end;
  //
  ActiveControl := SkinsListBox.ListBox;
end;

destructor TspSelectSkinDlgForm.Destroy;
begin
  if FCSkinList = nil
  then
    begin
      SkinList.Clear;
      SkinList.Free;
    end;  
  inherited;
end;

procedure TspSelectSkinDlgForm.SLBOnDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TspSelectSkinDlgForm.SLBOnChange(Sender: TObject);
begin
  if FCSkinList = nil
  then
    PreviewSkinData.CompressedStoredSkin := SkinList[SkinsListBox.ItemIndex]
  else
    PreviewSkinData.SkinIndex := SkinsListBox.ItemIndex;
end;

function TspSelectSkinDlgForm.GetSelectedSkin;
begin
  Result := PreviewSkinData.CompressedStoredSkin;
end;

constructor TspSelectSkinDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinList := nil;
  FSelectedSkinIndex := -1;
  FSelectedSkin := nil;
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FTitle := 'Select skin';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSelectSkinDialog.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSelectSkinDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSelectSkinDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
  if (Operation = opRemove) and (AComponent = FSkinList) then FSkinList := nil;
end;

function TspSelectSkinDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSelectSkinDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

function TspSelectSkinDialog.Execute(SkinIndex: Integer): Boolean;
var
  FW, FH, CIndex: Integer;
  Path: String;
begin
  if FSkinList = nil then Exit;
  FDlgFrm := TspSelectSkinDlgForm.CreateEx2(Application, FSkinList, SkinIndex, CtrlSkinData);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := Self.AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := Self.AlphaBlendValue;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    SkinsListBox.DefaultFont := DefaultFont;
    //
    OpenButton.SkinData := CtrlSkinData;
    CancelButton.SkinData := CtrlSkinData;
    SkinsListBox.SkinData := CtrlSkinData;

    FW := 420;
    FH := 240;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    FSelectedSkin := nil;
    FSelectedSkinIndex := -1;

    if FDlgFrm.ShowModal = mrOk
    then
      begin
        Result := True;
        FSelectedSkinIndex := FDlgFrm.PreviewSkinData.SkinIndex;
      end
    else
      Result := False;

  finally
    Free;
    FDlgFrm := nil;
  end;
end;

function TspSelectSkinDialog.Execute(DefaultCompressedSkin: TspCompressedStoredSkin): Boolean;
var
  FW, FH, CIndex: Integer;
  Path: String;
begin
  FDlgFrm := TspSelectSkinDlgForm.CreateEx(Application, TForm(Owner), DefaultCompressedSkin, CtrlSkinData);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.SkinData := FSD;
    DSF.SizeAble := False;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := Self.AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := Self.AlphaBlendValue;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    SkinsListBox.DefaultFont := DefaultFont;
    //
    OpenButton.SkinData := CtrlSkinData;
    CancelButton.SkinData := CtrlSkinData;
    SkinsListBox.SkinData := CtrlSkinData;

    FW := 420;
    FH := 240;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    FSelectedSkin := nil;

    if FDlgFrm.ShowModal = mrOk
    then
      begin
        Result := True;
        FSelectedSkin := FDlgFrm.SelectedSkin;
      end
    else
      Result := False;

  finally
    Free;
    FDlgFrm := nil;
  end;
end;

// SelectValue dialog

constructor TspSkinSelectValueDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName  := 'stdlabel';
  FSelectSkinDataName := 'combobox';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultSelectFont := TFont.Create;

  FSelectValues := TStringList.Create;
  FDefaultValueIndex := -1;
  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultSelectFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinSelectValueDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultSelectFont.Free;
  FSelectValues.Free;
  inherited;
end;

function TspSkinSelectValueDialog.Execute(const ACaption, APrompt: string; var ValueIndex: Integer): Boolean;
var
  DSF: TspDynamicSkinForm;
  Prompt: TspSkinStdLabel;
  Combobox: TspSkinComboBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Caption := ACaption;
  Form.Position := poScreenCenter;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  try
    with Form Do
    begin
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
    end;

    Prompt := TspSkinStdLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
      WordWrap := False;
      DefaultFont := DefaultLabelFont;
      UseSkinFont := Self.UseSkinFont;
      SkinDataName := FLabelSkinDataName;
      SkinData := CtrlSkinData;
      Caption := APrompt;
    end;

    Combobox := TspSkinCombobox.Create(Form);
    with Combobox do
    begin
      Parent := Form;
      DefaultFont := DefaultComboboxFont;
      UseSkinFont := Self.UseSkinFont;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 5;
      DefaultWidth := MulDiv(164, DialogUnits.X, 4);
      Items.Assign(Self.SelectValues);
      Combobox.ItemIndex := FDefaultValueIndex;
      SkinDataName := FSelectSkinDataName;
      SkinData := CtrlSkinData;
    end;

    ButtonTop := Combobox.Top + Combobox.Height + 15;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

    with TspSkinButton.Create(Form) do
    begin
      Parent := Form;
      DefaultFont:= DefaultButtonFont;
      UseSkinFont := Self.UseSkinFont;
      if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
      then
        Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
      else
        Caption := SP_MSG_BTN_OK;
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4) - BtnOff,
        ButtonTop, ButtonWidth, ButtonHeight);
      DefaultHeight := ButtonHeight;
      SkinDataName := FButtonSkinDataName;
      SkinData := CtrlSkinData;
    end;

    with TspSkinButton.Create(Form) do
    begin
      Parent := Form;
      DefaultFont := DefaultButtonFont;
      UseSkinFont := Self.UseSkinFont;
      if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
      then
        Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
      else
        Caption := SP_MSG_BTN_CANCEL;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4) + BtnOff, Combobox.Top + Combobox.Height + 15,
                ButtonWidth, ButtonHeight);
      DefaultHeight := ButtonHeight;
      SkinDataName := FButtonSkinDataName;
      SkinData := CtrlSkinData;
      Form.ClientHeight := Top + Height + 13;
    end;

    if Form.ShowModal = mrOk
    then
      begin
        ValueIndex := Combobox.ItemIndex;
        Result := True;
      end
    else
      Result := False;
  finally
    Form.Free;
  end;
end;

procedure TspSkinSelectValueDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinSelectValueDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinSelectValueDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinSelectValueDialog.SetDefaultSelectFont(Value: TFont);
begin
  FDefaultSelectFont.Assign(Value);
end;

procedure TspSkinSelectValueDialog.SetSelectValues(const Value: TStrings);
begin
  FSelectValues.Assign(Value);
end;

// TspSelectSkinsFromFolderDialog

constructor TspSelectSkinsFromFoldersDlgForm.CreateEx;
var
  Idx: Integer;
  BSR: TSearchRec;
  ResStrData: TspResourceStrData;
  S, S1: String;
  I: Integer;
begin
  inherited CreateNew(AOwner);
  Position := poScreenCenter;
  BorderStyle := bsSingle;

  DSF := TspDynamicSkinForm.Create(Self);

  FCompressed := ACompressed;

  if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
  then
    ResStrData := ACtrlSkinData.ResourceStrData
  else
    ResStrData := nil;

  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  begin
    Parent := Self;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_PREVIEWSKIN')
    else
      Caption := SP_MSG_PREVIEWSKIN;
    Enabled := False;
    Width :=  220;
    Height := 170;
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

  OpenButton := TspSkinButton.Create(Self);
  with OpenButton do
  begin
    Default := True;
    if ResStrData <> nil
    then
      Caption := ResStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    CanFocused := True;
    Left := 260;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrOK;
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
    Left := 340;
    Top := 200;
    Width := 70;
    DefaultHeight := 25;
    Parent := Self;
    ModalResult := mrCancel;
    Cancel := True;
  end;

  SkinsListBox := TspSkinListBox.Create(Self);
  with SkinsListBox do
  begin
    Parent := Self;
    SetBounds(10, 10, 170, 170);
    OnListboxClick := SLBOnChange;
    OnListboxDblClick := SLBOnDblClick;
  end;

  FIniFileName := AIniFileName;

  // load skins
  FSkinsFolder := ASkinsFolder;
  if FSkinsFolder = '' then FSkinsFolder := ExtractFilePath(ParamStr(0));
  if FSkinsFolder[Length(FSkinsFolder)] <> '\'
  then
    FSkinsFolder := FSkinsFolder + '\';
  Idx := -1;
  SkinsListBox.Clear;
  if FCompressed
  then
    begin
      if FindFirst(FSkinsFolder + '*.*', faAnyFile, BSR) = 0 then begin
      while True do begin
        if (BSR.Attr and faDirectory = 0) and (BSR.Name <> '.') and (BSR.Name <> '..')
        then
         begin
           S := LowerCase(ExtractFileExt(BSR.Name));
           if S = '.' +  Lowercase(FIniFileName)
           then
             begin
               S1 := LowerCase(BSR.Name);
               I := Pos(S, S1);
               if I <> 0
               then
                 begin
                   S1 := BSR.Name;
                   Delete(S1, I, Length(S));
                   SkinsListBox.Items.Add(S1);
                   if Lowercase(S1) = Lowercase(ADefaultSkinFolder) then Idx := SkinsListBox.Items.Count - 1;
                 end;
             end;
         end;
       if FindNext(BSR) <> 0 then Break;
       end;
       FindClose(BSR);
      end
    end
  else
    begin
      if FindFirst(FSkinsFolder + '*.*', faAnyFile, BSR) = 0 then begin
      while True do begin
        if (BSR.Attr and faDirectory <> 0) and (BSR.Name <> '.') and (BSR.Name <> '..') then begin
          SkinsListBox.Items.Add(BSR.Name);
        end;
       if Lowercase(BSR.Name) = Lowercase(ADefaultSkinFolder) then Idx := SkinsListBox.Items.Count - 1;
       if FindNext(BSR) <> 0 then Break;
       end;
       FindClose(BSR);
     end;
   end;
  if Idx = -1
  then SkinsListBox.ItemIndex := 0
  else SkinsListBox.ItemIndex := Idx;
  SLBOnChange(Self);
  //
  with PreviewForm do
  begin
    Left := 190;
    Top := 10;
    PreviewForm.Visible := not PreviewSkinData.Empty;
   end;
  //
  ActiveControl := SkinsListBox.ListBox;
end;

destructor TspSelectSkinsFromFoldersDlgForm.Destroy;
begin
  inherited;
end;

procedure TspSelectSkinsFromFoldersDlgForm.SLBOnDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TspSelectSkinsFromFoldersDlgForm.SLBOnChange(Sender: TObject);
var
  BFN: String;
begin
 if (SkinsListBox.Items.Count > 0) and (SkinsListBox.ItemIndex <> -1)
  then
    begin
      if FCompressed
      then
        begin
          BFN := FSkinsFolder + SkinsListBox.Items[SkinsListBox.ItemIndex] + '.' +  FIniFileName;
          PreviewSkinData.LoadFromCompressedFile(BFN);
          PreviewForm.Visible := not PreviewSkinData.Empty;
        end
      else
        begin
          BFN := FSkinsFolder + SkinsListBox.Items[SkinsListBox.ItemIndex] + '\' + FIniFileName;
          PreviewSkinData.LoadFromFile(BFN);
          PreviewForm.Visible := not PreviewSkinData.Empty;
        end;
    end;
end;

constructor TspSelectSkinsFromFoldersDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FSkinName := '';
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FTitle := 'Select skin';
  FDefaultFont := TFont.Create;
  with FDefaultFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSelectSkinsFromFoldersDialog.Destroy;
begin
  FDefaultFont.Free;
  inherited Destroy;
end;

procedure TspSelectSkinsFromFoldersDialog.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSelectSkinsFromFoldersDialog.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

function TspSelectSkinsFromFoldersDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSelectSkinsFromFoldersDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

function TspSelectSkinsFromFoldersDialog.Execute2(ASkinsFolder, ADefaultSkinFolder, AIniFileName: String): Boolean;
var
  FW, FH: Integer;
begin
  FDlgFrm := TspSelectSkinsFromFoldersDlgForm.CreateEx(Application, ASkinsFolder,
   ADefaultSkinFolder, AIniFileName, CtrlSkinData, False);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.Sizeable := False;
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := Self.AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := Self.AlphaBlendValue;
    OpenButton.SkinData := CtrlSkinData;
    CancelButton.SkinData := CtrlSkinData;
    SkinsListBox.SkinData := CtrlSkinData;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    SkinsListBox.DefaultFont := DefaultFont;
    //
    FW := 420;
    FH := 240;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    if (FDlgFrm.ShowModal = mrOk) and (SkinsListBox.Items.Count > 0) and
       (SkinsListBox.ItemIndex <> -1)
    then
      begin
        FSkinName := SkinsListBox.Items[SkinsListBox.ItemIndex];
        FFileName := FSkinsFolder +
          SkinsListBox.Items[SkinsListBox.ItemIndex] + '\' + AIniFileName;
        Result := True;
      end
    else
      Result := False;

  finally
    Free;
    FDlgFrm := nil;
  end;
end;

function TspSelectSkinsFromFoldersDialog.Execute(ASkinsFolder, ADefaultSkinFile, ASkinExt: String): Boolean;
var
  FW, FH: Integer;
begin
  FDlgFrm := TspSelectSkinsFromFoldersDlgForm.CreateEx(Application, ASkinsFolder,
   ADefaultSkinFile, ASkinExt, CtrlSkinData, True);
  with FDlgFrm do
  try
    Caption := Self.Title;
    DSF.BorderIcons := [];
    DSF.Sizeable := False;
    DSF.SkinData := FSD;
    DSF.MenusSkinData := CtrlSkinData;
    DSF.AlphaBlend := Self.AlphaBlend;
    DSF.AlphaBlendAnimation := AlphaBlendAnimation;
    DSF.AlphaBlendValue := Self.AlphaBlendValue;
    OpenButton.SkinData := CtrlSkinData;
    CancelButton.SkinData := CtrlSkinData;
    SkinsListBox.SkinData := CtrlSkinData;
    //
    OpenButton.DefaultFont := DefaultFont;
    CancelButton.DefaultFont := DefaultFont;
    SkinsListBox.DefaultFont := DefaultFont;
    //
    FW := 420;
    FH := 240;

    if (SkinData <> nil) and not SkinData.Empty
    then
      begin
        if FW < DSF.GetMinWidth then FW := DSF.GetMinWidth;
        if FH < DSF.GetMinHeight then FH := DSF.GetMinHeight;
      end;

    ClientWidth := FW;
    ClientHeight := FH;

    if (FDlgFrm.ShowModal = mrOk) and (SkinsListBox.Items.Count > 0) and
       (SkinsListBox.ItemIndex <> -1)
    then
      begin
        FSkinName := SkinsListBox.Items[SkinsListBox.ItemIndex];
        FFileName := FSkinsFolder +
          SkinsListBox.Items[SkinsListBox.ItemIndex] + '.' + FIniFileName;
        Result := True;
      end
    else
      Result := False;

  finally
    Free;
    FDlgFrm := nil;
  end;
end;

// TspSkinFindDialog

constructor TspSkinFindDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGroupBoxTransparentMode := False;
  FOptions := [spfrDown];
  FPosition.X := -1;
  FPosition.Y := -1;
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

 with FDefaultEditFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  FTitle := 'Find';

  Form := nil;
end;

destructor TspSkinFindDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited Destroy;
end;

procedure TspSkinFindDialog.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form := nil;
  if Assigned(FOnClose) then FOnClose(Sender);
  Action := caFree;
end;

procedure TspSkinFindDialog.CloseButtonClick(Sender: TObject);
begin
  Form.Close;
end;

procedure TspSkinFindDialog.FindButtonClick(Sender: TObject);
begin
  Find;
end;

function TspSkinFindDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinFindDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinFindDialog.DirecionUpClick(Sender: TObject);
begin
  Options := Options - [spfrDown];
end;

procedure TspSkinFindDialog.DirecionDownClick(Sender: TObject);
begin
  Options := Options + [spfrDown];
end;

procedure TspSkinFindDialog.MatchCaseCheckBoxClick(Sender: TObject);
begin
  if MatchCaseCheckBox.Checked
  then
    Options := Options + [spfrMatchCase]
  else
    Options := Options - [spfrMatchCase];
end;

procedure TspSkinFindDialog.MatchWWOnlyCheckBoxClick(Sender: TObject);
begin
  if MatchWWOnlyCheckBox.Checked
  then
    Options := Options + [spfrWholeWord]
  else
    Options := Options - [spfrWholeWord];
end;

procedure TspSkinFindDialog.EditChange;
begin
  FFindText := FEdit.Text;
  FindButton.Enabled := FFindText <> '';
end;

procedure TspSkinFindDialog.EditKeyDown;
begin
  if Key = 13 then Find;
end;

function TspSkinFindDialog.Execute: Boolean;
var
  DSF: TspDynamicSkinForm;
  DialogUnits: TPoint;
  DirectionGroupBox: TspSkinGroupBox;
begin

  if Form <> nil then Exit;

  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.FormStyle := fsStayOnTop;
  Form.OnClose := OnFormClose;
  Form.Caption := FTitle;
  if (Self.FPosition.X > -1) and (Self.FPosition.Y > -1)
  then
    begin
      Form.Left := FPosition.X;
      Form.Top := FPosition.Y;
    end
  else
    Form.Position := poScreenCenter;
    
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  with Form Do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    ClientWidth := 380;
  end;

  with TspSkinStdLabel.Create(Form) do
  begin
    Parent := Form;
    Left := 10;
    Top := 17;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_WHAT')
    else
      Caption := SP_FIND_WHAT;
  end;

  FEdit := TspSkinEdit.Create(Form);
  with FEdit do
  begin
    Parent := Form;
    SkinData := CtrlSkinData;
    DefaultFont := DefaultlabelFont;
    UseSkinFont := Self.UseSkinFont;
    Left := 80;
    Top := 15;
    Width := Form.ClientWidth - 180;
    DefaultHeight := 21;
    MaxLength := 255;
    Text := FFindText;
    OnKeyDown := EditKeydown;
    OnChange := EditChange;
  end;

  MatchWWOnlyCheckBox := TspSkinCheckRadioBox.Create(Self);
  with MatchWWOnlyCheckBox do
  begin
    Parent := Form;
    Left := 5;
    Top := 50;
    Width := 160;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_MATCH_WHOLE_WORD_ONLY')
    else
      Caption := SP_FIND_MATCH_WHOLE_WORD_ONLY;
    Visible := not (spfrHideWholeWord in Options);
    Checked := spfrWholeWord in Options;
    OnClick := MatchWWOnlyCheckBoxClick;
  end;

  MatchCaseCheckBox := TspSkinCheckRadioBox.Create(Self);
  with MatchCaseCheckBox do
  begin
    Parent := Form;
    Left := 5;
    Top := 80;
    Width := 160;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_MATCH_CASE')
    else
      Caption := SP_FIND_MATCH_CASE;
    Visible := not (spfrHideMatchCase in Options);
    Checked := spfrMatchCase in Options;
    OnClick := MatchCaseCheckBoxClick;
  end;

  DirectionGroupBox := TspSkinGroupBox.Create(Self);

  with DirectionGroupBox do
  begin
    Parent := Form;
    Left := 160;
    Top := 50;
    Width := 120;
    Height := 55;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTION')
    else
      Caption := SP_FIND_DIRECTION;
    Visible := not (spfrHideUpDown in Options);
    Enabled := not (spfrDisableUpDown in Options);
    if FGroupBoxTransparentMode and Visible
    then
      TransparentMode := FGroupBoxTransparentMode;
  end;

  with TspSkinCheckRadioBox.Create(Self) do
  begin
    GroupIndex := 1;
    Parent := DirectionGroupBox;
    Left := 5;
    Top := DirectionGroupBox.GetSkinClientRect.Top + 2;
    Width := RectWidth(DirectionGroupBox.GetSkinClientRect) div 2 - 5;
    Height := RectHeight(DirectionGroupBox.GetSkinClientRect) - 2;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTIONUP')
    else
      Caption := SP_FIND_DIRECTIONUP;
    Checked := not (spfrDown in Options);
    OnClick := DirecionUpClick;
  end;

  with TspSkinCheckRadioBox.Create(Self) do
  begin
    GroupIndex := 1;
    Parent := DirectionGroupBox;
    Left := DirectionGroupBox.Width div 2 - 10 + 5;
    Top := DirectionGroupBox.GetSkinClientRect.Top + 2;
    Width := RectWidth(DirectionGroupBox.GetSkinClientRect) div 2;
    Height := RectHeight(DirectionGroupBox.GetSkinClientRect) - 2;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTIONDOWN')
    else
      Caption := SP_FIND_DIRECTIONDOWN;
    Checked := spfrDown in Options;
    OnClick := DirecionDownClick;  
  end;

  FindButton := TspSkinButton.Create(Form);
  with FindButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_NEXT')
    else
      Caption := SP_FIND_NEXT;
    SetBounds(Form.ClientWidth - 90, 15, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    OnClick := FindButtonClick;
    Enabled := FFindText <> '';
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CLOSE')
    else
      Caption := SP_MSG_BTN_CLOSE;
    Cancel := True;
    SetBounds(Form.ClientWidth - 90, 50, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 45;
    OnClick := CloseButtonClick;
  end;

  Form.Show;

  Result := True;
end;

procedure TspSkinFindDialog.Find;
begin
  if Assigned(FOnFind) then FOnFind(Self);
end;

function TspSkinFindDialog.GetFindText: string;
begin
  Result := FFindText;
end;

function TspSkinFindDialog.GetLeft: Integer;
begin
  Result := Position.X;
end;

function TspSkinFindDialog.GetPosition: TPoint;
var
  Rect: TRect;
begin
  Result := FPosition;
  if Form <> nil then
  begin
    Result.X := Form.Left;
    Result.Y := Form.Top;
  end;
end;

function TspSkinFindDialog.GetTop: Integer;
begin
  Result := Position.Y;
end;

procedure TspSkinFindDialog.SetFindText(const Value: string);
begin
  FFindText := Value;
end;

procedure TspSkinFindDialog.SetLeft(Value: Integer);
begin
  SetPosition(Point(Value, Top));
end;

procedure TspSkinFindDialog.SetPosition(const Value: TPoint);
begin
  if (FPosition.X <> Value.X) or (FPosition.Y <> Value.Y) then
  begin
    FPosition := Value;
    if Form <> nil
    then
      begin
        Form.Left := FPosition.X;
        Form.Top := FPosition.Y;
      end;
  end;
end;

procedure TspSkinFindDialog.SetTop(Value: Integer);
begin
  SetPosition(Point(Left, Value));
end;

procedure TspSkinFindDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinFindDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinFindDialog.SetDefaultEditFont(Value: TFont);
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinFindDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

// TspSkinReplaceDialog

constructor TspSkinReplaceDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGroupBoxTransparentMode := False;
  FOptions := [spfrDown];
  FPosition.X := -1;
  FPosition.Y := -1;
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultEditFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

 with FDefaultEditFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  FTitle := 'Replace';

  FFindText := '';
  FReplaceText := '';

  Form := nil;
end;

destructor TspSkinReplaceDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultEditFont.Free;
  inherited Destroy;
end;

procedure TspSkinReplaceDialog.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form := nil;
  if Assigned(FOnClose) then FOnClose(Sender);
  Action := caFree;
end;

procedure TspSkinReplaceDialog.CloseButtonClick(Sender: TObject);
begin
  Form.Close;
end;

procedure TspSkinReplaceDialog.FindButtonClick(Sender: TObject);
begin
  Find;
end;

function TspSkinReplaceDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinReplaceDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TspSkinReplaceDialog.DirecionUpClick(Sender: TObject);
begin
  Options := Options - [spfrDown];
end;

procedure TspSkinReplaceDialog.DirecionDownClick(Sender: TObject);
begin
  Options := Options + [spfrDown];
end;

procedure TspSkinReplaceDialog.MatchCaseCheckBoxClick(Sender: TObject);
begin
  if MatchCaseCheckBox.Checked
  then
    Options := Options + [spfrMatchCase]
  else
    Options := Options - [spfrMatchCase];
end;

procedure TspSkinReplaceDialog.MatchWWOnlyCheckBoxClick(Sender: TObject);
begin
  if MatchWWOnlyCheckBox.Checked
  then
    Options := Options + [spfrWholeWord]
  else
    Options := Options - [spfrWholeWord];
end;

procedure TspSkinReplaceDialog.EditChange;
begin
  FFindText := FEdit.Text;
  FindButton.Enabled := FFindText <> '';
  ReplaceButton.Enabled := FFindText <> '';
  ReplaceAllButton.Enabled := FFindText <> '';
end;

procedure TspSkinReplaceDialog.EditKeyDown;
begin
  if Key = 13 then Find;
end;

procedure TspSkinReplaceDialog.ReplaceEditKeyDown;
begin
  if Key = 13 then Find;
end;

procedure TspSkinReplaceDialog.ReplaceEditChange;
begin
  FReplaceText := FReplaceEdit.Text;
end;

procedure TspSkinReplaceDialog.ReplaceButtonClick(Sender: TObject);
begin
  Options := Options + [spfrReplace] - [spfrReplaceAll];
  Replace;
end;

procedure TspSkinReplaceDialog.ReplaceAllButtonClick(Sender: TObject);
begin
  Options := Options - [spfrReplace] + [spfrReplaceAll];
  Replace;
end;

function TspSkinReplaceDialog.Execute: Boolean;
var
  DSF: TspDynamicSkinForm;
  DialogUnits: TPoint;
  DirectionGroupBox: TspSkinGroupBox;
begin

  if Form <> nil then Exit;

  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.FormStyle := fsStayOnTop;
  Form.OnClose := OnFormClose;
  Form.Caption := FTitle;
  if (Self.FPosition.X > -1) and (Self.FPosition.Y > -1)
  then
    begin
      Form.Left := FPosition.X;
      Form.Top := FPosition.Y;
    end
  else
    Form.Position := poScreenCenter;
    
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  with Form Do
  begin
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    ClientWidth := 380;
  end;

  with TspSkinStdLabel.Create(Form) do
  begin
    Parent := Form;
    Left := 10;
    Top := 17;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_WHAT')
    else
      Caption := SP_FIND_WHAT;
  end;

  FEdit := TspSkinEdit.Create(Form);
  with FEdit do
  begin
    Parent := Form;
    SkinData := CtrlSkinData;
    DefaultFont := DefaultlabelFont;
    UseSkinFont := Self.UseSkinFont;
    Left := 80;
    Top := 15;
    Width := Form.ClientWidth - 180;
    DefaultHeight := 21;
    MaxLength := 255;
    Text := FFindText;
    OnKeyDown := EditKeydown;
    OnChange := EditChange;
  end;

  with TspSkinStdLabel.Create(Form) do
  begin
    Parent := Form;
    Left := 10;
    Top := 53;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_REPLACE_WITH')
    else
      Caption := SP_FIND_REPLACE_WITH;
  end;

  FReplaceEdit := TspSkinEdit.Create(Form);
  with FReplaceEdit do
  begin
    Parent := Form;
    SkinData := CtrlSkinData;
    DefaultFont := DefaultlabelFont;
    UseSkinFont := Self.UseSkinFont;
    Left := 80;
    Top := 50;
    Width := Form.ClientWidth - 180;
    DefaultHeight := 21;
    MaxLength := 255;
    Text := FReplaceText;
    OnKeyDown := ReplaceEditKeydown;
    OnChange := ReplaceEditChange;
  end;

  MatchWWOnlyCheckBox := TspSkinCheckRadioBox.Create(Self);
  with MatchWWOnlyCheckBox do
  begin
    Parent := Form;
    Left := 5;
    Top := 90;
    Width := 160;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_MATCH_WHOLE_WORD_ONLY')
    else
      Caption := SP_FIND_MATCH_WHOLE_WORD_ONLY;
    Visible := not (spfrHideWholeWord in Options);
    Checked := spfrWholeWord in Options;
    OnClick := MatchWWOnlyCheckBoxClick;
  end;

  MatchCaseCheckBox := TspSkinCheckRadioBox.Create(Self);
  with MatchCaseCheckBox do
  begin
    Parent := Form;
    Left := 5;
    Top := 120;
    Width := 160;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_MATCH_CASE')
    else
      Caption := SP_FIND_MATCH_CASE;
    Visible := not (spfrHideMatchCase in Options);
    Checked := spfrMatchCase in Options;
    OnClick := MatchCaseCheckBoxClick;
  end;

  DirectionGroupBox := TspSkinGroupBox.Create(Self);

  with DirectionGroupBox do
  begin
    Parent := Form;
    Left := 160;
    Top := 90;
    Width := 120;
    Height := 55;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTION')
    else
      Caption := SP_FIND_DIRECTION;
    Visible := not (spfrHideUpDown in Options);
    Enabled := not (spfrDisableUpDown in Options);
    if FGroupBoxTransparentMode and Visible
    then
      TransparentMode := FGroupBoxTransparentMode;
  end;

  with TspSkinCheckRadioBox.Create(Self) do
  begin
    GroupIndex := 1;
    Parent := DirectionGroupBox;
    Left := 5;
    Top := DirectionGroupBox.GetSkinClientRect.Top + 2;
    Width := RectWidth(DirectionGroupBox.GetSkinClientRect) div 2 - 5;
    Height := RectHeight(DirectionGroupBox.GetSkinClientRect) - 2;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTIONUP')
    else
      Caption := SP_FIND_DIRECTIONUP;
    Checked := not (spfrDown in Options);
    OnClick := DirecionUpClick;
  end;

  with TspSkinCheckRadioBox.Create(Self) do
  begin
    GroupIndex := 1;
    Parent := DirectionGroupBox;
    Left := DirectionGroupBox.Width div 2 - 10 + 5;
    Top := DirectionGroupBox.GetSkinClientRect.Top + 2;
    Width := RectWidth(DirectionGroupBox.GetSkinClientRect) div 2;
    Height := RectHeight(DirectionGroupBox.GetSkinClientRect) - 2;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_DIRECTIONDOWN')
    else
      Caption := SP_FIND_DIRECTIONDOWN;
    Checked := spfrDown in Options;
    OnClick := DirecionDownClick;  
  end;

  FindButton := TspSkinButton.Create(Form);
  with FindButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_NEXT')
    else
      Caption := SP_FIND_NEXT;
    SetBounds(Form.ClientWidth - 90, 15, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    OnClick := FindButtonClick;
    Enabled := FFindText <> '';
  end;

  ReplaceButton := TspSkinButton.Create(Form);
  with ReplaceButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_REPLACE')
    else
      Caption := SP_FIND_REPLACE;
    SetBounds(Form.ClientWidth - 90, 50, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    OnClick := ReplaceButtonClick;
    Enabled := FFindText <> '';
  end;

  ReplaceAllButton := TspSkinButton.Create(Form);
  with ReplaceAllButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('FIND_REPLACE_ALL')
    else
      Caption := SP_FIND_REPLACE_ALL;
    SetBounds(Form.ClientWidth - 90, 85, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    OnClick := ReplaceAllButtonClick;
    Enabled := FFindText <> '';
  end;

  CloseButton := TspSkinButton.Create(Form);
  with CloseButton do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CLOSE')
    else
      Caption := SP_MSG_BTN_CLOSE;
    Cancel := True;
    SetBounds(Form.ClientWidth - 90, 120, 80, 25);
    DefaultHeight := 21;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 20;
    OnClick := CloseButtonClick;
  end;

  Form.Show;

  Result := True;
end;

procedure TspSkinReplaceDialog.Find;
begin
  if Assigned(FOnFind) then FOnFind(Self);
end;

procedure TspSkinReplaceDialog.Replace;
begin
  if Assigned(FOnReplace) then FOnReplace(Self);
end;

function TspSkinReplaceDialog.GetFindText: string;
begin
  Result := FFindText;
end;

function TspSkinReplaceDialog.GetReplaceText: string;
begin
  Result := FReplaceText;
end;

function TspSkinReplaceDialog.GetLeft: Integer;
begin
  Result := Position.X;
end;

function TspSkinReplaceDialog.GetPosition: TPoint;
var
  Rect: TRect;
begin
  Result := FPosition;
  if Form <> nil then
  begin
    Result.X := Form.Left;
    Result.Y := Form.Top;
  end;
end;

function TspSkinReplaceDialog.GetTop: Integer;
begin
  Result := Position.Y;
end;

procedure TspSkinReplaceDialog.SetFindText(const Value: string);
begin
  FFindText := Value;
end;

procedure TspSkinReplaceDialog.SetReplaceText(const Value: string);
begin
  FReplaceText := Value;
end;

procedure TspSkinReplaceDialog.SetLeft(Value: Integer);
begin
  SetPosition(Point(Value, Top));
end;

procedure TspSkinReplaceDialog.SetPosition(const Value: TPoint);
begin
  if (FPosition.X <> Value.X) or (FPosition.Y <> Value.Y) then
  begin
    FPosition := Value;
    if Form <> nil
    then
      begin
        Form.Left := FPosition.X;
        Form.Top := FPosition.Y;
      end;
  end;
end;

procedure TspSkinReplaceDialog.SetTop(Value: Integer);
begin
  SetPosition(Point(Left, Value));
end;

procedure TspSkinReplaceDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinReplaceDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinReplaceDialog.SetDefaultEditFont(Value: TFont);
begin
  FDefaultEditFont.Assign(Value);
end;

procedure TspSkinReplaceDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;


end.

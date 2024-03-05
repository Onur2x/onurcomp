unit SkinData;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}


interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, SPUtils, Forms,
     IniFiles, Dialogs;

type

  TStdCommand = (cmClose, cmMaximize, cmMinimize, cmSysMenu, cmDefault, cmRollUp,
                 cmMinimizeToTray);
  TMorphKind = (mkDefault, mkGradient, mkLeftGradient, mkRightGradient,
                mkLeftSlide, mkRightSlide, mkPush);
  TFramesPlacement = (fpHorizontal, fpVertical);
  TRegulatorKind = (rkRound, rkHorizontal, rkVertical);
  TspInActiveEffect = (ieBrightness, ieDarkness, ieGrayScale,
                       ieNoise, ieSplitBlur, ieInvert);

  TspDataSkinControl = class(TObject)
  public
    IDName: String;
    PictureIndex: Integer;
    MaskPictureIndex: Integer;
    SkinRect: TRect;
    CursorIndex: Integer;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); virtual;
    procedure SaveToFile(IniFile: TCustomIniFile); virtual;
  end;

  TspDataSkinBevel = class(TspDataSkinControl)
  public
    LightColor: TColor;
    DarkColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;
TspDataSkinresimkutusu = class(TspDataSkinControl)
  public
   LightColor: TColor;
    DarkColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;
  TspDataSkinSlider = class(TspDataSkinControl)
  public
    HRulerRect: TRect;
    HThumbRect: TRect;
    VRulerRect: TRect;
    VThumbRect: TRect;
    EdgeSize: Integer;
    BGColor: TColor;
    PointsColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinTreeView = class(TspDataSkinControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    BGColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinRichEdit = class(TspDataSkinControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    BGColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinListView = class(TspDataSkinControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    BGColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMainMenuBar = class(TspDataSkinControl)
  public
    ItemsRect: TRect;
    MenuBarItem: String;
    CloseButton: String;
    MaxButton: String;
    MinButton: String;
    SysMenuButton: String;
    TrackMarkColor, TrackMarkActiveColor: Integer;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinTabControl = class(TspDataSkinControl)
  public
    TabRect, ActiveTabRect, FocusTabRect, MouseInTabRect: TRect;
    ClRect: TRect;
    TabsBGRect: TRect;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    TabLeftOffset, TabRightOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FocusFontColor, MouseInFontColor: TColor;
    UpDown: String;
    BGPictureIndex: Integer; 
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinGridControl = class(TspDataSkinControl)
  public
    FixedCellRect, SelectCellRect, FocusCellRect: TRect;
    //
    FixedCellLeftOffset, FixedCellRightOffset: Integer;
    FixedCellTextRect: TRect;
    //
    CellLeftOffset, CellRightOffset: Integer;
    CellTextRect: TRect;
    //
    LinesColor, BGColor: TColor;
    BGPictureIndex: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, SelectFontColor, FocusFontColor: TColor;
    FixedFontName: String;
    FixedFontStyle: TFontStyles;
    FixedFontHeight: Integer;
    FixedFontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinFrameControl = class(TspDataSkinControl)
  public
    FramesCount: Integer;
    FramesPlacement: TFramesPlacement;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinAnimateControl = class(TspDataSkinFrameControl);
  TspDataSkinSwitchControl = class(TspDataSkinFrameControl);
  TspDataSkinFrameGauge = class(TspDataSkinFrameControl);

  TspDataSkinFrameRegulator = class(TspDataSkinFrameControl)
  public
    Kind: TRegulatorKind;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinCustomControl = class(TspDataSkinControl)
  public
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    ClRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinControlBar = class(TspDataSkinCustomControl)
  public
    ItemRect: TRect;
    BGPictureIndex: Integer;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinUpDownControl = class(TspDataSkinCustomControl)
  public
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;
  
  TspDataSkinComboBox = class(TspDataSkinCustomControl)
  public
    //
    SItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, FocusFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect: TRect;
    UnEnabledButtonRect: TRect;
    //
    ListBoxName: String;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinListBox = class(TspDataSkinCustomControl)
  public
    //
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, FocusFontColor: TColor;
    //
    CaptionRect: TRect;
    CaptionFontName: String;
    CaptionFontStyle: TFontStyles;
    CaptionFontHeight: Integer;
    CaptionFontColor: TColor;
    //
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    CheckButtonRect, ActiveCheckButtonRect, DownCheckButtonRect: TRect;
    //
    HScrollBarName: String;
    VScrollBarName: String;
    BothScrollBarName: String;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinCheckListBox = class(TspDataSkinListBox)
  public
    UnCheckImageRect, CheckImageRect: TRect;
    ItemCheckRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinScrollBarControl = class(TspDataSkinCustomControl)
  public
    TrackArea: TRect;
    UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
    DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
    ThumbRect, ActiveThumbRect, DownThumbRect: TRect;
    ThumbOffset1, ThumbOffset2: Integer;
    GlyphRect, ActiveGlyphRect, DownGlyphRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
 end;

 TspDataSkinSpinEditControl = class(TspDataSkinCustomControl)
 public
   ActiveSkinRect: TRect;
   FontName: String;
   FontStyle: TFontStyles;
   FontHeight: Integer;
   FontColor, ActiveFontColor, DisabledFontColor: TColor;
   UpButtonRect, ActiveUpButtonRect, DownUpButtonRect: TRect;
   DownButtonRect, ActiveDownButtonRect, DownDownButtonRect: TRect;
   constructor Create(AIDName: String);
   procedure LoadFromFile(IniFile: TCustomIniFile); override;
   procedure SaveToFile(IniFile: TCustomIniFile); override;
 end;

  TspDataSkinEditControl = class(TspDataSkinCustomControl)
  public
    ActiveSkinRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, DisabledFontColor: TColor;
    ActiveFontColor: TColor;
    ButtonRect: TRect;
    ActiveButtonRect: TRect;
    DownButtonRect: TRect;
    UnEnabledButtonRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMemoControl = class(TspDataSkinEditControl)
  public
    BGColor: TColor;
    ActiveBGColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinStdLabelControl = class(TspDataSkinControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    ActiveFontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinLabelControl = class(TspDataSkinCustomControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinBitLabelControl = class(TspDataSkinCustomControl)
  public
    SkinTextRect: TRect;
    SymbolWidth: Integer;
    SymbolHeight: Integer;
    Symbols: TStrings;
    constructor Create(AIDName: String);
    destructor Destroy; override;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinTrackBarControl = class(TspDataSkinCustomControl)
  public
    TrackArea, ButtonRect, ActiveButtonRect: TRect;
    Vertical: Boolean;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;


  TspDataSkinSplitterControl = class(TspDataSkinCustomControl);
  
  TspDataSkinGaugeControl = class(TspDataSkinCustomControl)
  public
    ProgressArea, ProgressRect: TRect;
    Vertical: Boolean;
    BeginOffset, EndOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinButtonControl = class(TspDataSkinCustomControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, DisabledFontColor: TColor;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    ActiveSkinRect, DownSkinRect, DisabledSkinRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMenuButtonControl = class(TspDataSkinButtonControl)
  public
    TrackButtonRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinCheckRadioControl = class(TspDataSkinCustomControl)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, UnEnabledFontColor: TColor;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    ActiveSkinRect: TRect;
    CheckImageArea, TextArea, 
    CheckImageRect, UnCheckImageRect: TRect;
    ActiveCheckImageRect, ActiveUnCheckImageRect: TRect;
    UnEnabledCheckImageRect, UnEnabledUnCheckImageRect: TRect;
    FrameFontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinScrollBoxControl = class(TspDataSkinCustomControl)
  public
    BGPictureIndex: Integer;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinPanelControl = class(TspDataSkinCustomControl)
  public
    CaptionRect: TRect;
    Alignment: TAlignment;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    BGPictureIndex: Integer;
    CheckImageRect, UnCheckImageRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinExPanelControl = class(TspDataSkinCustomControl)
  public
    //
    RollHSkinRect, RollVSkinRect: TRect;
    RollLeftOffset, RollRightOffset,
    RollTopOffset, RollBottomOffset: Integer;
    RollVCaptionRect, RollHCaptionRect: TRect;
    //
    CloseButtonRect, CloseButtonActiveRect, CloseButtonDownRect: TRect;
    HRollButtonRect, HRollButtonActiveRect, HRollButtonDownRect: TRect;
    HRestoreButtonRect, HRestoreButtonActiveRect, HRestoreButtonDownRect: TRect;
    VRollButtonRect, VRollButtonActiveRect, VRollButtonDownRect: TRect;
    VRestoreButtonRect, VRestoreButtonActiveRect, VRestoreButtonDownRect: TRect;
    //
    CaptionRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  
  TspDataSkinArea = class(TObject)
  public
    IDName: String;
    AreaRect: TRect;
    constructor Create(AIDName: String; ARect: TRect);
  end;

  TspDataSkinObject = class(TObject)
  public
    IDName: String;
    Hint: String;
    SkinRectInAPicture: Boolean;
    SkinRect: TRect;
    ActiveSkinRect: TRect;
    InActiveSkinRect: TRect;
    Morphing: Boolean;
    MorphKind: TMorphKind;
    ActivePictureIndex: Integer;
    CursorIndex: Integer;
    RollUp: Boolean;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); virtual;
    procedure SaveToFile(IniFile: TCustomIniFile); virtual;
  end;

  TspDataUserObject = class(TspDataSkinObject)
  public
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinBitLabel = class(TspDataSkinObject)
  public
    Symbols: TStrings;
    TextValue: String;
    SymbolWidth, SymbolHeight: Integer;
    constructor Create(AIDName: String);
    destructor Destroy; override;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinAnimate = class(TspDataSkinObject)
  public
    CountFrames: Integer;
    Cycle: Boolean;
    ButtonStyle: Boolean;
    TimerInterval: Integer;
    Command: TStdCommand;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinLabel = class(TspDataSkinObject)
  public
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    FontColor, ActiveFontColor: TColor;
    Alignment: TAlignment;
    TextValue: String;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinSwitch = class(TspDataSkinObject);

  TGaugeKind = (gkHorizontal, gkVertical);
  TspDataSkinGauge = class(TspDataSkinObject)
  public
    MinValue, MaxValue: Integer;
    Kind: TGaugeKind;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinFrameRegulatorObject = class(TspDataSkinObject)
  public
    MinValue, MaxValue: Integer;
    CountFrames: Integer;
    FramesPlacement: TFramesPlacement;
    Kind: TRegulatorKind;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinFrameGaugeObject = class(TspDataSkinObject)
  public
    MinValue, MaxValue: Integer;
    CountFrames: Integer;
    FramesPlacement: TFramesPlacement;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TTrackKind = (tkHorizontal, tkVertical);
  TspDataSkinTrackBar = class(TspDataSkinObject)
  public
    ButtonRect, ActiveButtonRect: TRect;
    BeginPoint, EndPoint: TPoint;
    MinValue, MaxValue: Integer;
    MouseDownChangeValue: Boolean;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinButton = class(TspDataSkinObject)
  public
    GroupIndex: Integer;
    DownRect: TRect;
    DisableSkinRect: TRect;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinStdButton = class(TspDataSkinButton)
  public
    Command: TStdCommand;
    RestoreRect: TRect;
    RestoreActiveRect: TRect;
    RestoreDownRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMainMenuBarButton = class(TspDataSkinStdButton);

  TspDataSkinPopupWindow = class(TObject)
  public
    WindowPictureIndex: Integer;
    MaskPictureIndex: Integer;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    ItemsRect: TRect;
    ScrollMarkerColor, ScrollMarkerActiveColor: Integer;
    CursorIndex: Integer;
    TopStretch, LeftStretch,
    RightStretch, BottomStretch: Boolean;
    constructor Create;
    procedure LoadFromFile(IniFile: TCustomIniFile);
    procedure SaveToFile(IniFile: TCustomIniFile);
  end;

  TspDataSkinHintWindow = class(TObject)
  public
    WindowPictureIndex: Integer;
    MaskPictureIndex: Integer;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    ClRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    TopStretch, LeftStretch,
    RightStretch, BottomStretch: Boolean;
    constructor Create;
    procedure LoadFromFile(IniFile: TCustomIniFile);
    procedure SaveToFile(IniFile: TCustomIniFile);
  end;

  TspDataSkinMenuItem = class(TspDataSkinObject)
  public
    DividerRect: TRect;
    DividerLO, DividerRO: Integer;
    ItemLO, ItemRO: Integer;
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    UnEnabledFontColor, FontColor, ActiveFontColor: TColor;
    TextRct: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMainMenuItem = class(TspDataSkinObject)
  public
    DownRect: TRect;
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    FontColor, ActiveFontColor, DownFontColor, UnEnabledFontColor: TColor;
    TextRct: TRect;
    ItemLO, ItemRO: Integer;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinMainMenuBarItem = class(TspDataSkinMainMenuItem);

  TspDataSkinCaption = class(TspDataSkinObject)
  public
    FontName: String;
    FontHeight: Integer;
    FontStyle: TFontStyles;
    FontColor, ActiveFontColor: TColor;
    ShadowColor, ActiveShadowColor: TColor;
    Shadow: Boolean;
    Alignment: TAlignment;
    TextRct: TRect;
    DefaultCaption: Boolean;
    FrameRect, ActiveFrameRect: TRect;
    FrameLeftOffset, FrameRightOffset: Integer;
    FrameTextRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspSkinData = class;

  TspCompressedStoredSkin = class(TComponent)
  private
    FFileName: String;
    FCompressedFileName: String;
    FCompressedStream: TMemoryStream;
    FDescription: String;
    procedure SetFileName(Value: String);
    procedure SetCompressedFileName(Value: String);
    function GetEmpty: Boolean;
  protected
    procedure ReadData(Reader: TStream);
    procedure WriteData(Writer: TStream);
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromIniFile(AFileName: String);
    procedure LoadFromCompressFile(AFileName: String);
    procedure SaveToCompressFile(AFileName: String);
    procedure DeCompressToStream(var S: TMemoryStream);
    procedure LoadFromSkinData(ASkinData: TspSkinData);
    property Empty: Boolean read GetEmpty;
  published
    property Description: String read FDescription write FDescription;
    property FileName: String read FFileName write SetFileName;
    property CompressedFileName: String read FCompressedFileName write SetCompressedFileName;
  end;

  TspResourceStrData = class(TComponent)
  private
    FResStrs: TStrings;
    FCharSet: TFontCharSet;
    procedure SetResStrs(Value: TStrings);
    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetResStr(const ResName: String): String;
  published
    property ResStrings: TStrings read FResStrs write SetResStrs;
    property CharSet: TFontCharSet read FCharSet write FCharSet;
  end;

  TspSkinData = class(TComponent)
  protected
    FCompressedStoredSkin: TspCompressedStoredSkin;
    FResourceStrData: TspResourceStrData;
    procedure SetCompressedStoredSkin(Value: TspCompressedStoredSkin);
    procedure SetResourceStrData(Value: TspResourceStrData);
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure WriteFormInfo(F: TCustomIniFile);
    procedure ReadFormInfo(F: TCustomIniFile);
    procedure WriteAreas(F: TCustomIniFile);
    procedure ReadAreas(F: TCustomIniFile);
    procedure WriteObjects(F: TCustomIniFile);
    procedure ReadObjects(F: TCustomIniFile);
    procedure WriteCtrls(F: TCustomIniFile);
    procedure ReadCtrls(F: TCustomIniFile);
    procedure WriteActivePictures(F: TCustomIniFile);
    procedure WriteCursors(F: TCustomIniFile);

    procedure ReadActivePictures(F: TCustomIniFile; Path: String);
    procedure ReadCursors(F: TCustomIniFile; Path: String);
    procedure GetObjectTypeName(S: String; var AName, AType: String);
    procedure GetAreaNameRect(S: String; var AName: String; var ARect: TRect);
  public
    //
    ButtonsRect, CaptionRect: TRect;
    ButtonsOffset: Integer;
    CapButtonsInLeft: Boolean;
    //
    AutoRenderingInActiveImage: Boolean;
    InActiveEffect: TspInActiveEffect;
    StartCursorIndex: Integer;
    CursorIndex: Integer;
    BuildMode: Boolean;
    PopupWindow: TspDataSkinPopupWindow;
    HintWindow: TspDataSkinHintWindow;
    Empty: Boolean;
    FPicture, FInActivePicture, FMask: TBitMap;
    FRollUpPicture, FRollUpMask: TBitMap;
    FActivePictures: TList;
    FPictureName, FInActivePictureName, FMaskName: String;
    FRollUpPictureName, FRollUpMaskName: String;
    FActivePicturesNames: TStrings;
    FCursorsNames: TStrings;
    ObjectList: TList;
    AreaList: TList;
    CtrlList: TList;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    BGPictureIndex: Integer;
    MDIBGPictureIndex: Integer;
    MainMenuRect: TRect;
    IconRect: TRect;
    MainMenuPopupUp: Boolean;
    MaskRectArea: TRect;
    HitTestLTPoint,
    HitTestRTPoint,
    HitTestLBPoint,
    HitTestRBPoint: TPoint;
    ClRect: TRect;
    BorderW: Integer;
    TopStretch, LeftStretch,
    RightStretch, BottomStretch: Boolean;
    
    RollUpLeftPoint, RollUpRightPoint: TPoint;

    SkinName: String;
    SkinAuthor: String;
    AuthorURL: String;
    AuthorEmail: String;
    SkinComments: String;

    procedure SaveToCustomIniFile(F: TCustomIniFile);
    
    procedure AddBitMap(FileName: String);
    procedure DeleteBitMap(Index: Integer);

    procedure AddSkinArea(AName: String; ARect: TRect);

    procedure SendSkinDataMessage(M: LongInt);
    function GetIndex(AIDName: String): Integer;
    function Getareaya(AIDName: String): Trect;
    function GetControlIndex(AIDName: String): Integer;
    function GetAreaIndex(AIDName: String): Integer;
    procedure ClearObjects;
    procedure ClearAll;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure LoadFromFile(FileName: String);
    procedure SaveToFile(FileName: String);
    procedure LoadFromCompressedFile(FileName: String);
    procedure SaveToCompressedFile(FileName: String);
    procedure StoreToDisk(APath: String);
    //
    procedure LoadCompressedStoredSkin(AStoredSkin: TspCompressedStoredSkin);
    //
    procedure ClearSkin;

  published
    property CompressedStoredSkin: TspCompressedStoredSkin
      read FCompressedStoredSkin write SetCompressedStoredSkin;
    property ResourceStrData: TspResourceStrData
      read FResourceStrData write SetResourceStrData;  
  end;

  function ReadInActiveEffect(IniFile: TCustomIniFile;
                              Section: String; Ident: String): TspInActiveEffect;

  procedure WriteInActiveEffect(IniFile: TCustomIniFile;
                                Section: String; Ident: String;
                                IE: TspInActiveEffect);

  function ReadMorphKind(IniFile: TCustomIniFile;
                     Section: String; Ident: String): TMorphKind;

  procedure WriteMorphKind(IniFile: TCustomIniFile;
                       Section: String; Ident: String; MK: TMorphKind);

// Internal messages
const
  WM_BEFORECHANGESKINDATA = WM_USER + 201;
  WM_CHANGESKINDATA = WM_USER + 202;
  WM_AFTERCHANGESKINDATA = WM_USER + 203;
  WM_CHANGERESSTRDATA = WM_USER + 250;
  
implementation
   Uses spZLibCompress;
function CheckSkinFile(F: TCustomIniFile): Boolean;
begin
  Result := F.SectionExists('VERSION') and F.SectionExists('PICTURES') and
            F.SectionExists('FORMINFO') and F.SectionExists('SKINOBJECTS') and
            F.SectionExists('SKINCONTROLS');
end;

function ReadMorphKind;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, 'mkdefault');
  if S = 'mkdefault'
  then Result := mkDefault
  else
  if S = 'mkgradient'
  then Result := mkGradient
  else
  if S = 'mkleftgradient'
  then Result := mkLeftGradient
  else
  if S = 'mkrightgradient'
  then Result := mkRightGradient
  else
  if S = 'mkleftslide'
  then Result := mkLeftSlide
  else
  if S = 'mkrightslide'
  then Result := mkRightSlide
  else
  if S = 'mkpush'
  then Result := mkPush
  else Result := mkDefault;
end;

procedure WriteMorphKind;
var
  S: String;
begin
  case MK of
    mkDefault: S := 'mkdefault';
    mkGradient: S := 'mkgradient';
    mkLeftGradient: S := 'mkleftgradient';
    mkRightGradient: S := 'mkrightgradient';
    mkLeftSlide: S := 'mkleftslide';
    mkRightSlide: S := 'mkrightslide';
    mkPush: S := 'mkpush';
  end;
  IniFile.WriteString(Section, Ident, S);
end;

procedure WriteInActiveEffect;
var
  S: String;
begin
  case IE of
    ieBrightness: S := 'iebrightness';
    ieDarkness: S := 'iedarkness';
    ieGrayScale: S := 'iegrayscale';
    ieNoise: S := 'ienoise';
    ieSplitBlur: S := 'iesplitblur';
    ieInvert: S := 'ieinvert';
  end;
  IniFile.WriteString(Section, Ident, S);
end;

function ReadInActiveEffect;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, 'iebrightness');
  if S = 'iebrightness'
  then Result := ieBrightness
  else
  if S = 'iedarkness'
  then Result := ieDarkness
  else
  if S = 'iegrayscale'
  then Result := ieGrayScale
  else
  if S = 'ienoise'
  then Result := ieNoise
  else
  if S = 'iesplitblur'
  then Result := ieSplitBlur
  else
  if S = 'ieinvert'
  then Result := ieInvert
  else Result := ieGrayScale;
end;

constructor TspDataSkinControl.Create;
begin
  IDName := AIDName;
  PictureIndex := -1;
  MaskPictureIndex := -1;
  SkinRect := Rect(0, 0, 0, 0);
  CursorIndex := -1;
end;

procedure TspDataSkinControl.LoadFromFile;
begin
  PictureIndex := IniFile.ReadInteger(IDName, 'pictureindex', -1);
  MaskPictureIndex := IniFile.ReadInteger(IDName, 'maskpictureindex', -1);
  CursorIndex := IniFile.ReadInteger(IDName, 'cursorindex', -1);
  SkinRect := ReadRect(IniFile, IDName, 'skinrect');
end;

procedure TspDataSkinControl.SaveToFile;
begin
  IniFile.EraseSection(IDName);
  IniFile.WriteInteger(IDName, 'pictureindex', PictureIndex);
  IniFile.WriteInteger(IDName, 'maskpictureindex', MaskPictureIndex);
  IniFile.WriteInteger(IDName, 'cursorindex', CursorIndex);
  WriteRect(IniFile, IDName, 'skinrect', SkinRect);
end;

constructor TspDataSkinMainMenuBar.Create;
begin
  inherited;
  TrackMarkColor := 0;
  TrackMarkActiveColor := 0;
end;

procedure TspDataSkinMainMenuBar.LoadFromFile;
begin
  inherited;
  ItemsRect := ReadRect(IniFile, IDName, 'itemsrect');
  MenuBarItem := IniFile.ReadString(IDName, 'menubaritem', '');
  CloseButton := IniFile.ReadString(IDName, 'closebutton', '');
  MinButton := IniFile.ReadString(IDName, 'minbutton', '');
  MaxButton := IniFile.ReadString(IDName, 'maxbutton', '');
  SysMenuButton := IniFile.ReadString(IDName, 'sysmenubutton', '');
  TrackMarkColor := IniFile.ReadInteger(IDName, 'trackmarkcolor', 0);
  TrackMarkActiveColor := IniFile.ReadInteger(IDName, 'trackmarkactivecolor', 0);
end;

procedure TspDataSkinMainMenuBar.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemsrect', ItemsRect);
  IniFile.WriteString(IDName, 'menubaritem', MenuBarItem);
  IniFile.WriteString(IDName, 'closebutton', CloseButton);
  IniFile.WriteString(IDName, 'minbutton', MinButton);
  IniFile.WriteString(IDName, 'maxbutton', MaxButton);
  IniFile.WriteString(IDName, 'sysmenubutton', SysMenuButton);
  IniFile.WriteInteger(IDName, 'trackmarkcolor', TrackMarkColor);
  IniFile.WriteInteger(IDName, 'trackmarkactivecolor', TrackMarkActiveColor);
end;

procedure TspDataSkinUpDownControl.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  UpButtonRect := ReadRect(IniFile, IDName, 'upbuttonrect');
  ActiveUpButtonRect := ReadRect(IniFile, IDName, 'activeupbuttonrect');
  DownUpButtonRect := ReadRect(IniFile, IDName, 'downupbuttonrect');
  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  ActiveDownButtonRect := ReadRect(IniFile, IDName, 'activedownbuttonrect');
  DownDownButtonRect := ReadRect(IniFile, IDName, 'downdownbuttonrect');
  LTPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  ClRect := NullRect;
end;

procedure TspDataSkinUpDownControl.SaveToFile(IniFile: TCustomIniFile);
begin
  LTPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  ClRect := NullRect;
  inherited;
  WriteRect(IniFile, IDName, 'upbuttonrect', UpButtonRect);
  WriteRect(IniFile, IDName, 'activeupbuttonrect', ActiveUpButtonRect);
  WriteRect(IniFile, IDName, 'downupbuttonrect', DownUpButtonRect);
  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'activedownbuttonrect', ActiveDownButtonRect);
  WriteRect(IniFile, IDName, 'downdownbuttonrect', DownDownButtonRect);
end;

constructor TspDataSkinListBox.Create(AIDName: String);
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  CaptionFontName := 'Arial';
  CaptionFontStyle := [];
  CaptionFontHeight := 14;
  CaptionFontColor := 0;
  HScrollBarName := '';
  VScrollBarName := '';
  BothScrollBarName := '';
end;

procedure TspDataSkinListBox.LoadFromFile;
begin
  inherited;
  //
  SItemRect := ReadRect(IniFile, IDName, 'itemrect');
  ActiveItemRect := ReadRect(IniFile, IDName, 'activeitemrect');
  FocusItemRect := ReadRect(IniFile, IDName, 'focusitemrect');
  ItemLeftOffset := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRightOffset := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  ItemTextRect := ReadRect(IniFile, IDName, 'itemtextrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  //
  CaptionRect := ReadRect(IniFile, IDName, 'captionrect');
  CaptionFontName := IniFile.ReadString(IDName, 'captionfontname', 'Arial');
  CaptionFontHeight := IniFile.ReadInteger(IDName, 'captionfontheight', 14);
  CaptionFontStyle := ReadFontStyles(IniFile, IDName, 'captionfontstyle');
  CaptionFontColor := IniFile.ReadInteger(IDName, 'captionfontcolor', 0);
  //
  UpButtonRect := ReadRect(IniFile, IDName, 'upbuttonrect');
  ActiveUpButtonRect := ReadRect(IniFile, IDName, 'activeupbuttonrect');
  DownUpButtonRect := ReadRect(IniFile, IDName, 'downupbuttonrect');
  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  ActiveDownButtonRect := ReadRect(IniFile, IDName, 'activedownbuttonrect');
  DownDownButtonRect := ReadRect(IniFile, IDName, 'downdownbuttonrect');
  CheckButtonRect := ReadRect(IniFile, IDName, 'checkbuttonrect');
  ActiveCheckButtonRect := ReadRect(IniFile, IDName, 'activecheckbuttonrect');
  DownCheckButtonRect := ReadRect(IniFile, IDName, 'downcheckbuttonrect');
  //
  VScrollBarName := IniFile.ReadString(IDName, 'vscrollbarname', 'vscrollbar');
  HScrollBarName := IniFile.ReadString(IDName, 'hscrollbarname', 'hscrollbar');
  BothScrollBarName := IniFile.ReadString(IDName, 'bothhscrollbarname', 'bothhscrollbar');
end;

procedure TspDataSkinListBox.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemrect', SItemRect);
  WriteRect(IniFile, IDName, 'activeitemrect', ActiveItemRect);
  WriteRect(IniFile, IDName, 'focusitemrect', FocusItemRect);
  IniFile.WriteInteger(IDName, 'itemleftoffset', ItemLeftOffset);
  IniFile.WriteInteger(IDName, 'itemrightoffset', ItemRightOffset);
  WriteRect(IniFile, IDName, 'itemtextrect', ItemTextRect);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  //
  WriteRect(IniFile, IDName, 'captionrect', CaptionRect);
  IniFile.WriteString(IDName, 'captionfontname', CaptionFontName);
  IniFile.WriteInteger(IDName, 'captionfontheight', CaptionFontHeight);
  WriteFontStyles(IniFile, IDName, 'captionfontstyle', CaptionFontStyle);
  IniFile.WriteInteger(IDName, 'captionfontcolor', CaptionFontColor);
  //
  WriteRect(IniFile, IDName, 'upbuttonrect', UpButtonRect);
  WriteRect(IniFile, IDName, 'activeupbuttonrect', ActiveUpButtonRect);
  WriteRect(IniFile, IDName, 'downupbuttonrect', DownUpButtonRect);
  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'activedownbuttonrect', ActiveDownButtonRect);
  WriteRect(IniFile, IDName, 'downdownbuttonrect', DownDownButtonRect);
  WriteRect(IniFile, IDName, 'checkbuttonrect', CheckButtonRect);
  WriteRect(IniFile, IDName, 'activecheckbuttonrect', ActiveCheckButtonRect);
  WriteRect(IniFile, IDName, 'downcheckbuttonrect', DownCheckButtonRect);
  //
  IniFile.WriteString(IDName, 'vscrollbarname', VScrollBarName);
  IniFile.WriteString(IDName, 'hscrollbarname', HScrollBarName);
  IniFile.WriteString(IDName, 'bothhscrollbarname', BothScrollBarName);
end;

procedure TspDataSkinCheckListBox.LoadFromFile;
begin
  inherited;
  CheckImageRect := ReadRect(IniFile, IDName, 'checkimagerect');
  ItemCheckRect := ReadRect(IniFile, IDName, 'itemcheckrect');
  UnCheckImageRect := ReadRect(IniFile, IDName, 'uncheckimagerect');
end;

procedure TspDataSkinCheckListBox.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemcheckrect', ItemCheckRect);
  WriteRect(IniFile, IDName, 'uncheckimagerect', UnCheckImageRect);
  WriteRect(IniFile, IDName, 'checkimagerect', CheckImageRect);
end;

constructor TspDataSkinComboBox.Create(AIDName: String);
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  FocusFontColor := 0;
  ListBoxName := '';
end;

procedure TspDataSkinComboBox.LoadFromFile;
begin
  inherited;
  //
  SItemRect := ReadRect(IniFile, IDName, 'itemrect');
  FocusItemRect := ReadRect(IniFile, IDName, 'focusitemrect');
  ItemLeftOffset := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRightOffset := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  ItemTextRect := ReadRect(IniFile, IDName, 'itemtextrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  //
  ListBoxName := IniFile.ReadString(IDName, 'listboxname', '');
  //
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  UnEnabledButtonRect := ReadRect(IniFile, IDName, 'unenabledbuttonrect');
  //
end;

procedure TspDataSkinComboBox.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemrect', SItemRect);
  WriteRect(IniFile, IDName, 'focusitemrect', FocusItemRect);
  IniFile.WriteInteger(IDName, 'itemleftoffset', ItemLeftOffset);
  IniFile.WriteInteger(IDName, 'itemrightoffset', ItemRightOffset);
  WriteRect(IniFile, IDName, 'itemtextrect', ItemTextRect);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  //
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'unenabledbuttonrect', UnEnabledButtonRect);
  //
  IniFile.WriteString(IDName, 'listboxname', ListBoxName);
end;

constructor TspDataSkinControlBar.Create(AIDName: String);
begin
  inherited;
  BGPictureIndex := -1;
end;

procedure TspDataSkinControlBar.LoadFromFile;
begin
  inherited;
  ItemRect := ReadRect(IniFile, IDName, 'itemrect');
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
end;

procedure TspDataSkinControlBar.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemrect', ItemRect);
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);
end;

constructor TspDataSkinTreeView.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinTreeView.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
end;

procedure TspDataSkinTreeView.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
end;

constructor TspDataSkinListView.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinListView.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
end;

procedure TspDataSkinListView.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
end;

constructor TspDataSkinRichEdit.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinRichEdit.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
end;

procedure TspDataSkinRichEdit.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
end;

constructor TspDataSkinSlider.Create;
begin
  inherited;
  BGColor := 0;
end;

procedure TspDataSkinSlider.LoadFromFile;
begin
  inherited;
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
  HRulerRect := ReadRect(IniFile, IDName, 'hrulerrect');
  HThumbRect := ReadRect(IniFile, IDName, 'hthumbrect');
  VRulerRect := ReadRect(IniFile, IDName, 'vrulerrect');
  VThumbRect := ReadRect(IniFile, IDName, 'vthumbrect');
  EdgeSize := IniFile.ReadInteger(IDName, 'edgesize', 0);
  PointsColor := IniFile.ReadInteger(IDName, 'pointscolor', 0);
end;

procedure TspDataSkinSlider.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
  WriteRect(IniFile, IDName, 'hrulerrect', HRulerRect);
  WriteRect(IniFile, IDName, 'hthumbrect', HThumbRect);
  WriteRect(IniFile, IDName, 'vrulerrect', VRulerRect);
  WriteRect(IniFile, IDName, 'vthumbrect', VThumbRect);
  IniFile.WriteInteger(IDName, 'edgesize', EdgeSize);
  IniFile.WriteInteger(IDName, 'pointscolor', PointsColor);
end;

constructor TspDataSkinBevel.Create;
begin
  inherited;
  LightColor := 0;
  DarkColor := 0;
end;

procedure TspDataSkinBevel.LoadFromFile;
begin
  inherited;
  LightColor := IniFile.ReadInteger(IDName, 'lightcolor', 0);
  DarkColor := IniFile.ReadInteger(IDName, 'darkcolor', 0);
end;

procedure TspDataSkinBevel.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'lightcolor', LightColor);
  IniFile.WriteInteger(IDName, 'darkcolor', DarkColor);
end;

constructor TspDataSkinresimkutusu.Create;
begin
  inherited;
  LightColor := 0;
  DarkColor := 0;
end;

procedure TspDataSkinresimkutusu.LoadFromFile;
begin
  inherited;
  LightColor := IniFile.ReadInteger(IDName, 'lightcolor', 0);
  DarkColor := IniFile.ReadInteger(IDName, 'darkcolor', 0);
end;

procedure TspDataSkinresimkutusu.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'lightcolor', LightColor);
  IniFile.WriteInteger(IDName, 'darkcolor', DarkColor);
end;



constructor TspDataSkinTabControl.Create(AIDName: String);
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  ActiveFontColor := 0;
  FocusFontColor := 0;
  UpDown := '';
  BGPictureIndex := -1;
end;

procedure TspDataSkinTabControl.LoadFromFile;
begin
  inherited;
  TabRect := ReadRect(IniFile, IDName, 'tabrect');
  ActiveTabRect := ReadRect(IniFile, IDName, 'activetabrect');
  FocusTabRect := ReadRect(IniFile, IDName, 'focustabrect');
  MouseInTabRect := ReadRect(IniFile, IDName, 'mouseintabrect');
  
  ClRect := ReadRect(IniFile, IDName, 'clientrect');
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
  LTPoint := ReadPoint(IniFile, IDName, 'lefttoppoint');
  RTPoint := Readpoint(IniFile, IDName, 'righttoppoint');
  LBPoint := ReadPoint(IniFile, IDName, 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, IDName, 'rightbottompoint');

  TabLeftOffset := IniFile.ReadInteger(IDName, 'tableftoffset', 0);
  TabRightOffset := IniFile.ReadInteger(IDName, 'tabrightoffset', 0);
  TabsBGRect := ReadRect(IniFile, IDName, 'tabsbgrect');

  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  MouseInFontColor := IniFile.ReadInteger(IDName, 'mouseinfontcolor', 0);

  UpDown := IniFile.ReadString(IDName, 'updown', '');
end;

procedure TspDataSkinTabControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'tabrect', TabRect);
  WriteRect(IniFile, IDName, 'activetabrect', ActiveTabRect);
  WriteRect(IniFile, IDName, 'focustabrect', FocusTabRect);
  WriteRect(IniFile, IDName, 'mouseintabrect',  MouseInTabRect);
  WriteRect(IniFile, IDName, 'clientrect', ClRect);
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);

  WritePoint(IniFile, IDName, 'lefttoppoint', LTPoint);
  writePoint(IniFile, IDName, 'righttoppoint', RTPoint);
  WritePoint(IniFile, IDName, 'leftbottompoint', LBPoint);
  WritePoint(IniFile, IDName, 'rightbottompoint', RBPoint);

  IniFile.WriteInteger(IDName, 'tableftoffset', TabLeftOffset);
  IniFile.WriteInteger(IDName, 'tabrightoffset', TabRightOffset);
  WriteRect(IniFile, IDName, 'tabsbgrect', TabsBGRect);

  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  IniFile.WriteInteger(IDName, 'mouseinfontcolor', MouseInFontColor);

  IniFile.WriteString(IDName, 'updown', UpDown);
end;

constructor TspDataSkinGridControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
  FixedFontName := 'Arial';
  FixedFontStyle := [];
  FixedFontHeight := 14;
  FixedFontColor := 0;
  BGPictureIndex := -1;
end;

procedure TspDataSkinGridControl.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  FixedCellRect := ReadRect(IniFile, IDName, 'fixedcellrect');
  SelectCellRect := ReadRect(IniFile, IDName, 'selectcellrect');
  FocusCellRect := ReadRect(IniFile, IDName, 'focuscellrect');
  //
  FixedCellLeftOffset := IniFile.ReadInteger(IDName, 'fixedcellleftoffset', 0);
  FixedCellRightOffset := IniFile.ReadInteger(IDName, 'fixedcellrightoffset', 0);
  FixedCellTextRect := ReadRect(IniFile, IDName, 'fixedcelltextrect');
  //
  CellLeftOffset := IniFile.ReadInteger(IDName, 'cellleftoffset', 0);
  CellRightOffset := IniFile.ReadInteger(IDName, 'cellrightoffset', 0);
  CellTextRect := ReadRect(IniFile, IDName, 'celltextrect');
  //
  LinesColor := IniFile.ReadInteger(IDName, 'linescolor', 0);
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  SelectFontColor := IniFile.ReadInteger(IDName, 'selectfontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  //
  FixedFontName := IniFile.ReadString(IDName, 'fixedfontname', 'Arial');
  FixedFontHeight := IniFile.ReadInteger(IDName, 'fixedfontheight', 14);
  FixedFontStyle := ReadFontStyles(IniFile, IDName, 'fixedfontstyle');
  FixedFontColor := IniFile.ReadInteger(IDName, 'fixedfontcolor', 0);
end;

procedure TspDataSkinGridControl.SaveToFile(IniFile: TCustomIniFile);
begin
  inherited;
  WriteRect(IniFile, IDName, 'fixedcellrect', FixedCellRect);
  WriteRect(IniFile, IDName, 'selectcellrect', SelectCellRect);
  WriteRect(IniFile, IDName, 'focuscellrect', FocusCellRect);
  //
  IniFile.WriteInteger(IDName, 'fixedcellleftoffset', FixedCellLeftOffset);
  IniFile.WriteInteger(IDName, 'fixedcellrightoffset', FixedCellRightOffset);
  WriteRect(IniFile, IDName, 'fixedcelltextrect', FixedCellTextRect);
  //
  IniFile.WriteInteger(IDName, 'cellleftoffset', CellLeftOffset);
  IniFile.WriteInteger(IDName, 'cellrightoffset', CellRightOffset);
  WriteRect(IniFile, IDName, 'celltextrect', CellTextRect);
  //
  IniFile.WriteInteger(IDName, 'linescolor', LinesColor);
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'selectfontcolor', SelectFontColor);
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  //
  IniFile.WriteString(IDName, 'fixedfontname', FixedFontName);
  IniFile.WriteInteger(IDName, 'fixedfontheight', FixedFontHeight);
  WriteFontStyles(IniFile, IDName, 'fixedfontstyle', FixedFontStyle);
  IniFile.WriteInteger(IDName, 'fixedfontcolor', FixedFontColor);
end;


constructor TspDataSkinFrameControl.Create;
begin
  inherited;
  FramesCount := 1;
  FramesPlacement := fpHorizontal;
end;

procedure TspDataSkinFrameControl.LoadFromFile;
var
  S: String;
begin
  inherited;
  FramesCount := IniFile.ReadInteger(IDName, 'framescount', 1);
  if FramesCount < 1 then FramesCount := 1;
  S := IniFile.ReadString(IDName, 'framesplacement', 'fphorizontal');
  if S = 'fphorizontal'
  then FramesPlacement := fpHorizontal
  else FramesPlacement := fpVertical;
end;

procedure TspDataSkinFrameControl.SaveToFile;
var
  S: String;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'framescount', FramesCount);
  if FramesPlacement = fpHorizontal
  then S := 'fphorizontal'
  else S := 'fpvertical';
  IniFile.WriteString(IDName, 'framesplacement', S);
end;


constructor TspDataSkinFrameRegulator.Create;
begin
  inherited;
  Kind := rkRound;
end;

procedure TspDataSkinFrameRegulator.LoadFromFile;
var
  S: String;
begin
  inherited;
  Kind := rkRound;
  S := IniFile.ReadString(IDName, 'kind', 'rkround');
  if S = 'rkround'
  then Kind := rkRound
  else
  if S = 'rkhorizontal'
  then Kind := rkHorizontal
  else Kind := rkVertical;
end;

procedure TspDataSkinFrameRegulator.SaveToFile;
var
  S: String;
begin
  inherited;
  if Kind = rkRound
  then S := 'rkround'
  else
  if Kind = rkHorizontal
  then S := 'rkhorizontal'
  else S := 'rkvertical';
  IniFile.WriteString(IDName, 'kind', S);
end;

constructor TspDataSkinCustomControl.Create;
begin
  inherited;
  LTPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  ClRect := Rect(0, 0, 0, 0);
  MaskPictureIndex := -1;
end;

procedure TspDataSkinCustomControl.LoadFromFile;
begin
  inherited;
  LTPoint := ReadPoint(IniFile, IDName, 'lefttoppoint');
  RTPoint := ReadPoint(IniFile, IDName, 'righttoppoint');
  LBPoint := ReadPoint(IniFile, IDName, 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, IDName, 'rightbottompoint');
  ClRect := ReadRect(IniFile, IDName, 'clientrect');
end;

procedure TspDataSkinCustomControl.SaveToFile;
begin
  inherited;
  WritePoint(IniFile, IDName, 'lefttoppoint', LTPoint);
  WritePoint(IniFile, IDName, 'righttoppoint', RTPoint);
  WritePoint(IniFile, IDName, 'leftbottompoint', LBPoint);
  WritePoint(IniFile, IDName, 'rightbottompoint', RBPoint);
  WriteRect(IniFile, IDName, 'clientrect', ClRect);
end;


constructor TspDataSkinSpinEditControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
end;

procedure TspDataSkinSpinEditControl.LoadFromFile;
begin
  inherited;
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DisabledFontColor := IniFile.ReadInteger(IDName, 'disabledfontcolor', 0);

  UpButtonRect := ReadRect(IniFile, IDName, 'upbuttonrect');
  ActiveUpButtonRect := ReadRect(IniFile, IDName, 'activeupbuttonrect');
  DownUpButtonRect := ReadRect(IniFile, IDName, 'downupbuttonrect');

  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  ActiveDownButtonRect := ReadRect(IniFile, IDName, 'activedownbuttonrect');
  DownDownButtonRect := ReadRect(IniFile, IDName, 'downdownbuttonrect');
end;

procedure TspDataSkinSpinEditControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'disabledfontcolor', DisabledFontColor);

  WriteRect(IniFile, IDName, 'upbuttonrect', UpButtonRect);
  WriteRect(IniFile, IDName, 'activeupbuttonrect', ActiveUpButtonRect);
  WriteRect(IniFile, IDName, 'downupbuttonrect', DownUpButtonRect);

  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'activedownbuttonrect', ActiveDownButtonRect);
  WriteRect(IniFile, IDName, 'downdownbuttonrect', DownDownButtonRect);
end;


constructor TspDataSkinEditControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
end;

procedure TspDataSkinEditControl.LoadFromFile;
begin
  inherited;
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  DisabledFontColor := IniFile.ReadInteger(IDName, 'disabledfontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  UnEnabledButtonRect := ReadRect(IniFile, IDName, 'unenabledbuttonrect');
end;

procedure TspDataSkinEditControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'disabledfontcolor', DisabledFontColor);
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'unenabledbuttonrect', UnEnabledButtonRect);
end;

constructor TspDataSkinMemoControl.Create(AIDName: String);
begin
  inherited;
end;

procedure TspDataSkinMemoControl.LoadFromFile;
begin
  inherited;
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
  ActiveBGColor := IniFile.ReadInteger(IDName, 'activebgcolor', 0);
end;

procedure TspDataSkinMemoControl.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
  IniFile.WriteInteger(IDName, 'activebgcolor', ActiveBGColor);
end;

constructor TspDataSkinStdLabelControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := clBlue;
end;

procedure TspDataSkinStdLabelControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', clBlue);
end;

procedure TspDataSkinStdLabelControl.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
end;

constructor TspDataSkinBitLabelControl.Create;
begin
  inherited;
  Symbols := TStringList.Create;
  SymbolWidth := 0;
  SymbolHeight := 0;
end;

destructor TspDataSkinBitLabelControl.Destroy;
begin
  Symbols.Clear;
  Symbols.Free;
  inherited;
end;

procedure TspDataSkinBitLabelControl.LoadFromFile;
begin
  inherited;
  SkinTextRect := ReadRect(IniFile, IDName, 'skintextrect');
  SymbolWidth := IniFile.ReadInteger(IDName, 'symbolwidth', 0);
  SymbolHeight := IniFile.ReadInteger(IDName, 'symbolheight', 0);
  ReadStrings(IniFile, IDName, 'symbols', Symbols);
end;

procedure TspDataSkinBitLabelControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'skintextrect', SkinTextRect);
  IniFile.WriteInteger(IDName, 'symbolwidth', SymbolWidth);
  IniFile.WriteInteger(IDName, 'symbolheight', SymbolHeight);
  WriteStrings(IniFile, IDName, 'symbols', Symbols);
end;


constructor TspDataSkinLabelControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
end;

procedure TspDataSkinLabelControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
end;

procedure TspDataSkinLabelControl.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
end;



constructor TspDataSkinScrollBarControl.Create;
begin
  inherited;
  ThumbOffset1 := 0;
  ThumbOffset2 := 0;
end;

procedure TspDataSkinScrollBarControl.LoadFromFile;
begin
  inherited;
  TrackArea := ReadRect(IniFile, IDName, 'trackarea');

  UpButtonRect := ReadRect(IniFile, IDName, 'upbuttonrect');
  ActiveUpButtonRect := ReadRect(IniFile, IDName, 'activeupbuttonrect');
  DownUpButtonRect := ReadRect(IniFile, IDName, 'downupbuttonrect');

  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  ActiveDownButtonRect := ReadRect(IniFile, IDName, 'activedownbuttonrect');
  DownDownButtonRect := ReadRect(IniFile, IDName, 'downdownbuttonrect');

  ThumbRect := ReadRect(IniFile, IDName, 'thumbrect');
  ActiveThumbRect := ReadRect(IniFile, IDName, 'activethumbrect');
  DownThumbRect := ReadRect(IniFile, IDName, 'downthumbrect');
  ThumbOffset1 := IniFile.ReadInteger(IDName, 'thumboffset1', 0);
  ThumbOffset2 := IniFile.ReadInteger(IDName, 'thumboffset2', 0);

  GlyphRect := ReadRect(IniFile, IDName, 'glyphrect');
  ActiveGlyphRect := ReadRect(IniFile, IDName, 'activeglyphrect');
  DownGlyphRect := ReadRect(IniFile, IDName, 'downglyphrect');
end;

procedure TspDataSkinScrollBarControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'trackarea', TrackArea);

  WriteRect(IniFile, IDName, 'upbuttonrect', UpButtonRect);
  WriteRect(IniFile, IDName, 'activeupbuttonrect', ActiveUpButtonRect);
  WriteRect(IniFile, IDName, 'downupbuttonrect', DownUpButtonRect);

  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'activedownbuttonrect', ActiveDownButtonRect);
  WriteRect(IniFile, IDName, 'downdownbuttonrect', DownDownButtonRect);

  WriteRect(IniFile, IDName, 'thumbrect', ThumbRect);
  WriteRect(IniFile, IDName, 'activethumbrect', ActiveThumbRect);
  WriteRect(IniFile, IDName, 'downthumbrect', DownThumbRect);

  IniFile.WriteInteger(IDName, 'thumboffset1', ThumbOffset1);
  IniFile.WriteInteger(IDName, 'thumboffset2', ThumbOffset2);

  WriteRect(IniFile, IDName, 'glyphrect', GlyphRect);
  WriteRect(IniFile, IDName, 'activeglyphrect', ActiveGlyphRect);
  WriteRect(IniFile, IDName, 'downglyphrect', DownGlyphRect);
end;

constructor TspDataSkinTrackBarControl.Create;
begin
  inherited;
  TrackArea := NullRect;
  ButtonRect := NullRect;
  ActiveButtonRect := NullRect;
  Vertical := False;
end;

procedure TspDataSkinTrackBarControl.LoadFromFile;
begin
  inherited;
  TrackArea := ReadRect(IniFile, IDName, 'trackarea');
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  Vertical := ReadBoolean(IniFile, IDName, 'vertical');
end;

procedure TspDataSkinTrackBarControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'trackarea', TrackArea);
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WriteBoolean(IniFile, IDName, 'vertical', Vertical);
end;

constructor TspDataSkinGaugeControl.Create;
begin
  inherited;
  ProgressArea := NullRect;
  ProgressRect := NullRect;
  Vertical := False;
  BeginOffset := 0;
  EndOffset := 0;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 14;
  FontColor := 0;
end;

procedure TspDataSkinGaugeControl.LoadFromFile;
begin
  inherited;
  ProgressArea := ReadRect(IniFile, IDName, 'progressarea');
  ProgressRect := ReadRect(IniFile, IDName, 'progressrect');
  BeginOffset := IniFile.ReadInteger(IDName, 'beginoffset', 0);
  EndOffset := IniFile.ReadInteger(IDName, 'endoffset', 0);
  Vertical := ReadBoolean(IniFile, IDName, 'vertical');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
end;

procedure TspDataSkinGaugeControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'progressarea', ProgressArea);
  WriteRect(IniFile, IDName, 'progressrect', ProgressRect);
  IniFile.WriteInteger(IDName, 'beginoffset', BeginOffset);
  IniFile.WriteInteger(IDName, 'endoffset', EndOffset);
  WriteBoolean(IniFile, IDName, 'vertical', Vertical);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
end;


constructor TspDataSkinScrollBoxControl.Create(AIDName: String);
begin
  inherited;
  BGPictureIndex := -1;
end;

procedure TspDataSkinScrollBoxControl.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
end;

procedure TspDataSkinScrollBoxControl.SaveToFile(IniFile: TCustomIniFile);
begin
  inherited;
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);
end;

constructor TspDataSkinPanelControl.Create;
begin
  inherited;
  CaptionRect := NullRect;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  Alignment := taCenter;
  BGPictureIndex := -1;
end;

procedure TspDataSkinPanelControl.LoadFromFile;
begin
  inherited;
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
  CaptionRect := ReadRect(IniFile, IDName, 'captionrect');
  Alignment := ReadAlignment(IniFile, IDName, 'alignment');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  CheckImageRect := ReadRect(IniFile, IDName, 'checkimagerect');
  UnCheckImageRect := ReadRect(IniFile, IDName, 'uncheckimagerect');
end;

procedure TspDataSkinPanelControl.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);
  WriteRect(IniFile, IDName, 'captionrect', CaptionRect);
  WriteAlignment(IniFile, IDName, 'alignment', Alignment);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  WriteRect(IniFile, IDName, 'checkimagerect', CheckImageRect);
  WriteRect(IniFile, IDName, 'uncheckimagerect', UnCheckImageRect);
end;

constructor TspDataSkinExPanelControl.Create(AIDName: String);
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
end;

procedure TspDataSkinExPanelControl.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  RollHSkinRect := ReadRect(IniFile, IDName, 'rollhskinrect');
  RollVSkinRect := ReadRect(IniFile, IDName, 'rollvskinrect');
  RollLeftOffset := IniFile.ReadInteger(IDName, 'rollleftoffset', 0);
  RollRightOffset := IniFile.ReadInteger(IDName, 'rollrightoffset', 0);
  RollTopOffset := IniFile.ReadInteger(IDName, 'rolltopoffset', 0);
  RollBottomOffset := IniFile.ReadInteger(IDName, 'rollbottomoffset', 0);
  RollVCaptionRect := ReadRect(IniFile, IDName, 'rollvcaptionrect');
  RollHCaptionRect := ReadRect(IniFile, IDName, 'rollhcaptionrect');
  //
  CloseButtonRect := ReadRect(IniFile, IDName, 'closebuttonrect');
  CloseButtonActiveRect := ReadRect(IniFile, IDName, 'closebuttonactiverect');
  CloseButtonDownRect := ReadRect(IniFile, IDName, 'closebuttondownrect');
  HRollButtonRect := ReadRect(IniFile, IDName, 'hrollbuttonrect');
  HRollButtonActiveRect := ReadRect(IniFile, IDName, 'hrollbuttonactiverect');
  HRollButtonDownRect := ReadRect(IniFile, IDName, 'hrollbuttondownrect');
  HRestoreButtonRect := ReadRect(IniFile, IDName, 'hrestorebuttonrect');
  HRestoreButtonActiveRect := ReadRect(IniFile, IDName, 'hrestorebuttonactiverect');
  HRestoreButtonDownRect := ReadRect(IniFile, IDName, 'hrestorebuttondownrect');

  VRollButtonRect := ReadRect(IniFile, IDName, 'vrollbuttonrect');
  VRollButtonActiveRect := ReadRect(IniFile, IDName, 'vrollbuttonactiverect');
  VRollButtonDownRect := ReadRect(IniFile, IDName, 'vrollbuttondownrect');

  VRestoreButtonRect := ReadRect(IniFile, IDName, 'vrestorebuttonrect');
  VRestoreButtonActiveRect := ReadRect(IniFile, IDName, 'vrestorebuttonactiverect');
  VRestoreButtonDownRect := ReadRect(IniFile, IDName, 'vrestorebuttondownrect');
  //
  CaptionRect := ReadRect(IniFile, IDName, 'captionrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
end;

procedure TspDataSkinExPanelControl.SaveToFile(IniFile: TCustomIniFile);
begin
  inherited;
  WriteRect(IniFile, IDName, 'rollhskinrect', RollHSkinRect);
  WriteRect(IniFile, IDName, 'rollvskinrect', RollVSkinRect);
  IniFile.WriteInteger(IDName, 'rollleftoffset', RollLeftOffset);
  IniFile.WriteInteger(IDName, 'rollrightoffset', RollRightOffset);
  IniFile.WriteInteger(IDName, 'rolltopoffset', RollTopOffset);
  IniFile.WriteInteger(IDName, 'rollbottomoffset', RollBottomOffset);
  WriteRect(IniFile, IDName, 'rollvcaptionrect', RollVCaptionRect);
  WriteRect(IniFile, IDName, 'rollhcaptionrect', RollHCaptionRect);
  //
  WriteRect(IniFile, IDName, 'closebuttonrect', CloseButtonRect);
  WriteRect(IniFile, IDName, 'closebuttonactiverect', CloseButtonActiveRect);
  WriteRect(IniFile, IDName, 'closebuttondownrect', CloseButtonDownRect);
  WriteRect(IniFile, IDName, 'hrollbuttonrect', HRollButtonRect);
  WriteRect(IniFile, IDName, 'hrollbuttonactiverect', HRollButtonActiveRect);
  WriteRect(IniFile, IDName, 'hrollbuttondownrect', HRollButtonDownRect);
  WriteRect(IniFile, IDName, 'hrestorebuttonrect', HRestoreButtonRect);
  WriteRect(IniFile, IDName, 'hrestorebuttonactiverect', HRestoreButtonActiveRect);
  WriteRect(IniFile, IDName, 'hrestorebuttondownrect', HRestoreButtonDownRect);
  WriteRect(IniFile, IDName, 'vrollbuttonrect', VRollButtonRect);
  WriteRect(IniFile, IDName, 'vrollbuttonactiverect', VRollButtonActiveRect);
  WriteRect(IniFile, IDName, 'vrollbuttondownrect', VRollButtonDownRect);
  WriteRect(IniFile, IDName, 'vrestorebuttonrect', VRestoreButtonRect);
  WriteRect(IniFile, IDName, 'vrestorebuttonactiverect', VRestoreButtonActiveRect);
  WriteRect(IniFile, IDName, 'vrestorebuttondownrect', VRestoreButtonDownRect);
  //
  WriteRect(IniFile, IDName, 'captionrect', CaptionRect);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
end;

constructor TspDataSkinCheckRadioControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
  FontColor := 0;
  CheckImageArea := NullRect;
  TextArea := NullRect;
  ActiveSkinRect := NullRect;
  CheckImageRect := NullRect;
  UnCheckImageRect := NullRect;
  MorphKind := mkDefault;
end;

procedure TspDataSkinCheckRadioControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  UnEnabledFontColor := IniFile.ReadInteger(IDName, 'unenabledfontcolor', 0);
  FrameFontColor := IniFile.ReadInteger(IDName, 'framefontcolor', 0);
  Morphing := ReadBoolean(IniFile, IDName, 'morphing');
  MorphKind := ReadMorphKind(IniFile, IDName, 'morphkind');
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  CheckImageArea := ReadRect(IniFile, IDName, 'checkimagearea');
  TextArea := ReadRect(IniFile, IDName, 'textarea');
  CheckImageRect := ReadRect(IniFile, IDName, 'checkimagerect');
  UnCheckImageRect := ReadRect(IniFile, IDName, 'uncheckimagerect');
  ActiveCheckImageRect := ReadRect(IniFile, IDName, 'activecheckimagerect');
  ActiveUnCheckImageRect := ReadRect(IniFile, IDName, 'activeuncheckimagerect');
  UnEnabledCheckImageRect := ReadRect(IniFile, IDName, 'unenabledcheckimagerect');
  UnEnabledUnCheckImageRect := ReadRect(IniFile, IDName, 'unenableduncheckimagerect');
end;

procedure TspDataSkinCheckRadioControl.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'unenabledfontcolor', UnEnabledFontColor);
  IniFile.WriteInteger(IDName, 'framefontcolor', FrameFontColor);
  WriteBoolean(IniFile, IDName, 'morphing', Morphing);
  WriteMorphKind(IniFile, IDName, 'morphkind', MorphKind);
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  WriteRect(IniFile, IDName, 'checkimagearea', CheckImageArea);
  WriteRect(IniFile, IDName, 'textarea', TextArea);
  WriteRect(IniFile, IDName, 'checkimagerect', CheckImageRect);
  WriteRect(IniFile, IDName, 'uncheckimagerect', UnCheckImageRect);
  WriteRect(IniFile, IDName, 'activecheckimagerect', ActiveCheckImageRect);
  WriteRect(IniFile, IDName, 'activeuncheckimagerect', ActiveUnCheckImageRect);
  WriteRect(IniFile, IDName, 'unenabledcheckimagerect', UnEnabledCheckImageRect);
  WriteRect(IniFile, IDName, 'unenableduncheckimagerect', UnEnabledUnCheckImageRect);
end;

constructor TspDataSkinMenuButtonControl.Create;
begin
  inherited;
end;

procedure TspDataSkinMenuButtonControl.LoadFromFile;
begin
  inherited;
  TrackButtonRect := ReadRect(IniFile, IDName, 'trackbuttonrect');
end;

procedure TspDataSkinMenuButtonControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'trackbuttonrect', TrackButtonRect);
end;

constructor TspDataSkinButtonControl.Create;
begin
  inherited;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
  DownFontColor := 0;
  FontColor := 0;
  ActiveSkinRect := NullRect;
  DownSkinRect := NullRect;
  MorphKind := mkDefault;
end;

procedure TspDataSkinButtonControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DisabledFontColor := IniFile.ReadInteger(IDName, 'disabledfontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  Morphing := ReadBoolean(IniFile, IDName, 'morphing');
  MorphKind := ReadMorphKind(IniFile, IDName, 'morphkind');
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  DownSkinRect := ReadRect(IniFile, IDName, 'downskinrect');
  DisabledSkinRect := ReadRect(IniFile, IDName, 'disabledskinrect');
end;

procedure TspDataSkinButtonControl.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'downfontcolor', DownFontColor);
  IniFile.WriteInteger(IDName, 'disabledfontcolor',   DisabledFontColor);
  WriteBoolean(IniFile, IDName, 'morphing', Morphing);
  WriteMorphKind(IniFile, IDName, 'morphkind', MorphKind);
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  WriteRect(IniFile, IDName, 'downskinrect', DownSkinRect);
  WriteRect(IniFile, IDName, 'disabledskinrect', DisabledSkinRect);
end;

constructor TspDataSkinArea.Create(AIDName: String; ARect: TRect);
begin
  IDName := AIDName;
  AreaRect := ARect;
end;

constructor TspDataSkinObject.Create;
begin
  IDName := AIDName;
  Hint := '';
  ActivePictureIndex := -1;
  SkinRect := NullRect;
  ActiveSkinRect := SkinRect;
  InActiveSkinRect := SkinRect;
  Morphing := False;
  CursorIndex := -1;
  RollUp := False;
end;

procedure TspDataSkinObject.LoadFromFile;
begin
  Hint := IniFile.ReadString(IDName, 'hint', '');
  RollUp := ReadBoolean(IniFile, IDName, 'rollup');
  ActivePictureIndex := IniFile.ReadInteger(IDName, 'activepictureindex', -1);
  SkinRectInAPicture := ReadBoolean(IniFile, IDName, 'skinrectinapicture');
  CursorIndex := IniFile.ReadInteger(IDName, 'cursorindex', -1);
  SkinRect := ReadRect(IniFile, IDName, 'skinrect');
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  InActiveSkinRect := ReadRect(IniFile, IDName, 'inactiveskinrect');
  Morphing := ReadBoolean(IniFile, IDName, 'morphing');
  MorphKind := ReadMorphKind(IniFile, IDName, 'morphkind');
end;

procedure TspDataSkinObject.SaveToFile;
begin
  IniFile.EraseSection(IDName);
  IniFile.WriteString(IDName, 'hint', Hint);
  WriteBoolean(IniFile, IDName, 'rollup',  RollUp);
  IniFile.WriteInteger(IDName, 'activepictureindex', ActivePictureIndex);
  WriteBoolean(IniFile, IDName, 'skinrectinapicture', SkinRectInAPicture);
  IniFile.WriteInteger(IDName, 'cursorindex', CursorIndex);
  WriteRect(IniFile, IDName, 'skinrect', SkinRect);
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  WriteRect(IniFile, IDName, 'inactiveskinrect', InActiveSkinRect);
  WriteBoolean(IniFile, IDName, 'morphing', Morphing);
  WriteMorphKind(IniFile, IDName, 'morphkind', MorphKind);
end;

procedure TspDataUserObject.LoadFromFile;
begin
  RollUp := ReadBoolean(IniFile, IDName, 'rollup');
  SkinRect := ReadRect(IniFile, IDName, 'skinrect');
  CursorIndex := IniFile.ReadInteger(IDName, 'cursorindex', -1);
end;

procedure TspDataUserObject.SaveToFile;
begin
  IniFile.EraseSection(IDName);
  WriteBoolean(IniFile, IDName, 'rollup',  RollUp);
  WriteRect(IniFile, IDName, 'skinrect', SkinRect);
  IniFile.WriteInteger(IDName, 'cursorindex', CursorIndex);
end;


procedure TspDataSkinFrameGaugeObject.LoadFromFile;
var
  S: String;
begin
  inherited;
  MinValue := IniFile.ReadInteger(IDName, 'minvalue', 0);
  MaxValue := IniFile.ReadInteger(IDName, 'maxvalue', 0);
  CountFrames := IniFile.ReadInteger(IDName, 'countframes', 0);
  S := IniFile.ReadString(IDName, 'framesplacement', 'fphorizontal');
  if S = 'fphorizontal'
  then FramesPlacement := fpHorizontal
  else FramesPlacement := fpVertical;
end;

procedure TspDataSkinFrameGaugeObject.SaveToFile;
var
  S: String;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'minvalue', MinValue);
  IniFile.WriteInteger(IDName, 'maxvalue', MaxValue);
  IniFile.WriteInteger(IDName, 'countframes', CountFrames);
  if FramesPlacement = fpHorizontal
  then S := 'fphorizontal'
  else S := 'fpvertical';
  IniFile.WriteString(IDName, 'framesplacement', S);
end;

procedure TspDataSkinFrameRegulatorObject.LoadFromFile;
var
  S: String;
begin
  inherited;
  MinValue := IniFile.ReadInteger(IDName, 'minvalue', 0);
  MaxValue := IniFile.ReadInteger(IDName, 'maxvalue', 0);
  CountFrames := IniFile.ReadInteger(IDName, 'countframes', 0);
  S := IniFile.ReadString(IDName, 'framesplacement', 'fphorizontal');
  if S = 'fphorizontal'
  then FramesPlacement := fpHorizontal
  else FramesPlacement := fpVertical;
  S := IniFile.ReadString(IDName, 'kind', 'rkround');
  if S = 'rkround'
  then Kind := rkRound
  else
  if S = 'rkhorizontal'
  then Kind := rkHorizontal
  else Kind := rkVertical;
end;

procedure TspDataSkinFrameRegulatorObject.SaveToFile;
var
  S: String;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'minvalue', MinValue);
  IniFile.WriteInteger(IDName, 'maxvalue', MaxValue);
  IniFile.WriteInteger(IDName, 'countframes', CountFrames);
  if FramesPlacement = fpHorizontal
  then S := 'fphorizontal'
  else S := 'fpvertical';
  IniFile.WriteString(IDName, 'framesplacement', S);
  case Kind of
    rkRound: S := 'rkround';
    rkVertical: S := 'rkvertical';
    rkHorizontal: S := 'rkhorizontal';
  end;
  IniFile.WriteString(IDName, 'kind', S);
end;

procedure TspDataSkinGauge.LoadFromFile;
var
  S: String;
begin
  inherited;
  MinValue := IniFile.ReadInteger(IDName, 'minvalue', 0);
  MaxValue := IniFile.ReadInteger(IDName, 'maxvalue', 0);
  S := IniFile.ReadString(IDName, 'kind', 'gkhorizontal');
  if S = 'gkhorizontal' then Kind := gkHorizontal else Kind := gkVertical;
end;

procedure TspDataSkinGauge.SaveToFile;
var
  S: String;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'minvalue', MinValue);
  IniFile.WriteInteger(IDName, 'maxvalue', MaxValue);
  if Kind = gkHorizontal then S := 'gkhorizontal' else S := 'gkvertical';
  IniFile.WriteString(IDName, 'kind', S);
end;

procedure TspDataSkinTrackBar.LoadFromFile;
begin
  inherited;
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  BeginPoint := ReadPoint(IniFile, IDName, 'beginpoint');
  EndPoint := ReadPoint(IniFile, IDName, 'endpoint');
  MinValue := IniFile.ReadInteger(IDName, 'minvalue', 0);
  MaxValue := IniFile.ReadInteger(IDName, 'maxvalue', 0);
  MouseDownChangeValue := ReadBoolean(IniFile, IDName, 'mousedownchangevalue');
  Morphing := False;
end;

procedure TspDataSkinTrackBar.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WritePoint(IniFile, IDName, 'beginpoint', BeginPoint);
  WritePoint(IniFile, IDName, 'endpoint', EndPoint);
  IniFile.WriteInteger(IDName, 'minvalue', MinValue);
  IniFile.WriteInteger(IDName, 'maxvalue', MaxValue);
  WriteBoolean(IniFile, IDName, 'mousedownchangevalue', MouseDownChangeValue);
end;

procedure TspDataSkinAnimate.LoadFromFile;
var
  S: String;
begin
  inherited;
  Morphing := False;
  CountFrames := IniFile.ReadInteger(IDName, 'countframes', 1);
  Cycle := ReadBoolean(IniFile, IDName, 'cycle');
  ButtonStyle := ReadBoolean(IniFile, IDName, 'buttonstyle');
  TimerInterval := IniFile.ReadInteger(IDName, 'timerinterval', 50);
  S := IniFile.ReadString(IDName, 'command', 'cmdefault');
  if S = 'cmclose' then Command := cmClose else
  if S = 'cmmaximize' then Command := cmMaximize else
  if S = 'cmminimize' then Command := cmMinimize else
  if S = 'cmsysmenu' then Command := cmSysMenu else
  if S = 'cmdefault' then Command := cmDefault else
  if S = 'cmrollup' then Command := cmRollUp else
  Command := cmMinimizeToTray;
end;

procedure TspDataSkinAnimate.SaveToFile;
var
  S: String;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'countframes', CountFrames);
  WriteBoolean(IniFile, IDName, 'cycle', Cycle);
  WriteBoolean(IniFile, IDName, 'buttonstyle', ButtonStyle);
  IniFile.WriteInteger(IDName, 'timerinterval', TimerInterval);
  if Command = cmClose then S := 'cmclose' else
  if Command = cmMaximize then S := 'cmmaximize' else
  if Command = cmMinimize then S := 'cmminimize' else
  if Command = cmSysMenu then S := 'cmsysmenu' else
  if Command = cmDefault then S := 'cmdefault' else
  if Command = cmRollUp then S := 'cmrollup' else
  S := 'cmminimizetotray';
  IniFile.WriteString(IDName, 'command', S);
end;


constructor TspDataSkinPopupWindow.Create;
begin
  inherited;
  WindowPictureIndex := -1;
  MaskPictureIndex := -1;
  LTPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  CursorIndex := -1;
  ScrollMarkerColor := 0;
  ScrollMarkerActiveColor := 0;
  TopStretch := False;
  LeftStretch := False;
  RightStretch := False;
  BottomStretch := False;
end;

procedure TspDataSkinPopupWindow.LoadFromFile;
begin
  WindowPictureIndex := IniFile.ReadInteger(
    'POPUPWINDOW', 'windowpictureindex', -1);
  MaskPictureIndex := IniFile.ReadInteger(
    'POPUPWINDOW', 'maskpictureindex', -1);
  LTPoint := ReadPoint(IniFile, 'POPUPWINDOW', 'lefttoppoint');
  RTPoint := Readpoint(IniFile, 'POPUPWINDOW', 'righttoppoint');
  LBPoint := ReadPoint(IniFile, 'POPUPWINDOW', 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, 'POPUPWINDOW', 'rightbottompoint');
  CursorIndex := IniFile.ReadInteger('POPUPWINDOW', 'cursorindex', -1);
  ItemsRect := ReadRect(IniFile, 'POPUPWINDOW', 'itemsrect');
  ScrollMarkerColor := IniFile.ReadInteger('POPUPWINDOW', 'scrollmarkercolor', 0);
  ScrollMarkerActiveColor := IniFile.ReadInteger('POPUPWINDOW', 'scrollmarkeractivecolor', 0);
  LeftStretch := ReadBoolean(IniFile, 'POPUPWINDOW', 'leftstretch');
  RightStretch := ReadBoolean(IniFile, 'POPUPWINDOW', 'rightstretch');
  TopStretch := ReadBoolean(IniFile, 'POPUPWINDOW', 'topstretch');
  BottomStretch := ReadBoolean(IniFile, 'POPUPWINDOW', 'bottomstretch');
end;

procedure TspDataSkinPopupWindow.SaveToFile;
begin
  IniFile.EraseSection('POPUPWINDOW');
  IniFile.WriteInteger('POPUPWINDOW', 'windowpictureindex',
    WindowPictureIndex);
  IniFile.WriteInteger( 'POPUPWINDOW', 'maskpictureindex',
    MaskPictureIndex);
  WritePoint(IniFile, 'POPUPWINDOW', 'lefttoppoint', LTPoint);
  WritePoint(IniFile, 'POPUPWINDOW', 'righttoppoint', RTPoint);
  WritePoint(IniFile, 'POPUPWINDOW', 'leftbottompoint', LBPoint);
  WritePoint(IniFile, 'POPUPWINDOW', 'rightbottompoint', RBPoint);
  WriteRect(IniFile, 'POPUPWINDOW', 'itemsrect', ItemsRect);
  IniFile.WriteInteger('POPUPWINDOW', 'cursorindex', CursorIndex);
  IniFile.WriteInteger('POPUPWINDOW', 'scrollmarkercolor', ScrollMarkerColor);
  IniFile.WriteInteger('POPUPWINDOW', 'scrollmarkeractivecolor', ScrollMarkerActiveColor);
  WriteBoolean(IniFile, 'POPUPWINDOW', 'leftstretch', LeftStretch);
  WriteBoolean(IniFile, 'POPUPWINDOW', 'rightstretch', RightStretch);
  WriteBoolean(IniFile, 'POPUPWINDOW', 'topstretch', TopStretch);
  WriteBoolean(IniFile, 'POPUPWINDOW', 'bottomstretch', BottomStretch);
end;

constructor TspDataSkinHintWindow.Create;
begin
  inherited;
  WindowPictureIndex := -1;
  MaskPictureIndex := -1;
  LTPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  ClRect := NullRect;
  FontName := 'Arial';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  TopStretch := False;
  LeftStretch := False;
  RightStretch := False;
  BottomStretch := False;
end;

procedure TspDataSkinHintWindow.LoadFromFile;
begin
  WindowPictureIndex := IniFile.ReadInteger(
    'HINTWINDOW', 'windowpictureindex', -1);
  MaskPictureIndex := IniFile.ReadInteger(
    'HINTWINDOW', 'maskpictureindex', -1);
  LTPoint := ReadPoint(IniFile, 'HINTWINDOW', 'lefttoppoint');
  RTPoint := Readpoint(IniFile, 'HINTWINDOW', 'righttoppoint');
  LBPoint := ReadPoint(IniFile, 'HINTWINDOW', 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, 'HINTWINDOW', 'rightbottompoint');
  ClRect := ReadRect(IniFile, 'HINTWINDOW', 'clientrect');
  FontName := IniFile.ReadString('HINTWINDOW', 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger('HINTWINDOW', 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, 'HINTWINDOW', 'fontstyle');
  FontColor := IniFile.ReadInteger('HINTWINDOW', 'fontcolor', 0);
  LeftStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'leftstretch');
  RightStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'rightstretch');
  TopStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'topstretch');
  BottomStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'bottomstretch');
end;

procedure TspDataSkinHintWindow.SaveToFile;
begin
  IniFile.EraseSection('HINTWINDOW');
  IniFile.WriteInteger('HINTWINDOW', 'windowpictureindex',
    WindowPictureIndex);
  IniFile.WriteInteger( 'HINTWINDOW', 'maskpictureindex',
    MaskPictureIndex);
  WritePoint(IniFile, 'HINTWINDOW', 'lefttoppoint', LTPoint);
  WritePoint(IniFile, 'HINTWINDOW', 'righttoppoint', RTPoint);
  WritePoint(IniFile, 'HINTWINDOW', 'leftbottompoint', LBPoint);
  WritePoint(IniFile, 'HINTWINDOW', 'rightbottompoint', RBPoint);
  WriteRect(IniFile, 'HINTWINDOW', 'clientrect', ClRect);
  IniFile.WriteString('HINTWINDOW', 'fontname', FontName);
  IniFile.WriteInteger('HINTWINDOW', 'fontheight', FontHeight);
  WriteFontStyles(IniFile, 'HINTWINDOW', 'fontstyle', FontStyle);
  IniFile.WriteInteger('HINTWINDOW', 'fontcolor', FontColor);
  WriteBoolean(IniFile, 'HINTWINDOW', 'leftstretch', LeftStretch);
  WriteBoolean(IniFile, 'HINTWINDOW', 'rightstretch', RightStretch);
  WriteBoolean(IniFile, 'HINTWINDOW', 'topstretch', TopStretch);
  WriteBoolean(IniFile, 'HINTWINDOW', 'bottomstretch', BottomStretch);
end;

procedure TspDataSkinMenuItem.LoadFromFile;
begin
  inherited;
  ItemLO := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRO := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  DividerRect := ReadRect(IniFile, IDName, 'dividerrect');
  DividerLO := IniFile.ReadInteger(IDName, 'dividerleftoffset', 0);
  DividerRO := IniFile.ReadInteger(IDName, 'dividerrightoffset', 0);
  TextRct := ReadRect(IniFile, IDName, 'textrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  UnEnabledFontColor := IniFile.ReadInteger(IDName, 'unenabledfontcolor', 0);
end;

procedure TspDataSkinMenuItem.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'itemleftoffset', ItemLO);
  IniFile.WriteInteger(IDName, 'itemrightoffset', ItemRO);
  WriteRect(IniFile, IDName, 'dividerrect', DividerRect);
  IniFile.WriteInteger(IDName, 'dividerleftoffset', DividerLO);
  IniFile.WriteInteger(IDName, 'dividerrightoffset', DividerRO);
  WriteRect(IniFile, IDName, 'textrect', TextRct);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'unenabledfontcolor', UnEnabledFontColor);
end;

procedure TspDataSkinMainMenuItem.LoadFromFile;
begin
  inherited;
  ItemLO := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRO := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  DownRect := ReadRect(IniFile, IDName, 'downrect');
  TextRct := ReadRect(IniFile, IDName, 'textrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  UnEnabledFontColor := IniFile.ReadInteger(IDName, 'unenabledfontColor', 0);
end;

procedure TspDataSkinMainMenuItem.SaveToFile;
begin
  inherited;
  IniFile.WriteInteger(IDName, 'itemleftoffset', ItemLO);
  IniFile.WriteInteger(IDName, 'itemrightoffset', ItemRO);
  WriteRect(IniFile, IDName, 'downrect', DownRect);
  WriteRect(IniFile, IDName, 'textrect', TextRct);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'downfontcolor', DownFontColor);
  IniFile.WriteInteger(IDName, 'unenabledfontColor', UnEnabledFontColor);
end;

constructor TspDataSkinButton.Create(AIDName: String);
begin
  inherited;
  GroupIndex := -1;
  DownRect := NullRect;

end;

procedure TspDataSkinButton.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'downrect', DownRect);
  WriteRect(IniFile, IDName, 'disableskinrsect', DisableSkinRect);
  IniFile.WriteInteger(IDName, 'groupindex', GroupIndex);
end;

procedure TspDataSkinButton.LoadFromFile;
begin
  inherited;
  DownRect := ReadRect(IniFile, IDName, 'downrect');
  DisableSkinRect := ReadRect(IniFile, IDName, 'disableskinrsect');
  GroupIndex := IniFile.ReadInteger(IDName, 'groupindex', -1);
end;

procedure TspDataSkinStdButton.LoadFromFile;
var
  S: String;
begin
  inherited;
  S := IniFile.ReadString(IDName, 'command', 'cmdefault');
  if S = 'cmclose' then Command := cmClose else
  if S = 'cmmaximize' then Command := cmMaximize else
  if S = 'cmminimize' then Command := cmMinimize else
  if S = 'cmsysmenu' then Command := cmSysMenu else
  if S = 'cmdefault' then Command := cmDefault else
  if S = 'cmrollup' then Command := cmRollUp else
  Command := cmMinimizeToTray;
  RestoreRect := ReadRect(IniFile, IDName, 'restorerect');
  RestoreActiveRect := ReadRect(IniFile, IDName, 'restoreactiverect');
  RestoreDownRect := ReadRect(IniFile, IDName, 'restoredownrect');
end;

procedure TspDataSkinStdButton.SaveToFile;
var
  S: String;
begin
  inherited;
  if Command = cmClose then S := 'cmclose' else
  if Command = cmMaximize then S := 'cmmaximize' else
  if Command = cmMinimize then S := 'cmminimize' else
  if Command = cmSysMenu then S := 'cmsysmenu' else
  if Command = cmDefault then S := 'cmdefault' else
  if Command = cmRollUp then S := 'cmrollup' else
  S := 'cmminimizetotray';
  IniFile.WriteString(IDName, 'command', S);
  WriteRect(IniFile, IDName, 'restorerect', RestoreRect);
  WriteRect(IniFile, IDName, 'restoreactiverect', RestoreActiveRect);
  WriteRect(IniFile, IDName, 'restoredownrect', RestoreDownRect);
end;

constructor TspDataSkinBitLabel.Create;
begin
  inherited;
  TextValue := '';
  Symbols := TStringList.Create;
  SymbolWidth := 0;
  SymbolHeight := 0;
end;

destructor TspDataSkinBitLabel.Destroy;
begin
  Symbols.Clear;
  Symbols.Free;
  inherited;
end;

procedure TspDataSkinBitLabel.LoadFromFile;
begin
  inherited;
  Morphing := False;
  TextValue := IniFile.ReadString(IDName, 'textvalue', '');
  SymbolWidth := IniFile.ReadInteger(IDName, 'symbolwidth', 0);
  SymbolHeight := IniFile.ReadInteger(IDName, 'symbolheight', 0);
  ReadStrings(IniFile, IDName, 'symbols', Symbols);
end;

procedure TspDataSkinBitLabel.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'textvalue', TextValue);
  IniFile.WriteInteger(IDName, 'symbolwidth', SymbolWidth);
  IniFile.WriteInteger(IDName, 'symbolheight', SymbolHeight);
  WriteStrings(IniFile, IDName, 'symbols', Symbols);
end;

procedure TspDataSkinLabel.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontName', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  Alignment := ReadAlignment(IniFile, IDName, 'alignment');
  TextValue := IniFile.ReadString(IDName, 'textvalue', '');
end;

procedure TspDataSkinLabel.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  WriteAlignment(IniFile, IDName, 'alignment', Alignment);
  IniFile.WriteString(IDName, 'textvalue', TextValue);
end;

procedure TspDataSkinCaption.SaveToFile;
begin
  inherited;
  WriteBoolean(IniFile, IDName, 'defaultcaption', DefaultCaption);
  WriteRect(IniFile, IDName, 'textrect', TextRct);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  WriteAlignment(IniFile, IDName, 'alignment', Alignment);
  WriteBoolean(IniFile, IDName, 'shadow', Shadow);
  IniFile.WriteInteger(IDName, 'shadowcolor', ShadowColor);
  IniFile.WriteInteger(IDName, 'activeshadowcolor', ActiveShadowColor);
  WriteRect(IniFile, IDName, 'framerect', FrameRect);
  WriteRect(IniFile, IDName, 'activeframerect', ActiveFrameRect);
  WriteRect(IniFile, IDName, 'frametextrect', FrameTextRect);
  IniFile.WriteInteger(IDName, 'frameleftoffset', FrameLeftOffset);
  IniFile.WriteInteger(IDName, 'framerightoffset', FrameRightOffset);
end;

procedure TspDataSkinCaption.LoadFromFile;
begin
  inherited;
  DefaultCaption := ReadBoolean(IniFile, IDName, 'defaultcaption');
  TextRct := ReadRect(IniFile, IDName, 'textrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Arial');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 14);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  Alignment := ReadAlignment(IniFile, IDName, 'alignment');
  Shadow := ReadBoolean(IniFile, IDName, 'shadow');
  ShadowColor := IniFile.ReadInteger(IDName, 'shadowcolor', 0);
  ActiveShadowColor := IniFile.ReadInteger(IDName, 'activeshadowcolor', 0);
  FrameRect := ReadRect(IniFile, IDName, 'framerect');
  ActiveFrameRect := ReadRect(IniFile, IDName, 'activeframerect');
  FrameTextRect := ReadRect(IniFile, IDName, 'frametextrect');
  FrameLeftOffset := IniFile.ReadInteger(IDName, 'frameleftoffset', 0);
  FrameRightOffset := IniFile.ReadInteger(IDName, 'framerightoffset', 0);
end;

constructor TspSkinData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ObjectList := TList.Create;
  CtrlList := TList.Create;
  AreaList := TList.Create;
  FActivePictures := TList.Create;
  FPicture := TBitMap.Create;
  FInActivePicture := TBitMap.Create;
  FMask := TBitMap.Create;
  FRollUpPicture := TBitMap.Create;
  FRollUpMask := TBitMap.Create;
  FPictureName := '';
  FInActivePictureName := '';
  FMaskName := '';
  FRollUpPictureName := '';
  FRollUpMaskName := '';
  FActivePicturesNames := TStringList.Create;
  FCursorsNames := TStringList.Create;
  SkinName := '';
  Empty := True;
  PopupWindow := TspDataSkinPopupWindow.Create;
  HintWindow := TspDataSkinHintWindow.Create;
  MainMenuPopupUp := False;
  BuildMode := False;
  StartCursorIndex := 1;
  CursorIndex := -1;
  BGPictureIndex := -1;
  MDIBGPictureIndex := -1;
end;

destructor TspSkinData.Destroy;
begin
  Empty := True;
  ClearObjects;
  ObjectList.Free;
  CtrlList.Free;
  AreaList.Free;
  FActivePictures.Free;
  FPicture.Free;
  FInActivePicture.Free;
  FMask.Free;
  FRollUpPicture.Free;
  FRollUpMask.Free;
  FActivePicturesNames.Free;
  FCursorsNames.Free;
  PopupWindow.Free;
  HintWindow.Free;
  inherited Destroy;
end;

procedure TspSkinData.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FCompressedStoredSkin)
  then FCompressedStoredSkin := nil;
  if (Operation = opRemove) and (AComponent = FResourceStrData)
  then FResourceStrData := nil;
end;

procedure TspSkinData.SetResourceStrData;
begin
  FResourceStrData := Value;
  if not (csDesigning in ComponentState)
  then
    begin
      SendSkinDataMessage(WM_CHANGERESSTRDATA);
    end
end;

procedure TspSkinData.StoreToDisk(APath: String);
var
  I: Integer;
begin
  SaveToFile(APath + 'skin.ini');
  if not FPicture.Empty
  then
    FPicture.SaveToFile(APath + Self.FPictureName);
  if not FInActivePicture.Empty
  then
    FInActivePicture.SaveToFile(APath + Self.FInActivePictureName);
  if not FMask.Empty
  then
    FMask.SaveToFile(APath + Self.FMaskName);
  if not FRollUpPicture.Empty
  then
    FRollUpPicture.SaveToFile(APath + Self.FRollUpPictureName);
  if not FRollUpMask.Empty
  then
    FRollUpMask.SaveToFile(APath + Self.FRollUpMaskName);
  if FActivePicturesNames.Count > 0
  then
    for I := 0 to FActivePictures.Count - 1 do
    begin
      TBitMap(FActivePictures.Items[I]).SaveToFile(APath + FActivePicturesNames[I]);
    end;
end;

procedure TspSkinData.SaveToCompressedFile(FileName: String);
var
  CSS: TspCompressedStoredSkin;
begin
  CSS := TspCompressedStoredSkin.Create(Self);
  CSS.LoadFromSkinData(Self);
  CSS.SaveToCompressFile(FileName);
  CSS.Free;
end;

procedure TspSkinData.LoadFromCompressedFile(FileName: String);
var
  CSS: TspCompressedStoredSkin;
begin
  CSS := TspCompressedStoredSkin.Create(Self);
  CSS.LoadFromCompressFile(FileName);
  if not CSS.Empty
  then
    Self.LoadCompressedStoredSkin(CSS);
  CSS.Free;
end;

procedure TspSkinData.SetCompressedStoredSkin;
begin
  FCompressedStoredSkin := Value;
  if not (csDesigning in ComponentState) and (FCompressedStoredSkin <> nil)
  then
    LoadCompressedStoredSkin(FCompressedStoredSkin);
end;

procedure TspSkinData.SendSkinDataMessage;
var
  i: Integer;
  F: TForm;
begin
  if (Owner is TForm)
  then
    begin
      F := TForm(Owner);
      SendMessage(F.Handle, M, Integer(Self), 1000);
    end
  else
    F := nil;

  with Screen do
   for i := 0 to FormCount - 1 do
     if (Forms[i] <> F) or (F = nil)
     then
       SendMessage(Forms[i].Handle, M, Integer(Self), 1000);
end;


function TspSkinData.GetAreaIndex;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to AreaList.Count - 1 do
  begin
    if AIDName = TspDataSkinArea(AreaList.Items[i]).IDName
    then
      begin
        Result := i;
        Break;
      end;
  end;
end;  

function TspSkinData.GetIndex;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to ObjectList.Count - 1 do
  begin
    if AIDName = TspDataSkinObject(ObjectList.Items[i]).IDName
    then
      begin
        Result := i;
        Break;
      end;
  end;
end;

function TspSkinData.GetControlIndex;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to CtrlList.Count - 1 do
  begin
    if AIDName = TspDataSkinControl(CtrlList.Items[i]).IDName
    then
      begin
        Result := i;
        Break;
      end;
  end;
end;

procedure TspSkinData.ClearObjects;
var
  i: Integer;
begin
  for i := 0 to AreaList.Count - 1 do
    TspDataSkinArea(AreaList.Items[i]).Free;
  AreaList.Clear;
  for i := 0 to ObjectList.Count - 1 do
    TspDataSkinObject(ObjectList.Items[i]).Free;
  ObjectList.Clear;
  for i := 0 to CtrlList.Count - 1 do
    TspDataSkinControl(CtrlList.Items[i]).Free;
  CtrlList.Clear;
  for i := 0 to FActivePictures.Count - 1 do
    TBitMap(FActivePictures.Items[i]).Free;
  PopupWindow.WindowPictureIndex := -1;
  HintWindow.WindowPictureIndex := -1;
  FCursorsNames.Clear;
  FActivePictures.Clear;
  FActivePicturesNames.Clear;
  FCursorsNames.Clear;
end;

procedure TspSkinData.ClearAll;
begin
  ClearObjects;
  FPicture.Assign(nil);
  FInActivePicture.Assign(nil);
  FMask.Assign(nil);
  FRollUpPicture.Assign(nil);
  FRollUpMask.Assign(nil);
  FPictureName := '';
  FInActivePictureName := '';
  FMaskName := '';
  FRollUpPictureName := '';
  FRollUpMaskName := '';
  Empty := True;
end;

const
  symbols = ',: ';

procedure TspSkinData.GetObjectTypeName(S: String; var AName, AType: String);
var
  i, j: Integer;
begin
  AName := '';
  AType := '';
  j := 0;
  for i := 1 to Length(S) do
    if S[i] = ':'
    then
      begin
        j := i;
        Break;
      end;
  if j <> 0
  then
    begin
      AName := Copy(S, 1, j - 1);
      AType := Copy(S, j + 1, Length(S) - j);
    end;  
end;

procedure TspSkinData.GetAreaNameRect(S: String; var AName: String; var ARect: TRect);
var
  i, j: Integer;
  ARectStr: String;
begin
  AName := '';
  ARectStr := '';
  j := 0;
  for i := 1 to Length(S) do
    if S[i] = ':'
    then
      begin
        j := i;
        Break;
      end;
  if j <> 0
  then
    begin
      AName := Copy(S, 1, j - 1);
      ARectStr := Copy(S, j + 1, Length(S) - j);
      ARect := GetRect(ARectStr);
    end;
end;

procedure TspSkinData.AddSkinArea;
begin
  AreaList.Add(TspDataSkinArea.Create(AName, ARect));
end;

procedure TspSkinData.WriteAreas(F: TCustomIniFile);
var
  S: String;
  i: Integer;
begin
  F.EraseSection('SKINAREAS');
  F.WriteInteger('SKINAREAS', 'count', AreaList.Count);
  for i := 0 to AreaList.Count - 1 do
  with TspDataSkinArea(AreaList.Items[i]) do
  begin
    S := IDName + ':' + SetRect(AreaRect);
    F.WriteString('SKINAREAS', IntToStr(i), S);
  end;
end;

procedure TspSkinData.ReadAreas(F: TCustomIniFile);
var
  i, Count: Integer;
  S, FName: String;
  FRect: TRect;
begin
  Count := F.ReadInteger('SKINAREAS', 'count', 0);
  for i := 0 to Count - 1 do
  begin
    S := F.ReadString('SKINAREAS', IntToStr(i), '');
    GetAreaNameRect(S, FName, FRect);
    AddSkinArea(FName, FRect);
  end;
end;

procedure TspSkinData.WriteObjects;
var
  i: Integer;
  S: String;
begin
  F.EraseSection('SKINOBJECTS');
  F.WriteInteger('SKINOBJECTS', 'count', ObjectList.Count);
  for i := 0 to ObjectList.Count - 1 do
  begin
    S := TspDataSkinObject(ObjectList.Items[i]).IDName + ':';
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMenuItem
    then S := S + 'menuitem' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMainMenuBarItem
    then S := S + 'mainmenubaritem' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMainMenuItem
    then S := S + 'mainmenuitem' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMainMenuBarButton
    then S := S + 'mainmenubarbutton' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinStdButton
    then S := S + 'stdbutton' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinButton
    then S := S + 'button' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaption
    then S := S + 'caption' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinTrackBar
    then S := S + 'trackbar' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinGauge
    then S := S + 'gauge' else
     if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinFrameGaugeObject
    then S := S + 'framegauge' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinFrameRegulatorObject
    then S := S + 'frameregulator' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinLabel
    then S := S + 'label' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinBitLabel
    then S := S + 'bitlabel' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinSwitch
    then S := S + 'switch' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinAnimate
    then S := S + 'animate' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataUserObject
    then S := S + 'userobject';
    F.WriteString('SKINOBJECTS', IntToStr(i), S);
    TspDataSkinObject(ObjectList.Items[i]).SaveToFile(F);
  end;
end;

procedure TspSkinData.WriteCtrls(F: TCustomIniFile);
var
  i: Integer;
  S: String;
begin
  F.EraseSection('SKINCONTROLS');
  F.WriteInteger('SKINCONTROLS', 'count', CtrlList.Count);
  for i := 0 to CtrlList.Count - 1 do
  begin
    S := TspDataSkinControl(CtrlList.Items[i]).IDName + ':';
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinSlider
    then S := S + 'slider'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinBevel
    then S := S + 'bevel'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinPanelControl
    then S := S + 'panel'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinExPanelControl
    then S := S + 'expanel'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinMenuButtonControl
    then S := S + 'menubutton'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinButtonControl
    then S := S + 'button'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinCheckRadioControl
    then S := S + 'checkradio'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinGaugeControl
    then S := S + 'gauge'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinSplitterControl
    then S := S + 'splitter'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinTrackBarControl
    then S := S + 'trackbar'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinLabelControl
    then S := S + 'label'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinStdLabelControl
    then S := S + 'stdlabel'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinBitLabelControl
    then S := S + 'bitlabel'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinFrameRegulator
    then S := S + 'frameregulator'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinFrameGauge
    then S := S + 'framegauge'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinAnimateControl
    then S := S + 'animate'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinUpDownControl
    then S := S + 'updown'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinSwitchControl
    then S := S + 'switch'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinGridControl
    then S := S + 'grid'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinTabControl
    then S := S + 'tab'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinMainMenuBar
    then S := S + 'mainmenubar'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinControlBar
    then S := S + 'controlbar'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinMemoControl
    then S := S + 'memo'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinEditControl
    then S := S + 'edit'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinCheckListBox
    then S := S + 'checklistbox'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinListBox
    then S := S + 'listbox'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinComboBox
    then S := S + 'combobox'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinScrollBarControl
    then S := S + 'scrollbar'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinSpinEditControl
    then S := S + 'spinedit'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinScrollBoxControl
    then S := S + 'scrollbox'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinTreeView
    then S := S + 'treeview'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinListView
    then S := S + 'listview'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinresimkutusu
    then S := S + 'resimkutusu'
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinRichEdit
    then S := S + 'richedit';
    
    F.WriteString('SKINCONTROLS', IntToStr(i), S);
    TspDataSkinControl(CtrlList.Items[i]).SaveToFile(F);
  end;
end;

procedure TspSkinData.ReadCtrls(F: TCustomIniFile);
var
  i, Count: Integer;
  S, FName, FType: String;
begin
  Count := F.ReadInteger('SKINCONTROLS', 'count', 0);
  for i := 0 to Count - 1 do
  begin
    S := F.ReadString('SKINCONTROLS', IntToStr(i), '');
    GetObjectTypeName(S, FName, FType);
    if FType = 'slider'
    then CtrlList.Add(TspDataSkinSlider.Create(FName))
    else
    if FType = 'bevel'
    then CtrlList.Add(TspDataSkinBevel.Create(FName))
    else
    if FType = 'resimkutusu'
    then CtrlList.Add(TspDataSkinresimkutusu.Create(FName))
    else
    if FType = 'panel'
    then CtrlList.Add(TspDataSkinPanelControl.Create(FName))
    else
    if FType = 'expanel'
    then CtrlList.Add(TspDataSkinExPanelControl.Create(FName))
    else
    if FType = 'menubutton'
    then CtrlList.Add(TspDataSkinMenuButtonControl.Create(FName))
    else
    if FType = 'button'
    then CtrlList.Add(TspDataSkinButtonControl.Create(FName))
    else
    if FType = 'checkradio'
    then CtrlList.Add(TspDataSkinCheckRadioControl.Create(FName))
    else
    if FType = 'gauge'
    then CtrlList.Add(TspDataSkinGaugeControl.Create(FName))
    else
    if FType = 'splitter'
    then CtrlList.Add(TspDataSkinSplitterControl.Create(FName))
    else
    if FType = 'trackbar'
    then CtrlList.Add(TspDataSkinTrackBarControl.Create(FName))
    else
    if FType = 'label'
    then CtrlList.Add(TspDataSkinLabelControl.Create(FName))
    else
    if FType = 'stdlabel'
    then CtrlList.Add(TspDataSkinStdLabelControl.Create(FName))
    else
    if FType = 'bitlabel'
    then CtrlList.Add(TspDataSkinBitLabelControl.Create(FName))
    else
    if FType = 'frameregulator'
    then CtrlList.Add(TspDataSkinFrameRegulator.Create(FName))
    else
    if FType = 'framegauge'
    then CtrlList.Add(TspDataSkinFrameGauge.Create(FName))
    else
    if FType = 'animate'
    then CtrlList.Add(TspDataSkinAnimateControl.Create(FName))
    else
    if FType = 'updown'
    then CtrlList.Add(TspDataSkinUpDownControl.Create(FName))
    else
    if FType = 'switch'
    then CtrlList.Add(TspDataSkinSwitchControl.Create(FName))
    else
    if FType = 'grid'
    then CtrlList.Add(TspDataSkinGridControl.Create(FName))
    else
    if FType = 'tab'
    then CtrlList.Add(TspDataSkinTabControl.Create(FName))
    else
    if FType = 'mainmenubar'
    then CtrlList.Add(TspDataSkinMainMenuBar.Create(FName))
    else
    if FType = 'controlbar'
    then CtrlList.Add(TspDataSkinControlBar.Create(FName))
    else
    if FType = 'memo'
    then CtrlList.Add(TspDataSkinMemoControl.Create(FName))
    else
    if FType = 'edit'
    then CtrlList.Add(TspDataSkinEditControl.Create(FName))
    else
    if FType = 'checklistbox'
    then CtrlList.Add(TspDataSkinCheckListBox.Create(FName))
    else
    if FType = 'listbox'
    then CtrlList.Add(TspDataSkinListBox.Create(FName))
    else
    if FType = 'combobox'
    then CtrlList.Add(TspDataSkinComboBox.Create(FName))
    else
    if FType = 'scrollbar'
    then CtrlList.Add(TspDataSkinScrollBarControl.Create(FName))
    else
    if FType = 'spinedit'
    then CtrlList.Add(TspDataSkinSpinEditControl.Create(FName))
    else
    if FType = 'scrollbox'
    then CtrlList.Add(TspDataSkinScrollBoxControl.Create(FName))
    else
    if FType = 'treeview'
    then CtrlList.Add(TspDataSkinTreeView.Create(FName))
    else
    if FType = 'listview'
    then CtrlList.Add(TspDataSkinListView.Create(FName))
    else
    if FType = 'richedit'
    then CtrlList.Add(TspDataSkinRichEdit.Create(FName));
    TspDataSkinControl(CtrlList[CtrlList.Count - 1]).LoadFromFile(F);
  end;
end;

procedure TspSkinData.WriteActivePictures;
begin
  WriteStrings1(F, 'PICTURES', 'activepictures', FActivePicturesNames);
end;

procedure TspSkinData.WriteCursors;
begin
  F.WriteInteger('CURSORS', 'startcursorindex', StartCursorIndex);
  WriteStrings1(F, 'CURSORS', 'cursors', FCursorsNames);
end;

 function TspSkinData.Getareaya(AIDName: String): trect;
 begin
IDName := AIDName;
Result:=GetRect(IDname);
end;



procedure TspSkinData.ReadActivePictures;
var
  i: Integer;
begin
  ReadStrings1(F, 'PICTURES', 'activepictures', FActivePicturesNames);
  for i := 0 to FActivePicturesNames.Count - 1 do
  begin
    FActivePictures.Add(TBitMap.Create);
    if IsJpegFile(FActivePicturesNames[i])
    then
      LoadFromJPegFile(TBitMap(FActivePictures.Items[i]), Path + FActivePicturesNames[i])
    else
      TBitMap(FActivePictures.Items[i]).LoadFromFile(Path + FActivePicturesNames[i]);
  end;
end;

procedure TspSkinData.ReadCursors;
var
  i: Integer;
  CN: PChar;
begin
  StartCursorIndex := F.ReadInteger('CURSORS', 'startcursorindex', 1);
  if StartCursorIndex < 1 then StartCursorIndex := 1;
  ReadStrings1(F, 'CURSORS', 'cursors', FCursorsNames);
  if not BuildMode and (FCursorsNames.Count <> 0)
  then
    begin
      for i := StartCursorIndex to StartCursorIndex + FCursorsNames.Count - 1 do
      begin
        CN := PChar(Path + FCursorsNames[i - StartCursorIndex]);
        Screen.Cursors[i] := LoadCursorFromFile(CN);
      end;
    end;
end;

procedure TspSkinData.ReadObjects;
var
  i, Count: Integer;
  S, FName, FType: String;
begin
  Count := F.ReadInteger('SKINOBJECTS', 'count', 0);
  for i := 0 to Count - 1 do
  begin
    S := F.ReadString('SKINOBJECTS', IntToStr(i), '');
    GetObjectTypeName(S, FName, FType);
    if FType = 'menuitem'
    then ObjectList.Add(TspDataSkinMenuItem.Create(FName)) else
    if FType = 'mainmenubaritem'
    then ObjectList.Add(TspDataSkinMainMenuBarItem.Create(FName)) else
    if FType = 'mainmenuitem'
    then ObjectList.Add(TspDataSkinMainMenuItem.Create(FName)) else
    if FType = 'stdbutton'
    then ObjectList.Add(TspDataSkinStdButton.Create(FName)) else
    if FType = 'mainmenubarbutton'
    then ObjectList.Add(TspDataSkinMainMenuBarButton.Create(FName)) else
    if FType = 'button'
    then ObjectList.Add(TspDataSkinButton.Create(FName)) else
    if FType = 'caption'
    then ObjectList.Add(TspDataSkinCaption.Create(FName)) else
    if FType = 'trackbar'
    then ObjectList.Add(TspDataSkinTrackBar.Create(FName)) else
    if FType = 'gauge'
    then ObjectList.Add(TspDataSkinGauge.Create(FName)) else
    if FType = 'framegauge'
    then ObjectList.Add(TspDataSkinFrameGaugeObject.Create(FName))
    else
    if FType = 'frameregulator'
    then ObjectList.Add(TspDataSkinFrameRegulatorObject.Create(FName)) else
    if FType = 'label'
    then ObjectList.Add(TspDataSkinLabel.Create(FName)) else
    if FType = 'bitlabel'
    then ObjectList.Add(TspDataSkinBitLabel.Create(FName)) else
    if FType = 'switch'
    then ObjectList.Add(TspDataSkinSwitch.Create(FName)) else
    if FType = 'animate'
    then ObjectList.Add(TspDataSkinAnimate.Create(FName)) else
    if FType = 'userobject'
    then ObjectList.Add(TspDataUserObject.Create(FName));
    TspDataSkinObject(ObjectList[ObjectList.Count - 1]).LoadFromFile(F);
  end;
end;


procedure TspSkinData.AddBitMap(FileName: String);
begin
  FActivePicturesNames.Add(ExtractFileName(FileName));
  FActivePictures.Add(TBitMap.Create);
  if IsJPegFile(ExtractFileName(FileName))
  then
    LoadFromJpegFile(TBitMap(FActivePictures.Items[FActivePictures.Count - 1]),
                     FileName)
  else
    TBitMap(FActivePictures.Items[FActivePictures.Count - 1]).LoadFromFile(FileName);
end;

procedure TspSkinData.DeleteBitMap(Index: Integer);
begin
  FActivePicturesNames.Delete(Index);
  TBitMap(FActivePictures.Items[Index]).Free;
  FActivePictures.Delete(Index);
end;

procedure TspSkinData.WriteFormInfo;
begin
  WritePoint(F, 'FORMINFO', 'lefttoppoint', LTPoint);
  Writepoint(F, 'FORMINFO', 'righttoppoint', RTPoint);
  WritePoint(F, 'FORMINFO', 'leftbottompoint', LBPoint);
  WritePoint(F, 'FORMINFO', 'rightbottompoint', RBPoint);
  WriteRect(F, 'FORMINFO', 'clientrect', ClRect);
  F.WriteInteger('FORMINFO', 'bgpictureindex', BGPictureIndex);
  F.WriteInteger('FORMINFO', 'mdibgpictureindex', MDIBGPictureIndex);
  WriteRect(F, 'FORMINFO', 'maskrectarea', MaskRectArea);
  //
  WriteBoolean(F, 'FORMINFO', 'leftstretch', LeftStretch);
  WriteBoolean(F, 'FORMINFO', 'rightstretch', RightStretch);
  WriteBoolean(F, 'FORMINFO', 'topstretch', TopStretch);
  WriteBoolean(F, 'FORMINFO', 'bottomstretch', BottomStretch);
  //
  WriteRect(F, 'FORMINFO', 'buttonsrect', ButtonsRect);
  WriteRect(F, 'FORMINFO', 'captionrect', CaptionRect);
  F.WriteInteger('FORMINFO', 'buttonsoffset', ButtonsOffset);
  WriteBoolean(F, 'FORMINFO', 'buttonsinleft', CapButtonsInLeft);
  //
  WritePoint(F, 'FORMINFO', 'hittestlefttoppoint', HitTestLTPoint);
  WritePoint(F, 'FORMINFO', 'hittestrighttoppoint', HitTestRTPoint);
  WritePoint(F, 'FORMINFO', 'hittestleftbottompoint', HitTestLBPoint);
  WritePoint(F, 'FORMINFO', 'hittestrightbottompoint', HitTestRBPoint);
  //
  WritePoint(F, 'FORMINFO', 'rollupleftpoint', RollUpLeftPoint);
  WritePoint(F, 'FORMINFO', 'rolluprightpoint', RollUpRightPoint);
  //
  WriteRect(F, 'FORMINFO', 'mainmenurect', MainMenuRect);
  WriteRect(F, 'FORMINFO', 'iconrect', IconRect);
  WriteBoolean(F, 'FORMINFO', 'mainmenupopupup', MainMenuPopupUp);
  F.WriteInteger('FORMINFO', 'borderwidth', BorderW);
  F.WriteInteger('FORMINFO', 'cursorindex', CursorIndex);
  WriteBoolean(F, 'FORMINFO', 'autorenderinginactiveimage', AutoRenderingInActiveImage);
  WriteInActiveEffect(F, 'FORMINFO', 'inactiveeffect', InActiveEffect);
end;

procedure TspSkinData.ReadFormInfo;
begin
  LTPoint := ReadPoint(F, 'FORMINFO', 'lefttoppoint');
  RTPoint := Readpoint(F, 'FORMINFO', 'righttoppoint');
  LBPoint := ReadPoint(F, 'FORMINFO', 'leftbottompoint');
  RBPoint := ReadPoint(F, 'FORMINFO', 'rightbottompoint');
  ClRect := ReadRect(F, 'FORMINFO', 'clientrect');
  BGPictureIndex := F.ReadInteger('FORMINFO', 'bgpictureindex', -1);
  MDIBGPictureIndex := F.ReadInteger('FORMINFO', 'mdibgpictureindex', -1);
  //
  LeftStretch := ReadBoolean(F, 'FORMINFO', 'leftstretch');
  RightStretch := ReadBoolean(F, 'FORMINFO', 'rightstretch');
  TopStretch := ReadBoolean(F, 'FORMINFO', 'topstretch');
  BottomStretch := ReadBoolean(F, 'FORMINFO', 'bottomstretch');
  //
  ButtonsRect := ReadRect(F, 'FORMINFO', 'buttonsrect');
  CaptionRect := ReadRect(F, 'FORMINFO', 'captionrect');
  ButtonsOffset := F.ReadInteger('FORMINFO', 'buttonsoffset', 0);
  CapButtonsInLeft := ReadBoolean(F, 'FORMINFO', 'buttonsinleft');
  //
  MaskRectArea := ReadRect(F, 'FORMINFO', 'maskrectarea');
  HitTestLTPoint := ReadPoint(F, 'FORMINFO', 'hittestlefttoppoint');
  HitTestRTPoint := ReadPoint(F, 'FORMINFO', 'hittestrighttoppoint');
  HitTestLBPoint := ReadPoint(F, 'FORMINFO', 'hittestleftbottompoint');
  HitTestRBPoint := ReadPoint(F, 'FORMINFO', 'hittestrightbottompoint');
  //
  RollUpLeftPoint := ReadPoint(F, 'FORMINFO', 'rollupleftpoint');
  RollUpRightPoint := ReadPoint(F, 'FORMINFO', 'rolluprightpoint');
  //
  if FMaskName <> ''
  then
    begin
      if isNullRect(MaskRectArea)
      then
        MaskRectArea := ClRect
      else
        begin
          if MaskRectArea.Left > ClRect.Left
          then MaskRectArea.Left := ClRect.Left;
          if MaskRectArea.Top > ClRect.Top
          then MaskRectArea.Top := ClRect.Top;
          if MaskRectArea.Right < ClRect.Right
          then MaskRectArea.Right := ClRect.Right;
          if MaskRectArea.Bottom < ClRect.Bottom
          then MaskRectArea.Bottom := ClRect.Bottom;
        end;
      if isNullPoint(HitTestLTPoint) then  HitTestLTPoint := LTPoint;
      if isNullPoint(HitTestRTPoint) then  HitTestRTPoint := RTPoint;
      if isNullPoint(HitTestLBPoint) then  HitTestLBPoint := LBPoint;
      if isNullPoint(HitTestRBPoint) then  HitTestRBPoint := RBPoint;
    end;
  //
  MainMenuRect := ReadRect(F, 'FORMINFO', 'mainmenurect');
  IconRect := ReadRect(F, 'FORMINFO', 'iconrect');
  MainMenuPopupUp := ReadBoolean(F, 'FORMINFO', 'mainmenupopupup');
  BorderW := F.ReadInteger('FORMINFO', 'borderwidth', 0);
  CursorIndex := F.ReadInteger('FORMINFO', 'cursorindex', -1);
  AutoRenderingInActiveImage := ReadBoolean(F, 'FORMINFO', 'autorenderinginactiveimage');
  InActiveEffect := ReadInActiveEffect(F, 'FORMINFO', 'inactiveeffect');
  //
  if (RBPoint.X - LTPoint.X  <> 0) and
     (RBPoint.Y - LTPoint.Y <> 0)
  then
    begin
      if LTPoint.X < CLRect.Left then LTPoint.X := CLRect.Left;
      if LTPoint.Y < CLRect.Top then LTPoint.Y := CLRect.Top;
      if RTPoint.X > CLRect.Right then RTPoint.X := CLRect.Right;
      if RTPoint.Y < CLRect.Top then RTPoint.Y := CLRect.Top;
      if LBPoint.X < CLRect.Left then LBPoint.X := CLRect.Left;
      if LBPoint.Y > CLRect.Bottom then LBPoint.Y := CLRect.Bottom;
      if RBPoint.X > CLRect.Right then RBPoint.X := CLRect.Right;
      if RBPoint.Y > CLRect.Bottom then RBPoint.Y := CLRect.Bottom;
    end;
end;

const
  SkinDataFileFormat = 2;

procedure TspSkinData.SaveToCustomIniFile;
var
  Version: Integer;
begin
  //
  F.EraseSection('VERSION');
  Version := SkinDataFileFormat;
  F.WriteInteger('VERSION', 'ver', Version);
  F.WriteString('VERSION', 'skinname', SkinName);
  F.WriteString('VERSION', 'skinauthor', SkinAuthor);
  F.WriteString('VERSION', 'authoremail', AuthorEmail);
  F.WriteString('VERSION', 'authorurl', AuthorURL);
  F.WriteString('VERSION', 'skincomments', SkinComments);
  //
  F.EraseSection('PICTURES');
  F.WriteString('PICTURES', 'picture', FPictureName);
  F.WriteString('PICTURES', 'inactivepicture', FInActivePictureName);
  F.WriteString('PICTURES', 'mask', FMaskName);
  F.WriteString('PICTURES', 'rolluppicture', FRollUpPictureName);
  F.WriteString('PICTURES', 'rollupmask', FRollUpMaskName);
  WriteActivePictures(F);
  //
  F.EraseSection('CURSORS');
  WriteCursors(F);
  //
  F.EraseSection('FORMINFO');
  WriteFormInfo(F);
  //
  F.EraseSection('POPUPWINDOW');
  PopupWindow.SaveToFile(F);
  //
  F.EraseSection('HINTWINDOW');
  HintWindow.SaveToFile(F);
  //
  WriteAreas(F);
  //
  WriteObjects(F);
  //
  WriteCtrls(F);
end;

procedure TspSkinData.SaveToFile;
var
  F: TIniFile;
  Version: Integer;
  F1: TFileStream;
begin
  //
  F1 := TFileStream.Create(FileName, fmCreate);
  F1.Free;
  F := TIniFile.Create(FileName);
  SaveToCustomIniFile(F);
  F.Free;
end;

procedure TspSkinData.LoadFromFile;
var
  F: TIniFile;
  FilePath: String;
begin
  Empty := True;

  SendSkinDataMessage(WM_BEFORECHANGESKINDATA);

  ClearAll;
  F := TIniFile.Create(FileName);

  if not CheckSkinFile(F)
  then
    begin
      SendSkinDataMessage(WM_CHANGESKINDATA);
      SendSkinDataMessage(WM_AFTERCHANGESKINDATA);
      F.Free;
      Exit;
    end;

  FilePath := ExtractFilePath(FileName);
  //
  SkinName := F.ReadString('VERSION', 'skinname', '');
  SkinAuthor := F.ReadString('VERSION', 'skinauthor', '');
  AuthorEmail := F.ReadString('VERSION', 'authoremail', '');
  AuthorURL := F.ReadString('VERSION', 'authorurl', '');
  SkinComments := F.ReadString('VERSION', 'skincomments', '');
  //
  FPictureName := F.ReadString('PICTURES', 'picture', '');
  FInActivePictureName := F.ReadString('PICTURES', 'inactivepicture', '');
  FMaskName := F.ReadString('PICTURES', 'mask', '');
  FRollUpPictureName := F.ReadString('PICTURES', 'rolluppicture', '');
  FRollUpMaskName := F.ReadString('PICTURES', 'rollupmask', '');

  if FPictureName <> ''
  then
    begin
      if IsJpegFile(FPictureName)
      then
        LoadFromJPegFile(FPicture, FilePath + FPictureName)
      else
        FPicture.LoadFromFile(FilePath + FPictureName);
    end
  else
    FPicture.Assign(nil);

  if FInActivePictureName <> ''
  then
    begin
      if IsJpegFile(FInActivePictureName)
      then
        LoadFromJPegFile(FInActivePicture, FilePath + FInActivePictureName)
      else
        FInActivePicture.LoadFromFile(FilePath + FInActivePictureName);
    end
  else
    FInActivePicture.Assign(nil);

  if FMaskName <> ''
  then
    begin
      if IsJpegFile(FMaskName)
      then
        LoadFromJpegFile(FMask, FilePath + FMaskName)
      else
        FMask.LoadFromFile(FilePath + FMaskName);
    end
  else
    FMask.Assign(nil);

  if FRollUpPictureName <> ''
  then
    begin
      if IsJpegFile(FRollUpPictureName)
      then
        LoadFromJPegFile(FRollUpPicture, FilePath + FRollUpPictureName)
      else
        FRollUpPicture.LoadFromFile(FilePath + FRollUpPictureName);
    end
  else
    FRollUpPicture.Assign(nil);

  if FRollUpMaskName <> ''
  then
    begin
      if IsJpegFile(FRollUpMaskName)
      then
        LoadFromJPegFile(FRollUpMask, FilePath + FRollUpMaskName)
      else
        FRollUpMask.LoadFromFile(FilePath + FRollUpMaskName);
    end
  else
    FRollUpMask.Assign(nil);


  ReadActivePictures(F, FilePath);
  ReadCursors(F, FilePath);
  //
  ReadFormInfo(F);
  //
  PopupWindow.LoadFromFile(F);
  //
  HintWindow.LoadFromFile(F);
  //
  ReadAreas(F);
  //
  ReadObjects(F);
  //
  ReadCtrls(F);
  //
  F.UpdateFile;

  F.Free;

  Empty := False;

  SendSkinDataMessage(WM_CHANGESKINDATA);
  SendSkinDataMessage(WM_AFTERCHANGESKINDATA);
end;

procedure TspSkinData.LoadCompressedStoredSkin(AStoredSkin: TspCompressedStoredSkin);
var
  TmpStream: TMemoryStream;
  CV: Integer;
  FIniStrings: TStrings;
  F: TMemIniFile;
  IsEmpty: Boolean;
  i, Count: Integer;
begin
  if AStoredSkin.Empty then Exit;
  Empty := True;
  SendSkinDataMessage(WM_BEFORECHANGESKINDATA);
  ClearAll;
  TmpStream := TMemoryStream.Create;
  AStoredSkin.DeCompressToStream(TmpStream);
  TmpStream.Seek(0, 0);
  TmpStream.Read(CV, SizeOf(CV));
  if CV > 3
  then
    begin
      TmpStream.Free;
      Exit;
    end;
  //
  TmpStream.Read(IsEmpty, SizeOf(IsEmpty));
  if IsEmpty
  then FPicture.Assign(nil)
  else FPicture.LoadFromStream(TmpStream);

  // new compress format additional
  if (CV = 2) or (CV = 3)
  then
    begin
      TmpStream.Read(IsEmpty, SizeOf(IsEmpty));
      if IsEmpty
      then FInActivePicture.Assign(nil)
      else FInActivePicture.LoadFromStream(TmpStream);
    end;  
  //

  TmpStream.Read(IsEmpty, SizeOf(IsEmpty));
  if IsEmpty
  then FMask.Assign(nil)
  else FMask.LoadFromStream(TmpStream);

  if (CV = 1) or (CV = 2)
  then
    begin
      TmpStream.Read(IsEmpty, SizeOf(IsEmpty));
      if IsEmpty
      then FRollUpPicture.Assign(nil)
      else FRollUpPicture.LoadFromStream(TmpStream);

      TmpStream.Read(IsEmpty, SizeOf(IsEmpty));
      if IsEmpty
      then FRollUpMask.Assign(nil)
      else FRollUpMask.LoadFromStream(TmpStream);
    end;  

  TmpStream.Read(Count, SizeOf(Count));
  if Count > 0
  then
    for i := 0 to Count - 1 do
    begin
      FActivePictures.Add(TBitMap.Create);
      TBitMap(FActivePictures.Items[i]).LoadFromStream(TmpStream);
    end;
  //
  FIniStrings := TStringList.Create;
  FIniStrings.LoadFromStream(TmpStream);
  F := TMemIniFile.Create('');
  F.SetStrings(FIniStrings);
  //
  SkinName := F.ReadString('VERSION', 'skinname', '');
  SkinAuthor := F.ReadString('VERSION', 'skinauthor', '');
  AuthorEmail := F.ReadString('VERSION', 'authoremail', '');
  AuthorURL := F.ReadString('VERSION', 'authorurl', '');
  SkinComments := F.ReadString('VERSION', 'skincomments', '');
  //
  FPictureName := F.ReadString('PICTURES', 'picture', '');
  FMaskName := F.ReadString('PICTURES', 'mask', '');
  FRollUpPictureName := F.ReadString('PICTURES', 'rolluppicture', '');
  FRollUpMaskName := F.ReadString('PICTURES', 'rollupmask', '');
  ReadStrings1(F, 'PICTURES', 'activepictures', FActivePicturesNames);
  //
  ReadFormInfo(F);
  PopupWindow.LoadFromFile(F);
  HintWindow.LoadFromFile(F);
  //
  ReadAreas(F);
  //
  ReadObjects(F);
  //
  ReadCtrls(F);
  //
  FIniStrings.Free;
  F.Free;
  TmpStream.Free;
  //
  Empty := False;
  SendSkinDataMessage(WM_CHANGESKINDATA);
  SendSkinDataMessage(WM_AFTERCHANGESKINDATA);
end;

procedure TspSkinData.ClearSkin;
begin
  ClearAll;
  SendSkinDataMessage(WM_BEFORECHANGESKINDATA);
  SendSkinDataMessage(WM_CHANGESKINDATA);
  SendSkinDataMessage(WM_AFTERCHANGESKINDATA);
end;

const
  CompressVersion = 2;

constructor TspCompressedStoredSkin.Create(AOwner: TComponent);
begin
  inherited;
  FCompressedStream := TMemoryStream.Create;
  FDescription := '';
  FFileName := '';
  FCompressedFileName := '';
end;

destructor TspCompressedStoredSkin.Destroy;
begin
  FCompressedStream.Free;
  inherited;
end;

procedure TspCompressedStoredSkin.LoadFromSkinData(ASkinData: TspSkinData);
var
  TmpStream: TMemoryStream;
  BitMap: TBitMap;
  IsEmpty: Boolean;
  i, Count, CV: Integer;
  F: TMemIniFile;
  FIniStrings: TStrings;
begin
  FCompressedStream.Clear;

  TmpStream := TMemoryStream.Create;
  //
  CV := CompressVersion;
  TmpStream.Write(CV, SizeOf(CV));
  // load bitmaps to stream
  IsEmpty := ASkinData.FPicture.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then
    ASkinData.FPicture.SaveToStream(TmpStream);
  //
  IsEmpty := ASkinData.FInActivePicture.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then
    ASkinData.FInActivePicture.SaveToStream(TmpStream);
  //
  IsEmpty := ASkinData.FMask.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then
    ASkinData.FMask.SaveToStream(TmpStream);
  //
  IsEmpty := ASkinData.FRollUpPicture.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then
    ASkinData.FRollUpPicture.SaveToStream(TmpStream);
  //
  IsEmpty := ASkinData.FRollUpMask.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then
    ASkinData.FRollUpMask.SaveToStream(TmpStream);
  //
  Count := ASkinData.FActivePictures.Count;
  TmpStream.Write(Count, SizeOf(Count));
  if Count <> 0
  then
    for i := 0 to Count - 1 do
    begin
      BitMap := TBitMap(ASkinData.FActivePictures[I]);
      BitMap.SaveToStream(TmpStream);
    end;
  //
  F := TMemIniFile.Create('');
  ASkinData.SaveToCustomIniFile(F);
  FIniStrings := TStringList.Create;
  F.GetStrings(FIniStrings);
  FIniStrings.SaveToStream(TmpStream);
  FIniStrings.Free;
  F.Free;
  //
  CompressStream(TmpStream, FCompressedStream);
  TmpStream.Free;
end;


function TspCompressedStoredSkin.GetEmpty: Boolean;
begin
  Result := FCompressedStream.Size = 0;
end;

procedure TspCompressedStoredSkin.SetFileName;
begin
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      FFileName := ExtractFileName(Value);
      LoadFromIniFile(Value);
    end
  else
    FFileName := Value;
end;

procedure TspCompressedStoredSkin.SetCompressedFileName;
begin
  if (csDesigning in ComponentState) and not
     (csLoading in ComponentState)
  then
    begin
      FCompressedFileName := ExtractFileName(Value);
      LoadFromCompressFile(Value);
    end
  else
    FCompressedFileName := Value;
end;

procedure TspCompressedStoredSkin.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('CompressedData', ReadData, WriteData, True);
end;

procedure TspCompressedStoredSkin.ReadData;
begin
  FCompressedStream.LoadFromStream(Reader);
end;

procedure TspCompressedStoredSkin.WriteData;
begin
  FCompressedStream.SaveToStream(Writer);
end;

procedure TspCompressedStoredSkin.DeCompressToStream;
begin
  DecompressStream(S, FCompressedStream);
end;

procedure TspCompressedStoredSkin.LoadFromIniFile(AFileName: String);
var
  TmpStream: TMemoryStream;
  F: TMemIniFile;
  Path: String;
  FIniStrings: TStrings;
  BitMapName: String;
  BitMap: TBitMap;
  IsEmpty: Boolean;
  i, Count, CV: Integer;
  PNames: TStrings;
begin
  FIniStrings := TStringList.Create;
  FIniStrings.LoadFromFile(AFileName);

  F := TMemIniFile.Create(AFileName);

  if not CheckSkinFile(F)
  then
    begin
      F.Free;
      FIniStrings.Free;
      Exit;
    end;

  Path := ExtractFilePath(AFileName);

  FCompressedStream.Clear;

  TmpStream := TMemoryStream.Create;
  //
  CV := CompressVersion;
  TmpStream.Write(CV, SizeOf(CV));
  // load bitmaps to stream
  BitMap := TBitMap.Create;
  //
  BitMapName := F.ReadString('PICTURES', 'picture', '');
  if BitMapName <> ''
  then BitMap.LoadFromFile(Path + BitMapName)
  else BitMap.Assign(nil);
  IsEmpty := BitMap.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then BitMap.SaveToStream(TmpStream);
  //
  BitMapName := F.ReadString('PICTURES', 'inactivepicture', '');
  if BitMapName <> ''
  then BitMap.LoadFromFile(Path + BitMapName)
  else BitMap.Assign(nil);
  IsEmpty := BitMap.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then BitMap.SaveToStream(TmpStream);
  //
  BitMapName := F.ReadString('PICTURES', 'mask', '');
  if BitMapName <> ''
  then BitMap.LoadFromFile(Path + BitMapName)
  else BitMap.Assign(nil);
  IsEmpty := BitMap.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty then BitMap.SaveToStream(TmpStream);
  //
  BitMapName := F.ReadString('PICTURES', 'rolluppicture', '');
  if BitMapName <> ''
  then BitMap.LoadFromFile(Path + BitMapName)
  else BitMap.Assign(nil);
  IsEmpty := BitMap.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then BitMap.SaveToStream(TmpStream);
  //
  BitMapName := F.ReadString('PICTURES', 'rollupmask', '');
  if BitMapName <> ''
  then BitMap.LoadFromFile(Path + BitMapName)
  else BitMap.Assign(nil);
  IsEmpty := BitMap.Empty;
  TmpStream.Write(IsEmpty, SizeOf(IsEmpty));
  if not IsEmpty
  then BitMap.SaveToStream(TmpStream);
  //
  PNames := TStringList.Create;
  ReadStrings1(F, 'PICTURES', 'activepictures', PNames);
  Count := PNames.Count;
  TmpStream.Write(Count, SizeOf(Count));
  if Count > 0
  then
    for i := 0 to Count - 1 do
    begin
      BitMapName := Path + PNames[i];
      BitMap.LoadFromFile(BitMapName);
      BitMap.SaveToStream(TmpStream);
    end;
  PNames.Free;
  //
  FIniStrings.SaveToStream(TmpStream);
  //
  CompressStream(TmpStream, FCompressedStream);
  BitMap.Free;
  FIniStrings.Free;
  TmpStream.Free;
  F.Free;
end;

procedure TspCompressedStoredSkin.LoadFromCompressFile(AFileName: String);
var
  F: TFileStream;
  CV, Size: LongInt;
begin
  FCompressedStream.Clear;
  F := TFileStream.Create(AFileName, fmOpenRead);
  F.Read(CV, SizeOf(CV));
  if CV <= 3
  then
    begin
      F.Read(Size, SizeOf(Size));
      FCompressedStream.CopyFrom(F, Size);
    end;
  F.Free;
end;

procedure TspCompressedStoredSkin.SaveToCompressFile(AFileName: String);
var
  F: TFileStream;
  CV, Size: LongInt;
begin
  if Empty then Exit;
  F := TFileStream.Create(AFileName, fmCreate);
  CV := CompressVersion;
  F.Write(CV, SizeOf(CV));
  Size := FCompressedStream.Size;
  F.Write(Size, SizeOf(Size));
  FCompressedStream.SaveToStream(F);
  F.Free;
end;

constructor TspResourceStrData.Create(AOwner: TComponent);
begin
  inherited;
  FResStrs := TStringList.Create;
  Init;
  FCharSet := DEFAULT_CHARSET;
end;

destructor TspResourceStrData.Destroy;
begin
  FResStrs.Free;
  inherited;
end;

procedure TspResourceStrData.SetResStrs(Value: TStrings);
begin
  FResStrs.Assign(Value);
end;

function TspResourceStrData.GetResStr(const ResName: String): String;
var
  I: Integer;
begin
  I := FResStrs.IndexOfName(ResName);
  if I <> -1
  then
    Result := Copy(FResStrs[I], Pos('=', FResStrs[I]) + 1,
     Length(FResStrs[I]) - Pos('=', FResStrs[I]) + 1)
  else
    Result := '';
end;

procedure TspResourceStrData.Init;
begin
  FResStrs.Add('MI_MINCAPTION=&Küçült');
  FResStrs.Add('MI_MAXCAPTION=&Büyült');
  FResStrs.Add('MI_CLOSECAPTION=&Kapat');
  FResStrs.Add('MI_RESTORECAPTION=&Eski Yerine Al');
  FResStrs.Add('MI_MINTOTRAYCAPTION=&Tray a kücült');
  FResStrs.Add('MI_ROLLUPCAPTION=&Ufak Boyut');

  FResStrs.Add('MINBUTTON_HINT=Küçült');
  FResStrs.Add('MAXBUTTON_HINT=Büyült');
  FResStrs.Add('CLOSEBUTTON_HINT=Kapat');
  FResStrs.Add('TRAYBUTTON_HINT=Tray a indir');
  FResStrs.Add('ROLLUPBUTTON_HINT=Ufak Boyut');
  FResStrs.Add('MENUBUTTON_HINT=Sistem menüsü');

  FResStrs.Add('EDIT_UNDO=Geri Al');
  FResStrs.Add('EDIT_COPY=Kopyala');
  FResStrs.Add('EDIT_CUT=Kes');
  FResStrs.Add('EDIT_PASTE=Yapýþtýr');
  FResStrs.Add('EDIT_DELETE=Sil');
  FResStrs.Add('EDIT_SELECTALL=Hepsini Seç');

  FResStrs.Add('MSG_BTN_YES=&Evet');
  FResStrs.Add('MSG_BTN_NO=&Hayýr');
  FResStrs.Add('MSG_BTN_OK=Tamam');
  FResStrs.Add('MSG_BTN_CANCEL=Ýptal');
  FResStrs.Add('MSG_BTN_ABORT=&Baþarýsýz');
  FResStrs.Add('MSG_BTN_RETRY=&Yeniden Dene');
  FResStrs.Add('MSG_BTN_IGNORE=&Yoksay');
  FResStrs.Add('MSG_BTN_ALL=&Tümü');
  FResStrs.Add('MSG_BTN_NOTOALL=H&içbiri');
  FResStrs.Add('MSG_BTN_YESTOALL=&Tümüne Evet');
  FResStrs.Add('MSG_BTN_HELP=&Yardým');
  FResStrs.Add('MSG_BTN_OPEN=&Aç');
  FResStrs.Add('MSG_BTN_SAVE=&Kaydet');

  FResStrs.Add('MSG_BTN_BACK_HINT=Ziyaret Edilen En Son Klasöre Git');
  FResStrs.Add('MSG_BTN_UP_HINT=Bir Üst Kademe');
  FResStrs.Add('MSG_BTN_NEWFOLDER_HINT=Yeni Klasör Oluþtur');
  FResStrs.Add('MSG_BTN_VIEWMENU_HINT=Görünüm Menüsü');
  FResStrs.Add('MSG_BTN_STRETCH_HINT=Resmi Döþe');

  FResStrs.Add('MSG_FILENAME=Dosya Adý:');
  FResStrs.Add('MSG_FILETYPE=Dosya Tipi:');
  FResStrs.Add('MSG_NEWFOLDER=Yeni Klasör');
  FResStrs.Add('MSG_LV_DETAILS=Açýklama');
  FResStrs.Add('MSG_LV_ICON=Büyük Simge');
  FResStrs.Add('MSG_LV_SMALLICON=Küçük Simge');
  FResStrs.Add('MSG_LV_LIST=Listele');
  FResStrs.Add('MSG_PREVIEWSKIN=Önizleme');
  FResStrs.Add('MSG_PREVIEWBUTTON=Buton');

  FResStrs.Add('MSG_CAP_WARNING=Dikkat');
  FResStrs.Add('MSG_CAP_ERROR=Hata');
  FResStrs.Add('MSG_CAP_INFORMATION=Bilgi');
  FResStrs.Add('MSG_CAP_CONFIRM=Onaylayýn');

  FResStrs.Add('CALC_CAP=Hesap Makinesi');
  FResStrs.Add('ERROR=Hata');
  FResStrs.Add('COLORGRID_CAP=Temel Renkler');
  FResStrs.Add('CUSTOMCOLORGRID_CAP=Özel Renkler');
  FResStrs.Add('ADDCUSTOMCOLORBUTTON_CAP=Özel Renklere Ekle');

  FResStrs.Add('FONTDLG_COLOR=Renk:');
  FResStrs.Add('FONTDLG_NAME=Adý:');
  FResStrs.Add('FONTDLG_SIZE=Boyutu:');
  FResStrs.Add('FONTDLG_HEIGHT=Yükseklik:');
  FResStrs.Add('FONTDLG_EXAMPLE=Örnek:');
  FResStrs.Add('FONTDLG_STYLE=Sitili:');
  FResStrs.Add('FONTDLG_SCRIPT=El Yazisi:');

  FResStrs.Add('DB_DELETE_QUESTION=Kayýt Silinsin mi?');
  FResStrs.Add('DB_MULTIPLEDELETE_QUESTION=Tüm Kayýtarý Silmek Ýstiyormusunuz?');

  FResStrs.Add('NODISKINDRIVE=Disk Yok Yada Okuma Yazma Korumalý ');
  FResStrs.Add('NOVALIDDRIVEID=Sürücü ID si Bulunamadý');

  FResStrs.Add('FLV_NAME=Adý');
  FResStrs.Add('FLV_SIZE=Boyutu');
  FResStrs.Add('FLV_TYPE=Tipi');
  FResStrs.Add('FLV_LOOKIN=Ýçeriði: ');
  FResStrs.Add('FLV_MODIFIED=Düzenleme');
  FResStrs.Add('FLV_ATTRIBUTES=Simgesi');
  FResStrs.Add('FLV_DISKSIZE=Disk boyu');
  FResStrs.Add('FLV_FREESPACE=Boþ Alan');
end;

end.

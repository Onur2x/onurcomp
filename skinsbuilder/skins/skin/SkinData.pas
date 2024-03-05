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

unit SkinData;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}


interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, SPUtils, Forms,
     IniFiles, Dialogs, spEffBmp;

type

  TStdCommand = (cmClose, cmMaximize, cmMinimize, cmSysMenu, cmDefault, cmRollUp,
                 cmMinimizeToTray);
  TMorphKind = (mkDefault, mkGradient, mkLeftGradient, mkRightGradient,
                mkLeftSlide, mkRightSlide, mkPush);
  TFramesPlacement = (fpHorizontal, fpVertical);
  TRegulatorKind = (rkRound, rkHorizontal, rkVertical);
  TspInActiveEffect = (ieBrightness, ieDarkness, ieGrayScale,
                       ieNoise, ieSplitBlur, ieInvert);

  TspSkinData = class;
                       
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
    //
    ExpandImageRect: TRect;
    NoExpandImageRect: TRect;
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
    StretchEffect: Boolean;
    ItemTransparent: Boolean;
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
    TabStretchEffect: Boolean;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    ShowFocus: Boolean;
    FocusOffsetX, FocusOffsetY: Integer;
    StretchEffect: Boolean;
    StretchType: TspStretchType;
    CloseButtonRect, CloseButtonActiveRect, CloseButtonDownRect: TRect;
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    TabLeftBottomActiveRect, TabLeftBottomFocusRect: TRect;
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
    FixedCellStretchEffect: Boolean;
    CellStretchEffect: Boolean;
    ShowFocus: Boolean;
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
    StretchEffect: Boolean;
    LeftStretch, TopStretch, RightStretch, BottomStretch: Boolean;
    StretchType: TspStretchType;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinControlBar = class(TspDataSkinCustomControl)
  public
    ItemRect: TRect;
    BGPictureIndex: Integer;
    HGripRect, VGripRect: TRect;
    GripOffset1, GripOffset2: Integer;
    ItemStretchEffect: Boolean;
    ItemOffset1, ItemOffset2: Integer;
    ItemTransparent: Boolean;
    ItemTransparentColor: TColor;
    GripTransparent: Boolean;
    GripTransparentColor: TColor;
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
    SItemRect, ActiveItemRect, FocusItemRect: TRect;
    ItemLeftOffset, ItemRightOffset: Integer;
    ItemTextRect: TRect;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, FocusFontColor, ActiveFontColor: TColor;
    ButtonRect,
    ActiveButtonRect,
    DownButtonRect,
    UnEnabledButtonRect: TRect;
    ItemStretchEffect: Boolean;
    FocusItemStretchEffect: Boolean;
    //
    ActiveSkinRect: TRect;
    //
    ShowFocus: Boolean;
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
    ShowFocus: Boolean;
    //
    DisabledButtonsRect: TRect;
    ButtonsArea: TRect;
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
    GlyphTransparent: Boolean;
    GlyphTransparentColor: TColor;
    ThumbTransparent: Boolean;
    ThumbTransparentColor: TColor;
    ThumbStretchEffect: Boolean;
    ThumbMinSize: Integer;
    ThumbMinPageSize: Integer;
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
    ActiveSkinRect: TRect;
    TrackArea, ButtonRect, ActiveButtonRect: TRect;
    Vertical: Boolean;
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;


  TspDataSkinSplitterControl = class(TspDataSkinCustomControl)
  public
    GripperRect: TRect;
    GripperTransparent: Boolean;
    GripperTransparentColor: TColor;
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;
  
  TspDataSkinGaugeControl = class(TspDataSkinCustomControl)
  public
    ProgressArea, ProgressRect: TRect;
    ProgressTransparent: Boolean;
    ProgressTransparentColor: TColor;
    ProgressStretch: Boolean;
    Vertical: Boolean;
    BeginOffset, EndOffset: Integer;
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor: TColor;
    AnimationSkinRect: TRect;
    AnimationCountFrames: Integer;
    AnimationTimerInterval: Integer;
    ProgressAnimationSkinRect: TRect;
    ProgressAnimationCountFrames: Integer;
    ProgressAnimationTimerInterval: Integer;
    AnimationBeginOffset: Integer;
    AnimationEndOffset: Integer;
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
    ActiveSkinRect, DownSkinRect, DisabledSkinRect, FocusedSkinRect: TRect;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    ShowFocus: Boolean;
    MenuMarkerFlatRect: TRect;
    MenuMarkerRect: TRect;
    MenuMarkerActiveRect: TRect;
    MenuMarkerDownRect: TRect;
    MenuMarkerTransparentColor: TColor;
    //
    GlowLayerPictureIndex: Integer;
    GlowLayerMaskPictureIndex: Integer;
    GlowLayerOffsetLeft: Integer;
    GlowLayerOffsetRight: Integer;
    GlowLayerOffsetTop: Integer;
    GlowLayerOffsetBottom: Integer;
    GlowLayerShowOffsetX: Integer;
    GlowLayerShowOffsetY: Integer;
    GlowLayerAlphaBlendValue: Integer;
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
    GrayedCheckImageRect, ActiveGrayedCheckImageRect: TRect;
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
    MarkFrameRect: TRect;
    FrameRect: TRect;
    FrameLeftOffset, FrameRightOffset: Integer;
    FrameTextRect: TRect;
    GripperRect: TRect;
    GripperTransparent: Boolean;
    GripperTransparentColor: TColor;
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
    //
    ButtonsTransparent: Boolean;
    ButtonsTransparentColor: TColor;
    //
    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  
  TspDataSkinArea = class(TObject)
  public
    IDName: String;
    AreaRect: TRect;
    UseAnchors: Boolean;
    AnchorLeft, AnchorTop, AnchorRight, AnchorBottom: Boolean;
    constructor Create(AIDName: String; ARect: TRect;
    AUseAnchors, AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom: Boolean);
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
    ActiveMaskPictureIndex: Integer;
    CursorIndex: Integer;
    RollUp: Boolean;
    //
    GlowLayerPictureIndex: Integer;
    GlowLayerMaskPictureIndex: Integer;
    GlowLayerOffsetX: Integer;
    GlowLayerOffsetY: Integer;
    GlowLayerAlphaBlendValue: Integer;

    constructor Create(AIDName: String);
    procedure LoadFromFile(IniFile: TCustomIniFile); virtual;
    procedure SaveToFile(IniFile: TCustomIniFile); virtual;
    procedure InitAlphaImages(ASkinData: TspSkinData); virtual;
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
    Transparent: Boolean;
    TransparentColor: TColor;
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
    DownSkinRect: TRect;
    RestoreRect: TRect;
    RestoreActiveRect: TRect;
    RestoreDownRect: TRect;
    RestoreInActiveRect: TRect;
    RestoreHint: String;
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
    ButtonTransparent: Boolean;
    ButtonTransparentColor: TColor;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

  TspDataSkinButton = class(TspDataSkinObject)
  public
    GroupIndex: Integer;
    DownRect: TRect;
    DisableSkinRect: TRect;
    AlphaMaskPictureIndex: Integer;
    AlphaMaskActivePictureIndex: Integer;
    AlphaMaskInActivePictureIndex: Integer;
    //
    FAlphaNormalImage, FAlphaActiveImage, FAlphaDownImage,
    FAlphaInActiveImage: TspBitMap;
    //
    constructor Create(AIDName: String);
    destructor Destroy; override;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
    procedure InitAlphaImages(ASkinData: TspSkinData); override;
    procedure InitAlphaImage(var ASkinData: TspSkinData; var AImage:
     TspBitMap; ARect: TRect; AMaskPictureIndex: Integer);
  end;

  TspDataSkinStdButton = class(TspDataSkinButton)
  public
    Command: TStdCommand;
    RestoreRect: TRect;
    RestoreActiveRect: TRect;
    RestoreDownRect: TRect;
    RestoreInActiveRect: TRect;
    RestoreHint: String;
    //
    FAlphaRestoreNormalImage, FAlphaRestoreActiveImage,
    FAlphaRestoreDownImage, FAlphaInActiveRestoreImage: TspBitMap;
    //
    constructor Create(AIDName: String);
    destructor Destroy; override;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
    procedure InitAlphaImages(ASkinData: TspSkinData); override;
  end;

  TspDataSkinCaptionMenuButton = class(TspDataSkinButton)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor, InActiveFontColor: TColor;
    LeftOffset, RightOffset: Integer;
    TopPosition: Integer;
    ClRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
    procedure InitAlphaImages(ASkinData: TspSkinData); override;
  end;

  TspDataSkinCaptionTab = class(TspDataSkinButton)
  public
    FontName: String;
    FontStyle: TFontStyles;
    FontHeight: Integer;
    FontColor, ActiveFontColor, DownFontColor: TColor;
    LeftOffset, RightOffset: Integer;
    TopPosition: Integer;
    ClRect: TRect;
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
    procedure InitAlphaImages(ASkinData: TspSkinData); override;
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
    StretchEffect: Boolean;
    StretchType: TspStretchType;
    constructor Create;
    procedure LoadFromFile(IniFile: TCustomIniFile);
    procedure SaveToFile(IniFile: TCustomIniFile);
  end;

  TspDataSkinLayerFrame = class(TObject)
  public
    PictureIndex: Integer;
    MaskPictureIndex: Integer;
    InActivePictureIndex: Integer;
    InActiveMaskPictureIndex: Integer;
    LTPoint, RTPoint, LBPoint, RBPoint: TPoint;
    ClRect: TRect;
    AlphaBlendValue: Integer;
    InActiveAlphaBlendValue: Integer;
    BorderRect: TRect;
    HitTestEnable: Boolean;
    FullBorder: Boolean;
    HitTestSize: Integer;
    CaptionRect: TRect;
    HitTestLTPoint,
    HitTestRTPoint,
    HitTestLBPoint,
    HitTestRBPoint: TPoint;
    //
    ButtonsRect: TRect;
    SysMenuButtonRect: TRect;
    FullStretch: Boolean;
    //
    RollUpFormHeight: Integer;
    ButtonsTopOffset: Integer;
    SysButtonTopOffset: Integer;
    //
    BlurMaskPictureIndex: Integer;
    IntersectBlurMaskRect: TRect;
    ExcludeBlurMaskRect: TRect;
    //
    LeftOffset, TopOffset, WidthOffset, HeightOffset: Integer;
    //
    FSourceBitmap, FSourceInActiveBitMap: TspBitMap;
    //
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(IniFile: TCustomIniFile);
    procedure SaveToFile(IniFile: TCustomIniFile);
    procedure InitAlphaImages(ASkinData: TspSkinData); 
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
    StretchEffect: Boolean;
    StretchType: TspStretchType;
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
    StretchEffect: Boolean;
    DividerStretchEffect: Boolean;
    InActiveStretchEffect: Boolean;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    InActiveAnimation: Boolean;
    ImageRct: TRect;
    UseImageColor: Boolean;
    ImageColor, ActiveImageColor: TColor;
    InActiveTransparent: Boolean;
    CheckImageRect, ActiveCheckImageRect: TRect;
    RadioImageRect, ActiveRadioImageRect: TRect;
    ArrowImageRect, ActiveArrowImageRect: TRect;
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
    StretchEffect: Boolean;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
    InActiveAnimation: Boolean;
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
    Light: Boolean;
    LightColor, ActiveLightColor: TColor;
    StretchEffect: Boolean;
    AnimateSkinRect: TRect;
    FrameCount: Integer;
    AnimateInterval: Integer;
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
    procedure LoadFromFile(IniFile: TCustomIniFile); override;
    procedure SaveToFile(IniFile: TCustomIniFile); override;
  end;

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
    procedure LoadFromCompressStream(Stream: TStream);
    procedure SaveToCompressStream(Stream: TStream);
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

  TspSkinColors = class(TObject)
  protected
    FcBtnFace: TColor;
    FcBtnText: TColor;
    FcWindow: TColor;
    FcWindowText: TColor;
    FcHighLight: TColor;
    FcHighLightText: TColor;
    FcBtnHighLight: TColor;
    FcBtnShadow: TColor;
    Fc3DLight: TColor;
    Fc3DDkShadow: TColor;
  public
    //
    constructor Create; 
    procedure LoadFromFile(IniFile: TCustomIniFile);
    procedure SaveToFile(IniFile: TCustomIniFile);
    procedure SetColorsToDefault;  
    //
    property cBtnFace: TColor read FcBtnFace write FcBtnFace; 
    property cBtnText: TColor read FcBtnText write FcBtnText;
    property cBtnHighLight: TColor read FcBtnHighLight write FcBtnHighLight;
    property cBtnShadow: TColor read FcBtnShadow write FcBtnShadow;
    property cHighLight: TColor read FcHighLight write FcHighLight;
    property cHighLightText: TColor read FcHighLightText write FcHighLightText;
    property cWindow: TColor read FcWindow write FcWindow;
    property cWindowText: TColor read FcWindowText write FcWindowText;
    property c3DLight: TColor read Fc3DLight write Fc3DLight;
    property c3DDkShadow: TColor read Fc3DDkShadow write Fc3DDkShadow;
  end;

  TspCompressedSkinList = class;

  TspSkinData = class(TComponent)
  protected
    FOnLoadData: TNotifyEvent;
    FCompressedSkinList: TspCompressedSkinList;
    FCompressedSkinIndex: Integer;
    FSkinnableForm: Boolean;
    FEnableSkinEffects: Boolean;
    FCompressedStoredSkin: TspCompressedStoredSkin;
    FResourceStrData: TspResourceStrData;
    FSkinColors: TspSkinColors;
    //
    FShowButtonGlowFrames: Boolean;
    FShowCaptionButtonGlowFrames: Boolean;
    FShowLayeredBorders: Boolean;
    FAeroBlurEnabled: Boolean;
    //
    FAnimationForAllWindows: Boolean;
    //
    FDlgTreeViewDrawSkin: Boolean;
    FDlgTreeViewItemSkinDataName: String;
    FDlgListViewDrawSkin: Boolean;
    FDlgListViewItemSkinDataName: String;
    //
    procedure SetAeroBlurEnabled(Value: Boolean);
    procedure SetShowLayeredBorders(Value: Boolean);
    procedure SetSkinnableForm(Value: Boolean);
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
    procedure GetAreaNameRect(S: String; var AName: String; var ARect: TRect;
      var AUseAnchors, AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom: Boolean);
    procedure SetCompressedSkinIndex(Value: Integer);
    procedure SetCompressedSkinList(Value: TspCompressedSkinList);
  public
    SizeGripArea: TRect;
    StatusBarName: String;
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
    LayerFrame: TspDataSkinLayerFrame;
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
    FormMinWidth: Integer;
    FormMinHeight: Integer;
    MDITabsTransparent: Boolean;
    MainMenuBarTransparent: Boolean;

    TopStretch, LeftStretch,
    RightStretch, BottomStretch: Boolean;
    StretchEffect: Boolean;
    StretchType: TspStretchType;
    MDIBGStretchEffect: Boolean;
    MDIBGStretchType: TspStretchType;
    
    RollUpLeftPoint, RollUpRightPoint: TPoint;

    SkinName: String;
    SkinAuthor: String;
    AuthorURL: String;
    AuthorEmail: String;
    SkinComments: String;

    ChangeSkinDataProcess: Boolean; 

    procedure SaveToCustomIniFile(F: TCustomIniFile);
    
    procedure AddBitMap(FileName: String);
    procedure DeleteBitMap(Index: Integer);

    procedure AddSkinArea(AName: String; ARect: TRect;
    AUseAnchors, AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom: Boolean);

    procedure SendSkinDataMessage(M: LongInt);

    function GetIndex(AIDName: String): Integer;
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
    procedure StoreToDisk(AFileName: String);
    //
    procedure LoadCompressedStoredSkin(AStoredSkin: TspCompressedStoredSkin);
    //
    procedure ClearSkin;

    procedure GlobalChangeFont(ANewFontName: String; AFontHeightCorrection: Integer);

    property SkinColors: TspSkinColors read FSkinColors;
  published
    property DlgTreeViewDrawSkin: Boolean
      read FDlgTreeViewDrawSkin write FDlgTreeViewDrawSkin;
    property  DlgTreeViewItemSkinDataName: String
      read FDlgTreeViewItemSkinDataName write FDlgTreeViewItemSkinDataName;
    property DlgListViewDrawSkin: Boolean
      read FDlgListViewDrawSkin write FDlgListViewDrawSkin;
    property  DlgListViewItemSkinDataName: String
      read FDlgListViewItemSkinDataName write FDlgListViewItemSkinDataName;
    //
    property AnimationForAllWindows: Boolean
      read FAnimationForAllWindows write FAnimationForAllWindows;
    property ShowLayeredBorders: Boolean
      read FShowLayeredBorders write SetShowLayeredBorders;
    property SkinnableForm: Boolean read FSkinnableForm write SetSkinnableForm;
    property EnableSkinEffects: Boolean read
      FEnableSkinEffects write FEnableSkinEffects;
    property AeroBlurEnabled: Boolean
      read FAeroBlurEnabled write SetAeroBlurEnabled;
    property ShowButtonGlowFrames: Boolean
      read FShowButtonGlowFrames write FShowButtonGlowFrames;
    property ShowCaptionButtonGlowFrames: Boolean
      read FShowCaptionButtonGlowFrames write FShowCaptionButtonGlowFrames;
    property CompressedStoredSkin: TspCompressedStoredSkin
      read FCompressedStoredSkin write SetCompressedStoredSkin;
    property ResourceStrData: TspResourceStrData
      read FResourceStrData write SetResourceStrData;
     property SkinList: TspCompressedSkinList
      read FCompressedSkinList write SetCompressedSkinList;
    property SkinIndex: Integer read
      FCompressedSkinIndex write SetCompressedSkinIndex;
    property OnLoadData: TNotifyEvent
     read FOnLoadData write FOnLoadData;
  end;


  TspSkinListItem = class(TCollectionItem)
  private
    FSkin: TspCompressedStoredSkin;
    FDescription: String;
    FFileName: String;
    FCompressedFileName: String;
    FName: string;
  protected
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
    procedure DefineProperties(Filer: TFiler); override;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Skin: TspCompressedStoredSkin read FSkin;
    procedure SetDescription(Value: String);
    procedure SetFileName(Value: String);
    procedure SetCompressedFileName(Value: String);
  published
    property Description: String read FDescription write SetDescription;
    property FileName: String read FFileName write SetFileName;
    property CompressedFileName: String read FCompressedFileName write SetCompressedFileName;
    property Name: string read FName write FName;
  end;

  TspSkinListItems = class(TCollection)
  private
    function GetItem(Index: Integer): TspSkinListItem;
    procedure SetItem(Index: Integer; Value:  TspSkinListItem);
  protected
    function GetOwner: TPersistent; override;
  public
    FSkinList: TspCompressedSkinList;
    constructor Create(ASkinList: TspCompressedSkinList);
    property Items[Index: Integer]:  TspSkinListItem read GetItem write SetItem; default;
  end;

  TspCompressedSkinList = class(TComponent)
  private
    FSkins: TspSkinListItems;
    procedure SetSkins(Value: TspSkinListItems);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Skins: TspSkinListItems read FSkins write SetSkins;
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
  WM_CHECKPARENTBG = WM_USER + 260;
  WM_CHANGEFORMSKINNABLE = WM_USER + 270;
  WM_SHOWLAYER = WM_USER + 400;
  WM_HIDELAYER = WM_USER + 401;
  WM_CHECKLAYEREDBORDER = WM_USER + 402;
  WM_SHOWLAYEREDBORDER = WM_USER + 403;
  WM_UPDATELAYEREDBORDER = WM_USER + 404;

  procedure WriteStretchType(IniFile: TCustomIniFile;
                             Section: String; Ident: String; ST: TspStretchType);


  function ReadStretchType(IniFile: TCustomIniFile;
                           Section: String; Ident: String): TspStretchType;
                             
implementation
   Uses spZLibCompress;
function CheckSkinFile(F: TCustomIniFile): Boolean;
begin
  Result := F.SectionExists('VERSION') and F.SectionExists('PICTURES') and
            F.SectionExists('FORMINFO') and F.SectionExists('SKINOBJECTS') and
            F.SectionExists('SKINCONTROLS');
end;



procedure WriteStretchType;
var
  S: String;
begin
  case ST of
    spstFull: S := 'stfull';
    spstVert: S := 'stvert';
    spstHorz: S := 'sthorz';
  end;
  IniFile.WriteString(Section, Ident, S);
end;


function ReadStretchType;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, 'stfull');
  if S = 'stfull'
  then
    Result := spstFull
  else
    if S = 'stvert'
    then
      Result := spstVert
    else
      Result := spstHorz;
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
  StretchEffect := False;
  ItemTransparent := False;
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
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  ItemTransparent := ReadBoolean(IniFile, IDName, 'itemtransparent');
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
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteBoolean(IniFile, IDName, 'itemtransparent', ItemTransparent);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  CaptionFontName := 'Tahoma';
  CaptionFontStyle := [];
  CaptionFontHeight := 13;
  CaptionFontColor := 0;
  HScrollBarName := '';
  VScrollBarName := '';
  BothScrollBarName := '';
  ShowFocus := False;
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
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  //
  CaptionRect := ReadRect(IniFile, IDName, 'captionrect');
  CaptionFontName := IniFile.ReadString(IDName, 'captionfontname', 'Tahoma');
  CaptionFontHeight := IniFile.ReadInteger(IDName, 'captionfontheight', 13);
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
  //
  ShowFocus := ReadBoolean(IniFile, IDName, 'showfocus');
  //
  DisabledButtonsRect := ReadRect(IniFile, IDName, 'disabledbuttonsrect');
  ButtonsArea := ReadRect(IniFile, IDName, 'buttonsarea');
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
  //
  WriteBoolean(IniFile, IDName, 'showfocus', ShowFocus);
  //
  WriteRect(IniFile, IDName, 'disabledbuttonsrect', DisabledButtonsRect);
  WriteRect(IniFile, IDName, 'buttonsarea', ButtonsArea);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  ActiveFontColor := 0;
  FocusFontColor := 0;
  ListBoxName := '';
  ShowFocus := False;
end;

procedure TspDataSkinComboBox.LoadFromFile;
begin
  inherited;
   ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  //
  SItemRect := ReadRect(IniFile, IDName, 'itemrect');
  ActiveItemRect := ReadRect(IniFile, IDName, 'activeitemrect');
  FocusItemRect := ReadRect(IniFile, IDName, 'focusitemrect');
  ItemLeftOffset := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRightOffset := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  ItemTextRect := ReadRect(IniFile, IDName, 'itemtextrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  //
  ListBoxName := IniFile.ReadString(IDName, 'listboxname', '');
  //
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  DownButtonRect := ReadRect(IniFile, IDName, 'downbuttonrect');
  UnEnabledButtonRect := ReadRect(IniFile, IDName, 'unenabledbuttonrect');
  //
  ItemStretchEffect := ReadBoolean(IniFile, IDName, 'itemstretcheffect');
  FocusItemStretchEffect := ReadBoolean(IniFile, IDName, 'focusitemstretcheffect');
  //
  ShowFocus := ReadBoolean(IniFile, IDName, 'showfocus');
end;

procedure TspDataSkinComboBox.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
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
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  //
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WriteRect(IniFile, IDName, 'downbuttonrect', DownButtonRect);
  WriteRect(IniFile, IDName, 'unenabledbuttonrect', UnEnabledButtonRect);
  //
  IniFile.WriteString(IDName, 'listboxname', ListBoxName);
  //
  WriteBoolean(IniFile, IDName, 'itemstretcheffect', ItemStretchEffect);
  WriteBoolean(IniFile, IDName, 'focusitemstretcheffect', FocusItemStretchEffect);
  WriteBoolean(IniFile, IDName, 'showfocus', ShowFocus);
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
  HGripRect := ReadRect(IniFile, IDName, 'hgriprect');
  VGripRect := ReadRect(IniFile, IDName, 'vgriprect');
  GripOffset1 := IniFile.ReadInteger(IDName, 'gripoffset1', 0);
  GripOffset2 := IniFile.ReadInteger(IDName, 'gripoffset2', 0);
  ItemStretchEffect := ReadBoolean(IniFile, IDName, 'itemstretcheffect');
  ItemOffset1 := IniFile.ReadInteger(IDName, 'itemoffset1', 3);
  ItemOffset2 := IniFile.ReadInteger(IDName, 'itemoffset2', 3);
  ItemTransparent := ReadBoolean(IniFile, IDName, 'itemtransparent');
  ItemTransparentColor := IniFile.ReadInteger(IDName, 'itemtransparentcolor', 0);
  GripTransparent := ReadBoolean(IniFile, IDName, 'griptransparent');
  GripTransparentColor := IniFile.ReadInteger(IDName, 'griptransparentcolor', 0);
end;

procedure TspDataSkinControlBar.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'itemrect', ItemRect);
  IniFile.WriteInteger(IDName, 'bgpictureindex', BGPictureIndex);
  WriteRect(IniFile, IDName, 'hgriprect', HGripRect);
  WriteRect(IniFile, IDName, 'vgriprect', VGripRect);
  IniFile.WriteInteger(IDName, 'gripoffset1', GripOffset1);
  IniFile.WriteInteger(IDName, 'gripoffset2', GripOffset2);
  IniFile.WriteInteger(IDName, 'itemoffset1', ItemOffset1);
  IniFile.WriteInteger(IDName, 'itemoffset2', ItemOffset2);
  WriteBoolean(IniFile, IDName, 'itemstretcheffect', ItemStretchEffect);
  WriteBoolean(IniFile, IDName, 'itemtransparent', ItemTransparent);
  IniFile.WriteInteger(IDName, 'itemtransparentcolor', ItemTransparentColor);
  WriteBoolean(IniFile, IDName, 'griptransparent', GripTransparent);
  IniFile.WriteInteger(IDName, 'griptransparentcolor', GripTransparentColor);
end;

constructor TspDataSkinTreeView.Create;
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinTreeView.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  BGColor := IniFile.ReadInteger(IDName, 'bgcolor', 0);
  ExpandImageRect := ReadRect(IniFile, IDName, 'expandimagerect');
  NoExpandImageRect := ReadRect(IniFile, IDName, 'noexpandimagerect');
end;

procedure TspDataSkinTreeView.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'bgcolor', BGColor);
  WriteRect(IniFile, IDName, 'expandimagerect', ExpandImageRect);
  WriteRect(IniFile, IDName, 'noexpandimagerect', NoExpandImageRect);
end;

constructor TspDataSkinListView.Create;
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinListView.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  BGColor := clWhite;
end;

procedure TspDataSkinRichEdit.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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

constructor TspDataSkinTabControl.Create(AIDName: String);
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  ActiveFontColor := 0;
  FocusFontColor := 0;
  UpDown := '';
  BGPictureIndex := -1;
  ShowFocus := False;
  FocusOffsetX := 0;
  FocusOffsetY := 0;
  ButtonTransparent := False;
  ButtonTransparentColor := clFuchsia; 
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
  TabStretchEffect := ReadBoolean(IniFile, IDName, 'tabstretcheffect');

  LeftStretch := ReadBoolean(IniFile, IDName, 'leftstretch');
  TopStretch := ReadBoolean(IniFile, IDName, 'topstretch');
  RightStretch := ReadBoolean(IniFile, IDName, 'rightstretch');
  BottomStretch := ReadBoolean(IniFile, IDName, 'bottomstretch');
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  StretchType :=  ReadStretchType(IniFile, IDName, 'stretchtype');

  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  MouseInFontColor := IniFile.ReadInteger(IDName, 'mouseinfontcolor', 0);

  UpDown := IniFile.ReadString(IDName, 'updown', '');

  ShowFocus := ReadBoolean(IniFile, IDName, 'showfocus');
  FocusOffsetX := IniFile.ReadInteger(IDName, 'focusoffsetx', 0);
  FocusOffsetY := IniFile.ReadInteger(IDName, 'focusoffsety', 0);

  CloseButtonRect := ReadRect(IniFile, IDName, 'closebuttonrect');
  CloseButtonActiveRect := ReadRect(IniFile, IDName, 'closebuttonactiverect');
  CloseButtonDownRect := ReadRect(IniFile, IDName, 'closebuttondownrect');

  ButtonTransparent := ReadBoolean(IniFile, IDName, 'buttontransparent');
  ButtonTransparentColor := IniFile.ReadInteger(IDName, 'buttontransparentcolor', 0);

  TabLeftBottomActiveRect := ReadRect(IniFile, IDName, 'tableftbottomactiverect');
  TabLeftBottomFocusRect := ReadRect(IniFile, IDName, 'tableftbottomfocusrect');
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
  WriteBoolean(IniFile, IDName, 'tabstretcheffect', TabStretchEffect);

  WriteBoolean(IniFile, IDName, 'leftstretch', LeftStretch);
  WriteBoolean(IniFile, IDName, 'topstretch', TopStretch);
  WriteBoolean(IniFile, IDName, 'topstretch', RightStretch);
  WriteBoolean(IniFile, IDName, 'bottomstretch', BottomStretch);
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteStretchType(IniFile, IDName, 'stretchtype', StretchType);

  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'focusfontcolor', FocusFontColor);
  IniFile.WriteInteger(IDName, 'mouseinfontcolor', MouseInFontColor);
  IniFile.WriteString(IDName, 'updown', UpDown);
  WriteBoolean(IniFile, IDName, 'showfocus', ShowFocus);
  IniFile.WriteInteger(IDName, 'focusoffsetx', FocusOffsetX);
  IniFile.WriteInteger(IDName, 'focusoffsety', FocusOffsetY);

  WriteRect(IniFile, IDName, 'closebuttonrect', CloseButtonRect);
  WriteRect(IniFile, IDName, 'closebuttonactiverect', CloseButtonActiveRect);
  WriteRect(IniFile, IDName, 'closebuttondownrect', CloseButtonDownRect);

  WriteBoolean(IniFile, IDName, 'buttontransparent', ButtonTransparent);
  IniFile.WriteInteger(IDName, 'buttontransparentcolor',  ButtonTransparentColor);

  WriteRect(IniFile, IDName, 'tableftbottomactiverect', TabLeftBottomActiveRect);
  WriteRect(IniFile, IDName, 'tableftbottomfocusrect', TabLeftBottomFocusRect);
end;

constructor TspDataSkinGridControl.Create;
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  FixedFontName := 'Tahoma';
  FixedFontStyle := [];
  FixedFontHeight := 13;
  FixedFontColor := 0;
  BGPictureIndex := -1;
  ShowFocus := False;
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
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  SelectFontColor := IniFile.ReadInteger(IDName, 'selectfontcolor', 0);
  FocusFontColor := IniFile.ReadInteger(IDName, 'focusfontcolor', 0);
  //
  FixedFontName := IniFile.ReadString(IDName, 'fixedfontname', 'Tahoma');
  FixedFontHeight := IniFile.ReadInteger(IDName, 'fixedfontheight', 13);
  FixedFontStyle := ReadFontStyles(IniFile, IDName, 'fixedfontstyle');
  FixedFontColor := IniFile.ReadInteger(IDName, 'fixedfontcolor', 0);
  //
  CellStretchEffect := ReadBoolean(IniFile, IDName, 'cellstretcheffect');
  FixedCellStretchEffect := ReadBoolean(IniFile, IDName, 'fixedcellstretcheffect');
  ShowFocus := ReadBoolean(IniFile, IDName, 'showfocus');
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
  //
  WriteBoolean(IniFile, IDName, 'cellstretcheffect', CellStretchEffect);
  WriteBoolean(IniFile, IDName, 'fixedcellstretcheffect', FixedCellStretchEffect);
  WriteBoolean(IniFile, IDName, 'showfocus', ShowFocus);
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
  StretchEffect := False;
  LeftStretch := False;
  TopStretch := False;
  RightStretch := False;
  BottomStretch := False;
  StretchType := spstFull;
end;

procedure TspDataSkinCustomControl.LoadFromFile;
begin
  inherited;
  LTPoint := ReadPoint(IniFile, IDName, 'lefttoppoint');
  RTPoint := ReadPoint(IniFile, IDName, 'righttoppoint');
  LBPoint := ReadPoint(IniFile, IDName, 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, IDName, 'rightbottompoint');
  ClRect := ReadRect(IniFile, IDName, 'clientrect');
  LeftStretch := ReadBoolean(IniFile, IDName, 'leftstretch');
  TopStretch := ReadBoolean(IniFile, IDName, 'topstretch');
  RightStretch := ReadBoolean(IniFile, IDName, 'rightstretch');
  BottomStretch := ReadBoolean(IniFile, IDName, 'bottomstretch');
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  StretchType :=  ReadStretchType(IniFile, IDName, 'stretchtype');
end;

procedure TspDataSkinCustomControl.SaveToFile;
begin
  inherited;
  WritePoint(IniFile, IDName, 'lefttoppoint', LTPoint);
  WritePoint(IniFile, IDName, 'righttoppoint', RTPoint);
  WritePoint(IniFile, IDName, 'leftbottompoint', LBPoint);
  WritePoint(IniFile, IDName, 'rightbottompoint', RBPoint);
  WriteRect(IniFile, IDName, 'clientrect', ClRect);
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteBoolean(IniFile, IDName, 'leftstretch', LeftStretch);
  WriteBoolean(IniFile, IDName, 'topstretch', TopStretch);
  WriteBoolean(IniFile, IDName, 'rightstretch', RightStretch);
  WriteBoolean(IniFile, IDName, 'bottomstretch', BottomStretch);
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteStretchType(IniFile, IDName, 'stretchtype', StretchType);
end;


constructor TspDataSkinSpinEditControl.Create;
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
end;

procedure TspDataSkinSpinEditControl.LoadFromFile;
begin
  inherited;
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
end;

procedure TspDataSkinEditControl.LoadFromFile;
begin
  inherited;
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := clBlue;
end;

procedure TspDataSkinStdLabelControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
end;

procedure TspDataSkinLabelControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  ThumbTransparent := False;
  ThumbTransparentColor := clFuchsia;
  ThumbStretchEffect := False;
  ThumbMinSize := 0;
  ThumbMinPageSize := 0;
  GlyphTransparent := False;
  GlyphTransparentColor := clFuchsia;
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
  ThumbTransparent := ReadBoolean(IniFile, IDName, 'thumbtransparent');
  ThumbTransparentColor := IniFile.ReadInteger(IDName, 'thumbtransparentcolor', 0);
  ThumbStretchEffect := ReadBoolean(IniFile, IDName, 'thumbstretcheffect');
  ThumbMinSize := IniFile.ReadInteger(IDName, 'thumbminsize', 0);
  ThumbMinPageSize := IniFile.ReadInteger(IDName, 'thumbminpagesize', 0);

  GlyphRect := ReadRect(IniFile, IDName, 'glyphrect');
  ActiveGlyphRect := ReadRect(IniFile, IDName, 'activeglyphrect');
  DownGlyphRect := ReadRect(IniFile, IDName, 'downglyphrect');
  
  GlyphTransparent := ReadBoolean(IniFile, IDName, 'glyphtransparent');
  GlyphTransparentColor := IniFile.ReadInteger(IDName, 'glyphtransparentcolor', 0);
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
  WriteBoolean(IniFile, IDName, 'thumbtransparent', ThumbTransparent);
  IniFile.WriteInteger(IDName, 'thumbtransparentcolor', ThumbTransparentColor);
  WriteBoolean(IniFile, IDName, 'thumbstretcheffect', ThumbStretchEffect);
  IniFile.WriteInteger(IDName, 'thumbminsize', ThumbMinSize);
  IniFile.WriteInteger(IDName, 'thumbminpagesize', ThumbMinPageSize);

  WriteRect(IniFile, IDName, 'glyphrect', GlyphRect);
  WriteRect(IniFile, IDName, 'activeglyphrect', ActiveGlyphRect);
  WriteRect(IniFile, IDName, 'downglyphrect', DownGlyphRect);

  WriteBoolean(IniFile, IDName, 'glyphtransparent', GlyphTransparent);
  IniFile.WriteInteger(IDName, 'glyphtransparentcolor', GlyphTransparentColor);
end;

constructor TspDataSkinTrackBarControl.Create;
begin
  inherited;
  TrackArea := NullRect;
  ButtonRect := NullRect;
  ActiveButtonRect := NullRect;
  Vertical := False;
  ButtonTransparent := False;
  ButtonTransparentColor := clFuchsia;
  ActiveSkinRect := NullRect;
end;

procedure TspDataSkinTrackBarControl.LoadFromFile;
begin
  inherited;
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  TrackArea := ReadRect(IniFile, IDName, 'trackarea');
  ButtonRect := ReadRect(IniFile, IDName, 'buttonrect');
  ActiveButtonRect := ReadRect(IniFile, IDName, 'activebuttonrect');
  Vertical := ReadBoolean(IniFile, IDName, 'vertical');
  ButtonTransparent := ReadBoolean(IniFile, IDName, 'buttontransparent');
  ButtonTransparentColor := IniFile.ReadInteger(IDName, 'buttontransparentcolor', 0);
end;

procedure TspDataSkinTrackBarControl.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  WriteRect(IniFile, IDName, 'trackarea', TrackArea);
  WriteRect(IniFile, IDName, 'buttonrect', ButtonRect);
  WriteRect(IniFile, IDName, 'activebuttonrect', ActiveButtonRect);
  WriteBoolean(IniFile, IDName, 'vertical', Vertical);
  WriteBoolean(IniFile, IDName, 'buttontransparent', ButtonTransparent);
  IniFile.WriteInteger(IDName, 'buttontransparentcolor', ButtonTransparentColor);
end;

constructor TspDataSkinSplitterControl.Create(AIDName: String);
begin
  inherited;
  GripperRect := NullRect;
  GripperTransparent := False;
  GripperTransparentColor := clFuchsia;
end;

procedure TspDataSkinSplitterControl.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  GripperRect := ReadRect(IniFile, IDName, 'gripperrect');
  GripperTransparent := ReadBoolean(IniFile, IDName, 'grippertransparent');
  GripperTransparentColor := IniFile.ReadInteger(IDName, 'grippertransparentcolor', 0);
end;

procedure TspDataSkinSplitterControl.SaveToFile(IniFile: TCustomIniFile);
begin
  inherited;
  WriteRect(IniFile, IDName, 'gripperrect', GripperRect);
  WriteBoolean(IniFile, IDName, 'grippertransparent', GripperTransparent);
  IniFile.WriteInteger(IDName, 'grippertransparentcolor', GripperTransparentColor);
end;

constructor TspDataSkinGaugeControl.Create;
begin
  inherited;
  ProgressArea := NullRect;
  ProgressRect := NullRect;
  Vertical := False;
  BeginOffset := 0;
  EndOffset := 0;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 13;
  FontColor := 0;
  ProgressTransparent := False;
  ProgressTransparentColor := clFuchsia;
  ProgressStretch := False;
  AnimationBeginOffset := 0;
  AnimationEndOffset := 0;
end;

procedure TspDataSkinGaugeControl.LoadFromFile;
begin
  inherited;
  ProgressArea := ReadRect(IniFile, IDName, 'progressarea');
  ProgressRect := ReadRect(IniFile, IDName, 'progressrect');
  BeginOffset := IniFile.ReadInteger(IDName, 'beginoffset', 0);
  EndOffset := IniFile.ReadInteger(IDName, 'endoffset', 0);
  Vertical := ReadBoolean(IniFile, IDName, 'vertical');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ProgressTransparent := ReadBoolean(IniFile, IDName, 'progresstransparent');
  ProgressTransparentColor := IniFile.ReadInteger(IDName, 'progresstransparentcolor', 0);
  ProgressStretch := ReadBoolean(IniFile, IDName, 'progressstretch');
  AnimationSkinRect := ReadRect(IniFile, IDName, 'animationskinrect');
  AnimationCountFrames := IniFile.ReadInteger(IDName, 'animationcountframes', 0);
  AnimationTimerInterval := IniFile.ReadInteger(IDName, 'animationtimerinterval', 0);
  ProgressAnimationSkinRect := ReadRect(IniFile, IDName, 'progressanimationskinrect');
  ProgressAnimationCountFrames := IniFile.ReadInteger(IDName, 'progressanimationcountframes', 0);
  ProgressAnimationTimerInterval := IniFile.ReadInteger(IDName, 'progressanimationtimerinterval', 0);
  AnimationBeginOffset := IniFile.ReadInteger(IDName, 'animationbeginoffset', 0);
  AnimationEndOffset := IniFile.ReadInteger(IDName, 'animationendoffset', 0);
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
  WriteBoolean(IniFile, IDName, 'progresstransparent', ProgressTransparent);
  IniFile.WriteInteger(IDName, 'progresstransparentcolor', ProgressTransparentColor);
  WriteBoolean(IniFile, IDName, 'progressstretch', ProgressStretch);
  WriteRect(IniFile, IDName, 'animationskinrect', AnimationSkinRect);
  IniFile.WriteInteger(IDName, 'animationcountframes', AnimationCountFrames);
  IniFile.WriteInteger(IDName, 'animationtimerinterval', AnimationTimerInterval);
  WriteRect(IniFile, IDName, 'progressanimationskinrect', ProgressAnimationSkinRect);
  IniFile.WriteInteger(IDName, 'progressanimationcountframes', ProgressAnimationCountFrames);
  IniFile.WriteInteger(IDName, 'progressanimationtimerinterval', ProgressAnimationTimerInterval);
  IniFile.WriteInteger(IDName, 'animationbeginoffset', AnimationBeginOffset);
  IniFile.WriteInteger(IDName, 'animationendoffset', AnimationEndOffset);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  Alignment := taCenter;
  BGPictureIndex := -1;
  GripperRect := NullRect;
  GripperTransparent := False;
  GripperTransparentColor := clFuchsia;
end;

procedure TspDataSkinPanelControl.LoadFromFile;
begin
  inherited;
  BGPictureIndex := IniFile.ReadInteger(IDName, 'bgpictureindex', -1);
  CaptionRect := ReadRect(IniFile, IDName, 'captionrect');
  Alignment := ReadAlignment(IniFile, IDName, 'alignment');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  CheckImageRect := ReadRect(IniFile, IDName, 'checkimagerect');
  UnCheckImageRect := ReadRect(IniFile, IDName, 'uncheckimagerect');
  //
  MarkFrameRect := ReadRect(IniFile, IDName, 'markframerect');
  FrameRect := ReadRect(IniFile, IDName, 'framerect');
  FrameTextRect := ReadRect(IniFile, IDName, 'frametextrect');
  FrameLeftOffset := IniFile.ReadInteger(IDName, 'frameleftoffset', 0);
  FrameRightOffset := IniFile.ReadInteger(IDName, 'framerightoffset', 0);
  //
  GripperRect := ReadRect(IniFile, IDName, 'gripperrect');
  GripperTransparent := ReadBoolean(IniFile, IDName, 'grippertransparent');
  GripperTransparentColor := IniFile.ReadInteger(IDName, 'grippertransparentcolor', 0);
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
  //
  WriteRect(IniFile, IDName, 'markframerect', MarkFrameRect);
  WriteRect(IniFile, IDName, 'framerect', FrameRect);
  WriteRect(IniFile, IDName, 'frametextrect', FrameTextRect);
  IniFile.WriteInteger(IDName, 'frameleftoffset', FrameLeftOffset);
  IniFile.WriteInteger(IDName, 'framerightoffset', FrameRightOffset);
  //
  WriteRect(IniFile, IDName, 'gripperrect', GripperRect);
  WriteBoolean(IniFile, IDName, 'grippertransparent', GripperTransparent);
  IniFile.WriteInteger(IDName, 'grippertransparentcolor', GripperTransparentColor);
end;

constructor TspDataSkinExPanelControl.Create(AIDName: String);
begin
  inherited;
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ButtonsTransparent := False;
  ButtonsTransparentColor := clFuchsia;
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
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  //
  ButtonsTransparent := ReadBoolean(IniFile, IDName, 'buttonstransparent');
  ButtonsTransparentColor := IniFile.ReadInteger(IDName, 'buttonstransparentcolor', 0);
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
  //
  WriteBoolean(IniFile, IDName, 'buttonstransparent', ButtonsTransparent);
  IniFile.WriteInteger(IDName, 'buttonstransparentcolor', ButtonsTransparentColor);
end;

constructor TspDataSkinCheckRadioControl.Create;
begin
  inherited;
  FontName := 'Tahoma';
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
  GrayedCheckImageRect := NullRect;
  ActiveGrayedCheckImageRect := NullRect;
end;

procedure TspDataSkinCheckRadioControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  GrayedCheckImageRect := ReadRect(IniFile, IDName, 'grayedcheckimagerect');
  ActiveGrayedCheckImageRect := ReadRect(IniFile, IDName, 'activegrayedcheckimagerect');
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
  WriteRect(IniFile, IDName, 'grayedcheckimagerect', GrayedCheckImageRect);
  WriteRect(IniFile, IDName, 'activegrayedcheckimagerect', ActiveGrayedCheckImageRect);
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
  FontName := 'Tahoma';
  FontStyle := [];
  FontHeight := 12;
  FontColor := 0;
  ActiveFontColor := 0;
  DownFontColor := 0;
  FontColor := 0;
  ActiveSkinRect := NullRect;
  DownSkinRect := NullRect;
  MorphKind := mkDefault;
  ShowFocus := False;
  FocusedSkinRect := NullRect;
  //
  GlowLayerPictureIndex := -1;
  GlowLayerMaskPictureIndex := -1;
  GlowLayerOffsetLeft := 0;
  GlowLayerOffsetTop := 0;
  GlowLayerOffsetRight := 0;
  GlowLayerOffsetBottom := 0;
  GlowLayerShowOffsetX := 0;
  GlowLayerShowOffsetY := 0;
  GlowLayerAlphaBlendValue := 255;
  //
end;

procedure TspDataSkinButtonControl.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DisabledFontColor := IniFile.ReadInteger(IDName, 'disabledfontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  Morphing := ReadBoolean(IniFile, IDName, 'morphing');
  MorphKind := ReadMorphKind(IniFile, IDName, 'morphkind');
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  DownSkinRect := ReadRect(IniFile, IDName, 'downskinrect');
  FocusedSkinRect := ReadRect(IniFile, IDName, 'focusedskinrect');
  DisabledSkinRect := ReadRect(IniFile, IDName, 'disabledskinrect');
  AnimateSkinRect := ReadRect(IniFile, IDName, 'animateskinrect');
  FrameCount := IniFile.ReadInteger(IDName, 'framecount', 0);
  AnimateInterval := IniFile.ReadInteger(IDName, 'animateinterval', 25);
  ShowFocus := ReadBoolean(IniFile, IDName, 'showfocus');
  //
  MenuMarkerFlatRect := ReadRect(IniFile, IDName, 'menumarkerflatrect');
  MenuMarkerRect := ReadRect(IniFile, IDName, 'menumarkerrect');
  MenuMarkerActiveRect := ReadRect(IniFile, IDName, 'menumarkeractiverect');
  MenuMarkerDownRect := ReadRect(IniFile, IDName, 'menumarkerdownrect');
  MenuMarkerTransparentColor := IniFile.ReadInteger(IDName, 'menumarkertransparentcolor', 0);
  //
  GlowLayerPictureIndex := IniFile.ReadInteger(IDName, 'glowlayerpictureindex', -1);
  GlowLayerMaskPictureIndex := IniFile.ReadInteger(IDName, 'glowlayermaskpictureindex', -1);
  GlowLayerOffsetLeft := IniFile.ReadInteger(IDName, 'glowlayeroffsetleft', 0);
  GlowLayerOffsetTop := IniFile.ReadInteger(IDName, 'glowlayeroffsettop', 0);
  GlowLayerOffsetRight := IniFile.ReadInteger(IDName, 'glowlayeroffsetright', 0);
  GlowLayerOffsetBottom := IniFile.ReadInteger(IDName, 'glowlayeroffsetbottom', 0);
  GlowLayerShowOffsetX := IniFile.ReadInteger(IDName, 'glowlayershowoffsetx', 0);
  GlowLayerShowOffsetY := IniFile.ReadInteger(IDName, 'glowlayershowoffsety', 0);
  GlowLayerAlphaBlendValue := IniFile.ReadInteger(IDName, 'glowlayeralphablendvalue', 255);
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
  WriteRect(IniFile, IDName, 'focusedskinrect', FocusedSkinRect);
  WriteRect(IniFile, IDName, 'disabledskinrect', DisabledSkinRect);
  WriteRect(IniFile, IDName, 'animateskinrect', AnimateSkinRect);
  IniFile.WriteInteger(IDName, 'framecount',   FrameCount);
  IniFile.WriteInteger(IDName, 'animateinterval',   AnimateInterval);
  WriteBoolean(IniFile, IDName, 'showfocus', ShowFocus);
  //
  WriteRect(IniFile, IDName, 'menumarkerflatrect', MenuMarkerFlatRect);
  WriteRect(IniFile, IDName, 'menumarkerrect', MenuMarkerRect);
  WriteRect(IniFile, IDName, 'menumarkeractiverect', MenuMarkerActiveRect);
  WriteRect(IniFile, IDName, 'menumarkerdownrect', MenuMarkerDownRect);
  IniFile.WriteInteger(IDName, 'menumarkertransparentcolor',   MenuMarkerTransparentColor);
  //
  IniFile.WriteInteger(IDName, 'glowlayerpictureindex', GlowLayerPictureIndex);
  IniFile.WriteInteger(IDName, 'glowlayermaskpictureindex', GlowLayerMaskPictureIndex);
  IniFile.WriteInteger(IDName, 'glowlayeroffsetleft', GlowLayerOffsetLeft);
  IniFile.WriteInteger(IDName, 'glowlayeroffsetright', GlowLayerOffsetRight);
  IniFile.WriteInteger(IDName, 'glowlayeroffsettop', GlowLayerOffsetTop);
  IniFile.WriteInteger(IDName, 'glowlayeroffsetbottom', GlowLayerOffsetBottom);
  IniFile.WriteInteger(IDName, 'glowlayershowoffsetx', GlowLayerShowOffsetX);
  IniFile.WriteInteger(IDName, 'glowlayershowoffsety', GlowLayerShowOffsetY);
  IniFile.WriteInteger(IDName, 'glowlayeralphablendvalue', GlowLayerAlphaBlendValue);
end;

constructor TspDataSkinArea.Create;
begin
  IDName := AIDName;
  AreaRect := ARect;
  UseAnchors := AUseAnchors;
  AnchorLeft := AAnchorLeft;
  AnchorTop := AAnchorTop;
  AnchorRight := AAnchorRight;
  AnchorBottom := AAnchorBottom;
end;

constructor TspDataSkinObject.Create;
begin
  IDName := AIDName;
  Hint := '';
  ActivePictureIndex := -1;
  ActiveMaskPictureIndex := -1;
  SkinRect := NullRect;
  ActiveSkinRect := SkinRect;
  InActiveSkinRect := SkinRect;
  Morphing := False;
  CursorIndex := -1;
  RollUp := False;
  GlowLayerPictureIndex := -1;
  GlowLayerMaskPictureIndex := -1;
  GlowLayerOffsetX := 0;
  GlowLayerOffsetY := 0;
  GlowLayerAlphaBlendValue := 255;
end;

procedure TspDataSkinObject.InitAlphaImages;
begin
end;

procedure TspDataSkinObject.LoadFromFile;
begin
  Hint := IniFile.ReadString(IDName, 'hint', '');
  RollUp := ReadBoolean(IniFile, IDName, 'rollup');
  ActivePictureIndex := IniFile.ReadInteger(IDName, 'activepictureindex', -1);
  ActiveMaskPictureIndex := IniFile.ReadInteger(IDName, 'activemaskpictureindex', -1);
  SkinRectInAPicture := ReadBoolean(IniFile, IDName, 'skinrectinapicture');
  CursorIndex := IniFile.ReadInteger(IDName, 'cursorindex', -1);
  SkinRect := ReadRect(IniFile, IDName, 'skinrect');
  ActiveSkinRect := ReadRect(IniFile, IDName, 'activeskinrect');
  InActiveSkinRect := ReadRect(IniFile, IDName, 'inactiveskinrect');
  Morphing := ReadBoolean(IniFile, IDName, 'morphing');
  MorphKind := ReadMorphKind(IniFile, IDName, 'morphkind');
  //
  GlowLayerPictureIndex := IniFile.ReadInteger(IDName, 'glowlayerpictureindex', -1);
  GlowLayerMaskPictureIndex := IniFile.ReadInteger(IDName, 'glowlayermaskpictureindex', -1);
  GlowLayerOffsetX := IniFile.ReadInteger(IDName, 'glowlayeroffsetx', 0);
  GlowLayerOffsetY := IniFile.ReadInteger(IDName, 'glowlayeroffsety', 0);
  GlowLayerAlphaBlendValue := IniFile.ReadInteger(IDName, 'glowlayeralphablendvalue', 255);
end;

procedure TspDataSkinObject.SaveToFile;
begin
  IniFile.EraseSection(IDName);
  IniFile.WriteString(IDName, 'hint', Hint);
  WriteBoolean(IniFile, IDName, 'rollup',  RollUp);
  IniFile.WriteInteger(IDName, 'activepictureindex', ActivePictureIndex);
  IniFile.WriteInteger(IDName, 'activemaskpictureindex', ActiveMaskPictureIndex);
  WriteBoolean(IniFile, IDName, 'skinrectinapicture', SkinRectInAPicture);
  IniFile.WriteInteger(IDName, 'cursorindex', CursorIndex);
  WriteRect(IniFile, IDName, 'skinrect', SkinRect);
  WriteRect(IniFile, IDName, 'activeskinrect', ActiveSkinRect);
  WriteRect(IniFile, IDName, 'inactiveskinrect', InActiveSkinRect);
  WriteBoolean(IniFile, IDName, 'morphing', Morphing);
  WriteMorphKind(IniFile, IDName, 'morphkind', MorphKind);
  //
  IniFile.WriteInteger(IDName, 'glowlayerpictureindex', GlowLayerPictureIndex);
  IniFile.WriteInteger(IDName, 'glowlayermaskpictureindex', GlowLayerMaskPictureIndex);
  IniFile.WriteInteger(IDName, 'glowlayeroffsetx', GlowLayerOffsetX);
  IniFile.WriteInteger(IDName, 'glowlayeroffsety', GlowLayerOffsetY);
  IniFile.WriteInteger(IDName, 'glowlayeralphablendvalue', GlowLayerAlphaBlendValue);
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
  ButtonTransparent := ReadBoolean(IniFile, IDName, 'buttontransparent');
  ButtonTransparentColor := IniFile.ReadInteger(IDName, 'buttontransparentcolor', 0);
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
  WriteBoolean(IniFile, IDName, 'buttontransparent', ButtonTransparent);
  IniFile.WriteInteger(IDName, 'buttontransparentcolor', ButtonTransparentColor);
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
  DownSkinRect := ReadRect(IniFile, IDName, 'downskinrect');
  RestoreRect := ReadRect(IniFile, IDName, 'restorerect');
  RestoreActiveRect := ReadRect(IniFile, IDName, 'restoreactiverect');
  RestoreDownRect := ReadRect(IniFile, IDName, 'restoredownrect');
  RestoreInActiveRect := ReadRect(IniFile, IDName, 'restoreinactiverect');
  RestoreHint := IniFile.ReadString(IDName, 'restorehint', '');
  if (RestoreHint = '') and (Hint = 'Maximize') and (Command = cmMaximize)
  then
    RestoreHint := 'Restore';
  if (RestoreHint = '') and (Hint = 'Minimize') and (Command = cmMinimize)
  then
    RestoreHint := 'Restore';
  if (RestoreHint = '') and ((Hint = 'RollUp') or (Hint = 'Roll Up')) and
     (Command = cmRollUp)
  then
    RestoreHint := 'Restore';
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
  WriteRect(IniFile, IDName, 'downskinrect', DownSkinRect);
  WriteRect(IniFile, IDName, 'restorerect', RestoreRect);
  WriteRect(IniFile, IDName, 'restoreactiverect', RestoreActiveRect);
  WriteRect(IniFile, IDName, 'restoredownrect', RestoreDownRect);
  WriteRect(IniFile, IDName, 'restoreinactiverect', RestoreInActiveRect);
  IniFile.WriteString(IDName, 'restorehint', RestoreHint);
end;


constructor TspDataSkinLayerFrame.Create;
begin
  inherited;
  PictureIndex := -1;
  MaskPictureIndex := -1;
  InActivePictureIndex := -1;
  InActiveMaskPictureIndex := -1;
  LTPoint := Point(0, 0);
  LBPoint := Point(0, 0);
  RTPoint := Point(0, 0);
  RBPoint := Point(0, 0);
  ClRect := NullRect;
  HitTestEnable := False;
  BorderRect := NullRect;
  AlphaBlendValue := 255;
  InActiveAlphaBlendValue := 255;
  FullBorder := False;
  HitTestSize := 0;
  CaptionRect := Rect(0, 0, 0, 0);
  ButtonsRect := Rect(0, 0, 0, 0);
  SysMenuButtonRect := Rect(0, 0, 0, 0);
  FullStretch := False;
  RollUpFormHeight := 0;
  ButtonsTopOffset := 0;
  SysButtonTopOffset := 0;
  BlurMaskPictureIndex := -1;
  IntersectBlurMaskRect := Rect(0, 0, 0, 0);
  ExcludeBlurMaskRect := Rect(0, 0, 0, 0);
  LeftOffset := 0;
  TopOffset := 0;
  WidthOffset := 0;
  HeightOffset := 0;
  FSourceBitMap := nil;
  FSourceInactiveBitMap := nil;
end;

destructor TspDataSkinLayerFrame.Destroy;
begin
  if FSourceBitMap <> nil then FSourceBitMap.Free;
  if FSourceInActiveBitMap <> nil then FSourceInActiveBitMap.Free;
  inherited;
end;

procedure TspDataSkinLayerFrame.InitAlphaImages(ASkinData: TspSkinData);
var
  FSourceMask: TspBitmap;
  AImage, AMaskImage: TBitmap;
begin
  if FSourceBitMap <> nil
  then
    begin
      FSourceBitMap.Free;
      FSourceBitMap := nil;
    end;  

  if (PictureIndex <> -1) and (MaskPictureIndex <> -1) and
     (PictureIndex < ASkinData.FActivePictures.Count) and
     (MaskPictureIndex < ASkinData.FActivePictures.Count)
  then
    begin
      AImage := TBitMap(ASkinData.FActivePictures.Items[PictureIndex]);
      AMaskImage := TBitMap(ASkinData.FActivePictures.Items[MaskPictureIndex]);
      FSourceBitMap := TspBitMap.Create;
      FSourceBitMap.Assign(AImage);
      FSourceMask := TspBitMap.Create;
      FSourceMask.Assign(AMaskImage);
      CreateAlphaByMask(FSourceBitmap, FSourceMask);
      FSourceBitmap.CheckingAlphaBlend;
      FSourceMask.Free;
    end;


  if FSourceInActiveBitMap <> nil
  then
    begin
      FSourceInActiveBitMap.Free;
      FSourceInActiveBitMap := nil;
    end;

  if (InActivePictureIndex <> -1) and (InActiveMaskPictureIndex <> -1) and
     (InActivePictureIndex < ASkinData.FActivePictures.Count) and
     (InActiveMaskPictureIndex < ASkinData.FActivePictures.Count)
  then
    begin
      AImage := TBitMap(ASkinData.FActivePictures.Items[InActivePictureIndex]);
      AMaskImage := TBitMap(ASkinData.FActivePictures.Items[InActiveMaskPictureIndex]);
      FSourceInActiveBitMap := TspBitMap.Create;
      FSourceInActiveBitMap.Assign(AImage);
      FSourceMask := TspBitMap.Create;
      FSourceMask.Assign(AMaskImage);
      CreateAlphaByMask(FSourceInActiveBitmap, FSourceMask);
      FSourceInActiveBitmap.CheckingAlphaBlend;
      FSourceMask.Free;
    end;
end;

procedure TspDataSkinLayerFrame.LoadFromFile;
begin
  PictureIndex := IniFile.ReadInteger('LAYERFRAME', 'pictureindex', -1);
  MaskPictureIndex := IniFile.ReadInteger('LAYERFRAME', 'maskpictureindex', -1);
  InActivePictureIndex := IniFile.ReadInteger('LAYERFRAME', 'inactivepictureindex', -1);
  InActiveMaskPictureIndex := IniFile.ReadInteger('LAYERFRAME', 'inactivemaskpictureindex', -1);
  LTPoint := ReadPoint(IniFile, 'LAYERFRAME', 'lefttoppoint');
  RTPoint := Readpoint(IniFile, 'LAYERFRAME', 'righttoppoint');
  LBPoint := ReadPoint(IniFile, 'LAYERFRAME', 'leftbottompoint');
  RBPoint := ReadPoint(IniFile, 'LAYERFRAME', 'rightbottompoint');
  ClRect := ReadRect(IniFile, 'LAYERFRAME', 'clientrect');
  AlphaBlendValue := IniFile.ReadInteger('LAYERFRAME', 'alphablendvalue', 255);
  InActiveAlphaBlendValue := IniFile.ReadInteger('LAYERFRAME', 'inactivealphablendvalue', 255);
  BorderRect := ReadRect(IniFile, 'LAYERFRAME', 'borderrect');
  HitTestEnable := ReadBoolean(IniFile, 'LAYERFRAME', 'hittestenable');
  FullBorder := ReadBoolean(IniFile, 'LAYERFRAME', 'fullborder');
  HitTestSize := IniFile.ReadInteger('LAYERFRAME', 'hittestsize', 0);
  CaptionRect := ReadRect(IniFile, 'LAYERFRAME', 'captionrect');
  HitTestLTPoint := ReadPoint(IniFile, 'LAYERFRAME', 'hittestlefttoppoint');
  HitTestRTPoint := ReadPoint(IniFile, 'LAYERFRAME', 'hittestrighttoppoint');
  HitTestLBPoint := ReadPoint(IniFile, 'LAYERFRAME', 'hittestleftbottompoint');
  HitTestRBPoint := ReadPoint(IniFile, 'LAYERFRAME', 'hittestrightbottompoint');
  //
  ButtonsRect := ReadRect(IniFile, 'LAYERFRAME', 'buttonsrect');
  SysMenuButtonRect := ReadRect(IniFile, 'LAYERFRAME', 'sysmenubuttonrect');
  FullStretch := ReadBoolean(IniFile, 'LAYERFRAME', 'fullstretch');
  //
  RollUpFormHeight := IniFile.ReadInteger('LAYERFRAME', 'rollupformheight', 0);
  ButtonsTopOffset := IniFile.ReadInteger('LAYERFRAME', 'buttonstopoffset', 0);
  SysButtonTopOffset := IniFile.ReadInteger('LAYERFRAME', 'sysbuttontopoffset', 0);
  //
  BlurMaskPictureIndex := IniFile.ReadInteger('LAYERFRAME', 'blurmaskpictureindex', -1);
  IntersectBlurMaskRect := ReadRect(IniFile, 'LAYERFRAME', 'intersectblurmaskrect');
  ExcludeBlurMaskRect := ReadRect(IniFile, 'LAYERFRAME', 'excludeblurmaskrect');
  //
  LeftOffset := IniFile.ReadInteger('LAYERFRAME', 'leftoffset', 0);
  TopOffset := IniFile.ReadInteger('LAYERFRAME', 'topoffset', 0);
  WidthOffset := IniFile.ReadInteger('LAYERFRAME', 'widthoffset', 0);
  HeightOffset := IniFile.ReadInteger('LAYERFRAME', 'heightoffset', 0);
end;

procedure TspDataSkinLayerFrame.SaveToFile;
begin
  IniFile.EraseSection('LAYERFRAME');
  IniFile.WriteInteger('LAYERFRAME', 'pictureindex', PictureIndex);
  IniFile.WriteInteger( 'LAYERFRAME', 'maskpictureindex', MaskPictureIndex);
  IniFile.WriteInteger('LAYERFRAME', 'inactivepictureindex', InActivePictureIndex);
  IniFile.WriteInteger( 'LAYERFRAME', 'inactivemaskpictureindex', InActiveMaskPictureIndex);
  WritePoint(IniFile, 'LAYERFRAME', 'lefttoppoint', LTPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'righttoppoint', RTPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'leftbottompoint', LBPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'rightbottompoint', RBPoint);
  WriteRect(IniFile, 'LAYERFRAME', 'clientrect', ClRect);
  IniFile.WriteInteger('LAYERFRAME', 'alphablendvalue', AlphaBlendValue);
  IniFile.WriteInteger('LAYERFRAME', 'inactivealphablendvalue', InActiveAlphaBlendValue);
  WriteRect(IniFile, 'LAYERFRAME', 'borderrect', BorderRect);
  WriteBoolean(IniFile, 'LAYERFRAME', 'hittestenable', HitTestEnable);
  WriteBoolean(IniFile, 'LAYERFRAME', 'fullborder', FullBorder);
  IniFile.WriteInteger('LAYERFRAME', 'hittestsize', HitTestSize);
  WriteRect(IniFile, 'LAYERFRAME', 'captionrect', CaptionRect);
  WritePoint(IniFile, 'LAYERFRAME', 'hittestlefttoppoint', HitTestLTPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'hittestrighttoppoint', HitTestRTPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'hittestleftbottompoint', HitTestLBPoint);
  WritePoint(IniFile, 'LAYERFRAME', 'hittestrightbottompoint', HitTestRBPoint);
  //
  WriteRect(IniFile, 'LAYERFRAME', 'buttonsrect', ButtonsRect);
  WriteRect(IniFile, 'LAYERFRAME', 'sysmenubuttonrect', SysMenuButtonRect);
  WriteBoolean(IniFile, 'LAYERFRAME', 'fullstretch', FullStretch);
  //
  IniFile.WriteInteger('LAYERFRAME', 'rollupformheight', RollUpFormHeight);
  IniFile.WriteInteger('LAYERFRAME', 'buttonstopoffset', ButtonsTopOffset);
  IniFile.WriteInteger('LAYERFRAME', 'sysbuttontopoffset', SysButtonTopOffset);
  //
  IniFile.WriteInteger('LAYERFRAME', 'blurmaskpictureindex', BlurMaskPictureIndex);
  WriteRect(IniFile, 'LAYERFRAME', 'intersectblurmaskrect', IntersectBlurMaskRect);
  WriteRect(IniFile, 'LAYERFRAME', 'excludeblurmaskrect', ExcludeBlurMaskRect);
  //
  IniFile.WriteInteger('LAYERFRAME', 'leftoffset', LeftOffset);
  IniFile.WriteInteger('LAYERFRAME', 'topoffset', TopOffset);
  IniFile.WriteInteger('LAYERFRAME', 'widthoffset', WidthOffset);
  IniFile.WriteInteger('LAYERFRAME', 'heightoffset', HeightOffset);
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
  StretchEffect := ReadBoolean(IniFile, 'POPUPWINDOW', 'stretcheffect');
  StretchType :=  ReadStretchType(IniFile, 'POPUPWINDOW', 'stretchtype');
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
  WriteBoolean(IniFile, 'POPUPWINDOW', 'stretcheffect', StretchEffect);
  WriteStretchType(IniFile, 'POPUPWINDOW', 'stretchtype', StretchType);
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
  FontName := 'Tahoma';
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
  FontName := IniFile.ReadString('HINTWINDOW', 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger('HINTWINDOW', 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, 'HINTWINDOW', 'fontstyle');
  FontColor := IniFile.ReadInteger('HINTWINDOW', 'fontcolor', 0);
  LeftStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'leftstretch');
  RightStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'rightstretch');
  TopStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'topstretch');
  BottomStretch := ReadBoolean(IniFile, 'HINTWINDOW', 'bottomstretch');
  StretchEffect := ReadBoolean(IniFile, 'HINTWINDOW', 'stretcheffect');
  StretchType :=  ReadStretchType(IniFile, 'HINTWINDOW', 'stretchtype');
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
  WriteBoolean(IniFile, 'HINTWINDOW', 'stretcheffect', StretchEffect);
  WriteStretchType(IniFile, 'HINTWINDOW', 'stretchtype', StretchType);
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
  ImageRct := ReadRect(IniFile, IDName, 'imagerect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  UnEnabledFontColor := IniFile.ReadInteger(IDName, 'unenabledfontcolor', 0);
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  InActiveStretchEffect := ReadBoolean(IniFile, IDName, 'inactivestretcheffect');
  DividerStretchEffect := ReadBoolean(IniFile, IDName, 'dividerstretcheffect');
  AnimateSkinRect := ReadRect(IniFile, IDName, 'animateskinrect');
  FrameCount := IniFile.ReadInteger(IDName, 'framecount', 0);
  AnimateInterval := IniFile.ReadInteger(IDName, 'animateinterval', 25);
  InActiveAnimation := ReadBoolean(IniFile, IDName, 'inactiveanimation');
  UseImageColor := ReadBoolean(IniFile, IDName, 'useimagecolor');
  ImageColor := IniFile.ReadInteger(IDName, 'imagecolor', 0);
  ActiveImageColor := IniFile.ReadInteger(IDName, 'activeimagecolor', 0);
  InActiveTransparent := ReadBoolean(IniFile, IDName, 'inactivetransparent');
  CheckImageRect := ReadRect(IniFile, IDName, 'checkimagerect');
  ActiveCheckImageRect := ReadRect(IniFile, IDName, 'activecheckimagerect');
  if IsNullRect(ActiveCheckImageRect) then ActiveCheckImageRect := CheckImageRect;
  RadioImageRect := ReadRect(IniFile, IDName, 'radioimagerect');
  ActiveRadioImageRect := ReadRect(IniFile, IDName, 'activeradioimagerect');
  if IsNullRect(ActiveRadioImageRect) then ActiveRadioImageRect := RadioImageRect;
  ArrowImageRect := ReadRect(IniFile, IDName, 'arrowimagerect');
  ActiveArrowImageRect := ReadRect(IniFile, IDName, 'activearrowimagerect');
  if IsNullRect(ActiveArrowImageRect) then ActiveArrowImageRect := ArrowImageRect;
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
  WriteRect(IniFile, IDName, 'imagerect', ImageRct);
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'unenabledfontcolor', UnEnabledFontColor);
  WriteBoolean(IniFile, IDName, 'stretcheffect', Stretcheffect);
  WriteBoolean(IniFile, IDName, 'inactivestretcheffect', InActiveStretcheffect);
  WriteBoolean(IniFile, IDName, 'dividerstretcheffect', DividerStretcheffect);
  WriteRect(IniFile, IDName, 'animateskinrect', AnimateSkinRect);
  IniFile.WriteInteger(IDName, 'framecount',   FrameCount);
  IniFile.WriteInteger(IDName, 'animateinterval',   AnimateInterval);
  WriteBoolean(IniFile, IDName, 'inactiveanimation', InActiveAnimation);
  WriteBoolean(IniFile, IDName, 'useimagecolor', UseImageColor);
  IniFile.WriteInteger(IDName, 'imagecolor', ImageColor);
  IniFile.WriteInteger(IDName, 'activeimagecolor', ActiveImageColor);
  WriteBoolean(IniFile, IDName, 'inactivetransparent', InActiveTransparent);   
  //
  WriteRect(IniFile, IDName, 'checkimagerect', CheckImageRect);
  WriteRect(IniFile, IDName, 'activecheckimagerect', ActiveCheckImageRect);
  WriteRect(IniFile, IDName, 'radioimagerect', RadioImageRect);
  WriteRect(IniFile, IDName, 'activeradioimagerect', ActiveRadioImageRect);
  WriteRect(IniFile, IDName, 'arrowimagerect', ArrowImageRect);
  WriteRect(IniFile, IDName, 'activearrowimagerect', ActiveArrowImageRect);
end;

procedure TspDataSkinMainMenuItem.LoadFromFile;
begin
  inherited;
  ItemLO := IniFile.ReadInteger(IDName, 'itemleftoffset', 0);
  ItemRO := IniFile.ReadInteger(IDName, 'itemrightoffset', 0);
  DownRect := ReadRect(IniFile, IDName, 'downrect');
  TextRct := ReadRect(IniFile, IDName, 'textrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  UnEnabledFontColor := IniFile.ReadInteger(IDName, 'unenabledfontColor', 0);
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  AnimateSkinRect := ReadRect(IniFile, IDName, 'animateskinrect');
  FrameCount := IniFile.ReadInteger(IDName, 'framecount', 0);
  AnimateInterval := IniFile.ReadInteger(IDName, 'animateinterval', 25);
  InActiveAnimation := ReadBoolean(IniFile, IDName, 'inactiveanimation');
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
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteRect(IniFile, IDName, 'animateskinrect', AnimateSkinRect);
  IniFile.WriteInteger(IDName, 'framecount',   FrameCount);
  IniFile.WriteInteger(IDName, 'animateinterval',   AnimateInterval);
  WriteBoolean(IniFile, IDName, 'inactiveanimation', InActiveAnimation);
end;

constructor TspDataSkinButton.Create(AIDName: String);
begin
  inherited;
  GroupIndex := -1;
  DownRect := NullRect;
  AlphaMaskPictureIndex := -1;
  AlphaMaskActivePictureIndex := -1;
  AlphaMaskInActivePictureIndex := -1;
  //
  FAlphaNormalImage := nil;
  FAlphaActiveImage := nil;
  FAlphaDownImage := nil;
  FAlphaInActiveImage := nil;
end;

destructor TspDataSkinButton.Destroy;
begin
  if FAlphaNormalImage <> nil then FreeAndNil(FAlphaNormalImage);
  if FAlphaActiveImage <> nil then FreeAndNil(FAlphaActiveImage);
  if FAlphaDownImage <>  nil then FreeAndNil(FAlphaDownImage);
  if FAlphaInActiveImage <> nil then FreeAndNil(FAlphaInActiveImage);
  inherited;
end;

procedure TspDataSkinButton.InitAlphaImage(var ASkinData: TspSkinData; var AImage:
   TspBitMap; ARect: TRect; AMaskPictureIndex: Integer);
var
  ActivePicture, MaskPicture: TBitmap;
  TempB: TspBitmap;
begin
  if AImage <> nil then FreeAndNil(AImage);
  if IsNullRect(ARect) then Exit;
  if (ActivePictureIndex = -1) or (ActivePictureIndex > ASkinData.FActivePictures.Count - 1)
  then
    Exit;
  ActivePicture := TBitMap(ASkinData.FActivePictures.Items[ActivePictureIndex]);
  AImage := TspBitMap.Create;
  AImage.SetSize(RectWidth(ARect), RectHeight(ARect));
  AImage.Canvas.CopyRect(Rect(0, 0, AImage.Width, AImage.Height),
    ActivePicture.Canvas, ARect);
  if (AMaskPictureIndex <> -1) and  (AMaskPictureIndex < ASkinData.FActivePictures.Count)
  then
    begin
      MaskPicture := TBitMap(ASkinData.FActivePictures.Items[AMaskPictureIndex]);
      TempB := TspBitMap.Create;
      TempB.SetSize(RectWidth(ARect), RectHeight(ARect));
      TempB.Canvas.Draw(0, 0, MaskPicture);
      CreateAlphaByMask2(AImage, TempB);
      TempB.Free;
    end
  else
    begin
      AImage.AlphaBlend := True;
      AImage.SetAlpha(255);
    end;
end;

procedure TspDataSkinButton.InitAlphaImages(ASkinData: TspSkinData);
begin
  inherited;
  if (ASkinData.LayerFrame.PictureIndex <> -1) and (ASkinData.LayerFrame.FullBorder)
  then
    begin
      InitAlphaImage(ASkinData, FAlphaNormalImage, SkinRect, AlphaMaskPictureIndex);
      InitAlphaImage(ASkinData, FAlphaActiveImage, ActiveSkinRect, AlphaMaskActivePictureIndex);
      InitAlphaImage(ASkinData, FAlphaDownImage, DownRect, AlphaMaskActivePictureIndex);
      InitAlphaImage(ASkinData, FAlphaInActiveImage, InActiveSkinRect, AlphaMaskInActivePictureIndex);
    end
  else
    begin
      if FAlphaNormalImage <> nil then FreeAndNil(FAlphaNormalImage);
      if FAlphaActiveImage <> nil then FreeAndNil(FAlphaActiveImage);
      if FAlphaDownImage <>  nil then FreeAndNil(FAlphaDownImage);
      if FAlphaInActiveImage <> nil then FreeAndNil(FAlphaInActiveImage);
    end;
end;

procedure TspDataSkinButton.SaveToFile;
begin
  inherited;
  WriteRect(IniFile, IDName, 'downrect', DownRect);
  WriteRect(IniFile, IDName, 'disableskinrsect', DisableSkinRect);
  IniFile.WriteInteger(IDName, 'groupindex', GroupIndex);
  IniFile.WriteInteger(IDName, 'alphamaskpictureindex', AlphaMaskPictureIndex);
  IniFile.WriteInteger(IDName, 'alphamaskactivepictureindex', AlphaMaskActivePictureIndex);
  IniFile.WriteInteger(IDName, 'alphamaskinactivepictureindex', AlphaMaskInActivePictureIndex);
end;

procedure TspDataSkinButton.LoadFromFile;
begin
  inherited;
  DownRect := ReadRect(IniFile, IDName, 'downrect');
  DisableSkinRect := ReadRect(IniFile, IDName, 'disableskinrsect');
  GroupIndex := IniFile.ReadInteger(IDName, 'groupindex', -1);
  AlphaMaskPictureIndex := IniFile.ReadInteger(IDName, 'alphamaskpictureindex', -1);
  AlphaMaskActivePictureIndex := IniFile.ReadInteger(IDName, 'alphamaskactivepictureindex', -1);
  AlphaMaskInActivePictureIndex := IniFile.ReadInteger(IDName, 'alphamaskinactivepictureindex', -1);
end;

procedure TspDataSkinCaptionMenuButton.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontName', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  InActiveFontColor := IniFile.ReadInteger(IDName, 'inactivefontcolor', 0);
  LeftOffset := IniFile.ReadInteger(IDName, 'leftoffset', 10);
  RightOffset := IniFile.ReadInteger(IDName, 'rightoffset', 10);
  TopPosition := IniFile.ReadInteger(IDName, 'topposition', 0);
  ClRect := ReadRect(IniFile, IDName, 'clientrect');
end;

procedure TspDataSkinCaptionMenuButton.InitAlphaImages(ASkinData: TspSkinData); 
begin
  InitAlphaImage(ASkinData, FAlphaNormalImage, SkinRect, AlphaMaskPictureIndex);
  InitAlphaImage(ASkinData, FAlphaActiveImage, ActiveSkinRect, AlphaMaskActivePictureIndex);
  InitAlphaImage(ASkinData, FAlphaDownImage, DownRect, AlphaMaskActivePictureIndex);
  InitAlphaImage(ASkinData, FAlphaInActiveImage, InActiveSkinRect, AlphaMaskInActivePictureIndex);
end;

procedure TspDataSkinCaptionMenuButton.SaveToFile(IniFile: TCustomIniFile); 
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'downfontcolor', DownFontColor);
  IniFile.WriteInteger(IDName, 'inactivefontcolor', InActiveFontColor);
  IniFile.WriteInteger(IDName, 'leftoffset', LeftOffset);
  IniFile.WriteInteger(IDName, 'rightoffset', RightOffset);
  IniFile.WriteInteger(IDName, 'topposition', TopPosition);
  WriteRect(IniFile, IDName, 'clientrect', ClRect);
end;

procedure TspDataSkinCaptionTab.LoadFromFile(IniFile: TCustomIniFile);
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontName', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  DownFontColor := IniFile.ReadInteger(IDName, 'downfontcolor', 0);
  LeftOffset := IniFile.ReadInteger(IDName, 'leftoffset', 10);
  RightOffset := IniFile.ReadInteger(IDName, 'rightoffset', 10);
  TopPosition := IniFile.ReadInteger(IDName, 'topposition', 0);
  ClRect := ReadRect(IniFile, IDName, 'clientrect');
end;

procedure TspDataSkinCaptionTab.InitAlphaImages(ASkinData: TspSkinData); 
begin
  InitAlphaImage(ASkinData, FAlphaNormalImage, SkinRect, AlphaMaskInActivePictureIndex);
  InitAlphaImage(ASkinData, FAlphaActiveImage, ActiveSkinRect, AlphaMaskActivePictureIndex);
  InitAlphaImage(ASkinData, FAlphaDownImage, DownRect, AlphaMaskPictureIndex);
end;

procedure TspDataSkinCaptionTab.SaveToFile(IniFile: TCustomIniFile);
begin
  inherited;
  IniFile.WriteString(IDName, 'fontname', FontName);
  IniFile.WriteInteger(IDName, 'fontheight', FontHeight);
  WriteFontStyles(IniFile, IDName, 'fontstyle', FontStyle);
  IniFile.WriteInteger(IDName, 'fontcolor', FontColor);
  IniFile.WriteInteger(IDName, 'activefontcolor', ActiveFontColor);
  IniFile.WriteInteger(IDName, 'downfontcolor', DownFontColor);
  IniFile.WriteInteger(IDName, 'leftoffset', LeftOffset);
  IniFile.WriteInteger(IDName, 'rightoffset', RightOffset);
  IniFile.WriteInteger(IDName, 'topposition', TopPosition);
  WriteRect(IniFile, IDName, 'clientrect', ClRect);
end;

constructor TspDataSkinStdButton.Create(AIDName: String);
begin
  inherited;
  FAlphaRestoreNormalImage := nil;
  FAlphaRestoreActiveImage := nil;
  FAlphaRestoreDownImage := nil;
  FAlphaInActiveRestoreImage := nil;
end;

destructor TspDataSkinStdButton.Destroy; 
begin
  if FAlphaRestoreNormalImage <> nil then FreeAndNil(FAlphaRestoreNormalImage);
  if FAlphaRestoreActiveImage <> nil then FreeAndNil(FAlphaRestoreActiveImage);
  if FAlphaRestoreDownImage <>  nil then FreeAndNil(FAlphaRestoreDownImage);
  if FAlphaInActiveRestoreImage <> nil then FreeAndNil(FAlphaInActiveRestoreImage);
  inherited;
end;

procedure TspDataSkinStdButton.InitAlphaImages(ASkinData: TspSkinData); 
begin
  inherited;
  if (ASkinData.LayerFrame.PictureIndex <> -1) and (ASkinData.LayerFrame.FullBorder)
  then
    begin
      InitAlphaImage(ASkinData, FAlphaRestoreNormalImage, RestoreRect, AlphaMaskPictureIndex);
      InitAlphaImage(ASkinData, FAlphaRestoreActiveImage, RestoreActiveRect, AlphaMaskActivePictureIndex);
      InitAlphaImage(ASkinData, FAlphaRestoreDownImage, RestoreDownRect, AlphaMaskActivePictureIndex);
      InitAlphaImage(ASkinData, FAlphaInActiveRestoreImage, RestoreInActiveRect, AlphaMaskInActivePictureIndex);
    end
  else
    begin
      if FAlphaRestoreNormalImage <> nil then FreeAndNil(FAlphaRestoreNormalImage);
      if FAlphaRestoreActiveImage <> nil then FreeAndNil(FAlphaRestoreActiveImage);
      if FAlphaRestoreDownImage <>  nil then FreeAndNil(FAlphaRestoreDownImage);
      if FAlphaInActiveRestoreImage <> nil then FreeAndNil(FAlphaInActiveRestoreImage);
    end;
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
  RestoreInActiveRect := ReadRect(IniFile, IDName, 'restoreinactiverect');
  RestoreHint := IniFile.ReadString(IDName, 'restorehint', '');
  if (RestoreHint = '') and (Hint = 'Maximize') and (Command = cmMaximize)
  then
    RestoreHint := 'Restore';
  if (RestoreHint = '') and (Hint = 'Minimize') and (Command = cmMinimize)
  then
    RestoreHint := 'Restore';
  if (RestoreHint = '') and ((Hint = 'RollUp') or (Hint = 'Roll Up'))
     and (Command = cmRollUp)
  then
    RestoreHint := 'Restore';
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
  WriteRect(IniFile, IDName, 'restoreinactiverect', RestoreInActiveRect);
  IniFile.WriteString(IDName, 'restorehint', RestoreHint);
end;

constructor TspDataSkinBitLabel.Create;
begin
  inherited;
  TextValue := '';
  Symbols := TStringList.Create;
  SymbolWidth := 0;
  SymbolHeight := 0;
  Transparent := False;
  TransparentColor := clFuchsia;
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
  Transparent := ReadBoolean(IniFile, IDName, 'transparent');
  TransparentColor := IniFile.ReadInteger(IDName, 'transparentcolor', clFuchsia);
end;

procedure TspDataSkinBitLabel.SaveToFile;
begin
  inherited;
  IniFile.WriteString(IDName, 'textvalue', TextValue);
  IniFile.WriteInteger(IDName, 'symbolwidth', SymbolWidth);
  IniFile.WriteInteger(IDName, 'symbolheight', SymbolHeight);
  WriteStrings(IniFile, IDName, 'symbols', Symbols);
  WriteBoolean(IniFile, IDName, 'transparent', Transparent);
  IniFile.WriteInteger(IDName, 'transparentcolor', TransparentColor);
end;

procedure TspDataSkinLabel.LoadFromFile;
begin
  inherited;
  FontName := IniFile.ReadString(IDName, 'fontName', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
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
  WriteBoolean(IniFile, IDName, 'light', Light);
  IniFile.WriteInteger(IDName, 'lightcolor', LightColor);
  IniFile.WriteInteger(IDName, 'activelightcolor', ActiveLightColor);
  WriteBoolean(IniFile, IDName, 'shadow', Shadow);
  IniFile.WriteInteger(IDName, 'shadowcolor', ShadowColor);
  IniFile.WriteInteger(IDName, 'activeshadowcolor', ActiveShadowColor);
  WriteRect(IniFile, IDName, 'framerect', FrameRect);
  WriteRect(IniFile, IDName, 'activeframerect', ActiveFrameRect);
  WriteRect(IniFile, IDName, 'frametextrect', FrameTextRect);
  IniFile.WriteInteger(IDName, 'frameleftoffset', FrameLeftOffset);
  IniFile.WriteInteger(IDName, 'framerightoffset', FrameRightOffset);
  WriteBoolean(IniFile, IDName, 'stretcheffect', StretchEffect);
  WriteRect(IniFile, IDName, 'animateskinrect', AnimateSkinRect);
  IniFile.WriteInteger(IDName, 'framecount',   FrameCount);
  IniFile.WriteInteger(IDName, 'animateinterval',   AnimateInterval);
  WriteBoolean(IniFile, IDName, 'inactiveanimation', InActiveAnimation);
  WriteBoolean(IniFile, IDName, 'fullframe', FullFrame);
  //
  WriteBoolean(IniFile, IDName, 'vistagloweffect', VistaGlowEffect);
  WriteBoolean(IniFile, IDName, 'vistaglowinactiveeffect', VistaGlowInActiveEffect);
  WriteBoolean(IniFile, IDName, 'gloweffect', GlowEffect);
  WriteBoolean(IniFile, IDName, 'glowinactiveeffect', GlowInActiveEffect);
  IniFile.WriteInteger(IDName, 'glowsize', GlowSize);
  IniFile.WriteInteger(IDName, 'glowcolor', GlowColor);
  IniFile.WriteInteger(IDName, 'glowactivecolor', GlowActiveColor);
  IniFile.WriteInteger(IDName, 'glowoffset', GlowOffset);
  //
  WriteBoolean(IniFile, IDName, 'reflectioneffect', ReflectionEffect);
  IniFile.WriteInteger(IDName, 'reflactioncolor', ReflectionColor);
  IniFile.WriteInteger(IDName, 'reflactionactivecolor', ReflectionActiveColor);
  IniFile.WriteInteger(IDName, 'reflectionoffset', ReflectionOffset);
  //
  WriteRect(IniFile, IDName, 'dividerrect', DividerRect);
  WriteRect(IniFile, IDName, 'inactivedividerrect', InActiveDividerRect);
  WriteBoolean(IniFile, IDName, 'dividertransparent', DividerTransparent);
  IniFile.WriteInteger(IDName, 'dividertransparentcolor', DividerTransparentColor);
  //
  IniFile.WriteInteger(IDName, 'quickbuttonalphamaskpictureindex', QuickButtonAlphaMaskPictureIndex);
end;

procedure TspDataSkinCaption.LoadFromFile;
begin
  inherited;
  DefaultCaption := ReadBoolean(IniFile, IDName, 'defaultcaption');
  TextRct := ReadRect(IniFile, IDName, 'textrect');
  FontName := IniFile.ReadString(IDName, 'fontname', 'Tahoma');
  FontHeight := IniFile.ReadInteger(IDName, 'fontheight', 13);
  FontStyle := ReadFontStyles(IniFile, IDName, 'fontstyle');
  FontColor := IniFile.ReadInteger(IDName, 'fontcolor', 0);
  ActiveFontColor := IniFile.ReadInteger(IDName, 'activefontcolor', 0);
  Alignment := ReadAlignment(IniFile, IDName, 'alignment');
  Shadow := ReadBoolean(IniFile, IDName, 'shadow');
  ShadowColor := IniFile.ReadInteger(IDName, 'shadowcolor', 0);
  Light := ReadBoolean(IniFile, IDName, 'light');
  LightColor := IniFile.ReadInteger(IDName, 'lightcolor', 0);
  ActiveLightColor := IniFile.ReadInteger(IDName, 'activelightcolor', 0);
  ActiveShadowColor := IniFile.ReadInteger(IDName, 'activeshadowcolor', 0);
  FrameRect := ReadRect(IniFile, IDName, 'framerect');
  ActiveFrameRect := ReadRect(IniFile, IDName, 'activeframerect');
  FrameTextRect := ReadRect(IniFile, IDName, 'frametextrect');
  FrameLeftOffset := IniFile.ReadInteger(IDName, 'frameleftoffset', 0);
  FrameRightOffset := IniFile.ReadInteger(IDName, 'framerightoffset', 0);
  StretchEffect := ReadBoolean(IniFile, IDName, 'stretcheffect');
  AnimateSkinRect := ReadRect(IniFile, IDName, 'animateskinrect');
  FrameCount := IniFile.ReadInteger(IDName, 'framecount', 0);
  AnimateInterval := IniFile.ReadInteger(IDName, 'animateinterval', 25);
  InActiveAnimation := ReadBoolean(IniFile, IDName, 'inactiveanimation');
  FullFrame := ReadBoolean(IniFile, IDName, 'fullframe');
  //
  VistaGlowEffect := ReadBoolean(IniFile, IDName, 'vistagloweffect');
  VistaGlowInActiveEffect := ReadBoolean(IniFile, IDName, 'vistaglowinactiveeffect');
  GlowEffect := ReadBoolean(IniFile, IDName, 'gloweffect');
  GlowInActiveEffect := ReadBoolean(IniFile, IDName, 'glowinactiveeffect');
  GlowSize := IniFile.ReadInteger(IDName, 'glowsize', 3);
  GlowColor := IniFile.ReadInteger(IDName, 'glowcolor', 0);
  GlowActiveColor := IniFile.ReadInteger(IDName, 'glowactivecolor', 0);
  GlowOffset := IniFile.ReadInteger(IDName, 'glowoffset', 0);
  //
  ReflectionEffect := ReadBoolean(IniFile, IDName, 'reflectioneffect');
  ReflectionColor := IniFile.ReadInteger(IDName, 'reflactioncolor', 0);
  ReflectionActiveColor := IniFile.ReadInteger(IDName, 'reflactionactivecolor', 0);
  ReflectionOffset := IniFile.ReadInteger(IDName, 'reflectionoffset', 0);
  //
  DividerRect := ReadRect(IniFile, IDName, 'dividerrect');
  InActiveDividerRect := ReadRect(IniFile, IDName, 'inactivedividerrect');
  DividerTransparent := ReadBoolean(IniFile, IDName, 'dividertransparent');
  DividerTransparentColor := IniFile.ReadInteger(IDName, 'dividertransparentcolor', 0);
  //
  QuickButtonAlphaMaskPictureIndex := IniFile.ReadInteger(IDName, 'quickbuttonalphamaskpictureindex', -1);
end;

constructor TspSkinColors.Create;
begin
  inherited;
  FcBtnFace := 0;
  FcBtnText := 0;
  FcWindow := 0;
  FcWindowText := 0;
  FcHighLight := 0;
  FcHighLightText := 0;
  FcBtnHighLight := 0;
  FcBtnShadow := 0;
  Fc3DLight := 0;
  Fc3DDkShadow := 0;
end;

procedure TspSkinColors.SetColorsToDefault;
begin
  FcBtnFace := clBtnFace;
  FcBtnText := clBtnText;
  FcWindow := clWindow;
  FcWindowText := clWindowText;
  FcHighLight := clHighLight;
  FcHighLightText := clHighLightText;
  FcBtnHighLight := clBtnHighLight;
  FcBtnShadow := clBtnShadow;
  Fc3DLight := cl3dLight;
  Fc3DDkShadow := cl3DDkShadow;
end;

procedure TspSkinColors.LoadFromFile;
begin
  FcBtnFace := IniFile.ReadInteger('SKINCOLORS', 'cbtnface', 0);
  FcBtnText := IniFile.ReadInteger('SKINCOLORS', 'cbtntext', 0);
  FcWindow := IniFile.ReadInteger('SKINCOLORS', 'cwindow', 0);
  FcWindowText := IniFile.ReadInteger('SKINCOLORS', 'cwindowtext', 0);
  FcHighLight := IniFile.ReadInteger('SKINCOLORS', 'chighlight', 0);
  FcHighLightText := IniFile.ReadInteger('SKINCOLORS', 'chighlighttext', 0);
  FcBtnHighLight := IniFile.ReadInteger('SKINCOLORS', 'cbtnhighlight', 0);
  FcBtnShadow := IniFile.ReadInteger('SKINCOLORS', 'cbtnshadow', 0);
  Fc3DLight := IniFile.ReadInteger('SKINCOLORS', 'c3dlight', 0);
  Fc3DDkShadow := IniFile.ReadInteger('SKINCOLORS', 'c3ddkshadow', 0);
end;

procedure TspSkinColors.SaveToFile;
begin
  IniFile.WriteInteger('SKINCOLORS', 'cbtnface', FcBtnFace);
  IniFile.WriteInteger('SKINCOLORS', 'cbtntext', FcBtnText);
  IniFile.WriteInteger('SKINCOLORS', 'cwindow', FcWindow);
  IniFile.WriteInteger('SKINCOLORS', 'cwindowtext', FcWindowText);
  IniFile.WriteInteger('SKINCOLORS', 'chighlight', FcHighLight);
  IniFile.WriteInteger('SKINCOLORS', 'chighlighttext', FcHighLightText);
  IniFile.WriteInteger('SKINCOLORS', 'cbtnhighlight', FcBtnHighLight);
  IniFile.WriteInteger('SKINCOLORS', 'cbtnshadow', FcBtnShadow);
  IniFile.WriteInteger('SKINCOLORS', 'c3dlight', Fc3DLight);
  IniFile.WriteInteger('SKINCOLORS', 'c3ddkshadow', Fc3DDkShadow);
end;

constructor TspSkinData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAeroBlurEnabled := True;
  FAnimationForAllWindows := False;
  FShowLayeredBorders := True;
  FCompressedSkinList := nil;
  FCompressedSkinIndex := 0;
  FSkinnableForm := True;
  FShowButtonGlowFrames := True;
  FShowCaptionButtonGlowFrames := True;
  ChangeSkinDataProcess := False;
  FEnableSkinEffects := True;
  FSkinColors := TspSkinColors.Create;
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
  LayerFrame := TspDataSkinLayerFrame.Create;
  HintWindow := TspDataSkinHintWindow.Create;
  MainMenuPopupUp := False;
  BuildMode := False;
  StartCursorIndex := 1;
  CursorIndex := -1;
  BGPictureIndex := -1;
  MDIBGPictureIndex := -1;
  FormMinWidth := 0;
  FormMinHeight := 0;
  //
  FDlgTreeViewDrawSkin := True;
  FDlgTreeViewItemSkinDataName := 'listbox';
  FDlgListViewDrawSkin := True;
  FDlgListViewItemSkinDataName := 'listbox';
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
  LayerFrame.Free;
  HintWindow.Free;
  FSkinColors.Free;
  inherited Destroy;
end;

procedure TspSkinData.GlobalChangeFont(ANewFontName: String; AFontHeightCorrection: Integer);
var
  i: Integer;
begin
  // for hint window
  HintWindow.FontName := ANewFontName;
  HintWindow.FontHeight := HintWindow.FontHeight + AFontHeightCorrection;
  // for skin-objects
  for i := 0 to ObjectList.Count - 1 do
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaptionMenuButton
    then
      with TspDataSkinCaptionMenuButton(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaptionTab
    then
      with TspDataSkinCaptionTab(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinLabel
    then
      with TspDataSkinLabel(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMenuItem
    then
      with TspDataSkinMenuItem(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinMainMenuBarItem
    then
      with TspDataSkinMainMenuBarItem(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaption
    then
      with TspDataSkinCaption(ObjectList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end;
  // for skin-controls
  for i := 0 to CtrlList.Count - 1 do
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinTreeView
    then
      with TspDataSkinTreeView(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinListView
    then
      with TspDataSkinListView(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinRichEdit
    then
      with TspDataSkinRichEdit(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinTabControl
    then
      with TspDataSkinTabControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinGridControl
    then
      with TspDataSkinGridControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
        FixedFontName := ANewFontName;
        FixedFontHeight := FixedFontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinComboBox
    then
      with TspDataSkinComboBox(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinListBox
    then
      with TspDataSkinListBox(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        CaptionFontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
        CaptionFontHeight := CaptionFontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinSpinEditControl
    then
      with TspDataSkinSpinEditControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinEditControl
    then
      with TspDataSkinEditControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinStdLabelControl
    then
      with TspDataSkinStdLabelControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinLabelControl
    then
      with TspDataSkinLabelControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinGaugeControl
    then
      with TspDataSkinGaugeControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinButtonControl
    then
      with TspDataSkinButtonControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinCheckRadioControl
    then
      with TspDataSkinCheckRadioControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinPanelControl
    then
      with TspDataSkinPanelControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end
    else  
    if TspDataSkinControl(CtrlList.Items[i]) is TspDataSkinExPanelControl
    then
      with TspDataSkinExPanelControl(CtrlList.Items[i]) do
      begin
        FontName := ANewFontName;
        FontHeight := FontHeight + AFontHeightCorrection;
      end;
end;

procedure TspSkinData.SetAeroBlurEnabled(Value: Boolean);
begin
  if FAeroBlurEnabled <> Value
  then
    begin
      FAeroBlurEnabled := Value;
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        SendSkinDataMessage(WM_UPDATELAYEREDBORDER);
    end;
end;

procedure TspSkinData.SetShowLayeredBorders(Value: Boolean);
begin
  if FShowLayeredBorders <> Value
  then
    begin
      FShowLayeredBorders := Value;
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        SendSkinDataMessage(WM_SHOWLAYEREDBORDER);
    end;
end;

procedure TspSkinData.SetCompressedSkinList(Value: TspCompressedSkinList);
begin
  FCompressedSkinList := Value;
  if not (csDesigning in ComponentState) and (FCompressedSkinList <> nil) and
     (FCompressedSkinIndex >= 0) and (FCompressedSkinIndex < FCompressedSkinList.Skins.Count)
  then
    begin
      LoadCompressedStoredSkin(FCompressedSkinList.Skins[FCompressedSkinIndex].Skin);
    end;
end;

procedure TspSkinData.SetCompressedSkinIndex(Value: Integer);
begin
  if Value = FCompressedSkinIndex then Exit;
  if FCompressedSkinList = nil
  then
    begin
      FCompressedSkinIndex := Value;
      Exit;
    end;

  if (Value >= 0) and (Value < FCompressedSkinList.Skins.Count)
  then
    begin
      FCompressedSkinIndex := Value;
      if not (csDesigning in ComponentState)
      then
        LoadCompressedStoredSkin(FCompressedSkinList.Skins[FCompressedSkinIndex].Skin);
    end;
end;


procedure TspSkinData.SetSkinnableForm;
begin
  if Value <> FSkinnableForm
  then
    begin
      FSkinnableForm := Value;
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState)
      then
        SendSkinDataMessage(WM_CHANGEFORMSKINNABLE);
    end;
end;

procedure TspSkinData.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FCompressedStoredSkin)
  then FCompressedStoredSkin := nil;
  if (Operation = opRemove) and (AComponent = FResourceStrData)
  then FResourceStrData := nil;
  if (Operation = opRemove) and (AComponent = FCompressedSkinList)
  then FCompressedSkinList := nil;
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

procedure TspSkinData.StoreToDisk(AFileName: String);
var
  I: Integer;
  APath: String;
begin
  SaveToFile(AFileName);
  APath := ExtractFilePath(AFileName);
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
  HandleList: array of Integer;
  HandleCount: Integer;
  S: String;
begin
  if BuildMode then Exit;

  if (Owner is TForm) and not FShowLayeredBorders
  then
    begin
      F := TForm(Owner);
      SendMessage(F.Handle, M, Integer(Self), 1000);
    end
  else
    F := nil;

  SetLength(HandleList, Screen.FormCount);

  HandleCount := 0;

  for i := 0 to Screen.FormCount - 1 do
  begin
    if ((Screen.Forms[i] <> F) or (F = nil)) and not (Screen.Forms[i].ClassName = 'TspFormLayerWindow')
    then
       begin
         Inc(HandleCount);
         HandleList[HandleCount - 1] := Screen.Forms[i].Handle;
       end;
  end;

  if FShowLayeredBorders and (LayerFrame.PictureIndex <> -1)
  then
    for i := HandleCount - 1 downto 0 do SendMessage(HandleList[i], M, Integer(Self), 1000)
  else
    for i := 0 to HandleCount - 1 do SendMessage(HandleList[i], M, Integer(Self), 1000);
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
  LayerFrame.PictureIndex := -1;
  LayerFrame.InActivePictureIndex := -1;
  LayerFrame.InitAlphaImages(Self);
  FCursorsNames.Clear;
  FActivePictures.Clear;
  FActivePicturesNames.Clear;
  FCursorsNames.Clear;
  FSkinColors.SetColorsToDefault;
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

procedure TspSkinData.GetAreaNameRect(S: String; var AName: String; var ARect: TRect;
  var AUseAnchors, AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom: Boolean);
var
  i, j, k: Integer;
  ARectStr, S1: String;
begin
  AName := '';
  ARectStr := '';
  j := 0;
  k := 0;
  for i := 1 to Length(S) do
    if S[i] = ':'
    then
      begin
        j := i;
      end
    else
    if S[i] = ';'
    then
      begin
        k := i;
      end;

  if k = 0 then k := Length(S) else k := k - 1;

  if j <> 0
  then
    begin
      AName := Copy(S, 1, j - 1);
      ARectStr := Copy(S, j + 1, k - j);
      ARect := GetRect(ARectStr);
    end;

  if k <> Length(S) then k := k + 2;

  if (k <> Length(S)) and (Length(S) - k = 8)
  then
    begin
      S1 := Copy(S, k, Length(S) - k + 1);
      AUseAnchors := S1[1] = '1';
      AAnchorLeft := S1[3] = '1';
      AAnchorTop := S1[5] = '1';
      AAnchorRight := S1[7] = '1';
      AAnchorBottom := S1[9] = '1';
    end
  else
    begin
      AUseAnchors := False;
      AAnchorLeft := False;
      AAnchorTop := False;
      AAnchorRight := False;
      AAnchorBottom := False;
    end;
end;

procedure TspSkinData.AddSkinArea;
begin
  AreaList.Add(TspDataSkinArea.Create(AName, ARect,
    AUseAnchors, AAnchorLeft, AAnchorTop, AAnchorRight, AAnchorBottom));
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
    S := S + ';';
    if UseAnchors then S := S + '1,' else S := S + '0,';
    if AnchorLeft then S := S + '1,' else S := S + '0,';
    if AnchorTop then S := S + '1,' else S := S + '0,';
    if AnchorRight then S := S + '1,' else S := S + '0,';
    if AnchorBottom then S := S + '1' else S := S + '0';
    F.WriteString('SKINAREAS', IntToStr(i), S);
  end;
end;

procedure TspSkinData.ReadAreas(F: TCustomIniFile);
var
  i, Count: Integer;
  S, FName: String;
  FRect: TRect;
  FUseAnchors, FAnchorLeft, FAnchorTop, FAnchorRight, FAnchorBottom: Boolean;
begin
  Count := F.ReadInteger('SKINAREAS', 'count', 0);
  for i := 0 to Count - 1 do
  begin
    S := F.ReadString('SKINAREAS', IntToStr(i), '');
    GetAreaNameRect(S, FName, FRect, FUseAnchors, FAnchorLeft, FAnchorTop, FAnchorRight, FAnchorBottom);
    AddSkinArea(FName, FRect, FUseAnchors, FAnchorLeft, FAnchorTop, FAnchorRight, FAnchorBottom);
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
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaptionMenuButton
    then S := S + 'captionmenubutton' else
    if TspDataSkinObject(ObjectList.Items[i]) is TspDataSkinCaptionTab
    then S := S + 'captiontab' else
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
    if FType = 'captionmenubutton'
    then ObjectList.Add(TspDataSkinCaptionMenuButton.Create(FName)) else
    if FType = 'captiontab'
    then ObjectList.Add(TspDataSkinCaptionTab.Create(FName)) else
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
    TspDataSkinObject(ObjectList[ObjectList.Count - 1]).InitAlphaImages(Self);
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
  WriteBoolean(F, 'FORMINFO', 'stretcheffect', StretchEffect);
  WriteStretchType(F, 'FORMINFO', 'stretchtype', StretchType);
  WriteBoolean(F, 'FORMINFO', 'mdibgstretcheffect', MDIBGStretchEffect);
  WriteStretchType(F, 'FORMINFO', 'mdibgstretchtype', MDIBGStretchType);
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
  F.WriteInteger('FORMINFO', 'formminwidth', FormMinWidth);
  F.WriteInteger('FORMINFO', 'formminheight', FormMinHeight);
  //
  WriteRect(F, 'FORMINFO', 'sizegriparea', SizeGripArea);
  F.WriteString('FORMINFO', 'statusbarname', StatusBarName);
  WriteBoolean(F, 'FORMINFO', 'mditabstransparent', MDITabsTransparent);
  WriteBoolean(F, 'FORMINFO', 'mainmenubartransparent', MainMenuBarTransparent);
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
  StretchEffect := ReadBoolean(F, 'FORMINFO', 'stretcheffect');
  StretchType :=  ReadStretchType(F, 'FORMINFO', 'stretchtype');
  MDIBGStretchEffect := ReadBoolean(F, 'FORMINFO', 'mdibgstretcheffect');
  MDIBGStretchType :=  ReadStretchType(F, 'FORMINFO', 'mdibgstretchtype');
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
  FormMinWidth := F.ReadInteger('FORMINFO', 'formminwidth', 0);
  FormMinHeight := F.ReadInteger('FORMINFO', 'formminheight', 0);
  MDITabsTransparent := ReadBoolean(F, 'FORMINFO', 'mditabstransparent');
  MainMenuBarTransparent := ReadBoolean(F, 'FORMINFO', 'mainmenubartransparent');
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
  SizeGripArea := ReadRect(F,'FORMINFO', 'sizegriparea');
  StatusBarName := F.ReadString('FORMINFO', 'statusbarname', '');
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
  F.EraseSection('LAYERFRAME');
  LayerFrame.SaveToFile(F);
  //
  F.EraseSection('HINTWINDOW');
  HintWindow.SaveToFile(F);
  //
  WriteAreas(F);
  //
  F.EraseSection('SKINCOLORS');
  FSkinColors.SaveToFile(F);
  //
  //
  WriteObjects(F);
  //
  WriteCtrls(F);
end;

procedure TspSkinData.SaveToFile(FileName: String);
var
  F: TMemIniFile;
begin
  F := TMemIniFile.Create(FileName);
  try
    SaveToCustomIniFile(F);
    F.UpdateFile;
  finally
    F.Free;
  end;
end;

procedure TspSkinData.LoadFromFile;
var
  F: TIniFile;
  FilePath: String;
begin

  F := TIniFile.Create(FileName);

  if not CheckSkinFile(F)
  then
    begin
      F.Free;
      Exit;
    end;


  Empty := True;

  ChangeSkinDataProcess := True;

  SendSkinDataMessage(WM_BEFORECHANGESKINDATA);

  ClearAll;

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
  LayerFrame.LoadFromFile(F);
  LayerFrame.InitAlphaImages(Self);
  //
  HintWindow.LoadFromFile(F);
  //
  FSkinColors.LoadFromFile(F);
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

  //
  if Assigned(FOnLoadData) then FOnLoadData(Self);
  //

  SendSkinDataMessage(WM_CHANGESKINDATA);

  ChangeSkinDataProcess := False;

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
  ChangeSkinDataProcess := True;
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
  //
  LayerFrame.LoadFromFile(F);
  LayerFrame.InitAlphaImages(Self);
  //
  HintWindow.LoadFromFile(F);
  FSkinColors.LoadFromFile(F);
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

  //
  if Assigned(FOnLoadData) then FOnLoadData(Self);
  //

  SendSkinDataMessage(WM_CHANGESKINDATA);

  ChangeSkinDataProcess := False;

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

procedure TspCompressedStoredSkin.SaveToCompressStream(Stream: TStream);
var
  CV, Size: LongInt;
begin
  CV := CompressVersion;
  Stream.Write(CV, SizeOf(CV));
  Size := FCompressedStream.Size;
  Stream.Write(Size, SizeOf(Size));
  FCompressedStream.SaveToStream(Stream);
end;

procedure TspCompressedStoredSkin.LoadFromCompressStream(Stream: TStream);
var
  CV, Size: LongInt;
begin
  FCompressedStream.Clear;
  Stream.Position := 0;
  Stream.Read(CV, SizeOf(CV));
  if CV <= 3
  then
     begin
       Stream.Read(Size, SizeOf(Size));
       FCompressedStream.CopyFrom(Stream, Size);
     end;
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
  FResStrs.Add('MI_MINCAPTION=Mi&nimize');
  FResStrs.Add('MI_MAXCAPTION=Ma&ximize');
  FResStrs.Add('MI_CLOSECAPTION=&Close');
  FResStrs.Add('MI_RESTORECAPTION=&Restore');
  FResStrs.Add('MI_MINTOTRAYCAPTION=Minimize to &Tray');
  FResStrs.Add('MI_ROLLUPCAPTION=Ro&llUp');

  FResStrs.Add('MINBUTTON_HINT=Minimize');
  FResStrs.Add('MAXBUTTON_HINT=Maximize');
  FResStrs.Add('CLOSEBUTTON_HINT=Close');
  FResStrs.Add('TRAYBUTTON_HINT=Minimize to Tray');
  FResStrs.Add('ROLLUPBUTTON_HINT=Roll Up');
  FResStrs.Add('MENUBUTTON_HINT=System menu');
  FResStrs.Add('RESTORE_HINT=Restore');

  FResStrs.Add('EDIT_UNDO=Undo');
  FResStrs.Add('EDIT_COPY=Copy');
  FResStrs.Add('EDIT_CUT=Cut');
  FResStrs.Add('EDIT_PASTE=Paste');
  FResStrs.Add('EDIT_DELETE=Delete');
  FResStrs.Add('EDIT_SELECTALL=Select All');

  FResStrs.Add('MSG_BTN_YES=&Yes');
  FResStrs.Add('MSG_BTN_NO=&No');
  FResStrs.Add('MSG_BTN_OK=OK');
  FResStrs.Add('MSG_BTN_CANCEL=Cancel');
  FResStrs.Add('MSG_BTN_ABORT=&Abort');
  FResStrs.Add('MSG_BTN_RETRY=&Retry');
  FResStrs.Add('MSG_BTN_IGNORE=&Ignore');
  FResStrs.Add('MSG_BTN_ALL=&All');
  FResStrs.Add('MSG_BTN_NOTOALL=N&oToAll');
  FResStrs.Add('MSG_BTN_YESTOALL=&YesToAll');
  FResStrs.Add('MSG_BTN_HELP=&Help');
  FResStrs.Add('MSG_BTN_OPEN=&Open');
  FResStrs.Add('MSG_BTN_SAVE=&Save');
  FResStrs.Add('MSG_BTN_CLOSE=Close');

  FResStrs.Add('MSG_BTN_BACK_HINT=Go To Last Folder Visited');
  FResStrs.Add('MSG_BTN_UP_HINT=Up One Level');
  FResStrs.Add('MSG_BTN_NEWFOLDER_HINT=Create New Folder');
  FResStrs.Add('MSG_BTN_VIEWMENU_HINT=View Menu');
  FResStrs.Add('MSG_BTN_STRETCH_HINT=Stretch Picture');

  FResStrs.Add('MSG_FILENAME=File name:');
  FResStrs.Add('MSG_FILETYPE=File type:');
  FResStrs.Add('MSG_NEWFOLDER=New Folder');
  FResStrs.Add('MSG_LV_DETAILS=Details');
  FResStrs.Add('MSG_LV_ICON=Large icons');
  FResStrs.Add('MSG_LV_SMALLICON=Small icons');
  FResStrs.Add('MSG_LV_LIST=List');
  FResStrs.Add('MSG_PREVIEWSKIN=Preview');
  FResStrs.Add('MSG_PREVIEWBUTTON=Button');
  FResStrs.Add('MSG_OVERWRITE=Do you want to overwrite old file?');

  FResStrs.Add('MSG_CAP_WARNING=Warning');
  FResStrs.Add('MSG_CAP_ERROR=Error');
  FResStrs.Add('MSG_CAP_INFORMATION=Information');
  FResStrs.Add('MSG_CAP_CONFIRM=Confirm');
  FResStrs.Add('MSG_CAP_SHOWFLAG=Do not display this message again');

  FResStrs.Add('CALC_CAP=Calculator');
  FResStrs.Add('ERROR=Error');
  FResStrs.Add('COLORGRID_CAP=Basic colors');
  FResStrs.Add('CUSTOMCOLORGRID_CAP=Custom colors');
  FResStrs.Add('ADDCUSTOMCOLORBUTTON_CAP=Add to Custom Colors');

  FResStrs.Add('FONTDLG_COLOR=Color:');
  FResStrs.Add('FONTDLG_NAME=Name:');
  FResStrs.Add('FONTDLG_SIZE=Size:');
  FResStrs.Add('FONTDLG_HEIGHT=Height:');
  FResStrs.Add('FONTDLG_EXAMPLE=Example:');
  FResStrs.Add('FONTDLG_STYLE=Style:');
  FResStrs.Add('FONTDLG_SCRIPT=Script:');

  FResStrs.Add('DB_DELETE_QUESTION=Delete record?');
  FResStrs.Add('DB_MULTIPLEDELETE_QUESTION=Delete all selected records?');

  FResStrs.Add('NODISKINDRIVE=There is no disk in Drive or Drive is not ready');
  FResStrs.Add('NOVALIDDRIVEID=Not a valid Drive ID');

  FResStrs.Add('FLV_NAME=Name');
  FResStrs.Add('FLV_SIZE=Size');
  FResStrs.Add('FLV_TYPE=Type');
  FResStrs.Add('FLV_LOOKIN=Look in: ');
  FResStrs.Add('FLV_MODIFIED=Modified');
  FResStrs.Add('FLV_ATTRIBUTES=Attributes');
  FResStrs.Add('FLV_DISKSIZE=Disk Size');
  FResStrs.Add('FLV_FREESPACE=Free Space');

  FResStrs.Add('PRNDLG_NAME=Name:');
  FResStrs.Add('PRNDLG_PRINTER=Printer');
  FResStrs.Add('PRNDLG_PROPERTIES=Properties...');
  FResStrs.Add('PRNDLG_TYPE=Type:');
  FResStrs.Add('PRNDLG_STATUS=Status:');
  FResStrs.Add('PRNDLG_WHERE=Where:');
  FResStrs.Add('PRNDLG_COMMENT=Comment:');
  FResStrs.Add('PRNDLG_PRINTRANGE=Print range');
  FResStrs.Add('PRNDLG_COPIES=Copies');
  FResStrs.Add('PRNDLG_NUMCOPIES=Number of copies:');
  FResStrs.Add('PRNDLG_COLLATE=Collate');
  FResStrs.Add('PRNDLG_ALL=All');
  FResStrs.Add('PRNDLG_PAGES=Pages');
  FResStrs.Add('PRNDLG_SELECTION=Selection');
  FResStrs.Add('PRNDLG_PRINTTOFILE=Print to file');
  FResStrs.Add('PRNDLG_FROM=from:');
  FResStrs.Add('PRNDLG_TO=to:');
  FResStrs.Add('PRNDLG_ORIENTATION=Orientation');
  FResStrs.Add('PRNDLG_PAPER=Paper');
  FResStrs.Add('PRNDLG_PORTRAIT=Portrait');
  FResStrs.Add('PRNDLG_LANDSCAPE=Landscape');
  FResStrs.Add('PRNDLG_SOURCE=Source:');
  FResStrs.Add('PRNDLG_SIZE=Size:');
  FResStrs.Add('PRNDLG_MARGINS=Margins (millimeters)');
  FResStrs.Add('PRNDLG_MARGINS_INCHES=Margins (inches)');
  FResStrs.Add('PRNDLG_LEFT=Left:');
  FResStrs.Add('PRNDLG_RIGHT=Right:');
  FResStrs.Add('PRNDLG_TOP=Top:');
  FResStrs.Add('PRNDLG_BOTTOM=Bottom:');
  FResStrs.Add('PRNDLG_WARNING=There are no printers in your system!');

  FResStrs.Add('FIND_NEXT=Find next');
  FResStrs.Add('FIND_WHAT=Find what:');
  FResStrs.Add('FIND_DIRECTION=Direction');
  FResStrs.Add('FIND_DIRECTIONUP=Up');
  FResStrs.Add('FIND_DIRECTIONDOWN=Down');
  FResStrs.Add('FIND_MATCH_CASE=Match case');
  FResStrs.Add('FIND_MATCH_WHOLE_WORD_ONLY=Match whole word only');
  FResStrs.Add('FIND_REPLACE_WITH=Replace with:');
  FResStrs.Add('FIND_REPLACE=Replace');
  FResStrs.Add('FIND_REPLACE_All=Replace All');
  FResStrs.Add('FIND_REPLACE_CLOSE=Close');

  FResStrs.Add('MORECOLORS=More colors...');
  FResStrs.Add('AUTOCOLOR=Automatic');
  FResStrs.Add('CUSTOMCOLOR=Custom...');

  FResStrs.Add('DBNAV_FIRST=FIRST');
  FResStrs.Add('DBNAV_PRIOR=PRIOR');
  FResStrs.Add('DBNAV_NEXT=NEXT');
  FResStrs.Add('DBNAV_LAST=LAST');
  FResStrs.Add('DBNAV_INSERT=INSERT');
  FResStrs.Add('DBNAV_DELETE=DELETE');
  FResStrs.Add('DBNAV_EDIT=EDIT');
  FResStrs.Add('DBNAV_POST=POST');
  FResStrs.Add('DBNAV_CANCEL=CANCEL');
  FResStrs.Add('DBNAV_REFRESH=REFRESH');

  FResStrs.Add('DB_DELETE_QUESTION=Delete record?');
  FResStrs.Add('DB_MULTIPLEDELETE_QUESTION=Delete all selected records?');


end;

constructor TspSkinListItem.Create(Collection: TCollection);
begin
  inherited;
  FSkin := TspCompressedStoredSkin.Create(nil);
  FDescription := '';
  FFileName := '';
  FCompressedFileName := '';
  FName := Format('spSkin%d', [Index]);
end;

destructor TspSkinListItem.Destroy;
begin
  FSkin.Free;
  inherited;
end;

function TspSkinListItem.GetDisplayName;
begin
  Result := FName;
end;

procedure TspSkinListItem.ReadData(Stream: TStream);
begin
  FSkin.LoadFromCompressStream(Stream);
end;

procedure TspSkinListItem.WriteData(Stream: TStream);
begin
  FSkin.SaveToCompressStream(Stream);
end;

procedure TspSkinListItem.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Skin', ReadData, WriteData, true);
end;

procedure TspSkinListItem.SetDescription(Value: String);
begin
  FDescription := Value;
end;

procedure TspSkinListItem.SetFileName(Value: String);
begin
  if (csDesigning in TspSkinListItems(Collection).FSkinList.ComponentState) and not
     (csLoading in TspSkinListItems(Collection).FSkinList.ComponentState)
  then
    begin
      FSkin.LoadFromIniFile(Value);
      FFileName := ExtractFileName(Value);
    end
  else
    FFileName := Value;
end;

procedure TspSkinListItem.SetCompressedFileName(Value: String);
begin
  if (csDesigning in TspSkinListItems(Collection).FSkinList.ComponentState) and not
     (csLoading in TspSkinListItems(Collection).FSkinList.ComponentState)
  then
    begin
      FSkin.LoadFromCompressFile(Value);
      FCompressedFileName := ExtractFileName(Value);
    end
  else
    FCompressedFileName := Value;
end;

function TspSkinListItems.GetItem(Index: Integer): TspSkinListItem;
begin
  Result := TspSkinListItem(inherited GetItem(Index));
end;

procedure TspSkinListItems.SetItem(Index: Integer; Value:  TspSkinListItem);
begin
  inherited SetItem(Index, Value);
end;

function TspSkinListItems.GetOwner: TPersistent;
begin
  Result := FSkinList;
end;

constructor TspSkinListItems.Create(ASkinList: TspCompressedSkinList);
begin
  inherited Create(TspSkinListItem);
  FSkinList := ASkinList;
end;


constructor TspCompressedSkinList.Create(AOwner: TComponent);
begin
  inherited;
  FSkins := TspSkinListItems.Create(Self);
end;

destructor TspCompressedSkinList.Destroy;
begin
  FSkins.Free;
  inherited;
end;

procedure TspCompressedSkinList.SetSkins(Value: TspSkinListItems);
begin
  FSkins.Assign(Value);
end;


end.

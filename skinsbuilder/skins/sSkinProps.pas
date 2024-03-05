unit sSkinProps;

interface

const

// Images
  BordersMask                           = 'BORDERSMASK';
  BordersMaskPlus                       = 'BORDERSMASK+'; // For additional painting (in TsPageControl for sample)
  StatusBarGrip                         = 'GRIPIMAGE';
  StatusPanelBordersMask                = 'STATUSPANELMASK';
  SliderChannelMask                     = 'SLIDERCHANNEL';

  ActiveTab                             = 'ACTIVETABBORDERSMASK';
  ActiveTabPlus                         = 'ACTIVETABBORDERSMASK+';
  InActiveTab                           = 'INACTIVETABBORDERSMASK';

  PatternFile                           = 'IMAGEFILE';
  HotPatternFile                        = 'HOTIMAGEFILE';

  TitleBorder                           = 'TITLEBORDER';
  NormalTitleBar                        = 'TITLEBAR';
  MenuLineBg                            = 'LINEPATTERN';

  BorderIconClose                       = 'BICONCLOSE';
  BorderIconMaximize                    = 'BICONMAX';
  BorderIconNormalize                   = 'BICONNORM';
  BorderIconMinimize                    = 'BICONMIN';
  BorderIconHelp                        = 'BICONHELP';

  SmallIconMinimize                     = 'BICONMIN';    //'SICONMIN';
  SmallIconMaximize                     = 'BICONMAX';    //'SICONMAX';
  SmallIconClose                        = 'BICONCLOSE';  //'SICONCLOSE';

  ComboBoxGlyph                         = 'GLYPHMASK';
  ItemGlyph                             = 'GLYPHMASK';
  GaugeHorProgress                      = 'GAUGEPROGRESSMASK';
  GlyphChecked                          = 'GLYPHCHECKED';
  GlyphUnChecked                        = 'GLYPHUNCHECKED';
  SliderHorzMask                        = 'SLIDERMASK';
  SliderVertMask                        = 'SLIDERVMASK';


// General properties
  // Text and text contours colors
  FColor                                = 'FONTCOLOR';
  TCLeft                                = 'TCLEFT';
  TCTop                                 = 'TCTOP';
  TCRight                               = 'TCRIGHT';
  TCBottom                              = 'TCBOTTOM';
  // Hot text and text contours colors
  HotFColor                             = 'HOTFONTCOLOR';
  HotTCLeft                             = 'HOTTCLEFT';
  HotTCTop                              = 'HOTTCTOP';
  HotTCRight                            = 'HOTTCRIGHT';
  HotTCBottom                           = 'HOTTCBOTTOM';

  ReservedBoolean                       = 'RESERVEDBOOLEAN';

  SectionName                           = 'SectionName';
  ParentClassName                       = 'ParentClassName';
  PaintingColor                         = 'PaintingColor';
  PaintingBevel                         = 'PaintingBevel';
  PaintingBevelWidth                    = 'PaintingBevelWidth';
  ShadowBlur                            = 'ShadowBlur';
  ShadowColor                           = 'ShadowColor';
  ShadowDontUse                         = 'ShadowDontUse';
  ShadowEnabled                         = 'ShadowEnabled';
  ShadowOffset                          = 'ShadowOffset';
  ShadowTransparency                    = 'ShadowTransparency';
  FontColor                             = 'FontColor';
  HotFontColor                          = 'HotFontColor';
  PaintingTransparency                  = 'PaintingTransparency';
  GradientPercent                       = 'GradientPercent';
  GradientData                          = 'GradientData';
  ImagePercent                          = 'ImagePercent';
  ShowFocus                             = 'ShowFocus';
  FadingEnabled                         = 'FadingEnabled';
  FadingIntervalIn                      = 'FadingIntervalIn';
  FadingIntervalOut                     = 'FadingIntervalOut';
  FadingIterations                      = 'FadingIterations';
  HotPaintingColor                      = 'HotPaintingColor';
  HotPaintingTransparency               = 'HotPaintingTransparency';
  HotPaintingBevel                      = 'HotPaintingBevel';
  HotPaintingBevelWidth                 = 'HotPaintingBevelWidth';
  HotGradientPercent                    = 'HotGradientPercent';
  HotGradientData                       = 'HotGradientData';
  HotImagePercent                       = 'HotImagePercent';
  PaintingColorBorderTop                = 'PaintingColorBorderTop';
  PaintingColorBorderBottom             = 'PaintingColorBorderBottom';
  SelectionBorderBevel                  = 'SelectionBorderBevel';
  SelectionBorderWidth                  = 'SelectionBorderWidth';
  SelectionColor                        = 'SelectionColor';


// Default sections
  FormTitle                             = 'FORMTITLE';
  NormalForm                            = 'FORM';
  MDIArea                               = 'MDIAREA';
  MainMenu                              = 'MAINMENU';
  MenuLine                              = 'MENULINE';
  MenuItem                              = 'MENUITEM';
  ScrollBar1            = 'SCROLLBAR1';   // After creation added 'H' or 'V' for horizontal or vertical kinds
  ScrollBar2            = 'SCROLLBAR2';   // After creation added 'H' or 'V' for horizontal or vertical kinds
  ScrollSlider          = 'SCROLLSLIDER'; // After creation added 'H' or 'V' for horizontal or vertical kinds
  ArrowLeft                             = 'SCROLLBTNLEFT';
  ArrowTop                              = 'SCROLLBTNTOP';
  ArrowRight                            = 'SCROLLBTNRIGHT';
  ArrowBottom                           = 'SCROLLBTNBOTTOM';
  Divider                               = 'DIVIDER';
  ColHeader                             = 'COLHEADER';

// When pagecontrol have TabPosition <> tpTop then to SkinSection added suffix "Bottom", "Left", or "Right"
// Sample - TsPageControlLeft. And Also to TsTabSheet added such suffixes (Sample - "TsTabSheetLeft") 

implementation

end.

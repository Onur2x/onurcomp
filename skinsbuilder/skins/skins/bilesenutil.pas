unit bilesenutil;

interface


uses Windows, Messages, SysUtils, Classes, Controls, Forms, Menus, Graphics,
     StdCtrls, ExtCtrls;

{ strings }
type

{ Object visible }

  TscVisible = (
    svAlways,
    { window state }
    svActive,
    svInactive,
    svMaximized,
    svNoMaximized,
    svRollup,
    svNoRollup,
    svStayOnTop,
    svNoStayOntop,
    svMenuBar,
    svNoMenuBar,
    { System button }
    svHelp,
    svNoHelp,
    svMax,
    svNoMax,
    svMin,
    svNoMin,
    svMinMax,
    svNoMinMax,
    svSizeable,
    svNoSizeable,
    svSysMenu,
    svNoSysMenu,
    svClose,
    svNoClose,
    { for WinControls }
    svFocused,
    svNoFocused,
    { for Buttons }
    svDefault,
    svDisabled,
    svClicked,
    { for CheckBox and RadioButton }
    svChecked,
    svNoChecked,
    svGrayed,
    { never visible }
    svNever,
    { for PageControl }
    svTabActive,
    svTabNoActive
  );

  TscVisibleSet = set of TscVisible;

{ Object aligns }

  TscAlign = (
    saNone,
    saLeft,
    saMostLeft,
    saTop,
    saMostTop,
    saRight,
    saMostRight,
    saBottom,
    saMostBottom,
    saClient,
    saTopLeft,
    saTopRight,
    saBottomLeft,
    saBottomRight,
    saCenter,
    saText
  );

{ Object kinds }

  TscKind = (
    skNone,
    skForm,
    skCalButonu,
    skDuraklatbutonu,
    skGeriButonu,
    skkaisik,
    skdevamli,
    sksesayar,
    skUstPanel,
    skOrtaPanel,
    SkAltpanel,
    skekobant1,
    skekobant2,
    skekobant3,
    skekobant4,
    skekobant5,
    skekobant6,
    skekobant7,
    skekobant8,
    skekobant9,
    skekobant10,
    sksarkibar,
    skekolayzirbutonu,
    skeklebutonu,
    sktemizlebutonu,
    sksarkigoster,
    skekogoster,
    SkileriButonu,
    skDurdurbutonu,
    skSessizButonu,
    skCaption,
    skTitle,
    skTop,
    skLeft,
    skRight,
    skBottom,
    skTopLeft,
    skTopRight,
    skBottomLeft,
    skBottomRight,
    skMenuBar,
    skMenuBarItem,
    skPopupMenu,
    skPopupMenuItem,
    skPopupMenuClient,
    skSysButton,
    skClient,

    skButton,
    skButtonGlyph,
    skButtonText,

    skProgressBar,
    skProgressBarBack,
    skProgressBarFore,

    skPanel,
    skPanelText,

    skCheckBox,
    skCheckBoxGlyph,
    skCheckBoxText,

    skRadioButton,
    skRadioButtonGlyph,
    skRadioButtonText,

    skPageControl,
    skPageControlTab,
    skPageControlClient
  );

{ Text out }

  TscTextAlign = (
    taTopLeft,
    taTopCenter,
    taTopRight,
    taLeft,
    taCenter,
    taRight,
    taBottomLeft,
    taBottomCenter,
    taBottomRight
  );

{ Window }

  TscBorderIcon = (
    sbSystemMenu,
    sbMinimize,
    sbMaximize,
    sbHelp,
    sbRollup,
    sbClose
  );

  TscBorderIcons = set of TscBorderIcon;

  TscWindowState = (
    wsMinimized,
    wsMaximized,
    wsRollup,
    wsStayOnTop,
    wsMDIChild,
    wsSizeable
  );

  TscWindowStates = set of TscWindowState;

{ Drawing }

  TscTileStyle = (
    tsTile,
    tsStretch,
    tsStretchLinear,
    tsCenter
  );

{ Mask and regions }

  TscMaskType = (
    smNone,
    smColor,
    smImage
  );

{ Effects }

  TSlideDirection = (
    sdLeftToRight,
    sdRightToLeft,
    sdTopToBottom,
    sdBottomToTop
  );

const

  SRollup = 'Rollu&p';

{$IFNDEF KS_D5} { Win2K and Win98 extentions }
  {$IFNDEF KS_CB5}
  TPM_NOANIMATION     = $4000;
  DT_HIDEPREFIX = $00100000;
  {$ENDIF}
{$ENDIF}

  CM_RECREATEWINDOW  = CM_BASE + 82;
  CM_DESTROYHOOK     = CM_BASE + 83;

  TransColor = $FF00FF;

  WM_DRAWSKIN   = WM_USER + 109;

  WM_ROLLUP     = WM_USER + 105;
  WM_STAYONTOP  = WM_USER + 106;

  WM_TRACKSKINPOPUPMENU = WM_USER + 107;
  WM_TRACKSYSTEMMENU = WM_USER + 108;

  WM_SKINCHANGE = WM_USER + 109;

  WM_SKINSYSCOMMAND = WM_USER + 111;

  WM_SKINMAINMENUCHANGED = WM_USER + 112;

function GetToken(var S: string): string;

{ graphics }

procedure PaintBackground(Control: TWinControl; Canvas: TCanvas);
procedure PaintBackgroundEx(Control: TWinControl; DC: HDC);

implementation {===============================================================}

{ strings }

function GetToken(var S: string): string;
var
  i: byte;
  CopyS: string;
begin
  Result := '';
  CopyS := S;
  for i := 1 to Length(CopyS) do
  begin
    Delete(S, 1, 1);
    if CopyS[i] in [',', ' ', '(', ')', ';'] then Break;
    Result := Result + CopyS[i];
  end;
  Trim(Result);
  Trim(S);
end;

{ graphics }

type
  TParentControl = class(TWinControl);

procedure PaintBackground(Control: TWinControl; Canvas: TCanvas);
var
  B: TBitmap;
begin
  if Assigned(Control) and Assigned(Control.Parent) then
  begin
    B := TBitmap.Create;
    try
      B.Width := TParentControl(Control.Parent).Width;
      B.Height := TParentControl(Control.Parent).Height;

      SendMessage(Control.Parent.Handle, WM_ERASEBKGND, B.Canvas.Handle, 0);
      TParentControl(Control.Parent).PaintControls(B.Canvas.Handle, nil);

      { Paint to DC }
      Canvas.Draw(-Control.Left, -Control.Top, B); 
    finally
      B.Free;
    end;
  end;
end;

procedure PaintBackgroundEx(Control: TWinControl; DC: HDC);
var
  Canvas: TCanvas;
  SaveIndex: integer;
begin
  SaveIndex := SaveDC(DC);
  try
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      PaintBackground(Control, Canvas);
      Canvas.Handle := 0;
    finally
      Canvas.Free;
    end;
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;


end.
 
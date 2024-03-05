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
                         
unit SPUtils;

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

interface

{$R-}

uses
  Windows, Controls, Messages, SysUtils, Classes, Graphics, IniFiles, JPeg,
  ImgList, spEffBmp, ExtCtrls,
  spPngImageList, spPngImage{$IFDEF VER200}, PngImage {$ENDIF};

const
  maxi = 10000;
  //

  SP_XP_BTNFRAMECOLOR = 8388608;
  SP_XP_BTNACTIVECOLOR = 13811126;
  SP_XP_BTNDOWNCOLOR = 11899781;

  CM_SEPAINT  = CM_BASE + 456;
  CM_SENCPAINT    = CM_BASE + 457;
  SE_RESULT = $3233;
  CM_CANSTARTFORMANIMATION = CM_BASE + 434;
  CM_STARTFORMANIMATION = CM_BASE + 435;
  CM_STOPFORMANIMATION = CM_BASE + 436;
  SE_STOPANIMATION = $3234;
  SE_CANANIMATION = $3235;
  
type

  DWMWINDOWATTRIBUTE = (
    DWMWA_NULL,
    DWMWA_NCRENDERING_ENABLED,
    DWMWA_NCRENDERING_POLICY,
    DWMWA_TRANSITIONS_FORCEDISABLED,
    DWMWA_ALLOW_NCPAINT,
    DWMWA_CAPTION_BUTTON_BOUNDS,
    DWMWA_NONCLIENT_RTL_LAYOUT,
    DWMWA_FORCE_ICONIC_REPRESENTATION,
    DWMWA_FLIP3D_POLICY,
    DWMWA_LAST
  );

  _DWM_BLURBEHIND = packed record
    dwFlags: DWORD;
    fEnable: Bool;
    hRgnBlur: HRGN;
    fTransitionOnMaximized: Bool;
  end;

  PDWM_BLURBEHIND = ^_DWM_BLURBEHIND;
  TDWM_BLURBEHIND = _DWM_BLURBEHIND;

  TspStretchType = (spstFull, spstHorz, spstVert);

{ TFBitmap }

  TFBColor  = record b,g,r:Byte end;
  PFBColor  =^TFBColor;
  TBLine    = array[0..0]of TFBColor;
  PBLine    =^TBLine;
  TPLines  = array[0..0]of PBLine;
  PPLines  =^TPLines;

  TFBitmap = class
  private
    Bits:   Pointer;
    procedure   Initialize;
  public
    Pixels: PPLines;
    Gap,
    RowInc,
    Size,   
    Width,
    Height: Integer;
    Handle,
    hDC:        Integer;
    bmInfo:     TBitmapInfo;
    bmHeader:   TBitmapInfoHeader;
    constructor Create(HBmp:Integer);
    destructor  Destroy; override;
  end;

  TspNumGlyphs = 1..4;
  TspButtonLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);

  TRectArray = array[0..maxi] of TRect;
  
//
  TspLayerWindow = class(TCustomControl)
  protected
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TspLayerManager = class(TComponent)
  protected
    LayerWindow: TspLayerWindow;
    Bmp: TspBitMap;
    Timer: TTimer;
    EndAlphaBlendValue: Integer;
    BeginAlphaBlendValue: Integer;
    StepAlphaBlendValue: Integer;
    procedure ExecTimer(Sender: TObject);
  public
    IsVisible: Boolean;
    TopMostMode: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartTimer;
    procedure StopTimer;
    procedure Show(X, Y: Integer; AImage, AImageMask: TBitMap; AAlphaBlendValue: Integer);
    procedure Hide;
    procedure Update;
  end;

//
function EqRects(R1, R2: TRect): Boolean;
function EqPoints(const Pt1, Pt2: TPoint): Boolean;
function NullRect: TRect;
function IsNullRect(R: TRect): Boolean;
function IsNullPoint(P: TPoint): Boolean;
function RectInRect(R1, R2: TRect): Boolean;
function RectToRect(R1, R2: TRect): Boolean;
//
function RectWidth(R: TRect): Integer;
function RectHeight(R: TRect): Integer;
function RectToCenter(var R: TRect; Bounds: TRect): TRect;
// Region functions
function CreateRgnFromBmp(B: TBitmap; XO, YO: Integer; var RgnData: PRgnData): integer;
// Stream functions
procedure WriteStringToStream(Str: String; S: TStream);
procedure ReadStringFromStream(var Str: String; S: TStream);
// Skin functions
function GetRect(S: String): TRect;
function GetPoint(S: String): TPoint;
function SetRect(R: TRect): String;


procedure CreateSkinBorderImages(LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  LeftB, TopB, RightB, BottomB, SB: TBitMap; R: TRect; AW, AH: Integer;
  LS, TS, RS, BS: Boolean);

procedure CreateSkinImageBS(LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; DrawClient: Boolean;
  LS, TS, RS, BS: Boolean; AStretchEffect: Boolean; AStretchType: TspStretchType);

procedure CreateSkinBG(ClRect: TRect; NewClRect: TRect;
   B, SB: TBitMap; R: TRect; AW, AH: Integer; AStretch: Boolean;
   AStretchType: TspStretchType);

procedure CreateSkinImage(LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; ADrawClient: Boolean;
  ALeftStretch, ATopStretch, ARightStretch, ABottomStretch,
  AClientStretch: Boolean; AStretchType: TspStretchType);

procedure CreateSkinImage2(LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; ADrawClient,
  ALeftStretch, ATopStretch, ARightStretch, ABottomStretch,
  AClientStretch: Boolean; AStretchType: TspStretchType);


procedure CreateStretchImage(B: TBitMap;  SB: TBitMap; R: TRect; ClRect: TRect;
                             ADrawClient: Boolean);

procedure CreateHSkinImage(LO, RO: Integer;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; AStretch: Boolean);

procedure CreateHSkinImage2(LO, RO: Integer;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; AStretch: Boolean);

procedure CreateHSkinImage3(LO, RO: Integer;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; AStretch: Boolean);

procedure CreateVSkinImage(TpO, BO: Integer;
  B, SB: TBitMap; R: TRect; AW, AH: Integer; AStretch: Boolean);
  
procedure CreateSkinMask(LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  FMask, RMTop, RMLeft, RMRight, RMBottom: TBitMap; AW, AH: Integer);

procedure CreateSkinSimplyRegion(var FRgn: HRgn; FMask: TBitMap);

procedure CreateSkinRegion(var FRgn: HRgn;
  LtPt, RTPt, LBPt, RBPt: TPoint; ClRect: TRect;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint; NewClRect: TRect;
  FMask: TBitMap; AW, AH: Integer);

procedure DrawGlyph(Cnvs: TCanvas; X, Y: Integer; FGlyph: TBitMap;
                    FNumGlyphs, FGlyphNum: Integer);

// IniFile funcitons
function ReadRect(IniFile: TCustomIniFile; Section: String; Ident: String): TRect;
function ReadPoint(IniFile: TCustomIniFile; Section: String; Ident: String): TPoint;
function ReadBoolean(IniFile: TCustomIniFile; Section: String; Ident: String): Boolean;
function ReadFontStyles(IniFile: TCustomIniFile;
                        Section: String; Ident: String): TFontStyles;
procedure ReadStrings(IniFile: TCustomIniFile;
                      Section: String; Ident: String; S: TStrings);
procedure ReadStrings1(IniFile: TCustomIniFile;
                       Section: String; Ident: String; S: TStrings);
function ReadAlignment(IniFile: TCustomIniFile;
                       Section: String; Ident: String): TAlignment;
procedure WriteAlignment(IniFile: TCustomIniFile;
                         Section: String; Ident: String; A: TAlignment);
procedure WriteRect(IniFile: TCustomIniFile; Section: String; Ident: String; R: TRect);
procedure WritePoint(IniFile: TCustomIniFile; Section: String; Ident: String; P: TPoint);
procedure WriteBoolean(IniFile: TCustomIniFile; Section: String; Ident: String; B: Boolean);
procedure WriteFontStyles(IniFile: TCustomIniFile;
                          Section: String; Ident: String; FS: TFontStyles);
procedure WriteStrings(IniFile: TCustomIniFile;
                       Section: String; Ident: String; S: TStrings);
procedure WriteStrings1(IniFile: TCustomIniFile;
                        Section: String; Ident: String; S: TStrings);

procedure GetScreenImage(X, Y: Integer; B: TBitMap);

procedure GetWindowsVersion(var Major, Minor: Integer);
function CheckW2KWXP: Boolean;

function CheckWXP: Boolean;

procedure SetAlphaBlendTransparent(WHandle: HWnd; Value: Byte);

function IsJpegFile(AFileName: String): Boolean;
procedure LoadFromJpegFile(SB: TBitMap; AFileName: String);
procedure LoadFromJpegStream(SB: TBitMap; AStream: TStream);
procedure LoadFromJPegImage(SB: TBitMap; JI: TJpegImage);

procedure Frm3D(Canvas: TCanvas; Rect: TRect; TopColor, BottomColor: TColor);
procedure DrawRadioImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawCheckImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawArrowImage(Cnvs: TCanvas; R: TRect; Color: TColor; Code: Integer);
procedure DrawArrowImage3(Cnvs: TCanvas; R: TRect; Color: TColor; Code: Integer);
procedure DrawTrackArrowImage(Cnvs: TCanvas; R: TRect; Color: TColor);
procedure GetParentImage(Control: TControl; Dest: TCanvas);
procedure GetParentImageRect(Control: TControl; Rct: TRect; Dest: TCanvas);
function PointInRect(R: TRect; P: TPoint): Boolean;

function CalcTextWidthW(C: TCanvas; Str: WideString): Integer;
function CalcTextHeightW(C: TCanvas; Str: WideString): Integer;
function SPDrawSkinText(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal): integer;
procedure SPDrawText(Cnvs: TCanvas; S: String; R: TRect);
procedure SPDrawText2(Cnvs: TCanvas; S: String; R: TRect);
procedure SPDrawText3(Cnvs: TCanvas; S: String; R: TRect; HorOffset: Integer);
procedure SPDrawTextCenterMultiLine(Cnvs: TCanvas; S: String; R: TRect; AModify: Boolean);
procedure SPDrawTextCenter(Cnvs: TCanvas; S: String; R: TRect);
procedure SPDrawTextAlignment(Cnvs: TCanvas; S: String; R: TRect; AAlignment: TAlignment);


procedure DrawCloseImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawRCloseImage(C: TCanvas; R: TRect; Color: TColor);
procedure DrawMinimizeImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawMaximizeImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawRollUpImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawRestoreRollUpImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawRestoreImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawSysMenuImage(C: TCanvas; X, Y: Integer; Color: TColor);
procedure DrawMTImage(C: TCanvas; X, Y: Integer; Color: TColor);

function ExtractDay(ADate: TDateTime): Word;
function ExtractMonth(ADate: TDateTime): Word;
function ExtractYear(ADate: TDateTime): Word;
function IsLeapYear(AYear: Integer): Boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;

function Max(A, B: Longint): Longint;
function Min(A, B: Longint): Longint;

procedure CorrectTextbyWidth(C: TCanvas; var S: String; W: Integer);
procedure CorrectTextbyWidthW(C: TCanvas; var S: WideString; W: Integer);

function GetMonitorWorkArea(const W: HWND; const WorkArea: Boolean): TRect;
function GetPrimaryMonitorWorkArea(const WorkArea: Boolean): TRect;
function MyGetScrollBarInfo(wnd: Cardinal; idObject: Longint; var psbi: TScrollBarInfo): BOOL;

function IsW7: Boolean;
function IsVistaOs: Boolean;
function Is9XOS: Boolean;


procedure DrawGlyphAndTextGlow(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor;
  FGlowColor: TColor; FGlowSize: Integer);

procedure DrawImageAndTextGlow(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor;
            FGlowColor: TColor; FGlowSize: Integer);

procedure DrawGlyphAndTextGlow2(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor;
  FGlowColor: TColor; FGlowSize: Integer);

procedure DrawImageAndTextGlow2(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor;
            FGlowColor: TColor; FGlowSize: Integer);

procedure DrawGlyphAndText2(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

procedure DrawImageAndText2(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);


function Darker(Color:TColor; Percent:Byte):TColor;

procedure CreateAlphaLayered(ABmp: TBitmap; AMaskBmp: TBitMap; AAlphaBlendValue: Integer; AControl: TWinControl);
procedure CreateAlphaLayer(ABmp: TBitmap; AMaskBmp: TBitMap;
                           AlphaBmp: TspBitmap);
procedure CreateAlphaLayered2(AlphaBmp: TspBitmap; AAlphaBlendValue: Integer;
                              AControl: TWinControl);

procedure CalcLCoord(Layout: TspButtonLayout; R: TRect; gw, gh, tw, th: Integer;
  Spacing, Margin: Integer; var tx, ty, gx, gy: Integer);

procedure DrawImageAndText(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

procedure DrawGlyphAndText(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor);



var
  SP_PlatformIsUnicode: Boolean;
  GetScrollBarInfoFunc: function (wnd: Cardinal; idObject: Longint; var psbi: TScrollBarInfo): BOOL; stdcall;

  SetLayeredWindowAttributes: function (hwnd: HWND; crKey: COLORREF; bAlpha: BYTE;
    dwFlags: DWORD): BOOL; stdcall;

  UpdateLayeredWindow: function (hWnd: HWND; hdcDst: HDC; pptDst: PPOINT;
    psize: PSIZE; hdcSrc: HDC; pptSrc: PPOINT; crKey: COLORREF;
    pblend: PBlendFunction; dwFlags: DWORD): BOOL; stdcall;


  // Aero

  DwmIsCompositionEnabled: function(pfEnabled: Pbool): HRESULT; stdcall;
  DwmSetWindowAttribute: function(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; size: cardinal): HRESULT; stdcall;
  DwmEnableBlurBehindWindow: function (hWnd : HWND; const pBlurBehind : PDWM_BLURBEHIND) : HRESULT; stdcall;

  //


  procedure DrawSkinFocusRect(C: TCanvas; R: TRect);

  procedure MakeCopyFromPng(B :TspBitMap; P: TspPngImage);
  procedure MakeCopyFromPng2(B :TspBitMap; P: TspPngImage);
  procedure MakeBlurBlank(B :TspBitMap; P: TspPngImage; BlurSize: Integer);
  procedure MakeBlurBlank2(B :TspBitMap; SB: TBitmap; BlurSize: Integer);
  procedure MakeBlurBlank3(B :TspBitMap; IL: TCustomImageList; Index: Integer; BlurSize: Integer);

  procedure DrawEffectText(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);

  procedure DrawEffectText2(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);


  procedure DrawReflectionText(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal;
  const ReflectionOffset: integer = 1;
  const ReflectionColor: cardinal = $202020);

  procedure DrawEffectTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);

  procedure DrawEffectTextW2(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);

  procedure DrawReflectionTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal;
  const ReflectionOffset: integer = 1;
  const ReflectionColor: cardinal = $202020);

  procedure DrawVistaEffectTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
   const ShadowColor: cardinal = $202020);

  procedure DrawVistaEffectTextW2(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
   const ShadowColor: cardinal = $202020);

  procedure DrawVistaEffectText(const Canvas: TCanvas;
   ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
   const ShadowColor: cardinal = $202020);


  function IsWindowsAero: Boolean;
  procedure SetDWMAnimation(AHandle: HWND; AEnabled: Boolean);
  procedure SetBlurBehindWindow(AHandle: HWND; AEnabled: Boolean; ARgn: HRGN);

  function MiddleColor(TheColor1, TheColor2: TColor): TColor;


  procedure DrawTextWithAlpha(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal);
  procedure DrawImageWithAlpha(AImageList: TCustomImageList; AImageIndex: Integer; Cnvs: TCanvas;
    X, Y: Integer; AEnabled: Boolean);
  procedure DrawImageAndTextWithAlpha(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

   
implementation //========================================================

uses Forms, Consts, SkinTabs;

const
  LWA_ALPHA = $2;

type
  TParentControl = class(TWinControl);

// draw image with alpha
procedure DrawImageWithAlpha(AImageList: TCustomImageList; AImageIndex: Integer; Cnvs: TCanvas;
    X, Y: Integer; AEnabled: Boolean);
var
  Buffer, Buffer2, Buffer3: TspBitmap;
  i, j: Integer;
  C1, C2: PspColor;
begin
  if AImageList = nil then Exit;
  if not ((AImageIndex >= 0) and (AImageIndex < AImageList.Count)) then Exit;
  if AImageList is TspPngImageList
  then
    begin
      Buffer := TspBitmap.Create;
      Buffer.AlphaBlend := True;
      Buffer.SetSize(AImageList.Width, AImageList.Height);
      if AEnabled
      then
        begin
          Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          Cnvs, Rect(X, Y,
           X + AImageList.Width, Y + AImageList.Height));
          //
          Buffer2 := TspBitmap.Create;
          Buffer2.SetSize(AImageList.Width, AImageList.Height);
          MakeCopyFromPng(Buffer2,
          TspPngImageList(AImageList).PngImages.Items[AImageIndex].PngImage);
          for i := 0 to Buffer2.Width - 1 do
          for j := 0 to Buffer2.Height - 1 do
          begin
            C1 := Buffer2.PixelPtr[i, j];
            TspColorRec(C1^).R := 255;
            TspColorRec(C1^).G := 255;
            TspColorRec(C1^).B := 255;
          end;
          //
          Buffer3 := TspBitmap.Create;
          Buffer3.SetSize(AImageList.Width, AImageList.Height);
          for i := 0 to Buffer3.Width - 1 do
          for j := 0 to Buffer3.Height - 1 do
          begin
            C1 := Buffer3.PixelPtr[i, j];
            C2 := Buffer.PixelPtr[i, j];
            TspColorRec(C1^).R := TspColorRec(C2^).A;
            TspColorRec(C1^).G := TspColorRec(C2^).A;
            TspColorRec(C1^).B := TspColorRec(C2^).A;
            TspColorRec(C1^).A := 255;
          end;
          Buffer2.Draw(Buffer3, 0, 0);
          //
          Buffer.SetAlpha(255);
          AImageList.Draw(Buffer.Canvas, 0, 0, AImageIndex, True);
          CreateAlphaByMask(Buffer, Buffer3);
          //
          Buffer2.Free;
          Buffer3.Free;
        end
      else
        begin
          Buffer2 := TspBitMap.Create;
          Buffer2.SetSize(Buffer.Width, Buffer.Height);
          Buffer2.Canvas.CopyRect(Rect(0, 0, Buffer2.Width, Buffer2.Height),
          Cnvs, Rect(X, Y,
            X + AImageList.Width, Y + AImageList.Height));
          Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          Cnvs, Rect(X, Y, X + AImageList.Width, Y + AImageList.Height));
          Buffer.SetAlpha(255);
          AImageList.Draw(Buffer.Canvas, 0, 0, AImageIndex, False);
          for i := 0 to Buffer.Width - 1 do
          for j := 0 to Buffer.Height - 1 do
          begin
            C1 := Buffer.PixelPtr[i, j];
            C2 := Buffer2.PixelPtr[i, j];
            TspColorRec(C1^).A := TspColorRec(C2^).A;
          end;
          Buffer2.Free;
        end;
        Buffer.Draw(Cnvs, X, Y);
        Buffer.Free;
   end
    else
      begin
        Buffer := TspBitmap.Create;
        Buffer.SetSize(AImageList.Width, AImageList.Height);
        Buffer.FillRect(Rect(0, 0, Buffer.Width, Buffer.Height), spTransparent);
        Buffer.Transparent := True;
        AImageList.Draw(Buffer.Canvas, 0, 0, AImageIndex, AEnabled);
        Buffer.CheckingTransparent;
        Buffer.Draw(Cnvs, X, Y);
        Buffer.Free;
      end;
end;

// draw text with alpha
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
  B.Draw(ACanvas.Handle, Bounds.Left, Bounds.Top);
  B.Free;
  B2.Free;
end;

procedure DrawImageAndTextWithAlpha(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
             DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
      end;
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawTextWithAlpha(Cnvs, Caption, TR, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_WORDBREAK);
    end;
  if gw <> 0
  then
    begin
      DrawImageWithAlpha(IL, ImageIndex, Cnvs, GX, GY, AEnabled);
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + IL.Height - 2);
          LineTo(GX + IL.Width, GY + IL.Height - 2);
          MoveTo(GX, GY + IL.Height - 1);
          LineTo(GX + IL.Width, GY + IL.Height - 1);
          MoveTo(GX, GY + IL.Height);
          LineTo(GX + IL.Width, GY + IL.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom );
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;
end;


//


function MiddleColor(TheColor1, TheColor2: TColor): TColor;
var
  r1, g1, b1, r2, g2, b2: Byte;
begin
  TheColor1 := ColorToRGB(TheColor1);
  TheColor2 := ColorToRGB(TheColor2);
  //
  r1 := GetRValue(TheColor1);
  g1 := GetGValue(TheColor1);
  b1 := GetBValue(TheColor1);
  r2 := GetRValue(TheColor2);
  g2 := GetGValue(TheColor2);
  b2 := GetBValue(TheColor2);
  //
  r1 := (r1 + r2) div 2;
  if r1 > 255 then r1 := 255;
  g1 := (g1 + g2) div 2;
  if g1 > 255 then g1 := 255;
  b1 := (b1 + b2) div 2;
  if b1 > 255 then b1 := 255;
  //
  Result := RGB(r1, g1, b1);
end;
//

procedure DrawSkinFocusRect(C: TCanvas; R: TRect);
var
  i: Integer;
  B1: Boolean;
begin
  Dec(R.Right, 1);
  Dec(R.Bottom, 1);
  C.Pen.Color := C.Font.Color;
  B1 := ((RectWidth(R) div 2) = (RectWidth(R) / 2)) and
        ((RectHeight(R) div 2) = (RectHeight(R) / 2));
  for i := R.Left to R.Right  do
  begin
    B1 := not B1;
    if B1 then C.Pixels[i, R.Top] := C.Font.Color;
  end;
  if not B1 then B1 := True else B1 := False;
  for i := R.Top to R.Bottom  do
  begin
    B1 := not B1;
    if B1 then C.Pixels[R.Right, i] := C.Font.Color;
  end;
  if not B1 then B1 := True else B1 := False;
  for i := R.Right downto R.Left  do
  begin
    B1 := not B1;
    if B1 then C.Pixels[i, R.Bottom] := C.Font.Color;
  end;
  if not B1 then B1 := True else B1 := False;
  for i := R.Bottom downto R.Top  do
  begin
    B1 := not B1;
    if B1 then C.Pixels[R.Left, i] := C.Font.Color;
  end;
end;

procedure CalcLCoord(Layout: TspButtonLayout; R: TRect; gw, gh, tw, th: Integer;
  Spacing, Margin: Integer; var tx, ty, gx, gy: Integer);
var
  H, W, H1, W1: Integer;
begin
 H := R.Top + RectHeight(R) div 2;
 W := R.Left + RectWidth(R) div 2;
 if gw = 0 then Spacing := 0;
 if Margin = -1
 then
   begin
     W1 := (tw + gw + Spacing) div 2;
     H1 := (th + gh + Spacing) div 2;
     case Layout of
       blGlyphRight:
         begin
           tx := W - W1;
           ty := H - th div 2;
           gx := W + W1 - gw;
           gy := H - gh div 2;
         end;
      blGlyphLeft:
         begin
           gx := W - W1;
           gy := H - gh div 2;
           tx := W + W1 - tw;
           ty := H - th div 2;
         end;
      blGlyphTop:
         begin
           tx := W - tw div 2;
           ty := H + H1 - th;
           gx := W - gw div 2;
           gy := H - H1;
        end;
     blGlyphBottom:
        begin
          gx := W - gw div 2;
          gy := H + H1 - gh;
          tx := W - tw div 2;
          ty := H - H1;
       end;
     end;
   end
 else
   begin
     case Layout of
       blGlyphRight:
         begin
           gy := H - gh div 2;
           gx := R.Right - gw - Margin;
           tx := gx - Spacing - tw;
           ty := H - th div 2;
         end;
       blGlyphLeft:
         begin
           gy := H - gh div 2;
           gx := R.Left + Margin;
           tx := gx + gw + Spacing;
           ty := H - th div 2;
         end;
       blGlyphTop:
          begin
            gy := R.Top +  Margin;
            gx := W - gw div 2;
            ty := gy + gh + Spacing;
            tx := W - tw div 2;
          end;
      blGlyphBottom:
          begin
            gy := R.Bottom - gh - Margin;
            gx := W - gw div 2;
            ty := gy - Spacing - th;
            tx := W - tw div 2;
         end;
       end;
    end;
end;

procedure DrawImageAndText(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
             DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
      end;
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_WORDBREAK);
    end;
  if gw <> 0
  then
    begin
      IL.Draw(Cnvs, GX, GY, ImageIndex, AEnabled);
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + IL.Height - 2);
          LineTo(GX + IL.Width, GY + IL.Height - 2);
          MoveTo(GX, GY + IL.Height - 1);
          LineTo(GX + IL.Width, GY + IL.Height - 1);
          MoveTo(GX, GY + IL.Height);
          LineTo(GX + IL.Width, GY + IL.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom );
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;
end;

procedure DrawGlyphAndText(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor);
var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if Glyph.Empty
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := Glyph.Width div NumGlyphs;
      gh := Glyph.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
        Brush.Style := bsClear;
     end;
  end;

  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);

  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;

  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawText(Cnvs.Handle, PChar(Caption),
        Length(Caption), TR, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_WORDBREAK);
    end;
      
  if not Glyph.Empty then DrawGlyph(Cnvs, GX, GY, Glyph, NumGlyphs, GlyphNum);

  if not Glyph.Empty
  then
    begin
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + Glyph.Height - 2);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 2);
          MoveTo(GX, GY + Glyph.Height - 1);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 1);
          MoveTo(GX, GY + Glyph.Height);
          LineTo(GX + Glyph.Width, GY + Glyph.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom);
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;

end;


function MyGetScrollBarInfo(wnd: Cardinal; idObject: Longint; var psbi: TScrollBarInfo): BOOL;
begin
  if @GetScrollBarInfoFunc <> nil then
    Result := GetScrollBarInfoFunc(wnd, idObject, psbi)
  else
  begin
    { Win95 }
    psbi.rgstate[0] := STATE_SYSTEM_INVISIBLE;
    Result := false;
  end;
end;

procedure CorrectTextbyWidth(C: TCanvas; var S: String; W: Integer);
var
  j: Integer;
begin
  j := Length(S);
  with C do
  begin
    if TextWidth(S) > w
    then
      begin
        repeat
          Delete(S, j, 1);
          Dec(j);
        until (TextWidth(S + '...') <= w) or (S = '');
        S := S + '...';
      end;
  end;
end;


procedure GetControls(X, Y, W, H: Integer;
                      Control: TCustomControl; Dest: TCanvas);
var
  I, Count, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
  Ctrl: TControl;
begin
  Count := Control.ControlCount;
  DC := Dest.Handle;
  SelfR := Bounds(0, 0, W, H);
  // Copy images of controls
  for I := 0 to Count - 1 do
  begin
    Ctrl := Control.Controls[I];
    if (Ctrl <> nil) and (Ctrl is TCustomControl)
    then
      begin
        with Ctrl do
        begin
          CtlR := Bounds(X + Left, Y + Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then
          begin
            SaveIndex := SaveDC(DC);
            SetViewportOrgEx(DC, Left + X, Top + Y, nil);
            IntersectClipRect(DC, 0, 0, Width, Height);
            Perform(WM_PAINT, DC, 0);
            RestoreDC(DC, SaveIndex);
            if TCustomControl(Ctrl).ControlCount <> 0
            then
              GetControls(Left + X, Top + Y, W, H,
              TCustomControl(Ctrl), Dest);
          end;
       end;
    end;
  end;
end;


procedure GetParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  with Control.Parent do ControlState := ControlState + [csPaintCopy];
  try
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
       if (Control.Parent is TForm) and
          (TForm(Control.Parent).FormStyle = fsMDIForm)
       then
         begin
           SendMessage(TForm(Control.Parent).ClientHandle, WM_ERASEBKGND, DC, 0);
         end
      else
      if Control.Parent is TspSkinTabControl
      then
        begin
          TspSkinTabControl(Control.Parent).PaintBG(DC);
       end
      else
      with TParentControl(Control.Parent) do begin
        Perform(WM_ERASEBKGND, DC, 0);
        if not (Control.Parent is TForm) then PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;

    for I := 0 to Count - 1 do
    if Control.Parent.Controls[I] <> Control
    then
    begin
      if (Control.Parent.Controls[I] <> nil) and
         (Control.Parent.Controls[I] is TGraphicControl)
      then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
            ControlState := ControlState + [csPaintCopy];
            SaveIndex := SaveDC(DC);
            try
              SaveIndex := SaveDC(DC);
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
              ControlState := ControlState - [csPaintCopy];
            end;
          end;
        end;
      end;
    end
    else
      Break;
  finally
    with Control.Parent do ControlState := ControlState - [csPaintCopy];
  end;
end;


procedure GetParentImageRect(Control: TControl; Rct: TRect; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  with Control.Parent do ControlState := ControlState + [csPaintCopy];
  try
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left - Rct.Left; Y := -Top - Rct.Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
      if (Control.Parent is TForm) and
         (TForm(Control.Parent).FormStyle = fsMDIForm)
       then
         begin
           SendMessage(TForm(Control.Parent).ClientHandle, WM_ERASEBKGND, DC, 0);
         end
      else
      if Control.Parent is TspSkinTabControl
      then
        begin
          TspSkinTabControl(Control.Parent).PaintBG(DC);
       end
      else
      with TParentControl(Control.Parent) do begin
        Perform(WM_ERASEBKGND, DC, 0);
        if not (Control.Parent is TForm) then PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    
    for I := 0 to Count - 1 do
    if Control.Parent.Controls[I] <> Control
    then
    begin
      if (Control.Parent.Controls[I] <> nil) and
         (Control.Parent.Controls[I] is TGraphicControl)
      then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
            ControlState := ControlState + [csPaintCopy];
            SaveIndex := SaveDC(DC);
            try
              SaveIndex := SaveDC(DC);
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
              ControlState := ControlState - [csPaintCopy];
            end;
          end;
        end;
      end
    end
    else
      Break;
  finally
    with Control.Parent do ControlState := ControlState - [csPaintCopy];
  end;
end;


function CalcTextWidthW(C: TCanvas; Str: WideString): Integer;
var
  R: TRect;
begin
  R := Rect(0, 0, 0, 0);
  SPDrawSkinText(C, Str, R, DT_CALCRECT);
  Result := RectWidth(R);
end;

function CalcTextHeightW(C: TCanvas; Str: WideString): Integer;
var
  R: TRect;
begin
  R := Rect(0, 0, 0, 0);
  SPDrawSkinText(C, Str, R, DT_CALCRECT);
  Result := RectHeight(R);
end;

procedure CorrectTextbyWidthW(C: TCanvas; var S: WideString; W: Integer);

function GetTextWidth(Str: WideString): Integer;
var
  R: TRect;
begin
  R := Rect(0, 0, 0, 0);
  SPDrawSkinText(C, Str, R, DT_CALCRECT);
  Result := RectWidth(R);
end;

var
  j: Integer;
begin
  j := Length(S);
  if GetTextWidth(S) > w
  then
   begin
     repeat
       Delete(S, j, 1);
       Dec(j);
     until (GetTextWidth(S + '...') <= w) or (S = '');
    S := S + '...';
  end;
end;

function SPDrawSkinText(ACanvas: TCanvas; AText: WideString; var Bounds: TRect; Flag: cardinal): integer;
var
  AnsiText: string;
begin
  if SP_PlatformIsUnicode
  then
    Result := Windows.DrawTextW(ACanvas.Handle, PWideChar(AText), Length(AText), Bounds, Flag)
  else
  begin
    AnsiText := WideCharToString(PWideChar(AText));
    Result := Windows.DrawText(ACanvas.Handle, PChar(AnsiText), Length(AnsiText), Bounds, Flag);
  end;
end;

procedure SPDrawText(Cnvs: TCanvas; S: String; R: TRect);
begin
  if S = '' then Exit;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(R.Top, 1);
  //
  DrawText(Cnvs.Handle, PChar(S), Length(S), R,
    DT_VCENTER or DT_SINGLELINE or DT_LEFT);
end;

function Max(A, B: Longint): Longint;
begin
  if A > B then Result := A
  else Result := B;
end;

function Min(A, B: Longint): Longint;
begin
  if A < B then Result := A
  else Result := B;
end;


procedure SPDrawText2(Cnvs: TCanvas; S: String; R: TRect);
var
  TX, TY: Integer;
begin
  if S = '' then Exit;
  TX := R.Left + 2;
  TY := R.Top + RectHeight(R) div 2 - Cnvs.TextHeight(S) div 2;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TY, 1);
  //
  Cnvs.TextRect(R, TX, TY, S);
end;

procedure SPDrawTextAlignment(Cnvs: TCanvas; S: String; R: TRect; AAlignment: TAlignment);
begin
  if S = '' then Exit;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(R.Top, 1);
  //
  case AAlignment of
    taLeftJustify:
      DrawText(Cnvs.Handle, PChar(S), Length(S), R,  DT_VCENTER or DT_SINGLELINE or DT_LEFT);
    taRightJustify:
      DrawText(Cnvs.Handle, PChar(S), Length(S), R,  DT_VCENTER or DT_SINGLELINE or DT_RIGHT);
    taCenter:
      DrawText(Cnvs.Handle, PChar(S), Length(S), R,  DT_VCENTER or DT_SINGLELINE or DT_CENTER);
  end;
end;

procedure SPDrawTextCenterMultiLine(Cnvs: TCanvas; S: String; R: TRect; AModify: Boolean);
var
  S1, S2: String;
  TempR: TRect;
  I, WordsCount: Integer;
  Words: array[1..50] of String;
  FStopAdd: Boolean;
begin
  if S = '' then Exit;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(R.Top, 1);
  S1 := '';
  S2 := '';
  //
  if not AModify
  then
    begin
      FStopAdd := False;
      for I := 1 to Length(S) do
      begin
        S1 := S1 + S[I];
        TempR := Rect(0, 0, 0, 0);
        DrawText(Cnvs.Handle, PChar(S1), Length(S1), TempR, DT_LEFT or DT_CALCRECT);
        if FStopAdd and (S[I] = ' ') then FStopAdd := False;
        if not FStopAdd then 
        if (RectWidth(TempR) > RectWidth(R)) and (S[I] <> ' ')
        then
           begin
             if Length(S2) > 3
             then
               begin
                 S2[Length(S2)] := '.';
                 S2[Length(S2) - 1] := '.';
                 S2[Length(S2) - 2] := '.';
               end;
             S2 := S2 + ' ';
             S1 := '';
             FStopAdd := True;
           end
        else
          begin
            S2 := S2 + S[I];
            if S[I] = ' ' then S1 := '';
          end;
       end;
    end
  else
  for I := 1 to Length(S) do
  begin
    S1 := S1 + S[I];
    TempR := Rect(0, 0, 0, 0);
    DrawText(Cnvs.Handle, PChar(S1), Length(S1), TempR, DT_LEFT or DT_CALCRECT);
    if (RectWidth(TempR) > RectWidth(R)) and (S[I] <> ' ')
    then
      begin
        S2 := S2 + ' ' + S[I];
        S1 := '';
      end
    else
      begin
        S2 := S2 + S[I];
        if S[I] = ' ' then S1 := '';
      end;
  end;
  S := S2;
  DrawText(Cnvs.Handle, PChar(S), Length(S), R, DT_WORDBREAK or DT_CENTER);
end;

procedure SPDrawTextCenter(Cnvs: TCanvas; S: String; R: TRect);
begin
  if S = '' then Exit;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(R.Top, 1);
  //
  DrawText(Cnvs.Handle, PChar(S), Length(S), R, DT_CENTER);
end;


procedure SPDrawText3(Cnvs: TCanvas; S: String; R: TRect; HorOffset: Integer);
var
  TX, TY: Integer;
begin
  if S = '' then Exit;
  TX := R.Left + 2 + HorOffset;
  TY := R.Top + RectHeight(R) div 2 - Cnvs.TextHeight(S) div 2;
  //
  if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TY, 1);
  //
  Cnvs.TextRect(R, TX, TY, S);
end;

procedure DrawArrowImage3(Cnvs: TCanvas; R: TRect; Color: TColor; Code: Integer);
var
  i: Integer;
  X, Y: Integer;
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    case Code of
      1:
        begin
          X := R.Left + RectWidth(R) div 2 - 1;
          Y := R.Top + RectHeight(R) div 2;
          for i := 0 to 2 do
          begin
            MoveTo(X + i, Y - i);
            LineTo(X + i, Y + i + 1);
          end;
        end;
      2:
        begin
          X := R.Left + RectWidth(R) div 2 + 1;
          Y := R.Top + RectHeight(R) div 2;
          for i := 2 downto 0 do
           begin
             MoveTo(X - i, Y + i);
             LineTo(X - i, Y - i - 1);
           end;
        end;
      3:
        begin
          X := R.Left + RectWidth(R) div 2;
          Y := R.Top + RectHeight(R) div 2 - 1;
          for i := 0 to 2 do
          begin
            MoveTo(X - i, Y + i);
            LineTo(X + i + 1, Y + i);
          end;
        end;
      4:
        begin
          X := R.Left + RectWidth(R) div 2;
          Y := R.Top + RectHeight(R) div 2 + 1;
          for i := 2 downto 0 do
          begin
            MoveTo(X - i, Y - i);
            LineTo(X + i + 1, Y - i);
          end;
        end;
    end;
  end;
end;

procedure DrawTrackArrowImage(Cnvs: TCanvas; R: TRect; Color: TColor);
var
  X, Y, i: Integer;
begin
  X := R.Left + RectWidth(R) div 2;
  Y := R.Top + RectHeight(R) div 2 + 2;
  for i := 2 downto 0 do
  with Cnvs do
  begin
    Pen.Color := Color;
    MoveTo(X - i, Y - i);
    LineTo(X + i + 1, Y - i);
  end;
end;

procedure DrawArrowImage(Cnvs: TCanvas; R: TRect; Color: TColor; Code: Integer);
var
  i: Integer;
  X, Y: Integer;
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    case Code of
      1:
        begin
          X := R.Left + RectWidth(R) div 2 - 2;
          Y := R.Top + RectHeight(R) div 2;
          for i := 0 to 3 do
          begin
            MoveTo(X + i, Y - i);
            LineTo(X + i, Y + i + 1);
          end;
        end;
      2:
        begin
          X := R.Left + RectWidth(R) div 2 + 2;
          Y := R.Top + RectHeight(R) div 2;
          for i := 3 downto 0 do
           begin
             MoveTo(X - i, Y + i);
             LineTo(X - i, Y - i - 1);
           end;
        end;
      3:
        begin
          X := R.Left + RectWidth(R) div 2;
          Y := R.Top + RectHeight(R) div 2 - 2;
          for i := 0 to 3 do
          begin
            MoveTo(X - i, Y + i);
            LineTo(X + i + 1, Y + i);
          end;
        end;
      4:
        begin
          X := R.Left + RectWidth(R) div 2;
          Y := R.Top + RectHeight(R) div 2 + 2;
          for i := 3 downto 0 do
          begin
            MoveTo(X - i, Y - i);
            LineTo(X + i + 1, Y - i);
          end;  
        end;
      5: begin
           X := R.Left + RectWidth(R) div 2;
           Y := R.Top + RectHeight(R) div 2;
           MoveTo(X - 4, Y - 1);
           LineTo(X + 4 , Y - 1);
           MoveTo(X - 4, Y);
           LineTo(X + 4 , Y);
           //
           MoveTo(X - 1, Y - 4);
           LineTo(X - 1, Y + 4);
           MoveTo(X, Y - 4);
           LineTo(X, Y + 4);
         end;
    end;
  end;
end;

procedure DrawRadioImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    Brush.Color := Color;
    Rectangle(X, Y, X + 6, Y + 6);
  end;
end;

procedure DrawCheckImage(Cnvs: TCanvas; X, Y: Integer; Color: TColor);
var
  i: Integer;
begin
  with Cnvs do
  begin
    Pen.Color := Color;
    for i := 0 to 2 do
    begin
      MoveTo(X, Y + 5 - i);
      LineTo(X + 2, Y + 7 - i);
      LineTo(X + 7, Y + 2 - i);
    end;
  end;
end;

function IsJpegFile(AFileName: String): Boolean;
begin
  Result := (Pos('.jpg', AFileName) <> 0) or
            (Pos('.jpeg', AFileName) <> 0);
end;

procedure LoadFromJPegImage(SB: TBitMap; JI: TJpegImage);
begin
  SB.Width := JI.Width;
  SB.Height := JI.Height;
  SB.Canvas.Draw(0, 0, JI);
end;

procedure LoadFromJpegStream(SB: TBitMap; AStream: TStream);
var
  JI: TJpegImage;
begin
  JI := TJpegImage.Create;
  JI.LoadFromStream(AStream);
  SB.Width := JI.Width;
  SB.Height := JI.Height;
  SB.Canvas.Draw(0, 0, JI);
  JI.Free;
end;

procedure LoadFromJpegFile(SB: TBitMap; AFileName: String);
var
  JI: TJpegImage;
begin
  JI := TJpegImage.Create;
  JI.LoadFromFile(AFileName);
  SB.Width := JI.Width;
  SB.Height := JI.Height;
  SB.Canvas.Draw(0, 0, JI);
  JI.Free;
end;


procedure Frm3D;
  procedure DoRect;
  var
    TopRight, BottomLeft: TPoint;
  begin
    with Canvas, Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      Pen.Color := TopColor;
      PolyLine([BottomLeft, TopLeft, TopRight]);
      Pen.Color := BottomColor;
      Dec(BottomLeft.X);
      PolyLine([TopRight, BottomRight, BottomLeft]);
    end;
  end;

begin
  Canvas.Pen.Width := 1;
  Dec(Rect.Bottom); Dec(Rect.Right);
  DoRect;
end;

procedure GetWindowsVersion(var Major, Minor: Integer);
var
  Ver : Longint;
begin
  Ver := GetVersion;
  Major := LoByte(LoWord(Ver));
  Minor := HiByte(LoWord(Ver));
end;

function IsW7: Boolean;
var
  Major, Minor : Integer;
begin
  GetWindowsVersion(major, minor);
  Result := (major = 6) and (minor = 1);
end;

function IsVistaOs: Boolean;
var
  Major, Minor : Integer;
begin
  GetWindowsVersion(major, minor);
  Result := (major >= 6);
end;

function Is9XOS: Boolean;
var
  Major, Minor : Integer;
begin
  GetWindowsVersion(major, minor);
  Result := (major < 5);
end;

function CheckWXP: Boolean;
var
  Major, Minor : Integer;
begin
  GetWindowsVersion(major, minor);
  Result := (major > 5) or ((major = 5) and (minor = 1));
end;

function CheckW2kWXP: Boolean;
var
  Major, Minor : Integer;
begin
  GetWindowsVersion(major, minor);
  Result := (major > 5) or ((major = 5) and ((minor = 0) or (minor = 1) or (minor = 2)));
end;

procedure SetAlphaBlendTransparent;
begin
  if @SetLayeredWindowAttributes <> nil
  then
    SetLayeredWindowAttributes(WHandle, 0, Value, LWA_ALPHA);
end;

procedure GetScreenImage(X, Y: Integer; B: TBitMap);
var
  DC: HDC;
begin
  DC := GetDC(0);
  BitBlt(B.Canvas.Handle, 0, 0,
         B.Width, B.Height, DC, X, Y, SrcCopy);
  ReleaseDC(0, DC);
end;

function EqPoints(const Pt1, Pt2: TPoint): Boolean;
begin
  Result := (Pt1.X = Pt2.X) and (Pt1.Y = Pt2.Y);
end;

function EqRects(R1, R2: TRect): Boolean;
begin
  Result := (R1.Left = R2.Left) and (R1.Top = R2.Top) and
            (R1.Right = R2.Right) and (R1.Bottom = R2.Bottom);
end;

function NullRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
end;

function IsNullRect(R: TRect): Boolean;
begin
  Result := (R.Right - R.Left <= 0) or (R.Bottom - R.Top <= 0)
end;

function IsNullPoint(P: TPoint): Boolean;
begin
  Result := (P.X = 0) or (P.Y = 0);
end;

function PointInRect(R: TRect; P: TPoint): Boolean;
begin
  Result := (P.X >= R.Left) and (P.Y >= R.Top) and
            (P.X <= R.Right) and (P.Y <= R.Bottom);
end;

function RectInRect(R1, R2: TRect): Boolean;
begin
  Result := PtInRect(R2, R1.TopLeft) and PtInRect(R2, R1.BottomRight)
end;

function RectToRect(R1, R2: TRect): Boolean;
begin
  R1.Left := R2.Left + 1;
  R1.Right := R2.Right - 1;
  Result := PtInRect(R2, R1.TopLeft) or PtInRect(R2, R1.BottomRight);
end;

function RectToCenter(var R: TRect; Bounds: TRect): TRect;
begin
  OffsetRect(R, -R.Left, -R.Top);
  OffsetRect(R, (RectWidth(Bounds) - RectWidth(R)) div 2, (RectHeight(Bounds) - RectHeight(R)) div 2);
  OffsetRect(R, Bounds.Left, Bounds.Top);
  Result := R;
end;

function RectWidth;
begin
  Result := R.Right - R.Left;
end;

function RectHeight;
begin
  Result := R.Bottom - R.Top;
end;

const
    nums = '1234567890';
    symbols = ', ';

function GetPoint(S: String): TPoint;
var
  i, j: Integer;
  S1: String;
  SA: array[1..2] of String;
begin
  S1 := '';
  j := 1;
  for i := 1 to Length(S) do
  begin
    if S[i] = ','
    then
      begin
        SA[j] := S1;
        S1 := '';
        Inc(j);
      end
    else
      if Pos(S[i], nums) <> 0 then S1 := S1 + S[i];
  end;
  SA[j] := S1;
  Result := Point(StrToInt(SA[1]), StrToInt(SA[2]));;
end;

function GetRect(S: String): TRect;
var
  i, j: Integer;
  S1: String;
  SA: array[1..4] of String;
begin
  S1 := '';
  j := 1;
  for i := 1 to Length(S) do
  begin
    if S[i] = ','
    then
      begin
        SA[j] := S1;
        S1 := '';
        Inc(j);
      end
    else
      if Pos(S[i], nums) <> 0 then S1 := S1 + S[i];
  end;
  SA[j] := S1;
  Result := Rect(StrToInt(SA[1]), StrToInt(SA[2]),
                 StrToInt(SA[3]), StrToInt(SA[4]));
end;

function SetRect(R: TRect): String;
begin
  Result := IntToStr(R.Left) + ',' +
    IntToStr(R.Top) + ',' + IntToStr(R.Right) + ',' +
    IntToStr(R.Bottom);
end;

function ReadRect;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, '0,0,0,0');
  Result := GetRect(S);
end;

function ReadPoint;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, '0,0');
  Result := GetPoint(S);
end;

function ReadBoolean;
var
  I: Integer;
begin
  I := IniFile.ReadInteger(Section, Ident, 0);
  Result := I = 1;
end;

function ReadFontStyles;
var
  FS: TFontStyles;
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, '');
  FS := [];
  if Pos('fsbold', S) <> 0 then FS := FS + [fsBold];
  if Pos('fsitalic', S) <> 0 then FS := FS + [fsItalic];
  if Pos('fsunderline', S) <> 0 then FS := FS + [fsUnderline];
  if Pos('fsstrikeout', S) <> 0 then FS := FS + [fsStrikeOut];
  Result := FS;
end;

procedure ReadStrings;
var
  Count, i: Integer;
begin
  Count := IniFile.ReadInteger(Section, Ident + 'linecount', 0);
  for i := 0 to Count - 1 do
    S.Add(IniFile.ReadString(Section, Ident + 'line' + IntToStr(i), ''));
end;

procedure ReadStrings1;
var
  Count, i: Integer;
begin
  Count := IniFile.ReadInteger(Section, Ident + 'count', 0);
  for i := 0 to Count - 1 do
    S.Add(IniFile.ReadString(Section, IntToStr(i), ''));
end;

procedure WriteRect;
var
  S: String;
begin
  S := IntToStr(R.Left) + ',' + IntToStr(R.Top) + ',' +
       IntToStr(R.Right) + ',' + IntToStr(R.Bottom);
  IniFile.WriteString(Section, Ident, S);
end;

procedure WritePoint;
var
  S: String;
begin
  S := IntToStr(P.X) + ',' + IntToStr(P.Y);
  IniFile.WriteString(Section, Ident, S);
end;

procedure WriteBoolean;
var
  I: Integer;
begin
  if B then I := 1 else I := 0;
  IniFile.WriteInteger(Section, Ident, I);
end;

procedure WriteFontStyles;
var
  S: String;
begin
  S := '';
  if fsBold in FS then S := S + 'fsbold';
  if fsItalic in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsitalic';
    end;
  if fsUnderline in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsunderline';
    end;
  if fsStrikeOut in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsstrikeout';
    end;
  IniFile.WriteString(Section, Ident, S);
end;

procedure WriteStrings;
var
  i: Integer;
begin
  IniFile.WriteInteger(Section, Ident + 'linecount', S.Count);
  for i := 0 to S.Count - 1 do
    IniFile.WriteString(Section, Ident + 'line' + IntToStr(i), S[i]);
end;

procedure WriteStrings1;
var
  i: Integer;
begin
  IniFile.WriteInteger(Section, Ident + 'count', S.Count);
  for i := 0 to S.Count - 1 do
    IniFile.WriteString(Section, IntToStr(i), S[i]);
end;

function ReadAlignment;
var
  S: String;
begin
  S := IniFile.ReadString(Section, Ident, 'tacenter');
  if S = 'tacenter' then Result := taCenter else
  if S = 'taleftjustify' then Result := taLeftJustify else
  Result := taRightJustify;
end;

procedure WriteAlignment;
var
  S: String;
begin
  if A = taCenter then S := 'tacenter' else
  if A = taLeftJustify then S := 'taleftjustify' else
  S := 'tarightjustify';
  IniFile.WriteString(Section, Ident, S);
end;

{ TFBitmap }
constructor TFBitmap.Create(HBmp:Integer);
var
  Bmp:   Windows.TBITMAP;
  memDC: Integer;
begin
  GetObject(hBmp,SizeOf(Bmp),@Bmp);
  Width:=Bmp.bmWidth;
  Height:=Bmp.bmHeight;
  Size:=((Width*3)+(Width mod 4))*Height;
  with bmHeader do
  begin
    biSize:=SizeOf(bmHeader);
    biWidth:=Width;
    biHeight:=-Height;
    biPlanes:=1;
    biBitCount:=24;
    biCompression:=BI_RGB;
  end;
  bmInfo.bmiHeader:=bmHeader;
  Handle:=CreateDIBSection(0,
                 bmInfo,
                 DIB_RGB_COLORS,
                 Bits, 0, 0);
  memDC:=GetDC(0);
  GetDIBits(memDC,hBmp,0,Height,Bits,bmInfo,DIB_RGB_COLORS);
  ReleaseDC(0,memDC);
  Initialize;
end;

destructor TFBitmap.Destroy;
begin
  DeleteDC(hDC);
  DeleteObject(Handle);
  FreeMem(Pixels);
  inherited;
end;

procedure TFBitmap.Initialize;
var
  x,i: Integer;
begin
  GetMem(Pixels,Height*SizeOf(PBLine));
  RowInc:=(Width*3)+Width mod 4;
  Gap:=Width mod 4;
  Size:=RowInc*Height;
  x:=Integer(Bits);
  for i:=0 to Height-1 do
  begin
    Pixels[i]:=Pointer(x);
    Inc(x,RowInc);
  end;
  hDC:=CreateCompatibleDC(0);
  SelectObject(hDC,Handle);
end;

// Region convert
function CreateRgnFromBmp(B: TBitmap; XO, YO: Integer; var RgnData: PRgnData): integer;
const
  max = 10000;
var
  j, i, i1: integer;
  C: TFBColor;
  FB: TFBitmap;
  Rts: array [0..max] of TRect;
  Count: integer;
begin
  Result := 0;
  If B.Empty Then Exit;
  Count := 0;
  FB := TFBitmap.Create(B.Handle);
  for j := 0 to FB.Height - 1 do
  begin
    i := 0;
    while i < FB.Width do
    begin
      C := FB.Pixels[j, i];
      If C.R + C.G + C.B = 0 Then
      begin
        i1 := i;
        C := FB.Pixels[j, i1];
        while C.R + C.G + C.B = 0 do
        begin
          Inc(i1);
          If i1 > FB.Width - 1 Then Break else C := FB.Pixels[j, i1];
        end;
        Rts[Count] := Rect(i + XO, j + YO, i1 + XO, j + 1 + YO);
        Inc(Count);
        i := i1;
        Continue;
      end;
      Inc(i);
    end;
  end;
  FB.Free;
  // Make Region data
  Result := Count*SizeOf(TRect);
  GetMem(Rgndata, SizeOf(TRgnDataHeader)+Result);
  FillChar(Rgndata^, SizeOf(TRgnDataHeader)+Result, 0);
  RgnData^.rdh.dwSize := SizeOf(TRgnDataHeader);
  RgnData^.rdh.iType := RDH_RECTANGLES;
  RgnData^.rdh.nCount := Count;
  RgnData^.rdh.nRgnSize := 0;
  RgnData^.rdh.rcBound := Rect(0 + XO, 0 + YO, B.Width + XO, B.Height + YO);
  // Update New Region
  Move(Rts, RgnData^.Buffer, Result);
  Result := SizeOf(TRgnDataHeader)+Count*SizeOf(TRect);
end;

procedure WriteStringToStream(Str: String; S: TStream);
var
  L: Integer;
begin
  L := Length(Str);
  S.Write(L, SizeOf(Integer));
  S.Write(Pointer(Str)^, L);
end;


procedure ReadStringFromStream(var Str: String; S: TStream);
var
  L: Integer;
begin
  L := 0;
  S.Read(L, SizeOf(Integer));
  SetLength(Str, L);
  S.Read(Pointer(Str)^, L);
end;

procedure CreateStretchImage;
var
  LTPt, RTPt, LBPt, RBPt: TPoint;
  NewLTPt, NewRTPt, NewLBPt, NewRBPt: TPoint;
  NewClRect: TRect;
begin
  LtPt := Point(ClRect.Left, ClRect.Top);
  RtPt := Point(ClRect.Right, ClRect.Top);
  LBPt := Point(ClRect.Left, ClRect.Bottom);
  RBPt := Point(ClRect.Right, ClRect.Bottom);

  NewClRect := ClRect;
  NewClRect.Right := B.Width - (RectWidth(R) - ClRect.Right);
  NewClRect.Bottom := B.Height - (RectHeight(R) - ClRect.Bottom);

  NewLtPt := Point(NewClRect.Left, NewClRect.Top);
  NewRtPt := Point(NewClRect.Right, NewClRect.Top);
  NewLBPt := Point(NewClRect.Left, NewClRect.Bottom);
  NewRBPt := Point(NewClRect.Right, NewClRect.Bottom);

  CreateSkinImage(LtPt, RTPt, LBPt, RBPt, ClRect,
    NewLTPt, NewRTPt, NewLBPt, NewRBPt, NewClRect,
    B, SB, R, B.Width, B.Height, ADrawClient,
    True, True, True, True, True, spstFull);
end;


procedure CreateHSkinImage;
var
  X, XCnt, w, XO: Integer;
  R1: TRect;
  Buffer: TBitMap;
begin
  B.Width := AW;
  B.Height := RectHeight(R);
  with B.Canvas do
  begin
    if LO <> 0 then
       CopyRect(Rect(0, 0, LO, B.Height), SB.Canvas,
                Rect(R.Left, R.Top, R.Left + LO, R.Bottom));
    if RO <> 0 then
       CopyRect(Rect(B.Width - RO, 0, B.Width, B.Height),
                SB.Canvas,
                Rect(R.Right - RO, R.Top, R.Right, R.Bottom));
    Inc(R.Left, LO);
    Dec(R.Right, RO);
    w := RectWidth(R);
    if w = 0 then w := 1;
    XCnt := (B.Width - LO - RO) div w;
    if AStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R);
        Buffer.Height := RectHeight(R);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
         SB.Canvas, R);
        R1 := Rect(LO, 0, B.Width - RO, B.Height);
        B.Canvas.StretchDraw(R1, Buffer);
        Buffer.Free;
      end
    else
    for X := 0 to XCnt do
    begin
      if LO + X * w + w > B.Width - RO
      then XO := LO + X * w + w - (B.Width - RO)
      else XO := 0;
      B.Canvas.CopyRect(Rect(LO + X * w, 0, LO + X * w + w - XO,
                        B.Height),
                        SB.Canvas,
                        Rect(R.Left, R.Top, R.Right - XO, R.Bottom));
    end;
  end;
end;

procedure CreateHSkinImage2;
var
  X, XCnt, w, XO: Integer;
  R1: TRect;
  Buffer: TBitMap;
begin
  B.Width := AW;
  B.Height := RectHeight(R);
  with B.Canvas do
  begin
    if LO <> 0 then
       CopyRect(Rect(0, 0, LO, B.Height), SB.Canvas,
                Rect(R.Left, R.Top, R.Left + LO, R.Bottom));
    Inc(R.Left, LO);
    Dec(R.Right, RO);
    w := RectWidth(R);
    if w = 0 then w := 1;
    XCnt := (B.Width - LO) div w;
    if AStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R);
        Buffer.Height := RectHeight(R);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
         SB.Canvas, R);
        R1 := Rect(LO, 0, B.Width, B.Height);
        B.Canvas.StretchDraw(R1, Buffer);
        Buffer.Free;
      end
    else
    for X := 0 to XCnt do
    begin
      if LO + X * w + w > B.Width
      then XO := LO + X * w + w - B.Width
      else XO := 0;
      B.Canvas.CopyRect(Rect(LO + X * w, 0, LO + X * w + w - XO,
                        B.Height),
                        SB.Canvas,
                        Rect(R.Left, R.Top, R.Right - XO, R.Bottom));
    end;
  end;
end;

procedure CreateHSkinImage3;
var
  X, XCnt, w, XO: Integer;
  R1: TRect;
  Buffer: TBitMap;
begin
  B.Width := AW;
  B.Height := RectHeight(R);
  with B.Canvas do
  begin
    Inc(R.Left, LO);
    Dec(R.Right, RO);
    w := RectWidth(R);
    if w = 0 then w := 1;
    XCnt := B.Width div w;
    if AStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R);
        Buffer.Height := RectHeight(R);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          SB.Canvas, R);
        R1 := Rect(0, 0, B.Width, B.Height);
        B.Canvas.StretchDraw(R1, Buffer);
        Buffer.Free;
      end
    else
    for X := 0 to XCnt do
    begin
      if LO + X * w + w > B.Width
      then XO := LO + X * w + w - B.Width
      else XO := 0;
      B.Canvas.CopyRect(Rect(X * w, 0, X * w + w - XO,
                        B.Height),
                        SB.Canvas,
                        Rect(R.Left, R.Top, R.Right - XO, R.Bottom));
    end;
  end;
end;


procedure CreateVSkinImage;
var
  Y, YCnt, h, YO: Integer;
  R1: TRect;
  Buffer: TBitMap;
begin
  B.Width := RectWidth(R);
  B.Height := AH;
  with B.Canvas do
  begin
    if TpO <> 0 then
       CopyRect(Rect(0, 0, B.Width, TpO), SB.Canvas,
                Rect(R.Left, R.Top, R.Right, R.Top + TpO));
    if BO <> 0 then
       CopyRect(Rect(0, B.Height - BO, B.Width, B.Height),
                SB.Canvas,
                Rect(R.Left, R.Bottom - BO, R.Right, R.Bottom));
    Inc(R.Top, TpO);
    Dec(R.Bottom, BO);
    h := RectHeight(R);
    if H <> 0
    then
      YCnt := (B.Height - TpO - BO) div h
    else
      YCnt := 0;
    if AStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R);
        Buffer.Height := RectHeight(R);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
         SB.Canvas, R);
        R1 := Rect(0, TpO, B.Width, B.Height - BO);
        B.Canvas.StretchDraw(R1, Buffer);
        Buffer.Free;
      end
    else
    for Y := 0 to YCnt do
    begin
      if TpO + Y * h + h > B.Height - BO
      then YO := TpO + Y * h + h - (B.Height - BO)
      else YO := 0;
      B.Canvas.CopyRect(
        Rect(0, TpO + Y * h, B.Width, TpO + Y * h + h - YO),
        SB.Canvas,
        Rect(R.Left, R.Top, R.Right, R.Bottom - YO));
    end;
  end;
end;


procedure CreateSkinImageBS;
var
  w, h, rw, rh: Integer;
  X, Y, XCnt, YCnt: Integer;
  XO, YO: Integer;
  Rct, SRct: TRect;
  Buffer, Buffer2: TBitMap;
  SaveIndex: Integer;
begin
  B.Width := AW;
  B.Height := AH;
  if (RBPt.X - LTPt.X  = 0) or
     (RBPt.Y - LTPt.Y = 0) or SB.Empty then  Exit;
  with B.Canvas do
  begin
    // Draw lines
    // top
    if not TS
    then
      begin
        w := RTPt.X - LTPt.X;
        XCnt := (NewRTPt.X - NewLTPt.X) div (RTPt.X - LTPt.X);
        for X := 0 to XCnt do
        begin
          if NewLTPt.X + X * w + w > NewRTPt.X
          then XO := NewLTPt.X + X * w + w - NewRTPt.X else XO := 0;
          CopyRect(Rect(NewLTPt.X + X * w, 0, NewLTPt.X + X * w + w - XO, NewClRect.Top),
               SB.Canvas, Rect(R.Left + LTPt.X, R.Top,
                 R.Left + RTPt.X - XO, R.Top + ClRect.Top));
        end;
      end
    else
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RTPt.X - LTPt.X;
        Buffer.Height := CLRect.Top;
        Rct := Rect(R.Left + LTPt.X, R.Top, R.Left + RTPt.X, R.Top + CLRect.Top);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          SB.Canvas, Rct);
        SRct := Rect(NewLTPt.X, 0, NewRTPt.X, NewCLRect.Top);
        StretchDraw(SRct, Buffer);
        Buffer.Free;
      end;
    // bottom
    if not BS
    then
      begin
        w := RBPt.X - LBPt.X;
        XCnt := (NewRBPt.X - NewLBPt.X) div (RBPt.X - LBPt.X);
        for X := 0 to XCnt do
        begin
         if NewLBPt.X + X * w + w > NewRBPt.X
         then XO := NewLBPt.X + X * w + w - NewRBPt.X else XO := 0;
           CopyRect(Rect(NewLBPt.X + X * w, NewClRect.Bottom, NewLBPt.X + X * w + w - XO, AH),
                    SB.Canvas, Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom,
                     R.Left + RBPt.X - XO, R.Bottom));
        end;             
      end
    else
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RBPt.X - LBPt.X;
        Buffer.Height := RectHeight(R) - CLRect.Bottom;
        Rct := Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom,
                    R.Left + RBPt.X, R.Bottom);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          SB.Canvas, Rct);
        SRct := Rect(NewLBPt.X, NewCLRect.Bottom, NewRBPt.X, B.Height);
        StretchDraw(SRct, Buffer);
        Buffer.Free;
      end;
    // left
    w := NewClRect.Left;
    h := LBPt.Y - LTPt.Y;
    if not LS
    then
      begin
        YCnt := (NewLBPt.Y - NewLTPt.Y) div h;
        for Y := 0 to YCnt do
        begin
          if NewLTPt.Y + Y * h + h > NewLBPt.Y
          then YO := NewLTPt.Y + Y * h + h - NewLBPt.Y else YO := 0;
          CopyRect(Rect(0, NewLTPt.Y + Y * h, w, NewLTPt.Y + Y * h + h - YO),
                   SB.Canvas,
                   Rect(R.Left, R.Top + LTPt.Y, R.Left + w, R.Top + LBPt.Y - YO));
        end;
      end
    else
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := ClRect.Left;
        Buffer.Height := LBPt.Y - LTPt.Y;
        Rct := Rect(R.Left, R.Top + LTPt.Y,
                    R.Left + CLRect.Left, R.Top + LBPt.Y);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          SB.Canvas, Rct);
        SRct := Rect(0, NewLTPt.Y, NewCLRect.Left, NewLBPt.Y);
        StretchDraw(SRct, Buffer);
        Buffer.Free;
      end;
    // right
    h := RBPt.Y - RTPt.Y;
    if not RS
    then
      begin
        YCnt := (NewRBPt.Y - NewRTPt.Y) div h;
        for Y := 0 to YCnt do
        begin
          if NewRTPt.Y + Y * h + h > NewRBPt.Y
          then YO := NewRTPt.Y + Y * h + h - NewRBPt.Y else YO := 0;
          CopyRect(Rect(NewClRect.Right, NewRTPt.Y + Y * h,
                    AW, NewRTPt.Y + Y * h + h - YO),
                   SB.Canvas,
                   Rect(R.Left + ClRect.Right, R.Top + RTPt.Y,
                   R.Right, R.Top + RBPt.Y - YO));
        end;
      end
    else
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R) - ClRect.Right;
        Buffer.Height := RBPt.Y - RTPt.Y;
        Rct := Rect(R.Left + ClRect.Right, R.Top + RTPt.Y,
                    R.Right, R.Top + RBPt.Y);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
          SB.Canvas, Rct);
        SRct := Rect(NewClRect.Right, NewRTPt.Y, B.Width, NewRBPt.Y);
        StretchDraw(SRct, Buffer);
        Buffer.Free;
      end;

    // Draw corners
    // lefttop

    CopyRect(Rect(0, 0, NewLTPt.X, NewClRect.Top),
             SB.Canvas, Rect(R.Left, R.Top,
                             R.Left + LTPt.X, R.Top + ClRect.Top));

    CopyRect(Rect(0, NewClRect.Top, NewClRect.Left, NewLTPt.Y),
             SB.Canvas, Rect(R.Left, R.Top + ClRect.Top,
                             R.Left + ClRect.left, R.Top + LTPT.Y));

    //topright

    CopyRect(Rect(NewRTPt.X, 0, AW, NewClRect.Top), SB.Canvas,
             Rect(R.Left + RTPt.X, R.Top,  R.Right, R.Top + ClRect.Top));
    CopyRect(Rect(NewClRect.Right, NewClRect.Top, AW, NewRTPt.Y), SB.Canvas,
             Rect(R.Left + ClRect.Right, R.Top + ClRect.Top,
             R.Right, R.Top + RTPt.Y));

    //leftbottom

    CopyRect(Rect(0, NewLBPt.Y, NewClRect.Left, AH), SB.Canvas,
             Rect(R.Left, R.Top + LBPt.Y, R.Left + ClRect.Left, R.Bottom));

    CopyRect(Rect(NewClRect.Left, NewClRect.Bottom, NewLBPt.X, AH), SB.Canvas,
             Rect(R.Left + ClRect.Left, R.Top + ClRect.Bottom, R.Left + LBPt.X, R.Bottom));


    //rightbottom

    CopyRect(Rect(NewRBPt.X, NewClRect.Bottom, AW, AH), SB.Canvas,
             Rect(R.Left + RBPt.X, R.Top + ClRect.Bottom, R.Right, R.Bottom));

    CopyRect(Rect(NewClRect.Right, NewRBPt.Y, AW, NewClRect.Bottom), SB.Canvas,
             Rect(R.Left + ClRect.Right, R.Top + RBPt.Y,
                  R.Right, R.Top + ClRect.Bottom));

    //Draw client
    w := RectWidth(ClRect);
    h := RectHeight(ClRect);
    rw := RectWidth(NewClRect);
    rh := RectHeight(NewClRect);
    if DrawClient and AStretchEffect
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(ClRect);
        Buffer.Height := RectHeight(ClRect);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
        SB.Canvas, Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
          R.Left + ClRect.Right, R.Top + ClRect.Bottom));

        if (RectWidth(NewClRect) > 0) and (RectHeight(NewClRect) > 0) then  
        case AStretchType of
         spstFull:
           StretchDraw(NewClRect, Buffer);
         spstHorz:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NewClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := Buffer.Width;
             Buffer2.Height := RectHeight(NewClRect);
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             XCnt := RectWidth(NewClRect) div Buffer2.Width;
             for X := 0 to XCnt do
               B.Canvas.Draw(NewClRect.Left + X * Buffer2.Width, NewClRect.Top, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
         spstVert:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NewClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := RectWidth(NewClRect);
             Buffer2.Height := Buffer.Height;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             YCnt := RectHeight(NewClRect) div Buffer2.Height;
             for Y := 0 to YCnt do
               B.Canvas.Draw(NewClRect.Left, NewClRect.Top + Y * Buffer2.Height, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
        end;

        Buffer.Free;
      end
    else
    if DrawClient
    then
      begin
        // Draw client area
        XCnt := rw div w;
        YCnt := rh div h;
        for X := 0 to XCnt do
        for Y := 0 to YCnt do
        begin
          if X * w + w > rw then XO := X * W + W - rw else XO := 0;
          if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
          CopyRect(Rect(NewClRect.Left + X * w, NewClRect.Top + Y * h,
             NewClRect.Left + X * w + w - XO,
             NewClRect.Top + Y * h + h - YO),
             SB.Canvas,
             Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
             R.Left + ClRect.Right - XO,
             R.Top + ClRect.Bottom - YO));
         end;
    end;
  end;
end;

procedure CreateSkinBG;
var
  w, h, rw, rh: Integer;
  X, Y, XCnt, YCnt: Integer;
  XO, YO: Integer;
  Buffer, Buffer2: TBitMap;
begin
  B.Width := AW;
  B.Height := AH;
  if RectWidth(NewClRect) = 0 then Exit;
  if RectHeight(NewClRect) = 0 then Exit;
  with B.Canvas do
  begin
    w := RectWidth(ClRect);
    h := RectHeight(ClRect);
    rw := RectWidth(NewClRect);
    rh := RectHeight(NewClRect);
    XCnt := rw div w;
    YCnt := rh div h;
    if AStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(ClRect);
        Buffer.Height := RectHeight(ClRect);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
         SB.Canvas, Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
                         R.Left + ClRect.Right, R.Top + ClRect.Bottom));
        if (RectWidth(NewClRect) > 0) and (RectHeight(NewClRect) > 0) then                  
        case AStretchType of
         spstHorz:
           begin
             Buffer2 := TBitMap.Create;
             Buffer2.Width := Buffer.Width;
             Buffer2.Height := RectHeight(NewClRect);
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             XCnt := RectWidth(NewClRect) div Buffer2.Width;
             for X := 0 to XCnt do
               B.Canvas.Draw(NewClRect.Left + X * Buffer2.Width, NewClRect.Top, Buffer2);
             Buffer2.Free;
           end;
         spstVert:
           begin
             Buffer2 := TBitMap.Create;
             Buffer2.Width := RectWidth(NewClRect);
             Buffer2.Height := Buffer.Height;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             YCnt := RectHeight(NewClRect) div Buffer2.Height;
             for Y := 0 to YCnt do
               B.Canvas.Draw(NewClRect.Left, NewClRect.Top + Y * Buffer2.Height, Buffer2);
             Buffer2.Free;
           end;
         spstFull:
           begin
             B.Canvas.StretchDraw(NewClRect, Buffer);
           end;
        end;
        //
        Buffer.Free;
      end
    else
    for X := 0 to XCnt do
    for Y := 0 to YCnt do
    begin
      if X * w + w > rw then XO := X * W + W - rw else XO := 0;
      if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
       CopyRect(Rect(X * w, Y * h, X * w + w - XO, Y * h + h - YO),
         SB.Canvas,
         Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
         R.Left + ClRect.Right - XO,
         R.Top + ClRect.Bottom - YO));
    end;
  end;
end;

procedure CreateSkinImage;
var
  w, h, rw, rh: Integer;
  X, Y, XCnt, YCnt: Integer;
  XO, YO: Integer;
  R1, R2, R3: TRect;
  Buffer, Buffer2: TBitMap;
  SaveIndex: Integer;
begin
  B.Width := AW;
  B.Height := AH;
  if (RBPt.X - LTPt.X  = 0) or
     (RBPt.Y - LTPt.Y = 0) or SB.Empty then  Exit;
  with B.Canvas do
  begin
    // Draw lines
    // top
    if not ATopStretch
    then
      begin
        w := RTPt.X - LTPt.X;
        XCnt := (NewRTPt.X - NewLTPt.X) div (RTPt.X - LTPt.X);
        for X := 0 to XCnt do
        begin
          if NewLTPt.X + X * w + w > NewRTPt.X
          then XO := NewLTPt.X + X * w + w - NewRTPt.X else XO := 0;
           CopyRect(Rect(NewLTPt.X + X * w, 0, NewLTPt.X + X * w + w - XO, NewClRect.Top),
                    SB.Canvas, Rect(R.Left + LTPt.X, R.Top,
                    R.Left + RTPt.X - XO, R.Top + ClRect.Top));
        end;
    end
    else
    begin
      R1 := Rect(NewLTPt.X, 0, NewRTPt.X, NewClRect.Top);
      R2 := Rect(R.Left + LTPt.X, R.Top, R.Left + RTPt.X, R.Top + ClRect.Top);
      Buffer := TBitMap.Create;
      Buffer.Width := RectWidth(R2);
      Buffer.Height := RectHeight(R2);
      R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
      Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
      StretchDraw(R1, Buffer);
      Buffer.Free;
    end;
    // bottom
    if not ABottomStretch
    then
      begin
        w := RBPt.X - LBPt.X;
        XCnt := (NewRBPt.X - NewLBPt.X) div (RBPt.X - LBPt.X);
        for X := 0 to XCnt do
        begin
          if NewLBPt.X + X * w + w > NewRBPt.X
          then XO := NewLBPt.X + X * w + w - NewRBPt.X else XO := 0;
            CopyRect(Rect(NewLBPt.X + X * w, NewClRect.Bottom, NewLBPt.X + X * w + w - XO, AH),
                 SB.Canvas, Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom,
                 R.Left + RBPt.X - XO, R.Bottom));
        end;
      end
    else
      begin
        R1 := Rect(NewLBPt.X, NewClRect.Bottom, NewRBPt.X, AH);
        R2 := Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom, R.Left + RBPt.X, R.Bottom);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;
    // left
    if not ALeftStretch
    then
      begin
        w := NewClRect.Left;
        h := LBPt.Y - LTPt.Y;
        YCnt := (NewLBPt.Y - NewLTPt.Y) div h;
        for Y := 0 to YCnt do
        begin
          if NewLTPt.Y + Y * h + h > NewLBPt.Y
          then YO := NewLTPt.Y + Y * h + h - NewLBPt.Y else YO := 0;
            CopyRect(Rect(0, NewLTPt.Y + Y * h, w, NewLTPt.Y + Y * h + h - YO),
              SB.Canvas,
              Rect(R.Left, R.Top + LTPt.Y, R.Left + w, R.Top + LBPt.Y - YO));
        end
      end
    else
      begin
        R1 := Rect(0, NewLTPt.Y, NewClRect.Left, NewLBPt.Y);
        R2 := Rect(R.Left, R.Top + LtPt.Y, R.Left + ClRect.Left, R.Top + LBPt.Y);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;
    // right
    if not ARightStretch
    then
      begin
        h := RBPt.Y - RTPt.Y;
        YCnt := (NewRBPt.Y - NewRTPt.Y) div h;
        for Y := 0 to YCnt do
        begin
         if NewRTPt.Y + Y * h + h > NewRBPt.Y
         then YO := NewRTPt.Y + Y * h + h - NewRBPt.Y else YO := 0;
          CopyRect(Rect(NewClRect.Right, NewRTPt.Y + Y * h,
                   AW, NewRTPt.Y + Y * h + h - YO),
               SB.Canvas,
               Rect(R.Left + ClRect.Right, R.Top + RTPt.Y,
                 R.Right, R.Top + RBPt.Y - YO));
       end
    end
    else
      begin
        R1 := Rect(NewClRect.Right, NewRTPt.Y, AW, NewRBPt.Y);
        R2 := Rect(R.Left + ClRect.Right, R.Top + RtPt.Y, R.Right, R.Top + RBPt.Y);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;

    // Draw corners
    // lefttop

    CopyRect(Rect(0, 0, NewLTPt.X, NewClRect.Top),
             SB.Canvas, Rect(R.Left, R.Top,
                             R.Left + LTPt.X, R.Top + ClRect.Top));

    CopyRect(Rect(0, NewClRect.Top, NewClRect.Left, NewLTPt.Y),
             SB.Canvas, Rect(R.Left, R.Top + ClRect.Top,
                             R.Left + ClRect.left, R.Top + LTPT.Y));

    //topright

    CopyRect(Rect(NewRTPt.X, 0, AW, NewClRect.Top), SB.Canvas,
             Rect(R.Left + RTPt.X, R.Top,  R.Right, R.Top + ClRect.Top));
    CopyRect(Rect(NewClRect.Right, NewClRect.Top, AW, NewRTPt.Y), SB.Canvas,
             Rect(R.Left + ClRect.Right, R.Top + ClRect.Top,
             R.Right, R.Top + RTPt.Y));

    //leftbottom

    CopyRect(Rect(0, NewLBPt.Y, NewClRect.Left, AH), SB.Canvas,
             Rect(R.Left, R.Top + LBPt.Y, R.Left + ClRect.Left, R.Bottom));

    CopyRect(Rect(NewClRect.Left, NewClRect.Bottom, NewLBPt.X, AH), SB.Canvas,
             Rect(R.Left + ClRect.Left, R.Top + ClRect.Bottom, R.Left + LBPt.X, R.Bottom));


    //rightbottom

    CopyRect(Rect(NewRBPt.X, NewClRect.Bottom, AW, AH), SB.Canvas,
             Rect(R.Left + RBPt.X, R.Top + ClRect.Bottom, R.Right, R.Bottom));

    CopyRect(Rect(NewClRect.Right, NewRBPt.Y, AW, NewClRect.Bottom), SB.Canvas,
             Rect(R.Left + ClRect.Right, R.Top + RBPt.Y,
                  R.Right, R.Top + ClRect.Bottom));

    //Draw client
    if ADrawClient
    then
    if AClientStretch
    then
      begin
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(ClRect);
        Buffer.Height := RectHeight(ClRect);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
        SB.Canvas, Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
          R.Left + ClRect.Right, R.Top + ClRect.Bottom));
        if (RectWidth(NewClRect) > 0) and (RectHeight(NewClRect) > 0) then
        case AStretchType of
         spstFull:
           StretchDraw(NewClRect, Buffer);
         spstHorz:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NewClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := Buffer.Width;
             Buffer2.Height := RectHeight(NewClRect);
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             XCnt := RectWidth(NewClRect) div Buffer2.Width;
             for X := 0 to XCnt do
               B.Canvas.Draw(NewClRect.Left + X * Buffer2.Width, NewClRect.Top, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
         spstVert:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NewClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := RectWidth(NewClRect);
             Buffer2.Height := Buffer.Height;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             YCnt := RectHeight(NewClRect) div Buffer2.Height;
             for Y := 0 to YCnt do
               B.Canvas.Draw(NewClRect.Left, NewClRect.Top + Y * Buffer2.Height, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
        end;

        Buffer.Free;
      end
    else
      begin
        w := RectWidth(ClRect);
        h := RectHeight(ClRect);
        rw := RectWidth(NewClRect);
        rh := RectHeight(NewClRect);
        // Draw client area
        XCnt := rw div w;
        YCnt := rh div h;
        for X := 0 to XCnt do
        for Y := 0 to YCnt do
        begin
          if X * w + w > rw then XO := X * W + W - rw else XO := 0;
          if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
          CopyRect(Rect(NewClRect.Left + X * w, NewClRect.Top + Y * h,
          NewClRect.Left + X * w + w - XO,
          NewClRect.Top + Y * h + h - YO),
          SB.Canvas,
          Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
          R.Left + ClRect.Right - XO,
          R.Top + ClRect.Bottom - YO));
        end;
      end;
  end;
end;

procedure CreateSkinImage2;
var
  w, h, rw, rh: Integer;
  X, Y, XCnt, YCnt: Integer;
  XO, YO: Integer;
  NCLRect: TRect;
  R1, R2, R3: TRect;
  Buffer, Buffer2: TBitMap;
  SaveIndex: Integer;
begin
  B.Width := AW;
  B.Height := AH;
  if (RBPt.X - LTPt.X  = 0) or
     (RBPt.Y - LTPt.Y = 0) or SB.Empty then  Exit;
  with B.Canvas do
  begin
    // Draw lines
    // top
    if not ATopStretch
    then
      begin
        w := RBPt.X - LTPt.X;
        XCnt := (AW - NewLTPt.X) div (RBPt.X - LTPt.X);
        for X := 0 to XCnt do
        begin
          if NewLTPt.X + X * w + w > AW
          then XO := NewLTPt.X + X * w + w - AW else XO := 0;
          CopyRect(Rect(NewLTPt.X + X * w, 0, NewLTPt.X + X * w + w - XO, NewClRect.Top),
               SB.Canvas, Rect(R.Left + LTPt.X, R.Top,
                 R.Left + RTPt.X - XO, R.Top + ClRect.Top));
        end;
    end
    else
      begin
        R1 := Rect(NewLTPt.X, 0, AW, NewClRect.Top);
        R2 := Rect(R.Left + LTPt.X, R.Top, R.Left + RTPt.X, R.Top + ClRect.Top);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;
    // bottom
    if not ABottomStretch
    then
      begin
        w := RBPt.X - LBPt.X;
        XCnt := (AW - NewLBPt.X) div (RBPt.X - LBPt.X);
        for X := 0 to XCnt do
        begin
          if NewLBPt.X + X * w + w > AW
          then XO := NewLBPt.X + X * w + w - AW else XO := 0;
          CopyRect(Rect(NewLBPt.X + X * w, NewClRect.Bottom, NewLBPt.X + X * w + w - XO, AH),
                   SB.Canvas, Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom,
                   R.Left + RBPt.X - XO, R.Bottom));
        end
    end
    else
      begin
        R1 := Rect(NewLBPt.X, NewClRect.Bottom, AW, AH);
        R2 := Rect(R.Left + LBPt.X, R.Top + ClRect.Bottom, R.Left + RBPt.X, R.Bottom);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;
    // left
    if not ALeftStretch
    then
      begin
        w := NewClRect.Left;
        h := LBPt.Y - LTPt.Y;
        YCnt := (NewLBPt.Y - NewLTPt.Y) div h;
        for Y := 0 to YCnt do
        begin
          if NewLTPt.Y + Y * h + h > NewLBPt.Y
          then YO := NewLTPt.Y + Y * h + h - NewLBPt.Y else YO := 0;
          CopyRect(Rect(0, NewLTPt.Y + Y * h, w, NewLTPt.Y + Y * h + h - YO),
               SB.Canvas,
               Rect(R.Left, R.Top + LTPt.Y, R.Left + w, R.Top + LBPt.Y - YO));
        end;
    end
    else
      begin
        R1 := Rect(0, NewLTPt.Y, NewClRect.Left, NewLBPt.Y);
        R2 := Rect(R.Left, R.Top + LtPt.Y, R.Left + ClRect.Left, R.Top + LBPt.Y);
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(R2);
        Buffer.Height := RectHeight(R2);
        R3 := Rect(0, 0, Buffer.Width, Buffer.Height);
        Buffer.Canvas.CopyRect(R3, SB.Canvas, R2);
        StretchDraw(R1, Buffer);
        Buffer.Free;
      end;

    // lefttop

    CopyRect(Rect(0, 0, NewLTPt.X, NewClRect.Top),
             SB.Canvas, Rect(R.Left, R.Top,
                             R.Left + LTPt.X, R.Top + ClRect.Top));

    CopyRect(Rect(0, NewClRect.Top, NewClRect.Left, NewLTPt.Y),
             SB.Canvas, Rect(R.Left, R.Top + ClRect.Top,
                             R.Left + ClRect.left, R.Top + LTPT.Y));

    //leftbottom

    CopyRect(Rect(0, NewLBPt.Y, NewClRect.Left, AH), SB.Canvas,
             Rect(R.Left, R.Top + LBPt.Y, R.Left + ClRect.Left, R.Bottom));

    CopyRect(Rect(NewClRect.Left, NewClRect.Bottom, NewLBPt.X, AH), SB.Canvas,
             Rect(R.Left + ClRect.Left, R.Top + ClRect.Bottom, R.Left + LBPt.X, R.Bottom));

    //Draw client
     if ADrawClient
    then
    if  AClientStretch
    then
      begin
        NCLRect := NewClRect;
        NCLRect.Right := AW;
        Buffer := TBitMap.Create;
        Buffer.Width := RectWidth(ClRect);
        Buffer.Height := RectHeight(ClRect);
        Buffer.Canvas.CopyRect(Rect(0, 0, Buffer.Width, Buffer.Height),
        SB.Canvas, Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
          R.Left + ClRect.Right, R.Top + ClRect.Bottom));
        if (RectWidth(NClRect) > 0) and (RectHeight(NClRect) > 0) then
        case AStretchType of
         spstFull:
           StretchDraw(NClRect, Buffer);
         spstHorz:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NClRect.Left, NClRect.Top, NClRect.Right, NClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := Buffer.Width;
             Buffer2.Height := RectHeight(NClRect);
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             XCnt := RectWidth(NClRect) div Buffer2.Width;
             for X := 0 to XCnt do
               B.Canvas.Draw(NClRect.Left + X * Buffer2.Width, NClRect.Top, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
         spstVert:
           begin
             SaveIndex := SaveDC(B.Canvas.Handle);
             IntersectClipRect(B.Canvas.Handle,
               NewCLRect.Left, NewCLRect.Top, NewCLRect.Right, NClRect.Bottom);
             //
             Buffer2 := TBitMap.Create;
             Buffer2.Width := RectWidth(NClRect);
             Buffer2.Height := Buffer.Height;
             Buffer2.Canvas.StretchDraw(Rect(0, 0, Buffer2.Width, Buffer2.Height), Buffer);
             YCnt := RectHeight(NClRect) div Buffer2.Height;
             for Y := 0 to YCnt do
               B.Canvas.Draw(NClRect.Left, NClRect.Top + Y * Buffer2.Height, Buffer2);
             Buffer2.Free;
             //
             RestoreDC(B.Canvas.Handle, SaveIndex);
           end;
        end;

          
        Buffer.Free;
      end
    else
      begin
        NCLRect := NewClRect;
        NCLRect.Right := AW;
        w := RectWidth(ClRect);
        h := RectHeight(ClRect);
        rw := RectWidth(NCLRect);
        rh := RectHeight(NCLRect);
        // Draw client area
        XCnt := rw div w;
        YCnt := rh div h;
        for X := 0 to XCnt do
        for Y := 0 to YCnt do
        begin
          if X * w + w > rw then XO := X * W + W - rw else XO := 0;
          if Y * h + h > rh then YO := Y * h + h - rh else YO := 0;
          CopyRect(Rect(NCLRect.Left + X * w, NCLRect.Top + Y * h,
             NCLRect.Left + X * w + w - XO,
             NCLRect.Top + Y * h + h - YO),
             SB.Canvas,
             Rect(R.Left + ClRect.Left, R.Top + ClRect.Top,
             R.Left + ClRect.Right - XO,
             R.Top + ClRect.Bottom - YO));
         end;
      end;
  end;
end;

procedure CreateSkinMask;
var
  i, j, k: Integer;
  LWidth, TWidth, RWidth, BWidth: Integer;
  Ofs: Integer;
  W, H: Integer;
begin
  LWidth := ClRect.Left;
  TWidth := ClRect.Top;
  RWidth := FMask.Width - ClRect.Right;
  BWidth := FMask.Height - ClRect.Bottom;
  //left
  W := LWidth;
  H := RectHeight(NewClRect);
  if (W > 0) and (H > 0) then
  begin
  RMLeft.Width := W;
  RMLeft.Height := H;
  j := LBPt.Y - LTPt.Y;
  with RMLeft.Canvas do
  begin
    if j <> 0
    then
    for i := 0 to RMLeft.Height div j do
    begin
      if i * j + j > RMLeft.Height
      then Ofs := i * j + j - RMLeft.Height else Ofs := 0;
      CopyRect(Rect(0, i * j, LWidth, i * j + j - Ofs),
               FMask.Canvas,
               Rect(0, LTPt.Y, LWidth, LBPt.Y - Ofs));
    end;

    k := LTPt.Y - ClRect.Top;
    if k > 0 then
      CopyRect(Rect(0, 0, LWidth, k),
               FMask.Canvas,
               Rect(0, ClRect.Top, LWidth, LTPt.Y));

    k := ClRect.Bottom - LBPt.Y;
    if k > 0 then
      CopyRect(Rect(0, RMLeft.Height - k, LWidth, RMLeft.Height),
               FMask.Canvas,
               Rect(0, LBPt.Y, LWidth, ClRect.Bottom));
  end;
  end;
  //right
  W := RWidth;
  H := RectHeight(NewClRect);
  if (W > 0) and (H > 0) then
  begin
  RMRight.Width  := W;
  RMRight.Height := H;
  j := RBPt.Y - RTPt.Y;

  with RMRight.Canvas do
  begin
    if j <> 0 then 
    for i := 0 to RMRight.Height div j do
    begin
      if i * j + j > RMRight.Height
      then Ofs := i * j + j - RMRight.Height else Ofs := 0;
      CopyRect(Rect(0, i * j, RWidth, i * j + j - Ofs),
               FMask.Canvas,
               Rect(ClRect.Right, RTPt.Y, FMask.Width, RBPt.Y - Ofs));
    end;           

    k := RTPt.Y - ClRect.Top;
    if k > 0 then
      CopyRect(Rect(0, 0, RWidth, k),
               FMask.Canvas,
               Rect(FMask.Width - RWidth, ClRect.Top, FMask.Width, RTPt.Y));

    k := ClRect.Bottom - RBPt.Y;
    if k > 0 then
      CopyRect(Rect(0, RMRight.Height - k, RWidth, RMRight.Height),
               FMask.Canvas,
               Rect(FMask.Width - RWidth, RBPt.Y, FMask.Width, CLRect.Bottom));
  end;
  end;
  // top
  H := TWidth;
  W := AW;
  if (W > 0) and (H > 0) then
  begin
  j := RTPt.X - LTPt.X;
  RMTop.Height := H;
  RMTop.Width := W;

  with RMTop.Canvas do
  begin
    if j <> 0 then
    for i := 0 to RMTop.Width div j do
    begin
      if NewLTPt.X + i * j + j > NewRTPt.X
      then Ofs := NewLTPt.X + i * j + j - NewRTPt.X else Ofs := 0;
      CopyRect(Rect(NewLTPt.X + i * j, 0, NewLTPt.X + i * j + j - Ofs, TWidth),
               FMask.Canvas,
               Rect(LTPt.X, 0, RTPt.X - Ofs, TWidth));
    end;
    CopyRect(Rect(0, 0, LTPt.X, TWidth), FMask.Canvas,
             Rect(0, 0, LTPt.X, TWidth));
    CopyRect(Rect(NewRTPt.X, 0, RMTop.Width, TWidth), FMask.Canvas,
             Rect(RTPt.X, 0, FMask.Width, TWidth));
  end;
  end;
  // bottom
  W := AW;
  H := BWidth;
  if (W > 0) and (H > 0) then
  begin
  j := RBPt.X - LBPt.X;
  RMBottom.Height := H;
  RMBottom.Width := W;

  with RMBottom.Canvas do
  begin
    if j <> 0 then
    for i := 0 to RMBottom.Width div j do
    begin
      if NewLBPt.X + i * j + j > NewRBPt.X
      then Ofs := NewLBPt.X + i * j + j - NewRBPt.X else Ofs := 0;
      CopyRect(Rect(NewLBPt.X + i * j, 0, NewLBPt.X + i * j + j - Ofs, BWidth),
               FMask.Canvas,
               Rect(LBPt.X, ClRect.Bottom, RBPt.X - Ofs, FMask.Height));
    end;
    CopyRect(Rect(0, 0, LBPt.X, BWidth), FMask.Canvas,
             Rect(0, ClRect.Bottom, LBPt.X, FMask.Height));
    CopyRect(Rect(NewRBPt.X, 0, RMBottom.Width, BWidth), FMask.Canvas,
             Rect(RBPt.X, ClRect.Bottom, FMask.Width, FMask.Height));
  end;
  end;
end;

procedure CreateSkinSimplyRegion(var FRgn: HRgn; FMask: TBitMap);
var
  Size: Integer;
  RgnData: PRgnData;
begin
  Size := CreateRgnFromBmp(FMask, 0, 0, RgnData);
  FRgn := ExtCreateRegion(nil, Size, RgnData^);
  FreeMem(RgnData, Size);
end;

procedure CreateSkinRegion;
var
  RMTop, RMBottom, RMLeft, RMRight: TBitMap;
  Size: Integer;
  RgnData: PRgnData;
  R1, R2, R3, R4: HRGN;
begin
  if (NewLtPt.X > NewRTPt.X) or (NewLtPt.Y > NewLBPt.Y)
  then
    begin
      FRgn := 0;
      Exit;
    end;
  RMTop := TBitMap.Create;
  RMBottom := TBitMap.Create;
  RMLeft := TBitMap.Create;
  RMRight := TBitMap.Create;
  //
  CreateSkinMask(LTPt, RTPt, LBPt, RBPt, ClRect,
               NewLtPt, NewRTPt, NewLBPt, NewRBPt, NewClRect,
               FMask, RMTop, RMLeft, RMRight, RMBottom,
               AW, AH);
  //
  if (RMTop.Width > 0) and (RMTop.Height > 0) 
  then
    begin
      Size := CreateRgnFromBmp(RMTop, 0, 0, RgnData);
      R1 := ExtCreateRegion(nil, Size, RgnData^);
      FreeMem(RgnData, Size);
    end
  else
    R1 := 0;

  if (RMBottom.Width > 0) and (RMBottom.Height > 0)
  then
    begin
      Size := CreateRgnFromBmp(RMBottom, 0, NewClRect.Bottom, RgnData);
      R2 := ExtCreateRegion(nil, Size, RgnData^);
      FreeMem(RgnData, Size);
    end
  else
    R2 := 0;

  if (RMLeft.Width > 0) and (RMleft.Height > 0)
  then
    begin
      Size := CreateRgnFromBmp(RMLeft, 0, NewClRect.Top, RgnData);
      R3 := ExtCreateRegion(nil, Size, RgnData^);
      FreeMem(RgnData, Size);
    end
  else
    R3 := 0;

  if (RMRight.Width > 0) and (RMRight.Height > 0)
  then
    begin
      Size := CreateRgnFromBmp(RMRight, NewClRect.Right, NewClRect.Top, RgnData);
      R4 := ExtCreateRegion(nil, Size, RgnData^);
      FreeMem(RgnData, Size);
    end
  else
    R4 := 0;  

  if not isNullRect(NewClRect)
  then
    FRgn := CreateRectRgn(NewClRect.Left, NewClRect.Top,
                          NewClRect.Right, NewClRect.Bottom)
  else
    FRgn := 0;

  CombineRgn(R1, R1, R2, RGN_OR);
  CombineRgn(R3, R3, R4, RGN_OR);
  CombineRgn(R3, R3, R1, RGN_OR);

  CombineRgn(FRgn, FRgn, R3, RGN_OR);

  DeleteObject(R1);
  DeleteObject(R2);
  DeleteObject(R3);
  DeleteObject(R4);
  //
  RMTop.Free;
  RMBottom.Free;
  RMLeft.Free;
  RMRight.Free;
end;

procedure DrawGlyph;
var
  B: TBitMap;
  gw, gh: Integer;
  GR: TRect;
begin
  if FGlyph.Empty then Exit;
  gw := FGlyph.Width div FNumGlyphs;
  gh := FGlyph.Height;
  B := TBitMap.Create;
  B.Width := gw;
  B.Height := gh;
  GR := Rect(gw * (FGlyphNum - 1), 0, gw * FGlyphNum, gh);
  B.Canvas.CopyRect(Rect(0, 0, gw, gh), FGlyph.Canvas, GR);
  B.Transparent := True;
  Cnvs.Draw(X, Y, B);
  B.Free;
end;

procedure CreateSkinBorderImages;
var
  XCnt, YCnt, i, X, Y, XO, YO, w, h: Integer;
  TB: TBitMap;
  TR, TR1: TRect;
begin
  // top
  w := AW;
  h := NewClRect.Top;
  if (w > 0) and (h > 0) and (RTPt.X - LTPt.X > 0)
  then
    begin
      TopB.Width := w;
      TopB.Height := h;
      w := RTPt.X - LTPt.X;
      XCnt := TopB.Width div w;
      if TS
      then
        begin
          TB := TBitMap.Create;
          TR := Rect(R.Left + LTPt.X, R.Top,
                     R.Left + RTPt.X, R.Top + h);
          TR1 := Rect(NewLTPt.X, 0, NewRTPt.X, h);
          TB.Width := RectWidth(TR);
          TB.Height := RectHeight(TR);
          TB.Canvas.CopyRect(Rect(0, 0, TB.Width, TB.Height),
          SB.Canvas, TR);
          TopB.Canvas.StretchDraw(TR1, TB);
          TB.Free;
        end
      else
        for X := 0 to XCnt do
        begin
          if X * w + w > TopB.Width
          then XO := X * w + w -  TopB.Width else XO := 0;
          with TopB.Canvas do
          begin
            CopyRect(Rect(X * w, 0, X * w + w - XO, h),
                     SB.Canvas,
                     Rect(R.Left + LTPt.X, R.Top,
                     R.Left + RTPt.X - XO, R.Top + h));
          end;
        end;
      with TopB.Canvas do
      begin
        CopyRect(Rect(0, 0, NewLTPt.X, h), SB.Canvas,
                 Rect(R.Left, R.Top, R.Left + LTPt.X, R.Top + h));
        CopyRect(Rect(NewRTPt.X, 0, TopB.Width, h), SB.Canvas,
                 Rect(R.Left + RTPt.X, R.Top, R.Right, R.Top + h));
      end;
    end;

  // bottom
  w := AW;
  h := AH - NewClRect.Bottom;
  if (w > 0) and (h > 0) and (RBPt.X - LBPt.X > 0)
  then
    begin
      BottomB.Width := w;
      BottomB.Height := h;
      w := RBPt.X - LBPt.X;
      XCnt := BottomB.Width div w;
      if BS
      then
        begin
          TB := TBitMap.Create;
          TR := Rect(R.Left + LBPt.X, R.Bottom - h,
                          R.Left + RBPt.X, R.Bottom);
          TR1 := Rect(NewLBPt.X, 0, NewRBPt.X, h);
          TB.Width := RectWidth(TR);
          TB.Height := RectHeight(TR);
          TB.Canvas.CopyRect(Rect(0, 0, TB.Width, TB.Height),
          SB.Canvas, TR);
          BottomB.Canvas.StretchDraw(TR1, TB);
          TB.Free;
        end
      else
      for X := 0 to XCnt do
      begin
        if X * w + w > BottomB.Width
        then XO := X * w + w -  BottomB.Width else XO := 0;
          with BottomB.Canvas do
          begin
            CopyRect(Rect(X * w, 0, X * w + w - XO, h),
                     SB.Canvas,
                     Rect(R.Left + LBPt.X, R.Bottom - h,
                          R.Left + RBPt.X - XO, R.Bottom));
          end;
      end;
      with BottomB.Canvas do
      begin
        CopyRect(Rect(0, 0, NewLBPt.X, h), SB.Canvas,
                 Rect(R.Left, R.Bottom - h, R.Left + LBPt.X, R.Bottom));
        CopyRect(Rect(NewRBPt.X, 0, BottomB.Width, h), SB.Canvas,
                 Rect(R.Left + RBPt.X, R.Bottom - h, R.Right, R.Bottom));
      end;
    end;
  // draw left
  h := AH - BottomB.Height - TopB.Height;
  w := NewClRect.Left;
  if (w > 0) and (h > 0) and (LBPt.Y - LTPt.Y > 0)
  then
    begin
      LeftB.Width := w;
      LeftB.Height := h;
      h := LBPt.Y - LTPt.Y;
      YCnt := LeftB.Height div h;
      if LS
      then
        begin
          TB := TBitMap.Create;
          TR := Rect(R.Left, R.Top + LTPt.Y,
                     R.Left + w, R.Top + LBPt.Y);
          TR1 := Rect(0, LTPt.Y - ClRect.Top, w,
                      LeftB.Height - (ClRect.Bottom - LBPt.Y));
          TB.Width := RectWidth(TR);
          TB.Height := RectHeight(TR);
          TB.Canvas.CopyRect(Rect(0, 0, TB.Width, TB.Height),
          SB.Canvas, TR);
          LeftB.Canvas.StretchDraw(TR1, TB);
          TB.Free;
        end
      else
      for Y := 0 to YCnt do
      begin
        if Y * h + h > LeftB.Height
        then YO := Y * h + h - LeftB.Height else YO := 0;
        with LeftB.Canvas do
          CopyRect(Rect(0, Y * h, w, Y * h + h - YO),
                   SB.Canvas,
                   Rect(R.Left, R.Top + LTPt.Y, R.Left + w, R.Top + LBPt.Y - YO));
      end;
      with LeftB.Canvas do
      begin
        YO := LTPt.Y - ClRect.Top;
        if YO > 0
        then
          CopyRect(Rect(0, 0, w, YO), SB.Canvas,
                   Rect(R.Left, R.Top + ClRect.Top,
                   R.Left + w, R.Top + LTPt.Y));
        YO :=  ClRect.Bottom - LBPt.Y;
        if YO > 0
        then
          CopyRect(Rect(0, LeftB.Height - YO, w, LeftB.Height),
                   SB.Canvas,
                   Rect(R.Left, R.Top + LBPt.Y,
                   R.Left + w, R.Top + ClRect.Bottom));
      end;
    end;
   // draw right
  h := AH - BottomB.Height - TopB.Height;
  w := AW - NewClRect.Right;
  if (w > 0) and (h > 0) and (RBPt.Y - RTPt.Y > 0)
  then
    begin
      RightB.Width := w;
      RightB.Height := h;
      h := RBPt.Y - RTPt.Y;
      YCnt := RightB.Height div h;
      if RS
      then
        begin
          TB := TBitMap.Create;
          TR := Rect(R.Left + ClRect.Right, R.Top + RTPt.Y,
                                R.Right, R.Top + RBPt.Y);
          TR1 := Rect(0, RTPt.Y - ClRect.Top, w,
                      RightB.Height - (ClRect.Bottom - RBPt.Y));
          TB.Width := RectWidth(TR);
          TB.Height := RectHeight(TR);
          TB.Canvas.CopyRect(Rect(0, 0, TB.Width, TB.Height),
          SB.Canvas, TR);
          RightB.Canvas.StretchDraw(TR1, TB);
          TB.Free;
        end
      else
      for Y := 0 to YCnt do
      begin
        if Y * h + h > RightB.Height
        then YO := Y * h + h - RightB.Height else YO := 0;
        with RightB.Canvas do
        CopyRect(Rect(0, Y * h, w, Y * h + h - YO),
                 SB.Canvas,
                 Rect(R.Left + ClRect.Right, R.Top + RTPt.Y,
                      R.Right, R.Top + RBPt.Y - YO));
      end;
      with RightB.Canvas do
      begin
        YO := RTPt.Y - ClRect.Top;
        if YO > 0
        then
          CopyRect(Rect(0, 0, w, YO), SB.Canvas,
                   Rect(R.Left + ClRect.Right, R.Top + ClRect.Top,
                   R.Right, R.Top + RTPt.Y));
                  
        YO :=  ClRect.Bottom - RBPt.Y;
        if YO > 0
        then
          CopyRect(Rect(0, RightB.Height - YO, w, RightB.Height),
                   SB.Canvas,
                   Rect(R.Left + ClRect.Right, R.Top + RBPt.Y,
                        R.Right, R.Top + ClRect.Bottom));
      end;
    end;
end;

procedure DrawRCloseImage(C: TCanvas; R: TRect; Color: TColor);
var
  X, Y: Integer;
begin
  X := R.Left + RectWidth(R) div 2 - 5;
  Y := R.Top + RectHeight(R) div 2 - 5;
  DrawCloseImage(C, X, Y, Color);
end;


procedure DrawCloseImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Pen.Color := Color;
    MoveTo(X + 1, Y + 1); LineTo(X + 9, Y + 9);
    MoveTo(X + 9, Y + 1); LineTo(X + 1, Y + 9);
    MoveTo(X + 2, Y + 1); LineTo(X + 10, Y + 9);
    MoveTo(X + 8, Y + 1); LineTo(X, Y + 9);
  end;
end;

procedure DrawSysMenuImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin                
    Pen.Color := Color;
    Brush.Style := bsClear;
    Rectangle(X + 1, Y + 3, X + 9, Y + 6);
  end;
end;

procedure DrawMinimizeImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Pen.Color := Color;
    MoveTo(X + 1, Y + 8); LineTo(X + 9, Y + 8);
    MoveTo(X + 1, Y + 9); LineTo(X + 9, Y + 9);
  end;
end;

procedure DrawMaximizeImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Brush.Style := bsClear;
    Pen.Color := Color;
    Rectangle(X, Y, X + 11, Y + 10);
    Rectangle(X, Y, X + 11, Y + 2);
  end;
end;

procedure DrawRestoreImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Brush.Style := bsClear;
    Pen.Color := Color;
    Rectangle(X + 2, Y, X + 10, Y + 6);
    Rectangle(X + 2, Y, X + 10, Y + 2);
    Rectangle(X, Y + 4, X + 7, Y + 10);
    Rectangle(X, Y + 4, X + 7, Y + 6);
  end;
end;

procedure DrawRestoreRollUpImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Pen.Color := Color;
    MoveTo(X + 5, Y + 6); LineTo(X + 5, Y + 6);
    MoveTo(X + 4, Y + 5); LineTo(X + 6, Y + 5);
    MoveTo(X + 3, Y + 4); LineTo(X + 7, Y + 4);
    MoveTo(X + 2, Y + 3); LineTo(X + 8, Y + 3);
    MoveTo(X + 1, Y + 2); LineTo(X + 9, Y + 2);
  end;
end;


procedure DrawRollUpImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Pen.Color := Color;
    MoveTo(X + 5, Y + 2); LineTo(X + 5, Y + 2);
    MoveTo(X + 4, Y + 3); LineTo(X + 6, Y + 3);
    MoveTo(X + 3, Y + 4); LineTo(X + 7, Y + 4);
    MoveTo(X + 2, Y + 5); LineTo(X + 8, Y + 5);
    MoveTo(X + 1, Y + 6); LineTo(X + 9, Y + 6);
  end;
end;

procedure DrawMTImage(C: TCanvas; X, Y: Integer; Color: TColor);
begin
  with C do
  begin
    Pen.Color := Color;
    Brush.Color := Color;
    Rectangle(X + 2, Y + 2, X + 7, Y + 7);
  end;
end;

function ExtractDay(ADate: TDateTime): Word;
var
  M, Y: Word;
begin
  DecodeDate(ADate, Y, M, Result);
end;

function ExtractMonth(ADate: TDateTime): Word;
var
  D, Y: Word;
begin
  DecodeDate(ADate, Y, Result, D);
end;

function ExtractYear(ADate: TDateTime): Word;
var
  D, M: Word;
begin
  DecodeDate(ADate, Result, M, D);
end;

function IsLeapYear(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result); { leap-year Feb is special }
end;

type

  PMonitorInfo = ^TMonitorInfo;
  TMonitorInfo = record
    cbSize: DWORD;
    rcMonitor: TRect;
    rcWork: TRect;
    dwFlags: DWORD;
  end;

const
  MONITOR_DEFAULTTONEAREST = $2;
  SM_CMONITORS = 80;

var
  MonitorFromWindowFunc: function(hWnd: HWND; dwFlags: DWORD): THandle; stdcall;
  GetMonitorInfoFunc: function(hMonitor: THandle; lpMonitorInfo: PMonitorInfo): BOOL; stdcall;

function CheckMultiMonitors: Boolean;
var
  MonitorCount: Integer;
begin
  MonitorCount := GetSystemMetrics(SM_CMONITORS);
  Result := (MonitorCount > 1) and Assigned(GetMonitorInfoFunc);
end;

function GetPrimaryMonitorWorkArea(const WorkArea: Boolean): TRect;
begin
  if WorkArea
  then
    SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0)
  else
    Result := Rect(0, 0, Screen.Width, Screen.Height);
end;

function GetMonitorWorkArea(const W: HWND; const WorkArea: Boolean): TRect;
var
  MonitorInfo: TMonitorInfo;
  MH: THandle;
begin
  if CheckMultiMonitors
  then
    begin
      MH := MonitorFromWindowFunc(W, MONITOR_DEFAULTTONEAREST);
      MonitorInfo.cbSize := SizeOf(MonitorInfo);
      if GetMonitorInfoFunc(MH, @MonitorInfo)
      then
        begin
          if not WorkArea
          then
            Result := MonitorInfo.rcMonitor
          else
            Result := MonitorInfo.rcWork;
        end;
    end
  else
    Result := GetPrimaryMonitorWorkArea(WorkArea);
end;

procedure DrawImageAndTextGlow;

var
  gw, gh: Integer;
  tw, th: Integer;
  i, j, TX, TY, GX, GY: Integer;
  TR: TRect;
  B: TspBitmap;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
      end;
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;

  if gw <> 0
  then
    begin
      B := TspBitMap.Create;
      B.SetSize(IL.Width + FGlowSize * 2, IL.Height + FGlowSize * 2);
      MakeBlurBlank3(B, IL, ImageIndex, FGlowSize);
      Blur(B, FGlowSize);
      for i := 0 to B.Width - 1 do
        for j := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(FGlowColor) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
      B.AlphaBlend := true;
      B.Draw(Cnvs, GX - FGlowSize, GY - FGlowSize);
      B.Free;
    end;

  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawEffectText2(Cnvs, TR, Caption, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_WORDBREAK,
          0, FGlowColor, FGlowSize);
    end;
  if gw <> 0
  then
    begin
      IL.Draw(Cnvs, GX, GY, ImageIndex, AEnabled);
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + IL.Height - 2);
          LineTo(GX + IL.Width, GY + IL.Height - 2);
          MoveTo(GX, GY + IL.Height - 1);
          LineTo(GX + IL.Width, GY + IL.Height - 1);
          MoveTo(GX, GY + IL.Height);
          LineTo(GX + IL.Width, GY + IL.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom );
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;
end;

procedure DrawGlyphAndTextGlow;
var
  gw, gh: Integer;
  tw, th: Integer;
  i, j, TX, TY, GX, GY: Integer;
  TR: TRect;
  B: TspBitmap;
begin
  if Glyph.Empty
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := Glyph.Width div NumGlyphs;
      gh := Glyph.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
        Brush.Style := bsClear;
     end;
  end;

  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);

  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  
  if not Glyph.Empty
  then
    begin
      B := TspBitMap.Create;
      B.SetSize(Glyph.Width + FGlowSize * 2, Glyph.Height + FGlowSize * 2);
      MakeBlurBlank2(B, Glyph, FGlowSize);
      Blur(B, FGlowSize);
      for i := 0 to B.Width - 1 do
        for j := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(FGlowColor) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
      B.AlphaBlend := true;
      B.Draw(Cnvs, GX - FGlowSize, GY - FGlowSize);
      B.Free;
    end;

  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawEffectText2(Cnvs, TR, Caption, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_WORDBREAK,
          0, FGlowColor, FGlowSize);
    end;
      
  if not Glyph.Empty then DrawGlyph(Cnvs, GX, GY, Glyph, NumGlyphs, GlyphNum);

  if not Glyph.Empty
  then
    begin
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + Glyph.Height - 2);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 2);
          MoveTo(GX, GY + Glyph.Height - 1);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 1);
          MoveTo(GX, GY + Glyph.Height);
          LineTo(GX + Glyph.Width, GY + Glyph.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom);
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;

end;

//==============================================================================
procedure DrawImageAndTextGlow2;
var
  gw, gh: Integer;
  tw, th: Integer;
  i, j, TX, TY, GX, GY: Integer;
  TR: TRect;
  B: TspBitmap;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
      end;
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;

  if gw <> 0
  then
    begin
      B := TspBitMap.Create;
      B.SetSize(IL.Width + FGlowSize * 2, IL.Height + FGlowSize * 2);
      MakeBlurBlank3(B, IL, ImageIndex, FGlowSize);
      Blur(B, FGlowSize);
      for i := 0 to B.Width - 1 do
        for j := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(FGlowColor) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
      B.AlphaBlend := true;
      B.Draw(Cnvs, GX - FGlowSize, GY - FGlowSize);
      B.Free;
    end;

  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawEffectText2(Cnvs, TR, Caption, DT_EXPANDTABS or DT_VCENTER or DT_WORDBREAK,
          0, FGlowColor, FGlowSize);
    end;
  if gw <> 0
  then
    begin
      IL.Draw(Cnvs, GX, GY, ImageIndex, AEnabled);
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + IL.Height - 2);
          LineTo(GX + IL.Width, GY + IL.Height - 2);
          MoveTo(GX, GY + IL.Height - 1);
          LineTo(GX + IL.Width, GY + IL.Height - 1);
          MoveTo(GX, GY + IL.Height);
          LineTo(GX + IL.Width, GY + IL.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom );
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;
end;

procedure DrawGlyphAndTextGlow2;
var
  gw, gh: Integer;
  tw, th: Integer;
  i, j, TX, TY, GX, GY: Integer;
  TR: TRect;
  B: TspBitmap;
begin
  if Glyph.Empty
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := Glyph.Width div NumGlyphs;
      gh := Glyph.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
        Brush.Style := bsClear;
     end;
  end;

  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);

  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;

  if not Glyph.Empty
  then
    begin
      B := TspBitMap.Create;
      B.SetSize(Glyph.Width + FGlowSize * 2, Glyph.Height + FGlowSize * 2);
      MakeBlurBlank2(B, Glyph, FGlowSize);
      Blur(B, FGlowSize);
      for i := 0 to B.Width - 1 do
        for j := 0 to B.Height - 1 do
          begin
            PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(FGlowColor) and
            not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
          end;
      B.AlphaBlend := true;
      B.Draw(Cnvs, GX - FGlowSize, GY - FGlowSize);
      B.Free;
    end;


  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawEffectText2(Cnvs, TR, Caption, DT_EXPANDTABS or DT_VCENTER or DT_WORDBREAK,
          0, FGlowColor, FGlowSize);
    end;
      
  if not Glyph.Empty then DrawGlyph(Cnvs, GX, GY, Glyph, NumGlyphs, GlyphNum);

  if not Glyph.Empty
  then
    begin
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + Glyph.Height - 2);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 2);
          MoveTo(GX, GY + Glyph.Height - 1);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 1);
          MoveTo(GX, GY + Glyph.Height);
          LineTo(GX + Glyph.Width, GY + Glyph.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom);
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;

end;
//==============================================================================

procedure DrawImageAndText2(Cnvs: TCanvas; R: TRect; Margin, Spacing: Integer;
            Layout: TspButtonLayout;
            Caption: String; ImageIndex: Integer; IL: TCustomIMageList; ADown: Boolean;
            AEnabled: Boolean; ADrawColorMarker: Boolean; AColorMarkerValue: TColor);

var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if (ImageIndex < 0) or (IL = nil) or (ImageIndex >= IL.Count)
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := IL.Width;
      gh := IL.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
             DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
      end;
    Brush.Style := bsClear;
  end;
  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);
  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;
  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawText(Cnvs.Handle, PChar(Caption), Length(Caption), TR, DT_EXPANDTABS or DT_VCENTER or DT_WORDBREAK);
    end;
  if gw <> 0
  then
    begin
      IL.Draw(Cnvs, GX, GY, ImageIndex, AEnabled);
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + IL.Height - 2);
          LineTo(GX + IL.Width, GY + IL.Height - 2);
          MoveTo(GX, GY + IL.Height - 1);
          LineTo(GX + IL.Width, GY + IL.Height - 1);
          MoveTo(GX, GY + IL.Height);
          LineTo(GX + IL.Width, GY + IL.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom );
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;
end;


procedure DrawGlyphAndText2(Cnvs: TCanvas;
  R: TRect; Margin, Spacing: Integer; Layout: TspButtonLayout;
  Caption: String; Glyph: TBitMap; NumGlyphs, GlyphNum: Integer; ADown: Boolean;
  ADrawColorMarker: Boolean; AColorMarkerValue: TColor);
var
  gw, gh: Integer;
  tw, th: Integer;
  TX, TY, GX, GY: Integer;
  TR: TRect;
begin
  if Glyph.Empty
  then
    begin
      gw := 0;
      gh := 0;
    end
  else
    begin
      gw := Glyph.Width div NumGlyphs;
      gh := Glyph.Height;
    end;
  with Cnvs do
  begin
    if Caption = ''
    then
      begin
        tw := 0;
        th := 0;
      end
    else
      begin
        TR := Rect(0, 0, RectWidth(R), RectHeight(R));
        if (Layout = blGlyphLeft) or (Layout = blGlyphRight)
        then
          begin
            Dec(TR.Right, gw);
          end
        else
        if (Layout = blGlyphTop) or (Layout = blGlyphBottom)
        then
          begin
            Dec(TR.Bottom, gh);
          end;
        DrawText(Handle, PChar(Caption), Length(Caption), TR,
                 DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT);
        tw := RectWidth(TR);
        th := RectHeight(TR);
        Brush.Style := bsClear;
     end;
  end;

  CalcLCoord(Layout, R, gw, gh, tw, th, Spacing, Margin, TX, TY, GX, GY);

  if ADown
  then
    begin
      Inc(GX); Inc(GY);
      Inc(TX); Inc(TY);
    end;

  if Caption <> ''
  then
    begin
      TR := Rect(TX, TY, TX + tw, TY + th);
      if (Cnvs.Font.Height div 2) <> (Cnvs.Font.Height / 2) then Dec(TR.Top, 1);
      Inc(TR.Right, 2);
      DrawText(Cnvs.Handle, PChar(Caption),
        Length(Caption), TR, DT_EXPANDTABS or DT_VCENTER or DT_WORDBREAK);
    end;
      
  if not Glyph.Empty then DrawGlyph(Cnvs, GX, GY, Glyph, NumGlyphs, GlyphNum);

  if not Glyph.Empty
  then
    begin
      if ADrawColorMarker
      then
        with Cnvs do
        begin
          Pen.Color := AColorMarkerValue;
          MoveTo(GX, GY + Glyph.Height - 2);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 2);
          MoveTo(GX, GY + Glyph.Height - 1);
          LineTo(GX + Glyph.Width, GY + Glyph.Height - 1);
          MoveTo(GX, GY + Glyph.Height);
          LineTo(GX + Glyph.Width, GY + Glyph.Height);
        end;
    end
  else
    if ADrawColorMarker
    then
      with Cnvs do
      begin
        if Caption <> ''
        then
          begin
            Pen.Color := AColorMarkerValue;
            MoveTo(TR.Left, TR.Bottom  - 1);
            LineTo(TR.Right, TR.Bottom  - 1);
            MoveTo(TR.Left, TR.Bottom);
            LineTo(TR.Right, TR.Bottom);
            MoveTo(TR.Left, TR.Bottom  + 1);
            LineTo(TR.Right, TR.Bottom  + 1);
          end
        else
          begin
            Brush.Color := AColorMarkerValue;
            Brush.Style := bsSolid;
            if ADown
            then
              FillRect(Rect(R.Left + 4, R.Top + 5, R.Right - 2, R.Bottom - 3))
            else
              FillRect(Rect(R.Left + 4, R.Top + 4, R.Right - 2, R.Bottom - 4));
          end;
     end;

end;

  // layer manager

procedure TspLayerWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TRANSPARENT;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TspLayerWindow.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

constructor TspLayerManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LayerWindow := nil;
  Bmp := nil;
  TopMostMode := True;
  Timer := TTimer.Create(Self);
  Timer.Enabled := False;
  Timer.OnTimer := ExecTimer;
  Timer.Interval := 25;
end;

destructor TspLayerManager.Destroy;
begin
  Timer.Free;
  if LayerWindow <> nil then LayerWindow.Free;
  if Bmp <> nil then Bmp.Free;
  inherited;
end;

procedure TspLayerManager.Update;
begin
  if not IsVisible then Exit;

  if TopMostMode
  then
    SetWindowPos(LayerWindow.Handle, HWND_TOPMOST, LayerWindow.Left, LayerWindow.Top, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE)
  else
    SetWindowPos(LayerWindow.Handle, HWND_NOTOPMOST, LayerWindow.Left, LayerWindow.Top, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);
end;

procedure TspLayerManager.Show;
const
  ULW_ALPHA = $00000002;
  WS_EX_LAYERED = $80000;
var
  P, P2: TBitmap;
  TickCount, I: Integer;
begin
  if not CheckW2KWXP then Exit;
  if LayerWindow <> nil then Hide;
  IsVisible := True;
  LayerWindow := TspLayerWindow.Create(Self);
  LayerWindow.Visible := False;
  LayerWindow.SetBounds(X, Y, AImage.Width, AImage.Height);
  SetWindowLong(LayerWindow.Handle, GWL_EXSTYLE,
                GetWindowLong(LayerWindow.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  //
  if Bmp <> nil then Bmp.Free;
  Bmp := TspBitMap.Create;

  CreateAlphaLayer(AImage, AImageMask, Bmp);

  CreateAlphaLayered2(Bmp, 0, LayerWindow);

  if TopMostMode
  then
    SetWindowPos(LayerWindow.Handle, HWND_TOPMOST, X, Y, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE)
  else
    SetWindowPos(LayerWindow.Handle, HWND_NOTOPMOST, X, Y, 0, 0,
                 SWP_NOACTIVATE or SWP_SHOWWINDOW or SWP_NOSIZE);

  EndAlphaBlendValue := AAlphaBlendValue;
  StepAlphaBlendValue := EndAlphaBlendValue div 10;
  StartTimer;
end;

procedure TspLayerManager.StartTimer;
begin
  BeginAlphaBlendValue := 0;
  Timer.Enabled := True;
end;

procedure TspLayerManager.StopTimer;
begin
  Timer.Enabled := False;
end;

procedure TspLayerManager.ExecTimer(Sender: TObject);
begin
  if bmp = nil then Exit;
  if LayerWindow = nil then Exit;
  Inc(BeginAlphaBlendValue, StepAlphaBlendValue);
  if BeginAlphaBlendValue > EndAlphaBlendValue
  then
    BeginAlphaBlendValue := EndAlphaBlendValue;
  CreateAlphaLayered2(Bmp, BeginAlphaBlendValue, LayerWindow);
  if BeginAlphaBlendValue = EndAlphaBlendValue
  then
    StopTimer;
end;

procedure TspLayerManager.Hide;
begin
  if not CheckW2KWXP then Exit;
  StopTimer;  
  if Bmp <> nil then FreeAndNil(Bmp);
  IsVisible := False;
  if LayerWindow <> nil
  then
    begin
      SetWindowPos(LayerWindow.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
       SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      LayerWindow.Free;
      LayerWindow := nil;
    end;
end;


function Darker(Color:TColor; Percent:Byte):TColor;
var
  r, g, b: Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);
  g:=g-muldiv(g,Percent,100);
  b:=b-muldiv(b,Percent,100);
  result:=RGB(r,g,b);
end;


procedure CreateAlphaLayered(ABmp: TBitmap; AMaskBmp: TBitMap;
   AAlphaBlendValue: Integer;
   AControl: TWinControl);
const
  ULW_ALPHA = $00000002;
  WS_EX_LAYERED = $80000;
var
  i, j: Integer;
  Origin, Size, BitmapOrigin: Windows.TPoint;
  OldRgn, Rgn: Cardinal;
  Blend: TBLENDFUNCTION;
  DC: HDC;
  Bmp, MaskBmp: TspBitMap;
begin
  if AControl = nil then Exit;

  SetWindowLong(AControl.Handle, GWL_EXSTYLE,
                GetWindowLong(AControl.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  Bmp := TspBitmap.Create;
  Bmp.Assign(ABmp);
  MaskBmp := TspBitmap.Create;
  MaskBmp.Assign(AMaskBmp);
  CreateAlphaByMask(Bmp, MaskBmp);
  Bmp.CheckRGBA;
  //
  if @UpdateLayeredWindow <> nil
  then
    begin
      Origin := Point(AControl.Left, AControl.Top);
      BitmapOrigin := Point(0, 0);
      Size := Point(Bmp.Width, Bmp.Height);
      with Blend do
      begin
        BlendOp := AC_SRC_OVER;
        AlphaFormat := $01;
        BlendFlags := 0;
        SourceConstantAlpha := AAlphaBlendValue;
       end;
       UpdateLayeredWindow(AControl.Handle, 0, @Origin, @Size, Bmp.DC,
        @BitmapOrigin, $00000000, @Blend, ULW_ALPHA);
    end;
  Bmp.Free;
  Maskbmp.Free;
end;

procedure CreateAlphaLayer(ABmp: TBitmap; AMaskBmp: TBitMap;
                           AlphaBmp: TspBitmap);
var
  MaskBmp: TspBitmap;
begin
  AlphaBmp.Assign(ABmp);
  MaskBmp := TspBitmap.Create;
  MaskBmp.Assign(AMaskBmp);
  CreateAlphaByMask(AlphaBmp, MaskBmp);
  AlphaBmp.CheckRGBA;
  MaskBmp.Free;
end;

procedure CreateAlphaLayered2(AlphaBmp: TspBitmap; AAlphaBlendValue: Integer;
                              AControl: TWinControl);
const
  ULW_ALPHA = $00000002;
  WS_EX_LAYERED = $80000;
var
  Origin, Size, BitmapOrigin: Windows.TPoint;
  OldRgn, Rgn: Cardinal;
  Blend: TBLENDFUNCTION;
begin
  if AControl = nil then Exit;
  
  if @UpdateLayeredWindow <> nil
  then
    begin
      Origin := Point(AControl.Left, AControl.Top);
      BitmapOrigin := Point(0, 0);
      Size := Point(AlphaBmp.Width, AlphaBmp.Height);
      with Blend do
      begin
        BlendOp := AC_SRC_OVER;
        AlphaFormat := $01;
        BlendFlags := 0;
        SourceConstantAlpha := AAlphaBlendValue;
       end;
       UpdateLayeredWindow(AControl.Handle, 0, @Origin, @Size, AlphaBmp.DC,
        @BitmapOrigin, $00000000, @Blend, ULW_ALPHA);
    end;
end;


procedure MakeBlurBlank3(B :TspBitMap; IL: TCustomImageList; Index: Integer; BlurSize: Integer);
var
  X, Y: Integer;
  B1: TspBitMap;
  DstP: PspColor;
  C, C1: TspColor;
  SB: TBitMap;
begin
  if IL is TspPngImageList
  then
    begin
      MakeBlurBlank(B, TspPngImageList(IL).PngImages.Items[Index].PngImage, BlurSize);
      Exit;
    end
  else
    begin
      SB := TBitMap.Create;
      IL.GetBitmap(Index, SB);
      if SB.Empty
      then
        begin
          SB.Free;
          Exit;
        end;
    end;
  B1 := TspBitMap.Create;
  B1.Assign(SB);
  C1 := B1.Pixels[0, 0];
  for X := 0 to B1.Width - 1 do
   begin
     for Y := 0 to B1.Height - 1 do
     begin
       C := B1.Pixels[X, Y];
       DstP := B1.PixelPtr[X, Y];
       if C <> C1
       then
         DstP^ := bsColor($FF);
     end;
   end;
  B1.CheckingTransparent(B1.Pixels[0, 0]);
  B1.Draw(B.Canvas, BlurSize, BlurSize);
  B1.Draw(B.Canvas, BlurSize - 1, BlurSize - 1);
  B1.Draw(B.Canvas, BlurSize + 1, BlurSize + 1);
  SB.Free;
  B1.Free;
end;

procedure MakeBlurBlank2(B :TspBitMap; SB: TBitmap; BlurSize: Integer);
var
  X, Y: Integer;
  B1: TspBitMap;
  DstP: PspColor;
  DstP1: PspColor;
  C, C1: TspColor;
begin
  B1 := TspBitMap.Create;
  B1.Assign(SB);
  C1 := B1.Pixels[0, 0];
  for X := 0 to B1.Width - 1 do
   begin
     for Y := 0 to B1.Height - 1 do
     begin
       C := B1.Pixels[X, Y];
       DstP := B1.PixelPtr[X, Y];
       if C <> C1
       then
         DstP^ := bsColor($FF);
     end;
   end;
  B1.CheckingTransparent(B1.Pixels[0, 0]);
  B1.Draw(B.Canvas, BlurSize, BlurSize);
  B1.Draw(B.Canvas, BlurSize - 1, BlurSize - 1);
  B1.Draw(B.Canvas, BlurSize + 1, BlurSize + 1);
  B1.Free;
end;


procedure MakeBlurBlank(B :TspBitMap; P: TspPngImage; BlurSize: Integer);
var
  X, Y: Integer;
  {$IFNDEF VER200}
  Line: spPngImage.PByteArray;
  {$ELSE}
  Line: PByteArray;
  {$ENDIF}
  C: TspColor;
  DstP: PspColor;
begin
  for Y := 0 to P.Height - 1 do
   begin
     Line := P.AlphaScanline[Y];
     for X := 0 to P.Width - 1 do
     begin
       DstP := B.PixelPtr[X + BlurSize, Y + BlurSize];
       if Line^[X] <> 0
       then
          DstP^ := bsColor($FF, $FF);
     end;
   end;
  B.CheckingAlphaBlend;
end;

procedure MakeCopyFromPng(B :TspBitMap; P: TspPngImage);
var
  X, Y: Integer;
  {$IFNDEF VER200}
  Line: spPngImage.PByteArray;
  {$ELSE}
  Line: PByteArray;
  {$ENDIF}
  C: TspColor;
  DstP: PspColor;
begin
  B.SetSize(P.Width, P.Height);
  for Y := 0 to P.Height - 1 do
   begin
     Line := P.AlphaScanline[Y];
     for X := 0 to P.Width - 1 do
     begin
       DstP := B.PixelPtr[X, Y];
       DstP^ := bsColor(P.Pixels[X, Y], $FF);
       TspColorRec(DstP^).A := Line^[X];
     end;
   end;
  B.CheckingAlphaBlend;
end;

procedure MakeCopyFromPng2(B :TspBitMap; P: TspPngImage);
var
  X, Y: Integer;
  {$IFNDEF VER200}
  Line: spPngImage.PByteArray;
  {$ELSE}
  Line: PByteArray;
  {$ENDIF}
  C: TspColor;
  DstP: PspColor;
begin
  B.SetSize(P.Width, P.Height);
  for Y := 0 to P.Height - 1 do
   begin
     Line := P.AlphaScanline[Y];
     for X := 0 to P.Width - 1 do
     begin
       DstP := B.PixelPtr[X, Y];
       DstP^ := bsColor(P.Pixels[X, Y], $FF);
       TspColorRec(DstP^).A := Line^[X];
       TspColorRec(DstP^).A := TspColorRec(DstP^).A div 2;
     end;
   end;
  B.CheckingAlphaBlend;
end;


procedure DrawEffectText(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);
var
  B: TspBitmap;
  R: TRect;
  i, j: integer;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius * 2, R.Bottom + BlurRadius * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius, BlurRadius, B.Width - BlurRadius, B.Height - BlurRadius);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  Blur(B, BlurRadius);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left + ShadowDistance - BlurRadius, ARect.Top + ShadowDistance - BlurRadius);
  B.Free;
  Canvas.Brush.Style := bsClear;
  Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, Flags);
end;

procedure DrawEffectText2(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius * 2, R.Bottom + BlurRadius * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius, BlurRadius, B.Width - BlurRadius, B.Height - BlurRadius);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  R1 := R;
  OffsetRect(R1, -1, 0);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R1, Flags);
  OffsetRect(R1, 2, 0);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R1, Flags);
  OffsetRect(R1, -1, -1);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R1, Flags);
  OffsetRect(R1, 0, 2);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R1, Flags);
  Blur(B, BlurRadius);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and
        not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left + ShadowDistance - BlurRadius, ARect.Top + ShadowDistance - BlurRadius);
  B.Free;
  Canvas.Brush.Style := bsClear;
  Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, Flags);
end;

procedure DrawReflectionText(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal;
  const ReflectionOffset: integer = 1;
  const ReflectionColor: cardinal = $202020);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
  Line: PspColorArray;
  Transparency: single;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right, R.Bottom);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R, Flags or DT_CALCRECT);
  R1 := ARect;
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R1, Flags or DT_CALCRECT);
  if R.Bottom - R.Top > 0 then
    for j := 0 to B.Height - 1 do
    begin
      if (j < R.Top) or (j > R.Bottom) then
      begin
        FillChar(B.Scanline[j]^, B.Width * 4, 0);
        Continue;
      end;
      for i := 0 to B.Width - 1 do
      begin
        Transparency := 0.7 - (R.Bottom - (j - R.Top)) / (R.Bottom - R.Top);
        if Transparency < 0.05 then Transparency := 0.05;
        PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ReflectionColor) and
        not $FF000000 or
        ((Trunc(PspColorRec(B.PixelPtr[i, j]).R * Transparency) shl 24));
      end;
    end;
  GetMem(Line, B.Width * 4);
  for j := 0 to (B.Height div 2) - 1 do
  begin
    Move(B.Scanline[j]^, Line^, B.Width * 4);
    Move(B.Scanline[B.Height - 1 - j]^, B.Scanline[j]^, B.Width * 4);
    Move(Line^, B.Scanline[B.Height - 1 - j]^, B.Width * 4);
  end;
  FreeMem(Line, B.Width * 4);
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left, R1.Bottom - (B.Height - R.Bottom) + ReflectionOffset);
  B.Free;
  Canvas.Brush.Style := bsClear;
  Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, Flags);
end;

procedure DrawVistaEffectText(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal; // std text params - like DrawText
  const ShadowColor: cardinal = $202020);
var
  B: TspBitmap;
  R: TRect;
  i, j: integer;
  BlurRadius1: Integer;
begin
  BlurRadius1 := 10;
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius1 * 2, R.Bottom + BlurRadius1 * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius1, BlurRadius1, B.Width - BlurRadius1, B.Height - BlurRadius1);
  //
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 2);
  //
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 0);
  //
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, 0);
  //
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, -2);
  //
  Windows.DrawText(B.Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  //
  Blur(B, BlurRadius1);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left - BlurRadius1, ARect.Top - BlurRadius1);
  B.Free;
  Canvas.Brush.Style := bsClear;
  Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, Flags);
end;


procedure DrawVistaEffectTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowColor: cardinal = $202020);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
  BlurRadius1: Integer;
begin
  BlurRadius1 := 12;
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius1 * 2, R.Bottom + BlurRadius1 * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius1, BlurRadius1, B.Width - BlurRadius1, B.Height - BlurRadius1);
  with B.Canvas do
  begin
    Brush.Color := $FF;
    Brush.Style := bsSolid;
    R1 := R;
    Inc(R1.Top, 2);
    Dec(R1.Bottom, 2);
    Dec(R1.Left, 3);
    Inc(R1.Right, 3);
    FillRect(R1);
    Brush.Style := bsClear;
  end;
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 2);
  //
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 0);
  //
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, 0);
  //
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, -2);
  //
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  //
  Blur(B, BlurRadius1 div 2);
  Blur(B, BlurRadius1 div 2);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left - BlurRadius1, ARect.Top - BlurRadius1);
  B.Free;
  Canvas.Brush.Style := bsClear;
  SPDrawSkinText(Canvas, Text, ARect, Flags);
end;

procedure DrawVistaEffectTextW2(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowColor: cardinal = $202020);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
  BlurRadius1: Integer;
begin
  BlurRadius1 := 10;
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius1 * 2, R.Bottom + BlurRadius1 * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius1, BlurRadius1, B.Width - BlurRadius1, B.Height - BlurRadius1);
  with B.Canvas do
  begin
    Brush.Color := $FF;
    Brush.Style := bsSolid;
    R1 := R;
    Inc(R1.Top, 3);
    Dec(R1.Bottom, 3);
    Inc(R1.Left, 3);
    Dec(R1.Right, 3);
    FillRect(R1);
    Brush.Style := bsClear;
  end;
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 2);
  //
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 2, 0);
  //
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 0);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, 0);
  //
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, 1, 1);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  OffsetRect(R, -2, -2);
  //
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  //
  Blur(B, BlurRadius1 div 2);
  Blur(B, BlurRadius1 div 2);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left - BlurRadius1, ARect.Top - BlurRadius1);
  B.Free;
  Canvas.Brush.Style := bsClear;
  SPDrawSkinText(Canvas, Text, ARect, Flags);
end;


procedure DrawEffectTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);
var
  B: TspBitmap;
  R: TRect;
  i, j: integer;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius * 2, R.Bottom + BlurRadius * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius, BlurRadius, B.Width - BlurRadius, B.Height - BlurRadius);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  Blur(B, BlurRadius);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left + ShadowDistance - BlurRadius, ARect.Top + ShadowDistance - BlurRadius);
  B.Free;
  Canvas.Brush.Style := bsClear;
  SPDrawSkinText(Canvas, Text, ARect, Flags);
end;

procedure DrawEffectTextW2(const Canvas: TCanvas;
  ARect: TRect; const Text: WideString; const Flags: cardinal; // std text params - like DrawText
  const ShadowDistance: integer = 1;
  const ShadowColor: cardinal = $202020;
  const BlurRadius: integer = 1);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right + BlurRadius * 2, R.Bottom + BlurRadius * 2);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  R := Rect(BlurRadius, BlurRadius, B.Width - BlurRadius, B.Height - BlurRadius);
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  //
  R1 := R;
  OffsetRect(R1, -1, 0);
  SPDrawSkinText(B.Canvas, Text, R1, Flags);
  OffsetRect(R1, 2, 0);
  SPDrawSkinText(B.Canvas, Text, R1, Flags);
  OffsetRect(R1, -1, -1);
  SPDrawSkinText(B.Canvas, Text, R1, Flags);
  OffsetRect(R1, 0, 2);
  SPDrawSkinText(B.Canvas, Text, R1, Flags);
  Blur(B, BlurRadius);
  //
  Blur(B, BlurRadius);
  for i := 0 to B.Width - 1 do
    for j := 0 to B.Height - 1 do
    begin
      PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ShadowColor) and not $FF000000 or (PspColorRec(B.PixelPtr[i, j]).R shl 24);
    end;
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left + ShadowDistance - BlurRadius, ARect.Top + ShadowDistance - BlurRadius);
  B.Free;
  Canvas.Brush.Style := bsClear;
  SPDrawSkinText(Canvas, Text, ARect, Flags);
end;

procedure DrawReflectionTextW(const Canvas: TCanvas;
  ARect: TRect; const Text: string; const Flags: cardinal;
  const ReflectionOffset: integer = 1;
  const ReflectionColor: cardinal = $202020);
var
  B: TspBitmap;
  R, R1: TRect;
  i, j: integer;
  Line: PspColorArray;
  Transparency: single;
begin
  R := Rect(0, 0, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
  B := TspBitmap.Create;
  B.SetSize(R.Right, R.Bottom);
  B.Canvas.Font.Assign(Canvas.Font);
  B.Canvas.Font.Color := $FF; // blue
  B.Canvas.Brush.Style := bsClear;
  SPDrawSkinText(B.Canvas, Text, R, Flags);
  SPDrawSkinText(B.Canvas, Text, R, Flags or DT_CALCRECT);
  R1 := ARect;
  SPDrawSkinText(B.Canvas, Text, R1, Flags or DT_CALCRECT);
  if R.Bottom - R.Top > 0 then
    for j := 0 to B.Height - 1 do
    begin
      if (j < R.Top) or (j > R.Bottom) then
      begin
        FillChar(B.Scanline[j]^, B.Width * 4, 0);
        Continue;
      end;
      for i := 0 to B.Width - 1 do
      begin
        Transparency := 0.7 - (R.Bottom - (j - R.Top)) / (R.Bottom - R.Top);
        if Transparency < 0 then
          Transparency := 0;
        PspColorRec(B.PixelPtr[i, j]).Color := FromRGB(ReflectionColor) and
        not $FF000000 or
        ((Trunc(PspColorRec(B.PixelPtr[i, j]).R * Transparency) shl 24));
      end;
    end;
  GetMem(Line, B.Width * 4);
  for j := 0 to (B.Height div 2) - 1 do
  begin
    Move(B.Scanline[j]^, Line^, B.Width * 4);
    Move(B.Scanline[B.Height - 1 - j]^, B.Scanline[j]^, B.Width * 4);
    Move(Line^, B.Scanline[B.Height - 1 - j]^, B.Width * 4);
  end;
  FreeMem(Line, B.Width * 4);
  B.AlphaBlend := true;
  B.Draw(Canvas, ARect.Left, R1.Bottom - (B.Height - R.Bottom) + ReflectionOffset);
  B.Free;
  Canvas.Brush.Style := bsClear;
  SPDrawSkinText(Canvas, Text, ARect, Flags);
end;

var
  User32H: THandle;
  hDWMDLL: Cardinal = 0;

procedure SetupDWM;
begin
  hDWMDLL := LoadLibrary('dwmapi.dll');
  if hDWMDLL <> 0 then
  begin
    @DwmIsCompositionEnabled := GetProcAddress(hDWMDLL, 'DwmIsCompositionEnabled');
    @DwmSetWindowAttribute := GetProcAddress(hDWMDLL, 'DwmSetWindowAttribute');
    @DwmEnableBlurBehindWindow := GetProcAddress(hDWMDLL, 'DwmEnableBlurBehindWindow');
  end;
end;


function IsWindowsAero: Boolean;
var
  R: longbool;
begin
  Result := false;
  if hDWMDLL <> 0 then
  begin
    if @DwmIsCompositionEnabled <> nil then
    begin
      DwmIsCompositionEnabled(@R);
      Result := R;
    end;
  end;
end;

procedure SetDWMAnimation(AHandle: HWND; AEnabled: Boolean);
const
  DWMWA_TRANSITIONS_FORCEDISABLED = 3;
var
  b: Bool;
begin
  if hDWMDLL <> 0
  then
    begin
      b := not AEnabled;
      if @DwmSetWindowAttribute <> nil
      then
        DwmSetWindowAttribute(AHandle, DWMWA_TRANSITIONS_FORCEDISABLED, @b, sizeof(b));
    end;
end;

procedure SetBlurBehindWindow(AHandle: HWND; AEnabled: Boolean; ARGN: HRGN);
const
  DWM_BB_ENABLE = 1;
  DWM_BB_BLURREGION = 2;
var
  BlurBehind: TDWM_BLURBEHIND;
begin
  if hDWMDLL <> 0
  then
    begin
      if ARGN <> 0
      then
        BlurBehind.dwFlags := DWM_BB_ENABLE or DWM_BB_BLURREGION
      else
        BlurBehind.dwFlags := DWM_BB_ENABLE;
      BlurBehind.fTransitionOnMaximized := False;
      BlurBehind.hRgnBlur := ARGN;
      BlurBehind.fEnable := AEnabled;
      if @DwmEnableBlurBehindWindow <> nil
      then
        DwmEnableBlurBehindWindow(AHandle, @BlurBehind);
    end;
end;

initialization

  User32H := GetModuleHandle(user32);

  if User32H > 0 then
  begin
    MonitorFromWindowFunc := GetProcAddress(User32H, 'MonitorFromWindow');
    GetMonitorInfoFunc := GetProcAddress(User32H, 'GetMonitorInfoA');
    GetScrollBarInfoFunc := GetProcAddress(User32H, 'GetScrollBarInfo');
    @SetLayeredWindowAttributes := GetProcAddress(User32H, 'SetLayeredWindowAttributes');
    @UpdateLayeredWindow := GetProcAddress(User32H, 'UpdateLayeredWindow');
  end;

  SP_PlatformIsUnicode := (Win32Platform = VER_PLATFORM_WIN32_NT);

  SetupDWM;

finalization

  if User32H > 0 then FreeLibrary(User32H);

  if hDWMDLL <> 0 then FreeLibrary(hDWMDLL);

  MonitorFromWindowFunc := nil;
  GetMonitorInfoFunc := nil;
  GetScrollBarInfoFunc := nil;
end.
